# Migrating Cards: shadcn/MUI/Tailwind → Constellation

## Constellation component

```tsx
import { Card, Text, Heading } from '@zillow/constellation';
import { Flex } from '@/styled-system/jsx';
```

---

## Before (shadcn/ui)

```tsx
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';

{/* Static info card */}
<Card>
  <CardHeader>
    <CardTitle>Account settings</CardTitle>
    <CardDescription>Manage your account preferences</CardDescription>
  </CardHeader>
  <CardContent>
    <p>Your account details go here.</p>
  </CardContent>
  <CardFooter>
    <Button>Save changes</Button>
  </CardFooter>
</Card>

{/* Clickable card */}
<Card className="cursor-pointer hover:shadow-lg" onClick={handleClick}>
  <CardHeader>
    <CardTitle>View listing</CardTitle>
  </CardHeader>
  <CardContent>
    <p>Click to see details</p>
  </CardContent>
</Card>
```

## Before (MUI)

```tsx
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardActions from '@mui/material/CardActions';
import Paper from '@mui/material/Paper';
import Typography from '@mui/material/Typography';

{/* Card with elevation */}
<Card elevation={3}>
  <CardContent>
    <Typography variant="h6">Account settings</Typography>
    <Typography variant="body2" color="text.secondary">
      Manage your account preferences
    </Typography>
  </CardContent>
  <CardActions>
    <Button size="small">Save</Button>
  </CardActions>
</Card>

{/* Card with outline */}
<Card variant="outlined">
  <CardContent>
    <Typography>Read-only info</Typography>
  </CardContent>
</Card>

{/* Paper as container */}
<Paper elevation={2} sx={{ p: 2 }}>
  <Typography>Container content</Typography>
</Paper>

{/* Clickable card */}
<Card sx={{ cursor: 'pointer' }} onClick={handleClick}>
  <CardContent>
    <Typography>Click me</Typography>
  </CardContent>
</Card>
```

## Before (Chakra UI)

```tsx
import { Card, CardBody, CardHeader, CardFooter } from '@chakra-ui/react';

<Card variant="elevated">
  <CardHeader>
    <Heading size="md">Title</Heading>
  </CardHeader>
  <CardBody>
    <Text>Content here</Text>
  </CardBody>
</Card>

<Card variant="outline">
  <CardBody>
    <Text>Outlined card</Text>
  </CardBody>
</Card>
```

## Before (Tailwind + HTML)

```tsx
{/* Elevated card */}
<div className="bg-white rounded-lg shadow-md p-4 hover:shadow-lg cursor-pointer" onClick={handleClick}>
  <h3 className="text-lg font-bold">Title</h3>
  <p className="text-gray-600">Description</p>
</div>

{/* Outlined card */}
<div className="bg-white rounded-lg border border-gray-200 p-4">
  <h3 className="text-lg font-bold">Title</h3>
  <p className="text-gray-600">Static content</p>
</div>

{/* Minimal card */}
<div className="bg-white rounded-lg p-4">
  <h3 className="text-lg font-bold">Title</h3>
  <p className="text-gray-600">Minimal container</p>
</div>
```

---

## After (Constellation)

### ⚠️ CRITICAL: Three card styles — pick ONE, NEVER combine elevated and outlined

### 1. Elevated + interactive (clickable cards)

Elevated cards MUST be interactive. Use for navigation, links, clickable items.

```tsx
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Flex direction="column" gap="200">
    <Text textStyle="body-bold">View listing</Text>
    <Text textStyle="body" css={{ color: 'text.subtle' }}>Click to see details</Text>
  </Flex>
</Card>
```

### 2. Outlined + elevated={false} (static display cards)

Use for read-only content, info panels, form sections. Must explicitly set `elevated={false}` since `elevated` defaults to `true`.

```tsx
<Card outlined elevated={false} tone="neutral">
  <Flex direction="column" gap="200">
    <Text textStyle="body-bold">Account settings</Text>
    <Text textStyle="body" css={{ color: 'text.subtle' }}>
      Manage your account preferences
    </Text>
  </Flex>
</Card>
```

### 3. Minimal (no shadow, no border)

Use for subtle containers with no visual emphasis.

```tsx
<Card elevated={false} tone="neutral">
  <Flex direction="column" gap="200">
    <Text textStyle="body-bold">Subtle section</Text>
    <Text textStyle="body">Minimal container content</Text>
  </Flex>
</Card>
```

### Card with footer actions

```tsx
<Card outlined elevated={false} tone="neutral" css={{ p: '400' }}>
  <Flex direction="column" gap="300">
    <Text textStyle="body-lg-bold">Account settings</Text>
    <Text textStyle="body" css={{ color: 'text.subtle' }}>
      Manage your account preferences
    </Text>
    <Divider />
    <Flex justify="flex-end" gap="200">
      <Button tone="brand" emphasis="secondary" size="md">Cancel</Button>
      <Button tone="brand" emphasis="filled" size="md">Save changes</Button>
    </Flex>
  </Flex>
</Card>
```

---

## Required rules

- **ALWAYS** set `tone="neutral"` on every Card
- Choose **ONE** style: `elevated` OR `outlined` — **NEVER both**
- Elevated cards **MUST** also be `interactive` (elevated implies clickability)
- Static/display cards use `outlined` with `elevated={false}` (must explicitly disable elevation)
- Use `Text textStyle="body-bold"` for card titles — NOT `Heading` (reserve Heading for 1-2 per screen)
- Use `<Divider />` for separators inside cards — NEVER CSS borders
- Card internal padding uses token `400` (16px)

---

## Anti-patterns

```tsx
// WRONG — combining elevated and outlined
<Card elevated outlined tone="neutral">
  <Text>Content</Text>
</Card>

// CORRECT — pick ONE style
<Card elevated interactive tone="neutral">
  <Text>Clickable content</Text>
</Card>
// OR
<Card outlined elevated={false} tone="neutral">
  <Text>Static content</Text>
</Card>
```

```tsx
// WRONG — elevated card that is NOT interactive
<Card elevated tone="neutral">
  <Text>Static info</Text>
</Card>

// CORRECT — elevated cards MUST be interactive
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Text>Clickable content</Text>
</Card>
// OR for static content, use outlined
<Card outlined elevated={false} tone="neutral">
  <Text>Static info</Text>
</Card>
```

```tsx
// WRONG — missing tone="neutral"
<Card elevated interactive>
  <Text>Content</Text>
</Card>

// CORRECT — always include tone="neutral"
<Card elevated interactive tone="neutral">
  <Text>Content</Text>
</Card>
```

```tsx
// WRONG — using Heading for card title
<Card outlined elevated={false} tone="neutral">
  <Heading>Card title</Heading>
</Card>

// CORRECT — use Text with body-bold for card titles
<Card outlined elevated={false} tone="neutral">
  <Text textStyle="body-bold">Card title</Text>
</Card>
```

```tsx
// WRONG — CSS border as separator inside card
<Card outlined elevated={false} tone="neutral">
  <Text>Section 1</Text>
  <div style={{ borderBottom: '1px solid #ccc' }} />
  <Text>Section 2</Text>
</Card>

// CORRECT — use Divider component
<Card outlined elevated={false} tone="neutral">
  <Text>Section 1</Text>
  <Divider />
  <Text>Section 2</Text>
</Card>
```

---

## Variants

### Card styling decision tree

| Scenario | Style | Props |
|----------|-------|-------|
| User clicks to navigate | Elevated | `elevated interactive tone="neutral"` |
| Display read-only info | Outlined | `outlined elevated={false} tone="neutral"` |
| Subtle background group | Minimal | `elevated={false} tone="neutral"` |

### Card with padding

```tsx
<Card outlined elevated={false} tone="neutral" css={{ p: '400' }}>
  <Text>Padded content</Text>
</Card>
```

### Card grid layout

```tsx
import { Grid } from '@/styled-system/jsx';

<Grid columns={3} gap="400">
  <Card elevated interactive tone="neutral" onClick={() => navigate('/a')}>
    <Text textStyle="body-bold">Option A</Text>
  </Card>
  <Card elevated interactive tone="neutral" onClick={() => navigate('/b')}>
    <Text textStyle="body-bold">Option B</Text>
  </Card>
  <Card elevated interactive tone="neutral" onClick={() => navigate('/c')}>
    <Text textStyle="body-bold">Option C</Text>
  </Card>
</Grid>
```

---

## Edge cases

### Property listings — use PropertyCard, NOT Card

```tsx
// WRONG — using Card for property listings
<Card elevated interactive tone="neutral">
  <img src={photo} />
  <Text>$450,000</Text>
  <Text>3 bd | 2 ba | 1,500 sqft</Text>
</Card>

// CORRECT — ALWAYS use PropertyCard for property listings
<PropertyCard
  saveButton={<PropertyCard.SaveButton />}
  data={{
    dataArea1: '$450,000',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: 3, label: 'bd' },
      { value: 2, label: 'ba' },
      { value: '1,500', label: 'sqft' }
    ]} />,
    dataArea3: '123 Main St, Seattle, WA 98101'
  }}
  elevated
  interactive
  onClick={handleClick}
/>
```

### Card with no content padding (edge-to-edge image)

```tsx
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <img src={imageUrl} alt="Preview" style={{ width: '100%', borderRadius: '12px 12px 0 0' }} />
  <Flex direction="column" gap="200" css={{ p: '400' }}>
    <Text textStyle="body-bold">Title</Text>
    <Text textStyle="body" css={{ color: 'text.subtle' }}>Description</Text>
  </Flex>
</Card>
```

### Nested cards

```tsx
<Card outlined elevated={false} tone="neutral" css={{ p: '400' }}>
  <Text textStyle="body-lg-bold">Section</Text>
  <Flex direction="column" gap="300">
    <Card elevated interactive tone="neutral" onClick={handleItemClick}>
      <Text textStyle="body-bold">Nested clickable item</Text>
    </Card>
  </Flex>
</Card>
```
