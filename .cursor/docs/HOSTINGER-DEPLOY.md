# Hostinger Deployment — MyStudioChannel

**Live site:** [https://mystudiochannel.com](https://mystudiochannel.com)  
**Project root (Local):** `D:\Cursor_Projectz\MyStudioChannel`  
**Branch:** `MSC-Website-v6`  
**Stack:** Next.js 15 + Payload CMS 3 + SQLite · entry **`server.js`** (Hostinger may auto-detect **`next start`** for Next.js preset)

**Related:** [DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md) (2026-06-01 learnings) · [DEPLOYMENT-TROUBLESHOOTING.md](./DEPLOYMENT-TROUBLESHOOTING.md) (503/500/504 root-cause guide) · [Go-Live-Checklist.md](./Go-Live-Checklist.md) · [`.env.example`](../../.env.example)

**hPanel:** [https://hpanel.hostinger.com/](https://hpanel.hostinger.com/)

**Canonical rule:** [DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md) → *The Canonical Rule* — if it's imported in app code, it must be in **`dependencies`**, not **`devDependencies`**. Pre-deploy: **`npm ls --omit=dev --depth=0`**.

**Recommended daily deploy:** **`npm run pushit:live:fast`** (~10–15 min) for code/UI when DB and media are unchanged; **`npm run pushit:live`** (~45–60 min) when you need full DB + media parity. Both run **`sync-app`** + host **`npm install --ignore-scripts`**. **Avoid MCP zip** on this host — `better-sqlite3` native compile fails and hPanel can show a stale **Build failed** while FTPS deploys are healthy.

---

## 📁 Hostinger folder map (two `nodejs` folders — not a mistake)

FTPS with **`FTP_REMOTE_PATH=/nodejs`** lands files under **`public_html/nodejs/`**. The Node process **does not** run from there. It runs from the **app root** one level up from `public_html`.

| Path on server | What it is | Node runs here? | Delete? |
|----------------|------------|-------------------|---------|
| `/home/u942711528/domains/mystudiochannel.com/public_html/nodejs/` | **FTPS landing / staging** — `.next`, `payload.sqlite`, `package.json`, source after upload | **No** | **No** — required for deploy pipeline |
| `/home/u942711528/domains/mystudiochannel.com/nodejs/` | **Live app root** — what `server.js` and Payload read at runtime | **Yes** | Never delete while site is live |
| `/home/u942711528/domains/mystudiochannel.com/public_html/.builds/` | Hostinger preload (`config/preload-timestamp.js`) | N/A | **Never** — missing file → **503** |
| `/home/u942711528/domains/mystudiochannel.com/public_html/.htaccess` | Reverse proxy to Node | N/A | Keep |

**File Manager breadcrumbs:** `public_html > nodejs` = staging. Top-level **`nodejs`** (sibling of `public_html`) = live app root.

### After every FTPS upload (automated in `pushit:live`)

| Step | Command | Copies what |
|------|---------|-------------|
| 1 | FTPS `pushitup` | Lands under **`public_html/nodejs/`** |
| 2 | **`npm run msc:hostinger:sync-db`** | `payload.sqlite` → app root; clears WAL/SHM |
| 3 | **`npm run msc:hostinger:sync-app`** | `.next`, `app/`, `lib/`, configs, `package.json`, lockfile → app root; runs **`npm install --legacy-peer-deps --ignore-scripts`** |
| 4 | **hPanel Restart** | Node picks up app root |
| 5 | **`npm run msc:verify:live`** | `/`, `/admin`, APIs **200** |

**Skipping step 2** → DB/API wrong (stub or stale nav). **Skipping step 3** → old code/footer or **503** (`Cannot find module 'next/dist/compiled/webpack/webpack'`). **Skipping step 4** → changes not live.

**Quick DB only:** `npm run msc:push:db:live` runs stop → FTPS DB → **`sync-db`** → **`sync-app`** (keeps code + `node_modules` aligned).

### Database on live

| Check | Good | Bad |
|-------|------|-----|
| `domains/.../nodejs/payload.sqlite` size | **~500–540 KB** | **4 KB** stub |
| Legal nav row (SQLite) | `Legal \| pages-collection \| /` | `Pages` or link `/msc1` |
| `package.json` version (app root) | Matches local (**`6.0.0`**) | Older (**`5.0.0`**) |

Nav labels and Legal dropdown are **DB-driven** — code-only deploy without DB sync will show wrong nav even when `.next` is new.

### `node_modules` on the host

- FTPS **does not** upload `node_modules/` (by design).
- When **`package.json`** / **`package-lock.json`** sync to app root, run **`npm install --legacy-peer-deps --ignore-scripts`** (automated inside **`sync-app`**).
- **Do not** run plain `npm install` without `--ignore-scripts` on this host — **`better-sqlite3`** native rebuild fails (`node-gyp` / GLIBC). **`--ignore-scripts`** keeps the existing binary and still restores Next.js webpack.
- Manual repair: **`npm run msc:hostinger:npm-install`** or **`npm run msc:hostinger:recover`** (diagnose + preload + log trim).

### MCP zip / hPanel "Build failed"

| Symptom | Meaning | Action |
|---------|---------|--------|
| hPanel **Build failed** (red X) | Often stale **MCP** record — `better-sqlite3` compile failed on server | Ignore if **`msc:verify:live`** passes after **FTPS** |
| Live **503** after FTPS | Usually broken **`node_modules`** (missing webpack) or missing **`.builds`** | **`msc:hostinger:npm-install`** or **`msc:hostinger:recover`** → Restart |
| MCP deploy | Server runs `npm install` + `npm run build` | **Unreliable** on this account — use **`pushit:live`** instead |

---

## ✅ Final Configuration Audit (1-Minute Checklist)

Before considering your deployment complete, verify these in hPanel:

### In Node.js → Environment Variables
- [ ] NODE_ENV = production
- [ ] PAYLOAD_SECRET = (32+ char secret)
- [ ] DATABASE_URL = file:./payload.sqlite
- [ ] NEXT_PUBLIC_SERVER_URL = https://mystudiochannel.com
- [ ] PAYLOAD_PUBLIC_SERVER_URL = https://mystudiochannel.com
- [ ] RESEND_API_KEY = (your Resend key)
- [ ] PAYLOAD_DISABLE_SHARP = true

### In Node.js → Dashboard
- [ ] App is "Running" (green status)
- [ ] Last deployment shows "Completed"

### In File Manager → app root `/nodejs/` (not `public_html/nodejs` only)
- [ ] `payload.sqlite` is ~500–540 KB (not 4 KB)
- [ ] `.next/BUILD_ID` exists
- [ ] `server.js` exists
- [ ] `package.json` version matches local (e.g. **6.0.0**)
- [ ] `node_modules/next/dist/compiled/webpack/webpack.js` exists (or run **`msc:hostinger:npm-install`**)

### Run Verification

```bash
npm run msc:verify:live
npm run msc:verify:live:version
```

All green? Your site is live and configured correctly!

---

## ⚠️ MCP / Git deploy ≠ DB deploy (read first)

**MCP zip** and **Git-connected hPanel rebuilds** are **code deploys**. They may include `payload.sqlite` in the archive or repo, but the **live Node app often does not use that file** — you can end up with a **4 KB stub** in `/nodejs/payload.sqlite` while APIs return **500**.

| Check after MCP or Git deploy | Good | Bad — run DB sync |
|-------------------------------|------|-------------------|
| `payload.sqlite` in File Manager → `/nodejs/` | **~500–540 KB** | **4 KB** |
| `GET /api/globals/projects-home?depth=1` | **200** | **500** |

**Fix (fast, ~1–2 min):** `npm run msc:push:db:live` → **Restart** Node in hPanel → `npm run msc:verify:live`

**Reliable DB + code parity:** Full FTPS (`push-website-live.ps1 -Ftps`) or **Quick DB** when only CMS data is wrong.

---

## Deploy paths overview

| Path | When | DB reliable? | Where it runs |
|------|------|--------------|----------------|
| **Quick DB** | APIs **500**, site/admin OK, stub DB | **Yes** | **Local:** `npm run msc:push:db:live` → **Live:** Restart Node |
| **A — MCP zip (code-only default)** | **Code** changed; no CMS/DB trust needed | **No** — verify size after; use Quick DB if stub | **Local:** `push:website:live` → MCP → **Live:** restart |
| **B — FTPS full (`pushit:live`)** | Code + **`.next`** + **DB** + **media** parity | **Yes** (`sync-db` + **`sync-app`** + host npm) | **Local:** `push-website-live.ps1 -Ftps` or `pushit:live` → **Live:** restart |
| **C — Git push + hPanel rebuild** | Major updates from GitHub | **No** — same stub risk as MCP | **Local:** `git push` → Hostinger rebuild → verify DB |
| **D — Daily operator phrase** | Say *push it live* in Cursor | Agent **asks first** (Quick / FTPS / MCP) | See [Push-Website-Live.md](../prompts/Push-Website-Live.md) |

Do **not** run `pushitup` or zip uploads in **Hostinger Terminal** — upload from **Local (PC repo root)** only.

---

## Path A — Zip deploy checklist (verified 2026-06-01)

### 0) Pre-flight (Local)

```powershell
cd D:\Cursor_Projectz\MyStudioChannel
node scripts/msc-kill-dev-port.mjs
npm run build
npm run msc:verify:local
```

Confirm footer shows **`MyStudioChannel v6.0.0`** on `http://localhost:3000/`.

### 1) `package.json` — production dependency rule

See **[DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md) → The Canonical Rule.**

Hostinger runs **`npm install --production`** before **`npm run build`**. **`devDependencies` are not installed** on the server.

**Pre-deploy check:**

```bash
npm ls --omit=dev --depth=0
```

If a build-time import is missing from that list → move it to **`dependencies`**, then **`npm install`**, rebuild, and recreate the deploy bundle.

**Required in `dependencies` (as of 2026-06-01):**

| Package | Why |
|---------|-----|
| `@tailwindcss/postcss` | PostCSS plugin in `postcss.config.mjs` |
| `postcss` | Build pipeline |
| `tw-animate-css` | `@import 'tw-animate-css'` in `app/globals.css` |

**Audit before every zip deploy:** use the pre-deploy check above.

**Lockfile:** Use **`npm`** only. Delete **`pnpm-lock.yaml`** from the project if present — Hostinger expects **`package-lock.json`**.

### 2) Create deployment zip (Local)

**Output:** `zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip`

**Exclude:** `node_modules/`, `.next/`, `.git/`, `*.zip`, `payload.sqlite-wal`, `payload.sqlite-shm`

**Include:** all source, `payload.sqlite`, `public/media/`, `server.js`, `package.json`, `package-lock.json`, `.env.example`, `patches/`, config files, `.cursor/` (optional but harmless).

Stop dev server first (`node scripts/msc-kill-dev-port.mjs`) so SQLite is not locked.

**Reliable method (nested exclusions):** use robocopy to a temp folder, then zip — or ask Cursor to run the deploy-zip script. Simple `Compress-Archive` on the top-level folder **does not** exclude nested `node_modules` / `.next`.

**Quick check after zip:** size should be **under ~200 MB** without `node_modules` (typical ~66 MB).

### 3) Hostinger hPanel — Node.js app settings

Create or configure **Node.js** for **`mystudiochannel.com`** (replaces temporary WordPress when deploy completes).

| Setting | Value |
|---------|--------|
| Framework preset | **Next.js** |
| Node version | **22.x** (20.x also works; verified on 20 via MCP) |
| Package manager | **npm** |
| Build command | `npm run build` |
| Output directory | `.next` |
| Entry (if asked) | `server.js` or platform default for Next.js |

Reference: hPanel → **Websites** → **mystudiochannel.com** → **Node.js** / **Deployments**.

### 4) Environment variables (Live — hPanel → Node.js → Environment)

Set **before** or **immediately after** first deploy. Values from **`.env.local`** on PC — **never commit secrets**.

| Variable | Production value | Purpose |
|----------|------------------|---------|
| `NODE_ENV` | `production` | Production mode |
| `PAYLOAD_SECRET` | 32+ char random (from `.env.local`) | Payload encryption / sessions |
| `DATABASE_URL` | `file:./payload.sqlite` | SQLite path on server |
| `NEXT_PUBLIC_SERVER_URL` | `https://mystudiochannel.com` | Public site + client bundle |
| `PAYLOAD_PUBLIC_SERVER_URL` | `https://mystudiochannel.com` | Payload `serverURL`, emails, CSRF |
| `RESEND_API_KEY` | from Resend dashboard | Transactional email |
| `PAYLOAD_DISABLE_SHARP` | `true` | Skip native `sharp` on shared hosting |

Optional: `NEXT_PUBLIC_MSC_BOOKING_URL=payload`, `MSC_CANONICAL_SITE_ORIGIN=https://mystudiochannel.com`

Template copy: [`.env.example`](../../.env.example)

### 5) Upload and deploy (Live — hPanel)

1. Upload **`MyStudioChannel-deploy.zip`** (drag-and-drop or file manager).
2. **Deploy** / trigger build.
3. Wait for build (~**56–90 seconds** typical).
4. **Restart** Node app if hPanel does not auto-restart.

### 6) Verify live

**Incognito:**

- `https://mystudiochannel.com/` — Next.js site (not WordPress / `wp-content`)
- Footer: **`MyStudioChannel v6.0.0`**
- `https://mystudiochannel.com/admin` — Payload login
- After login: sidebar **`MyStudioChannel Admin v6.0.0`**

**Local smoke script:**

```powershell
npm run msc:verify:live
```

---

## Path B — FTPS update (`pushit:live`)

For **ongoing updates** after first live deploy. **Local (PC repo root)** only.

```powershell
npm run pushit:live
```

Pipeline: **`npm run build`** (live `NEXT_PUBLIC_SERVER_URL` for that step) → **`msc:pushitup:admin-ui`** → **`.next`** → **`payload.sqlite`** → **`msc:hostinger:sync-db`** → **`msc:hostinger:sync-app`** (mirror staging → app root + **`npm install --ignore-scripts`**) → **`public/media`**.

Then **Live (hPanel):** **Restart** Node app.

**Why two SSH steps:** FTPS lands in **`public_html/nodejs/`**; Node runs from **`domains/.../nodejs/`**. Without **`sync-app`**, only the DB might update — live code/footer/nav can stay on v5.

See [Go-Live-Checklist.md](./Go-Live-Checklist.md) for tier tables and recovery steps.

**Before Tier 2 upload (Live Terminal, optional):**

```bash
cd /home/u942711528/domains/mystudiochannel.com/nodejs
rm -rf .next
rm -f payload.sqlite-wal payload.sqlite-shm
```

**FTPS target:** **`FTP_REMOTE_PATH=/nodejs`** in **`.env.local`** → sync with **`scripts/sync-sftp-from-env.ps1`**.  
Uploads land in **`public_html/nodejs/`** (staging). **`msc:hostinger:sync-db`** and **`msc:hostinger:sync-app`** copy into the live app root.  
Wrong **`remotePath`** or skipping SSH sync → live app never sees your `.next` or DB.

---

## Path C — Daily updates (after first deploy)

**Canonical operator phrase:** say **"push website live"** in chat → agent runs [`.cursor/prompts/Push-Website-Live.md`](../prompts/Push-Website-Live.md):

1. **Local:** `npm run push:website:live` (kill dev → build → `zips/MyStudioChannel-deploy-*.zip`)
2. **MCP:** `hosting_deployJsApplication` + poll `hosting_listJsDeployments` / logs on failure
3. **Restart:** https://hpanel.hostinger.com/websites/mystudiochannel.com → Node.js → **Restart**
4. **Verify:** `npm run msc:verify:live` + `msc:verify:live:version`

**FTPS fallback (if MCP fails):**
```powershell
npm run push:website:live -- --ftps
```

Dry-run preflight only:
```powershell
npm run push:website:live -- --dry-run
```

**Zip-only** (after manual build):
```powershell
npm run msc:deploy:zip
```

**Deployment zip folder:** `zips/` at repo root — `MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip` (gitignored). Never save deploy zips to `D:\Cursor_Projectz\`.

Once your site is live, use these methods for ongoing updates. **Quick card:** [START-HERE.md](./START-HERE.md) → *Pushing updates live*.

### Quick reference: update methods

| Method | Command | When to use | Time | DB reliable? |
|--------|---------|-------------|------|--------------|
| **Quick DB sync** | `npm run msc:push:db:live` | APIs **500**, stub **4 KB** DB | ~1–2 min | **Yes** |
| **Push website live (ask mode)** | Say *push it live* — agent picks Quick / FTPS / MCP | Always start here | Varies | Depends on mode |
| **MCP zip (code-only)** | `npm run push:website:live` → MCP | **Code** changes only; verify DB after | ~5–10 min | **No** |
| **FTPS fast (Tier 2b)** | `npm run pushit:live:fast` | Code + `.next` + admin-ui; optional `-WithDb` / `-WithMedia` | ~10–15 min | **Only with `-WithDb`** |
| **FTPS full (Tier 2)** | `push-website-live.ps1 -Ftps` or `pushit:live` | Code + DB + media parity | ~45–60 min | **Yes** (+ `sync-db` + **`sync-app`**) |
| **Git push + rebuild** | `git push origin main` | Major updates, new packages | ~5–6 min | **No** — verify DB size |

---

### Method 1a: FTPS fast — `npm run pushit:live:fast` (default for daily code/UI)

Zips **`.next`** to **`zips/deploy-next.zip`**, copies to repo-root **`deploy-next.zip`** for FTPS (remote: **`public_html/nodejs/deploy-next.zip`** — not under `zips/`), SSH-unzips on staging (BUILD_ID verify), then **`sync-app`**. Falls back to full **`pushitup -- .next`** if zip/unzip fails.

```powershell
# Default — code + admin-ui + sync-app (no DB/media)
npm run pushit:live:fast

# Admin-only (~3–5 min) — no build, no zip
npm run pushit:live:fast -- -SkipBuild

# Include DB and/or media when needed
npm run pushit:live:fast -- -WithDb
npm run pushit:live:fast -- -WithDb -WithMedia

# Preflight — print steps only
npm run pushit:live:fast -- -DryRun
```

**When not to use:** first deploy, new npm packages (use **`pushit:live`** or **`msc:pushitup:server-config`** + **`msc:hostinger:npm-install`**), or when CMS/media must always ship with code (use full **`pushit:live`**).

---

### Method 1b: FTPS full — `npm run pushit:live` (full parity)

**What it uploads (Local → Live via FTPS):**

- **`msc:pushitup:admin-ui`** — Payload admin sources (middleware, branding, config, etc.)
- **`.next/`** — production build
- **`payload.sqlite`** — local CMS database
- **`public/media/`** — on-disk media assets

**What it does NOT upload (manage separately):**

- **`node_modules/`** — host keeps its own install
- **`package.json` / `package-lock.json`** — shipped by **`pushit:live`** / **`sync-app`**; host **`npm install --ignore-scripts`** runs automatically. Manual: **`npm run msc:hostinger:npm-install`**.

**Note:** `pushit:live` runs **`npm run build`** internally (live `NEXT_PUBLIC_SERVER_URL` for that step only). Running build first is still recommended for pre-flight.

**Step-by-step (Local — repo root):**

```bash
# 1. Pre-flight (optional but recommended)
npm run build
npm run msc:verify:local

# 2. Push live (includes build + FTPS upload)
npm run pushit:live

# 3. Live (hPanel) → Restart Node.js app
```

Safer variant: **`npm run msc:pushit:live:safe`** — runs **`msc:verify:local`** first, then full **`pushit:live`**.

**After adding new npm packages:** run **`pushit:live`** (includes lockfile + **`sync-app`** npm step) or **`msc:pushitup:server-config`** + **`npm run msc:hostinger:npm-install`**. FTPS upload alone without **`sync-app`** will **not** update app root or `node_modules`.

---

### Method 2: Git push + Hostinger rebuild (code — not a DB deploy)

If your Hostinger Node.js app is connected to GitHub:

```bash
git push origin main
```

Hostinger will typically:

1. Pull latest code (may include `payload.sqlite` in the repo)
2. Run **`npm install`** (production)
3. Run **`npm run build`**
4. Restart the app

**Best for:** new dependencies and **code** changes when FTPS/MCP are unavailable.

**Not reliable for CMS data:** even when `payload.sqlite` is committed (~500 KB), the live app root can still show a **4 KB stub** after rebuild. Payload then has no tables → `/api/globals/*` **500**.

**After every Git rebuild:**

1. File Manager → `/nodejs/payload.sqlite` — expect **~500 KB**, not **4 KB**
2. Or run `npm run msc:verify:live` — projects-home must be **200**
3. If stub → **`npm run msc:push:db:live`** → Restart Node

**Reminder:** apply **The Canonical Rule** — packages imported in app/CSS must be in **`dependencies`**, or the host build will fail.

---

### Method 3: From Cursor (Hostinger MCP) — code-only default

Tell Cursor:

> push it live

The agent will **ask which mode** (Quick DB · Full FTPS · MCP zip). For MCP alone:

The MCP uploads a source zip (`create-deploy-zip.ps1` **includes** `payload.sqlite` and validates size) and triggers a server-side build (`hosting_deployJsApplication`).

**Best for:** **code** updates when you do not need to trust the live database from the zip.

**DB caveat:** the zip can contain a full DB, but Hostinger’s extract/build path does not guarantee `/nodejs/payload.sqlite` is updated — same **4 KB stub** risk as Git deploy. **Always verify DB size or run `msc:verify:live` after MCP deploy.** If APIs fail → **`npm run msc:push:db:live`**.

**MCP cannot set environment variables** — set those in hPanel UI.

---

### Pre-update checklist (before any method)

| Step | Command | Why |
|------|---------|-----|
| 1 | `npm run build` | Verify build passes locally |
| 2 | `npm run msc:verify:local` | Test all local endpoints |
| 3 | `npm ls --omit=dev --depth=0` | Audit production deps ([DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md)) |
| 4 | `git status` | Ensure clean working tree (or know what you're shipping) |

---

### Post-update verification

After any update:

```bash
# Local smoke test (optional)
npm run msc:verify:live
```

**Manual checks (Incognito):**

- [https://mystudiochannel.com](https://mystudiochannel.com)
- [https://mystudiochannel.com/admin](https://mystudiochannel.com/admin)
- Footer shows correct version (**`MyStudioChannel v6.0.0`**)

---

### Troubleshooting common update issues

| Issue | Likely cause | Fix |
|-------|--------------|-----|
| Changes not showing | Forgot to restart Node app | Restart in hPanel |
| Missing CSS | `tw-animate-css` not in **`dependencies`** | Move to **`dependencies`**, rebuild, redeploy |
| API 500 errors | Env vars missing | Check hPanel environment variables |
| Build fails on host | Missing package in **`dependencies`** | **`npm ls --omit=dev --depth=0`** to audit |
| Old content showing | Browser cache | Hard refresh (Ctrl+Shift+R) or Incognito |
| Vendor-chunk 500 | Stale **`.next`** on host | Re-upload **`.next`** after local build; run **`msc:hostinger:sync-app`** |
| 503 after FTPS / wrong version | Code landed in **`public_html/nodejs`** only, or broken **`node_modules`** | **`msc:hostinger:sync-app`** or **`msc:hostinger:npm-install`** → Restart |
| hPanel Build failed (MCP) | **`better-sqlite3`** compile on host | Use **`pushit:live`**; ignore stale MCP status if **`msc:verify:live`** passes |

---

### Summary: which method should I use?

| Change type | Recommended method |
|-------------|-------------------|
| Text / UI changes | FTPS (`pushit:live`) |
| CSS / Tailwind updates | FTPS (`pushit:live`) |
| Component logic | FTPS (`pushit:live`) |
| Added npm package | Git push **or** new zip **or** server-config + `npm install` |
| Payload collection change | Git push + migration plan |
| Environment variable | Set in hPanel (no code deploy) |
| Database / seed data | FTPS (uploads **`payload.sqlite`**) — **stop Node first** |

---

### Quick command card

```bash
# Local pre-flight
npm run build && npm run msc:verify:local

# Push live (FTPS)
npm run pushit:live

# Then in hPanel: Restart Node.js app

# Check live health
npm run msc:verify:live
```

---

## Hostinger MCP (optional)

With **Hostinger Connector** signed in, agents can:

- `hosting_listWebsitesV1` — confirm domain / username
- `hosting_deployJsApplication` — upload source archive (no `.next`; server builds)
- `hosting_listJsDeployments` / `hosting_showJsDeploymentLogs` — build status

**MCP cannot set environment variables** — Jon must set those in hPanel UI.

Zip path and **`package.json` dependency fixes** apply to MCP uploads the same way.

---

## Common errors and fixes

| Issue | Error / symptom | Fix |
|-------|----------------|-----|
| Missing PostCSS | `Cannot find module '@tailwindcss/postcss'` | Move `@tailwindcss/postcss` + `postcss` to **`dependencies`** |
| Missing animations CSS | `Can't resolve 'tw-animate-css'` | Move **`tw-animate-css`** to **`dependencies`** |
| Missing other build import | `Cannot find module '…'` during `next build` on Hostinger | Move package to **`dependencies`**; `npm ls --omit=dev` |
| Lockfile mismatch | npm vs pnpm errors | Delete **`pnpm-lock.yaml`**; use **`package-lock.json`** + **npm** only |
| SQLite locked / corrupt zip | WAL errors, stale DB | Stop **`npm run dev`** before zipping; exclude **`payload.sqlite-wal`** / **`-shm`** |
| Still shows WordPress | `wp-content` in page source | Complete Node deploy; ensure domain points to Node app, not old WP docroot |
| Live API 500 | `/api/globals/projects-home` fails | Set env vars; restart Node; on host remove WAL files and re-upload `payload.sqlite` if needed |
| Vendor-chunk 500 | `Cannot find module './vendor-chunks/…'` | Full **`.next`** re-upload after local **`npm run build`** ([Go-Live-Checklist.md](./Go-Live-Checklist.md) §6) |
| Build timeout | Slow compile on shared host | Normal ~56s; retry deploy; avoid uploading pre-built `.next` in zip (let host build) |
| 503 After Cleanup | Fatal crash on startup | Recreate missing `.builds/config/preload-timestamp.js` via SSH, then restart in hPanel. |
| 503 missing webpack | `Cannot find module 'next/dist/compiled/webpack/webpack'` in `stderr.log` | **`npm run msc:hostinger:npm-install`** (uses **`--ignore-scripts`**) → Restart |
| Nav/footer wrong on live | DB or code not synced to app root | **`pushit:live`** or **`msc:push:db:live`** (includes **`sync-app`**) |

### 503 After Cleaning Up Files (Hostinger-specific)

**Cause:** You deleted the `.builds/` directory inside `public_html` to free space. Hostinger's Node.js process manager expects a preload file at `.builds/config/preload-timestamp.js` to start, and without it, Node crashes instantly, resulting in a persistent 503 error.

**Fix:**
1. Connect via SSH or use hPanel File Manager
2. Recreate the folder structure:
   ```bash
   mkdir -p /home/u942711528/domains/mystudiochannel.com/public_html/.builds/config
   ```
3. Create the empty preload file:
   ```bash
   touch /home/u942711528/domains/mystudiochannel.com/public_html/.builds/config/preload-timestamp.js
   ```
4. Set correct permissions:
   ```bash
   chmod 644 /home/u942711528/domains/mystudiochannel.com/public_html/.builds/config/preload-timestamp.js
   ```
5. **Restart** Node.js in hPanel.

**Prevention:** Never delete the `.builds/` folder. If you need to free resources, delete old deployment `.zip` archives in `/nodejs/zips/` or old `.log` files, but leave `.builds/` intact.

### 504 Error After Database Upload (Now Automated)

**Cause:** `payload.sqlite` was copied while `npm run dev` still had the DB open/locked.

**Fix (Automated in our FTPS deployment script!):**
Running `npm run push:website:live -- --ftps` automatically:
1. Verifies that the local dev server is stopped.
2. Creates a clean copy of the database (`payload.sqlite.temp`).
3. Uploads it safely to the server.
4. **Automatically deletes the remote server's `payload.sqlite-wal` and `payload.sqlite-shm` files over FTPS** to prevent locks.
5. Verifies the remote file size is correct.

**Fix (Manual / Fail-safe Fallback):**
1. Stop local `npm run dev` (Ctrl+C).
2. Run `npm run msc:db:copy` (to create a clean temp database).
3. Upload `payload.sqlite.temp` to `/nodejs/` and rename it to `payload.sqlite`.
4. Delete `payload.sqlite-wal` and `payload.sqlite-shm` on the server manually.
5. Restart the Node app in hPanel.

---

## Successful live update protocol (numbered)

| Step | Where | Action |
|------|--------|--------|
| 1 | **Local** | Dependency audit: `npm ls --omit=dev --depth=0` |
| 2 | **Local** | `npm run build` + `npm run msc:verify:local` |
| 3 | **Local** | Zip deploy **or** `npm run pushit:live` |
| 4 | **Live (hPanel)** | Set / verify environment variables |
| 5 | **Live (hPanel)** | Deploy or wait for FTPS upload to finish (WAL files are cleaned up automatically in `--ftps` mode) |
| 6 | **Live (hPanel)** | **Restart** Node.js application (Stop then Start) |
| 7 | **Local** | `npm run msc:verify:live` + Incognito check `/` and `/admin` |

**Do not run on Hostinger Terminal:** `pushitup`, zip creation, or `git pull` from your PC workflow unless you explicitly maintain server-side git.

**Prefer Local SSH scripts over hPanel Terminal:** **`npm run msc:hostinger:sync-app`**, **`msc:hostinger:npm-install`**, **`msc:hostinger:recover`**.  
**Hostinger Terminal (if needed):** `npm install --legacy-peer-deps --ignore-scripts` in app root, `rm -f payload.sqlite-wal payload.sqlite-shm`.

---

## Ground rules

1. Secrets only in **hPanel env** and **`.env.local`** — never in git.
2. **MCP zip and Git rebuild are not DB deploys** — treat `payload.sqlite` on live as unverified until File Manager or `msc:verify:live` confirms **~500 KB** and APIs **200**. Use **`msc:push:db:live`** when the stub appears.
3. **FTPS lands under `public_html/nodejs/`** — always run **`msc:hostinger:sync-db`** + **`msc:hostinger:sync-app`** (both are in **`pushit:live`**).
4. **`payload.sqlite`** in a zip/repo does not mean the live app uses it — verify app root size or use Quick DB.
5. **`PAYLOAD_DISABLE_SHARP=true`** on Hostinger.
6. Production URLs must be **`https://mystudiochannel.com`** (both `NEXT_PUBLIC_*` and `PAYLOAD_PUBLIC_*`).
7. After deploy, confirm version labels: **`MyStudioChannel v6.0.0`** / **`MyStudioChannel Admin v6.0.0`**.
8. **Do not delete `public_html/nodejs/`** — it is the FTPS staging folder, not a duplicate mistake.

---

*Last updated: 2026-06-08 — v6.0.0: folder map, sync-app + npm-install hardening, MCP/build-failed notes*
