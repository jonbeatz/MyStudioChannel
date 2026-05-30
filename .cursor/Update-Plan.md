# Plan: Create Unified Workflow System

We will implement a clean, unified, project-specific workflow system for MyStudioChannel on the `MSC-Website-v2` branch.

## Todos
- [ ] Review current update-docs.md contents <!-- id: review-update-docs -->
- [ ] Create Start-Project.md cold-start prompt runner <!-- id: create-start-project -->
- [ ] Create End-Project.md session closeout prompt runner <!-- id: create-end-project -->
- [ ] Create Update-Project.md auto-sync prompt runner <!-- id: create-update-project -->
- [ ] Create project-log.md session log template <!-- id: create-project-log -->
- [ ] Create Checkpoint.md milestone tracker <!-- id: create-checkpoint -->
- [ ] Rename update-docs.md to Update-Docs.md and scrub Vader-Engine references <!-- id: rename-update-docs -->
- [ ] Create workflow.mdc rule file to coordinate triggers <!-- id: create-workflow-rule -->
- [ ] Run verification tests for Start, Update, and End project flows <!-- id: verify-workflow -->

## Phases & Deliverables

### Phase 1: Review and Prompt Runners Creation
1. Review existing `.cursor/prompts/update-docs.md` to ensure zero disruption.
2. Create `.cursor/prompts/Start-Project.md` with explicit document reads and lightweight preflights.
3. Create `.cursor/prompts/End-Project.md` to automate changes summary, tracking log append, git state audit, and port cleanups.
4. Create `.cursor/prompts/Update-Project.md` to automatically read commit logs/diffs and sync logs.

### Phase 2: Create Tracking Files
1. Create `.cursor/docs/project-log.md` with initial release setup log.
2. Create `.cursor/docs/Checkpoint.md` with current branch, version, and milestone list.

### Phase 3: Rename and Clean Up Update-Docs
1. Rename `.cursor/prompts/update-docs.md` to `.cursor/prompts/Update-Docs.md` (correct casing).
2. Rewrite the file to remove any global references like `msc-new`, `MSC_Clean_v2`, or old spaceship runbooks, replacing them with standard local paths (`MyStudioChannel` and `HOSTINGER-DEPLOY.md`).

### Phase 4: Create Coordination Rule
1. Create `.cursor/rules/workflow.mdc` to bind prompt triggers (`Start Project`, `End Project`, `update docs`, `Update Project` / `Sync Project`) to their respective markdown instructions.

### Phase 5: Verification & Push
1. Perform verification checks on the newly created commands.
2. Commit and push everything to `origin/MSC-Website-v2`.
