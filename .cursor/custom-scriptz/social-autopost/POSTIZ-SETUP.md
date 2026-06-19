# Postiz Self-Host Setup (Phase 2)

Install Postiz at `D:\Hermes\postiz` as the publishing hub for Facebook, Instagram, TikTok, X, YouTube, and WordPress.

## Prerequisites

- Docker Desktop (recommended) or Node.js 20+ with pnpm
- Ports: **4007** (host UI/API) — container internal **5000**; avoid conflict with MSC dev **3000**

## Option A — Docker (recommended)

```powershell
cd D:\Hermes
git clone https://github.com/gitroomhq/postiz-app.git postiz
cd postiz
docker compose up -d
```

## Option B — Manual

See [Postiz docs](https://docs.postiz.com/introduction) for pnpm install and environment variables.

## After install

1. Open Postiz UI at **`http://localhost:4007`**
2. Create account (local admin)
3. Settings → API → copy API key
4. Add to `.env.local`:

   ```env
   POSTIZ_API_URL=http://localhost:4007/api/public/v1
   POSTIZ_API_KEY=your-key-here
   ```

5. Connect platforms one-by-one in Postiz Integrations UI (OAuth)

## Verify

```powershell
npm run social:auto-post -- --dry-run --spec specs/social-autopost/examples/dry-run-campaign.yaml
# Phase 2 live test (schedule 24h out, then cancel):
npm run social:auto-post -- --live --spec specs/social-autopost/examples/dry-run-campaign.yaml
```

## Client

- `scripts/social/postiz-client.mjs` — `schedulePost()` calls Postiz REST API
- API docs: https://docs.postiz.com/public-api

## MSC rituals

- **Start Project:** optional `docker compose up -d` in `D:\Hermes\postiz` (not part of `msc:session:start`)
- **End Project:** `npm run msc:session:stop` handles Kanban + LiteLLM; stop Postiz separately if needed: `docker compose down` in `D:\Hermes\postiz`
