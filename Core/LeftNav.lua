local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;
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
            addon.ApplyColor(bg, "SetColorTexture", CT.nav_hover);
            addon.ApplyColor(lbl, "SetTextColor", CT.bright_text);
        end
    end
    return _OnEnter;
end

local function OnLeave(name, bg, lbl, active)
    local function _OnLeave()
        if active ~= name then
            addon.ApplyColor(bg, "SetColorTexture", addon.BLACK, 0);
            addon.ApplyColor(lbl, "SetTextColor", CT.dim_text);
        end
    end
    return _OnLeave;
end

local function SetActive(name, btns, OnSelect)
    local function _SetActive()
        for k, btn in pairs(btns) do
            if k == name then
                addon.ApplyColor(btn.bg, "SetColorTexture", CT.nav_active);
                addon.ApplyColor(btn.lbl, "SetTextColor", addon.WHITE);
                btn.stripe:Show();
            else
                addon.ApplyColor(btn.bg, "SetColorTexture", addon.BLACK, 0);
                addon.ApplyColor(btn.lbl, "SetTextColor", CT.dim_text);
                btn.stripe:Hide();
            end
        end
        if OnSelect then
            OnSelect(name);
        end
    end
    return _SetActive;
end

local function AddRow(navBg, def, SetRowPoint, SetActive)
    local row = CreateFrame(addon.BUTTON, nil, navBg);
    local bg = row:CreateTexture(nil, addon.BACKGROUND);
    local stripe = row:CreateTexture(nil, addon.ARTWORK);
    local lbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    local name = def.name;

    row:SetSize(NAV_W, ROW_H);
    SetRowPoint(row);
    bg:SetAllPoints();
    addon.ApplyColor(bg, "SetColorTexture", addon.BLACK, 0);
    addon.ApplyColor(stripe, "SetColorTexture", CT.nav_border);
    stripe:SetSize(ROW_W, ROW_H);
    stripe:SetPoint(addon.LEFT, row, addon.LEFT, 0, 0);
    stripe:Hide();
    lbl:SetPoint(addon.LEFT, row, addon.LEFT, 16, 0);
    lbl:SetText(def.label);
    addon.ApplyColor(lbl, "SetTextColor", CT.dim_text);
    row:SetScript(addon.OnClick, SetActive(name));
    row:SetScript(addon.OnEnter, OnEnter(name, bg, lbl));
    row:SetScript(addon.OnLeave, OnLeave(name, bg, lbl));

    return row, bg, stripe, lbl;
end

local function BuildLeftNav(parent, topDefs, bottomDefs, OnSelect)
    local navBg = CreateFrame(addon.FRAME, nil, parent);
    local divR = navBg:CreateTexture(nil, addon.ARTWORK);
    local btns   = {};

    addon.Tx(navBg, CT.sidebar);
    navBg:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0,-30);
    navBg:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 0);
    navBg:SetWidth(NAV_W);
    addon.ApplyColor(divR, "SetColorTexture", CT.divider);
    divR:SetWidth(1);
    divR:SetPoint(addon.TOPRIGHT, navBg, addon.TOPRIGHT, 0, 0);
    divR:SetPoint(addon.BOTTOMRIGHT, navBg, addon.BOTTOMRIGHT, 0, 0);

    local prev = navBg;
    local pp = addon.TOPLEFT;
    for _, def in ipairs(topDefs) do
        local row, bg, stripe, lbl = AddRow(navBg, def, SetTopRowPoint(prev, pp, 0), SetActive(def.name, btns, OnSelect));
        btns[def.name] = {bg=bg, stripe=stripe, lbl=lbl};
        prev = row;
        pp = addon.BOTTOMLEFT;
    end

    -- divider above bottom items
    local bdiv = navBg:CreateTexture(nil,addon.ARTWORK);
    addon.ApplyColor(bdiv, "SetColorTexture", CT.divider);
    bdiv:SetHeight(1);
    bdiv:SetPoint(addon.BOTTOMLEFT, navBg, addon.BOTTOMLEFT,  0, #bottomDefs * ROW_H);
    bdiv:SetPoint(addon.BOTTOMRIGHT, navBg, addon.BOTTOMRIGHT, 0, #bottomDefs * ROW_H);

    for k, def in ipairs(bottomDefs) do
        AddRow(navBg, def, SetBottomRowPoint(navBg, #bottomDefs, k), SetActive(def.name, btns, OnSelect));
    end

    SetActive(topDefs[1].name, btns, OnSelect)();
end
addon.BuildLeftNav = BuildLeftNav;
