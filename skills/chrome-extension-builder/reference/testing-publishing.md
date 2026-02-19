# Testing & Publishing

## Unit Testing

### Framework Setup

```bash
npm install -D vitest @testing-library/react @testing-library/jest-dom jsdom
```

### vitest.config.ts

```typescript
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./test/setup.ts'],
    include: ['src/**/*.test.{ts,tsx}'],
  },
});
```

### Chrome API Mocks

```typescript
// test/setup.ts
import '@testing-library/jest-dom';

// Mock Chrome APIs
const chromeMock = {
  runtime: {
    id: 'test-extension-id',
    sendMessage: vi.fn(),
    onMessage: {
      addListener: vi.fn(),
      removeListener: vi.fn(),
    },
    getURL: vi.fn((path: string) => `chrome-extension://test-id/${path}`),
    getManifest: vi.fn(() => ({ version: '1.0.0', name: 'Test Extension' })),
    openOptionsPage: vi.fn(),
    onInstalled: { addListener: vi.fn() },
    onStartup: { addListener: vi.fn() },
    lastError: null,
  },
  storage: {
    local: {
      get: vi.fn().mockResolvedValue({}),
      set: vi.fn().mockResolvedValue(undefined),
      remove: vi.fn().mockResolvedValue(undefined),
      clear: vi.fn().mockResolvedValue(undefined),
    },
    sync: {
      get: vi.fn().mockResolvedValue({}),
      set: vi.fn().mockResolvedValue(undefined),
    },
    onChanged: {
      addListener: vi.fn(),
      removeListener: vi.fn(),
    },
  },
  tabs: {
    query: vi.fn().mockResolvedValue([]),
    create: vi.fn().mockResolvedValue({ id: 1 }),
    update: vi.fn().mockResolvedValue({}),
    remove: vi.fn().mockResolvedValue(undefined),
    sendMessage: vi.fn(),
    onUpdated: { addListener: vi.fn() },
    onActivated: { addListener: vi.fn() },
    onRemoved: { addListener: vi.fn() },
  },
  action: {
    setBadgeText: vi.fn(),
    setBadgeBackgroundColor: vi.fn(),
    setIcon: vi.fn(),
    setTitle: vi.fn(),
    setPopup: vi.fn(),
    onClicked: { addListener: vi.fn() },
  },
  contextMenus: {
    create: vi.fn(),
    update: vi.fn(),
    remove: vi.fn(),
    removeAll: vi.fn(),
    onClicked: { addListener: vi.fn() },
  },
  alarms: {
    create: vi.fn(),
    get: vi.fn().mockResolvedValue(null),
    getAll: vi.fn().mockResolvedValue([]),
    clear: vi.fn(),
    clearAll: vi.fn(),
    onAlarm: { addListener: vi.fn() },
  },
  notifications: {
    create: vi.fn(),
    update: vi.fn(),
    clear: vi.fn(),
    onClicked: { addListener: vi.fn() },
    onButtonClicked: { addListener: vi.fn() },
    onClosed: { addListener: vi.fn() },
  },
  scripting: {
    executeScript: vi.fn(),
    insertCSS: vi.fn(),
    removeCSS: vi.fn(),
    registerContentScripts: vi.fn(),
    unregisterContentScripts: vi.fn(),
  },
  sidePanel: {
    open: vi.fn(),
    setOptions: vi.fn(),
    setPanelBehavior: vi.fn(),
  },
  identity: {
    getAuthToken: vi.fn(),
    removeCachedAuthToken: vi.fn(),
    launchWebAuthFlow: vi.fn(),
    getRedirectURL: vi.fn(() => 'https://test-id.chromiumapp.org/'),
  },
};

Object.defineProperty(global, 'chrome', {
  value: chromeMock,
  writable: true,
});
```

### Writing Unit Tests

```typescript
// src/utils/storage.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { getSettings, saveSettings } from './storage';

describe('storage utilities', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('returns default settings when storage is empty', async () => {
    vi.mocked(chrome.storage.local.get).mockResolvedValue({});

    const settings = await getSettings();

    expect(settings).toEqual({ enabled: true, theme: 'light' });
    expect(chrome.storage.local.get).toHaveBeenCalledWith('settings');
  });

  it('saves settings to chrome.storage', async () => {
    const newSettings = { enabled: false, theme: 'dark' };

    await saveSettings(newSettings);

    expect(chrome.storage.local.set).toHaveBeenCalledWith({ settings: newSettings });
  });
});
```

```tsx
// src/popup/App.test.tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import App from './App';

describe('Popup App', () => {
  it('renders extension title', () => {
    render(<App />);
    expect(screen.getByText('Property Insights')).toBeInTheDocument();
  });

  it('opens options page on settings click', async () => {
    render(<App />);
    const settingsButton = screen.getByTitle('Settings');
    fireEvent.click(settingsButton);
    expect(chrome.runtime.openOptionsPage).toHaveBeenCalled();
  });

  it('opens Zillow when button is clicked', async () => {
    render(<App />);
    const button = screen.getByText('Open Zillow');
    fireEvent.click(button);
    expect(chrome.tabs.create).toHaveBeenCalledWith({ url: 'https://www.zillow.com' });
  });
});
```

### Testing Message Handlers

```typescript
// src/background/handlers.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { handleMessage } from './handlers';

describe('message handlers', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('handles GET_SETTINGS message', async () => {
    vi.mocked(chrome.storage.local.get).mockResolvedValue({
      settings: { enabled: true, theme: 'light' },
    });

    const sendResponse = vi.fn();
    const result = handleMessage(
      { type: 'GET_SETTINGS' },
      {} as chrome.runtime.MessageSender,
      sendResponse
    );

    expect(result).toBe(true); // async response

    await vi.waitFor(() => {
      expect(sendResponse).toHaveBeenCalledWith({
        success: true,
        data: { enabled: true, theme: 'light' },
      });
    });
  });
});
```

---

## End-to-End Testing

### Puppeteer Setup

```bash
npm install -D puppeteer
```

### E2E Test Configuration

```typescript
// test/e2e/extension.test.ts
import puppeteer, { Browser, Page } from 'puppeteer';
import { resolve } from 'path';

const EXTENSION_PATH = resolve(__dirname, '../../dist');

describe('Extension E2E', () => {
  let browser: Browser;

  beforeAll(async () => {
    browser = await puppeteer.launch({
      headless: 'new',
      args: [
        `--disable-extensions-except=${EXTENSION_PATH}`,
        `--load-extension=${EXTENSION_PATH}`,
        '--no-sandbox',
      ],
    });
  });

  afterAll(async () => {
    await browser.close();
  });

  it('loads the extension service worker', async () => {
    const workerTarget = await browser.waitForTarget(
      (target) => target.type() === 'service_worker'
    );
    expect(workerTarget).toBeDefined();
  });

  it('renders the popup', async () => {
    const targets = await browser.targets();
    const extensionTarget = targets.find(
      (target) => target.type() === 'service_worker'
    );
    const extensionId = extensionTarget?.url().split('/')[2];

    const page = await browser.newPage();
    await page.goto(`chrome-extension://${extensionId}/popup/index.html`);

    const title = await page.$eval('h2', (el) => el.textContent);
    expect(title).toBe('Property Insights');
  });

  it('saves settings via options page', async () => {
    const targets = await browser.targets();
    const extensionTarget = targets.find(
      (target) => target.type() === 'service_worker'
    );
    const extensionId = extensionTarget?.url().split('/')[2];

    const page = await browser.newPage();
    await page.goto(`chrome-extension://${extensionId}/options/index.html`);

    // Interact with options page
    await page.click('[data-testid="dark-mode-toggle"]');

    // Verify setting was saved
    const worker = await extensionTarget?.worker();
    const result = await worker?.evaluate(() =>
      chrome.storage.local.get('settings')
    );
    expect(result?.settings?.theme).toBe('dark');
  });
});
```

---

## Chrome Web Store Publishing

### Developer Account Setup

1. Go to [Chrome Web Store Developer Dashboard](https://chrome.google.com/webstore/devconsole/)
2. Pay **$5 one-time registration fee**
3. Enable **2-Step Verification** (mandatory)
4. Verify contact email
5. Set publisher name

### Required Assets

| Asset | Size | Format | Notes |
|-------|------|--------|-------|
| Extension icon | 128×128 px | PNG | Shown in store listing |
| Store screenshots | 1280×800 or 640×400 px | PNG/JPEG | 1-5 screenshots required |
| Small promo tile | 440×280 px | PNG/JPEG | Optional but recommended |
| Marquee promo tile | 1400×560 px | PNG/JPEG | Optional, for featured placement |

### Store Listing Metadata

| Field | Requirement |
|-------|-------------|
| **Name** | Clear, descriptive (max 75 chars) |
| **Description** | Specific functionality (max 16,000 chars, no keyword stuffing) |
| **Category** | Select most relevant category |
| **Language** | Primary language |
| **Privacy policy URL** | Required if collecting any user data |
| **Support URL** | Optional but recommended |

### Description Best Practices

```
✅ "Displays real-time property values and neighborhood data when browsing Zillow listings"
❌ "The best extension ever that makes browsing amazing and better"

✅ "Saves property listings for comparison. Tracks price changes. Shows market trends."
❌ "Extension for homes real estate property listings Zillow Trulia Redfin houses"
```

### Privacy Policy

**Required when your extension:**
- Accesses any user data (even error logs)
- Uses `tabs`, `history`, `bookmarks`, or similar permissions
- Stores any user-generated content
- Makes network requests with user data

**Must include:**
1. What data you collect (specific types)
2. How you use the data
3. Who you share data with
4. Data retention period
5. How users can access/delete their data
6. Security measures (HTTPS, encryption)

### Privacy Practices Tab

In the Developer Dashboard, certify your data collection:

- List all data types collected
- Explain how data is used
- Confirm compliance with Limited Use policy
- Indicate if data is sold/shared

### Submission

1. Build production extension: `npm run build`
2. Create ZIP: `cd dist && zip -r ../extension.zip .`
3. Upload ZIP in Developer Dashboard
4. Fill in all metadata and screenshots
5. Complete privacy practices certification
6. Submit for review

### Review Process

- **90%+ reviewed within 3 days**
- Simple extensions: often < 24 hours
- First-time submissions may take longer
- Sensitive permissions trigger closer review

### Common Rejection Reasons

| Reason | Prevention |
|--------|-----------|
| Excessive permissions | Request only what you need |
| Missing privacy policy | Always include if accessing any data |
| Misleading description | Be specific and accurate |
| Bugs or crashes | Test thoroughly before submission |
| Unclear purpose | State single, clear purpose |
| Remote code loading | Bundle all code with the extension |

### Updating an Extension

1. Increment `version` in manifest.json
2. Build and create new ZIP
3. Upload new ZIP in Developer Dashboard
4. Existing users auto-update within hours

---

## Pre-Publish Checklist

```
[ ] manifest.json is valid Manifest V3
[ ] All permissions are justified and minimal
[ ] No remote code execution
[ ] Extension tested on multiple sites
[ ] All Chrome APIs used correctly (async/await)
[ ] Service worker handles termination gracefully
[ ] Storage used instead of global variables
[ ] Content scripts don't leak styles
[ ] Icons in all required sizes (16, 48, 128)
[ ] Privacy policy written and hosted (if needed)
[ ] Store listing metadata complete
[ ] Screenshots captured (1280×800 or 640×400)
[ ] Production build minified
[ ] ZIP file under 10MB (target under 5MB)
[ ] Tested with fresh Chrome profile
[ ] No console.log statements in production
```
