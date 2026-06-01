# Hostinger Deployment — MyStudioChannel

**Live site:** [https://mystudiochannel.com](https://mystudiochannel.com)  
**Project root (Local):** `D:\Cursor_Projectz\MyStudioChannel`  
**Branch:** `MSC-Website-v3`  
**Stack:** Next.js 15 + Payload CMS 3 + SQLite · entry **`server.js`** (Hostinger may auto-detect **`next start`** for Next.js preset)

**Related:** [DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md) (2026-06-01 learnings) · [Go-Live-Checklist.md](./Go-Live-Checklist.md) · [`.env.production.template`](../../.env.production.template)

**hPanel:** [https://hpanel.hostinger.com/](https://hpanel.hostinger.com/)

---

## Two deploy paths (pick one)

| Path | When | Where it runs |
|------|------|----------------|
| **A — Zip upload (first deploy / full refresh)** | First Node.js setup, replacing WordPress, or when FTPS is not configured | **Local:** build zip → **Live (hPanel):** drag-and-drop → Deploy |
| **B — FTPS `pushit:live` (updates)** | Day-to-day updates after initial live setup | **Local:** `npm run pushit:live` → **Live (hPanel):** restart Node |

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

Hostinger runs **`npm install --production`** (or production-equivalent install) before **`npm run build`**. Packages in **`devDependencies` are not installed** on the server.

**Rule:** Any package **imported in app code** (CSS `@import`, TS/TSX `import`, PostCSS plugins) **must** be in **`dependencies`**, not `devDependencies`.

**Required in `dependencies` (as of 2026-06-01):**

| Package | Why |
|---------|-----|
| `@tailwindcss/postcss` | PostCSS plugin in `postcss.config.mjs` |
| `postcss` | Build pipeline |
| `tw-animate-css` | `@import 'tw-animate-css'` in `app/globals.css` |

**Audit before every zip deploy:**

```powershell
npm ls --omit=dev --depth=0
```

If build fails with **`Cannot find module '…'`** or **`Can't resolve '…'`**, move that package from `devDependencies` → `dependencies`, run `npm install`, rebuild, recreate zip.

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

*Last updated: 2026-06-01 — first successful zip deploy to mystudiochannel.com*
