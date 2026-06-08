# Prompt & Custom Commands Cheat Sheet

**Last Updated:** 2026-06-06

---

## ⚡ Quick Aliases (Easiest to Type)

| Alias | Full Command | What it does |
|-------|--------------|--------------|
| `npm run log:session` | `npm run msc:log:session` | Log session summary |
| `npm run log:fix` | `npm run msc:log:fix` | Log a bug fix |
| `npm run log:milestone` | `npm run msc:log:milestone` | Log a milestone |
| `npm run doctor` | `npm run msc:doctor` | Full health check |
| `npm run docs` | `npm run docs:audit` | Audit documentation |
| `npm run sync` | `npm run docs:sync` | Sync documentation |
| `npm run backup` | `npm run msc:backup:quick` | Quick backup |
| `npm run deploy` | `npm run push:website:live` | Deploy code only |
| `npm run deploy:full` | `npm run push:website:live -- --ftps` | Deploy code + database |

---

## 🚀 Unified Commands (Session Workflows)

These commands are bound to automated workflows inside `.cursor/prompts/` and are coordinated by `.cursor/rules/workflow.mdc`.

### ➡️ `"Start Project"`  
*Alternative phrasings: `"Begin Project"`, `"Start Session"`, `"Cold Start"`, `"Ready to begin"` (full sync)*
- **Action:** Cold-start handshake ritual.
- **Workflow File:** `.cursor/prompts/Start-Project.md`
- **Expected Behavior:** 
  1. Automatically reads critical files (`README.md`, `START-HERE.md`, `project-log.md`, `Checkpoint.md`, `TRUTH.md`).
  2. Runs lightweight preflight node/git environment checks.
  3. Optionally prompts to start the Google API / LiteLLM proxy.
  4. Outputs a beautiful, green session start handshake.
- **Handshake Response Formats:**
  ```text
  ✅ SESSION STARTED — [YYYY-MM-DD HH:MM]
  📁 Branch: [current branch]
  📝 Docs loaded: README, START-HERE, TRUTH, project-log, Checkpoint
  🔧 Git: [clean/has changes]
  🖥️ Node: [version]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ Ready, Jon. What shall we build today?
  ```
  *(See .cursor/docs/Agent-Runbook.md §0 for the full-sync requirements)*

### ➡️ `"End Project"`  
*Alternative phrasings: `"End Session"`, `"Close Session"`, `"Session Closeout"`, `"I'm done for now"`, `"Continue later"`*
- **Action:** Session closeout & cleanup.
- **Workflow File:** `.cursor/prompts/End-Project.md`
- **Expected Behavior:** 
  1. Identifies and summarizes modified, added, and deleted files.
  2. Appends logs to `.cursor/docs/project-log.md`.
  3. Runs a Git audit and asks if you would like to commit and push.
  4. Always runs `npm run msc:session:stop` (Next dev `3000`, LiteLLM `4000`, ngrok `4040`) — unconditional fresh restart.
  5. Outputs goodbye handshake.
- **Handoff Response Format:**
  ```text
  ✅ SESSION CLOSEOUT — [YYYY-MM-DD HH:MM]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📁 Branch: [current branch]
  📝 Changes logged to project-log.md
  🔧 Git: [clean if committed, otherwise note pending]
  🛑 Local services stopped: Next dev (3000), LiteLLM + ngrok (4000, 4040)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ Goodbye, Jon. See you next session.
  Cold-start pointer: Say "Start Project" to begin next session.
  ```

### ➡️ `"update docs"`  
- **Action:** Documentation sync & audit.
- **Workflow File:** `.cursor/prompts/Update-Docs.md`
- **Expected Behavior:** 
  1. Scans project folders for outdated paths, names, and contradictions.
  2. Synchronizes version info.
  3. Logs bug fixes and temporary changes to `ISSUES-RESOLVED.md`.
  4. Automatically stages, commits, and pushes doc updates (gated on your approval).

### ➡️ `"Update Project"`  
*Alternative phrasings: `"Sync Project"`*
- **Action:** Git-to-docs tracker sync.
- **Workflow File:** `.cursor/prompts/Update-Project.md`
- **Expected Behavior:** 
  1. Reads git logs and diffs.
  2. Automatically syncs milestone dates, versions, and lists inside `project-log.md` and `Checkpoint.md`.

### ➡️ `"backup project"`  
- **Action:** Interactive standard & full backups via **Composer buttons** (`AskQuestion`).
- **Module File:** `.cursor/custom-scriptz/backup-system/CURSOR.md`
- **Expected Behavior:** 
  1. Presents **clickable choices** for Type, Destination, Folder, Note, and Confirm (not "Reply 1 or 2").
  2. Packages files and exports to `G:\Cursor_Project_BackUpz\MyStudioChannel`.

---

## 🏃 Natural Language Session Triggers

These phrasings trigger targeted mini-runbooks or prompt workflows to help guide the AI's step-by-step thinking.

### ➡️ `"Lets Start"`
- **Purpose:** Lighter morning bootstrap.
- **Action:** Checks Git status, starts local server safely, verifies `/` + `/admin`, and confirms deployment tooling.

### ➡️ `"Lets Continue"`
- **Purpose:** Context rehydration.
- **Action:** Pulls current status from git and docs, then gives a concise "what matters now" summary.

### ➡️ `"Lets Finish"`
- **Purpose:** Safe end-of-day closeout without deployment.
- **Action:** Check status, update tracking docs, confirm commit and push to GitHub, stop local dev servers.

### ➡️ `"Lets Finish + Deploy"`
- **Purpose:** End-of-day closeout immediately followed by Hostinger deployment.
- **Action:** Runs closeout checks, updates tracking docs, commits/pushes to branch, and prints step-by-step deploy validation instructions.

### ➡️ `"Before you edit, list impacted files and why"`
- **Purpose:** Proactive impact risk planning.
- **Action:** Evaluates proposed task against codebase and outputs a short 2-3 line list of impacted files and risk level before any code change.

### ➡️ `"Lets Cut New Branch"`
- **Purpose:** Branch cutting.
- **Action:** Creates a clean git branch from the current HEAD, sets up upstream tracking, and verifies git branch status.

### ➡️ `"Show me only the exact next step"`
- **Purpose:** Focused, zero-noise execution.
- **Action:** Prevents long lists of options and outputs exactly ONE concrete, actionable step.

---

## 🧪 Development & Testing

Core triggers for local environment execution, compiling, and linting.

### ➡️ `"start dev"`  
*Alternative phrasings: `"dev"`, `"start local"`*
- **Action:** Start local development server.
- **Script Command:** `npm run dev`
- **Expected Outcome:** Launches the Next.js development server on `http://localhost:3000` with automated hot-reload.

### ➡️ `"run build"`  
*Alternative phrasings: `"build"`, `"compile"`*
- **Action:** Create Next.js production build.
- **Script Command:** `npm run build` *(or `npm run verify:next:safe` to build with safe port checks)*
- **Expected Outcome:** Compiles the optimized production build to the `.next/` directory.

### ➡️ `"run lint"`  
*Alternative phrasings: `"lint"`, `"check formatting"`*
- **Action:** Run code quality checks.
- **Script Command:** `npm run lint`
- **Expected Outcome:** Scans repository for TypeScript and ESLint syntax anomalies.

### ➡️ `"Run dev:fresh and recover localhost"`  
*Alternative phrasings: `"Fix localhost (white screen / 500 / fallback chunks)"`*
- **Action:** Full state reset of local server.
- **Script Command:** `npm run dev:fresh` or `npm run dev:recover`
- **Explanation:** Essential when `.next` was rebuilt/deleted while `next dev` was running. Kills port 3000, wipes cache, and brings back a healthy server.

---

## 📡 API Tunnels & Proxies

For AI development, API testing, and model integrations.

### ➡️ `"start google-api"`  
- **Action:** Start LiteLLM Vertex AI proxy + ngrok tunnel.
- **Script Command:** `npm run msc:google-api:start`
- **Expected Outcome:** Launches LiteLLM on port `4000` mapped to Vertex AI and mounts an active public HTTPS ngrok tunnel.

### ➡️ `"verify google-api"`  
- **Action:** Test proxy tunnel connections.
- **Script Command:** `npm run msc:litellm:test:ngrok`

### ➡️ `"stop google-api"`  
- **Action:** Stop active proxy instance.
- **Script Command:** `npm run msc:litellm:stop`

---

## 📦 Hostinger Deployment (Tiered FTPS)

Commands for deploying code changes to Hostinger from your PC terminal. Never run these from a host terminal.

### ➡️ `"deploy"`
- **Action:** Push code live.
- **Command:** `npm run deploy`

### ➡️ `"deploy:full"`
- **Action:** Push code + database live.
- **Command:** `npm run deploy:full`

### ➡️ `"Push my branding"`  
- **Action:** **Tier 1 — Fast FTP (look and feel only).**
- **Script Command:** `npm run pushitup:admin-branding`

### ➡️ `"Push Website Live"` / `"push it live"`
*Alternative phrasings: `"push site live"`, `"deploy live"`*
- **Action:** Agent **asks first** (clickable) — pick deploy mode before any upload:
  - **Quick DB sync** (~1–2 min) → `npm run msc:push:db:live` → hPanel **Restart** → `msc:verify:live`
  - **Full FTPS** (~45–60 min) → `pushit:live` / `push-website-live.ps1 -Ftps` → Restart → verify (includes **`sync-db`** + **`sync-app`**)
  - **MCP zip** — **avoid on this host** (`better-sqlite3` fails); use FTPS instead
- **Quick DB when:** `/` + `/admin` OK but `/api/globals/*` returns 500 (stub `payload.sqlite` on live).
- **503 when:** `msc:hostinger:npm-install` (webpack) or `msc:hostinger:recover` (preload) → Restart → `verify:live`.

### ➡️ `"Push server config"`  
- **Action:** **Tier 3 — Hosting / Node runtime contract.**
- **Script Command:** `npm run pushitup:server-config`

---

## 🛠️ Environment Recovery & Diagnostics

### ➡️ `"Fix Local"`  
- **Action:** Local dev recovery.
- **Script Command:** `npm run dev:recover`

### ➡️ `"Take a snapshot"`  
- **Action:** Milestone checkpointing.

### ➡️ `"Clean my folders"`  
- **Action:** Consolidate stray media.
- **Script Command:** `npm run msc:media:consolidate`

### ➡️ `"Sync my media"`  
- **Action:** Bulk Media Database sync.
- **Script Command:** `npm run msc:media:sync`

### ➡️ `"Full media refresh"`
- **Action:** Full media house-cleaning.

### ➡️ `"Audit docs"`
- **Purpose:** Keep docs aligned.
- **Command:** `npm run docs`

### ➡️ `"Sync docs"`
- **Purpose:** Command alignment and drift check.
- **Command:** `npm run sync`

### ➡️ `"Lets Verify Live"`  
- **Action:** Remote environment testing.
- **Script Command:** `npm run verify:live`

---

## 🔧 Utility Commands

### ➡️ `"kill port 3000"`  
- **Action:** Kill process on port 3000 manually.
- **Script Command:** `npm run msc:kill-dev-port`

---

*Last Updated: 2026-06-07 (v6.0.0 — MSC-Website-v6 branch cut)*  
<sub>· Powered by the MSC Media Engine</sub>
