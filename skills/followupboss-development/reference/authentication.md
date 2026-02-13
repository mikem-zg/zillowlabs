# Follow Up Boss Authentication Reference

Complete guide to authenticating with the Follow Up Boss API. Covers system registration, API key authentication, OAuth 2.0 flows, permission levels, and security best practices.

---

## 1. System Registration (Required First Step)

Before making any API calls, you must register your system at:
**https://apps.followupboss.com/system-registration**

Upon registration you receive two values:

| Header | Description | Example |
|--------|-------------|---------|
| `X-System` | Your registered system name | `AwesomeWebsiteBuilder` |
| `X-System-Key` | Your system's unique key | `560270f7914b5b4a5f4dc1793ebc2796` |

These headers are **required on EVERY API request**:

```
X-System: AwesomeWebsiteBuilder
X-System-Key: 560270f7914b5b4a5f4dc1793ebc2796
```

### Key Concepts

- **System headers identify YOUR SOFTWARE**, not the end user. They remain the same across all API requests regardless of which FUB user's API key is being used.
- **"source"** describes the lead's marketing origin (e.g., `"Zillow.com"`, `"MyWebsite.com"`) — where the lead came from.
- **"system"** describes the software making the API request (e.g., `"AwesomeWebsiteBuilder"`) — what is sending the data.
- These are different concepts: a single system can submit leads from many sources.

### Without System Registration

- API calls still work but are subject to stricter rate limits (50 req/10s vs 250 req/10s).
- You cannot create OAuth apps.
- You cannot register webhooks.
- FUB cannot identify or support your integration.

---

## 2. HTTP Basic Authentication (API Key)

### Getting an API Key

Every FUB user has a unique API key, generated from **Admin → API** in the FUB dashboard.

**Important:** The key is shown only once when created — copy it immediately. If lost, generate a new one (the old key is invalidated).

### How It Works

Use the API key as the **username** in HTTP Basic Auth. The password can be blank or any value (it is ignored).

```
Authorization: Basic base64(API_KEY:)
```

The trailing colon after the API key is required — it separates username from password in Basic Auth format.

### HTTPS Required

All API requests must use HTTPS. HTTP requests will fail. HTTPS ensures the API key is encrypted in transit.

### Permission Levels

The API key inherits the same access level as the user it belongs to:

| Role | Access |
|------|--------|
| **Owner** | Everything, including webhook management |
| **Admin (Broker)** | Most access, but **NOT** webhooks |
| **Agent** | Only contacts assigned to them or contacts they are collaborating on |
| **Lender** | Similar to Agent, with even fewer available actions |

**Webhook note:** Only Owner-level API keys can create, list, or delete webhooks. Admin/Agent/Lender keys will receive a 403 when attempting webhook operations.

### Expired Accounts

When a FUB account's subscription expires:

- The API key remains valid during the grace period.
- `POST /v1/events` continues to work (ensures no lead data is lost).
- Most other endpoints return `403 Forbidden`.
- Once the grace period ends, all endpoints return 403.

### TypeScript Example — API Key Auth

```typescript
import fetch from 'node-fetch';

const FUB_API_KEY = process.env.FUB_API_KEY!;
const FUB_SYSTEM = process.env.FUB_SYSTEM!;
const FUB_SYSTEM_KEY = process.env.FUB_SYSTEM_KEY!;

async function fubRequest(endpoint: string, options: RequestInit = {}) {
  const url = `https://api.followupboss.com/v1/${endpoint}`;
  const authHeader = `Basic ${Buffer.from(`${FUB_API_KEY}:`).toString('base64')}`;

  const response = await fetch(url, {
    ...options,
    headers: {
      'Authorization': authHeader,
      'Content-Type': 'application/json',
      'X-System': FUB_SYSTEM,
      'X-System-Key': FUB_SYSTEM_KEY,
      ...options.headers,
    },
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`FUB API ${response.status}: ${body}`);
  }

  return response.json();
}

// Usage
const people = await fubRequest('people?limit=10');
console.log(people);
```

### Python Example — API Key Auth

```python
import os
import requests

FUB_API_KEY = os.environ["FUB_API_KEY"]
FUB_SYSTEM = os.environ["FUB_SYSTEM"]
FUB_SYSTEM_KEY = os.environ["FUB_SYSTEM_KEY"]

def fub_request(endpoint: str, method: str = "GET", json_data: dict = None) -> dict:
    url = f"https://api.followupboss.com/v1/{endpoint}"
    response = requests.request(
        method,
        url,
        auth=(FUB_API_KEY, ""),
        headers={
            "X-System": FUB_SYSTEM,
            "X-System-Key": FUB_SYSTEM_KEY,
            "Content-Type": "application/json",
        },
        json=json_data,
    )
    response.raise_for_status()
    return response.json()

# Usage
people = fub_request("people", method="GET")
print(people)
```

### Python Example — Using the follow-up-boss SDK

```python
from follow_up_boss import FollowUpBossApiClient

client = FollowUpBossApiClient(
    api_key=os.environ["FUB_API_KEY"],
    x_system=os.environ["FUB_SYSTEM"],
    x_system_key=os.environ["FUB_SYSTEM_KEY"],
)

people = client.people.get_all()
```

---

## 3. OAuth 2.0 Authorization Code Flow

Use OAuth 2.0 for multi-tenant applications and partner integrations where you need to access FUB on behalf of many different FUB accounts without collecting their API keys.

FUB implements the standard **OAuth 2.0 Authorization Code Grant** flow.

### Prerequisites

1. **Registered System** — You must have `X-System` and `X-System-Key` from system registration.
2. **Redirect URIs** — Must be publicly accessible, use HTTPS, and accept GET requests.
3. **NO localhost redirects** — FUB does not allow `localhost` or `127.0.0.1` as redirect URIs. Use a tunnel service (e.g., ngrok) during development.

### Step 1: Create an OAuth Client App

```http
POST https://api.followupboss.com/v1/oauthApps
X-System: YourSystem
X-System-Key: your_system_key
Content-Type: application/json

{
  "redirectUris": ["https://yoursite.com/oauth/redirect"]
}
```

**Response:**

```json
{
  "clientId": "your_client_id",
  "clientSecret": "your_client_secret_SAVE_THIS"
}
```

> **CRITICAL:** `clientSecret` is only returned on creation. Store it securely immediately. There is no way to retrieve it later — you would need to create a new OAuth app.

### Step 2: Request User Consent

Redirect the user's browser to the FUB authorization page:

```
GET https://app.followupboss.com/oauth/authorize
  ?response_type=auth_code
  &client_id=<your_client_id>
  &redirect_uri=<url_encoded_redirect_uri>
  &state=<opaque_csrf_value>
  &prompt=login
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `response_type` | Yes | Must be `auth_code` |
| `client_id` | Yes | Your OAuth client ID from Step 1 |
| `redirect_uri` | Yes | URL-encoded redirect URI (must match one registered in Step 1) |
| `state` | Yes | Opaque value for CSRF protection — returned unchanged in the callback |
| `prompt` | No | Set to `login` to force the user to re-authenticate |

### Step 3: Receive the Authorization Grant

After the user approves (or denies) access, FUB redirects the user's browser back to your `redirect_uri` with query parameters:

**Approved:**
```
https://yoursite.com/oauth/redirect?response=approved&code=AUTH_CODE_HERE&state=your_state_value
```

**Denied:**
```
https://yoursite.com/oauth/redirect?response=denied&state=your_state_value
```

| Parameter | Description |
|-----------|-------------|
| `response` | `approved` or `denied` |
| `code` | The authorization code (only present if approved) — one-time use, expires in 15 minutes |
| `state` | The same value you sent in Step 2 — verify this matches to prevent CSRF attacks |

### Step 4: Exchange the Authorization Code for Tokens

```http
POST https://app.followupboss.com/oauth/token
Authorization: Basic base64(client_id:client_secret)
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&code=AUTH_CODE_HERE&redirect_uri=https%3A%2F%2Fyoursite.com%2Foauth%2Fredirect&state=your_state_value
```

**Response:**

```json
{
  "access_token": "eyJhbGciOi...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "dGhpcyBpcyBh..."
}
```

**Important notes:**
- The `Authorization` header uses your `client_id` and `client_secret` (not the user's API key).
- The `Content-Type` must be `application/x-www-form-urlencoded` (not JSON).
- The `redirect_uri` must match exactly what was used in Step 2.
- The authorization code is single-use — it is invalidated after this exchange.

### Step 5: Make Authenticated Requests

Use the access token as a Bearer token. System headers are still required.

```http
GET https://api.followupboss.com/v1/people?limit=10
Authorization: Bearer eyJhbGciOi...
X-System: YourSystem
X-System-Key: your_system_key
```

### Step 6: Refresh the Access Token

Access tokens expire after 60 minutes. Use the refresh token to get a new access token without requiring user interaction:

```http
POST https://app.followupboss.com/oauth/token
Authorization: Basic base64(client_id:client_secret)
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&refresh_token=dGhpcyBpcyBh...
```

**Response:**

```json
{
  "access_token": "new_access_token...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "new_or_same_refresh_token..."
}
```

### Token Lifetimes

| Token | Lifetime |
|-------|----------|
| Authorization Code | 15 minutes, or immediately after first use (one-time) |
| Access Token | 60 minutes |
| Refresh Token | Never expires, unless unused for 90 consecutive days |

### OAuth Error Codes

| Error Code | Description |
|------------|-------------|
| `server_error` | Internal error on FUB's side — retry with backoff |
| `invalid_client` | Bad `client_id` or `client_secret` |
| `invalid_grant` | Auth code expired, already used, or refresh token invalid |
| `unauthorized_client` | Client not authorized for this grant type |
| `unsupported_grant_type` | Must be `authorization_code` or `refresh_token` |
| `invalid_request` | Missing or malformed parameters |

### Updating Your OAuth Client App

To update redirect URIs for an existing OAuth app:

```http
PUT https://api.followupboss.com/v1/oauthApps
X-System: YourSystem
X-System-Key: your_system_key
Content-Type: application/json

{
  "redirectUris": ["https://newurl.com/oauth/callback"]
}
```

### TypeScript Example — Complete OAuth Flow

```typescript
import express from 'express';
import fetch from 'node-fetch';

const CLIENT_ID = process.env.FUB_OAUTH_CLIENT_ID!;
const CLIENT_SECRET = process.env.FUB_OAUTH_CLIENT_SECRET!;
const REDIRECT_URI = 'https://yourapp.com/oauth/callback';
const FUB_SYSTEM = process.env.FUB_SYSTEM!;
const FUB_SYSTEM_KEY = process.env.FUB_SYSTEM_KEY!;

const app = express();

// Step 2: Redirect user to FUB authorization page
app.get('/oauth/start', (req, res) => {
  const state = crypto.randomUUID();
  // Store state in session for CSRF verification
  req.session.oauthState = state;

  const authUrl = new URL('https://app.followupboss.com/oauth/authorize');
  authUrl.searchParams.set('response_type', 'auth_code');
  authUrl.searchParams.set('client_id', CLIENT_ID);
  authUrl.searchParams.set('redirect_uri', REDIRECT_URI);
  authUrl.searchParams.set('state', state);
  authUrl.searchParams.set('prompt', 'login');

  res.redirect(authUrl.toString());
});

// Step 3 & 4: Handle callback, exchange code for tokens
app.get('/oauth/callback', async (req, res) => {
  const { response, code, state } = req.query;

  // Verify CSRF state
  if (state !== req.session.oauthState) {
    return res.status(403).send('Invalid state parameter');
  }

  if (response === 'denied') {
    return res.send('Authorization denied by user');
  }

  // Exchange auth code for tokens
  const basicAuth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64');

  const tokenResponse = await fetch('https://app.followupboss.com/oauth/token', {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${basicAuth}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      grant_type: 'authorization_code',
      code: code as string,
      redirect_uri: REDIRECT_URI,
      state: state as string,
    }).toString(),
  });

  const tokens = await tokenResponse.json();

  // Store tokens securely (database, encrypted storage, etc.)
  // tokens.access_token, tokens.refresh_token, tokens.expires_in

  res.send('Connected to Follow Up Boss!');
});

// Step 5: Make authenticated requests with access token
async function fubOAuthRequest(accessToken: string, endpoint: string) {
  const response = await fetch(`https://api.followupboss.com/v1/${endpoint}`, {
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'X-System': FUB_SYSTEM,
      'X-System-Key': FUB_SYSTEM_KEY,
    },
  });

  if (response.status === 401) {
    // Access token expired — trigger refresh flow
    throw new Error('TOKEN_EXPIRED');
  }

  return response.json();
}

// Step 6: Refresh access token
async function refreshAccessToken(refreshToken: string) {
  const basicAuth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64');

  const response = await fetch('https://app.followupboss.com/oauth/token', {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${basicAuth}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token: refreshToken,
    }).toString(),
  });

  if (!response.ok) {
    throw new Error('Failed to refresh token — user may need to re-authorize');
  }

  return response.json();
}
```

### Python Example — Complete OAuth Flow

```python
import os
import secrets
from urllib.parse import urlencode
import requests
from flask import Flask, redirect, request, session

CLIENT_ID = os.environ["FUB_OAUTH_CLIENT_ID"]
CLIENT_SECRET = os.environ["FUB_OAUTH_CLIENT_SECRET"]
REDIRECT_URI = "https://yourapp.com/oauth/callback"
FUB_SYSTEM = os.environ["FUB_SYSTEM"]
FUB_SYSTEM_KEY = os.environ["FUB_SYSTEM_KEY"]

app = Flask(__name__)
app.secret_key = os.environ["FLASK_SECRET_KEY"]

# Step 2: Redirect user to FUB authorization page
@app.route("/oauth/start")
def oauth_start():
    state = secrets.token_urlsafe(32)
    session["oauth_state"] = state

    params = urlencode({
        "response_type": "auth_code",
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "state": state,
        "prompt": "login",
    })
    return redirect(f"https://app.followupboss.com/oauth/authorize?{params}")

# Step 3 & 4: Handle callback, exchange code for tokens
@app.route("/oauth/callback")
def oauth_callback():
    if request.args.get("state") != session.get("oauth_state"):
        return "Invalid state parameter", 403

    if request.args.get("response") == "denied":
        return "Authorization denied by user"

    code = request.args["code"]
    state = request.args["state"]

    token_response = requests.post(
        "https://app.followupboss.com/oauth/token",
        auth=(CLIENT_ID, CLIENT_SECRET),
        data={
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": REDIRECT_URI,
            "state": state,
        },
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    token_response.raise_for_status()
    tokens = token_response.json()

    # Store tokens securely (database, encrypted storage, etc.)
    # tokens["access_token"], tokens["refresh_token"], tokens["expires_in"]

    return "Connected to Follow Up Boss!"

# Step 5: Make authenticated requests
def fub_oauth_request(access_token: str, endpoint: str) -> dict:
    response = requests.get(
        f"https://api.followupboss.com/v1/{endpoint}",
        headers={
            "Authorization": f"Bearer {access_token}",
            "X-System": FUB_SYSTEM,
            "X-System-Key": FUB_SYSTEM_KEY,
        },
    )
    if response.status_code == 401:
        raise Exception("TOKEN_EXPIRED")
    response.raise_for_status()
    return response.json()

# Step 6: Refresh access token
def refresh_access_token(refresh_token: str) -> dict:
    response = requests.post(
        "https://app.followupboss.com/oauth/token",
        auth=(CLIENT_ID, CLIENT_SECRET),
        data={
            "grant_type": "refresh_token",
            "refresh_token": refresh_token,
        },
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    response.raise_for_status()
    return response.json()
```

---

## 4. Choosing an Auth Method

| Criteria | API Key | OAuth 2.0 |
|----------|---------|-----------|
| Single user / single account | ✅ Yes | Overkill |
| Multi-tenant SaaS | ❌ No | ✅ Yes |
| Partner integration | ❌ No | ✅ Yes |
| Quick prototype / testing | ✅ Yes | ❌ No |
| User manages their own key | ✅ Yes | ❌ No |
| Automated token refresh needed | N/A (keys don't expire) | ✅ Yes |
| No user interaction for auth | ✅ Yes | ❌ No (initial consent required) |
| Granular token revocation | ❌ No (key = full access) | ✅ Yes |

### Decision Guide

- **Use API Key** when you are building for a single FUB account, an internal integration, or a quick prototype. The user provides their API key and you store it securely.
- **Use OAuth 2.0** when you are building a product that multiple FUB customers will connect to. OAuth lets each customer authorize your app without sharing their API key.

---

## 5. Security Best Practices

### API Key Security

- **Never expose API keys in client-side code** — JavaScript running in the browser, mobile app source code, or public repositories.
- **Never include API keys in webhook callback URLs** — use opaque identifiers to map callbacks to accounts.
- **Store keys as environment variables** — never hardcode in source files.
- **Use a server-side proxy** for browser-based apps — the browser calls your server, your server calls FUB.
- **Rotate keys immediately if compromised** — go to Admin → API → generate a new key (the old one is invalidated).

### OAuth Security

- **Always validate the `state` parameter** in the callback to prevent CSRF attacks.
- **Store `clientSecret` encrypted** — treat it like a password.
- **Store refresh tokens encrypted** in your database — they provide long-lived access.
- **Implement token refresh proactively** — refresh before expiration (e.g., at 50 minutes) rather than waiting for a 401.
- **Handle refresh token expiration gracefully** — if a refresh token fails (unused for 90 days), prompt the user to re-authorize.

### General

- **HTTPS is mandatory** — FUB rejects all HTTP requests. This ensures credentials are encrypted in transit.
- **Log authentication failures** — monitor for unauthorized access attempts.
- **Use least-privilege API keys** — if you only need to read contacts, use an Agent-level key instead of an Owner key.
- **Never log full API keys or tokens** — log only the last 4 characters for debugging.

---

## 6. Common Authentication Errors

| HTTP Status | Meaning | Resolution |
|-------------|---------|------------|
| `401 Unauthorized` | Invalid or missing API key / expired access token | Check API key, refresh OAuth token |
| `403 Forbidden` | Valid auth but insufficient permissions | Check user role, check account status |
| `429 Too Many Requests` | Rate limit exceeded | Back off, check `X-RateLimit-Remaining` header |

### Debugging Authentication Issues

```typescript
// TypeScript — Debug auth headers
const response = await fetch('https://api.followupboss.com/v1/identity', {
  headers: {
    'Authorization': `Basic ${Buffer.from(`${API_KEY}:`).toString('base64')}`,
    'X-System': SYSTEM,
    'X-System-Key': SYSTEM_KEY,
  },
});

// The /v1/identity endpoint returns info about the authenticated user
// Use it to verify your credentials are working
const identity = await response.json();
console.log('Authenticated as:', identity);
```

```python
# Python — Debug auth headers
response = requests.get(
    "https://api.followupboss.com/v1/identity",
    auth=(API_KEY, ""),
    headers={"X-System": SYSTEM, "X-System-Key": SYSTEM_KEY},
)
print(f"Status: {response.status_code}")
print(f"Identity: {response.json()}")
```

---

## 7. Required Headers Summary

Every FUB API request must include these headers:

| Header | Source | Required | Notes |
|--------|--------|----------|-------|
| `Authorization` | API key or OAuth token | Yes | `Basic base64(key:)` or `Bearer <token>` |
| `X-System` | System registration | Yes (for registered systems) | Your system name |
| `X-System-Key` | System registration | Yes (for registered systems) | Your system key |
| `Content-Type` | Standard HTTP | Yes (for POST/PUT) | `application/json` for API, `application/x-www-form-urlencoded` for OAuth token exchange |
