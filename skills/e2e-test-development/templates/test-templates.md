## Playwright Test Templates and Configuration

### Basic User Journey Test Template

**User Authentication Test:**
```javascript
// File: tests/user-authentication.spec.js
import { test, expect } from '@playwright/test';

test.describe('User Authentication', () => {
  test('should allow user to login successfully', async ({ page }) => {
    // Navigate to login page
    await page.goto('/login');

    // Fill login form
    await page.fill('[data-testid="email-input"]', 'test@fub.com');
    await page.fill('[data-testid="password-input"]', 'password123');

    // Click login button
    await page.click('[data-testid="login-button"]');

    // Verify successful login
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();
  });

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/login');

    await page.fill('[data-testid="email-input"]', 'invalid@email.com');
    await page.fill('[data-testid="password-input"]', 'wrongpassword');
    await page.click('[data-testid="login-button"]');

    await expect(page.locator('[data-testid="error-message"]')).toBeVisible();
    await expect(page.locator('[data-testid="error-message"]')).toContainText('Invalid credentials');
  });
});
```

### Cross-Browser Configuration Template

**Playwright Configuration for FUB:**
```javascript
// playwright.config.js
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
    },
  ],

  webServer: {
    command: 'npm run start:test',
    url: 'http://127.0.0.1:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### Property Search Journey Template

```javascript
test.describe('Property Search Journey', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.getByTestId('login-button').click();
    await page.getByTestId('email-input').fill('test.agent@fub.com');
    await page.getByTestId('password-input').fill('testpass123');
    await page.getByTestId('login-submit').click();
    await expect(page.getByTestId('dashboard-header')).toBeVisible();
  });

  test('complete property search and contact creation', async ({ page }) => {
    await page.getByTestId('property-search-nav').click();
    await expect(page.getByTestId('search-form')).toBeVisible();

    await page.getByTestId('address-input').fill('123 Main Street');
    await page.getByTestId('search-submit').click();

    await expect(page.getByTestId('search-results')).toBeVisible();
    const resultCount = await page.getByTestId('result-item').count();
    expect(resultCount).toBeGreaterThan(0);
  });
});
```

### Authentication and User Role Testing Template

**Multi-Role Test Fixtures:**
```javascript
const test = base.extend({
  agentPage: async ({ browser }, use) => {
    const context = await browser.newContext();
    const page = await context.newPage();
    await page.goto('/login');
    await page.getByTestId('email-input').fill('agent@fub.com');
    await page.getByTestId('password-input').fill('agentpass');
    await page.getByTestId('login-submit').click();
    await page.waitForURL('/dashboard');
    await use(page);
    await context.close();
  }
});
```

### Performance Testing Template

**Performance Monitoring:**
```javascript
test('property search page loads within acceptable time', async ({ page }) => {
  const startTime = Date.now();
  await page.goto('/search');
  await page.waitForLoadState('networkidle');
  const loadTime = Date.now() - startTime;
  expect(loadTime).toBeLessThan(3000); // 3 seconds max
});
```

### Accessibility Testing Template

**Accessibility Validation:**
```javascript
test('contact form meets accessibility standards', async ({ page }) => {
  await page.goto('/contacts/new');
  const accessibilityScanResults = await new AxeBuilder({ page })
    .include('[data-testid="contact-form"]')
    .analyze();
  expect(accessibilityScanResults.violations).toEqual([]);
});
```

### Data-Driven Testing Template

**Test Data Management:**
```javascript
const testProperties = [
  {
    address: '123 Main Street, Anytown USA',
    expectedResults: 5,
    contactEmail: 'john.smith@example.com'
  },
  {
    address: '456 Oak Avenue, Somewhere City',
    expectedResults: 3,
    contactEmail: 'jane.doe@example.com'
  }
];

testProperties.forEach(({ address, expectedResults, contactEmail }) => {
  test(`search for "${address}" returns ${expectedResults} results`, async ({ page }) => {
    await page.goto('/search');
    await page.getByTestId('address-input').fill(address);
    await page.getByTestId('search-submit').click();
    const resultCount = await page.getByTestId('result-item').count();
    expect(resultCount).toBe(expectedResults);
  });
});
```

### Visual Regression Testing Template

**Screenshot Comparison:**
```javascript
test('dashboard layout remains consistent', async ({ page }) => {
  await page.goto('/dashboard');
  await page.waitForLoadState('networkidle');
  await expect(page).toHaveScreenshot('dashboard-layout.png');
});
```

### Environment Configuration Template

**Multi-Environment Configuration:**
```javascript
const config = {
  staging: {
    baseURL: 'https://staging.fub.com',
    timeout: 30000,
    retries: 2
  },
  development: {
    baseURL: 'http://localhost:3000',
    timeout: 10000,
    retries: 0
  },
  production: {
    baseURL: 'https://app.fub.com',
    timeout: 45000,
    retries: 3
  }
};

// Enhanced Playwright Configuration
export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  use: {
    baseURL: process.env.BASE_URL || 'https://staging.fub.com',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    { name: 'Mobile Chrome', use: { ...devices['Pixel 5'] } },
    { name: 'Mobile Safari', use: { ...devices['iPhone 12'] } }
  ]
});
```

### GitLab CI Integration Template

**GitLab CI Configuration:**
```yaml
e2e-tests:
  stage: test
  image: mcr.microsoft.com/playwright:v1.40.0-focal
  script:
    - npm ci
    - npx playwright install
    - npm run test:e2e -- --reporter=junit
  artifacts:
    reports:
      junit: test-results.xml
    paths:
      - test-results/
      - playwright-report/
    when: always
    expire_in: 1 week
  allow_failure: false
```

### Contact Management Workflow Template

```javascript
test.describe('Contact Management Workflow', () => {
  test('create and edit contact journey', async ({ page }) => {
    // Navigate to contacts
    await page.goto('/contacts');
    await expect(page.getByTestId('contacts-header')).toBeVisible();

    // Create new contact
    await page.getByTestId('new-contact-button').click();
    await expect(page.getByTestId('contact-form')).toBeVisible();

    // Fill contact details
    await page.getByTestId('contact-name-input').fill('John Smith');
    await page.getByTestId('contact-email-input').fill('john.smith@example.com');
    await page.getByTestId('contact-phone-input').fill('555-123-4567');

    // Save contact
    await page.getByTestId('save-contact-button').click();
    await expect(page.getByTestId('success-message')).toBeVisible();

    // Verify contact in list
    await expect(page.getByTestId('contact-item')).toContainText('John Smith');
  });
});
```

These templates provide comprehensive starting points for implementing Playwright E2E tests following FUB's patterns and standards.