-- Panels/Names.lua
-- Author: I_AM_T3X | v1.0.0

WSID.BuildNamePanel = function(contentArea)
    local panel = WSID.MakePanel(contentArea)
    local hdr = WSID.MakeHeader(panel, WSID.NAMES_LABEL)
    hdr:SetPoint(WSID.TOPLEFT, panel, WSID.TOPLEFT, WSID.PAD, -WSID.PAD)

    local desc = WSID.MakeLabel(panel, "Pick a race and gender to generate a list of names.", hdr, WSID.BOTTOMLEFT, 4, -8)

    -- Race dropdown (we'll use a simple scrollable button list)
    local raceLabel = panel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    raceLabel:SetPoint(WSID.TOPLEFT, desc, WSID.BOTTOMLEFT, 0, -10)
    raceLabel:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.dim_text[1],WhatShouldIDoDB.COLOR_TABLE.dim_text[2],WhatShouldIDoDB.COLOR_TABLE.dim_text[3])
    raceLabel:SetText("Race:")

    -- Race selector display box
    local raceBox = CreateFrame(WSID.BUTTON, nil, panel, WSID.BACKDROP_TEMPLATE)
    raceBox:SetSize(200, 26)
    raceBox:SetPoint(WSID.LEFT, raceLabel, WSID.RIGHT, 8, 0)
    WSID.BgBorder(raceBox, WhatShouldIDoDB.COLOR_TABLE.result_bg[1],WhatShouldIDoDB.COLOR_TABLE.result_bg[2],WhatShouldIDoDB.COLOR_TABLE.result_bg[3], WhatShouldIDoDB.COLOR_TABLE.result_bdr[1],WhatShouldIDoDB.COLOR_TABLE.result_bdr[2],WhatShouldIDoDB.COLOR_TABLE.result_bdr[3])
    local raceBoxLbl = raceBox:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    raceBoxLbl:SetPoint(WSID.LEFT, raceBox, WSID.LEFT, 8, 0)
    raceBoxLbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
    raceBoxLbl:SetText("Select Race...")

    -- Gender toggle
    local genderLbl = panel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    genderLbl:SetPoint(WSID.LEFT, raceBox, WSID.RIGHT, 16, 0)
    genderLbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.dim_text[1],WhatShouldIDoDB.COLOR_TABLE.dim_text[2],WhatShouldIDoDB.COLOR_TABLE.dim_text[3])
    genderLbl:SetText("Gender:")

    local selectedGender = "Male"
    local genderBtns = {}
    for i, g in ipairs({"Male","Female"}) do
        local gb = WSID.MakeBtn(panel, g, 72, 26)
        gb:SetPoint(WSID.LEFT, genderLbl, WSID.RIGHT, 6+(i-1)*76, 0)
        local gv = g
        gb:SetScript(WSID.OnClick, function()
            selectedGender = gv
            for _, b in ipairs(genderBtns) do
                b:SetBackdropColor(WhatShouldIDoDB.COLOR_TABLE.btn_bg[1],WhatShouldIDoDB.COLOR_TABLE.btn_bg[2],WhatShouldIDoDB.COLOR_TABLE.btn_bg[3])
                b:SetBackdropBorderColor(WhatShouldIDoDB.COLOR_TABLE.btn_bdr[1],WhatShouldIDoDB.COLOR_TABLE.btn_bdr[2],WhatShouldIDoDB.COLOR_TABLE.btn_bdr[3],1)
                b._lbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.btn_text[1],WhatShouldIDoDB.COLOR_TABLE.btn_text[2],WhatShouldIDoDB.COLOR_TABLE.btn_text[3])
            end
            gb:SetBackdropColor(WhatShouldIDoDB.COLOR_TABLE.nav_active[1],WhatShouldIDoDB.COLOR_TABLE.nav_active[2],WhatShouldIDoDB.COLOR_TABLE.nav_active[3])
            gb:SetBackdropBorderColor(WhatShouldIDoDB.COLOR_TABLE.nav_border[1],WhatShouldIDoDB.COLOR_TABLE.nav_border[2],WhatShouldIDoDB.COLOR_TABLE.nav_border[3],1)
            gb._lbl:SetTextColor(1,1,1)
        end)
        table.insert(genderBtns, gb)
    end
    -- Default Male active
    genderBtns[1]:SetBackdropColor(WhatShouldIDoDB.COLOR_TABLE.nav_active[1],WhatShouldIDoDB.COLOR_TABLE.nav_active[2],WhatShouldIDoDB.COLOR_TABLE.nav_active[3])
    genderBtns[1]:SetBackdropBorderColor(WhatShouldIDoDB.COLOR_TABLE.nav_border[1],WhatShouldIDoDB.COLOR_TABLE.nav_border[2],WhatShouldIDoDB.COLOR_TABLE.nav_border[3],1)
    genderBtns[1]._lbl:SetTextColor(1,1,1)

    -- Race dropdown popup
    local raceList = CreateFrame(WSID.FRAME, nil, panel, WSID.BACKDROP_TEMPLATE)
    raceList:SetSize(200, 300)
    raceList:SetPoint(WSID.TOPLEFT, raceBox, WSID.BOTTOMLEFT, 0, -2)
    raceList:SetFrameStrata("TOOLTIP")
    WSID.BgBorder(raceList, WhatShouldIDoDB.COLOR_TABLE.bg[1],WhatShouldIDoDB.COLOR_TABLE.bg[2],WhatShouldIDoDB.COLOR_TABLE.bg[3], WhatShouldIDoDB.COLOR_TABLE.win_border[1],WhatShouldIDoDB.COLOR_TABLE.win_border[2],WhatShouldIDoDB.COLOR_TABLE.win_border[3])
    raceList:Hide()

    local allRaces = WSID.GetRaceNames()
    table.sort(allRaces)

    local selectedRace = nil
    local raceRowFrames = {}

    local raceScroll, raceScrollContent, _ = WSID.MakeScrollBox(raceList, 198, 298)
    raceScroll:SetPoint(WSID.TOPLEFT, raceList, WSID.TOPLEFT, 1, -1)

    for i, race in ipairs(allRaces) do
        local row = CreateFrame(WSID.BUTTON, nil, raceScrollContent)
        row:SetSize(196, 22)
        row:SetPoint(WSID.TOPLEFT, raceScrollContent, WSID.TOPLEFT, 0, -(i-1)*22)
        local rbg = row:CreateTexture(nil,WSID.BACKGROUND) ; rbg:SetAllPoints()
        rbg:SetColorTexture(i%2==0 and WhatShouldIDoDB.COLOR_TABLE.row_even[1] or WhatShouldIDoDB.COLOR_TABLE.row_odd[1],
                            i%2==0 and WhatShouldIDoDB.COLOR_TABLE.row_even[2] or WhatShouldIDoDB.COLOR_TABLE.row_odd[2],
                            i%2==0 and WhatShouldIDoDB.COLOR_TABLE.row_even[3] or WhatShouldIDoDB.COLOR_TABLE.row_odd[3], 1)
        local rlbl = row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        rlbl:SetPoint(WSID.LEFT, row, WSID.LEFT, 8, 0) ; rlbl:SetJustifyH(WSID.LEFT)
        rlbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.bright_text[1],WhatShouldIDoDB.COLOR_TABLE.bright_text[2],WhatShouldIDoDB.COLOR_TABLE.bright_text[3])
        rlbl:SetText(race)
        local rv = race
        row:SetScript(WSID.OnClick, function()
            selectedRace = rv
            raceBoxLbl:SetText(rv)
            raceBoxLbl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
            raceList:Hide()
            for _, r in ipairs(raceRowFrames) do r._bg:SetColorTexture(r._ec and WhatShouldIDoDB.COLOR_TABLE.row_even[1] or WhatShouldIDoDB.COLOR_TABLE.row_odd[1],r._ec and WhatShouldIDoDB.COLOR_TABLE.row_even[2] or WhatShouldIDoDB.COLOR_TABLE.row_odd[2],r._ec and WhatShouldIDoDB.COLOR_TABLE.row_even[3] or WhatShouldIDoDB.COLOR_TABLE.row_odd[3],1) end
            rbg:SetColorTexture(WhatShouldIDoDB.COLOR_TABLE.row_select[1],WhatShouldIDoDB.COLOR_TABLE.row_select[2],WhatShouldIDoDB.COLOR_TABLE.row_select[3],1)
        end)
        row:SetScript(WSID.OnEnter, function() if selectedRace~=rv then rbg:SetColorTexture(WhatShouldIDoDB.COLOR_TABLE.row_hover[1],WhatShouldIDoDB.COLOR_TABLE.row_hover[2],WhatShouldIDoDB.COLOR_TABLE.row_hover[3],1) end end)
        row:SetScript(WSID.OnLeave, function() if selectedRace~=rv then rbg:SetColorTexture(i%2==0 and WhatShouldIDoDB.COLOR_TABLE.row_even[1] or WhatShouldIDoDB.COLOR_TABLE.row_odd[1],i%2==0 and WhatShouldIDoDB.COLOR_TABLE.row_even[2] or WhatShouldIDoDB.COLOR_TABLE.row_odd[2],i%2==0 and WhatShouldIDoDB.COLOR_TABLE.row_even[3] or WhatShouldIDoDB.COLOR_TABLE.row_odd[3],1) end end)
        row._bg = rbg ; row._ec = (i%2==0)
        table.insert(raceRowFrames, row)
    end
    raceScrollContent:SetHeight(#allRaces * 22 + 2)

    raceBox:SetScript(WSID.OnClick, function()
        if raceList:IsShown() then raceList:Hide() else raceList:Show() end
    end)

    -- Generate button
    local generateBtn = WSID.MakeBtn(panel, "Generate Names", nil, 30)
    generateBtn:SetPoint(WSID.TOP,   raceLabel, WSID.BOTTOM,  0, -14)
    generateBtn:SetPoint(WSID.LEFT,  panel, WSID.LEFT,   WSID.PAD, 0)
    generateBtn:SetPoint(WSID.RIGHT, panel, WSID.RIGHT,  -WSID.PAD, 0)

    -- Name list scroll
    local nameHdr = WSID.MakeHeader(panel, "Generated Names  (click to copy to chat)")
    nameHdr:SetPoint(WSID.TOP,  generateBtn, WSID.BOTTOM, 0, -10)
    nameHdr:SetPoint(WSID.LEFT, panel, WSID.LEFT, WSID.PAD, 0)

    local nameBG, nameContent, nameReset = WSID.MakeScrollBox(panel, nil, 200)
    nameBG:SetPoint(WSID.TOPLEFT, nameHdr, WSID.BOTTOMLEFT, 0, 0)

    local nameRows = {}

    local function RenderNames(names)
        for _, r in ipairs(nameRows) do r:Hide() end
        nameRows = {}
        for i, name in ipairs(names) do
            local even = (i%2==0)
            local row = CreateFrame(WSID.BUTTON, nil, nameContent)
            row:SetHeight(26)
            row:SetPoint(WSID.TOP,   nameContent, WSID.TOP,   0, -(i-1)*26)
            row:SetPoint(WSID.LEFT,  nameContent, WSID.LEFT,  0, 0)
            row:SetPoint(WSID.RIGHT, nameContent, WSID.RIGHT, 0, 0)
            local rb = row:CreateTexture(nil,WSID.BACKGROUND) ; rb:SetAllPoints()
            rb:SetColorTexture(even and WhatShouldIDoDB.COLOR_TABLE.row_even[1] or WhatShouldIDoDB.COLOR_TABLE.row_odd[1],
                               even and WhatShouldIDoDB.COLOR_TABLE.row_even[2] or WhatShouldIDoDB.COLOR_TABLE.row_odd[2],
                               even and WhatShouldIDoDB.COLOR_TABLE.row_even[3] or WhatShouldIDoDB.COLOR_TABLE.row_odd[3], 1)
            local nl = row:CreateFontString(nil,WSID.OVERLAY)
            nl:SetFont(WSID.GAME_FONT, 13, WSID.EMPTY_STRING)
            nl:SetPoint(WSID.LEFT, row, WSID.LEFT, 12, 0) ; nl:SetJustifyH(WSID.LEFT)
            nl:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.spin_text[1],WhatShouldIDoDB.COLOR_TABLE.spin_text[2],WhatShouldIDoDB.COLOR_TABLE.spin_text[3])
            nl:SetText(name)

            local copyHint = row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            copyHint:SetPoint(WSID.RIGHT, row, WSID.RIGHT, -10, 0)
            copyHint:SetTextColor(WhatShouldIDoDB.COLOR_TABLE.dim_text[1],WhatShouldIDoDB.COLOR_TABLE.dim_text[2],WhatShouldIDoDB.COLOR_TABLE.dim_text[3])
            copyHint:SetText("click to copy")
            copyHint:Hide()

            local n = name
            row:SetScript(WSID.OnClick, function()
                -- Copy to default chat editbox
                ChatFrame_OpenChat(n)
            end)
            row:SetScript(WSID.OnEnter, function()
                rb:SetColorTexture(WhatShouldIDoDB.COLOR_TABLE.row_hover[1],WhatShouldIDoDB.COLOR_TABLE.row_hover[2],WhatShouldIDoDB.COLOR_TABLE.row_hover[3],1)
                copyHint:Show()
            end)
            row:SetScript(WSID.OnLeave, function()
                rb:SetColorTexture(even and WhatShouldIDoDB.COLOR_TABLE.row_even[1] or WhatShouldIDoDB.COLOR_TABLE.row_odd[1],
                                   even and WhatShouldIDoDB.COLOR_TABLE.row_even[2] or WhatShouldIDoDB.COLOR_TABLE.row_odd[2],
                                   even and WhatShouldIDoDB.COLOR_TABLE.row_even[3] or WhatShouldIDoDB.COLOR_TABLE.row_odd[3], 1)
                copyHint:Hide()
            end)
            table.insert(nameRows, row)
        end
        nameContent:SetHeight(math.max(26, #names*26+2))
        nameReset()
    end

    generateBtn:SetScript(WSID.OnClick, function()
        if not selectedRace then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a race first.", 1,0.8,0.2)
            return
        end
        raceList:Hide()
        local names = WSID.GenerateNameList(selectedRace, selectedGender, 10)
        RenderNames(names)
    end)

    -- Also generate when race is selected from dropdown
    -- (handled inline above; user can click Generate)

    return panel
end


