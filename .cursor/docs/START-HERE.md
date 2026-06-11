# START HERE (Daily Ops)

If an agent is new to this project, read this file first.

Project root: `D:\Cursor_Projectz\MyStudioChannel`

---

## For new developers

If you are joining the project for the first time, use our automated onboarding command:

```bash
npm run setup:dev
```

This script automates the installation, environment configuration, and initial database setup. Once complete, run `npm run dev` to begin.

---

## Operator profile

- Operator name: **Jon**
- Handshake rule: when an agent starts or resumes from docs, first line should include the operator name.
  - Startup example: **"Ok Jon - docs loaded, ready to go."**
  - Closeout example: **"Great work Jon - all saved."** (use "see you later" only on "End Project").

Use this as a quick confidence signal that docs were read.

---

## Source-of-truth order

When docs differ, use this priority:

1. **[`TRUTH.md`](../../TRUTH.md)** (absolute master blueprint - read first!)
2. `START-HERE.md` (this file - daily operations)
3. `Agent-Runbook.md` (copy/paste prompts)
4. `HOSTINGER-DEPLOY.md` (Hostinger deployment guide)
5. `Jedi-List.md` (commands quick reference)
6. `Development.md` (architecture details)
7. `ReCall.md` / `Restore-Points.md` (history + checkpoints)

**Planning backlog (optional, not daily ops):**

- [`.cursor/review.md`](../review.md) — audit follow-up and next-session queue
- [`.cursor/ideaz.md`](../ideaz.md) — portable `custom-scriptz` / new-project kit ideas

---

## Core docs only (daily)

These are the only docs you should need most days:

- `START-HERE.md`
- `Agent-Runbook.md`
- `HOSTINGER-DEPLOY.md`
- `Jedi-List.md`
- `Restore-Points.md`

Other docs are reference/history and optional unless a task specifically needs them.

Portable workflow skills pack for reuse in other projects:
- `.cursor/skills/Workflow-Portable/README.md`

**UI & agent skills (MSC — read before UI work):**
- **MSC-UI-Taste** — `.cursor/skills/MSC-UI-Taste/SKILL.md` (anti-slop, polish workflow)
- **NovaMira-Design** — Studio Gold `#F5B841`, glass, bento
- **Premium-UI** — registries, motion/react, 21st.dev
- **DesignMD** — brand extraction (required before greenfield UI)

**Think layer (Obsidian):** `I:\Vader_Vault` — personal notes; ship layer = this repo's `.cursor/docs/` + TRUTH. Weekly distill to ReCall (operator calendar).

**MCP:** Global **12** + project **6** — `MCP-SETUP.md`. **`HOSTINGER_API_TOKEN`** in `.env.local` → **`npm run msc:sync:mcp-env`**. Reload: **Settings → MCP** (refresh server) or restart Cursor.

Project rules layout:
- Core rule file: `.cursorrules`
- Scoped rules folder: `.cursor/rules/` (topic-specific `.mdc` files)
- Skills: `.cursor/skills/`

---

## Docs map (what to read when)

| Doc | Use it for | Priority |
|---|---|---|
| `START-HERE.md` | Daily startup/deploy guardrails | Daily |
| `MASTER-COMMANDS.md` | Master list of dev, deployment, and troubleshooting commands | Daily |
| `Agent-Runbook.md` | Copy/paste prompts (`Ready to begin`, `Lets Start`, etc.) | Daily |
| `HOSTINGER-DEPLOY.md` | Hostinger hPanel deployment guide | Deployment |
| `DEPLOYMENT-FIXES.md` | Hostinger deploy fixes & learnings (2026-06-01) | Deployment / troubleshooting |
| `Jedi-List.md` | Commands and script meanings | Daily |
| `Restore-Points.md` | Known-good checkpoints + rollback notes | Daily (after milestones) |
| `ReCall.md` | Session history and resume context | Optional |
| `ToDo.md` | Next ideas / tomorrow’s focus (lightweight; not a full backlog) | Optional |
| `Development.md` | Architecture and deep implementation details | Optional |
| `MCP-SETUP.md` | Cursor MCP global vs project config, msc:sync:mcp-env | Optional |
| `markdown-docs/*.md` | Local Markdown copies of external docs/tools | Optional |
| `markdown-docs/*.md` | Converted Markdown documentation from external links | Optional |
| `GitHub-Cheat-Sheet.md` | Git quick ref + bundle/archive recovery | Optional |
| `Run-Next-JS.md` | Local run/build/deploy summary | Optional |
| `Site-Plans.md` | Product/site planning notes | Archive/Optional |
| `Headless-WP-Backend-Plan.md` | WP integration planning | Archive/Optional |
| `NovaMira-MSC-PRO-ENGINE.md` | Branding/engine reference notes | Archive/Optional |

If an agent over-reads history/planning docs, tell it:
`Use only START-HERE, Agent-Runbook, HOSTINGER-DEPLOY, Jedi-List, and Restore-Points unless asked otherwise.`

---

## Fast daily workflow

### Start work (local)

1. Open terminal in repo root.
2. Ensure Hostinger MCP is connected in Cursor Settings (Sign in to Hostinger Connector).
3. Run **`npm run dev`** (frees port **3000**, then **`next dev`** — no full **`.next`** wipe on every start).
3. Verify:
   - `http://localhost:3000/`
   - `http://localhost:3000/admin`

If local breaks with missing vendor chunks (`date-fns`, etc.), after **`pushit:live`**, or when **`/admin`** **500s** after a bad overlap, run **`npm run dev:fresh`** or **`npm run dev:recover`** (both **clean** **`.next`** then dev).

### Public site URL (`.env.local` + production)

- **Local:** set **`NEXT_PUBLIC_SERVER_URL`** in **`.env.local`** to your dev origin (see **`.env.example`**) so Payload admin **CSRF** and **View site** match what you open in the browser.
- **Production:** set **`NEXT_PUBLIC_SERVER_URL`** and/or **`PAYLOAD_PUBLIC_SERVER_URL`** on the host (see **HOSTINGER-DEPLOY.md**). If both are missing at build/runtime, the app falls back to **`https://mystudiochannel.com`** (override with **`MSC_CANONICAL_SITE_ORIGIN`**). Details: **`Jedi-List.md`** → *Public site URL*.
- **MCP secrets:** after changing **`GITHUB_PERSONAL_ACCESS_TOKEN`**, **`RESEND_API_KEY`**, **`TAVILY_API_KEY`**, **`NGROK_AUTHTOKEN`**, or **`WORDPRESS_*`** in **`.env.local`**, run **`npm run msc:sync:mcp-env`** and reload MCP in Cursor (**`MCP-SETUP.md`**).

### Google API Proxy (LiteLLM + ngrok)

For Vertex AI model testing/dev workflows:
- Run **`npm run msc:google-api:start`** to fire up LiteLLM on port **4000** and mount an active ngrok HTTPS tunnel.
- Check connections and display Cursor settings via **`npm run msc:litellm:test:ngrok`** (prints **Override OpenAI Base URL** + API key — use **`MSC_LITELLM_MASTER_KEY`** from **`.env.local`**, not a committed placeholder).
- **Cursor Models:** **Auto** and **Tab** use Cursor’s servers; custom **`vader-*`** models use the ngrok **`/v1`** URL above. LiteLLM/ngrok survive a Cursor restart; **End Project** runs **`msc:session:stop`** (ports **3000**, **4000**, **4040**).
- Keep credentials safe; never commit Service Account JSON or raw authtokens. Reference: **`config/Ngrok-SETUP.md`**.

### Why the browser shows a white page + `/_next/static/chunks/fallback/*` (500)

That pattern almost always means **`.next` was deleted or overwritten while `next dev` was still running** — for example **`npm run verify:next`** or **`npm run clean:next`** in a **second** terminal while the dev server was up. The dev server then serves broken chunks and error fallbacks.

**Fix (Local / Cursor / repo root):** one terminal only — **`npm run dev:recover`** (or **`npm run repair:dev`** for clean + build + dev). Do not run **`verify:next`** until dev is stopped unless you use **`npm run verify:next:safe`**, which stops whatever is on port **3000** first.

**Prevention:** Cursor blocks **`verify:next`** / **`clean:next`** when port **3000** is busy (see **`.cursor/hooks.json`**). Prefer **`verify:next:safe`** when you are not sure.

### Deploy to Hostinger (read first)

**Full guides:**

- **[HOSTINGER-DEPLOY.md](./HOSTINGER-DEPLOY.md)** — env vars, hPanel build settings, zip vs FTPS, troubleshooting
- **[HOSTINGER-MODULE.md](./HOSTINGER-MODULE.md)** — portable Hostinger kit (drop into new projects via `.cursor/custom-scriptz/hostinger-setup/`)
- **[DEPLOYMENT-FIXES.md](./DEPLOYMENT-FIXES.md)** — 2026-06-01 successful deploy learnings (dependency rule, lockfile, zip flow)
- **[Go-Live-Checklist.md](./Go-Live-Checklist.md)** — tiered FTPS checklist

**First deploy / full refresh (zip):** stop dev → audit **`npm ls --omit=dev --depth=0`** → **`npm run build`** → upload **`MyStudioChannel-deploy.zip`** in hPanel → set env vars → Deploy → restart Node. See **HOSTINGER-DEPLOY.md** → *Path A*.

**Ongoing updates:** say **"push it live"** in Cursor — agent **asks mode** (Quick DB · Full FTPS · MCP code-only). **MCP/Git rebuild ≠ DB deploy** — verify live `payload.sqlite` ~500 KB after code deploys; use **`npm run msc:push:db:live`** if APIs **500**. See *Push to live* below.

### Push to live

From repo root on PC:

0. **Before upload:** run **`npm ls --omit=dev --depth=0`** — any package imported in app/CSS must be in **`dependencies`** (Hostinger skips **`devDependencies`**). See **DEPLOYMENT-FIXES.md**.
1. Run `npm run pushit:live` (ships **admin-ui**, **`.next`**, **`payload.sqlite`**, **`public/media`**, then SSH **`sync-db`** + **`sync-app`** + host **`npm install --ignore-scripts`**). FTPS lands in **`public_html/nodejs/`**; sync copies into the **live app root**. By default it **does not** auto-start local dev — run **`npm run dev`** afterward. Optional: **`PUSHIT_LIVE_RUN_DEV_FRESH=1`** (**HOSTINGER-DEPLOY.md**).
2. Wait for build/upload completion. **One or two FTPS errors** on random `.next` chunks with **retry OK** at the end is normal.
3. In hPanel, restart the Node app.
4. Validate live in Incognito.

Important: `pushitup` runs on PC, not Hostinger Terminal. You may upload **`.next`** with **FileZilla** instead if you follow **HOSTINGER-DEPLOY.md** and still deploy the rest of Tier 2 when needed.

**FTPS target:** **`FTP_REMOTE_PATH=/nodejs`** → uploads to **`public_html/nodejs/`** (staging). **`msc:hostinger:sync-db`** + **`msc:hostinger:sync-app`** copy DB and code into the **live app root** (`domains/.../nodejs/`). **Do not delete `public_html/nodejs/`** — see **HOSTINGER-DEPLOY.md** § *folder map*.

### Pushing updates live

| I want to… | Command |
|------------|---------|
| CMS/API broken, site loads (stub DB) | **`npm run msc:push:db:live`** (~1–2 min) → [restart in hPanel](https://hpanel.hostinger.com/websites/mystudiochannel.com) |
| Push **code/UI** fast (~10–15 min) | **`npm run pushit:live:fast`** (zip `.next` + **`sync-app`**; **no DB** unless **`-WithDb`**) |
| Push **code + DB** fast | **`npm run pushit:live:fast -- -WithDb`** → restart in hPanel when step 9 done |
| Push **code + DB + media** (full parity) | **`pushit:live`** (includes **`sync-db`** + **`sync-app`**) → restart in hPanel |
| Preflight fast deploy (no upload) | **`npm run msc:pushit:live:fast:dry`** |
| Diagnose staging before deploy | **`npm run msc:hostinger:deploy-diagnose`** |
| Deploy took ~45 min (zip fallback) | Read **`logs/pushit-unzip-last.log`** · **DEPLOYMENT-TROUBLESHOOTING.md** § fast deploy mistakes |
| Push **code** only (MCP zip) | Say **push it live** → choose MCP → verify DB size after |
| Repair live `node_modules` (503 webpack) | **`npm run msc:hostinger:npm-install`** → restart in hPanel |
| Diagnose live 503 | **`npm run msc:hostinger:recover`** → follow stderr hint → restart |
| Stream server error logs live | **`npm run msc:logs:live`** (SSH `tail -f stderr.log`) |
| Stream server console logs live | **`npm run msc:logs:live:console`** (SSH `tail -f console.log`) |
| Optimize local database | **`npm run msc:db:optimize`** (`PRAGMA optimize` + `VACUUM`) |
| Purge old local backups | **`npm run msc:backup:clean`** (retains only 10 most recent backups) |
| Trim deploy zips in repo | **`npm run backup:clean-zips`** (keeps 3 newest in `zips/`) |
| Push with new packages | **`git push origin main`** (auto rebuild, if Git connected) |
| Check what Hostinger will install | **`npm ls --omit=dev --depth=0`** |
| Verify build before push | **`npm run build && npm run msc:verify:local`** |
| Test live site | **`npm run msc:verify:live`** |

Full guide: **HOSTINGER-DEPLOY.md** → *Path C — Daily updates*.

## ✅ Deployment Verification

Before considering your deployment complete, run through the:  
**[Final Configuration Audit (1-Minute Checklist)](./HOSTINGER-DEPLOY.md#-final-configuration-audit-1-minute-checklist)**

---

## Hostinger links (session-scoped)

**Jon’s current bookmarks**:

- hPanel:  
  <https://hpanel.hostinger.com/>

**Agent instruction:** When telling Jon to run something, always say whether it is **Local (Cursor / PC repo root)** or **Live (Hostinger hPanel)**.

---

## Top 7 rules (avoid pain)

1. Do not run `pushitup` in Hostinger Terminal.
2. For app/admin code changes: full `npm run build` + full `.next` upload. Keep **`.vscode/sftp.json`** **`remotePath`** aligned with **HOSTINGER-DEPLOY.md** (FTPS **`/`** vs Hostinger path); run **`npm run msc:verify:ftp-smoke`** if anything about the upload target folder is uncertain.
3. Do not partially upload random files inside `.next`.
4. If you delete server `.next`, immediately re-upload `.next` from PC.
5. After deploy, **`sync-app`** runs **`npm install --ignore-scripts`** on the host when lockfile changes — prefer **`pushit:live`** over manual hPanel npm. Manual repair: **`msc:hostinger:npm-install`**.
6. Keep `patches/` present on server if install relies on `patch-package`.
7. After deploy, restart Node app and validate in Incognito.

---

## If site goes down (live quick path)

1. **Live (hPanel):** restart Node.js app
2. Check `/nodejs/payload.sqlite` size (real DB vs `4 KB` stub)
3. If DB was replaced, delete `payload.sqlite-wal` and `payload.sqlite-shm`
4. **503 quick path:** `npm run msc:hostinger:recover` or read `/nodejs/stderr.log` — missing **preload** → recover; missing **webpack** → `msc:hostinger:npm-install`; wrong version → `msc:hostinger:sync-app`. See [DEPLOYMENT-TROUBLESHOOTING.md](./DEPLOYMENT-TROUBLESHOOTING.md).
5. Re-test `/`, `/admin`, and `/api/globals/projects-home?depth=1`
6. Use full incident guide: [DEPLOYMENT-TROUBLESHOOTING.md](./DEPLOYMENT-TROUBLESHOOTING.md)

## Quick incident recovery (when things suddenly break)

1. Local broken after deploy? Run `npm run dev:fresh`.
2. If `msc:verify:local` still fails on `/` + `/admin`, check for port hijack:
   - kill stale node process on `3000`
   - rerun `npm run dev:fresh`
3. Live 500 with `vendor-chunks` module errors:
   - Restart app in hPanel
   - remove server `.next`
   - re-upload full `.next` from PC
   - Start app again
4. In Hostinger Terminal, ensure you are in the correct directory for `npm`.
5. Use correct log files in app root.

---

## What to tell a new agent

**Full session sync (recommended):** say **`Ready to begin`** or paste the block from **`Custom-Prompts.md` → item 0** — same content as **`Agent-Runbook.md` → §0 Ready to begin (full sync)**. The agent reads core docs, rules, and git/local health before coding; first reply should start with **`Ok Jon - Ready to begin.`** (see **Agent-Runbook** handshake).

**Known-good resume tip:** newest dated row in **`Restore-Points.md`** (e.g. **`RP-2026-05-30-*`**) — stay on **`main`** and **`git pull`** for latest.

**Minimal bootstrap:** paste this:

```text
Use `.cursor/docs/START-HERE.md` then `.cursor/docs/Agent-Runbook.md` and `.cursor/docs/HOSTINGER-DEPLOY.md` as source of truth.
Project root is D:\Cursor_Projectz\MyStudioChannel.
Use operator handshake with my name: Jon.
```

---

## Restore points (quick rollback memory)

Yes, keep using `Restore-Points.md`. It is useful.

Use this lightweight pattern after meaningful milestones:

- **Checkpoint ID:** `RP-YYYY-MM-DD-short-name`
- **Branch/commit:** `<branch> @ <sha>`
- **What was working:** 2-4 bullets
- **How to restore:** exact commands (checkout/reset/deploy/startup)
- **Known caveats:** env/dependency notes

This gives fast "go back to known good" context for future sessions.
