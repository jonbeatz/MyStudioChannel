# Prompt & Custom Commands Cheat Sheet

This is your ongoing reference guide for all custom developer prompts, workflows, and session commands configured for the **MyStudioChannel** project. 

Whenever you create or adapt workflows, update this cheat sheet so you always have an accurate, ready-to-use list.

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
  4. Cleans up ports (kills dev server on `3000` and LiteLLM on `4000`).
  5. Outputs goodbye handshake.
- **Handoff Response Format:**
  ```text
  ✅ SESSION CLOSEOUT — [YYYY-MM-DD HH:MM]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📁 Branch: [current branch]
  📝 Changes logged to project-log.md
  🔧 Git: [clean if committed, otherwise note pending]
  🛑 Ports cleared: 3000, 4000
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
- **Action:** Interactive/Non-interactive standard & full backups.
- **Module File:** `.cursor/custom-scriptz/backup-system/CURSOR.md`
- **Expected Behavior:** 
  1. Guides you through Type, Destination, Folder, and custom note steps.
  2. Packages files and exports them safely to `G:\Cursor_Project_BackUpz\MyStudioChannel`.

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
- **Expected Outcome:** Tests endpoint connections and lists the active tunnel URLs for Cursor.

### ➡️ `"stop google-api"`  
- **Action:** Stop active proxy instance.
- **Script Command:** `npm run msc:litellm:stop`
- **Expected Outcome:** Safely terminates the Python LiteLLM proxy process on port `4000`.

---

## 📦 Hostinger Deployment (Tiered FTPS)

Commands for deploying code changes to Hostinger from your PC terminal. Never run these from a host terminal.

### ➡️ `"Push my branding"`  
- **Action:** **Tier 1 — Fast FTP (look and feel only).**
- **Script Command:** `npm run pushitup:admin-branding`
- **Scope:** Uploads ONLY SCSS and custom admin UI code (`components/msc-payload-graphics.tsx`, `components/msc-payload-admin-enhancements.tsx`, `collections/Users.ts`, `payload.config.ts`, `app/(payload)/custom.scss`). No production build required. Fast-restart of Node app inside hPanel is required.

### ➡️ `"Lets Push It Live"`  
*Alternative phrasings: `"Lets Push It Live (Safe)"` (runs verify:local first)*
- **Action:** **Tier 2 — Full build + DB + media ship ("zero footprint" sync).**
- **Script Command:** `npm run pushit:live` (or prefix with `PUSHIT_LIVE_RUN_DEV_FRESH=1` to auto-restart local dev on completion)
- **Required Host Prep:** **hPanel -> STOP APP first**. Then host terminal:
  ```bash
  rm -rf .next                                 # Prevent webpack-runtime module collision 500s
  rm -f payload.sqlite-wal payload.sqlite-shm  # Delete stale WAL replays to prevent data regression
  ```
- **Execution Scope:** Builds production bundle (with live URL injection) -> uploads `.next/`, `payload.sqlite`, and `public/media/` via FTPS.
- **Required Post-Upload Step:** restart Node.js app in hPanel. Validate `/` and `/admin` in Incognito mode.

### ➡️ `"Push server config"`  
- **Action:** **Tier 3 — Hosting / Node runtime contract.**
- **Script Command:** `npm run pushitup:server-config`
- **Scope:** Uploads `server.js`, `package.json`, `package-lock.json`, and `.env.example`.
- **Required Host Action:** run `npm install --legacy-peer-deps` in Hostinger Terminal, then restart the Node app in hPanel.

### ➡️ `"Lets test FTP"`  
- **Action:** Read-Only FTP connection smoke test.
- **Script Command:** `npm run test:hostinger-ftp`
- **Scope:** Runs a quick READ-ONLY LIST of the remote directory to check FTPS logins and paths.

### ➡️ `"Pre-deploy risk check for current changes"`
- **Purpose:** Post-development safety gate.
- **Action:** Examines active Git diff, lists specific deployment risks, and highlights exact mitigation steps before push.

---

## 🛠️ Environment Recovery & Diagnostics

Troubleshooting and maintenance triggers when things break.

### ➡️ `"Fix Local"`  
- **Action:** Local dev recovery.
- **Script Command:** `npm run dev:recover`
- **Expected Outcome:** Kills stale node listeners, clears Next.js caches, restarts dev server on port `3000`, and probes local URLs to ensure 200 OK.
- **Verification Rule:** Probes `http://localhost:3000/` and `/admin` (fallback to `http://127.0.0.1:3000` if localhost DNS is slow) and reports both HTTP status codes.

### ➡️ `"Take a snapshot"`  
- **Action:** Milestone checkpointing.
- **Expected Outcome:** Updates local documentation files, summarizes progress, commits, and creates a recovery branch for rollback safety.

### ➡️ `"Clean my folders"`  
- **Action:** Consolidate stray media.
- **Script Command:** `npm run media:consolidate`
- **Expected Outcome:** Moves files outside `public/media/` back into their correct structured folders.

### ➡️ `"Sync my media"`  
- **Action:** Bulk Media Database sync.
- **Script Command:** `npm run media:sync`
- **Expected Outcome:** Scans `public/media/` and automatically registers physical files as database rows in Payload CMS, bypassing Alt text constraints.

### ➡️ `"Full media refresh"`
- **Action:** Full media house-cleaning.
- **Steps:** Runs `Clean my folders` followed by `Sync my media`. Verifies all UI components use `/media/` paths.

### ➡️ `"Audit docs for contradictions and tighten source-of-truth"`
- **Purpose:** Keep docs aligned.
- **Action:** Scans rules, custom scripts, prompts, and docs for contradictory files and flags duplicates.

### ➡️ `"Create a restore point for this milestone"`
- **Purpose:** Local git rollbacks.
- **Action:** Appends a clean entry to `Restore-Points.md` with branch/SHA, what works, and exact rollback commands.

### ➡️ `"Audit my skills, rules, and runbook for drift"`
- **Purpose:** Structural compliance.
- **Action:** Reviews `.cursorrules`, skill files, and runbook prompts for drift, outdated paths, or old project naming references.

### ➡️ `"Sync docs to scripts (no guessing)"`
- **Purpose:** Command alignment.
- **Action:** Cross-checks doc phrasings against active script commands in `package.json` to fix broken mappings.

### ➡️ `"Lets Verify Live"`  
*Alternative phrasings: `"Lets test Live"`*
- **Action:** Remote environment testing.
- **Script Command:** `npm run verify:live` (or run verify:live and show pass/fail only)
- **Expected Outcome:** Performs quick HTTP smoke queries against live URL endpoints and provides a concise post-deploy validation status.

---

## 🔧 Utility Commands

Commands to manually free processes and manage port bindings.

### ➡️ `"kill port 3000"`  
*Alternative phrasings: `"kill-port"`, `"free port"`*
- **Action:** Kill process on a specific port manually.
- **Script Command:** `node scripts/kill-dev-port.mjs`
- **Expected Outcome:** Forcefully terminates any stale Node.js process bound to port `3000` to prevent `EADDRINUSE` errors.

### ➡️ `"Lets run system check"`
- **Action:** Full health assessment.
- **Scope:** Runs local preflight + live test + FTP connectivity + git status to print one consolidated readiness check.

---

*Last Updated: 2026-05-30*  
<sub>· Powered by the MSC Media Engine</sub>
