# ToastProvider

```tsx
import { ToastProvider } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.4.0

## Usage

```tsx
import { Button, ButtonGroup, Toast, ToastProvider, useToast } from '@zillow/constellation';
```

```tsx
const Triggers = () => {
  const { enqueueToast } = useToast();
  return (
    <ButtonGroup aria-label="Toast tone example">
      <Button
        onClick={() =>
          enqueueToast(<Toast tone="info">Lorem ipsum dolor sit amet, consectetur.</Toast>)
        }
      >
        Info
      </Button>
      <Button
        onClick={() =>
          enqueueToast(<Toast tone="warning">Lorem ipsum dolor sit amet, consectetur.</Toast>)
        }
      >
        Warning
      </Button>
      <Button
        onClick={() =>
          enqueueToast(<Toast tone="critical">Lorem ipsum dolor sit amet, consectetur.</Toast>)
        }
      >
        Critical
      </Button>
      <Button
        onClick={() =>
          enqueueToast(<Toast tone="success">Lorem ipsum dolor sit amet, consectetur.</Toast>)
        }
      >
        Success
      </Button>
    </ButtonGroup>
  );
};

export const ToastProviderBasic = () => (
  <ToastProvider>
    <Triggers />
  </ToastProvider>
);
```

## Examples

### Toast Provider Duration

```tsx
import { Button, ButtonGroup, Toast, ToastProvider, useToast } from '@zillow/constellation';
```

```tsx
const Triggers = () => {
  const { enqueueToast } = useToast();
  return (
    <ButtonGroup aria-label="Toast duration example">
      <Button
        onClick={() => enqueueToast(<Toast>This will not auto-dismiss</Toast>, { duration: 0 })}
      >
        Duration: 0
      </Button>
      <Button
        onClick={() =>
          enqueueToast(<Toast>This will dismiss after 1000ms</Toast>, { duration: 1000 })
        }
      >
        Duration: 1000
      </Button>
    </ButtonGroup>
  );
};

export const ToastProviderDuration = () => (
  <ToastProvider>
    <Triggers />
  </ToastProvider>
);
```

### Toast Provider Placement

```tsx
import { Box, Button, Toast, ToastProvider, useToast } from '@zillow/constellation';
```

```tsx
const Component: FC<PropsWithChildren> = (props) => {
  const { enqueueToast } = useToast();
  const onClick = () => {
    enqueueToast(<Toast>{props.children}</Toast>);
  };
  return <Button onClick={onClick}>{props.children}</Button>;
};

export const ToastProviderPlacement = () => (
  <Box css={{ display: 'flex', flexDirection: 'column', gap: 'layout.vast.default' }}>
    <Box css={{ display: 'flex', justifyContent: 'space-between' }}>
      <ToastProvider placement="top-start">
        <Component>top-start</Component>
      </ToastProvider>
      <ToastProvider placement="top">
        <Component>top</Component>
      </ToastProvider>
      <ToastProvider placement="top-end">
        <Component>top-end</Component>
      </ToastProvider>
    </Box>
    <Box css={{ display: 'flex', justifyContent: 'space-between' }}>
      <ToastProvider placement="bottom-start">
        <Component>bottom-start</Component>
      </ToastProvider>
      <ToastProvider placement="bottom">
        <Component>bottom</Component>
      </ToastProvider>
      <ToastProvider placement="bottom-end">
        <Component>bottom-end</Component>
      </ToastProvider>
    </Box>
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Components that require Toast context need to be children of this component. |
| `duration` | `number \| Partial<Record<'info' \| 'success' \| 'warning' \| 'critical', number>>` | `{ critical: 0, warning: 10000, info: 5000, success: 5000 }` | The default duration in milliseconds to show a toast before automatically dismissing it. Set this to `0` and toasts must manually be dismissed.  Note: A `duration` supplied in `enqueueToast()` options will take precedence over this value. |
| `maxSize` | `number` | — | The maximum number of toasts visible at once. Set this to `0` to remove the size limit. |
| `pauseOnMouseEnter` | `boolean` | — | By default, toasts are paused when the mouse enters them. |
| `pauseOnWindowBlur` | `boolean` | — | By default, all toasts are paused when the window loses focus. |
| `placement` | `'top-start' \| 'top' \| 'top-end' \| 'bottom-start' \| 'bottom' \| 'bottom-end'` | `bottom-end` | Where the toast region will exist with respect to the viewport. e.g. "top-start", "top", "top-end", "bottom-start", "bottom", "bottom-end" |
| `resumeOnMouseLeave` | `boolean` | — | By default, toasts are resumed when the mouse leaves them. |
| `resumeOnWindowFocus` | `boolean` | — | By default, all toasts are resumed when the window gains focus. |
| `portal` | `boolean \| HTMLElement \| Element` | `true` | By default, toasts will be rendered into a Portal in the document body. With this prop, you can specify a different container, or you can disable the portal to render the content inline by passing false. |
| `renderToast` | `(toast: ToastObjectInterface) => ReactNode` | `(toast) => <ToastProvider.Item key={toast.toastId} toast={toast} />` | Render function called when rendering individual Toasts |
| `css` | `SystemStyleObject` | — | Styles object |

### ToastProviderContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-live'` | `AriaAttributes['aria-live']` | `'polite'` | Tells assistive technologies that this is a region where content will be dynamically updated. All of our toast variants use `role="status"` so we default `aria-live` to the less-intrusive "polite" value. |
| `'css'` | `SystemStyleObject` | — | Styles object |

### ToastProviderItem

**Element:** `HTMLLIElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `toast` | `ToastObjectInterface` | — | Toast object generated by `useToastQueue` |
| `css` | `SystemStyleObject` | — | Styles object |

### ToastProviderList

**Element:** `HTMLUListElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `renderToast` | `(toast: ToastObjectInterface) => ReactNode` | `(toast) => <ToastProvider.Item key={toast.toastId} toast={toast} />` | Render function called when rendering individual Toasts |

### ToastProviderPortal

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `portal` | `boolean \| HTMLElement \| Element` | `true` | By default, toasts will be rendered into a Portal in the document body. With this prop, you can specify a different container, or you can disable the portal to render the content inline by passing false. |
| `children` | `ReactNode` | — | Contents of the React portal |

### ToastProviderRoot

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Components that require Toast context need to be children of this component. |
| `duration` | `number \| Partial<Record<'info' \| 'success' \| 'warning' \| 'critical', number>>` | `{ critical: 0, warning: 10000, info: 5000, success: 5000 }` | The default duration in milliseconds to show a toast before automatically dismissing it. Set this to `0` and toasts must manually be dismissed. Note: A `duration` supplied in `enqueueToast()` options will take precedence over this value. |
| `maxSize` | `number` | `3` | The maximum number of toasts visible at once. Set this to `0` to remove the size limit. |
| `pauseOnMouseEnter` | `boolean` | `true` | By default, toasts are paused when the mouse enters them. |
| `pauseOnWindowBlur` | `boolean` | `true` | By default, all toasts are paused when the window loses focus. |
| `placement` | `'top-start' \| 'top' \| 'top-end' \| 'bottom-start' \| 'bottom' \| 'bottom-end'` | `bottom-end` | Where the toast region will exist with respect to the viewport. e.g. "top-start", "top", "top-end", "bottom-start", "bottom", "bottom-end" |
| `resumeOnMouseLeave` | `boolean` | `true` | By default, toasts are resumed when the mouse leaves them. |
| `resumeOnWindowFocus` | `boolean` | `true` | By default, all toasts are resumed when the window gains focus. |

