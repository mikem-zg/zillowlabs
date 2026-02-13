# Dotloop Authentication Reference

Complete guide to authenticating with the dotloop Public API v2. Covers client registration, OAuth 2.0 Authorization Code flow, token management, scopes, and security best practices.

---

## Overview

- Dotloop v2 API uses **OAuth 2.0 ONLY** (3-legged, Authorization Code flow)
- **No API key authentication** is available for the v2 API
- Auth server: `https://auth.dotloop.com/oauth/`
- API server: `https://api-gateway.dotloop.com/public/v2/`
- All requests must use HTTPS

---

## 1. Client Registration

Before making any API calls, you must register your application with dotloop.

### How to Register

- **Request access** at https://info.dotloop.com/developers — dotloop will provision your credentials
- **Or register directly** at https://www.dotloop.com/my/account/#/clients (requires an existing dotloop account)

### Credentials Received

Upon registration you receive two values:

| Credential | Format | Description |
|------------|--------|-------------|
| `client_id` | UUID | Identifies your application |
| `client_secret` | UUID | Secret key for your application |

### Redirect URI Requirements

- Must be **HTTPS** (no HTTP)
- Must be **publicly accessible** (no `localhost` or `127.0.0.1`)
- Must exactly match the URI configured during registration
- Use a tunnel service (e.g., ngrok) during development

---

## 2. OAuth 2.0 Authorization Code Flow

Dotloop implements the standard OAuth 2.0 Authorization Code Grant (3-legged flow).

### Step 1: Obtain Authorization Code

Redirect the user's browser to the dotloop authorization page:

```
GET https://auth.dotloop.com/oauth/authorize
  ?response_type=code
  &client_id=<your_client_id>
  &redirect_uri=<url_encoded_redirect_uri>
  &state=<random_csrf_string>
  &redirect_on_deny=true
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `response_type` | Yes | Must be `code` |
| `client_id` | Yes | Your application's client_id (UUID) |
| `redirect_uri` | Yes | URL-encoded redirect URI (must match registered URI exactly) |
| `state` | Recommended | Opaque value for CSRF protection — returned unchanged in the callback |
| `redirect_on_deny` | No | `true` or `false` (default `false`). Controls whether the deny button redirects back to your app or simply closes the window |

**User approves:**
```
302 Redirect → https://yourapp.com/callback?code=AUTHORIZATION_CODE&state=your_state_value
```

**User denies (with `redirect_on_deny=true`):**
```
302 Redirect → https://yourapp.com/callback?response=denied
```

**User denies (with `redirect_on_deny=false` or omitted):**
The authorization window closes — no redirect occurs.

### Step 2: Exchange Authorization Code for Tokens

Exchange the authorization code for access and refresh tokens:

```http
POST https://auth.dotloop.com/oauth/token?grant_type=authorization_code&code=AUTH_CODE&redirect_uri=https%3A%2F%2Fyourapp.com%2Fcallback&state=your_state_value
Authorization: Basic <base64(client_id:client_secret)>
```

**Authorization header construction:**

The `Authorization` header uses HTTP Basic Auth with `client_id` as the username and `client_secret` as the password, base64-encoded:

| Component | Value |
|-----------|-------|
| client_id | `69bcf590-71b7-41a4-a039-a1d290edca11` |
| client_secret | `3415e381-bdc4-49b7-bde2-69b3c5cd6447` |
| Combined | `69bcf590-71b7-41a4-a039-a1d290edca11:3415e381-bdc4-49b7-bde2-69b3c5cd6447` |
| Base64 | `NjliY2Y1OTAtNzFiNy00MWE0LWEwMzktYTFkMjkwZWRjYTExOjM0MTVlMzgxLWJkYzQtNDliNy1iZGUyLTY5YjNjNWNkNjQ0Nw==` |

**Response:**

```json
{
  "access_token": "eyJhbGciOi...",
  "token_type": "Bearer",
  "refresh_token": "dGhpcyBpcyBh...",
  "expires_in": 43199,
  "scope": "account:read, profile:*, loop:*, contact:*, template:read"
}
```

### Step 3: Make Authenticated Requests

Use the access token as a Bearer token in the `Authorization` header:

```http
GET https://api-gateway.dotloop.com/public/v2/profile
Authorization: Bearer eyJhbGciOi...
```

---

## 3. Token Refresh

Access tokens expire after approximately **12 hours** (43199 seconds). Use the refresh token to obtain a new access token without requiring user interaction.

```http
POST https://auth.dotloop.com/oauth/token?grant_type=refresh_token&refresh_token=dGhpcyBpcyBh...
Authorization: Basic <base64(client_id:client_secret)>
```

**Response:**

```json
{
  "access_token": "new_access_token...",
  "token_type": "Bearer",
  "refresh_token": "new_or_same_refresh_token...",
  "expires_in": 43199
}
```

### Token Lifetimes

| Token | Lifetime |
|-------|----------|
| Access Token | ~12 hours (43199 seconds) |
| Refresh Token | Long-lived (no documented expiry) |

### Critical: Token Invalidation on Refresh

When you refresh a token, the **previous access token becomes INVALID immediately**. This has important implications:

- In **clustered environments**, coordinate token refresh across instances to avoid race conditions where one instance refreshes while another is still using the old token.
- Use a **centralized token store** (database, Redis) so all instances share the same current token.
- Implement a **mutex or lock** around the refresh operation to prevent concurrent refreshes.

### Refresh Strategies

| Strategy | When to Use |
|----------|-------------|
| **Proactive** | Refresh before expiry (e.g., at 11 hours). Avoids failed requests. |
| **Lazy** | Refresh on 401 error. Simpler but causes one failed request per cycle. |
| **Hybrid** | Proactive refresh with lazy fallback. Best for production. |

---

## 4. Access Revocation

To revoke tokens (e.g., when a user disconnects your app):

```http
POST https://auth.dotloop.com/oauth/token/revoke?token=<access_token>
```

This invalidates **both** the access token and the associated refresh token.

---

## 5. Available Scopes

Scopes control what resources your application can access. Wildcard (`*`) scopes grant both read and write access.

| Scope | Access |
|-------|--------|
| `account:read` | Read account details |
| `profile:read` | Read profiles |
| `profile:write` | Create/update profiles |
| `profile:*` | Full profile access (read + write) |
| `loop:read` | Read loops, participants, documents, details, activity |
| `loop:write` | Create/update loops, participants, upload documents |
| `loop:*` | Full loop access (read + write) |
| `contact:read` | Read contacts |
| `contact:write` | Create/update contacts |
| `contact:*` | Full contact access (read + write) |
| `template:read` | Read loop templates |

The default scope granted on authorization typically includes: `account:read, profile:*, loop:*, contact:*, template:read`

---

## 6. Error Handling

### OAuth Error Responses

Dotloop follows standard OAuth 2.0 error codes (RFC 6749):

| HTTP Status | Error | Description | Resolution |
|-------------|-------|-------------|------------|
| 401 | Unauthenticated | Expired or invalid access token | Refresh the token using the refresh token |
| 403 | Access Denied | Insufficient permissions or wrong profile type | Check scopes, verify profile type is INDIVIDUAL |
| 400 | invalid_request | Missing or malformed parameters | Check required parameters |
| 400 | invalid_grant | Authorization code expired or already used | Restart the authorization flow |
| 400 | invalid_client | Bad client_id or client_secret | Verify credentials |
| 400 | unsupported_grant_type | Invalid grant_type parameter | Must be `authorization_code` or `refresh_token` |

### Handling 401 Errors

```typescript
async function dotloopRequest(endpoint: string, accessToken: string, refreshToken: string) {
  let response = await fetch(`https://api-gateway.dotloop.com/public/v2/${endpoint}`, {
    headers: { 'Authorization': `Bearer ${accessToken}` },
  });

  if (response.status === 401) {
    const newTokens = await refreshAccessToken(refreshToken);
    response = await fetch(`https://api-gateway.dotloop.com/public/v2/${endpoint}`, {
      headers: { 'Authorization': `Bearer ${newTokens.access_token}` },
    });
  }

  return response.json();
}
```

---

## 7. Security Best Practices

### CSRF Protection

- **Always use the `state` parameter** in authorization requests.
- Generate a cryptographically random string for each authorization attempt.
- Store the state value in the user's session before redirecting.
- Verify the returned `state` matches the stored value in the callback.

### Credential Security

- **Store `client_secret` as an environment variable** — never hardcode in source files.
- **Never expose `client_secret` in client-side code** — JavaScript running in the browser, mobile app bundles, or public repositories.
- **Store tokens encrypted at rest** in your database.
- **Never include tokens in URLs** — use headers only.
- **Never log tokens** — log only the last 4 characters for debugging.

### Token Management

- **Implement proactive token refresh** — refresh before expiry rather than waiting for a 401.
- **Use a centralized token store** in clustered environments to prevent race conditions.
- **Revoke tokens** when users disconnect your integration.
- **Use HTTPS redirect URIs only** — dotloop requires this.

---

## 8. Code Examples

### TypeScript (Express) — Complete OAuth Flow

```typescript
import express from 'express';
import crypto from 'crypto';

const CLIENT_ID = process.env.DOTLOOP_CLIENT_ID!;
const CLIENT_SECRET = process.env.DOTLOOP_CLIENT_SECRET!;
const REDIRECT_URI = 'https://yourapp.com/oauth/dotloop/callback';

const app = express();

// Step 1: Redirect user to dotloop authorization page
app.get('/oauth/dotloop/start', (req, res) => {
  const state = crypto.randomUUID();
  // Store state in session for CSRF verification
  req.session.dotloopOAuthState = state;

  const authUrl = new URL('https://auth.dotloop.com/oauth/authorize');
  authUrl.searchParams.set('response_type', 'code');
  authUrl.searchParams.set('client_id', CLIENT_ID);
  authUrl.searchParams.set('redirect_uri', REDIRECT_URI);
  authUrl.searchParams.set('state', state);
  authUrl.searchParams.set('redirect_on_deny', 'true');

  res.redirect(authUrl.toString());
});

// Step 2 & 3: Handle callback, exchange code for tokens
app.get('/oauth/dotloop/callback', async (req, res) => {
  const { code, state, response: authResponse } = req.query;

  // Verify CSRF state
  if (state !== req.session.dotloopOAuthState) {
    return res.status(403).send('Invalid state parameter');
  }

  // Handle denial
  if (authResponse === 'denied') {
    return res.send('Authorization denied by user');
  }

  if (!code) {
    return res.status(400).send('Missing authorization code');
  }

  // Exchange authorization code for tokens
  const basicAuth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64');

  const tokenUrl = new URL('https://auth.dotloop.com/oauth/token');
  tokenUrl.searchParams.set('grant_type', 'authorization_code');
  tokenUrl.searchParams.set('code', code as string);
  tokenUrl.searchParams.set('redirect_uri', REDIRECT_URI);
  tokenUrl.searchParams.set('state', state as string);

  const tokenResponse = await fetch(tokenUrl.toString(), {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${basicAuth}`,
    },
  });

  if (!tokenResponse.ok) {
    const error = await tokenResponse.text();
    return res.status(500).send(`Token exchange failed: ${error}`);
  }

  const tokens = await tokenResponse.json();
  // tokens = { access_token, token_type, refresh_token, expires_in, scope }

  // Store tokens securely (database, encrypted storage)
  // Calculate expiry: Date.now() + (tokens.expires_in * 1000)

  res.send('Connected to dotloop!');
});

// Make authenticated API requests
async function dotloopRequest(endpoint: string, accessToken: string) {
  const response = await fetch(`https://api-gateway.dotloop.com/public/v2/${endpoint}`, {
    headers: {
      'Authorization': `Bearer ${accessToken}`,
    },
  });

  if (response.status === 401) {
    throw new Error('TOKEN_EXPIRED');
  }

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Dotloop API ${response.status}: ${body}`);
  }

  return response.json();
}

// Refresh access token
async function refreshAccessToken(refreshToken: string) {
  const basicAuth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64');

  const tokenUrl = new URL('https://auth.dotloop.com/oauth/token');
  tokenUrl.searchParams.set('grant_type', 'refresh_token');
  tokenUrl.searchParams.set('refresh_token', refreshToken);

  const response = await fetch(tokenUrl.toString(), {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${basicAuth}`,
    },
  });

  if (!response.ok) {
    throw new Error('Failed to refresh token — user may need to re-authorize');
  }

  return response.json();
  // Returns: { access_token, token_type, refresh_token, expires_in }
}

// Revoke tokens
async function revokeToken(accessToken: string) {
  const revokeUrl = new URL('https://auth.dotloop.com/oauth/token/revoke');
  revokeUrl.searchParams.set('token', accessToken);

  await fetch(revokeUrl.toString(), { method: 'POST' });
}

// Usage: Auto-refresh wrapper
async function dotloopRequestWithRefresh(
  endpoint: string,
  accessToken: string,
  refreshToken: string,
  onTokenRefresh: (newTokens: any) => Promise<void>
) {
  try {
    return await dotloopRequest(endpoint, accessToken);
  } catch (err: any) {
    if (err.message === 'TOKEN_EXPIRED') {
      const newTokens = await refreshAccessToken(refreshToken);
      await onTokenRefresh(newTokens);
      return await dotloopRequest(endpoint, newTokens.access_token);
    }
    throw err;
  }
}
```

### Python (Flask) — Complete OAuth Flow

```python
import os
import secrets
from urllib.parse import urlencode
from base64 import b64encode
import requests
from flask import Flask, redirect, request, session

CLIENT_ID = os.environ["DOTLOOP_CLIENT_ID"]
CLIENT_SECRET = os.environ["DOTLOOP_CLIENT_SECRET"]
REDIRECT_URI = "https://yourapp.com/oauth/dotloop/callback"

app = Flask(__name__)
app.secret_key = os.environ["FLASK_SECRET_KEY"]


# Step 1: Redirect user to dotloop authorization page
@app.route("/oauth/dotloop/start")
def oauth_start():
    state = secrets.token_urlsafe(32)
    session["dotloop_oauth_state"] = state

    params = urlencode({
        "response_type": "code",
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "state": state,
        "redirect_on_deny": "true",
    })
    return redirect(f"https://auth.dotloop.com/oauth/authorize?{params}")


# Step 2 & 3: Handle callback, exchange code for tokens
@app.route("/oauth/dotloop/callback")
def oauth_callback():
    # Verify CSRF state
    if request.args.get("state") != session.get("dotloop_oauth_state"):
        return "Invalid state parameter", 403

    # Handle denial
    if request.args.get("response") == "denied":
        return "Authorization denied by user"

    code = request.args.get("code")
    if not code:
        return "Missing authorization code", 400

    state = request.args["state"]

    # Exchange authorization code for tokens
    auth_header = b64encode(f"{CLIENT_ID}:{CLIENT_SECRET}".encode()).decode()

    token_response = requests.post(
        "https://auth.dotloop.com/oauth/token",
        params={
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": REDIRECT_URI,
            "state": state,
        },
        headers={"Authorization": f"Basic {auth_header}"},
    )
    token_response.raise_for_status()
    tokens = token_response.json()
    # tokens = { access_token, token_type, refresh_token, expires_in, scope }

    # Store tokens securely (database, encrypted storage)
    return "Connected to dotloop!"


# Make authenticated API requests
def dotloop_request(endpoint: str, access_token: str) -> dict:
    response = requests.get(
        f"https://api-gateway.dotloop.com/public/v2/{endpoint}",
        headers={"Authorization": f"Bearer {access_token}"},
    )
    if response.status_code == 401:
        raise Exception("TOKEN_EXPIRED")
    response.raise_for_status()
    return response.json()


# Refresh access token
def refresh_access_token(refresh_token: str) -> dict:
    auth_header = b64encode(f"{CLIENT_ID}:{CLIENT_SECRET}".encode()).decode()

    response = requests.post(
        "https://auth.dotloop.com/oauth/token",
        params={
            "grant_type": "refresh_token",
            "refresh_token": refresh_token,
        },
        headers={"Authorization": f"Basic {auth_header}"},
    )
    if not response.ok:
        raise Exception("Failed to refresh token — user may need to re-authorize")
    return response.json()


# Revoke tokens
def revoke_token(access_token: str) -> None:
    requests.post(
        "https://auth.dotloop.com/oauth/token/revoke",
        params={"token": access_token},
    )


# Auto-refresh wrapper
def dotloop_request_with_refresh(
    endpoint: str,
    access_token: str,
    refresh_token: str,
    on_token_refresh=None,
) -> dict:
    try:
        return dotloop_request(endpoint, access_token)
    except Exception as e:
        if str(e) == "TOKEN_EXPIRED":
            new_tokens = refresh_access_token(refresh_token)
            if on_token_refresh:
                on_token_refresh(new_tokens)
            return dotloop_request(endpoint, new_tokens["access_token"])
        raise
```

---

## 9. Quick Reference

### URLs

| Purpose | URL |
|---------|-----|
| Authorization | `https://auth.dotloop.com/oauth/authorize` |
| Token Exchange | `https://auth.dotloop.com/oauth/token` |
| Token Revocation | `https://auth.dotloop.com/oauth/token/revoke` |
| API Base | `https://api-gateway.dotloop.com/public/v2/` |

### Required Headers

| Header | Value | When |
|--------|-------|------|
| `Authorization` | `Basic base64(client_id:client_secret)` | Token exchange and refresh |
| `Authorization` | `Bearer <access_token>` | API requests |

### Environment Variables

```bash
DOTLOOP_CLIENT_ID=your-client-id-uuid
DOTLOOP_CLIENT_SECRET=your-client-secret-uuid
DOTLOOP_REDIRECT_URI=https://yourapp.com/oauth/dotloop/callback
```
