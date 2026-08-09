-- Panels/Creator.lua
-- Author: I_AM_T3X | v1.0.0

WSID.BuildCreatorPanel = function(contentArea)
    local panel = WSID.MakePanel(contentArea)
    local hdr = WSID.MakeHeader(panel, "Character Creator")
    hdr:SetPoint(WSID.TOPLEFT, panel, WSID.TOPLEFT, WSID.PAD, -WSID.PAD)

    local desc = WSID.MakeLabel(panel, "Spin a random valid Race + Class combo for a new character.", hdr, WSID.BOTTOMLEFT, 4, -8)

    local raceBox, raceLabel = WSID.MakeResult(panel, nil, 52, "RACE")
    raceBox:SetPoint(WSID.TOPLEFT, desc, WSID.BOTTOMLEFT, -4, -12)
    raceLabel:SetText("Race")

    local classBox, classLabel = WSID.MakeResult(panel, nil, 52, "CLASS")
    classBox:SetPoint(WSID.TOPLEFT, raceBox, WSID.BOTTOMLEFT, 0, -10)
    classLabel:SetText("Class")

    local infoLbl = panel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    infoLbl:SetPoint(WSID.TOPLEFT, classBox, WSID.BOTTOMLEFT, 4, -8)
    infoLbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.dim_text[1],WhatShouldIDoDB.COLOR_TABLE.dim_text[2],WhatShouldIDoDB.COLOR_TABLE.dim_text[3])
    infoLbl:SetText(" ")

    -- Faction filter
    local filterLbl = panel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    filterLbl:SetPoint(WSID.TOPLEFT, infoLbl, WSID.BOTTOMLEFT, 0, -8)
    filterLbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.dim_text[1],WhatShouldIDoDB.COLOR_TABLE.dim_text[2],WhatShouldIDoDB.COLOR_TABLE.dim_text[3])
    filterLbl:SetText("Faction:")

    local factionFilter = "Any"
    local filterBtns = {}
    
    local function Activate(b)
        b:SetBackdropColor(WhatShouldIDoDB.COLOR_TABLE.nav_active[1],WhatShouldIDoDB.COLOR_TABLE.nav_active[2],WhatShouldIDoDB.COLOR_TABLE.nav_active[3])
        b:SetBackdropBorderColor(WhatShouldIDoDB.COLOR_TABLE.nav_border[1],WhatShouldIDoDB.COLOR_TABLE.nav_border[2],WhatShouldIDoDB.COLOR_TABLE.nav_border[3],1)
        b._lbl:SetTextColor(1,1,1)
    end
    local function Deactivate(b)
        b:SetBackdropColor(WhatShouldIDoDB.COLOR_TABLE.btn_bg[1],WhatShouldIDoDB.COLOR_TABLE.btn_bg[2],WhatShouldIDoDB.COLOR_TABLE.btn_bg[3])
        b:SetBackdropBorderColor(WhatShouldIDoDB.COLOR_TABLE.btn_bdr[1],WhatShouldIDoDB.COLOR_TABLE.btn_bdr[2],WhatShouldIDoDB.COLOR_TABLE.btn_bdr[3],1)
        b._lbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.btn_text[1],WhatShouldIDoDB.COLOR_TABLE.btn_text[2],WhatShouldIDoDB.COLOR_TABLE.btn_text[3])
    end

    for i, opt in ipairs({"Any",WSID.ALLIANCE,WSID.HORDE}) do
        local fb = WSID.MakeBtn(panel, opt, 84, 26)
        fb:SetPoint(WSID.LEFT, filterLbl, WSID.RIGHT, 6+(i-1)*88, 0)
        local fo = opt
        fb:SetScript(WSID.OnClick, function()
            factionFilter=fo
            for _,b in ipairs(filterBtns) do Deactivate(b) end
            Activate(fb)
        end)
        table.insert(filterBtns, fb)
    end

    filterBtns[1]:SetBackdropColor(WhatShouldIDoDB.COLOR_TABLE.nav_active[1],WhatShouldIDoDB.COLOR_TABLE.nav_active[2],WhatShouldIDoDB.COLOR_TABLE.nav_active[3])
    filterBtns[1]:SetBackdropBorderColor(WhatShouldIDoDB.COLOR_TABLE.nav_border[1],WhatShouldIDoDB.COLOR_TABLE.nav_border[2],WhatShouldIDoDB.COLOR_TABLE.nav_border[3],1)
    filterBtns[1]._lbl:SetTextColor(1,1,1)

    local spinRaceBtn = WSID.MakeBtn(panel, "Spin Race", nil, 30)
    spinRaceBtn:SetPoint(WSID.TOP, filterLbl, WSID.BOTTOM, 0, -10)
    spinRaceBtn:SetPoint(WSID.LEFT,    panel, WSID.LEFT,  WSID.PAD, 0)
    spinRaceBtn:SetPoint(WSID.RIGHT,   panel, WSID.CENTER, -3, 0)

    local spinClassBtn = WSID.MakeBtn(panel, "Spin Class", nil, 30)
    spinClassBtn:SetPoint(WSID.TOP, filterLbl, WSID.BOTTOM, 0, -10)
    spinClassBtn:SetPoint(WSID.LEFT,    panel, WSID.CENTER, 3, 0)
    spinClassBtn:SetPoint(WSID.RIGHT,   panel, WSID.RIGHT, -WSID.PAD, 0)
    spinClassBtn:SetEnabled(false)

    local spinBothBtn = WSID.MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint(WSID.TOP, spinRaceBtn, WSID.BOTTOM, 0, -6)
    spinBothBtn:SetPoint(WSID.LEFT,    panel, WSID.LEFT,  WSID.PAD, 0)
    spinBothBtn:SetPoint(WSID.RIGHT,   panel, WSID.RIGHT, -WSID.PAD, 0)

    local pickedRace = nil

    local function GetRaceNames()
        local names={}
        for _, race in ipairs(WSID.RACE_INFO) do
            if race and (factionFilter=="Any" or race.faction==factionFilter or race.faction==WSID.NEUTRAL) then
                table.insert(names, race.name)
            end
        end
        return names
    end

    local function AfterRace(winner)
        pickedRace = WSID.RACE_INFO[winner]
        raceLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
        if pickedRace then
            local fc = pickedRace.faction==WSID.ALLIANCE and "|cff4499ff"
                    or pickedRace.faction==WSID.HORDE    and "|cffff4444" or "|cffaaaaaa"
            infoLbl:SetText(pickedRace.rtype.."  --  "..fc..pickedRace.faction.."|r")
        end
        spinRaceBtn:SetEnabled(true)
        spinBothBtn:SetEnabled(true)
        spinClassBtn:SetEnabled(true)
    end

    local function SpinRaceBtnClick()
        local names=GetRaceNames()
        if #names>0 then
            WSID.StopSlot()
            spinRaceBtn:SetEnabled(false)
            spinBothBtn:SetEnabled(false)
            spinClassBtn:SetEnabled(false)
            pickedRace=nil
            classLabel:SetText("Class")
            classLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.dim_text[1],WhatShouldIDoDB.COLOR_TABLE.dim_text[2],WhatShouldIDoDB.COLOR_TABLE.dim_text[3])
            infoLbl:SetText(" ")
            raceLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
            WSID.StartSlot(raceLabel, names, AfterRace)
        end
    end

    local function SpinClassBtnClick()
        if pickedRace then
            local classes = pickedRace and pickedRace.classes or nil
            if classes then
                WSID.StopSlot()
                spinClassBtn:SetEnabled(false)
                classLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
                WSID.StartSlot(classLabel, classes, function(w)
                    local cc=WSID.CLASS_INFO[w]
                    if cc then
                        classLabel:SetTextColor(cc.r,cc.g,cc.b)
                    else
                        classLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
                    end
                    spinClassBtn:SetEnabled(true)
                end)
            end
        end
    end

    local function SpinBothBtnClick()
        local names=GetRaceNames()
        if #names==0 then return end
        WSID.StopSlot()
        spinRaceBtn:SetEnabled(false)
        spinClassBtn:SetEnabled(false)
        spinBothBtn:SetEnabled(false)
        pickedRace=nil
        classLabel:SetText("Class")
        classLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.dim_text[1],WhatShouldIDoDB.COLOR_TABLE.dim_text[2],WhatShouldIDoDB.COLOR_TABLE.dim_text[3])
        infoLbl:SetText(" ")
        raceLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
        WSID.StartSlot(raceLabel, names, function(winner)
            AfterRace(winner)
            spinRaceBtn:SetEnabled(false)
            spinBothBtn:SetEnabled(false)
            spinClassBtn:SetEnabled(false)
            local classes = pickedRace and pickedRace.classes or {}
            if #classes==0 then spinRaceBtn:SetEnabled(true)
                spinBothBtn:SetEnabled(true)
                return end
            classLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
            WSID.StartSlot(classLabel, classes, function(cls)
                local cc=WSID.CLASS_INFO[cls]
                if cc then
                    classLabel:SetTextColor(cc.r,cc.g,cc.b)
                else
                    classLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
                end
                spinRaceBtn:SetEnabled(true)
                spinClassBtn:SetEnabled(true)
                spinBothBtn:SetEnabled(true)
            end)
        end)
    end

    spinRaceBtn:SetScript(WSID.OnClick, SpinRaceBtnClick)
    spinClassBtn:SetScript(WSID.OnClick, SpinClassBtnClick)
    spinBothBtn:SetScript(WSID.OnClick, SpinBothBtnClick)

    return panel
end
