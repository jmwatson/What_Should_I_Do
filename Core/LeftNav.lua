local _, addon = ...;
local CT = addon.DB.COLOR_TABLE;
local NAV_W  = 120;
local ROW_H = 38;
local ROW_W = 3;

local function SetTopRowPoint(anchorFrm, anchorPt, anchorOff)
    local function _SetTopRowPoint(row)
        row:SetPoint(addon.TOPLEFT, anchorFrm, anchorPt, 0, anchorOff or 0);
    end
    return _SetTopRowPoint;
end

local function SetBottomRowPoint(parent, count, index)
    local function _SetBottomRowPoint(row)
        row:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, (count - index) * ROW_H);
    end
    return _SetBottomRowPoint;
end

local function OnEnter(name, bg, lbl, active)
    local function _OnEnter()
        if active ~= name then
            bg:SetColorTexture(CT.nav_hover[1], CT.nav_hover[2], CT.nav_hover[3], 1);
            lbl:SetTextColor(CT.bright_text[1], CT.bright_text[2], CT.bright_text[3]);
        end
    end
    return _OnEnter;
end

local function OnLeave(name, bg, lbl, active)
    local function _OnLeave()
        if active ~= name then
            bg:SetColorTexture(0, 0, 0, 0);
            lbl:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);
        end
    end
    return _OnLeave;
end

local function AddRow(def, SetRowPoint, SetActive)
    local row = CreateFrame(addon.BUTTON, nil, navBg);
    local bg = row:CreateTexture(nil, addon.BACKGROUND);
    local stripe = row:CreateTexture(nil, addon.ARTWORK);
    local lbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    local name = def.name;

    row:SetSize(NAV_W, ROW_H);
    SetRowPoint(row);
    bg:SetAllPoints();
    bg:SetColorTexture(0,0,0,0);
    stripe:SetColorTexture(CT.nav_border[1], CT.nav_border[2], CT.nav_border[3], 1);
    stripe:SetSize(ROW_W, ROW_H);
    stripe:SetPoint(addon.LEFT, row, addon.LEFT, 0, 0);
    stripe:Hide();
    lbl:SetPoint(addon.LEFT, row, addon.LEFT, 16, 0);
    lbl:SetText(def.label);
    lbl:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);
    row:SetScript(addon.OnClick, SetActive(name));
    row:SetScript(addon.OnEnter, OnEnter(name, bg, lbl));
    row:SetScript(addon.OnLeave, OnLeave(name, bg, lbl));

    return row, bg, stripe, lbl;
end

local function SetActive(name, btns, OnSelect)
    local function _SetActive()
        for k, btn in pairs(btns) do
            if k == name then
                btn.bg:SetColorTexture(CT.nav_active[1], CT.nav_active[2], CT.nav_active[3], 1);
                btn.stripe:Show();
                btn.lbl:SetTextColor(1, 1, 1);
            else
                btn.bg:SetColorTexture(0, 0, 0, 0);
                btn.stripe:Hide();
                btn.lbl:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);
            end
        end
        if OnSelect then
            OnSelect(name);
        end
    end
    return _SetActive;
end

local function BuildLeftNav(parent, topDefs, bottomDefs, OnSelect)
    local navBg = CreateFrame(addon.FRAME, nil, parent);
    local divR = navBg:CreateTexture(nil, addon.ARTWORK);
    local btns   = {};

    addon.Tx(navBg, CT.sidebar[1], CT.sidebar[2], CT.sidebar[3]);
    navBg:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0,-30);
    navBg:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 0);
    navBg:SetWidth(NAV_W);
    divR:SetColorTexture(CT.divider[1], CT.divider[2], CT.divider[3], 1);
    divR:SetWidth(1);
    divR:SetPoint(addon.TOPRIGHT, navBg, addon.TOPRIGHT, 0, 0);
    divR:SetPoint(addon.BOTTOMRIGHT, navBg, addon.BOTTOMRIGHT, 0, 0);

    local prev = navBg;
    local pp = addon.TOPLEFT;
    for _, def in ipairs(topDefs) do
        local row, bg, stripe, lbl = AddRow(def, SetTopRowPoint(prev, pp, 0), SetActive(def.name, btns, OnSelect));
        btns[def.name] = {bg=bg, stripe=stripe, lbl=lbl};
        prev = row;
        pp = addon.BOTTOMLEFT;
    end

    -- divider above bottom items
    local bdiv = navBg:CreateTexture(nil,addon.ARTWORK);
    bdiv:SetColorTexture(CT.divider[1],CT.divider[2],CT.divider[3],1);
    bdiv:SetHeight(1);
    bdiv:SetPoint(addon.BOTTOMLEFT, navBg, addon.BOTTOMLEFT,  0, #bottomDefs * ROW_H);
    bdiv:SetPoint(addon.BOTTOMRIGHT, navBg, addon.BOTTOMRIGHT, 0, #bottomDefs * ROW_H);

    for k, def in ipairs(bottomDefs) do
        AddRow(def, SetBottomRowPoint(navBg, #bottomDefs, k));
    end

    SetActive(topDefs[1].name);
    return SetActive;
end
addon.BuildLeftNav = BuildLeftNav;
