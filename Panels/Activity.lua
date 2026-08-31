local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

local ActivityPanelMixin = {};

function ActivityPanelMixin:ResetSub()
    self.subLabel:SetText("Sub-Activity");
    addon.ApplyColor(self.subLabel, "SetTextColor", CT.dim_text);
    self.spinSubBtn:SetEnabled(false);
    self.spinBothBtn:SetEnabled(false);
    self.lastCat = nil;
end

function ActivityPanelMixin:CatSlotStart(w)
    self.lastCat = w;
    addon.ApplyColor(self.catLabel, "SetTextColor", CT.spin_text);
    self.spinCatBtn:SetEnabled(true);
    self.spinSubBtn:SetEnabled(true);
    self.spinBothBtn:SetEnabled(true);
end

function ActivityPanelMixin:SubSlotStart()
    addon.ApplyColor(self.subLabel, "SetTextColor", CT.spin_text);
    self.spinSubBtn:SetEnabled(true);
end

function ActivityPanelMixin:BothSlotStart(w)
    self.lastCat = w
    addon.ApplyColor(self.catLabel, "SetTextColor", CT.spin_text);
    local sub = addon.GetSubActivities(w);
    
    if sub and #sub > 0 then
        addon.ApplyColor(self.subLabel, "SetTextColor", CT.bright_text);
        addon.StartSlot(self.subLabel, sub, function(_)
            addon.ApplyColor(self.subLabel, "SetTextColor", CT.spin_text);
            self.spinCatBtn:SetEnabled(true);
            self.spinSubBtn:SetEnabled(true);
            self.spinBothBtn:SetEnabled(true);
        end);
    else
        self.subLabel:SetText("(none)");
        self.spinCatBtn:SetEnabled(true);
        self.spinBothBtn:SetEnabled(true);
    end
end

function ActivityPanelMixin:CatBtnOnClick()
    local pool = addon.GetActivities();

    -- Early out if no activities available
    if #pool==0 then
        return;
    end

    addon.StopSlot();
    addon.ApplyColor(self.catLabel, "SetTextColor", CT.bright_text);
    self.spinCatBtn:SetEnabled(false);
    self:ResetSub();
    addon.StartSlot(self.catLabel, pool, function(w)
        self:CatSlotStart(w);
    end);
end

function ActivityPanelMixin:SubBtnOnClick()
    if not self.lastCat then
        return;
    end
    
    local pool = addon.GetSubActivities(self.lastCat);
    
    if not pool or #pool == 0 then
        self.subLabel:SetText("(none)");
        return;
    end

    addon.StopSlot();
    addon.ApplyColor(self.subLabel, "SetTextColor", CT.bright_text);
    self.spinSubBtn:SetEnabled(false);
    addon.StartSlot(self.subLabel, pool, function(_)
        self:SubSlotStart();
    end);
end

function ActivityPanelMixin:BothBtnOnClick()
    local pool = addon.GetActivities();

    if #pool == 0 then
        return;
    end

    addon.StopSlot();
    addon.ApplyColor(self.catLabel, "SetTextColor", CT.bright_text);
    self.spinCatBtn:SetEnabled(false);
    self:ResetSub();
    addon.StartSlot(self.catLabel, pool, function(w)
        self:BothSlotStart(w);
    end);
end

local function BuildActivityPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, ActivityPanelMixin);

    panel.lastCat = nil;
    panel.header = addon.MakeHeader(panel, "Activity Wheel");
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    panel.description = addon.MakeLabel(panel, "Spin a category, then spin a sub-activity.", panel.header, addon.BOTTOMLEFT, 4, -8);
    panel.catBox, panel.catLabel = addon.MakeResult(panel, nil, 52, "CATEGORY");
    panel.catBox:SetPoint(addon.TOPLEFT, panel.description, addon.BOTTOMLEFT, -4, -12);
    panel.catLabel:SetText("Category");
    panel.subBox, panel.subLabel = addon.MakeResult(panel, nil, 52, "SUB-ACTIVITY");
    panel.subBox:SetPoint(addon.TOPLEFT, panel.catBox, addon.BOTTOMLEFT, 0, -10);
    panel.subLabel:SetText("Sub-Activity");
    panel.spinCatBtn = addon.MakeBtn(panel, "Spin Category", nil, 30);
    panel.spinCatBtn:SetPoint(addon.TOP, panel.subBox, addon.BOTTOMLEFT, 0, -14);
    panel.spinCatBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.spinCatBtn:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);
    panel.spinSubBtn = addon.MakeBtn(panel, "Spin Sub-Activity", nil, 30);
    panel.spinBothBtn = addon.MakeBtn(panel, "Spin Both", nil, 30);
    panel.spinBothBtn:SetPoint(addon.TOP, panel.spinCatBtn, addon.BOTTOM, 0, -6);
    panel.spinBothBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.spinBothBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    panel.spinSubBtn:SetPoint(addon.TOP, panel.subBox, addon.BOTTOMLEFT, 0, -14);
    panel.spinSubBtn:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    panel.spinSubBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    panel.spinSubBtn:SetEnabled(false);

    panel.spinCatBtn:SetScript(addon.OnClick, function()
        panel:CatBtnOnClick();
    end);
    panel.spinBothBtn:SetScript(addon.OnClick, function()
        panel:BothBtnOnClick();
    end);
    panel.spinSubBtn:SetScript(addon.OnClick, function()
        panel:SubBtnOnClick();
    end);

    return panel;
end
addon.BuildActivityPanel = BuildActivityPanel;
