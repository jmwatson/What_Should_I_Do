-- Core/Roster.lua
-- Character roster management
-- Author: I_AM_T3X | v1.0.0

WSID_Roster = {}

WSID.BuildRoster = function()
    WSID_Roster = {}
    local name    = UnitName(WSID.IDENTITY)
    local cls, _  = UnitClass(WSID.IDENTITY)
    local level   = UnitLevel(WSID.IDENTITY)
    local race    = UnitRace(WSID.IDENTITY)
    local faction = UnitFactionGroup(WSID.IDENTITY)
    local found   = false
    cls = WSID.NormalizeClass(cls)
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name == name then
            s.level=level ; s.class=cls ; s.race=race ; s.faction=faction
            found = true ; break
        end
    end
    if not found then
        table.insert(WhatShouldIDoDB.seenChars, {name=name,class=cls,level=level,race=race,faction=faction})
    end
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        s.class = WSID.NormalizeClass(s.class)
    end
    table.insert(WSID_Roster, {name=name,class=cls,level=level,race=race,faction=faction,current=true})
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name ~= name then table.insert(WSID_Roster, s) end
    end
end

WSID.RemoveCharFromRoster = function(charName)
    for i, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name == charName then table.remove(WhatShouldIDoDB.seenChars, i) ; break end
    end
    WSID.BuildRoster()
end
