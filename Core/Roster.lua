-- Core/Roster.lua
-- Character roster management
-- Author: I_AM_T3X | v1.0.0

WSID_Roster = {}

function BuildRoster()
    WSID_Roster = {}
    local name    = UnitName(WSID_IDENTITY)
    local cls, _  = UnitClass(WSID_IDENTITY)
    local level   = UnitLevel(WSID_IDENTITY)
    local race    = UnitRace(WSID_IDENTITY)
    local faction = UnitFactionGroup(WSID_IDENTITY)
    local found   = false
    cls = NormalizeClass(cls)
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
        s.class = NormalizeClass(s.class)
    end
    table.insert(WSID_Roster, {name=name,class=cls,level=level,race=race,faction=faction,current=true})
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name ~= name then table.insert(WSID_Roster, s) end
    end
end

function RemoveCharFromRoster(charName)
    for i, s in ipairs(WhatShouldIDoDB.seenChars) do
        if s.name == charName then table.remove(WhatShouldIDoDB.seenChars, i) ; break end
    end
    BuildRoster()
end
