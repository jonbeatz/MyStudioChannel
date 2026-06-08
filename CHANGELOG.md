# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- (none)

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
