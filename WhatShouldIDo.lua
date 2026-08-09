-- WhatShouldIDo.lua
-- Author: I_AM_T3X | v1.0.0

------------------------------------------------------------------------
-- ROSTER
------------------------------------------------------------------------

local roster = {}

local function BuildRoster()
    roster = {}
    local name    = UnitName(WSID.IDENTITY)
    local cls, _  = UnitClass(WSID.IDENTITY)
    cls = WSID.NormalizeClass(cls)
    local level   = UnitLevel(WSID.IDENTITY)
    local race    = UnitRace(WSID.IDENTITY)
    local faction = UnitFactionGroup(WSID.IDENTITY)
    local found   = false
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name == name then
            s.level=level
            s.class=cls
            s.race=race
            s.faction=faction
            found = true
            break
        end
    end
    if not found then
        table.insert(WhatShouldIDoDB.seenChars, {name=name,class=cls,level=level,race=race,faction=faction})
    end
    -- Normalise any existing entries that may have token-style class names
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        s.class = WSID.NormalizeClass(s.class)
    end

    table.insert(roster, {name=name,class=cls,level=level,race=race,faction=faction,current=true})
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name ~= name then table.insert(roster, s) end
    end
end

------------------------------------------------------------------------
-- THEME SYSTEM
------------------------------------------------------------------------

-- C is the live color table -- starts as Default, swapped by ApplyTheme
local C = {}
for k,v in pairs(WSID.THEMES.Default) do C[k] = {v[1],v[2],v[3]} end

local function ApplyTheme(themeName, customColors)
    local src = WSID.THEMES[themeName]
    if not src and themeName == WSID.CUSTOM_THEME then
        src = customColors or WSID.THEMES.Default
    end
    if not src then src = WSID.THEMES.Default end
    for k,v in pairs(src) do
        C[k][1] = v[1]
        C[k][2] = v[2]
        C[k][3] = v[3]
    end
end

------------------------------------------------------------------------
-- SETTINGS WINDOW
------------------------------------------------------------------------

local settingsFrame

------------------------------------------------------------------------
-- INIT
------------------------------------------------------------------------

local initFrame=CreateFrame(WSID.FRAME)
initFrame:RegisterEvent(WSID.ADDON_LOADED)
initFrame:RegisterEvent(WSID.PLAYER_LOGIN)
initFrame:SetScript(WSID.OnEvent,function(self,event,arg1)
    if event==WSID.ADDON_LOADED and arg1==WSID.ADDON_NAME then
        WSID.InitDB()
        -- Apply saved theme (must run after InitDB sets defaults and after ApplyTheme is defined)
        if WhatShouldIDoDB.colorTheme == WSID.CUSTOM_THEME and next(WhatShouldIDoDB.customColors) then
            ApplyTheme(WSID.CUSTOM_THEME, WhatShouldIDoDB.customColors)
        else
            ApplyTheme(WhatShouldIDoDB.colorTheme or WSID.DEFAULT_THEME)
        end
        WhatShouldIDoDB.MainFrame     = WSID.BuildMainFrame()
        settingsFrame = WSID.BuildSettingsWindow()
        WSID.RegisterMinimapButton()
    elseif event==WSID.PLAYER_LOGIN then
        if WhatShouldIDoDB then BuildRoster() end
    end
end)

SLASH_SPINWHEELS1="/sw"
SLASH_SPINWHEELS2="/spinwheels"
SLASH_SPINWHEELS3="/wsid"
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
    if WhatShouldIDoDB.MainFrame then
        if WhatShouldIDoDB.MainFrame:IsShown() then WhatShouldIDoDB.MainFrame:Hide()
            if settingsFrame then settingsFrame:Hide() end
        else BuildRoster()
            WhatShouldIDoDB.MainFrame:Show() end
    end
end
