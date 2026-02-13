# Paragraph

```tsx
import { Paragraph } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.0.0

## Usage

```tsx
import { Paragraph } from '@zillow/constellation';
```

```tsx
export const ParagraphBasic = () => (
  <Paragraph color="text.neutral" textStyle="body">
    A design system is a complete set of standards intended to manage design at scale using reusable
    components and patterns. But, it is more than just a library of components and patterns—it is a
    shared language.
  </Paragraph>
);
```

## Examples

### Paragraph With Icon

```tsx
import { Icon, Paragraph } from '@zillow/constellation';
```

```tsx
export const ParagraphWithIcon = () => (
  <Paragraph color="text.neutral" textStyle="body">
    <Icon>
      <IconCheckmarkCircleFilled />
    </Icon>{' '}
    Design and development work can be created and replicated quickly and at scale.
  </Paragraph>
);
```

### Paragraph With Semantic Elements

```tsx
import { Paragraph } from '@zillow/constellation';
```

```tsx
export const ParagraphWithSemanticElements = () => (
  <Paragraph color="text.neutral" textStyle="body">
    Lorem <strong>ipsum</strong> dolor <em>sit</em> amet, <b>consectetur</b> adipiscing <i>elit</i>.
  </Paragraph>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `color` | `\| 'text.invisible'     \| 'text.neutral'     \| 'text.neutral-fixed'     \| 'text.subtle'     \| 'transparent'     \| 'brand'     \| 'brandSecondary'     \| 'textWhite'     \| 'textLight'     \| 'textMedium'     \| 'textDark'` | `text.neutral` | The text color |
| `css` | `SystemStyleObject` | — | Styles object |
| `fontColor` | `never` | — |  |
| `fontType` | `never` | — |  |
| `textStyle` | `\| 'body-lg'     \| 'body-lg-bold'     \| 'body'     \| 'body-bold'     \| 'body-sm'     \| 'body-sm-bold'     \| 'body-xs'     \| 'body-xs-bold'     \| 'fineprint'     \| 'fineprint-bold'     \| 'fineprint-sm'     \| 'fineprint-sm-bold'` | `body` | The text style, it determines the size, weight, and line-height. |

