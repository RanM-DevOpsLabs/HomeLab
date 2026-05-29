# ddns-updater

[qmcgaw/ddns-updater](https://github.com/qdm12/ddns-updater) — keeps dynamic DNS records pointed at the current WAN IP.

- Web UI on `8000` for IP / record status.
- Provider configuration lives in `./data/config.json` (created on first run, not in git).
- `UPDATE_COOLDOWN_PERIOD=5m`, `PUBLICIP_FETCHERS=all`, timezone `Asia/Jerusalem`.
