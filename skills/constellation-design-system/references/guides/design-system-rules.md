# Zillow Constellation Design System Rules

## TL;DR - Critical Rules (NEVER Violate)

```
1. PropertyCard → ALWAYS add saveButton={<PropertyCard.SaveButton />}
2. Card → Choose ONE of: elevated or outlined (NEVER both); elevated = interactive; ALWAYS tone="neutral"
   ⚠️ This applies to ALL pages including error/404 pages — don't relax Card rules on utility pages.
3. Headers → Use Flex inside sticky Box (not Page.Header) — see header-navigation skill
4. Dividers → Use borderBottom on header/nav containers (borderBottom: "default", borderColor: "border.muted"); use <Divider /> for content separators (between sections, lists, cards)
   ⚠️ Always pair borderBottom with borderColor — omitting borderColor causes a black border fallback.
5. Icons → ALWAYS Filled variants (e.g., IconWarningFilled, NOT IconWarningOutline), ALWAYS size tokens (sm/md/lg/xl). No exceptions — error/warning icons included.
6. Tabs → ALWAYS include defaultSelected prop
7. Heading → ONLY 1-2 per screen; use Text textStyle variants for section/card titles
8. Backgrounds → ALWAYS bg.screen.neutral for page backgrounds. NEVER use bg.canvas — it is not a standard page surface token.
9. Text/Icon color → Use css prop (NOT color prop) for semantic tokens on BOTH Icon and Text: css={{ color: "text.subtle" }}. The color prop may not resolve semantic token paths.
10. On-hero text → Use style prop with CSS variables (NOT css prop): style={{ color: "var(--color-text-on-hero-neutral)" }}
11. Logo sizing → Use style prop (NOT css prop) for pixel values on logos
12. Modal → ALWAYS use body prop for content (NEVER children); default size="md"
13. PropertyCard images → ALWAYS generate via property-card-data skill; NEVER external URLs
14. Page structure → ALWAYS wrap pages in Page.Root > Page.Content; NEVER use manual Box wrappers with maxWidth/mx as a substitute. In sidebar layouts, Page.Root goes inside the content pane (not around the sidebar).
15. Heading level → ALWAYS include level prop (level={1} for page headline, level={2} for section/modal headers)
16. PropertyCard.Badge tone → ONLY "notify" | "neutral" | "buyAbility" | "zillow"; other tone values fail silently
17. Native HTML elements → NEVER use raw HTML form elements (<input>, <select>, <textarea>). ALWAYS use Constellation equivalents (Input, Select, Textarea, RadioGroup, Radio, etc.).
18. Custom form controls → NEVER hand-build radio buttons, checkboxes, toggles, or selectors using Flex/Box when Constellation provides RadioGroup, Radio, CheckboxGroup, Checkbox, Switch, ToggleButtonGroup.
19. PandaCSS shorthand → ALWAYS use Panda utility shorthands (p, px, py, m, mx, mb, etc.) instead of raw CSS property names (padding, marginInline, marginBottom). Raw property names may not resolve spacing tokens correctly.
20. Minimum interactive gap → NEVER use spacing tokens below "200" (8px) for gaps between clickable/tappable elements (nav items, buttons, list rows). Tokens "50" and "100" are for text-internal spacing only.
21. Professional buttons → Default to text-only. Do NOT add icons to text buttons unless the icon is essential for comprehension (search, download, external link). NEVER conditionally inject an icon (causes layout shift). For icon-only actions, use IconButton.
```

---

## AI Workflow (REQUIRED)

AFTER EVERY UI BUILD:
1. Run component validation: `bash .agents/skills/constellation-design-system/scripts/validate-constellation.sh client/src`
2. Run token audit: `bash .agents/skills/constellation-design-system/scripts/validate-tokens.sh client/src`
3. Run icon check: `bash .agents/skills/constellation-icons/scripts/validate-icon-imports.sh client/src`
4. Fix all violations found by scripts
5. Request architect review against this file
6. Re-verify before delivery

---

## New Page Checklist

Before writing any new page or route, verify:

```
[ ] Page wrapped in <Page.Root> <Page.Content> ... </Page.Content> </Page.Root>
[ ] Page background is bg.screen.neutral (via Page.Root default, not manual)
[ ] Only 1 Heading component on the page (level={1}, textStyle per audience)
[ ] All form inputs use Constellation components (Input, Select, Radio, Textarea, etc.)
[ ] No raw HTML elements (<input>, <select>, <div> as button, etc.)
[ ] All Icons use Filled variants and css={{ color: "..." }} for color
[ ] All Cards use tone="neutral" and EITHER elevated OR outlined (not both)
[ ] All Text/Icon color uses css prop, not color prop
[ ] Logo uses style prop for pixel dimensions, not css prop
[ ] Buttons are text-only by default (professional) — icon only when essential
[ ] No spacing tokens below "200" between clickable elements
```

---

## Audience Identification

**Before building any UI, determine the target audience:**

| Audience | Description | Examples |
|----------|-------------|----------|
| **Consumer** | Users looking to buy, sell, or rent a home for themselves | Homebuyer, Renter, Seller, "My Home" dashboard |
| **Professional** | Users conducting business or providing services | Real Estate Agents, Loan Officers, Property Managers, "Agent Hub" |

Load the appropriate brand skill (`consumer-brand-guidelines` or `professional-brand-guidelines`) for complete typography, spacing, and color rules.

---

## Standard Imports

```tsx
import { 
  Button, Card, Text, Heading, Input, Tabs, PropertyCard, ZillowLogo,
  Icon, Divider, Select, Checkbox, Radio, ToggleButtonGroup, ToggleButton,
  CheckboxGroup, Page, Paragraph, TextButton, ButtonGroup
} from '@zillow/constellation';

import { IconHeartFilled, IconSearchFilled, IconHouseFilled } from '@zillow/constellation-icons';

import { css } from '@/styled-system/css';
import { Box, Flex, Grid } from '@/styled-system/jsx';
```

---

## Related Files (Load When Needed)

| File | Load when... |
|------|-------------|
| [Component Patterns](component-patterns.md) | Building UI components — Card, Modal, Table, Tag, Button, PropertyCard, Page structure, sidebar layouts |
| [Token Reference](token-reference.md) | Styling — token resolution, expressive colors, hero backgrounds, on-hero text, spacing, shape & elevation |
| [Quick Reference](quick-reference.md) | Need a condensed cheat sheet for fast lookups |
| [Build Kickoff Guide](build-kickoff-guide.md) | Starting a new app or feature from scratch |
