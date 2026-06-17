# Credentials Checklist — Social Auto-Post

**Do not commit secrets.** Add values to `.env.local` only when ready for each phase.

## Phase 0 (now)

No credentials required. All commands use `--dry-run` by default.

## Already configured (MSC)

| Key | Purpose | Status |
|-----|---------|--------|
| `HF_TOKEN` | FLUX image generation | Add when generating images |
| `MEM0_API_KEY` | Cloud Mem0 CLI | Optional |
| `MSC_LITELLM_MASTER_KEY` | LiteLLM caption drafting | Start Project |
| `WORDPRESS_*` | WP MCP (optional blog) | If using local WP |

## Phase 2 — Postiz self-host

| Key | Example | Notes |
|-----|---------|-------|
| `POSTIZ_API_URL` | `http://localhost:5000/api` | Self-hosted API base |
| `POSTIZ_API_KEY` | From Postiz Settings → API | After install |

## Phase 3 — Composio (agent testing)

| Key | Notes |
|-----|-------|
| `COMPOSIO_API_KEY` | [Composio dashboard](https://app.composio.dev) — free tier |

## Phase 3 — Platform OAuth (via Postiz UI or own apps)

### Meta (Facebook + Instagram)

| Key | Notes |
|-----|-------|
| `META_APP_ID` | [developers.facebook.com](https://developers.facebook.com) |
| `META_APP_SECRET` | Business app; IG Professional linked to FB Page |

**Prerequisites:** Facebook Page, Instagram Business/Creator account linked to Page.

### TikTok

| Key | Notes |
|-----|-------|
| `TIKTOK_CLIENT_KEY` | [developers.tiktok.com](https://developers.tiktok.com) |
| `TIKTOK_CLIENT_SECRET` | Content Posting API enabled |

### YouTube

| Key | Notes |
|-----|-------|
| Google OAuth client | Reuse GCP project `wordpress-map-1492461083797` or new project |
| YouTube Data API v3 | Enabled in Google Cloud Console |

### X (Twitter) — paid

| Key | Notes |
|-----|-------|
| `X_API_KEY` | Developer portal — load credits first |
| `X_API_SECRET` | |
| `X_ACCESS_TOKEN` | OAuth 1.0a user context |
| `X_ACCESS_SECRET` | |

**Budget:** ~$0.015 per text post; ~$0.20 if post contains external link.

### WordPress (optional blog)

| Key | Notes |
|-----|-------|
| `WORDPRESS_SITE_URL` | e.g. `https://blog.example.com` |
| `WORDPRESS_APP_PASSWORD` | Users → Application Passwords |

## Verification commands (after credentials added)

```powershell
# Dry-run (always safe)
npm run social:auto-post -- --dry-run --spec specs/social-autopost/examples/dry-run-campaign.yaml

# Postiz health (Phase 2+)
curl http://localhost:5000/api/health

# Composio (Phase 3+)
composio whoami
```

## Security

- Never paste secrets in chat or commit `.env.local`
- Use Postiz hosted OAuth flows in UI — do not store user passwords in repo
- Rotate keys if exposed
