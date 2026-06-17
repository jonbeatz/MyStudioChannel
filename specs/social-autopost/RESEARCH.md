# Social Auto-Post — Research Summary

**Status:** Phase 0 scaffold (dry-run only; no live credentials)  
**Last updated:** 2026-06-17  
**Repo:** MyStudioChannel v9.0.0

## Goal

Enable scheduled, multi-platform creative posts (AI image + caption) to Facebook, Instagram, TikTok, X, YouTube, WordPress (optional blog), and Payload CMS (mystudiochannel.com) — credentials added later.

**Example future command:**

> At 3pm on 2026-06-18, create a creative post with generated image and caption and publish to Facebook and Instagram.

## What we already have

| Asset | Role |
|-------|------|
| `scripts/generate-image.py` | FLUX.1-schnell via Hugging Face (`HF_TOKEN`) |
| ComfyUI :8188 | Edit/upscale/inpaint |
| LiteLLM :4000 + Hermes :8642 | Caption drafting |
| TaskBoardAI :3001 + Hermes Kanban | Plan → execute workflow |
| `scripts/mem0-chat.ps1` | Local workflow memory |
| WordPress MCP | Optional separate blog |
| Payload CMS | Primary owned website |

## Gaps (before Phase 1+)

- No post queue or scheduler
- No platform OAuth connected
- No per-platform formatters (now: `scripts/social/format-caption.mjs`)
- Hermes `approvals.cron_mode: deny` — change only when scheduling live
- TikTok/IG APIs need **public media URLs** for publish

## Recommended stack

### Primary: Postiz (self-hosted)

- MIT open source: [gitroomhq/postiz-app](https://github.com/gitroomhq/postiz-app)
- Scheduler + OAuth hub + REST API for FB, IG, TikTok, X, YT, WordPress
- Install target: `D:\Hermes\postiz` (Phase 2)
- Client stub: `scripts/social/postiz-client.mjs`

### Secondary: Composio MCP

- Agent dev/testing layer for Cursor/Hermes
- Free developer tier; Meta/TikTok/YouTube/X toolkits
- Production publish → Postiz API (single queue)

### Alternatives rejected

| Option | Why not primary |
|--------|-----------------|
| Composio only | No visual calendar / durable scheduler |
| Nango | More engineering than needed solo |
| n8n only | Glue layer; Postiz node exists as optional add-on |
| Browser automation | Fragile, ToS risk |

## Platform cost notes

| Platform | Cost |
|----------|------|
| Facebook / Instagram | Free API (App Review for production) |
| YouTube | Free quota (~100 uploads/day) |
| TikTok | Free API (own OAuth app) |
| WordPress / Payload | Free |
| X (Twitter) | **Pay-per-use** ~$0.015/post (2026) — budget or defer |

## Architecture

```
TaskBoardAI / campaign YAML
  → auto-post skill / scripts/social/auto-post.mjs
  → generate-image.py + LiteLLM captions
  → format-caption.mjs (per platform)
  → [dry-run] specs/social-autopost/outbox/
  → [live] Postiz API → platforms
  → [optional] Payload / WordPress cross-post
```

## Phases

| Phase | Scope | Status |
|-------|--------|--------|
| 0 | Specs, skill, scripts (dry-run), portable module | **Current** |
| 1 | Wire FLUX + LiteLLM in auto-post pipeline | Partial (formatters + dry-run CLI) |
| 2 | Self-host Postiz + `postiz-client.mjs` | Documented + stub |
| 3 | Platform OAuth + Composio MCP | Checklist only |
| 4 | Hermes cron + TaskBoardAI `social-campaign` cards | Templates only |

## Key files

| Path | Purpose |
|------|---------|
| [PLATFORM-MATRIX.md](./PLATFORM-MATRIX.md) | Per-platform specs |
| [CREDENTIALS-CHECKLIST.md](./CREDENTIALS-CHECKLIST.md) | Env placeholders |
| [WORKFLOW.md](./WORKFLOW.md) | Operator runbook |
| [examples/dry-run-campaign.yaml](./examples/dry-run-campaign.yaml) | Sample campaign |
| `.agents/skills/auto-post/SKILL.md` | Hermes/Cursor skill |
| `scripts/social/auto-post.mjs` | CLI orchestrator |
| `.cursor/custom-scriptz/social-autopost/` | Portable module |

## References

- [Postiz docs](https://docs.postiz.com/introduction)
- [Composio toolkits](https://composio.dev/toolkits)
- `.cursor/docs/Hermes-Agent.md` — Kanban + LiteLLM stack
