---
name: Linear
url: https://linear.app/
colors:
  primary: '#6366f1'
  background: '#ffffff'
  text-primary: '#62666d'
  surface: '#f7f8f8'
  accent: '#eb5757'
  text-inverse: '#f7f8f8'
  text-muted: '#8a8f98'
  border: '#e5e5e6'
typography:
  display:
    family: 'Inter Variable'
    size: 64px
    weight: 700
    line-height: 1.2
  body:
    family: 'Inter Variable'
    size: 16px
    weight: 400
    line-height: 1.5
spacing:
  base: 4px
  scale: [0, 4, 8, 12, 16, 20, 24, 32]
radius:
  sm: 2px
  md: 4px
  lg: 12px
  full: 9999px
elevation:
  card: 'rgba(0, 0, 0, 0.03) 0px 1.2px 0px 0px'
  hover: 'rgba(0, 0, 0, 0.4) 0px 2px 4px 0px'
components:
  button-primary:
    bg: '{colors.primary}'
    text: '{colors.text-inverse}'
    radius: '{radius.md}'
    padding: '12px 24px'
  card:
    bg: '{colors.surface}'
    radius: '{radius.md}'
    shadow: '{elevation.card}'
---

# Design System Inspired by Linear

## 1. Visual Theme & Atmosphere
Linear features a modern interface characterized by a dark background (#0f1011) contrasted with light text (#f7f8f8) and vibrant accents (#6366f1, #eb5757). The typography is primarily set in "Inter Variable," emphasizing clarity and readability with a consistent hierarchy. The layout is spacious, allowing for clear delineation of sections and elements, enhancing user focus on content.

Key Characteristics:
- Dark background (#0f1011) with light text (#f7f8f8).
- Accent colors include #6366f1 and #eb5757.
- Typography uses "Inter Variable" for all text.
- Spacing is generous, with a base unit of 4px.
- Rounded corners with a radius of 12px for cards.

## 2. Color Palette & Roles
- **Primary**:
  - Primary (#6366f1) — used for buttons and highlights.
- **Accent Colors**:
  - Accent Red (#eb5757) — used for alerts and important highlights.
  - Accent Purple (#8b5cf6) — used for secondary highlights.
  - Accent Blue (#5e6ad2) — used for links and interactive elements.
- **Interactive**:
  - Hover State (#ffffff) — button text color on hover.
- **Neutral Scale**:
  - Light Background (#ffffff) — primary background color.
  - Dark Background (#0f1011) — used for dark mode elements.
  - Text Color (#62666d) — primary text color.
  - Muted Text (#8a8f98) — secondary text color.
- **Surface & Borders**:
  - Surface Color (#f7f8f8) — used for card backgrounds.
  - Border Color (#e5e5e6) — subtle borders on elements.

## 3. Typography Rules
- **Font Family**: 
  - Primary: 'Inter Variable', sans-serif; fallback: Arial, sans-serif.
  - Monospace: 'Berkeley Mono', monospace; fallback: monospace.
  
| Role     | Font               | Size   | Weight | Line Height | Letter Spacing | Notes          |
|----------|--------------------|--------|--------|-------------|----------------|----------------|
| Display  | Inter Variable      | 64px   | 700    | 1.2         | 0              | Main headings   |
| H1       | Inter Variable      | 48px   | 700    | 1.2         | 0              | Major titles    |
| H2       | Inter Variable      | 24px   | 700    | 1.2         | 0              | Section titles   |
| H3       | Inter Variable      | 20px   | 400    | 1.5         | 0              | Subsections     |
| Body     | Inter Variable      | 16px   | 400    | 1.5         | 0              | Main text       |
| Small    | Inter Variable      | 15px   | 400    | 1.5         | 0              | Small text      |
| Code     | Berkeley Mono       | 13px   | 400    | 1.5         | 0              | Code snippets    |

- **Principles**:
  - Maintain a clear hierarchy using defined font sizes.
  - Use consistent line heights for readability.
  - Prioritize legibility with sans-serif fonts for body text.

## 4. Component Stylings

### Buttons
The primary button features a bold color with rounded edges, inviting interaction.

```css
.button-primary {
  background: {colors.primary};
  color: {colors.text-inverse};
  font-family: 'Inter Variable';
  font-size: 16px;
  font-weight: 700;
  padding: 12px 24px;
  border: none;
  border-radius: {radius.md};
  transition: background-color 0.2s cubic-bezier(0.25, 1, 0.5, 1);
}

.button-primary:hover {
  background: {colors.accent}; /* inferred from screenshot */
}
```

### Cards
Cards are designed with a subtle shadow and rounded edges, providing a clean and modern look.

```css
.card {
  background: {colors.surface};
  color: {colors.text-primary};
  font-family: 'Inter Variable';
  font-size: 16px;
  padding: 16px;
  border: none;
  border-radius: {radius.md};
  box-shadow: {elevation.card};
  transition: box-shadow 0.2s ease-in-out;
}

.card:hover {
  box-shadow: {elevation.hover}; /* inferred from screenshot */
}
```

### Inputs
Text inputs feature a clear and simple design, with a focus on usability.

```css
.input {
  background: {colors.background};
  color: {colors.text-primary};
  font-family: 'Inter Variable';
  font-size: 16px;
  padding: 12px;
  border: 1px solid {colors.border};
  border-radius: {radius.sm};
  transition: border-color 0.2s ease-in-out;
}

.input:focus {
  border-color: {colors.primary};
  outline: none;
}

.input:disabled {
  cursor: not-allowed;
}
```

### Navigation
The top navigation bar is designed for clarity and ease of use, with clear hover states.

```css
.nav {
  background: {colors.background};
  display: flex;
  padding: 16px;
  border-bottom: 1px solid {colors.border};
}

.nav-link {
  color: {colors.text-primary};
  padding: 12px 16px;
  text-decoration: none;
  transition: color 0.2s ease-in-out;
}

.nav-link:hover {
  color: {colors.primary};
}
```

## 5. Layout Principles
- **Spacing System**: Base unit 4px → [0, 4, 8, 12, 16, 20, 24, 32]. 
  - Usage Context: 
    - 4px for small margins.
    - 12px for card padding.
    - 24px for section spacing.
  
- **Grid & Container**: 
  - _Note: container widths and column counts are not extracted from the source. The values below are reasonable defaults inferred from the visible layout density._
  - Max width: 1200px, Columns: 12, Gutter: 16px.

- **Whitespace Philosophy**: Whitespace is utilized to create visual separation between elements, enhancing readability and focus.

- **Border Radius Scale**: 
  - Small: 2px (buttons)
  - Medium: 4px (inputs)
  - Large: 12px (cards)
  - Full: 9999px (pill-shaped elements)

## 6. Depth & Elevation
| Level | Treatment                               | Use                  |
|-------|-----------------------------------------|----------------------|
| z-0   | None                                    | Base elements        |
| z-1   | {elevation.card}                       | Cards                |
| z-3   | {elevation.hover}                      | Hover effects        |
| z-50  | {elevation.hover}                      | Navigation bar       |
| z-100 | {elevation.hover}                      | Modals               |

Shadow Philosophy: Shadows are used subtly to create depth, enhancing the visual hierarchy without overwhelming the design.

## 7. Do's and Don'ts

### Do's
- Use #6366f1 for primary buttons; never use a different color.
- Maintain 12px padding in cards for consistency.
- Apply a 4px border radius to inputs for a softer look.
- Keep text at 16px for body copy; avoid smaller sizes.
- Use #62666d for primary text on light backgrounds.

### Don'ts
- Don’t mix font sizes; use only the defined sizes (16px, 24px).
- Avoid using #ffffff for text on light backgrounds; use #62666d instead.
- Don't use inconsistent spacing; stick to the 4px base unit.
- Never use sharp corners; always apply a radius to buttons and cards.
- Avoid low contrast combinations; ensure text is readable against backgrounds.

## 8. Responsive Behavior
| Breakpoint Name     | Width   | Key Changes                     |
|---------------------|---------|---------------------------------|
| Mobile Small        | 600px   | Stack navigation links          |
| Mobile Large        | 640px   | Adjust button sizes             |
| Tablet              | 768px   | Change layout to two columns    |
| Desktop             | 1280px  | Full-width layout               |
| Desktop Large       | 1440px  | Increase padding and margins     |

- **Touch Targets**: Minimum sizes for buttons should be 44px x 44px.
- **Collapsing Strategy**: 
  - Navigation: Collapse links into a hamburger menu on mobile.
  - Cards: Stack vertically on smaller screens.
  - Typography: Reduce font sizes for mobile devices.

## 9. Agent Prompt Guide
- **Quick Color Reference**:
  - Primary: #6366f1
  - Background: #ffffff
  - Text Primary: #62666d
  - Surface: #f7f8f8

- **Iteration Guide**:
  1. Always use #6366f1 for primary buttons.
  2. Maintain a font size of 16px for body text.
  3. Use 12px padding for card components.
  4. Apply a border radius of 4px for input fields.
  5. Ensure all text is legible against backgrounds.
  6. Use consistent spacing based on the 4px scale.
  7. Keep hover effects subtle with a transition duration of 0.2s.
  8. Ensure navigation links are at least 44px in height for touch targets.
  9. Utilize #62666d for text on light backgrounds.
  10. Maintain a maximum width of 1200px for main content areas.