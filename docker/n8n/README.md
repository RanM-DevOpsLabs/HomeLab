# n8n

Self-hosted [n8n](https://n8n.io/) workflow automation.

- Exposes 5678; intended to sit behind `nginx-proxy-manager` on `https://${HOSTNAME}`.
- Workflow + credential data persisted to `${HOME}/n8n_data`.
- Requires `HOSTNAME` and `N8N_ENCRYPTION_KEY` in `.env`. The encryption key is mandatory for restoring credentials from a backup.

## Restore from backup

See [`restore.md`](restore.md).
