---
name: zillowlabs-core
description: "Install and configure the ZillowLabs Core update service that keeps your app's local assets (.agents/skills) automatically in sync during development. Covers bootstrap setup, widget installation, three-tier skill customization, environment variables, and troubleshooting."
---

# zillowlabs-core — Client Installation Guide

> Centralized update service that keeps your app's local assets (`.agents/skills`) automatically in sync **during development only**. The bootstrap is a no-op in production.

---

## Quick Start

Run this in your project root to install the bootstrap script:

```bash
mkdir -p scripts

# Download the bootstrap file
curl -fsSL https://zillowlabs-core.replit.app/client/zillowlabs_core_bootstrap.mjs \
  -o scripts/zillowlabs_core_bootstrap.mjs

# Add cache directory to .gitignore
node - <<'NODE'
const fs = require('fs');
const gi = '.gitignore';
const line = '.cache/zillowlabs-core/';
const cur = fs.existsSync(gi) ? fs.readFileSync(gi,'utf8') : '';
if (!cur.split(/\r?\n/).includes(line))
  fs.appendFileSync(gi, (cur.endsWith('\n')||cur===''?'':'\n') + line + '\n');
console.log('added to .gitignore:', line);
NODE
```

Then chain the bootstrap into your dev script so it runs before the dev server. Ask the Replit AI agent to update the `dev` script in `package.json`. For example, change:

```json
"dev": "tsx server/index.ts"
```

to:

```json
"dev": "node scripts/zillowlabs_core_bootstrap.mjs && tsx server/index.ts"
```

> **Note:** You cannot edit `package.json` directly on Replit. Ask the AI agent to make the change for you.

This ensures the bootstrap runs on every development startup before your app starts.

---

## Widget (Optional)

Add the ZillowLabs Core widget to your app for quick access to skills documentation and updates. It adds a small floating button in the corner of your app during development.

Add this script tag to your `client/index.html` (or equivalent HTML entry point), passing your Replit app's unique ID and owner via data attributes:

```html
<script src="https://zillowlabs-core.replit.app/client/zillowlabs-core-widget.js" data-repl-id="YOUR_REPL_ID" data-repl-owner="YOUR_REPL_OWNER" defer></script>
```

Replace `YOUR_REPL_ID` and `YOUR_REPL_OWNER` with your app's environment variables. You can find them by running:

```bash
echo $REPL_ID
echo $REPL_OWNER
```

- `data-repl-id` identifies your specific app for app-level skill overrides.
- `data-repl-owner` identifies you (the user) for user-level skill overrides that apply to all your apps.

Without these attributes, the widget still works but won't support per-app or per-user customization.

> **Tip:** The widget only loads in the browser — it has no effect on your server or production builds.

---

## App Heartbeat (Usage Tracking)

The bootstrap script can report back to the skills library so your team can see which apps are using it. Add a heartbeat call to your bootstrap or startup script:

```bash
curl -s -X POST https://zillowlabs-core.replit.app/api/heartbeat \
  -H "Content-Type: application/json" \
  -d "{\"appId\": \"$REPL_ID\", \"appName\": \"$REPL_SLUG\", \"replSlug\": \"$REPL_SLUG\", \"skillCount\": $(ls -d .agents/skills/*/ 2>/dev/null | wc -l)}"
```

Or from Node.js:

```js
fetch("https://zillowlabs-core.replit.app/api/heartbeat", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    appId: process.env.REPL_ID,
    appName: process.env.REPL_SLUG,
    replSlug: process.env.REPL_SLUG,
    skillCount: require("fs").readdirSync(".agents/skills").filter(f =>
      require("fs").statSync(`.agents/skills/${f}`).isDirectory()
    ).length,
  }),
});
```

This sends:
- `appId` — unique identifier for this app (uses `REPL_ID`)
- `appName` — human-readable name (uses `REPL_SLUG`)
- `skillCount` — number of skill directories installed

The heartbeat is idempotent. Duplicate calls update the "last seen" timestamp without creating extra records. Results appear on the Reports page under "Active apps".

---

## Dev-Only Behavior

The bootstrap script **automatically skips sync when `NODE_ENV=production`**. This means:

- In **development** (default) — files sync from the central service on every startup.
- In **production** — the bootstrap exits immediately with no network calls, no file writes, and no side effects.

You can safely leave the bootstrap in your workflow command for all environments. In production it exits immediately with zero overhead.

If you want to see confirmation that it was skipped, set `ZLC_DEBUG=1` and you'll see:

```
[zlc-bootstrap] production mode detected — skipping sync
```

---

## Skill Customization (Three-Tier Override)

Skills use a three-tier override system with the following precedence:

1. **App-level** (highest priority) — Overrides for a specific Replit app, identified by `REPL_ID`.
2. **User-level** — Overrides for all your apps, identified by `REPL_OWNER`.
3. **Global default** — The admin-configured default for all users.

The widget provides three choices for each skill:
- **All My Apps** — Enables the skill for every app you own (user-level override).
- **This App** — Enables the skill only for this specific app (app-level override).
- **Disabled** — Disables the skill for this app (app-level override).

The bootstrap script automatically detects both `REPL_ID` and `REPL_OWNER` environment variables (set by Replit) and passes them to the service. When you change skill settings via the widget, those changes take effect on the next server restart.

If no overrides exist, the app receives the default set of globally-enabled skills.

---

## Environment Variables

Set these in your app's **development** environment (Replit Secrets tab):

```bash
# Required
ZLC_BOOTSTRAP_URL=https://zillowlabs-core.replit.app/bootstrap?appId=my-app&channel=stable

# Optional
ZLC_TOKEN=your-bearer-token
ZLC_STRICT=0
ZLC_CACHE_DIR=.cache/zillowlabs-core
ZLC_TIMEOUT_MS=15000
ZLC_DEBUG=1
```

These variables are only used in development. In production the bootstrap exits before reading them.

### Variable Reference

| Variable | Required | Default | Description |
|---|---|---|---|
| `ZLC_BOOTSTRAP_URL` | Yes | — | Full URL to this service's `/bootstrap` endpoint. Replace `my-app` with your app's unique ID. |
| `REPL_ID` | Auto | — | Set automatically by Replit. Identifies the app for app-level skill overrides. |
| `REPL_OWNER` | Auto | — | Set automatically by Replit. Identifies the user for user-level skill overrides across all apps. |
| `REPL_SLUG` | Auto | — | Set automatically by Replit. Human-readable app name, used as display name in the dashboard. |
| `REPL_LANGUAGE` | Auto | — | Set automatically by Replit. App's programming language, shown in the dashboard for context. |
| `REPLIT_DEV_DOMAIN` | Auto | — | Set automatically by Replit (dev only). The `.replit.dev` URL for the app, shown as a link in the dashboard. |
| `ZLC_TOKEN` | No | — | Bearer token for authenticated requests. |
| `ZLC_STRICT` | No | `0` | Set to `1` to fail startup if sync fails. Default `0` (fail-open). |
| `ZLC_CACHE_DIR` | No | `.cache/zillowlabs-core` | Local directory for cached configs and engine scripts. |
| `ZLC_TIMEOUT_MS` | No | `15000` | Network request timeout in milliseconds. |
| `ZLC_DEBUG` | No | `0` | Set to `1` to enable verbose debug logging. |

---

## Verification

After installation, restart your workflow. You should see output like:

```
[zlc-bootstrap] fetching config from https://zillowlabs-core.replit.app/bootstrap...
[zlc-bootstrap] downloading engine...
[zlc-engine] syncing to .agents/skills...
[zlc-sync:skills] 3 files synced, 0 skipped
[zlc-engine] done
[zlc-bootstrap] done
```

If you set `ZLC_DEBUG=1`, you'll see additional detail about cache hits, hash checks, and individual file operations.

---

## How It Works

1. **Bootstrap** (`scripts/zillowlabs_core_bootstrap.mjs`) runs before your dev server via the workflow command.
2. If `NODE_ENV=production`, it exits immediately — no network calls, no file changes.
3. Otherwise, it fetches a config from `ZLC_BOOTSTRAP_URL`, automatically appending your `REPL_ID` and `REPL_OWNER` so the service knows which skill overrides to apply (app-level and user-level).
4. It downloads the engine script (with SHA-256 verification) if needed, caching it locally.
5. The engine reads the config, fetches file manifests (filtered by your app's per-app skill settings), and syncs files into target directories (e.g., `.agents/skills`).

### Fail-Open vs Strict Mode

- **Default (fail-open):** If the service is unreachable, the bootstrap uses cached config/engine and continues. If no cache exists, it skips syncing silently — your app still starts.
- **Strict (`ZLC_STRICT=1`):** If the service is unreachable and no cache exists, the bootstrap exits with code 1, preventing startup.

---

## Security

- **SHA-256 Integrity** — All files include SHA-256 hashes. The engine verifies integrity before writing. Hash mismatches abort the sync.
- **Path Traversal Protection** — The engine rejects any file paths containing `../`, null bytes, or absolute paths.
- **Atomic Writes** — Files are written to a temporary location first, then atomically renamed into place. Partial writes never corrupt your files.
- **Managed Pruning** — When `prune: "managed"` is set, only files previously installed by the updater are removed. Your custom files are never touched.

---

## Service Endpoints

These public endpoints are used by the bootstrap/engine and do not require authentication:

| Endpoint | Description |
|---|---|
| `GET /bootstrap?appId=X&channel=Y&replId=Z&owner=W&slug=S&language=L&devDomain=D` | Returns bootstrap config with engine URL and sync jobs. Auto-registers app with metadata. |
| `GET /engine/:version/engine.mjs` | Returns the engine script (immutable, cached forever). |
| `GET /manifests/skills.json?replId=X&owner=Y` | Returns the file manifest with three-tier override resolution. |
| `GET /files/skills/:filepath` | Returns raw file content for a skill file. |
| `GET /client/zillowlabs_core_bootstrap.mjs` | Downloadable bootstrap script. |
| `GET /client/zillowlabs-core-widget.js` | Embeddable widget script (reads `data-repl-id` and `data-repl-owner` attributes). |
| `GET /widget?replId=X&owner=Y` | Widget HTML page with three-state skill controls (loaded inside the iframe). |
| `GET /app-skills/:replId?owner=Y` | Returns all skills with three-tier effective state. |
| `POST /app-skills/:replId?owner=Y` | Set skill scope: `{skillId, scope}` where scope is `app`, `user`, `disabled`, or `default`. |
| `DELETE /app-skills/:replId/:skillId?owner=Y` | Remove all overrides for a skill. |

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `[zlc-bootstrap] fetch failed: ...` | Service unreachable or `ZLC_BOOTSTRAP_URL` wrong. | Check the URL. Ensure network access. Cached config will be used if available. |
| `[zlc-engine] HASH MISMATCH` | File was corrupted in transit. | Retry. If persistent, check for a proxy/CDN modifying responses. |
| `[zlc-engine] UNSAFE PATH REJECTED` | Manifest contains a path with `../` or absolute path. | This is a server-side issue. Report to the service admin. |
| No output at all | Bootstrap not chained into the dev script. | Ask the AI agent to prepend `node scripts/zillowlabs_core_bootstrap.mjs &&` to your `dev` script in `package.json`. |
| Files not updating | Engine cache hit — files haven't changed on the server. | Set `ZLC_DEBUG=1` to confirm. Or delete `.cache/zillowlabs-core/` to force a full re-sync. |
| Widget skill toggle not taking effect | The bootstrap needs a server restart to pick up changes. | Restart your dev server after toggling skills in the widget. Also delete `.cache/zillowlabs-core/` to clear stale configs. |
| Nothing happens in production | This is expected. The bootstrap is a no-op when `NODE_ENV=production`. | No action needed. |
