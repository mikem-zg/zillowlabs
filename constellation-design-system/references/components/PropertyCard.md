# PropertyCard

```tsx
import { PropertyCard } from '@zillow/constellation';
```

**Version:** 10.11.0 | **Since:** 8.63.0

## Usage

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardBadgeBasic = () => <PropertyCard.Badge>Default</PropertyCard.Badge>;
```

## Examples

### Property Card Action Button

```tsx
import { Menu, PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

const moreMenu = (
  <Menu
    content={
      <>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()} disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
    trigger={<PropertyCard.MenuTrigger onClick={(e) => e.stopPropagation()} />}
  />
);

export const PropertyCardActionButton = () => (
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
    photoBody={
      <PropertyCard.Photo
        src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
        alt="2611 S 2nd St #A, Austin, TX 78704"
      />
    }
    saveButton={
      <PropertyCard.SaveButton
        // oxlint-disable-next-line no-console
        onClick={() => console.log('onClick Save button')}
        // oxlint-disable-next-line no-console
        onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
      />
    }
    actionButton={moreMenu}
  />
);
```

### Property Card Badge Buy Ability

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardBadgeBuyAbility = () => (
  <PropertyCard.Badge tone="buyAbility">BuyAbility</PropertyCard.Badge>
);
```

### Property Card Badge Neutral

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardBadgeNeutral = () => (
  <PropertyCard.Badge tone="neutral">Neutral</PropertyCard.Badge>
);
```

### Property Card Badge Notify

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardBadgeNotify = () => (
  <PropertyCard.Badge tone="notify">Notify</PropertyCard.Badge>
);
```

### Property Card Badge Zillow

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardBadgeZillow = () => (
  <PropertyCard.Badge tone="zillow">Zillow</PropertyCard.Badge>
);
```

### Property Card Basic

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

export const PropertyCardBasic = () => (
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
    photoBody={
      <PropertyCard.Photo
        src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
        alt="2611 S 2nd St #A, Austin, TX 78704"
      />
    }
    saveButton={
      <PropertyCard.SaveButton
        // oxlint-disable-next-line no-console
        onClick={() => console.log('onClick Save button')}
        // oxlint-disable-next-line no-console
        onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
      />
    }
    // oxlint-disable-next-line no-console
    onClick={() => console.log('onClick: Card body')}
    tabIndex={0}
  />
);
```

### Property Card Composed Horizontal

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

export const PropertyCardComposedHorizontal = () => (
  <PropertyCard.Root appearance="horizontal">
    <PropertyCard.Body
      interactive
      tabIndex={0}
      // oxlint-disable-next-line no-console
      onClick={() => console.log('onClick: Card body')}
    >
      <PropertyCard.DataWrapper>
        <PropertyCard.DataArea dataType="dataArea3" asChild>
          <h5>2611 S 2nd St #A, Austin, TX 78704</h5>
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea1">$1,695,000</PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea2">{homeDetailsExample}</PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea4">House for sale</PropertyCard.DataArea>
        <PropertyCard.MLSLogo
          attribution="Listing provided by ABOR"
          logoSrc="https://photos.zillowstatic.com/fp/98ab7c7b2895c2f5f278917766712625-zillow_web_48_23.jpg"
        />
      </PropertyCard.DataWrapper>

      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoHeader>
          <PropertyCard.BadgeArea />
          <PropertyCard.SaveArea>
            <PropertyCard.SaveButton
              // oxlint-disable-next-line no-console
              onClick={() => console.log('onClick Save button')}
              // oxlint-disable-next-line no-console
              onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
            />
          </PropertyCard.SaveArea>
        </PropertyCard.PhotoHeader>

        <PropertyCard.PhotoBody>
          <PropertyCard.Photo
            src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
            alt="2611 S 2nd St #A, Austin, TX 78704"
          />
        </PropertyCard.PhotoBody>
      </PropertyCard.PhotoWrapper>
    </PropertyCard.Body>
    <PropertyCard.DataArea dataType="dataArea5">
      Realty Austin. Listing provided by ABOR lorem ipsum dolor sit amet
    </PropertyCard.DataArea>
  </PropertyCard.Root>
);
```

### Property Card Composed Large

```tsx
import { Button, Menu, PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

const moreMenu = (
  <Menu
    content={
      <>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()} disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
    trigger={<PropertyCard.MenuTrigger onClick={(e) => e.stopPropagation()} />}
  />
);

export const PropertyCardComposedLarge = () => (
  <PropertyCard.Root appearance="large">
    <PropertyCard.Body
      interactive
      tabIndex={0}
      // oxlint-disable-next-line no-console
      onClick={() => console.log('onClick: Card body')}
    >
      <PropertyCard.DataWrapper>
        <PropertyCard.DataArea dataType="dataArea3" asChild>
          <h5>2611 S 2nd St #A, Austin, TX 78704</h5>
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea1">$1,695,000</PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea2">
          {homeDetailsExample}{' '}
          <PropertyCard.DataArea asChild dataType="dataArea4" lineClamp="none">
            <span>House for sale</span>
          </PropertyCard.DataArea>
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea5">
          Realty Austin. Listing provided by ABOR
        </PropertyCard.DataArea>
        <PropertyCard.ActionArea>{moreMenu}</PropertyCard.ActionArea>
      </PropertyCard.DataWrapper>

      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoHeader>
          <PropertyCard.BadgeArea>
            <PropertyCard.Badge>New listing</PropertyCard.Badge>
          </PropertyCard.BadgeArea>
          <PropertyCard.SaveArea>
            <PropertyCard.SaveButton
              // oxlint-disable-next-line no-console
              onClick={() => console.log('onClick Save button')}
              // oxlint-disable-next-line no-console
              onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
            />
          </PropertyCard.SaveArea>
        </PropertyCard.PhotoHeader>

        <PropertyCard.PhotoBody>
          <PropertyCard.Photo
            src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
            alt="2611 S 2nd St #A, Austin, TX 78704"
          />
        </PropertyCard.PhotoBody>

        <PropertyCard.PhotoFooter>
          <PropertyCard.MLSLogo
            attribution="Listing provided by ABOR"
            logoSrc="https://photos.zillowstatic.com/fp/98ab7c7b2895c2f5f278917766712625-zillow_web_48_23.jpg"
          />
        </PropertyCard.PhotoFooter>
      </PropertyCard.PhotoWrapper>

      <PropertyCard.FlexArea>
        <Button
          emphasis="filled"
          fluid
          size="sm"
          onClick={(e) => {
            // oxlint-disable-next-line no-console
            console.log('onClick: Flex button');
            e.stopPropagation();
          }}
        >
          Apply now
        </Button>
      </PropertyCard.FlexArea>
    </PropertyCard.Body>
  </PropertyCard.Root>
);
```

### Property Card Composed Small

```tsx
import { Menu, PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

const moreMenu = (
  <Menu
    content={
      <>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()} disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
    trigger={<PropertyCard.MenuTrigger onClick={(e) => e.stopPropagation()} />}
  />
);

export const PropertyCardComposedSmall = () => (
  <PropertyCard.Root appearance="small">
    <PropertyCard.Body
      interactive
      tabIndex={0}
      // oxlint-disable-next-line no-console
      onClick={() => console.log('onClick: Card body')}
    >
      <PropertyCard.DataWrapper>
        <PropertyCard.DataArea dataType="dataArea3" asChild>
          <h5>2611 S 2nd St #A, Austin, TX 78704</h5>
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea1">$1,695,000</PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea2">{homeDetailsExample}</PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea4">House for sale</PropertyCard.DataArea>
        <PropertyCard.ActionArea>{moreMenu}</PropertyCard.ActionArea>
      </PropertyCard.DataWrapper>

      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoHeader>
          <PropertyCard.BadgeArea />
          <PropertyCard.SaveArea>
            <PropertyCard.SaveButton
              // oxlint-disable-next-line no-console
              onClick={() => console.log('onClick Save button')}
              // oxlint-disable-next-line no-console
              onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
            />
          </PropertyCard.SaveArea>
        </PropertyCard.PhotoHeader>

        <PropertyCard.PhotoBody>
          <PropertyCard.Photo
            src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
            alt="2611 S 2nd St #A, Austin, TX 78704"
          />
        </PropertyCard.PhotoBody>

        <PropertyCard.PhotoFooter>
          <PropertyCard.MLSLogo
            attribution="Listing provided by ABOR"
            logoSrc="https://photos.zillowstatic.com/fp/98ab7c7b2895c2f5f278917766712625-zillow_web_48_23.jpg"
          />
        </PropertyCard.PhotoFooter>
      </PropertyCard.PhotoWrapper>
    </PropertyCard.Body>
    <PropertyCard.DataArea dataType="dataArea5">
      Realty Austin. Listing provided by ABOR lorem ipsum dolor sit amet
    </PropertyCard.DataArea>
  </PropertyCard.Root>
);
```

### Property Card Composed S R P

```tsx
import { Anchor, Menu, PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

const moreMenu = (
  <Menu
    content={
      <>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()} disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
    trigger={<PropertyCard.MenuTrigger onClick={(e) => e.stopPropagation()} />}
  />
);

export const PropertyCardComposedSRP = () => (
  <PropertyCard.Root appearance="large">
    <PropertyCard.Body
      interactive
      // oxlint-disable-next-line no-console
      onClick={() => console.log('onClick: Card body')}
    >
      <PropertyCard.DataWrapper>
        <PropertyCard.DataArea asChild dataType="dataArea3" data-test="property-card-link">
          <Anchor
            css={{ textDecoration: 'none' }}
            href="https://www.zillow.com/homedetails/10-Crestview-Ct-Orinda-CA-94563/18479893_zpid/"
          >
            <address style={{ color: '#2a2a33' }}>2611 S 2nd St #A, Austin, TX 78704</address>
          </Anchor>
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea1">$1,695,000</PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea2">
          {homeDetailsExample}{' '}
          <PropertyCard.DataArea asChild dataType="dataArea4" lineClamp="none">
            <span>House for sale</span>
          </PropertyCard.DataArea>
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea5">
          Realty Austin. Listing provided by ABOR
        </PropertyCard.DataArea>
        <PropertyCard.ActionArea>{moreMenu}</PropertyCard.ActionArea>
      </PropertyCard.DataWrapper>

      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoHeader>
          <PropertyCard.BadgeArea>
            <PropertyCard.Badge>New listing</PropertyCard.Badge>
          </PropertyCard.BadgeArea>
          <PropertyCard.SaveArea>
            <PropertyCard.SaveButton
              // oxlint-disable-next-line no-console
              onClick={() => console.log('onClick Save button')}
              // oxlint-disable-next-line no-console
              onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
            />
          </PropertyCard.SaveArea>
        </PropertyCard.PhotoHeader>

        <PropertyCard.PhotoBody>
          <Anchor href="https://www.zillow.com/homedetails/10-Crestview-Ct-Orinda-CA-94563/18479893_zpid/">
            <PropertyCard.Photo
              src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
              alt="2611 S 2nd St #A, Austin, TX 78704"
            />
          </Anchor>
        </PropertyCard.PhotoBody>

        <PropertyCard.PhotoFooter>
          <PropertyCard.MLSLogo
            attribution="Listing provided by ABOR"
            logoSrc="https://photos.zillowstatic.com/fp/98ab7c7b2895c2f5f278917766712625-zillow_web_48_23.jpg"
          />
        </PropertyCard.PhotoFooter>
      </PropertyCard.PhotoWrapper>
    </PropertyCard.Body>
  </PropertyCard.Root>
);
```

### Property Card Custom Loading Layout

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardCustomLoadingLayout = () => (
  <PropertyCard.Root appearance="large" loading>
    <PropertyCard.Body css={{ gridTemplateRows: '150px 120px' }} onClick={undefined}>
      <PropertyCard.DataWrapper
        css={{
          gridTemplateAreas: `"dataArea2" "dataArea1"`,
        }}
      >
        <PropertyCard.DataArea dataType="dataArea2" css={{ width: '8em' }}>
          &nbsp;
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea1" css={{ width: '80%' }}>
          &nbsp;
        </PropertyCard.DataArea>
      </PropertyCard.DataWrapper>
      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoBody />
      </PropertyCard.PhotoWrapper>
    </PropertyCard.Body>
  </PropertyCard.Root>
);
```

### Property Card Data Area Objects

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

export const PropertyCardDataAreaObjects = () => (
  <PropertyCard
    data={{
      dataArea1: '$1,695,000',
      dataArea2: homeDetailsExample,
      dataArea3: {
        'children': '2611 S 2nd St #A, Austin, TX 78704',
        'data-id': 'sc_address_45',
        'lineClamp': 'none',
      },
      dataArea4: 'House for sale',
      dataArea5: 'Realty Austin',
      mls: {
        attribution: 'Listing provided by ABOR',
        logoSrc:
          'https://photos.zillowstatic.com/fp/98ab7c7b2895c2f5f278917766712625-zillow_web_48_23.jpg',
      },
    }}
    photoBody={
      <PropertyCard.Photo
        src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
        alt="2611 S 2nd St #A, Austin, TX 78704"
      />
    }
    // oxlint-disable-next-line no-console
    onClick={() => console.log('onClick: Card Body')}
    tabIndex={0}
  />
);
```

### Property Card Flex Area

```tsx
import { Button, PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

export const PropertyCardFlexArea = () => (
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
    photoBody={
      <PropertyCard.Photo
        src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
        alt="2611 S 2nd St #A, Austin, TX 78704"
      />
    }
    saveButton={
      <PropertyCard.SaveButton
        // oxlint-disable-next-line no-console
        onClick={() => console.log('onClick Save button')}
        // oxlint-disable-next-line no-console
        onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
      />
    }
    flexArea={
      <Button
        emphasis="filled"
        fluid
        size="sm"
        // oxlint-disable-next-line no-console
        onClick={() => console.log('Flex button click')}
      >
        Apply now
      </Button>
    }
  />
);
```

### Property Card Loading

```tsx
import { Box, PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

const renderExampleCard = ({
  appearance,
  loading,
  badge,
}: {
  appearance: 'large' | 'small' | 'horizontal';
  loading: boolean;
  badge?: null;
}) => (
  <PropertyCard
    appearance={appearance}
    loading={loading}
    badge={
      badge === null ? undefined : (
        <PropertyCard.Badge tone="notify">New listing</PropertyCard.Badge>
      )
    }
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
    photoBody={
      <PropertyCard.Photo
        src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
        alt="2611 S 2nd St #A, Austin, TX 78704"
      />
    }
    saveButton={
      <PropertyCard.SaveButton
        // oxlint-disable-next-line no-console
        onClick={() => console.log('onClick Save button')}
        // oxlint-disable-next-line no-console
        onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
      />
    }
  />
);

export const PropertyCardLoading = () => (
  <Box css={{ display: 'flex', flexDirection: 'row', gap: 'layout.loose' }}>
    {renderExampleCard({ appearance: 'large', loading: true })}
    {renderExampleCard({ appearance: 'small', loading: true })}
    {renderExampleCard({ appearance: 'horizontal', loading: true, badge: null })}
  </Box>
);
```

### Property Card Photo Basic

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardPhotoBasic = () => (
  <PropertyCard.Root appearance="large">
    <PropertyCard.Body>
      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoBody>
          <PropertyCard.Photo
            alt="2611 S 2nd St #A, Austin, TX 78704"
            src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
          />
        </PropertyCard.PhotoBody>
      </PropertyCard.PhotoWrapper>
    </PropertyCard.Body>
  </PropertyCard.Root>
);
```

### Property Card Photo Fallback Image

```tsx
import { Box, PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardPhotoFallbackImage = () => (
  <Box css={{ display: 'flex', flexDirection: 'row', gap: 'lg' }}>
    <PropertyCard.Root appearance="large">
      <PropertyCard.Body>
        <PropertyCard.PhotoWrapper>
          <PropertyCard.PhotoBody>
            <PropertyCard.Photo alt="2611 S 2nd St #A, Austin, TX 78704" src="" />
          </PropertyCard.PhotoBody>
        </PropertyCard.PhotoWrapper>
      </PropertyCard.Body>
    </PropertyCard.Root>

    <PropertyCard.Root appearance="small">
      <PropertyCard.Body>
        <PropertyCard.PhotoWrapper>
          <PropertyCard.PhotoBody>
            <PropertyCard.Photo alt="2611 S 2nd St #A, Austin, TX 78704" src="" />
          </PropertyCard.PhotoBody>
        </PropertyCard.PhotoWrapper>
      </PropertyCard.Body>
    </PropertyCard.Root>

    <PropertyCard.Root appearance="horizontal">
      <PropertyCard.Body>
        <PropertyCard.PhotoWrapper>
          <PropertyCard.PhotoBody>
            <PropertyCard.Photo alt="2611 S 2nd St #A, Austin, TX 78704" src="" />
          </PropertyCard.PhotoBody>
        </PropertyCard.PhotoWrapper>
      </PropertyCard.Body>
    </PropertyCard.Root>
  </Box>
);
```

### Property Card Photo Portrait

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardPhotoPortrait = () => (
  <PropertyCard.Root appearance="large">
    <PropertyCard.Body>
      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoBody>
          <PropertyCard.Photo
            photoOrientation="portrait"
            src="https://wp.zillowstatic.com/1/Chris-Stout-Hazard-c6db41.jpg"
            alt="2611 S 2nd St #A, Austin, TX 78704"
          />
        </PropertyCard.PhotoBody>
      </PropertyCard.PhotoWrapper>
    </PropertyCard.Body>
  </PropertyCard.Root>
);
```

### Property Card Photo Responsive

```tsx
import { PropertyCard } from '@zillow/constellation';
```

```tsx
export const PropertyCardPhotoResponsive = () => (
  <PropertyCard.Root appearance="large">
    <PropertyCard.Body>
      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoBody>
          <PropertyCard.Photo
            srcSet="https://www.zillowstatic.com/bedrock/app/uploads/sites/5/2024/07/image2-sm%401x.jpg 375w, https://www.zillowstatic.com/bedrock/app/uploads/sites/5/2024/07/image2-m%401x.jpg 727w"
            sizes="(max-width: 600px) 375px, 727px"
            src="https://www.zillowstatic.com/bedrock/app/uploads/sites/5/2024/07/image2-m%401x.jpg"
            alt="Agent walking in front of home with couple"
          />
        </PropertyCard.PhotoBody>
      </PropertyCard.PhotoWrapper>
    </PropertyCard.Body>
  </PropertyCard.Root>
);
```

### Property Card Polymorphic Image

```tsx
import { Button, Menu, PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

const moreMenu = (
  <Menu
    content={
      <>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()} disabled>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
        <Menu.Item onClick={(e) => e.stopPropagation()}>
          <Menu.ItemLabel>Action item</Menu.ItemLabel>
        </Menu.Item>
      </>
    }
    trigger={<PropertyCard.MenuTrigger onClick={(e) => e.stopPropagation()} />}
  />
);

export const PropertyCardPolymorphicImage = () => (
  <PropertyCard.Root appearance="large">
    <PropertyCard.Body
      interactive
      tabIndex={0}
      // oxlint-disable-next-line no-console
      onClick={() => console.log('onClick: Card body')}
    >
      <PropertyCard.DataWrapper>
        <PropertyCard.DataArea dataType="dataArea3">
          2611 S 2nd St #A, Austin, TX 78704
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea1">$1,695,000</PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea2">
          {homeDetailsExample}{' '}
          <PropertyCard.DataArea asChild dataType="dataArea4" lineClamp="none">
            <span>House for sale</span>
          </PropertyCard.DataArea>
        </PropertyCard.DataArea>
        <PropertyCard.DataArea dataType="dataArea5">
          Realty Austin. Listing provided by ABOR
        </PropertyCard.DataArea>
        <PropertyCard.ActionArea>{moreMenu}</PropertyCard.ActionArea>
      </PropertyCard.DataWrapper>

      <PropertyCard.PhotoWrapper>
        <PropertyCard.PhotoHeader>
          <PropertyCard.BadgeArea>
            <PropertyCard.Badge>New listing</PropertyCard.Badge>
          </PropertyCard.BadgeArea>
          <PropertyCard.SaveArea>
            <PropertyCard.SaveButton
              // oxlint-disable-next-line no-console
              onClick={() => console.log('onClick Save button')}
              // oxlint-disable-next-line no-console
              onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
            />
          </PropertyCard.SaveArea>
        </PropertyCard.PhotoHeader>

        <PropertyCard.PhotoBody>
          <PropertyCard.Photo asChild>
            <picture>
              <source srcSet="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg" />
              <img
                src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
                alt="2611 S 2nd St #A, Austin, TX 78704"
              />
            </picture>
          </PropertyCard.Photo>
        </PropertyCard.PhotoBody>

        <PropertyCard.PhotoFooter>
          <PropertyCard.MLSLogo asChild>
            <picture>
              <source srcSet="https://photos.zillowstatic.com/fp/98ab7c7b2895c2f5f278917766712625-zillow_web_48_23.jpg" />
              <img
                src="https://photos.zillowstatic.com/fp/98ab7c7b2895c2f5f278917766712625-zillow_web_48_23.jpg"
                alt="Listing provided by ABOR"
              />
            </picture>
          </PropertyCard.MLSLogo>
        </PropertyCard.PhotoFooter>
      </PropertyCard.PhotoWrapper>

      <PropertyCard.FlexArea>
        <Button
          emphasis="filled"
          fluid
          size="sm"
          onClick={(e) => {
            // oxlint-disable-next-line no-console
            console.log('onClick: Flex button');
            e.stopPropagation();
          }}
        >
          Apply now
        </Button>
      </PropertyCard.FlexArea>
    </PropertyCard.Body>
  </PropertyCard.Root>
);
```

### Property Card Sizes

```tsx
import { Box, PropertyCard } from '@zillow/constellation';
```

```tsx
const homeDetailsExample = (
  <PropertyCard.HomeDetails
    data={[
      { value: '4', label: 'bed' },
      { value: '3', label: 'bath' },
      { value: '2,656', label: 'sq. ft.' },
    ]}
  />
);

const renderExampleCard = ({
  appearance,
  badge,
}: {
  appearance: 'large' | 'small' | 'horizontal';
  badge?: React.ReactNode | null;
}) => (
  <PropertyCard
    appearance={appearance}
    badge={
      badge === null ? undefined : (
        <PropertyCard.Badge tone="notify">New listing</PropertyCard.Badge>
      )
    }
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
    photoBody={
      <PropertyCard.Photo
        src="https://photos.zillowstatic.com/fp/e5bc941fae54de5675f724894c151724-cc_ft_1536.jpg"
        alt="2611 S 2nd St #A, Austin, TX 78704"
      />
    }
    saveButton={
      <PropertyCard.SaveButton
        // oxlint-disable-next-line no-console
        onClick={() => console.log('onClick Save button')}
        // oxlint-disable-next-line no-console
        onSelectedChange={(changed) => console.log(`onSelectedChange: ${changed}`)}
      />
    }
  />
);

export const PropertyCardSizes = () => (
  <Box css={{ display: 'flex', flexDirection: 'row', gap: 'layout.loose' }}>
    {renderExampleCard({ appearance: 'large' })}
    {renderExampleCard({ appearance: 'small' })}
    {renderExampleCard({ appearance: 'horizontal', badge: null })}
  </Box>
);
```

## API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `appearance` | `'large' \| 'small' \| 'horizontal'` | — | Determines the overall card style. |
| `asChild` | `boolean` | — | Use child as the root element for polymorphism.  Allows you to render the property card as an element other than `<article>` (default). It's not recommended that you use `asChild` but it's provided here just in case. |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `loading` | `boolean` | `false` | If true, displays the card in a loading state. |
| `actionButton` | `ReactNode` | — | Displays a button in the top right of the data area. Usually a `PropertyCard.SaveButton` or `PropertyCard.MenuPopper`. Cannot be used in a Flag card. |
| `badge` | `ReactNode` | — | Takes a `PropertyCard.Badge` node that will display in the upper-left corner of the photo container. Note that only a Large Card supports displaying a `PropertyCard.Badge` and `PropertyCard.SaveButton` at the same time. |
| `data` | `{     dataArea1?: ReactNode \| (Record<string, unknown> & { children: ReactNode });     dataArea2?: ReactNode \| (Record<string, unknown> & { children: ReactNode });     dataArea3?: ReactNode \| (Record<string, unknown> & { children: ReactNode });     dataArea4?: ReactNode \| (Record<string, unknown> & { children: ReactNode });     dataArea5?: ReactNode \| (Record<string, unknown> & { children: ReactNode });     mls?: {       attribution: string;       logoSrc: string;     };   }` | — | The property info text you’d like to display in the card. The `data` object can include data area properties for each data type: dataArea1, dataArea2, dataArea3, dataArea4, and dataArea5. Each data area property can take a node or a props object. Nodes (including strings) will be rendered as children of a `PropertyCard.DataArea`. A props object will be spread across a `PropertyCard.DataArea` (a `children` property is required). An `mls` property can also be included to display the logo and attribution text for an MLS. |
| `elevated` | `boolean` | `true` | Adds shadow to the card |
| `flexArea` | `ReactNode` | — | Custom content that appears after the data areas. |
| `interactive` | `boolean` | `false` | Adds interactive styling to the card (hover, active, cursor pointer, etc). This is automatically set to `true` if an `onClick` function is defined. To make the card keyboard focusable, you still need to set `tabIndex={0}`. |
| `onClick` | `MouseEventHandler` | — | Executed when you click anywhere on the card (unless you've clicked on an interactive child component) or hit ENTER or SPACE while card has focus. |
| `photoBody` | `ReactNode` | — | Takes a node that will render across the entire width and height of the photo area. Usually, this will be a `PropertyCard.Photo` or a `PhotoCarousel`. |
| `photoFooter` | `ReactNode` | — | By default, the photo footer displays a `PropertyCard.MLSLogo`. To override this, pass a node to this prop. |
| `saveButton` | `ReactNode` | — | Displays a button in the top right of the photo area. Usually a `PropertyCard.SaveButton`. Note that only a Large Card supports displaying a `PropertyCard.Badge` and `PropertyCard.SaveButton` at the same time. |
| `tabIndex` | `number` | — | To make the card keyboard focusable, set to {0}. Usually used alongside `interactive` and `onClick`. For SRP-style cards where the address text is wrapped in an anchor and focusable (for SEO reasons), leave `tabIndex` as undefined or `-1`. This allows keyboard users to tab through the anchors for browsing instead of both the anchors and card bodies. |

### PropertyCardActionArea

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardBadge

**Element:** `HTMLSpanElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content. Can include an `Icon`. **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `lineClamp` | `number \| 'none'` | `1` | Truncates text at the number of lines specified (with ellipses). For no truncation, use `none`. |
| `tone` | `'buyAbility' \| 'default' \| 'neutral' \| 'notify' \| 'zillow'` | `default` | Determines the color of the badge. |

### PropertyCardBadgeArea

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `appearance` | `'large' \| 'small' \| 'horizontal'` | `propertyCardRootContext.appearance \|\| 'large'` | Determines the overall card style. |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |
| `elevated` | `boolean` | `true` | Adds shadow to the card |
| `onClick` | `MouseEventHandler` | — | Since the Property Card body doesn't support being rendered as a button nor an anchor, `onClick` must be used for interactivity (ex: triggering an HDP modal). |
| `interactive` | `boolean` | `false` | Adds interactive styling to the card (hover, active, cursor pointer, etc). This is automatically set to `true` if an `onClick` function is defined. To make the card keyboard focusable, you still need to set `tabIndex={0}`. |
| `role` | `'string'` | `'presentation'` | Defaults to `presentation` as part of the technique to add interactivity to a parent element (PropertyCardRoot) with a non-interactive ARIA role (article). https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/0be7ea95f560c6afc6817d381054d914ebd0b2ca/docs/rules/no-noninteractive-element-interactions.md#case-this-element-is-catching-bubbled-events-from-elements-that-it-contains |
| `tabIndex` | `number` | — | To make the card keyboard focusable, set to {0}. Usually used alongside `interactive` and `onClick`. For SRP-style cards where the address text is wrapped in an anchor and focusable (for SEO reasons), leave `tabIndex` as undefined or `-1`. This allows keyboard users to tab through the anchors for browsing instead of both the anchors and card bodies. |

### PropertyCardDataArea

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `appearance` | `'large' \| 'small' \| 'horizontal'` | `propertyCardRootContext.appearance \|\| 'large'` | The card style. Usually inherited from parent context. Helps determine the data area's text style. |
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `dataType` | `'dataArea1' \| 'dataArea2' \| 'dataArea3' \| 'dataArea4' \| 'dataArea5'` | `dataArea1` | Helps determine the text style and placement. |
| `lineClamp` | `number \| 'none'` | `1` | Truncates text at the number of lines specified (with ellipses). Useful for helping a Property Card maintain a fixed height. For no truncation, use `none`. |
| `loading` | `boolean` | `false` | If true, displays the data area in a loading state. Usually inherited from parent context. |

### PropertyCardDataWrapper

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardFlexArea

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the root element |
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardHomeDetails

**Element:** `HTMLUListElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `data` | `Array<{ value: ReactNode; label: ReactNode; delimiter?: 'pipe' \| 'comma' }>` | — | Renders home details information. `data` takes an array of objects, each with a key/value pair: `[{ value: '4', label: 'bd' }, { value: '3', label: 'ba' }]` `label` and `value` can take a string or a node. You can also leave either one empty. `delimiter` determines the separator character between each home detail. Defaults to 'pipe', which renders a vertical pipe ("\|"). 'comma' can be used to join two related details. Ex: `4 bed \| 3 bath, 2 half bath \| 2,656 sq. ft.` **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardMenuTrigger

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardMLSLogo

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `asChild` | `boolean` | `false` | Use child as the PropertyCard.MLSLogo element |
| `attribution` | `string` | — | The MLS attribution text. Used for alt text. If none provided, uses an empty string instead (''). Ex: alt="Listing provided by NWMLS" |
| `children` | `ReactNode` | — | By default, `PropertyCard.MLSLogo` renders an `Image` component as `children`. Pass `children` your own component to override this. Ex: you need to apply more attributes to the image. |
| `css` | `SystemStyleObject` | — | Styles object |
| `logoSrc` | `string` | — | The URL for the MLS logo. |

### PropertyCardPhoto

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `'alt'` | `string` | — | Alt text for the image. For xDP pages, this is usually set as the property address for SEO purposes. To provide alternative descriptions for screen reader users (ex: detailed image descriptions), use `aria-label`. |
| `'aria-label'` | `AriaAttributes['aria-label']` | — | Provides an accessible label for the image. This can be useful in situations where the `alt` text doesn't provide useful information to screen reader users. The `aria-label` will be applied directly to the `img` element and announced by screen readers instead for the `alt` text. |
| `'asChild'` | `boolean` | `false` | Use child as the PropertyCard.Photo element |
| `'css'` | `SystemStyleObject` | — | Styles object |
| `'draggable'` | `boolean` | — | Indicates whether the image can be dragged, either with native browser behavior or the HTML Drag and Drop API. |
| `'fallbackImg'` | `ReactNode` | — | The image to display if no photo is available. Takes a component that is displayed if no `src` value is provided. |
| `'photoOrientation'` | `'landscape' \| 'portrait'` | — | Determines how to display the photo. Vertically-oriented photos get special treatment to ensure they fill their container. If the photo is square, use ‘portrait’. |
| `'sizes'` | `string` | — | The optional `sizes` of the image to support responsive images. If none is provided, the `sizes` is not rendered. |
| `'src'` | `string` | — | The URL of the property photo, Google Street View image or satellite image. If none is provided, the `fallbackImg` is displayed instead. |
| `'srcSet'` | `string` | — | The optional `scrset` of the image to support responsive images. If none is provided, the `srcset` is not rendered. |

### PropertyCardPhotoBody

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `loading` | `boolean` | `false` | If true, displays the photo body in a loading state. Usually inherited from parent context. |

### PropertyCardPhotoFallback

**Element:** `SVGSVGElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `altText` | `string` | `No image available for this property` | Text that will be read by screenreaders when this image is selected. |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardPhotoFooter

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardPhotoHeader

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardPhotoWrapper

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardRoot

**Element:** `HTMLElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `appearance` | `'large' \| 'small' \| 'horizontal'` | `large` | Determines the overall card style. |
| `asChild` | `boolean` | `false` | Use child as the root element for polymorphism. Allows you to render the property card as an element other than `<article>` (default). It's not recommended that you use `asChild` but it's provided here just in case. |
| `children` | `ReactNode` | — | Content |
| `css` | `SystemStyleObject` | — | Styles object |
| `loading` | `boolean` | `false` | If true, displays the card in a loading state. |

### PropertyCardSaveArea

**Element:** `HTMLDivElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content **(required)** |
| `css` | `SystemStyleObject` | — | Styles object |

### PropertyCardSaveButton

**Element:** `HTMLButtonElement`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `string` | `'Save'` | Provides an accessible label for the button. Renders as visually-hidden text. It's recommended to use the default text ('Save'). Important: the label text should not change when the button's state changes. https://www.w3.org/WAI/ARIA/apg/patterns/button/ |
| `css` | `SystemStyleObject` | — | Styles object |
| `disabled` | `boolean` | `false` | Sets disabled state |
| `onClick` | `MouseEventHandler` | — | Click event handler |
| `onSelectedChange` | `(value: boolean) => void` | — | Event handler called when the selected state of the Save Button changes. |
| `defaultSelected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as an [uncontrolled component](https://reactjs.org/docs/uncontrolled-components.html). A Save Button can use `selected` or `defaultSelected`, but not both. |
| `selected` | `boolean` | — | Sets the [aria-pressed](https://www.w3.org/TR/wai-aria-1.1/#aria-pressed) state and use as a [controlled component](https://reactjs.org/docs/forms.html#controlled-components). A Save Button can use `selected` or `defaultSelected`, but not both. |

