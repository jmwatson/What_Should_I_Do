-- Data/Classes.lua
-- Classes / Colors

WSID.DEATH_KNIGHT = "Death Knight"
WSID.DEMON_HUNTER = "Demon Hunter"
WSID.DRUID = "Druid"
WSID.EVOKER = "Evoker"
WSID.HUNTER = "Hunter"
WSID.MAGE = "Mage"
WSID.MONK = "Monk"
WSID.PALADIN = "Paladin"
WSID.PRIEST = "Priest"
WSID.ROGUE = "Rogue"
WSID.SHAMAN = "Shaman"
WSID.WARLOCK = "Warlock"
WSID.WARRIOR = "Warrior"

WSID.DK_COLOR = {r=0.77, g=0.12, b=0.23}
WSID.DH_COLOR = {r=0.64, g=0.19, b=0.79}
WSID.DR_COLOR = {r=1.00, g=0.49, b=0.04}
WSID.EV_COLOR = {r=0.20, g=0.58, b=0.50}
WSID.HU_COLOR = {r=0.67, g=0.83, b=0.45}
WSID.MA_COLOR = {r=0.25, g=0.78, b=0.92}
WSID.MO_COLOR = {r=0.00, g=1.00, b=0.60}
WSID.PA_COLOR = {r=0.96, g=0.55, b=0.73}
WSID.PR_COLOR = {r=0.90, g=0.90, b=0.90}
WSID.RO_COLOR = {r=1.00, g=0.96, b=0.41}
WSID.SH_COLOR = {r=0.00, g=0.44, b=0.87}
WSID.WL_COLOR = {r=0.53, g=0.53, b=0.93}
WSID.WA_COLOR = {r=0.78, g=0.61, b=0.43}

WSID.CLASS_INFO = {
    [WSID.DEATH_KNIGHT] = {name=WSID.DEATH_KNIGHT, short_name="DK", colors=WSID.DK_COLOR,},
    [WSID.DEMON_HUNTER] = {name=WSID.DEMON_HUNTER, short_name="DH", colors=WSID.DH_COLOR,},
    [WSID.DRUID] = {name=WSID.DRUID, short_name="DR", colors=WSID.DR_COLOR,},
    [WSID.EVOKER] = {name=WSID.EVOKER, short_name="EV", colors=WSID.EV_COLOR,},
    [WSID.HUNTER] = {name=WSID.HUNTER, short_name="HU", colors=WSID.HU_COLOR,},
    [WSID.MAGE] = {name=WSID.MAGE, short_name="MA", colors=WSID.MA_COLOR,},
    [WSID.MONK] = {name=WSID.MONK, short_name="MO", colors=WSID.MO_COLOR,},
    [WSID.PALADIN] = {name=WSID.PALADIN, short_name="PA", colors=WSID.PA_COLOR,},
    [WSID.PRIEST] = {name=WSID.PRIEST, short_name="PR", colors=WSID.PR_COLOR,},
    [WSID.ROGUE] = {name=WSID.ROGUE, short_name="RO", colors=WSID.RO_COLOR,},
    [WSID.SHAMAN] = {name=WSID.SHAMAN, short_name="SH", colors=WSID.SH_COLOR,},
    [WSID.WARLOCK] = {name=WSID.WARLOCK, short_name="WL", colors=WSID.WL_COLOR,},
    [WSID.WARRIOR] = {name=WSID.WARRIOR, short_name="WA", colors=WSID.WA_COLOR,},
}

WSID.GetClassShortNames = function()
    local short_name={}
    for _,c in ipairs(WSID.CLASS_INFO) do table.insert(short_name, c.short_name) end
    return short_name
end

WSID.GetClassColor = function(class)
    if not class or not WSID.CLASS_INFO[class] then return {r=1,g=1,b=1} end
    return WSID.CLASS_INFO[class].colors
end

WSID.EncodeClass = function(class)
    if not class or not WSID.CLASS_INFO[class] then return WSID.UNKNOWN end
    return WSID.CLASS_INFO[class].short_name
end

WSID.DecodeClass = function(class_short_name)
    local class = WSID.UNKNOWN
    if class_short_name then
        for _, class_info in ipairs(WSID.CLASS_INFO) do
            if class_info.short_name == class_short_name then
                class = class_info.name
                break
            end
        end
    end
    return class
end

WSID.NormalizeClass = function(class)
    if not class and WSID.CLASS_INFO[class] then return class end
    return WSID.CLASS_INFO[class]
end
