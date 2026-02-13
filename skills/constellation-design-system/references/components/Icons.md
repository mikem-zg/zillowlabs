# Icons

```tsx
import { IconHeartFilled, IconSearchFilled } from '@zillow/constellation-icons';
import { Icon } from '@zillow/constellation';
```

**Total icons:** 621

## Usage

```tsx
// Always wrap icons in the Icon component with a size token
<Icon size="md"><IconHeartFilled /></Icon>

// For semantic colors, use the css prop (NOT color prop)
<Icon size="md" css={{ color: 'icon.neutral' }}><IconHeartFilled /></Icon>

// Size tokens: sm (16px), md (24px), lg (32px), xl (44px)
<Icon size="sm"><IconSearchFilled /></Icon>
<Icon size="lg"><IconHomeFilled /></Icon>
```

## Important Rules

- **ALWAYS** use Filled variants by default (`IconHeartFilled`, not `IconHeartOutline`)
- **ALWAYS** wrap in `<Icon size="...">` with size tokens (sm/md/lg/xl)
- **NEVER** use random pixel sizes or inline styles for sizing
- For two-tone decorative illustrations, see [Illustrations](Illustrations.md)
- Use `css={{ color: 'token' }}` for semantic colors, NOT the `color` prop

## Styles

| Style | Count | Usage |
|-------|-------|-------|
| Filled | 302 | Default style for all UI |
| Outline | 302 | Secondary/inactive states |
| DuoColor | — | See [Illustrations](Illustrations.md) |
| Other | 17 | Special icons |

## Icon Metadata Example

**IconHeartFilled** — "Heart" | Style: Filled | Categories: ui, actions | Search terms: favorite, save, like

**IconSearchFilled** — "Search" | Style: Filled | Categories: ui, actions | Search terms: search

## All Filled Icons (302)

`IconAIMagicFilled`, `IconAirConditioningFilled`, `IconAirQualityFilled`, `IconAppDownloadFilled`
`IconAppHeartFilled`, `IconArchiveFilled`, `IconArrowDownCircleFilled`, `IconArrowDownFilled`
`IconArrowLeftCircleFilled`, `IconArrowLeftFilled`, `IconArrowRightCircleFilled`, `IconArrowRightFilled`
`IconArrowUpCircleFilled`, `IconArrowUpFilled`, `IconAttachmentFilled`, `IconAutofillFilled`
`IconAwardRibbonFilled`, `IconBankFilled`, `IconBathroomFilled`, `IconBatteryFullFilled`
`IconBatteryHalfFilled`, `IconBatteryLowFilled`, `IconBeachFilled`, `IconBeautySpaFilled`
`IconBedroomFilled`, `IconBikeFilled`, `IconBlueprintFilled`, `IconBuildingFilled`
`IconBuildingsFilled`, `IconBusFilled`, `IconBusSideFilled`, `IconCafeFilled`
`IconCalculatorFilled`, `IconCalendarClockFilled`, `IconCalendarFilled`, `IconCameraExposureFilled`
`IconCameraFilled`, `IconCameraGridFilled`, `IconCameraShutterFilled`, `IconCarFilled`
`IconCarSideFilled`, `IconCatFilled`, `IconCheckedBoxFilled`, `IconChecklistEmptyFilled`
`IconChecklistFilled`, `IconCheckmarkCircleFilled`, `IconCheckmarkFilled`, `IconChevronDownCircleFilled`
`IconChevronDownFilled`, `IconChevronLeftCircleFilled`, `IconChevronLeftFilled`, `IconChevronRightCircleFilled`
`IconChevronRightFilled`, `IconChevronUpCircleFilled`, `IconChevronUpFilled`, `IconCircleFilled`
`IconClapFilled`, `IconClockFilled`, `IconCloseCircleFilled`, `IconCloseFilled`
`IconCognitiveProtectionFilled`, `IconCollapseFilled`, `IconColorPickerFilled`, `IconCompassFilled`
`IconConcealFilled`, `IconCoolingFilled`, `IconCopyFilled`, `IconCreditCardFilled`
`IconCreditScoreFilled`, `IconCrownFilled`, `IconDeleteFilled`, `IconDiningRoomFilled`
`IconDirectionsFilled`, `IconDogLargeFilled`, `IconDogSmallFilled`, `IconDollarSignCircleFilled`
`IconDoorOpenFilled`, `IconDownloadFilled`, `IconDrawFilled`, `IconEHOFilled`
`IconEditFilled`, `IconEditFormFilled`, `IconElectricityFilled`, `IconEntertainmentFilled`
`IconErrorFilled`, `IconExclamationCircleFilled`, `IconExpandFilled`, `IconExternalFilled`
`IconFactsFeaturesFilled`, `IconFileCSVFilled`, `IconFileFilled`, `IconFileMergeFilled`
`IconFilePDFFilled`, `IconFileSplitFilled`, `IconFileSpreadsheetFilled`, `IconFileTextFilled`
`IconFilterFilled`, `IconFingerDrawFilled`, `IconFireFilled`, `IconFireplaceFilled`
`IconFlagFilled`, `IconFlagPointedFilled`, `IconFloodFilled`, `IconFloorPlanFilled`
`IconFolderFilled`, `IconFullScreenFilled`, `IconGasStationFilled`, `IconGiftFilled`
`IconGlobeFilled`, `IconGridFilled`, `IconGroceryStoreFilled`, `IconGymFilled`
`IconHDRFilled`, `IconHOAFilled`, `IconHammerFilled`, `IconHandshakeFilled`
`IconHardHatFilled`, `IconHearingAidFilled`, `IconHeartFilled`, `IconHeatFilled`
`IconHeatingFilled`, `IconHideFilled`, `IconHighFiveFilled`, `IconHomeCompareFilled`
`IconHomeSimilarFilled`, `IconHomeTypeFilled`, `IconHomesFilled`, `IconHospitalFilled`
`IconHourglassFilled`, `IconHouseClockFilled`, `IconHouseFilled`, `IconHouseHeartFilled`
`IconHouseUserFilled`, `IconISOFilled`, `IconIdBadgeFilled`, `IconIdCardFilled`
`IconInboxFilled`, `IconInfoFilled`, `IconInitialsFilled`, `IconKeyFilled`
`IconKeyboardFilled`, `IconKitchenFilled`, `IconLaptopFilled`, `IconLaundromatFilled`
`IconLaundryFilled`, `IconLayersFilled`, `IconLeafFilled`, `IconLightBulbFilled`
`IconLightningFilled`, `IconLinkBrokenFilled`, `IconLinkFilled`, `IconListBulletedFilled`
`IconListNumberedFilled`, `IconLiveBroadcastFilled`, `IconLivingRoomFilled`, `IconLocationArrowFilled`
`IconLocationFilled`, `IconLockClosedFilled`, `IconLockOpenFilled`, `IconLongPressFilled`
`IconLotSizeFilled`, `IconMLSFilled`, `IconMailFilled`, `IconManufacturedFilled`
`IconMapDrawFilled`, `IconMapFilled`, `IconMedicalFacilityFilled`, `IconMegaphoneFilled`
`IconMenuFilled`, `IconMessageFilled`, `IconMessageHeartFilled`, `IconMessagePlusFilled`
`IconMessageQuestionFilled`, `IconMicrophoneFilled`, `IconMinusCircleFilled`, `IconMinusFilled`
`IconMonitorFilled`, `IconMoreFilled`, `IconMoreVerticalFilled`, `IconMousePointerFilled`
`IconMovingTruckFilled`, `IconMultiFamilyFilled`, `IconNightLifeFilled`, `IconNoPetsFilled`
`IconNoteFilled`, `IconNotePlusFilled`, `IconNotificationFilled`, `IconPaintRollerFilled`
`IconPanelLeftCloseFilled`, `IconPanelLeftOpenFilled`, `IconPanorama360Filled`, `IconPanoramaFilled`
`IconParkingFilled`, `IconPasteFilled`, `IconPatioFilled`, `IconPauseCircleFilled`
`IconPauseFilled`, `IconPedestrianFilled`, `IconPetsFilled`, `IconPharmacyFilled`
`IconPhoneCircleFilled`, `IconPhoneFilled`, `IconPhotosFilled`, `IconPiggyBankFilled`
`IconPlayCircleFilled`, `IconPlayFilled`, `IconPlusCircleFilled`, `IconPlusFilled`
`IconPointerDownFilled`, `IconPointerUpFilled`, `IconPriceSqftFilled`, `IconPrintFilled`
`IconProfessionalFilled`, `IconProfileFilled`, `IconPublicTransitFilled`, `IconQuestionMarkCircleFilled`
`IconQuoteFilled`, `IconRadioButtonFilled`, `IconRateHappyFilled`, `IconRateOkFilled`
`IconRateUnhappyFilled`, `IconRateVeryHappyFilled`, `IconRateVeryUnhappyFilled`, `IconRecreationFilled`
`IconRedoFilled`, `IconReloadFilled`, `IconRenameFilled`, `IconReorderFilled`
`IconReplyFilled`, `IconRestaurantFilled`, `IconRestoreMailFilled`, `IconRevealFilled`
`IconRotateClockwiseFilled`, `IconRotateCounterClockwiseFilled`, `IconSchoolAlternateFilled`, `IconSchoolFilled`
`IconSearchFilled`, `IconSearchHeartFilled`, `IconSendFilled`, `IconSettingsFilled`
`IconShareWebFilled`, `IconShieldCheckmarkFilled`, `IconShieldFilled`, `IconShoppingFilled`
`IconShovelFilled`, `IconSignatureFilled`, `IconSmartphoneFilled`, `IconSortAscendingFilled`
`IconSortDescendingFilled`, `IconSortFilled`, `IconSpamFolderFilled`, `IconSparkleFilled`
`IconSquareFeetFilled`, `IconStopFilled`, `IconStreetViewFilled`, `IconSwipeFilled`
`IconSyncFilled`, `IconTabletFilled`, `IconTagDollarSignFilled`, `IconTagFilled`
`IconTargetFilled`, `IconTaxFilled`, `IconTeaFilled`, `IconTextAlignCenterFilled`
`IconTextAlignLeftFilled`, `IconTextAlignRightFilled`, `IconTextBoldFilled`, `IconTextColorFilled`
`IconTextItalicsFilled`, `IconTextUnderlinedFilled`, `IconThreeDimensionalFilled`, `IconThumbsDownFilled`
`IconThumbsUpFilled`, `IconTourDoorFilled`, `IconTownhouseFilled`, `IconTreeBenchFilled`
`IconTreesEvergreenFilled`, `IconTreesFilled`, `IconTrendingFilled`, `IconTrophyFilled`
`IconUnconstrainedFlyOverFilled`, `IconUnconstrainedWalkThroughFilled`, `IconUndoFilled`, `IconUploadFilled`
`IconUserAddFilled`, `IconUserFilled`, `IconUserGroupFilled`, `IconUserSettingsFilled`
`IconVideoCameraFilled`, `IconVideoPlayFilled`, `IconVolumeFilled`, `IconVolumeLowFilled`
`IconVolumeMidFilled`, `IconVolumeMutedFilled`, `IconWarningFilled`, `IconWaterFilled`
`IconWhiteBalanceFilled`, `IconWindFilled`, `IconWrenchFilled`, `IconYardSignFilled`
`IconZoomInFilled`, `IconZoomOutFilled`

## All Outline Icons (302)

`IconAIMagicOutline`, `IconAirConditioningOutline`, `IconAirQualityOutline`, `IconAppDownloadOutline`
`IconAppHeartOutline`, `IconArchiveOutline`, `IconArrowDownCircleOutline`, `IconArrowDownOutline`
`IconArrowLeftCircleOutline`, `IconArrowLeftOutline`, `IconArrowRightCircleOutline`, `IconArrowRightOutline`
`IconArrowUpCircleOutline`, `IconArrowUpOutline`, `IconAttachmentOutline`, `IconAutofillOutline`
`IconAwardRibbonOutline`, `IconBankOutline`, `IconBathroomOutline`, `IconBatteryFullOutline`
`IconBatteryHalfOutline`, `IconBatteryLowOutline`, `IconBeachOutline`, `IconBeautySpaOutline`
`IconBedroomOutline`, `IconBikeOutline`, `IconBlueprintOutline`, `IconBuildingOutline`
`IconBuildingsOutline`, `IconBusOutline`, `IconBusSideOutline`, `IconCafeOutline`
`IconCalculatorOutline`, `IconCalendarClockOutline`, `IconCalendarOutline`, `IconCameraExposureOutline`
`IconCameraGridOutline`, `IconCameraOutline`, `IconCameraShutterOutline`, `IconCarOutline`
`IconCarSideOutline`, `IconCatOutline`, `IconCheckedBoxOutline`, `IconChecklistEmptyOutline`
`IconChecklistOutline`, `IconCheckmarkCircleOutline`, `IconCheckmarkOutline`, `IconChevronDownCircleOutline`
`IconChevronDownOutline`, `IconChevronLeftCircleOutline`, `IconChevronLeftOutline`, `IconChevronRightCircleOutline`
`IconChevronRightOutline`, `IconChevronUpCircleOutline`, `IconChevronUpOutline`, `IconCircleOutline`
`IconClapOutline`, `IconClockOutline`, `IconCloseCircleOutline`, `IconCloseOutline`
`IconCognitiveProtectionOutline`, `IconCollapseOutline`, `IconColorPickerOutline`, `IconCompassOutline`
`IconConcealOutline`, `IconCoolingOutline`, `IconCopyOutline`, `IconCreditCardOutline`
`IconCreditScoreOutline`, `IconCrownOutline`, `IconDeleteOutline`, `IconDiningRoomOutline`
`IconDirectionsOutline`, `IconDogLargeOutline`, `IconDogSmallOutline`, `IconDollarSignCircleOutline`
`IconDoorOpenOutline`, `IconDownloadOutline`, `IconDrawOutline`, `IconEHOOutline`
`IconEditFormOutline`, `IconEditOutline`, `IconElectricityOutline`, `IconEntertainmentOutline`
`IconErrorOutline`, `IconExclamationCircleOutline`, `IconExpandOutline`, `IconExternalOutline`
`IconFactsFeaturesOutline`, `IconFileCSVOutline`, `IconFileMergeOutline`, `IconFileOutline`
`IconFilePDFOutline`, `IconFileSplitOutline`, `IconFileSpreadsheetOutline`, `IconFileTextOutline`
`IconFilterOutline`, `IconFingerDrawOutline`, `IconFireOutline`, `IconFireplaceOutline`
`IconFlagOutline`, `IconFlagPointedOutline`, `IconFloodOutline`, `IconFloorPlanOutline`
`IconFolderOutline`, `IconFullScreenOutline`, `IconGasStationOutline`, `IconGiftOutline`
`IconGlobeOutline`, `IconGridOutline`, `IconGroceryStoreOutline`, `IconGymOutline`
`IconHDROutline`, `IconHOAOutline`, `IconHammerOutline`, `IconHandshakeOutline`
`IconHardHatOutline`, `IconHearingAidOutline`, `IconHeartOutline`, `IconHeatOutline`
`IconHeatingOutline`, `IconHideOutline`, `IconHighFiveOutline`, `IconHomeCompareOutline`
`IconHomeSimilarOutline`, `IconHomeTypeOutline`, `IconHomesOutline`, `IconHospitalOutline`
`IconHourglassOutline`, `IconHouseClockOutline`, `IconHouseHeartOutline`, `IconHouseOutline`
`IconHouseUserOutline`, `IconISOOutline`, `IconIdBadgeOutline`, `IconIdCardOutline`
`IconInboxOutline`, `IconInfoOutline`, `IconInitialsOutline`, `IconKeyOutline`
`IconKeyboardOutline`, `IconKitchenOutline`, `IconLaptopOutline`, `IconLaundromatOutline`
`IconLaundryOutline`, `IconLayersOutline`, `IconLeafOutline`, `IconLightBulbOutline`
`IconLightningOutline`, `IconLinkBrokenOutline`, `IconLinkOutline`, `IconListBulletedOutline`
`IconListNumberedOutline`, `IconLiveBroadcastOutline`, `IconLivingRoomOutline`, `IconLocationArrowOutline`
`IconLocationOutline`, `IconLockClosedOutline`, `IconLockOpenOutline`, `IconLongPressOutline`
`IconLotSizeOutline`, `IconMLSOutline`, `IconMailOutline`, `IconManufacturedOutline`
`IconMapDrawOutline`, `IconMapOutline`, `IconMedicalFacilityOutline`, `IconMegaphoneOutline`
`IconMenuOutline`, `IconMessageHeartOutline`, `IconMessageOutline`, `IconMessagePlusOutline`
`IconMessageQuestionOutline`, `IconMicrophoneOutline`, `IconMinusCircleOutline`, `IconMinusOutline`
`IconMonitorOutline`, `IconMoreOutline`, `IconMoreVerticalOutline`, `IconMousePointerOutline`
`IconMovingTruckOutline`, `IconMultiFamilyOutline`, `IconNightLifeOutline`, `IconNoPetsOutline`
`IconNoteOutline`, `IconNotePlusOutline`, `IconNotificationOutline`, `IconPaintRollerOutline`
`IconPanelLeftCloseOutline`, `IconPanelLeftOpenOutline`, `IconPanorama360Outline`, `IconPanoramaOutline`
`IconParkingOutline`, `IconPasteOutline`, `IconPatioOutline`, `IconPauseCircleOutline`
`IconPauseOutline`, `IconPedestrianOutline`, `IconPetsOutline`, `IconPharmacyOutline`
`IconPhoneCircleOutline`, `IconPhoneOutline`, `IconPhotosOutline`, `IconPiggyBankOutline`
`IconPlayCircleOutline`, `IconPlayOutline`, `IconPlusCircleOutline`, `IconPlusOutline`
`IconPointerDownOutline`, `IconPointerUpOutline`, `IconPriceSqftOutline`, `IconPrintOutline`
`IconProfessionalOutline`, `IconProfileOutline`, `IconPublicTransitOutline`, `IconQuestionMarkCircleOutline`
`IconQuoteOutline`, `IconRadioButtonOutline`, `IconRateHappyOutline`, `IconRateOkOutline`
`IconRateUnhappyOutline`, `IconRateVeryHappyOutline`, `IconRateVeryUnhappyOutline`, `IconRecreationOutline`
`IconRedoOutline`, `IconReloadOutline`, `IconRenameOutline`, `IconReorderOutline`
`IconReplyOutline`, `IconRestaurantOutline`, `IconRestoreMailOutline`, `IconRevealOutline`
`IconRotateClockwiseOutline`, `IconRotateCounterClockwiseOutline`, `IconSchoolAlternateOutline`, `IconSchoolOutline`
`IconSearchHeartOutline`, `IconSearchOutline`, `IconSendOutline`, `IconSettingsOutline`
`IconShareWebOutline`, `IconShieldCheckmarkOutline`, `IconShieldOutline`, `IconShoppingOutline`
`IconShovelOutline`, `IconSignatureOutline`, `IconSmartphoneOutline`, `IconSortAscendingOutline`
`IconSortDescendingOutline`, `IconSortOutline`, `IconSpamFolderOutline`, `IconSparkleOutline`
`IconSquareFeetOutline`, `IconStopOutline`, `IconStreetViewOutline`, `IconSwipeOutline`
`IconSyncOutline`, `IconTabletOutline`, `IconTagDollarSignOutline`, `IconTagOutline`
`IconTargetOutline`, `IconTaxOutline`, `IconTeaOutline`, `IconTextAlignCenterOutline`
`IconTextAlignLeftOutline`, `IconTextAlignRightOutline`, `IconTextBoldOutline`, `IconTextColorOutline`
`IconTextItalicsOutline`, `IconTextUnderlinedOutline`, `IconThreeDimensionalOutline`, `IconThumbsDownOutline`
`IconThumbsUpOutline`, `IconTourDoorOutline`, `IconTownhouseOutline`, `IconTreeBenchOutline`
`IconTreesEvergreenOutline`, `IconTreesOutline`, `IconTrendingOutline`, `IconTrophyOutline`
`IconUnconstrainedFlyOverOutline`, `IconUnconstrainedWalkThroughOutline`, `IconUndoOutline`, `IconUploadOutline`
`IconUserAddOutline`, `IconUserGroupOutline`, `IconUserOutline`, `IconUserSettingsOutline`
`IconVideoCameraOutline`, `IconVideoPlayOutline`, `IconVolumeLowOutline`, `IconVolumeMidOutline`
`IconVolumeMutedOutline`, `IconVolumeOutline`, `IconWarningOutline`, `IconWaterOutline`
`IconWhiteBalanceOutline`, `IconWindOutline`, `IconWrenchOutline`, `IconYardSignOutline`
`IconZoomInOutline`, `IconZoomOutOutline`

## Other Icons (17)

`IconEHOLogo`, `IconFacebook`, `IconInstagram`, `IconLinkedIn`
`IconPinterest`, `IconStar0Percent`, `IconStar100Percent`, `IconStar25Percent`
`IconStar50Percent`, `IconStar75Percent`, `IconTikTok`, `IconTopAgent`
`IconWhatsApp`, `IconX`, `IconYouTube`, `IconZillowMark`
`IconZillowMarkLegacy`

