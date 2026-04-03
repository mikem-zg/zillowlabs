# API Reference

Complete request/response schemas for all external API endpoints.

## Table of Contents

- [SMS: Send Single](#sms-send-single)
- [SMS: Send Batch](#sms-send-batch)
- [Email: Send Single](#email-send-single)
- [Email: Send Batch](#email-send-batch)
- [Email: List Deliveries](#email-list-deliveries)
- [Email: Get Delivery](#email-get-delivery)
- [Conversations: Get History](#conversations-get-history)
- [Contacts: Bulk Import](#contacts-bulk-import)
- [Jobs: Check Status](#jobs-check-status)

---

## SMS: Send Single

**POST** `/api/external/send`

### Request Body

```json
{
  "message": "string (required, supports {{variable}} templates)",
  "recipient": {
    "phoneNumber": "string (E.164 format, e.g. +15551234567)",
    "zuid": "string (Zillow user ID, alternative to phoneNumber)",
    "firstName": "string (optional)",
    "lastName": "string (optional)",
    "email": "string (optional)"
  },
  "customFields": { "key": "value" },
  "callbackUrl": "string (optional, HTTPS only)"
}
```

`recipient` must include either `phoneNumber` or `zuid`.

### Success Response (200)

```json
{
  "success": true,
  "jobId": "uuid",
  "messageId": "provider-message-id",
  "status": "ok",
  "phoneNumber": "+15551234567",
  "contactId": "uuid",
  "messageContent": "Hello Jane, your appointment is confirmed.",
  "timestamp": "2026-01-15T10:30:00.000Z",
  "deliveryStatus": "queued"
}
```

---

## SMS: Send Batch

**POST** `/api/external/send-batch`

### Request Body

```json
{
  "message": "string (required, supports {{variable}} templates)",
  "recipients": [
    {
      "phoneNumber": "string (optional)",
      "zuid": "string (optional)",
      "customFields": { "key": "value" }
    }
  ],
  "callbackUrl": "string (optional, HTTPS only)"
}
```

- Each recipient must have either `phoneNumber` or `zuid`.
- Maximum 20,000 recipients per batch.

### Success Response (200)

```json
{
  "success": true,
  "jobId": "uuid",
  "totalItems": 500,
  "message": "Job created, processing in background"
}
```

Processing is asynchronous. Poll `/api/external/jobs/:id` for status.

---

## Email: Send Single

**POST** `/api/external/email/send`

### Request Body

```json
{
  "to": "string (required, valid email)",
  "from": "string (required, valid email)",
  "fromName": "string (optional)",
  "subject": "string (required)",
  "text": "string (optional, plain text body)",
  "html": "string (optional, HTML body)",
  "templateId": "string (optional, SendGrid template ID)",
  "dynamicTemplateData": { "key": "value" },
  "metadata": { "key": "value" },
  "cc": ["email@example.com"],
  "bcc": ["email@example.com"]
}
```

At least one of `text`, `html`, or `templateId` is required.

### Success Response (200)

```json
{
  "success": true,
  "emailId": "uuid",
  "messageId": "sendgrid-message-id",
  "status": "sent"
}
```

---

## Email: Send Batch

**POST** `/api/external/email/send-batch`

### Request Body

```json
{
  "from": "string (required, valid email)",
  "fromName": "string (optional)",
  "subject": "string (required, default subject)",
  "text": "string (optional, default plain text)",
  "html": "string (optional, default HTML body)",
  "templateId": "string (optional, SendGrid template ID)",
  "dynamicTemplateData": { "key": "value" },
  "cc": ["email@example.com"],
  "bcc": ["email@example.com"],
  "recipients": [
    {
      "to": "string (required, valid email)",
      "subject": "string (optional, override default)",
      "text": "string (optional, override default)",
      "html": "string (optional, override default)",
      "dynamicTemplateData": { "key": "value" }
    }
  ]
}
```

- At least one of `text`, `html`, or `templateId` is required at the top level.
- Maximum 1,000 recipients per batch.
- Per-recipient fields override the top-level defaults.

### Success Response (200)

```json
{
  "success": true,
  "total": 50,
  "successful": 48,
  "failed": 2,
  "emailIds": ["uuid1", "uuid2"]
}
```

---

## Email: List Deliveries

**GET** `/api/external/email/deliveries`

### Query Parameters

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| limit | number | 50 | Max results (capped at 100) |
| offset | number | 0 | Pagination offset |
| status | string | — | Filter by status |

### Success Response (200)

```json
{
  "success": true,
  "emails": [ ... ],
  "pagination": {
    "total": 150,
    "limit": 50,
    "offset": 0,
    "hasMore": true
  }
}
```

---

## Email: Get Delivery

**GET** `/api/external/email/deliveries/:id`

### Success Response (200)

```json
{
  "success": true,
  "email": {
    "id": "uuid",
    "toEmail": "recipient@example.com",
    "fromEmail": "sender@yourdomain.com",
    "subject": "Welcome!",
    "status": "delivered",
    "sentAt": "2026-01-15T10:30:00.000Z"
  }
}
```

---

## Conversations: Get History

**GET** `/api/external/conversations`

Retrieve a chronologically sorted list of inbound and outbound messages for a given contact. Identify the contact by phone number or ZUID.

### Query Parameters

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| phoneNumber | string | One of phoneNumber or zuid | Contact phone number (E.164 format, e.g. +15551234567) |
| zuid | string | One of phoneNumber or zuid | Unique contact identifier (ZUID) |
| limit | integer | No | Maximum number of messages to return (must be a positive integer) |

### Success Response (200)

```json
{
  "success": true,
  "messages": [
    {
      "direction": "inbound",
      "content": "Hi, I have a question about my account",
      "timestamp": "2026-03-15T10:30:00.000Z",
      "phoneNumber": "+15551234567",
      "status": "received",
      "contact": {
        "id": "contact_abc123",
        "firstName": "John",
        "lastName": "Doe",
        "zuid": "ZUID-12345"
      }
    },
    {
      "direction": "outbound",
      "content": "Hello John! I'd be happy to help.",
      "timestamp": "2026-03-15T10:35:00.000Z",
      "phoneNumber": "+15551234567",
      "status": "delivered",
      "contact": {
        "id": "contact_abc123",
        "firstName": "John",
        "lastName": "Doe",
        "zuid": "ZUID-12345"
      }
    }
  ],
  "total": 2
}
```

### Error Responses

| Status | Condition |
|--------|-----------|
| 400 | Neither phoneNumber nor zuid was provided, or limit is not a positive integer |
| 401 | Missing or invalid API key |
| 404 | No contact found for the given ZUID |
| 500 | Internal error fetching conversation history |

---

## Contacts: Bulk Import

**POST** `/api/external/contacts`

### Request Body

```json
{
  "contacts": [
    {
      "phoneNumber": "string (required)",
      "firstName": "string (optional)",
      "lastName": "string (optional)",
      "email": "string (optional)",
      "zuid": "string (optional)"
    }
  ]
}
```

- Maximum 20,000 contacts per request.
- Processing is asynchronous. Returns a `jobId`.

### Success Response (200)

```json
{
  "success": true,
  "jobId": "uuid",
  "totalItems": 1000,
  "message": "Contact import job created"
}
```

---

## Jobs: Check Status

**GET** `/api/external/jobs/:id`

### Query Parameters

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| include_items | string | "false" | Set to "true" to include individual item results |

### Success Response (200)

```json
{
  "id": "uuid",
  "jobType": "batch",
  "status": "completed",
  "totalItems": 500,
  "processedItems": 498,
  "failedItems": 2,
  "callbackUrl": "https://yourapp.com/webhook",
  "createdAt": "2026-01-15T10:30:00.000Z",
  "completedAt": "2026-01-15T10:35:00.000Z",
  "metadata": {}
}
```

Job statuses: `pending`, `processing`, `completed`, `failed`.

---

## Callback Webhooks

When a `callbackUrl` is provided on SMS send requests, the platform sends delivery status updates as POST requests:

```json
{
  "eventType": "delivered",
  "jobId": "uuid",
  "messageId": "provider-message-id",
  "phoneNumber": "+15551234567",
  "status": "delivered",
  "timestamp": "2026-01-15T10:31:00.000Z",
  "error": null,
  "metadata": {}
}
```

Event types: `delivered`, `failed`, `sent`.

Requests include these headers for verification:
- `X-Webhook-Signature`: HMAC-SHA256 signature of the JSON payload
- `X-Webhook-Timestamp`: ISO 8601 timestamp of the request

The platform retries up to 3 times with exponential backoff (1s, 3s, 9s delays) on failure, with a 5-second timeout per attempt.
