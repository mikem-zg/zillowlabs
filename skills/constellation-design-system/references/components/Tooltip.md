# Tooltip

```tsx
import { Tooltip } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.0.0

## Usage

```tsx
import { Tooltip } from '@zillow/constellation';
```

```tsx
export const TooltipBasic = () => <Tooltip content="Lorem ipsum dolor sit amet." />;
```

## Examples

### Tooltip Close On Viewport Leave

```tsx
import { Tooltip } from '@zillow/constellation';
```

```tsx
export const TooltipCloseOnViewportLeave = () => (
  <Tooltip content="Lorem ipsum dolor sit amet." shouldCloseOnViewportLeave />
);
```

### Tooltip Composable

```tsx
import { Tooltip } from '@zillow/constellation';
```

```tsx
export const TooltipComposable = () => (
  <Tooltip.Root>
    <Tooltip.Trigger />
    <Tooltip.Portal>
      <Tooltip.Content>
        Lorem ipsum dolor sit amet.
        <Tooltip.Arrow />
      </Tooltip.Content>
    </Tooltip.Portal>
  </Tooltip.Root>
);
```

### Tooltip Controlled Composable

```tsx
import { Tooltip } from '@zillow/constellation';
```

```tsx
export const TooltipControlledComposable = () => {
  const [open, onOpenChange] = useState<boolean>(false);
  const handler: UseFloatingOptions['onOpenChange'] = (open) => {
    onOpenChange(open);
  };
  return (
    <Tooltip.Root open={open} onOpenChange={handler}>
      <Tooltip.Trigger />
      <Tooltip.Portal>
        <Tooltip.Content>
          Lorem ipsum dolor sit amet.
          <Tooltip.Arrow />
        </Tooltip.Content>
      </Tooltip.Portal>
    </Tooltip.Root>
  );
};
```

### Tooltip Controlled Shorthand

```tsx
import { Tooltip } from '@zillow/constellation';
```

```tsx
export const TooltipControlledShorthand = () => {
  const [open, onOpenChange] = useState<boolean>(false);
  const handler: UseFloatingOptions['onOpenChange'] = (open) => {
    onOpenChange(open);
  };
  return <Tooltip content="Lorem ipsum dolor sit amet." open={open} onOpenChange={handler} />;
};
```

### Tooltip Custom Trigger

```tsx
import { Paragraph, Tooltip, TriggerText } from '@zillow/constellation';
```

```tsx
export const TooltipCustomTrigger = () => (
  <Paragraph>
    Lorem ipsum{' '}
    <Tooltip
      content="Lorem ipsum dolor sit amet."
      trigger={<TriggerText>dolor sit amet</TriggerText>}
    />
    , consectetur adipiscing elit.
  </Paragraph>
);
```

### Tooltip Default Open

```tsx
import { Tooltip } from '@zillow/constellation';
```

```tsx
export const TooltipDefaultOpen = () => (
  <Tooltip content="Lorem ipsum dolor sit amet." defaultOpen placement="right" />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `offset` | `OffsetOptions` | `22` | Tooltip content offset from trigger |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `placement` | `UseFloatingOptions['placement']` | `top` | Tooltip placement. If there is not enough space, Tooltip will pick the next best placement. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useFocusProps` | `UseFocusProps` | — | Floating UI's `useFocus` props. See https://floating-ui.com/docs/useFocus |
| `useHoverProps` | `UseHoverProps` | — | Floating UI's `useHover` props. See https://floating-ui.com/docs/useHover |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |
| `forceUpdateDependency` | `any` | — | The component will call Floating UI `update()` function when this prop changes |
| `className` | `TooltipContentPropsInterface['className']` | — | Class names passed to Tooltip.Content |
| `content` | `string` | — | Custom content to be used within Tooltip.Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusManagerProps` | `Partial<FloatingFocusManagerProps>` | `{}` | Props to be passed to the FloatingFocusManager |
| `style` | `TooltipContentPropsInterface['style']` | — | Style passed to Tooltip.Content |
| `trigger` | `ReactNode` | — | Custom trigger to be used as Tooltip.Trigger |
| `portalId` | `FloatingPortalProps['id']` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified root (by default document.body). Passed to Tooltip.Portal. |
| `portalRoot` | `FloatingPortalProps['root']` | — | Specifies the root node the portal container will be appended to. Passed to Tooltip.Portal. |
| `portalPreserveTabOrder` | `FloatingPortalProps['preserveTabOrder']` | `true` | When using non-modal focus management, this will preserve the tab order context based on the React tree instead of the DOM tree. Passed to Tooltip.Portal. |

### TooltipArrow

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

### TooltipContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusManagerProps` | `Partial<FloatingFocusManagerProps>` | `{}` | Floating UI's `FloatingFocusManager` props. See https://floating-ui.com/docs/FloatingFocusManager |

### TooltipPortal

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `id` | `string` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified `root` (by default `document.body`). |
| `root` | `HTMLElement \| ShadowRoot \| null \| React.MutableRefObject<HTMLElement \| ShadowRoot \| null>` | — | Specifies the root node the portal container will be appended to. |
| `preserveTabOrder` | `boolean` | — | When using non-modal focus management using `FloatingFocusManager`, this will preserve the tab order context based on the React tree instead of the DOM tree. |
| `css` | `SystemStyleObject` | — | Styles object |

### TooltipRoot

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `rootContext` | `FloatingRootContext<RT>` | — |  |
| `elements` | `{         /**          * Externally passed reference element. Store in state.          */         reference?: Element \| null;         /**          * Externally passed floating element. Store in state.          */         floating?: HTMLElement \| null;     }` | — | Object of external elements as an alternative to the `refs` object setters. |
| `nodeId` | `string` | — | Unique node id when using `FloatingTree`. |
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `offset` | `OffsetOptions` | `22` | Tooltip content offset from trigger |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `placement` | `UseFloatingOptions['placement']` | `top` | Tooltip placement. If there is not enough space, Tooltip will pick the next best placement. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useFocusProps` | `UseFocusProps` | — | Floating UI's `useFocus` props. See https://floating-ui.com/docs/useFocus |
| `useHoverProps` | `UseHoverProps` | — | Floating UI's `useHover` props. See https://floating-ui.com/docs/useHover |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |
| `forceUpdateDependency` | `any` | — | The component will call Floating UI `update()` function when this prop changes |

### TooltipTrigger

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `<TriggerButton />` | Content |
| `css` | `SystemStyleObject` | — | Styles object |

