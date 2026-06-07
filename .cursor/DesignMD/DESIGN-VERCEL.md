# Design System Inspired by Vercel

## 1. Visual Theme & Atmosphere
Vercel's design system is a masterclass in high-contrast, technical precision. It pairs a stark, monochrome foundation of black (`#171717`) and white (`#ffffff`) with vibrant, abstract gradients that evoke a sense of digital energy and innovation. The aesthetic is unapologetically developer-centric, communicated through the clean geometry of the `Geist` font family, ample whitespace, and pixel-perfect alignment grids that are often subtly visible in component backgrounds. The overall feeling is one of speed, reliability, and cutting-edge performance, where complexity is managed with effortless clarity.

The signature visual element is the use of ethereal, colorful glows and fine-line geometric patterns against the otherwise minimalist black-and-white UI. This creates a dynamic tension between the functional and the aspirational. The system feels alive, with extensive use of SVG and keyframe-based animations (`cmdkScaleIn`, `accordion-down`) adding subtle motion to user interactions. This isn't a static design; it's a responsive, high-performance interface that mirrors the capabilities of the Vercel platform itself.

**Key Characteristics:**
*   **Monochrome Foundation:** The core palette is almost entirely black, white, and shades of gray, creating a high-contrast and focused environment. Primary CTAs are solid black (`#171717`).
*   **Abstract Gradient Accents:** Soft, multi-color gradients featuring hues like `#ffb224` (yellow), `#e5484d` (red), and `#45dec5` (cyan) are used as background elements to add depth and visual interest without distracting from content.
*   **Precision Typography:** The entire interface is set in `Geist` and `Geist Mono`, a geometric sans-serif and monospaced font that provides exceptional clarity and a technical feel.
*   **Minimalist Component Styling:** Components like buttons and cards feature clean lines, subtle 1px borders (`#ebebeb`), and small, consistent corner radii (`6px`).
*   **Structured Layout:** A strict 4px-based spacing system and a visible grid motif create a sense of order, precision, and intentionality.
*   **Subtle, Performant Motion:** The UI is enhanced by a significant number of SVG animations and CSS transitions for states like hover and focus, reinforcing the brand's focus on performance.

## 2. Color Palette & Roles
The palette is primarily monochrome, using vibrant colors only as accents within gradients or for specific, isolated highlights.

### Primary
*   **Nero (#171717):** The primary color for text, primary buttons, and dark UI elements. It establishes the system's high-contrast, confident tone.
*   **White (#ffffff):** Used for all primary backgrounds, inverse text, and as the fill for secondary buttons.

### Accent Colors
*   **Vercel Blue (#0068d6):** The primary color for interactive text links.
*   **Bright Red (#e5484d):** Used within gradients and for accents, potentially for destructive action states.
*   **Bright Blue (#52aeff):** A lighter, more vibrant blue used in illustrations and gradients.
*   **Bright Teal (#45dec5):** A key color in the hero gradient, adding a cool, futuristic feel.
*   **Bright Yellow (#ffb224):** A warm accent color used in gradients and visual elements.
*   **Pale Blue (#ebf5ff):** A very light blue used for subtle backgrounds, like on the "Events" badge.

### Neutral Scale
*   **Text Gray (#4d4d4d):** For secondary and body text that requires less emphasis than pure black.
*   **Off-White (#fafafa):** A subtle off-white for secondary backgrounds and card surfaces to differentiate sections.
*   **Border Gray (#ebebeb):** The standard color for borders on cards, inputs, and other containers.

## 3. Typography Rules

### Font Family
*   **Primary:** `Geist`, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"
*   **Monospace:** `Geist Mono`, ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace

### Hierarchy
| Role          | Font       | Size  | Weight | Line Height | Letter Spacing | Notes                               |
|---------------|------------|-------|--------|-------------|----------------|-------------------------------------|
| Display       | Geist      | 48px  | 700    | 1.2         | -0.02em        | For primary, page-level hero titles.|
| H1            | Geist      | 32px  | 600    | 1.25        | -0.015em       | Major section headings.             |
| H2            | Geist      | 24px  | 600    | 1.3         | -0.01em        | Subsection headings.                |
| H3            | Geist      | 18px  | 500    | 1.4         | normal         | Card titles and minor headings.     |
| Body          | Geist      | 16px  | 400    | 1.5         | normal         | Primary paragraph and body text.    |
| Caption / Meta| Geist      | 14px  | 400    | 1.5         | normal         | UI labels, helper text, captions.   |
| Small         | Geist      | 12px  | 400    | 1.5         | normal         | Legal text, small disclaimers.      |
| Code/Mono     | Geist Mono | 14px  | 400    | 1.5         | normal         | For all code blocks and snippets.   |

### Principles
*   **Clarity through Contrast:** The system defaults to near-black text (`#171717`) on white backgrounds for maximum readability.
*   **Minimal Weight Variation:** The design relies heavily on `400` for body copy and `500`/`600` for headings, avoiding thinner weights to maintain a strong, confident presence.
*   **Functional Sizing:** Font sizes are chosen for clear hierarchical roles, with `16px` as a comfortable reading size and `14px` for most interactive UI text.
*   **Readability First:** Generous line-height (`1.5`) is applied to all body and paragraph-level text to ensure comfortable reading, even in dense sections.

## 4. Component Stylings

### Buttons

#### Primary Button
Solid, high-contrast, and used for the most important actions. Available in standard and pill shapes.

```css
.button-primary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 40px;
  padding: 0 24px;
  background-color: #171717;
  color: #ffffff;
  border: 1px solid #171717;
  border-radius: 6px;
  font-family: "Geist", sans-serif;
  font-size: 16px;
  font-weight: 500;
  text-decoration: none;
  cursor: pointer;
  transition: opacity 0.15s ease;
}

.button-primary:hover {
  opacity: 0.8;
}

.button-primary.pill {
  border-radius: 9999px;
}
```


<details>
<summary>Secondary Button</summary>

Used for secondary actions that need to be visible but not compete with the primary CTA.

```css
.button-secondary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 40px;
  padding: 0 24px;
  background-color: #ffffff;
  color: #171717;
  border: 1px solid #ebebeb;
  border-radius: 6px;
  font-family: "Geist", sans-serif;
  font-size: 16px;
  font-weight: 500;
  text-decoration: none;
  cursor: pointer;
  transition: border-color 0.15s ease, color 0.15s ease;
}

.button-secondary:hover {
  border-color: #171717;
  color: #171717;
}
```

</details>

<details>
<summary>Ghost / Tertiary Button</summary>

Used for less prominent actions, often in groups or within components.

```css
.button-ghost {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 32px;
  padding: 0 12px;
  background-color: transparent;
  color: #4d4d4d;
  border: none;
  border-radius: 6px;
  font-family: "Geist", sans-serif;
  font-size: 14px;
  font-weight: 400;
  text-decoration: none;
  cursor: pointer;
  transition: background-color 0.15s ease, color 0.15s ease;
}

.button-ghost:hover {
  background-color: #fafafa;
  color: #171717;
}
```

</details>
### Cards & Containers
Cards are clean and minimal, defined by a subtle border and radius. They act as the primary surface for grouped content.

```css
.card {
  background-color: #ffffff;
  border-radius: 8px;
  padding: 24px;
  border: 1px solid #ebebeb;
  box-shadow: rgba(0, 0, 0, 0.04) 0px 2px 2px 0px;
  transition: box-shadow 0.2s ease;
}

.card:hover {
  /* Uses a more complex shadow on hover, as seen in tokens */
  box-shadow: 0 0 0 1px rgba(0,0,0,0.08), 0px 4px 8px rgba(0,0,0,0.04);
}
```

### Inputs & Forms

```css
.form-label {
  display: block;
  font-family: "Geist", sans-serif;
  font-size: 14px;
  font-weight: 500;
  color: #171717;
  margin-bottom: 8px;
}

.text-input {
  width: 100%;
  height: 40px;
  padding: 0 12px;
  background-color: #ffffff;
  border: 1px solid #ebebeb;
  border-radius: 6px;
  font-family: "Geist", sans-serif;
  font-size: 14px;
  color: #171717;
  transition: border-color 0.15s ease, box-shadow 0.15s ease;
}

.text-input::placeholder {
  color: #a8a8a8; /* Inferred from low-contrast pair */
}

.text-input:focus {
  outline: none;
  border-color: #0068d6;
  box-shadow: 0 0 0 3px rgba(0, 104, 214, 0.2); /* Inferred focus ring */
}

.text-input.error {
    border-color: #e5484d;
}
```

### Navigation

```css
.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 72px; /* Inferred from visual proportions */
  padding: 0 48px;
  background-color: #ffffff;
  border-bottom: 1px solid #ebebeb;
}

.nav-link {
  padding: 8px 12px;
  font-family: "Geist", sans-serif;
  font-size: 14px;
  font-weight: 400;
  color: #4d4d4d;
  text-decoration: none;
  border-radius: 6px;
  transition: color 0.15s ease, background-color 0.15s ease;
}

.nav-link:hover {
  color: #171717;
  background-color: #fafafa;
}
```

### Links

```css
.link {
  color: #0068d6;
  text-decoration: none;
  font-weight: 400;
  transition: color 0.15s ease;
}

.link:hover {
  text-decoration: underline;
  color: #171717;
}

.secondary-link {
  color: #4d4d4d;
  text-decoration: none;
  transition: color 0.15s ease;
}

.secondary-link:hover {
  color: #171717;
  text-decoration: underline;
}
```

### Badges

```css
.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 8px;
  border-radius: 9999px;
  font-family: "Geist", sans-serif;
  font-size: 12px;
  font-weight: 500;
  line-height: 1;
}

.badge-info {
  background-color: #ebf5ff;
  color: #0068d6;
}

.badge-alert {
  background-color: #fff2e5; /* Inferred from #ffb224 */
  color: #ffb224;
}

.badge-error {
  background-color: #ffeaea; /* Inferred from #e5484d */
  color: #e5484d;
}
```

## 5. Layout Principles

### Spacing System
The system uses a base unit of 4px. All padding, margins, and gaps should use multiples of this base unit.
*   **Scale:** `4px`, `8px`, `12px`, `16px`, `24px`, `32px`, `40px`, `48px`, `96px`

**Usage Context:**
*   `4px`: Micro-spacing within components, like between an icon and text.
*   `8px`: Gaps between related small elements, vertical padding for badges.
*   `12px`: Padding for small inputs and buttons.
*   `16px`: Standard padding within components like small cards.
*   `24px`: Standard padding for larger cards, gap between columns.
*   `32px`: Spacing between distinct content sections on a page.
*   `48px`: Horizontal padding for main page containers.
*   `96px`: Vertical padding for major page sections (hero, footer).

### Grid & Container
The layout is built on a wide, open grid to accommodate technical content and marketing visuals.
*   **Max Container Width:** `1400px` (from `--ds-page-width`)
*   **Columns:** 12-column grid is recommended for primary layouts.
*   **Gutter:** `24px`
*   **Section Padding:** `96px` (vertical) and `48px` (horizontal).

### Whitespace Philosophy
Whitespace is used generously to create a calm, focused, and uncluttered user experience. It reduces cognitive load by clearly separating components and content sections. Ample padding within cards and around typography ensures that even complex information is easy to parse and read.

### Border Radius Scale
*   `6px`: Standard radius for buttons, inputs, and small containers.
*   `8px`: Standard radius for larger components like cards.
*   `9999px`: "Pill" shape for badges and specific button variants.

## 6. Depth & Elevation
Depth is used sparingly and subtly. Shadows are light and primarily serve to lift interactive elements from the background, rather than create heavy, layered interfaces.

| Level | Treatment                                              | Use                                             |
|-------|--------------------------------------------------------|-------------------------------------------------|
| z-0   | `box-shadow: none; border: 1px solid #ebebeb;`          | Default static containers, content cards.       |
| z-1   | `box-shadow: rgba(0, 0, 0, 0.04) 0px 2px 2px 0px;`       | Subtle lift for interactive or hovered cards.   |
| z-2   | `box-shadow: var(--ds-shadow-border-medium);`           | Active dropdowns, popovers.                     |
| z-10  | `box-shadow: var(--ds-shadow-2xl);`                     | Complex interactive elements, foreground UI.    |
| z-75+ | `box-shadow: var(--ds-shadow-2xl);`                     | Global elements like navigation bars, modals.   |

### Shadow Philosophy
Shadows are not for decoration; they signify interactivity and elevation in the stacking context. The default state for most containers is flat, with a simple 1px border. A subtle shadow is added on hover or focus to provide feedback. Heavier shadows are reserved for transient UI like modals and dropdowns that must appear distinctly above the main content plane. The use of CSS variables like `--ds-shadow-border-medium` indicates a systematic approach to depth.

## 7. Do's and Don'ts

### Do
*   Use `#171717` for all primary button backgrounds.
*   Set body text at `16px` with `400` weight in `Geist`.
*   Apply a `6px` or `8px` border-radius to all cards and inputs.
*   Use only the defined spacing scale: `4, 8, 12, 16, 24, 32, 40, 48, 96px`.
*   Use `#0068d6` for all primary text links.
*   Ensure all cards have a `1px` border of `#ebebeb`.
*   Use `Geist Mono` for any display of code.
*   Combine Display `48px/700` with Body `16px/400` for clear hierarchy.
*   Use the pill `border-radius: 9999px` only for badges and select buttons.
*   Place at least `32px` of vertical space between distinct content cards.

### Don't
*   Use any font other than `Geist` or `Geist Mono`.
*   Place `#a8a8a8` text on a `#ffffff` background; the contrast is too low.
*   Invent spacing values like `20px` or `30px`.
*   Use a `border-radius` larger than `8px` on a standard card.
*   Make primary call-to-action buttons any color other than `#171717`.
*   Use shadows on static, non-interactive elements.
*   Set body text smaller than `14px`.
*   Apply multiple, competing gradients in the same view.
*   Use colors like `#e5484d` or `#45dec5` for text, except in illustrations.
*   Forget the `1px` `#ebebeb` border on secondary buttons.

## 8. Responsive Behavior
*Note: breakpoints below are measured directly from the source CSS. They are not suggestions.*

### Measured Breakpoints
| Breakpoint Name | Width           | Key Changes                                                                                             |
|-----------------|-----------------|---------------------------------------------------------------------------------------------------------|
| Mobile          | `< 600px`       | Single-column layout. Navigation collapses to a hamburger menu. Typography scales down. Section padding reduced to `24px`. |
| Phablet         | `600px - 768px` | Two-column grids become possible. Card layouts may stack. Horizontal padding increases.                 |
| Tablet          | `768px - 960px` | Full navigation may reappear. Complex grid layouts are introduced. Font sizes are closer to desktop.      |
| Desktop         | `> 960px`       | The full, wide layout with a `1400px` max-width. Multi-column layouts are standard.                     |
| Hover-capable   | `(hover: hover)`| Enables hover styles that are disabled on touch devices to prevent sticky hovers.                       |

### Touch Targets
*   All interactive elements (buttons, links, inputs) must have a minimum touch target size of 44x44px.
*   Ensure at least `8px` of space between adjacent touch targets.

### Collapsing Strategy
*   **Navigation:** The primary navigation links collapse into a hamburger menu icon. The "Log In" and "Sign Up" buttons remain visible in the mobile header.
*   **Cards:** Card grids reflow from multi-column (e.g., 3-across) to a single-column stack on mobile.
*   **Typography:** The `48px` Display heading may scale down to `32px` on mobile screens to prevent awkward wrapping.
*   **Padding:** Section padding is reduced from `96px` to `48px` or `32px` on mobile. Container padding is reduced from `48px` to `24px`.
*   **Forms:** Form elements stack vertically on a single column.

## 9. Agent Prompt Guide

### Quick Color Reference
*   **Primary Text/CTA:** `#171717`
*   **Primary Background:** `#ffffff`
*   **Secondary Text:** `#4d4d4d`
*   **Borders:** `#ebebeb`
*   **Interactive Link:** `#0068d6`
*   **Accent Gradient Colors:** `#e5484d`, `#52aeff`, `#45dec5`, `#ffb224`

### Iteration Guide
1.  **Always** use `#171717` for primary buttons and `#ffffff` with an `#ebebeb` border for secondary buttons.
2.  **Always** set H1 titles to `32px/600` and body text to `16px/400` in the `Geist` font.
3.  **Always** use the spacing scale: `4, 8, 12, 16, 24, 32, 40, 48, 96px`. Default component padding is `24px`.
4.  **Always** use a `border-radius` of `6px` for buttons/inputs and `8px` for cards. Use `9999px` for pills.
5.  **Always** give cards a `1px` border of `#ebebeb` and a subtle `box-shadow: rgba(0, 0, 0, 0.04) 0px 2px 2px 0px;`.
6.  **Always** ensure buttons and inputs have a minimum height of `40px`.
7.  **Always** show focus states with a distinct outline or `box-shadow`, never just a color change.
8.  **Always** collapse the main navigation into an icon menu on viewports narrower than `960px`.
9.  **Always** use shadows to indicate elevation for interactive elements like popovers, not for static layout.
10. **Always** ensure text contrast meets WCAG AA; never use `#a8a8a8` on `#ffffff`.
11. **Always** use `Geist Mono` for all code snippets, typically at `14px`.
12. **Always** use the measured breakpoints: `<600px`, `600px-960px`, and `>960px`.