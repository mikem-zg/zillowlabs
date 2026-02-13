# ToggleCard

```tsx
import { ToggleCard } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.34.0

## Usage

```tsx
import { Box, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardBasic = () => (
  <Box css={{ maxWidth: '400px' }}>
    <ToggleCard>
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
      </Paragraph>
    </ToggleCard>
  </Box>
);
```

## Examples

### Toggle Card Composable

```tsx
import { Box, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardComposable = () => (
  <Box css={{ maxWidth: '400px' }}>
    <ToggleCard.Root>
      <ToggleCard.Header>ToggleCard Heading</ToggleCard.Header>
      <ToggleCard.Body>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      </ToggleCard.Body>
      <ToggleCard.Footer>
        <Paragraph>ToggleCard Footer</Paragraph>
      </ToggleCard.Footer>
    </ToggleCard.Root>
  </Box>
);
```

### Toggle Card Controlled

```tsx
import { Box, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardControlled = () => {
  const [activeId, setActiveId] = useState(1);

  return (
    <Box css={{ display: 'flex', alignItems: 'center', gap: '10', maxWidth: '600px' }}>
      <ToggleCard selected={activeId === 0} onClick={() => setActiveId(0)}>
        <Paragraph>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</Paragraph>
      </ToggleCard>
      <ToggleCard selected={activeId === 1} onClick={() => setActiveId(1)}>
        <Paragraph>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</Paragraph>
      </ToggleCard>
      <ToggleCard selected={activeId === 2} onClick={() => setActiveId(2)}>
        <Paragraph>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</Paragraph>
      </ToggleCard>
    </Box>
  );
};
```

### Toggle Card Custom

```tsx
import { Box, Heading, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardCustom = () => (
  <Box css={{ maxWidth: '400px' }}>
    <ToggleCard
      dividers
      header={
        <Heading level={5} css={{ textAlign: 'center' }}>
          ToggleCard Heading
        </Heading>
      }
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      }
    />
  </Box>
);
```

### Toggle Card Default Selected

```tsx
import { Box, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardDefaultSelected = () => (
  <Box css={{ maxWidth: '400px' }}>
    <ToggleCard defaultSelected outlined={false} elevated>
      <Paragraph>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</Paragraph>
    </ToggleCard>
  </Box>
);
```

### Toggle Card Disabled

```tsx
import { Box, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardDisabled = () => (
  <Box css={{ maxWidth: '400px' }}>
    <ToggleCard disabled>
      <Paragraph>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</Paragraph>
    </ToggleCard>
  </Box>
);
```

### Toggle Card Shorthand

```tsx
import { Box, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardShorthand = () => (
  <Box css={{ maxWidth: '400px' }}>
    <ToggleCard
      dividers
      header="ToggleCard Heading"
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien.
        </Paragraph>
      }
    />
  </Box>
);
```

### Toggle Card Tones

```tsx
import { Box, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardTones = () => (
  <Box css={{ display: 'flex', alignItems: 'center', gap: '10', maxWidth: '600px' }}>
    <ToggleCard tone="neutral">
      <Paragraph>Neutral</Paragraph>
    </ToggleCard>
    <ToggleCard tone="soft">
      <Paragraph>Soft</Paragraph>
    </ToggleCard>
  </Box>
);
```

### Toggle Card Uncontrolled

```tsx
import { Box, Paragraph, ToggleCard } from '@zillow/constellation';
```

```tsx
export const ToggleCardUncontrolled = () => (
  <Box css={{ display: 'flex', alignItems: 'center', gap: '10', maxWidth: '600px' }}>
    <ToggleCard>
      <Paragraph>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</Paragraph>
    </ToggleCard>
    <ToggleCard>
      <Paragraph>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</Paragraph>
    </ToggleCard>
    <ToggleCard>
      <Paragraph>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</Paragraph>
    </ToggleCard>
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets disabled state when interactive |
| `elevated` | `boolean` | `true` | Adds shadow to the card |
| `outlined` | `boolean` | `true` | Adds border outline around the card |
| `onClick` | `MouseEventHandler` | — | Click event handler |
| `tone` | `'neutral' \| 'soft'` | `neutral` | Adds tone to the card |
| `onSelectedChange` | `(value: boolean) => void` | — | Event handler called when the selected state of the ToggleCard changes. |
| `defaultSelected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html).  A ToggleCard can use `selected` or `defaultSelected`, but not both. |
| `selected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components).  A ToggleCard can use `selected` or `defaultSelected`, but not both. |
| `dividers` | `boolean` | `true` | Adds dividers to the card header and footer sections |
| `header` | `ReactNode` | — | Header content |
| `body` | `ReactNode` | — | Body content |
| `footer` | `ReactNode` | — | Footer content |

### ToggleCardBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### ToggleCardFooter

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `divider` | `boolean` | `true` | Adds divider to the card footer |

### ToggleCardHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `divider` | `boolean` | `true` | Adds divider to the card header |

### ToggleCardRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets disabled state when interactive |
| `elevated` | `boolean` | `true` | Adds shadow to the card |
| `outlined` | `boolean` | `true` | Adds border outline around the card |
| `onClick` | `MouseEventHandler` | — | Click event handler |
| `tone` | `'neutral' \| 'soft'` | `neutral` | Adds tone to the card |
| `onSelectedChange` | `(value: boolean) => void` | — | Event handler called when the selected state of the ToggleCard changes. |
| `defaultSelected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). A ToggleCard can use `selected` or `defaultSelected`, but not both. |
| `selected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). A ToggleCard can use `selected` or `defaultSelected`, but not both. |

