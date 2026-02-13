# ShowHideWordCount

```tsx
import { ShowHideWordCount } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Paragraph, ShowHideWordCount } from '@zillow/constellation';
```

```tsx
export const ShowHideWordCountBasic = () => (
  <Paragraph>
    <ShowHideWordCount
      text="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus scelerisque nulla sit amet placerat. Morbi rhoncus dictum elementum. Nulla facilisi. Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie et purus a, mollis ullamcorper velit. Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra odio tortor porttitor nisi. Vestibulum faucibus tellus sed magna sodales ultricies. Suspendisse potenti. Curabitur at eros porttitor, luctus quam quis, feugiat metus. Ut semper, tortor eget mattis euismod, enim mi rutrum risus, sit amet commodo diam metus at est. Nam vel urna nec felis mollis adipiscing non eget mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat lobortis."
      wordCount={100}
    />
  </Paragraph>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `defaultHidden` | `boolean` | `true` | A ShowHideWordCount is uncontrolled by default. You can specify `isHidden` to manually control the visibility of disclosable content. |
| `isHidden` | `boolean` | — | A ShowHideWordCount is uncontrolled by default. You can specify `isHidden` to manually control the visibility of disclosable content. |
| `onDisplayChange` | `() => void` | — | Call back when the visibility of disclosable content is changed |
| `renderButton` | `ReactNode \| ((props: ShowHideWordCountPropsInterface) => ReactNode)` | — | Default button styling corresponding to the `appearance` prop. |
| `text` | `string` | — | Content to be displayed. Part of the content will be toggled based on `wordCount`. **(required)** |
| `wordCount` | `number` | `100` | Function called when button is pressed. |

