# Cora AI Assistant

GPT-4o-mini powered natural language interface for the Lead Audit Tool. Streams responses via SSE.

## Architecture

```
User message → Query classification → Data retrieval → System prompt injection → GPT-4o-mini streaming → SSE response
```

- **Endpoint:** `POST /api/cora/chat`
- **Model:** `gpt-4o-mini` via Replit AI Integrations (`AI_INTEGRATIONS_OPENAI_API_KEY`, `AI_INTEGRATIONS_OPENAI_BASE_URL`)
- **Streaming:** `AsyncGenerator` yields `{type, data}` chunks as SSE events
- **File:** `server/services/coraAssistant.ts`

## Query Classification Priority

Queries are classified in this order (mutually exclusive via `else if`):

1. **Count/Analytics** — Triggered by: "how many", "count", "number of", "total", "report", "analytics", "trend", "summary", "stats", "metrics"
2. **Lead Search** — Triggered by: "search", "find", "look up", "customer", "lead"
3. **Property Details** — Triggered by: "property", "price", "bedroom", "sqft", "listing" (requires `currentLead` context)

This ordering prevents "how many unselected **leads**..." from being classified as a search.

## Filter Parsing (`parseFiltersFromQuery`)

Extracts structured filters from natural language. Located at `coraAssistant.ts`.

### Supported Filters
- **Intent:** Buy, Sell, Rent, NewCon, Finance
- **Brand:** Zillow, Trulia, StreetEasy, HotPads
- **LOB:** ZHL, Connections
- **Quality:** Passed, Spam, Threshold, Deny List
- **Classification:** Selected, Unselected
- **BARS:** Yes, No, No Response
- **MAR:** Yes, No
- **Subcategory:** Flex, Premier Agent, Agent Profile, Exclusive/MyAgent, Connections Plus
- **Pearl Disposition:** Connected, Not Interested, No Answer, Busy, Voicemail, Wrong Number, Non Arc Ready, Callback Requested
- **Result:** Connected, No Answer, Rejected, Busy, Voicemail, Pending
- **Transacted:** Detected by keywords "transacted", "transaction", "closed deal"

### Date Range Parsing
- Specific dates: "on 1/15/2026", "for 3/1"
- Date ranges: "1/26 thru 1/28", "from Jan 15 to Jan 20", "between 2/1 and 2/15/2026"
- Relative: "today", "yesterday", "last 7 days", "last week", "this week"
- Month/year: "January 2026", "in 2025"
- ISO format: "2026-01-15 to 2026-01-20"

## Search Query Extraction

For lead search, Cora extracts the search term using this priority:

1. Email regex match
2. Phone number regex match
3. UUID regex match (full or partial)
4. Lead ID pattern (`[LZP]\d{5}`)
5. Stop-word filtering — removes common words ("search", "find", "for", "lead", etc.) and uses remaining words

Search function `searchLeadsForCora()` tries Databricks first, falls back to local PostgreSQL.

## Analytics Queries

When Databricks is configured, `queryDatabricksAnalytics()` builds dynamic SQL:

- Applies `WHERE` clauses from parsed filters (intent, brand, date range, etc.)
- Uses `COUNT(DISTINCT lead_id)` for accurate counts
- Handles ZHL leads separately via the ZHL table
- Transaction queries use `INNER JOIN` with `matched_transactions` + `LATERAL VIEW EXPLODE`
- Returns `{totalLeads, byIntent, byQuality, byResult, byDisposition, conversionRate, transactionCount, source}`

## PII Redaction

Before sending lead data to the LLM, `redactLeadForAI()` strips sensitive fields:
- Names: "John Smith" → "John ***"
- Excluded: raw email, phone, full address
- Included: leadId, intent, brand, classification, leadQuality, bars, mar, result, pearlDisposition

## Clickable Lead Links

Cora formats lead references as `[[LEAD:LeadID]]` in its responses. The frontend `CoraAssistant.tsx` parses these into clickable links that navigate to `/lead/:leadId`.

## Property Lookup

When a user is viewing a specific lead, Cora can fetch property details:
1. Constructs Zillow URL from lead's property address
2. Fetches HTML with browser User-Agent
3. Parses JSON-LD, meta tags, and regex patterns for: price, bedrooms, bathrooms, sqft, year built, lot size
4. Falls back to providing the Zillow link if fetch fails

## Context Injection

All retrieved data (search results, analytics, property info) is appended to the system prompt as `contextData` before the GPT-4o-mini call. The model then formulates a response using this data.

## Suggested Actions

Based on query type, Cora returns suggested next actions:
- After search: "View lead details", "Search for another customer"
- After analytics: "View different time period", "Add more filters"
- No results: "Try a different search", "View analytics"
