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

### Step 4: Port Cleanup (if dev server was running)
- Run `npm run msc:kill-dev-port` (or `node scripts/kill-dev-port.mjs` which clears port 3000)
- If LiteLLM was running: `npm run msc:litellm:stop`

### Step 5: Session Handoff Block
Print:
✅ SESSION CLOSEOUT — [YYYY-MM-DD HH:MM]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Branch: [current branch]
📝 Changes logged to project-log.md
🔧 Git: [clean if committed, otherwise note pending]
🛑 Ports cleared: 3000
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Goodbye, Jon. See you next session.

Cold-start pointer: Say "Start Project" to begin next session.

## Important Rules
- NEVER commit without explicit operator approval
- NEVER force push unless operator confirms
- NEVER log secret values - reference only variable names
