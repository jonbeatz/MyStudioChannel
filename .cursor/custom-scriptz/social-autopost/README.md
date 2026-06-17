# Social Auto-Post Module

Portable scaffold for multi-platform social scheduling (dry-run first).

## Install

```powershell
.\.cursor\custom-scriptz\social-autopost\install.ps1
```

## Verify

```powershell
npm run social:auto-post -- --dry-run --spec specs/social-autopost/examples/dry-run-campaign.yaml
```

## What it copies

- `scripts/social/*.mjs` — auto-post, format-caption, postiz-client
- `specs/social-autopost/` — docs and examples
- `.agents/skills/auto-post/SKILL.md` — Hermes/Cursor skill
- npm scripts via `package-scripts.json`
- `.env.example` fragments for Postiz/Composio keys

## Phases

| Phase | Action |
|-------|--------|
| 0 | Dry-run CLI (now) |
| 2 | Self-host Postiz at `D:\Hermes\postiz` — see [POSTIZ-SETUP.md](POSTIZ-SETUP.md) |
| 3 | Connect platforms + Composio MCP — see [COMPOSIO-MCP.md](COMPOSIO-MCP.md) |
| 4 | Hermes cron + TaskBoardAI — see [SCHEDULING.md](SCHEDULING.md) |

## Docs

- Repo: `specs/social-autopost/`
- Agent: [CURSOR.md](CURSOR.md)
