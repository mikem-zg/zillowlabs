# Agent Data API — Complete Endpoint Reference

## Base URL

```
https://agent-data-api.zillowlabs.com/api/v1/{namespace}/{entity}/{id}/{view}
```

## Authentication

### API Key (Server-to-Server)

Store as environment variable:
```bash
ZILLOW_LABS_API_KEY=your_api_key_here
```

**Header (recommended):**
```bash
curl -H "X-API-Key: $ZILLOW_LABS_API_KEY" \
  https://agent-data-api.zillowlabs.com/api/v1/profile/agent/1168
```

**Query parameter:**
```bash
curl "https://agent-data-api.zillowlabs.com/api/v1/profile/agent/1168?api_key=$ZILLOW_LABS_API_KEY"
```

### Browser-Based Requests

Requests from verified domains are auto-authenticated via Origin header. Contact your administrator to add domains.

**NEVER** hardcode API keys in client-side code.

---

## Profile Namespace

### GET /api/v1/profile/agent/:identifier

Get profile for a specific agent by ZUID or email.

**URL Parameters:**
- `identifier` (number or string, required): Agent ZUID (e.g., `1168`) or email (e.g., `greg.markov@example.com`)

**Smart Detection:** Contains `@` → email lookup (case-insensitive). No `@` → ZUID lookup.

**Cache:** 1 hour (3600s)

**Examples:**
```bash
GET /api/v1/profile/agent/1168
GET /api/v1/profile/agent/greg.markov@example.com
```

**Response:**
```json
{
  "zuid": 1168,
  "firstName": "Greg",
  "lastName": "Markov",
  "fullName": "Greg Markov",
  "email": "greg.markov@example.com",
  "teamRole": "Agent",
  "profilePictureUrl": "https://photos.zillowstatic.com/fp/example-profile-photo-h_l.jpg",
  "additionalEmails": ["alternate@example.com"],
  "additionalPhones": ["+1-555-0100"],
  "marketOpsMarketPartner": "Market Partner Name",
  "metadata": {},
  "importedAt": "2024-01-15T10:30:00.000Z",
  "sourceTable": "agent_profile"
}
```

**Errors:**
- `404 PROFILE_NOT_FOUND` — no profile for the specified ZUID or email
- `400 INVALID_ZUID` — ZUID is not a valid number

---

### GET /api/v1/profile/agent/:agentZuid/team

Get team roster for an agent (resolves team automatically).

**URL Parameters:**
- `agentZuid` (number, required)

**Cache:** 10 minutes (600s)

**Response:**
```json
{
  "team_zuid": 1168,
  "member_count": 5,
  "members": [
    {
      "zuid": 1168,
      "firstName": "Greg",
      "lastName": "Markov",
      "fullName": "Greg Markov",
      "email": "greg.markov@example.com",
      "teamRole": "Team Lead",
      "profilePictureUrl": "https://photos.zillowstatic.com/fp/example-profile-photo-h_l.jpg",
      "additionalEmails": ["alternate@example.com"],
      "additionalPhones": ["+1-555-0100"],
      "marketOpsMarketPartner": "Market Partner Name",
      "metadata": {},
      "snapshotDate": "2024-01-15",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

**Errors:**
- `404 AGENT_PROFILE_NOT_FOUND` — no profile for the agent
- `404 TEAM_NOT_ASSIGNED` — agent has no team
- `400 INVALID_ZUID` — not a valid number

---

### GET /api/v1/profile/team/:teamZuid

Get all members of a team by team lead ZUID.

**URL Parameters:**
- `teamZuid` (number, required): The team lead's ZUID

**Cache:** 10 minutes (600s)

**Response:**
```json
{
  "team_zuid": 1168,
  "member_count": 1,
  "members": [
    {
      "zuid": 1168,
      "firstName": "Greg",
      "lastName": "Markov",
      "fullName": "Greg Markov",
      "email": "greg.markov@example.com",
      "teamRole": "Team Lead",
      "profilePictureUrl": "https://photos.zillowstatic.com/fp/example-profile-photo-h_l.jpg",
      "additionalEmails": ["alternate@example.com"],
      "additionalPhones": ["+1-555-0100"],
      "marketOpsMarketPartner": "Market Partner Name",
      "metadata": {},
      "importedAt": "2024-01-15T10:30:00.000Z",
      "sourceTable": "agent_profile"
    }
  ]
}
```

**Errors:**
- `400 INVALID_TEAM_ZUID` — not a valid number

---

### POST /api/v1/profile/custom-agent-list

Get profiles for a custom list of agents.

**Request Body:**
```json
{
  "zuids": [1168, 546, 29301]
}
```

**Body Parameters:**
- `zuids` (number[], required): Agent ZUIDs (min: 1, max: 1000)

**Response:**
```json
{
  "member_count": 3,
  "members": [
    {
      "zuid": 1168,
      "firstName": "Greg",
      "lastName": "Markov",
      "fullName": "Greg Markov",
      "email": "greg.markov@example.com",
      "teamRole": "Agent",
      "teamZuid": 69922393,
      "teamName": "Example Team",
      "profilePictureUrl": "https://photos.zillowstatic.com/fp/example-profile-photo-h_l.jpg",
      "additionalEmails": ["alternate@example.com"],
      "additionalPhones": ["+1-555-0100"],
      "marketOpsMarketPartner": "Market Partner Name",
      "metadata": {},
      "snapshotDate": "2024-01-15",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

**curl:**
```bash
curl -X POST \
  -H "X-API-Key: $ZILLOW_LABS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"zuids": [1168, 546, 29301]}' \
  https://agent-data-api.zillowlabs.com/api/v1/profile/custom-agent-list
```

**Errors:**
- `400 VALIDATION_ERROR` — missing zuids, invalid format, or out of range

---

### GET /api/v1/teams

List all unique teams. Supports filtering by market ops status.

**Query Parameters:**
- `marketOps` (boolean, optional): `true` = market ops only, `false` = non-market-ops only, omitted = all

**Cache:** 1 hour (3600s)

**Examples:**
```bash
GET /api/v1/teams
GET /api/v1/teams?marketOps=true
GET /api/v1/teams?marketOps=false
```

**Response:**
```json
{
  "teams": [
    {
      "parent_zuid": 12345678,
      "team_name": "Example Team Alpha",
      "market_ops_market_partner": true
    },
    {
      "parent_zuid": 87654321,
      "team_name": "Example Team Beta",
      "market_ops_market_partner": false
    }
  ],
  "count": 2398,
  "filter": {
    "marketOps": null
  }
}
```

**curl:**
```bash
curl -H "X-API-Key: $ZILLOW_LABS_API_KEY" \
  "https://agent-data-api.zillowlabs.com/api/v1/teams?marketOps=true"
```

---

## Performance Namespace

### GET /api/v1/performance/agent/:zuid/current

Get the latest performance data for an agent.

**URL Parameters:**
- `zuid` (number, required)

**Cache:** 10 minutes (600s)

**Response:**
```json
{
  "agent_zuid": 546,
  "team_lead_zuid": 69922393,
  "performance": {
    "agent_zuid": "546",
    "agent_name": "John Smith",
    "team_lead_zuid": "69922393",
    "rank": "5",
    "total_score": "125.45",
    "performance_tier": "Excellent",
    "total_cxn_l30d": "15",
    "buyside_agent_cvr": "0.075",
    "desired_cxns": 20,
    "desired_cxns_last_update": "2024-01-15",
    "agent_performance_date": "2024-01-22"
  },
  "importedAt": "2024-01-15T10:30:00.000Z",
  "sourceTable": "agent_data"
}
```

**Errors:**
- `404 AGENT_NOT_FOUND` — no performance data for ZUID
- `400 INVALID_ZUID` — not a valid number

---

### GET /api/v1/performance/agent/:zuid/history

Get complete performance history for an agent (all historical records).

**URL Parameters:**
- `zuid` (number, required)

**Cache:** 1 hour (3600s)

**Response:**
```json
{
  "agentZuid": 546,
  "totalRecords": 15,
  "history": [
    {
      "performanceDate": "2024-01-01",
      "data": {},
      "teamLeadZuid": 69922393,
      "importedAt": "2024-01-15T10:30:00.000Z",
      "sourceTable": "agent_data"
    }
  ]
}
```

**Errors:**
- `404 PERFORMANCE_NOT_FOUND` — no history for ZUID
- `400 INVALID_ZUID` — not a valid number

---

### GET /api/v1/performance/team/:teamZuid/current

Get current performance data for all team members.

**URL Parameters:**
- `teamZuid` (number, required): Team lead's ZUID

**Cache:** 10 minutes (600s)

**Response:**
```json
{
  "team_lead_zuid": 69922393,
  "agent_count": 83,
  "agents": [
    {
      "agent_zuid": 546,
      "team_lead_zuid": 69922393,
      "performance": {},
      "importedAt": "2024-01-15T10:30:00.000Z",
      "sourceTable": "agent_data"
    }
  ]
}
```

**Errors:**
- `400 INVALID_TEAM_ZUID` — not a valid number

---

### POST /api/v1/performance/custom-agent-list/current

Get current performance for a custom list of agents.

**Request Body:**
```json
{
  "zuids": [546, 29301, 32206]
}
```

**Body Parameters:**
- `zuids` (number[], required): Agent ZUIDs (min: 1, max: 1000)

**Response:**
```json
{
  "agent_count": 3,
  "agents": [
    {
      "agent_zuid": 546,
      "team_lead_zuid": 69922393,
      "performance": {},
      "importedAt": "2024-01-15T10:30:00.000Z",
      "sourceTable": "agent_data"
    }
  ]
}
```

**curl:**
```bash
curl -X POST \
  -H "X-API-Key: $ZILLOW_LABS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"zuids": [546, 29301, 32206]}' \
  https://agent-data-api.zillowlabs.com/api/v1/performance/custom-agent-list/current
```

**Errors:**
- `400 VALIDATION_ERROR` — invalid body

---

### POST /api/v1/performance/custom-agent-list/history

Get performance history for a custom list of agents.

**Request Body:**
```json
{
  "zuids": [546, 29301]
}
```

**Body Parameters:**
- `zuids` (number[], required): Agent ZUIDs (min: 1, max: 1000)

**Response:**
```json
{
  "agent_count": 2,
  "total_records": 23,
  "agents": [
    {
      "agent_zuid": 546,
      "record_count": 15,
      "history": [
        {
          "performanceDate": "2024-01-01",
          "data": {},
          "teamLeadZuid": 69922393,
          "importedAt": "2024-01-15T10:30:00.000Z",
          "sourceTable": "agent_data"
        }
      ]
    }
  ]
}
```

**curl:**
```bash
curl -X POST \
  -H "X-API-Key: $ZILLOW_LABS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"zuids": [546, 29301]}' \
  https://agent-data-api.zillowlabs.com/api/v1/performance/custom-agent-list/history
```

**Errors:**
- `400 VALIDATION_ERROR` — invalid body

---

## Performance Data Fields

All numeric values returned as strings to preserve precision except where noted.

### Agent Identification

| Field | Type | Description |
|-------|------|-------------|
| `agent_zuid` | string | Agent's unique identifier |
| `agent_name` | string | Agent's full name |
| `team_lead_zuid` | string | Team lead's ZUID |

### Performance Metrics

| Field | Type | Description |
|-------|------|-------------|
| `rank` | string | Rank within team |
| `total_score` | string | Overall performance score |
| `performance_tier` | string | "Fair", "Good", "Excellent" |
| `internal_tier` | string | Internal tier classification |

### Engagement Metrics

| Field | Type | Description |
|-------|------|-------------|
| `total_cxn_l7d` | string | Connections last 7 days |
| `total_cxn_l30d` | string | Connections last 30 days |
| `total_cxn_mtd` | string | Month-to-date connections |
| `answer_rate_l90` | string | Answer rate last 90 days |
| `pickup_rate_l90` | string | Pickup rate last 90 days |

### Conversion Metrics

| Field | Type | Description |
|-------|------|-------------|
| `buyside_agent_cvr` | string | Buy-side conversion rate |
| `cvr_pct_to_market` | string | Conversion rate vs. market |
| `agent_etr` | string | Engagement-to-transaction ratio |
| `bayesian_etr` | string | Bayesian ETR |

### Capacity Management

| Field | Type | Description |
|-------|------|-------------|
| `desired_cxns` | integer (nullable) | Desired connection capacity target |
| `desired_cxns_last_update` | date (nullable) | Last updated date |

---

## Error Format

All errors follow this structure:

```json
{
  "success": false,
  "error": "ERROR_CODE",
  "message": "Human-readable error message",
  "statusCode": 400
}
```

### Error Codes

| Code | Status | Meaning |
|------|--------|---------|
| `PROFILE_NOT_FOUND` | 404 | Profile not found for ZUID/email |
| `AGENT_PROFILE_NOT_FOUND` | 404 | No agent profile found |
| `AGENT_NOT_FOUND` | 404 | No performance data for ZUID |
| `PERFORMANCE_NOT_FOUND` | 404 | No performance history |
| `TEAM_NOT_ASSIGNED` | 404 | Agent not assigned to a team |
| `INVALID_ZUID` | 400 | ZUID not a valid number |
| `INVALID_TEAM_ZUID` | 400 | Team ZUID not a valid number |
| `VALIDATION_ERROR` | 400 | Request validation failed |

---

## Caching Strategy

| Data | TTL | Notes |
|------|-----|-------|
| Agent profile | 1 hour | Stable data, infrequent changes |
| Team profile | 10 minutes | Members may change |
| Performance current | 10 minutes | Near-real-time KPIs |
| Performance history | 1 hour | Historical, immutable |

Cached responses include cache headers. Cache can be bypassed using appropriate cache headers.

---

## Data Sync

### Agent Profiles (`agent_profile`)
- Latest snapshot of all agent information
- 1M+ records with automatic batching
- Updated via scheduled jobs

### Performance Data (`agent_data`)
- Rolling 12-month window
- Recent 3 months: days 1, 8, 15, 22 sampled
- Older months: day 1 only
- ~604,428 current records

---

## TypeScript Helper

```typescript
const AGENT_API_BASE = 'https://agent-data-api.zillowlabs.com/api/v1';

async function agentApi<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${AGENT_API_BASE}${path}`, {
    ...options,
    headers: {
      'X-API-Key': process.env.ZILLOW_LABS_API_KEY!,
      'Content-Type': 'application/json',
      ...options?.headers,
    },
  });
  if (!res.ok) {
    const err = await res.json();
    throw new Error(`${err.error}: ${err.message}`);
  }
  return res.json();
}

// Usage
const agent = await agentApi('/profile/agent/1168');
const team = await agentApi('/profile/agent/1168/team');
const perf = await agentApi('/performance/agent/546/current');
const bulk = await agentApi('/profile/custom-agent-list', {
  method: 'POST',
  body: JSON.stringify({ zuids: [1168, 546] }),
});
```

---

## Best Practices

1. **Validate ZUIDs** are integers before calling endpoints
2. **Batch requests** — use team/custom-list endpoints instead of per-agent loops
3. **Respect cache TTLs** to reduce server load
4. **Always use versioned paths** (`/api/v1/`)
5. **Store API key as secret** — never in client code or version control
6. **Handle errors gracefully** — check `success` field and error codes
7. **Parse numeric strings** — performance values are strings, parse as needed

---

## Environment Variables

| Variable | Purpose | How to Obtain |
|----------|---------|---------------|
| `ZILLOW_LABS_API_KEY` | Server-to-server auth | Contact Mike Messenger |
