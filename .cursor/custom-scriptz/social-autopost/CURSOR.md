# CURSOR — Install `social-autopost`

## When to use

- Operator wants multi-platform social auto-post **scaffold** (dry-run)
- Setting up Postiz + Composio for future scheduled campaigns

## Agent procedure (install)

1. Read [module.manifest.json](module.manifest.json).
2. Run from repo root:

   ```powershell
   .\.cursor\custom-scriptz\social-autopost\install.ps1
   ```

3. Merge `env.example.fragment` (Postiz/Composio placeholders).
4. Smoke:

   ```powershell
   npm run social:auto-post -- --dry-run --spec specs/social-autopost/examples/dry-run-campaign.yaml
   ```

## Auto-post skill

- Path: `.agents/skills/auto-post/SKILL.md`
- Triggers: "auto-post", "create campaign post", "schedule social post"
- **Default:** `--dry-run` — never `--live` without operator confirmation

## Commands

| Say / run | Command |
|-----------|---------|
| Dry-run preview | `npm run social:auto-post -- --dry-run --spec <yaml>` |
| Format caption | `npm run social:format-caption -- --platform instagram --text "..."` |
| Live (Phase 2+) | `npm run social:auto-post -- --live --spec <yaml>` |

## Phase guides

- [POSTIZ-SETUP.md](POSTIZ-SETUP.md) — self-host at `D:\Hermes\postiz`
- [COMPOSIO-MCP.md](COMPOSIO-MCP.md) — Cursor MCP for agent testing
- [SCHEDULING.md](SCHEDULING.md) — Hermes cron + TaskBoardAI cards

## Security

- Never commit `.env.local` or platform tokens
- Connect OAuth only via Postiz UI or official developer consoles
