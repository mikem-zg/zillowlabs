# Migrating Tags & Badges: shadcn Badge/MUI Chip/Custom Labels → Constellation

## Constellation components

```tsx
import { Tag, AssistChip, FilterChip, InputChip, ChipGroup } from '@zillow/constellation';
```

---

## Before (shadcn/ui)

```tsx
import { Badge } from '@/components/ui/badge';

<Badge>Default</Badge>
<Badge variant="secondary">Secondary</Badge>
<Badge variant="destructive">Error</Badge>
<Badge variant="outline">Outline</Badge>

{/* Custom status labels */}
<div className="inline-flex items-center rounded-full bg-green-100 px-2.5 py-0.5 text-xs font-medium text-green-800">
  Active
</div>
<div className="inline-flex items-center rounded-full bg-blue-100 px-2.5 py-0.5 text-xs font-medium text-blue-800">
  New
</div>
```

## Before (MUI)

```tsx
import Chip from '@mui/material/Chip';
import Avatar from '@mui/material/Avatar';
import DeleteIcon from '@mui/icons-material/Delete';

{/* Basic chips */}
<Chip label="Active" color="success" size="small" />
<Chip label="Pending" color="warning" size="small" />
<Chip label="Error" color="error" size="small" />

{/* Deletable chip */}
<Chip label="React" onDelete={handleDelete} />

{/* Clickable chip */}
<Chip label="Filter: 3+ beds" onClick={handleClick} variant="outlined" />

{/* Chip with avatar */}
<Chip avatar={<Avatar>J</Avatar>} label="John Doe" />

{/* Chip group */}
<Stack direction="row" spacing={1}>
  <Chip label="JavaScript" />
  <Chip label="TypeScript" />
  <Chip label="React" />
</Stack>
```

## Before (Chakra UI)

```tsx
import { Badge, Tag, TagLabel, TagCloseButton, Wrap, WrapItem } from '@chakra-ui/react';

<Badge colorScheme="green">Active</Badge>
<Badge colorScheme="blue">New</Badge>
<Badge colorScheme="red">Error</Badge>

<Tag size="md" colorScheme="teal">
  <TagLabel>React</TagLabel>
  <TagCloseButton />
</Tag>

<Wrap>
  <WrapItem><Tag>JavaScript</Tag></WrapItem>
  <WrapItem><Tag>TypeScript</Tag></WrapItem>
</Wrap>
```

## Before (Tailwind + HTML)

```tsx
{/* Custom badge/label */}
<span className="inline-flex items-center rounded-full bg-blue-100 px-2.5 py-0.5 text-xs font-medium text-blue-800">
  New
</span>

{/* Custom tag with close */}
<span className="inline-flex items-center gap-1 rounded-full bg-gray-100 px-3 py-1 text-sm">
  React
  <button className="ml-1 text-gray-500 hover:text-gray-700" onClick={handleRemove}>×</button>
</span>

{/* Status dot + label */}
<div className="flex items-center gap-2">
  <span className="h-2 w-2 rounded-full bg-green-500"></span>
  <span className="text-sm text-gray-600">Active</span>
</div>

{/* Filter chips */}
<div className="flex flex-wrap gap-2">
  <button className="rounded-full border px-3 py-1 text-sm hover:bg-gray-100">3+ beds</button>
  <button className="rounded-full border px-3 py-1 text-sm bg-blue-50 border-blue-300">$200k-$400k</button>
</div>
```

---

## After (Constellation)

### Status labels/badges → Tag

```tsx
import { Tag } from '@zillow/constellation';

<Tag size="sm" tone="blue">New</Tag>
<Tag size="sm" tone="green">Active</Tag>
<Tag size="sm" tone="red">Error</Tag>
<Tag size="sm" tone="neutral">Draft</Tag>
<Tag size="sm" tone="orange">Pending</Tag>
```

### Tag with nowrap (recommended)

```tsx
<Tag size="sm" tone="blue" css={{ whiteSpace: 'nowrap' }}>New listing</Tag>
```

### Dismissible tag → InputChip

```tsx
import { InputChip } from '@zillow/constellation';

<InputChip onDismiss={handleRemove}>React</InputChip>
<InputChip onDismiss={handleRemove}>TypeScript</InputChip>
```

### Clickable action tag → AssistChip

```tsx
import { AssistChip } from '@zillow/constellation';

<AssistChip onClick={handleClick}>Add filter</AssistChip>
<AssistChip onClick={handleAddTag}>Add tag</AssistChip>
```

### Toggle filter → FilterChip

```tsx
import { FilterChip, ChipGroup } from '@zillow/constellation';

<ChipGroup>
  <FilterChip selected={filters.beds} onChange={() => toggleFilter('beds')}>
    3+ beds
  </FilterChip>
  <FilterChip selected={filters.price} onChange={() => toggleFilter('price')}>
    $200k–$400k
  </FilterChip>
  <FilterChip selected={filters.pool} onChange={() => toggleFilter('pool')}>
    Pool
  </FilterChip>
</ChipGroup>
```

### Group of tags

```tsx
import { Flex } from '@/styled-system/jsx';

<Flex gap="200" flexWrap="wrap">
  <Tag size="sm" tone="blue">For sale</Tag>
  <Tag size="sm" tone="green">Active</Tag>
  <Tag size="sm" tone="orange">Open house</Tag>
</Flex>
```

---

## Component selection guide

| Use case | Constellation component |
|----------|------------------------|
| Status labels, categories, metadata display | `Tag` |
| Removable/dismissible tokens (selected items) | `InputChip` |
| Clickable action (opens a flow) | `AssistChip` |
| Toggle on/off filter | `FilterChip` |
| Filter chip with dropdown menu | `FilterChipWithMenu` |
| Group of chips | `ChipGroup` |

---

## Required rules

- ALWAYS use `Tag` for status labels, categories, and metadata — NEVER custom `Box` with `bg`/`borderRadius`/`padding`
- ALWAYS use `size="sm"` on Tag for standard inline labels
- Use `tone` to convey meaning: `blue` (info), `green` (success), `red` (error), `orange` (warning), `neutral` (default)
- Add `css={{ whiteSpace: 'nowrap' }}` to Tag when text should not wrap
- Use `FilterChip` for toggleable filters, NOT styled `Button` components
- Use `InputChip` for removable items (like selected tags in a form), NOT custom close-button spans

---

## Anti-patterns

```tsx
// WRONG — custom Box with bg/borderRadius/padding for labels
<Box
  css={{
    display: 'inline-flex',
    bg: 'blue.100',
    borderRadius: 'full',
    px: '200',
    py: '50'
  }}
>
  <Text textStyle="body-sm">New</Text>
</Box>

// CORRECT — use Tag component
<Tag size="sm" tone="blue">New</Tag>
```

```tsx
// WRONG — using Button for filter toggles
<Button
  variant={isActive ? 'default' : 'outline'}
  size="sm"
  onClick={toggleFilter}
>
  3+ beds
</Button>

// CORRECT — use FilterChip
<FilterChip selected={isActive} onChange={toggleFilter}>
  3+ beds
</FilterChip>
```

```tsx
// WRONG — custom span with close button for removable items
<span className="inline-flex items-center gap-1 bg-gray-100 rounded-full px-3 py-1">
  React
  <button onClick={handleRemove}>×</button>
</span>

// CORRECT — use InputChip
<InputChip onDismiss={handleRemove}>React</InputChip>
```

```tsx
// WRONG — Tailwind classes for status badge
<span className="rounded-full bg-green-100 px-2 py-0.5 text-xs text-green-800">Active</span>

// CORRECT
<Tag size="sm" tone="green">Active</Tag>
```

---

## Variants

### Tag tones

```tsx
<Tag size="sm" tone="blue">Info</Tag>
<Tag size="sm" tone="green">Success</Tag>
<Tag size="sm" tone="red">Error</Tag>
<Tag size="sm" tone="orange">Warning</Tag>
<Tag size="sm" tone="neutral">Default</Tag>
```

### Tag sizes

```tsx
<Tag size="sm">Small (default for labels)</Tag>
<Tag size="md">Medium</Tag>
```

### FilterChip states

```tsx
<FilterChip selected={false} onChange={toggle}>Unselected</FilterChip>
<FilterChip selected={true} onChange={toggle}>Selected</FilterChip>
<FilterChip disabled>Disabled</FilterChip>
```

---

## Edge cases

### Tag inside a Card

```tsx
<Card outlined elevated={false} tone="neutral">
  <Flex direction="column" gap="200">
    <Flex justify="space-between" align="center">
      <Text textStyle="body-bold">Listing details</Text>
      <Tag size="sm" tone="green">Active</Tag>
    </Flex>
    <Text textStyle="body" css={{ color: 'text.subtle' }}>
      This listing is currently visible to buyers.
    </Text>
  </Flex>
</Card>
```

### Multiple filter chips in a filter bar

```tsx
<Flex align="center" gap="200" flexWrap="wrap">
  <FilterChip selected={filters.beds} onChange={() => toggle('beds')}>
    3+ beds
  </FilterChip>
  <FilterChip selected={filters.baths} onChange={() => toggle('baths')}>
    2+ baths
  </FilterChip>
  <FilterChip selected={filters.price} onChange={() => toggle('price')}>
    Under $300k
  </FilterChip>
  <FilterChip selected={filters.newListing} onChange={() => toggle('newListing')}>
    New listings
  </FilterChip>
</Flex>
```

### InputChip for selected search terms

```tsx
<Flex gap="200" flexWrap="wrap" align="center">
  {selectedTerms.map((term) => (
    <InputChip key={term} onDismiss={() => removeTerm(term)}>
      {term}
    </InputChip>
  ))}
</Flex>
```

### Tag on PropertyCard (use PropertyCard.Badge, not Tag)

```tsx
// Note: For badges ON a PropertyCard, use PropertyCard.Badge — not Tag
<PropertyCard
  badge={<PropertyCard.Badge tone="notify">New listing</PropertyCard.Badge>}
  saveButton={<PropertyCard.SaveButton />}
  ...
/>
```
