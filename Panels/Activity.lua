-- Panels/Activity.lua
-- Author: I_AM_T3X | v1.0.0

function BuildActivityPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Activity Wheel")
    hdr:SetPoint(WSID_TOPLEFT, panel, WSID_TOPLEFT, WSID_PAD, -WSID_PAD)

    local desc = MakeLabel(panel, "Spin a category, then spin a sub-activity.", hdr, WSID_BOTTOMLEFT, 4, -8)

    local catBox, catLabel = MakeResult(panel, nil, 52, "CATEGORY")
    catBox:SetPoint(WSID_TOPLEFT, desc, WSID_BOTTOMLEFT, -4, -12)
    catLabel:SetText("Category")

    local subBox, subLabel = MakeResult(panel, nil, 52, "SUB-ACTIVITY")
    subBox:SetPoint(WSID_TOPLEFT, catBox, WSID_BOTTOMLEFT, 0, -10)
    subLabel:SetText("Sub-Activity")

    local spinCatBtn = MakeBtn(panel, "Spin Category", nil, 30)
    spinCatBtn:SetPoint(WSID_TOP, subBox, WSID_BOTTOMLEFT, 0, -14)
    spinCatBtn:SetPoint(WSID_LEFT, panel, WSID_LEFT, WSID_PAD, 0)
    spinCatBtn:SetPoint(WSID_RIGHT, panel, WSID_CENTER, -3, 0)

    local spinSubBtn = MakeBtn(panel, "Spin Sub-Activity", nil, 30)
    spinSubBtn:SetPoint(WSID_TOP, subBox, WSID_BOTTOMLEFT, 0, -14)
    spinSubBtn:SetPoint(WSID_LEFT, panel, WSID_CENTER, 3, 0)
    spinSubBtn:SetPoint(WSID_RIGHT, panel, WSID_RIGHT, -WSID_PAD, 0)
    spinSubBtn:SetEnabled(false)

    local spinBothBtn = MakeBtn(panel, "Spin Both", nil, 30)
    spinBothBtn:SetPoint(WSID_TOP, spinCatBtn, WSID_BOTTOM, 0, -6)
    spinBothBtn:SetPoint(WSID_LEFT, panel, WSID_LEFT, WSID_PAD, 0)
    spinBothBtn:SetPoint(WSID_RIGHT, panel, WSID_RIGHT, -WSID_PAD, 0)

    local lastCat = nil

    local function ResetSub()
        subLabel:SetText("Sub-Activity")
        subLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        spinSubBtn:SetEnabled(false)
        lastCat = nil
    end

    spinCatBtn:SetScript(WSID_OnClick, function()
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

    spinSubBtn:SetScript(WSID_OnClick, function()
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

    spinBothBtn:SetScript(WSID_OnClick, function()
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
