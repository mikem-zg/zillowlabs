# Zillow Presentation Branding Guide

## Color Palette

When creating or styling slides programmatically, prefer the Zillow template's built-in styles. Only apply colors manually when adding new elements beyond what the template provides.

**Important:** The Zillow template already includes branded master slides with correct colors, fonts, and layouts. Always copy from the template rather than building slides from scratch.

### Primary Colors (Safe to Use)

| Color | Hex | RGB (0-1 scale for API) | Usage |
|-------|-----|-------------------------|-------|
| Zillow Blue | `#0041D9` | `(0.0, 0.255, 0.851)` | Primary actions, links, clickable elements only |
| Granite (Dark) | `#111116` | `(0.067, 0.067, 0.086)` | Body text, dark backgrounds |
| Marble (White) | `#FFFFFF` | `(1.0, 1.0, 1.0)` | Backgrounds, reversed text |

### Accent Colors (Use Sparingly — Pick ONE Per Deck)

Choose at most one accent color family per presentation. Do not mix accent families.

| Color | Hex | RGB (0-1 scale) | Permitted Context |
|-------|-----|-----------------|-------------------|
| Teal 600 | `#006382` | `(0.0, 0.388, 0.510)` | Finance topics, home loans, trust themes |
| Orange 600 | `#C45300` | `(0.769, 0.325, 0.0)` | Urgency callouts, alerts — use very sparingly |
| Purple 500 | `#6B3FA0` | `(0.420, 0.247, 0.627)` | New features, innovation themes — use very sparingly |

**Note:** For most professional/internal presentations, stick to Blue + Gray only and avoid accent colors entirely. Accent colors are more appropriate for consumer-facing or marketing decks.

### Neutral Colors

| Color | Hex | RGB (0-1 scale) | Usage |
|-------|-----|-----------------|-------|
| Gray 50 | `#F7F7F7` | `(0.969, 0.969, 0.969)` | Section backgrounds |
| Gray 200 | `#D4D4D4` | `(0.831, 0.831, 0.831)` | Borders, dividers |
| Gray 600 | `#737373` | `(0.451, 0.451, 0.451)` | Subtle text, captions |
| Gray 950 | `#1A1A1A` | `(0.102, 0.102, 0.102)` | Primary text |

## Typography

### Font Families

| Priority | Font | Usage |
|----------|------|-------|
| Primary | **Arial** | All body text, bullet points |
| Headlines | **Arial Bold** | Slide titles, section headers |
| Monospace | **Roboto Mono** | Code samples, technical content |

### Font Sizes

| Element | Size (PT) | Weight |
|---------|-----------|--------|
| Slide title | 36-44 | Bold |
| Section header | 28-36 | Bold |
| Subtitle | 20-24 | Regular |
| Body text | 16-18 | Regular |
| Bullet points | 14-16 | Regular |
| Caption / Fine print | 10-12 | Regular |
| Big number / KPI | 60-72 | Bold |

## API Color Format

Google Slides API uses RGB values on a 0-1 scale:

```python
ZILLOW_COLORS = {
    "blue": {"red": 0.0, "green": 0.255, "blue": 0.851},       # #0041D9
    "granite": {"red": 0.067, "green": 0.067, "blue": 0.086},   # #111116
    "white": {"red": 1.0, "green": 1.0, "blue": 1.0},           # #FFFFFF
    "teal": {"red": 0.0, "green": 0.388, "blue": 0.510},        # #006382
    "orange": {"red": 0.769, "green": 0.325, "blue": 0.0},      # #C45300
    "purple": {"red": 0.420, "green": 0.247, "blue": 0.627},    # #6B3FA0
    "gray_50": {"red": 0.969, "green": 0.969, "blue": 0.969},   # #F7F7F7
    "gray_600": {"red": 0.451, "green": 0.451, "blue": 0.451},  # #737373
    "gray_950": {"red": 0.102, "green": 0.102, "blue": 0.102},  # #1A1A1A
}

def make_color(color_name):
    """Convert color name to API format."""
    rgb = ZILLOW_COLORS[color_name]
    return {"opaqueColor": {"rgbColor": rgb}}
```

## Slide Design Rules

### DO

- Use the Zillow template — it preserves brand fonts, master slides, and layouts
- Keep text left-aligned (except centered titles on title slides)
- Use Zillow Blue only for interactive elements (links, buttons, CTAs)
- Use Granite for all body text
- Keep backgrounds White or Light Gray (#F7F7F7) for section contrast
- Use one accent color family consistently throughout the deck
- Limit bold colors to under 25% of any slide (except title slides)
- Use high-contrast text (dark text on light backgrounds)

### DO NOT

- Do not use light blue backgrounds on slides
- Do not use more than one accent color family per deck
- Do not use Blue for non-interactive text (headlines, labels)
- Do not mix Purple, Orange, and Teal within the same presentation
- Do not use custom fonts — stick to Arial
- Do not use all caps for body text (sentence case only)
- Do not overcrowd slides — aim for 5-7 bullet points maximum per slide
- Do not use clip art or low-resolution images

## Logo Usage

### Zillow Logo Placement

- **Position:** Top-left or bottom-left of slides
- **Size:** Proportional, do not stretch or distort
- **Clear space:** Maintain padding equal to the logo height on all sides
- **On dark backgrounds:** Use white logo variant
- **On light backgrounds:** Use standard dark logo variant

### Co-branding

When presenting with partners or clients:
- Zillow logo appears first (left) or larger
- Partner logo separated by a divider or adequate spacing
- Both logos at the same visual weight

## Slide Content Guidelines

### Text

- **Sentence case** for all text (capitalize only first word and proper nouns)
- **Contractions** are acceptable (use "we'll" instead of "we will")
- **Active voice** preferred ("We increased sales" not "Sales were increased")
- **Numbers:** Use numerals for all numbers (1, 2, 3... not one, two, three)
- **Currency:** Format as $1,500 (with comma separators)

### Charts and Data Visualization

- Use Zillow Blue as the primary data color
- Use Gray for secondary/comparison data
- Use one accent color for highlights
- Always include data labels or a legend
- Title every chart with a descriptive heading
- Source data must be cited in fine print

### Images

- Use high-resolution images (minimum 150 DPI)
- Property photos should be well-lit and professional
- Avoid stock photos that feel generic
- Ensure image aspect ratios are maintained (no stretching)
