# Chrome APIs Reference

Complete reference for the most commonly used Chrome Extension APIs in Manifest V3.

---

## chrome.storage

Persistent key-value storage that persists across service worker restarts.

### Storage Areas

| Area | Limit | Sync | Notes |
|------|-------|------|-------|
| `chrome.storage.local` | 5MB (10MB with `unlimitedStorage`) | No | Local to device |
| `chrome.storage.sync` | 100KB total, 8KB per item | Yes | Syncs across Chrome browsers with same Google account |
| `chrome.storage.session` | 10MB | No | Clears on browser close; not accessible to content scripts by default |

### Permission

```json
{ "permissions": ["storage"] }
```

### Core Operations

```typescript
// SET — single or multiple values
await chrome.storage.local.set({ key: 'value' });
await chrome.storage.local.set({ name: 'David', count: 42, settings: { theme: 'dark' } });

// GET — with optional defaults
const { name } = await chrome.storage.local.get(['name']);
const result = await chrome.storage.local.get({ theme: 'light', count: 0 }); // defaults
const everything = await chrome.storage.local.get(null); // all data

// REMOVE
await chrome.storage.local.remove('name');
await chrome.storage.local.remove(['name', 'count']);

// CLEAR ALL
await chrome.storage.local.clear();
```

### Listen for Changes

```typescript
chrome.storage.onChanged.addListener((changes, areaName) => {
  for (const [key, { oldValue, newValue }] of Object.entries(changes)) {
    console.log(`${areaName}.${key}: ${oldValue} → ${newValue}`);
  }
});
```

### Session Storage Access from Content Scripts

```typescript
// In service worker — grant content script access
chrome.storage.session.setAccessLevel({
  accessLevel: 'TRUSTED_AND_UNTRUSTED_CONTEXTS'
});
```

### Typed Storage Helper

```typescript
interface StorageSchema {
  settings: { enabled: boolean; theme: 'light' | 'dark' };
  favorites: string[];
  lastSync: number;
}

async function getStorage<K extends keyof StorageSchema>(
  key: K
): Promise<StorageSchema[K] | undefined> {
  const result = await chrome.storage.local.get(key);
  return result[key];
}

async function setStorage<K extends keyof StorageSchema>(
  key: K,
  value: StorageSchema[K]
): Promise<void> {
  await chrome.storage.local.set({ [key]: value });
}
```

---

## chrome.tabs

Query, create, update, and manage browser tabs.

### Permission

```json
{ "permissions": ["tabs"] }
```

The `tabs` permission is only needed for `url`, `title`, and `favIconUrl` properties. Most other tab operations work without it.

### Query Tabs

```typescript
// Active tab in current window
const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

// All tabs in current window
const tabs = await chrome.tabs.query({ currentWindow: true });

// Tabs matching URL pattern
const zillowTabs = await chrome.tabs.query({ url: '*://*.zillow.com/*' });

// All tabs
const allTabs = await chrome.tabs.query({});

// Pinned tabs
const pinned = await chrome.tabs.query({ pinned: true });
```

### Create, Update, Remove

```typescript
// Create new tab
const tab = await chrome.tabs.create({ url: 'https://zillow.com', active: true });

// Create in background
await chrome.tabs.create({ url: 'https://example.com', active: false });

// Update tab URL
await chrome.tabs.update(tabId, { url: 'https://zillow.com/homes' });

// Activate tab
await chrome.tabs.update(tabId, { active: true });

// Close tab(s)
await chrome.tabs.remove(tabId);
await chrome.tabs.remove([tabId1, tabId2]);
```

### Tab Events

```typescript
chrome.tabs.onCreated.addListener((tab) => { /* new tab */ });

chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === 'complete') {
    // Page fully loaded
  }
  if (changeInfo.url) {
    // URL changed (SPA navigation, etc.)
  }
});

chrome.tabs.onActivated.addListener((activeInfo) => {
  // User switched to tab activeInfo.tabId
});

chrome.tabs.onRemoved.addListener((tabId, removeInfo) => {
  // Tab closed
});
```

### Send Message to Tab

```typescript
const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
if (tab?.id) {
  const response = await chrome.tabs.sendMessage(tab.id, {
    type: 'GET_PAGE_DATA',
  });
}
```

---

## chrome.scripting

Dynamically inject JavaScript and CSS into web pages.

### Permission

```json
{
  "permissions": ["scripting"],
  "host_permissions": ["https://*.example.com/*"]
}
```

### Execute JavaScript

```typescript
// Inject function
await chrome.scripting.executeScript({
  target: { tabId: tab.id },
  func: () => {
    document.body.style.backgroundColor = 'yellow';
    return document.title;
  },
});

// Inject function with arguments
await chrome.scripting.executeScript({
  target: { tabId: tab.id },
  func: (color, text) => {
    document.body.style.backgroundColor = color;
    return text;
  },
  args: ['blue', 'hello'],
});

// Inject file
await chrome.scripting.executeScript({
  target: { tabId: tab.id },
  files: ['src/content/injected.js'],
});

// Inject in all frames
await chrome.scripting.executeScript({
  target: { tabId: tab.id, allFrames: true },
  func: () => console.log(window.location.href),
});

// Inject in specific world
await chrome.scripting.executeScript({
  target: { tabId: tab.id },
  func: () => window.myAppState, // access page variables
  world: 'MAIN', // MAIN or ISOLATED
});
```

### Insert / Remove CSS

```typescript
// Inject CSS string
await chrome.scripting.insertCSS({
  target: { tabId: tab.id },
  css: 'body { font-family: Inter, sans-serif !important; }',
});

// Inject CSS file
await chrome.scripting.insertCSS({
  target: { tabId: tab.id },
  files: ['styles/override.css'],
});

// Remove injected CSS
await chrome.scripting.removeCSS({
  target: { tabId: tab.id },
  css: 'body { font-family: Inter, sans-serif !important; }',
});
```

### Dynamic Content Script Registration

```typescript
await chrome.scripting.registerContentScripts([{
  id: 'zillow-enhancer',
  matches: ['https://*.zillow.com/*'],
  js: ['content/enhancer.js'],
  css: ['content/styles.css'],
  runAt: 'document_idle',
}]);

// Check registered scripts
const scripts = await chrome.scripting.getRegisteredContentScripts();

// Update
await chrome.scripting.updateContentScripts([{
  id: 'zillow-enhancer',
  js: ['content/enhancer-v2.js'],
}]);

// Remove
await chrome.scripting.unregisterContentScripts({ ids: ['zillow-enhancer'] });
```

---

## chrome.action

Control the extension's toolbar icon, badge, popup, and enabled state.

### No Permission Required

The `action` key in manifest.json is sufficient.

### Badge

```typescript
// Set badge text (max ~4 characters)
await chrome.action.setBadgeText({ text: '5' });
await chrome.action.setBadgeText({ text: 'NEW' });
await chrome.action.setBadgeText({ text: '' }); // clear

// Set badge color
await chrome.action.setBadgeBackgroundColor({ color: '#FF0000' });
await chrome.action.setBadgeBackgroundColor({ color: [0, 128, 255, 255] });

// Tab-specific badge
await chrome.action.setBadgeText({ text: '3', tabId: 123 });

// Get current badge
const text = await chrome.action.getBadgeText({});
```

### Icon

```typescript
// Change icon
await chrome.action.setIcon({
  path: { 16: 'icons/active16.png', 32: 'icons/active32.png' },
});

// Tab-specific icon
await chrome.action.setIcon({
  path: 'icons/special.png',
  tabId: 123,
});
```

### Tooltip

```typescript
await chrome.action.setTitle({ title: 'Extension active — 5 items found' });
const title = await chrome.action.getTitle({});
```

### Popup

```typescript
// Set popup
await chrome.action.setPopup({ popup: 'popup/index.html' });

// Remove popup (enables onClicked event)
await chrome.action.setPopup({ popup: '' });

// Get popup
const popup = await chrome.action.getPopup({});
```

### Enable / Disable

```typescript
await chrome.action.disable(tabId);  // Grays out icon for specific tab
await chrome.action.enable(tabId);
await chrome.action.disable();       // Disable globally
```

### Click Handler

```typescript
// Only fires when NO popup is set
chrome.action.onClicked.addListener(async (tab) => {
  // Toggle functionality
  const { enabled = false } = await chrome.storage.local.get('enabled');
  await chrome.storage.local.set({ enabled: !enabled });
  await chrome.action.setBadgeText({ text: !enabled ? 'ON' : '' });
});
```

---

## chrome.contextMenus

Add items to Chrome's right-click context menu.

### Permission

```json
{ "permissions": ["contextMenus"] }
```

### Create Menu Items

```typescript
// Create on install (service worker)
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: 'search-zillow',
    title: 'Search Zillow for "%s"',
    contexts: ['selection'],
  });

  chrome.contextMenus.create({
    id: 'save-image',
    title: 'Save to collection',
    contexts: ['image'],
  });

  // Nested menus
  chrome.contextMenus.create({
    id: 'tools',
    title: 'Extension Tools',
    contexts: ['page'],
  });
  chrome.contextMenus.create({
    id: 'tool-analyze',
    title: 'Analyze page',
    parentId: 'tools',
    contexts: ['page'],
  });
  chrome.contextMenus.create({
    id: 'tool-export',
    title: 'Export data',
    parentId: 'tools',
    contexts: ['page'],
  });
});
```

### Context Types

| Context | Trigger |
|---------|---------|
| `selection` | Text selected on page |
| `link` | Right-click on a link |
| `image` | Right-click on an image |
| `page` | Anywhere on page background |
| `action` | Extension toolbar icon |
| `all` | All contexts |
| `video` | Right-click on a video |
| `audio` | Right-click on audio |
| `frame` | Right-click in an iframe |
| `editable` | Right-click in editable area |

### Handle Clicks

```typescript
chrome.contextMenus.onClicked.addListener((info, tab) => {
  switch (info.menuItemId) {
    case 'search-zillow': {
      const query = encodeURIComponent(info.selectionText || '');
      chrome.tabs.create({ url: `https://www.zillow.com/homes/${query}` });
      break;
    }
    case 'save-image': {
      chrome.runtime.sendMessage({ type: 'SAVE_IMAGE', url: info.srcUrl });
      break;
    }
  }
});
```

### URL Filtering

```typescript
chrome.contextMenus.create({
  id: 'zillow-only',
  title: 'Zillow-specific action',
  contexts: ['page'],
  documentUrlPatterns: ['*://*.zillow.com/*'],
});
```

---

## chrome.alarms

Schedule code to run at specific times or intervals. Persists across service worker restarts and browser sleep.

### Permission

```json
{ "permissions": ["alarms"] }
```

### Create Alarms

```typescript
// One-time alarm (1 minute delay)
await chrome.alarms.create('one-time', { delayInMinutes: 1 });

// Repeating alarm
await chrome.alarms.create('periodic-sync', {
  delayInMinutes: 1,          // First fire after 1 minute
  periodInMinutes: 30,        // Then every 30 minutes
});

// Alarm at specific time
await chrome.alarms.create('scheduled', {
  when: Date.now() + 60_000,  // 1 minute from now (ms)
});
```

### Limits
- Minimum interval: **30 seconds** (production), no limit when unpacked (development)
- Maximum active alarms: **500** (Chrome 117+)

### Listen for Alarms

```typescript
chrome.alarms.onAlarm.addListener((alarm) => {
  switch (alarm.name) {
    case 'periodic-sync':
      syncData();
      break;
    case 'daily-check':
      checkForUpdates();
      break;
  }
});
```

### Manage Alarms

```typescript
// Get specific alarm
const alarm = await chrome.alarms.get('periodic-sync');

// Get all alarms
const allAlarms = await chrome.alarms.getAll();

// Clear specific alarm
await chrome.alarms.clear('periodic-sync');

// Clear all alarms
await chrome.alarms.clearAll();
```

### Re-create on Startup

```typescript
chrome.runtime.onStartup.addListener(async () => {
  const existing = await chrome.alarms.get('periodic-sync');
  if (!existing) {
    await chrome.alarms.create('periodic-sync', { periodInMinutes: 30 });
  }
});
```

---

## chrome.notifications

Display system notifications to the user.

### Permission

```json
{ "permissions": ["notifications"] }
```

### Notification Types

```typescript
// Basic notification
chrome.notifications.create('notif-1', {
  type: 'basic',
  iconUrl: 'icons/icon128.png',
  title: 'Property Alert',
  message: 'New listing matches your saved search!',
  priority: 2,
});

// Image notification
chrome.notifications.create('notif-2', {
  type: 'image',
  iconUrl: 'icons/icon128.png',
  title: 'Featured Property',
  message: '123 Main St — $425,000',
  imageUrl: 'images/featured-property.png',
});

// List notification
chrome.notifications.create('notif-3', {
  type: 'list',
  iconUrl: 'icons/icon128.png',
  title: 'Price Drops',
  message: '3 properties reduced',
  items: [
    { title: '123 Main St', message: '$450K → $425K' },
    { title: '456 Oak Ave', message: '$350K → $340K' },
    { title: '789 Elm Blvd', message: '$500K → $475K' },
  ],
});

// Progress notification
chrome.notifications.create('notif-4', {
  type: 'progress',
  iconUrl: 'icons/icon128.png',
  title: 'Syncing data',
  message: 'Updating saved searches...',
  progress: 50,
});
```

### Buttons

```typescript
chrome.notifications.create('action-notif', {
  type: 'basic',
  iconUrl: 'icons/icon128.png',
  title: 'New listing nearby',
  message: '3 bed, 2 bath — $350,000',
  buttons: [
    { title: 'View listing' },
    { title: 'Dismiss' },
  ],
});

chrome.notifications.onButtonClicked.addListener((notifId, buttonIndex) => {
  if (notifId === 'action-notif') {
    if (buttonIndex === 0) {
      chrome.tabs.create({ url: 'https://zillow.com/listing/123' });
    }
    chrome.notifications.clear(notifId);
  }
});
```

### Events

```typescript
chrome.notifications.onClicked.addListener((notifId) => {
  chrome.tabs.create({ url: 'https://zillow.com/notifications' });
  chrome.notifications.clear(notifId);
});

chrome.notifications.onClosed.addListener((notifId, byUser) => {
  console.log(`Notification ${notifId} closed ${byUser ? 'by user' : 'programmatically'}`);
});
```

### Update and Clear

```typescript
chrome.notifications.update('notif-4', { progress: 75, message: '75% complete...' });
chrome.notifications.clear('notif-4');
```

---

## chrome.runtime

Core API for extension lifecycle, messaging, metadata, and error handling.

### Installation and Updates

```typescript
chrome.runtime.onInstalled.addListener((details) => {
  if (details.reason === 'install') {
    // First install — setup defaults, show onboarding
    chrome.storage.local.set({ version: chrome.runtime.getManifest().version });
  } else if (details.reason === 'update') {
    const prev = details.previousVersion;
    const curr = chrome.runtime.getManifest().version;
    console.log(`Updated: ${prev} → ${curr}`);
  }
});

chrome.runtime.onStartup.addListener(() => {
  // Browser started, extension already installed
});
```

### Extension Metadata

```typescript
const id = chrome.runtime.id;                        // Extension ID
const manifest = chrome.runtime.getManifest();       // Full manifest object
const url = chrome.runtime.getURL('popup/index.html'); // chrome-extension://ID/popup/index.html
```

### Open Extension Pages

```typescript
chrome.runtime.openOptionsPage();
chrome.tabs.create({ url: chrome.runtime.getURL('onboarding/index.html') });
```

### Error Handling

```typescript
// Check for errors after Chrome API calls (callback pattern)
chrome.tabs.create({ url: 'chrome://invalid' }, () => {
  if (chrome.runtime.lastError) {
    console.error('Failed:', chrome.runtime.lastError.message);
  }
});
```

---

## chrome.identity

OAuth2 authentication for accessing Google APIs or custom OAuth providers.

### Permission

```json
{ "permissions": ["identity"] }
```

### Google OAuth

```typescript
// Get OAuth token
chrome.identity.getAuthToken({ interactive: true }, (token) => {
  if (chrome.runtime.lastError) {
    console.error(chrome.runtime.lastError.message);
    return;
  }
  // Use token to call Google APIs
  fetch('https://www.googleapis.com/oauth2/v1/userinfo', {
    headers: { Authorization: `Bearer ${token}` },
  })
    .then(r => r.json())
    .then(user => console.log('User:', user));
});

// Remove cached token (force re-auth)
chrome.identity.removeCachedAuthToken({ token }, () => {
  // Token removed
});
```

### Custom OAuth (Non-Google)

```typescript
const redirectUrl = chrome.identity.getRedirectURL();
// Returns: https://<extension-id>.chromiumapp.org/

const authUrl = new URL('https://auth.example.com/authorize');
authUrl.searchParams.set('client_id', CLIENT_ID);
authUrl.searchParams.set('redirect_uri', redirectUrl);
authUrl.searchParams.set('response_type', 'token');
authUrl.searchParams.set('scope', 'read write');

chrome.identity.launchWebAuthFlow(
  { url: authUrl.toString(), interactive: true },
  (responseUrl) => {
    if (chrome.runtime.lastError || !responseUrl) return;
    const url = new URL(responseUrl);
    const token = url.hash.split('access_token=')[1]?.split('&')[0];
    chrome.storage.local.set({ authToken: token });
  }
);
```

---

## chrome.offscreen

Create offscreen documents for DOM operations in MV3 (since service workers lack DOM access).

### Permission

```json
{ "permissions": ["offscreen"] }
```

### Use Cases
- DOM parsing (`DOMParser`)
- Audio playback
- Canvas operations
- Clipboard access
- WebRTC

```typescript
// Create offscreen document
await chrome.offscreen.createDocument({
  url: chrome.runtime.getURL('offscreen/index.html'),
  reasons: ['DOM_PARSER'],
  justification: 'Parse HTML content for data extraction',
});

// Send data to offscreen document for processing
const result = await chrome.runtime.sendMessage({
  type: 'PARSE_HTML',
  html: '<div class="price">$425,000</div>',
});

// Close when done
await chrome.offscreen.closeDocument();
```

---

## API Quick Reference

| API | Permission | Key Methods |
|-----|-----------|-------------|
| `chrome.storage` | `storage` | `set()`, `get()`, `remove()`, `onChanged` |
| `chrome.tabs` | `tabs` (for url/title) | `query()`, `create()`, `update()`, `remove()`, `sendMessage()` |
| `chrome.scripting` | `scripting` + host | `executeScript()`, `insertCSS()`, `registerContentScripts()` |
| `chrome.action` | (none) | `setBadgeText()`, `setIcon()`, `setPopup()`, `enable()`/`disable()` |
| `chrome.contextMenus` | `contextMenus` | `create()`, `update()`, `remove()`, `onClicked` |
| `chrome.alarms` | `alarms` | `create()`, `get()`, `clear()`, `onAlarm` |
| `chrome.notifications` | `notifications` | `create()`, `update()`, `clear()`, `onClicked`, `onButtonClicked` |
| `chrome.runtime` | (none) | `sendMessage()`, `onInstalled`, `getManifest()`, `getURL()` |
| `chrome.identity` | `identity` | `getAuthToken()`, `launchWebAuthFlow()` |
| `chrome.sidePanel` | `sidePanel` | `open()`, `setOptions()`, `setPanelBehavior()` |
| `chrome.offscreen` | `offscreen` | `createDocument()`, `closeDocument()` |
