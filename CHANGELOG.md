# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-05-30

### Added
- **Master Source of Truth:** Created `TRUTH.md` at the project root as the definitive reference for project identity, core commands, and architectural blueprints.
- **Hostinger hPanel Operator Rule:** Created `.cursor/rules/jon-operator-hpanel.mdc` with dedicated hPanel bookmarks and command locality guidance.

### Changed
- **Version Bump:** Upgraded project to `v3.0.0` and established `MSC-Website-v3` as the primary working branch.
- **Deep Audit & Consolidation:** 
  - Merged `Custom-Prompts.md` into `Prompt-Cheat-Sheet.md` for a unified session command reference.
  - Archived legacy `Vader-Engine` skill files and purged all old project naming/hosting remnants (`msc-new`, `Spaceship`, `cPanel`).
  - Standardized all documentation on `MyStudioChannel` and `Hostinger` hPanel terminology.
- **Workflow Standardization:** Audited and refined prompt runners and coordination rules (`workflow.mdc`, `docs-sync.mdc`) for high-fidelity agent collaboration.

### Fixed
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

[3.0.0]: https://github.com/jonbeatz/MyStudioChannel/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/jonbeatz/MyStudioChannel/compare/v1.0.24...v2.0.0
