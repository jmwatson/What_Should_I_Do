local _, addon = ...;

addon.ALCHEMY = "Alchemy";
addon.BLACKSMITHING = "Blacksmithing";
addon.ENCHANTING = "Enchanting";
addon.ENGINEERING = "Engineering";
addon.HERBALISM = "Herbalism";
addon.INSCRIPTION = "Inscription";
addon.JEWELCRAFTING = "Jewelcrafting";
addon.LEATHERWORKING = "Leatherworking";
addon.MINING = "Mining";
addon.SKINNING = "Skinning";
addon.TAILORING = "Tailoring";
addon.FISHING = "Fishing";
addon.COOKING = "Cooking";

addon.PROFESSIONS = {
    addon.ALCHEMY,
    addon.BLACKSMITHING,
    addon.ENCHANTING,
    addon.ENGINEERING,
    addon.HERBALISM,
    addon.INSCRIPTION,
    addon.JEWELCRAFTING,
    addon.LEATHERWORKING,
    addon.MINING,
    addon.SKINNING,
    addon.TAILORING,
    addon.FISHING,
    addon.COOKING,
};

addon.FARM_PROFESSIONS = {
    [addon.HERBALISM] = true,
    [addon.MINING] = true,
    [addon.SKINNING] = true,
}
