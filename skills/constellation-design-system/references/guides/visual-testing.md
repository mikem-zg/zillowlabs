# Visual Testing

## Overview

This project uses Percy for automated visual regression testing of our component library. Percy integrates with our existing Cypress component tests to capture visual snapshots and detects visual changes before they reach production.

## How it works

1. **Screenshot Capture** - Percy captures visual snapshots during Cypress component tests
2. **Baseline Comparison** - New snapshots are compared against the target branch baseline
3. **Change Detection** - Visual differences are highlighted and flagged for review
4. **Approval Workflow** - Changes require approval through Percy dashboard or auto-approval via branch patterns

## Usage

### Environment configuration

Create a `.env.local` file in the project root and add your Percy token:

```
PERCY_TOKEN=your_percy_token_here
```

### Running Percy tests locally

```bash
pnpm --filter=@apps/cypress test:e2e:percy

# Run specific component visual tests
pnpm --filter=@apps/cypress test:e2e:percy:file "src/tests/components/button.cy.tsx"
```

### Writing Percy tests

Percy integrates seamlessly with existing Cypress component tests. You should consider adding `cy.percySnapshot()` to your tests when an `it` block represents a visual difference.

```tsx
// button.cy.tsx
describe('Button Component', () => {
  it('renders correctly', () => {
    mount(<Button>Click me</Button>);
    cy.percySnapshot();
  });
});
```
