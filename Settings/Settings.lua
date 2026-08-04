-- Settings/Settings.lua
-- Settings window and all tabs
-- Author: I_AM_T3X | v1.0.0

SettingsFrame = nil
WSID_refreshActivities = nil
WSID_refreshRoster = nil
WSID_WSID_refreshActivities = nil
WSID_WSID_refreshRoster = nil

function BuildSettingsWindow()
    local f = CreateFrame(WSID_FRAME,"WhatShouldIDoSettings",UIParent,WSID_BACKDROP_TEMPLATE)
    f:SetSize(WSID_SET_W, WSID_SET_H)
    f:SetPoint(WSID_CENTER,UIParent,WSID_CENTER,280,0)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag(WSID_WSIDLEFT_BUTTON)
    f:SetScript(WSID_OnDragStart,f.StartMoving)
    f:SetScript(WSID_OnDragStop,f.StopMovingOrSizing)
    f:SetFrameStrata(WSID_DIALOG)
    f:SetFrameLevel(20)
    f:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})
    f:SetBackdropColor(COLOR_TABLE.bg[1],COLOR_TABLE.bg[2],COLOR_TABLE.bg[3],1)
    f:SetBackdropBorderColor(COLOR_TABLE.win_border[1],COLOR_TABLE.win_border[2],COLOR_TABLE.win_border[3],1)
    f:Hide()

    -- Title bar
    local tb=CreateFrame(WSID_FRAME,nil,f)
    tb:SetHeight(30)
    tb:SetPoint(WSID_TOPLEFT,f,WSID_TOPLEFT,0,0)
    tb:SetPoint(WSID_TOPRIGHT,f,WSID_TOPRIGHT,0,0)
    Tx(tb,COLOR_TABLE.sidebar[1],COLOR_TABLE.sidebar[2],COLOR_TABLE.sidebar[3])
    local tbBord=tb:CreateTexture(nil,WSID_ARTWORK)
    tbBord:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    tbBord:SetHeight(1)
    tbBord:SetPoint(WSID_BOTTOMLEFT,tb,WSID_BOTTOMLEFT,0,0)
    tbBord:SetPoint(WSID_BOTTOMRIGHT,tb,WSID_BOTTOMRIGHT,0,0)
    local tbLbl=tb:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL)
    tbLbl:SetPoint(WSID_LEFT,tb,WSID_LEFT,10,0)
    tbLbl:SetText("What Should I Do?  --  Settings")
    tbLbl:SetTextColor(COLOR_TABLE.header_txt[1],COLOR_TABLE.header_txt[2],COLOR_TABLE.header_txt[3])
    local closeBtn=CreateFrame(WSID_BUTTON,nil,f,WSID_UI_PANEL_CLOSE_BUTTON)
    closeBtn:SetPoint(WSID_TOPRIGHT,f,WSID_TOPRIGHT,-2,-2)
    closeBtn:SetFrameStrata(f:GetFrameStrata())
    closeBtn:SetFrameLevel(f:GetFrameLevel() + 1)

    -- Left nav
    local navBg=CreateFrame(WSID_FRAME,nil,f)
    navBg:SetPoint(WSID_TOPLEFT,f,WSID_TOPLEFT,0,-30)
    navBg:SetPoint(WSID_BOTTOMLEFT,f,WSID_BOTTOMLEFT,0,0)
    navBg:SetWidth(WSID_SET_NAV)
    Tx(navBg,COLOR_TABLE.sidebar[1],COLOR_TABLE.sidebar[2],COLOR_TABLE.sidebar[3])
    local nd=navBg:CreateTexture(nil,WSID_ARTWORK)
    nd:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    nd:SetWidth(1)
    nd:SetPoint(WSID_TOPRIGHT,navBg,WSID_TOPRIGHT,0,0)
    nd:SetPoint(WSID_BOTTOMRIGHT,navBg,WSID_BOTTOMRIGHT,0,0)

    local content=CreateFrame(WSID_FRAME,nil,f)
    content:SetPoint(WSID_TOPLEFT,f,WSID_TOPLEFT,WSID_SET_NAV,-30)
    content:SetPoint(WSID_BOTTOMRIGHT,f,WSID_BOTTOMRIGHT,0,0)

    local actPanel=CreateFrame(WSID_FRAME,nil,content)
    actPanel:SetAllPoints(content)
    actPanel:Hide()
    local rostPanel=CreateFrame(WSID_FRAME,nil,content)
    rostPanel:SetAllPoints(content)
    rostPanel:Hide()
    local ioPanel=CreateFrame(WSID_FRAME,nil,content)
    ioPanel:SetAllPoints(content)
    ioPanel:Hide()
    local colorsPanel=CreateFrame(WSID_FRAME,nil,content)
    colorsPanel:SetAllPoints(content)
    colorsPanel:Hide()
    local scalePanel=CreateFrame(WSID_FRAME,nil,content)
    scalePanel:SetAllPoints(content)
    scalePanel:Hide()
    local expExclPanel=CreateFrame(WSID_FRAME,nil,content)
    expExclPanel:SetAllPoints(content)
    expExclPanel:Hide()
    local changelogPanel=CreateFrame(WSID_FRAME,nil,content)
    changelogPanel:SetAllPoints(content)
    changelogPanel:Hide()
    local PANELS={activities=actPanel,WSID_Roster=rostPanel,importexport=ioPanel,expansions=expExclPanel,colors=colorsPanel,uiscale=scalePanel,changelog=changelogPanel}
    local navBtns={}
    local navActive=nil

    local function SetNavActive(name)
        navActive=name
        for k,b in pairs(navBtns) do
            if k==name then
                b.bg:SetColorTexture(COLOR_TABLE.nav_active[1],COLOR_TABLE.nav_active[2],COLOR_TABLE.nav_active[3],1)
                b.stripe:Show()
                b.lbl:SetTextColor(1,1,1)
            else
                b.bg:SetColorTexture(0,0,0,0)
                b.stripe:Hide()
                b.lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
            end
        end
        for k,p in pairs(PANELS) do
            if k==name then p:Show() else p:Hide() end
        end
        if name=="activities" and WSID_refreshActivities then WSID_refreshActivities() end
        if name=="WSID_Roster"     and WSID_refreshRoster     then WSID_refreshRoster() end
    end

    for i,def in ipairs({{name="activities",label="Activities"},{name="WSID_Roster",label="Roster"},{name="importexport",label="Import/Export"},{name="expansions",label="Expansions"},{name="colors",label="Colors"},{name="uiscale",label="UI Scale"}}) do
        local row=CreateFrame(WSID_BUTTON,nil,navBg)
        row:SetSize(WSID_SET_NAV,36)
        row:SetPoint(WSID_TOPLEFT,navBg,WSID_TOPLEFT,0,-(i-1)*36)
        local bg=row:CreateTexture(nil,WSID_BACKGROUND)
        bg:SetAllPoints()
        bg:SetColorTexture(0,0,0,0)
        local stripe=row:CreateTexture(nil,WSID_ARTWORK)
        stripe:SetColorTexture(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
        stripe:SetSize(3,36)
        stripe:SetPoint(WSID_LEFT,row,WSID_LEFT,0,0)
        stripe:Hide()
        local lbl=row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
        lbl:SetPoint(WSID_LEFT,row,WSID_LEFT,12,0)
        lbl:SetText(def.label)
        lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        local name=def.name
        row:SetScript(WSID_OnClick,function() SetNavActive(name) end)
        row:SetScript(WSID_OnEnter,function()
            if navActive~=name then
                bg:SetColorTexture(COLOR_TABLE.nav_hover[1],COLOR_TABLE.nav_hover[2],COLOR_TABLE.nav_hover[3],1)
                lbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
            end
        end)
        row:SetScript(WSID_OnLeave,function()
            if navActive~=name then
                bg:SetColorTexture(0,0,0,0)
                lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
            end
        end)
        navBtns[def.name]={bg=bg,stripe=stripe,lbl=lbl}
    end

    -- Reset window size button at bottom of nav
    -- Changelog button above separator
    local clNavBtn = CreateFrame(WSID_BUTTON, nil, navBg)
    clNavBtn:SetSize(WSID_SET_NAV, 36)
    clNavBtn:SetPoint(WSID_BOTTOMLEFT, navBg, WSID_BOTTOMLEFT, 0, 36)
    local clNavBg = clNavBtn:CreateTexture(nil,WSID_BACKGROUND)
    clNavBg:SetAllPoints()
    clNavBg:SetColorTexture(0,0,0,0)
    local clNavStripe = clNavBtn:CreateTexture(nil,WSID_ARTWORK)
    clNavStripe:SetColorTexture(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
    clNavStripe:SetSize(3,36)
    clNavStripe:SetPoint(WSID_LEFT,clNavBtn,WSID_LEFT,0,0)
    clNavStripe:Hide()
    local clNavLbl = clNavBtn:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    clNavLbl:SetPoint(WSID_LEFT,clNavBtn,WSID_LEFT,12,0)
    clNavLbl:SetText("Changelog")
    clNavLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    clNavBtn:SetScript(WSID_OnClick, function() SetNavActive("changelog") end)
    clNavBtn:SetScript(WSID_OnEnter, function()
        if navActive~="changelog" then
            clNavBg:SetColorTexture(COLOR_TABLE.nav_hover[1],COLOR_TABLE.nav_hover[2],COLOR_TABLE.nav_hover[3],1)
            clNavLbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        end
    end)
    clNavBtn:SetScript(WSID_OnLeave, function()
        if navActive~="changelog" then
            clNavBg:SetColorTexture(0,0,0,0)
            clNavLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        end
    end)
    navBtns["changelog"] = {bg=clNavBg, stripe=clNavStripe, lbl=clNavLbl}

    local resetSizeRule = navBg:CreateTexture(nil,WSID_ARTWORK)
    resetSizeRule:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    resetSizeRule:SetHeight(1)
    resetSizeRule:SetPoint(WSID_BOTTOMLEFT,  navBg, WSID_BOTTOMLEFT,  0, 72)
    resetSizeRule:SetPoint(WSID_BOTTOMRIGHT, navBg, WSID_BOTTOMRIGHT, 0, 72)

    local resetSizeBtn = CreateFrame(WSID_BUTTON, nil, navBg)
    resetSizeBtn:SetSize(WSID_SET_NAV, 36)
    resetSizeBtn:SetPoint(WSID_BOTTOMLEFT, navBg, WSID_BOTTOMLEFT, 0, 0)
    local rsBg = resetSizeBtn:CreateTexture(nil,WSID_BACKGROUND)
    rsBg:SetAllPoints()
    rsBg:SetColorTexture(0,0,0,0)
    local rsLbl = resetSizeBtn:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    rsLbl:SetPoint(WSID_LEFT, resetSizeBtn, WSID_LEFT, 12, 0)
    rsLbl:SetText("Reset Size")
    rsLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    resetSizeBtn:SetScript(WSID_OnEnter, function()
        rsBg:SetColorTexture(COLOR_TABLE.nav_hover[1],COLOR_TABLE.nav_hover[2],COLOR_TABLE.nav_hover[3],1)
        rsLbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    end)
    resetSizeBtn:SetScript(WSID_OnLeave, function()
        rsBg:SetColorTexture(0,0,0,0)
        rsLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    end)
    resetSizeBtn:SetScript(WSID_OnClick, function()
        WhatShouldIDoDB.uiScale = 1.0
        WhatShouldIDoDB.uiScale = 1.0
        if MainFrame     then MainFrame:SetScale(1.0) end
        if SettingsFrame then SettingsFrame:SetScale(1.0) end
        UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r UI scale reset to 100%%.", 1, 0.85, 0.2)
    end)

    --------------------------------------------------------------------
    -- ACTIVITIES PANEL: two columns
    --------------------------------------------------------------------
    -- Column layout: WSID_PAD(12) | COL(277) | gap(12) | COL(277) | WSID_PAD(12) = 590 = WSID_SET_CW ok
    -- Row heights: hdr(28) + scroll(280) + gap(10) + addRow(26) + gap(8) + resetBtn(26) = 378 < (500-30-12) = 458 ok

    local SCRL_H = 280  -- scroll list height
    local BTN_H  = 26
    local GAP    = 10

    -- Left column: Categories
    local catHdr = MakeHeader(actPanel, "Categories", WSID_SET_COL)
    catHdr:SetPoint(WSID_TOPLEFT, actPanel, WSID_TOPLEFT, WSID_SET_PAD, -WSID_SET_PAD)

    local catCount=actPanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    catCount:SetPoint(WSID_RIGHT,catHdr,WSID_RIGHT,-6,0)
    catCount:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])

    local catBG,catContent,catReset=MakeScrollBox(actPanel,WSID_SET_COL,SCRL_H)
    catBG:SetPoint(WSID_TOPLEFT,catHdr,WSID_BOTTOMLEFT,0,-4)

    local catAddBtn=MakeBtn(actPanel,"Add",54,BTN_H)
    catAddBtn:SetPoint(WSID_TOPRIGHT,catBG,WSID_BOTTOMRIGHT,0,-GAP)

    local catAddBox=CreateFrame(WSID_EDIT_BOX,nil,actPanel,WSID_BACKDROP_TEMPLATE)
    catAddBox:SetHeight(BTN_H)
    catAddBox:SetPoint(WSID_TOPLEFT,catBG,WSID_BOTTOMLEFT,0,-GAP)
    catAddBox:SetPoint(WSID_TOPRIGHT,catAddBtn,WSID_TOPLEFT,-6,0)
    catAddBox:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})
    catAddBox:SetBackdropColor(0.04,0.03,0.08,1)
    catAddBox:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    catAddBox:SetFont(WSID_GAME_FONT,11,WSID_EMPTY_STRING)
    catAddBox:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    catAddBox:SetTextInsets(6,6,2,2)
    catAddBox:SetAutoFocus(false)
    catAddBox:SetMaxLetters(64)
    catAddBox:SetScript(WSID_OnEditFocusGained,function(s) s:SetBackdropBorderColor(COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3],1) end)
    catAddBox:SetScript(WSID_OnEditFocusLost,  function(s) s:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1) end)

    local catResetBtn=MakeBtn(actPanel,"Reset All Defaults",WSID_SET_COL,BTN_H)
    catResetBtn:SetPoint(WSID_TOPLEFT,catBG,WSID_BOTTOMLEFT,0,-(GAP+BTN_H+28))

    -- Right column: Sub-Activities
    local subHdr=MakeHeader(actPanel,"Sub-Activities",WSID_SET_COL)
    subHdr:SetPoint(WSID_TOPLEFT,catHdr,WSID_TOPRIGHT,12,0)

    local subCount=actPanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    subCount:SetPoint(WSID_RIGHT,subHdr,WSID_RIGHT,-6,0)
    subCount:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])

    local subSelLbl=actPanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    subSelLbl:SetPoint(WSID_TOPLEFT,subHdr,WSID_BOTTOMLEFT,4,-4)
    subSelLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    subSelLbl:SetText("(click a category to edit its sub-activities)")
    subSelLbl:SetWidth(WSID_SET_COL)

    -- Sub scroll must align vertically with cat scroll despite the extra label line
    -- Anchor subBG to subHdr bottom + fixed 28px (label height) to keep tops aligned
    local subBG,subContent,subReset=MakeScrollBox(actPanel,WSID_SET_COL,SCRL_H)
    subBG:SetPoint(WSID_TOPLEFT,subHdr,WSID_BOTTOMLEFT,0,-28)

    local subAddBtn=MakeBtn(actPanel,"Add",54,BTN_H)
    subAddBtn:SetPoint(WSID_TOPRIGHT,subBG,WSID_BOTTOMRIGHT,0,-GAP)
    subAddBtn:SetEnabled(false)

    local subAddBox=CreateFrame(WSID_EDIT_BOX,nil,actPanel,WSID_BACKDROP_TEMPLATE)
    subAddBox:SetHeight(BTN_H)
    subAddBox:SetPoint(WSID_TOPLEFT,subBG,WSID_BOTTOMLEFT,0,-GAP)
    subAddBox:SetPoint(WSID_TOPRIGHT,subAddBtn,WSID_TOPLEFT,-6,0)
    subAddBox:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})
    subAddBox:SetBackdropColor(0.04,0.03,0.08,1)
    subAddBox:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    subAddBox:SetFont(WSID_GAME_FONT,11,WSID_EMPTY_STRING)
    subAddBox:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    subAddBox:SetTextInsets(6,6,2,2)
    subAddBox:SetAutoFocus(false)
    subAddBox:SetMaxLetters(64)
    subAddBox:SetScript(WSID_OnEditFocusGained,function(s) s:SetBackdropBorderColor(COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3],1) end)
    subAddBox:SetScript(WSID_OnEditFocusLost,  function(s) s:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1) end)

    -- State
    local selectedCat=nil
    local catRows={}
    local subRows={}
    local catRowBgs={}

    local function RefreshSubList()
        for _,r in ipairs(subRows) do r:Hide() end
        subRows={}
        if not selectedCat then
            subCount:SetText(WSID_EMPTY_STRING)
            subAddBtn:SetEnabled(false)
            return
        end
        -- if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities={} end
        if not WhatShouldIDoDB.excludedSubActivities then WhatShouldIDoDB.excludedSubActivities = {} end
        local subs = GetSubActivities()
        subCount:SetText("["..#subs.."]")
        subAddBtn:SetEnabled(true)
        for i,sub in ipairs(subs) do
            local even=(i%2==0)
            local row=CreateFrame(WSID_FRAME,nil,subContent)
            row:SetSize(WSID_SET_COL-2,22)
            row:SetPoint(WSID_TOPLEFT,subContent,WSID_TOPLEFT,0,-(i-1)*22)
            local rb=row:CreateTexture(nil,WSID_BACKGROUND)
            rb:SetAllPoints()
            rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
            local fs=row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            fs:SetPoint(WSID_LEFT,row,WSID_LEFT,6,0)
            fs:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
            fs:SetJustifyH(WSID_LEFT)
            fs:SetText(sub)
            fs:SetWidth(WSID_SET_COL-28)
            local xBtn=CreateFrame(WSID_BUTTON,nil,row)
            xBtn:SetSize(20,22)
            xBtn:SetPoint(WSID_RIGHT,row,WSID_RIGHT,0,0)
            local xL=xBtn:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            xL:SetAllPoints()
            xL:SetJustifyH(WSID_CENTER)
            xL:SetText("|cffcc3333x|r")
            local idx=i
            xBtn:SetScript(WSID_OnClick,function()
                table.remove(WhatShouldIDoDB.subActivities[selectedCat],idx)
                RefreshSubList()
            end)
            xBtn:SetScript(WSID_OnEnter,function() xL:SetText("|cffff5555x|r") end)
            xBtn:SetScript(WSID_OnLeave,function() xL:SetText("|cffcc3333x|r") end)
            table.insert(subRows,row)
        end
        subContent:SetHeight(math.max(22,#subs*22+2))
        subReset()
    end

    local function SelectCat(name,rowBg)
        selectedCat=name
        for _,rb in ipairs(catRowBgs) do rb:SetColorTexture(COLOR_TABLE.row_even[1],COLOR_TABLE.row_even[2],COLOR_TABLE.row_even[3],1) end
        rowBg:SetColorTexture(COLOR_TABLE.row_select[1],COLOR_TABLE.row_select[2],COLOR_TABLE.row_select[3],1)
        subSelLbl:SetText(name)
        subSelLbl:SetTextColor(COLOR_TABLE.spin_text[1],COLOR_TABLE.spin_text[2],COLOR_TABLE.spin_text[3])
        RefreshSubList()
    end

    WSID_refreshActivities=function()
        for _,r in ipairs(catRows) do r:Hide() end
        catRows={}
        catRowBgs={}
        selectedCat=nil
        subSelLbl:SetText("(click a category to edit its sub-activities)")
        subSelLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        for _,r in ipairs(subRows) do r:Hide() end
        subRows={}
        subCount:SetText(WSID_EMPTY_STRING)
        subAddBtn:SetEnabled(false)
        local acts=WhatShouldIDoDB.activities
        catCount:SetText("["..#acts.."]")
        for i,act in ipairs(acts) do
            local even=(i%2==0)
            local row=CreateFrame(WSID_BUTTON,nil,catContent)
            row:SetSize(WSID_SET_COL-2,22)
            row:SetPoint(WSID_TOPLEFT,catContent,WSID_TOPLEFT,0,-(i-1)*22)
            local rb=row:CreateTexture(nil,WSID_BACKGROUND)
            rb:SetAllPoints()
            rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
            table.insert(catRowBgs,rb)
            local nl=row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            nl:SetPoint(WSID_LEFT,row,WSID_LEFT,6,0)
            nl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
            nl:SetJustifyH(WSID_LEFT)
            nl:SetText(act)
            nl:SetWidth(WSID_SET_COL-28)
            local xBtn=CreateFrame(WSID_BUTTON,nil,row)
            xBtn:SetSize(20,22)
            xBtn:SetPoint(WSID_RIGHT,row,WSID_RIGHT,0,0)
            local xL=xBtn:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            xL:SetAllPoints()
            xL:SetJustifyH(WSID_CENTER)
            xL:SetText("|cffcc3333x|r")
            local idx=i
            xBtn:SetScript(WSID_OnClick,function()
                if selectedCat==WhatShouldIDoDB.activities[idx] then
                    selectedCat=nil
                    subSelLbl:SetText("(click a category to edit its sub-activities)")
                    subSelLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
                    for _,r in ipairs(subRows) do r:Hide() end
                    subRows={}
                    subCount:SetText(WSID_EMPTY_STRING)
                    subAddBtn:SetEnabled(false)
                end
                table.remove(WhatShouldIDoDB.activities,idx)
                WSID_refreshActivities()
            end)
            xBtn:SetScript(WSID_OnEnter,function() xL:SetText("|cffff5555x|r") end)
            xBtn:SetScript(WSID_OnLeave,function() xL:SetText("|cffcc3333x|r") end)
            local actName=act
            row:SetScript(WSID_OnClick,function() SelectCat(actName,rb) end)
            row:SetScript(WSID_OnEnter,function() if selectedCat~=actName then rb:SetColorTexture(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1) end end)
            row:SetScript(WSID_OnLeave,function()
                if selectedCat~=actName then rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1) end end)
            table.insert(catRows,row)
        end
        catContent:SetHeight(math.max(22,#acts*22+2))
        catReset()
    end

    local function DoCatAdd()
        local txt=strtrim(catAddBox:GetText())
        if txt~=WSID_EMPTY_STRING then
            table.insert(WhatShouldIDoDB.activities,txt)
            catAddBox:SetText(WSID_EMPTY_STRING)
            WSID_refreshActivities()
        end
    end
    catAddBtn:SetScript(WSID_OnClick,DoCatAdd)
    catAddBox:SetScript(WSID_OnEnterPressed,DoCatAdd)

    local function DoSubAdd()
        if selectedCat then
            local txt=strtrim(subAddBox:GetText())
            if txt~=WSID_EMPTY_STRING then
                if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities={} end
                if not WhatShouldIDoDB.subActivities[selectedCat] then WhatShouldIDoDB.subActivities[selectedCat]={} end
                table.insert(WhatShouldIDoDB.subActivities[selectedCat],txt)
                subAddBox:SetText(WSID_EMPTY_STRING)
                RefreshSubList()
            end
        end
        local txt=strtrim(subAddBox:GetText())
        if txt~=WSID_EMPTY_STRING then
            if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities={} end
            if not WhatShouldIDoDB.subActivities[selectedCat] then WhatShouldIDoDB.subActivities[selectedCat]={} end
            table.insert(WhatShouldIDoDB.subActivities[selectedCat],txt)
            subAddBox:SetText(WSID_EMPTY_STRING)
            RefreshSubList()
        end
    end

    subAddBtn:SetScript(WSID_OnClick,DoSubAdd)
    subAddBox:SetScript(WSID_OnEnterPressed,DoSubAdd)

    catResetBtn:SetScript(WSID_OnClick,function()
        WhatShouldIDoDB.activities={}
        for activity, _ in ipairs(WSID_ACTIVITIES_INFO) do table.insert(WhatShouldIDoDB.activities,activity) end
        WhatShouldIDoDB.subActivities={}
        WSID_refreshActivities()
    end)

    --------------------------------------------------------------------
    -- ROSTER PANEL
    --------------------------------------------------------------------

    local rostHdr=MakeHeader(rostPanel,"Seen Characters",WSID_SET_CW)
    rostHdr:SetPoint(WSID_TOPLEFT,rostPanel,WSID_TOPLEFT,WSID_SET_PAD,-WSID_SET_PAD)
    local rostCount=rostPanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    rostCount:SetPoint(WSID_RIGHT,rostHdr,WSID_RIGHT,-6,0)
    rostCount:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    local rostNote=rostPanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    rostNote:SetPoint(WSID_TOPLEFT,rostHdr,WSID_BOTTOMLEFT,4,-6)
    rostNote:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    rostNote:SetText("Log into each alt to add it. Levels update on every login.")
    rostNote:SetWidth(WSID_SET_CW)

    local rostBG,rostContent,rostReset=MakeScrollBox(rostPanel,WSID_SET_CW,WSID_SET_H-30-WSID_SET_PAD*2-80)
    rostBG:SetPoint(WSID_TOPLEFT,rostNote,WSID_BOTTOMLEFT,0,-8)

    local rostRows={}
    WSID_refreshRoster=function()
        for _,r in ipairs(rostRows) do r:Hide() end
        rostRows={}
        local chars=WhatShouldIDoDB.seenChars
        rostCount:SetText("["..#chars.."]")
        if not WhatShouldIDoDB.excludedChars then WhatShouldIDoDB.excludedChars = {} end
        for i,ch in ipairs(chars) do
            local even=(i%2==0)
            local row=CreateFrame(WSID_FRAME,nil,rostContent)
            row:SetSize(WSID_SET_CW-2,24)
            row:SetPoint(WSID_TOPLEFT,rostContent,WSID_TOPLEFT,0,-(i-1)*24)
            local rb=row:CreateTexture(nil,WSID_BACKGROUND)
            rb:SetAllPoints()
            rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
            local cc=WSID_CLASS_INFO[ch.class] or {r=0.8,g=0.8,b=0.8}
            local isExcluded = WhatShouldIDoDB.excludedChars[ch.name] == true
            local fs=row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            fs:SetPoint(WSID_LEFT,row,WSID_LEFT,10,0)
            fs:SetJustifyH(WSID_LEFT)
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s %s|r  |cffffcc00Lv %d|r%s",
                isExcluded and 80 or cc.r*255,
                isExcluded and 80 or cc.g*255,
                isExcluded and 80 or cc.b*255,
                ch.name, ch.race or WSID_EMPTY_STRING, ch.class or WSID_EMPTY_STRING, ch.level or 0,
                isExcluded and "  |cff888888[excluded]|r" or WSID_EMPTY_STRING))
            local isCurrent=(ch.name==UnitName(WSID_IDENTITY))
            -- Exclude toggle button (all chars including current)
            local exBtn=CreateFrame(WSID_BUTTON,nil,row,WSID_BACKDROP_TEMPLATE)
            exBtn:SetSize(58,18)
            exBtn:SetPoint(WSID_RIGHT,row,WSID_RIGHT, isCurrent and -4 or -26, 0)
            exBtn:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})
            local function UpdateExBtn()
                local ex = WhatShouldIDoDB.excludedChars[ch.name] == true
                exBtn:SetBackdropColor(ex and 0.25 or 0.08, ex and 0.08 or 0.18, ex and 0.08 or 0.08)
                exBtn:SetBackdropBorderColor(ex and 0.6 or 0.3, ex and 0.2 or 0.3, ex and 0.2 or 0.3, 1)
                local exL = exBtn._lbl
                if exL then exL:SetText(ex and "|cffff6666Excluded|r" or "|cff888888Exclude|r") end
            end
            local exL=exBtn:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            exL:SetAllPoints()
            exL:SetJustifyH(WSID_CENTER)
            exBtn._lbl = exL
            UpdateExBtn()
            local cn=ch.name
            exBtn:SetScript(WSID_OnClick,function()
                if WhatShouldIDoDB.excludedChars[cn] then
                    WhatShouldIDoDB.excludedChars[cn] = nil
                else
                    WhatShouldIDoDB.excludedChars[cn] = true
                end
                WSID_refreshRoster()
            end)
            if isCurrent then
                local yl=row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
                yl:SetPoint(WSID_RIGHT,exBtn,WSID_LEFT,-4,0)
                yl:SetTextColor(0.30,0.75,0.30)
                yl:SetText("(you)")
            else
                local xBtn=CreateFrame(WSID_BUTTON,nil,row)
                xBtn:SetSize(20,24)
                xBtn:SetPoint(WSID_RIGHT,row,WSID_RIGHT,0,0)
                local xL2=xBtn:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
                xL2:SetAllPoints()
                xL2:SetJustifyH(WSID_CENTER)
                xL2:SetText("|cffcc3333x|r")
                xBtn:SetScript(WSID_OnClick,function()
                    RemoveCharFromRoster(cn)
                    WSID_refreshRoster()
                end)
                xBtn:SetScript(WSID_OnEnter,function() xL2:SetText("|cffff5555x|r") end)
                xBtn:SetScript(WSID_OnLeave,function() xL2:SetText("|cffcc3333x|r") end)
            end
            table.insert(rostRows,row)
        end
        rostContent:SetHeight(math.max(24,#chars*24+2))
        rostReset()
    end

    local clearBtn=MakeBtn(rostPanel,"Clear All Others",WSID_SET_CW,BTN_H)
    clearBtn:SetPoint(WSID_TOPLEFT,rostBG,WSID_BOTTOMLEFT,0,-10)
    clearBtn:SetScript(WSID_OnClick,function()
        local cur=UnitName(WSID_IDENTITY)
        local kept={}
        for _,ch in ipairs(WhatShouldIDoDB.seenChars) do
            if ch.name==cur then table.insert(kept,ch) end
        end
        WhatShouldIDoDB.seenChars=kept
        BuildRoster()
        WSID_refreshRoster()
        print("|cffd5a742What Should I Do?:|r Roster cleared.")
    end)

    --------------------------------------------------------------------
    -- IMPORT / EXPORT PANEL
    --------------------------------------------------------------------

    local ioNoteBg = ioPanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    ioNoteBg:SetPoint(WSID_TOPLEFT, ioPanel, WSID_TOPLEFT, WSID_SET_PAD, -WSID_SET_PAD)
    ioNoteBg:SetPoint(WSID_RIGHT,   ioPanel, WSID_RIGHT,  -WSID_SET_PAD, 0)
    ioNoteBg:SetJustifyH(WSID_LEFT)
    ioNoteBg:SetWordWrap(true)
    ioNoteBg:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    ioNoteBg:SetText("|cffd5a742For multi-account players:|r Export your roster on one account, then import it on another. This lets the Leveling wheel see characters from all your accounts in one place.")

    -- Encode tables (no collisions between CLASS/RACE/FACT within same field)
    local CLASS_ENC = {}
    local CLASS_DEC = {}
    for _, c in ipairs(WSID_CLASS_INFO) do
        CLASS_ENC[c.name] = c.short_name
        CLASS_DEC[c.short_name] = c.name
    end

    local RACE_ENC = {}
    local RACE_DEC = {}
    for _, r in ipairs(WSID_RACE_INFO) do
        if r then
            RACE_ENC[r.name] = r.short_name
            RACE_DEC[r.short_name] = r.name
        end
    end

    local FACT_ENC = {[ALLIANCE]="Al",[HORDE]="Ho",[NEUTRAL]="Ne"}
    local FACT_DEC = {Al=ALLIANCE,Ho=HORDE,Ne=NEUTRAL}

    local function BuildExportStr()
        local chars = WhatShouldIDoDB and WhatShouldIDoDB.seenChars
        if not chars or #chars == 0 then return nil end
        local excl = WhatShouldIDoDB.excludedChars or {}
        local parts = {}
        for _, ch in ipairs(chars) do
            local cls  = EncodeClass(ch.class)  or (ch.class   or "?")
            local race = EncodeRace(ch.race)    or (ch.race    or "?")
            local fact = FACT_ENC[ch.faction] or (ch.faction or "?")
            table.insert(parts, (ch.name or "?")..":"..cls..":"..tostring(ch.level or 0)..":"..race..":"..fact..":".. (excl[ch.name] and "1" or "0"))
        end
        return "W2:" .. table.concat(parts, "|")
    end

    -- EXPORT section
    local expHdr = MakeHeader(ioPanel, "Export Roster", WSID_SET_CW)
    expHdr:SetPoint(WSID_TOPLEFT, ioNoteBg, WSID_BOTTOMLEFT, -4, -10)

    local expBoxBg = CreateFrame(WSID_FRAME, nil, ioPanel, WSID_BACKDROP_TEMPLATE)
    expBoxBg:SetSize(WSID_SET_CW, 54)
    expBoxBg:SetPoint(WSID_TOPLEFT, expHdr, WSID_BOTTOMLEFT, 0, -6)
    expBoxBg:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})
    expBoxBg:SetBackdropColor(0.06,0.04,0.10,1)
    expBoxBg:SetBackdropBorderColor(0.25,0.20,0.35,1)

    -- XOR encode/decode for opaque export strings
    local XOR_KEY = 42
    local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function EncodeStr(str)
        -- XOR each byte then base64-encode
        local xored = {}
        for i = 1, #str do
            xored[i] = string.char(bit.bxor(str:byte(i), XOR_KEY))
        end
        local raw = table.concat(xored)
        -- simple base64
        local out = {}
        for i = 1, #raw, 3 do
            local a, b, c = raw:byte(i), raw:byte(i+1) or 0, raw:byte(i+2) or 0
            local n = a*65536 + b*256 + c
            out[#out+1] = B64:sub(math.floor(n/262144)%64+1,math.floor(n/262144)%64+1)
            out[#out+1] = B64:sub(math.floor(n/4096)%64+1,math.floor(n/4096)%64+1)
            out[#out+1] = (raw:byte(i+1) and B64:sub(math.floor(n/64)%64+1,math.floor(n/64)%64+1) or "=")
            out[#out+1] = (raw:byte(i+2) and B64:sub(n%64+1,n%64+1) or "=")
        end
        return "WX!" .. table.concat(out)
    end
    local function DecodeStr(enc)
        if enc:sub(1,3) ~= "WX!" then return nil end
        local b64 = enc:sub(4)
        local map = {}
        for i = 1, #B64 do map[B64:sub(i,i)] = i-1 end
        local raw = {}
        for i = 1, #b64, 4 do
            local a = map[b64:sub(i,i)] or 0
            local b = map[b64:sub(i+1,i+1)] or 0
            local c = map[b64:sub(i+2,i+2)]
            local d = map[b64:sub(i+3,i+3)]
            local n = a*262144 + b*4096 + (c or 0)*64 + (d or 0)
            raw[#raw+1] = string.char(math.floor(n/65536) % 256)
            if c then raw[#raw+1] = string.char(math.floor(n/256) % 256) end
            if d then raw[#raw+1] = string.char(n % 256) end
        end
        -- XOR decode
        local out = {}
        for _, ch in ipairs(raw) do
            out[#out+1] = string.char(bit.bxor(ch:byte(1), XOR_KEY))
        end
        return table.concat(out)
    end

    -- ScrollFrame inside expBoxBg so the multiline EditBox scrolls
    local expScroll = CreateFrame("ScrollFrame", nil, expBoxBg, "UIPanelScrollFrameTemplate")
    expScroll:SetPoint(WSID_TOPLEFT,     expBoxBg, WSID_TOPLEFT,     4,  -4)
    expScroll:SetPoint(WSID_BOTTOMRIGHT, expBoxBg, WSID_BOTTOMRIGHT, -24,  4)

    local expBox = CreateFrame(WSID_EDIT_BOX, "WhatShouldIDoExportBox", expScroll, "InputBoxTemplate")
    expBox:SetWidth(expScroll:GetWidth() or (WSID_SET_CW - 28))
    expBox:SetHeight(54)
    expBox:SetFontObject(GameFontNormalSmall)
    expBox:SetTextColor(0.85, 0.85, 0.85)
    expBox:SetMultiLine(true)
    expBox:SetAutoFocus(false)
    expBox:SetMaxLetters(0)
    expBox:SetText("-- click Export to generate --")
    expBox._last = WSID_EMPTY_STRING
    expScroll:SetScrollChild(expBox)
    -- Hide InputBoxTemplate border textures
    if expBox.Left   then expBox.Left:SetAlpha(0) end
    if expBox.Middle then expBox.Middle:SetAlpha(0) end
    if expBox.Right  then expBox.Right:SetAlpha(0) end
    -- Sync scroll when text changes
    expBox:SetScript(WSID_OnTextChanged, function(self)
        expScroll:UpdateScrollChildRect()
    end)
    -- Block typing but allow select/copy
    expBox:SetScript(WSID_OnChar,            function(s) s:SetText(s._last or WSID_EMPTY_STRING) end)
    expBox:SetScript(WSID_OnEscapePressed,   function(s) s:ClearFocus() end)
    expBox:SetScript(WSID_OnEnterPressed,    function(s) s:ClearFocus() end)
    expBox:SetScript(WSID_OnEditFocusGained, function(s) s:HighlightText() end)

    local expGenBtn = MakeBtn(ioPanel, "Export", WSID_SET_CW, 24)
    expGenBtn:SetPoint(WSID_TOPLEFT, expBoxBg, WSID_BOTTOMLEFT, 0, -4)

    expGenBtn:SetScript(WSID_OnClick, function()
        local str = BuildExportStr()
        if not str then
            expBox._last = WSID_EMPTY_STRING
            expBox:SetText("No characters in roster.")
            return
        end
        local encoded = EncodeStr(str)
        expBox._last = encoded
        expBox:SetText(encoded)
        expBox:SetFocus()
    end)

    local ioRule = ioPanel:CreateTexture(nil,WSID_ARTWORK)
    ioRule:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    ioRule:SetHeight(1)
    ioRule:SetPoint(WSID_TOPLEFT,  expGenBtn, WSID_BOTTOMLEFT,  0, -10)
    ioRule:SetPoint(WSID_TOPRIGHT, expGenBtn, WSID_BOTTOMRIGHT, 0, -10)

    -- IMPORT
    local impHdr = MakeHeader(ioPanel, "Import Roster", WSID_SET_CW)
    impHdr:SetPoint(WSID_TOPLEFT, ioRule, WSID_BOTTOMLEFT, 0, -8)

    local impBoxBg = CreateFrame(WSID_FRAME, nil, ioPanel, WSID_BACKDROP_TEMPLATE)
    impBoxBg:SetSize(WSID_SET_CW, 26)
    impBoxBg:SetPoint(WSID_TOPLEFT, impHdr, WSID_BOTTOMLEFT, 0, -6)
    impBoxBg:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})
    impBoxBg:SetBackdropColor(0.03,0.02,0.06,1)
    impBoxBg:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)

    local impBox = CreateFrame(WSID_EDIT_BOX, "WhatShouldIDoImportBox", impBoxBg)
    impBox:SetPoint(WSID_TOPLEFT,     impBoxBg, WSID_TOPLEFT,     6, -4)
    impBox:SetPoint(WSID_BOTTOMRIGHT, impBoxBg, WSID_BOTTOMRIGHT, -6,  4)
    impBox:SetFontObject(ChatFontNormal)
    impBox:SetTextColor(1, 1, 1)
    impBox:SetAutoFocus(false)
    impBox:SetScript(WSID_OnEscapePressed, function(s) s:ClearFocus() end)
    impBox:SetScript(WSID_OnEditFocusGained, function()
        impBoxBg:SetBackdropBorderColor(COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3],1)
    end)
    impBox:SetScript(WSID_OnEditFocusLost, function()
        impBoxBg:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    end)

    local impBtn = MakeBtn(ioPanel, "Import Roster", WSID_SET_CW, 24)
    impBtn:SetPoint(WSID_TOPLEFT, impBoxBg, WSID_BOTTOMLEFT, 0, -4)

    local impStatus = ioPanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    impStatus:SetPoint(WSID_TOPLEFT, impBtn, WSID_BOTTOMLEFT, 4, -6)
    impStatus:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    impStatus:SetText(" ")
    impStatus:SetWidth(WSID_SET_CW)

    WSID_DoImport = function(importStr)
        importStr = strtrim(importStr or WSID_EMPTY_STRING)
        if importStr == WSID_EMPTY_STRING then
            impStatus:SetText("Paste an export string first.")
            impStatus:SetTextColor(0.8,0.3,0.3)
            return
        end
        -- Decode WX! encoded strings first
        if importStr:sub(1,3) == "WX!" then
            local decoded = DecodeStr(importStr)
            if not decoded then
                impStatus:SetText("Failed to decode string.")
                impStatus:SetTextColor(0.8,0.3,0.3)
                return
            end
            importStr = decoded
        end
        local str, compressed
        if importStr:sub(1,3) == "W2:" then
            str = importStr:sub(4)
            compressed = true
        elseif importStr:sub(1,5) == "WSID:" then
            str = importStr:sub(6)
            compressed = false
        else
            impStatus:SetText("Invalid string format.")
            impStatus:SetTextColor(0.8,0.3,0.3)
            return
        end
        local imported, updated, excluded = 0, 0, 0
        if not WhatShouldIDoDB.excludedChars then WhatShouldIDoDB.excludedChars = {} end
        for entry in str:gmatch("[^|]+") do
            local name,cls,level,race,faction,excl = entry:match("^([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):?([01]?)$")
            if name and name ~= WSID_EMPTY_STRING then
                if compressed then
                    cls     = DecodeClass(cls) or NormalizeClass(cls)
                    race    = RACE_DEC[race]    or race
                    faction = FACT_DEC[faction] or faction
                else
                    cls = NormalizeClass(cls)
                end
                local exists = false
                for _, ch in ipairs(WhatShouldIDoDB.seenChars) do
                    if ch.name == name then
                        if tonumber(level) and tonumber(level) > (ch.level or 0) then
                            ch.level = tonumber(level)
                            updated = updated + 1
                        end
                        exists = true
                        break
                    end
                end
                if not exists then
                    table.insert(WhatShouldIDoDB.seenChars, {
                        name=name, class=cls, level=tonumber(level) or 0, race=race, faction=faction,
                    })
                    imported = imported + 1
                end
                if excl == "1" then
                    WhatShouldIDoDB.excludedChars[name] = true
                    excluded = excluded + 1
                end
            end
        end
        BuildRoster()
        if WSID_refreshRoster then WSID_refreshRoster() end
        impBox:SetText(WSID_EMPTY_STRING)
        impStatus:SetTextColor(0.3,0.8,0.3)
        impStatus:SetText(string.format("Done! %d added, %d levels updated, %d excluded.", imported, updated, excluded))
    end

    impBtn:SetScript(WSID_OnClick, function()
        WSID_DoImport(impBox:GetText())
    end)
    impBox:SetScript(WSID_OnEnterPressed, function(s)
        WSID_DoImport(s:GetText())
        s:ClearFocus()
    end)

    --------------------------------------------------------------------
    -- COLORS PANEL
    --------------------------------------------------------------------

    local colScrollBG, colScrollContent, _ = MakeScrollBox(colorsPanel, WSID_SET_CW, WSID_SET_H - 30 - WSID_SET_PAD * 2)
    colScrollBG:SetPoint(WSID_TOPLEFT, colorsPanel, WSID_TOPLEFT, WSID_SET_PAD, -WSID_SET_PAD)

    -- COLOR THEME
    local colHdr = MakeHeader(colScrollContent, "Color Theme", WSID_SET_CW - 4)
    colHdr:SetPoint(WSID_TOPLEFT, colScrollContent, WSID_TOPLEFT, 0, -4)

    local colDesc = colScrollContent:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    colDesc:SetPoint(WSID_TOPLEFT, colHdr, WSID_BOTTOMLEFT, 4, -6)
    colDesc:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    colDesc:SetText("Select a theme. A UI reload is required to fully apply the new colors.")
    colDesc:SetWidth(WSID_SET_CW - 8)

    local themeSep = colScrollContent:CreateTexture(nil,WSID_ARTWORK)
    themeSep:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    themeSep:SetHeight(1)
    themeSep:SetPoint(WSID_TOPLEFT,  colDesc, WSID_BOTTOMLEFT,  0, -10)
    themeSep:SetPoint(WSID_TOPRIGHT, colDesc, WSID_BOTTOMRIGHT, 0, -10)

    local themeHdr = colScrollContent:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    themeHdr:SetPoint(WSID_TOPLEFT, themeSep, WSID_BOTTOMLEFT, 0, -8)
    themeHdr:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    themeHdr:SetText("Preset Themes:")

    -- Confirm popup helper
    local function ConfirmAndReload(themeName, displayName, onConfirm)
        StaticPopupDialogs["WSID_CONFIRM_THEME"] = {
            text = "Apply the "..displayName.." theme?\n\nThe UI will reload to apply the new colors.",
            button1 = "Yes, Apply",
            button2 = "Cancel",
            OnAccept = function()
                if onConfirm then onConfirm() end
                WhatShouldIDoDB.colorTheme = themeName
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
        StaticPopup_Show("WSID_CONFIRM_THEME")
    end

    local THEME_DEFS = {
        {name=DEFAULT,      label=DEFAULT,      desc="The original purple theme."},
        {name=DEUTERANOPIA, label=DEUTERANOPIA, desc="Red-green colorblind. Blue/cyan accents."},
        {name=PROTANOPIA,   label=PROTANOPIA,   desc="Red blind. Deep blue accents."},
        {name=TRITANOPIA,   label=TRITANOPIA,   desc="Blue-yellow blind. Orange/amber accents."},
        {name=HIGHCONTRAST, label="High Contrast",desc="Black background with yellow accents."},
    }

    local themeBtns = {}
    local function UpdateThemeBtns()
        local cur = WhatShouldIDoDB.colorTheme or DEFAULT
        for _, tb in ipairs(themeBtns) do
            if tb._theme == cur then
                tb:SetBackdropColor(COLOR_TABLE.nav_active[1],COLOR_TABLE.nav_active[2],COLOR_TABLE.nav_active[3])
                tb:SetBackdropBorderColor(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
                tb._lbl:SetTextColor(1,1,1)
            else
                tb:SetBackdropColor(COLOR_TABLE.btn_bg[1],COLOR_TABLE.btn_bg[2],COLOR_TABLE.btn_bg[3])
                tb:SetBackdropBorderColor(COLOR_TABLE.btn_bdr[1],COLOR_TABLE.btn_bdr[2],COLOR_TABLE.btn_bdr[3],1)
                tb._lbl:SetTextColor(COLOR_TABLE.btn_text[1],COLOR_TABLE.btn_text[2],COLOR_TABLE.btn_text[3])
            end
        end
    end

    local prevRow = themeHdr
    for _, td in ipairs(THEME_DEFS) do
        local row = CreateFrame(WSID_FRAME, nil, colScrollContent)
        row:SetSize(WSID_SET_CW - 4, 28)
        row:SetPoint(WSID_TOPLEFT, prevRow, WSID_BOTTOMLEFT, 0, -6)

        local btn = MakeBtn(row, td.label, 140, 26)
        btn:SetPoint(WSID_TOPLEFT, row, WSID_TOPLEFT, 0, 0)
        local tname = td.name
        local tlabel = td.label
        btn._theme = tname
        btn:SetScript(WSID_OnClick, function()
            ConfirmAndReload(tname, tlabel)
        end)
        table.insert(themeBtns, btn)

        local dlbl = row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
        dlbl:SetPoint(WSID_LEFT, btn, WSID_RIGHT, 10, 0)
        dlbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        dlbl:SetText(td.desc)
        prevRow = row
    end

    UpdateThemeBtns()

    -- Custom section
    local customSep = colScrollContent:CreateTexture(nil,WSID_ARTWORK)
    customSep:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    customSep:SetHeight(1)
    customSep:SetPoint(WSID_TOPLEFT,  prevRow, WSID_BOTTOMLEFT,  0, -12)
    customSep:SetPoint(WSID_TOPRIGHT, prevRow, WSID_BOTTOMRIGHT, 0, -12)

    local customHdr = colScrollContent:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    customHdr:SetPoint(WSID_TOPLEFT, customSep, WSID_BOTTOMLEFT, 0, -8)
    customHdr:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    customHdr:SetText("Custom Colors -- click Edit to pick a color. Hit Apply when done.")

    local CUSTOM_KEYS = {
        {key="nav_border",  label="Accent / Border"},
        {key="btn_bdr",     label="Button Border"},
        {key="header_txt",  label="Header Text"},
        {key="spin_text",   label="Spin Result Text"},
        {key="bright_text", label="Bright Text"},
        {key="bg",          label="Background"},
    }

    local swatchRefs = {}  -- track swatches so we can update them after color pick

    local function OpenColorPicker(key, swatch)
        -- Auto-select Custom theme when editing colors
        WhatShouldIDoDB.colorTheme = CUSTOM
        UpdateThemeBtns()
        if not WhatShouldIDoDB.customColors then WhatShouldIDoDB.customColors = {} end
        -- Seed all keys from current C table if not yet set
        for k,v in pairs(COLOR_TABLE) do
            if not WhatShouldIDoDB.customColors[k] then
                WhatShouldIDoDB.customColors[k] = {v[1],v[2],v[3]}
            end
        end
        local cur = WhatShouldIDoDB.customColors[key] or COLOR_TABLE[key]
        local info = {}
        info.r, info.g, info.b = cur[1], cur[2], cur[3]
        info.hasOpacity = false
        info.swatchFunc = function()
            local r,g,b = ColorPickerFrame:GetColorRGB()
            WhatShouldIDoDB.customColors[key] = {r,g,b}
            -- Update the swatch preview
            if swatch then swatch:SetBackdropColor(r,g,b,1) end
        end
        info.cancelFunc = function(prev)
            WhatShouldIDoDB.customColors[key] = {prev.r,prev.g,prev.b}
            if swatch then swatch:SetBackdropColor(prev.r,prev.g,prev.b,1) end
        end
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end

    local prevCustom = customHdr
    for _, ck in ipairs(CUSTOM_KEYS) do
        local row = CreateFrame(WSID_FRAME, nil, colScrollContent)
        row:SetSize(WSID_SET_CW - 4, 26)
        row:SetPoint(WSID_TOPLEFT, prevCustom, WSID_BOTTOMLEFT, 0, -6)

        local swatch = CreateFrame(WSID_BUTTON, nil, row, WSID_BACKDROP_TEMPLATE)
        swatch:SetSize(22, 22)
        swatch:SetPoint(WSID_TOPLEFT, row, WSID_TOPLEFT, 0, -2)
        swatch:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})
        local cv = COLOR_TABLE[ck.key]
        swatch:SetBackdropColor(cv[1],cv[2],cv[3],1)
        swatch:SetBackdropBorderColor(0.4,0.4,0.4,1)
        table.insert(swatchRefs, {swatch=swatch, key=ck.key})

        local rlbl = row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
        rlbl:SetPoint(WSID_LEFT, swatch, WSID_RIGHT, 8, 0)
        rlbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        rlbl:SetText(ck.label)

        local editBtn = MakeBtn(row, "Edit", 50, 22)
        editBtn:SetPoint(WSID_LEFT, rlbl, WSID_RIGHT, 10, 0)
        local k = ck.key
        editBtn:SetScript(WSID_OnClick, function() OpenColorPicker(k, swatch) end)

        prevCustom = row
    end

    -- Apply Custom button with confirmation
    local applyCustomBtn = MakeBtn(colScrollContent, "Apply Custom Theme", 220, 30)
    applyCustomBtn:SetPoint(WSID_TOPLEFT, prevCustom, WSID_BOTTOMLEFT, 0, -12)
    applyCustomBtn:SetScript(WSID_OnClick, function()
        StaticPopupDialogs["WSID_CONFIRM_CUSTOM"] = {
            text = "Apply your custom color theme?\n\nThe UI will reload to apply the new colors.",
            button1 = "Yes, Apply",
            button2 = "Cancel",
            OnAccept = function()
                WhatShouldIDoDB.colorTheme = CUSTOM
                -- Write custom colors into C so they survive the reload via DB
                if WhatShouldIDoDB.customColors then
                    ApplyTheme(CUSTOM, WhatShouldIDoDB.customColors)
                end
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
        StaticPopup_Show("WSID_CONFIRM_CUSTOM")
    end)

    -- Set scroll content height
    colScrollContent:SetHeight(680)

    --------------------------------------------------------------------
    -- EXPANSIONS PANEL
    --------------------------------------------------------------------

    local expExclHdr = MakeHeader(expExclPanel, "Raid & Dungeon Expansions", WSID_SET_CW)
    expExclHdr:SetPoint(WSID_TOPLEFT, expExclPanel, WSID_TOPLEFT, WSID_SET_PAD, -WSID_SET_PAD)

    local expExclDesc = expExclPanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    expExclDesc:SetPoint(WSID_TOPLEFT, expExclHdr, WSID_BOTTOMLEFT, 4, -6)
    expExclDesc:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    expExclDesc:SetText("Uncheck an expansion to exclude it from the Raids & Dungeons spinner.")
    expExclDesc:SetWidth(WSID_SET_CW - 8)

    local expExclScrollBG, expExclContent, _ = MakeScrollBox(expExclPanel, WSID_SET_CW, WSID_SET_H - 160)
    expExclScrollBG:SetPoint(WSID_TOPLEFT, expExclDesc, WSID_BOTTOMLEFT, -4, -8)

    local ORDER = WSID_EXPANSIONS

    local ROW_H = 28

    local COL_W = math.floor(WSID_SET_CW / 2) - 2

    local function MakeExpRow(i, exp)
        local col = (i-1) % 2        -- 0 = left, 1 = right
        local rowIdx = math.floor((i-1) / 2)
        local even = (rowIdx%2==0)
        local row = CreateFrame(WSID_BUTTON, nil, expExclContent, WSID_BACKDROP_TEMPLATE)
        row:SetSize(COL_W, ROW_H)
        row:SetPoint(WSID_TOPLEFT, expExclContent, WSID_TOPLEFT, col*(COL_W+4), -rowIdx*ROW_H)
        row:SetBackdrop({bgFile=WSID_BG_FILE})
        row:SetBackdropColor(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                             even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                             even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)

        -- Custom checkbox box
        local box = CreateFrame(WSID_FRAME, nil, row, WSID_BACKDROP_TEMPLATE)
        box:SetSize(14, 14)
        box:SetPoint(WSID_LEFT, row, WSID_LEFT, 10, 0)
        box:SetBackdrop({bgFile=WSID_BG_FILE,edgeFile=WSID_BG_FILE,edgeSize=1})

        -- Checkmark texture
        local check = box:CreateTexture(nil, WSID_OVERLAY)
        check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
        check:SetSize(16, 16)
        check:SetPoint(WSID_CENTER, box, WSID_CENTER, 0, 0)

        -- Label
        local lbl = row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
        lbl:SetPoint(WSID_LEFT, box, WSID_RIGHT, 8, 0)

        local expName = exp
        local checked = not (WhatShouldIDoDB.excludedExpansions and WhatShouldIDoDB.excludedExpansions[expName])

        local function SetState(isChecked)
            checked = isChecked
            -- Use C table if populated, else hardcoded defaults
            local ac1,ac2,ac3   = COLOR_TABLE.accent     and COLOR_TABLE.accent[1]      or 0.84, COLOR_TABLE.accent     and COLOR_TABLE.accent[2]      or 0.67, COLOR_TABLE.accent     and COLOR_TABLE.accent[3]      or 0.20
            local rb1,rb2,rb3   = COLOR_TABLE.result_bg  and COLOR_TABLE.result_bg[1]   or 0.06, COLOR_TABLE.result_bg  and COLOR_TABLE.result_bg[2]   or 0.04, COLOR_TABLE.result_bg  and COLOR_TABLE.result_bg[3]   or 0.10
            local di1,di2,di3   = COLOR_TABLE.divider    and COLOR_TABLE.divider[1]     or 0.25, COLOR_TABLE.divider    and COLOR_TABLE.divider[2]     or 0.20, COLOR_TABLE.divider    and COLOR_TABLE.divider[3]     or 0.35
            local br1,br2,br3   = COLOR_TABLE.bright_text and COLOR_TABLE.bright_text[1] or 1.00, COLOR_TABLE.bright_text and COLOR_TABLE.bright_text[2] or 0.90, COLOR_TABLE.bright_text and COLOR_TABLE.bright_text[3] or 0.40
            local dm1,dm2,dm3   = COLOR_TABLE.dim_text   and COLOR_TABLE.dim_text[1]    or 0.50, COLOR_TABLE.dim_text   and COLOR_TABLE.dim_text[2]    or 0.45, COLOR_TABLE.dim_text   and COLOR_TABLE.dim_text[3]    or 0.55
            if isChecked then
                box:SetBackdropColor(rb1,rb2,rb3,1)
                box:SetBackdropBorderColor(ac1,ac2,ac3,1)
                check:SetVertexColor(ac1,ac2,ac3,1)
                check:Show()
                lbl:SetTextColor(br1,br2,br3)
            else
                box:SetBackdropColor(0.05,0.03,0.08,1)
                box:SetBackdropBorderColor(di1,di2,di3,1)
                check:Hide()
                lbl:SetTextColor(dm1,dm2,dm3)
            end
        end

        lbl:SetText(expName)
        SetState(checked)

        row:SetScript(WSID_OnClick, function()
            if not WhatShouldIDoDB.excludedExpansions then WhatShouldIDoDB.excludedExpansions = {} end
            checked = not checked
            if checked then
                WhatShouldIDoDB.excludedExpansions[expName] = nil
            else
                WhatShouldIDoDB.excludedExpansions[expName] = true
            end
            SetState(checked)
        end)
        row:SetScript(WSID_OnEnter, function()
            row:SetBackdropColor(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1)
        end)
        local re,rg,rb = even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1], even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2], even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3]
        row:SetBackdropColor(re,rg,rb,1)
        row:SetScript(WSID_OnLeave, function() row:SetBackdropColor(re,rg,rb,1) end)

        return row, SetState
    end

    local expRows = {}
    for i, exp in ipairs(ORDER) do
        local row, setState = MakeExpRow(i, exp)
        expRows[exp] = setState
    end
    expExclContent:SetHeight(math.ceil(#ORDER / 2) * ROW_H)

    -- Enable All / Disable All buttons
    local expEnableAllBtn = MakeBtn(expExclPanel, "Enable All", math.floor(WSID_SET_CW/2) - 3, 24)
    expEnableAllBtn:SetPoint(WSID_BOTTOMLEFT, expExclPanel, WSID_BOTTOMLEFT, WSID_SET_PAD, WSID_SET_PAD)
    expEnableAllBtn:SetScript(WSID_OnClick, function()
        if WhatShouldIDoDB.excludedExpansions then wipe(WhatShouldIDoDB.excludedExpansions) end
        for _, setState in pairs(expRows) do setState(true) end
    end)

    local expDisableAllBtn = MakeBtn(expExclPanel, "Disable All", math.floor(WSID_SET_CW/2) - 3, 24)
    expDisableAllBtn:SetPoint(WSID_BOTTOMRIGHT, expExclPanel, WSID_BOTTOMRIGHT, -WSID_SET_PAD, WSID_SET_PAD)
    expDisableAllBtn:SetScript(WSID_OnClick, function()
        if not WhatShouldIDoDB.excludedExpansions then WhatShouldIDoDB.excludedExpansions = {} end
        for _, exp in ipairs(ORDER) do
            WhatShouldIDoDB.excludedExpansions[exp] = true
            if expRows[exp] then expRows[exp](false) end
        end
    end)

    --------------------------------------------------------------------
    -- UI SCALE PANEL
    --------------------------------------------------------------------

    local scaleHdr = MakeHeader(scalePanel, "UI Scale", WSID_SET_CW)
    scaleHdr:SetPoint(WSID_TOPLEFT, scalePanel, WSID_TOPLEFT, WSID_SET_PAD, -WSID_SET_PAD)

    local scaleDesc = scalePanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    scaleDesc:SetPoint(WSID_TOPLEFT, scaleHdr, WSID_BOTTOMLEFT, 4, -8)
    scaleDesc:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    scaleDesc:SetText("Scale the addon windows and all text. Changes apply instantly.")
    scaleDesc:SetWidth(WSID_SET_CW - 8)

    local scaleOptions = {
        {label="50%",  val=0.50}, {label="60%",  val=0.60}, {label="70%",  val=0.70},
        {label="80%",  val=0.80}, {label="90%",  val=0.90}, {label="100%", val=1.00},
        {label="110%", val=1.10}, {label="120%", val=1.20}, {label="130%", val=1.30},
        {label="140%", val=1.40}, {label="150%", val=1.50}, {label="160%", val=1.60},
        {label="170%", val=1.70}, {label="180%", val=1.80}, {label="190%", val=1.90},
        {label="200%", val=2.00},
    }

    local scaleLbl = scalePanel:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    scaleLbl:SetPoint(WSID_TOPLEFT, scaleDesc, WSID_BOTTOMLEFT, 0, -12)
    scaleLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    scaleLbl:SetText("Scale:")

    local scaleBox = CreateFrame(WSID_BUTTON, nil, scalePanel, WSID_BACKDROP_TEMPLATE)
    scaleBox:SetSize(100, 26)
    scaleBox:SetPoint(WSID_LEFT, scaleLbl, WSID_RIGHT, 8, 0)
    BgBorder(scaleBox, COLOR_TABLE.result_bg[1],COLOR_TABLE.result_bg[2],COLOR_TABLE.result_bg[3], COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3])
    local scaleBoxLbl = scaleBox:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
    scaleBoxLbl:SetPoint(WSID_LEFT, scaleBox, WSID_LEFT, 8, 0)
    scaleBoxLbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    local curScale = WhatShouldIDoDB.uiScale or 1.0
    scaleBoxLbl:SetText(string.format("%.0f%%", curScale * 100))

    local scaleDropdown = CreateFrame(WSID_FRAME, nil, scalePanel, WSID_BACKDROP_TEMPLATE)
    scaleDropdown:SetSize(100, #scaleOptions * 22)
    scaleDropdown:SetPoint(WSID_TOPLEFT, scaleBox, WSID_BOTTOMLEFT, 0, -2)
    scaleDropdown:SetFrameStrata("TOOLTIP")
    BgBorder(scaleDropdown, COLOR_TABLE.bg[1],COLOR_TABLE.bg[2],COLOR_TABLE.bg[3], COLOR_TABLE.win_border[1],COLOR_TABLE.win_border[2],COLOR_TABLE.win_border[3])
    scaleDropdown:Hide()

    local function ApplyScale(val, label)
        WhatShouldIDoDB.uiScale = val
        scaleBoxLbl:SetText(label)
        scaleDropdown:Hide()
        if MainFrame     then MainFrame:SetScale(val) end
        if SettingsFrame then SettingsFrame:SetScale(val) end
    end

    for i, opt in ipairs(scaleOptions) do
        local row = CreateFrame(WSID_BUTTON, nil, scaleDropdown)
        row:SetSize(100, 22)
        row:SetPoint(WSID_TOPLEFT, scaleDropdown, WSID_TOPLEFT, 0, -(i-1)*22)
        local rb = row:CreateTexture(nil,WSID_BACKGROUND)
        rb:SetAllPoints()
        local isEven = (i%2==0)
        rb:SetColorTexture(isEven and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                           isEven and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                           isEven and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)
        local rl = row:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
        rl:SetPoint(WSID_LEFT, row, WSID_LEFT, 10, 0)
        if opt.val == 1.0 then
            rl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        else
            rl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        end
        rl:SetText(opt.label)
        local ov, ol = opt.val, opt.label
        row:SetScript(WSID_OnClick,  function() ApplyScale(ov, ol) end)
        row:SetScript(WSID_OnEnter, function() rb:SetColorTexture(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1) end)
        row:SetScript(WSID_OnLeave, function()
            rb:SetColorTexture(isEven and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                               isEven and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                               isEven and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)
        end)
    end

    scaleBox:SetScript(WSID_OnClick, function()
        if scaleDropdown:IsShown() then scaleDropdown:Hide() else scaleDropdown:Show() end
    end)

    local scaleResetBtn = MakeBtn(scalePanel, "Reset to 100%", 120, 26)
    scaleResetBtn:SetPoint(WSID_TOPLEFT, scaleLbl, WSID_BOTTOMLEFT, 0, -14)
    scaleResetBtn:SetScript(WSID_OnClick, function()
        ApplyScale(1.0, "100%")
    end)

    --------------------------------------------------------------------
    -- CHANGELOG PANEL
    --------------------------------------------------------------------

    local clScrollBG, clScrollContent, _ = MakeScrollBox(changelogPanel, WSID_SET_CW, WSID_SET_H - 50)
    clScrollBG:SetPoint(WSID_TOPLEFT, changelogPanel, WSID_TOPLEFT, WSID_SET_PAD, -WSID_SET_PAD)

    local yOff = -6
    for _, block in ipairs(WSID_CHANGELOG) do
        -- Version header
        local vHdr = MakeHeader(clScrollContent, "v"..block.version, WSID_SET_CW - 4)
        vHdr:SetPoint(WSID_TOPLEFT, clScrollContent, WSID_TOPLEFT, 0, yOff)
        yOff = yOff - 34

        for _, entry in ipairs(block.entries) do
            local isNew = entry.type == "new"
            -- Tag label
            local tag = clScrollContent:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            tag:SetPoint(WSID_TOPLEFT, clScrollContent, WSID_TOPLEFT, 8, yOff)
            tag:SetText(isNew and "|cff44cc44[New]|r" or "|cffcc4444[Fix]|r")

            -- Entry text
            local txt = clScrollContent:CreateFontString(nil,WSID_OVERLAY,WSID_NORMAL_SMALL)
            txt:SetPoint(WSID_TOPLEFT, clScrollContent, WSID_TOPLEFT, 52, yOff)
            txt:SetPoint(WSID_RIGHT,   clScrollContent, WSID_RIGHT,  -8, 0)
            txt:SetJustifyH(WSID_LEFT)
            txt:SetWordWrap(true)
            txt:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
            txt:SetText(entry.text)

            -- Measure wrapped height (approx 14px per line, min 18)
            local lineCount = math.max(1, math.ceil(#entry.text / 72))
            yOff = yOff - (lineCount * 14) - 6
        end

        yOff = yOff - 10  -- gap between versions
    end

    clScrollContent:SetHeight(math.abs(yOff) + 20)

    f:SetScript(WSID_OnShow,function() SetNavActive("activities") end)
    SetNavActive("activities")
    return f
end

------------------------------------------------------------------------
-- MAIN WINDOW
------------------------------------------------------------------------


