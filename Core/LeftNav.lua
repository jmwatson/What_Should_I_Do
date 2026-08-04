-- Core/LeftNav.lua
-- Left navigation bar builder
-- Author: I_AM_T3X | v1.0.0

WSID["BuildLeftNav"] = function(parent, topDefs, bottomDefs, onSelect)
    local ROW_H = 38
    local navBg = CreateFrame(WSID.FRAME, nil, parent)
    navBg:SetPoint(WSID.TOPLEFT,    parent,WSID.TOPLEFT,    0,-30)
    navBg:SetPoint(WSID.BOTTOMLEFT, parent,WSID.BOTTOMLEFT, 0,  0)
    navBg:SetWidth(WSID.NAV_W)
    Tx(navBg, COLOR_TABLE.sidebar[1],COLOR_TABLE.sidebar[2],COLOR_TABLE.sidebar[3])
    local divR = navBg:CreateTexture(nil,WSID.ARTWORK)
    divR:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1)
    divR:SetWidth(1)
    divR:SetPoint(WSID.TOPRIGHT,navBg,WSID.TOPRIGHT,0,0)
    divR:SetPoint(WSID.BOTTOMRIGHT,navBg,WSID.BOTTOMRIGHT,0,0)

    local btns   = {}
    local active = nil

    local function SetActive(name)
        active = name
        for k,b in pairs(btns) do
            if k == name then
                b.bg:SetColorTexture(COLOR_TABLE.nav_active[1],COLOR_TABLE.nav_active[2],COLOR_TABLE.nav_active[3],1)
                b.stripe:Show() ; b.lbl:SetTextColor(1,1,1)
            else
                b.bg:SetColorTexture(0,0,0,0)
                b.stripe:Hide() ; b.lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
            end
        end
        if onSelect then onSelect(name) end
    end

    local function AddRow(def, anchorFrm, anchorPt, anchorOff)
        local row = CreateFrame(WSID.BUTTON, nil, navBg)
        row:SetSize(WSID.NAV_W, ROW_H)
        row:SetPoint(WSID.TOPLEFT, anchorFrm, anchorPt, 0, anchorOff or 0)
        local bg     = row:CreateTexture(nil,WSID.BACKGROUND) ; bg:SetAllPoints() ; bg:SetColorTexture(0,0,0,0)
        local stripe = row:CreateTexture(nil,WSID.ARTWORK)
        stripe:SetColorTexture(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
        stripe:SetSize(3,ROW_H) ; stripe:SetPoint(WSID.LEFT,row,WSID.LEFT,0,0) ; stripe:Hide()
        local lbl = row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        lbl:SetPoint(WSID.LEFT,row,WSID.LEFT,16,0) ; lbl:SetText(def.label)
        lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        local name = def.name
        row:SetScript(WSID.OnClick,  function() SetActive(name) end)
        row:SetScript(WSID.OnEnter,  function()
            if active~=name then bg:SetColorTexture(COLOR_TABLE.nav_hover[1],COLOR_TABLE.nav_hover[2],COLOR_TABLE.nav_hover[3],1)
                                 lbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3]) end end)
        row:SetScript(WSID.OnLeave,  function()
            if active~=name then bg:SetColorTexture(0,0,0,0)
                                 lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3]) end end)
        btns[name] = {bg=bg,stripe=stripe,lbl=lbl}
        return row
    end

    local prev = navBg ; local pp = WSID.TOPLEFT
    for _, def in ipairs(topDefs) do
        local row = AddRow(def, prev, pp, 0)
        prev = row ; pp = WSID.BOTTOMLEFT
    end

    -- divider above bottom items
    local bdiv = navBg:CreateTexture(nil,WSID.ARTWORK)
    bdiv:SetColorTexture(COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3],1) ; bdiv:SetHeight(1)
    bdiv:SetPoint(WSID.BOTTOMLEFT,  navBg,WSID.BOTTOMLEFT,  0, #bottomDefs*ROW_H)
    bdiv:SetPoint(WSID.BOTTOMRIGHT, navBg,WSID.BOTTOMRIGHT, 0, #bottomDefs*ROW_H)

    for i, def in ipairs(bottomDefs) do
        local row = CreateFrame(WSID.BUTTON, nil, navBg)
        row:SetSize(WSID.NAV_W, ROW_H)
        row:SetPoint(WSID.BOTTOMLEFT, navBg,WSID.BOTTOMLEFT, 0, (#bottomDefs-i)*ROW_H)
        local bg     = row:CreateTexture(nil,WSID.BACKGROUND) ; bg:SetAllPoints() ; bg:SetColorTexture(0,0,0,0)
        local stripe = row:CreateTexture(nil,WSID.ARTWORK)
        stripe:SetColorTexture(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
        stripe:SetSize(3,ROW_H) ; stripe:SetPoint(WSID.LEFT,row,WSID.LEFT,0,0) ; stripe:Hide()
        local lbl = row:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        lbl:SetPoint(WSID.LEFT,row,WSID.LEFT,16,0) ; lbl:SetText(def.label)
        lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        local name = def.name
        row:SetScript(WSID.OnClick,  function() SetActive(name) end)
        row:SetScript(WSID.OnEnter,  function()
            if active~=name then bg:SetColorTexture(COLOR_TABLE.nav_hover[1],COLOR_TABLE.nav_hover[2],COLOR_TABLE.nav_hover[3],1)
                                 lbl:SetTextColor(COLOR_TABLE.bright_text[1],COLOR_TABLE.bright_text[2],COLOR_TABLE.bright_text[3]) end end)
        row:SetScript(WSID.OnLeave,  function()
            if active~=name then bg:SetColorTexture(0,0,0,0)
                                 lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3]) end end)
        btns[name] = {bg=bg,stripe=stripe,lbl=lbl}
    end

    SetActive(topDefs[1].name)
    return SetActive
end

------------------------------------------------------------------------
-- TAB 1: ACTIVITY
------------------------------------------------------------------------
-- Layout (total content height needed = 490px available):
--   WSID.PAD(16) + hdr(28) + gap(10) + desc(14) + gap(12)
--   + catBox(52) + gap(10) + subBox(52) + gap(14)
--   + btnRow(30) + gap(6) + bothBtn(30) + WSID.PAD(16) = 290px  (lots of breathing room)


