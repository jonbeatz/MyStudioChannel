# Hostinger Deployment — Fixes & Learnings

## Date: 2026-06-01
## Status: SUCCESSFUL — [https://mystudiochannel.com](https://mystudiochannel.com)

First production deploy: replaced temporary WordPress with Next.js 15 + Payload CMS 3 on Hostinger Node.js.

**Full guide:** [HOSTINGER-DEPLOY.md](./HOSTINGER-DEPLOY.md)

---

## The Canonical Rule

> **If it's imported in app code** (CSS `@import`, TS/TSX `import`, PostCSS plugin), **it must be in `dependencies`, not `devDependencies`.**

**Why:** Hostinger runs **`npm install --production`** before **`npm run build`** — **`devDependencies` are never installed on the server.**

### Pre-deploy check (Local — repo root)

```bash
npm ls --omit=dev --depth=0
```

This lists only what Hostinger will actually install. If a build-time import is missing from that list → move it to **`dependencies`** before zipping or pushing live.

---

## Issues encountered & resolved

| Issue | Error | Fix |
|-------|-------|-----|
| Missing PostCSS | `Cannot find module '@tailwindcss/postcss'` | Move `@tailwindcss/postcss` and `postcss` from `devDependencies` → `dependencies` |
| Missing tw-animate-css | `Can't resolve 'tw-animate-css'` | Move `tw-animate-css` to `dependencies` (used in `app/globals.css`) |
| Lockfile mismatch | npm vs pnpm on host | Use **npm** only; delete `pnpm-lock.yaml`; ship `package-lock.json` |
| SQLite sidecars in zip | Stale / locked DB | Stop dev server before zipping; exclude `payload.sqlite-wal` / `-shm` |
| WordPress still live | `wp-content` in HTML | Complete Node.js deploy; env vars + restart |
| MCP env vars | Build OK but API 500 | Set all vars in **hPanel UI** (MCP cannot set env) |

---

## Root cause: `devDependencies` on Hostinger

See **The Canonical Rule** above. In short: anything needed at build time must ship in **`dependencies`**.

**Current production CSS deps (2026-06-01):**

- `@tailwindcss/postcss`
- `postcss`
- `tw-animate-css`

(`tailwindcss` may remain in `devDependencies` if pulled transitively by `@tailwindcss/postcss` — if Hostinger fails on `@import 'tailwindcss'`, move `tailwindcss` to `dependencies` too.)

---

## Verified working configuration

| Setting | Value |
|---------|--------|
| Node version | 22.x (20.x verified via MCP) |
| Package manager | npm |
| Build command | `npm run build` |
| Output directory | `.next` |
| Build time | ~56–90 seconds |
| Static pages | 7 generated |
| Live footer | `MyStudioChannel v8.0.0` |
| Live admin label | `MyStudioChannel Admin v8.0.0` |

---

## Environment variables (required in hPanel)

| Variable | Value |
|----------|--------|
| `NODE_ENV` | `production` |
| `PAYLOAD_SECRET` | 32+ char secret (from `.env.local`) |
| `DATABASE_URL` | `file:./payload.sqlite` |
| `NEXT_PUBLIC_SERVER_URL` | `https://mystudiochannel.com` |
| `PAYLOAD_PUBLIC_SERVER_URL` | `https://mystudiochannel.com` |
| `RESEND_API_KEY` | from Resend |
| `PAYLOAD_DISABLE_SHARP` | `true` |

---

## Quick reference commands (Local — repo root)

**Stop dev before zip:**

```powershell
node scripts/msc-kill-dev-port.mjs
```

**Audit production deps:**

```powershell
npm ls --omit=dev --depth=0
```

**Build gate:**

```powershell
npm run build
npm run msc:verify:local
```

**Create deploy zip** (output: `zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip`):

Use robocopy staging so nested `node_modules` / `.next` are excluded — see [HOSTINGER-DEPLOY.md](./HOSTINGER-DEPLOY.md) § Path A step 2. Simple top-level `Compress-Archive` is **not** safe for nested folders.

**Live smoke:**

```powershell
npm run msc:verify:live
```

---

## Deployment flow that worked (zip)

1. Fix `package.json` dependencies
2. `npm install` + `npm run build` locally
3. Stop dev server
4. Create `MyStudioChannel-deploy.zip` (~66 MB)
5. Upload to Hostinger hPanel
6. Set environment variables
7. Deploy → wait for build
8. Restart Node app
9. Verify in Incognito

---

*Append new rows to the issues table when live deploys teach something new.*
