local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

DB.SettingsFrame = nil;

local PANELS = {};

-----------------
--- Callbacks ---
-----------------

local function OnSelect(name)
    for key, panel in pairs(PANELS) do
        if key == name then
            panel:Show();
        else
            panel:Hide();
        end
    end

    if name == "roster" and DB.RefreshRoster then
        DB.RefreshRoster();
    end
end

local function OnEnter(bg, lbl)
    local function _OnEnter()
        addon.ApplyColor(bg, "SetColorTexture", CT.nav_hover);
        addon.ApplyColor(lbl, "SetTextColor", CT.bright_text);
    end
    return _OnEnter;
end

local function OnLeave(bg, lbl)
    local function _OnLeave()
        addon.ApplyColor(bg, "SetColorTexture", addon.BLACK, 0);
        addon.ApplyColor(lbl, "SetTextColor", CT.dim_text);
    end
    return _OnLeave;
end

local function ResetSize()
    DB.uiScale = 1.0;

    if DB.MainFrame then
        DB.MainFrame:SetScale(1.0);
    end

    if DB.SettingsFrame then
        DB.SettingsFrame:SetScale(1.0);
    end

    UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r UI scale reset to 100%%.", 1, 0.85, 0.2);
end

----------------
--- Builders ---
----------------

local function BuildMainFrame(parent)
    local frame = CreateFrame(addon.FRAME, "WhatShouldIDoSettings", parent, addon.BACKDROP_TEMPLATE);
    frame:SetSize(addon.SET_W, addon.SET_H);
    frame:SetPoint(addon.CENTER, parent, addon.CENTER, 280, 0);
    frame:SetMovable(true);
    frame:EnableMouse(true);
    frame:RegisterForDrag(addon.LEFT_BUTTON);
    frame:SetScript(addon.OnDragStart, frame.StartMoving);
    frame:SetScript(addon.OnDragStop, frame.StopMovingOrSizing);
    frame:SetFrameStrata(addon.DIALOG);
    frame:SetFrameLevel(20);
    frame:SetBackdrop({bgFile=addon.BG_FILE, edgeFile=addon.BG_FILE, edgeSize=1});
    addon.ApplyColor(frame, "SetBackdropColor", CT.bg);
    addon.ApplyColor(frame, "SetBackdropBorderColor", CT.win_border);
    frame:Hide();

    return frame;
end

local function BuildTitleBar(parent)
    local frame = CreateFrame(addon.FRAME, nil, parent);
    frame:SetHeight(30);
    frame:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0, 0);
    frame:SetPoint(addon.TOPRIGHT, parent, addon.TOPRIGHT, 0, 0);
    addon.Tx(frame, CT.sidebar);

    local border=frame:CreateTexture(nil, addon.ARTWORK);
    addon.ApplyColor(border, "SetColorTexture", CT.divider);
    border:SetHeight(1);
    border:SetPoint(addon.BOTTOMLEFT, frame, addon.BOTTOMLEFT, 0, 0);
    border:SetPoint(addon.BOTTOMRIGHT, frame, addon.BOTTOMRIGHT, 0, 0);

    local label=frame:CreateFontString(nil, addon.OVERLAY, addon.NORMAL);
    label:SetPoint(addon.LEFT, frame, addon.LEFT, 10, 0);
    label:SetText("What Should I Do?  --  Settings");
    label:SetTextColor(CT.header_txt[1], CT.header_txt[2], CT.header_txt[3]);

    local closeBtn=CreateFrame(addon.BUTTON, nil, parent, addon.UI_PANEL_CLOSE_BUTTON);
    closeBtn:SetPoint(addon.TOPRIGHT, parent, addon.TOPRIGHT, -2, -2);
    closeBtn:SetFrameStrata(parent:GetFrameStrata());
    closeBtn:SetFrameLevel(parent:GetFrameLevel() + 1);

    return frame;
end

local function BuildResetSizeButton(parent)
    local frame = CreateFrame(addon.BUTTON, nil, parent);
    frame:SetSize(addon.SET_NAV, 36);
    frame:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 0);

    local background = frame:CreateTexture(nil,addon.BACKGROUND);
    background:SetAllPoints();
    addon.ApplyColor(background, "SetColorTexture", addon.BLACK, 0);

    local label = frame:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    label:SetPoint(addon.LEFT, frame, addon.LEFT, 12, 0);
    label:SetText("Reset Size");
    addon.ApplyColor(label, "SetTextColor", CT.dim_text);

    frame:SetScript(addon.OnEnter, OnEnter(background, label));
    frame:SetScript(addon.OnLeave, OnLeave(background, label));
    frame:SetScript(addon.OnClick, ResetSize);
end

local function BuildSettingsWindow()
    local mainFrame = BuildMainFrame(UIParent);
    local content = CreateFrame(addon.FRAME, nil, mainFrame);
    content:SetPoint(addon.TOPLEFT, mainFrame, addon.TOPLEFT, addon.SET_NAV, -30);
    content:SetPoint(addon.BOTTOMRIGHT, mainFrame, addon.BOTTOMRIGHT, 0, 0);

    local navBg = addon.CreateLeftNav(mainFrame, OnSelect, {
        width = addon.SET_NAV,
        rowHeight = 36,
        bottomInset = 36, -- Reserves room below nav for reset button
    });
    
    PANELS.activities = addon.BuildActivitiesPanel(content);
    navBg:AddNav("activities", "Activities");
    PANELS.roster = addon.BuildRosterPanel(content);
    navBg:AddNav("roster", "Roster");
    PANELS.importexport = addon.BuildImportExportPanel(content);
    navBg:AddNav("importexport", "Import/Export");
    PANELS.expansions = addon.BuildExpansionsPanel(content);
    navBg:AddNav("expansions", "Expansions");
    PANELS.colors = addon.BuildColorsPanel(content);
    navBg:AddNav("colors", "Colors");
    PANELS.uiscale = addon.BuildUIScalePanel(content);
    navBg:AddNav("uiscale", "UI Scale");
    PANELS.changelog = addon.BuildChangelogPanel(content);
    navBg:AddRule();
    navBg:AddBottomNav("changelog", "Changelog");
    
    BuildTitleBar(mainFrame);
    BuildResetSizeButton(navBg);

    mainFrame:SetScript(addon.OnShow, function() navBg:SetActive("activities"); end);
    navBg:SetActive("activities");

    return mainFrame;
end
addon.BuildSettingsWindow = BuildSettingsWindow;
