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

### Step 4: LiteLLM / Vertex AI (Optional)
If operator uses `vader-3-flash` in Cursor:
- Ask: "Start Google API proxy? (y/n)"
- If yes: `npm run msc:google-api:start` then `verify google-api`

### Step 5: Session Handshake
Print:
✅ SESSION STARTED — [YYYY-MM-DD HH:MM]
📁 Branch: [current branch]
📝 Docs loaded: README, START-HERE, project-log
🔧 Git: [clean/has changes]
🖥️ Node: [version]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Ready, Jon. What shall we build today?

## Important Rules
- DO NOT auto-start dev servers (`npm run dev`) unless operator asks
- DO NOT auto-deploy or push without confirmation
- DO NOT paste secrets or tokens in chat
