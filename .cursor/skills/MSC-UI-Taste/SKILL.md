---
name: msc-ui-taste
description: >-
  Authoritative UI taste layer for MyStudioChannel: merges taste-skill anti-slop
  dials, impeccable audit/polish workflow, and emilkowalski motion philosophy
  under NovaMira Gold Standard. Use for greenfield UI, polish passes, and
  rejecting generic AI layouts.
---

# MSC-UI-Taste — Anti-Slop + Polish Authority

**Canonical stack order** (when skills conflict, higher wins for MSC):

1. **TRUTH.md** + project security rules
2. **NovaMira-Design** — tokens, glass, bento, Gold `#F5B841`
3. **This skill** — taste dials, banned patterns, review workflow
4. **Premium-UI** — component registries and MCP builders
5. **DesignMD** — extracted brand systems (required before greenfield UI)

Cross-links: [NovaMira-Design](../NovaMira-Design/SKILL.md) · [Premium-UI](../Premium-UI/SKILL.md) · [DesignMD](../DesignMD/SKILL.md)

---

## 0. Greenfield gate (mandatory)

Before designing **new** marketing or dashboard surfaces:

1. Check `.cursor/DesignMD/DESIGN-*.md` for an existing extraction
2. If none: run DesignMD (`npm run dmd <url>`) or `getdesign add <brand>`
3. Read **NovaMira-Design** for MSC Gold, 8px rhythm, 16:9 grids
4. Apply taste dials below — never ship first-draft AI layout

---

## 1. Taste dials (from taste-skill)

Tune three axes explicitly; default MSC profile in **bold**:

| Dial | Low | MSC default | High |
|------|-----|-------------|------|
| **Variance** | Safe, minimal | **Restrained** — one signature moment per view | Experimental, asymmetric |
| **Motion** | Static | **Feedback-only** — hover, success, loading | Choreographed scroll scenes |
| **Density** | Airy marketing | **Bento-balanced** — modular tiles, 8px gutters | Dashboard-dense |

**Agent rule:** State which dial you are adjusting when proposing UI changes.

---

## 2. Banned patterns (anti-slop)

Reject and rewrite if any appear:

| Pattern | Why banned | MSC alternative |
|---------|------------|-----------------|
| Purple/indigo gradient heroes | Generic AI slop | Dark charcoal canvas + **Studio Gold** accent |
| Inter-only + centered everything | Cookie-cutter SaaS | Project fonts from `globals.css`; asymmetric bento |
| Giant gradient CTA + stock illustration | Low craft | Real MSC media `/media/`, gold CTA, glass panel |
| Identical card grid (3 equal columns) | No hierarchy | Bento unequal cells per NovaMira-Design |
| Neon glow on every element | Visual noise | Gold glow on **one** primary CTA max |
| `framer-motion` import (legacy) | React 19 path | `motion/react` per Premium-UI |
| Decorative motion on layout | Accessibility + perf | `prefers-reduced-motion`; motion for feedback only |
| Invented brand colors | Drift | Tokens from DesignMD or NovaMira Gold |

---

## 3. Impeccable workflow (audit → polish → critique)

Use this sequence for UI tasks (not for deploy or Hostinger ops):

### Audit (`/audit` mindset)

- Screenshot or describe current section
- List violations of banned patterns + NovaMira checklist
- Score: **Ship / Polish / Rebuild**

### Polish (`/polish` mindset)

- Fix spacing to 8px rhythm
- Borders over muddy shadows
- One accent color (Gold) with scarcity
- Touch targets ≥ 44px; `:focus-visible` outlines

### Critique (`/critique` mindset)

- One paragraph: what still feels generic?
- Propose **one** signature improvement (not ten tweaks)

Optional harsh pass: `.cursor/prompts/harsh-review.md` (Gilfoyle) — **code review only**, never deploy.

---

## 4. Motion philosophy (from emilkowalski/skill)

- **Purpose:** motion explains state change (open, submit, error), not decoration
- **Duration:** 150–300ms UI; 400–600ms hero entrances max
- **Easing:** ease-out for enter; ease-in for exit; avoid linear on large elements
- **Micro-interactions:** button press scale `0.98`, card hover `scale(1.02–1.03)` with `transition: 0.2s ease-in-out`
- **Scroll:** prefer Lenis only when scroll-linked animation is required (Premium-UI)
- **CSS-first:** prefer transforms/opacity over layout-thrashing properties
- **Reduced motion:** disable scale/blur when `prefers-reduced-motion: reduce`

---

## 5. NovaMira tokens (always win)

| Token | Value | Use |
|-------|-------|-----|
| Studio Gold | `#F5B841` | Primary MSC accent — CTAs, badges, glow |
| Nova Red | `#c01a1a` | DiviGear filters, destructive only |
| Surface stack | `--nm-surface-*` | Layered neutrals, not flat `#000` everywhere |
| Rhythm | 8px multiples | Gaps, padding, icon grid |
| Thumbnails | 16:9 | Show/project grids |

Read full spec: [NovaMira-Design](../NovaMira-Design/SKILL.md)

---

## 6. Agent checklist (before marking UI done)

- [ ] DesignMD or NovaMira tokens cited (not invented hexes)
- [ ] No banned slop patterns
- [ ] Gold accent used sparingly (≤ 2 prominent uses per viewport)
- [ ] `motion/react` if animating (not `framer-motion`)
- [ ] `prefers-reduced-motion` respected
- [ ] Images: meaningful `alt`, lazy below fold
- [ ] `npm run verify:next` or `verify:next:safe` if runtime files changed

---

## Sources (merged, not duplicated)

| Upstream | Contribution |
|----------|----------------|
| [taste-skill](https://github.com/Leonxlnx/taste-skill) | Variance/motion/density dials, anti-slop |
| [impeccable](https://github.com/pbakaus/impeccable) | Audit/polish/critique command workflow |
| [emilkowalski/skill](https://github.com/emilkowalski/skill) | Motion craft, CSS mastery, micro-interactions |
