# Color System

Source: Zillow April 2024 Brand Guidelines, slides 80-139.

## Primary Palette

Always-present colors throughout the Zillow brand experience.

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

## Color Family Meanings

| Family | Meaning | Use For | Personality |
|--------|---------|---------|-------------|
| **Blue** | Trust / Action | CTAs, links, interactive elements, brand moments | Confidence, Possibility, Optimism |
| **Teal** | Productive / Insight | Finance, home loans, agent connections, trust signals | Trust, Progress, Insight |
| **Purple** | Inspired / News | New features, inspiration, creativity, engagement | Joy, Leader-like, Vibrance |
| **Orange** | Empowered / Focus | "New" badges, "Open House", urgency, alerts | Authentic, Dependable, Unflappable |

## Feedback Colors (Product UI)

| Role | Color | Use |
|------|-------|-----|
| Interactive | Blue (Blue600) | Actionable UI elements, primary CTA |
| Selected | Light Blue | Selected element on page |
| Notify | Feedback Orange | Notification dots, urgency |
| Success | Green | Completion, success states |
| Warning | Yellow | Cautionary messages |
| Critical | Red | Errors, incomplete actions |

## Extended Color System (OkLCH)

The design system uses OkLCH (lightness, chroma, hue) with 9 values per scale (050-950).

**Accessibility shortcut:** Any color in the 700+ range on any color in the 200- range always passes AA contrast. This applies across all color families at the same level.

## Color Usage Rules

### Coverage Limit
- Max 25% bold color per viewport (what customer can see at one time)
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

### NEVER Rules

| DON'T | Why |
|-------|-----|
| Stack colored sections back-to-back | Looks "childish and amateur" (brand guidelines p.137) |
| Use light/pastel colored backgrounds | Feels "dingy" and "juvenile" (leadership directive, p.138) |
| Use navy or light blue for backgrounds | Violates background restrictions (p.139) |
| Fill >25% of viewport with bold color | Overwhelms content |
| Use color for decoration without purpose | Every color must serve a function |
| Mix color families on one page | Breaks visual consistency |
| Use blue for headlines | Blue = interactive only; blue headline looks like a link |
| Use Granite as a background color | Reserved for text |
| Use Granite + Marble as the only colors | Needs a supporting secondary color |

## Dark Mode

Invert the color scale: switch from blue100 to blue900 (opposite position on the 050-950 scale). Exceptions exist for drop shadows — elements overlaying the page background in dark mode should use a lighter color to maintain visual hierarchy.

## Accessibility

- All text colors must pass WCAG AA (AAA preferred but not required)
- Non-text elements (cards, inputs) need 3:1 contrast ratio
- Blue600 buttons pass AA on backgrounds up to gray400 level
- Test contrast at: https://www.aremycolorsaccessible.com/
