# Dark Mode

As of Constellation v10, dark mode is available for the Zillow and Zillow Legacy themes.

## How to Turn On Dark Mode

Add the `data-panda-mode` data-attribute to the parent element and set it to `dark`. To turn off dark mode, remove the data-attribute.

```html
<html data-panda-theme="zillow" data-panda-mode="dark">
  <body></body>
</html>
```

## Overriding Theme Values for Dark Mode

Use the `_dark` condition in the `semanticTokens` property within the `themes` config. This does NOT work in the `tokens` property.

```ts
// panda.config.ts
import { defineConfig } from '@pandacss/dev';

export default defineConfig({
  themes: {
    extend: {
      'zillow': {
        semanticTokens: {
          colors: {
            bg: {
              neutral: {
                base: 'white',
                _dark: 'gray.950',
              },
            },
          },
        },
      },
    },
  },
});
```

PandaCSS offers OS-preference-based functionality, but it is **not recommended** as it can lead to unexpected results for apps not fully compatible with dark mode.

## Implementing Dark Mode with Simple Functions

### Detecting System Preference

```ts
const isDarkMode = window.matchMedia?.('(prefers-color-scheme: dark)').matches;
```

### Listening to System Preference Changes

```ts
window.matchMedia?.('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
  const mode = e.matches ? 'dark' : 'light';
  setThemeMode(mode);
});
```

### Setting Mode Preference

```ts
// scripts/theme-mode.ts
export const setThemeMode = (mode: 'light' | 'dark') => {
  localStorage.setItem('themeMode', mode);
  document.documentElement.setAttribute('data-panda-mode', mode);
};
```

### Getting the Current Mode

```ts
// scripts/theme-mode.ts
export const getThemeMode = (): 'light' | 'dark' => {
  const saved = localStorage.getItem('themeMode');
  if (saved === 'light' || saved === 'dark') {
    return saved;
  }
  return window.matchMedia?.('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
};
```

### Initializing Dark Mode on Page Load

```ts
import { getThemeMode } from './scripts/theme-mode';

const mode = getThemeMode();
document.documentElement.setAttribute('data-panda-mode', mode);
```

### Creating a Dark Mode Toggle Component

```tsx
// components/dark-mode-toggle.tsx
import { Checkbox } from '@zillow/constellation';
import { useEffect, useState } from 'react';
import { getThemeMode, setThemeMode } from './scripts/theme-mode';

export const DarkModeToggle = () => {
  const [isDarkMode, setIsDarkMode] = useState(false);

  useEffect(() => {
    const mode = getThemeMode();
    setIsDarkMode(mode === 'dark');
  }, []);

  const handleToggle = (checked: boolean) => {
    const mode = checked ? 'dark' : 'light';
    setThemeMode(mode);
    setIsDarkMode(checked);
  };

  return <Checkbox checked={isDarkMode} onCheckedChange={handleToggle} label="Enable Dark Mode" />;
};
```
