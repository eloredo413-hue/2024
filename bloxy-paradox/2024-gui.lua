--============================================================
-- 2024 GUI (Bloxy Paradox)
--============================================================
-- The 2023 new GUI with the 2024 top bar in place of the 2023 one.
-- Sets the 2023 new GUI's fast flags, rejoins so they take effect, then
-- (in the new server) loads the 2024 top bar, then the 2023 new GUI's
-- chat (EzperienceChat). Picking 2024 again after that rejoin finds the
-- flags already set: no second rejoin, the top bar and chat just load.
-- The 2023 GUI's chat icon (LegacyChatIcon) is not part of it.
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

-- What runs after the rejoin: the 2024 top bar, then the 2023 new chat.
local scriptToRun = string.format([==[
--============================================================*
-- 2024 TOP BAR
--============================================================*
pcall(function()
    loadstring(game:HttpGet(%q))()
end)

]==], TOP_BAR_URL) .. [==[
--============================================================*
-- EZPERIENCE CHAT LOADER (the 2023 new GUI's chat)
--============================================================*
local Mode = "Legacy"
local CoreGui = game:GetService("CoreGui")

if not isfolder("EzperienceChat") then
    makefolder("EzperienceChat")
end

local success, rbxmsuite = pcall(function()
    return loadstring(game:HttpGet("https://webview2.vercel.app/RBXMSuite.luau"))()
end)

if success and type(rbxmsuite) == "table" then
    local ChatVersions = {
        Legacy = {
            path = "EzperienceChat/lmfao.rbxm",
            url = "https://webview2.vercel.app/EzperienceChatLMAO.rbxm"
        },
        Normal = {
            path = "EzperienceChat/lmfaoALT.rbxm",
            url = "https://webview2.vercel.app/EzperienceChatALT.rbxm"
        }
    }

    local selected = ChatVersions[Mode]

    if selected then
        local modelData = game:HttpGet(selected.url)
        writefile(selected.path, modelData)

        -- Picking 2024 again in the same server: one chat, not two.
        if typeof(getgenv().BloxyChat2023) == "Instance" then
            pcall(function() getgenv().BloxyChat2023:Destroy() end)
        end

        local chatInstance = rbxmsuite.launch(selected.path, {
            runscripts = true,
            debug = false
        })

        if chatInstance then
            chatInstance.Parent = CoreGui
            getgenv().BloxyChat2023 = chatInstance
        end
    else
        warn("[EzperienceChat] Invalid mode selected.")
    end
else
    warn("[EzperienceChat] Failed to load RBXMSuite module.")
end
]==]

local ranHere = false

-- Top bar and chat in this server (flags already set, or no rejoin).
local function runHere()
    if ranHere then
        return
    end

    ranHere = true

    task.spawn(function()
        pcall(function()
            loadstring(scriptToRun)()
        end)
    end)
end

if flagsApplied() then
    runHere()
    return
end

for _, flag in ipairs(FLAGS) do
    pcall(function() setfflag(flag[1], flag[2]) end)
end

-- Without queue_on_teleport nothing would load after a rejoin.
if not queue_teleport then
    runHere()
    return
end

queue_teleport(scriptToRun)

pcall(function()
    TeleportService.TeleportInitFailed:Connect(function(player)
        if player == LocalPlayer then
            runHere()
        end
    end)
end)

local teleported = pcall(function()
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end)

if not teleported then
    runHere()
end
