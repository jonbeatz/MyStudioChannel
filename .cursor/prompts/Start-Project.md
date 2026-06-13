# Start Project - Cold-Start Ritual

## Trigger
When user says "Start Project", "Begin Project", "Start Session", or "Cold Start"

## Execution Steps (strict order)

### Step 1: LiteLLM / Vertex AI Proxy
Launch LiteLLM automatically in a **minimized, elevated Windows Terminal** tab and wait for port 4000:
`powershell -ExecutionPolicy Bypass -File scripts/start-hermes-api.ps1`

Or: `npm run msc:google-api:start-session`

**Expected:** UAC prompt may appear (RunAs). A LiteLLM tab opens in Windows Terminal (ANSI colors; may pop up briefly — minimize manually on taskbar if needed). Script exits 0 when port 4000 is online (~30–90s). If port 4000 is already up, launcher skips relaunch.

**No voice in this step.** The launcher only starts LiteLLM — it must never call `jarvis-speak`, `speak`, or any TTS.

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

**Print this card** (replace `[…]` placeholders with live values; keep dot leaders aligned):

```
-------------------------------------------------------------------------------
✅ SESSION STARTED — [YYYY-MM-DD HH:MM]
-------------------------------------------------------------------------------

📦 SYSTEM STATUS
   🎙️ J.A.R.V.I.S. Voice………. Ryan Neural (Edge TTS)
   🔌 LiteLLM Proxy…………. [Online (port 4000) | Offline]
   ☁️ Google Vertex AI………. [Connected (vader-3.5-flash) | Reachable (models unverified) | Offline]
   🌐 ngrok Tunnel………….. [Online (https://xxxx.ngrok-free.dev) | Active | Not running]

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
- DO NOT auto-start dev servers (`npm run dev`) unless operator asks
- DO NOT auto-deploy or push without confirmation
- DO NOT paste secrets or tokens in chat
- Voice greeting is always **Step 7 only** — never in Step 1 or `start-hermes-api.ps1`; dispatch with `Start-Process -WindowStyle Hidden` (non-blocking) only after the Step 5 summary is in chat
