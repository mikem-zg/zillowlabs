# Accessibility Reporting

Constellation uses automated accessibility scanning to maintain WCAG compliance across the component library. This guide outlines the reporting system and workflows for identifying, prioritizing, and resolving accessibility violations.

## Overview

The accessibility reporting system integrates axe-playwright with Storybook to automatically scan all components and generate comprehensive violation reports. This systematic approach ensures consistent accessibility standards and provides clear guidance for remediation.

## Quick start

### Generate accessibility reports

```bash
pnpm --filter=@apps/storybook test:a11y
```

The scan process:

1. Automatically builds Storybook for testing
2. Starts a dedicated test server
3. Runs accessibility tests on all Storybook components
4. Generates individual violation reports for each story
5. Creates or updates an aggregated report at `apps/storybook/a11y/report.md` when violations exist
6. Cleans up test server and temporary files

No report file indicates zero violations across all components.

### Review the report

The `apps/storybook/a11y/report.md` file contains:

- **Summary statistics** - Total violations and severity breakdown
- **Most common violations** - Issues affecting multiple components
- **Component-specific violations** - Detailed breakdown by component

### Prioritize and fix issues

Use the report data to systematically address accessibility violations based on severity and impact.

## Development workflow

### Baseline assessment

1. Generate the report using `pnpm --filter=@apps/storybook test:a11y`
2. Review the summary to understand the scope of issues
3. Identify patterns in the "Most Common Violations" section
4. Choose a component to focus on, prioritizing high-impact violations

### Interactive development

1. Start Storybook with `pnpm --filter=@apps/storybook dev`
2. Navigate to the component you want to fix
3. Use the Accessibility tab in Storybook's bottom panel
4. View real-time violations as you make changes

### Fix and verify

1. Make changes to your component code
2. Use the Accessibility tab to verify fixes in real-time
3. Test different story variations to ensure comprehensive coverage
4. Re-run the full accessibility test suite to confirm system-wide improvements

### Progress tracking

1. Re-generate the report periodically with `pnpm --filter=@apps/storybook test:a11y`
2. Compare violation counts to track progress
3. Focus on high-impact violations first (critical and serious severity)

## Exception handling

When violations cannot or should not be fixed due to valid design or technical reasons:

1. Add exceptions in `apps/storybook/a11y/exceptions.ts`
2. Document the reason clearly in the exception entry
3. Be specific — target the exact story and rule ID
4. Re-run tests to verify the exception is applied correctly

Example exception:

```ts
export const EXCEPTIONS: Record<string, Array<{ ruleId: string; reason: string }>> = {
  'Components_Button--IconOnly': [
    {
      ruleId: 'button-name',
      reason: 'Button text provided via aria-label for icon-only variant',
    },
  ],
};
```

## MR completion workflow

When creating merge requests to address accessibility violations, ensure your MR includes all required deliverables.

### Required deliverables

Every accessibility fix MR should include:

1. **Changeset file** - When component `.tsx` files are modified:

```bash
# Generate changeset for component changes
pnpm changeset
# Select 'patch' release type for accessibility fixes
```

2. **Component and story updates** - The actual fixes to address violations:
   - Updated component implementation
   - Modified story files if needed for proper accessibility testing

3. **Updated report.md** - Demonstrates the fix resolved the targeted violations:
   - Run `pnpm --filter=@apps/storybook test:a11y` after implementing fixes
   - Verify violations are removed from `apps/storybook/a11y/report.md`
   - Commit the updated report showing progress

4. **Updated completed-components.ts** - Prevents future conflicts:
   - Add the component name to `apps/storybook/a11y/completed-components.ts`
   - This excludes the component from subsequent accessibility scans
   - Prevents other MRs from reporting on components you've already fixed

### Example MR structure

```
feat(Button): fix accessibility violations

- Fix button-name violation by adding proper aria-label
- Fix color-contrast issues in disabled state
- Add Button to completed components list

Files changed:
  .changeset/fix-button-a11y.md (patch release)
  packages/constellation/src/components/button/button.tsx
  packages/constellation/src/components/button/stories/button.stories.tsx
  apps/storybook/a11y/report.md (violations removed)
  apps/storybook/a11y/completed-components.ts (Button added)
```

### Benefits of this workflow

- **Prevents merge conflicts** - Completed components don't generate reports in other MRs
- **Tracks progress systematically** - Clear before/after in report.md changes
- **Maintains release integrity** - Proper changesets for component modifications
- **Enables parallel work** - Multiple developers can work on different components safely

## Common accessibility issues

| Rule ID | Description | Common Fixes |
|---------|-------------|--------------|
| `label` | Form elements lack proper labels | Add `<label>` elements, use `aria-label`, connect with `aria-labelledby` |
| `aria-input-field-name` | ARIA input fields missing accessible names | Add `aria-label` to inputs, use `aria-labelledby` |
| `button-name` | Buttons without discernible text | Add visible text content, use `aria-label` for icon buttons |
| `select-name` | Select elements lack accessible names | Add associated `<label>` elements, use `aria-label` |
| `aria-allowed-attr` | ARIA attributes not supported by element role | Review ARIA attribute usage, match attributes to appropriate roles |
| `color-contrast` | Insufficient contrast between text and background | Adjust color values, use design tokens with proper ratios |
| `aria-valid-attr-value` | ARIA attributes have invalid values | Verify ARIA value formats, check for typos |

### Key patterns to address

- **Form accessibility** is the biggest challenge, with labeling issues affecting 17 components across multiple rule types
- **ARIA implementation** needs attention, with 5 components having invalid or conflicting ARIA usage
- **Semantic HTML issues** appear in list structures and element roles

### Prevention strategies

- Use semantic HTML first — often eliminates need for complex ARIA
- Test with keyboard navigation — reveals focus and labeling issues early
- Include accessibility in component design — consider screen readers during development
- Leverage form field patterns — use established label association patterns
- Validate ARIA usage — review ARIA authoring practices before implementation

## Resources

- [axe-core Rules](https://github.com/dequelabs/axe-core/blob/develop/doc/rule-descriptions.md)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Storybook Accessibility Addon](https://storybook.js.org/addons/@storybook/addon-a11y)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/)
