#!/usr/bin/env python3
"""luna-haircut-finder.

Polls the Luna salon booking API (dibs-app) on an interval and sends a Telegram
message when an *earlier* appointment slot opens up. State is persisted so the bot
stays quiet unless the earliest available slot actually moves closer.
"""

import json
import logging
import os
import sys
import tempfile
import time
from datetime import date, datetime
from zoneinfo import ZoneInfo

import requests

# --- Config (read from env; sensible defaults for everything but the secrets) ---
BOT_TOKEN = os.environ.get("LUNA_BOT_TOKEN", "")
CHAT_ID = os.environ.get("LUNA_CHAT_ID", "")
POLL_INTERVAL = int(os.environ.get("LUNA_POLL_INTERVAL", "3600"))
BUSINESS_ID = os.environ.get("LUNA_BUSINESS_ID", "62d96ea8ead1f7324846e599")
SERVICE_IDS = [
    s.strip()
    for s in os.environ.get("LUNA_SERVICE_IDS", "6728cb964f31bc1892c9936e").split(",")
    if s.strip()
]
SPOTS_TO_SHOW = int(os.environ.get("LUNA_SPOTS_TO_SHOW", "3"))
STATE_FILE = os.environ.get("LUNA_STATE_FILE", "/data/state.json")

_threshold_raw = os.environ.get("LUNA_THRESHOLD_DATE", "").strip()
THRESHOLD_DATE = date.fromisoformat(_threshold_raw) if _threshold_raw else None

TZ_IL = ZoneInfo("Asia/Jerusalem")

API_URL = "https://rest-api.dibs-app.com/appointments/availability"
HEADERS = {
    "accept": "application/json, text/plain, */*",
    "accept-language": "en-US,en;q=0.9",
    "app-platform": "web",
    "app-version": "2.0.0",
    "content-type": "application/json",
    "origin": "https://customers.dibs-app.com",
    "referer": "https://customers.dibs-app.com/",
    "x-lang": "he",
    "user-agent": (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"
    ),
}

logging.basicConfig(
    level=logging.INFO,
    stream=sys.stdout,
    format="%(asctime)s %(levelname)s %(message)s",
)
log = logging.getLogger("luna")


# --- API ---
def fetch_slots(session):
    """POST the availability query and return the parsed list of slot objects."""
    body = {"businessId": BUSINESS_ID, "isEvent": False, "servicesIds": SERVICE_IDS}
    resp = session.post(API_URL, json=body, headers=HEADERS, timeout=30)
    if resp.status_code not in (200, 201):  # the API returns 201 on success
        raise RuntimeError(f"availability returned {resp.status_code}: {resp.text[:200]}")
    data = resp.json()
    if not isinstance(data, list):
        raise RuntimeError(f"expected a JSON array, got {type(data).__name__}")
    return data


# --- Parsing / filtering ---
def parse_start(slot):
    """'2026-08-31T10:30:00.000Z' -> aware UTC datetime."""
    return datetime.fromisoformat(slot["startTime"].replace("Z", "+00:00"))


def available_slots(slots):
    """Free slots (occupiedSlot is False), chronological, within the threshold date."""
    out = []
    for s in slots:
        if s.get("occupiedSlot") is not False:  # only an explicit False counts as free
            continue
        try:
            start = parse_start(s)
        except (KeyError, ValueError):
            continue
        if THRESHOLD_DATE and start.astimezone(TZ_IL).date() > THRESHOLD_DATE:
            continue
        out.append((start, s))
    out.sort(key=lambda t: t[0])  # defensive — the API already returns these in order
    return out


def provider_name(slot):
    try:
        user = slot["providers"][0]["userDetails"]["user"]
        name = f"{user.get('firstName', '')} {user.get('lastName', '')}".strip()
        return name or "?"
    except (KeyError, IndexError, TypeError):
        return "?"


def format_message(avail):
    lines = ["\U0001f487 Luna — earlier appointment available!"]
    for start, slot in avail[:SPOTS_TO_SHOW]:
        local = start.astimezone(TZ_IL)
        lines.append(f"• {local:%a %d %b %Y, %H:%M} — {provider_name(slot)}")
    return "\n".join(lines)


# --- State (dedup watermark) ---
def load_state(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {}


def save_state(path, state):
    """Atomic write so a crash mid-write can't corrupt the state file."""
    directory = os.path.dirname(path) or "."
    os.makedirs(directory, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=directory)
    try:
        with os.fdopen(fd, "w") as f:
            json.dump(state, f)
        os.replace(tmp, path)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise


def should_notify(prev_iso, new_earliest):
    """Notify on the first-ever slot, or when the earliest free slot moves earlier."""
    if prev_iso is None:
        return True
    return new_earliest < datetime.fromisoformat(prev_iso)


# --- Telegram ---
def send_telegram(text):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    resp = requests.post(url, json={"chat_id": CHAT_ID, "text": text}, timeout=30)
    if not resp.ok:
        raise RuntimeError(f"telegram sendMessage {resp.status_code}: {resp.text[:200]}")


# --- One poll cycle ---
def run_cycle(session, state_path):
    log.info("polling availability...")
    state = load_state(state_path)
    avail = available_slots(fetch_slots(session))
    log.info("fetched %d available slot(s)", len(avail))

    if not avail:
        if state.get("earliest") is not None:
            save_state(state_path, {"earliest": None})  # cleared so a reopening re-alerts
        log.info("no available slots")
        return

    new_earliest = avail[0][0]
    if should_notify(state.get("earliest"), new_earliest):
        send_telegram(format_message(avail))
        log.info("notified; earliest now %s", new_earliest.isoformat())
    else:
        log.info("no earlier slot (earliest still %s)", state.get("earliest"))

    # Always update the watermark — including when it slips later — so that a slot
    # returning to a previously-seen time re-triggers an alert.
    save_state(state_path, {"earliest": new_earliest.isoformat()})


def main():
    if not BOT_TOKEN or not CHAT_ID:
        log.error("LUNA_BOT_TOKEN and LUNA_CHAT_ID are required")
        sys.exit(1)

    session = requests.Session()
    log.info(
        "luna-haircut-finder started; interval=%ss businessId=%s services=%s threshold=%s",
        POLL_INTERVAL,
        BUSINESS_ID,
        SERVICE_IDS,
        THRESHOLD_DATE,
    )
    while True:
        try:
            run_cycle(session, STATE_FILE)
        except Exception:  # noqa: BLE001 — a transient hiccup must not kill the loop
            log.exception("cycle failed; will retry next interval")
        time.sleep(POLL_INTERVAL)


if __name__ == "__main__":
    main()
