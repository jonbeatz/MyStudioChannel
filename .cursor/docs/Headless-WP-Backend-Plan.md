---
name: Headless WP Backend
overview: "Optional future track: connect headless WordPress (LocalWP for dev, Hostinger for production) to additional data flows (booking, signups, WP-driven content). The live MSC app (`MyStudioChannel`) is already a full Next.js + Payload bundle with unified assets under `/media/`; this plan does not replace Payload — it describes how a WP plugin could complement Payload if you choose to wire REST endpoints later."
todos:
  - id: wp-plugin
    content: Build msc-api WordPress plugin with booking-request, booking-availability, and signup endpoints
    status: pending
  - id: wire-booking
    content: Replace mock in lib/booking.ts with real fetch; add fetchBookingAvailability for live slot data
    status: pending
  - id: wire-signup
    content: Create lib/signup.ts and connect the contact form email field to the signup endpoint
    status: pending
  - id: env-files
    content: Create .env.local and .env.example with all MSC API keys and URLs
    status: pending
  - id: test-local
    content: "End-to-end local test: submit booking, verify msc_booking CPT entry in LocalWP admin"
    status: pending
  - id: deploy-plugin
    content: Deploy plugin to live Hostinger WP, update env to production URLs, rebuild and verify
    status: pending
  - id: acf-fields
    content: "Phase 2: Register ACF field groups for Hero, Shows, Testimonials in WP"
    status: pending
  - id: cms-lib
    content: "Phase 2: Write lib/cms.ts fetch functions with hardcoded fallbacks"
    status: pending
  - id: cms-components
    content: "Phase 2: Update hero-section.tsx, demos-section.tsx, testimonials-section.tsx to accept CMS props"
    status: pending
isProject: false
---

# Headless WordPress Backend — optional integration plan

**Phase note (2026):** **`MyStudioChannel` has completed the move** from a static-export style workflow to a **full Next.js + Payload** application. **Booking, leads, hero, and Media** are implemented in Payload with static files in **`public/media`** (**`/media/...`** URLs). The flows below describe a **possible WordPress plugin** layer if you want **WP** to own some endpoints or content **in addition to** Payload — not a replacement for the current bundle.

## Architecture (if you add WP endpoints later)

```mermaid
flowchart LR
    subgraph dev [Local Dev]
        NL[Next + Payload\nlocalhost:3000]
        WL[LocalWP\nlocalhost:PORT/wp-json/msc/v1/...]
        NL -. optional fetch .-> WL
    end
    subgraph prod [Production - Hostinger]
        NS[Next + Payload app\mystudiochannel.com]
        WS[WordPress\nmystudiochannel.com/wp-json/msc/v1/...]
        NS -. optional fetch .-> WS
    end
```

**If implemented:** dynamic data would use browser or server `fetch` to WP where you wire it. **Core MSC** remains **`next build` + `.next` deploy** with **`/media/`** for images — not an **`out/`**-only static tree.

---

## What gets built

| Component | Language / Path | Purpose |
|-----------|-----------------|---------|
| **WordPress API Plugin** | PHP / `wp-content/plugins/msc-api/msc-api.php` | Exposes booking/lead REST endpoints, saves to custom post types (`msc_booking`, `msc_lead`), triggers transactional mail alerts. Protected by `X-MSC-Key`. |
| **Next.js API Library** | TypeScript / `lib/booking.ts` (alt), `lib/signup.ts`, `lib/cms.ts` | Discovers available slots, submits lead and booking data, and server-side fetches ACF options for marketing blocks with local hardcoded fallbacks. |
| **Env variables** | `.env.local` / `.env.production` | Environment endpoint targets for LocalWP and Hostinger production URLs. |

---

## Phased delivery (WordPress track — optional; Payload is Phase-complete for MSC)

**Current MSC (done):** Payload admin, **`/api`**, **`public/media`**, **`npm run media:sync`** — see **START-HERE.md** and **Development.md**.

**WP Phase 1 — booking + signup via WordPress (only if you choose this path)**
1. Build and install the WordPress plugin on LocalWP.
2. Wire `lib/booking.ts` / forms to the WP endpoints **or** keep Payload as source of truth and use WP for parallel experiments (avoid double-writes unless designed).
3. Test locally end-to-end against WP if enabled.
4. Deploy plugin to Hostinger WP, update `.env` to point at live URL, **`npm run build`** + **`pushitup -- .next`** per **Go-Live-Checklist.md**.

**WP Phase 2 — CMS-driven content from WordPress**
5. Register ACF field groups for Hero, Shows, Testimonials (WP side).
6. Write `lib/cms.ts` fetch functions with fallbacks **alongside** Payload-driven content.
7. Update components only where you intentionally dual-source from WP.
8. Rebuild and deploy **`.next`**; confirm WP-fed content appears as expected without breaking **`/media/`** assets served from Next.

---

## Files changed summary

- **New (WordPress):** `wp-content/plugins/msc-api/msc-api.php`
- **Modified:** [`lib/booking.ts`](lib/booking.ts) -- replace mock with real fetch
- **New (Next.js):** `lib/signup.ts`, `lib/cms.ts`
- **New:** `.env.local`, `.env.example`
- **Modified (Phase 2):** `components/hero-section.tsx`, `components/demos-section.tsx`, `components/testimonials-section.tsx`
- **Docs:** `Development.md`, `ReCall.md` updated after each phase
