-- Panels/Leveling.lua
-- Author: I_AM_T3X | v1.0.0

function BuildLevelingPanel(contentArea)
    local panel = MakePanel(contentArea)
    local hdr = MakeHeader(panel, "Leveling Wheel")
    hdr:SetPoint(TOPLEFT, panel, TOPLEFT, WSID_PAD, -WSID_PAD)

    local desc = MakeDimLabel(panel, "Spin a class -> pick a character -> spin an expansion.", hdr, BOTTOMLEFT, 4, -8)

    -- Auto-pick character toggle
    local autoPickLbl = panel:CreateFontString(nil,OVERLAY,NORMAL_SMALL)
    autoPickLbl:SetPoint(TOPLEFT, desc, BOTTOMLEFT, 0, -8)
    autoPickLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
    autoPickLbl:SetText("Auto-pick a character after class spin:")

    local autoPick = false
    local autoPickBtn = MakeBtn(panel, "Off", 60, 24)
    autoPickBtn:SetPoint(LEFT, autoPickLbl, RIGHT, 8, 0)
    autoPickBtn:SetScript(ONCLICK, function()
        autoPick = not autoPick
        if autoPick then
            autoPickBtn._lbl:SetText("On")
            autoPickBtn:SetBackdropColor(C.nav_active[1],C.nav_active[2],C.nav_active[3])
            autoPickBtn:SetBackdropBorderColor(C.nav_border[1],C.nav_border[2],C.nav_border[3],1)
            autoPickBtn._lbl:SetTextColor(1,1,1)
        else
            autoPickBtn._lbl:SetText("Off")
            autoPickBtn:SetBackdropColor(C.btn_bg[1],C.btn_bg[2],C.btn_bg[3])
            autoPickBtn:SetBackdropBorderColor(C.btn_bdr[1],C.btn_bdr[2],C.btn_bdr[3],1)
            autoPickBtn._lbl:SetTextColor(C.btn_text[1],C.btn_text[2],C.btn_text[3])
        end
    end)

    local classBox, classLabel = MakeResult(panel, nil, 52, "CLASS")
    classBox:SetPoint(TOPLEFT, autoPickLbl, BOTTOMLEFT, 0, -10)
    classLabel:SetText("Class")

    local spinClassBtn = MakeBtn(panel, "Spin Class", nil, 30)
    spinClassBtn:SetPoint(TOP, classBox, BOTTOM, 0, -10)
    spinClassBtn:SetPoint(LEFT,    panel, LEFT,  WSID_PAD, 0)
    spinClassBtn:SetPoint(RIGHT,   panel, RIGHT, -WSID_PAD, 0)

    local charHdr = MakeHeader(panel, "Characters of that class  (click to select)")
    charHdr:SetPoint(TOPLEFT, spinClassBtn, BOTTOMLEFT, 0, -10)

    local listBG, listContent, listReset = MakeScrollBox(panel, nil, 110)
    listBG:SetPoint(TOPLEFT, charHdr, BOTTOMLEFT, 0, 0)

    local expBox, expLabel = MakeResult(panel, nil, 52, "EXPANSION")
    expBox:SetPoint(TOPLEFT, listBG, BOTTOMLEFT, 0, -10)
    expLabel:SetText("Expansion")

    local spinExpBtn = MakeBtn(panel, "Spin Expansion", nil, 30)
    spinExpBtn:SetPoint(TOP, expBox, BOTTOM, 0, -10)
    spinExpBtn:SetPoint(LEFT,    panel, LEFT,  WSID_PAD, 0)
    spinExpBtn:SetPoint(RIGHT,   panel, CENTER, -3, 0)
    spinExpBtn:SetEnabled(false)

    local spinAllBtn = MakeBtn(panel, "Spin All Steps", nil, 30)
    spinAllBtn:SetPoint(TOP, expBox, BOTTOM, 0, -10)
    spinAllBtn:SetPoint(LEFT,    panel, CENTER, 3, 0)
    spinAllBtn:SetPoint(RIGHT,   panel, RIGHT, -WSID_PAD, 0)

    local noteLbl = panel:CreateFontString(nil,OVERLAY,NORMAL_SMALL)
    noteLbl:SetPoint(TOPLEFT, spinExpBtn, BOTTOMLEFT, 0, -10)
    noteLbl:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
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
            local none=listContent:CreateFontString(nil,OVERLAY,NORMAL_SMALL)
            none:SetPoint(TOPLEFT,listContent,TOPLEFT,8,-8)
            none:SetTextColor(0.65,0.30,0.30)
            none:SetText("No "..class.."s available for leveling.  (Max level characters are excluded.)")
            table.insert(charRows, none) ; listContent:SetHeight(30) ; return
        end
        for i,ch in ipairs(matches) do
            local even=(i%2==0)
            local row=CreateFrame(BUTTON,nil,listContent)
            row:SetHeight(24)
            row:SetPoint(TOP,   listContent, TOP,   0, -(i-1)*24)
            row:SetPoint(LEFT,  listContent, LEFT,  0, 0)
            row:SetPoint(RIGHT, listContent, RIGHT, 0, 0)
            local rowBg=row:CreateTexture(nil,BACKGROUND) ; rowBg:SetAllPoints()
            rowBg:SetColorTexture(even and C.row_even[1] or C.row_odd[1],
                                  even and C.row_even[2] or C.row_odd[2],
                                  even and C.row_even[3] or C.row_odd[3],1)
            local cc=WSID_CLASS_INFO[ch.class] or {r=0.8,g=0.8,b=0.8}
            local fs=row:CreateFontString(nil,OVERLAY,NORMAL_SMALL)
            fs:SetPoint(LEFT,row,LEFT,10,0) ; fs:SetJustifyH(LEFT)
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s|r  |cffffcc00Lv %d|r%s",
                cc.r*255,cc.g*255,cc.b*255,ch.name,ch.race or EMPTY_STRING,ch.level or 0,
                ch.current and "  |cff55cc55(you)|r" or EMPTY_STRING))
            local charData=ch
            row:SetScript(ONCLICK, function()
                selectedChar=charData
                for _,r in ipairs(charRows) do
                    if r._bg then
                        local re=r._even
                        r._bg:SetColorTexture(re and C.row_even[1] or C.row_odd[1],
                                              re and C.row_even[2] or C.row_odd[2],
                                              re and C.row_even[3] or C.row_odd[3],1)
                    end
                end
                rowBg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
            end)
            row:SetScript(ONENTER, function()
                if selectedChar~=charData then rowBg:SetColorTexture(C.row_hover[1],C.row_hover[2],C.row_hover[3],1) end end)
            row:SetScript(ONLEAVE, function()
                if selectedChar~=charData then
                    rowBg:SetColorTexture(even and C.row_even[1] or C.row_odd[1],
                                         even and C.row_even[2] or C.row_odd[2],
                                         even and C.row_even[3] or C.row_odd[3],1)
                end end)
            row._bg=rowBg ; row._even=even ; row._charData=ch
            table.insert(charRows, row)
        end
        listContent:SetHeight(math.max(24,#matches*24+2))
    end

    local function DoSpinClass(onDone)
        local pool={} ; for _, clsInfo in ipairs(WSID_CLASS_INFO) do table.insert(pool, clsInfo.name) end
        StopSlot() ; pickedClass=nil ; selectedChar=nil
        classLabel:SetText("Class") ; classLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        expLabel:SetText("Expansion") ; expLabel:SetTextColor(C.dim_text[1],C.dim_text[2],C.dim_text[3])
        spinExpBtn:SetEnabled(false) ; ClearList()
        classLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
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
                        pick:GetScript(ONCLICK)(pick)
                        -- Flash the selected row so user sees it
                        if pick._bg then
                            pick._bg:SetColorTexture(C.spin_text[1]*0.6,C.spin_text[2]*0.6,C.spin_text[3]*0.6,1)
                            C_Timer.After(0.15, function()
                                pick._bg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
                            end)
                        end
                    end)
                end
            end

            if onDone then onDone(winner) end
        end)
    end

    spinClassBtn:SetScript(ONCLICK, function()
        spinClassBtn:SetEnabled(false) ; spinAllBtn:SetEnabled(false)
        DoSpinClass(function(_) spinClassBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true) end)
    end)

    spinExpBtn:SetScript(ONCLICK, function()
        if not selectedChar then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a character first.",1,0.8,0.2) ; return
        end
        local pool = GetExpansionPool(selectedChar.level or 1)
        if #pool == 1 then
            expLabel:SetText(pool[1])
            expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
            return
        end
        StopSlot() ; spinExpBtn:SetEnabled(false)
        expLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
        StartSlot(expLabel, pool, function(_)
            expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3]) ; spinExpBtn:SetEnabled(true)
        end)
    end)

    spinAllBtn:SetScript(ONCLICK, function()
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
                    charRows[1]._bg:SetColorTexture(C.row_select[1],C.row_select[2],C.row_select[3],1)
                end
                local pool=GetExpansionPool(autoChar.level or 1)
                if #pool==1 then
                    expLabel:SetText(pool[1])
                    expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
                    spinClassBtn:SetEnabled(true) ; spinExpBtn:SetEnabled(true) ; spinAllBtn:SetEnabled(true)
                else
                    expLabel:SetTextColor(C.bright_text[1],C.bright_text[2],C.bright_text[3])
                    StartSlot(expLabel, pool, function(_)
                        expLabel:SetTextColor(C.spin_text[1],C.spin_text[2],C.spin_text[3])
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
