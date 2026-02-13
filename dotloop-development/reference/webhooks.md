# Dotloop Webhooks Reference

Complete guide to dotloop webhook subscriptions, event types, payload formats, signature verification, delivery behavior, and best practices.

---

## Overview

- Webhooks allow subscribing to events in dotloop (Initial Release)
- When events occur, dotloop sends an HTTP POST with a JSON payload to your configured URL
- Events are stored for **90 days** and are queryable via the API
- All webhook endpoints use the base URL: `https://api-gateway.dotloop.com/public/v2/`

---

## All Supported Event Types

### Contact Events

| Event | Description |
|-------|-------------|
| `CONTACT_CREATED` | New contact created |
| `CONTACT_UPDATED` | Contact record updated |

### Loop Events

| Event | Description |
|-------|-------------|
| `LOOP_CREATED` | New loop (transaction) created |
| `LOOP_UPDATED` | Loop details updated |
| `LOOP_DELETED` | Loop deleted |

### Participant Events

| Event | Description |
|-------|-------------|
| `LOOP_PARTICIPANT_CREATED` | Participant added to a loop |
| `LOOP_PARTICIPANT_UPDATED` | Participant details updated |

### Document Events

| Event | Description |
|-------|-------------|
| `DOCUMENT_CREATED` | Document uploaded to a loop |
| `DOCUMENT_UPDATED` | Document updated |

### Folder Events

| Event | Description |
|-------|-------------|
| `FOLDER_CREATED` | Folder created in a loop |
| `FOLDER_UPDATED` | Folder updated |

### Task Events

| Event | Description |
|-------|-------------|
| `TASK_CREATED` | Task created |
| `TASK_UPDATED` | Task updated |
| `TASK_COMPLETED` | Task marked as completed |

### Important: Multiple Events Per Action

A single user action can trigger **MULTIPLE** webhook events. For example:

- Adding a participant to a loop fires both `LOOP_UPDATED` **AND** `LOOP_PARTICIPANT_CREATED`
- Creating a loop with participants via Loop-It fires `LOOP_CREATED`, `LOOP_PARTICIPANT_CREATED` (per participant), and potentially `FOLDER_CREATED`

Design your webhook handler to be idempotent and handle related events arriving in any order.

---

## Subscription Management

All subscription endpoints require Bearer token authentication:

```
Authorization: Bearer <access_token>
```

### Create Subscription

```http
POST https://api-gateway.dotloop.com/public/v2/subscription
Content-Type: application/json
Authorization: Bearer <access_token>
```

**Request body:**

```json
{
  "url": "https://yourapp.com/webhooks/dotloop",
  "eventTypes": ["LOOP_CREATED", "LOOP_UPDATED"],
  "signingKey": "your_secret_key",
  "externalId": "your-foreign-key",
  "enabled": true,
  "profileId": 12345,
  "targetType": "PROFILE",
  "targetId": 789
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | Yes | HTTPS URL where dotloop will POST events |
| `eventTypes` | string[] | Yes | Array of event types to subscribe to |
| `signingKey` | string | No | Secret key for HMAC-SHA1 signature verification |
| `externalId` | string | No | Your foreign key — returned in each webhook payload for correlation |
| `enabled` | boolean | No | Whether the subscription is active (default: `true`) |
| `profileId` | number | No | Profile ID to scope the subscription |
| `targetType` | string | No | Target type filter (e.g., `"PROFILE"`) |
| `targetId` | number | No | Target ID filter |

### List Subscriptions

```http
GET https://api-gateway.dotloop.com/public/v2/subscription?enabled=true&next_cursor=<cursor>
Authorization: Bearer <access_token>
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `enabled` | boolean | Filter by enabled/disabled status |
| `next_cursor` | string | Pagination cursor for next page of results |

### Get Subscription

```http
GET https://api-gateway.dotloop.com/public/v2/subscription/:id
Authorization: Bearer <access_token>
```

### Update Subscription

```http
PATCH https://api-gateway.dotloop.com/public/v2/subscription/:id
Content-Type: application/json
Authorization: Bearer <access_token>

{
  "enabled": false,
  "url": "https://newapp.com/webhooks/dotloop"
}
```

### Delete Subscription

```http
DELETE https://api-gateway.dotloop.com/public/v2/subscription/:id
Authorization: Bearer <access_token>
```

### Query Stored Events

Events are retained for 90 days and can be queried via the API:

```http
GET https://api-gateway.dotloop.com/public/v2/subscription/:id/event
Authorization: Bearer <access_token>
```

This is useful for:
- Recovering missed events after downtime
- Auditing webhook delivery history
- Debugging event processing issues

---

## Webhook Payload Format

When an event occurs, dotloop sends an HTTP POST to your configured URL.

### Request Body

```json
{
  "eventId": "unique-event-id",
  "eventType": "LOOP_CREATED",
  "timestamp": 1691763097001,
  "subscriptionExternalId": "your-foreign-key",
  "event": {
    "id": "12345",
    "profileId": "67890",
    "loopId": "12345"
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `eventId` | string | Unique identifier for this event — use for idempotency |
| `eventType` | string | The event type (e.g., `LOOP_CREATED`, `CONTACT_UPDATED`) |
| `timestamp` | number | Event timestamp in milliseconds since epoch |
| `subscriptionExternalId` | string | The `externalId` you set when creating the subscription |
| `event` | object | Event-specific data containing resource IDs |

### Event Object Fields

The `event` object varies by event type but typically contains:

| Event Category | Fields |
|---------------|--------|
| Contact events | `id` |
| Loop events | `id`, `profileId`, `loopId` |
| Participant events | `id`, `profileId`, `loopId` |
| Document events | `id`, `profileId`, `loopId` |
| Folder events | `id`, `profileId`, `loopId` |
| Task events | `id`, `profileId`, `loopId` |

### Request Headers

Dotloop includes these headers with each webhook POST:

| Header | Description |
|--------|-------------|
| `X-DOTLOOP-TIMESTAMP` | Event timestamp (seconds since epoch) |
| `X-DOTLOOP-SIGNATURE` | HMAC-SHA1 signature (only present if `signingKey` was set on the subscription) |
| `Content-Type` | `application/json` |

---

## Signature Verification (HMAC-SHA1)

If you set a `signingKey` when creating your subscription, dotloop will include an `X-DOTLOOP-SIGNATURE` header with each webhook delivery. Use this to verify that the request genuinely came from dotloop.

### Algorithm

1. Extract the `X-DOTLOOP-TIMESTAMP` header value
2. Extract the raw request body as a string
3. Construct the signed content: `${X-DOTLOOP-TIMESTAMP}.${rawBody}`
4. Compute HMAC-SHA1 of the signed content using your `signingKey`
5. Compare the hex digest to the `X-DOTLOOP-SIGNATURE` header value

### Node.js Example

```typescript
import crypto from 'crypto';

function verifyDotloopSignature(
  rawBody: string,
  timestamp: string,
  signature: string,
  signingKey: string
): boolean {
  const signedContent = `${timestamp}.${rawBody}`;
  const calculated = crypto
    .createHmac('sha1', signingKey)
    .update(signedContent)
    .digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(calculated),
    Buffer.from(signature)
  );
}
```

### Python Example

```python
import hmac
import hashlib

def verify_dotloop_signature(
    raw_body: str,
    timestamp: str,
    signature: str,
    signing_key: str,
) -> bool:
    signed_content = f"{timestamp}.{raw_body}"
    calculated = hmac.new(
        signing_key.encode(),
        signed_content.encode(),
        hashlib.sha1,
    ).hexdigest()
    return hmac.compare_digest(calculated, signature)
```

### PHP Example

```php
function verifyDotloopSignature(
    string $rawBody,
    string $timestamp,
    string $signature,
    string $signingKey
): bool {
    $signedContent = $timestamp . '.' . $rawBody;
    $calculated = hash_hmac('sha1', $signedContent, $signingKey);
    return hash_equals($calculated, $signature);
}
```

---

## Delivery & Retry Logic

### Expected Response

- Your endpoint must return a **2XX status code** within **5 seconds**
- Any non-2XX response or timeout triggers retries

### Retry Schedule

If delivery fails, dotloop retries up to **8 times** with increasing delays:

| Retry | Delay After Previous Attempt |
|-------|------------------------------|
| 1 | 30 seconds |
| 2 | 1 minute |
| 3 | 15 minutes |
| 4 | 30 minutes |
| 5 | 1 hour |
| 6 | 2 hours |
| 7 | 4 hours |
| 8 | 8 hours |

After the final retry, the event is marked as **FAILED**. You can still retrieve it via the event query API (`GET /subscription/:id/event`) for up to 90 days.

### Important Delivery Behaviors

- **Duplicate events are possible** — always implement idempotency using the `eventId` field
- **Events may arrive out of order** — do not depend on delivery order
- **Profile access loss disables subscriptions** — if a user loses access to a profile, webhook subscriptions for that profile are **DISABLED** and will NOT auto-re-enable when access is restored. You must re-enable them manually.

---

## Best Practices

### 1. Return 2XX Immediately, Process Asynchronously

Store the webhook payload in a queue or database, respond with 200, then process asynchronously. This ensures you respond within the 5-second window.

```typescript
app.post('/webhooks/dotloop', (req, res) => {
  // Store immediately
  webhookQueue.push(req.body);
  // Respond immediately
  res.status(200).send();
  // Process later
});
```

### 2. Always Verify Signatures

If you set a `signingKey`, always verify the `X-DOTLOOP-SIGNATURE` header in production to prevent spoofed requests.

### 3. Prevent Replay Attacks

Check the `X-DOTLOOP-TIMESTAMP` header and reject events older than 5 minutes:

```typescript
const eventTimestamp = parseInt(req.headers['x-dotloop-timestamp'] as string, 10);
const now = Math.floor(Date.now() / 1000);
if (Math.abs(now - eventTimestamp) > 300) {
  return res.status(400).send('Stale timestamp');
}
```

### 4. Handle Duplicates Using eventId

Store processed `eventId` values and skip duplicates:

```typescript
const existing = await db.query.webhookEvents.findFirst({
  where: eq(webhookEvents.eventId, payload.eventId),
});
if (existing) return; // Already processed
```

### 5. Fetch Full Resource Data via API

Webhook payloads only contain resource IDs, not full resource data. After receiving a webhook, use the dotloop API to fetch the complete resource:

```typescript
const loop = await dotloopRequest(
  `profile/${event.profileId}/loop/${event.loopId}`,
  accessToken
);
```

### 6. Monitor for Subscription Disabling

When a user loses profile access, subscriptions are silently disabled. Implement periodic checks to verify your subscriptions are still active:

```typescript
const subscriptions = await dotloopRequest('subscription?enabled=true', accessToken);
// Compare against expected subscriptions and re-enable if needed
```

---

## Complete Code Examples

### TypeScript (Express) — Webhook Handler

```typescript
import express from 'express';
import crypto from 'crypto';

const DOTLOOP_WEBHOOK_SIGNING_KEY = process.env.DOTLOOP_WEBHOOK_SIGNING_KEY!;

const app = express();

// Capture raw body for signature verification
app.post('/webhooks/dotloop', express.json({
  verify: (req: any, _res, buf) => {
    req.rawBody = buf.toString();
  },
}), async (req, res) => {
  const timestamp = req.headers['x-dotloop-timestamp'] as string;
  const signature = req.headers['x-dotloop-signature'] as string;

  // 1. Verify signature (if signingKey was set)
  if (DOTLOOP_WEBHOOK_SIGNING_KEY && signature) {
    const signedContent = `${timestamp}.${req.rawBody}`;
    const calculated = crypto
      .createHmac('sha1', DOTLOOP_WEBHOOK_SIGNING_KEY)
      .update(signedContent)
      .digest('hex');

    if (!crypto.timingSafeEqual(Buffer.from(calculated), Buffer.from(signature))) {
      return res.status(401).send('Invalid signature');
    }
  }

  // 2. Check timestamp freshness (reject > 5 min old)
  const eventTimestamp = parseInt(timestamp, 10);
  const now = Math.floor(Date.now() / 1000);
  if (Math.abs(now - eventTimestamp) > 300) {
    return res.status(400).send('Stale timestamp');
  }

  // 3. Extract payload
  const { eventId, eventType, event, subscriptionExternalId } = req.body;

  // 4. Idempotency check
  // const existing = await db.query.webhookEvents.findFirst({
  //   where: eq(webhookEvents.eventId, eventId),
  // });
  // if (existing) return res.status(200).send();

  // 5. Respond immediately
  res.status(200).send();

  // 6. Process asynchronously
  try {
    switch (eventType) {
      case 'LOOP_CREATED':
        console.log(`Loop created: ${event.loopId} in profile ${event.profileId}`);
        // Fetch full loop data via API
        break;

      case 'LOOP_UPDATED':
        console.log(`Loop updated: ${event.loopId}`);
        break;

      case 'LOOP_DELETED':
        console.log(`Loop deleted: ${event.loopId}`);
        break;

      case 'LOOP_PARTICIPANT_CREATED':
        console.log(`Participant added to loop ${event.loopId}: ${event.id}`);
        break;

      case 'DOCUMENT_CREATED':
        console.log(`Document uploaded to loop ${event.loopId}: ${event.id}`);
        break;

      case 'TASK_COMPLETED':
        console.log(`Task completed in loop ${event.loopId}: ${event.id}`);
        break;

      case 'CONTACT_CREATED':
        console.log(`Contact created: ${event.id}`);
        break;

      case 'CONTACT_UPDATED':
        console.log(`Contact updated: ${event.id}`);
        break;

      default:
        console.log(`Unhandled event: ${eventType}`, event);
    }
  } catch (err) {
    console.error(`Error processing ${eventType}:`, err);
  }
});

// Subscription management helpers
async function createSubscription(accessToken: string, config: {
  url: string;
  eventTypes: string[];
  signingKey?: string;
  externalId?: string;
  profileId?: number;
}) {
  const response = await fetch('https://api-gateway.dotloop.com/public/v2/subscription', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      url: config.url,
      eventTypes: config.eventTypes,
      signingKey: config.signingKey,
      externalId: config.externalId,
      enabled: true,
      profileId: config.profileId,
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Failed to create subscription: ${error}`);
  }

  return response.json();
}

async function listSubscriptions(accessToken: string, enabled?: boolean) {
  const url = new URL('https://api-gateway.dotloop.com/public/v2/subscription');
  if (enabled !== undefined) {
    url.searchParams.set('enabled', String(enabled));
  }

  const response = await fetch(url.toString(), {
    headers: { 'Authorization': `Bearer ${accessToken}` },
  });

  return response.json();
}

async function deleteSubscription(accessToken: string, subscriptionId: string) {
  await fetch(`https://api-gateway.dotloop.com/public/v2/subscription/${subscriptionId}`, {
    method: 'DELETE',
    headers: { 'Authorization': `Bearer ${accessToken}` },
  });
}
```

### Python (Flask) — Webhook Handler

```python
import hmac
import hashlib
import json
import os
import time
import requests
from flask import Flask, request

DOTLOOP_WEBHOOK_SIGNING_KEY = os.environ.get("DOTLOOP_WEBHOOK_SIGNING_KEY", "")

app = Flask(__name__)


@app.route("/webhooks/dotloop", methods=["POST"])
def handle_webhook():
    timestamp = request.headers.get("X-DOTLOOP-TIMESTAMP", "")
    signature = request.headers.get("X-DOTLOOP-SIGNATURE", "")
    raw_body = request.get_data(as_text=True)

    # 1. Verify signature (if signingKey was set)
    if DOTLOOP_WEBHOOK_SIGNING_KEY and signature:
        signed_content = f"{timestamp}.{raw_body}"
        calculated = hmac.new(
            DOTLOOP_WEBHOOK_SIGNING_KEY.encode(),
            signed_content.encode(),
            hashlib.sha1,
        ).hexdigest()
        if not hmac.compare_digest(calculated, signature):
            return "Invalid signature", 401

    # 2. Check timestamp freshness (reject > 5 min old)
    try:
        event_timestamp = int(timestamp)
        now = int(time.time())
        if abs(now - event_timestamp) > 300:
            return "Stale timestamp", 400
    except (ValueError, TypeError):
        pass  # Skip check if timestamp is missing or invalid

    # 3. Extract payload
    payload = request.get_json()
    event_id = payload.get("eventId")
    event_type = payload.get("eventType")
    event = payload.get("event", {})
    external_id = payload.get("subscriptionExternalId")

    # 4. Idempotency check
    # if db.webhook_events.find_one({"eventId": event_id}):
    #     return "", 200

    # 5. Process event
    if event_type == "LOOP_CREATED":
        print(f"Loop created: {event.get('loopId')} in profile {event.get('profileId')}")
    elif event_type == "LOOP_UPDATED":
        print(f"Loop updated: {event.get('loopId')}")
    elif event_type == "LOOP_DELETED":
        print(f"Loop deleted: {event.get('loopId')}")
    elif event_type == "LOOP_PARTICIPANT_CREATED":
        print(f"Participant added to loop {event.get('loopId')}: {event.get('id')}")
    elif event_type == "DOCUMENT_CREATED":
        print(f"Document uploaded to loop {event.get('loopId')}: {event.get('id')}")
    elif event_type == "TASK_COMPLETED":
        print(f"Task completed in loop {event.get('loopId')}: {event.get('id')}")
    elif event_type == "CONTACT_CREATED":
        print(f"Contact created: {event.get('id')}")
    elif event_type == "CONTACT_UPDATED":
        print(f"Contact updated: {event.get('id')}")
    else:
        print(f"Unhandled event: {event_type} — {event}")

    return "", 200


# Subscription management helpers
def create_subscription(
    access_token: str,
    url: str,
    event_types: list,
    signing_key: str = None,
    external_id: str = None,
    profile_id: int = None,
) -> dict:
    body = {
        "url": url,
        "eventTypes": event_types,
        "enabled": True,
    }
    if signing_key:
        body["signingKey"] = signing_key
    if external_id:
        body["externalId"] = external_id
    if profile_id:
        body["profileId"] = profile_id

    response = requests.post(
        "https://api-gateway.dotloop.com/public/v2/subscription",
        headers={
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json",
        },
        json=body,
    )
    response.raise_for_status()
    return response.json()


def list_subscriptions(access_token: str, enabled: bool = None) -> dict:
    params = {}
    if enabled is not None:
        params["enabled"] = str(enabled).lower()

    response = requests.get(
        "https://api-gateway.dotloop.com/public/v2/subscription",
        headers={"Authorization": f"Bearer {access_token}"},
        params=params,
    )
    response.raise_for_status()
    return response.json()


def delete_subscription(access_token: str, subscription_id: str) -> None:
    response = requests.delete(
        f"https://api-gateway.dotloop.com/public/v2/subscription/{subscription_id}",
        headers={"Authorization": f"Bearer {access_token}"},
    )
    response.raise_for_status()


def query_events(access_token: str, subscription_id: str) -> dict:
    response = requests.get(
        f"https://api-gateway.dotloop.com/public/v2/subscription/{subscription_id}/event",
        headers={"Authorization": f"Bearer {access_token}"},
    )
    response.raise_for_status()
    return response.json()


if __name__ == "__main__":
    app.run(port=5000)
```

---

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Processing webhook synchronously and timing out | Respond 200 immediately, process async (5-second window) |
| Not handling duplicate deliveries | Use `eventId` for idempotency |
| Expecting full resource data in payload | Payload only has IDs — fetch full data via API |
| Not verifying signatures | Always verify `X-DOTLOOP-SIGNATURE` if `signingKey` is set |
| Ignoring timestamp header | Check `X-DOTLOOP-TIMESTAMP` to prevent replay attacks |
| Not monitoring subscription status | Profile access loss silently disables subscriptions |
| Assuming events arrive in order | Events may arrive out of order — don't depend on sequence |
| Expecting one event per action | A single action can trigger multiple events |
| Not re-enabling disabled subscriptions | When profile access is restored, manually re-enable subscriptions |
