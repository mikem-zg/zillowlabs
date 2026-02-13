# Banner

```tsx
import { Banner } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.13.0

## Usage

```tsx
import { Banner } from '@zillow/constellation';
```

```tsx
export const BannerBasic = () => <Banner>Lorem ipsum dolor sit amet, consectetur.</Banner>;
```

## Examples

### Banner Composed

```tsx
import { Anchor, Banner, CloseButton } from '@zillow/constellation';
```

```tsx
export const BannerComposed = () => (
  // oxlint-disable-next-line no-console
  <Banner.Root onClose={() => console.log('composed clicked')}>
    <Banner.Body>
      Lorem <Anchor onImpact>ipsum dolor</Anchor> sit amet, consectetur.
    </Banner.Body>
    <Banner.Close asChild>
      <CloseButton onImpact />
    </Banner.Close>
  </Banner.Root>
);
```

### Banner Controlled

```tsx
import { Banner, TextButton } from '@zillow/constellation';
```

```tsx
export const BannerControlled = () => {
  const [open, setOpen] = useState(true);

  const handleClose = () => {
    setOpen(false);
    setTimeout(() => {
      setOpen(true);
    }, 1000);
  };

  return (
    <Banner
      actionButton={
        <TextButton onImpact onClick={handleClose}>
          Retry
        </TextButton>
      }
      isOpen={open}
    >
      Lorem ipsum dolor sit amet, consectetur.
    </Banner>
  );
};
```

### Banner Tones

```tsx
import { Banner, Box } from '@zillow/constellation';
```

```tsx
export const BannerTones = () => (
  <Box css={{ display: 'flex', gap: 'layout.default', flexDirection: 'column' }}>
    <Banner tone="info">Lorem ipsum dolor sit amet, consectetur.</Banner>
    <Banner tone="success">Lorem ipsum dolor sit amet, consectetur.</Banner>
    <Banner tone="critical">Lorem ipsum dolor sit amet, consectetur.</Banner>
    <Banner tone="warning">Lorem ipsum dolor sit amet, consectetur.</Banner>
  </Box>
);
```

### Banner With Action Button

```tsx
import { Banner, TextButton } from '@zillow/constellation';
```

```tsx
export const BannerWithActionButton = () => (
  <Banner actionButton={<TextButton onImpact>Action</TextButton>}>
    Lorem ipsum dolor sit amet, consectetur.
  </Banner>
);
```

### Banner With Close Button

```tsx
import { Banner, CloseButton } from '@zillow/constellation';
```

```tsx
export const BannerWithCloseButton = () => (
  <Banner closeButton={<CloseButton onImpact />}>Lorem ipsum dolor sit amet, consectetur.</Banner>
);
```

### Banner With Custom On Close

```tsx
import { Banner, CloseButton } from '@zillow/constellation';
```

```tsx
export const BannerWithCustomOnClose = () => (
  <Banner
    closeButton={<CloseButton onImpact />}
    // oxlint-disable-next-line no-console
    onClose={() => console.log('with custom close event')}
  >
    Lorem ipsum dolor sit amet, consectetur.
  </Banner>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `Extract<StatusType, 'critical' \| 'info' \| 'success' \| 'warning'>` | `info` | The type of the banner to display. |
| `children` | `ReactNode` | — | The body content of the banner message. |
| `css` | `SystemStyleObject` | — | Styles object |
| `isOpen` | `boolean` | — | A Banner is uncontrolled by default. You can specify `isOpen` to manually control the visibility of the component. |
| `onClose` | `() => void` | — | Function called with the `closeButton` is clicked. |
| `role` | `'alert' \| 'status'` | `'status'` | Banners should have a role of status or alert to signal assistive technologies that it requires the user's attention.  In general, you will always want to use the less strict "status" role. |
| `actionButton` | `ReactNode` | — | An optional action button. |
| `closeButton` | `ReactNode` | `null` | The close button node. You can set this to `<CloseButton />` if needed. NOTE: Don’t make a banner dismissible if there’s an action presented to the user that can help resolve the banner. |

### BannerAction

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### BannerBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### BannerClose

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### BannerIcon

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `never` | — | We do not want folks overriding the icon. |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusable` | `ComponentProps<'svg'>['focusable']` | `false` | The SVG [`focusable`](https://www.w3.org/TR/SVGTiny12/interact.html#focusable-attr) attribute. |
| `role` | `AriaRole` | `img` | The role is set to "img" by default to exclude all child content from the accessibility tree. |
| `size` | `ResponsiveVariant<'sm' \| 'md' \| 'lg' \| 'xl'>` | — | By default, icons are sized to `1em` to match the size of the text content. For fixed-width sizes, you can use the `size` prop. |
| `render` | `ReactNode` | — | Alternative to children. |
| `title` | `string` | — | Creates an accessible label for the icon for contextually meaninful icons, and sets the appropriate `aria` attributes. Icons are hidden from screen readers by default without this prop.  Note: specifying `aria-labelledby`, `aria-hidden`, or `children` manually while using this prop may produce accessibility errors. This prop is only available on prebuilt icons within Constellation. |

### BannerRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `Extract<StatusType, 'critical' \| 'info' \| 'success' \| 'warning'>` | `info` | The type of the banner to display. |
| `children` | `ReactNode` | — | Content for when you want to compose vs render props |
| `css` | `SystemStyleObject` | — | Styles object |
| `isOpen` | `boolean` | — | A Banner is uncontrolled by default. You can specify `isOpen` to manually control the visibility of the component. |
| `onClose` | `() => void` | — | Function called with the `closeButton` is clicked. |
| `role` | `'alert' \| 'status'` | `'status'` | Banners should have a role of status or alert to signal assistive technologies that it requires the user's attention. In general, you will always want to use the less strict "status" role. |

