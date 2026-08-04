-- Panels/Names.lua
-- Author: I_AM_T3X | v1.0.0

function BuildNamePanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, WSID_NAMES_LABEL)
    hdr:SetPoint(WSID_TOPLEFT, panel, WSID_TOPLEFT, WSID_PAD, -WSID_PAD)

    local desc = MakeLabel(panel, "Pick a race and gender to generate a list of names.", hdr, WSID_BOTTOMLEFT, 4, -8)

    -- Race dropdown (we'll use a simple scrollable button list)
    local raceLabel = panel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    raceLabel:SetPoint(WSID_TOPLEFT, desc, WSID_BOTTOMLEFT, 0, -10)
    raceLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    raceLabel:SetText("Race:")

    -- Race selector display box
    local raceBox = CreateFrame(WSID_BUTTON, nil, panel, WSID_BACKDROP_TEMPLATE)
    raceBox:SetSize(200, 26)
    raceBox:SetPoint(WSID_LEFT, raceLabel, WSID_RIGHT, 8, 0)
    BgBorder(raceBox, COLOR_TABLE.result_bg[1],COLOR_TABLE.result_bg[2],COLOR_TABLE.result_bg[3], COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3])
    local raceBoxLbl = raceBox:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    raceBoxLbl:SetPoint(WSID_LEFT, raceBox, WSID_LEFT, 8, 0)
    raceBoxLbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    raceBoxLbl:SetText("Select Race...")

    -- Gender toggle
    local genderLbl = panel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    genderLbl:SetPoint(WSID_LEFT, raceBox, WSID_RIGHT, 16, 0)
    genderLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    genderLbl:SetText("Gender:")

    local selectedGender = "Male"
    local genderBtns = {}
    for i, g in ipairs({"Male","Female"}) do
        local gb = MakeBtn(panel, g, 72, 26)
        gb:SetPoint(WSID_LEFT, genderLbl, WSID_RIGHT, 6+(i-1)*76, 0)
        local gv = g
        gb:SetScript(WSID_OnClick, function()
            selectedGender = gv
            for _, b in ipairs(genderBtns) do
                b:SetBackdropColor(COLOR_TABLE.btn_bg[1],COLOR_TABLE.btn_bg[2],COLOR_TABLE.btn_bg[3])
                b:SetBackdropBorderColor(COLOR_TABLE.btn_bdr[1],COLOR_TABLE.btn_bdr[2],COLOR_TABLE.btn_bdr[3],1)
                b._lbl:SetTextColor(COLOR_TABLE.btn_text[1],COLOR_TABLE.btn_text[2],COLOR_TABLE.btn_text[3])
            end
            gb:SetBackdropColor(COLOR_TABLE.nav_active[1],COLOR_TABLE.nav_active[2],COLOR_TABLE.nav_active[3])
            gb:SetBackdropBorderColor(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
            gb._lbl:SetTextColor(1,1,1)
        end)
        table.insert(genderBtns, gb)
    end
    -- Default Male active
    genderBtns[1]:SetBackdropColor(COLOR_TABLE.nav_active[1],COLOR_TABLE.nav_active[2],COLOR_TABLE.nav_active[3])
    genderBtns[1]:SetBackdropBorderColor(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
    genderBtns[1]._lbl:SetTextColor(1,1,1)

    -- Race dropdown popup
    local raceList = CreateFrame(WSID_FRAME, nil, panel, WSID_BACKDROP_TEMPLATE)
    raceList:SetSize(200, 300)
    raceList:SetPoint(WSID_TOPLEFT, raceBox, WSID_BOTTOMLEFT, 0, -2)
    raceList:SetFrameStrata("TOOLTIP")
    BgBorder(raceList, COLOR_TABLE.bg[1],COLOR_TABLE.bg[2],COLOR_TABLE.bg[3], COLOR_TABLE.win_border[1],COLOR_TABLE.win_border[2],COLOR_TABLE.win_border[3])
    raceList:Hide()

    local allRaces = GetRaceNames()
    table.sort(allRaces)

    local selectedRace = nil
    local raceRowFrames = {}

    local raceScroll, raceScrollContent, _ = MakeScrollBox(raceList, 198, 298)
    raceScroll:SetPoint(WSID_TOPLEFT, raceList, WSID_TOPLEFT, 1, -1)

    for i, race in ipairs(allRaces) do
        local row = CreateFrame(WSID_BUTTON, nil, raceScrollContent)
        row:SetSize(196, 22)
        row:SetPoint(WSID_TOPLEFT, raceScrollContent, WSID_TOPLEFT, 0, -(i-1)*22)
        local rbg = row:CreateTexture(nil,WSID_BACKGROUND) ; rbg:SetAllPoints()
        rbg:SetColorTexture(i%2==0 and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                            i%2==0 and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                            i%2==0 and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)
        local rlbl = row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
        rlbl:SetPoint(WSID_LEFT, row, WSID_LEFT, 8, 0) ; rlbl:SetJustifyH(WSID_LEFT)
        rlbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        rlbl:SetText(race)
        local rv = race
        row:SetScript(WSID_OnClick, function()
            selectedRace = rv
            raceBoxLbl:SetText(rv)
            raceBoxLbl:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            raceList:Hide()
            for _, r in ipairs(raceRowFrames) do r._bg:SetColorTexture(r._ec and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],r._ec and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],r._ec and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1) end
            rbg:SetColorTexture(COLOR_TABLE.row_select[1],COLOR_TABLE.row_select[2],COLOR_TABLE.row_select[3],1)
        end)
        row:SetScript(WSID_OnEnter, function() if selectedRace~=rv then rbg:SetColorTexture(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1) end end)
        row:SetScript(WSID_OnLeave, function() if selectedRace~=rv then rbg:SetColorTexture(i%2==0 and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],i%2==0 and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],i%2==0 and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1) end end)
        row._bg = rbg ; row._ec = (i%2==0)
        table.insert(raceRowFrames, row)
    end
    raceScrollContent:SetHeight(#allRaces * 22 + 2)

    raceBox:SetScript(WSID_OnClick, function()
        if raceList:IsShown() then raceList:Hide() else raceList:Show() end
    end)

    -- Generate button
    local generateBtn = MakeBtn(panel, "Generate Names", nil, 30)
    generateBtn:SetPoint(WSID_TOP,   raceLabel, WSID_BOTTOM,  0, -14)
    generateBtn:SetPoint(WSID_LEFT,  panel, WSID_LEFT,   WSID_PAD, 0)
    generateBtn:SetPoint(WSID_RIGHT, panel, WSID_RIGHT,  -WSID_PAD, 0)

    -- Name list scroll
    local nameHdr = MakeHeader(panel, "Generated Names  (click to copy to chat)")
    nameHdr:SetPoint(WSID_TOP,  generateBtn, WSID_BOTTOM, 0, -10)
    nameHdr:SetPoint(WSID_LEFT, panel, WSID_LEFT, WSID_PAD, 0)

    local nameBG, nameContent, nameReset = MakeScrollBox(panel, nil, 200)
    nameBG:SetPoint(WSID_TOPLEFT, nameHdr, WSID_BOTTOMLEFT, 0, 0)

    local nameRows = {}

    local function RenderNames(names)
        for _, r in ipairs(nameRows) do r:Hide() end
        nameRows = {}
        for i, name in ipairs(names) do
            local even = (i%2==0)
            local row = CreateFrame(WSID_BUTTON, nil, nameContent)
            row:SetHeight(26)
            row:SetPoint(WSID_TOP,   nameContent, WSID_TOP,   0, -(i-1)*26)
            row:SetPoint(WSID_LEFT,  nameContent, WSID_LEFT,  0, 0)
            row:SetPoint(WSID_RIGHT, nameContent, WSID_RIGHT, 0, 0)
            local rb = row:CreateTexture(nil,WSID_BACKGROUND) ; rb:SetAllPoints()
            rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                               even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                               even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)
            local nl = row:CreateFontString(nil,WSID_OVERLAY)
            nl:SetFont(WSID_GAME_FONT, 13, WSID_EMPTY_STRING)
            nl:SetPoint(WSID_LEFT, row, WSID_LEFT, 12, 0) ; nl:SetJustifyH(WSID_LEFT)
            nl:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            nl:SetText(name)

            local copyHint = row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            copyHint:SetPoint(WSID_RIGHT, row, WSID_RIGHT, -10, 0)
            copyHint:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
            copyHint:SetText("click to copy")
            copyHint:Hide()

            local n = name
            row:SetScript(WSID_OnClick, function()
                -- Copy to default chat editbox
                ChatFrame_OpenChat(n)
            end)
            row:SetScript(WSID_OnEnter, function()
                rb:SetColorTexture(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1)
                copyHint:Show()
            end)
            row:SetScript(WSID_OnLeave, function()
                rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                                   even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                                   even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)
                copyHint:Hide()
            end)
            table.insert(nameRows, row)
        end
        nameContent:SetHeight(math.max(26, #names*26+2))
        nameReset()
    end

    generateBtn:SetScript(WSID_OnClick, function()
        if not selectedRace then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a race first.", 1,0.8,0.2)
            return
        end
        raceList:Hide()
        local names = GenerateNameList(selectedRace, selectedGender, 10)
        RenderNames(names)
    end)

    -- Also generate when race is selected from dropdown
    -- (handled inline above; user can click Generate)

    return panel
end


