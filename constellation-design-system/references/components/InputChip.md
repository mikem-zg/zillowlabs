# InputChip

```tsx
import { InputChip } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.97.0

## Usage

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipBasic = () => <InputChip defaultOpen>Air conditioning</InputChip>;
```

## Examples

### Input Chip Close Button Voice Over

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipCloseButtonVoiceOver = () => (
  <InputChip defaultOpen closeButtonVoiceOver="Remove air conditioning from search">
    Air conditioning
  </InputChip>
);
```

### Input Chip Composed Controlled

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipComposedControlled = () => {
  const [isOpen, setIsOpen] = useState(true);

  const onCloseCallback = useCallback(() => {
    setIsOpen(false);
    setTimeout(() => {
      setIsOpen(true);
    }, 1000);
  }, [setIsOpen]);

  return (
    <InputChip.Root isOpen={isOpen} onClose={onCloseCallback}>
      <InputChip.Label>Lorem ipsum</InputChip.Label>
      <InputChip.Close />
    </InputChip.Root>
  );
};
```

### Input Chip Composed With Icon

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipComposedWithIcon = () => (
  <InputChip.Root>
    <InputChip.Icon>
      <IconAirConditioningFilled />
    </InputChip.Icon>
    <InputChip.Label>Air conditioning</InputChip.Label>
    <InputChip.Close />
  </InputChip.Root>
);
```

### Input Chip Composed With Image Avatar

```tsx
import { Avatar, InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipComposedWithImageAvatar = () => (
  <InputChip.Root>
    <InputChip.Avatar>
      <Avatar
        alt="Rich Barton"
        src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
      />
    </InputChip.Avatar>
    <InputChip.Label>Lorem ipsum</InputChip.Label>
    <InputChip.Close />
  </InputChip.Root>
);
```

### Input Chip Controlled

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipControlled = () => {
  const [isOpen, setIsOpen] = useState(true);

  const onCloseCallback = useCallback(() => {
    setIsOpen(false);
    setTimeout(() => {
      setIsOpen(true);
    }, 1000);
  }, [setIsOpen]);

  return (
    <InputChip isOpen={isOpen} onClose={onCloseCallback}>
      Lorem ipsum
    </InputChip>
  );
};
```

### Input Chip Disabled

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipDisabled = () => (
  <InputChip defaultOpen disabled>
    Air conditioning
  </InputChip>
);
```

### Input Chip Text Truncation Off

```tsx
import { Box, InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipTextTruncationOff = () => (
  <Box
    css={{
      display: 'flex',
      flexDirection: 'column',
      gap: 'xs',
      maxWidth: '200px',
      border: '1px dashed red',
      padding: 'xs',
    }}
  >
    <InputChip icon={<IconAirConditioningFilled />}>Chip with truncation turned on</InputChip>
    <InputChip icon={<IconAirConditioningFilled />} truncate={false}>
      Chip with truncation turned off
    </InputChip>
    <InputChip.Root>
      <InputChip.Icon>
        <IconAirConditioningFilled />
      </InputChip.Icon>
      <InputChip.Label truncate={false}>Composed Chip with truncation turned off</InputChip.Label>
      <InputChip.Close />
    </InputChip.Root>
  </Box>
);
```

### Input Chip Uncontrolled

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipUncontrolled = () => <InputChip defaultOpen>Air conditioning</InputChip>;
```

### Input Chip With Elevation

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipWithElevation = () => (
  <InputChip defaultOpen elevated>
    Air conditioning
  </InputChip>
);
```

### Input Chip With Icon Avatar

```tsx
import { Avatar, InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipWithIconAvatar = () => (
  <InputChip defaultOpen avatar={<Avatar aria-label="User avatar" />}>
    Air conditioning
  </InputChip>
);
```

### Input Chip With Icon

```tsx
import { InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipWithIcon = () => (
  <InputChip defaultOpen icon={<IconAirConditioningFilled />}>
    Air conditioning
  </InputChip>
);
```

### Input Chip With Image Avatar

```tsx
import { Avatar, InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipWithImageAvatar = () => (
  <InputChip
    defaultOpen
    avatar={
      <Avatar
        alt="Rich Barton"
        src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
      />
    }
  >
    Air conditioning
  </InputChip>
);
```

### Input Chip With Initial Avatar

```tsx
import { Avatar, InputChip } from '@zillow/constellation';
```

```tsx
export const InputChipWithInitialAvatar = () => (
  <InputChip defaultOpen avatar={<Avatar fullName="Rich Barton" />}>
    Air conditioning
  </InputChip>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `elevated` | `boolean` | — | When true, adds a drop shadow. Useful for making the input chip easier to see on certain backgrounds (ex: on top of a photo or map) |
| `css` | `SystemStyleObject` | — | Styles object |
| `defaultOpen` | `boolean` | — | When enabled, the input chip will close in an uncontrolled manner. |
| `disabled` | `boolean` | — | Sets the input chip as disabled. |
| `isOpen` | `boolean` | — | When enabled, the input chip will close in a controlled manner. |
| `onClose` | `() => void` | — | Function called when the chip is closed. The chip’s props will be passed as the only argument. |
| `truncate` | `boolean` | — | When true, label text truncates to one line with ellipsis. |
| `avatar` | `ReactNode` | — | Adds a leading avatar. Takes an `Avatar` component. Ignores `Avatar`’s `size` prop (i.e. the avatar size is fixed). |
| `children` | `string` | — | The input chip’s text label. **(required)** |
| `icon` | `ReactNode` | — | Adds a leading icon. Takes an `Icon` component but ignores its `size` prop (i.e. the icon size is fixed). |
| `closeButtonVoiceOver` | `string` | — | The text that will be announced to screen readers when you focus on the chip's close button. Used as the close button's `title` value. Defaults to "Remove {chip label}" |

### InputChipAvatar

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Requires an `Avatar` component. Ignores `Avatar`’s `size` prop (i.e. the avatar size is fixed). **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### InputChipClose

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `(         <CloseButton>           <Icon>             <IconCloseCircleFilled />           </Icon>         </CloseButton>       )` | The content of the close button container. Defaults to a `CloseButton` component with an `IconCloseCircleFilled`. |
| `css` | `SystemStyleObject` | — | Styles object |
| `title` | `string` | — | Used to tell screenreaders what to speak for this button. This will leverage the VisuallyHidden component to allow a consistent experience and solve a NVDA bug. Defaults to "Remove {chip label}". |

### InputChipIcon

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

### InputChipLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `string` | — | The input chip’s text label. Must be a string. **(required)** |
| `color` | `never` | — |  |
| `css` | `SystemStyleObject` | — | Styles object |
| `truncate` | `boolean` | `true` | When true, label text truncates to one line with ellipsis. |

### InputChipRoot

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The input chip’s text label. To add decorators, use the `icon` and `avatar` props. **(required)** |
| `elevated` | `boolean` | `false` | When true, adds a drop shadow. Useful for making the input chip easier to see on certain backgrounds (ex: on top of a photo or map) |
| `css` | `SystemStyleObject` | — | Styles object |
| `defaultOpen` | `boolean` | — | When enabled, the input chip will close in an uncontrolled manner. |
| `disabled` | `boolean` | `false` | Sets the input chip as disabled. |
| `isOpen` | `boolean` | — | When enabled, the input chip will close in a controlled manner. |
| `onClose` | `() => void` | — | Function called when the chip is closed. The chip’s props will be passed as the only argument. |
| `truncate` | `boolean` | — | When true, label text truncates to one line with ellipsis. |

