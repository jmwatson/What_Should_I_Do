-- WhatShouldIDo.lua
-- Author: I_AM_T3X | v1.0.0

------------------------------------------------------------------------
-- DATA
------------------------------------------------------------------------

local ADDON_NAME = "WhatShouldIDo"

-- Window / layout constants (single source of truth)
local WIN_W  = 660
local WIN_H  = 520
local NAV_W  = 120
local PAD    = 16
-- Content area width: window - nav - left pad - right pad
local CONT_W = WIN_W - NAV_W - PAD * 2   -- 660-120-32 = 508

------------------------------------------------------------------------
-- ROSTER
------------------------------------------------------------------------

local roster = {}

local function BuildRoster()
    roster = {}
    local name    = UnitName("player")
    local cls, _  = UnitClass("player")
    cls = NormaliseClass(cls)
    local level   = UnitLevel("player")
    local race    = UnitRace("player")
    local faction = UnitFactionGroup("player")
    local found   = false
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name == name then
            s.level=level ; s.class=cls ; s.race=race ; s.faction=faction
            found = true ; break
        end
    end
    if not found then
        table.insert(WhatShouldIDoDB.seenChars, {name=name,class=cls,level=level,race=race,faction=faction})
    end
    -- Normalise any existing entries that may have token-style class names
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        s.class = NormaliseClass(s.class)
    end

    table.insert(roster, {name=name,class=cls,level=level,race=race,faction=faction,current=true})
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name ~= name then table.insert(roster, s) end
    end
end

------------------------------------------------------------------------
-- THEME SYSTEM
------------------------------------------------------------------------

local THEMES = {
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

-- C is the live color table -- starts as Default, swapped by ApplyTheme
local C = {}
for k,v in pairs(THEMES.Default) do C[k] = {v[1],v[2],v[3]} end

local function ApplyTheme(themeName, customColors)
    local src = THEMES[themeName]
    if not src and themeName == "Custom" then
        src = customColors or THEMES.Default
    end
    if not src then src = THEMES.Default end
    for k,v in pairs(src) do
        C[k][1] = v[1] ; C[k][2] = v[2] ; C[k][3] = v[3]
    end
end

------------------------------------------------------------------------
-- SETTINGS WINDOW
------------------------------------------------------------------------

local settingsFrame

------------------------------------------------------------------------
-- INIT
------------------------------------------------------------------------

local initFrame=CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED") ; initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent",function(self,event,arg1)
    if event=="ADDON_LOADED" and arg1==ADDON_NAME then
        InitDB()
        -- Apply saved theme (must run after InitDB sets defaults and after ApplyTheme is defined)
        if WhatShouldIDoDB.colorTheme == "Custom" and next(WhatShouldIDoDB.customColors) then
            ApplyTheme("Custom", WhatShouldIDoDB.customColors)
        else
            ApplyTheme(WhatShouldIDoDB.colorTheme or "Default")
        end
        MainFrame     = BuildMainFrame()
        settingsFrame = BuildSettingsWindow()
        RegisterMinimapButton()
    elseif event=="PLAYER_LOGIN" then
        if WhatShouldIDoDB then BuildRoster() end
    end
end)

SLASH_SPINWHEELS1="/sw" ; SLASH_SPINWHEELS2="/spinwheels" ; SLASH_SPINWHEELS3="/wsid"
SlashCmdList["SPINWHEELS"]=function(msg)
    msg=strtrim(msg)
    local msgL=msg:lower()
    if msgL=="roster" then
        BuildRoster()
        print("|cffd5a742What Should I Do?:|r Roster refreshed -- "..#roster.." character(s).")
        return
    end
    if msgL=="settings" then
        if settingsFrame then
            if settingsFrame:IsShown() then settingsFrame:Hide() else settingsFrame:Show() end
        end
        return
    end
    if MainFrame then
        if MainFrame:IsShown() then MainFrame:Hide() ; if settingsFrame then settingsFrame:Hide() end
        else BuildRoster() ; MainFrame:Show() end
    end
end
