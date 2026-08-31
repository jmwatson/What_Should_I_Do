local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

local function CreateLeftNav(parent, OnSelect, opts)
    opts = opts or {};
    local NAV_W = opts.width or 120;
    local ROW_H = opts.rowHeight or 38;
    local ROW_W = 3;
    local bottomInset = opts.bottomInset or 0;

    local navBg = CreateFrame(addon.FRAME, nil, parent);

    local btns = {};
    local active = nil;
    local topAnchor = navBg;
    local topAnchorPt = addon.TOPLEFT;
    local bottomSection = nil;
    local bottomHeight = 0;

    --- PRIVATE API
    local function _SetActive(name)
        active = name;

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

    local function AddRow(def, SetRowPoint, rowParent)
        local row = CreateFrame(addon.BUTTON, nil, rowParent or navBg);
        local bg = row:CreateTexture(nil, addon.BACKGROUND);
        local stripe = row:CreateTexture(nil, addon.ARTWORK);
        local lbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
        local name = def.name;

        row:SetSize(NAV_W, ROW_H);
        SetRowPoint(row);
        bg:SetAllPoints();
        stripe:SetSize(ROW_W, ROW_H);
        stripe:SetPoint(addon.LEFT, row, addon.LEFT, 0, 0);
        stripe:Hide();
        lbl:SetPoint(addon.LEFT, row, addon.LEFT, 16, 0);
        lbl:SetText(def.label);
        addon.ApplyColor(bg, "SetColorTexture", addon.BLACK, 0);
        addon.ApplyColor(stripe, "SetColorTexture", CT.nav_border);
        addon.ApplyColor(lbl, "SetTextColor", CT.dim_text);

        row:SetScript(addon.OnClick, function() _SetActive(name); end);
        row:SetScript(addon.OnEnter, function()
            if active ~= name then
                addon.ApplyColor(bg, "SetColorTexture", CT.nav_hover);
                addon.ApplyColor(lbl, "SetTextColor", CT.bright_text);
            end
        end);
        row:SetScript(addon.OnLeave, function()
            if active ~= name then
                addon.ApplyColor(bg, "SetColorTexture", addon.BLACK, 0);
                addon.ApplyColor(lbl, "SetTextColor", CT.dim_text);
            end
        end);

        btns[name] = {bg=bg, stripe=stripe, lbl=lbl};

        return row;
    end

    local function EnsureBottomSection()
        if not bottomSection then
            bottomSection = CreateFrame(addon.FRAME, nil, navBg);
            bottomSection:SetPoint(addon.BOTTOMLEFT, navBg, addon.BOTTOMLEFT, 0, bottomInset);
            bottomSection:SetPoint(addon.BOTTOMRIGHT, navBg, addon.BOTTOMRIGHT, 0, bottomInset);
            bottomSection:SetHeight(0.01);
        end

        return bottomSection;
    end

    --- PUBLIC API
    function navBg:AddNav(name, label)
        local anchorFrm, anchorPt = topAnchor, topAnchorPt;
        local row = AddRow({name = name, label = label}, function(r)
            r:SetPoint(addon.TOPLEFT, anchorFrm, anchorPt, 0, 0);
        end);
        topAnchor = row;
        topAnchorPt = addon.BOTTOMLEFT;

        return row;
    end

    function navBg:AddBottomNav(name, label)
        local sec = EnsureBottomSection();
        local yOff = bottomHeight;
        local row = AddRow({name = name, label = label}, function(r)
            r:SetPoint(addon.TOPLEFT, sec, addon.TOPLEFT, 0, -yOff);
        end, sec);
        bottomHeight = bottomHeight + ROW_H;
        sec:SetHeight(bottomHeight);

        return row;
    end

    function navBg:AddRule()
        local sec = EnsureBottomSection();
        local rule = sec:CreateTexture(nil, addon.ARTWORK);
        addon.ApplyColor(rule, "SetColorTexture", CT.divider);
        rule:SetHeight(1);
        rule:SetPoint(addon.TOPLEFT, sec, addon.TOPLEFT, 0, -bottomHeight);
        rule:SetPoint(addon.TOPRIGHT, sec, addon.TOPRIGHT, 0, -bottomHeight);
        bottomHeight = bottomHeight + 1;
        sec:SetHeight(bottomHeight);
    end

    function navBg:SetActive(name)
        _SetActive(name);
    end

    addon.Tx(navBg, CT.sidebar);
    navBg:SetPoint(addon.TOPLEFT, parent, addon.TOPLEFT, 0, -30);
    navBg:SetPoint(addon.BOTTOMLEFT, parent, addon.BOTTOMLEFT, 0, 0);
    navBg:SetWidth(NAV_W);

    local divR = navBg:CreateTexture(nil, addon.ARTWORK);
    addon.ApplyColor(divR, "SetColorTexture", CT.divider);
    divR:SetWidth(1);
    divR:SetPoint(addon.TOPRIGHT, navBg, addon.TOPRIGHT, 0, 0);
    divR:SetPoint(addon.BOTTOMRIGHT, navBg, addon.BOTTOMRIGHT, 0, 0);

    return navBg;
end
addon.CreateLeftNav = CreateLeftNav;
