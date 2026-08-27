local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

DB.SettingsFrame = nil;

local navActive = nil;
local navBtns = {};
local PANELS = {};

-----------------
--- Callbacks ---
-----------------

local function SetNavActive(name)
    local function _SetNavActive()
        navActive = name;
        for key, button in pairs(navBtns) do
            if key == name then
                addon.ApplyColor(button.bg, "SetColorTexture", CT.nav_active);
                addon.ApplyColor(button.lbl, "SetTextColor", addon.WHITE);
                button.stripe:Show();
            else
                addon.ApplyColor(button.bg, "SetColorTexture", addon.BLACK);
                addon.ApplyColor(button.lbl, "SetTextColor", CT.dim_text);
                button.stripe:Hide();
            end
        end
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
    return _SetNavActive;
end

local function ConditionalOnEnter(name, bg, lbl)
    local function _ConditionalOnEnter()
        if navActive~=name then
            addon.ApplyColor(bg, "SetColorTexture", CT.nav_hover);
            addon.ApplyColor(lbl, "SetTextColor", CT.bright_text);
        end
    end
    return _ConditionalOnEnter;
end

local function ConditionalOnLeave(name, bg, lbl)
    local function _ConditionalOnLeave()
        if navActive~=name then
            addon.ApplyColor(bg, "SetColorTexture", addon.BLACK, 0);
            addon.ApplyColor(lbl, "SetTextColor", CT.dim_text);
        end
    end
    return _ConditionalOnLeave;
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

local function BuildLeftNav(parent)
    local frame = CreateFrame(addon.FRAME, nil, parent);
    frame:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0, -30);
    frame:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 0);
    frame:SetWidth(addon.SET_NAV);
    addon.Tx(frame, CT.sidebar);

    local texture = frame:CreateTexture(nil, addon.ARTWORK);
    addon.ApplyColor(texture, "SetColorTexture", CT.divider);
    texture:SetWidth(1);
    texture:SetPoint(addon.TOPRIGHT, frame, addon.TOPRIGHT, 0, 0);
    texture:SetPoint(addon.BOTTOMRIGHT, frame, addon.BOTTOMRIGHT, 0, 0);

    return frame;
end

local function BuildNavButton(parent, i, def)
    local row = CreateFrame(addon.BUTTON, nil, parent);
    row:SetSize(addon.SET_NAV, 36);
    row:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0, -(i-1)*36);

    local background = row:CreateTexture(nil, addon.BACKGROUND);
    background:SetAllPoints();
    addon.ApplyColor(background, "SetColorTexture", addon.BLACK, 0);

    local stripe = row:CreateTexture(nil, addon.ARTWORK);
    addon.ApplyColor(stripe, "SetColorTexture", CT.nav_border);
    stripe:SetSize(3, 36);
    stripe:SetPoint(addon.LEFT, row, addon.LEFT, 0, 0);
    stripe:Hide();

    local label = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    label:SetPoint(addon.LEFT, row, addon.LEFT, 12, 0);
    label:SetText(def.label);
    addon.ApplyColor(label, "SetTextColor", CT.dim_text);

    local name = def.name;
    row:SetScript(addon.OnClick, SetNavActive(name));
    row:SetScript(addon.OnEnter, ConditionalOnEnter(name,  background,  label));
    row:SetScript(addon.OnLeave, ConditionalOnLeave(name,  background,  label));

    navBtns[def.name] = {bg = background, stripe = stripe, lbl = label};
end

local function BuildChangeListButton(parent)
    local frame = CreateFrame(addon.BUTTON, nil, parent);
    frame:SetSize(addon.SET_NAV, 36);
    frame:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 36);

    local background = frame:CreateTexture(nil, addon.BACKGROUND);
    background:SetAllPoints();
    addon.ApplyColor(background, "SetColorTexture", addon.BLACK, 0);

    local artwork = frame:CreateTexture(nil, addon.ARTWORK);
    addon.ApplyColor(artwork, "SetColorTexture", CT.nav_border);
    artwork:SetSize(3, 36);
    artwork:SetPoint(addon.LEFT, frame, addon.LEFT, 0, 0);
    artwork:Hide();

    local label = frame:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    label:SetPoint(addon.LEFT, frame, addon.LEFT, 12, 0);
    label:SetText("Changelog");
    addon.ApplyColor(label, "SetTextColor", CT.dim_text);

    frame:SetScript(addon.OnClick, SetNavActive("changelog"));
    frame:SetScript(addon.OnEnter, ConditionalOnEnter("changelog", background, label));
    frame:SetScript(addon.OnLeave, ConditionalOnLeave("changelog", background, label));

    navBtns["changelog"] = {bg=background, stripe=artwork, lbl=label};

    return frame;
end

local function BuildSeperator(parent, y_offset)
    local rule = parent:CreateTexture(nil, addon.ARTWORK);
    addon.ApplyColor(rule, "SetColorTexture", CT.divider);
    rule:SetHeight(1);
    rule:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, y_offset);
    rule:SetPoint(addon.BOTTOMRIGHT, parent, addon.BOTTOMRIGHT, 0, y_offset);
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
    -- Left nav
    local navBg = BuildLeftNav(mainFrame);
    local content = CreateFrame(addon.FRAME, nil, mainFrame);
    local activitiesPanel = addon.BuildActivitiesPanel(content);
    local rosterPanel = addon.BuildRosterPanel(content);
    local importExportPanel = addon.BuildImportExportPanel(content);
    local colorsPanel = addon.BuildColorsPanel(content);
    local scalePanel = addon.BuildUIScalePanel(content);
    local expansionsPanel = addon.BuildExpansionsPanel(content);
    local changelogPanel = addon.BuildChangelogPanel(content);
    BuildTitleBar(mainFrame);

    content:SetPoint(addon.TOPLEFT, mainFrame, addon.TOPLEFT, addon.SET_NAV, -30);
    content:SetPoint(addon.BOTTOMRIGHT, mainFrame, addon.BOTTOMRIGHT, 0, 0);
    PANELS.activities = activitiesPanel;
    PANELS.roster = rosterPanel;
    PANELS.importexport = importExportPanel;
    PANELS.expansions = expansionsPanel;
    PANELS.colors = colorsPanel;
    PANELS.uiscale = scalePanel;
    PANELS.changelog = changelogPanel;

    local panelStrings = {
        {name="activities", label="Activities"},
        {name="roster", label="Roster"},
        {name="importexport", label="Import/Export"},
        {name="expansions", label="Expansions"},
        {name="colors", label="Colors"},
        {name="uiscale", label="UI Scale"}
    };

    for i,def in ipairs(panelStrings) do
        BuildNavButton(navBg, i, def);
    end

    BuildChangeListButton(navBg);
    BuildSeperator(navBg, 72);
    BuildResetSizeButton(navBg);

    mainFrame:SetScript(addon.OnShow, SetNavActive("activities"));
    SetNavActive("activities");

    return mainFrame;
end
addon.BuildSettingsWindow = BuildSettingsWindow;
