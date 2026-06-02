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
- **Solution:** Re-ran `npm run test:hostinger-ftp` to confirm FTPS login success; added docs guidance that env vars must be visually verified in hPanel; added final audit checklist and troubleshooting decision tree/cross-links.
- **Files Changed:** `.cursor/docs/DEPLOYMENT-TROUBLESHOOTING.md`, `.cursor/docs/HOSTINGER-DEPLOY.md`, `.cursor/docs/Prompt-Cheat-Sheet.md`, `.cursor/docs/START-HERE.md`
- **Prevention:** After each deploy, run `npm run verify:live`, `npm run verify:live:version`, `npm run test:hostinger-ftp`, then complete hPanel UI env-var checklist.

## [2026-06-01] Live API 500 after v4 deploy — missing hPanel env vars
- **Error:** `https://mystudiochannel.com/api/globals/projects-home?depth=1` returns **500** after successful v4 deploy; **`/`** and **`/admin`** return **200**.
- **Cause:** Hostinger MCP cannot set environment variables; production **`PAYLOAD_SECRET`**, **`DATABASE_URL`**, and public URL vars must be set manually in hPanel → Node.js → Environment.
- **Solution:** Set all vars per **HOSTINGER-DEPLOY.md** and **DEPLOYMENT-FIXES.md**; restart Node app in hPanel.
- **Prevention:** After every zip/MCP deploy, verify env vars and run **`npm run verify:live`**.

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
- **Prevention:** Always use Ctrl+C to stop dev servers; use npm run kill-dev-port script if needed

## [2026-05-30] Project Identity Bleed and Redundant Documentation
- **Error:** Project contained legacy references to older project names (`msc-new`, `Vader-Engine`), outdated/deprecated hosting services (`Spaceship`, `cPanel`), duplicate custom prompt files (`Custom-Prompts.md` vs `Prompt-Cheat-Sheet.md`), and orphaned skill rules.
- **Cause:** Evolution of the codebase across hosting transitions and workspace naming conventions left legacy configurations, rules, and markdown files.
- **Solution:** 
  1. Merged `Custom-Prompts.md` into `Prompt-Cheat-Sheet.md`, archived `Custom-Prompts.md` to `_archive/`, and updated all references.
  2. Moved 9 orphaned untracked `Vader-Engine` skill files from `.cursor/skills/` to `_archive/cursor-skills-vader/`.
  3. Rewrote and renamed `jon-operator-cpanel.mdc` to `jon-operator-hpanel.mdc` pointing to Hostinger hPanel.
  4. Updated `.cursorrules` and other docs (e.g., `START-HERE.md`, `README.md`, `Go-Live-Checklist.md`, `Development.md`, `Run-Next-JS.md`, `Headless-WP-Backend-Plan.md`, `Site-Plans.md`, `Agent-Runbook.md`, `MCP-SETUP.md`, `GitHub-Cheat-Sheet.md`) to standardize on `MyStudioChannel` and `Hostinger` hPanel.
  5. Established a single master source of truth in `TRUTH.md` at the project root and linked it in `README.md` and `START-HERE.md`.
  6. Verified project health with `verify:next:safe` (0 errors) and ran `verify:local` to confirm all local smoke tests return `200`.
- **Files Changed:** `TRUTH.md`, `README.md`, `.cursorrules`, `.cursor/docs/START-HERE.md`, `.cursor/docs/Prompt-Cheat-Sheet.md`, `.cursor/docs/Go-Live-Checklist.md`, `.cursor/docs/Development.md`, `.cursor/docs/Run-Next-JS.md`, `.cursor/docs/Headless-WP-Backend-Plan.md`, `.cursor/docs/Site-Plans.md`, `.cursor/docs/Agent-Runbook.md`, `.cursor/docs/MCP-SETUP.md`, `.cursor/docs/GitHub-Cheat-Sheet.md`, `.cursor/rules/jon-operator-hpanel.mdc` (created), `.cursor/rules/jon-operator-cpanel.mdc` (deleted).
- **Prevention:** Adhere strictly to the `TRUTH.md` identity map and run `verify:local` to verify changes end-to-end.

## Pending / To Be Investigated
None currently
