-- Panels/Professions.lua
-- Author: I_AM_T3X | v1.0.0

function BuildProfessionPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Profession Picker")
    hdr:SetPoint(WSID_TOPLEFT, panel, WSID_TOPLEFT, WSID_PAD, -WSID_PAD)

    local desc = MakeLabel(panel, "Spin two professions for your character.", hdr, WSID_BOTTOMLEFT, 4, -8)

    local prof1Box, prof1Label = MakeResult(panel, nil, 52, "PROFESSION 1")
    prof1Box:SetPoint(WSID_TOP, desc, WSID_BOTTOM, 0, -12)
    prof1Box:SetPoint(WSID_LEFT, panel, WSID_LEFT,  WSID_PAD, 0)
    prof1Box:SetPoint(WSID_RIGHT, panel, WSID_CENTER, -3, 0)
    prof1Label:SetText(WSID_DASH_DASH)

    local prof2Box, prof2Label = MakeResult(panel, nil, 52, "PROFESSION 2")
    prof2Box:SetPoint(WSID_TOP, desc, WSID_BOTTOM, 0, -12)
    prof2Box:SetPoint(WSID_LEFT, panel, WSID_CENTER, 3, 0)
    prof2Box:SetPoint(WSID_RIGHT, panel, WSID_RIGHT, -WSID_PAD, 0)
    prof2Label:SetText(WSID_DASH_DASH)

    local spinBtn = MakeBtn(panel, "Spin Professions", nil, 30)
    spinBtn:SetPoint(WSID_TOP, prof1Box, WSID_BOTTOM, 0, -10)
    spinBtn:SetPoint(WSID_LEFT, panel, WSID_LEFT,  WSID_PAD, 0)
    spinBtn:SetPoint(WSID_RIGHT, panel, WSID_RIGHT, -WSID_PAD, 0)

    -- Exclude farming professions checkbox
    local FARMING = WSID_FARM_PROFESSIONS

    local farmBox = CreateFrame(WSID_FRAME, nil, panel, WSID_BACKDROP_TEMPLATE)
    farmBox:SetSize(14, 14)
    farmBox:SetPoint(WSID_TOPLEFT, spinBtn, WSID_BOTTOMLEFT, 0, -14)
    farmBox:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})

    local farmCheck = farmBox:CreateTexture(nil,WSID_OVERLAY)
    farmCheck:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
    farmCheck:SetSize(16,16)
    farmCheck:SetPoint(WSID_CENTER, farmBox, WSID_CENTER, 0, 0)

    local farmLbl = panel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    farmLbl:SetPoint(WSID_LEFT, farmBox, WSID_RIGHT, 6, 0)
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

    local farmBtn = CreateFrame(WSID_BUTTON, nil, panel)
    farmBtn:SetHeight(20)
    farmBtn:SetPoint(WSID_TOPLEFT, spinBtn, WSID_BOTTOMLEFT, 0, -10)
    farmBtn:SetPoint(WSID_RIGHT,   panel,   WSID_RIGHT, -WSID_PAD, 0)
    farmBtn:SetScript(WSID_OnClick, function()
        SetFarmState(not (WhatShouldIDoDB and WhatShouldIDoDB.excludeFarming))
    end)

    -- Init state after frame shown (C table populated by then)
    panel:SetScript(WSID_OnShow, function()
        SetFarmState(WhatShouldIDoDB and WhatShouldIDoDB.excludeFarming or false)
        panel:SetScript(WSID_OnShow, nil)
    end)

    local spinning = false

    spinBtn:SetScript(WSID_OnClick, function()
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

