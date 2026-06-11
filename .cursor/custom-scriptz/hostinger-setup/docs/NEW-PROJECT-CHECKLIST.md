# New project — Hostinger module checklist

After `install.ps1` on a **new** repo:

## 1. Install module

```powershell
.\.cursor\custom-scriptz\hostinger-setup\install.ps1
```

Copy entire `.cursor/custom-scriptz/` from MyStudioChannel (or G: backup) if the folder is missing.

## 2. Environment (`.env.local`)

Fill from `env.example.fragment`:

- `FTP_*` — FTPS staging (`FTP_REMOTE_PATH` usually `/nodejs` under `public_html`)
- `HOSTINGER_SSH_*` — SSH credentials from hPanel
- `HOSTINGER_APP_ROOT` — **live** Node app root (not staging path)
- `HOSTINGER_API_TOKEN` — optional, for Hostinger MCP

## 3. Customize for this site

- [ ] Replace domain in `verify-live.ps1` / `verify-live-version.ps1` if bundled URLs are still `mystudiochannel.com`
- [ ] Edit `Push-Website-Live.md` branch/site names if copied from MSC
- [ ] Add `HOSTINGER-MODULE.md` link to project `START-HERE.md`
- [ ] Merge `global.mdc.fragment` into `.cursor/rules/global.mdc`

## 4. Smoke tests

```powershell
npm run msc:test:hostinger-ftp
npm run msc:hostinger:deploy-diagnose
```

## 5. Optional MCP

```powershell
npm run msc:sync:mcp-env
```

Reload **Settings → MCP** in Cursor.

## 6. First deploy

Say **push it live** → pick **Fast FTPS** for code-only, **`-WithDb`** if CMS DB must ship.

**hPanel restart:** https://hpanel.hostinger.com/

## 7. Pair with other portable modules

| Module | Purpose |
|--------|---------|
| `backup-system` | Pre-deploy backup |
| `google-api-proxy` | Optional Vertex/LiteLLM (not required for Hostinger) |
| `dev-runtime-core` | *(ideaz backlog)* local port 3000 recovery |
