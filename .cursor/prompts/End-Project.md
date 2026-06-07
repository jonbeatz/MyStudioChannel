# End Project - Session Closeout

## Trigger
When user says "End Project", "End Session", "Close Session", or "Session Closeout"

## Execution Steps

### Step 1: Summarize Working Changes
Based on `git status` and `git diff --name-only`, summarize:
- Files modified (group by type: components, docs, config, scripts)
- Files added
- Files deleted

### Step 2: Update Tracking Docs
Append to `.cursor/docs/project-log.md`:
```markdown
### [YYYY-MM-DD HH:MM] - Session Summary
- **Branch:** [current branch]
- **Changes:** [summary from step 1]
- **Status:** [completed / in-progress / blocked]
- **Next:** [what operator plans next session]
```

### Step 3: Git Audit
- Show `git status --porcelain`
- Note any unstaged secrets (`.env.local`, credentials) - do NOT show values
- **Reminder Note for Jon**: Remind Jon to verify or find any missing API keys (e.g., `21ST_DEV_MAGIC_API_KEY`) in `.env.local` to fully unlock pre-wired MCP servers next session.
- Ask: "Commit and push changes? (yes/no)"

### Step 4: Full local shutdown (always — fresh restart next session)
Run unconditionally from repo root (safe when nothing is listening):
- `npm run msc:session:stop`

This clears **Next dev (3000)**, **LiteLLM (4000)**, **ngrok**, and **ngrok inspector (4040)**. Report what each sub-step found (process killed vs already free).

### Step 5: Session Handoff Block
Print:
✅ SESSION CLOSEOUT — [YYYY-MM-DD HH:MM]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Branch: [current branch]
📝 Changes logged to project-log.md
🔧 Git: [clean if committed, otherwise note pending]
🛑 Local services stopped: Next dev (3000), LiteLLM + ngrok (4000, 4040)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Goodbye, Jon. See you next session.

Cold-start pointer: Say "Start Project" to begin next session.

## Important Rules
- NEVER commit without explicit operator approval
- NEVER force push unless operator confirms
- NEVER log secret values - reference only variable names
