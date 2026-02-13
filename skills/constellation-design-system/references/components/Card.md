# Card

```tsx
import { Card } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 4.1.0

## Usage

```tsx
import { Card, Paragraph } from '@zillow/constellation';
```

```tsx
export const CardBasic = () => (
  <Card>
    <Paragraph>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
      efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
    </Paragraph>
  </Card>
);
```

## Examples

### Card Block Anchor Composable

```tsx
import { Card, Heading, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const CardBlockAnchorComposable = () => (
  <Card.Root interactive>
    <Card.BlockAnchor href="https://www.zillow.com" />
    <Card.Content>
      <Card.Header>
        <Heading level={5}>Card heading</Heading>
      </Card.Header>
      <Card.Body>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      </Card.Body>
      <Card.Footer>
        <TextButton asChild>
          <a href="https://www.zillow.com">Card action</a>
        </TextButton>
      </Card.Footer>
    </Card.Content>
  </Card.Root>
);
```

### Card Block Anchor Shorthand

```tsx
import { Card, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const CardBlockAnchorShorthand = () => (
  <Card
    interactive
    blockAnchorUrl="https://www.zillow.com"
    header="Card heading"
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
      </Paragraph>
    }
    footer={
      <TextButton asChild>
        <a href="https://www.zillow.com">Card action</a>
      </TextButton>
    }
  />
);
```

### Card Composable

```tsx
import { Card, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const CardComposable = () => (
  <Card.Root>
    <Card.Header>Card heading</Card.Header>
    <Card.Body>
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
      </Paragraph>
    </Card.Body>
    <Card.Footer>
      <TextButton>Card action</TextButton>
    </Card.Footer>
  </Card.Root>
);
```

### Card Custom Shorthand

```tsx
import { Button, Card, Heading, Paragraph } from '@zillow/constellation';
```

```tsx
export const CardCustomShorthand = () => (
  <Card
    dividers
    header={<Heading level={5}>Card heading</Heading>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
      </Paragraph>
    }
    footer={
      <Button
        tone="brand"
        emphasis="filled"
        fluid
        // oxlint-disable-next-line no-console
        onClick={() => console.log('button onClick')}
        // oxlint-disable-next-line no-console
        onKeyDown={() => console.log('button onKeyDown')}
      >
        Card action
      </Button>
    }
  />
);
```

### Card Interactive Disabled

```tsx
import { Card, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const CardInteractiveDisabled = () => (
  <Card
    disabled
    interactive
    dividers
    header="Card heading"
    onClick={() => {
      console.log('root onClick');
    }}
    onKeyDown={() => {
      console.log('root onKeyDown');
    }}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
      </Paragraph>
    }
    footer={<TextButton>Card action</TextButton>}
  />
);
```

### Card Interactive Flat Shorthand

```tsx
import { Card, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const CardInteractiveFlatShorthand = () => (
  <Card
    interactive
    dividers
    elevated={false}
    header="Card heading"
    onClick={() => {
      // oxlint-disable-next-line no-console
      console.log('root onClick');
    }}
    onKeyDown={() => {
      // oxlint-disable-next-line no-console
      console.log('root onKeyDown');
    }}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
      </Paragraph>
    }
    footer={<TextButton>Card action</TextButton>}
  />
);
```

### Card Interactive Shorthand

```tsx
import { Card, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const CardInteractiveShorthand = () => (
  <Card
    interactive
    dividers
    header="Card heading"
    onClick={() => {
      // oxlint-disable-next-line no-console
      console.log('root onClick');
    }}
    onKeyDown={() => {
      // oxlint-disable-next-line no-console
      console.log('root onKeyDown');
    }}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
      </Paragraph>
    }
    footer={<TextButton>Card action</TextButton>}
  />
);
```

### Card Polymorphic Shorthand

```tsx
import { Card, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const CardPolymorphicShorthand = () => (
  <Card
    asChild
    dividers
    header="Card heading"
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
      </Paragraph>
    }
    footer={<TextButton>Card action</TextButton>}
  >
    <article />
  </Card>
);
```

### Card Shorthand

```tsx
import { Card, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const CardShorthand = () => (
  <Card
    dividers
    header="Card heading"
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
      </Paragraph>
    }
    footer={<TextButton>Card action</TextButton>}
  />
);
```

### Card Soft

```tsx
import { Card, Paragraph } from '@zillow/constellation';
```

```tsx
export const CardSoft = () => (
  <Card tone="soft">
    <Paragraph>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
      efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.{' '}
    </Paragraph>
  </Card>
);
```

## Styling Rules (CRITICAL)

**ALWAYS** set `tone="neutral"`.

**Choose ONE style — NEVER combine `elevated` and `outlined`:**

| Style | Props | When to use |
|-------|-------|-------------|
| **Elevated** (shadow) | `elevated tone="neutral" interactive` | Clickable/interactive cards — links, navigation, actions |
| **Outlined** (border) | `outlined elevated={false} tone="neutral"` | Static display cards — info panels, read-only content, form sections |
| **Minimal** (neither) | `elevated={false} tone="neutral"` | Subtle containers with no visual emphasis |

**Key rules:**
- Clickable cards → ALWAYS use `elevated` + `interactive` together
- Static/display cards → use `outlined` with `elevated={false}` (must explicitly disable elevation since `elevated` defaults to `true`)
- NEVER set both `elevated` and `outlined` to `true` on the same card

```tsx
// Clickable card — elevated + interactive
<Card elevated interactive tone="neutral" onClick={handleClick}>
  <Paragraph>Click to navigate</Paragraph>
</Card>

// Static display card — outlined, no elevation
<Card outlined elevated={false} tone="neutral">
  <Paragraph>Read-only information</Paragraph>
</Card>

// Minimal card — no emphasis
<Card elevated={false} tone="neutral">
  <Paragraph>Subtle container</Paragraph>
</Card>
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets disabled state when interactive |
| `elevated` | `boolean` | `true` | Adds shadow to the card |
| `interactive` | `boolean` | `false` | Adds interactive styling to the card (hover, cursor pointer, etc). |
| `outlined` | `boolean` | `true` | Adds border outline around the card |
| `role` | `AriaRole` | — | Used for accessibility. If the Card's `interactive` prop is set, the `role` is set to `"button"` by default. |
| `tone` | `'neutral' \| 'soft'` | `neutral` | Adds tone to the card |
| `blockAnchorUrl` | `string` | — | URL for the invisible block overlay action |
| `dividers` | `boolean` | `true` | Adds dividers to the card header and footer sections |
| `header` | `ReactNode` | — | Header content |
| `body` | `ReactNode` | — | Body content |
| `footer` | `ReactNode` | — | Footer content |

### CardBlockAnchor

**Element:** `HTMLAnchorElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### CardBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### CardContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### CardFooter

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `divider` | `boolean` | `true` | Adds divider to the card footer |

### CardHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `divider` | `boolean` | `true` | Adds divider to the card header |

### CardRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets disabled state when interactive |
| `elevated` | `boolean` | `true` | Adds shadow to the card |
| `interactive` | `boolean` | `false` | Adds interactive styling to the card (hover, cursor pointer, etc). |
| `outlined` | `boolean` | `true` | Adds border outline around the card |
| `role` | `AriaRole` | — | Used for accessibility. If the Card's `interactive` prop is set, the `role` is set to `"button"` by default. |
| `tone` | `'neutral' \| 'soft'` | `neutral` | Adds tone to the card |

