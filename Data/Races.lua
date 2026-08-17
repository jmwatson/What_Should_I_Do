local _, addon = ...;

addon.HUMAN = "Human";
addon.DWARF = "Dwarf";
addon.NIGHT_ELF = "Night Elf";
addon.GNOME = "Gnome";
addon.DRAENEI = "Draenei";
addon.WORGEN = "Worgen";
addon.ORC = "Orc";
addon.UNDEAD = "Undead";
addon.TAUREN = "Tauren";
addon.TROLL = "Troll";
addon.BLOOD_ELF = "Blood Elf";
addon.GOBLIN = "Goblin";
addon.PANDAREN = "Pandaren";
addon.DRACHTHYR = "Dracthyr";
addon.VOID_ELF = "Void Elf";
addon.LIGHTFORGED_DRAENEI = "Lightforged Draenei";
addon.DARK_IRON_DWARF = "Dark Iron Dwarf";
addon.KUL_TIRAN = "Kul Tiran";
addon.MECHAGNOME = "Mechagnome";
addon.NIGHTBORNE = "Nightborne";
addon.HIGHMOUNTAIN_TAUREN = "Highmountain Tauren";
addon.MAGHAR_ORC = "Maghar Orc";
addon.ZANDALARI_TROLL = "Zandalari Troll";
addon.VULPERA = "Vulpera";
addon.EARTHEN = "Earthen";
addon.HARANIR = "Haranir";

addon.ALLIANCE = "Alliance";
addon.HORDE = "Horde";
addon.NEUTRAL = "Neutral";

addon.CORE_RACE = "Core";
addon.ALLIED_RACE = "Allied";

addon.RACE_INFO = {
    [addon.HUMAN] = {name=addon.HUMAN, short_name="HU", faction=addon.ALLIANCE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.PALADIN}},
    [addon.DWARF] = {name=addon.DWARF, short_name="DW", faction=addon.ALLIANCE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN,addon.PALADIN}},
    [addon.NIGHT_ELF] = {name=addon.NIGHT_ELF, short_name="NE", faction=addon.ALLIANCE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.DRUID,addon.DEMON_HUNTER}},
    [addon.GNOME] = {name=addon.GNOME, short_name="GN", faction=addon.ALLIANCE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT}},
    [addon.DRAENEI] = {name=addon.DRAENEI, short_name="DN", faction=addon.ALLIANCE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN,addon.PALADIN}},
    [addon.WORGEN] = {name=addon.WORGEN, short_name="WG", faction=addon.ALLIANCE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.DRUID}},
    [addon.ORC] = {name=addon.ORC, short_name="OR", faction=addon.HORDE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN}},
    [addon.UNDEAD] = {name=addon.UNDEAD, short_name="UD", faction=addon.HORDE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT}},
    [addon.TAUREN] = {name=addon.TAUREN, short_name="TA", faction=addon.HORDE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN,addon.DRUID,addon.PALADIN}},
    [addon.TROLL] = {name=addon.TROLL, short_name="TR", faction=addon.HORDE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN,addon.DRUID}},
    [addon.BLOOD_ELF] = {name=addon.BLOOD_ELF, short_name="BE", faction=addon.HORDE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.PALADIN,addon.DEMON_HUNTER}},
    [addon.GOBLIN] = {name=addon.GOBLIN, short_name="GO", faction=addon.HORDE, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN}},
    [addon.PANDAREN] = {name=addon.PANDAREN, short_name="PA", faction=addon.NEUTRAL, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN}},
    [addon.DRACHTHYR] = {name=addon.DRACHTHYR, short_name="DT", faction=addon.NEUTRAL, rtype=addon.CORE_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.EVOKER}},
    [addon.VOID_ELF] = {name=addon.VOID_ELF, short_name="VE", faction=addon.ALLIANCE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.DEMON_HUNTER}},
    [addon.LIGHTFORGED_DRAENEI] = {name=addon.LIGHTFORGED_DRAENEI, short_name="LD", faction=addon.ALLIANCE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.PALADIN}},
    [addon.DARK_IRON_DWARF] = {name=addon.DARK_IRON_DWARF, short_name="DI", faction=addon.ALLIANCE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN,addon.PALADIN}},
    [addon.KUL_TIRAN] = {name=addon.KUL_TIRAN, short_name="KT", faction=addon.ALLIANCE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN,addon.DRUID}},
    [addon.MECHAGNOME] = {name=addon.MECHAGNOME, short_name="MG", faction=addon.ALLIANCE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT}},
    [addon.NIGHTBORNE] = {name=addon.NIGHTBORNE, short_name="NB", faction=addon.HORDE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT}},
    [addon.HIGHMOUNTAIN_TAUREN] = {name=addon.HIGHMOUNTAIN_TAUREN, short_name="HT", faction=addon.HORDE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN,addon.DRUID}},
    [addon.MAGHAR_ORC] = {name=addon.MAGHAR_ORC, short_name="MO", faction=addon.HORDE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN}},
    [addon.ZANDALARI_TROLL] = {name=addon.ZANDALARI_TROLL, short_name="ZT", faction=addon.HORDE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN,addon.DRUID,addon.PALADIN}},
    [addon.VULPERA] = {name=addon.VULPERA, short_name="VU", faction=addon.HORDE, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.DEATH_KNIGHT,addon.SHAMAN}},
    [addon.EARTHEN] = {name=addon.EARTHEN, short_name="EA", faction=addon.NEUTRAL, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.SHAMAN,addon.PALADIN}},
    [addon.HARANIR] = {name=addon.HARANIR, short_name="HR", faction=addon.NEUTRAL, rtype=addon.ALLIED_RACE, classes={addon.WARRIOR,addon.HUNTER,addon.MAGE,addon.PRIEST,addon.ROGUE,addon.WARLOCK,addon.MONK,addon.SHAMAN,addon.DRUID}},
};

local function GetRaceNames()
    local names = {};
    for _, race in ipairs(addon.RACE_INFO) do table.insert(names, race.name); end
    return names;
end
addon.GetRaceNames = GetRaceNames;

local function GetRaceShortNames()
    local short_names={};
    for _, race in ipairs(addon.RACE_INFO) do table.insert(short_names, race.short_name); end
    return short_names;
end
addon.GetRaceShortNames = GetRaceShortNames;

local function EncodeRace(race)
    if not race or not addon.RACE_INFO[race] then return addon.UNKNOWN; end
    return addon.RACE_INFO[race].short_name;
end
addon.EncodeRace = EncodeRace;

local function GetFaction(race)
    if not race or not addon.RACE_INFO[race] then return addon.NEUTRAL; end
    return addon.RACE_INFO[race].faction;
end
addon.GetFaction = GetFaction;

local function GetRaceType(race)
    if not race or not addon.RACE_INFO[race] then return addon.CORE_RACE; end
    return addon.RACE_INFO[race].rtype;
end
addon.GetRaceType = GetRaceType;

local function GetRaceClasses(race)
    if not race or not addon.RACE_INFO[race] then return {}; end
    return addon.RACE_INFO[race].classes;
end
addon.GetRaceClasses = GetRaceClasses;
