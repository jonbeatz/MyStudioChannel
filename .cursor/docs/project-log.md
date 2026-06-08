## [2026-06-08] - MSC-Website-v7 branch cut
- **Branch:** `MSC-Website-v7` created from `MSC-Website-v6` @ `c9e260e` and pushed; active dev branch
- **Policy:** `MSC-Website-v6` frozen @ `c9e260e` as clean restore; full backup `msc-website-v2-f`
- **Changes:** Restore-Points, Checkpoint, ReCall, TRUTH, ops docs synced to v7 active line
- **Status:** completed — version still 6.0.0 until release
- **Next:** Feature work on `MSC-Website-v7`

## [2026-06-08] - Hostinger MCP launcher + docs sync
- **Branch:** MSC-Website-v6
- **Changes:** **`scripts/msc-hostinger-mcp.mjs`** (scoped Hostinger bins + invalid tool-name filter). Extended **`msc-sync-mcp-env.mjs`** to copy launcher to `~/.cursor/scripts/`. Docs: **MCP-SETUP**, **ISSUES-RESOLVED**, **START-HERE**, **MASTER-COMMANDS**, **Prompt-Cheat-Sheet**, **ReCall** — MCP reload via **Settings → MCP** (cursor-mcp-refresh uninstalled). Verified 4 Hostinger servers: hosting 27, vps 62, domains 18, dns 8 tools; zero naming warnings.
- **Status:** completed — committed `57f3304` and pushed
- **Next:** Feature work on v6; optional DeepSeek via LiteLLM `model_list`

## [2026-06-07 22:45] - Session closeout — audit complete, planning docs, backups
- **Branch:** MSC-Website-v6 @ `e06627e` (pushed)
- **Changes:** Comprehensive audit Phases 2–4 (`9d9831f`); project analysis (86/100); **`.cursor/ideaz.md`** + **`.cursor/review.md`**; docs sync (`2c2e94d`, `e06627e`). Quick backups **`msc-website-v2-d`** @ `9d9831f`, **`msc-website-v2-e`** @ `e06627e`.
- **Status:** completed — all code/docs committed and pushed; only **`payload.sqlite`** unstaged (local dev)
- **Next:** See **`.cursor/review.md`** — live v6 deploy + `msc:verify:live:version`; hygiene (`NODE_ENV`, sqlite git policy); portable kit from **ideaz.md** when ready

## [2026-06-07] - Docs sync — ideaz + review planning files
- **Branch:** MSC-Website-v6 @ `9d9831f` (audit already pushed)
- **Changes:** Added **`.cursor/ideaz.md`** (portable studio kit / `custom-scriptz` roadmap) and **`.cursor/review.md`** (audit follow-up, score 86/100, tomorrow queue). Ran **`msc:docs:sync`** (PERFECT SYNC). Updated TRUTH, START-HERE, Checkpoint, CHANGELOG, ReCall.
- **Status:** completed — docs commit pending this entry
- **Next:** See **review.md** — live v6 deploy, `NODE_ENV` in `.env.local`, `payload.sqlite` policy

## [2026-06-08] - Session closeout — MCP docs + Hostinger MCP fix
- **Branch:** MSC-Website-v6 @ `667eb20`
- **Changes:** Updated **MCP-SETUP.md** (global 12 servers, secrets checklist). Fixed Hostinger MCP **`spawn EINVAL`** — global `~/.cursor/mcp.json` now uses `cmd /c npx -y hostinger-api-mcp@latest`. Added **`HOSTINGER_API_TOKEN`** to `.env.local`; extended **`msc-sync-mcp-env.mjs`** to sync all four `hostinger-*` servers. Verified API (`mystudiochannel.com` listed). **Start Project** ritual run; ports stopped.
- **Status:** completed — committed in follow-up (docs + sync script)
- **Next:** Feature work on v6; project MCP secrets (WordPress, 21st, Browserbase) when needed

## [2026-06-07 19:15] - Session closeout — backup + port shutdown
- **Branch:** MSC-Website-v6 @ `667eb20`
- **Changes:** Interactive **backup project** → `G:\Cursor_Project_BackUpz\MyStudioChannel\msc-website-v2-a` (Standard). Note: Hostinger upload workflow + new MCPs. Prior session work already committed/pushed (`27adb12`, `667eb20`). Working tree: only `payload.sqlite` (local dev, not committed).
- **Status:** completed — session stopped; ports cleared
- **Next:** Say **Start Project**; reload MCP (cursor-mcp-refresh); Obsidian kepano skills Week 1

## [2026-06-08] - MSC Tooling Upgrade + Obsidian pilot + MCP consolidation
- **Branch:** MSC-Website-v6
- **Changes:** Added **MSC-UI-Taste** skill; Gilfoyle **harsh-review** prompt + global rule; archived **browsermcp** + **antigravity** from project MCP (6 servers); **CURATED-INDEX** for imported playbooks; **cursor-mcp-refresh** VSIX; **codeburn** + **`msc:codeburn`**; Obsidian vault structure at **`I:\Vader_Vault`**; fixed **`msc-sync-mcp-env.mjs`** for Node 24 ESM. Synced AGENTS, MCP-SETUP, TOOL-CHEST, Jedi-List, ReCall, Checkpoint, Prompt-Cheat-Sheet, START-HERE.
- **Status:** completed — `verify:next:safe` pass; no Hostinger/production changes
- **Next:** Reload MCP after restart; Obsidian kepano skills Week 1; Friday ReCall distill ritual

## [2026-06-08] - pushit:live:fast (Tier 2b) + full docs sync
- **Branch:** MSC-Website-v6
- **Changes:** Added **`pushit:live:fast`** (~10–15 min): zip **`.next`** → single FTPS → SSH unzip (BUILD_ID) → **`sync-app`**. Scripts: **`pushit-live-fast.ps1`**, **`msc-hostinger-unzip-deploy-next`**. Fixed zip upload path (repo-root **`deploy-next.zip`** for FTPS, not **`zips/`** on remote). Flags **`-SkipBuild`**, **`-WithDb`**, **`-WithMedia`**, **`-DryRun`**. Updated MASTER-COMMANDS, HOSTINGER-DEPLOY, Go-Live-Checklist, Push-Website-Live, Checkpoint, ReCall, Restore-Points, Jedi-List, START-HERE, README, AGENTS, rules.
- **Status:** completed — live **`msc:verify:live`** passing after deploy test
- **Next:** Routine code/UI via **`pushit:live:fast`**; full parity via **`pushit:live`**

## [2026-06-08] - Live 503 recovery, sync-app hardening, full docs sync
- **Branch:** MSC-Website-v6 @ `b368d3e`
- **Changes:** Diagnosed live **503** — `node_modules` missing Next webpack after lockfile sync; fixed via SSH **`npm install --ignore-scripts`**. Added **`msc:hostinger:sync-app`**, **`msc:hostinger:npm-install`**, **`msc:hostinger:recover`**. Wired **`sync-app`** into **`pushit:live`** and **`msc:push:db:live`**. Documented two **`nodejs`** folders (FTPS staging vs live app root), MCP **Build failed** note, prevention checklist across HOSTINGER-DEPLOY, DEPLOYMENT-TROUBLESHOOTING, MASTER-COMMANDS, Jedi-List, Checkpoint, ReCall, Restore-Points, AGENTS, rules.
- **Status:** completed — live **v6.0.0**, **`msc:verify:live`** passing
- **Next:** Routine updates via **`pushit:live`** only; avoid MCP zip on this host

## [2026-06-08] - Header nav submenuSource, Legal label, docs sync
- **Branch:** MSC-Website-v6
- **Changes:** Replaced magic **Pages** nav label with explicit **`submenuSource`** (Manual | From Pages collection). Added **`showInHeaderNav`** on Pages; excluded MSC1. Renamed dropdown to **Legal**. SQLite migrations + seed update. Synced CHANGELOG, ISSUES-RESOLVED, Development, MASTER-COMMANDS, Checkpoint, DEPLOYMENT-TROUBLESHOOTING.
- **Status:** completed
- **Next:** Deploy v6 + run live SQLite migrations when pushing header nav changes.

## [2026-06-07 23:30] - GitHub releases/tags backfill and docs audit
- **Branch:** MSC-Website-v6 @ `17b3da8`
- **Changes:** Published GitHub tags/releases for `v4.0.0` (`87ec9de`), `v5.0.0` (`d14a4b2`), and `v6.0.0` (`17b3da8`). Set `v6.0.0` as Latest. Ran `msc:docs:audit` (PERFECT SYNC). Updated Checkpoint, CHANGELOG compare links, GitHub-Cheat-Sheet releases table, ReCall.
- **Status:** completed
- **Next:** Feature work on `MSC-Website-v6`; deploy to show v6.0.0 on live.

## [2026-06-07 22:30] - Version bump to 6.0.0 and MSC-Website-v6 branch cut
- **Branch:** MSC-Website-v6 (cut from MSC-Website-v5 @ `92918b6`)
- **Changes:** Bumped global project version to `6.0.0` in `package.json`. Created `MSC-Website-v6` development branch. Synchronized branch/version references across operational documentation (README, TRUTH, Checkpoint, CHANGELOG, MASTER-COMMANDS, HOSTINGER-DEPLOY, Jedi-List, Go-Live-Checklist, GitHub-Cheat-Sheet, Development, ReCall, Restore-Points). Updated `msc-audit-docs.mjs` for v6 branch checks. Test playground footer reads version from `lib/msc-app-version.ts`.
- **Status:** completed
- **Next:** Feature work on `MSC-Website-v6`; deploy when ready to show v6.0.0 on live.

## [2026-06-07 18:00] - Deploy hardening, live DB sync, docs sync
- **Branch:** MSC-Website-v5 @ `06ec2be`
- **Changes:** Fixed Sentry org/project wiring (`mystudiochannel`); migrated to `instrumentation-client.ts` + `global-error.tsx`. Added SSH scripts (`msc:hostinger:stop-node`, `msc:hostinger:sync-db`), quick DB deploy (`msc:push:db:live`), and `msc:session:stop`. Wired auto `sync-db` into `pushit:live` (FTPS landing → live app root). Documented MCP/Git as code-only deploys with AskQuestion mode picker. Restored live site via Full FTPS + sync-db; `msc:verify:live` passed. Pushed `MSC-Website-v5` and fast-forwarded `main` on GitHub.
- **Status:** completed
- **Next:** Feature work on `MSC-Website-v5`; use Quick DB when APIs 500 with stub DB.

## [2026-06-07 04:10] - Sentry Next.js 15 & React 19 Active Integration
- **Branch:** MSC-Website-v5
- **Changes:** Manually installed Sentry SDK. Set up server-side and edge-side error catching inside root `/instrumentation.ts` bootstrap utilizing Next 15 `onRequestError` interceptors. Added client-side config via `instrumentation-client.ts` (later session migrated off deprecated `sentry.client.config.ts`) and customized Sentry plugin inside `next.config.mjs` with safeties for missing tokens. Built interactive client-side and server-side testing diagnostics inside `/test/sentry-crash` playground and `app/api/dev/sentry-test` route, fully verified real-time logging and immediate email dispatch.
- **Status:** completed
- **Next:** Proceed with feature development on `MSC-Website-v5` or closeout the session.

## [2026-06-07 03:40] - Jina Reader & Tool Chest Integration
- **Branch:** MSC-Website-v5
- **Changes:** Created a canonical `.cursor/docs/TOOL-CHEST.md` outlining the integration of Jina Reader, Resend, Stripe, and Vertex AI/LiteLLM. Upgraded the `GitHub-Ops` skill pack to incorporate fast Markdown-fetching conventions using Jina's proxy. Updated root `README.md` to reference the new Tool Chest. Registered a secure restore point.
- **Status:** completed
- **Next:** Proceed with feature development on `MSC-Website-v5` or begin next session tasks.

## [2026-06-06 23:35] - Linting Optimization & Workflow Smoothing
- **Branch:** MSC-Website-v5
- **Changes:** Created `.eslintrc.json` to optimize linting rules for automated development. Downgraded `no-unused-vars` to warning and disabled `react/no-unescaped-entities` to prevent Husky pre-commit hooks from blocking valid commits for minor syntax issues. Added `npm run lint:fix` alias to `package.json`. Updated `AGENTS.md` with a new rule to run lint-fix before committing.
- **Status:** completed
- **Next:** Enjoy smoother Git workflows.

## [2026-06-06 23:30] - Automated Onboarding & Seeding System
- **Branch:** MSC-Website-v5
- **Changes:** Created `scripts/setup-dev.mjs` for one-command developer onboarding. Implemented a comprehensive seeding system via a Dev Lab API route (`app/api/dev/seed/route.ts`) and CLI manager (`scripts/msc-seed-manager.ts`). Content can now be exported to and imported from `seed-data/` JSON files. Added `npm run seed:production` and `npm run seed:all` commands. Integrated these into the `setup:dev` workflow. Updated `README.md` and `START-HERE.md` for new contributors.
- **Status:** completed
- **Next:** Invite collaborators to test the new onboarding flow.

## [2026-06-06 23:00] - Engine Hardening & Test Playground
- **Branch:** MSC-Website-v5
- **Changes:** Executed Phase 1 & 2 of Engine Consolidation: standardized scripts with `msc:` prefix, added `msc-doctor.mjs` health check, and implemented `msc-logger.mjs` for documentation automation. Created `AGENTS.md` and `specs/` structure for project governance. Created an isolated **Test Playground** at `app/test/[[...slug]]/page.tsx` with Stripe, Supabase, and Tesla design experiments. Fixed `msc:kill-dev-port` to default to port 3000 in `package.json`.
- **Status:** completed
- **Next:** Use `/test` to iterate on new UI components before production integration.

## [2026-06-06 20:57] - DesignMD Module Integrated
- **Branch:** MSC-Website-v5
- **Changes:** Installed `@designmdcc/cli` globally. Created `.cursor/DesignMD/` as the canonical store for design extractions. Extracted `linear.app` design system to `DESIGN-LINEAR.md`. Logged this as a new portable design-extraction skill.
- **Status:** completed
- **Next:** Use `dmd <url> --out .cursor/DesignMD/DESIGN-<NAME>.md` for future extractions.

## [2026-06-03 16:33] - Session closeout (ops + Vertex AI verify)
- **Branch:** MSC-Website-v5 @ `ac356d8`
- **Changes:** Cold-start ritual (docs load, lint pass). Quick backup to `G:\Cursor_Project_BackUpz\MyStudioChannel\msc-website-v1-s` (standard, 6/6 verify). Started Google API proxy (`msc:google-api:start` — LiteLLM :4000 + ngrok). Verified Vertex via `msc:litellm:verify` and live chat smoke (`vader-3-flash` → capital of Massachusetts). Stopped LiteLLM/ngrok on closeout. No app/runtime code edits.
- **Status:** completed
- **Next:** Feature work on `MSC-Website-v5` (creators, media workflows, or WP dual-sourcing); say **Start Project** to resume.

## [2026-06-02 13:30] - Production-Hardening Upgrades & Docs Sync
- **Branch:** MSC-Website-v5
- **Changes:** Completed all project audit upgrades. Created `scripts/db-optimize.mjs` for database optimization. Installed and configured Husky pre-commit linting hook. Developed `scripts/stream-live-logs.mjs` for remote SSH log tailing. Integrated version tracking and post-backup self-test checks into `scripts/msc-backup.mjs`. Created `scripts/clean-old-backups.ps1` retention manager. Created `scripts/audit-docs.mjs` documentation integrity scanner and resolved all broken internal markdown links. Updated README with v5.0.0 and FTPS deploy badges. Executed quick project backup.
- **Status:** completed
- **Next:** Focus on next major creators feature, media workflows, or WordPress content dual-sourcing integrations on active `MSC-Website-v5` branch.

## [2026-06-02 10:55] - Version bump to 5.0.0 and MSC-Website-v5 branch cut
- **Branch:** MSC-Website-v5
- **Changes:** Cut new development branch `MSC-Website-v5` from `MSC-Website-v4`. Bumped global project version to `5.0.0` in `package.json` and synchronized branch/version references across all project documentation files (`README.md`, `TRUTH.md`, `Checkpoint.md`, `project-log.md`, `Prompt-Cheat-Sheet.md`, `Restore-Points.md`, `MASTER-COMMANDS.md`, `HOSTINGER-DEPLOY.md`, `START-HERE.md`, `CHANGELOG.md`).
- **Status:** completed
- **Next:** Continue high-fidelity feature development under `MSC-Website-v5` branch.

## [2026-06-02 10:45] - Document sync + Master command index & WAL automation
- **Branch:** MSC-Website-v4
- **Changes:** Created `MASTER-COMMANDS.md` single source of truth command index. Logged 503 missing preload file error and SQLite WAL locking issue in `ISSUES-RESOLVED.md`. Automated remote WAL/SHM deletion and DB size check in `push-website-live.ps1`. Updated documentation mapping cross-references.
- **Status:** completed
- **Next:** Continue daily feature development and run `npm run push:website:live -- --ftps` for future updates.

## [2026-06-02 01:15] - Session closeout (docs hardening + env template consolidation)
- **Branch:** MSC-Website-v4
- **Changes:** Added deployment troubleshooting guide + decision tree, final audit checklist links, START-HERE deployment verification link, Hostinger verification notes, and consolidated `.env.production.template` into `.env.example`.
- **Status:** completed
- **Next:** Use `push website live` for next deploy and run HOSTINGER-DEPLOY final configuration audit checklist.

## [2026-06-02] - MCP-first push website live + deploy tooling
- **Branch:** MSC-Website-v4
- **Changes:** `msc:deploy:zip`, MCP-default `push-website-live.ps1`, FTPS fallback (`--ftps`), Hostinger restart reminder, `FTP_REMOTE_PATH=/nodejs` sync, debug projects-home probe (gated).
- **Docs:** Push-Website-Live.md, HOSTINGER-DEPLOY Path C, global/workflow rules, Jedi-List, START-HERE, Checkpoint, ReCall.
- **Next:** MCP deploy + hPanel restart; verify live API/globals

## [2026-06-01] - v4.0.0 live deploy + docs sync
- **Branch:** MSC-Website-v4 @ `87ec9de`+; **main** synced
- **Live:** mystudiochannel.com serving Next.js v4.0.0 (Hostinger MCP deploy, build `019e8569-74dc-70e6-bc10-4a121aac92ad`)
- **Status:** `/` and `/admin` 200; API globals 500 until hPanel env vars verified
- **Next:** Feature work on MSC-Website-v4

## [2026-06-01] - v4.0.0 development branch
- **Branch:** MSC-Website-v4 (new from MSC-Website-v3 @ `8a44d95`)
- **Changes:** Version bump to 4.0.0; operational docs updated for v4
- **Status:** Complete
- **Next:** Deploy to live (done same day)

## [2026-06-01] - Docs sync (Hostinger deploy + Path C)
- **Branch:** MSC-Website-v3 @ `c0bdaac`
- **Changes:** `HOSTINGER-DEPLOY.md` Path C daily updates; `DEPLOYMENT-FIXES.md` canonical dependency rule; cross-links in START-HERE, Jedi-List, Go-Live, TRUTH; ISSUES-RESOLVED + Restore-Points + ReCall synced.
- **Status:** Complete
- **Next:** Ongoing live updates via `pushit:live`; verify hPanel env vars

## [2026-06-01] - Hostinger first live deploy + deployment docs
- **Branch:** MSC-Website-v3 / main
- **Changes:** Successful zip deploy to mystudiochannel.com; moved `@tailwindcss/postcss`, `postcss`, `tw-animate-css` to `dependencies`; full HOSTINGER-DEPLOY rewrite; DEPLOYMENT-FIXES.md created.
- **Status:** Complete
- **Next:** Path C FTPS updates for day-to-day changes

## [2026-06-01] - Docs sync + main merge
- **Branch:** MSC-Website-v3 / main @ `57910cd`
- **Changes:** Version/branding consolidation docs; `main` fast-forwarded from `MSC-Website-v3`; Jedi-List, ReCall, Checkpoint, Go-Live updated for `package.json`-only versioning.
- **Status:** Complete
- **Next:** Deploy when ready; continue feature work on `MSC-Website-v3`

## [2026-06-01] - Version consolidation
- **Branch:** MSC-Website-v3
- **Changes:** `lib/msc-app-version.ts` from `package.json`; removed `msc-admin-version.ts`; footer/admin MyStudioChannel labels; hero slide 5 JPG; MCP test script.
- **Status:** Complete
- **Next:** Merge to main (done same day)

## [2026-05-30] - Version 3.0.0 Bump
- **Branch:** MSC-Website-v3
- **Changes:** Deep audit consolidation completed; branch upgraded to v3; version bumped to 3.0.0.
- **Status:** Complete
- **Next:** Continue development on v3

## [2026-05-30] - Initial Setup
- **Branch:** MSC-Website-v3
- **Changes:** Initial workflow system setup
- **Status:** Complete
- **Next:** Begin development

## [6/6/2026, 10:18:08 PM] - Session Summary
- **Branch:** y
- **Changes:** y
- **Status:** completed
