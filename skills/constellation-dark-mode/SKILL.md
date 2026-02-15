---
name: constellation-dark-mode
description: Implement and manage Constellation dark mode and theming. Use when adding dark mode support, switching themes, handling dark/light illustrations, or applying conditional dark mode styles in components using the Zillow Constellation design system.
---

# Constellation Dark Mode & Theming

## Reference Guides

For deeper documentation, see the reference files in this skill:

- **`reference/dark-mode.md`** — Official Constellation dark mode guide, toggle patterns, localStorage persistence
- **`reference/theming.md`** — Theme application, `getTheme`/`injectTheme`, SSR patterns, theme overrides
- **`reference/custom-themes.md`** — Creating custom themes, preset structure, merging with Constellation tokens
- **`reference/design-tokens.md`** — Token tier system, naming taxonomy, color semantics, PandaCSS token usage

## Architecture Overview

This project uses **PandaCSS** with the **Zillow Constellation** design system. Theming is powered by:

1. **CSS token files** from `@zillow/constellation-tokens` (light and dark variants)
2. **PandaCSS theme injection** via `getTheme()` and `injectTheme()` from `@/styled-system/themes`
3. **CSS conditions** (`_dark`, `_light`, `_osDark`, `_osLight`) for conditional styling
4. **`data-panda-mode` attribute** on DOM elements to trigger dark mode styles

## Available Themes

| Theme Name | CSS Import | Description |
|---|---|---|
| `zillow` | `@zillow/constellation-tokens/css/zillow` | Current light theme (active) |
| `zillow-dark` | `@zillow/constellation-tokens/css/zillow-dark` | Dark theme raw tokens (DO NOT import directly — see warning below) |
| `legacy-zillow` | `@zillow/constellation-tokens/css/legacy` | Legacy light theme |

Token files located at: `node_modules/@zillow/constellation-tokens/dist/css/{theme}/constellation-tokens.css`

PandaCSS theme JSON files: `client/src/styled-system/themes/theme-zillow.json`, `theme-legacy-zillow.json`

## CRITICAL WARNING: Do NOT import zillow-dark CSS directly

**NEVER** add `import "@zillow/constellation-tokens/css/zillow-dark"` to `main.tsx` or any file.

**Why it breaks:** The raw `zillow-dark` CSS file defines `:root` variables (`--color-*`) with dark values unconditionally. This overrides the light theme for all Constellation components that internally reference `--color-*` variables. Meanwhile, PandaCSS uses a separate set of variables (`--colors-*`, note the "s") that are properly scoped behind `[data-panda-theme=zillow][data-panda-mode="dark"]` selectors via `injectTheme()`.

**The result:** Text turns light (from the raw dark `:root` tokens) while PandaCSS backgrounds stay white (from the `--colors-*` variables that still reflect light mode). This creates a mismatch where content becomes unreadable.

**The correct approach:** PandaCSS's `injectTheme()` already generates the proper conditional dark mode CSS. You only need to set `data-panda-mode="dark"` on the root element — no additional CSS import is needed.

| NEVER | ALWAYS instead |
|---|---|
| `import "@zillow/constellation-tokens/css/zillow-dark"` in main.tsx | Rely on `injectTheme()` from `@/styled-system/themes` |
| Raw `:root` dark token overrides | `data-panda-mode="dark"` attribute on `document.documentElement` |
| Both `--color-*` and `--colors-*` active at once | Let PandaCSS manage all token switching via conditions |

## How Theme Injection Works

In `client/src/main.tsx`:

```tsx
import { getTheme, injectTheme } from "@/styled-system/themes";

async function initApp() {
  const theme = await getTheme("zillow");
  injectTheme(document.documentElement, theme);
  createRoot(document.getElementById("root")!).render(<App />);
}
```

`injectTheme()` does three things:
1. Creates a `<style>` element with the theme's CSS
2. Sets `data-panda-theme="zillow"` on the target element
3. Appends the style sheet to `<head>`

## Dark Mode Activation

Dark mode is controlled by the `data-panda-mode` attribute on a DOM element (typically `document.documentElement`).

### Manual Toggle

```tsx
document.documentElement.setAttribute('data-panda-mode', 'dark');
document.documentElement.removeAttribute('data-panda-mode'); // back to light
```

### OS-Preference Based (Automatic)

Use the `_osDark` / `_osLight` conditions which map to `@media (prefers-color-scheme: dark/light)`.

### Full Dark Mode Setup Pattern

```tsx
// main.tsx - Load dark tokens alongside light tokens
import "@zillow/constellation-tokens/css/zillow";
import "@zillow/constellation-tokens/css/zillow-dark"; // ADD THIS for dark mode
import "@zillow/constellation-fonts/zillow-fonts.css";
import "@/styled-system/styles.css";
import { getTheme, injectTheme } from "@/styled-system/themes";

async function initApp() {
  const theme = await getTheme("zillow");
  injectTheme(document.documentElement, theme);
  createRoot(document.getElementById("root")!).render(<App />);
}
initApp();
```

### Theme Toggle Hook

```tsx
import { useState, useEffect, useCallback } from 'react';

type ThemeMode = 'light' | 'dark' | 'system';

function useThemeMode(defaultMode: ThemeMode = 'system') {
  const [mode, setMode] = useState<ThemeMode>(() => {
    if (typeof window === 'undefined') return defaultMode;
    return (localStorage.getItem('theme-mode') as ThemeMode) || defaultMode;
  });

  const applyMode = useCallback((m: ThemeMode) => {
    const root = document.documentElement;
    if (m === 'dark') {
      root.setAttribute('data-panda-mode', 'dark');
    } else if (m === 'light') {
      root.removeAttribute('data-panda-mode');
    } else {
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      if (prefersDark) {
        root.setAttribute('data-panda-mode', 'dark');
      } else {
        root.removeAttribute('data-panda-mode');
      }
    }
  }, []);

  useEffect(() => {
    applyMode(mode);
    localStorage.setItem('theme-mode', mode);
  }, [mode, applyMode]);

  useEffect(() => {
    if (mode !== 'system') return;
    const mq = window.matchMedia('(prefers-color-scheme: dark)');
    const handler = () => applyMode('system');
    mq.addEventListener('change', handler);
    return () => mq.removeEventListener('change', handler);
  }, [mode, applyMode]);

  return { mode, setMode };
}
```

## CSS Conditions Reference

| Condition | Selector | Use For |
|---|---|---|
| `_dark` | `[data-panda-mode="dark"]` | Manual dark mode toggle |
| `_light` | `[data-panda-mode="light"]` | Explicit light mode |
| `_osDark` | `@media (prefers-color-scheme: dark)` | OS preference dark |
| `_osLight` | `@media (prefers-color-scheme: light)` | OS preference light |
| `_themeZillow` | `[data-panda-theme=zillow]` | Zillow theme-specific |
| `_themeLegacy-zillow` | `[data-panda-theme=legacy-zillow]` | Legacy theme-specific |

## Conditional Styling in Components

### Using css() function

```tsx
import { css } from '@/styled-system/css';

const containerStyle = css({
  bg: 'bg.screen.neutral',
  color: 'text.default',
  _dark: {
    bg: 'bg.screen.neutral',    // Resolves to black in dark mode
    color: 'text.default',       // Resolves to light text in dark mode
  }
});
```

### Using JSX style props

```tsx
import { Box, Flex } from '@/styled-system/jsx';

<Box
  bg="bg.screen.neutral"
  _dark={{ bg: 'bg.screen.neutral' }}
  p="400"
>
  Content
</Box>
```

### Nesting conditions

```tsx
const style = css({
  color: 'text.default',
  _dark: {
    color: 'text.default',
    _hover: {
      color: 'text.subtle',
    }
  }
});
```

## Key Dark Mode Token Mappings

Semantic tokens automatically remap between light and dark. Key changes:

| Token | Light Value | Dark Value |
|---|---|---|
| `bg.screen.neutral` | `white` | `black` |
| `bg.screen.softest` | `gray-50` | `gray-950` |
| `bg.action.hero.default` | `blue-600` | `blue-400` |
| `bg.action.soft.default` | `gray-100` | `gray-900` |
| `text.on-hero.neutral` | `white` | `black` |
| `border.accent.brand.hero` | `blue-600` | `blue-400` |

### Fixed Tokens (Same in Both Modes)

Some tokens are intentionally fixed across modes:
- `text.on-hero.neutral-fixed` → always `white`
- `text.on-hero.link-fixed-*` → always `white/gray-100/gray-200`

## Illustrations (Dark Mode Variants)

Both light and dark illustration SVGs are available:

| Theme | Path |
|---|---|
| Light | `client/src/assets/illustrations/Lightmode/{name}.svg` |
| Dark | `client/src/assets/illustrations/Darkmode/{name}.svg` |

93 illustrations available. See `custom_instruction/illustrations-catalog.md` for the full list.

### Dark Mode Illustration Pattern

```tsx
import SearchHomesLight from '@/assets/illustrations/Lightmode/search-homes.svg';
import SearchHomesDark from '@/assets/illustrations/Darkmode/search-homes.svg';

function useIsDarkMode(): boolean {
  const [isDark, setIsDark] = useState(false);
  useEffect(() => {
    const observer = new MutationObserver(() => {
      setIsDark(document.documentElement.getAttribute('data-panda-mode') === 'dark');
    });
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-panda-mode'] });
    setIsDark(document.documentElement.getAttribute('data-panda-mode') === 'dark');
    return () => observer.disconnect();
  }, []);
  return isDark;
}

function EmptyState() {
  const isDark = useIsDarkMode();
  return (
    <img
      src={isDark ? SearchHomesDark : SearchHomesLight}
      alt="Search homes"
      width={160}
      height={160}
    />
  );
}
```

## Dark Mode Design Rules

### Shadows
- NO shadows in dark mode — use lighter/elevated backgrounds instead
- Use `_dark: { shadow: 'none' }` to remove shadows

### Backgrounds
- Use semantic tokens (`bg.screen.neutral`, `bg.screen.softest`) — they auto-remap
- Do NOT hardcode `#FFFFFF` or `#000000`

### Dividers
- Continue using `<Divider />` — it adapts automatically via semantic tokens
- Never use CSS borders

### Cards
- Card elevation via shadows should be disabled in dark mode
- Use subtle background differentiation instead

```tsx
<Card
  elevated
  tone="neutral"
  css={{
    _dark: {
      shadow: 'none',
      bg: 'bg.screen.softest',
    }
  }}
>
  ...
</Card>
```

## PandaCSS Config Reference

The panda config at `panda.config.ts` uses:

```ts
import { constellationPandaPreset, constellationPandaPlugins } from '@zillow/constellation-config';

export default defineConfig({
  presets: [constellationPandaPreset()],
  plugins: constellationPandaPlugins({ removeUnusedCssVariables: false }),
});
```

The preset includes theme definitions for `zillow` and `legacy-zillow` with conditions `_themeZillow` and `_themeLegacy-zillow`.

## Checklist: Adding Dark Mode to a Page

1. Import dark token CSS in `main.tsx`: `import "@zillow/constellation-tokens/css/zillow-dark";`
2. Create a theme toggle mechanism (hook + UI control)
3. Set `data-panda-mode="dark"` on `document.documentElement`
4. Use semantic tokens everywhere (they auto-remap)
5. Add `_dark` overrides only for custom styles not covered by semantic tokens
6. Swap illustrations to Darkmode variants
7. Remove shadows in dark mode, use background differentiation
8. Test all Constellation components — they respect `data-panda-mode` automatically
