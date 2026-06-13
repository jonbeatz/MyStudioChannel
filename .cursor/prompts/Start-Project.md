# Start Project - Cold-Start Ritual

## Trigger
When user says "Start Project", "Begin Project", "Start Session", or "Cold Start"

## Execution Steps

### Step 1: Mandatory Document Reads (Read tool - do not skip)
Read in this order:
1. `README.md` - Project overview
2. `.cursor/docs/START-HERE.md` - Operator contract
3. `.cursor/docs/project-log.md` - Last session status
4. `.cursor/docs/Checkpoint.md` - Current milestone

### Step 2: Environment Check
- Run `node --version`
- Verify `.env.local` exists (warn if missing)
- Check `git status` - report clean or changes

### Step 3: Health Gate (Lightweight)
Run these and report results:
- `npm run lint` (if script exists) or skip
- `npm run build` (quick check only if operator requests)

### Step 4: LiteLLM / Vertex AI & J.A.R.V.I.S. Vocal Greeting
Launch the Google API proxy, wait for port 4000 to stabilize, and trigger J.A.R.V.I.S.'s vocal greeting by executing the unified session-start script:
`powershell -ExecutionPolicy Bypass -File scripts/start-hermes-api.ps1`

Wait for the script to finish and J.A.R.V.I.S. to speak before proceeding to the handshake.

### Step 5: Session Handshake
Print the beautiful session summary card in the chat:
✅ SESSION STARTED — [YYYY-MM-DD HH:MM]
📁 Branch: [current branch]
📝 Docs loaded: README, START-HERE, project-log
🔧 Git: [clean/has changes]
🖥️ Node: [version]
🎙️ J.A.R.V.I.S. Status: Active on Port 4000 (Ryan Neural)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Ready, Jon. What shall we build today?

## Important Rules
- DO NOT auto-start dev servers (`npm run dev`) unless operator asks
- DO NOT auto-deploy or push without confirmation
- DO NOT paste secrets or tokens in chat
