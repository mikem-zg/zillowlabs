# Route gating examples

All examples assume `server/auth.ts` from this skill is in place and `app.use(authMiddleware)` runs before `registerRoutes`.

## Basic auth gate

```ts
import { requireAuth } from "./auth";

app.post("/api/items", requireAuth, async (req, res) => {
  // req.user is guaranteed non-null here
  const item = await createItem({ ...req.body, createdBy: req.user!.email });
  res.json(item);
});
```

## Admin-only gate

```ts
import { requireAdmin } from "./auth";

app.delete("/api/items/:id", requireAdmin, async (req, res) => {
  await deleteItem(req.params.id);
  res.json({ ok: true });
});
```

## Read req.user without forcing auth

Useful for endpoints that personalize a response but still work for signed-out users:

```ts
app.get("/api/items", async (req, res) => {
  const items = await listItems();
  res.json({
    items,
    canEdit: !!req.user?.isAdmin,
    currentUser: req.user, // null if signed out
  });
});
```

## Ownership check (user can edit their own records, admins can edit anyone's)

```ts
import { requireAuth } from "./auth";

app.patch("/api/items/:id", requireAuth, async (req, res) => {
  const item = await getItem(req.params.id);
  if (!item) return res.status(404).json({ error: "Not found" });

  const isOwner = item.createdBy === req.user!.email;
  if (!isOwner && !req.user!.isAdmin) {
    return res.status(403).json({ error: "You can only edit your own items." });
  }

  const updated = await updateItem(req.params.id, req.body);
  res.json(updated);
});
```

## Conditional admin check inside a handler

If a single endpoint mixes user-allowed and admin-only fields:

```ts
import { requireAuth } from "./auth";

app.patch("/api/profile", requireAuth, async (req, res) => {
  const { displayName, role } = req.body;
  const updates: Record<string, unknown> = {};

  if (displayName !== undefined) updates.displayName = displayName;
  if (role !== undefined) {
    if (!req.user!.isAdmin) {
      return res.status(403).json({ error: "Only admins can change role." });
    }
    updates.role = role;
  }

  const profile = await updateProfile(req.user!.email, updates);
  res.json(profile);
});
```

## Refresh admin allowlist at runtime

If you build a small admin tool that lets you edit `ADMIN_EMAILS` and want the change to take effect without a workflow restart:

```ts
import { requireAdmin, refreshAdminEmails } from "./auth";

app.post("/api/admin/reload-admins", requireAdmin, (_req, res) => {
  refreshAdminEmails();
  res.json({ ok: true });
});
```
