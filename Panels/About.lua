local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

local WIN_H  = 520;
local PAD    = 16;

local function BuildAboutPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    local yOff = -8;
    local scrollBG, scrollContent, _ = addon.MakeScrollBox(panel, nil, WIN_H - 30 - PAD * 2);

    local lines = {
        {text=addon.STRING, size=16, color={CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]}},
        {text="Version 1.1.1",     size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text=" ", size=5},
        {text="Author:  I_AM_T3X", size=12, color={CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]}},
        {text=" ", size=5},
        {text="A spin-wheel decision helper for World of Warcraft.", size=12, color={CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]}},
        {text="Can't decide what to do? Let the wheels choose for you.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text=" ", size=5},
        {text="Wheels:", size=12, color={CT.header_txt[1],CT.header_txt[2],CT.header_txt[3]}},
        {text="Activity         --  Spin a category and sub-activity.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Creator          --  Spin a random Race + Class combo.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Leveling         --  Spin a class, pick a char, spin an expansion.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Name Generator   --  Generate race-appropriate character names.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Professions      --  Spin two random primary professions.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Raids & Dungeons --  Spin an expansion then a random instance.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text=" ", size=5},
        {text="Slash Commands:", size=12, color={CT.header_txt[1],CT.header_txt[2],CT.header_txt[3]}},
        {text="/wsid              --  Toggle main window", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="/sw                --  Toggle main window (alias)", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="/wsid settings     --  Open settings", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="/wsid roster       --  Refresh character roster", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text=" ", size=5},
        {text="Roster:", size=12, color={CT.header_txt[1],CT.header_txt[2],CT.header_txt[3]}},
        {text="Characters are added automatically each time you log in.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Leveling wheel excludes max level (90) characters.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Use Settings -- Import/Export to share rosters between accounts.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text=" ", size=5},
        {text="Settings:", size=12, color={CT.header_txt[1],CT.header_txt[2],CT.header_txt[3]}},
        {text="Activities    --  Add/remove categories and their sub-activities.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Roster        --  View and remove characters from the roster.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Import/Export --  Share roster strings between two accounts.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Colors        --  Pick a preset theme or build custom colors.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text=" ", size=5},
        {text="UI Scale:", size=12, color={CT.header_txt[1],CT.header_txt[2],CT.header_txt[3]}},
        {text="Found in Settings > UI Scale. Scales the entire addon from 50%% to 200%%.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Useful for accessibility or high-resolution displays. Changes apply instantly.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text=" ", size=5},
        {text="Minimap Button:", size=12, color={CT.header_txt[1],CT.header_txt[2],CT.header_txt[3]}},
        {text="Left-click   --  Open or close the main window.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Right-click  --  Open Settings.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="Drag         --  Reposition around the minimap.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text=" ", size=5},
        {text="Special Thanks:", size=12, color={CT.header_txt[1],CT.header_txt[2],CT.header_txt[3]}},
        {text="MajGhostPants  --  For the inspiration and feedback.", size=11, color={CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]}},
        {text="twitch.tv/majghostpants", size=11, color={CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]}},
    };

    scrollBG:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);

    for _, line in ipairs(lines) do
        local fs = scrollContent:CreateFontString(nil, addon.OVERLAY);
        fs:SetFont(addon.GAME_FONT, line.size or 12, addon.EMPTY_STRING);
        fs:SetPoint(addon.TOPLEFT, scrollContent, addon.TOPLEFT, 10, yOff);
        fs:SetPoint(addon.LEFT,  panel, addon.LEFT,  addon.PAD + 12, 0);
        fs:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
        fs:SetJustifyH(addon.LEFT) ; fs:SetWordWrap(true);
        fs:SetText(line.text);
        if line.color then
            fs:SetTextColor(line.color[1], line.color[2], line.color[3]);
        else
            fs:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);
        end
        yOff = yOff - (line.size or 12) - 4;
    end
    scrollContent:SetHeight(math.abs(yOff) + 20);
    return panel;
end
addon.BuildAboutPanel = BuildAboutPanel;

