# React + Vite Build Configuration

Build Chrome extensions with React, TypeScript, and Vite using multi-entry builds for popup, content script, service worker, side panel, and options page.

---

## Project Setup

### Initialize

```bash
npm create vite@latest my-extension -- --template react-ts
cd my-extension
npm install
npm install -D @types/chrome
```

### Install Constellation (if using Zillow design system)

```bash
npm install @zillow/constellation @zillow/constellation-icons @zillow/constellation-tokens @zillow/constellation-fonts @zillow/constellation-config
npm install -D @pandacss/dev
```

### Directory Structure

```
my-extension/
├── manifest.json                    # In project root
├── vite.config.ts
├── vite.content.config.ts           # Separate config for content script
├── panda.config.ts                  # PandaCSS (if using Constellation)
├── tsconfig.json
├── package.json
├── public/
│   ├── icons/
│   │   ├── icon16.png
│   │   ├── icon48.png
│   │   └── icon128.png
│   ├── fonts/
│   │   ├── inter-variable.woff2
│   │   └── object-sans-heavy.woff2
│   └── styles/
│       ├── fonts.css
│       └── constellation-tokens.css
├── src/
│   ├── popup/
│   │   ├── index.html
│   │   ├── main.tsx
│   │   └── App.tsx
│   ├── sidepanel/
│   │   ├── index.html
│   │   ├── main.tsx
│   │   └── App.tsx
│   ├── options/
│   │   ├── index.html
│   │   ├── main.tsx
│   │   └── App.tsx
│   ├── content/
│   │   ├── index.tsx               # Content script entry
│   │   └── App.tsx
│   ├── background/
│   │   └── service-worker.ts
│   ├── components/                  # Shared components
│   ├── utils/
│   └── types/
│       └── messages.ts             # Typed message definitions
└── styled-system/                   # PandaCSS output
```

---

## Vite Configuration

### Main Config (Extension Pages)

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  base: './',  // CRITICAL: Chrome extensions need relative paths
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    rollupOptions: {
      input: {
        popup: resolve(__dirname, 'src/popup/index.html'),
        sidepanel: resolve(__dirname, 'src/sidepanel/index.html'),
        options: resolve(__dirname, 'src/options/index.html'),
      },
      output: {
        entryFileNames: 'assets/[name].js',
        chunkFileNames: 'assets/[name]-[hash].js',
        assetFileNames: 'assets/[name].[ext]',
      },
    },
  },
});
```

### Content Script Config (Separate Build)

Content scripts need a separate build — they must produce a single JS file (no HTML entry point, no code splitting).

```typescript
// vite.content.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  base: './',
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  build: {
    outDir: 'dist',
    emptyOutDir: false,  // Don't clear main build output
    lib: {
      entry: resolve(__dirname, 'src/content/index.tsx'),
      name: 'ContentScript',
      formats: ['iife'],  // Immediately-invoked function expression
      fileName: () => 'content.js',
    },
    rollupOptions: {
      output: {
        extend: true,
      },
    },
  },
  define: {
    'process.env.NODE_ENV': JSON.stringify('production'),
  },
});
```

### Service Worker Config (Separate Build)

```typescript
// vite.background.config.ts
import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  build: {
    outDir: 'dist',
    emptyOutDir: false,
    lib: {
      entry: resolve(__dirname, 'src/background/service-worker.ts'),
      formats: ['es'],
      fileName: () => 'service-worker.js',
    },
    rollupOptions: {
      output: {
        entryFileNames: 'service-worker.js',
      },
    },
  },
});
```

---

## Build Scripts

### package.json

```json
{
  "scripts": {
    "dev": "npm run build:watch",
    "build": "npm run build:pages && npm run build:content && npm run build:background && npm run build:manifest",
    "build:pages": "vite build",
    "build:content": "vite build --config vite.content.config.ts",
    "build:background": "vite build --config vite.background.config.ts",
    "build:manifest": "cp manifest.json dist/manifest.json",
    "build:watch": "concurrently \"vite build --watch\" \"vite build --config vite.content.config.ts --watch\"",
    "panda": "panda codegen",
    "panda:watch": "panda codegen --watch",
    "zip": "cd dist && zip -r ../extension.zip ."
  }
}
```

### Post-Build: Copy Static Assets

```typescript
// scripts/copy-assets.ts
import { cpSync, mkdirSync } from 'fs';
import { join } from 'path';

const dist = join(__dirname, '..', 'dist');

// Copy fonts
mkdirSync(join(dist, 'fonts'), { recursive: true });
cpSync(join(__dirname, '..', 'public', 'fonts'), join(dist, 'fonts'), { recursive: true });

// Copy styles
mkdirSync(join(dist, 'styles'), { recursive: true });
cpSync(join(__dirname, '..', 'public', 'styles'), join(dist, 'styles'), { recursive: true });

// Copy icons
mkdirSync(join(dist, 'icons'), { recursive: true });
cpSync(join(__dirname, '..', 'public', 'icons'), join(dist, 'icons'), { recursive: true });

// Copy manifest
cpSync(join(__dirname, '..', 'manifest.json'), join(dist, 'manifest.json'));
```

Add to package.json:

```json
{
  "scripts": {
    "build": "npm run build:pages && npm run build:content && npm run build:background && tsx scripts/copy-assets.ts"
  }
}
```

---

## CRXJS Plugin (Alternative)

CRXJS provides HMR, automatic manifest handling, and simpler configuration.

### Setup

```bash
npm install -D @crxjs/vite-plugin
```

### vite.config.ts with CRXJS

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { crx } from '@crxjs/vite-plugin';
import manifest from './manifest.json';

export default defineConfig({
  plugins: [
    react(),
    crx({ manifest }),
  ],
  resolve: {
    alias: {
      '@': new URL('./src', import.meta.url).pathname,
    },
  },
});
```

### CRXJS Benefits
- Hot Module Replacement in popup and content scripts
- Automatic manifest.json processing
- TypeScript manifest support
- Content script auto-reload
- Simplified build — single `vite build` command

### CRXJS Limitations
- May not support all manifest features (side panel, etc.)
- Some versions have compatibility issues with latest Vite
- Less control over build output structure

---

## TypeScript Configuration

### tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "types": ["chrome"],
    "paths": {
      "@/*": ["./src/*"]
    },
    "baseUrl": "."
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### Chrome Types

The `@types/chrome` package provides complete type definitions for all Chrome Extension APIs:

```bash
npm install -D @types/chrome
```

---

## HTML Entry Points

### Popup

```html
<!-- src/popup/index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Extension Popup</title>
</head>
<body>
  <div id="root"></div>
  <script type="module" src="main.tsx"></script>
</body>
</html>
```

### Side Panel

```html
<!-- src/sidepanel/index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Side Panel</title>
</head>
<body>
  <div id="root"></div>
  <script type="module" src="main.tsx"></script>
</body>
</html>
```

### Main Entry Point

```tsx
// src/popup/main.tsx (same pattern for sidepanel and options)
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

// If using Constellation PandaCSS:
// import '../styles/fonts.css';
// import { injectTheme } from '../styled-system/themes';
// injectTheme(document.documentElement);

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>
);
```

---

## Asset Handling

### Images and Icons

Place static assets in `public/` — they're copied as-is to `dist/`:

```
public/
├── icons/
│   ├── icon16.png
│   ├── icon48.png
│   └── icon128.png
└── images/
    └── logo.svg
```

Reference in code:

```typescript
// In service worker or popup
const iconUrl = chrome.runtime.getURL('icons/icon128.png');

// In HTML
<img src="icons/icon128.png" alt="Extension icon" />
```

### Importing Assets in React

```tsx
// For extension pages (popup, sidepanel, options)
import logoSvg from '@/assets/logo.svg';

function Header() {
  return <img src={logoSvg} alt="Logo" />;
}
```

---

## Development Workflow

### 1. Build the Extension

```bash
npm run build
```

### 2. Load in Chrome

1. Navigate to `chrome://extensions`
2. Enable **Developer mode** (top-right toggle)
3. Click **Load unpacked**
4. Select the `dist/` folder

### 3. Reload After Changes

After rebuilding:
- Click the reload icon on your extension card in `chrome://extensions`
- Or use the CRXJS plugin for automatic HMR

### 4. Debugging

| Component | How to Debug |
|-----------|-------------|
| **Popup** | Right-click extension icon → "Inspect popup" |
| **Service Worker** | chrome://extensions → click "Inspect views: service worker" |
| **Content Script** | Regular DevTools on the host page (Console → select extension context) |
| **Side Panel** | Right-click inside panel → "Inspect" |
| **Options** | Standard DevTools on the options page |

### 5. Common Development Issues

| Issue | Solution |
|-------|----------|
| Changes not visible | Rebuild and reload extension at chrome://extensions |
| Assets not loading | Verify `base: './'` in Vite config |
| Content script not injecting | Check `matches` patterns in manifest |
| Service worker errors | Check chrome://extensions → "Errors" button |
| TypeScript Chrome API errors | Ensure `@types/chrome` is installed and `"types": ["chrome"]` in tsconfig |

---

## Production Build Checklist

1. Set `NODE_ENV=production` in build
2. Remove console.log statements (or use a build-time strip plugin)
3. Minify all output (Vite default)
4. Verify all paths are relative (`base: './'`)
5. Test with a fresh Chrome profile
6. Check bundle size (Chrome Web Store has a ~10MB ZIP limit, recommend under 5MB)
7. Zip the `dist/` folder: `cd dist && zip -r ../extension.zip .`
