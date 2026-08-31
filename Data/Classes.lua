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

local DK_COLOR = {r=0.77, g=0.12, b=0.23};
local DH_COLOR = {r=0.64, g=0.19, b=0.79};
local DR_COLOR = {r=1.00, g=0.49, b=0.04};
local EV_COLOR = {r=0.20, g=0.58, b=0.50};
local HU_COLOR = {r=0.67, g=0.83, b=0.45};
local MA_COLOR = {r=0.25, g=0.78, b=0.92};
local MO_COLOR = {r=0.00, g=1.00, b=0.60};
local PA_COLOR = {r=0.96, g=0.55, b=0.73};
local PR_COLOR = {r=0.90, g=0.90, b=0.90};
local RO_COLOR = {r=1.00, g=0.96, b=0.41};
local SH_COLOR = {r=0.00, g=0.44, b=0.87};
local WL_COLOR = {r=0.53, g=0.53, b=0.93};
local WA_COLOR = {r=0.78, g=0.61, b=0.43};

addon.CLASS_INFO = {
    [addon.DEATH_KNIGHT] = {name=addon.DEATH_KNIGHT, short_name="DK", colors=DK_COLOR,},
    [addon.DEMON_HUNTER] = {name=addon.DEMON_HUNTER, short_name="DH", colors=DH_COLOR,},
    [addon.DRUID] = {name=addon.DRUID, short_name="DR", colors=DR_COLOR,},
    [addon.EVOKER] = {name=addon.EVOKER, short_name="EV", colors=EV_COLOR,},
    [addon.HUNTER] = {name=addon.HUNTER, short_name="HU", colors=HU_COLOR,},
    [addon.MAGE] = {name=addon.MAGE, short_name="MA", colors=MA_COLOR,},
    [addon.MONK] = {name=addon.MONK, short_name="MO", colors=MO_COLOR,},
    [addon.PALADIN] = {name=addon.PALADIN, short_name="PA", colors=PA_COLOR,},
    [addon.PRIEST] = {name=addon.PRIEST, short_name="PR", colors=PR_COLOR,},
    [addon.ROGUE] = {name=addon.ROGUE, short_name="RO", colors=RO_COLOR,},
    [addon.SHAMAN] = {name=addon.SHAMAN, short_name="SH", colors=SH_COLOR,},
    [addon.WARLOCK] = {name=addon.WARLOCK, short_name="WL", colors=WL_COLOR,},
    [addon.WARRIOR] = {name=addon.WARRIOR, short_name="WA", colors=WA_COLOR,},
};

local function GetClassShortNames()
    local short_name={};
    for _,c in pairs(addon.CLASS_INFO) do table.insert(short_name, c.short_name); end
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
        for _, class_info in pairs(addon.CLASS_INFO) do
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
