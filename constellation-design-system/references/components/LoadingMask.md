# LoadingMask

```tsx
import { LoadingMask } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { LoadingMask, Paragraph } from '@zillow/constellation';
```

```tsx
export const LoadingMaskBasic = () => (
  <LoadingMask loading loadingVoiceOver="Loading">
    <Paragraph>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
      mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus scelerisque
      nulla sit amet placerat. Morbi rhoncus dictum elementum. Nulla facilisi. Mauris porta sit amet
      erat a euismod. Duis lacus mauris, molestie et purus a, mollis ullamcorper velit. Aliquam
      accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra.
    </Paragraph>
  </LoadingMask>
);
```

## Examples

### Loading Mask On Impact

```tsx
import { LoadingMask, Paragraph } from '@zillow/constellation';
```

```tsx
export const LoadingMaskOnImpact = () => (
  <LoadingMask loading loadingVoiceOver="Loading" onImpact>
    <Paragraph css={{ color: 'text.onImpact.neutral' }}>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
      mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus scelerisque
      nulla sit amet placerat. Morbi rhoncus dictum elementum. Nulla facilisi. Mauris porta sit amet
      erat a euismod. Duis lacus mauris, molestie et purus a, mollis ullamcorper velit. Aliquam
      accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu pharetra.
    </Paragraph>
  </LoadingMask>
);
```

### Loading Mask With Composed Components

```tsx
import { LoadingMask, Paragraph } from '@zillow/constellation';
```

```tsx
export const LoadingMaskWithComposedComponents = () => (
  <LoadingMask.Root loading loadingVoiceOver="Loading">
    <LoadingMask.Content>
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam
        mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus
        scelerisque nulla sit amet placerat. Morbi rhoncus dictum elementum. Nulla facilisi. Mauris
        porta sit amet erat a euismod. Duis lacus mauris, molestie et purus a, mollis ullamcorper
        velit. Aliquam accumsan, augue id sollicitudin posuere, magna nulla fermentum purus, eu
        pharetra.
      </Paragraph>
    </LoadingMask.Content>
    <LoadingMask.Spinner />
  </LoadingMask.Root>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The content to be masked. **(required)** |
| `display` | `never` | — | Loading mask's wrapper CSS display value |
| `loading` | `boolean` | `true` | The loading state of the container. |
| `loadingVoiceOver` | `string` | `Loading` | The text that will be announced to screen readers using `VisuallyHidden`. |
| `iconSize` | `IconPropsInterface['size']` | `lg` | The size of the `Spinner`. |
| `role` | `AriaRole` | `status` | The ARIA role, defaulting to [status](https://www.w3.org/TR/wai-aria-1.1/#status). |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |
| `css` | `SystemStyleObject` | — | Styles object |

### LoadingMaskContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The content to be masked. **(required)** |
| `inert` | `boolean` | — | Prevents interaction with contents. See [MDN docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/inert). Automatically set by `loading`. Note: This type is not provided by React below React 19. |
| `loading` | `boolean` | `true` | The loading state of icon. Provided by LoadingMask.Root context. |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. Provided by LoadingMask.Root context. |
| `css` | `SystemStyleObject` | — | Styles object |

### LoadingMaskRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The content of the Root component. **(required)** |
| `display` | `never` | — | Loading mask's wrapper CSS display value |
| `loading` | `boolean` | `true` | The loading state of the container. |
| `loadingVoiceOver` | `string` | `Loading` | The text that will be announced to screen readers using `VisuallyHidden`. |
| `iconSize` | `IconPropsInterface['size']` | `lg` | The size of the `Spinner`. |
| `role` | `AriaRole` | `status` | The ARIA role, defaulting to [status](https://www.w3.org/TR/wai-aria-1.1/#status). |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |
| `css` | `SystemStyleObject` | — | Styles object |

### LoadingMaskSpinner

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `loading` | `boolean` | `true` | The loading state of icon. Provided by LoadingMask.Root context. |
| `size` | `SpinnerPropsInterface['size']` | `lg` | The icon size. Provided by LoadingMask.Root context. |
| `css` | `SystemStyleObject` | — | Styles object |
| `onImpact` | `boolean` | `false` | Inverse colors for use on dark or colored backgrounds. |

