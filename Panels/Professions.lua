-- Panels/Professions.lua
-- Author: I_AM_T3X | v1.0.0

function BuildProfessionPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Profession Picker")
    hdr:SetPoint(WSID.TOPLEFT, panel, WSID.TOPLEFT, WSID.PAD, -WSID.PAD)

    local desc = MakeLabel(panel, "Spin two professions for your character.", hdr, WSID.BOTTOMLEFT, 4, -8)

    local prof1Box, prof1Label = MakeResult(panel, nil, 52, "PROFESSION 1")
    prof1Box:SetPoint(WSID.TOP, desc, WSID.BOTTOM, 0, -12)
    prof1Box:SetPoint(WSID.LEFT, panel, WSID.LEFT,  WSID.PAD, 0)
    prof1Box:SetPoint(WSID.RIGHT, panel, WSID.CENTER, -3, 0)
    prof1Label:SetText(WSID.DASH_DASH)

    local prof2Box, prof2Label = MakeResult(panel, nil, 52, "PROFESSION 2")
    prof2Box:SetPoint(WSID.TOP, desc, WSID.BOTTOM, 0, -12)
    prof2Box:SetPoint(WSID.LEFT, panel, WSID.CENTER, 3, 0)
    prof2Box:SetPoint(WSID.RIGHT, panel, WSID.RIGHT, -WSID.PAD, 0)
    prof2Label:SetText(WSID.DASH_DASH)

    local spinBtn = MakeBtn(panel, "Spin Professions", nil, 30)
    spinBtn:SetPoint(WSID.TOP, prof1Box, WSID.BOTTOM, 0, -10)
    spinBtn:SetPoint(WSID.LEFT, panel, WSID.LEFT,  WSID.PAD, 0)
    spinBtn:SetPoint(WSID.RIGHT, panel, WSID.RIGHT, -WSID.PAD, 0)

    -- Exclude farming professions checkbox
    local FARMING = WSID_FARM_PROFESSIONS

    local farmBox = CreateFrame(WSID.FRAME, nil, panel, WSID.BACKDROP_TEMPLATE)
    farmBox:SetSize(14, 14)
    farmBox:SetPoint(WSID.TOPLEFT, spinBtn, WSID.BOTTOMLEFT, 0, -14)
    farmBox:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})

    local farmCheck = farmBox:CreateTexture(nil,WSID.OVERLAY)
    farmCheck:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
    farmCheck:SetSize(16,16)
    farmCheck:SetPoint(WSID.CENTER, farmBox, WSID.CENTER, 0, 0)

    local farmLbl = panel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    farmLbl:SetPoint(WSID.LEFT, farmBox, WSID.RIGHT, 6, 0)
    farmLbl:SetText("Exclude farming professions (Herbalism, Mining, Skinning)")

    local function SetFarmState(on)
        if not WhatShouldIDoDB then return end
        WhatShouldIDoDB.excludeFarming = on
        local ac1,ac2,ac3   = COLOR_TABLE.accent      and COLOR_TABLE.accent[1]      or 0.84, COLOR_TABLE.accent      and COLOR_TABLE.accent[2]      or 0.67, COLOR_TABLE.accent      and COLOR_TABLE.accent[3]      or 0.20
        local rb1,rb2,rb3   = COLOR_TABLE.result_bg   and COLOR_TABLE.result_bg[1]   or 0.06, COLOR_TABLE.result_bg   and COLOR_TABLE.result_bg[2]   or 0.04, COLOR_TABLE.result_bg   and COLOR_TABLE.result_bg[3]   or 0.10
        local di1,di2,di3   = COLOR_TABLE.divider     and COLOR_TABLE.divider[1]     or 0.25, COLOR_TABLE.divider     and COLOR_TABLE.divider[2]     or 0.20, COLOR_TABLE.divider     and COLOR_TABLE.divider[3]     or 0.35
        local br1,br2,br3   = COLOR_TABLE.bright_text and COLOR_TABLE.bright_text[1] or 1.00, COLOR_TABLE.bright_text and COLOR_TABLE.bright_text[2] or 0.90, COLOR_TABLE.bright_text and COLOR_TABLE.bright_text[3] or 0.40
        local dm1,dm2,dm3   = COLOR_TABLE.dim_text    and COLOR_TABLE.dim_text[1]    or 0.50, COLOR_TABLE.dim_text    and COLOR_TABLE.dim_text[2]    or 0.45, COLOR_TABLE.dim_text    and COLOR_TABLE.dim_text[3]    or 0.55
        if on then
            farmBox:SetBackdropColor(rb1,rb2,rb3,1)
            farmBox:SetBackdropBorderColor(ac1,ac2,ac3,1)
            farmCheck:SetVertexColor(ac1,ac2,ac3,1)
            farmCheck:Show()
            farmLbl:SetTextColor(br1,br2,br3)
        else
            farmBox:SetBackdropColor(0.05,0.03,0.08,1)
            farmBox:SetBackdropBorderColor(di1,di2,di3,1)
            farmCheck:Hide()
            farmLbl:SetTextColor(dm1,dm2,dm3)
        end
    end

    local farmBtn = CreateFrame(WSID.BUTTON, nil, panel)
    farmBtn:SetHeight(20)
    farmBtn:SetPoint(WSID.TOPLEFT, spinBtn, WSID.BOTTOMLEFT, 0, -10)
    farmBtn:SetPoint(WSID.RIGHT,   panel,   WSID.RIGHT, -WSID.PAD, 0)
    farmBtn:SetScript(WSID.OnClick, function()
        SetFarmState(not (WhatShouldIDoDB and WhatShouldIDoDB.excludeFarming))
    end)

    -- Init state after frame shown (C table populated by then)
    panel:SetScript(WSID.OnShow, function()
        SetFarmState(WhatShouldIDoDB and WhatShouldIDoDB.excludeFarming or false)
        panel:SetScript(WSID.OnShow, nil)
    end)

    local spinning = false

    spinBtn:SetScript(WSID.OnClick, function()
        if spinning then return end
        local excludeFarming = WhatShouldIDoDB and WhatShouldIDoDB.excludeFarming
        local pool = {}
        for _, p in ipairs(WSID_PROFESSIONS) do
            if p ~= FISHING and p ~= COOKING then
                if not (excludeFarming and FARMING[p]) then
                    table.insert(pool, p)
                end
            end
        end
        if #pool < 2 then return end
        spinning = true
        spinBtn:SetEnabled(false)

        -- Pre-pick two different winners
        local idx1   = math.random(#pool)
        local winner1 = pool[idx1]
        local pool2  = {}
        for _, p in ipairs(pool) do if p ~= winner1 then table.insert(pool2, p) end end
        local winner2 = pool2[math.random(#pool2)]

        prof1Label:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        prof2Label:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])

        -- Chain: spin 1 then spin 2
        StartSlot(prof1Label, pool, function(_)
            prof1Label:SetText(winner1)
            prof1Label:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            StartSlot(prof2Label, pool2, function(_)
                prof2Label:SetText(winner2)
                prof2Label:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
                spinning = false
                spinBtn:SetEnabled(true)
            end)
        end)
    end)

    return panel
end

