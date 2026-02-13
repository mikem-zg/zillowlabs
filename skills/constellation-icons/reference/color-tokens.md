# Icon Color Tokens & Implementation Guide

**Package:** `@zillow/constellation-icons` v10.11.0
**Styling:** PandaCSS with Constellation semantic tokens

## Critical Rules

1. **NEVER** use the `color` prop on `<Icon>` — it does NOT accept semantic token paths
2. **ALWAYS** use the `css` prop for semantic token colors
3. **ALWAYS** wrap icons in `<Icon size="...">` with size tokens
4. **ALWAYS** use Filled variants by default

## Color Application Methods

### Method 1: CSS Prop with Semantic Tokens (Recommended)

Requires `injectTheme()` or `ConstellationProvider` set up in `main.tsx`.

```tsx
import { Icon } from '@zillow/constellation';
import { IconHeartFilled } from '@zillow/constellation-icons';

// Default icon color (inherits from parent)
<Icon size="md"><IconHeartFilled /></Icon>

// Semantic token via css prop
<Icon size="md" css={{ color: 'icon.neutral' }}><IconHeartFilled /></Icon>
<Icon size="md" css={{ color: 'text.subtle' }}><IconHeartFilled /></Icon>
<Icon size="md" css={{ color: 'text.action.critical.hero.default' }}><IconHeartFilled /></Icon>
```

### Method 2: Style Prop with CSS Variables (Fallback)

Use when theme injection is unavailable.

```tsx
<Icon size="md" style={{ color: 'var(--color-icon-subtle)' }}><IconHeartFilled /></Icon>
<Icon size="md" style={{ color: 'var(--color-icon-muted)' }}><IconHeartFilled /></Icon>
<Icon size="md" style={{ color: 'var(--color-icon-action-hero-default)' }}><IconHeartFilled /></Icon>
```

### Method 3: Parent Color Inheritance

Icons inherit color from their parent element.

```tsx
<Flex css={{ color: 'text.subtle' }}>
  <Icon size="md"><IconClockFilled /></Icon>
  <Text textStyle="body-sm">Last updated 2h ago</Text>
</Flex>
```

## Semantic Icon Color Tokens

### Standard UI Colors

| Token (css prop) | CSS Variable | Light Value | Dark Value | Use For |
|---|---|---|---|---|
| `icon.neutral` | `--color-icon-neutral` | Gray-950 | Gray-50 | Default icon color |
| `icon.subtle` | `--color-icon-subtle` | Gray-600 | Gray-400 | Secondary/supporting icons |
| `icon.muted` | `--color-icon-muted` | Gray-500 | Gray-500 | Disabled/inactive icons |
| `icon.on-hero.neutral` | `--color-icon-on-hero-neutral` | White | Black | Icons on filled backgrounds |

### Action Colors

| Token (css prop) | CSS Variable | Light Value | Use For |
|---|---|---|---|
| `icon.action.hero.default` | `--color-icon-action-hero-default` | Blue-600 | Primary action icons |
| `icon.action.hero.hover` | `--color-icon-action-hero-hover` | Blue-700 | Hovered action icons |
| `icon.action.hero.active` | `--color-icon-action-hero-active` | Blue-800 | Pressed action icons |

### Semantic Status Colors

| Token (css prop) | CSS Variable | Light Value | Use For |
|---|---|---|---|
| `text.action.critical.hero.default` | `--color-text-action-critical-hero-default` | Red-600 | Error/danger icons |
| `text.action.success.hero.default` | `--color-text-action-success-hero-default` | Green-700 | Success icons |
| `text.action.trust.hero.default` | `--color-text-action-trust-hero-default` | Teal-600 | Trust/finance icons |
| `text.action.inspire.hero.default` | `--color-text-action-inspire-hero-default` | Purple-500 | Inspiration/new feature icons |
| `text.action.focus.hero.default` | `--color-text-action-focus-hero-default` | Orange-600 | Urgency/attention icons |

### On-Hero Colors (Icons on Filled Backgrounds)

| Token (css prop) | CSS Variable | Light Value | Use For |
|---|---|---|---|
| `icon.on-hero.neutral` | `--color-icon-on-hero-neutral` | White | Icons on dark/brand backgrounds |
| `text.on-hero.neutral-fixed` | `--color-text-on-hero-neutral-fixed` | White (always) | Icons that stay white in dark mode |

## Common Color Patterns by Context

### Navigation Icons
```tsx
// Active navigation item
<Icon size="md" css={{ color: 'icon.action.hero.default' }}><IconHomeFilled /></Icon>

// Inactive navigation item
<Icon size="md" css={{ color: 'icon.subtle' }}><IconSearchFilled /></Icon>
```

### Status Icons
```tsx
// Success
<Icon size="md" css={{ color: 'text.action.success.hero.default' }}><IconCheckmarkCircleFilled /></Icon>

// Error
<Icon size="md" css={{ color: 'text.action.critical.hero.default' }}><IconErrorFilled /></Icon>

// Warning
<Icon size="md" css={{ color: 'text.action.focus.hero.default' }}><IconWarningFilled /></Icon>

// Info
<Icon size="md" css={{ color: 'icon.action.hero.default' }}><IconInfoFilled /></Icon>
```

### Interactive Icons
```tsx
// Clickable icon with hover state (use IconButton)
<IconButton title="Settings" tone="neutral" emphasis="bare" size="md" shape="circle">
  <Icon><IconSettingsFilled /></Icon>
</IconButton>

// Favorite/save (active state)
<Icon size="md" css={{ color: 'text.action.critical.hero.default' }}><IconHeartFilled /></Icon>

// Favorite/save (inactive state)
<Icon size="md" css={{ color: 'icon.subtle' }}><IconHeartOutline /></Icon>
```

### Card & List Item Icons
```tsx
// Supporting metadata icon
<Flex align="center" gap="100">
  <Icon size="sm" css={{ color: 'icon.subtle' }}><IconClockFilled /></Icon>
  <Text textStyle="body-sm" css={{ color: 'text.subtle' }}>3 days ago</Text>
</Flex>

// Feature list icon
<Flex align="center" gap="200">
  <Icon size="md" css={{ color: 'text.action.success.hero.default' }}><IconCheckmarkFilled /></Icon>
  <Text textStyle="body">Feature included</Text>
</Flex>
```

### Button Icons
```tsx
// Use Button's built-in icon prop — NOT Flex wrapping
<Button tone="brand" emphasis="filled" size="md" icon={<IconSearchFilled />} iconPosition="start">
  Search
</Button>

// Icon-only button
<IconButton title="Filter" tone="neutral" emphasis="outlined" size="md" shape="square">
  <Icon><IconFilterFilled /></Icon>
</IconButton>
```

### Empty State Icons (Professional Apps)
```tsx
// Professional apps use Outline for empty states
<Icon size="xl" css={{ color: 'icon.muted' }}><IconInboxOutline /></Icon>
<Text textStyle="body" css={{ color: 'text.subtle' }}>No messages yet</Text>
```

## Icon Sizes Reference

| Token | Pixels | Use For |
|---|---|---|
| `sm` | 16px | Inline metadata, small indicators, list items |
| `md` | 24px | Default size, navigation, buttons, standard UI |
| `lg` | 32px | Section headers, prominent indicators |
| `xl` | 44px | Empty states, hero sections, onboarding |

```tsx
<Icon size="sm"><IconCheckmarkFilled /></Icon>   // 16px
<Icon size="md"><IconSearchFilled /></Icon>       // 24px - default
<Icon size="lg"><IconHomeFilled /></Icon>         // 32px
<Icon size="xl"><IconInboxFilled /></Icon>        // 44px
```

### Responsive Sizing
```tsx
<Icon size={{ base: 'sm', md: 'md', lg: 'lg' }}><IconSearchFilled /></Icon>
```

## Dark Mode Behavior

Semantic tokens automatically remap in dark mode:
- `icon.neutral`: Gray-950 → Gray-50
- `icon.subtle`: Gray-600 → Gray-400
- `icon.action.hero.default`: Blue-600 → Blue-400

No additional dark mode overrides needed when using semantic tokens.

## Anti-Patterns (NEVER Do)

```tsx
// WRONG - color prop doesn't accept tokens
<Icon size="md" color="icon.neutral"><IconHeartFilled /></Icon>

// WRONG - no Icon wrapper
<IconHeartFilled />

// WRONG - hardcoded color
<Icon size="md" style={{ color: '#0041D9' }}><IconHeartFilled /></Icon>

// WRONG - custom pixel size
<Icon style={{ width: '20px', height: '20px' }}><IconHeartFilled /></Icon>

// WRONG - Outline as default
<Icon size="md"><IconHeartOutline /></Icon>

// WRONG - wrapping icon inside Button with Flex
<Button>
  <Flex><Icon><IconSearchFilled /></Icon><Text>Search</Text></Flex>
</Button>
```
