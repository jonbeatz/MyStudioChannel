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

**Interactive (default):** Use **`AskQuestion`** buttons — see **`.cursor/rules/interactive-workflows.mdc`**.

**Quick (non-interactive):** Operator says **`backup quick`** / **`backup project quick`** or **`backup full`** / **`backup project full`** — agent runs the quick script immediately (**no questions, no note prompt**). See **Commands** below.

Follow the interactive flow **one question at a time** when not using quick commands.

## Commands

| Say this | Run | Behavior |
|----------|-----|----------|
| **`backup quick`** or **`backup project quick`** | `npm run msc:backup:quick` | Standard backup, auto folder name, `--yes`, no prompts |
| **`backup full`** or **`backup project full`** | `npm run msc:backup:quick:full` | Full backup, auto folder name, `--yes`, no prompts |
| **`backup project`** (interactive) | `AskQuestion` ritual → `npm run msc:backup -- …` | Full 6-step flow with optional note |

Dry-run (verify only): `npm run msc:backup:quick -- --dry-run`

---

## Interactive steps (`backup project` only)

### Step 1 — Type

**`AskQuestion` prompt:** `What type of backup?`

| Option id | Label |
|-----------|--------|
| `standard` | **Standard** — skips node_modules, .next, logs, test-results |
| `full` | **Full** — includes everything |

**Standard skips only:** `node_modules`, `.next`, `logs`, `test-results`

### Step 2 — Destination

**Default (MyStudioChannel):** `G:\Cursor_Project_BackUpz\MyStudioChannel`  
(`DEFAULT_BACKUP_ROOT` in `scripts/msc-backup.mjs`; override via `MSC_BACKUP_ROOT` in `.env.local`)

**`AskQuestion` prompt:** `Use default backup folder?`

| Option id | Label |
|-----------|--------|
| `default` | **Yes** — G:\Cursor_Project_BackUpz\MyStudioChannel |
| `custom` | **Different path** — I'll set MSC_BACKUP_ROOT or specify |

If **custom**, ask the operator for the path in chat before Step 3.

### Step 3 — Folder

Scan backup root for **`msc-website-v1-*`** folders; suggest next letter (script: `npm run msc:backup` / `scripts/msc-backup.mjs`).

**`AskQuestion` prompt:** `Folder name for this backup?`

| Option id | Label |
|-----------|--------|
| `suggested` | **Use suggested** — e.g. msc-website-v1-l |
| `custom` | **Custom name** — I'll type it next |

If **custom**, accept folder name from the operator's next message.

### Step 4 — Summary

Show summary in chat (no question yet):

```text
Backup Summary:
- Type: Standard (skips node_modules, .next, logs, test-results)
- Destination: [path]
- Folder: [name]
```

### Step 5 — Note

**`AskQuestion` prompt:** `Add a note about this backup?`

| Option id | Label |
|-----------|--------|
| `skip` | **Skip** — no note |
| `add` | **Add note** — I'll type it in my next message |

If **add**, wait for the operator's note text before Step 6.

### Step 6 — Confirm

**`AskQuestion` prompt:** `Run backup now?`

| Option id | Label |
|-----------|--------|
| `yes` | **Yes** — create backup |
| `no` | **No** — cancel |

Include the summary + note in the prompt context above the question.

### Step 7 — Run

If **Yes**, from repo root:

```bash
npm run msc:backup -- --standard [folder-name] --yes --note "[user note]"
```

Use `--full` when Step 1 was Full. **Omit `--note`** if the operator skipped the note.

### Step 8 — Report

Report backup path and `.cursor/BackUp-Notez.md` inside the backup folder.

## Report (install)

```text
✅ backup-system installed
📂 scripts/msc-backup.mjs
📦 msc:backup, msc:backup:standard, msc:backup:full, msc:backup:quick, msc:backup:quick:full
📝 BackUp-Notez.md written per backup (see README.md)
```
