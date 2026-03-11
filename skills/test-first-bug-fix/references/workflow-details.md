# Test-First Bug Fix: Workflow Details

## Example 1: TypeScript / Vitest

**Bug report:** "The search filter crashes when the user clears the input field."

**Phase 1 — Reproduction test:**

```typescript
// src/components/__tests__/search-filter.test.ts
import { describe, it, expect } from 'vitest';
import { filterResults } from '../search-filter';

describe('search filter', () => {
  it('should not crash when input is cleared to empty string', () => {
    const items = [{ name: 'Alpha' }, { name: 'Beta' }];
    // This is the exact scenario that crashes — clearing the input
    const result = filterResults(items, '');
    expect(result).toEqual(items);
  });
});
```

**Run command:** `npx vitest run src/components/__tests__/search-filter.test.ts`

**Confirm failure:** Test fails with `TypeError: Cannot read property 'toLowerCase' of undefined` — matches the reported crash.

---

## Example 2: Python / Pytest

**Bug report:** "API returns 500 when creating a user with a very long email address."

**Phase 1 — Reproduction test:**

```python
# tests/test_user_creation.py
import pytest
from app.services.user import create_user

def test_create_user_with_long_email_does_not_crash():
    """Bug: 500 error when email exceeds 255 chars."""
    long_email = "a" * 250 + "@example.com"  # 262 chars total
    # Should either succeed or raise a ValidationError, not crash
    try:
        result = create_user(email=long_email, name="Test")
        assert result is not None
    except ValidationError:
        pass  # Validation rejection is acceptable
    # If it raises any other exception, the test fails
```

**Run command:** `pytest tests/test_user_creation.py::test_create_user_with_long_email_does_not_crash -v`

---

## Example 3: React Component / React Testing Library

**Bug report:** "The modal doesn't close when clicking the X button."

**Phase 1 — Reproduction test:**

```tsx
// src/components/__tests__/modal.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { ConfirmModal } from '../confirm-modal';

describe('ConfirmModal', () => {
  it('should close when the close button is clicked', () => {
    const onClose = vi.fn();
    render(<ConfirmModal open={true} onClose={onClose} />);
    
    const closeButton = screen.getByRole('button', { name: /close/i });
    fireEvent.click(closeButton);
    
    expect(onClose).toHaveBeenCalledTimes(1);
  });
});
```

---

## Subagent Strategy Hints

The 3 subagents should get genuinely different strategy hints so they explore different solution spaces:

| Subagent | Strategy | Good for |
|----------|----------|----------|
| **Direct fix** | "Fix the logic in the most direct, minimal way. Change as few lines as possible." | Simple logic errors, off-by-one, wrong operator |
| **Validation fix** | "Look for missing input validation, null checks, or edge cases that aren't handled." | Crashes on empty input, unexpected types, boundary conditions |
| **Structural fix** | "Consider whether the data flow, types, or component structure is fundamentally wrong." | Architectural issues, prop drilling bugs, state management problems |

## Picking the Winner

When multiple subagents produce passing fixes, evaluate by:

1. **Smallest diff** — fewer changed lines = less risk of regressions
2. **Addresses root cause** — a null check is a band-aid; fixing the source of the null is better
3. **Readability** — the fix should be obvious to a future reader
4. **No side effects** — doesn't change unrelated behavior

## When Reproduction Is Hard

| Situation | Fallback |
|-----------|----------|
| No test framework and user doesn't want one | Write a standalone script: `node reproduce-bug.js` that exits 0/1 |
| Bug requires specific data | Create a fixture file with the exact data that triggers the bug |
| Bug is timing-dependent | Use controlled async (fake timers, manual promise resolution) |
| Bug only happens in production | Match prod config locally (env vars, feature flags, data shape) |
| Bug is visual/CSS | Use snapshot tests or assert on computed styles/DOM structure |

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Write the test after the fix | Write the test BEFORE touching any source code |
| Write a test that tests the happy path | Write a test that fails the way the bug fails |
| Let subagents modify the test | Lock the test file — subagents only change source code |
| Accept "the test is hard to write, I just fixed it" | No test = no proof = not fixed |
| Write a huge integration test | Write the smallest test that reproduces the specific bug |
| Skip running the full test suite after fixing | Always run the full suite to catch regressions |
