# Menu

```tsx
import { Menu } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.28.0

## Usage

```tsx
import { Menu } from '@zillow/constellation';
```

```tsx
export const MenuBasic = () => (
  <Menu
    content={
      <>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
  />
);
```

## Examples

### Menu Button Trigger

```tsx
import { Menu } from '@zillow/constellation';
```

```tsx
export const MenuButtonTrigger = () => (
  <Menu
    trigger={<Menu.Button>Open menu</Menu.Button>}
    content={
      <>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
  />
);
```

### Menu Composable

```tsx
import { Icon, Menu } from '@zillow/constellation';
```

```tsx
export const MenuComposable = () => (
  <Menu.Root>
    <Menu.Trigger>
      <Menu.Button>Open menu</Menu.Button>
    </Menu.Trigger>
    <Menu.Portal>
      <Menu.Content>
        <Menu.Heading level={3}>
          <Icon render={<IconLocationFilled />} /> Transportation
        </Menu.Heading>
        <Menu.Item>
          <Menu.ItemIcon render={<IconPedestrianFilled />} />
          <Menu.ItemLabel>Walk</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemIcon render={<IconBikeFilled />} />
          <Menu.ItemLabel>Bike</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item disabled>
          <Menu.ItemIcon render={<IconCarFilled />} />
          <Menu.ItemLabel>Car</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemIcon render={<IconBusFilled />} />
          <Menu.ItemLabel>Bus</Menu.ItemLabel>
        </Menu.Item>
      </Menu.Content>
    </Menu.Portal>
  </Menu.Root>
);
```

### Menu Controlled

```tsx
import { Icon, Menu } from '@zillow/constellation';
```

```tsx
export const MenuControlled = () => {
  const [open, onOpenChange] = useState<boolean>(false);
  const handler: UseFloatingOptions['onOpenChange'] = (open) => {
    onOpenChange(open);
  };
  return (
    <Menu
      open={open}
      onOpenChange={handler}
      content={
        <>
          <Menu.Heading level={3}>
            <Icon render={<IconLocationFilled />} /> Transportation
          </Menu.Heading>
          <Menu.Item>
            <Menu.ItemIcon render={<IconPedestrianFilled />} />
            <Menu.ItemLabel>Walk</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemIcon render={<IconBikeFilled />} />
            <Menu.ItemLabel>Bike</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item disabled>
            <Menu.ItemIcon render={<IconCarFilled />} />
            <Menu.ItemLabel>Car</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemIcon render={<IconBusFilled />} />
            <Menu.ItemLabel>Bus</Menu.ItemLabel>
          </Menu.Item>
        </>
      }
    />
  );
};
```

### Menu Groups

```tsx
import { Menu } from '@zillow/constellation';
```

```tsx
export const MenuGroups = () => (
  <Menu
    content={
      <>
        <Menu.Group>
          <Menu.Heading level={3}>Heading</Menu.Heading>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item disabled>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
        </Menu.Group>
        <Menu.Group>
          <Menu.Heading level={3}>Heading</Menu.Heading>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item disabled>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
        </Menu.Group>
      </>
    }
  />
);
```

### Menu Icons

```tsx
import { Icon, Menu } from '@zillow/constellation';
```

```tsx
export const MenuIcons = () => (
  <Menu
    content={
      <>
        <Menu.Heading level={3}>
          <Icon render={<IconLocationFilled />} /> Transportation
        </Menu.Heading>
        <Menu.Item>
          <Menu.ItemIcon render={<IconPedestrianFilled />} />
          <Menu.ItemLabel>Walk</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemIcon render={<IconBikeFilled />} />
          <Menu.ItemLabel>Bike</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item disabled>
          <Menu.ItemIcon render={<IconCarFilled />} />
          <Menu.ItemLabel>Car</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemIcon render={<IconBusFilled />} />
          <Menu.ItemLabel>Bus</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
  />
);
```

### Menu Link Items

```tsx
import { Menu } from '@zillow/constellation';
```

```tsx
export const MenuLinkItems = () => (
  <Menu
    content={
      <>
        <Menu.Item asChild>
          <a href="https://www.zillow.com">
            <Menu.ItemLabel>Link item</Menu.ItemLabel>
          </a>
        </Menu.Item>
        <Menu.Item asChild>
          <a href="https://www.zillow.com">
            <Menu.ItemLabel>Link item</Menu.ItemLabel>
          </a>
        </Menu.Item>
        <Menu.Item asChild disabled>
          <a href="https://www.zillow.com">
            <Menu.ItemLabel>Link item</Menu.ItemLabel>
          </a>
        </Menu.Item>
        <Menu.Item asChild>
          <a href="https://www.zillow.com">
            <Menu.ItemLabel>Link item</Menu.ItemLabel>
          </a>
        </Menu.Item>
      </>
    }
  />
);
```

### Menu Menu Item Sub Components

```tsx
import { Icon, Menu } from '@zillow/constellation';
```

```tsx
export const MenuMenuItemSubComponents = () => (
  <Menu
    content={
      <>
        <Menu.Heading level={3}>
          <Icon render={<IconLocationFilled />} /> Transportation
        </Menu.Heading>
        <Menu.Item>
          <Menu.ItemIcon render={<IconPedestrianFilled />} />
          <Menu.ItemLabel>Walk</Menu.ItemLabel>
          <Menu.ItemMeta>Description</Menu.ItemMeta>
        </Menu.Item>
        <Menu.Item asChild>
          <a href="https://www.zillow.com">
            <Menu.ItemIcon render={<IconBikeFilled />} />
            <Menu.ItemLabel>Bike</Menu.ItemLabel>
            <Menu.ItemMeta>Description</Menu.ItemMeta>
          </a>
        </Menu.Item>
        <Menu.Item disabled>
          <Menu.ItemIcon render={<IconCarFilled />} />
          <Menu.ItemLabel>Car</Menu.ItemLabel>
          <Menu.ItemMeta>Description</Menu.ItemMeta>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemIcon render={<IconBusFilled />} />
          <Menu.ItemLabel>Bus</Menu.ItemLabel>
          <Menu.ItemMeta>Description</Menu.ItemMeta>
        </Menu.Item>
      </>
    }
  />
);
```

### Menu Meta Items

```tsx
import { Menu } from '@zillow/constellation';
```

```tsx
export const MenuMetaItems = () => (
  <Menu
    content={
      <>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
          <Menu.ItemMeta>Description</Menu.ItemMeta>
        </Menu.Item>
        <Menu.Item asChild>
          <a href="https://www.zillow.com">
            <Menu.ItemLabel>Link item</Menu.ItemLabel>
            <Menu.ItemMeta>Description</Menu.ItemMeta>
          </a>
        </Menu.Item>
        <Menu.Item disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
          <Menu.ItemMeta>Description</Menu.ItemMeta>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
          <Menu.ItemMeta>Description</Menu.ItemMeta>
        </Menu.Item>
      </>
    }
  />
);
```

### Menu Modal Action Item

```tsx
import { Heading, Menu, Modal, Paragraph } from '@zillow/constellation';
```

```tsx
export const MenuModalActionItem = () => (
  <Menu
    content={
      <>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Modal
          trigger={
            <Menu.Item>
              <Menu.ItemLabel>Open modal action</Menu.ItemLabel>
            </Menu.Item>
          }
          header={<Heading level={3}>Modal heading</Heading>}
          body={
            <Paragraph>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
              porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
            </Paragraph>
          }
        />
        <Menu.Item disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
  />
);
```

### Menu No Heading Groups With Dividers

```tsx
import { Menu } from '@zillow/constellation';
```

```tsx
export const MenuNoHeadingGroupsWithDividers = () => (
  <Menu
    dividers
    content={
      <>
        <Menu.Group aria-label="Group heading one">
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
        </Menu.Group>
        <Menu.Group aria-label="Group heading two">
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
        </Menu.Group>
        <Menu.Group aria-label="Group heading three">
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
        </Menu.Group>
      </>
    }
  />
);
```

### Menu Single Heading

```tsx
import { Menu } from '@zillow/constellation';
```

```tsx
export const MenuSingleHeading = () => (
  <Menu
    content={
      <>
        <Menu.Heading level={3}>Heading</Menu.Heading>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `dividers` | `boolean` | `false` | Show divider between groups |
| `offset` | `OffsetOptions` | `22` | Dropdown content offset from trigger |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `placement` | `UseFloatingOptions['placement']` | `bottom-start` | Dropdown placement. If there is not enough space, Dropdown will pick the next best placement. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |
| `className` | `MenuContentPropsInterface['className']` | — | Class names passed to Menu.Content |
| `content` | `ReactNode` | — | Content to be used within Menu.Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `style` | `MenuContentPropsInterface['style']` | — | Style passed to Menu.Content |
| `trigger` | `ReactNode` | — | Custom trigger to be used as Menu.Trigger |
| `portalId` | `FloatingPortalProps['id']` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified root (by default document.body). Passed to Menu.Portal. |
| `portalRoot` | `FloatingPortalProps['root']` | — | Specifies the root node the portal container will be appended to. Passed to Menu.Portal. |
| `portalPreserveTabOrder` | `FloatingPortalProps['preserveTabOrder']` | `true` | When using non-modal focus management, this will preserve the tab order context based on the React tree instead of the DOM tree. Passed to Menu.Portal. |

### MenuButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### MenuContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusManagerProps` | `FloatingFocusManagerProps` | `{}` | Floating UI's `FloatingFocusManager` props. See https://floating-ui.com/docs/FloatingFocusManager |

### MenuGroup

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### MenuHeading

**Element:** `HTMLHeadingElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `level` | `1 \| 2 \| 3 \| 4 \| 5 \| 6` | — | Heading level **(required)** |

### MenuItem

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Disabled state |

### MenuItemIcon

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

### MenuItemLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### MenuItemMeta

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### MenuPortal

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `id` | `string` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified `root` (by default `document.body`). |
| `root` | `HTMLElement \| ShadowRoot \| null \| React.MutableRefObject<HTMLElement \| ShadowRoot \| null>` | — | Specifies the root node the portal container will be appended to. |
| `preserveTabOrder` | `boolean` | — | When using non-modal focus management using `FloatingFocusManager`, this will preserve the tab order context based on the React tree instead of the DOM tree. |
| `css` | `SystemStyleObject` | — | Styles object |

### MenuRoot

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `rootContext` | `FloatingRootContext<RT>` | — |  |
| `elements` | `{         /**          * Externally passed reference element. Store in state.          */         reference?: Element \| null;         /**          * Externally passed floating element. Store in state.          */         floating?: HTMLElement \| null;     }` | — | Object of external elements as an alternative to the `refs` object setters. |
| `nodeId` | `string` | — | Unique node id when using `FloatingTree`. |
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `dividers` | `boolean` | `false` | Show divider between groups |
| `offset` | `OffsetOptions` | `22` | Dropdown content offset from trigger |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `overflowPadding` | `DetectOverflowOptions['padding']` | `8` | This describes the virtual padding around the boundary to check for overflow. |
| `placement` | `UseFloatingOptions['placement']` | `bottom-start` | Dropdown placement. If there is not enough space, Dropdown will pick the next best placement. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `shouldCloseOnViewportLeave` | `boolean` | `false` | Close the trigger when the user scrolls away from the trigger node. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |

### MenuTrigger

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

