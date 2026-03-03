# Consumer Brand Guidelines

Zillow's April 2024 Brand Guidelines for the **consumer audience** (homebuyers, renters, sellers). Covers visual identity, verbal identity, color, typography, logo, shape, illustration, iconography, and photography.

## When to Activate

- Building consumer-facing UI (homebuyer, renter, seller experiences)
- Writing consumer-facing copy or marketing content
- Choosing colors, typography, or imagery for consumer touchpoints
- Designing hero sections, landing pages, email templates
- Applying the Zillow house motif (Frame, Window, Solid House)
- Selecting photography or illustration for consumer pages
- Co-branding with external partners

## Audience Identification

| Audience | Promise | Vibe | This Skill? |
|----------|---------|------|-------------|
| **Consumer** | "Get home" | Joyful, Vibrant, Emotional | Yes |
| **Professional** | "Unlock success" | Unflappable, Efficient, Organized | No — see professional guidelines |

## Brand Foundation

| Element | Value |
|---------|-------|
| **Purpose** | Make home a reality for more and more people |
| **Consumer promise** | Get home |
| **Personality** | Courageous · Insightful · Unflappable |
| **Archetype** | The Advocate |
| **Pillars** | Possibility → Understanding → Progress |

## Core Brand Rules

| Rule ID | Category | Constraint | Exception |
|---------|----------|------------|-----------|
| CLR_001 | Color | Max 25% bold color per viewport | Hero sections on homepages/landing pages |
| CLR_002 | Color | No light/pastel colored backgrounds | None — leadership directive |
| CLR_003 | Color | No navy or light blue backgrounds | None |
| CLR_004 | Color | No stacking colored sections back-to-back | None |
| CLR_005 | Color | Pick ONE color family per page; carry it through | None |
| CLR_006 | Color | Blue = interactive/action ONLY; never decorative | Hero backgrounds in non-owned spaces |
| CLR_007 | Color | Teal or purple for colored card/section backgrounds | None |
| CLR_008 | Color | Use illustrations to bring color instead of painted surfaces | None |
| LOGO_001 | Logo | Desktop: 24px height | None |
| LOGO_002 | Logo | Mobile: 16px height | None |
| LOGO_003 | Logo | Email: 24px height | None |
| LOGO_004 | Logo | Minimum logomark size: 58px | None |
| LOGO_005 | Logo | Left-align logo whenever possible | Center OK with house motif frame |
| LOGO_006 | Logo | Owned space: secondary white logo OK without blue | None |
| LOGO_007 | Logo | Non-owned space without blue: must use tag design | None |
| TYPO_001 | Typography | Object Sans for headings; Inter (web), SF Pro (iOS), Roboto (Android) for body | Email: Helvetica body, Arial Black/Arial fallback |
| TYPO_002 | Typography | Left-align body text; center OK for 1-2 line headlines only | None |
| TYPO_003 | Typography | Line length 50-75 characters for body copy | None |
| TYPO_004 | Typography | ONE highlight color per headline; same color family | None |
| TYPO_005 | Typography | Never make headlines blue (implies interactivity) | None |
| SHAPE_001 | Shape | Default corner radius: 12px | Large/hero containers: 20px |
| SHAPE_002 | Shape | Do not override Constellation component corner radii | None |
| SHAPE_003 | Shape | 12px corners: 8-16px padding minimum | None |
| SHAPE_004 | Shape | 20px corners: 16-32px padding minimum | None |
| SHAPE_005 | Shape | Nested corners: outer ≥ inner rounding | None |
| ELEV_001 | Elevation | Shadows on interactive elements only | None |
| ELEV_002 | Elevation | Large shadows for property cards, toggle cards | None |
| ELEV_003 | Elevation | No nested shadows (shadow inside shadow) | None |
| ELEV_004 | Elevation | Dark mode: no shadows; use lighter backgrounds for elevation | None |
| ICON_001 | Icons | Filled icons as default | Outline for pre-interaction states (e.g., unfavorited heart) |
| ICON_002 | Icons | Sizes: sm=16px, md=24px (default), lg=32px, xl=44px | None |
| ICON_003 | Icons | Interactive icons: Blue600 | Gray950 when interaction is implied by container |
| ICON_004 | Icons | Content support icons: Gray600 | Teal600 for storytelling emphasis |
| PHOTO_001 | Photography | No wholly AI-generated images for consumer-facing assets | AI OK for geographic diversity, aspect ratio adjustment |
| PHOTO_002 | Photography | Never manipulate faces or hands with AI | None |
| ILLUS_001 | Illustration | Keep beige background element on spot illustrations | None |
| ILLUS_002 | Illustration | Zillow Blue present in every illustration (10-50%) | None |
| ILLUS_003 | Illustration | Spot: 160×160px; Scene: 300×500px aspect ratio | None |
| ILLUS_004 | Illustration | Do not edit, embellish, or remove elements from illustrations | None |

## Decision Trees

### Choosing a Background Color
```
Is this a hero section on a homepage/landing page?
├── Yes → Bold color OK (teal, purple, or blue). Pick ONE family.
└── No → Is this a card or section that needs prominence?
    ├── Yes → Saturated teal or purple background (ONE per page max)
    └── No → Use white (#FFFFFF) or light gray (#F7F7F7)

NEVER: light blue, navy, pastel tints, stacked colored sections
```

### Choosing a Color Family
```
What is the content about?
├── Trust, finance, home loans, agent connection → Teal family
├── Urgency, "New", "Open House", alerts → Orange family
├── Creativity, inspiration, new features → Purple family
├── Interactive elements, CTAs, links → Blue (action only)
└── Default / neutral → Granite text on Marble background

Rule: Once you pick a family, use it throughout the entire page.
```

### Choosing an Illustration Type
```
Is this a landing page hero, email header, or social post?
├── Yes → Scene illustration (300×500px aspect ratio)
└── No → Is this a value prop list, empty state, or upsell banner?
    ├── Yes → Spot illustration (160×160px)
    └── No → Could a 44px icon suffice?
        ├── Yes → Use xl icon instead
        └── No → Spot illustration
```

### Logo Colorway Selection
```
Is this an owned space (app, email, social)?
├── Yes → Primary logo preferred; white logo OK without blue
└── No (billboard, display ad, external)?
    ├── Is Zillow Blue present in the design? → White logo OK
    └── No blue present → MUST use tag design logo
```

## Reference Files

| File | Contents |
|------|----------|
| `references/color-system.md` | Full palette with hex/RGB, color families, usage rules, accessibility |
| `references/typography.md` | Object Sans hierarchy, pairings, emphasis, alignment rules |
| `references/logo-usage.md` | Sizing, clearspace, colorways, co-branding, incorrect usage |
| `references/verbal-identity.md` | Personality, archetype, writing principles, tone modulation |
| `references/photography-illustration.md` | Photo art direction, illustration types, house motifs |

## Cross-References

- **Constellation Design System** → `.agents/skills/constellation-design-system/` for component rules, spacing tokens, code patterns
- **Constellation Icons** → `.agents/skills/constellation-icons/` for icon catalog, name verification, import patterns
- **Constellation Illustrations** → `.agents/skills/constellation-illustrations/` for spot illustration catalog (93 illustrations with light/dark mode paths)
- **UX Writing Guide** → `custom_instruction/ux-writing-guide.md` for product copy standards
- **Instructions** → `custom_instruction/instructions.md` for implementation rules and validation workflow
