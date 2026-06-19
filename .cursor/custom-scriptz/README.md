# Portable modules (`custom-scriptz`)

Personal dev packs — **fat on disk** (include `ngrok.exe` locally), **lean in Git** (binaries gitignored).

| Module | Purpose | Manifest |
|--------|---------|----------|
| [google-api-proxy](google-api-proxy/) | LiteLLM + Vertex + ngrok for Cursor AI | [module.manifest.json](google-api-proxy/module.manifest.json) |
| [backup-system](backup-system/) | Standard/Full robocopy + BackUp-Notez + versioned folder naming (`msc-website-v{N}-{a-z}`) | [module.manifest.json](backup-system/module.manifest.json) |
| [hostinger-setup](hostinger-setup/) | Hostinger deploy tiers, SSH sync, pitfalls, Cursor rules | [module.manifest.json](hostinger-setup/module.manifest.json) |
| [hermes-system](hermes-system/) | J.A.R.V.I.S. suite: Mem0/Qdrant, VRAM monitor, FLUX image gen, Payload types sync, **session + Kanban stack** | [module.manifest.json](hermes-system/module.manifest.json) |
| [book-consultation](book-consultation/) | Multi-step consultation booking + Resend + Payload | [module.manifest.json](book-consultation/module.manifest.json) |
| [schedule-a-call](schedule-a-call/) | Single-step call scheduling lightbox + Payload | [module.manifest.json](schedule-a-call/module.manifest.json) |
| [stay-in-the-loop](stay-in-the-loop/) | Double opt-in newsletter / email signup + Resend | [module.manifest.json](stay-in-the-loop/module.manifest.json) |
| [social-autopost](social-autopost/) | Multi-platform social auto-post scaffold (dry-run CLI, Postiz stub, Hermes skill) | [module.manifest.json](social-autopost/module.manifest.json) |

Shared installer helpers: [_lib/Msc-ModuleInstall.ps1](_lib/Msc-ModuleInstall.ps1)

## Quick install (Vader or any repo)

```powershell
.\.cursor\custom-scriptz\google-api-proxy\install.ps1
.\.cursor\custom-scriptz\backup-system\install.ps1
.\.cursor\custom-scriptz\hostinger-setup\install.ps1
.\.cursor\custom-scriptz\hermes-system\install.ps1
```

Feature modules (`book-consultation`, `schedule-a-call`, `stay-in-the-loop`) install into an existing Payload/Next app — see each module's `CURSOR.md`.

## Copy to another project

1. Robocopy entire `.cursor/custom-scriptz/` folder (includes local `ngrok.exe` in google-api-proxy).
2. Run `install.ps1` for each module you need from the new repo root.
3. `npm install` · copy `.env.local` + GCP key manually.
4. `npm run msc:litellm:preflight`

## Create a new module

Say **`make new`** or **`create module`** — see **`.cursor/ideaz.md`** (portable module roadmap).

## Future modules (backlog)

See **[`.cursor/ideaz.md`](../ideaz.md)** for the portable studio kit roadmap (`dev-runtime-core`, `docs-governance`, `project-bootstrap`, etc.).

## Agent entry (any project)

**[Prompt-Module.md](Prompt-Module.md)** — tell the agent to read and follow this file, then name the module (e.g. `google-api-proxy`). For install steps, open each module's `CURSOR.md` + `install.ps1`.

Per-module detail: `module.manifest.json` + `CURSOR.md` + `install.ps1`.

## Sync portable copies from live repo

After changing `scripts/`, session stack, LiteLLM, backup, or Hostinger tooling:

```powershell
npm run msc:portable:sync
```

Individual modules: `msc:hermes:module:sync`, `msc:google-api:module:sync`, `msc:backup:module:sync`, `msc:hostinger:module:sync`.

Registry: [registry.json](registry.json) · Audit drift: `npm run sync` (docs audit includes portable hash check).
