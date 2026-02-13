# Illustration Usage Guide

## File Locations

| Theme | Path |
|-------|------|
| Light Mode | `client/src/assets/illustrations/Lightmode/{name}.svg` |
| Dark Mode | `client/src/assets/illustrations/Darkmode/{name}.svg` |

All 99 illustrations have both light and dark mode variants. Files use identical names in both directories.

## Import Patterns

### Basic Import (Single Mode)

```tsx
import forSaleHomeSvg from '@/assets/illustrations/Lightmode/for-sale-home.svg';
import { Image } from '@zillow/constellation';

<Image src={forSaleHomeSvg} alt="Home for sale" css={{ width: '160px', height: '160px' }} />
```

### Dark Mode Support (Recommended)

```tsx
import SearchHomesLight from '@/assets/illustrations/Lightmode/search-homes.svg';
import SearchHomesDark from '@/assets/illustrations/Darkmode/search-homes.svg';
import { useIsDarkMode } from '@/hooks/use-theme-mode';

function EmptySearchState() {
  const isDarkMode = useIsDarkMode();
  return (
    <img
      src={isDarkMode ? SearchHomesDark : SearchHomesLight}
      alt="Search homes"
      style={{ width: '160px', height: '160px' }}
    />
  );
}
```

### Reusable Illustration Component Pattern

```tsx
function Illustration({ name, alt, size = 160 }: { name: string; alt: string; size?: number }) {
  const isDarkMode = useIsDarkMode();
  const lightSrc = new URL(`../assets/illustrations/Lightmode/${name}.svg`, import.meta.url).href;
  const darkSrc = new URL(`../assets/illustrations/Darkmode/${name}.svg`, import.meta.url).href;
  
  return (
    <img
      src={isDarkMode ? darkSrc : lightSrc}
      alt={alt}
      style={{ width: `${size}px`, height: `${size}px` }}
    />
  );
}
```

## Sizing

| Type | Dimensions | Use For |
|------|-----------|---------|
| Standard Spot | 160×160px | Empty states, value prop lists, product upsell banners |
| Compact Spot | 120×120px | Tighter layouts, inline with content, sidebar placements |

All SVGs are natively 160×160px. Scale down with CSS for compact usage.

## Design System Rules

### ALWAYS

- Keep the beige background blob — it visually grounds the illustration
- Provide both light and dark mode variants
- Use whitespace to separate illustrations from other bold elements
- Count illustrations toward the 25% bold color limit on a page
- Use standard or compact sizing (160px or 120px)
- Add descriptive `alt` text for accessibility

### NEVER

- Remove the beige background element from SVGs
- Use illustrations as purely decorative filler with no purpose
- Place illustrations directly next to large solid-colored cards
- Exceed 25% bold color when illustrations + backgrounds are combined
- Use custom sizes outside the standard 160px / 120px options
- Use spot illustrations when a simple X-Large (44px) icon would suffice

## Consumer vs Professional

| Audience | Allowed Types | Notes |
|----------|---------------|-------|
| Consumer | Spot + Scene illustrations | Full expressive palette, storytelling OK |
| Professional | Spot illustrations ONLY | No complex scene illustrations except onboarding |

### Professional App Guidelines

- Use spot illustrations for metaphorical concepts (success, empty states, feature promos)
- Pair with DuoColorIcon for upsell sections
- Keep placement minimal and purposeful
- Never use as large hero backgrounds

## Common Layout Patterns

### Empty State (Centered)

```tsx
<Flex direction="column" align="center" gap="400" css={{ py: '800', textAlign: 'center' }}>
  <img src={emptyIllustration} alt="No results" style={{ width: '160px', height: '160px' }} />
  <Heading textStyle="heading-lg">No results found</Heading>
  <Text textStyle="body" css={{ color: 'text.subtle', maxWidth: '400px' }}>
    Try adjusting your search criteria to find what you're looking for.
  </Text>
  <Button tone="brand" emphasis="filled" size="md">Update search</Button>
</Flex>
```

### Feature Card (Horizontal)

```tsx
<Card outlined elevated={false} tone="neutral">
  <Flex align="center" gap="400" css={{ p: '400' }}>
    <img src={featureIllustration} alt="" style={{ width: '120px', height: '120px', flexShrink: 0 }} />
    <Flex direction="column" gap="200">
      <Text textStyle="body-bold">Feature title</Text>
      <Text textStyle="body" css={{ color: 'text.subtle' }}>Feature description here.</Text>
      <Button tone="brand" emphasis="outlined" size="md">Learn more</Button>
    </Flex>
  </Flex>
</Card>
```

### Value Proposition List

```tsx
<Grid columns={{ base: 1, md: 3 }} gap="600">
  {valueProps.map(({ illustration, title, description }) => (
    <Flex direction="column" align="center" gap="300" key={title}>
      <img src={illustration} alt="" style={{ width: '160px', height: '160px' }} />
      <Text textStyle="body-bold" css={{ textAlign: 'center' }}>{title}</Text>
      <Text textStyle="body" css={{ color: 'text.subtle', textAlign: 'center' }}>{description}</Text>
    </Flex>
  ))}
</Grid>
```

## When to Use Icons Instead

Use an **X-Large (44px) icon** instead of a spot illustration when:

- The concept is simple and universally understood (settings, notifications, search)
- Space is limited (inline with text, small cards)
- The visual is purely functional, not storytelling
- Multiple items need icons in a compact list

Use a **spot illustration** when:

- You need to tell a story or convey emotion
- The state is significant (empty, error, success, onboarding)
- You want to humanize the experience
- The section has dedicated visual space (hero, card, banner)

## DuoColorIcon Alternative

For simpler two-tone decorative icons (not spot illustrations), use the `DuoColorIcon` component:

```tsx
import { DuoColorIcon, Icon } from '@zillow/constellation';
import { IconKeyFilled } from '@zillow/constellation-icons';

<DuoColorIcon tone="trust" onBackground="default">
  <Icon><IconKeyFilled /></Icon>
</DuoColorIcon>
```

Available tones: `trust`, `insight`, `inspire`, `empower`, `info`, `success`, `critical`, `warning`, `notify`
