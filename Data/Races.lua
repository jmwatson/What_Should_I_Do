-- Data/Races.lua
-- Races

HUMAN = "Human"
DWARF = "Dwarf"
NIGHT_ELF = "Night Elf"
GNOME = "Gnome"
DRAENEI = "Draenei"
WORGEN = "Worgen"
ORC = "Orc"
UNDEAD = "Undead"
TAUREN = "Tauren"
TROLL = "Troll"
BLOOD_ELF = "Blood Elf"
GOBLIN = "Goblin"
PANDAREN = "Pandaren"
DRACHTHYR = "Dracthyr"
VOID_ELF = "Void Elf"
LIGHTFORGED_DRAENEI = "Lightforged Draenei"
DARK_IRON_DWARF = "Dark Iron Dwarf"
KUL_TIRAN = "Kul Tiran"
MECHAGNOME = "Mechagnome"
NIGHTBORNE = "Nightborne"
HIGHMOUNTAIN_TAUREN = "Highmountain Tauren"
MAGHAR_ORC = "Maghar Orc"
ZANDALARI_TROLL = "Zandalari Troll"
VULPERA = "Vulpera"
EARTHEN = "Earthen"
HARANIR = "Haranir"

ALLIANCE = "Alliance"
HORDE = "Horde"
NEUTRAL = "Neutral"

CORE = "Core"
ALLIED = "Allied"

WSID_RACE_INFO = {
    [HUMAN] = {name=HUMAN, short_name="HU", faction=ALLIANCE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,PALADIN}},
    [DWARF] = {name=DWARF, short_name="DW", faction=ALLIANCE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN,PALADIN}},
    [NIGHT_ELF] = {name=NIGHT_ELF, short_name="NE", faction=ALLIANCE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,DRUID,DEMON_HUNTER}},
    [GNOME] = {name=GNOME, short_name="GN", faction=ALLIANCE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT}},
    [DRAENEI] = {name=DRAENEI, short_name="DN", faction=ALLIANCE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN,PALADIN}},
    [WORGEN] = {name=WORGEN, short_name="WG", faction=ALLIANCE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,DRUID}},
    [ORC] = {name=ORC, short_name="OR", faction=HORDE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN}},
    [UNDEAD] = {name=UNDEAD, short_name="UD", faction=HORDE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT}},
    [TAUREN] = {name=TAUREN, short_name="TA", faction=HORDE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN,DRUID,PALADIN}},
    [TROLL] = {name=TROLL, short_name="TR", faction=HORDE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN,DRUID}},
    [BLOOD_ELF] = {name=BLOOD_ELF, short_name="BE", faction=HORDE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,PALADIN,DEMON_HUNTER}},
    [GOBLIN] = {name=GOBLIN, short_name="GO", faction=HORDE, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN}},
    [PANDAREN] = {name=PANDAREN, short_name="PA", faction=NEUTRAL, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN}},
    [DRACHTHYR] = {name=DRACHTHYR, short_name="DT", faction=NEUTRAL, rtype=CORE, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,EVOKER}},
    [VOID_ELF] = {name=VOID_ELF, short_name="VE", faction=ALLIANCE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,DEMON_HUNTER}},
    [LIGHTFORGED_DRAENEI] = {name=LIGHTFORGED_DRAENEI, short_name="LD", faction=ALLIANCE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,PALADIN}},
    [DARK_IRON_DWARF] = {name=DARK_IRON_DWARF, short_name="DI", faction=ALLIANCE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN,PALADIN}},
    [KUL_TIRAN] = {name=KUL_TIRAN, short_name="KT", faction=ALLIANCE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN,DRUID}},
    [MECHAGNOME] = {name=MECHAGNOME, short_name="MG", faction=ALLIANCE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT}},
    [NIGHTBORNE] = {name=NIGHTBORNE, short_name="NB", faction=HORDE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT}},
    [HIGHMOUNTAIN_TAUREN] = {name=HIGHMOUNTAIN_TAUREN, short_name="HT", faction=HORDE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN,DRUID}},
    [MAGHAR_ORC] = {name=MAGHAR_ORC, short_name="MO", faction=HORDE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN}},
    [ZANDALARI_TROLL] = {name=ZANDALARI_TROLL, short_name="ZT", faction=HORDE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN,DRUID,PALADIN}},
    [VULPERA] = {name=VULPERA, short_name="VU", faction=HORDE, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,DEATH_KNIGHT,SHAMAN}},
    [EARTHEN] = {name=EARTHEN, short_name="EA", faction=NEUTRAL, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,SHAMAN,PALADIN}},
    [HARANIR] = {name=HARANIR, short_name="HR", faction=NEUTRAL, rtype=ALLIED, classes={WARRIOR,HUNTER,MAGE,PRIEST,ROGUE,WARLOCK,MONK,SHAMAN,DRUID}},
}

function GetRaceNames()
    local names = {}
    for _, race in ipairs(WSID_RACE_INFO) do table.insert(names, race.name) end
    return names
end

function GetRaceShortNames()
    local short_names={}
    for _, race in ipairs(WSID_RACE_INFO) do table.insert(short_names, race.short_name) end
    return short_names
end

function EncodeRace(race)
    if not race or not WSID_RACE_INFO[race] then return WSID_UNKNOWN end
    return WSID_RACE_INFO[race].short_name
end

function GetFaction(race)
    if not race or not WSID_RACE_INFO[race] then return NEUTRAL end
    return WSID_RACE_INFO[race].faction
end

function GetRaceType(race)
    if not race or not WSID_RACE_INFO[race] then return "Core" end
    return WSID_RACE_INFO[race].rtype
end

function GetRaceClasses(race)
    if not race or not WSID_RACE_INFO[race] then return {} end
    return WSID_RACE_INFO[race].classes
end

