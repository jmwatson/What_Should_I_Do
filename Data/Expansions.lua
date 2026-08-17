local _, addon = ...;

addon.EXPANSIONS = {
    addon.CLASSIC.NAME,
    addon.TBC.NAME,
    addon.WRATH.NAME,
    addon.CATA.NAME,
    addon.MISTS.NAME,
    addon.WOD.NAME,
    addon.LEGION.NAME,
    addon.BFA.NAME,
    addon.SL.NAME,
    addon.DF.NAME,
    addon.TWW.NAME,
    addon.MIDNIGHT.NAME,
};

addon.EXPANSION_INDEX = {};
for i, name in ipairs(addon.EXPANSIONS) do
    addon.EXPANSION_INDEX[name] = i;
end

local function GetExpansionPool(level)
    -- Should probably find a better way to make this generic,
    -- but for now it being hardcoded to the last 2 expansions is fine.
    if level >= 80 then
        return {addon.MIDNIGHT.NAME};
    elseif level >= 70 then
        return {addon.TWW.NAME};
    elseif level >= 10 then
        -- Trim last 2 expansions from the list
        local new_len = #addon.EXPANSIONS - 2;
        return table.move(addon.EXPANSIONS, 1, new_len, 1, {});
    end
    
    return {"Finish your starting zone and reroll!"};
end
addon.GetExpansionPool = GetExpansionPool;
