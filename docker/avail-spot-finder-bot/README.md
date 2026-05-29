# avail-spot-finder-bot

Telegram bot that watches for available spots and notifies a chat.

- Image `available-spots-finder_bot` is built outside this repo and must already exist locally before `docker compose up`.
- Requires `BOT_TOKEN_SECRET` (Telegram bot token) and `GPG_SECRET` in `.env`.
- No exposed ports, no persistent volumes.
