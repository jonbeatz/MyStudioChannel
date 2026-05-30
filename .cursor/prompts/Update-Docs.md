# Workflow: Update Documentation

When the user says "update docs", execute this workflow:

## Phase 1: Discovery & Audit

1. **Scan all documentation folders:**
   - `.cursor/docs/` - All markdown files
   - `.cursor/rules/` - All .mdc rule files
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
   - Outdated paths (D:\Cursor_Projectz\MSC_Clean_v2\msc-new vs D:\Cursor_Projectz\MyStudioChannel)
   - Old branch names (MSC-Site-Updates-v1 vs MSC-Website-v2)
   - Missing sections or TODOs
   - Contradictory instructions
   - Broken internal links

## Phase 2: Synchronization

4. **Update paths across all docs:**
   - Replace any `msc-new` references with `MyStudioChannel`
   - Update any hardcoded drive paths to relative or current workspace
   - Update branch names to current workflow (`main`, `MSC-Website-v2`)

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

## Phase 5: Reporting

11. **Generate summary report:**
    - Files updated (list)
    - Inconsistencies found and fixed
    - Outstanding issues (if any)
    - Recommended next actions

## Phase 6: Commit

12. **Commit changes:**
    ```bash
    git add .cursor/docs/ .cursor/rules/ .cursor/prompts/ README.md CHANGELOG.md
    git commit -m "docs: update synchronization [YYYY-MM-DD HH:MM]"
    git push origin MSC-Website-v2
    ```

## Output Format

Provide a report showing:
- **Files scanned:** Count and list
- **Changes made:** Before/after for key updates
- **Issues logged:** What was added to ISSUES-RESOLVED.md
- **Remaining TODOs:** Any unresolved items
