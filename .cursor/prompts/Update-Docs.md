# Workflow: Update Documentation

When the user says **"update docs"** or **"update docs and mem0"**, execute the matching path below.

---

## Triggers & Paths

### Path A: `update docs` (default — no Mem0)

**Triggers:** `"update docs"`, `"Update Docs"`, or any docs-sync request **without** `and mem0`.

1. Run **Phases 1–4** (scan, fix, sync physical files)
2. Run **Phase 5** (summary report)
3. **Skip Phase 5b entirely**
4. Run **Phase 6** (report changes, no commit/push)
5. End with: **"Ready to commit. Say 'commit docs' when ready."**

### Path B: `update docs and mem0` (full sync with memory)

**Triggers:** `"update docs and mem0"`, `"update docs + mem0"`, or any docs-sync request that **explicitly includes** `and mem0`.

1. Run **Phases 1–4** (scan, fix, sync physical files)
2. Run **Phase 5** (summary report)
3. Run **Phase 5b** (Mem0 sync with auto LM Studio setup)
4. Run **Phase 6** (report changes, no commit/push)
5. End with: **"Ready to commit. Say 'commit docs' when ready."**

**Rule:** Phase 5b is **optional and separate**. It runs **only** when the user explicitly includes `and mem0` in the command. Default `"update docs"` never touches Mem0.

---

## Phase 1: Discovery & Audit

1. **Scan all documentation folders:**
   - `.cursor/docs/` - All markdown files
   - `.cursor/rules/` - All .mdc rule files
   - `.cursor/prompts/` - Start/End Project and workflow prompts
   - `.cursor/custom-scriptz/` - Portable module READMEs and cheat sheets
   - `README.md` - Root readme
   - `CONTRIBUTING.md` - Contributing guide
   - `CHANGELOG.md` - Version history
   - Any other .md files in root

2. **Identify documentation types:**
   - **Runbooks:** START-HERE.md, Development.md, HOSTINGER-DEPLOY.md
   - **Reference:** Jedi-List.md, GitHub-Cheat-Sheet.md
   - **History:** ReCall.md, Restore-Points.md, CHANGELOG.md, ISSUES-RESOLVED.md
   - **Rules:** All .mdc files in .cursor/rules/
   - **Deployment:** HOSTINGER-DEPLOY.md, Go-Live-Checklist.md

3. **Check for inconsistencies:**
   - Outdated paths (legacy `MSC_Clean_v2` tree vs current `MyStudioChannel` workspace)
   - Old branch names (MSC-Website-v2 vs MSC-Website-v3)
   - Missing sections or TODOs
   - Contradictory instructions
   - Broken internal links

## Phase 2: Synchronization

4. **Update paths across all docs:**
   - Replace legacy short project folder names with `MyStudioChannel`
   - Update any hardcoded drive paths to relative or current workspace
   - Update branch names to current workflow (`main`, `MSC-Website-v9`)

5. **Update version information:**
   - Check `package.json` version
   - Update any version references in docs
   - Update CHANGELOG.md with recent changes

6. **Cross-reference validation:**
   - Ensure all linked files exist
   - Verify all commands in docs work
   - Check that rule files are referenced correctly

## Phase 3: Issue Tracking

7. **Create/Update `.cursor/docs/ISSUES-RESOLVED.md`:**
   ```markdown
   # Issues & Resolutions Log

   ## [YYYY-MM-DD] Issue Title
   - **Error:** What happened
   - **Cause:** Why it happened
   - **Solution:** How it was fixed
   - **Files Changed:** Which files changed
   - **Related Issue:** Link to GitHub issue (if any)
   - **Prevention:** How to avoid recurrence
   ```

8. **Log recent fixes from memory or git log:**
   - Scan `git log --oneline -20` for recent fixes
   - Document significant ones in `ISSUES-RESOLVED.md`

## Phase 4: Consistency Enforcement

9. **Check rule conflicts:**
   - Scan all .mdc files for contradictory rules
   - Flag any rules that conflict with current workflow

10. **Update timestamps:**
    - Add/update "Last Updated" footers
    - Update `Restore-Points.md` with current state

11. **Portable module sync (when live scripts changed):**
    - If `git diff` or session work touched `scripts/` (session stack, LiteLLM, backup, Hostinger) or `.cursor/prompts/Start-Project.md` / `End-Project.md`:
      ```powershell
      npm run msc:portable:sync
      ```
    - Or sync individually: `msc:hermes:module:sync`, `msc:google-api:module:sync`, `msc:backup:module:sync`, `msc:hostinger:module:sync`
    - Report **SYNCED** / **DIFFERS** for key pairs (audit script checks hashes)
    - **Source of truth:** live repo `scripts/` + `.cursor/docs/` → copies into `.cursor/custom-scriptz/*/`

## Phase 5: Reporting

11. **Generate summary report:**
    - Files updated (list)
    - Inconsistencies found and fixed
    - Outstanding issues (if any)
    - Recommended next actions

## Phase 5b: Memory Synchronization (Mem0) — Path B only

> **Do not run this phase** unless the user triggered Path B (`update docs and mem0`).

11b. **LM Studio preflight (VRAM-optimized for Mem0):**
    - Run `npm run msc:mem0:preflight` (loads `qwen3-4b-instruct-2507` with **context 8192**, **parallel 1** — ~3-4 GB VRAM vs ~12 GB at 64k).
    - This runs automatically before every `mem0-chat.ps1` add/search unless `-SkipPreflight` is passed.
    - If `lms` is unavailable or load fails: skip Phase 5b, report a warning, continue to Phase 6.

11c. **Sync major milestones to Mem0:**
    - Identify new system-wide configurations, paths, directory shifts, or major troubleshooting resolutions from this session.
    - Record each as a semantic memory using:
      `powershell -ExecutionPolicy Bypass -File scripts/mem0-chat.ps1 -Action "add" -Text "takeaway here"`
    - Run **sequentially** (one call at a time) to avoid local Qdrant folder locking conflicts.
    - Report how many memories were added and any Mem0 warnings.

11d. **Confirm Mem0 status in output:**
    - **Mem0 Status:** ✅ Memories synced *(or ⚠️ Skipped - LM Studio unavailable)*

## Phase 6: Prepare Changes (No Auto-Commit)

12. **Report all changes found and made**
13. **Do NOT commit or push automatically**
14. **State:** "Ready to commit. Say 'commit docs' when ready."

---

## Output Format

Provide a report showing:
- **Path used:** Path A (docs only) or Path B (docs + mem0)
- **Files scanned:** Count and list
- **Changes made:** Before/after for key updates
- **Issues logged:** What was added to ISSUES-RESOLVED.md
- **Mem0 sync:** Skipped / completed / failed (Path B only) — include line: **Mem0 Status:** ✅ Memories synced *(or ⚠️ Skipped - LM Studio unavailable)*
- **Portable sync:** Files synced via `msc:portable:sync` (or skipped if no script changes)
- **Remaining TODOs:** Any unresolved items
