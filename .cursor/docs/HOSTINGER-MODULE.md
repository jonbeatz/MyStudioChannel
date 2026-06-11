# Hostinger portable module — operator guide

**Module:** `.cursor/custom-scriptz/hostinger-setup`  
**Install:** `.\.cursor\custom-scriptz\hostinger-setup\install.ps1`  
**Agent playbook:** `CURSOR.md` (same folder)

This document is the **portable** deploy brain — distilled from MyStudioChannel production lessons. For the full MSC site-specific guide, see `HOSTINGER-DEPLOY.md` after install.

---

## Two-folder model (critical)

| Path on server | Role |
|----------------|------|
| **`public_html/nodejs/`** (FTPS `FTP_REMOTE_PATH`) | **Staging** — FTPS uploads land here |
| **`HOSTINGER_APP_ROOT`** (e.g. `/home/.../domains/site.com/nodejs`) | **Live app root** — Node.js actually runs here |

**FTPS alone does not update live.** Always run **`msc:hostinger:sync-app`** (and **`sync-db`** when DB changed) so staging copies into the live root.

---

## Deploy tiers

| Tier | Command | When |
|------|---------|------|
| **Quick DB** | `npm run msc:push:db:live` | `/` OK, APIs **500**, stub `payload.sqlite` on server |
| **Fast (daily)** | `npm run pushit:live:fast` | Code/UI — zip `.next`, SSH unzip, sync-app (~10–15 min) |
| **Fast + DB** | `npm run pushit:live:fast -- -WithDb` | Fast path **with** `payload.sqlite` |
| **Full** | `npm run pushit:live` | DB + media + full parity (~45–60 min) |
| **Tier 1 branding** | `npm run msc:pushitup:admin-branding` | Admin CSS/branding only |
| **Tier 3 config** | `npm run msc:pushitup:server-config` | `server.js`, `package.json`, lockfile |

**Say "push it live"** → agent runs `Push-Website-Live.md` with **AskQuestion** (Quick DB · Fast · Full · MCP avoid).

---

## Command locality

| Where | What |
|-------|------|
| **Local (PC repo root)** | `npm run build`, `pushit:live*`, `msc:hostinger:*`, `git` |
| **Live (hPanel browser)** | Node.js **Restart** — [https://hpanel.hostinger.com/](https://hpanel.hostinger.com/) |
| **Live (SSH)** | Prefer **Local scripts** (`msc:hostinger:npm-install`, `sync-app`, `recover`) |

**Never** run `pushitup` in hPanel Terminal.

---

## Post-deploy

1. Wait for script **step 9** / "Restart Node in hPanel"
2. **Restart** Node.js app in hPanel
3. `npm run msc:verify:live`
4. Optional: `npm run msc:verify:live:version`

---

## MCP (optional)

Add `HOSTINGER_API_TOKEN` to `.env.local` → `npm run msc:sync:mcp-env` → reload MCP.  
Uses scoped launcher `msc-hostinger-mcp.mjs` (hosting, vps, domains, dns).

---

## Pitfalls index

See **`PITFALLS-HOSTINGER.md`** in this module (installed to `.cursor/docs/`).

---

## New project setup

See **`NEW-PROJECT-CHECKLIST.md`**.
