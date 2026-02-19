# Constellation Design System Integration for Chrome Extensions

This guide covers how to use Zillow's Constellation design system (v10.13.0) inside Chrome extensions — including fonts, design tokens, PandaCSS styling, Shadow DOM isolation, and component usage.

---

## Integration Strategies by UI Surface

| UI Surface | Strategy | PandaCSS | Shadow DOM | Fonts |
|------------|----------|----------|------------|-------|
| **Popup** | Full Constellation + PandaCSS | Yes | Not needed | Extension-bundled |
| **Side Panel** | Full Constellation + PandaCSS | Yes | Not needed | Extension-bundled |
| **Options Page** | Full Constellation + PandaCSS | Yes | Not needed | Extension-bundled |
| **Content Script** | CSS tokens + Shadow DOM | Pre-built CSS only | Required | Extension-bundled, injected via `chrome.runtime.getURL()` |

Extension pages (popup, side panel, options) are fully controlled by you. Content scripts inject into host pages and need style isolation.

---

## 1. Bundling Fonts Locally

Chrome extension CSP blocks external font CDNs. You must bundle fonts with the extension.

### Step 1: Download Font Files

Download from Zillow's CDN (one-time) and place in your extension's `fonts/` directory:

```
fonts/
├── inter-variable.woff2       (from zillowstatic.com Inter variable font)
└── object-sans-heavy.woff2    (from zillowstatic.com Object Sans heavy)
```

Source URLs (download these files):
- `https://www.zillowstatic.com/s3/constellation-website/public/shared/fonts/inter/LATEST/inter-variable.woff2`
- `https://www.zillowstatic.com/s3/constellation-website/public/shared/fonts/object-sans/LATEST/object-sans-heavy.woff2`

### Step 2: Create Local Font CSS

```css
/* styles/fonts.css */
@font-face {
  font-family: "Inter";
  font-display: swap;
  font-stretch: 100%;
  font-weight: 400 800;
  src: url("chrome-extension://__MSG_@@extension_id__/fonts/inter-variable.woff2") format("woff2");
}

@font-face {
  font-family: "Inter Fallback";
  ascent-override: 90.44%;
  descent-override: 22.52%;
  line-gap-override: 0%;
  size-adjust: 107.12%;
  src: local("Arial");
}

@font-face {
  font-family: "Object Sans";
  font-display: swap;
  font-weight: 800;
  src: url("chrome-extension://__MSG_@@extension_id__/fonts/object-sans-heavy.woff2") format("woff2");
}

@font-face {
  font-family: "Object Sans Fallback";
  ascent-override: 104%;
  descent-override: 40%;
  line-gap-override: 0%;
  size-adjust: 91.5%;
  src: local("Arial Black");
}
```

### Step 3: Declare in Manifest

```json
{
  "web_accessible_resources": [{
    "resources": ["fonts/*", "styles/*"],
    "matches": ["<all_urls>"]
  }],
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'; font-src 'self';"
  }
}
```

### Step 4: Load in Extension Pages

For popup, side panel, and options pages, import the CSS directly:

```tsx
// popup/main.tsx
import '../styles/fonts.css';
import '@zillow/constellation-tokens/css/zillow';  // design tokens
import { injectTheme } from '../styled-system/themes';

injectTheme(document.documentElement);
```

### Step 5: Load in Content Scripts (Shadow DOM)

```typescript
// content/index.tsx
async function injectFonts(shadowRoot: ShadowRoot) {
  const fontCSS = await fetch(chrome.runtime.getURL('styles/fonts.css')).then(r => r.text());
  const style = document.createElement('style');
  style.textContent = fontCSS;
  shadowRoot.appendChild(style);
}
```

---

## 2. Design Tokens

Constellation tokens provide consistent colors, spacing, typography, and shadows as CSS custom properties.

### Token File

Copy `node_modules/@zillow/constellation-tokens/dist/css/zillow/constellation-tokens.css` into your extension's `styles/` directory.

This file contains 3,500+ CSS custom properties including:

#### Color Tokens

```css
/* Base colors */
--color-blue-600: hsl(222.03deg 100% 42.55%);   /* Primary action blue */
--color-gray-50: hsl(0deg 0% 96.86%);            /* Light background */
--color-gray-950: hsl(240deg 12.82% 7.65%);      /* Near-black text */
--color-white: hsl(0deg 0% 100%);

/* Semantic tokens */
--color-bg-screen-neutral: var(--color-white);    /* Page background */
--color-bg-screen-softest: var(--color-gray-50);  /* Section background */
--color-text-default: var(--color-gray-950);      /* Primary text */
--color-text-subtle: var(--color-gray-600);       /* Secondary text */
--color-text-action-hero-default: var(--color-blue-600); /* Link/action text */
--color-border-default: var(--color-gray-200);    /* Default borders */
--color-icon-default: var(--color-gray-950);      /* Icon color */
--color-icon-subtle: var(--color-gray-600);       /* Muted icon color */
```

#### Spacing Tokens

```css
--spacing-100: 0.25rem;    /* 4px  — tight */
--spacing-200: 0.5rem;     /* 8px  — compact */
--spacing-300: 0.75rem;    /* 12px — comfortable */
--spacing-400: 1rem;       /* 16px — standard padding */
--spacing-600: 1.5rem;     /* 24px — section padding */
--spacing-800: 2rem;       /* 32px — section gaps */
```

#### Typography Tokens

```css
--font-family-ui: "Inter", "Inter Fallback", sans-serif;
--font-family-brand: "Object Sans", "Object Sans Fallback", sans-serif;
--font-size-350: 0.875rem;   /* 14px — body small */
--font-size-400: 1rem;       /* 16px — body default */
--font-size-500: 1.25rem;    /* 20px — body large */
--font-size-600: 1.5rem;     /* 24px — heading small */
--font-size-800: 2rem;       /* 32px — heading large */
--font-weight-regular: 400;
--font-weight-bold: 700;
--font-weight-heavy: 900;    /* Object Sans headings */
```

#### Radius & Shadow Tokens

```css
--radius-200: 0.5rem;     /* 8px  — small elements */
--radius-300: 0.75rem;    /* 12px — cards, buttons (default) */
--radius-400: 1rem;       /* 16px — medium containers */
--radius-500: 1.25rem;    /* 20px — hero sections */
--radius-capsule: 62.4375rem; /* pill shapes */

--shadow-sm: /* small elevation */;
--shadow-md: /* medium elevation */;
--shadow-lg: /* large elevation (property cards) */;
```

### Using Tokens in CSS

```css
/* styles/content-app.css */
.ext-widget {
  font-family: var(--font-family-ui);
  color: var(--color-text-default);
  background: var(--color-bg-screen-neutral);
  padding: var(--spacing-400);
  border-radius: var(--radius-300);
  box-shadow: var(--shadow-md);
}

.ext-widget-title {
  font-family: var(--font-family-brand);
  font-size: var(--font-size-600);
  font-weight: var(--font-weight-heavy);
  color: var(--color-text-default);
  margin-bottom: var(--spacing-200);
}

.ext-widget-subtitle {
  font-size: var(--font-size-350);
  color: var(--color-text-subtle);
}

.ext-widget-button {
  background: var(--color-blue-600);
  color: var(--color-white);
  border: none;
  padding: var(--spacing-200) var(--spacing-400);
  border-radius: var(--radius-300);
  font-family: var(--font-family-ui);
  font-size: var(--font-size-400);
  font-weight: var(--font-weight-bold);
  cursor: pointer;
}

.ext-widget-button:hover {
  background: var(--color-blue-700);
}
```

---

## 3. PandaCSS Setup for Extension Pages

For popup, side panel, and options pages — use PandaCSS with the Constellation preset exactly as in a standard Zillow app.

### panda.config.ts

```typescript
import { defineConfig } from '@pandacss/dev';
import { constellationPandaPreset, constellationPandaPlugins } from '@zillow/constellation-config';

export default defineConfig({
  preflight: true,
  jsxFramework: 'react',
  include: ['./src/**/*.{ts,tsx}'],
  exclude: ['./src/content/**'],  // Exclude content scripts — they use pre-built CSS
  outdir: 'styled-system',
  presets: [constellationPandaPreset()],
  plugins: constellationPandaPlugins({ removeUnusedCssVariables: false }),
});
```

### Using PandaCSS in Popup/SidePanel

```tsx
import { css } from '../styled-system/css';
import { Box, Flex } from '../styled-system/jsx';
import { Button, Text, Card, Icon } from '@zillow/constellation';
import { IconSearchFilled } from '@zillow/constellation-icons';

function PopupApp() {
  return (
    <Flex direction="column" gap="300" css={{ p: '400', width: '360px' }}>
      <Text textStyle="body-lg-bold">Property Insights</Text>
      <Card outlined elevated={false} tone="neutral" css={{ p: '400' }}>
        <Flex direction="column" gap="200">
          <Text textStyle="body-bold">Current listing</Text>
          <Text textStyle="body" css={{ color: 'text.subtle' }}>
            3 bed, 2 bath — $425,000
          </Text>
        </Flex>
      </Card>
      <Button tone="brand" emphasis="filled" size="md" icon={<IconSearchFilled />}>
        View details
      </Button>
    </Flex>
  );
}
```

### Theme Injection

```tsx
// popup/main.tsx
import { createRoot } from 'react-dom/client';
import { injectTheme } from '../styled-system/themes';
import '../styles/fonts.css';
import App from './App';

// Inject Constellation theme (applies CSS variables)
injectTheme(document.documentElement);

createRoot(document.getElementById('root')!).render(<App />);
```

---

## 4. Shadow DOM for Content Scripts

Content scripts inject UI into host pages. Shadow DOM prevents style conflicts in both directions.

### Complete Shadow DOM Setup

```typescript
// src/utils/create-shadow-root.tsx
import { createRoot, Root } from 'react-dom/client';

interface ShadowRootConfig {
  containerId: string;
  cssFiles: string[];       // Paths relative to extension root
  position?: 'fixed' | 'absolute' | 'relative';
}

export async function createExtensionShadowRoot(config: ShadowRootConfig): Promise<{
  root: Root;
  shadowRoot: ShadowRoot;
  container: HTMLDivElement;
}> {
  // Prevent duplicate injection
  const existing = document.getElementById(config.containerId);
  if (existing) {
    existing.remove();
  }

  // Create host element
  const container = document.createElement('div');
  container.id = config.containerId;
  container.style.all = 'initial'; // Reset inherited styles
  if (config.position) {
    container.style.position = config.position;
  }
  document.body.appendChild(container);

  // Create shadow root
  const shadowRoot = container.attachShadow({ mode: 'open' });

  // Load and inject CSS files
  const cssContents = await Promise.all(
    config.cssFiles.map(async (file) => {
      const url = chrome.runtime.getURL(file);
      const response = await fetch(url);
      return response.text();
    })
  );

  // Use adoptedStyleSheets (modern, performant)
  const sheet = new CSSStyleSheet();
  sheet.replaceSync(cssContents.join('\n'));
  shadowRoot.adoptedStyleSheets = [sheet];

  // Create mount point
  const mountPoint = document.createElement('div');
  mountPoint.id = 'app';
  shadowRoot.appendChild(mountPoint);

  const root = createRoot(mountPoint);

  return { root, shadowRoot, container };
}
```

### Content Script Entry Point

```tsx
// src/content/index.tsx
import { createExtensionShadowRoot } from '../utils/create-shadow-root';
import App from './App';

async function init() {
  const { root } = await createExtensionShadowRoot({
    containerId: 'zillow-ext-root',
    cssFiles: [
      'styles/fonts.css',
      'styles/constellation-tokens.css',
      'styles/content-app.css',
    ],
    position: 'fixed',
  });

  root.render(<App />);
}

init();
```

### Content Script React Component

```tsx
// src/content/App.tsx
import { useState, useEffect } from 'react';

function ContentApp() {
  const [visible, setVisible] = useState(true);
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    // Listen for messages from service worker
    chrome.runtime.onMessage.addListener((message) => {
      if (message.type === 'UPDATE_DATA') {
        setData(message.data);
      }
    });
  }, []);

  if (!visible) return null;

  return (
    <div className="ext-widget" style={{
      position: 'fixed',
      top: 'var(--spacing-400)',
      right: 'var(--spacing-400)',
      zIndex: 2147483647,
      width: '320px',
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <span className="ext-widget-title">Insights</span>
        <button
          className="ext-widget-close"
          onClick={() => setVisible(false)}
          aria-label="Close"
        >
          ✕
        </button>
      </div>
      {data && (
        <div className="ext-widget-content">
          <span className="ext-widget-subtitle">{data.summary}</span>
        </div>
      )}
      <button className="ext-widget-button" onClick={() => {
        chrome.runtime.sendMessage({ type: 'OPEN_DETAILS' });
      }}>
        View full analysis
      </button>
    </div>
  );
}

export default ContentApp;
```

---

## 5. Constellation Components in Extension Pages

Extension pages (popup, side panel, options) can use the full Constellation component library.

### Available Components (Commonly Used in Extensions)

| Component | Extension Use Case |
|-----------|-------------------|
| `Button` | Primary/secondary actions |
| `Card` | Content containers (outlined for static, elevated+interactive for clickable) |
| `Text` | All text rendering with textStyle hierarchy |
| `Heading` | Page title (1-2 per page max) |
| `Icon` + Icons | UI indicators, action buttons |
| `IconButton` | Icon-only actions (close, settings, etc.) |
| `Input` | Search fields, text entry |
| `Select` | Dropdown selection |
| `Checkbox` / `Radio` | Settings toggles |
| `Tabs` | Multi-section content |
| `Divider` | Visual separators |
| `Tag` | Status labels, badges |
| `Modal` | Confirmation dialogs |
| `Accordion` | Expandable sections |
| `ToggleButtonGroup` | Single-select options |
| `SegmentedControl` | View switching |
| `ZillowLogo` | Branding (24px desktop) |

### Component Imports

```tsx
// Components
import {
  Button, Card, Text, Heading, Input, Tabs, Icon, IconButton,
  Divider, Select, Checkbox, Radio, Tag, Modal, Accordion,
  ToggleButtonGroup, ToggleButton, SegmentedControl, ZillowLogo,
} from '@zillow/constellation';

// Icons — ALWAYS use Filled variants
import {
  IconSearchFilled, IconSettingsFilled, IconCloseFilled,
  IconHomeFilled, IconHeartFilled, IconFilterFilled,
} from '@zillow/constellation-icons';

// PandaCSS
import { css } from '../styled-system/css';
import { Box, Flex } from '../styled-system/jsx';
```

### Extension Popup Example

```tsx
import { useState, useEffect } from 'react';
import { Button, Card, Text, Heading, Icon, IconButton, Divider, Tag, ZillowLogo } from '@zillow/constellation';
import { IconSettingsFilled, IconCloseFilled, IconHomeFilled } from '@zillow/constellation-icons';
import { Flex } from '../styled-system/jsx';

function PopupApp() {
  const [listings, setListings] = useState([]);

  useEffect(() => {
    chrome.storage.local.get('savedListings', (result) => {
      setListings(result.savedListings || []);
    });
  }, []);

  return (
    <Flex direction="column" css={{ width: '380px', bg: 'bg.screen.neutral' }}>
      {/* Header */}
      <Flex
        css={{ p: '300', justifyContent: 'space-between', alignItems: 'center' }}
      >
        <Flex gap="200" css={{ alignItems: 'center' }}>
          <ZillowLogo css={{ height: '24px', width: 'auto' }} />
          <Text textStyle="body-bold">Property Insights</Text>
        </Flex>
        <IconButton
          title="Settings"
          tone="neutral"
          emphasis="bare"
          size="md"
          shape="square"
          onClick={() => chrome.runtime.openOptionsPage()}
        >
          <Icon><IconSettingsFilled /></Icon>
        </IconButton>
      </Flex>

      <Divider />

      {/* Content */}
      <Flex direction="column" gap="300" css={{ p: '400' }}>
        {listings.length === 0 ? (
          <Flex direction="column" gap="200" css={{ alignItems: 'center', py: '600' }}>
            <Icon size="xl" css={{ color: 'icon.subtle' }}><IconHomeFilled /></Icon>
            <Text textStyle="body" css={{ color: 'text.subtle', textAlign: 'center' }}>
              No saved listings yet. Browse Zillow to save properties.
            </Text>
          </Flex>
        ) : (
          listings.map((listing) => (
            <Card key={listing.id} outlined elevated={false} tone="neutral" css={{ p: '300' }}>
              <Flex direction="column" gap="100">
                <Flex css={{ justifyContent: 'space-between', alignItems: 'center' }}>
                  <Text textStyle="body-bold">{listing.price}</Text>
                  <Tag size="sm" tone="blue">{listing.status}</Tag>
                </Flex>
                <Text textStyle="body-sm" css={{ color: 'text.subtle' }}>
                  {listing.address}
                </Text>
              </Flex>
            </Card>
          ))
        )}
      </Flex>

      {/* Footer */}
      <Divider />
      <Flex css={{ p: '300' }}>
        <Button
          tone="brand"
          emphasis="filled"
          size="md"
          css={{ width: '100%' }}
          onClick={() => chrome.tabs.create({ url: 'https://www.zillow.com' })}
        >
          Open Zillow
        </Button>
      </Flex>
    </Flex>
  );
}
```

---

## 6. Dark Mode Support

### Extension Pages

Use the same approach as standard Constellation apps:

```tsx
// main.tsx
import { getTheme, injectTheme } from '../styled-system/themes';

const theme = getTheme('zillow');
injectTheme(document.documentElement);

// Toggle dark mode
function toggleDarkMode(enabled: boolean) {
  document.documentElement.setAttribute(
    'data-panda-mode',
    enabled ? 'dark' : 'light'
  );
  chrome.storage.local.set({ darkMode: enabled });
}

// Load preference on startup
chrome.storage.local.get('darkMode', (result) => {
  if (result.darkMode) {
    document.documentElement.setAttribute('data-panda-mode', 'dark');
  }
});
```

### Content Scripts

For content scripts using raw CSS tokens, include both light and dark token files and switch based on preference:

```typescript
const { darkMode } = await chrome.storage.local.get('darkMode');
const tokenFile = darkMode ? 'styles/constellation-tokens-dark.css' : 'styles/constellation-tokens.css';
```

---

## 7. Professional App Rules in Extensions

When building extensions for real estate professionals, follow these Constellation rules:

| Rule | Implementation |
|------|---------------|
| Colors restricted to Blue (#0041D9) for actions, Granite (#111116) for text | Use `--color-blue-600` for buttons/links, `--color-gray-950` for text |
| Backgrounds: White + Light Gray only | Use `--color-bg-screen-neutral` and `--color-bg-screen-softest` |
| No Purple, Orange, or vibrant Teal for UI | Stick to blue, gray, and neutral tones |
| Default to `size="md"` for buttons and inputs | Set `size="md"` on all `Button`, `Input`, `Select` |
| Filled icons for standard UI, Duotone for empty states | Import from `@zillow/constellation-icons` (Filled variants) |
| Spot illustrations only (no Scene illustrations) | Use spot SVGs from Constellation illustration library |
| Shadows only on interactive elements | `elevated` only with `interactive` on Cards |

---

## 8. Token Quick Reference for Content Script CSS

When you cannot use PandaCSS (content scripts), use these CSS custom properties directly:

```css
/* Typography */
font-family: var(--font-family-ui);           /* Inter */
font-family: var(--font-family-brand);        /* Object Sans (headings) */

/* Colors */
color: var(--color-text-default);             /* Primary text */
color: var(--color-text-subtle);              /* Secondary text */
color: var(--color-text-action-hero-default); /* Links/actions */
background: var(--color-bg-screen-neutral);   /* White background */
background: var(--color-bg-screen-softest);   /* Light gray background */
border-color: var(--color-border-default);    /* Default border */

/* Spacing */
padding: var(--spacing-400);                  /* 16px standard */
gap: var(--spacing-300);                      /* 12px comfortable */
margin-bottom: var(--spacing-200);            /* 8px tight */

/* Shape */
border-radius: var(--radius-300);             /* 12px cards/buttons */
box-shadow: var(--shadow-md);                 /* Medium elevation */

/* Sizing */
font-size: var(--font-size-400);              /* 16px body */
font-size: var(--font-size-350);              /* 14px body-sm */
```
