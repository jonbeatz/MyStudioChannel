# CURSOR — Install `hostinger-setup`

## When to use

- Operator says **`install hostinger module`**, **`install hostinger-setup`**, or **`setup hostinger deploy`**
- Dropping MyStudioChannel deploy workflow into a **new** Next.js / Payload project on Hostinger

## Agent procedure (install)

1. Read [module.manifest.json](module.manifest.json).
2. **Local (repo root):**

   ```powershell
   .\.cursor\custom-scriptz\hostinger-setup\install.ps1
   ```

   Flags: `-WhatIf` (dry run) · `-Force` (overwrite rules/prompts/docs)

3. Merge [global.mdc.fragment](global.mdc.fragment) into `.cursor/rules/global.mdc` if **push it live** shortcuts missing.
4. Operator fills **`.env.local`** — see [env.example.fragment](env.example.fragment).
5. Smoke:
   - `npm run msc:test:hostinger-ftp`
   - `npm run msc:hostinger:deploy-diagnose` (after SSH vars set)

## Push website live (after install)

Trigger: **push it live** / **push website live** / **deploy live**

1. Run [prompts/Push-Website-Live.md](prompts/Push-Website-Live.md) with **`AskQuestion`** first.
2. Modes: Quick DB · **Fast FTPS** (`pushit:live:fast`) · Full FTPS · MCP (avoid on Hostinger shared Node).
3. Always end with **hPanel Node restart** + `msc:verify:live`.

## Knowledge files (installed to `.cursor/docs/`)

| File | Purpose |
|------|---------|
| `HOSTINGER-MODULE.md` | Two-folder model, tiers, locality |
| `PITFALLS-HOSTINGER.md` | Symptom → fix index |
| `NEW-PROJECT-CHECKLIST.md` | First-time setup on new repo |

## Rules (installed to `.cursor/rules/`)

- `deploy-safety-hostinger.mdc` — tier scripts, never pushitup in hPanel
- `jon-operator-hpanel.mdc` — Local vs Live labels, hPanel link

## Scripts bundled

All under `hostinger-setup/scripts/` → copied to repo `scripts/` on install:

- FTPS: `PushItUP.ps1`, `pushit-live*.ps1`, `push-website-live.ps1`
- SSH: `msc-hostinger-*-ssh.mjs`, `msc-push-db-live.mjs`
- Verify: `Test-HostingerFtp.ps1`, `verify-live.ps1`, `verify-live-version.ps1`
- DB: `copy-db-for-deploy.ps1`, `assert-payload-sqlite-deploy.ps1`

## Updating the module from MyStudioChannel

When deploy scripts change in the main repo, refresh the module copy:

```powershell
npm run msc:hostinger:module:sync
```

Copies `scripts/` → `hostinger-setup/scripts/`, rules, prompts, and portable docs.

On **another** project: re-run `install.ps1` to pull the updated module into that repo.

## Security

- Never commit `.env.local`, FTP/SSH passwords, or `HOSTINGER_API_TOKEN`
- Never run deploy commands unless operator explicitly requests **push it live**
