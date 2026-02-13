# LabeledRatingStars

```tsx
import { LabeledRatingStars } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { LabeledRatingStars, RatingStars, TextButton } from '@zillow/constellation';
```

```tsx
export const LabeledRatingStarsBasic = () => (
  <LabeledRatingStars
    ratingStars={<RatingStars value={3} aria-label="3 out of 5 stars" />}
    label={
      <TextButton textStyle="body-sm" tone="neutral" asChild>
        <a href="#reviews">468 reviews</a>
      </TextButton>
    }
  />
);
```

## Examples

### Labeled Rating Stars As Child

```tsx
import { LabeledRatingStars, RatingStars, TextButton } from '@zillow/constellation';
```

```tsx
export const LabeledRatingStarsAsChild = () => (
  <LabeledRatingStars asChild>
    <div>
      <RatingStars value={3} aria-label="3 out of 5 stars" />
      <TextButton textStyle="body-sm" tone="neutral" asChild>
        <a href="#reviews">468 reviews</a>
      </TextButton>
    </div>
  </LabeledRatingStars>
);
```

### Labeled Rating Stars Empty State No Action

```tsx
import { LabeledRatingStars, RatingStars, Text } from '@zillow/constellation';
```

```tsx
export const LabeledRatingStarsEmptyStateNoAction = () => (
  <LabeledRatingStars
    ratingStars={<RatingStars value={null} />}
    label={
      <Text textStyle="body-sm" css={{ color: 'text.subtle' }}>
        No reviews
      </Text>
    }
  />
);
```

### Labeled Rating Stars Empty State With Action

```tsx
import { LabeledRatingStars, RatingStars, TextButton } from '@zillow/constellation';
```

```tsx
export const LabeledRatingStarsEmptyStateWithAction = () => (
  <LabeledRatingStars
    ratingStars={<RatingStars value={null} />}
    label={
      <TextButton textStyle="body-sm" tone="neutral">
        Write a review
      </TextButton>
    }
  />
);
```

### Labeled Rating Stars Multiple Labels

```tsx
import { Box, LabeledRatingStars, RatingStars, Text, TextButton } from '@zillow/constellation';
```

```tsx
export const LabeledRatingStarsMultipleLabels = () => (
  <LabeledRatingStars
    ratingStars={<RatingStars value={3} aria-label="3 out of 5 stars" />}
    label={
      <Box css={{ display: 'inline-flex', gap: 'tightest' }}>
        <TextButton textStyle="body-sm" tone="neutral" asChild>
          <a href="#reviews">468 reviews</a>
        </TextButton>
        <Text>•</Text>
        <TextButton textStyle="body-sm" tone="neutral" asChild>
          <a href="#communities">12 communities</a>
        </TextButton>
      </Box>
    }
  />
);
```

### Labeled Rating Stars With Text

```tsx
import { LabeledRatingStars, RatingStars, Text } from '@zillow/constellation';
```

```tsx
export const LabeledRatingStarsWithText = () => (
  <LabeledRatingStars
    ratingStars={<RatingStars value={5} aria-label="5 out of 5 stars" />}
    label={<Text textStyle="body-sm">Design system expertise</Text>}
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `label` | `ReactNode` | — | The label to display next to the Rating Stars. Usually, this will be a `TextButton`. |
| `ratingStars` | `ReactNode` | — | The `RatingStars` component. |

