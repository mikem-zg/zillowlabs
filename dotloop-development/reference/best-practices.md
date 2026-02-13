# Dotloop API Best Practices

## Rate Limiting

- Limit: 100 requests per window
- Response headers: `X-RateLimit-Limit` (100), `X-RateLimit-Remaining` (decreasing), `X-RateLimit-Reset` (milliseconds until reset)
- Do NOT bypass rate limits — violates API License Agreement
- Implement exponential backoff when approaching limits
- Cache responses when appropriate (profiles, templates change infrequently)

### Rate Limit Handling Example

```typescript
async function requestWithRateLimit<T>(fn: () => Promise<Response>): Promise<T> {
  const response = await fn();

  const remaining = parseInt(response.headers.get('X-RateLimit-Remaining') || '100', 10);
  const resetMs = parseInt(response.headers.get('X-RateLimit-Reset') || '0', 10);

  if (remaining < 10) {
    console.warn(`[Dotloop] Rate limit warning: ${remaining} requests remaining, resets in ${resetMs}ms`);
  }

  if (response.status === 429) {
    console.warn(`[Dotloop] Rate limited. Waiting ${resetMs}ms before retry`);
    await new Promise(resolve => setTimeout(resolve, resetMs));
    return requestWithRateLimit<T>(fn);
  }

  if (!response.ok) {
    throw new Error(`Dotloop API error: ${response.status} ${await response.text()}`);
  }

  return response.json() as Promise<T>;
}
```

---

## Pagination

Dotloop uses **BATCH-based** pagination (NOT offset or cursor).

- Parameters: `batch_number` (starts at 1), `batch_size` (max 50, default 50)
- Increment `batch_number` to get next page: batch=1, batch=2, batch=3...
- Applies to: Loops, Contacts, Activity logs
- Webhook subscriptions use cursor: `next_cursor` parameter
- No total count header — keep fetching until you get fewer than `batch_size` results

### Pagination Code Pattern

```typescript
async function getAllLoops(profileId: number): Promise<Loop[]> {
  const allLoops: Loop[] = [];
  let batchNumber = 1;
  while (true) {
    const response = await client.get(`/profile/${profileId}/loop`, {
      params: { batch_number: batchNumber, batch_size: 50 }
    });
    const loops = response.data.data;
    allLoops.push(...loops);
    if (loops.length < 50) break;
    batchNumber++;
  }
  return allLoops;
}
```

### Python Pagination Pattern

```python
def iter_loops(self, profile_id: int):
    """Generator that auto-paginates through all loops."""
    batch_number = 1
    while True:
        data = self.get_loops(profile_id, batch_number=batch_number, batch_size=50)
        loops = data.get('data', [])
        yield from loops
        if len(loops) < 50:
            break
        batch_number += 1
```

---

## Loop View ID vs Loop ID

- **ALWAYS use `loop_view_id`, NOT `loop_id`**
- They are different! `loop_view_id` handles merged loops correctly
- API may return 301 redirects if loop has been merged — follow redirects
- The Node.js client README explicitly warns: "just forget that the loop id exists"

---

## Profile Types

- **INDIVIDUAL** — personal profile, has loops, this is what most API integrations work with
- **OFFICE** — office-level profile
- **BROKERAGE** — brokerage-level profile
- Loop access is currently restricted to INDIVIDUAL profiles only
- Check `profile.requiresTemplate` — if true, `templateId` is required when creating loops

---

## Transaction Types

| Type | Description | Use Case |
|------|-------------|----------|
| `PURCHASE_OFFER` | Buyer making offer | Buying agent |
| `LISTING_FOR_SALE` | Sale listing | Listing agent |
| `LISTING_FOR_LEASE` | Rental listing | Landlord/listing agent |
| `LEASE` | Lease offer | Tenant/buying agent |
| `REAL_ESTATE_OTHER` | Non-standard RE | Referrals, other |
| `OTHER` | Non-real estate | Limited fields/roles |

---

## Status Values

| Status | For Transaction Type |
|--------|---------------------|
| `PRE_OFFER` | `PURCHASE_OFFER` |
| `PRE_LISTING` | `LISTING_FOR_SALE` |
| `PRIVATE_LISTING` | `LISTING_FOR_SALE` |
| `ACTIVE_LISTING` | `LISTING_FOR_SALE` |
| `UNDER_CONTRACT` | Both |
| `SOLD` | Both |

---

## Loop Detail Sections

- Sections are **DYNAMIC** — empty fields are NOT included in responses
- Don't assume specific properties will always exist
- Sections include: Property Address, Financials, Contract Dates, Closing Information, Listing Information, Listing Brokerage, Buying Brokerage
- Use PATCH to update individual sections without sending all data

---

## Error Handling

| Status | Meaning | Action |
|--------|---------|--------|
| 200 | Success | Process response |
| 201 | Created | Resource created successfully |
| 301 | Redirect | Loop was merged — follow redirect |
| 400 | Bad request | Check request body/params |
| 401 | Unauthenticated | Token expired — refresh and retry |
| 403 | Access denied | Wrong profile type or insufficient permissions |
| 404 | Not found | Resource doesn't exist |
| 429 | Rate limited | Check `X-RateLimit-Reset`, back off |
| 500 | Server error | Retry with exponential backoff |

---

## Token Management Best Practices

- Access tokens expire every ~12 hours (43199 seconds)
- Refresh proactively before expiry (e.g., at 80% of lifetime)
- Handle 401 gracefully — refresh token and retry the request
- **CRITICAL:** Refreshing invalidates the previous access token immediately
- In clustered environments: use a single token store, coordinate refresh, use locks to prevent concurrent refresh
- Store tokens encrypted at rest

### Token Refresh Pattern

```typescript
async function ensureValidToken(tokenStore: TokenStore): Promise<string> {
  const tokens = tokenStore.get();
  const now = Date.now();
  const expiresAt = tokens.issuedAt + (tokens.expiresIn * 1000);
  const refreshThreshold = tokens.issuedAt + (tokens.expiresIn * 0.8 * 1000);

  if (now >= refreshThreshold) {
    console.log('[Dotloop] Proactively refreshing token');
    const newTokens = await refreshAccessToken(tokens.refreshToken);
    tokenStore.save({ ...newTokens, issuedAt: now });
    return newTokens.access_token;
  }

  return tokens.access_token;
}
```

---

## Document Handling

- Upload documents via `multipart/form-data`
- Download documents as PDF via `/download` endpoint
- Documents are organized in folders within loops
- Each document has `signatureVerificationLink`

---

## Common Pitfalls

1. **Using `loop_id` instead of `loop_view_id`** (they're different!)
2. **Not handling token expiry** (12-hour lifetime)
3. **Expecting specific fields in loop details** (they're dynamic)
4. **Not following 301 redirects** (merged loops)
5. **Exceeding `batch_size` of 50** (silently capped)
6. **Trying to access loops on non-INDIVIDUAL profiles** (403 error)
7. **Not implementing idempotent webhook handlers** (duplicate events)
8. **Concurrent token refresh in clustered environments** (race condition)
9. **Forgetting `templateId` when organization requires it** (check `profile.requiresTemplate`)
10. **Not using CSRF `state` parameter in OAuth flow**
