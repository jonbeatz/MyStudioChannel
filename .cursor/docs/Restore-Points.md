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
| **RP-2026-06-08-v7-start** | 2026-06-08 | **Fresh v7 development branch:** Branch `MSC-Website-v7`, version still **6.0.0** until release bump. Cut from `MSC-Website-v6` @ `c9e260e` (Hostinger MCP launcher fix; docs sync). Full backup **`msc-website-v2-f`**. **`MSC-Website-v6`** frozen @ `c9e260e` as clean restore. **Restore v6:** `git fetch origin && git checkout MSC-Website-v6 && git reset --hard c9e260e`. **Restore v7:** `git fetch origin && git checkout MSC-Website-v7 && git pull`. |
| **RP-2026-06-08-pushit-live-fast** | 2026-06-08 | **Tier 2b fast deploy (`pushit:live:fast`):** Zip **`.next`** → single FTPS → SSH unzip + BUILD_ID → **`sync-app`**. Fixed FTPS path (upload **`deploy-next.zip`** at staging root, not **`zips/`**). Live **v6.0.0** healthy; **`msc:verify:live`** pass. **Branch:** `MSC-Website-v6`. **Restore:** `git fetch origin && git checkout MSC-Website-v6 && git pull`. |
| **RP-2026-06-08-live-v6-sync-app** | 2026-06-08 | **Live v6.0.0 healthy + deploy pipeline hardened:** Fixed **503** (`node_modules` / missing Next webpack). Added SSH **`msc:hostinger:sync-app`**, **`msc:hostinger:npm-install`**, **`msc:hostinger:recover`**. **`pushit:live`** mirrors FTPS staging → live app root. Documented two **`nodejs`** folders; prefer FTPS over MCP. Live: Legal dropdown, footer **v6.0.0**, **`msc:verify:live`** pass. **Branch/commit:** `MSC-Website-v6` @ **`b368d3e`**. **Restore:** `git fetch origin && git checkout MSC-Website-v6 && git reset --hard b368d3e && git pull`. |

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
