# Manifest V3 Complete Reference

## Manifest File Structure

Every Chrome extension requires a `manifest.json` at its root. Manifest V3 is mandatory for all new extensions.

```json
{
  "manifest_version": 3,
  "name": "Extension Name",
  "version": "1.0.0",
  "description": "Clear, specific description of what it does",

  "action": {
    "default_popup": "popup/index.html",
    "default_icon": {
      "16": "icons/icon16.png",
      "24": "icons/icon24.png",
      "32": "icons/icon32.png",
      "48": "icons/icon48.png",
      "128": "icons/icon128.png"
    },
    "default_title": "Extension tooltip text",
    "default_state": "enabled"
  },

  "background": {
    "service_worker": "src/background/service-worker.js",
    "type": "module"
  },

  "content_scripts": [
    {
      "matches": ["https://*.example.com/*"],
      "js": ["src/content/index.js"],
      "css": ["src/content/styles.css"],
      "run_at": "document_idle",
      "all_frames": false,
      "match_about_blank": false
    }
  ],

  "permissions": [
    "storage",
    "activeTab",
    "alarms",
    "notifications",
    "contextMenus"
  ],

  "optional_permissions": [
    "bookmarks",
    "history",
    "topSites"
  ],

  "host_permissions": [
    "https://api.example.com/*"
  ],

  "optional_host_permissions": [
    "https://*/*",
    "http://*/*"
  ],

  "side_panel": {
    "default_path": "sidepanel/index.html"
  },

  "options_ui": {
    "page": "options/index.html",
    "open_in_tab": false
  },

  "devtools_page": "devtools/index.html",

  "icons": {
    "16": "icons/icon16.png",
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  },

  "web_accessible_resources": [
    {
      "resources": ["fonts/*", "styles/*", "images/*"],
      "matches": ["<all_urls>"]
    }
  ],

  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'; font-src 'self';"
  },

  "minimum_chrome_version": "114"
}
```

---

## Permissions Reference

### API Permissions (No User Warning)

| Permission | API Access | Notes |
|------------|-----------|-------|
| `activeTab` | Temporary access to active tab via user gesture | Preferred over broad host permissions |
| `alarms` | `chrome.alarms` | Scheduled tasks |
| `contextMenus` | `chrome.contextMenus` | Right-click menus |
| `cookies` | `chrome.cookies` | Read/write cookies |
| `declarativeContent` | `chrome.declarativeContent` | Conditional page actions |
| `declarativeNetRequest` | `chrome.declarativeNetRequest` | Network request modification |
| `dns` | `chrome.dns` | DNS resolution |
| `fontSettings` | `chrome.fontSettings` | Browser font settings |
| `gcm` | `chrome.gcm` | Google Cloud Messaging |
| `identity` | `chrome.identity` | OAuth2 authentication |
| `idle` | `chrome.idle` | User idle detection |
| `offscreen` | `chrome.offscreen` | Offscreen documents |
| `power` | `chrome.power` | Power management |
| `scripting` | `chrome.scripting` | Dynamic script injection |
| `search` | `chrome.search` | Default search engine |
| `sessions` | `chrome.sessions` | Recently closed tabs/windows |
| `sidePanel` | `chrome.sidePanel` | Side panel UI |
| `storage` | `chrome.storage` | Extension storage |
| `system.cpu` | `chrome.system.cpu` | CPU info |
| `system.display` | `chrome.system.display` | Display info |
| `system.memory` | `chrome.system.memory` | Memory info |
| `tabGroups` | `chrome.tabGroups` | Tab grouping |
| `tabs` | `chrome.tabs` (url, title, favIconUrl) | Tab metadata |
| `tts` | `chrome.tts` | Text-to-speech |
| `unlimitedStorage` | Remove 5MB storage limit | Unlimited local storage |
| `webNavigation` | `chrome.webNavigation` | Navigation events |
| `webRequest` | `chrome.webRequest` | Network request observation |

### Permissions with User Warnings

| Permission | Warning Shown |
|------------|---------------|
| `bookmarks` | "Read and change your bookmarks" |
| `clipboardRead` | "Read data you copy and paste" |
| `clipboardWrite` | "Modify data you copy and paste" |
| `debugger` | "Access the page debugger backend" |
| `desktopCapture` | "Capture content of your screen" |
| `downloads` | "Manage your downloads" |
| `geolocation` | "Detect your physical location" |
| `history` | "Read and change your browsing history" |
| `management` | "Manage your apps, extensions, and themes" |
| `nativeMessaging` | "Communicate with cooperating native applications" |
| `notifications` | "Display notifications" |
| `privacy` | "Change your privacy-related settings" |
| `proxy` | "Read and modify proxy settings" |
| `topSites` | "Read a list of most frequently visited sites" |

---

## Host Permissions

Host permissions control which websites the extension can interact with.

```json
{
  "host_permissions": [
    "https://www.example.com/*",
    "https://*.example.com/*",
    "*://example.com/*",
    "https://api.example.com/v1/*",
    "<all_urls>"
  ]
}
```

### Match Patterns

| Pattern | Matches |
|---------|---------|
| `https://www.example.com/*` | All pages on www.example.com over HTTPS |
| `https://*.example.com/*` | All subdomains of example.com over HTTPS |
| `*://example.com/*` | HTTP and HTTPS on example.com |
| `<all_urls>` | All URLs (triggers strongest warning) |
| `http://localhost:*/*` | Localhost on any port |
| `file:///*` | Local files |

### Optional Host Permissions

Request at runtime to minimize install warnings:

```json
{
  "optional_host_permissions": [
    "https://*/*"
  ]
}
```

```typescript
chrome.permissions.request({
  origins: ['https://api.newsite.com/*']
}, (granted) => {
  if (granted) {
    // Permission granted at runtime
  }
});
```

---

## Content Security Policy

### Default CSP (MV3)

```
script-src 'self'; object-src 'self';
```

### Custom CSP

```json
{
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'; font-src 'self'; style-src 'self' 'unsafe-inline';",
    "sandbox": "sandbox allow-scripts; script-src 'self' 'unsafe-eval';"
  }
}
```

### CSP Restrictions in MV3

| Allowed | Prohibited |
|---------|------------|
| `'self'` (extension's own resources) | `'unsafe-eval'` on extension pages |
| `'wasm-unsafe-eval'` (WebAssembly) | Remote script sources (`https://cdn.example.com`) |
| `'unsafe-inline'` for styles only | `eval()`, `new Function()`, `setTimeout(string)` |
| `blob:` and `filesystem:` | Inline `<script>` tags |
| localhost sources (dev only) | Remote code of any kind |

---

## Content Scripts

### Static Declaration

```json
{
  "content_scripts": [
    {
      "matches": ["https://*.zillow.com/*", "https://*.trulia.com/*"],
      "exclude_matches": ["https://www.zillow.com/admin/*"],
      "js": ["src/content/index.js"],
      "css": ["src/content/styles.css"],
      "run_at": "document_idle",
      "all_frames": false,
      "match_about_blank": false,
      "world": "ISOLATED"
    }
  ]
}
```

### `run_at` Options

| Value | When |
|-------|------|
| `document_idle` (default) | After DOM is complete, before `window.onload` |
| `document_start` | Before any other scripts run |
| `document_end` | After DOM is complete, before images/subframes load |

### `world` Options

| Value | Description |
|-------|-------------|
| `ISOLATED` (default) | Separate JS execution environment, shares DOM |
| `MAIN` | Same execution context as the page (can access page variables) |

### Dynamic Content Script Registration

```typescript
await chrome.scripting.registerContentScripts([{
  id: 'my-script',
  matches: ['https://*.example.com/*'],
  js: ['src/content/index.js'],
  runAt: 'document_idle'
}]);

await chrome.scripting.unregisterContentScripts({ ids: ['my-script'] });
```

---

## Web Accessible Resources

Resources that can be accessed by web pages or content scripts via `chrome.runtime.getURL()`.

```json
{
  "web_accessible_resources": [
    {
      "resources": [
        "fonts/*.woff2",
        "fonts/*.woff",
        "styles/*.css",
        "images/*.png",
        "images/*.svg"
      ],
      "matches": ["<all_urls>"]
    },
    {
      "resources": ["api-config.json"],
      "matches": ["https://*.zillow.com/*"],
      "use_dynamic_url": true
    }
  ]
}
```

### `use_dynamic_url`

When `true`, the resource URL changes per session, preventing fingerprinting. Use for sensitive resources.

---

## Icons

Required sizes for Chrome Web Store and browser UI:

| Size | Usage |
|------|-------|
| **16x16** | Favicon, toolbar icon |
| **24x24** | Toolbar icon (optional, for crisp display) |
| **32x32** | Toolbar icon on high-DPI displays |
| **48x48** | Extensions management page |
| **128x128** | Chrome Web Store listing, installation dialog |

### Design Guidelines
- Use PNG format with transparency
- Keep designs simple and recognizable at 16x16
- Avoid text in icons (unreadable at small sizes)
- Use the Zillow "Z" mark or a custom icon — do NOT use the full Zillow logo wordmark

---

## Versioning

```json
{
  "version": "1.2.3",
  "version_name": "1.2.3 Beta"
}
```

- `version`: 1-4 dot-separated integers (e.g., `1.0.0` or `1.0.0.1`)
- `version_name`: Human-readable version string (optional, shown in Chrome Web Store)
- Chrome Web Store requires version to increase with each upload

---

## Internationalization

```json
{
  "name": "__MSG_extensionName__",
  "description": "__MSG_extensionDescription__",
  "default_locale": "en"
}
```

Create `_locales/{locale}/messages.json`:

```json
{
  "extensionName": {
    "message": "My Extension",
    "description": "The display name of the extension"
  },
  "extensionDescription": {
    "message": "A helpful Chrome extension",
    "description": "The description of the extension"
  }
}
```

---

## Complete Starter Manifest

```json
{
  "manifest_version": 3,
  "name": "Zillow Extension",
  "version": "1.0.0",
  "description": "Enhances Zillow browsing experience with property insights",
  "minimum_chrome_version": "114",

  "action": {
    "default_popup": "popup/index.html",
    "default_icon": {
      "16": "icons/icon16.png",
      "48": "icons/icon48.png",
      "128": "icons/icon128.png"
    }
  },

  "background": {
    "service_worker": "background.js",
    "type": "module"
  },

  "side_panel": {
    "default_path": "sidepanel/index.html"
  },

  "options_ui": {
    "page": "options/index.html",
    "open_in_tab": false
  },

  "content_scripts": [{
    "matches": ["https://*.zillow.com/*"],
    "js": ["content.js"],
    "run_at": "document_idle"
  }],

  "permissions": [
    "storage",
    "activeTab",
    "sidePanel",
    "contextMenus",
    "alarms"
  ],

  "host_permissions": [
    "https://*.zillow.com/*"
  ],

  "web_accessible_resources": [{
    "resources": ["fonts/*", "styles/*", "images/*"],
    "matches": ["<all_urls>"]
  }],

  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'; font-src 'self';"
  },

  "icons": {
    "16": "icons/icon16.png",
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  }
}
```
