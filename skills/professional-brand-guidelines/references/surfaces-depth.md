# Surfaces & Depth (Professional — Product Only)

Source: Zillow March 2025 Professional Brand Guidelines, slides 83-105.

## Depth Model

Every component and surface has an implied depth. Surfaces closer to the user appear lighter (in light mode) or lighter (in dark mode — like shining a flashlight from above).

## Page Backgrounds

| Background | Token / Value | Use |
|-----------|--------------|-----|
| White | `bg.screen.neutral` | Default page background |
| Light gray | `bg.screen.muted` / `#F7F7F7` | Section differentiation |
| Colored | `Blue600` or `Blue800` tones | Sparingly — one accent section max |
| Dark gray | — | Dark mode only |
| Black | — | Dark mode only |

**Note:** Gray background in light mode pushes surface below base level. In dark mode, gray makes surface appear slightly raised.

## Container Types

Containers are elements that hold information, data, and visuals. They layer on top of backgrounds. Similar to Constellation's `Card` component, but not all containers require a `Card`.

| Type | Appearance | Constellation Pattern | Use Case |
|------|-----------|----------------------|----------|
| **Blank (white)** | White fill, no border | `Card elevated={false} tone="neutral"` | Section callouts, accordions |
| **Grayscale** | Gray fill | `Card` with gray background | Subtle grouping |
| **Solid filled** | Bold color fill | `Card` with colored background | Upsells, alerts, high-importance (ONE per page) |
| **Elevated** | Shadow | `Card elevated interactive tone="neutral"` | Interactive cards, property cards |
| **Outlined** | Border, no fill | `Card outlined elevated={false} tone="neutral"` | Form field grouping, discrete sections |
| **Colored** | Brand color fill | `Card` with `Blue600`/`Blue800` background | Premium content, upsells |

## What Containers Communicate

| Communication | Container Types |
|---------------|----------------|
| Content is grouped together | Gray, Blank (white) |
| Static information display | Outlined blank (white) |
| Strong emphasis on content | Colored, Container with photo |
| Interactivity (clickable) | Elevated white, Elevated colored |
| Supporting/educational | Container with illustration or icon |

**Important:** Interactive cards MUST have a secondary visual indicator (text, border, or shadow) to communicate interactivity to users with visual disabilities.

## Container DOs and DON'Ts

| DO | DON'T |
|----|-------|
| Use varying container types for visual hierarchy | Use gray cards with drop shadow (shadow muddles gray edge) |
| Use solid flat container to separate content within another container | Use colored cards with border (border muddles colored edge) |
| White containers for content that needs focus | Too many dark colored containers (impacts hierarchy) |
| Use elevation to suggest interactivity | Gray or colored cards with border in dark mode |

## Elevation / Shadows

### Shadow Levels

| Shadow | Use Cases |
|--------|-----------|
| **Large** | Modals, page overlays, large interactive containers — provides prominence |
| **Medium** | Cards, making content/next-best-action prominent — use most often |
| **Small** | Components needing separation between elements |

### Elevation Rules

| DO | DON'T |
|----|-------|
| Apply shadows to interactive elements to suggest clickability | Nest shadows inside containers that already have shadows |
| Use flat containers to separate content within shadowed containers | Apply shadows to non-interactive elements |
| Medium shadow most commonly | Too many prominent shadows (clutters UI, confuses interactivity) |

## Rounded Corners

| Type | Radius | Use Cases | Min Padding |
|------|--------|-----------|-------------|
| **Default** | 12px | Buttons, small cards, property cards, banners, alerts | spacing `200`-`400` |
| **Large** | 20px | Prominent hero cards, large sections | spacing `400`-`800` |
| **Full** (∞) | Pill | Tags, chips, icon buttons | — |
| **Circular** | 50% | Small interactive elements | — |

**Rules:**
- Do NOT override Constellation component corner radii
- Nested corners: outer ≥ inner rounding
- Large rounded corners with small padding looks juvenile

## Dark Mode Containers

- Blank cards become lighter than background (appear similar to elevated cards)
- No shadows in dark mode — use color lightness for elevation
- Do not use gray or colored cards with borders (muddles edges)
- Lightest areas = closest to user; darkest = farthest away

## Cross-References

- **Card component patterns** → `custom_instruction/instructions.md` lines 146-174
- **Consumer surfaces** → `.agents/skills/consumer-brand-guidelines/references/photography-illustration.md` (Product: Shape section)
- **Dark mode** → `.agents/skills/constellation-dark-mode/SKILL.md`
