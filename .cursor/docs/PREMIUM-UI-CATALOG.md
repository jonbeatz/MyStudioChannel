# Premium UI Resource Catalog

Welcome to the MyStudioChannel Premium UI Arsenal. This master catalog indexes modern interactive resources designed to help build outstanding, motion-heavy interfaces rapidly.

---

## 🛠️ Pre-Wired Registry Components

These are pre-configured inside `components.json` and can be fetched natively via the shadcn CLI:

### 1. Cult UI
*   **Aesthetic:** Niche, tactile, vintage texture, and motion-rich components.
*   **Documentation:** [https://www.cult-ui.com/](https://www.cult-ui.com/)
*   **Command:** `npx shadcn@latest add @cult-ui/[component]`
*   **Hot Components:** `texture-card`, `texture-button`, `text-gif`

### 2. Aceternity UI
*   **Aesthetic:** Ultra-modern, premium dark SaaS, lights, and spotlights.
*   **Documentation:** [https://ui.aceternity.com/](https://ui.aceternity.com/)
*   **Command:** `npx shadcn@latest add @aceternity/[component]`
*   **Hot Components:** `bento-grid`, `background-beams`, `sparkles`, `hover-effect`

### 3. Ali Imam Components
*   **Aesthetic:** Creative interactive elements (physics canvases, hardcover books, premium carousels).
*   **Documentation:** [https://aliimam.in/docs/components](https://aliimam.in/docs/components)
*   **Command:** `npx shadcn@latest add @aliimam/[component]`
*   **Hot Components:** `attraction` (physics gravity container), `book` (hardcover interaction), `carousel`

---

## 🔗 Direct URL / Registry Additions

These resources support the shadcn standard, but require direct JSON URLs or individual scripts for installation:

### 4. Animate UI
*   **Aesthetic:** Tasteful, highly-fluid animated primitives.
*   **Documentation:** [https://animate-ui.com/](https://animate-ui.com/)
*   **Command:** `npx shadcn@latest add "https://animate-ui.com/r/[component].json"`
*   **Example:** `npx shadcn@latest add "https://animate-ui.com/r/install-tabs"`

### 5. Its Hover
*   **Aesthetic:** Action-driven interactive SVGs and motion icons.
*   **Documentation:** [https://www.itshover.com/](https://www.itshover.com/)
*   **Command:** `npx shadcn@latest add "https://itshover.com/r/[icon-name].json"`
*   **Example:** `npx shadcn@latest add "https://itshover.com/r/like-icon.json"`

### 6. Lenis Smooth Scroll
*   **Aesthetic:** Standardized, buttery-smooth scrolling experiences, performance-first frame sync, and flawless scroll-linked animations.
*   **Documentation:** [https://www.lenis.dev/](https://www.lenis.dev/)
*   **Installation:** `npm install lenis`
*   **React Wrapper Setup:** Wrap Layout with `<ReactLenis root />` importing `'lenis/dist/lenis.css'`.
*   **Hot Primitives:** `<ReactLenis>`, `useLenis()` hook.

### 7. 21st.dev (Magic MCP)
*   **Aesthetic:** Modern custom UI components built instantly in your IDE from natural language prompts.
*   **Documentation:** [https://21st.dev/](https://21st.dev/)
*   **Integration:** Configured in `.cursor/mcp.json` under `21st-dev-magic`.
*   **API Activation:** Set `21ST_DEV_MAGIC_API_KEY` in `.env.local`, then sync using `npm run msc:sync:mcp-env` to reload the Cursor server.
*   **Usage:** Prompt Cursor to generate custom components inspired by 21st.dev styling.

---

## 🎨 Copy-Paste playgrounds

These do not rely on registries but are high-value design systems, design languages, and layout assets:

### 8. Uiverse.io
*   **Focus:** A massive community library with thousands of buttons, loaders, and card effects in HTML/CSS and Tailwind.
*   **Documentation:** [https://uiverse.io/](https://uiverse.io/)
*   **Usage:** Copy the Tailwind markup or raw CSS animations to spruce up button hover highlights, glowing cards, or custom spinners.

### 9. VibeUI Prompts
*   **Focus:** Structured layout prompts designed specifically to feed into AI models (Cursor, Claude, Bolt, Lovable) alongside UI screenshots to match aesthetic structures.
*   **Documentation:** [https://vibeui.online/](https://vibeui.online/)
*   **Usage:** Copy layout prompt strings to jump-start beautiful landing pages, hero segments, bento features, or multi-step onboarding flows.

### 10. MotionSites.ai
*   **Focus:** Curated prompt library with 65 high-performance structural templates designed for AI layout generation (Bolt.new, Cursor, v0).
*   **Documentation:** [https://motionsites.ai/](https://motionsites.ai/)
*   **Usage:** Copy and adapt their pro-grade layout prompts and motion-rich specifications during generation tasks.

### 11. Three.js & React Three Fiber (R3F)
*   **Aesthetic:** Immersive 3D interactive experiences, customizable geometric objects, particle physics systems, and 3D web graphics.
*   **Documentation:** [https://threejs.org/](https://threejs.org/) and [https://r3f.docs.pmnd.rs/](https://r3f.docs.pmnd.rs/)
*   **Installation:** `npm install three @react-three/fiber @react-three/drei` and `npm install --save-dev @types/three`
*   **Next.js Integration:** Added to `transpilePackages` inside `next.config.mjs` to allow full compilation. Always use dynamic import with `{ ssr: false }` for canvas scenes to bypass server-side hydration mismatches.
*   **Usage:** Prototype 3D canvases under `/test/three-d` to render and interact with complex models in isolated environments.

---

## 🚨 Guidelines for AI Agents
When prompted to "build a feature using our premium UI tools," the agent MUST:
1. Scan this catalog (`.cursor/docs/PREMIUM-UI-CATALOG.md`) to select a candidate.
2. Cross-reference the `.cursor/skills/Premium-UI/SKILL.md` for specific installation steps.
3. Incorporate the asset while preserving the gold-accented NovaMira theme rules.
