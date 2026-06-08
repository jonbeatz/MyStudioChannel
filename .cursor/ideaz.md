# IDEAZ — Portable Studio Kit & `custom-scriptz` Roadmap

**Saved:** 2026-06-07  
**Status:** Backlog — revisit when starting a new project or extracting modules from MyStudioChannel.

---

## Goal

Package the reusable 20% of MyStudioChannel (dev runtime, docs governance, backup, doctor, session rituals, MCP sync) into installable `custom-scriptz` modules + one **project-bootstrap** meta-installer — without dragging Payload/Hostinger specifics into every repo.

**Pattern to copy:** `backup-system` — `module.manifest.json` + `install.ps1` + `CURSOR.md` + `package-scripts.json` + optional `global.mdc.fragment` + `_lib/Msc-ModuleInstall.ps1`.

---

## Current inventory

### Portable infra (already in `custom-scriptz`)

| Module | Purpose |
|--------|---------|
| **backup-system** | Standard/Full robocopy, BackUp-Notez, quick/interactive ritual |
| **google-api-proxy** | LiteLLM + Vertex + ngrok (Jon-specific, optional) |
| **_lib/Msc-ModuleInstall.ps1** | Shared installer kernel — keep as contract |

### Feature packs (Payload/marketing — not for every project)

| Module | Notes |
|--------|-------|
| stay-in-the-loop | Leads/newsletter |
| book-consultation | Bookings |
| schedule-a-call | Call requests |

→ Group later as optional **`payload-marketing-bundle`**.

### Portable but still in repo root (not modules yet)

- `scripts/msc-kill-dev-port.mjs`, `clean-next-cache.mjs`, `verify-next-safe.ps1`, `verify-local.ps1`
- `scripts/msc-doctor.mjs`, `msc-audit-docs.mjs`, `msc-sync-doc-commands.mjs`
- `scripts/msc-sync-mcp-env.mjs`, `clean-zips.ps1`
- `.cursor/hooks/*`
- `.cursor/prompts/Start-Project.md`, `End-Project.md`, `Update-Docs.md`
- `.cursor/rules/workflow.mdc`, `global.mdc`, `local-runtime-recovery.mdc`, `interactive-workflows.mdc`
- `.cursor/skills/Workflow-Portable/*`

### Gaps to fix

- `README.md` references **`Create-New-Module.md`** — prompt does not exist yet
- **`Prompt-Module.md`** only lists 2 modules; 6+ folders exist
- No **`custom-scriptz/registry.json`** central module index
- **`msc-audit-docs.mjs`** hardcodes branch (`MSC-Website-v6`) — should read git or env

---

## Modules to add (prioritized)

### Tier 1 — every Next/Node project

#### 1. `dev-runtime-core`

- Kill port, clean `.next`, `verify:next:safe`, `verify:local`, `repair:dev` aliases
- `local-runtime-recovery.mdc.fragment`
- Optional Cursor `hooks.json` (stop hook + guard-clean-while-dev)

#### 2. `docs-governance`

- Parameterized `msc-audit-docs.mjs` (branch/version from manifest or env)
- `msc-sync-doc-commands.mjs`
- Templates: `TRUTH.template.md`, `START-HERE.template.md`, `MASTER-COMMANDS.template.md`, `Restore-Points.template.md`
- Prompts: Start-Project, End-Project, Update-Docs (`{{PROJECT_NAME}}` placeholders)

#### 3. `doctor`

- Configurable via manifest: `requiredEnvKeys[]`, `ports[]`, `optionalServices[]`
- Generic mode: Node, `.env.local`, git, ports
- MSC/Payload mode: add Payload/SQLite checks

#### 4. `session-closeout`

- `msc:session:stop` (configurable ports: 3000, 4000, 4040)
- End-Project prompt + Session-Closeout skill wiring

#### 5. `mcp-env-sync`

- Portable `msc-sync-mcp-env.mjs` with manifest listing global vs project MCP servers

### Tier 2 — when stack matches

#### 6. `deploy-ftps-node`

- SSH preflight lib, stop-node patterns (not full mystudiochannel paths)
- Pairs with **Workflow-Portable/Deploy-FTP-Node** skill

#### 7. `deploy-zips-retention`

- `clean-zips.ps1` + `backup:clean-zips` pattern

#### 8. `github-ops-lite`

- `msc:test:github-api`, backup:github-repos hooks
- Pairs with **GitHub-Ops** skill

### Tier 3 — optional

- **google-api-proxy** — exists
- **payload-marketing-bundle** — merge stay-in-the-loop + book-consultation + schedule-a-call

---

## Meta-module: `project-bootstrap`

```
.cursor/custom-scriptz/project-bootstrap/
  module.manifest.json
  install.ps1
  CURSOR.md
  templates/
    TRUTH.md
    START-HERE.md
    Checkpoint.md
    AGENTS.md
    .cursor/rules/*.mdc.fragments
  scaffold.mjs    # {{PROJECT_NAME}}, {{BACKUP_ROOT}}, {{DOMAIN}}
```

**Trigger:** `bootstrap new project` / `install studio kit`

**Flow:**

1. Ask: project name, backup root, primary domain, hosting (Hostinger / Vercel / other)
2. Chain Tier-1 module installs
3. `scaffold.mjs` writes templated docs + merges rule fragments
4. Copy `Workflow-Portable/` skills if missing
5. Smoke: `npm run doctor` + `npm run msc:docs:audit`

---

## Lighter alternative: `Cursor-Studio-Kit` on G: or GitHub template

```
Cursor-Studio-Kit/
  custom-scriptz/          # Tier 1 modules
  skills/Workflow-Portable/
  skills/Project-Bootstrap/   # NEW orchestrator SKILL.md
  prompts/
    Start-Project.md
    End-Project.md
    Update-Docs.md
    Create-New-Module.md      # create this
  rules-starter/
    workflow.mdc
    global.mdc
    interactive-workflows.mdc
    local-runtime-recovery.mdc
  docs-starter/
    TRUTH.template.md
    START-HERE.template.md
```

**New project ritual:**

```powershell
robocopy G:\Cursor_Studio_Kit\.cursor .cursor /E
.\.cursor\custom-scriptz\project-bootstrap\install.ps1 -ProjectName "MyNewApp"
.\.cursor\custom-scriptz\dev-runtime-core\install.ps1
.\.cursor\custom-scriptz\backup-system\install.ps1
.\.cursor\custom-scriptz\docs-governance\install.ps1
# Customize TRUTH + hosting doc
npm run doctor
```

---

## Do NOT portableize (keep project-specific)

| Item | Why |
|------|-----|
| Full Hostinger SSH scripts (`sync-app`, `sync-db`) | Two-folder map, Payload sqlite |
| Payload UI patches | Locked to `@payloadcms/ui@3.81` |
| book-consultation / Leads collections | Product features |
| TRUTH deploy table as-is | mystudiochannel.com URLs |
| Hardcoded audit branch | Manifest/env first |

---

## Implementation priority

| # | Action | Effort |
|---|--------|--------|
| 1 | `dev-runtime-core` module | ~2–3 h |
| 2 | `docs-governance` + templates | ~3–4 h |
| 3 | `project-bootstrap` meta-installer | ~4–6 h |
| 4 | `doctor` (configurable manifest) | ~2 h |
| 5 | `mcp-env-sync` module | ~1–2 h |
| 6 | `deploy-ftps-node` (pattern only) | ~4+ h |
| 7 | `Create-New-Module.md` + `registry.json` | ~1 h |

---

## Relationship to existing skills

- **Workflow-Portable** = brain (when to run what)
- **custom-scriptz** = hands (install scripts + merges)
- **Nova / NovaMira-Design / Premium-UI** = product UI (per brand)
- **Obsidian (`I:\Vader_Vault`)** = think layer; repo `.cursor/docs` = ship layer

---

*Revisit when cold-starting a new repo or after next major MSC deploy.*
