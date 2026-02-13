---
name: frontend-test-development
description: Develop comprehensive React frontend tests for FUB's SPA application with Jest and React Testing Library
---

## Overview

Develop comprehensive React frontend tests for FUB's SPA application with Jest and React Testing Library. Create, execute, and analyze Jest tests integrating with React Testing Library, MSW for API mocking, snapshot testing, and custom component testing for River state management and Forge design system while maintaining 75% coverage.

## Usage

```bash
/frontend-test-development --target=<component_or_file> [--test_type=<type>] [--coverage_target=<percentage>] [--mock_apis=<bool>] [--include_snapshots=<bool>]
```

# Frontend Test Development

## Examples

```bash
# Test React component with full coverage
/frontend-test-development --target="PropertyCard.jsx" --test_type="unit" --coverage_target=85 --include_snapshots=true

# Test custom hook with API mocking
/frontend-test-development --target="usePropertySearch.js" --test_type="hook" --mock_apis=true --coverage_target=80

# Integration test for complete feature workflow
/frontend-test-development --target="SearchPage.jsx" --test_type="integration" --mock_apis=true --coverage_target=75

# Pure unit test without mocking (utilities/helpers)
/frontend-test-development --target="utils/formatters.js" --test_type="unit" --mock_apis=false --include_snapshots=false

# Snapshot testing for UI consistency
/frontend-test-development --target="ContactCard.jsx" --test_type="snapshot" --include_snapshots=true
```

## Core Workflow

### Essential Operations (Most Common - 90% of Usage)

**1. Basic Component Testing**
```bash
# Test React component with RTL
frontend-test-development --target="PropertyCard.jsx" --test_type="unit" --coverage_target=80

# Test custom hooks
frontend-test-development --target="useZillowAuth.js" --test_type="hook" --mock_apis=true

# Create integration test with API mocking
frontend-test-development --target="SearchResults.jsx" --test_type="integration" --mock_apis=true
```

**2. API Mocking and Integration**
```bash
# Test with MSW API mocking enabled
frontend-test-development --target="UserProfile.jsx" --mock_apis=true --test_type="integration"

# Test without API mocking (pure unit test)
frontend-test-development --target="utilities/formatPrice.js" --mock_apis=false --test_type="unit"
```

**3. Snapshot and Coverage Testing**
```bash
# Generate snapshot tests for UI consistency
frontend-test-development --target="PropertyCard.jsx" --include_snapshots=true --test_type="snapshot"

# Run with specific coverage target
frontend-test-development --target="SearchFilters.jsx" --coverage_target=90 --include_snapshots=true
```

### Preconditions

- Must have access to `fub-spa` testing infrastructure (Jest 26.6.3, React Testing Library v12.1.5)
- Must verify MSW 2.4.7 is configured for API mocking when required
- Must verify test environment setup and browser mocks are configured
- Must have appropriate React 17 and Flow/TypeScript type definitions
- Must have Node.js test environment properly configured

## Quick Reference

### Common FUB Test Types

| Test Type | Purpose | Tools Used | Mock APIs |
|-----------|---------|------------|-----------|
| `unit` | Individual component/function testing | RTL, Jest | Optional |
| `integration` | Multi-component interaction testing | RTL, MSW, Jest | Recommended |
| `snapshot` | UI consistency and regression testing | Jest snapshots | No |
| `hook` | Custom React hook testing | RTL hooks, Jest | Context dependent |

### Test File Templates

**React Component Test Template:**
```javascript
/* @flow */
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { setupServer } from 'msw/node';
import { rest } from 'msw';
import PropertyCard from '../PropertyCard';

// MSW server setup for API mocking
const server = setupServer(
  rest.get('/api/properties/:id', (req, res, ctx) => {
    return res(ctx.json({
      id: req.params.id,
      address: '123 Main St',
      price: '$500,000'
    }));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('PropertyCard', () => {
  const defaultProps = {
    propertyId: 'prop-123',
    onSelect: jest.fn(),
  };

  test('renders property information correctly', async () => {
    render(<PropertyCard {...defaultProps} />);

    await waitFor(() => {
      expect(screen.getByText('123 Main St')).toBeInTheDocument();
      expect(screen.getByText('$500,000')).toBeInTheDocument();
    });
  });

  test('calls onSelect when clicked', () => {
    render(<PropertyCard {...defaultProps} />);

    fireEvent.click(screen.getByRole('button', { name: /select property/i }));

    expect(defaultProps.onSelect).toHaveBeenCalledWith('prop-123');
  });
});
```

**Custom Hook Test Template:**
```javascript
/* @flow */
import { renderHook, act } from '@testing-library/react';
import { setupServer } from 'msw/node';
import { rest } from 'msw';
import useZillowAuth from '../useZillowAuth';

const server = setupServer(
  rest.post('/api/auth/login', (req, res, ctx) => {
    return res(ctx.json({ token: 'mock-token', user: { id: '123' } }));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('useZillowAuth', () => {
  test('handles login successfully', async () => {
    const { result } = renderHook(() => useZillowAuth());

    await act(async () => {
      await result.current.login('user@example.com', 'password');
    });

    expect(result.current.isAuthenticated).toBe(true);
    expect(result.current.user.id).toBe('123');
  });

  test('handles login failure', async () => {
    server.use(
      rest.post('/api/auth/login', (req, res, ctx) => {
        return res(ctx.status(401), ctx.json({ error: 'Invalid credentials' }));
      })
    );

    const { result } = renderHook(() => useZillowAuth());

    await act(async () => {
      await result.current.login('user@example.com', 'wrong-password');
    });

    expect(result.current.isAuthenticated).toBe(false);
    expect(result.current.error).toBe('Invalid credentials');
  });
});
```

### MSW API Mocking Patterns

| Pattern | Use Case | Example |
|---------|----------|---------|
| **REST API Mock** | Mock HTTP endpoints | `rest.get('/api/users', handler)` |
| **GraphQL Mock** | Mock GraphQL queries | `graphql.query('GetUser', handler)` |
| **Error Simulation** | Test error handling | `res(ctx.status(500), ctx.json({ error: 'Server error' }))` |
| **Dynamic Responses** | Context-dependent data | `req.params.id` to customize response |

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| **MSW handlers not working** | Verify server setup in `beforeAll`/`afterAll` lifecycle |
| **Async component not updating** | Use `waitFor` or `findBy*` queries for async updates |
| **Flow type errors in tests** | Add `/* @flow */` header and proper type annotations |
| **Jest snapshot mismatches** | Run `npm test -- --updateSnapshot` to update snapshots |
| **Coverage not meeting target** | Add missing test cases for uncovered branches/functions |

## Advanced Patterns

<details>
<summary>Click to expand detailed implementation and configuration options</summary>

### Comprehensive Frontend Testing Workflow

When invoked, execute this comprehensive frontend testing workflow:

### 1. Test Analysis and Setup
**Determine Test Requirements:**
- Analyze target React component/hook to classify test type (unit, integration, snapshot, hook)
- Create test file with FUB naming convention (`*-test.js`) in appropriate `__tests__` directory
- Configure React Testing Library imports and setup utilities
- Set up MSW API mocking if external API calls are involved

### 2. Test Implementation Patterns
**Create Tests Following FUB Patterns:**
- **Component Tests**: Use `render()` from React Testing Library with proper prop mocking
- **Hook Tests**: Use `renderHook()` with comprehensive mocking
- **Snapshot Tests**: Generate snapshots for stable component output verification
- **API Integration**: Use MSW handlers for realistic request/response testing
- **River State**: Test custom state management with `act()` wrapper for state updates

### 3. Test Execution and Coverage Analysis
**Run Tests in Jest Environment:**
- Execute Jest with coverage collection enabled (`npm test -- --coverage`)
- Run specific test files or watch mode for development
- Update snapshots when component output changes intentionally
- Verify 75% coverage threshold across branches, functions, lines, and statements

### 4. FUB-Specific Testing Patterns

**Component Test Structure:**
- Use React Testing Library with proper queries and user interactions
- Mock external dependencies with MSW for API calls
- Test accessibility with screen readers and keyboard navigation
- Validate Flow/TypeScript types in test scenarios

**Custom Hook Testing:**
- Use `@testing-library/react-hooks` for hook isolation
- Mock context providers and external dependencies
- Test error boundaries and loading states
- Validate custom state management patterns

**River State Management Testing:**
- Test custom state management with `act()` wrapper
- Mock complex state transitions and side effects
- Validate state persistence and hydration
- Test component integration with state management

**Forge Design System Integration:**
- Test component compatibility with design system
- Validate theme integration and styling props
- Test responsive behavior and accessibility
- Ensure consistent component APIs

**API Mocking with MSW:**
- Set up MSW server for realistic API mocking
- Mock REST endpoints and GraphQL queries
- Test error scenarios and loading states
- Validate request/response data flow

**Jest Configuration and Performance:**
- Configure Jest for optimal test performance
- Set up test environment with proper browser mocks
- Configure coverage thresholds and reporting
- Integrate with CI/CD pipeline requirements

</details>

## Integration Points

### Cross-Skill Workflow Patterns

**Backend Testing → Frontend Testing:**
```bash
# Test full-stack feature integration
backend-test-development --target="UserController" --test_type="api" |
  frontend-test-development --target="UserProfile.jsx" --test_type="integration" --mock_apis=true

# Coordinate API contract testing
frontend-test-development --target="apiClient.js" --test_type="unit" --mock_apis=false
```

**E2E Testing → Frontend Testing:**
```bash
# Create component tests that align with E2E selectors
frontend-test-development --target="SearchForm.jsx" --include_snapshots=true |
  e2e-test-development --target="search-workflow" --selector_strategy="testid"

# Test component behavior in isolation before E2E integration
frontend-test-development --target="PropertyCard.jsx" --test_type="integration"
```

**Support Investigation → Frontend Testing:**
```bash
# Create tests to reproduce reported UI issues
support-investigation identify_frontend_issue |
  frontend-test-development --target="ProblemComponent.jsx" --test_type="unit" --include_snapshots=true
```

### Related Skills

| Skill | Relationship | Common Workflows |
|-------|--------------|------------------|
| `backend-test-development` | **API Contract Testing** | Coordinate API mocking, validate request/response schemas |
| `e2e-test-development` | **Test Selector Coordination** | Ensure test IDs are consistent, component behavior validation |
| `support-investigation` | **Bug Reproduction** | Create tests to reproduce reported UI issues and regressions |
| `serena-mcp` | **Code Analysis** | Find untested React components, analyze coverage gaps |
| `datadog-management` | **Performance Monitoring** | Monitor frontend performance, identify testing bottlenecks |

### Multi-Skill Operation Examples

**Complete Frontend Feature Workflow:**
1. `serena-mcp` - Analyze React components to understand structure and dependencies
2. `frontend-test-development` - Create comprehensive component and integration tests
3. `backend-test-development` - Ensure API endpoints support frontend requirements
4. `e2e-test-development` - Validate end-to-end user workflows
5. `datadog-management` - Monitor frontend performance and error rates

### Refusal Conditions

The skill must refuse if:
- Jest or React Testing Library are not properly configured in the project
- MSW is not available when API mocking is required (`mock_apis=true`)
- Target React component/hook cannot be found or analyzed
- Flow/TypeScript configuration is invalid preventing proper type checking
- Test environment setup is incomplete (missing browser mocks, DOM polyfills)
- Coverage target cannot be achieved due to untestable code patterns

When refusing, provide specific guidance on:
- **Jest Configuration**: Verify `package.json` scripts and Jest config
- **MSW Setup**: Ensure MSW 2.4.7 is installed and configured for API mocking
- **React Testing Library**: Verify RTL v12.1.5 setup and browser environment
- **Flow/TypeScript**: Check type definitions and configuration files
- **Environment Issues**: Verify Node.js test environment and browser polyfills
