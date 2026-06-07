# Premium UI Skill Pack

Integrate highly animated, modern, and high-fidelity UI components from community-trusted registries and design catalogs.

## Capabilities
- **Shadcn Registries**: Instantly add components from pre-wired third-party registries.
- **Micro-Interactions**: Implement motion-first components, custom physics animations, SVG micro-interactions, and premium layout presets.
- **Copy-Paste Assets**: Seamlessly convert Tailwind and CSS structures into React components fitting the NovaMira design system.

## Registry Selection & Installation

### 1. Pre-registered CLI Addition (Best Developer Experience)
Use namespaced tags to add components directly using your current `components.json` setup:

```bash
# Cult UI (Motion-rich cards, buttons, text-gif)
npx shadcn@latest add @cult-ui/texture-button

# Aceternity UI (Framer motion bento grids, spotlights, etc.)
npx shadcn@latest add @aceternity/bento-grid

# Ali Imam (Physics attractions, hardcovers, carousels)
npx shadcn@latest add @aliimam/carousel
```

### 2. Direct JSON Registries
For non-namespaced registries, use direct URLs, or standard package installations for scroll controllers:

```bash
# Its Hover (Animated action icons)
npx shadcn@latest add https://itshover.com/r/like-icon.json

# Animate UI (Fluid primitives and effects)
npx shadcn@latest add https://animate-ui.com/r/install-tabs

# Lenis (Butter-smooth scrolling and scroll-linked animations)
npm install lenis
```

### 3. Snippet Injection & AI Prompts
- **Uiverse.io**: Grab optimized raw CSS animations and Tailwind blocks. Use to spice up buttons, inputs, and interactive loaders.
- **VibeUI**: High-quality layout prompt strings tailored for AI generation context (Cursor, Claude, Bolt). Copy the pattern, combine with active screenshots, and let the model construct clean layouts.

## Guidelines
- **Framer Motion Dependencies**: Ensure `framer-motion` (or `motion` package) is active when adding interactive elements.
- **Cinematic Harmony**: Style additions to match the **Gold Standard** (Accent gold) and deep dark layered bento layouts defined in `.cursor/skills/NovaMira-Design/SKILL.md`.
- **Reference Catalog**: Check `.cursor/docs/PREMIUM-UI-CATALOG.md` for the single source of truth catalog indexing of these assets.
