# Upsell

```tsx
import { Upsell } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.8.0

## Usage

```tsx
import { Heading, Icon, Paragraph, TextButton, Upsell } from '@zillow/constellation';
```

```tsx
export const UpsellBasic = () => (
  <Upsell
    tone="neutral"
    elevated
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Love this home?</Heading>}
    body={<Paragraph>Sell your current home to Zillow, and close on your schedule.</Paragraph>}
    action={<TextButton>Explore Zillow Offers</TextButton>}
  />
);
```

## Examples

### Upsell Composed

```tsx
import { Heading, Icon, Paragraph, Text, TextButton, Upsell } from '@zillow/constellation';
```

```tsx
export const UpsellComposed = () => (
  <Upsell.Root tone="neutral" elevated>
    <Upsell.Media>
      <Icon render={<IconYardSignFilled />} />
    </Upsell.Media>
    <Upsell.Content>
      <Upsell.Header>
        <Heading level={4}>Love this home?</Heading>
      </Upsell.Header>
      <Upsell.Body>
        <Paragraph>Sell your current home to Zillow, and close on your schedule.</Paragraph>
      </Upsell.Body>
      <Upsell.Action>
        <TextButton>Explore Zillow Offers</TextButton>
      </Upsell.Action>
      <Upsell.Legal>
        <Text>Optional legal or fineprint copy</Text>
      </Upsell.Legal>
    </Upsell.Content>
    <Upsell.CloseButton />
  </Upsell.Root>
);
```

### Upsell Controlled

```tsx
import { Heading, Icon, Paragraph, TextButton, Upsell } from '@zillow/constellation';
```

```tsx
export const UpsellControlled = () => {
  const [open, setOpen] = useState(true);
  const handler = useCallback((state: boolean) => {
    setOpen(state);
  }, []);
  return (
    <Upsell
      open={open}
      onOpenChange={handler}
      tone="neutral"
      elevated
      media={<Icon render={<IconYardSignFilled />} />}
      header={<Heading level={4}>Love this home?</Heading>}
      body={<Paragraph>Sell your current home to Zillow, and close on your schedule.</Paragraph>}
      action={<TextButton>Explore Zillow Offers</TextButton>}
    />
  );
};
```

### Upsell Hero

```tsx
import { Heading, Icon, Paragraph, TextButton, Upsell } from '@zillow/constellation';
```

```tsx
export const UpsellHero = () => (
  <Upsell
    tone="hero"
    elevated
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Love this home?</Heading>}
    body={<Paragraph>Sell your current home to Zillow, and close on your schedule.</Paragraph>}
    action={<TextButton>Explore Zillow Offers</TextButton>}
  />
);
```

### Upsell Impact

```tsx
import { Heading, Icon, Paragraph, TextButton, Upsell } from '@zillow/constellation';
```

```tsx
export const UpsellImpact = () => (
  <Upsell
    tone="impact"
    elevated
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Love this home?</Heading>}
    body={<Paragraph>Sell your current home to Zillow, and close on your schedule.</Paragraph>}
    action={<TextButton>Explore Zillow Offers</TextButton>}
  />
);
```

### Upsell Legal Or Fine Print

```tsx
import { Heading, Icon, Paragraph, Text, TextButton, Upsell } from '@zillow/constellation';
```

```tsx
export const UpsellLegalOrFinePrint = () => (
  <Upsell
    tone="impact"
    elevated
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Love this home?</Heading>}
    body={<Paragraph>Sell your current home to Zillow, and close on your schedule.</Paragraph>}
    action={<TextButton>Explore Zillow Offers</TextButton>}
    legal={<Text>Optional legal or fine print copy</Text>}
  />
);
```

### Upsell Soft

```tsx
import { Heading, Icon, Paragraph, TextButton, Upsell } from '@zillow/constellation';
```

```tsx
export const UpsellSoft = () => (
  <Upsell
    tone="soft"
    elevated
    media={<Icon render={<IconYardSignFilled />} />}
    header={<Heading level={4}>Love this home?</Heading>}
    body={<Paragraph>Sell your current home to Zillow, and close on your schedule.</Paragraph>}
    action={<TextButton>Explore Zillow Offers</TextButton>}
  />
);
```

### Upsell With Illustration

```tsx
import { Heading, Image, Paragraph, TextButton, Upsell } from '@zillow/constellation';
```

```tsx
export const UpsellWithIllustration = () => (
  <Upsell
    elevated
    media={
      <Image
        src="https://delivery.digitallibrary.zillowgroup.com/public/sell-home-light_svg_Original.svg"
        alt="demo illustration"
      />
    }
    header={<Heading level={4}>Love this home?</Heading>}
    body={<Paragraph>Sell your current home to Zillow, and close on your schedule.</Paragraph>}
    action={<TextButton>Explore Zillow Offers</TextButton>}
    css={{ flexDirection: 'column' }}
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `elevated` | `boolean` | `true` | Adds shadow to the card |
| `open` | `boolean` | — | A closeable Upsell is uncontrolled by default. You can specify `open` to manually control the visibility of the component. |
| `onOpenChange` | `(state: boolean, event: MouseEvent<HTMLButtonElement>) => void` | — | Function called when the Upsell is closed. |
| `tone` | `'neutral' \| 'soft' \| 'hero' \| 'impact'` | `neutral` | Customize the tone of the Upsell. |
| `body` | `ReactNode` | — | Body content **(required)** |
| `closeable` | `boolean` | — | Allow to close Upsell via CloseButton |
| `action` | `ReactNode` | — | Action content **(required)** |
| `header` | `ReactNode` | — | Header content **(required)** |
| `legal` | `ReactNode` | — | Legal content |
| `media` | `ReactNode` | — | Media content **(required)** |

### UpsellAction

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellCloseButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellLegal

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellMedia

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### UpsellRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `elevated` | `boolean` | `true` | Adds shadow to the card |
| `open` | `boolean` | — | A closeable Upsell is uncontrolled by default. You can specify `open` to manually control the visibility of the component. |
| `onOpenChange` | `(state: boolean, event: MouseEvent<HTMLButtonElement>) => void` | — | Function called when the Upsell is closed. |
| `tone` | `'neutral' \| 'soft' \| 'hero' \| 'impact'` | `neutral` | Customize the tone of the Upsell. |

