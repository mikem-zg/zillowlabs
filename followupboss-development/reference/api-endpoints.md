# Follow Up Boss API Endpoints Reference

## Base URL

```
https://api.followupboss.com/v1/
```

All requests require HTTPS. HTTP will not work. Every request must include authentication and system headers:

```
Authorization: Basic base64(API_KEY:)
X-System: YourSystemName
X-System-Key: your-system-key
Content-Type: application/json
```

---

## 1. Events — `POST /v1/events`

> **THE MOST IMPORTANT ENDPOINT.** This is the PREFERRED way to send leads into Follow Up Boss. It handles deduplication, triggers action plans, assigns agents via Lead Flow, and records events in the contact timeline.

> ⚠️ **WARNING:** DO NOT use `POST /v1/people` to send leads. It skips automations, action plans, lead routing, and deduplication. ALWAYS use Events.

### Request Body Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `source` | string | Yes | Lead source name (e.g., "MyWebsite.com", "Zillow") |
| `system` | string | Yes | Your registered system name (must match `X-System` header) |
| `type` | string | Yes | Event type (see list below) |
| `message` | string | No | Free-text message or inquiry details |
| `person` | object | Yes | Contact information (see Person sub-object) |
| `person.id` | integer | No | Existing FUB person ID to link event to |
| `person.firstName` | string | No | First name |
| `person.lastName` | string | No | Last name |
| `person.emails` | array | No | `[{"value": "email@example.com"}]` |
| `person.phones` | array | No | `[{"value": "555-555-5555"}]` |
| `person.tags` | array | No | `["tag1", "tag2"]` |
| `property` | object | No | Property details for property-related events |
| `property.street` | string | No | Street address |
| `property.city` | string | No | City |
| `property.state` | string | No | State |
| `property.zip` | string | No | ZIP code |
| `property.mlsNumber` | string | No | MLS listing number |
| `property.price` | number | No | Property price |
| `property.bedrooms` | number | No | Number of bedrooms |
| `property.bathrooms` | number | No | Number of bathrooms |
| `property.url` | string | No | Property listing URL |
| `property.type` | string | No | Property type (e.g., "Single Family", "Condo") |
| `propertySearch` | object | No | Search criteria for Property Search events |
| `propertySearch.minPrice` | number | No | Minimum price |
| `propertySearch.maxPrice` | number | No | Maximum price |
| `propertySearch.city` | string | No | Search city |
| `propertySearch.state` | string | No | Search state |
| `propertySearch.type` | string | No | Property type filter |
| `campaign` | object | No | Marketing campaign attribution |
| `campaign.name` | string | No | Campaign name |
| `campaign.source` | string | No | Campaign source |
| `campaign.medium` | string | No | Campaign medium |
| `campaign.term` | string | No | Campaign term |
| `campaign.content` | string | No | Campaign content |
| `occurredAt` | string | No | ISO 8601 timestamp when event occurred (defaults to now) |
| `custom*` | any | No | Custom fields — prefix field name with "custom" (e.g., `customBudget`) |

### Event Types

| Type | Description | Triggers Action Plan? |
|------|-------------|----------------------|
| `Registration` | New user registration / sign-up | ✅ Yes |
| `Inquiry` | Generic inquiry (legacy — prefer specific types) | ❌ No |
| `Seller Inquiry` | Homeowner looking to sell | ✅ Yes |
| `Property Inquiry` | Inquiry about a specific property | ✅ Yes |
| `General Inquiry` | General contact form or question | ✅ Yes |
| `Viewed Property` | User viewed a property listing page | ❌ No |
| `Saved Property` | User saved/favorited a property | ❌ No |
| `Visited Website` | User visited your website | ❌ No |
| `Incoming Call` | Inbound phone call received | ❌ No |
| `Unsubscribed` | User unsubscribed from communications | ❌ No |
| `Property Search` | User performed a property search | ❌ No |
| `Saved Property Search` | User saved a property search | ❌ No |
| `Visited Open House` | User visited an open house | ✅ Yes |
| `Viewed Page` | User viewed a specific page on your site | ❌ No |

### Viewed Page Event — Special Fields

| Parameter | Type | Description |
|-----------|------|-------------|
| `pageTitle` | string | Title of the page viewed |
| `pageUrl` | string | URL of the page viewed |
| `pageReferrer` | string | Referring URL |
| `pageDuration` | number | Time spent on page (seconds) |

### Status Codes

| Code | Meaning |
|------|---------|
| `200` | Event created, existing person updated |
| `201` | Event created, new person created |
| `204` | Event received but lead flow archived/ignored the lead |

### Example Request

```bash
curl -X POST https://api.followupboss.com/v1/events \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "source": "MyWebsite.com",
    "system": "YourSystem",
    "type": "Property Inquiry",
    "message": "I am interested in this property. Please contact me.",
    "person": {
      "firstName": "Jane",
      "lastName": "Doe",
      "emails": [{"value": "jane@example.com"}],
      "phones": [{"value": "555-123-4567"}],
      "tags": ["buyer", "hot-lead"]
    },
    "property": {
      "street": "123 Main Street",
      "city": "Austin",
      "state": "TX",
      "zip": "78701",
      "mlsNumber": "MLS12345",
      "price": 450000,
      "bedrooms": 3,
      "bathrooms": 2,
      "url": "https://mywebsite.com/listing/123",
      "type": "Single Family"
    },
    "campaign": {
      "name": "Spring 2025 Campaign",
      "source": "google",
      "medium": "cpc",
      "term": "homes for sale austin",
      "content": "ad-variation-1"
    }
  }'
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/events', {
  method: 'POST',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    source: 'MyWebsite.com',
    system: 'YourSystem',
    type: 'Property Inquiry',
    message: 'I am interested in this property.',
    person: {
      firstName: 'Jane',
      lastName: 'Doe',
      emails: [{ value: 'jane@example.com' }],
      phones: [{ value: '555-123-4567' }],
    },
    property: {
      street: '123 Main Street',
      city: 'Austin',
      state: 'TX',
      zip: '78701',
      price: 450000,
    },
  }),
});

const status = response.status;
if (status === 201) {
  const data = await response.json();
  console.log('New person created with ID:', data.id);
} else if (status === 200) {
  console.log('Existing person updated');
} else if (status === 204) {
  console.log('Lead flow archived this lead');
}
```

### Key Response Fields (200/201)

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Event ID |
| `personId` | integer | Person ID (new or existing) |
| `type` | string | Event type |
| `source` | string | Lead source |
| `createdAt` | string | ISO 8601 timestamp |

### Important Notes

- **Person matching:** FUB deduplicates by email and phone. If a match is found, the existing person is updated; otherwise a new person is created.
- **Person ID:** You can provide `person.id` to explicitly link the event to an existing contact instead of relying on dedup.
- **Cannot reassign in same call:** You cannot change the person's agent assignment in the same Events call. To reassign, make a separate `PUT /v1/people/:id` call afterward.
- **Custom fields:** Prefix with "custom" (e.g., `customBudget`, `customMoveInDate`). The custom field must already exist in the FUB account.
- **Campaign object:** Used for marketing attribution reports in FUB. Does not affect lead routing.
- **occurredAt:** Use this for historical event import. If omitted, defaults to current time.

---

## 2. People

### GET /v1/people — List/Search People

```bash
curl -G https://api.followupboss.com/v1/people \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  --data-urlencode "sort=created" \
  --data-urlencode "limit=25" \
  --data-urlencode "offset=0"
```

```typescript
const params = new URLSearchParams({
  sort: 'created',
  limit: '25',
  offset: '0',
  fields: 'allFields',
});
const response = await fetch(`https://api.followupboss.com/v1/people?${params}`, {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
const data = await response.json();
```

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `sort` | string | Sort field: `created`, `updated`, `lastActivity`, `name` |
| `limit` | integer | Results per page (max 100, default 25) |
| `offset` | integer | Number of results to skip |
| `next` | string | Cursor-based pagination token (preferred over offset for deep pagination) |
| `listId` | integer | Filter by Smart List ID |
| `fields` | string | Set to `allFields` to include custom fields in response |
| `email` | string | Search by email address |
| `phone` | string | Search by phone number |
| `tag` | string | Filter by tag |
| `stage` | string | Filter by stage |
| `assignedUserId` | integer | Filter by assigned agent |
| `q` | string | Search query (searches name, email, phone) |

#### Response

```json
{
  "people": [
    {
      "id": 12345,
      "firstName": "Jane",
      "lastName": "Doe",
      "emails": [{"value": "jane@example.com", "type": "home"}],
      "phones": [{"value": "555-123-4567", "type": "mobile"}],
      "stage": "Lead",
      "source": "MyWebsite.com",
      "assignedTo": "Agent Name",
      "assignedUserId": 67,
      "tags": ["buyer", "hot-lead"],
      "created": "2025-01-15T10:30:00Z",
      "updated": "2025-01-20T14:00:00Z"
    }
  ],
  "_metadata": {
    "total": 150,
    "limit": 25,
    "offset": 0,
    "next": "cursor_token_here"
  }
}
```

### GET /v1/people/:id — Get Single Person

```bash
curl https://api.followupboss.com/v1/people/12345 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

```typescript
const response = await fetch(`https://api.followupboss.com/v1/people/${personId}`, {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
const person = await response.json();
```

### POST /v1/people — Create Person

> ⚠️ **WARNING:** Do NOT use this endpoint to send leads. Use `POST /v1/events` instead. This endpoint skips automations, action plans, lead routing, and deduplication.

```bash
curl -X POST https://api.followupboss.com/v1/people \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Smith",
    "emails": [{"value": "john@example.com"}],
    "phones": [{"value": "555-999-8888"}],
    "source": "Import",
    "tags": ["imported"],
    "assignedUserId": 67,
    "deduplicate": true
  }'
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/people', {
  method: 'POST',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    firstName: 'John',
    lastName: 'Smith',
    emails: [{ value: 'john@example.com' }],
    phones: [{ value: '555-999-8888' }],
    source: 'Import',
    tags: ['imported'],
    assignedUserId: 67,
    deduplicate: true,
  }),
});
```

#### Create Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `firstName` | string | First name |
| `lastName` | string | Last name |
| `emails` | array | `[{"value": "email@example.com", "type": "home"}]` |
| `phones` | array | `[{"value": "555-5555", "type": "mobile"}]` |
| `addresses` | array | `[{"street": "...", "city": "...", "state": "...", "zip": "..."}]` |
| `tags` | array | `["tag1", "tag2"]` |
| `stage` | string | Contact stage (e.g., "Lead", "Prospect", "Active Client") |
| `source` | string | Lead source (can only be set on creation, NOT updateable) |
| `sourceUrl` | string | Lead source URL (can only be set on creation, NOT updateable) |
| `price` | number | Budget/price point |
| `assignedTo` | string | Agent name (prefer `assignedUserId`) |
| `assignedUserId` | integer | Agent user ID |
| `assignedPondId` | integer | Lead pond ID |
| `assignedLenderName` | string | Lender name |
| `assignedLenderId` | integer | Lender user ID |
| `contacted` | boolean | Whether the contact has been contacted |
| `background` | string | Background notes |
| `collaborators` | array | `[{"userId": 67}]` — additional agents with access |
| `timeframeId` | integer | Timeframe ID |
| `deduplicate` | boolean | If true, merges with existing person matched by email/phone |
| `createdAt` | string | ISO 8601 — use for historical imports (backdate creation) |
| `custom*` | any | Custom fields prefixed with "custom" |

### PUT /v1/people/:id — Update Person

> ⚠️ **`source` and `sourceUrl` CANNOT be changed via PUT.** They are set once on person creation only.

```bash
curl -X PUT https://api.followupboss.com/v1/people/12345 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "stage": "Active Client",
    "tags": ["buyer", "hot-lead", "vip"],
    "assignedUserId": 89,
    "customBudget": "500000"
  }'
```

```typescript
const response = await fetch(`https://api.followupboss.com/v1/people/${personId}`, {
  method: 'PUT',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    stage: 'Active Client',
    tags: ['buyer', 'hot-lead', 'vip'],
    assignedUserId: 89,
    customBudget: '500000',
  }),
});
```

### DELETE /v1/people/:id — Delete Person

```bash
curl -X DELETE https://api.followupboss.com/v1/people/12345 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

```typescript
await fetch(`https://api.followupboss.com/v1/people/${personId}`, {
  method: 'DELETE',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
```

---

## 3. Notes

### POST /v1/notes — Create Note

```bash
curl -X POST https://api.followupboss.com/v1/notes \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "personId": 12345,
    "body": "Spoke with client. They are interested in 3+ bed homes in East Austin under $500k.",
    "subject": "Phone Call Follow-Up"
  }'
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/notes', {
  method: 'POST',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    personId: 12345,
    body: 'Spoke with client. Interested in 3+ bed homes in East Austin under $500k.',
    subject: 'Phone Call Follow-Up',
  }),
});
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `personId` | integer | Yes | ID of the person to attach the note to |
| `body` | string | Yes | Note content (supports plain text) |
| `subject` | string | No | Note subject/title |
| `isHtml` | boolean | No | Whether body contains HTML |

### GET /v1/notes — List Notes

```bash
curl -G https://api.followupboss.com/v1/notes \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  --data-urlencode "personId=12345" \
  --data-urlencode "limit=25"
```

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `personId` | integer | Filter notes by person ID |
| `limit` | integer | Results per page |
| `offset` | integer | Pagination offset |

### PUT /v1/notes/:id — Update Note

```bash
curl -X PUT https://api.followupboss.com/v1/notes/999 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{"body": "Updated note content."}'
```

### DELETE /v1/notes/:id — Delete Note

```bash
curl -X DELETE https://api.followupboss.com/v1/notes/999 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

---

## 4. Tasks

### POST /v1/tasks — Create Task

```bash
curl -X POST https://api.followupboss.com/v1/tasks \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "personId": 12345,
    "assignedUserId": 67,
    "name": "Follow up on property inquiry",
    "description": "Client asked about 123 Main St. Call to schedule showing.",
    "dueDate": "2025-02-15",
    "status": "pending",
    "type": "call"
  }'
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/tasks', {
  method: 'POST',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    personId: 12345,
    assignedUserId: 67,
    name: 'Follow up on property inquiry',
    description: 'Client asked about 123 Main St. Call to schedule showing.',
    dueDate: '2025-02-15',
    status: 'pending',
    type: 'call',
  }),
});
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `personId` | integer | No | Person to associate the task with |
| `assignedUserId` | integer | No | User to assign the task to |
| `name` | string | Yes | Task title/name |
| `description` | string | No | Task description |
| `dueDate` | string | No | Due date in `YYYY-MM-DD` format |
| `status` | string | No | `pending`, `completed` |
| `type` | string | No | Task type: `call`, `email`, `todo`, `text`, `other` |

### GET /v1/tasks — List Tasks

```bash
curl -G https://api.followupboss.com/v1/tasks \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  --data-urlencode "personId=12345" \
  --data-urlencode "status=pending" \
  --data-urlencode "limit=25"
```

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `personId` | integer | Filter by person |
| `assignedUserId` | integer | Filter by assigned user |
| `status` | string | Filter: `pending`, `completed` |
| `limit` | integer | Results per page |
| `offset` | integer | Pagination offset |

### PUT /v1/tasks/:id — Update Task

```bash
curl -X PUT https://api.followupboss.com/v1/tasks/456 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{"status": "completed"}'
```

### DELETE /v1/tasks/:id — Delete Task

```bash
curl -X DELETE https://api.followupboss.com/v1/tasks/456 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

---

## 5. Deals

### POST /v1/deals — Create Deal

```bash
curl -X POST https://api.followupboss.com/v1/deals \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "personId": 12345,
    "name": "123 Main St - Smith Purchase",
    "dealValue": 450000,
    "commissionValue": 13500,
    "agentCommission": 10800,
    "teamCommission": 2700,
    "pipelineId": 1,
    "stageId": 3,
    "closingDate": "2025-06-15",
    "dealType": "Buying",
    "propertyAddress": "123 Main Street, Austin, TX 78701"
  }'
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/deals', {
  method: 'POST',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    personId: 12345,
    name: '123 Main St - Smith Purchase',
    dealValue: 450000,
    commissionValue: 13500,
    agentCommission: 10800,
    teamCommission: 2700,
    pipelineId: 1,
    stageId: 3,
    closingDate: '2025-06-15',
    dealType: 'Buying',
    propertyAddress: '123 Main Street, Austin, TX 78701',
  }),
});
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `personId` | integer | No | Associated person/contact |
| `name` | string | Yes | Deal name |
| `dealValue` | number | No | Total deal value (sale price) |
| `commissionValue` | number | No | Total commission amount — **TOP-LEVEL param** |
| `agentCommission` | number | No | Agent's commission share — **TOP-LEVEL param** |
| `teamCommission` | number | No | Team's commission share — **TOP-LEVEL param** |
| `pipelineId` | integer | No | Pipeline ID |
| `stageId` | integer | No | Stage ID within the pipeline |
| `closingDate` | string | No | Expected closing date (`YYYY-MM-DD`) |
| `dealType` | string | No | `Buying`, `Selling`, `Renting`, `Listing` |
| `propertyAddress` | string | No | Property address for the deal |
| `assignedUserId` | integer | No | Assigned agent |

> ⚠️ **IMPORTANT:** `commissionValue`, `agentCommission`, and `teamCommission` are **TOP-LEVEL** parameters on the deal. Do NOT put them inside `custom_fields` or any nested object — they will be silently ignored.

### GET /v1/deals — List Deals

```bash
curl -G https://api.followupboss.com/v1/deals \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  --data-urlencode "personId=12345" \
  --data-urlencode "limit=25"
```

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `personId` | integer | Filter by person |
| `pipelineId` | integer | Filter by pipeline |
| `stageId` | integer | Filter by stage |
| `assignedUserId` | integer | Filter by assigned user |
| `limit` | integer | Results per page |
| `offset` | integer | Pagination offset |

### PUT /v1/deals/:id — Update Deal

```bash
curl -X PUT https://api.followupboss.com/v1/deals/789 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "stageId": 5,
    "closingDate": "2025-07-01",
    "commissionValue": 14000
  }'
```

### DELETE /v1/deals/:id — Delete Deal

```bash
curl -X DELETE https://api.followupboss.com/v1/deals/789 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

---

## 6. Appointments

### POST /v1/appointments — Create Appointment

```bash
curl -X POST https://api.followupboss.com/v1/appointments \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "personId": 12345,
    "assignedUserId": 67,
    "title": "Property Showing - 123 Main St",
    "description": "Show 3BR/2BA home to Smith family",
    "startAt": "2025-02-20T14:00:00Z",
    "endAt": "2025-02-20T15:00:00Z",
    "location": "123 Main Street, Austin, TX 78701"
  }'
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/appointments', {
  method: 'POST',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    personId: 12345,
    assignedUserId: 67,
    title: 'Property Showing - 123 Main St',
    description: 'Show 3BR/2BA home to Smith family',
    startAt: '2025-02-20T14:00:00Z',
    endAt: '2025-02-20T15:00:00Z',
    location: '123 Main Street, Austin, TX 78701',
  }),
});
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `personId` | integer | No | Associated person/contact |
| `assignedUserId` | integer | No | Assigned agent |
| `title` | string | Yes | Appointment title |
| `description` | string | No | Appointment description |
| `startAt` | string | Yes | Start time (ISO 8601) |
| `endAt` | string | Yes | End time (ISO 8601) |
| `location` | string | No | Appointment location |

> ⚠️ **NOTE:** Webhooks only fire for appointments created directly in FUB (via API or UI). Appointments synced from external calendars (Google Calendar, Outlook, etc.) do NOT trigger webhooks.

### GET /v1/appointments — List Appointments

```bash
curl -G https://api.followupboss.com/v1/appointments \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  --data-urlencode "personId=12345" \
  --data-urlencode "limit=25"
```

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `personId` | integer | Filter by person |
| `assignedUserId` | integer | Filter by assigned user |
| `limit` | integer | Results per page |
| `offset` | integer | Pagination offset |

### PUT /v1/appointments/:id — Update Appointment

```bash
curl -X PUT https://api.followupboss.com/v1/appointments/101 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "startAt": "2025-02-21T10:00:00Z",
    "endAt": "2025-02-21T11:00:00Z"
  }'
```

### DELETE /v1/appointments/:id — Delete Appointment

```bash
curl -X DELETE https://api.followupboss.com/v1/appointments/101 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

---

## 7. Users

### GET /v1/users — List Users (Agents/Team Members)

```bash
curl https://api.followupboss.com/v1/users \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/users', {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
const data = await response.json();
const users = data.users;
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | User ID |
| `firstName` | string | First name |
| `lastName` | string | Last name |
| `email` | string | Email address |
| `role` | string | Role: `owner`, `admin`, `agent`, `lender` |
| `status` | string | `active`, `inactive` |
| `teamId` | integer | Team ID (if team member) |

---

## 8. Teams

### GET /v1/teams — List Teams

```bash
curl https://api.followupboss.com/v1/teams \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Team ID |
| `name` | string | Team name |
| `leaderId` | integer | Team leader user ID |

---

## 9. Custom Fields

### GET /v1/customFields — List Custom Fields

Returns all custom fields configured in the FUB account. Use this to discover available custom field names before sending data.

```bash
curl https://api.followupboss.com/v1/customFields \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/customFields', {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
const data = await response.json();
const customFields = data.customfields;
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Custom field ID |
| `name` | string | Display name |
| `key` | string | API key (prefixed with "custom", e.g., `customBudget`) |
| `type` | string | Field type: `text`, `number`, `date`, `dropdown`, `checkbox` |
| `options` | array | Dropdown options (if type is `dropdown`) |

---

## 10. Pipelines

### GET /v1/pipelines — List Pipelines

```bash
curl https://api.followupboss.com/v1/pipelines \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

### POST /v1/pipelines — Create Pipeline

```bash
curl -X POST https://api.followupboss.com/v1/pipelines \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name": "Buyer Pipeline"}'
```

### PUT /v1/pipelines/:id — Update Pipeline

```bash
curl -X PUT https://api.followupboss.com/v1/pipelines/1 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name": "Updated Pipeline Name"}'
```

### DELETE /v1/pipelines/:id — Delete Pipeline

```bash
curl -X DELETE https://api.followupboss.com/v1/pipelines/1 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Pipeline ID |
| `name` | string | Pipeline name |

---

## 11. Stages

### GET /v1/stages — List Stages

Returns all stages across all pipelines.

```bash
curl https://api.followupboss.com/v1/stages \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/stages', {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
const data = await response.json();
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Stage ID |
| `name` | string | Stage name |
| `pipelineId` | integer | Parent pipeline ID |
| `position` | integer | Sort order |

---

## 12. Smart Lists

### GET /v1/smartLists — List Smart Lists

Returns all saved smart lists (dynamic contact filters). Use the returned `id` as the `listId` parameter in `GET /v1/people` to fetch contacts matching that smart list.

```bash
curl https://api.followupboss.com/v1/smartLists \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/smartLists', {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
const data = await response.json();

const smartListId = data.smartlists[0].id;
const people = await fetch(
  `https://api.followupboss.com/v1/people?listId=${smartListId}`,
  { headers: { /* auth headers */ } }
);
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Smart list ID |
| `name` | string | Smart list name |
| `count` | integer | Number of matching contacts |

---

## 13. Action Plans

### GET /v1/actionPlans — List Action Plans

Returns all action plans configured in the account.

```bash
curl https://api.followupboss.com/v1/actionPlans \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Action plan ID |
| `name` | string | Action plan name |
| `isActive` | boolean | Whether the plan is active |
| `triggerType` | string | What triggers this plan |

---

## 14. Text Messages

### POST /v1/textMessages — Log a Text Message

```bash
curl -X POST https://api.followupboss.com/v1/textMessages \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "personId": 12345,
    "message": "Hi Jane, just following up on our conversation about 123 Main St.",
    "to": "555-123-4567",
    "from": "555-999-0000",
    "direction": "outgoing"
  }'
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `personId` | integer | Yes | Associated person |
| `message` | string | Yes | Text message content |
| `to` | string | No | Recipient phone number |
| `from` | string | No | Sender phone number |
| `direction` | string | No | `incoming` or `outgoing` |

### GET /v1/textMessages — List Text Messages

```bash
curl -G https://api.followupboss.com/v1/textMessages \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  --data-urlencode "personId=12345"
```

### PUT /v1/textMessages/:id — Update Text Message

```bash
curl -X PUT https://api.followupboss.com/v1/textMessages/555 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message": "Updated message content"}'
```

### DELETE /v1/textMessages/:id — Delete Text Message

```bash
curl -X DELETE https://api.followupboss.com/v1/textMessages/555 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

---

## 15. Calls

### POST /v1/calls — Log a Call

```bash
curl -X POST https://api.followupboss.com/v1/calls \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "personId": 12345,
    "userId": 67,
    "to": "555-123-4567",
    "from": "555-999-0000",
    "duration": 180,
    "direction": "outgoing",
    "outcome": "connected",
    "note": "Discussed pricing and showing schedule."
  }'
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `personId` | integer | Yes | Associated person |
| `userId` | integer | No | Agent who made/received the call |
| `to` | string | No | Called number |
| `from` | string | No | Caller number |
| `duration` | integer | No | Call duration in seconds |
| `direction` | string | No | `incoming` or `outgoing` |
| `outcome` | string | No | `connected`, `no answer`, `voicemail`, `busy` |
| `note` | string | No | Call notes |
| `recordingUrl` | string | No | URL to call recording |

### GET /v1/calls — List Calls

```bash
curl -G https://api.followupboss.com/v1/calls \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  --data-urlencode "personId=12345"
```

### PUT /v1/calls/:id — Update Call

```bash
curl -X PUT https://api.followupboss.com/v1/calls/777 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY" \
  -H "Content-Type: application/json" \
  -d '{"note": "Updated call notes.", "outcome": "connected"}'
```

### DELETE /v1/calls/:id — Delete Call

```bash
curl -X DELETE https://api.followupboss.com/v1/calls/777 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

---

## 16. Email Templates

### GET /v1/emailTemplates — List Email Templates

Returns all email templates available in the account.

```bash
curl https://api.followupboss.com/v1/emailTemplates \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/emailTemplates', {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
const data = await response.json();
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Template ID |
| `name` | string | Template name |
| `subject` | string | Email subject line |
| `body` | string | Email body (HTML) |
| `userId` | integer | Owner user ID |

---

## 17. Identity

### GET /v1/identity — Get Current User/Account Info

Returns information about the currently authenticated user and account. Useful for embedded apps to determine which FUB account is connected.

```bash
curl https://api.followupboss.com/v1/identity \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

```typescript
const response = await fetch('https://api.followupboss.com/v1/identity', {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
  },
});
const identity = await response.json();
console.log(`Logged in as: ${identity.firstName} ${identity.lastName}`);
console.log(`Account ID: ${identity.accountId}`);
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Current user ID |
| `firstName` | string | First name |
| `lastName` | string | Last name |
| `email` | string | Email address |
| `role` | string | User role (`owner`, `admin`, `agent`) |
| `accountId` | integer | FUB account ID |
| `accountName` | string | FUB account/team name |
| `timezone` | string | Account timezone |

---

## 18. Webhooks

### POST /v1/webhooks — Register Webhook

> See [webhooks.md](webhooks.md) for comprehensive webhook documentation including all events, signature verification, and retry logic.

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

```typescript
const response = await fetch('https://api.followupboss.com/v1/webhooks', {
  method: 'POST',
  headers: {
    'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': FUB_SYSTEM_KEY,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    event: 'peopleCreated',
    url: 'https://yourapp.com/webhooks/fub/people-created',
  }),
});
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `event` | string | Yes | Webhook event name (e.g., `peopleCreated`, `peopleUpdated`) |
| `url` | string | Yes | HTTPS callback URL |

### GET /v1/webhooks — List Webhooks

```bash
curl https://api.followupboss.com/v1/webhooks \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

### DELETE /v1/webhooks/:id — Delete Webhook

```bash
curl -X DELETE https://api.followupboss.com/v1/webhooks/202 \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

#### Key Webhook Rules

- Only the **account owner** can manage webhooks
- Maximum **2 webhooks per event per system**
- Callback URLs **must be HTTPS**
- Must respond within **10 seconds** with a 2XX status
- FUB retries failed webhooks **5 times over 8 hours**
- Verify `FUB-Signature` header using HMAC SHA256

---

## Pagination

All list endpoints support pagination with these standard parameters:

| Parameter | Type | Description |
|-----------|------|-------------|
| `limit` | integer | Results per page (max 100, default 25) |
| `offset` | integer | Number of results to skip |
| `next` | string | Cursor token for cursor-based pagination |

### Response Metadata

```json
{
  "_metadata": {
    "total": 500,
    "limit": 25,
    "offset": 0,
    "next": "cursor_token_for_next_page"
  }
}
```

> **Best Practice:** Use cursor-based pagination (`next` parameter) instead of `offset` for large result sets. Offset pagination can skip or duplicate records when data changes between requests.

### Cursor Pagination Example

```typescript
let next: string | undefined;
const allPeople: any[] = [];

do {
  const params = new URLSearchParams({ limit: '100' });
  if (next) params.set('next', next);

  const response = await fetch(
    `https://api.followupboss.com/v1/people?${params}`,
    {
      headers: {
        'Authorization': `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`,
        'X-System': 'YourSystem',
        'X-System-Key': FUB_SYSTEM_KEY,
      },
    }
  );
  const data = await response.json();
  allPeople.push(...data.people);
  next = data._metadata?.next;
} while (next);
```

---

## Rate Limiting

- **Sliding window:** 10-second window
- **Global limit:** 250 requests per 10 seconds (with system key)
- **Monitor headers:** `X-RateLimit-Remaining`, `X-RateLimit-Limit`
- **On 429 response:** Back off and retry after the window resets

### Rate Limit Headers

| Header | Description |
|--------|-------------|
| `X-RateLimit-Limit` | Maximum requests allowed in the window |
| `X-RateLimit-Remaining` | Requests remaining in current window |
| `Retry-After` | Seconds to wait before retrying (on 429) |

---

## Common HTTP Status Codes

| Code | Meaning |
|------|---------|
| `200` | Success (resource returned or updated) |
| `201` | Created (new resource) |
| `204` | No content (deleted, or event archived by lead flow) |
| `400` | Bad request (invalid parameters) |
| `401` | Unauthorized (invalid/missing API key) |
| `403` | Forbidden (insufficient permissions) |
| `404` | Not found |
| `409` | Conflict (duplicate resource) |
| `422` | Validation error |
| `429` | Rate limited |
| `500` | Server error |

---

## Error Response Format

```json
{
  "errorCode": 422,
  "errorMessage": "Validation failed",
  "errors": [
    {
      "field": "person.emails",
      "message": "At least one email or phone is required"
    }
  ]
}
```
