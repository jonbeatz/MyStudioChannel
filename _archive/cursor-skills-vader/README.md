# Skills Index

This directory houses the foundational competence profiles and execution runbooks for the AI agent.

**Primary directory compass:** [Code-Jedi.md](../docs/Code-Jedi.md) — maps objectives → `core/` / `scripts/` / `ui/` modules, lists every native `package.json` script, and defines the documentation SSoT reading order. Read it before deep-diving into individual skills.

Use the map below for task-specific technical rules after Code-Jedi routing.

**Rules index:** [.cursor/rules/README.md](../rules/README.md) · **Zero-leak:** [env-ingestion-compliance.mdc](../rules/env-ingestion-compliance.mdc) (always on).

## 🧭 Competency Routing Map

### 1. 🌐 [WordPress & Divi Engineering](./wordpress-divi-engineering.md)
- **When to invoke:** Building plugins, writing theme functions, injecting custom actions/filters, managing asset enqueues, preventing Theme Builder bloat, or structuring `WP_Query` loops.
- **Core Standard:** `msc_` functions, `msc-` CSS prefixes, strict `defined('ABSPATH')` security blocks.

### 2. ⚡ [Node.js Runtime Mastery](./node-runtime-mastery.md) — **Node ID: runtime-gate**
- **When to invoke:** Managing environment variables, configuring `package.json` scripts, resolving server process deadlocks, running build gates, or executing local smoke-testing.
- **Core Standard:** **Local Script Gate Sequence** (strict order): `msc-kill-dev-port.mjs` → `msc-local-http-smoke.mjs` on port **3000** (`MSC_DEV_PORT`) for web; proxy ports **4000**/**8000** per Node 6.

### 3. 💾 [Local Data & Infrastructure Operations](./local-data-operations.md)
- **When to invoke:** Interfacing with local databases (SQLite/MySQL), executing backup routines, repairing table schemas, auditing asset file trees, or verifying media directories.
- **Core Standard:** Backup-first pipelines, WAL/SHM engine safety, project-agnostic paths.

### 4. 📚 [Documentation & Governance Operations](./docs-ops-governance.md)
- **When to invoke:** Structuring project logs, generating execution plans, updating task statuses, documenting code modifications, or formatting incident tracking data.
- **Core Standard:** Rule prioritization, `package.json` configuration alignment, standardized incident schemas.

### 5. 🏁 [Session Handoff & Project Closeout](./session-handoff-closeout.md)
- **When to invoke:** Creating repository snapshots, wrapping up coding sessions, generating restore points, cutting branches, or prepping files for staging/deployment.
- **Core Standard:** Mandatory explicit operator consent check gates, system state archiving templates.

### 6. 🌐 [Local AI Proxy Engine & Infrastructure](../docs/local-ai-proxy-setup.md)
- **When to invoke:** Setting up or debugging local model APIs, handling port collisions on proxy ranges (ports 4000/8000), configuring Ngrok tunnels, or referencing Google Cloud Vertex AI integration schema contracts.
- **Core Standard:** Strict local port isolation via `msc-kill-dev-port.mjs`, gitignored credential policies, and proxy translation setups.

### 7. 🐙 [GitHub Automation & Release Governance](../docs/github-automation-rules.md)
- **When to invoke:** Prepping commits, cutting semantic version tags (e.g., `v1.0.4`), managing feature/dev branches, preparing Pull Requests, or validating structural pipeline expectations for GitHub Actions.
- **Core Standard:** Pre-tag **runtime-gate** sequence on port **3000**, then build/verify; explicit operator confirmation before commit/push/tag.

### 8. 🛡️ [Studio Dark Shield](./studio-dark-shield.md)
- **When to invoke:** Shield → Satellite CSS, hybrid consumer paths (Shield-only vs Tailwind/shadcn), `msc-shield-load.css` import order, or choosing between satellite files and Tailwind for a surface.
- **Core Standard:** Tokens only in `ui/msc-shield.css`; Path A for dashboards/WordPress; Path B for Next/shadcn with [tailwind-shadcn-bridge.mdc](../rules/tailwind-shadcn-bridge.mdc). MCP: `shadcn`, `context7`.

## 📂 Docs cross-reference (`.cursor/docs/`)

| Doc | Path |
|-----|------|
| **Code-Jedi (master compass)** | [Code-Jedi.md](../docs/Code-Jedi.md) |
| Local AI proxy | [local-ai-proxy-setup.md](../docs/local-ai-proxy-setup.md) |
| GitHub automation | [github-automation-rules.md](../docs/github-automation-rules.md) |
| Spaceship deploy | [spaceship-node-deployment.md](../docs/spaceship-node-deployment.md) |
| Architecture map | [system-architecture.md](../docs/system-architecture.md) |
| MCP setup | [mcp-setup.md](../docs/mcp-setup.md) · config [mcp.json](../mcp.json) |
| Media strategies | [media-strategy-specs.md](../docs/media-strategy-specs.md) |
| Ecosystem options matrix | [ecosystem-options-matrix.md](../docs/ecosystem-options-matrix.md) |
| Discovered logic map | [discovered-logic-map.md](../docs/discovered-logic-map.md) |
| SQLite repair manifest | [sqlite-repair-manifest.md](../docs/sqlite-repair-manifest.md) |
| Env ingestion (zero-leak) | [env-ingestion-compliance.mdc](../rules/env-ingestion-compliance.mdc) |
| Tailwind / shadcn bridge | [tailwind-shadcn-bridge.mdc](../rules/tailwind-shadcn-bridge.mdc) |
| Design system (tokens first) | [design-system-rules.mdc](../rules/design-system-rules.mdc) |
| Studio Dark Shield skill | [studio-dark-shield.md](./studio-dark-shield.md) |
| Constitution | [TRUTH.md](../../TRUTH.md) |
| Repair protocols | [REPAIR_PROTOCOLS.md](../docs/REPAIR_PROTOCOLS.md) |
| Consumer bootstrap | [consumer-bootstrap.md](../docs/consumer-bootstrap.md) |
| npm script appendix (mirror) | [config/npm-scripts-appendix.json](../../config/npm-scripts-appendix.json) |
| Project log | [project-log.md](../docs/project-log.md) |
| Incident log | [incident-log.md](../docs/incident-log.md) |

### Prompt blueprints (agent rituals)

| Prompt | Path | When |
|--------|------|------|
| **Start Project** (alias) | [`.cursor/prompts/Start-Project.md`](../prompts/Start-Project.md) | Routes → `task-planner.md` |
| Feature plan template | [`.cursor/prompts/TEMPLATE-PLAN.md`](../prompts/TEMPLATE-PLAN.md) | **New features** — populate plan; operator approval before code |
| Task planner gate | [`.cursor/prompts/task-planner.md`](../prompts/task-planner.md) | **Start** of implementation — before any code edits |
| **End Project** / Session closeout | [`.cursor/prompts/End-Project.md`](../prompts/End-Project.md) | **End** of session — gates, log check-in, git audit, Handoff Block |
| Incident response | [`.cursor/prompts/incident-response.md`](../prompts/incident-response.md) | Runtime failure, DB lock, port/deploy recovery |
| Refactor protocol | [`.cursor/prompts/refactor-protocol.md`](../prompts/refactor-protocol.md) | Structural refactors after task-planner approval |
