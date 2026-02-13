# RatingStars

```tsx
import { RatingStars } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.4.0

## Usage

```tsx
import { RatingStars } from '@zillow/constellation';
```

```tsx
export const RatingStarsBasic = () => <RatingStars aria-label="2.5 out of 5 stars" value={2.5} />;
```

## Examples

### Rating Stars Custom Rounding

```tsx
import { RatingStars, type RatingStarsPropsInterface } from '@zillow/constellation';
```

```tsx
const customRoundingFn: RatingStarsPropsInterface['roundingFn'] = (value) => {
  if (!value) {
    return 0;
  }
  if (value >= 0.5) {
    return 100;
  }
  return 50;
};

export const RatingStarsCustomRounding = () => (
  <RatingStars aria-label="2.49 out of 5 stars" value={2.49} roundingFn={customRoundingFn} />
);
```

### Rating Stars Full Rating

```tsx
import { RatingStars } from '@zillow/constellation';
```

```tsx
export const RatingStarsFullRating = () => (
  <RatingStars aria-label="5 out of 5 stars" value={100} />
);
```

### Rating Stars No Rating

```tsx
import { RatingStars } from '@zillow/constellation';
```

```tsx
export const RatingStarsNoRating = () => <RatingStars aria-label="Not rated" value={null} />;
```

### Rating Stars Zero Rating

```tsx
import { RatingStars } from '@zillow/constellation';
```

```tsx
export const RatingStarsZeroRating = () => <RatingStars aria-label="0 out of 5 stars" value={0} />;
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-label'` | `AriaAttributes['aria-label']` | — | Used to convey the rating to screen readers. Ex: "3.6 out of 5 stars." If you're already including this text in an accompanying label use [`aria-labelledby`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_aria-labelledby_attribute) instead. |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'roundingFn'` | `(value: number \| null) => 0 \| 50 \| 100` | — | A function that translates a value into percentage used to select the right star. It takes value argument as null or between 0 and 1, ex: 0.49 It then returns rounded up or down value as percentage, ex: 0, 50, or 100. The default function rounds ***down*** to the nearest half star. Ex: 0.49 => 0 (empty star), 0.99 => 50 (half star) |
| `'maxValue'` | `number` | `5` | The highest rating this set of stars can represent. Customizing this value is not encouraged and should only be used in rare cases. |
| `'role'` | `AriaRole` | `img` | A WAI-ARIA role is required in order to use `aria-label` or `aria-labelledby`. We default to using [`role="img"`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/Role_Img) so that screen readers treat the group of stars as a single image. |
| `'value'` | `number \| null` | — | Takes a rating value from 0 to 5 or null. **(required)** |

