# Update Project - Auto-Sync Tracking Docs

## Trigger
When user says "Update Project" or "Sync Project"

## Execution Steps

### Step 1: Detect Recent Changes
Run from repo root:
- `git log --oneline -10`
- `git diff --name-only HEAD~5`
- `git branch --show-current`

### Step 2: Update `project-log.md`
Append checkpoint:
```markdown
### [YYYY-MM-DD HH:MM] - Update Project Checkpoint
- **Status:** [current progress based on recent commits]
- **Branch:** [current branch]
- **Files changed:** [list from git diff]
- **Next:** [inferred next steps]
```

### Step 3: Update `Checkpoint.md`
Update or create `.cursor/docs/Checkpoint.md`:
```markdown
# Project Checkpoint

## Current Status
- **Date:** [YYYY-MM-DD]
- **Branch:** [current branch]
- **Version:** [from package.json]
- **Build Status:** [pass/fail - run npm run build to check]

## Recent Milestones
| Date | Milestone | Commit |
|------|-----------|--------|
| [date] | [description] | [commit hash] |

## Next Milestones
- [ ] [next task 1]
- [ ] [next task 2]
```

### Step 4: Summary Report
Print (replace `[…]` with live values):

```
-------------------------------------------------------------------------------
📊 PROJECT UPDATE — [YYYY-MM-DD HH:MM]
-------------------------------------------------------------------------------

📝 TRACKING
   📋 project-log.md……… checkpoint added
   🏁 Checkpoint.md………. [updated | created]
   📦 Recent commits……… [count from git log]

📁 PROJECT
   🌿 Branch……………… [current branch]

-------------------------------------------------------------------------------
✅ Project tracking updated.
-------------------------------------------------------------------------------
```

## Important Rules
- DO NOT commit changes automatically - just update local files
- DO NOT modify CHANGELOG.md - that's for releases only
- Preserve existing formatting - append only
