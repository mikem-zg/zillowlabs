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
| Visual separator | `<Divider />` | CSS `border` |
| Single select (price, beds) | `ToggleButtonGroup` + `ToggleButton` | `Button` |
| Segmented choices | `SegmentedControl` | `Button` group |
| Multi-select | `ComboBox` or `CheckboxGroup` | `Button` |
| Page headline (1-2 max) | `<Heading textStyle="heading-lg">` (consumer) or `<Heading textStyle="heading-md">` (professional) | Multiple `Heading` |
| Section title | `<Text textStyle="body-lg-bold">` | `Heading` |
| Card title | `<Text textStyle="body-bold">` | `Heading` |
| Body text | `<Text textStyle="body">` | `<p>` / `<span>` |
| Description/hint | `<Text textStyle="body-sm">` + `color="text.subtle"` | raw text |
| Labels/badges | `<Tag>` | custom `Box` |
| Icon-only button | `<IconButton title="..." tone="neutral" emphasis="bare">` | `<Button icon={...}>` |
| Dialog | `<Modal header={} body={} footer={} dividers />` | custom overlay |

## Spacing Tokens

### Consumer

| Context | Token | Value |
|---|---|---|
| Page padding (sides) | `400` | 16px |
| Page padding (top/bottom) | `600` | 24px |
| Section gaps | `800` | 32px |
| Card internal padding | `400` | 16px |
| Grid gaps | `400` | 16px |
| Tight list spacing | `200` | 8px |
| Comfortable list spacing | `300` | 12px |

### Professional (standard)

| Context | Token | Value | Consumer comparison |
|---|---|---|---|
| Page padding (sides) | `400` | 16px | same |
| Page padding (top/bottom) | `600` | 24px | same |
| Section gaps | `800` | 32px | same |
| Card internal padding | `300` | 12px | consumer uses `400` (16px) |
| Internal card element gaps | `200` | 8px | consumer uses `300` (12px) |
| Grid gaps between cards | `300` | 12px | consumer uses `400` (16px) |
| Tight list spacing | `200` | 8px | same |

### Professional (dense)

Use in data-heavy dashboards, tables, and compact card grids:

| Context | Token | Value |
|---|---|---|
| Section gaps | `400` | 16px |
| Card internal padding | `300` | 12px |
| Grid gaps | `200` | 8px |
| Tab panel padding | `300` | 12px |

## Typography Hierarchy

### Consumer

| Content | Component | Color |
|---|---|---|
| Page headline | `<Heading textStyle="heading-lg">` | default |
| Section title | `<Text textStyle="body-lg-bold">` | default |
| Card title | `<Text textStyle="body-bold">` | default |
| Description | `<Text textStyle="body">` | `text.subtle` |
| Fine print | `<Text textStyle="body-sm">` | `text.subtle` |

### Professional

| Content | Component | Color |
|---|---|---|
| Page headline | `<Heading textStyle="heading-md">` | default |
| Stat/metric value | `<Text textStyle="heading-xs">` | default |
| Section title | `<Text textStyle="body-lg-bold">` | default |
| Card title | `<Text textStyle="body-bold">` | default |
| Description | `<Text textStyle="body">` | `text.subtle` |
| Fine print | `<Text textStyle="body-sm">` | `text.subtle` |

### Professional Compact Contexts

For tables, dense cards, and sidebar content. **Tables default to `appearance="horizontal"` and `size="sm"`. All elements inside tables inherit `sm` sizing — do NOT override individual elements back to `md`.**

| Content | Component | Notes |
|---|---|---|
| Table root | `<Table.Root appearance="horizontal" size="sm">` | Horizontal lines, compact rows |
| Table cell label | `<Text textStyle="body-sm" css={{ fontWeight: 600 }}>` | Bold small text for headers/labels |
| Table cell value | `<Text textStyle="body-sm">` | Regular weight |
| Table cell icon | `<Icon size="sm">` | 16px icons inside table rows |
| Table cell badge | `<Tag size="sm">` | Small tags for status/category |
| Table cell button | `<Button size="sm">` | Small buttons for row actions |
| Table cell icon button | `<IconButton size="sm">` | Small icon-only actions |
| Dense card label | `<Text textStyle="body-sm" css={{ fontWeight: 600 }}>` | Bold small text |

Table `appearance` options: `horizontal` (default for professional), `grid` (bordered cells), `bare` (no lines), `zebra` (alternating rows).

## Text Component Display Behavior

Constellation's `Text` component renders as an inline `<span>` by default. When you place two `Text` elements as siblings, they will run together on the same line instead of stacking vertically.

To stack `Text` elements vertically, either add `css={{ display: "block" }}` to each `Text`, or wrap them in a `Flex direction="column"` or `Box` container.

`Heading` renders as a block-level element and does not have this issue.

## Icon Rules

- ALWAYS use **Filled** variants: `IconHeartFilled` not `IconHeartOutline`
- ALWAYS wrap in `<Icon size="sm|md|lg|xl">`
- ALWAYS use `css` prop for colors: `<Icon css={{ color: 'icon.neutral' }}>`
- NEVER use `color` prop with token paths
- NEVER guess icon names — verify with the lookup table or search command below

## Icon Lookup by Concept

Use this table to find the correct icon name for common UI concepts. Many intuitive names do NOT exist.

| Concept | Correct Icon Name | Wrong Guesses (do NOT exist) |
|---|---|---|
| Home | `IconHomesFilled` | ~~IconHomeFilled~~ |
| Search | `IconSearchFilled` | — |
| Heart / Favorite / Save | `IconHeartFilled` | ~~IconFavoriteFilled~~, ~~IconSaveFilled~~ |
| Close / Dismiss | `IconCloseFilled` | ~~IconXFilled~~, ~~IconCrossFilled~~ |
| Check / Done | `IconCheckmarkFilled` | ~~IconCheckFilled~~, ~~IconDoneFilled~~ |
| Check (in circle) | `IconCheckmarkCircleFilled` | — |
| Plus / Add | `IconPlusFilled` | ~~IconAddFilled~~ |
| Plus (in circle) | `IconPlusCircleFilled` | — |
| Minus | `IconMinusFilled` | ~~IconRemoveFilled~~ |
| Menu / Hamburger | `IconMenuFilled` | — |
| Settings | `IconSettingsFilled` | ~~IconSettingFilled~~, ~~IconGearFilled~~ |
| Edit / Pencil | `IconEditFilled` | ~~IconPencilFilled~~ |
| Delete / Trash | `IconDeleteFilled` | ~~IconTrashFilled~~ |
| Chat / Message | `IconMessageFilled` | ~~IconChatFilled~~ |
| Email / Mail | `IconMailFilled` | ~~IconEmailFilled~~ |
| Phone / Call | `IconPhoneFilled` | — |
| Notification / Bell | `IconNotificationFilled` | ~~IconBellFilled~~, ~~IconAlertFilled~~ |
| Star / Rating | `IconStar100Percent` (Special) | ~~IconStarFilled~~ |
| Share | `IconShareWebFilled` | ~~IconShareFilled~~ |
| Download | `IconDownloadFilled` | — |
| Upload | `IconUploadFilled` | — |
| Copy | `IconCopyFilled` | — |
| Send | `IconSendFilled` | — |
| Link | `IconLinkFilled` | — |
| Refresh / Reload | `IconReloadFilled` | ~~IconRefreshFilled~~ |
| Location / Pin | `IconLocationFilled` | ~~IconPinFilled~~ |
| Map | `IconMapFilled` | — |
| Calendar / Date | `IconCalendarFilled` | — |
| Clock / Time | `IconClockFilled` | ~~IconTimeFilled~~ |
| User / Profile | `IconUserFilled` or `IconProfileFilled` | ~~IconAccountFilled~~ |
| User Group / Team | `IconUserGroupFilled` | — |
| Filter | `IconFilterFilled` | — |
| Sort | `IconSortFilled` | — |
| List | `IconListBulletedFilled` | ~~IconListFilled~~ |
| Grid | `IconGridFilled` | — |
| Photo / Image | `IconPhotosFilled` | ~~IconImageFilled~~, ~~IconPhotoFilled~~ |
| Video | `IconVideoCameraFilled` | ~~IconVideoFilled~~ |
| Camera | `IconCameraFilled` | — |
| Microphone | `IconMicrophoneFilled` | ~~IconMicFilled~~ |
| Document / File | `IconFileFilled` | ~~IconDocumentFilled~~ |
| Folder | `IconFolderFilled` | — |
| Print | `IconPrintFilled` | — |
| Lock (closed) | `IconLockClosedFilled` | ~~IconLockFilled~~ |
| Lock (open) | `IconLockOpenFilled` | ~~IconUnlockFilled~~ |
| Info | `IconInfoFilled` | — |
| Warning | `IconWarningFilled` | — |
| Error | `IconErrorFilled` | — |
| Flag / Bookmark | `IconFlagFilled` | ~~IconBookmarkFilled~~ |
| Tag / Label | `IconTagFilled` | ~~IconLabelFilled~~ |
| Expand | `IconExpandFilled` | — |
| Fullscreen | `IconFullScreenFilled` | ~~IconFullscreenFilled~~ (capital S) |
| Trending / Chart | `IconTrendingFilled` | ~~IconChartFilled~~, ~~IconGraphFilled~~ |
| AI / Magic / Sparkle | `IconAIMagicFilled` or `IconSparkleFilled` | — |
| Visibility / Eye | `IconStreetViewFilled` | ~~IconEyeFilled~~, ~~IconViewFilled~~ |
| Arrow (directional) | `IconArrowUpFilled`, `IconArrowDownFilled`, `IconArrowLeftFilled`, `IconArrowRightFilled` | — |
| Chevron | `IconChevronDownFilled`, `IconChevronUpFilled`, `IconChevronLeftFilled`, `IconChevronRightFilled` | — |
| Divider | `<Divider />` component (not an icon) | — |

**Quick icon search command:**
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

## Professional App Colors

| Use | Color |
|---|---|
| Primary actions | Blue (#0041D9) |
| Text | Granite (#111116) |
| Section backgrounds | Light Gray (#F7F7F7 / `bg.screen.softest`, NOT `bg.screen.muted`) |
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
