CLI · v0.1.2

# Pull a real design system into your terminal.

Extract colors, typography, spacing, breakpoints, and UI patterns from any production website into a portable `DESIGN.md`.


bash

```
$ npx @designmdcc/cli stripe.com > DESIGN.md
```

copy

One command. No setup required.

No login. No API key. No config.

Install · optional

## Want `dmd` available globally?

`npx` is the easiest first run — zero install, works in any terminal.
Install globally only if you want `dmd` always on your `PATH`.


```
$ npm install -g @designmdcc/cli
$ dmd stripe.com
```

copy

\# Some macOS setups may require `sudo` for global npm installs.

```
$ sudo npm install -g @designmdcc/cli
```

copy

\# Also works with pnpm, yarn, and bun. · Node 18+

Output

## What you get back.

A measured spec, not a vision-model guess. Colors come from computed styles,
typography from the cascade, breakpoints from live `@media` rules.


DESIGN.md · stripe.com [see full file →](https://designmd.cc/benchmarks/stripe)

\## Color Palette & Roles\### Primary
\- Brand Indigo(#0a2540)Hero typography, footer surface
\- Stripe Purple(#635bff)Primary buttons, focus rings, link accents\### Typography
\| Role \| Font \| Size \| Weight \| Line height \|
\|---------\|------------\|------\|--------\|-------------\|
\| Display \| Sohne Var \| 64px \| 600 \| 1.05 \|
\| H1 \| Sohne Var \| 40px \| 600 \| 1.15 \|
\| Body \| Sohne Var \| 18px \| 400 \| 1.6 \|
\| Code \| Sohne Mono \| 14px \| 400 \| 1.5 \|

\### Breakpoints(measured live)
480px · 600px · 768px · 880px · 1024px · 1200px · 1440px

Workflows

## Common workflows.

Three patterns that cover most use cases.


01Clone a production design language

```
$ npx @designmdcc/cli stripe.com > DESIGN.md
```

copy

→ Drop the file into Cursor or Claude Code, then ask:
"Rebuild this pricing section using the typography and spacing from DESIGN.md."

02Audit a competitor

```
$ dmd linear.app --json
```

copy

Token-only extraction. No LLM call. Pipe into `jq` for structured analysis.


03Create internal design memory

```
$ dmd yourcompany.com > DESIGN.md
```

copy

A versioned design reference that lives next to your code. Re-run when the brand changes.


Integrations

## Use it with Cursor or Claude Code.

Works directly with your existing AI coding workflow. Optional, but recommended.


Cursor

Claude Code

Windsurf

VSCode

GitHub Copilot

Cursor.cursor/rules

```
Before writing UI code, read DESIGN.md.
Use its color palette, type scale, and spacing values
exactly. Every brand value should trace back to the file.
```

copy

Claude CodeCLAUDE.md

```
When building UI in this project, reference @DESIGN.md.
That file contains the colors, typography, spacing, and
component patterns extracted from the source URL.
Do not invent brand values — read them from the file.
```

copy

Windsurfwindsurf.rules

```
When building UI in this project, read DESIGN.md.
Use the colors, typography, and spacing values it
specifies. Do not invent brand values.
```

copy

VSCode · GitHub Copilot.github/copilot-instructions.md

```
When generating UI code, read DESIGN.md from the
project root. Use the exact colors, typography, and
spacing it specifies. Treat the file as ground truth
for the brand.
```

copy

\# Copilot reads this file in any editor.

Full notes for Aider, Cline, Continue, and plain ChatGPT —
[on GitHub →](https://github.com/adityarajdigital/designmd/blob/main/docs/using-with-ai-tools.md)

Reference

## Advanced options.

You probably don't need these on day one. Run `dmd --help` for full descriptions.


$ dmd --help

Show all available commands and examples.

$ dmd --version

Print the installed CLI version.

$ dmd stripe.com --json

Output the raw structured design tokens as JSON. No LLM call.

$ dmd stripe.com --out ./design/stripe.md

Save the output to a custom location instead of stdout.

$ dmd stripe.com --force

Re-extract from the live page and bypass the cache.

$ dmd stripe.com --quiet

Hide progress logs. Only the output is printed.

Examples

## Production sites, measured live.

[![Stripe homepage screenshot](https://designmd.cc/benchmarks/stripe.jpg)\\
Stripe→](https://designmd.cc/benchmarks/stripe) [![Linear homepage screenshot](https://designmd.cc/benchmarks/linear.jpg)\\
Linear→](https://designmd.cc/benchmarks/linear) [![Vercel homepage screenshot](https://designmd.cc/benchmarks/vercel.jpg)\\
Vercel→](https://designmd.cc/benchmarks/vercel) [![Notion homepage screenshot](https://designmd.cc/benchmarks/notion.jpg)\\
Notion→](https://designmd.cc/benchmarks/notion)