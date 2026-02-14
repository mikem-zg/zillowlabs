---
name: agent-data-api
description: "Query the Zillow Agent Data API for agent profiles, team rosters, and performance metrics. Covers Profile endpoints (agent lookup by ZUID/email, team members, custom lists, all teams) and Performance endpoints (current KPIs, historical trends, team/custom-list aggregations). Includes auth via API key, error handling, caching strategy, and TypeScript/curl examples."
---

# Agent Data API

Query agent profiles and performance metrics from the Zillow Agent Data API.

**Base URL:** `https://agent-data-api.zillowlabs.com/api/v1/`
**Auth:** API key via `X-API-Key` header (server-to-server) or verified Origin (browser)
**API Key env var:** `ZILLOW_LABS_API_KEY` — contact Mike Messenger to obtain one

## Authentication

```bash
# Header (recommended)
curl -H "X-API-Key: $ZILLOW_LABS_API_KEY" \
  https://agent-data-api.zillowlabs.com/api/v1/profile/agent/1168

# Query parameter (alternative)
curl "https://agent-data-api.zillowlabs.com/api/v1/profile/agent/1168?api_key=$ZILLOW_LABS_API_KEY"
```

**NEVER** hardcode API keys in client-side code. Make API calls from your backend.

## Profile Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/profile/agent/:identifier` | GET | Agent by ZUID or email (smart detection: `@` → email) |
| `/profile/agent/:agentZuid/team` | GET | Team roster for an agent |
| `/profile/team/:teamZuid` | GET | All members of a team |
| `/profile/custom-agent-list` | POST | Bulk lookup (body: `{ "zuids": [1168, 546] }`, max 1000) |
| `/teams` | GET | All teams (optional `?marketOps=true\|false`) |

### Quick Example — Agent Lookup

```typescript
const res = await fetch(
  `https://agent-data-api.zillowlabs.com/api/v1/profile/agent/${zuid}`,
  { headers: { 'X-API-Key': process.env.ZILLOW_LABS_API_KEY! } }
);
const agent = await res.json();
// { zuid, firstName, lastName, fullName, email, teamRole, profilePictureUrl, ... }
```

### Quick Example — Custom Agent List

```typescript
const res = await fetch(
  'https://agent-data-api.zillowlabs.com/api/v1/profile/custom-agent-list',
  {
    method: 'POST',
    headers: {
      'X-API-Key': process.env.ZILLOW_LABS_API_KEY!,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ zuids: [1168, 546, 29301] }),
  }
);
const { members, member_count } = await res.json();
```

## Performance Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/performance/agent/:zuid/current` | GET | Latest KPIs for an agent |
| `/performance/agent/:zuid/history` | GET | Full 12-month performance history |
| `/performance/team/:teamZuid/current` | GET | Current KPIs for all team members |
| `/performance/custom-agent-list/current` | POST | Current KPIs for custom ZUID list |
| `/performance/custom-agent-list/history` | POST | Historical KPIs for custom ZUID list |

### Key Performance Fields

| Field | Type | Description |
|-------|------|-------------|
| `total_score` | string | Overall performance score |
| `performance_tier` | string | "Fair", "Good", "Excellent" |
| `rank` | string | Rank within team |
| `total_cxn_l30d` | string | Connections last 30 days |
| `buyside_agent_cvr` | string | Buy-side conversion rate |
| `answer_rate_l90` | string | Answer rate last 90 days |
| `desired_cxns` | integer? | Desired connection capacity |

All numeric values returned as strings to preserve precision.

### Quick Example — Agent Performance

```typescript
const res = await fetch(
  `https://agent-data-api.zillowlabs.com/api/v1/performance/agent/${zuid}/current`,
  { headers: { 'X-API-Key': process.env.ZILLOW_LABS_API_KEY! } }
);
const { performance } = await res.json();
// { total_score, performance_tier, rank, total_cxn_l30d, buyside_agent_cvr, ... }
```

## Error Handling

All errors return a consistent shape:

```json
{
  "success": false,
  "error": "ERROR_CODE",
  "message": "Human-readable message",
  "statusCode": 400
}
```

| Code | Status | Meaning |
|------|--------|---------|
| `PROFILE_NOT_FOUND` | 404 | No profile for ZUID/email |
| `AGENT_NOT_FOUND` | 404 | No performance data for ZUID |
| `TEAM_NOT_ASSIGNED` | 404 | Agent has no team |
| `INVALID_ZUID` | 400 | ZUID is not a valid number |
| `VALIDATION_ERROR` | 400 | Bad request body |

## Caching

| Data | TTL |
|------|-----|
| Agent profile | 1 hour |
| Team profile | 10 minutes |
| Performance current | 10 minutes |
| Performance history | 1 hour |

## Best Practices

1. Validate ZUIDs are integers before calling endpoints
2. Use team/custom-list endpoints to batch requests — avoid per-agent loops
3. Respect cache TTLs to reduce load
4. Always use `/api/v1/` versioned paths
5. Store `ZILLOW_LABS_API_KEY` as a secret env var, never in client code

## Data Freshness

- **Profiles (`agent_profile`):** Snapshots, 1M+ records, updated via scheduled jobs
- **Performance (`agent_data`):** Rolling 12-month window. Recent 3 months sampled on days 1, 8, 15, 22. Older months day 1 only. ~604K records.

---

## Detailed Reference

- **Full endpoint documentation**: See [references/api-reference.md](references/api-reference.md)
- Covers: complete response schemas, all URL/body/query parameters, curl examples, performance data field catalog
