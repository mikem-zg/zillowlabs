# Table

```tsx
import { Table } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Table } from '@zillow/constellation';
```

```tsx
export const TableBasic = () => (
  <Table.Root
    appearance="grid"
    size="md"
    aria-label="Demo table"
    alignments={['start', 'center', 'end', 'end']}
  >
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {[...Array(8).keys()].map((key) => (
        <Table.Row key={key}>
          <Table.HeaderCell>Table row header</Table.HeaderCell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
        </Table.Row>
      ))}
    </Table.Body>
  </Table.Root>
);
```

## Examples

### Table Alignments

```tsx
import { Table } from '@zillow/constellation';
```

```tsx
export const TableAlignments = () => (
  <Table.Root
    appearance="grid"
    size="md"
    aria-label="Demo table"
    alignments={['start', 'center', 'end', 'center']}
  >
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      <Table.Row>
        <Table.HeaderCell>Table row header</Table.HeaderCell>
        <Table.Cell>Table cell</Table.Cell>
        <Table.Cell>Table cell</Table.Cell>
        <Table.Cell>Table cell</Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.HeaderCell>Table row header</Table.HeaderCell>
        <Table.Cell colSpan={2}>Table cell</Table.Cell>
        <Table.Cell>Table cell</Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.HeaderCell>Table row header</Table.HeaderCell>
        <Table.Cell>Table cell</Table.Cell>
        <Table.Cell>Table cell</Table.Cell>
        <Table.Cell>Table cell</Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.HeaderCell colSpan={2}>Table row header</Table.HeaderCell>
        <Table.Cell>Table cell</Table.Cell>
        <Table.Cell>Table cell</Table.Cell>
      </Table.Row>
    </Table.Body>
  </Table.Root>
);
```

### Table Barebones

```tsx
import { Table } from '@zillow/constellation';
```

```tsx
export const TableBarebones = () => (
  <Table.Root
    appearance="bare"
    size="md"
    aria-label="Demo table"
    alignments={['start', 'center', 'end', 'end']}
  >
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {[...Array(8).keys()].map((key) => (
        <Table.Row key={key}>
          <Table.HeaderCell>Table row header</Table.HeaderCell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
        </Table.Row>
      ))}
    </Table.Body>
  </Table.Root>
);
```

### Table Horizontal

```tsx
import { Table } from '@zillow/constellation';
```

```tsx
export const TableHorizontal = () => (
  <Table.Root
    appearance="horizontal"
    size="md"
    aria-label="Demo table"
    alignments={['start', 'center', 'end', 'end']}
  >
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {[...Array(8).keys()].map((key) => (
        <Table.Row key={key}>
          <Table.HeaderCell>Table row header</Table.HeaderCell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
        </Table.Row>
      ))}
    </Table.Body>
  </Table.Root>
);
```

### Table Responsive

```tsx
import { Table } from '@zillow/constellation';
```

```tsx
export const TableResponsive = () => (
  <Table.Responsive>
    <Table.Root
      appearance="grid"
      size="md"
      aria-label="Demo table"
      alignments={['start', 'center', 'end', 'end']}
      css={{ minWidth: '800px' }}
    >
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell>Table header</Table.HeaderCell>
          <Table.HeaderCell>Table header</Table.HeaderCell>
          <Table.HeaderCell>Table header</Table.HeaderCell>
          <Table.HeaderCell>Table header</Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {[...Array(8).keys()].map((key) => (
          <Table.Row key={key}>
            <Table.HeaderCell>Table row header</Table.HeaderCell>
            <Table.Cell>Table cell</Table.Cell>
            <Table.Cell>Table cell</Table.Cell>
            <Table.Cell>Table cell</Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table.Root>
  </Table.Responsive>
);
```

### Table Selectable

```tsx
import { Checkbox, Table, TextButton } from '@zillow/constellation';
```

```tsx
export const TableSelectable = () => {
  const INITIAL_SELECTED = [true, true, false, true, false, false, true, false];
  const [selected, setSelected] = useState(INITIAL_SELECTED);

  const onAllItemsChange = useCallback((event: ChangeEvent<HTMLInputElement>) => {
    setSelected((prev) => prev.map(() => event.target.checked));
  }, []);

  const onItemChange = useCallback((index: number) => {
    setSelected((prev) => {
      const next = [...prev];
      next[index] = !next[index];
      return next;
    });
  }, []);

  return (
    <Table.Root
      appearance="grid"
      size="md"
      aria-label="Demo table"
      alignments={['start', 'center', 'end', 'end']}
    >
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell style={{ width: '20px' }}>
            <Checkbox
              aria-label="Toggle selecting all rows"
              checked={selected.every((item) => item === true)}
              indeterminate={selected.some((item) => item) && selected.some((item) => !item)}
              onChange={(event) => onAllItemsChange(event)}
            />
          </Table.HeaderCell>
          <Table.HeaderCell>Table header</Table.HeaderCell>
          <Table.HeaderCell>Table header</Table.HeaderCell>
          <Table.HeaderCell>Table header</Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {[...Array(8).keys()].map((key) => (
          <Table.Row
            key={key}
            aria-selected={selected[key]}
            interactive
            onClick={() => onItemChange(key)}
          >
            <Table.Cell>
              <Checkbox
                aria-label={`Select row ${key + 1}`}
                checked={selected[key]}
                onChange={() => onItemChange(key)}
                onClick={(event) => event.stopPropagation()}
              />
            </Table.Cell>
            <Table.Cell>Table cell</Table.Cell>
            <Table.Cell>Table cell</Table.Cell>
            <Table.Cell>
              <TextButton onClick={(event) => event.stopPropagation()}>Text button</TextButton>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table.Root>
  );
};
```

### Table Sortable

```tsx
import { Table, type TableOnSortChangeStateType } from '@zillow/constellation';
```

```tsx
const STATE_DATA = [
  { name: 'Arizona', length: 400, width: 310, nickname: 'The Grand Canyon State' },
  { name: 'California', length: 770, width: 250, nickname: 'The Golden State' },
  { name: 'Tennessee', length: 440, width: 120, nickname: 'The Natural State' },
  { name: 'Washington', length: 240, width: 360, nickname: 'The Evergreen State' },
];

interface SortStateType {
  sortBy: string;
  sortDirection: 'ascending' | 'descending' | 'none';
}

const useDataSort = <T extends Record<string, any>>(
  data: Array<T>,
  { sortBy, sortDirection }: SortStateType,
): Array<T> => {
  return useMemo(() => {
    const sortedData = [...data];

    if (!sortDirection || sortDirection === 'none') {
      return sortedData;
    }

    const compareValues = (a: T, b: T) => {
      const valueA = a[sortBy];
      const valueB = b[sortBy];

      if (valueA == null) return 1;
      if (valueB == null) return -1;
      if (valueA == null && valueB == null) return 0;

      if (typeof valueA === 'string' && typeof valueB === 'string') {
        return valueA.localeCompare(valueB);
      }

      return valueA < valueB ? -1 : valueA > valueB ? 1 : 0;
    };

    const multiplier = sortDirection === 'ascending' ? 1 : -1;

    return sortedData.sort((a, b) => compareValues(a, b) * multiplier);
  }, [data, sortBy, sortDirection]);
};

export const TableSortable = () => {
  const [sortState, setSortState] = useState<SortStateType>({
    sortBy: 'name',
    sortDirection: 'ascending',
  });

  const sortedStates = useDataSort(STATE_DATA, sortState);

  const onSortChange = useCallback((state: TableOnSortChangeStateType) => {
    setSortState(state);
  }, []);

  return (
    <Table.Root
      appearance="grid"
      size="md"
      aria-label="Demo table"
      sortBy={sortState.sortBy}
      sortDirection={sortState.sortDirection}
      onSortChange={onSortChange}
    >
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell value="name">Name</Table.HeaderCell>
          <Table.HeaderCell value="length">Length (mi)</Table.HeaderCell>
          <Table.HeaderCell value="width" sortDirectionOrder={['descending', 'ascending', 'none']}>
            Width (mi)
          </Table.HeaderCell>
          <Table.HeaderCell>Nickname</Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {sortedStates.map((state, index) => (
          <Table.Row key={index}>
            <Table.Cell>{state.name}</Table.Cell>
            <Table.Cell>{state.length}</Table.Cell>
            <Table.Cell>{state.width}</Table.Cell>
            <Table.Cell>{state.nickname}</Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table.Root>
  );
};
```

### Table Sticky Header

```tsx
import { Table } from '@zillow/constellation';
```

```tsx
export const TableStickyHeader = () => (
  <Table.Root
    appearance="grid"
    size="md"
    aria-label="Demo table"
    alignments={['start', 'center', 'end', 'end']}
  >
    <Table.Header sticky>
      <Table.Row>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {[...Array(16).keys()].map((key) => (
        <Table.Row key={key}>
          <Table.HeaderCell>Table row header</Table.HeaderCell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
        </Table.Row>
      ))}
    </Table.Body>
  </Table.Root>
);
```

### Table Zebra

```tsx
import { Table } from '@zillow/constellation';
```

```tsx
export const TableZebra = () => (
  <Table.Root
    appearance="zebra"
    size="md"
    aria-label="Demo table"
    alignments={['start', 'center', 'end', 'end']}
  >
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
        <Table.HeaderCell>Table header</Table.HeaderCell>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {[...Array(8).keys()].map((key) => (
        <Table.Row key={key}>
          <Table.HeaderCell>Table row header</Table.HeaderCell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
          <Table.Cell>Table cell</Table.Cell>
        </Table.Row>
      ))}
    </Table.Body>
  </Table.Root>
);
```

## API

### TableBody

**Element:** `HTMLTableSectionElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### TableCell

**Element:** `HTMLTableCellElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `align` | `TableAlignmentType` | — | Text alignment |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### TableHeader

**Element:** `HTMLTableSectionElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `sticky` | `boolean` | `false` | Fixed header position |

### TableHeaderCell

**Element:** `HTMLTableCellElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `align` | `TableAlignmentType` | — | Text alignment |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `sortDirectionOrder` | `Array<TableSortDirectionType>` | `['ascending', 'descending']` | An array that dictates the order of sort direction order. When you first click on a sortable header cell, the sort direction is determined by the first value in the array. Clicking on the header cell again sorts in the direction determined by the second value and so on. Once you reach the end of the array, we rotate back to the first value. If you click on a different header cell and then come back to this one, the sequence begins again with the first value in the array. |
| `value` | `string` | — | A unique identifier. If this `Table.SortableHeaderCell`'s `value` matches the `sortedBy` or `defaultSortedBy` prop on `Table.Root`, this `Table.SortableHeaderCell` will be selected. |

### TableResponsive

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### TableRoot

**Element:** `HTMLTableElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'alignments'` | `Array<TableAlignmentType>` | `[]` | Sets the horizontal alignment for each column. Ex: ['left', 'left', 'center', 'right']. You can use the css prop on individual cells to override. |
| `'appearance'` | `'bare' \| 'horizontal' \| 'grid' \| 'zebra'` | `grid` | Styles the table based on one of its preset templates |
| `'aria-label'` | `AriaAttributes['aria-label']` | — | An [aria-label](https://www.w3.org/TR/wai-aria-1.2/#aria-label) is required for assistive technologies to announce the table properly. **(required)** |
| `'children'` | `ReactNode` | — | Content **(required)** |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'defaultSortBy'` | `string` | — | Unique identifier of the currently sorted column in uncontrolled mode. Must match the `value` of one of the `Table.SortableHeaderCell` components. |
| `'defaultSortDirection'` | `TableSortDirectionType` | — | Current sort direction of the sorted column in the uncontrolled mode. |
| `'onSortChange'` | `(     state: TableOnSortChangeStateType,     event: MouseEvent<HTMLTableCellElement>,   ) => void` | — | Callback after every sort change. It passes `state` object with `sortBy` and `sortDirection` values, and `event` as second argument. |
| `'size'` | `'sm' \| 'md' \| 'lg'` | `md` | Styles object |
| `'sortBy'` | `string` | — | Unique identifier of the currently sorted column in controlled mode. Must match the `value` of one of the `Table.SortableHeaderCell` components. |
| `'sortDirection'` | `TableSortDirectionType` | — | Current sort direction of the sorted column in the controlled mode. |
| `'sortDirectionOrder'` | `Array<TableSortDirectionType>` | `['ascending', 'descending']` | An array that dictates the order of sort direction order. When you first click on a sortable header cell, the sort direction is determined by the first value in the array. Clicking on the header cell again sorts in the direction determined by the second value and so on. Once you reach the end of the array, we rotate back to the first value. Can be overridden on individual `Table.SortableHeaderCell` component. |

### TableRow

**Element:** `HTMLTableRowElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-selected'` | `AriaAttributes['aria-selected']` | — | Selected state |
| `'children'` | `ReactNode` | — | Content **(required)** |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'interactive'` | `boolean` | — | The row's background color will change on hover. Primarily used in conjuction with `onClick` and `aria-selected` to indicate a row is selectable. It can also be used to help show the user where they are within a larger table. |

### TableSortButton

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### TableSortIcon

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The SVG icon to render. |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusable` | `ComponentProps<'svg'>['focusable']` | `false` | The SVG [`focusable`](https://www.w3.org/TR/SVGTiny12/interact.html#focusable-attr) attribute. |
| `role` | `AriaRole` | `img` | The role is set to "img" by default to exclude all child content from the accessibility tree. |
| `size` | `ResponsiveVariant<'sm' \| 'md' \| 'lg' \| 'xl'>` | — | By default, icons are sized to `1em` to match the size of the text content. For fixed-width sizes, you can use the `size` prop. |
| `render` | `ReactNode` | — | Alternative to children. |
| `title` | `string` | — | Creates an accessible label for the icon for contextually meaninful icons, and sets the appropriate `aria` attributes. Icons are hidden from screen readers by default without this prop.  Note: specifying `aria-labelledby`, `aria-hidden`, or `children` manually while using this prop may produce accessibility errors. This prop is only available on prebuilt icons within Constellation. |

