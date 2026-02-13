# Migrating Tabs: shadcn/MUI/Radix → Constellation

## Constellation component

```tsx
import { Tabs } from '@zillow/constellation';
```

---

## Before (shadcn/ui)

```tsx
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';

<Tabs defaultValue="overview">
  <TabsList>
    <TabsTrigger value="overview">Overview</TabsTrigger>
    <TabsTrigger value="details">Details</TabsTrigger>
    <TabsTrigger value="reviews">Reviews</TabsTrigger>
  </TabsList>
  <TabsContent value="overview">
    <p>Overview content goes here.</p>
  </TabsContent>
  <TabsContent value="details">
    <p>Details content goes here.</p>
  </TabsContent>
  <TabsContent value="reviews">
    <p>Reviews content goes here.</p>
  </TabsContent>
</Tabs>
```

## Before (MUI)

```tsx
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Box from '@mui/material/Box';

const [value, setValue] = useState(0);

<Box>
  <Tabs value={value} onChange={(e, v) => setValue(v)}>
    <Tab label="Overview" />
    <Tab label="Details" />
    <Tab label="Reviews" />
  </Tabs>
  {value === 0 && <div>Overview content</div>}
  {value === 1 && <div>Details content</div>}
  {value === 2 && <div>Reviews content</div>}
</Box>
```

## Before (Radix Tabs)

```tsx
import * as Tabs from '@radix-ui/react-tabs';

<Tabs.Root defaultValue="overview">
  <Tabs.List className="flex border-b">
    <Tabs.Trigger value="overview" className="px-4 py-2 border-b-2 data-[state=active]:border-blue-500">
      Overview
    </Tabs.Trigger>
    <Tabs.Trigger value="details" className="px-4 py-2 border-b-2 data-[state=active]:border-blue-500">
      Details
    </Tabs.Trigger>
    <Tabs.Trigger value="reviews" className="px-4 py-2 border-b-2 data-[state=active]:border-blue-500">
      Reviews
    </Tabs.Trigger>
  </Tabs.List>
  <Tabs.Content value="overview">Overview content</Tabs.Content>
  <Tabs.Content value="details">Details content</Tabs.Content>
  <Tabs.Content value="reviews">Reviews content</Tabs.Content>
</Tabs.Root>
```

## Before (Tailwind + HTML)

```tsx
const [activeTab, setActiveTab] = useState('overview');

<div>
  <div className="flex border-b">
    <button
      className={`px-4 py-2 ${activeTab === 'overview' ? 'border-b-2 border-blue-500 text-blue-600' : 'text-gray-500'}`}
      onClick={() => setActiveTab('overview')}
    >
      Overview
    </button>
    <button
      className={`px-4 py-2 ${activeTab === 'details' ? 'border-b-2 border-blue-500 text-blue-600' : 'text-gray-500'}`}
      onClick={() => setActiveTab('details')}
    >
      Details
    </button>
    <button
      className={`px-4 py-2 ${activeTab === 'reviews' ? 'border-b-2 border-blue-500 text-blue-600' : 'text-gray-500'}`}
      onClick={() => setActiveTab('reviews')}
    >
      Reviews
    </button>
  </div>
  <div className="p-4">
    {activeTab === 'overview' && <p>Overview content</p>}
    {activeTab === 'details' && <p>Details content</p>}
    {activeTab === 'reviews' && <p>Reviews content</p>}
  </div>
</div>
```

---

## After (Constellation)

### ⚠️ CRITICAL: ALWAYS use `defaultSelected` (NOT `defaultValue`)

### Uncontrolled tabs (recommended default)

```tsx
<Tabs.Root defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="details">Details</Tabs.Tab>
    <Tabs.Tab value="reviews">Reviews</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">
    <Text textStyle="body">Overview content goes here.</Text>
  </Tabs.Panel>
  <Tabs.Panel value="details">
    <Text textStyle="body">Details content goes here.</Text>
  </Tabs.Panel>
  <Tabs.Panel value="reviews">
    <Text textStyle="body">Reviews content goes here.</Text>
  </Tabs.Panel>
</Tabs.Root>
```

### Controlled tabs (when you need external state)

```tsx
const [selected, setSelected] = useState('overview');

<Tabs.Root defaultSelected="overview" selected={selected} onSelectedChange={setSelected}>
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="details">Details</Tabs.Tab>
    <Tabs.Tab value="reviews">Reviews</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">
    <Text textStyle="body">Overview content</Text>
  </Tabs.Panel>
  <Tabs.Panel value="details">
    <Text textStyle="body">Details content</Text>
  </Tabs.Panel>
  <Tabs.Panel value="reviews">
    <Text textStyle="body">Reviews content</Text>
  </Tabs.Panel>
</Tabs.Root>
```

---

## Required rules

- **ALWAYS** include `defaultSelected` prop — Tabs must have a tab selected by default
- Use `defaultSelected` — **NOT** `defaultValue` (common mistake from shadcn/Radix migration)
- Structure: `Tabs.Root` > `Tabs.List` > `Tabs.Tab` (tabs) + `Tabs.Panel` (content)
- Each `Tabs.Tab` must have a `value` prop matching its corresponding `Tabs.Panel`
- Even controlled tabs should include `defaultSelected` for SSR/initial render

---

## Anti-patterns

```tsx
// WRONG — using defaultValue (shadcn/Radix habit)
<Tabs.Root defaultValue="overview">
  ...
</Tabs.Root>

// CORRECT — use defaultSelected
<Tabs.Root defaultSelected="overview">
  ...
</Tabs.Root>
```

```tsx
// WRONG — no defaultSelected at all
<Tabs.Root>
  <Tabs.List>
    <Tabs.Tab value="tab1">Tab 1</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="tab1">Content</Tabs.Panel>
</Tabs.Root>

// CORRECT — always set defaultSelected
<Tabs.Root defaultSelected="tab1">
  <Tabs.List>
    <Tabs.Tab value="tab1">Tab 1</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="tab1">Content</Tabs.Panel>
</Tabs.Root>
```

```tsx
// WRONG — numeric indices (MUI pattern)
<Tabs.Root defaultSelected={0}>
  <Tabs.Tab value={0}>Tab</Tabs.Tab>
</Tabs.Root>

// CORRECT — string values
<Tabs.Root defaultSelected="tab1">
  <Tabs.Tab value="tab1">Tab</Tabs.Tab>
</Tabs.Root>
```

```tsx
// WRONG — mismatched Tab and Panel values
<Tabs.Root defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="tab1">Content</Tabs.Panel>  {/* "tab1" doesn't match "overview" */}
</Tabs.Root>

// CORRECT — matching values
<Tabs.Root defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">Content</Tabs.Panel>
</Tabs.Root>
```

---

## Variants

### Two tabs

```tsx
<Tabs.Root defaultSelected="buy">
  <Tabs.List>
    <Tabs.Tab value="buy">Buy</Tabs.Tab>
    <Tabs.Tab value="rent">Rent</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="buy">
    <Text textStyle="body">Search homes for sale</Text>
  </Tabs.Panel>
  <Tabs.Panel value="rent">
    <Text textStyle="body">Search rental listings</Text>
  </Tabs.Panel>
</Tabs.Root>
```

### Many tabs

```tsx
<Tabs.Root defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="facts">Facts & features</Tabs.Tab>
    <Tabs.Tab value="price">Price history</Tabs.Tab>
    <Tabs.Tab value="tax">Tax history</Tabs.Tab>
    <Tabs.Tab value="neighborhood">Neighborhood</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">...</Tabs.Panel>
  <Tabs.Panel value="facts">...</Tabs.Panel>
  <Tabs.Panel value="price">...</Tabs.Panel>
  <Tabs.Panel value="tax">...</Tabs.Panel>
  <Tabs.Panel value="neighborhood">...</Tabs.Panel>
</Tabs.Root>
```

### Disabled tab

```tsx
<Tabs.Root defaultSelected="active">
  <Tabs.List>
    <Tabs.Tab value="active">Active listings</Tabs.Tab>
    <Tabs.Tab value="pending">Pending</Tabs.Tab>
    <Tabs.Tab value="archived" disabled>Archived</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="active">Active content</Tabs.Panel>
  <Tabs.Panel value="pending">Pending content</Tabs.Panel>
  <Tabs.Panel value="archived">Archived content</Tabs.Panel>
</Tabs.Root>
```

---

## Edge cases

### Tabs with rich panel content

```tsx
<Tabs.Root defaultSelected="overview">
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="details">Details</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">
    <Flex direction="column" gap="400" css={{ pt: '400' }}>
      <Text textStyle="body-lg-bold">Property overview</Text>
      <Card outlined elevated={false} tone="neutral" css={{ p: '400' }}>
        <Text textStyle="body">Key facts about the property.</Text>
      </Card>
      <Card outlined elevated={false} tone="neutral" css={{ p: '400' }}>
        <Text textStyle="body">Neighborhood information.</Text>
      </Card>
    </Flex>
  </Tabs.Panel>
  <Tabs.Panel value="details">
    <Flex direction="column" gap="400" css={{ pt: '400' }}>
      <Text textStyle="body-lg-bold">Detailed facts</Text>
      <Text textStyle="body">Lot size, year built, HOA, etc.</Text>
    </Flex>
  </Tabs.Panel>
</Tabs.Root>
```

### Tabs with data fetching on tab change

```tsx
const [selected, setSelected] = useState('overview');

const handleTabChange = (value: string) => {
  setSelected(value);
  if (value === 'reviews' && !reviewsLoaded) {
    fetchReviews();
  }
};

<Tabs.Root defaultSelected="overview" selected={selected} onSelectedChange={handleTabChange}>
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="reviews">Reviews</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">
    <Text textStyle="body">Overview content</Text>
  </Tabs.Panel>
  <Tabs.Panel value="reviews">
    {reviewsLoading ? <Spinner /> : <Text textStyle="body">Reviews content</Text>}
  </Tabs.Panel>
</Tabs.Root>
```

### Migration from MUI numeric indices

When migrating from MUI's numeric tab indices, assign descriptive string values:

```tsx
// MUI (numeric indices)
const [value, setValue] = useState(0);
<Tabs value={value} onChange={(e, v) => setValue(v)}>
  <Tab label="Overview" />     {/* index 0 */}
  <Tab label="Details" />      {/* index 1 */}
</Tabs>

// Constellation (descriptive string values)
const [selected, setSelected] = useState('overview');
<Tabs.Root defaultSelected="overview" selected={selected} onSelectedChange={setSelected}>
  <Tabs.List>
    <Tabs.Tab value="overview">Overview</Tabs.Tab>
    <Tabs.Tab value="details">Details</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="overview">...</Tabs.Panel>
  <Tabs.Panel value="details">...</Tabs.Panel>
</Tabs.Root>
```
