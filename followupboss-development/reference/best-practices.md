# Follow Up Boss API Best Practices

## Rate Limiting

Follow Up Boss uses a sliding 10-second window for rate limiting.

### Default Limits WITH Valid X-System-Key

| Context | Limit | Endpoints | Method |
|---------|-------|-----------|--------|
| POST.events | unlimited* | /v1/events | POST |
| events | 20 | /v1/events | GET |
| global | 250 | ALL | ALL |
| PUT.people | 25 | /v1/people | PUT |
| notes | 10 | /v1/notes | ALL |

*Unlimited POST events is subject to fair use and capacity constraints.

### WITHOUT Valid X-System-Key

| Context | Limit |
|---------|-------|
| events | 10 |
| global | 125 |

### Rate Limit Response Headers

Every API response includes these headers:

| Header | Description |
|--------|-------------|
| `X-RateLimit-Limit` | Maximum requests allowed in the current window |
| `X-RateLimit-Remaining` | Requests remaining in the current window |
| `X-RateLimit-Window` | Window duration in seconds (10) |
| `X-RateLimit-Context` | Which rate limit context applies to this request |

### Handling 429 Responses

- HTTP `429 Too Many Requests` includes a `Retry-After` header (seconds to wait)
- You MAY receive 429 even when `X-RateLimit-Remaining > 0` due to server capacity issues
- Always implement exponential backoff or honor `Retry-After`
- To request higher limits, email api@followupboss.com

### Rate Limit Handling Example

```typescript
async function requestWithRetry(fn: () => Promise<Response>, maxRetries = 3): Promise<Response> {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    const response = await fn();
    if (response.status === 429) {
      const retryAfter = parseInt(response.headers.get('Retry-After') || '10', 10);
      console.warn(`Rate limited. Retrying after ${retryAfter}s (attempt ${attempt + 1}/${maxRetries})`);
      await new Promise(resolve => setTimeout(resolve, retryAfter * 1000));
      continue;
    }
    return response;
  }
  throw new Error('Max retries exceeded due to rate limiting');
}
```

---

## Pagination

- Default limit: **10**, max limit: **100**, default offset: **0**
- Resources are returned in **descending order by ID** (newest first)

### Two Pagination Methods

1. **Cursor-based (RECOMMENDED):** Use the `_metadata.next` parameter from the response
2. **Offset-based:** Use the `offset` query parameter

Deep pagination is enforced to use cursor (`next`) instead of `offset`. If you attempt deep offset-based pagination, the API will return an error directing you to use cursor pagination.

### _metadata Response Format

```json
{
  "_metadata": {
    "collection": "people",
    "offset": 0,
    "limit": 100,
    "total": 1523,
    "next": "eyJpZCI6MTIzNDV9",
    "nextLink": "https://api.followupboss.com/v1/people?limit=100&next=eyJpZCI6MTIzNDV9"
  }
}
```

### Smart Lists

For Smart Lists (using `listId` parameter), cursor pagination is automatic. The API returns results in the Smart List's sort order.

### Cursor Pagination Example (Python)

```python
results = []
params = {'limit': 100}
while True:
    response = client.get('/v1/people', params=params)
    data = response.json()
    results.extend(data.get('people', []))
    next_cursor = data.get('_metadata', {}).get('next')
    if not next_cursor:
        break
    params = {'limit': 100, 'next': next_cursor}
```

### Cursor Pagination Example (TypeScript)

```typescript
async function getAllPeople(client: FUBClient, params: Record<string, any> = {}): Promise<any[]> {
  const results: any[] = [];
  let requestParams = { limit: 100, ...params };

  while (true) {
    const data = await client.getPeople(requestParams);
    results.push(...(data.people || []));
    const next = data._metadata?.next;
    if (!next) break;
    requestParams = { limit: 100, next };
  }

  return results;
}
```

---

## Error Handling

| Status Code | Meaning | Action |
|-------------|---------|--------|
| 200 | Success | Process response normally |
| 201 | Created | New resource created (e.g., new person via events) |
| 204 | No Content | Lead flow archived — event was received but no person created/updated |
| 400 | Bad Request | Check request body/params for errors |
| 401 | Unauthorized | API key is invalid or missing |
| 403 | Forbidden | Insufficient permissions or expired/suspended account |
| 404 | Not Found | Resource doesn't exist — check the ID |
| 429 | Rate Limited | Check `Retry-After` header and wait before retrying |
| 500 | Server Error | FUB internal error — retry with backoff |

### Important: Handle 204 for Events

When posting events, a `204` response means the lead flow has archived/ignored the event. This is NOT an error — the event was received but the lead flow rules decided not to create or update a person. Your application should handle this gracefully.

---

## Custom Fields

- Custom field names are prefixed with `custom` (e.g., `customClosingDate`, `customLoanAmount`)
- Use `GET /v1/customFields` to see all available custom fields for the account
- When reading people, custom fields are NOT included by default — use `fields=allFields` query parameter to include them

```bash
GET /v1/people/123?fields=allFields
```

### Deal Commission Fields

Deal commission fields (`commissionValue`, `agentCommission`, `teamCommission`) are **TOP-LEVEL** fields on the deal object, NOT custom fields. Do not put them inside a `custom_fields` object.

```json
{
  "name": "123 Main St Sale",
  "personId": 456,
  "commissionValue": 15000,
  "agentCommission": 7500,
  "teamCommission": 7500
}
```

---

## Contact Deduplication

### Events Endpoint (Automatic)

The Events endpoint automatically deduplicates contacts by email or phone number. If a person with the same email or phone already exists, the event is attached to the existing person rather than creating a duplicate.

### People Endpoint (Manual)

When creating people directly via `POST /v1/people`, use the `deduplicate=true` query parameter to enable deduplication:

```bash
POST /v1/people?deduplicate=true
```

### Force-Matching

Provide `person.id` in the Events payload to force-match an existing contact, bypassing email/phone matching:

```json
{
  "source": "MyApp",
  "type": "General Inquiry",
  "person": {
    "id": 12345,
    "firstName": "John"
  }
}
```

---

## Action Plan Triggers

### Event Types That Trigger Action Plans

Only these event types trigger action plans:
- `Registration`
- `Seller Inquiry`
- `Property Inquiry`
- `General Inquiry`
- `Visited Open House`

### Event Types That Trigger Automations

Only these trigger automations:
- `Registration`
- `Property Inquiry`
- `Seller Inquiry`
- `General Inquiry`

### Inquiry Auto-Conversion

The generic `Inquiry` type automatically converts to:
- `Property Inquiry` — if a `property` section is included in the event
- `General Inquiry` — if no `property` section is included

---

## Common Pitfalls

1. **Using `POST /v1/people` instead of `POST /v1/events` for leads** — Events handles deduplication, action plans, lead flow assignment, and timeline recording. People endpoint does none of this.

2. **Not including `X-System` / `X-System-Key` headers** — Without these headers, your rate limits are significantly lower (125 global vs 250, 10 events vs 20).

3. **Putting commission fields in `custom_fields` instead of top-level** — `commissionValue`, `agentCommission`, and `teamCommission` are top-level deal fields.

4. **Not URL-encoding `redirect_uri` in OAuth flow** — The redirect URI must be properly URL-encoded when passed as a query parameter.

5. **Expecting `source` / `sourceUrl` to be updatable via PUT** — These fields can only be set on person creation. PUT requests will silently ignore these fields.

6. **Not handling 204 responses** — When posting events, 204 means the lead flow archived/ignored the event. This is a valid response, not an error.

7. **Blocking webhook handlers with slow processing (10s timeout)** — Webhook callbacks must respond within 10 seconds. Decouple receipt (immediate 200 response) from processing (async/queue).

8. **Using API keys in webhook callback URLs** — Never put API keys in URLs. Use opaque identifiers or verify webhook signatures instead.

9. **Not using `fields=allFields` when needing custom field data** — Custom fields are excluded from people responses by default. You must explicitly request them.

10. **Assuming calendar-synced appointments trigger webhooks** — Only appointments created via the FUB API or UI trigger webhooks. Calendar-synced appointments do NOT trigger webhooks.

---

## Data Model Tips

- **People** can have multiple emails, phones, and addresses — these are arrays, not single values:
  ```json
  {
    "emails": [{"value": "john@example.com"}, {"value": "john.work@company.com"}],
    "phones": [{"value": "555-1234", "type": "mobile"}],
    "addresses": [{"street": "123 Main St", "city": "Boston", "state": "MA"}]
  }
  ```

- **Tags** are string arrays: `["buyer", "hot-lead", "east-boston"]`

- **Stage** is a string value — use `GET /v1/stages` to get valid stage values for the account

- **`assignedTo`** (string, user's name) vs **`assignedUserId`** (integer, user's ID) — prefer `assignedUserId` for reliability since names can change

- **Collaborators** are arrays of user IDs: `[123, 456]`

- **Historical events** — events with `occurredAt` more than 1 day in the past do NOT trigger workflows or action plans

---

## Webhook Best Practices

### Respond Quickly
```typescript
app.post('/webhooks/fub', (req, res) => {
  res.status(200).send('OK');
  processWebhookAsync(req.body).catch(console.error);
});
```

### Verify Signatures
Always verify the `FUB-Signature` header using HMAC SHA256 with your webhook secret.

### Handle Retries
FUB retries failed webhooks 5 times over 8 hours. Ensure your handler is idempotent — use the event ID to deduplicate.

### Max Webhooks Per Event
Maximum 2 webhooks per event type per system. Plan your webhook architecture accordingly.
