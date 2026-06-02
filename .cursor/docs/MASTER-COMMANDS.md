# MyStudioChannel - Master Command Reference

**Last Updated:** 2026-06-02  
**Branch:** `MSC-Website-v5`  
**Version:** `5.0.0`  
**Live Site:** [https://mystudiochannel.com](https://mystudiochannel.com)

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
| `npm run push:website:live` | MCP zip deploy (code only) | ❌ No | ~3 min |
| `npm run push:website:live -- --ftps` | FTPS full deploy (code + DB) | ✅ Yes (with WAL cleanup) | ~5 min |
| `npm run push:website:live -- --dry-run` | Preview deploy without uploading | N/A | ~30 sec |
| `npm run deploy:zip` | Create deploy zip only | ✅ Yes (in /zips/) | ~10 sec |

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
| 503 error | Check `stderr.log` for missing `.builds/config/preload-timestamp.js`. Recreate if missing. |
| Database 4KB (not 528KB) | Upload correct database via FTPS or File Manager |
| WAL files causing lock | Delete `payload.sqlite-wal` and `payload.sqlite-shm` on server |
| Wrong files deployed | Verify `FTP_REMOTE_PATH=/nodejs` in `.env.local` |
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
| Footer version | MyStudioChannel v5.0.0 |
| `/admin` login | Works |
| Demos section | Loads with images |

---

## 📚 Related Documentation

- [START-HERE.md](./START-HERE.md) — Project entry point
- [HOSTINGER-DEPLOY.md](./HOSTINGER-DEPLOY.md) — Full deployment guide
- [DEPLOYMENT-TROUBLESHOOTING.md](./DEPLOYMENT-TROUBLESHOOTING.md) — Fix common issues
- [Prompt-Cheat-Sheet.md](./Prompt-Cheat-Sheet.md) — Natural language commands
