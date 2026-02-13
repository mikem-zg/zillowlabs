# AssistChip

```tsx
import { AssistChip } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.97.0

## Usage

```tsx
import { AssistChip } from '@zillow/constellation';
```

```tsx
export const AssistChipBasic = () => <AssistChip>Content</AssistChip>;
```

## Examples

### Assist Chip Composed With Icon

```tsx
import { AssistChip } from '@zillow/constellation';
```

```tsx
export const AssistChipComposedWithIcon = () => (
  <AssistChip.Root>
    <AssistChip.Icon>
      <IconCalendarFilled />
    </AssistChip.Icon>
    <AssistChip.Label>Add to itinerary</AssistChip.Label>
  </AssistChip.Root>
);
```

### Assist Chip Composed With Image Avatar

```tsx
import { AssistChip, Avatar } from '@zillow/constellation';
```

```tsx
export const AssistChipComposedWithImageAvatar = () => (
  <AssistChip.Root>
    <AssistChip.Avatar>
      <Avatar
        alt="Rich Barton"
        src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
      />
    </AssistChip.Avatar>
    <AssistChip.Label>Email Rich</AssistChip.Label>
  </AssistChip.Root>
);
```

### Assist Chip Text Truncation Off

```tsx
import { AssistChip, Box } from '@zillow/constellation';
```

```tsx
export const AssistChipTextTruncationOff = () => (
  <Box
    css={{
      border: '1px dashed red',
      display: 'flex',
      flexDirection: 'column',
      gap: 'xs',
      maxWidth: '200px',
      padding: 'xs',
    }}
  >
    <AssistChip icon={<IconCalendarFilled />}>Chip with truncation turned on</AssistChip>
    <AssistChip icon={<IconCalendarFilled />} truncate={false}>
      Chip with truncation turned off
    </AssistChip>
    <AssistChip.Root>
      <AssistChip.Icon>
        <IconCalendarFilled />
      </AssistChip.Icon>
      <AssistChip.Label truncate={false}>Composed Chip with truncation turned off</AssistChip.Label>
    </AssistChip.Root>
  </Box>
);
```

### Assist Chip With Elevated

```tsx
import { AssistChip } from '@zillow/constellation';
```

```tsx
export const AssistChipWithElevated = () => <AssistChip elevated>Content</AssistChip>;
```

### Assist Chip With Icon Avatar

```tsx
import { AssistChip, Avatar } from '@zillow/constellation';
```

```tsx
export const AssistChipWithIconAvatar = () => (
  <AssistChip avatar={<Avatar aria-label="User avatar" />}>Content</AssistChip>
);
```

### Assist Chip With Icon

```tsx
import { AssistChip } from '@zillow/constellation';
```

```tsx
export const AssistChipWithIcon = () => (
  <AssistChip icon={<IconCalendarFilled />}>Content</AssistChip>
);
```

### Assist Chip With Image Avatar

```tsx
import { AssistChip, Avatar } from '@zillow/constellation';
```

```tsx
export const AssistChipWithImageAvatar = () => (
  <AssistChip
    avatar={
      <Avatar
        alt="Rich Barton"
        src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
      />
    }
  >
    Content
  </AssistChip>
);
```

### Assist Chip With Initials Avatar

```tsx
import { AssistChip, Avatar } from '@zillow/constellation';
```

```tsx
export const AssistChipWithInitialsAvatar = () => (
  <AssistChip avatar={<Avatar fullName="Rich Barton" />}>Content</AssistChip>
);
```

### Assist Chip With Loading Icon

```tsx
import { AssistChip } from '@zillow/constellation';
```

```tsx
export const AssistChipWithLoadingIcon = () => (
  <AssistChip icon={<IconCalendarFilled />} loading>
    Content
  </AssistChip>
);
```

### Assist Chip With Loading Image Avatar

```tsx
import { AssistChip, Avatar } from '@zillow/constellation';
```

```tsx
export const AssistChipWithLoadingImageAvatar = () => (
  <AssistChip
    avatar={
      <Avatar
        alt="Rich Barton"
        src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
      />
    }
    loading
  >
    Content
  </AssistChip>
);
```

### Assist Chip With Loading

```tsx
import { AssistChip } from '@zillow/constellation';
```

```tsx
export const AssistChipWithLoading = () => <AssistChip loading>Content</AssistChip>;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `elevated` | `boolean` | `false` | When true, adds a drop shadow. Useful for making the assist chip easier to see on certain backgrounds (ex: on top of a photo or map) |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets the assist chip as disabled. |
| `loading` | `boolean` | `false` | Add a loading spinner to the chip. |
| `loadingVoiceOver` | `string` | `'Loading'` | The text that will be announced to screen readers when the chip changes to its loading state. Defaults to "loading". Text is `VisuallyHidden`.  Don't include the chip's label text in `loadingVoiceOver` because some assistive technologies will, by default, read the label text after the `loadingVoiceOver` text. |
| `children` | `string` | — | The assist chip’s text label. **(required)** |
| `avatar` | `ReactNode` | — | Adds a leading avatar. Takes an `Avatar` component. Ignores `Avatar`’s `size` prop (i.e. the avatar size is fixed). |
| `icon` | `ReactNode` | — | Adds a leading icon. Takes an `Icon` component but ignores its `size` prop (i.e. the icon size is fixed). |
| `truncate` | `boolean` | — | When true, label text truncates to one line with ellipsis. |

### AssistChipAvatar

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Requires an `Avatar` component. Ignores `Avatar`’s `size` prop (i.e. the avatar size is fixed). **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### AssistChipIcon

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

### AssistChipLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `string` | — | The assist chip’s text label. Must be a string. **(required)** |
| `color` | `never` | — |  |
| `css` | `SystemStyleObject` | — | Styles object |
| `truncate` | `boolean` | `true` | When true, label text truncates to one line with ellipsis. |

### AssistChipLoading

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Requires an `Spinner` component. Ignores `Spinner`’s `size` prop (i.e. the avatar size is fixed). |
| `css` | `SystemStyleObject` | — | Styles object |

### AssistChipRoot

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The assist chip’s text label. To add decorators, use the `icon` and `avatar` props. **(required)** |
| `elevated` | `boolean` | `false` | When true, adds a drop shadow. Useful for making the assist chip easier to see on certain backgrounds (ex: on top of a photo or map) |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets the assist chip as disabled. |
| `loading` | `boolean` | `false` | Add a loading spinner to the chip. |
| `loadingVoiceOver` | `string` | `'Loading'` | The text that will be announced to screen readers when the chip changes to its loading state. Defaults to "loading". Text is `VisuallyHidden`. Don't include the chip's label text in `loadingVoiceOver` because some assistive technologies will, by default, read the label text after the `loadingVoiceOver` text. |

