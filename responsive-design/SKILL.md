---
name: responsive-design
description: "Build responsive, mobile-first interfaces using PandaCSS breakpoint tokens, Constellation component sizing, container queries, fluid typography, and modern CSS techniques. Covers mobile-first strategy, dynamic viewport units, CSS Grid/Flexbox fluid layouts, responsive images, touch targets, Core Web Vitals optimization, WCAG 2.2 mobile accessibility, and React responsive hooks."
---

# Responsive Design

Build interfaces that adapt seamlessly across all screen sizes using modern CSS techniques, PandaCSS responsive tokens, and Constellation components.

## When to Use This Skill

- Implementing mobile-first responsive layouts
- Using PandaCSS breakpoint tokens and responsive conditions
- Creating fluid typography and spacing with clamp()
- Building responsive grids with CSS Grid auto-fit/auto-fill
- Using container queries for component-level responsiveness
- Optimizing for Core Web Vitals (CLS, LCP, INP)
- Meeting WCAG 2.2 mobile accessibility requirements
- Handling dynamic viewport units on mobile browsers
- Creating responsive React components with hooks

## Constellation/PandaCSS Breakpoint System

This project uses PandaCSS with Constellation's preset. Breakpoints use `em` units (mobile-first, `min-width`):

| Token | Value | Pixels | Use For |
|-------|-------|--------|---------|
| `sm` | 20em | 320px | Small phones |
| `md` | 30em | 480px | Large phones / landscape |
| `lg` | 48em | 768px | Tablets |
| `xl` | 64em | 1024px | Laptops / small desktops |
| `xxl` | 80em | 1280px | Large desktops |

### Responsive Props (Object Syntax)

```tsx
import { css } from '@/styled-system/css';
import { Flex, Grid, Box } from '@/styled-system/jsx';

<Box className={css({
  p: { base: '400', lg: '600' },
  display: { base: 'block', lg: 'flex' },
  fontSize: { base: 'sm', md: 'md', xl: 'lg' },
})}>
  Content
</Box>

<Grid columns={{ base: 1, md: 2, xl: 3 }} gap="400">
  <Card />
  <Card />
  <Card />
</Grid>
```

### Hide/Show Utilities

```tsx
<Box hideBelow="lg">Desktop only content</Box>
<Box hideFrom="lg">Mobile/tablet only content</Box>

<Box className={css({ display: { base: 'none', lg: 'block' } })}>
  Desktop only (alternative)
</Box>
```

### Responsive Conditions

```tsx
<Box className={css({
  lg: { display: 'flex', gap: '400' },
  lgDown: { flexDirection: 'column' },
  mdToLg: { padding: '300' },
  xlOnly: { maxWidth: '1200px' },
})}>
```

Available conditions: `sm`, `md`, `lg`, `xl`, `xxl`, `smOnly`, `mdOnly`, `lgOnly`, `xlOnly`, `xxlOnly`, `smDown`, `mdDown`, `lgDown`, `xlDown`, `xxlDown`, `smToMd`, `smToLg`, `mdToLg`, `mdToXl`, `lgToXl`, `lgToXxl`, `xlToXxl`

## Mobile-First Strategy

Start with mobile styles (no media query), then progressively enhance:

```tsx
<Flex
  direction={{ base: 'column', lg: 'row' }}
  gap={{ base: '400', lg: '600' }}
  p={{ base: '400', lg: '600' }}
  alignItems={{ base: 'stretch', lg: 'flex-start' }}
>
  <Box flex={{ lg: '1' }}>Main content</Box>
  <Box width={{ lg: '300px' }}>Sidebar</Box>
</Flex>
```

### Why Mobile-First

1. **Performance**: Mobile devices load only base CSS; desktop adds enhancements
2. **Content priority**: Forces focus on essential content
3. **Progressive enhancement**: Features add, never subtract
4. **PandaCSS default**: Breakpoints use `min-width` automatically

## Key Responsive Patterns

### Responsive Card Grid

```tsx
<Grid
  columns={{ base: 1, md: 2, xl: 3 }}
  gap="400"
  className={css({ px: '400', py: '600' })}
>
  {items.map(item => (
    <Card outlined elevated={false} tone="neutral" key={item.id}>
      <Flex direction="column" gap="200">
        <Text textStyle="body-bold">{item.title}</Text>
        <Text textStyle="body" color="text.subtle">{item.description}</Text>
      </Flex>
    </Card>
  ))}
</Grid>
```

### Auto-fit Grid (No Breakpoints Needed)

```tsx
<div className={css({
  display: 'grid',
  gridTemplateColumns: 'repeat(auto-fit, minmax(min(100%, 280px), 1fr))',
  gap: '400',
})}>
  {items.map(item => <Card key={item.id}>...</Card>)}
</div>
```

### Responsive Navigation

```tsx
function ResponsiveNav() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <Page.Header>
      <Flex justifyContent="space-between" alignItems="center">
        <ZillowLogo css={{ height: { base: '16px', lg: '24px' }, width: 'auto' }} />
        <Box hideBelow="lg">
          <Flex gap="300" alignItems="center">
            <Button tone="brand" emphasis="filled" size="md">Search</Button>
          </Flex>
        </Box>
        <Box hideFrom="lg">
          <Button
            size="md"
            emphasis="tertiary"
            icon={<IconMenuFilled />}
            onClick={() => setIsOpen(!isOpen)}
            aria-expanded={isOpen}
            aria-label="Toggle menu"
          />
        </Box>
      </Flex>
    </Page.Header>
  );
}
```

### Fluid Typography

```css
h1 { font-size: clamp(1.75rem, 4vw + 1rem, 3rem); }
h2 { font-size: clamp(1.5rem, 3vw + 0.75rem, 2.5rem); }
body { font-size: clamp(1rem, 0.95rem + 0.25vw, 1.125rem); }
```

### Dynamic Viewport Height (Mobile)

```tsx
<div className={css({
  minHeight: '100dvh',
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'center',
})}>
  Hero content
</div>
```

### Responsive Images

```tsx
<picture>
  <source media="(min-width: 1024px)" srcSet="/hero-wide.webp" type="image/webp" />
  <source media="(min-width: 768px)" srcSet="/hero-medium.webp" type="image/webp" />
  <source srcSet="/hero-mobile.webp" type="image/webp" />
  <img src="/hero-mobile.jpg" alt="Description" loading="eager" fetchPriority="high"
    style={{ width: '100%', height: 'auto' }} />
</picture>
```

## Touch Targets

Minimum 44x44px for all interactive elements (WCAG 2.2 requires 24x24px minimum):

```tsx
<Button size="md" css={{ minHeight: '44px', minWidth: '44px' }}>
  Tap me
</Button>
```

## Constellation Component Sizing

| Audience | Button/Input Size | Why |
|----------|------------------|-----|
| Professional | `size="md"` always | Consistent, efficient UI |
| Consumer | `size="md"` default, `size="lg"` for hero CTAs | Welcoming, touch-friendly |

## Performance Checklist

| Area | Technique |
|------|-----------|
| Images | `loading="lazy"`, `srcset`, WebP/AVIF, explicit `width`/`height` |
| Fonts | `font-display: swap`, preload critical fonts |
| CLS | Always set `width`/`height` or `aspect-ratio` on images |
| LCP | `fetchPriority="high"` on hero image, preload LCP resource |
| INP | Debounce resize handlers, use `requestIdleCallback` |
| CSS | Use PandaCSS (zero-runtime), avoid runtime CSS-in-JS |

## Accessibility Checklist

| Requirement | Implementation |
|-------------|---------------|
| Reflow at 320px | Content must not require horizontal scroll at 320px width |
| 200% zoom | All content accessible at 200% browser zoom |
| Touch targets | 44x44px minimum (48px preferred) |
| Focus indicators | 3:1 contrast ratio, visible on all elements |
| Reduced motion | `@media (prefers-reduced-motion: reduce)` |
| Orientation | Support both portrait and landscape |
| Keyboard nav | All mobile interactions work via keyboard |

## NEVER Do

| NEVER | ALWAYS Instead |
|-------|----------------|
| Fixed pixel widths for layouts | Relative units (%, rem, fr) |
| `100vh` on mobile (causes jump) | `100dvh` with `100vh` fallback |
| Hide content with `display: none` without alternative | Use `hideBelow`/`hideFrom` or provide mobile equivalent |
| Disable pinch-to-zoom | Allow zoom in viewport meta |
| Small touch targets (<44px) | Minimum 44x44px with adequate spacing |
| Center long paragraphs | Left-align body text, center only short headlines |
| Device-specific breakpoints | Content-based breakpoints |
| Nest many container queries | Strategic placement, prefer `inline-size` |
