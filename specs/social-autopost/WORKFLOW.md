# Social Auto-Post — Workflow Runbook

## Modes

| Mode | Flag | Behavior |
|------|------|----------|
| **Dry-run** (default) | `--dry-run` | Format captions, pick image size, write preview to `outbox/` — no API calls |
| **Live** | `--live` | Requires Postiz + platform credentials; schedules/publishes |

## Operator quick start (Phase 0)

```powershell
# From repo root
npm run social:auto-post -- --dry-run --spec specs/social-autopost/examples/dry-run-campaign.yaml
```

Output: JSON summary + files in `specs/social-autopost/outbox/<campaign-id>/`.

## Agent / Hermes flow

1. Read `.agents/skills/auto-post/SKILL.md`
2. Parse operator intent or load campaign YAML
3. Run `npm run social:auto-post -- --dry-run --spec <path>`
4. Review `outbox/` preview with operator
5. When credentials ready: `--live` + Postiz connected

## Campaign YAML schema

```yaml
id: campaign-001
topic: "Studio update"
tone: professional-friendly
scheduledAt: "2026-06-18T15:00:00-04:00"
platforms:
  - facebook
  - instagram
image:
  prompt: "NovaMira gold accent, glass bento grid, dark studio aesthetic"
  width: 1080
  height: 1080
caption:
  draft: ""  # optional; auto-generated in Phase 1 via LiteLLM
  hashtags: ["MyStudioChannel", "WebDesign"]
dryRun: true
crossPost:
  payload: false
  wordpress: false
```

## Phase progression

### Phase 0 — Scaffold (current)

- [x] Specs, formatters, dry-run CLI, skill, portable module
- [ ] Credentials: none

### Phase 1 — Content pipeline

- [ ] `auto-post.mjs` calls `generate-image.py` when `HF_TOKEN` set
- [ ] LiteLLM caption step on port 4000
- [ ] Public media URL strategy documented

### Phase 2 — Postiz

- [ ] Install at `D:\Hermes\postiz` (Docker or manual)
- [ ] Connect platforms in Postiz UI
- [ ] `postiz-client.mjs` schedule API

### Phase 3 — Credentials

- [ ] Fill `.env.local` per [CREDENTIALS-CHECKLIST.md](./CREDENTIALS-CHECKLIST.md)
- [ ] Composio MCP in Cursor for agent testing

### Phase 4 — Scheduling

- [ ] Hermes `approvals.cron_mode: allow` in `%LOCALAPPDATA%\hermes\config.yaml`
- [ ] Cron template in `specs/social-autopost/examples/hermes-cron.yaml`
- [ ] TaskBoardAI card label `social-campaign`

## Integration with MSC rituals

| Ritual | Action |
|--------|--------|
| **Start Project** | Optional: `docker compose up -d` in `D:\Hermes\postiz` |
| **End Project** | Stop Postiz if running (add port 5000 to shutdown when self-hosted) |
| **backup quick** | `specs/social-autopost/` included automatically |
| **update docs and mem0** | Log campaign system changes |

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `HF_TOKEN not found` | Add to `.env.local` or skip image gen in dry-run |
| LiteLLM unreachable | Run Start Project (`msc:google-api:start-session`) |
| IG/TikTok publish fails | Ensure public HTTPS media URL |
| X post fails | Load X API credits |
| Meta App Review pending | Use Standard Access for your own accounts only |
