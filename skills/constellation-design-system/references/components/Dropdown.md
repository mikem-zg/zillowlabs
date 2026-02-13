# Dropdown

```tsx
import { Dropdown } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.28.0

## Usage

```tsx
import { Box, Dropdown, Paragraph } from '@zillow/constellation';
```

```tsx
export const DropdownBasic = () => (
  <Dropdown css={{ maxWidth: '320px' }}>
    <Box css={{ padding: 'default' }}>
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
      </Paragraph>
    </Box>
  </Dropdown>
);
```

## Examples

### Dropdown Auto Max Height

```tsx
import { Box, Dropdown, Paragraph } from '@zillow/constellation';
```

```tsx
export const DropdownAutoMaxHeight = () => (
  <Dropdown autoMaxHeight css={{ maxWidth: '320px' }}>
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default', padding: 'default' }}>
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed fringilla porta nibh, sed
        tempor enim luctus at. Etiam luctus erat non blandit viverra. Aenean at orci aliquet,
        faucibus ante in, ornare ipsum. Integer at suscipit odio, vitae ultrices nisl. Aliquam odio
        enim, laoreet eu risus ac, elementum placerat diam. Aliquam viverra luctus velit eget
        cursus. Duis non justo id purus dignissim viverra.
      </Paragraph>

      <Paragraph>
        Nulla sit amet fermentum elit, in dapibus massa. Suspendisse accumsan urna ut augue blandit,
        vel blandit nibh feugiat. Donec aliquam eros ac ultrices interdum. Sed lobortis lectus eget
        massa blandit, convallis faucibus sapien ultrices. Suspendisse tempus venenatis ligula, vel
        consequat lorem laoreet quis. Proin et arcu non enim vestibulum tempus ac venenatis justo.
        Fusce interdum nulla quis metus porttitor, sit amet bibendum diam ultrices. In ullamcorper
        felis eu nulla ultricies vehicula. In convallis vel massa eu interdum. Aenean eget erat
        tincidunt, eleifend est id, porttitor purus. In ultrices ligula sit amet leo fermentum
        tristique in eu tellus. Cras faucibus ultricies neque, finibus fermentum elit pretium a.
        Phasellus ligula sem, pulvinar id placerat sit amet, porttitor ac dolor. Nulla facilisi.
        Mauris enim arcu, ultricies ac est a, tristique tincidunt quam.
      </Paragraph>

      <Paragraph>
        Nam et pellentesque lacus. Proin bibendum dui sed velit congue, nec accumsan lorem
        malesuada. Etiam eu eros efficitur, blandit ante sit amet, aliquam elit. In gravida massa
        sed nulla blandit lacinia. Curabitur a nisl ante. Curabitur et quam ut ligula porttitor
        gravida. Cras sagittis mi ac lacus pellentesque, id consectetur libero gravida. Suspendisse
        id justo in ipsum sodales sodales eu iaculis elit. Mauris nisi tellus, semper vel sapien
        porttitor, eleifend consequat metus. Donec fermentum ac nisi in mollis. Duis dignissim
        efficitur purus quis fermentum. Vestibulum in consectetur augue, nec varius dui.
      </Paragraph>

      <Paragraph>
        Fusce egestas purus et cursus dictum. Praesent iaculis posuere imperdiet. Aenean fringilla
        justo a nisl iaculis, eget vulputate mauris euismod. Morbi luctus tellus id enim vehicula
        laoreet. Phasellus congue nisl et fermentum mollis. Morbi fringilla velit ut finibus
        dignissim. Sed at dignissim risus, vel scelerisque quam.
      </Paragraph>

      <Paragraph>
        In gravida luctus urna, id viverra neque molestie ut. Quisque eros ex, feugiat ac eros ut,
        commodo congue eros. Nullam euismod vel sem vitae luctus. Fusce dictum, arcu tempus
        efficitur facilisis, ipsum neque blandit nunc, nec facilisis urna erat id nulla. Vestibulum
        a tincidunt justo. Duis vehicula neque nec libero cursus consequat. Nunc congue enim vel
        ligula bibendum laoreet sed vitae metus. Donec vel nibh sed libero malesuada consectetur eu
        vitae velit. Phasellus non nulla faucibus, blandit sem sit amet, eleifend magna. Sed et
        varius lectus. Ut rutrum nulla ligula, semper convallis ante aliquet et. Duis semper mi
        nisl, vel scelerisque elit accumsan ac. Integer dapibus est ante, quis imperdiet sapien
        vestibulum vel.
      </Paragraph>

      <Paragraph>
        Ut faucibus rutrum justo, vitae fringilla elit vulputate vitae. In congue, erat ut sagittis
        commodo, justo enim blandit nunc, sed iaculis ligula mi varius tellus. Sed feugiat, ante ut
        sollicitudin luctus, ipsum ante semper augue, gravida auctor purus ligula et neque. Proin a
        nunc ut lacus placerat pharetra iaculis a elit. Integer laoreet elit eu massa auctor
        ultricies. Integer eu cursus odio, luctus tincidunt augue. Morbi in leo erat. Sed
        consectetur leo vel vulputate consequat. Nunc nec mi eros. Nam at dignissim erat, id
        faucibus nunc. Phasellus sit amet nisi consequat, commodo urna ac, bibendum sapien. Quisque
        id eleifend quam.
      </Paragraph>

      <Paragraph>
        Pellentesque et justo libero. Curabitur vel vehicula metus. Pellentesque quis odio dictum,
        luctus dolor et, rhoncus diam. Nulla sed urna tincidunt, aliquet arcu id, elementum erat.
        Suspendisse potenti. Aliquam ut lacus et eros scelerisque rhoncus. Aliquam tincidunt leo
        elit, vitae scelerisque lectus porta eu. Vivamus suscipit vehicula neque, eu ultricies
        turpis ultrices fringilla. Praesent auctor massa a tincidunt auctor. Mauris rhoncus et enim
        non elementum. Aliquam egestas facilisis venenatis. Aliquam bibendum dignissim consequat.
        Duis aliquet fermentum tincidunt. Sed efficitur, metus in viverra lacinia, justo elit
        maximus lacus, tincidunt mattis mi erat a elit.
      </Paragraph>

      <Paragraph>
        Cras blandit vehicula malesuada. Phasellus a dolor fringilla, dignissim velit dignissim,
        fermentum ligula. Curabitur eleifend tincidunt ante vel pretium. Nulla auctor lacinia
        pretium. Phasellus varius eros in semper gravida. Aenean in sapien augue. Class aptent
        taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut non nulla
        odio.
      </Paragraph>

      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse id lorem ullamcorper,
        semper tortor sit amet, venenatis purus. Vestibulum ante ipsum primis in faucibus orci
        luctus et ultrices posuere cubilia curae; Nam rhoncus, dolor vel scelerisque interdum,
        turpis dui posuere eros, nec rutrum nisi ipsum vel felis. Fusce id lacus vel nisl ultricies
        hendrerit. Morbi lacinia, felis eleifend tempus malesuada, leo quam convallis mi, ut
        dignissim magna mi pulvinar neque. Nunc non feugiat nulla, ut congue tellus. Suspendisse at
        molestie neque. In hac habitasse platea dictumst.
      </Paragraph>

      <Paragraph>
        Curabitur euismod ultricies ante. Etiam porttitor erat at elit aliquet, ut sodales felis
        maximus. Nam ut cursus arcu. Phasellus in turpis in tellus ultrices iaculis et quis leo.
        Integer lacinia, dui in sodales vestibulum, sem eros fermentum mi, quis rutrum lectus mauris
        lobortis ipsum. Sed sed ipsum ut mi suscipit cursus. Ut libero tellus, blandit eu lacus
        commodo, mollis auctor massa. Donec interdum auctor euismod. Aliquam erat volutpat. Proin eu
        metus fringilla, tristique tortor in, consequat elit. Donec consequat euismod nulla et
        consequat. Suspendisse ut quam non est lobortis viverra. In in augue erat.
      </Paragraph>
    </Box>
  </Dropdown>
);
```

### Dropdown Close Button

```tsx
import { Box, Dropdown, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const DropdownCloseButton = () => (
  <Dropdown css={{ maxWidth: '320px' }}>
    <Box css={{ padding: 'default' }}>
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
      </Paragraph>
      <Box css={{ marginBlockStart: 'default' }}>
        <Dropdown.Close>
          <TextButton>Close</TextButton>
        </Dropdown.Close>
      </Box>
    </Box>
  </Dropdown>
);
```

### Dropdown Composition With Form

```tsx
import {
  Box,
  Button,
  ButtonGroup,
  Divider,
  Dropdown,
  FormField,
  Icon,
  Input,
  Label,
  TextButton,
} from '@zillow/constellation';
```

```tsx
export const DropdownCompositionWithForm = () => (
  <Dropdown.Root>
    <Dropdown.Trigger>
      <Dropdown.Button>Open dropdown</Dropdown.Button>
    </Dropdown.Trigger>
    <Dropdown.Portal>
      <Dropdown.Content asChild css={{ maxWidth: '360px', maxHeight: '360px' }}>
        <form
          onSubmit={(event) => {
            event.preventDefault();
            alert('Form submitted!');
          }}
        >
          <Dropdown.Header>
            <Dropdown.Heading level={3}>
              <Icon render={<IconFilterFilled />} /> Filters
            </Dropdown.Heading>
          </Dropdown.Header>
          <Divider />
          <Dropdown.Body>
            <FormField label={<Label>Input one</Label>} control={<Input type="text" />} />
            <Box css={{ display: 'flex', gap: 'tight', marginBlock: 'tight' }}>
              <FormField label={<Label>Input two</Label>} control={<Input type="text" />} />
              <FormField label={<Label>Input three</Label>} control={<Input type="text" />} />
            </Box>
            <FormField label={<Label>Input four</Label>} control={<Input type="text" />} />
            <Box css={{ display: 'flex', gap: 'tight', marginBlock: 'tight' }}>
              <FormField label={<Label>Input five</Label>} control={<Input type="text" />} />
              <FormField label={<Label>Input six</Label>} control={<Input type="text" />} />
            </Box>
          </Dropdown.Body>
          <Divider />
          <Dropdown.Footer>
            <ButtonGroup aria-label="modal actions">
              <Dropdown.Close>
                <TextButton>Close</TextButton>
              </Dropdown.Close>
              <Button type="submit" tone="brand" emphasis="filled">
                Apply
              </Button>
            </ButtonGroup>
          </Dropdown.Footer>
        </form>
      </Dropdown.Content>
    </Dropdown.Portal>
  </Dropdown.Root>
);
```

### Dropdown Controlled Interaction Response

```tsx
import { Box, Dropdown, Paragraph } from '@zillow/constellation';
```

```tsx
export const DropdownControlledInteractionResponse = () => {
  const [open, setOpen] = useState(false);

  const slowHandler = useCallback(async (state: boolean) => {
    // Update state
    setOpen(() => state);

    // Force next frame paint
    await interactionResponse();

    // Expensive computation
    const start = new Date();
    while (new Date().getTime() - start.getTime() < 1000);
  }, []);

  return (
    <Dropdown open={open} onOpenChange={(state) => slowHandler(state)} css={{ maxWidth: '320px' }}>
      <Box css={{ padding: 'default' }}>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      </Box>
    </Dropdown>
  );
};
```

### Dropdown Inline Headings

```tsx
import { Box, Dropdown, Paragraph } from '@zillow/constellation';
```

```tsx
export const DropdownInlineHeadings = () => (
  <Dropdown css={{ maxWidth: '320px' }}>
    <>
      <Dropdown.Heading level={3}>Heading one</Dropdown.Heading>
      <Box css={{ padding: 'default' }}>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      </Box>
      <Dropdown.Heading level={3}>Heading two</Dropdown.Heading>
      <Box css={{ padding: 'default' }}>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      </Box>
    </>
  </Dropdown>
);
```

### Dropdown Shorthand With Headings

```tsx
import { Button, Dropdown, Paragraph } from '@zillow/constellation';
```

```tsx
export const DropdownShorthandWithHeadings = () => (
  <Dropdown
    css={{ maxWidth: '320px', maxHeight: '360px' }}
    dividers
    body={
      <>
        <Dropdown.Heading level={3}>Heading one</Dropdown.Heading>
        <Paragraph css={{ marginBlock: 'default' }}>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
        <Dropdown.Heading level={3}>Heading two</Dropdown.Heading>
        <Paragraph css={{ marginBlock: 'default' }}>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
        <Dropdown.Heading level={3}>Heading three</Dropdown.Heading>
        <Paragraph css={{ marginBlockStart: 'default' }}>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      </>
    }
    footer={
      <Dropdown.Close>
        <Button tone="brand" emphasis="filled" fluid>
          Done
        </Button>
      </Dropdown.Close>
    }
  />
);
```

### Dropdown Trigger As Dropdown Button

```tsx
import { Box, Dropdown, Paragraph } from '@zillow/constellation';
```

```tsx
export const DropdownTriggerAsDropdownButton = () => (
  <Dropdown css={{ maxWidth: '320px' }} trigger={<Dropdown.Button>Open dropdown</Dropdown.Button>}>
    <Box css={{ padding: 'default' }}>
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
      </Paragraph>
    </Box>
  </Dropdown>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `autoMaxHeight` | `boolean` | — | Automatically set max height to Dropdown.Content based on available space |
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
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
| `body` | `ReactNode` | — | Custom content to be used within Modal.Body |
| `className` | `DropdownContentPropsInterface['className']` | — | Class names passed to Dropdown.Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `dividers` | `boolean` | `false` | Display divider lines between body and footer sections when present. |
| `footer` | `ReactNode` | — | Custom content to be used within Modal.Footer |
| `header` | `ReactNode` | — | Custom content to be used within Modal.Header |
| `style` | `DropdownContentPropsInterface['style']` | — | Style passed to Dropdown.Content |
| `trigger` | `ReactNode` | — | Custom trigger to be used as Modal.Trigger |
| `portalId` | `FloatingPortalProps['id']` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified root (by default document.body). Passed to Dropdown.Portal. |
| `portalRoot` | `FloatingPortalProps['root']` | — | Specifies the root node the portal container will be appended to. Passed to Dropdown.Portal. |
| `portalPreserveTabOrder` | `FloatingPortalProps['preserveTabOrder']` | `true` | When using non-modal focus management, this will preserve the tab order context based on the React tree instead of the DOM tree. Passed to Dropdown.Portal. |

### DropdownBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### DropdownButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### DropdownClose

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### DropdownContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusManagerProps` | `FloatingFocusManagerProps` | `{}` | Floating UI's `FloatingFocusManager` props. See https://floating-ui.com/docs/FloatingFocusManager |

### DropdownFooter

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### DropdownHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### DropdownHeading

**Element:** `HTMLHeadingElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `level` | `1 \| 2 \| 3 \| 4 \| 5 \| 6` | — | Heading level **(required)** |

### DropdownPortal

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `id` | `string` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified `root` (by default `document.body`). |
| `root` | `HTMLElement \| ShadowRoot \| null \| React.MutableRefObject<HTMLElement \| ShadowRoot \| null>` | — | Specifies the root node the portal container will be appended to. |
| `preserveTabOrder` | `boolean` | — | When using non-modal focus management using `FloatingFocusManager`, this will preserve the tab order context based on the React tree instead of the DOM tree. |
| `css` | `SystemStyleObject` | — | Styles object |

### DropdownRoot

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `rootContext` | `FloatingRootContext<RT>` | — |  |
| `elements` | `{         /**          * Externally passed reference element. Store in state.          */         reference?: Element \| null;         /**          * Externally passed floating element. Store in state.          */         floating?: HTMLElement \| null;     }` | — | Object of external elements as an alternative to the `refs` object setters. |
| `nodeId` | `string` | — | Unique node id when using `FloatingTree`. |
| `autoMaxHeight` | `boolean` | — | Automatically set max height to Dropdown.Content based on available space |
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
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

### DropdownTrigger

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `<IconButton icon={<IconMoreFilled />} emphasis="bare" tone="brand" title="More" />` | Content |
| `css` | `SystemStyleObject` | — | Styles object |

