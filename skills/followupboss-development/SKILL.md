---
name: followupboss-development
description: "Build production-ready Follow Up Boss applications. Covers the complete FUB REST API (v1), OAuth 2.0 authorization, webhooks, embedded apps, and the Python SDK. Includes copy-paste project templates for TypeScript and Python with authentication, lead submission via Events, People CRUD, webhook handling, and deployment patterns."
---

# Follow Up Boss App Development Guide

Build applications that integrate with Follow Up Boss (FUB), the leading real estate CRM. This skill covers the complete FUB REST API, OAuth 2.0 authorization, webhooks, embedded apps, and production deployment.

## When to Use This Skill

- Building integrations that send leads into Follow Up Boss
- Creating apps that read/write FUB contacts, deals, notes, tasks
- Setting up webhook consumers for real-time FUB event processing
- Building embedded apps that display inside the FUB UI
- Connecting IDX websites, lead sources, or marketing tools to FUB

## API Overview

**Base URL:** `https://api.followupboss.com/v1/`
**Protocol:** HTTPS only (HTTP will not work)
**Auth:** HTTP Basic Auth (API key) or OAuth 2.0 Bearer tokens
**Rate Limits:** Sliding 10-second window, 250 req/10s global (with system key)

### System Registration (Required for Service Providers)

Every app that accesses FUB on behalf of customers MUST register at https://apps.followupboss.com/system-registration to get:
- `X-System` header — your system name
- `X-System-Key` header — your system key

These headers are required on EVERY API request alongside the user's API key.

### Core Resources

| Resource | Endpoint | Key Operations |
|----------|----------|----------------|
| **Events** | `/v1/events` | Send leads (PREFERRED for lead ingestion) |
| **People** | `/v1/people` | Contact CRUD, search, tags, stages |
| **Notes** | `/v1/notes` | Add/read notes on contacts |
| **Tasks** | `/v1/tasks` | Create/manage follow-up tasks |
| **Deals** | `/v1/deals` | Track real estate transactions |
| **Appointments** | `/v1/appointments` | Schedule showings/meetings |
| **Webhooks** | `/v1/webhooks` | Register event callbacks |
| **Users** | `/v1/users` | List agents/team members |
| **Teams** | `/v1/teams` | Team structures |
| **Custom Fields** | `/v1/customFields` | Account custom fields |
| **Pipelines** | `/v1/pipelines` | Sales pipelines |
| **Stages** | `/v1/stages` | Pipeline stages |
| **Smart Lists** | `/v1/smartLists` | Dynamic contact lists |
| **Action Plans** | `/v1/actionPlans` | Automated workflows |
| **Identity** | `/v1/identity` | Current user/account info |

## Development Workflow

### Phase 1: Setup

1. **Create a trial FUB account** at https://app.followupboss.com/signup (14-day free trial, request extension at product@followupboss.com for dev accounts)
2. **Generate an API key** in Admin → API (copy immediately — shown only once)
3. **Register your system** at https://apps.followupboss.com/system-registration
4. **Store credentials securely** — API key as env var `FUB_API_KEY`, system key as `FUB_SYSTEM_KEY`

### Phase 2: Build — Send Your First Lead

The Events endpoint is the PREFERRED way to send leads into FUB. It handles deduplication, triggers action plans, assigns agents via Lead Flow, and records events in the contact timeline.

```bash
curl -X POST https://api.followupboss.com/v1/events \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "source": "MyWebsite.com",
    "system": "YourSystem",
    "type": "General Inquiry",
    "message": "Looking for a house under $500k in East Boston",
    "person": {
      "firstName": "John",
      "lastName": "Smith",
      "emails": [{"value": "john@example.com"}],
      "phones": [{"value": "555-555-5555"}]
    }
  }'
```

**Status codes:** `200` = event created + person updated, `201` = event created + new person created, `204` = lead flow archived/ignored.

**Event types that trigger action plans:** `Registration`, `Seller Inquiry`, `Property Inquiry`, `General Inquiry`, `Visited Open House`.

### Phase 3: Integrate — Add Webhooks & Real-Time Processing

Register webhooks to receive real-time notifications when contacts, deals, or tasks change in FUB.

```bash
curl -X POST https://api.followupboss.com/v1/webhooks \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "event": "peopleCreated",
    "url": "https://yourapp.com/webhooks/fub/people-created"
  }'
```

**Requirements:** Only the account owner can manage webhooks. Max 2 webhooks per event per system. Callback URLs must be HTTPS. Respond within 10 seconds with 2XX.

### Phase 4: Deploy

1. **Secure your credentials** — never expose API keys in client-side code or URLs
2. **Handle rate limits** — monitor `X-RateLimit-Remaining` header, back off on 429
3. **Use cursor pagination** — prefer `next` parameter over `offset` for deep pagination
4. **Validate webhook signatures** — verify `FUB-Signature` header with HMAC SHA256
5. **Handle retries gracefully** — FUB retries failed webhooks 5 times over 8 hours

## Critical Rules

1. **ALWAYS use `/v1/events` to send leads** — never `/v1/people` (misses automations, dedup, agent assignment)
2. **ALWAYS include X-System and X-System-Key headers** — required for all requests
3. **NEVER expose API keys in client-side code** — use server-side proxy
4. **NEVER use API keys in webhook callback URLs** — use opaque identifiers
5. **ALWAYS respond to webhooks within 10 seconds** — decouple receipt from processing
6. **ALWAYS use HTTPS** — HTTP requests will fail
7. **Source/sourceUrl can only be set on person creation** — cannot be changed via PUT

## Reference Documents

📁 **API Endpoints**: [reference/api-endpoints.md](reference/api-endpoints.md) — Complete endpoint reference with request/response formats
📁 **Authentication**: [reference/authentication.md](reference/authentication.md) — API key auth, OAuth 2.0 flow, permission levels
📁 **Webhooks**: [reference/webhooks.md](reference/webhooks.md) — All webhook events, registration, signature verification, retry logic
📁 **Embedded Apps**: [reference/embedded-apps.md](reference/embedded-apps.md) — Building apps inside the FUB UI
📁 **Best Practices**: [reference/best-practices.md](reference/best-practices.md) — Rate limiting, pagination, error handling, pitfalls

## Example Templates

📁 **TypeScript Template**: [examples/typescript-template.md](examples/typescript-template.md) — Express server with FUB API client, webhook handler, lead submission
📁 **Python Template**: [examples/python-template.md](examples/python-template.md) — Flask server with follow-up-boss SDK, webhook handler, pagination

## Quick Reference — Authentication

```typescript
// TypeScript — Basic Auth
const response = await fetch('https://api.followupboss.com/v1/people?limit=10', {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': SYSTEM_KEY,
  },
});

// TypeScript — OAuth Bearer
const response = await fetch('https://api.followupboss.com/v1/people?limit=10', {
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'X-System': 'YourSystem',
    'X-System-Key': SYSTEM_KEY,
  },
});
```

```python
# Python — Basic Auth
import requests
response = requests.get(
    'https://api.followupboss.com/v1/people',
    auth=(API_KEY, ''),
    headers={'X-System': 'YourSystem', 'X-System-Key': SYSTEM_KEY},
    params={'limit': 10}
)

# Python — Using follow-up-boss SDK
from follow_up_boss import FollowUpBossApiClient
client = FollowUpBossApiClient(
    api_key=API_KEY,
    x_system='YourSystem',
    x_system_key=SYSTEM_KEY
)
people = client.people.get_all()
```
