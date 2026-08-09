-- Data/Expansions.lua
-- Expansion list and level-gated pool logic
-- Author: I_AM_T3X | v1.0.0

WSID.EXPANSIONS = {
    WSID.CLASSIC.NAME,
    WSID.TBC.NAME,
    WSID.WRATH.NAME,
    WSID.CATA.NAME,
    WSID.MISTS.NAME,
    WSID.WOD.NAME,
    WSID.LEGION.NAME,
    WSID.BFA.NAME,
    WSID.SL.NAME,
    WSID.DF.NAME,
    WSID.TWW.NAME,
    WSID.MIDNIGHT.NAME,
}

WSID.GetExpansionPool = function(level)
    -- Should probably find a better way to make this generic,
    -- but for now it being hardcoded to the last 2 expansions is fine.
    if level >= 80 then
        return {WSID.MIDNIGHT.NAME}
    elseif level >= 70 then
        return {WSID.TWW.NAME}
    elseif level >= 10 then
        -- Trim last 2 expansions from the list
        local new_len = #WSID.EXPANSIONS - 2
        return table.move(WSID.EXPANSIONS, 1, new_len, 1, {})
    else
        return {"Finish your starting zone and reroll!"}
    end
end

-- Helper: map expansion name -> chronological index
WSID.EXPANSION_INDEX = {}
for i, name in ipairs(WSID.EXPANSIONS) do WSID.EXPANSION_INDEX[name] = i end
