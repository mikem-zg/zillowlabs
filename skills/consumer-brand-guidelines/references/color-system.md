# Color System

Source: Zillow April 2024 Brand Guidelines, slides 80-139.

## Primary Palette

Always-present colors throughout the Zillow brand experience (both marketing and product).

| Name | Hex | RGB | PMS | Role |
|------|-----|-----|-----|------|
| **Zillow Blue** | `#0041D9` | 0, 65, 217 | 2728C | Interactive/action, brand lead, logo |
| **Granite** | `#111116` | 17, 17, 22 | Black 6 C | Primary text color, bold confidence |
| **Marble** | `#FFFFFF` | 255, 255, 255 | — | Leading background color |

## Secondary Palette

Expressive layer built on the primary palette. Divided into three tiers.

### Secondary Colors (standalone, prominent use)

| Name | Hex | RGB | PMS | Family |
|------|-----|-----|-----|--------|
| **Garden** | `#136F65` | 19, 111, 101 | 562C | Teal |
| **Playroom** | `#933DFB` | 147, 61, 251 | 266C | Purple |
| **Fireplace** | `#D03C0B` | 208, 60, 11 | 173C | Orange |

### Shadow Colors (backgrounds, paired with family)

| Name | Hex | RGB | PMS | Family |
|------|-----|-----|-----|--------|
| **Waterfront** | `#001962` | 0, 25, 98 | 280C | Blue |
| **Acreage** | `#053630` | 5, 54, 48 | 3308C | Teal |
| **Wine Cellar** | `#3B0470` | 59, 4, 112 | 2685C | Purple |
| **Brick** | `#7D2103` | 125, 33, 3 | 1815C | Orange |

### Highlight Colors (accents, sparingly)

| Name | Hex | RGB | PMS | Family |
|------|-----|-----|-----|--------|
| **Pool** | `#73E4F9` | 115, 228, 249 | 310C | Blue |
| **Houseplant** | `#9FF17B` | 159, 241, 123 | 7487C | Teal |
| **Dollhouse** | `#E6A8FF` | 230, 168, 255 | 2562C | Purple |
| **Terracotta** | `#FFA385` | 255, 163, 133 | 2022C | Orange |

## Design System Name Mapping

Brand "nail polish" names mapped to Constellation design system tokens.

| Brand Name | DS Token Name |
|------------|---------------|
| Pool | Aqua300 |
| Zillow Blue | Blue600 |
| Waterfront | Blue800 |
| Houseplant | Green300 |
| Garden | Teal600 |
| Terracotta | Orange300 |
| Fireplace | Orange600 |
| Brick | Orange700 |
| Dollhouse | Purple300 |
| Playroom | Purple500 |
| Wine Cellar | Purple800 |

## Color Family Meanings (Both Marketing and Product)

| Family | Meaning | Use For | Personality |
|--------|---------|---------|-------------|
| **Blue** | Trust / Action | CTAs, links, interactive elements, brand moments | Confidence, Possibility, Optimism |
| **Teal** | Productive / Insight | Finance, home loans, agent connections, trust signals | Trust, Progress, Insight |
| **Purple** | Inspired / News | New features, inspiration, creativity, engagement | Joy, Leader-like, Vibrance |
| **Orange** | Empowered / Focus | "New" badges, "Open House", urgency, alerts | Authentic, Dependable, Unflappable |

---

## Marketing Color Rules

Marketing contexts: ads, email campaigns, social posts, OOH, landing pages, print.

### How Blue Works in Marketing
Zillow Blue is versatile in marketing — it can appear in CTAs, backgrounds, headlines, and illustrations. It anchors the logo and inspires brand recognition.

| Use Case | Allowed Colors |
|----------|---------------|
| Hero backgrounds | Zillow Blue, Waterfront, secondary family colors |
| Headlines | Granite text with ONE highlight color from a family |
| CTAs | Zillow Blue (primary) |
| House motif fills | Any secondary color; match text/motif combos to approved pairings |

### Zillow Blue vs Waterfront in Marketing

| Zillow Blue | Waterfront (Navy) |
|-------------|-------------------|
| Primary color; suggests interaction and expression | Supporting color; more grounded |
| Use for energetic, activating copy | Use for direct, to-the-point copy |
| OK as email/ad background when brand equity needed | Do NOT use without Zillow Blue present in non-owned spaces |
| Do NOT use as background if it distracts from CTA | Do NOT use when messaging should excite and energize |

### Highlight Colors as Backgrounds (Marketing Only)
Light "highlight" colors (Pool, Houseplant, Dollhouse, Terracotta) may be used as backgrounds ONLY for:
- Social media posts
- Layouts with a solid-filled house motif on top

They are NOT general-purpose background colors.

### Color Combos Per Family (Marketing)
Each color family has approved combinations for house motif, logo tag, and headline highlights. Do not mix families — e.g., teal house motif with purple highlight text.

### Contextual Color Spectrum (Marketing)

| More Functional ← | → More Expressive |
|---|---|
| App experience | Brand social |
| Email | Paid social |
| Landing page | Out-of-home |

More expressive contexts allow bolder color use. App/email should be more restrained.

---

## Product Color Rules

Product contexts: app UI, website screens, in-product flows, dashboards, settings.

### Blue in Product = Interactive Only
This is the critical difference from marketing. In product, blue is reserved EXCLUSIVELY for interactive elements. Blue suggests the element can be clicked or tapped.

| Blue600 Usage in Product | NOT Allowed |
|--------------------------|-------------|
| Primary CTA buttons | Blue headlines (looks like a link) |
| Links | Blue backgrounds (except hero images) |
| Interactive icons | Blue decorative accents |
| Selected states | Blue section fills |

### Feedback Colors (Product Only)

| Role | Color | UI Example |
|------|-------|------------|
| **Interactive** | Blue (Zillow Blue) | CTA buttons |
| **Selected** | Light Blue | Selected date card, selected state |
| **Notify** | Feedback Orange | Notification dot |
| **Success** | Green | Success checkmark |
| **Warning** | Yellow | Warning badge |
| **Critical** | Red | Error icon |

### Accessibility (Product — Stricter Than Marketing)
- WCAG AA mandatory for all text (AAA preferred but not required)
- 3:1 contrast ratio required for non-text elements (cards, inputs)
- Blue600 buttons pass AA on backgrounds up to gray400 level
- Any color in the 700+ range on any color in the 200- range passes AA
- Test contrast at: https://www.aremycolorsaccessible.com/

### Extended Color System (Product)
The design system uses OkLCH (lightness, chroma, hue) with 9 values per scale (050-950). Each step has predictable lightness: 100-family ≈ 95% lightness, 200-family ≈ 90%, etc.

### Product Icon Colors

| Context | Color | When |
|---------|-------|------|
| Most interactive icons | Blue600 | Default for clickable icons |
| Functional icons in containers | Gray950 | Icons in inputs, tabs, nav (interaction implied by placement) |
| Content support | Gray600 | Paired with content for visual separation |
| Storytelling emphasis | Teal600 | Features, landing pages, upsell banners — use sparingly |
| Vibrant non-interactive (upsells) | Orange500, Purple500, etc. | Sparingly, for prominent moments only |

---

## Shared Color Usage Rules (Both Marketing and Product)

### Coverage Limit
- Max 25% bold color per viewport
- Exception: hero images on homepages/landing pages may exceed 25%
- If multiple color modules on one page, keep within the same color family

### Color Importance Hierarchy

| Level | Surface Area | Example |
|-------|-------------|---------|
| **High** | Large area | Hero section (homepage/landing page only) |
| **Medium** | One colored card | Teal upsell banner, purple feature callout (one per page max) |
| **Low** | Subtle accent | Orange "New" badge, teal trust icon, illustration |

### Color Family Consistency
Once you pick a color family for a page, carry it through. If the hero is teal, all colored elements below (badges, accents, CTAs) must also be teal. Do not introduce orange or purple further down.

### NEVER Rules (Both Contexts)

| DON'T | Why |
|-------|-----|
| Stack colored sections back-to-back | Looks "childish and amateur" (brand guidelines p.137) |
| Use light/pastel colored backgrounds | Feels "dingy" and "juvenile" (leadership directive, p.138) |
| Use navy or light blue for section backgrounds | Violates background restrictions (p.139) |
| Fill >25% of viewport with bold color | Overwhelms content |
| Use color for decoration without purpose | Every color must serve a function |
| Mix color families on one page | Breaks visual consistency |
| Use Granite as a background color | Reserved for text |
| Use Granite + Marble as the only colors | Needs a supporting secondary color |

## Dark Mode

Invert the color scale: switch from blue100 to blue900 (opposite position on the 050-950 scale). Exceptions exist for drop shadows — elements overlaying the page background in dark mode should use a lighter color to maintain visual hierarchy.
