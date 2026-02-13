# Icon

```tsx
import { Icon } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.4.0

## Usage

```tsx
import { Icon } from '@zillow/constellation';
```

```tsx
export const IconBasic = () => (
  <Icon role="img">
    <IconSearchFilled />
  </Icon>
);
```

## Examples

### Icon Custom Color

```tsx
import { Icon } from '@zillow/constellation';
```

```tsx
export const IconCustomColor = () => (
  <Icon role="img" title="Custom Title" css={{ color: 'text.action.critical.hero.default' }}>
    <IconSearchFilled />
  </Icon>
);
```

### Icon Responsive Size

```tsx
import { Icon } from '@zillow/constellation';
```

```tsx
export const IconResponsiveSize = () => (
  <Icon role="img" title="Custom Title" size={{ base: 'sm', md: 'md', lg: 'lg', xl: 'xl' }}>
    <IconSearchFilled />
  </Icon>
);
```

### Icon With Heading

```tsx
import { Heading, Icon } from '@zillow/constellation';
```

```tsx
export const IconWithHeading = () => (
  <Heading level={4}>
    <Icon role="img" title="Custom Title">
      <IconSearchFilled />
    </Icon>{' '}
    Request A Tour
  </Heading>
);
```

### Icon With Render

```tsx
import { Icon } from '@zillow/constellation';
```

```tsx
export const IconWithRender = () => (
  <Icon role="img" render={<IconSearchFilled />} title="Custom Title" />
);
```

### Icon With Title

```tsx
import { Icon } from '@zillow/constellation';
```

```tsx
export const IconWithTitle = () => (
  <Icon role="img" title="Custom Title">
    <IconSearchFilled />
  </Icon>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The SVG icon to render. |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusable` | `ComponentProps<'svg'>['focusable']` | `false` | The SVG [`focusable`](https://www.w3.org/TR/SVGTiny12/interact.html#focusable-attr) attribute. |
| `role` | `AriaRole` | `img` | The role is set to "img" by default to exclude all child content from the accessibility tree. |
| `size` | `ResponsiveVariant<'sm' \| 'md' \| 'lg' \| 'xl'>` | — | By default, icons are sized to `1em` to match the size of the text content. For fixed-width sizes, you can use the `size` prop. |
| `render` | `ReactNode` | — | Alternative to children. |
| `title` | `string` | — | Creates an accessible label for the icon for contextually meaninful icons, and sets the appropriate `aria` attributes. Icons are hidden from screen readers by default without this prop. Note: specifying `aria-labelledby`, `aria-hidden`, or `children` manually while using this prop may produce accessibility errors. This prop is only available on prebuilt icons within Constellation. |

