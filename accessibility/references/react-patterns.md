# React Accessibility Patterns

React-specific patterns for building accessible SPAs. Covers focus management, live regions, route transitions, forms, and common pitfalls.

## Focus Management

### Route Change Focus

When navigating between routes in a React SPA, screen reader users need to know navigation occurred.

Best practice: Focus the `<h1>` heading after route change.

```tsx
import { useEffect } from 'react';
import { useLocation } from 'wouter';

function useFocusOnRouteChange() {
  const [location] = useLocation();

  useEffect(() => {
    const h1 = document.querySelector('h1');
    if (h1) {
      h1.setAttribute('tabindex', '-1');
      h1.focus();
    }
  }, [location]);
}
```

CSS to hide outline on programmatic focus:

```css
[tabindex="-1"]:focus { outline: none; }
[tabindex="-1"]:focus-visible { outline: 2px solid var(--color-blue-600); outline-offset: 2px; }
```

### Modal Focus Trap

- On open: focus first focusable element or heading
- Trap Tab/Shift+Tab cycling within modal
- On close: return focus to trigger element
- Constellation `<Modal>` handles this automatically

```tsx
function Modal({ isOpen, onClose, children }) {
  const previousFocus = useRef(null);
  const modalRef = useRef(null);

  useEffect(() => {
    if (isOpen) {
      previousFocus.current = document.activeElement;
      modalRef.current?.focus();
    } else {
      previousFocus.current?.focus();
    }
  }, [isOpen]);

  if (!isOpen) return null;
  return (
    <div ref={modalRef} role="dialog" aria-modal="true" tabIndex={-1}>
      {children}
    </div>
  );
}
```

### Focus After Dynamic Content

When new content appears (expanding accordion, loading results), move focus to:
- The new content container (with `tabindex="-1"`)
- Or the first interactive element in the new content

## ARIA Live Regions

### Critical Rules

1. Keep live region elements permanently in the DOM
2. Start with empty content
3. Update text content only — never conditionally render the container
4. Use `aria-live="polite"` for ~95% of use cases
5. Use `aria-live="assertive"` only for critical errors

### Wrong vs Right

```tsx
// WRONG — element gets destroyed/recreated, screen reader loses track
{showError && <div aria-live="polite">{error}</div>}

// RIGHT — element always present, content changes
<div aria-live="polite">{showError ? error : ''}</div>
```

### Global Announcer Pattern

```tsx
import { createContext, useContext, useState, useCallback } from 'react';

const LiveRegionContext = createContext<{ announce: (msg: string) => void }>({ announce: () => {} });

export function LiveRegionProvider({ children }: { children: React.ReactNode }) {
  const [message, setMessage] = useState('');

  const announce = useCallback((text: string) => {
    setMessage('');
    setTimeout(() => setMessage(text), 100);
  }, []);

  return (
    <LiveRegionContext.Provider value={{ announce }}>
      <div aria-live="polite" aria-atomic="true" className="sr-only">
        {message}
      </div>
      {children}
    </LiveRegionContext.Provider>
  );
}

export const useAnnounce = () => useContext(LiveRegionContext);
```

Usage:

```tsx
function SaveButton() {
  const { announce } = useAnnounce();
  const handleSave = async () => {
    await saveData();
    announce('Changes saved successfully');
  };
  return <Button onClick={handleSave}>Save</Button>;
}
```

### Common Use Cases

| Scenario | aria-live | aria-atomic | Example message |
|----------|-----------|-------------|-----------------|
| Form validation error | assertive | true | "Email address is required" |
| Success notification | polite | true | "Property saved to favorites" |
| Search results count | polite | true | "24 homes found" |
| Loading state | polite | true | "Loading search results" |
| Chat message | polite | false | (new message text only) |

## Accessible Forms

### Label Association

```tsx
// Method 1: htmlFor (preferred)
<label htmlFor="email">Email address</label>
<Input id="email" type="email" />

// Method 2: aria-label (visually hidden label)
<Input aria-label="Search properties" type="search" />

// Method 3: aria-labelledby (label from another element)
<Text id="price-label" textStyle="body-bold">Price range</Text>
<Input aria-labelledby="price-label" type="text" />
```

### Error Messaging

```tsx
function EmailField() {
  const [error, setError] = useState('');
  const errorId = 'email-error';

  return (
    <div>
      <label htmlFor="email">Email</label>
      <Input
        id="email"
        type="email"
        aria-describedby={error ? errorId : undefined}
        aria-invalid={!!error}
      />
      {error && (
        <span id={errorId} role="alert">
          {error}
        </span>
      )}
    </div>
  );
}
```

### Form Validation Pattern

- Associate errors with inputs via `aria-describedby`
- Set `aria-invalid="true"` on invalid fields
- Use `role="alert"` on error messages for immediate announcement
- On form submission failure: focus the first invalid field
- Provide error suggestions when possible (WCAG 3.3.3)

### Required Fields

```tsx
<label htmlFor="name">
  Full name <span aria-hidden="true">*</span>
</label>
<Input id="name" aria-required="true" />
```

## Skip Links

```tsx
function SkipLink() {
  return (
    <a
      href="#main-content"
      className="sr-only focus:not-sr-only"
      style={{
        position: 'absolute',
        top: '-40px',
        left: 0,
        zIndex: 1000,
      }}
      onFocus={(e) => { e.currentTarget.style.top = '0'; }}
      onBlur={(e) => { e.currentTarget.style.top = '-40px'; }}
    >
      Skip to main content
    </a>
  );
}

// In layout:
<SkipLink />
<nav>...</nav>
<main id="main-content" tabIndex={-1}>...</main>
```

## Visually Hidden Content (sr-only)

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

Use for:
- Skip link text (visible only on focus)
- Additional context for screen readers
- Live region announcer containers
- Form field descriptions that don't need visual display

## Keyboard Navigation Patterns

### Interactive Elements Must Be Focusable

- Native HTML elements (`<button>`, `<a href>`, `<input>`) are focusable by default
- Custom interactive elements need `tabIndex={0}`
- Non-interactive containers that need programmatic focus: `tabIndex={-1}`
- Never use `tabIndex` > 0

### Keyboard Shortcuts

- Document all custom keyboard shortcuts
- Single-character shortcuts must be remappable (WCAG 2.1.4)
- Common patterns: Escape to close, Arrow keys to navigate, Enter/Space to activate

## Images & Icons

### Informative Images

```tsx
<img src={photo} alt="Three-bedroom ranch home with large front yard" />
```

### Decorative Images

```tsx
<img src={divider} alt="" role="presentation" />
```

### Icon Accessibility (Constellation)

```tsx
// Icon with visible label — icon is decorative
<Button icon={<IconSearchFilled />} iconPosition="start">Search</Button>

// Icon-only button — title provides accessible name
<IconButton title="Close dialog">
  <Icon><IconCloseFilled /></Icon>
</IconButton>

// Standalone informative icon — provide aria-label on wrapper
<span aria-label="Favorited">
  <Icon size="md" css={{ color: 'text.action.critical.hero.default' }}>
    <IconHeartFilled />
  </Icon>
</span>
```

## Common Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| `<div onClick={handler}>` | Not keyboard accessible, no role | Use `<button>` |
| `<a>` without `href` | Not focusable, no link semantics | Add `href` or use `<button>` |
| Placeholder as label | Disappears on input, low contrast | Use `<label>` element |
| `aria-label` on non-interactive `<div>` | Screen readers may ignore | Use on interactive elements or landmarks |
| Auto-focus on page load | Disorienting for screen reader users | Focus after user-initiated actions only |
| `tabIndex={5}` | Breaks natural tab order | Use `tabIndex={0}` or `tabIndex={-1}` |
| `onClick` on `<span>` for toggle | Missing role, state, keyboard support | Use `<button aria-pressed>` |

## Page Title Management

```tsx
// Update document title on route change
useEffect(() => {
  document.title = `${pageTitle} | Zillow`;
}, [pageTitle]);
```
