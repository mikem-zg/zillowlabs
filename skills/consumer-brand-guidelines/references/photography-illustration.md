# Photography & Illustration

Source: Zillow April 2024 Brand Guidelines, slides 167-252.

## Sourcing Assets

**All photography and logo assets MUST come from OrangeLogic DAM.** Never use AI image generation, stock photo APIs (Unsplash/Pexels), or placeholder images.

| Asset Type | Source | Skill Reference |
|------------|--------|-----------------|
| Photography (heroes, cards, backgrounds) | OrangeLogic DAM | `.agents/skills/orangelogic-dam/SKILL.md` |
| Spot illustrations (93 available) | Local assets in `client/src/assets/illustrations/` | `.agents/skills/constellation-illustrations/SKILL.md` |
| Logos and brand marks | OrangeLogic DAM | `.agents/skills/orangelogic-dam/SKILL.md` |
| PropertyCard listing photos | AI-generated OK (only exception) | `.agents/skills/property-card-data/SKILL.md` |

### Using DAM Assets in Code

Search the DAM, then use the `path_TR1.URI` CloudFront URL directly — never download to the local filesystem:

```tsx
<img src={asset.path_TR1.URI} alt={asset.CaptionShort || asset.Title} />
```

---

## Marketing: House Motifs

The House Motif is the primary graphic device that expresses the Zillow brand beyond the logo. Used in marketing contexts: ads, email, social, landing pages, OOH.

### Three Motif Types

| Motif | Purpose | When to Use |
|-------|---------|-------------|
| **Frame** | Leading motif; shows broad plane of photography | Dynamic photography, telling larger stories |
| **Window** | Draws focus; highlights intimate moments | Close-up moments, joy, excitement |
| **Solid House** | Graphic expression without photography | Typography-focused layouts, limited sizes |

### Frame Rules
- Always appears as a cropped element
- Lower edge/curve must not be visible when cropping with images
- Peak and at least one vertical edge must be visible

### Window Rules
- Peak and at least one vertical axis always visible
- Movement should overlap the crop (parts of image extend beyond shape)
- People should not be completely contained

### Solid House Rules
- Center-align all typography within the solid house
- Scale proportionally; never stretch or warp
- Can be cropped abstractly but keep the apex intact

### When to Skip the House Motif
- Small placements and challenging aspect ratios
- Wide angle photography
- Educational, informational tone
- Secondary email placements (not hero)

### House Motif DON'Ts
- Do not crop the apex
- Do not display as uncropped element
- Do not separate or exclude people
- Do not use with images without people
- Do not use with wide angle photography or home exteriors (Frame/Window)
- Do not manipulate or stretch the shape
- Do not place the window on a background other than white (`bg.screen.neutral`)

---

## Product: Shape, Containers & Elevation

### House Motifs in Product
The Frame and Window can be used as hero images on landing pages and in upsells across all LOBs.

### Containers in Product

| Type | Constellation Pattern | Use Case | Importance |
|------|----------------------|----------|------------|
| **Filled (saturated)** | `Card` with colored background | Upsells, alerts, system notifications | Highest |
| **Filled (white)** | `Card elevated={false} tone="neutral"` | Section callouts, accordions | Moderate |
| **Outlined** | `Card outlined elevated={false} tone="neutral"` | Grouping form fields | Separation |
| **Elevated interactive** | `Card elevated interactive tone="neutral"` | Property cards, task cards | Interactive |

### Accessible Interactive Containers
- Interactive cards must have a secondary visual indicator (text, border, or shadow)
- Use `Card elevated interactive` to get shadow + hover state automatically

### Rounded Corners in Product

| Type | Radius | Constellation Default | Min Padding |
|------|--------|----------------------|-------------|
| **Default** | 12px | `Card`, `Button` (built-in) | spacing `200`-`400` |
| **Large** | 20px | Hero containers | spacing `400`-`800` |
| **Full** (∞) | Pill | `Tag`, chips | — |

**Rules:**
- Do NOT override Constellation component corner radii (`SHAPE_002`)
- Nested rounded corners: outer ≥ inner rounding
- Large rounded corners with small padding looks juvenile

### Elevation in Product

| Shadow | Use Cases | Constellation |
|--------|-----------|--------------|
| **Large** | Property cards, toggle cards | `Card elevated` (default) |
| **Medium** | Sliding backgrounds | — |
| **Small heavy** | Interactive chips on maps | — |
| **Small light** | Small interactive components | — |

**Rules:**
- Shadows indicate interactivity — use to guide to clickable elements
- Do NOT nest shadows inside other shadows
- Do NOT use shadows on static, non-interactive elements
- Dark mode: no shadows; use lighter backgrounds for elevation (see **constellation-dark-mode** skill)

---

## Illustration (Both Marketing and Product)

### Two Types

| Type | Size | Marketing Use | Product Use |
|------|------|---------------|-------------|
| **Scene** | 300×500px aspect ratio | Landing pages, social, email headers | Landing page heroes, upsells |
| **Spot** | 160×160px | Email lists, value prop sets | Empty states, feature cards, upsell banners |

### Illustration Assets in Code

93 spot illustrations are available locally with light/dark mode variants:

```tsx
import SearchHomesLight from '@/assets/illustrations/Lightmode/search-homes.svg';
import SearchHomesDark from '@/assets/illustrations/Darkmode/search-homes.svg';

<img src={isDarkMode ? SearchHomesDark : SearchHomesLight} alt="Search homes" />
```

Full catalog: `.agents/skills/constellation-illustrations/SKILL.md`

### Color Strategy for Illustrations
- **Zillow Blue** (`Blue600`): 10-50% in every illustration for brand identification
- **Granite** (`Gray950`): 5-25% for depth
- **Finance = green**: Money/dollar signs always in green palette
- Beige background element (`#FFF0E1`) grounds spot illustrations — never remove

### Illustration DON'Ts

| DON'T | DO Instead |
|-------|-----------|
| Use colors outside the illustration palette | Use approved palette tokens |
| Edit, embellish, or remove elements | Contact the illustration team |
| Remove the beige background element | Keep for visual consistency |
| Create new illustrations without approval | Use existing catalog (93 illustrations) |
| Omit `Blue600` from any composition | Use strategically in all compositions |

---

## Product: Iconography

All icons use Constellation's `<Icon>` wrapper with size tokens.

### Icon Sizes

| Size Token | Pixels | Use |
|------------|--------|-----|
| `sm` | 16px | Components, input fields, paired with `body-sm` text |
| `md` | 24px | Default; pairs with `body` and `body-bold` text |
| `lg` | 32px | Higher emphasis (modals, content blocks); max 5 in proximity |
| `xl` | 44px | Where spot illustration is too prominent; max 3 in proximity |

### Icon Styles
- **Filled** (default): `IconHeartFilled`, `IconSearchFilled`
- **Outline**: Only for pre-interaction states (e.g., unfavorited heart)

### Icon Colors in Product

| Context | Semantic Token | Scale Token | Usage |
|---------|---------------|-------------|-------|
| Interactive icons | `icon.action.hero.default` | `Blue600` | Clickable icons |
| Functional icons | `icon.neutral` | `Gray950` | Input fields, tabs, nav |
| Content support | `icon.subtle` | `Gray600` | Paired with content |
| Storytelling | — | `Teal600` | Features, upsell banners |

### Icon Color in Code

```tsx
<Icon size="md" css={{ color: 'icon.action.hero.default' }}><IconSearchFilled /></Icon>
<Icon size="md" css={{ color: 'icon.neutral' }}><IconSettingsFilled /></Icon>
<Icon size="md" css={{ color: 'icon.subtle' }}><IconLocationFilled /></Icon>
```

**Never use the `color` prop** for semantic tokens — it does not resolve token paths. Always use `css`.

Full icon catalog (621 icons): `.agents/skills/constellation-icons/SKILL.md`

---

## Photography (Both Marketing and Product)

### Sourcing
**All photography assets must come from OrangeLogic DAM.** Search using the DAM skill, then use the CloudFront URL directly in `src` attributes.

### Art Direction
- Dynamic energy and unmissable joy
- Movement (real or suggested)
- Relatable rather than staged
- Vibrant, rich, saturated colors
- Natural light, shot in real homes

### Casting & Inclusivity
- Diversity in ethnicity, background, style, body type, culture
- Customers should see themselves reflected in imagery

### AI Guidelines
- No wholly AI-generated images for consumer-facing assets
- AI OK for: geographic diversity, aspect ratio adjustment, subtle manipulation for type placement
- Never manipulate faces or hands with AI
- Use only Zillow-approved AI tools (Adobe Firefly)
- Midjourney, DALL-E, etc. cannot be used for consumer-facing assets

### Product: Native Platform Color Balance
60-30-10 rule for small screens: 60% dominant color, 30% secondary, 10% accent.

## Cross-References

| Asset Need | Skill |
|-----------|-------|
| Photography, logos, brand assets | `.agents/skills/orangelogic-dam/SKILL.md` |
| Spot illustrations (93 with light/dark mode) | `.agents/skills/constellation-illustrations/SKILL.md` |
| Icon catalog (621 icons) | `.agents/skills/constellation-icons/SKILL.md` |
| PropertyCard listing photos (AI OK) | `.agents/skills/property-card-data/SKILL.md` |
| Dark mode patterns | `.agents/skills/constellation-dark-mode/SKILL.md` |
