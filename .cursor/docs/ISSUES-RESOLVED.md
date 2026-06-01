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
