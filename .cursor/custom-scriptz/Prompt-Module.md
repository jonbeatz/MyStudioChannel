# For Cursor Agent: Install my portable modules

To install a portable module in this project:

1. Find the module folder in `.cursor/custom-scriptz/`
2. Run `.\.cursor\custom-scriptz\[module-name]\install.ps1` from repo root (use **pwsh** if Windows PowerShell 5.1 reports parse errors)
3. Follow post-install steps in that module's `CURSOR.md`
4. Run verify commands from `module.manifest.json` (not Vader-specific gates)

## Available modules

| Folder | Purpose |
|--------|---------|
| `google-api-proxy` | LiteLLM + ngrok for Cursor AI |
| `backup-system` | Backup project command (`msc-website-v{N}-{a-z}` folder naming) |
| `hostinger-setup` | Hostinger FTPS/SSH deploy stack + pitfalls + rules |
| `hermes-system` | J.A.R.V.I.S.: Mem0, VRAM monitor, FLUX gen, Payload types sync, session + Kanban stack |
| `book-consultation` | Multi-step consultation booking (Payload + Resend) |
| `schedule-a-call` | Call scheduling lightbox (Payload + Resend) |
| `stay-in-the-loop` | Newsletter / email signup double opt-in |
| `social-autopost` | Multi-platform social auto-post (dry-run CLI, formatters, Postiz stub) |

## List modules (PowerShell)

```powershell
Get-ChildItem .cursor\custom-scriptz -Directory -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -ne '_lib' -and (Test-Path (Join-Path $_.FullName 'module.manifest.json')) } |
  ForEach-Object {
    $m = Get-Content (Join-Path $_.FullName 'module.manifest.json') -Raw | ConvertFrom-Json
    [PSCustomObject]@{ Folder = $_.Name; Id = $m.moduleId; Description = $m.description }
  }
```

## Name aliases

| User may say | Folder |
|--------------|--------|
| `google-api-proxy`, `google-api module`, `google-api` | `google-api-proxy` |
| `backup-system`, `backup module` | `backup-system` |
| `hostinger-setup`, `hostinger module`, `install hostinger` | `hostinger-setup` |
| `hermes-system`, `jarvis module`, `hermes module` | `hermes-system` (includes session + Kanban stack scripts) |
| `book-consultation`, `booking module` | `book-consultation` |
| `schedule-a-call`, `call scheduling module` | `schedule-a-call` |
| `stay-in-the-loop`, `newsletter module` | `stay-in-the-loop` |
| `social-autopost`, `auto-post module`, `social module` | `social-autopost` |

## Installer flags (optional)

- `-WhatIf` — dry run
- `-Force` — overwrite existing config
- `-SkipVerify` — skip installer preflight

## If `custom-scriptz` is missing

Tell the operator to copy the entire `.cursor/custom-scriptz/` folder from Vader Engine or a G: backup, then retry.

## Security

- Never ask for API keys, tokens, or passwords in chat
- Never paste `.env.local` or credential file contents
- Never commit paths listed in manifest `neverCommit`
- Operator sets live values in `.env.local` only

## Human index

[README.md](README.md)
