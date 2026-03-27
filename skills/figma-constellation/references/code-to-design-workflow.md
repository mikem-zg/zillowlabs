# Code → Figma (Code Connect) Workflow

Detailed scripts and workflows for linking Constellation React components to Figma design nodes.

## Overview

Code Connect creates bidirectional links between Figma design components and their code implementations. When designers inspect a component in Figma, they see the corresponding Constellation React code.

## Prerequisites

- Figma MCP server connected and authenticated
- `@zillow/constellation` installed in the project
- Access to the Figma design file (fileKey and nodeIds)

## Workflow 1: Link a single component

### Step 1: Get the Figma file info

Extract `fileKey` and `nodeId` from the Figma URL:
```
https://figma.com/design/:fileKey/:fileName?node-id=:nodeId
```

### Step 2: Check existing mappings

```javascript
const result = await mcpFigma_getCodeConnectMap({
  nodeId: "123:456",
  fileKey: "abc123",
  codeConnectLabel: "React"
});
console.log(result);
```

### Step 3: Map the component

```javascript
const result = await mcpFigma_addCodeConnectMap({
  nodeId: "123:456",
  fileKey: "abc123",
  clientLanguages: "typescript",
  clientFrameworks: "react",
  source: "@zillow/constellation",
  componentName: "Button",
  label: "React"
});
console.log(result);
```

### Standard Constellation mappings

Use these `source` and `componentName` values for common components:

| Figma component | source | componentName |
|---|---|---|
| Button | `@zillow/constellation` | `Button` |
| IconButton | `@zillow/constellation` | `IconButton` |
| Card | `@zillow/constellation` | `Card` |
| PropertyCard | `@zillow/constellation` | `PropertyCard` |
| Input | `@zillow/constellation` | `Input` |
| Select | `@zillow/constellation` | `Select` |
| Checkbox | `@zillow/constellation` | `Checkbox` |
| Radio | `@zillow/constellation` | `Radio` |
| Tabs | `@zillow/constellation` | `Tabs` |
| Modal | `@zillow/constellation` | `Modal` |
| Tag | `@zillow/constellation` | `Tag` |
| Alert | `@zillow/constellation` | `Alert` |
| Avatar | `@zillow/constellation` | `Avatar` |
| Accordion | `@zillow/constellation` | `Accordion` |
| ToggleButtonGroup | `@zillow/constellation` | `ToggleButtonGroup` |
| Switch | `@zillow/constellation` | `Switch` |
| Tooltip | `@zillow/constellation` | `Tooltip` |
| Divider | `@zillow/constellation` | `Divider` |
| ZillowLogo | `@zillow/constellation` | `ZillowLogo` |
| Icon | `@zillow/constellation-icons` | `Icon{Name}Filled` |

## Workflow 2: AI-assisted bulk mapping

### Step 1: Get suggestions

```javascript
const result = await mcpFigma_getCodeConnectSuggestions({
  nodeId: "0:1",
  fileKey: "abc123",
  clientLanguages: "typescript",
  clientFrameworks: "react"
});
console.log(JSON.stringify(result, null, 2));
```

### Step 2: Review and override with Constellation names

The AI suggestions may use generic component names. Override with Constellation equivalents:

| AI suggestion | Constellation override |
|---|---|
| `CustomButton` | `Button` from `@zillow/constellation` |
| `CardContainer` | `Card` from `@zillow/constellation` |
| `InputField` | `Input` from `@zillow/constellation` |
| `Badge` | `Tag` from `@zillow/constellation` |
| `SegmentedControl` | `ToggleButtonGroup` from `@zillow/constellation` |
| `Dialog` | `Modal` from `@zillow/constellation` |

### Step 3: Send corrected mappings

```javascript
const result = await mcpFigma_sendCodeConnectMappings({
  nodeId: "0:1",
  fileKey: "abc123",
  clientLanguages: "typescript",
  clientFrameworks: "react",
  mappings: [
    {
      nodeId: "10:20",
      source: "@zillow/constellation",
      componentName: "Button",
      label: "React"
    },
    {
      nodeId: "10:30",
      source: "@zillow/constellation",
      componentName: "Card",
      label: "React"
    }
  ]
});
console.log(result);
```

## Workflow 3: Template-based Code Connect

For components with specific required props (PropertyCard, Tabs, Modal), use template mappings:

### PropertyCard template

```javascript
const result = await mcpFigma_addCodeConnectMap({
  nodeId: "50:100",
  fileKey: "abc123",
  clientLanguages: "typescript",
  clientFrameworks: "react",
  source: "@zillow/constellation",
  componentName: "PropertyCard",
  label: "React",
  template: `<PropertyCard
  saveButton={<PropertyCard.SaveButton />}
  photoBody={<PropertyCard.Photo src={imageUrl} alt="Property photo" />}
  badge={<PropertyCard.Badge tone="accent">New</PropertyCard.Badge>}
  data={{
    dataArea1: '$price',
    dataArea2: <PropertyCard.HomeDetails data={[
      { value: beds, label: 'bd' },
      { value: baths, label: 'ba' },
      { value: sqft, label: 'sqft' }
    ]} />,
    dataArea3: 'address',
    dataArea4: 'city, state zip'
  }}
  elevated
  interactive
/>`,
  templateDataJson: JSON.stringify({
    imports: ["import { PropertyCard } from '@zillow/constellation'"]
  })
});
```

### Tabs template

```javascript
const result = await mcpFigma_addCodeConnectMap({
  nodeId: "60:200",
  fileKey: "abc123",
  clientLanguages: "typescript",
  clientFrameworks: "react",
  source: "@zillow/constellation",
  componentName: "Tabs",
  label: "React",
  template: `<Tabs.Root defaultSelected="tab1">
  <Tabs.List>
    <Tabs.Tab value="tab1">Tab 1</Tabs.Tab>
    <Tabs.Tab value="tab2">Tab 2</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="tab1">Content 1</Tabs.Panel>
  <Tabs.Panel value="tab2">Content 2</Tabs.Panel>
</Tabs.Root>`,
  templateDataJson: JSON.stringify({
    imports: ["import { Tabs } from '@zillow/constellation'"]
  })
});
```

### Modal template

```javascript
const result = await mcpFigma_addCodeConnectMap({
  nodeId: "70:300",
  fileKey: "abc123",
  clientLanguages: "typescript",
  clientFrameworks: "react",
  source: "@zillow/constellation",
  componentName: "Modal",
  label: "React",
  template: `<Modal
  size="md"
  open={isOpen}
  onOpenChange={setIsOpen}
  dividers
  header={<Heading level={1}>Title</Heading>}
  body={<Text>Content goes in body prop</Text>}
  footer={
    <ButtonGroup aria-label="actions">
      <Modal.Close><TextButton>Cancel</TextButton></Modal.Close>
      <Button emphasis="filled" tone="brand">Save</Button>
    </ButtonGroup>
  }
/>`,
  templateDataJson: JSON.stringify({
    imports: [
      "import { Modal, Heading, Text, Button, ButtonGroup, TextButton } from '@zillow/constellation'"
    ]
  })
});
```

## Workflow 4: Audit existing Code Connect mappings

### Check all mappings for a page

```javascript
const metadata = await mcpFigma_getMetadata({
  nodeId: "0:1",
  fileKey: "abc123",
  clientLanguages: "typescript",
  clientFrameworks: "react"
});

const mappings = await mcpFigma_getCodeConnectMap({
  nodeId: "0:1",
  fileKey: "abc123",
  codeConnectLabel: "React"
});

console.log("Existing mappings:", JSON.stringify(mappings, null, 2));
```

### Verify mappings point to Constellation

Check that all `source` values reference `@zillow/constellation` or `@zillow/constellation-icons`, not custom or third-party components.

## Workflow 5: Variable definitions audit

Extract Figma variables and verify they map to Constellation tokens:

```javascript
const vars = await mcpFigma_getVariableDefs({
  nodeId: "0:1",
  fileKey: "abc123",
  clientLanguages: "typescript",
  clientFrameworks: "react"
});
console.log(JSON.stringify(vars, null, 2));
```

Compare output against Constellation token table in `references/figma-to-constellation-map.md`.
