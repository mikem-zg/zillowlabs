# Creating a Custom Theme

This guide explains how to create a new custom theme that extends Constellation's design tokens. Custom themes allow you to add brand-specific tokens while maintaining compatibility with the Constellation design system.

## When to Create a Custom Theme vs. Override

| Approach | When to Use |
|---|---|
| Custom Theme (this guide) | You need to add new tokens that don't exist in Constellation (e.g., brand-specific colors, custom spacing scales). You want to share the theme across multiple apps or packages. You're building a distinct experience like a partner integration or embedded product. |
| Theme Override | You only need to change a few existing values (e.g., swap primary color, adjust font family). The changes are specific to one app and don't need to be shared. You're tweaking existing Constellation tokens, not adding new ones. |

## Prerequisites

Required packages:

```
pnpm add @zillow/constellation-tokens
```

You'll also need a deep merge utility (lodash or custom `deep-merge.ts`).

## Part 1: Creating a Custom Theme

### Directory Structure

```
src/
└── panda-preset/
    ├── utils/
    │   └── deep-merge.ts
    ├── theme/
    │   ├── tokens.ts          # Tier 1: Base tokens
    │   ├── semantic-tokens.ts # Tier 2: Semantic tokens
    │   └── index.ts           # Theme export
    └── index.ts               # Preset export
```

### Step 1: Define Base Tokens (Tier 1)

```ts
// src/panda-preset/theme/tokens.ts
export const tokens = {
  // Add colors, fonts, sizes, spacing, radii, fontSizes, etc.
};
```

### Step 2: Define Semantic Tokens (Tier 2)

Semantic tokens provide contextual meaning and support light/dark mode.

```ts
// src/panda-preset/theme/semantic-tokens.ts
// Use `base` for light mode, `_dark` for dark mode
// Reference base tokens with {category.tokenName} syntax
export const semanticTokens = {
  // Add semantic tokens as needed
};
```

### Step 3: Create the Theme Export

Merge your tokens with Constellation's base tokens.

```ts
// src/panda-preset/theme/index.ts
import {
  constellationSemanticTokens,
  constellationTokens,
} from '@zillow/constellation-tokens/panda/zillow';

import { deepMerge } from '../utils/deep-merge';
import { semanticTokens } from './semantic-tokens';
import { tokens } from './tokens';

export const customTheme = {
  tokens: deepMerge<object>(constellationTokens, tokens),
  semanticTokens: deepMerge<object>(constellationSemanticTokens, semanticTokens),
};
```

### Step 4: Create the Preset

```ts
// src/panda-preset/index.ts
import { definePreset } from '@pandacss/dev';
import { customTheme } from './theme';

export const customThemePreset = () => {
  return definePreset({
    name: 'preset-custom-theme',
    themes: {
      extend: {
        'custom-theme': {
          ...customTheme,
        },
      },
    },
  });
};
```

### Step 5: Export from Your Package

```json
{
  "name": "@your-org/your-package",
  "exports": {
    ".": "./dist/index.js",
    "./panda-preset": "./src/panda-preset/index.ts"
  }
}
```

### Step 6: Configure panda.config.ts

```ts
import { defineConfig } from '@pandacss/dev';
import { constellationPandaConfig } from '@zillow/constellation-config';
import { customThemePreset } from './src/panda-preset';

export default defineConfig(
  constellationPandaConfig({
    config: {
      include: ['./src/**/*.{ts,tsx,js,jsx}'],
      presets: [customThemePreset()],
      staticCss: {
        themes: ['custom-theme'],
      },
    },
  }),
);
```

## Part 2: Consuming a Custom Theme

```ts
// panda.config.ts
import { defineConfig } from '@pandacss/dev';
import { customThemePreset } from '@your-org/your-package/panda-preset';
import { constellationPandaConfig } from '@zillow/constellation-config';

export default defineConfig(
  constellationPandaConfig({
    config: {
      include: ['./src/**/*.{ts,tsx,js,jsx}'],
      presets: [customThemePreset()],
      staticCss: {
        themes: ['zillow', 'custom-theme'],
      },
    },
  }),
);
```

## Part 3: Applying Your Theme

The key requirement is setting the `data-panda-theme` attribute on your root element:

```html
<html data-panda-theme="custom-theme"></html>
```

## Troubleshooting

| Issue | Solution |
|---|---|
| Tokens not applying | Ensure the theme is listed in `staticCss.themes` and run `pnpm scaffold` |
| Type errors with tokens | Run `pnpm scaffold` after adding new tokens |
| Dark mode not working | Verify semantic tokens have both `base` and `_dark` values |
| Theme name not found | Check theme name matches exactly (case-sensitive) |
