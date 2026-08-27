local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local RAIDS = "Raids";
local DUNGEONS = "Dungeons";

local RaidDungeonPanelMixin = {};

function RaidDungeonPanelMixin:MakeModeBtn(mode)
    local offset = mode == RAIDS and 0 or 1;
    local btn = addon.MakeBtn(self, mode, 100, 26);
    btn:SetPoint(addon.LEFT, self.modeLbl, addon.RIGHT, 6 + offset * 104, 0);
    btn:SetScript(addon.OnClick, function()
        self.mode = mode;

        for _, b in ipairs(self.modeBtns) do
            addon.ApplyColor(b, "SetBackdropColor", CT.btn_bg);
            addon.ApplyColor(b, "SetBackdropBorderColor", CT.btn_bdr);
            addon.ApplyColor(b._lbl, "SetTextColor", CT.btn_text);
        end

        addon.ApplyColor(btn, "SetBackdropColor", CT.nav_active);
        addon.ApplyColor(btn, "SetBackdropBorderColor", CT.nav_border);
        addon.ApplyColor(btn._lbl, "SetTextColor", addon.BLACK);
    end);

    return btn;
end

function RaidDungeonPanelMixin:GetExpansionList()
    local pool = {};
    local src = self.mode == RAIDS and addon.RAIDS_BY_EXPANSION or addon.DUNGEONS_BY_EXPANSION;
    local excluded = DB and DB.excludedExpansions or {};

    for exp, instances in pairs(src) do
        if exp and #instances > 0 and not excluded[exp] then
            table.insert(pool, exp);
        end
    end
    -- Sort chronologically using the central index map

    table.sort(pool, function(a,b)
        local ai = addon.EXPANSION_INDEX[a] or 99;
        local bi = addon.EXPANSION_INDEX[b] or 99;
        return ai < bi;
    end);

    return pool;
end

function RaidDungeonPanelMixin:GetInstanceList(exp)
    local src = self.mode == RAIDS and addon.RAIDS_BY_EXPANSION or addon.DUNGEONS_BY_EXPANSION;
    return src[exp] or {};
end

function RaidDungeonPanelMixin:SetBtnEnabled(enabled)
    self.spinExpBtn:SetEnabled(enabled);
    self.spinBothBtn:SetEnabled(enabled);
    self.spinInstBtn:SetEnabled(enabled);
end

function RaidDungeonPanelMixin:SpinExpBtnClick()
    local pool = self:GetExpansionList();

    if #pool == 0 then
        return;
    end

    addon.StopSlot();
    self:SetBtnEnabled(false);
    self.picked = nil;
    self.instLabel:SetText(addon.DASH_DASH);
    addon.ApplyColor(self.instLabel, "SetTextColor", CT.dim_text);
    addon.ApplyColor(self.expLabel, "SetTextColor", CT.bright_text);
    addon.StartSlot(self.expLabel, pool, function(winner)
        self.picked = winner;
        self:SetBtnEnabled(true);
        addon.ApplyColor(self.expLabel, "SetTextColor", CT.spin_text);
    end);
end

function RaidDungeonPanelMixin:SpinInstBtnClick()
    if not self.picked then
        return;
    end

    local pool = self:GetInstanceList(self.picked);

    if #pool == 0 then
        self.instLabel:SetText("None found");
        return;
    end

    addon.StopSlot()
    self.spinInstBtn:SetEnabled(false);
    addon.ApplyColor(self.instLabel, "SetTextColor", CT.bright_text);
    addon.StartSlot(self.instLabel, pool, function(_)
        addon.ApplyColor(self.instLabel, "SetTextColor", CT.spin_text);
        self.spinInstBtn:SetEnabled(true);
    end);
end

function RaidDungeonPanelMixin:SpinBothBtnClick()
    local pool = self:GetExpansionList();

    if #pool == 0 then
        return;
    end

    addon.StopSlot();
    self:SetBtnEnabled(false);
    self.picked = nil;
    self.instLabel:SetText(addon.DASH_DASH);
    addon.ApplyColor(self.instLabel, "SetTextColor", CT.dim_text);
    addon.ApplyColor(self.expLabel, "SetTextColor", CT.bright_text);
    addon.StartSlot(self.expLabel, pool, function(winner)
        self.picked = winner;
        local instPool = self:GetInstanceList(winner);
        
        if #instPool == 0 then
            self.spinExpBtn:SetEnabled(true);
            self.spinBothBtn:SetEnabled(true);
            return;
        end
        
        addon.ApplyColor(self.expLabel, "SetTextColor", CT.spin_text);
        addon.ApplyColor(self.instLabel, "SetTextColor", CT.bright_text);
        addon.StartSlot(self.instLabel, instPool, function(_)
            addon.ApplyColor(self.instLabel, "SetTextColor", CT.spin_text);
            self:SetBtnEnabled(true);
        end);
    end);
end

local function BuildRaidDungeonPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, RaidDungeonPanelMixin);

    panel.header = addon.MakeHeader(panel, addon.RAIDS_AND_DUNGEONS_LABEL);
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    panel.desc = addon.MakeLabel(panel, "Choose Raids or Dungeons, spin an expansion, then spin a random instance.", panel.header, addon.BOTTOMLEFT, 4, -8);

    -- Mode toggle: Raids or Dungeons
    panel.modeLbl = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.modeLbl:SetPoint(addon.TOPLEFT, panel.desc, addon.BOTTOMLEFT, 0, -10);
    addon.ApplyColor(panel.modeLbl, "SetTextColor", CT.dim_text);
    panel.modeLbl:SetText("Mode:");

    panel.mode = RAIDS;
    panel.modeBtns = {
        panel:MakeModeBtn(RAIDS),
        panel:MakeModeBtn(DUNGEONS)
    };

    -- Default: Raids active
    addon.ApplyColor(panel.modeBtns[1], "SetBackdropColor", CT.nav_active);
    addon.ApplyColor(panel.modeBtns[1], "SetBackdropBorderColor", CT.nav_border);
    addon.ApplyColor(panel.modeBtns[1]._lbl, "SetTextColor", addon.BLACK);

    -- Expansion result
    panel.expBox, panel.expLabel = addon.MakeResult(panel, nil, 52, "EXPANSION");
    panel.expBox:SetPoint(addon.TOPLEFT, panel.modeLbl, addon.BOTTOMLEFT, 0, -12);
    panel.expLabel:SetText("Expansion");

    -- Instance result
    panel.instBox, panel.instLabel = addon.MakeResult(panel, nil, 52, "RAID / DUNGEON");
    panel.instBox:SetPoint(addon.TOPLEFT, panel.expBox, addon.BOTTOMLEFT, 0, -8);
    panel.instLabel:SetText(addon.DASH_DASH);

    -- Spin buttons
    panel.spinExpBtn = addon.MakeBtn(panel, "Spin Expansion", nil, 30);
    panel.spinExpBtn:SetPoint(addon.TOP, panel.instBox, addon.BOTTOM, 0, -10);
    panel.spinExpBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.spinExpBtn:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);

    panel.spinInstBtn = addon.MakeBtn(panel, "Spin Instance", nil, 30);
    panel.spinInstBtn:SetPoint(addon.TOP, panel.instBox, addon.BOTTOM, 0, -10);
    panel.spinInstBtn:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    panel.spinInstBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    panel.spinInstBtn:SetEnabled(false)

    panel.spinBothBtn = addon.MakeBtn(panel, "Spin Both", nil, 30);
    panel.spinBothBtn:SetPoint(addon.TOP, panel.spinExpBtn, addon.BOTTOM, 0, -6);
    panel.spinBothBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.spinBothBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);

    panel.picked = nil;

    panel.spinExpBtn:SetScript(addon.OnClick, function() panel:SpinExpBtnClick(); end);
    panel.spinInstBtn:SetScript(addon.OnClick, function() panel:SpinInstBtnClick(); end);
    panel.spinBothBtn:SetScript(addon.OnClick, function() panel:SpinBothBtnClick(); end);

    return panel;
end
addon.BuildRaidDungeonPanel = BuildRaidDungeonPanel;
