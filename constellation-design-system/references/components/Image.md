# Image

```tsx
import { Image } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.10.0

## Usage

```tsx
import { Image } from '@zillow/constellation';
```

```tsx
export const ImageBasic = () => (
  <Image
    alt="Zillow"
    src="https://filecache.mediaroom.com/mr5mr_zillow/204622/Zillow_Wordmark_Blue_RGB.jpg"
  />
);
```

## Examples

### Image Polymorphic

```tsx
import { Image } from '@zillow/constellation';
```

```tsx
export const ImagePolymorphic = () => {
  const src = 'https://filecache.mediaroom.com/mr5mr_zillow/204622/Zillow_Wordmark_Blue_RGB.jpg';
  const alt = 'Zillow';

  return (
    <Image asChild>
      <picture>
        <source srcSet={src} />
        <img src={src} alt={alt} />
      </picture>
    </Image>
  );
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `alt` | `string` | — | Image elements must have an alt prop, either with meaningful text, or an empty string for decorative images. |
| `asChild` | `boolean` | `false` | Use child as the Image element |
| `css` | `SystemStyleObject` | — | Styles object |
| `src` | `string` | — | Image source |

