# Converting an Existing Frontend to Constellation

A step-by-step playbook for replacing an existing frontend (Tailwind, Material UI, shadcn, Chakra, vanilla CSS, etc.) with Zillow's Constellation Design System while preserving the app's layout and features.

---

## TL;DR — Three Pillars

```
1. Analyze  → Run analyze-codebase.sh to produce a migration report
2. Convert  → Install Constellation, run side-by-side, convert page-by-page
3. Validate → Run validate-migration.sh to track progress and catch remnants
```

**Rule:** Only replace the UI layer. Keep routing, state management, data fetching, and business logic untouched.

---

## Phase 1: Analyze the Existing Codebase

Before writing any code, run the analysis script to understand what you're working with:

```bash
bash .agents/skills/transition-to-constellation/references/scripts/analyze-codebase.sh src
```

This produces a `migration-report.md` with:
- Current UI stack (libraries, styling, icons)
- File counts per library
- Component-to-Constellation mapping
- Suggested migration order
- Estimated scope (small / medium / large)

Read the report before proceeding. It tells you exactly which files import old libraries and how many occurrences of each pattern exist.

### Manual Checks (if the script misses anything)

| Check | How |
|-------|-----|
| Component library | Look at `package.json` for MUI, Chakra, Radix, shadcn, Ant Design, etc. |
| Styling solution | Look for Tailwind config, CSS modules, styled-components, Emotion, etc. |
| Icons | Look for lucide-react, heroicons, react-icons, FontAwesome, etc. |
| Routing | Keep as-is (React Router, Wouter, Next.js, etc.) |
| State management | Keep as-is (Redux, Zustand, TanStack Query, etc.) |
| Forms | Keep logic, replace UI (react-hook-form, Formik, etc.) |

---

## Phase 2: Install Constellation (Side-by-Side)

### 2A. Install Packages

Copy tarballs from the skill and add to `package.json`:

```bash
cp .agents/skills/transition-to-constellation/packages/*.tgz ./
```

```json
{
  "dependencies": {
    "@zillow/constellation": "file:constellation-10.11.0.tgz",
    "@zillow/constellation-fonts": "file:constellation-fonts-10.11.0.tgz",
    "@zillow/constellation-icons": "file:constellation-icons-10.11.0.tgz",
    "@zillow/constellation-tokens": "file:constellation-tokens-10.11.0.tgz",
    "@zillow/yield-callback": "file:yield-callback-1.4.0.tgz"
  },
  "devDependencies": {
    "@zillow/constellation-config": "file:constellation-config-10.11.0.tgz"
  }
}
```

Then run `npm install`.

> For full setup details (font loading, PostCSS config, etc.), see the [Installation Guide](installation.md).

### 2B. Configure PandaCSS

**IMPORTANT:** Use `constellationPandaConfig` (NOT `constellationPandaPreset` with `defineConfig`). The preset alone does not include the PandaCSS plugins that generate required utility exports (`crv`, `ccv`, `splitResponsiveVariant`). Using only the preset will cause codegen to fail.

```ts
// panda.config.ts
import { constellationPandaConfig } from '@zillow/constellation-config';

export default constellationPandaConfig({
  include: [
    './src/**/*.{js,jsx,ts,tsx}',
    './node_modules/@zillow/constellation/dist/**/*.{js,mjs}',
  ],
  outdir: 'src/styled-system',
});
```

Run `npx panda codegen` to generate the styled-system.

### 2C. Set Up Aliases

**Vite:**
```ts
resolve: {
  alias: {
    '@/styled-system': path.resolve(__dirname, 'src/styled-system'),
  },
}
```

**TypeScript:**
```json
{
  "compilerOptions": {
    "paths": {
      "@/styled-system/*": ["./src/styled-system/*"]
    }
  }
}
```

### 2D. Import Styles and Inject Theme

In your app entry point (main.tsx or App.tsx):

```tsx
import './styled-system/styles.css';
import { useEffect } from 'react';
import { getTheme, injectTheme } from './styled-system/themes';

function ThemeLoader({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    getTheme('zillow').then((theme) => {
      injectTheme(document.documentElement, theme);
    });
  }, []);
  return <>{children}</>;
}
```

---

## Phase 3: Coexistence Strategy (Gradual Migration)

For medium and large migrations, run old and new systems side-by-side. The app stays functional throughout — you convert one component at a time.

### Tailwind + PandaCSS Coexistence

If the project uses Tailwind, you can run both simultaneously:

**Step 1: Prefix Tailwind classes** to avoid collisions:

```js
// tailwind.config.js
module.exports = {
  prefix: 'tw-',
  content: ['./src/**/*.{js,jsx,ts,tsx}'],
};
```

**Step 2: Configure CSS layer ordering** so PandaCSS takes priority:

```css
/* In your global CSS */
@tailwind components;
@tailwind utilities;

/* PandaCSS layers (ordered after Tailwind so they win) */
@layer reset-panda, base-layer, tokens-panda, recipes-panda, utilities-panda;
```

**Step 3: Use custom PandaCSS layer names** to avoid conflicts:

```ts
// panda.config.ts — add layers config
constellationPandaConfig({
  layers: {
    reset: 'reset-panda',
    base: 'base-layer',
    tokens: 'tokens-panda',
    recipes: 'recipes-panda',
    utilities: 'utilities-panda',
  },
  // ... rest of config
});
```

This lets you convert file-by-file. Old Tailwind classes keep working (with `tw-` prefix), and new Constellation components use PandaCSS. When a file is fully converted, remove its `tw-` classes.

### shadcn/ui + Constellation Coexistence

shadcn components live in your codebase as actual files (usually `components/ui/`). They can coexist with Constellation indefinitely:

1. Keep the `components/ui/` directory working
2. Create new features using Constellation imports
3. When editing an existing page, swap shadcn components for Constellation equivalents
4. Delete shadcn component files only when no imports remain (check with `grep -r "from.*components/ui/button" src/`)

### MUI / Chakra + Constellation Coexistence

These are npm packages that can coexist with Constellation. The main concern is CSS specificity and theme conflicts:

1. Keep MUI/Chakra `ThemeProvider` wrapping only old components
2. Wrap Constellation sections in `ConstellationProvider` or use `injectTheme`
3. As you convert components, the old theme provider scope shrinks
4. Uninstall MUI/Chakra only when zero imports remain

---

## Phase 4: Convert Page by Page

Work through one page at a time, using the migration report's suggested order.

### Conversion Order

1. **App shell** (header, footer, sidebar) — establishes the Constellation foundation
2. **Simplest pages first** (about, settings, static content)
3. **Form-heavy pages** (login, registration, profile edit)
4. **Data-heavy pages** (dashboards, tables, lists)
5. **Complex interactive pages** (search, filters, property detail)

### Per-Page Process

Use the [Page Migration Checklist](page-migration-checklist.md) for each page. The checklist covers pre-flight, imports, components, styling, design rules, testing, and validation evidence.

For detailed before/after code, see the [Component Migration Recipes](../recipes/) — one recipe per component type.

For the 30 most common mistakes, see [Common Pitfalls](common-pitfalls.md).

To find the right component for a UI pattern, see the [Component Decision Tree](component-decision-tree.md).

---

## Component Mapping Table

Use this to find the Constellation equivalent for any existing component:

| Existing Element | Constellation Replacement |
|-----------------|--------------------------|
| Custom button / MUI Button / shadcn Button | `Button` with `icon`/`iconPosition` props |
| Card / Paper / custom container | `Card tone="neutral"` (choose elevated, outlined, or neither) |
| Text input / MUI TextField | `Input` wrapped in `FormField` or `LabeledInput` |
| Select / custom dropdown | `Select`, `DropdownSelect`, or `Combobox` |
| Checkbox | `Checkbox` |
| Radio / RadioGroup | `Radio` inside `FieldSet` |
| Switch / Toggle | `Switch` |
| Modal / Dialog | `Modal` with `header`/`body`/`footer` props |
| Tabs | `Tabs.Root` with `defaultSelected` |
| Accordion / Collapsible | `Accordion` or `Collapsible` |
| Table / DataGrid | `Table` (Table.Root, Table.Header, Table.Body, Table.Row, Table.Cell) |
| Tooltip | `Tooltip` |
| Alert / Toast / Snackbar | `Alert`, `Toast`, or `Banner` |
| Breadcrumb / Pagination | `Pagination` |
| Progress / Loading | `ProgressBar`, `Spinner`, or `LoadingMask` |
| Chip / Tag / Badge | `Tag`, `AssistChip`, `FilterChip`, or `InputChip` |
| Avatar | `Avatar` |
| Divider / HR / border separator | `Divider` (NEVER use CSS borders) |
| Nav bar / Header / AppBar | `Page.Header` (NEVER Box/Flex for headers) |
| Property listing card | `PropertyCard` with `saveButton={<PropertyCard.SaveButton />}` |
| Image carousel / gallery | `PhotoCarousel` or `Carousel` |
| Icon (any library) | Constellation icon from `@zillow/constellation-icons` (Filled by default) |
| Skeleton / placeholder | `Gleam` |
| Star rating | `RatingStars` or `LabeledRatingStars` |

### Gaps — When No 1:1 Match Exists

For UI patterns without a direct Constellation match:

- Use Constellation layout primitives (`Box`, `Flex`, `Grid`) with PandaCSS styling
- Compose from multiple Constellation components
- Check if a Constellation compound component covers the pattern (e.g., `MediaObject` for icon + text layouts)

---

## Common Conversions (Code Examples)

### Buttons

```tsx
// BEFORE (Tailwind + custom)
<button className="bg-blue-500 text-white px-4 py-2 rounded">Save</button>

// AFTER
import { Button } from '@zillow/constellation';
<Button tone="brand" emphasis="filled" size="md">Save</Button>
```

### Buttons with Icons

```tsx
// BEFORE
<button><SearchIcon /> Search</button>

// AFTER — use icon and iconPosition props (NEVER wrap in Flex)
import { Button } from '@zillow/constellation';
import { IconSearchFilled } from '@zillow/constellation-icons';
<Button icon={<IconSearchFilled />} iconPosition="start">Search</Button>
```

### Text and Typography

```tsx
// BEFORE
<h1 className="text-2xl font-bold">Find your home</h1>
<p className="text-gray-600">Browse listings near you.</p>

// AFTER
import { Heading, Text } from '@zillow/constellation';
<Heading textStyle="heading-lg">Find your home</Heading>
<Text textStyle="body" css={{ color: 'text.subtle' }}>Browse listings near you.</Text>
```

### Cards

```tsx
// BEFORE
<div className="shadow rounded-lg p-4 border">
  <h3>Title</h3>
  <p>Content</p>
</div>

// AFTER — clickable card (elevated + interactive)
import { Card, Text } from '@zillow/constellation';
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Text textStyle="body-lg-bold">Title</Text>
  <Text textStyle="body">Content</Text>
</Card>

// AFTER — static display card (outlined, no elevation)
<Card outlined elevated={false} tone="neutral">
  <Text textStyle="body-lg-bold">Title</Text>
  <Text textStyle="body">Content</Text>
</Card>
```

### Form Fields

```tsx
// BEFORE
<label>Email</label>
<input type="email" className="border rounded px-3 py-2" />
<span className="text-red-500">Required</span>

// AFTER
import { LabeledInput } from '@zillow/constellation';
<LabeledInput label="Email" type="email" error="Required" />
```

### Icons

```tsx
// BEFORE (lucide, heroicons, react-icons, etc.)
import { Heart, Search, Home } from 'lucide-react';

// AFTER (always Filled by default)
import { IconHeartFilled, IconSearchFilled, IconHomeFilled } from '@zillow/constellation-icons';
import { Icon } from '@zillow/constellation';
<Icon size="md"><IconHeartFilled /></Icon>
```

### Modals

```tsx
// BEFORE
<Dialog open={isOpen} onClose={handleClose}>
  <DialogTitle>Confirm</DialogTitle>
  <DialogContent>Are you sure?</DialogContent>
  <DialogActions>
    <button onClick={handleClose}>Cancel</button>
    <button onClick={handleConfirm}>Confirm</button>
  </DialogActions>
</Dialog>

// AFTER — content MUST go in body prop, NEVER as children
import { Modal, Heading, Button, TextButton, ButtonGroup } from '@zillow/constellation';
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Confirm</Heading>}
  body={<Text>Are you sure?</Text>}
  footer={
    <ButtonGroup aria-label="modal actions">
      <Modal.Close>
        <TextButton>Cancel</TextButton>
      </Modal.Close>
      <Button emphasis="filled" tone="brand" onClick={handleConfirm}>Confirm</Button>
    </ButtonGroup>
  }
/>
```

### Tabs

```tsx
// BEFORE
<Tabs value={tab} onChange={setTab}>
  <Tab label="Overview" />
  <Tab label="Details" />
</Tabs>

// AFTER — ALWAYS include defaultSelected
import { Tabs } from '@zillow/constellation';
<Tabs.Root defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="details">Details</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">Overview content</Tabs.Panel>
  <Tabs.Panel value="details">Details content</Tabs.Panel>
</Tabs.Root>
```

### Layout (Flexbox / Grid)

```tsx
// BEFORE (Tailwind)
<div className="flex flex-col gap-4">
  <div className="flex justify-between items-center">...</div>
</div>

// AFTER (PandaCSS)
import { Flex } from '@/styled-system/jsx';
<Flex direction="column" gap="400">
  <Flex justify="space-between" align="center">...</Flex>
</Flex>
```

### Dividers

```tsx
// BEFORE
<hr className="border-gray-200 my-4" />
// or
<div style={{ borderBottom: '1px solid #ccc' }} />

// AFTER — NEVER use CSS borders for visual separators
import { Divider } from '@zillow/constellation';
<Divider />
```

### Toast / Notifications

```tsx
// BEFORE (react-hot-toast, notistack, custom, etc.)
<Toaster />
toast.success('Saved!');

// AFTER — wrap app in ToastProvider
import { ToastProvider } from '@zillow/constellation';
<ConstellationProvider>
  <ToastProvider>
    <YourApp />
  </ToastProvider>
</ConstellationProvider>

// Then use Toast in components:
import { Toast } from '@zillow/constellation';
<Toast.Root tone="positive">
  <Toast.Body>Your listing was published.</Toast.Body>
  <Toast.Close />
</Toast.Root>
```

---

## Automated Conversion Tools

### tw2panda — Tailwind to PandaCSS

For projects using Tailwind CSS, `tw2panda` automates class conversion:

```bash
# Install
npm install -D tw2panda

# Convert a single file (preview to stdout)
npx tw2panda rewrite src/components/Button.tsx

# Convert and write to disk
npx tw2panda rewrite src/components/Button.tsx -w

# Convert all files in a directory
npx tw2panda rewrite "src/**/*.tsx" -w

# Use with shorthand properties
npx tw2panda rewrite src/components/Button.tsx -w -s

# Point to your panda config
npx tw2panda rewrite src/** --config ./panda.config.ts -w
```

**What it does:**
- Converts `className="flex flex-col gap-4 p-4"` → PandaCSS `css({ display: 'flex', flexDirection: 'column', gap: '4', p: '4' })`
- Converts CVA (class-variance-authority) patterns → PandaCSS `cva()`
- Reads your Tailwind and PandaCSS configs for accurate mapping

**Online converter:** [tailwind-to-panda.vercel.app](https://tailwind-to-panda.vercel.app/) — paste Tailwind code and get PandaCSS output.

### jscodeshift — AST-Based Component Transforms

For mechanical import renaming and prop swapping, use `jscodeshift`:

```bash
npm install -g jscodeshift
```

**Example: Rename lucide-react icons to Constellation icons**

```js
// transforms/migrate-icons.js
export default function transformer(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);

  const iconMap = {
    Heart: 'IconHeartFilled',
    Search: 'IconSearchFilled',
    Home: 'IconHomeFilled',
    Settings: 'IconSettingsFilled',
    User: 'IconPersonFilled',
    X: 'IconCloseFilled',
    Menu: 'IconMenuFilled',
    ArrowLeft: 'IconArrowLeftFilled',
    ArrowRight: 'IconArrowRightFilled',
    Check: 'IconCheckFilled',
    Edit: 'IconEditFilled',
    Trash: 'IconDeleteFilled',
    Download: 'IconDownloadFilled',
    Upload: 'IconUploadFilled',
    Filter: 'IconFilterFilled',
    Share: 'IconShareFilled',
    Info: 'IconInfoFilled',
    AlertTriangle: 'IconWarningFilled',
    Bell: 'IconNotificationFilled',
    Calendar: 'IconCalendarFilled',
    Clock: 'IconClockFilled',
    MapPin: 'IconLocationFilled',
    Phone: 'IconPhoneFilled',
    Mail: 'IconEmailFilled',
    Camera: 'IconCameraFilled',
    Star: 'IconStarFilled',
    ChevronDown: 'IconChevronDownFilled',
    ChevronUp: 'IconChevronUpFilled',
    ChevronLeft: 'IconChevronLeftFilled',
    ChevronRight: 'IconChevronRightFilled',
    Plus: 'IconAddFilled',
    Minus: 'IconMinusFilled',
    Eye: 'IconVisibilityFilled',
    EyeOff: 'IconVisibilityOffFilled',
    Copy: 'IconCopyFilled',
    ExternalLink: 'IconExternalLinkFilled',
  };

  // Find lucide-react import declarations
  const lucideImports = root.find(j.ImportDeclaration, {
    source: { value: 'lucide-react' },
  });

  if (lucideImports.length === 0) return undefined;

  const constellationSpecifiers = [];

  lucideImports.forEach((path) => {
    path.node.specifiers.forEach((specifier) => {
      const oldName = specifier.imported?.name;
      const newName = iconMap[oldName];
      if (newName) {
        constellationSpecifiers.push(
          j.importSpecifier(j.identifier(newName))
        );
        // Rename all JSX usages of this icon
        root.findJSXElements(specifier.local?.name || oldName).forEach((el) => {
          el.node.openingElement.name = j.jsxIdentifier(newName);
          if (el.node.closingElement) {
            el.node.closingElement.name = j.jsxIdentifier(newName);
          }
        });
      }
    });
  });

  // Remove old lucide-react import
  lucideImports.remove();

  // Add constellation-icons import
  if (constellationSpecifiers.length > 0) {
    const newImport = j.importDeclaration(
      constellationSpecifiers,
      j.literal('@zillow/constellation-icons')
    );
    // Insert at top of file (after existing imports)
    const body = root.find(j.Program).get('body');
    body.value.unshift(newImport);
  }

  return root.toSource();
}
```

Run it:

```bash
jscodeshift -t transforms/migrate-icons.js src/**/*.tsx --parser tsx --dry
# Review the output, then run without --dry to apply
jscodeshift -t transforms/migrate-icons.js src/**/*.tsx --parser tsx
```

**Best practices for codemods:**
- Always run with `--dry` first to preview changes
- Commit before running (so you can `git diff` after)
- Run prettier/linting after (`npm run lint:fix`)
- Test on a single file before running on the whole codebase
- Codemods should be idempotent (safe to run multiple times)

---

## Styling Migration Reference

### Tailwind → PandaCSS

| Tailwind | PandaCSS Equivalent |
|----------|-------------------|
| `className="flex"` | `<Flex>` or `display="flex"` |
| `className="flex-col"` | `<Flex direction="column">` |
| `className="gap-4"` | `gap="400"` |
| `className="p-4"` | `p="400"` |
| `className="m-2"` | `m="200"` |
| `className="text-lg font-bold"` | `<Text textStyle="body-lg-bold">` |
| `className="text-gray-600"` | `css={{ color: 'text.subtle' }}` |
| `className="bg-white"` | `bg="bg.screen.neutral"` |
| `className="rounded-lg"` | `borderRadius="node.md"` |
| `className="shadow-md"` | Use `Card elevated` instead |
| `className="border"` | Use `Card outlined` or `<Divider />` |
| `className="hidden md:block"` | `display={{ base: 'none', md: 'block' }}` |

### Inline Styles → PandaCSS

```tsx
// BEFORE
<div style={{ display: 'flex', gap: '16px', padding: '16px' }}>

// AFTER
import { css } from '@/styled-system/css';
<div className={css({ display: 'flex', gap: '400', p: '400' })}>

// OR use JSX component
import { Flex } from '@/styled-system/jsx';
<Flex gap="400" p="400">
```

---

## Icon Mapping Reference

When replacing icons from other libraries, find the Constellation equivalent:

| Common Icon Name | Constellation (Filled) |
|-----------------|----------------------|
| Search | `IconSearchFilled` |
| Home | `IconHomeFilled` |
| Heart / Favorite | `IconHeartFilled` |
| Settings / Gear | `IconSettingsFilled` |
| User / Person | `IconPersonFilled` |
| Close / X | `IconCloseFilled` |
| Menu / Hamburger | `IconMenuFilled` |
| Arrow Left/Right | `IconArrowLeftFilled` / `IconArrowRightFilled` |
| Check / Checkmark | `IconCheckFilled` |
| Edit / Pencil | `IconEditFilled` |
| Delete / Trash | `IconDeleteFilled` |
| Download | `IconDownloadFilled` |
| Upload | `IconUploadFilled` |
| Filter | `IconFilterFilled` |
| Sort | `IconSortFilled` |
| Share | `IconShareFilled` |
| Info | `IconInfoFilled` |
| Warning | `IconWarningFilled` |
| Error | `IconErrorFilled` |
| Notification / Bell | `IconNotificationFilled` |
| Calendar | `IconCalendarFilled` |
| Clock / Time | `IconClockFilled` |
| Map / Location | `IconLocationFilled` |
| Phone | `IconPhoneFilled` |
| Email / Mail | `IconEmailFilled` |
| Camera | `IconCameraFilled` |
| Star | `IconStarFilled` |

---

## Phase 5: Clean Up

After all pages are converted:

### 5A. Remove Old Dependencies

```bash
npm uninstall tailwindcss @tailwindcss/forms @tailwindcss/typography
npm uninstall @mui/material @mui/icons-material @emotion/react @emotion/styled
npm uninstall @chakra-ui/react @chakra-ui/icons
npm uninstall lucide-react react-icons @heroicons/react
npm uninstall class-variance-authority clsx tailwind-merge
```

### 5B. Remove Old Configuration Files

- `tailwind.config.js` / `tailwind.config.ts`
- `postcss.config.js` (if only used for Tailwind — PandaCSS has its own)
- Old theme files (MUI theme, Chakra theme, etc.)
- `components.json` (shadcn config)
- Old global CSS files that are now empty

### 5C. Remove Old Component Files

If the project had custom UI components (e.g., `components/ui/button.tsx` from shadcn), delete them after confirming all imports now point to Constellation.

### 5D. Clean Imports

```bash
grep -r "from 'lucide-react'" src/
grep -r "from '@mui" src/
grep -r "from 'tailwind" src/
grep -r "className=" src/
```

---

## Phase 6: Validate

Run the validation script:

```bash
bash .agents/skills/transition-to-constellation/references/scripts/validate-migration.sh src
```

This checks:
- No old library imports remain
- No old config files remain
- Constellation is properly installed and configured
- PandaCSS is using `constellationPandaConfig`
- Theme injection is set up
- Design system rules are followed (Divider, Filled icons, Tabs defaultSelected, etc.)

### Manual Checklist

**Design system rules:**
- [ ] `PropertyCard` used for all property listings (with `saveButton`)
- [ ] `Card tone="neutral"` for all generic containers
- [ ] Headers use `Page.Header` (not Box/Flex headers)
- [ ] `Divider` used instead of CSS borders
- [ ] Filled icons by default, wrapped in `<Icon size="md">`
- [ ] `Tabs.Root` includes `defaultSelected`
- [ ] Max 1-2 `Heading` per screen; `Text textStyle` for hierarchy
- [ ] White or Gray backgrounds only (no light blue)
- [ ] Left-aligned by default
- [ ] `size="md"` for buttons/inputs in professional apps

**UX writing:**
- [ ] Sentence case for all UI text
- [ ] Contractions used (we'll, you're, it's)
- [ ] Active voice throughout
- [ ] User = "you", Zillow = "we/us/our"
- [ ] Numerals for all numbers

**No remnants:**
- [ ] No `className` props remain (except on third-party components)
- [ ] No old library imports remain
- [ ] No old CSS/Tailwind files remain
- [ ] `package.json` has no old UI library dependencies
- [ ] App builds and runs without errors
