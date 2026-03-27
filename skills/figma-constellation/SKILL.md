---
name: figma-constellation
description: Bridge Figma MCP server tools with Zillow's Constellation design system. Translates Figma designs to Constellation React components/tokens and maps code components back to Figma nodes via Code Connect. Use when implementing Figma designs, reviewing Figma-to-code output, or linking Constellation components to Figma.
---

# Figma ↔ Constellation Bridge

Ensures all Figma-to-code output uses Constellation components, tokens, and patterns — and all code-to-Figma mappings reference the correct design system primitives.

## When to activate

- User pastes a Figma URL and asks to implement it
- User asks to connect Figma components to code (Code Connect)
- User asks to review/audit Figma-to-code output for design system compliance
- User asks to create a Figma file from existing Constellation code

## Quick workflow

### Figma → Code (most common)

1. **Extract context** — call `mcpFigma_getDesignContext` with `clientLanguages: "typescript"`, `clientFrameworks: "react"`
2. **Translate** — map every Figma element to a Constellation component using the mapping table in `references/figma-to-constellation-map.md`
3. **Apply rules** — enforce all rules from `custom_instruction/instructions.md` (audience, sizing, colors, required props)
4. **Validate** — run both validation scripts:
   ```bash
   bash .agents/skills/constellation-design-system/scripts/validate-constellation.sh client/src
   bash .agents/skills/constellation-icons/scripts/validate-icon-imports.sh client/src
   ```
5. **Fix violations** before delivery

### Code → Figma (Code Connect)

1. **Identify components** — list Constellation components used in the codebase
2. **Get suggestions** — call `mcpFigma_getCodeConnectSuggestions` with the target Figma node
3. **Map** — call `mcpFigma_addCodeConnectMap` for each component, using `label: "React"` and `clientFrameworks: "react"`
4. **Bulk save** — call `mcpFigma_sendCodeConnectMappings` with all approved mappings
5. See `references/code-to-design-workflow.md` for detailed scripts

## Translation rules (summary)

| Figma output | Constellation replacement |
|---|---|
| `<div>` with layout | `<Flex>`, `<Box>`, `<Grid>` from `@/styled-system/jsx` |
| `<button>` | `<Button>` / `<IconButton>` from `@zillow/constellation` |
| `<input>`, `<select>`, `<textarea>` | `<Input>`, `<Select>`, `<Textarea>` |
| `<img>` for property photos | `<PropertyCard>` with `saveButton` |
| Custom card `<div>` | `<Card tone="neutral">` (elevated or outlined) |
| `border-bottom` / `<hr>` | `<Divider />` |
| `<span>` / `<p>` for text | `<Text>` / `<Heading>` / `<Paragraph>` |
| Badge / label `<span>` | `<Tag>` with appropriate `tone` |
| Toggle / segmented | `<ToggleButtonGroup>` + `<ToggleButton>` |
| Custom icon SVG | `<Icon>` + verified `IconXxxFilled` from `@zillow/constellation-icons` |
| CSS `color: #0041D9` | `css={{ color: 'text.action.hero.default' }}` |
| CSS `background: #F7F7F7` | `css={{ background: 'bg.screen.neutral' }}` or `bg.subtle` |
| Tailwind classes | PandaCSS `css()` or `css={{}}` prop with design tokens |

Full mapping: `references/figma-to-constellation-map.md`

## Critical rules to enforce on every translation

1. **Icons** — NEVER guess names. Verify with:
   ```bash
   node --input-type=module -e "import * as m from '@zillow/constellation-icons'; Object.keys(m).filter(k=>k.toLowerCase().includes('KEYWORD')).forEach(k=>console.log(k))"
   ```
2. **PropertyCard** — ALWAYS add `saveButton={<PropertyCard.SaveButton />}`
3. **Card** — choose ONE of `elevated` or `outlined`, NEVER both; always `tone="neutral"`
4. **Tabs** — ALWAYS include `defaultSelected`
5. **Professional apps** — `size="sm"` for buttons/inputs/tables; max `heading-md`
6. **No light blue backgrounds** — use `bg.screen.neutral` (white) or gray
7. **No CSS borders for dividers** — use `<Divider />`
8. **Filled icons only** (no Outline as default)
9. **Sentence case** for all UI text
10. **Modal** — content in `body` prop, not children; always include `dividers`

## Reference files

- `references/figma-to-constellation-map.md` — comprehensive element-by-element mapping table
- `references/code-to-design-workflow.md` — Code Connect scripts and workflows
- `references/plugin-api-rules.md` — Figma Plugin API critical rules and gotchas
