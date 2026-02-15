---
name: constellation-icons
description: Complete reference for Zillow's Constellation icon library (621 icons). Includes full catalog with descriptions, search aliases, color token patterns, sizing, accessibility, and implementation guides for all Filled, Outline, and Special icon variants.
---

# Constellation Icons Library

## Reference Guides

- **`reference/icon-catalog.md`** — Full catalog of all 302 icons with descriptions, alternative names, and categories
- **`reference/color-tokens.md`** — Color token reference, implementation patterns, sizing, dark mode, and anti-patterns
- **`reference/quick-reference.md`** — Alphabetical lookup table and category-based quick finder

## Overview

| Stat | Value |
|---|---|
| Package | `@zillow/constellation-icons` v10.11.0 |
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

// Button with icon (use Button's built-in props)
<Button icon={<IconSearchFilled />} iconPosition="start">Search</Button>

// Icon-only button
<IconButton title="Settings" tone="neutral" emphasis="bare" size="md" shape="circle">
  <Icon><IconSettingsFilled /></Icon>
</IconButton>
```

## Size Tokens

| Token | Pixels | Use For |
|---|---|---|
| `sm` | 16px | Inline metadata, small indicators |
| `md` | 24px | Default — navigation, buttons, standard UI |
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

### Status Indicators
```tsx
<Icon size="md" css={{ color: 'text.action.success.hero.default' }}><IconCheckmarkCircleFilled /></Icon>
<Icon size="md" css={{ color: 'text.action.critical.hero.default' }}><IconErrorFilled /></Icon>
<Icon size="md" css={{ color: 'text.action.focus.hero.default' }}><IconWarningFilled /></Icon>
<Icon size="md" css={{ color: 'icon.action.hero.default' }}><IconInfoFilled /></Icon>
```

### Metadata Row
```tsx
<Flex align="center" gap="100">
  <Icon size="sm" css={{ color: 'icon.subtle' }}><IconClockFilled /></Icon>
  <Text textStyle="body-sm" css={{ color: 'text.subtle' }}>3 days ago</Text>
</Flex>
```

### Empty State (Professional)
```tsx
<Flex direction="column" align="center" gap="300">
  <Icon size="xl" css={{ color: 'icon.muted' }}><IconInboxOutline /></Icon>
  <Text textStyle="body" css={{ color: 'text.subtle' }}>No messages yet</Text>
</Flex>
```

### Favorite Toggle
```tsx
// Saved
<Icon size="md" css={{ color: 'text.action.critical.hero.default' }}><IconHeartFilled /></Icon>
// Not saved
<Icon size="md" css={{ color: 'icon.subtle' }}><IconHeartOutline /></Icon>
```

## Button Icon Integration

### Button with Text + Icon

ALWAYS use Button's built-in `icon` and `iconPosition` props. NEVER wrap icons in Flex/Box inside a Button.

```tsx
// CORRECT — use icon and iconPosition props
<Button icon={<IconSearchFilled />} iconPosition="start">Search</Button>
<Button icon={<IconArrowRightFilled />} iconPosition="end">Next</Button>

// WRONG — don't wrap icons and text in Flex
<Button>
  <Flex align="center" gap="100">
    <Icon size="sm"><IconSearchFilled /></Icon>
    <Text>Search</Text>
  </Flex>
</Button>

// WRONG — don't use Icon wrapper inside Button icon prop
<Button icon={<Icon size="sm"><IconSearchFilled /></Icon>} iconPosition="start">Search</Button>
```

### IconButton (Icon-Only Buttons)

For buttons that show only an icon with no text, use `IconButton`. Always include `title` for accessibility.

```tsx
import { Icon, IconButton } from '@zillow/constellation';
import { IconSettingsFilled, IconCloseFilled } from '@zillow/constellation-icons';

// Standard icon-only button
<IconButton title="Settings" tone="neutral" emphasis="bare" size="md" shape="circle">
  <Icon><IconSettingsFilled /></Icon>
</IconButton>

// Close button
<IconButton title="Close" tone="neutral" emphasis="bare" size="md" shape="circle">
  <Icon><IconCloseFilled /></Icon>
</IconButton>
```

| Prop | Required | Values | Notes |
|---|---|---|---|
| `title` | Yes | String | Accessibility label — screen readers use this |
| `tone` | Yes | `"neutral"`, `"brand"`, etc. | Visual tone |
| `emphasis` | Yes | `"bare"`, `"outlined"`, `"filled"` | Visual weight |
| `size` | Yes | `"sm"`, `"md"`, `"lg"` | Button size |
| `shape` | No | `"circle"`, `"square"` | Shape of the button |

## Icons Inside Tabs

When adding icons to tab labels, place the Icon and label text inside a Flex container within the Tab.

```tsx
<Tabs.Root defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">
      <Flex align="center" gap="100">
        <Icon size="sm"><IconHomeFilled /></Icon>
        Overview
      </Flex>
    </Tabs.Tab>
    <Tabs.Tab value="files">
      <Flex align="center" gap="100">
        <Icon size="sm"><IconFileTextFilled /></Icon>
        Files (3)
      </Flex>
    </Tabs.Tab>
  </Tabs.List>
</Tabs.Root>
```

## Duotone Icons — `DuoColorIcon` (Professional Apps)

Also known as **duotone icons** or **duo color icons**. Professional apps use `DuoColorIcon` for upsell banners and empty states. These are two-tone styled icons with a colored foreground and a tinted background, making them feel lighter and more approachable than solid Filled icons.

Available since Constellation v10.2.0.

### Import

```tsx
import { DuoColorIcon, Icon } from '@zillow/constellation';
import { IconInboxFilled } from '@zillow/constellation-icons';
```

### Basic usage

The inner icon MUST be wrapped in `<Icon>`. `DuoColorIcon` does NOT have a `size` prop — sizing is controlled by the inner `<Icon>` component.

```tsx
<DuoColorIcon tone="trust" onBackground="default">
  <Icon><IconKeyFilled /></Icon>
</DuoColorIcon>
```

### Props

| Prop | Type | Default | Description |
|---|---|---|---|
| `tone` | `'trust' \| 'insight' \| 'inspire' \| 'empower' \| 'info' \| 'success' \| 'critical' \| 'warning' \| 'notify'` | `'trust'` | Controls the color theme of the icon |
| `onBackground` | `'default' \| 'hero' \| 'impact'` | `'default'` | Adjusts icon colors for the surface it sits on |
| `css` | `SystemStyleObject` | — | Custom styles via PandaCSS |
| `children` | `ReactNode` | — | Must contain an `<Icon>` wrapping a Filled icon |

### Tone reference

**Brand tones** (for feature areas and product sections):

| Tone | Color | Use for |
|---|---|---|
| `trust` | Teal | Finance, loans, agent connections |
| `insight` | Blue | Data, analytics, market info |
| `inspire` | Purple | New features, AI, creativity |
| `empower` | Orange | Urgency, opportunities, growth |

**Status tones** (for feedback and system states):

| Tone | Color | Use for |
|---|---|---|
| `info` | Blue | Informational messages |
| `success` | Green | Completed actions, confirmations |
| `critical` | Red | Errors, critical alerts |
| `warning` | Yellow/Amber | Caution, attention needed |
| `notify` | Blue | Notifications, updates |

### Background surfaces

| `onBackground` | When to use |
|---|---|
| `default` | Standard page backgrounds (white/gray) |
| `hero` | Colored hero sections or banners |
| `impact` | Dark or high-contrast backgrounds |

### Common patterns

```tsx
// Empty state (Professional app)
<Flex direction="column" align="center" gap="300">
  <DuoColorIcon tone="trust" onBackground="default">
    <Icon><IconInboxFilled /></Icon>
  </DuoColorIcon>
  <Text textStyle="body" css={{ color: 'text.subtle' }}>No messages yet</Text>
</Flex>

// Upsell banner (Professional app)
<DuoColorIcon tone="inspire" onBackground="default">
  <Icon><IconSparkFilled /></Icon>
</DuoColorIcon>

// On a hero section background
<DuoColorIcon tone="trust" onBackground="hero">
  <Icon><IconShieldFilled /></Icon>
</DuoColorIcon>
```

### When to use each icon style

| Context | Use Filled | Use Outline | Use DuoColorIcon |
|---|---|---|---|
| Standard UI | Yes | — | — |
| Active/selected state | Yes | — | — |
| Inactive toggle | — | Yes | — |
| Empty states (Consumer) | Yes (with `icon.muted`) | — | — |
| Empty states (Professional) | — | — | Yes |
| Upsell banners (Professional) | — | — | Yes |

### Common mistakes

| Mistake | Correct |
|---|---|
| `<DuoColorIcon size="xl">` | `DuoColorIcon` has no `size` prop. Use `<Icon>` inside to control size |
| `<DuoColorIcon><IconKeyFilled /></DuoColorIcon>` | Always wrap the icon in `<Icon>`: `<DuoColorIcon><Icon><IconKeyFilled /></Icon></DuoColorIcon>` |
| Using `DuoColorIcon` in Consumer apps | `DuoColorIcon` is for Professional apps only. Consumer apps use Filled icons with `icon.muted` color |
| Missing `tone` prop | Always specify `tone` explicitly to match the content meaning |

## Common Mistakes (NEVER DO)

| Mistake | Why It's Wrong | Correct Approach |
|---|---|---|
| `<Icon color="icon.neutral">` | `color` prop doesn't resolve token paths | `<Icon css={{ color: 'icon.neutral' }}>` |
| `<Icon style={{ width: 20 }}>` | Custom pixel sizes break consistency | `<Icon size="sm">` (or `md`, `lg`, `xl`) |
| `<Button><Flex><Icon>...</Icon><Text>Label</Text></Flex></Button>` | Wrapping icon+text in Flex inside Button | `<Button icon={<IconXFilled />} iconPosition="start">Label</Button>` |
| `<Button icon={<Icon><IconXFilled /></Icon>}>` | Wrapping in Icon component inside icon prop | `<Button icon={<IconXFilled />}>` |
| `<IconSearchOutline />` as default | Outline variants are not the default style | `<IconSearchFilled />` |
| `<IconButton>` without `title` | Missing accessibility label for screen readers | `<IconButton title="Search">` |
| Custom `<Box>` styled as a badge/tag | Bypasses design system components | `<Tag size="sm" tone="blue">Label</Tag>` |
| Bare icon SVG without `<Icon>` wrapper | No size token control, inconsistent rendering | `<Icon size="md"><IconXFilled /></Icon>` |

## Variant Selection Guide

| Context | Use | Example |
|---|---|---|
| Default UI | Filled | `IconHomeFilled` |
| Active/selected state | Filled | `IconHeartFilled` |
| Inactive/unselected | Outline | `IconHeartOutline` |
| Empty states (Consumer) | Filled + muted color | `IconInboxFilled` with `icon.muted` |
| Empty states (Pro) | DuoColorIcon | `<DuoColorIcon><IconInboxFilled /></DuoColorIcon>` |
| Upsells (Pro) | DuoColorIcon | `<DuoColorIcon><IconSparkFilled /></DuoColorIcon>` |
| Navigation active | Filled | `IconHomeFilled` |
| Navigation inactive | Filled (subtle color) | `IconHomeFilled` with `icon.subtle` |
| Buttons with text | Filled (no wrapper) | `<Button icon={<IconSearchFilled />}>` |
| Icon-only buttons | Filled (in IconButton) | `<IconButton title="..."><Icon><IconSearchFilled /></Icon></IconButton>` |
| Tab labels | Filled (sm size) | `<Icon size="sm"><IconNoteFilled /></Icon>` |

## Naming Conventions & Verification

### Naming rules

All Constellation icon exports follow strict **PascalCase for every word** in the name:

| Correct | Wrong |
|---|---|
| `IconLightBulbFilled` | `IconLightbulbFilled` |
| `IconUserGroupFilled` | `IconUsergroupFilled` |
| `IconThumbsUpFilled` | `IconThumbsupFilled` |
| `IconCreditCardFilled` | `IconCreditcardFilled` |

### Verification workflow

**Never guess icon names.** Always verify against the source before using an icon:

1. Check `reference/icon-catalog.md` for the icon name and available variants
2. If unsure, search the type declarations file to confirm the exact export:
   ```bash
   grep "IconLightBulb" node_modules/@zillow/constellation-icons/dist/react/index.d.ts
   ```

### Common mistakes to avoid

| Mistake | Why it fails |
|---|---|
| Assuming an icon exists because the concept is common | Many expected icons don't exist (e.g., there is no `IconEyeFilled` or `IconStarFilled`) |
| Assuming both Filled and Outline variants exist for every icon | Some icons only have one variant |
| Inferring names from other icon libraries (Material, Lucide, etc.) | Constellation uses its own naming — always verify |
| Using lowercase compound words (`Lightbulb` instead of `LightBulb`) | Every word is PascalCased individually |

## Finding Icons

When looking for an icon, check the full catalog in `reference/icon-catalog.md`. Each icon entry includes alternative names to help with discovery. For example:
- Looking for "favorite"? → `IconHeartFilled`
- Looking for "settings" or "gear"? → `IconSettingsFilled`
- Looking for "trash" or "remove"? → `IconDeleteFilled`
- Looking for "location" or "pin" or "marker"? → `IconLocationFilled`
- Looking for "close" or "x" or "dismiss"? → `IconCloseFilled`
