---
name: vader-protocol
description: Use this skill whenever building any UI, component, page, or feature for VaderLabz or any project using the Vader Protocol design system. Triggers: any mention of "Vader Protocol", "VaderLabz", "dark aesthetic", or when the user says "keep my design style". Ensures all new code matches the established VaderLabz visual identity — deep black backgrounds, crimson accents, monospace typography, terminal/command-center aesthetic.
---

# Vader Protocol Design System

This skill defines the VaderLabz design language. All UI built for VaderLabz or Vader Protocol projects must follow these rules exactly. Do not introduce new colors, fonts, or layout patterns without explicit instruction.

---

## Core Aesthetic

**Concept:** Terminal meets modern dev dashboard. A developer's command center — raw, dark, precise. Not a business site. Not a startup landing page. A weapon.

**Tone:** Industrial minimalism with edge. Every element earns its place. Nothing decorative unless it serves the atmosphere.

**Keywords:** Dark, crisp, monospace, crimson, grid, scanline, flicker, protocol, system.

---

## Color Tokens

Always use CSS variables. Never hardcode hex values in components.

```css
:root {
  --bg-void: #080808;          /* Page background — true near-black */
  --bg-surface: #0f0f0f;       /* Slightly lifted surface */
  --bg-card: #141414;          /* Card backgrounds */
  --bg-card-hover: #1a1a1a;    /* Card hover state */

  --accent-red: #c0392b;       /* Primary accent — crimson */
  --accent-red-bright: #e74c3c; /* Hover/active accent */
  --accent-red-dim: #7b1f17;   /* Subtle accent / borders */
  --accent-amber: #e67e22;     /* Warning / building status */

  --text-primary: #f0f0f0;     /* Main text */
  --text-secondary: #888;      /* Muted text */
  --text-dim: #444;            /* Very muted / decorative */

  --border: #1e1e1e;           /* Default border */
  --border-accent: #c0392b33;  /* Red-tinted border */
}
```

**Never use:** Purple gradients, blue accents, white backgrounds, rounded pill buttons, pastel colors, or any color not in this palette without explicit approval.

---

## Typography

```css
/* Display / Headings */
font-family: 'Rajdhani', sans-serif;
/* Weights: 400, 500, 600, 700 */
/* Use for: hero titles, section headers, project names, nav logo */

/* Monospace / Code / Labels */
font-family: 'Share Tech Mono', monospace;
/* Weight: 400 only */
/* Use for: eyebrows, tags, status labels, nav links, CTAs, footer, any small caps text */
```

**Import in layout.tsx:**
```ts
import { Share_Tech_Mono, Rajdhani } from "next/font/google";
import './globals.css';
import './vader.css';
```

---

## Stylesheet architecture (single source of truth)

| File | Purpose |
|------|---------|
| `app/(app)/globals.css` | CSS variables (`:root`), keyframes, resets, scrollbar, `::selection`, `prefers-reduced-motion` only |
| `app/(app)/vader.css` | **All** Vader Protocol component styles — nav, hero, sections, cards, lab, stack, contact, footer, back-to-top |

**Rules:**
- Add or edit component UI in **`vader.css`** using plain global classes prefixed with `vader-` (e.g. `.vader-hero`, `.vader-project-card`).
- Do **not** add component styles to `globals.css` or CSS Modules for Vader site pages.
- Import **`vader.css` once** in `app/(app)/layout.tsx` — no per-page CSS module imports.
- TSX uses `className="vader-*"` only — no `styles.foo`, no inline `style={{}}` for protocol UI.
- Motion keyframes live in `globals.css`; animation *application* lives on classes in `vader.css`.

Canonical paths in scaffolds: `templates/full-stack/vader-site/app/(app)/vader.css`.

---

**Rules:**
- Hero titles: Rajdhani, 700, clamp(4rem, 12vw, 9rem)
- Section titles: Rajdhani, 700, ~1.1rem, letter-spacing: 0.2em, ALL CAPS
- Body/descriptions: Rajdhani, 400, ~0.85–1.1rem
- All labels, tags, CTAs, nav: Share Tech Mono, letter-spacing: 0.1–0.15em, ALL CAPS
- Never use Inter, Roboto, Arial, or system fonts

---

## Layout Principles

- **Full bleed dark:** `background: var(--bg-void)` on body. No white sections ever.
- **Grid separators:** Use `gap: 1px; background: var(--border)` on grid containers to create hairline dividers between cards — no individual card borders needed.
- **Max width:** Content sections max-width 1100px, centered, padding 2.5rem horizontal (1.25rem mobile).
- **Section spacing:** 5rem top/bottom padding per section (3.5rem mobile).
- **No rounded corners** on cards or buttons. Sharp edges only. Border-radius: 0.
- **No box shadows.** Depth is created through background color differences only.

---

## Key Components

### Nav
```css
position: fixed; top: 0;
background: rgba(8,8,8,0.92);
backdrop-filter: blur(8px);
border-bottom: 1px solid var(--border);
```
- Logo: `> VADERLABZ` in Share Tech Mono, with `>` in accent-red
- Links: Share Tech Mono, 0.7rem, letter-spacing 0.15em, color text-secondary → accent-red-bright on hover

### Hero
- Grid overlay: CSS grid of cells with `border: 1px solid var(--accent-red)`, opacity 0.04
- Title flicker animation (subtle, not distracting)
- Eyebrow: `// VADER_PROTOCOL :: INITIALIZED` in accent-red mono
- Status dot: green `#27ae60` with glow, "SYSTEM ONLINE" text

### Cards (Projects)
```css
background: var(--bg-card);
padding: 1.75rem;
transition: background 0.2s;
/* Top border reveal on hover: */
::before { height: 2px; background: var(--accent-red); transform: scaleX(0) → scaleX(1) on hover }
```

### Tags / Badges
```css
font-family: var(--font-mono);
font-size: 0.6rem;
letter-spacing: 0.08em;
padding: 0.2rem 0.5rem;
background: var(--bg-surface);
color: var(--text-dim);
border: 1px solid var(--border);
border-radius: 0;
```

### Status Badges
- ACTIVE: `color: #27ae60; border-color: #27ae6033; background: #27ae6010`
- BUILDING: `color: var(--accent-amber); border-color: #e67e2233`
- COMING SOON: `color: var(--text-dim); border: 1px solid var(--border)`

### CTAs / Buttons
```css
/* Primary */
font-family: var(--font-mono);
font-size: 0.75rem;
letter-spacing: 0.15em;
padding: 0.85rem 2rem;
background: var(--accent-red);
color: #fff;
border: 1px solid var(--accent-red);
border-radius: 0;

/* Secondary */
background: transparent;
color: var(--text-secondary);
border: 1px solid var(--border);
```

### Section Headers
```css
/* Pattern: [number tag] [TITLE] [————————line] */
display: flex; align-items: center; gap: 1rem;
/* Tag: mono, 0.7rem, accent-red */
/* Title: display, 1.1rem, 700, letter-spacing 0.2em */
/* Line: flex:1; height:1px; background: var(--border) */
```

---

## Animations

```css
@keyframes flicker {
  0%, 100% { opacity: 1; }
  92% { opacity: 1; }
  93% { opacity: 0.8; }
  94% { opacity: 1; }
  96% { opacity: 0.9; }
  97% { opacity: 1; }
}

@keyframes scanline {
  0% { transform: translateY(-100%); }
  100% { transform: translateY(100vh); }
}

@keyframes pulse-red {
  0%, 100% { box-shadow: 0 0 0 0 rgba(192,57,43,0); }
  50% { box-shadow: 0 0 12px 2px rgba(192,57,43,0.3); }
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(24px); }
  to { opacity: 1; transform: translateY(0); }
}
```

- Scanline: fixed element, 2px red gradient, 8s infinite — always present
- Flicker: on hero title only, 6s interval — subtle
- pulse-red: on primary CTA button, 3s infinite
- fadeInUp: hero content on load, 0.8s

---

## Page Structure (Standard)

```
<nav> — fixed, logo + links
<section.hero> — full viewport, grid overlay, big title
<section#projects> — card grid
<section#lab> — experiment placeholders  
<section#stack> — tech stack grid
<section#contact> — simple CTA
<footer> — logo + version string
```

Section numbering: 01, 02, 03, 04 in accent-red mono

---

## Scrollbar

```css
::-webkit-scrollbar { width: 4px; }
::-webkit-scrollbar-track { background: var(--bg-void); }
::-webkit-scrollbar-thumb { background: var(--accent-red-dim); border-radius: 2px; }
```

---

## Text Selection

```css
::selection { background: var(--accent-red); color: #fff; }
```

---

## Do's and Don'ts

**DO:**
- Use sharp corners everywhere
- Use monospace for all UI text (labels, tags, nav, buttons)
- Use Rajdhani for display/heading text
- Keep backgrounds near-black
- Use crimson red as the ONLY accent color (amber for warnings only)
- Add scanline and flicker effects
- Use hairline 1px borders in `var(--border)` color
- Use grid gaps as dividers between cards

**DON'T:**
- Add rounded corners (border-radius > 0 on interactive elements)
- Use gradients as decorative elements
- Use any color outside the palette
- Add drop shadows
- Use light backgrounds anywhere
- Use Inter, Roboto, or system fonts
- Add emojis or illustrations
- Make it look like a startup / SaaS product

---

## Live Site
https://vaderlabz.com

## GitHub Repo
https://github.com/jonbeatz/VaderLabz

## Stack
Next.js 14, TypeScript, CSS Modules, Google Fonts (Rajdhani + Share Tech Mono)
