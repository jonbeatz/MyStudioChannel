# Workflow: MSC Branch Cut + Version Bump

When the user says **"branch cut"**, **"cut MSC-Website-vN"**, **"cut new development branch"**, or **"Lets Cut New Branch"** (full ritual — not a bare `git checkout -b`):

**Read first:** `.cursor/skills/Workflow-Portable/Checkpoint-Restore/SKILL.md` → *MSC branch-cut ritual*

---

## Triggers

| Say this | Action |
|----------|--------|
| **"branch cut"**, **"cut development branch"** | Full ritual below; infer next version from current branch (e.g. v10 active → cut **v11**) |
| **"Cut MSC-Website-v11"** (explicit N) | Full ritual for that branch name |
| **"Lets Cut New Branch"** | Same full ritual (replaces bare branch-only helper) |

**Do not** stop after `git checkout -b` alone — that leaves GitHub Releases, README table, and TRUTH out of sync.

---

## Phase 0: Preflight

1. **Local (Cursor / repo root):** `git status -sb` — working tree must be clean or user-approved commit first.
2. **Record freeze line:** Note current active branch + short SHA (e.g. `MSC-Website-v10` @ `e71d39e` → will freeze).
3. **Backup (recommended):** `npm run msc:backup:quick` — report folder under `G:\Cursor_Project_BackUpz\MyStudioChannel\`.
4. **Parse target:** Branch `MSC-Website-v{N}` → version **`N.0.0`** → tag **`vN.0.0`**.

---

## Phase 1: Create branch

**Local:**

```powershell
git fetch origin
git checkout MSC-Website-v{prev}    # current active line, clean HEAD
git pull
git checkout -b MSC-Website-v{N}
```

Confirm: `git branch --show-current` → `MSC-Website-v{N}`.

---

## Phase 2: Governance (before or alongside bump)

Edit (do **not** skip):

| File | Update |
|------|--------|
| **`TRUTH.md`** | **Primary Branch** — new active; previous branch **frozen @ `<short-sha>`** |
| **`.cursor/docs/Restore-Points.md`** | New row **`RP-YYYY-MM-DD-vN-start`** with restore commands for frozen + active lines |
| **`.github/workflows/verify.yml`** | Add **`MSC-Website-v{N}`** to `push.branches` (keep previous branch entries for CI) |

These may land in a **second commit** after the bump — `version-bump.ps1` only auto-commits `package.json`, `README.md`, `CHANGELOG.md`, `.cursor/docs/` files it touches.

---

## Phase 3: Version bump + GitHub Release

**Local:**

```powershell
powershell -ExecutionPolicy Bypass -File scripts/version-bump.ps1 -Force -BranchName MSC-Website-v{N}
```

This script **must**:

- Bump **`package.json`** → **`N.0.0`**
- Update README **badge** and **Current Status table** row
- Run **types validate + lint + build**
- Commit **`chore: bump version to N.0.0`**
- Push branch + tag **`vN.0.0`**
- Publish **GitHub Release** with **`--latest`** (sidebar “Latest” — tag alone is not enough)

Use **`-SkipRelease`** only when intentionally tag-only (rare).

---

## Phase 4: Post-bump verification

1. **Checkpoint audit:** Open `.cursor/docs/Checkpoint.md` — milestone **history** must still name correct frozen branches (v6–v9 rows must **not** all say v10). Fix if corrupted.
2. **Governance commit** (if TRUTH / `verify.yml` still unstaged):

   ```powershell
   git add TRUTH.md .github/workflows/verify.yml .cursor/docs/Checkpoint.md
   git commit -m "chore: v{N} branch governance — TRUTH, CI verify, Checkpoint"
   git push origin MSC-Website-v{N}
   ```

3. **Docs gate:**

   ```powershell
   npm run msc:docs:sync
   ```

   Must exit **0** — auditor errors if README Current Status table ≠ `package.json`.

4. **GitHub check (report to user):**
   - [Releases](https://github.com/jonbeatz/MyStudioChannel/releases) → **vN.0.0** shows **Latest**
   - [README](https://github.com/jonbeatz/MyStudioChannel) → Current Status **vN.0.0**

5. **Optional:** **"update docs and mem0"** (Path B) — Mem0 memories for branch cut + restore SHAs.

---

## Phase 5: Closeout report

Print:

```
MSC-Website-v{N} branch cut complete
  Active:  MSC-Website-v{N} @ <sha>
  Frozen:  MSC-Website-v{prev} @ <freeze-sha>
  Version: N.0.0  |  Tag: vN.0.0  |  GitHub Latest: vN.0.0
  Live:    mystudiochannel.com still vX until pushit:live deploy
  Restore frozen: git fetch origin && git checkout MSC-Website-v{prev} && git reset --hard <freeze-sha>
```

---

## Pitfalls (ISSUES-RESOLVED 2026-06-19)

| Symptom | Cause | Fix |
|---------|-------|-----|
| Tags show v10 but Releases sidebar still v9 | Tag pushed without `gh release create --latest` | Run `npm run github:release` or re-run bump without `-SkipRelease` |
| README badge v10, table still v9 | Old bump script skipped table row | Fixed in `version-bump.ps1`; run `npm run msc:docs:sync` |
| Checkpoint milestones all same branch | Global `MSC-Website-v\d+` replace | Use scoped Checkpoint edits; audit after bump |
| `msc:docs:sync` said PERFECT but README wrong | Auditor did not check table | Fixed in `msc-audit-docs.mjs` |

---

## Related commands

| Command | Purpose |
|---------|---------|
| `npm run version:bump` | Interactive bump on current branch |
| `npm run github:release` | Publish release for current `package.json` tag |
| `npm run msc:backup:quick` | Pre-cut backup |
| `npm run sync` | Docs integrity audit |

**Skill:** `.cursor/skills/Workflow-Portable/Checkpoint-Restore/SKILL.md`
