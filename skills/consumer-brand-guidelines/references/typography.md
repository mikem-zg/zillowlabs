# Typography

Source: Zillow April 2024 Brand Guidelines, slides 140-166.

## Primary Typeface: Object Sans

Geometric, minimalist, contemporary. Approachable, conversational, confident.

| Weight | Use |
|--------|-----|
| **Heavy** | H1 headers, hero text |
| **Bold** | H2 subheaders |
| **Medium** | H3 secondary headings |
| **Regular** | Body copy (marketing only), legal/captions |

## Fallback Typeface: Poppins

When Object Sans is unavailable (e.g., Google Slides): Heavy→Bold, Bold→Semibold, Medium→Medium, Regular→Normal.

---

## Marketing Typography Rules

Marketing contexts: ads, email campaigns, social posts, OOH, landing pages, print.

### Hierarchy in Marketing

Object Sans is used across ALL weights in marketing, including body copy.

| Level | Weight | Leading Multiplier |
|-------|--------|-------------------|
| H1 Header | Heavy | ×1.1 |
| H2 Subheader | Bold | ×1.2 |
| H3 Secondary | Medium | ×1.3 |
| Body | Regular | ×1.3 |
| Legal / Captions | Regular | ×1.3 |

### Email Typography

| Role | Primary | Fallback |
|------|---------|----------|
| Headlines | Object Sans Heavy | Arial Black |
| Body | Helvetica | Arial |

---

## Product Typography Rules

Product contexts: app UI, website screens, in-product flows.

### Key Difference from Marketing
In product, Object Sans is used for **headings ONLY**. Body copy uses platform-native typefaces for performance and consistency.

### Platform Typeface Pairings

| Platform | Headings | Body Copy |
|----------|----------|-----------|
| Web | Object Sans Heavy | Inter |
| iOS | Object Sans Heavy | SF Pro |
| Android | Object Sans Heavy | Roboto |
| Email | Object Sans Heavy | Helvetica |

### Constellation `textStyle` Tokens (Product)

Use these tokens in code. They map to the correct font family, weight, size, and line height automatically.

| Content Type | Constellation Component + Token | Semantic Color |
|--------------|-------------------------------|----------------|
| Page headline (1-2 max) | `<Heading textStyle="heading-lg">` | default (`text.default`) |
| Section title | `<Text textStyle="body-lg-bold">` | default |
| Card title | `<Text textStyle="body-bold">` | default |
| Body / description | `<Text textStyle="body">` | `text.subtle` |
| Fine print / hints | `<Text textStyle="body-sm">` | `text.subtle` |

**Important:** `<Heading>` should be used for only 1-2 true page headlines per screen. All other titles should use `<Text>` with the appropriate `textStyle`. Overusing `<Heading>` dilutes impact.

**Display behavior:** `Text` renders as an inline `<span>`. Stack `Text` elements in `<Flex direction="column">` to ensure vertical layout.

### Web Type Scale (Product)

| Level | Typeface | Size/Leading | Constellation Token |
|-------|----------|-------------|-------------------|
| Display | Object Sans Heavy | 60/72 | — |
| H1 | Object Sans Heavy | 44/48 | `heading-lg` or larger |
| H2 | Object Sans Heavy | 36/40 | `heading-lg` |
| H3 | Object Sans Heavy | 24/32 | — |
| H4 | Object Sans Heavy | 20/24 | — |
| Subtitle | Inter Bold | 18/24 | `body-lg-bold` |
| Body | Inter Regular | 16/24 | `body` |
| Caption | Inter Regular | 14/24 | `body-sm` |

### Type Colors in Product

Three-color text system mapped to semantic tokens:

| Role | Light Mode | Dark Mode | Semantic Token |
|------|-----------|-----------|----------------|
| Primary | `Gray950` (Granite) | White | `text.default` |
| Secondary | Gray | Light gray | `text.subtle` |
| Inverse | White | Granite | `text.inverse` |

---

## Shared Typography Rules (Both Marketing and Product)

### Text Emphasis (Color Highlights)

| DO | DON'T |
|----|-------|
| Highlight specific words for "before & after" structure | Highlight random individual words |
| Use ONE color for highlighting | Mix color families in one headline |
| Keep the base text in Granite (`text.default`) | Use more than one highlight color |

### Text Alignment

| Alignment | When |
|-----------|------|
| **Left-align** (default) | Multiple lines, body copy, paragraphs |
| **Center-align** | Short headlines (1-2 lines), loading states, empty states |
| **Never center** | Multiple lines of body text |
| **Never justify** | Any text |

### Line Length
Body copy: 50-75 characters per line.

### NEVER Rules (Both Contexts)

| DON'T | Why |
|-------|-----|
| Use other typefaces (e.g., GT Walsheim) | Off-brand |
| Use Object Sans Heavy for body copy in product | Too heavy for extended reading; use `textStyle="body"` |
| Use outlined type | Not part of the visual system |
| Apply effects or drop shadows to text | Reduces legibility |
| Justify text | Violates alignment rules |
| Blue headlines | Implies interactivity (`text.action.hero.default` = links only) |

## Cross-References

- **Constellation textStyle tokens** → `custom_instruction/instructions.md` lines 343-350 for the complete hierarchy table
- **Constellation quick reference** → `.agents/skills/constellation-design-system/references/guides/quick-reference.md` for component + textStyle mapping
