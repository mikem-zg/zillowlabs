# CloseButton

```tsx
import { CloseButton } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { CloseButton } from '@zillow/constellation';
```

```tsx
export const CloseButtonBasic = () => <CloseButton title="Close" />;
```

## Examples

### Close Button On Impact

```tsx
import { CloseButton } from '@zillow/constellation';
```

```tsx
export const CloseButtonOnImpact = () => <CloseButton onImpact title="Close" />;
```

### Close Button Polymorphic

```tsx
import { CloseButton, Icon } from '@zillow/constellation';
```

```tsx
export const CloseButtonPolymorphic = () => (
  <CloseButton asChild title="Close">
    <a href="https://www.zillow.com">
      <Icon>
        <IconChevronRightFilled />
      </Icon>
    </a>
  </CloseButton>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | The close button content, by default a close icon. |
| `css` | `SystemStyleObject` | — | Styles object |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |
| `label` | `string` | — |  |
| `title` | `string` | `Close` | Used to tell screenreaders what to speak for this button. This will leverage the VisuallyHidden component to allow a consistent experience and solve a NVDA bug. |

