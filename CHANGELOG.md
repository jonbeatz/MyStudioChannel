# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [8.0.0] - 2026-06-11

### Added
- **`MSC-Website-v8`** branch — active development line; **`MSC-Website-v7`** frozen @ `b4ab8ae` as restore backup
- **GitHub tag `v8.0.0`** on **`MSC-Website-v8`**

### Changed
- **Version bump** to **8.0.0** in `package.json`; UI labels via `lib/msc-app-version.ts` (footer + admin sidebar)
- **CI** runs on **`MSC-Website-v8`**, **`MSC-Website-v7`**, and **`main`**
- Ops docs synced to v8.0.0 (TRUTH, README, HOSTINGER-DEPLOY, Jedi-List, Checkpoint, ReCall)

## [Unreleased]

### Added
- **Payload CMS Types Sync & Validation Pipeline (`payload-types-sync.ps1`):** Robust PowerShell controller supporting `-Watch`, `-Validate`, and `-PreCommit` actions. Integrated with NextJS build gates (`npm run build`) and `.husky/pre-commit` to guarantee database schema types are always validated and auto-staged on change.
- **VRAM Idle Manager & Auto-Unloader (`vram-idle-manager.ps1`):** Lightweight background monitoring daemon tracking LM Studio local LLM idle durations. Auto-warns and unloads loaded GGUF models after 15 minutes of inactivity to reclaim system memory. Features manual overrides (`keep-model-on`, `keep-model-off`) and native PowerShell Job integration (`vram-daemon-start`, `vram-daemon-stop`).
- **Seamless Local Build & Auto-Dev Pipeline (`npm run build:dev`):** Spawns a production compilation gate, validates schemas, purges active ports, and starts NextJS dev in a detached background job so local click-links are instantly active on port 3000.
- **J.A.R.V.I.S. Welcome Greeting Launcher:** Designed `scripts/start-hermes-api.ps1` (with `package.json` mapping `msc:google-api:start-session`) to poll LiteLLM port 4000 and play a vocal welcome after tunnel stabilization. Refined the `speak` classifier in your PowerShell profile to avoid false-positive AI queries.
- **Mem0 Long-Term Memory Layer:** Native integration with local Qdrant vector store and LM Studio model embeddings. Added PowerShell shortcuts `remember` and `recall` that auto-load Qwen 4B reasoning models when empty.
- **Cursor Workspace MCP Server Expansion:** Registered sqlite, git, and docker MCP servers inside `cline_mcp_settings.json` to expand local workspace capabilities.
- **Cinematic Bento-Grid Explorer (`DemosReimagined`)** — Modern, high-end, responsive `grid-cols-1 md:grid-cols-2 lg:grid-cols-3` layout for showcasing creator platforms. Includes staggered load-in animations via `motion/react`, responsive image aspect-video framing, and top-left category pill badges.
- **Spring-Loaded Glass Modal (`DemosModal`)** — Premium overlay modal featuring backdrop blurring (`backdrop-blur-lg`), spring mechanics (`type: "spring", damping: 30, stiffness: 250`), keyboard escape-key closes, backdrop click dismissal, and touch device friendly fallbacks.
- **Option-Based Carousel Pagination:** Added center-aligned pagination footer (e.g. "1-6 of 8") with sliding page transitions (`AnimatePresence`) that handles item sets greater than 6 and automatically hides when unnecessary.
- **Dynamic CMS Project Hydration:** Permanently seeded 3 new test/mock projects directly into the SQLite `projects_home_project_items` database and registered new physical files (`test-project-alpha-alt.jpg`, `beta-studio-alt.jpg`, `gamma-network-alt.jpg`) inside the `media` collection.
- **Scroll Anchor Migration:** Configured `DemosReimagined` to support the canonical scroll target `#msc-demos` with accurate sticky header offset margins (`scroll-mt-30`).
- **Hermes Agent Windows 11 Integration:** Installed global `hermes-agent` CLI, performed configuration tuning with a custom named `vertex-proxy` routing model requests directly to Google Cloud Vertex AI via the local active LiteLLM proxy on port `4000`, and created `HERMES.md` in the project root to load the architecture and `TRUTH.md` constitution context into all future agent sessions.
- **Automated Performance Test-Suite (`test-website.ps1`):** Created a PowerShell test runner that automates multi-stage build, link integrity, and layout performance audits using parallel Hermes Agent execution.
- **`scripts/jarvis-speak.ps1` + `npm run msc:jarvis:speak`:** Profile-independent Edge TTS for Start Project Step 7 (non-blocking).

### Changed
- **Start Project ritual (2026-06-13):** Polished summary cards with LiteLLM/Vertex/ngrok status; voice greeting moved to Step 7 only (`Start-Process -WindowStyle Hidden`); launcher uses Windows Terminal (`wt`) without TTS.
- **J.A.R.V.I.S. greeting copy:** *"Welcome back Jon, I am JARVIS your personal assistant, all systems are fully functional, let's begin."*
- **Hiding Legacy Demos:** Safely commented out and preserved the old `DemosSection` swapper layout in `app/(site)/page.tsx` for easy rollback if needed.
- **Performance Optimization:** Migrated the homepage (`app/(site)/page.tsx`) and CMS projects fetch layer (`lib/cms/projects.ts`) from raw `noStore()` (force-dynamic) SSR to Incremental Static Regeneration (ISR) with a 3600-second revalidation window (`export const revalidate = 3600`), drastically reducing page latency and database load.
- **Dependency Upgrades:** Upgraded Payload CMS core packages to `3.85.1`, React to `19.2.7`, and Tailwind to `4.3.0`, completely cleaning up and deleting outdated package-level patches (`@payloadcms+drizzle`, `@payloadcms+next`, `@payloadcms+ui`).

## [7.0.0] - 2026-06-08

### Added
- **GitHub release/tag `v7.0.0`** on **`MSC-Website-v7`**
- **`MSC-Website-v7` branch cut** — active development line from frozen `MSC-Website-v6` @ `c9e260e`; full backup `msc-website-v2-f`
- **`scripts/msc-hostinger-mcp.mjs`** — scoped Hostinger MCP bins + invalid tool-name filter for Cursor
- **`.cursor/ideaz.md`** — portable `custom-scriptz` / project-bootstrap roadmap (backlog)
- **`.cursor/review.md`** — comprehensive audit follow-up queue and tomorrow work list
- **Comprehensive audit (Phases 2–4)** — Payload UI patch regenerate; `/test` middleware fix; `sync-app --skip-db`; SSH preflight; bulk `msc:*` doc sync; rules dedup; Restore-Points trim; Sentry pin; MCP sync for 21st/browserbase
- **Header nav `submenuSource`** — per-row **Submenu source**: Manual | From Pages collection
- **`showInHeaderNav`** on Pages collection — opt pages in/out of the **Legal** dropdown
- **SQLite migrations:** `msc:migrate:sqlite:header-nav-submenu-source`, `msc:migrate:sqlite:pages-show-in-header-nav`
- **`msc:hostinger:sync-app`**, **`msc:hostinger:npm-install`**, **`msc:hostinger:recover`** SSH scripts

### Changed
- **Version bump** to **7.0.0** in `package.json`; UI labels via `lib/msc-app-version.ts` (footer + admin sidebar)
- **MCP reload docs** — **Settings → MCP** (cursor-mcp-refresh optional/archived)
- **`msc-sync-mcp-env.mjs`** — copies Hostinger launcher to `~/.cursor/scripts/`
- **Legal** nav label (was **Pages**) for the collection-driven dropdown
- **`pushit:live`** — step **5b** runs **`msc:hostinger:sync-app`**; auto **`npm install --legacy-peer-deps --ignore-scripts`**
- Deploy docs — Hostinger folder map, MCP build-failed notes, prevention checklist

### Fixed
- **Hostinger MCP** — Windows spawn EINVAL; tool naming warnings (`Node.js` in tool names)
- **MSC1** excluded from header nav via `showInHeaderNav` + runtime slug filter
- **Live 503** after deploy — `node_modules` missing Next webpack; **`msc:hostinger:npm-install`**
- **Wrong live code/footer** when FTPS landed in **`public_html/nodejs/`** only — **`msc:hostinger:sync-app`**
- **pushit:live:fast** — zip path (staging root, not `zips/`)
- Live **4 KB stub DB** after MCP/Git deploy — FTPS + `sync-db` restores ~500 KB DB

## [6.0.0] - 2026-06-07

### Added
- **GitHub releases/tags** — `v4.0.0`, `v5.0.0`, `v6.0.0` published on [releases](https://github.com/jonbeatz/MyStudioChannel/releases) (`v6.0.0` superseded by `v7.0.0`)
- **`MSC-Website-v6` branch cut** — new active development line from `MSC-Website-v5` @ `92918b6`
- **`msc:push:db:live`** — quick (~1–2 min) live database deploy path
- **`msc:hostinger:stop-node`** and **`msc:hostinger:sync-db`** — SSH stop Node and copy FTPS DB into live app root
- **`msc:session:stop`** — end-session cleanup (dev :3000 + LiteLLM/ngrok)
- **`app/global-error.tsx`** and **`instrumentation-client.ts`** — Sentry client boundary (replaces deprecated `sentry.client.config.ts`)

### Changed
- **Version bump** to **6.0.0** in `package.json`; UI labels via `lib/msc-app-version.ts`
- **Deploy workflow:** say **push it live** → agent asks mode (Quick DB · Full FTPS · MCP code-only); **MCP/Git ≠ DB deploy** documented across ops docs
- **`pushit:live`** — auto-runs **`msc:hostinger:sync-db`** after `payload.sqlite` FTPS upload (7-step pipeline)
- **Sentry:** correct org slug `mystudiochannel`; env-driven org/project in `next.config.mjs`
- Updated operational docs for **`MSC-Website-v6`** and **v6.0.0**

### Fixed
- Live **4 KB stub DB** after MCP/Git deploy — FTPS + `sync-db` restores ~500 KB DB to Node app root; `/api/globals/*` **200** after fix

## [5.0.0] - 2026-06-02

### Added
- **`MSC-Website-v5` branch cut** — production hardening line from `MSC-Website-v4`
- **`msc:db:optimize`**, Husky pre-commit lint, **`msc:logs:live`**, backup retention **`msc:backup:clean`**
- **`MASTER-COMMANDS.md`** — single source of truth for npm scripts

### Changed
- Version bump to **5.0.0**; **`MSC-Website-v4`** frozen

## [4.0.0] - 2026-06-01

### Added
- **`MSC-Website-v4` branch cut** — Hostinger Node.js production deploy path
- Unified **`.env.example`** template; deployment troubleshooting docs

### Changed
- Version bump to **4.0.0**; live on Hostinger

## [3.0.0] - 2026-06-01

### Changed
- Deep audit and consolidation on **`MSC-Website-v3`**

## [2.0.0] - 2026-05-29

### Changed
- Hostinger migration milestone

## [1.0.0] - 2026-05-29

### Added
- Initial MyStudioChannel Payload + Next.js release
