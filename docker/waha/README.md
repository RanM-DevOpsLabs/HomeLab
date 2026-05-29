# waha

[WAHA](https://waha.devlike.pro/) — WhatsApp HTTP API (no-web build, pinned to `2026.4.3`).

- API on `3000`, gated by `WAHA_API_KEY` (sourced from `WAHA_SECRET` in `.env`).
- Session data persisted to `${HOME}/.waha_sessions`. Treat this directory as secret-equivalent — it contains live WhatsApp auth state.
