-- Panels/RaidsDungeons.lua
-- Author: I_AM_T3X | v1.0.0

function BuildRaidDungeonPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, WSID_RAIDS_AND_DUNGEONS_LABEL)
    hdr:SetPoint(WSID_TOPLEFT, panel, WSID_TOPLEFT, WSID_PAD, -WSID_PAD)

    local desc = MakeLabel(panel, "Choose Raids or Dungeons, spin an expansion, then spin a random instance.", hdr, WSID_BOTTOMLEFT, 4, -8)

    -- Mode toggle: Raids or Dungeons
    local modeLbl = panel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    modeLbl:SetPoint(WSID_TOPLEFT, desc, WSID_BOTTOMLEFT, 0, -10)
    modeLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    modeLbl:SetText("Mode:")

    local mode = "Raids"
    local modeBtns = {}
    for i, m in ipairs({"Raids","Dungeons"}) do
        local mb = MakeBtn(panel, m, 100, 26)
        mb:SetPoint(WSID_LEFT, modeLbl, WSID_RIGHT, 6+(i-1)*104, 0)
        local mv = m
        mb:SetScript(WSID_OnClick, function()
            mode = mv
            for _, b in ipairs(modeBtns) do
                b:SetBackdropColor(COLOR_TABLE.btn_bg[1],COLOR_TABLE.btn_bg[2],COLOR_TABLE.btn_bg[3])
                b:SetBackdropBorderColor(COLOR_TABLE.btn_bdr[1],COLOR_TABLE.btn_bdr[2],COLOR_TABLE.btn_bdr[3],1)
                b._lbl:SetTextColor(COLOR_TABLE.btn_text[1],COLOR_TABLE.btn_text[2],COLOR_TABLE.btn_text[3])
            end
            mb:SetBackdropColor(COLOR_TABLE.nav_active[1],COLOR_TABLE.nav_active[2],COLOR_TABLE.nav_active[3])
            mb:SetBackdropBorderColor(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
            mb._lbl:SetTextColor(1,1,1)
        end)
        table.insert(modeBtns, mb)
    end
    -- Default: Raids active
    modeBtns[1]:SetBackdropColor(COLOR_TABLE.nav_active[1],COLOR_TABLE.nav_active[2],COLOR_TABLE.nav_active[3])
    modeBtns[1]:SetBackdropBorderColor(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
    modeBtns[1]._lbl:SetTextColor(1,1,1)

    -- Expansion result
    local expBox, expLabel = MakeResult(panel, nil, 52, "EXPANSION")
    expBox:SetPoint(WSID_TOPLEFT, modeLbl, WSID_BOTTOMLEFT, 0, -12)
    expLabel:SetText("Expansion")

    -- Instance result
    local instBox, instLabel = MakeResult(panel, nil, 52, "RAID / DUNGEON")
    instBox:SetPoint(WSID_TOPLEFT, expBox, WSID_BOTTOMLEFT, 0, -8)
    instLabel:SetText(WSID_DASH_DASH)

    -- Spin buttons
    local spinExpBtn = MakeBtn(panel, "Spin Expansion", nil, 30)
    spinExpBtn:SetPoint(WSID_TOP, instBox, WSID_BOTTOM, 0, -10)
    spinExpBtn:SetPoint(WSID_LEFT,    panel, WSID_LEFT,  WSID_PAD, 0)
    spinExpBtn:SetPoint(WSID_RIGHT,   panel, WSID_CENTER, -3, 0)

    local spinInstBtn = MakeBtn(panel, "Spin Instance", nil, 30)
    spinInstBtn:SetPoint(WSID_TOP, instBox, WSID_BOTTOM, 0, -10)
    spinInstBtn:SetPoint(WSID_LEFT,    panel, WSID_CENTER, 3, 0)
    spinInstBtn:SetPoint(WSID_RIGHT,   panel, WSID_RIGHT, -WSID_PAD, 0)
    spinInstBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint(WSID_TOP, spinExpBtn, WSID_BOTTOM, 0, -6)
    spinBothBtn:SetPoint(WSID_LEFT,    panel, WSID_LEFT,  WSID_PAD, 0)
    spinBothBtn:SetPoint(WSID_RIGHT,   panel, WSID_RIGHT, -WSID_PAD, 0)

    local pickedExp = nil

    local function GetExpansionList()
        local pool = {}
        local src = mode == "Raids" and WSID_RAIDS_BY_EXPANSION or WSID_DUNGEONS_BY_EXPANSION
        local excluded = WhatShouldIDoDB and WhatShouldIDoDB.excludedExpansions or {}
        for exp, instances in pairs(src) do
            if exp and #instances > 0 and not excluded[exp] then
                table.insert(pool, exp)
            end
        end
        -- Sort chronologically using the central index map
        table.sort(pool, function(a,b)
            local ai = WSID_EXPANSION_INDEX[a] or 99
            local bi = WSID_EXPANSION_INDEX[b] or 99
            return ai < bi
        end)
        return pool
    end

    local function GetInstanceList(exp)
        local src = mode == "Raids" and WSID_RAIDS_BY_EXPANSION or WSID_DUNGEONS_BY_EXPANSION
        return src[exp] or {}
    end

    spinExpBtn:SetScript(WSID_OnClick, function()
        local pool = GetExpansionList()
        if #pool == 0 then return end
        StopSlot()
        spinExpBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false)
        spinInstBtn:SetEnabled(false) ; pickedExp = nil
        instLabel:SetText(WSID_DASH_DASH) ; instLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        expLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        StartSlot(expLabel, pool, function(winner)
            pickedExp = winner
            expLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinInstBtn:SetEnabled(true)
        end)
    end)

    spinInstBtn:SetScript(WSID_OnClick, function()
        if not pickedExp then return end
        local pool = GetInstanceList(pickedExp)
        if #pool == 0 then instLabel:SetText("None found") return end
        StopSlot() ; spinInstBtn:SetEnabled(false)
        instLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        StartSlot(instLabel, pool, function(_)
            instLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            spinInstBtn:SetEnabled(true)
        end)
    end)

    spinBothBtn:SetScript(WSID_OnClick, function()
        local pool = GetExpansionList()
        if #pool == 0 then return end
        StopSlot()
        spinExpBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false) ; spinInstBtn:SetEnabled(false)
        pickedExp = nil
        instLabel:SetText(WSID_DASH_DASH) ; instLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        expLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        StartSlot(expLabel, pool, function(winner)
            pickedExp = winner
            expLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            local instPool = GetInstanceList(winner)
            if #instPool == 0 then
                spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; return
            end
            instLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
            StartSlot(instLabel, instPool, function(_)
                instLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
                spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinInstBtn:SetEnabled(true)
            end)
        end)
    end)

    return panel
end

