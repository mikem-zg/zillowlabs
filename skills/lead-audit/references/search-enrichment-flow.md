# Search & Enrichment Flow

## Search Flow

### API Endpoint
`GET /api/leads/search?q={query}&months={lookback}`

### Identifier Detection
The search system auto-detects query type via regex:

| Pattern | Type | SQL Strategy |
|---------|------|-------------|
| `[0-9a-f]{8}-...` | Full UUID | Exact `lead_id` match |
| `[0-9a-f]{8,}` | Partial UUID | `lead_id LIKE '%query%'` |
| `user@domain.com` | Email | `LOWER(sender_email) = LOWER(query)` |
| `\d{10}` | Phone | `regexp_replace(phone, '[^0-9]', '') LIKE '%digits%'` |
| `[LZP]\d{5}` | Legacy ID | Exact match |
| Other | Name/text | `LOWER(sender_name) LIKE '%query%'` |

### Multi-Source Search (UUID queries)
When searching by UUID, all three sources fire in parallel:

```
Promise.all([
  searchFactLeads(query),      // Primary
  searchLeadEventV1(query),    // Fallback
  searchZhlLeads(query)        // ZHL
])
```

First source to return results wins. Results are deduplicated by `lead_id`.

### Text Search
Name/text queries only hit the primary `fact_leads` table with `LIMIT 50` and `ORDER BY create_dt DESC`.

### Column Optimization
- Primary search uses `buildSearchLightSelectColumns()` — only columns needed for search results display
- `lead_event_v1` fallback uses `buildLeadEventV1SelectColumns()` — 12 specific columns instead of `SELECT *`

## Predictive Search (Suggestions)

### API Endpoint
`GET /api/leads/suggest?q={query}`

- Fires after 2+ characters typed
- Returns up to 8 suggestions
- Shows name, brand, intent, and lead ID prefix
- Uses same Databricks-first, PostgreSQL-fallback pattern

## Lead Retrieval

### API Endpoint
`GET /api/leads/{leadId}`

### Retrieval Priority
1. **Server LRU cache** — Check if lead already cached (never downgrades `enriched=true` entries)
2. **Databricks `fact_leads`** — Primary lookup by exact `lead_id`
3. **Databricks `lead_event_v1`** — Fallback with optional concierge JOIN for `consumer_id`/`case_id`
4. **Databricks ZHL table** — Third-tier for Finance/ZHL leads
5. **Local PostgreSQL** — Final fallback

### Request Timeout
45 seconds on the Express route handler.

## Enrichment Flow

### API Endpoint
`GET /api/leads/{leadId}/enriched`

### Progressive Loading Pattern
The frontend loads lead data in two stages:

1. **Base load** — Quick fetch of core lead fields (< 3s typical)
2. **Enrichment** — Separate request that runs parallel enrichment tasks

### Parallel Enrichment Tasks
`enrichDatabricksLead()` uses `Promise.allSettled()` with individual timeouts:

```
timedEnrich("agent", enrichLeadWithAgentPerformance(...), 10000)
timedEnrich("mar", enrichLeadWithMarStatus(...), 10000)
timedEnrich("bars", enrichLeadWithBarsPercentile(...), 10000)
timedEnrich("conversations", enrichLeadWithConversations(...), 15000)
timedEnrich("eligibility", enrichLeadWithProgramEligibility(...), 10000)
```

Each task can fail independently without blocking others.

### Enrichment Details

#### Agent Performance (`enrichLeadWithAgentPerformance`)
- **Input:** `recipient_account_id` from lead
- **Query:** `SELECT * FROM dim_flex_agents WHERE account_id = ?`
- **Adds:** `agentName`, agent CVR, target, performance tier

#### MAR Status (`enrichLeadWithMarStatus`)
- **Input:** `lead_id`
- **Query:** `SELECT mar_status, destruction_source FROM fact_my_agent_relationship_snapshot WHERE lead_id = ? ORDER BY snapshot_date DESC LIMIT 1`
- **Adds:** `mar` field (YES/NO)

#### BARS Percentile (`enrichLeadWithBarsPercentile`)
- **Input:** `lead_id`
- **Query:** Against metrics table for percentile and model version
- **Adds:** BARS percentile score

#### Pearl Conversations (`enrichLeadWithConversations`)
- **Flow:** `lead_id` → `bc_lead_lead_event` (get `case_id`) → `bc_communication_store_sms` (get messages) + `bc_case_concierge_cases` (get disposition)
- **Adds:** `pearlConversation`, `pearlDisposition`, `pearlOutcome`, `pearlCaseId`

#### Program Eligibility (`enrichLeadWithProgramEligibility`)
- **Query:** `SELECT * FROM touring.lead_tracing.program_eligibility WHERE lead_id = ?`
- **Adds:** Program eligibility flags

## Unified Conversations

### API: Part of enrichment (not a separate endpoint)
Aggregates conversations across three channels by querying in parallel:

```
Promise.all([
  fetchChannelConversations("sms_silver", phoneNumber),
  fetchChannelConversations("voice_silver", phoneNumber),
  fetchChannelConversations("chat_silver", zuid)
])
```

Each channel query joins: `participants` → `conversations` → `messages`

### ZUID Discovery
If ZUID not present on the lead, attempts to find it via `bc_lead_lead_event.consumer_id`.

## Voice Calls & Transcripts

### Metadata: `GET /api/voice-calls?phone={phone}&leadId={leadId}`
- Queries `call_transcriptions` matching `external_number` in multiple formats
- Also matches `mapped_ids["lead_id"]`
- Returns call metadata without transcript content
- 30s timeout

### Transcript: `GET /api/voice-calls/{callId}/transcript`
- Lazy-loaded per individual call
- Returns segments: `{channel, speaker, content, startTime, endTime, confidence}`
- Client-side caching after first load

## Matched Transactions

### API Endpoint
`GET /api/leads/{leadId}/transactions`

- **Query:** Uses `LATERAL VIEW EXPLODE(pa_lead_metadata)` to unnest the lead-to-transaction mapping
- **Returns:** `transactionId`, `transactionSide` (Buy/Sell), `closeDate`, `zpid`
- Lazy-loaded separately from main lead data

## Caching Strategy

### Server-Side LRU Cache
- **Size:** 200 entries max
- **TTL:** 5 minutes
- **Key:** `lead_id`
- **Rule:** Never overwrites `enriched=true` with `enriched=false`
- **Eviction:** Only on new key insert when at capacity

### Client-Side (React Query)
- **staleTime:** `Infinity` (global default)
- **Key patterns:** `['/api/leads', id]` for hierarchical invalidation
- Voice transcripts cached after first load per `callId`

## Databricks Warehouse Management
- Keep-warm ping every 8 minutes to prevent cold starts
- Health check: `GET /api/databricks/status`
- Cold start polling with configurable timeout
