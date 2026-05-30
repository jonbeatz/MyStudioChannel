---
name: local-data-operations
description: >-
  Universal local SQLite/file-tree operations — safe schema repair, backup-first
  mutations, PRAGMA inspection, and environment-relative path resolution.
  Use when querying databases, reconciling media trees, or debugging data drift.
---

# Local Data Operations (Universal)



## Path & environment resolution

- **Never hardcode** machine paths (`D:\...`, `/home/user/...`) in scripts or docs—use:
  - `process.env.DATABASE_URI` (or project-defined DB env)
  - `path.resolve(__dirname, '..')` from script location
  - `file:` URI parsing for SQLite file paths
- **File tree audits:** Use repo-relative globs; store generated assets under project-root `media/` only.
- **Tenant isolation:** Scope storage keys and server actions per user/tenant—never broaden ownership casually.

## SQLite operations (Payload / libsql / generic)

### Before any schema mutation

1. **Stop** writers (dev server, workers) touching the DB file.
2. **Backup** with a timestamped copy: `<db>.bak.<ISO-stamp>`.
3. **Clear WAL sidecars** before deploy/upload when copying DB to another host:
   - Remove `*.sqlite-wal` and `*.sqlite-shm` alongside the main file to prevent stale journal replay.

### Inspection routines

```sql
-- Table columns
PRAGMA table_info('table_name');

-- Indexes
SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'table_name';
```

In Node (libsql/sqlite client), parameterize table names safely and log with `[msc_sqlite_repair]`-style prefixes.

### Repair philosophy (from production-hardened patterns)

- **Additive only:** `ALTER TABLE ... ADD COLUMN` when missing; skip if column exists.
- **Index idempotency:** Create indexes only when absent in `sqlite_master`.
- **No row deletes** in automated repair scripts unless the operator explicitly requests pruning.
- **Exit codes:** `0` success, `1` on missing file or unrecoverable error.

### Example resolver (environment-agnostic)

```javascript
function msc_resolveSqliteFile() {
  const raw = process.env.DATABASE_URI || 'file:./data/app.sqlite';
  let rest = raw.trim().replace(/^file:/i, '');
  if (/^[A-Za-z]:[\\/]/.test(rest)) return path.normalize(rest);
  return path.resolve(process.cwd(), rest.replace(/^\/+/, ''));
}
```

## Media & URL consistency

- After bulk media imports, normalize public URLs relative to project convention (e.g. `'/media/' || filename`).
- Verify **file count parity** between local `public/media` (or `media/`) and remote before declaring deploy success.
- Do not upload a DB smaller/older than local when CMS content must match—treat size drift as a blocker.

## File-tree query checklist

1. List target directory with glob—confirm expected artifacts exist.
2. Compare checksums or sizes for critical binaries (DB, `.next` bundles) when debugging drift.
3. Log findings with structured prefixes (`[msc:audit]`)—no secrets in output.

## Operational safety matrix

| Action | Requirement |
|--------|-------------|
| Schema change | Backup + stop writers |
| DB deploy | Remove WAL/SHM + full file replace |
| Media deploy | Full tree or scripted sync—avoid partial hot patches for runtime bundles |
| Prune test users | Dedicated script + backup when deletes occur |

## When to escalate

- `datatype mismatch` / missing FK columns → run project `repair:sqlite` or equivalent after backup.
- `malformed database schema` → stop app, replace DB from known-good backup, clear WAL, restart.
- Repeated drift after deploy → suspect incomplete `.next` upload or mixed dev/prod artifacts—not code-only fixes.

## Local verification pointer

After DB or media repairs affecting a running dev server, defer HTTP checks to **Node 2** — Local Script Gate Sequence on port **3000**.


## Admin security & project relational model (`core/msc-auth-admin.ts`, `core/msc-project-actions.ts`)

### User roles & admin thresholds

| Role | Directory access | Privileged actions |
|------|------------------|-------------------|
| `user` | Own account + owned/joined projects | Standard vault read via membership |
| `admin` | Own user row only in settings cage | Create/update own projects; no full user directory |
| `master-admin` | Full user directory | Create users, assign `master-admin`, reset roles/passwords |

Helpers: `msc_canManageFullUserDirectory`, `msc_canAssignMasterAdmin`, `msc_filterUsersForAdminView`.

### Project relational fields (portable schema)

| Field | Type | Notes |
|-------|------|--------|
| `ownerUserId` / `user` | relationship → users | Tenant owner; set from session on create |
| `members` | relationship[] → users | Collaborators with read access |
| `clientRefId` / `client` | optional external id | Generic CRM link—no fixed collection slug in boilerplate |
| `manualRank` | number | Grid sort order (lower = earlier) |
| `credentials` | embedded array | label / username / password rows on project |
| `localPath` / `liveUrl` | text | Connectivity targets—env-relative, never `D:\` literals |
| `thumbnailMediaId` | relationship → media | Preferred over raw thumbnail string |

Access matrix constant: `MSC_PROJECT_ACCESS` in `msc-project-actions.ts` (`read: owner OR member`, `write: owner OR admin/master-admin`).
