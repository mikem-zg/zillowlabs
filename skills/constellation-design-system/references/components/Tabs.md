# Tabs

```tsx
import { Tabs } from '@zillow/constellation';
```

**Version:** 10.11.0

## CRITICAL: Always set `defaultSelected`

**ALWAYS include `defaultSelected` on `Tabs.Root` to ensure the first tab is selected on render.** Without this prop, no tab will be visually selected when the component mounts, resulting in a broken-looking UI.

```tsx
// CORRECT - first tab is selected by default
<Tabs.Root defaultSelected="tab-1">

// WRONG - no tab selected on mount
<Tabs.Root>

// WRONG - defaultValue does not exist on this component
<Tabs.Root defaultValue="tab-1">
```

The `defaultSelected` value must match the `value` prop of the `Tabs.Tab` you want selected initially.

## Usage

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsBasic = () => (
  <Tabs.Root appearance="default" defaultSelected="tab-1">
    <Tabs.List>
      <Tabs.Tab value="tab-1">Tab 1</Tabs.Tab>
      <Tabs.Tab value="tab-2">Tab 2</Tabs.Tab>
      <Tabs.Tab value="tab-3">Tab 3</Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="tab-1">Panel 1</Tabs.Panel>
    <Tabs.Panel value="tab-2">Panel 2</Tabs.Panel>
    <Tabs.Panel value="tab-3">Panel 3</Tabs.Panel>
  </Tabs.Root>
);
```

## Examples

### Tabs All Disabled

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsAllDisabled = () => (
  <Tabs.Root appearance="default" defaultSelected="tab-1" disabled>
    <Tabs.List>
      <Tabs.Tab value="tab-1">Tab 1</Tabs.Tab>
      <Tabs.Tab value="tab-2">Tab 2</Tabs.Tab>
      <Tabs.Tab value="tab-3">Tab 3</Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="tab-1">Panel 1</Tabs.Panel>
    <Tabs.Panel value="tab-2">Panel 2</Tabs.Panel>
    <Tabs.Panel value="tab-3">Panel 3</Tabs.Panel>
  </Tabs.Root>
);
```

### Tabs As Links

```tsx
import { Box, Tabs } from '@zillow/constellation';
```

```tsx
export const TabsAsLinks = () => (
  <Box css={{ width: '320px' }}>
    <Tabs.Root appearance="default" defaultSelected="zillow-tab">
      <Tabs.List>
        <Tabs.Tab asChild value="zillow-tab">
          <a href="https://www.zillow.com">Zillow</a>
        </Tabs.Tab>
        <Tabs.Tab asChild value="trulia-tab" disabled>
          <a href="https://www.trulia.com">Trulia</a>
        </Tabs.Tab>
      </Tabs.List>
    </Tabs.Root>
  </Box>
);
```

### Tabs Controlled

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsControlled = () => {
  const [selected, setSelected] = useState<string>('tab-3');
  return (
    <Tabs.Root
      appearance="default"
      selected={selected}
      onSelectedChange={(value: string) => {
        // oxlint-disable-next-line no-console
        console.log(value);
        setSelected(value);
      }}
    >
      <Tabs.List>
        <Tabs.Tab value="tab-1">Tab 1</Tabs.Tab>
        <Tabs.Tab value="tab-2">Tab 2</Tabs.Tab>
        <Tabs.Tab value="tab-3">Tab 3</Tabs.Tab>
      </Tabs.List>
      <Tabs.Panel value="tab-1">Panel 1</Tabs.Panel>
      <Tabs.Panel value="tab-2">Panel 2</Tabs.Panel>
      <Tabs.Panel value="tab-3">Panel 3</Tabs.Panel>
    </Tabs.Root>
  );
};
```

### Tabs Custom Id And Labelledby

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsCustomIdAndLabelledby = () => (
  <Tabs.Root
    appearance="default"
    defaultSelected="zillow-tab"
    onSelectedChange={(props) => {
      // oxlint-disable-next-line no-console
      console.log(props);
    }}
  >
    <Tabs.List>
      <Tabs.Tab id="zillow-tab" aria-controls="zillow-panel" value="zillow-tab">
        Zillow
      </Tabs.Tab>
      <Tabs.Tab id="trulia-tab" aria-controls="trulia-panel" value="trulia-tab">
        Trulia
      </Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel id="zillow-panel" aria-labelledby="zillow-tab" value="zillow-tab">
      Zillow Panel
    </Tabs.Panel>
    <Tabs.Panel id="trulia-panel" aria-labelledby="trulia-tab" value="trulia-tab">
      Trulia Panel
    </Tabs.Panel>
  </Tabs.Root>
);
```

### Tabs Default Selected

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsDefaultSelected = () => (
  <Tabs.Root appearance="default" defaultSelected="tab-2">
    <Tabs.List>
      <Tabs.Tab value="tab-1">Tab 1</Tabs.Tab>
      <Tabs.Tab value="tab-2">Tab 2</Tabs.Tab>
      <Tabs.Tab value="tab-3">Tab 3</Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="tab-1">Panel 1</Tabs.Panel>
    <Tabs.Panel value="tab-2">Panel 2</Tabs.Panel>
    <Tabs.Panel value="tab-3">Panel 3</Tabs.Panel>
  </Tabs.Root>
);
```

### Tabs Disabled

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsDisabled = () => (
  <Tabs.Root appearance="default" defaultSelected="tab-1">
    <Tabs.List>
      <Tabs.Tab value="tab-1">Tab 1</Tabs.Tab>
      <Tabs.Tab value="tab-2">Tab 2</Tabs.Tab>
      <Tabs.Tab disabled value="tab-3">
        Tab 3
      </Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="tab-1">Panel 1</Tabs.Panel>
    <Tabs.Panel value="tab-2">Panel 2</Tabs.Panel>
    <Tabs.Panel value="tab-3">Panel 3</Tabs.Panel>
  </Tabs.Root>
);
```

### Tabs Dynamic Sizing

```tsx
import { Box, Tabs } from '@zillow/constellation';
```

```tsx
export const TabsDynamicSizing = () => (
  <Box css={{ width: '320px' }}>
    <Tabs.Root appearance="file" defaultSelected="zillow-tab">
      <Tabs.List>
        <Tabs.Tab value="zillow-tab">Zillow</Tabs.Tab>
        <Tabs.Tab value="trulia-tab">Trulia</Tabs.Tab>
        <Tabs.Tab value="premieragent-tab">Premier Agent</Tabs.Tab>
        <Tabs.Tab value="streeteasy-tab">StreetEasy</Tabs.Tab>
      </Tabs.List>
      <Tabs.Panel value="zillow-tab">Zillow Panel</Tabs.Panel>
      <Tabs.Panel value="trulia-tab">Trulia Panel</Tabs.Panel>
      <Tabs.Panel value="premieragent-tab">Premier Agent Panel</Tabs.Panel>
      <Tabs.Panel value="streeteasy-tab">StreetEasy Panel</Tabs.Panel>
    </Tabs.Root>
  </Box>
);
```

### Tabs File

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsFile = () => (
  <Tabs.Root appearance="file" defaultSelected="tab-1">
    <Tabs.List>
      <Tabs.Tab value="tab-1">Tab 1</Tabs.Tab>
      <Tabs.Tab value="tab-2">Tab 2</Tabs.Tab>
      <Tabs.Tab value="tab-3">Tab 3</Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="tab-1">Panel 1</Tabs.Panel>
    <Tabs.Panel value="tab-2">Panel 2</Tabs.Panel>
    <Tabs.Panel value="tab-3">Panel 3</Tabs.Panel>
  </Tabs.Root>
);
```

### Tabs Justify End

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsJustifyEnd = () => (
  <Tabs.Root appearance="default" defaultSelected="streeteasy-tab">
    <Tabs.List css={{ justifyContent: 'flex-end' }}>
      <Tabs.Tab value="zillow-tab">Zillow</Tabs.Tab>
      <Tabs.Tab value="trulia-tab">Trulia</Tabs.Tab>
      <Tabs.Tab value="premieragent-tab">Premier Agent</Tabs.Tab>
      <Tabs.Tab value="streeteasy-tab">StreetEasy</Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="zillow-tab">Zillow Panel</Tabs.Panel>
    <Tabs.Panel value="trulia-tab">Trulia Panel</Tabs.Panel>
    <Tabs.Panel value="premieragent-tab">Premier Agent Panel</Tabs.Panel>
    <Tabs.Panel value="streeteasy-tab">StreetEasy Panel</Tabs.Panel>
  </Tabs.Root>
);
```

### Tabs Manual Activation

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsManualActivation = () => (
  <Tabs.Root appearance="default" manualActivation defaultSelected="tab-1">
    <Tabs.List>
      <Tabs.Tab value="tab-1">Tab 1</Tabs.Tab>
      <Tabs.Tab value="tab-2">Tab 2</Tabs.Tab>
      <Tabs.Tab value="tab-3">Tab 3</Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="tab-1">Panel 1</Tabs.Panel>
    <Tabs.Panel value="tab-2">Panel 2</Tabs.Panel>
    <Tabs.Panel value="tab-3">Panel 3</Tabs.Panel>
  </Tabs.Root>
);
```

### Tabs On Selected Change

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsOnSelectedChange = () => (
  <Tabs.Root
    appearance="default"
    defaultSelected="zillow-tab"
    onSelectedChange={(props) => {
      // oxlint-disable-next-line no-console
      console.log(props);
    }}
  >
    <Tabs.List>
      <Tabs.Tab value="zillow-tab">Zillow</Tabs.Tab>
      <Tabs.Tab value="trulia-tab">Trulia</Tabs.Tab>
      <Tabs.Tab value="premieragent-tab">Premier Agent</Tabs.Tab>
      <Tabs.Tab value="streeteasy-tab">StreetEasy</Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="zillow-tab">Zillow Panel</Tabs.Panel>
    <Tabs.Panel value="trulia-tab">Trulia Panel</Tabs.Panel>
    <Tabs.Panel value="premieragent-tab">Premier Agent Panel</Tabs.Panel>
    <Tabs.Panel value="streeteasy-tab">StreetEasy Panel</Tabs.Panel>
  </Tabs.Root>
);
```

### Tabs With Icons

```tsx
import { Tabs } from '@zillow/constellation';
```

```tsx
export const TabsWithIcons = () => (
  <Tabs.Root appearance="default" defaultSelected="tab-1">
    <Tabs.List>
      <Tabs.Tab icon={<IconMailFilled />} value="tab-1">
        Tab 1
      </Tabs.Tab>
      <Tabs.Tab icon={<IconArchiveFilled />} value="tab-2">
        Tab 2
      </Tabs.Tab>
      <Tabs.Tab icon={<IconDeleteFilled />} value="tab-3">
        Tab 3
      </Tabs.Tab>
    </Tabs.List>
    <Tabs.Panel value="tab-1">Panel 1</Tabs.Panel>
    <Tabs.Panel value="tab-2">Panel 2</Tabs.Panel>
    <Tabs.Panel value="tab-3">Panel 3</Tabs.Panel>
  </Tabs.Root>
);
```

## API

### TabsList

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | A group of `Tabs.Tab` components. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### TabsPanel

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | A group of `Tabs.Panel` components. **(required)** |
| `value` | `string` | — | This must match the `value` of the `Tabs.Tab` associated with this panel. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### TabsRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `appearance` | `'default' \| 'file'` | `default` | The style of `Tabs.Tab` to display. Overrides `appearance` set on `Tabs.List`. |
| `children` | `ReactNode` | — | `Tabs.Root` expects `Tabs.List` and `Tabs.Panel` as direct children. **(required)** |
| `disabled` | `boolean` | `false;` | Set the all tabs as disabled. |
| `css` | `SystemStyleObject` | — | Styles object |
| `defaultSelected` | `string` | — | The id of the `Tabs.Tab` to select by default. When set, `Tabs` will behave as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). `Tabs` must be set with either `selected` or `defaultSelected`, but not both. Overrides `defaultSelected` set on `Tabs.List`. |
| `fluid` | `boolean` | `false` | When `true`, the `Tabs.List` stretches to fill its container and tries to maintain equal tab widths. Overrides `fluid` set on `Tabs.List`. |
| `manualActivation` | `boolean` | — | Describes the behavior when navigating the `Tabs.List` with arrow keys. By default, when a new `Tabs.Tab` is given focus, its corresponding `Tabs.Panel` will display automatically. When `manualActivation` is set to "true", the user must press the Spacebar or Enter key before the panel is displayed. In circumstances where content can be displayed instantly (i.e., all `Tabs.Panel` content is present in the DOM), use the default behavior. If changing panels requires first loading the content, set `manualActivation` to "true". https://www.w3.org/TR/wai-aria-practices-1.2/#kbd_selection_follows_focus |
| `onSelectedChange` | `(value: string) => void` | — | Callback for when a new tab is selected. Passes the id of the selected `Tabs.Tab`. |
| `selected` | `string` | — | The id of the selected `Tabs.Tab`. When used, `Tabs` will behave as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). `Tabs` must be set with either `selected` or `defaultSelected`, but not both. Overrides `selected` set on `Tabs.List`. |

### TabsTab

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the `Tabs.Tab` as disabled. |
| `icon` | `ReactNode` | — | Add an `Icon` to the button. |
| `value` | `string` | — | A unique identifier. If this `Tabs.Tab`'s `value` matches the `selected` or `defaultSelected` prop on `Tabs.Root`, this `Tabs.Tab` will be selected. If you're using `Tabs.Panel` components this `value` must match the `value` of the corresponding `Tabs.Panel`. **(required)** |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |

### TabsTabIcon

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

