# Payload CMS Schema Types Synchronization & Validation Pipeline

This documentation details the automated type-compilation and validation framework designed for `MyStudioChannel` to ensure database type-safety across local development and production build stages.

---

## 1. Overview & Goal
Payload CMS defines database models through TypeScript schemas inside `collections/` and `globals/`. These must be compiled into `payload-types.ts` for Next.js compile safety.

If a developer modifies a schema but forgets to compile or commit the newly updated types, the production deployment will either fail or suffer from type desynchronization.

The **Payload Types Sync Pipeline** completely eliminates this risk by automating:
1. **Interactive File Watching** during development.
2. **Husky Pre-Commit Verification** to auto-compile and auto-stage types on schema modifications.
3. **Build Gates** that fail local or remote `next build` if types are out of sync with schemas.

---

## 2. Implementation Architecture

```
+-------------------------------------------------------------+
|               scripts/payload-types-sync.ps1                |
+--------+---------------------+---------------------+--------+
         |                     |                     |
         v                     v                     v
   [ -Watch ]            [ -PreCommit ]         [ -Validate ]
         |                     |                     |
  FileSystemWatcher      Husky git hooks        npm run build
  re-compiles schema     auto-compiles and     fails compilation
  on change (2s delay)   auto-stages on commit  if types modified
```

---

## 3. Configuration & CLI Reference

All pipelines are driven by the unified controller script `[scripts/payload-types-sync.ps1](scripts/payload-types-sync.ps1)`.

### A. Run interactive schema watcher (Dev Mode)
To auto-generate types on the fly during development, run:
```bash
npm run msc:types:watch
```
This spawns a `System.IO.FileSystemWatcher` on your `collections/`, `globals/`, and `payload.config.ts`. It is throttled to 2 seconds to prevent redundant generation triggers during rapid keyboard strokes.

### B. Verify local schema alignment
To verify if your generated types exactly match your files, run:
```bash
npm run msc:types:validate
```
This re-generates types and compares `payload-types.ts` to your active git index. If differences are detected, it returns exit code `1` and aborts.

### C. Build Gate (Integrated)
We have fully integrated validation into your core Next.js build. Executing:
```bash
npm run build
```
automatically triggers `npm run msc:types:validate` before beginning `next build`. This ensures that out-of-sync types are caught immediately in the build gate.

---

## 4. Husky Git Hook Integration
The pre-commit hook file `[.husky/pre-commit](.husky/pre-commit)` has been reinforced. When you run `git commit`:
1. It runs `npm run lint` first.
2. It executes `powershell -ExecutionPolicy Bypass -File scripts/payload-types-sync.ps1 -PreCommit`.
3. If changes inside `collections/`, `globals/`, or `payload.config.ts` are detected, it compiles the new schemas and **automatically runs `git add payload-types.ts`** to stage the file cleanly before completing the commit.
