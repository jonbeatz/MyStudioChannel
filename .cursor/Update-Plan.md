# Plan: Update Docs and Aligned Versioning

This plan executes Phase 2 and 3 of our workflow system to align all project documents and rules to Hostinger (MyStudioChannel) and branch MSC-Website-v2.

## Todos
- [x] Replace all occurrences of `Spaceship.md` with `HOSTINGER-DEPLOY.md` in `.cursor/docs/Agent-Runbook.md` and `.cursor/docs/Run-Next-JS.md` <!-- id: replace-spaceship-refs -->
- [x] Replace occurrences of `msc-new` with `MyStudioChannel` inside Site-Plans.md, ReCall.md, GitHub-Cheat-Sheet.md, Restore-Points.md, Jedi-List.md, and payload-blocks-first.mdc <!-- id: replace-msc-new-refs -->
- [x] Append the latest milestone (`RP-2026-05-30-unified-workflow-setup`, branch `MSC-Website-v2`, version `v2.0.0`) to `.cursor/docs/Restore-Points.md` <!-- id: append-restore-point -->
- [x] Present change summaries to Jon and ask for explicit confirmation before staging or committing any files <!-- id: prompt-commit-confirmation -->

## Execution Details
All edits will be made using case-sensitive exact string replacements using `StrReplace`. No commits or pushes will be executed without Jon's direct confirmation.
