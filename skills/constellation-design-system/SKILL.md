---
name: constellation-design-system
description: Build UI with Zillow's Constellation Design System v10.11.0. Use when developers mention Constellation, Zillow components, @zillow/constellation, PandaCSS with Zillow, or Zillow design system. Provides usage documentation for 99 components and 621 icons, plus design system rules and UX writing guidelines.
license: Proprietary
compatibility: Requires a React 18+ project with @zillow/constellation and @pandacss/dev installed.
metadata:
  author: Zillow Group
  version: "10.11.0"
---

# Zillow Constellation Design System (v10.11.0)

Constellation is Zillow's unified design system for building consumer and professional real estate applications. It provides accessible, themed React components with PandaCSS styling.

This skill covers **how to use** Constellation components, design rules, and UX writing guidelines in projects that already have Constellation installed.

## Documentation Structure

The `references/` directory contains detailed documentation organized as follows:

### Guides
- [Installation and Setup](references/guides/installation-and-setup.md): Complete setup guide for installing Constellation packages, configuring PandaCSS, setting themes, configuring aliases for styled-system, and framework-specific configs (Next.js, Vite, Storybook, Jest).
- [Design System Rules](references/guides/design-system-rules.md): Critical rules for component selection, colors, icons, typography, layouts, and audience-specific guidelines (Consumer vs Professional apps).
- [Navigation Patterns](references/guides/navigation-patterns.md): Decision framework for choosing the right navigation component (Page.Header, Tabs, VerticalNav, Breadcrumb, Menu, Pagination, Accordion, SegmentedControl). Covers when to use each, hybrid patterns, mobile/responsive behavior, and Consumer vs Professional guidance.
- [UX Writing Guide](references/guides/ux-writing.md): Voice, tone, sentence case, microcopy patterns, error/success messages, and copy review checklist.
- [Development Tech Stack](references/guides/development-tech-stack.md): Monorepo toolchain (Turbo, pnpm), build tools (Rslib, Rsbuild), testing (Vitest, Cypress), code quality (oxlint, Prettier), and daily development workflows.
- [Production Tech Stack](references/guides/production-tech-stack.md): Runtime dependencies, Panda CSS styling architecture, build output format, performance optimizations, and browser support.
- [Visual Testing](references/guides/visual-testing.md): Percy integration for automated visual regression testing with Cypress component tests.
- [Accessibility Reporting](references/guides/accessibility-reporting.md): Automated WCAG compliance scanning with axe-playwright and Storybook, violation reporting, exception handling, and MR workflow.
- [Token Testing Framework](references/guides/token-testing-framework.md): Cypress token assertion API (`assertToken`, `testWithThemesAndModes`) for validating design token usage across themes and color modes.

### Components
- [Accordion](references/components/Accordion.md): Expandable/collapsible content sections.
- [AdornedInput](references/components/AdornedInput.md): Input with prefix/suffix adornments.
- [Alert](references/components/Alert.md): Contextual alert messages.
- [Anchor](references/components/Anchor.md): Styled link component.
- [AssistChip](references/components/AssistChip.md): Action chip for quick tasks.
- [Avatar](references/components/Avatar.md): User/entity thumbnail representation.
- [Banner](references/components/Banner.md): Full-width notification banner.
- [Box](references/components/Box.md): Basic layout primitive.
- [Button](references/components/Button.md): Primary action trigger with icon support.
- [ButtonGroup](references/components/ButtonGroup.md): Grouping of related buttons.
- [Calendar](references/components/Calendar.md): Date selection calendar grid.
- [Card](references/components/Card.md): Generic content container (use tone="neutral").
- [Carousel](references/components/Carousel.md): Horizontal content slider.
- [Checkbox](references/components/Checkbox.md): Single checkbox input.
- [ChipGroup](references/components/ChipGroup.md): Group of selectable chips.
- [CloseButton](references/components/CloseButton.md): Dismiss/close action button.
- [Collapsible](references/components/Collapsible.md): Show/hide content toggle.
- [Combobox](references/components/Combobox.md): Searchable dropdown selection.
- [DataSelect](references/components/DataSelect.md): Data-driven select component.
- [DateInput](references/components/DateInput.md): Date text input field.
- [DatePicker](references/components/DatePicker.md): Calendar-based date picker.
- [DateTimeBlock](references/components/DateTimeBlock.md): Date and time display block.
- [Divider](references/components/Divider.md): Visual separator (ALWAYS use instead of CSS borders).
- [Dropdown](references/components/Dropdown.md): Dropdown menu trigger.
- [DropdownSelect](references/components/DropdownSelect.md): Dropdown with selection.
- [DuoColorIcon](references/components/DuoColorIcon.md): Two-tone icons for upsells/empty states.
- [FieldSet](references/components/FieldSet.md): Form field grouping.
- [FilterChip](references/components/FilterChip.md): Toggleable filter chip.
- [FilterChipWithMenu](references/components/FilterChipWithMenu.md): Filter chip with dropdown menu.
- [Flex](references/components/Flex.md): Flexbox layout (deprecated, use Box).
- [Form](references/components/Form.md): Form container with validation.
- [FormActions](references/components/FormActions.md): Form action button group.
- [FormField](references/components/FormField.md): Form field wrapper with label/error.
- [FormHelp](references/components/FormHelp.md): Form helper text.
- [Gleam](references/components/Gleam.md): Skeleton loading shimmer effect.
- [Grid](references/components/Grid.md): CSS Grid layout (deprecated, use Box).
- [Heading](references/components/Heading.md): Page headline (use sparingly, 1-2 per screen).
- [Highlight](references/components/Highlight.md): Text highlight/emphasis.
- [Highlighter](references/components/Highlighter.md): Search term highlighter.
- [Icon](references/components/Icon.md): Icon wrapper with size tokens (sm/md/lg/xl).
- [IconButton](references/components/IconButton.md): Icon-only button.
- [Icons](references/components/Icons.md): Full icon reference (621 icons, all styles).
- [Illustrations](references/components/Illustrations.md): 99 spot illustrations catalog (SVGs) with DuoColorIcon two-tone styling guide.
- [Image](references/components/Image.md): Responsive image component.
- [InlineFeedback](references/components/InlineFeedback.md): Inline validation feedback.
- [Input](references/components/Input.md): Text input field.
- [InputChip](references/components/InputChip.md): Removable input tag/chip.
- [Label](references/components/Label.md): Form field label.
- [LabeledControl](references/components/LabeledControl.md): Control with integrated label.
- [LabeledInput](references/components/LabeledInput.md): Input with integrated label.
- [LabeledRatingStars](references/components/LabeledRatingStars.md): Star rating with label.
- [Layout](references/components/Layout.md): Page layout structure.
- [Legend](references/components/Legend.md): Fieldset legend.
- [List](references/components/List.md): Ordered/unordered list.
- [LoadingMask](references/components/LoadingMask.md): Loading overlay mask.
- [MediaObject](references/components/MediaObject.md): Media + content layout pattern.
- [Menu](references/components/Menu.md): Dropdown action menu.
- [Modal](references/components/Modal.md): Dialog modal (use body prop, NOT children).
- [NumberRating](references/components/NumberRating.md): Numeric rating display.
- [Page](references/components/Page.md): Page layout system (Page.Root, Page.Header, Page.Content, Page.Breadcrumb). ALWAYS use instead of Box/Flex for page structure.
- [Pagination](references/components/Pagination.md): Page navigation controls.
- [Paragraph](references/components/Paragraph.md): Body text paragraph.
- [PhotoCarousel](references/components/PhotoCarousel.md): Image gallery carousel.
- [Popover](references/components/Popover.md): Floating content popover.
- [Progress](references/components/Progress.md): Progress indicator.
- [ProgressBar](references/components/ProgressBar.md): Linear progress bar.
- [ProgressStepper](references/components/ProgressStepper.md): Multi-step progress tracker.
- [PropertyCard](references/components/PropertyCard.md): Property listing card (ALWAYS use for listings).
- [Radio](references/components/Radio.md): Radio button input.
- [Range](references/components/Range.md): Range slider input.
- [RatingStars](references/components/RatingStars.md): Star rating display.
- [Select](references/components/Select.md): Dropdown select input.
- [ShowHide](references/components/ShowHide.md): Expandable text with show/hide toggle.
- [ShowHideWordCount](references/components/ShowHideWordCount.md): Show/hide with word count.
- [Slider](references/components/Slider.md): Single value slider.
- [Slot](references/components/Slot.md): Component composition slot.
- [Spacer](references/components/Spacer.md): Layout spacing utility.
- [Spinner](references/components/Spinner.md): Loading spinner animation.
- [Switch](references/components/Switch.md): Toggle switch input.
- [Table](references/components/Table.md): Data table with sorting/selection.
- [Tabs](references/components/Tabs.md): Tabbed content navigation (ALWAYS set defaultValue).
- [Tag](references/components/Tag.md): Categorization tag/label.
- [Text](references/components/Text.md): Text display with textStyle variants.
- [TextButton](references/components/TextButton.md): Text-only button (no background).
- [Textarea](references/components/Textarea.md): Multi-line text input.
- [Toast](references/components/Toast.md): Temporary notification message.
- [ToastProvider](references/components/ToastProvider.md): Toast notification provider.
- [ToggleButton](references/components/ToggleButton.md): On/off toggle button.
- [ToggleButtonGroup](references/components/ToggleButtonGroup.md): Group of toggle buttons for selection.
- [ToggleCard](references/components/ToggleCard.md): Selectable card toggle.
- [ToneIcon](references/components/ToneIcon.md): Themed icon with tone variants.
- [Tooltip](references/components/Tooltip.md): Hover information tooltip.
- [TriggerButton](references/components/TriggerButton.md): Button that triggers a popup/menu.
- [TriggerText](references/components/TriggerText.md): Text that triggers a popup/menu.
- [UnstyledButton](references/components/UnstyledButton.md): Button with no default styling.
- [Upsell](references/components/Upsell.md): Promotional upsell component.
- [UpsellBanner](references/components/UpsellBanner.md): Full-width upsell banner.
- [VerticalNav](references/components/VerticalNav.md): Vertical navigation menu.
- [VisuallyHidden](references/components/VisuallyHidden.md): Screen-reader only content.
- [ZillowHomeLogo](references/components/ZillowHomeLogo.md): Zillow home icon logo.
- [ZillowLogo](references/components/ZillowLogo.md): Full Zillow wordmark logo.

### Related Skills
- **[accessibility](../../accessibility/SKILL.md)**: For WCAG 2.2 AA compliance, ARIA patterns, React focus management, and testing workflows. Load this skill alongside Constellation when building accessible UI, reviewing components for a11y, or preparing designs for engineering handoff. Covers Zillow's internal design checklist, engineering handoff checklist, and Figma annotation guidance.
- **[responsive-design](../../responsive-design/SKILL.md)**: For mobile-first responsive layouts using PandaCSS breakpoint tokens, Constellation component sizing, container queries, fluid typography, and touch targets. Load this skill when building responsive pages, adapting layouts across screen sizes, or optimizing for mobile performance and Core Web Vitals.
