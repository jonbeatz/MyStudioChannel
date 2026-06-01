# CURSOR — Install `backup-system`

## When to use

- Operator says **`install backup module`** or **`install backup-system`**
- Enabling **`backup project`** on a personal repo

## Agent procedure (install)

1. Read [module.manifest.json](module.manifest.json).
2. Run from repo root:

   ```powershell
   .\.cursor\custom-scriptz\backup-system\install.ps1
   ```

3. Merge `env.example.fragment` (installer adds `MSC_BACKUP_ROOT` comment if missing).
4. Optional: set `MSC_BACKUP_ROOT` in `.env.local`.
5. If target has `.cursor/rules/global.mdc`, merge rows from [global.mdc.fragment](global.mdc.fragment) (shortcuts + backup ritual pointer).
6. Smoke: `npm run msc:backup -- --standard install-smoke-test --yes --note "module install smoke"` (operator deletes test folder after).

## Backup ritual (`backup project`)

Follow this flow **one question at a time**. In Vader Engine, same steps live in `.cursor/rules/global.mdc`.

### Step 1 — Type

Ask: `What type of backup? (1 = Standard / 2 = Full)`

**Standard skips only** (never list includes in this step): `node_modules`, `.next`, `logs`, `test-results`

### Step 2 — Destination

**Default (always for MyStudioChannel):** `G:\Cursor_Project_BackUpz\MyStudioChannel`  
Set in `scripts/msc-backup.mjs` (`DEFAULT_BACKUP_ROOT`) and optional `MSC_BACKUP_ROOT` in `.env.local`.

Ask only if the operator might use another path: `Use default backup folder? (1 = Yes — G:\Cursor_Project_BackUpz\MyStudioChannel / 2 = Different — set MSC_BACKUP_ROOT or type path)`

If **1**, use the default root. If **2**, ask for override path and pass via env or confirm they updated `.env.local`.

### Step 3 — Folder

Scan **`G:\Cursor_Project_BackUpz\MyStudioChannel`** (or `MSC_BACKUP_ROOT`) for existing **`msc-website-v1-*`** folders; suggest the next letter (e.g. `msc-website-v1-i` → **`msc-website-v1-j`**). The script lists existing folders and computes this automatically (`npm run msc:backup` / `scripts/msc-backup.mjs`).

Ask: `Folder name? (1 = Use [suggested] / 2 = Enter custom)`

### Step 4 — Summary

Show (skips only on Type line):

```text
Backup Summary:
- Type: Standard (skips node_modules, .next, logs, test-results)
- Destination: [path]
- Folder: [name]
```

Optional: keep G: backups private. **Do not confirm yet.**

### Step 5 — Note

Ask: `Add a note about this backup? (optional — type your note, or press Enter to skip)`

### Step 6 — Confirm

Ask: `Confirm backup? (1 = Yes / 2 = No)`

### Step 7 — Run

If Yes, from repo root:

```bash
npm run msc:backup -- --standard [folder-name] --yes --note "[user note]"
```

Use `--full` when Step 1 was Full. **Omit `--note`** if the operator skipped the note.

Example:

```bash
npm run msc:backup -- --standard Vader-Engine-v1-v --yes --note "Added backup notes feature"
```

Override default only when needed: `MSC_BACKUP_ROOT` in `.env.local` (default for this repo: `G:\Cursor_Project_BackUpz\MyStudioChannel`).

### Step 8 — Report

Report backup path and `.cursor/BackUp-Notez.md` inside the backup folder.

## Report (install)

```text
✅ backup-system installed
📂 scripts/msc-backup.mjs
📦 msc:backup, msc:backup:standard, msc:backup:full
📝 BackUp-Notez.md written per backup (see README.md)
```
