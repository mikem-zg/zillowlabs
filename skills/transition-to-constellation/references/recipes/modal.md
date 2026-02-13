# Migrating Modals: shadcn/MUI/Radix → Constellation

## Constellation component

```tsx
import { Modal, Heading, Button, TextButton, ButtonGroup, Text } from '@zillow/constellation';
import { Flex } from '@/styled-system/jsx';
```

---

## Before (shadcn/ui)

```tsx
import {
  Dialog, DialogContent, DialogDescription, DialogFooter,
  DialogHeader, DialogTitle, DialogTrigger
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';

<Dialog open={isOpen} onOpenChange={setIsOpen}>
  <DialogTrigger asChild>
    <Button>Open dialog</Button>
  </DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Confirm deletion</DialogTitle>
      <DialogDescription>
        This action cannot be undone. Are you sure you want to delete this item?
      </DialogDescription>
    </DialogHeader>
    <DialogFooter>
      <Button variant="outline" onClick={() => setIsOpen(false)}>Cancel</Button>
      <Button variant="destructive" onClick={handleDelete}>Delete</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

## Before (MUI)

```tsx
import Dialog from '@mui/material/Dialog';
import DialogTitle from '@mui/material/DialogTitle';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogActions from '@mui/material/DialogActions';
import Button from '@mui/material/Button';

<Dialog open={isOpen} onClose={handleClose} maxWidth="sm" fullWidth>
  <DialogTitle>Confirm deletion</DialogTitle>
  <DialogContent>
    <DialogContentText>
      This action cannot be undone. Are you sure you want to delete this item?
    </DialogContentText>
  </DialogContent>
  <DialogActions>
    <Button onClick={handleClose}>Cancel</Button>
    <Button variant="contained" color="error" onClick={handleDelete}>
      Delete
    </Button>
  </DialogActions>
</Dialog>
```

## Before (Radix Dialog)

```tsx
import * as Dialog from '@radix-ui/react-dialog';

<Dialog.Root open={isOpen} onOpenChange={setIsOpen}>
  <Dialog.Trigger asChild>
    <button>Open</button>
  </Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Overlay className="fixed inset-0 bg-black/50" />
    <Dialog.Content className="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white rounded-lg p-6 w-[400px]">
      <Dialog.Title className="text-lg font-bold">Confirm deletion</Dialog.Title>
      <Dialog.Description className="text-gray-600 mt-2">
        This action cannot be undone.
      </Dialog.Description>
      <div className="flex justify-end gap-2 mt-4">
        <Dialog.Close asChild>
          <button className="px-4 py-2 border rounded">Cancel</button>
        </Dialog.Close>
        <button className="px-4 py-2 bg-red-600 text-white rounded" onClick={handleDelete}>
          Delete
        </button>
      </div>
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

## Before (Tailwind + HTML)

```tsx
{isOpen && (
  <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
    <div className="bg-white rounded-lg p-6 w-[400px] shadow-xl">
      <h2 className="text-lg font-bold">Confirm deletion</h2>
      <p className="text-gray-600 mt-2">
        This action cannot be undone. Are you sure?
      </p>
      <div className="flex justify-end gap-2 mt-4">
        <button className="px-4 py-2 border rounded" onClick={() => setIsOpen(false)}>
          Cancel
        </button>
        <button className="px-4 py-2 bg-red-600 text-white rounded" onClick={handleDelete}>
          Delete
        </button>
      </div>
    </div>
  </div>
)}
```

---

## After (Constellation)

### ⚠️ CRITICAL: Content goes in `body` prop — NEVER as children

### Confirmation modal

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Confirm deletion</Heading>}
  body={
    <Text textStyle="body">
      This action cannot be undone. Are you sure you want to delete this item?
    </Text>
  }
  footer={
    <ButtonGroup aria-label="Confirmation actions">
      <Modal.Close>
        <TextButton>Cancel</TextButton>
      </Modal.Close>
      <Button tone="critical" emphasis="filled" size="md" onClick={handleDelete}>
        Delete
      </Button>
    </ButtonGroup>
  }
/>
```

### Form modal

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Edit profile</Heading>}
  body={
    <Flex direction="column" gap="300">
      <LabeledInput label="Full name" value={name} onChange={(e) => setName(e.target.value)} />
      <LabeledInput label="Email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
      <LabeledInput label="Phone" type="tel" value={phone} onChange={(e) => setPhone(e.target.value)} />
    </Flex>
  }
  footer={
    <ButtonGroup aria-label="Form actions">
      <Modal.Close>
        <TextButton>Cancel</TextButton>
      </Modal.Close>
      <Button tone="brand" emphasis="filled" size="md" onClick={handleSave}>
        Save changes
      </Button>
    </ButtonGroup>
  }
/>
```

### Info/alert modal

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Important notice</Heading>}
  body={
    <Flex direction="column" gap="300">
      <Text textStyle="body">
        Your listing has been updated successfully. Changes will be visible within 24 hours.
      </Text>
    </Flex>
  }
  footer={
    <ButtonGroup aria-label="Notice actions">
      <Modal.Close>
        <Button tone="brand" emphasis="filled" size="md">Got it</Button>
      </Modal.Close>
    </ButtonGroup>
  }
/>
```

---

## Required rules

- Content **MUST** go in the `body` prop — **NEVER** pass content as children
- **ALWAYS** include `dividers` for proper visual separation
- **ALWAYS** default to `size="md"`
- Footer uses `ButtonGroup` with `Modal.Close` wrapper for cancel/dismiss actions
- **NEVER** place action buttons inside the body — **ALWAYS** use `footer`
- Header uses `<Heading level={1}>` for the modal title
- Use `onOpenChange` (not `onClose`) for controlling open state

---

## Anti-patterns

```tsx
// WRONG — content as children (NOT the body prop)
<Modal open={isOpen} onOpenChange={setIsOpen}>
  <Text>This is wrong! Content must go in body prop.</Text>
</Modal>

// CORRECT — content in body prop
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  body={<Text>Content goes here in the body prop.</Text>}
/>
```

```tsx
// WRONG — missing dividers
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  header={<Heading level={1}>Title</Heading>}
  body={<Text>Content</Text>}
/>

// CORRECT — always include dividers
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Title</Heading>}
  body={<Text>Content</Text>}
/>
```

```tsx
// WRONG — action buttons inside body
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Confirm</Heading>}
  body={
    <Flex direction="column" gap="300">
      <Text>Are you sure?</Text>
      <Flex justify="flex-end" gap="200">
        <Button>Cancel</Button>
        <Button>Confirm</Button>
      </Flex>
    </Flex>
  }
/>

// CORRECT — action buttons in footer
<Modal
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Confirm</Heading>}
  body={<Text>Are you sure?</Text>}
  footer={
    <ButtonGroup aria-label="Actions">
      <Modal.Close>
        <TextButton>Cancel</TextButton>
      </Modal.Close>
      <Button tone="brand" emphasis="filled" size="md">Confirm</Button>
    </ButtonGroup>
  }
/>
```

```tsx
// WRONG — missing Modal.Close wrapper on cancel button
<Modal
  footer={
    <ButtonGroup aria-label="Actions">
      <TextButton onClick={() => setIsOpen(false)}>Cancel</TextButton>
      <Button tone="brand" emphasis="filled" size="md">Save</Button>
    </ButtonGroup>
  }
/>

// CORRECT — use Modal.Close to auto-close
<Modal
  footer={
    <ButtonGroup aria-label="Actions">
      <Modal.Close>
        <TextButton>Cancel</TextButton>
      </Modal.Close>
      <Button tone="brand" emphasis="filled" size="md">Save</Button>
    </ButtonGroup>
  }
/>
```

---

## Variants

### Modal sizes

```tsx
<Modal size="sm" ... />  {/* Small — simple confirmations */}
<Modal size="md" ... />  {/* Medium — default, always start here */}
<Modal size="lg" ... />  {/* Large — complex forms, multi-section content */}
```

### Modal with scrollable body

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Terms of service</Heading>}
  body={
    <Flex direction="column" gap="300">
      <Text textStyle="body">
        {longTermsText}
      </Text>
    </Flex>
  }
  footer={
    <ButtonGroup aria-label="Terms actions">
      <Modal.Close>
        <TextButton>Decline</TextButton>
      </Modal.Close>
      <Button tone="brand" emphasis="filled" size="md">Accept</Button>
    </ButtonGroup>
  }
/>
```

### Single-action modal (acknowledgment)

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Success</Heading>}
  body={<Text>Your changes have been saved.</Text>}
  footer={
    <ButtonGroup aria-label="Dismiss">
      <Modal.Close>
        <Button tone="brand" emphasis="filled" size="md">Done</Button>
      </Modal.Close>
    </ButtonGroup>
  }
/>
```

---

## Edge cases

### Modal with trigger button

```tsx
const [isOpen, setIsOpen] = useState(false);

<Button tone="brand" emphasis="filled" size="md" onClick={() => setIsOpen(true)}>
  Open modal
</Button>

<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Modal title</Heading>}
  body={<Text>Content here</Text>}
  footer={
    <ButtonGroup aria-label="Actions">
      <Modal.Close>
        <TextButton>Close</TextButton>
      </Modal.Close>
    </ButtonGroup>
  }
/>
```

### Modal with validation before close

```tsx
<Modal
  size="md"
  open={isOpen}
  onOpenChange={(open) => {
    if (!open && hasUnsavedChanges) {
      setShowConfirmDiscard(true);
      return;
    }
    setIsOpen(open);
  }}
  dividers
  header={<Heading level={1}>Edit listing</Heading>}
  body={<Text>Form content here</Text>}
  footer={
    <ButtonGroup aria-label="Actions">
      <Modal.Close>
        <TextButton>Cancel</TextButton>
      </Modal.Close>
      <Button tone="brand" emphasis="filled" size="md" onClick={handleSave}>
        Save
      </Button>
    </ButtonGroup>
  }
/>
```

### Nested content sections in body

```tsx
<Modal
  size="lg"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Listing details</Heading>}
  body={
    <Flex direction="column" gap="400">
      <Flex direction="column" gap="200">
        <Text textStyle="body-lg-bold">Property info</Text>
        <Text textStyle="body">3 bed, 2 bath, 1,500 sqft</Text>
      </Flex>
      <Divider />
      <Flex direction="column" gap="200">
        <Text textStyle="body-lg-bold">Pricing</Text>
        <Text textStyle="body">$450,000</Text>
      </Flex>
    </Flex>
  }
  footer={
    <ButtonGroup aria-label="Actions">
      <Modal.Close>
        <TextButton>Close</TextButton>
      </Modal.Close>
      <Button tone="brand" emphasis="filled" size="md">Contact agent</Button>
    </ButtonGroup>
  }
/>
```
