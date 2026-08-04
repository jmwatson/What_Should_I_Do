-- Settings/Settings.lua
-- Settings window and all tabs
-- Author: I_AM_T3X | v1.0.0

SettingsFrame = nil
WSID_refreshActivities = nil
WSID_refreshRoster = nil
WSID_WSID_refreshActivities = nil
WSID_WSID_refreshRoster = nil

WSID["BuildSettingsWindow"] = function()
    local f = CreateFrame(WSID.FRAME,"WhatShouldIDoSettings",UIParent,WSID.BACKDROP_TEMPLATE)
    f:SetSize(WSID.SET_W, WSID.SET_H)
    f:SetPoint(WSID.CENTER,UIParent,WSID.CENTER,280,0)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag(WSID.LEFT_BUTTON)
    f:SetScript(WSID.OnDragStart,f.StartMoving)
    f:SetScript(WSID.OnDragStop,f.StopMovingOrSizing)
    f:SetFrameStrata(WSID.DIALOG)
    f:SetFrameLevel(20)
    f:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})
    f:SetBackdropColor(COLOR_TABLE.bg[1],COLOR_TABLE.bg[2],COLOR_TABLE.bg[3],1)
    f:SetBackdropBorderColor(COLOR_TABLE.win_border[1],COLOR_TABLE.win_border[2],COLOR_TABLE.win_border[3],1)
    f:Hide()

    -- Title bar
    local tb=CreateFrame(WSID.FRAME,nil,f)
    tb:SetHeight(30)
    tb:SetPoint(WSID.TOPLEFT,f,WSID.TOPLEFT,0,0)
    tb:SetPoint(WSID.TOPRIGHT,f,WSID.TOPRIGHT,0,0)
    Tx(tb,COLOR_TABLE.sidebar[1],COLOR_TABLE.sidebar[2],COLOR_TABLE.sidebar[3])
    local tbBord=tb:CreateTexture(nil,WSID.ARTWORK)
    tbBord:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    tbBord:SetHeight(1)
    tbBord:SetPoint(WSID.BOTTOMLEFT,tb,WSID.BOTTOMLEFT,0,0)
    tbBord:SetPoint(WSID.BOTTOMRIGHT,tb,WSID.BOTTOMRIGHT,0,0)
    local tbLbl=tb:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL)
    tbLbl:SetPoint(WSID.LEFT,tb,WSID.LEFT,10,0)
    tbLbl:SetText("What Should I Do?  --  Settings")
    tbLbl:SetTextColor(COLOR_TABLE.header_txt[1],COLOR_TABLE.header_txt[2],COLOR_TABLE.header_txt[3])
    local closeBtn=CreateFrame(WSID.BUTTON,nil,f,WSID.UI_PANEL_CLOSE_BUTTON)
    closeBtn:SetPoint(WSID.TOPRIGHT,f,WSID.TOPRIGHT,-2,-2)
    closeBtn:SetFrameStrata(f:GetFrameStrata())
    closeBtn:SetFrameLevel(f:GetFrameLevel() + 1)

    -- Left nav
    local navBg=CreateFrame(WSID.FRAME,nil,f)
    navBg:SetPoint(WSID.TOPLEFT,f,WSID.TOPLEFT,0,-30)
    navBg:SetPoint(WSID.BOTTOMLEFT,f,WSID.BOTTOMLEFT,0,0)
    navBg:SetWidth(WSID.SET_NAV)
    Tx(navBg,COLOR_TABLE.sidebar[1],COLOR_TABLE.sidebar[2],COLOR_TABLE.sidebar[3])
    local nd=navBg:CreateTexture(nil,WSID.ARTWORK)
    nd:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    nd:SetWidth(1)
    nd:SetPoint(WSID.TOPRIGHT,navBg,WSID.TOPRIGHT,0,0)
    nd:SetPoint(WSID.BOTTOMRIGHT,navBg,WSID.BOTTOMRIGHT,0,0)

    local content=CreateFrame(WSID.FRAME,nil,f)
    content:SetPoint(WSID.TOPLEFT,f,WSID.TOPLEFT,WSID.SET_NAV,-30)
    content:SetPoint(WSID.BOTTOMRIGHT,f,WSID.BOTTOMRIGHT,0,0)

    local actPanel=CreateFrame(WSID.FRAME,nil,content)
    actPanel:SetAllPoints(content)
    actPanel:Hide()
    local rostPanel=CreateFrame(WSID.FRAME,nil,content)
    rostPanel:SetAllPoints(content)
    rostPanel:Hide()
    local ioPanel=CreateFrame(WSID.FRAME,nil,content)
    ioPanel:SetAllPoints(content)
    ioPanel:Hide()
    local colorsPanel=CreateFrame(WSID.FRAME,nil,content)
    colorsPanel:SetAllPoints(content)
    colorsPanel:Hide()
    local scalePanel=CreateFrame(WSID.FRAME,nil,content)
    scalePanel:SetAllPoints(content)
    scalePanel:Hide()
    local expExclPanel=CreateFrame(WSID.FRAME,nil,content)
    expExclPanel:SetAllPoints(content)
    expExclPanel:Hide()
    local changelogPanel=CreateFrame(WSID.FRAME,nil,content)
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
        local row=CreateFrame(WSID.BUTTON,nil,navBg)
        row:SetSize(WSID.SET_NAV,36)
        row:SetPoint(WSID.TOPLEFT,navBg,WSID.TOPLEFT,0,-(i-1)*36)
        local bg=row:CreateTexture(nil,WSID.BACKGROUND)
        bg:SetAllPoints()
        bg:SetColorTexture(0,0,0,0)
        local stripe=row:CreateTexture(nil,WSID.ARTWORK)
        stripe:SetColorTexture(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
        stripe:SetSize(3,36)
        stripe:SetPoint(WSID.LEFT,row,WSID.LEFT,0,0)
        stripe:Hide()
        local lbl=row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        lbl:SetPoint(WSID.LEFT,row,WSID.LEFT,12,0)
        lbl:SetText(def.label)
        lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        local name=def.name
        row:SetScript(WSID.OnClick,function() SetNavActive(name) end)
        row:SetScript(WSID.OnEnter,function()
            if navActive~=name then
                bg:SetColorTexture(COLOR_TABLE.nav_hover[1],COLOR_TABLE.nav_hover[2],COLOR_TABLE.nav_hover[3],1)
                lbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
            end
        end)
        row:SetScript(WSID.OnLeave,function()
            if navActive~=name then
                bg:SetColorTexture(0,0,0,0)
                lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
            end
        end)
        navBtns[def.name]={bg=bg,stripe=stripe,lbl=lbl}
    end

    -- Reset window size button at bottom of nav
    -- Changelog button above separator
    local clNavBtn = CreateFrame(WSID.BUTTON, nil, navBg)
    clNavBtn:SetSize(WSID.SET_NAV, 36)
    clNavBtn:SetPoint(WSID.BOTTOMLEFT, navBg, WSID.BOTTOMLEFT, 0, 36)
    local clNavBg = clNavBtn:CreateTexture(nil,WSID.BACKGROUND)
    clNavBg:SetAllPoints()
    clNavBg:SetColorTexture(0,0,0,0)
    local clNavStripe = clNavBtn:CreateTexture(nil,WSID.ARTWORK)
    clNavStripe:SetColorTexture(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
    clNavStripe:SetSize(3,36)
    clNavStripe:SetPoint(WSID.LEFT,clNavBtn,WSID.LEFT,0,0)
    clNavStripe:Hide()
    local clNavLbl = clNavBtn:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    clNavLbl:SetPoint(WSID.LEFT,clNavBtn,WSID.LEFT,12,0)
    clNavLbl:SetText("Changelog")
    clNavLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    clNavBtn:SetScript(WSID.OnClick, function() SetNavActive("changelog") end)
    clNavBtn:SetScript(WSID.OnEnter, function()
        if navActive~="changelog" then
            clNavBg:SetColorTexture(COLOR_TABLE.nav_hover[1],COLOR_TABLE.nav_hover[2],COLOR_TABLE.nav_hover[3],1)
            clNavLbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        end
    end)
    clNavBtn:SetScript(WSID.OnLeave, function()
        if navActive~="changelog" then
            clNavBg:SetColorTexture(0,0,0,0)
            clNavLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        end
    end)
    navBtns["changelog"] = {bg=clNavBg, stripe=clNavStripe, lbl=clNavLbl}

    local resetSizeRule = navBg:CreateTexture(nil,WSID.ARTWORK)
    resetSizeRule:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    resetSizeRule:SetHeight(1)
    resetSizeRule:SetPoint(WSID.BOTTOMLEFT,  navBg, WSID.BOTTOMLEFT,  0, 72)
    resetSizeRule:SetPoint(WSID.BOTTOMRIGHT, navBg, WSID.BOTTOMRIGHT, 0, 72)

    local resetSizeBtn = CreateFrame(WSID.BUTTON, nil, navBg)
    resetSizeBtn:SetSize(WSID.SET_NAV, 36)
    resetSizeBtn:SetPoint(WSID.BOTTOMLEFT, navBg, WSID.BOTTOMLEFT, 0, 0)
    local rsBg = resetSizeBtn:CreateTexture(nil,WSID.BACKGROUND)
    rsBg:SetAllPoints()
    rsBg:SetColorTexture(0,0,0,0)
    local rsLbl = resetSizeBtn:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    rsLbl:SetPoint(WSID.LEFT, resetSizeBtn, WSID.LEFT, 12, 0)
    rsLbl:SetText("Reset Size")
    rsLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    resetSizeBtn:SetScript(WSID.OnEnter, function()
        rsBg:SetColorTexture(COLOR_TABLE.nav_hover[1],COLOR_TABLE.nav_hover[2],COLOR_TABLE.nav_hover[3],1)
        rsLbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    end)
    resetSizeBtn:SetScript(WSID.OnLeave, function()
        rsBg:SetColorTexture(0,0,0,0)
        rsLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    end)
    resetSizeBtn:SetScript(WSID.OnClick, function()
        WhatShouldIDoDB.uiScale = 1.0
        WhatShouldIDoDB.uiScale = 1.0
        if MainFrame     then MainFrame:SetScale(1.0) end
        if SettingsFrame then SettingsFrame:SetScale(1.0) end
        UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r UI scale reset to 100%%.", 1, 0.85, 0.2)
    end)

    --------------------------------------------------------------------
    -- ACTIVITIES PANEL: two columns
    --------------------------------------------------------------------
    -- Column layout: WSID.PAD(12) | COL(277) | gap(12) | COL(277) | WSID.PAD(12) = 590 = WSID.SET_CW ok
    -- Row heights: hdr(28) + scroll(280) + gap(10) + addRow(26) + gap(8) + resetBtn(26) = 378 < (500-30-12) = 458 ok

    local SCRL_H = 280  -- scroll list height
    local BTN_H  = 26
    local GAP    = 10

    -- Left column: Categories
    local catHdr = MakeHeader(actPanel, "Categories", WSID.SET_COL)
    catHdr:SetPoint(WSID.TOPLEFT, actPanel, WSID.TOPLEFT, WSID.SET_PAD, -WSID.SET_PAD)

    local catCount=actPanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    catCount:SetPoint(WSID.RIGHT,catHdr,WSID.RIGHT,-6,0)
    catCount:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])

    local catBG,catContent,catReset=MakeScrollBox(actPanel,WSID.SET_COL,SCRL_H)
    catBG:SetPoint(WSID.TOPLEFT,catHdr,WSID.BOTTOMLEFT,0,-4)

    local catAddBtn=MakeBtn(actPanel,"Add",54,BTN_H)
    catAddBtn:SetPoint(WSID.TOPRIGHT,catBG,WSID.BOTTOMRIGHT,0,-GAP)

    local catAddBox=CreateFrame(WSID.EDIT_BOX,nil,actPanel,WSID.BACKDROP_TEMPLATE)
    catAddBox:SetHeight(BTN_H)
    catAddBox:SetPoint(WSID.TOPLEFT,catBG,WSID.BOTTOMLEFT,0,-GAP)
    catAddBox:SetPoint(WSID.TOPRIGHT,catAddBtn,WSID.TOPLEFT,-6,0)
    catAddBox:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})
    catAddBox:SetBackdropColor(0.04,0.03,0.08,1)
    catAddBox:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    catAddBox:SetFont(WSID.GAME_FONT,11,WSID.EMPTY_STRING)
    catAddBox:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    catAddBox:SetTextInsets(6,6,2,2)
    catAddBox:SetAutoFocus(false)
    catAddBox:SetMaxLetters(64)
    catAddBox:SetScript(WSID.OnEditFocusGained,function(s) s:SetBackdropBorderColor(COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3],1) end)
    catAddBox:SetScript(WSID.OnEditFocusLost,  function(s) s:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1) end)

    local catResetBtn=MakeBtn(actPanel,"Reset All Defaults",WSID.SET_COL,BTN_H)
    catResetBtn:SetPoint(WSID.TOPLEFT,catBG,WSID.BOTTOMLEFT,0,-(GAP+BTN_H+28))

    -- Right column: Sub-Activities
    local subHdr=MakeHeader(actPanel,"Sub-Activities",WSID.SET_COL)
    subHdr:SetPoint(WSID.TOPLEFT,catHdr,WSID.TOPRIGHT,12,0)

    local subCount=actPanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    subCount:SetPoint(WSID.RIGHT,subHdr,WSID.RIGHT,-6,0)
    subCount:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])

    local subSelLbl=actPanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    subSelLbl:SetPoint(WSID.TOPLEFT,subHdr,WSID.BOTTOMLEFT,4,-4)
    subSelLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    subSelLbl:SetText("(click a category to edit its sub-activities)")
    subSelLbl:SetWidth(WSID.SET_COL)

    -- Sub scroll must align vertically with cat scroll despite the extra label line
    -- Anchor subBG to subHdr bottom + fixed 28px (label height) to keep tops aligned
    local subBG,subContent,subReset=MakeScrollBox(actPanel,WSID.SET_COL,SCRL_H)
    subBG:SetPoint(WSID.TOPLEFT,subHdr,WSID.BOTTOMLEFT,0,-28)

    local subAddBtn=MakeBtn(actPanel,"Add",54,BTN_H)
    subAddBtn:SetPoint(WSID.TOPRIGHT,subBG,WSID.BOTTOMRIGHT,0,-GAP)
    subAddBtn:SetEnabled(false)

    local subAddBox=CreateFrame(WSID.EDIT_BOX,nil,actPanel,WSID.BACKDROP_TEMPLATE)
    subAddBox:SetHeight(BTN_H)
    subAddBox:SetPoint(WSID.TOPLEFT,subBG,WSID.BOTTOMLEFT,0,-GAP)
    subAddBox:SetPoint(WSID.TOPRIGHT,subAddBtn,WSID.TOPLEFT,-6,0)
    subAddBox:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})
    subAddBox:SetBackdropColor(0.04,0.03,0.08,1)
    subAddBox:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    subAddBox:SetFont(WSID.GAME_FONT,11,WSID.EMPTY_STRING)
    subAddBox:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    subAddBox:SetTextInsets(6,6,2,2)
    subAddBox:SetAutoFocus(false)
    subAddBox:SetMaxLetters(64)
    subAddBox:SetScript(WSID.OnEditFocusGained,function(s) s:SetBackdropBorderColor(COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3],1) end)
    subAddBox:SetScript(WSID.OnEditFocusLost,  function(s) s:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1) end)

    -- State
    local selectedCat=nil
    local catRows={}
    local subRows={}
    local catRowBgs={}

    local function RefreshSubList()
        for _,r in ipairs(subRows) do r:Hide() end
        subRows={}
        if not selectedCat then
            subCount:SetText(WSID.EMPTY_STRING)
            subAddBtn:SetEnabled(false)
            return
        end
        -- if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities={} end
        if not WhatShouldIDoDB.excludedSubActivities then WhatShouldIDoDB.excludedSubActivities = {} end
        local subs = WSID.GetSubActivities()
        subCount:SetText("["..#subs.."]")
        subAddBtn:SetEnabled(true)
        for i,sub in ipairs(subs) do
            local even=(i%2==0)
            local row=CreateFrame(WSID.FRAME,nil,subContent)
            row:SetSize(WSID.SET_COL-2,22)
            row:SetPoint(WSID.TOPLEFT,subContent,WSID.TOPLEFT,0,-(i-1)*22)
            local rb=row:CreateTexture(nil,WSID.BACKGROUND)
            rb:SetAllPoints()
            rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
            local fs=row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            fs:SetPoint(WSID.LEFT,row,WSID.LEFT,6,0)
            fs:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
            fs:SetJustifyH(WSID.LEFT)
            fs:SetText(sub)
            fs:SetWidth(WSID.SET_COL-28)
            local xBtn=CreateFrame(WSID.BUTTON,nil,row)
            xBtn:SetSize(20,22)
            xBtn:SetPoint(WSID.RIGHT,row,WSID.RIGHT,0,0)
            local xL=xBtn:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            xL:SetAllPoints()
            xL:SetJustifyH(WSID.CENTER)
            xL:SetText("|cffcc3333x|r")
            local idx=i
            xBtn:SetScript(WSID.OnClick,function()
                table.remove(WhatShouldIDoDB.subActivities[selectedCat],idx)
                RefreshSubList()
            end)
            xBtn:SetScript(WSID.OnEnter,function() xL:SetText("|cffff5555x|r") end)
            xBtn:SetScript(WSID.OnLeave,function() xL:SetText("|cffcc3333x|r") end)
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
        subCount:SetText(WSID.EMPTY_STRING)
        subAddBtn:SetEnabled(false)
        local acts=WhatShouldIDoDB.activities
        catCount:SetText("["..#acts.."]")
        for i,act in ipairs(acts) do
            local even=(i%2==0)
            local row=CreateFrame(WSID.BUTTON,nil,catContent)
            row:SetSize(WSID.SET_COL-2,22)
            row:SetPoint(WSID.TOPLEFT,catContent,WSID.TOPLEFT,0,-(i-1)*22)
            local rb=row:CreateTexture(nil,WSID.BACKGROUND)
            rb:SetAllPoints()
            rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
            table.insert(catRowBgs,rb)
            local nl=row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            nl:SetPoint(WSID.LEFT,row,WSID.LEFT,6,0)
            nl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
            nl:SetJustifyH(WSID.LEFT)
            nl:SetText(act)
            nl:SetWidth(WSID.SET_COL-28)
            local xBtn=CreateFrame(WSID.BUTTON,nil,row)
            xBtn:SetSize(20,22)
            xBtn:SetPoint(WSID.RIGHT,row,WSID.RIGHT,0,0)
            local xL=xBtn:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            xL:SetAllPoints()
            xL:SetJustifyH(WSID.CENTER)
            xL:SetText("|cffcc3333x|r")
            local idx=i
            xBtn:SetScript(WSID.OnClick,function()
                if selectedCat==WhatShouldIDoDB.activities[idx] then
                    selectedCat=nil
                    subSelLbl:SetText("(click a category to edit its sub-activities)")
                    subSelLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
                    for _,r in ipairs(subRows) do r:Hide() end
                    subRows={}
                    subCount:SetText(WSID.EMPTY_STRING)
                    subAddBtn:SetEnabled(false)
                end
                table.remove(WhatShouldIDoDB.activities,idx)
                WSID_refreshActivities()
            end)
            xBtn:SetScript(WSID.OnEnter,function() xL:SetText("|cffff5555x|r") end)
            xBtn:SetScript(WSID.OnLeave,function() xL:SetText("|cffcc3333x|r") end)
            local actName=act
            row:SetScript(WSID.OnClick,function() SelectCat(actName,rb) end)
            row:SetScript(WSID.OnEnter,function() if selectedCat~=actName then rb:SetColorTexture(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1) end end)
            row:SetScript(WSID.OnLeave,function()
                if selectedCat~=actName then rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1) end end)
            table.insert(catRows,row)
        end
        catContent:SetHeight(math.max(22,#acts*22+2))
        catReset()
    end

    local function DoCatAdd()
        local txt=strtrim(catAddBox:GetText())
        if txt~=WSID.EMPTY_STRING then
            table.insert(WhatShouldIDoDB.activities,txt)
            catAddBox:SetText(WSID.EMPTY_STRING)
            WSID_refreshActivities()
        end
    end
    catAddBtn:SetScript(WSID.OnClick,DoCatAdd)
    catAddBox:SetScript(WSID.OnEnterPressed,DoCatAdd)

    local function DoSubAdd()
        if selectedCat then
            local txt=strtrim(subAddBox:GetText())
            if txt~=WSID.EMPTY_STRING then
                if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities={} end
                if not WhatShouldIDoDB.subActivities[selectedCat] then WhatShouldIDoDB.subActivities[selectedCat]={} end
                table.insert(WhatShouldIDoDB.subActivities[selectedCat],txt)
                subAddBox:SetText(WSID.EMPTY_STRING)
                RefreshSubList()
            end
        end
        local txt=strtrim(subAddBox:GetText())
        if txt~=WSID.EMPTY_STRING then
            if not WhatShouldIDoDB.subActivities then WhatShouldIDoDB.subActivities={} end
            if not WhatShouldIDoDB.subActivities[selectedCat] then WhatShouldIDoDB.subActivities[selectedCat]={} end
            table.insert(WhatShouldIDoDB.subActivities[selectedCat],txt)
            subAddBox:SetText(WSID.EMPTY_STRING)
            RefreshSubList()
        end
    end

    subAddBtn:SetScript(WSID.OnClick,DoSubAdd)
    subAddBox:SetScript(WSID.OnEnterPressed,DoSubAdd)

    catResetBtn:SetScript(WSID.OnClick,function()
        WhatShouldIDoDB.activities={}
        for activity, _ in ipairs(WSID_ACTIVITIES_INFO) do table.insert(WhatShouldIDoDB.activities,activity) end
        WhatShouldIDoDB.subActivities={}
        WSID_refreshActivities()
    end)

    --------------------------------------------------------------------
    -- ROSTER PANEL
    --------------------------------------------------------------------

    local rostHdr=MakeHeader(rostPanel,"Seen Characters",WSID.SET_CW)
    rostHdr:SetPoint(WSID.TOPLEFT,rostPanel,WSID.TOPLEFT,WSID.SET_PAD,-WSID.SET_PAD)
    local rostCount=rostPanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    rostCount:SetPoint(WSID.RIGHT,rostHdr,WSID.RIGHT,-6,0)
    rostCount:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    local rostNote=rostPanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    rostNote:SetPoint(WSID.TOPLEFT,rostHdr,WSID.BOTTOMLEFT,4,-6)
    rostNote:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    rostNote:SetText("Log into each alt to add it. Levels update on every login.")
    rostNote:SetWidth(WSID.SET_CW)

    local rostBG,rostContent,rostReset=MakeScrollBox(rostPanel,WSID.SET_CW,WSID.SET_H-30-WSID.SET_PAD*2-80)
    rostBG:SetPoint(WSID.TOPLEFT,rostNote,WSID.BOTTOMLEFT,0,-8)

    local rostRows={}
    WSID_refreshRoster=function()
        for _,r in ipairs(rostRows) do r:Hide() end
        rostRows={}
        local chars=WhatShouldIDoDB.seenChars
        rostCount:SetText("["..#chars.."]")
        if not WhatShouldIDoDB.excludedChars then WhatShouldIDoDB.excludedChars = {} end
        for i,ch in ipairs(chars) do
            local even=(i%2==0)
            local row=CreateFrame(WSID.FRAME,nil,rostContent)
            row:SetSize(WSID.SET_CW-2,24)
            row:SetPoint(WSID.TOPLEFT,rostContent,WSID.TOPLEFT,0,-(i-1)*24)
            local rb=row:CreateTexture(nil,WSID.BACKGROUND)
            rb:SetAllPoints()
            rb:SetColorTexture(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3],1)
            local cc=WSID_CLASS_INFO[ch.class] or {r=0.8,g=0.8,b=0.8}
            local isExcluded = WhatShouldIDoDB.excludedChars[ch.name] == true
            local fs=row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            fs:SetPoint(WSID.LEFT,row,WSID.LEFT,10,0)
            fs:SetJustifyH(WSID.LEFT)
            fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s %s|r  |cffffcc00Lv %d|r%s",
                isExcluded and 80 or cc.r*255,
                isExcluded and 80 or cc.g*255,
                isExcluded and 80 or cc.b*255,
                ch.name, ch.race or WSID.EMPTY_STRING, ch.class or WSID.EMPTY_STRING, ch.level or 0,
                isExcluded and "  |cff888888[excluded]|r" or WSID.EMPTY_STRING))
            local isCurrent=(ch.name==UnitName(WSID.IDENTITY))
            -- Exclude toggle button (all chars including current)
            local exBtn=CreateFrame(WSID.BUTTON,nil,row,WSID.BACKDROP_TEMPLATE)
            exBtn:SetSize(58,18)
            exBtn:SetPoint(WSID.RIGHT,row,WSID.RIGHT, isCurrent and -4 or -26, 0)
            exBtn:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})
            local function UpdateExBtn()
                local ex = WhatShouldIDoDB.excludedChars[ch.name] == true
                exBtn:SetBackdropColor(ex and 0.25 or 0.08, ex and 0.08 or 0.18, ex and 0.08 or 0.08)
                exBtn:SetBackdropBorderColor(ex and 0.6 or 0.3, ex and 0.2 or 0.3, ex and 0.2 or 0.3, 1)
                local exL = exBtn._lbl
                if exL then exL:SetText(ex and "|cffff6666Excluded|r" or "|cff888888Exclude|r") end
            end
            local exL=exBtn:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            exL:SetAllPoints()
            exL:SetJustifyH(WSID.CENTER)
            exBtn._lbl = exL
            UpdateExBtn()
            local cn=ch.name
            exBtn:SetScript(WSID.OnClick,function()
                if WhatShouldIDoDB.excludedChars[cn] then
                    WhatShouldIDoDB.excludedChars[cn] = nil
                else
                    WhatShouldIDoDB.excludedChars[cn] = true
                end
                WSID_refreshRoster()
            end)
            if isCurrent then
                local yl=row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
                yl:SetPoint(WSID.RIGHT,exBtn,WSID.LEFT,-4,0)
                yl:SetTextColor(0.30,0.75,0.30)
                yl:SetText("(you)")
            else
                local xBtn=CreateFrame(WSID.BUTTON,nil,row)
                xBtn:SetSize(20,24)
                xBtn:SetPoint(WSID.RIGHT,row,WSID.RIGHT,0,0)
                local xL2=xBtn:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
                xL2:SetAllPoints()
                xL2:SetJustifyH(WSID.CENTER)
                xL2:SetText("|cffcc3333x|r")
                xBtn:SetScript(WSID.OnClick,function()
                    RemoveCharFromRoster(cn)
                    WSID_refreshRoster()
                end)
                xBtn:SetScript(WSID.OnEnter,function() xL2:SetText("|cffff5555x|r") end)
                xBtn:SetScript(WSID.OnLeave,function() xL2:SetText("|cffcc3333x|r") end)
            end
            table.insert(rostRows,row)
        end
        rostContent:SetHeight(math.max(24,#chars*24+2))
        rostReset()
    end

    local clearBtn=MakeBtn(rostPanel,"Clear All Others",WSID.SET_CW,BTN_H)
    clearBtn:SetPoint(WSID.TOPLEFT,rostBG,WSID.BOTTOMLEFT,0,-10)
    clearBtn:SetScript(WSID.OnClick,function()
        local cur=UnitName(WSID.IDENTITY)
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

    local ioNoteBg = ioPanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    ioNoteBg:SetPoint(WSID.TOPLEFT, ioPanel, WSID.TOPLEFT, WSID.SET_PAD, -WSID.SET_PAD)
    ioNoteBg:SetPoint(WSID.RIGHT,   ioPanel, WSID.RIGHT,  -WSID.SET_PAD, 0)
    ioNoteBg:SetJustifyH(WSID.LEFT)
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
    local expHdr = MakeHeader(ioPanel, "Export Roster", WSID.SET_CW)
    expHdr:SetPoint(WSID.TOPLEFT, ioNoteBg, WSID.BOTTOMLEFT, -4, -10)

    local expBoxBg = CreateFrame(WSID.FRAME, nil, ioPanel, WSID.BACKDROP_TEMPLATE)
    expBoxBg:SetSize(WSID.SET_CW, 54)
    expBoxBg:SetPoint(WSID.TOPLEFT, expHdr, WSID.BOTTOMLEFT, 0, -6)
    expBoxBg:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})
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
    expScroll:SetPoint(WSID.TOPLEFT,     expBoxBg, WSID.TOPLEFT,     4,  -4)
    expScroll:SetPoint(WSID.BOTTOMRIGHT, expBoxBg, WSID.BOTTOMRIGHT, -24,  4)

    local expBox = CreateFrame(WSID.EDIT_BOX, "WhatShouldIDoExportBox", expScroll, "InputBoxTemplate")
    expBox:SetWidth(expScroll:GetWidth() or (WSID.SET_CW - 28))
    expBox:SetHeight(54)
    expBox:SetFontObject(GameFontNormalSmall)
    expBox:SetTextColor(0.85, 0.85, 0.85)
    expBox:SetMultiLine(true)
    expBox:SetAutoFocus(false)
    expBox:SetMaxLetters(0)
    expBox:SetText("-- click Export to generate --")
    expBox._last = WSID.EMPTY_STRING
    expScroll:SetScrollChild(expBox)
    -- Hide InputBoxTemplate border textures
    if expBox.Left   then expBox.Left:SetAlpha(0) end
    if expBox.Middle then expBox.Middle:SetAlpha(0) end
    if expBox.Right  then expBox.Right:SetAlpha(0) end
    -- Sync scroll when text changes
    expBox:SetScript(WSID.OnTextChanged, function(self)
        expScroll:UpdateScrollChildRect()
    end)
    -- Block typing but allow select/copy
    expBox:SetScript(WSID.OnChar,            function(s) s:SetText(s._last or WSID.EMPTY_STRING) end)
    expBox:SetScript(WSID.OnEscapePressed,   function(s) s:ClearFocus() end)
    expBox:SetScript(WSID.OnEnterPressed,    function(s) s:ClearFocus() end)
    expBox:SetScript(WSID.OnEditFocusGained, function(s) s:HighlightText() end)

    local expGenBtn = MakeBtn(ioPanel, "Export", WSID.SET_CW, 24)
    expGenBtn:SetPoint(WSID.TOPLEFT, expBoxBg, WSID.BOTTOMLEFT, 0, -4)

    expGenBtn:SetScript(WSID.OnClick, function()
        local str = BuildExportStr()
        if not str then
            expBox._last = WSID.EMPTY_STRING
            expBox:SetText("No characters in roster.")
            return
        end
        local encoded = EncodeStr(str)
        expBox._last = encoded
        expBox:SetText(encoded)
        expBox:SetFocus()
    end)

    local ioRule = ioPanel:CreateTexture(nil,WSID.ARTWORK)
    ioRule:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    ioRule:SetHeight(1)
    ioRule:SetPoint(WSID.TOPLEFT,  expGenBtn, WSID.BOTTOMLEFT,  0, -10)
    ioRule:SetPoint(WSID.TOPRIGHT, expGenBtn, WSID.BOTTOMRIGHT, 0, -10)

    -- IMPORT
    local impHdr = MakeHeader(ioPanel, "Import Roster", WSID.SET_CW)
    impHdr:SetPoint(WSID.TOPLEFT, ioRule, WSID.BOTTOMLEFT, 0, -8)

    local impBoxBg = CreateFrame(WSID.FRAME, nil, ioPanel, WSID.BACKDROP_TEMPLATE)
    impBoxBg:SetSize(WSID.SET_CW, 26)
    impBoxBg:SetPoint(WSID.TOPLEFT, impHdr, WSID.BOTTOMLEFT, 0, -6)
    impBoxBg:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})
    impBoxBg:SetBackdropColor(0.03,0.02,0.06,1)
    impBoxBg:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)

    local impBox = CreateFrame(WSID.EDIT_BOX, "WhatShouldIDoImportBox", impBoxBg)
    impBox:SetPoint(WSID.TOPLEFT,     impBoxBg, WSID.TOPLEFT,     6, -4)
    impBox:SetPoint(WSID.BOTTOMRIGHT, impBoxBg, WSID.BOTTOMRIGHT, -6,  4)
    impBox:SetFontObject(ChatFontNormal)
    impBox:SetTextColor(1, 1, 1)
    impBox:SetAutoFocus(false)
    impBox:SetScript(WSID.OnEscapePressed, function(s) s:ClearFocus() end)
    impBox:SetScript(WSID.OnEditFocusGained, function()
        impBoxBg:SetBackdropBorderColor(COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3],1)
    end)
    impBox:SetScript(WSID.OnEditFocusLost, function()
        impBoxBg:SetBackdropBorderColor(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    end)

    local impBtn = MakeBtn(ioPanel, "Import Roster", WSID.SET_CW, 24)
    impBtn:SetPoint(WSID.TOPLEFT, impBoxBg, WSID.BOTTOMLEFT, 0, -4)

    local impStatus = ioPanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    impStatus:SetPoint(WSID.TOPLEFT, impBtn, WSID.BOTTOMLEFT, 4, -6)
    impStatus:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    impStatus:SetText(" ")
    impStatus:SetWidth(WSID.SET_CW)

    WSID_DoImport = function(importStr)
        importStr = strtrim(importStr or WSID.EMPTY_STRING)
        if importStr == WSID.EMPTY_STRING then
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
            if name and name ~= WSID.EMPTY_STRING then
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
        impBox:SetText(WSID.EMPTY_STRING)
        impStatus:SetTextColor(0.3,0.8,0.3)
        impStatus:SetText(string.format("Done! %d added, %d levels updated, %d excluded.", imported, updated, excluded))
    end

    impBtn:SetScript(WSID.OnClick, function()
        WSID_DoImport(impBox:GetText())
    end)
    impBox:SetScript(WSID.OnEnterPressed, function(s)
        WSID_DoImport(s:GetText())
        s:ClearFocus()
    end)

    --------------------------------------------------------------------
    -- COLORS PANEL
    --------------------------------------------------------------------

    local colScrollBG, colScrollContent, _ = MakeScrollBox(colorsPanel, WSID.SET_CW, WSID.SET_H - 30 - WSID.SET_PAD * 2)
    colScrollBG:SetPoint(WSID.TOPLEFT, colorsPanel, WSID.TOPLEFT, WSID.SET_PAD, -WSID.SET_PAD)

    -- COLOR THEME
    local colHdr = MakeHeader(colScrollContent, "Color Theme", WSID.SET_CW - 4)
    colHdr:SetPoint(WSID.TOPLEFT, colScrollContent, WSID.TOPLEFT, 0, -4)

    local colDesc = colScrollContent:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    colDesc:SetPoint(WSID.TOPLEFT, colHdr, WSID.BOTTOMLEFT, 4, -6)
    colDesc:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    colDesc:SetText("Select a theme. A UI reload is required to fully apply the new colors.")
    colDesc:SetWidth(WSID.SET_CW - 8)

    local themeSep = colScrollContent:CreateTexture(nil,WSID.ARTWORK)
    themeSep:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    themeSep:SetHeight(1)
    themeSep:SetPoint(WSID.TOPLEFT,  colDesc, WSID.BOTTOMLEFT,  0, -10)
    themeSep:SetPoint(WSID.TOPRIGHT, colDesc, WSID.BOTTOMRIGHT, 0, -10)

    local themeHdr = colScrollContent:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    themeHdr:SetPoint(WSID.TOPLEFT, themeSep, WSID.BOTTOMLEFT, 0, -8)
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
        local row = CreateFrame(WSID.FRAME, nil, colScrollContent)
        row:SetSize(WSID.SET_CW - 4, 28)
        row:SetPoint(WSID.TOPLEFT, prevRow, WSID.BOTTOMLEFT, 0, -6)

        local btn = MakeBtn(row, td.label, 140, 26)
        btn:SetPoint(WSID.TOPLEFT, row, WSID.TOPLEFT, 0, 0)
        local tname = td.name
        local tlabel = td.label
        btn._theme = tname
        btn:SetScript(WSID.OnClick, function()
            ConfirmAndReload(tname, tlabel)
        end)
        table.insert(themeBtns, btn)

        local dlbl = row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        dlbl:SetPoint(WSID.LEFT, btn, WSID.RIGHT, 10, 0)
        dlbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        dlbl:SetText(td.desc)
        prevRow = row
    end

    UpdateThemeBtns()

    -- Custom section
    local customSep = colScrollContent:CreateTexture(nil,WSID.ARTWORK)
    customSep:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    customSep:SetHeight(1)
    customSep:SetPoint(WSID.TOPLEFT,  prevRow, WSID.BOTTOMLEFT,  0, -12)
    customSep:SetPoint(WSID.TOPRIGHT, prevRow, WSID.BOTTOMRIGHT, 0, -12)

    local customHdr = colScrollContent:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    customHdr:SetPoint(WSID.TOPLEFT, customSep, WSID.BOTTOMLEFT, 0, -8)
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
        local row = CreateFrame(WSID.FRAME, nil, colScrollContent)
        row:SetSize(WSID.SET_CW - 4, 26)
        row:SetPoint(WSID.TOPLEFT, prevCustom, WSID.BOTTOMLEFT, 0, -6)

        local swatch = CreateFrame(WSID.BUTTON, nil, row, WSID.BACKDROP_TEMPLATE)
        swatch:SetSize(22, 22)
        swatch:SetPoint(WSID.TOPLEFT, row, WSID.TOPLEFT, 0, -2)
        swatch:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})
        local cv = COLOR_TABLE[ck.key]
        swatch:SetBackdropColor(cv[1],cv[2],cv[3],1)
        swatch:SetBackdropBorderColor(0.4,0.4,0.4,1)
        table.insert(swatchRefs, {swatch=swatch, key=ck.key})

        local rlbl = row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        rlbl:SetPoint(WSID.LEFT, swatch, WSID.RIGHT, 8, 0)
        rlbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        rlbl:SetText(ck.label)

        local editBtn = MakeBtn(row, "Edit", 50, 22)
        editBtn:SetPoint(WSID.LEFT, rlbl, WSID.RIGHT, 10, 0)
        local k = ck.key
        editBtn:SetScript(WSID.OnClick, function() OpenColorPicker(k, swatch) end)

        prevCustom = row
    end

    -- Apply Custom button with confirmation
    local applyCustomBtn = MakeBtn(colScrollContent, "Apply Custom Theme", 220, 30)
    applyCustomBtn:SetPoint(WSID.TOPLEFT, prevCustom, WSID.BOTTOMLEFT, 0, -12)
    applyCustomBtn:SetScript(WSID.OnClick, function()
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

    local expExclHdr = MakeHeader(expExclPanel, "Raid & Dungeon Expansions", WSID.SET_CW)
    expExclHdr:SetPoint(WSID.TOPLEFT, expExclPanel, WSID.TOPLEFT, WSID.SET_PAD, -WSID.SET_PAD)

    local expExclDesc = expExclPanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    expExclDesc:SetPoint(WSID.TOPLEFT, expExclHdr, WSID.BOTTOMLEFT, 4, -6)
    expExclDesc:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    expExclDesc:SetText("Uncheck an expansion to exclude it from the Raids & Dungeons spinner.")
    expExclDesc:SetWidth(WSID.SET_CW - 8)

    local expExclScrollBG, expExclContent, _ = MakeScrollBox(expExclPanel, WSID.SET_CW, WSID.SET_H - 160)
    expExclScrollBG:SetPoint(WSID.TOPLEFT, expExclDesc, WSID.BOTTOMLEFT, -4, -8)

    local ORDER = WSID_EXPANSIONS

    local ROW_H = 28

    local COL_W = math.floor(WSID.SET_CW / 2) - 2

    local function MakeExpRow(i, exp)
        local col = (i-1) % 2        -- 0 = left, 1 = right
        local rowIdx = math.floor((i-1) / 2)
        local even = (rowIdx%2==0)
        local row = CreateFrame(WSID.BUTTON, nil, expExclContent, WSID.BACKDROP_TEMPLATE)
        row:SetSize(COL_W, ROW_H)
        row:SetPoint(WSID.TOPLEFT, expExclContent, WSID.TOPLEFT, col*(COL_W+4), -rowIdx*ROW_H)
        row:SetBackdrop({bgFile=WSID.BG_FILE})
        row:SetBackdropColor(even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                             even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                             even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)

        -- Custom checkbox box
        local box = CreateFrame(WSID.FRAME, nil, row, WSID.BACKDROP_TEMPLATE)
        box:SetSize(14, 14)
        box:SetPoint(WSID.LEFT, row, WSID.LEFT, 10, 0)
        box:SetBackdrop({bgFile=WSID.BG_FILE,edgeFile=WSID.BG_FILE,edgeSize=1})

        -- Checkmark texture
        local check = box:CreateTexture(nil, WSID.OVERLAY)
        check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
        check:SetSize(16, 16)
        check:SetPoint(WSID.CENTER, box, WSID.CENTER, 0, 0)

        -- Label
        local lbl = row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        lbl:SetPoint(WSID.LEFT, box, WSID.RIGHT, 8, 0)

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

        row:SetScript(WSID.OnClick, function()
            if not WhatShouldIDoDB.excludedExpansions then WhatShouldIDoDB.excludedExpansions = {} end
            checked = not checked
            if checked then
                WhatShouldIDoDB.excludedExpansions[expName] = nil
            else
                WhatShouldIDoDB.excludedExpansions[expName] = true
            end
            SetState(checked)
        end)
        row:SetScript(WSID.OnEnter, function()
            row:SetBackdropColor(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1)
        end)
        local re,rg,rb = even and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1], even and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2], even and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3]
        row:SetBackdropColor(re,rg,rb,1)
        row:SetScript(WSID.OnLeave, function() row:SetBackdropColor(re,rg,rb,1) end)

        return row, SetState
    end

    local expRows = {}
    for i, exp in ipairs(ORDER) do
        local row, setState = MakeExpRow(i, exp)
        expRows[exp] = setState
    end
    expExclContent:SetHeight(math.ceil(#ORDER / 2) * ROW_H)

    -- Enable All / Disable All buttons
    local expEnableAllBtn = MakeBtn(expExclPanel, "Enable All", math.floor(WSID.SET_CW/2) - 3, 24)
    expEnableAllBtn:SetPoint(WSID.BOTTOMLEFT, expExclPanel, WSID.BOTTOMLEFT, WSID.SET_PAD, WSID.SET_PAD)
    expEnableAllBtn:SetScript(WSID.OnClick, function()
        if WhatShouldIDoDB.excludedExpansions then wipe(WhatShouldIDoDB.excludedExpansions) end
        for _, setState in pairs(expRows) do setState(true) end
    end)

    local expDisableAllBtn = MakeBtn(expExclPanel, "Disable All", math.floor(WSID.SET_CW/2) - 3, 24)
    expDisableAllBtn:SetPoint(WSID.BOTTOMRIGHT, expExclPanel, WSID.BOTTOMRIGHT, -WSID.SET_PAD, WSID.SET_PAD)
    expDisableAllBtn:SetScript(WSID.OnClick, function()
        if not WhatShouldIDoDB.excludedExpansions then WhatShouldIDoDB.excludedExpansions = {} end
        for _, exp in ipairs(ORDER) do
            WhatShouldIDoDB.excludedExpansions[exp] = true
            if expRows[exp] then expRows[exp](false) end
        end
    end)

    --------------------------------------------------------------------
    -- UI SCALE PANEL
    --------------------------------------------------------------------

    local scaleHdr = MakeHeader(scalePanel, "UI Scale", WSID.SET_CW)
    scaleHdr:SetPoint(WSID.TOPLEFT, scalePanel, WSID.TOPLEFT, WSID.SET_PAD, -WSID.SET_PAD)

    local scaleDesc = scalePanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    scaleDesc:SetPoint(WSID.TOPLEFT, scaleHdr, WSID.BOTTOMLEFT, 4, -8)
    scaleDesc:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    scaleDesc:SetText("Scale the addon windows and all text. Changes apply instantly.")
    scaleDesc:SetWidth(WSID.SET_CW - 8)

    local scaleOptions = {
        {label="50%",  val=0.50}, {label="60%",  val=0.60}, {label="70%",  val=0.70},
        {label="80%",  val=0.80}, {label="90%",  val=0.90}, {label="100%", val=1.00},
        {label="110%", val=1.10}, {label="120%", val=1.20}, {label="130%", val=1.30},
        {label="140%", val=1.40}, {label="150%", val=1.50}, {label="160%", val=1.60},
        {label="170%", val=1.70}, {label="180%", val=1.80}, {label="190%", val=1.90},
        {label="200%", val=2.00},
    }

    local scaleLbl = scalePanel:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    scaleLbl:SetPoint(WSID.TOPLEFT, scaleDesc, WSID.BOTTOMLEFT, 0, -12)
    scaleLbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    scaleLbl:SetText("Scale:")

    local scaleBox = CreateFrame(WSID.BUTTON, nil, scalePanel, WSID.BACKDROP_TEMPLATE)
    scaleBox:SetSize(100, 26)
    scaleBox:SetPoint(WSID.LEFT, scaleLbl, WSID.RIGHT, 8, 0)
    BgBorder(scaleBox, COLOR_TABLE.result_bg[1],COLOR_TABLE.result_bg[2],COLOR_TABLE.result_bg[3], COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3])
    local scaleBoxLbl = scaleBox:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    scaleBoxLbl:SetPoint(WSID.LEFT, scaleBox, WSID.LEFT, 8, 0)
    scaleBoxLbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
    local curScale = WhatShouldIDoDB.uiScale or 1.0
    scaleBoxLbl:SetText(string.format("%.0f%%", curScale * 100))

    local scaleDropdown = CreateFrame(WSID.FRAME, nil, scalePanel, WSID.BACKDROP_TEMPLATE)
    scaleDropdown:SetSize(100, #scaleOptions * 22)
    scaleDropdown:SetPoint(WSID.TOPLEFT, scaleBox, WSID.BOTTOMLEFT, 0, -2)
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
        local row = CreateFrame(WSID.BUTTON, nil, scaleDropdown)
        row:SetSize(100, 22)
        row:SetPoint(WSID.TOPLEFT, scaleDropdown, WSID.TOPLEFT, 0, -(i-1)*22)
        local rb = row:CreateTexture(nil,WSID.BACKGROUND)
        rb:SetAllPoints()
        local isEven = (i%2==0)
        rb:SetColorTexture(isEven and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                           isEven and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                           isEven and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)
        local rl = row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        rl:SetPoint(WSID.LEFT, row, WSID.LEFT, 10, 0)
        if opt.val == 1.0 then
            rl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3])
        else
            rl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        end
        rl:SetText(opt.label)
        local ov, ol = opt.val, opt.label
        row:SetScript(WSID.OnClick,  function() ApplyScale(ov, ol) end)
        row:SetScript(WSID.OnEnter, function() rb:SetColorTexture(COLOR_TABLE.row_hover[1],COLOR_TABLE.row_hover[2],COLOR_TABLE.row_hover[3],1) end)
        row:SetScript(WSID.OnLeave, function()
            rb:SetColorTexture(isEven and COLOR_TABLE.row_even[1] or COLOR_TABLE.row_odd[1],
                               isEven and COLOR_TABLE.row_even[2] or COLOR_TABLE.row_odd[2],
                               isEven and COLOR_TABLE.row_even[3] or COLOR_TABLE.row_odd[3], 1)
        end)
    end

    scaleBox:SetScript(WSID.OnClick, function()
        if scaleDropdown:IsShown() then scaleDropdown:Hide() else scaleDropdown:Show() end
    end)

    local scaleResetBtn = MakeBtn(scalePanel, "Reset to 100%", 120, 26)
    scaleResetBtn:SetPoint(WSID.TOPLEFT, scaleLbl, WSID.BOTTOMLEFT, 0, -14)
    scaleResetBtn:SetScript(WSID.OnClick, function()
        ApplyScale(1.0, "100%")
    end)

    --------------------------------------------------------------------
    -- CHANGELOG PANEL
    --------------------------------------------------------------------

    local clScrollBG, clScrollContent, _ = MakeScrollBox(changelogPanel, WSID.SET_CW, WSID.SET_H - 50)
    clScrollBG:SetPoint(WSID.TOPLEFT, changelogPanel, WSID.TOPLEFT, WSID.SET_PAD, -WSID.SET_PAD)

    local yOff = -6
    for _, block in ipairs(WSID_CHANGELOG) do
        -- Version header
        local vHdr = MakeHeader(clScrollContent, "v"..block.version, WSID.SET_CW - 4)
        vHdr:SetPoint(WSID.TOPLEFT, clScrollContent, WSID.TOPLEFT, 0, yOff)
        yOff = yOff - 34

        for _, entry in ipairs(block.entries) do
            local isNew = entry.type == "new"
            -- Tag label
            local tag = clScrollContent:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            tag:SetPoint(WSID.TOPLEFT, clScrollContent, WSID.TOPLEFT, 8, yOff)
            tag:SetText(isNew and "|cff44cc44[New]|r" or "|cffcc4444[Fix]|r")

            -- Entry text
            local txt = clScrollContent:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
            txt:SetPoint(WSID.TOPLEFT, clScrollContent, WSID.TOPLEFT, 52, yOff)
            txt:SetPoint(WSID.RIGHT,   clScrollContent, WSID.RIGHT,  -8, 0)
            txt:SetJustifyH(WSID.LEFT)
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

    f:SetScript(WSID.OnShow,function() SetNavActive("activities") end)
    SetNavActive("activities")
    return f
end

------------------------------------------------------------------------
-- MAIN WINDOW
------------------------------------------------------------------------


