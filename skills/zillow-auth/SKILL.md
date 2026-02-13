---
name: zillow-auth
description: Integrate Zillow Auth (pauth) into web applications using the Broker SDK. Covers SDK loading, client authentication, session events, server-side validation, ownership patterns, test auth, and security checklists. Use when adding Zillow login, pauth, ZillowAuth, ZUID-based auth, or broker session validation to an app.
---

# Zillow Auth (pauth) Integration

Add Zillow authentication to any web app via the Auth Broker SDK (`https://pauth.zillowlabs.com/sdk/v1/broker.js`, v2.1.2).

## Quick Start

### 1. Load SDK in `<head>` (CRITICAL — no `async`/`defer`)

**Vite/React** — add to `index.html` before your bundle:
```html
<head>
  <link rel="preconnect" href="https://pauth.zillowlabs.com" crossorigin>
  <script src="https://pauth.zillowlabs.com/sdk/v1/broker.js"></script>
</head>
```

**Next.js:**
```jsx
import Script from 'next/script';
<Script src="https://pauth.zillowlabs.com/sdk/v1/broker.js" strategy="beforeInteractive" />
```

### 2. Use SDK Methods (all async)

```javascript
if (await ZillowAuth.isAuthenticated()) {
  const zuid = await ZillowAuth.getZUID(); // single source of truth
} else {
  ZillowAuth.login();        // login(returnUrl?) — defaults to current page
}
await ZillowAuth.logout();
```

### 3. Listen for Session Events

```javascript
window.addEventListener('zillowauth:session-changed', (e) => {
  const { current, previous, changes } = e.detail;
  refreshUI();
});
window.addEventListener('zillowauth:session-expiring', (e) => {
  // background refresh failed — prompt or reauth
});
```

### 4. Server-Side Validation (CRITICAL)

Validate sessions via broker — never trust client-supplied ZUIDs:

```javascript
async function validateSessionToken(token) {
  const res = await fetch('https://pauth.zillowlabs.com/api/broker/session', {
    headers: { 'X-Broker-Session': token, 'Origin': process.env.APP_ORIGIN },
    signal: AbortSignal.timeout(3000)
  });
  const data = await res.json();
  return data.authenticated ? { zuid: data.zuid, isPA: data.isPA, isEmployee: data.isZillowGroupEmployee } : null;
}
```

## SDK Method Reference

| Method | Returns | Notes |
|--------|---------|-------|
| `isAuthenticated(reason?, source?)` | `boolean` | Cached, fast |
| `getZUID()` | `string \| null` | Single source of truth — never cache |
| `login(returnUrl?)` | redirects | Default: current page |
| `logout()` | `void` | Clears session |
| `isPA()` | `boolean` | Premier Agent check |
| `isZillowGroupEmployee()` | `boolean` | Employee check |
| `getSession(reason?, source?)` | `object` | Full session data |
| `loginTest(zuid, options?)` | `object \| null` | Dev-only, blocked in prod |
| `isImpersonating()` | `boolean` | Ignore in app logic |
| `version` / `brokerUrl` | `string` | Diagnostics |

## Session Mechanics

- Session stored in `localStorage` key `zillow_broker_session_id` (NOT cookies)
- SDK adds `X-Broker-Session` header to broker calls automatically
- OAuth callback handled automatically (no manual handling needed)
- Cross-tab sync via localStorage events
- Token auto-refresh before expiry
- Expiry: 8h rolling, 7d absolute

## Security Rules (MUST COMPLY)

- **NEVER** send client auth headers (`x-zillow-zuid`, `x-dev-auth`, etc.)
- **NEVER** trust client-supplied ZUIDs for authorization
- **NEVER** cache ZUIDs on client or server — always validate live
- **ALWAYS** validate sessions server-side via broker endpoint
- **ALWAYS** use `credentials: 'include'` on client API calls
- **ALWAYS** include `isOwner` in API responses for ownership checks
- **ALWAYS** do authorization on server, not frontend

## Ownership Pattern

```javascript
// Server response: { id: 123, data: "...", isOwner: true }
// Frontend: consume isOwner, never compare ZUIDs
{resource?.isOwner && <EditButton />}
```

## Test Auth (Dev-Only)

```javascript
await ZillowAuth.loginTest('12345678');
await ZillowAuth.loginTest('87654321', { isPremierAgent: true, isZillowGroupEmployee: false });
```

Blocked on production domains. Works on `localhost`, `*.test`, `*.dev`.

## React Hook Pattern

```jsx
useEffect(() => {
  async function checkAuth() {
    if (await window.ZillowAuth.isAuthenticated()) {
      setZuid(await window.ZillowAuth.getZUID());
    }
    setLoading(false);
  }
  const handler = () => checkAuth();
  window.addEventListener('zillowauth:session-changed', handler);
  checkAuth();
  return () => window.removeEventListener('zillowauth:session-changed', handler);
}, []);
```

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

## Detailed Reference

- **Full integration guide**: See [references/integration-guide.md](references/integration-guide.md)
- Covers: CSP config, CORS setup, CSRF protection, impersonation, troubleshooting, validation checklists
