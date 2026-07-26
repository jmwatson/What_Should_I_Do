-- Data/Expansions.lua
-- Expansion list and level-gated pool logic
-- Author: I_AM_T3X | v1.0.0

WSID_EXPANSIONS = {
    CLASSIC,
    TBC,
    WRATH,
    CATA,
    MISTS,
    WOD,
    LEGION,
    BFA,
    SL,
    DF,
    TWW,
    MIDNIGHT,
}

function GetExpansionPool(level)
    -- Should probably find a better way to make this generic,
    -- but for now it being hardcoded to the last 2 expansions is fine.
    if level >= 80 then
        return {MIDNIGHT}
    elseif level >= 70 then
        return {TWW}
    elseif level >= 10 then
        -- Trim last 2 expansions from the list
        local new_len = #WSID_EXPANSIONS - 2
        return table.move(WSID_EXPANSIONS, 1, new_len, 1, {})
    else
        return {"Finish your starting zone and reroll!"}
    end
end

-- Helper: map expansion name -> chronological index
WSID_EXPANSION_INDEX = {}
for i, name in ipairs(WSID_EXPANSIONS) do WSID_EXPANSION_INDEX[name] = i end
