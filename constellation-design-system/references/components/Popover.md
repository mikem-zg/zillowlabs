# Popover

```tsx
import { Popover } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.0.0

## Usage

```tsx
import { Heading, Paragraph, Popover } from '@zillow/constellation';
```

```tsx
export const PopoverBasic = () => (
  <Popover
    header={<Heading level={4}>Popover heading</Heading>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
      </Paragraph>
    }
  />
);
```

## Examples

### Popover Composable

```tsx
import { Button, Divider, Heading, Paragraph, Popover } from '@zillow/constellation';
```

```tsx
export const PopoverComposable = () => (
  <Popover.Root>
    <Popover.Trigger />
    <Popover.Portal>
      <Popover.Backdrop>
        <Popover.Content>
          <Popover.Header>
            <Heading level={3}>Popover heading</Heading>
          </Popover.Header>
          <Divider />
          <Popover.Body>
            <Paragraph css={{ marginBlockEnd: 'default' }}>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
              porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
            </Paragraph>
            <Popover.Close>
              <Button>Close</Button>
            </Popover.Close>
          </Popover.Body>
          <Popover.Arrow />
          <Popover.CloseButton />
        </Popover.Content>
      </Popover.Backdrop>
    </Popover.Portal>
  </Popover.Root>
);
```

### Popover Controlled

```tsx
import { Button, Heading, Paragraph, Popover } from '@zillow/constellation';
```

```tsx
export const PopoverControlled = () => {
  const [open, onOpenChange] = useState<boolean>(false);
  const handler: UseFloatingOptions['onOpenChange'] = (open) => {
    onOpenChange(open);
  };
  return (
    <Popover
      header={<Heading level={5}>Popover heading</Heading>}
      body={
        <>
          <Paragraph css={{ marginBlockEnd: 'default' }}>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
            porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
          </Paragraph>{' '}
          <Popover.Close>
            <Button>Close</Button>
          </Popover.Close>
        </>
      }
      open={open}
      onOpenChange={handler}
    />
  );
};
```

### Popover Custom Close Button

```tsx
import { Box, Heading, Paragraph, Popover, TextButton } from '@zillow/constellation';
```

```tsx
export const PopoverCustomCloseButton = () => (
  <Popover
    header={<Heading level={4}>Popover heading</Heading>}
    body={
      <>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
        <Box css={{ marginBlockStart: 'default' }}>
          <Popover.Close>
            <TextButton>Close</TextButton>
          </Popover.Close>
        </Box>
      </>
    }
  />
);
```

### Popover Overflow Content

```tsx
import { Heading, Paragraph, Popover } from '@zillow/constellation';
```

```tsx
export const PopoverOverflowContent = () => (
  <Popover
    header={<Heading level={4}>Popover heading</Heading>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et
        aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna.
        Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada
        lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
        malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin. Lorem
        ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et
        aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna.
        Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada
        lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
        malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin. Lorem
        ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et
        aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna.
        Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada
        lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
        malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
  />
);
```

### Popover Tone

```tsx
import { Button, ButtonGroup, Heading, Paragraph, Popover } from '@zillow/constellation';
```

```tsx
export const PopoverTone = () => (
  <ButtonGroup aria-label="Popovers">
    <Popover
      tone="neutral"
      header={<Heading level={4}>Popover heading</Heading>}
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      }
      trigger={<Button>Netural</Button>}
    />
    <Popover
      tone="critical"
      header={<Heading level={4}>Popover heading</Heading>}
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      }
      trigger={<Button>Critical</Button>}
    />
    <Popover
      tone="info"
      header={<Heading level={4}>Popover heading</Heading>}
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      }
      trigger={<Button>Info</Button>}
    />
    <Popover
      tone="success"
      header={<Heading level={4}>Popover heading</Heading>}
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      }
      trigger={<Button>Success</Button>}
    />
    <Popover
      tone="warning"
      header={<Heading level={4}>Popover heading</Heading>}
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      }
      trigger={<Button>Warning</Button>}
    />
  </ButtonGroup>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `dividers` | `boolean` | `true` | Display divider lines between header and body sections when present. |
| `modal` | `boolean` | `true` | When true, the popover will look like a modal until the medium breakpoint. |
| `offset` | `OffsetOptions` | `22` | Popover content offset from trigger |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `placement` | `UseFloatingOptions['placement']` | `top` | Popover placement. If there is not enough space, Popover will pick the next best placement. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `tone` | `'neutral' \| 'critical' \| 'info' \| 'success' \| 'warning'` | `neutral` | Change the tone of the popover. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |
| `body` | `ReactNode` | — | Custom content to be used within Popover.Body **(required)** |
| `className` | `PopoverContentPropsInterface['className']` | — | Class names passed to Popover.Content |
| `closeButton` | `ReactNode` | — | Custom content to be used within Popover.CloseButton |
| `css` | `SystemStyleObject` | — | Styles object |
| `header` | `ReactNode` | — | Custom content to be used within Popover.Header **(required)** |
| `style` | `PopoverContentPropsInterface['style']` | — | Style passed to Popover.Content |
| `trigger` | `ReactNode` | — | Custom trigger to be used as Popover.Trigger |
| `portalId` | `FloatingPortalProps['id']` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified root (by default document.body). Passed to Popover.Portal. |
| `portalRoot` | `FloatingPortalProps['root']` | — | Specifies the root node the portal container will be appended to. Passed to Popover.Portal. |
| `portalPreserveTabOrder` | `FloatingPortalProps['preserveTabOrder']` | `true` | When using non-modal focus management, this will preserve the tab order context based on the React tree instead of the DOM tree. Passed to Popover.Portal. |

### PopoverArrow

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `context` | `FloatingContext` | — | Tooltip context |
| `width` | `number` | `24` | The width of the arrow |
| `height` | `number` | `14` | The height of the arrow |
| `tipRadius` | `number` | `1` | The radius (rounding) of the arrow tip |
| `staticOffset` | `number \| string \| null` | — | A static offset override of the arrow from the floating element edge |
| `d` | `string` | — | A custom path for the arrow |
| `fill` | `string` | — | The color of the arrow |
| `stroke` | `string` | `none` | The stroke (border) color of the arrow |
| `strokeWidth` | `number` | `0` | The stroke (border) width of the arrow |

### PopoverBackdrop

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `lockScroll` | `boolean` | `false` | Whether the overlay should lock scrolling on the document body. |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PopoverBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PopoverClose

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### PopoverCloseButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `<CloseButton />` | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### PopoverContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `dividers` | `boolean` | `true` | Display divider lines between header and body sections when present. |
| `focusManagerProps` | `FloatingFocusManagerProps` | `{}` | Floating UI's `FloatingFocusManager` props. See https://floating-ui.com/docs/FloatingFocusManager |

### PopoverHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PopoverPortal

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `id` | `string` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified `root` (by default `document.body`). |
| `root` | `HTMLElement \| ShadowRoot \| null \| React.MutableRefObject<HTMLElement \| ShadowRoot \| null>` | — | Specifies the root node the portal container will be appended to. |
| `preserveTabOrder` | `boolean` | — | When using non-modal focus management using `FloatingFocusManager`, this will preserve the tab order context based on the React tree instead of the DOM tree. |
| `css` | `SystemStyleObject` | — | Styles object |

### PopoverRoot

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `rootContext` | `FloatingRootContext<RT>` | — |  |
| `elements` | `{         /**          * Externally passed reference element. Store in state.          */         reference?: Element \| null;         /**          * Externally passed floating element. Store in state.          */         floating?: HTMLElement \| null;     }` | — | Object of external elements as an alternative to the `refs` object setters. |
| `nodeId` | `string` | — | Unique node id when using `FloatingTree`. |
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `dividers` | `boolean` | `true` | Display divider lines between header and body sections when present. |
| `modal` | `boolean` | `true` | When true, the popover will look like a modal until the medium breakpoint. |
| `offset` | `OffsetOptions` | `22` | Popover content offset from trigger |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `placement` | `UseFloatingOptions['placement']` | `top` | Popover placement. If there is not enough space, Popover will pick the next best placement. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `tone` | `'neutral' \| 'critical' \| 'info' \| 'success' \| 'warning'` | `neutral` | Change the tone of the popover. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |

### PopoverTrigger

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `<TriggerButton />` | Content |
| `css` | `SystemStyleObject` | — | Styles object |

