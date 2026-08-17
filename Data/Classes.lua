local _, addon = ...;

addon.DEATH_KNIGHT = "Death Knight";
addon.DEMON_HUNTER = "Demon Hunter";
addon.DRUID = "Druid";
addon.EVOKER = "Evoker";
addon.HUNTER = "Hunter";
addon.MAGE = "Mage";
addon.MONK = "Monk";
addon.PALADIN = "Paladin";
addon.PRIEST = "Priest";
addon.ROGUE = "Rogue";
addon.SHAMAN = "Shaman";
addon.WARLOCK = "Warlock";
addon.WARRIOR = "Warrior";

addon.DK_COLOR = {r=0.77, g=0.12, b=0.23};
addon.DH_COLOR = {r=0.64, g=0.19, b=0.79};
addon.DR_COLOR = {r=1.00, g=0.49, b=0.04};
addon.EV_COLOR = {r=0.20, g=0.58, b=0.50};
addon.HU_COLOR = {r=0.67, g=0.83, b=0.45};
addon.MA_COLOR = {r=0.25, g=0.78, b=0.92};
addon.MO_COLOR = {r=0.00, g=1.00, b=0.60};
addon.PA_COLOR = {r=0.96, g=0.55, b=0.73};
addon.PR_COLOR = {r=0.90, g=0.90, b=0.90};
addon.RO_COLOR = {r=1.00, g=0.96, b=0.41};
addon.SH_COLOR = {r=0.00, g=0.44, b=0.87};
addon.WL_COLOR = {r=0.53, g=0.53, b=0.93};
addon.WA_COLOR = {r=0.78, g=0.61, b=0.43};

addon.CLASS_INFO = {
    [addon.DEATH_KNIGHT] = {name=addon.DEATH_KNIGHT, short_name="DK", colors=addon.DK_COLOR,},
    [addon.DEMON_HUNTER] = {name=addon.DEMON_HUNTER, short_name="DH", colors=addon.DH_COLOR,},
    [addon.DRUID] = {name=addon.DRUID, short_name="DR", colors=addon.DR_COLOR,},
    [addon.EVOKER] = {name=addon.EVOKER, short_name="EV", colors=addon.EV_COLOR,},
    [addon.HUNTER] = {name=addon.HUNTER, short_name="HU", colors=addon.HU_COLOR,},
    [addon.MAGE] = {name=addon.MAGE, short_name="MA", colors=addon.MA_COLOR,},
    [addon.MONK] = {name=addon.MONK, short_name="MO", colors=addon.MO_COLOR,},
    [addon.PALADIN] = {name=addon.PALADIN, short_name="PA", colors=addon.PA_COLOR,},
    [addon.PRIEST] = {name=addon.PRIEST, short_name="PR", colors=addon.PR_COLOR,},
    [addon.ROGUE] = {name=addon.ROGUE, short_name="RO", colors=addon.RO_COLOR,},
    [addon.SHAMAN] = {name=addon.SHAMAN, short_name="SH", colors=addon.SH_COLOR,},
    [addon.WARLOCK] = {name=addon.WARLOCK, short_name="WL", colors=addon.WL_COLOR,},
    [addon.WARRIOR] = {name=addon.WARRIOR, short_name="WA", colors=addon.WA_COLOR,},
};

local function GetClassShortNames()
    local short_name={};
    for _,c in ipairs(addon.CLASS_INFO) do table.insert(short_name, c.short_name); end
    return short_name;
end
addon.GetClassShortNames = GetClassShortNames;

local function GetClassColor(class)
    if not class or not addon.CLASS_INFO[class] then return {r=1,g=1,b=1}; end
    return addon.CLASS_INFO[class].colors;
end
addon.GetClassColor = GetClassColor;

local function EncodeClass(class)
    if not class or not addon.CLASS_INFO[class] then return addon.UNKNOWN; end
    return addon.CLASS_INFO[class].short_name;
end
addon.EncodeClass = EncodeClass;

local function DecodeClass(class_short_name)
    local class = addon.UNKNOWN;
    
    if class_short_name then
        for _, class_info in ipairs(addon.CLASS_INFO) do
            if class_info.short_name == class_short_name then
                class = class_info.name;
                break;
            end
        end
    end

    return class;
end
addon.DecodeClass = DecodeClass;

local function NormalizeClass(class)
    return class or addon.CLASS_INFO[class];
end
addon.NormalizeClass = NormalizeClass;
