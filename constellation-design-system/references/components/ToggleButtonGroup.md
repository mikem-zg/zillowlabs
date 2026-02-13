# ToggleButtonGroup

```tsx
import { ToggleButtonGroup } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.0.0

## Usage

```tsx
import { ToggleButton, ToggleButtonGroup } from '@zillow/constellation';
```

```tsx
export const ToggleButtonGroupBasic = () => (
  <ToggleButtonGroup aria-label="Storybook Example">
    <ToggleButton value="first">First</ToggleButton>
    <ToggleButton value="second">Second</ToggleButton>
    <ToggleButton value="third">Third</ToggleButton>
    <ToggleButton value="last">Last</ToggleButton>
  </ToggleButtonGroup>
);
```

## Examples

### Toggle Button Group Controlled

```tsx
import { ToggleButton, ToggleButtonGroup } from '@zillow/constellation';
```

```tsx
export const ToggleButtonGroupControlled = () => {
  const [state, setState] = useState<string | Array<string>>('second');
  return (
    <ToggleButtonGroup
      aria-label="Controlled ToggleButtonGroup"
      value={state}
      onValueChange={(value) => setState(value)}
      conjoined
    >
      <ToggleButton value="first">First</ToggleButton>
      <ToggleButton value="second">Second</ToggleButton>
      <ToggleButton value="third">Third</ToggleButton>
      <ToggleButton value="last">Last</ToggleButton>
    </ToggleButtonGroup>
  );
};
```

### Toggle Button Group Disabled

```tsx
import { ToggleButton, ToggleButtonGroup } from '@zillow/constellation';
```

```tsx
export const ToggleButtonGroupDisabled = () => (
  <ToggleButtonGroup aria-label="Storybook Example" defaultValue="first" size="md" disabled>
    <ToggleButton value="first">First</ToggleButton>
    <ToggleButton value="second">Second</ToggleButton>
    <ToggleButton value="third">Third</ToggleButton>
    <ToggleButton value="last">Last</ToggleButton>
  </ToggleButtonGroup>
);
```

### Toggle Button Group Multi Select Controlled

```tsx
import { ToggleButton, ToggleButtonGroup } from '@zillow/constellation';
```

```tsx
export const ToggleButtonGroupMultiSelectControlled = () => {
  const [state, setState] = useState<string | Array<string>>(['second', 'last']);
  return (
    <ToggleButtonGroup
      aria-label="Controlled ToggleButtonGroup"
      value={state}
      onValueChange={(value) => setState(value)}
      conjoined
    >
      <ToggleButton value="first">First</ToggleButton>
      <ToggleButton value="second">Second</ToggleButton>
      <ToggleButton value="third">Third</ToggleButton>
      <ToggleButton value="last">Last</ToggleButton>
    </ToggleButtonGroup>
  );
};
```

### Toggle Button Group Multi Select

```tsx
import { ToggleButton, ToggleButtonGroup } from '@zillow/constellation';
```

```tsx
export const ToggleButtonGroupMultiSelect = () => (
  <ToggleButtonGroup aria-label="Controlled ToggleButtonGroup" defaultValue={[]} conjoined>
    <ToggleButton value="first">First</ToggleButton>
    <ToggleButton value="second">Second</ToggleButton>
    <ToggleButton value="third">Third</ToggleButton>
    <ToggleButton value="last">Last</ToggleButton>
  </ToggleButtonGroup>
);
```

### Toggle Button Group Not Conjoined

```tsx
import { ToggleButton, ToggleButtonGroup } from '@zillow/constellation';
```

```tsx
export const ToggleButtonGroupNotConjoined = () => (
  <ToggleButtonGroup aria-label="Storybook Example" conjoined={false}>
    <ToggleButton value="first">First</ToggleButton>
    <ToggleButton value="second">Second</ToggleButton>
    <ToggleButton value="third">Third</ToggleButton>
    <ToggleButton value="last">Last</ToggleButton>
  </ToggleButtonGroup>
);
```

### Toggle Button Group Size

```tsx
import { ToggleButton, ToggleButtonGroup } from '@zillow/constellation';
```

```tsx
export const ToggleButtonGroupSize = () => (
  <ToggleButtonGroup aria-label="Storybook Example" defaultValue="first" size="md">
    <ToggleButton value="first">First</ToggleButton>
    <ToggleButton value="second">Second</ToggleButton>
    <ToggleButton value="third">Third</ToggleButton>
    <ToggleButton value="last">Last</ToggleButton>
  </ToggleButtonGroup>
);
```

### Toggle Button Group With Default Value

```tsx
import { ToggleButton, ToggleButtonGroup } from '@zillow/constellation';
```

```tsx
export const ToggleButtonGroupWithDefaultValue = () => (
  <ToggleButtonGroup aria-label="Storybook Example" defaultValue="first">
    <ToggleButton value="first">First</ToggleButton>
    <ToggleButton value="second">Second</ToggleButton>
    <ToggleButton value="third">Third</ToggleButton>
    <ToggleButton value="last">Last</ToggleButton>
  </ToggleButtonGroup>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-label'` | `AriaAttributes['aria-label']` | — | An [aria-label](https://www.w3.org/TR/wai-aria-1.2/#aria-label) is required for assistive technologies to announce the button group properly. **(required)** |
| `'asChild'` | `boolean` | — | Use child as the root element |
| `'children'` | `ReactNode` | — | Content **(required)** |
| `'conjoined'` | `boolean` | `true` | Connect the buttons by removing the space between buttons in the group. In general, you will only want to do this with buttons of the same type. You can use `buttonType` to set the type to be the same for all buttons. |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'role'` | `AriaRole` | `group` | Sets the `role` of the button group. By default, this is set to ["group"](https://www.w3.org/TR/wai-aria-1.2/#group), but "toolbar" might be more appropriate if the button group is used in a toolbar. |
| `'disabled'` | `boolean` | `false` | Set the buttons as disabled. |
| `'size'` | `'sm' \| 'md' \| 'lg'` | `sm` | Set the same button size on all children. |
| `'defaultValue'` | `string \| Array<string>` | — | Set the toggle button group value, and use as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). A toggle button group can set `value` or `defaultValue`, but not both. |
| `'onValueChange'` | `(value: string \| Array<string>) => void` | — | Callback for change events within the toggle button group. The callback will receive the `value` of the currently selected `ToggleButton`, or `undefined` if all buttons are unpressed. |
| `'value'` | `string \| Array<string>` | — | Set the toggle button group value, and use as an [controlled component](https://reactjs.org/docs/forms.html#controlled-components). A toggle button group can set `value` or `defaultValue`, but not both. |

