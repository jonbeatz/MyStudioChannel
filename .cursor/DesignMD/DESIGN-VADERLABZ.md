---
name: VaderLabz
url: https://www.vaderlabz.com/
colors:
  primary: '#c0392b'
  primary-dim: '#7b1f17'
  primary-hover: '#e74c3c'
  accent-green: '#27ae60'
  accent-amber: '#e67e22'
  background-void: '#080808'
  background-surface: '#0f0f0f'
  background-card: '#141414'
  background-card-hover: '#1a1a1a'
  text-primary: '#f0f0f0'
  text-muted: '#888888'
  text-dim: '#444444'
  border-subtle: '#1e1e1e'
  border-primary-alpha: '#c0392b33'
typography:
  display:
    family: 'Rajdhani'
    size: 64px
    weight: 700
    line-height: 1.1
  heading-1:
    family: 'Rajdhani'
    size: 48px
    weight: 700
    line-height: 1.2
  heading-2:
    family: 'Rajdhani'
    size: 24px
    weight: 700
    line-height: 1.2
  body:
    family: 'Rajdhani'
    size: 16px
    weight: 400
    line-height: 1.5
  caption:
    family: 'Rajdhani'
    size: 13px
    weight: 400
    line-height: 1.5
  code:
    family: 'Share Tech Mono'
    size: 13px
    weight: 400
    line-height: 1.5
spacing:
  base: 4px
  scale: [0, 4, 8, 12, 16, 24, 32, 40, 80, 96]
radius:
  full: 50px
elevation:
  card-glow: '0px 0px 6px 0px {colors.accent-green}'
  z-index-card: 1
  z-index-nav: 50
  z-index-overlay: 100
components:
  button-primary:
    bg: '{colors.primary}'
    text: '{colors.text-primary}'
    radius: '{radius.full}'
    padding: '12px 24px'
  button-secondary:
    bg: '{colors.background-card}'
    text: '{colors.text-primary}'
    border: '1px solid {colors.border-subtle}'
    radius: '{radius.full}'
    padding: '12px 24px'
  card:
    bg: '{colors.background-card}'
    text: '{colors.text-primary}'
    border: '1px solid {colors.border-subtle}'
    radius: '0px'
    padding: '32px'
    shadow: 'none'
motion:
  duration-base: '0.2s'
  duration-fast: '0.3s'
  easing-standard: 'ease-in-out'
layout:
  breakpoints:
    mobile-max: 768px
---

# Design System Inspired by VaderLabz

## 1. Visual Theme & Atmosphere
VaderLabz presents a high-tech, dark-mode aesthetic, reminiscent of a command-line interface or a futuristic data terminal. The primary visual elements are a stark black background (`#080808`), contrasted with bright white (`#f0f0f0`) and a vibrant red (`#c0392b`) for interactive elements and brand accents. A subtle grid overlay and monospace typography contribute to a precise, developer-centric atmosphere. CSS animations such as `pulse-red` on primary calls to action and `scanline` effects reinforce the digital, system-like feel.

The design leverages ample dark space to highlight content, employing a strict hierarchy with bold, condensed display fonts (`Rajdhani`) for titles and a monospaced font (`Share Tech Mono`) for code-like snippets and secondary information. Interactive elements are clearly delineated with the brand's primary red, which pulses subtly to draw attention. The overall impression is one of focused technical development and experimentation within a secure, almost clandestine digital environment.

**Key Characteristics**
*   Dark background (`#080808`) with white text (`#f0f0f0`).
*   Primary accent color is a bold red (`#c0392b`).
*   Condensed `Rajdhani` font for headings, `Share Tech Mono` for code.
*   Subtle grid overlay and scanline animation for a digital aesthetic.
*   Pill-shaped buttons and tags with `50px` border-radius.
*   Interactive elements use `pulse-red` animation and `0.2s ease-in-out` transitions.
*   Project cards feature a `1px solid #1e1e1e` border.

## 2. Color Palette & Roles
The VaderLabz color palette is dominated by a deep dark neutral scale, punctuated by a striking primary red and supporting accent colors for status indication.

-   **Primary**
    -   `primary` (`#c0392b`) — The main brand red, used for primary calls to action, active states, and key visual accents.
    -   `primary-dim` (`#7b1f17`) — A darker, muted red used for lower contrast text accents, such as the `//` separators in the "TECH STACK" section.
    -   `primary-hover` (`#e74c3c`) — A brighter red, used for hover states on navigation links and secondary buttons to indicate interactivity.
-   **Accent Colors**
    -   `accent-green` (`#27ae60`) — Used for "ACTIVE" status badges and a subtle glow shadow on interactive elements, indicating success or live status.
    -   `accent-amber` (`#e67e22`) — Used for "BUILDING" status badges, indicating a work-in-progress state.
-   **Neutral Scale**
    -   `text-primary` (`#f0f0f0`) — The default text color for main content, headings, and interactive elements on dark backgrounds.
    -   `text-muted` (`#888888`) — Secondary text color, used for descriptions, helper text, and less prominent information.
    -   `text-dim` (`#444444`) — A very dark grey, used for subtle hints or text that needs to recede further into the background, often failing AA contrast.
-   **Surface & Borders**
    -   `background-void` (`#080808`) — The deepest background color, forming the base of the entire interface.
    -   `background-surface` (`#0f0f0f`) — A slightly lighter dark grey, used for main content sections and to provide subtle visual separation from the void.
    -   `background-card` (`#141414`) — The background color for cards and distinct content blocks, offering a subtle lift from the main surface.
    -   `background-card-hover` (`#1a1a1a`) — A slightly lighter shade of dark grey, used for card hover states to provide visual feedback.
    -   `border-subtle` (`#1e1e1e`) — A dark grey border color, used for dividing lines, card outlines, and input fields.
    -   `border-primary-alpha` (`#c0392b33`) — A semi-transparent primary red, used for subtle accent borders, particularly around interactive elements.

## 3. Typography Rules
-   **Font Family**:
    -   Primary: `'Rajdhani', sans-serif`
    -   Monospace: `'Share Tech Mono', monospace`
-   **Hierarchy**:
    -   **Display**: `Rajdhani` `64px` `700` · line-height `1.1` · tracking `none` · Used for the main brand title. (inferred from screenshot)
    -   **Heading 1**: `Rajdhani` `48px` `700` · line-height `1.2` · tracking `none` · Used for prominent section titles. (inferred from screenshot)
    -   **Heading 2**: `Rajdhani` `24px` `700` · line-height `1.2` · tracking `none` · Used for section headers like "PROJECTS" or "TECH STACK".
    -   **Body**: `Rajdhani` `16px` `400` · line-height `1.5` · tracking `none` · Standard text for paragraphs and descriptions.
    -   **Caption**: `Rajdhani` `13px` `400` · line-height `1.5` · tracking `none` · Used for small labels, timestamps, and secondary information.
    -   **Code/Mono**: `Share Tech Mono` `13px` `400` · line-height `1.5` · tracking `none` · Used for inline code, tags, and system messages.
-   **Principles**
    -   Emphasize hierarchy through `Rajdhani` font weights (700 for headings, 400 for body) and size variations.
    -   Utilize `Share Tech Mono` for all technical tags, code snippets, and system-level information to maintain a consistent digital aesthetic.
    -   Maintain a generous line-height of `1.5` for body text to ensure readability against the dark background.
    -   Use `text-primary` (`#f0f0f0`) on `background-void` (`#080808`) for all primary text content to ensure AAA contrast.
    -   Apply `text-muted` (`#888888`) for secondary information, ensuring it still meets AA contrast on `background-card` (`#141414`).

## 4. Component Stylings

### Buttons
VaderLabz buttons are designed with a pill-shaped `border-radius: 50px` and clear visual feedback for interaction states. Primary buttons feature a distinct `pulse-red` animation.

#### Primary Button
A prominent, red button for key actions, featuring a subtle pulsing animation.

```css
.button-primary {
  background-color: var(--color-primary, #c0392b);
  color: var(--color-text-primary, #f0f0f0);
  font-family: 'Rajdhani', sans-serif;
  font-size: 16px;
  font-weight: 700;
  padding: 12px 24px;
  border: none;
  border-radius: var(--radius-full, 50px);
  cursor: pointer;
  animation: pulse-red var(--motion-duration-base, 3s) infinite ease-in-out; /* inferred from animations.transitions */
  transition: background-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.button-primary:hover {
  background-color: var(--color-primary-hover, #e74c3c);
  animation: none; /* inferred from screenshot */
}

.button-primary:active {
  background-color: var(--color-primary-dim, #7b1f17); /* inferred from screenshot */
  transform: translateY(1px); /* inferred from screenshot */
}

.button-primary:disabled {
  background-color: var(--color-text-dim, #444444); /* inferred from screenshot */
  color: var(--color-text-muted, #888888); /* inferred from screenshot */
  cursor: not-allowed;
  animation: none;
}
```

#### Secondary Button
A dark button with a subtle border, used for secondary actions like "GITHUB".

```css
.button-secondary {
  background-color: var(--color-background-card, #141414);
  color: var(--color-text-primary, #f0f0f0);
  font-family: 'Rajdhani', sans-serif;
  font-size: 16px;
  font-weight: 700;
  padding: 12px 24px;
  border: 1px solid var(--color-border-subtle, #1e1e1e);
  border-radius: var(--radius-full, 50px);
  cursor: pointer;
  transition: background-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out),
              color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.button-secondary:hover {
  background-color: var(--color-background-card-hover, #1a1a1a);
  color: var(--color-primary-hover, #e74c3c); /* inferred from pseudoStates.hover for nav links */
  border-color: var(--color-primary-hover, #e74c3c); /* inferred from screenshot */
}

.button-secondary:active {
  background-color: var(--color-background-void, #080808); /* inferred from screenshot */
  transform: translateY(1px); /* inferred from screenshot */
}

.button-secondary:disabled {
  background-color: var(--color-background-card, #141414); /* inferred from screenshot */
  color: var(--color-text-dim, #444444); /* inferred from screenshot */
  border-color: var(--color-text-dim, #444444); /* inferred from screenshot */
  cursor: not-allowed;
}
```

#### Ghost Button (Text Link Button)
A text-only button, often used for navigation or less prominent actions.

```css
.button-ghost {
  background: none;
  color: var(--color-text-primary, #f0f0f0);
  font-family: 'Rajdhani', sans-serif;
  font-size: 16px;
  font-weight: 700;
  padding: 8px 12px;
  border: none;
  border-radius: 0px; /* inferred from screenshot */
  cursor: pointer;
  transition: color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.button-ghost:hover {
  color: var(--color-primary-hover, #e74c3c);
  text-decoration: underline; /* inferred from screenshot */
}

.button-ghost:active {
  color: var(--color-primary-dim, #7b1f17); /* inferred from screenshot */
}

.button-ghost:disabled {
  color: var(--color-text-dim, #444444); /* inferred from screenshot */
  cursor: not-allowed;
}
```

### Cards & Containers
Cards are dark rectangular blocks with a subtle border, used to group related content like project descriptions or lab experiments. Hover states provide a subtle background change.

#### Standard Card (`.page_projectCard__2LcUe`)
Used for showcasing projects, with a dark background and a subtle border.

```css
.page_projectCard__2LcUe {
  background-color: var(--color-background-card, #141414);
  color: var(--color-text-primary, #f0f0f0);
  font-family: 'Rajdhani', sans-serif;
  padding: 32px;
  border: 1px solid var(--color-border-subtle, #1e1e1e);
  border-radius: 0px; /* inferred from screenshot */
  box-shadow: none;
  transition: background-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
  position: relative; /* for the ::before pseudo-element */
  overflow: hidden; /* to contain the ::before scaleX */
}

.page_projectCard__2LcUe::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: var(--color-background-card-hover, #1a1a1a); /* inferred from screenshot */
  transform: scaleX(0);
  transform-origin: left;
  transition: transform var(--motion-duration-fast, 0.3s) var(--motion-easing-standard, ease-in-out);
  z-index: 0;
}

.page_projectCard__2LcUe:hover {
  background-color: var(--color-background-card-hover, #1a1a1a); /* This is overridden by ::before, but kept for clarity */
  border-color: var(--color-primary, #c0392b); /* inferred from screenshot */
}

.page_projectCard__2LcUe:hover::before {
  transform: scaleX(1);
}

.page_projectCard__2LcUe > * {
  position: relative;
  z-index: 1; /* Ensure content is above the hover overlay */
}
```

#### Lab Card (`.page_labCard__SHmX_`)
Similar to the standard card but with an icon and a "COMING SOON" badge.

```css
.page_labCard__SHmX_ {
  background-color: var(--color-background-card, #141414);
  color: var(--color-text-primary, #f0f0f0);
  font-family: 'Rajdhani', sans-serif;
  padding: 32px;
  border: 1px solid var(--color-border-subtle, #1e1e1e);
  border-radius: 0px; /* inferred from screenshot */
  box-shadow: none;
  transition: background-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.page_labCard__SHmX_:hover {
  background-color: var(--color-background-card-hover, #1a1a1a);
  border-color: var(--color-primary, #c0392b); /* inferred from screenshot */
}
```

### Inputs & Forms
Form elements are minimal, dark, and use subtle borders. Focus states are clearly defined with a primary red border.

#### Text Input
A standard text input field with a dark background and a subtle border.

```css
.input-text {
  background-color: var(--color-background-card, #141414);
  color: var(--color-text-primary, #f0f0f0);
  font-family: 'Rajdhani', sans-serif;
  font-size: 16px;
  font-weight: 400;
  padding: 12px 16px;
  border: 1px solid var(--color-border-subtle, #1e1e1e);
  border-radius: 4px; /* inferred from screenshot */
  transition: border-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out),
              box-shadow var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.input-text::placeholder {
  color: var(--color-text-muted, #888888);
}

.input-text:focus {
  border-color: var(--color-primary, #c0392b);
  outline: none;
  box-shadow: 0 0 0 2px var(--color-border-primary-alpha, #c0392b33); /* inferred from screenshot */
}

.input-text:disabled {
  background-color: var(--color-background-surface, #0f0f0f); /* inferred from screenshot */
  color: var(--color-text-dim, #444444); /* inferred from screenshot */
  border-color: var(--color-text-dim, #444444); /* inferred from screenshot */
  cursor: not-allowed;
}
```

#### Form Label
Labels for form fields, using a muted text color.

```css
.form-label {
  color: var(--color-text-muted, #888888);
  font-family: 'Rajdhani', sans-serif;
  font-size: 14px;
  font-weight: 400;
  margin-bottom: 8px; /* inferred from screenshot */
  display: block;
}
```

#### Checkbox/Radio (inferred)
Simple, dark-themed checkboxes or radio buttons.

```css
.checkbox, .radio {
  appearance: none;
  width: 18px; /* inferred from screenshot */
  height: 18px; /* inferred from screenshot */
  border: 1px solid var(--color-border-subtle, #1e1e1e);
  background-color: var(--color-background-card, #141414);
  border-radius: 2px; /* inferred from screenshot */
  cursor: pointer;
  display: inline-block;
  vertical-align: middle;
  transition: background-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out),
              border-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.radio {
  border-radius: 50%; /* inferred from screenshot */
}

.checkbox:checked, .radio:checked {
  background-color: var(--color-primary, #c0392b);
  border-color: var(--color-primary, #c0392b);
}

.checkbox:focus, .radio:focus {
  outline: 2px solid var(--color-border-primary-alpha, #c0392b33); /* inferred from screenshot */
  outline-offset: 2px; /* inferred from screenshot */
}

.checkbox:disabled, .radio:disabled {
  background-color: var(--color-background-surface, #0f0f0f); /* inferred from screenshot */
  border-color: var(--color-text-dim, #444444); /* inferred from screenshot */
  cursor: not-allowed;
}
```

### Navigation
The top navigation bar features subtle links that highlight in red on hover.

#### Top Navigation Bar
A minimalist dark bar at the top, housing navigation links.

```css
.page_nav__ijo23 { /* inferred from elevation.zIndexValues */
  background-color: var(--color-background-void, #080808); /* inferred from screenshot */
  padding: 24px 40px; /* inferred from screenshot */
  border-bottom: 1px solid var(--color-border-subtle, #1e1e1e); /* inferred from screenshot */
  display: flex;
  justify-content: flex-end; /* inferred from screenshot */
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: var(--elevation-z-index-nav, 50);
}
```

#### Navigation Link (`.page_navLinks__8rPi_ a`)
Individual links within the navigation bar.

```css
.page_navLinks__8rPi_ a {
  color: var(--color-text-muted, #888888);
  font-family: 'Rajdhani', sans-serif;
  font-size: 16px;
  font-weight: 400;
  text-decoration: none;
  padding: 8px 16px; /* inferred from screenshot */
  transition: color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.page_navLinks__8rPi_ a:hover {
  color: var(--color-primary-hover, #e74c3c);
}

.page_navLinks__8rPi_ a.active,
.page_navLinks__8rPi_ a[aria-current="page"] {
  color: var(--color-text-primary, #f0f0f0);
  font-weight: 700; /* inferred from screenshot */
}
```

#### Dropdown Menu (none observed in source)

### Links
Standard links are subtle, often appearing as "VIEW ON GITHUB" or within body text.

#### Standard Link
A basic text link, often in `text-muted` and highlighting in `primary-hover`.

```css
.link-standard {
  color: var(--color-text-muted, #888888);
  text-decoration: none;
  font-family: 'Rajdhani', sans-serif;
  font-size: 16px;
  font-weight: 400;
  transition: color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.link-standard:hover {
  color: var(--color-primary-hover, #e74c3c);
  text-decoration: underline;
}

.link-standard:active {
  color: var(--color-primary-dim, #7b1f17); /* inferred from screenshot */
}

.link-standard:visited {
  color: var(--color-text-muted, #888888); /* inferred from screenshot */
}
```

#### Secondary Link (`VIEW ON GITHUB`)
A more prominent link, often with an arrow icon, using the primary red.

```css
.link-secondary {
  color: var(--color-primary, #c0392b);
  text-decoration: none;
  font-family: 'Share Tech Mono', monospace; /* inferred from screenshot */
  font-size: 13px; /* inferred from screenshot */
  font-weight: 400;
  display: inline-flex;
  align-items: center;
  gap: 4px; /* inferred from screenshot */
  transition: color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.link-secondary:hover {
  color: var(--color-primary-hover, #e74c3c);
  text-decoration: underline;
}

.link-secondary:active {
  color: var(--color-primary-dim, #7b1f17); /* inferred from screenshot */
}

.link-secondary:visited {
  color: var(--color-primary, #c0392b); /* inferred from screenshot */
}
```

### Badges
VaderLabz uses distinct badges to indicate status or categorize content, often with a pill shape.

#### Status Badge - Active (`.status-active`)
Indicates an active or live status, using the accent green.

```css
.status-active {
  background-color: var(--color-accent-green, #27ae60);
  color: var(--color-text-primary, #f0f0f0);
  font-family: 'Share Tech Mono', monospace;
  font-size: 10px; /* inferred from screenshot */
  font-weight: 400;
  padding: 4px 8px; /* inferred from screenshot */
  border-radius: var(--radius-full, 50px);
  text-transform: uppercase;
  letter-spacing: 0.5px; /* inferred from screenshot */
  display: inline-block;
}
```

#### Status Badge - Building (`.status-building`)
Indicates a work-in-progress status, using the accent amber.

```css
.status-building {
  background-color: var(--color-accent-amber, #e67e22);
  color: var(--color-text-primary, #f0f0f0);
  font-family: 'Share Tech Mono', monospace;
  font-size: 10px; /* inferred from screenshot */
  font-weight: 400;
  padding: 4px 8px; /* inferred from screenshot */
  border-radius: var(--radius-full, 50px);
  text-transform: uppercase;
  letter-spacing: 0.5px; /* inferred from screenshot */
  display: inline-block;
}
```

#### Tag Badge (`.page_tag__t9Q6I`)
Used for categorizing projects or tech stack items, with a muted appearance.

```css
.page_tag__t9Q6I {
  background-color: var(--color-background-void, #080808); /* inferred from screenshot */
  color: var(--color-text-muted, #888888);
  font-family: 'Share Tech Mono', monospace;
  font-size: 10px; /* inferred from screenshot */
  font-weight: 400;
  padding: 4px 8px; /* inferred from screenshot */
  border: 1px solid var(--color-border-subtle, #1e1e1e);
  border-radius: var(--radius-full, 50px);
  text-transform: uppercase;
  letter-spacing: 0.5px; /* inferred from screenshot */
  display: inline-block;
  transition: background-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out),
              border-color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out),
              color var(--motion-duration-base, 0.2s) var(--motion-easing-standard, ease-in-out);
}

.page_tag__t9Q6I:hover {
  background-color: var(--color-background-card, #141414); /* inferred from screenshot */
  border-color: var(--color-primary, #c0392b); /* inferred from screenshot */
  color: var(--color-text-primary, #f0f0f0); /* inferred from screenshot */
}
```

#### Coming Soon Badge (`.page_labCardBadge__OU8M_`)
A specific badge for upcoming features, with a muted text and border.

```css
.page_labCardBadge__OU8M_ {
  background: none;
  color: var(--color-text-muted, #888888);
  font-family: 'Share Tech Mono', monospace;
  font-size: 10px; /* inferred from screenshot */
  font-weight: 400;
  padding: 4px 8px; /* inferred from screenshot */
  border: 1px solid var(--color-text-dim, #444444); /* inferred from screenshot */
  border-radius: 4px; /* inferred from screenshot */
  text-transform: uppercase;
  letter-spacing: 0.5px; /* inferred from screenshot */
  display: inline-block;
}
```

## 5. Layout Principles
-   **Spacing System**:
    -   Base unit: `4px`
    -   Scale: `0, 4, 8, 12, 16, 24, 32, 40, 80, 96` px
    -   Usage Context:
        -   `4px`: Smallest element spacing, e.g., icon to text, line-height adjustments.
        -   `8px`: Spacing between small components, padding for badges.
        -   `12px`: Padding inside buttons, vertical spacing for form elements.
        -   `16px`: Horizontal spacing for navigation links, padding for text inputs.
        -   `24px`: Vertical spacing between content blocks, padding around sections.
        -   `32px`: Padding inside cards, larger vertical gaps.
        -   `40px`: Horizontal padding for main content areas.
        -   `80px`: Large vertical section spacing.
        -   `96px`: Very large vertical section spacing, often for hero sections.
-   **Grid & Container** _Note: container widths and column counts are not extracted from the source. The values below are reasonable defaults inferred from the visible layout density._
    -   Max Width: `1280px` (inferred from screenshot)
    -   Columns: `12` (inferred from screenshot)
    -   Gutter: `24px` (inferred from screenshot)
    -   Section Padding: `80px 40px` (top/bottom, left/right)
-   **Whitespace Philosophy**: VaderLabz employs a generous use of dark whitespace (`background-void: #080808`) to create a sense of depth and focus