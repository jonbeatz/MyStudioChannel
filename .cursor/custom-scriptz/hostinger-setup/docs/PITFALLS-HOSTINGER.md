# Hostinger pitfalls — lessons learned (portable)

Symptom → cause → fix. Keep this file when moving the module to new projects.

---

## 503 Service Unavailable

| Cause | Fix |
|-------|-----|
| Missing `next/dist/compiled/webpack` | `npm run msc:hostinger:npm-install` → Restart Node |
| Missing `.builds/config/preload-timestamp.js` | `npm run msc:hostinger:recover` → Restart Node |
| Code only in staging, not live root | `npm run msc:hostinger:sync-app` or full deploy → Restart |
| `payload.sqlite` ~4 KB stub on server | `npm run msc:push:db:live` → Restart |

---

## Fast deploy (`pushit:live:fast`)

| Mistake | Symptom | Fix |
|---------|---------|-----|
| Assumed DB ships by default | Live CMS stale | Use **`-WithDb`** flag |
| Bash `'$STAGING'` quoting bug | 45 min FTPS fallback | Fixed in `msc-hostinger-unzip-deploy-next-ssh.mjs` — check `logs/pushit-unzip-last.log` |
| `package.json` not uploaded | Version label wrong on live | Fast path uploads `package.json` in step 4 |
| Zip uploaded to `zips/` on remote | missing deploy-next.zip | Upload repo-root **`deploy-next.zip`** only |
| Skipped `sync-app` | New `.next` in staging only | Always run sync-app in pipeline |
| Restart too early | 503 / half-updated | Wait for script completion message |

**Preflight:** `npm run msc:hostinger:deploy-diagnose`

---

## API 500 on `/api/*`

- Local DB good, live stub → **Quick DB** (`msc:push:db:live`)
- After deploy: remove WAL on server if needed: `rm -f payload.sqlite-wal payload.sqlite-shm`

---

## MCP zip deploy

- **Avoid on Hostinger shared Node** — `better-sqlite3` compile often fails
- MCP zip ≠ DB deploy even if zip contains sqlite
- Prefer **Fast FTPS** or **Full FTPS**

---

## npm on server

- Manual hPanel install: **`npm install --legacy-peer-deps --ignore-scripts`** only
- Plain `npm install` can break webpack preload

---

## Local dev after deploy

- Production `.next` on PC can break `next dev` → `npm run dev:fresh` or `dev:recover`

---

## WAL / SQLite

- Copy DB with deploy scripts; on server delete `payload.sqlite-wal` and `payload.sqlite-shm` if lock errors
- Never commit live `payload.sqlite` unless project policy says so
