# Modern Responsive CSS Techniques (2025)

Comprehensive reference for building responsive interfaces with modern CSS. Examples show plain CSS and PandaCSS/React equivalents where applicable.

---

## 1. Container Queries

Container queries let components respond to their container's size rather than the viewport. This enables truly reusable, context-aware components.

### container-type: inline-size vs size

```css
.card-container {
  container-type: inline-size;
}

.full-container {
  container-type: size;
}
```

| Value | Tracks | Performance | Use When |
|-------|--------|-------------|----------|
| `inline-size` | Width only | Better (no height containment needed) | Most cases — cards, sidebars, content areas |
| `size` | Width + Height | Heavier (requires height containment) | Only when querying both dimensions |

**Always prefer `inline-size`** unless you explicitly need height queries. `size` establishes containment on both axes, which can cause layout issues if the element's height depends on its content.

### Named Containers

```css
.sidebar {
  container-type: inline-size;
  container-name: sidebar;
}

.main-content {
  container-type: inline-size;
  container-name: main;
}

/* Shorthand */
.sidebar {
  container: sidebar / inline-size;
}

@container sidebar (min-width: 300px) {
  .sidebar-widget {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }
}

@container main (min-width: 600px) {
  .article-card {
    flex-direction: row;
  }
}
```

### Container Query Syntax

```css
.container {
  container: card / inline-size;
}

@container card (min-width: 400px) {
  .card-body {
    display: flex;
    gap: 1rem;
  }
}

@container card (max-width: 399px) {
  .card-body {
    display: block;
  }
}

@container card (width > 600px) {
  .card-body {
    grid-template-columns: 2fr 1fr;
  }
}
```

### Container Query Units

| Unit | Meaning | Relative To |
|------|---------|-------------|
| `cqi` | Container query inline size | 1% of container's inline (width in LTR) |
| `cqw` | Container query width | 1% of container's width |
| `cqh` | Container query height | 1% of container's height |
| `cqmin` | Smaller of cqi/cqb | min(cqi, cqb) |
| `cqmax` | Larger of cqi/cqb | max(cqi, cqb) |

```css
.container {
  container-type: inline-size;
}

.responsive-text {
  font-size: clamp(0.875rem, 3cqi, 1.5rem);
  padding: 2cqi;
}

.responsive-heading {
  font-size: clamp(1.25rem, 5cqi + 0.5rem, 3rem);
}
```

### Style Queries with Custom Properties

```css
.card {
  --card-variant: default;
}

.card.featured {
  --card-variant: featured;
}

@container style(--card-variant: featured) {
  .card-title {
    font-size: 1.5rem;
    color: var(--color-accent);
  }
  .card-image {
    aspect-ratio: 16 / 9;
  }
}

@container style(--card-variant: default) {
  .card-title {
    font-size: 1rem;
  }
  .card-image {
    aspect-ratio: 1 / 1;
  }
}
```

### Combining Conditions

```css
@container card (min-width: 400px) and (max-width: 799px) {
  .card-body {
    grid-template-columns: 1fr 1fr;
  }
}

@container (min-width: 300px) or (orientation: landscape) {
  .widget {
    flex-direction: row;
  }
}

@container not (max-width: 399px) {
  .detail {
    display: block;
  }
}
```

### PandaCSS / React Equivalent

```tsx
import { css } from '@/styled-system/css';

function ProductCard({ product }: { product: Product }) {
  return (
    <div className={css({
      containerType: 'inline-size',
      containerName: 'product-card',
    })}>
      <div className={css({
        display: 'flex',
        flexDirection: 'column',
        gap: '200',
        '@container product-card (min-width: 400px)': {
          flexDirection: 'row',
          gap: '400',
        },
        '@container product-card (min-width: 700px)': {
          gap: '600',
        },
      })}>
        <img src={product.image} alt={product.name} className={css({
          width: '100%',
          aspectRatio: '1',
          objectFit: 'cover',
          borderRadius: 'node.md',
          '@container product-card (min-width: 400px)': {
            width: '200px',
            aspectRatio: '4/3',
          },
        })} />
        <div>
          <Text textStyle="body-bold">{product.name}</Text>
          <Text textStyle="body" color="text.subtle">{product.description}</Text>
        </div>
      </div>
    </div>
  );
}
```

### Performance Considerations

1. **Prefer `inline-size` over `size`** — avoids unnecessary height containment
2. **Avoid deep nesting** — container queries inside container queries create layout dependency chains
3. **Limit container query depth to 2 levels** — deeper nesting causes recalculation cascades
4. **Use named containers** — prevents unintended matching against ancestor containers
5. **Avoid querying `size` on elements with content-dependent height** — can cause infinite layout loops

### Browser Support

| Browser | Version | Date |
|---------|---------|------|
| Chrome | 105+ | Aug 2022 |
| Firefox | 110+ | Feb 2023 |
| Safari | 16+ | Sep 2022 |
| Edge | 105+ | Aug 2022 |

Style queries: Chrome 111+, Safari 18+, Firefox 128+.

### Fallback Strategies with @supports

```css
.card-body {
  display: flex;
  flex-direction: column;
}

@media (min-width: 600px) {
  .card-body {
    flex-direction: row;
  }
}

@supports (container-type: inline-size) {
  .card-container {
    container-type: inline-size;
  }

  @container (min-width: 400px) {
    .card-body {
      flex-direction: row;
    }
  }

  @media (min-width: 600px) {
    .card-body {
      flex-direction: unset;
    }
  }
}
```

```tsx
// PandaCSS fallback
<div className={css({
  display: 'flex',
  flexDirection: 'column',
  md: { flexDirection: 'row' },
  '@supports (container-type: inline-size)': {
    containerType: 'inline-size',
  },
  '@container (min-width: 400px)': {
    flexDirection: 'row',
  },
})}>
```

---

## 2. Fluid Typography with clamp()

### The clamp(min, preferred, max) Formula

```
clamp(MIN, PREFERRED, MAX)
```

- **MIN**: Absolute minimum size (usually in `rem`)
- **PREFERRED**: Fluid value that scales (viewport-based calculation)
- **MAX**: Absolute maximum size (usually in `rem`)

The preferred value typically uses the formula: `y-intercept(rem) + slope(vw)`

### Calculating Slope and Y-Intercept

Given a desired range:
- Font should be `minSize` at viewport `minWidth`
- Font should be `maxSize` at viewport `maxWidth`

```
slope = (maxSize - minSize) / (maxWidth - minWidth)
y-intercept = minSize - slope × minWidth
preferred = y-intercept(rem) + slope(vw)
```

Example: 1rem at 320px → 1.5rem at 1280px

```
slope = (1.5 - 1) / (80 - 20) = 0.00833
In vw: 0.00833 × 100 = 0.833vw
y-intercept = 1 - (0.00833 × 20) = 0.833rem

Result: clamp(1rem, 0.833rem + 0.833vw, 1.5rem)
```

### Complete Fluid Type Scale

```css
:root {
  --font-xs:   clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem);
  --font-sm:   clamp(0.875rem, 0.8rem + 0.375vw, 1rem);
  --font-base: clamp(1rem, 0.925rem + 0.375vw, 1.125rem);
  --font-lg:   clamp(1.125rem, 0.95rem + 0.875vw, 1.5rem);
  --font-xl:   clamp(1.25rem, 1rem + 1.25vw, 1.75rem);
  --font-2xl:  clamp(1.5rem, 1.1rem + 2vw, 2.25rem);
  --font-3xl:  clamp(1.875rem, 1.3rem + 2.875vw, 3rem);
  --font-4xl:  clamp(2.25rem, 1.5rem + 3.75vw, 3.75rem);
  --font-5xl:  clamp(3rem, 2rem + 5vw, 5rem);
}
```

### Fluid Spacing Scale

```css
:root {
  --space-3xs: clamp(0.25rem, 0.2rem + 0.25vw, 0.375rem);
  --space-2xs: clamp(0.5rem, 0.425rem + 0.375vw, 0.625rem);
  --space-xs:  clamp(0.75rem, 0.65rem + 0.5vw, 1rem);
  --space-sm:  clamp(1rem, 0.85rem + 0.75vw, 1.25rem);
  --space-md:  clamp(1.5rem, 1.3rem + 1vw, 2rem);
  --space-lg:  clamp(2rem, 1.65rem + 1.75vw, 3rem);
  --space-xl:  clamp(3rem, 2.5rem + 2.5vw, 4rem);
  --space-2xl: clamp(4rem, 3.3rem + 3.5vw, 6rem);
  --space-3xl: clamp(6rem, 5rem + 5vw, 8rem);
}
```

### TypeScript Utility Function

```typescript
interface FluidValueOptions {
  minSize: number;
  maxSize: number;
  minViewport?: number;
  maxViewport?: number;
  unit?: 'rem' | 'px';
  clampMin?: boolean;
  clampMax?: boolean;
}

function fluidValue({
  minSize,
  maxSize,
  minViewport = 320,
  maxViewport = 1280,
  unit = 'rem',
  clampMin = true,
  clampMax = true,
}: FluidValueOptions): string {
  const minVw = minViewport / 16;
  const maxVw = maxViewport / 16;
  const slope = (maxSize - minSize) / (maxVw - minVw);
  const yIntercept = minSize - slope * minVw;
  const slopeVw = +(slope * 100).toFixed(4);
  const intercept = +yIntercept.toFixed(4);

  const preferred = `${intercept}${unit} + ${slopeVw}vw`;

  if (clampMin && clampMax) {
    return `clamp(${minSize}${unit}, ${preferred}, ${maxSize}${unit})`;
  }
  if (clampMin) {
    return `max(${minSize}${unit}, ${preferred})`;
  }
  if (clampMax) {
    return `min(${preferred}, ${maxSize}${unit})`;
  }
  return `calc(${preferred})`;
}

function fluidTypeScale(baseSizeMin: number, baseSizeMax: number, ratio: number, steps: number) {
  const scale: Record<string, string> = {};
  const names = ['xs', 'sm', 'base', 'lg', 'xl', '2xl', '3xl', '4xl', '5xl'];
  const baseIndex = 2;

  for (let i = 0; i < steps; i++) {
    const power = i - baseIndex;
    const min = baseSizeMin * Math.pow(ratio, power);
    const max = baseSizeMax * Math.pow(ratio, power);
    scale[`--font-${names[i]}`] = fluidValue({
      minSize: +min.toFixed(3),
      maxSize: +max.toFixed(3),
    });
  }

  return scale;
}
```

### Integration with CSS Custom Properties

```css
:root {
  --font-base: clamp(1rem, 0.925rem + 0.375vw, 1.125rem);
  --font-lg: clamp(1.125rem, 0.95rem + 0.875vw, 1.5rem);
  --space-md: clamp(1.5rem, 1.3rem + 1vw, 2rem);
}

.article {
  font-size: var(--font-base);
  line-height: 1.6;
  padding: var(--space-md);
}

.article h2 {
  font-size: var(--font-lg);
  margin-block: var(--space-md);
}
```

```tsx
// PandaCSS with CSS variables
import { css } from '@/styled-system/css';

const fluidStyles = css({
  fontSize: 'clamp(1rem, 0.925rem + 0.375vw, 1.125rem)',
  padding: 'clamp(1.5rem, 1.3rem + 1vw, 2rem)',
});

// Or define in PandaCSS config as tokens
// panda.config.ts
const pandaConfig = {
  theme: {
    extend: {
      tokens: {
        fontSizes: {
          'fluid-sm': { value: 'clamp(0.875rem, 0.8rem + 0.375vw, 1rem)' },
          'fluid-base': { value: 'clamp(1rem, 0.925rem + 0.375vw, 1.125rem)' },
          'fluid-lg': { value: 'clamp(1.125rem, 0.95rem + 0.875vw, 1.5rem)' },
          'fluid-xl': { value: 'clamp(1.25rem, 1rem + 1.25vw, 1.75rem)' },
        },
      },
    },
  },
};
```

---

## 3. Dynamic Viewport Units

### The Problem with 100vh on Mobile

On mobile browsers, `100vh` represents the viewport height when the browser UI (address bar, toolbar) is fully retracted. When the browser UI is visible, content set to `100vh` overflows the visible area, causing layout jumps and hidden content.

### Unit Definitions

| Unit | Name | Behavior |
|------|------|----------|
| `dvh` | Dynamic viewport height | Updates live as browser UI animates in/out |
| `svh` | Small viewport height | Viewport when browser UI is fully expanded (smallest possible) |
| `lvh` | Large viewport height | Viewport when browser UI is fully retracted (largest possible) |
| `dvw` | Dynamic viewport width | Dynamic equivalent for width (rarely changes) |
| `svw` | Small viewport width | Width with all browser UI visible |
| `lvw` | Large viewport width | Width with browser UI hidden |

### When to Use Which Unit

| Use Case | Unit | Why |
|----------|------|-----|
| Full-screen hero | `dvh` | Seamlessly tracks browser UI changes |
| Sticky header offset | `svh` | Ensures header doesn't get hidden behind browser UI |
| Modal/overlay height | `lvh` | Prevents modal from resizing during scroll |
| Full-page app shell | `dvh` | App always fills the visible area |
| Bottom navigation spacing | `svh` | Safe area above mobile browser toolbar |
| Scroll-snap sections | `svh` | Consistent snap points regardless of browser UI |

### Plain CSS

```css
.hero {
  min-height: 100dvh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.sticky-header {
  position: sticky;
  top: 0;
  height: 60px;
  z-index: 100;
}

.below-header {
  min-height: calc(100svh - 60px);
}

.modal-overlay {
  position: fixed;
  inset: 0;
  height: 100lvh;
}

.app-shell {
  display: grid;
  grid-template-rows: auto 1fr auto;
  min-height: 100dvh;
}
```

### Progressive Enhancement Fallback

```css
.hero {
  min-height: 100vh;
  min-height: 100dvh;
}

.full-page {
  height: 100vh;
  height: 100dvh;
}

@supports (height: 100dvh) {
  .hero {
    min-height: 100dvh;
  }
}

@supports not (height: 100dvh) {
  .hero {
    min-height: -webkit-fill-available;
  }
}
```

### PandaCSS / React

```tsx
import { css } from '@/styled-system/css';

function HeroSection() {
  return (
    <section className={css({
      minHeight: '100dvh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '400',
    })}>
      <Heading textStyle="heading-lg">Welcome</Heading>
    </section>
  );
}

function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <div className={css({
      display: 'grid',
      gridTemplateRows: 'auto 1fr auto',
      minHeight: '100dvh',
    })}>
      <header className={css({ position: 'sticky', top: 0 })}>
        <Page.Header>Navigation</Page.Header>
      </header>
      <main>{children}</main>
      <footer>Footer</footer>
    </div>
  );
}

function FullScreenModal({ isOpen }: { isOpen: boolean }) {
  if (!isOpen) return null;
  return (
    <div className={css({
      position: 'fixed',
      inset: 0,
      height: '100lvh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      bg: 'rgba(0, 0, 0, 0.5)',
      zIndex: 50,
    })}>
      <div className={css({
        bg: 'bg.screen.neutral',
        borderRadius: 'node.md',
        maxHeight: '90svh',
        overflow: 'auto',
        p: '400',
      })}>
        Modal content
      </div>
    </div>
  );
}
```

### Browser Support

| Browser | Version | Date |
|---------|---------|------|
| Chrome | 108+ | Nov 2022 |
| Safari | 15.4+ | Mar 2022 |
| Firefox | 101+ | May 2022 |
| Edge | 108+ | Nov 2022 |

---

## 4. CSS Grid Advanced Patterns

### auto-fit vs auto-fill with minmax()

```css
/* auto-fit: columns stretch to fill available space when few items */
.grid-fit {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

/* auto-fill: maintains column tracks even when empty */
.grid-fill {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1rem;
}
```

| | Few Items | Many Items |
|--|-----------|------------|
| `auto-fit` | Columns stretch to fill row | Same as auto-fill |
| `auto-fill` | Empty tracks preserved, items don't stretch | Same as auto-fit |

**Use `auto-fit`** when items should expand. **Use `auto-fill`** when you want consistent column widths.

### Safe Minimums with min()

The problem: `minmax(250px, 1fr)` overflows on viewports narrower than 250px.

```css
.safe-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 280px), 1fr));
  gap: 1rem;
}
```

`min(100%, 280px)` ensures columns never exceed their container, even on small screens.

```tsx
// PandaCSS
<div className={css({
  display: 'grid',
  gridTemplateColumns: 'repeat(auto-fit, minmax(min(100%, 280px), 1fr))',
  gap: '400',
})}>
  {items.map(item => <Card key={item.id} outlined elevated={false} tone="neutral">...</Card>)}
</div>
```

### Grid Template Areas with Responsive Named Areas

```css
.layout {
  display: grid;
  grid-template-areas:
    "header"
    "main"
    "sidebar"
    "footer";
  grid-template-rows: auto 1fr auto auto;
  min-height: 100dvh;
}

@media (min-width: 768px) {
  .layout {
    grid-template-areas:
      "header  header"
      "sidebar main"
      "footer  footer";
    grid-template-columns: 250px 1fr;
    grid-template-rows: auto 1fr auto;
  }
}

@media (min-width: 1200px) {
  .layout {
    grid-template-areas:
      "header header  header"
      "nav    main    sidebar"
      "footer footer  footer";
    grid-template-columns: 200px 1fr 300px;
  }
}

.header  { grid-area: header; }
.main    { grid-area: main; }
.sidebar { grid-area: sidebar; }
.footer  { grid-area: footer; }
```

```tsx
// PandaCSS responsive grid areas
<div className={css({
  display: 'grid',
  gridTemplateAreas: {
    base: '"header" "main" "sidebar" "footer"',
    lg: '"header header" "sidebar main" "footer footer"',
  },
  gridTemplateColumns: { base: '1fr', lg: '250px 1fr' },
  gridTemplateRows: { base: 'auto 1fr auto auto', lg: 'auto 1fr auto' },
  minHeight: '100dvh',
})}>
  <header className={css({ gridArea: 'header' })}><Page.Header>Nav</Page.Header></header>
  <aside className={css({ gridArea: 'sidebar' })}>Sidebar</aside>
  <main className={css({ gridArea: 'main' })}>Content</main>
  <footer className={css({ gridArea: 'footer' })}>Footer</footer>
</div>
```

### Subgrid

Subgrid lets nested elements align to their parent grid's tracks.

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 300px), 1fr));
  gap: 1rem;
}

.card {
  display: grid;
  grid-template-rows: subgrid;
  grid-row: span 3;
}
```

This ensures all cards in a row have aligned title, body, and footer sections, regardless of content length.

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: auto;
  gap: 1.5rem;
}

.card {
  display: grid;
  grid-row: span 3;
  grid-template-rows: subgrid;
  gap: 0;
}

.card-header  { align-self: start; }
.card-body    { align-self: start; }
.card-footer  { align-self: end; }
```

Browser support: Chrome 117+, Firefox 71+, Safari 16+.

### Intrinsic Sizing

```css
.tag {
  width: fit-content;
  padding: 0.25rem 0.75rem;
}

.truncated-heading {
  width: min-content;
  overflow-wrap: break-word;
}

.wide-element {
  width: max-content;
  white-space: nowrap;
}

.column {
  grid-template-columns: fit-content(200px) 1fr fit-content(300px);
}
```

| Function | Behavior |
|----------|----------|
| `fit-content` | Shrinks to content but won't exceed available space |
| `min-content` | Smallest size without overflow (wraps text at every opportunity) |
| `max-content` | Largest size the content wants (no wrapping) |
| `fit-content(max)` | Like `fit-content` but with a maximum limit |

---

## 5. Flexbox Fluid Patterns

### Sidebar Layout (flex-grow: 999)

Content takes up all available space; sidebar has a fixed basis. When there isn't enough room, they stack.

```css
.with-sidebar {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.with-sidebar > :first-child {
  flex-basis: 250px;
  flex-grow: 1;
}

.with-sidebar > :last-child {
  flex-basis: 0;
  flex-grow: 999;
  min-inline-size: 60%;
}
```

The `min-inline-size: 60%` on the main content forces a wrap when the container is too narrow, causing the sidebar to stack above/below.

```tsx
// PandaCSS sidebar layout
function SidebarLayout({ sidebar, children }: { sidebar: React.ReactNode; children: React.ReactNode }) {
  return (
    <div className={css({
      display: 'flex',
      flexWrap: 'wrap',
      gap: '400',
    })}>
      <aside className={css({
        flexBasis: '250px',
        flexGrow: 1,
      })}>
        {sidebar}
      </aside>
      <main className={css({
        flexBasis: 0,
        flexGrow: 999,
        minInlineSize: '60%',
      })}>
        {children}
      </main>
    </div>
  );
}
```

### Switcher Layout

Items display in a row when the container is wide enough; they stack into a column when it's narrow. No media queries needed.

```css
.switcher {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.switcher > * {
  flex-grow: 1;
  flex-basis: calc((40rem - 100%) * 999);
}
```

When the container is wider than `40rem`, `flex-basis` becomes a large negative number (effectively 0), so items sit in a row. When narrower, `flex-basis` becomes a large positive number, forcing each item to take full width.

```tsx
// PandaCSS switcher
<div className={css({
  display: 'flex',
  flexWrap: 'wrap',
  gap: '400',
  '& > *': {
    flexGrow: 1,
    flexBasis: 'calc((40rem - 100%) * 999)',
  },
})}>
  <Card outlined elevated={false} tone="neutral">Item 1</Card>
  <Card outlined elevated={false} tone="neutral">Item 2</Card>
  <Card outlined elevated={false} tone="neutral">Item 3</Card>
</div>
```

### Cluster Layout

Wrapping inline items with consistent spacing — ideal for tags, badges, buttons.

```css
.cluster {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  align-items: center;
}
```

```tsx
// PandaCSS cluster
<Flex wrap="wrap" gap="200" alignItems="center">
  <Tag size="sm" tone="blue">React</Tag>
  <Tag size="sm" tone="blue">TypeScript</Tag>
  <Tag size="sm" tone="blue">PandaCSS</Tag>
</Flex>
```

### Holy Grail Layout

Header, footer, main content, and two sidebars — fully responsive.

```css
.holy-grail {
  display: grid;
  grid-template: auto 1fr auto / 1fr;
  min-height: 100dvh;
}

@media (min-width: 768px) {
  .holy-grail {
    grid-template:
      "header header  header"  auto
      "nav    main    aside"   1fr
      "footer footer  footer"  auto
      / 200px 1fr 250px;
  }
}

.holy-grail > header { grid-area: header; }
.holy-grail > nav    { grid-area: nav; }
.holy-grail > main   { grid-area: main; }
.holy-grail > aside  { grid-area: aside; }
.holy-grail > footer { grid-area: footer; }
```

```tsx
// PandaCSS holy grail
<div className={css({
  display: 'grid',
  gridTemplate: { base: 'auto 1fr auto / 1fr', lg: '"header header header" auto "nav main aside" 1fr "footer footer footer" auto / 200px 1fr 250px' },
  minHeight: '100dvh',
})}>
  <header className={css({ gridArea: { lg: 'header' } })}><Page.Header>Site</Page.Header></header>
  <nav className={css({ gridArea: { lg: 'nav' }, display: { base: 'none', lg: 'block' } })}>Nav</nav>
  <main className={css({ gridArea: { lg: 'main' }, p: '400' })}>Content</main>
  <aside className={css({ gridArea: { lg: 'aside' }, display: { base: 'none', lg: 'block' } })}>Aside</aside>
  <footer className={css({ gridArea: { lg: 'footer' } })}>Footer</footer>
</div>
```

---

## 6. Modern CSS Functions

### min(), max(), clamp() Combinations

```css
/* Responsive padding: at least 1rem, at most 3rem, scales with viewport */
.section {
  padding: clamp(1rem, 5vw, 3rem);
}

/* Width that never exceeds container or 600px */
.form {
  width: min(100%, 600px);
}

/* At least 300px, but grows if viewport allows */
.sidebar {
  width: max(300px, 25vw);
}

/* Combining: responsive gap with a floor */
.grid {
  gap: max(1rem, 2vw);
}
```

### Responsive Widths Without Media Queries

```css
.container {
  width: min(100% - 2rem, 1200px);
  margin-inline: auto;
}

.narrow-container {
  width: min(100% - 2rem, 720px);
  margin-inline: auto;
}

.card {
  width: min(100%, 400px);
}

.responsive-columns {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 300px), 1fr));
  gap: clamp(1rem, 3vw, 2rem);
  padding: clamp(1rem, 5vw, 3rem);
}
```

```tsx
// PandaCSS container width
<div className={css({
  width: 'min(100% - 2rem, 1200px)',
  marginInline: 'auto',
  padding: 'clamp(1rem, 5vw, 3rem)',
})}>
  <Grid
    columns={{ base: 1, md: 2, xl: 3 }}
    gap="400"
  >
    {children}
  </Grid>
</div>
```

### Advanced Combinations

```css
/* Responsive font that respects user preferences */
.heading {
  font-size: clamp(1.5rem, 1rem + 2vw, 3rem);
  line-height: clamp(1.2, 1.1 + 0.2vw, 1.4);
}

/* Responsive aspect ratio container */
.video-wrapper {
  width: min(100%, 800px);
  aspect-ratio: 16 / 9;
  margin-inline: auto;
}

/* Responsive border-radius */
.card {
  border-radius: min(1.5rem, 4vw);
}

/* Responsive image grid with consistent spacing */
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 200px), 1fr));
  gap: clamp(0.5rem, 1.5vw, 1.5rem);
  padding: clamp(0.5rem, 2vw, 2rem);
}
```

---

## 7. Feature Queries (@supports)

### Progressive Enhancement for Container Queries

```css
.component {
  display: flex;
  flex-direction: column;
}

@media (min-width: 600px) {
  .component {
    flex-direction: row;
  }
}

@supports (container-type: inline-size) {
  .component-wrapper {
    container-type: inline-size;
  }

  @container (min-width: 500px) {
    .component {
      flex-direction: row;
    }
  }
}

@supports (grid-template-rows: subgrid) {
  .card-grid .card {
    display: grid;
    grid-row: span 3;
    grid-template-rows: subgrid;
  }
}

@supports not (grid-template-rows: subgrid) {
  .card-grid .card {
    display: flex;
    flex-direction: column;
  }
  .card-grid .card-footer {
    margin-top: auto;
  }
}
```

### Combining @supports with @media

```css
@supports (container-type: inline-size) and (height: 100dvh) {
  .app-shell {
    min-height: 100dvh;
    container-type: inline-size;
  }
}

@media (min-width: 768px) {
  @supports (grid-template-rows: subgrid) {
    .feature-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
    }
    .feature-grid > .card {
      grid-row: span 2;
      grid-template-rows: subgrid;
    }
  }
}

/* Feature detection for has() selector */
@supports selector(:has(*)) {
  .form-field:has(:invalid) {
    border-color: var(--color-error);
  }
}

/* Nesting @supports within @media */
@media (min-width: 1024px) {
  @supports (container-type: inline-size) {
    .dashboard-widget {
      container-type: inline-size;
    }
    @container (min-width: 400px) {
      .widget-content {
        grid-template-columns: 1fr 1fr;
      }
    }
  }
}
```

```tsx
// PandaCSS @supports
<div className={css({
  display: 'flex',
  flexDirection: 'column',
  md: { flexDirection: 'row' },
  '@supports (container-type: inline-size)': {
    containerType: 'inline-size',
  },
  '@container (min-width: 500px)': {
    flexDirection: 'row',
    gap: '400',
  },
})}>
```

---

## 8. Preference Media Queries

### prefers-color-scheme

```css
:root {
  --bg-primary: #ffffff;
  --text-primary: #111116;
  --border-color: #e0e0e0;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg-primary: #1a1a2e;
    --text-primary: #e0e0e0;
    --border-color: #333;
  }
}

.card {
  background: var(--bg-primary);
  color: var(--text-primary);
  border: 1px solid var(--border-color);
}
```

```tsx
// PandaCSS with Constellation theme support
import { css } from '@/styled-system/css';

<div className={css({
  bg: 'bg.screen.neutral',
  color: 'text.default',
  _osDark: {
    bg: 'bg.screen.neutral',
    color: 'text.default',
  },
})}>
```

### prefers-reduced-motion

```css
@media (prefers-reduced-motion: no-preference) {
  .animated-element {
    transition: transform 0.3s ease, opacity 0.3s ease;
  }

  .scroll-reveal {
    animation: fadeInUp 0.6s ease-out;
  }
}

@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

```tsx
// PandaCSS reduced motion
<div className={css({
  transition: 'transform 0.3s ease, opacity 0.3s ease',
  _motionReduce: {
    transition: 'none',
    animation: 'none',
  },
})}>

// React hook for motion preference
function usePrefersReducedMotion() {
  const [prefersReduced, setPrefersReduced] = useState(false);

  useEffect(() => {
    const mql = window.matchMedia('(prefers-reduced-motion: reduce)');
    setPrefersReduced(mql.matches);

    const handler = (e: MediaQueryListEvent) => setPrefersReduced(e.matches);
    mql.addEventListener('change', handler);
    return () => mql.removeEventListener('change', handler);
  }, []);

  return prefersReduced;
}
```

### prefers-contrast: high

```css
@media (prefers-contrast: high) {
  :root {
    --border-color: #000;
    --text-subtle: #333;
    --focus-ring: 3px solid #000;
  }

  .card {
    border: 2px solid var(--border-color);
  }

  .button {
    border: 2px solid currentColor;
  }

  .subtle-text {
    color: var(--text-subtle);
  }

  *:focus-visible {
    outline: var(--focus-ring);
    outline-offset: 2px;
  }
}

@media (prefers-contrast: more) {
  .card {
    border-width: 2px;
  }
}

@media (prefers-contrast: less) {
  .card {
    border: none;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  }
}
```

```tsx
// PandaCSS contrast handling
<div className={css({
  border: '1px solid',
  borderColor: 'border.default',
  '@media (prefers-contrast: high)': {
    borderWidth: '2px',
    borderColor: '#000',
  },
})}>
```

### prefers-reduced-data

```css
@media (prefers-reduced-data: reduce) {
  .hero-image {
    display: none;
  }

  .hero-fallback {
    display: block;
    background: var(--bg-accent);
  }

  .decorative-video {
    display: none;
  }

  img[loading="lazy"] {
    content-visibility: auto;
  }
}

@media (prefers-reduced-data: no-preference) {
  .hero-image {
    display: block;
  }

  .hero-fallback {
    display: none;
  }
}
```

```tsx
// React hook for reduced data preference
function usePrefersReducedData() {
  const [prefersReduced, setPrefersReduced] = useState(false);

  useEffect(() => {
    const mql = window.matchMedia('(prefers-reduced-data: reduce)');
    setPrefersReduced(mql.matches);

    const handler = (e: MediaQueryListEvent) => setPrefersReduced(e.matches);
    mql.addEventListener('change', handler);
    return () => mql.removeEventListener('change', handler);
  }, []);

  return prefersReduced;
}

function HeroSection() {
  const reducedData = usePrefersReducedData();

  return (
    <section className={css({ position: 'relative', minHeight: '60dvh' })}>
      {!reducedData && (
        <img
          src="/hero-large.webp"
          alt=""
          className={css({ position: 'absolute', inset: 0, objectFit: 'cover', width: '100%', height: '100%' })}
        />
      )}
      <div className={css({
        position: 'relative',
        zIndex: 1,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: '60dvh',
        bg: reducedData ? 'bg.screen.neutral' : 'transparent',
      })}>
        <Heading textStyle="heading-lg">Welcome</Heading>
      </div>
    </section>
  );
}
```

### Combining Preference Queries

```css
@media (prefers-color-scheme: dark) and (prefers-contrast: high) {
  :root {
    --bg-primary: #000;
    --text-primary: #fff;
    --border-color: #fff;
  }
}

@media (prefers-reduced-motion: reduce) and (prefers-reduced-data: reduce) {
  .hero {
    background: var(--bg-accent);
    animation: none;
  }

  img:not([loading="eager"]) {
    display: none;
  }
}
```

### Browser Support for Preference Queries

| Query | Chrome | Firefox | Safari |
|-------|--------|---------|--------|
| `prefers-color-scheme` | 76+ | 67+ | 12.1+ |
| `prefers-reduced-motion` | 74+ | 63+ | 10.1+ |
| `prefers-contrast` | 96+ | 101+ | 14.1+ |
| `prefers-reduced-data` | No | No | No (experimental) |

`prefers-reduced-data` has very limited support — always provide a no-JS fallback and treat it as progressive enhancement.
