-- Panels/Activity.lua
-- Author: I_AM_T3X | v1.0.0

WSID.BuildActivityPanel = function(contentArea)
    local panel = WSID.MakePanel(contentArea)
    local hdr = WSID.MakeHeader(panel, "Activity Wheel")
    hdr:SetPoint(WSID.TOPLEFT, panel, WSID.TOPLEFT, WSID.PAD, -WSID.PAD)

    local desc = WSID.MakeLabel(panel, "Spin a category, then spin a sub-activity.", hdr, WSID.BOTTOMLEFT, 4, -8)

    local catBox, catLabel = WSID.MakeResult(panel, nil, 52, "CATEGORY")
    catBox:SetPoint(WSID.TOPLEFT, desc, WSID.BOTTOMLEFT, -4, -12)
    catLabel:SetText("Category")

    local subBox, subLabel = WSID.MakeResult(panel, nil, 52, "SUB-ACTIVITY")
    subBox:SetPoint(WSID.TOPLEFT, catBox, WSID.BOTTOMLEFT, 0, -10)
    subLabel:SetText("Sub-Activity")

    local spinCatBtn = WSID.MakeBtn(panel, "Spin Category", nil, 30)
    spinCatBtn:SetPoint(WSID.TOP, subBox, WSID.BOTTOMLEFT, 0, -14)
    spinCatBtn:SetPoint(WSID.LEFT, panel, WSID.LEFT, WSID.PAD, 0)
    spinCatBtn:SetPoint(WSID.RIGHT, panel, WSID.CENTER, -3, 0)

    local spinSubBtn = WSID.MakeBtn(panel, "Spin Sub-Activity", nil, 30)
    spinSubBtn:SetPoint(WSID.TOP, subBox, WSID.BOTTOMLEFT, 0, -14)
    spinSubBtn:SetPoint(WSID.LEFT, panel, WSID.CENTER, 3, 0)
    spinSubBtn:SetPoint(WSID.RIGHT, panel, WSID.RIGHT, -WSID.PAD, 0)
    spinSubBtn:SetEnabled(false)

    local spinBothBtn = WSID.MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint(WSID.TOP, spinCatBtn, WSID.BOTTOM, 0, -6)
    spinBothBtn:SetPoint(WSID.LEFT, panel, WSID.LEFT, WSID.PAD, 0)
    spinBothBtn:SetPoint(WSID.RIGHT, panel, WSID.RIGHT, -WSID.PAD, 0)

    local lastCat = nil

    local function ResetSub()
        subLabel:SetText("Sub-Activity")
        subLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.dim_text[1],WhatShouldIDoDB.COLOR_TABLE.dim_text[2],WhatShouldIDoDB.COLOR_TABLE.dim_text[3])
        spinSubBtn:SetEnabled(false)
        lastCat = nil
    end

    spinCatBtn:SetScript(WSID.OnClick, function()
        local pool = WSID.GetActivities()
        if #pool==0 then return end
        WSID.StopSlot()
        spinCatBtn:SetEnabled(false)
        spinBothBtn:SetEnabled(false)
        ResetSub()
        catLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
        WSID.StartSlot(catLabel, pool, function(w)
            lastCat=w
            catLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
            spinCatBtn:SetEnabled(true)
            spinBothBtn:SetEnabled(true)
            spinSubBtn:SetEnabled(true)
        end)
    end)

    spinSubBtn:SetScript(WSID.OnClick, function()
        if not lastCat then return end
        local pool = WSID.GetSubActivities(lastCat)
        if not pool or #pool==0 then subLabel:SetText("(none)") return end
        WSID.StopSlot()
        spinSubBtn:SetEnabled(false)
        subLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
        WSID.StartSlot(subLabel, pool, function(_)
            subLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
            spinSubBtn:SetEnabled(true)
        end)
    end)

    spinBothBtn:SetScript(WSID.OnClick, function()
        local pool = WSID.GetActivities()
        if #pool==0 then return end
        WSID.StopSlot()
        spinCatBtn:SetEnabled(false)
        spinBothBtn:SetEnabled(false)
        ResetSub()
        catLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
        WSID.StartSlot(catLabel, pool, function(w)
            lastCat=w
            catLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
            local sub = WSID.GetSubActivities(w)
            if sub and #sub>0 then
                subLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
                WSID.StartSlot(subLabel, sub, function(_)
                    subLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
                    spinCatBtn:SetEnabled(true)
                    spinBothBtn:SetEnabled(true)
                    spinSubBtn:SetEnabled(true)
                end)
            else
                subLabel:SetText("(none)")
                spinCatBtn:SetEnabled(true)
                spinBothBtn:SetEnabled(true)
            end
        end)
    end)

    return panel
end
