# MediaObject

```tsx
import { MediaObject } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 7.6.0

## Usage

```tsx
import { Avatar, MediaObject, Paragraph } from '@zillow/constellation';
```

```tsx
export const MediaObjectBasic = () => (
  <MediaObject media={<Avatar fullName="Jeremy Wacksman" />}>
    <Paragraph>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
      efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa, ornare
      quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel, elementum
      nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in scelerisque augue.
      Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a augue elementum, ac
      ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque
      blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at
      sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam,
      ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue
      vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
      Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit
      amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi
      eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel,
      aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero.
      Maecenas malesuada lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam
      consectetur elit non sem malesuada gravida.
    </Paragraph>
  </MediaObject>
);
```

## Examples

### Media Object Alignment

```tsx
import { Avatar, MediaObject, Paragraph } from '@zillow/constellation';
```

```tsx
export const MediaObjectAlignment = () => (
  <MediaObject media={<Avatar fullName="Jeremy Wacksman" />} css={{ alignItems: 'end' }}>
    <Paragraph>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
      efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa, ornare
      quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel, elementum
      nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in scelerisque augue.
      Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a augue elementum, ac
      ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque
      blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at
      sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam,
      ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue
      vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
      Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit
      amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi
      eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel,
      aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero.
      Maecenas malesuada lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam
      consectetur elit non sem malesuada gravida.
    </Paragraph>
  </MediaObject>
);
```

### Media Object Column

```tsx
import { Avatar, MediaObject, Paragraph } from '@zillow/constellation';
```

```tsx
export const MediaObjectColumn = () => (
  <MediaObject
    media={<Avatar fullName="Jeremy Wacksman" />}
    css={{ alignItems: 'center', flexDirection: 'column' }}
  >
    <Paragraph>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
      efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa, ornare
      quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel, elementum
      nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in scelerisque augue.
      Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a augue elementum, ac
      ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque
      blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at
      sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam,
      ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue
      vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
      Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit
      amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi
      eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel,
      aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero.
      Maecenas malesuada lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam
      consectetur elit non sem malesuada gravida.
    </Paragraph>
  </MediaObject>
);
```

### Media Object Composed

```tsx
import { Avatar, MediaObject, Paragraph } from '@zillow/constellation';
```

```tsx
export const MediaObjectComposed = () => (
  <MediaObject.Root>
    <MediaObject.Media>
      <Avatar fullName="Jeremy Wacksman" />
    </MediaObject.Media>
    <MediaObject.Content>
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et
        aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna.
        Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada
        lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
        malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin. Lorem
        ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
      </Paragraph>
    </MediaObject.Content>
  </MediaObject.Root>
);
```

### Media Object Reversed

```tsx
import { Avatar, MediaObject, Paragraph } from '@zillow/constellation';
```

```tsx
export const MediaObjectReversed = () => (
  <MediaObject media={<Avatar fullName="Jeremy Wacksman" />} css={{ flexDirection: 'row-reverse' }}>
    <Paragraph>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
      efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa, ornare
      quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel, elementum
      nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in scelerisque augue.
      Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a augue elementum, ac
      ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque
      blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at
      sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam,
      ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue
      vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
      Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit
      amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi
      eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel,
      aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero.
      Maecenas malesuada lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam
      consectetur elit non sem malesuada gravida.
    </Paragraph>
  </MediaObject>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `media` | `ReactNode` | — | Media **(required)** |

### MediaObjectContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### MediaObjectMedia

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### MediaObjectRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

