local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local WIN_W  = 660;
local WIN_H  = 520;
local NAV_W  = 120;
local PAD    = 16;
-- local CONT_W = WIN_W - NAV_W - PAD * 2;  -- 508

local MainPanels = {};

local function BuildContentArea(parent)
    local leveling_nav = "leveling";
    local settings_nav = "settings_nav";

    local function OnSelect(name)
        if name == settings_nav and DB.SettingsFrame and DB.SettingsFrame:IsShown() then
            DB.SettingsFrame:Hide();
        elseif name == settings_nav and DB.SettingsFrame then
            
            DB.SettingsFrame:Show();
        elseif name == settings_nav then
            return;
        end
        -- Always refresh roster when switching to leveling so imports show immediately
        if name == leveling_nav then
            addon.BuildRoster();
        end
        for k,p in pairs(MainPanels) do
            if k == name then
                p:Show();
            else
                p:Hide();
            end
        end
    end

    local contentArea = CreateFrame(addon.FRAME, nil, parent);
    local nav = addon.CreateLeftNav(parent, OnSelect);

    local actPanel = addon.BuildActivityPanel(contentArea);
    nav:AddNav("activity", addon.ACTIVITY_LABEL);
    local crePanel = addon.BuildCreatorPanel(contentArea);
    nav:AddNav("creator", addon.CREATOR_LABEL);
    local levPanel = addon.BuildLevelingPanel(contentArea);
    nav:AddNav(leveling_nav, addon.LEVELING_LABEL);
    local namPanel = addon.BuildNamePanel(contentArea);
    nav:AddNav("names", addon.NAMES_LABEL);
    local profPanel = addon.BuildProfessionPanel(contentArea);
    nav:AddNav("professions", addon.PROFESSIONS_LABEL);
    local rdPanel = addon.BuildRaidDungeonPanel(contentArea);
    nav:AddNav("raidsdungeons", addon.RAIDS_AND_DUNGEONS_LABEL);
    local abtPanel = addon.BuildAboutPanel(contentArea);
    nav:AddRule();
    nav:AddBottomNav(settings_nav, addon.SETTINGS_LABEL);
    nav:AddBottomNav("about", addon.ABOUT_LABEL);

    contentArea:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, NAV_W, -30);
    contentArea:SetPoint(addon.BOTTOMRIGHT, parent, addon.BOTTOMRIGHT, 0, 0);
    addon.Tx(contentArea, addon.AddColor(CT.bg, {0.005, 0.005, 0.01}));

    MainPanels = {activity=actPanel, creator=crePanel, leveling=levPanel, names=namPanel, professions=profPanel, raidsdungeons=rdPanel, about=abtPanel};
    nav:SetActive("activity");
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
