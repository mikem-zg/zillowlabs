# Professional Brand Guidelines

Zillow's March 2025 Brand Guidelines for the **professional audience** (Real Estate Agents, Rental Partners, New Construction Partners). Builds on the core consumer guidelines while tailoring the visual and verbal identity to professional needs.

**Important:** The professional guidelines define separate rules for **Marketing** (frontline presentations, one-pagers, email campaigns, landing pages, events) and **Product** (app UI, dashboards, tools, in-product flows). Each reference file is split into Marketing and Product sections where rules differ.

## When to Activate

- Building professional-facing UI (Agent Hub, Premier Agent, Rentals Manager, New Construction)
- Writing copy for agent, rental, or builder partner experiences
- Designing dashboards, tools, CRM-style interfaces, or professional workflows
- Creating frontline materials (presentations, one-pagers)
- Selecting colors, typography, or imagery for professional touchpoints
- Building email templates for lifecycle or operational emails targeting partners

## Audience Identification

| Audience | Promise | Vibe | This Skill? |
|----------|---------|------|-------------|
| **Professional** | "Unlock success" | Unflappable, Efficient, Organized, Trustworthy | Yes |
| **Consumer** | "Get home" | Joyful, Vibrant, Emotional | No — see `consumer-brand-guidelines` |

## Brand Foundation

| Element | Value |
|---------|-------|
| **Purpose** | Make home a reality for more and more people |
| **Professional promise** | Unlock success |
| **Personality** | Courageous · Insightful · Unflappable |
| **Professional attributes** | Organized, Reliable, Stable, Dependable, Confident, Bold, Empowering, Knowledgeable, Precise, Intuitive |
| **Functional spectrum** | Most work leans functional (events are the expressive exception) |

## First Decision: Marketing or Product?

| Context | Examples | Key Differences |
|---------|----------|-----------------|
| **Marketing** | Frontline presentations, one-pagers, lifecycle emails, landing pages, events | Object Sans across all weights; restricted palette (no full secondary); no house motif |
| **Product** | App screens, dashboards, tools, in-product flows | `Blue600` interactive only; platform-native body typefaces; container/elevation rules; `size="sm"` for buttons/inputs/tables; max `heading-md` |

## Core Brand Rules

| Rule ID | Applies To | Category | Constraint | Exception |
|---------|-----------|----------|------------|-----------|
| CLR_P01 | Both | Color | Restricted palette: Marble, `Blue600`, `Gray950`, `Aqua300` (Pool), `Blue800` (Waterfront), Light Gray (`#F7F7F7`) | Full secondary palette allowed in illustrations and events only |
| CLR_P02 | Both | Color | PROHIBITED: Purple, Orange, Teal for UI elements | Illustrations may use full palette |
| CLR_P03 | Both | Color | White (`bg.screen.neutral`) as default background | Light Gray for section differentiation |
| CLR_P04 | Both | Color | No light/pastel colored backgrounds | None — leadership directive |
| CLR_P05 | Both | Color | No stacking colored sections back-to-back | None |
| CLR_P06 | Product | Color | `Blue600` = interactive/action ONLY | None |
| CLR_P07 | Product | Color | Feedback colors: green=success, yellow=warning, red=critical, light blue=selected | None |
| CLR_P08 | Product | Color | WCAG AA mandatory for all text; AAA preferred | None |
| CLR_P09 | Product | Color | Do not assign colors to lines of business (no purple for Rentals, no blue+gold for Agents) | None |
| CLR_P10 | Product | Color | Do not adjust colors within Constellation components | None |
| CLR_P11 | Product | Color | White background for content-heavy sections; avoid gray behind large content blocks | None |
| CLR_P12 | Product | Color | Use illustrations to bring vibrancy; keep UI minimalist | None |
| CLR_P13 | Marketing | Color | Approved color combinations only (see color reference) | Events may use full palette |
| CLR_P14 | Product | Color | Use `Tag` for status/category display with appropriate tone | None |
| LOGO_P01 | Product | Logo | Desktop navigation: 24px height | None |
| LOGO_P02 | Product | Logo | Mobile navigation: 16px height | None |
| LOGO_P03 | Both | Logo | Left-align preferred; center OK in symmetric layouts | None |
| LOGO_P04 | Both | Logo | Sub-brand logos: Premier Agent, Rentals, New Construction | None |
| LOGO_P05 | Both | Logo | Tag design when `Blue600` not present in layout | None |
| LOGO_P06 | Both | Logo | Minimum horizontal lockup size: 120px screen | None |
| TYPO_P01 | Product | Typography | Object Sans Heavy for headings ONLY; Inter (web), SF Pro (iOS), Roboto (Android) for body | Email: Helvetica body |
| TYPO_P02 | Marketing | Typography | Object Sans across all weights (Heavy, Bold, Medium, Regular) | None |
| TYPO_P03 | Both | Typography | Left-align body text; center OK for 1-2 line headlines | None |
| TYPO_P04 | Both | Typography | Line length 50-75 characters for body copy | None |
| TYPO_P05 | Both | Typography | ONE highlight color per headline; brighter than base text | None |
| TYPO_P06 | Both | Typography | Never make headlines blue (implies interactivity) | None |
| TYPO_P07 | Product | Typography | Three-color text system: `text.default`, `text.subtle`, `text.inverse` | Dark mode inverts |
| SHAPE_P01 | Marketing | Shape | NO house motif for professional audience | None — explicitly prohibited |
| SHAPE_P02 | Product | Shape | Default corner radius: 12px | Large/hero containers: 20px |
| SHAPE_P03 | Product | Shape | Do not override Constellation component corner radii | None |
| SURF_P01 | Product | Surfaces | Do not use gray cards with drop shadow (shadow muddles gray edge) | None |
| SURF_P02 | Product | Surfaces | Do not use colored cards with border (border muddles colored edge) | None |
| SURF_P03 | Product | Surfaces | Shadows on interactive elements only | None |
| SURF_P04 | Product | Surfaces | No nested shadows (shadow inside shadow) | None |
| SURF_P05 | Product | Surfaces | Dark mode: no shadows; lighter backgrounds for elevation | None |
| SURF_P06 | Product | Surfaces | Negative space for separation; use `<Divider />` sparingly | None |
| ICON_P01 | Product | Icons | Filled icons as default | Outline for pre-interaction states |
| ICON_P02 | Product | Icons | Sizes: sm=16px, md=24px (default), lg=32px, xl=44px | None |
| ICON_P03 | Product | Icons | Duotone icons: MAX 1-2 per viewport. ONLY for summary/overview callout cards, empty states, upsell banners, one-off awareness moments. NEVER in metric cards, data cards, status cards, agent cards, list items, or repeating card patterns. | Not for functional UI |
| ICON_P04 | Product | Icons | Duotone: use "Express - trust" color variant | None |
| ICON_P05 | Product | Icons | Interactive icons: `icon.action.hero.default` (`Blue600`) | `icon.neutral` (`Gray950`) when implied by container |
| ICON_P06 | Product | Icons | Content support icons: `icon.subtle` (`Gray600`) | None |
| ICON_P07 | Product | Icons | Max 4 xl duotone icons in proximity; max 5 lg icons | None |
| ICON_P08 | Product | Icons | Text labels alongside icons; few icons are universally recognized | None |
| ILLUS_P01 | Both | Illustration | Spot illustrations ONLY — no scene illustrations for professionals | None |
| ILLUS_P02 | Both | Illustration | Keep beige background element on spot illustrations | None |
| ILLUS_P03 | Both | Illustration | `Blue600` present in every illustration (10-50%) | None |
| ILLUS_P04 | Both | Illustration | Do not edit, embellish, or remove elements from illustrations | None |
| ILLUS_P05 | Product | Illustration | Do not place spot illustrations against dark gray backgrounds (poor contrast) | None |
| PHOTO_P01 | Both | Photography | Source all photography from OrangeLogic DAM | None |
| PHOTO_P02 | Both | Photography | No wholly AI-generated images | AI OK for geographic diversity, aspect ratio adjustment |
| PHOTO_P03 | Both | Photography | Agent-focused: candid professional moments, device/product shots | None |
| COMP_P01 | Product | Components | Default `size="sm"` for buttons, inputs, selects, and tables | `size="md"` for hero CTAs or primary page actions |
| COMP_P03 | Product | Components | Max heading size: `heading-md`; never use `heading-lg` | None |
| COMP_P02 | Product | Components | Use `PropertyCard` with `saveButton` and `elevated` for listings | None |
| PLAT_P01 | Both | Platform | Lifecycle emails = more expressive; operational emails = minimalist | None |
| PLAT_P02 | Product | Platform | Empty states: spot illustration + clear path forward, consistent across web and native | None |

## Decision Trees

### Choosing a Background Color (Professional)
```
Is this a hero section on a landing page or welcome screen?
├── Yes → White background with Blue600 CTA and vibrant photography
└── No → Is this a section needing visual differentiation?
    ├── Yes → Light Gray (#F7F7F7 / bg.screen.muted)
    └── No → White (#FFFFFF / bg.screen.neutral)

NEVER: colored backgrounds (no purple, orange, teal), pastel tints, light blue fills
Only color exception: ONE colored upsell card per page (Blue600/Blue800 tones)
```

### Choosing an Illustration Type (Professional)
```
Do I need a hero visual element?
├── Yes → Use photography (from DAM), NOT illustration
└── No → Is this a value prop, empty state, or upsell?
    ├── Yes → Spot illustration (160×160px)
    └── No → Could a 44px duotone icon suffice?
        ├── Yes → Use xl duotone icon ("Express - trust" variant)
        └── No → Spot illustration

NEVER: Scene illustrations for professional audience
```

### Choosing Icon Style (Professional)
```
Is this a functional UI element (nav, input, CTA)?
├── Yes → Filled icon (default)
└── No → Is this an upsell, empty state, or awareness moment?
    ├── Yes → Duotone icon ("Express - trust" variant)
    └── No → Is this a pre-interaction state?
        ├── Yes → Outline icon
        └── No → Filled icon (default)
```

### Logo Colorway Selection (Professional)
```
Is Zillow Blue (Blue600) present in the layout?
├── Yes → Primary logo or white logo OK
└── No → Tag design required
```

## Reference Files

Each reference file is split into **Marketing** and **Product** sections where rules differ.

| File | Contents |
|------|----------|
| `references/color-system.md` | Restricted palette with tokens, approved combinations, product color DOs/DON'Ts, data viz, dark mode |
| `references/typography.md` | Marketing hierarchy, product textStyle tokens, type scales, emphasis, alignment |
| `references/logo-usage.md` | Parent + sub-brand logos, clearspace, sizing, tag design, incorrect usage |
| `references/surfaces-depth.md` | Container types, elevation/shadows, dark mode containers, rounded corners |
| `references/illustration-iconography.md` | Spot illustrations only, duotone icons, icon sizes/styles/colors, photography |
| `references/platform-channels.md` | Functional-to-expressive spectrum, email/web/native platform rules |

## Cross-References

- **Consumer Brand Guidelines** → `.agents/skills/consumer-brand-guidelines/` for consumer-specific rules (full palette, house motifs, scene illustrations)
- **Constellation Design System** → `.agents/skills/constellation-design-system/` for component rules, spacing tokens, code patterns
- **Constellation Icons** → `.agents/skills/constellation-icons/` for icon catalog, name verification, import patterns
- **Constellation Illustrations** → `.agents/skills/constellation-illustrations/` for spot illustration catalog (93 illustrations with light/dark mode paths)
- **Constellation Dark Mode** → `.agents/skills/constellation-dark-mode/` for theme injection, `_dark`/`_light` conditions
- **OrangeLogic DAM** → `.agents/skills/orangelogic-dam/` for sourcing photography and logo assets. NEVER use AI generation or stock APIs.
- **UX Writing Guide** → `custom_instruction/ux-writing-guide.md` for product copy standards
- **Instructions** → `custom_instruction/instructions.md` for implementation rules and validation workflow
