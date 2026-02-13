# Zillow Slide Templates Reference

## Zillow Template ID

```
Template ID: 1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4
URL: https://docs.google.com/presentation/d/1vcfUwWSFD_gPQiOIJdPvDzBENT170CrJvKB0gnEmME4/edit
```

## Available Predefined Layouts

When adding slides via the API, use these `predefinedLayout` values:

### TITLE
Full-screen title slide. Used for opening slides and major section dividers.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "TITLE"}}}
```
**Contains:** Title placeholder, Subtitle placeholder
**Best for:** First slide, section transitions

### TITLE_AND_BODY
Standard content slide with a title and body text area.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "TITLE_AND_BODY"}}}
```
**Contains:** Title placeholder, Body text placeholder
**Best for:** General content, bullet points, descriptions

### TITLE_AND_TWO_COLUMNS
Title with two side-by-side content areas.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "TITLE_AND_TWO_COLUMNS"}}}
```
**Contains:** Title placeholder, Left column, Right column
**Best for:** Comparisons, before/after, pros/cons

### SECTION_HEADER
Section break slide with prominent text.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "SECTION_HEADER"}}}
```
**Contains:** Title placeholder, Description placeholder
**Best for:** Topic transitions between major sections

### BLANK
Empty slide with no placeholders.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "BLANK"}}}
```
**Contains:** Nothing — fully custom layout
**Best for:** Full-bleed images, custom charts, freeform design

### CAPTION_ONLY
Slide with only a caption area.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "CAPTION_ONLY"}}}
```
**Contains:** Caption text placeholder
**Best for:** Images with captions, simple callouts

### BIG_NUMBER
Slide optimized for displaying a large statistic or KPI.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "BIG_NUMBER"}}}
```
**Contains:** Number placeholder, Description placeholder
**Best for:** KPIs, key metrics, headline statistics

### ONE_COLUMN_TEXT
Single column text layout.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "ONE_COLUMN_TEXT"}}}
```
**Contains:** Title placeholder, Single text column
**Best for:** Text-heavy content, narratives, long-form explanations

### MAIN_POINT
Slide designed to convey a single key takeaway.

```python
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "MAIN_POINT"}}}
```
**Contains:** Main point text placeholder
**Best for:** Key takeaways, summary points, important conclusions

## Common Slide Patterns for Zillow Presentations

### Market Report Deck

| Slide # | Layout | Content |
|---------|--------|---------|
| 1 | TITLE | Report title, date, author |
| 2 | SECTION_HEADER | "Market Overview" |
| 3 | BIG_NUMBER | Key statistic (e.g., median home price) |
| 4 | TITLE_AND_BODY | Market trends, bullet points |
| 5 | TITLE_AND_TWO_COLUMNS | Year-over-year comparison |
| 6 | BLANK | Full chart / graph |
| 7 | SECTION_HEADER | "Regional Breakdown" |
| 8-10 | TITLE_AND_BODY | Per-region data |
| 11 | MAIN_POINT | Key takeaway |
| 12 | TITLE | Thank you / Contact info |

### Product Update Deck

| Slide # | Layout | Content |
|---------|--------|---------|
| 1 | TITLE | Product name, version, date |
| 2 | TITLE_AND_BODY | Agenda / Overview |
| 3 | SECTION_HEADER | "What's New" |
| 4-6 | TITLE_AND_BODY | Feature details |
| 7 | BIG_NUMBER | Key metric improvement |
| 8 | TITLE_AND_TWO_COLUMNS | Before/After comparison |
| 9 | MAIN_POINT | Summary |
| 10 | TITLE | Next steps / Q&A |

### Team Presentation Deck

| Slide # | Layout | Content |
|---------|--------|---------|
| 1 | TITLE | Presentation title, team, date |
| 2 | TITLE_AND_BODY | Agenda |
| 3 | SECTION_HEADER | Section 1 |
| 4-5 | TITLE_AND_BODY | Content slides |
| 6 | SECTION_HEADER | Section 2 |
| 7-8 | TITLE_AND_BODY | Content slides |
| 9 | BIG_NUMBER | Impact metric |
| 10 | MAIN_POINT | Key takeaway |
| 11 | TITLE | Q&A |

## Placeholder Conventions

Use double curly braces for placeholders in template slides:

| Placeholder | Description | Example Value |
|-------------|-------------|---------------|
| `{{title}}` | Presentation title | "Q1 2025 Market Report" |
| `{{subtitle}}` | Subtitle or tagline | "Seattle Metro Area Analysis" |
| `{{date}}` | Report date | "February 2025" |
| `{{author}}` | Author name | "Jane Smith" |
| `{{team}}` | Team name | "Zillow Economics Research" |
| `{{section_title}}` | Section heading | "Market Overview" |
| `{{metric_value}}` | Key number | "$650,000" |
| `{{metric_label}}` | Metric description | "Median Home Price" |
| `{{chart_placeholder}}` | Image placeholder (replaced by chart) | — |
| `{{image_placeholder}}` | Image placeholder (replaced by image) | — |
