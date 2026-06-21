# NovaMira Studio — v0 Master Design Blueprint

A reusable design system + prompt blueprint for spinning up premium, dark, cinematic developer
dashboards and control panels in v0.dev. Copy the relevant parts into v0 when starting a new project.

> Brand character: "A media broadcasting operating system." Premium, clean, futuristic, dark, and
> highly polished — a hybrid of Linear.app, high-end video editing bays, and a black-box command
> console. The UI should feel powerful, intentional, and hardware-grade.

---

## Table of Contents

1. [How to Use This Blueprint](#how-to-use-this-blueprint)
2. [Recommended Tech Stack](#part-0--recommended-tech-stack)
3. [Brand Identity & Design Tokens](#part-1--brand-identity--design-tokens)
4. [Layout Patterns](#part-2--layout-patterns)
5. [Component Patterns](#part-3--component-patterns)
6. [Interaction & Motion](#part-4--interaction--motion)
7. [Accessibility & Responsive](#part-5--accessibility--responsive)
8. [Anti-Slop: Do / Don't](#part-6--anti-slop-do--dont)
9. [Architecture & Data-Layer Pattern](#part-7--architecture--data-layer-pattern)
10. [Quick Reference Card](#part-8--quick-reference-card)

---

## How to Use This Blueprint

Paste this document into v0 when you want to build:

- A new dashboard or control panel
- A profile / workspace / project manager
- A settings or configuration interface
- Any tool that needs a premium, dark, cinematic UI

Start your v0 message with:

```text
Build a [Your Tool Name] using the NovaMira Studio design language defined below.
Tech stack: Next.js 15 (App Router) + TypeScript + Tailwind v4 + shadcn/ui + Framer Motion + lucide-react.
Keep all data access behind a typed lib/api.ts (mock now) so a real backend drops in later.

[Your specific feature requirements here.]

--- then paste the NovaMira Studio blueprint below ---
```

---

## PART 0 — Recommended Tech Stack

| Layer | Choice | Notes |
|-------|--------|-------|
| Framework | **Next.js 15 (App Router) + React 19 + TypeScript** | v0's native output; enables API routes for real backends |
| Styling | **Tailwind CSS v4** | Token-driven; pair with the CSS variables below |
| Components | **shadcn/ui** | Dialog, Command, Tabs, Select, Switch, Slider, Tooltip, Badge, ScrollArea, AlertDialog, Sonner |
| Animation | **Framer Motion** | Springs, layout animations, gold pulse |
| Icons | **lucide-react** | Thin line icons; gold tint on active |
| Fonts | **Geist** + **Geist Mono** | via `next/font`; Space Grotesk as a display alt |
| Toasts | **Sonner** | Glass styling, gold/danger variants |
| Data layer | **`lib/api.ts`** (mock → real) | Single typed module; never fetch directly in components |

---

## PART 1 — Brand Identity & Design Tokens

### Core Color Palette (use exactly)

| Token | Value | Usage |
|-------|-------|-------|
| Background Base | `#070708` → `#0B0B0E` → `#0D0D11` | Main backgrounds, layered depths |
| Primary Accent (Studio Gold) | `#F5B841` | Active states, glowing borders, CTAs, indicators, pulse |
| Gold Dim | `#C8922E` | Hover states, borders |
| Text Primary | `#FBFBFB` | Headings, primary labels |
| Text Secondary | `#9F9FA9` | Body text, descriptions |
| Text Muted | `#6B6B73` | Placeholders, decorative text only |
| Success | `#3FB950` | Online status, completed actions |
| Warning | `#F5B841` | Pending, checking states |
| Danger | `#F85149` | Errors, destructive actions |
| Info | `#58A6FF` | Information, links |

### CSS Variables (drop into `globals.css`)

```css
:root {
  --bg-0: #070708;
  --bg-1: #0b0b0e;
  --bg-2: #0d0d11;
  --accent: #f5b841;        /* swap to re-theme the whole app */
  --accent-dim: #c8922e;
  --text-1: #fbfbfb;
  --text-2: #9f9fa9;
  --text-muted: #6b6b73;
  --success: #3fb950;
  --warning: #f5b841;
  --danger: #f85149;
  --info: #58a6ff;

  --glass-bg: rgba(13, 13, 17, 0.45);
  --glass-border: rgba(255, 255, 255, 0.04);
  --glass-border-gold: rgba(245, 184, 65, 0.10);

  --radius-panel: 18px;
  --radius-card: 12px;
  --radius-input: 10px;

  --shadow-ambient: 0 8px 40px rgba(0, 0, 0, 0.5);
  --shadow-modal: 0 20px 60px rgba(0, 0, 0, 0.7), inset 0 1px 0 rgba(255, 255, 255, 0.05);
  --inner-highlight: inset 0 1px 0 rgba(255, 255, 255, 0.05);

  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
  --dur-fast: 150ms;
  --dur-base: 220ms;
}
```

### Tailwind v4 token mapping (`@theme`)

```css
@theme inline {
  --color-bg-0: var(--bg-0);
  --color-accent: var(--accent);
  --color-text-1: var(--text-1);
  --color-text-2: var(--text-2);
  --radius-panel: var(--radius-panel);
  --font-sans: var(--font-geist-sans);
  --font-mono: var(--font-geist-mono);
}
```

### Surface Layering (Glassmorphism)

```css
/* Base glass panel */
.glass {
  background: var(--glass-bg);
  backdrop-filter: blur(20px) saturate(140%);
  -webkit-backdrop-filter: blur(20px) saturate(140%);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-panel);
}

/* Enhanced glass (hardware feel) */
.glass-premium {
  background: var(--glass-bg);
  backdrop-filter: blur(20px) saturate(140%);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-panel);
  box-shadow: var(--inner-highlight), var(--shadow-ambient);
}

/* Gold-tinted glass (active / hover) */
.glass-gold {
  border-color: var(--glass-border-gold);
  box-shadow:
    inset 0 1px 0 rgba(245, 184, 65, 0.05),
    0 0 30px rgba(245, 184, 65, 0.05);
}
```

### Typography

| Element | Font | Size | Weight | Tracking |
|---------|------|------|--------|----------|
| UI / Headings | Geist / Space Grotesk | variable | 600–700 | -0.02em |
| Body | Geist | 14px | 400 | 0 |
| Mono (paths, ports, slugs) | Geist Mono / JetBrains Mono | 13px | 400 | 0 |
| Eyebrow labels | Geist | 10px | 600 | 0.08em (uppercase) |
| Status badges | Geist Mono | 11px | 500 | 0.04em |

### Spacing & Radius

| Token | Value |
|-------|-------|
| Panel radius | 16–20px |
| Card radius | 12px |
| Button / input radius | 10px |
| Capsule / pill radius | 9999px |
| Inner padding | 16–24px |
| Grid gap | 16–20px |

### Shadows

```css
/* Ambient */
box-shadow: 0 8px 40px rgba(0, 0, 0, 0.5);

/* Gold glow (pulse) */
box-shadow: 0 0 20px rgba(245, 184, 65, 0.15);

/* Inner highlight (hardware feel) */
box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.05);

/* Premium modal */
box-shadow: 0 20px 60px rgba(0, 0, 0, 0.7), inset 0 1px 0 rgba(255, 255, 255, 0.05);
```

### Animations

```css
/* Pulse gold — active elements, waveform, CTAs */
@keyframes pulseGold {
  0%   { box-shadow: 0 0 5px rgba(245, 184, 65, 0.2);  border-color: rgba(245, 184, 65, 0.10); }
  50%  { box-shadow: 0 0 20px rgba(245, 184, 65, 0.4); border-color: rgba(245, 184, 65, 0.25); }
  100% { box-shadow: 0 0 5px rgba(245, 184, 65, 0.2);  border-color: rgba(245, 184, 65, 0.10); }
}

/* Waveform bars */
@keyframes waveMotion {
  0%   { height: 4px; }
  50%  { height: 16px; }
  100% { height: 4px; }
}

/* Modal spring-in */
@keyframes springIn {
  0%   { transform: scale(0.96); opacity: 0; }
  100% { transform: scale(1); opacity: 1; }
}

/* Shimmer sweep (active selection / loading) */
@keyframes shimmer {
  0%   { background-position: -200% center; }
  100% { background-position: 200% center; }
}
```

### Cinematic Depth Effects

Add these for the premium "hardware console" feel:

- **Radial gold glow:** very low opacity (~6%) behind the top-left wordmark / logo area.
- **Edge vignette:** subtle darkening at the viewport edges.
- **Film grain:** optional ultra-subtle noise overlay (`opacity: 0.02–0.04`).
- **Inner top highlight:** `1px rgba(255,255,255,0.05)` on all glass panels.
- **Custom scrollbars:** thin (8px), transparent track, `rgba(255,255,255,0.08)` thumb, gold on hover.
- **Focus ring:** `2px` gold (`--accent`) `focus-visible` ring with a soft glow, never the default blue.

---

## PART 2 — Layout Patterns

### Bento Grid (asymmetric)

The signature layout: a structured, asymmetric grid with multiple panel sizes.

```text
+--------------------------------------------------------------+
| TOP BAR (slim)                                               |
| [Logo/Wordmark] [Search/Command] [Active/Status] [Settings]  |
+-----------------------------+--------------------------------+
| LEFT PANEL (~38%)           | RIGHT PANEL (~62%)             |
|                             |                                |
| [List / Navigation / Menu]  | [Detail / Content / View]      |
|                             |                                |
| Cards with:                 | Bento-style info cards:        |
| - Monogram avatar           | - Stats in mono                |
| - Title + slug              | - Quick actions                |
| - Path (truncated)          | - Command preview              |
| - Status pill               |                                |
| - Active state (gold glow)  |                                |
+-----------------------------+--------------------------------+
| FOOTER CONSOLE (fixed bottom, glass)                         |
| [Waveform] [Service Capsules] [Quick Actions]                |
+--------------------------------------------------------------+
```

### Profile / Item Card

```text
+---------------------------------------------+
| +---+  Title                  [ACTIVE]      |
| | J |  slug                                 |
| +---+  status pill                          |
|        truncated path (tooltip on hover)    |
|        ----------------                     |
|        [CLI ok] pill                        |
+---------------------------------------------+
```

### Detail Bento (2x2 stats)

```text
+-------------------------------------------------------------+
| Large Title   slug   Status        [Action Button]          |
|                                                             |
| +-----------------+ +-----------------+                     |
| | WORKSPACE PATH  | | CLI PROFILE HOME|                     |
| | D:\Hermes\...   | | %LOCALAPPDATA%  |                     |
| | [Open Folder]   | | [Reveal]        |                     |
| +-----------------+ +-----------------+                     |
| +-----------------+ +-----------------+                     |
| | MEM0 COLLECTION | | DESKTOP SHORTCUT|                     |
| | collection_name | | shortcut.lnk    |                     |
| +-----------------+ +-----------------+                     |
|                                                             |
| QUICK ACTIONS: [Launch] [Sync] [Open] [Reveal] [Edit]       |
|                                                             |
| +---------------------------------------------------------+ |
| | COMMAND PREVIEW                                         | |
| | > Switch-Hermes-Profile.ps1 -Action switch -Profile X  | |
| | Transparency — the exact command that will run.        | |
| +---------------------------------------------------------+ |
+-------------------------------------------------------------+
```

### Footer Console (J.A.R.V.I.S.)

```text
+-------------------------------------------------------------+
| |||||  J.A.R.V.I.S.   o LITELLM 4000   o NGROK 4040         |
| |||||  ACTIVE         o LM STUDIO 1234  o GATEWAY           |
| |||||                 [Switch] [+ New] [Adopt]              |
+-------------------------------------------------------------+
```

---

## PART 3 — Component Patterns

### Glass Modal (spring-in)

```text
+-------------------------------------------------------------+
| [Backdrop: glass blur, click to close / confirm if dirty]   |
| +---------------------------------------------------------+  |
| |  x  TITLE                       [Action Button]         |  |
| |  Subtitle or helper text                                |  |
| |  +---------------------------------------------------+  |  |
| |  | Content area                                      |  |  |
| |  | - Form fields (glass inputs)                      |  |  |
| |  | - Toggles (gold when active)                      |  |  |
| |  | - Selects (glass dropdowns)                       |  |  |
| |  | - Live previews (command preview)                 |  |  |
| |  +---------------------------------------------------+  |  |
| |  [Cancel]   [Save / Create] (gold filled)              |  |
| +---------------------------------------------------------+  |
+-------------------------------------------------------------+
```

### Settings Panel (tabbed, full-screen glass)

```text
+-------------------------------------------------------------+
| SETTINGS                                                    |
| A premium control panel for your environment.               |
| +----------+----------------------------------------------+ |
| | GENERAL  |  Setting rows:                                | |
| | APPEAR.  |  +-----------------------------------------+  | |
| | CONSOLE  |  | Label    Helper text       [Control]   |  | |
| | SHORTCUTS|  +-----------------------------------------+  | |
| | INTEGR.  |  Section headers (uppercase eyebrow)        | |
| | DATA     |  Live preview for appearance settings       | |
| | ADVANCED |                       [Save Changes][Cancel] | |
| +----------+----------------------------------------------+ |
+-------------------------------------------------------------+
```

### Command Palette (Ctrl+K)

```text
+-------------------------------------------------------------+
| Cmd+K                                                       |
| +---------------------------------------------------------+ |
| | search profiles or commands...                          | |
| +---------------------------------------------------------+ |
| | > JonBeatz                  Personal AI command         | |
| |   MyStudioChannel           MSC website project         | |
| |   ClientX                   Client engagement           | |
| |   =====================================================  | |
| |   Switch to JonBeatz        Cmd+1                        | |
| |   Create new profile        Cmd+N                        | |
| |   Open settings             Cmd+,                        | |
| +---------------------------------------------------------+ |
| Tip: / to filter   .   Esc to close                        |
+-------------------------------------------------------------+
```

### Buttons

| Variant | Style |
|---------|-------|
| Primary (gold) | Solid `--accent` fill, dark text `#0B0B0E`, subtle gold glow on hover |
| Ghost | Transparent, `--glass-border`, text-2; brightens border + lifts 1px on hover |
| Danger | Transparent with `--danger` border/text; fills danger on confirm |
| Icon | 36px square glass, lucide icon, gold on active |

### Inputs & Selects

- Glass background, `--glass-border`, `10px` radius, `13–14px` text.
- Focus: gold `focus-visible` ring + brighter border, no blue outline.
- Mono variant for paths/ports/slugs. Path inputs pair with a `Browse` / copy button.

### Badges, Pills & Status Dots

| State | Dot color | Pill label |
|-------|-----------|-----------|
| Online / OK | `--success` | "CLI ok", "ONLINE" |
| Checking / Pending | `--warning` | "checking" |
| Offline / Missing | `--text-muted` / `--danger` | "CLI missing", "OFFLINE" |

Pills: capsule radius, mono 11px, `0.04em` tracking, faint tinted background of the status color.

### Monogram Avatar

- Circle with the item's first letter, thin gold ring (`1px var(--accent)` at ~40% alpha),
  subtle inner gold glow. Small (28–32px) on cards, large (44–52px) in detail headers.

### Toasts (Sonner)

- Glass panel, gold left border for success, danger left border for errors, info border for neutral.
- Bottom-right, auto-dismiss ~4s, spring-in, with optional action button.

### Loading / Empty / Error States

- **Loading:** shimmer sweep across the panel or skeleton cards (glass blocks with shimmer).
- **Empty:** centered glass card, gold-outlined CTA (e.g., "Create your first profile"), short helper.
- **Error:** danger-tinted card or toast with a retry action; never a raw stack trace.

---

## PART 4 — Interaction & Motion

### State Transitions

| Action | Visual feedback |
|--------|-----------------|
| Hover (card/button) | 2px lift, border brightens, cursor pointer |
| Active state | Gold left border (2px), `pulseGold` halo, "ACTIVE" tag |
| Selected (not active) | Gold left border (1px), "Switch to this" button |
| Toggle ON | Gold background, smooth slide |
| Toast | Glass panel, gold border (success) / danger border (error) |
| Loading | Subtle shimmer sweep across the area |
| Modal open | Spring scale (0.96 → 1), backdrop blur-in |

### Motion Principles

- Durations: `150ms` for hovers/toggles, `220ms` for panels/modals, `300ms` max for large moves.
- Easing: `cubic-bezier(0.16, 1, 0.3, 1)` for enters; Framer spring `{ stiffness: 300, damping: 30 }`
  for modals.
- Animate `transform` and `opacity` (GPU-friendly); avoid animating layout/`width`/`top`.
- Always honor `prefers-reduced-motion` (drop to fades or none).

### Keyboard Shortcuts (standard set)

| Shortcut | Action |
|----------|--------|
| Ctrl+K | Command palette |
| Ctrl+N | Create new |
| `/` | Focus search |
| Enter | Switch / select |
| Arrow keys | Navigate list |
| Ctrl+, | Open settings |
| Esc | Close modals, clear selection |

---

## PART 5 — Accessibility & Responsive

### Accessibility

- Maintain WCAG AA contrast for all functional text. Reserve `--text-muted` (`#6B6B73`) for purely
  decorative text only.
- Gold `focus-visible` ring on every interactive element; full keyboard operability.
- Proper roles/labels: `dialog` + focus trap on modals, `aria-live` for toasts and status changes,
  `aria-pressed` on toggles, labelled inputs.
- Respect `prefers-reduced-motion` and `prefers-contrast`.
- Hit targets >= 36px; tooltips supplement (never replace) visible labels.

### Responsive

- Optimize for wide desktop (>= 1280px); the bento sits side-by-side.
- < 1024px: stack to a single column (list above detail) with a back affordance.
- < 640px: footer console collapses to an expandable sheet; quick actions become an overflow menu.
- Panels scroll internally; the app shell is `100dvh` with no full-page scroll on desktop.

---

## PART 6 — Anti-Slop: Do / Don't

**Do**

- Lead with the obsidian + Studio Gold identity and the bento layout.
- Use mono for paths/ports/slugs and an eyebrow label above each section.
- Add restraint: gold is an accent, not a fill — use it for state, glow, and key CTAs.
- Include a "transparency" surface (command preview / live values) where it fits.

**Don't**

- No purple/blue gradient hero blobs.
- No generic centered Inter card stack or cookie-cutter SaaS marketing layout.
- No rainbow status colors — stick to the success/warning/danger/info set.
- No heavy drop shadows or neon; depth comes from glass, blur, and the inner highlight.
- No default browser focus outlines or unstyled native selects.

---

## PART 7 — Architecture & Data-Layer Pattern

Keep the UI portable and backend-swappable:

- All reads/writes go through a single typed module **`lib/api.ts`** (`listX()`, `doY()`,
  `getSettings()`, `updateSettings()`), returning **mock data** during prototyping.
- Components never `fetch` directly — they call `lib/api.ts`. Swapping mock → real (Next.js Route
  Handlers, Tauri commands, etc.) is then a one-file change.
- Persist UI settings to a single `settings` object (localStorage now; a real `settings.json` later).
- For local tools that run shell/system commands, bind the backend to `127.0.0.1` only — never
  expose it publicly.
- Suggested component naming: `XList`, `XCard`, `XDetail`, `XDialog`, plus shared `FooterConsole`,
  `CommandPalette`, `StatusDot`, `Monogram`, `CommandPreview`.

---

## PART 8 — Quick Reference Card

| Element | Token / Value |
|---------|---------------|
| Background | `#070708` → `#0B0B0E` → `#0D0D11` |
| Accent | `#F5B841` (Studio Gold) |
| Glass | `rgba(13,13,17,0.45)` + `blur(20px) saturate(140%)` |
| Border | `rgba(255,255,255,0.04)` or `rgba(245,184,65,0.10)` |
| Radius | 16–20px panels, 12px cards, 10px inputs |
| Shadow | `0 8px 40px rgba(0,0,0,0.5)` + inner highlight |
| Font | Geist (UI) + Geist Mono (paths/code) |
| Motion | `pulseGold`, `springIn`, `waveMotion`, `shimmer` |
| Easing | `cubic-bezier(0.16, 1, 0.3, 1)`; spring `{300, 30}` |
| Focus | 2px gold `focus-visible` ring (never blue) |

---

This is the master NovaMira Studio design system. Keep it on file and reuse it for every future v0
project. To re-theme, swap the `--accent` variable (e.g., Saber Green `#3FB950`, Sith Red `#F85149`,
Ice Blue `#58A6FF`) and the entire UI follows.
