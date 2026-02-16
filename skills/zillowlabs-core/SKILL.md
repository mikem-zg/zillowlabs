
# zillowlabs-core — Client Installation Guide

> Centralized update service that keeps your app's local assets (`.agents/skills`) automatically in sync **during development only**. The bootstrap is a no-op in production.

---

## Quick Start

Follow these steps in order. Each step uses a shell command — run them in the project root.

### Step 1: Download the bootstrap script

```bash
mkdir -p scripts && curl -fsSL https://zillowlabs-core.replit.app/client/zillowlabs_core_bootstrap.mjs -o scripts/zillowlabs_core_bootstrap.mjs
```

### Step 2: Add cache directory to .gitignore

```bash
node -e "const fs=require('fs');const gi='.gitignore';const line='.cache/zillowlabs-core/';const cur=fs.existsSync(gi)?fs.readFileSync(gi,'utf8'):'';if(!cur.split(/\r?\n/).includes(line))fs.appendFileSync(gi,(cur.endsWith('\n')||cur===''?'':'\n')+line+'\n');console.log('added to .gitignore:',line);"
```

### Step 3: Chain bootstrap into your dev command

The bootstrap must run **before** your dev server on every startup. Create a wrapper script that runs the bootstrap first, then calls the original dev command.

**How to do it:** First, read `package.json` and find the current `"dev"` script value (e.g., `tsx server/index.ts`, `vite`, `next dev`, etc.). Then create a wrapper script at `scripts/dev.sh`:

```bash
#!/bin/bash
node scripts/zillowlabs_core_bootstrap.mjs
ORIGINAL_DEV_COMMAND_HERE
```

Replace `ORIGINAL_DEV_COMMAND_HERE` with whatever the current `"dev"` script runs. For example, if the dev script is `"tsx server/index.ts"`, then `scripts/dev.sh` should be:

```bash
#!/bin/bash
node scripts/zillowlabs_core_bootstrap.mjs
npx tsx server/index.ts
```

Then make it executable:

```bash
chmod +x scripts/dev.sh
```

Finally, update the `"dev"` script in `package.json` to call the wrapper:

```json
"dev": "bash scripts/dev.sh"
```

> **Why a wrapper script?** On Replit, `package.json` may be a protected file that can't be edited with file tools. If that's the case, use `bash` to run a `sed` command to update it:
>
> ```bash
> sed -i 's|"dev": ".*"|"dev": "bash scripts/dev.sh"|' package.json
> ```
>
> This reliably modifies the dev script regardless of file protection. The wrapper script itself is always editable.

### Step 4: Set the environment variable

Set this in the **development** environment (not production):

```bash
ZLC_BOOTSTRAP_URL=https://zillowlabs-core.replit.app/bootstrap?appId=my-app&channel=stable
```

Use the `set_env_vars` tool with `environment: "development"` to set it.

### Step 5: Add widget to index.html

The widget adds a small floating "ZillowLabs" button in the bottom-right corner of your app during development. It lets users toggle skills on/off without leaving the app.

Use the `edit` tool to add this script tag to your HTML entry point (`client/index.html`, `index.html`, or `public/index.html`) — insert it just before `</head>` or `</body>` (either works since the script uses `defer`):

```html
<script src="https://zillowlabs-core.replit.app/client/zillowlabs-core-widget.js" data-repl-id="REPL_ID_VALUE" data-repl-owner="REPL_OWNER_VALUE" defer></script>
```

To get the actual values, run these commands and use the output:

```bash
echo $REPL_ID
echo $REPL_OWNER
```

Replace `REPL_ID_VALUE` and `REPL_OWNER_VALUE` with the values from those commands.

> **Note:** The widget only renders in development (`.replit.dev` domains). It automatically hides itself on published apps (`.replit.app` domains). It has no effect on your server or production builds.

### Step 6: Restart and verify

Restart the dev server. You should see output like:

```
[zlc-bootstrap] fetching config from https://zillowlabs-core.replit.app/bootstrap...
[zlc-bootstrap] downloading engine...
[zlc-engine] syncing to .agents/skills...
[zlc-sync:skills] 3 files synced, 0 skipped
[zlc-engine] done
[zlc-bootstrap] done
```

You should see a small "ZillowLabs" widget in the bottom-right corner of your app's Preview — this only appears in the dev environment. If you don't see it, you can manage your app's skills and turn them on/off by visiting the unique URL saved in `docs/skills-url.md` (created automatically by the engine on first sync).

**After installation, read `docs/skills-url.md` and display its contents to the user** so they have the direct link to manage their app's skills. If `docs/skills-url.md` doesn't exist (e.g., due to a hash mismatch on first sync), delete `.cache/zillowlabs-core/` and restart the dev server to trigger a clean sync. If it still doesn't appear, construct the URL manually:

```
https://zillowlabs-core.replit.app/widget?replId=REPL_ID_VALUE&owner=REPL_OWNER_VALUE
```

Replace `REPL_ID_VALUE` and `REPL_OWNER_VALUE` with the values from `echo $REPL_ID` and `echo $REPL_OWNER`.

> **Hash mismatch warnings:** If you see `[zlc-engine] HASH MISMATCH` in the output, this means a file changed on the server between when the manifest was generated and when the file was downloaded. In fail-open mode (the default), the bootstrap skips that file and continues. This is harmless — the file will sync correctly on the next restart. To fix immediately, delete `.cache/zillowlabs-core/` and restart. This also resolves a missing `docs/skills-url.md`.

---

## App Heartbeat (Usage Tracking)

The heartbeat lets this library track which apps are actively using skills. Each heartbeat sends a small JSON payload with the app's identity and skill count. Results appear on the Reports page under "Active apps".

**What counts as a heartbeat:** Any HTTP POST to this library's `/api/heartbeat` endpoint with a JSON body containing at least an `appId`. The server records when it was first and last seen, plus the app name and skill count.

### Required: Set the library URL

Before using heartbeats, set the `SKILLS_LIBRARY_URL` environment variable to the published URL of this Skill & MCP Library app. In the app that should send heartbeats, add this secret:

```
SKILLS_LIBRARY_URL=https://<your-published-domain>
```

For example, if this library is published at `https://zillowlabs-core.replit.app`, set `SKILLS_LIBRARY_URL=https://zillowlabs-core.replit.app`. During development, use the dev domain (e.g., `https://18d34e23-xxxx.worf.replit.dev`).

### Sending a heartbeat (bash)

Add this to your app's bootstrap or startup script:

```bash
LIBRARY_URL="${SKILLS_LIBRARY_URL:-https://zillowlabs-core.replit.app}"
curl -s -X POST "${LIBRARY_URL}/api/heartbeat" \
  -H "Content-Type: application/json" \
  -d "{\"appId\": \"$REPL_ID\", \"appName\": \"$REPL_SLUG\", \"replSlug\": \"$REPL_SLUG\", \"skillCount\": $(ls -d .agents/skills/*/ 2>/dev/null | wc -l)}"
```

### Sending a heartbeat (Node.js)

```js
const libraryUrl = process.env.SKILLS_LIBRARY_URL || "https://zillowlabs-core.replit.app";
fetch(`${libraryUrl}/api/heartbeat`, {
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

### Payload fields

| Field | Required | Description |
|-------|----------|-------------|
| `appId` | Yes | Unique identifier (use `REPL_ID` env var) |
| `appName` | No | Human-readable name (use `REPL_SLUG` env var) |
| `replSlug` | No | Repl slug for linking |
| `skillCount` | No | Number of skill directories installed |

### Behavior

- **Idempotent** — duplicate calls update the "last seen" timestamp without creating extra records
- **Upsert** — first call creates the record, subsequent calls update `lastSeenAt` and any non-null fields
- **No auth required** — the endpoint is open so any app can register itself

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

## How It Works

1. **Bootstrap** (`scripts/zillowlabs_core_bootstrap.mjs`) runs before your dev server via the wrapper script.
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
| `[zlc-engine] HASH MISMATCH` | File changed on server between manifest fetch and file download. | Harmless in fail-open mode. Delete `.cache/zillowlabs-core/` and restart for a clean sync. |
| `[zlc-engine] UNSAFE PATH REJECTED` | Manifest contains a path with `../` or absolute path. | This is a server-side issue. Report to the service admin. |
| No output at all | Bootstrap not chained into the dev script. | Ensure `scripts/dev.sh` exists and `package.json` has `"dev": "bash scripts/dev.sh"`. |
| Files not updating | Engine cache hit — files haven't changed on the server. | Set `ZLC_DEBUG=1` to confirm. Or delete `.cache/zillowlabs-core/` to force a full re-sync. |
| `docs/skills-url.md` not created | Engine skipped file creation due to hash mismatch or partial sync. | Delete `.cache/zillowlabs-core/` and restart. Or construct the URL manually: `https://zillowlabs-core.replit.app/widget?replId=YOUR_REPL_ID&owner=YOUR_REPL_OWNER`. |
| Widget skill toggle not taking effect | The bootstrap needs a server restart to pick up changes. | Restart your dev server after toggling skills in the widget. Also delete `.cache/zillowlabs-core/` to clear stale configs. |
| Nothing happens in production | This is expected. The bootstrap is a no-op when `NODE_ENV=production`. | No action needed. |
