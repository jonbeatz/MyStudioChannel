---
name: docs-ops-governance
description: >-
  Documentation and operations authority — canonical doc order, package.json
  sync, anti-duplication, and incident capture. Use when editing docs or workflow
  guidance.
---

# Docs Ops Governance (Universal)



## Authority stack

1. Constitution / TRUTH doc (non-negotiable principles)
2. Root `.cursorrules` and `.cursor/rules/*`
3. Docs architecture map + START-HERE entry
4. **`package.json` scripts** (executable truth only)

## Required behavior

- Keep edits focused on **canonical docs first**; avoid duplicating the same instructions in five files—use pointers.
- When commands or paths change, update docs in the **same session**.
- **Version sync:** root `package.json` `"version"` is the only release-number authority. On bump or doc sweep, align all **current-version** headers (README, TRUTH, DOCS, ARCHITECTURE, TROUBLESHOOTING, CONTRIBUTING, START-HERE, HOW-TO, Code-Jedi, system-architecture, `.cursor/rules/README.md`, `.devcontainer/devcontainer.json`, `project-log.md` `Current Version:`) in the **same commit**. Leave prior CHANGELOG sections and archived `RELEASE-v2.x.x.md` files as historical record.
- Archive redundant docs instead of deleting useful history.
- Capture incidents as: **symptom → root cause → shortest verified recovery path**.

## Minimal update set (when relevant)

- Startup / architecture map (`START-HERE.md`, `system-architecture.md`)
- UI / MCP changes: `Code-Jedi.md`, `consumer-bootstrap.md` §6, `mcp-setup.md`, `studio-dark-shield.md`, `.cursor/rules/README.md`
- Session snapshots
- Development roadmap
- Agent runbook
- Deploy / recovery guide (project-specific name)
- Restore points (milestones only)

## Planning artefacts

- Canonical tracked plans: `.cursor/plans/`
- Profile-draft plans may exist outside the repo—consolidate into `.cursor/plans/` before session closeout when they belong in Git.

## Production hosting & environment mapping

- **Single master blueprint:** `.cursor/docs/spaceship-node-deployment.md` — Spaceship/cPanel Node + FTP directory architecture, Passenger startup, pre-upload cleanup, deploy SOP, and live recovery playbooks.
- **Environment contract:** repo root **`.env.example`** — grouped variables for app origin, database, secrets, local script gates, and `SPACESHIP_*` path hooks.
- When deploy docs or env keys change, update **both** files in the same session and sync any project `package.json` deploy scripts separately.

## Local AI proxy & GitHub automation

- **LiteLLM + ngrok + Vertex:** `.cursor/docs/local-ai-proxy-setup.md` — OpenAI-compatible proxy port isolation (default **4000**), Cursor `/v1` base URL rules, service account handling, ngrok tunnel lifecycle, and `msc-kill-dev-port` pre-flight. Agents must not point Cursor at stale ngrok URLs or commit `gcp_key.json` / `master_key`.
- **GitHub branching & releases:** `.cursor/docs/github-automation-rules.md` — `main`/`dev`/`feature/*` governance, semver tags, `gh release` packaging pattern, and CI workflow contract (lint → typecheck → build). Production deploys to Spaceship remain **`spaceship-node-deployment.md`**, not GitHub Releases alone.

## Terminology & gate sequence (workspace-wide)

- **PHP:** `msc_` function prefix · **CSS/UI:** `msc-` class prefix
- **Ports:** web **3000** (`MSC_DEV_PORT`) · AI proxy **4000**/**8000** (`MSC_LITELLM_PORT`)
- **Pre-flight / post-build:** always **Node 2** kill → smoke order — never smoke-only when docs reference the gate

## Anti-conflict rule

Do not paste competing command lists from memory—always read `package.json` and sync docs to match. Point `.cursorrules` and prompts at skill **Node IDs** instead of duplicating full runtime blocks.
