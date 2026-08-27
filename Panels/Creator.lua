local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;
local defaultFaction = "Any";

local function Activate(b)
    addon.ApplyColor(b, "SetBackdropColor", CT.nav_active);
    addon.ApplyColor(b, "SetBackdropBorderColor", CT.nav_border);
    addon.ApplyColor(b._lbl, "SetTextColor", addon.BLACK);
end

local function Deactivate(b)
    addon.ApplyColor(b, "SetBackdropColor", CT.btn_bg);
    addon.ApplyColor(b, "SetBackdropBorderColor", CT.btn_bdr);
    addon.ApplyColor(b._lbl, "SetTextColor", CT.btn_text);
end

local CreatorPanelMixin = {};

function CreatorPanelMixin:GetRaceNames()
    local names={}
    for _, race in ipairs(addon.RACE_INFO) do
        if race and (self.factionFilter == defaultFaction or race.faction == self.factionFilter or race.faction == addon.NEUTRAL) then
            table.insert(names, race.name)
        end
    end
    return names
end

function CreatorPanelMixin:FactionBtnClick(btn, faction)
    self.factionFilter = faction;
    for _,b in ipairs(self.filterBtns) do Deactivate(b); end
    Activate(btn);
end

function CreatorPanelMixin:MakeFactionBtn(faction)
    local offset = faction == addon.ALLIANCE and 1 or faction == addon.HORDE and 2 or 0;
    local btn = addon.MakeBtn(self, faction, 84, 26);
    btn:SetPoint(addon.LEFT, self.filterLabel, addon.RIGHT, 6 + offset * 88, 0);
    btn:SetScript(addon.OnClick, function() self:FactionBtnClick(btn, faction); end);
    return btn;
end

function CreatorPanelMixin:SetPick(winner)
    addon.ApplyColor(self.raceLabel, "SetTextColor", CT.spin_text);
    self.spinRaceBtn:SetEnabled(true);
    self.spinBothBtn:SetEnabled(true);
    self.spinClassBtn:SetEnabled(true);
    self.pickedRace = addon.RACE_INFO[winner];

    if self.pickedRace then
        local fc = self.pickedRace.faction == addon.ALLIANCE and "|cff4499ff"
                or self.pickedRace.faction == addon.HORDE    and "|cffff4444" or "|cffaaaaaa";
        self.infoLabel:SetText(self.pickedRace.rtype.."  --  "..fc..self.pickedRace.faction.."|r");
    end
end

function CreatorPanelMixin:UpdateClass(class)
    local cc = addon.CLASS_INFO[class];

    if cc then
        addon.ApplyColor(self.classLabel, "SetTextColor", {cc.r, cc.g, cc.b});
    else
        addon.ApplyColor(self.classLabel, "SetTextColor", CT.spin_text);
    end

    self.spinRaceBtn:SetEnabled(true);
    self.spinClassBtn:SetEnabled(true);
    self.spinBothBtn:SetEnabled(true);
end

function CreatorPanelMixin:FinalizePick(winner)
    self:SetPick(winner);
    local classes = self.pickedRace and self.pickedRace.classes or {};

    self.spinRaceBtn:SetEnabled(false);
    self.spinBothBtn:SetEnabled(false);
    self.spinClassBtn:SetEnabled(false);

    if #classes == 0 then self.spinRaceBtn:SetEnabled(true)
        self.spinBothBtn:SetEnabled(true);
        return;
    end

    addon.ApplyColor(self.classLabel, "SetTextColor", CT.bright_text);
    addon.StartSlot(self.classLabel, classes, function(w) self:UpdateClass(w); end);
end

function CreatorPanelMixin:SpinBothBtnClick()
    local names = addon.GetRaceNames();
    self.pickedRace = nil;

    if #names == 0 then
        return;
    end

    addon.StopSlot();
    self.classLabel:SetText("Class");
    self.infoLabel:SetText(" ");
    self.spinRaceBtn:SetEnabled(false);
    self.spinClassBtn:SetEnabled(false);
    self.spinBothBtn:SetEnabled(false);
    addon.ApplyColor(self.classLabel, "SetTextColor", CT.dim_text);
    addon.ApplyColor(self.raceLabel, "SetTextColor", CT.bright_text);
    addon.StartSlot(self.raceLabel, names, function(winner) self:FinalizePick(winner); end);
end

function CreatorPanelMixin:SpinRaceBtnClick()
    local names = self:GetRaceNames();
    if #names > 0 then
        addon.StopSlot();
        self.pickedRace = nil;
        self.spinRaceBtn:SetEnabled(false);
        self.spinBothBtn:SetEnabled(false);
        self.spinClassBtn:SetEnabled(false);
        self.classLabel:SetText("Class");
        self.infoLabel:SetText(" ");
        addon.ApplyColor(self.classLabel, "SetTextColor", CT.dim_text);
        addon.ApplyColor(self.raceLabel, "SetTextColor", CT.bright_text);
        addon.StartSlot(self.raceLabel, names, function(winner) self:FinalizePick(winner); end);
    end
end

function CreatorPanelMixin:SpinClassBtnClick()
    if self.pickedRace then
        local classes = self.pickedRace and self.pickedRace.classes or nil;
        if classes then
            addon.StopSlot();
            self.spinClassBtn:SetEnabled(false);
            addon.ApplyColor(self.classLabel, "SetTextColor", CT.bright_text);
            addon.StartSlot(self.classLabel, classes, function(winner) self:UpdateClass(winner); end);
        end
    end
end

local function BuildCreatorPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, CreatorPanelMixin);

    panel.factionFilter = defaultFaction;
    panel.pickedRace = nil;
    panel.header = addon.MakeHeader(panel, "Character Creator");
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    panel.desc = addon.MakeLabel(panel, "Spin a random valid Race + Class combo for a new character.", panel.header, addon.BOTTOMLEFT, 4, -8);
    panel.raceBox, panel.raceLabel = addon.MakeResult(panel, nil, 52, "RACE");
    panel.raceBox:SetPoint(addon.TOPLEFT, panel.desc, addon.BOTTOMLEFT, -4, -12);
    panel.raceLabel:SetText("Race");
    panel.classBox, panel.classLabel = addon.MakeResult(panel, nil, 52, "CLASS");
    panel.classBox:SetPoint(addon.TOPLEFT, panel.raceBox, addon.BOTTOMLEFT, 0, -10);
    panel.classLabel:SetText("Class");
    panel.infoLabel = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.filterLabel = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.filterLabel:SetPoint(addon.TOPLEFT, panel.infoLabel, addon.BOTTOMLEFT, 0, -8);
    panel.filterLabel:SetText("Faction:");
    panel.infoLabel:SetPoint(addon.TOPLEFT, panel.classBox, addon.BOTTOMLEFT, 4, -8);
    panel.infoLabel:SetText(" ");

    addon.ApplyColor(panel.infoLabel, "SetTextColor", CT.dim_text);
    addon.ApplyColor(panel.filterLabel, "SetTextColor", CT.dim_text);

    panel.filterBtns = {
        panel:MakeFactionBtn(defaultFaction),
        panel:MakeFactionBtn(addon.ALLIANCE),
        panel:MakeFactionBtn(addon.HORDE)
    };

    addon.ApplyColor(panel.filterBtns[1], "SetBackdropColor", CT.nav_active);
    addon.ApplyColor(panel.filterBtns[1], "SetBackdropBorderColor", CT.nav_border);
    addon.ApplyColor(panel.filterBtns[1]._lbl, "SetTextColor", addon.BLACK);

    panel.spinRaceBtn = addon.MakeBtn(panel, "Spin Race", nil, 30);
    panel.spinRaceBtn:SetPoint(addon.TOP, panel.filterLabel, addon.BOTTOM, 0, -10);
    panel.spinRaceBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.spinRaceBtn:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);
    panel.spinClassBtn = addon.MakeBtn(panel, "Spin Class", nil, 30);
    panel.spinClassBtn:SetPoint(addon.TOP, panel.filterLabel, addon.BOTTOM, 0, -10);
    panel.spinClassBtn:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    panel.spinClassBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    panel.spinClassBtn:SetEnabled(false);
    panel.spinBothBtn = addon.MakeBtn(panel, "Spin Both", nil, 30);
    panel.spinBothBtn:SetPoint(addon.TOP, panel.spinRaceBtn, addon.BOTTOM, 0, -6);
    panel.spinBothBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.spinBothBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);

    panel.spinRaceBtn:SetScript(addon.OnClick, function() panel:SpinRaceBtnClick(); end);
    panel.spinClassBtn:SetScript(addon.OnClick, function() panel:SpinClassBtnClick(); end);
    panel.spinBothBtn:SetScript(addon.OnClick, function() panel:SpinBothBtnClick(); end);

    return panel;
end
addon.BuildCreatorPanel = BuildCreatorPanel;
