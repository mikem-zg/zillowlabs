# Typography (Professional)

Source: Zillow March 2025 Professional Brand Guidelines, slides 51-73.

## Primary Typeface: Object Sans

Same typeface as consumer. Geometric, minimalist, contemporary.

| Weight | Use |
|--------|-----|
| **Heavy** | H1 headers, hero text |
| **Bold** | H2 subheaders |
| **Medium** | H3 secondary headings |
| **Regular** | Body copy (marketing only), legal/captions |

## Fallback: Poppins

When Object Sans is unavailable: Heavy→Bold, Bold→Semibold, Medium→Medium, Regular→Normal.

---

## Marketing Typography Rules

### Hierarchy in Marketing

Object Sans used across ALL weights in marketing.

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

### Key Difference from Marketing
Object Sans is used for **headings ONLY** in product. Body copy uses platform-native typefaces.

### Platform Typeface Pairings

| Platform | Headings | Body Copy |
|----------|----------|-----------|
| Web | Object Sans Heavy | Inter |
| iOS | Object Sans Heavy | SF Pro |
| Android | Object Sans Heavy | Roboto |
| Email | Object Sans Heavy | Helvetica |

### Constellation `textStyle` Tokens (Product)

| Content Type | Component + Token | Semantic Color |
|--------------|------------------|----------------|
| Page headline (1-2 max) | `<Heading textStyle="heading-lg">` | `text.default` |
| Section title | `<Text textStyle="body-lg-bold">` | `text.default` |
| Card title | `<Text textStyle="body-bold">` | `text.default` |
| Body / description | `<Text textStyle="body">` | `text.subtle` |
| Fine print / hints | `<Text textStyle="body-sm">` | `text.subtle` |

### Web Type Scale (Product)

| Level | Typeface | Size/Leading | Token |
|-------|----------|-------------|-------|
| Display | Object Sans Heavy | 60/72 | — |
| H1 | Object Sans Heavy | 44/48 | `heading-lg` |
| H2 | Object Sans Heavy | 36/40 | `heading-lg` |
| H3 | Object Sans Heavy | 24/32 | — |
| H4 | Object Sans Heavy | 20/24 | — |
| Subtitle | Inter Bold | 18/24 | `body-lg-bold` |
| Body | Inter Regular | 16/24 | `body` |
| Caption | Inter Regular | 14/24 | `body-sm` |

### Type Colors in Product

| Role | Light Mode | Dark Mode | Token |
|------|-----------|-----------|-------|
| Primary | `Gray950` | White | `text.default` |
| Secondary | Gray | Light gray | `text.subtle` |
| Inverse | White | `Gray950` | `text.inverse` |

---

## Shared Typography Rules (Both)

### Emphasis

| DO | DON'T |
|----|-------|
| Highlight specific words; brighter than rest of sentence | Highlight individual words inside a sentence |
| Omit emphasis when singular idea is communicated | Use more than one color or multiple highlights |
| Ensure headlines are readable against dark and light backgrounds | Combine too many type colors in a layout |

### Alignment

| Alignment | When |
|-----------|------|
| **Left-align** (default) | Multiple lines, body copy |
| **Center** | Short headlines (1-2 lines), symmetric layouts |
| **Never center** | Multiple lines of body text |

### Line Length
50-75 characters per line for body copy.

### NEVER Rules

| DON'T | Why |
|-------|-----|
| Use other typefaces (GT Walsheim) | Off-brand |
| Object Sans Heavy for body copy | Too heavy for extended reading |
| Weights outside selected range (Thin) | Not in brand family |
| Leave widows in text treatments | Disrupts readability |
| Apply effects or drop shadows to text | Reduces legibility |
| Justify text | Violates alignment rules |
| Blue headlines | Implies interactivity |

## Cross-References

- **Constellation textStyle tokens** → `custom_instruction/instructions.md` lines 343-350
- **Consumer typography** → `.agents/skills/consumer-brand-guidelines/references/typography.md`
