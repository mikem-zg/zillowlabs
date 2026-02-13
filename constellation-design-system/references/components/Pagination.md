# Pagination

```tsx
import { Pagination } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.42.0

## Usage

```tsx
import { Pagination } from '@zillow/constellation';
```

```tsx
export const PaginationBasic = () => <Pagination showNumberButtons totalPages={15} />;
```

## Examples

### Pagination Composition

```tsx
import { Pagination } from '@zillow/constellation';
```

```tsx
export const PaginationComposition = () => (
  <Pagination.Root totalPages={10}>
    <Pagination.List>
      <Pagination.Item>
        <Pagination.PreviousButton />
      </Pagination.Item>
      <Pagination.PageItems />
      <Pagination.Readout />
      <Pagination.Item>
        <Pagination.NextButton />
      </Pagination.Item>
    </Pagination.List>
  </Pagination.Root>
);
```

### Pagination Hide Number Buttons

```tsx
import { Pagination } from '@zillow/constellation';
```

```tsx
export const PaginationHideNumberButtons = () => (
  <Pagination showNumberButtons={false} totalPages={15} />
);
```

### Pagination With Divider

```tsx
import { Pagination } from '@zillow/constellation';
```

```tsx
export const PaginationWithDivider = () => <Pagination divider totalPages={10} />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'currentPageIndex'` | `number` | — | (Controlled component) The index of the currently-selected page. Including this prop will render this as a controlled component. To render an uncontrolled component, use `defaultCurrentPageIndex` instead. |
| `'defaultCurrentPageIndex'` | `number` | — | (Uncontrolled component) The index of the currently-selected page. Including this prop will render this as an uncontrolled component. To render a controlled component, use `currentPageIndex` instead. |
| `'totalPages'` | `number` | — | The total number of available pages **(required)** |
| `'onPageSelected'` | `(index: number) => void` | — | An event handler to attach to page selection events. Takes one argument:     `pageIndex`: the newly selected page index |
| `'aria-label'` | `string` | `Pagination` | A unique label that describes this component's purpose. Especially necessary when using multiple pagination components on the same page. |
| `'showNumberButtons'` | `ResponsiveVariant<boolean>` | `{ base: false, md: true }` | When true, the wider version of the pagination component will be rendered, providing numbered buttons that link directly to pages.  Supports inline media query objects. |
| `divider` | `boolean` | `false` | Renders an optional divider above the Pagination component |

### PaginationItem

**Element:** `HTMLLIElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |

### PaginationList

**Element:** `HTMLUListElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |

### PaginationNextButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `(       <Icon>         <IconChevronRightFilled />       </Icon>     )` | The button's content, defaults to an icon |
| `css` | `SystemStyleObject` | — | Styles object |
| `title` | `IconButtonPropsInterface['title']` | `Next page` | Accessible text of the button |

### PaginationPageButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | The button's content |
| `css` | `SystemStyleObject` | — | Styles object |
| `selected` | `boolean` | `false` | Whether this button is selected or not |

### PaginationPageItems

### PaginationPreviousButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `(       <Icon>         <IconChevronLeftFilled />       </Icon>     )` | The button's content, defaults to an icon |
| `css` | `SystemStyleObject` | — | Styles object |
| `title` | `IconButtonPropsInterface['title']` | `Previous page` | Accessible text of the button |

### PaginationReadout

**Element:** `HTMLLIElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |

### PaginationRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'currentPageIndex'` | `number` | — | (Controlled component) The index of the currently-selected page. Including this prop will render this as a controlled component. To render an uncontrolled component, use `defaultCurrentPageIndex` instead. |
| `'defaultCurrentPageIndex'` | `number` | — | (Uncontrolled component) The index of the currently-selected page. Including this prop will render this as an uncontrolled component. To render a controlled component, use `currentPageIndex` instead. |
| `'totalPages'` | `number` | — | The total number of available pages **(required)** |
| `'onPageSelected'` | `(index: number) => void` | — | An event handler to attach to page selection events. Takes one argument: `pageIndex`: the newly selected page index |
| `'aria-label'` | `string` | `Pagination` | A unique label that describes this component's purpose. Especially necessary when using multiple pagination components on the same page. |
| `'showNumberButtons'` | `ResponsiveVariant<boolean>` | `{ base: false, md: true }` | When true, the wider version of the pagination component will be rendered, providing numbered buttons that link directly to pages. Supports inline media query objects. |

