# Box

```tsx
import { Box } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.83.0

## Usage

```tsx
import { Box } from '@zillow/constellation';
```

```tsx
export const BoxBasic = () => (
  <Box
    css={{
      backgroundColor: 'bg.soft',
      color: 'text.neutral',
      padding: 'default',
      borderRadius: 'obj.soft',
      textStyle: 'body',
    }}
  >
    This is a basic Box component with styling applied using the css prop and design tokens.
  </Box>
);
```

## Examples

### Box Flexbox Column

```tsx
import { Box } from '@zillow/constellation';
```

```tsx
export const BoxFlexboxColumn = () => (
  <Box
    css={{
      display: 'flex',
      flexDirection: 'column',
      gap: 'default',
      padding: 'default',
      backgroundColor: 'bg.soft',
      borderRadius: 'obj.soft',
      textStyle: 'body',
    }}
  >
    <Box
      css={{
        padding: 'tight',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Item 1
    </Box>
    <Box
      css={{
        padding: 'tight',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Item 2
    </Box>
    <Box
      css={{
        padding: 'tight',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Item 3
    </Box>
  </Box>
);
```

### Box Flexbox

```tsx
import { Box } from '@zillow/constellation';
```

```tsx
export const BoxFlexbox = () => (
  <Box
    css={{
      display: 'flex',
      gap: 'default',
      padding: 'default',
      backgroundColor: 'bg.soft',
      color: 'text.neutral',
      borderRadius: 'obj.soft',
    }}
  >
    <Box
      css={{
        padding: 'tight',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Item 1
    </Box>
    <Box
      css={{
        padding: 'tight',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Item 2
    </Box>
    <Box
      css={{
        padding: 'tight',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Item 3
    </Box>
  </Box>
);
```

### Box Grid Basic

```tsx
import { Box } from '@zillow/constellation';
```

```tsx
export const BoxGridBasic = () => (
  <Box
    css={{
      display: 'grid',
      gridTemplateColumns: 'repeat(3, 1fr)',
      gap: 'default',
      padding: 'default',
      color: 'text.neutral',
      backgroundColor: 'bg.soft',
      borderRadius: 'obj.soft',
    }}
  >
    <Box
      css={{
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Grid Item 1
    </Box>
    <Box
      css={{
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Grid Item 2
    </Box>
    <Box
      css={{
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Grid Item 3
    </Box>
    <Box
      css={{
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Grid Item 4
    </Box>
    <Box
      css={{
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Grid Item 5
    </Box>
    <Box
      css={{
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Grid Item 6
    </Box>
  </Box>
);
```

### Box Grid Template Areas

```tsx
import { Box } from '@zillow/constellation';
```

```tsx
export const BoxGridTemplateAreas = () => (
  <Box
    css={{
      display: 'grid',
      gridTemplateColumns: 'repeat(3, 1fr)',
      gridTemplateAreas: `
        'header header header'
        'sidebar main main'
        'footer footer footer'
      `,
      gap: 'default',
      padding: 'default',
      color: 'text.neutral',
      backgroundColor: 'bg.soft',
      borderRadius: 'obj.soft',
      textStyle: 'body',
    }}
  >
    <Box
      css={{
        gridArea: 'header',
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Header Area
    </Box>
    <Box
      css={{
        gridArea: 'sidebar',
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Sidebar Area
    </Box>
    <Box
      css={{
        gridArea: 'main',
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Main Content Area
    </Box>
    <Box
      css={{
        gridArea: 'footer',
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
      }}
    >
      Footer Area
    </Box>
  </Box>
);
```

### Box Responsive Grid

```tsx
import { Box } from '@zillow/constellation';
```

```tsx
export const BoxResponsiveGrid = () => (
  <Box
    css={{
      display: 'grid',
      gridTemplateColumns: {
        base: '1fr',
        sm: 'repeat(2, 1fr)',
        lg: 'repeat(4, 1fr)',
      },
      gap: 'default',
      padding: 'default',
      backgroundColor: 'bg.soft',
      color: 'text.neutral',
      borderRadius: 'obj.soft',
      textStyle: 'body',
    }}
  >
    {[1, 2, 3, 4].map((item) => (
      <Box
        key={item}
        css={{
          padding: 'default',
          backgroundColor: 'bg.softest',
          borderRadius: 'obj.default',
        }}
      >
        Item {item}
      </Box>
    ))}
  </Box>
);
```

### Box Responsive Layout

```tsx
import { Box } from '@zillow/constellation';
```

```tsx
export const BoxResponsiveLayout = () => (
  <Box
    css={{
      display: 'flex',
      flexDirection: { base: 'column', md: 'row' },
      gap: 'default',
      padding: 'default',
      backgroundColor: 'bg.soft',
      color: 'text.neutral',
      borderRadius: 'obj.soft',
      textStyle: 'body',
    }}
  >
    <Box
      css={{
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
        flex: 1,
      }}
    >
      Stacks vertically on mobile, horizontally on tablet+
    </Box>
    <Box
      css={{
        padding: 'default',
        backgroundColor: 'bg.softest',
        borderRadius: 'obj.default',
        flex: 1,
      }}
    >
      Responsive content
    </Box>
  </Box>
);
```

### Box Responsive Padding

```tsx
import { Box } from '@zillow/constellation';
```

```tsx
export const BoxResponsivePadding = () => (
  <Box
    css={{
      padding: {
        base: 'tight',
        md: 'default',
        lg: 'loose',
      },
      backgroundColor: 'bg.soft',
      color: 'text.neutral',
      borderRadius: 'obj.soft',
      textStyle: 'body',
    }}
  >
    Padding increases with screen size: tight → default → loose
  </Box>
);
```

### Box Semantic Section

```tsx
import { Box, Paragraph } from '@zillow/constellation';
```

```tsx
export const BoxSemanticSection = () => (
  <Box asChild css={{ padding: 'layout.default', backgroundColor: 'bg.soft' }}>
    <section>
      <Paragraph>This section uses semantic HTML with the asChild prop.</Paragraph>
    </section>
  </Box>
);
```

### Box With As Child

```tsx
import { Box, Paragraph } from '@zillow/constellation';
```

```tsx
export const BoxWithAsChild = () => (
  <Box
    asChild
    css={{
      padding: 'layout.default',
      backgroundColor: 'bg.soft',
    }}
  >
    <section>
      <Paragraph>
        This section uses semantic HTML with the asChild prop. The outer Box renders as a{' '}
        <code>&lt;section&gt;</code> element while maintaining all styling capabilities.
      </Paragraph>
    </section>
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

