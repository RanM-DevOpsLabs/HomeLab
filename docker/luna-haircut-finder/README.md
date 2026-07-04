# luna-haircut-finder

Telegram bot that polls the Luna salon booking API (dibs-app) on an interval
(hourly by default) and messages a chat **when an earlier appointment slot opens
up** — a cancellation watcher.

- **Built in-repo** (unlike `avail-spot-finder-bot`): source under `app/`, image
  built by `docker compose up -d --build`.
- Outbound-only — no exposed ports. Talks to the dibs-app API and Telegram.
- Requires `LUNA_BOT_TOKEN` and `LUNA_CHAT_ID` in `.env`. Optional tuning vars are
  documented in `.env.example` (poll interval, businessId/serviceIds, threshold
  date, spots to show).
- Dedup state is persisted to the `luna-data` Docker volume (`/data/state.json`
  inside the container); an alert fires only when the earliest free slot gets
  earlier, so there's no hourly spam.
- Times are displayed in `Asia/Jerusalem`.

The container runs as a non-root user, so state uses a **named volume** rather than
a `${HOME}` bind mount — Docker gives a fresh named volume the image's `/data`
ownership, so no host-side `chown` is needed.

## Run

```bash
cp .env.example .env   # fill in LUNA_BOT_TOKEN + LUNA_CHAT_ID
docker compose up -d --build
docker compose logs -f luna-haircut-finder
```

## Inspect / reset state

```bash
docker compose exec luna-haircut-finder cat /data/state.json   # current watermark
docker compose down && docker volume rm luna-haircut-finder_luna-data  # force a re-alert
```
