## Testing Standards and Reference Guide

### Common FUB Test Types Matrix

| Test Type | Purpose | Browser Coverage | Environment |
|-----------|---------|------------------|-------------|
| `user-journey` | Complete workflow testing | Single browser (chromium) | Staging |
| `regression` | Feature stability verification | All browsers | Staging |
| `performance` | Load time and responsiveness | Chromium + WebKit | Staging |
| `accessibility` | WCAG compliance validation | Chromium | Development |
| `mobile` | Responsive design testing | WebKit (mobile) | Staging |

### Test Data and Fixtures Reference

| Fixture Type | Usage | Location |
|-------------|-------|----------|
| **User Accounts** | Authentication testing | `fixtures/users.json` |
| **Property Data** | Search and listing tests | `fixtures/properties.json` |
| **Contact Data** | CRM workflow testing | `fixtures/contacts.json` |
| **API Responses** | Mock server data | `fixtures/api-responses/` |

### Common Playwright Commands Reference

| Operation | Command | Purpose |
|-----------|---------|---------|
| **Run All Tests** | `npx playwright test` | Execute complete test suite |
| **Run Specific Browser** | `npx playwright test --project=chromium` | Test single browser |
| **Run Mobile Tests** | `npx playwright test --project=mobile-chrome` | Mobile device testing |
| **Debug Mode** | `npx playwright test --debug` | Interactive debugging |
| **Generate Report** | `npx playwright show-report` | View test results |
| **Run with Trace** | `npx playwright test --trace on` | Generate execution trace |
| **Run Headed** | `npx playwright test --headed` | Visible browser execution |
| **Run Specific Test** | `npx playwright test auth.spec.js` | Run single test file |

### Common Issues and Solutions Guide

| Issue | Solution |
|-------|----------|
| **Flaky tests due to timing** | Use `waitFor` and proper selectors instead of `wait(timeout)` |
| **Element not found** | Verify `data-testid` attributes match between frontend and E2E tests |
| **Cross-browser differences** | Use browser-specific configurations and conditional logic |
| **Authentication state** | Use `storageState` to persist login across tests |
| **Test data cleanup** | Implement proper `beforeEach`/`afterEach` hooks |
| **Slow test execution** | Optimize selectors, reduce unnecessary waits, use parallel execution |
| **Screenshot differences** | Use consistent viewport sizes and wait for content to load |
| **Network issues** | Implement retry logic and proper network waiting |

### Testing Standards Enforcement

#### Test ID Consistency Standards
- **Use `data-testid` attributes** matching frontend component patterns
- **Naming convention**: `component-action-element` (e.g., `login-form-submit`)
- **Coordinate with frontend team** to ensure consistent test ID implementation
- **Avoid CSS selectors** or text-based selectors that can break with UI changes

#### User Journey Focus Standards
- **Test complete business workflows** rather than isolated interactions
- **Follow realistic user paths** from start to finish
- **Include error scenarios** and edge cases in journey testing
- **Validate business logic** and data persistence throughout workflows

#### Cross-Browser Coverage Standards
- **Chromium**: Primary testing browser for development and CI
- **Firefox**: Secondary browser for cross-browser compatibility
- **WebKit**: Safari compatibility testing, especially for mobile
- **Mobile Chrome/Safari**: Mobile responsiveness and touch interactions

#### Performance Thresholds Standards
- **Page Load Time**: < 3 seconds for initial page load
- **Navigation Time**: < 1 second for page-to-page navigation
- **Form Submission**: < 2 seconds for form processing
- **Search Results**: < 3 seconds for search query execution
- **Image Loading**: Progressive loading with skeleton screens

#### Accessibility Compliance Standards
- **WCAG 2.1 AA compliance** for all public-facing features
- **Keyboard navigation** support for all interactive elements
- **Screen reader compatibility** with proper ARIA labels
- **Color contrast ratios** meeting accessibility guidelines
- **Focus management** for modal dialogs and dynamic content

#### Visual Regression Standards
- **Screenshot baselines** for critical UI components
- **Cross-browser visual consistency** validation
- **Responsive design verification** across viewport sizes
- **Theme consistency** if multiple themes are supported

#### Mobile Responsiveness Standards
- **Viewport testing** across common mobile screen sizes
- **Touch interaction validation** for mobile-specific gestures
- **Mobile navigation patterns** testing
- **Performance optimization** for mobile networks

#### Test Data Management Standards
- **Consistent fixtures** for repeatable test execution
- **Data cleanup procedures** to prevent test interference
- **Environment-specific data** for staging vs. development
- **Sensitive data handling** with proper security measures

### Test Environment Configuration

#### Staging Environment Requirements
```javascript
const stagingConfig = {
  baseURL: 'https://staging.fub.com',
  timeout: 30000,
  retries: 2,
  users: {
    agent: 'test.agent@fub.com',
    admin: 'test.admin@fub.com',
    client: 'test.client@fub.com'
  }
};
```

#### Development Environment Requirements
```javascript
const developmentConfig = {
  baseURL: 'http://localhost:3000',
  timeout: 10000,
  retries: 0,
  users: {
    agent: 'dev.agent@fub.com',
    admin: 'dev.admin@fub.com',
    client: 'dev.client@fub.com'
  }
};
```

### Test Execution Guidelines

#### Pre-Test Checklist
- [ ] Verify test environment is accessible
- [ ] Confirm test data fixtures are available
- [ ] Check authentication credentials are valid
- [ ] Validate frontend deployment matches test requirements
- [ ] Ensure backend services are operational

#### Test Execution Best Practices
- **Run smoke tests first** before comprehensive test suites
- **Execute in consistent environment** to avoid flaky results
- **Monitor test execution time** and optimize slow tests
- **Review test reports** for patterns in failures
- **Maintain test data hygiene** with proper cleanup

#### Post-Test Activities
- **Review test results** and identify failure patterns
- **Update test documentation** for any changes
- **Clean up test data** to prevent environment pollution
- **Report critical issues** discovered during testing
- **Update baseline screenshots** if UI changes are intentional

### Debugging and Troubleshooting

#### Debug Configuration Setup
```javascript
// Enhanced debugging in playwright.config.js
export default defineConfig({
  use: {
    trace: process.env.DEBUG ? 'on' : 'retain-on-failure',
    video: process.env.DEBUG ? 'on' : 'retain-on-failure',
    screenshot: process.env.DEBUG ? 'on' : 'only-on-failure',
    headless: process.env.DEBUG ? false : true
  }
});
```

#### Common Debugging Commands
```bash
# Run specific test with full debug info
npx playwright test auth.spec.js --debug --headed

# Generate trace for failed test
npx playwright test --trace on

# View trace file
npx playwright show-trace test-results/auth-User-Authentication-should-allow-user-to-login-successfully-chromium/trace.zip

# Run test with video recording
npx playwright test --video on

# Interactive mode for test development
npx playwright codegen https://staging.fub.com
```

#### Troubleshooting Flaky Tests
1. **Identify timing issues**: Add appropriate waits for dynamic content
2. **Check element visibility**: Ensure elements are visible before interaction
3. **Validate test data**: Confirm test data is consistent across runs
4. **Review network conditions**: Account for varying response times
5. **Analyze test isolation**: Ensure tests don't interfere with each other

### Quality Metrics and Reporting

#### Test Coverage Metrics
- **User Journey Coverage**: Percentage of critical workflows tested
- **Browser Coverage**: Distribution of tests across browser types
- **Feature Coverage**: Percentage of features with E2E test coverage
- **Error Scenario Coverage**: Percentage of error paths tested

#### Performance Metrics
- **Test Execution Time**: Average time for test suite execution
- **Flaky Test Rate**: Percentage of tests that fail intermittently
- **Browser Performance**: Relative performance across different browsers
- **CI/CD Integration**: Pipeline success rate for E2E tests

#### Quality Standards Checklist
- [ ] All user journeys have comprehensive E2E test coverage
- [ ] Cross-browser testing covers Chromium, Firefox, and WebKit
- [ ] Performance thresholds are monitored and enforced
- [ ] Accessibility compliance is validated through automated testing
- [ ] Visual regression testing maintains UI consistency
- [ ] Mobile responsiveness is tested across device types
- [ ] Test data is properly managed and cleaned up
- [ ] CI/CD integration provides reliable feedback

This comprehensive reference guide ensures consistent, high-quality E2E testing practices aligned with FUB's standards and development workflows.