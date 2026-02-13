# Follow Up Boss Embedded Apps Reference

## Overview

Embedded Apps let you load your own application inside the Follow Up Boss UI via an iframe. Your app appears in the lead profile sidebar and inbox, giving agents contextual data without leaving FUB.

**Key facts:**
- Apps are loaded in an **iframe** within the FUB interface
- Must be served over **HTTPS**
- Appears in the **lead profile sidebar** and **inbox**
- Request access to the Embedded Apps program at: https://help.followupboss.com/hc/en-us/articles/360048843753

---

## iframe Configuration

FUB loads your app in a sandboxed iframe with the following permissions:

```html
<iframe sandbox="allow-scripts allow-forms allow-same-origin allow-popups allow-popups-to-escape-sandbox allow-downloads"></iframe>
```

Your app must work within these sandbox restrictions. The `allow-same-origin` permission enables your app to access cookies and local storage. `allow-popups` allows opening new windows (e.g., for OAuth flows).

---

## Required JavaScript

Include the FUB Embedded Apps SDK in your HTML:

```html
<script src="https://eia.followupboss.com/embeddedApps-v1.0.0.js"></script>
```

This script provides communication between your app and the FUB host window.

---

## Context Parameter

When FUB loads your embedded app, it appends query parameters to your URL:

```
https://yourapp.com/fub?context=<base64_encoded>&signature=<hmac_hex>
```

### Decoding the Context

The `context` parameter is a URL-safe base64-encoded JSON string. Decode it to access:

```json
{
  "account": {
    "id": 12345,
    "domain": "myteam",
    "owner": {
      "name": "Jane Smith",
      "email": "jane@example.com"
    }
  },
  "person": {
    "id": 67890,
    "firstName": "John",
    "lastName": "Doe",
    "emails": [
      { "value": "john@example.com", "type": "home" }
    ],
    "phones": [
      { "value": "555-123-4567", "type": "mobile" }
    ],
    "stage": {
      "id": 1,
      "name": "New Lead"
    }
  },
  "user": {
    "id": 111,
    "name": "Agent Sarah",
    "email": "sarah@myteam.com"
  },
  "context": "person"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `account.id` | number | FUB account ID |
| `account.domain` | string | Account subdomain |
| `account.owner` | object | Account owner name and email |
| `person.id` | number | Contact ID being viewed |
| `person.firstName` | string | Contact first name |
| `person.lastName` | string | Contact last name |
| `person.emails` | array | Contact email addresses |
| `person.phones` | array | Contact phone numbers |
| `person.stage` | object | Current stage (id and name) |
| `user.id` | number | Logged-in FUB user ID |
| `user.name` | string | Logged-in user name |
| `user.email` | string | Logged-in user email |
| `context` | string | View context (e.g., `"person"`) |
| `debugState` | string | Only present in preview mode |
| `example` | boolean | Only present in preview mode |

### Decoding Example (TypeScript)

```typescript
function decodeContext(contextParam: string): any {
  const base64 = contextParam.replace(/-/g, '+').replace(/_/g, '/');
  const json = Buffer.from(base64, 'base64').toString('utf-8');
  return JSON.parse(json);
}

// Express route handler
app.get('/fub', (req, res) => {
  const context = decodeContext(req.query.context as string);
  const signature = req.query.signature as string;

  if (!isFromFUB(req.query.context as string, signature)) {
    return res.status(401).send('Unauthorized');
  }

  const personName = `${context.person.firstName} ${context.person.lastName}`;
  // Render your app with the contact context...
});
```

### Decoding Example (Python)

```python
import base64
import json

def decode_context(context_param: str) -> dict:
    padded = context_param + '=' * (4 - len(context_param) % 4)
    decoded = base64.urlsafe_b64decode(padded)
    return json.loads(decoded)

@app.route('/fub')
def embedded_app():
    context_param = request.args.get('context', '')
    signature = request.args.get('signature', '')

    context = decode_context(context_param)
    if not is_from_fub(context_param, signature):
        return 'Unauthorized', 401

    person = context.get('person', {})
    # Render your app with the contact context...
```

---

## Signature Verification (HMAC SHA256)

Always verify the `signature` query parameter to confirm the request came from FUB. Compute an HMAC SHA256 of the raw `context` parameter using your app's secret key.

### JavaScript / Node.js

```javascript
const crypto = require('crypto');

function isFromFUB(context, signature) {
  const calculated = crypto
    .createHmac('sha256', SECRET_KEY)
    .update(context)
    .digest('hex');
  return calculated === signature;
}
```

### Python

```python
import hmac
import hashlib

def is_from_fub(context: str, signature: str) -> bool:
    calculated = hmac.new(
        SECRET_KEY.encode(),
        context.encode(),
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(calculated, signature)
```

### PHP

```php
function isFromFUB($context, $signature) {
    return hash_hmac('sha256', $context, YOUR_SECRET_KEY) === $signature;
}
```

---

## Debug States

When testing your embedded app in FUB's preview mode, you can simulate different states using the `debugState` attribute in the context. Your app must handle each state:

| Debug State | Purpose | What to Show |
|-------------|---------|--------------|
| `working` | Main functional state | Your app's normal UI (required) |
| `account_not_found` | FUB account not linked to your system | Help the user set up / connect their account |
| `user_not_found` | FUB user not recognized in your system | Prompt user to verify identity or create account |
| `person_not_found` | Contact not found in your system | Display "Person not found in our system" message |
| `unauthorized` | User lacks permission | Show access denied / contact admin message |

**Implementation example:**

```typescript
function renderApp(context: any) {
  if (context.debugState) {
    switch (context.debugState) {
      case 'working':
        return renderWorkingState(context);
      case 'account_not_found':
        return renderAccountSetup();
      case 'user_not_found':
        return renderUserNotFound();
      case 'person_not_found':
        return renderPersonNotFound();
      case 'unauthorized':
        return renderUnauthorized();
    }
  }
  // Production: determine state from your own data
  return renderWorkingState(context);
}
```

> **Important:** The `debugState` and `example` attributes only appear in preview mode, never in production. In production, your app must determine the correct state by looking up the account/user/person in your own system.

---

## Identity Mapping

Use the FUB Identity endpoint to map FUB accounts and users to your system:

```
GET /v1/identity
```

This returns the current authenticated user and account information. Use this during initial setup to create the mapping between a FUB account and your system's account.

```typescript
async function mapIdentity(apiKey: string) {
  const response = await fetch('https://api.followupboss.com/v1/identity', {
    headers: {
      'Authorization': `Basic ${Buffer.from(`${apiKey}:`).toString('base64')}`,
      'X-System': 'YourSystem',
      'X-System-Key': SYSTEM_KEY,
    },
  });
  const identity = await response.json();
  // Store mapping: identity.accountId -> your account ID
  // Store mapping: identity.userId -> your user ID
  return identity;
}
```

---

## Security

### Remove X-Frame-Options Header

Your app **must not** send the `X-Frame-Options` header, as it prevents the page from loading in an iframe. If your framework sets this header by default, explicitly remove it:

```typescript
// Express
app.use((_req, res, next) => {
  res.removeHeader('X-Frame-Options');
  next();
});
```

```python
# Flask
@app.after_request
def remove_x_frame(response):
    response.headers.pop('X-Frame-Options', None)
    return response
```

### Verify Signature on Every Request

Never skip signature verification, even for development. Always validate that the `signature` parameter matches the HMAC of the `context` parameter.

### Preview vs Production Attributes

| Attribute | Preview Mode | Production |
|-----------|-------------|------------|
| `debugState` | Present (set by tester) | Never present |
| `example` | Present (`true`) | Never present |

Do not rely on `debugState` or `example` in production logic.

---

## Submission Process

### Step-by-Step

1. **Create your embedded app** in your FUB account (Admin → Integrations → Embedded Apps)
2. **Test all debug states** — verify your app handles `working`, `account_not_found`, `user_not_found`, `person_not_found`, and `unauthorized`
3. **Submit for review** through the FUB interface
4. **FUB reviews** the following:
   - App name and description
   - Thumbnail image
   - App URL (must be HTTPS)
   - Company information
5. FUB may request **test credentials** to verify your app's functionality
6. **Once approved**, your app becomes available to all FUB customers

### Review Checklist

Before submitting, ensure:
- [ ] All 5 debug states render correctly
- [ ] Signature verification is implemented
- [ ] App loads quickly (under 3 seconds)
- [ ] App works in the iframe sandbox
- [ ] HTTPS is configured
- [ ] `X-Frame-Options` header is removed
- [ ] App handles missing or incomplete context gracefully

---

## Styling

- Match FUB's UI styles for a seamless user experience
- There is no strict style guide yet, but FUB may request visual adjustments during the review process
- Keep your UI clean, minimal, and focused on the most relevant data for the contact being viewed
- Avoid scrollbars when possible — design for the sidebar width (~350px)
- Use neutral colors and standard fonts for consistency with FUB's interface

---

## Monitoring

FUB periodically pings your app's URL with a test context to verify availability:

- Your app should handle these health check requests without errors
- Record and log errors properly for debugging
- If your app generates too many errors, FUB will contact you to resolve the issue
- Persistent failures may result in your app being temporarily disabled

---

## Updating Apps

When releasing a new version of your embedded app:

1. **Create a second embedded app** in your FUB account (mark it as "Beta" or "v2.0" in the name)
2. **Test thoroughly** — verify all debug states, signature verification, and core functionality
3. **Submit the new version for review**
4. **Once approved**, update the URL in your existing approved app to point to the new version
5. The original app entry remains active — users experience a seamless transition

> **Tip:** Never update the URL of a live approved app before the new version has been reviewed and approved. This could break the experience for all users.

---

## Complete Example: Express Embedded App

```typescript
import express from 'express';
import crypto from 'crypto';

const app = express();
const SECRET_KEY = process.env.FUB_EMBEDDED_APP_SECRET!;

function decodeContext(contextParam: string): any {
  const base64 = contextParam.replace(/-/g, '+').replace(/_/g, '/');
  const padded = base64 + '='.repeat((4 - base64.length % 4) % 4);
  return JSON.parse(Buffer.from(padded, 'base64').toString('utf-8'));
}

function verifySignature(context: string, signature: string): boolean {
  const calculated = crypto
    .createHmac('sha256', SECRET_KEY)
    .update(context)
    .digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(calculated),
    Buffer.from(signature)
  );
}

app.use((_req, res, next) => {
  res.removeHeader('X-Frame-Options');
  next();
});

app.get('/fub', (req, res) => {
  const contextParam = req.query.context as string;
  const signature = req.query.signature as string;

  if (!contextParam || !signature) {
    return res.status(400).send('Missing context or signature');
  }

  if (!verifySignature(contextParam, signature)) {
    return res.status(401).send('Invalid signature');
  }

  const context = decodeContext(contextParam);

  // Handle debug states in preview mode
  if (context.debugState) {
    return res.send(renderDebugState(context.debugState, context));
  }

  // Production: look up the person in your system
  const person = context.person;
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <script src="https://eia.followupboss.com/embeddedApps-v1.0.0.js"></script>
      <style>
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; padding: 16px; margin: 0; }
        .contact-name { font-size: 18px; font-weight: 600; margin-bottom: 8px; }
        .contact-detail { color: #666; font-size: 14px; margin-bottom: 4px; }
      </style>
    </head>
    <body>
      <div class="contact-name">${person.firstName} ${person.lastName}</div>
      <div class="contact-detail">${person.emails?.[0]?.value || 'No email'}</div>
      <div class="contact-detail">${person.phones?.[0]?.value || 'No phone'}</div>
      <div class="contact-detail">Stage: ${person.stage?.name || 'Unknown'}</div>
    </body>
    </html>
  `);
});

function renderDebugState(state: string, context: any): string {
  const messages: Record<string, string> = {
    working: `Connected! Viewing ${context.person?.firstName || 'contact'}`,
    account_not_found: 'Account not connected. Please set up your integration.',
    user_not_found: 'User not found. Please verify your identity.',
    person_not_found: 'Person not found in our system.',
    unauthorized: 'Access denied. Please contact your administrator.',
  };
  return `
    <!DOCTYPE html>
    <html>
    <head>
      <script src="https://eia.followupboss.com/embeddedApps-v1.0.0.js"></script>
      <style>body { font-family: sans-serif; padding: 16px; }</style>
    </head>
    <body><p>${messages[state] || 'Unknown state'}</p></body>
    </html>
  `;
}

app.listen(5000, () => console.log('Embedded app running on port 5000'));
```

---

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| `X-Frame-Options` header blocks iframe | Explicitly remove the header in your server middleware |
| Not handling URL-safe base64 | Replace `-` with `+` and `_` with `/` before decoding, add padding |
| Relying on `debugState` in production | Only use `debugState` for preview testing — determine state from your own data in production |
| Skipping signature verification | Always verify — prevents unauthorized access to your app |
| App too slow to load | Optimize for <3 second load time; FUB users expect instant sidebar content |
| Not testing all debug states | FUB reviewers check all 5 states during approval |
| Designing for full-width layout | Sidebar is ~350px wide — design accordingly |
