# Alert

```tsx
import { Alert } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.21.0

## Usage

```tsx
import { Alert } from '@zillow/constellation';
```

```tsx
export const AlertBasic = () => {
  return (
    <Alert>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
      mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
    </Alert>
  );
};
```

## Examples

### Alert Composed

```tsx
import { Alert, Anchor, CloseButton, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const AlertComposed = () => {
  return (
    // oxlint-disable-next-line no-console
    <Alert.Root onClose={() => console.log('composed clicked')}>
      <Alert.Body>
        <Paragraph>
          Lorem <Anchor>ipsum dolor</Anchor> sit amet, consectetur adipiscing elit. Fusce ornare
          lorem sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
        </Paragraph>
        <Alert.Action>
          <TextButton>Action</TextButton>
        </Alert.Action>
      </Alert.Body>
      <Alert.Close>
        <CloseButton />
      </Alert.Close>
    </Alert.Root>
  );
};
```

### Alert Controlled

```tsx
import { Alert, CloseButton, TextButton } from '@zillow/constellation';
```

```tsx
export const AlertControlled = () => {
  {
    const [open, setOpen] = useState(true);

    const handleClose = () => {
      setOpen(false);
      setTimeout(() => {
        setOpen(true);
      }, 1000);
    };

    return (
      <Alert
        actionButton={<TextButton onClick={handleClose}>Dismiss</TextButton>}
        tone="warning"
        closeButton={<CloseButton />}
        isOpen={open}
        onClose={handleClose}
      >
        Lorem ipsum dolor sit amet, consectetur.
      </Alert>
    );
  }
};
```

### Alert Tones

```tsx
import { Alert, Box } from '@zillow/constellation';
```

```tsx
export const AlertTones = () => {
  return (
    <Box css={{ display: 'flex', gap: 'layout.default', flexDirection: 'column' }}>
      <Alert tone="info">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
        mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
      </Alert>
      <Alert tone="success">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
        mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
      </Alert>
      <Alert tone="critical">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
        mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
      </Alert>
      <Alert tone="warning">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
        mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
      </Alert>
    </Box>
  );
};
```

### Alert With Action Button

```tsx
import { Alert, TextButton } from '@zillow/constellation';
```

```tsx
export const AlertWithActionButton = () => {
  return (
    <Alert actionButton={<TextButton>Action</TextButton>}>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
      mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
    </Alert>
  );
};
```

### Alert With Close Button

```tsx
import { Alert, CloseButton, TextButton } from '@zillow/constellation';
```

```tsx
export const AlertWithCloseButton = () => {
  return (
    <Alert actionButton={<TextButton>Action</TextButton>} closeButton={<CloseButton />}>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
      mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
    </Alert>
  );
};
```

### Alert With Custom Close Event

```tsx
import { Alert, CloseButton, TextButton } from '@zillow/constellation';
```

```tsx
export const AlertWithCustomCloseEvent = () => {
  return (
    <Alert
      actionButton={<TextButton>Action</TextButton>}
      closeButton={<CloseButton />}
      // oxlint-disable-next-line no-console
      onClose={() => console.log('custom close event')}
    >
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
      mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.
    </Alert>
  );
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `Extract<StatusType, 'critical' \| 'info' \| 'success' \| 'warning'>` | `info` | The type of the alert to display. |
| `children` | `ReactNode` | — | The body content of the Alert message. |
| `css` | `SystemStyleObject` | — | Styles object |
| `isOpen` | `boolean` | — | An Alert is uncontrolled by default. You can specify `isOpen` to manually control the visibility of the component. |
| `onClose` | `() => void` | — | Function called when the `closeButton` is clicked. |
| `role` | `'alert' \| 'status'` | `status` | Alerts should have a role of status or alert to signal to assistive technologies that it requires the user's attention. In general, you will want to use the less noisy "status" role. |
| `actionButton` | `ReactNode` | — | An optional action button. Typically a `<TextButton />` |
| `closeButton` | `ReactNode` | — | The close button node. Typically a `<CloseButton />`. |

### AlertAction

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content, typically a `<TextButton>` **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### AlertBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Any text content for Alert, `Alert.Action`s should be within this container **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### AlertClose

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content, typically a `<CloseButton>` **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### AlertRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `Extract<StatusType, 'critical' \| 'info' \| 'success' \| 'warning'>` | `info` | The type of the alert to display. |
| `children` | `ReactNode` | — | Content for composable Alert subcomponents |
| `css` | `SystemStyleObject` | — | Styles object |
| `isOpen` | `boolean` | — | An Alert is uncontrolled by default. You can specify `isOpen` to manually control the visibility of the component. |
| `onClose` | `() => void` | — | Function called when the `closeButton` is clicked. |
| `role` | `'alert' \| 'status'` | `status` | Alerts should have a role of status or alert to signal to assistive technologies that it requires the user's attention. In general, you will want to use the less noisy "status" role. |

