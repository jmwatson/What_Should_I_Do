local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

local THEME_DEFS = {
    {name=addon.DEFAULT_THEME, label=addon.DEFAULT_THEME, desc="The original purple theme."},
    {name=addon.DEUTERANOPIA, label=addon.DEUTERANOPIA, desc="Red-green colorblind. Blue/cyan accents."},
    {name=addon.PROTANOPIA, label=addon.PROTANOPIA, desc="Red blind. Deep blue accents."},
    {name=addon.TRITANOPIA, label=addon.TRITANOPIA, desc="Blue-yellow blind. Orange/amber accents."},
    {name=addon.HIGHCONTRAST, label="High Contrast",desc="Black background with yellow accents."},
};

local CUSTOM_KEYS = {
    {key="nav_border",  label="Accent / Border"},
    {key="btn_bdr",     label="Button Border"},
    {key="header_txt",  label="Header Text"},
    {key="spin_text",   label="Spin Result Text"},
    {key="bright_text", label="Bright Text"},
    {key="bg",          label="Background"},
};

-- Confirm popup helper
local function ConfirmAndReload(themeName, displayName, onConfirm)
    StaticPopupDialogs["WSID_CONFIRM_THEME"] = {
        text = "Apply the "..displayName.." theme?\n\nThe UI will reload to apply the new colors.",
        button1 = "Yes, Apply",
        button2 = "Cancel",
        OnAccept = function()
            if onConfirm then
                onConfirm();
            end

            DB.colorTheme = themeName;
            ReloadUI();
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    };
    StaticPopup_Show("WSID_CONFIRM_THEME");
end

local ColorsPanelMixin = {};

function ColorsPanelMixin:UpdateThemeBtns()
    local cur = DB.colorTheme or addon.DEFAULT_THEME;

    for _, tb in ipairs(self.themeBtns) do
        if tb._theme == cur then
            addon.ApplyColor(tb, "SetBackdropColor", CT.nav_active);
            addon.ApplyColor(tb, "SetBackdropBorderColor", CT.nav_border);
            addon.ApplyColor(tb._lbl, "SetTextColor", addon.WHITE);
        else
            addon.ApplyColor(tb, "SetBackdropColor", CT.btn_bg);
            addon.ApplyColor(tb, "SetBackdropBorderColor", CT.btn_bdr);
            addon.ApplyColor(tb._lbl, "SetTextColor", CT.btn_text);
        end
    end
end

function ColorsPanelMixin:OpenColorPicker(key, swatch)
    -- Auto-select Custom theme when editing colors
    DB.colorTheme = addon.CUSTOM_THEME;
    self:UpdateThemeBtns();

    if not DB.customColors then DB.customColors = {}; end

    -- Seed all keys from current C table if not yet set
    for k,v in pairs(CT) do
        if not DB.customColors[k] then
            DB.customColors[k] = {v[1],v[2],v[3]};
        end
    end

    local cur = DB.customColors[key] or CT[key];
    local info = {};
    info.r, info.g, info.b = cur[1], cur[2], cur[3];
    info.hasOpacity = false;
    info.swatchFunc = function()
        local r,g,b = ColorPickerFrame:GetColorRGB();
        DB.customColors[key] = {r,g,b};

        -- Update the swatch preview
        if swatch then
            addon.ApplyColor(swatch, "SetBackdropColor", DB.customColors[key]);
        end
    end
    info.cancelFunc = function(prev)
        DB.customColors[key] = {prev.r,prev.g,prev.b};

        if swatch then
            addon.ApplyColor(swatch, "SetBackdropColor", DB.customColors[key]);
        end
    end

    ColorPickerFrame:SetupColorPickerAndShow(info);
end

local function BuildColorsPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, ColorsPanelMixin);

    panel.scrollBG, panel.content, _ = addon.MakeScrollBox(panel, addon.SET_CW, addon.SET_H - 30 - addon.SET_PAD * 2);
    panel.scrollBG:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD);
    panel.header = addon.MakeHeader(panel.content, "Color Theme", addon.SET_CW - 4);
    panel.header:SetPoint(addon.TOPLEFT, panel.content, addon.TOPLEFT, 0, -4);
    panel.desc = panel.content:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.desc:SetPoint(addon.TOPLEFT, panel.header, addon.BOTTOMLEFT, 4, -6);
    panel.desc:SetText("Select a theme. A UI reload is required to fully apply the new colors.");
    panel.desc:SetWidth(addon.SET_CW - 8);
    panel.themeSep = panel.content:CreateTexture(nil,addon.ARTWORK);
    panel.themeSep:SetPoint(addon.TOPLEFT,  panel.desc, addon.BOTTOMLEFT,  0, -10);
    panel.themeSep:SetPoint(addon.TOPRIGHT, panel.desc, addon.BOTTOMRIGHT, 0, -10);
    panel.themeSep:SetHeight(1);
    panel.themeHdr = panel.content:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.themeHdr:SetPoint(addon.TOPLEFT, panel.themeSep, addon.BOTTOMLEFT, 0, -8);
    panel.themeHdr:SetText("Preset Themes:");

    addon.ApplyColor(panel.themeSep, "SetColorTexture", CT.divider);
    addon.ApplyColor(panel.desc, "SetTextColor", CT.dim_text);
    addon.ApplyColor(panel.themeHdr, "SetTextColor", CT.dim_text);

    panel.themeBtns = {};

    panel.prevRow = panel.themeHdr;
    for _, themeDef in ipairs(THEME_DEFS) do
        local row = CreateFrame(addon.FRAME, nil, panel.content);
        local btn = addon.MakeBtn(row, themeDef.label, 140, 26);
        local themeName = themeDef.name;
        local themeLbl = themeDef.label;
        local definitionLbl = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);

        btn._theme = themeName;
        addon.ApplyColor(definitionLbl, "SetTextColor", CT.dim_text);
        row:SetSize(addon.SET_CW - 4, 28);
        row:SetPoint(addon.TOPLEFT, panel.prevRow, addon.BOTTOMLEFT, 0, -6);
        btn:SetPoint(addon.TOPLEFT, row, addon.TOPLEFT, 0, 0);
        definitionLbl:SetPoint(addon.LEFT, btn, addon.RIGHT, 10, 0);
        definitionLbl:SetText(themeDef.desc);
        btn:SetScript(addon.OnClick, function()
            ConfirmAndReload(themeName, themeLbl);
        end);

        table.insert(panel.themeBtns, btn);
        panel.prevRow = row;
    end

    panel:UpdateThemeBtns();

    -- Custom section
    panel.customSep = panel.content:CreateTexture(nil,addon.ARTWORK);
    addon.ApplyColor(panel.customSep, "SetColorTexture", CT.divider);
    panel.customSep:SetHeight(1);
    panel.customSep:SetPoint(addon.TOPLEFT,  panel.prevRow, addon.BOTTOMLEFT,  0, -12);
    panel.customSep:SetPoint(addon.TOPRIGHT, panel.prevRow, addon.BOTTOMRIGHT, 0, -12);

    panel.customHdr = panel.content:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.customHdr:SetPoint(addon.TOPLEFT, panel.customSep, addon.BOTTOMLEFT, 0, -8);
    addon.ApplyColor(panel.customHdr, "SetTextColor", CT.dim_text);
    panel.customHdr:SetText("Custom Colors -- click Edit to pick a color. Hit Apply when done.");

    panel.swatchRefs = {};  -- track swatches so we can update them after color pick

    panel.prevCustom = panel.customHdr;
    for _, ck in ipairs(CUSTOM_KEYS) do
        local row = CreateFrame(addon.FRAME, nil, panel.content);
        local swatch = CreateFrame(addon.BUTTON, nil, row, addon.BACKDROP_TEMPLATE);
        local rowLbl = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
        local editBtn = addon.MakeBtn(row, "Edit", 50, 22);
        local key = ck.key;

        row:SetSize(addon.SET_CW - 4, 26);
        swatch:SetSize(22, 22);
        row:SetPoint(addon.TOPLEFT, panel.prevCustom, addon.BOTTOMLEFT, 0, -6);
        swatch:SetPoint(addon.TOPLEFT, row, addon.TOPLEFT, 0, -2);
        rowLbl:SetPoint(addon.LEFT, swatch, addon.RIGHT, 8, 0);
        editBtn:SetPoint(addon.LEFT, rowLbl, addon.RIGHT, 10, 0);
        swatch:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1});
        addon.ApplyColor(swatch, "SetBackdropColor", CT[ck.key]);
        addon.ApplyColor(swatch, "SetBackdropBorderColor", {0.4, 0.4, 0.4});
        addon.ApplyColor(rowLbl, "SetTextColor", CT.bright_text);
        rowLbl:SetText(ck.label);

        editBtn:SetScript(addon.OnClick, function()
            panel:OpenColorPicker(key, swatch);
        end);
        table.insert(panel.swatchRefs, {swatch=swatch, key=ck.key});

        panel.prevCustom = row;
    end

    -- Apply Custom button with confirmation
    panel.applyCustomBtn = addon.MakeBtn(panel.content, "Apply Custom Theme", 220, 30);
    panel.applyCustomBtn:SetPoint(addon.TOPLEFT, panel.prevCustom, addon.BOTTOMLEFT, 0, -12);
    panel.applyCustomBtn:SetScript(addon.OnClick, function()
        StaticPopupDialogs["WSID_CONFIRM_addon.CUSTOM_THEME"] = {
            text = "Apply your custom color theme?\n\nThe UI will reload to apply the new colors.",
            button1 = "Yes, Apply",
            button2 = "Cancel",
            OnAccept = function()
                DB.colorTheme = addon.CUSTOM_THEME;
                -- Write custom colors into C so they survive the reload via DB
                if DB.customColors then
                    addon.ApplyTheme(addon.CUSTOM_THEME, DB.customColors);
                end
                ReloadUI();
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        };
        StaticPopup_Show("WSID_CONFIRM_addon.CUSTOM_THEME");
    end);

    -- Set scroll content height
    panel.content:SetHeight(680);

    return panel;
end
addon.BuildColorsPanel = BuildColorsPanel;