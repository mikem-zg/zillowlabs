# Token Testing Framework

Our components rely heavily on token use in our `.style.ts` files. We can enhance our Cypress tests by pointing directly to those tokens instead of raw computed CSS properties. The unified `assertToken` function documented below automatically tests both token values and generated classes for comprehensive validation.

**Prerequisites:** Token testing requires PandaCSS mappings to be generated. Run `pnpm scaffold:apps` after PandaCSS version updates or when setting up the project. See Development tech-stack for details.

## Basic token testing

```ts
it('should use correct tokens', () => {
  cy.mount(<MyComponent data-testid="component" />);
  const component = cy.findByTestId('component');

  component.assertToken('Component.bg', 'backgroundColor');
  component.assertToken('Component.text', 'color');
});
```

## Composed CSS testing

```ts
it('should use tokens in composed CSS values', () => {
  cy.mount(<MyComponent data-testid="component" />);
  const component = cy.findByTestId('component');

  // Test calc() expressions with tokens (class assertions auto-skipped for templates)
  component.assertToken('Component.positioning.avatar.xs', 'right', 'calc(${token} * -1)');

  // Test multi-value properties
  component.assertToken('Space.4', 'padding', '${token} 0');

  // Test gradients with tokens
  component.assertToken(
    'Color.primary',
    'background',
    'linear-gradient(90deg, ${token}, transparent)',
  );

  // Multi-token support for complex values
  component.assertToken(
    ['shadows.elevation.sm', 'colors.neutral.400'],
    'boxShadow',
    '${token0} ${token1}',
  );
});
```

## Multi-theme testing

```ts
// Test the same component across all themes and color modes (default: 4 combinations)
testWithThemesAndModes('should use correct tokens', () => {
  cy.mount(<MyComponent data-testid="component" />);
  const component = cy.findByTestId('component');
  component.assertToken('Component.bg', 'backgroundColor');
});
```

### Theme/mode configuration options

You can customize which themes and modes to test by passing configuration options:

```ts
// Test only dark mode across all themes
testWithThemesAndModes(
  'should work in dark mode',
  () => {
    cy.mount(<MyComponent data-testid="component" />);
    const component = cy.findByTestId('component');
    component.assertToken('Component.bg', 'backgroundColor');
  },
  {
    modes: ['dark'],
  },
);

// Test only the new zillow theme in both modes
testWithThemesAndModes(
  'should work in zillow theme',
  () => {
    cy.mount(<MyComponent data-testid="component" />);
    const component = cy.findByTestId('component');
    component.assertToken('Component.bg', 'backgroundColor');
  },
  {
    themes: ['zillow'],
  },
);

// Test specific theme/mode combination
testWithThemesAndModes(
  'should work in legacy-zillow light only',
  () => {
    cy.mount(<MyComponent data-testid="component" />);
    const component = cy.findByTestId('component');
    component.assertToken('Component.bg', 'backgroundColor');
  },
  {
    themes: ['legacy-zillow'],
    modes: ['light'],
  },
);
```

## Split token vs standard CSS assertions

For components that need both token testing AND regular CSS assertions, you can split them to optimize test execution:

```ts
testWithThemesAndModes('generates correct component styles', {
  setup: () => {
    cy.mount(
      <MyComponent data-testid="component" count={99}>
        <Icon size="lg">
          <IconMail />
        </Icon>
      </MyComponent>,
    );
  },
  tokenAssertions: () => {
    // These run across ALL configured themes/modes (default: 4 combinations)
    const component = cy.findByTestId('component');
    const badge = cy.get('[data-c11n-component="Badge"]');

    component.assertToken('Component.bg', 'backgroundColor');
    component.assertToken('Component.text', 'color');
    badge.assertToken('Badge.bg', 'backgroundColor');
  },
  valueAssertions: () => {
    // These run ONLY ONCE with default theme/mode
    const component = cy.findByTestId('component');

    component.should('have.css', 'position', 'absolute');
    component.should('have.css', 'right', '-8px');
    component.should('have.css', 'top', '-8px');
  },
});

// You can also configure themes/modes in the config object
testWithThemesAndModes('dark mode specific component styles', {
  setup: () => {
    cy.mount(<MyComponent data-testid="component" />);
  },
  tokenAssertions: () => {
    const component = cy.findByTestId('component');
    component.assertToken('Component.bg', 'backgroundColor');
    component.assertToken('Component.text', 'color');
  },
  valueAssertions: () => {
    const component = cy.findByTestId('component');
    component.should('have.css', 'border-radius', '8px');
  },
  themeModeConfig: {
    modes: ['dark'],
  },
});
```

## API

### `element.assertToken(tokenPath, cssPropertyOrOptions, template?)`

Unified function that automatically performs both CSS value and class assertions for comprehensive token testing.

**Parameters:**

- `tokenPath: string | string[]` - The token path(s) to resolve (e.g., `'Component.bg'` or `['shadows.sm', 'colors.red']`)
- `cssPropertyOrOptions: string | { cssProperty: string; template?: string }` - CSS property or options object
- `template?: string` - Optional template string with `${token}` placeholder for composed values

**Key features:**

- **Always tests both** - Validates CSS values AND generated Panda CSS classes automatically
- **Smart token resolution** - Works with clean names (`Gleam.bg`) or prefixed names (`colors.Gleam.bg`)
- **Automatic prefix handling** - Supports any token category (sizes, colors, spacing, typography, etc.)
- **Template support** - For `calc()` expressions and composite values
- **Multi-token support** - Arrays for complex CSS values using `${token0}`, `${token1}` placeholders
- **Intelligent class skipping** - Class assertions auto-skipped for templates

**Examples:**

```ts
// Simple token assertion (tests both value and class)
component.assertToken('Component.bg', 'backgroundColor');

// Smart prefix resolution - these work identically:
component.assertToken('Gleam.positioning.default', 'right');
component.assertToken('sizes.Gleam.positioning.default', 'right');

// Template with calc() (class assertion auto-skipped)
component.assertToken('Component.positioning.xs', 'right', 'calc(${token} * -1)');

// Options object syntax
component.assertToken('Component.bg', {
  cssProperty: 'backgroundColor',
  template: 'linear-gradient(90deg, ${token}, transparent)',
});

// Multi-token support for complex values
component.assertToken(
  ['shadows.elevation.sm', 'colors.neutral.400'],
  'boxShadow',
  '${token0} ${token1}',
);
```

**Migration from legacy API:**

- Replace `assertTokenValue()` with `assertToken()`
- Remove `assertTokenClass()` calls (now automatic)
- Same test coverage with cleaner, more robust API

### `testWithThemesAndModes(testName, testFnOrConfig, themeModeConfig?)`

Generates tests for all theme/mode combinations automatically, with optional configuration to specify which themes and modes to test.

**Signatures:**

```ts
// Simple: All assertions run across all themes/modes
testWithThemesAndModes(testName: string, testFn: () => void): void

// Simple with custom themes/modes
testWithThemesAndModes(
  testName: string,
  testFn: () => void,
  themeModeConfig?: ThemeModeConfig
): void

// Advanced: Split token and value assertions with optional theme/mode config
testWithThemesAndModes(testName: string, config: TestConfig): void

interface TestConfigInterface {
  setup: () => void;
  tokenAssertions: () => void;
  valueAssertions?: () => void;
  themeModeConfig?: ThemeModeConfig;
}

interface ThemeModeConfigInterface {
  themes?: Array<'legacy-zillow' | 'zillow'>;  // Default: ['legacy-zillow', 'zillow']
  modes?: Array<'light' | 'dark'>;             // Default: ['light', 'dark']
}
```
