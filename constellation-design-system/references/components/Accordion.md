# Accordion

```tsx
import { Accordion } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Accordion, Heading, Paragraph } from '@zillow/constellation';
```

```tsx
export const AccordionBasic = () => (
  <Accordion.Root title="Accordion example">
    <Accordion.Item value="accordion-1">
      <Accordion.Header>
        <Heading level={5}>Heading One</Heading>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-2">
      <Accordion.Header>
        <Heading level={5}>Heading Two</Heading>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit tristique
          convallis.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
  </Accordion.Root>
);
```

## Examples

### Accordion As Child

```tsx
import { Accordion, Heading, Paragraph } from '@zillow/constellation';
```

```tsx
export const AccordionAsChild = () => (
  <Accordion.Root title="Accordion example" asChild>
    <dl>
      <Accordion.Item asChild value="accordion-1">
        <div>
          <dt>
            <Accordion.Header>
              <Heading level={5}>Heading One</Heading>
            </Accordion.Header>
          </dt>
          <dd>
            <Accordion.Panel>
              <Paragraph>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare
                laoreet. Sed condimentum pretium nibh ac dapibus.
              </Paragraph>
            </Accordion.Panel>
          </dd>
        </div>
      </Accordion.Item>
    </dl>
  </Accordion.Root>
);
```

### Accordion Controlled

```tsx
import { Accordion, Heading, Paragraph, Tag } from '@zillow/constellation';
```

```tsx
export const AccordionControlled = () => {
  const [expanded, setExpanded] = useState<string | Array<string>>('accordion-3');
  return (
    <Accordion.Root
      title="Accordion example"
      type="single"
      expanded={expanded}
      onExpandedChange={(value: string | Array<string>) => {
        setExpanded(value);
      }}
    >
      <Accordion.Item value="accordion-1">
        <Accordion.Header>
          <Heading level={6}>Heading One</Heading>
          <Tag size="sm" tone="success">
            Complete
          </Tag>
        </Accordion.Header>
        <Accordion.Panel>
          <Paragraph>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
            Sed condimentum pretium nibh ac dapibus.
          </Paragraph>
        </Accordion.Panel>
      </Accordion.Item>
      <Accordion.Item value="accordion-2">
        <Accordion.Header>
          <Heading level={6}>Heading Two</Heading>
          <Tag size="sm" tone="info">
            In Progress
          </Tag>
        </Accordion.Header>
        <Accordion.Panel>
          <Paragraph>
            Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit
            tristique convallis.
          </Paragraph>
        </Accordion.Panel>
      </Accordion.Item>
      <Accordion.Item value="accordion-3">
        <Accordion.Header>
          <Heading level={6}>Heading Three</Heading>
          <Tag size="sm" tone="gray">
            Pending
          </Tag>
        </Accordion.Header>
        <Accordion.Panel>
          <Paragraph>
            Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit
            tristique convallis.
          </Paragraph>
        </Accordion.Panel>
      </Accordion.Item>
    </Accordion.Root>
  );
};
```

### Accordion Css Prop

```tsx
import { Accordion, Heading, Paragraph } from '@zillow/constellation';
```

```tsx
export const AccordionCssProp = () => (
  <Accordion.Root title="Accordion example" css={{ gap: 'layout.vast.default' }}>
    <Accordion.Item value="accordion-1">
      <Accordion.Header>
        <Heading level={5}>Heading One</Heading>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-2">
      <Accordion.Header>
        <Heading level={5}>Heading Two</Heading>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit tristique
          convallis.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
  </Accordion.Root>
);
```

### Accordion Default Expanded

```tsx
import { Accordion, Heading, Paragraph, Tag } from '@zillow/constellation';
```

```tsx
export const AccordionDefaultExpanded = () => (
  <Accordion.Root title="Accordion example" defaultExpanded="accordion-2">
    <Accordion.Item value="accordion-1">
      <Accordion.Header>
        <Heading level={6}>Heading One</Heading>
        <Tag size="sm" tone="success">
          Complete
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-2">
      <Accordion.Header>
        <Heading level={6}>Heading Two</Heading>
        <Tag size="sm" tone="info">
          In Progress
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit tristique
          convallis.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
  </Accordion.Root>
);
```

### Accordion Disabled

```tsx
import { Accordion, Heading, Paragraph, Tag } from '@zillow/constellation';
```

```tsx
export const AccordionDisabled = () => (
  <Accordion.Root title="Accordion example" type="single">
    <Accordion.Item disabled value="accordion-1">
      <Accordion.Header>
        <Heading level={6}>Heading One</Heading>
        <Tag size="sm" tone="success">
          Complete
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-2">
      <Accordion.Header>
        <Heading level={6}>Heading Two</Heading>
        <Tag size="sm" tone="info">
          In Progress
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit tristique
          convallis.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
  </Accordion.Root>
);
```

### Accordion Heading Sizes

```tsx
import { Accordion, Heading, Paragraph, Tag, Text } from '@zillow/constellation';
```

```tsx
export const AccordionHeadingSizes = () => (
  <Accordion.Root title="Accordion example">
    <Accordion.Item value="accordion-1">
      <Accordion.Header>
        <Heading level={4}>Heading Sm</Heading>
        <Tag size="sm" tone="success">
          Complete
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-2">
      <Accordion.Header>
        <Heading level={5}>Heading XS</Heading>
        <Tag size="sm" tone="info">
          In Progress
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit tristique
          convallis.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-3">
      <Accordion.Header>
        <Heading level={6}>Heading Body Bold</Heading>
        <Tag size="sm" tone="warning">
          Warning
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-3">
      <Accordion.Header>
        <Paragraph>Heading Body</Paragraph>
        <Text textStyle="body-bold">$11,800</Text>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
  </Accordion.Root>
);
```

### Accordion Inert

```tsx
import { Accordion, Anchor, Heading, Paragraph } from '@zillow/constellation';
```

```tsx
export const AccordionInert = () => (
  <Accordion.Root title="Accordion example" type="single" defaultExpanded="accordion-1">
    <Accordion.Item value="accordion-1">
      <Accordion.Header>
        <Heading level={5}>Heading One</Heading>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          A <Anchor href="https://constellation.zillowgroup.com">design system</Anchor> is a
          complete set of standards intended to manage design at scale using reusable components and
          patterns. But, it is more than just a library of components and patterns—it is a shared
          language.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-2">
      <Accordion.Header>
        <Heading level={5}>Heading Two</Heading>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          A <Anchor href="https://constellation.zillowgroup.com">design system</Anchor> is a
          complete set of standards intended to manage design at scale using reusable components and
          patterns. But, it is more than just a library of components and patterns—it is a shared
          language.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
  </Accordion.Root>
);
```

### Accordion On Expanded Change

```tsx
import { Accordion, Heading, Paragraph, Tag } from '@zillow/constellation';
```

```tsx
export const AccordionOnExpandedChange = () => {
  return (
    <Accordion.Root
      onExpandedChange={(value: string | Array<string>) => {
        // event happens here and the value is the index of the expanded accordion item
        // oxlint-disable-next-line no-console
        console.log(value);
      }}
    >
      <Accordion.Item value="accordion-1">
        <Accordion.Header>
          <Heading level={6}>Heading One</Heading>
          <Tag size="sm" tone="success">
            Complete
          </Tag>
        </Accordion.Header>
        <Accordion.Panel>
          <Paragraph>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
            Sed condimentum pretium nibh ac dapibus.
          </Paragraph>
        </Accordion.Panel>
      </Accordion.Item>
      <Accordion.Item value="accordion-2">
        <Accordion.Header>
          <Heading level={6}>Heading Two</Heading>
          <Tag size="sm" tone="info">
            In Progress
          </Tag>
        </Accordion.Header>
        <Accordion.Panel>
          <Paragraph>
            Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit
            tristique convallis.
          </Paragraph>
        </Accordion.Panel>
      </Accordion.Item>
    </Accordion.Root>
  );
};
```

### Accordion Single Opening

```tsx
import { Accordion, Heading, Paragraph, Tag } from '@zillow/constellation';
```

```tsx
export const AccordionSingleOpening = () => (
  <Accordion.Root title="Accordion example" type="single">
    <Accordion.Item value="accordion-1">
      <Accordion.Header>
        <Heading level={6}>Heading One</Heading>
        <Tag size="sm" tone="success">
          Complete
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-2">
      <Accordion.Header>
        <Heading level={6}>Heading Two</Heading>
        <Tag size="sm" tone="info">
          In Progress
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit tristique
          convallis.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
  </Accordion.Root>
);
```

### Accordion With Decorators

```tsx
import { Accordion, Heading, Paragraph, Tag, Text } from '@zillow/constellation';
```

```tsx
export const AccordionWithDecorators = () => (
  <Accordion.Root title="Accordion example">
    <Accordion.Item value="accordion-1">
      <Accordion.Header>
        <Heading level={6}>Heading One</Heading>
        <Tag size="sm" tone="success">
          Complete
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-2">
      <Accordion.Header>
        <Heading level={6}>Heading Two</Heading>
        <Tag size="sm" tone="info">
          In Progress
        </Tag>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Suspendisse tempus porta lectus sit amet malesuada. Etiam mollis magna vel velit tristique
          convallis.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
    <Accordion.Item value="accordion-3">
      <Accordion.Header>
        <Heading level={6}>Heading Three</Heading>
        <Text textStyle="body-bold">$11,800</Text>
      </Accordion.Header>
      <Accordion.Panel>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam cursus ornare laoreet.
          Sed condimentum pretium nibh ac dapibus.
        </Paragraph>
      </Accordion.Panel>
    </Accordion.Item>
  </Accordion.Root>
);
```

## API

### AccordionHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### AccordionItem

**Element:** `HTMLLIElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | `Accordion.Item` expects `Accordion.Header` and `Accordion.Panel` elements as direct children. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Set the Accordion.Item as disabled. |
| `value` | `string` | — | A unique identifier. If this `Accordion.Item`'s `value` matches the `expanded` or `defaultExpanded` prop on `Accordion.Root`, this `Accordion.Item` will be expanded. **(required)** |

### AccordionPanel

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### AccordionRoot

**Element:** `HTMLUListElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | `Accordion.Root` expects `Accordion.Item` elements as direct children. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `defaultExpanded` | `string \| Array<string>` | — | A default value for the expanded panel's index, or indices, in an uncontrolled accordion component when it is initially rendered. |
| `expanded` | `string \| Array<string>` | — | The index, or array of indices, for expanded accordion panels. The `expanded` prop should be used along with `onChange` prop to create controlled accordion component. |
| `onExpandedChange` | `(value: string \| Array<string>) => void` | — | The callback for when accordion state has changed. This function will be passed the selected panel's `index` and the `nextState` as index or array of indices. |
| `onPanelFocus` | `(value: string) => void` | — | The callback for when accordion focus has changed. This function will be passed the focused panel's `index`. |
| `type` | `'single' \| 'multiple'` | `'multiple'` | The type of accordion behavior: - 'single': Only one panel can be expanded at a time. - 'multiple': Multiple panels can be expanded simultaneously. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |

