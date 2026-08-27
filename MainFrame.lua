local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local WIN_W  = 660;
local WIN_H  = 520;
local NAV_W  = 120;
local PAD    = 16;
local CONT_W = WIN_W - NAV_W - PAD * 2;  -- 508

local MainPanels = {};

local function OnSelect(settings_nav, leveling_nav)
    local function _OnSelect(name)
        if name==settings_nav and DB.SettingsFrame and DB.SettingsFrame:IsShown() then
            DB.SettingsFrame:Hide();
        elseif name==settings_nav and DB.SettingsFrame then
            
            DB.SettingsFrame:Show();
        elseif name==settings_nav then
            return;
        end
        -- Always refresh roster when switching to leveling so imports show immediately
        if name==leveling_nav then
            addon.BuildRoster();
        end
        for k,p in pairs(MainPanels) do
            if k==name then
                p:Show();
            else
                p:Hide();
            end
        end
    end
    return _OnSelect;
end

local function BuildContentArea(parent)
    local contentArea=CreateFrame(addon.FRAME, nil, parent);
    local actPanel  = addon.BuildActivityPanel(contentArea);
    local crePanel  = addon.BuildCreatorPanel(contentArea);
    local levPanel  = addon.BuildLevelingPanel(contentArea);
    local namPanel  = addon.BuildNamePanel(contentArea);
    local profPanel = addon.BuildProfessionPanel(contentArea);
    local rdPanel   = addon.BuildRaidDungeonPanel(contentArea);
    local abtPanel  = addon.BuildAboutPanel(contentArea);
    local leveling_nav = "leveling";
    local settings_nav = "settings_nav";
    contentArea:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, NAV_W, -30);
    contentArea:SetPoint(addon.BOTTOMRIGHT, parent, addon.BOTTOMRIGHT, 0, 0);
    addon.Tx(contentArea, {CT.bg[1]+0.005, CT.bg[2]+0.005, CT.bg[3]+0.01});

    MainPanels={activity=actPanel, creator=crePanel, leveling=levPanel, names=namPanel, professions=profPanel, raidsdungeons=rdPanel, about=abtPanel};

    addon.BuildLeftNav(parent,
        {
            {name="activity", label=addon.ACTIVITY_LABEL},
            {name="creator", label=addon.CREATOR_LABEL},
            {name=leveling_nav, label=addon.LEVELING_LABEL},
            {name="names", label=addon.NAMES_LABEL},
            {name="professions", label=addon.PROFESSIONS_LABEL},
            {name="raidsdungeons", label=addon.RAIDS_AND_DUNGEONS_LABEL}
        },
        {
            {name=settings_nav, label=addon.SETTINGS_LABEL},
            {name="about", label=addon.ABOUT_LABEL}
        },
        OnSelect(settings_nav, leveling_nav));
end

local function BuildMainFrame()
    local frame = CreateFrame(addon.FRAME, addon.FRAME, UIParent, addon.BACKDROP_TEMPLATE);
    local titleBar = CreateFrame(addon.FRAME, nil, frame);
    local titleBarB = titleBar:CreateTexture(nil, addon.ARTWORK);
    local titleLabel = titleBar:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_LARGE);
    local closeBtn = CreateFrame(addon.BUTTON, nil, frame, addon.UI_PANEL_CLOSE_BUTTON);

    frame:SetSize(WIN_W, WIN_H);
    frame:SetPoint(addon.CENTER);
    frame:SetMovable(true);
    frame:EnableMouse(true);
    frame:RegisterForDrag(addon.LEFT_BUTTON);
    frame:SetScript(addon.OnDragStart, frame.StartMoving);
    frame:SetScript(addon.OnDragStop, frame.StopMovingOrSizing);
    frame:SetFrameStrata(addon.DIALOG);
    frame:SetBackdrop({bgFile=addon.BG_FILE, edgeFile=addon.BG_FILE, edgeSize=1});
    addon.ApplyColor(frame, "SetBackdropColor", CT.bg);
    addon.ApplyColor(frame, "SetBackdropBorderColor", CT.win_border);
    titleBar:SetHeight(30);
    titleBar:SetPoint(addon.TOPLEFT, frame, addon.TOPLEFT, 0, 0);
    titleBar:SetPoint(addon.TOPRIGHT, frame, addon.TOPRIGHT, 0, 0);
    addon.Tx(titleBar, CT.sidebar);
    addon.ApplyColor(titleBarB, "SetColorTexture", CT.divider);
    titleBarB:SetHeight(1);
    titleBarB:SetPoint(addon.BOTTOMLEFT, titleBar, addon.BOTTOMLEFT, 0, 0);
    titleBarB:SetPoint(addon.BOTTOMRIGHT, titleBar, addon.BOTTOMRIGHT, 0, 0);
    titleLabel:SetPoint(addon.CENTER, titleBar, addon.CENTER, 0, 0);
    titleLabel:SetText(addon.STRING);
    addon.ApplyColor(titleLabel, "SetTextColor", CT.bright_text);
    closeBtn:SetPoint(addon.TOPRIGHT, frame, addon.TOPRIGHT, -2, -2);
    closeBtn:SetFrameStrata(frame:GetFrameStrata());
    closeBtn:SetFrameLevel(frame:GetFrameLevel() + 1);
    closeBtn:SetScript(addon.OnClick, function()
        frame:Hide();
        if DB.SettingsFrame then DB.SettingsFrame:Hide(); end
    end)

    -- Content area
    BuildContentArea(frame);

    frame:Hide();
    return frame;
end

local function OnAddonLoaded(self, event, arg1)
    addon.InitDB();
    -- Apply saved theme (must run after InitDB sets defaults)
    if DB.colorTheme == addon.CUSTOM_THEME and next(DB.customColors) then
        addon.ApplyTheme(addon.CUSTOM_THEME, DB.customColors);
    else
        addon.ApplyTheme(DB.colorTheme or addon.DEFAULT_THEME);
    end

    -- Define StaticPopup dialogs at init time so they're registered before use
    StaticPopupDialogs["WSID_CONFIRM_THEME"] = StaticPopupDialogs["WSID_CONFIRM_THEME"] or {};
    StaticPopupDialogs["WSID_CONFIRM_WhatShouldIDoDB.CUSTOM_THEME"] = StaticPopupDialogs["WSID_CONFIRM_WhatShouldIDoDB.CUSTOM_THEME"] or {};
    DB.MainFrame = BuildMainFrame();
    DB.SettingsFrame = addon.BuildSettingsWindow();
    addon.RegisterMinimapButton();
    -- ESC closes the windows
    tinsert(UISpecialFrames, addon.FRAME);
    tinsert(UISpecialFrames, "WhatShouldIDoSettings");
    -- Apply saved UI scale
    local scale = DB.uiScale or 1.0;
    DB.MainFrame:SetScale(scale);
    DB.SettingsFrame:SetScale(scale);
end

local function HandleEvent(self, event, arg1)
    if event == addon.ADDON_LOADED and arg1 == addon.ADDON_NAME then
        OnAddonLoaded(self, event, arg1);
    elseif event == addon.PLAYER_LOGIN then
        addon.BuildRoster();
    end
end

------------------------------------------------------------------------
-- MINIMAP BUTTON
------------------------------------------------------------------------

local function MinimapButtonClick(_,btn)
    if btn == addon.LEFT_BUTTON and DB.MainFrame:IsShown() and DB.SettingsFrame then
        DB.SettingsFrame:Hide();
    elseif btn == addon.LEFT_BUTTON and DB.MainFrame:IsShown() then
        DB.MainFrame:Hide();
    elseif btn == addon.LEFT_BUTTON then
        addon.BuildRoster();
        DB.MainFrame:Show();
    elseif btn == addon.RIGHT_BUTTON and DB.SettingsFrame:IsShown() then
        DB.SettingsFrame:Hide();
    elseif btn == addon.RIGHT_BUTTON then
            DB.SettingsFrame:Show();
    end
end

local function ShowToolTip(toolTip)
    toolTip:SetText(addon.STRING,1,0.85,0.20);
    toolTip:AddLine("Left-click: open / close",0.8,0.8,0.8);
    toolTip:AddLine("Right-click: settings", 0.8,0.8,0.8);
end

local function RegisterMinimapButton()
    local LDB=LibStub("LibDataBroker-1.1")
    local LibDBIcon=LibStub("LibDBIcon-1.0")
    local broker=LDB:NewDataObject(addon.ADDON_NAME, {
        type="launcher",
        icon="Interface\\Icons\\INV_Misc_QuestionMark",
        label=addon.STRING,
        OnClick=MinimapButtonClick,
        OnTooltipShow=ShowToolTip
    })
    LibDBIcon:Register(addon.ADDON_NAME, broker, DB.minimap)
end
addon.RegisterMinimapButton = RegisterMinimapButton

------------------------------------------------------------------------
-- INIT
------------------------------------------------------------------------

local initFrame=CreateFrame(addon.FRAME);
initFrame:RegisterEvent(addon.ADDON_LOADED);
initFrame:RegisterEvent(addon.PLAYER_LOGIN);
initFrame:SetScript(addon.OnEvent, HandleEvent);

SLASH_WSID1="/wsid";
SLASH_WSID2="/whatshouldido";
SLASH_WSID3="/sw";
local function WSID(msg)
    msg=strtrim(msg);
    local msgL=msg:lower();
    if msgL=="roster" then
        addon.BuildRoster();
        print("|cffd5a742What Should I Do?:|r Roster refreshed -- "..#DB.seenChars.." character(s).");
        return;
    end
    if msgL=="settings" then
        if DB.SettingsFrame and DB.SettingsFrame:IsShown() then
            DB.SettingsFrame:Hide();
        else
            DB.SettingsFrame:Show();
        end
        return
    end
    if DB.MainFrame and DB.MainFrame:IsShown() and DB.SettingsFrame then
        DB.SettingsFrame:Hide();
    elseif DB.MainFrame and DB.MainFrame:IsShown() then
        DB.MainFrame:Hide();
    else
        addon.BuildRoster();
        DB.MainFrame:Show();
    end
end
SlashCmdList.WSID = WSID;
