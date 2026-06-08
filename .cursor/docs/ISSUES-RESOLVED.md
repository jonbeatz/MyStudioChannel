# Issues & Resolutions Log

This file tracks problems encountered during development and how they were resolved.

## Format

Each entry follows this structure:

```markdown
## [YYYY-MM-DD] Issue Title
- **Error:** What happened
- **Cause:** Why it happened
- **Solution:** How it was fixed
- **Files Changed:** Which files changed
- **Prevention:** How to avoid recurrence
```

## Log Entries

## [2026-06-07] Phase 4 audit — rules dedup, Restore-Points trim, bundle/MCP opts
- **Error:** Overlapping deploy rules (`workflow.mdc` vs `global.mdc`); Restore-Points table had 47+ rows; `@sentry/nextjs` floated on `^`; SectionsRenderer ignored `rowInstanceUid`; project MCP secrets required manual paste.
- **Cause:** Incremental doc/rule growth; no retention policy on restore points; caret range on Sentry; React keys used numeric id fallback; `msc-sync-mcp-env` only synced WordPress on project MCP.
- **Solution:** `workflow.mdc` delegates deploy to `global.mdc` + `deploy-safety-hostinger.mdc`. Archived 44 historical restore points to `_archive/Restore-Points-historical.md` (kept 3 active). Pinned `@sentry/nextjs@10.56.0`. `SectionsRenderer` prefers `rowInstanceUid`. Extended sync for `21st-dev-magic` + `browserbase`. UI skill read order in NovaMira-Design.
- **Files Changed:** `.cursor/rules/workflow.mdc`, `.cursor/rules/global.mdc`, `.cursor/docs/Restore-Points.md`, `.cursor/docs/_archive/Restore-Points-historical.md`, `components/blocks/SectionsRenderer.tsx`, `package.json`, `scripts/msc-sync-mcp-env.mjs`, `.env.example`, `next.config.mjs`, `.cursor/docs/MCP-SETUP.md`
- **Prevention:** When adding restore points, trim table to 3 + archive older rows. New chat shortcuts go in `global.mdc`; `workflow.mdc` only wires triggers.

## [2026-06-07] Phase 3 audit — docs alias sync (Option B) + guardrails
- **Error:** ~52 npm script alias drift instances across docs/rules/skills; SoT order contradictions (Jedi-List vs TRUTH); dev Sentry test route exposed in production; weak `PAYLOAD_SECRET` not flagged by doctor.
- **Cause:** Historical short aliases (`verify:live`, `sync:mcp-env`, `migrate:sqlite:*`) documented while `package.json` canonical names use `msc:*`; bulk sync script double-prefixed `msc:msc:sync:mcp-env`; Jedi-List ranked START-HERE above TRUTH.
- **Solution:** Added `scripts/msc-sync-doc-commands.mjs` and bulk-updated 36+ doc files to `msc:*`. Fixed double-prefix in MCP docs. Aligned Jedi-List SoT with TRUTH-first. Gated `/api/dev/sentry-test` with `notFound()` in production. Doctor warns on short `PAYLOAD_SECRET`. Nova skill clarifies WP-only `build:wp-theme`.
- **Files Changed:** `.cursor/docs/*`, `.cursor/rules/*`, `.cursor/skills/*`, `TRUTH.md`, `AGENTS.md`, `scripts/msc-doctor.mjs`, `scripts/msc-sync-doc-commands.mjs`, `app/api/dev/sentry-test/route.ts`
- **Prevention:** Prefer **`msc:*`** in new docs. Re-run **`node scripts/msc-sync-doc-commands.mjs`** after large `package.json` script renames. Keep short aliases only where `KEEP_SHORT` in sync script lists them.

## [2026-06-07] Phase 2 audit — deploy safety + Payload UI patch + /test route
- **Error:** Missing `@payloadcms+ui` patch; `/test` hijacked by middleware; `sync-app` overwrote live DB on code-only fast deploy; `deploy` alias defaulted to MCP; SSH scripts lacked credential preflight.
- **Cause:** Patch file lost from working tree; `test` not in `RESERVED_PATHS`; `sync-app` always `cp payload.sqlite`; `package.json` `deploy` → MCP gateway; only `stop-node` validated `HOSTINGER_SSH_*`.
- **Solution:** Regenerated `patches/@payloadcms+ui+3.81.0.patch` via `patch-package`. Added `test` to middleware reserved paths. `msc:hostinger:sync-app --skip-db` for `pushit:live:fast` default; webpack missing fails deploy. `deploy` → `pushit:live:fast`. Shared `msc-hostinger-ssh-preflight.mjs`. `global.mdc` `msc:db:copy` → `msc:db:copy`.
- **Files Changed:** `middleware.ts`, `patches/@payloadcms+ui+3.81.0.patch`, `scripts/msc-hostinger-*.mjs`, `scripts/lib/msc-hostinger-ssh-preflight.mjs`, `scripts/pushit-live-fast.ps1`, `package.json`, `.cursor/rules/global.mdc`
- **Prevention:** Fast deploy uses `--skip-db` unless `-WithDb`. Run `npx patch-package` after `@payloadcms/ui` upgrades.

## [2026-06-07] Standard backup bloated by reproducible deploy zips (~400 MB)
- **Error:** Standard backups jumped from ~244 MB to ~637 MB after deploy sessions; `zips/` alone was ~525 MB.
- **Cause:** `scripts/msc-backup.mjs` standard robocopy included gitignored `zips/` (`deploy-next.zip`, timestamped `MyStudioChannel-deploy-*.zip`). Archives are reproducible via `msc:deploy:zip` / `pushit:live:fast`.
- **Solution:** Added `zips` to `STANDARD_DIRS` skip list. Added `scripts/clean-zips.ps1` + `npm run backup:clean-zips` (retain 3 newest). Backup folder naming uses `msc-website-v2-*`.
- **Files Changed:** `scripts/msc-backup.mjs`, `scripts/clean-zips.ps1`, `package.json`, `.cursor/custom-scriptz/backup-system/*`, `.cursor/rules/global.mdc`, docs
- **Prevention:** Run **`npm run backup:clean-zips`** after deploys. Standard backup never copies `zips/`.

## [2026-06-08] Hostinger MCP tool naming warnings (Cursor Settings)
- **Error:** MCP panel showed **“Some tools have naming issues and may be filtered out”** on all four `hostinger-*` servers — tools like `hosting_listNode.jsBuildsV1` (dot in `Node.js`).
- **Cause:** (1) `npx hostinger-api-mcp@latest hostinger-hosting-mcp` runs the **default** all-tools binary and passes the scoped name as a ignored CLI arg — every server exposed the same hosting tools. (2) Upstream `hostinger-api-mcp@0.2.6` ships three OpenAPI tool names with `.` which Cursor rejects (`[a-zA-Z0-9_]` only).
- **Solution:** Added **`scripts/msc-hostinger-mcp.mjs`** — spawns `npx -y --package=hostinger-api-mcp <scoped-bin>` and filters invalid tool names from `tools/list`. First proxy draft used obsolete Content-Length framing (MCP SDK now uses newline JSON-RPC) — fixed 2026-06-08. **`msc-sync-mcp-env.mjs`** copies launcher to `~/.cursor/scripts/` and rewrites global `hostinger-*` entries. Documented safe alternatives for Node.js deploy status/logs.
- **Files Changed:** `scripts/msc-hostinger-mcp.mjs`, `scripts/msc-sync-mcp-env.mjs`, `~/.cursor/mcp.json`, `.cursor/docs/MCP-SETUP.md`
- **Prevention:** After Hostinger MCP edits run **`npm run msc:sync:mcp-env`** then reload in **Settings → MCP**. Do not revert to `hostinger-api-mcp@latest` + string arg pattern.

## [2026-06-08] Hostinger MCP spawn EINVAL on Windows (Cursor)
- **Error:** `hostinger-hosting`, `hostinger-vps`, `hostinger-domains`, `hostinger-dns` failed to start — **`Error: spawn EINVAL`**; MCP panel showed duplicate `?` rows.
- **Cause:** Global `~/.cursor/mcp.json` used **`"command": "npx.cmd"`** with `--package=…` args. Cursor's MCP runner on Windows does not spawn that reliably (unlike **`cmd /c npx -y …`** used by github/tavily).
- **Solution:** Changed all four Hostinger blocks away from bare **`npx.cmd`**. Later superseded by **`msc-hostinger-mcp.mjs`** launcher (see tool-naming entry above). Added **`HOSTINGER_API_TOKEN`** to `.env.local`; extended **`msc-sync-mcp-env.mjs`** to sync all `hostinger-*` servers.
- **Files Changed:** `~/.cursor/mcp.json` (global, outside repo), `scripts/msc-sync-mcp-env.mjs`, `.env.example`, `.cursor/docs/MCP-SETUP.md`, `.cursor/docs/Site-Plans.md`
- **Prevention:** On Windows, never use bare `npx.cmd` for MCP. Use **`npm run msc:sync:mcp-env`** so launcher args stay correct. Reload in **Settings → MCP** after edits; restart Cursor if duplicate stale rows persist.

## [2026-06-08] msc:sync:mcp-env fails on Node 24 (require in ESM)
- **Error:** `npm run msc:sync:mcp-env` → `ReferenceError: require is not defined in ES module scope`
- **Cause:** `scripts/msc-sync-mcp-env.mjs` used CommonJS `require()` while Node treats `.mjs` as ESM.
- **Solution:** Converted to `import fs from 'node:fs'` + `import.meta.url` for `__dirname`.
- **Files Changed:** `scripts/msc-sync-mcp-env.mjs`
- **Prevention:** Use ESM `import` in all `.mjs` scripts; run **`npm run msc:sync:mcp-env`** after `.env.local` MCP secret edits, then reload in **Settings → MCP** (or restart Cursor).

## [2026-06-08] pushit:live:fast — zip landed under zips/ on FTPS staging
- **Error:** First **`pushit:live:fast`** test: SSH unzip failed (`missing deploy-next.zip on staging`); zip path fallback did not run; staging had **`zips/deploy-next.zip`** instead of **`deploy-next.zip`** at FTPS root.
- **Cause:** **`msc:pushitup`** preserves relative paths — uploading **`zips/deploy-next.zip`** lands at **`public_html/nodejs/zips/deploy-next.zip`**, while **`msc:hostinger:unzip-deploy-next`** expected **`public_html/nodejs/deploy-next.zip`**.
- **Solution:** **`pushit-live-fast.ps1`** copies zip to repo-root **`deploy-next.zip`** before FTPS (remote staging root). Unzip script checks **`zips/`** as legacy fallback. Added **`msc:pushit:live:fast:dry`** for preflight. Live verified after manual unzip + **`sync-app`**; **`msc:verify:live`** pass.
- **Files Changed:** `scripts/pushit-live-fast.ps1`, `scripts/msc-hostinger-unzip-deploy-next-ssh.mjs`, `package.json`, deploy docs
- **Prevention:** Always upload **`deploy-next.zip`** at FTPS **`/nodejs`** root (not under **`zips/`**). Preflight with **`npm run msc:pushit:live:fast:dry`**.

## [2026-06-08] pushit:live:fast — Tier 2b fast deploy (~10–15 min)
- **Error:** Daily **`pushit:live`** took ~45–60 min (thousands of FTPS files for **`.next`**).
- **Cause:** Full FTPS uploads every **`.next`** chunk individually; reliable but slow.
- **Solution:** Added **`npm run pushit:live:fast`**: local build → zip **`.next`** → single FTPS file → SSH unzip + **BUILD_ID** verify → **`sync-app`**. Flags: **`-SkipBuild`**, **`-WithDb`**, **`-WithMedia`**, **`-DryRun`**. Fallback to **`pushitup -- .next`** if zip path fails. **`pushit:live`** unchanged for full DB + media parity.
- **Files Changed:** `scripts/pushit-live-fast.ps1`, `scripts/msc-hostinger-unzip-deploy-next-ssh.mjs`, `package.json`, `MASTER-COMMANDS.md`, `HOSTINGER-DEPLOY.md`, `Go-Live-Checklist.md`, `Push-Website-Live.md`
- **Prevention:** Use **`pushit:live:fast`** for daily code/UI; **`pushit:live`** when DB/media must ship or new npm packages added.

## [2026-06-08] Live 503 after deploy — broken node_modules (missing Next webpack) + two-folder confusion
- **Error:** `https://mystudiochannel.com` returned **503** after FTPS deploy. hPanel showed **Build failed** (MCP). Operator saw **`public_html/nodejs`** and top-level **`nodejs`** and assumed misplacement.
- **Cause:** (1) FTPS lands under **`public_html/nodejs/`** while Node runs from **`domains/.../nodejs/`** — without **`sync-app`**, code/`.next`/lockfile never reached the app root. (2) Syncing **`package-lock.json`** without **`npm install`** left **`node_modules/next`** incomplete → `stderr.log`: `Cannot find module 'next/dist/compiled/webpack/webpack'`. (3) Plain **`npm install`** on host fails on **`better-sqlite3`** (`node-gyp` / GLIBC). (4) hPanel **Build failed** was a **stale MCP** attempt, not the healthy FTPS path.
- **Solution:** SSH **`npm install --legacy-peer-deps --ignore-scripts`** on app root (script: **`msc:hostinger:npm-install`**). Hardened **`msc:hostinger:sync-app`** to mirror staging → app root and run the same npm step after every deploy. Added **`msc:hostinger:recover`** for diagnose/preload/log trim. **`pushit:live`** already runs **`sync-db`** + **`sync-app`**. Live restored: **`msc:verify:live`** + **`msc:verify:live:version`** **v6.0.0**, Legal **`pages-collection`**.
- **Files Changed:** `scripts/msc-hostinger-sync-app-ssh.mjs`, `scripts/msc-hostinger-npm-install-ssh.mjs`, `scripts/msc-hostinger-live-recover-ssh.mjs`, `package.json`, `.cursor/docs/HOSTINGER-DEPLOY.md`, `.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md`, `.cursor/docs/MASTER-COMMANDS.md`, `.cursor/docs/START-HERE.md`, `.cursor/docs/Go-Live-Checklist.md`, `.cursor/prompts/Push-Website-Live.md`
- **Prevention:** Use **`npm run pushit:live`** for updates (not MCP alone). Never delete **`public_html/nodejs/`**. After any lockfile sync, ensure **`sync-app`** ran (includes **`--ignore-scripts`** npm). If **503**, check **`stderr.log`** for webpack/preload errors → **`msc:hostinger:npm-install`** or **`msc:hostinger:recover`**.

## [2026-06-07] Header Pages dropdown confusing — magic label vs manual submenus
- **Error:** **Pages** nav showed MSC1, Privacy Policy, and Terms of Service, but Header admin had no submenu rows (unlike Services/Resources). Renaming or editing manual submenu had no effect.
- **Cause:** Runtime treated any nav row labeled exactly **Pages** as special — it ignored manual submenu/link and auto-built the dropdown from the **Pages** collection. Two different systems looked like one broken editor.
- **Solution:** Added explicit **`submenuSource`** per Header row (**Manual** | **From Pages collection**). Added **`showInHeaderNav`** on Pages (MSC1 opted out). Renamed dropdown label to **Legal**. Migrations: **`msc:migrate:sqlite:header-nav-submenu-source`** (adds column, sets legacy rows, renames **Pages** → **Legal**), **`msc:migrate:sqlite:pages-show-in-header-nav`**.
- **Files Changed:** `globals/Header.ts`, `lib/cms/header.ts`, `collections/Pages.ts`, `seed-data/header.json`, `scripts/migrate-sqlite-header-nav-submenu-source.py`, `scripts/migrate-sqlite-pages-show-in-header-nav.py`, `package.json`, `payload-types.ts`, `.cursor/docs/Development.md`
- **Prevention:** Use **Submenu source** in Header admin — never rely on label text for behavior. After code deploy with new fields, run both SQLite migrations on live before restart.

## [2026-06-07] Live stub DB after MCP/Git deploy — FTPS lands in wrong tree
- **Error:** Live `/api/globals/*` returned **500** (`no such table: site_settings`) while `/` and `/admin` returned **200**. File Manager showed **`payload.sqlite` = 4 KB** in live app root (`/nodejs/`) despite Git repo and deploy zip containing **~507–540 KB** DB.
- **Cause:** **MCP zip and Git-connected hPanel rebuilds are code deploys, not DB deploys** — server build/extract does not reliably apply `payload.sqlite` to the Node app root. Separately, FTPS uploads with `remotePath: /nodejs` land under **`public_html/nodejs/`**, not where the Node process reads files.
- **Solution:** Added **`npm run msc:hostinger:sync-db`** (SSH copy `public_html/nodejs/payload.sqlite` → app root), **`npm run msc:push:db:live`** (quick ~1–2 min DB path), and **`npm run msc:hostinger:stop-node`** (SSH stop). Full FTPS deploy + sync-db + hPanel restart restored live health; **`msc:verify:live`** passed including `/api/globals/projects-home` **200**.
- **Files Changed:** `scripts/msc-hostinger-sync-db-ssh.mjs`, `scripts/msc-hostinger-stop-node-ssh.mjs`, `scripts/msc-push-db-live.mjs`, `scripts/push-website-live.ps1`, `package.json`, `.cursor/docs/HOSTINGER-DEPLOY.md`, `.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md`, `.cursor/prompts/Push-Website-Live.md`, `.cursor/rules/global.mdc`, `.cursor/rules/workflow.mdc`
- **Prevention:** Say **push it live** → agent asks deploy mode first. Treat MCP/Git as **code-only**; verify live DB is **~500 KB** after any code deploy. Use **`msc:push:db:live`** for stub DB; use **Full FTPS + `sync-db`** for reliable DB parity.

## [2026-06-07] Created DesignMD and GitHub-Ops and Premium-UI Portable Skill Packs
- **Symptom:** UI component references, styling specifications (e.g. `@designmdcc/cli`), and external repository management processes were not organized or reusable across different workspaces.
- **Root Cause:** Standardizing design system extractions and external GitHub integrations required custom, portable instructions to ensure future AI agents immediately inherit these custom capabilities.
- **Resolution:** Created `.cursor/skills/DesignMD/SKILL.md` (DesignMD automation logic), `.cursor/skills/GitHub-Ops/SKILL.md` (discovery and GH API operations), and `.cursor/skills/Premium-UI/SKILL.md` (pre-wired UI registry and package mappings including Cult, Aceternity, Ali Imam, Animate UI, Its Hover, 21st.dev Magic, MotionSites, and Lenis). Configured multi-registry namespaces inside `components.json`. Logged checkpoints in `MASTER-COMMANDS.md`, `AGENTS.md`, `Restore-Points.md`, and `Checkpoint.md`.
- **Files Changed:** `components.json`, `AGENTS.md`, `.cursor/skills/DesignMD/SKILL.md` (created), `.cursor/skills/GitHub-Ops/SKILL.md` (created), `.cursor/skills/Premium-UI/SKILL.md` (created), `.cursor/docs/PREMIUM-UI-CATALOG.md` (created), `.cursor/docs/MASTER-COMMANDS.md`, `.cursor/docs/Restore-Points.md`, `.cursor/docs/Checkpoint.md`
- **Prevention:** Reference the respective skill packs inside `.cursor/skills/` to instantly utilize these pre-wired UI builders and operational utilities.

## [2026-06-02] Live Site 503 Service Unavailable due to Missing Hostinger Preload File
- **Error:** `https://mystudiochannel.com` returned a 503 Service Unavailable error immediately, even though Node.js showed running and the database/files were in place.
- **Cause:** Hostinger's Node.js process manager expects a preload/config structure under `/public_html/.builds/config/preload-timestamp.js`. If `.builds/` is deleted (such as during manual FTP or file system cleanups), Hostinger's app runner throws `MODULE_NOT_FOUND` and fails silently or with 503.
- **Solution:** Connected via SSH and recreated the missing directory structure (`mkdir -p /home/u942711528/domains/mystudiochannel.com/public_html/.builds/config`) and touched/configured a dummy `preload-timestamp.js` file with permissions `644`.
- **Files Changed:** Created remote folder `/public_html/.builds/config/preload-timestamp.js`. Updated `.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md`, `.cursor/docs/HOSTINGER-DEPLOY.md`, `.cursor/docs/START-HERE.md`.
- **Prevention:** Never delete the `/public_html/.builds/` directory during cleanups, or immediately restore it using SSH/File Manager if it is accidentally removed.

## [2026-06-02] SQLite WAL Journal Locking on Hostinger App Server (Now Automated via FTPS)
- **Error:** Upon uploading a fresh database to `/nodejs/payload.sqlite`, the live site returned 500/504 errors because of SQLite Write-Ahead Log (WAL) locks.
- **Cause:** SQLite generates `-wal` and `-shm` files for active connections. When the database binary (`payload.sqlite`) is replaced via FTPS, the existing `-wal` and `-shm` files mismatch, causing locking issues until they are deleted and the Node.js process restarted.
- **Solution:** Updated `push-website-live.ps1` (FTPS fallback mode) to parse `.vscode/sftp.json` credentials, perform automated verification of the uploaded `payload.sqlite` file size, and issue FTP commands to automatically delete `payload.sqlite-wal` and `payload.sqlite-shm` on the server before prompting for restart.
- **Files Changed:** `scripts/push-website-live.ps1`, `.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md`, `.cursor/docs/HOSTINGER-DEPLOY.md`.
- **Prevention:** The deploy script now completely automates WAL file deletion and size checks on the server, eliminating the risk of manual omission.

## [2026-06-02] Created Single Source of Truth for Project Commands
- **Error:** Developers had to search across multiple markdown files (`START-HERE.md`, `Jedi-List.md`, `Prompt-Cheat-Sheet.md`) to find working dev, deployment, and troubleshooting commands.
- **Cause:** Incremental feature additions left commands scattered across various files without a single master index.
- **Solution:** Created `.cursor/docs/MASTER-COMMANDS.md`, consolidating all local dev, deployment options (with database support distinctions), database copying rules, connection diagnostic commands, manual SSH guides, recovery routines, environment variables, copy-paste quick cards, and success check templates. Cross-linked the new file from `START-HERE.md`, `Prompt-Cheat-Sheet.md`, and `README.md`.
- **Files Changed:** `.cursor/docs/MASTER-COMMANDS.md`, `.cursor/docs/START-HERE.md`, `.cursor/docs/Prompt-Cheat-Sheet.md`, `README.md`.
- **Prevention:** Keep all operational scripts and commands indexed inside `MASTER-COMMANDS.md` as the single authoritative source of truth.

## [2026-06-02] Hostinger verification gap: env vars are UI-only + FTPS auth fluctuation
- **Error:** Connectivity checks gave mixed confidence: FTPS initially returned `530 Not logged in`, and automated checks could not reliably prove hPanel environment variables from scripts.
- **Cause:** FTPS credentials/session state can intermittently fail; Hostinger env vars are managed in hPanel UI and are not consistently exposed via MCP/SSH read-only diagnostics.
- **Solution:** Re-ran `npm run msc:test:hostinger-ftp` to confirm FTPS login success; added docs guidance that env vars must be visually verified in hPanel; added final audit checklist and troubleshooting decision tree/cross-links.
- **Files Changed:** `.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md`, `.cursor/docs/HOSTINGER-DEPLOY.md`, `.cursor/docs/Prompt-Cheat-Sheet.md`, `.cursor/docs/START-HERE.md`
- **Prevention:** After each deploy, run `npm run msc:verify:live`, `npm run msc:verify:live:version`, `npm run msc:test:hostinger-ftp`, then complete hPanel UI env-var checklist.

## [2026-06-01] Live API 500 after v4 deploy — missing hPanel env vars
- **Error:** `https://mystudiochannel.com/api/globals/projects-home?depth=1` returns **500** after successful v4 deploy; **`/`** and **`/admin`** return **200**.
- **Cause:** Hostinger MCP cannot set environment variables; production **`PAYLOAD_SECRET`**, **`DATABASE_URL`**, and public URL vars must be set manually in hPanel → Node.js → Environment.
- **Solution:** Set all vars per **HOSTINGER-DEPLOY.md** and **DEPLOYMENT-FIXES.md**; restart Node app in hPanel.
- **Prevention:** After every zip/MCP deploy, verify env vars and run **`npm run msc:verify:live`**.

## [2026-06-01] Hostinger build fails — missing production dependencies
- **Error:** `Cannot find module '@tailwindcss/postcss'`, `Can't resolve 'tw-animate-css'` during `npm run build` on Hostinger Node.js.
- **Cause:** Hostinger runs **`npm install --production`** before build — packages in **`devDependencies` are not installed**. PostCSS plugins and CSS `@import` packages were listed as dev-only.
- **Solution:** Moved **`@tailwindcss/postcss`**, **`postcss`**, and **`tw-animate-css`** to **`dependencies`**. Documented **The Canonical Rule** in **`DEPLOYMENT-FIXES.md`** and **`HOSTINGER-DEPLOY.md`**. Pre-deploy audit: **`npm ls --omit=dev --depth=0`**. Use **npm** only (delete **`pnpm-lock.yaml`** if present).
- **Files Changed:** `package.json`, `package-lock.json`, `.cursor/docs/HOSTINGER-DEPLOY.md`, `.cursor/docs/DEPLOYMENT-FIXES.md`, START-HERE, Jedi-List, Go-Live-Checklist, TRUTH.md
- **Prevention:** Before every zip deploy or Git rebuild on Hostinger, run **`npm ls --omit=dev --depth=0`**. If a build-time import is missing, move it to **`dependencies`**.

## [2026-06-01] Dual version numbers (package vs admin) confused operators
- **Error:** Footer showed `Release v1.0.24` while README/docs referenced `v3.0.0`; operators were told to bump `lib/msc-admin-version.ts` separately from `package.json`.
- **Cause:** Legacy admin deploy marker (`MSC_ADMIN_VERSION`) ran parallel to npm semver after the v3 product bump.
- **Solution:** Removed `lib/msc-admin-version.ts`. Added `lib/msc-app-version.ts` importing `package.json` only. User-facing strings: `MyStudioChannel v3.0.0` (footer), `MyStudioChannel Admin v3.0.0` (Payload sidebar). Updated `Jedi-List.md`, `Go-Live-Checklist.md`, deploy script file list in `package.json`.
- **Files Changed:** `lib/msc-app-version.ts`, `components/footer.tsx`, `components/msc-payload-nav-logout.tsx`, `components/msc-payload-graphics.tsx`, `package.json` (deleted `lib/msc-admin-version.ts`)
- **Prevention:** Bump **`package.json`** `"version"` only on release; confirm footer + `/admin` labels after deploy. See **Jedi-List** → *Release version*.

## [2026-05-30] Hero Section Images Mismatch
- **Error:** Hero slides showing demo preview images instead of hero images
- **Cause:** Database had wrong media IDs assigned (Demos-* images instead of hero-studio.jpg, show-artwork.jpg, on-air-bg.jpg, creator-in-mind.jpg)
- **Solution:** Ran fix-homepage-hero-slide-images.py to reassign correct media IDs
- **Files Changed:** payload.sqlite, scripts/fix-homepage-hero-slide-images.py
- **Prevention:** Verify media selections in Payload admin when editing hero slides; use the fix script if mismatch occurs

## [2026-05-29] MCP Duplicate Servers
- **Error:** MCPs appearing twice in Cursor list
- **Cause:** Same server defined in both global ~/.cursor/mcp.json and project .cursor/mcp.json
- **Solution:** Removed duplicates from project .cursor/mcp.json; kept only WordPress MCPs (local-wp, mcp-wordpress) in project config
- **Files Changed:** .cursor/mcp.json, .cursor/mcp.servers.archived.json
- **Prevention:** Keep only project-specific MCPs in project config; use global config for shared tools

## [2026-05-29] Temporary Button Redirects
- **Error:** N/A (intentional temporary change)
- **Change:** All CTA buttons redirected to external forms/calendar (Google Forms for consultations, Google Calendar for scheduling)
- **Files Changed:** components/header.tsx, components/hero-section.tsx, components/packages-section.tsx, components/contact-section.tsx, components/built-for-creators-section.tsx, components/requirements-section.tsx
- **Restore Instructions:** Search for // TEMPORARY REDIRECT in each file, delete the window.open() line, uncomment the original code above it

## [2026-05-29] Git Author Name Incorrect
- **Error:** Commits showing "mscAdmin" instead of "JonBeatz"
- **Cause:** Git global config had incorrect user.name
- **Solution:** Ran git config --global user.name "JonBeatz" and git config --global user.email "jonbeatz@gmail.com"
- **Files Changed:** Git config only (no project files)
- **Prevention:** Always set Git config on new machines before committing

## [2026-05-29] Port 3000 Already in Use
- **Error:** EADDRINUSE: address already in use :::3000
- **Cause:** Previous dev server process still running in background
- **Solution:** Found PID using netstat -ano | findstr :3000 and killed with taskkill /PID 11520 /F
- **Files Changed:** None
- **Prevention:** Always use Ctrl+C to stop dev servers; use npm run msc:kill-dev-port script if needed

## [2026-05-30] Project Identity Bleed and Redundant Documentation
- **Error:** Project contained legacy references to older project names (`msc-new`, `Vader-Engine`), outdated/deprecated hosting services (`Spaceship`, `cPanel`), duplicate custom prompt files (`Custom-Prompts.md` vs `Prompt-Cheat-Sheet.md`), and orphaned skill rules.
- **Cause:** Evolution of the codebase across hosting transitions and workspace naming conventions left legacy configurations, rules, and markdown files.
- **Solution:** 
  1. Merged `Custom-Prompts.md` into `Prompt-Cheat-Sheet.md`, archived `Custom-Prompts.md` to `_archive/`, and updated all references.
  2. Moved 9 orphaned untracked `Vader-Engine` skill files from `.cursor/skills/` to `_archive/cursor-skills-vader/`.
  3. Rewrote and renamed `jon-operator-cpanel.mdc` to `jon-operator-hpanel.mdc` pointing to Hostinger hPanel.
  4. Updated `.cursorrules` and other docs (e.g., `START-HERE.md`, `README.md`, `Go-Live-Checklist.md`, `Development.md`, `Run-Next-JS.md`, `Headless-WP-Backend-Plan.md`, `Site-Plans.md`, `Agent-Runbook.md`, `MCP-SETUP.md`, `GitHub-Cheat-Sheet.md`) to standardize on `MyStudioChannel` and `Hostinger` hPanel.
  5. Established a single master source of truth in `TRUTH.md` at the project root and linked it in `README.md` and `START-HERE.md`.
  6. Verified project health with `verify:next:safe` (0 errors) and ran `msc:verify:local` to confirm all local smoke tests return `200`.
- **Files Changed:** `TRUTH.md`, `README.md`, `.cursorrules`, `.cursor/docs/START-HERE.md`, `.cursor/docs/Prompt-Cheat-Sheet.md`, `.cursor/docs/Go-Live-Checklist.md`, `.cursor/docs/Development.md`, `.cursor/docs/Run-Next-JS.md`, `.cursor/docs/Headless-WP-Backend-Plan.md`, `.cursor/docs/Site-Plans.md`, `.cursor/docs/Agent-Runbook.md`, `.cursor/docs/MCP-SETUP.md`, `.cursor/docs/GitHub-Cheat-Sheet.md`, `.cursor/rules/jon-operator-hpanel.mdc` (created), `.cursor/rules/jon-operator-cpanel.mdc` (deleted).
- **Prevention:** Adhere strictly to the `TRUTH.md` identity map and run `msc:verify:local` to verify changes end-to-end.

## Pending / To Be Investigated
None currently
