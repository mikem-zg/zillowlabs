# Accessibility Testing Guide

Automated testing catches ~40% of accessibility issues. Combine with manual keyboard and screen reader testing for comprehensive coverage.

## Testing Pyramid

| Layer | Coverage | Tools | What It Catches |
|-------|----------|-------|-----------------|
| Unit tests (jest-axe) | ~30-40% | jest-axe, @testing-library/react | Missing labels, ARIA violations, semantic issues |
| Integration tests | ~50% | axe-playwright, cypress-axe | Full-page violations, focus management |
| Manual testing | ~90%+ | Screen readers, keyboard | Usability, reading order, focus flow, announcement quality |

## Unit Testing with jest-axe

### Setup
```bash
npm install --save-dev jest-axe @types/jest-axe
```

```ts
// jest.setup.ts
import 'jest-axe/extend-expect';
```

### Basic Component Test
```tsx
import { render } from '@testing-library/react';
import { axe } from 'jest-axe';

test('Button has no accessibility violations', async () => {
  const { container } = render(<Button>Click me</Button>);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

### Testing Multiple States
```tsx
describe('Accordion accessibility', () => {
  it('accessible when collapsed', async () => {
    const { container } = render(<Accordion />);
    expect(await axe(container)).toHaveNoViolations();
  });

  it('accessible when expanded', async () => {
    const { container } = render(<Accordion defaultOpen />);
    expect(await axe(container)).toHaveNoViolations();
  });
});
```

### Testing After User Interaction
```tsx
import userEvent from '@testing-library/user-event';

test('modal accessible after opening', async () => {
  const { container } = render(<App />);
  await userEvent.click(screen.getByRole('button', { name: /open/i }));
  expect(await axe(container)).toHaveNoViolations();
});
```

### Custom Configuration
```tsx
import { configureAxe } from 'jest-axe';

const axe = configureAxe({
  rules: {
    'region': { enabled: false }, // Disable for isolated component tests
  },
});
```

### Common Gotchas
- jest-axe doesn't work with `jest.useFakeTimers()` — call `jest.useRealTimers()` before axe
- Color contrast checks don't work in JSDOM (no computed styles)
- Use `baseElement` instead of `container` for components using React portals
- Increase timeout for complex components: `jest.setTimeout(10000)`

## Integration Testing with axe-playwright

### Setup
```bash
npm install --save-dev @axe-core/playwright
```

### Full Page Test
```ts
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test('homepage has no accessibility violations', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page }).analyze();
  expect(results.violations).toEqual([]);
});
```

### Scoped to Component
```ts
test('search form is accessible', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page })
    .include('#search-form')
    .analyze();
  expect(results.violations).toEqual([]);
});
```

### Target WCAG 2.2 AA
```ts
const results = await new AxeBuilder({ page })
  .withTags(['wcag2a', 'wcag2aa', 'wcag22aa'])
  .analyze();
```

## Lighthouse Accessibility Audit

### Chrome DevTools
1. Open DevTools (F12)
2. Go to Lighthouse tab
3. Check "Accessibility"
4. Click "Analyze page load"

### CLI
```bash
npx lighthouse https://localhost:5000 --only-categories=accessibility --output=json
```

### CI/CD Integration
```json
{
  "ci": {
    "collect": { "url": ["http://localhost:5000"] },
    "assert": {
      "assertions": {
        "categories:accessibility": ["error", { "minScore": 0.9 }]
      }
    }
  }
}
```

### Limitations
- Lighthouse uses axe-core but runs a limited rule set
- A 100% Lighthouse score does NOT mean the site is fully accessible
- Cannot assess quality of alt text, reading order, or keyboard usability
- Always supplement with axe DevTools and manual testing

## Constellation Accessibility Reporting

Constellation uses automated axe-playwright scanning against Storybook. See the constellation-design-system skill's `references/guides/accessibility-reporting.md` for the full workflow:

```bash
pnpm --filter=@apps/storybook test:a11y
```

This generates `apps/storybook/a11y/report.md` with violation summaries and component-specific breakdowns.

## Manual Testing

### Keyboard Testing (5 minutes)
1. Unplug or ignore your mouse
2. Press Tab — can you reach every interactive element?
3. Is focus visible on each element?
4. Can you activate buttons with Enter/Space?
5. Can you navigate dropdowns/tabs with arrow keys?
6. Can you close modals/popups with Escape?
7. Can you skip repeated navigation with skip links?
8. Are there any keyboard traps (can't tab away)?
9. Is the tab order logical (matches visual reading order)?

### Screen Reader Testing
| Screen Reader | OS | Market Share |
|-------------- |-----|-------------|
| NVDA | Windows | ~30% |
| JAWS | Windows | ~40% |
| VoiceOver | macOS/iOS | ~25% |
| TalkBack | Android | ~5% |

#### VoiceOver Quick Start (macOS)
- Enable: Cmd+F5
- Navigate: VO keys (Ctrl+Option) + Arrow keys
- Read next: VO + Right Arrow
- Interact: VO + Shift + Down Arrow (enter group)
- Headings: VO + Cmd + H
- Links: VO + Cmd + L
- Form controls: VO + Cmd + J

#### NVDA Quick Start (Windows)
- Enable: Ctrl+Alt+N
- Navigate: Arrow keys in browse mode
- Switch to focus mode: NVDA+Space or Enter
- Headings: H
- Links: K
- Form controls: F
- Landmarks: D

### Color Contrast Testing
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- Normal text: 4.5:1 minimum
- Large text (18pt+ or 14pt+ bold): 3:1 minimum
- UI components and graphical objects: 3:1 minimum

### Browser Extensions
| Tool | Best For |
|------|----------|
| axe DevTools | Comprehensive automated testing, zero false positives |
| WAVE | Visual overlay showing issues in context |
| Accessibility Insights (Microsoft) | FastPass for high-impact issues in <5 min |

## Testing Checklist by Phase

### During Development
- [ ] Run jest-axe on every new component
- [ ] Keyboard-navigate through all interactive states
- [ ] Verify focus indicators are visible (2px, 3:1 contrast)
- [ ] Check all images have appropriate alt text
- [ ] Verify form labels and error messages

### Before PR/MR
- [ ] Run full axe-playwright scan on affected pages
- [ ] Test with at least one screen reader
- [ ] Verify focus management on route changes and modals
- [ ] Check color contrast on all text and UI elements
- [ ] Verify touch targets are at least 24×24px

### Before Release
- [ ] Full Lighthouse accessibility audit (target 90+)
- [ ] Complete keyboard walkthrough of critical user flows
- [ ] Screen reader test of primary user journeys
- [ ] Verify at 200% and 400% zoom
- [ ] Test with `prefers-reduced-motion: reduce`

## Resources
- [axe-core rule descriptions](https://github.com/dequelabs/axe-core/blob/develop/doc/rule-descriptions.md)
- [Deque University](https://dequeuniversity.com/)
- [WebAIM Screen Reader Survey](https://webaim.org/projects/screenreadersurvey10/)
- [Accessibility Insights](https://accessibilityinsights.io/)
