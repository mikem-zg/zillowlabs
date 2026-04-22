# Troubleshooting

## "I'm signed in to Replit but the app says I'm not"

The browser is reaching the app via a path that bypasses Replit's auth proxy, so the `X-Replit-User-*` headers never arrive. Check in this order:

1. **What URL is the user hitting?** It must be either:
   - The `.replit.app` deployment URL, or
   - A custom domain configured through Replit's deployment domain settings (not pointed at the app via your own CDN/DNS).
2. **Are you in the workspace preview?** The preview iframe inside the Replit editor *does* receive headers, but only when the user has signed in once via the popout. Open the app in a new tab to verify.
3. **Log the headers.** Add a one-line debug middleware before `authMiddleware`:
   ```ts
   app.use((req, _res, next) => { console.log("[auth-debug]", req.headers["x-replit-user-id"], req.headers["x-replit-user-name"]); next(); });
   ```
   If both are `undefined`, the request did not flow through the proxy. If they're populated but `req.user` is still null, your middleware order is wrong (auth must run before the route).

## "Sign-in keeps looping / opens a blank tab"

The iframe-escape branch in `signIn()` is not firing or is being blocked.

- If the app is embedded in something other than the Replit workspace, `window.top` may be cross-origin and silently throw. The helper falls back to `window.open`, which can be blocked by popup blockers.
- Workaround: trigger `signIn()` from a direct user click (which it already is in `UserMenu`), and ensure you have not added a custom click handler that calls `preventDefault()` before `signIn()` runs.

## "Admin permissions aren't working"

1. Confirm `ADMIN_EMAILS` is set in the **shared** environment (not just development).
2. The match is case-insensitive and uses the synthesized email (`<handle>@<AUTH_EMAIL_DOMAIN>`). If a user's Replit handle does not equal their corporate username, the synthesized email will not match — set `AUTH_EMAIL_DOMAIN` correctly and verify by hitting `/api/auth/me` and comparing the returned `email` field to your allowlist.
3. The allowlist is parsed once at boot. Restart the workflow after changing `ADMIN_EMAILS`, or expose a `refreshAdminEmails()` endpoint (see `route-examples.md`).
4. Whitespace in the env var is fine — the parser splits on commas, semicolons, and whitespace.

## "Everyone shows up as null in production"

Almost always: the production deployment is reachable via a custom domain that does not flow through Replit's auth proxy. Either:
- Move the custom domain to be managed by Replit's deployment domain settings, or
- Switch this app to the `zillow-auth` skill which uses pauth and works on any domain.

## "Type error: Property 'user' does not exist on type 'Request'"

The `declare global { namespace Express { interface Request { user: AuthUser | null } } }` block in `server/auth.ts` was either deleted or the file is not being included in the TypeScript compilation. Confirm `tsconfig.json` includes `server/**/*.ts` and that `server/auth.ts` is imported somewhere in your build graph (importing from `server/index.ts` is enough).

## "The /api/auth/me endpoint returns 404"

The route was registered before `authMiddleware`, or the route is being shadowed by Vite's catch-all in dev. Confirm registration order is:

```ts
app.use(express.json());
app.use(authMiddleware);
await registerRoutes(httpServer, app); // includes /api/auth/me
// THEN setupVite or serveStatic
```

## "useAuth flickers between signed-in and signed-out"

Two causes:
1. `staleTime` is set too low and React Query is refetching aggressively. The reference uses `60_000` ms and `refetchOnWindowFocus: true`, which is a good balance.
2. You have multiple `QueryClient` instances. There must be exactly one `QueryClientProvider` at the root of the app.
