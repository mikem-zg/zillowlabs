# Migrating Dividers: CSS borders/hr → Constellation

## Constellation component

```tsx
import { Divider } from '@zillow/constellation';
```

---

## Before (shadcn/ui)

```tsx
{/* shadcn Separator */}
import { Separator } from '@/components/ui/separator';

<Separator />
<Separator orientation="vertical" />
<Separator className="my-4" />
```

## Before (MUI)

```tsx
import Divider from '@mui/material/Divider';

<Divider />
<Divider orientation="vertical" flexItem />
<Divider variant="middle" />
<Divider sx={{ my: 2 }} />
<Divider textAlign="center">OR</Divider>
```

## Before (Chakra UI)

```tsx
import { Divider } from '@chakra-ui/react';

<Divider />
<Divider orientation="vertical" />
<Divider borderColor="gray.300" />
```

## Before (Tailwind + HTML)

```tsx
{/* HR element */}
<hr className="border-gray-200 my-4" />

{/* CSS border divider */}
<div className="border-b border-gray-200 my-4" />

{/* Styled border */}
<div style={{ borderBottom: '1px solid #e5e7eb', margin: '16px 0' }} />

{/* Between sections */}
<div className="py-4 border-t border-gray-100">
  <h3>Next section</h3>
</div>

{/* Inline style separator */}
<div style={{ height: 1, backgroundColor: '#ccc', width: '100%' }} />
```

---

## After (Constellation)

```tsx
import { Divider } from '@zillow/constellation';

{/* Standard horizontal divider */}
<Divider />

{/* Between header and content */}
<Page.Header>
  {/* header content */}
</Page.Header>
<Divider />
<Page.Content>
  {/* page content */}
</Page.Content>

{/* Between list items */}
<Flex direction="column">
  <Text>Item 1</Text>
  <Divider />
  <Text>Item 2</Text>
  <Divider />
  <Text>Item 3</Text>
</Flex>

{/* Between sections */}
<Flex direction="column" gap="800">
  <section>{/* Section 1 */}</section>
  <Divider />
  <section>{/* Section 2 */}</section>
</Flex>
```

---

## Required rules

- **NEVER** use CSS `border`, `border-bottom`, `border-top` as visual separators — ALWAYS use `<Divider />`
- **NEVER** use `<hr>` elements — ALWAYS use `<Divider />`
- **NEVER** use styled `<div>` elements with border or background as separators
- ALWAYS use `<Divider />` below `Page.Header`
- ALWAYS use `<Divider />` between list items when visual separation is needed

---

## Anti-patterns

```tsx
// WRONG — CSS border as separator
<div style={{ borderBottom: '1px solid #e5e7eb' }} />

// CORRECT
<Divider />
```

```tsx
// WRONG — HR element
<hr className="my-4" />

// CORRECT
<Divider />
```

```tsx
// WRONG — Tailwind border class as separator
<div className="border-b border-gray-200 my-4" />

// CORRECT
<Divider />
```

```tsx
// WRONG — Box with border for header separator
<Box borderBottom="1px solid" borderColor="gray.200">
  <nav>Header content</nav>
</Box>

// CORRECT — Divider below Page.Header
<Page.Header>
  <nav>Header content</nav>
</Page.Header>
<Divider />
```

```tsx
// WRONG — background color div as separator
<div style={{ height: 1, backgroundColor: '#ccc', width: '100%' }} />

// CORRECT
<Divider />
```

---

## Variants

Constellation `Divider` handles orientation and styling automatically. No manual configuration needed for standard horizontal dividers.

```tsx
{/* Horizontal (default) */}
<Divider />
```

---

## Edge cases

### Divider inside a Card

```tsx
<Card outlined elevated={false} tone="neutral">
  <Text textStyle="body-bold">Section A</Text>
  <Text textStyle="body">Content for section A</Text>
  <Divider />
  <Text textStyle="body-bold">Section B</Text>
  <Text textStyle="body">Content for section B</Text>
</Card>
```

### Divider in Modal (use dividers prop instead)

```tsx
// Don't manually add Divider inside Modal — use the dividers prop
<Modal
  size="md"
  dividers  {/* This adds dividers between header, body, and footer */}
  header={<Heading level={1}>Title</Heading>}
  body={<Text>Content</Text>}
  footer={<Button>Save</Button>}
/>
```

### Divider between form sections

```tsx
<Flex direction="column" gap="600">
  <Flex direction="column" gap="300">
    <Text textStyle="body-lg-bold">Personal info</Text>
    <LabeledInput label="Full name" />
    <LabeledInput label="Email" type="email" />
  </Flex>
  <Divider />
  <Flex direction="column" gap="300">
    <Text textStyle="body-lg-bold">Address</Text>
    <LabeledInput label="Street" />
    <LabeledInput label="City" />
  </Flex>
</Flex>
```
