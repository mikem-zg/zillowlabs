# UnstyledButton

```tsx
import { UnstyledButton } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.30.0

## Usage

```tsx
import { UnstyledButton } from '@zillow/constellation';
```

```tsx
export const UnstyledButtonBasic = () => <UnstyledButton>Unstyled Button</UnstyledButton>;
```

## Examples

### Unstyled Button Text As Button

```tsx
import { Text, UnstyledButton } from '@zillow/constellation';
```

```tsx
export const UnstyledButtonTextAsButton = () => (
  <Text asChild>
    <UnstyledButton
      onClick={() => {
        alert('Action invoked');
      }}
    >
      This is an accessible onClick handler, note the lack of styles on the button element.
    </UnstyledButton>
  </Text>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `role` | `AriaRole` | `button` | A [role](https://www.w3.org/TR/wai-aria-1.2/#roles) is required for assistive technologies to announce the button properly. |

