# Constellation Quick Reference

One-page cheat sheet for the most critical rules, component selection, and tokens.

## Component Selection

| Building this? | Use this | Not this |
|---|---|---|
| Property listing | `PropertyCard` + `saveButton` | `Card` |
| Generic container (clickable) | `Card elevated interactive tone="neutral"` | `Box` |
| Generic container (static) | `Card outlined elevated={false} tone="neutral"` | `Box` with border |
| Page header | `Page.Header` inside `Page.Root` | `Box` / `Flex` |
| Visual separator | `<Divider />` | CSS `border` |
| Single select (price, beds) | `ToggleButtonGroup` + `ToggleButton` | `Button` |
| Segmented choices | `SegmentedControl` | `Button` group |
| Multi-select | `ComboBox` or `CheckboxGroup` | `Button` |
| Page headline (1-2 max) | `<Heading textStyle="heading-lg">` | Multiple `Heading` |
| Section title | `<Text textStyle="body-lg-bold">` | `Heading` |
| Card title | `<Text textStyle="body-bold">` | `Heading` |
| Body text | `<Text textStyle="body">` | `<p>` / `<span>` |
| Description/hint | `<Text textStyle="body-sm">` + `color="text.subtle"` | raw text |
| Labels/badges | `<Tag>` | custom `Box` |
| Icon-only button | `<IconButton title="..." tone="neutral" emphasis="bare">` | `<Button icon={...}>` |
| Dialog | `<Modal header={} body={} footer={} dividers />` | custom overlay |

## Spacing Tokens

| Context | Token | Value |
|---|---|---|
| Page padding (sides) | `400` | 16px |
| Page padding (top/bottom) | `600` | 24px |
| Section gaps | `800` | 32px |
| Card internal padding | `400` | 16px |
| Grid gaps | `400` | 16px |
| Tight list spacing | `200` | 8px |
| Comfortable list spacing | `300` | 12px |

## Typography Hierarchy

| Content | Component | Color |
|---|---|---|
| Page headline | `<Heading textStyle="heading-lg">` | default |
| Section title | `<Text textStyle="body-lg-bold">` | default |
| Card title | `<Text textStyle="body-bold">` | default |
| Description | `<Text textStyle="body">` | `text.subtle` |
| Fine print | `<Text textStyle="body-sm">` | `text.subtle` |

## Icon Rules

- ALWAYS use **Filled** variants: `IconHeartFilled` not `IconHeartOutline`
- ALWAYS wrap in `<Icon size="sm|md|lg|xl">`
- ALWAYS use `css` prop for colors: `<Icon css={{ color: 'icon.neutral' }}>`
- NEVER use `color` prop with token paths

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

## Professional App Colors

| Use | Color |
|---|---|
| Primary actions | Blue (#0041D9) |
| Text | Granite (#111116) |
| Section backgrounds | Light Gray (#F7F7F7) |
| Accent (sparingly) | Waterfront (Navy), Pool (Light Blue) |
| NEVER | Purple, Orange, vibrant Teal |

## Consumer App Colors

| Use | Color |
|---|---|
| Actions | Blue (#0041D9) |
| Accents | Full palette — Teal, Orange, Purple OK |
| Backgrounds | White or Gray only |
| NEVER | Light blue backgrounds |

## Color in Product

- Max **25% bold color** per viewport. Hero sections are the only exception.
- NEVER stack colored sections back-to-back. Alternate with neutral (white/gray).
- Only **teal or purple** for colored card/section backgrounds. NEVER navy, light blue, or pastel.
- Heroes ONLY on homepages, marketing landing pages, and welcome/onboarding screens.
- Use **illustrations** to bring color into the experience instead of colored backgrounds.

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
