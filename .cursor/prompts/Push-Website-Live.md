# Push Website Live — Deploy Mode Picker (ask first)

## Trigger
When user says **"push website live"**, **"push it live"**, **"push site live"**, or **"deploy live"**.

## Goal
Ship **`MSC-Website-v6`** to **https://mystudiochannel.com**. **Always ask Jon which deploy mode first** — do not auto-run the long full build.

---

## Step 0 — Deploy mode gate (required — `AskQuestion`)

When Jon says **push it live** / **push website live**, present **one** `AskQuestion` with these options (recommended order):

| Option | Label for Jon | Time | When to use |
|--------|---------------|------|-------------|
| **A** | **Quick DB sync** (~1–2 min) | ~1–2 min | `/` + `/admin` OK, `/api/globals/*` **500**, or live `payload.sqlite` is ~4 KB stub |
| **B** | **Full FTPS deploy** (~45–60 min) | Long | Code/UI/admin changed; need local `.next` + DB + media on server |
| **C** | **MCP zip — code only** (~5–10 min) | Medium | **Code** changed; **not** for CMS/DB trust — zip has DB but live may keep **4 KB stub** |

**Agent rule:** Wait for Jon’s choice before running build/upload commands.

### Mode A — Quick DB sync (default when APIs 500, site loads)
**Local:**
```powershell
npm run msc:push:db:live
```
Then **Live (hPanel):** **Restart** Node → `npm run msc:verify:live`

Steps inside script: `msc:hostinger:stop-node` → FTPS `payload.sqlite` → `msc:hostinger:sync-db` (FTPS lands under `public_html/nodejs/`; SSH copies into live app root).

### Mode B — Full FTPS
**Local:**
```powershell
powershell -ExecutionPolicy Bypass -File scripts/push-website-live.ps1 -Ftps
```
Includes SSH stop + `pushit:live` + SSH DB sync. **Live (hPanel):** **Restart** when done.

### Mode C — MCP zip (code-only — not a DB deploy)
See steps below.

**Tell Jon explicitly:** MCP zip **includes** `payload.sqlite` in the archive, but **MCP/Git deploy ≠ DB deploy**. After deploy, verify `/nodejs/payload.sqlite` is **~500 KB** (not **4 KB**) or run `msc:verify:live`. If APIs **500** → run **Mode A** immediately.

---

## Mode C steps: MCP zip (code-only)
1. **Local:** fresh production build + timestamped source zip (includes `payload.sqlite` for validation; **do not trust live DB from zip alone**).
2. **MCP:** `hosting_deployJsApplication` uploads zip → Hostinger runs `npm install` + `npm run build` on server.
3. **Always:** hPanel **Restart** + **DB size check** or `npm run msc:verify:live`.
4. **If stub DB:** run **Mode A** (`msc:push:db:live`) — do not re-run full MCP hoping DB will stick.

**Full FTPS (Mode B)** — when you need **reliable** DB + `.next` + media on live.

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

Confirm branch **`MSC-Website-v6`**, report `package.json` version, warn on uncommitted changes.

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

### Option B — SSH stop + FTPS + SSH DB sync (no hPanel Stop button)

When hPanel only shows **Restart** (Git-connected Node.js):

**Local (Cursor / repo root):**
```powershell
powershell -ExecutionPolicy Bypass -File scripts/push-website-live.ps1 -Ftps
```

Or: `npm run push:website:live -- --ftps` (pass `-Ftps` to PowerShell if npm eats the flag).

The FTPS path automatically:
1. **`npm run msc:hostinger:stop-node`** — SSH `pkill` + clear WAL/SHM on live app root
2. **`npm run pushit:live`** — build + FTPS upload
3. **`npm run msc:hostinger:sync-db`** — copy `public_html/nodejs/payload.sqlite` → `domains/.../nodejs/` (Hostinger FTPS chroot quirk)

**Live (hPanel):** click **Restart** after upload completes.

**Why sync-db?** FTPS `remotePath: /nodejs` lands files under `public_html/nodejs/` while the Node app runs from `domains/mystudiochannel.com/nodejs/`. Without the SSH copy, live keeps a 4 KB stub DB and `/api/globals/*` returns 500.

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
- **DO** ask deploy mode first; use **MCP code-only** for code changes (verify DB after); **Quick DB** or **Full FTPS** when CMS/data must be trusted on live
