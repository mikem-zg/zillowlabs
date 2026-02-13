# List

```tsx
import { List } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 10.0.0

## Usage

```tsx
import { List } from '@zillow/constellation';
```

```tsx
export const ListBasic = () => (
  <List.Root appearance="bullet">
    <List.Item>This is the first list item.</List.Item>
    <List.Item>This is the second list item.</List.Item>
    <List.Item>This is the third list item.</List.Item>
    <List.Item>This is the fourth list item.</List.Item>
  </List.Root>
);
```

## Examples

### List Nested

```tsx
import { List } from '@zillow/constellation';
```

```tsx
export const ListNested = () => (
  <List.Root appearance="none">
    <List.Item>This is the first list item.</List.Item>
    <List.Item>
      This is the second list item.
      <List.Root appearance="none">
        <List.Item>This is the first list item of the second level.</List.Item>
        <List.Item>This is the second list item of the second level.</List.Item>
        <List.Item>This is the third list item of the second level.</List.Item>
        <List.Item>
          This is the fourth list item.
          <List.Root appearance="none">
            <List.Item>This is the first list item of the third level.</List.Item>
            <List.Item>This is the second list item of the third level.</List.Item>
            <List.Item>This is the third list item of the third level.</List.Item>
            <List.Item>
              This is the fourth list item of the third level and it is very very very very very
              very very very very very very very very very very very very very very very very very
              very very very very very very very very very very very very very very very very very
              very very very very very very very very very very very long.
            </List.Item>
          </List.Root>
        </List.Item>
      </List.Root>
    </List.Item>
    <List.Item>This is the third list item.</List.Item>
    <List.Item>This is the fourth list item.</List.Item>
  </List.Root>
);
```

### List No Markers

```tsx
import { List } from '@zillow/constellation';
```

```tsx
export const ListNoMarkers = () => (
  <List.Root appearance="none">
    <List.Item>This is the first list item.</List.Item>
    <List.Item>
      This is the second list item and it is very very very very very very very very very very very
      very very very very very very very very very very very very very very very very very very very
      very very very very very very very very very very very very very very very very very very very
      very long.
    </List.Item>
    <List.Item>This is the third list item.</List.Item>
    <List.Item>This is the fourth list item.</List.Item>
  </List.Root>
);
```

### List Ordered

```tsx
import { List } from '@zillow/constellation';
```

```tsx
export const ListOrdered = () => (
  <List.Root appearance="number">
    <List.Item>This is the first list item.</List.Item>
    <List.Item>
      This is the second list item and it is very very very very very very very very very very very
      very very very very very very very very very very very very very very very very very very very
      very very very very very very very very very very very very very very very very very very very
      very long.
    </List.Item>
    <List.Item>This is the third list item.</List.Item>
    <List.Item>This is the fourth list item.</List.Item>
  </List.Root>
);
```

### List Unordered

```tsx
import { List } from '@zillow/constellation';
```

```tsx
export const ListUnordered = () => (
  <List.Root>
    <List.Item>This is the first list item.</List.Item>
    <List.Item>
      This is the second list item and it is very very very very very very very very very very very
      very very very very very very very very very very very very very very very very very very very
      very very very very very very very very very very very very very very very very very very very
      very long.
    </List.Item>
    <List.Item>This is the third list item.</List.Item>
    <List.Item>This is the fourth list item.</List.Item>
  </List.Root>
);
```

## API

### ListItem

**Element:** `HTMLLIElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### ListRoot

**Element:** `HTMLUListElement | HTMLOListElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `ref` | `RefObject<HTMLOListElement \| HTMLUListElement>` | — | Needed to set a custom ref type to support multiple list type elements. |
| `appearance` | `'bullet' \| 'number' \| 'none'` | `'bullet'` | The type of list to display. |
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

