# Constellation Rebuild Recipes

This document provides Constellation-native patterns for rebuilding common feature types from scratch. Unlike migration recipes (which show before/after conversions), these recipes show the *correct Constellation implementation* from the ground up.

## Recipe Index

| Recipe | Feature Type |
|--------|-------------|
| [App Shell](#app-shell) | Header, navigation, layout, logo |
| [Content Grid](#content-grid) | Card grids for browsing items |
| [Detail Page](#detail-page) | Full-page item detail with tabs |
| [Modal Preview](#modal-preview) | Quick-view modal with actions |
| [Search](#search) | Global search with Combobox |
| [Category Filters](#category-filters) | FilterChip-based filtering |
| [Submission Form](#submission-form) | Multi-field form in a modal |
| [Reports Dashboard](#reports-dashboard) | Stats cards, leaderboard, timeline |
| [Auth Integration](#auth-integration) | Sign-in/out with user menu |
| [Theme Support](#theme-support) | Light/dark/system mode switching |
| [Illustrations](#illustrations) | Empty states, hero sections, onboarding |
| [Shared Patterns](#shared-patterns) | Code blocks, tags, markdown, timestamps |

---

## App Shell

The app shell is the foundation. Build it first.

```tsx
import { Page, ZillowLogo, IconButton, Icon, Menu, TextButton } from "@zillow/constellation";
import { IconSettingsFilled, IconTrendingFilled } from "@zillow/constellation-icons";
import { Flex } from "@/styled-system/jsx";

function AppHeader() {
  return (
    <Page.Header
      css={{
        bg: "bg.screen.neutral",
        position: "sticky",
        top: 0,
        zIndex: 100,
        marginBlockStart: 0,
        marginBlockEnd: 0,
      }}
    >
      <Flex
        align="center"
        justify="space-between"
        css={{ px: "400", py: "300", maxWidth: "1200px", mx: "auto", width: "100%" }}
      >
        <ZillowLogo css={{ height: "24px", width: "auto" }} />
        {/* Global search goes here */}
        <Flex align="center" gap="300">
          {/* Navigation icons, theme menu, user menu */}
        </Flex>
      </Flex>
    </Page.Header>
  );
}

function App() {
  return (
    <Page.Root>
      <AppHeader />
      <Page.Content css={{ bg: "bg.screen.neutral", minHeight: "100vh" }}>
        <Router />
      </Page.Content>
    </Page.Root>
  );
}
```

**Key rules:**
- ALWAYS use `Page.Header` — never `Box` or `Flex` as a header
- ALWAYS use `bg.screen.neutral` for backgrounds — never light blue
- Logo: 24px desktop, 16px mobile
- Sticky header with solid background — never transparent

---

## Content Grid

For displaying browsable items (skills, MCPs, products, articles).

```tsx
import { Card, Text, Tag, Icon, Divider } from "@zillow/constellation";
import { IconArrowRightFilled } from "@zillow/constellation-icons";
import { Flex, Grid } from "@/styled-system/jsx";

function ItemCard({ item, onClick }: { item: ItemSummary; onClick: () => void }) {
  return (
    <Card elevated interactive tone="neutral" onClick={onClick}>
      <Flex direction="column" gap="300" css={{ p: "400" }}>
        <Flex align="center" justify="space-between">
          <Tag size="sm" tone={getCategoryTone(item.category)} css={{ whiteSpace: "nowrap", width: "fit-content" }}>
            {formatCategoryLabel(item.category)}
          </Tag>
          <Icon size="sm" css={{ color: "icon.subtle" }}>
            <IconArrowRightFilled />
          </Icon>
        </Flex>
        <Text textStyle="body-bold">{item.name}</Text>
        <Text
          textStyle="body-sm"
          css={{ color: "text.subtle", overflow: "hidden" }}
          style={{ display: "-webkit-box", WebkitLineClamp: 3, WebkitBoxOrient: "vertical" }}
        >
          {item.description}
        </Text>
        <Divider />
        <Flex align="center" gap="300">
          {/* Metadata: file count, feature count, author, etc. */}
        </Flex>
      </Flex>
    </Card>
  );
}

function ItemGrid({ items, onItemClick }: Props) {
  return (
    <Grid columns={{ base: 1, md: 2, lg: 3 }} gap="400">
      {items.map((item) => (
        <ItemCard key={item.id} item={item} onClick={() => onItemClick(item.id)} />
      ))}
    </Grid>
  );
}
```

**Key rules:**
- Clickable cards: `elevated interactive tone="neutral"` — always together
- Static/display cards: `outlined elevated={false} tone="neutral"`
- NEVER combine `elevated` and `outlined` on the same card
- Card internal padding: `p="400"` (16px)
- Grid gaps: `gap="400"` (16px)
- Section gaps: `gap="800"` (32px)

---

## Detail Page

Full-page view of a single item with tabbed content.

```tsx
import { Heading, Text, Tag, Tabs, Divider, Button, Card, TextButton } from "@zillow/constellation";
import { IconArrowLeftFilled, IconDownloadFilled } from "@zillow/constellation-icons";
import { Flex, Box } from "@/styled-system/jsx";

function DetailPage({ item }: { item: ItemDetail }) {
  return (
    <Flex direction="column" gap="600" css={{ px: "400", py: "600", maxWidth: "1000px", mx: "auto", width: "100%" }}>
      {/* Back navigation */}
      <TextButton
        size="md"
        onClick={() => navigate("/")}
        icon={<IconArrowLeftFilled />}
        iconPosition="start"
      >
        Back to library
      </TextButton>

      {/* Title area */}
      <Flex direction="column" gap="300">
        <Flex align="center" gap="300">
          <Tag size="sm" tone="blue" css={{ whiteSpace: "nowrap", width: "fit-content" }}>
            {item.category}
          </Tag>
        </Flex>
        <Heading level={1} textStyle="heading-lg">{item.name}</Heading>
        <Text textStyle="body" css={{ color: "text.subtle" }}>{item.description}</Text>
      </Flex>

      {/* Action buttons */}
      <Flex gap="300">
        <Button tone="brand" emphasis="filled" size="md" icon={<IconDownloadFilled />} iconPosition="start">
          Download
        </Button>
      </Flex>

      <Divider />

      {/* Tabbed content */}
      <Tabs.Root defaultSelected="instructions">
        <Tabs.List>
          <Tabs.Tab value="instructions">Instructions</Tabs.Tab>
          <Tabs.Tab value="files">Files ({item.files.length})</Tabs.Tab>
        </Tabs.List>
        <Tabs.Panel value="instructions">
          <Box css={{ pt: "400" }}>
            <MarkdownContent content={item.mainContent} />
          </Box>
        </Tabs.Panel>
        <Tabs.Panel value="files">
          <Flex direction="column" gap="400" css={{ pt: "400" }}>
            {item.files.map((file) => (
              <CodeBlock key={file.path} content={file.content} filename={file.path} />
            ))}
          </Flex>
        </Tabs.Panel>
      </Tabs.Root>
    </Flex>
  );
}
```

**Key rules:**
- Only 1-2 `Heading` components per screen — use `Text textStyle="body-lg-bold"` for section titles
- Tabs ALWAYS need `defaultSelected` prop — never omit it
- Use `TextButton` for back navigation — not a styled anchor
- Max width 1000px for detail pages, 1200px for grids

---

## Modal Preview

Quick-view modal that loads item details without navigating away.

```tsx
import { Modal, Heading, Divider, Spinner, Button, ButtonGroup, TextButton } from "@zillow/constellation";
import { Flex } from "@/styled-system/jsx";

function ItemPreviewModal({ itemId, open, onOpenChange }: ModalProps) {
  const [item, setItem] = useState(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!itemId || !open) return;
    setLoading(true);
    api.getItem(itemId).then(setItem).finally(() => setLoading(false));
  }, [itemId, open]);

  return (
    <Modal
      size="md"
      open={open}
      onOpenChange={onOpenChange}
      dividers
      header={<Heading level={1}>{loading ? "Loading..." : item?.name ?? "Not found"}</Heading>}
      body={
        loading ? (
          <Flex align="center" justify="center" css={{ py: "800" }}>
            <Spinner size="lg" />
          </Flex>
        ) : item ? (
          <Flex direction="column" gap="400">
            {/* Full content here */}
          </Flex>
        ) : (
          <Text textStyle="body-lg-bold">Not found</Text>
        )
      }
      footer={
        <Flex align="center" justify="space-between" css={{ width: "100%" }}>
          <ButtonGroup aria-label="modal actions">
            <Modal.Close>
              <TextButton>Close</TextButton>
            </Modal.Close>
          </ButtonGroup>
          <Button tone="brand" emphasis="outlined" size="md" onClick={() => navigateToFullPage()}>
            View full page
          </Button>
        </Flex>
      }
    />
  );
}
```

**Key rules:**
- ALWAYS use `header`, `body`, and `footer` props — NEVER pass content as children
- ALWAYS include `dividers` prop for visual separation between header/body/footer
- Default to `size="md"` — adjust only if content requires more space
- NEVER place action buttons inside `body` — ALWAYS use `footer`
- Use `ButtonGroup` with `Modal.Close` wrapper in `footer`

**Note:** The actual app uses a compound `Modal.Root > Modal.Portal > Modal.Backdrop > Modal.Content` pattern for advanced responsive sizing (`size={{ base: "fullScreen", md: "lg" }}`). For standard modals, the prop-based `<Modal />` pattern above is preferred and simpler.

---

## Search

Global search using Constellation Combobox.

```tsx
import { Combobox, Icon, Tag } from "@zillow/constellation";
import { IconSearchFilled } from "@zillow/constellation-icons";

function GlobalSearch() {
  const [value, setValue] = useState(undefined);

  const optionFilter = useCallback((inputValue: string, optionText: string) => {
    const q = inputValue.toLowerCase();
    return optionText.toLowerCase().includes(q);
  }, []);

  return (
    <Combobox
      options={options}
      value={value}
      onChange={handleChange}
      optionFilter={optionFilter}
      placeholder="Search..."
      aria-label="Search"
      appearance="input"
      autoCompleteBehavior="manual"
      focusFirstOption
      showLabelForValue
      renderAdornment={(props) => (
        <Combobox.Adornment {...props}>
          <Icon size="sm" css={{ color: "icon.subtle" }}><IconSearchFilled /></Icon>
        </Combobox.Adornment>
      )}
      renderOptionMeta={(props) => {
        const { children, ...rest } = props;
        return (
          <Combobox.OptionMeta {...rest}>
            <Tag size="sm" tone="blue" css={{ whiteSpace: "nowrap" }}>{children}</Tag>
          </Combobox.OptionMeta>
        );
      }}
      renderEmptyState={(props) => (
        <Combobox.EmptyState {...props}>No results found</Combobox.EmptyState>
      )}
    />
  );
}
```

**Key rules:**
- Use `Combobox` — not a custom autocomplete
- `appearance="input"` for search-style combobox
- `autoCompleteBehavior="manual"` for type-to-filter
- Custom `optionFilter` for searching across multiple fields
- Keyboard shortcut: add `useEffect` for Cmd+K listener

---

## Category Filters

Filtering content by category using FilterChip.

```tsx
import { FilterChip } from "@zillow/constellation";
import { Flex } from "@/styled-system/jsx";

function CategoryFilter({ tags, activeFilter, onFilterChange, items }) {
  return (
    <Flex gap="200" css={{ flexWrap: "wrap" }}>
      {tags.map((tag) => {
        const count = tag.value === "all"
          ? items.length
          : items.filter((item) => item.tags?.includes(tag.value)).length;
        if (count === 0 && tag.value !== "all") return null;
        return (
          <FilterChip
            key={tag.value}
            selected={activeFilter === tag.value}
            onClick={() => onFilterChange(tag.value)}
          >
            {`${tag.label} (${count})`}
          </FilterChip>
        );
      })}
    </Flex>
  );
}
```

**Key rules:**
- Use `FilterChip` — not `Button` or `ToggleButton` for multi-select filters
- Hide tags with zero count (except "All")
- Show count in the chip label

---

## Submission Form

Authenticated form inside a modal.

```tsx
import { Modal, Heading, Divider, Button, ButtonGroup, TextButton, Input, Textarea, Spinner, FilterChip } from "@zillow/constellation";
import { Flex, Box } from "@/styled-system/jsx";

function SubmitItemModal({ open, onOpenChange, onSubmitted }: Props) {
  const [name, setName] = useState("");
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  return (
    <Modal
      size="md"
      open={open}
      onOpenChange={onOpenChange}
      dividers
      header={<Heading level={1}>Submit an item</Heading>}
      body={
        <Flex direction="column" gap="400">
          {error && (
            <Box css={{ bg: "bg.accent.red.soft", borderRadius: "node.md", px: "300", py: "200" }}>
              <Text textStyle="body-sm" css={{ color: "text.action.critical.hero.default" }}>{error}</Text>
            </Box>
          )}
          <Flex direction="column" gap="100">
            <Text textStyle="body-bold">Name</Text>
            <Input size="md" placeholder="Item name" value={name} onChange={(e) => setName(e.target.value)} />
          </Flex>
          {/* More fields... */}
          <Flex direction="column" gap="200">
            <Text textStyle="body-bold">Tags</Text>
            <Flex gap="200" css={{ flexWrap: "wrap" }}>
              {TAGS.map((tag) => (
                <FilterChip key={tag} selected={selectedTags.includes(tag)} onClick={() => toggleTag(tag)}>
                  {tag}
                </FilterChip>
              ))}
            </Flex>
          </Flex>
        </Flex>
      }
      footer={
        <ButtonGroup aria-label="submission actions">
          <Modal.Close><TextButton>Cancel</TextButton></Modal.Close>
          <Button tone="brand" emphasis="filled" size="md" onClick={handleSubmit} disabled={!isValid || submitting}>
            {submitting ? <Flex align="center" gap="200"><Spinner size="sm" />Submitting...</Flex> : "Submit"}
          </Button>
        </ButtonGroup>
      }
    />
  );
}
```

**Key rules:**
- Use `Input size="md"` and `Textarea` — never custom styled inputs
- Form labels: `Text textStyle="body-bold"` — not `Heading`
- Error display: red soft background box — not an alert or toast
- Submit button disabled when form is invalid or submitting
- Reset form state when modal closes

---

## Reports Dashboard

Stats cards, leaderboards, and activity timelines.

```tsx
import { Card, Text, Icon, Divider, Tag } from "@zillow/constellation";
import { Flex, Grid } from "@/styled-system/jsx";

function StatCard({ label, value, icon }) {
  return (
    <Card outlined elevated={false} tone="neutral" css={{ p: "400" }}>
      <Flex align="center" gap="300">
        <Flex align="center" justify="center" css={{ width: "48px", height: "48px", borderRadius: "node.md", bg: "bg.elevated", flexShrink: 0 }}>
          {icon}
        </Flex>
        <Flex direction="column" gap="50">
          <Text textStyle="body-sm" css={{ color: "text.subtle" }}>{label}</Text>
          <Text textStyle="heading-lg">{value.toLocaleString()}</Text>
        </Flex>
      </Flex>
    </Card>
  );
}

function StatsGrid({ stats }) {
  return (
    <Grid columns={{ base: 1, sm: 2, md: 4 }} gap="400">
      {stats.map((stat) => <StatCard key={stat.label} {...stat} />)}
    </Grid>
  );
}
```

**Key rules:**
- Stat cards are static/display — use `outlined elevated={false} tone="neutral"`
- Use `Grid` for responsive stat layouts
- Section titles: `Text textStyle="body-lg-bold"` — not `Heading`
- Dividers between sections within cards — use `<Divider />`

---

## Auth Integration

Google OAuth with user menu.

```tsx
import { TextButton, Menu, IconButton, Icon } from "@zillow/constellation";
import { IconUserFilled } from "@zillow/constellation-icons";

function UserMenu() {
  const { user, signIn, signOut } = useAuth();

  if (!user) {
    return <TextButton size="md" onClick={signIn}>Sign in</TextButton>;
  }

  return (
    <Menu
      placement="bottom-end"
      trigger={
        user.photoURL ? (
          <button style={{ border: "none", background: "none", cursor: "pointer", padding: 0, borderRadius: "50%" }}>
            <img src={user.photoURL} alt={user.displayName} style={{ width: 32, height: 32, borderRadius: "50%", objectFit: "cover" }} />
          </button>
        ) : (
          <IconButton title="Account" tone="neutral" emphasis="bare" size="md" shape="circle">
            <Icon><IconUserFilled /></Icon>
          </IconButton>
        )
      }
      content={
        <>
          <Menu.Heading level={3}>{user.displayName || user.email}</Menu.Heading>
          <Menu.Item onClick={signOut}><Menu.ItemLabel>Sign out</Menu.ItemLabel></Menu.Item>
        </>
      }
    />
  );
}
```

---

## Theme Support

Light/dark/system mode with Constellation.

```tsx
import { Menu, Icon, IconButton } from "@zillow/constellation";
import { IconSettingsFilled, IconLightBulbFilled } from "@zillow/constellation-icons";

function ThemeMenu({ mode, setMode }) {
  const options = [
    { value: "light", label: "Light", meta: "Always use light theme" },
    { value: "dark", label: "Dark", meta: "Always use dark theme" },
    { value: "system", label: "System", meta: "Match your device setting" },
  ];

  return (
    <Menu
      placement="bottom-end"
      trigger={
        <IconButton title="Settings" tone="neutral" emphasis="bare" size="md" shape="circle">
          <Icon><IconSettingsFilled /></Icon>
        </IconButton>
      }
      content={
        <>
          <Menu.Heading level={3}><Icon size="md"><IconLightBulbFilled /></Icon> Appearance</Menu.Heading>
          {options.map((opt) => (
            <Menu.Item key={opt.value} onClick={() => setMode(opt.value)}>
              <Menu.ItemLabel>{opt.label}{mode === opt.value ? " ✓" : ""}</Menu.ItemLabel>
              <Menu.ItemMeta>{opt.meta}</Menu.ItemMeta>
            </Menu.Item>
          ))}
        </>
      }
    />
  );
}
```

**Theme hook pattern:**
- Store preference in `localStorage`
- Apply via `data-panda-mode` attribute on `document.documentElement`
- Listen for system preference changes with `matchMedia`

---

## Illustrations

Use Constellation illustrations for empty states and hero sections.

```tsx
import IllustrationLight from "@/assets/illustrations/Lightmode/search-homes.svg";
import IllustrationDark from "@/assets/illustrations/Darkmode/search-homes.svg";

function EmptyState({ isDarkMode }) {
  return (
    <Flex direction="column" align="center" gap="300" css={{ py: "800" }}>
      <img
        src={isDarkMode ? IllustrationDark : IllustrationLight}
        alt="No results"
        style={{ width: 160, height: 160 }}
      />
      <Text textStyle="body-lg-bold">No items found</Text>
      <Text textStyle="body" css={{ color: "text.subtle" }}>Try adjusting your filters or search terms.</Text>
    </Flex>
  );
}
```

**Key rules:**
- Standard spot illustrations: 160x160px
- ALWAYS include both light and dark variants
- NEVER remove the beige background blob
- Center-alignment is OK for empty states
- Use for empty states, hero sections, onboarding — not as decorative filler

---

## Shared Patterns

### Tag with Category Tone

```tsx
function getCategoryTone(category: string): "gray" | "blue" | "green" | "purple" | "yellow" | "red" {
  const toneMap: Record<string, "gray" | "blue" | "green" | "purple" | "yellow" | "red"> = {
    development: "blue",
    design: "purple",
    research: "green",
    testing: "yellow",
    devops: "gray",
    tooling: "gray",
    data: "green",
  };
  return toneMap[category.toLowerCase()] || "gray";
}

<Tag size="sm" tone={getCategoryTone(category)} css={{ whiteSpace: "nowrap", width: "fit-content" }}>
  {formatCategoryLabel(category)}
</Tag>
```

### Code Block with Copy

```tsx
function CodeBlock({ content, filename }: { content: string; filename: string }) {
  const [copied, setCopied] = useState(false);

  return (
    <Box>
      <Flex align="center" justify="space-between" css={{ bg: "bg.elevated", px: "300", py: "200", borderTopRadius: "node.md" }}>
        <Flex align="center" gap="200">
          <Icon size="sm" css={{ color: "icon.subtle" }}><IconFileFilled /></Icon>
          <Text textStyle="body-sm-bold">{filename}</Text>
        </Flex>
        <TextButton size="md" onClick={() => { navigator.clipboard.writeText(content); setCopied(true); setTimeout(() => setCopied(false), 2000); }}
          icon={<IconCopyFilled />} iconPosition="start"
        >
          {copied ? "Copied" : "Copy"}
        </TextButton>
      </Flex>
      <Divider />
      <Box css={{ bg: "bg.canvas", p: "400", borderBottomRadius: "node.md", overflow: "auto", maxHeight: "500px", fontFamily: "monospace", fontSize: "13px", lineHeight: "1.5", whiteSpace: "pre-wrap", wordBreak: "break-word" }}>
        {content}
      </Box>
    </Box>
  );
}
```

### Relative Timestamps

```tsx
function formatRelativeTime(dateString: string): string {
  const diffMs = Date.now() - new Date(dateString).getTime();
  const minutes = Math.floor(diffMs / 60000);
  const hours = Math.floor(diffMs / 3600000);
  const days = Math.floor(diffMs / 86400000);

  if (minutes < 1) return "Just now";
  if (minutes < 60) return `${minutes}m ago`;
  if (hours < 24) return `${hours}h ago`;
  if (days < 7) return `${days}d ago`;
  return new Date(dateString).toLocaleDateString();
}
```
