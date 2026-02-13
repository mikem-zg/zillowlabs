# Heading

```tsx
import { Heading } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.0.0

## Usage

```tsx
import { Heading } from '@zillow/constellation';
```

```tsx
export const HeadingBasic = () => <Heading level={1}>Constellation Design System</Heading>;
```

## Examples

### Heading Responsive

```tsx
import { Box, Heading } from '@zillow/constellation';
```

```tsx
export const HeadingResponsive = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
    <Heading level={1} textStyle="responsive.heading-xl">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-lg">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-md">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-sm">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-xs">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.body-lg-bold">
      Constellation Design System
    </Heading>
  </Box>
);
```

### Heading With Css Prop

```tsx
import { Heading } from '@zillow/constellation';
```

```tsx
export const HeadingWithCssProp = () => (
  <Heading level={1} css={{ color: 'text.subtle', marginBlockEnd: 'default' }}>
    Constellation Design System
  </Heading>
);
```

### Heading With Icon

```tsx
import { Heading, Icon } from '@zillow/constellation';
```

```tsx
export const HeadingWithIcon = () => (
  <Heading level={1}>
    <Icon render={<IconHouseClockFilled />} />
    Constellation Design System
  </Heading>
);
```

### Heading With Level

```tsx
import { Box, Heading } from '@zillow/constellation';
```

```tsx
export const HeadingWithLevel = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
    <Heading level={1}>Constellation Design System</Heading>
    <Heading level={2}>Constellation Design System</Heading>
    <Heading level={3}>Constellation Design System</Heading>
    <Heading level={4}>Constellation Design System</Heading>
    <Heading level={5}>Constellation Design System</Heading>
    <Heading level={6}>Constellation Design System</Heading>
  </Box>
);
```

### Heading With Text Style

```tsx
import { Box, Heading } from '@zillow/constellation';
```

```tsx
export const HeadingWithTextStyle = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
    <Heading level={1} textStyle="heading-xl">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="heading-lg">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="heading-md">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="heading-sm">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="heading-xs">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="body-lg-bold">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-xl">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-lg">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-md">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-sm">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.heading-xs">
      Constellation Design System
    </Heading>
    <Heading level={1} textStyle="responsive.body-lg-bold">
      Constellation Design System
    </Heading>
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `fontFamily` | `'heading' \| 'heading-alt'` | — | The text font family |
| `fontColor` | `never` | — |  |
| `fontType` | `never` | — |  |
| `level` | `1 \| 2 \| 3 \| 4 \| 5 \| 6` | `1` | Heading level **(required)** |
| `textStyle` | `\| 'heading-xl'     \| 'heading-lg'     \| 'heading-md'     \| 'heading-sm'     \| 'heading-xs'     \| 'body-lg-bold'     \| 'responsive.heading-xl'     \| 'responsive.heading-lg'     \| 'responsive.heading-md'     \| 'responsive.heading-sm'     \| 'responsive.heading-xs'     \| 'responsive.body-lg-bold'` | — | The text style, it determines the size, weight, and line-height. |

