# NumberRating

```tsx
import { NumberRating } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { NumberRating } from '@zillow/constellation';
```

```tsx
export const NumberRatingBasic = () => <NumberRating value={4.54} />;
```

## Examples

### Number Rating Rounding As Function

```tsx
import { NumberRating } from '@zillow/constellation';
```

```tsx
export const NumberRatingRoundingAsFunction = () => (
  <NumberRating value={4.54} rounding={(value) => Math.ceil(value)} />
);
```

### Number Rating Rounding As Number

```tsx
import { NumberRating } from '@zillow/constellation';
```

```tsx
export const NumberRatingRoundingAsNumber = () => <NumberRating value={4.54} rounding={2} />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `rounding` | `number \| ((value: number) => number)` | `1` | Rounds the value up or down to a desired threshold. If a number is provided, the default function will round to that number of decimal places. Or, you can provide your own rounding function that takes `value` as an arg. |
| `value` | `number` | — | The rating value **(required)** |

