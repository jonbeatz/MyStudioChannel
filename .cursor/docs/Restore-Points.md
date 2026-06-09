# Restore points — MyStudioChannel (`MyStudioChannel`)

Human-named checkpoints so you can roll back mentally or on disk if a change goes wrong.

## How to restore

1. **Git (recommended)**  
   If the repo is under version control: tag after each checkpoint, e.g. `git tag restore-2026-04-08-cms-globals`.

2. **No git**  
   Copy the whole **`MyStudioChannel`** folder, or at minimum:
   - `payload.sqlite` (all CMS data: users, media, bookings, globals, leads)
   - `patch/` + `package-lock.json` if you rely on patched deps

3. **Database only**  
   Stop the dev server, copy `payload.sqlite` to a dated backup (e.g. `payload.2026-04-08.bak.sqlite`), restore by swapping the file back.

---

## Checkpoints

| ID | Date | Summary |
|----|------|---------|
| **RP-2026-06-08-v7-live** | 2026-06-08 | **v7.0.0 live + fast-deploy zip fix:** **`pushit:live:fast -- -WithDb`** deployed; zip unzip quoting bug fixed; **`msc:hostinger:deploy-diagnose`** added. Live **`msc:verify:live:version`** **v7.0.0**. **Restore:** `git checkout v7.0.0` or **`MSC-Website-v7`**. |
| **RP-2026-06-08-v7-release** | 2026-06-08 | **v7.0.0 release on `MSC-Website-v7`:** Version **7.0.0** @ **`a295fc4`**; Hostinger MCP launcher; docs sync; GitHub tag **`v7.0.0`**. Cut from frozen `MSC-Website-v6` @ `c9e260e`. Backup **`msc-website-v2-f`**. **Restore:** `git fetch --tags origin && git checkout v7.0.0` or `MSC-Website-v7 && git reset --hard a295fc4`. **Restore v6 clean:** `git checkout MSC-Website-v6 && git reset --hard c9e260e`. |

> **Archive:** Older checkpoints moved to [_archive/Restore-Points-historical.md](_archive/Restore-Points-historical.md) (Phase 4 trim — keeps 3 most recent).

## New restore-point template (copy/paste)

Use this template when adding a checkpoint:

```md
| **RP-YYYY-MM-DD-short-name** | YYYY-MM-DD | **What was working:** short summary. **Branch/commit:** `<branch> @ <sha>`. **Restore steps:** 1) checkout branch/sha 2) run exact startup/deploy commands 3) note any env/dependency caveats. |
```

Suggested naming:

- `RP-2026-04-10-admin-v103-sidebar-version`
- `RP-2026-04-10-deploy-pushit-live-stable`

### Files worth diffing from this checkpoint

- `payload.config.ts`
- `globals/Homepage.ts`, `globals/SiteSettings.ts`, `globals/Header.ts`
- `collections/Leads.ts`, `collections/Media.ts`, `collections/Pages.ts`, `collections/Bookings.ts`
- `components/contact-section.tsx`, `components/hero-section.tsx`
- `lib/cms/*` (incl. **`homepage-gallery-hydrate.ts`**, **`homepage-gallery-seed.ts`**), `lib/booking.ts`, `lib/email-brand.ts`, `lib/email-templates.ts`
- `app/(site)/page.tsx`, `app/(site)/layout.tsx`
- `next.config.mjs` (image `remotePatterns` for localhost)

*(Older docs mentioned `collections/HeroSlides.ts` — that collection was removed; hero rows live on **`globals/Homepage`**, images on **Media**.)*

---

*Append a new row when you create the next restore point.*
