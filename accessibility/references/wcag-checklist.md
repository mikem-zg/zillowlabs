# WCAG 2.2 Checklist

Target Level AA compliance for all Zillow products. Based on W3C WCAG 2.2 (October 2023).

> Attribution: Based on Web Content Accessibility Guidelines (WCAG) 2.2, W3C Recommendation 05 October 2023. Copyright © W3C. See [W3C Document License](https://www.w3.org/copyright/document-license-2023/).

## How to Use This Checklist

- **Level A** = minimum baseline (must pass)
- **Level AA** = legal standard (target for all Zillow products)
- **Level AAA** = enhanced (nice to have, not required)

Criteria marked **[NEW 2.2]** were added in WCAG 2.2 and may not appear in older references.

---

## Principle 1: Perceivable

Information and user interface components must be presentable to users in ways they can perceive.

### 1.1 Text Alternatives

- **1.1.1 Non-text Content (A):** All informative images need alt text. Decorative images need `alt=""`. Controls/inputs need accessible names.
  - React: `<img alt="Description" />` or `<img alt="" role="presentation" />`

### 1.2 Time-based Media

- **1.2.1 Audio-only/Video-only (A):** Provide transcript or text alternative
- **1.2.2 Captions (A):** Pre-recorded video needs captions
- **1.2.3 Audio Description (A):** Pre-recorded video needs audio description or text alternative
- **1.2.4 Captions Live (AA):** Live video needs real-time captions
- **1.2.5 Audio Description (AA):** Pre-recorded video needs audio description

### 1.3 Adaptable

- **1.3.1 Info and Relationships (A):** Use semantic HTML. Headings, lists, tables must be marked up properly. Forms need labels.
  - React: Use `<h1>`-`<h6>`, `<ul>/<ol>`, `<table>`, `<label htmlFor="id">`
- **1.3.2 Meaningful Sequence (A):** Reading order must be logical in DOM even if CSS changes visual order
- **1.3.3 Sensory Characteristics (A):** Don't rely solely on shape, size, position, or sound
- **1.3.4 Orientation (AA):** Don't lock to portrait or landscape unless essential
- **1.3.5 Identify Input Purpose (AA):** Use autocomplete attributes on personal data inputs
  - React: `<input autoComplete="email" />`, `<input autoComplete="given-name" />`

### 1.4 Distinguishable

- **1.4.1 Use of Color (A):** Color is not the only visual means of conveying info
- **1.4.2 Audio Control (A):** Auto-playing audio >3s must have pause/stop/volume control
- **1.4.3 Contrast Minimum (AA):** Text 4.5:1, large text 3:1
- **1.4.4 Resize Text (AA):** Text can be resized to 200% without loss of content
- **1.4.5 Images of Text (AA):** Use real text, not images of text (except logos)
- **1.4.10 Reflow (AA):** Content reflows at 400% zoom without horizontal scrolling (320px viewport)
- **1.4.11 Non-text Contrast (AA):** UI components and graphical objects need 3:1 contrast
- **1.4.12 Text Spacing (AA):** No loss of content when users adjust letter/word/line spacing
- **1.4.13 Content on Hover or Focus (AA):** Tooltips/popovers must be dismissible, hoverable, and persistent

---

## Principle 2: Operable

User interface components and navigation must be operable.

### 2.1 Keyboard Accessible

- **2.1.1 Keyboard (A):** All functionality available via keyboard
- **2.1.2 No Keyboard Trap (A):** Focus can always be moved away
- **2.1.4 Character Key Shortcuts (A):** Single-character shortcuts must be remappable or disableable

### 2.2 Enough Time

- **2.2.1 Timing Adjustable (A):** Time limits can be turned off, adjusted, or extended
- **2.2.2 Pause, Stop, Hide (A):** Moving/blinking/scrolling content can be paused

### 2.3 Seizures

- **2.3.1 Three Flashes (A):** Nothing flashes more than 3 times per second

### 2.4 Navigable

- **2.4.1 Bypass Blocks (A):** Skip links to bypass repeated content
  - React: `<a href="#main-content" className="sr-only focus:not-sr-only">Skip to main content</a>`
- **2.4.2 Page Titled (A):** Pages have descriptive titles
  - React: `document.title = "Page Name | Zillow"` or use a helmet/meta component
- **2.4.3 Focus Order (A):** Tab order follows logical reading order
- **2.4.4 Link Purpose (A):** Link text describes destination (avoid "click here")
- **2.4.5 Multiple Ways (AA):** More than one way to find pages (nav + search + sitemap)
- **2.4.6 Headings and Labels (AA):** Headings and labels are descriptive
- **2.4.7 Focus Visible (AA):** Keyboard focus indicator is visible
- **2.4.11 Focus Not Obscured Minimum (AA) [NEW 2.2]:** Focused element not fully hidden by sticky headers/footers/banners
  - React: Ensure sticky elements don't cover focused items. Consider making sticky elements non-sticky at high zoom levels.
- **2.4.13 Focus Appearance (AAA) [NEW 2.2]:** Focus indicator at least 2px thick, 3:1 contrast

### 2.5 Input Modalities

- **2.5.1 Pointer Gestures (A):** Multi-point gestures have single-pointer alternatives
- **2.5.2 Pointer Cancellation (A):** Down-event doesn't trigger action (use click/mouseup)
- **2.5.3 Label in Name (A):** Visible label text is included in accessible name
- **2.5.4 Motion Actuation (A):** Motion-triggered actions have UI alternatives
- **2.5.7 Dragging Movements (A) [NEW 2.2]:** All drag operations have single-pointer alternatives
  - React: Provide button controls alongside drag-and-drop interfaces
- **2.5.8 Target Size Minimum (AAA) [NEW 2.2]:** Interactive targets at least 24×24px

---

## Principle 3: Understandable

Information and the operation of the user interface must be understandable.

### 3.1 Readable

- **3.1.1 Language of Page (A):** `<html lang="en">`
- **3.1.2 Language of Parts (AA):** Mark content in different languages with `lang` attribute

### 3.2 Predictable

- **3.2.1 On Focus (A):** No context change on focus alone
- **3.2.2 On Input (A):** No unexpected context change on input (warn users first)
- **3.2.6 Consistent Help (AA) [NEW 2.2]:** Help mechanisms in same relative position across pages

### 3.3 Input Assistance

- **3.3.1 Error Identification (A):** Errors described in text (not just color)
  - React: `<span role="alert">{errorMessage}</span>` with `aria-describedby` on input
- **3.3.2 Labels or Instructions (A):** Form inputs have labels and instructions
- **3.3.3 Error Suggestion (AA):** Suggest corrections when possible
- **3.3.4 Error Prevention (AA):** Reversible/confirmed/checked for legal/financial/data submissions
- **3.3.7 Redundant Entry (A) [NEW 2.2]:** Don't ask for same info twice in a session
- **3.3.8 Accessible Authentication Minimum (AA) [NEW 2.2]:** Don't require cognitive function tests for login. Support password managers, biometric, email-based auth.

---

## Principle 4: Robust

Content must be robust enough that it can be interpreted by a wide variety of user agents, including assistive technologies.

### 4.1 Compatible

- **4.1.2 Name, Role, Value (A):** Custom components expose name, role, state to assistive technology
  - React: Use ARIA roles/states on custom widgets; prefer native HTML elements
- **4.1.3 Status Messages (AA):** Status messages announced without receiving focus
  - React: Use `role="status"` or `aria-live="polite"` for non-focus status updates

---

## Resources

- [WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)
- [Understanding WCAG 2.2](https://www.w3.org/WAI/WCAG22/Understanding/)
- [WCAG 2.2 JSON (W3C)](https://www.w3.org/WAI/WCAG22/wcag.json)

---

Attribution: Based on Web Content Accessibility Guidelines (WCAG) 2.2, W3C Recommendation 05 October 2023. Copyright © W3C. See [W3C Document License](https://www.w3.org/copyright/document-license-2023/).
