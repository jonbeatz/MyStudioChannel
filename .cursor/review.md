# REVIEW — Audit follow-up & tomorrow’s work queue

**Saved:** 2026-06-11  
**Branch:** `MSC-Website-v7` (active @ `5596b56`) · `main` synced @ `5596b56` · `MSC-Website-v6` frozen @ `c9e260e`  
**Audit:** Phases 1–4 complete (committed + pushed)  
**Project score (analysis):** **86 / 100**

---

## Completed 2026-06-11

- GitHub CI (`verify:next` + Playwright) on push to `MSC-Website-v7` / `main`
- **Playwright CI fix** — wait for Payload admin login fields + `wait-for-dev-admin.mjs` @ `112acc5`
- Admin bundle snapshot (`@next/bundle-analyzer`) — **816 kB** baselined
- Parameterized `msc-audit-docs.mjs` (dynamic git branch)
- Playwright smoke tests integrated into `verify:local` + CI
- Deploy tables consolidated into canonical source (`HOSTINGER-DEPLOY.md`)
- Removed `motion`, added missing deps (`file-type`, `image-size`, `node-fetch`, **`@payloadcms/ui`**)
- **depcheck** — `@payloadcms/ui` declared in `package.json` (no missing-deps warning)
- Codeburn run (token usage reviewed)
- ISSUES-RESOLVED v6.0.0 historical annotation — **`msc:docs:sync`** PERFECT (0 warnings)
- `NODE_ENV=development` in `.env.local`
- Docs sync closeout @ `ac79160`; CI fix @ `112acc5`; deps + final hygiene @ `5596b56` (pushed to origin)

---

## Audit completion summary

| Phase | Done | Commit |
|-------|------|--------|
| Phase 1 | Read-only 6-section report | — |
| Phase 2 | UI patch, `/test` middleware, `sync-app --skip-db`, deploy alias, SSH preflight, `db:copy` trigger | `9d9831f` |
| Phase 3 | Bulk `msc:*` doc sync, SoT alignment, sentry-test prod gate, doctor secret warning | `9d9831f` |
| Phase 4 | Rules dedup, Restore-Points trim (3 + archive), Sentry pin, MCP sync extension, SectionsRenderer keys | `9d9831f` |

**Verification at close:** `verify:next:safe` PASS · `msc:docs:sync` PERFECT SYNC · backup `msc-website-v2-d` @ `9d9831f`

---

## Score breakdown (reference)

| Pillar | Score |
|--------|-------|
| Documentation & agent ops | 94 |
| Deploy & live reliability | 88 |
| Codebase quality | 82 |
| Developer ergonomics | 85 |
| Production readiness | 80 |
| Security hygiene | 84 |
| **Overall** | **86** |

---

## Tomorrow — recommended order

### A. Close the v7 live loop — **done 2026-06-08**

1. ~~Deploy v7 labels live~~ — **`pushit:live:fast -- -WithDb`** completed
2. ~~Verify live~~ — **`msc:verify:live:version`** **v7.0.0** pass
3. ~~Deploy zip fix~~ — **`2404cc0`** (no more ~45 min fallback when zip path OK)
4. ~~Git parity~~ — **`main`** @ **`5596b56`**; dev on **`MSC-Website-v7`**

### B. Quick hygiene — **done 2026-06-11**

| Task | Status |
|------|--------|
| ~~Add `NODE_ENV=development` to `.env.local`~~ | **Done** |
| ~~Decide **`payload.sqlite` git policy**~~ | **Done** — tracked @ **`14ceb53`**; use **`-WithDb`** when live DB must match local |
| ~~Run **`msc:codeburn`**~~ | **Done** (2026-06-11); rerun weekly |
| ~~Run **`depcheck`**~~ | **Done** — `motion` removed; missing deps added incl. **`@payloadcms/ui`** |

### C. Medium-term improvements — **done 2026-06-11**

| Task | Status |
|------|--------|
| ~~**GitHub CI:** `verify:next` on push~~ | **Done** — **`MSC-Website-v7`** + **`main`** @ `5596b56` |
| ~~**Parameterize `msc-audit-docs.mjs`**~~ | **Done** |
| ~~**Admin bundle snapshot**~~ | **Done** — **816 kB** baselined via **`analyze`** |
| ~~**Playwright smoke**~~ | **Done** — `verify:local` + CI; admin login wait fix @ `112acc5` |
| ~~**Merge deploy tables**~~ | **Done** — canonical table in **HOSTINGER-DEPLOY.md** |

> **Optional later:** CI on frozen **`MSC-Website-v6`** only if hotfixing v6 again.

### D. Strategic (not tomorrow unless blocked)

| Task | Notes |
|------|-------|
| Postgres migration path | Only when SQLite concurrency/editor pain appears |
| CDN for `/media` | If Lighthouse/image weight becomes an issue |
| Obsidian → ReCall weekly distill | Manual Friday ritual at `I:\Vader_Vault` |
| Portable studio kit | See **`.cursor/ideaz.md`** |

---

## Audit “next steps” still open (non-blocking)

These were identified in Phases 1–4 but intentionally deferred:

- **Admin First Load JS (~816 kB)** — Payload/Lexical/Sentry; baselined @ `112acc5`; separate pass if slimming needed
- **Consolidate homepage admin routes** — **done** — canonical **`/admin/msc-homepage`**; redirects in **`next.config.mjs`** (documented in TRUTH)
- **`eslint.ignoreDuringBuilds`** — **done** — documented in TRUTH Build Notes
- **`images.unoptimized`** — intentional for Hostinger; documented in `next.config.mjs`
- **Extend MCP sync** for any new project MCPs as added — 21st + browserbase done in Phase 4
- **Restore-Points:** append new row after next major milestone (keep 3 active rule)

---

## What NOT to change (confirmed good)

- SQLite while traffic/modest — don’t migrate preemptively
- Doc hierarchy (TRUTH → START-HERE → MASTER-COMMANDS) — working
- MCP count (6 project + 12 global) — don’t add browsers
- Webpack dev default (not Turbopack) — required for Payload patches
- Fast deploy default `--skip-db` — keep; use `-WithDb` / full push when CMS data must ship

---

## Doctor snapshot (2026-06-07 evening)

```
✅ Node v24.14.0
⚠️ NODE_ENV missing in .env.local  ← fixed 2026-06-11
⚠️ payload.sqlite small + WAL (dev server running)
⚠️ Port 3000 in use (expected)
⚠️ Uncommitted payload.sqlite
⚠️ LiteLLM offline (optional)
✅ System Healthy
```

---

## Session prompts for tomorrow

| Say this | Intent |
|----------|--------|
| **Start Project** | Cold start + doctor + branch status |
| **push it live** | AskQuestion: Quick DB · Fast FTPS · Full · MCP avoid |
| **Postflight local** | `verify:next:safe` + HTTP smoke |
| **update docs** | After deploy or doc edits |

---

## Links

- Portable kit ideas: [`.cursor/ideaz.md`](./ideaz.md)
- Constitution: [`TRUTH.md`](../TRUTH.md)
- Checkpoint: [`.cursor/docs/Checkpoint.md`](./docs/Checkpoint.md)
- Issues log: [`.cursor/docs/ISSUES-RESOLVED.md`](./docs/ISSUES-RESOLVED.md)

---

*Last updated: 2026-06-11 @ `5596b56`.*
