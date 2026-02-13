# UpsellBanner

```tsx
import { UpsellBanner } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.29.0

## Usage

```tsx
import { Heading, Icon, Paragraph, TextButton, UpsellBanner } from '@zillow/constellation';
```

```tsx
export const UpsellBannerBasic = () => (
  <UpsellBanner
    tone="soft"
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Upsell heading.</Heading>}
    body={<Paragraph>Upsell banner body message.</Paragraph>}
    action={<TextButton>Action button</TextButton>}
  />
);
```

## Examples

### Upsell Banner Composed

```tsx
import { Heading, Icon, Paragraph, TextButton, UpsellBanner } from '@zillow/constellation';
```

```tsx
export const UpsellBannerComposed = () => (
  <UpsellBanner.Root tone="soft">
    <UpsellBanner.Media>
      <Icon render={<IconYardSignFilled />} />
    </UpsellBanner.Media>
    <UpsellBanner.Content>
      <UpsellBanner.Header>
        <Heading level={4}>Upsell heading.</Heading>
      </UpsellBanner.Header>
      <UpsellBanner.Body>
        <Paragraph>Upsell banner body message.</Paragraph>
      </UpsellBanner.Body>
    </UpsellBanner.Content>
    <UpsellBanner.Action>
      <TextButton>Action button</TextButton>
    </UpsellBanner.Action>
    <UpsellBanner.CloseButton />
  </UpsellBanner.Root>
);
```

### Upsell Banner Controlled

```tsx
import { Heading, Icon, Paragraph, TextButton, UpsellBanner } from '@zillow/constellation';
```

```tsx
export const UpsellBannerControlled = () => {
  const [open, setOpen] = useState(true);
  const handler = useCallback((state: boolean) => {
    setOpen(state);
  }, []);
  return (
    <UpsellBanner
      open={open}
      onOpenChange={handler}
      tone="soft"
      media={<Icon render={<IconYardSignFilled />} />}
      header={<Heading level={4}>Upsell heading.</Heading>}
      body={<Paragraph>Upsell banner body message.</Paragraph>}
      action={<TextButton>Action button</TextButton>}
    />
  );
};
```

### Upsell Banner Hero

```tsx
import { Heading, Icon, Paragraph, TextButton, UpsellBanner } from '@zillow/constellation';
```

```tsx
export const UpsellBannerHero = () => (
  <UpsellBanner
    tone="hero"
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Upsell heading.</Heading>}
    body={<Paragraph>Upsell banner body message.</Paragraph>}
    action={<TextButton>Action button</TextButton>}
  />
);
```

### Upsell Banner Impact

```tsx
import { Heading, Icon, Paragraph, TextButton, UpsellBanner } from '@zillow/constellation';
```

```tsx
export const UpsellBannerImpact = () => (
  <UpsellBanner
    tone="impact"
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Upsell heading.</Heading>}
    body={<Paragraph>Upsell banner body message.</Paragraph>}
    action={<TextButton>Action button</TextButton>}
  />
);
```

### Upsell Banner Neutral

```tsx
import { Heading, Icon, Paragraph, TextButton, UpsellBanner } from '@zillow/constellation';
```

```tsx
export const UpsellBannerNeutral = () => (
  <UpsellBanner
    tone="neutral"
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Upsell heading.</Heading>}
    body={<Paragraph>Upsell banner body message.</Paragraph>}
    action={<TextButton>Action button</TextButton>}
  />
);
```

### Upsell Banner Responsive Behavior

```tsx
import { Heading, Icon, Paragraph, TextButton, UpsellBanner } from '@zillow/constellation';
```

```tsx
export const UpsellBannerResponsiveBehavior = () => (
  <UpsellBanner
    tone="soft"
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Upsell heading text.</Heading>}
    body={
      <Paragraph>
        Upsell banner body message. Upsell banner body message. Upsell banner body message.
      </Paragraph>
    }
    action={<TextButton>Action button</TextButton>}
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `open` | `boolean` | — | A closeable UpsellBanner is uncontrolled by default. You can specify `open` to manually control the visibility of the component. |
| `onOpenChange` | `(state: boolean, event: MouseEvent<HTMLButtonElement>) => void` | — | Function called when the UpsellBanner is closed. |
| `tone` | `'neutral' \| 'soft' \| 'hero' \| 'impact'` | `soft` | Customize the tone of the UpsellBanner. |
| `body` | `ReactNode` | — | Body content **(required)** |
| `closeButton` | `ReactNode` | — | Close button |
| `action` | `ReactNode` | — | Action content **(required)** |
| `header` | `ReactNode` | — | Header content **(required)** |
| `media` | `ReactNode` | — | Media content **(required)** |

### UpsellBannerAction

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellBannerBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellBannerCloseButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellBannerContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellBannerHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellBannerMedia

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellBannerRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `open` | `boolean` | — | A closeable UpsellBanner is uncontrolled by default. You can specify `open` to manually control the visibility of the component. |
| `onOpenChange` | `(state: boolean, event: MouseEvent<HTMLButtonElement>) => void` | — | Function called when the UpsellBanner is closed. |
| `tone` | `'neutral' \| 'soft' \| 'hero' \| 'impact'` | `soft` | Customize the tone of the UpsellBanner. |

