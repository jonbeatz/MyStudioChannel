# Push Website Live — MCP Zip Deploy (Default)

## Trigger
When user says **"push website live"**, **"push it live"**, **"push site live"**, or **"deploy live"**.

## Goal
Ship **`MSC-Website-v5`** to **https://mystudiochannel.com** using the **fast MCP zip** path by default. Fall back to **FTPS** only if MCP fails.

## Default method: MCP zip (recommended)
1. **Local:** fresh production build + timestamped source zip (no `node_modules`, `.next`, `.git`).
2. **MCP:** `hosting_deployJsApplication` uploads zip → Hostinger runs `npm install` + `npm run build` on server.
3. **Always:** clickable **hPanel restart** reminder after successful deploy.

**FTPS** (`npm run pushit:live`) is **fallback** — slower, but ships your **local** `.next` + DB bit-for-bit when MCP is broken.

---

## Agent execution (do this in order)

### Step 1 — Local preflight + zip
**Local (Cursor / repo root):**
```powershell
npm run push:website:live
```

This script:
- Stops port **3000** (`kill-dev-port`)
- Runs **`npm run build`** with live `NEXT_PUBLIC_SERVER_URL`
- Creates **`zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip`**
- Prints **`DEPLOY_ZIP_PATH=...`** and MCP instructions

**Dry-run only:**
```powershell
npm run push:website:live -- --dry-run
```

**Zip only (if build already done):**
```powershell
npm run deploy:zip
```

Confirm branch **`MSC-Website-v5`**, report `package.json` version, warn on uncommitted changes.

### Step 2 — MCP deploy (default)
Read MCP schema first: `hosting_deployJsApplication`, `hosting_listJsDeployments`, `hosting_showJsDeploymentLogs`.

1. **Deploy** — use absolute zip path from script output or `zips/.last-deploy-zip.txt`:
   - **Server:** `user-hostinger-hosting`
   - **Tool:** `hosting_deployJsApplication`
   - **Args:** `domain: mystudiochannel.com`, `archivePath: <full path to zip>`, `removeArchive: false`

2. **Poll** — `hosting_listJsDeployments` for `domain: mystudiochannel.com` until latest deployment is **`completed`** or **`failed`** (re-poll every ~15–30 s, up to ~10 min).

3. **On failure** — `hosting_showJsDeploymentLogs` with `buildUuid` from the failed deployment. Summarize error for Jon.

4. **On MCP failure** — ask Jon, then run FTPS fallback:
   ```powershell
   npm run push:website:live -- --ftps
   ```

### Step 3 — Restart reminder (required)
After **successful** MCP deploy **or** successful FTPS upload, print:

```
✅ Deployment successful!
🔄 IMPORTANT: You MUST restart your Node.js app for changes to take effect.
➡️ Click here to restart: https://hpanel.hostinger.com/websites/mystudiochannel.com (then click the 'Restart' button in the Node.js section)
```

Or run:
```powershell
powershell -File scripts/print-hostinger-restart-reminder.ps1 -Status success
```

**No MCP tool restarts Node** — Jon must restart in hPanel.

### Step 4 — Optional server cleanup (Live — hPanel Terminal)
If DB was replaced or SQLite looks stale:
```bash
cd /home/u942711528/domains/mystudiochannel.com/nodejs
rm -f payload.sqlite-wal payload.sqlite-shm
```

### Step 5 — Live verification (Local)
After restart (wait 20–30 s):
```powershell
npm run verify:live
npm run verify:live:version
```

Expected:
- `/` → 200
- `/admin` → 200
- `/api/globals/projects-home?depth=1` → 200
- Footer matches `package.json` version

Poll automatically when using **`--ftps`** (script handles). For **MCP**, agent runs verify after Jon restarts (or poll `verify:live` up to ~3 min).

### Step 6 — Report
Pass/fail summary. If API **500**, check hPanel env vars (`HOSTINGER-DEPLOY.md`). Suggest **`npm run dev:fresh`** locally after deploy.

---

## Zip rules
| Rule | Value |
|------|--------|
| **Folder** | `zips/` at repo root (gitignored) |
| **Naming** | `MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip` |
| **Exclude** | `node_modules/`, `.next/`, `.git/`, `zips/`, `*.zip`, `payload.sqlite-wal`, `payload.sqlite-shm` |
| **Include** | Source, `payload.sqlite`, `public/media/`, `server.js`, `package.json`, `patches/` |
| **Never** | Save deploy zips to `D:\Cursor_Projectz\` parent folder |

---

## FTPS fallback (`--ftps`)
When MCP fails or Jon requests FTPS:

```powershell
npm run push:website:live -- --ftps
```

Requires **`.vscode/sftp.json`** (`FTP_REMOTE_PATH=/nodejs`). Runs **`pushit:live`** + polls **`verify:live`**.

**Before FTPS DB upload:** STOP Node in hPanel; optional:
```bash
cd /home/u942711528/domains/mystudiochannel.com/nodejs
rm -rf .next
rm -f payload.sqlite-wal payload.sqlite-shm
```

---

## MCP tools
| Tool | Use |
|------|-----|
| `hosting_deployJsApplication` | Upload zip, trigger server build (**default**) |
| `hosting_listJsDeployments` | Poll deploy status |
| `hosting_showJsDeploymentLogs` | Debug failed builds |

---

## Cleanup “old stuff” on server (optional)
| Path | Action |
|------|--------|
| `public_html/.builds/` | Old Hostinger zip cache — safe to delete |
| `nodejs/payload.sqlite-wal` / `.shm` | Delete before restart after DB deploy |
| Do **not** delete | `nodejs/`, `payload.sqlite`, `.next` (after good deploy), `node_modules` |

---

## Related docs
- `.cursor/docs/HOSTINGER-DEPLOY.md` — Path A (zip) / B (FTPS) / C (daily)
- `.cursor/docs/Go-Live-Checklist.md`
- `.cursor/docs/Jedi-List.md`

## Rules
- **DO** run zip + MCP from **Local (PC)**; agent calls MCP tools
- **DO NOT** run `pushitup` on Hostinger Terminal
- **DO** print restart link after every successful deploy
- **DO** use MCP zip for daily updates; FTPS only as fallback or when shipping local `.next`/DB without server rebuild
