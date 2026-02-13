# Tag

```tsx
import { Tag } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.6.0

## Usage

```tsx
import { Tag } from '@zillow/constellation';
```

```tsx
export const TagBasic = () => (
  <Tag size="md" tone="gray">
    Fancy Kitchen
  </Tag>
);
```

## Examples

### Tag Composable

```tsx
import { Tag } from '@zillow/constellation';
```

```tsx
export const TagComposable = () => (
  <Tag.Root size="md" tone="gray">
    <Tag.Icon render={<IconBikeFilled />} />
    <Tag.Label>Fancy Kitchen</Tag.Label>
  </Tag.Root>
);
```

### Tag Polymorphic

```tsx
import { Tag } from '@zillow/constellation';
```

```tsx
export const TagPolymorphic = () => (
  <Tag size="md" tone="gray" asChild>
    <figcaption>Tag as Caption</figcaption>
  </Tag>
);
```

### Tag Small

```tsx
import { Tag } from '@zillow/constellation';
```

```tsx
export const TagSmall = () => <Tag size="sm">Fancy Kitchen</Tag>;
```

### Tag With Icon

```tsx
import { Box, Tag } from '@zillow/constellation';
```

```tsx
export const TagWithIcon = () => (
  <Box css={{ display: 'flex', gap: 'layout.tightest', flexShrink: 0, flexWrap: 'wrap' }}>
    <Tag icon={<IconBikeFilled />}>Default Tag</Tag>
    <Tag tone="critical" icon={<IconErrorFilled />}>
      Critical Tag
    </Tag>
    <Tag tone="success" icon={<IconCheckmarkCircleFilled />}>
      Success Tag
    </Tag>
    <Tag tone="warning" icon={<IconWarningFilled />}>
      Warning Tag
    </Tag>
    <Tag tone="info" icon={<IconInfoFilled />}>
      Info Tag
    </Tag>
  </Box>
);
```

### Tag With Text Transform

```tsx
import { Box, Tag } from '@zillow/constellation';
```

```tsx
export const TagWithTextTransform = () => (
  <Box css={{ display: 'flex', gap: 'layout.tightest', flexShrink: 0, flexWrap: 'wrap' }}>
    <Tag css={{ textTransform: 'capitalize' }}>Capitalize Tag</Tag>
    <Tag css={{ textTransform: 'lowercase' }}>Lowercase Tag</Tag>
    <Tag css={{ textTransform: 'uppercase' }}>Uppercase Tag</Tag>
    <Tag css={{ textTransform: 'none' }}>No CaSe TaG</Tag>
  </Box>
);
```

### Tag With Tone

```tsx
import { Box, Tag } from '@zillow/constellation';
```

```tsx
export const TagWithTone = () => (
  <Box css={{ display: 'flex', gap: 'layout.tightest', flexShrink: 0, flexWrap: 'wrap' }}>
    <Tag size="md" tone="aqua">
      Aqua
    </Tag>
    <Tag size="md" tone="blue">
      Blue
    </Tag>
    <Tag size="md" tone="critical">
      Critical
    </Tag>
    <Tag size="md" tone="gray">
      Gray
    </Tag>
    <Tag size="md" tone="green">
      Green
    </Tag>
    <Tag size="md" tone="info">
      Info
    </Tag>
    <Tag size="md" tone="orange">
      Orange
    </Tag>
    <Tag size="md" tone="purple">
      Purple
    </Tag>
    <Tag size="md" tone="red">
      Red
    </Tag>
    <Tag size="md" tone="success">
      Success
    </Tag>
    <Tag size="md" tone="teal">
      Teal
    </Tag>
    <Tag size="md" tone="transparent">
      Transparent
    </Tag>
    <Tag size="md" tone="warning">
      Warning
    </Tag>
    <Tag size="md" tone="yellow">
      Yellow
    </Tag>
  </Box>
);
```

## Usage Rules

### Prevent Text Wrapping

Tag labels must always stay on a single line. Add `css={{ whiteSpace: 'nowrap' }}` to prevent the text from breaking across lines when the container is narrow:

```tsx
// CORRECT — text stays on one line
<Tag size="sm" tone="green" css={{ whiteSpace: 'nowrap' }}>Developer Tools</Tag>

// WRONG — text can wrap to multiple lines in narrow containers
<Tag size="sm" tone="green">Developer Tools</Tag>
```

When placing multiple Tags in a row, use `flexWrap: 'wrap'` on the parent so Tags flow to the next row rather than being squeezed:

```tsx
<Flex align="center" gap="200" css={{ flexWrap: 'wrap' }}>
  <Tag size="sm" tone="green" css={{ whiteSpace: 'nowrap' }}>Developer Tools</Tag>
  <Tag size="sm" tone="blue" css={{ whiteSpace: 'nowrap' }}>In development</Tag>
</Flex>
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `\| 'aqua'     \| 'blue'     \| 'critical'     \| 'gray'     \| 'green'     \| 'info'     \| 'orange'     \| 'purple'     \| 'red'     \| 'success'     \| 'teal'     \| 'transparent'     \| 'warning'     \| 'yellow'` | `gray` | The type of the button. |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `size` | `'sm' \| 'md'` | `'md'` | Tag size |
| `icon` | `ReactNode` | — | Icon component |

### TagIcon

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

### TagLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `color` | `never` | — | The label returns Text; however we do not want users to override the `color` value |
| `css` | `SystemStyleObject` | — | Styles object |

### TagRoot

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `\| 'aqua'     \| 'blue'     \| 'critical'     \| 'gray'     \| 'green'     \| 'info'     \| 'orange'     \| 'purple'     \| 'red'     \| 'success'     \| 'teal'     \| 'transparent'     \| 'warning'     \| 'yellow'` | `gray` | The type of the button. |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `size` | `'sm' \| 'md'` | `'md'` | Tag size |

