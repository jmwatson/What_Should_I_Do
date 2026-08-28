local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local ORDER = addon.EXPANSIONS;
local ROW_H = 28;
local COL_W = math.floor(addon.SET_CW / 2) - 2;

local function PaintRow(row, checked)
    if checked then
        addon.ApplyColor(row.box, "SetBackdropColor", CT.result_bg);
        addon.ApplyColor(row.box, "SetBackdropBorderColor", CT.accent or CT.nav_border);
        addon.ApplyColor(row.box, "SetVertexColor", CT.accent or CT.nav_border);
        addon.ApplyColor(row.box, "SetTextColor", CT.bright_text);
        row.check:Show();
    else
        addon.ApplyColor(row.box, "SetBackdropColor", {0.05, 0.03, 0.08});
        addon.ApplyColor(row.box, "SetBackdropBorderColor", CT.divider);
        addon.ApplyColor(row.box, "SetTextColor", CT.dim_text);
        row.check:Hide();
    end
end

local ExpansionsPanelMixin = {};

function ExpansionsPanelMixin:RefreshExpansions()
    self.rowPool:ReleaseAll();

    DB.excludedExpansions = DB.excludedExpansions or {};

    for i, exp in ipairs(ORDER) do
        local col = (i - 1) % 2;
        local rowIdx = math.floor((i - 1) / 2);
        local even = (rowIdx % 2 == 0);
        local name = exp;

        local row = self.rowPool:Acquire();

        if not row.box then
            row.box = CreateFrame(addon.FRAME, nil, row, addon.BACKDROP_TEMPLATE);
            row.box:SetSize(14, 14);
            row.box:SetPoint(addon.LEFT, row, addon.LEFT, 10, 0);
            row.box:SetBackdrop({bgFile = addon.BG_FILE, edgeFile = addon.BG_FILE, edgeSize = 1});
            row.check = row.box:CreateTexture(nil, addon.OVERLAY);
            row.check:SetSize(16, 16);
            row.check:SetPoint(addon.CENTER, row.box, addon.CENTER, 0, 0);
            row.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check");
            row.lbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
            row.lbl:SetPoint(addon.LEFT, row.box, addon.RIGHT, 8, 0);
        end

        row:Show();
        row:SetSize(COL_W, ROW_H);
        row:ClearAllPoints();
        row:SetPoint(addon.TOPLEFT, self.content, addon.TOPLEFT, col * (COL_W + 4), -rowIdx * ROW_H);
        row:SetBackdrop({bgFile = addon.BG_FILE});
        row.lbl:SetText(name);
        row._even = even;

        local isChecked = not DB.excludedExpansions[name];
        PaintRow(row, isChecked);
        addon.ApplyColor(row, "SetBackdropColor", even and CT.row_even or CT.row_odd);

        row:SetScript(addon.OnClick, function()
            isChecked = not isChecked;
            DB.excludedExpansions[name] = isChecked and nil or true;
            PaintRow(row, isChecked);
        end);
        row:SetScript(addon.OnEnter, function()
            addon.ApplyColor(row, "SetBackdropColor", CT.row_hover);
        end);
        row:SetScript(addon.OnLeave, function()
            addon.ApplyColor(row, "SetBackdropColor", row._even and CT.row_even or CT.row_odd);
        end);
    end
end

function ExpansionsPanelMixin:EnableAll()
    if DB.excludedExpansions then
        wipe(DB.excludedExpansions);
    end

    self:RefreshExpansions();
end

function ExpansionsPanelMixin:DisableAll()
    DB.excludedExpansions = DB.excludedExpansions or {};

    for _, exp in ipairs(ORDER) do
        DB.excludedExpansions[exp] = true;
    end

    self:RefreshExpansions();
end

local function BuildExpansionsPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, ExpansionsPanelMixin);

    panel.header = addon.MakeHeader(panel, "Raid & Dungeon Expansions", addon.SET_CW);
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD);
    panel.desc = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.desc:SetPoint(addon.TOPLEFT, panel.header, addon.BOTTOMLEFT, 4, -6);
    panel.desc:SetText("Uncheck an expansion to exclude it from the Raids & Dungeons spinner.");
    panel.desc:SetWidth(addon.SET_CW - 8);
    panel.scrollBG, panel.content, _ = addon.MakeScrollBox(panel, addon.SET_CW, addon.SET_H - 160);
    panel.scrollBG:SetPoint(addon.TOPLEFT, panel.desc, addon.BOTTOMLEFT, -4, -8);
    panel.content:SetHeight(math.ceil(#ORDER / 2) * ROW_H);

    addon.ApplyColor(panel.desc, "SetTextColor", CT.dim_text);

    panel.rowPool = CreateFrame(addon.BUTTON, panel.content, addon.BACKDROP_TEMPLATE);

    -- Enable All / Disable All buttons
    panel.enableAllBtn = addon.MakeBtn(panel, "Enable All", math.floor(addon.SET_CW/2) - 3, 24);
    panel.enableAllBtn:SetPoint(addon.BOTTOMLEFT, panel, addon.BOTTOMLEFT, addon.SET_PAD, addon.SET_PAD);
    panel.enableAllBtn:SetScript(addon.OnClick, function() panel:OnClick(); end);

    panel.disableAllBtn = addon.MakeBtn(panel, "Disable All", math.floor(addon.SET_CW/2) - 3, 24);
    panel.disableAllBtn:SetPoint(addon.BOTTOMRIGHT, panel, addon.BOTTOMRIGHT, -addon.SET_PAD, addon.SET_PAD);
    panel.disableAllBtn:SetScript(addon.OnClick, function() panel:DisableAll(); end);

    panel:SetScript(addon.OnShow, panel.RefreshExpansions)
    panel:RefreshExpansions();

    return panel;
end
addon.BuildExpansionsPanel = BuildExpansionsPanel;