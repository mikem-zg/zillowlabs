# API Contract Guide

This guide describes how to capture and document every backend endpoint before deleting the frontend. The API contract becomes the interface specification for the new frontend — the backend stays untouched, so the new frontend must call these exact endpoints with the correct request shapes and handle the exact response shapes.

**When to do this:** After the PRD is written (Phase 2) and before deleting any frontend code (Phase 4). You need the old frontend code to discover what endpoints are called and how.

**Why this matters:** Once you delete the frontend, you lose the implicit documentation of how the UI called the backend. Without an API contract, you will guess at request/response shapes during rebuild, which causes bugs and wasted time.

---

## Methodology

### Step 1: Find All API Calls in the Frontend

Search the existing frontend code for every HTTP request:

```bash
# Find all fetch/axios/API calls
grep -rn "fetch(" client/src/
grep -rn "axios\." client/src/
grep -rn "/api/" client/src/
grep -rn "useQuery\|useMutation" client/src/

# Check for custom API wrapper modules (common pattern)
ls client/src/lib/api* client/src/utils/api* client/src/services/* 2>/dev/null
```

**Important:** Many apps centralize API calls in a custom wrapper (e.g., `client/src/lib/api.ts` or `client/src/services/api.ts`). If one exists, read it thoroughly — it may define base URLs, default headers, auth token injection, or error handling that individual `fetch` calls rely on.

For each API call found, note:
- The file and line number where it's called
- The HTTP method (GET, POST, PUT, DELETE)
- The URL path
- Any request body, query parameters, or path parameters
- How the response is consumed (what fields are read from it)

### Step 2: Cross-Reference with Backend Routes

Open the backend route files and match each frontend call to its handler:

```bash
# Find all route definitions
grep -rn "app.get\|app.post\|app.put\|app.delete\|router.get\|router.post" server/
```

For each route handler, note:
- What the handler reads from the request (params, query, body)
- What the handler returns (the exact JSON shape)
- Any middleware applied (auth checks, validation)
- Any side effects (database writes, external API calls, logging)

### Step 3: Test Each Endpoint

Use curl or a similar tool to call each endpoint and capture the real response:

```bash
# GET endpoint
curl -s http://localhost:5000/api/skills | jq '.[0]' > /tmp/skills-response-sample.json

# POST endpoint (with auth)
curl -s -X POST http://localhost:5000/api/downloads/skill/1

# Auth endpoint
curl -s http://localhost:5000/api/auth/me -H "Cookie: session=..."
```

Compare the real response to what the frontend expects. They should match exactly.

### Step 4: Document Each Endpoint

Use the template below for each endpoint. Include real response samples where possible.

---

## Endpoint Documentation Template

```markdown
### `GET /api/skills`

**Purpose:** List all skills with summary data for card display.

**Auth required:** No

**Request:**
- Path params: none
- Query params: none
- Body: none

**Response (200):**
```json
[
  {
    "id": 1,
    "name": "constellation-design-system",
    "description": "Build UI with Zillow's Constellation Design System v10.11.0",
    "category": "design",
    "tags": ["react", "panda-css", "zillow"],
    "fileCount": 12,
    "hasReferences": true,
    "isBuiltIn": true,
    "authorDisplayName": null,
    "authorPhotoURL": null
  }
]
```

**Error responses:**
- `500` — Internal server error

**Side effects:** None

**Frontend usage:** Home page skill grid, global search results
```

---

## Common Patterns to Watch For

### Authentication Endpoints

Auth endpoints often involve cookies, tokens, and redirects. Document these carefully:

| Pattern | What to capture |
|---------|-----------------|
| Token exchange | What the frontend sends (e.g., Google credential) and what the backend returns (session cookie, user data) |
| Session check | What `/api/auth/me` returns when authenticated vs unauthenticated |
| Logout | Whether it clears cookies, what HTTP method is used, what the response is |
| Protected routes | Which endpoints return `401` when not authenticated |

### Side-Effect Endpoints

Some endpoints do more than return data:

| Pattern | What to capture |
|---------|-----------------|
| Download tracking | `POST /api/downloads/:type/:id` — increments a counter, returns nothing meaningful |
| Form submissions | What validation the server does, what error shape it returns on failure |
| File creation | What the server creates, what the response contains (new ID, creation timestamp) |

### Pagination and Filtering

If any endpoints support pagination or filtering, document:
- Query parameter names (`?page=1&limit=10`, `?category=design`)
- Default values when params are omitted
- Response shape for paginated results (total count, page info, items array)

---

## Verification Checklist

Before moving to Phase 4 (Clean Slate), verify:

- [ ] Every `fetch` call in the existing frontend has a documented endpoint
- [ ] Every endpoint has been tested with curl and returns the expected shape
- [ ] Request shapes match what the frontend sends (check query params, body fields)
- [ ] Response shapes match what the frontend reads (check every field accessed in code)
- [ ] Auth requirements are correct (tested both authenticated and unauthenticated)
- [ ] Error responses are documented (test with invalid data, missing auth, 404 routes)
- [ ] Side effects are noted (anything that writes to the database or triggers external actions)
- [ ] The endpoint summary table is complete

---

## Output

The API contract should be included either as Section 5 of the PRD (see [PRD Template](prd-template.md)) or as a standalone companion document. Either way, it must be complete before any frontend code is deleted.

**Next step:** With the PRD and API contract complete, proceed to Phase 4 (Clean Slate) — delete all frontend code and prepare for the rebuild.
