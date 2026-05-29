# nginx-proxy-manager

[Nginx Proxy Manager](https://nginxproxymanager.com/) — reverse proxy with a web UI for managing hosts and Let's Encrypt certificates. The single entry point for all HTTPS traffic into the lab.

- `80` / `443` — public HTTP / HTTPS
- `81` — admin UI
- Data: `${HOME}/npm/data`
- Certs: `${HOME}/npm/letsencrypt`

No `.env` required.
