# Push Website Live — Unified Deploy Playbook

## Trigger
When user says **"push website live"**, **"push it live"**, **"push site live"**, or **"deploy live"**.

## Goal
Ship the **exact local production build** (`.next` + admin-ui + `payload.sqlite` + `public/media`) to **https://mystudiochannel.com** via FTPS, then verify live health and version parity with `package.json`.

## Command
**Local (Cursor / repo root):**
```powershell
npm run push:website:live
```

Dry-run preflight only (no upload):
```powershell
npm run push:website:live -- --dry-run
```

## Deployment zip location (MCP / manual only)
- **Folder:** `D:\Cursor_Projectz\MyStudioChannel\zips\` (gitignored)
- **Naming:** `MyStudioChannel-v4-deploy-YYYYMMDD-HHmmss.zip`
- **Never** save deploy zips to `D:\Cursor_Projectz\` root

## Agent execution steps

### Step 1: Confirm context
- Branch should be **`MSC-Website-v4`** (or operator-approved release branch)
- Read `package.json` version — report to Jon
- Run `git status` — warn if uncommitted runtime changes

### Step 2: Preflight (Local)
Run from repo root:
```powershell
npm run push:website:live -- --dry-run
```
If dry-run fails, stop and report the failing step.

### Step 3: Server prep (Live — Jon or hPanel)
**Before upload**, Jon must:
1. **STOP** Node app: https://hpanel.hostinger.com/websites/mystudiochannel.com/nodejs
2. **Hostinger Terminal:**
   ```bash
   cd /home/u942711528/domains/mystudiochannel.com/public_html
   rm -rf .next
   rm -f payload.sqlite-wal payload.sqlite-shm
   ```

Use **AskQuestion** to confirm server prep is done before running the full deploy.

### Step 4: Deploy (Local)
```powershell
npm run push:website:live
```
This runs:
1. `verify:next:safe` — build gate
2. `verify:ftp-smoke` — FTPS path sanity
3. `pushit:live` — build (live URL) → admin-ui → `.next` → DB → media

### Step 5: Restart (Live — hPanel)
**After upload**, Jon must:
1. **Terminal** (optional media URL fix):
   ```bash
   cd /home/u942711528/domains/mystudiochannel.com/public_html
   sqlite3 ./payload.sqlite "UPDATE media SET url = '/media/' || filename;"
   pkill -u $(whoami) node
   ```
2. **START** Node app: https://hpanel.hostinger.com/websites/mystudiochannel.com/nodejs (wait 20–30 s)

Agent polls `verify:live` automatically (script handles up to ~3 min).

### Step 6: Verification
Confirm all pass:
```powershell
npm run verify:live
npm run verify:live:version
```

Expected:
- `/` → 200
- `/admin` → 200
- `/api/globals/projects-home?depth=1` → 200
- Footer: `MyStudioChannel v{version}` (from `package.json`)
- Admin sidebar: `MyStudioChannel Admin v{version}`

### Step 7: Report
Print pass/fail summary. If API 500 persists, remind Jon to check hPanel env vars (`HOSTINGER-DEPLOY.md`):
- `NODE_ENV`, `PAYLOAD_SECRET`, `DATABASE_URL`, `NEXT_PUBLIC_SERVER_URL`, `PAYLOAD_PUBLIC_SERVER_URL`, `RESEND_API_KEY`, `PAYLOAD_DISABLE_SHARP=true`

Suggest `npm run dev:fresh` locally after deploy.

## When to use Hostinger MCP instead
Use **`hosting_deployJsApplication`** (source zip → server build) only when:
- New npm packages in `dependencies` (FTPS does not run `npm install` on host)
- FTPS is broken
- Full source redeploy requested

MCP zip path does **not** guarantee bit-identical `.next` to local — prefer FTPS for daily parity.

## MCP tools (secondary)
| Tool | Use |
|------|-----|
| `hosting_deployJsApplication` | Full source zip deploy |
| `hosting_listJsDeployments` | Poll deploy status |
| `hosting_showJsDeploymentLogs` | Debug failed builds |

**No MCP tool** restarts Node after FTPS — hPanel restart is required.

## Related docs
- `.cursor/docs/HOSTINGER-DEPLOY.md` — Path B/C
- `.cursor/docs/Go-Live-Checklist.md` — Tier 2 table
- `.cursor/docs/Jedi-List.md` — script reference

## Important rules
- **DO** run deploy from **Local (PC repo root)** only
- **DO NOT** run `pushitup` or `pushit:live` on Hostinger Terminal
- **DO NOT** skip server `.next` / WAL cleanup before Tier 2 upload
- **DO NOT** assume MCP auto-restarts Node after FTPS
