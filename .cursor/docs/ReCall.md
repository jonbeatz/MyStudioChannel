# ReCall — Working Memory

Quick-running memory for recent changes, current focus, and next ideas.
Use this when returning after a break.

---

## Session Resume Prompt (copy/paste)

Use this at the start of a new session:

```text
Continue from ReCall.

1) Read docs in this order first:
   - `.cursor/docs/Agent-Runbook.md`
   - `.cursor/docs/HOSTINGER-DEPLOY.md`
   - `.cursor/docs/ReCall.md`
   - `.cursor/docs/Development.md`
2) Give me a quick resume using this format:
   - Done
   - Next
   - Open Questions
3) Start local dev runtime:
   - run install only if needed (`npm install`)
   - run `npm run dev:payload` (or `npm run dev` — same as `next dev`; webpack is default on Next 15, avoid `--turbo`)
   - confirm Local URL at dev root (`http://localhost:3000/`) and `/admin` if testing Payload
4) Then start implementation for: <PASTE TODAY'S TASK HERE>
5) As you work, update ReCall with any major changes, bug fixes, or decisions.
6) When I say "I'm done for now" or "continue later", append a short closeout to ReCall and confirm it was saved.
7) On goodbye, stop local dev listeners (e.g. Node on ports 3000-3010) and confirm ports are clear.
```

Quick variants:

- **General resume:** `Do a ReCall on this project and propose the next 3 actions.`
- **Backend phase:** `Continue from ReCall and wire WordPress backend phase 1.`
- **UI polish phase:** `Continue from ReCall and finish UI polish pass for <section>.`

## Git Quick Reference (checkpoint + restore branch)

Use this mini-flow any time you want a safe checkpoint:

1. `git status -sb`
2. `git diff -- .`
3. `git add -A`
4. `git commit -m "clear outcome message"`
5. `git push`

Create a new restore branch from the current clean state:

1. `git checkout -b <branch-name>`
2. `git push -u origin <branch-name>`
3. `git status -sb` (confirm tracking branch)

---

## How to use this file

- Ask: **"Do a ReCall on this project"** to quickly summarize recent work.
- Keep updates short and practical (what changed, why, where).
- Add one entry per notable session.
- For production deploy/connectivity steps on Hostinger, see **`HOSTINGER-DEPLOY.md`** in this same docs folder.

---

## Deployment docs ↔ `package.json` (keep in sync)

**Source of truth for npm deploy aliases:** root **`package.json`** (`pushitup`, **`msc:pushitup:admin-ui`**, **`msc:pushitup:admin-branding`**, **`pushit:live:fast`**, **`pushit:live`**, **`msc:pushit:live:safe`**, etc.).

These operator docs should match those scripts whenever deploy behavior changes:

1. **`Jedi-List.md`** — command cheat sheet and Deploy uploaders table  
2. **`HOSTINGER-DEPLOY.md`** — Path A/B/C, PC vs hPanel protocol  
3. **`DEPLOYMENT-FIXES.md`** — canonical dependency rule and deploy learnings  
4. **`Go-Live-Checklist.md`** — local → live flow and branding file lists  
5. **`Prompt-Cheat-Sheet.md`** — shortcuts including **Push my branding** (item **37**)

If **`package.json`** scripts change, update the five docs in the same commit when possible.

**Release version / admin bundle (2026-06-01):** Bump root **`package.json`** `"version"` only. **`msc:pushitup:admin-ui`** ships **`lib/msc-app-version.ts`** + **`components/msc-payload-nav-logout.tsx`** (see **`package.json`** script). Older log entries may mention **`msc-admin-version.ts`** — historical only.

**MCP / GitHub tooling scripts** (`msc:sync:mcp-env`, `msc:sync:mcp-all`, `msc:test:github-api`, `msc:test:tavily-api`, `msc:backup:github-repos`): keep **`Jedi-List.md`**, **`MCP-SETUP.md`**, and **`.env.example`** in sync.

---

## Current focus

- **Payload CMS:** **`globals/Homepage`** + **Media** (hero + **Programming Styles** / **Services Gallery** seven-slot rows, relationship **`appearance: 'drawer'`**, optional clear slot → static fallback); **`globals/Site settings`**; **Leads** / **Bookings**; static **Pages**; legal **`/privacy-policy`**, **`/terms-of-service`**.
- **Gallery hydration:** **`lib/cms/homepage-gallery-seed.ts`**, **`lib/cms/homepage-gallery-hydrate.ts`** (`afterRead` → full Media shape for admin + site).
- **Public URLs:** **`lib/public-origin.ts`** + **`lib/site-origin-defaults.ts`** — **`PAYLOAD_PUBLIC_SERVER_URL`** / **`NEXT_PUBLIC_SERVER_URL`** / **`MSC_CANONICAL_SITE_ORIGIN`**; **`getPublicOriginClient()`** for admin Client Components; **`payload.config.ts`** **`serverURL`** + env-built **CSRF**.
- **Marketing site:** Header/footer in-page hash scroll (mobile drawer defer); **`HomeHashScroll`**; **`middleware`** pathname-only rewrites (host-agnostic).
- **Version:** **`v8.0.0`** — sole source: root **`package.json`**; UI labels via **`lib/msc-app-version.ts`** (footer **`MyStudioChannel v8.0.0`**, admin **`MyStudioChannel Admin v8.0.0`**). Bump **`package.json`** only on release; see **`Jedi-List.md`** → *Release version*.
- **Live:** **`https://mystudiochannel.com`** — **v7.0.0** on host until next deploy; repo/local **v8.0.0**.
- **Deploy docs:** **`HOSTINGER-DEPLOY.md`**, **`DEPLOYMENT-TROUBLESHOOTING.md`** (§ fast deploy mistakes). **`-WithDb`** required for **`payload.sqlite`** on fast path. Zip unzip bug fixed — expect **~10–15 min**, not **~45 min** fallback.
- **Branches:** **`MSC-Website-v8`** (active dev); **`MSC-Website-v7`** frozen @ **`b4ab8ae`** (backup **`msc-website-v2-k`**); **`main`** tracks v8 line; **`MSC-Website-v6`** frozen @ `c9e260e`; **`MSC-Website-v5`** frozen at v5.0.0.
- **Git:** **`payload.sqlite`** tracked @ **`14ceb53`** (v7 CMS baseline for deploy seed); **`MSC-Website-v8`** @ **8.0.0**.
- **GitHub:** [releases](https://github.com/jonbeatz/MyStudioChannel/releases) **`v1.0.0`–`v8.0.0`**; **Latest = `v8.0.0`**.
- **CI:** **`.github/workflows/verify.yml`** — build + Playwright smoke on push (Node **22**); admin login wait fix @ **`112acc5`**.
- **Local preflight:** **`npm run verify:local`** (HTTP + Playwright); **`npm run analyze`** for admin bundle (~**816 kB**).
- **Agent tooling:** **MSC-UI-Taste** skill; project MCP **6 servers** (`browsermcp` + `antigravity` archived); Hostinger quartet via **`msc-hostinger-mcp.mjs`** launcher (scoped bins, no tool-naming warnings); MCP reload via **Settings → MCP**; **Obsidian** think layer at **`I:\Vader_Vault`** (ship layer = `.cursor/docs`).
- **Audit (2026-06-07):** Phases 1–4 complete @ **`9d9831f`** (pushed). **`.cursor/review.md`** audit queue closed 2026-06-11.
- **Hygiene (2026-06-11):** Complete on frozen **`MSC-Website-v7`** @ **`b4ab8ae`**; active dev on **`MSC-Website-v8`**.
- **Next ideas:** Feature work on **`MSC-Website-v8`**; portable kit from **ideaz.md** when starting new projects.

---

## Recent changes (latest first)

### 2026-06-11 — v8.0.0 release on MSC-Website-v8

- **`package.json`** → **8.0.0**; UI via **`lib/msc-app-version.ts`**; GitHub tag **`v8.0.0`**.
- **`MSC-Website-v7`** remains frozen @ **`b4ab8ae`** (v7.0.0 restore line).

### 2026-06-11 — MSC-Website-v8 branch cut

- **`MSC-Website-v8`** created from frozen **`MSC-Website-v7`** @ **`b4ab8ae`**.
- **Policy:** v7 frozen as restore line; backup **`msc-website-v2-k`**; **v8.0.0** in repo on **`MSC-Website-v8`**.
- **CI:** **`verify.yml`** runs on **`MSC-Website-v8`**, **`MSC-Website-v7`**, **`main`**.

### 2026-06-11 — Hygiene complete (audit queue closed)

- **CI fix @ `112acc5`:** Playwright waits for admin login fields; **`wait-for-dev-admin.mjs`**.
- **Deps @ `3d3cef7`:** **`@payloadcms/ui`** declared; review.md Sections B/C closed.
- **Final docs @ `5596b56`:** TRUTH build notes (eslint, homepage admin redirect); Restore-Points CI RP; codeburn **$2.58**/7d.
- **Tip:** **`MSC-Website-v7`** + **`main`** @ **`5596b56`** on origin.

### 2026-06-11 — Hygiene pass + docs:sync PERFECT

- **CI:** **`.github/workflows/verify.yml`** — `verify:next:safe` + Playwright smoke (Node **22**).
- **Local:** **`verify:local`**, **`test:smoke`**, **`analyze`**; deploy tables consolidated in **HOSTINGER-DEPLOY.md**.
- **Deps:** removed `motion`; added `file-type`, `image-size`, `node-fetch`.
- **Docs:** ISSUES-RESOLVED v6 historical annotation; **`msc:docs:sync`** 0 warnings. Tip @ **`6cb8c5a`**.

### 2026-06-08 — Git parity: main synced + payload.sqlite baseline

- **Commits:** **`2404cc0`** deploy zip fix + pitfalls docs; **`14ceb53`** **`payload.sqlite`** v7 CMS baseline.
- **Git:** **`main`** fast-forwarded to **`14ceb53`**; active dev stays on **`MSC-Website-v7`**.

### 2026-06-08 — pushit:live:fast zip path fix + v7 live deploy

- **Live:** **`pushit:live:fast -- -WithDb`** — v7 labels live; zip path failed once (bash quoting bug) → **~45 min** fallback; site healthy after.
- **Fix:** `msc-hostinger-unzip-deploy-next-ssh.mjs` — expand zip paths in Node (not `'$STAGING/...'`). Step 4 uploads **`package.json`** + lockfile. **`msc:hostinger:deploy-diagnose`**, **`logs/pushit-unzip-last.log`**. Shipped **`2404cc0`**.
- **Docs:** **DEPLOYMENT-TROUBLESHOOTING** § mistakes table; **ISSUES-RESOLVED** entry.

### 2026-06-08 — v7.0.0 release + MSC-Website-v7

- **Version:** **`package.json`** → **7.0.0**; UI via **`lib/msc-app-version.ts`**; GitHub tag **`v7.0.0`**.
- **Branch:** **`MSC-Website-v7`** active; **`MSC-Website-v6`** frozen @ **`c9e260e`**.
- **Backup:** Full **`msc-website-v2-f`** on `G:\` (MCP fixes note).
- **Live deploy:** completed — **`msc:verify:live:version`** expects **v7.0.0**.

### 2026-06-08 — Hostinger MCP launcher + docs sync

- **Fix:** **`scripts/msc-hostinger-mcp.mjs`** — scoped `hostinger-*` bins (not default 129-tool server); filters upstream `Node.js` tool names Cursor rejects.
- **Sync:** **`msc-sync-mcp-env.mjs`** copies launcher to `~/.cursor/scripts/` and rewrites global Hostinger entries.
- **Docs:** **MCP-SETUP**, **ISSUES-RESOLVED**, **START-HERE** — reload via **Settings → MCP** (optional **cursor-mcp-refresh** VSIX archived/uninstalled).
- **LiteLLM:** **`npm run msc:litellm:test:ngrok`** prints Cursor **Override OpenAI Base URL** + API key (`MSC_LITELLM_MASTER_KEY`); ngrok URL survives Cursor restart; stopped by **End Project** / **`msc:session:stop`**.

### 2026-06-07 — Planning docs + docs sync

- **Added:** `.cursor/ideaz.md` (portable `custom-scriptz` / bootstrap kit ideas) and `.cursor/review.md` (audit score 86/100, tomorrow queue).
- **Synced:** TRUTH, START-HERE, Checkpoint, CHANGELOG, ReCall, project-log.
- **Backup:** Quick backup `msc-website-v2-d` @ `9d9831f`.

### 2026-06-07 — Comprehensive audit Phase 4 — cleanup + optimizations

- **Rules:** `workflow.mdc` deploy section delegates to `global.mdc` + `deploy-safety-hostinger.mdc` (no duplicate mode lists).
- **Restore-Points:** 3 active rows; 44 archived to **`_archive/Restore-Points-historical.md`**.
- **Bundle/MCP:** `@sentry/nextjs` pinned **10.56.0**; `SectionsRenderer` uses **`rowInstanceUid`** keys; `msc:sync:mcp-env` syncs **21st-dev-magic** + **browserbase** from `.env.local`.

### 2026-06-07 — Comprehensive audit Phase 3 — docs alias sync (Option B)

- **Bulk sync:** `scripts/msc-sync-doc-commands.mjs` updated 36+ files to canonical **`msc:*`** npm names; fixed **`msc:msc:sync:mcp-env`** double-prefix in MCP docs.
- **SoT:** **Jedi-List** now matches **TRUTH** (TRUTH → START-HERE → …). **AGENTS.md** START-HERE path corrected.
- **Guardrails:** `/api/dev/sentry-test` returns **`notFound()`** in production; **`msc:doctor`** warns on weak **`PAYLOAD_SECRET`**.
- **Drift:** Doc alias matrix → **0** invalid `npm run` refs (Nova WP **`build:wp-theme`** noted as external).

### 2026-06-07 — Comprehensive audit Phase 2 — deploy safety + runtime fixes

- **Payload UI patch** regenerated; **`test`** added to middleware **`RESERVED_PATHS`**; **`msc:hostinger:sync-app --skip-db`** default for **`pushit:live:fast`**; SSH preflight on all hostinger scripts; **`deploy`** → **`pushit:live:fast`**.

### 2026-06-07 — Backup bloat fix: exclude zips/ + clean-zips retention

- **Issue:** Standard backups ~637 MB vs ~244 MB — `zips/` deploy archives (~525 MB) copied despite being gitignored.
- **Fix:** `STANDARD_DIRS` now skips **`zips`**. **`npm run backup:clean-zips`** keeps 3 newest `zips/*.zip`. Folder naming **`msc-website-v2-*`**.
- **Docs:** MASTER-COMMANDS, START-HERE, ISSUES-RESOLVED, backup-system README/CURSOR, global.mdc.

### 2026-06-08 — Hostinger MCP fix + MCP-SETUP sync (global 12)

- **Error fixed:** Hostinger MCPs failed with **`spawn EINVAL`** in Cursor (bare **`npx.cmd`** in global `~/.cursor/mcp.json`).
- **Fix:** All four `hostinger-*` servers now use **`cmd /c npx -y hostinger-api-mcp@latest …`** (matches working global MCPs).
- **Secrets:** **`HOSTINGER_API_TOKEN`** added to **`.env.local`**; **`msc-sync-mcp-env.mjs`** syncs token to all four Hostinger servers.
- **Verified:** `hosting_listWebsitesV1` returns **mystudiochannel.com**; GitHub + Tavily API tests PASS.
- **Docs:** **MCP-SETUP.md** rewritten (12 global servers, secrets checklist, health check); **Site-Plans.md**, **`.env.example`** updated.

### 2026-06-11 — Portable Hostinger setup & project MCP verification

- **Feature:** Extracted fully portable **`hostinger-setup`** module containing 26 deploy scripts, package JSON aliases, env fragment, Cursor rules, prompts, and pitfalls guides under `.cursor/custom-scriptz/hostinger-setup/`.
- **Scripts:** Added **`msc:hostinger:module:sync`** (npm run alias) to refresh the portable module from repo script assets.
- **MCP:** Added verified keys for **`21st-dev-magic`** and **`browserbase`**; resolved leading space and project ID typos; removed redundant `mcp.json.example` and `.sync-bak` files.
- **Persona:** Removed Bertram Gilfoyle prompt and cleaned up references across doc files.
- **Vertex:** Verified `vader-3-flash` and `vader-3.5-flash` local connections.

### 2026-06-08 — MSC Tooling Upgrade + Obsidian pilot + MCP consolidation

- **Skills:** **`.cursor/skills/MSC-UI-Taste/SKILL.md`** — merged taste-skill + impeccable + emilkowalski under NovaMira Gold. Extended **NovaMira-Design** + **Premium-UI** anti-slop cross-links.
- **MCP:** Project **`.cursor/mcp.json`** → **6 servers** (removed **`browsermcp`**, **`antigravity-awesome-skills`** → archive). Browser QA: **`msc:verify:live`** + **cursor-ide-browser**. **cursor-mcp-refresh** v1.1.0 installed (`.cursor/tools/`).
- **Prompts:** **`.cursor/prompts/harsh-review.md`** (Gilfoyle) — code review only; rule in **`.cursor/rules/global.mdc`**.
- **Dev tools:** **`npm run msc:codeburn`**; global **`codeburn`** install documented in **MASTER-COMMANDS** + **TOOL-CHEST**.
- **Antigravity:** Curated whitelist **`.cursor/skills/imported/CURATED-INDEX.md`** — no bulk auto-install.
- **Obsidian:** **`I:\Vader_Vault`** PARA-lite folders + **Jon-Operator**, **Current-Focus**, **Repo-Watchlist** notes. Weekly distill to ReCall — operator calendar, not agent.
- **Fix:** **`msc-sync-mcp-env.mjs`** → ESM imports (Node 24).
- **Docs:** AGENTS, MCP-SETUP, Jedi-List, TOOL-CHEST, Site-Plans, Checkpoint, project-log synced.

### 2026-06-08 — pushit:live:fast (Tier 2b) + docs sync

- **Feature:** **`npm run pushit:live:fast`** — zip **`.next`** → single FTPS → SSH unzip (BUILD_ID) → **`sync-app`**. Flags **`-SkipBuild`**, **`-WithDb`**, **`-WithMedia`**, **`-DryRun`**. Preflight: **`msc:pushit:live:fast:dry`**.
- **Fix:** FTPS zip must land at staging root **`deploy-next.zip`** (not **`zips/deploy-next.zip`** on remote).
- **Live:** **`msc:verify:live`** pass; **`pushit:live`** unchanged for full DB + media.

### 2026-06-08 — Live 503 fix, sync-app deploy pipeline, docs sync

- **Commit:** **`b368d3e`** on **`MSC-Website-v6`** (pushed).
- **Incident:** Live **503** after deploy — `stderr.log`: `Cannot find module 'next/dist/compiled/webpack/webpack'`. FTPS had landed files in **`public_html/nodejs/`**; **`sync-app`** + **`npm install --ignore-scripts`** required on app root.
- **Fix scripts:** **`msc:hostinger:sync-app`**, **`msc:hostinger:npm-install`**, **`msc:hostinger:recover`**. **`pushit:live`** = FTPS → **`sync-db`** → **`sync-app`**.
- **Live:** **v6.0.0**, Legal **`pages-collection`**, **`msc:verify:live`** + **`msc:verify:live:version`** pass.
- **Policy:** Prefer **`pushit:live`** over MCP zip (`better-sqlite3` compile fails; hPanel **Build failed** can be stale). **Do not delete** **`public_html/nodejs/`** or **`.builds/`**.

### 2026-06-07 — v6.0.0 development branch and MSC-Website-v6 branch cut

- **Branch:** Created **`MSC-Website-v6`** from **`MSC-Website-v5`** @ **`92918b6`**.
- **Version:** Bumped **`package.json`** to **`6.0.0`**; UI labels follow via **`lib/msc-app-version.ts`** dynamically.
- **Policy:** **`MSC-Website-v5`** frozen as backup branch; all active development on **`MSC-Website-v6`**.

### 2026-06-07 — Deploy hardening, live DB sync, Sentry org fix

- **Commit:** **`06ec2be`** on **`MSC-Website-v5`** and **`main`** (pushed to origin).
- **Live DB:** MCP/Git rebuild left **4 KB stub** in app root; FTPS landed under **`public_html/nodejs/`**. Fix: **`msc:hostinger:sync-db`** + **`msc:hostinger:sync-app`**; **`pushit:live`** runs both after upload.
- **Deploy modes:** AskQuestion picker — Quick DB (~1–2 min) · Full FTPS (~45–60 min) · MCP code-only (~5–10 min, verify DB after).
- **Sentry:** org slug **`mystudiochannel`**; client via **`instrumentation-client.ts`**; removed deprecated **`sentry.client.config.ts`**.

### 2026-06-02 — v5.0.0 development branch and MSC-Website-v5 branch cut

- **Branch:** Created **`MSC-Website-v5`** from **`MSC-Website-v4`**.
- **Version:** Bumped **`package.json`** to **`5.0.0`**; UI labels follow via **`lib/msc-app-version.ts`** dynamically.
- **Git:** **`main`** branch fast-forwarded to match **`MSC-Website-v5`**.
- **Policy:** **`MSC-Website-v4`** remains as a backup branch; all active development happens on **`MSC-Website-v5`**.

### 2026-06-02 — MCP-first “push website live” workflow

- **Default deploy:** `npm run push:website:live` → kill dev → `npm run build` → `npm run msc:deploy:zip` → Hostinger MCP **`hosting_deployJsApplication`** → hPanel **restart** → `msc:verify:live`.
- **Zip:** `zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip` (robocopy excludes `node_modules`, `.next`, `.git`).
- **FTPS fallback:** `npm run push:website:live -- --ftps` when MCP fails. Target **`FTP_REMOTE_PATH=/nodejs`**.
- **Scripts:** `create-deploy-zip.ps1`, `print-hostinger-restart-reminder.ps1`, `sync-sftp-from-env.ps1`.

### 2026-06-01 — v4.0.0 live on Hostinger

- **Live:** Deployed **`MSC-Website-v4`** @ **`87ec9de`** via Hostinger MCP (`MyStudioChannel-v4-deploy.zip`). Build completed; footer **`MyStudioChannel v4.0.0`** on **`/`**.
- **Smoke:** **`npm run msc:verify:live`** — **`/`** + **`/admin`** 200; **`/api/globals/projects-home`** 500 (env vars — set in hPanel).
- **Git:** Docs sync; **`main`** fast-forwarded to match **`MSC-Website-v4`**.

### 2026-06-01 — v4.0.0 development branch

- **Branch:** Created **`MSC-Website-v4`** from **`MSC-Website-v3`** @ **`8a44d95`**.
- **Version:** Bumped **`package.json`** to **`4.0.0`**; UI labels follow via **`lib/msc-app-version.ts`**.
- **Policy:** **`main`** and **`MSC-Website-v3`** unchanged at v3.0.0 until v4 release.

### 2026-06-01 — Hostinger live deploy + deployment documentation

- **Live:** First successful production deploy to **`mystudiochannel.com`** (zip upload + hPanel build). Footer **`MyStudioChannel v3.0.0`** verified.
- **Build fix:** Moved **`@tailwindcss/postcss`**, **`postcss`**, **`tw-animate-css`** to **`dependencies`** — Hostinger skips **`devDependencies`**.
- **Docs:** Full **`HOSTINGER-DEPLOY.md`** rewrite; **`DEPLOYMENT-FIXES.md`** (canonical rule + **`npm ls --omit=dev --depth=0`**); Path C daily updates; cross-links in START-HERE, Jedi-List, Go-Live, TRUTH.
- **Git:** **`7202c44`**, **`d94fe67`**, **`c0bdaac`**; **`main`** synced with **`MSC-Website-v3`**.

### 2026-06-01 — Version consolidation + `main` sync

- **Versioning:** Removed **`lib/msc-admin-version.ts`** / **`MSC_ADMIN_VERSION`**. Added **`lib/msc-app-version.ts`** reading **`package.json`** only. User-facing labels: **`MyStudioChannel v3.0.0`** (footer), **`MyStudioChannel Admin v3.0.0`** (Payload sidebar).
- **Docs:** **`Jedi-List.md`** — operators bump **`package.json`** only; **`msc:pushitup:admin-ui`** file list synced.
- **Git:** Pushed **`MSC-Website-v3`**, fast-forward merged into **`main`**, pushed **`origin/main`**; continued dev on **`MSC-Website-v3`**.
- **Other:** Hero slide 5 JPG (**`IWWI-Indie-WorldWide-Inc-Hero-6.jpg`**); **`scripts/test-mcps.mjs`** MCP health script.
- **Commits:** **`50ae6b2`**, **`57910cd`** (docs).

### 2026-05-30 — Version 3.0.0 Bump

- **Audit:** Completed deep audit and consolidation; purged all legacy `msc-new` and `Spaceship` references.
- **SSoT:** Established `TRUTH.md` as the single source of truth.
- **Git:** Merged `MSC-Website-v3` into `main`, tagged `v3.0.0`, and created GitHub release.
- **Status:** Project 100% healthy and standardized.

### 2026-05-30 — Hostinger Migration Complete

- **Docs:** Removed all references to Spaceship and cPanel.
- **SSoT:** Updated `START-HERE`, `Agent-Runbook`, `Jedi-List`, `ReCall`, `Site-Plans`, and `Go-Live-Checklist` to point to **Hostinger (hPanel)**.
- **Rules:** Created `deploy-safety-hostinger.mdc` and updated project rules.
- **Scripts:** Prepared scripts for renaming to Hostinger-specific aliases (e.g. `msc:test:hostinger-ftp`).

### 2026-05-30 — End Project: Hostinger Audit + MCP Setup Complete

- **Audit:** Completed 12-point pre-deployment audit for Hostinger.
- **MCP:** Fully connected and verified Hostinger Connector; websites and plans listed.
- **Docs:** Integrated Hostinger into `START-HERE`, `Jedi-List`, `ReCall`, and `Restore-Points`.
- **Backup:** Project backed up to `msc-website-v1-f` with note "Adding the Hostinger MCP setup updated docs".
- **Status:** Ports 3000-3010 cleared; workspace sync to `D:\Cursor_Projectz\MyStudioChannel` finalized.

### 2026-05-30 — Hostinger MCP + Pre-Deployment Audit Complete

- **Tooling:** Fully connected and verified **Hostinger Connector (MCP)**. I now have access to `user-hostinger-hosting`, `user-hostinger-domains`, `user-hostinger-dns`, and `user-hostinger-vps`. 
- **Verification:** Successfully listed Hostinger websites (`vaderlabz.com`, `jon-beatz.com`) and active plans (`hostinger_business_v3`) directly via MCP.
- **Audit:** Completed a 12-point pre-deployment audit for Hostinger.
- **Docs:** Created `.cursor/docs/HOSTINGER-DEPLOY.md` and `.env.production.template`.
- **Git:** Pushed audit changes to `main`.
- **Project Version:** Still at **`v1.0.8`** (admin version).

### 2026-05-30 — Workspace sync + GitHub repo and release v1.0.0

- **Workspace:** Updated project root to `D:\Cursor_Projectz\MyStudioChannel` across all docs and scripts after directory rename.
- **Git:** Created and pushed public repository `jonbeatz/MyStudioChannel` via GitHub MCP.
- **Release:** Created official GitHub release `v1.0.0` ("Initial Release - My Studio Channel v1.0.0") on the `main` branch.
- **Health:** Dev server running safely on port 3000; `msc:verify:local` passing all checks.
- **Project Version:** Still at **`v1.0.8`** (admin version).

### 2026-05-30 — MCP additions + Google-API confirmed working

- **Feature:** Added 4 new project-level MCP servers to `.cursor/mcp.json`: `browsermcp`, `browserbase`, `21st-dev-magic`, and `markdownify`.
- **Governance:** Updated `.cursor/rules/docs-checkpoint-governance.mdc` to enforce the **Backup Ritual** workflow whenever "update project", "update docs", or "backup project" is called.
- **Service:** Started and verified `google-api` (LiteLLM + ngrok).
- **Verification:** Successfully tested `vader-3-flash` on port 4000 (Capital of France = Paris).
- **Docs:** Updated `MCP-SETUP.md` and `START-HERE.md` to reflect the new total of 6 project-level MCPs.
- **Backups:** Completed two backups to `G:\Cursor_Project_BackUpz\MyStudioChannel` following the new Ritual.
- **Project Version:** Still at **`v1.0.8`** (admin version).

### 2026-05-29 — LiteLLM (Gemini 3.5 Flash) + ngrok connection verified

- **Feature:** Installed and fully configured `google-api-proxy` portable module.
- **Port:** LiteLLM proxy runs on port **4000** (Next.js/Payload remains on **3000**).
- **Authentication:** `NGROK_AUTHTOKEN` added to `.env.local` only (never committed). `google-api/ngrok.exe` is gitignored.
- **Test results:** Verified with Vertex AI Gemini 3.5 Flash (`vader-3.5-flash`) responding **200 OK** (Capital of France = Paris). 
- **Cursor Settings:**
  - Base URL: `https://pushy-water-reformer.ngrok-free.dev/v1`
  - Key: `MSC_LITELLM_MASTER_KEY` (`sk-vader-protocol-1234`)
  - Model: `vader-3.5-flash`

### 2026-05-29 — Tavily MCP re-enabled + docs sync

- **Global MCP:** **`tavily`** restored ([tavily-ai/tavily-mcp](https://github.com/tavily-ai/tavily-mcp)); **`TAVILY_API_KEY`** synced via **`npm run msc:sync:mcp-env`**.
- **Scripts:** **`scripts/test_tavily_api.py`** → **`npm run msc:test:tavily-api`**.
- **Docs:** **`GitHub-Cheat-Sheet.md`** (git + bundle recovery), MCP/Jedi/START-HERE/README updates; global count **8** servers.
- **Security:** **`.env.example`** uses Tavily placeholder only; real key stays in **`.env.local`**.

### 2026-05-29 — MCP config reorganization (Cursor)

- **Global `~/.cursor/mcp.json`:** trimmed to **7** servers (GitHub, filesystem, Playwright, fetch, terminal-controller, sequential-thinking, desktop-commander). **15** recipes archived to **`.cursor/mcp.servers.archived.json`**.
- **Project `.cursor/mcp.json`:** WordPress only (**`local-wp`**, **`mcp-wordpress`**). Committed with placeholders; secrets via **`npm run msc:sync:mcp-env`**.
- **Payload MCP:** **`@govcraft/payload-cms-mcp`** not configured (Redis + SSE; broken local stdio). Use workspace **`user-payload`**, REST **`/api/*`**, or **`/admin`**.
- **Scripts:** **`scripts/sync-mcp-env.js`**; **`msc:sync:github-mcp`** → alias; Python **`sync_github_mcp_token.py`** deprecated.
- **Docs:** **`MCP-SETUP.md`**; cross-links in **Development**, **START-HERE**, **Jedi-List**, **Site-Plans**, **Run-Next-JS**, **README**.
- **Git:** **`4a731a6`** on **`MSC-Site-Updates-v1`**.

---

### 2026-04-14 — Session closeout (I'm done for today)

- **Live recovered and verified:** `https://mystudiochannel.com` homepage demos now match local (`Talk Show Land` featured), and `https://mystudiochannel.com/admin/msc-homepage` loads successfully.
- **Root issue resolved:** live had stale/undersized `payload.sqlite` plus `.next` upload path confusion during recovery; fixed with full rebuild + full `.next` upload + DB/media re-sync + WAL cleanup + app restart.
- **Docs/governance synced:** added guardrails and post-upload sanity checks across `HOSTINGER-DEPLOY.md`, `Custom-Prompts.md`, `Go-Live-Checklist.md`, `ReCall.md`, and `Restore-Points.md`; checkpoint commit `58c47d4`.
- **Snapshot branch created:** `snapshot/2026-04-14-live-parity-playbook` (restore line for this known-good state).
- **Local closeout:** dev listener on port 3000 stopped; working tree clean on `feature/projects-admin-polish`.

### 2026-04-14 — Live parity restored: admin homepage + demos corrected

- **Issue observed:** live showed stale demos (`MSC Core Pro v1`) and `https://mystudiochannel.com/admin/msc-homepage` 404 while local worked.
- **Root causes (confirmed):**
  1. **Live DB drift:** live `payload.sqlite` was tiny/old (~57 KB) while local was current (~540 KB) and included `homepage.is_styles_visible`.
  2. **`.next` path confusion during recovery:** one upload pass landed a too-small `.next` set; recovery required a clean rebuild + full `.next` upload.
  3. **WAL sidecars reintroduced risk** until removed before restart.
- **Recovery runbook that worked:**
  - Stop app; `rm -rf .next`; `rm -f payload.sqlite-wal payload.sqlite-shm`
  - Local: `npm run build` then `npm run pushitup -- .next` (full prod bundle), `npm run pushitup -- payload.sqlite`, `npm run pushitup -- public/media`
  - Live terminal: `sqlite3 ./payload.sqlite "UPDATE media SET url = '/media/' || filename;"` then `pkill -u $(whoami) node`
  - Start app in Node.js Selector
- **Result:** live site now matches local (`Talk Show Land` featured) and `/admin/msc-homepage` loads correctly.
- **Docs hardening:** added FileZilla nested `.next` trap + post-upload sanity checks (Custom-Prompts item 38, manual upload section).
- **Code line in this session:** `97f4421` (Projects admin polish), `327d843` and `68e1f3e` (rowLabel serialization/type fixes for stable build).

### 2026-04-13 — Live deploy hardening: pre-upload cleanup + media table sync docs

- **Live site was showing fallback Demos data** after `pushit:live` — root causes identified and fixed:
  1. **Stale `.next` on server** (FTP merges, not replaces) → old `webpack-runtime.js` referenced non-existent `vendor-chunks` → 500. Fix: `rm -rf .next` before every Tier 2 upload.
  2. **SQLite WAL replay** (`payload.sqlite-wal` / `payload.sqlite-shm`) → SQLite replayed old journal on top of freshly-uploaded DB → stale project data returned. Fix: `rm -f payload.sqlite-wal payload.sqlite-shm` before every DB upload.
  3. **Missing `media` table rows** → `projects_home_project_items` referenced image IDs 33–37 that didn't exist in server's `media` table → `mapProjectItemsToDemos` filtered all rows → `FALLBACK_DEMOS` rendered. Fix: inserted matching rows via `sqlite3` and re-ran media URL update. Image files (`Demos-1b/2b/3b/4b/5c-preview.jpg`) were present in `public/media` all along.
- **Docs updated:**
  - `HOSTINGER-DEPLOY.md` — new **"⚠️ REQUIRED pre-upload cleanup"** section before `npm run pushit:live`; new **§4a** "media table out of sync" troubleshooting entry.
  - `Custom-Prompts.md` — items **3** and **38** now include the pre-upload cleanup block and media table check.
  - `scripts/pushit-live.ps1` — already has pre/post reminders as comments and `Write-Host` warnings.
- **Live site confirmed:** `https://mystudiochannel.com` — Demos section shows Talk Show Land as featured with correct image.
- **Current version:** `v1.0.8` (no code changes this session — docs + DB surgery only).

### 2026-04-13 — Finish: homepage galleries + closeout (`Lets Finish`)

- **Shipped in commit `43fd417` (`mcs-Live-v5-Restore`):** Programming Styles / Services Gallery — **`globals/Homepage`** relationship images with **drawer** admin UI; seed + **`homepage-gallery-hydrate`**; **`components/services-section.tsx`** hybrid CMS/fallback; **`getPublicOrigin()`** for services gallery absolutized fallbacks on **`page.tsx`**; **`v1.0.8`**; **`payload-types`** regen; **Restore-Points** **`RP-2026-04-13-homepage-galleries-drawer-hydrate`**; **ReCall** this block.
- **Verify:** **`npm run verify:next:safe`** green before commit; ESLint clean on **`lib/cms/homepage.ts`** (removed unused type import).
- **No deploy** unless you run **`Lets Finish + Deploy`** — production still on prior push until **`npm run pushit:live`** + hPanel Node restart.
- **Resume:** **`npm run dev:fresh`**, **`npm run msc:verify:local`**; open **Globals → Homepage** to confirm gallery pickers.

### 2026-04-13 — Checkpoint: docs + commit (`Lets Checkpoint Docs + Commit`)

- **Committed:** broad WIP merge — env URL protocol, **`v1.0.7`**, admin hydration fix, Leads SQLite delete preflight, marketing anchor scroll polish, legal pages + **`pages`** route group, contact modal, FTPS/SQLite tooling, **`.env.example`** updates.
- **Docs synced:** **Jedi-List** (*Public site URL* table), **START-HERE** (env blurb + resume tip), **HOSTINGER-DEPLOY.md** (production env baseline + verify-email note), **Restore-Points** **`RP-2026-04-13-checkpoint-v107-env-nav-leads`**, this **ReCall** block.
- **No deploy** in this flow — run **`npm run pushit:live`** when ready, then Hostinger Node restart.
- **Verify before deploy:** **`npm run verify:next:safe`**, **`npm run msc:verify:local`** (dev on **3000**).

### 2026-04-12 — Session closeout (I'm done for now) — evening

- **Chats:** Confirmed **docs + “Ready to begin”** readiness for next session; answered **Composer 2** vs **Composer 2 Fast** — same rough token use for a task; **standard Composer 2** is **lower cost per token** than **Fast** on usage-based pricing (see Cursor **Composer 2** blog); **Fast** is the default for latency.
- **Git:** **`mscNowLive-v4-RestorePoint`** @ **`5201318`**, clean and pushed to **`origin`**.
- **Next session:** **`Ready to begin`** (**`Custom-Prompts`** item **0** / **`Agent-Runbook`** §0) → **`npm run dev:fresh`** or **`npm run dev:payload`** from repo root if **`/`** / **`/admin`** need a boot.
- **Local:** Freed port **3000** via **`scripts/msc-kill-dev-port.mjs`** when a listener was present.

### 2026-04-12 — Docs + restore tip synced for tomorrow (`Ready to begin`)

- **Restore-Points:** New row **`RP-2026-04-12-branch-tip-ready-tomorrow`** — branch **`mscNowLive-v4-RestorePoint`** (pull latest); **Files worth diffing** list deduped; **`HeroSlides`** removed from checklist (superseded by **Homepage** + **Media**).
- **ReCall:** **Current focus** updated for hero/Media/email helpers; this entry confirms **Custom-Prompts** item **0** / **Agent-Runbook §0** are the canonical **Ready to begin** paste for the next session.
- **Parity report:** **`parity-ftp-report.md`** is **gitignored** (**`b92d1be`**); **`npm run msc:parity:ftp`** still writes it locally for drift checks.

### 2026-04-11 — Snapshot: MSC PRO admin branding + deploy docs (`Take a snapshot`)

- **Checkpoint:** **`RP-2026-04-11-msc-pro-admin-branding`** in **`Restore-Points.md`**. **Branch:** **`mscNowLive-v4-RestorePoint`** @ **`6b84052`** + pushed **`snapshot/2026-04-11-msc-pro-admin-branding`** at the same commit.
- **Verified:** **`npm run build`** green immediately before commit.
- **Includes:** Payload admin graphics, password-field enhancement, **`msc:pushitup:admin-ui` / `msc:pushitup:admin-branding`**, doc sync (Jedi-List, HOSTINGER-DEPLOY.md, Go-Live, Custom-Prompts), hooks / **`verify-next-safe`**, version **1.0.5**.

### 2026-04-11 — Deploy docs synced with `package.json` (admin branding scripts)

- **`package.json`:** **`msc:pushitup:admin-ui`** uploads the full MSC PRO ENGINE / Payload admin bundle (middleware, **`lib/msc-admin-version.ts`**, nav dashboard, **`msc-payload-graphics`**, **`msc-payload-admin-enhancements`**, **`collections/Users.ts`**, **`payload.config.ts`**, **`app/(payload)/custom.scss`**); **`msc:pushitup:admin-branding`** uploads the branding subset only.
- **Docs aligned:** **`Jedi-List.md`** (workflow + Deploy rows), **`HOSTINGER-DEPLOY.md`** (Standard update step 2), **`Go-Live-Checklist.md`**, **`Custom-Prompts.md`** (shortcut **Push my branding**) — all describe the same paths and commands as **`package.json`**.
- **ReCall:** added **Deployment docs ↔ package.json** section above so future sessions treat the four docs + **`package.json`** as a single contract.

### 2026-04-11 — Take a snapshot (commit + restore branch)

- **`verify:next`** green, then full **`git add -A`** commit on **`mscNowLive-v3-RestorePoint`**, **`git push origin`**, restore branch **`snapshot/2026-04-11-msc-next-payload-media`** pushed for rollback. **`Restore-Points.md`** row **RP-2026-04-11-snapshot-next-payload-media**.
- **Active branch (post-snapshot):** **`mscNowLive-v4-RestorePoint`** — created from the same snapshot commit, pushed to **`origin`**, and used as the ongoing **RestorePoint** line (replaces **v3** for day-to-day work).

### 2026-04-11 — Docs checkpoint (scripts ↔ Jedi-List)

- **`Lets Checkpoint Docs`:** **`Jedi-List.md`** — added **`verify:next`**, new **Media (disk ↔ Payload)** table (**`msc:media:consolidate`**, **`msc:media:sync`**), clarified **`dev:fresh`** = **`npm run dev`**. **`Agent-Runbook.md` §0** and **`Custom-Prompts.md`** item **0** paste block now list the same script names alongside existing deploy/smoke commands. No commit/push in this checkpoint (per prompt).

### 2026-04-10 — Session closeout (docs + tomorrow’s focus)

- **`Ready to begin`:** full-sync prompt in **Agent-Runbook §0** + **Custom-Prompts** (items 0, 31, 32); committed/pushed (`56a723e`); final dry-run: **`msc:verify:local`** green.
- **`ToDo.md`:** lightweight next-session list (email templates review, Media / `public/media`, admin login password reveal); **START-HERE** docs map points here; backlog left empty (keep it simple).
- **Next session:** see **`ToDo.md` → Next session (2026-04-11)**.
- **Repo note:** **`ToDo.md`** and **`START-HERE.md`** (ToDo row) may still need **`git add` / commit** if not saved to `origin` yet.

### 2026-04-10 — Checkpoint: demos polish, ESLint, admin v1.0.4 live, operator docs

- **Demos:** `components/demos-section.tsx` — valid focusable rail (no `<button>` wrapping `<a>`), same-tab links for non-HTTP URLs, selection sync when CMS list changes; `lib/cms/projects.ts` fallback images aligned with hero assets.
- **Tooling:** `eslint.config.mjs` + `next lint`; ESLint devDeps; lint fixes (`hash-nav`, requirements typing, toast action types, unused imports).
- **Admin:** `MSC_ADMIN_VERSION` **1.0.4**; shipped with local **`npm run build`** + **`msc:pushitup:admin-ui`** + **`pushitup -- .next`** (client bundle must include version).
- **Docs / ops:** `START-HERE` + `Agent-Runbook` updated Hostinger hPanel bookmarks; new **`.cursor/rules/jon-operator-hpanel.mdc`** — always label **Local (Cursor)** vs **Live (Hostinger)** and use Jon’s bookmarks for Start/Stop vs host shell steps.
- **Verify:** `npm run lint`, `npm run build`, `msc:verify:local` / `msc:verify:live`, `msc:test:hostinger-ftp` used during session; port-3000 hijack note: free stale listener before `msc:verify:local`.

### 2026-04-10 — Email template dark-mode hardening + dev preview lab

- Hardened email templates for iPhone/Apple Mail consistency in:
  - `collections/Leads.ts` (verify + admin lead alert)
  - `collections/Bookings.ts` (booking confirmed + admin booking alert)
- Added dark-mode compatibility attributes and styles (`color-scheme`, `supported-color-schemes`, explicit `bgcolor`, Apple data detector link overrides).
- Added dev-only preview route for the 3 core templates:
  - `app/(site)/dev/email-preview/page.tsx`
- Safety behavior:
  - preview returns 404 in production (and when `ENABLE_DEV_LAB=false`).
- Status check:
  - local verify checks pass after changes.

### 2026-04-10 — Incident recovery: live 500 + local port drift

- **Live incident:** site and admin returned `500` after deploy; Hostinger logs showed missing `.next` runtime modules (`./vendor-chunks/@payloadcms.js`, `date-fns.js`, `next.js`).
- **Root cause:** mixed/incomplete server `.next` artifacts from interrupted/partial FTPS chunk uploads.
- **Fix path (confirmed):**
  1) remove server `.next`
  2) rebuild locally
  3) re-upload full `.next` from PC
  4) re-upload failed chunk areas when `msc:pushitup` reports end-of-run failures
  5) restart Node app
- **Result:** live `https://mystudiochannel.com/` and `/admin` recovered; admin version `v1.0.3` visible.
- **Local incident:** `msc:verify:local` failed (`/` 404 + `/admin` 500) while API stayed `200` because stale node process kept port 3000 and dev booted on 3002/3003/3004.
- **Local fix:** kill stale process on `3000`, rerun `npm run dev:fresh`, then `npm run msc:verify:local` passes all checks.

### 2026-04-09 — Dev scripts aligned with Next.js 15.4 CLI

- **Issue:** `npm run dev:payload` failed with `error: unknown option '--webpack'` — Next **15.4.11** uses **webpack by default**; Turbopack is opt-in (`--turbo` / `--turbopack`). `--no-server-fast-refresh` is not a valid flag on this CLI.
- **Fix:** `package.json` → **`dev`** and **`dev:payload`** both run plain **`next dev`**.
- **Verified:** `npm install` (patches OK) → dev server **Ready**; **`http://localhost:3000/`** and **`/admin`** return **200**.

### 2026-04-09 — Verify email redirect fix for Hostinger proxy hosts

- **Issue:** verification links opened correctly on `mystudiochannel.com` but post-verify redirect could land on `https://0.0.0.0:3000/?verified=...` behind Hostinger reverse proxy.
- **Fix:** `collections/Leads.ts` now returns a **relative redirect** (`Location: /?verified=success|error`) from `/api/leads/verify/:token`.
- **Result:** browser stays on public origin and homepage verify toast/badge appears as expected.
- **Deploy note:** rebuild locally and upload refreshed `.next-deploy.zip` before restart.

### 2026-04-09 — Hostinger production recovery + deploy scripts

- **Root causes fixed:** production postinstall missing `patch-package`, host-side `next build` OOM (`WebAssembly.instantiate`).
- **Runtime/deps:** pinned `next` to **15.4.11** and Payload packages to exact **3.81.0**; moved `patch-package` into `dependencies`; `server.js` binds to `0.0.0.0`.
- **Deploy tooling:** added **`scripts/PushItUP.ps1`** (path upload) and **`scripts/PushItUPzip.ps1`** (zip-first upload) with npm aliases `pushitup` / `msc:pushitupzip`.
- **Shared-host workflow:** build locally, upload `.next` as zip + `patches` + runtime files, then host runs `npm install --legacy-peer-deps` and app restart (skip host build on low-memory plans).
- **Result:** `https://mystudiochannel.com/` and `/admin/login` load successfully.

### 2026-04-09 — Docs: hash navigation + pathname-aware header/footer

- **Docs:** **Development.md** (marketing header / default nav / **`lib/hash-nav.ts`** / **`HomeHashScroll`**), **ReCall** (current focus), **README** (pointer to hash helpers).
- **Context:** Section links in admin are **`#msc-*`**; runtime chooses **`#`** on `/` and **`/#`** off home; URL cleanup for stacked fragments remains in **`home-hash-scroll.tsx`**.

### 2026-04-08 — ReCall resume: booking time zone capture

- **Changed:** `BookingRequestPayload` + `submitBookingRequest` send optional `timeZone` to Payload; `contact-section` sets it from `Intl.DateTimeFormat().resolvedOptions().timeZone`.
- **Admin email:** New booking alert HTML includes **Time zone** (stored field was already on `Bookings`).
- **Verified:** `npm run build` green; `npm run dev:payload` shows **Next.js (webpack)** at `http://localhost:3000/`.

### 2026-04-08 — Session closeout (goodbye sequence)

- **Restore branch:** **`msc-new-payload-polished-v3`** on `origin` (checkpoint commit **`c751c92`**); includes marketing nav / Demos scroll / scroll-to-top / docs work (**`145f226`** in history).
- **Resume:** `git checkout msc-new-payload-polished-v3 && git pull` → **`npm run dev:payload`** → **`http://localhost:3000/`** and **`/admin`** as needed; read **ReCall** + **Development.md** first.
- **Dev listener:** Goodbye step stopped **`node.exe`** that was **LISTENING on port 3000** (PID 14268). Re-run **`netstat -ano | findstr ":3000"`** after other sessions if a port looks busy.

### 2026-04-08 — Marketing home: nav anchors, Demos scroll, scroll-to-top, docs

- **Header defaults (`globals/Header.ts`, `lib/cms/header.ts`):** Services submenu ends with **What We Do** → `#msc-creators`; order above it is Own Your Platform, Packages, Requirements. Resources: Testimonials → **Extras** → `#msc-addons`, then FAQ → `#msc-faq`.
- **Demos (`components/demos-section.tsx`):** `#msc-demos` on the inner `max-w-7xl` wrapper; **`scroll-mt-30`** when sticky header is on; section uses **`py-*` padding** (not margin-top) so **`bg-surface-2`** covers the top band (no dark “divider” from `main` background).
- **Scroll to top:** `components/scroll-to-top.tsx` mounted in `app/(site)/layout.tsx` (shows after ~half viewport scroll).
- **Payload:** Homepage hero secondary CTA columns → `npm run msc:migrate:sqlite:homepage-hero-secondary-cta` if `/admin/globals/homepage` 404s on SQLite without push. Sticky header field admin copy is short (no long SQLite paragraph).
- **Docs refreshed:** `Development.md`, `README.md`, `.cursor/docs` + `public/` **CURSOR-SETUP-PROMPT.md**, **DIVI-CONVERSION-GUIDE.md** updated to match the above.

### 2026-04-08 — Final polish closeout: jump links + seeded demo page

- **Jump-link UX finalized:** Kept active-chip detection and auto-centering, but removed sticky behavior so in-page nav scrolls away naturally after passing it.
- **Page flow cleanup:** Dynamic slug pages now suppress the "Page Content Coming Soon" card when sections exist; spacing between sections tightened for smoother premium rhythm.
- **Demo validation content:** `msc1` now includes a full 5-block narrative flow (`The Studio`, `Virtual Tour`, `Our Solutions`, `Case Study`, `Get Started`) to test anchor progress and visual pacing.
- **Seed script:** Added `scripts/seed-demo-page.ts` and npm alias `msc:seed:demo-page`; local execution via Payload CLI still has alias-resolution limitations in this environment, so equivalent demo content was seeded directly into SQLite for this session.
- **Build status:** `npm run build` passes after final polish.

### 2026-04-08 — Closeout checkpoint for tomorrow resume

- **Pinned restore branch:** `msc-new-payload-polished-v2`
- **App feature freeze (pages polish + demo):** `98c51c0` (`Finalize pages polish and demo flow closeout.`)
- **Branch tip:** `git pull` on `msc-new-payload-polished-v2` — may include doc-only commits after the freeze; same runtime as freeze unless `git log` shows newer code changes.
- **Resume sequence (low risk):**
  1. `git checkout msc-new-payload-polished-v2`
  2. `git pull`
  3. `npm run dev:payload`
  4. Verify `http://localhost:3000/msc1` and `/admin` load cleanly.
- **Known environment note:** `npm run msc:seed:demo-page` is currently blocked by local Payload alias resolution in this machine runtime; `msc1` demo data is already seeded in local SQLite for this checkpoint.

### 2026-04-08 — Dynamic Pages + Sections Builder + jump links

- **Branding controls:** Added `Site settings -> Branding` tab (`siteLogo`, `favicon`, `ogImage`, `siteTitleSuffix`) and wired logo into Header/Footer plus metadata favicon/OG/title suffix defaults.
- **Dynamic route engine:** Added `app/(site)/[slug]/page.tsx` with slug-based `pages` lookup, SEO metadata generation, and dark/gold page presentation.
- **Pages content model:** Upgraded `pages` with `Content Builder` tab including `featuredImage`, Lexical `content`, and `sections` blocks (`richText`, `featureGrid`, `videoPlayer`) where every block requires `sectionId` (Anchor ID).
- **Block rendering:** Added `components/blocks/SectionsRenderer.tsx` to map each block type into frontend UI and wrap each block as `<section id={sectionId}>`.
- **Sticky in-page nav:** Added `components/blocks/PageJumpLinks.tsx` (gold-on-dark chip navigation) with active-section detection, smooth-scroll, and auto-centering active chip behavior on scroll.
- **SQLite drift fixes:** Patched local DB with new `pages` columns and block tables to resolve runtime 500/404 issues (`pages.content`, `pages.featured_image_id`, and `pages_blocks_*` tables).
- **Status:** Build green after each phase (`npm run build` passes).

### 2026-04-08 — Admin UX + navigation consolidation polish

- **Projects editor UX:** moved from collection-document editing to `projects-home` global array so projects are managed in one draggable/toggle list like Homepage hero rows.
- **Demos frontend stability:** right rail now keeps fixed card heights, uses conditional scrolling only when needed, supports click-to-preview in left feature area, and applies darker gold-accent scrollbar styling.
- **Visibility controls:** added `isVisible` project toggle and frontend filtering so hidden projects do not render publicly.
- **Header submenu restore:** Header global now has nested submenu rows (collapsed by default), with restored desktop dropdowns, mobile nested links, chevron rotation animation, and delayed-close hover behavior.
- **Admin sidebar/account polish:** nav group labels switched to gold, Dashboard quick link added near the top, and custom logout moved off sidebar into account-page context.
- **Preferences note:** Payload remembers row open/close state per-user in `payload_preferences`; clearing/resetting preferences may be needed after changing `initCollapsed`.

### 2026-04-08 — Command Center finalize: routing, sidebar grouping, email branding

- **Site Settings 404 fix:** Root cause was schema drift (not slug routing): missing `site_settings_notification_emails` table and missing `site_settings` notification columns in local SQLite with `db.push: false`. Patched DB schema and confirmed `/api/globals/site-settings` + `/admin/globals/site-settings` return 200.
- **Admin UX:** Added live Notifications preview field in Site Settings (`Effective Recipient List`) so admin can see array recipients vs fallback before save; clarified `systemFromEmail` label to **Sender Address**.
- **Sidebar structure:** `bookings` moved under `admin.group: "Marketing"` and aligned with `leads`.
- **Email templates:** Added global anchor style overrides (`#D4AF37`, `text-decoration:none`, `!important`) in Leads + Bookings templates; Lead admin alert now includes only lead email; booking admin alert requester email is a gold-styled mailto link.
- **Verification notes:** `npm run build` passes after changes. Live booking API create succeeded (`/api/bookings` 201). Lead test is constrained by Resend sandbox/duplicate checks in local environment.

### 2026-04-07 — Dev URL at root (no `basePath`)

- Removed **`basePath`** and **`assetPrefix`** from `next.config.mjs` — app runs at **`http://localhost:3000/`**.
- Local images: **`public/media/`** → use **`/media/filename`** in components (folder tracked via `.gitkeep`).
- Updated **Development.md**, **Run-Next-JS.md**, **ReCall** prompt, **.cursorrules**, **Nova** / **NovaMira-Design** skills.

### 2026-04-07 — Schedule dialog UX + payload shape

- Implemented mock **Schedule a Call** lightbox flow in `components/contact-section.tsx`.
- Added booking helper module `lib/booking.ts` for backend-ready submit contract.
- Switched from range-date selection to **single-day selection**.
- Added **12-hour AM/PM** time selection from **8:00 AM to 8:00 PM**.
- Added mock booked-slot blocking logic via `BOOKED_SLOT_KEYS`.
- Updated selector to show only available times and dynamic placeholder:
  - `Select a date first`
  - `Select from N available times`
  - `No slots available`
- Added availability summary: `X available, Y booked on this date`.

---

## What’s working now

- Schedule button opens a clean dialog (not a large static time list).
- User selects one day + one available time slot.
- Booked times are blocked in mock logic.
- Continue action submits mock payload and shows success status.
- No linter errors in touched scheduling files.

---

## Next ideas

- Replace `BOOKED_SLOT_KEYS` with live slot fetch from WordPress endpoint.
- Add timezone capture (`Intl.DateTimeFormat().resolvedOptions().timeZone`) to payload.
- Add optional email/name fields in dialog and verify flow (double opt-in).
- Add confirmation step showing selected date/time before final submit.

---

## Backend handoff notes (WordPress-ready)

- Planned public endpoint: `/wp-json/msc/v1/booking-request`
- Env var placeholder: `NEXT_PUBLIC_MSC_BOOKING_URL`
- Current payload (mock) in `lib/booking.ts`:
  - `source`
  - `email`
  - `name`
  - `preferredDateLocal`
  - `preferredTimeLocal`

---

## Session log template

Copy/paste for new entries:

```md
### YYYY-MM-DD — Short title
- Changed:
- Files:
- Why:
- Result:
- Next:
```

---

### 2026-04-07 — Session closeout (Done for today)
- Done:
  - Added and polished Schedule Call dialog UX in `components/contact-section.tsx`.
  - Finalized single-day + time-slot flow (8:00 AM–8:00 PM, AM/PM format).
  - Added mock booked-slot logic and availability-aware dropdown behavior.
  - Added backend-ready booking payload shape in `lib/booking.ts`.
  - Updated docs: `Development.md`, `Run-Next-JS.md`, and created/expanded `ReCall.md`.
  - Updated `.cursorrules` to include ReCall startup + closeout workflow.
- Next:
  - Start WordPress backend phase 1 (`/wp-json/msc/v1/booking-request` + availability endpoint).
  - Replace mock slot map with live WP availability data.
  - Add timezone + optional email verification flow.
- Open Questions:
  - Confirm where booking data should be stored in WP (custom table vs CPT/meta).
  - Confirm email provider path (`wp_mail` SMTP plugin vs transactional provider API).

### 2026-04-07 — Goodbye closeout
- Done:
  - Performed goodbye runtime cleanup for local dev listeners.
- Result:
  - Common dev ports (3000-3010) are clear for next restart.
- Next:
  - Resume with: `Continue from ReCall and wire WordPress backend phase 1.`

---

### 2026-04-08 — Critical bug fix: Turbopack dev server generating invalid JS chunks

**Symptom:** Hero carousel arrows, Demos switcher, and Schedule a Call dialog all had zero
interactivity. Browser console showed `SyntaxError: Unexpected end of input` and
`SyntaxError: Invalid or unexpected token` in `/_next/static/...` chunks. Clearing browser
cache, hard refresh, and incognito window all made no difference.

**Root cause (2 layered issues):**

1. **Turbopack panic (server crash)** — Multi-byte UTF-8 characters inside JSX block
   comments `{/* ... */}` (specifically em-dash `—` U+2014 and box-drawing `──` U+2500
   used as section separators) triggered a Rust `highlight.rs` panic in Turbopack's
   code-frame error display. The crash signature was `end byte index N is not a char
   boundary`. Exit code `3221226505` (STATUS_STACK_BUFFER_OVERRUN). When the server
   crashes mid-stream the browser caches the truncated response. On restart, fresh chunks
   are generated but the Turbopack dev server in **Next.js 16.2.0 + React 19 + Tailwind v4**
   continued to emit invalid JS chunks even after fixing the panic.

2. **Turbopack dev-mode chunk corruption (persistent)** — Even with the panic fixed and
   `.next` cache cleared, `npm run dev` (Turbopack) kept emitting malformed JS chunks.
   Incognito window confirmed this was server-side, not browser cache. This is a known
   instability in Next.js 16 + Turbopack dev mode with this exact stack.

**Fix:**
- Removed all non-ASCII characters from every `{/* JSX comment */}` across all
  components (replaced `—` with ` - ` and `──` with plain text).
- Files cleaned: `demos-section.tsx`, `contact-section.tsx`, `hero-section.tsx`,
  `process-section.tsx`, `services-section.tsx`, `policies-section.tsx`.
- **Stopped using `npm run dev` (Turbopack).** Instead:
  1. `npm run build` → generates valid production JS in `out/`
  2. `npx serve@latest out -l 3000` → serves it at `http://localhost:3000`
- All three interactions immediately worked on the production-served build.

**Also fixed during this session:**
- Rewrote `contact-section.tsx` Schedule a Call dialog: replaced Radix `<Dialog>` with
  a plain CSS `fixed inset-0 z-[9999]` overlay div — avoids Radix controlled/uncontrolled
  conflicts and works in all environments.
- Fixed invalid import order in `contact-section.tsx` (imports were placed after a `const`
  dynamic import, which is invalid ESM — moved all imports to top, `dynamic()` call after).
- Added `Image` import back to `footer.tsx` after it was accidentally removed.

**Update (Payload + Webpack):** On **Next 16**, default dev was Turbopack and risky on this stack. **`package.json`** later used **`next dev --webpack`** where the CLI supported it. **As of Next 15.4.11 in this repo,** dev scripts are plain **`next dev`** (webpack default; `--webpack` flag removed). Use **`npm run build` + `npm run start`** for a production-like smoke test.

**Historical (pre-Webpack scripts):** The workflow below was used when dev server meant Turbopack-only:

```text
npm run build
npx serve@latest out -l 3000
```

That **static `out/`** path is **obsolete** now that Payload needs **`next start`**. See **Run-Next-JS.md**.

---

### 2026-04-08 — CHECKPOINT: "Pick Your Call Window" modal polished and working

**Status: STABLE — everything working on production build.**

- **Changed:** Removed Today/Tomorrow quick-shortcut buttons from the schedule modal (redundant — calendar covers any date).
- **Changed:** Replaced the native `<select>` time picker (unstyled browser blue highlight) with a fully custom gold-themed dropdown:
  - Trigger button shows gold border + gold text on selection; chevron rotates on open.
  - Dropdown list has dark `#13131a` background, gold border (`rgba(245,184,65,0.25)`), and each option highlights gold on hover and when selected.
  - Auto-closes when a time is chosen or when the calendar date changes.
- **Removed:** `getToday()` / `getTomorrow()` helper functions (no longer needed).
- **Added:** `timeDropdownOpen` state to `ContactSection`.
- **Files changed:** `components/contact-section.tsx` only.
- **Build:** `npm run build` passed clean (0 errors, 0 lints) in ~6s.
- **Served:** `npx serve out -l 3000` → `http://localhost:3000/` confirmed working.

**Revert reference:** To roll back to the button-grid time picker, restore the `{/* Time picker */}` block in `contact-section.tsx` to the version using `display: grid; gridTemplateColumns: repeat(3,1fr)` buttons, remove the `timeDropdownOpen` state, and restore `getToday`/`getTomorrow` if shortcuts are wanted again.

**What is working at this checkpoint:**
- Hero carousel cycles through all 4 images automatically.
- Demos section switches featured video when a thumbnail is clicked.
- Schedule a Call button opens the modal; calendar + custom gold dropdown work; mock submit shows success.
- All images load from `public/media/`.
- Zero linter errors across all components.

---

### 2026-04-08 — Session closeout

- Done:
  - Removed Today/Tomorrow shortcuts from schedule modal.
  - Replaced native `<select>` with custom gold-styled dropdown in the modal.
  - Rebuild and serve confirmed working.
  - ReCall + Development.md updated with checkpoint.
- Next:
  - Wire WordPress backend: `/wp-json/msc/v1/booking-request` + live slot availability.
  - Replace `BOOKED_SLOT_KEYS` mock with a live WP availability fetch.
  - Add optional email/name fields + confirmation step before final submit.
- Open Questions:
  - Confirm booking data storage in WP (custom table vs CPT/meta).
  - Confirm email provider path (`wp_mail` SMTP plugin vs transactional API).
  - Timezone capture: add `Intl.DateTimeFormat().resolvedOptions().timeZone` to payload?

### 2026-04-08 — Goodbye closeout (continue later)

- Done:
  - Added `.cursor/docs/Site-Plans.md` — backend/CMS options (headless WP vs Payload vs Supabase), static-export constraint, phased headless WP plan, links to Development/ReCall.
  - Runtime cleanup: stopped Node listener on port **3000** (PID 10404); ports **3000-3010** verified clear.
- Next:
  - Resume: read `ReCall.md` + `Development.md` + `Site-Plans.md`, then start **Phase 1** headless WP (`msc-api` plugin + wire `lib/booking.ts`) when ready — or say **Agent mode: build Phase 1**.
- Open questions:
  - Same as prior closeout (WP storage for bookings, email path, timezone in payload).

### 2026-04-08 — Payload CMS MCP (Cursor)

- **Finding:** npm `payload-cms-mcp` CLI runs `server.js` (Express static app only) — not MCP stdio. Real MCP is `api/server.ts` (SSE + `/message`) and **requires Redis** (`REDIS_URL`); meant for Vercel/Railway deploy, not `npx` in Cursor command mode.
- **Action:** Removed broken `payload-cms-mcp` entry from user `~/.cursor/mcp.json`. To use upstream: deploy + Redis + remote MCP URL/SSE in Cursor (see project chat log). **2026-05-29:** Full MCP reorg documented in **`MCP-SETUP.md`** — use workspace **`user-payload`**, REST, or admin instead.

### 2026-04-08 — Dev: switch off Turbopack (broken chunks / blank admin)

- **Symptom:** `SyntaxError` in `/_next/static/chunks/*` and react-dev-overlay; hero/demos dead; `/admin` blank.
- **Cause:** Next 16 default **Turbopack** dev on this stack corrupts or truncates client JS.
- **Fix (era):** Dev scripts forced webpack where the CLI had **`--webpack`**. **Next 15.4+:** plain **`next dev`**. Cleared **`.next`**, restart **`npm run dev:payload`** if chunks look stale.

### 2026-04-08 — Payload CMS integrated (Phase A)

- **Changed:** Removed `output: 'export'`; `withPayload` in `next.config.mjs`; marketing at `app/(site)/page.tsx`; Payload routes under `app/(payload)/`; `payload.config.ts` + SQLite + collections `Users`, `Media`, `Bookings`.
- **Booking:** `NEXT_PUBLIC_MSC_BOOKING_URL=payload` → `POST /api/bookings`; optional `timeZone` on submit. `.env.example` documents vars.
- **Docs:** Updated `Development.md`, `Run-Next-JS.md`, `Site-Plans.md`.
- **Next:** User creates `.env.local`, runs `npm run dev:payload`, seeds admin at `/admin`; later Postgres/Neon + production hardening.

### 2026-04-08 — Restore point RP-2026-04-08-cms-globals

- **Checkpoint:** See [.cursor/docs/Restore-Points.md](./Restore-Points.md) — back up **`payload.sqlite`** before schema changes.
- **Added:** Globals `globals/Homepage.ts`, `globals/SiteSettings.ts`; collection `collections/Leads.ts`; `lib/cms/homepage.ts`, `site-settings.ts`, `content-types.ts`.
- **Wired:** `app/(site)/page.tsx` → CMS hero; `app/(site)/layout.tsx` → `generateMetadata` from Site settings; `HeroSection` accepts optional CMS slides/stats; `next.config` localhost image pattern.
- **Docs:** Development, Site-Plans, ReCall; new Restore-Points file.

### 2026-04-08 — Payload admin: logout link, hydration, docs sync

- **Changed:** Added `components/msc-payload-nav-logout.tsx` + `afterNavLinks` in `payload.config.ts`; `app/(payload)/admin/importMap.js` + `custom.scss` styles; `patch-package` regen for `@payloadcms/next` (`suppressHydrationWarning` on `<html>` after `htmlProps` and on `<body>`).
- **Verified:** With **browser extensions disabled** (e.g. ColorZilla), dev hydration overlay on `/admin` clears; sidebar **Log out** visible; direct **`/admin/logout`** works.
- **Docs:** Expanded **Development.md** (logout, import map, extensions), **Run-Next-JS.md** (`/admin/logout`, admin tip), **Site-Plans.md** (changelog); **ReCall.md** — corrected stale “only build + serve out” workflow vs current **`dev:payload` (Webpack)** and `next start`.

### 2026-04-08 — Checkpoint + check-in prep: hero media relinked

- **Checkpoint:** Added `RP-2026-04-08-hero-media-relinked` in `.cursor/docs/Restore-Points.md`.
- **Data result:** Homepage global `heroSlides` now shows **5** slides total in admin.
- **Migration details:** One-time temp scripts seeded/relinked the 4 original hero slides and preserved the existing custom slide; temp scripts deleted after run.
- **Note:** Source images live under `public/media` as `/media/...` (`tv-wall.jpg`, `show-cards.jpg`, `on-air.jpg`, `creator-solo.jpg`, etc.) and are represented in `Media`.

### 2026-04-08 — Resend verify flow: route + UX confirmed working

- **Backend:** `collections/Leads.ts` now includes GET endpoint `leads /verify/:token` to support browser click-through from email links (with `?token=` fallback).
- **Email:** verification HTML uses `http://localhost:3000/api/leads/verify/${token}`; token generation + send confirmed via Resend adapter in `payload.config.ts`.
- **Frontend UX:** Added verify status toast on homepage via `?verified=success|error`, styled in site gold accent, auto-clears URL param, and appears top-center on mobile / bottom-right on desktop.
- **Contact cleanup:** removed “Need direct booking? Open external link” helper text from the contact card; centered newsletter success text.

### 2026-04-08 — Newsletter engine final UI polish

- **Consistency:** unified the newsletter success pill and verify toast to one shared gold token set in `components/contact-section.tsx`.
- **Affordance:** added `cursor-pointer` hover state on `Schedule a Call` and `Stay in the Loop` buttons for clearer clickability.
- **Status:** newsletter verification loop considered complete for current local scope.

### 2026-04-08 — Duplicate lead signup handling polished

- **Fix:** newsletter submit now detects duplicate-email responses from Payload and shows a clean user-facing message instead of raw JSON.
- **Behavior:** parses API error payload safely, falls back to generic error text when needed.
- **File:** `components/contact-section.tsx`.

### 2026-04-09 — Session closeout (goodbye sequence)

- **Done:**
  - Fixed `ViewPageLinkField` list-view column showing blank placeholder — added `ViewPageLinkCell` (reads `rowData.slug`) registered under `admin.components.Cell`; sidebar `Field` (useFormFields) and list `Cell` now both work.
  - Patched `@payloadcms/drizzle` `insertArrays.js` → DELETE stale child rows before re-insert; resolves `UNIQUE constraint failed` on `pages_blocks_feature_grid_items`.
  - Schema migration `scripts/migrate-sqlite-blocks-id-to-text.py` → block table PKs changed `INTEGER → TEXT` to match Payload 3 ObjectID strings (resolves `datatype mismatch` 500s).
  - Removed `omitFeatureGridItemPrimaryIds` hook (was making datatype mismatch worse).
  - Added `rowInstanceUid` / `itemInstanceUid` `defaultValue: randomUUID()`.
  - `coalesceEmptyPagesSlug` hook + `slug defaultValue: 'msc1'`.
  - Committed all work (`0148054`); created restore branch **`msc-new-payload-polished-v4`** and pushed to origin.
  - Updated `Development.md` — dual-context `ui` field pattern (Field + Cell), Cell props reference, changelog entry.
- **Restore point:** **`msc-new-payload-polished-v4`** on `origin` — tip is commit `0148054`.
- **Resume:** `git checkout msc-new-payload-polished-v4 && git pull` → `npm run dev:payload` → `http://localhost:3000/` and `/admin`.
- **Dev listener:** Stopped **`node.exe`** LISTENING on port **3000** (PID 8272). Brave browser had lingering SYN_SENT connections that time out naturally — no action needed. Run `netstat -ano | findstr ":3000"` to confirm clear on next session start.

### 2026-04-08 — Homepage hero slide SEO connected to metadata

- **Admin UX:** added a dedicated `seo` group in each `Homepage.heroSlides` row (`title`, `description`, `OpenGraph image`) so legacy/global slides can be edited in-place.
- **Frontend SEO:** `app/(site)/layout.tsx` `generateMetadata` now uses the active hero slide SEO first, then falls back to slide content and `Site settings`.
- **Social tags:** OpenGraph + Twitter metadata now mirror the same active-slide SEO values.
- **Helper:** new `getHomepageActiveSlideSeo()` in `lib/cms/homepage.ts`.

### 2026-04-12 — Docs checkpoint (Tier 2 + `msc:parity:ftp`)

- **Trigger:** Custom-Prompts item **22** (`Lets Checkpoint Docs`) — sync docs to **`package.json`**, no required commit.
- **Scripts:** Added **`npm run msc:parity:ftp`** → **`scripts/ftp-parity-check.ps1`**; output **`parity-ftp-report.md`**.
- **Tier 2 copy aligned** across **Jedi-List**, **Custom-Prompts** (items **3**, **38**), **Go-Live-Checklist**, **HOSTINGER-DEPLOY.md**, **START-HERE** (push to live), **Agent-Runbook** (script list): **`pushit:live`** = build → **`msc:pushitup:admin-ui`** → **`pushitup -- .next`** → **`pushitup -- payload.sqlite`** → **`pushitup -- public/media`** → **`dev:fresh`**.
- **Jedi-List:** **`msc:test:hostinger-ftp`** row updated (**PushItUP** honors **`remotePath`** when LIST fails).

### 2026-04-12 — Session closeout (I'm done for now)

- **Shipped:** **`ff47fe5`** — docs checkpoint (Tier 2 + **`msc:parity:ftp`**, **`msc:pushitup`**, **`pushit-live`**, tooling scripts). **`38dd8f8`** — remove **`HeroSlides`**, homepage/Media-driven hero, email **`lib/email-*`**, **`payload-types.ts`**, section/app updates, seeds.
- **Git:** **`mscNowLive-v4-RestorePoint`** matches **`origin`**; **`parity-ftp-report.md`** later added to **`.gitignore`** (**`b92d1be`**).
- **Next session:** **`npm run dev:payload`** (or **`npm run dev`**) from repo root; read **ReCall** + **START-HERE** if resuming cold.
- **Local:** Freed port **3000** via **`scripts/msc-kill-dev-port.mjs`** so the next dev boot is clean.
