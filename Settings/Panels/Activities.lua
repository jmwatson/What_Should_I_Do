local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

local SCRL_H = 280;
local BTN_H = 26;
local GAP = 10;

local function AcquireCheckboxRow(pool, i, name)
    local row = pool:Acquire();
    local even = (i % 2 == 0);

    if not row.box then
        row.box = CreateFrame(addon.FRAME, nil, row, addon.BACKDROP_TEMPLATE);
        row.check = row.box:CreateTexture(nil, addon.OVERLAY);
        row.lbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);

        row:SetBackdrop({bgFile=addon.BG_FILE});
        row.box:SetSize(14, 14);
        row.box:SetPoint(addon.LEFT, row, addon.LEFT, 6, 0);
        row.box:SetBackdrop({bgFile=addon.BG_FILE, edgeFile=addon.BG_FILE, edgeSize=1});
        row.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check");
        row.check:SetSize(16, 16);
        row.check:SetPoint(addon.CENTER, row.box, addon.CENTER, 0, 0);
        row.lbl:SetPoint(addon.LEFT, row.box, addon.RIGHT, 6, 0);
        row.lbl:SetJustifyH(addon.LEFT);
        row.lbl:SetWidth(addon.SET_COL-32);
    end

    row:Show();
    row:SetSize(addon.SET_COL - 2, 22);
    row:SetPoint(addon.TOPLEFT, row:GetParent(), addon.TOPLEFT, 0, -(i - 1) * 22);
    addon.ApplyColor(row, "SetBackdropColor", even and CT.row_even or CT.row_odd);
    row.lbl:SetText(name);
    row._even = even;
    row._name = name;

    return row;
end

local function PaintCheckbox(row, checked)
    if checked then
        addon.ApplyColor(row.box, "SetBackdropColor", CT.result_bg);
        addon.ApplyColor(row.box, "SetBackdropBorderColor", CT.nav_border);
        addon.ApplyColor(row.check, "SetVertexColor", CT.nav_border);
        addon.ApplyColor(row.lbl, "SetTextColor", CT.bright_text);
        row.check:Show();
    else
        row.box:SetBackdropColor(0.05,0.03,0.08,1);
        addon.ApplyColor(row.box, "SetBackdropBorderColor", CT.divider);
        addon.ApplyColor(row.lbl, "SetTextColor", CT.dim_text);
        row.check:Hide();
    end
end

------------------------------------------------------------------------
-- PANEL METHODS
------------------------------------------------------------------------

local ActivitiesPanelMixin = {};

function ActivitiesPanelMixin:RefreshSubList()
    self.subRowPool:ReleaseAll();
    self.subReset();

    if not self.selectedActivity then
        self.subCount:SetText(addon.EMPTY_STRING);
        self.subContent:SetHeight(22);
        return;
    end

    if not DB.excludedSubActivities then
        DB.excludedSubActivities = {};
    end

    local subs = addon.GetAllSubActivities(self.selectedActivity);
    self.subCount:SetText("["..#subs.."]");

    for i, sub in ipairs(subs) do
        local row = AcquireCheckboxRow(self.subRowPool, i, sub);
        local subName = sub;
        local checked = not DB.excludedSubActivities[subName];
        PaintCheckbox(row, checked);

        row:SetScript(addon.OnClick,function()
            checked = not checked;
            DB.excludedSubActivities[subName] = checked and nil or true;
            PaintCheckbox(row, checked);
        end);
        row:SetScript(addon.OnEnter,function()
            addon.ApplyColor(row, "SetBackdropColor", CT.row_hover);
        end);
        row:SetScript(addon.OnLeave,function()
            addon.ApplyColor(row, "SetBackdropColor", row._even and CT.row_even or CT.row_odd);
        end);
    end

    self.subContent:SetHeight(math.max(22, #subs * 22 + 2));
end

function ActivitiesPanelMixin:SelectActivity(name)
    self.selectedActivity = name;

    for row in self.activitiesRowPool:EnumerateActive() do
        if row._name == name then
            addon.ApplyColor(row, "SetBackdropColor", CT.row_select);
        else
            addon.ApplyColor(row, "SetBackdropColor", row._even and CT.row_even or CT.row_odd);
        end
    end

    addon.ApplyColor(self.subSelectLabel, "SetTextColor", CT.spin_text);
    self.subSelectLabel:SetText(name);
    self:RefreshSubList();
end

function ActivitiesPanelMixin:RefreshActivities()
    self.activitiesRowPool:ReleaseAll();

    if not DB.excludedActivities then
        DB.excludedActivities = {};
    end

    local acts = addon.GetAllActivities();
    self.activitiesCount:SetText("["..#acts.."]");

    for i, act in ipairs(acts) do
        local row = AcquireCheckboxRow(self.activitiesRowPool, i, act);
        local checked = not DB.excludedActivities[act];
        PaintCheckbox(row, checked);

        row:SetScript(addon.OnClick, function()
            self.selectedActivity = act;
            checked = not checked;
            DB.excludedActivities[act] = checked and nil or true;
            PaintCheckbox(row, checked);
            self:SelectActivity(act);
        end);
        row:SetScript(addon.OnEnter, function()
            if self.selectedActivity ~= act then
                addon.ApplyColor(row, "SetBackdropColor", CT.row_hover);
            end
        end);
        row:SetScript(addon.OnLeave, function()
            if self.selectedActivity ~= act then
                addon.ApplyColor(row, "SetBackdropColor", row._even and CT.row_even or CT.row_odd);
            end
        end);
    end

    self.actContent:SetHeight(math.max(22, #acts * 22 + 2));
    self.actReset();

    if self.selectedActivity then
        for row in self.activitiesRowPool:EnumerateActive() do
            if row._name == self.selectedActivity then
                addon.ApplyColor(row, "SetBackdropColor", CT.row_select);
            end
        end
    end

    self:RefreshSubList();
end

function ActivitiesPanelMixin:ResetBtnOnClick()
    addon.ResetActivities();
    addon.ResetSubActivities();
    self.selectedActivity = nil;
    self.subSelectLabel:SetText("(click a category to edit its sub-activities)");
    addon.ApplyColor(self.subSelectLabel, "SetTextColor", CT.dim_text);
    self:RefreshActivities();
end

------------------------------------------------------------------------
-- BUILD
------------------------------------------------------------------------

local function BuildActivitiesPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, ActivitiesPanelMixin);

    -- Left column: Categories
    panel.activitiesHeader = addon.MakeHeader(panel, "Categories", addon.SET_COL);
    panel.activitiesHeader:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD);
    panel.activitiesCount = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    panel.activitiesCount:SetPoint(addon.RIGHT, panel.activitiesHeader, addon.RIGHT, -6, 0);
    panel.activitiesBG, panel.actContent, panel.actReset = addon.MakeScrollBox(panel, addon.SET_COL, SCRL_H);
    panel.activitiesBG:SetPoint(addon.TOPLEFT, panel.activitiesHeader, addon.BOTTOMLEFT, 0, -4);
    panel.resetBtn = addon.MakeBtn(panel, "Reset All Defaults", addon.SET_COL, BTN_H);
    panel.resetBtn:SetPoint(addon.TOPLEFT, panel.activitiesBG, addon.BOTTOMLEFT, 0, -GAP);

    -- Right column: Sub-Activities
    panel.subHeader = addon.MakeHeader(panel, "Sub-Activities", addon.SET_COL);
    panel.subHeader:SetPoint(addon.TOPLEFT, panel.activitiesHeader, addon.TOPRIGHT, 12, 0);
    panel.subCount = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    panel.subCount:SetPoint(addon.RIGHT, panel.subHeader, addon.RIGHT, -6, 0);
    panel.subSelectLabel = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    panel.subSelectLabel:SetPoint(addon.TOPLEFT, panel.subHeader, addon.BOTTOMLEFT, 4, -4);
    panel.subSelectLabel:SetText("(click a category to edit its sub-activities)");
    panel.subSelectLabel:SetWidth(addon.SET_COL);
    panel.subBG, panel.subContent, panel.subReset = addon.MakeScrollBox(panel, addon.SET_COL, SCRL_H);
    panel.subBG:SetPoint(addon.TOPLEFT, panel.subHeader, addon.BOTTOMLEFT, 0, -28);

    -- State
    panel.selectedActivity = nil;
    panel.activitiesRowPool = CreateFramePool(addon.BUTTON, panel.actContent, addon.BACKDROP_TEMPLATE);
    panel.subRowPool = CreateFramePool(addon.BUTTON, panel.subContent, addon.BACKDROP_TEMPLATE);

    addon.ApplyColor(panel.activitiesCount, "SetTextColor", CT.dim_text);
    addon.ApplyColor(panel.subCount, "SetTextColor", CT.dim_text);
    addon.ApplyColor(panel.subSelectLabel, "SetTextColor", CT.dim_text);

    panel.resetBtn:SetScript(addon.OnClick, function() panel:ResetBtnOnClick(); end);
    panel:SetScript(addon.OnShow, panel.RefreshActivities);

    return panel;
end
addon.BuildActivitiesPanel = BuildActivitiesPanel;