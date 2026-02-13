# Follow Up Boss Webhooks Reference

## Overview

Follow Up Boss webhooks deliver real-time JSON payloads via HTTP POST to your callback URL whenever events occur in a FUB account. This eliminates the need to poll the API for changes.

**Key facts:**
- Only the account **OWNER** can manage (create/delete) webhooks
- The `X-System` header is **REQUIRED** on all `/v1/webhooks` requests
- Callback URLs must be **HTTPS**
- Maximum **2 webhooks per event per system**
- Webhooks deliver batched resource IDs — use the included `uri` to fetch full data

---

## All Supported Webhook Events

### People Events

| Event | Description |
|-------|-------------|
| `peopleCreated` | New contact created |
| `peopleUpdated` | Contact record updated |
| `peopleDeleted` | Contact deleted (all associated notes, calls, texts also deleted — no separate delete events fire for those) |
| `peopleTagsCreated` | Tags added to a contact (payload includes tag names in `data.tags`) |
| `peopleStageUpdated` | Contact stage changed (payload includes stage name in `data.stage`) |
| `peopleRelationshipCreated` | Relationship created between contacts |
| `peopleRelationshipUpdated` | Relationship updated |
| `peopleRelationshipDeleted` | Relationship removed |

**`peopleUpdated` triggers on changes to:** name, emails, phones, addresses, price, background, assignedTo, assignedUserId, assignedLenderName, assignedLenderId, contacted, stage, source, tags, custom fields, relationships.

### Notes Events

| Event | Description |
|-------|-------------|
| `notesCreated` | Note added to a contact |
| `notesUpdated` | Note content updated |
| `notesDeleted` | Note deleted |

### Tasks Events

| Event | Description |
|-------|-------------|
| `tasksCreated` | Task created |
| `tasksUpdated` | Task updated |
| `tasksDeleted` | Task deleted |

### Deals Events

| Event | Description |
|-------|-------------|
| `dealsCreated` | Deal created |
| `dealsUpdated` | Deal updated (does NOT fire for file/attachment changes) |
| `dealsDeleted` | Deal deleted |

### Appointments Events

| Event | Description |
|-------|-------------|
| `appointmentsCreated` | Appointment created |
| `appointmentsUpdated` | Appointment updated |
| `appointmentsDeleted` | Appointment deleted |

> **Note:** Appointment webhooks only fire for appointments created directly in FUB, NOT for appointments synced from external calendars (Google Calendar, Outlook, etc.).

### Text Messages Events

| Event | Description |
|-------|-------------|
| `textMessagesCreated` | Text message sent or received |
| `textMessagesUpdated` | Text message updated |
| `textMessagesDeleted` | Text message deleted |

### Calls Events

| Event | Description |
|-------|-------------|
| `callsCreated` | Call logged |
| `callsUpdated` | Call record updated |
| `callsDeleted` | Call record deleted |

### Emails Events

| Event | Description |
|-------|-------------|
| `emailsCreated` | Email sent or received |
| `emailsUpdated` | Email updated |
| `emailsDeleted` | Email deleted |

### Reactions Events (Beta)

| Event | Description |
|-------|-------------|
| `reactionCreated` | Reaction added (payload includes `refType`, `refId`, `refUri`) |
| `reactionDeleted` | Reaction removed (payload includes `refType`, `refId`, `refUri`) |

### Threaded Replies Events (Beta)

| Event | Description |
|-------|-------------|
| `threadedReplyCreated` | Threaded reply created |
| `threadedReplyUpdated` | Threaded reply updated |
| `threadedReplyDeleted` | Threaded reply deleted |

### Email Marketing Events

| Event | Description |
|-------|-------------|
| `emEventsOpened` | Marketing email opened |
| `emEventsClicked` | Marketing email link clicked |
| `emEventsUnsubscribed` | Contact unsubscribed from marketing emails |

### Stages Events

| Event | Description |
|-------|-------------|
| `stageCreated` | Stage configuration created |
| `stageUpdated` | Stage configuration updated |
| `stageDeleted` | Stage configuration deleted |

> **Important:** These fire when stage definitions are changed in account settings, NOT when a lead's stage changes. For lead stage changes, use `peopleStageUpdated`.

### People Events (IDX)

| Event | Description |
|-------|-------------|
| `eventsCreated` | IDX website actions (property views, searches, favorites) |

### Pipelines Events

| Event | Description |
|-------|-------------|
| `pipelineCreated` | Pipeline created |
| `pipelineUpdated` | Pipeline updated |
| `pipelineDeleted` | Pipeline deleted |

### Pipeline Stages Events

| Event | Description |
|-------|-------------|
| `pipelineStageCreated` | Pipeline stage created |
| `pipelineStageUpdated` | Pipeline stage updated |
| `pipelineStageDeleted` | Pipeline stage deleted |

### Custom Fields Events

| Event | Description |
|-------|-------------|
| `customFieldsCreated` | Custom field definition created |
| `customFieldsUpdated` | Custom field definition updated |
| `customFieldsDeleted` | Custom field definition deleted |

> **Note:** These fire for custom field configuration changes only, NOT when custom field values change on a contact. Value changes trigger `peopleUpdated`.

### Deal Custom Fields Events

| Event | Description |
|-------|-------------|
| `dealCustomFieldsCreated` | Deal custom field definition created |
| `dealCustomFieldsUpdated` | Deal custom field definition updated |
| `dealCustomFieldsDeleted` | Deal custom field definition deleted |

---

## Webhook Payload Format

Every webhook POST delivers a JSON body with the following structure:

```json
{
  "eventId": "152d60c0-79da-4018-a9af-28aec8a71c94",
  "eventCreated": "2016-12-12T15:19:21+00:00",
  "event": "peopleCreated",
  "resourceIds": [1234, 3244, 3232],
  "uri": "https://api.followupboss.com/v1/people?id=1234,3244,3232"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `eventId` | string (UUID) | Unique identifier for this webhook delivery |
| `eventCreated` | string (ISO 8601) | Timestamp when the event occurred |
| `event` | string | Event type (e.g., `peopleCreated`, `dealsUpdated`) |
| `resourceIds` | number[] | Array of affected resource IDs |
| `uri` | string | API URL to fetch the full resource data |

Some events include additional `data` fields:
- `peopleTagsCreated` includes `data.tags` — array of tag names
- `peopleStageUpdated` includes `data.stage` — stage name string
- `reactionCreated` / `reactionDeleted` include `refType`, `refId`, `refUri`

---

## Registering Webhooks

**Endpoint:** `POST /v1/webhooks`

**Required headers:**
- `Authorization: Basic <base64(apiKey:)>`
- `X-System: YourSystem`
- `X-System-Key: your-system-key`
- `Content-Type: application/json`

**Request body:**

```json
{
  "event": "peopleCreated",
  "url": "https://yourapp.com/webhooks/fub/people-created"
}
```

**Limits:** Maximum 2 webhooks per event per system.

**Example:**

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

---

## Receiving Webhooks

Your callback endpoint must:

1. Accept **HTTP POST** requests
2. Parse the **JSON body**
3. Respond within **10 seconds** with a **2XX status code** (200 or 204)
4. Be accessible via **HTTPS**

If your endpoint does not respond within 10 seconds, FUB considers the delivery failed and will retry.

---

## Retry Logic

When a webhook delivery fails (non-2XX response or timeout), FUB retries up to **5 times** over approximately **8 hours**:

| Retry | Delay After Previous Attempt |
|-------|------------------------------|
| 1 | 1 minute |
| 2 | 5 minutes |
| 3 | 5 minutes |
| 4 | 10 minutes |
| 5 | 30 minutes |

After 5 failed retries, the webhook delivery is abandoned for that event.

---

## Signature Verification

FUB includes a `FUB-Signature` header with each webhook request. Use this to verify that the request genuinely came from Follow Up Boss.

Verify the signature by computing an HMAC SHA256 of the raw request body using your webhook secret, then comparing it to the `FUB-Signature` header value.

```typescript
import crypto from 'crypto';

function verifyFubSignature(rawBody: string, signature: string, secret: string): boolean {
  const calculated = crypto.createHmac('sha256', secret).update(rawBody).digest('hex');
  return crypto.timingSafeEqual(Buffer.from(calculated), Buffer.from(signature));
}
```

```python
import hmac
import hashlib

def verify_fub_signature(raw_body: bytes, signature: str, secret: str) -> bool:
    calculated = hmac.new(secret.encode(), raw_body, hashlib.sha256).hexdigest()
    return hmac.compare_digest(calculated, signature)
```

---

## Disabling Webhooks

You can signal FUB to automatically disable a webhook by returning specific HTTP status codes:

| Status Code | Effect |
|-------------|--------|
| **406 Not Acceptable** | FUB disables the webhook |
| **410 Gone** | FUB disables the webhook |

This is useful when decommissioning an endpoint or when your application no longer needs a particular webhook.

---

## Best Practices

### Decouple Receipt from Processing

Store the webhook payload immediately (in a database or queue), respond with 200, then process asynchronously. This ensures you respond within the 10-second window.

```typescript
app.post('/webhooks/fub', async (req, res) => {
  await db.insert(webhookQueue).values({
    eventId: req.body.eventId,
    event: req.body.event,
    payload: JSON.stringify(req.body),
    status: 'pending',
  });
  res.status(200).send();
});
```

### Fetch Full Data from the Resource URI

Webhook payloads contain resource IDs and a `uri` field — they do NOT contain the full resource data. Always GET the `uri` to fetch complete records:

```typescript
const response = await fetch(webhookPayload.uri, {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${API_KEY}:`).toString('base64')}`,
    'X-System': 'YourSystem',
    'X-System-Key': SYSTEM_KEY,
  },
});
const fullData = await response.json();
```

### Never Use API Keys in Callback URLs

Use opaque identifiers or tokens instead:

```
✅ https://yourapp.com/webhooks/fub/abc123-opaque-id
❌ https://yourapp.com/webhooks/fub?apiKey=sk_live_xxx
```

### Handle Batch Updates

Bulk operations in FUB (applying tags to multiple contacts, stage changes) may result in multiple webhook deliveries or a single delivery with multiple `resourceIds`. Always iterate over the `resourceIds` array.

### Idempotency

Use the `eventId` field to deduplicate webhook deliveries. Store processed `eventId` values and skip duplicates:

```typescript
const existing = await db.query.webhookEvents.findFirst({
  where: eq(webhookEvents.eventId, payload.eventId),
});
if (existing) return; // Already processed
```

---

## Code Examples

### TypeScript (Express) Webhook Handler

```typescript
import express from 'express';
import crypto from 'crypto';

const app = express();

app.post('/webhooks/fub', express.json({ verify: (req: any, _res, buf) => {
  req.rawBody = buf.toString();
}}), async (req, res) => {
  const signature = req.headers['fub-signature'] as string;
  const webhookSecret = process.env.FUB_WEBHOOK_SECRET!;

  if (signature) {
    const calculated = crypto
      .createHmac('sha256', webhookSecret)
      .update(req.rawBody)
      .digest('hex');
    if (!crypto.timingSafeEqual(Buffer.from(calculated), Buffer.from(signature))) {
      return res.status(401).send('Invalid signature');
    }
  }

  const { eventId, event, resourceIds, uri } = req.body;

  console.log(`Received ${event} for resources: ${resourceIds.join(', ')}`);

  switch (event) {
    case 'peopleCreated':
      await handlePeopleCreated(resourceIds, uri);
      break;
    case 'peopleUpdated':
      await handlePeopleUpdated(resourceIds, uri);
      break;
    case 'dealsCreated':
      await handleDealsCreated(resourceIds, uri);
      break;
    default:
      console.log(`Unhandled event: ${event}`);
  }

  res.status(200).send();
});

async function handlePeopleCreated(resourceIds: number[], uri: string) {
  const response = await fetch(uri, {
    headers: {
      'Authorization': `Basic ${Buffer.from(`${process.env.FUB_API_KEY}:`).toString('base64')}`,
      'X-System': process.env.FUB_SYSTEM!,
      'X-System-Key': process.env.FUB_SYSTEM_KEY!,
    },
  });
  const data = await response.json();
  for (const person of data.people) {
    console.log(`New contact: ${person.firstName} ${person.lastName}`);
  }
}

async function handlePeopleUpdated(resourceIds: number[], uri: string) {
  console.log(`People updated: ${resourceIds.join(', ')}`);
}

async function handleDealsCreated(resourceIds: number[], uri: string) {
  console.log(`Deals created: ${resourceIds.join(', ')}`);
}
```

### Python (Flask) Webhook Handler

```python
import hmac
import hashlib
import os
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

FUB_API_KEY = os.environ['FUB_API_KEY']
FUB_SYSTEM = os.environ['FUB_SYSTEM']
FUB_SYSTEM_KEY = os.environ['FUB_SYSTEM_KEY']
FUB_WEBHOOK_SECRET = os.environ.get('FUB_WEBHOOK_SECRET', '')

@app.route('/webhooks/fub', methods=['POST'])
def handle_webhook():
    signature = request.headers.get('FUB-Signature', '')
    if FUB_WEBHOOK_SECRET and signature:
        calculated = hmac.new(
            FUB_WEBHOOK_SECRET.encode(),
            request.get_data(),
            hashlib.sha256
        ).hexdigest()
        if not hmac.compare_digest(calculated, signature):
            return 'Invalid signature', 401

    payload = request.get_json()
    event = payload.get('event')
    resource_ids = payload.get('resourceIds', [])
    uri = payload.get('uri', '')
    event_id = payload.get('eventId', '')

    print(f"Received {event} for resources: {resource_ids}")

    if event == 'peopleCreated':
        handle_people_created(resource_ids, uri)
    elif event == 'peopleUpdated':
        handle_people_updated(resource_ids, uri)
    elif event == 'dealsCreated':
        handle_deals_created(resource_ids, uri)
    else:
        print(f"Unhandled event: {event}")

    return '', 200

def handle_people_created(resource_ids, uri):
    response = requests.get(
        uri,
        auth=(FUB_API_KEY, ''),
        headers={
            'X-System': FUB_SYSTEM,
            'X-System-Key': FUB_SYSTEM_KEY,
        }
    )
    data = response.json()
    for person in data.get('people', []):
        print(f"New contact: {person.get('firstName')} {person.get('lastName')}")

def handle_people_updated(resource_ids, uri):
    print(f"People updated: {resource_ids}")

def handle_deals_created(resource_ids, uri):
    print(f"Deals created: {resource_ids}")

if __name__ == '__main__':
    app.run(port=5000)
```

---

## Listing and Deleting Webhooks

### List All Webhooks

```bash
curl https://api.followupboss.com/v1/webhooks \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

### Delete a Webhook

```bash
curl -X DELETE https://api.followupboss.com/v1/webhooks/{webhookId} \
  -u "$FUB_API_KEY:" \
  -H "X-System: YourSystem" \
  -H "X-System-Key: $FUB_SYSTEM_KEY"
```

---

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Processing webhook synchronously and timing out | Decouple: store payload, respond 200, process async |
| Not handling duplicate deliveries | Use `eventId` for idempotency |
| Expecting full resource data in payload | Payload only has IDs — GET the `uri` for full data |
| Using non-HTTPS callback URLs | Always use HTTPS |
| Not verifying `FUB-Signature` | Always verify in production to prevent spoofed requests |
| Assuming `peopleDeleted` fires for associated data | When a person is deleted, associated notes/calls/texts are also deleted without separate events |
| Confusing `stageUpdated` with `peopleStageUpdated` | `stageUpdated` = stage config change; `peopleStageUpdated` = lead moved to different stage |
| Expecting appointment webhooks for synced calendars | Only FUB-native appointments trigger webhooks |
