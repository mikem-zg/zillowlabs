# Carousel

```tsx
import { Carousel } from '@zillow/constellation';
```

**Version:** 10.11.0

## Usage

```tsx
import { Card, Carousel, Heading } from '@zillow/constellation';
```

```tsx
export const CarouselBasic = () => {
  return (
    <Carousel
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          interactive
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
            width: '200px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

## Examples

### Carousel Composed

```tsx
import { Card, Carousel, Heading, useCarousel } from '@zillow/constellation';
```

```tsx
export const CarouselComposed = () => {
  const {
    previousEnabled,
    nextEnabled,
    nextPage,
    previousPage,
    firstSlide,
    scrollContainer,
    sectionStart,
    sectionEnd,
    handleOnScroll,
    scrollToFocusedEl,
    handleSkipToStart,
    handleSkipToEnd,
  } = useCarousel({
    onNextClick: () => {
      // eslint-disable-next-line no-console
      console.log('next clicked');
    },
    onPreviousClick: () => {
      // eslint-disable-next-line no-console
      console.log('previous clicked');
    },
    onScroll: () => {
      // eslint-disable-next-line no-console
      console.log('scroll happened');
    },
  });

  return (
    <Carousel.Root>
      <Carousel.Header>
        <Carousel.HeadingArea>
          <Heading level={5}>Carousel heading</Heading>
        </Carousel.HeadingArea>
        <Carousel.NavControls
          leftButtonProps={{ onClick: previousPage, disabled: !previousEnabled }}
          rightButtonProps={{ onClick: nextPage, disabled: !nextEnabled }}
        />
      </Carousel.Header>
      <Carousel.SkipLink onClick={handleSkipToEnd} ref={sectionStart}>
        Skip to the end of the carousel
      </Carousel.SkipLink>
      <Carousel.ScrollContainer
        enableSnap
        hasFocusableContent
        onKeyUp={scrollToFocusedEl}
        onScroll={(e) => handleOnScroll(e)}
        scrollOffset="none"
        slideGap="sm"
        ref={scrollContainer}
      >
        {Array.from({ length: 10 }).map((_, index: number) => (
          <Carousel.Slide
            css={{ flexBasis: { base: '200px', lg: '300px' } }}
            ref={index === 0 ? firstSlide : undefined}
            key={index}
          >
            <Card
              interactive
              outlined
              elevated={false}
              tone="neutral"
              onClick={() => {}}
              onKeyDown={() => {}}
              css={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                height: '150px',
              }}
            >
              {index + 1}
            </Card>
          </Carousel.Slide>
        ))}
      </Carousel.ScrollContainer>
      <Carousel.SkipLink onClick={handleSkipToStart} ref={sectionEnd}>
        Skip to the beginning of the carousel
      </Carousel.SkipLink>
    </Carousel.Root>
  );
};
```

### Carousel Custom Controls

```tsx
import { Card, Carousel, Heading, IconButton } from '@zillow/constellation';
```

```tsx
export const CarouselCustomControls = () => {
  return (
    <Carousel
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
      renderNavigationControls={(leftButtonProps, rightButtonProps) => (
        <Carousel.NavControls css={{ gap: 'looser' }}>
          <IconButton
            shape="circle"
            aria-label="Previous"
            icon={<IconArrowLeftFilled />}
            size="sm"
            tabIndex={-1}
            title="Previous items"
            data-c11n-version={__C11N_VERSION__}
            data-c11n-component="Carousel.PreviousButton"
            {...leftButtonProps}
          />
          <IconButton
            shape="circle"
            aria-label="Next"
            icon={<IconArrowRightFilled />}
            size="sm"
            tabIndex={-1}
            title="Next items"
            data-c11n-version={__C11N_VERSION__}
            data-c11n-component="Carousel.NextButton"
            {...rightButtonProps}
          />
        </Carousel.NavControls>
      )}
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          interactive
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
            width: '200px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

### Carousel Custom Nav Controls

```tsx
import { Card, Carousel, Heading, IconButton } from '@zillow/constellation';
```

```tsx
export const CarouselCustomNavControls = () => {
  return (
    <Carousel
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
      renderNavigationControls={(leftButtonProps, rightButtonProps) => (
        <Carousel.NavControls css={{ gap: 'looser' }}>
          <IconButton
            shape="circle"
            aria-label="Previous"
            icon={<IconArrowLeftFilled />}
            size="sm"
            tabIndex={-1}
            title="Previous items"
            data-c11n-version={__C11N_VERSION__}
            data-c11n-component="Carousel.PreviousButton"
            {...leftButtonProps}
          />
          <IconButton
            shape="circle"
            aria-label="Next"
            icon={<IconArrowRightFilled />}
            size="sm"
            tabIndex={-1}
            title="Next items"
            data-c11n-version={__C11N_VERSION__}
            data-c11n-component="Carousel.NextButton"
            {...rightButtonProps}
          />
        </Carousel.NavControls>
      )}
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          interactive
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
            width: '200px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

### Carousel Enable Scroll Snap

```tsx
import { Card, Carousel, Heading } from '@zillow/constellation';
```

```tsx
export const CarouselEnableScrollSnap = () => {
  return (
    <Carousel
      enableSnap={{ base: false, lg: true }}
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          interactive
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
            width: '200px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

### Carousel Enable Slide Snap

```tsx
import { Card, Carousel, Heading } from '@zillow/constellation';
```

```tsx
export const CarouselEnableSlideSnap = () => {
  return (
    <Carousel
      enableSnap={{ base: false, lg: true }}
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          interactive
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
            width: '200px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

### Carousel No Focusable Content

```tsx
import { Card, Carousel, Heading } from '@zillow/constellation';
```

```tsx
export const CarouselNoFocusableContent = () => {
  return (
    <Carousel
      hasFocusableContent={false}
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
            width: '200px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

### Carousel Responsive

```tsx
import { Card, Carousel, Heading, useCarousel } from '@zillow/constellation';
```

```tsx
export const CarouselResponsive = () => {
  const {
    previousEnabled,
    nextEnabled,
    nextPage,
    previousPage,
    firstSlide,
    scrollContainer,
    sectionStart,
    sectionEnd,
    handleOnScroll,
    scrollToFocusedEl,
    handleSkipToStart,
    handleSkipToEnd,
  } = useCarousel({
    onNextClick: () => {
      // eslint-disable-next-line no-console
      console.log('next clicked');
    },
    onPreviousClick: () => {
      // eslint-disable-next-line no-console
      console.log('previous clicked');
    },
    onScroll: () => {
      // eslint-disable-next-line no-console
      console.log('scroll happened');
    },
  });

  return (
    <Carousel.Root>
      <Carousel.Header>
        <Carousel.HeadingArea>
          <Heading level={5}>Carousel heading</Heading>
        </Carousel.HeadingArea>
        <Carousel.NavControls
          leftButtonProps={{ onClick: previousPage, disabled: !previousEnabled }}
          rightButtonProps={{ onClick: nextPage, disabled: !nextEnabled }}
        />
      </Carousel.Header>
      <Carousel.SkipLink onClick={handleSkipToEnd} ref={sectionStart}>
        Skip to the end of the carousel
      </Carousel.SkipLink>
      <Carousel.ScrollContainer
        enableSnap
        hasFocusableContent
        onKeyUp={scrollToFocusedEl}
        onScroll={(e) => handleOnScroll(e)}
        scrollOffset="none"
        slideGap="sm"
        ref={scrollContainer}
      >
        {Array.from({ length: 10 }).map((_, index: number) => (
          <Carousel.Slide
            css={{ flexBasis: { base: '200px', lg: '300px' } }}
            ref={index === 0 ? firstSlide : undefined}
            key={index}
          >
            <Card
              interactive
              outlined
              elevated={false}
              tone="neutral"
              onClick={() => {}}
              onKeyDown={() => {}}
              css={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                height: '150px',
              }}
            >
              {index + 1}
            </Card>
          </Carousel.Slide>
        ))}
      </Carousel.ScrollContainer>
      <Carousel.SkipLink onClick={handleSkipToStart} ref={sectionEnd}>
        Skip to the beginning of the carousel
      </Carousel.SkipLink>
    </Carousel.Root>
  );
};
```

### Carousel Scroll Offset

```tsx
import { Card, Carousel, Heading } from '@zillow/constellation';
```

```tsx
export const CarouselScrollOffset = () => {
  return (
    <Carousel
      scrollOffset="xs"
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          interactive
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
            width: '200px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

### Carousel Scroll To Slide

```tsx
import { Box, Button, Card, Carousel, Heading, Text } from '@zillow/constellation';
```

```tsx
export const CarouselScrollToSlide = () => {
  const [visibleSlides, setVisibleSlides] = useState<Array<number>>([]);
  const [currentSlide, setCurrentSlide] = useState<number | undefined>(undefined);
  const totalSlides = 10;

  const goToRandomSlide = () => {
    let randomSlide;
    do {
      randomSlide = Math.floor(Math.random() * totalSlides);
    } while (randomSlide === currentSlide && totalSlides > 1);

    setCurrentSlide(randomSlide);
  };

  const onVisibleSlidesChange = useCallback((slides: Array<number>) => {
    setVisibleSlides(slides);
  }, []);

  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: 'tight' }}>
      <Text textStyle="body-sm">
        Last <code>onVisibleSlidesChange</code> callback:{' '}
        <code>{JSON.stringify(visibleSlides)}</code>
      </Text>
      <Carousel
        heading={<Heading level={5}>Carousel heading</Heading>}
        scrollToSlide={currentSlide}
        onVisibleSlidesChange={onVisibleSlidesChange}
      >
        {Array.from({ length }).map((_, index) => (
          <Card
            interactive
            outlined
            elevated={false}
            tone="neutral"
            onClick={() => {}}
            onKeyDown={() => {}}
            css={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              height: '150px',
              width: '200px',
            }}
            key={index}
          >
            {index + 1}
          </Card>
        ))}
      </Carousel>
      <Box>
        <Button onClick={goToRandomSlide}>
          Go to Random Slide {currentSlide !== undefined ? `(Current: ${currentSlide + 1})` : ''}
        </Button>
      </Box>
    </Box>
  );
};
```

### Carousel Slide Align

```tsx
import { Card, Carousel, Heading } from '@zillow/constellation';
```

```tsx
export const CarouselSlideAlign = () => {
  return (
    <Carousel
      slideAlign="center"
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          interactive
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
            width: '200px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

### Carousel Slide Gap

```tsx
import { Card, Carousel, Heading } from '@zillow/constellation';
```

```tsx
export const CarouselSlideGap = () => {
  return (
    <Carousel
      slideGap="sm"
      slideWidth="200px"
      heading={
        <Heading level={5} textStyle="heading-sm">
          Carousel heading
        </Heading>
      }
    >
      {Array.from({ length: 7 }).map((_, index: number) => (
        <Card
          interactive
          outlined
          elevated={false}
          tone="neutral"
          onClick={() => {}}
          onKeyDown={() => {}}
          css={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: '150px',
          }}
          key={index}
        >
          {index + 1}
        </Card>
      ))}
    </Carousel>
  );
};
```

## API

### Carousel (shorthand)

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| heading | `ReactNode` | - | A heading to display above the Carousel. Accepts a node (ex: `Heading`) or a fragment with multiple nodes (ex: `Heading` + `Paragraph`). Try to provide heading copy that's descriptive enough so that a screen reader user can decide whether they would want to view it or skip over it. |
| includeSkipLink | `boolean` | - | When true, keyboard users will see a "skip" link they can use to skip past all of the carousel content. "Skip" links appear at the beginning and end of a carousel. |
| renderNavigationControls | `(leftButtonProps: Omit<IconButtonPropsInterface, 'children' \| 'title'>, rightButtonProps: Omit<IconButtonPropsInterface, 'children' \| 'title'>) => ReactNode` | - | A render prop that returns the navigation controls. It takes two arguments: props objects for the left and right buttons. |
| slideWidth | `Property.FlexBasis` | `auto` | Sets the width of a slide using `flex-basis`. |
| enableSnap | `ResponsiveVariant<boolean>` | `{ base: false, lg: true }` | When true, the carousel will "snap" to the nearest slide after the user clicks a nav control or finishes scrolling or swiping. |
| hasFocusableContent | `boolean` | `true` | When false, the Carousel's content area will be focusable so that users can control the container's scroll position with their keyboard. |
| scrollOffset | `ResponsiveVariant<'none' \| 'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl'>` | `sm` | Sets padding at the beginning and end of the slide container. Useful for preventing box shadows from getting cropped. Takes a spacing t-shirt size. Supports inline media query objects. |
| slideGap | `ResponsiveVariant<'xxs' \| 'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl'>` | `none` | Sets the gutter size between slides. Takes a spacing t-shirt size. Supports inline media query objects. |
| slideAlign | `ResponsiveVariant<'start' \| 'end' \| 'center'>` | - | Determines how a slide should try to align within its container. Applied using `scroll-snap-align`. Supports inline media query objects. |
| scrollLeft | `number` | - | Use to scroll the carousel to a specified position. Takes a number representing the number of pixels to scroll from the beginning of the carousel. |
| scrollToSlide | `number` | - | Scroll to a specific slide by index. The carousel will scroll to the specified slide. If the slide index doesn't exist the operation will fail silently. Respects the enableSnap setting and uses smooth scrolling behavior. |
| onVisibleSlidesChange | `(slideIndices: Array<number>) => void` | - | Callback function that's called when the set of fully visible slides changes. Only slides that are completely within the carousel viewport are included. |
| aria-label | `string` | - | An aria-label for assistive technologies to announce the carousel properly. Especially necessary when using multiple carousels on the same page. |
| asChild | `boolean` | `false` | Use child as the root element. |
| children | `ReactNode` | - | Content. |
| css | `SystemStyleObject` | - | Styles object. |
| onNextClick | `MouseEventHandler` | - | Callback function that's called when you click on the nav button that shows the next set of slides. |
| onPreviousClick | `MouseEventHandler` | - | Callback function that's called when you click on the nav button that shows the previous set of slides. |
| onScroll | `UIEventHandler<HTMLElement>` | - | An event handler that will be called when the carousel has been scrolled either via mouse, swipe or the navigation buttons. |
| role | `AriaRole` | - | Sets the `role` of the carousel root. |

### CarouselHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| asChild | `boolean` | `false` | Use child as the root element. |
| children | `ReactNode` | - | Content. |
| css | `SystemStyleObject` | - | Styles object. |

### CarouselHeadingArea

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| asChild | `boolean` | `false` | Use child as the root element. |
| children | `ReactNode` | - | Content. |
| css | `SystemStyleObject` | - | Styles object. |

### CarouselNavControls

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| children | `ReactNode` | - | Content. |
| css | `SystemStyleObject` | - | Styles object. |
| leftButtonProps | `Omit<IconButtonPropsInterface, 'children' \| 'title'>` | - | Props passed by `Carousel` for the left navigation button. |
| rightButtonProps | `Omit<IconButtonPropsInterface, 'children' \| 'title'>` | - | Props passed by `Carousel` for the right navigation button. |

### CarouselRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| aria-label | `string` | - | An aria-label for assistive technologies to announce the carousel properly. Especially necessary when using multiple carousels on the same page. |
| asChild | `boolean` | `false` | Use child as the root element. |
| children | `ReactNode` | - | Content. |
| css | `SystemStyleObject` | - | Styles object. |
| onNextClick | `MouseEventHandler` | - | Callback function that's called when you click on the nav button that shows the next set of slides. |
| onPreviousClick | `MouseEventHandler` | - | Callback function that's called when you click on the nav button that shows the previous set of slides. |
| onScroll | `UIEventHandler<HTMLElement>` | - | An event handler that will be called when the carousel has been scrolled either via mouse, swipe or the navigation buttons. |
| onVisibleSlidesChange | `(slideIndices: Array<number>) => void` | - | Callback function that's called when the set of fully visible slides changes. Only slides that are completely within the carousel viewport are included. Triggers after manual scroll/swipe ends, scrollToSlide completes, navigation button clicks, initial render, and container resize. |
| role | `AriaRole` | - | Sets the `role` of the carousel root. |
| scrollLeft | `number` | - | Use to scroll the carousel to a specified position. Takes a number representing the number of pixels to scroll from the beginning of the carousel. |
| scrollToSlide | `number` | - | Scroll to a specific slide by index. The carousel will scroll to the specified slide. If the slide index doesn't exist the operation will fail silently. Respects the enableSnap setting and uses smooth scrolling behavior. |

### CarouselScrollContainer

**Element:** `HTMLUListElement`

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| children | `ReactNode` | - | Content. |
| css | `SystemStyleObject` | - | Styles object. |
| enableSnap | `ResponsiveVariant<boolean>` | `{ base: false, lg: true }` | When true, the carousel will "snap" to the nearest slide after the user clicks a nav control or finishes scrolling or swiping. By default, snap is enabled on desktop but disabled on mobile to protect touch users from clunky, unexpected behavior. |
| hasFocusableContent | `boolean` | `true` | When false, the Carousel's content area will be focusable so that users can control the container's scroll position with their keyboard. |
| scrollOffset | `ResponsiveVariant<'none' \| 'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl'>` | `sm` | Sets padding at the beginning and end of the slide container. Useful for preventing box shadows from getting cropped. Takes a spacing t-shirt size. Supports inline media query objects. |
| slideGap | `ResponsiveVariant<'xxs' \| 'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl'>` | `none` | Sets the gutter size between slides. Takes a spacing t-shirt size. Supports inline media query objects. |

### CarouselSkipLink

**Element:** `HTMLAnchorElement`

Extends `AnchorPropsInterface` (without `href`).

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| asChild | `boolean` | `false` | Use child as the root element. |
| children | `ReactNode` | - | Content. |
| css | `SystemStyleObject` | - | Styles object. |
| disabled | `boolean` | `false` | This prop mainly supports situations where `asChild` is used to turn another component into an anchor (ex: a `Button` component that is rendered as an anchor). Otherwise, anchor links should not be disabled. |
| onImpact | `ResponsiveVariant<boolean>` | - | For use on dark or colored backgrounds. |

### CarouselSlide

**Element:** `HTMLLIElement`

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| children | `ReactNode` | - | Content. |
| css | `SystemStyleObject` | - | Styles object. |
| slideAlign | `ResponsiveVariant<'start' \| 'end' \| 'center'>` | - | Determines how a slide should try to align within its container. Applied using `scroll-snap-align`. Supports inline media query objects. |
| slideWidth | `string` | `auto` | Sets the width of a slide. Deprecated: use `css` prop instead. |

### useCarousel Hook

```tsx
import { useCarousel } from '@zillow/constellation';
```

**Parameters:**

| Prop | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| scrollLeft | `number` | - | Use to scroll the carousel to a specified position. |
| scrollToSlide | `number` | - | Scroll to a specific slide by index. |
| onNextClick | `MouseEventHandler` | - | Callback function that's called when you click on the nav button that shows the next set of slides. |
| onPreviousClick | `MouseEventHandler` | - | Callback function that's called when you click on the nav button that shows the previous set of slides. |
| onScroll | `UIEventHandler<HTMLElement>` | - | An event handler that will be called when the carousel has been scrolled either via mouse, swipe or the navigation buttons. |
| onVisibleSlidesChange | `(slideIndices: Array<number>) => void` | - | Callback function that's called when the set of fully visible slides changes. |

**Return Value:**

| Property | Type | Description |
| -------- | ---- | ----------- |
| previousEnabled | `boolean` | Whether the previous button is enabled. |
| nextEnabled | `boolean` | Whether the next button is enabled. |
| firstSlide | `RefObject<HTMLLIElement>` | A reference to the first slide in the carousel. |
| scrollContainer | `RefObject<HTMLUListElement>` | A reference to the scroll container in the carousel. |
| sectionStart | `RefObject<HTMLAnchorElement>` | A reference to the section start in the carousel. |
| sectionEnd | `RefObject<HTMLAnchorElement>` | A reference to the section end in the carousel. |
| handleOnScroll | `UIEventHandler<HTMLUListElement>` | An event handler that will be called when the carousel has been scrolled either via mouse, swipe or the navigation buttons. |
| scrollToFocusedEl | `KeyboardEventHandler` | When tabbing, this tries to ensure the focused element is always visible. If focused element is outside of the Carousel container, scroll by at least one slide width. |
| handleSkipToStart | `MouseEventHandler` | A mouse event handler that will be called when you click on the skip link that takes you to the beginning of the carousel. |
| handleSkipToEnd | `MouseEventHandler` | A mouse event handler that will be called when you click on the skip link that takes you to the end of the carousel. |
| nextPage | `MouseEventHandler` | A mouse event handler that will be called when you click on the next button. |
| previousPage | `MouseEventHandler` | A mouse event handler that will be called when you click on the previous button. |
| updateNavControlStates | `() => void` | Updates the state of the navigation controls. |

