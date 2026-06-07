# Deployment Troubleshooting (Hostinger + MyStudioChannel)

Use this guide when live deploys fail or production behavior diverges from local.

- **Live site:** [https://mystudiochannel.com](https://mystudiochannel.com)
- **hPanel:** [https://hpanel.hostinger.com/](https://hpanel.hostinger.com/)
- **Deploy phrase (Local):** say **push it live** — agent asks mode (Quick DB · Full FTPS · MCP code-only)
- **Quick DB (Local):** `npm run msc:push:db:live` (~1–2 min)
- **Full FTPS (Local):** `powershell -File scripts/push-website-live.ps1 -Ftps`
- **MCP code-only (Local):** `npm run push:website:live` — **not a DB deploy**; verify DB after

---

## 🚨 Quick Decision Tree

Is your site down?

```text
Is your site down?
    ├── 503 error -> Check stderr.log for missing .builds/ -> Recreate preload file -> Restart Node
    ├── 500 API error -> Run msc:push:db:live (or Full FTPS + sync-db) -> Restart Node
    ├── 504 timeout -> Stop dev server -> npm run db:copy -> Re-upload with auto WAL cleanup
    └── Wrong content -> Upload local payload.sqlite with auto size verification -> Restart Node
```

---

## 1) 503 Service Unavailable / Site Down

### Symptoms
- Live site returns `503`
- Admin panel is inaccessible

### Root Causes We Found
- Node.js app crashed (including missing DB tables)
- Hostinger resource limits exceeded
- `payload.sqlite` on server was `4 KB` instead of expected `~528 KB`
- Wrong app root directory configured in hPanel

### Solutions
1. **Live (hPanel):** Node.js -> Restart app
2. Check resource usage; upgrade plan or request temporary boost if limits are hit
3. Upload correct `payload.sqlite` (expected size around `528 KB`) to `/nodejs/`
4. Confirm app root is `/nodejs` (not `/public_html`)

---

## 2) API 500 (`/api/globals/projects-home?depth=1`)

### Symptoms
- `https://mystudiochannel.com/api/globals/projects-home?depth=1` returns `500`

### Root Causes
- Missing `projects_home` table due to empty `4 KB` database
- Database not uploaded after MCP deploy
- SQLite WAL files (`payload.sqlite-wal`, `payload.sqlite-shm`) causing lock/stale state

### Solutions
1. Upload correct `payload.sqlite` (`~528 KB`) to `/nodejs/`
2. Delete `payload.sqlite-wal` and `payload.sqlite-shm`
3. Restart Node app in hPanel
4. For DB-inclusive deploys, use `npm run push:website:live -- --ftps`

---

## 3) `payload.sqlite` is 4 KB instead of ~528 KB

### Symptoms
- File Manager shows `payload.sqlite` as `4 KB` under **`/nodejs/`** (live app root)
- `/api/globals/*` returns **500** (`no such table: site_settings`)
- Site `/` and `/admin` may still return **200**

### Root Causes
- **MCP zip deploy ≠ DB deploy** — zip includes `payload.sqlite`, but server build may not apply it to the app root
- **Git-connected hPanel rebuild ≠ DB deploy** — repo has ~500 KB DB; live app can still boot a **4 KB stub**
- **FTPS** uploaded DB to **`public_html/nodejs/`** while Node reads **`domains/.../nodejs/`** (fix: `npm run msc:hostinger:sync-db`)
- Local dev server was running while DB copy was made (locked/inconsistent file)

### Solutions (fastest first)
1. **`npm run msc:push:db:live`** → Restart Node in hPanel → **`npm run msc:verify:live`**
2. Stop `npm run dev` before any DB copy (`Ctrl+C`)
3. Full parity: `powershell -File scripts/push-website-live.ps1 -Ftps` (includes `msc:hostinger:sync-db`)
4. Manual: File Manager upload to **`/nodejs/payload.sqlite`** (not `public_html` only)

---

## 4) Wrong Files Deployed / Site Shows WordPress

### Symptoms
- Live site shows WordPress theme/footer ("Designed with WordPress")

### Root Causes
- FTPS uploaded to wrong remote path (`/public_html/` instead of `/nodejs/`)
- Node app root misconfigured in hPanel

### Solutions
1. Ensure `.env.local` has `FTP_REMOTE_PATH=/nodejs`
2. Run `npm run sync:sftp-env`
3. In hPanel -> Node.js, verify Root Directory is `/nodejs`

---

## 5) Navigation Different on Live vs Local

### Symptoms
- Local has updated navigation links (example: **Legal** dropdown), live does not

### Root Causes
- Live database does not contain latest navigation/global content
- DB not synced after content changes

### Solutions
1. Upload local `payload.sqlite` to server
2. Remember navigation (Header global) is DB-driven, not just code-driven

---

## 6) 504 Gateway Timeout After Database Upload

### Symptoms
- Live site returns `504` after DB upload

### Root Causes
- DB copied while local dev server was running (lock/inconsistent copy)
- Corrupted DB file uploaded

### Solutions
1. Stop dev server before copying DB (`Ctrl+C`)
2. Use `npm run db:copy` (safe copy workflow)
3. Upload clean copy
4. Delete WAL/SHM files on server
5. Restart Node app

---

## 7) ESLint Build Failures on Hostinger

### Symptoms
- Deploy/build fails with ESLint-related install error (example: "ESLint must be installed")

### Root Causes
- Hostinger production install excludes `devDependencies`
- ESLint is commonly in `devDependencies`

### Solutions
- Set `eslint.ignoreDuringBuilds: true` in `next.config.mjs`
- Alternative (not preferred): move ESLint into `dependencies`

---

## 8) Resource Limit Exceeded

### Symptoms
- Random 503s, slow performance, intermittent downtime

### Root Causes
- Inode/file pressure from old artifacts
- Memory/CPU limits reached

### Solutions
1. Delete old deployment artifacts/zips on server
2. Remove unused files, but **NEVER delete the `.builds/` directory** (Hostinger's Node.js process manager expects `.builds/config/preload-timestamp.js` to start, and deleting it causes fatal 503 startup crashes).
3. Upgrade Hostinger plan or request temporary resource boost

---

## 9) [RESOLVED] 503 Service Unavailable - Missing Hostinger Preload File

### Symptoms
- Site returns `503 Service Temporarily Unavailable`
- Code, database, and node modules are correct, but the Node.js application is not running
- `stderr.log` shows the fatal startup crash:
  `Error: Cannot find module '/home/u942711528/domains/mystudiochannel.com/public_html/.builds/config/preload-timestamp.js'`

### Root Cause
The `.builds/` directory under `public_html` was deleted (e.g., during resource/inode cleanups to free space). Hostinger's git/process manager injects `--require` on startup expecting this file, and Node.js crashes instantly if it is missing.

### Solutions
Recreate the missing directory and preload file via SSH or Hostinger File Manager:

```bash
# Connect via SSH and run:
mkdir -p /home/u942711528/domains/mystudiochannel.com/public_html/.builds/config
touch /home/u942711528/domains/mystudiochannel.com/public_html/.builds/config/preload-timestamp.js
chmod 644 /home/u942711528/domains/mystudiochannel.com/public_html/.builds/config/preload-timestamp.js
```

Then **Stop** and **Start** (or **Restart**) the Node.js application in your Hostinger hPanel.

### Prevention
Never delete the `.builds/` directory. If you need to free space, delete other files (old deployment zips in `/nodejs/zips/` or old logs), but keep `.builds/` intact.

---

## 10) SQLite WAL Journal Locks (Now Automated via FTPS)

### Symptoms
- Database updates don't show up on live after a new deployment
- Site returns `500` or database feels locked/corrupted
- Old data reappears when the Node process restarts

### Root Cause
When Node.js is running, SQLite creates `-wal` (Write-Ahead Log) and `-shm` (Shared Memory) journal files. If you upload a fresh `payload.sqlite` file while these files exist on the server, SQLite will attempt to recover/replay the stale `-wal` logs on top of your new database, reverting your changes or causing immediate 500 crashes.

### Solutions
This is now **100% automated** on our PC-side deployment scripts!
- When you run:
  ```bash
  npm run push:website:live -- --ftps
  ```
- The deployment script automatically uploads the clean `payload.sqlite` and **instantly deletes** the remote server's `payload.sqlite-wal` and `payload.sqlite-shm` files over FTPS.
- **Manual fall-back (File Manager/SSH):** If deploying manually, you must delete `/home/u942711528/domains/mystudiochannel.com/nodejs/payload.sqlite-wal` and `/home/u942711528/domains/mystudiochannel.com/nodejs/payload.sqlite-shm` yourself before restarting the Node app.

---

## Quick Reference Commands

| Symptom | Command / Action |
|---|---|
| Site down / 503 | Check `stderr.log` for missing `.builds/` preload file. Recreate with SSH, then restart in hPanel. |
| API 500 / stub DB | `npm run msc:push:db:live` → restart → `msc:verify:live` |
| Database wrong size | `npm run db:copy` then Quick DB or Full FTPS + `msc:hostinger:sync-db` |
| Wrong files deployed | Check `FTP_REMOTE_PATH=/nodejs`, run `npm run sync:sftp-env` |
| FTPS upload issues | `npm run test:hostinger-ftp` |
| Full deploy with DB | `push-website-live.ps1 -Ftps` (WAL cleanup + `sync-db`) |
| Code-only deploy | `npm run push:website:live` (MCP) — verify DB size after |

---

## Preventive Measures

1. Before DB operations, stop local dev server (`Ctrl+C`)
2. After MCP or Git deploy, confirm DB is **~500 KB** (not **4 KB**) — MCP/Git ≠ DB deploy
3. After FTPS DB upload, run **`npm run msc:hostinger:sync-db`** (lands under `public_html/nodejs/`)
4. Keep `.env.local` correct (`FTP_REMOTE_PATH=/nodejs`)
5. Monitor Hostinger resources in hPanel regularly
6. Choose deploy method intentionally:
   - Stub DB / APIs 500 → **Quick DB** (`msc:push:db:live`)
   - Code-only changes → MCP zip (verify DB after)
   - DB/content parity required → Full FTPS + `sync-db`

---

## First Checks When Something Breaks

| Symptom | First place to check |
|---|---|
| Site down (503) | `/nodejs/stderr.log` via SSH/File Manager (look for missing `.builds/preload` module error) |
| API errors | `/nodejs/console.log` via File Manager |
| Database issues | File Manager -> `/nodejs/payload.sqlite` size |
| FTPS issues | `npm run test:hostinger-ftp` |
| Build fails | hPanel -> Deployments -> Build logs |

---

## Standard Recovery Sequence

1. Verify Node app root is `/nodejs` in hPanel
2. Check `/nodejs/stderr.log` for missing `.builds/preload` module error (recreate if missing)
3. Restart Node app
4. Validate DB size (`payload.sqlite` should be real DB size, not `4 KB`)
5. Remove WAL files when DB was replaced (`-wal`, `-shm`)
6. Re-run smoke checks:
   - `https://mystudiochannel.com/`
   - `https://mystudiochannel.com/admin`
   - `https://mystudiochannel.com/api/globals/projects-home?depth=1`

---

## Related Docs

- [HOSTINGER-DEPLOY.md](./HOSTINGER-DEPLOY.md)
- [START-HERE.md](./START-HERE.md)
- [Prompt-Cheat-Sheet.md](./Prompt-Cheat-Sheet.md)
- [DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md)

---

## Configuration Verified vs UI-Only Checks

### Script-Verifiable (Automated)

| Item | Method | Command |
|------|--------|---------|
| MCP connection | `hosting_listWebsitesV1` | Verified via MCP |
| FTPS auth | `test:hostinger-ftp` | `npm run test:hostinger-ftp` |
| SSH access | SSH connection test | Manual or script |
| File system | File Manager / SSH | `ls -la /nodejs/` |
| Live endpoints | `verify:live` | `npm run verify:live` |

### UI-Only Checks (Must Verify in hPanel)

| Item | Where to check |
|------|----------------|
| Environment variables | hPanel -> Node.js -> Environment Variables |
| Node.js app status | hPanel -> Node.js -> Dashboard |
| Resource usage | hPanel -> Hosting Plan -> Resources |
| FTP password | hPanel -> FTP Accounts |

**Note:** MCP/SSH checks cannot expose hPanel environment variables. Always visually confirm env vars in hPanel UI after deployment.
