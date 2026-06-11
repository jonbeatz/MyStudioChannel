# MyStudioChannel - Master Command Reference

**Last Updated:** 2026-06-11 (`MSC-Website-v8` branch cut @ `b4ab8ae`)
**Branch:** `MSC-Website-v8` (active @ `b4ab8ae`) · `MSC-Website-v7` frozen @ `b4ab8ae` · `main` @ `b4ab8ae` · `MSC-Website-v6` frozen @ `c9e260e`
**Version:** `7.0.0`

---

## ⚡ Quick Aliases (Easiest to Type)

| Alias | Full Command | What it does |
|-------|--------------|--------------|
| `npm run log:session` | `npm run msc:log:session` | Log session summary |
| `npm run log:fix` | `npm run msc:log:fix` | Log a bug fix |
| `npm run log:milestone` | `npm run msc:log:milestone` | Log a milestone |
| `npm run msc:docs:audit` | `npx @designmdcc/cli` | Extract design tokens |
| `npm run msc:test:github-api` | `npm run msc:test:github-api` | Test GitHub API |
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
| `npm run msc:verify:local` / `verify:local` | HTTP smoke + Playwright (`/`, `/admin`, APIs) | Before pushing live |
| `npm run test:smoke` | Playwright smoke only (dev server on **3000**) | After local changes |
| `npm run verify:next:safe` | Production build gate (frees port **3000** first) | After runtime code edits |
| `npm run analyze` | `@next/bundle-analyzer` — writes `.next/analyze/client.html` | Admin bundle inspection |

**GitHub CI:** push to **`MSC-Website-v7`** or **`main`** runs `.github/workflows/verify.yml` (`verify:next:safe` + Playwright).

---

## 📦 Deployment Commands

> **For deploy methods, see [HOSTINGER-DEPLOY.md#deploy-methods-quick-decision-tree](./HOSTINGER-DEPLOY.md#deploy-methods-quick-decision-tree)**

### Hostinger SSH helpers

| Command | What it does | Time |
|---------|--------------|------|
| `npm run msc:hostinger:sync-db` | SSH: DB `public_html/nodejs/` → live app root | ~30 sec |
| `npm run msc:hostinger:sync-app` | SSH: code + `.next` + lockfile → app root + `npm install --ignore-scripts` | ~1–3 min |
| `npm run msc:hostinger:npm-install` | SSH: repair `node_modules` on app root (fixes missing webpack) | ~1–2 min |
| `npm run msc:hostinger:recover` | SSH: diagnose `stderr.log`, preload, WAL, trim logs | ~30 sec |
| `npm run msc:hostinger:stop-node` | SSH: stop Node + clear WAL/SHM before DB upload | ~15 sec |
| `npm run msc:hostinger:unzip-deploy-next` | SSH: unzip `deploy-next.zip` on staging, verify **BUILD_ID**, remove zip | ~15 sec |
| `npm run msc:hostinger:deploy-diagnose` | SSH: read-only preflight (disk, zip, BUILD_ID, `package.json` version) | ~15 sec |

### After ANY deploy:
1. Restart Node in hPanel: [https://hpanel.hostinger.com/websites/mystudiochannel.com](https://hpanel.hostinger.com/websites/mystudiochannel.com)
2. Run `npm run msc:verify:live`

---

## 🗄️ Database Commands

| Command | What it does | Safety check |
|---------|--------------|--------------|
| `npm run msc:db:copy` | Create clean `payload.sqlite.temp` copy | ✅ Checks if dev server is running |
| `npm run msc:db:copy:force` | Force copy without prompts | ⚠️ Use carefully |
| `npm run msc:db:optimize` | Run `PRAGMA optimize` and `VACUUM` on `payload.sqlite` | ✅ Checks if dev server is running |
| `npm run msc:db:maintain` | Optimize local database then create clean copy for deploy | ✅ Safe all-in-one prep command |
| `npm run pushitup -- payload.sqlite` | Upload database via FTPS | Manual |

### SQLite field migrations (`db.push: false`)
| Command | When to run |
|---------|-------------|
| `npm run msc:migrate:sqlite:header-nav-submenu-source` | After deploy with Header **`submenuSource`** field; sets legacy **Pages** rows and renames to **Legal** |
| `npm run msc:migrate:sqlite:pages-show-in-header-nav` | After deploy with Pages **`showInHeaderNav`** field; opts MSC1 out of header nav |

### Database Safety Rules:
- ✅ Always stop `npm run dev` (`Ctrl+C`) before copying database
- ✅ Run `npm run msc:db:copy` to create a clean temp file
- ✅ Upload `payload.sqlite.temp` then rename to `payload.sqlite` on server
- ✅ Delete WAL files (`-wal`, `-shm`) on server after upload
- ✅ Restart Node in hPanel after database changes

---

## 🔌 Connection & Diagnostic Commands

| Command | What it does | Use when |
|---------|--------------|----------|
| `npm run msc:test:hostinger-ftp` | Test FTPS connection | FTPS not working |
| `npm run msc:verify:ftp-smoke` | Upload/download test file | Verify FTPS write access |
| `npm run msc:verify:live` | Smoke test all live endpoints | After deployment |
| `npm run msc:verify:live:version` | Check footer version matches | Verify correct build |
| `npm run msc:logs:live` | Real-time stream of server `stderr.log` via SSH | Debugging live server errors / crashes |
| `npm run msc:logs:live:console` | Real-time stream of server `console.log` via SSH | Viewing live server application output |

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
| `npm run msc:backup:quick` | Non-interactive standard backup to local backup drive (skips `node_modules`, `.next`, `logs`, `test-results`, `zips`) | Daily / before substantive changes |
| `npm run msc:backup:quick:full` | Non-interactive full backup including `node_modules` and `.next` | Weekly / major upgrades |
| `npm run msc:backup:clean` | Retention manager: purges backups older than the 10 most recent | Monthly / as disk space requires |
| `npm run msc:backup:clean -- --dry-run` | Preview which folders would be cleaned up | Safely preview before deleting |
| `npm run backup:clean-zips` | Keeps only the 3 most recent deploy zips in `zips/` | After deploy sessions |

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
| Port 3000 in use | `node scripts/msc-kill-dev-port.mjs` or `npm run msc:kill-dev-port` |
| 503 error | `npm run msc:hostinger:recover` (preload) or `msc:hostinger:npm-install` (webpack in `stderr.log`) |
| Wrong footer/nav on live | `npm run msc:hostinger:sync-app` or `pushit:live:fast -- -WithDb` or full `pushit:live` |
| Fast deploy always ~45 min (zip fallback) | Read **`logs/pushit-unzip-last.log`**; run **`msc:hostinger:deploy-diagnose`** — see **DEPLOYMENT-TROUBLESHOOTING.md** § fast deploy mistakes |
| Need CMS data on live with fast deploy | **`npm run pushit:live:fast -- -WithDb`** (not default) |
| hPanel "Build failed" (MCP) | Ignore if `msc:verify:live` passes — use `pushit:live`, not MCP |
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
npm run msc:verify:live

# Create safe database copy
npm run msc:db:copy

# Test FTPS connection
npm run msc:test:hostinger-ftp
```

### After ANY Deployment (Manual Steps)
🔄 Restart Node: [https://hpanel.hostinger.com/websites/mystudiochannel.com](https://hpanel.hostinger.com/websites/mystudiochannel.com)

✅ Run: `npm run msc:verify:live`

🎉 Confirm site loads: [https://mystudiochannel.com](https://mystudiochannel.com)

---

## 🏆 Success Indicators

| Check | Expected result |
|-------|-----------------|
| `npm run msc:verify:live` | 3/3 PASS (200 OK) |
| Footer version | MyStudioChannel v7.0.0 |
| `/admin` login | Works |
| Demos section | Loads with images |

---

## 🔌 MCP & Cursor

| Command | What it does | When to use |
|---------|--------------|-------------|
| `npm run msc:sync:mcp-env` | Sync `.env.local` → global + project `mcp.json` (GitHub, Tavily, Hostinger ×4, WordPress) | After editing MCP secrets in `.env.local` |
| `npm run msc:test:github-api` | Verify GitHub token | MCP troubleshooting |
| `npm run msc:test:tavily-api` | Verify Tavily token | MCP troubleshooting |

**Docs:** [MCP-SETUP.md](./MCP-SETUP.md) · Reload: **Settings → MCP** (refresh server) or restart Cursor

---

## 🛠️ Dev Tools

| Command | What it does | When to use |
|---------|--------------|-------------|
| `codeburn` | View token usage and cost for Cursor/Claude sessions | Optional — run from any terminal after global install |
| `npm run msc:codeburn` | Wrapper: runs `codeburn` if installed | Weekly token spend review |

Install once (Local):

```bash
npm install -g codeburn
```

---

## 📚 Related Documentation

- [START-HERE.md](./START-HERE.md) — Project entry point
- [HOSTINGER-DEPLOY.md](./HOSTINGER-DEPLOY.md) — Full deployment guide
- [DEPLOYMENT-TROUBLESHOOTING.md](./DEPLOYMENT-TROUBLESHOOTING.md) — Fix common issues
- [PREMIUM-UI-CATALOG.md](./PREMIUM-UI-CATALOG.md) — Pre-wired and copy-paste interactive components
- [Prompt-Cheat-Sheet.md](./Prompt-Cheat-Sheet.md) — Natural language commands
