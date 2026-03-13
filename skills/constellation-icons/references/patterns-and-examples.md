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
| Empty states (Pro) | DuoColorIcon | `<DuoColorIcon tone="trust"><Icon><IconInboxFilled /></Icon></DuoColorIcon>` |
| Upsells (Pro) | DuoColorIcon | `<DuoColorIcon tone="inspire"><Icon><IconSparkFilled /></Icon></DuoColorIcon>` |
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
