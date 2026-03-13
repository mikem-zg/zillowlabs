---
name: constellation-icons
description: Complete reference for Zillow's Constellation icon library (621 icons). Activates when working with icons, adding icons to components, searching for icon names, or using @zillow/constellation-icons. Includes full catalog with descriptions, search aliases, color token patterns, sizing, accessibility, and implementation guides for all Filled, Outline, and Special icon variants.
---

# Constellation Icons Library

## Prerequisites

- `@zillow/constellation` installed (provides the `Icon` and `IconButton` wrapper components)
- `@zillow/constellation-icons` installed (provides the icon SVG components)
- Theme injected via `injectTheme()` or `ConstellationProvider` (required for semantic color tokens like `icon.subtle` to resolve)

## When to Use

- Adding icons to any UI component, button, or layout
- Looking up an icon name for a concept (e.g., "what's the icon for notifications?")
- Checking which icon variants exist (Filled, Outline, Special)
- Implementing icon color, sizing, or accessibility patterns

## When NOT to Use

- **Choosing between components** (Card vs PropertyCard, Button vs ToggleButton) — use `constellation-design-system`
- **Selecting illustrations for empty states or onboarding** — use `constellation-illustrations` (illustrations are not icons)
- **Building favicons or app icons** — those are static assets, not Constellation icons
- **Logo usage** — use `ZillowLogo` or `ZillowHomeLogo` from `@zillow/constellation`, not an icon

## Reference Guides

- **`reference/icon-catalog.md`** — Full catalog of all 302 icons with descriptions, alternative names, and categories
- **`reference/color-tokens.md`** — Color token reference, implementation patterns, sizing, dark mode, and anti-patterns
- **`reference/quick-reference.md`** — Alphabetical lookup table and category-based quick finder

## Related Constellation Skills

- **[constellation-design-system](../../constellation-design-system/SKILL.md)**: Core design system rules, all 99 component docs, UX writing guidelines, and layout patterns. **Load this skill for component usage, spacing tokens, and design rules.**
- **[constellation-dark-mode](../../constellation-dark-mode/SKILL.md)**: Theme injection, dark mode toggle patterns, `_dark`/`_light` CSS conditions, and design token tiers. **Load this skill when implementing theming or dark mode.**
- **[constellation-illustrations](../../constellation-illustrations/SKILL.md)**: Full catalog of 99 spot illustrations with light/dark mode SVG paths. **Load this skill when selecting illustrations for empty states, onboarding, or storytelling.**
- **[consumer-brand-guidelines](../../consumer-brand-guidelines/SKILL.md)**: Consumer audience brand rules — full expressive color palette, Filled icons as default. **Load for consumer-facing icon color and usage decisions.**
- **[professional-brand-guidelines](../../professional-brand-guidelines/SKILL.md)**: Professional audience brand rules — restricted palette, Duotone icons for upsells/empty states, "Express - trust" variant. **Load for professional-facing icon style and color decisions.**

## Overview

| Stat | Value |
|---|---|
| Package | `@zillow/constellation-icons` v10.14.0 |
| Total icons | 621 |
| Filled variants | 302 |
| Outline variants | 302 |
| Special icons | 17 (social, brand, ratings) |

## Critical Rules

1. **ALWAYS** use Filled variants by default (`IconHeartFilled`, not `IconHeartOutline`)
2. **ALWAYS** wrap icons in `<Icon size="...">` with size tokens (`sm`, `md`, `lg`, `xl`)
3. **ALWAYS** use the `css` prop for semantic color tokens (NOT `color` prop)
4. **NEVER** use custom pixel sizes or inline styles for sizing
5. **NEVER** use Outline variants as default (use only for inactive/secondary states)
6. Professional apps: use Outline icons for empty states and upsells only
7. **NEVER guess icon names** — ALWAYS verify against the catalog (`reference/icon-catalog.md`) before importing. Many intuitive names do not exist (e.g., `IconHomeFilled` does not exist — use `IconHomesFilled`). If unsure, run the verification command below.

## Verify Icon Exists

Before importing any icon, run this to confirm it exists in the package:

```bash
node --input-type=module -e "import * as m from '@zillow/constellation-icons'; console.log(m['IconHomeFilled'] ? 'EXISTS' : 'NOT FOUND')"
```

Search for valid icon names matching a keyword:

```bash
node --input-type=module -e "import * as m from '@zillow/constellation-icons'; Object.keys(m).filter(k=>k.toLowerCase().includes('home')).forEach(k=>console.log(k))"
```

## Common Name Gotchas (Frequently Wrong Guesses)

These icon names look right but **do NOT exist**. Use the correct name instead:

| Wrong Guess (does NOT exist) | Correct Name | Why |
|---|---|---|
| `IconHomeFilled` | `IconHomesFilled` | Plural — "Homes" not "Home" |
| `IconChatFilled` | `IconMessageFilled` | Named "Message" not "Chat" |
| `IconTrashFilled` | `IconDeleteFilled` | Named "Delete" not "Trash" |
| `IconSettingFilled` | `IconSettingsFilled` | Plural — "Settings" not "Setting" |
| `IconBellFilled` | `IconNotificationFilled` | Named "Notification" not "Bell" |
| `IconCheckFilled` | `IconCheckmarkFilled` | Full name — "Checkmark" not "Check" |
| `IconStarFilled` | `IconStar100Percent` (Special) | Stars are Special rating icons — no Filled/Outline variants |
| `IconPencilFilled` | `IconEditFilled` | Named "Edit" not "Pencil" |
| `IconRefreshFilled` | `IconReloadFilled` | Named "Reload" not "Refresh" |
| `IconShareFilled` | `IconShareWebFilled` | Full name — "ShareWeb" not "Share" |
| `IconEyeFilled` | `IconStreetViewFilled` | Named "StreetView" for visibility |
| `IconImageFilled` / `IconPhotoFilled` | `IconPhotosFilled` | Plural — "Photos" not "Photo" |
| `IconVideoFilled` | `IconVideoCameraFilled` | Full name — "VideoCamera" not "Video" |
| `IconMicFilled` | `IconMicrophoneFilled` | Full name — "Microphone" not "Mic" |
| `IconEmailFilled` | `IconMailFilled` | Named "Mail" not "Email" |
| `IconPinFilled` | `IconLocationFilled` | Named "Location" not "Pin" |
| `IconTimeFilled` / `IconClockFilled` | `IconClockFilled` | `IconClockFilled` exists ✓ |
| `IconBookmarkFilled` | `IconHeartFilled` or `IconFlagFilled` | No bookmark icon — use Heart (favorite) or Flag (mark) |
| `IconChartFilled` | `IconTrendingFilled` | Named "Trending" not "Chart" |
| `IconListFilled` | `IconListBulletedFilled` | Suffixed — "ListBulleted" not "List" |
| `IconAddFilled` | `IconPlusCircleFilled` | Named "PlusCircle" not "Add" |
| `IconCloseFilled` | `IconCloseFilled` | `IconCloseFilled` exists ✓ |

**When in doubt, ALWAYS run the search command above** — never guess.

## Validate All Icon Imports

After building UI, run this script to catch all invalid icon imports across the codebase:

```bash
bash .agents/skills/constellation-icons/scripts/validate-icon-imports.sh client/src
```

This verifies every `Icon*Filled` / `Icon*Outline` import actually exists in the package and suggests alternatives for invalid ones.

## Icon Wrapper Exceptions

The following component slots manage icon sizing internally. Do NOT add an `<Icon size="...">` wrapper when using these — sizing is handled by the parent component:

| Slot | Wrapper needed? | Example |
|------|-----------------|---------|
| `FilterChip.Icon` | No `<Icon>` at all | `<FilterChip.Icon><IconBeachFilled /></FilterChip.Icon>` |
| `AssistChip.Icon` | No `<Icon>` at all | `<AssistChip.Icon><IconSparkleFilled /></AssistChip.Icon>` |
| Button `icon` prop | No `<Icon>` at all | `<Button icon={<IconSearchFilled />}>Search</Button>` |
| IconButton children | Use `<Icon>` but omit `size` | `<IconButton title="Close"><Icon><IconCloseFilled /></Icon></IconButton>` |

## Quick Import

```tsx
import { Icon, IconButton } from '@zillow/constellation';
import { IconHeartFilled, IconSearchFilled } from '@zillow/constellation-icons';
```

## Basic Usage

```tsx
// Standard icon
<Icon size="md"><IconHeartFilled /></Icon>

// Icon with semantic color
<Icon size="md" css={{ color: 'icon.subtle' }}><IconHeartFilled /></Icon>

// Button with icon — use sparingly, only when icon adds real clarity
<Button icon={<IconSearchFilled />} iconPosition="start">Search</Button>

// Icon-only button — ALWAYS use IconButton, default to bare neutral
<IconButton title="Settings" tone="neutral" emphasis="bare" size="md" shape="square">
  <Icon><IconSettingsFilled /></Icon>
</IconButton>
```

## Button Icon Rules

**Use icons in buttons sparingly.** Most buttons work fine with text alone. Only add an icon when it genuinely aids comprehension (e.g., search, filter, close). Do not add icons to buttons just for decoration.

**Icon-only buttons:** Always use `<IconButton>`, never `<Button icon={...}>` without text. Default to `tone="neutral" emphasis="bare"` unless there is a specific reason for another style.

```tsx
// CORRECT — IconButton with bare neutral defaults
<IconButton title="Close" tone="neutral" emphasis="bare" size="md" shape="square">
  <Icon><IconCloseFilled /></Icon>
</IconButton>

// WRONG — Button with icon but no text
<Button icon={<IconCloseFilled />} />
```

## Size Tokens

**Default size is `md` (24px).** Always use `size="md"` unless you have a specific reason for another size.

| Token | Pixels | Use For |
|---|---|---|
| `sm` | 16px | Inline metadata, small indicators |
| `md` | 24px | **Default** — navigation, buttons, standard UI |
| `lg` | 32px | Section headers, prominent indicators |
| `xl` | 44px | Empty states, hero sections, onboarding |

## Color Application

```tsx
// CORRECT — css prop with semantic tokens
<Icon size="md" css={{ color: 'icon.neutral' }}><IconHeartFilled /></Icon>
<Icon size="md" css={{ color: 'icon.subtle' }}><IconHeartFilled /></Icon>
<Icon size="md" css={{ color: 'icon.action.hero.default' }}><IconSearchFilled /></Icon>
<Icon size="md" css={{ color: 'text.action.critical.hero.default' }}><IconErrorFilled /></Icon>

// WRONG — color prop doesn't resolve token paths
<Icon size="md" color="icon.neutral"><IconHeartFilled /></Icon>
```

## Icon Color by Context

Use this table to choose the right color token based on what the icon represents, not just what it looks like:

| Context | Token | Color | Notes |
|---------|-------|-------|-------|
| Interactive action (clickable) | `icon.action.hero.default` | Blue-600 | Buttons, links, clickable icons ONLY |
| Informational / decorative | `icon.neutral` or `icon.subtle` | Gray-950 / Gray-600 | Non-interactive icons next to text |
| Success indicator | `text.action.success.hero.default` | Green-700 | Checkmarks, confirmations |
| Error indicator | `text.action.critical.hero.default` | Red-600 | Errors, warnings |
| AI / inspiration accent | `text.action.inspire.hero.default` | Purple-500 | Consumer apps ONLY — AI features, new features |
| Trust / finance accent | `text.action.trust.hero.default` | Teal-600 | Loans, agent connections (Consumer apps; use sparingly in Professional) |
| Urgency / attention | `text.action.focus.hero.default` | Orange-600 | "New", "Hot", alerts (Consumer apps ONLY) |

**Key rules:**
- If the icon is NOT clickable, do NOT use `icon.action.hero.default` (blue). Blue = interactive only.
- Professional apps: Purple, Orange, and vibrant Teal are PROHIBITED for UI elements. Use `icon.neutral` or `icon.subtle` for non-interactive icons.
- Use `icon.neutral`, `icon.subtle`, or a semantic accent token that matches the content meaning.

## Key Color Tokens

| Token | Light | Dark | Purpose |
|---|---|---|---|
| `icon.neutral` | Gray-950 | Gray-50 | Default icon color |
| `icon.subtle` | Gray-600 | Gray-400 | Secondary/supporting |
| `icon.muted` | Gray-500 | Gray-500 | Disabled/inactive |
| `icon.action.hero.default` | Blue-600 | Blue-400 | Primary action |
| `text.action.critical.hero.default` | Red-600 | Red-400 | Error/danger |
| `text.action.success.hero.default` | Green-700 | Green-400 | Success |
| `text.action.trust.hero.default` | Teal-600 | Teal-400 | Trust/finance |
| `text.action.focus.hero.default` | Orange-600 | Orange-400 | Urgency/attention |
| `text.action.inspire.hero.default` | Purple-500 | Purple-400 | New features |

## Icon Categories

| Category | Count | Examples |
|---|---|---|
| Navigation & Arrows | 34 | Arrow*, Chevron*, Close, Menu, Expand |
| Actions & Controls | 51 | Search, Edit, Filter, Sort, Copy, Delete |
| Property & Real Estate | 38 | House, Building, Bathroom, Kitchen, Key |
| Finance & Business | 18 | Bank, CreditCard, Calculator, Trophy |
| Communication | 17 | Mail, Message, Phone, Notification |
| Media & Content | 37 | Camera, File, Photo, Play, Video |
| Transportation | 10 | Car, Bus, Bike, Pedestrian |
| User & People | 14 | User, UserGroup, Profile, ThumbsUp |
| Places & Amenities | 20 | Beach, Gym, Restaurant, School |
| Status & Feedback | 21 | Error, Warning, Info, Shield, Sparkle |
| Technology & Devices | 13 | Laptop, Smartphone, Globe, Battery |
| Nature & Weather | 16 | Leaf, Water, Wind, Fire, Pets |
| Text Formatting | 9 | TextBold, TextItalics, ListBulleted |
| Special | 17 | Social logos, Star ratings, ZillowMark |

## Common Patterns

See [references/patterns-and-examples.md](references/patterns-and-examples.md) for complete code examples covering:
- Status indicators, metadata rows, empty states, favorite toggles
- Button icon integration (text + icon, icon-only)
- Icons inside Tabs
- Duotone icons for professional apps
- Common mistakes to avoid
- Variant selection guide
- Naming conventions and verification
- Finding icons by keyword

