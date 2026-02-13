# VerticalNav

```tsx
import { VerticalNav } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 10.0.0

## Usage

```tsx
import { Anchor, VerticalNav } from '@zillow/constellation';
```

```tsx
export const VerticalNavBasic = () => (
  <VerticalNav.Root background outlined elevated tone="brand">
    <VerticalNav.List>
      <VerticalNav.Item current="true">
        <Anchor href="#">Good Choice 1</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 2</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 3</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 4</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item disabled>
        <Anchor href="#">Disabled Choice 5</Anchor>
      </VerticalNav.Item>
    </VerticalNav.List>
  </VerticalNav.Root>
);
```

## Examples

### Vertical Nav With Heading And Divider

```tsx
import { Anchor, VerticalNav } from '@zillow/constellation';
```

```tsx
export const VerticalNavWithHeadingAndDivider = () => (
  <VerticalNav.Root background outlined elevated tone="brand">
    <VerticalNav.Heading level={5} id="links-heading">
      Fancy Links
    </VerticalNav.Heading>
    <VerticalNav.List aria-labelledby="links-heading">
      <VerticalNav.Item current>
        <Anchor href="#">Good Choice 1</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 2</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 3</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 4</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 5</Anchor>
      </VerticalNav.Item>
    </VerticalNav.List>
    <VerticalNav.Divider />
    <VerticalNav.Heading level={5} id="more-links-heading">
      More Fancy Links
    </VerticalNav.Heading>
    <VerticalNav.List aria-labelledby="more-links-heading">
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 6</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 7</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 8</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 9</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 10</Anchor>
      </VerticalNav.Item>
    </VerticalNav.List>
  </VerticalNav.Root>
);
```

### Vertical Nav With Icons

```tsx
import { Icon, UnstyledButton, VerticalNav } from '@zillow/constellation';
```

```tsx
export const VerticalNavWithIcons = () => {
  const [active, setActive] = useState('fancy-1');
  const handleClick = useCallback((e: MouseEvent<HTMLElement>) => {
    const id = e.currentTarget.parentElement?.id;
    if (id) {
      setActive(id);
    }
  }, []);

  return (
    <VerticalNav.Root background outlined elevated tone="brand">
      <VerticalNav.List>
        <VerticalNav.Item id="fancy-1" selected={active === 'fancy-1'}>
          <UnstyledButton onClick={handleClick}>
            <Icon role="img" size="md">
              {active === 'fancy-1' ? <IconDogLargeFilled /> : <IconDogLargeOutline />}
            </Icon>{' '}
            Large Dogs
          </UnstyledButton>
        </VerticalNav.Item>
        <VerticalNav.Item id="fancy-2" selected={active === 'fancy-2'}>
          <UnstyledButton onClick={handleClick}>
            <Icon role="img" size="md">
              {active === 'fancy-2' ? <IconCatFilled /> : <IconCatOutline />}
            </Icon>{' '}
            Cats
          </UnstyledButton>
        </VerticalNav.Item>
        <VerticalNav.Item id="fancy-3" selected={active === 'fancy-3'}>
          <UnstyledButton onClick={handleClick}>
            <Icon role="img" size="md">
              {active === 'fancy-3' ? <IconDogSmallFilled /> : <IconDogSmallOutline />}
            </Icon>{' '}
            Small Dogs
          </UnstyledButton>
        </VerticalNav.Item>
      </VerticalNav.List>
    </VerticalNav.Root>
  );
};
```

### Vertical Nav With Tone

```tsx
import { Anchor, VerticalNav } from '@zillow/constellation';
```

```tsx
export const VerticalNavWithTone = () => (
  <VerticalNav.Root background outlined elevated tone="neutral">
    <VerticalNav.List>
      <VerticalNav.Item current="true">
        <Anchor href="#">Good Choice 1</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 2</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 3</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item>
        <Anchor href="#">Good Choice 4</Anchor>
      </VerticalNav.Item>
      <VerticalNav.Item disabled>
        <Anchor href="#">Disabled Choice 5</Anchor>
      </VerticalNav.Item>
    </VerticalNav.List>
  </VerticalNav.Root>
);
```

### Vertical Nav With Unstyled Buttons

```tsx
import { UnstyledButton, VerticalNav } from '@zillow/constellation';
```

```tsx
export const VerticalNavWithUnstyledButtons = () => {
  const [active, setActive] = useState('fancy-3');
  const handleClick = useCallback((e: MouseEvent<HTMLElement>) => {
    const id = e.currentTarget.parentElement?.id;
    if (id) {
      setActive(id);
    }
  }, []);

  return (
    <VerticalNav.Root background outlined elevated tone="brand">
      <VerticalNav.List>
        <VerticalNav.Item id="fancy-1" selected={active === 'fancy-1'}>
          <UnstyledButton onClick={handleClick}>Good Choice 1</UnstyledButton>
        </VerticalNav.Item>
        <VerticalNav.Item id="fancy-2" selected={active === 'fancy-2'}>
          <UnstyledButton onClick={handleClick}>Good Choice 2</UnstyledButton>
        </VerticalNav.Item>
        <VerticalNav.Item id="fancy-3" selected={active === 'fancy-3'}>
          <UnstyledButton onClick={handleClick}>Good Choice 3</UnstyledButton>
        </VerticalNav.Item>
        <VerticalNav.Item id="fancy-4" selected={active === 'fancy-4'}>
          <UnstyledButton onClick={handleClick}>Good Choice 4</UnstyledButton>
        </VerticalNav.Item>
        <VerticalNav.Item id="fancy-5" selected={active === 'fancy-5'} disabled>
          <UnstyledButton onClick={handleClick}>Disabled Choice 5</UnstyledButton>
        </VerticalNav.Item>
      </VerticalNav.List>
    </VerticalNav.Root>
  );
};
```

## API

### VerticalNavDivider

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `tone` | `never` | — | We do not want to change the tone. |
| `css` | `SystemStyleObject` | — | Styles object |
| `length` | `never` | — |  |
| `orientation` | `never` | — | We do not want to change the orientation. |
| `role` | `AriaRole` | `separator` | A [role](https://www.w3.org/TR/wai-aria-1.2/#roles) is required for assistive technologies to announce the divider properly. Divider uses the [separator](https://www.w3.org/TR/wai-aria-1.2/#separator) role. |

### VerticalNavHeading

**Element:** `HTMLHeadingElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `level` | `1 \| 2 \| 3 \| 4 \| 5 \| 6` | — | Heading level **(required)** |

### VerticalNavItem

**Element:** `HTMLLIElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `disabled` | `boolean` | `false` | If true, displays the item in its "disabled" state. |
| `selected` | `boolean` | — | If true, displays the item in its "selected" state. This should only be used if the nav item is like a tab, or the child is a button |
| `current` | `AriaAttributes['aria-current']` | — | If anything but false, displays the item in its "selected" state. |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### VerticalNavList

**Element:** `HTMLOListElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | A group of `VerticalNav.Item` components. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### VerticalNavRoot

**Element:** `HTMLElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `elevated` | `boolean` | `true` | Adds shadow to the nav |
| `outlined` | `boolean` | `true` | Adds border to the nav |
| `background` | `boolean` | `true` | If true adds a background color, false will be transparent |
| `tone` | `'brand' \| 'neutral'` | `brand` | The tone of the vertical nav |

