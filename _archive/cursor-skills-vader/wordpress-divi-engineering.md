---
name: wordpress-divi-engineering
description: >-
  Universal WordPress and Divi 4 engineering — msc_ hooks, conditional asset
  loading, query standards, DiviGear integration, and delivery validation.
  Use when building or reviewing PHP themes, plugins, or child-theme modules.
---

# WordPress & Divi Engineering (Universal)

Pair with [studio-dark-shield.md](./studio-dark-shield.md) (Path A) and `.cursor/rules/studio-dark-ui.mdc` for visual tokens.

## Scope gate

- Apply when the active task is WordPress, Divi 4 (Classic Builder / `et_pb_*`), ACF, or child-theme PHP/CSS.
- For Next.js app shells (Tailwind/shadcn), defer to Path B in `studio-dark-shield.md` and `tailwind-shadcn-bridge.mdc`.
- For Electron or standalone Node apps, defer to `node-runtime-mastery.md` and root `.cursorrules`.

## Core identity

| Area | Rule |
|------|------|
| **PHP** | Prefix functions, classes, and hook callbacks with `msc_`. |
| **CSS** | Namespace custom selectors with `msc-` to avoid Divi/plugin collisions. |
| **Bootstrap** | Every PHP file: `defined( 'ABSPATH' ) || exit;` |
| **Media** | Use project-relative paths (e.g. `/media/...` or theme-relative URIs)—never machine-absolute paths. |

## Action & filter hook discipline

- **Single responsibility:** One `msc_` callback per concern; avoid stacking duplicate filters on the same tag.
- **Priority:** Document non-default priorities when order matters; prefer late enqueue (`wp_enqueue_scripts` priority ≥ 10) for front-end assets.
- **Conditional registration:** Register hooks inside `msc_bootstrap_*` loaders only when the feature is enabled (option flag or environment constant).
- **Remove on teardown:** Use `remove_action` / `remove_filter` when unregistering feature modules to prevent ghost hooks after deactivation.

## Studio Dark asset enqueue (Path A)

- Use `core/msc-assets.php` → `msc_enqueue_shield_satellite_chain()` (Shield → Layout → Components → Features → optional Extensions).
- Do not hand-enqueue only `msc-shield.css` unless you intentionally omit satellites.
- Set `MSC_SHIELD_EXTENSIONS=1` when glass/forms/motion packs are required.

## Theme Builder & asset bloat prevention

- **Conditional enqueue:** Load Divi module CSS/JS only on templates that render those modules—never globally `wp_enqueue_*` builder bundles site-wide unless required.
- **Admin isolation:** Keep dashboard/settings assets off `wp_enqueue_scripts` front-end; use `admin_enqueue_scripts` with screen ID checks.
- **Dependency chains:** Declare accurate `$deps` so WordPress does not reload duplicate jQuery/plugin bundles.
- **Defer & async:** Prefer `wp_script_add_data( ..., 'defer', true )` for non-critical front-end scripts when compatible.
- **No inline bloat:** Prefer module settings + custom CSS classes over large inline style blobs on Divi modules.
- **Native flows:** Prefer DiviGear / Filterable CPT native shortcode flows over Code-module hacks that intercept layout output.
- **No overrides:** If a legacy project uses a different established prefix, do not mass-rename without an explicit migration task. New MSC boilerplate work uses **`msc_`** (PHP) and **`msc-`** (CSS) only unless the operator directs otherwise.

## Security & data standards

- **Nonces:** Required for AJAX/REST mutations and privileged forms.
- **Queries:** Use `WP_Query` or high-level APIs—never `query_posts`.
- **Performance:** Set `'no_found_rows' => true` when pagination counts are unnecessary.
- **Portable schema:** Prefer `acf_add_local_field_group` (PHP) for mission-critical field groups over JSON-only imports.

## Divi integration patterns

- **Images:** Prefer Featured Image over duplicate ACF image fields unless art direction requires ACF-only sources.
- **Grids:** Enforce **16:9** thumbnails on project/show cards:

```css
.msc-show-card img,
.dg-cpt-image-wrap img {
  aspect-ratio: 16 / 9;
  object-fit: cover;
  width: 100%;
}
```

- **Filter pills (DiviGear):** Use design tokens (`--msc-accent`) or project filter color; keep transitions `0.2s ease-in-out`.

## Delivery checklist

1. Responsive at **375px** and **1024px**.
2. `loading="lazy"` on below-the-fold images.
3. Contrast ≥ **4.5:1** on dark backgrounds.
4. Meaningful `alt` text on semantic images.
5. Keyboard-visible `:focus-visible` on interactive controls.
