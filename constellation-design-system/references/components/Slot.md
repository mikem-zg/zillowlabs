# Slot

```tsx
import { Slot, Slottable } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

The `Slot` component merges its props onto its immediate child element. This is useful for components that use the `asChild` pattern, allowing consumers to replace the default rendered element while preserving the component's behavior and styles.

`Slottable` is used within a `Slot` to mark which part of the children should be slotted.

```tsx
import { Slot, Slottable } from '@zillow/constellation';
```

## API

### Slot

**Element:** `HTMLElement`

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| children | `ReactNode` | - | The child element to merge props onto |

### Slottable

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| children | `ReactNode` | **required** | The content to be slotted |

