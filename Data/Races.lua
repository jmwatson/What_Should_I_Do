-- Data/Races.lua
-- Race, class, and color data

WSID_RACES = {
    HUMAN = 0,
    DWARF = 1,
    NIGHT_ELF = 2,
    GNOME = 3,
    DRAENEI = 4,
    WORGEN = 5,
    ORC = 6,
    UNDEAD = 7,
    TAUREN = 8,
    TROLL = 9,
    BLOOD_ELF = 10,
    GOBLIN = 11,
    PANDAREN = 12,
    DRACHTHYR = 13,
    VOID_ELF = 14,
    LIGHTFORGED_DRAENEI = 15,
    DARK_IRON_DWARF = 16,
    KUL_TIRAN = 17,
    MECHAGNOME = 18,
    NIGHTBORNE = 19,
    HIGHMOUNTAIN_TAUREN = 20,
    MAGHAR_ORC = 21,
    ZANDALARI_TROLL = 22,
    VULPERA = 23,
    EARTHEN = 24,
    HARANIR = 25,
}

WSID_RACE_INFO = {
    {name="Human", short_name="HU", faction="Alliance", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.PALADIN},},
    {name="Dwarf", short_name="DW", faction="Alliance", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN, WSID_CLASSES.PALADIN},},
    {name="Night Elf", short_name="NE", faction="Alliance", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.DRUID, WSID_CLASSES.DEMON_HUNTER},},
    {name="Gnome", short_name="GN", faction="Alliance", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT},},
    {name="Draenei", short_name="DN", faction="Alliance", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN, WSID_CLASSES.PALADIN},},
    {name="Worgen", short_name="WG", faction="Alliance", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.DRUID},},
    {name="Orc", short_name="OR", faction="Horde", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN},},
    {name="Undead", short_name="UD", faction="Horde", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT},},
    {name="Tauren", short_name="TA", faction="Horde", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN, WSID_CLASSES.DRUID, WSID_CLASSES.PALADIN},},
    {name="Troll", short_name="TR", faction="Horde", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN, WSID_CLASSES.DRUID},},
    {name="Blood Elf", short_name="BE", faction="Horde", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.PALADIN, WSID_CLASSES.DEMON_HUNTER},},
    {name="Goblin", short_name="GO", faction="Horde", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN},},
    {name="Pandaren", short_name="PA", faction="Neutral", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN},},
    {name="Dracthyr", short_name="DT", faction="Neutral", rtype="Core", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.EVOKER},},
    {name="Void Elf", short_name="VE", faction="Alliance", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.DEMON_HUNTER},},
    {name="Lightforged Draenei", short_name="LD", faction="Alliance", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.PALADIN},},
    {name="Dark Iron Dwarf", short_name="DI", faction="Alliance", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN, WSID_CLASSES.PALADIN},},
    {name="Kul Tiran", short_name="KT", faction="Alliance", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN, WSID_CLASSES.DRUID},},
    {name="Mechagnome", short_name="MG", faction="Alliance", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT},},
    {name="Nightborne", short_name="NB", faction="Horde", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT},},
    {name="Highmountain Tauren", short_name="HT", faction="Horde", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN, WSID_CLASSES.DRUID},},
    {name="Mag'har Orc", short_name="MO", faction="Horde", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN},},
    {name="Zandalari Troll", short_name="ZT", faction="Horde", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN, WSID_CLASSES.DRUID, WSID_CLASSES.PALADIN},},
    {name="Vulpera", short_name="VU", faction="Horde", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.DEATH_KNIGHT, WSID_CLASSES.SHAMAN},},
    {name="Earthen", short_name="EA", faction="Neutral", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.SHAMAN, WSID_CLASSES.PALADIN},},
    {name="Haranir", short_name="HR", faction="Neutral", rtype="Allied", classes={WSID_CLASSES.WARRIOR, WSID_CLASSES.HUNTER, WSID_CLASSES.MAGE, WSID_CLASSES.PRIEST, WSID_CLASSES.ROGUE, WSID_CLASSES.WARLOCK, WSID_CLASSES.MONK, WSID_CLASSES.SHAMAN, WSID_CLASSES.DRUID},},
}

function GetRaceNames()
    local names={}
    for _,r in ipairs(WSID_RACE_INFO) do table.insert(names, r.name) end
    return names
end

function GetRaceShortNames()
    local short_names={}
    for _,r in ipairs(WSID_RACE_INFO) do table.insert(short_names, r.short_name) end
    return short_names
end

function EncodeRace(race)
    if not race or not WSID_RACE_INFO[race] then return "??" end
    return WSID_RACE_INFO[race].short_name
end

function GetFaction(race)
    if not race or not WSID_RACE_INFO[race] then return "Neutral" end
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

WSID_CLASSES = {
    DEATH_KNIGHT = 0,
    DEMON_HUNTER = 1,
    DRUID = 2,
    EVOKER = 3,
    HUNTER = 4,
    MAGE = 5,
    MONK = 6,
    PALADIN = 7,
    PRIEST = 8,
    ROGUE = 9,
    SHAMAN = 10,
    WARLOCK = 11,
    WARRIOR = 12,
}

WSID_CLASS_INFO = {
    {name="Death Knight", short_name="DK", colors={r=0.77, g=0.12, b=0.23},},
    {name="Demon Hunter", short_name="DH", colors={r=0.64, g=0.19, b=0.79},},
    {name="Druid", short_name="DR", colors={r=1.00, g=0.49, b=0.04},},
    {name="Evoker", short_name="EV", colors={r=0.20, g=0.58, b=0.50},},
    {name="Hunter", short_name="HU", colors={r=0.67, g=0.83, b=0.45},},
    {name="Mage", short_name="MA", colors={r=0.25, g=0.78, b=0.92},},
    {name="Monk", short_name="MO", colors={r=0.00, g=1.00, b=0.60},},
    {name="Paladin", short_name="PA", colors={r=0.96, g=0.55, b=0.73},},
    {name="Priest", short_name="PR", colors={r=0.90, g=0.90, b=0.90},},
    {name="Rogue", short_name="RO", colors={r=1.00, g=0.96, b=0.41},},
    {name="Shaman", short_name="SH", colors={r=0.00, g=0.44, b=0.87},},
    {name="Warlock", short_name="WL", colors={r=0.53, g=0.53, b=0.93},},
    {name="Warrior", short_name="WA", colors={r=0.78, g=0.61, b=0.43},},
}

function GetClassNames()
    local names={}
    for _,c in ipairs(WSID_CLASS_INFO) do table.insert(names, c.name) end
    return names
end

function GetClassShortNames()
    local short_name={}
    for _,c in ipairs(WSID_CLASS_INFO) do table.insert(short_name, c.short_name) end
    return short_name
end

function GetClassColor(class)
    if not class or not WSID_CLASS_INFO[class] then return {r=1,g=1,b=1} end
    return WSID_CLASS_INFO[class].colors
end

function EncodeClass(class)
    if not class or not WSID_CLASS_INFO[class] then return "??" end
    return WSID_CLASS_INFO[class].short_name
end
