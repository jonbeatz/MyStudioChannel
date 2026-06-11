# hostinger-setup (portable)

Drop-in **Hostinger deploy stack** from MyStudioChannel: tiered FTPS, SSH sync, Quick DB, pitfalls docs, Cursor rules, and agent prompts.

## Quick install

```powershell
.\.cursor\custom-scriptz\hostinger-setup\install.ps1
```

## What you get

- **26+ scripts** — `PushItUP`, `pushit:live:fast`, `msc:hostinger:*`, verify/smoke
- **`package.json` aliases** — `pushit:live:fast`, `deploy`, `msc:push:db:live`, etc.
- **`.env.example` keys** — FTP, SSH, `HOSTINGER_APP_ROOT`, API token
- **Cursor rules** — deploy safety + hPanel operator labels
- **Docs** — `HOSTINGER-MODULE.md`, `PITFALLS-HOSTINGER.md`, `NEW-PROJECT-CHECKLIST.md`
- **Prompt** — `Push-Website-Live.md` (AskQuestion deploy modes)

## Copy to another project

1. Robocopy `.cursor/custom-scriptz/hostinger-setup/` (or entire `custom-scriptz/`)
2. Run `install.ps1` from new repo root
3. Fill `.env.local` · customize domain in verify scripts if needed
4. `npm run msc:test:hostinger-ftp`

## Agent entry

[CURSOR.md](CURSOR.md) · [module.manifest.json](module.manifest.json)

## Refresh module (MyStudioChannel maintainer)

After changing deploy scripts in `scripts/`:

```powershell
npm run msc:hostinger:module:sync
```

## Source of truth (MyStudioChannel)

Full site-specific docs remain in the parent repo:

- `.cursor/docs/HOSTINGER-DEPLOY.md`
- `.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md`

This module is the **portable extract** — update it when those docs or scripts change materially.
