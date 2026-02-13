# Toast

```tsx
import { Toast } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.4.0

## Usage

```tsx
import { Toast } from '@zillow/constellation';
```

```tsx
export const ToastBasic = () => <Toast>Lorem ipsum dolor</Toast>;
```

## Examples

### Toast Action

```tsx
import { TextButton, Toast } from '@zillow/constellation';
```

```tsx
export const ToastAction = () => (
  <Toast actionButton={<TextButton onImpact>Click Me</TextButton>}>Lorem ipsum dolor</Toast>
);
```

### Toast Composed

```tsx
import { Anchor, CloseButton, TextButton, Toast } from '@zillow/constellation';
```

```tsx
export const ToastComposed = () => (
  <Toast.Root>
    <Toast.Body>
      Lorem <Anchor onImpact>ipsum dolor</Anchor> sit amet, consectetur.
    </Toast.Body>
    <Toast.Action>
      <TextButton onImpact>Action</TextButton>
    </Toast.Action>
    <Toast.Close>
      <CloseButton onImpact />
    </Toast.Close>
  </Toast.Root>
);
```

### Toast Controlled Open

```tsx
import { Box, Button, Toast } from '@zillow/constellation';
```

```tsx
export const ToastControlledOpen = () => {
  const [open, setOpen] = useState(true);

  return (
    <Box
      css={{
        display: 'flex',
        gap: 'layout.default',
        flexDirection: 'column',
        alignItems: 'flex-start',
      }}
    >
      <Button onClick={() => setOpen(!open)}>Toggle</Button>
      <Toast isOpen={open} onClose={() => setOpen(false)}>
        Lorem ipsum dolor sit amet, consectetur.
      </Toast>
    </Box>
  );
};
```

### Toast Custom Close

```tsx
import { Toast } from '@zillow/constellation';
```

```tsx
export const ToastCustomClose = () => (
  <Toast onClose={() => alert('Closed')}>Lorem ipsum dolor sit amet, consectetur.</Toast>
);
```

### Toast Tones

```tsx
import { Box, Toast } from '@zillow/constellation';
```

```tsx
export const ToastTones = () => (
  <Box
    css={{
      display: 'flex',
      gap: 'layout.default',
      flexDirection: 'column',
      alignItems: 'flex-start',
    }}
  >
    <Toast tone="info">Lorem ipsum dolor sit amet, consectetur.</Toast>
    <Toast tone="success">Lorem ipsum dolor sit amet, consectetur.</Toast>
    <Toast tone="critical">Lorem ipsum dolor sit amet, consectetur.</Toast>
    <Toast tone="warning">Lorem ipsum dolor sit amet, consectetur.</Toast>
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `'info' \| 'success' \| 'warning' \| 'critical'` | `info` | The type of toast to display. Note: The tone value can modify component content such as icon, as well as behavior such as the duration it is visible with ToastProvider. |
| `children` | `ReactNode` | — | The content of the toast message |
| `isOpen` | `boolean` | — | Controlled open state |
| `onClose` | `() => void` | — | Function called with the close button is clicked. |
| `css` | `SystemStyleObject` | — | Styles object |
| `role` | `AriaRole` | `status` | Toasts should have a role of status or alert to signal assistive technologies that it requires the user's attention. In general, you will always want to use the less strict "status" role. |
| `actionButton` | `ReactNode` | — | An optional action button. |
| `closeButton` | `ReactNode` | — | The close button node. You can set this to null to remove the close button from the toast. |

### ToastAction

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The content of the action button container |
| `css` | `SystemStyleObject` | — | Styles object |

### ToastBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The content of the toast message |
| `css` | `SystemStyleObject` | — | Styles object |

### ToastClose

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The content of the close button container |
| `css` | `SystemStyleObject` | — | Styles object |

### ToastIcon

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `'info' \| 'success' \| 'warning' \| 'critical'` | `info` | The type of toast to display. Note: The tone value can modify component content such as icon, as well as behavior such as the duration it is visible with ToastProvider. |
| `css` | `SystemStyleObject` | — | Styles object |

### ToastRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `'info' \| 'success' \| 'warning' \| 'critical'` | `info` | The type of toast to display. Note: The tone value can modify component content such as icon, as well as behavior such as the duration it is visible with ToastProvider. |
| `children` | `ReactNode` | — | The content of the toast message |
| `isOpen` | `boolean` | — | Controlled open state |
| `onClose` | `() => void` | — | Function called with the close button is clicked. |
| `css` | `SystemStyleObject` | — | Styles object |
| `role` | `AriaRole` | `status` | Toasts should have a role of status or alert to signal assistive technologies that it requires the user's attention. In general, you will always want to use the less strict "status" role. |

