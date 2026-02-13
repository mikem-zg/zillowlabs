# IA Foundations

## Dan Brown's 8 Principles (Deep Dive)

### 1. Principle of Objects

Treat content as living things with lifecycles, behaviors, and attributes — not static pages.

Every content object should have:
- **Type** — what kind of thing is it (article, listing, profile, tool)
- **Attributes** — metadata fields (title, date, author, category, status)
- **Relationships** — how it connects to other objects (parent, sibling, related)
- **Lifecycle** — creation, publication, update, archival, deletion
- **Behaviors** — what actions users can take (save, share, compare, filter)

Application: When designing IA, map content objects first. Ask "what are the nouns in this system?" before designing navigation.

### 2. Principle of Choices

Hick's Law: decision time increases logarithmically with number of options. Keep choices focused.

| Number of Options | User Experience |
|-------------------|-----------------|
| 3-5 | Comfortable, quick decision |
| 6-9 | Manageable with clear labels |
| 10-15 | Requires scanning, grouping helps |
| 15+ | Overwhelming — use progressive disclosure or search |

Application: Limit primary navigation to 5-7 items. Use progressive disclosure for deeper choices.

### 3. Principle of Disclosure

Progressive disclosure — show information in layers:

| Layer | What to Show | Example |
|-------|-------------|---------|
| **Overview** | Titles, thumbnails, key data | Search results list |
| **Preview** | Summary, key details | Card hover state, modal |
| **Detail** | Full content, all metadata | Detail page |
| **Related** | Connected content, next steps | Recommendations, similar items |

Application: Never front-load all information. Each interaction should reveal the next appropriate level of detail.

### 4. Principle of Exemplars

Show don't tell. Categories become understandable through examples.

- Show a sample item when describing a category
- Use icons, images, or previews alongside labels
- "New construction" is clearer with a photo of a new build

Application: Navigation labels become self-documenting when paired with exemplar content.

### 5. Principle of Multiple Classification

Different users have different mental models for finding the same thing.

| User Intent | Access Path | Example |
|-------------|-------------|---------|
| Knows what they want | Search | "123 Main St" |
| Browsing by attribute | Filter/facet | "3 bed, 2 bath, under $500k" |
| Exploring a category | Navigation | "Homes for sale in Seattle" |
| Following a workflow | Sequential | "Step 1: Get pre-approved" |

Application: Provide at least 2-3 paths to any important content. Never assume there's only one way users think about your content.

### 6. Principle of Focused Navigation

Each navigation system should serve one purpose. Don't mix:
- Primary actions with settings
- Content categories with tools
- Different content types in the same list

Application: If a navigation mixes "Buy a home" with "Advertise with us," it's serving two audiences in one nav.

### 7. Principle of Growth

Design for 10x the current content volume.

| Current State | Growth Question |
|---------------|----------------|
| 5 categories | What happens at 50? |
| 100 listings | What happens at 10,000? |
| 3 content types | What happens with 15? |
| 1 market | What happens in 50 markets? |

Application: Test your IA with extreme content volumes. If navigation breaks at scale, redesign now.

### 8. Principle of Front Doors

Nearly 50% of users enter a site from a page other than the homepage (via search engines, shared links, bookmarks).

Every page must:
- Communicate where the user is (breadcrumbs, active nav states)
- Provide access to global navigation
- Show the site/app identity
- Allow the user to orient themselves

Application: Never design a page assuming users arrived from the homepage.

## LATCH Framework (Deep Dive)

### Location

Organizing by physical or virtual position.

Strengths:
- Intuitive for spatial content (real estate, travel, retail)
- Supports map-based interfaces
- Natural for comparing nearby items

Weaknesses:
- Requires geographic data
- Not useful for abstract content
- Can be disorienting without context (zoom level, boundaries)

Zillow application: Map-based search is the primary discovery pattern. Location is the dominant organization scheme for listings.

### Alphabet

Ordering from A to Z.

Strengths:
- Universal, no learning curve
- Works for reference content (glossaries, directories)
- Scalable — works at any size

Weaknesses:
- Requires knowing the name of what you're looking for
- No semantic grouping (related items may be far apart)
- Poor for discovery/browsing

When to use: Contact lists, glossaries, index pages, brand directories. Avoid as primary organization for content meant to be browsed.

### Time

Ordering chronologically or sequentially.

Strengths:
- Natural for events, news, activity feeds
- Supports "what's new" and "what's next" mental models
- Good for workflows with steps

Weaknesses:
- Older content gets buried
- Not useful when recency isn't important
- Can feel overwhelming with high-frequency updates

Zillow application: "New listings" sort, price history timelines, activity feeds in agent tools.

### Category

Grouping by shared attributes or themes.

Strengths:
- Supports browsing and discovery
- Aligns with user mental models when categories match
- Scalable with subcategories

Weaknesses:
- Category names must be clear and mutually exclusive
- Items may belong to multiple categories (cross-listing problem)
- Requires user research to validate groupings

Zillow application: Property types (house, condo, townhouse, land), listing status (for sale, pending, sold), home features (pool, garage, waterfront).

### Hierarchy

Ordering by magnitude — size, price, popularity, importance, rating.

Strengths:
- Natural for comparison shopping
- Supports "best of" and "most relevant" patterns
- Enables sorting and ranking

Weaknesses:
- Requires quantifiable attributes
- "Best" is subjective — whose hierarchy?
- Can bias toward extreme values

Zillow application: Price sort, Zestimate ranking, popularity-based recommendations, "hot homes" designation.

## Mental Models

A mental model is the user's internal understanding of how a system works. IA succeeds when it matches user mental models.

### Common Mismatches

| Company Model | User Model | Result |
|---------------|------------|--------|
| Org chart structure | Task-based grouping | Users can't find features |
| Technical architecture | Simple categories | Confusing labels |
| Business unit silos | Unified experience | Duplicate content, inconsistent nav |

### How to Discover Mental Models

1. **Card sorting** — how users naturally group content
2. **Interviews** — ask "where would you expect to find X?"
3. **Search analytics** — what terms do users search for?
4. **Support tickets** — what can't users find?
5. **Competitor analysis** — what patterns are users trained on?

### Matching Mental Models

- Use user language, not internal jargon
- Group by task, not by department
- Test with real users before building
- Monitor search queries for findability failures
