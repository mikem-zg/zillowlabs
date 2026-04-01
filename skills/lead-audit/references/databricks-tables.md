# Databricks Tables Inventory

22 tables across 6 schemas used by the Lead Audit Tool.

## Primary Lead Data

### 1. `premier_agent.leads_gold.fact_leads`
- **Purpose:** Main leads table — primary search and detail source
- **Config:** `DATABRICKS_LEADS_TABLE` env var
- **Key columns:** `lead_id`, `sender.*` (name, email, phone), `recipient.*` (agent info), `property.*` (address, city, state, zip), `quality.*`, `create_dt`, `update_dt`, `brand`, `contact_form_type`, `listing_type`, `pa_type`
- **Aliases:** When joined with metrics, uses `f.` prefix

### 2. `premier_agent.leads_gold.fact_pa_submits_enriched_metrics`
- **Purpose:** Lead metrics — BARS response, connection status, work-with indicators
- **Config:** `DATABRICKS_METRICS_TABLE` env var
- **Key columns:** `lead_id`, `bars_yes`, `bars_no`, `pearl_status`, `non_arc_disposition`
- **Join:** `LEFT JOIN` on `f.lead_id = m.lead_id`

## Fallback Lead Sources

### 3. `connections_platform.leads_platform.lead_event_v1`
- **Purpose:** Secondary lead source when lead not found in `fact_leads`
- **Hardcoded:** Not env-configured
- **Structure:** Uses nested JSON structs: `sender`, `recipient`, `property`, `capture`, `quality`, `buy`
- **Parsing:** Requires `safeParseStruct()` to extract nested fields
- **Select columns:** `lead_id`, `create_dt`, `update_dt`, `brand`, `lob`, `status`, `sender`, `recipient`, `property`, `capture`, `quality`, `buy`

### 4. `mortgage.zhl_lead_gold.zhl_lead_loan_funnel`
- **Purpose:** ZHL/Finance leads (third-tier fallback)
- **Hardcoded:** Not env-configured
- **Key columns:** `sf_lead_id` (mapped to `leadId`), `l3_lead_id`, `lo_name`, `loan_status`
- **Nested structs:** `agent`, `assignment`, `connect`, `lead`, `loan`, `pearl`, `submit`, `prequal_response`, `current_lead_source_hierarchy`
- **Notes:** No `zhl_lead_id` column; uses `sf_lead_id` as primary key

## Agent & Enrichment

### 5. `premier_agent.agent_gold.dim_flex_agents`
- **Purpose:** Agent details — name, team, phone, performance tier
- **Config:** `DATABRICKS_AGENT_TABLE` env var
- **Key columns:** `account_id`, `buyside_agent_cvr`, `current_target`, `performance_tier_current`
- **Lookup:** By `recipient_account_id` from lead data

### 6. `premier_agent.connections_gold.fact_my_agent_relationship_snapshot`
- **Purpose:** MAR (My Agent Relationship) status
- **Config:** `DATABRICKS_MAR_TABLE` env var
- **Key columns:** `lead_id`, `mar_status`, `destruction_source`

## Pearl / Concierge Tables

All under the schema configured by `DATABRICKS_CONCIERGE_SCHEMA` env var.

### 7. `${schema}.bc_lead_lead_event`
- **Purpose:** Lead-to-case mapping, consumer IDs
- **Key columns:** `lead_id`, `case_id`, `consumer_id`, `lead_agent_id`

### 8. `${schema}.bc_communication_store_sms`
- **Purpose:** Pearl SMS conversations
- **Key columns:** `case_id`, `sender_name`, `message`, `created_at`, `persona_type`
- **Note:** `persona_type=0` = concierge rep (Pearl), `persona_type=1` = agent (ZIMS)

### 9. `${schema}.bc_case_concierge_cases`
- **Purpose:** Concierge case details
- **Key columns:** `case_id`, `disposition`, `outcome`

### 10. `${schema}.bc_case_case_disposition_map`
- **Purpose:** Disposition label mapping (ID → human-readable text)

## Unified Conversations (communications silver)

Three channels, each with three tables (9 tables total):

### SMS Channel (11-13)
- `communications.sms_silver.participants`
- `communications.sms_silver.conversations`
- `communications.sms_silver.messages`

### Voice Channel (14-16)
- `communications.voice_silver.participants`
- `communications.voice_silver.conversations`
- `communications.voice_silver.messages`

### Chat Channel (17-19)
- `communications.chat_silver.participants`
- `communications.chat_silver.conversations`
- `communications.chat_silver.messages`

**Lookup pattern:** Participants by phone (SMS/Voice) or ZUID (Chat) → conversation IDs → messages. All three channels queried in parallel.

## Voice Transcripts

### 20. `communications.voice_silver.call_transcriptions`
- **Purpose:** Full voice call transcripts with metadata
- **Metadata query:** Matches `external_number` in multiple formats (raw digits, formatted, tel: URI) and `mapped_ids["lead_id"]`
- **Transcript query:** `call_id` → returns `channel`, `speaker`, `content.segment`, `start_time`, `end_time`, `confidence`
- **Note:** Lazy-loaded per individual call (not bulk)

## Routing

### 21. `touring.lead_tracing.program_eligibility`
- **Purpose:** Program eligibility for leads (Flex, PA, etc.)
- **Hardcoded:** Not env-configured

## Transactions

### 22. `customer.transactions.matched_transactions`
- **Purpose:** Matched real estate transactions linked to leads
- **Hardcoded:** Not env-configured
- **Key columns:** `transaction_id`, `transaction_side` (Buy/Sell), `close_date`, `zpid`
- **Join pattern:** `LATERAL VIEW EXPLODE(pa_lead_metadata) t AS lead_meta` then `lead_meta.pa_lead_id = ?`

## Environment Variables

| Variable | Required | Purpose |
|----------|----------|---------|
| `DATABRICKS_HOST` | Yes | Warehouse hostname |
| `DATABRICKS_TOKEN` | Yes | Auth token (secret) |
| `DATABRICKS_HTTP_PATH` | Yes | SQL warehouse HTTP path |
| `DATABRICKS_LEADS_TABLE` | Yes | Primary leads table name |
| `DATABRICKS_METRICS_TABLE` | No | Metrics table for JOIN |
| `DATABRICKS_AGENT_TABLE` | No | Agent dimension table |
| `DATABRICKS_MAR_TABLE` | No | MAR snapshot table |
| `DATABRICKS_CONCIERGE_SCHEMA` | No | Pearl/concierge schema prefix |
