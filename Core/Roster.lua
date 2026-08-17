local _, addon = ...;
local DB = addon.DB;

addon.Roster = {}

local function BuildRoster()
    local name = UnitName(addon.IDENTITY);
    local cls, _ = UnitClass(addon.IDENTITY);
    local level = UnitLevel(addon.IDENTITY);
    local race = UnitRace(addon.IDENTITY);
    local faction = UnitFactionGroup(addon.IDENTITY);
    local found = false;
    cls = addon.NormalizeClass(cls);
    
    for _, s in ipairs(DB.seenChars) do
        if s.name == name then
            s.level=level;
            s.class=cls;
            s.race=race;
            s.faction=faction
            found = true;
            break;
        end
    end
    
    if not found then
        table.insert(DB.seenChars, {name=name, class=cls, level=level, race=race, faction=faction});
    end
end
addon.BuildRoster = BuildRoster;

local function RemoveCharFromRoster(charName)
    for i, s in ipairs(DB.seenChars) do
        if s.name == charName then
            table.remove(DB.seenChars, i);
            break;
        end
    end
    addon.BuildRoster();
end
addon.RemoveCharFromRoster = RemoveCharFromRoster;
