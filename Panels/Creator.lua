local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;
local pickedRace = nil;
local factionFilter = "Any";
local filterBtns = {};

local function GetRaceNames()
    local names={}
    for _, race in ipairs(addon.RACE_INFO) do
        if race and (factionFilter == "Any" or race.faction == factionFilter or race.faction == addon.NEUTRAL) then
            table.insert(names, race.name)
        end
    end
    return names
end

local function Activate(b)
    b:SetBackdropColor(CT.nav_active[1], CT.nav_active[2], CT.nav_active[3]);
    b:SetBackdropBorderColor(CT.nav_border[1], CT.nav_border[2], CT.nav_border[3], 1);
    b._lbl:SetTextColor(1, 1, 1);
end

local function Deactivate(b)
    b:SetBackdropColor(CT.btn_bg[1], CT.btn_bg[2], CT.btn_bg[3]);
    b:SetBackdropBorderColor(CT.btn_bdr[1], CT.btn_bdr[2], CT.btn_bdr[3], 1);
    b._lbl:SetTextColor(CT.btn_text[1], CT.btn_text[2], CT.btn_text[3]);
end

local function FactionBtnClick(factionBtn, faction)
    local function _FactionBtnClick()
        factionFilter = faction;
        for _,b in ipairs(filterBtns) do Deactivate(b); end
        Activate(factionBtn);
    end
    return _FactionBtnClick;
end

local function BuildCreatorPanel(contentArea)
    local panel = addon.MakePanel(contentArea)
    local header = addon.MakeHeader(panel, "Character Creator");
    local description = addon.MakeLabel(panel, "Spin a random valid Race + Class combo for a new character.", header, addon.BOTTOMLEFT, 4, -8);
    local raceBox, raceLabel = addon.MakeResult(panel, nil, 52, "RACE");
    local classBox, classLabel = addon.MakeResult(panel, nil, 52, "CLASS");
    local infoLabel = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    local filterLabel = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);

    header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD)
    raceBox:SetPoint(addon.TOPLEFT, description, addon.BOTTOMLEFT, -4, -12)
    raceLabel:SetText("Race")
    classBox:SetPoint(addon.TOPLEFT, raceBox, addon.BOTTOMLEFT, 0, -10)
    classLabel:SetText("Class")
    infoLabel:SetPoint(addon.TOPLEFT, classBox, addon.BOTTOMLEFT, 4, -8)
    infoLabel:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3])
    infoLabel:SetText(" ")

    -- Faction filter
    filterLabel:SetPoint(addon.TOPLEFT, infoLabel, addon.BOTTOMLEFT, 0, -8)
    filterLabel:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3])
    filterLabel:SetText("Faction:")

    for i, faction in ipairs({"Any", addon.ALLIANCE, addon.HORDE}) do
        local factionBtn = addon.MakeBtn(panel, faction, 84, 26);
        factionBtn:SetPoint(addon.LEFT, filterLabel, addon.RIGHT, 6 + (i - 1) * 88, 0);
        factionBtn:SetScript(addon.OnClick, FactionBtnClick(factionBtn, faction));
        table.insert(filterBtns, factionBtn);
    end

    filterBtns[1]:SetBackdropColor(CT.nav_active[1], CT.nav_active[2], CT.nav_active[3]);
    filterBtns[1]:SetBackdropBorderColor(CT.nav_border[1], CT.nav_border[2], CT.nav_border[3], 1);
    filterBtns[1]._lbl:SetTextColor(1, 1, 1);

    local spinRaceBtn = addon.MakeBtn(panel, "Spin Race", nil, 30);
    local spinClassBtn = addon.MakeBtn(panel, "Spin Class", nil, 30);
    local spinBothBtn = addon.MakeBtn(panel, "Spin Both", nil, 30);

    spinRaceBtn:SetPoint(addon.TOP, filterLabel, addon.BOTTOM, 0, -10);
    spinRaceBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    spinRaceBtn:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);
    spinClassBtn:SetPoint(addon.TOP, filterLabel, addon.BOTTOM, 0, -10);
    spinClassBtn:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    spinClassBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    spinClassBtn:SetEnabled(false);
    spinBothBtn:SetPoint(addon.TOP, spinRaceBtn, addon.BOTTOM, 0, -6);
    spinBothBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    spinBothBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);

    local function SetPick(winner)
        raceLabel:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3])
        spinRaceBtn:SetEnabled(true)
        spinBothBtn:SetEnabled(true)
        spinClassBtn:SetEnabled(true)
        pickedRace = addon.RACE_INFO[winner]

        if pickedRace then
            local fc = pickedRace.faction == addon.ALLIANCE and "|cff4499ff"
                    or pickedRace.faction == addon.HORDE    and "|cffff4444" or "|cffaaaaaa"
            infoLabel:SetText(pickedRace.rtype.."  --  "..fc..pickedRace.faction.."|r")
        end
    end

    local function UpdateClass(class)
        local cc = addon.CLASS_INFO[class];

        if cc then
            classLabel:SetTextColor(cc.r, cc.g, cc.b);
        else
            classLabel:SetTextColor(CT.spin_text[1], CT.spin_text[2], CT.spin_text[3]);
        end

        spinRaceBtn:SetEnabled(true);
        spinClassBtn:SetEnabled(true);
        spinBothBtn:SetEnabled(true);
    end

    local function FinalizePick(winner)
        SetPick(winner)
        local classes = pickedRace and pickedRace.classes or {};

        spinRaceBtn:SetEnabled(false);
        spinBothBtn:SetEnabled(false);
        spinClassBtn:SetEnabled(false);

        if #classes == 0 then spinRaceBtn:SetEnabled(true)
            spinBothBtn:SetEnabled(true);
            return;
        end

        classLabel:SetTextColor(CT.bright_text[1], CT.bright_text[2], CT.bright_text[3]);
        addon.StartSlot(classLabel, classes, UpdateClass);
    end

    local function SpinBothBtnClick()
        local names = addon.GetRaceNames();
        pickedRace = nil;

        if #names == 0 then
            return;
        end

        addon.StopSlot();
        classLabel:SetText("Class");
        classLabel:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);
        infoLabel:SetText(" ");
        raceLabel:SetTextColor(CT.bright_text[1], CT.bright_text[2], CT.bright_text[3]);
        spinRaceBtn:SetEnabled(false);
        spinClassBtn:SetEnabled(false);
        spinBothBtn:SetEnabled(false);
        addon.StartSlot(raceLabel, names, FinalizePick);
    end

    local function SpinRaceBtnClick()
        local names=GetRaceNames()
        if #names>0 then
            addon.StopSlot()
            spinRaceBtn:SetEnabled(false)
            spinBothBtn:SetEnabled(false)
            spinClassBtn:SetEnabled(false)
            pickedRace=nil
            classLabel:SetText("Class")
            classLabel:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
            infoLabel:SetText(" ")
            raceLabel:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3])
            addon.StartSlot(raceLabel, names, FinalizePick)
        end
    end

    local function SpinClassBtnClick()
        if pickedRace then
            local classes = pickedRace and pickedRace.classes or nil;
            if classes then
                addon.StopSlot();
                spinClassBtn:SetEnabled(false);
                classLabel:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
                addon.StartSlot(classLabel, classes, function(w)
                    local cc=addon.CLASS_INFO[w];
                    if cc then
                        classLabel:SetTextColor(cc.r,cc.g,cc.b);
                    else
                        classLabel:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
                    end
                    spinClassBtn:SetEnabled(true);
                end);
            end
        end
    end

    spinRaceBtn:SetScript(addon.OnClick, SpinRaceBtnClick);
    spinClassBtn:SetScript(addon.OnClick, SpinClassBtnClick);
    spinBothBtn:SetScript(addon.OnClick, SpinBothBtnClick);

    return panel;
end
addon.BuildCreatorPanel = BuildCreatorPanel;
