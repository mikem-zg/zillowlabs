---
name: transition-to-constellation
description: Migrate any React frontend to Zillow's Constellation Design System v10.13.0. Includes automated codebase analysis, component migration recipes, side-by-side coexistence strategy, validation scripts, and all v10.13.0 tarballs for offline installation.
license: Proprietary
compatibility: Requires a React 18+ project. Will install @zillow/constellation and @pandacss/dev.
metadata:
  author: Zillow Group
  version: "10.13.0"
---

# Transition to Constellation (v10.13.0)

This skill handles **analyzing, migrating, and validating** a React frontend's transition to Zillow's Constellation Design System. It supports migration from Tailwind, shadcn/ui, Material UI, Chakra UI, Ant Design, vanilla CSS, or any combination.

## Prerequisites

- React 18+ project with an existing frontend to migrate
- Node.js 18+ and npm/pnpm available
- `bash` shell for running analysis and validation scripts

## When to Use

- Migrating an existing React app to Constellation incrementally (page-by-page)
- Running the codebase analysis script to inventory current components and styling
- Looking up component migration recipes (e.g., MUI Button → Constellation Button)
- Validating migration progress with the validation script

## When NOT to Use

- **App has heavy design debt or fewer than 15 screens** — use `transition-to-constellation-from-scratch` for a clean-slate rebuild instead
- **Constellation is already installed and you're building new UI** — use `constellation-design-system`
- **Looking up icon names, illustrations, or dark mode** — use the specialized Constellation skills

**After installation is complete**, use the related Constellation skills for building UI:

- **[constellation-design-system](../constellation-design-system/SKILL.md)**: Core design system rules, all 99 component docs, UX writing guidelines, and layout patterns
- **[constellation-icons](../constellation-icons/SKILL.md)**: Full catalog of 621 icons with color tokens, sizing, and implementation guides
- **[constellation-illustrations](../constellation-illustrations/SKILL.md)**: 99 spot illustrations with light/dark mode SVG paths for empty states, onboarding, and storytelling
- **[constellation-dark-mode](../constellation-dark-mode/SKILL.md)**: Theme injection, dark mode toggle patterns, and design token tiers

## Migration Program (How a Team Does This)

```
1. Audit       → Run analyze-codebase.sh to inventory every component, icon, and styling pattern
2. Install     → Add Constellation packages alongside existing libraries (coexistence)
3. Pilot page  → Convert one simple page end-to-end using the recipes and checklist
4. Scale       → Roll out page-by-page using the same checklist, simplest to most complex
5. Validate    → Run validate-migration.sh after each page to catch remnants
6. Clean up    → Remove old dependencies, configs, and component files when zero imports remain
```

## Quick Start

### Step 1: Analyze

```bash
bash .agents/skills/transition-to-constellation/references/scripts/analyze-codebase.sh src
```

Output: `migration-report.md` with current stack detection, file counts per library, component-to-Constellation mapping, and a suggested migration order.

### Step 2: Install Constellation

See: [Installation Guide](references/guides/installation.md) for package setup, PandaCSS config, theme injection, and aliases.

### Step 3: Convert page by page

For each page, follow the [Page Migration Checklist](references/guides/page-migration-checklist.md) and reference the component recipes below.

**Conversion order:**
1. App shell (header, footer, sidebar) — establishes the Constellation foundation
2. Simplest pages first (about, settings, static content)
3. Form-heavy pages (login, registration, profile edit)
4. Data-heavy pages (dashboards, tables, lists)
5. Complex interactive pages (search, filters, property detail)

### Step 4: Validate

```bash
bash .agents/skills/transition-to-constellation/references/scripts/validate-migration.sh src
```

## Component Migration Recipes

Each recipe shows before/after code for migrating from shadcn, MUI, Chakra, and Tailwind to Constellation. Includes required props, anti-patterns, variants, and edge cases.

| Recipe | What It Covers |
|--------|---------------|
| [Button](references/recipes/button.md) | Button, IconButton, TextButton, ButtonGroup — primary/secondary/destructive, icon placement |
| [Card](references/recipes/card.md) | Card — elevated+interactive vs outlined+static vs minimal, tone="neutral" |
| [Modal](references/recipes/modal.md) | Modal — body prop (not children), header/footer, dividers, ButtonGroup |
| [Tabs](references/recipes/tabs.md) | Tabs — defaultSelected (not defaultValue), controlled/uncontrolled |
| [Form Fields](references/recipes/form-fields.md) | Input, LabeledInput, Select, Checkbox, Radio, Switch, Textarea, FormField |
| [Table](references/recipes/table.md) | Table.Root/Header/Body/Row/Cell/HeaderCell |
| [Icon](references/recipes/icon.md) | Icon wrapper, Filled variants, css prop for color, 120+ icon mappings |
| [Divider](references/recipes/divider.md) | Divider — replacing CSS borders, hr, styled dividers |
| [Page Header](references/recipes/page-header.md) | Page.Root, Page.Header, Page.Content — replacing custom navs/app bars |
| [PropertyCard](references/recipes/property-card.md) | PropertyCard — saveButton, data areas, HomeDetails, address format |
| [Tag / Badge](references/recipes/tag-badge.md) | Tag, AssistChip, FilterChip, InputChip — replacing Badge/Chip/custom labels |
| [Combobox / Search](references/recipes/combobox-search.md) | Combobox — replacing Autocomplete, Command, react-select |

## Migration Guides

| Guide | Purpose |
|-------|---------|
| [Installation Guide](references/guides/installation.md) | Install packages, configure PandaCSS, set up themes and aliases |
| [Conversion Guide](references/guides/converting-to-constellation.md) | Full migration playbook with coexistence strategy and automated tools |
| [Page Migration Checklist](references/guides/page-migration-checklist.md) | Copy-paste checklist for each page conversion |
| [Common Pitfalls](references/guides/common-pitfalls.md) | 30 known gotchas with wrong/correct code examples |
| [Component Decision Tree](references/guides/component-decision-tree.md) | "I need X" → "Use Y" — find the right component for any pattern |

## Automated Tools

| Tool | Purpose |
|------|---------|
| [Analysis Script](references/scripts/analyze-codebase.sh) | Scan codebase and generate migration report |
| [Validation Script](references/scripts/validate-migration.sh) | Check migration completeness and catch remnants |
| `tw2panda` | Convert Tailwind classes → PandaCSS (see [Conversion Guide](references/guides/converting-to-constellation.md)) |
| `jscodeshift` | AST-based icon/component transforms (see [Conversion Guide](references/guides/converting-to-constellation.md)) |

## Bundled Packages (v10.13.0)

All tarballs are in `packages/` for offline or Replit installation:

| Package | File |
|---------|------|
| `@zillow/constellation` | `packages/constellation-10.13.0.tgz` |
| `@zillow/constellation-icons` | `packages/constellation-icons-10.13.0.tgz` |
| `@zillow/constellation-tokens` | `packages/constellation-tokens-10.13.0.tgz` |
| `@zillow/constellation-fonts` | `packages/constellation-fonts-10.13.0.tgz` |
| `@zillow/constellation-config` | `packages/constellation-config-10.13.0.tgz` |
| `@zillow/constellation-mcp` | `packages/constellation-mcp-10.13.0.tgz` |
| `@zillow/yield-callback` | `packages/yield-callback-1.4.0.tgz` |

## Key Decisions

- **Always use `constellationPandaConfig`** (not `constellationPandaPreset` with `defineConfig`) — the preset alone lacks required PandaCSS plugins
- **Gradual migration over big-bang** — coexistence is supported for all major libraries
- **Automate the mechanical parts** — icon renames, Tailwind class conversion, and import swaps can be scripted
- **Validate continuously** — run the validation script after each page to track progress
- **Recipes over mapping tables** — detailed before/after recipes are more useful than abstract component lists
- **Pilot one page first** — prove the pattern works on a simple page before scaling to the whole app
