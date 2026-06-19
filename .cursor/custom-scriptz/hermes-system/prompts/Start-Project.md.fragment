# Start Project - Cold-Start Ritual

## Trigger
When user says "Start Project", "Begin Project", "Start Session", or "Cold Start"

## Execution Steps (strict order)

### Step 1: Session Stack (LiteLLM + ngrok + Kanban)
Launch the **full session stack** in one command from repo root:

```powershell
npm run msc:session:start
```

This runs, in order:
1. **`scripts/start-hermes-api.ps1`** — LiteLLM (**4000**), ngrok (**4040**), Hermes **Telegram gateway** (hidden; no Windows logon popup)
2. **`scripts/start-kanban-stack.ps1`** — TaskBoardAI (**3001**), Hermes Workspace (**3005**), Hermes Dashboard (**9119**) as **hidden background processes** (no command-window clutter)

**Individual commands** (if you only need part of the stack):
- AI proxy only: `npm run msc:google-api:start-session`
- Kanban only: `npm run kanban`
- Cold restart LiteLLM: `npm run msc:google-api:start`

**Expected:** UAC prompt(s) may appear for LiteLLM (RunAs). **One** minimized Windows Terminal tab titled **LiteLLM** is normal; Kanban services run hidden. Script exits **0** when:
- LiteLLM responds on port **4000** (~30–90s)
- ngrok inspector on **4040** reports an **HTTPS** tunnel URL
- Remote `/v1/models` probe is attempted (200 = verified)
- Kanban ports **3001**, **3005**, **9119** are online or spawned (hidden)

If a service is already running, the launcher **reuses** it (no duplicate ngrok or Kanban instances).

**Does NOT start:** Next.js dev (**3000**) — start with `npm run dev` when you are actively coding the site.

**No voice in this step.** The launcher must never call `jarvis-speak`, `speak`, or any TTS.

### Step 1b: ngrok URL + Cursor connection (after Step 1 exits 0)
Read the active ngrok URL from launcher output, `.cursor/session-google-api.json`, or:
`Invoke-RestMethod http://127.0.0.1:4040/api/tunnels` → first `https://` `public_url`

**Print in chat** (use live URL — do not hardcode):
```
🔗 CURSOR CONNECTION
   Override OpenAI Base URL: https://<ngrok-host>/v1
   OpenAI API Key:           sk-vader-protocol-1234 (or MSC_LITELLM_MASTER_KEY from .env.local)
   Custom model:             vader-3.5-flash
```
Jon sets **Cursor → Settings → Models → Override OpenAI Base URL** to the live ngrok `/v1` URL above. Re-run Step 1 if the tunnel URL changes.

### Step 2: Mandatory Document Reads (Read tool - do not skip)
Read in this order:
1. `README.md` - Project overview
2. `.cursor/docs/START-HERE.md` - Operator contract
3. `.cursor/docs/project-log.md` - Last session status
4. `.cursor/docs/Checkpoint.md` - Current milestone

### Step 3: Environment Check
- Run `node --version`
- Verify `.env.local` exists (warn if missing)
- Check `git status` - report clean or changes

### Step 4: Health Gate (Lightweight)
Run these and report results:
- `npm run lint` (if script exists) or skip
- `npm run build` (quick check only if operator requests)

### Step 5: Session Handshake (print in chat BEFORE voice)
Gather live status, then print the session summary card in chat **immediately** — do not wait for voice.

**Status probes (repo root):**
- LiteLLM: `npm run msc:litellm:status` → `online` or `offline`
- Vertex / models: `npm run msc:litellm:verify --models-only` → use primary model label (prefer `vader-3.5-flash` if listed, else first `vader-*` model); if verify fails but LiteLLM is online, show `Reachable (models unverified)`
- ngrok URL: `Invoke-RestMethod http://127.0.0.1:4040/api/tunnels` (PowerShell) or `npm run msc:litellm:test-ngrok` — extract the `https://` public URL
  - URL found → `Online (https://xxxx.ngrok-free.dev)`
  - ngrok running but URL not available → `Active`
  - ngrok not running → `Not running`
- Kanban stack: probe ports **3001**, **3005**, **9119** (`Get-NetTCPConnection -LocalPort … -State Listen`) or HTTP smoke:
  - `http://127.0.0.1:3001/` → TaskBoardAI
  - `http://127.0.0.1:3005/` → Hermes Workspace
  - `http://127.0.0.1:9119/system` → Hermes Dashboard

**Print this card** (replace `[…]` placeholders with live values; keep dot leaders aligned):

```
-------------------------------------------------------------------------------
✅ SESSION STARTED — [YYYY-MM-DD HH:MM]
-------------------------------------------------------------------------------

📦 SYSTEM STATUS
   🎙️ J.A.R.V.I.S. Voice………. Ryan Neural (Edge TTS)
   🔌 LiteLLM Proxy…………. [Online (port 4000) | Offline]
   ☁️ Google Vertex AI………. [Connected (vader-3.5-flash) | Reachable (models unverified) | Offline]
   🌐 ngrok Tunnel………….. [Online (https://xxxx.ngrok-free.dev/v1) | Active | Not running]
   📱 Hermes Gateway………. [Online (Telegram) | Offline | Not configured]
   📋 Kanban Stack…………. [3001 + 3005 + 9119 online | partial | offline]

🔗 CURSOR
   Base URL……………… [https://xxxx.ngrok-free.dev/v1 | set after Step 1b]
   API Key……………… [sk-vader-protocol-1234 | MSC_LITELLM_MASTER_KEY]
   Model………………… vader-3.5-flash

📁 PROJECT
   🌿 Branch……………… [current branch]
   📦 Node………………… [node --version]
   📝 Docs………………… README, START-HERE, project-log, Checkpoint
   🔧 Git………………… [clean | has changes]

-------------------------------------------------------------------------------
✅ Ready, Jon. Let's begin...
-------------------------------------------------------------------------------
```

**The summary card must appear in chat before Step 7 runs.**

### Step 6: Pre-Voice Verification (required before any TTS)
Confirm **all** of the following before dispatching voice:
- [ ] LiteLLM is online on port 4000 (`npm run msc:litellm:status` reports `online`)
- [ ] ngrok tunnel is online with HTTPS URL (`4040/api/tunnels` or Step 1b Cursor block printed)
- [ ] All mandatory docs were read (README, START-HERE, project-log, Checkpoint)
- [ ] Session summary card (Step 5) is **already printed in chat**

If any check fails, complete the missing step first. **Do not dispatch voice until all three pass.**

### Step 7: J.A.R.V.I.S. Vocal Greeting (LAST — non-blocking, fire-and-forget)
Dispatch the welcome greeting **only after** Step 5 summary is visible in chat and Step 6 passes. Run voice in the **background** so the terminal and chat are not blocked (~10–15s TTS):

```powershell
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File scripts/jarvis-speak.ps1 -Text `"Welcome back Jon, I am JARVIS your personal assistant, all systems are fully functional, let's begin.`"" -WindowStyle Hidden
```

Run from repo root. **Do not await** the process — exit the step immediately after `Start-Process`.

**Expected:** Summary card is already in chat; voice plays a moment later in a hidden background process. Never use blocking `powershell -File scripts/jarvis-speak.ps1` or `npm run msc:jarvis:speak` here — they delay the summary.

## Important Rules
- DO NOT auto-start Next.js dev (`npm run dev` on **3000**) unless operator asks — session start handles AI + Kanban only
- DO NOT auto-deploy or push without confirmation
- DO NOT paste secrets or tokens in chat
- Voice greeting is always **Step 7 only** — never in Step 1 or `start-hermes-api.ps1`; dispatch with `Start-Process -WindowStyle Hidden` (non-blocking) only after the Step 5 summary is in chat
- **Kanban URLs:** http://localhost:3001 · http://localhost:3005 · http://localhost:9119/system
