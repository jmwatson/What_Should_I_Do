local _, addon = ...;
local DB = addon.DB;

local function CharKey(name, realm)
    return name .. "-" .. realm;
end
addon.CharKey = CharKey;

addon.RegisterMigration(2, function(DB)
    local oldChars = DB.seenChars;

    if not oldChars or next(oldChars) == nil then
        DB.seenChars = {};
        return;
    end

    local currentRealm = GetNormalizedRealmName() or GetRealmName() or "UnknownRealm";
    local playerName = UnitName(addon.IDENTITY);
    local oldExcluded = DB.excludedChars or {};
    local newChars = {};
    local newExcluded = {};

    for _, ch in ipairs(oldChars) do
        local realm = (ch.name == playerName) and currentRealm or "Unknown";
        local key = CharKey(ch.name, realm);

        if not newChars[key] or (ch.level or 0) > (newChars[key].level or 0) then
            ch.realm = realm;
            newChars[key] = ch;
        end

        if oldExcluded[ch.name] then
            newExcluded[key] = true;
        end
    end

    DB.seenChars = newChars;
    DB.excludedChars = newExcluded;
end, "roster (name+realm keys)");

local function BuildRoster()
    local name = UnitName(addon.IDENTITY);
    local realm = GetNormalizedRealmName() or GetRealmName();
    local cls, _ = UnitClass(addon.IDENTITY);
    local level = UnitLevel(addon.IDENTITY);
    local race = UnitRace(addon.IDENTITY);
    local faction = UnitFactionGroup(addon.IDENTITY);
    local key = CharKey(name, realm);
    local existing = DB.seenChars[key];
    cls = addon.NormalizeClass(cls);

    if existing then
        existing.level = level;
        existing.class = cls;
        existing.race = race;
        existing.faction = faction;
        existing.realm = realm;
    else
        DB.seenChars[key] = {
            name = name,
            class = cls,
            level = level,
            race = race,
            faction = faction,
            realm = realm,
        };
    end
end
addon.BuildRoster = BuildRoster;

local function RemoveCharFromRoster(key)
    DB.seenChars[key] = nil;
    addon.BuildRoster();
end
addon.RemoveCharFromRoster = RemoveCharFromRoster;
