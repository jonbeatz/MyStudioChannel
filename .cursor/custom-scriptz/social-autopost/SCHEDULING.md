# Scheduling — Hermes Cron + TaskBoardAI (Phase 4)

## Hermes cron

**Prerequisite:** Change `approvals.cron_mode` from `deny` to `allow` (or `manual`) in `%LOCALAPPDATA%\hermes\config.yaml`.

Template: `specs/social-autopost/examples/hermes-cron.yaml`

```yaml
name: social-campaign-msc-demo
schedule: "2026-06-18T15:00:00-04:00"
timezone: America/New_York
command: |
  cd D:\Cursor_Projectz\MyStudioChannel && npm run social:auto-post -- --live --spec specs/social-autopost/outbox/msc-demo-fb-ig-2026-06-18/campaign.yaml
notify: telegram
```

Create cron via Hermes CLI when ready:

```powershell
hermes cron create --name "MSC social demo" --at "2026-06-18T15:00:00-04:00" --command "npm run social:auto-post -- --live --spec ..."
```

**Fallback:** Postiz native scheduler if Hermes cron stays denied.

## TaskBoardAI cards

Board: `.cursor/boards/msc-website-v9.json`

Create cards with:

- **Label:** `social-campaign`
- **Title:** e.g. `FB+IG post — hero refresh`
- **Description:** Link to campaign YAML path + `scheduledAt`
- **Checklist:** image prompt, platforms, dry-run preview, operator approve live

### Promote to Hermes Kanban

```powershell
hermes kanban create "Social: FB+IG hero refresh" --body "Run npm run social:auto-post -- --live --spec specs/..." --assignee msc --workspace "dir:D:\Cursor_Projectz\MyStudioChannel"
```

## Operator approval gate

Before any `--live` run:

1. Dry-run preview reviewed
2. Postiz platforms connected
3. Operator says "approve live post"

## Telegram optional notify

Use `TELEGRAM_HOME_CHANNEL` in Hermes `.env` for cron completion summaries (existing gateway).
