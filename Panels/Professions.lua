local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

local ProfessionPanelMixin = {};

function ProfessionPanelMixin:SetFarmState(shouldExclude)
    if not DB then
        return;
    end

    DB.excludeFarming = shouldExclude;

    if shouldExclude then
        addon.ApplyColor(self.farmBox, "SetBackdropColor", CT.result_bg or {0.06, 0.04, 0.1});
        addon.ApplyColor(self.farmBox, "SetBackdropBorderColor", CT.accent or {0.84, 0.67, 0.2});
        addon.ApplyColor(self.farmCheck, "SetVertexColor", CT.accent or {0.84, 0.67, 0.2});
        addon.ApplyColor(self.farmLbl, "SetTextColor", CT.bright_text or {1.0, 0.9, 0.4});
        self.farmCheck:Show();
    else
        addon.ApplyColor(self.farmBox, "SetBackdropColor", {0.05, 0.03, 0.08});
        addon.ApplyColor(self.farmBox, "SetBackdropBorderColor", CT.divider or {0.25, 0.2, 0.35});
        addon.ApplyColor(self.farmLbl, "SetTextColor", CT.dim_text or {0.5, 0.45, 0.55});
        self.farmCheck:Hide();
    end
end

function ProfessionPanelMixin:SpinBtnClick()
    if self.spinning then
        return;
    end

    local excludeFarming = DB and DB.excludeFarming;
    local pool = {};

    for _, p in ipairs(addon.PROFESSIONS) do
        if p ~= addon.FISHING and p ~= addon.COOKING and not (excludeFarming and addon.FARM_PROFESSIONS[p]) then
            table.insert(pool, p);
        end
    end

    if #pool < 2 then
        return;
    end

    self.spinning = true;
    self.spinBtn:SetEnabled(false);

    -- Pre-pick two different winners
    local idx1   = math.random(#pool);
    local winner1 = pool[idx1];
    local pool2  = {};

    for _, p in ipairs(pool) do
        if p ~= winner1 then
            table.insert(pool2, p);
        end
    end

    local winner2 = pool2[math.random(#pool2)];

    addon.ApplyColor(self.prof1Label, "SetTextColor", CT.bright_text);
    addon.ApplyColor(self.prof2Label, "SetTextColor", CT.bright_text);

    -- Chain: spin 1 then spin 2
    addon.StartSlot(self.prof1Label, pool, function(_)
        self.prof1Label:SetText(winner1);
        addon.ApplyColor(self.prof1Label, "SetTextColor", CT.spin_text);
        addon.StartSlot(self.prof2Label, pool2, function(_)
            self.prof2Label:SetText(winner2);
            addon.ApplyColor(self.prof2Label, "SetTextColor", CT.spin_text);
            self.spinning = false;
            self.spinBtn:SetEnabled(true);
        end);
    end);
end

local function BuildProfessionPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, ProfessionPanelMixin);

    panel.spinning = false;
    panel.header = addon.MakeHeader(panel, "Profession Picker");
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    panel.desc = addon.MakeLabel(panel, "Spin two professions for your character.", panel.header, addon.BOTTOMLEFT, 4, -8);
    panel.prof1Box, panel.prof1Label = addon.MakeResult(panel, nil, 52, "PROFESSION 1");
    panel.prof1Box:SetPoint(addon.TOP, panel.desc, addon.BOTTOM, 0, -12);
    panel.prof1Box:SetPoint(addon.LEFT, panel, addon.LEFT,  addon.PAD, 0);
    panel.prof1Box:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);
    panel.prof1Label:SetText(addon.DASH_DASH);
    panel.prof2Box, panel.prof2Label = addon.MakeResult(panel, nil, 52, "PROFESSION 2");
    panel.prof2Box:SetPoint(addon.TOP, panel.desc, addon.BOTTOM, 0, -12);
    panel.prof2Box:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    panel.prof2Box:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    panel.prof2Label:SetText(addon.DASH_DASH);
    panel.spinBtn = addon.MakeBtn(panel, "Spin Professions", nil, 30);
    panel.spinBtn:SetPoint(addon.TOP, panel.prof1Box, addon.BOTTOM, 0, -10);
    panel.spinBtn:SetPoint(addon.LEFT, panel, addon.LEFT,  addon.PAD, 0);
    panel.spinBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);

    -- Exclude farming professions checkbox
    panel.farmBox = CreateFrame(addon.FRAME, nil, panel, addon.BACKDROP_TEMPLATE);
    panel.farmBox:SetSize(14, 14);
    panel.farmBox:SetPoint(addon.TOPLEFT, panel.spinBtn, addon.BOTTOMLEFT, 0, -14);
    panel.farmBox:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1});
    panel.farmCheck = panel.farmBox:CreateTexture(nil,addon.OVERLAY);
    panel.farmCheck:SetTexture("Interface\\Buttons\\UI-CheckBox-Check");
    panel.farmCheck:SetSize(16,16);
    panel.farmCheck:SetPoint(addon.CENTER, panel.farmBox, addon.CENTER, 0, 0);
    panel.farmLbl = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.farmLbl:SetPoint(addon.LEFT, panel.farmBox, addon.RIGHT, 6, 0);
    panel.farmLbl:SetText("Exclude farming professions (Herbalism, Mining, Skinning)");
    panel.farmBtn = CreateFrame(addon.BUTTON, nil, panel);
    panel.farmBtn:SetHeight(20);
    panel.farmBtn:SetPoint(addon.TOPLEFT, panel.spinBtn, addon.BOTTOMLEFT, 0, -10);
    panel.farmBtn:SetPoint(addon.RIGHT,   panel,   addon.RIGHT, -addon.PAD, 0);
    panel.farmBtn:SetScript(addon.OnClick, function()
        panel:SetFarmState(not (DB and DB.excludeFarming));
    end);

    -- Init state after frame shown (C table populated by then)
    panel:SetScript(addon.OnShow, function()
        panel:SetFarmState(DB and DB.excludeFarming or false);
        panel:SetScript(addon.OnShow, nil);
    end);

    panel.spinBtn:SetScript(addon.OnClick, function() panel:SpinBtnClick(); end);

    return panel;
end
addon.BuildProfessionPanel = BuildProfessionPanel;

