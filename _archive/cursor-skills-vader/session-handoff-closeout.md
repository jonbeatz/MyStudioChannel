---
name: session-handoff-closeout
description: >-
  Unified session closeout and checkpoint workflow — snapshots, restore points,
  handoff notes, and explicit commit/deploy consent.
---

# Session Handoff & Closeout (Universal)



## When to use

- Ending a work block — execute the binding prompt **`.cursor/prompts/End-Project.md`** (this skill is the competency sheet; the prompt is the ritual).
- Preparing operator handoff
- Creating a rollback checkpoint after a milestone

## Closeout checklist

1. Summary working tree changes by theme (3–7 bullets).
2. Update **Session-Snapshots** (newest entry at top):
   - branch / commit / clean vs dirty tree
   - localhost or service status
   - what changed and where
   - validation outcomes (build gate, smoke, deploy)
   - exact **start-next** commands and first task
3. Add **Restore-Points** row for milestone-level or incident-recovery wins.
4. Ask for **explicit confirmation** before commit, push, or deploy.
5. Commit and push **only when requested**.

## Restore-point template

```text
| RP-YYYY-MM-DD-short-name | YYYY-MM-DD | What worked. Branch/commit: <ref>. Restore: <commands>. Caveats: <env/deps>. |
```

## Branch-cut mini-flow

1. Confirm intentional tree state.
2. Create branch from current HEAD.
3. Push upstream when requested.
4. Record branch + checkpoint in docs.

## Agent discipline

- Before closeout, run the **Local Script Gate Sequence** when localhost was in scope (Node 2): `msc-kill-dev-port.mjs` → `msc-local-http-smoke.mjs` on port **3000** (or project `MSC_DEV_PORT`).
- Run verification yourself—do not hand off broken localhost without documenting blockers.
- Sign operational summaries with clear next steps, not open-ended suggestions.
