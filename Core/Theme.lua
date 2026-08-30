local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

------------------------------------------------------------------------
-- THEME DEFINITIONS
------------------------------------------------------------------------

addon.DEFAULT_THEME = "Default";
addon.DEUTERANOPIA = "Deuteranopia";
addon.PROTANOPIA = "Protanopia";
addon.TRITANOPIA = "Tritanopia";
addon.HIGHCONTRAST = "HighContrast";
addon.CUSTOM_THEME = "Custom";

addon.THEMES = {
    Default = {
        bg          = {0.058, 0.048, 0.075},
        sidebar     = {0.040, 0.032, 0.058},
        nav_hover   = {0.14,  0.10,  0.22},
        nav_active  = {0.18,  0.10,  0.32},
        nav_border  = {0.55,  0.28,  0.90},
        header_bg   = {0.14,  0.08,  0.24},
        header_txt  = {0.82,  0.65,  1.00},
        row_even    = {0.08,  0.06,  0.11},
        row_odd     = {0.06,  0.04,  0.09},
        row_hover   = {0.18,  0.12,  0.28},
        row_select  = {0.22,  0.12,  0.38},
        result_bg   = {0.05,  0.03,  0.10},
        result_bdr  = {0.44,  0.22,  0.72},
        btn_bg      = {0.16,  0.08,  0.28},
        btn_bdr     = {0.50,  0.28,  0.80},
        btn_hover   = {0.24,  0.12,  0.40},
        btn_text    = {0.88,  0.72,  1.00},
        btn_dis     = {0.09,  0.06,  0.14},
        dim_text    = {0.50,  0.44,  0.62},
        bright_text = {0.92,  0.86,  1.00},
        spin_text   = {0.78,  0.55,  1.00},
        win_border  = {0.28,  0.16,  0.44},
        divider     = {0.18,  0.12,  0.28},
    },
    -- Deuteranopia: red-green blind -- replace purples with blues/cyans
    Deuteranopia = {
        bg          = {0.04,  0.06,  0.12},
        sidebar     = {0.03,  0.04,  0.09},
        nav_hover   = {0.08,  0.14,  0.26},
        nav_active  = {0.06,  0.18,  0.36},
        nav_border  = {0.20,  0.60,  1.00},
        header_bg   = {0.06,  0.12,  0.24},
        header_txt  = {0.55,  0.88,  1.00},
        row_even    = {0.06,  0.08,  0.14},
        row_odd     = {0.04,  0.06,  0.11},
        row_hover   = {0.10,  0.18,  0.32},
        row_select  = {0.08,  0.22,  0.44},
        result_bg   = {0.03,  0.05,  0.12},
        result_bdr  = {0.20,  0.55,  0.90},
        btn_bg      = {0.06,  0.14,  0.30},
        btn_bdr     = {0.22,  0.55,  0.90},
        btn_hover   = {0.10,  0.22,  0.44},
        btn_text    = {0.65,  0.90,  1.00},
        btn_dis     = {0.05,  0.07,  0.14},
        dim_text    = {0.44,  0.55,  0.70},
        bright_text = {0.86,  0.94,  1.00},
        spin_text   = {0.40,  0.82,  1.00},
        win_border  = {0.14,  0.30,  0.55},
        divider     = {0.10,  0.18,  0.34},
    },
    -- Protanopia: red blind -- similar to deuteranopia, heavier blue shift
    Protanopia = {
        bg          = {0.04,  0.05,  0.10},
        sidebar     = {0.03,  0.04,  0.08},
        nav_hover   = {0.07,  0.12,  0.24},
        nav_active  = {0.05,  0.16,  0.34},
        nav_border  = {0.15,  0.65,  0.95},
        header_bg   = {0.05,  0.10,  0.22},
        header_txt  = {0.50,  0.85,  1.00},
        row_even    = {0.05,  0.07,  0.13},
        row_odd     = {0.04,  0.05,  0.10},
        row_hover   = {0.09,  0.16,  0.30},
        row_select  = {0.07,  0.20,  0.42},
        result_bg   = {0.03,  0.04,  0.10},
        result_bdr  = {0.15,  0.60,  0.92},
        btn_bg      = {0.05,  0.12,  0.28},
        btn_bdr     = {0.18,  0.58,  0.92},
        btn_hover   = {0.09,  0.20,  0.42},
        btn_text    = {0.60,  0.88,  1.00},
        btn_dis     = {0.04,  0.06,  0.13},
        dim_text    = {0.42,  0.54,  0.68},
        bright_text = {0.84,  0.92,  1.00},
        spin_text   = {0.35,  0.80,  1.00},
        win_border  = {0.12,  0.28,  0.52},
        divider     = {0.09,  0.16,  0.32},
    },
    -- Tritanopia: blue-yellow blind -- use orange/red accents instead of blue/purple
    Tritanopia = {
        bg          = {0.10,  0.06,  0.04},
        sidebar     = {0.08,  0.04,  0.03},
        nav_hover   = {0.22,  0.12,  0.06},
        nav_active  = {0.32,  0.14,  0.05},
        nav_border  = {0.95,  0.55,  0.10},
        header_bg   = {0.22,  0.10,  0.04},
        header_txt  = {1.00,  0.80,  0.40},
        row_even    = {0.12,  0.08,  0.06},
        row_odd     = {0.09,  0.06,  0.04},
        row_hover   = {0.28,  0.14,  0.06},
        row_select  = {0.36,  0.16,  0.06},
        result_bg   = {0.08,  0.04,  0.03},
        result_bdr  = {0.80,  0.42,  0.08},
        btn_bg      = {0.26,  0.10,  0.04},
        btn_bdr     = {0.88,  0.48,  0.10},
        btn_hover   = {0.38,  0.16,  0.06},
        btn_text    = {1.00,  0.82,  0.50},
        btn_dis     = {0.12,  0.07,  0.05},
        dim_text    = {0.62,  0.48,  0.36},
        bright_text = {1.00,  0.92,  0.80},
        spin_text   = {1.00,  0.72,  0.20},
        win_border  = {0.48,  0.24,  0.08},
        divider     = {0.28,  0.14,  0.06},
    },
    -- High Contrast: white/black/yellow for maximum readability
    HighContrast = {
        bg          = {0.02,  0.02,  0.02},
        sidebar     = {0.05,  0.05,  0.05},
        nav_hover   = {0.20,  0.20,  0.20},
        nav_active  = {0.25,  0.25,  0.00},
        nav_border  = {1.00,  1.00,  0.00},
        header_bg   = {0.15,  0.15,  0.15},
        header_txt  = {1.00,  1.00,  0.00},
        row_even    = {0.10,  0.10,  0.10},
        row_odd     = {0.06,  0.06,  0.06},
        row_hover   = {0.25,  0.25,  0.25},
        row_select  = {0.30,  0.30,  0.00},
        result_bg   = {0.00,  0.00,  0.00},
        result_bdr  = {1.00,  1.00,  0.00},
        btn_bg      = {0.15,  0.15,  0.15},
        btn_bdr     = {1.00,  1.00,  0.00},
        btn_hover   = {0.30,  0.30,  0.00},
        btn_text    = {1.00,  1.00,  0.00},
        btn_dis     = {0.08,  0.08,  0.08},
        dim_text    = {0.70,  0.70,  0.70},
        bright_text = {1.00,  1.00,  1.00},
        spin_text   = {1.00,  1.00,  0.00},
        win_border  = {1.00,  1.00,  0.00},
        divider     = {0.40,  0.40,  0.40},
    },
};

local function Clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v));
end

-- Starts as Default

local function ApplyTheme(themeName, customColors)
    local src = addon.THEMES[themeName];
    if not src and themeName == addon.CUSTOM_THEME then
        src = customColors or addon.THEMES.Default;
    end
    if not src then src = addon.THEMES.Default end
    for k, v in pairs(src) do
        CT[k] = {v[1], v[2], v[3]};
    end
    return CT;
end
addon.ApplyTheme = ApplyTheme;

ApplyTheme(addon.DEFAULT_THEME);

------------------------------------------------------------------------
-- COLOR HELPERS
------------------------------------------------------------------------

---@alias ColorTable number[]
---@class RGB
---@field r number
---@field g number
---@field b number

-- Applies a {r,g,b} color table to any Set*Color-style method, e.g.:
--   addon.ApplyColor(texture, "SetColorTexture", CT.row_even)
--   addon.ApplyColor(frame, "SetBackdropBorderColor", CT.divider, 1)comment
---@param obj Region
---@param method string
---@param colorTable ColorTable
---@param alpha? number
local function ApplyColor(obj, method, colorTable, alpha)
    obj[method](obj, colorTable[1], colorTable[2], colorTable[3], alpha or 1);
end
addon.ApplyColor = ApplyColor;

---@param obj Region
---@param method string
---@param rgb RGB
---@param alpha? number
local function ApplyRGB(obj, method, rgb, alpha)
    obj[method](obj, rgb.r, rgb.b, rgb.g, alpha or 1);
end
addon.ApplyRGB = ApplyRGB;

---@param left ColorTable
---@param right ColorTable
---@return ColorTable
local function AddColor(left, right)
    return {left[1] + right[1], left[2] + right[2], left[3] + right[3]};
end
addon.AddColor = AddColor;

---@param left ColorTable
---@param right ColorTable
---@return ColorTable
local function MulColor(left, right)
    return {left[1] * right[1], left[2] * right[2], left[3] * right[3]};
end
addon.MulColor = MulColor;

---@param left RGB
---@param right RGB
---@return RGB
local function AddRGB(left, right)
    return {r=left.r + right.r, g=left.g + right.g, b=left.b + right.b};
end
addon.AddRGB = AddRGB;

---@param left RGB
---@param right RGB
---@return RGB
local function MulRGB(left, right)
    return {r=left.r * right.r, g=left.g * right.g, b=left.b * right.b};
end
addon.MulRGB = MulRGB;

---@param left RGB
---@param right ColorTable
---@return RGB
local function AddRGBL(left, right)
    return {r=left.r + right[1], g=left.g + right[2], b=left.b + right[3]};
end
addon.AddRGBL = AddRGBL;

---@param left RGB
---@param right ColorTable
---@return RGB
local function MulRGBL(left, right)
    return {r=left.r * right[1], g=left.g * right[2], b=left.b * right[3]};
end
addon.MulRGBL = MulRGBL;

---@param left ColorTable
---@param right RGB
---@return ColorTable
local function AddRGBR(left, right)
    return {left[1] + right.r, left[2] + right.g, left[3] + right.b};
end
addon.AddRGBR = AddRGBR;

---@param left ColorTable
---@param right RGB
---@return ColorTable
local function MulRGBR(left, right)
    return {left[1] * right.r, left[2] * right.g, left[3] * right.b};
end
addon.MulRGBR = MulRGBR;

------------------------------------------------------------------------
-- RENDERING HELPERS
------------------------------------------------------------------------

local FLAT = {bgFile=addon.BG_FILE, edgeFile=addon.BG_FILE, edgeSize=1};

local function Tx(parent, color, alpha)
    local texture = parent:CreateTexture(nil, addon.BACKGROUND);
    texture:SetAllPoints();
    ApplyColor(texture, "SetColorTexture", color, alpha);
    return texture;
end
addon.Tx = Tx;

local function BgBorder(element, bgColor, bgBorderColor)
    element:SetBackdrop(FLAT);
    ApplyColor(element, "SetBackdropColor", bgColor);
    ApplyColor(element, "SetBackdropBorderColor", bgBorderColor);
end
addon.BgBorder = BgBorder;

------------------------------------------------------------------------
-- SCROLL BOX
------------------------------------------------------------------------

function addon.MakeScrollBox(parent, w, h)
    local bg = CreateFrame(addon.FRAME, nil, parent, addon.BACKDROP_TEMPLATE);
    local clip = CreateFrame(addon.FRAME, nil, bg);
    local content = CreateFrame(addon.FRAME, nil, clip);
    local scrollOff = 0;
    
    local function Scroll(d)
        scrollOff = Clamp(scrollOff - d*22*2, 0, math.max(0, content:GetHeight()-clip:GetHeight()));
        content:SetPoint(addon.TOPLEFT, clip, addon.TOPLEFT, 0, scrollOff);
    end

    local function ResetScroll()
        scrollOff = 0;
        content:SetPoint(addon.TOPLEFT, clip, addon.TOPLEFT, 0, 0);
    end

    if w then
        bg:SetWidth(w);
        content:SetWidth(w-2);
    else
        bg:SetPoint(addon.LEFT,  parent, addon.LEFT,  addon.PAD, 0);
        bg:SetPoint(addon.RIGHT, parent, addon.RIGHT, -addon.PAD, 0);
        -- Stretch content to clip width dynamically
        content:SetPoint(addon.LEFT, clip, addon.LEFT, 0, 0);
        content:SetPoint(addon.RIGHT, clip, addon.RIGHT, 0, 0);
    end
    
    BgBorder(bg, CT.row_even, CT.divider);
    bg:SetHeight(h);
    clip:SetPoint(addon.TOPLEFT, bg, addon.TOPLEFT, 1, -1);
    clip:SetPoint(addon.BOTTOMRIGHT, bg, addon.BOTTOMRIGHT, -1, 1);
    content:SetPoint(addon.TOPLEFT, clip, addon.TOPLEFT, 0, 0);
    clip:SetClipsChildren(true);
    content:SetHeight(h);
    bg:EnableMouseWheel(true);
    bg:SetScript(addon.OnMouseWheel, function(_,d) Scroll(d) end);

    return bg, content, ResetScroll;
end

------------------------------------------------------------------------
-- UI PRIMITIVES
------------------------------------------------------------------------

local function MakeResult(parent, w, h, tagText)
    local frame = CreateFrame(addon.FRAME, nil, parent, addon.BACKDROP_TEMPLATE);
    local label = frame:CreateFontString(nil,addon.OVERLAY);
    
    -- If w is a number use fixed size; if nil stretch to parent
    if w then frame:SetWidth(w) else
        -- caller sets TOPLEFT; we add LEFT+RIGHT for stretch
        frame:SetPoint(addon.LEFT,  parent, addon.LEFT,  addon.PAD, 0);
        frame:SetPoint(addon.RIGHT, parent, addon.RIGHT, -addon.PAD, 0);
    end
    
    
    if tagText then
        local tag = frame:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
        tag:SetPoint(addon.TOPLEFT, frame, addon.TOPLEFT, 10, -6);
        tag:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
        tag:SetText(tagText);
    end
    
    BgBorder(frame, CT.result_bg, CT.result_bdr);
    frame:SetHeight(h or 52);
    label:SetFont(addon.GAME_FONT, 17, addon.EMPTY_STRING);
    label:SetPoint(addon.CENTER, frame, addon.CENTER, 0, tagText and -4 or 0);
    label:SetPoint(addon.LEFT,  frame, addon.LEFT,  10, 0);
    label:SetPoint(addon.RIGHT, frame, addon.RIGHT, -10, 0);
    label:SetJustifyH(addon.CENTER);
    label:SetWordWrap(false);
    label:SetText(addon.DASH_DASH);
    label:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
    
    return frame, label;
end
addon.MakeResult = MakeResult;

local function MakeBtn(parent, text, w, h)
    local button = CreateFrame(addon.BUTTON, nil, parent, addon.BACKDROP_TEMPLATE);
    local label = button:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    local origSetEnabled = button.SetEnabled;

    local function ButtonSetEnabled(self, v)
        origSetEnabled(self, v);
        if v then
            ApplyColor(self, "SetBackdropColor", CT.btn_bg);
            ApplyColor(self, "SetBackdropBorderColor", CT.btn_bdr);
            ApplyColor(label, "SetTextColor", CT.btn_text);
        else
            ApplyColor(self, "SetBackdropColor", CT.btn_dis);
            ApplyColor(self, "SetBackdropBorderColor", AddColor(CT.btn_dis, {0.1, 0.1, 0.1}));
            ApplyColor(label, "SetTextColor", AddColor(CT.dim_text, {0.6, 0.6, 0.6}));
        end
    end

    if w then
        button:SetWidth(w);
    end
    
    -- RIGHT anchor set by caller when w is nil
    BgBorder(button, CT.btn_bg, CT.btn_bdr);
    label:SetAllPoints();
    label:SetJustifyH(addon.CENTER);
    label:SetText(text);
    ApplyColor(label, "SetTextColor", CT.btn_text);
    button.SetEnabled = ButtonSetEnabled;
    button:SetHeight(h or 30);
    button._lbl = label;
    button:SetScript(addon.OnEnter, function(s)
        if s:IsEnabled() then
            ApplyColor(s, "SetBackdropColor", CT.btn_hover);
            ApplyColor(s, "SetBackdropBorderColor", {0.70, 0.42, 1.00}, 1);
        end
    end);
    button:SetScript(addon.OnLeave, function(s)
        if s:IsEnabled() then
            ApplyColor(s, "SetBackdropColor", CT.btn_bg);
            ApplyColor(s, "SetBackdropBorderColor", CT.btn_bdr);
        end
    end);
    button:SetEnabled(true);

    return button;
end
addon.MakeBtn = MakeBtn;

local function MakeHeader(parent, text, w)
    local header = CreateFrame(addon.FRAME, nil, parent, addon.BACKDROP_TEMPLATE);
    local stripe = header:CreateTexture(nil,addon.ARTWORK);
    local label = header:CreateFontString(nil,addon.OVERLAY,addon.NORMAL);

    if w then header:SetWidth(w) else
        header:SetPoint(addon.LEFT,  parent, addon.LEFT,  addon.PAD, 0);
        header:SetPoint(addon.RIGHT, parent, addon.RIGHT, -addon.PAD, 0);
    end

    BgBorder(header, CT.header_bg, CT.divider);
    header:SetHeight(28);
    ApplyColor(stripe, "SetColorTexture", CT.nav_border);
    stripe:SetSize(3,28);
    stripe:SetPoint(addon.LEFT,header,addon.LEFT,0,0);
    label:SetPoint(addon.LEFT,header,addon.LEFT,12,0);
    label:SetText(text);
    label:SetTextColor(CT.header_txt[1],CT.header_txt[2],CT.header_txt[3]);
    
    return header;
end
addon.MakeHeader = MakeHeader;

local function MakeLabel(parent, text, anchorFrame, anchorPoint, ox, oy)
    local fontString = parent:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    fontString:SetPoint(addon.TOPLEFT, anchorFrame, anchorPoint or addon.BOTTOMLEFT, ox or 0, oy or -6)
    fontString:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3])
    fontString:SetText(text)
    return fontString
end
addon.MakeLabel = MakeLabel;

local function MakePanel(parent)
    local panel = CreateFrame(addon.FRAME, nil, parent)
    panel:SetAllPoints(parent)
    panel:Hide()
    return panel
end
addon.MakePanel = MakePanel;

------------------------------------------------------------------------
-- POOLED ROW HELPER
------------------------------------------------------------------------

-- Acquires a row from `pool`, running `buildFn(row)` exactly once per
-- physical frame (the first time it's ever acquired) to construct its
-- child widgets, then returning it every time after without rebuilding
-- anything. Callers are responsible for updating per-refresh state
-- (text, colors, anchors) on the returned row after this call.
local function AcquirePooledRow(pool, buildFn)
    local row = pool:Acquire();
    if not row._built then
        buildFn(row);
        row._built = true;
    end
    return row;
end
addon.AcquirePooledRow = AcquirePooledRow;
