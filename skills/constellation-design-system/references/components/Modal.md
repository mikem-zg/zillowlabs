# Modal

```tsx
import { Modal } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 5.0.0

## Usage

```tsx
import { Button, ButtonGroup, Heading, Modal, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const ModalBasic = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    header={<Heading level={1}>Modal heading</Heading>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
    footer={
      <ButtonGroup aria-label="modal actions">
        <Modal.Close>
          <TextButton>Close</TextButton>
        </Modal.Close>
        <Button tone="brand" emphasis="filled">
          Action
        </Button>
      </ButtonGroup>
    }
  />
);
```

## Examples

### Modal As Form

```tsx
import {
  Button,
  ButtonGroup,
  Divider,
  Form,
  FormField,
  Heading,
  Input,
  Label,
  Modal,
  TextButton,
} from '@zillow/constellation';
```

```tsx
export const ModalAsForm = () => (
  <Modal.Root>
    <Modal.Trigger>
      <Button>Open modal</Button>
    </Modal.Trigger>
    <Modal.Portal>
      <Modal.Backdrop>
        <Modal.Content asChild>
          <Form
            onSubmit={(event) => {
              event.preventDefault();
              alert('Form submitted!');
            }}
          >
            <Modal.Header>
              <Heading level={4}>Modal heading</Heading>
            </Modal.Header>
            <Divider />
            <Modal.Body>
              <FormField
                label={<Label>Email</Label>}
                control={<Input type="email" placeholder="Enter email" />}
              />
              <FormField
                label={<Label>Password</Label>}
                control={<Input type="password" placeholder="Enter password" />}
              />
            </Modal.Body>
            <Divider />
            <Modal.Footer>
              <ButtonGroup aria-label="modal actions">
                <Modal.Close>
                  <TextButton>Close</TextButton>
                </Modal.Close>
                <Button type="submit" tone="brand" emphasis="filled">
                  Sign In
                </Button>
              </ButtonGroup>
            </Modal.Footer>
            <Modal.CloseButton />
          </Form>
        </Modal.Content>
      </Modal.Backdrop>
    </Modal.Portal>
  </Modal.Root>
);
```

### Modal Body Only

```tsx
import { Button, Modal, Paragraph } from '@zillow/constellation';
```

```tsx
export const ModalBodyOnly = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
  />
);
```

### Modal Composable

```tsx
import {
  Button,
  ButtonGroup,
  Divider,
  Heading,
  Modal,
  Paragraph,
  TextButton,
} from '@zillow/constellation';
```

```tsx
export const ModalComposable = () => (
  <Modal.Root>
    <Modal.Trigger>
      <Button>Open modal</Button>
    </Modal.Trigger>
    <Modal.Portal>
      <Modal.Backdrop>
        <Modal.Content>
          <Modal.Header>
            <Heading level={4}>Modal heading</Heading>
          </Modal.Header>
          <Divider />
          <Modal.Body>
            <Paragraph>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
              porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam
              dolor massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper
              vitae blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue vehicula.
              Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
              Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
            </Paragraph>
          </Modal.Body>
          <Divider />
          <Modal.Footer>
            <ButtonGroup aria-label="modal actions">
              <Modal.Close>
                <TextButton>Close</TextButton>
              </Modal.Close>
              <Button tone="brand" emphasis="filled">
                Action
              </Button>
            </ButtonGroup>
          </Modal.Footer>
          <Modal.CloseButton />
        </Modal.Content>
      </Modal.Backdrop>
    </Modal.Portal>
  </Modal.Root>
);
```

### Modal Controlled Composable

```tsx
import {
  Button,
  ButtonGroup,
  Divider,
  Heading,
  Modal,
  Paragraph,
  TextButton,
} from '@zillow/constellation';
```

```tsx
export const ModalControlledComposable = () => {
  const [open, onOpenChange] = useState<boolean>(false);
  const handler: UseFloatingOptions['onOpenChange'] = (open) => {
    onOpenChange(open);
  };
  return (
    <Modal.Root open={open} onOpenChange={handler}>
      <Modal.Trigger>
        <Button>Open modal</Button>
      </Modal.Trigger>
      <Modal.Portal>
        <Modal.Backdrop>
          <Modal.Content>
            <Modal.Header>
              <Heading level={4}>Modal heading</Heading>
            </Modal.Header>
            <Divider />
            <Modal.Body>
              <Paragraph>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
                porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam
                dolor massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper
                vitae blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue
                vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
                malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo
                sollicitudin.
              </Paragraph>
            </Modal.Body>
            <Divider />
            <Modal.Footer>
              <ButtonGroup aria-label="modal actions">
                <Modal.Close>
                  <TextButton>Close</TextButton>
                </Modal.Close>
                <Button tone="brand" emphasis="filled">
                  Action
                </Button>
              </ButtonGroup>
            </Modal.Footer>
            <Modal.CloseButton />
          </Modal.Content>
        </Modal.Backdrop>
      </Modal.Portal>
    </Modal.Root>
  );
};
```

### Modal Controlled Shorthand

```tsx
import { Button, ButtonGroup, Heading, Modal, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const ModalControlledShorthand = () => {
  const [open, onOpenChange] = useState<boolean>(false);
  const handler: UseFloatingOptions['onOpenChange'] = (open) => {
    onOpenChange(open);
  };
  return (
    <Modal
      trigger={<Button>Open modal</Button>}
      open={open}
      onOpenChange={handler}
      header={<Heading level={5}>Modal heading</Heading>}
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor
          massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae
          blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue vehicula.
          Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
          Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
        </Paragraph>
      }
      footer={
        <ButtonGroup aria-label="modal actions">
          <Modal.Close>
            <TextButton>Close</TextButton>
          </Modal.Close>
          <Button tone="brand" emphasis="filled">
            Action
          </Button>
        </ButtonGroup>
      }
    />
  );
};
```

### Modal Dismiss On Close Only

```tsx
import { Button, ButtonGroup, Heading, Modal, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const ModalDismissOnCloseOnly = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    header={<Heading level={1}>Modal heading</Heading>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
    footer={
      <ButtonGroup aria-label="modal actions">
        <Modal.Close>
          <TextButton>Close</TextButton>
        </Modal.Close>
        <Button tone="brand" emphasis="filled">
          Action
        </Button>
      </ButtonGroup>
    }
    useDismissProps={{
      escapeKey: false,
      outsidePress: false,
    }}
  />
);
```

### Modal Merge Close On Click

```tsx
import { Button, ButtonGroup, Heading, Modal, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const ModalMergeCloseOnClick = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    header={<Heading level={1}>Modal heading</Heading>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
    footer={
      <ButtonGroup aria-label="modal actions">
        <Modal.Close>
          <TextButton onClick={() => alert('Closing')}>Close</TextButton>
        </Modal.Close>
        <Button tone="brand" emphasis="filled">
          Action
        </Button>
      </ButtonGroup>
    }
    useDismissProps={{
      escapeKey: false,
      outsidePress: false,
    }}
  />
);
```

### Modal Multi Trigger Modal

```tsx
import {
  Box,
  Button,
  DatePicker,
  DropdownSelect,
  Heading,
  Modal,
  ModalTrigger,
  Paragraph,
} from '@zillow/constellation';
```

```tsx
export const ModalMultiTriggerModal = () => (
  <Box css={{ display: 'flex', gap: 'default' }}>
    <ModalTrigger multiModalTriggerId="modal-1">
      <Button>Open modal one</Button>
    </ModalTrigger>

    <ModalTrigger multiModalTriggerId="modal-2">
      <Button>Open modal two</Button>
    </ModalTrigger>

    <Modal
      size="lg"
      trigger={null}
      multiModalTriggerId="modal-1"
      header={<Heading level={5}>Modal one</Heading>}
      body={
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor
          massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae
          blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue vehicula.
          Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
          Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
        </Paragraph>
      }
      footer={
        <ModalTrigger multiModalTriggerId="modal-2">
          <Button tone="brand" emphasis="filled">
            Open modal two
          </Button>
        </ModalTrigger>
      }
    />

    <Modal
      size="sm"
      trigger={null}
      multiModalTriggerId="modal-2"
      header={<Heading level={5}>Modal two</Heading>}
      body={
        <Box css={{ display: 'grid', gap: 'default' }}>
          <Paragraph>Modal 2 text</Paragraph>
          <DatePicker
            dateFormat="MM/dd/yyyy"
            // oxlint-disable-next-line no-console
            onValueChange={(value) => console.log(value)}
            size="md"
          />
          <DropdownSelect
            defaultValue="Michigan"
            fluidDropdown
            options={[
              'Alabama',
              'Alaska',
              'Arizona',
              'Arkansas',
              'California',
              'Colorado',
              'Connecticut',
              'Delaware',
              'Florida',
            ]}
          />
        </Box>
      }
    />
  </Box>
);
```

### Modal No Footer

```tsx
import { Button, Heading, Modal, Paragraph } from '@zillow/constellation';
```

```tsx
export const ModalNoFooter = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    header={<Heading level={5}>Modal heading</Heading>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
  />
);
```

### Modal No Heading

```tsx
import { Button, ButtonGroup, Modal, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const ModalNoHeading = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
    footer={
      <ButtonGroup aria-label="modal actions">
        <Modal.Close>
          <TextButton>Close</TextButton>
        </Modal.Close>
        <Button tone="brand" emphasis="filled">
          Action
        </Button>
      </ButtonGroup>
    }
  />
);
```

### Modal Overscroll Body

```tsx
import { Button, ButtonGroup, Heading, Modal, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const ModalOverscrollBody = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    header={<Heading level={5}>Modal heading</Heading>}
    body={
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
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et
        aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna.
        Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada
        lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
        malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
    footer={
      <ButtonGroup aria-label="modal actions">
        <Modal.Close>
          <TextButton>Close</TextButton>
        </Modal.Close>
        <Button tone="brand" emphasis="filled">
          Action
        </Button>
      </ButtonGroup>
    }
  />
);
```

### Modal Overscroll Document

```tsx
import { Button, ButtonGroup, Heading, Modal, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const ModalOverscrollDocument = () => (
  <Modal
    scrollDocument
    trigger={<Button>Open modal</Button>}
    header={<Heading level={5}>Modal heading</Heading>}
    body={
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
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et
        aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna.
        Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada
        lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
        malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
    footer={
      <ButtonGroup aria-label="modal actions">
        <Modal.Close>
          <TextButton>Close</TextButton>
        </Modal.Close>
        <Button tone="brand" emphasis="filled">
          Action
        </Button>
      </ButtonGroup>
    }
  />
);
```

### Modal Responsive

```tsx
import { Button, ButtonGroup, Heading, Modal, Paragraph, TextButton } from '@zillow/constellation';
```

```tsx
export const ModalResponsive = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    header={<Heading level={5}>Modal heading</Heading>}
    body={
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
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Quisque blandit, nisi vel porttitor efficitur, sapien mi eleifend magna, et
        aliquam nunc arcu at sapien. Etiam dolor massa, ornare quis sodales vel, aliquet sed magna.
        Donec dui quam, ullamcorper vitae blandit vel, elementum nec libero. Maecenas malesuada
        lorem nec congue vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
        malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
    footer={
      <ButtonGroup aria-label="modal actions">
        <Modal.Close>
          <TextButton>Close</TextButton>
        </Modal.Close>
        <Button tone="brand" emphasis="filled">
          Action
        </Button>
      </ButtonGroup>
    }
    size={{
      base: 'fullScreen',
      lg: 'md',
    }}
  />
);
```

### Modal With Nested Floating Components

```tsx
import {
  Box,
  Button,
  ButtonGroup,
  Combobox,
  DatePicker,
  Divider,
  Dropdown,
  Heading,
  Menu,
  Modal,
  Paragraph,
  Popover,
  TextButton,
  Tooltip,
} from '@zillow/constellation';
```

```tsx
export const ModalWithNestedFloatingComponents = () => (
  <Modal
    size="md"
    trigger={<Button>Open modal</Button>}
    header={<Heading level={1}>Modal heading</Heading>}
    body={
      <Box css={{ display: 'flex', flexDirection: 'column', gap: 'default' }}>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor
          massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae
          blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue vehicula.
          Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
          Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
        </Paragraph>

        <Divider />

        <Heading level={5}>Combobox</Heading>
        <Combobox options={['One', 'Two', 'three']} />

        <Divider />

        <Heading level={5}>DatePicker</Heading>
        <DatePicker />

        <Divider />

        <Heading level={5}>Menu</Heading>
        <Menu>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
          <Menu.Item>
            <Menu.ItemLabel>Action item</Menu.ItemLabel>
          </Menu.Item>
        </Menu>

        <Divider />

        <Heading level={5}>Dropdown</Heading>
        <Dropdown css={{ maxWidth: '320px', padding: 'default' }}>
          <Paragraph>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
            porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam
            dolor massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper
            vitae blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue vehicula.
            Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
            Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
          </Paragraph>
        </Dropdown>

        <Divider />

        <Heading level={5}>Popover</Heading>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor
          massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae
          blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue vehicula.
          Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
          Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
          <Popover
            header={<Heading level={4}>Popover heading</Heading>}
            body={
              <Paragraph>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
                porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam
                dolor massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper
                vitae blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue
                vehicula. Suspendisse in scelerisque augue. Nullam consectetur elit non sem
                malesuada gravida. Nullam maximus ex a augue elementum, ac ultricies leo
                sollicitudin.
              </Paragraph>
            }
          />
        </Paragraph>

        <Divider />

        <Heading level={5}>Tooltip</Heading>
        <Paragraph>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel
          porttitor efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor
          massa, ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae
          blandit vel, elementum nec libero. Maecenas malesuada lorem nec congue vehicula.
          Suspendisse in scelerisque augue. Nullam consectetur elit non sem malesuada gravida.
          Nullam maximus ex a augue elementum, ac ultricies leo sollicitudin.
          <Tooltip>Lorem ipsum dolor sit amet, consectetur adipiscing elit</Tooltip>
        </Paragraph>
      </Box>
    }
    footer={
      <ButtonGroup aria-label="modal actions">
        <Modal.Close>
          <TextButton>Close</TextButton>
        </Modal.Close>
        <Button tone="brand" emphasis="filled">
          Action
        </Button>
      </ButtonGroup>
    }
  />
);
```

### Modal With Nested Modal

```tsx
import {
  Box,
  Button,
  DatePicker,
  DropdownSelect,
  Heading,
  Modal,
  Paragraph,
} from '@zillow/constellation';
```

```tsx
export const ModalWithNestedModal = () => (
  <Modal
    trigger={<Button>Open modal</Button>}
    header={<Heading level={1}>Modal heading</Heading>}
    body={
      <Paragraph>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque blandit, nisi vel porttitor
        efficitur, sapien mi eleifend magna, et aliquam nunc arcu at sapien. Etiam dolor massa,
        ornare quis sodales vel, aliquet sed magna. Donec dui quam, ullamcorper vitae blandit vel,
        elementum nec libero. Maecenas malesuada lorem nec congue vehicula. Suspendisse in
        scelerisque augue. Nullam consectetur elit non sem malesuada gravida. Nullam maximus ex a
        augue elementum, ac ultricies leo sollicitudin.
      </Paragraph>
    }
    footer={
      <Modal
        trigger={
          <Button tone="brand" emphasis="filled">
            Open nested modal
          </Button>
        }
        header={<Heading level={2}>Nested modal heading</Heading>}
        body={
          <Box css={{ display: 'grid', gap: 'default' }}>
            <Paragraph>Modal 2 text</Paragraph>
            <DatePicker
              dateFormat="MM/dd/yyyy"
              // oxlint-disable-next-line no-console
              onValueChange={(value) => console.log(value)}
              size="md"
            />
            <DropdownSelect
              defaultValue="Michigan"
              fluidDropdown
              options={[
                'Alabama',
                'Alaska',
                'Arizona',
                'Arkansas',
                'California',
                'Colorado',
                'Connecticut',
                'Delaware',
                'Florida',
              ]}
            />
          </Box>
        }
      />
    }
  />
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `multiModalTriggerId` | `string` | — | Unique ID that connects modal component with multiple modal triggers. |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `scrollDocument` | `boolean` | `false` | By default, when there is overflow content in the dialog body, the body will scroll within the dialog bounds. Optionally, you can disable scrolling on the dialog body and instead have the entire dialog scroll within the document bounds. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `size` | `ResponsiveVariant<'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl' \| 'fullScreen'>` | `xs` | The size of a modal dialog. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |
| `body` | `ReactNode` | — | Custom content to be used within Modal.Body |
| `className` | `ModalContentPropsInterface['className']` | — | Class names passed to Modal.Content |
| `css` | `SystemStyleObject` | — | Styles object passed to Modal.Content |
| `closeButton` | `ReactNode` | — | Custom content to be used within Modal.CloseButton |
| `dividers` | `boolean` | `true` | Display divider lines between header, body, and footer sections. |
| `footer` | `ReactNode` | — | Custom content to be used within Modal.Footer |
| `header` | `ReactNode` | — | Custom content to be used within Modal.Header |
| `style` | `ModalContentPropsInterface['style']` | — | Style passed to Modal.Content |
| `trigger` | `ReactNode` | — | Custom trigger to be used as Modal.Trigger |
| `portalId` | `FloatingPortalProps['id']` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified root (by default document.body). Passed to Modal.Portal. |
| `portalRoot` | `FloatingPortalProps['root']` | — | Specifies the root node the portal container will be appended to. Passed to Modal.Portal. |
| `portalPreserveTabOrder` | `FloatingPortalProps['preserveTabOrder']` | `true` | When using non-modal focus management, this will preserve the tab order context based on the React tree instead of the DOM tree. Passed to Modal.Portal. |

### ModalBackdrop

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `lockScroll` | `boolean` | `false` | Whether the overlay should lock scrolling on the document body. |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ModalBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ModalClose

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### ModalCloseButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `<CloseButton />` | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### ModalContent

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `focusManagerProps` | `FloatingFocusManagerProps` | `{}` | Floating UI's `FloatingFocusManager` props. See https://floating-ui.com/docs/FloatingFocusManager |

### ModalFooter

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ModalHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### ModalPortal

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `id` | `string` | — | Optionally selects the node with the id if it exists, or create it and append it to the specified `root` (by default `document.body`). |
| `root` | `HTMLElement \| ShadowRoot \| null \| React.MutableRefObject<HTMLElement \| ShadowRoot \| null>` | — | Specifies the root node the portal container will be appended to. |
| `preserveTabOrder` | `boolean` | — | When using non-modal focus management using `FloatingFocusManager`, this will preserve the tab order context based on the React tree instead of the DOM tree. |
| `css` | `SystemStyleObject` | — | Styles object |

### ModalRoot

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `rootContext` | `FloatingRootContext<RT>` | — |  |
| `elements` | `{         /**          * Externally passed reference element. Store in state.          */         reference?: Element \| null;         /**          * Externally passed floating element. Store in state.          */         floating?: HTMLElement \| null;     }` | — | Object of external elements as an alternative to the `refs` object setters. |
| `nodeId` | `string` | — | Unique node id when using `FloatingTree`. |
| `children` | `ReactNode` | — | Content |
| `defaultOpen` | `boolean` | — | Uncontrolled default state |
| `multiModalTriggerId` | `string` | — | Unique ID that connects modal component with multiple modal triggers. |
| `onOpenChange` | `UseFloatingOptions['onOpenChange']` | — | Controlled event. Receives `open` state, `event` object, and `reason` for state change. |
| `open` | `UseFloatingOptions['open']` | `false` | Controlled state |
| `scrollDocument` | `boolean` | `false` | By default, when there is overflow content in the dialog body, the body will scroll within the dialog bounds. Optionally, you can disable scrolling on the dialog body and instead have the entire dialog scroll within the document bounds. |
| `shouldAwaitInteractionResponse` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `size` | `ResponsiveVariant<'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl' \| 'fullScreen'>` | `xs` | The size of a modal dialog. |
| `useClickProps` | `UseClickProps` | — | Floating UI's `useClick` props. See https://floating-ui.com/docs/useClick |
| `useDismissProps` | `UseDismissProps` | — | Floating UI's `useDismiss` props. See https://floating-ui.com/docs/useDimiss |
| `useRoleProps` | `UseRoleProps` | — | Floating UI's `useRole` props. See https://floating-ui.com/docs/useRole |

### ModalTrigger

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `multiModalTriggerId` | `string` | — | Unique ID that connects multiple modal triggers with single modal component. |

