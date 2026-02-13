# Navigation Patterns

## Global Navigation

The persistent navigation visible on every page. It's the user's primary orientation and wayfinding tool.

### Design Rules

| Rule | Rationale |
|------|-----------|
| 5-7 top-level items max | Beyond 7, cognitive load increases sharply |
| Consistent labels across pages | Changing labels destroys trust and orientation |
| Highlight current section | Users need to know where they are |
| Solid background on sticky headers | Transparency causes readability issues on scroll |
| Include search access | Not a replacement for nav, but a complement |

### Desktop Patterns

| Pattern | When to Use | Max Items |
|---------|-------------|-----------|
| **Horizontal bar** | Most websites and apps | 5-7 |
| **Left sidebar** | Documentation, dashboards, admin tools | 10-15 with groups |
| **Mega menu** | Large sites with many categories | 20+ with visual grouping |
| **Tab bar** | Single-page apps with distinct sections | 3-5 |

### Mobile Patterns

| Pattern | When to Use | Pros | Cons |
|---------|-------------|------|------|
| **Bottom tab bar** | Core app sections (max 5) | Thumb-friendly, always visible | Limited items |
| **Hamburger menu** | Secondary nav, large sites | Saves space | Low discoverability |
| **Drawer** | Filters, settings, account | Familiar pattern | Extra tap to access |
| **Accordion** | Nested categories | Shows hierarchy | Can be lengthy |

## Breadcrumbs

Show the user's current position in the hierarchy.

### When to Use

- Multi-level hierarchies (3+ levels deep)
- E-commerce product pages
- Documentation and knowledge bases
- Content-heavy sites with deep structure
- Any page users might reach via search or external links

### When NOT to Use

- Flat site structures (1-2 levels)
- Single-page applications
- Linear processes (use step indicators instead)

### Format

```
Home > Category > Sub-category > Current Page
        ↑ clickable    ↑ clickable     ↑ not clickable
```

### Rules

- Always start with Home
- Every segment except the current page should be clickable
- Use ">" or "/" as separators
- Current page should be visually distinct (bold, no link)
- Place consistently — typically below global nav, above page title
- Implement schema.org BreadcrumbList markup for SEO

## Mega Menus

Expanded navigation panels for sites with many categories.

### When to Use

- 10+ top-level categories
- Users need to see sub-categories before clicking
- Content is browsable (e-commerce, large content sites)
- University sites, enterprise portals, retailers

### Design Guidelines

| Guideline | Detail |
|-----------|--------|
| **Visual grouping** | Use columns, headers, and whitespace to organize |
| **Max depth** | Show 2-3 levels maximum |
| **Include "View all"** | Every category group should have a "View all" link |
| **Add visual cues** | Icons, thumbnails, or featured images aid scanning |
| **Highlight new/featured** | Call out important items with badges |
| **Mobile fallback** | Convert to accordion or drill-down on mobile |

### Anti-Patterns

- Mega menus that cover the entire viewport (overwhelming)
- No visual hierarchy within the menu (wall of links)
- Requiring precise mouse movement to keep the menu open
- Missing "View all" — users stuck if they don't see their item
- Inconsistent grouping logic across categories

## Faceted Search

Multi-dimensional filtering for content with many attributes. Essential for catalogs of 100+ items.

### When to Use

- Product catalogs, property listings, job boards
- Content with 3+ filterable attributes
- Users have specific criteria but browse within results
- Items are comparable across multiple dimensions

### Facet Types

| Type | UI Pattern | Best For |
|------|-----------|----------|
| **Range** | Slider or dual input | Price, sqft, year |
| **Single select** | Radio buttons or dropdown | Property type, status |
| **Multi select** | Checkboxes | Amenities, features |
| **Color/visual** | Swatches | Colors, finishes |
| **Boolean** | Toggle | "Has pool," "Has garage" |
| **Location** | Map, radius, text input | Geography |

### Layout

| Layout | When | Pros | Cons |
|--------|------|------|------|
| **Left sidebar** | Desktop, many facets | Scannable, scalable | Takes horizontal space |
| **Horizontal bar** | Simple catalogs (3-5 facets) | Compact | Can't fit many options |
| **Drawer/modal** | Mobile, complex filters | Full screen for interaction | Extra tap to access |

### Design Rules

1. **Show result counts** — "3 bed (142)" helps users predict results
2. **Disable unavailable options** — don't show "0 results" options
3. **Show active filters clearly** — badge or breadbox of selected filters
4. **Provide "Clear all"** — one-click reset of all filters
5. **Most-used facets first** — price, category, location typically top
6. **Progressive disclosure** — show 5-8 facets, "More filters" for the rest
7. **Mobile: batch apply** — don't reload on every tap, wait for "Apply"
8. **Preserve state** — filters should persist when navigating back to results

### Zillow Application

Zillow's property search uses extensive faceted navigation:
- Primary: Location, Price, Beds, Baths, Home Type
- Secondary: Sqft, Lot size, Year built, Days on market
- Tertiary: Keywords, amenities, specific features
- Map integration: Location facet tied to map bounds

## Local/Contextual Navigation

Navigation specific to a section or page context.

### Patterns

| Pattern | Use Case | Example |
|---------|----------|---------|
| **Sidebar nav** | Section-specific pages | Documentation left nav |
| **In-page anchors** | Long-form content | Table of contents with jump links |
| **Related content** | Cross-linking | "You might also like" |
| **Tabs** | Same topic, different views | Overview / Details / Reviews |
| **Pagination** | Long content lists | Page 1 of 50 |
| **Step indicator** | Linear processes | "Step 2 of 5: Financing" |

## Footer Navigation

Secondary navigation at the bottom of the page.

### What Belongs in the Footer

- Sitemap-style comprehensive link list
- Legal links (terms, privacy, accessibility)
- Contact information
- Social media links
- Newsletter signup
- App download links
- Language/region selector

### What Does NOT Belong in the Footer

- Primary navigation (users shouldn't need the footer to navigate)
- Important calls-to-action
- Content that users need to see before scrolling

## Information Scent

The degree to which a navigation element communicates what content lies behind it. Strong scent = users confidently click. Weak scent = users hesitate or click incorrectly.

### Improving Information Scent

| Technique | Example |
|-----------|---------|
| **Descriptive labels** | "Mortgage calculator" not "Tools" |
| **Trigger words** | Use terms that match user search queries |
| **Preview text** | Show 1-2 lines of content below the link |
| **Icons** | Visual reinforcement of the label meaning |
| **Exemplars** | Show sample content from the category |
| **Result counts** | "Homes for sale (2,345)" confirms content exists |
