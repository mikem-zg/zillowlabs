# InlineFeedback

```tsx
import { InlineFeedback } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.17.0

## Usage

```tsx
import { InlineFeedback } from '@zillow/constellation';
```

```tsx
export const InlineFeedbackBasic = () => (
  <InlineFeedback>Lorem ipsum dolor sit amet, consectetur.</InlineFeedback>
);
```

## Examples

### Inline Feedback Appearances

```tsx
import { Box, InlineFeedback } from '@zillow/constellation';
```

```tsx
export const InlineFeedbackAppearances = () => (
  <Box css={{ display: 'flex', gap: 'layout.default', flexDirection: 'column' }}>
    <InlineFeedback tone="critical">Critical tone. Lorem ipsum dolor sit amet.</InlineFeedback>
    <InlineFeedback tone="info">Info tone. Lorem ipsum dolor sit amet.</InlineFeedback>
    <InlineFeedback tone="success">Success tone. Lorem ipsum dolor sit amet.</InlineFeedback>
    <InlineFeedback tone="transient">Transient tone. Lorem ipsum dolor sit amet.</InlineFeedback>
    <InlineFeedback tone="warning">Warning tone. Lorem ipsum dolor sit amet.</InlineFeedback>
  </Box>
);
```

### Inline Feedback Composable

```tsx
import { InlineFeedback } from '@zillow/constellation';
```

```tsx
export const InlineFeedbackComposable = () => (
  <InlineFeedback.Root tone="success">
    <InlineFeedback.Icon />
    <InlineFeedback.Label>Lorem ipsum dolor sit amet, consectetur.</InlineFeedback.Label>
  </InlineFeedback.Root>
);
```

### Inline Feedback Label Basic

```tsx
import { InlineFeedback } from '@zillow/constellation';
```

```tsx
export const InlineFeedbackLabelBasic = () => (
  <InlineFeedback.Label>Lorem ipsum dolor sit amet, consectetur.</InlineFeedback.Label>
);
```

### Inline Feedback Polymorphic

```tsx
import { InlineFeedback } from '@zillow/constellation';
```

```tsx
export const InlineFeedbackPolymorphic = () => (
  <InlineFeedback asChild>
    <div>
      This example uses &#39;asChild&#39; to render an inline feedback as a div. Normally, it&#39;s
      rendered as a paragraph.
    </div>
  </InlineFeedback>
);
```

### Inline Feedback Wrap Longer Content

```tsx
import { InlineFeedback } from '@zillow/constellation';
```

```tsx
export const InlineFeedbackWrapLongerContent = () => (
  <InlineFeedback>
    This example just shows what it looks like when inline feedback wraps long content. This is
    default behavior — no special prop values are needed. Lorem ipsum dolor sit amet, consectetur
    adipiscing elit. Fusce ornare lorem sit amet quam mattis, ac fringilla est commodo.
  </InlineFeedback>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `'critical' \| 'info' \| 'success' \| 'transient' \| 'warning'` | — | The type and style of inline feedback to display. |
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | The text content of the inline feedback message. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### InlineFeedbackIcon

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The SVG icon to render. |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusable` | `ComponentProps<'svg'>['focusable']` | `false` | The SVG [`focusable`](https://www.w3.org/TR/SVGTiny12/interact.html#focusable-attr) attribute. |
| `role` | `AriaRole` | `img` | The role is set to "img" by default to exclude all child content from the accessibility tree. |
| `size` | `ResponsiveVariant<'sm' \| 'md' \| 'lg' \| 'xl'>` | — | By default, icons are sized to `1em` to match the size of the text content. For fixed-width sizes, you can use the `size` prop. |
| `render` | `ReactNode` | — | Alternative to children. |
| `title` | `string` | — | Creates an accessible label for the icon for contextually meaninful icons, and sets the appropriate `aria` attributes. Icons are hidden from screen readers by default without this prop.  Note: specifying `aria-labelledby`, `aria-hidden`, or `children` manually while using this prop may produce accessibility errors. This prop is only available on prebuilt icons within Constellation. |
| `tone` | `Exclude<StatusType, 'complete' \| 'incomplete'>` | `inlineFeedbackRootContext.tone \|\| 'info'` | The type and style of inline feedback to display. |

### InlineFeedbackLabel

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | The text content of the inline feedback message. **(required)** |
| `color` | `\| 'text.invisible'     \| 'text.neutral'     \| 'text.neutral-fixed'     \| 'text.subtle'     \| 'transparent'     \| 'brand'     \| 'brandSecondary'     \| 'textWhite'     \| 'textLight'     \| 'textMedium'     \| 'textDark'` | `body` | The text color |
| `css` | `SystemStyleObject` | — | Styles object |
| `fontColor` | `never` | — |  |
| `fontType` | `never` | — |  |
| `textStyle` | `\| 'heading-xl'     \| 'heading-lg'     \| 'heading-md'     \| 'heading-sm'     \| 'heading-xs'     \| 'body-lg'     \| 'body-lg-bold'     \| 'body'     \| 'body-bold'     \| 'body-sm'     \| 'body-sm-bold'     \| 'body-xs'     \| 'body-xs-bold'     \| 'fineprint'     \| 'fineprint-bold'     \| 'fineprint-sm'     \| 'fineprint-sm-bold'     \| 'responsive.heading-xl'     \| 'responsive.heading-lg'     \| 'responsive.heading-md'     \| 'responsive.heading-sm'     \| 'responsive.heading-xs'     \| 'responsive.body-lg'     \| 'responsive.body-lg-bold'` | `body` | The text style, it determines the size, weight, and line-height.  Text styles prefixed with `responsive`, will include responsive typography already provided. |
| `tone` | `Exclude<StatusType, 'complete' \| 'incomplete'>` | `inlineFeedbackRootContext.tone \|\| 'info'` | The type and style of inline feedback to display. |

### InlineFeedbackRoot

**Element:** `HTMLParagraphElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `tone` | `'critical' \| 'info' \| 'success' \| 'transient' \| 'warning'` | `info` | The type and style of inline feedback to display. |
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Usually `InlineFeedback.Icon` and `InlineFeedback.Label` components. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

