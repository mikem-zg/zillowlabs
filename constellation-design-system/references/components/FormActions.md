# FormActions

```tsx
import { FormActions } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.0.0

## Usage

```tsx
import { Button, FormActions } from '@zillow/constellation';
```

```tsx
export const FormActionsBasic = () => (
  <FormActions>
    <Button tone="brand" emphasis="filled">
      Submit
    </Button>
  </FormActions>
);
```

## Examples

### Form Actions Polymorphic

```tsx
import { Button, ButtonGroup, FormActions } from '@zillow/constellation';
```

```tsx
export const FormActionsPolymorphic = () => (
  <FormActions asChild>
    <ButtonGroup aria-label="Story buttons" fluid>
      <Button>Cancel</Button>
      <Button tone="brand" emphasis="filled">
        Submit
      </Button>
    </ButtonGroup>
  </FormActions>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

