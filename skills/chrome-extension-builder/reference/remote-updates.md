# Remote Rendering & Auto-Update Patterns

Chrome extensions can serve UI from remote servers or receive real-time data updates without requiring Chrome Web Store republishing. Each approach has different trade-offs around capability, CSP compliance, and offline resilience.

---

## Pattern Overview

| Pattern | Best For | Chrome API Access | Auto-Updates | Offline Support |
|---------|----------|-------------------|--------------|-----------------|
| **Side Panel with iframe** | Companion webapp alongside browsing | Full (local shell) + None (iframe) | Yes — instant | Partial (local shell) |
| **Iframe in local page** | Embedding remote content in popup/options | Full (local shell) + None (iframe) | Yes — instant | Partial (local shell) |
| **WebSocket/SSE push** | Real-time data to locally-rendered UI | Full (local page) | Yes — instant | Partial (last state) |
| **Polling fetch** | Periodic data refresh | Full (local page) | Yes — on interval | Partial (cached) |
| **Remote config** | Feature flags, A/B tests, dynamic settings | Full (local page) | Yes — on check | Yes (cached fallback) |

---

## 1. Side Panel with Remote URL

The simplest approach — load a remote webpage directly in the side panel. Updates to your server are reflected immediately.

```typescript
// service-worker.ts
chrome.sidePanel.setOptions({
  path: 'https://your-app.example.com/extension-panel',
  enabled: true,
});

chrome.sidePanel.setPanelBehavior({
  openPanelOnActionClick: true,
});
```

### Communication Between Remote Page and Extension

The remote page has NO direct access to Chrome APIs. Use `chrome.runtime.sendMessage()` from the remote page (if the extension declares it as an externally connectable source) or relay through the service worker:

```json
// manifest.json
{
  "externally_connectable": {
    "matches": ["https://your-app.example.com/*"]
  }
}
```

```typescript
// Remote webpage (your-app.example.com)
const extensionId = 'YOUR_EXTENSION_ID';

// Send message to extension
chrome.runtime.sendMessage(extensionId, {
  type: 'GET_TAB_DATA',
  payload: { url: window.location.href }
}, (response) => {
  console.log('Extension responded:', response);
});
```

```typescript
// service-worker.ts — handle messages from remote page
chrome.runtime.onMessageExternal.addListener(
  (message, sender, sendResponse) => {
    if (sender.origin !== 'https://your-app.example.com') return;

    switch (message.type) {
      case 'GET_TAB_DATA':
        chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
          sendResponse({ tab: tabs[0] });
        });
        return true; // async sendResponse
      case 'SAVE_SETTING':
        chrome.storage.local.set(message.payload);
        sendResponse({ success: true });
        break;
    }
  }
);
```

### Limitations
- Remote page cannot call `chrome.tabs`, `chrome.storage`, etc. directly
- Requires `externally_connectable` in manifest
- No offline support — blank panel if server is down
- Extension ID must be known by the remote page (hardcode or pass via URL param)

---

## 2. Iframe Embedding in Local Pages

Embed remote content inside a locally-bundled popup, options, or side panel page. The local wrapper retains full Chrome API access while the iframe content auto-updates.

```html
<!-- popup/index.html (local) -->
<!DOCTYPE html>
<html>
<head><style>
  body { margin: 0; }
  iframe { width: 100%; height: 100%; border: none; }
</style></head>
<body>
  <iframe
    id="remote-frame"
    src="https://your-app.example.com/extension-embed"
    sandbox="allow-scripts allow-same-origin allow-forms"
  ></iframe>
  <script src="popup.js"></script>
</body>
</html>
```

### Bidirectional Communication via postMessage

```typescript
// popup.js (local extension page)
const iframe = document.getElementById('remote-frame') as HTMLIFrameElement;
const REMOTE_ORIGIN = 'https://your-app.example.com';

// Listen for messages FROM the iframe
window.addEventListener('message', async (event) => {
  if (event.origin !== REMOTE_ORIGIN) return;

  const { type, requestId, payload } = event.data;

  switch (type) {
    case 'GET_STORAGE': {
      const data = await chrome.storage.local.get(payload.keys);
      iframe.contentWindow?.postMessage(
        { type: 'STORAGE_RESPONSE', requestId, data },
        REMOTE_ORIGIN
      );
      break;
    }
    case 'SET_STORAGE': {
      await chrome.storage.local.set(payload);
      iframe.contentWindow?.postMessage(
        { type: 'STORAGE_RESPONSE', requestId, success: true },
        REMOTE_ORIGIN
      );
      break;
    }
    case 'GET_ACTIVE_TAB': {
      const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
      iframe.contentWindow?.postMessage(
        { type: 'TAB_RESPONSE', requestId, tab },
        REMOTE_ORIGIN
      );
      break;
    }
  }
});

// Send initialization data TO the iframe
iframe.addEventListener('load', () => {
  iframe.contentWindow?.postMessage(
    { type: 'INIT', extensionVersion: chrome.runtime.getManifest().version },
    REMOTE_ORIGIN
  );
});
```

```typescript
// Remote page (your-app.example.com/extension-embed)
// Create a typed bridge to request Chrome APIs from the host extension page

let requestCounter = 0;
const pendingRequests = new Map<number, (data: any) => void>();

window.addEventListener('message', (event) => {
  // Only accept messages from the extension
  if (!event.data?.requestId) return;
  const resolver = pendingRequests.get(event.data.requestId);
  if (resolver) {
    resolver(event.data);
    pendingRequests.delete(event.data.requestId);
  }
});

function requestFromExtension<T>(type: string, payload?: any): Promise<T> {
  return new Promise((resolve) => {
    const requestId = ++requestCounter;
    pendingRequests.set(requestId, resolve as any);
    window.parent.postMessage({ type, requestId, payload }, '*');
  });
}

// Usage in remote app
const storageData = await requestFromExtension('GET_STORAGE', { keys: ['settings'] });
const tabInfo = await requestFromExtension('GET_ACTIVE_TAB');
```

### Security: Sandbox Attributes

| Sandbox Flag | Purpose | Include? |
|-------------|---------|----------|
| `allow-scripts` | JavaScript execution in iframe | Yes (required) |
| `allow-same-origin` | Cookies, localStorage in iframe | Only if needed |
| `allow-forms` | Form submission | Only if needed |
| `allow-popups` | Opening new windows | Rarely |
| `allow-modals` | alert/confirm/prompt | Rarely |

---

## 3. WebSocket / Server-Sent Events (Real-Time Push)

Keep the UI bundled locally (full Chrome API access, offline capable) but receive real-time data updates from a server. Best for dashboards, notifications, and live data feeds.

### WebSocket from Service Worker

```typescript
// service-worker.ts
let ws: WebSocket | null = null;

function connectWebSocket() {
  ws = new WebSocket('wss://your-api.example.com/extension-ws');

  ws.onopen = () => {
    console.log('WebSocket connected');
    // Authenticate with stored credentials
    chrome.storage.local.get('authToken', ({ authToken }) => {
      ws?.send(JSON.stringify({ type: 'AUTH', token: authToken }));
    });
  };

  ws.onmessage = (event) => {
    const message = JSON.parse(event.data);
    handleServerPush(message);
  };

  ws.onclose = () => {
    // Reconnect with exponential backoff
    setTimeout(connectWebSocket, 5000);
  };

  ws.onerror = (error) => {
    console.error('WebSocket error:', error);
    ws?.close();
  };
}

async function handleServerPush(message: { type: string; data: any }) {
  switch (message.type) {
    case 'DATA_UPDATE':
      // Store locally for offline access
      await chrome.storage.local.set({ latestData: message.data });
      // Notify open UI pages
      chrome.runtime.sendMessage({ type: 'DATA_UPDATED', data: message.data });
      break;

    case 'NOTIFICATION':
      chrome.notifications.create({
        type: 'basic',
        iconUrl: 'icons/icon128.png',
        title: message.data.title,
        message: message.data.body,
      });
      break;

    case 'BADGE_UPDATE':
      chrome.action.setBadgeText({ text: message.data.count.toString() });
      chrome.action.setBadgeBackgroundColor({ color: '#0041D9' });
      break;
  }
}

// Start connection when extension loads
connectWebSocket();

// Reconnect when service worker wakes up
chrome.runtime.onStartup.addListener(connectWebSocket);
chrome.runtime.onInstalled.addListener(connectWebSocket);
```

**Service Worker Limitation:** WebSocket connections close when the service worker terminates (~30s idle). Use `chrome.alarms` to periodically wake the worker and reconnect:

```typescript
// Keep-alive strategy
chrome.alarms.create('ws-keepalive', { periodInMinutes: 0.5 }); // every 30 seconds

chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === 'ws-keepalive') {
    if (!ws || ws.readyState !== WebSocket.OPEN) {
      connectWebSocket();
    }
  }
});
```

### Server-Sent Events (SSE) from Extension Page

SSE is simpler than WebSocket for one-way server-to-client data. Best used from popup/side panel pages (not service workers, which terminate):

```typescript
// popup/App.tsx or sidepanel/App.tsx
import { useEffect, useState } from 'react';

function useLiveUpdates(endpoint: string) {
  const [data, setData] = useState<any>(null);
  const [connected, setConnected] = useState(false);

  useEffect(() => {
    const eventSource = new EventSource(endpoint);

    eventSource.onopen = () => setConnected(true);

    eventSource.addEventListener('update', (event) => {
      const parsed = JSON.parse(event.data);
      setData(parsed);
      // Also persist to storage for offline access
      chrome.storage.local.set({ cachedData: parsed });
    });

    eventSource.addEventListener('notification', (event) => {
      const { title, body } = JSON.parse(event.data);
      chrome.runtime.sendMessage({
        type: 'SHOW_NOTIFICATION',
        title,
        body,
      });
    });

    eventSource.onerror = () => {
      setConnected(false);
      // EventSource auto-reconnects
    };

    return () => eventSource.close();
  }, [endpoint]);

  return { data, connected };
}

function Dashboard() {
  const { data, connected } = useLiveUpdates(
    'https://your-api.example.com/events?stream=extension'
  );

  return (
    <Flex direction="column" gap="300">
      <Tag size="sm" tone={connected ? 'green' : 'neutral'}>
        {connected ? 'Live' : 'Reconnecting...'}
      </Tag>
      {data && <DataDisplay data={data} />}
    </Flex>
  );
}
```

---

## 4. Polling with Cached Fallback

Periodically fetch data from a server using `chrome.alarms` in the service worker. Simpler than WebSocket, works reliably with service worker lifecycle.

```typescript
// service-worker.ts
const POLL_INTERVAL_MINUTES = 5;

chrome.alarms.create('data-poll', { periodInMinutes: POLL_INTERVAL_MINUTES });

chrome.alarms.onAlarm.addListener(async (alarm) => {
  if (alarm.name === 'data-poll') {
    await fetchAndCacheData();
  }
});

async function fetchAndCacheData() {
  try {
    const { authToken } = await chrome.storage.local.get('authToken');
    if (!authToken) return;

    const response = await fetch('https://your-api.example.com/extension/data', {
      headers: { Authorization: `Bearer ${authToken}` },
    });

    if (!response.ok) throw new Error(`HTTP ${response.status}`);

    const data = await response.json();

    // Store with timestamp for cache validation
    await chrome.storage.local.set({
      cachedData: data,
      lastFetchedAt: Date.now(),
    });

    // Update badge if needed
    if (data.unreadCount > 0) {
      chrome.action.setBadgeText({ text: data.unreadCount.toString() });
    }

    // Notify open UI pages
    chrome.runtime.sendMessage({ type: 'DATA_REFRESHED', data }).catch(() => {
      // No listeners — popup/sidepanel not open, which is fine
    });
  } catch (error) {
    console.error('Poll failed, using cached data:', error);
  }
}

// Also fetch on install and startup
chrome.runtime.onInstalled.addListener(fetchAndCacheData);
chrome.runtime.onStartup.addListener(fetchAndCacheData);
```

```typescript
// popup/App.tsx — use cached data with manual refresh
function usePolledData() {
  const [data, setData] = useState<any>(null);
  const [lastUpdated, setLastUpdated] = useState<number | null>(null);

  const loadCached = async () => {
    const { cachedData, lastFetchedAt } = await chrome.storage.local.get([
      'cachedData',
      'lastFetchedAt',
    ]);
    if (cachedData) {
      setData(cachedData);
      setLastUpdated(lastFetchedAt);
    }
  };

  useEffect(() => {
    loadCached();
    // Listen for background updates
    const listener = (message: any) => {
      if (message.type === 'DATA_REFRESHED') {
        setData(message.data);
        setLastUpdated(Date.now());
      }
    };
    chrome.runtime.onMessage.addListener(listener);
    return () => chrome.runtime.onMessage.removeListener(listener);
  }, []);

  const refresh = async () => {
    chrome.runtime.sendMessage({ type: 'FORCE_REFRESH' });
  };

  return { data, lastUpdated, refresh };
}
```

---

## 5. Remote Configuration & Feature Flags

Fetch configuration from a server to control extension behavior without republishing.

```typescript
// service-worker.ts
interface RemoteConfig {
  featureFlags: Record<string, boolean>;
  uiConfig: {
    theme: 'light' | 'dark';
    maxResults: number;
    enableBetaFeatures: boolean;
  };
  version: string;
}

const CONFIG_CHECK_INTERVAL_MINUTES = 60;

chrome.alarms.create('config-check', {
  periodInMinutes: CONFIG_CHECK_INTERVAL_MINUTES,
});

chrome.alarms.onAlarm.addListener(async (alarm) => {
  if (alarm.name === 'config-check') {
    await fetchRemoteConfig();
  }
});

async function fetchRemoteConfig() {
  try {
    const response = await fetch(
      'https://your-api.example.com/extension/config',
      {
        headers: {
          'X-Extension-Version': chrome.runtime.getManifest().version,
        },
      }
    );

    if (!response.ok) return;

    const config: RemoteConfig = await response.json();

    // Compare with cached config
    const { remoteConfig: cached } = await chrome.storage.local.get('remoteConfig');
    const configChanged = JSON.stringify(cached) !== JSON.stringify(config);

    await chrome.storage.local.set({ remoteConfig: config });

    if (configChanged) {
      // Notify UI pages of config change
      chrome.runtime.sendMessage({ type: 'CONFIG_UPDATED', config });
    }
  } catch (error) {
    console.error('Config fetch failed, using cached:', error);
  }
}

// Typed config access
async function getConfig(): Promise<RemoteConfig> {
  const { remoteConfig } = await chrome.storage.local.get('remoteConfig');
  return remoteConfig ?? {
    featureFlags: {},
    uiConfig: { theme: 'light', maxResults: 10, enableBetaFeatures: false },
    version: '1.0.0',
  };
}

async function isFeatureEnabled(flag: string): Promise<boolean> {
  const config = await getConfig();
  return config.featureFlags[flag] ?? false;
}
```

```typescript
// popup/App.tsx — consume remote config
function App() {
  const [config, setConfig] = useState<RemoteConfig | null>(null);

  useEffect(() => {
    chrome.storage.local.get('remoteConfig', ({ remoteConfig }) => {
      setConfig(remoteConfig);
    });

    const listener = (message: any) => {
      if (message.type === 'CONFIG_UPDATED') {
        setConfig(message.config);
      }
    };
    chrome.runtime.onMessage.addListener(listener);
    return () => chrome.runtime.onMessage.removeListener(listener);
  }, []);

  if (!config) return <Text>Loading...</Text>;

  return (
    <Flex direction="column" gap="300">
      {config.featureFlags.showNewDashboard && <NewDashboard />}
      {config.uiConfig.enableBetaFeatures && <BetaFeatures />}
    </Flex>
  );
}
```

---

## 6. Hybrid Pattern: Local Shell + Remote Content

The recommended production pattern combines local UI (for Chrome API access, offline resilience, and fast load) with remote data and optional remote content blocks:

```typescript
// popup/App.tsx
function HybridApp() {
  const { data, connected, refresh } = useLiveUpdates();
  const config = useRemoteConfig();

  return (
    <Flex direction="column" gap="300" css={{ p: '400', width: '380px' }}>
      {/* Local header — always renders, uses Constellation */}
      <Flex justify="space-between" align="center">
        <Text textStyle="body-lg-bold">My Extension</Text>
        <Tag size="sm" tone={connected ? 'green' : 'neutral'}>
          {connected ? 'Live' : 'Offline'}
        </Tag>
      </Flex>

      <Divider />

      {/* Data-driven content — auto-updates from server */}
      {data ? (
        <DataView data={data} config={config} />
      ) : (
        <Flex direction="column" align="center" gap="300" css={{ py: '600' }}>
          <Text textStyle="body" css={{ color: 'text.subtle' }}>
            Loading latest data...
          </Text>
        </Flex>
      )}

      {/* Optional: embed remote content for specific sections */}
      {config?.featureFlags.showRemoteWidget && (
        <iframe
          src="https://your-app.example.com/widget"
          sandbox="allow-scripts"
          style={{ width: '100%', height: '200px', border: 'none', borderRadius: '12px' }}
        />
      )}

      {/* Local footer — Chrome API actions */}
      <Divider />
      <Flex gap="200">
        <Button tone="brand" emphasis="filled" size="md" onClick={refresh}>
          Refresh
        </Button>
        <Button tone="neutral" emphasis="outlined" size="md"
          onClick={() => chrome.tabs.create({ url: 'https://your-app.example.com' })}>
          Open full app
        </Button>
      </Flex>
    </Flex>
  );
}
```

---

## Decision Guide

| Question | If Yes → | If No → |
|----------|----------|---------|
| Does the UI need Chrome APIs (tabs, storage, etc.)? | Local UI + data push (patterns 3-5) | Remote URL side panel (pattern 1) |
| Must the UI work offline? | Local UI + cached data (patterns 4-5) | Remote URL or iframe (patterns 1-2) |
| Do you need real-time updates (<1s latency)? | WebSocket or SSE (pattern 3) | Polling (pattern 4) |
| Do you want to update UI without republishing? | Remote URL, iframe, or remote config (patterns 1, 2, 5) | Standard local build |
| Is the extension a companion to a web app? | Side panel with remote URL (pattern 1) | Local UI (patterns 3-6) |

---

## Manifest Requirements for Remote Patterns

```json
{
  "permissions": [
    "storage",
    "alarms",
    "notifications"
  ],
  "host_permissions": [
    "https://your-api.example.com/*"
  ],
  "externally_connectable": {
    "matches": ["https://your-app.example.com/*"]
  },
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'; frame-src https://your-app.example.com;"
  }
}
```

| Field | Purpose |
|-------|---------|
| `host_permissions` | Required for `fetch()` to your API from service worker or extension pages |
| `externally_connectable` | Required for remote pages to send messages TO the extension via `chrome.runtime.sendMessage()` |
| `frame-src` in CSP | Required to embed remote URLs in `<iframe>` on extension pages |

---

## Security Considerations

1. **Always validate `sender.origin`** in `onMessageExternal` — never trust messages from unknown origins
2. **Use `sandbox` attribute** on iframes embedding remote content — restrict capabilities to minimum needed
3. **Authenticate server connections** — pass tokens via WebSocket/fetch headers, not URL parameters
4. **Cache sensitive data in `chrome.storage.session`** (cleared on browser restart) rather than `chrome.storage.local`
5. **Rate-limit reconnection attempts** — use exponential backoff for WebSocket/SSE reconnects
6. **Pin your API domain** in `host_permissions` — avoid wildcards like `https://*/*`
7. **Handle server downtime gracefully** — always fall back to cached data with a "last updated" indicator
