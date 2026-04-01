# Constellation Quick Reference

One-page cheat sheet for the most critical rules, component selection, and tokens.

## Component Selection

| Building this? | Use this | Not this |
|---|---|---|
| Property listing | `PropertyCard` + `saveButton` | `Card` |
| Generic container (clickable) | `Card elevated interactive tone="neutral"` | `Box` |
| Generic container (static) | `Card outlined elevated={false} tone="neutral"` | `Box` with border |
| Sticky header | `Flex` inside `Box` with `display: 'flow-root'` | `position: sticky` on `Page.Header` |
| Non-sticky header | `Page.Header` inside `Page.Root` | `Box` / `Flex` |
| Content separator | `<Divider />` | CSS `border` |
| Header edge line | `borderBottom: "default"` + `borderColor: "border.muted"` on the header `Box` | `<Divider />` as child |
| Single select (price, beds) | `ToggleButtonGroup` + `ToggleButton` | `Button` |
| Segmented choices | `ToggleButtonGroup` + `ToggleButton` | `Button` group |
| Multi-select | `ComboBox` or `CheckboxGroup` | `Button` |
| Page headline (1-2 max) | `<Heading textStyle="heading-lg">` (consumer) or `<Heading textStyle="heading-md">` (professional) | Multiple `Heading` |
| Section title | `<Text textStyle="body-lg-bold">` | `Heading` |
| Card title | `<Text textStyle="body-bold">` | `Heading` |
| Body text | `<Text textStyle="body">` | `<p>` / `<span>` |
| Description/hint | `<Text textStyle="body-sm">` + `color="text.subtle"` | raw text |
| Labels/badges | `<Tag>` — sentence case only, never line-wrap | custom `Box` |
| Icon-only button | `<IconButton title="..." tone="neutral" emphasis="bare">` | `<Button icon={...}>` |
| Dialog | `<Modal header={} body={} footer={} dividers />` | custom overlay |

## Spacing & Typography

For complete audience-specific spacing tokens, typography hierarchy, and table patterns, load:
- **consumer-brand-guidelines** skill — for consumer apps
- **professional-brand-guidelines** skill — for professional apps (standard + compact + dense modes)

Key differences at a glance:

| Context | Consumer | Professional |
|---|---|---|
| Page headline | `<Heading textStyle="heading-lg">` | `<Heading textStyle="heading-md">` |
| Card padding | `400` (16px) | `300` (12px) |
| Grid gaps | `400` (16px) | `300` (12px) |
| Component sizing | `size="md"` (default) | `size="sm"` (always) |

## Layout Stacking Rules

### Flex defaults to ROW — not column

`<Flex>` from `@/styled-system/jsx` defaults to `flexDirection: "row"` (CSS default). If you want vertical stacking, you MUST specify `direction="column"`. Forgetting this is the #1 cause of content appearing side-by-side instead of stacked.

**Use the right component for the job:**

| Intent | Use | NOT |
|--------|-----|-----|
| Stack content vertically | `<Flex direction="column">` or `<VStack>` or `<Stack>` | `<Flex>` (defaults to row) |
| Lay out content horizontally | `<Flex>` or `<HStack>` | `<Flex direction="row">` (works but verbose) |

`VStack`, `HStack`, and `Stack` are available from `@/styled-system/jsx` and have safe defaults:
- `VStack` → `flexDirection: "column"`, `gap: "8px"`, `alignItems: "center"`
- `HStack` → `flexDirection: "row"`, `gap: "8px"`, `alignItems: "center"`
- `Stack` → `flexDirection: "column"`, `gap: "8px"` (no alignItems default)

### Text is inline by default

Constellation's `Text` component renders as an inline `<span>` by default. When you place two `Text` elements as siblings, they will run together on the same line instead of stacking vertically.

`Heading` renders as a block-level element and does not have this issue.

**WRONG — text runs together:**
```tsx
<Text>Google Drive Connected</Text>
<Text>Folder ID: abc123</Text>
{/* Renders: "Google Drive ConnectedFolder ID: abc123" */}
```

**CORRECT — use a vertical flex container:**
```tsx
<Flex direction="column" gap="200">
  <Text>Google Drive Connected</Text>
  <Text>Folder ID: abc123</Text>
</Flex>
```

**Also correct — use VStack:**
```tsx
<VStack gap="200" align="flex-start">
  <Text>Google Drive Connected</Text>
  <Text>Folder ID: abc123</Text>
</VStack>
```

**Also correct — make Text block-level:**
```tsx
<Text css={{ display: "block" }}>Google Drive Connected</Text>
<Text css={{ display: "block" }}>Folder ID: abc123</Text>
```

## Icon Rules

- ALWAYS use **Filled** variants: `IconHeartFilled` not `IconHeartOutline`
- ALWAYS wrap in `<Icon size="sm|md|lg|xl">`
- ALWAYS use `css` prop for colors: `<Icon css={{ color: 'icon.neutral' }}>`
- NEVER use `color` prop with token paths
- NEVER guess icon names — verify with the lookup table or search command below

## Icon Lookup

For the full icon lookup table (50+ concepts with correct names and wrong guesses), load the **constellation-icons** skill. Quick essentials:

| Concept | Correct Name |
|---|---|
| Home | `IconHomesFilled` (NOT ~~IconHouseFilled~~) |
| Close | `IconCloseFilled` (NOT ~~IconXFilled~~) |
| Check | `IconCheckmarkFilled` (NOT ~~IconCheckFilled~~) |
| Add | `IconPlusFilled` (NOT ~~IconAddFilled~~) |
| Star | `IconStar100Percent` (NOT ~~IconStarFilled~~) |
| Share | `IconShareWebFilled` (NOT ~~IconShareFilled~~) |

**Quick icon search:**
```bash
node --input-type=module -e "import * as m from '@zillow/constellation-icons'; Object.keys(m).filter(k=>k.toLowerCase().includes('KEYWORD')).forEach(k=>console.log(k))"
```

## Card Rules

| Style | Props | When |
|---|---|---|
| Clickable | `elevated interactive tone="neutral"` | Links, navigation, actions |
| Static | `outlined elevated={false} tone="neutral"` | Info panels, read-only |
| Minimal | `elevated={false} tone="neutral"` | Subtle containers |

NEVER combine `elevated` and `outlined` on the same card.

## Modal Rules

- ALWAYS use `body` prop for content (NEVER children)
- ALWAYS use `footer` for action buttons
- ALWAYS include `dividers` prop
- ALWAYS default to `size="md"`

## Color Rules

For audience-specific color palettes, load the **consumer-brand-guidelines** or **professional-brand-guidelines** skill. Universal rules:

- Max **25% bold color** per viewport (hero sections are the only exception)
- NEVER stack colored sections back-to-back — alternate with neutral (white/gray)
- Blue (#0041D9) is for interactive elements ONLY — never headlines or decoration
- Heroes ONLY on homepages, marketing landing pages, and welcome/onboarding screens
- Use **illustrations** to bring color into the experience instead of colored backgrounds

## Header Containment

- ALWAYS add `maxWidth: "breakpoint-xxl", mx: "auto"` on the header's inner Flex to match page content width
- Use Constellation breakpoint size tokens (`breakpoint-sm` / `breakpoint-md` / `breakpoint-lg` / `breakpoint-xl` / `breakpoint-xxl`) — NEVER hardcode pixel values
- The sticky `Box` wrapper stays full-bleed for the background color
- Adjust the breakpoint token to match your page content's `maxWidth`

## Logo Sizing

| Context | Height |
|---|---|
| Desktop | 24px |
| Mobile | 16px |

## Common Imports

```tsx
import { Button, Card, Text, Heading, Input, Tabs, Divider, Modal, Tag, Icon, IconButton } from '@zillow/constellation';
import { IconHeartFilled, IconSearchFilled } from '@zillow/constellation-icons';
import { css } from '@/styled-system/css';
import { Box, Flex, Grid } from '@/styled-system/jsx';
```

## Validation Script

Run to check for common violations:
```bash
bash .agents/skills/constellation-design-system/scripts/validate-constellation.sh ./client/src
```
