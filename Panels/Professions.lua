local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local function BuildProfessionPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    local hdr = addon.MakeHeader(panel, "Profession Picker");
    local desc = addon.MakeLabel(panel, "Spin two professions for your character.", hdr, addon.BOTTOMLEFT, 4, -8);
    local prof1Box, prof1Label = addon.MakeResult(panel, nil, 52, "PROFESSION 1");
    local prof2Box, prof2Label = addon.MakeResult(panel, nil, 52, "PROFESSION 2");
    local spinBtn = addon.MakeBtn(panel, "Spin Professions", nil, 30);

    hdr:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    prof1Box:SetPoint(addon.TOP, desc, addon.BOTTOM, 0, -12);
    prof1Box:SetPoint(addon.LEFT, panel, addon.LEFT,  addon.PAD, 0);
    prof1Box:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);
    prof1Label:SetText(addon.DASH_DASH);
    prof2Box:SetPoint(addon.TOP, desc, addon.BOTTOM, 0, -12);
    prof2Box:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    prof2Box:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    prof2Label:SetText(addon.DASH_DASH);
    spinBtn:SetPoint(addon.TOP, prof1Box, addon.BOTTOM, 0, -10);
    spinBtn:SetPoint(addon.LEFT, panel, addon.LEFT,  addon.PAD, 0);
    spinBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);

    -- Exclude farming professions checkbox
    local FARMING = addon.FARM_PROFESSIONS;
    local farmBox = CreateFrame(addon.FRAME, nil, panel, addon.BACKDROP_TEMPLATE);
    local farmCheck = farmBox:CreateTexture(nil,addon.OVERLAY);
    local farmLbl = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);

    farmBox:SetSize(14, 14);
    farmBox:SetPoint(addon.TOPLEFT, spinBtn, addon.BOTTOMLEFT, 0, -14);
    farmBox:SetBackdrop({bgFile=addon.BG_FILE,edgeFile=addon.BG_FILE,edgeSize=1});
    farmCheck:SetTexture("Interface\\Buttons\\UI-CheckBox-Check");
    farmCheck:SetSize(16,16);
    farmCheck:SetPoint(addon.CENTER, farmBox, addon.CENTER, 0, 0);
    farmLbl:SetPoint(addon.LEFT, farmBox, addon.RIGHT, 6, 0);
    farmLbl:SetText("Exclude farming professions (Herbalism, Mining, Skinning)");

    local function SetFarmState(shouldExclude)
        if not DB then
            return;
        end
        DB.excludeFarming = shouldExclude;
        local ac1,ac2,ac3 = CT.accent and CT.accent[1] or 0.84, CT.accent and CT.accent[2] or 0.67, CT.accent and CT.accent[3] or 0.20;
        local rb1,rb2,rb3 = CT.result_bg and CT.result_bg[1] or 0.06, CT.result_bg and CT.result_bg[2] or 0.04, CT.result_bg and CT.result_bg[3] or 0.10;
        local di1,di2,di3 = CT.divider and CT.divider[1] or 0.25, CT.divider and CT.divider[2] or 0.20, CT.divider and CT.divider[3] or 0.35;
        local br1,br2,br3 = CT.bright_text and CT.bright_text[1] or 1.00, CT.bright_text and CT.bright_text[2] or 0.90, CT.bright_text and CT.bright_text[3] or 0.40;
        local dm1,dm2,dm3 = CT.dim_text and CT.dim_text[1] or 0.50, CT.dim_text and CT.dim_text[2] or 0.45, CT.dim_text and CT.dim_text[3] or 0.55;
        if shouldExclude then
            farmBox:SetBackdropColor(rb1,rb2,rb3,1);
            farmBox:SetBackdropBorderColor(ac1,ac2,ac3,1);
            farmCheck:SetVertexColor(ac1,ac2,ac3,1);
            farmCheck:Show();
            farmLbl:SetTextColor(br1,br2,br3);
        else
            farmBox:SetBackdropColor(0.05,0.03,0.08,1);
            farmBox:SetBackdropBorderColor(di1,di2,di3,1);
            farmCheck:Hide();
            farmLbl:SetTextColor(dm1,dm2,dm3);
        end
    end

    local farmBtn = CreateFrame(addon.BUTTON, nil, panel);
    farmBtn:SetHeight(20);
    farmBtn:SetPoint(addon.TOPLEFT, spinBtn, addon.BOTTOMLEFT, 0, -10);
    farmBtn:SetPoint(addon.RIGHT,   panel,   addon.RIGHT, -addon.PAD, 0);
    farmBtn:SetScript(addon.OnClick, function()
        SetFarmState(not (DB and DB.excludeFarming));
    end)

    -- Init state after frame shown (C table populated by then)
    panel:SetScript(addon.OnShow, function()
        SetFarmState(DB and DB.excludeFarming or false);
        panel:SetScript(addon.OnShow, nil);
    end)

    local spinning = false;

    spinBtn:SetScript(addon.OnClick, function()
        if spinning then
            return;
        end
        local excludeFarming = DB and DB.excludeFarming;
        local pool = {};
        for _, p in ipairs(addon.PROFESSIONS) do
            if p ~= addon.FISHING and p ~= addon.COOKING and not (excludeFarming and FARMING[p]) then
                table.insert(pool, p);
            end
        end
        if #pool < 2 then
            return;
        end
        spinning = true;
        spinBtn:SetEnabled(false);

        -- Pre-pick two different winners
        local idx1   = math.random(#pool);
        local winner1 = pool[idx1];
        local pool2  = {};
        for _, p in ipairs(pool) do
            if p ~= winner1 then
                table.insert(pool2, p);
            end
        end
        local winner2 = pool2[math.random(#pool2)];

        prof1Label:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
        prof2Label:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);

        -- Chain: spin 1 then spin 2
        addon.StartSlot(prof1Label, pool, function(_)
            prof1Label:SetText(winner1);
            prof1Label:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
            addon.StartSlot(prof2Label, pool2, function(_)
                prof2Label:SetText(winner2);
                prof2Label:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
                spinning = false;
                spinBtn:SetEnabled(true);
            end);
        end);
    end);

    return panel;
end
addon.BuildProfessionPanel = BuildProfessionPanel;

