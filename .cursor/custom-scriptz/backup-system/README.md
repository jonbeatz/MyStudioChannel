# backup-system (portable module)

Robocopy-based **Standard** and **Full** project backups to a configurable drive (`MSC_BACKUP_ROOT`).

## Standard skips

`node_modules`, `.next`, `logs`, `test-results`

Summaries should list **skips only** — do not add “includes `.env.local`” or `BackUp-Notez.md` in the type/summary lines. Keep G: backups private.

## Install

```powershell
.\.cursor\custom-scriptz\backup-system\install.ps1
.\.cursor\custom-scriptz\backup-system\install.ps1 -WhatIf
```

Uses shared `_lib/Msc-ModuleInstall.ps1`. Pulls `msc-load-env` from `google-api-proxy/prerequisites/` if missing.

## Commands

| Command | Action |
|---------|--------|
| `npm run msc:backup` | Standard backup (interactive) |
| `npm run msc:backup:standard` | Same |
| `npm run msc:backup:full` | Full mirror (no directory skips) |
| `npm run msc:backup -- --standard <folder> --yes` | Non-interactive Standard |
| `npm run msc:backup -- --standard <folder> --yes --note "why"` | Non-interactive + backup note |

Chat (Vader or after merging `global.mdc.fragment`): **`backup project`**

## Script flow (direct `npm run msc:backup`)

1. Backup drive/folder (default `G:\Cursor_Project_BackUpz\MyStudioChannel`, or `MSC_BACKUP_ROOT`)
2. Folder name — **`msc-website-v1-a`** … **`msc-website-v1-z`** (next letter auto-suggested from existing folders), or CLI arg / custom name
3. Confirm (interactive only)
4. Optional note prompt (interactive only; use `--note` when using `--yes`)
5. Robocopy, then write `.cursor/BackUp-Notez.md`

## Agent flow (`backup project` — one question at a time)

See [CURSOR.md](CURSOR.md) § Backup ritual (matches Vader `global.mdc`):

1. Type · 2. Destination · 3. Folder · 4. Summary · 5. Note · 6. Confirm · 7. Run with `--yes --note "..."`

## Backup Notes

Each backup writes **`.cursor/BackUp-Notez.md`** inside the backup folder **after** robocopy:

- Optional **My Notes** at top (prompt or `--note`)
- Git branch, commit, message
- Type, **Excluded** dirs, **Included (secrets)** row (`.env.local` for Standard)
- **Timestamp** — local machine time (not UTC)
- **Footer** — `*Backup created — includes source code, config, and portable modules.*`

New entries **prepend** (newest first). Re-backup to the same folder preserves prior note history.

## Env

| Key | Default |
|-----|---------|
| `MSC_BACKUP_ROOT` | `G:\Cursor_Project_BackUpz\MyStudioChannel` (prompt default; set in `.env.local` to skip location prompt) |

## After restore (Standard)

1. robocopy backup → project folder  
2. `npm install` (+ `--prefix` for workspaces you use)  
3. Run project smoke/gate if defined  

Manifest: [module.manifest.json](module.manifest.json) · Agent: [CURSOR.md](CURSOR.md)
