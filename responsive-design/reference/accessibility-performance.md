# Accessibility & Performance Optimization for Responsive Design

## 1. WCAG 2.2 Mobile Responsive Requirements

| Success Criterion | Requirement | Key Rule |
|---|---|---|
| SC 1.4.10 Reflow | Content at 320px CSS width without horizontal scroll | No `overflow-x: scroll` on body |
| SC 2.5.8 Target Size (Minimum) | Interactive targets ≥ 24×24 CSS pixels | WCAG 2.2 minimum |
| SC 1.3.4 Orientation | Support portrait and landscape | Never lock orientation via CSS/JS |
| SC 1.4.4 Resize Text | Readable at 200% browser zoom | Use `rem`/`em`, not `px` for text |
| SC 2.5.7 Dragging Movements | All drag actions must have non-drag alternatives | Provide buttons for reorder/slider |
| EU Accessibility Act | Compliance deadline: **June 28, 2025** | Applies to products/services sold in the EU |

### Recommended Touch Target Sizes

| Standard | Minimum Size |
|---|---|
| WCAG 2.2 (SC 2.5.8) | 24×24px |
| Apple HIG | 44×44px |
| Google Material Design | 48×48px |

### Reflow at 320px

```css
html {
  overflow-x: hidden;
}

.container {
  width: 100%;
  max-width: 100%;
  padding-inline: 16px;
  box-sizing: border-box;
}

.responsive-table {
  display: block;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

img, video, iframe {
  max-width: 100%;
  height: auto;
}
```

```tsx
<Box className={css({
  width: '100%',
  maxWidth: '100%',
  px: '400',
  boxSizing: 'border-box',
})}>
  <Grid columns={{ base: 1, md: 2, xl: 3 }} gap="400">
    {items.map(item => <Card key={item.id}>...</Card>)}
  </Grid>
</Box>
```

### Orientation Support

```css
@media (orientation: portrait) {
  .hero { min-height: 50dvh; }
}

@media (orientation: landscape) {
  .hero { min-height: 80dvh; }
  .sidebar { position: sticky; top: 0; }
}
```

Never lock orientation:

```html
<!-- WRONG -->
<meta name="screen-orientation" content="portrait">

<!-- CORRECT — allow both orientations -->
<meta name="viewport" content="width=device-width, initial-scale=1">
```

### 200% Zoom Support

```css
body {
  font-size: 1rem;
  line-height: 1.5;
}

h1 { font-size: clamp(1.75rem, 4vw + 1rem, 3rem); }
h2 { font-size: clamp(1.5rem, 3vw + 0.75rem, 2.5rem); }

.layout {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.card {
  flex: 1 1 min(100%, 320px);
}
```

### Dragging Movements Alternative

```tsx
function ReorderableList({ items, onReorder }) {
  const moveItem = (index: number, direction: 'up' | 'down') => {
    const newItems = [...items];
    const targetIndex = direction === 'up' ? index - 1 : index + 1;
    if (targetIndex < 0 || targetIndex >= newItems.length) return;
    [newItems[index], newItems[targetIndex]] = [newItems[targetIndex], newItems[index]];
    onReorder(newItems);
  };

  return (
    <ul role="list">
      {items.map((item, index) => (
        <li key={item.id}>
          <span>{item.label}</span>
          <button
            aria-label={`Move ${item.label} up`}
            onClick={() => moveItem(index, 'up')}
            disabled={index === 0}
          >↑</button>
          <button
            aria-label={`Move ${item.label} down`}
            onClick={() => moveItem(index, 'down')}
            disabled={index === items.length - 1}
          >↓</button>
        </li>
      ))}
    </ul>
  );
}
```

---

## 2. Touch Targets

### Minimum Sizes by Platform

| Platform | Min Size | Recommended Spacing |
|---|---|---|
| Apple (HIG) | 44×44px | 8px between targets |
| Google (Material) | 48×48px | 8px between targets |
| WCAG 2.2 | 24×24px | Inline text links exempt |

### Touch-Friendly Buttons

```css
.touch-button {
  min-height: 44px;
  min-width: 44px;
  padding: 12px 24px;
  touch-action: manipulation;
}

.touch-link {
  display: inline-flex;
  align-items: center;
  min-height: 44px;
  padding: 8px 4px;
}

.button-group {
  display: flex;
  gap: 8px;
}
```

```tsx
<Button size="md" css={{ minHeight: '44px', minWidth: '44px' }}>
  Tap me
</Button>

<Flex gap="200">
  <Button size="md">Option A</Button>
  <Button size="md">Option B</Button>
</Flex>
```

### Touch-Friendly Form Elements

```css
input, select, textarea {
  min-height: 44px;
  font-size: 16px;
  padding: 8px 12px;
}

input[type="checkbox"],
input[type="radio"] {
  min-width: 24px;
  min-height: 24px;
}

label {
  display: flex;
  align-items: center;
  gap: 8px;
  min-height: 44px;
  cursor: pointer;
}
```

### Prevent Double-Tap Zoom

```css
button, a, [role="button"] {
  touch-action: manipulation;
}
```

### Accessible Icon Buttons

```tsx
<button
  aria-label="Close dialog"
  className={css({
    minWidth: '44px',
    minHeight: '44px',
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    touchAction: 'manipulation',
  })}
>
  <Icon size="md"><IconCloseFilled /></Icon>
</button>

<Button
  size="md"
  emphasis="tertiary"
  icon={<IconMenuFilled />}
  aria-label="Open navigation menu"
  css={{ minWidth: '44px', minHeight: '44px' }}
/>
```

---

## 3. Core Web Vitals Optimization

| Metric | Target | What It Measures |
|---|---|---|
| LCP | ≤ 2.5s | Loading — largest visible element render time |
| CLS | ≤ 0.1 | Visual stability — unexpected layout shifts |
| INP | ≤ 200ms | Interactivity — input delay to visual update |

### LCP Optimization (≤ 2.5s)

**Prioritize hero image loading:**

```html
<head>
  <link rel="preload" as="image" href="/hero.webp" type="image/webp"
        imagesrcset="/hero-400.webp 400w, /hero-800.webp 800w, /hero-1200.webp 1200w"
        imagesizes="100vw">
  <link rel="preload" as="font" href="/fonts/Inter-var.woff2"
        type="font/woff2" crossorigin>
  <style>
    .hero-img { width: 100%; height: auto; aspect-ratio: 16/9; }
  </style>
</head>
```

```tsx
<img
  src="/hero.webp"
  alt="Hero image"
  width={1200}
  height={675}
  loading="eager"
  fetchPriority="high"
  style={{ width: '100%', height: 'auto' }}
/>
```

**Use modern formats with fallbacks:**

```html
<picture>
  <source srcset="/hero.avif" type="image/avif">
  <source srcset="/hero.webp" type="image/webp">
  <img src="/hero.jpg" alt="Hero" width="1200" height="675"
       loading="eager" fetchpriority="high">
</picture>
```

**Inline critical CSS:**

```html
<head>
  <style>
    body { margin: 0; font-family: system-ui, -apple-system, sans-serif; }
    .hero { width: 100%; aspect-ratio: 16/9; object-fit: cover; }
    .nav { display: flex; align-items: center; padding: 16px; }
  </style>
  <link rel="stylesheet" href="/styles.css" media="print" onload="this.media='all'">
</head>
```

**Font display swap:**

```css
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-var.woff2') format('woff2');
  font-weight: 100 900;
  font-display: swap;
}
```

### CLS Optimization (≤ 0.1)

**Always set dimensions on media:**

```css
img, video {
  max-width: 100%;
  height: auto;
}

.hero-img {
  aspect-ratio: 16 / 9;
  width: 100%;
  object-fit: cover;
}

.thumbnail {
  aspect-ratio: 4 / 3;
  width: 100%;
  object-fit: cover;
}
```

**Reserve space for dynamic content:**

```css
.ad-slot {
  min-height: 250px;
  width: 100%;
  contain: layout;
  background: #f0f0f0;
}

.embed-container {
  aspect-ratio: 16 / 9;
  width: 100%;
  contain: layout;
}

.skeleton {
  min-height: 200px;
  border-radius: 12px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

**Contain layout for isolated components:**

```css
.card {
  contain: layout;
}

.sidebar-widget {
  contain: layout style;
}
```

**Preload fonts to prevent FOIT/FOUT:**

```html
<link rel="preload" as="font" href="/fonts/Inter-var.woff2"
      type="font/woff2" crossorigin>
```

### INP Optimization (≤ 200ms)

**Break up long tasks:**

```typescript
function yieldToMain(): Promise<void> {
  return new Promise(resolve => {
    if ('scheduler' in globalThis && 'yield' in (globalThis as any).scheduler) {
      (globalThis as any).scheduler.yield().then(resolve);
    } else {
      setTimeout(resolve, 0);
    }
  });
}

async function processLargeList(items: any[]) {
  const CHUNK_SIZE = 50;
  for (let i = 0; i < items.length; i += CHUNK_SIZE) {
    const chunk = items.slice(i, i + CHUNK_SIZE);
    chunk.forEach(item => processItem(item));
    await yieldToMain();
  }
}
```

**Debounce/throttle resize handlers:**

```typescript
function debounce<T extends (...args: any[]) => void>(fn: T, ms: number): T {
  let timer: ReturnType<typeof setTimeout>;
  return ((...args: any[]) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), ms);
  }) as T;
}

function throttle<T extends (...args: any[]) => void>(fn: T, ms: number): T {
  let last = 0;
  return ((...args: any[]) => {
    const now = Date.now();
    if (now - last >= ms) {
      last = now;
      fn(...args);
    }
  }) as T;
}

window.addEventListener('resize', debounce(() => {
  recalculateLayout();
}, 150));
```

**Passive event listeners:**

```typescript
document.addEventListener('scroll', handleScroll, { passive: true });
document.addEventListener('touchstart', handleTouch, { passive: true });
document.addEventListener('touchmove', handleTouchMove, { passive: true });
document.addEventListener('wheel', handleWheel, { passive: true });
```

**Code splitting and lazy loading:**

```tsx
import { lazy, Suspense } from 'react';

const HeavyChart = lazy(() => import('./components/HeavyChart'));
const MapView = lazy(() => import('./components/MapView'));

function Dashboard() {
  return (
    <div>
      <header>Dashboard</header>
      <Suspense fallback={<div style={{ minHeight: 400 }}>Loading chart...</div>}>
        <HeavyChart />
      </Suspense>
      <Suspense fallback={<div style={{ minHeight: 400 }}>Loading map...</div>}>
        <MapView />
      </Suspense>
    </div>
  );
}
```

---

## 4. Responsive Images

### Resolution Switching with `srcset`

```html
<img
  srcset="
    /photo-400.webp 400w,
    /photo-800.webp 800w,
    /photo-1200.webp 1200w,
    /photo-1600.webp 1600w
  "
  sizes="
    (max-width: 480px) 100vw,
    (max-width: 768px) 50vw,
    33vw
  "
  src="/photo-800.webp"
  alt="Property exterior"
  width="800"
  height="600"
  loading="lazy"
  decoding="async"
  style="width: 100%; height: auto; aspect-ratio: 4/3;"
>
```

### Art Direction with `<picture>`

```html
<picture>
  <source
    media="(min-width: 1024px)"
    srcset="/hero-wide.avif" type="image/avif">
  <source
    media="(min-width: 1024px)"
    srcset="/hero-wide.webp" type="image/webp">
  <source
    media="(min-width: 768px)"
    srcset="/hero-medium.avif" type="image/avif">
  <source
    media="(min-width: 768px)"
    srcset="/hero-medium.webp" type="image/webp">
  <source srcset="/hero-mobile.avif" type="image/avif">
  <source srcset="/hero-mobile.webp" type="image/webp">
  <img
    src="/hero-mobile.jpg"
    alt="Featured property"
    width="800" height="600"
    loading="eager"
    fetchpriority="high"
  >
</picture>
```

### Loading Strategy

| Position | Attributes | Why |
|---|---|---|
| Above the fold (LCP) | `loading="eager"` `fetchpriority="high"` | Render ASAP |
| Above the fold (non-LCP) | `loading="eager"` | Don't delay |
| Below the fold | `loading="lazy"` `decoding="async"` | Save bandwidth |

### Prevent CLS with `aspect-ratio`

```css
.property-photo {
  aspect-ratio: 4 / 3;
  width: 100%;
  object-fit: cover;
  border-radius: 12px;
  background-color: #f0f0f0;
}

.hero-banner {
  aspect-ratio: 16 / 9;
  width: 100%;
  object-fit: cover;
}

.avatar {
  aspect-ratio: 1 / 1;
  width: 48px;
  border-radius: 50%;
  object-fit: cover;
}
```

---

## 5. Reduced Motion and Accessibility Preferences

### Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

.fade-in {
  animation: fadeIn 300ms ease-out;
}

@media (prefers-reduced-motion: reduce) {
  .fade-in {
    animation: none;
    opacity: 1;
  }
}
```

```tsx
const prefersReducedMotion =
  window.matchMedia('(prefers-reduced-motion: reduce)').matches;

const animationDuration = prefersReducedMotion ? 0 : 300;
```

### High Contrast

```css
@media (prefers-contrast: high) {
  :root {
    --border-color: #000;
    --text-color: #000;
    --bg-color: #fff;
  }

  button {
    border: 2px solid #000;
  }

  a {
    text-decoration: underline;
    text-decoration-thickness: 2px;
  }

  .card {
    border: 2px solid #000;
    box-shadow: none;
  }
}
```

### Focus Indicators

```css
:focus-visible {
  outline: 3px solid #0041D9;
  outline-offset: 2px;
  border-radius: 4px;
}

:focus:not(:focus-visible) {
  outline: none;
}

a:focus-visible {
  outline: 3px solid #0041D9;
  outline-offset: 2px;
  text-decoration: underline;
}

@media (forced-colors: active) {
  :focus-visible {
    outline: 3px solid LinkText;
  }
}
```

| Selector | When It Applies | Use For |
|---|---|---|
| `:focus` | All focus (click, tap, keyboard) | Rarely — overrides are needed |
| `:focus-visible` | Keyboard/programmatic focus only | Default choice for visible outlines |
| `:focus:not(:focus-visible)` | Mouse/touch focus | Removing outlines on click |

### Skip Links

```html
<body>
  <a href="#main-content" class="skip-link">Skip to main content</a>
  <nav>...</nav>
  <main id="main-content" tabindex="-1">...</main>
</body>
```

```css
.skip-link {
  position: absolute;
  top: -100%;
  left: 16px;
  z-index: 9999;
  padding: 12px 24px;
  background: #0041D9;
  color: #fff;
  font-weight: 600;
  border-radius: 0 0 8px 8px;
  text-decoration: none;
}

.skip-link:focus {
  top: 0;
}
```

---

## 6. Safe Area Insets

### Notched Device Support

```html
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
```

```css
.app-container {
  padding-top: env(safe-area-inset-top);
  padding-right: env(safe-area-inset-right);
  padding-bottom: env(safe-area-inset-bottom);
  padding-left: env(safe-area-inset-left);
}

.fixed-bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 12px 16px;
  padding-bottom: calc(12px + env(safe-area-inset-bottom));
  background: #fff;
  border-top: 1px solid #e0e0e0;
}

.sticky-header {
  position: sticky;
  top: 0;
  padding-top: env(safe-area-inset-top);
  z-index: 100;
  background: #fff;
}
```

### Full-Bleed Content on Mobile

```css
.full-bleed-hero {
  width: 100vw;
  margin-left: calc(-50vw + 50%);
  padding-left: env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}

.full-bleed-section {
  width: 100%;
  padding: 24px max(16px, env(safe-area-inset-left));
}
```

```tsx
<Box className={css({
  position: 'fixed',
  bottom: 0,
  left: 0,
  right: 0,
  p: '400',
  pb: 'calc(16px + env(safe-area-inset-bottom))',
  bg: 'bg.screen.neutral',
})}>
  <Button size="md" tone="brand" emphasis="filled" css={{ width: '100%' }}>
    Continue
  </Button>
</Box>
```

---

## 7. Responsive Font Loading

### Font Preloading

```html
<head>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="preload" as="font" href="/fonts/Inter-var.woff2"
        type="font/woff2" crossorigin>
  <link rel="preload" as="font" href="/fonts/Inter-italic-var.woff2"
        type="font/woff2" crossorigin>
</head>
```

### `font-display` Strategies

| Value | Behavior | Best For |
|---|---|---|
| `swap` | Shows fallback immediately, swaps when loaded | Body text, most use cases |
| `optional` | May skip custom font on slow connections | Performance-critical pages |
| `fallback` | Short block period (100ms), then fallback | Balance of speed and visual |
| `block` | Invisible text up to 3s | Icon fonts only |

```css
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-var.woff2') format('woff2');
  font-weight: 100 900;
  font-display: swap;
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+2000-206F;
}

@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-var-latin-ext.woff2') format('woff2');
  font-weight: 100 900;
  font-display: swap;
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF;
}
```

### Variable Fonts for Responsive Weight/Width

```css
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-var.woff2') format('woff2');
  font-weight: 100 900;
  font-stretch: 75% 125%;
  font-display: swap;
}

h1 {
  font-variation-settings: 'wght' 700, 'wdth' 100;
}

@media (max-width: 480px) {
  h1 {
    font-variation-settings: 'wght' 600, 'wdth' 87.5;
  }
}
```

### System Font Stack Fallback

```css
:root {
  font-family:
    'Inter',
    system-ui,
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    Roboto,
    'Helvetica Neue',
    Arial,
    'Noto Sans',
    sans-serif,
    'Apple Color Emoji',
    'Segoe UI Emoji';
}
```

Metric-compatible fallback to reduce CLS:

```css
@font-face {
  font-family: 'Inter Fallback';
  src: local('Arial');
  ascent-override: 90%;
  descent-override: 22.43%;
  line-gap-override: 0%;
  size-adjust: 107.64%;
}

body {
  font-family: 'Inter', 'Inter Fallback', sans-serif;
}
```

---

## 8. Performance Testing Tools

| Tool | What It Tests | URL |
|---|---|---|
| Lighthouse | LCP, CLS, INP, accessibility, SEO | Built into Chrome DevTools |
| PageSpeed Insights | Lab + field data (CrUX) | https://pagespeed.web.dev |
| WebPageTest | Waterfall, filmstrip, real devices | https://webpagetest.org |
| Chrome DevTools | Device emulation, throttling, Performance tab | Built into Chrome |
| CrUX Dashboard | Real-user Core Web Vitals over time | https://developer.chrome.com/docs/crux |
| Search Console | Core Web Vitals report (per-URL group) | https://search.google.com/search-console |
| web-vitals (npm) | Measure CWV in production JS | https://github.com/GoogleChrome/web-vitals |

### Chrome DevTools Device Emulation

```
1. Open DevTools → Toggle Device Toolbar (Ctrl+Shift+M)
2. Select device preset or set custom dimensions
3. Test at 320px width (WCAG reflow)
4. Test at 200% zoom (SC 1.4.4)
5. Throttle network to Slow 3G / Fast 3G
6. Throttle CPU to 4× / 6× slowdown
7. Performance tab → record interaction for INP
```

### Measure Core Web Vitals in Production

```typescript
import { onLCP, onCLS, onINP } from 'web-vitals';

onLCP(metric => {
  console.log('LCP:', metric.value, 'ms');
  sendToAnalytics({ name: 'LCP', value: metric.value, id: metric.id });
});

onCLS(metric => {
  console.log('CLS:', metric.value);
  sendToAnalytics({ name: 'CLS', value: metric.value, id: metric.id });
});

onINP(metric => {
  console.log('INP:', metric.value, 'ms');
  sendToAnalytics({ name: 'INP', value: metric.value, id: metric.id });
});
```

### Real Device Testing

| Why Lab Data Isn't Enough | What Real Devices Catch |
|---|---|
| Simulated CPU ≠ real hardware | Thermal throttling on sustained use |
| Mouse emulation ≠ actual touch | Touch target usability, fat-finger errors |
| Chrome DevTools ≠ Safari rendering | iOS-specific layout issues, safe areas |
| No real network variability | Actual 3G/4G latency, packet loss |

**Minimum real device test matrix:**

| Device | OS | Browser | Screen |
|---|---|---|---|
| iPhone SE | iOS Safari | Safari | 375×667 |
| iPhone 14/15 | iOS Safari | Safari | 390×844 (notch) |
| Samsung Galaxy S series | Android | Chrome | 360×800 |
| iPad | iPadOS | Safari | 768×1024 |
| Low-end Android | Android | Chrome | 320×568 |
