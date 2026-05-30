---
name: studio-dark-shield
description: >-
  Global Shield Core-to-Satellite CSS workflow and hybrid Tailwind consumer paths.
  Use when styling dashboards, WordPress surfaces, Payload UI, or deciding between
  msc satellite CSS vs Tailwind/shadcn for Next.js app shells.
---

# Studio Dark Shield — Agent Skill

**Compass:** [Code-Jedi.md](../docs/Code-Jedi.md) §5 · [TRUTH.md](../../TRUTH.md) §4–§6 · **Rules:** [rules/README.md](../rules/README.md), [studio-dark-ui.mdc](../rules/studio-dark-ui.mdc), [design-system-rules.mdc](../rules/design-system-rules.mdc), [tailwind-shadcn-bridge.mdc](../rules/tailwind-shadcn-bridge.mdc) · **Zero-leak:** [env-ingestion-compliance.mdc](../rules/env-ingestion-compliance.mdc)

## When to invoke

- Adding or editing files under `ui/` (`msc-shield.css`, satellites, TSX viewers).
- Choosing styling approach for a **consumer** fork (Shield-only vs hybrid Tailwind).
- Enqueue / import order (`msc-shield-load.css`, `core/msc-assets.php`).
- Reviewing agent output for inline styles, hardcoded colors, or global CSS leaks.

## Path A — Shield-only (dashboards / WordPress)

**Use when:** Payload admin chrome, `msc-project-manager`, `msc-portfolio-viewer`, PHP/Divi frontends, any surface wrapped in `.msc-viewport-shield` or `.msc-dashboard-container`.

| Step | Action |
|------|--------|
| 1 | Tokens + resets **only** in `ui/msc-shield.css` |
| 2 | Layout in `ui/msc-layout.css` |
| 3 | Shared chrome in `ui/msc-components.css` |
| 4 | Feature CSS in `ui/msc-[feature].css` under a **unique wrapper** |
| 5 | Optional: `MSC_SHIELD_EXTENSIONS=1` → `msc-shield-extensions.css` |

**Import:** `ui/msc-shield-load.css` or WordPress `msc_enqueue_shield_satellite_chain()`.

**Do not use Tailwind** for these surfaces unless explicitly bridging tokens for a shared layout shell (see Path B).

## Path B — Hybrid Tailwind (Next.js / shadcn consumers)

**Use when:** Consumer `app/` routes, marketing pages, shadcn forms, public app shell built with Tailwind v3/v4.

| Layer | Tooling |
|-------|---------|
| Tokens SSoT | Still `ui/msc-shield.css` — map to `tailwind.config.ts` per bridge rule |
| Components | shadcn registry + **shadcn MCP** (`npx shadcn@latest mcp`) |
| Live docs | **context7 MCP** — append “use context7” for framework API questions |
| Custom MSC chrome | Satellite CSS + wrappers — never replace shadcn primitives with global CSS |

**Do not** put feature layout in `globals.css` or `@apply` on `body`. Bridge tokens; use utilities inside namespaced regions or shadcn components.

## Decision matrix

| Question | Answer |
|----------|--------|
| Is it inside `.msc-dashboard-container` / dashboard TSX? | Path A — satellite CSS |
| Is it a Next `app/` page with `components.json`? | Path B — Tailwind + shadcn |
| New color needed? | Add to `msc-shield.css` first, then bridge to Tailwind if needed |
| New feature domain? | Create `ui/msc-[feature].css` + wrapper in same PR |
| Figma → code? | Consumer may use Figma MCP; merge tokens into Shield, not random hex in satellites |

## MCP tools (Tier 1)

| Server | Role |
|--------|------|
| `shadcn` | Browse/install registry components |
| `context7` | Up-to-date library docs in prompts |

Configured in `.cursor/mcp.json`. No API keys required for these two in committed config.

## Anti-patterns

- Inline `style={{ color: '...' }}` for theme colors
- Hardcoded `#121212` / `#e02b20` outside `msc-shield.css`
- Styling bare HTML tags at document scope
- Skipping wrapper class on new feature markup
- Contradicting Code-Jedi §5 load order

## Verification

```bash
npm run verify:mcp
```

Confirm `shadcn` and `context7` appear in server list. Enable both in Cursor Settings → MCP after config change.
