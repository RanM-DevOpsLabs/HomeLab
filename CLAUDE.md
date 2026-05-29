# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal HomeLab: a collection of `docker-compose.yml` files, one per self-hosted service, plus operational notes. There is no build system, no tests, and no application source code — only declarative container definitions intended to be deployed on a home server (host user `ran-markovich`, paths under `/home/ran-markovich/...`).

## Layout

Each service lives in its own subdirectory under `docker/<service>/`. Current services:

- `n8n` — workflow automation; sibling `restore.md` documents disaster recovery (credentials/workflow JSON import via `docker exec`, gated by `N8N_ENCRYPTION_KEY`).
- `nginx-proxy-manager` — reverse proxy / TLS termination, owns ports 80/443/81.
- `ddns-updater` — dynamic DNS, web UI on 8000.
- `waha` — WhatsApp HTTP API on 3000.
- `avail-spot-finder-bot` — Telegram bot; image `available-spots-finder_bot` is built/loaded out-of-band (not from this repo).

## Working with the compose files

- Run a service: `cd docker/<service> && docker compose up -d` on the host.
- Secrets are injected via a sibling `.env` file (gitignored). Known variables referenced across files: `HOSTNAME`, `N8N_ENCRYPTION_KEY`, `BOT_TOKEN_SECRET`, `GPG_SECRET`, `WAHA_SECRET`. Never commit `.env` or substitute real values into compose files.
- Host volume paths use `${HOME}/...` (n8n, nginx-proxy-manager, waha) — substituted by Docker Compose from the env of the user running `docker compose up`. Do not switch these to literal `~/...` (Compose does not shell-expand tilde and would create a directory named `~`).
- Several compose files (`nginx-proxy-manager`, `avail-spot-finder-bot`, `waha`) are missing the top-level service name key under `services:` (the keys jump straight to `container_name`/`image`). This is a known shape in the repo; preserve it unless explicitly asked to repair, and ask before reformatting.
- `nginx-proxy-manager` owns 80/443 — any new service that wants external HTTPS should be proxied through it rather than binding 443 directly.

## n8n restore

`docker/n8n/restore.md` is the authoritative runbook for rebuilding n8n from `workflows_backup.json` + `credentials_backup.json`. The encryption key in `.env` must match the key in use when the backup was taken, or credential decryption fails. Note the file is wrapped in a stray ```` ```python ```` fence (a copy-paste artifact); the procedure itself is correct.
