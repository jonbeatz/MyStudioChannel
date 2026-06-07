---
name: My Studio Channel
url: https://mystudiochannel.com/
colors:
  primary: '#d4af37'
  primary-hover: '#d9a438'
  accent-light: '#f5b841'
  background: '#191919'
  surface: '#2a2a2a'
  surface-secondary: '#222222'
  text-primary: '#ffffff'
  text-muted: '#4c4c4c'
  text-on-primary: '#000000'
  border: '#4c4c4c'
  border-subtle: 'rgba(255, 255, 255, 0.05)'
typography:
  family: 'Montserrat'
  display:
    family: 'Montserrat'
    size: 96px
    weight: 600
    line-height: 1.2
  h1:
    family: 'Montserrat'
    size: 36px
    weight: 600
    line-height: 1.2
  h2:
    family: 'Montserrat'
    size: 30px
    weight: 600
    line-height: 1.2
  body:
    family: 'Montserrat'
    size: 16px
    weight: 400
    line-height: 1.5
  caption:
    family: 'Montserrat'
    size: 14px
    weight: 400
    line-height: 1.2
  code:
    family: 'Geist Mono'
    size: 14px
    weight: 400
    line-height: 1.5
spacing:
  base: 4px
  scale: [0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 128]
radius:
  sm: 4px
  md: 10px
  lg: 12px
  xl: 16px
  full: 9999px
elevation:
  card: 'oklch(0.78 0.16 75 / 0.25) 0px 0px 12px 0px'
  button-hover: 'rgba(245, 184, 65, 0.35) 0px 0px 20px'
  focus-ring: 'oklab(0.78 0.041411 0.154548 / 0.3) 0px 0px 0px 1px'
motion:
  duration-base: '0.3s'
  easing-standard: 'cubic-bezier(0.4, 0, 0.2, 1)'
components:
  button-primary:
    bg: '{colors.primary}'
    text: '{colors.text-on-primary}'
    radius: '{radius.md}'
    padding: '8px 12px'
  button-secondary:
    bg: 'transparent'
    text: '{colors.text-primary}'
    border: '1px solid {colors.border}'
    radius: '{radius.lg}'
    padding: '8px 16px'
  card:
    bg: '{colors.surface}'
    radius: '{radius.xl}'
    shadow: '{elevation.card}'
---

# Design System Inspired by My Studio Channel

## 1. Visual Theme & Atmosphere
My Studio Channel presents a professional and immersive digital experience, characterized by a deep, dark aesthetic. The site leverages a primary background of `#191919` with slightly lighter `#2a2a2a` for cards, creating a sense of depth and focus on content. Accents of vibrant gold, primarily `#d4af37`, punctuate interactive elements and key headlines, drawing the eye and establishing brand identity against the dark canvas.

The visual language is structured and media-centric, utilizing the Montserrat typeface across all typographic elements to maintain a consistent, modern feel. Interactive elements like "bento-style" cards animate with subtle `translateY(-2px)` transforms on hover, providing a responsive and engaging user experience. The site also incorporates CSS keyframe animations, such as `msc-fade-up`, to introduce content dynamically, enhancing the overall polish and perceived quality of the platform.

Key Characteristics:
- Dark theme with `#191919` background and `#2a2a2a` surfaces.
- Gold accent color `#d4af37` for CTAs and highlights.
- Exclusive use of Montserrat for all text.
- Bento-style cards with `translateY(-2px)` hover effect.
- Subtle CSS keyframe animations for content presentation.
- Strong visual hierarchy through varied font sizes and weights.
- Minimalist iconography with a focus on content presentation.

## 2. Color Palette & Roles
The color palette for My Studio Channel is built around a dark, sophisticated foundation with a striking gold accent, designed to evoke a premium and professional media environment.

-   **Primary**:
    -   `primary`: `#d4af37` — The core brand gold, used for primary calls-to-action, active states, and key highlights.
    -   `primary-hover`: `#d9a438` — A slightly darker, richer gold used for the hover state of primary interactive elements.
    -   `accent-light`: `#f5b841` — A brighter gold, used for subtle shadows and secondary accent elements, providing visual warmth.

-   **Neutral Scale**:
    -   `text-primary`: `#ffffff` — Pure white, used for primary headlines and body text on dark backgrounds, ensuring maximum readability.
    -   `text-muted`: `#4c4c4c` — A dark gray used for secondary information, subtle borders, and less prominent text elements.
    -   `text-on-primary`: `#000000` — Pure black, used for text placed directly on the vibrant gold primary color to ensure strong contrast.

-   **Surface & Borders**:
    -   `background`: `#191919` — The deepest dark, serving as the main canvas for the entire website.
    -   `surface`: `#2a2a2a` — A slightly lighter dark gray, used for cards, containers, and elevated content blocks to provide visual separation.
    -   `surface-secondary`: `#222222` — Another dark gray variant, used for subtle background variations or specific component backgrounds.
    -   `border`: `#4c4c4c` — A dark gray used for subtle outlines and dividers, providing structure without being obtrusive.
    -   `border-subtle`: `rgba(255, 255, 255, 0.05)` — A transparent white overlay, used for hover states on outline buttons to create a subtle glow effect.

## 3. Typography Rules
The My Studio Channel design system relies exclusively on the Montserrat typeface, establishing a consistent and modern typographic voice across all content.

-   **Font Family**:
    -   Primary: `'Montserrat', 'Montserrat Fallback', system-ui, sans-serif`
    -   Monospace: `'Geist Mono', 'Geist Mono Fallback', monospace` (inferred from `cssVariables`)

-   **Hierarchy**:
    -   **Display/H1**: `Montserrat` `96px` `600` · line-height `1.2` · tracking `none` · Used for prominent hero section titles.
    -   **H2**: `Montserrat` `48px` `600` · line-height `1.2` · tracking `none` · Employed for major section headings.
    -   **H3**: `Montserrat` `36px` `600` · line-height `1.2` · tracking `none` · Used for sub-section titles and large feature callouts.
    -   **H4**: `Montserrat` `30px` `600` · line-height `1.2` · tracking `none` · Applied to smaller section titles and key feature descriptions.
    -   **Body**: `Montserrat` `16px` `400` · line-height `1.5` · tracking `none` · Standard text for paragraphs and detailed content.
    -   **Caption**: `Montserrat` `14px` `400` · line-height `1.2` · tracking `none` · Used for meta-information, labels, and small descriptive text.
    -   **Code/Mono**: `Geist Mono` `14px` `400` · line-height `1.5` · tracking `none` · Intended for code snippets or technical text.

-   **Principles**:
    -   Maintain a strong visual hierarchy using distinct font sizes and weights from the Montserrat family.
    -   Utilize the `600` weight for all headings to ensure impact and readability on dark backgrounds.
    -   Apply a generous line-height of `1.5` for body text to enhance readability and visual comfort.
    -   Reserve the gold accent color (`#d4af37`) for key labels and interactive text elements to guide user attention.
    -   Employ `uppercase` and `tracking-wider` for small accent text to create a distinct informational style.

## 4. Component Stylings

### Buttons

#### Primary Button
The primary button features a bold gold background with dark text, signaling the most important actions. On hover, it subtly lifts and glows.

```css
.msc-btn-primary {
  background-color: var(--color-primary, #d4af37);
  color: var(--color-text-on-primary, #000000);
  font-family: var(--typography-family, 'Montserrat');
  font-size: 14px; /* Inferred from extracted buttons */
  font-weight: 500; /* Inferred from extracted buttons */
  padding: 8px 12px;
  border: none;
  border-radius: var(--radius-md, 10px);
  cursor: pointer;
  transition: background-color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1)),
              transform var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1)),
              box-shadow var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-btn-primary:hover {
  background-color: var(--color-primary-hover, #d9a438); /* From extracted pseudoStates */
  transform: translateY(-2px); /* From extracted pseudoStates */
  box-shadow: var(--elevation-button-hover, rgba(245, 184, 65, 0.35) 0px 0px 20px); /* From extracted pseudoStates */
}

.msc-btn-primary:active {
  background-color: var(--color-primary, #d4af37); /* Inferred from screenshot */
  transform: translateY(0); /* Inferred from screenshot */
  box-shadow: none; /* Inferred from screenshot */
}

.msc-btn-primary:disabled {
  background-color: var(--color-text-muted, #4c4c4c); /* Inferred from screenshot */
  color: rgba(255, 255, 255, 0.5); /* Inferred from screenshot */
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}
```

#### Secondary Button (Outline)
The secondary button provides a clear alternative action, featuring a transparent background with white text and a subtle border. It gains a light background fill on hover.

```css
.msc-btn-outline {
  background-color: transparent;
  color: var(--color-text-primary, #ffffff);
  font-family: var(--typography-family, 'Montserrat');
  font-size: 14px; /* Inferred from extracted buttons */
  font-weight: 400; /* Inferred from extracted buttons */
  padding: 8px 16px;
  border: 1px solid var(--color-border, #4c4c4c); /* Inferred from screenshot */
  border-radius: var(--radius-lg, 12px);
  cursor: pointer;
  transition: background-color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1)),
              border-color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-btn-outline:hover {
  background-color: var(--color-border-subtle, rgba(255, 255, 255, 0.05)); /* From extracted pseudoStates */
  border-color: var(--color-border-subtle, rgba(255, 255, 255, 0.05)); /* Inferred from screenshot */
}

.msc-btn-outline:active {
  background-color: var(--color-border-subtle, rgba(255, 255, 255, 0.05)); /* Inferred from screenshot */
  border-color: var(--color-border-subtle, rgba(255, 255, 255, 0.05)); /* Inferred from screenshot */
}

.msc-btn-outline:disabled {
  color: var(--color-text-muted, #4c4c4c); /* Inferred from screenshot */
  border-color: var(--color-text-muted, #4c4c4c); /* Inferred from screenshot */
  cursor: not-allowed;
  background-color: transparent;
}
```

#### Ghost Button
Ghost buttons are text-only, used for less prominent actions or navigation within content. They gain an underline on hover.

```css
.msc-btn-ghost {
  background-color: transparent;
  color: var(--color-text-primary, #ffffff);
  font-family: var(--typography-family, 'Montserrat');
  font-size: 16px; /* Inferred from screenshot */
  font-weight: 400; /* Inferred from screenshot */
  padding: 0;
  border: none;
  border-radius: 0;
  cursor: pointer;
  text-decoration: none;
  transition: text-decoration var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1)),
              color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-btn-ghost:hover {
  text-decoration: underline; /* Inferred from screenshot */
  color: var(--color-primary, #d4af37); /* Inferred from screenshot */
}

.msc-btn-ghost:active {
  color: var(--color-primary-hover, #d9a438); /* Inferred from screenshot */
  text-decoration: underline; /* Inferred from screenshot */
}

.msc-btn-ghost:disabled {
  color: var(--color-text-muted, #4c4c4c); /* Inferred from screenshot */
  cursor: not-allowed;
  text-decoration: none;
}
```

### Cards & Containers

#### Standard Card
Cards serve as content containers, featuring a dark background and subtle rounded corners. On hover, they lift slightly to indicate interactivity.

```css
.msc-card {
  background-color: var(--color-surface, #2a2a2a);
  color: var(--color-text-primary, #ffffff);
  border: 1px solid var(--color-border, #4c4c4c); /* Inferred from screenshot */
  border-radius: var(--radius-xl, 16px);
  padding: var(--spacing-40, 40px); /* Inferred from screenshot */
  box-shadow: none; /* Initial state, no shadow */
  transition: transform var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-card:hover {
  transform: translateY(-2px); /* From extracted pseudoStates */
  box-shadow: var(--elevation-card, oklch(0.78 0.16 75 / 0.25) 0px 0px 12px 0px); /* Inferred, applying a subtle glow */
}
```

### Inputs & Forms

#### Text Input
Standard text input fields with a dark background and subtle border. They highlight with a gold border and ring on focus.

```css
.msc-input-text {
  background-color: var(--color-surface, #2a2a2a);
  color: var(--color-text-primary, #ffffff);
  font-family: var(--typography-family, 'Montserrat');
  font-size: 16px; /* Inferred from screenshot */
  font-weight: 400;
  padding: 12px 16px; /* Inferred from screenshot */
  border: 1px solid var(--color-border, #4c4c4c); /* Inferred from screenshot */
  border-radius: var(--radius-sm, 4px); /* Inferred from screenshot */
  transition: border-color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1)),
              box-shadow var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-input-text:focus {
  outline: none;
  border-color: var(--color-primary, #d4af37); /* Inferred from screenshot */
  box-shadow: var(--elevation-focus-ring, oklab(0.78 0.041411 0.154548 / 0.3) 0px 0px 0px 1px); /* From extracted shadows */
}

.msc-input-text:disabled {
  background-color: var(--color-surface-secondary, #222222); /* Inferred from screenshot */
  color: var(--color-text-muted, #4c4c4c); /* Inferred from screenshot */
  border-color: var(--color-text-muted, #4c4c4c); /* Inferred from screenshot */
  cursor: not-allowed;
}
```

#### Form Label
Labels for form fields, using a clear white text on the dark background.

```css
.msc-form-label {
  color: var(--color-text-primary, #ffffff);
  font-family: var(--typography-family, 'Montserrat');
  font-size: 14px; /* Inferred from screenshot */
  font-weight: 500; /* Inferred from screenshot */
  margin-bottom: var(--spacing-8, 8px); /* Inferred from screenshot */
  display: block;
}
```

#### Checkbox/Radio
Custom styled checkboxes and radio buttons with a gold accent for the checked state.

```css
.msc-checkbox,
.msc-radio {
  appearance: none;
  width: 20px; /* Inferred from screenshot */
  height: 20px; /* Inferred from screenshot */
  border: 2px solid var(--color-border, #4c4c4c); /* Inferred from screenshot */
  border-radius: var(--radius-sm, 4px); /* For checkbox */
  background-color: var(--color-surface, #2a2a2a);
  cursor: pointer;
  transition: background-color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1)),
              border-color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-radio {
  border-radius: var(--radius-full, 9999px); /* For radio */
}

.msc-checkbox:checked,
.msc-radio:checked {
  background-color: var(--color-primary, #d4af37);
  border-color: var(--color-primary, #d4af37);
}

.msc-checkbox:focus,
.msc-radio:focus {
  outline: none;
  box-shadow: var(--elevation-focus-ring, oklab(0.78 0.041411 0.154548 / 0.3) 0px 0px 0px 1px); /* From extracted shadows */
}

.msc-checkbox:disabled,
.msc-radio:disabled {
  background-color: var(--color-surface-secondary, #222222); /* Inferred from screenshot */
  border-color: var(--color-text-muted, #4c4c4c); /* Inferred from screenshot */
  cursor: not-allowed;
}
```

### Navigation

#### Top Navigation Bar
The main navigation bar is a fixed dark strip at the top, housing the logo and primary navigation links.

```css
.msc-navbar {
  background-color: var(--color-background, #191919);
  color: var(--color-text-primary, #ffffff);
  height: 80px; /* Inferred from screenshot */
  padding: 0 var(--spacing-64, 64px); /* Inferred from screenshot */
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100; /* From extracted zIndexValues */
}
```

#### Navigation Link
Individual links within the navigation bar, appearing as white text and turning gold on hover or when active.

```css
.msc-nav-link {
  color: var(--color-text-primary, #ffffff);
  font-family: var(--typography-family, 'Montserrat');
  font-size: 14px; /* From extracted buttons */
  font-weight: 400; /* From extracted buttons */
  text-decoration: none;
  padding: var(--spacing-8, 8px) var(--spacing-16, 16px); /* Inferred from screenshot */
  transition: color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-nav-link:hover {
  color: var(--color-primary, #d4af37);
}

.msc-nav-link.active,
.msc-nav-link[aria-current="page"] {
  color: var(--color-primary, #d4af37);
  text-decoration: underline; /* Inferred from screenshot */
}
```

#### Dropdown Menu
Dropdown menus provide nested navigation or options, with a dark surface background and subtle border.

```css
.msc-dropdown-menu {
  background-color: var(--color-surface, #2a2a2a);
  border: 1px solid var(--color-border, #4c4c4c); /* Inferred from screenshot */
  border-radius: var(--radius-sm, 4px); /* Inferred from screenshot */
  padding: var(--spacing-8, 8px) 0;
  box-shadow: var(--elevation-focus-ring, oklab(0.78 0.041411 0.154548 / 0.3) 0px 0px 0px 1px); /* Using focus-ring shadow for subtle depth */
  min-width: 160px; /* Inferred from screenshot */
  z-index: 20; /* From extracted zIndexValues */
}

.msc-dropdown-menu-item {
  color: var(--color-text-primary, #ffffff);
  font-family: var(--typography-family, 'Montserrat');
  font-size: 14px; /* Inferred from screenshot */
  font-weight: 400;
  padding: var(--spacing-8, 8px) var(--spacing-16, 16px);
  cursor: pointer;
  transition: background-color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1)),
              color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-dropdown-menu-item:hover {
  background-color: var(--color-border-subtle, rgba(255, 255, 255, 0.05)); /* Inferred from screenshot */
  color: var(--color-primary, #d4af37); /* Inferred from screenshot */
}
```

### Links

#### Standard Link
Inline text links are white by default and turn gold with an underline on hover.

```css
.msc-link-standard {
  color: var(--color-text-primary, #ffffff);
  text-decoration: none;
  transition: color var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1)),
              text-decoration var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-link-standard:hover {
  color: var(--color-primary, #d4af37);
  text-decoration: underline;
}

.msc-link-standard:visited {
  color: var(--color-primary, #d4af37); /* Inferred from screenshot */
}
```

#### Secondary Link
Links that are already gold, used for accentuating specific text within paragraphs or lists. They only gain an underline on hover.

```css
.msc-link-secondary {
  color: var(--color-primary, #d4af37);
  text-decoration: none;
  transition: text-decoration var(--motion-duration-base, 0.3s) var(--motion-easing-standard, cubic-bezier(0.4, 0, 0.2, 1));
}

.msc-link-secondary:hover {
  text-decoration: underline;
}

.msc-link-secondary:visited {
  color: var(--color-primary, #d4af37); /* Inferred from screenshot */
}
```

### Badges
(none observed in source)

## 5. Layout Principles
My Studio Channel employs a spacious, dark aesthetic with a clear grid system to present content in a structured and engaging manner, reminiscent of streaming platforms.

-   **Spacing System**: The design system uses a `4px` base unit, creating a consistent and harmonious rhythm across the interface.
    -   Base unit: `4px`
    -   Scale: `[0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 128]`
    -   Usage Context:
        -   `4px`: Smallest gaps, icon-to-text spacing.
        -   `8px`: Inline element spacing, small vertical rhythm.
        -   `12px`: Button padding (horizontal), list item spacing.
        -   `16px`: Button padding (horizontal), input padding, small component spacing.
        -   `20px`: Moderate spacing between related elements.
        -   `24px`: Section padding (vertical), card content spacing.
        -   `32px`: Larger component spacing, grid column gutters.
        -   `40px`: Card internal padding, significant vertical rhythm.
        -   `48px`: Section padding, major content block separation.
        -   `64px`: Large section padding, hero content separation.
        -   `128px`: Extra large spacing for hero sections or full-page dividers.

-   **Grid & Container** *(Suggested — not measured)*: _Note: container widths and column counts are not extracted from the source. The values below are reasonable defaults inferred from the visible layout density._
    -   Max Width: `1280px` (inferred from screenshot)
    -   Columns: `12` (inferred from common web practices)
    -   Gutter: `32px` (inferred from screenshot)
    -   Section Padding: `64px` horizontal and vertical (inferred from screenshot)

-   **Whitespace Philosophy**: The design embraces generous dark whitespace, particularly around major content blocks and headings. This ample negative space allows the gold accents and white text to stand out, reducing visual clutter and guiding the user's focus. It contributes to a premium and uncluttered aesthetic, providing visual breathing room for the rich media content.

-   **Border Radius Scale**:
    -   `sm`: `4px` — Subtle rounding for inputs and small elements.
    -   `md`: `10px` — Standard for primary buttons.
    -   `lg`: `12px` — Used for secondary outline buttons.
    -   `xl`: `16px` — Prominent rounding for cards and larger containers.
    -   `full`: `9999px` — For perfectly rounded elements like avatars or radio buttons.

## 6. Depth & Elevation
My Studio Channel utilizes subtle elevation cues, primarily through shadows and z-index values, to create a sense of hierarchy and interactivity within its dark interface.

-   **Flat (z-0)**: `none` — Default state for background elements, main