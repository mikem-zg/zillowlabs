# Token Reference

Load this file when styling components. For critical rules (must-read every session), see [design-system-rules.md](design-system-rules.md). For component patterns, see [component-patterns.md](component-patterns.md).

---

## Token Resolution Rules

Some design tokens resolve through PandaCSS's `css` prop; others require the `style` prop with raw CSS variables. Using the wrong method causes silent failures.

| Token category | Works in `css` prop? | How to use |
|---|---|---|
| `bg.screen.*` | YES | `css={{ bg: "bg.screen.neutral" }}` |
| `bg.softest`, `bg.softer` | YES | `css={{ bg: "bg.softest" }}` |
| `text.subtle`, `text.muted` | YES | `css={{ color: "text.subtle" }}` |
| `border.muted` | YES | `css={{ borderColor: "border.muted" }}` |
| Spacing (`200`, `400`, etc.) | YES | `css={{ p: "400" }}` |
| `bg.surface.brand.*` | NO | `style={{ backgroundColor: "var(--color-bg-surface-brand-teal-soft)" }}` |
| `icon.brand.*` | NO | `style={{ color: "var(--color-icon-accent-teal-strong)" }}` |
| `text.on-hero.*` | NO | `style={{ color: "var(--color-text-on-hero-neutral)" }}` |
| Any accent/expressive color | NO | Use `--color-*` CSS variables in `style` prop |

> **CSS variable prefix:** Constellation CSS variables use `--color-` (singular), NOT `--colors-` (plural). Example: `var(--color-text-on-hero-neutral)`. Using `--colors-` silently fails.

---

## Text & Icon Color

The `color` prop on `Icon` and `Text` does NOT resolve semantic token paths. Use `css` prop:

```tsx
// WRONG
<Icon size="md" color="icon.neutral"><IconHeartFilled /></Icon>
<Text color="text.subtle">Label</Text>

// CORRECT — css prop
<Icon size="md" css={{ color: 'icon.neutral' }}><IconHeartFilled /></Icon>
<Text css={{ color: 'text.subtle' }}>Label</Text>

// FALLBACK — style prop with CSS variables
<Icon size="md" style={{ color: 'var(--color-icon-subtle)' }}><IconHeartFilled /></Icon>
<Text style={{ color: 'var(--color-text-subtle)' }}>Label</Text>
```

---

## Token Syntax

```tsx
// In css() or JSX props: token value only (NO prefix)
<Box bg="bg.default" p="400" borderRadius="node.md" />

// In token() function: full path WITH prefix
token('spacing.400')
```

---

## Expressive Color CSS Variables

PandaCSS does NOT resolve brand surface tokens. Use the `style` prop:

| Family | Soft | Hero | Impact |
|--------|------|------|--------|
| **Teal** | `var(--color-bg-surface-brand-teal-soft)` | `var(--color-bg-surface-brand-teal-hero)` | `var(--color-bg-surface-brand-teal-impact)` |
| **Purple** | `var(--color-bg-surface-brand-purple-soft)` | `var(--color-bg-surface-brand-purple-hero)` | `var(--color-bg-surface-brand-purple-impact)` |
| **Orange** | `var(--color-bg-surface-brand-orange-soft)` | `var(--color-bg-surface-brand-orange-hero)` | `var(--color-bg-surface-brand-orange-impact)` |

Matching icon/text variables for on-hero content:

| Token type | CSS variable |
|------------|-------------|
| Text (neutral) | `var(--color-text-on-hero-neutral)` |
| Text (subtle) | `var(--color-text-on-hero-subtle)` |
| Icon (neutral) | `var(--color-icon-on-hero-neutral)` |
| Icon (subtle) | `var(--color-icon-on-hero-subtle)` |

---

## Hero Background Tokens

Each color family provides three intensity levels. Use in `style` prop:

| Color Family | Soft | Hero | Impact |
|-------------|------|------|--------|
| **Teal** | `bg.accent.teal.soft` | `bg.accent.teal.hero` | `bg.accent.teal.impact` |
| **Orange** | `bg.accent.orange.soft` | `bg.accent.orange.hero` | `bg.accent.orange.impact` |
| **Purple** | `bg.accent.purple.soft` | `bg.accent.purple.hero` | `bg.accent.purple.impact` |
| **Blue** | `bg.accent.blue.soft` | `bg.accent.blue.hero` | `bg.accent.blue.impact` |
| **Green** | `bg.accent.green.soft` | `bg.accent.green.hero` | `bg.accent.green.impact` |
| **Red** | `bg.accent.red.soft` | `bg.accent.red.hero` | `bg.accent.red.impact` |
| **Yellow** | `bg.accent.yellow.soft` | `bg.accent.yellow.hero` | `bg.accent.yellow.impact` |
| **Aqua** | `bg.accent.aqua.soft` | `bg.accent.aqua.hero` | `bg.accent.aqua.impact` |
| **Gray** | `bg.accent.gray.soft` | `bg.accent.gray.hero` | `bg.accent.gray.impact` |
| **Brand** | `bg.accent.brand.soft` | `bg.accent.brand.hero` | `bg.accent.brand.impact` |

| Level | When to use |
|-------|-------------|
| **Soft** | Subtle tinted backgrounds for cards, banners, upsells |
| **Hero** | Primary hero section backgrounds |
| **Impact** | High-contrast hero backgrounds for maximum visual impact |

---

## On-Hero Text Tokens

**`text.on-hero.*` tokens are NOT recognized by PandaCSS's `css` prop.** Use `style` with CSS variables:

```tsx
// WRONG
<Text css={{ color: "text.onHero.neutral" }}>Hero text</Text>

// CORRECT
<Text style={{ color: "var(--color-text-on-hero-neutral)" }}>Hero text</Text>
```

| Token (PandaCSS path) | CSS Variable | Purpose |
|-------|-------------|---------|
| `text.onHero.neutral` | `var(--color-text-on-hero-neutral)` | Body text on hero backgrounds |
| `text.onHero.neutral-fixed` | `var(--color-text-on-hero-neutral-fixed)` | Body text that stays fixed across themes |
| `text.onHero.action.neutral.default` | `var(--color-text-on-hero-action-neutral-default)` | Interactive text on hero (default) |
| `text.onHero.action.neutral.hover` | `var(--color-text-on-hero-action-neutral-hover)` | Interactive text on hero (hover) |
| `text.onHero.link.default` | `var(--color-text-on-hero-link-default)` | Link on hero (default) |
| `text.onHero.link.hover` | `var(--color-text-on-hero-link-hover)` | Link on hero (hover) |
| `text.onHero.express.trust.hero` | `var(--color-text-on-hero-express-trust-hero)` | Trust accent (Teal family) |
| `text.onHero.express.inspire.hero` | `var(--color-text-on-hero-express-inspire-hero)` | Inspiration accent (Purple family) |
| `text.onHero.express.empower.hero` | `var(--color-text-on-hero-express-empower-hero)` | Empowerment accent (Orange family) |
| `text.onHero.express.insight.hero` | `var(--color-text-on-hero-express-insight-hero)` | Insight accent (Blue family) |

---

## Color Tokens (Semantic Usage)

| Token | Purpose | Use For |
|-------|---------|---------|
| `Blue600` | Interactive/Action | Buttons, links, primary actions ONLY |
| `Teal600` | Trust/Finance | Home loans, agent connections |
| `Orange600` | Urgency/Focus | "New", "Open House", alerts |
| `Purple500` | Creativity/News | "New Features", inspiration |
| `Gray`, `White` | Backgrounds | All background colors |

---

## Color in Product

Color should be used with restraint. Default surface is always neutral (white or light gray).

| Level | Surface area | Usage | Example |
|-------|-------------|-------|---------|
| **High** | Large area | Hero sections ONLY | Full-width hero with teal background |
| **Medium** | Colored card | One colored card/section per page max | Teal upsell banner |
| **Low** | Subtle accent | Badges, icons, illustrations, tags | Orange "New" badge |

### DON'T Rules

| DON'T | WHY |
|-------|-----|
| Stack colored sections back-to-back | Looks "childish and amateur" |
| Use light/pastel colored backgrounds | Feels "dingy" and "juvenile" |
| Fill more than 25% of viewport with bold color | Overwhelms the content |
| Use color for decoration without purpose | Every color must serve a function |

---

## Hero Sections

**Heroes are ONLY for homepages, marketing landing pages, and welcome/onboarding screens.** Most pages do NOT need a hero.

| Page type | Hero? |
|-----------|-------|
| Homepage / main entry | Yes |
| Marketing landing page | Yes |
| Welcome / onboarding | Yes |
| Dashboard / tool / settings | No |
| Search results / listings | No |
| Forms / multi-step flows | No |

| ALWAYS | NEVER |
|--------|-------|
| 20px rounded corners for hero containers | 12px corners for heroes |
| Pick ONE color family for hero | Mix multiple color families |
| Use SAME color family for elements below hero | Switch color family down page |
| ONE accent color for text emphasis | Multiple highlight colors |

---

## Shape & Elevation

Do not override component default corner radii.

| Element | Corner Radius |
|---------|---------------|
| Cards, Buttons | 12px (default) |
| Hero/Large containers | 20px |

| Context | Shadow |
|---------|--------|
| Property Cards (high interactivity) | Large shadow |
| Chips, small interactive elements | Small shadow |
| Dark Mode | NO shadows - use lighter backgrounds |

---

## Logo Sizing

| Context | Size |
|---------|------|
| Desktop | 24px height ONLY |
| Mobile | 16px height ONLY |

Use `style` prop (not `css` prop) for pixel values on logos.

---

## Illustrations

| Theme | Path |
|-------|------|
| Light Mode | `client/src/assets/illustrations/Lightmode/{name}.svg` |
| Dark Mode | `client/src/assets/illustrations/Darkmode/{name}.svg` |

```tsx
import SearchHomesLight from '@/assets/illustrations/Lightmode/search-homes.svg';
import SearchHomesDark from '@/assets/illustrations/Darkmode/search-homes.svg';
<img src={isDarkMode ? SearchHomesDark : SearchHomesLight} alt="Search homes" />
```

| Type | Size | Use For |
|------|------|---------|
| Standard Spot | 160x160px | Empty states, value prop lists, upsell banners |
| Compact Spot | 120x120px | Tighter layouts, inline with content |
