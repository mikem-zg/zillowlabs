# Extension Architecture

## Component Overview

A Chrome extension can use multiple UI surfaces and background processes. Each component runs in a different execution context with different capabilities.

| Component | DOM Access | Chrome APIs | Lifetime | Primary Use |
|-----------|------------|-------------|----------|-------------|
| **Service Worker** | None | Full | Event-driven (~30s idle timeout) | Event handling, API calls, coordination |
| **Content Script** | Host page DOM | Limited (storage, runtime) | Per-page | DOM manipulation, UI injection |
| **Popup** | Own DOM | Full | While visible (closes on click-away) | Quick actions, status, settings |
| **Side Panel** | Own DOM | Full | Persistent (stays open across tabs) | Companion UI alongside pages |
| **Options Page** | Own DOM | Full | While tab is open | Extension configuration |
| **DevTools Panel** | Inspected page (via eval) | DevTools + limited | While DevTools is open | Developer inspection tools |

---

## Service Worker (Background)

The service worker is the central event handler. It replaces MV2's persistent background pages.

### Lifecycle
1. Loads when an event fires (install, message, alarm, etc.)
2. Executes event handlers
3. Terminates after ~30 seconds of inactivity
4. Chrome API calls reset the idle timer

### Capabilities
- Full access to all Chrome APIs
- Cross-origin fetch (with host_permissions)
- Relay messages between components
- NO DOM access (`document`, `window` are unavailable)
- NO persistent state (global variables reset on termination)

### Service Worker Template

```typescript
// src/background/service-worker.ts

// Extension installed or updated
chrome.runtime.onInstalled.addListener((details) => {
  if (details.reason === 'install') {
    chrome.storage.local.set({ settings: { enabled: true, theme: 'light' } });
    chrome.tabs.create({ url: chrome.runtime.getURL('options/index.html') });
  }
});

// Message handler
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'GET_DATA') {
    fetchData(message.payload)
      .then(data => sendResponse({ success: true, data }))
      .catch(error => sendResponse({ success: false, error: error.message }));
    return true; // CRITICAL: keeps message channel open for async response
  }

  if (message.type === 'UPDATE_SETTINGS') {
    chrome.storage.local.set({ settings: message.payload });
    sendResponse({ success: true });
  }
});

// Tab events
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === 'complete' && tab.url?.includes('zillow.com')) {
    chrome.tabs.sendMessage(tabId, { type: 'PAGE_LOADED', url: tab.url });
  }
});

async function fetchData(params: Record<string, string>) {
  const response = await fetch('https://api.example.com/data', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(params),
  });
  return response.json();
}
```

### State Persistence Pattern

```typescript
// WRONG: Global variables are lost when service worker terminates
let counter = 0;
chrome.action.onClicked.addListener(() => {
  counter++; // Resets to 0 when worker restarts
});

// CORRECT: Use chrome.storage for persistence
chrome.action.onClicked.addListener(async () => {
  const { counter = 0 } = await chrome.storage.local.get('counter');
  await chrome.storage.local.set({ counter: counter + 1 });
});
```

### Module Imports

```json
{
  "background": {
    "service_worker": "background.js",
    "type": "module"
  }
}
```

```typescript
// With "type": "module", ES6 imports work
import { processData } from './utils/data-processor.js';
import { CONSTANTS } from './config.js';

// Without "type": "module", use importScripts()
importScripts('lib/helper.js', 'config.js');
```

---

## Content Scripts

Content scripts run in the context of web pages and can read/modify the DOM.

### Execution Environment
- **Isolated world** (default): Separate JS context, shares DOM with host page
- **Main world**: Same JS context as the page (can access page variables)
- Limited Chrome API access: `chrome.runtime`, `chrome.storage`, `chrome.i18n`

### Content Script Template

```typescript
// src/content/index.tsx

// Avoid running multiple times
if (document.getElementById('zillow-ext-root')) {
  throw new Error('Extension already injected');
}

// Create isolated container with Shadow DOM
const container = document.createElement('div');
container.id = 'zillow-ext-root';
document.body.appendChild(container);

const shadow = container.attachShadow({ mode: 'open' });

// Inject styles
const fontCSS = await fetch(chrome.runtime.getURL('styles/fonts.css')).then(r => r.text());
const tokenCSS = await fetch(chrome.runtime.getURL('styles/tokens.css')).then(r => r.text());
const appCSS = await fetch(chrome.runtime.getURL('styles/content-app.css')).then(r => r.text());

const sheet = new CSSStyleSheet();
sheet.replaceSync([fontCSS, tokenCSS, appCSS].join('\n'));
shadow.adoptedStyleSheets = [sheet];

// Mount React app
const mountPoint = document.createElement('div');
shadow.appendChild(mountPoint);

import { createRoot } from 'react-dom/client';
import App from './App';

createRoot(mountPoint).render(<App />);

// Listen for messages from service worker
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'PAGE_LOADED') {
    // React to page load event
    sendResponse({ received: true });
  }
});
```

### Communicating with Service Worker

```typescript
// Content script → Service worker
const response = await chrome.runtime.sendMessage({
  type: 'GET_DATA',
  payload: { url: window.location.href }
});

// Service worker → Content script
chrome.tabs.sendMessage(tabId, { type: 'UPDATE_UI', data: newData });
```

### DOM Observation Pattern

```typescript
const observer = new MutationObserver((mutations) => {
  for (const mutation of mutations) {
    for (const node of mutation.addedNodes) {
      if (node instanceof HTMLElement && node.matches('.target-selector')) {
        processElement(node);
      }
    }
  }
});

observer.observe(document.body, {
  childList: true,
  subtree: true,
});
```

---

## Popup

The popup appears when clicking the extension icon in the toolbar.

### Characteristics
- Closes when user clicks outside
- Full Chrome API access
- Own HTML/CSS/JS context (no host page interference)
- Recommended width: 300-400px; max: 800x600px

### Popup Template

```html
<!-- popup/index.html -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="stylesheet" href="styles.css" />
</head>
<body>
  <div id="root"></div>
  <script type="module" src="main.tsx"></script>
</body>
</html>
```

```tsx
// popup/main.tsx
import { createRoot } from 'react-dom/client';
import App from './App';

createRoot(document.getElementById('root')!).render(<App />);
```

```tsx
// popup/App.tsx
import { useState, useEffect } from 'react';

function App() {
  const [settings, setSettings] = useState({ enabled: true });

  useEffect(() => {
    chrome.storage.local.get('settings', (result) => {
      if (result.settings) setSettings(result.settings);
    });
  }, []);

  const toggleEnabled = async () => {
    const newSettings = { ...settings, enabled: !settings.enabled };
    await chrome.storage.local.set({ settings: newSettings });
    setSettings(newSettings);
  };

  return (
    <div style={{ width: '360px', padding: '16px' }}>
      <h2>My Extension</h2>
      <button onClick={toggleEnabled}>
        {settings.enabled ? 'Disable' : 'Enable'}
      </button>
    </div>
  );
}

export default App;
```

---

## Side Panel

Persistent UI panel that appears alongside web page content. Available since Chrome 114.

### Setup

```json
{
  "permissions": ["sidePanel"],
  "side_panel": {
    "default_path": "sidepanel/index.html"
  }
}
```

### Opening the Side Panel

```typescript
// Open on extension icon click
chrome.sidePanel.setPanelBehavior({ openPanelOnActionClick: true });

// Open programmatically (global)
chrome.sidePanel.open({ windowId: (await chrome.windows.getCurrent()).id });

// Open programmatically (tab-specific)
chrome.sidePanel.open({ tabId: tab.id });

// Site-specific side panel
chrome.tabs.onUpdated.addListener(async (tabId, info, tab) => {
  if (!tab.url) return;
  const url = new URL(tab.url);
  await chrome.sidePanel.setOptions({
    tabId,
    path: url.origin.includes('zillow.com') ? 'sidepanel/zillow.html' : 'sidepanel/default.html',
    enabled: true,
  });
});
```

### Side Panel Template

```tsx
// sidepanel/App.tsx
function SidePanelApp() {
  const [pageData, setPageData] = useState(null);

  useEffect(() => {
    // Listen for data from content script via service worker
    chrome.runtime.onMessage.addListener((message) => {
      if (message.type === 'PAGE_DATA') {
        setPageData(message.data);
      }
    });
  }, []);

  return (
    <div style={{ padding: '16px', height: '100vh', overflowY: 'auto' }}>
      <h2>Property Details</h2>
      {pageData && <PropertyInfo data={pageData} />}
    </div>
  );
}
```

---

## Options Page

Settings and configuration UI for the extension.

### Setup

```json
{
  "options_ui": {
    "page": "options/index.html",
    "open_in_tab": false
  }
}
```

| `open_in_tab` | Behavior |
|---------------|----------|
| `false` | Embedded within `chrome://extensions` |
| `true` | Opens in a new browser tab |

### Opening Options Programmatically

```typescript
// From popup, side panel, or service worker
chrome.runtime.openOptionsPage();
```

---

## DevTools Panel

Custom panel in Chrome DevTools for developer inspection tools.

### Setup

```json
{
  "devtools_page": "devtools/index.html"
}
```

```html
<!-- devtools/index.html -->
<!DOCTYPE html>
<html>
<body>
  <script src="devtools.js"></script>
</body>
</html>
```

```typescript
// devtools/devtools.js
chrome.devtools.panels.create(
  'My Panel',
  'icons/icon16.png',
  'devtools/panel.html',
  (panel) => {
    panel.onShown.addListener((window) => { /* panel visible */ });
    panel.onHidden.addListener(() => { /* panel hidden */ });
  }
);

// Create sidebar in Elements panel
chrome.devtools.panels.elements.createSidebarPane('Styles', (sidebar) => {
  sidebar.setExpression('document.body.style', 'Body Styles');
});
```

### Inspecting the Page

```typescript
// Execute code in the inspected page's context
chrome.devtools.inspectedWindow.eval(
  'document.querySelectorAll("[data-testid]").length',
  (result, isException) => {
    if (!isException) console.log('Test IDs found:', result);
  }
);
```

### Theme Detection

```typescript
const isDark = chrome.devtools.panels.themeName === 'dark';
```

---

## Message Passing Patterns

### One-Time Messages

```typescript
// Sender (any context)
const response = await chrome.runtime.sendMessage({
  type: 'ACTION_NAME',
  payload: { key: 'value' }
});

// Receiver (service worker)
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'ACTION_NAME') {
    handleAction(message.payload)
      .then(result => sendResponse({ success: true, data: result }))
      .catch(err => sendResponse({ success: false, error: err.message }));
    return true; // Required for async sendResponse
  }
});
```

### Long-Lived Connections

```typescript
// Sender
const port = chrome.runtime.connect({ name: 'data-stream' });
port.postMessage({ type: 'subscribe', topic: 'prices' });
port.onMessage.addListener((message) => {
  console.log('Received:', message);
});
port.onDisconnect.addListener(() => {
  console.log('Connection closed');
});

// Receiver (service worker)
chrome.runtime.onConnect.addListener((port) => {
  if (port.name === 'data-stream') {
    port.onMessage.addListener((message) => {
      if (message.type === 'subscribe') {
        // Send periodic updates
        const interval = setInterval(() => {
          port.postMessage({ type: 'update', data: getLatestData() });
        }, 5000);
        port.onDisconnect.addListener(() => clearInterval(interval));
      }
    });
  }
});
```

### Service Worker → Specific Tab

```typescript
// Send to a specific tab's content script
chrome.tabs.sendMessage(tabId, { type: 'UPDATE', data: newData });

// Send to active tab
const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
if (tab?.id) {
  chrome.tabs.sendMessage(tab.id, { type: 'REFRESH' });
}
```

### Typed Message Pattern

```typescript
// types.ts — shared across all extension components
type MessageMap = {
  GET_SETTINGS: { request: void; response: Settings };
  SAVE_SETTINGS: { request: Settings; response: { success: boolean } };
  FETCH_DATA: { request: { url: string }; response: ApiData };
  PAGE_LOADED: { request: { url: string }; response: void };
};

type MessageType = keyof MessageMap;

interface ExtMessage<T extends MessageType> {
  type: T;
  payload: MessageMap[T]['request'];
}

async function sendMessage<T extends MessageType>(
  type: T,
  payload: MessageMap[T]['request']
): Promise<MessageMap[T]['response']> {
  return chrome.runtime.sendMessage({ type, payload });
}

// Usage
const settings = await sendMessage('GET_SETTINGS', undefined);
await sendMessage('SAVE_SETTINGS', { enabled: true, theme: 'dark' });
```

---

## Extension Lifecycle Events

```typescript
// First install
chrome.runtime.onInstalled.addListener((details) => {
  switch (details.reason) {
    case 'install':
      // First time setup
      chrome.storage.local.set({ version: chrome.runtime.getManifest().version });
      chrome.tabs.create({ url: 'onboarding/index.html' });
      break;
    case 'update':
      // Extension updated
      const newVersion = chrome.runtime.getManifest().version;
      console.log(`Updated to ${newVersion}`);
      break;
    case 'chrome_update':
      // Browser updated
      break;
  }
});

// Browser started (extension already installed)
chrome.runtime.onStartup.addListener(async () => {
  // Re-create alarms if needed
  const alarm = await chrome.alarms.get('periodic-check');
  if (!alarm) {
    chrome.alarms.create('periodic-check', { periodInMinutes: 30 });
  }
});

// Extension suspended (about to be unloaded)
chrome.runtime.onSuspend.addListener(() => {
  // Cleanup: close connections, save state
});
```
