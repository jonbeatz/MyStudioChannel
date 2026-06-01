# Hostinger Deployment — MyStudioChannel

**Live site:** [https://mystudiochannel.com](https://mystudiochannel.com)  
**Project root (Local):** `D:\Cursor_Projectz\MyStudioChannel`  
**Branch:** `MSC-Website-v3`  
**Stack:** Next.js 15 + Payload CMS 3 + SQLite · entry **`server.js`** (Hostinger may auto-detect **`next start`** for Next.js preset)

**Related:** [DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md) (2026-06-01 learnings) · [Go-Live-Checklist.md](./Go-Live-Checklist.md) · [`.env.production.template`](../../.env.production.template)

**hPanel:** [https://hpanel.hostinger.com/](https://hpanel.hostinger.com/)

**Canonical rule:** [DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md) → *The Canonical Rule* — if it's imported in app code, it must be in **`dependencies`**, not **`devDependencies`**. Pre-deploy: **`npm ls --omit=dev --depth=0`**.

---

## Deploy paths overview

| Path | When | Where it runs |
|------|------|----------------|
| **A — Zip upload (first deploy / full refresh)** | First Node.js setup, replacing WordPress, or when FTPS is not configured | **Local:** build zip → **Live (hPanel):** drag-and-drop → Deploy |
| **B — FTPS `pushit:live` (updates)** | Day-to-day updates after initial live setup | **Local:** `npm run pushit:live` → **Live (hPanel):** restart Node |
| **C — Daily updates (after first deploy)** | Ongoing changes — pick FTPS, Git rebuild, or MCP | See **Path C** below |

Do **not** run `pushitup` or zip uploads in **Hostinger Terminal** — upload from **Local (PC repo root)** only.

---

## Path A — Zip deploy checklist (verified 2026-06-01)

### 0) Pre-flight (Local)

```powershell
cd D:\Cursor_Projectz\MyStudioChannel
node scripts/kill-dev-port.mjs
npm run build
npm run verify:local
```

Confirm footer shows **`MyStudioChannel v3.0.0`** on `http://localhost:3000/`.

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

**Output:** `D:\Cursor_Projectz\MyStudioChannel-deploy.zip`

**Exclude:** `node_modules/`, `.next/`, `.git/`, `*.zip`, `payload.sqlite-wal`, `payload.sqlite-shm`

**Include:** all source, `payload.sqlite`, `public/media/`, `server.js`, `package.json`, `package-lock.json`, `.env.production.template`, `patches/`, config files, `.cursor/` (optional but harmless).

Stop dev server first (`node scripts/kill-dev-port.mjs`) so SQLite is not locked.

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

Template copy: [`.env.production.template`](../../.env.production.template)

### 5) Upload and deploy (Live — hPanel)

1. Upload **`MyStudioChannel-deploy.zip`** (drag-and-drop or file manager).
2. **Deploy** / trigger build.
3. Wait for build (~**56–90 seconds** typical).
4. **Restart** Node app if hPanel does not auto-restart.

### 6) Verify live

**Incognito:**

- `https://mystudiochannel.com/` — Next.js site (not WordPress / `wp-content`)
- Footer: **`MyStudioChannel v3.0.0`**
- `https://mystudiochannel.com/admin` — Payload login
- After login: sidebar **`MyStudioChannel Admin v3.0.0`**

**Local smoke script:**

```powershell
npm run verify:live
```

---

## Path B — FTPS update (`pushit:live`)

For **ongoing updates** after first live deploy. **Local (PC repo root)** only.

```powershell
npm run pushit:live
```

Pipeline: **`npm run build`** (briefly sets live `NEXT_PUBLIC_SERVER_URL`) → **`pushitup:admin-ui`** → **`.next`** → **`payload.sqlite`** → **`public/media`**.

Then **Live (hPanel):** Stop → wait → Start Node app.

See [Go-Live-Checklist.md](./Go-Live-Checklist.md) for tier tables and recovery steps.

**Before Tier 2 upload (Live Terminal, optional):**

```bash
cd /home/u942711528/domains/mystudiochannel.com/public_html
rm -rf .next
rm -f payload.sqlite-wal payload.sqlite-shm
```

Adjust `cd` path to your hPanel app root if different.

---

## Path C — Daily updates (after first deploy)

Once your site is live, use these methods for ongoing updates. **Full reference:** this section. **Quick card:** [START-HERE.md](./START-HERE.md) → *Pushing updates live*.

### Quick reference: three update methods

| Method | Command | When to use | Time | Restart needed? |
|--------|---------|-------------|------|-----------------|
| **FTPS (recommended)** | `npm run pushit:live` | Daily changes (CSS, components, images, admin UI) | ~2–3 min | Yes — hPanel |
| **Git push + rebuild** | `git push origin main` | Major updates, new packages, when FTPS is not enough | ~5–6 min | Usually auto |
| **Hostinger MCP** | Ask Cursor | Testing, automated deploys | Varies | Yes — hPanel |

---

### Method 1: FTPS — `npm run pushit:live` (fastest for daily updates)

**What it uploads (Local → Live via FTPS):**

- **`pushitup:admin-ui`** — Payload admin sources (middleware, branding, config, etc.)
- **`.next/`** — production build
- **`payload.sqlite`** — local CMS database
- **`public/media/`** — on-disk media assets

**What it does NOT upload (manage separately):**

- **`node_modules/`** — host keeps its own install
- **`package.json` / `package-lock.json`** — use **`npm run pushitup:server-config`**, zip deploy, Git rebuild, or hPanel Terminal **`npm install --legacy-peer-deps`**

**Note:** `pushit:live` runs **`npm run build`** internally (live `NEXT_PUBLIC_SERVER_URL` for that step only). Running build first is still recommended for pre-flight.

**Step-by-step (Local — repo root):**

```bash
# 1. Pre-flight (optional but recommended)
npm run build
npm run verify:local

# 2. Push live (includes build + FTPS upload)
npm run pushit:live

# 3. Live (hPanel) → Restart Node.js app
```

Safer variant: **`npm run pushit:live:safe`** — runs **`verify:local`** first, then full **`pushit:live`**.

**After adding new npm packages:** update **`package.json`** on the server (zip, Git rebuild, or **`pushitup:server-config`** + **`npm install --legacy-peer-deps`** on host). FTPS alone will **not** install new dependencies.

---

### Method 2: Git push + Hostinger rebuild

If your Hostinger Node.js app is connected to GitHub:

```bash
git push origin main
```

Hostinger will typically:

1. Pull latest code
2. Run **`npm install`** (production)
3. Run **`npm run build`**
4. Restart the app

**Best for:** new dependencies, major changes, or when FTPS fails.

**Reminder:** apply **The Canonical Rule** — packages imported in app/CSS must be in **`dependencies`**, or the host build will fail.

---

### Method 3: From Cursor (Hostinger MCP)

Tell Cursor:

> Use the Hostinger MCP to deploy my latest changes to mystudiochannel.com

The MCP can upload a source zip and trigger a server-side build (`hosting_deployJsApplication`).

**Best for:** automated workflows, testing, first deploy–style refreshes without FTPS.

**MCP cannot set environment variables** — set those in hPanel UI.

---

### Pre-update checklist (before any method)

| Step | Command | Why |
|------|---------|-----|
| 1 | `npm run build` | Verify build passes locally |
| 2 | `npm run verify:local` | Test all local endpoints |
| 3 | `npm ls --omit=dev --depth=0` | Audit production deps ([DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md)) |
| 4 | `git status` | Ensure clean working tree (or know what you're shipping) |

---

### Post-update verification

After any update:

```bash
# Local smoke test (optional)
npm run verify:live
```

**Manual checks (Incognito):**

- [https://mystudiochannel.com](https://mystudiochannel.com)
- [https://mystudiochannel.com/admin](https://mystudiochannel.com/admin)
- Footer shows correct version (**`MyStudioChannel v3.0.0`**)

---

### Troubleshooting common update issues

| Issue | Likely cause | Fix |
|-------|--------------|-----|
| Changes not showing | Forgot to restart Node app | Restart in hPanel |
| Missing CSS | `tw-animate-css` not in **`dependencies`** | Move to **`dependencies`**, rebuild, redeploy |
| API 500 errors | Env vars missing | Check hPanel environment variables |
| Build fails on host | Missing package in **`dependencies`** | **`npm ls --omit=dev --depth=0`** to audit |
| Old content showing | Browser cache | Hard refresh (Ctrl+Shift+R) or Incognito |
| Vendor-chunk 500 | Stale **`.next`** on host | Remove **`.next`** on host; re-upload full **`.next`** after local build |

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
npm run build && npm run verify:local

# Push live (FTPS)
npm run pushit:live

# Then in hPanel: Restart Node.js app

# Check live health
npm run verify:live
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

---

## Successful live update protocol (numbered)

| Step | Where | Action |
|------|--------|--------|
| 1 | **Local** | Dependency audit: `npm ls --omit=dev --depth=0` |
| 2 | **Local** | `npm run build` + `npm run verify:local` |
| 3 | **Local** | Zip deploy **or** `npm run pushit:live` |
| 4 | **Live (hPanel)** | Set / verify environment variables |
| 5 | **Live (hPanel)** | Deploy or wait for FTPS upload to finish |
| 6 | **Live (hPanel)** | **Restart** Node.js application |
| 7 | **Local** | `npm run verify:live` + Incognito check `/` and `/admin` |

**Do not run on Hostinger Terminal:** `pushitup`, zip creation, or `git pull` from your PC workflow unless you explicitly maintain server-side git.

**Run on Hostinger Terminal only when needed:** `npm install --legacy-peer-deps` (if `package.json` / lockfile / `patches/` changed), `rm -rf .next`, `rm -f payload.sqlite-wal payload.sqlite-shm`, SQLite maintenance.

---

## Ground rules

1. Secrets only in **hPanel env** and **`.env.local`** — never in git.
2. **`payload.sqlite`** is shipped on first deploy; avoid overwriting production DB from PC unless intentional.
3. **`PAYLOAD_DISABLE_SHARP=true`** on Hostinger.
4. Production URLs must be **`https://mystudiochannel.com`** (both `NEXT_PUBLIC_*` and `PAYLOAD_PUBLIC_*`).
5. After deploy, confirm version labels: **`MyStudioChannel v3.0.0`** / **`MyStudioChannel Admin v3.0.0`**.

---

*Last updated: 2026-06-01 — Path C daily updates; first successful zip deploy to mystudiochannel.com*
