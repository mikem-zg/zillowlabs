# Production Tech Stack

Constellation is built for speed, resilience, and delight — at scale. This guide highlights the tools and choices that power the `@zillow/constellation` package in production.

## Core runtime dependencies

### UI and interaction libraries

- **@floating-ui/react** - Powers floating UI components like tooltips, popovers, and dropdowns with intelligent positioning
- **@radix-ui/react-slot** - Provides the slot pattern for flexible component composition and prop forwarding
- **react-swipeable** - Adds touch gesture support for swipeable components and interactions

### Animation and visual effects

- **@react-spring/web** - Handles smooth animations and transitions throughout the component library with physics-based animations

### Icons and assets

- **@zillow/constellation-icons** - Comprehensive icon library with optimized SVG icons for all Constellation components

### Date and time utilities

- **date-fns** - Modern JavaScript date utility library for date formatting and manipulation in date picker components

### Development and maintenance utilities

- **chalk** - Terminal string styling for CLI tools and build scripts
- **semver** - Semantic version parsing and comparison for package compatibility
- **update-notifier** - Notifies users when new versions are available

## Peer dependencies

These dependencies must be provided by the consuming application:

- **@pandacss/dev** - Panda CSS build system for generating styles
- **react ^18 || ^19** - React framework with broad version compatibility
- **react-dom ^18 || ^19** - React DOM rendering with matching version support

## Styling architecture

### Panda CSS integration

Constellation uses Panda CSS as its styling solution, providing:

- **Atomic CSS generation** - Generates only the CSS classes you use
- **Type-safe styling** - TypeScript integration for style props
- **Design token integration** - Direct access to design system tokens
- **Theme support** - Built-in theming capabilities

### Build-time optimization

- **Build manifest generation** - Creates `panda-constellation.buildinfo.json` for optimal CSS extraction
- **Tree shaking support** - `"sideEffects": false` enables dead code elimination
- **ESM module format** - Modern ES modules for better bundling and performance

## Build and bundling

### Build tools

- **Rslib and Rsbuild** - Fast build tools for packages and applications
- **@rsbuild/plugin-react** - React support with fast refresh and JSX transformation

### TypeScript configuration

- **TypeScript** - Full type safety with strict configuration
- **@types/react** and **@types/react-dom** - React type definitions

### Output format

The package is built as:

- **ES modules** - Modern module format for optimal tree shaking
- **TypeScript declarations** - Complete type definitions for TypeScript consumers

## React compatibility

Constellation is compatible with React 18 and 19.

## Performance optimizations

### Bundle size

- **Tree shaking enabled** - Only import what you use
- **No side effects** - Enables aggressive dead code elimination
- **Modular architecture** - Import individual components to minimize bundle size
- **Optimized dependencies** - Carefully selected dependencies for minimal footprint

### Runtime performance

- **Optimized re-renders** - Components designed to minimize unnecessary re-renders
- **Efficient animations** - react-spring provides performant, physics-based animations
- **Smart positioning** - Floating UI optimizes tooltip and popover positioning

### CSS performance

- **Atomic CSS** - Minimal CSS output with maximum reusability
- **Theme optimization** - Efficient theme switching

## Browser support

Constellation targets modern browsers with:

- **ES2020+ syntax** - Modern JavaScript features for optimal performance
- **Modern CSS features** - CSS Grid, Flexbox, and custom properties
