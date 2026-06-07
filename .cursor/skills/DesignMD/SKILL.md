# DesignMD Skill Pack

Extract and apply production design systems using `@designmdcc/cli`.

## Capabilities
- Extract design tokens (colors, typography, spacing) from any URL.
- Apply extracted design systems to new or existing UI components.
- Maintain a canonical "Design Memory" for the project.

## Workflow
1. **Extraction**: `npx @designmdcc/cli <url> --out .cursor/DesignMD/DESIGN-<NAME>.md`
2. **Application**: When building UI, read the relevant file in `.cursor/DesignMD/` and treat it as the "Design Source of Truth".

## Rules
- NEVER invent brand values if a `DESIGN-*.md` file exists.
- Always use `8px` rhythm and `16:9` cinematic grid (NovaMira standard) unless the extracted design specifies otherwise.
- Store all extractions in `.cursor/DesignMD/`.
