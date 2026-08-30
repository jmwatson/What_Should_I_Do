local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;
local NAV_W  = 120;
local ROW_H = 38;
local ROW_W = 3;

local LeftNavMixin = {};

function LeftNavMixin:SetActive(name)
    self.active = name;

    for k, btn in pairs(self.btns) do
        if k == self.name then
            addon.ApplyColor(btn.bg, "SetColorTexture", CT.nav_active);
            addon.ApplyColor(btn.lbl, "SetTextColor", addon.WHITE);
            btn.stripe:Show();
        else
            addon.ApplyColor(btn.bg, "SetColorTexture", addon.BLACK, 0);
            addon.ApplyColor(btn.lbl, "SetTextColor", CT.dim_text);
            btn.stripe:Hide();
        end
    end

    if self.OnSelect then
        self.OnSelect(name);
    end
end

function LeftNavMixin:AddRow(navBg, def, SetRowPoint, SetActive)
    local row = CreateFrame(addon.BUTTON, nil, navBg);
    local bg = row:CreateTexture(nil, addon.BACKGROUND);
    local stripe = row:CreateTexture(nil, addon.ARTWORK);
    local lbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    local name = def.name;

    SetRowPoint(row);
    bg:SetAllPoints();
    row:SetSize(NAV_W, ROW_H);
    stripe:SetSize(ROW_W, ROW_H);
    stripe:SetPoint(addon.LEFT, row, addon.LEFT, 0, 0);
    stripe:Hide();
    lbl:SetPoint(addon.LEFT, row, addon.LEFT, 16, 0);
    lbl:SetText(def.label);
    addon.ApplyColor(bg, "SetColorTexture", addon.BLACK, 0);
    addon.ApplyColor(stripe, "SetColorTexture", CT.nav_border);
    addon.ApplyColor(lbl, "SetTextColor", CT.dim_text);
    row:SetScript(addon.OnClick, function() self:SetActive(name); end);
    row:SetScript(addon.OnEnter, function()
        if self.active ~= name then
            addon.ApplyColor(bg, "SetColorTexture", CT.nav_hover);
            addon.ApplyColor(lbl, "SetTextColor", CT.bright_text);
        end
    end);
    row:SetScript(addon.OnLeave, function()
        if self.active ~= name then
            addon.ApplyColor(bg, "SetColorTexture", addon.BLACK, 0);
            addon.ApplyColor(lbl, "SetTextColor", CT.dim_text);
        end
    end);

    self.btns[name] = {bg = bg, stripe = stripe, lbl = lbl};

    return row;
end

local function BuildLeftNav(parent, topDefs, bottomDefs, OnSelect)
    local navBg = CreateFrame(addon.FRAME, nil, parent);
    Mixin(navBg, LeftNavMixin);

    navBg.OnSelect = OnSelect;
    local divR = navBg:CreateTexture(nil, addon.ARTWORK);
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
        local anchorFrm, anchorPt = prev, pp;
        local row = navBg:AddRow(def, function(r)
            r:SetPoint(addon.TOPLEFT, anchorFrm, anchorPt, 0, 0);
        end);
        prev = row;
        pp = addon.BOTTOMLEFT;
    end

    -- divider above bottom items
    local bdiv = navBg:CreateTexture(nil,addon.ARTWORK);
    addon.ApplyColor(bdiv, "SetColorTexture", CT.divider);
    bdiv:SetHeight(1);
    bdiv:SetPoint(addon.BOTTOMLEFT, navBg, addon.BOTTOMLEFT,  0, #bottomDefs * ROW_H);
    bdiv:SetPoint(addon.BOTTOMRIGHT, navBg, addon.BOTTOMRIGHT, 0, #bottomDefs * ROW_H);

    for idx, def in ipairs(bottomDefs) do
        navBg:AddRow(def, function(r)
            r:SetPoint(addon.BOTTOMLEFT, navBg, addon.BOTTOMLEFT, 0, (#bottomDefs - idx) * ROW_H);
        end);
    end

    navBg:SetActive(topDefs[1].name);

    return navBg;
end
addon.BuildLeftNav = BuildLeftNav;
