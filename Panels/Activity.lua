-- Panels/Activity.lua
-- Author: I_AM_T3X | v1.0.0

function BuildActivityPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Activity Wheel")
    hdr:SetPoint(WSID.TOPLEFT, panel, WSID.TOPLEFT, WSID.PAD, -WSID.PAD)

    local desc = MakeLabel(panel, "Spin a category, then spin a sub-activity.", hdr, WSID.BOTTOMLEFT, 4, -8)

    local catBox, catLabel = MakeResult(panel, nil, 52, "CATEGORY")
    catBox:SetPoint(WSID.TOPLEFT, desc, WSID.BOTTOMLEFT, -4, -12)
    catLabel:SetText("Category")

    local subBox, subLabel = MakeResult(panel, nil, 52, "SUB-ACTIVITY")
    subBox:SetPoint(WSID.TOPLEFT, catBox, WSID.BOTTOMLEFT, 0, -10)
    subLabel:SetText("Sub-Activity")

    local spinCatBtn = MakeBtn(panel, "Spin Category", nil, 30)
    spinCatBtn:SetPoint(WSID.TOP, subBox, WSID.BOTTOMLEFT, 0, -14)
    spinCatBtn:SetPoint(WSID.LEFT, panel, WSID.LEFT, WSID.PAD, 0)
    spinCatBtn:SetPoint(WSID.RIGHT, panel, WSID.CENTER, -3, 0)

    local spinSubBtn = MakeBtn(panel, "Spin Sub-Activity", nil, 30)
    spinSubBtn:SetPoint(WSID.TOP, subBox, WSID.BOTTOMLEFT, 0, -14)
    spinSubBtn:SetPoint(WSID.LEFT, panel, WSID.CENTER, 3, 0)
    spinSubBtn:SetPoint(WSID.RIGHT, panel, WSID.RIGHT, -WSID.PAD, 0)
    spinSubBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint(WSID.TOP, spinCatBtn, WSID.BOTTOM, 0, -6)
    spinBothBtn:SetPoint(WSID.LEFT, panel, WSID.LEFT, WSID.PAD, 0)
    spinBothBtn:SetPoint(WSID.RIGHT, panel, WSID.RIGHT, -WSID.PAD, 0)

    local lastCat = nil

    local function ResetSub()
        subLabel:SetText("Sub-Activity")
        subLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        spinSubBtn:SetEnabled(false)
        lastCat = nil
    end

    spinCatBtn:SetScript(WSID.OnClick, function()
        local pool = WhatShouldIDoDB.activities
        if #pool==0 then return end
        StopSlot()
        spinCatBtn:SetEnabled(false)
        spinBothBtn:SetEnabled(false)
        ResetSub()
        catLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        StartSlot(catLabel, pool, function(w)
            lastCat=w
            catLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            spinCatBtn:SetEnabled(true)
            spinBothBtn:SetEnabled(true)
            spinSubBtn:SetEnabled(true)
        end)
    end)

    spinSubBtn:SetScript(WSID.OnClick, function()
        if not lastCat then return end
        local pool = SetSubActivitiesDB(lastCat)
        if not pool or #pool==0 then subLabel:SetText("(none)") return end
        StopSlot()
        spinSubBtn:SetEnabled(false)
        subLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        StartSlot(subLabel, pool, function(_)
            subLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            spinSubBtn:SetEnabled(true)
        end)
    end)

    spinBothBtn:SetScript(WSID.OnClick, function()
        local pool = WhatShouldIDoDB.activities
        if #pool==0 then return end
        StopSlot()
        spinCatBtn:SetEnabled(false)
        spinBothBtn:SetEnabled(false)
        ResetSub()
        catLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        StartSlot(catLabel, pool, function(w)
            lastCat=w
            catLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            local sub = SetSubActivitiesDB(w)
            if sub and #sub>0 then
                subLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
                StartSlot(subLabel, sub, function(_)
                    subLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
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
