# Zillow Auth Broker SDK — Full Integration Guide

> **SDK**: `https://pauth.zillowlabs.com/sdk/v1/broker.js`
> **Version**: v2.1.2 (September 2025)

## Table of Contents

1. [SDK Loading](#1-sdk-loading)
2. [Client Authentication](#2-client-authentication)
3. [Session Events & UI](#3-session-events--ui)
4. [Server Security & Validation](#4-server-security--validation)
5. [Ownership Pattern](#5-ownership-pattern)
6. [Test Authentication](#6-test-authentication)
7. [Troubleshooting](#7-troubleshooting)
8. [Validation Checklists](#8-validation-checklists)
9. [Impersonation (Optional)](#9-impersonation)
10. [React Example](#10-react-example)

---

## 1. SDK Loading

Load the broker script **first** in `<head>` — never use `async` or `defer`:

```html
<head>
  <link rel="preconnect" href="https://pauth.zillowlabs.com" crossorigin>
  <script src="https://pauth.zillowlabs.com/sdk/v1/broker.js"></script>
  <script src="/app.js"></script>
</head>
```

### Framework Tips

- **Next.js**: `<Script src="..." strategy="beforeInteractive" />`
- **Angular/React (static index.html)**: place broker `<script>` in `<head>` before your bundle
- **Vite/CRA/Parcel**: ensure the raw `<script>` tag remains first and is not transformed to `defer`

### CSP Configuration (Optional)

```html
<meta http-equiv="Content-Security-Policy"
  content="
    default-src 'self';
    script-src 'self' https://pauth.zillowlabs.com;
    connect-src 'self' https://pauth.zillowlabs.com;
    img-src 'self' data:;
    style-src 'self' 'unsafe-inline';
    frame-ancestors 'self';
  ">
```

---

## 2. Client Authentication

All methods are async and return promises.

### Basic Usage

```javascript
if (await ZillowAuth.isAuthenticated()) {
  const zuid = await ZillowAuth.getZUID();
  console.log(`Logged in as: ${zuid}`);
} else {
  ZillowAuth.login();
}
await ZillowAuth.logout();
```

Always use `ZillowAuth.getZUID()` as your single source of truth. Never cache or duplicate this value.

### Debugging Parameters

`isAuthenticated` and `getSession` accept optional `reason` and `source` params:

```javascript
const authenticated = await ZillowAuth.isAuthenticated('user clicked refresh', 'client');
const session = await ZillowAuth.getSession('checking status', 'client');
```

### Return URL Hardening

```javascript
function sanitizeReturnUrl(url) {
  try {
    const u = new URL(url, process.env.APP_ORIGIN);
    if (u.origin === process.env.APP_ORIGIN) {
      return u.pathname + u.search + u.hash;
    }
  } catch {}
  return '/';
}
```

### How Authentication Works

1. User clicks login → SDK redirects to OAuth provider
2. OAuth success → returns with `broker_session` handoff token in URL
3. SDK auto-detects and exchanges token for session ID
4. Session ID stored in `localStorage` key `zillow_broker_session_id`
5. No manual OAuth callback handling required
6. SDK adds `X-Broker-Session` header to broker API requests automatically
7. No cookies used — avoids cross-domain/Safari issues

---

## 3. Session Events & UI

### Session Changed Event

```javascript
window.addEventListener('zillowauth:session-changed', (event) => {
  const { current, previous, changes } = event.detail;
  // current: { zuid, impersonating_zuid, authenticated }
  // changes: { userChanged, authStatusChanged, impersonationChanged }
  refreshUserInterface();
});
```

Fires on: login/logout, different user login, impersonation changes, tab focus changes.
Does NOT fire for: background token maintenance.

### Session Expiring Event

```javascript
window.addEventListener('zillowauth:session-expiring', (e) => {
  const { expiresAt, timeUntilExpiry } = e.detail || {};
  // Prompt user or auto-reauth:
  // ZillowAuth.login(window.location.href);
});
```

Fires when session is about to expire AND background refresh failed.

---

## 4. Server Security & Validation

### NEVER Send Client Auth Headers

```javascript
// WRONG — security breach
fetch('/api/data', { headers: { 'x-zillow-zuid': zuid } });

// CORRECT — standard credentials
fetch('/api/data', { credentials: 'include' });
```

### Broker Session Validation Endpoint

`GET https://pauth.zillowlabs.com/api/broker/session`

**Request Headers:**
```
X-Broker-Session: <sessionToken>
Origin: <your-app-origin>
```

**Authenticated Response:**
```json
{
  "authenticated": true,
  "zuid": "67279988",
  "expiresAt": 1759503514784,
  "isPA": false,
  "isZillowGroupEmployee": true,
  "impersonating_zuid": "12345678"
}
```

**Unauthenticated Response:**
```json
{ "authenticated": false, "zuid": null, "loginUrl": "https://pauth.zillowlabs.com/auth/start?return_to=..." }
```

**Domain Not Verified Response:**
```json
{ "authenticated": false, "requiresDomainVerification": true, "domain": "your-app.com" }
```

### Server Validation Implementation

```javascript
async function validateSessionToken(token) {
  const controller = new AbortController();
  const t = setTimeout(() => controller.abort(), 3000);
  const response = await fetch('https://pauth.zillowlabs.com/api/broker/session', {
    headers: { 'X-Broker-Session': token, 'Origin': process.env.APP_ORIGIN },
    signal: controller.signal
  }).finally(() => clearTimeout(t));
  const data = await response.json();
  if (data.authenticated) {
    return { zuid: data.zuid, isZillowGroupEmployee: data.isZillowGroupEmployee, isPA: data.isPA, impersonatingZuid: data.impersonating_zuid };
  }
  return null;
}
```

### Centralized Auth Middleware

```javascript
async function buildAuthFromRequest(req) {
  const sessionToken = req.cookies?.['auth_session'];
  if (sessionToken) {
    try {
      const session = await validateSessionToken(sessionToken);
      if (session) {
        return {
          status: 'authenticated', zuid: session.zuid,
          roles: { employee: session.isZillowGroupEmployee, premierAgent: session.isPA },
          isImpersonating: !!session.impersonatingZuid
        };
      }
    } catch (error) { /* fall through */ }
  }
  return { status: 'anonymous', zuid: null, roles: { employee: false, premierAgent: false } };
}
```

### CORS Configuration

```javascript
import cors from 'cors';
app.use(cors({ origin: process.env.APP_ORIGIN, credentials: true }));
```

### Security Features

- Domain verification: only verified domains access authenticated sessions
- Origin validation: request origin must match session origin
- Auto-expiry: 8h rolling, 7d absolute
- Rate limiting: protected against abuse
- No credentials required: session token is the credential
- Allowed CORS domains: `*.replit.dev`, `*.replit.app`, `*.zillowlabs.com`

---

## 5. Ownership Pattern

### Server: Include Ownership in Responses

```javascript
// Good API response
{ "id": 123, "data": "...", "isOwner": true, "zuid": "67279988" }
// Include zuid ONLY when isOwner is true
```

### Frontend: Consume Server Decisions

```jsx
// CORRECT
{resource?.isOwner && <EditButton />}

// WRONG — never compare ZUIDs in frontend
{currentZuid === resource?.userId && <EditButton />}
```

### Common Pitfalls

1. **ZUID header auth** — use broker validation instead
2. **Inconsistent auth patterns** — use centralized middleware
3. **Missing ownership data** — always include `isOwner`
4. **Frontend auth logic** — keep frontend simple, consume server decisions
5. **Cached session state** — eliminate caching, always use live SDK/broker state

---

## 6. Test Authentication

Dev/testing shortcut — blocked on production domains.

```javascript
await ZillowAuth.loginTest('12345678');

await ZillowAuth.loginTest('87654321', {
  isPremierAgent: true,
  isZillowGroupEmployee: false,
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@example.com'
});
```

**`loginTest(zuid, options?)` Parameters:**
- `zuid` (string, required)
- `isPremierAgent` (boolean, default `false`)
- `isZillowGroupEmployee` (boolean, default `false`)
- `firstName` (string, default `"Test"`)
- `lastName` (string, default `"User"`)
- `email` (string, default `"test@example.com"`)

Returns: `Promise<object|null>`

**"test_auth_forbidden" error** — running on a production domain. Use `localhost`, `*.test`, or `*.dev`.

---

## 7. Troubleshooting

| Issue | Solution |
|-------|----------|
| SDK not loading | Verify HTTPS, check console logs |
| Auth not persisting | Ensure `localStorage` enabled; expiry: 8h rolling, 7d absolute |
| CORS errors | Allowed: `*.replit.dev`, `*.replit.app`, `*.zillowlabs.com` |
| Session changes not detected | Listen for `zillowauth:session-changed` |
| No `auth_session` cookie | Expected — SDK uses localStorage, not cookies |
| Safari cookie issues | Not a problem — SDK doesn't use cookies |
| Need session on backend | Create endpoint to receive session ID from SDK |
| ZUID mismatch frontend/backend | Server likely caching stale state; validate current token |
| Wrong user data shown | Eliminate separate ZUID caching |
| Security: client auth headers | Remove `x-zillow-zuid`/`x-dev-auth`; use broker validation |

---

## 8. Validation Checklists

### Final Validation

- [ ] SDK loads first (no `async`/`defer`)
- [ ] Frontend uses only SDK methods (`isAuthenticated`, `getZUID`, `login`, `logout`)
- [ ] Listeners for `zillowauth:session-changed` (+ optional `session-expiring`)
- [ ] `credentials: 'include'` on all client API calls
- [ ] Server validates via `GET /api/broker/session`
- [ ] Centralized auth middleware populates `req.auth`
- [ ] Responses include `isOwner` (and `zuid` only when owner)
- [ ] No ZUID caching anywhere

### Security Checklist (MUST COMPLY)

- [ ] Zero client auth headers (never `x-zillow-zuid`, `x-dev-auth`, etc.)
- [ ] Server validates all sessions via broker
- [ ] Frontend never makes authorization decisions
- [ ] ZUID never cached separately
- [ ] Domain/Origin checks pass
- [ ] CSRF protection for cookie-backed APIs
- [ ] CORS with explicit origin + `credentials: true`

---

## 9. Impersonation

Most apps should ignore impersonation entirely — it works transparently.

To hide the impersonation banner:
```html
<script src="https://pauth.zillowlabs.com/sdk/v1/broker.js?hideImpersonationBar=true"></script>
```

Methods (reference only, do NOT gate features on these):
- `isImpersonating()` — `true` if impersonated
- `getImpersonatorZUID()` — impersonator's ZUID or `null`

---

## 10. React Example

```jsx
import { useEffect, useState } from 'react';

function App() {
  const [zuid, setZuid] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function checkAuth() {
      if (await window.ZillowAuth.isAuthenticated()) {
        setZuid(await window.ZillowAuth.getZUID());
      }
      setLoading(false);
    }

    function handleSessionChange(event) {
      console.log('Session changed:', event.detail);
      checkAuth();
    }

    function handleSessionExpiring(e) {
      const { expiresAt, timeUntilExpiry } = e.detail || {};
      console.warn('[Auth] Session expiring:', { expiresAt: new Date(expiresAt).toISOString(), timeUntilExpiryMs: timeUntilExpiry });
    }

    window.addEventListener('zillowauth:session-changed', handleSessionChange);
    window.addEventListener('zillowauth:session-expiring', handleSessionExpiring);
    console.info('[ZillowAuth] version:', window.ZillowAuth.version, 'broker:', window.ZillowAuth.brokerUrl);
    checkAuth();

    return () => {
      window.removeEventListener('zillowauth:session-changed', handleSessionChange);
      window.removeEventListener('zillowauth:session-expiring', handleSessionExpiring);
    };
  }, []);

  if (loading) return <div>Loading...</div>;
  if (!zuid) return <button onClick={() => window.ZillowAuth.login()}>Login with Zillow</button>;

  return (
    <div>
      <h1>Welcome {zuid}</h1>
      <button onClick={async () => { await window.ZillowAuth.logout(); }}>Logout</button>
    </div>
  );
}

export default App;
```
