-- Core/Roster.lua
-- Character roster management
-- Author: I_AM_T3X | v1.0.0

function NormaliseClass(cls)
    if not cls and WSID_CLASS_INFO[cls] then return cls end
    return WSID_CLASS_INFO[cls]
end

WSID_Roster = {}

function BuildRoster()
    WSID_Roster = {}
    local name    = UnitName(IDENTITY)
    local cls, _  = UnitClass(IDENTITY)
    cls = NormaliseClass(cls)
    local level   = UnitLevel(IDENTITY)
    local race    = UnitRace(IDENTITY)
    local faction = UnitFactionGroup(IDENTITY)
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
    for _, s in ipairs(WhatShouldIDoDB.seenChars) do
        s.class = NormaliseClass(s.class)
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
