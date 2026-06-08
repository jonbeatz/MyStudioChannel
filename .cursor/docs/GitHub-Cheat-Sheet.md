# Git quick reference (Jon / MyStudioChannel)

**Local (Cursor / PC repo root)** — run from `D:\Cursor_Projectz\MyStudioChannel` unless noted.

Full detail on backups: **`.cursor/GitHub-Repo-BackUps/BACKUP-REPORT.md`** (regenerated each run).

---

## Every session — check where you are

```bash
git branch --show-current
git status -sb
git log -5 --oneline
```

---

## Daily save (feature branch)

```bash
git status
git diff
git add path/to/file    # or: git add .
git commit -m "fix: short description of why"
git push -u origin HEAD   # first push on new branch
git push                  # after upstream is set
```

**Current workflow branch:** `MSC-Website-v6` (active dev) | `main` (sync with v6 on push) | `MSC-Website-v5` (frozen at v5.0.0).

```bash
git push origin MSC-Website-v6
```

---

## Start new work on a branch

```bash
git fetch origin
git checkout main
git pull origin main
git checkout -b feature/my-task-name
```

Or branch from current work:

```bash
git checkout -b MSC-Website-v6
```

---

## Switch branches

```bash
git checkout branch-name
git switch branch-name          # same idea (newer syntax)
```

Stash first if you have uncommitted changes:

```bash
git stash push -m "wip before switch"
git checkout other-branch
git stash pop
```

---

## See changes

```bash
git status
git diff                        # unstaged
git diff --staged               # staged
git log --oneline --graph -15
git show HEAD                   # last commit
```

---

## Pull latest (before you push)

```bash
git fetch origin
git pull origin branch-name
```

---

## Undo / fix (common)

| Goal | Command |
|------|---------|
| Unstage a file | `git restore --staged filename` |
| Discard edits to one file | `git restore filename` |
| Undo last commit, keep files | `git reset --soft HEAD~1` |
| Recover a “lost” commit | `git reflog` then `git checkout -b rescue-branch <hash>` |

Avoid `git reset --hard` and `git push --force` on shared branches unless you mean it.

---

## Merge main into your branch

```bash
git checkout MSC-Website-v6
git fetch origin
git merge origin/main
# fix conflicts if any, then:
git push
```

---

## GitHub CLI (when MCP or browser is slow)

```bash
gh auth status
gh repo list jonbeatz --limit 20
gh pr list
gh pr create --title "Title" --body "Summary"
```

---

## Releases & tags (MyStudioChannel)

**Latest release:** [v6.0.0](https://github.com/jonbeatz/MyStudioChannel/releases/latest) · **All tags:** [tags](https://github.com/jonbeatz/MyStudioChannel/tags)

| Tag | Branch-cut commit | Notes |
|-----|-------------------|-------|
| `v6.0.0` | `17b3da8` | MSC-Website-v6 — **Latest** |
| `v5.0.0` | `d14a4b2` | MSC-Website-v5 production hardening (frozen at v5.0.0) |
| `v4.0.0` | `87ec9de` | MSC-Website-v4 live on Hostinger (frozen at v4.0.0) |
| `v3.0.0` | `a9ad698` | Deep audit & consolidation |
| `v2.0.0` | `f6058ab` | Hostinger migration |
| `v1.0.0` | `9b4a16e` | Initial release |

```bash
gh release list --limit 10
gh release view v6.0.0
git fetch --tags
git checkout v6.0.0    # read-only snapshot
```

**Cut a new release** (after version bump on `MSC-Website-v6`):

```bash
git tag -a vX.Y.Z <commit> -m "MyStudioChannel vX.Y.Z"
git push origin vX.Y.Z
gh release create vX.Y.Z --title "MyStudioChannel vX.Y.Z" --latest --notes-file CHANGELOG-snippet.md
gh release edit vX.Y.Z --latest   # if a newer draft release stole Latest
```

---

## MyStudioChannel repo helpers (not plain git)

```bash
npm run msc:test:github-api      # token OK?
npm run msc:sync:mcp-env         # .env.local → Cursor MCP
npm run msc:backup:github-repos  # clone + .bundle → .cursor/GitHub-Repo-BackUps/
```

Output: **`GitHub-Bundle-Archive\*.bundle`**, **`GitHub-Development-Archive\<repo>\`**, and **`BACKUP-REPORT.md`**. Recovery: section below.

---

## Recover from GitHub backups (bundles & archives)

**Local only** — backups live under:

```text
D:\Cursor_Projectz\MyStudioChannel\.cursor\GitHub-Repo-BackUps\
```

| What | Typical path | Best for |
|------|----------------|----------|
| **Bundle files** (single file, all branches/tags) | `GitHub-Bundle-Archive\<repo-name>.bundle` | Disaster recovery, copy to another PC, repo deleted on GitHub |
| **Working clones** (full folder) | `GitHub-Development-Archive\<repo-name>\` | Quick open, diff, branch checkout without re-downloading |
| **Legacy layout** (older runs of `msc:backup:github-repos`) | `GitHub-Repo-BackUps\<repo-name>\` + `<repo-name>.bundle` at folder root | Same as above — check both locations |

Regenerate everything from GitHub:

```bash
npm run msc:backup:github-repos
```

Requires **`GITHUB_PERSONAL_ACCESS_TOKEN`** in **`.env.local`**. Writes **`BACKUP-REPORT.md`** with per-repo status.

---

### Option A — Restore from a `.bundle` file (recommended)

A bundle is a portable copy of **all branches and tags** at backup time.

**1. Verify the bundle (optional but smart)**

```powershell
cd D:\Cursor_Projectz\MyStudioChannel\.cursor\GitHub-Repo-BackUps\GitHub-Bundle-Archive
git bundle verify MyStudioChannel.bundle
git bundle list-heads MyStudioChannel.bundle
```

**2. Clone from the bundle into a new folder**

Pick a restore location **outside** the backup folder (e.g. `D:\Cursor_Projectz\RESTORED\`):

```powershell
mkdir D:\Cursor_Projectz\RESTORED -Force
cd D:\Cursor_Projectz\RESTORED

git clone "D:\Cursor_Projectz\MyStudioChannel\.cursor\GitHub-Repo-BackUps\GitHub-Bundle-Archive\MyStudioChannel.bundle" MyStudioChannel-RESTORED
cd MyStudioChannel-RESTORED
git branch -a
git log --oneline -5
```

Replace `MyStudioChannel.bundle` / `MyStudioChannel-RESTORED` with the repo you need (e.g. `MSC-CRM.bundle`, `NovaMira-v1-local-wp.bundle`).

**3. Re-attach GitHub remote (so you can push/pull again)**

```powershell
git remote -v
# If origin is missing or points at the bundle file:
git remote remove origin
git remote add origin https://github.com/jonbeatz/REPO-NAME.git
git fetch origin
```

**4. Push restored history back to GitHub** (only if the remote repo was wiped or you created a new empty repo)

```powershell
git push -u origin --all
git push origin --tags
```

Use **`--force`** only if you intentionally overwrite remote history (dangerous on shared repos).

---

### Option B — Use an existing archive clone (no bundle step)

If **`GitHub-Development-Archive\MSC-CRM\`** (or a flat **`GitHub-Repo-BackUps\MSC-CRM\`**) already exists:

```powershell
cd "D:\Cursor_Projectz\MyStudioChannel\.cursor\GitHub-Repo-BackUps\GitHub-Development-Archive\MSC-CRM"
git status
git branch -a
git fetch origin
git log --oneline -5
```

**Copy to a working folder** (leave the archive read-only):

```powershell
xcopy /E /I /H "...\GitHub-Development-Archive\MSC-CRM" "D:\Cursor_Projectz\MSC-CRM-working"
cd D:\Cursor_Projectz\MSC-CRM-working
git remote -v
git fetch origin
```

Or **open the archive folder directly in Cursor** for read-only inspection — do not run destructive git commands there if you want to keep it as a snapshot.

**Refresh an archive clone from GitHub:**

```powershell
cd "...\GitHub-Development-Archive\MSC-CRM"
git fetch --all --prune --tags
git pull origin main
```

Then re-run **`npm run msc:backup:github-repos`** to refresh the matching **`.bundle`**.

---

### Option C — Recover one branch or old commit from a backup

From a restored clone or archive folder:

```powershell
git branch -a
git checkout branch-name
# or inspect history:
git log --oneline --graph -20
git checkout -b rescue-from-backup <commit-hash>
```

Copy specific files without switching branches:

```powershell
git show branch-name:path/to/file.tsx > recovered-file.tsx
```

---

### Which backup should I use?

| Situation | Use |
|-----------|-----|
| GitHub repo deleted or account issue | **`.bundle`** → clone to new folder → push to new remote |
| “I deleted my local copy but GitHub is fine” | `git clone https://github.com/jonbeatz/REPO.git` (no backup needed) |
| “What did this repo look like on backup day?” | **`.bundle`** or **Development-Archive** clone at backup date |
| Move repo to another PC without GitHub | Copy **`.bundle`** file only, then `git clone repo.bundle` on the other machine |
| Not sure backup is good | `git bundle verify` + `git bundle list-heads` |

---

### Bundles in this project (examples)

Check **`GitHub-Bundle-Archive\`** for files like:

- `MyStudioChannel.bundle`
- `MSC-CRM.bundle`
- `MSC-Projectz.bundle`
- `NovaMira-v1-local-wp.bundle`
- `Node-Launcher.bundle`
- … (one `.bundle` per backed-up repo)

See **`BACKUP-REPORT.md`** after **`npm run msc:backup:github-repos`** for the full list, sizes, and any errors.

---

- **Never commit:** `.env.local`, real API keys, `~/.cursor/mcp.json` secrets
- **Commit template:** `.env.example`, `.cursor/mcp.json` (placeholders only)
- **After env change:** `npm run msc:sync:mcp-env` → reload MCP in Cursor
- **Checkpoint before risky work:** commit + push, or new branch
