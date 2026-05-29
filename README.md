# HomeLab

Docker Compose definitions for the self-hosted services running on my home server. One folder per service under `docker/`. There is no build step — each service is deployed independently with `docker compose up -d` from its own directory.

## Services

| Service | Purpose | Ports |
|---|---|---|
| [n8n](docker/n8n) | Workflow automation | 5678 (behind reverse proxy on 443) |
| [nginx-proxy-manager](docker/nginx-proxy-manager) | Reverse proxy + TLS termination | 80, 443, 81 (admin) |
| [ddns-updater](docker/ddns-updater) | Keeps dynamic DNS records in sync with the WAN IP | 8000 |
| [waha](docker/waha) | WhatsApp HTTP API | 3000 |
| [avail-spot-finder-bot](docker/avail-spot-finder-bot) | Telegram bot (image built out-of-band) | — |

## Conventions

- Secrets live in a `.env` file next to each `docker-compose.yml` and are gitignored. Variables used: `HOSTNAME`, `N8N_ENCRYPTION_KEY`, `BOT_TOKEN_SECRET`, `GPG_SECRET`, `WAHA_SECRET`.
- Persistent data is bind-mounted under the host user's home directory (`${HOME}/...`).
- External HTTPS goes through `nginx-proxy-manager`; other services should not bind 443 directly.

## Deploy a service

```bash
cd docker/<service>
docker compose up -d
```

## Disaster recovery

n8n credentials are encrypted with `N8N_ENCRYPTION_KEY` — back up that key alongside the workflow/credential JSON exports. Full restore procedure: [`docker/n8n/restore.md`](docker/n8n/restore.md).
