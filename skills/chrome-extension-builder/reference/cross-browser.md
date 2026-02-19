# Cross-Browser Compatibility

Build extensions that work across Chrome, Firefox, Edge, and Safari.

---

## Browser Support Matrix

| Feature | Chrome | Firefox | Edge | Safari |
|---------|--------|---------|------|--------|
| Manifest V3 | Full support | Full support (MV2 still supported) | Full support (Chromium) | Supported since 15.4 |
| Service Workers | Yes | Event Pages (non-persistent) | Yes (Chromium) | Partial |
| Side Panel | `chrome.sidePanel` | `browser.sidebarAction` (different API) | `chrome.sidePanel` | No |
| `chrome.action` | Yes | Yes (MV3) | Yes | Yes |
| `declarativeNetRequest` | Yes | Yes | Yes | Yes |
| Blocking `webRequest` | No (MV3) | Yes (preserved in MV3) | No (Chromium) | No |
| Promise-based APIs | Chrome 121+ | Always | Yes | Yes |

---

## API Namespace

### Chrome / Edge (Chromium)

```javascript
chrome.tabs.query({ active: true }, (tabs) => { /* callback */ });
// Chrome 121+: also supports promises
const tabs = await chrome.tabs.query({ active: true });
```

### Firefox / Safari

```javascript
// Native promise-based API
const tabs = await browser.tabs.query({ active: true });
```

Firefox also supports `chrome.*` namespace with promises in MV3.

---

## WebExtension Polyfill

Normalizes the API to use `browser.*` with promises across all browsers.

### Install

```bash
npm install webextension-polyfill
npm install -D @types/webextension-polyfill
```

### Usage

```typescript
import browser from 'webextension-polyfill';

// Works the same across Chrome, Firefox, Edge, Safari
const tabs = await browser.tabs.query({ active: true, currentWindow: true });
const tab = tabs[0];

await browser.storage.local.set({ lastTab: tab.url });

const response = await browser.runtime.sendMessage({ type: 'PING' });
```

### In Content Scripts

```json
{
  "content_scripts": [{
    "matches": ["<all_urls>"],
    "js": ["browser-polyfill.js", "content.js"]
  }]
}
```

### Limitations

- Does NOT polyfill APIs that don't exist in a browser (e.g., `sidePanel` in Firefox)
- Does NOT handle API name changes (`browserAction` → `action`) — you must use the MV3 name
- Firefox already has `browser.*` natively, so the polyfill is a no-op there

---

## Manifest Differences

### Background Scripts

```json
// Chrome / Edge (MV3)
{
  "background": {
    "service_worker": "background.js",
    "type": "module"
  }
}

// Firefox (MV3) — supports both, but event pages preferred
{
  "background": {
    "scripts": ["background.js"],
    "type": "module"
  }
}
```

### Sidebar vs Side Panel

```json
// Chrome — Side Panel API
{
  "permissions": ["sidePanel"],
  "side_panel": {
    "default_path": "sidepanel.html"
  }
}

// Firefox — Sidebar Action
{
  "sidebar_action": {
    "default_panel": "sidebar.html",
    "default_title": "My Sidebar",
    "default_icon": "icon.png"
  }
}
```

### Host Permissions

```json
// Chrome / Edge (MV3) — separate key
{
  "host_permissions": ["https://*.example.com/*"]
}

// Firefox (MV3) — also separate, same syntax
{
  "host_permissions": ["https://*.example.com/*"]
}
```

---

## Feature Detection

Handle browser-specific APIs with runtime feature detection:

```typescript
import browser from 'webextension-polyfill';

// Side panel vs sidebar
function openSideUI() {
  if ('sidePanel' in chrome) {
    // Chrome side panel
    chrome.sidePanel.open({ windowId: chrome.windows.WINDOW_ID_CURRENT });
  } else if (browser.sidebarAction) {
    // Firefox sidebar
    browser.sidebarAction.open();
  } else {
    // Fallback: open as tab
    browser.tabs.create({ url: browser.runtime.getURL('sidebar.html') });
  }
}

// Offscreen documents (Chrome only)
async function parseHTML(html: string): Promise<Document> {
  if ('offscreen' in chrome) {
    // Use offscreen document
    await chrome.offscreen.createDocument({
      url: 'offscreen.html',
      reasons: ['DOM_PARSER'],
      justification: 'Parse HTML',
    });
    return chrome.runtime.sendMessage({ type: 'PARSE', html });
  } else {
    // Firefox service workers have DOMParser
    const parser = new DOMParser();
    return parser.parseFromString(html, 'text/html');
  }
}
```

---

## Build Strategy

### Single Source, Multiple Outputs

```
src/                          # Shared source code
├── background/
├── content/
├── popup/
└── utils/

builds/
├── chrome/                   # Chrome/Edge output
│   ├── manifest.json         # Chrome manifest
│   └── ...
├── firefox/                  # Firefox output
│   ├── manifest.json         # Firefox manifest
│   └── ...
└── safari/                   # Safari output (via Xcode converter)
    └── ...
```

### Build Script

```typescript
// scripts/build.ts
import { cpSync, readFileSync, writeFileSync } from 'fs';

// Base manifest
const base = JSON.parse(readFileSync('manifest.base.json', 'utf-8'));

// Chrome manifest
const chromeManifest = {
  ...base,
  background: {
    service_worker: 'background.js',
    type: 'module',
  },
  side_panel: {
    default_path: 'sidepanel.html',
  },
};
writeFileSync('builds/chrome/manifest.json', JSON.stringify(chromeManifest, null, 2));

// Firefox manifest
const firefoxManifest = {
  ...base,
  background: {
    scripts: ['background.js'],
    type: 'module',
  },
  sidebar_action: {
    default_panel: 'sidepanel.html',
    default_title: base.name,
  },
  browser_specific_settings: {
    gecko: {
      id: 'my-extension@zillow.com',
      strict_min_version: '109.0',
    },
  },
};
delete firefoxManifest.side_panel;
writeFileSync('builds/firefox/manifest.json', JSON.stringify(firefoxManifest, null, 2));
```

---

## Firefox-Specific Notes

### Extension ID

Firefox requires a stable extension ID for development:

```json
{
  "browser_specific_settings": {
    "gecko": {
      "id": "my-extension@zillow.com",
      "strict_min_version": "109.0"
    }
  }
}
```

### Testing on Firefox

1. Open `about:debugging#/runtime/this-firefox`
2. Click "Load Temporary Add-on"
3. Select any file in your extension directory

### Publishing to Firefox Add-ons

1. Go to [addons.mozilla.org](https://addons.mozilla.org/developers/)
2. Create developer account (free)
3. Upload ZIP
4. Review process: typically 1-3 days
5. Firefox supports both MV2 and MV3

---

## Edge-Specific Notes

Edge uses Chromium, so Chrome extensions work with minimal changes.

### Publishing to Edge Add-ons

1. Go to [Partner Center](https://partner.microsoft.com/dashboard/microsoftedge/)
2. Create developer account (free)
3. Upload the same ZIP as Chrome
4. Review process: 1-7 days

---

## Safari-Specific Notes

### Converting Chrome Extension to Safari

```bash
# macOS only — requires Xcode
xcrun safari-web-extension-converter /path/to/extension --project-location /path/to/output
```

This creates an Xcode project wrapping your extension.

### Safari Limitations
- Must be distributed through the Mac App Store or TestFlight
- No service worker support in older versions
- Some Chrome APIs may not be available
- Requires Apple Developer Program ($99/year)

---

## Cross-Browser Testing Checklist

```
[ ] Chrome — load unpacked from dist/, test all features
[ ] Firefox — load temporary add-on from about:debugging
[ ] Edge — load unpacked (same as Chrome since Chromium-based)
[ ] Safari — convert with Xcode tool, test in Safari (if targeting)
[ ] Verify message passing works across all components
[ ] Verify storage operations persist correctly
[ ] Verify content scripts inject and style correctly
[ ] Verify permissions prompts appear correctly
[ ] Test with webextension-polyfill for promise consistency
```

---

## Recommended Approach

1. **Primary target**: Chrome (largest market share)
2. **Secondary**: Firefox and Edge (easy to add)
3. **Optional**: Safari (requires Xcode, Apple developer account)
4. **Use `webextension-polyfill`** for consistent promise-based APIs
5. **Feature detect** browser-specific APIs (sidePanel vs sidebarAction)
6. **Maintain separate manifests** per browser, share all source code
7. **Test on all target browsers** before each release
