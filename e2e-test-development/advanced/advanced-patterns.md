## Advanced E2E Testing Patterns and Implementation

### Comprehensive E2E Testing Workflow

When invoked, execute this comprehensive E2E testing workflow:

#### 1. Test Analysis and Planning
**Determine E2E Requirements:**
- Analyze target user journey to identify critical interaction paths
- Map business workflow steps to testable user actions
- Identify cross-browser compatibility requirements
- Coordinate with frontend component test IDs for reliable element selection

#### 2. Test Implementation Patterns
**Create E2E Tests Following FUB Patterns:**
- **User Journey Tests**: Complete end-to-end workflows (login → search → contact → conversion)
- **Cross-Browser Tests**: Verify functionality across Chromium, Firefox, and WebKit
- **Mobile Responsive Tests**: Test mobile viewport behaviors and touch interactions
- **Performance Tests**: Measure page load times and interaction responsiveness
- **Accessibility Tests**: Verify WCAG compliance and keyboard navigation

#### 3. Test Execution and Reporting
**Run Tests in FUB Playwright Environment:**
- Execute tests against specified environment (staging/development)
- Generate detailed test reports with screenshots and traces
- Capture performance metrics and accessibility audit results
- Coordinate with CI/CD pipeline for automated execution

### FUB-Specific E2E Patterns

#### User Journey Test Structure
- Implement complete workflows with realistic user interactions
- Use `data-testid` selectors for reliable element targeting
- Test authentication flows and user role permissions
- Validate business logic and data persistence

#### Cross-Browser Testing Configuration
- Configure Playwright for Chromium, Firefox, and WebKit browsers
- Test responsive design across different viewport sizes
- Validate JavaScript functionality in various browser environments
- Handle browser-specific differences and capabilities

#### Performance and Accessibility Testing
- Monitor Core Web Vitals and page load performance
- Test WCAG compliance and screen reader compatibility
- Validate keyboard navigation and focus management
- Capture performance metrics across different browsers

#### Data-Driven Testing with Fixtures
- Use JSON fixtures for consistent test data across runs
- Test with various data sets and edge cases
- Validate form handling and data validation
- Test internationalization and localization features

#### Visual Regression Testing
- Capture and compare screenshots across test runs
- Test UI consistency across browsers and devices
- Validate design system implementation
- Monitor visual changes and regressions

### FUB Playwright Repository Integration

**Repository Structure:**
```bash
fub-playwright/
├── tests/
│   ├── auth/           # Authentication tests
│   ├── contacts/       # Contact management
│   ├── properties/     # Property search
│   └── regression/     # Visual regression
├── fixtures/
│   ├── users.json      # Test user accounts
│   └── properties.json # Sample data
├── utils/
│   ├── auth-helpers.js # Authentication utilities
│   └── test-data.js    # Data generation
└── playwright.config.js
```

**Integration Points:**
- Coordinate with `fub-playwright` repository structure
- Maintain consistent test organization and naming conventions
- Integrate with GitLab CI/CD pipelines for automated testing
- Coordinate selector strategies with frontend component tests

### Environment Configuration and CI/CD Integration

**Multi-Environment Setup:**
- Configure test environments (staging, development, production-like)
- Manage test data and user accounts across environments
- Handle environment-specific configurations and API endpoints
- Integrate with GitLab CI for automated test execution

### Advanced Test Execution Patterns

#### Parallel Test Execution
```javascript
// Advanced parallel configuration
export default defineConfig({
  workers: process.env.CI ? 4 : 8,
  fullyParallel: true,
  projects: [
    {
      name: 'smoke-tests',
      testMatch: '**/smoke.spec.js',
      fullyParallel: true
    },
    {
      name: 'regression-tests',
      testMatch: '**/regression.spec.js',
      dependencies: ['smoke-tests']
    }
  ]
});
```

#### Test Retry and Resilience
```javascript
// Smart retry configuration
export default defineConfig({
  retries: process.env.CI ? 2 : 0,
  use: {
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  }
});
```

#### Custom Test Fixtures
```javascript
// Advanced fixture patterns
const test = baseTest.extend({
  authenticatedAgent: async ({ browser }, use) => {
    const context = await browser.newContext({
      storageState: 'auth/agent-state.json'
    });
    const page = await context.newPage();
    await use(page);
    await context.close();
  },

  testProperty: async ({}, use) => {
    const property = await createTestProperty();
    await use(property);
    await cleanupTestProperty(property.id);
  }
});
```

### Performance Testing Patterns

#### Core Web Vitals Monitoring
```javascript
test('measures Core Web Vitals', async ({ page }) => {
  await page.goto('/dashboard');

  const metrics = await page.evaluate(() => {
    return new Promise((resolve) => {
      new PerformanceObserver((list) => {
        const entries = list.getEntries();
        resolve({
          lcp: entries.find(entry => entry.entryType === 'largest-contentful-paint'),
          fid: entries.find(entry => entry.entryType === 'first-input'),
          cls: entries.find(entry => entry.entryType === 'layout-shift')
        });
      }).observe({ entryTypes: ['largest-contentful-paint', 'first-input', 'layout-shift'] });
    });
  });

  expect(metrics.lcp?.value).toBeLessThan(2500);
});
```

#### Network Performance Testing
```javascript
test('optimizes network requests', async ({ page }) => {
  const responses = [];
  page.on('response', response => responses.push(response));

  await page.goto('/search');
  await page.waitForLoadState('networkidle');

  const slowRequests = responses.filter(r => r.timing()?.responseEnd > 1000);
  expect(slowRequests.length).toBeLessThan(3);
});
```

### Accessibility Testing Patterns

#### Comprehensive A11y Validation
```javascript
test('validates comprehensive accessibility', async ({ page }) => {
  await page.goto('/contacts/new');

  // Run axe-core accessibility scan
  const results = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa'])
    .analyze();

  expect(results.violations).toEqual([]);

  // Test keyboard navigation
  await page.keyboard.press('Tab');
  const focusedElement = await page.locator(':focus');
  await expect(focusedElement).toBeVisible();
});
```

#### Screen Reader Compatibility
```javascript
test('supports screen readers', async ({ page }) => {
  await page.goto('/dashboard');

  // Check ARIA labels and roles
  const landmarks = await page.locator('[role="main"], [role="navigation"], [role="banner"]');
  await expect(landmarks).toHaveCount(3);

  // Verify heading structure
  const headings = await page.locator('h1, h2, h3, h4, h5, h6');
  const headingLevels = await headings.evaluateAll(elements =>
    elements.map(el => parseInt(el.tagName.charAt(1)))
  );

  // Ensure proper heading hierarchy
  expect(headingLevels[0]).toBe(1);
});
```

### Mobile Testing Patterns

#### Responsive Design Validation
```javascript
test('validates mobile responsive design', async ({ page }) => {
  // Test different viewport sizes
  const viewports = [
    { width: 375, height: 667 }, // iPhone SE
    { width: 390, height: 844 }, // iPhone 12
    { width: 428, height: 926 }  // iPhone 12 Pro Max
  ];

  for (const viewport of viewports) {
    await page.setViewportSize(viewport);
    await page.goto('/search');

    // Verify mobile navigation
    await expect(page.getByTestId('mobile-menu-button')).toBeVisible();

    // Test touch interactions
    await page.getByTestId('mobile-menu-button').tap();
    await expect(page.getByTestId('mobile-navigation')).toBeVisible();
  }
});
```

#### Touch Interaction Testing
```javascript
test('handles touch interactions', async ({ page }) => {
  await page.goto('/properties/123');

  // Test swipe gestures on property images
  const carousel = page.getByTestId('property-carousel');
  await carousel.hover();

  // Simulate swipe left
  await page.mouse.down();
  await page.mouse.move(100, 0);
  await page.mouse.up();

  // Verify carousel moved
  await expect(page.getByTestId('carousel-indicator')).toContainText('2 of 10');
});
```

### Test Data Management

#### Dynamic Test Data Generation
```javascript
// Test data factory
class TestDataFactory {
  static createContact(overrides = {}) {
    return {
      name: faker.name.fullName(),
      email: faker.internet.email(),
      phone: faker.phone.number(),
      address: faker.address.streetAddress(),
      ...overrides
    };
  }

  static createProperty(overrides = {}) {
    return {
      address: faker.address.streetAddress(),
      price: faker.datatype.number({ min: 100000, max: 1000000 }),
      bedrooms: faker.datatype.number({ min: 1, max: 6 }),
      bathrooms: faker.datatype.number({ min: 1, max: 4 }),
      ...overrides
    };
  }
}
```

#### Test Data Cleanup
```javascript
// Cleanup utilities
class TestDataCleanup {
  static async cleanupContacts(testRun) {
    const contacts = await getContactsByTestRun(testRun);
    for (const contact of contacts) {
      await deleteContact(contact.id);
    }
  }

  static async cleanupProperties(testRun) {
    const properties = await getPropertiesByTestRun(testRun);
    for (const property of properties) {
      await deleteProperty(property.id);
    }
  }
}
```

### Advanced Debugging and Troubleshooting

#### Debug Configuration
```javascript
// Enhanced debugging setup
export default defineConfig({
  use: {
    trace: process.env.DEBUG ? 'on' : 'retain-on-failure',
    video: process.env.DEBUG ? 'on' : 'retain-on-failure',
    screenshot: process.env.DEBUG ? 'on' : 'only-on-failure'
  }
});
```

#### Test Execution Commands
- `npm run test:e2e` - Run all tests
- `npm run test:e2e -- --project=chromium` - Browser-specific
- `npm run test:e2e -- --debug` - Debug mode
- `npm run test:e2e -- --headed` - Visible browser
- `npx playwright show-report` - View results
- `npx playwright show-trace test-results/trace.zip` - View trace

This comprehensive guide provides advanced patterns for implementing robust, maintainable E2E tests that align with FUB's quality standards and development practices.