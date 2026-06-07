# Go Live Checklist (Local -> Live)

Use this when you want to move local development changes to `https://mystudiochannel.com` safely.

Project root:
- `D:\Cursor_Projectz\MyStudioChannel`

---

## 0) Optional quick pre-check

Custom prompt shortcuts:
- `Lets run system check` (local + live + FTP + repo)
- `Lets test Local`
- `Lets test Live`
- `Lets test FTP`

Run these from your PC terminal in repo root:

```bash
npm run verify:local
npm run verify:live
npm run test:hostinger-ftp
npm run verify:ftp-smoke
```

**FTPS path sanity:** **`.vscode/sftp.json`** **`remotePath`** for Hostinger FTPS is usually **`/`** — not a nested home folder — or **`PushItUP`** writes under the wrong nested folder (see **HOSTINGER-DEPLOY.md** § FTP). **`npm run verify:ftp-smoke`** must pass before you trust a full **`.next`** upload.

**Post-upload sanity checks (do not skip):**
- Live app root should contain **one** `.next` folder (not `/.next/.next` nesting).
- Live `payload.sqlite` size should be roughly in the same range as local; if live is far smaller/older, CMS content will drift (wrong demos, admin route issues).
- If `.next` upload reports unexpectedly tiny file counts after a recovery reset, run `npm run build` again and re-upload full `.next`.

If local is broken, run:

```bash
npm run dev:fresh
```

---

## 0.5) Production dependency check (PC — before zip or first deploy)

Hostinger runs **`npm install --production`** before **`npm run build`**. Anything imported in app code, CSS, or PostCSS must be in **`dependencies`**, not **`devDependencies`**.

```powershell
npm ls --omit=dev --depth=0
```

**Known required packages (2026-06-01):** `@tailwindcss/postcss`, `postcss`, `tw-animate-css`.

If Hostinger build fails with **`Cannot find module '…'`** or **`Can't resolve '…'`**, move that package to **`dependencies`**, run **`npm install`**, rebuild, and redeploy.

**Lockfile:** use **npm** + **`package-lock.json`** only — remove **`pnpm-lock.yaml`** from the deploy bundle.

Details: **DEPLOYMENT-FIXES.md** · **HOSTINGER-DEPLOY.md** → *Path A step 1* · *Path C* for ongoing updates.

---

## 1) Build locally (PC)

Custom prompt shortcut:
- `Lets Push It Live (Safe)` (runs preflight verify first, then deploy if pass)

From repo root:

```bash
npm run build
```

Wait until build completes successfully.

---

## 2) Upload to Hostinger (PC) — tiered deploy

**Shortcuts (see `Prompt-Cheat-Sheet.md`):** **`Push my branding`** (item **37**) · **`Lets Push It Live`** (items **3** / **38**) · **`Push server config`** (item **39**).

**Before / alongside upload:** confirm marketing assets are present locally under **`public/media`** (that folder is what the live site serves as **`/media/...`**). If you added or replaced files there, commit them and ensure they are included in what you deploy; missing **`public/media`** files on the server means broken images even when **`.next`** is healthy.

### Deploy tiers (pick one path)

| Tier | Name | Command (Local / repo root) | What it ships | When to use |
|------|------|----------------------------|---------------|-------------|
| **1** | **Branding — Fast FTP** | `npm run pushitup:admin-branding` | **Only:** `components/msc-payload-graphics.tsx`, `components/msc-payload-admin-enhancements.tsx`, `collections/Users.ts`, `payload.config.ts`, `app/(payload)/custom.scss` | Quick look-and-feel / config / SCSS tweaks; **no** `build` or `.next` in this step. |
| **2** | **Admin logic / pages — Full build + UI + `.next` + DB + media** | `npm run pushit:live` | **`npm run build`** (live **`NEXT_PUBLIC_SERVER_URL`** for that step) → **`npm run msc:pushitup:admin-ui`** → **`npm run pushitup -- .next`** (or manual **FileZilla** full **`.next`** per **HOSTINGER-DEPLOY.md**) → **`npm run pushitup -- payload.sqlite`** → **`npm run msc:hostinger:sync-db`** → **`npm run pushitup -- public/media`** → optional **`npm run dev:fresh`** only if **`PUSHIT_LIVE_RUN_DEV_FRESH=1`** | Default for anything that must match compiled Next output and ship the local SQLite + on-disk **`public/media`** (routes, React admin UI, CMS data, `/media/*` assets). **Master** deploy. |
| **3** | **Hosting — server / package config** | `npm run pushitup:server-config` | **`server.js`**, **`package.json`**, **`package-lock.json`**, **`.env.example`** | Deps, lockfile, startup file, or documented env template changed; follow **§5** for **`npm install`** on the host. |

**Tier 2** is the **full** pipeline: it uploads the **admin source bundle**, the **entire `.next`** output, **`payload.sqlite`**, and **`public/media`** so the live app, **`/admin`**, CMS data, and **`/media/...`** files stay consistent.

**Tier 1** does **not** run `build` — use **Tier 2** when the admin bundle or site needs to reflect new compiled code.

### Standard one-command deploy (Tier 2)

```bash
npm run pushit:live
```

This is exactly: **`build`** → **`msc:pushitup:admin-ui`** → **`pushitup -- .next`** → **`pushitup -- payload.sqlite`** → **`msc:hostinger:sync-db`** → **`pushitup -- public/media`** (see `scripts/pushit-live.ps1`). Local **`dev:fresh`** runs only when **`PUSHIT_LIVE_RUN_DEV_FRESH=1`**. **FTPS:** brief connection errors on 1–2 files during **`.next`** upload are common; **PushItUP** retries once.

**`pushitup:admin-ui`** includes (among others): `middleware.ts`, `lib/msc-app-version.ts`, `components/msc-payload-nav-dashboard.tsx`, `components/msc-payload-nav-logout.tsx`, branding components, `collections/Users.ts`, `payload.config.ts`, `app/(payload)/custom.scss`. After deploy, confirm **`MyStudioChannel Admin v5.0.0`** in the sidebar (matches **`package.json`** **`version`**).

A full **`.next`** upload is what fixes many **vendor-chunk** / missing-module errors on the host; if the browser shows **`Cannot find module './vendor-chunks/...'`** or similar after a deploy, re-run **`npm run pushitup -- .next`** (after a successful local **`npm run build`**) so chunk paths stay in sync.

### If upload reports failures

If `PushItUP` ends with failures, re-upload failed paths before restart.

Common retry:

```bash
npm run pushitup -- .next/static/chunks .next/server/chunks .next/server/webpack-runtime.js
```

Or upload the whole build output again:

```bash
npm run pushitup -- .next
```

---

## 3) Restart app in hPanel

Custom prompt helper:
- `Lets Push It Live` returns the exact next restart step + links

In Hostinger hPanel Node.js app page for `mystudiochannel.com`:
1. Stop
2. Wait 5 seconds
3. Start

---

## 4) Validate live

Custom prompt shortcuts:
- `Lets Verify Live`
- `Lets test Live`

Check in Incognito:
- `https://mystudiochannel.com/`
- `https://mystudiochannel.com/admin`

Optional command check:

```bash
npm run verify:live
```

---

## 5) Only when dependencies changed

Custom prompt helper:
- `Lets Push It Live (Safe)` (good before dependency-sensitive deploys)
- **`Push server config`** (item **39**) to upload **`package.json`**, **`package-lock.json`**, **`server.js`**, **`.env.example`** before install

Use Hostinger Terminal only if `package.json`, lockfile, or `patches/` changed.

```bash
npm install --legacy-peer-deps
```

Then restart Node app again.

---

## 6) Emergency recovery (live 500)

Custom prompt helper:
- `Pre-deploy risk check for current changes` (before pushing risky fixes)

If live shows `Cannot find module './vendor-chunks/...` or other **chunk / vendor** runtime errors, the fix is a **clean rebuild + full `.next` upload** on the PC (and **`public/media`** must still be deployed with the app so **`/media/...`** assets exist on the server—verify **`public/media`** under your app path on the host if images are broken).

1. Stop app in hPanel
2. In Hostinger terminal:

```bash
rm -rf .next
```

3. On **PC (repo root)** — rebuild, then upload the full **`.next`** folder (this is the primary fix for vendor-chunk mismatches):

```bash
npm run build
npm run pushitup -- .next
```

If **`/media/`** images are wrong or 404 after deploy, sync **`public/media`** to the host (same relative path under the app root) or re-run your usual upload so **`public/media`** is not missing.

4. Start app in hPanel
5. Re-test live

---

## Ground rules

- Run `pushitup` on PC terminal, not Hostinger Terminal.
- For app/admin code changes, prefer **Tier 2** (`pushit:live`): full build + full `.next` upload.
- Do not partially upload random files in `.next` unless recovering failed chunk uploads.

---

## Prompt-first quick flow (copy/paste friendly)

Use this if you want to run go-live mostly by prompt commands:

1. `Lets run system check`
2. Choose tier:
   - **Branding-only FTP:** `Push my branding` (item **37**) → restart Node in hPanel.
   - **Full app + admin:** `Lets Push It Live` (items **3** / **38**) or `Lets Push It Live (Safe)` — then restart Node.
   - **Deps / server files:** `Push server config` (item **39**) → Hostinger Terminal **`npm install --legacy-peer-deps`** → restart Node.
3. Restart Node app in hPanel when you uploaded anything that affects runtime (Stop -> wait -> Start)
4. `Lets Verify Live`
5. Optional: `Lets Checkpoint Docs` (docs only) or `Lets Checkpoint Docs + Commit`
