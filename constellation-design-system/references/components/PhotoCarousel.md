# PhotoCarousel

```tsx
import { PhotoCarousel } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.66.0

## Usage

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselBasic = () => (
  <PhotoCarousel defaultActiveIndex={0} aria-label="Property photos" maxDotsToDisplay={5}>
    <Anchor
      key="photo-1"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
      />
    </Anchor>
    <Anchor
      key="photo-2"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-3"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/0bd51160351eecc3d82276efde87cf8a-cc_ft_576.webp"
      />
    </Anchor>
    <Anchor
      key="photo-4"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/8fe0d4cea23655890c28a24ed535917f-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-5"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/4dde4ead561a8fd6f684a1f5ca2f5764-full.webp"
      />
    </Anchor>
    <Anchor
      key="photo-6"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/fc48caaf7591cd4ac66854cf6d5d8a94-full.webp"
      />
    </Anchor>
    <Anchor
      key="photo-7"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/90fd80d12802cf2594d1fa7ab4a0c59e-full.webp"
      />
    </Anchor>
  </PhotoCarousel>
);
```

## Examples

### Photo Carousel Composed

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselComposed = () => (
  <PhotoCarousel.Root>
    <PhotoCarousel.Dots />
    <PhotoCarousel.NavControls>
      <PhotoCarousel.PreviousButton />
      <PhotoCarousel.NextButton />
    </PhotoCarousel.NavControls>
    <PhotoCarousel.Slides>
      <Anchor
        key="photo-1"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
        />
      </Anchor>
      <Anchor
        key="photo-2"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
        />
      </Anchor>
      <Anchor
        key="photo-3"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/0bd51160351eecc3d82276efde87cf8a-cc_ft_576.webp"
        />
      </Anchor>
      <Anchor
        key="photo-4"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/8fe0d4cea23655890c28a24ed535917f-cc_ft_384.webp"
        />
      </Anchor>
      <Anchor
        key="photo-5"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/4dde4ead561a8fd6f684a1f5ca2f5764-full.webp"
        />
      </Anchor>
      <Anchor
        key="photo-6"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/fc48caaf7591cd4ac66854cf6d5d8a94-full.webp"
        />
      </Anchor>
      <Anchor
        key="photo-7"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/90fd80d12802cf2594d1fa7ab4a0c59e-full.webp"
        />
      </Anchor>
    </PhotoCarousel.Slides>
  </PhotoCarousel.Root>
);
```

### Photo Carousel Controlled

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselControlled = () => {
  const [selected, setSelected] = useState<number>(0);

  const handler = (newIndex: number) => {
    setSelected(newIndex);
  };

  return (
    <PhotoCarousel
      defaultActiveIndex={0}
      aria-label="Property photos"
      maxDotsToDisplay={5}
      activeIndex={selected}
      onActiveIndexChange={handler}
    >
      <Anchor
        key="photo-1"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
        />
      </Anchor>
      <Anchor
        key="photo-2"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
        />
      </Anchor>
      <Anchor
        key="photo-3"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/0bd51160351eecc3d82276efde87cf8a-cc_ft_576.webp"
        />
      </Anchor>
      <Anchor
        key="photo-4"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/8fe0d4cea23655890c28a24ed535917f-cc_ft_384.webp"
        />
      </Anchor>
      <Anchor
        key="photo-5"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/4dde4ead561a8fd6f684a1f5ca2f5764-full.webp"
        />
      </Anchor>
      <Anchor
        key="photo-6"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/fc48caaf7591cd4ac66854cf6d5d8a94-full.webp"
        />
      </Anchor>
      <Anchor
        key="photo-7"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/90fd80d12802cf2594d1fa7ab4a0c59e-full.webp"
        />
      </Anchor>
    </PhotoCarousel>
  );
};
```

### Photo Carousel Image Descriptions For Screen Readers

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselImageDescriptionsForScreenReaders = () => (
  <PhotoCarousel
    renderSlide={({ key, slideProps }) => <PhotoCarousel.Slide key={key} {...slideProps} />}
  >
    <Anchor
      key="photo-1"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        aria-label="A sunroom with floor-to-ceiling windows that extend to the middle of the ceiling. A spiral staircase is attached to the right wall."
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
      />
    </Anchor>
    <Anchor
      key="photo-2"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        aria-label="An enclosed patio with floor-to-ceiling windows and hammocks."
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-3"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        aria-label="An alternative view of the sunroom."
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/0bd51160351eecc3d82276efde87cf8a-cc_ft_576.webp"
      />
    </Anchor>
  </PhotoCarousel>
);
```

### Photo Carousel No Looping

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselNoLooping = () => (
  <PhotoCarousel
    defaultActiveIndex={0}
    aria-label="Property photos"
    maxDotsToDisplay={5}
    shouldLoop={false}
  >
    <Anchor
      key="photo-1"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
      />
    </Anchor>
    <Anchor
      key="photo-2"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-3"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/0bd51160351eecc3d82276efde87cf8a-cc_ft_576.webp"
      />
    </Anchor>
    <Anchor
      key="photo-4"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/8fe0d4cea23655890c28a24ed535917f-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-5"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/4dde4ead561a8fd6f684a1f5ca2f5764-full.webp"
      />
    </Anchor>
    <Anchor
      key="photo-6"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/fc48caaf7591cd4ac66854cf6d5d8a94-full.webp"
      />
    </Anchor>
    <Anchor
      key="photo-7"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/90fd80d12802cf2594d1fa7ab4a0c59e-full.webp"
      />
    </Anchor>
  </PhotoCarousel>
);
```

### Photo Carousel Number Of Dots To Display

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselNumberOfDotsToDisplay = () => (
  <PhotoCarousel defaultActiveIndex={0} aria-label="Property photos" maxDotsToDisplay={3}>
    <Anchor
      key="photo-1"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
      />
    </Anchor>
    <Anchor
      key="photo-2"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-3"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/0bd51160351eecc3d82276efde87cf8a-cc_ft_576.webp"
      />
    </Anchor>
    <Anchor
      key="photo-4"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/8fe0d4cea23655890c28a24ed535917f-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-5"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/4dde4ead561a8fd6f684a1f5ca2f5764-full.webp"
      />
    </Anchor>
    <Anchor
      key="photo-6"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/fc48caaf7591cd4ac66854cf6d5d8a94-full.webp"
      />
    </Anchor>
    <Anchor
      key="photo-7"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/90fd80d12802cf2594d1fa7ab4a0c59e-full.webp"
      />
    </Anchor>
  </PhotoCarousel>
);
```

### Photo Carousel One Slide

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselOneSlide = () => (
  <PhotoCarousel>
    <Anchor href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/">
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
      />
    </Anchor>
  </PhotoCarousel>
);
```

### Photo Carousel Render Props

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselRenderProps = () => (
  <PhotoCarousel
    renderDot={({ key, dotProps }) => (
      <PhotoCarousel.Dot key={key} {...dotProps} data-testid={`dot-${key}`} />
    )}
    renderSlide={({ key, slideProps }) => (
      <PhotoCarousel.Slide key={key} {...slideProps} data-testid={`slide-${key}`} />
    )}
  >
    <Anchor
      key="photo-1"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
      />
    </Anchor>
    <Anchor
      key="photo-2"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-3"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/0bd51160351eecc3d82276efde87cf8a-cc_ft_576.webp"
      />
    </Anchor>
    <Anchor
      key="photo-4"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/8fe0d4cea23655890c28a24ed535917f-cc_ft_384.webp"
      />
    </Anchor>
    <Anchor
      key="photo-5"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/4dde4ead561a8fd6f684a1f5ca2f5764-full.webp"
      />
    </Anchor>
    <Anchor
      key="photo-6"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/fc48caaf7591cd4ac66854cf6d5d8a94-full.webp"
      />
    </Anchor>
    <Anchor
      key="photo-7"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/90fd80d12802cf2594d1fa7ab4a0c59e-full.webp"
      />
    </Anchor>
  </PhotoCarousel>
);
```

### Photo Carousel With CTA Slide

```tsx
import { Anchor, Box, Button, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselWithCTASlide = () => {
  return (
    <PhotoCarousel>
      <Anchor
        key="photo-1"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
        />
      </Anchor>
      <Anchor
        key="photo-2"
        href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
      >
        <PropertyCard.Photo
          alt="2611 S 2nd St #A, Austin, TX 78704"
          src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
        />
      </Anchor>
      <Box
        key="cta-slide"
        css={{
          alignItems: 'center',
          backgroundColor: 'bg.accent.aqua.soft',
          display: 'flex',
          height: '100%',
          justifyContent: 'center',
        }}
      >
        <Button>View all photos</Button>
      </Box>
    </PhotoCarousel>
  );
};
```

### Photo Carousel With Property Card

```tsx
import { Anchor, PhotoCarousel, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PhotoCarouselWithPropertyCard = () => {
  const slides = [
    <Anchor
      key="photo-1"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/cee39698e5894fc981084ef6d6fbb082-cc_ft_768.webp"
      />
    </Anchor>,
    <Anchor
      key="photo-2"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/fd035f8ef62b9fbeb068cc79592400cc-cc_ft_384.webp"
      />
    </Anchor>,
    <Anchor
      key="photo-3"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/0bd51160351eecc3d82276efde87cf8a-cc_ft_576.webp"
      />
    </Anchor>,
    <Anchor
      key="photo-4"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://photos.zillowstatic.com/fp/8fe0d4cea23655890c28a24ed535917f-cc_ft_384.webp"
      />
    </Anchor>,
    <Anchor
      key="photo-5"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/4dde4ead561a8fd6f684a1f5ca2f5764-full.webp"
      />
    </Anchor>,
    <Anchor
      key="photo-6"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/fc48caaf7591cd4ac66854cf6d5d8a94-full.webp"
      />
    </Anchor>,
    <Anchor
      key="photo-7"
      href="https://www.zillow.com/homedetails/2611-S-2nd-St-A-Austin-TX-78704/2069113063_zpid/"
    >
      <PropertyCard.Photo
        alt="2611 S 2nd St #A, Austin, TX 78704"
        src="https://www.trulia.com/pictures/thumbs_3/zillowstatic/fp/90fd80d12802cf2594d1fa7ab4a0c59e-full.webp"
      />
    </Anchor>,
  ];

  const homeDetailsExample = (
    <PropertyCard.HomeDetails
      data={[
        { value: '4', label: 'bed' },
        { value: '3', label: 'bath' },
        { value: '2,656', label: 'sq. ft.' },
      ]}
    />
  );

  return (
    <PropertyCard
      badge={<PropertyCard.Badge tone="notify">New listing</PropertyCard.Badge>}
      data={{
        dataArea1: '$1,695,000',
        dataArea2: homeDetailsExample,
        dataArea3: '2611 S 2nd St #A, Austin, TX 78704',
        dataArea4: 'House for sale',
        dataArea5: 'Realty Austin',
        mls: {
          attribution: 'Listing provided by ABOR',
          logoSrc:
            'https://photos.zillowstatic.com/fp/98ab7c7b2895c2f5f278917766712625-zillow_web_48_23.jpg',
        },
      }}
      photoBody={<PhotoCarousel>{slides}</PhotoCarousel>}
      saveButton={
        <PropertyCard.SaveButton
          // oxlint-disable-next-line no-console
          onClick={() => {
            // oxlint-disable-next-line no-console
            console.log('onClick Save button');
          }}
          onSelectedChange={(changed) => {
            // oxlint-disable-next-line no-console
            console.log(`onSelectedChange: ${changed}`);
          }}
        />
      }
    />
  );
};
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'activeIndex'` | `number` | — | The index of the slide you want to display when using this as an [controlled component](https://reactjs.org/docs/forms.html#controlled-components).  A carousel can set `activeIndex` or `defaultActiveIndex`, but not both. |
| `'aria-label'` | `string` | `'Property photos'` | Announced by some screen readers when you first enter the carousel. |
| `'children'` | `ReactNode` | — | Content |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'defaultActiveIndex'` | `number` | — | The index of the slide you want to display on initial render when using this as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html).  A carousel can set `activeIndex` or `defaultActiveIndex`, but not both. |
| `'onActiveIndexChange'` | `(newIndex: number) => void` | — | Callback that's executed every time the slide changes. Takes the new slide index as an arg. |
| `'shouldAwaitInteractionResponse'` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `'shouldLoop'` | `boolean` | `true` | When true, users are able to navigate past the last slide and loop back to the first slide. Similarly, navigating before the first slide will loop them back to the last slide. |
| `renderSlide` | `(props: {     slideProps: Partial<PhotoCarouselSlidePropsInterface>;     key: Key;   }) => ReactNode` | `({ key, slideProps }) => (   <PhotoCarouselSlide key={key} {...slideProps} /> )` | Called when rendering individual slides. |

### PhotoCarouselDot

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'aria-label'` | `AriaAttributes['aria-label']` | — | Provides an accessible label that is announced by screen readers when this component receives keyboard focus. This is set by `PhotoCarousel.Dots`. |
| `'aria-controls'` | `AriaAttributes['aria-controls']` | — | The ID of the `PhotoCarousel.Slide`. This is usually provided via context. |
| `'aria-selected'` | `AriaAttributes['aria-selected']` | — | If true, the dot is rendered larger to represent the active slide. |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'isContinuation'` | `boolean` | `false` | Set by the `use-dots-range` hook. If true, the dot is rendered smaller to give visual affordance that there are more slides beyond it. |
| `'isHidden'` | `boolean` | — | If true, the dot is hidden. |

### PhotoCarouselDots

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'activeIndex'` | `number` | `0` | The index of the active slide. Usually provided via context. |
| `'aria-label'` | `AriaAttributes['aria-label']` | `'Slides'` | Provides an accessible label that is announced by screen readers when this component receives keyboard focus. |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'maxDotsToDisplay'` | `number` | `5` | The maximum number of dots to display. |
| `'onKeyDown'` | `KeyboardEventHandler` | — | Called when the user presses a key while the dots have focus. The callback is passed a KeyboardEvent object as its only argument. Primarily used to assist with navigation by screen readers and other assitive technologies. |
| `'totalSlides'` | `number` | `0` | The total number of slides in the carousel. |
| `'renderDot'` | `(props: {     dotProps: Partial<PhotoCarouselDotPropsInterface>;     key: Key;   }) => ReactNode` | `({ key, dotProps }) => (   <PhotoCarouselDot key={key} {...dotProps} /> )` | Called when rendering individual dots. |

### PhotoCarouselNavControls

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |

### PhotoCarouselNextButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `(       <Icon>         <IconChevronRightFilled />       </Icon>     )` | The button's content, defaults to an icon |
| `css` | `SystemStyleObject` | — | Styles object |
| `title` | `IconButtonPropsInterface['title']` | `'Next photo'` | Accessible text of the button |

### PhotoCarouselPreviousButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | `(       <Icon>         <IconChevronLeftFilled />       </Icon>     )` | The button's content, defaults to an icon |
| `css` | `SystemStyleObject` | — | Styles object |
| `title` | `IconButtonPropsInterface['title']` | `'Previous photo'` | Accessible text of the button |

### PhotoCarouselRoot

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'activeIndex'` | `number` | — | The index of the slide you want to display when using this as an [controlled component](https://reactjs.org/docs/forms.html#controlled-components). A carousel can set `activeIndex` or `defaultActiveIndex`, but not both. |
| `'aria-label'` | `string` | `'Property photos'` | Announced by some screen readers when you first enter the carousel. |
| `'children'` | `ReactNode` | — | Content |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'defaultActiveIndex'` | `number` | — | The index of the slide you want to display on initial render when using this as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). A carousel can set `activeIndex` or `defaultActiveIndex`, but not both. |
| `'onActiveIndexChange'` | `(newIndex: number) => void` | — | Callback that's executed every time the slide changes. Takes the new slide index as an arg. |
| `'shouldAwaitInteractionResponse'` | `boolean` | `true` | Improve INP score by interrupting the main thread with interaction response. You might need to opt-out if you require a reliable access to the `event` object. |
| `'shouldLoop'` | `boolean` | `true` | When true, users are able to navigate past the last slide and loop back to the first slide. Similarly, navigating before the first slide will loop them back to the last slide. |

### PhotoCarouselSlide

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |
| `shouldAnimateTranslations` | `boolean` | `true` | If true, the sliding animation is enabled. |
| `slidePosition` | `'left' \| 'center' \| 'right'` | — | Photo Carousel only renders up to three slides at a time. This prop dictates where this slide is located. The center slide is the one currently visible. |

### PhotoCarouselSlides

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `activeIndex` | `number` | `0` | The index of the active slide. Usually provided via context. |
| `children` | `ReactNode` | — | The slide content you want to display. Each child will be wrapped inside of a `PhotoCarousel.Slide`. |
| `css` | `SystemStyleObject` | — | Styles object |
| `onSwiped` | `SwipeCallback` | — | Callback invoked after any swipe. Called with a [`SwipeEventData` object](https://commerce.nearform.com/open-source/react-swipeable/docs/api#swipe-event-data) as an arg. |
| `onSwiping` | `SwipeCallback` | — | Callback invoked during swiping. Called with a [`SwipeEventData` object](https://commerce.nearform.com/open-source/react-swipeable/docs/api#swipe-event-data) as an arg. |
| `renderSlide` | `(props: {     slideProps: Partial<PhotoCarouselSlidePropsInterface>;     key: Key;   }) => ReactNode` | `({ key, slideProps }) => (   <PhotoCarouselSlide key={key} {...slideProps} /> )` | Called when rendering individual slides. |
| `shouldAnimateTranslations` | `boolean` | `true` | If true, the sliding animation is enabled. |
| `totalSlides` | `number` | `0` | The total number of slides in the carousel. Usually inherited from parent context. |

