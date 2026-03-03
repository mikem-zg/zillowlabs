# Color System (Professional)

Source: Zillow March 2025 Professional Brand Guidelines, slides 22-49.

## Restricted Palette

The professional palette is deliberately minimalist to convey sophistication and reliability. Only these colors are approved for UI elements:

| Brand Name | Constellation Token | Hex | Role |
|------------|-------------------|-----|------|
| **Marble** | — (white) | `#FFFFFF` | Default background (`bg.screen.neutral`) |
| **Zillow Blue** | `Blue600` | `#0041D9` | Interactive/action, brand lead, logo |
| **Granite** | `Gray950` | `#111116` | Primary text color (`text.default`) |
| **Pool** | `Aqua300` | `#73E4F9` | Highlight color, sparingly |
| **Waterfront** | `Blue800` | `#001962` | Dark blue, supporting backgrounds |
| **Light Gray** | — | `#F7F7F7` | Section differentiation (`bg.screen.muted`) |

### PROHIBITED Colors for Professional UI

| Color | Consumer Token | Why Prohibited |
|-------|---------------|----------------|
| Purple (any shade) | `Purple300`-`Purple800` | Reserved for consumer audience |
| Orange (any shade) | `Orange300`-`Orange700` | Reserved for consumer audience |
| Teal (any shade) | `Teal600`, `Teal800` | Reserved for consumer audience |

**Exception:** The full secondary palette (including purple, orange, teal) is allowed ONLY in illustrations and professional events. It must never appear in UI elements, backgrounds, or text.

---

## Marketing Color Rules

### Approved Color Combinations (Digital)

All text colors must meet AA accessibility standards (AAA preferred).

| Main Copy | Highlight | Background |
|-----------|-----------|------------|
| Marble (white) | `Aqua300` (Pool) | Dark background |
| Marble (white) | `Aqua300` + `Blue600` | Dark background |
| `Gray950` (Granite) | `Blue600` | Light background |
| `Gray950` (Granite) | `Blue600` + Marble | Light background |
| `Gray950` (Granite) | `Blue800` (Waterfront) | Light background |
| `Gray950` (Granite) | `Blue800` + `Aqua300` | Light background |

### Supporting Visual Elements (Marketing)

Color comes through supporting elements, NOT through UI paint:

| Element | How Color Enters | Palette |
|---------|-----------------|---------|
| Photography | Stories, personalities, relatable connection | Natural/candid |
| Product photography | Educational, key features | App UI screenshots |
| Iconography | Visual cues, navigation | Professional palette only |
| Illustrations | Supporting metaphors, focus | Full palette allowed |

### Functional-to-Expressive Spectrum

| More Functional ← | → More Expressive |
|---|---|
| Frontline presentations | Landing pages |
| One-pagers | Events (full palette OK) |
| Lifecycle emails | — |

Most professional work leans functional. Events are the exception.

### Landing Page Color Usage (Marketing)

| Section | Color Approach |
|---------|---------------|
| Hero | White background; `Blue600` CTAs and vibrant photography stand out |
| Benefits | Photography or photo illustrations; avoid colored backgrounds |
| RTBs (Reason to Believe) | Illustrations on white cards; colored background behind card group OK |
| Upsell / social proof | Background color OK for visual balance |
| Dense content | Small color accents through iconography |

---

## Product Color Rules

### Blue in Product = Interactive Only

| `Blue600` Usage | NOT Allowed |
|----------------|-------------|
| Primary CTA buttons (`tone="brand"`) | Blue headlines |
| Links (`text.action.hero.default`) | Blue backgrounds (except hero images) |
| Interactive icons (`icon.action.hero.default`) | Blue decorative accents |
| Selected states | Blue section fills |

### Feedback Colors (Product)

| Role | Color | UI Example |
|------|-------|------------|
| **Interactive** | `Blue600` | CTA buttons |
| **Selected** | Light Blue | Selected date card |
| **Notify** | Feedback Orange | Notification dot |
| **Success** | Green | Success checkmark |
| **Warning** | Yellow | Warning badge |
| **Critical** | Red | Error icon |

### Product Color DOs and DON'Ts

| DO | DON'T |
|----|-------|
| Apply `Blue600` to create depth and focus attention on important content | Assign colors to lines of business (no purple for Rentals, no blue+gold for Agents) |
| Apply brand blue so user can determine next best action | Adjust colors within Constellation components |
| Use illustrations in empty states and error states for vibrancy | Place spot illustrations against dark gray backgrounds (poor contrast) |
| Use duotone icons ("Express - trust" variant) to draw attention | Use other color variants of duotone icons |
| White background for content-heavy sections | Gray background behind large content blocks (insufficient text contrast) |
| Use `Tag` components for status, categories, properties | Use custom colored boxes for labels |

### Data Visualization Colors (Product)

| DO | DON'T |
|----|-------|
| Apply appropriate palette (qualitative, sequential, diverging) based on data type | Use colors too similar to each other when comparing metrics |
| Use contrasting colors for differentiating data | — |

### Accessibility (Product)
- WCAG AA mandatory for all text (AAA preferred)
- 3:1 contrast ratio for non-text elements
- Test at: https://www.aremycolorsaccessible.com/

### Dark Mode

Invert the color scale: switch from scale-100 to scale-900. Exceptions for drop shadows — elements overlaying page background in dark mode use lighter color for visual hierarchy. See **constellation-dark-mode** skill.

## Cross-References

- **Consumer palette** (full secondary colors) → `.agents/skills/consumer-brand-guidelines/references/color-system.md`
- **Constellation tokens** → `.agents/skills/constellation-design-system/references/guides/quick-reference.md`
- **Dark mode** → `.agents/skills/constellation-dark-mode/SKILL.md`
