# DuoColorIcon

```tsx
import { DuoColorIcon } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 10.2.0

## Usage

```tsx
import { DuoColorIcon, Icon } from '@zillow/constellation';
```

```tsx
export const DuoColorIconBasic = () => (
  <DuoColorIcon tone="trust" onBackground="default">
    <Icon>
      <IconKeyFilled />
    </Icon>
  </DuoColorIcon>
);
```

## Examples

### Duo Color Icon Backgrounds

```tsx
import type { DuoColorIconBackgroundType, DuoColorIconToneType } from '@zillow/constellation';
```

```tsx
export const DUO_COLOR_ICON_BACKGROUNDS: Array<DuoColorIconBackgroundType> = [
  'default',
  'hero',
  'impact',
] as const;

export const DUO_COLOR_ICON_TONES: Array<DuoColorIconToneType> = [
  'trust',
  'insight',
  'inspire',
  'empower',
  'info',
  'success',
  'critical',
  'warning',
  'notify',
] as const;
```

### Duo Color Icon All Surfaces And Tones

```tsx
import { Box, DuoColorIcon, Icon, Text } from '@zillow/constellation';
```

```tsx
export const DuoColorIconAllSurfacesAndTones = () => (
  <Box css={{ display: 'grid', gap: '8px' }}>
    <Box
      css={{
        display: 'grid',
        gridTemplateColumns: 'repeat(4, 100px)',
        gap: '8px',
        justifyItems: 'center',
      }}
    >
      <div />
      {DUO_COLOR_ICON_BACKGROUNDS.map((background) => (
        <Text key={background} textStyle="body-sm">
          <code>{background}</code>
        </Text>
      ))}
    </Box>
    {DUO_COLOR_ICON_TONES.map((tone) => {
      return (
        <Box
          key={tone}
          css={{
            alignItems: 'center',
            display: 'grid',
            gridTemplateColumns: 'repeat(4, 100px)',
            gap: '8px',
            justifyItems: 'center',
          }}
        >
          <Text textStyle="body-sm" css={{ justifySelf: 'end' }}>
            <code>{tone}</code>
          </Text>
          {DUO_COLOR_ICON_BACKGROUNDS.map((background) => {
            return (
              <DuoColorIcon key={background} tone={tone} onBackground={background}>
                <Icon>
                  <IconKeyFilled />
                </Icon>
              </DuoColorIcon>
            );
          })}
        </Box>
      );
    })}
  </Box>
);
```

### Duo Color Icon Surfaces

```tsx
import { Box, DuoColorIcon, Icon, Text } from '@zillow/constellation';
```

```tsx
export const DuoColorIconSurfaces = () => (
  <Box css={{ display: 'flex', gap: '16px' }}>
    {DUO_COLOR_ICON_BACKGROUNDS.map((background) => (
      <Box key={background} css={{ display: 'grid', justifyItems: 'center', gap: '8px' }}>
        <Text textStyle="body-sm">
          <code>{background}</code>
        </Text>
        <DuoColorIcon tone="trust" onBackground={background}>
          <Icon>
            <IconKeyFilled />
          </Icon>
        </DuoColorIcon>
      </Box>
    ))}
  </Box>
);
```

### Duo Color Icon Tones

```tsx
import { Box, DuoColorIcon, Icon, Text } from '@zillow/constellation';
```

```tsx
export const DuoColorIconTones = () => (
  <Box css={{ display: 'flex', flexWrap: 'wrap', gap: '16px' }}>
    {DUO_COLOR_ICON_TONES.map((tone) => (
      <Box key={tone} css={{ display: 'grid', justifyItems: 'center', gap: '8px' }}>
        <Text textStyle="body-sm">
          <code>{tone}</code>
        </Text>
        <DuoColorIcon tone={tone} onBackground="default">
          <Icon>
            <IconKeyFilled />
          </Icon>
        </DuoColorIcon>
      </Box>
    ))}
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | The icon to display. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `onBackground` | `DuoColorIconBackgroundType` | `default` | The type of surface the icon is on. |
| `tone` | `DuoColorIconToneType` | `trust` | The tone of the icon. |

