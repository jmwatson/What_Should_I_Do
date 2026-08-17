local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local function BuildRaidDungeonPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    local hdr = addon.MakeHeader(panel, addon.RAIDS_AND_DUNGEONS_LABEL);
    hdr:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);

    local desc = addon.MakeLabel(panel, "Choose Raids or Dungeons, spin an expansion, then spin a random instance.", hdr, addon.BOTTOMLEFT, 4, -8);

    -- Mode toggle: Raids or Dungeons
    local modeLbl = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    modeLbl:SetPoint(addon.TOPLEFT, desc, addon.BOTTOMLEFT, 0, -10);
    modeLbl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
    modeLbl:SetText("Mode:");

    local mode = "Raids";
    local modeBtns = {};
    for i, m in ipairs({"Raids","Dungeons"}) do
        local mb = addon.MakeBtn(panel, m, 100, 26);
        mb:SetPoint(addon.LEFT, modeLbl, addon.RIGHT, 6+(i-1)*104, 0);
        local mv = m;
        mb:SetScript(addon.OnClick, function()
            mode = mv;
            for _, b in ipairs(modeBtns) do
                b:SetBackdropColor(CT.btn_bg[1],CT.btn_bg[2],CT.btn_bg[3]);
                b:SetBackdropBorderColor(CT.btn_bdr[1],CT.btn_bdr[2],CT.btn_bdr[3],1);
                b._lbl:SetTextColor(CT.btn_text[1],CT.btn_text[2],CT.btn_text[3]);
            end
            mb:SetBackdropColor(CT.nav_active[1],CT.nav_active[2],CT.nav_active[3]);
            mb:SetBackdropBorderColor(CT.nav_border[1],CT.nav_border[2],CT.nav_border[3],1);
            mb._lbl:SetTextColor(1,1,1);
        end);
        table.insert(modeBtns, mb);
    end
    -- Default: Raids active
    modeBtns[1]:SetBackdropColor(CT.nav_active[1],CT.nav_active[2],CT.nav_active[3]);
    modeBtns[1]:SetBackdropBorderColor(CT.nav_border[1],CT.nav_border[2],CT.nav_border[3],1);
    modeBtns[1]._lbl:SetTextColor(1,1,1);

    -- Expansion result
    local expBox, expLabel = addon.MakeResult(panel, nil, 52, "EXPANSION");
    expBox:SetPoint(addon.TOPLEFT, modeLbl, addon.BOTTOMLEFT, 0, -12);
    expLabel:SetText("Expansion");

    -- Instance result
    local instBox, instLabel = addon.MakeResult(panel, nil, 52, "RAID / DUNGEON");
    instBox:SetPoint(addon.TOPLEFT, expBox, addon.BOTTOMLEFT, 0, -8);
    instLabel:SetText(addon.DASH_DASH);

    -- Spin buttons
    local spinExpBtn = addon.MakeBtn(panel, "Spin Expansion", nil, 30);
    spinExpBtn:SetPoint(addon.TOP, instBox, addon.BOTTOM, 0, -10);
    spinExpBtn:SetPoint(addon.LEFT,    panel, addon.LEFT,  addon.PAD, 0);
    spinExpBtn:SetPoint(addon.RIGHT,   panel, addon.CENTER, -3, 0);

    local spinInstBtn = addon.MakeBtn(panel, "Spin Instance", nil, 30);
    spinInstBtn:SetPoint(addon.TOP, instBox, addon.BOTTOM, 0, -10);
    spinInstBtn:SetPoint(addon.LEFT,    panel, addon.CENTER, 3, 0);
    spinInstBtn:SetPoint(addon.RIGHT,   panel, addon.RIGHT, -addon.PAD, 0);
    spinInstBtn:SetEnabled(false)

    local spinBothBtn = addon.MakeBtn(panel, "Spin Both", nil, 30);
    spinBothBtn:SetPoint(addon.TOP, spinExpBtn, addon.BOTTOM, 0, -6);
    spinBothBtn:SetPoint(addon.LEFT,    panel, addon.LEFT,  addon.PAD, 0);
    spinBothBtn:SetPoint(addon.RIGHT,   panel, addon.RIGHT, -addon.PAD, 0);

    local pickedExp = nil;

    local function GetExpansionList()
        local pool = {};
        local src = mode == "Raids" and addon.RAIDS_BY_EXPANSION or addon.DUNGEONS_BY_EXPANSION;
        local excluded = DB and DB.excludedExpansions or {};
        for exp, instances in pairs(src) do
            if exp and #instances > 0 and not excluded[exp] then
                table.insert(pool, exp);
            end
        end
        -- Sort chronologically using the central index map
        table.sort(pool, function(a,b)
            local ai = addon.EXPANSION_INDEX[a] or 99;
            local bi = addon.EXPANSION_INDEX[b] or 99;
            return ai < bi;
        end);
        return pool;
    end

    local function GetInstanceList(exp)
        local src = mode == "Raids" and addon.RAIDS_BY_EXPANSION or addon.DUNGEONS_BY_EXPANSION;
        return src[exp] or {};
    end

    spinExpBtn:SetScript(addon.OnClick, function()
        local pool = GetExpansionList();
        if #pool == 0 then
            return;
        end
        addon.StopSlot();
        spinExpBtn:SetEnabled(false);
        spinBothBtn:SetEnabled(false);
        spinInstBtn:SetEnabled(false);
        pickedExp = nil;
        instLabel:SetText(addon.DASH_DASH);
        instLabel:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
        expLabel:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
        addon.StartSlot(expLabel, pool, function(winner)
            pickedExp = winner;
            expLabel:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
            spinExpBtn:SetEnabled(true);
            spinBothBtn:SetEnabled(true);
            spinInstBtn:SetEnabled(true);
        end);
    end);

    spinInstBtn:SetScript(addon.OnClick, function()
        if not pickedExp then
            return;
        end
        local pool = GetInstanceList(pickedExp);
        if #pool == 0 then
            instLabel:SetText("None found");
            return;
        end
        addon.StopSlot()
        spinInstBtn:SetEnabled(false);
        instLabel:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
        addon.StartSlot(instLabel, pool, function(_)
            instLabel:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
            spinInstBtn:SetEnabled(true);
        end);
    end);

    spinBothBtn:SetScript(addon.OnClick, function()
        local pool = GetExpansionList();
        if #pool == 0 then
            return;
        end
        addon.StopSlot();
        spinExpBtn:SetEnabled(false);
        spinBothBtn:SetEnabled(false);
        spinInstBtn:SetEnabled(false);
        pickedExp = nil;
        instLabel:SetText(addon.DASH_DASH);
        instLabel:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
        expLabel:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
        addon.StartSlot(expLabel, pool, function(winner)
            pickedExp = winner;
            expLabel:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
            local instPool = GetInstanceList(winner);
            if #instPool == 0 then
                spinExpBtn:SetEnabled(true);
                spinBothBtn:SetEnabled(true);
                return;
            end
            instLabel:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
            addon.StartSlot(instLabel, instPool, function(_)
                instLabel:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
                spinExpBtn:SetEnabled(true);
                spinBothBtn:SetEnabled(true);
                spinInstBtn:SetEnabled(true);
            end);
        end);
    end);

    return panel;
end
addon.BuildRaidDungeonPanel = BuildRaidDungeonPanel;
