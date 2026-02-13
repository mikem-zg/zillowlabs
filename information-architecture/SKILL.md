---
name: information-architecture
description: Expert in organizing, structuring, and labeling digital content for findability and usability. Use when designing navigation systems, building taxonomies, structuring content hierarchies, conducting IA research (card sorting, tree testing), modeling content types, or making decisions about how information should be grouped and presented. Includes Zillow-specific IA Northstar strategy.
---

# Information Architecture

Specialized knowledge for organizing and structuring digital information so users can find what they need and complete their goals. Covers foundational IA theory, research methods, navigation design, content modeling, and Zillow's specific IA strategy.

## When to Use

- Designing or restructuring site/app navigation
- Building taxonomies, categorization schemes, or labeling systems
- Planning card sorting or tree testing research
- Modeling content types, metadata, and relationships
- Evaluating findability and information scent
- Making decisions about grouping, hierarchy, or progressive disclosure
- Working on Zillow IA Northstar or Housing Super App features
- Creating sitemaps, user flows, or IA documentation

## Core Frameworks

### LATCH (Richard Saul Wurman)

All information can be organized in exactly five ways:

| Method | Description | Example |
|--------|-------------|---------|
| **Location** | By geography or physical/virtual position | Store locator, map-based search |
| **Alphabet** | A-Z ordering | Directory, glossary, contact list |
| **Time** | Chronological or sequential | News feed, timeline, calendar |
| **Category** | Grouped by shared attributes | Product types, topic areas |
| **Hierarchy** | Ordered by magnitude | Price high-to-low, most popular |

Combine methods for power: Zillow uses Location + Category + Hierarchy (map + property type + price).

### Dan Brown's 8 Principles

| Principle | Rule |
|-----------|------|
| **Objects** | Treat content as living objects with attributes and lifecycles |
| **Choices** | Limit options to prevent decision paralysis |
| **Disclosure** | Show only what's needed at each step (progressive disclosure) |
| **Exemplars** | Use examples and previews to describe categories |
| **Multiple Classification** | Offer multiple paths to the same content |
| **Focused Navigation** | Don't mix different content types in one navigation |
| **Growth** | Design structures that accommodate 10x content expansion |
| **Front Doors** | Assume users enter from any page, not just the homepage |

### Typography Hierarchy for IA

| Level | Purpose | Navigation Role |
|-------|---------|-----------------|
| **L1** | App/site identity | Global navigation, logo |
| **L2** | Primary sections | Main nav tabs, mega menu categories |
| **L3** | Sub-sections | Sidebar nav, breadcrumb segments |
| **L4** | Content groups | Card titles, list headers |
| **L5** | Individual items | Body text, metadata labels |

## Zillow IA Quick Reference

### Housing Super App — Five Pillars

| Pillar | Function | Key Metric |
|--------|----------|------------|
| **Search** | Find and filter properties | Engagement, saved searches |
| **Find** | Discover neighborhoods, schools, commute | Time on platform |
| **Tour** | Schedule and manage property tours | Tour conversion rate |
| **Finance** | Affordability, pre-approval, mortgage | ZHL attachment rate |
| **Buy** | Offer, negotiate, close transaction | Transaction completion |

### Unified Navigation Scheme (IA Northstar)

| Tab | Maps To | Purpose |
|-----|---------|---------|
| **Search** | Search pillar | Property discovery and filtering |
| **Plan** | Find + Finance | Saved homes, affordability tools, neighborhood research |
| **Next Steps** | Tour + Buy | Active transaction management, touring, closing |
| **Inbox** | Global Inbox | All communications — agent messages, alerts, updates |
| **Account** | Profile | Settings, preferences, saved searches |

### User Personas

| Persona | Type | Mental Model |
|---------|------|-------------|
| **Beth** | Consumer | "I want to find my home" — emotional, journey-driven |
| **Alan** | Professional | "I need to manage my business" — efficiency-driven |

### Core Principles (IA Northstar)

1. **Simple and usable** — reduce cognitive load at every step
2. **Aim for exponential value** — each feature compounds with others
3. **Support all life's chapters** — buying, selling, renting, refinancing
4. **Connection to real people** — surface agents and loan officers contextually
5. **Cross-platform consistency** — same IA on web, iOS, Android

## Routing Dimensions

Use these to route questions to the right reference material:

- `domain`: `foundations`, `research_methods`, `navigation`, `content_modeling`, `zillow_strategy`, `deliverables`
- `task`: `organize`, `label`, `navigate`, `research`, `model`, `evaluate`, `document`
- `method`: `card_sorting`, `tree_testing`, `content_audit`, `competitive_analysis`, `sitemap`, `user_flow`
- `framework`: `latch`, `dan_brown`, `faceted`, `taxonomy`, `ontology`
- `zillow_pillar`: `search`, `find`, `tour`, `finance`, `buy`

## Question Types This Skill Handles

- "How should I organize [content type] for [audience]?"
- "What's the best navigation pattern for [use case]?"
- "How do I run a card sort / tree test for [project]?"
- "What taxonomy should I use for [domain]?"
- "How does Zillow's IA Northstar apply to [feature]?"
- "What content model do I need for [product]?"
- "Should I use faceted search or hierarchical navigation?"
- "How do I structure this for scalability?"

## Decision Trees

### Choosing an Organization Scheme

```
Is content location-dependent?
├─ Yes → Location-based (maps, geo-filters)
├─ No → Is there a natural sequence?
│  ├─ Yes → Time-based (chronological, steps)
│  ├─ No → Are items comparable by magnitude?
│     ├─ Yes → Hierarchy (price, rating, popularity)
│     ├─ No → Do clear groupings exist?
│        ├─ Yes → Category-based (types, topics)
│        └─ No → Alphabetical (last resort)
```

### Choosing a Navigation Pattern

```
How many top-level sections?
├─ 3-5 → Tab bar or horizontal nav
├─ 6-10 → Mega menu or sidebar
├─ 10+ → Faceted navigation + search
│
How deep is the hierarchy?
├─ 2-3 levels → Breadcrumbs sufficient
├─ 4+ levels → Sidebar + breadcrumbs + local nav
│
Is content highly filterable?
├─ Yes → Faceted search (left sidebar desktop, drawer mobile)
├─ No → Standard hierarchical navigation
```

### Choosing a Research Method

```
Starting from scratch?
├─ Yes → Open card sorting (generate categories)
├─ No → Have proposed structure?
│  ├─ Yes → Tree testing (validate findability)
│  ├─ No → Have categories but unsure of labels?
│     └─ Closed card sorting (validate groupings)
│
Need both exploration and validation?
└─ Hybrid card sorting → then tree testing
```

## Reference Files

| File | Contents |
|------|----------|
| `references/foundations.md` | Dan Brown's principles deep dive, LATCH details, mental models, organization schemes |
| `references/research-methods.md` | Card sorting, tree testing, content audits, competitive analysis — step-by-step |
| `references/navigation-patterns.md` | Global nav, breadcrumbs, mega menus, faceted search, mobile patterns |
| `references/content-modeling.md` | Taxonomy, ontology, metadata schemas, content types, scalability |
| `references/zillow-ia-strategy.md` | Housing Super App, IA Northstar, Strategy Stack, unified navigation, personas |
| `references/deliverables.md` | Sitemaps, wireframes, user flows, taxonomy docs, IA documentation templates |
