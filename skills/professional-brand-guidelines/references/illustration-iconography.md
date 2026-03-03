# Illustration, Iconography & Photography (Professional)

Source: Zillow March 2025 Professional Brand Guidelines, slides 106-128.

## Sourcing Assets

| Asset Type | Source | Skill Reference |
|------------|--------|-----------------|
| Photography | OrangeLogic DAM | `.agents/skills/orangelogic-dam/SKILL.md` |
| Spot illustrations (93 available) | Local: `client/src/assets/illustrations/` | `.agents/skills/constellation-illustrations/SKILL.md` |
| Logos and brand marks | OrangeLogic DAM | `.agents/skills/orangelogic-dam/SKILL.md` |
| PropertyCard listing photos | AI-generated OK (only exception) | `.agents/skills/property-card-data/SKILL.md` |

---

## Illustration

### Spot Illustrations ONLY

**No scene illustrations for the professional audience.** Use photography for hero visuals and illustrations as supporting elements only.

| Type | Size | Use For |
|------|------|---------|
| **Spot** | 160×160px | Empty states, value props, upsell banners, supporting copy and CTAs |

### When to Use What

| Visual Need | Use This | NOT This |
|-------------|----------|----------|
| Hero visual | Photography (from DAM) | Illustration |
| Supporting content | Spot illustration | Scene illustration |
| Simple highlight | xl duotone icon (44px) | Spot illustration |
| Navigation cue | Filled icon (16-32px) | Illustration |

### Using Illustrations in Code

```tsx
import SearchHomesLight from '@/assets/illustrations/Lightmode/search-homes.svg';
import SearchHomesDark from '@/assets/illustrations/Darkmode/search-homes.svg';

<img src={isDarkMode ? SearchHomesDark : SearchHomesLight} alt="Search homes" />
```

### Illustration DON'Ts

| DON'T | DO Instead |
|-------|-----------|
| Use scene illustrations for professionals | Use photography as hero; illustration as support |
| Use spot illustrations at overly large or small scale | Standard 160×160px |
| Stretch or modify to fit aspect ratio | Use at native proportions |
| Place against dark gray backgrounds | Place against white (`bg.screen.neutral`) |
| Remove beige background element | Keep for visual consistency |
| Edit, embellish, or remove elements | Contact illustration team |
| Omit `Blue600` from compositions | Use strategically for brand cohesion |
| Create new illustrations without approval | Use existing catalog |

---

## Iconography

### Icon Sizes

| Size Token | Pixels | Use |
|------------|--------|-----|
| `sm` | 16px | Components, input fields, paired with `body-sm` text |
| `md` | 24px | Default; pairs with `body` and `body-bold` text |
| `lg` | 32px | Higher emphasis (modals, content blocks); max 5 in proximity |
| `xl` | 44px | Where spot illustration is too prominent; max 4 duotone in proximity |

### Three Icon Styles (Professional)

| Style | When to Use | Example |
|-------|-------------|---------|
| **Filled** (default) | Most use cases; complements bold type | Functional UI, navigation, actions |
| **Outline** | Pre-interaction states; dense task-oriented UIs | Unfavorited heart, internal tools |
| **Duotone** | Professional-specific — upsells, empty states, awareness moments | Landing page cards, feature highlights, success pages |

### Duotone Icons (Professional-Specific)

Duotone is a new icon style for professionals. Provides additional visual weight for high-level UI cases.

- Use "Express - trust" color variant in Figma for brand consistency
- NOT for functional moments — only awareness-building experiences
- Do NOT use other color variants (causes inconsistent brand experience)
- Replace legacy "Detailed Icons" with xl duotone icons

### Icon Colors in Product

| Context | Semantic Token | Scale Token | When |
|---------|---------------|-------------|------|
| Interactive icons | `icon.action.hero.default` | `Blue600` | Clickable icons, CTAs |
| Functional icons | `icon.neutral` | `Gray950` | Input fields, tabs, nav, global nav |
| Content support | `icon.subtle` | `Gray600` | Paired with content for separation |
| Duotone (upsells) | "Express - trust" variant | — | Landing pages, upsell banners |

### Icon Color in Code

```tsx
<Icon size="md" css={{ color: 'icon.action.hero.default' }}><IconSearchFilled /></Icon>
<Icon size="md" css={{ color: 'icon.neutral' }}><IconSettingsFilled /></Icon>
<Icon size="md" css={{ color: 'icon.subtle' }}><IconLocationFilled /></Icon>
```

### Icon Usage Rules

| DO | DON'T |
|----|-------|
| Use icons to improve visual interest and guide navigation | Enlarge icons to spot illustration size |
| Include text labels alongside icons | Use colors with poor contrast |
| Use sparingly when easily recognizable | Overuse — few icons are universally recognized without labels |

---

## Photography

### Sourcing
All photography from OrangeLogic DAM. Use CloudFront URLs directly in `src` attributes.

### Art Direction (Professional-Specific)
- Day-to-day lives of partners — agents, lenders, property managers
- Candid professional moments of comfort, excitement, authenticity
- Device/product shots showing Zillow UI clearly
- Homes that agents would be excited to represent
- Lived-in interiors (never sterile or overly designed)

### Embrace

| EMBRACE | AVOID |
|---------|-------|
| Realistic depth of field | Overly shallow or wide depth-of-field |
| Unique perspectives and framing | Expected, straight-on angles |
| Realistic staging (Post-Its, family photos) | Environments too organized or staged |
| Lived-in, casual wardrobe unique to each character | Generic, overly-formal wardrobe |
| Lived-in workspaces with hustle elements | Idealized or model-like talent |
| Diverse, approachable talent | Locations that don't read as business locations |
| Candid, relatable moments | Wholly AI-generated images |
| Natural yet elevated lighting | — |

### AI Guidelines
- No wholly AI-generated images
- AI OK for: geographic diversity, aspect ratio adjustment
- Never manipulate faces or hands
- Use only Zillow-approved AI tools (Adobe Firefly)

## Cross-References

| Asset Need | Skill |
|-----------|-------|
| Photography, logos | `.agents/skills/orangelogic-dam/SKILL.md` |
| Spot illustrations (93) | `.agents/skills/constellation-illustrations/SKILL.md` |
| Icon catalog (621 icons) | `.agents/skills/constellation-icons/SKILL.md` |
| PropertyCard photos (AI OK) | `.agents/skills/property-card-data/SKILL.md` |
