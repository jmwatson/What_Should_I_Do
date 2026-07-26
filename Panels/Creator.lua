-- Panels/Creator.lua
-- Author: I_AM_T3X | v1.0.0

function BuildCreatorPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Character Creator")
    hdr:SetPoint("TOPLEFT", panel, "TOPLEFT", WSID_PAD, -WSID_PAD)

    local desc = MakeDimLabel(panel, "Spin a random valid Race + Class combo for a new character.", hdr, "BOTTOMLEFT", 4, -8)

    local raceBox, raceLabel = MakeResult(panel, nil, 52, "RACE")
    raceBox:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", -4, -12)
    raceLabel:SetText("Race")

    local classBox, classLabel = MakeResult(panel, nil, 52, "CLASS")
    classBox:SetPoint("TOPLEFT", raceBox, "BOTTOMLEFT", 0, -10)
    classLabel:SetText("Class")

    local infoLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    infoLbl:SetPoint("TOPLEFT", classBox, "BOTTOMLEFT", 4, -8)
    infoLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    infoLbl:SetText(" ")

    -- Faction filter
    local filterLbl = panel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    filterLbl:SetPoint("TOPLEFT", infoLbl, "BOTTOMLEFT", 0, -8)
    filterLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    filterLbl:SetText("Faction:")

    local factionFilter = "Any"
    local filterBtns = {}
    for i, opt in ipairs({"Any","Alliance","Horde"}) do
        local fb = MakeBtn(panel, opt, 84, 26)
        fb:SetPoint("LEFT", filterLbl, "RIGHT", 6+(i-1)*88, 0)
        local fo = opt
        local function Activate(b)
            b:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
            b:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
            b._lbl:SetTextColor(1,1,1)
        end
        local function Deactivate(b)
            b:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
            b:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
            b._lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
        end
        fb:SetScript("OnClick", function()
            factionFilter=fo
            for _,b in ipairs(filterBtns) do Deactivate(b) end
            Activate(fb)
        end)
        table.insert(filterBtns, fb)
    end
    Activate = function(b)
        b:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
        b:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
        b._lbl:SetTextColor(1,1,1)
    end
    filterBtns[1]:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
    filterBtns[1]:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
    filterBtns[1]._lbl:SetTextColor(1,1,1)

    local spinRaceBtn = MakeBtn(panel, "Spin Race", nil, 30)
    spinRaceBtn:SetPoint("TOP", filterLbl, "BOTTOM", 0, -10)
    spinRaceBtn:SetPoint("LEFT",    panel, "LEFT",  WSID_PAD, 0)
    spinRaceBtn:SetPoint("RIGHT",   panel, "CENTER", -3, 0)

    local spinClassBtn = MakeBtn(panel, "Spin Class", nil, 30)
    spinClassBtn:SetPoint("TOP", filterLbl, "BOTTOM", 0, -10)
    spinClassBtn:SetPoint("LEFT",    panel, "CENTER", 3, 0)
    spinClassBtn:SetPoint("RIGHT",   panel, "RIGHT", -WSID_PAD, 0)
    spinClassBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint("TOP", spinRaceBtn, "BOTTOM", 0, -6)
    spinBothBtn:SetPoint("LEFT",    panel, "LEFT",  WSID_PAD, 0)
    spinBothBtn:SetPoint("RIGHT",   panel, "RIGHT", -WSID_PAD, 0)

    local pickedRace = nil

    local function GetRaceNames()
        local names={}
        for _, key in ipairs(WSID_RACE_ORDER) do
            local race = WSID_RACE_INFO[key]
            if race and (factionFilter=="Any" or race.faction==factionFilter or race.faction==NEUTRAL) then
                table.insert(names, race.name)
            end
        end
        return names
    end

    local function AfterRace(winner)
        pickedRace = WSID_RACE_INFO[winner]
        raceLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
        if pickedRace then
            local fc = pickedRace.faction=="Alliance" and "|cff4499ff"
                    or pickedRace.faction=="Horde"    and "|cffff4444" or "|cffaaaaaa"
            infoLbl:SetText(pickedRace.rtype.."  --  "..fc..pickedRace.faction.."|r")
        end
        spinRaceBtn:SetEnabled(true)
        spinBothBtn:SetEnabled(true)
        spinClassBtn:SetEnabled(true)
    end

    local function SpinRaceBtnClick()
        local names=GetRaceNames()
        if #names>0 then
            StopSlot()
            spinRaceBtn:SetEnabled(false)
            spinBothBtn:SetEnabled(false)
            spinClassBtn:SetEnabled(false)
            pickedRace=nil
            classLabel:SetText("Class")
            classLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
            infoLbl:SetText(" ")
            raceLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            StartSlot(raceLabel, names, AfterRace)
        end
    end

    local function SpinClassBtnClick()
        if pickedRace then
            local classes = pickedRace and pickedRace.classes or nil
            if classes then
                StopSlot()
                spinClassBtn:SetEnabled(false)
                classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
                StartSlot(classLabel, classes, function(w)
                    local cc=WSID_CLASS_INFO[w]
                    if cc then
                        classLabel:SetTextColor(cc.r,cc.g,cc.b)
                    else
                        classLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                    end
                    spinClassBtn:SetEnabled(true)
                end)
            end
        end
    end

    local function SpinBothBtnClick()
        local names=GetRaceNames()
        if #names==0 then return end
        StopSlot()
        spinRaceBtn:SetEnabled(false)
        spinClassBtn:SetEnabled(false)
        spinBothBtn:SetEnabled(false)
        pickedRace=nil
        classLabel:SetText("Class")
        classLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        infoLbl:SetText(" ")
        raceLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(raceLabel, names, function(winner)
            AfterRace(winner)
            spinRaceBtn:SetEnabled(false)
            spinBothBtn:SetEnabled(false)
            spinClassBtn:SetEnabled(false)
            local classes = pickedRace and pickedRace.classes or {}
            if #classes==0 then spinRaceBtn:SetEnabled(true)
                spinBothBtn:SetEnabled(true)
                return end
            classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
            StartSlot(classLabel, classes, function(cls)
                local cc=WSID_CLASS_INFO[cls]
                if cc then
                    classLabel:SetTextColor(cc.r,cc.g,cc.b)
                else
                    classLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                end
                spinRaceBtn:SetEnabled(true)
                spinClassBtn:SetEnabled(true)
                spinBothBtn:SetEnabled(true)
            end)
        end)
    end

    spinRaceBtn:SetScript("OnClick", SpinRaceBtnClick)
    spinClassBtn:SetScript("OnClick", SpinClassBtnClick)
    spinBothBtn:SetScript("OnClick", SpinBothBtnClick)

    return panel
end
