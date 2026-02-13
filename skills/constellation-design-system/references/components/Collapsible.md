# Collapsible

```tsx
import { Collapsible } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 4.1.0

## Usage

```tsx
import { Button, Collapsible, Paragraph } from '@zillow/constellation';
```

```tsx
export const CollapsibleBasic = () => (
  <Collapsible>
    {(collapsed, toggle) => (
      <Fragment>
        {collapsed ? null : (
          <Paragraph css={{ marginBlockEnd: 'loose' }}>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ornare lorem sit amet
            quam mattis, ac fringilla est commodo. Vestibulum rhoncus congue tempus. Vivamus cursus
            scelerisque nulla sit amet placerat. Morbi rhoncus dictum elementum. Nulla facilisi.
            Mauris porta sit amet erat a euismod. Duis lacus mauris, molestie et purus a, mollis
            ullamcorper velit. Aliquam accumsan, augue id sollicitudin posuere, magna nulla
            fermentum purus, eu pharetra odio tortor porttitor nisi. Vestibulum faucibus tellus sed
            magna sodales ultricies. Suspendisse potenti. Curabitur at eros porttitor, luctus quam
            quis, feugiat metus. Ut semper, tortor eget mattis euismod, enim mi rutrum risus, sit
            amet commodo diam metus at est. Nam vel urna nec felis mollis adipiscing non eget
            mauris. Cras auctor, nulla a iaculis interdum, arcu lorem mattis augue, eu porta diam
            ligula a dui. Morbi eu porttitor sapien. Donec fermentum justo eu ligula placerat
            lobortis.
          </Paragraph>
        )}
        <Button onClick={() => toggle()}>{collapsed ? 'Show' : 'Hide'}</Button>
      </Fragment>
    )}
  </Collapsible>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `defaultCollapsed` | `boolean` | `false` | `true` if the content should be collapsed to start with |
| `children` | `(collapsed: boolean, toggle: (collapsed?: boolean) => void) => ReactNode` | — | A render prop that receives two arguments: - `collapsed`: the current collapsed state, - `toggle`: a callback for when to toggle the collapsed state **(required)** |

