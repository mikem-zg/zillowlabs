# Rebuild Checklist

This checklist is used during Phase 3 (Rebuild) of the transition-to-constellation-from-scratch skill. It defines the Ralph Wiggum verification protocol — what you check after building each individual task.

---

## Ralph Wiggum Per-Task Protocol

Run this protocol for **every single task** in the PRD. No exceptions. No batching.

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: BUILD                                               │
│   Build ONLY what this one task describes.                   │
│   Do not touch anything outside the task scope.              │
│                                                              │
│ STEP 2: RUN                                                  │
│   Start the app. Does it load without errors?                │
│   → NO → Fix before proceeding.                              │
│   → YES → Continue.                                          │
│                                                              │
│ STEP 3: VERIFY ACCEPTANCE CRITERIA                           │
│   Check each acceptance criterion for this task's feature.   │
│   Does the task's portion pass?                              │
│   → NO → Fix before proceeding.                              │
│   → YES → Continue.                                          │
│                                                              │
│ STEP 4: REGRESSION CHECK                                     │
│   Do all previously completed tasks still work?              │
│   → NO → Fix the regression before proceeding.               │
│   → YES → Continue.                                          │
│                                                              │
│ STEP 5: CONSTELLATION CHECK                                  │
│   Does the new code follow Constellation rules?              │
│   (Use the Constellation Compliance checklist below)         │
│   → NO → Fix before proceeding.                              │
│   → YES → Continue.                                          │
│                                                              │
│ STEP 6: DARK MODE CHECK (if applicable)                      │
│   Does it render correctly in dark mode?                     │
│   → NO → Fix before proceeding.                              │
│   → YES → Continue.                                          │
│                                                              │
│ STEP 7: MARK COMPLETE                                        │
│   This task is done. Move to the next task in the PRD.       │
└─────────────────────────────────────────────────────────────┘
```

**Rules:**
- NEVER skip a step
- NEVER move to the next task while the current one is broken
- NEVER batch multiple tasks — one at a time
- If a task breaks something that was working, fix it NOW, not later

---

## Constellation Compliance Checklist

Check these after every task that adds or modifies UI:

### Components

- [ ] All UI elements use Constellation components — no custom replacements
- [ ] `Card` usage: clickable = `elevated interactive tone="neutral"`, static = `outlined elevated={false} tone="neutral"`
- [ ] `Heading` used sparingly (1-2 per screen max), `Text textStyle="body-lg-bold"` for section titles
- [ ] Icons: Filled variants only, wrapped in `<Icon size="sm|md|lg">`, color via `css` prop not `color` prop
- [ ] `Divider` component for all visual separators — no CSS borders
- [ ] `Tag` for labels/badges — no custom `Box` with bg/borderRadius
- [ ] Forms use `Input`, `Textarea`, `Select`, `Checkbox`, `Radio` — no styled divs
- [ ] Buttons use `icon` and `iconPosition` props — no Flex wrapping inside Button
- [ ] Tabs include `defaultSelected` prop
- [ ] Modals use `header`, `body`, and `footer` props with `dividers` — NEVER pass content as children
- [ ] Headers use `Page.Header` inside `Page.Root` — no custom `Box`/`Flex` headers

### Design Tokens

- [ ] Background: `bg.screen.neutral` (white) — no light blue
- [ ] Spacing: page padding `px="400" py="600"`, section gaps `gap="800"`, card padding `p="400"`, grid gaps `gap="400"`
- [ ] Typography: sentence case for all UI text, no Title Case or ALL CAPS
- [ ] Colors: Blue600 only for interactive elements — no blue headlines
- [ ] Text alignment: left-aligned by default, center only for short content (empty states, heroes)
- [ ] Corner radius: use component defaults or tokens (`node.md`) — no hardcoded pixel values

### Professional App Rules (if applicable)

- [ ] Colors restricted to Blue (#0041D9) for actions, Granite (#111116) for text
- [ ] No Purple, Orange, or vibrant Teal for UI elements
- [ ] Component sizing: `size="md"` for buttons, inputs, selects
- [ ] Shadows only on interactive/clickable elements
- [ ] Spot illustrations only — no scene illustrations

---

## Dark Mode Verification

Check these after every task (if the app supports dark mode):

### Switching

- [ ] Theme toggle/menu is accessible from every screen
- [ ] Light, dark, and system modes all function
- [ ] System mode follows OS preference and updates in real time
- [ ] Selected mode persists across page reloads (localStorage)
- [ ] No flash of wrong theme on initial page load

### Visual

- [ ] No hardcoded hex colors — all colors use semantic tokens
- [ ] No shadows on elements in dark mode
- [ ] Text is legible against dark backgrounds (check subtle/muted text)
- [ ] Borders and dividers are visible in dark mode
- [ ] Code blocks have appropriate dark backgrounds

### Assets

- [ ] Illustrations have light/dark variants that switch with theme
- [ ] Logo adapts to dark background if needed

### Implementation

- [ ] Theme applied via `data-panda-mode` attribute on `<html>`
- [ ] `injectTheme()` or `ConstellationProvider` initialized before rendering
- [ ] No inline `style={{ color: "#hex" }}` bypassing the theme system

---

## Responsive Verification

Check these after tasks that affect layout:

- [ ] Layout adapts: 1 column (mobile 375px), 2 columns (tablet 768px), 3 columns (desktop 1280px)
- [ ] Modals are fullscreen on mobile, sized on desktop
- [ ] Search collapses to icon on mobile (if applicable)
- [ ] Grid columns use responsive props
- [ ] Touch targets are at least 44x44px on mobile
- [ ] No horizontal scrolling at any breakpoint

---

## Accessibility Verification

Check these after tasks that add interactive elements:

- [ ] Interactive elements are keyboard-navigable (Tab, Enter, Escape)
- [ ] Modal focus is trapped and restored on close
- [ ] Images have meaningful `alt` text
- [ ] Form fields have visible labels
- [ ] Icon-only buttons have `title` or `aria-label`
- [ ] Color is not the only means of conveying information

---

## Per-Phase Verification

Run these after completing all tasks in a build phase:

### After Phase 1 (Foundation)

- [ ] App loads without errors
- [ ] Header renders with logo, navigation, and sticky behavior
- [ ] All routes render (even if content is empty)
- [ ] Light/dark/system theme switching works with persistence
- [ ] No flash of wrong theme on load
- [ ] Auth flow works: sign in, session persistence, sign out (if applicable)
- [ ] 404 page renders for unknown routes
- [ ] No console errors or warnings

### After Phase 2 (Core)

- [ ] Primary user workflow is complete end-to-end
- [ ] Data fetches from API and renders correctly
- [ ] Detail pages show all required information
- [ ] Primary actions work (download, copy, navigate)
- [ ] Deep linking works — every content item has a unique URL
- [ ] Browser back/forward navigation works correctly
- [ ] All of the above work in dark mode

### After Phase 3 (Supporting)

- [ ] Search finds items across all content types
- [ ] Filters narrow results correctly
- [ ] Modal previews open and close cleanly
- [ ] Forms submit successfully with validation
- [ ] Auth-gated actions prompt sign-in when not authenticated
- [ ] All of the above work in dark mode

### After Phase 4 (Polish)

- [ ] Reports/analytics page shows correct data
- [ ] Keyboard shortcuts work (Cmd+K for search, etc.)
- [ ] Clipboard actions show confirmation ("Copied")
- [ ] Relative timestamps display correctly
- [ ] Page titles update per route
- [ ] Empty states show illustrations and helpful copy
- [ ] Loading states show spinners for all async operations
- [ ] All of the above work in dark mode

---

## PRD Acceptance Criteria Verification

After all phases are complete, verify every acceptance criterion in the PRD:

```
For each feature in the PRD:
  For each acceptance criterion:
    → Does it pass? Record YES or NO.
    → If NO: fix it before declaring the rebuild complete.
```

The rebuild is complete ONLY when every acceptance criterion in the PRD passes.

---

## Common Failures

| Failure | Root Cause | Fix |
|---------|-----------|-----|
| Card hover doesn't work | Missing `interactive` prop | Add `interactive` alongside `elevated` |
| Card has both shadow and border | Both `elevated` and `outlined` set | Pick one — never both |
| Tab content doesn't show | Missing `defaultSelected` | Add `defaultSelected="firstTabValue"` |
| Icon color doesn't resolve | Using `color` prop instead of `css` | Change to `css={{ color: "token.path" }}` |
| Modal content overflows | Content as children instead of `body` prop | Use `header`, `body`, `footer` props with `dividers` |
| Blue headline | Using Blue600 for non-interactive text | Blue is for interactive elements only |
| Light blue background | Using colored background | Use `bg.screen.neutral` (white) or Gray |
| Text centered on paragraphs | Center-aligning body text | Left-align by default |
| Multiple Headings per screen | Using `Heading` for section titles | Use `Text textStyle="body-lg-bold"` |
| CSS border for dividers | Using `borderBottom` style | Use `<Divider />` component |
| Flash of wrong theme on load | Mode applied after React hydration | Read localStorage and set `data-panda-mode` in a `<script>` before React mounts |
| Dark mode colors don't change | Hardcoded hex values in inline styles | Replace with semantic tokens via `css` prop |
| Shadows visible in dark mode | Not removing elevation in dark context | Use lighter background instead of shadows in dark mode |
| Illustrations don't switch | Using only light variant | Conditionally load from `Lightmode/` or `Darkmode/` based on resolved theme |
