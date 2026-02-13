# Installation and Setup

For sub-apps built on the Web Platform refer to the Setup for sub-apps guide.

## Install Constellation

Constellation requires Node 18+ and React 18+.

### Standard installation

Add Constellation packages as production dependencies.

```bash
npm install @zillow/constellation
npm install @zillow/constellation-fonts
npm install @zillow/constellation-icons

npm install --save-dev @zillow/constellation-config
```

### Install v10 alongside v8

In order to add Constellation v10 packages as production dependencies alongside Constellation v8, we recommend using an NPM alias with `npm install <alias>@npm:<name>`.

Please use `@zillow/constellation-10` as an alias, as this will help us track adoption.

```bash
npm install @zillow/constellation-10@npm:@zillow/constellation@^10
npm install @zillow/constellation-fonts
npm install @zillow/constellation-icons

npm install --save-dev @zillow/constellation-config
```

After completing the remaining installation steps, you'll be able to use both v8 and v10 at the same time:

```tsx
// page.tsx
import { Button } from '@zillow/constellation';
import { Text } from '@zillow/constellation-10';

const App = () => (
  <>
    <Button>This is a v8 component</Button>
    <Text>This is a v10 component</Text>
  </>
);
```

## Install dependencies

Constellation relies on an ecosystem of internal and external dependencies.

### Packaged Dependencies

These are bundled with Constellation, so you don't need to worry about installing them separately:

- `@floating-ui/react` - Powers our floating UI components like tooltips and popovers
- `@radix-ui/react-slot` - Provides slot pattern functionality for component composition
- `@react-spring/web` - Handles animations throughout the library
- `@zillow/constellation-icons` - Our comprehensive icon library
- `date-fns` - Date manipulation utilities
- `react-swipeable` - Adds swipe gesture support

### Peer Dependencies

You'll need to install these alongside Constellation:

- `@pandacss/dev` - Our styling solution
- `react` - Core React library (v18 or later)
- `react-dom` - React's DOM rendering package (v18 or later)

### Optional Peer Dependencies

Some dependencies are only needed in specific scenarios:

- `@types/react` - Only if you're using TypeScript
- `@zillow/constellation-icons` - Only if you need to explicitly import an icon. Ex: adding `IconClockFilled` to a Button
- `date-fns` - Only if you need to format dates while using DatePicker component

## Install and configure Panda CSS

Constellation uses Panda CSS for styling. Refer to their getting started guide to install and setup Panda in your codebase.

### Enhance Panda config with Constellation config

Use Constellation's predefined config, and include paths to files in your project that may contain Constellation/Panda usage. Note that it is important to scope this pattern as narrowly as possible in order to decrease the time it takes Panda to find and build your styles.

```ts
// panda.config.ts
import { defineConfig } from '@pandacss/dev';
import { constellationPandaConfig } from '@zillow/constellation-config';

export default defineConfig(
  constellationPandaConfig({
    config: {
      include: ['./path-to-source-files/**/*.{ts,tsx,js,jsx}'],
      staticCss: {
        themes: ['legacy-zillow'], // or `zillow` or both if you want to support multi-theme w/out dynamic imports
      },
    },
  }),
);
```

**Note:** You can provide your own build info file path by passing it to the includes array and setting `autoIncludeBuildInfo: false`. In some monorepo projects, the inclusion of the build info manifest file via symlinks might not work correctly.

```ts
// panda.config.ts
import { defineConfig } from '@pandacss/dev';
import { constellationPandaConfig } from '@zillow/constellation-config';

export default defineConfig(
  constellationPandaConfig({
    autoIncludeBuildInfo: false,
    config: {
      include: [
        './path-to-source-files/**/*.{ts,tsx,js,jsx}',
        './node_modules/@zillow/constellation/dist/panda-constellation.buildinfo.json',
      ],
    },
  }),
);
```

### Constellation Panda config defaults

The `constellationPandaConfig` function merges any Panda config options you specify with our own defaults.

The following options are set by default:

```json
{
    "eject": true,
    "importMap": "@/styled-system",
    "jsxFramework": "react",
    "jsxStyleProps": "minimal",
    "lightningcss": true,
    "outdir": "./styled-system",
    "preflight": false,
    "shorthands": false,
    "strictTokens": false,
    "strictPropertyValues": true
}
```

`constellationPandaConfig` also includes:

- Preset for v10 Constellation tokens
- Preset for legacy v8 Constellation tokens
- Plugin `panda-plugin-crv` for runtime responsive variants

### Customize Panda settings

The `constellationPandaConfig` function accepts any Panda config options under the `config` key.

```ts
// panda.config.ts
import { defineConfig } from '@pandacss/dev';
import { constellationPandaConfig } from '@zillow/constellation-config';

export default defineConfig(
  constellationPandaConfig({
    config: {
      hash: true,
    },
  }),
);
```

### Set up Panda CSS build process

Add `panda codegen --clean` to `package.json` as a prepare script to trigger Panda code generation on install:

```json
{
  "scripts": {
    "prepare": "panda codegen --clean"
  }
}
```

### Optimize CSS bundle size

We recommend using the config below to dramatically shrink your CSS bundle size. The `hash` setting converts all CSS variables and class names into short hashes, `removeUnusedCssVariables` cleans out unused variables, and `minify` handles compression.

As a real-world example, the entire Zillow theme for all Constellation components (light + dark) goes from ~715 kB down to ~218 kB.

```ts
// panda.config.ts
import { defineConfig } from '@pandacss/dev';
import { constellationPandaConfig } from '@zillow/constellation-config';

const optimize = (process.env.NODE_ENV === 'production' || Boolean(process.env.CI)) ?? false;

export default defineConfig(
  constellationPandaConfig({
    removeUnusedCssVariables: optimize,
    config: {
      // ...
      hash: optimize,
      minify: optimize,
    },
  }),
);
```

## Import Panda CSS styles

### Create a CSS file for Panda layers

Create a CSS file to serve as the consumption point for your generated CSS. Include the following layer declaration:

```css
/* src/app/globals.css */
@layer reset, base, tokens, recipes, utilities;
```

`constellationPandaConfig` organizes its CSS into these layers. Styles should cascade in this order:

1. **reset** - CSS resets and normalization (lowest priority)
2. **base** - Base element styles
3. **tokens** - Design token-based styles
4. **recipes** - Component recipe styles
5. **utilities** - Utility classes (highest priority)

### Import the CSS styles

Import the CSS styles in your application. The method depends on your framework and setup:

**Next.js application:**
```tsx
// src/app/layout.tsx
import '../styles/globals.css';
```

**React application with bundler support:**
```tsx
// src/index.tsx
import './index.css';
```

**Custom setup:**
```tsx
// src/index.tsx
import styles from './index.css';

<style dangerouslySetInnerHTML={{ __html: `${styles}` }} />;
```

## Set the theme

Whether you are implementing a NextJS app or a Storybook app, you will need to set the theme.

Add `data-panda-theme="theme-name"` to either your `body` tag or your `html` tag.

```html
<!-- zillow theme -->
<body data-panda-theme="zillow">
  <div id="root"></div>
</body>

<!-- legacy theme -->
<body data-panda-theme="legacy-zillow">
  <div id="root"></div>
</body>
```

For Storybook, leverage the `withThemeByDataAttribute` decorator:

```ts
// .storybook/preview.ts
import { withThemeByDataAttribute } from '@storybook/addon-themes';

const preview: Preview = {
  decorators: [
    withThemeByDataAttribute<ReactRenderer>({
      themes: {
        'Legacy Zillow': 'legacy-zillow',
        'Zillow': 'zillow',
      },
      defaultTheme: 'Legacy Zillow',
      attributeName: 'data-panda-theme',
    }),
  ],
};
```

## Set up aliases for styled-system

Your local Panda styled-system runtime will need to be shared with Constellation components. Internally, Constellation uses the import alias `@/styled-system`, and `constellation-config` sets `importMap` to `@/styled-system` to resolve your local Panda codegen output.

After setting up the aliases, you can use them to import styling functions:

```tsx
// page.tsx
import { Text } from '@zillow/constellation';
import { css } from '@/styled-system/css';

const App = () => (
  <div className={css({ display: 'flex' })}>
    <Text>Hello</Text>
  </div>
);
```

### Update TypeScript alias config

```json
// tsconfig.json
{
  "compilerOptions": {
    "paths": {
      "@/styled-system/*": ["./styled-system/*"]
    }
  }
}
```

### Update Next.js alias config and tree-shaking optimization

```ts
// next.config.ts
import path from 'path';

const nextConfig = {
  experimental: {
    optimizePackageImports: ['@zillow/constellation', '@zillow/constellation-icons'],
  },

  webpack(config) {
    config.resolve.alias['@/styled-system'] = path.resolve('./styled-system');
    return config;
  },
  experimental: {
    esmExternals: false, // If you are using Next's pages router, you may need this flag
  },
};
```

Constellation supports Next.js versions 13 and above (including app and pages router).

**Warning:** We have not yet tested Constellation with Turbopack bundler in Next.js dev mode.

### Update Storybook alias config

```ts
// .storybook/main.ts
import path from 'node:path';

const config = {
  webpackFinal(config) {
    config.resolve.alias['@/styled-system'] = path.resolve('./styled-system');
    return config;
  },
};
```

```ts
// .storybook/preview.ts
import '../<your-app>/globals.css';
```

### Update Jest alias config

```js
// jest.config.js
module.exports = {
  moduleNameMapper: {
    '^@/styled-system/(.*)$': '<rootDir>/styled-system/$1',
    '^@/(.*)$': '<rootDir>/src/$1',
    '^@zillow/constellation-icons/react/(.*)$':
      '<rootDir>/node_modules/@zillow/constellation-icons/dist/react/$1',
    '^@zillow/constellation-icons$':
      '<rootDir>/node_modules/@zillow/constellation-icons/dist/react/index.js',
    '^@zillow/constellation/(.*)$': '<rootDir>/node_modules/@zillow/constellation/dist/$1',
    '^@zillow/constellation$': '<rootDir>/node_modules/@zillow/constellation/dist/index.js',
  },
};
```

If you use Jest with Next.js you need to transform Constellation packages as well:

```js
// jest.config.js
import nextJest from 'next/jest.js';

const createJestConfig = nextJest({
  dir: './',
});

const customJestConfig = {};

const jestConfig = async () => {
  const nextJestConfig = await createJestConfig(customJestConfig)();

  nextJestConfig.transformIgnorePatterns = [
    '<rootDir>/node_modules/@zillow/constellation',
    '<rootDir>/node_modules/@zillow/constellation-icon',
  ];

  return nextJestConfig;
};

export default jestConfig;
```

### Update Vite/Vitest alias config

You can use the `vite-tsconfig-paths` plugin to automatically resolve paths from `tsconfig.json`, or manually add the alias:

```ts
// vite.config.ts
import path from 'node:path';

export default defineConfig({
  resolve: {
    alias: {
      '@/styled-system': path.resolve('./styled-system'),
    },
  },

  // Vitest specific
  test: {
    server: {
      deps: {
        inline: [/@zillow\/constellation/],
      },
    },
  },
});
```

## Update CI config

To ensure your pipeline jobs can execute scripts that rely on the `./styled-system` directory, it must be available. If the directory is not present, you will receive an error such as `Could not locate module @/styled-system/css mapped as:`.

The most common method is by extending the predefined `zillow/fit/frontend-cicd-pipeline` template. Configure the `npm_install` job to include `./styled-system` in its artifacts:

```yaml
# .gitlab-ci.yml
include:
  - project: 'zillow/fit/frontend-cicd-pipeline'
    file: 'npm-package.yml'

npm_install:
  stage: install
  extends: .npm-install
  artifacts:
    paths:
      - node_modules/
      - styled-system/
```

Alternatively, confirm that the `./styled-system` directory is either transferred between jobs via artifacts or regenerated following each dependency installation process.

## Update Docker config

```dockerfile
# Copy build configuration files.
COPY panda.config.ts .
COPY postcss.config.cjs .

# Generate Panda CSS styles
# Use the command you set up in package.json to trigger `panda codegen --clean`
RUN npm run prepare

# ...test

# ...build
```
