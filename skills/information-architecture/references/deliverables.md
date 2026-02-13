# IA Deliverables

## Sitemaps

A visual representation of the site's hierarchical structure. The primary communication tool for IA decisions.

### Types

| Type | Shows | Audience |
|------|-------|----------|
| **Structural sitemap** | Page hierarchy and relationships | Developers, designers, stakeholders |
| **Content sitemap** | Content types at each level | Content strategists, writers |
| **Visual sitemap** | Annotated with wireframe thumbnails | Designers, product managers |

### Components

Every sitemap should include:
- Page/section labels (using production terminology)
- Hierarchy depth (levels)
- Cross-links between sections (dotted lines)
- Content type indicators
- Utility pages (login, error, search results)
- Annotation for dynamic/personalized sections

### Conventions

| Symbol | Meaning |
|--------|---------|
| Rectangle | Page or section |
| Solid line | Parent-child relationship |
| Dotted line | Cross-link or reference |
| Dashed border | Dynamic/conditional page |
| Color coding | Content type or owner |
| Numbering | Priority or launch phase |

### Best Practices

- Start with the top 2-3 levels — add depth iteratively
- Include utility pages (search, login, 404, settings)
- Show where content types repeat (e.g., "Listing detail" is one template, many instances)
- Note where personalization changes the structure
- Version the sitemap — it will evolve with research findings

## User Flows

A diagram showing the path a user takes to complete a specific task.

### When to Create

- For every critical user task (search for a home, schedule a tour, get pre-approved)
- When mapping multi-step processes
- When identifying where users drop off
- When communicating handoffs between systems

### Components

| Component | Representation |
|-----------|----------------|
| **Entry point** | Circle or rounded rectangle |
| **Decision point** | Diamond |
| **Action** | Rectangle |
| **System response** | Rectangle (different color) |
| **End point** | Circle with border |
| **Error state** | Red rectangle |
| **External system** | Dashed rectangle |

### Flow Types

| Type | Purpose | Example |
|------|---------|---------|
| **Happy path** | Ideal completion flow | Search → View → Save → Tour → Offer |
| **Error flow** | What happens when things go wrong | Invalid input, no results, timeout |
| **Edge case flow** | Uncommon but important scenarios | Co-shopper adds property, agent changes |
| **Cross-platform flow** | User moves between devices | Start on mobile, continue on desktop |

### Best Practices

- One flow per task — don't combine multiple goals
- Include system responses, not just user actions
- Show error states and recovery paths
- Note where analytics events fire
- Annotate decision points with the logic/criteria

## Wireframes (IA-Focused)

Low-fidelity layouts that demonstrate information hierarchy and content placement — not visual design.

### What to Show

| Element | Purpose |
|---------|---------|
| **Navigation placement** | Where global/local nav appears |
| **Content zones** | What type of content goes where |
| **Information hierarchy** | Size and position indicate importance |
| **Interactive elements** | Buttons, links, filters (labeled, not styled) |
| **Content priority** | What's above the fold, what requires scrolling |

### What NOT to Show

- Colors, fonts, or visual design
- Real photography or illustrations
- Pixel-perfect spacing
- Brand elements

### Annotation Guidelines

- Label every section with its content type
- Note dynamic vs static content
- Indicate responsive behavior (what changes on mobile)
- Call out IA decisions (why this grouping, why this order)

## Taxonomy Documentation

A formal document defining the classification system for content.

### Structure

1. **Scope** — what content does this taxonomy cover?
2. **Governance** — who owns it, how are changes made?
3. **Term list** — all terms with definitions
4. **Hierarchy** — parent-child relationships
5. **Relationships** — synonyms, related terms, see-also
6. **Rules** — how to apply terms (one per item? multiple?)
7. **Examples** — sample content with applied taxonomy

### Term Entry Format

For each taxonomy term, document:

| Field | Content |
|-------|---------|
| **Preferred term** | The canonical label |
| **Definition** | What this term means in context |
| **Synonyms** | Alternative terms users might use |
| **Parent** | The broader category |
| **Children** | Narrower categories (if any) |
| **Related terms** | Associated concepts in other facets |
| **Usage notes** | When to apply, edge cases |
| **Examples** | Sample content that belongs here |

## Navigation Specification

A document defining the navigation system's structure, behavior, and labels.

### Contents

1. **Global navigation** — labels, order, destinations, active states
2. **Local navigation** — per-section nav, sidebar structure
3. **Breadcrumbs** — format, depth, dynamic segments
4. **Search** — placement, behavior, facets, auto-suggest rules
5. **Mobile adaptations** — how each nav element changes on mobile
6. **Footer** — links, grouping, priority
7. **Utility navigation** — login, settings, help, language

### Specification Format

For each navigation element:

| Property | Detail |
|----------|--------|
| **Label** | Exact text (production-ready) |
| **Destination** | URL or route |
| **Behavior** | Click, hover, expand, drawer |
| **Active state** | When is this item highlighted? |
| **Visibility** | Always visible, conditional, responsive |
| **Priority** | Primary, secondary, utility |
| **Mobile treatment** | Tab bar, hamburger, accordion, hidden |

## Content Model Documentation

Formal specification of content types, their attributes, and relationships.

### Per Content Type

| Section | Content |
|---------|---------|
| **Name** | Content type name |
| **Description** | What this type represents |
| **Fields** | All attributes with data types, required/optional, validation |
| **Relationships** | How it connects to other content types |
| **Display contexts** | Where it appears (card, detail, list, search result) |
| **Lifecycle** | States (draft, published, archived) |
| **Permissions** | Who can create, edit, publish, delete |
| **Templates** | Display templates for each context |

## IA Audit Report

A document evaluating the current state of information architecture.

### Sections

1. **Executive summary** — key findings and recommendations
2. **Methodology** — what was tested, how, with whom
3. **Findings by area**
   - Navigation effectiveness (tree test results)
   - Categorization alignment (card sort results)
   - Labeling clarity (user comprehension)
   - Search effectiveness (query analysis)
   - Content findability (task completion rates)
4. **Competitive comparison** — how competitors handle similar IA challenges
5. **Recommendations** — prioritized list of changes with rationale
6. **Appendices** — raw data, participant demographics, detailed results
