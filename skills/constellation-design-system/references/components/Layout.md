# Layout

```tsx
import { Layout } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 10.0.0

## Usage

```tsx
import { Layout, Page, Text } from '@zillow/constellation';
```

```tsx
export const LayoutBasic = () => (
  <Page.Root>
    <Page.Content>
      <Layout.Root template="fluid12">
        {[...Array(12).keys()].map((key) => (
          <Layout.Content key={key}>
            <Text css={{ textAlign: 'center' }}>{key + 1}</Text>
          </Layout.Content>
        ))}
      </Layout.Root>
    </Page.Content>
  </Page.Root>
);
```

## Examples

### Layout Auto

```tsx
import { Layout, Page, Text } from '@zillow/constellation';
```

```tsx
export const LayoutAuto = () => (
  <Page.Root>
    <Page.Content>
      <Layout.Root template="auto">
        {[...Array(5).keys()].map((key) => (
          <Layout.Content key={key}>
            <Text css={{ textAlign: 'center' }}>{key + 1}</Text>
          </Layout.Content>
        ))}
      </Layout.Root>
    </Page.Content>
  </Page.Root>
);
```

### Layout Complex Layout

```tsx
import { Layout, Page, Paragraph } from '@zillow/constellation';
```

```tsx
export const LayoutComplexLayout = () => (
  <Page.Root>
    <Page.Content>
      <Layout.Root template="fluid12">
        {[6, 6, 4, 4, 4, 3, 3, 3, 3].map((span, key) => (
          <Layout.Content key={key} css={{ gridColumnEnd: `span ${span}` }}>
            <Paragraph>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet
              quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus
              cursus scelerisque nulla sit amet placerat.
            </Paragraph>
          </Layout.Content>
        ))}
      </Layout.Root>
    </Page.Content>
  </Page.Root>
);
```

### Layout Fixed

```tsx
import { Layout, Page, Text } from '@zillow/constellation';
```

```tsx
export const LayoutFixed = () => (
  <Page.Root>
    <Page.Content>
      <Layout.Root template="fixed12">
        {[...Array(12).keys()].map((key) => (
          <Layout.Content key={key}>
            <Text css={{ textAlign: 'center' }}>{key + 1}</Text>
          </Layout.Content>
        ))}
      </Layout.Root>
    </Page.Content>
  </Page.Root>
);
```

### Layout Grid Layout

```tsx
import { Layout, Page, Paragraph } from '@zillow/constellation';
```

```tsx
export const LayoutGridLayout = () => (
  <Page.Root>
    <Page.Content>
      <Layout.Root template="fluid12">
        {[...Array(6).keys()].map((key) => (
          <Layout.Content
            key={key}
            css={{ gridColumnEnd: { base: 'span 12', md: 'span 6', lg: 'span 4' } }}
          >
            <Paragraph>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet
              quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus
              cursus scelerisque nulla sit amet placerat.
            </Paragraph>
          </Layout.Content>
        ))}
      </Layout.Root>
    </Page.Content>
  </Page.Root>
);
```

### Layout Left Rail Layout

```tsx
import { Layout, Page, Paragraph } from '@zillow/constellation';
```

```tsx
export const LayoutLeftRailLayout = () => (
  <Page.Root>
    <Page.Content>
      <Layout.Root template="fluid12">
        <Layout.Content
          css={{ gridColumnEnd: { base: 'span 12', lg: 'span 3' }, order: { base: 2, lg: 1 } }}
        >
          <Paragraph>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet
            quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus
            scelerisque nulla sit amet placerat.
          </Paragraph>
        </Layout.Content>
        <Layout.Content
          css={{ gridColumnEnd: { base: 'span 12', lg: 'span 9' }, order: { base: 1, lg: 2 } }}
        >
          <Paragraph>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet
            quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus
            scelerisque nulla sit amet placerat. Lorem ipsum dolor sit amet, consectetur adipiscing
            elit. Fusce ornare lorem sit amet quam mattis, ac fringilla est commodo. Vestibulum
            rhoncus congue tempus. Vivamus cursus scelerisque nulla sit amet placerat. Lorem ipsum
            dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam mattis, ac
            fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus scelerisque
            nulla sit amet placerat.
          </Paragraph>
        </Layout.Content>
      </Layout.Root>
    </Page.Content>
  </Page.Root>
);
```

### Layout Right Rail Layout

```tsx
import { Layout, Page, Paragraph } from '@zillow/constellation';
```

```tsx
export const LayoutRightRailLayout = () => (
  <Page.Root>
    <Page.Content>
      <Layout.Root template="fluid12">
        <Layout.Content css={{ gridColumnEnd: { base: 'span 12', lg: 'span 9' } }}>
          <Paragraph>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet
            quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus
            scelerisque nulla sit amet placerat. Lorem ipsum dolor sit amet, consectetur adipiscing
            elit. Fusce ornare lorem sit amet quam mattis, ac fringilla est commodo. Vestibulum
            rhoncus congue tempus. Vivamus cursus scelerisque nulla sit amet placerat. Lorem ipsum
            dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet quam mattis, ac
            fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus scelerisque
            nulla sit amet placerat.
          </Paragraph>
        </Layout.Content>
        <Layout.Content css={{ gridColumnEnd: { base: 'span 12', lg: 'span 3' } }}>
          <Paragraph>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet
            quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus
            scelerisque nulla sit amet placerat.
          </Paragraph>
        </Layout.Content>
      </Layout.Root>
    </Page.Content>
  </Page.Root>
);
```

### Layout Split Layout

```tsx
import { Layout, Page, Paragraph } from '@zillow/constellation';
```

```tsx
export const LayoutSplitLayout = () => (
  <Page.Root>
    <Page.Content>
      <Layout.Root template="fluid12">
        {[...Array(2).keys()].map((key) => (
          <Layout.Content key={key} css={{ gridColumnEnd: { base: 'span 12', md: 'span 6' } }}>
            <Paragraph>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet
              quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus
              cursus scelerisque nulla sit amet placerat.
            </Paragraph>
          </Layout.Content>
        ))}
      </Layout.Root>
    </Page.Content>
  </Page.Root>
);
```

## API

### LayoutRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| asChild | `boolean` | `false` | Use child as the root element |
| children | `ReactNode` | - | Content |
| css | `SystemStyleObject` | - | Styles object |
| template | `'fluid12' \| 'fixed12' \| 'auto'` | `'fluid12'` | A pre-defined grid template configuration |

### LayoutContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| asChild | `boolean` | `false` | Use child as the root element |
| children | `ReactNode` | - | Content |
| css | `SystemStyleObject` | - | Styles object |

