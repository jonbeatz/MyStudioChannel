# My Commands — MyStudioChannel SSoT

This is the single source of truth for ALL custom commands and scripts wired into the MyStudioChannel engine.

## ⚡ Quick Aliases (Easiest to Type)

| Alias | Full Command | Purpose |
|-------|--------------|---------|
| `npm run doctor` | `npm run msc:doctor` | Full project health check |
| `npm run setup:dev` | `node scripts/setup-dev.mjs` | Automated contributor onboarding |
| `npm run log:session` | `npm run msc:log:session` | Log interactive session summary |
| `npm run log:fix` | `npm run msc:log:fix` | Log interactive bug fix |
| `npm run log:milestone` | `npm run msc:log:milestone` | Log milestone achievement |
| `npm run backup` | `npm run msc:backup:quick` | Non-interactive standard backup |
| `npm run sync` | `npm run msc:docs:sync` | Audit and sync all documentation |
| `npm run docs` | `npm run docs:audit` | Audit internal documentation links |
| `npm run deploy` | `npm run push:website:live` | MCP code-only (verify DB after) |
| `npm run deploy:full` | `powershell -File scripts/push-website-live.ps1 -Ftps` | Full FTPS code + DB + media |
| `npm run msc:push:db:live` | — | Quick DB sync (~1–2 min) |
| `[URL]/test` | `app/test/[[...slug]]/page.tsx` | Isolated design playground |

---

## 🛠️ Engine & Maintenance

| Command | Action |
|---------|--------|
| `npm run msc:doctor` | Baseline health check (Node, Env, DB, Git, Ports) |
| `npm run msc:kill-dev-port` | Clears processes on port 3000 |
| `npm run msc:db:optimize` | PRAGMA optimize + VACUUM for local SQLite |
| `npm run msc:db:maintain` | Optimize + Create clean deployment copy |
| `npm run msc:media:consolidate` | Organizes stray media into /public/media/ |
| `npm run msc:media:sync` | Registers physical files to Payload database |
| `npm run msc:generate:types` | Regenerates Payload TypeScript definitions |

---

## 📦 Deployment & Remote Logs

| Command | Action |
|---------|--------|
| `npm run msc:push:website:live` | Main deployment orchestrator |
| `npm run msc:deploy:zip` | Creates robocopy-staged deployment archive |
| `npm run msc:verify:live` | Smoke tests all live endpoints |
| `npm run msc:logs:live` | Stream remote stderr.log via SSH |
| `npm run msc:logs:live:console` | Stream remote console.log via SSH |

---

## 📡 Google API & LiteLLM

| Command | Action |
|---------|--------|
| `npm run msc:google-api:start` | Stop + Start LiteLLM proxy with ngrok tunnel |
| `npm run msc:litellm:status` | Check if proxy is online |
| `npm run msc:litellm:verify` | Run chat smoke test against vader-3-flash |
| `npm run msc:litellm:stop` | Cleanly terminate all proxy processes |

---

## 🎨 Design System (Curated References)

| Site | Style Profile | Reference File |
|------|---------------|----------------|
| **Stripe** | Ultra-premium, weight-300 elegance | `DESIGN-STRIPE.md` |
| **Supabase** | Dark emerald, developer-first | `DESIGN-SUPABASE.md` |
| **Tesla** | Minimalist subtraction, high imagery | `DESIGN-TESLA.md` |
| **Linear** | Precise SaaS, modern indigo | `DESIGN-LINEAR.md` |
| **Apple** | Premium white space, SF Pro | `DESIGN-APPLE.md` |

**Tool:** Use the **Awesome List** (VoltAgent) to "shop" for more brand files via `curl` to `.cursor/DesignMD/`.

---

## 🧹 Backup System

| Command | Action |
|---------|--------|
| `npm run msc:backup` | Interactive backup ritual (buttons) |
| `npm run msc:backup:quick` | Non-interactive daily standard backup |
| `npm run msc:backup:quick:full` | Non-interactive weekly full backup |
| `npm run msc:backup:clean` | Purge backups older than 10 most recent |
