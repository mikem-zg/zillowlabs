# Content Modeling

## Taxonomy

A hierarchical classification system that organizes concepts into parent-child relationships. Taxonomies provide standardized terminology for tagging, categorization, and navigation.

### Types

| Type | Structure | Example |
|------|-----------|---------|
| **Flat** | Single-level list of terms | Tags: "new listing," "open house," "price drop" |
| **Hierarchical** | Parent-child tree structure | Property > Residential > Single Family > Detached |
| **Faceted** | Multiple independent dimensions | Type + Location + Price + Status (combinable) |
| **Network/Polyhierarchical** | Items in multiple parent categories | A "townhouse" under both "Residential" and "Attached" |

### Building a Taxonomy

**Step 1: Gather terms**
- Extract from existing content, labels, navigation
- Collect from user research (search queries, card sorts)
- Review competitor and industry terminology

**Step 2: Normalize terminology**
- Choose one preferred term per concept
- Document synonyms and variants
- Decide on singular vs plural, abbreviations, capitalization

**Step 3: Build hierarchy**
- Group related terms under parent concepts
- Aim for 5-9 children per parent (cognitive limits)
- Limit depth to 3-4 levels for user-facing taxonomy
- Ensure mutual exclusivity where possible

**Step 4: Validate**
- Card sort with users to test groupings
- Tree test to verify findability
- Review with subject matter experts
- Test edge cases (where does X go?)

### Rules

| Rule | Rationale |
|------|-----------|
| **Mutually exclusive** | Each item should clearly belong to one category (or use facets) |
| **Collectively exhaustive** | Every item should have a home |
| **Consistent depth** | Similar categories should have similar depth |
| **User language** | Use terms users know, not internal jargon |
| **Evolvable** | Plan for new terms and categories |

## Ontology

Goes beyond taxonomy by defining not just concepts but relationships between them. Ontologies model how entities interact, enabling richer connections.

### Taxonomy vs Ontology

| Aspect | Taxonomy | Ontology |
|--------|----------|----------|
| **Structure** | Hierarchical (parent-child) | Graph (entity-relationship) |
| **Relationships** | "is a type of" only | Multiple relationship types |
| **Complexity** | Simple to build and maintain | Complex, requires governance |
| **Use case** | Navigation, categorization | Knowledge graphs, AI, search |
| **Example** | "Condo is a type of Property" | "Condo is-a Property, has-a HOA, located-in Building, managed-by Association" |

### When to Use Ontology

- Content has complex, multi-dimensional relationships
- Building knowledge graphs or AI-powered features
- Need semantic search beyond keyword matching
- Integrating data from multiple systems with different schemas
- Enterprise-scale content with cross-system relationships

### Real Estate Ontology Example

```
Property
├─ is-a → Listing (when on market)
├─ has → Address (location relationship)
├─ has → Features (pool, garage, etc.)
├─ has → Price History (temporal relationship)
├─ associated-with → Agent (listing agent)
├─ associated-with → Brokerage
├─ located-in → Neighborhood
│   └─ part-of → City → State → Country
├─ near → School, Transit, Shopping
└─ comparable-to → Other Properties (comp relationship)
```

## Metadata Schema Design

Metadata is the structured data that describes, classifies, and enables findability of content objects.

### Types of Metadata

| Type | Purpose | Examples |
|------|---------|---------|
| **Descriptive** | What the content is about | Title, description, tags, category |
| **Administrative** | Content management | Author, created date, last modified, status, owner |
| **Technical** | System behavior | File format, size, encoding, URL slug |
| **Structural** | Content relationships | Parent page, related items, sort order |
| **Use** | User interaction data | Views, downloads, saves, shares |

### Designing a Metadata Schema

For each content type, define:

1. **Required fields** — must be filled for content to publish
2. **Optional fields** — enhance content but not mandatory
3. **Auto-generated fields** — system-created (date, URL, ID)
4. **Controlled vocabulary fields** — must use approved terms
5. **Free-text fields** — open input (title, description)

### Example: Property Listing Metadata

| Field | Type | Required? | Controlled? |
|-------|------|-----------|-------------|
| **Address** | Structured (street, city, state, zip) | Yes | Validated |
| **Price** | Currency | Yes | No |
| **Property type** | Enum | Yes | Yes (taxonomy) |
| **Bedrooms** | Integer | Yes | No |
| **Bathrooms** | Float | Yes | No |
| **Square footage** | Integer | Yes | No |
| **Listing status** | Enum | Yes | Yes (for sale, pending, sold) |
| **Description** | Free text | Yes | No |
| **Photos** | Media array | Yes (min 1) | No |
| **Features** | Multi-select | No | Yes (taxonomy) |
| **Year built** | Integer | No | No |
| **HOA fees** | Currency | No | No |
| **MLS number** | String | Yes | System-generated |
| **Listing date** | Date | Yes | Auto-generated |
| **Agent** | Reference | Yes | Linked entity |

## Content Types

A content type defines the structure and attributes of a class of content objects.

### Defining Content Types

| Question | Purpose |
|----------|---------|
| What is this type of content? | Name and description |
| What fields does it have? | Attribute list with data types |
| What are the required fields? | Minimum viable content |
| How does it relate to other types? | Relationships (parent, reference, embedded) |
| What are the display contexts? | Where and how is it shown (card, detail, list) |
| What actions can users take? | Save, share, compare, contact |
| What's the lifecycle? | Draft → Review → Published → Archived |

### Relationship Types

| Relationship | Description | Example |
|-------------|-------------|---------|
| **Parent-child** | Hierarchical containment | Section → Page |
| **Reference** | Linked but independent | Listing → Agent profile |
| **Embedded** | Content within content | Article → Image gallery |
| **Peer** | Same level, related | Listing → Comparable listings |
| **Sequential** | Ordered series | Step 1 → Step 2 → Step 3 |

## Scalability Considerations

### Content Growth Patterns

| Pattern | Challenge | Solution |
|---------|-----------|----------|
| **Volume growth** | More items in existing categories | Faceted navigation, search, pagination |
| **Type growth** | New content types added | Flexible schemas, modular templates |
| **Depth growth** | More levels of hierarchy | Breadcrumbs, local nav, progressive disclosure |
| **Attribute growth** | More metadata fields | Progressive disclosure, "advanced" sections |
| **Audience growth** | More user segments | Personalization, role-based navigation |

### Design for Scale

1. **Use facets over fixed categories** — facets scale infinitely
2. **Separate structure from presentation** — content model independent of display
3. **Modular content** — reusable components over monolithic pages
4. **API-first** — content accessible across platforms and channels
5. **Governance** — who can create content types, add taxonomy terms, modify schemas
