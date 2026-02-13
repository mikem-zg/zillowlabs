# Migrating Tables: shadcn/MUI/HTML → Constellation

## Constellation component

```tsx
import { Table } from '@zillow/constellation';
```

Sub-components: `Table.Root`, `Table.Header`, `Table.Body`, `Table.Row`, `Table.Cell`, `Table.HeaderCell`

---

## Before (shadcn/ui)

```tsx
import {
  Table, TableBody, TableCaption, TableCell,
  TableHead, TableHeader, TableRow
} from '@/components/ui/table';

<Table>
  <TableCaption>Recent transactions</TableCaption>
  <TableHeader>
    <TableRow>
      <TableHead>Date</TableHead>
      <TableHead>Description</TableHead>
      <TableHead>Amount</TableHead>
      <TableHead>Status</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    <TableRow>
      <TableCell>2024-01-15</TableCell>
      <TableCell>Rent payment</TableCell>
      <TableCell>$2,450.00</TableCell>
      <TableCell>
        <span className="text-green-600 bg-green-50 px-2 py-1 rounded">Completed</span>
      </TableCell>
    </TableRow>
    <TableRow>
      <TableCell>2024-01-10</TableCell>
      <TableCell>Security deposit</TableCell>
      <TableCell>$4,900.00</TableCell>
      <TableCell>
        <span className="text-yellow-600 bg-yellow-50 px-2 py-1 rounded">Pending</span>
      </TableCell>
    </TableRow>
  </TableBody>
</Table>
```

## Before (MUI)

```tsx
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';

<TableContainer component={Paper}>
  <Table>
    <TableHead>
      <TableRow>
        <TableCell>Date</TableCell>
        <TableCell>Description</TableCell>
        <TableCell align="right">Amount</TableCell>
        <TableCell>Status</TableCell>
      </TableRow>
    </TableHead>
    <TableBody>
      <TableRow>
        <TableCell>2024-01-15</TableCell>
        <TableCell>Rent payment</TableCell>
        <TableCell align="right">$2,450.00</TableCell>
        <TableCell>Completed</TableCell>
      </TableRow>
      <TableRow>
        <TableCell>2024-01-10</TableCell>
        <TableCell>Security deposit</TableCell>
        <TableCell align="right">$4,900.00</TableCell>
        <TableCell>Pending</TableCell>
      </TableRow>
    </TableBody>
  </Table>
</TableContainer>
```

### MUI DataGrid

```tsx
import { DataGrid } from '@mui/x-data-grid';

const columns = [
  { field: 'date', headerName: 'Date', width: 150 },
  { field: 'description', headerName: 'Description', width: 250 },
  { field: 'amount', headerName: 'Amount', width: 150 },
  { field: 'status', headerName: 'Status', width: 130 },
];

const rows = [
  { id: 1, date: '2024-01-15', description: 'Rent payment', amount: '$2,450.00', status: 'Completed' },
  { id: 2, date: '2024-01-10', description: 'Security deposit', amount: '$4,900.00', status: 'Pending' },
];

<DataGrid rows={rows} columns={columns} pageSize={10} />
```

## Before (Tailwind + HTML)

```tsx
<div className="overflow-x-auto">
  <table className="min-w-full divide-y divide-gray-200">
    <thead className="bg-gray-50">
      <tr>
        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Description</th>
        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Amount</th>
        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
      </tr>
    </thead>
    <tbody className="bg-white divide-y divide-gray-200">
      <tr>
        <td className="px-6 py-4 whitespace-nowrap text-sm">2024-01-15</td>
        <td className="px-6 py-4 whitespace-nowrap text-sm">Rent payment</td>
        <td className="px-6 py-4 whitespace-nowrap text-sm text-right">$2,450.00</td>
        <td className="px-6 py-4 whitespace-nowrap">
          <span className="px-2 py-1 text-xs rounded-full bg-green-100 text-green-800">Completed</span>
        </td>
      </tr>
      <tr>
        <td className="px-6 py-4 whitespace-nowrap text-sm">2024-01-10</td>
        <td className="px-6 py-4 whitespace-nowrap text-sm">Security deposit</td>
        <td className="px-6 py-4 whitespace-nowrap text-sm text-right">$4,900.00</td>
        <td className="px-6 py-4 whitespace-nowrap">
          <span className="px-2 py-1 text-xs rounded-full bg-yellow-100 text-yellow-800">Pending</span>
        </td>
      </tr>
    </tbody>
  </table>
</div>
```

---

## After (Constellation)

### Basic table

```tsx
import { Table, Text, Tag } from '@zillow/constellation';

<Table.Root>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Date</Table.HeaderCell>
      <Table.HeaderCell>Description</Table.HeaderCell>
      <Table.HeaderCell>Amount</Table.HeaderCell>
      <Table.HeaderCell>Status</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    <Table.Row>
      <Table.Cell>2024-01-15</Table.Cell>
      <Table.Cell>Rent payment</Table.Cell>
      <Table.Cell>$2,450.00</Table.Cell>
      <Table.Cell>
        <Tag size="sm" tone="green" css={{ whiteSpace: 'nowrap' }}>Completed</Tag>
      </Table.Cell>
    </Table.Row>
    <Table.Row>
      <Table.Cell>2024-01-10</Table.Cell>
      <Table.Cell>Security deposit</Table.Cell>
      <Table.Cell>$4,900.00</Table.Cell>
      <Table.Cell>
        <Tag size="sm" tone="yellow" css={{ whiteSpace: 'nowrap' }}>Pending</Tag>
      </Table.Cell>
    </Table.Row>
  </Table.Body>
</Table.Root>
```

### Table with dynamic data

```tsx
<Table.Root>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Address</Table.HeaderCell>
      <Table.HeaderCell>Price</Table.HeaderCell>
      <Table.HeaderCell>Beds</Table.HeaderCell>
      <Table.HeaderCell>Baths</Table.HeaderCell>
      <Table.HeaderCell>Sqft</Table.HeaderCell>
      <Table.HeaderCell>Status</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    {listings.map((listing) => (
      <Table.Row key={listing.id}>
        <Table.Cell>
          <Text textStyle="body">{listing.address}</Text>
        </Table.Cell>
        <Table.Cell>
          <Text textStyle="body-bold">{listing.price}</Text>
        </Table.Cell>
        <Table.Cell>{listing.beds}</Table.Cell>
        <Table.Cell>{listing.baths}</Table.Cell>
        <Table.Cell>{listing.sqft}</Table.Cell>
        <Table.Cell>
          <Tag size="sm" tone={listing.active ? 'green' : 'neutral'} css={{ whiteSpace: 'nowrap' }}>
            {listing.active ? 'Active' : 'Inactive'}
          </Tag>
        </Table.Cell>
      </Table.Row>
    ))}
  </Table.Body>
</Table.Root>
```

### Table inside a Card

```tsx
<Card outlined elevated={false} tone="neutral">
  <Flex direction="column" gap="300" css={{ p: '400' }}>
    <Text textStyle="body-lg-bold">Transaction history</Text>
  </Flex>
  <Table.Root>
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Date</Table.HeaderCell>
        <Table.HeaderCell>Description</Table.HeaderCell>
        <Table.HeaderCell>Amount</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {transactions.map((tx) => (
        <Table.Row key={tx.id}>
          <Table.Cell>{tx.date}</Table.Cell>
          <Table.Cell>{tx.description}</Table.Cell>
          <Table.Cell>{tx.amount}</Table.Cell>
        </Table.Row>
      ))}
    </Table.Body>
  </Table.Root>
</Card>
```

---

## Required rules

- Use `Table.Root` as the wrapper — NOT raw `<table>` elements
- Use `Table.HeaderCell` for header cells — NOT `Table.Cell` in the header row
- Use `<Tag>` for status badges/labels — NOT custom styled spans or divs
- Use `<Divider />` if you need visual separators — NOT CSS borders
- Use `Text` components for cell content that needs specific styling
- Use `Text textStyle="body-bold"` for emphasis cells (like price)
- Use `Text textStyle="body-sm"` for secondary info in cells

---

## Anti-patterns

```tsx
// WRONG — raw HTML table
<table>
  <thead>
    <tr>
      <th>Name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Value</td>
    </tr>
  </tbody>
</table>

// CORRECT — Constellation Table
<Table.Root>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Name</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    <Table.Row>
      <Table.Cell>Value</Table.Cell>
    </Table.Row>
  </Table.Body>
</Table.Root>
```

```tsx
// WRONG — custom styled badge in table cell
<Table.Cell>
  <span className="px-2 py-1 text-xs rounded bg-green-100 text-green-800">Active</span>
</Table.Cell>

// CORRECT — use Tag component
<Table.Cell>
  <Tag size="sm" tone="green" css={{ whiteSpace: 'nowrap' }}>Active</Tag>
</Table.Cell>
```

```tsx
// WRONG — CSS border for row separation
<Table.Row style={{ borderBottom: '1px solid #eee' }}>

// CORRECT — Table.Root handles row borders automatically
<Table.Row>
```

---

## Variants

### Compact table

```tsx
<Table.Root size="sm">
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Item</Table.HeaderCell>
      <Table.HeaderCell>Value</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    <Table.Row>
      <Table.Cell>Year built</Table.Cell>
      <Table.Cell>2005</Table.Cell>
    </Table.Row>
    <Table.Row>
      <Table.Cell>Lot size</Table.Cell>
      <Table.Cell>0.25 acres</Table.Cell>
    </Table.Row>
  </Table.Body>
</Table.Root>
```

### Table with actions column

```tsx
<Table.Root>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Listing</Table.HeaderCell>
      <Table.HeaderCell>Price</Table.HeaderCell>
      <Table.HeaderCell>Status</Table.HeaderCell>
      <Table.HeaderCell>Actions</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    <Table.Row>
      <Table.Cell>
        <Text textStyle="body-bold">123 Main St</Text>
      </Table.Cell>
      <Table.Cell>$450,000</Table.Cell>
      <Table.Cell>
        <Tag size="sm" tone="green" css={{ whiteSpace: 'nowrap' }}>Active</Tag>
      </Table.Cell>
      <Table.Cell>
        <ButtonGroup aria-label="Row actions">
          <TextButton size="sm">Edit</TextButton>
          <TextButton size="sm">View</TextButton>
        </ButtonGroup>
      </Table.Cell>
    </Table.Row>
  </Table.Body>
</Table.Root>
```

### Table with icons in cells

```tsx
import { Icon } from '@zillow/constellation';
import { IconCheckFilled, IconCloseFilled } from '@zillow/constellation-icons';

<Table.Root>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Feature</Table.HeaderCell>
      <Table.HeaderCell>Basic</Table.HeaderCell>
      <Table.HeaderCell>Premium</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    <Table.Row>
      <Table.Cell>Photo uploads</Table.Cell>
      <Table.Cell>
        <Icon size="md" css={{ color: 'text.action.positive.hero.default' }}>
          <IconCheckFilled />
        </Icon>
      </Table.Cell>
      <Table.Cell>
        <Icon size="md" css={{ color: 'text.action.positive.hero.default' }}>
          <IconCheckFilled />
        </Icon>
      </Table.Cell>
    </Table.Row>
    <Table.Row>
      <Table.Cell>3D tours</Table.Cell>
      <Table.Cell>
        <Icon size="md" css={{ color: 'text.subtle' }}>
          <IconCloseFilled />
        </Icon>
      </Table.Cell>
      <Table.Cell>
        <Icon size="md" css={{ color: 'text.action.positive.hero.default' }}>
          <IconCheckFilled />
        </Icon>
      </Table.Cell>
    </Table.Row>
  </Table.Body>
</Table.Root>
```

---

## Edge cases

### Empty table state

```tsx
{data.length === 0 ? (
  <Flex direction="column" align="center" gap="300" css={{ py: '800' }}>
    <img src={EmptyStateIllustration} alt="No data" style={{ width: 160, height: 160 }} />
    <Text textStyle="body-lg-bold">No transactions yet</Text>
    <Text textStyle="body" css={{ color: 'text.subtle' }}>
      Your transaction history will appear here.
    </Text>
  </Flex>
) : (
  <Table.Root>
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Date</Table.HeaderCell>
        <Table.HeaderCell>Amount</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {data.map((row) => (
        <Table.Row key={row.id}>
          <Table.Cell>{row.date}</Table.Cell>
          <Table.Cell>{row.amount}</Table.Cell>
        </Table.Row>
      ))}
    </Table.Body>
  </Table.Root>
)}
```

### Responsive table (overflow scroll)

```tsx
<Box css={{ overflowX: 'auto' }}>
  <Table.Root>
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Address</Table.HeaderCell>
        <Table.HeaderCell>Price</Table.HeaderCell>
        <Table.HeaderCell>Beds</Table.HeaderCell>
        <Table.HeaderCell>Baths</Table.HeaderCell>
        <Table.HeaderCell>Sqft</Table.HeaderCell>
        <Table.HeaderCell>Year built</Table.HeaderCell>
        <Table.HeaderCell>Status</Table.HeaderCell>
        <Table.HeaderCell>Actions</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {/* rows */}
    </Table.Body>
  </Table.Root>
</Box>
```

### Clickable table rows

```tsx
<Table.Root>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Listing</Table.HeaderCell>
      <Table.HeaderCell>Price</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    {listings.map((listing) => (
      <Table.Row
        key={listing.id}
        onClick={() => navigate(`/listing/${listing.id}`)}
        css={{ cursor: 'pointer', '&:hover': { bg: 'bg.surface.neutral.hover' } }}
      >
        <Table.Cell>{listing.address}</Table.Cell>
        <Table.Cell>{listing.price}</Table.Cell>
      </Table.Row>
    ))}
  </Table.Body>
</Table.Root>
```

### Migrating from MUI DataGrid

When migrating from MUI DataGrid, convert the column/row data model to declarative JSX:

```tsx
// MUI DataGrid (data-driven)
const columns = [
  { field: 'address', headerName: 'Address' },
  { field: 'price', headerName: 'Price' },
];
<DataGrid rows={rows} columns={columns} />

// Constellation Table (declarative JSX)
<Table.Root>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Address</Table.HeaderCell>
      <Table.HeaderCell>Price</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    {rows.map((row) => (
      <Table.Row key={row.id}>
        <Table.Cell>{row.address}</Table.Cell>
        <Table.Cell>{row.price}</Table.Cell>
      </Table.Row>
    ))}
  </Table.Body>
</Table.Root>
```

For sorting, filtering, and pagination with Constellation Table, implement these features manually or with a table utility library (like TanStack Table) and render through Constellation's Table components.
