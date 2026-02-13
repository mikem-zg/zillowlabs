# Page Migration Checklist

Copy this checklist for each page you convert. Check off items as you complete them.

## Page: ____________

### Pre-flight
- [ ] Read the existing page and understand what it renders
- [ ] List all components used on this page
- [ ] List all icons used
- [ ] List all styling approaches (Tailwind classes, CSS modules, styled-components, inline styles)
- [ ] Identify forms, modals, interactive elements
- [ ] Note any custom components that may not have a 1:1 Constellation match

### Imports
- [ ] Replace component library imports with `@zillow/constellation`
- [ ] Replace icon imports with `@zillow/constellation-icons` (Filled variants)
- [ ] Replace layout imports with `@/styled-system/jsx` (Flex, Box, Grid)
- [ ] Replace styling imports with `@/styled-system/css` (css function)
- [ ] Remove old library imports (confirm zero remaining)

### Components (check each one used on this page)
- [ ] Buttons → Button/IconButton/TextButton with correct tone/emphasis/size
- [ ] Cards → Card with tone="neutral", correct elevated/outlined choice
- [ ] Modals → Modal with body prop (not children), dividers, header/footer
- [ ] Tabs → Tabs.Root with defaultSelected (not defaultValue)
- [ ] Forms → Input/LabeledInput/Select/Checkbox/Radio/Switch
- [ ] Tables → Table.Root/Header/Body/Row/Cell/HeaderCell
- [ ] Icons → Icon wrapper with size token, Filled variant, css prop for color
- [ ] Dividers → Divider component (no CSS borders)
- [ ] Tags/Badges → Tag component (no custom Box styling)
- [ ] Navigation → Page.Header inside Page.Root
- [ ] Property listings → PropertyCard with saveButton

### Styling
- [ ] Remove all Tailwind/className usage
- [ ] Remove all inline style objects (replace with css() or component props)
- [ ] Remove all CSS module imports
- [ ] Remove all styled-components/Emotion
- [ ] Verify spacing uses tokens (200, 300, 400, 600, 800)
- [ ] Verify colors use semantic tokens (bg.screen.neutral, text.subtle, etc.)
- [ ] Verify layout uses Flex/Box/Grid from styled-system

### Design System Rules
- [ ] Backgrounds: white (bg.screen.neutral) or gray only — no light blue
- [ ] Typography: max 1-2 Heading per screen; Text for section/card titles
- [ ] Alignment: left-aligned by default (center OK for short content only)
- [ ] UX writing: sentence case, contractions, active voice
- [ ] Icons: all Filled, all wrapped in Icon with size token
- [ ] Professional app: size="md" on buttons/inputs
- [ ] No CSS borders for separators (use Divider)
- [ ] Card: never elevated+outlined together
- [ ] Blue used only for interactive elements (not headlines)

### Testing
- [ ] Page renders without errors
- [ ] All interactions work (clicks, forms, modals, tabs)
- [ ] Responsive layout works (mobile + desktop)
- [ ] No old library imports remain (grep to verify)
- [ ] Visual matches expected design

### Validation evidence
- [ ] Run: `grep -rn "from.*old-library" src/pages/this-page.tsx` — confirm zero matches
- [ ] Run: `bash .agents/skills/transition-to-constellation/references/scripts/validate-migration.sh src` — check for regressions
- [ ] Screenshot the page at desktop and mobile widths for QA review

### References
- Component recipes: `references/recipes/` — before/after code for each component type
- Common pitfalls: `references/guides/common-pitfalls.md` — 30 gotchas to check against
- Decision tree: `references/guides/component-decision-tree.md` — which component to use for each pattern
