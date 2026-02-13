---
name: e2e-test-development
description: Develop comprehensive end-to-end tests for FUB's web application using Playwright with cross-browser testing and user journey validation
---

## Examples

```bash
# Test complete user authentication flow with comprehensive browser coverage
/e2e-test-development --target="user-authentication" --browser="all" --test_type="user-journey" --environment="staging"

# Test property search functionality with mobile responsive design validation
/e2e-test-development --target="property-search" --browser="webkit" --test_type="regression" --mobile_testing=true

# Performance testing for contact management across browsers
/e2e-test-development --target="contact-management" --browser="all" --test_type="performance" --environment="staging"

# Accessibility compliance testing for navigation components
/e2e-test-development --target="navigation-accessibility" --browser="chromium" --test_type="accessibility" --environment="development"

# Cross-browser user registration flow testing
/e2e-test-development --target="user-registration" --browser="all" --test_type="user-journey" --environment="development"
```

## Overview

Develop comprehensive end-to-end tests for FUB's web application using Playwright with cross-browser testing and user journey validation. Create, execute, and maintain Playwright end-to-end tests covering complete user journeys, cross-browser compatibility, mobile responsiveness, and accessibility compliance for critical business workflows.

🧪 **Test Templates**: [templates/test-templates.md](templates/test-templates.md)
🚀 **Advanced Patterns**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
🔗 **Integration Workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)
📋 **Testing Standards**: [reference/testing-standards.md](reference/testing-standards.md)

## Usage

```bash
/e2e-test-development --target=<journey_or_feature> [--browser=<browser_type>] [--test_type=<type>] [--environment=<env>] [--mobile_testing=<bool>]
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Basic User Journey Testing**
```bash
# Test complete user authentication flow
e2e-test-development --target="user-authentication" --browser="chromium" --environment="staging"

# Test property search workflow
e2e-test-development --target="property-search" --browser="all" --test_type="user-journey"

# Test contact management features
e2e-test-development --target="contact-management" --browser="chromium" --environment="development"
```

**2. Cross-Browser and Device Testing**
```bash
# Test across all browsers (chromium, firefox, webkit)
e2e-test-development --target="user-registration" --browser="all" --test_type="regression"

# Test mobile responsive design
e2e-test-development --target="property-details" --mobile_testing=true --browser="webkit"

# Performance testing across browsers
e2e-test-development --target="search-performance" --test_type="performance" --browser="all"
```

**3. Regression and Accessibility Testing**
```bash
# Run regression tests for critical workflows
e2e-test-development --target="payment-processing" --test_type="regression" --environment="staging"

# Test accessibility compliance
e2e-test-development --target="navigation-accessibility" --test_type="accessibility" --browser="chromium"
```

### Preconditions

- Must have access to FUB Playwright E2E repository (`gitlab.zgtools.net/fub/fub-playwright/`)
- Must have Playwright installed with browser binaries (Chromium, Firefox, WebKit)
- Must have access to appropriate test environments (staging, development)
- Must verify component test IDs are compatible with frontend unit tests
- Must have authentication test accounts configured for different user roles
- Must have test data fixtures available for consistent E2E scenarios

## Quick Reference

### Common FUB Test Types

| Test Type | Purpose | Browser Coverage | Environment |
|-----------|---------|------------------|-------------|
| `user-journey` | Complete workflow testing | Single browser (chromium) | Staging |
| `regression` | Feature stability verification | All browsers | Staging |
| `performance` | Load time and responsiveness | Chromium + WebKit | Staging |
| `accessibility` | WCAG compliance validation | Chromium | Development |
| `mobile` | Responsive design testing | WebKit (mobile) | Staging |

→ **Complete testing standards**: [reference/testing-standards.md](reference/testing-standards.md)

### Basic Test Template

```javascript
import { test, expect } from '@playwright/test';

test.describe('User Authentication', () => {
  test('should allow user to login successfully', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', 'test@fub.com');
    await page.fill('[data-testid="password-input"]', 'password123');
    await page.click('[data-testid="login-button"]');

    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();
  });
});
```

→ **Complete test templates and configurations**: [templates/test-templates.md](templates/test-templates.md)

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| **Flaky tests due to timing** | Use `waitFor` and proper selectors instead of `wait(timeout)` |
| **Element not found** | Verify `data-testid` attributes match between frontend and E2E tests |
| **Cross-browser differences** | Use browser-specific configurations and conditional logic |
| **Authentication state** | Use `storageState` to persist login across tests |
| **Test data cleanup** | Implement proper `beforeEach`/`afterEach` hooks |

→ **Complete troubleshooting guide**: [reference/testing-standards.md](reference/testing-standards.md)

## Integration Patterns

### Cross-Skill Workflow Integration

**Frontend Testing → E2E Testing:**
```bash
# Coordinate test IDs between component and E2E tests
frontend-test-development --target="LoginForm.jsx" --include_snapshots=true |
  e2e-test-development --target="user-authentication" --browser="all"
```

**Backend Testing → E2E Testing:**
```bash
# Ensure API endpoints work before E2E testing
backend-test-development --target="AuthController" --test_type="api" |
  e2e-test-development --target="user-authentication" --environment="staging"
```

**Support Investigation → E2E Testing:**
```bash
# Create E2E tests to reproduce reported user issues
support-investigation identify_user_workflow_issue |
  e2e-test-development --target="reported-workflow" --test_type="regression" --browser="all"
```

### Related Skills Integration

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `frontend-test-development` | **Test ID Coordination** | Ensure `data-testid` consistency, component behavior validation |
| `backend-test-development` | **API Contract Testing** | Validate end-to-end data flows, coordinate API endpoint testing |
| `support-investigation` | **Issue Reproduction** | Create E2E tests to reproduce reported user journey issues |
| `gitlab-pipeline-monitoring` | **CI/CD Integration** | Manage E2E test pipeline execution, coordinate with MR workflows |
| `datadog-management` | **Performance Monitoring** | Monitor E2E test execution performance, identify bottlenecks |

→ **Complete integration workflows**: [workflows/integration-workflows.md](workflows/integration-workflows.md)

### Multi-Skill Operation Example

**Complete E2E Feature Testing Workflow:**
1. `frontend-test-development` - Ensure component-level test coverage and proper test IDs
2. `backend-test-development` - Validate API endpoints support required user journeys
3. `e2e-test-development` - Create comprehensive user journey tests
4. `gitlab-pipeline-monitoring` - Configure CI/CD pipeline for automated E2E execution
5. `datadog-management` - Monitor test execution performance and user experience metrics

## Testing Standards Enforcement

- **Test ID Consistency**: Use `data-testid` attributes matching frontend component patterns
- **User Journey Focus**: Test complete business workflows rather than isolated interactions
- **Cross-Browser Coverage**: Verify functionality across Chromium, Firefox, and WebKit
- **Performance Thresholds**: Monitor and assert page load times and interaction responsiveness
- **Accessibility Compliance**: Include WCAG validation and keyboard navigation testing
- **Visual Regression**: Maintain screenshot baselines for critical UI components
- **Mobile Responsiveness**: Test mobile viewport behaviors and touch interactions
- **Test Data Management**: Use consistent fixtures and cleanup procedures

→ **Complete testing standards**: [reference/testing-standards.md](reference/testing-standards.md)

## Refusal Conditions

The skill must refuse if:
- FUB Playwright repository (gitlab.zgtools.net/fub/fub-playwright/) is not accessible
- Playwright is not installed or browser binaries are unavailable
- Target test environment (staging/development) is not accessible or properly configured
- Test user accounts are not configured or credentials are unavailable
- Component test IDs are not documented or coordinated with frontend team
- Required test data fixtures are not available or improperly configured
- CI/CD pipeline integration requirements cannot be met

When refusing, explain which requirement prevents execution and provide specific steps to resolve the issue, including repository access setup, Playwright installation commands, environment configuration requirements, or test data preparation procedures.

## Supporting Infrastructure

→ **Advanced testing patterns and implementations**: [advanced/advanced-patterns.md](advanced/advanced-patterns.md)
→ **Comprehensive test templates and configurations**: [templates/test-templates.md](templates/test-templates.md)

This skill provides comprehensive E2E testing capabilities for FUB's web application while maintaining seamless integration with the broader development and quality assurance ecosystem.