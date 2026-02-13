# Constellation Installation and Setup

## Requirements

- Node 18+
- React 18+
- PandaCSS (`@pandacss/dev`)

## Install Constellation

Add Constellation packages as production dependencies:

```bash
npm install @zillow/constellation
npm install @zillow/constellation-fonts
npm install @zillow/constellation-icons

npm install --save-dev @zillow/constellation-config
```

### Packaged Dependencies

These are bundled with Constellation (no separate install needed):
- `@floating-ui/react` - Floating UI components (tooltips, popovers)
- `@radix-ui/react-slot` - Slot pattern for component composition
- `@react-spring/web` - Animations
- `@zillow/constellation-icons` - Icon library
- `date-fns` - Date utilities
- `react-swipeable` - Swipe gesture support

### Peer Dependencies

Install these alongside Constellation:
- `@pandacss/dev` - Styling solution
- `react` (v18+)
- `react-dom` (v18+)

### Optional Peer Dependencies

- `@types/react` - Only if using TypeScript
- `@zillow/constellation-icons` - Only if explicitly importing icons (e.g., adding `IconClockFilled` to a Button)
- `date-fns` - Only if formatting dates with `DatePicker`

## Install and Configure PandaCSS

### Configure PandaCSS with constellationPandaConfig (Recommended)

Use `constellationPandaConfig` to wrap your entire PandaCSS configuration. This is the recommended approach because it includes the preset, all required plugins (for `crv`, `ccv`, `splitResponsiveVariant` utilities), and correct defaults in one call.

```ts
// panda.config.ts
import { constellationPandaConfig } from '@zillow/constellation-config';

export default constellationPandaConfig({
  include: [
    './src/**/*.{js,jsx,ts,tsx}',
    './node_modules/@zillow/constellation/dist/**/*.{js,mjs}',
  ],
  outdir: 'src/styled-system',
});
```

**IMPORTANT:** Do NOT use `constellationPandaPreset` with `defineConfig` as the primary setup. The preset alone does not include the PandaCSS plugins that generate required utility exports (`crv`, `ccv`, `splitResponsiveVariant`). Using only the preset will cause codegen to fail with missing exports. Always use `constellationPandaConfig` instead.

### Available Exports from @zillow/constellation-config

The package exports three items with different levels of control:

| Export | Usage | Includes Plugins? |
|--------|-------|-------------------|
| `constellationPandaConfig` | Full config wrapper (recommended) | Yes |
| `constellationPandaPreset` | Preset only (advanced use) | No |
| `constellationPandaPlugins` | Plugins only (advanced use) | Yes (plugins only) |

### Advanced: Using Preset + Plugins Separately

If you need fine-grained control, you can combine the preset and plugins manually with `defineConfig`:

```ts
// panda.config.ts (advanced — only if constellationPandaConfig doesn't fit your needs)
import { defineConfig } from '@pandacss/dev';
import { constellationPandaPreset, constellationPandaPlugins } from '@zillow/constellation-config';

export default defineConfig({
  presets: [constellationPandaPreset],
  plugins: constellationPandaPlugins,
  include: [
    './src/**/*.{js,jsx,ts,tsx}',
    './node_modules/@zillow/constellation/dist/**/*.{js,mjs}',
  ],
  outdir: 'src/styled-system',
  jsxFramework: 'react',
});
```

### Constellation Panda Config Defaults

The `constellationPandaConfig` wrapper provides:
- `jsxFramework: 'react'`
- `jsxStyleProps: 'all'`
- Hash enabled (`hash: true`)
- Constellation's theme tokens, semantic tokens, and recipes
- PandaCSS plugins for `crv`, `ccv`, and `splitResponsiveVariant` utility generation

You can pass any PandaCSS setting to `constellationPandaConfig()` and the Constellation defaults will be merged with your overrides.

### Set Up PandaCSS Build Process

Add PandaCSS scripts to your `package.json`:

```json
{
  "scripts": {
    "prepare": "panda codegen",
    "dev": "concurrently \"panda --watch\" \"your-dev-server\"",
    "build": "panda codegen && panda cssgen && your-build-command"
  }
}
```

## Import CSS Styles

### React Application with Bundler

```tsx
// main.tsx or App.tsx
import './styled-system/styles.css';
```

## Set the Theme

The `getTheme` function loads a theme by name (returns a Promise), and `injectTheme` applies it to a DOM element. Both arguments to `injectTheme` are required: the target element and the theme object.

### Using useEffect in a React Component (Recommended)

```tsx
import { useEffect } from 'react';
import { getTheme, injectTheme } from './styled-system/themes';

function ThemeLoader({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    getTheme('zillow').then((theme) => {
      injectTheme(document.documentElement, theme);
    });
  }, []);
  return <>{children}</>;
}

function App() {
  return (
    <ThemeLoader>
      <YourApp />
    </ThemeLoader>
  );
}
```

### Using ConstellationProvider

```tsx
import { ConstellationProvider } from '@zillow/constellation';

function App() {
  return (
    <ConstellationProvider>
      <YourApp />
    </ConstellationProvider>
  );
}
```

**IMPORTANT:** `injectTheme` requires two arguments: `injectTheme(element, theme)`. Calling it with only one argument (e.g., `injectTheme(document.documentElement)`) will fail silently because the theme CSS won't be injected. Always load the theme first with `getTheme('zillow')` and pass the result as the second argument.

## Set Up Aliases for styled-system

### Vite / Vitest

```ts
// vite.config.ts
import { defineConfig } from 'vite';
import path from 'path';

export default defineConfig({
  resolve: {
    alias: {
      '@/styled-system': path.resolve(__dirname, 'src/styled-system'),
    },
  },
});
```

### TypeScript

```json
// tsconfig.json
{
  "compilerOptions": {
    "paths": {
      "@/styled-system/*": ["./src/styled-system/*"]
    }
  }
}
```

## Tarball Installation (Replit / Offline)

Constellation v10.11.0 tarballs are bundled with this skill at `.agents/skills/constellation/packages/`. Copy them to your project root and add them to `package.json`:

```bash
cp .agents/skills/constellation/packages/*.tgz ./
```

Then add to `package.json`:

```json
{
  "dependencies": {
    "@zillow/constellation": "file:constellation-10.11.0.tgz",
    "@zillow/constellation-fonts": "file:constellation-fonts-10.11.0.tgz",
    "@zillow/constellation-icons": "file:constellation-icons-10.11.0.tgz",
    "@zillow/constellation-tokens": "file:constellation-tokens-10.11.0.tgz",
    "@zillow/yield-callback": "file:yield-callback-1.4.0.tgz"
  },
  "devDependencies": {
    "@zillow/constellation-config": "file:constellation-config-10.11.0.tgz"
  }
}
```

Then run `npm install`.

### Bundled Packages

The following tarballs are included in `packages/`:

| File | Package | Description |
|------|---------|-------------|
| `constellation-10.11.0.tgz` | `@zillow/constellation` | Core UI components (99 components) |
| `constellation-icons-10.11.0.tgz` | `@zillow/constellation-icons` | Icon library (621 icons) |
| `constellation-tokens-10.11.0.tgz` | `@zillow/constellation-tokens` | Design tokens (colors, spacing, etc.) |
| `constellation-fonts-10.11.0.tgz` | `@zillow/constellation-fonts` | Zillow typography |
| `constellation-config-10.11.0.tgz` | `@zillow/constellation-config` | PandaCSS preset configuration |
| `constellation-mcp-10.11.0.tgz` | `@zillow/constellation-mcp` | MCP server (17 tools, 253 resources) |
| `yield-callback-1.4.0.tgz` | `@zillow/yield-callback` | Performance utility |
