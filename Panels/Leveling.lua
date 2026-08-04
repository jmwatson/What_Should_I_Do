-- Panels/Leveling.lua
-- Author: I_AM_T3X | v1.0.0

function BuildLevelingPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Leveling Wheel")
    hdr:SetPoint(WSID_TOPLEFT, panel, WSID_TOPLEFT, WSID_PAD, -WSID_PAD)

    local desc = MakeLabel(panel, "Spin a class -> pick a character -> spin an expansion.", hdr, WSID_BOTTOMLEFT, 4, -8)

    -- Auto-pick character toggle
    local autoPickLbl = panel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    autoPickLbl:SetPoint(WSID_TOPLEFT, desc, WSID_BOTTOMLEFT, 0, -8)
    autoPickLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    autoPickLbl:SetText("Auto-pick a character after class spin:")

    local autoPick = false
    local autoPickBtn = MakeBtn(panel, "Off", 60, 24)
    autoPickBtn:SetPoint(WSID_LEFT, autoPickLbl, WSID_RIGHT, 8, 0)
    autoPickBtn:SetScript(WSID_OnClick, function()
        autoPick = not autoPick
        if autoPick then
            autoPickBtn._lbl:SetText("On")
            autoPickBtn:SetBackdropColor(COLOR_TABLE.nav_active[1],COLOR_TABLE.nav_active[2],COLOR_TABLE.nav_active[3])
            autoPickBtn:SetBackdropBorderColor(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
            autoPickBtn._lbl:SetTextColor(1,1,1)
        else
            autoPickBtn._lbl:SetText("Off")
            autoPickBtn:SetBackdropColor(COLOR_TABLE.btn_bg[1],COLOR_TABLE.btn_bg[2],COLOR_TABLE.btn_bg[3])
            autoPickBtn:SetBackdropBorderColor(COLOR_TABLE.btn_bdr[1],COLOR_TABLE.btn_bdr[2],COLOR_TABLE.btn_bdr[3],1)
            autoPickBtn._lbl:SetTextColor(COLOR_TABLE.btn_text[1],COLOR_TABLE.btn_text[2],COLOR_TABLE.btn_text[3])
        end
    end)

    local classBox, classLabel = MakeResult(panel, nil, 52, "CLASS")
    classBox:SetPoint(WSID_TOPLEFT, autoPickLbl, WSID_BOTTOMLEFT, 0, -10)
    classLabel:SetText("Class")

    local spinClassBtn = MakeBtn(panel, "Spin Class", nil, 30)
    spinClassBtn:SetPoint(WSID_TOP, classBox, WSID_BOTTOM, 0, -10)
    spinClassBtn:SetPoint(WSID_LEFT,    panel, WSID_LEFT,  WSID_PAD, 0)
    spinClassBtn:SetPoint(WSID_RIGHT,   panel, WSID_RIGHT, -WSID_PAD, 0)

    local charHdr = MakeHeader(panel, "Characters of that class  (click to select)")
    charHdr:SetPoint(WSID_TOPLEFT, spinClassBtn, WSID_BOTTOMLEFT, 0, -10)

    local listBG, listContent, listReset = MakeScrollBox(panel, nil, 110)
    listBG:SetPoint(WSID_TOPLEFT, charHdr, WSID_BOTTOMLEFT, 0, 0)

    local expBox, expLabel = MakeResult(panel, nil, 52, "EXPANSION")
    expBox:SetPoint(WSID_TOPLEFT, listBG, WSID_BOTTOMLEFT, 0, -10)
    expLabel:SetText("Expansion")

    local spinExpBtn = MakeBtn(panel, "Spin Expansion", nil, 30)
    spinExpBtn:SetPoint(WSID_TOP, expBox, WSID_BOTTOM, 0, -10)
    spinExpBtn:SetPoint(WSID_LEFT,    panel, WSID_LEFT,  WSID_PAD, 0)
    spinExpBtn:SetPoint(WSID_RIGHT,   panel, WSID_CENTER, -3, 0)
    spinExpBtn:SetEnabled(false)

    local spinAllBtn = MakeBtn(panel, "Spin All Steps", nil, 30)
    spinAllBtn:SetPoint(WSID_TOP, expBox, WSID_BOTTOM, 0, -10)
    spinAllBtn:SetPoint(WSID_LEFT,    panel, WSID_CENTER, 3, 0)
    spinAllBtn:SetPoint(WSID_RIGHT,   panel, WSID_RIGHT, -WSID_PAD, 0)

    local noteLbl = panel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    noteLbl:SetPoint(WSID_TOPLEFT, spinExpBtn, WSID_BOTTOMLEFT, 0, -10)
    noteLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    noteLbl:SetText("Roster fills automatically as you log into each character.")

    local pickedClass=nil ; local selectedChar=nil ; local charRows={}

    local function ClearList()
        for _,r in ipairs(charRows) do r:Hide() end
        charRows={} ; selectedChar=nil ; listContent:SetHeight(110) ; listReset()
    end

    local function PopulateList(class)
        ClearList()
        local matches={}
        for _,ch in ipairs(WSID_Roster) do
            local excluded = WhatShouldIDoDB.excludedChars and WhatShouldIDoDB.excludedChars[ch.name]
            if ch.class==class and (ch.level or 0) < 90 and not excluded then
                table.insert(matches,ch)
            end
        end
        if #matches==0 then
            local none=listContent:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            none:SetPoint(WSID_TOPLEFT,listContent,WSID_TOPLEFT,8,-8)
            none:SetTextColor(0.65,0.30,0.30)
            none:SetText("No "..class.."s available for leveling.  (Max level characters are excluded.)")
            table.insert(charRows, none) ; listContent:SetHeight(30) ; return
        end
        for i,ch in ipairs(matches) do
            local even=(i%2==0)
            local row=CreateFrame(WSID_BUTTON,nil,listContent)
            row:SetHeight(24)
            row:SetPoint(WSID_TOP,   listContent, WSID_TOP,   0, -(i-1)*24)
            row:SetPoint(WSID_LEFT,  listContent, WSID_LEFT,  0, 0)
            row:SetPoint(WSID_RIGHT, listContent, WSID_RIGHT, 0, 0)
            local rowBg=row:CreateTexture(nil,WSID_BACKGROUND) ; rowBg:SetAllPoints()
            rowBg:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                                  even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                                  even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
            local cc=WSID_CLASS_INFO[ch.class] or {r=0.8,g=0.8,b=0.8}
            local fs=row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            fs:SetPoint(WSID_LEFT,row,WSID_LEFT,10,0) ; fs:SetJustifyH(WSID_LEFT)
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s|r  |cffffcc00Lv %d|r%s",
                cc.r*255,cc.g*255,cc.b*255,ch.name,ch.race or WSID_EMPTY_STRING,ch.level or 0,
                ch.current and "  |cff55cc55(you)|r" or WSID_EMPTY_STRING))
            local charData=ch
            row:SetScript(WSID_OnClick, function()
                selectedChar=charData
                for _,r in ipairs(charRows) do
                    if r._bg then
                        local re=r._even
                        r._bg:SetColorTexture(re and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                                              re and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                                              re and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
                    end
                end
                rowBg:SetColorTexture(COLOR_TABLE.row_select[1],COLOR_TABLE.row_select[2],COLOR_TABLE.row_select[3],1)
            end)
            row:SetScript(WSID_OnEnter, function()
                if selectedChar~=charData then rowBg:SetColorTexture(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1) end end)
            row:SetScript(WSID_OnLeave, function()
                if selectedChar~=charData then
                    rowBg:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                                         even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                                         even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
                end end)
            row._bg=rowBg ; row._even=even ; row._charData=ch
            table.insert(charRows, row)
        end
        listContent:SetHeight(math.max(24,#matches*24+2))
    end

    local function DoSpinClass(onDone)
        local pool={} ; for _, clsInfo in ipairs(WSID_CLASS_INFO) do table.insert(pool, clsInfo.name) end
        StopSlot() ; pickedClass=nil ; selectedChar=nil
        classLabel:SetText("Class") ; classLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        expLabel:SetText("Expansion") ; expLabel:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        spinExpBtn:SetEnabled(false) ; ClearList()
        classLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        StartSlot(classLabel, pool, function(winner)
            pickedClass=winner
            local cc=WSID_CLASS_INFO[winner]
            if cc then classLabel:SetTextColor(cc.r,cc.g,cc.b) end
            PopulateList(winner) ; spinExpBtn:SetEnabled(true)

            -- Auto-pick: spin a random eligible character from the list
            if autoPick and #charRows > 0 then
                -- Build eligible pool (already filtered in PopulateList via charRows)
                local eligible = {}
                for _, row in ipairs(charRows) do
                    if row._charData then table.insert(eligible, row) end
                end
                if #eligible > 0 then
                    -- Small delay so the class slot finishes visually first
                    C_Timer.After(0.3, function()
                        local pick = eligible[math.random(#eligible)]
                        -- Simulate a click on that row
                        pick:GetScript(WSID_OnClick)(pick)
                        -- Flash the selected row so user sees it
                        if pick._bg then
                            pick._bg:SetColorTexture(COLOR_TABLE.spin_text[1]*0.6,COLOR_TABLE.spin_text[2]*0.6,COLOR_TABLE.spin_text[3]*0.6,1)
                            C_Timer.After(0.15, function()
                                pick._bg:SetColorTexture(COLOR_TABLE.row_select[1],COLOR_TABLE.row_select[2],COLOR_TABLE.row_select[3],1)
                            end)
                        end
                    end)
                end
            end

            if onDone then onDone(winner) end
        end)
    end

    spinClassBtn:SetScript(WSID_OnClick, function()
        spinClassBtn:SetEnabled(false) ; spinAllBtn:SetEnabled(false)
        DoSpinClass(function(_) spinClassBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true) end)
    end)

    spinExpBtn:SetScript(WSID_OnClick, function()
        if not selectedChar then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a character first.",1,0.8,0.2) ; return
        end
        local pool = GetExpansionPool(selectedChar.level or 1)
        if #pool == 1 then
            expLabel:SetText(pool[1])
            expLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
            return
        end
        StopSlot() ; spinExpBtn:SetEnabled(false)
        expLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        StartSlot(expLabel, pool, function(_)
            expLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3]) ; spinExpBtn:SetEnabled(true)
        end)
    end)

    spinAllBtn:SetScript(WSID_OnClick, function()
        spinClassBtn:SetEnabled(false) ; spinAllBtn:SetEnabled(false) ; spinExpBtn:SetEnabled(false)
        DoSpinClass(function(winner)
            local autoChar=nil
            for _,ch in ipairs(WSID_Roster) do
                local excluded = WhatShouldIDoDB.excludedChars and WhatShouldIDoDB.excludedChars[ch.name]
                if ch.class==winner and (ch.level or 0) < 90 and not excluded then
                    autoChar=ch ; break
                end
            end
            if autoChar then
                selectedChar=autoChar
                if charRows[1] and charRows[1]._bg then
                    charRows[1]._bg:SetColorTexture(COLOR_TABLE.row_select[1],COLOR_TABLE.row_select[2],COLOR_TABLE.row_select[3],1)
                end
                local pool=GetExpansionPool(autoChar.level or 1)
                if #pool==1 then
                    expLabel:SetText(pool[1])
                    expLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
                    spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
                else
                    expLabel:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
                    StartSlot(expLabel, pool, function(_)
                        expLabel:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
                        spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
                    end)
                end
            else
                spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
            end
        end)
    end)

    return panel
end
