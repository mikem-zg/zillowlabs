# ShowHide

```tsx
import { ShowHide } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.36.0

## Usage

```tsx
import { Anchor, Paragraph, ShowHide } from '@zillow/constellation';
```

```tsx
export const ShowHideBasic = () => (
  <ShowHide.Root>
    <Paragraph>
      Lorem ipsum dolor sit amet, <Anchor>consectetur</Anchor> adipiscing elit. Fusce ornare lorem
      sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.{' '}
      <Anchor>Vivamus</Anchor> cursus scelerisque nulla sit amet placerat. Morbi rhoncus dictum
      elementum. Nulla facilisi. Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie
      et purus a, mollis ullamcorper velit.{' '}
      <ShowHide.Hidden>
        Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra
        odio tortor porttitor nisi. Vestibulum faucibus tellus sed magna sodales ultricies.
        Suspendisse potenti. Curabitur at eros porttitor, luctus quam quis, feugiat metus. Ut
        semper, tortor eget mattis euismod, enim mi rutrum risus, sit amet{' '}
        <Anchor>commodo diam</Anchor> metus at est. Nam vel urna nec felis mollis adipiscing non
        eget mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam
        ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat lobortis.
      </ShowHide.Hidden>
    </Paragraph>
  </ShowHide.Root>
);
```

## Examples

### Show Hide As Child

```tsx
import { Anchor, Paragraph, ShowHide } from '@zillow/constellation';
```

```tsx
export const ShowHideAsChild = () => (
  <ShowHide.Root asChild>
    <section>
      <Paragraph>
        Lorem ipsum dolor sit amet, <Anchor>consectetur</Anchor> adipiscing elit. Fusce ornare lorem
        sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.{' '}
        <Anchor>Vivamus</Anchor> cursus scelerisque nulla sit amet placerat. Morbi rhoncus dictum
        elementum. Nulla facilisi. Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie
        et purus a, mollis ullamcorper velit.{' '}
        <ShowHide.Hidden>
          Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra
          odio tortor porttitor nisi. Vestibulum faucibus tellus sed magna sodales ultricies.
          Suspendisse potenti. Curabitur at eros porttitor, luctus quam quis, feugiat metus. Ut
          semper, tortor eget mattis euismod, enim mi rutrum risus, sit amet{' '}
          <Anchor>commodo diam</Anchor> metus at est. Nam vel urna nec felis mollis adipiscing non
          eget mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam
          ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat
          lobortis.
        </ShowHide.Hidden>
      </Paragraph>
    </section>
  </ShowHide.Root>
);
```

### Show Hide Custom Button

```tsx
import { Anchor, Paragraph, ShowHide, TextButton } from '@zillow/constellation';
```

```tsx
export const ShowHideCustomButton = () => {
  const [isHiddenState, setIsHiddenState] = useState(true);

  const renderButton = () => (
    <TextButton.Root
      onClick={() => {
        setIsHiddenState(!isHiddenState);
      }}
    >
      <TextButton.Icon size="sm">
        {isHiddenState ? <IconPlusFilled /> : <IconCloseFilled />}
      </TextButton.Icon>
      <TextButton.Label>{isHiddenState ? 'Show' : 'Hide'}</TextButton.Label>
    </TextButton.Root>
  );

  return (
    <ShowHide.Root isHidden={isHiddenState} renderButton={renderButton}>
      <Paragraph>
        Lorem ipsum dolor sit amet, <Anchor>consectetur</Anchor> adipiscing elit. Fusce ornare lorem
        sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.{' '}
        <Anchor>Vivamus</Anchor> cursus scelerisque nulla sit amet placerat. Morbi rhoncus dictum
        elementum. Nulla facilisi. Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie
        et purus a, mollis ullamcorper velit.{' '}
        <ShowHide.Hidden>
          Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra
          odio tortor porttitor nisi. Vestibulum faucibus tellus sed magna sodales ultricies.
          Suspendisse potenti. Curabitur at eros porttitor, luctus quam quis, feugiat metus. Ut
          semper, tortor eget mattis euismod, enim mi rutrum risus, sit amet{' '}
          <Anchor>commodo diam</Anchor> metus at est. Nam vel urna nec felis mollis adipiscing non
          eget mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam
          ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat
          lobortis.
        </ShowHide.Hidden>
      </Paragraph>
    </ShowHide.Root>
  );
};
```

### Show Hide Default Not Hidden

```tsx
import { Anchor, Paragraph, ShowHide } from '@zillow/constellation';
```

```tsx
export const ShowHideDefaultNotHidden = () => (
  <ShowHide.Root defaultHidden={false}>
    <Paragraph>
      Lorem ipsum dolor sit amet, <Anchor>consectetur</Anchor> adipiscing elit. Fusce ornare lorem
      sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.{' '}
      <Anchor>Vivamus</Anchor> cursus scelerisque nulla sit amet placerat. Morbi rhoncus dictum
      elementum. Nulla facilisi. Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie
      et purus a, mollis ullamcorper velit.{' '}
      <ShowHide.Hidden>
        Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra
        odio tortor porttitor nisi. Vestibulum faucibus tellus sed magna sodales ultricies.
        Suspendisse potenti. Curabitur at eros porttitor, luctus quam quis, feugiat metus. Ut
        semper, tortor eget mattis euismod, enim mi rutrum risus, sit amet{' '}
        <Anchor>commodo diam</Anchor> metus at est. Nam vel urna nec felis mollis adipiscing non
        eget mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam
        ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat lobortis.
      </ShowHide.Hidden>
    </Paragraph>
  </ShowHide.Root>
);
```

### Show Hide Inline

```tsx
import { Anchor, Paragraph, ShowHide } from '@zillow/constellation';
```

```tsx
export const ShowHideInline = () => (
  <ShowHide.Root appearance="inline">
    <Paragraph>
      Lorem ipsum dolor sit amet, <Anchor>consectetur</Anchor> adipiscing elit. Fusce ornare lorem
      sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.{' '}
      <Anchor>Vivamus</Anchor> cursus scelerisque nulla sit amet placerat. Morbi rhoncus dictum
      elementum. Nulla facilisi. Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie
      et purus a, mollis ullamcorper velit. Nostra faucibus pretium augue feugiat felis commodo
      tellus. Pulvinar vel suspendisse volutpat per congue;{' '}
      <ShowHide.Hidden>
        Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra
        odio tortor porttitor nisi. Vestibulum faucibus tellus sed magna sodales ultricies.
        Suspendisse potenti. Curabitur at eros porttitor, luctus quam quis, feugiat metus. Ut
        semper, tortor eget mattis euismod, enim mi rutrum risus, sit amet{' '}
        <Anchor>commodo diam</Anchor> metus at est. Nam vel urna nec felis mollis adipiscing non
        eget mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam
        ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat lobortis.
      </ShowHide.Hidden>
    </Paragraph>
  </ShowHide.Root>
);
```

### Show Hide On Display Change

```tsx
import { Anchor, Paragraph, ShowHide } from '@zillow/constellation';
```

```tsx
export const ShowHideOnDisplayChange = () => (
  <ShowHide.Root
    onDisplayChange={() => {
      // oxlint-disable-next-line no-console
      console.log('onDisplayChange called');
    }}
  >
    <Paragraph>
      Lorem ipsum dolor sit amet, <Anchor>consectetur</Anchor> adipiscing elit. Fusce ornare lorem
      sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.{' '}
      <Anchor>Vivamus</Anchor> cursus scelerisque nulla sit amet placerat. Morbi rhoncus dictum
      elementum. Nulla facilisi. Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie
      et purus a, mollis ullamcorper velit.{' '}
      <ShowHide.Hidden>
        Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra
        odio tortor porttitor nisi. Vestibulum faucibus tellus sed magna sodales ultricies.
        Suspendisse potenti. Curabitur at eros porttitor, luctus quam quis, feugiat metus. Ut
        semper, tortor eget mattis euismod, enim mi rutrum risus, sit amet{' '}
        <Anchor>commodo diam</Anchor> metus at est. Nam vel urna nec felis mollis adipiscing non
        eget mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam
        ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat lobortis.
      </ShowHide.Hidden>
    </Paragraph>
  </ShowHide.Root>
);
```

### Show Hide Using Is Hidden

```tsx
import { Anchor, Paragraph, ShowHide } from '@zillow/constellation';
```

```tsx
export const ShowHideUsingIsHidden = () => (
  <ShowHide.Root isHidden>
    <Paragraph>
      Lorem ipsum dolor sit amet, <Anchor>consectetur</Anchor> adipiscing elit. Fusce ornare lorem
      sit amet quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus.{' '}
      <Anchor>Vivamus</Anchor> cursus scelerisque nulla sit amet placerat. Morbi rhoncus dictum
      elementum. Nulla facilisi. Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie
      et purus a, mollis ullamcorper velit.{' '}
      <ShowHide.Hidden>
        Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra
        odio tortor porttitor nisi. Vestibulum faucibus tellus sed magna sodales ultricies.
        Suspendisse potenti. Curabitur at eros porttitor, luctus quam quis, feugiat metus. Ut
        semper, tortor eget mattis euismod, enim mi rutrum risus, sit amet{' '}
        <Anchor>commodo diam</Anchor> metus at est. Nam vel urna nec felis mollis adipiscing non
        eget mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam
        ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat lobortis.
      </ShowHide.Hidden>
    </Paragraph>
  </ShowHide.Root>
);
```

### Show Hide With Multiple Components

```tsx
import { List, ShowHide } from '@zillow/constellation';
```

```tsx
export const ShowHideWithMultipleComponents = () => (
  <ShowHide.Root>
    <List.Root>
      <List.Item>item 1</List.Item>
      <List.Item>item 2</List.Item>
      <List.Item>item 3</List.Item>
      <ShowHide.Hidden>
        <List.Item>item 4</List.Item>
        <List.Item>item 5</List.Item>
        <List.Item>item 6</List.Item>
      </ShowHide.Hidden>
    </List.Root>
  </ShowHide.Root>
);
```

## API

### ShowHideButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — |  **(required)** |
| `css` | `SystemStyleObject` | — |  |
| `onClick` | `MouseEventHandler<HTMLButtonElement>` | — |  |

### ShowHideHidden

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The visibility of the content will be controlled by `isHidden`. **(required)** |
| `isHidden` | `boolean` | — | Flag to display children content. |

### ShowHideRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `appearance` | `'block' \| 'inline'` | `block` | The type of ShowHide to display. |
| `children` | `ReactNode` | — | The visibility of disclosable content will be controlled by button press. **(required)** |
| `defaultHidden` | `boolean` | `true` | A ShowHide is uncontrolled by default. You can specify `isHidden` to manually control the visibility of disclosable content. |
| `isHidden` | `boolean` | — | A ShowHide is uncontrolled by default. You can specify `isHidden` to manually control the visibility of disclosable content. |
| `onDisplayChange` | `() => void` | — | Call back when the visibility of disclosable content is changed |
| `renderButton` | `ReactNode \| ((props: ShowHideRootPropsInterface) => ReactNode)` | — | Default button styling corresponding to the `appearance` prop. |

