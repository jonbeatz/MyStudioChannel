# Deployment Troubleshooting (Hostinger + MyStudioChannel)

Use this guide when live deploys fail or production behavior diverges from local.

- **Live site:** [https://mystudiochannel.com](https://mystudiochannel.com)
- **hPanel:** [https://hpanel.hostinger.com/](https://hpanel.hostinger.com/)
- **Primary deploy ritual (Local):** `npm run push:website:live`
- **FTPS fallback (Local):** `npm run push:website:live -- --ftps`

---

## 🚨 Quick Decision Tree

Is your site down?

```text
Is your site down?
    ├── 503 error -> Check stderr.log for missing .builds/ -> Recreate preload file -> Restart Node
    ├── 500 API error -> Upload DB -> Delete WAL files -> Restart
    ├── 504 timeout -> Stop dev server -> npm run db:copy -> Re-upload
    └── Wrong content -> Upload local payload.sqlite -> Restart
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
- File Manager shows `payload.sqlite` as `4 KB`
- Site data is missing or defaults appear unexpectedly

### Root Causes
- MCP zip deploy can leave/create a fresh empty DB if real DB is not carried over correctly
- Database not included or not applied after deployment
- Local dev server was running while DB copy was made (locked/inconsistent file)

### Solutions
1. Stop `npm run dev` before copying DB (`Ctrl+C`)
2. Run `npm run db:copy` to create safe `payload.sqlite.temp`
3. Upload DB copy via File Manager after MCP deploy when needed
4. Use `npm run push:website:live -- --ftps` for full parity deploys

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
- Local has updated navigation links (example: "Pages"), live does not

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

## 9) 503 Service Unavailable - Missing Hostinger Preload File

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

## Quick Reference Commands

| Symptom | Command / Action |
|---|---|
| Site down / 503 | Check `stderr.log` for missing `.builds/` preload file. Recreate with SSH, then restart in hPanel. |
| API 500 | Upload DB, delete WAL files, restart |
| Database wrong size | `npm run db:copy`, then upload `payload.sqlite.temp` |
| Wrong files deployed | Check `FTP_REMOTE_PATH=/nodejs`, run `npm run sync:sftp-env` |
| FTPS upload issues | `npm run test:hostinger-ftp` |
| Full deploy with DB | `npm run push:website:live -- --ftps` |
| Code-only deploy | `npm run push:website:live` |

---

## Preventive Measures

1. Before DB operations, stop local dev server (`Ctrl+C`)
2. After MCP deploy, confirm DB state (manual upload if needed) or use FTPS path
3. Keep `.env.local` correct (`FTP_REMOTE_PATH=/nodejs`)
4. Monitor Hostinger resources in hPanel regularly
5. Choose deploy method intentionally:
   - Code-only changes -> MCP zip
   - DB/content parity required -> FTPS or manual DB upload

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
