# Zillow IA Strategy

## The Housing Super App

Zillow is executing a strategic pivot from a media-centric aggregation model to a transaction-centric operating system. The "Housing Super App" represents a fundamental reimagining of how housing data is structured, accessed, and acted upon.

The underlying domain model is transitioning from a static repository of "For Sale" listings to a dynamic, stateful graph of user intentions, financial capabilities, and logistical events.

### Five Pillars

| Pillar | Description | Strategic Goal |
|--------|-------------|----------------|
| **Search** | Property discovery and filtering | Engagement depth, saved search creation |
| **Find** | Neighborhood, school, commute research | Time on platform, informed decision-making |
| **Tour** | Scheduling and managing property tours | Tour-to-transaction conversion |
| **Finance** | Affordability, pre-approval, Zillow Home Loans | ZHL attachment rate, mortgage origination |
| **Buy** | Offer, negotiate, close the transaction | End-to-end transaction completion |

The pillars represent a progression from passive browsing to active transacting. IA decisions should support this progression, not create dead ends.

### Strategic Metrics

- Double Zillow's share of housing market transactions from 3% to 6%
- Increase "Enhanced Market" connections from 21% to 35%
- Grow Zillow Home Loans attachment rate
- Increase tour-to-offer conversion

## The Strategy Stack

The Strategy Stack is Zillow's framework for prioritizing what information and features to surface. It determines hierarchy of content.

From top (highest priority) to bottom:

1. **Active transaction** — user currently buying/selling/renting
2. **Financial readiness** — pre-approval, affordability, mortgage
3. **Active search** — saved searches, alerts, recently viewed
4. **Discovery** — browsing, neighborhood research, market trends
5. **Education** — guides, articles, how-to content

IA implication: when a user has an active transaction, that state should dominate navigation (Next Steps tab). When browsing, Search and Plan tabs are primary.

## IA Northstar Initiative (2024-2027)

A multi-year strategic undertaking that provides the blueprint for how Zillow organizes its digital ecosystem.

### Core Principles

| Principle | Meaning | IA Impact |
|-----------|---------|-----------|
| **Simple and usable** | Reduce cognitive load at every step | Fewer nav items, progressive disclosure, clear labels |
| **Aim for exponential value** | Each feature compounds with others | Cross-linking between pillars, contextual suggestions |
| **Support all life's chapters** | Buying, selling, renting, refinancing | Unified nav that adapts to user's current journey |
| **Connection to real people** | Surface agents and loan officers contextually | People-centric content alongside property content |
| **Cross-platform consistency** | Same IA on web, iOS, Android | Unified navigation scheme, responsive patterns |

### Unified Navigation Scheme

The IA Northstar defines five primary navigation tabs:

| Tab | Maps to Pillars | Content | User State |
|-----|----------------|---------|------------|
| **Search** | Search | Property search, map, filters, results | All users |
| **Plan** | Find + Finance | Saved homes, affordability tools, neighborhood research, pre-approval | Users with intent |
| **Next Steps** | Tour + Buy | Active tour management, offer status, closing timeline, agent communication | Active transactors |
| **Inbox** | Cross-cutting | Agent messages, listing alerts, price change notifications, system updates | All authenticated users |
| **Account** | Cross-cutting | Profile, settings, saved searches, notification preferences | All authenticated users |

### Key Design Decisions

**Plan tab** — consolidates what was previously scattered across Saved Homes, My Zillow, and Home Loans into a unified planning workspace. Users can see saved properties alongside their financial readiness.

**Next Steps** (formerly Home Loans) — renamed to reflect broader transaction management. Surfaces touring, financing, and closing in one place. Only prominent when user has active transaction state.

**Global Inbox** — centralizes all communications. Previously, agent messages, alerts, and notifications were in separate areas. Unified inbox reduces missed communications and supports the "connection to real people" principle.

## User Personas

### Beth (Consumer)

| Dimension | Detail |
|-----------|--------|
| **Mental model** | "I want to find my home" |
| **Journey** | Dreaming → Exploring → Deciding → Transacting → Settling |
| **Key need** | Emotional connection + practical information |
| **IA priority** | Easy discovery, clear next steps, financial transparency |
| **Navigation pattern** | Search-first, then Plan, then Next Steps as journey progresses |

Beth's journey is not linear. She may oscillate between Dreaming and Exploring for months. IA must support non-linear exploration without losing her place.

### Alan (Professional)

| Dimension | Detail |
|-----------|--------|
| **Mental model** | "I need to manage my business efficiently" |
| **Journey** | Lead capture → Nurture → Tour → Transaction → Post-close |
| **Key need** | Speed, organization, client management |
| **IA priority** | Dashboard-centric, task-oriented, minimal clicks |
| **Navigation pattern** | Inbox-first (lead alerts), then client management tools |

Alan needs a different IA surface than Beth. Professional tools should not clutter consumer navigation, and vice versa. The "One Zillow" philosophy means the same platform, but contextually adapted.

### The Co-Shopping Dynamic

"Mike and Maria" — housing decisions are rarely individual. Zillow recognizes the "Household Entity" where multiple users (partners, family members) collaborate on the same transaction.

IA implications:
- Shared saved lists and notes
- Collaborative filtering (what both of you liked)
- Household-level financial view
- Shared inbox for transaction communications

## Key IA Concepts

### Fluidity

Users move fluidly between stages (Dreaming → Transacting) and between roles (buyer → seller). IA must support:
- State-aware navigation that adapts to user's current journey phase
- Smooth transitions between sections without losing context
- Multiple active journeys (buying a new home while selling current home)

### BuyAbility

Zillow's concept for real-time affordability signals integrated throughout the search experience. Rather than separating "search" from "finance," BuyAbility embeds financial context directly into property cards and search results.

IA implication: financial information is not a separate section — it's a layer on top of search results.

### Smart Link

Contextual connection between search activity and recommended next steps. When a user saves properties, Smart Link surfaces relevant next actions (get pre-approved, schedule a tour, connect with agent).

IA implication: navigation is not just structural hierarchy — it's also behavioral, adapting to what the user has done.

### Enhanced Market

Markets where Zillow has deep agent and lending partnerships, enabling the full transaction flow. IA in Enhanced Markets surfaces more transaction features; in non-Enhanced Markets, IA focuses on search and discovery.

## Constellation Design System

The design system enforces IA consistency across all platforms:

- **ProX Theme** for professional (agent-facing) tools — efficiency-focused, data-dense
- **Consumer Theme** for homebuyers/renters — emotional, discovery-focused
- **Generative UI** — emerging pattern where AI generates interface components contextually
- **Modular Architecture** — micro-frontends allow independent navigation modules

### IA Consistency Rules

- Same navigation labels across web, iOS, Android
- Same hierarchy of information across platforms
- Responsive adaptation (not separate mobile IA)
- Design tokens enforce spacing, typography, and layout consistency
- Component library enforces interaction patterns

## User Memory and Personalization

The "User Memory" engine tracks user behavior to adapt IA:

| Signal | IA Adaptation |
|--------|---------------|
| **Saved searches** | Surface relevant listings proactively |
| **Viewed properties** | Show "recently viewed" and similar properties |
| **Pre-approval status** | Promote Next Steps tab, show BuyAbility |
| **Tour history** | Surface tour-related next steps |
| **Search patterns** | Adapt filter defaults and sort orders |
| **Journey stage** | Shift navigation emphasis (Search → Plan → Next Steps) |

Personalization should enhance the existing IA, not replace it. The base structure remains consistent — personalization adjusts emphasis and defaults.
