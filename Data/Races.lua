-- Data/Races.lua
-- Race, class, and color data

HUMAN = 0
DWARF = 1
NIGHT_ELF = 2
GNOME = 3
DRAENEI = 4
WORGEN = 5
ORC = 6
UNDEAD = 7
TAUREN = 8
TROLL = 9
BLOOD_ELF = 10
GOBLIN = 11
PANDAREN = 12
DRACHTHYR = 13
VOID_ELF = 14
LIGHTFORGED_DRAENEI = 15
DARK_IRON_DWARF = 16
KUL_TIRAN = 17
MECHAGNOME = 18
NIGHTBORNE = 19
HIGHMOUNTAIN_TAUREN = 20
MAGHAR_ORC = 21
ZANDALARI_TROLL = 22
VULPERA = 23
EARTHEN = 24
HARANIR = 25

WSID_RACE_INFO = {
    {name="Human", enc="HU", faction="Alliance", rtype="Core", classes={"Warrior","Paladin","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},},
    {name="Dwarf", enc="DW", faction="Alliance", rtype="Core", classes={"Warrior","Paladin","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Death Knight"},},
    {name="Night Elf", enc="NE", faction="Alliance", rtype="Core", classes={"Warrior","Hunter","Rogue","Priest","Mage","Monk","Druid","Demon Hunter","Death Knight"},},
    {name="Gnome", enc="GN", faction="Alliance", rtype="Core", classes={"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},},
    {name="Draenei", enc="DN", faction="Alliance", rtype="Core", classes={"Warrior","Paladin","Hunter","Priest","Shaman","Mage","Monk","Death Knight"},},
    {name="Worgen", enc="WG", faction="Alliance", rtype="Core", classes={"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Druid","Death Knight"},},
    {name="Orc", enc="OR", faction="Horde", rtype="Core", classes={"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Monk","Death Knight"},},
    {name="Undead", enc="UD", faction="Horde", rtype="Core", classes={"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Evoker"},},
    {name="Tauren", enc="TA", faction="Horde", rtype="Core", classes={"Warrior","Hunter","Rogue","Shaman","Mage","Warlock","Monk","Death Knight"},},
    {name="Troll", enc="TR", faction="Horde", rtype="Core", classes={"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},},
    {name="Blood Elf", enc="BE", faction="Horde", rtype="Core", classes={"Warrior","Paladin","Hunter","Priest","Shaman","Mage","Monk","Druid","Death Knight"},},
    {name="Goblin", enc="GO", faction="Horde", rtype="Core", classes={"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Druid","Death Knight"},},
    {name="Pandaren", enc="PA", faction="Neutral", rtype="Core", classes={"Warrior","Paladin","Hunter","Rogue","Priest","Mage","Warlock","Monk","Demon Hunter","Death Knight"},},
    {name="Dracthyr", enc="DT", faction="Neutral", rtype="Core", classes={"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Death Knight"},},
    {name="Void Elf", enc="VE", faction="Alliance", rtype="Allied", classes={"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},},
    {name="Lightforged Draenei", enc="LD", faction="Alliance", rtype="Allied", classes={"Warrior","Paladin","Hunter","Priest","Mage","Monk","Death Knight"},},
    {name="Dark Iron Dwarf", enc="DI", faction="Alliance", rtype="Allied", classes={"Warrior","Paladin","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Death Knight"},},
    {name="Kul Tiran", enc="KT", faction="Alliance", rtype="Allied", classes={"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Monk","Druid","Death Knight"},},
    {name="Mechagnome", enc="MG", faction="Alliance", rtype="Allied", classes={"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},},
    {name="Nightborne", enc="NB", faction="Horde", rtype="Allied", classes={"Warrior","Hunter","Rogue","Priest","Mage","Warlock","Monk","Death Knight"},},
    {name="Highmountain Tauren", enc="HT", faction="Horde", rtype="Allied", classes={"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Monk","Druid","Death Knight"},},
    {name="Mag'har Orc", enc="MO", faction="Horde", rtype="Allied", classes={"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Monk","Death Knight"},},
    {name="Zandalari Troll", enc="ZT", faction="Horde", rtype="Allied", classes={"Warrior","Paladin","Hunter","Rogue","Priest","Shaman","Mage","Monk","Druid","Death Knight"},},
    {name="Vulpera", enc="VU", faction="Horde", rtype="Allied", classes={"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Death Knight"},},
    {name="Earthen", enc="EA", faction="Neutral", rtype="Allied", classes={"Warrior","Paladin","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Death Knight"},},
    {name="Haranir", enc="HR", faction="Neutral", rtype="Allied", classes={"Warrior","Hunter","Rogue","Priest","Shaman","Mage","Warlock","Monk","Druid"},},
}

DEATH_KNIGHT = 0
DEMON_HUNTER = 1
DRUID = 2
EVOKER = 3
HUNTER = 4
MAGE = 5
MONK = 6
PALADIN = 7
PRIEST = 8
ROGUE = 9
SHAMAN = 10
WARLOCK = 11
WARRIOR = 12

WSID_CLASS_INFO = {
    {name="Death Knight", enc="DK", colors={r=0.77, g=0.12, b=0.23},},
    {name="Demon Hunter", enc="DH", colors={r=0.64, g=0.19, b=0.79},},
    {name="Druid", enc="DR", colors={r=1.00, g=0.49, b=0.04},},
    {name="Evoker", enc="EV", colors={r=0.20, g=0.58, b=0.50},},
    {name="Hunter", enc="HU", colors={r=0.67, g=0.83, b=0.45},},
    {name="Mage", enc="MA", colors={r=0.25, g=0.78, b=0.92},},
    {name="Monk", enc="MO", colors={r=0.00, g=1.00, b=0.60},},
    {name="Paladin", enc="PA", colors={r=0.96, g=0.55, b=0.73},},
    {name="Priest", enc="PR", colors={r=0.90, g=0.90, b=0.90},},
    {name="Rogue", enc="RO", colors={r=1.00, g=0.96, b=0.41},},
    {name="Shaman", enc="SH", colors={r=0.00, g=0.44, b=0.87},},
    {name="Warlock", enc="WL", colors={r=0.53, g=0.53, b=0.93},},
    {name="Warrior", enc="WA", colors={r=0.78, g=0.61, b=0.43},},
}
