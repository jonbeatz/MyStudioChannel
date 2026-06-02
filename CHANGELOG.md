# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [5.0.0] - 2026-06-02

### Added
- **MSC-Website-v5 branch cut**: Switched to a new development branch line `MSC-Website-v5` for continuous feature development.
- **Master Command Reference SSoT**: Created `MASTER-COMMANDS.md` as the unified command card for dev, deploy, db, and diagnostics.
- **Automated WAL Cleanup**: Integrated automated SQLite WAL/SHM file cleanup and remote file size verification into `push-website-live.ps1` via FTPS, solving the 500/504 replay locks.
- **503 Preload Troubleshooting**: Added resolution for silent Hostinger Node.js 503 crashes caused by missing `.builds` config preload files.

### Changed
- **Version bump**: Upgraded global semver to `5.0.0` in `package.json` with dynamic import by `lib/msc-app-version.ts` for headers/footers.
- Updated all operational documentation files (`README.md`, `TRUTH.md`, `Checkpoint.md`, `project-log.md`, `Prompt-Cheat-Sheet.md`, `Restore-Points.md`, `Development.md`, `Jedi-List.md`, `Go-Live-Checklist.md`, `GitHub-Cheat-Sheet.md`, `DEPLOYMENT-FIXES.md`) to reflect `v5.0.0` and branch `MSC-Website-v5`.

## [4.0.0] - 2026-06-01

### Added
- **Live production deploy** to [https://mystudiochannel.com](https://mystudiochannel.com) via Hostinger MCP (`MyStudioChannel-v4-deploy.zip`).

### Changed
- **Version bump** to `4.0.0` on **`MSC-Website-v4`**; footer and admin show **MyStudioChannel v4.0.0** live.
- **Branch model:** `MSC-Website-v4` active dev; **`main`** synced with v4; **`MSC-Website-v3`** frozen at v3.0.0.
- Operational docs updated for v4 workflow and live deploy status.

### Fixed
- Live site serving Next.js + Payload (WordPress docroot replaced by Node.js app).

### Known
- `/api/globals/projects-home` may return **500** until all hPanel environment variables are set and Node is restarted.

## [3.0.0] - 2026-05-30 (live deploy 2026-06-01 on `main`)

### Added
- **`scripts/test-mcps.mjs`** — MCP connectivity health checks.
- Hero slide 5 asset: **`public/media/IWWI-Indie-WorldWide-Inc-Hero-6.jpg`**.
- **Hostinger deployment docs:** `DEPLOYMENT-FIXES.md`; full **`HOSTINGER-DEPLOY.md`** (Path A zip, Path B FTPS, Path C daily updates); canonical production dependency rule.
- **Master Source of Truth:** Created `TRUTH.md` at the project root as the definitive reference for project identity, core commands, and architectural blueprints.
- **Hostinger hPanel Operator Rule:** Created `.cursor/rules/jon-operator-hpanel.mdc` with dedicated hPanel bookmarks and command locality guidance.

### Changed
- **Single release version:** `lib/msc-app-version.ts` reads root **`package.json`** only; removed **`lib/msc-admin-version.ts`**.
- **User-facing branding:** Footer and Payload admin sidebar show **MyStudioChannel** + **`v3.0.0`** (no separate admin semver).
- **`pushitup:admin-ui`** file list: `lib/msc-app-version.ts`, `components/msc-payload-nav-logout.tsx`.
- **Production dependencies:** `@tailwindcss/postcss`, `postcss`, `tw-animate-css` moved from `devDependencies` for Hostinger builds.
- **`main`** fast-forwarded from **`MSC-Website-v3`** (2026-06-01, tip **`8a44d95`**).
- **Version Bump:** Upgraded project to `v3.0.0` and established `MSC-Website-v3` as the primary working branch.
- **Deep Audit & Consolidation:** 
  - Merged `Custom-Prompts.md` into `Prompt-Cheat-Sheet.md` for a unified session command reference.
  - Archived legacy `Vader-Engine` skill files and purged all old project naming/hosting remnants (`msc-new`, `Spaceship`, `cPanel`).
  - Standardized all documentation on `MyStudioChannel` and `Hostinger` hPanel terminology.
- **Workflow Standardization:** Audited and refined prompt runners and coordination rules (`workflow.mdc`, `docs-sync.mdc`) for high-fidelity agent collaboration.

### Fixed
- **Hostinger build failures** from missing PostCSS / CSS packages when host runs `npm install --production`.
- **Local Identity Bleed:** Resolved 10+ instances of inconsistent project naming and outdated hosting paths across the documentation suite.

## [2.0.0] - 2026-05-30

### Added
- **New README.md Branding:** Complete overhaul with Vader-Engine structure, hero image, and visual asset gallery.
- **Visual Assets:** Integrated platform screenshots (`MSC-Pages-v*`) for better GitHub representation.
- **Contributors Section:** Added Jon Beatz as the primary creator and developer.
- **Version Tracking:** Shifted project baseline to `v2.0.0` for the production-ready milestone.

### Changed
- **Hosting Migration:** Fully transitioned from Spaceship (cPanel) to Hostinger (hPanel).
- **Deployment Engine:** Updated `PushItUP` scripts and documentation for Hostinger FTPS.
- **Documentation:** Consolidated all human runbooks and agent prompts into a Hostinger-centric model.
- **Footer:** Refined footer branding to "Powered by the MSC Media Engine".

### Fixed
- **Git Author Info:** Corrected commit author metadata to `JonBeatz <jonbeatz@gmail.com>`.

---

[4.0.0]: https://github.com/jonbeatz/MyStudioChannel/compare/v3.0.0...v4.0.0
[3.0.0]: https://github.com/jonbeatz/MyStudioChannel/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/jonbeatz/MyStudioChannel/compare/v1.0.24...v2.0.0
