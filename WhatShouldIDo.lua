-- WhatShouldIDo.lua
-- Author: I_AM_T3X | v1.0.0

------------------------------------------------------------------------
-- ROSTER
------------------------------------------------------------------------

local roster = {}

local function BuildRoster()
    roster = {}
    local name    = UnitName(IDENTITY)
    local cls, _  = UnitClass(IDENTITY)
    cls = NormaliseClass(cls)
    local level   = UnitLevel(IDENTITY)
    local race    = UnitRace(IDENTITY)
    local faction = UnitFactionGroup(IDENTITY)
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

-- C is the live color table -- starts as Default, swapped by ApplyTheme
local C = {}
for k,v in pairs(WSID_THEMES.Default) do C[k] = {v[1],v[2],v[3]} end

local function ApplyTheme(themeName, customColors)
    local src = WSID_THEMES[themeName]
    if not src and themeName == CUSTOM then
        src = customColors or WSID_THEMES.Default
    end
    if not src then src = WSID_THEMES.Default end
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

local initFrame=CreateFrame(FRAME)
initFrame:RegisterEvent(ADDON_LOADED)
initFrame:RegisterEvent(PLAYER_LOGIN)
initFrame:SetScript(ONEVENT,function(self,event,arg1)
    if event==ADDON_LOADED and arg1==WSID_ADDON_NAME then
        InitDB()
        -- Apply saved theme (must run after InitDB sets defaults and after ApplyTheme is defined)
        if WhatShouldIDoDB.colorTheme == CUSTOM and next(WhatShouldIDoDB.customColors) then
            ApplyTheme(CUSTOM, WhatShouldIDoDB.customColors)
        else
            ApplyTheme(WhatShouldIDoDB.colorTheme or DEFAULT)
        end
        MainFrame     = BuildMainFrame()
        settingsFrame = BuildSettingsWindow()
        RegisterMinimapButton()
    elseif event==PLAYER_LOGIN then
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
    if MainFrame then
        if MainFrame:IsShown() then MainFrame:Hide()
            if settingsFrame then settingsFrame:Hide() end
        else BuildRoster()
            MainFrame:Show() end
    end
end
