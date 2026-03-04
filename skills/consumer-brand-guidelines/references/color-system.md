# Color System

Source: Zillow April 2024 Brand Guidelines, slides 80-139.

## Primary Palette

| Brand Name | Constellation Token | Hex | Role |
|------------|-------------------|-----|------|
| **Zillow Blue** | `Blue600` | `#0041D9` | Interactive/action, brand lead, logo |
| **Granite** | `Gray950` | `#111116` | Primary text color |
| **Marble** | — (white) | `#FFFFFF` | Leading background (`bg.screen.neutral`) |

## Secondary Palette

### Secondary Colors (standalone, prominent use)

| Brand Name | Constellation Token | Hex | Family |
|------------|-------------------|-----|--------|
| **Garden** | `Teal600` | `#136F65` | Teal |
| **Playroom** | `Purple500` | `#933DFB` | Purple |
| **Fireplace** | `Orange600` | `#D03C0B` | Orange |

### Shadow Colors (backgrounds, paired with family)

| Brand Name | Constellation Token | Hex | Family |
|------------|-------------------|-----|--------|
| **Waterfront** | `Blue800` | `#001962` | Blue |
| **Acreage** | `Teal800` | `#053630` | Teal |
| **Wine Cellar** | `Purple800` | `#3B0470` | Purple |
| **Brick** | `Orange700` | `#7D2103` | Orange |

### Highlight Colors (accents, sparingly)

| Brand Name | Constellation Token | Hex | Family |
|------------|-------------------|-----|--------|
| **Pool** | `Aqua300` | `#73E4F9` | Blue |
| **Houseplant** | `Green300` | `#9FF17B` | Teal |
| **Dollhouse** | `Purple300` | `#E6A8FF` | Purple |
| **Terracotta** | `Orange300` | `#FFA385` | Orange |

## Semantic Color Tokens (Product)

Use these semantic tokens in code instead of raw hex or scale tokens. These resolve through the theme.

### Backgrounds

| Semantic Token | Usage | CSS Prop Example |
|----------------|-------|-----------------|
| `bg.screen.neutral` | Default page background (white) | `css={{ bg: "bg.screen.neutral" }}` |
| `bg.default` | Default surface | `css={{ bg: "bg.default" }}` |
| `bg.screen.softest` | Light gray section differentiation | `css={{ bg: "bg.screen.softest" }}` |

> ⚠️ `bg.screen.muted` does NOT exist in PandaCSS. Always use `bg.screen.softest` for light gray backgrounds.

### Text Colors

| Semantic Token | Usage | CSS Prop Example |
|----------------|-------|-----------------|
| `text.default` | Primary text (Granite) | default, no override needed |
| `text.subtle` | Secondary/supporting text | `css={{ color: "text.subtle" }}` |
| `text.muted` | Tertiary text, less emphasis | `css={{ color: "text.muted" }}` |
| `text.inverse` | Text on dark backgrounds | `css={{ color: "text.inverse" }}` |
| `text.action.hero.default` | Link/CTA text (Blue600) | `css={{ color: "text.action.hero.default" }}` |

### Icon Colors

| Semantic Token | Usage | CSS Prop Example |
|----------------|-------|-----------------|
| `icon.neutral` | Default icon color | `css={{ color: "icon.neutral" }}` |
| `icon.subtle` | Gray600, content support | `css={{ color: "icon.subtle" }}` |
| `icon.muted` | Gray500, least emphasis | `css={{ color: "icon.muted" }}` |
| `icon.action.hero.default` | Blue600, interactive icons | `css={{ color: "icon.action.hero.default" }}` |

### Hero Text (PandaCSS Gotcha)

`text.onHero.*` tokens are NOT resolved by PandaCSS `css` prop. Use `style` prop with CSS variables:

```tsx
<Text style={{ color: "var(--colors-text-on-hero-neutral)" }}>Hero text</Text>
```

## Color Family Meanings (Both Marketing and Product)

| Family | Meaning | Constellation Tokens | Use For |
|--------|---------|---------------------|---------|
| **Blue** | Trust / Action | `Blue600` (primary), `Blue800` (shadow), `Aqua300` (highlight) | CTAs, links, interactive elements |
| **Teal** | Productive / Insight | `Teal600` (primary), `Teal800` (shadow), `Green300` (highlight) | Finance, home loans, trust signals |
| **Purple** | Inspired / News | `Purple500` (primary), `Purple800` (shadow), `Purple300` (highlight) | New features, inspiration |
| **Orange** | Empowered / Focus | `Orange600` (primary), `Orange700` (shadow), `Orange300` (highlight) | "New" badges, urgency, alerts |

---

## Marketing Color Rules

Marketing contexts: ads, email campaigns, social posts, OOH, landing pages, print.

### How Blue Works in Marketing
Zillow Blue (`Blue600`) is versatile in marketing — it can appear in CTAs, backgrounds, headlines, and illustrations. It anchors the logo and inspires brand recognition.

### Zillow Blue vs Waterfront in Marketing

| `Blue600` (Zillow Blue) | `Blue800` (Waterfront / Navy) |
|--------------------------|-------------------------------|
| Primary; suggests interaction and expression | Supporting; more grounded |
| Use for energetic, activating copy | Use for direct, to-the-point copy |
| OK as email/ad background when brand equity needed | Do NOT use without `Blue600` present in non-owned spaces |

### Highlight Colors as Backgrounds (Marketing Only)
Highlight tokens (`Aqua300`, `Green300`, `Purple300`, `Orange300`) may be used as backgrounds ONLY for:
- Social media posts
- Layouts with a solid-filled house motif on top

They are NOT general-purpose background colors.

### Contextual Color Spectrum (Marketing)

| More Functional ← | → More Expressive |
|---|---|
| App experience | Brand social |
| Email | Paid social |
| Landing page | Out-of-home |

---

## Product Color Rules

Product contexts: app UI, website screens, in-product flows.

### Blue in Product = Interactive Only
In product, `Blue600` is reserved EXCLUSIVELY for interactive elements. Blue suggests the element can be clicked or tapped.

| `Blue600` Usage in Product | NOT Allowed |
|---------------------------|-------------|
| Primary CTA buttons (`tone="brand"`) | Blue headlines (looks like a link) |
| Links (`text.action.hero.default`) | Blue backgrounds (except hero images) |
| Interactive icons (`icon.action.hero.default`) | Blue decorative accents |
| Selected states | Blue section fills |

### Feedback Colors (Product Only)

| Role | Token / Color | UI Example |
|------|--------------|------------|
| **Interactive** | `Blue600` / `text.action.hero.default` | CTA buttons |
| **Selected** | Light Blue | Selected date card |
| **Success** | Green | Success checkmark |
| **Warning** | Yellow | Warning badge |
| **Critical** | Red / `text.action.critical.hero.default` | Error icon |

### Accessibility (Product — Stricter Than Marketing)
- WCAG AA mandatory for all text (AAA preferred but not required)
- 3:1 contrast ratio required for non-text elements (cards, inputs)
- `Blue600` buttons pass AA on backgrounds up to `Gray400` level
- Any 700+ scale token on any 200- scale token passes AA

### Product Icon Colors

| Context | Semantic Token | Scale Token | When |
|---------|---------------|-------------|------|
| Interactive icons | `icon.action.hero.default` | `Blue600` | Clickable icons |
| Functional icons | `icon.neutral` | `Gray950` | Icons in inputs, tabs, nav |
| Content support | `icon.subtle` | `Gray600` | Paired with content |
| Storytelling emphasis | — | `Teal600` | Features, upsell banners |

---

## Shared Color Usage Rules (Both Marketing and Product)

### Coverage Limit
- Max 25% bold color per viewport
- Exception: hero images on homepages/landing pages may exceed 25%

### Color Importance Hierarchy

| Level | Surface Area | Example |
|-------|-------------|---------|
| **High** | Large area | Hero section (homepage/landing page only) |
| **Medium** | One colored card | `Teal600` upsell banner, `Purple500` feature callout (one per page max) |
| **Low** | Subtle accent | `Orange600` "New" badge, `Teal600` trust icon, illustration |

### Color Family Consistency
Once you pick a color family, carry it through the entire page. If the hero uses Teal (`Teal600`), all colored elements below must also use Teal tokens.

### NEVER Rules (Both Contexts)

| DON'T | Why |
|-------|-----|
| Stack colored sections back-to-back | Looks "childish and amateur" |
| Use light/pastel colored backgrounds | Feels "dingy" and "juvenile" — leadership directive |
| Use `Blue800` (navy) or light blue for section backgrounds | Violates background restrictions |
| Fill >25% of viewport with bold color | Overwhelms content |
| Use color for decoration without purpose | Every color must serve a function |
| Mix color families on one page | Breaks visual consistency |
| Use `Gray950` as a background color | Reserved for text |

## Dark Mode

Invert the color scale: switch from scale-100 to scale-900 (opposite position on the 050-950 scale). See **constellation-dark-mode** skill for implementation patterns (`_dark`/`_light` conditions, `getTheme`/`injectTheme`).

## Cross-References

- **Constellation tokens** → `.agents/skills/constellation-design-system/references/guides/quick-reference.md` for spacing, typography, and icon token tables
- **Dark mode** → `.agents/skills/constellation-dark-mode/SKILL.md` for theme injection and conditional styles
