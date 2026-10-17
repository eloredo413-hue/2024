--============================================================
-- 2024 GUI (Bloxy Paradox)
--============================================================
-- The 2023 new GUI with the 2024 top bar in place of the 2023 one:
-- the same fast flags, then Old Chrome 2024. Like the 2023 new GUI it
-- rejoins so the flags take effect, with the top bar queued to load in
-- the new server. Picking 2024 again after that rejoin finds the flags
-- already set, so it only loads the top bar. The 2023 GUI's chat icon
-- (LegacyChatIcon) and EzperienceChat are not part of it.
--============================================================

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local queue_teleport = queue_on_teleport or (syn and syn.queue_on_teleport)

local TOP_BAR_URL = "https://raw.githubusercontent.com/eloredo413-hue/2024/main/2024"

-- The 2023 new GUI's flags and values, in its order.
local FLAGS = {
    { "AddMachineIDInstallerTelemetry", "False" },
    { "AddMoreSysTrayTelemetry", "False" },
    { "AddPlaySessionIdTelemetry", "False" },
    { "AddToDecryptionTelemetry", "False" },
    { "AddUniverseIDToTelemetryV2FRMStats", "False" },
    { "AICOUseTelemetryV2", "False" },
    { "AndroidDebugHeapTelemetry", "False" },
    { "AndroidMajorFaultsRateTelemetry", "False" },
    { "AndroidOnTrimMemoryLevelTelemetry", "False" },
    { "AndroidOomScoreTelemetry", "False" },
    { "AppConfigurationAddTimeIntervalInTelemetry", "False" },
    { "AppConfigurationAddUrlInTelemetry", "False" },
    { "AppConfigurationAddUserIdInTelemetry", "False" },
    { "AssetProviderByteRangeTelemetry", "False" },
    { "AssetProviderSendTelemetryForIfRequestIsSentToNewAdDomain", "False" },
    { "AssetRequestTelemetryAddCacheSourceField2", "False" },
    { "AudioWiringTelemetryForAudioSpeechToText", "False" },
    { "AudioWiringTelemetryForAudioTextToSpeech", "False" },
    { "AvatarChangeTelemetryBatchFlush", "False" },
    { "AvatarChangeTelemetryImmediateSend", "False" },
    { "AvatarChatServiceTelemetryIncludeServerFeatures", "False" },
    { "AvatarClothingAndDecalTelemetry3", "False" },
    { "BadgesApiUsageTelemetryEnabled", "False" },
    { "BrowserTrackerIdTelemetryEnabled", "False" },
    { "CapsMissRegularTelemetry", "False" },
    { "CapsMissUnassignedTelemetry", "False" },
    { "CaptureServiceSendAssetUploadFailureTelemetry", "False" },
    { "CaptureServiceUpdateUploadTelemetry", "False" },
    { "CheckFixLuaTelemetryBoolTypes", "False" },
    { "CleanUpTeamCreateDeprecatedTelemetry", "False" },
    { "CLI_147010_ReportAttributesWithHangTelemetry2", "False" },
    { "DebugRenderForceTechnologyVoxel", "True" },
    { "IASReportNewActionTypes", "False" },
    { "ReplicatorTelemetryServerAuthorityMode", "False" },
    { "ReportAssetRequestV1Telemetry", "False" },
    { "ReportAssetRequestV2Telemetry", "False" },
    { "VideoEnableL2aSessionTelemetry2", "False" },
    { "VideoEnableL2bSessionTelemetry2", "False" },
    { "VideoEnableUsageTelemetry", "False" },
    { "AnimationLodFacsDistanceMax", "0" },
    { "AnimationLodFacsDistanceMin", "0" },
    { "AnimationLodFacsVisibilityDenominator", "0" },
    { "PartyVoiceLaunchFlowTelemetryThrottle", "0" },
    { "PerfDataOnTelemetryV2ThrottleHundredthsPercent", "0" },
    { "SurfaceControllerErrorTelemetryThrottleHundredthsPercent", "0" },
    { "AbuseReportMenuV2", "False" },
    { "AbuseReportMenuV2_IXP", "False" },
    { "AbuseReportTabSelectionHighlightCutoffFixEnabled", "False" },
    { "AddFriendsBannersNewUI_exp_IXP", "False" },
    { "AddFriendsCINewIcon_exp_IXP", "False" },
    { "AddFriendsUserListEnabled_v2_IXP", "False" },
    { "AddIGMToSideSheet3", "False" },
    { "AddTraversalHistory699v1", "False" },
    { "AddTraversalHistoryReactMenuButtons", "False" },
    { "AdServiceEnabled", "False" },
    { "AESEnableTimedOptions3", "False" },
    { "AgeBasedUXHomepageVerificationBannerGreyButton", "True" },
    { "AgeBasedUXHomepageVerificationBannerLockIcon", "False" },
    { "AIDiffMessage1", "False" },
    { "AIRephraseSettingEnabled3", "False" },
    { "AppChatInExperienceRenameToRobloxChat", "False" },
    { "AppChatRebrandIconUpdates", "False" },
    { "AppChatRebrandIconUpdatesNew", "False" },
    { "AppChatRebrandInNonChrome", "False" },
    { "AppChatRebrandStringUpdates", "False" },
    { "AppChatUniversalAppNavbarNewConfig", "False" },
    { "AXCatalogMakeupSupport10", "False" },
    { "AXCommunityAvatarsMakeupEquipping", "False" },
    { "AXCustomizeMakeupSupport4", "True" },
    { "AXEnableFoundationSegmentedMenu_IXP", "False" },
    { "AXEnableSlotBasedEditor3", "True" },
    { "AXInspectAndBuyMakeupSupport", "False" },
    { "AXMakeupEquipping", "False" },
    { "AXMigrateSystemSliderToFoundationSlider2", "False" },
    { "AXNewRobuxBalanceButton2", "False" },
    { "AXTimedOptionsSalesTypeFilter", "False" },
    { "ChatSummariesSettingEnabled3", "False" },
    { "ConnectionsHubLayerExposure", "False" },
    { "CreateConnectionsHub_v6_IXP", "False" },
    { "DataModelPatcherForceLocal", "True" },
    { "DecoupleScreenGuiFromPurchasePromptApp", "False" },
    { "EnableAccountSwitcherFoundationDesign9", "False" },
    { "EnableAccountSwitcherLoginV2Correction", "False" },
    { "EnableAccountSwitcherRedesignIXP", "False" },
    { "EnableConsoleExpControls684", "False" },
    { "EnableConsoleExpControlsV4", "False" },
    { "EnableCoreContentThemeUseFoundationButton", "False" },
    { "EnableCoreContentThemeUseFoundationButton_IXP", "False" },
    { "EnableDesktopGameJoinCard_v5", "False" },
    { "EnableFlyoutUncheckedBadge2", "False" },
    { "EnableHomeRobloxLogo", "False" },
    { "EnableHomeRobloxLogo_IXP", "False" },
    { "EnableInExperienceShop3", "False" },
    { "EnableInGameMenuChrome", "False" },
    { "EnableInGameMenuChromeABTest3", "False" },
    { "EnableInGameMenuChromeABTest4", "False" },
    { "EnableInGameMenuControls", "True" },
    { "EnableInGameMenuChromeSignalAPI", "False" },
    { "EnableInGameMenuModernization", "True" },
    { "EnableInGameMenuSongbirdABTest", "False" },
    { "EnableInspectAndBuyV2RootFlag2", "False" },
    { "EnableMenuControlsABTest", "False" },
    { "EnableNavBarLabels3", "False" },
    { "EnableNonFlyoutUncheckedBadge2", "False" },
    { "EnablePartyPageCarouselExperimentation4", "False" },
    { "EnablePartyTabNumberedBadge6", "False" },
    { "EnableV3MenuABTest3", "False" },
    { "EnableWhiteOrGreyRobuxIcon", "False" },
    { "ExpChatGetLabelAndIconFromUtilUnibarHoldout", "False" },
    { "ExpChatShowGlobalChatTooltip", "False" },
    { "FocusNavOutOfSubmenu", "False" },
    { "FoundationDialogAnimation2", "False" },
    { "FoundationEnableNewButtonSizes", "False" },
    { "FoundationFixDisablingForIconButtons", "False" },
    { "FoundationRobuxIconMigration", "False" },
    { "FoundationToastButtonsFillRightToLeft", "False" },
    { "FriendsPageUserListEnabled_v2_IXP", "False" },
    { "FriendsPageViewBtnEnabled", "False" },
    { "IEMFocusNavSupportNewButtons2", "False" },
    { "IEMFocusNavToButtons", "False" },
    { "IEMSettingsGroups709_IXP", "False" },
    { "IGMChangeCapturesToGallery", "False" },
    { "IGMChangeGalleryHeaderIcon", "False" },
    { "JoinCardAgeCheckUpsell_V3_IXP", "False" },
    { "LuaAppChangeRecommendedGamesTitle", "False" },
    { "LuaAppCompositionCharts", "False" },
    { "LuaAppCompositionHome", "False" },
    { "LuaAppCompositionSupport", "False" },
    { "LuaAppEnableFoundationColors7", "False" },
    { "LuaAppFoundationColorsABTest7", "False" },
    { "LuaAppPlayButtonAmpAgeCheckFlow", "False" },
    { "LuaAppSearchGridTiles2", "False" },
    { "LuaAppUseFoundationCheckbox_IXP", "False" },
    { "LuaAppUseFoundationLoading_IXP", "False" },
    { "LuaAppUseNewTilePadding", "False" },
    { "MeshSimplificationTelemetry", "False" },
    { "NewGuiSelectionHighlights", "False" },
    { "NewPeoplePageIcons5", "False" },
    { "PerformanceControlFixTelemetryName", "False" },
    { "PerformanceControlFttAdditionalTelemetryEnabled", "False" },
    { "ProfilePlatformCTAsRefactor_V3_IXP", "False" },
    { "RefactorHelpPage5", "False" },
    { "RefactorHelpPage5_IXP", "False" },
    { "RefactorMenuConfirmationButtons2_IXP", "False" },
    { "RefactorMenuConfirmationButtons5", "False" },
    { "RefactorPeoplePage9", "False" },
    { "RefactorPeoplePage9_IXP", "False" },
    { "RefactorUnifiedPurchasePrompt", "False" },
    { "RenameRespawnConfirmationPage", "False" },
    { "ReportTextureStreamingTelemetry7", "False" },
    { "ReportVisibilityAndIslandTelemetry", "False" },
    { "SoundsUsePhysicalVelocity", "True" },
    { "SupportTimedOptionsinPerformPurchase", "False" },
    { "SwitchOverToAbuseReportMenuV2_IXP", "False" },
    { "TopBarSignalizeHealthBar4", "False" },
    { "TopBarSignalizeKeepOutAreas5", "False" },
    { "TopBarSignalizeMenuOpen", "False" },
    { "TopBarSignalizeScreenSize2", "False" },
    { "TopBarSignalizeSetCores", "False" },
    { "UIBloxUseFoundationButton3_IXP", "False" },
    { "UIBloxUseFoundationButton5_IXP", "False" },
    { "UIBloxUseFoundationButtonInGame2_IXP", "False" },
    { "UIBloxUseFoundationButtonInGame_IXP", "False" },
    { "UIBloxUseFoundationSkeleton", "False" },
    { "UIBloxUseFoundationSkeleton_IXP", "False" },
    { "UnibarHoldoutChatIconUseNewIconSize", "False" },
    { "UnibarMenuOpenHamburgerGamepadIXP684", "False" },
    { "UnibarMenuOpenHamburgerGamepadIXP684_IXP", "False" },
    { "UseNewHurtOverlayAnimation", "False" },
    { "UseNewHurtOverlayImage", "False" },
    { "UseNewPlayerList3", "False" },
    { "UseNewPlayerListConsole_IXP", "False" },
    { "UseNewRobloxIconInNotifications", "False" },
    { "WebBrowserMemoryTelemetryEnabled", "False" },
    { "WebBrowserPreInitializeMemoryTelemetry", "False" },
    { "WebBrowserSTM6353MemoryTelemetry", "False" },
    { "NewInGameMenuPercentRollout3", "0" },
    { "RelocateMobileMenuButtonsVariant", "0" },
}

-- True when every flag getfflag can read already has its value.
local function flagsApplied()
    if type(getfflag) ~= "function" then
        return false
    end

    local checked = 0

    for _, flag in ipairs(FLAGS) do
        local ok, value = pcall(getfflag, flag[1])

        if ok and value ~= nil then
            if string.lower(tostring(value)) ~= string.lower(flag[2]) then
                return false
            end

            checked += 1
        end
    end

    return checked > 0
end

local alreadyApplied = flagsApplied()

for _, flag in ipairs(FLAGS) do
    pcall(function() setfflag(flag[1], flag[2]) end)
end

local scriptToRun = string.format("loadstring(game:HttpGet(%q))()", TOP_BAR_URL)

if alreadyApplied then
    pcall(function()
        loadstring(scriptToRun)()
    end)

    return
end

if queue_teleport then
    queue_teleport(scriptToRun)
end

pcall(function()
    loadstring(scriptToRun)()
end)

if #Players:GetPlayers() <= 1 then
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
else
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end
