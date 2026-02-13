# Avatar

```tsx
import { Avatar } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 6.10.0

## Usage

```tsx
import { Avatar } from '@zillow/constellation';
```

```tsx
export const AvatarBasic = () => <Avatar />;
```

## Examples

### Avatar Accessible

```tsx
import { Avatar, Box, Heading } from '@zillow/constellation';
```

```tsx
export const AvatarAccessible = () => {
  return (
    <Box css={{ display: 'flex', gap: 'layout.default', flexDirection: 'column' }}>
      <Box css={{ display: 'flex', gap: 'layout.tight', alignItems: 'center' }}>
        <Avatar aria-label="Abraham Lincoln" fullName="Abraham Lincoln" />
        <Heading level={5}>Standalone avatar with aria-label</Heading>
      </Box>
      <Box css={{ display: 'flex', gap: 'layout.tight', alignItems: 'center' }}>
        <Avatar aria-hidden fullName="Abraham Lincoln" />
        <Heading level={5}>Abraham Lincoln</Heading>
      </Box>
    </Box>
  );
};
```

### Avatar Composed

```tsx
import { Avatar, Box } from '@zillow/constellation';
```

```tsx
export const AvatarComposed = () => (
  <Box css={{ display: 'flex', alignItems: 'center', flexWrap: 'wrap', gap: 'loose' }}>
    <Avatar.Root>
      <Avatar.Icon />
      <Avatar.Badge icon={<IconCheckmarkFilled />} tone="hero" />
    </Avatar.Root>
    <Avatar.Root>
      <Avatar.Image
        src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
        alt="Rich Barton"
      />
    </Avatar.Root>
    <Avatar.Root tone="accent-1">
      <Avatar.FullName>Rich Barton</Avatar.FullName>
    </Avatar.Root>
  </Box>
);
```

### Avatar Sizes

```tsx
import { Avatar, Box } from '@zillow/constellation';
```

```tsx
export const AvatarSizes = () => {
  return (
    <>
      <Box
        css={{
          display: 'flex',
          alignItems: 'center',
          flexWrap: 'wrap',
          gap: 'tighter',
          marginBlockStart: 'tighter',
        }}
      >
        <Avatar size="xs" />
        <Avatar size="sm" />
        <Avatar size="md" />
        <Avatar size="lg" />
        <Avatar size="xl" />
        <Avatar size="xxl" />
      </Box>
      <Box
        css={{
          display: 'flex',
          alignItems: 'center',
          flexWrap: 'wrap',
          gap: 'tighter',
          marginBlockStart: 'tighter',
        }}
      >
        <Avatar size="xs" fullName="Rich Barton" />
        <Avatar size="sm" fullName="Rich Barton" />
        <Avatar size="md" fullName="Rich Barton" />
        <Avatar size="lg" fullName="Rich Barton" />
        <Avatar size="xl" fullName="Rich Barton" />
        <Avatar size="xxl" fullName="Rich Barton" />
      </Box>
      <Box
        css={{
          display: 'flex',
          alignItems: 'center',
          flexWrap: 'wrap',
          gap: 'tighter',
          marginBlockStart: 'tighter',
        }}
      >
        <Avatar size="xs">
          <Avatar.Image
            alt="Rich Barton"
            src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
          />
        </Avatar>
        <Avatar size="sm">
          <Avatar.Image
            alt="Rich Barton"
            src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
          />
        </Avatar>
        <Avatar size="md">
          <Avatar.Image
            alt="Rich Barton"
            src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
          />
        </Avatar>
        <Avatar size="lg">
          <Avatar.Image
            alt="Rich Barton"
            src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
          />
        </Avatar>
        <Avatar size="xl">
          <Avatar.Image
            alt="Rich Barton"
            src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
          />
        </Avatar>
        <Avatar size="xxl">
          <Avatar.Image
            alt="Rich Barton"
            src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
          />
        </Avatar>
      </Box>
    </>
  );
};
```

### Avatar Tones

```tsx
import { Avatar, Box } from '@zillow/constellation';
```

```tsx
export const AvatarTones = () => {
  return (
    <Box css={{ display: 'flex', gap: 'layout.default', flexWrap: 'wrap' }}>
      <Avatar tone="default" fullName="Rich Barton" />
      <Avatar tone="brand-hero" fullName="George Washington" />
      <Avatar tone="accent-1" fullName="Thomas Jefferson" />
      <Avatar tone="accent-2" fullName="Abraham Lincoln" />
      <Avatar tone="accent-3" fullName="Theodore Roosevelt" />
      <Avatar tone="accent-4" fullName="Franklin Roosevelt" />
    </Box>
  );
};
```

### Avatar With Badge With Badge Tone

```tsx
import { Avatar, Box } from '@zillow/constellation';
```

```tsx
export const AvatarWithBadgeWithBadgeTone = () => (
  <Box css={{ display: 'flex', alignItems: 'center', flexWrap: 'wrap', gap: 'loose' }}>
    <Avatar size="lg" badge={<Avatar.Badge icon={<IconCheckmarkFilled />} tone="hero" />} />
    <Avatar size="xl" badge={<Avatar.Badge icon={<IconCheckmarkFilled />} tone="hero" />} />
    <Avatar size="lg" badge={<Avatar.Badge icon={<IconPlusFilled />} tone="impact" />} />
    <Avatar size="xl" badge={<Avatar.Badge icon={<IconPlusFilled />} tone="impact" />} />
    <Avatar
      size="lg"
      src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
      alt="Rich Barton"
      badge={<Avatar.Badge icon={<IconTopAgent />} tone="bare" />}
    />
    <Avatar
      size="xl"
      src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
      alt="Rich Barton"
      badge={<Avatar.Badge icon={<IconTopAgent />} tone="bare" />}
    />
    <Avatar
      size="xxl"
      src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
      alt="Rich Barton"
      badge={<Avatar.Badge icon={<IconTopAgent />} tone="bare" />}
    />
  </Box>
);
```

### Avatar With Badge

```tsx
import { Avatar } from '@zillow/constellation';
```

```tsx
export const AvatarWithBadge = () => (
  <Avatar
    fullName="Abraham Lincoln"
    badge={<Avatar.Badge icon={<IconCheckmarkFilled />} tone="hero" />}
  />
);
```

### Avatar With Emoji

```tsx
import { Avatar } from '@zillow/constellation';
```

```tsx
export const AvatarWithEmoji = () => <Avatar fullName="🤠" />;
```

### Avatar With Icon

```tsx
import { Avatar } from '@zillow/constellation';
```

```tsx
export const AvatarWithIcon = () => <Avatar aria-label="User avatar" icon={<IconUserFilled />} />;
```

### Avatar With Image

```tsx
import { Avatar } from '@zillow/constellation';
```

```tsx
export const AvatarWithImage = () => (
  <Avatar>
    <Avatar.Image
      alt="Rich Barton"
      src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
    />
  </Avatar>
);
```

### Avatar With Initials

```tsx
import { Avatar, Box } from '@zillow/constellation';
```

```tsx
export const AvatarWithInitials = () => (
  <Box css={{ display: 'flex', alignItems: 'center', flexWrap: 'wrap', gap: 'tighter' }}>
    <Avatar fullName="George" size="sm" />
    <Avatar fullName="George" size="lg" />
    <Avatar fullName="Abraham Lincoln" size="sm" />
    <Avatar fullName="Abraham Lincoln" size="lg" />
    <Avatar fullName="Ulysses S. Grant" size="sm" />
    <Avatar fullName="Ulysses S. Grant" size="lg" />
  </Box>
);
```

### Avatar With Polymorphic Image

```tsx
import { Avatar } from '@zillow/constellation';
```

```tsx
export const AvatarWithPolymorphicImage = () => (
  <Avatar>
    <Avatar.Image asChild>
      <picture>
        <source srcSet="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg" />
        <img
          src="https://wp.zillowstatic.com/zillowgroup/1/Rich-2-00bd1e-683x1024.jpg"
          alt="Rich Barton"
        />
      </picture>
    </Avatar.Image>
  </Avatar>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-hidden'` | `AriaAttributes['aria-hidden']` | — | Considering setting this prop to `true` if the avatar is used for presentational content only. In other words, if the avatar sits next to a heading with similar content, then there is no need for screen readers to read both he avatar label and the heading content. |
| `'aria-label'` | `AriaAttributes['aria-label']` | — | Provide an accessible label for the avatar. Use this only if you aren't already providing alt text in your Image, or if you want to provide a different value than `fullName`. |
| `'tone'` | `'default' \| 'brand-hero' \| 'accent-1' \| 'accent-2' \| 'accent-3' \| 'accent-4'` | `'default'` | Customize the color of the avatar. |
| `'children'` | `ReactNode` | — | Content |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'size'` | `'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl' \| 'xxl'` | — | The avatar size.  Supports inline media query objects. |
| `fullName` | `string` | — | The `fullName` prop is used for generating simple letter avatars and providing the `aria-label` attribute. For custom letters, pass the text as `children`. |
| `icon` | `ReactNode` | — | Add an Icon component to the avatar. Accepts `Avatar.Icon` |
| `src` | `string` | — | Image source for the avatar. |
| `alt` | `string` | — | Alt text for the avatar image. |
| `badge` | `ReactNode` | — | Add a Badge component to the avatar. Accepts `Avatar.Badge` |

### AvatarBadge

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `tone` | `'bare' \| 'hero' \| 'impact'` | `'hero'` | The tone of the badge. |
| `icon` | `ReactNode` | — | The badge icon. **(required)** |

### AvatarFullName

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Full name content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### AvatarIcon

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

### AvatarImage

**Element:** `HTMLImageElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `alt` | `string` | — | Image elements must have an alt prop, either with meaningful text, or an empty string for decorative images. |
| `asChild` | `boolean` | `false` | Use child as the Avatar.Image element |
| `css` | `SystemStyleObject` | — | Styles object |
| `src` | `string` | — | Image source |

### AvatarRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-hidden'` | `AriaAttributes['aria-hidden']` | — | Considering setting this prop to `true` if the avatar is used for presentational content only. In other words, if the avatar sits next to a heading with similar content, then there is no need for screen readers to read both he avatar label and the heading content. |
| `'aria-label'` | `AriaAttributes['aria-label']` | — | Provide an accessible label for the avatar. Use this only if you aren't already providing alt text in your Image, or if you want to provide a different value than `fullName`. |
| `'tone'` | `'default' \| 'brand-hero' \| 'accent-1' \| 'accent-2' \| 'accent-3' \| 'accent-4'` | `'default'` | Customize the color of the avatar. |
| `'children'` | `ReactNode` | — | Content |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'size'` | `'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl' \| 'xxl'` | — | The avatar size. Supports inline media query objects. |

