# Migrating Buttons: shadcn/MUI/Tailwind → Constellation

## Constellation components

```tsx
import { Button, IconButton, TextButton, ButtonGroup } from '@zillow/constellation';
import { IconSearchFilled, IconAddFilled, IconDeleteFilled } from '@zillow/constellation-icons';
```

---

## Before (shadcn/ui)

```tsx
import { Button } from '@/components/ui/button';
import { Search, Plus, Trash2 } from 'lucide-react';

<Button variant="default">Save</Button>
<Button variant="secondary">Cancel</Button>
<Button variant="destructive">Delete</Button>
<Button variant="outline">Edit</Button>
<Button variant="ghost">More</Button>
<Button disabled>Disabled</Button>
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>

{/* Icon button */}
<Button variant="default">
  <Search className="mr-2 h-4 w-4" />
  Search
</Button>

{/* Icon-only */}
<Button variant="ghost" size="icon">
  <Plus className="h-4 w-4" />
</Button>
```

## Before (MUI)

```tsx
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import ButtonGroup from '@mui/material/ButtonGroup';
import SearchIcon from '@mui/icons-material/Search';
import AddIcon from '@mui/icons-material/Add';
import DeleteIcon from '@mui/icons-material/Delete';

<Button variant="contained">Save</Button>
<Button variant="outlined">Cancel</Button>
<Button variant="text">More</Button>
<Button variant="contained" color="error">Delete</Button>
<Button disabled>Disabled</Button>
<Button size="small">Small</Button>
<Button size="large">Large</Button>

{/* Icon button */}
<Button variant="contained" startIcon={<SearchIcon />}>
  Search
</Button>

{/* Icon-only */}
<IconButton>
  <AddIcon />
</IconButton>

{/* Button group */}
<ButtonGroup variant="contained">
  <Button>One</Button>
  <Button>Two</Button>
</ButtonGroup>
```

## Before (Chakra UI)

```tsx
import { Button, IconButton, ButtonGroup } from '@chakra-ui/react';
import { SearchIcon, AddIcon, DeleteIcon } from '@chakra-ui/icons';

<Button colorScheme="blue">Save</Button>
<Button variant="outline">Cancel</Button>
<Button colorScheme="red">Delete</Button>
<Button isDisabled>Disabled</Button>
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>

<Button leftIcon={<SearchIcon />}>Search</Button>

<IconButton aria-label="Add" icon={<AddIcon />} />

<ButtonGroup spacing={2}>
  <Button>One</Button>
  <Button>Two</Button>
</ButtonGroup>
```

## Before (Tailwind + HTML)

```tsx
<button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
  Save
</button>
<button className="border border-gray-300 px-4 py-2 rounded-lg hover:bg-gray-50">
  Cancel
</button>
<button className="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700">
  Delete
</button>
<button className="bg-blue-600 text-white px-4 py-2 rounded-lg" disabled>
  Disabled
</button>

{/* Icon button */}
<button className="bg-blue-600 text-white px-4 py-2 rounded-lg flex items-center gap-2">
  <svg>...</svg>
  Search
</button>
```

---

## After (Constellation)

### Primary button

```tsx
<Button tone="brand" emphasis="filled" size="md">
  Save
</Button>
```

### Secondary button

```tsx
<Button tone="brand" emphasis="secondary" size="md">
  Cancel
</Button>
```

### Destructive button

```tsx
<Button tone="critical" emphasis="filled" size="md">
  Delete
</Button>
```

### Button with icon (use icon + iconPosition props)

```tsx
<Button
  tone="brand"
  emphasis="filled"
  size="md"
  icon={<IconSearchFilled />}
  iconPosition="start"
>
  Search
</Button>
```

### Icon-only button

```tsx
<IconButton tone="brand" emphasis="filled" size="md" aria-label="Add item">
  <IconAddFilled />
</IconButton>
```

### Text button (minimal/ghost)

```tsx
<TextButton size="md">More options</TextButton>
```

### Button group

```tsx
<ButtonGroup aria-label="Actions">
  <Button tone="brand" emphasis="filled" size="md">Save</Button>
  <Button tone="brand" emphasis="secondary" size="md">Cancel</Button>
</ButtonGroup>
```

### Disabled button

```tsx
<Button tone="brand" emphasis="filled" size="md" disabled>
  Disabled
</Button>
```

---

## Required rules

- Professional apps ALWAYS use `size="md"` for buttons
- Use `icon` and `iconPosition` props for icons — NEVER wrap icons and text in Flex inside a Button
- Use `tone="brand"` for primary actions with `emphasis="filled"`
- Use `emphasis="secondary"` for secondary actions — NEVER use filled for everything
- Use `tone="critical"` for destructive actions
- ALWAYS use Filled icon variants (`IconSearchFilled`, NOT `IconSearchOutline`)
- NEVER use `Button` for selection/toggle UI — use `ToggleButtonGroup`, `SegmentedControl`, or `CheckboxGroup` instead

---

## Anti-patterns

```tsx
// WRONG — wrapping icon + text in Flex inside Button
<Button>
  <Flex>
    <Icon><IconSearchFilled /></Icon>
    <Text>Search</Text>
  </Flex>
</Button>

// CORRECT — use icon and iconPosition props
<Button icon={<IconSearchFilled />} iconPosition="start">
  Search
</Button>
```

```tsx
// WRONG — using Button for toggle/selection
<Button onClick={() => setFilter('sale')}>For sale</Button>
<Button onClick={() => setFilter('rent')}>For rent</Button>

// CORRECT — use ToggleButtonGroup for selection
<ToggleButtonGroup value={filter} onChange={setFilter}>
  <ToggleButton value="sale">For sale</ToggleButton>
  <ToggleButton value="rent">For rent</ToggleButton>
</ToggleButtonGroup>
```

```tsx
// WRONG — inconsistent sizes
<Button size="sm">Save</Button>
<Button size="lg">Cancel</Button>

// CORRECT — consistent size="md" for professional apps
<Button tone="brand" emphasis="filled" size="md">Save</Button>
<Button tone="brand" emphasis="secondary" size="md">Cancel</Button>
```

---

## Variants

### Sizes

```tsx
<Button size="sm">Small</Button>   {/* Use sparingly */}
<Button size="md">Medium</Button>  {/* Default for professional apps */}
<Button size="lg">Large</Button>   {/* Hero CTAs */}
```

### Tones

```tsx
<Button tone="brand" emphasis="filled">Primary action</Button>
<Button tone="brand" emphasis="secondary">Secondary action</Button>
<Button tone="critical" emphasis="filled">Destructive action</Button>
<Button tone="neutral" emphasis="secondary">Neutral action</Button>
```

### Emphasis levels

```tsx
<Button tone="brand" emphasis="filled">Filled (primary)</Button>
<Button tone="brand" emphasis="secondary">Secondary</Button>
```

### Icon positions

```tsx
<Button icon={<IconSearchFilled />} iconPosition="start">Start icon</Button>
<Button icon={<IconArrowRightFilled />} iconPosition="end">End icon</Button>
```

---

## Edge cases

### Loading state

```tsx
<Button tone="brand" emphasis="filled" size="md" disabled>
  <Spinner size="sm" /> Saving...
</Button>
```

### Full-width button

```tsx
<Button tone="brand" emphasis="filled" size="md" css={{ width: '100%' }}>
  Continue
</Button>
```

### Button as link

```tsx
<Button tone="brand" emphasis="filled" size="md" as="a" href="/next">
  Continue
</Button>
```

### Icon button with tooltip

```tsx
<Tooltip content="Delete item">
  <IconButton tone="critical" emphasis="secondary" size="md" aria-label="Delete">
    <IconDeleteFilled />
  </IconButton>
</Tooltip>
```
