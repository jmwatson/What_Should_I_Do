-- Panels/RaidsDungeons.lua
-- Author: I_AM_T3X | v1.0.0

WSID.BuildRaidDungeonPanel = function(contentArea)
    local panel = WSID.MakePanel(contentArea)
    local hdr = WSID.MakeHeader(panel, WSID.RAIDS_AND_DUNGEONS_LABEL)
    hdr:SetPoint(WSID.TOPLEFT, panel, WSID.TOPLEFT, WSID.PAD, -WSID.PAD)

    local desc = WSID.MakeLabel(panel, "Choose Raids or Dungeons, spin an expansion, then spin a random instance.", hdr, WSID.BOTTOMLEFT, 4, -8)

    -- Mode toggle: Raids or Dungeons
    local modeLbl = panel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    modeLbl:SetPoint(WSID.TOPLEFT, desc, WSID.BOTTOMLEFT, 0, -10)
    modeLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    modeLbl:SetText("Mode:")

    local mode = "Raids"
    local modeBtns = {}
    for i, m in ipairs({"Raids","Dungeons"}) do
        local mb = WSID.MakeBtn(panel, m, 100, 26)
        mb:SetPoint(WSID.LEFT, modeLbl, WSID.RIGHT, 6+(i-1)*104, 0)
        local mv = m
        mb:SetScript(WSID.OnClick, function()
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
    local expBox, expLabel = WSID.MakeResult(panel, nil, 52, "EXPANSION")
    expBox:SetPoint(WSID.TOPLEFT, modeLbl, WSID.BOTTOMLEFT, 0, -12)
    expLabel:SetText("Expansion")

    -- Instance result
    local instBox, instLabel = WSID.MakeResult(panel, nil, 52, "RAID / DUNGEON")
    instBox:SetPoint(WSID.TOPLEFT, expBox, WSID.BOTTOMLEFT, 0, -8)
    instLabel:SetText(WSID.DASH_DASH)

    -- Spin buttons
    local spinExpBtn = WSID.MakeBtn(panel, "Spin Expansion", nil, 30)
    spinExpBtn:SetPoint(WSID.TOP, instBox, WSID.BOTTOM, 0, -10)
    spinExpBtn:SetPoint(WSID.LEFT,    panel, WSID.LEFT,  WSID.PAD, 0)
    spinExpBtn:SetPoint(WSID.RIGHT,   panel, WSID.CENTER, -3, 0)

    local spinInstBtn = WSID.MakeBtn(panel, "Spin Instance", nil, 30)
    spinInstBtn:SetPoint(WSID.TOP, instBox, WSID.BOTTOM, 0, -10)
    spinInstBtn:SetPoint(WSID.LEFT,    panel, WSID.CENTER, 3, 0)
    spinInstBtn:SetPoint(WSID.RIGHT,   panel, WSID.RIGHT, -WSID.PAD, 0)
    spinInstBtn:SetEnabled(false)

    local spinBothBtn = WSID.MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint(WSID.TOP, spinExpBtn, WSID.BOTTOM, 0, -6)
    spinBothBtn:SetPoint(WSID.LEFT,    panel, WSID.LEFT,  WSID.PAD, 0)
    spinBothBtn:SetPoint(WSID.RIGHT,   panel, WSID.RIGHT, -WSID.PAD, 0)

    local pickedExp = nil

    local function GetExpansionList()
        local pool = {}
        local src = mode == "Raids" and WSID.RAIDS_BY_EXPANSION or WSID.DUNGEONS_BY_EXPANSION
        local excluded = WhatShouldIDoDB and WhatShouldIDoDB.excludedExpansions or {}
        for exp, instances in pairs(src) do
            if exp and #instances > 0 and not excluded[exp] then
                table.insert(pool, exp)
            end
        end
        -- Sort chronologically using the central index map
        table.sort(pool, function(a,b)
            local ai = WSID.EXPANSION_INDEX[a] or 99
            local bi = WSID.EXPANSION_INDEX[b] or 99
            return ai < bi
        end)
        return pool
    end

    local function GetInstanceList(exp)
        local src = mode == "Raids" and WSID.RAIDS_BY_EXPANSION or WSID.DUNGEONS_BY_EXPANSION
        return src[exp] or {}
    end

    spinExpBtn:SetScript(WSID.OnClick, function()
        local pool = GetExpansionList()
        if #pool == 0 then return end
        WSID.StopSlot()
        spinExpBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false)
        spinInstBtn:SetEnabled(false) ; pickedExp = nil
        instLabel:SetText(WSID.DASH_DASH) ; instLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        expLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        WSID.StartSlot(expLabel, pool, function(winner)
            pickedExp = winner
            expLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinInstBtn:SetEnabled(true)
        end)
    end)

    spinInstBtn:SetScript(WSID.OnClick, function()
        if not pickedExp then return end
        local pool = GetInstanceList(pickedExp)
        if #pool == 0 then instLabel:SetText("None found") return end
        WSID.StopSlot() ; spinInstBtn:SetEnabled(false)
        instLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        WSID.StartSlot(instLabel, pool, function(_)
            instLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            spinInstBtn:SetEnabled(true)
        end)
    end)

    spinBothBtn:SetScript(WSID.OnClick, function()
        local pool = GetExpansionList()
        if #pool == 0 then return end
        WSID.StopSlot()
        spinExpBtn:SetEnabled(false) ; spinBothBtn:SetEnabled(false) ; spinInstBtn:SetEnabled(false)
        pickedExp = nil
        instLabel:SetText(WSID.DASH_DASH) ; instLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        expLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        WSID.StartSlot(expLabel, pool, function(winner)
            pickedExp = winner
            expLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            local instPool = GetInstanceList(winner)
            if #instPool == 0 then
                spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; return
            end
            instLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
            WSID.StartSlot(instLabel, instPool, function(_)
                instLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
                spinExpBtn:SetEnabled(true) ; spinBothBtn:SetEnabled(true) ; spinInstBtn:SetEnabled(true)
            end)
        end)
    end)

    return panel
end

