# Migrating Icons: lucide-react/heroicons/MUI/react-icons → Constellation

## Constellation components

```tsx
import { Icon } from '@zillow/constellation';
import {
  IconHeartFilled, IconSearchFilled, IconHomeFilled, IconSettingsFilled,
  IconPersonFilled, IconCloseFilled, IconMenuFilled, IconCheckFilled,
  IconEditFilled, IconDeleteFilled, IconFilterFilled, IconShareFilled,
  IconInfoFilled, IconWarningFilled, IconNotificationFilled, IconCalendarFilled,
  IconClockFilled, IconLocationFilled, IconPhoneFilled, IconEmailFilled,
  IconCameraFilled, IconStarFilled, IconAddFilled, IconMinusFilled,
  IconArrowLeftFilled, IconArrowRightFilled, IconChevronDownFilled,
  IconChevronUpFilled, IconChevronLeftFilled, IconChevronRightFilled,
  IconDownloadFilled, IconUploadFilled, IconSortFilled, IconCopyFilled,
  IconVisibilityFilled, IconVisibilityOffFilled, IconExternalLinkFilled,
  IconErrorFilled, IconBookmarkFilled, IconLockFilled, IconPrintFilled,
  IconRefreshFilled, IconSaveFilled
} from '@zillow/constellation-icons';
```

---

## Icon mapping table

### From lucide-react

| lucide-react | Constellation |
|-------------|---------------|
| `Heart` | `IconHeartFilled` |
| `Search` | `IconSearchFilled` |
| `Home` | `IconHomeFilled` |
| `Settings` | `IconSettingsFilled` |
| `User` | `IconPersonFilled` |
| `X` | `IconCloseFilled` |
| `Menu` | `IconMenuFilled` |
| `Check` | `IconCheckFilled` |
| `Edit` / `Pencil` | `IconEditFilled` |
| `Trash2` / `Trash` | `IconDeleteFilled` |
| `Download` | `IconDownloadFilled` |
| `Upload` | `IconUploadFilled` |
| `Filter` | `IconFilterFilled` |
| `Share2` / `Share` | `IconShareFilled` |
| `Info` | `IconInfoFilled` |
| `AlertTriangle` | `IconWarningFilled` |
| `AlertCircle` | `IconErrorFilled` |
| `Bell` | `IconNotificationFilled` |
| `Calendar` | `IconCalendarFilled` |
| `Clock` | `IconClockFilled` |
| `MapPin` | `IconLocationFilled` |
| `Phone` | `IconPhoneFilled` |
| `Mail` | `IconEmailFilled` |
| `Camera` | `IconCameraFilled` |
| `Star` | `IconStarFilled` |
| `ChevronDown` | `IconChevronDownFilled` |
| `ChevronUp` | `IconChevronUpFilled` |
| `ChevronLeft` | `IconChevronLeftFilled` |
| `ChevronRight` | `IconChevronRightFilled` |
| `ArrowLeft` | `IconArrowLeftFilled` |
| `ArrowRight` | `IconArrowRightFilled` |
| `Plus` | `IconAddFilled` |
| `Minus` | `IconMinusFilled` |
| `Eye` | `IconVisibilityFilled` |
| `EyeOff` | `IconVisibilityOffFilled` |
| `Copy` | `IconCopyFilled` |
| `ExternalLink` | `IconExternalLinkFilled` |
| `Bookmark` | `IconBookmarkFilled` |
| `Lock` | `IconLockFilled` |
| `Printer` | `IconPrintFilled` |
| `RefreshCw` | `IconRefreshFilled` |
| `Save` | `IconSaveFilled` |
| `ArrowUpDown` / `ChevronsUpDown` | `IconSortFilled` |

### From @heroicons/react

| heroicons | Constellation |
|-----------|---------------|
| `HeartIcon` | `IconHeartFilled` |
| `MagnifyingGlassIcon` | `IconSearchFilled` |
| `HomeIcon` | `IconHomeFilled` |
| `Cog6ToothIcon` / `CogIcon` | `IconSettingsFilled` |
| `UserIcon` | `IconPersonFilled` |
| `XMarkIcon` | `IconCloseFilled` |
| `Bars3Icon` | `IconMenuFilled` |
| `CheckIcon` | `IconCheckFilled` |
| `PencilIcon` / `PencilSquareIcon` | `IconEditFilled` |
| `TrashIcon` | `IconDeleteFilled` |
| `FunnelIcon` | `IconFilterFilled` |
| `ShareIcon` | `IconShareFilled` |
| `InformationCircleIcon` | `IconInfoFilled` |
| `ExclamationTriangleIcon` | `IconWarningFilled` |
| `BellIcon` | `IconNotificationFilled` |
| `CalendarIcon` | `IconCalendarFilled` |
| `ClockIcon` | `IconClockFilled` |
| `MapPinIcon` | `IconLocationFilled` |
| `PhoneIcon` | `IconPhoneFilled` |
| `EnvelopeIcon` | `IconEmailFilled` |
| `StarIcon` | `IconStarFilled` |

### From @mui/icons-material

| MUI Icon | Constellation |
|----------|---------------|
| `Favorite` / `FavoriteBorder` | `IconHeartFilled` |
| `Search` | `IconSearchFilled` |
| `Home` | `IconHomeFilled` |
| `Settings` | `IconSettingsFilled` |
| `Person` / `AccountCircle` | `IconPersonFilled` |
| `Close` | `IconCloseFilled` |
| `Menu` | `IconMenuFilled` |
| `Check` / `Done` | `IconCheckFilled` |
| `Edit` | `IconEditFilled` |
| `Delete` | `IconDeleteFilled` |
| `FilterList` | `IconFilterFilled` |
| `Share` | `IconShareFilled` |
| `Info` / `InfoOutlined` | `IconInfoFilled` |
| `Warning` / `WarningAmber` | `IconWarningFilled` |
| `Error` | `IconErrorFilled` |
| `Notifications` | `IconNotificationFilled` |
| `CalendarToday` / `Event` | `IconCalendarFilled` |
| `AccessTime` / `Schedule` | `IconClockFilled` |
| `LocationOn` / `Place` | `IconLocationFilled` |
| `Phone` | `IconPhoneFilled` |
| `Email` / `Mail` | `IconEmailFilled` |
| `CameraAlt` | `IconCameraFilled` |
| `Star` / `StarBorder` | `IconStarFilled` |
| `Add` | `IconAddFilled` |
| `Remove` | `IconMinusFilled` |
| `Visibility` | `IconVisibilityFilled` |
| `VisibilityOff` | `IconVisibilityOffFilled` |
| `ContentCopy` | `IconCopyFilled` |
| `OpenInNew` / `Launch` | `IconExternalLinkFilled` |
| `Sort` | `IconSortFilled` |
| `Bookmark` / `BookmarkBorder` | `IconBookmarkFilled` |
| `Lock` | `IconLockFilled` |
| `Print` | `IconPrintFilled` |
| `Refresh` | `IconRefreshFilled` |
| `Save` | `IconSaveFilled` |

### From react-icons

| react-icons | Constellation |
|-------------|---------------|
| `FaHeart` / `AiFillHeart` | `IconHeartFilled` |
| `FaSearch` / `AiOutlineSearch` | `IconSearchFilled` |
| `FaHome` / `AiFillHome` | `IconHomeFilled` |
| `FaCog` / `AiFillSetting` | `IconSettingsFilled` |
| `FaUser` / `AiOutlineUser` | `IconPersonFilled` |
| `FaTimes` / `AiOutlineClose` | `IconCloseFilled` |
| `FaBars` / `AiOutlineMenu` | `IconMenuFilled` |
| `FaCheck` / `AiOutlineCheck` | `IconCheckFilled` |
| `FaEdit` / `AiFillEdit` | `IconEditFilled` |
| `FaTrash` / `AiFillDelete` | `IconDeleteFilled` |
| `FaFilter` | `IconFilterFilled` |
| `FaShare` / `AiOutlineShareAlt` | `IconShareFilled` |
| `FaInfoCircle` / `AiFillInfoCircle` | `IconInfoFilled` |
| `FaBell` / `AiFillBell` | `IconNotificationFilled` |
| `FaCalendar` / `AiFillCalendar` | `IconCalendarFilled` |
| `FaClock` / `AiFillClockCircle` | `IconClockFilled` |
| `FaMapMarkerAlt` / `MdLocationOn` | `IconLocationFilled` |
| `FaPhone` / `AiFillPhone` | `IconPhoneFilled` |
| `FaEnvelope` / `AiFillMail` | `IconEmailFilled` |
| `FaStar` / `AiFillStar` | `IconStarFilled` |
| `FaPlus` / `AiOutlinePlus` | `IconAddFilled` |
| `FaEye` / `AiFillEye` | `IconVisibilityFilled` |
| `FaEyeSlash` / `AiFillEyeInvisible` | `IconVisibilityOffFilled` |
| `FaCopy` / `AiOutlineCopy` | `IconCopyFilled` |
| `FaExternalLinkAlt` | `IconExternalLinkFilled` |

---

## Before (shadcn/ui + lucide-react)

```tsx
import { Heart, Search, Home, MapPin, Star, Bell, X } from 'lucide-react';

<Heart className="h-5 w-5 text-red-500" />
<Search className="h-4 w-4 text-gray-600" />
<Home className="h-6 w-6" />
<MapPin className="h-4 w-4 text-gray-400" />
<Star className="h-5 w-5 text-yellow-500 fill-yellow-500" />
<Bell className="h-5 w-5" />
<X className="h-4 w-4" onClick={handleClose} />
```

## Before (MUI)

```tsx
import FavoriteIcon from '@mui/icons-material/Favorite';
import SearchIcon from '@mui/icons-material/Search';
import HomeIcon from '@mui/icons-material/Home';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import StarIcon from '@mui/icons-material/Star';
import NotificationsIcon from '@mui/icons-material/Notifications';
import CloseIcon from '@mui/icons-material/Close';

<FavoriteIcon sx={{ color: 'red', fontSize: 20 }} />
<SearchIcon sx={{ color: 'gray', fontSize: 16 }} />
<HomeIcon fontSize="medium" />
<LocationOnIcon sx={{ color: '#999', fontSize: 16 }} />
<StarIcon sx={{ color: '#f59e0b', fontSize: 20 }} />
<NotificationsIcon fontSize="medium" />
<CloseIcon fontSize="small" onClick={handleClose} />
```

## Before (Chakra UI)

```tsx
import { Icon } from '@chakra-ui/react';
import { FaHeart, FaSearch, FaHome, FaMapMarkerAlt, FaStar, FaBell } from 'react-icons/fa';

<Icon as={FaHeart} color="red.500" boxSize={5} />
<Icon as={FaSearch} color="gray.600" boxSize={4} />
<Icon as={FaHome} boxSize={6} />
<Icon as={FaMapMarkerAlt} color="gray.400" boxSize={4} />
<Icon as={FaStar} color="yellow.500" boxSize={5} />
<Icon as={FaBell} boxSize={5} />
```

## Before (Tailwind + HTML)

```tsx
<svg className="h-5 w-5 text-red-500" fill="currentColor" viewBox="0 0 24 24">
  {/* heart path */}
</svg>

<img src="/icons/search.svg" className="h-4 w-4" alt="Search" />

{/* Or with inline SVG */}
<svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-gray-600" viewBox="0 0 24 24" fill="none" stroke="currentColor">
  {/* icon path */}
</svg>
```

---

## After (Constellation)

### Basic icon usage

```tsx
import { Icon } from '@zillow/constellation';
import { IconHeartFilled, IconSearchFilled, IconHomeFilled } from '@zillow/constellation-icons';

<Icon size="md"><IconHeartFilled /></Icon>
<Icon size="md"><IconSearchFilled /></Icon>
<Icon size="md"><IconHomeFilled /></Icon>
```

### Icon with color (use css prop, NOT color prop)

```tsx
<Icon size="md" css={{ color: 'text.action.critical.hero.default' }}>
  <IconHeartFilled />
</Icon>

<Icon size="md" css={{ color: 'text.subtle' }}>
  <IconSearchFilled />
</Icon>

<Icon size="md" css={{ color: 'icon.neutral' }}>
  <IconHomeFilled />
</Icon>

<Icon size="sm" css={{ color: 'text.subtle' }}>
  <IconLocationFilled />
</Icon>

<Icon size="md" css={{ color: 'text.action.brand.hero.default' }}>
  <IconStarFilled />
</Icon>
```

### Fallback — CSS variable (when theme injection unavailable)

```tsx
<Icon size="md" style={{ color: 'var(--color-icon-subtle)' }}>
  <IconSearchFilled />
</Icon>

<Icon size="md" style={{ color: 'var(--color-icon-action-hero-default)' }}>
  <IconHeartFilled />
</Icon>
```

---

## Required rules

- ALWAYS use **Filled** icon variants (`IconHeartFilled`), NEVER Outline as default
- ALWAYS wrap icons in `<Icon size="...">` — size tokens: `sm` (16px), `md` (24px), `lg` (32px), `xl` (48px)
- ALWAYS use `css` prop for color: `css={{ color: 'token.path' }}` — NEVER use `color` prop with token paths
- ALWAYS import icons from `@zillow/constellation-icons`, `Icon` from `@zillow/constellation`
- Theme injection (`injectTheme()`) or `ConstellationProvider` must be set up for semantic tokens to resolve
- Professional apps: use `IconXxxDuotone` variants ONLY for empty states and upsells, `IconXxxFilled` for everything else

---

## Anti-patterns

```tsx
// WRONG — using Outline variant as default
import { IconHeartOutline } from '@zillow/constellation-icons';
<Icon size="md"><IconHeartOutline /></Icon>

// CORRECT — always Filled by default
import { IconHeartFilled } from '@zillow/constellation-icons';
<Icon size="md"><IconHeartFilled /></Icon>
```

```tsx
// WRONG — color prop does NOT accept token paths
<Icon size="md" color="icon.neutral"><IconSearchFilled /></Icon>

// CORRECT — use css prop for semantic tokens
<Icon size="md" css={{ color: 'icon.neutral' }}><IconSearchFilled /></Icon>
```

```tsx
// WRONG — custom pixel sizes
<IconSearchFilled style={{ width: 18, height: 18 }} />

// CORRECT — use Icon wrapper with size token
<Icon size="sm"><IconSearchFilled /></Icon>
```

```tsx
// WRONG — bare icon without Icon wrapper
<IconHomeFilled />

// CORRECT — always wrap in Icon with size
<Icon size="md"><IconHomeFilled /></Icon>
```

```tsx
// WRONG — using icon inside Button with Flex wrapper
<Button>
  <Flex>
    <Icon size="sm"><IconSearchFilled /></Icon>
    <Text>Search</Text>
  </Flex>
</Button>

// CORRECT — use Button's icon and iconPosition props
<Button icon={<IconSearchFilled />} iconPosition="start">
  Search
</Button>
```

---

## Variants

### Size tokens

```tsx
<Icon size="sm"><IconSearchFilled /></Icon>   {/* 16px */}
<Icon size="md"><IconSearchFilled /></Icon>   {/* 24px — default */}
<Icon size="lg"><IconSearchFilled /></Icon>   {/* 32px */}
<Icon size="xl"><IconSearchFilled /></Icon>   {/* 48px — use for simple highlights instead of illustrations */}
```

### Color examples

```tsx
{/* Default (inherits text color) */}
<Icon size="md"><IconHomeFilled /></Icon>

{/* Subtle/muted */}
<Icon size="md" css={{ color: 'text.subtle' }}><IconInfoFilled /></Icon>

{/* Brand/action */}
<Icon size="md" css={{ color: 'text.action.brand.hero.default' }}><IconSearchFilled /></Icon>

{/* Critical/error */}
<Icon size="md" css={{ color: 'text.action.critical.hero.default' }}><IconErrorFilled /></Icon>

{/* Warning */}
<Icon size="md" css={{ color: 'text.action.notify.hero.default' }}><IconWarningFilled /></Icon>
```

### Duotone icons (Professional apps — empty states and upsells only)

```tsx
import { IconHomeDuotone, IconSearchDuotone } from '@zillow/constellation-icons';

{/* Empty state illustration */}
<Icon size="xl"><IconHomeDuotone /></Icon>
```

---

## Edge cases

### Icon in a clickable context (use IconButton)

```tsx
import { IconButton } from '@zillow/constellation';
import { IconCloseFilled } from '@zillow/constellation-icons';

<IconButton tone="neutral" emphasis="secondary" size="md" aria-label="Close">
  <IconCloseFilled />
</IconButton>
```

### Icon next to text (use Flex, not wrapping in Text)

```tsx
import { Flex } from '@/styled-system/jsx';

<Flex align="center" gap="200">
  <Icon size="sm" css={{ color: 'text.subtle' }}><IconLocationFilled /></Icon>
  <Text textStyle="body-sm" css={{ color: 'text.subtle' }}>Seattle, WA</Text>
</Flex>
```

### Heroicons solid vs outline (always map to Filled)

```tsx
// heroicons has /20/solid and /24/outline — ALWAYS map to Filled
// BEFORE
import { HeartIcon } from '@heroicons/react/24/outline';
import { HeartIcon } from '@heroicons/react/20/solid';

// AFTER — both map to Filled
import { IconHeartFilled } from '@zillow/constellation-icons';
<Icon size="md"><IconHeartFilled /></Icon>
```

### Missing icon — no direct equivalent

If no Constellation icon exists for a specific concept, check `@zillow/constellation-icons` exports for the closest match. Use `IconInfoFilled` or a related semantic icon as fallback. Never use raw SVGs or other icon libraries alongside Constellation.
