# 🔧 Self-Hosted n8n Made Easy (with Ngrok + Docker)

This repo helps you **instantly run your own local n8n automation server** with:

- Docker
- Ngrok (for HTTPS webhook access)
- Just two scripts: `run.sh` and `stop.sh`

Perfect for personal workflows, Telegram bots, Notion integrations, or just exploring automation — without dealing with complicated setups or domains.

---

## What You Get

- Fully working [n8n.io](https://n8n.io) instance
- Secure public webhook URL (via Ngrok)
- Easily restartable with persistent data
- Auto-configured `WEBHOOK_URL` for triggers to work (e.g., Telegram)
- Scripts to start & stop everything smoothly

---

## Why Ngrok?

Most services (like Telegram, Notion, etc.) require your webhook to be on **HTTPS** and **publicly accessible** (as opposed to localhost **HTTP**)

Instead of buying a domain, setting up SSL, or deploying to a VPS — this setup uses **[Ngrok](https://ngrok.com)** to expose your local server securely in seconds.

No nonsense. Just start and build automations.

## Prerequisites

Make sure you have:

- [Docker](https://docs.docker.com/get-docker/)
- [Ngrok](https://ngrok.com/download)
- `jq` (for parsing JSON; install via `brew install jq` on macOS)

## How to Use

### Start n8n + Ngrok:

```bash
./run.sh
```

- Launches ngrok on port 5678
- Fetches the HTTPS URL
- Writes it into .env
- Starts n8n via Docker
