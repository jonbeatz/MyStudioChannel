# MyStudioChannel - Master Command Reference

**Last Updated:** 2026-06-08 (full docs sync — sync-app, 503 webpack, folder map)
**Branch:** `MSC-Website-v6`
**Version:** `6.0.0`

---

## ⚡ Quick Aliases (Easiest to Type)

| Alias | Full Command | What it does |
|-------|--------------|--------------|
| `npm run log:session` | `npm run msc:log:session` | Log session summary |
| `npm run log:fix` | `npm run msc:log:fix` | Log a bug fix |
| `npm run log:milestone` | `npm run msc:log:milestone` | Log a milestone |
| `npm run dmd` | `npx @designmdcc/cli` | Extract design tokens |
| `npm run gh-test` | `npm run msc:test:github-api` | Test GitHub API |
| `npm run doctor` | `npm run msc:doctor` | Full health check |
| `npm run docs` | `npm run msc:docs:audit` | Audit documentation |
| `npm run sync` | `npm run msc:docs:sync` | Sync documentation |
| `npm run backup` | `npm run msc:backup:quick` | Quick backup |
| `npm run deploy` | `npm run msc:push:website:live` | Deploy code only |
| `npm run deploy:full` | `npm run msc:push:website:live -- --ftps` | Deploy code + database |

---

## 🚀 Daily Development Commands

| Command | What it does | When to use |
|---------|--------------|-------------|
| `npm run dev` | Start local dev server on port 3000 | Every coding session |
| `npm run build` | Create production build locally | Before deploying |
| `npm run lint` | Check code quality | Before committing |
| `npm run verify:local` | Test all local endpoints (/, /admin, /api) | Before pushing live |

---

## 📦 Deployment Commands

| Command | What it does | Database handled? | Time |
|---------|--------------|-------------------|------|
| Say **push it live** | Agent asks mode (Quick · FTPS · MCP) | Depends on mode | Varies |
| `npm run msc:push:db:live` | Quick DB sync to live app root | ✅ Yes | ~1–2 min |
| `npm run push:website:live` | MCP zip (code only) — **verify DB after** | ❌ Not reliable | ~5–10 min |
| `powershell -File scripts/push-website-live.ps1 -Ftps` | Full FTPS (code + DB + media) | ✅ Yes (+ `sync-db`) | ~45–60 min |
| `npm run push:website:live -- --dry-run` | Preview deploy without uploading | N/A | ~30 sec |
| `npm run deploy:zip` | Create deploy zip only | ✅ Yes (in /zips/) | ~10 sec |
| `npm run msc:hostinger:sync-db` | SSH: DB `public_html/nodejs/` → live app root | ✅ Yes | ~30 sec |
| `npm run msc:hostinger:sync-app` | SSH: code + `.next` + lockfile → app root + `npm install --ignore-scripts` | ✅ Code parity | ~1–3 min |
| `npm run msc:hostinger:npm-install` | SSH: repair `node_modules` on app root (fixes missing webpack) | N/A | ~1–2 min |
| `npm run msc:hostinger:recover` | SSH: diagnose `stderr.log`, preload, WAL, trim logs | N/A | ~30 sec |
| `npm run msc:hostinger:stop-node` | SSH: stop Node + clear WAL/SHM before DB upload | N/A | ~15 sec |
| `npm run pushit:live` | Full FTPS: build + upload + **`sync-db`** + **`sync-app`** | ✅ Yes | ~45–60 min |

### After ANY deploy:
1. Restart Node in hPanel: [https://hpanel.hostinger.com/websites/mystudiochannel.com](https://hpanel.hostinger.com/websites/mystudiochannel.com)
2. Run `npm run verify:live`

---

## 🗄️ Database Commands

| Command | What it does | Safety check |
|---------|--------------|--------------|
| `npm run db:copy` | Create clean `payload.sqlite.temp` copy | ✅ Checks if dev server is running |
| `npm run db:copy:force` | Force copy without prompts | ⚠️ Use carefully |
| `npm run db:optimize` | Run `PRAGMA optimize` and `VACUUM` on `payload.sqlite` | ✅ Checks if dev server is running |
| `npm run db:maintain` | Optimize local database then create clean copy for deploy | ✅ Safe all-in-one prep command |
| `npm run pushitup -- payload.sqlite` | Upload database via FTPS | Manual |

### SQLite field migrations (`db.push: false`)
| Command | When to run |
|---------|-------------|
| `npm run msc:migrate:sqlite:header-nav-submenu-source` | After deploy with Header **`submenuSource`** field; sets legacy **Pages** rows and renames to **Legal** |
| `npm run msc:migrate:sqlite:pages-show-in-header-nav` | After deploy with Pages **`showInHeaderNav`** field; opts MSC1 out of header nav |

### Database Safety Rules:
- ✅ Always stop `npm run dev` (`Ctrl+C`) before copying database
- ✅ Run `npm run db:copy` to create a clean temp file
- ✅ Upload `payload.sqlite.temp` then rename to `payload.sqlite` on server
- ✅ Delete WAL files (`-wal`, `-shm`) on server after upload
- ✅ Restart Node in hPanel after database changes

---

## 🔌 Connection & Diagnostic Commands

| Command | What it does | Use when |
|---------|--------------|----------|
| `npm run test:hostinger-ftp` | Test FTPS connection | FTPS not working |
| `npm run verify:ftp-smoke` | Upload/download test file | Verify FTPS write access |
| `npm run verify:live` | Smoke test all live endpoints | After deployment |
| `npm run verify:live:version` | Check footer version matches | Verify correct build |
| `npm run logs:live` | Real-time stream of server `stderr.log` via SSH | Debugging live server errors / crashes |
| `npm run logs:live:console` | Real-time stream of server `console.log` via SSH | Viewing live server application output |

### Manual Diagnostics (SSH)
```bash
ssh -p 65002 u942711528@82.180.174.36
# Then:
cd /home/u942711528/domains/mystudiochannel.com/nodejs
ls -la payload.sqlite          # Should be ~528KB
tail -20 stderr.log            # View startup errors
tail -20 console.log           # View application logs
ps aux | grep node             # Check if Node is running
```

---

## 🧹 Backup & Git Maintenance Commands

| Command | What it does | Frequency |
|---------|--------------|-----------|
| `npm run msc:backup:quick` | Non-interactive standard backup to local backup drive | Daily / before substantive changes |
| `npm run msc:backup:quick:full` | Non-interactive full backup including `node_modules` and `.next` | Weekly / major upgrades |
| `npm run backup:clean` | Retention manager: purges backups older than the 10 most recent | Monthly / as disk space requires |
| `npm run backup:clean -- --dry-run` | Preview which folders would be cleaned up | Safely preview before deleting |

### 🛡️ Git Pre-Commit Security Hook
Every time you perform a `git commit` command, Husky automatically intercepts the commit to:
1. Print a linter progress check (`npm run lint`).
2. Run code validation and format verification.
3. Prevent bad builds or runtime errors from entering the repository history.
4. Abort the commit immediately if any linting or structural issues are detected.

---

## 🔧 Recovery Commands

| Issue | Command/Action |
|-------|----------------|
| Port 3000 in use | `node scripts/kill-dev-port.mjs` or `npm run kill-port` |
| 503 error | `npm run msc:hostinger:recover` (preload) or `msc:hostinger:npm-install` (webpack in `stderr.log`) |
| Wrong footer/nav on live | `npm run msc:hostinger:sync-app` or full `pushit:live` |
| hPanel "Build failed" (MCP) | Ignore if `verify:live` passes — use `pushit:live`, not MCP |
| Database 4KB (not 528KB) | Upload correct database via FTPS or File Manager |
| WAL files causing lock | Delete `payload.sqlite-wal` and `payload.sqlite-shm` on server |
| Wrong files deployed | `FTP_REMOTE_PATH=/nodejs` + run `sync-db` + `sync-app` (FTPS lands in `public_html/nodejs/`) |
| Node not running | Restart in hPanel → Node.js → Restart |

---

## 📋 Environment Variables (hPanel)

Required in Hostinger hPanel → Node.js → Environment Variables:

| Key | Value |
|-----|-------|
| `NODE_ENV` | `production` |
| `PAYLOAD_SECRET` | (32+ char secret) |
| `DATABASE_URL` | `file:./payload.sqlite` |
| `NEXT_PUBLIC_SERVER_URL` | `https://mystudiochannel.com` |
| `PAYLOAD_PUBLIC_SERVER_URL` | `https://mystudiochannel.com` |
| `RESEND_API_KEY` | (your Resend key) |
| `PAYLOAD_DISABLE_SHARP` | `true` |

---

## 📝 Documentation & Logging Commands

| Command | What it does | When to use |
|---------|--------------|-------------|
| `npm run msc:log:fix` | Interactive bug fix logger | Immediately after resolving a bug |
| `npm run msc:log:session` | Interactive session summary logger | Before every "End Project" ritual |
| `npm run msc:docs:sync` | Audits all docs for drift | After significant documentation changes |
| `npm run msc:doctor` | Full project health check | Before starting significant work |

---

## 🎯 Quick Reference Card

Most Common Commands (Copy-Paste Ready)

```bash
# Start coding
npm run dev

# Full deploy (code + database)
npm run push:website:live -- --ftps

# Check live site
npm run verify:live

# Create safe database copy
npm run db:copy

# Test FTPS connection
npm run test:hostinger-ftp
```

### After ANY Deployment (Manual Steps)
🔄 Restart Node: [https://hpanel.hostinger.com/websites/mystudiochannel.com](https://hpanel.hostinger.com/websites/mystudiochannel.com)

✅ Run: `npm run verify:live`

🎉 Confirm site loads: [https://mystudiochannel.com](https://mystudiochannel.com)

---

## 🏆 Success Indicators

| Check | Expected result |
|-------|-----------------|
| `npm run verify:live` | 3/3 PASS (200 OK) |
| Footer version | MyStudioChannel v6.0.0 |
| `/admin` login | Works |
| Demos section | Loads with images |

---

## 📚 Related Documentation

- [START-HERE.md](./START-HERE.md) — Project entry point
- [HOSTINGER-DEPLOY.md](./HOSTINGER-DEPLOY.md) — Full deployment guide
- [DEPLOYMENT-TROUBLESHOOTING.md](./DEPLOYMENT-TROUBLESHOOTING.md) — Fix common issues
- [PREMIUM-UI-CATALOG.md](./PREMIUM-UI-CATALOG.md) — Pre-wired and copy-paste interactive components
- [Prompt-Cheat-Sheet.md](./Prompt-Cheat-Sheet.md) — Natural language commands
