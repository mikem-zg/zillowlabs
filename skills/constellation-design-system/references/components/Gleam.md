# Gleam

```tsx
import { Gleam } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.39.0

## Usage

```tsx
import { Gleam } from '@zillow/constellation';
```

```tsx
export const GleamAsDotBasic = () => (
  <Gleam count={2} appearance="dot" dotProps={{ label: 'New messages' }} />
);
```

## Examples

### Gleam As Dot Composable

```tsx
import { Gleam, Icon } from '@zillow/constellation';
```

```tsx
export const GleamAsDotComposable = () => (
  <Gleam.Root>
    <Icon size="lg">
      <IconMailFilled />
    </Icon>
    <Gleam.Label
      appearance="dot"
      count={7}
      maxCount={99}
      maxSuffix={false}
      onImpact={false}
      renderDot={(inheritedProps) => <Gleam.Dot {...inheritedProps} label="New messages" />}
      tone="default"
    />
  </Gleam.Root>
);
```

### Gleam As Dot On Impact

```tsx
import { Box, Gleam } from '@zillow/constellation';
```

```tsx
export const GleamAsDotOnImpact = () => (
  <Box css={{ display: 'flex', gap: 'loose' }}>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }} onImpact />
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }} tone="info" onImpact />
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }} tone="new" onImpact />
  </Box>
);
```

### Gleam As Dot With Avatar

```tsx
import { Avatar, Box, Gleam } from '@zillow/constellation';
```

```tsx
export const GleamAsDotWithAvatar = () => (
  <Box css={{ display: 'flex', gap: 'loose' }}>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Avatar size="xs" />
    </Gleam>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Avatar size="sm" />
    </Gleam>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Avatar size="md" />
    </Gleam>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Avatar size="lg" />
    </Gleam>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Avatar size="xl" />
    </Gleam>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Avatar size="xxl" />
    </Gleam>
  </Box>
);
```

### Gleam As Dot With Icon

```tsx
import { Box, Gleam, Icon } from '@zillow/constellation';
```

```tsx
export const GleamAsDotWithIcon = () => (
  <Box css={{ display: 'flex', gap: 'loose' }}>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Icon size="sm">
        <IconMailFilled />
      </Icon>
    </Gleam>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Icon size="md">
        <IconMailFilled />
      </Icon>
    </Gleam>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Icon size="lg">
        <IconMailFilled />
      </Icon>
    </Gleam>
    <Gleam count={7} appearance="dot" dotProps={{ label: 'New messages' }}>
      <Icon size="xl">
        <IconMailFilled />
      </Icon>
    </Gleam>
  </Box>
);
```

### Gleam As Dot With Text

```tsx
import { Gleam, Text } from '@zillow/constellation';
```

```tsx
export const GleamAsDotWithText = () => (
  <Text textStyle="body-lg-bold">
    Inbox <Gleam count={23} appearance="dot" dotProps={{ label: 'New messages' }} />
  </Text>
);
```

### Gleam Basic

```tsx
import { Gleam } from '@zillow/constellation';
```

```tsx
export const GleamBasic = () => <Gleam count={2} />;
```

### Gleam Composable

```tsx
import { Gleam, Icon } from '@zillow/constellation';
```

```tsx
export const GleamComposable = () => (
  <Gleam.Root>
    <Icon size="lg">
      <IconMailFilled />
    </Icon>
    <Gleam.Label count={7} />
  </Gleam.Root>
);
```

### Gleam Dot Basic

```tsx
import { Gleam } from '@zillow/constellation';
```

```tsx
export const GleamDotBasic = () => <Gleam.Dot count={23} />;
```

### Gleam Dot Label

```tsx
import { Gleam } from '@zillow/constellation';
```

```tsx
export const GleamDotLabel = () => <Gleam.Label count={23}>New messages</Gleam.Label>;
```

### Gleam Label Basic

```tsx
import { Gleam } from '@zillow/constellation';
```

```tsx
export const GleamLabelBasic = () => <Gleam.Label count={23} />;
```

### Gleam On Impact

```tsx
import { Box, Gleam } from '@zillow/constellation';
```

```tsx
export const GleamOnImpact = () => (
  <Box css={{ display: 'flex', gap: 'loose' }}>
    <Gleam count={7} onImpact />
    <Gleam count={7} tone="info" onImpact />
    <Gleam count={7} tone="new" onImpact />
  </Box>
);
```

### Gleam With Avatar

```tsx
import { Avatar, Box, Gleam } from '@zillow/constellation';
```

```tsx
export const GleamWithAvatar = () => (
  <Box css={{ display: 'flex', gap: 'loose' }}>
    <Gleam count={7}>
      <Avatar size="xs" />
    </Gleam>
    <Gleam count={7}>
      <Avatar size="sm" />
    </Gleam>
    <Gleam count={7}>
      <Avatar size="md" />
    </Gleam>
    <Gleam count={7}>
      <Avatar size="lg" />
    </Gleam>
    <Gleam count={7}>
      <Avatar size="xl" />
    </Gleam>
    <Gleam count={7}>
      <Avatar size="xxl" />
    </Gleam>
  </Box>
);
```

### Gleam With Icon

```tsx
import { Box, Gleam, Icon } from '@zillow/constellation';
```

```tsx
export const GleamWithIcon = () => (
  <Box css={{ display: 'flex', gap: 'loose' }}>
    <Gleam count={7}>
      <Icon size="sm">
        <IconMailFilled />
      </Icon>
    </Gleam>
    <Gleam count={7}>
      <Icon size="md">
        <IconMailFilled />
      </Icon>
    </Gleam>
    <Gleam count={7}>
      <Icon size="lg">
        <IconMailFilled />
      </Icon>
    </Gleam>
    <Gleam count={7}>
      <Icon size="xl">
        <IconMailFilled />
      </Icon>
    </Gleam>
  </Box>
);
```

### Gleam With Text

```tsx
import { Gleam, Text } from '@zillow/constellation';
```

```tsx
export const GleamWithText = () => (
  <Text textStyle="body-lg-bold">
    Inbox <Gleam count={23} />
  </Text>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `'default' \| 'info' \| 'new'` | `default` | The type of gleam to display. |
| `appearance` | `'ellipsis' \| 'dot'` | `ellipsis` | The appearance of the gleam. |
| `color` | `never` | — |  |
| `css` | `SystemStyleObject` | — | Styles object |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |
| `count` | `number` | — | The notification count displayed on the badge **(required)** |
| `maxCount` | `number` | `99` | If `count` is greater than `maxCount`, the badge will display `maxCount` instead. You can disable a max by setting this to 0. |
| `maxSuffix` | `boolean` | `false` | If `count` is greater than `maxCount`, the badge will display `maxCount` with a `+` suffix. |
| `children` | `ReactNode` | — | Content |
| `dotProps` | `Partial<Pick<GleamDotPropsInterface, 'label' \| 'css' \| 'className'>>` | — | Props to pass to the dot component for independent configuration |

### GleamDot

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `'default' \| 'info' \| 'new'` | `default` | The type of gleam to display. |
| `css` | `SystemStyleObject` | — | Styles object |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |
| `count` | `number` | — | The notification count visually hidden from the user, but spoken by assistive technologies if `label` is not provided. **(required)** |
| `label` | `string` | — | Optional label announced by assistive technologies in place of just saying a number. Ex: "New messages". |

### GleamLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `'default' \| 'info' \| 'new'` | `default` | The type of gleam to display. |
| `appearance` | `'ellipsis' \| 'dot'` | `ellipsis` | The appearance of the gleam. |
| `color` | `never` | — |  |
| `css` | `SystemStyleObject` | — | Styles object |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |
| `count` | `number` | — | The notification count displayed on the badge **(required)** |
| `maxCount` | `number` | `99` | If `count` is greater than `maxCount`, the badge will display `maxCount` instead. You can disable a max by setting this to 0. |
| `maxSuffix` | `boolean` | `false` | If `count` is greater than `maxCount`, the badge will display `maxCount` with a `+` suffix. |
| `renderDot` | `(props: GleamDotPropsInterface) => ReactNode` | — | A function that renders the dot component. |

### GleamRoot

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

