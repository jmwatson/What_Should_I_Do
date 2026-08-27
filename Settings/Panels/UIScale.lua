local _, addon = ...;
local DB = addon.DB;
local CT = addon.COLOR_TABLE;

local Options = {
    {label="50%",  val=0.50}, {label="60%",  val=0.60}, {label="70%",  val=0.70},
    {label="80%",  val=0.80}, {label="90%",  val=0.90}, {label="100%", val=1.00},
    {label="110%", val=1.10}, {label="120%", val=1.20}, {label="130%", val=1.30},
    {label="140%", val=1.40}, {label="150%", val=1.50}, {label="160%", val=1.60},
    {label="170%", val=1.70}, {label="180%", val=1.80}, {label="190%", val=1.90},
    {label="200%", val=2.00},
};

local UIScaleMixins = {};

function UIScaleMixins:ApplyScale(val, label)
    DB.uiScale = val;
    self.boxLbl:SetText(label);
    self.dropdown:Hide();
    if DB.MainFrame then
        DB.MainFrame:SetScale(val);
    end
    if DB.SettingsFrame then
        DB.SettingsFrame:SetScale(val);
    end
end

function UIScaleMixins:ShowHide()
    if self.dropdown:IsShown() then
        self.dropdown:Hide();
    else
        self.dropdown:Show();
    end
end

local function BuildUIScalePanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, UIScaleMixins);

    panel.curScale = DB.uiScale or 1.0;
    panel.header = addon.MakeHeader(panel, "UI Scale", addon.SET_CW);
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD);
    panel.desc = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.desc:SetPoint(addon.TOPLEFT, panel.header, addon.BOTTOMLEFT, 4, -8);
    panel.desc:SetText("Scale the addon windows and all text. Changes apply instantly.");
    panel.desc:SetWidth(addon.SET_CW - 8);
    panel.lbl = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.lbl:SetPoint(addon.TOPLEFT, panel.desc, addon.BOTTOMLEFT, 0, -12);
    panel.lbl:SetText("Scale:");
    panel.box = CreateFrame(addon.BUTTON, nil, panel, addon.BACKDROP_TEMPLATE);
    panel.box:SetPoint(addon.LEFT, panel.lbl, addon.RIGHT, 8, 0);
    panel.box:SetSize(100, 26);
    panel.boxLbl = panel.box:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.boxLbl:SetPoint(addon.LEFT, panel.box, addon.LEFT, 8, 0);
    panel.boxLbl:SetText(string.format("%.0f%%", panel.curScale * 100));
    panel.dropdown = CreateFrame(addon.FRAME, nil, panel, addon.BACKDROP_TEMPLATE);
    panel.dropdown:SetPoint(addon.TOPLEFT, panel.box, addon.BOTTOMLEFT, 0, -2);
    panel.dropdown:SetSize(100, #Options * 22);
    panel.dropdown:SetFrameStrata("TOOLTIP");
    panel.dropdown:Hide();
    panel.resetBtn = addon.MakeBtn(panel, "Reset to 100%", 120, 26);
    panel.resetBtn:SetPoint(addon.TOPLEFT, panel.lbl, addon.BOTTOMLEFT, 0, -14);

    addon.ApplyColor(panel.desc, "SetTextColor", CT.dim_text);
    addon.ApplyColor(panel.lbl, "SetTextColor", CT.dim_text);
    addon.ApplyColor(panel.boxLbl, "SetTextColor", CT.bright_text);
    addon.BgBorder(panel.box, CT.result_bg, CT.result_bdr);
    addon.BgBorder(panel.dropdown, CT.bg, CT.win_border);

    for i, opt in ipairs(Options) do
        local row = CreateFrame(addon.BUTTON, nil, panel.dropdown);
        local rowBG = row:CreateTexture(nil,addon.BACKGROUND);
        local isEven = (i%2==0);
        local rowLbl = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
        local scaleVal, scaleLbl = opt.val, opt.label;
        row:SetSize(100, 22);
        row:SetPoint(addon.TOPLEFT, panel.dropdown, addon.TOPLEFT, 0, -(i-1)*22);
        rowLbl:SetPoint(addon.LEFT, row, addon.LEFT, 10, 0);
        rowBG:SetAllPoints();
        addon.ApplyColor(rowBG, "SetColorTexture", isEven and CT.row_even or CT.row_odd);
        addon.ApplyColor(rowLbl, "SetTextColor", opt.val == 1.0 and CT.bright_text or CT.dim_text);
        rowLbl:SetText(opt.label);
        row:SetScript(addon.OnClick,  function()
            panel:ApplyScale(scaleVal, scaleLbl);
        end);
        row:SetScript(addon.OnEnter, function()
            addon.ApplyColor(rowBG, "SetColorTexture", CT.row_hover);
        end);
        row:SetScript(addon.OnLeave, function()
            addon.ApplyColor(rowBG, "SetColorTexture", isEven and CT.row_even or CT.row_odd);
        end);
    end

    panel.box:SetScript(addon.OnClick, function() panel:ShowHide(); end);
    panel.resetBtn:SetScript(addon.OnClick, function() panel:ApplyScale(1.0, "100%"); end);
end
addon.BuildUIScalePanel = BuildUIScalePanel;