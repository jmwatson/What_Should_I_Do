-- Data/Classes.lua
-- Classes / Colors

DEATH_KNIGHT = "Death Knight"
DEMON_HUNTER = "Demon Hunter"
DRUID = "Druid"
EVOKER = "Evoker"
HUNTER = "Hunter"
MAGE = "Mage"
MONK = "Monk"
PALADIN = "Paladin"
PRIEST = "Priest"
ROGUE = "Rogue"
SHAMAN = "Shaman"
WARLOCK = "Warlock"
WARRIOR = "Warrior"

DK_COLOR = {r=0.77, g=0.12, b=0.23}
DH_COLOR = {r=0.64, g=0.19, b=0.79}
DR_COLOR = {r=1.00, g=0.49, b=0.04}
EV_COLOR = {r=0.20, g=0.58, b=0.50}
HU_COLOR = {r=0.67, g=0.83, b=0.45}
MA_COLOR = {r=0.25, g=0.78, b=0.92}
MO_COLOR = {r=0.00, g=1.00, b=0.60}
PA_COLOR = {r=0.96, g=0.55, b=0.73}
PR_COLOR = {r=0.90, g=0.90, b=0.90}
RO_COLOR = {r=1.00, g=0.96, b=0.41}
SH_COLOR = {r=0.00, g=0.44, b=0.87}
WL_COLOR = {r=0.53, g=0.53, b=0.93}
WA_COLOR = {r=0.78, g=0.61, b=0.43}

WSID_CLASS_INFO = {
    [DEATH_KNIGHT] = {name=DEATH_KNIGHT, short_name="DK", colors=DK_COLOR,},
    [DEMON_HUNTER] = {name=DEMON_HUNTER, short_name="DH", colors=DH_COLOR,},
    [DRUID] = {name=DRUID, short_name="DR", colors=DR_COLOR,},
    [EVOKER] = {name=EVOKER, short_name="EV", colors=EV_COLOR,},
    [HUNTER] = {name=HUNTER, short_name="HU", colors=HU_COLOR,},
    [MAGE] = {name=MAGE, short_name="MA", colors=MA_COLOR,},
    [MONK] = {name=MONK, short_name="MO", colors=MO_COLOR,},
    [PALADIN] = {name=PALADIN, short_name="PA", colors=PA_COLOR,},
    [PRIEST] = {name=PRIEST, short_name="PR", colors=PR_COLOR,},
    [ROGUE] = {name=ROGUE, short_name="RO", colors=RO_COLOR,},
    [SHAMAN] = {name=SHAMAN, short_name="SH", colors=SH_COLOR,},
    [WARLOCK] = {name=WARLOCK, short_name="WL", colors=WL_COLOR,},
    [WARRIOR] = {name=WARRIOR, short_name="WA", colors=WA_COLOR,},
}

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
    if not class or not WSID_CLASS_INFO[class] then return WSID_UNKNOWN end
    return WSID_CLASS_INFO[class].short_name
end

function DecodeClass(class_short_name)
    local class = WSID_UNKNOWN
    if class_short_name then
        for _, class_info in ipairs(WSID_CLASS_INFO) do
            if class_info.short_name == class_short_name then
                class = class_info.name
                break
            end
        end
    end
    return class
end

function NormalizeClass(class)
    if not class and WSID_CLASS_INFO[class] then return class end
    return WSID_CLASS_INFO[class]
end
