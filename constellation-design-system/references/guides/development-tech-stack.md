# Development Tech Stack

Constellation uses a modern toolchain for fast, type-safe development across a shared monorepo. This guide outlines the core tooling and daily workflows.

For guidance on interacting with specific packages, see the following documents:

- `@zillow/constellation`
- `@zillow/constellation-config`
- `@zillow/constellation-fonts`
- `@zillow/constellation-icons`
- `@zillow/constellation-tokens`

## Core technologies

### Monorepo management

- **Turbo** - Build orchestration and task running across the monorepo
- **pnpm** - Fast, efficient package management with workspace support
- **pnpm workspaces** - Manages dependencies between packages and applications

### Build & bundling

- **Rslib and Rsbuild** - Fast build tools for packages and applications
- **TypeScript** - Type safety across the entire codebase

### Testing framework

- **Vitest** - Unit testing with fast execution and great TypeScript support
- **Cypress** - Component and end-to-end testing in real browsers
- **Coverage reporting** - Comprehensive test coverage tracking

### Code quality

- **oxlint** - Code linting with custom rules for consistency
- **Prettier** - Code formatting for consistent style
- **commitlint** - Ensures conventional commit message format

### Version management

- **Changesets** - Manages versioning and changelog generation

## Development workflows

### Everyday component work — fast and focused

```bash
# 1. Install and scaffold apps
pnpm i && pnpm scaffold:apps

# 2. Start Storybook for component development
pnpm run --filter @apps/storybook dev

# 3. Run tests (choose your preference):
# Option A: Watch mode for continuous feedback
pnpm run test:unit:watch
# Option B: Run specific test files as needed
pnpm run test:unit /path/to/test

# 4. Run e2e tests before deploying commit
pnpm run test:e2e
```

**When to re-scaffold apps:**

You'll need to re-run the scaffold command when:

- **PandaCSS version updates** - The scaffold process generates PandaCSS mappings required for token testing
- **New team member setup** - First time setup after cloning the repository
- **Styling issues** - If you notice missing styles or token resolution problems

```bash
# Re-scaffold when PandaCSS updates or after dependency changes
pnpm run scaffold:apps
```

If you are wanting to test changes in Next.js apps or the Token Explorer, you can do so by running the following commands:

```bash
# Token development workflow - for editing design tokens
pnpm run --filter @zillow/constellation-tokens dev

# Next.js app testing workflow - for testing components in full applications
pnpm run --filter @apps/next-15-react-19 dev
# or pnpm run --filter @apps/next-14-react-18 dev
```

### Pre-commit checks — catch issues before CI does

Run these commands before committing to ensure code quality:

```bash
# Auto-fix linting issues
pnpm run lint:fix

# Auto-fix code formatting
pnpm run format:fix

# Verify TypeScript compilation
pnpm run typecheck:packages && pnpm run typecheck:apps

# Test only changed files
pnpm run test:unit:file
```

**Why these specific commands:**

- **Fast** – Under 1 minute
- **Automatic** – Fixes lint and format issues for you
- **Targeted** – Only runs what's relevant
- **CI-friendly** – Fewer broken builds

### Integration testing workflow

For testing changes across different React versions and frameworks:

```bash
# Build packages first
pnpm run build:packages

# Test in Next.js 15 + React 19
pnpm run --filter @apps/next-15-react-19 dev

# or pnpm run --filter @apps/next-14-react-18 dev
```

## Key development tools

### Storybook

Primary development environment for building and testing components in isolation. Provides:

- Live component playground
- Interactive documentation
- Visual regression testing capabilities
- Addon ecosystem for enhanced development

### Token Explorer

Interactive tool for browsing and understanding design tokens:

- Visual token browser
- Token relationships and dependencies
- Integration with Figma design files

## Development environment conventions

### Package filtering

pnpm provides powerful filtering capabilities:

```bash
# Run commands for specific packages
pnpm run --filter @apps/storybook dev
pnpm run --filter packages/constellation build

# Run commands for multiple packages
pnpm run --filter "@apps/*" build
```

### Fast feedback with watch mode

Most scripts support watch mode for immediate feedback:

```bash
# Unit tests in watch mode
pnpm run test:unit:watch

# Type checking in watch mode
pnpm run typecheck:packages --watch

# File-specific test watching
pnpm run test:unit:file:watch
```
