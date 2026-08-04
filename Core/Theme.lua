-- Core/Theme.lua
-- Theme system, color table, ApplyTheme, and all UI primitive helpers
-- Author: I_AM_T3X | v1.0.0

------------------------------------------------------------------------
-- THEME DEFINITIONS
------------------------------------------------------------------------

WSID.DEFAULT_THEME = "Default"
WSID.DEUTERANOPIA = "Deuteranopia"
WSID.PROTANOPIA = "Protanopia"
WSID.TRITANOPIA = "Tritanopia"
WSID.HIGHCONTRAST = "HighContrast"
WSID.CUSTOM_THEME = "Custom"

WSID.THEMES = {
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
}

-- C is the live color table, starts as Default
COLOR_TABLE = {}

WSID.ApplyTheme = function(themeName, customColors)
    local src = WSID.THEMES[themeName]
    if not src and themeName == WSID.CUSTOM_THEME then
        src = customColors or WSID.THEMES.Default
    end
    if not src then src = WSID.THEMES.Default end
    for k, v in pairs(src) do
        COLOR_TABLE[k] = {v[1], v[2], v[3]}
    end
    return COLOR_TABLE
end

WSID.ApplyTheme(WSID.DEFAULT_THEME)

------------------------------------------------------------------------
-- RENDERING HELPERS
------------------------------------------------------------------------

local FLAT = {bgFile=WSID.BG_FILE, edgeFile=WSID.BG_FILE, edgeSize=1}

WSID.Tx = function(f, r, g, b, a)
    local t = f:CreateTexture(nil, WSID.BACKGROUND)
    t:SetAllPoints()
    t:SetColorTexture(r, g, b, a or 1)
    return t
end

WSID.BgBorder = function(f, br, bg_, bb, er, eg, eb)
    f:SetBackdrop(FLAT)
    f:SetBackdropColor(br, bg_, bb, 1)
    f:SetBackdropBorderColor(er, eg, eb, 1)
end

------------------------------------------------------------------------
-- SCROLL BOX
------------------------------------------------------------------------

WSID.MakeScrollBox = function(parent, w, h)
    local bg = CreateFrame(WSID.FRAME, nil, parent, WSID.BACKDROP_TEMPLATE)
    bg:SetHeight(h)
    if w then bg:SetWidth(w) else
        bg:SetPoint(WSID.LEFT,  parent, WSID.LEFT,  WSID.PAD, 0)
        bg:SetPoint(WSID.RIGHT, parent, WSID.RIGHT, -WSID.PAD, 0)
    end
    WSID.BgBorder(bg, COLOR_TABLE.row_even[1],COLOR_TABLE.row_even[2],COLOR_TABLE.row_even[3],
                 COLOR_TABLE.divider[1], COLOR_TABLE.divider[2], COLOR_TABLE.divider[3])
    local clip = CreateFrame(WSID.FRAME, nil, bg)
    clip:SetPoint(WSID.TOPLEFT,     bg, WSID.TOPLEFT,     1, -1)
    clip:SetPoint(WSID.BOTTOMRIGHT, bg, WSID.BOTTOMRIGHT, -1, 1)
    clip:SetClipsChildren(true)
    local content = CreateFrame(WSID.FRAME, nil, clip)
    if w then
        content:SetWidth(w-2)
    else
        -- Stretch content to clip width dynamically
        content:SetPoint(WSID.LEFT,  clip, WSID.LEFT,  0, 0)
        content:SetPoint(WSID.RIGHT, clip, WSID.RIGHT, 0, 0)
    end
    content:SetHeight(h)
    content:SetPoint(WSID.TOPLEFT, clip, WSID.TOPLEFT, 0, 0)
    local scrollOff = 0
    local function Clamp(v,lo,hi) return math.max(lo,math.min(hi,v)) end
    local function Scroll(d)
        scrollOff = Clamp(scrollOff - d*22*2, 0, math.max(0, content:GetHeight()-clip:GetHeight()))
        content:SetPoint(WSID.TOPLEFT, clip, WSID.TOPLEFT, 0, scrollOff)
    end
    bg:EnableMouseWheel(true)
    bg:SetScript(WSID.OnMouseWheel, function(_,d) Scroll(d) end)
    local function ResetScroll()
        scrollOff=0
        content:SetPoint(WSID.TOPLEFT, clip, WSID.TOPLEFT, 0, 0)
    end
    return bg, content, ResetScroll
end

------------------------------------------------------------------------
-- UI PRIMITIVES
------------------------------------------------------------------------

WSID.MakeResult = function(parent, w, h, tagText)
    local f = CreateFrame(WSID.FRAME, nil, parent, WSID.BACKDROP_TEMPLATE)
    f:SetHeight(h or 52)
    -- If w is a number use fixed size; if nil stretch to parent
    if w then f:SetWidth(w) else
        -- caller sets TOPLEFT; we add LEFT+RIGHT for stretch
        f:SetPoint(WSID.LEFT,  parent, WSID.LEFT,  WSID.PAD, 0)
        f:SetPoint(WSID.RIGHT, parent, WSID.RIGHT, -WSID.PAD, 0)
    end
    WSID.BgBorder(f, COLOR_TABLE.result_bg[1],COLOR_TABLE.result_bg[2],COLOR_TABLE.result_bg[3],
                COLOR_TABLE.result_bdr[1],COLOR_TABLE.result_bdr[2],COLOR_TABLE.result_bdr[3])
    if tagText then
        local tag = f:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
        tag:SetPoint(WSID.TOPLEFT, f, WSID.TOPLEFT, 10, -6)
        tag:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
        tag:SetText(tagText)
    end
    local lbl = f:CreateFontString(nil,WSID.OVERLAY)
    lbl:SetFont(WSID.GAME_FONT, 17, WSID.EMPTY_STRING)
    lbl:SetPoint(WSID.CENTER, f, WSID.CENTER, 0, tagText and -4 or 0)
    lbl:SetPoint(WSID.LEFT,  f, WSID.LEFT,  10, 0)
    lbl:SetPoint(WSID.RIGHT, f, WSID.RIGHT, -10, 0)
    lbl:SetJustifyH(WSID.CENTER)
    lbl:SetWordWrap(false)
    lbl:SetText(WSID.DASH_DASH)
    lbl:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    return f, lbl
end

WSID.MakeBtn = function(parent, text, w, h)
    local b = CreateFrame(WSID.BUTTON, nil, parent, WSID.BACKDROP_TEMPLATE)
    b:SetHeight(h or 30)
    if w then b:SetWidth(w) end
    -- RIGHT anchor set by caller when w is nil
    WSID.BgBorder(b, COLOR_TABLE.btn_bg[1],COLOR_TABLE.btn_bg[2],COLOR_TABLE.btn_bg[3], COLOR_TABLE.btn_bdr[1],COLOR_TABLE.btn_bdr[2],COLOR_TABLE.btn_bdr[3])
    local lbl = b:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    lbl:SetAllPoints()
    lbl:SetJustifyH(WSID.CENTER)
    lbl:SetText(text)
    lbl:SetTextColor(COLOR_TABLE.btn_text[1],COLOR_TABLE.btn_text[2],COLOR_TABLE.btn_text[3])
    b:SetScript(WSID.OnEnter, function(s)
        if s:IsEnabled() then
            s:SetBackdropColor(COLOR_TABLE.btn_hover[1],COLOR_TABLE.btn_hover[2],COLOR_TABLE.btn_hover[3])
            s:SetBackdropBorderColor(0.70,0.42,1.00,1)
        end
    end)
    b:SetScript(WSID.OnLeave, function(s)
        if s:IsEnabled() then
            s:SetBackdropColor(COLOR_TABLE.btn_bg[1],COLOR_TABLE.btn_bg[2],COLOR_TABLE.btn_bg[3])
            s:SetBackdropBorderColor(COLOR_TABLE.btn_bdr[1],COLOR_TABLE.btn_bdr[2],COLOR_TABLE.btn_bdr[3],1)
        end
    end)
    b._lbl = lbl
    local origSetEnabled = b.SetEnabled
    b.SetEnabled = function(self, v)
        origSetEnabled(self, v)
        if v then
            self:SetBackdropColor(COLOR_TABLE.btn_bg[1],COLOR_TABLE.btn_bg[2],COLOR_TABLE.btn_bg[3])
            self:SetBackdropBorderColor(COLOR_TABLE.btn_bdr[1],COLOR_TABLE.btn_bdr[2],COLOR_TABLE.btn_bdr[3],1)
            lbl:SetTextColor(COLOR_TABLE.btn_text[1],COLOR_TABLE.btn_text[2],COLOR_TABLE.btn_text[3])
        else
            self:SetBackdropColor(COLOR_TABLE.btn_dis[1],COLOR_TABLE.btn_dis[2],COLOR_TABLE.btn_dis[3])
            self:SetBackdropBorderColor(COLOR_TABLE.btn_dis[1]+0.10,COLOR_TABLE.btn_dis[2]+0.10,COLOR_TABLE.btn_dis[3]+0.10,1)
            lbl:SetTextColor(COLOR_TABLE.dim_text[1]*0.6, COLOR_TABLE.dim_text[2]*0.6, COLOR_TABLE.dim_text[3]*0.6)
        end
    end
    b:SetEnabled(true)
    return b
end

WSID.MakeHeader = function(parent, text, w)
    local f = CreateFrame(WSID.FRAME, nil, parent, WSID.BACKDROP_TEMPLATE)
    f:SetHeight(28)
    if w then f:SetWidth(w) else
        f:SetPoint(WSID.LEFT,  parent, WSID.LEFT,  WSID.PAD, 0)
        f:SetPoint(WSID.RIGHT, parent, WSID.RIGHT, -WSID.PAD, 0)
    end
    WSID.BgBorder(f, COLOR_TABLE.header_bg[1],COLOR_TABLE.header_bg[2],COLOR_TABLE.header_bg[3], COLOR_TABLE.divider[1],COLOR_TABLE.divider[2],COLOR_TABLE.divider[3])
    local stripe = f:CreateTexture(nil,WSID.ARTWORK)
    stripe:SetColorTexture(COLOR_TABLE.nav_border[1],COLOR_TABLE.nav_border[2],COLOR_TABLE.nav_border[3],1)
    stripe:SetSize(3,28)
    stripe:SetPoint(WSID.LEFT,f,WSID.LEFT,0,0)
    local lbl = f:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL)
    lbl:SetPoint(WSID.LEFT,f,WSID.LEFT,12,0)
    lbl:SetText(text)
    lbl:SetTextColor(COLOR_TABLE.header_txt[1],COLOR_TABLE.header_txt[2],COLOR_TABLE.header_txt[3])
    return f
end

WSID.MakeLabel = function(parent, text, anchorFrame, anchorPoint, ox, oy)
    local fs = parent:CreateFontString(nil,WSID.OVERLAY,WSID.NORMAL_SMALL)
    fs:SetPoint(WSID.TOPLEFT, anchorFrame, anchorPoint or WSID.BOTTOMLEFT, ox or 0, oy or -6)
    fs:SetTextColor(COLOR_TABLE.dim_text[1],COLOR_TABLE.dim_text[2],COLOR_TABLE.dim_text[3])
    fs:SetText(text)
    return fs
end

WSID.MakePanel = function(parent)
    local p = CreateFrame(WSID.FRAME, nil, parent)
    p:SetAllPoints(parent)
    p:Hide()
    return p
end
