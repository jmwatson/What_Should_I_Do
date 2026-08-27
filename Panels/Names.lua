local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local function SetupRow(row)
    row.bg = row:CreateTexture(nil, addon.BACKGROUND);
    row.bg:SetAllPoints();
    row.nl = row:CreateFontString(nil, addon.OVERLAY);
    row.nl:SetFont(addon.GAME_FONT, 13, addon.EMPTY_STRING);
    row.nl:SetPoint(addon.LEFT, row, addon.LEFT, 12, 0);
    row.nl:SetJustifyH(addon.LEFT);
    row.copyHint = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    row.copyHint:SetPoint(addon.RIGHT, row, addon.RIGHT, -10, 0);
    addon.ApplyColor(row.copyHint, "SetTextColor", CT.dim_t);
    row.copyHint:SetText("click to copy");
    row.copyHint:Hide();

    row:SetScript(addon.OnClick, function()
        ChatFrame_OpenChat(row._name);
    end);
    row:SetScript(addon.OnEnter, function()
        addon.ApplyColor(row.bg, "SetColorTexture", CT.row_hover);
        row.copyHint:Show();
    end);
    row:SetScript(addon.OnLeave, function()
        addon.ApplyColor(row.bg, "SetColorTexture", row._even and CT.row_even or CT.row_odd);
        row.copyHint:Hide();
    end);
end

local function BuildNamePanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    local hdr = addon.MakeHeader(panel, addon.NAMES_LABEL);
    local desc = addon.MakeLabel(panel, "Pick a race and gender to generate a list of names.", hdr, addon.BOTTOMLEFT, 4, -8);
    local raceLabel = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    local raceBox = CreateFrame(addon.BUTTON, nil, panel, addon.BACKDROP_TEMPLATE);
    local raceBoxLbl = raceBox:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    local genderLbl = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    local selectedGender = "Male";
    local genderBtns = {};

    hdr:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    raceLabel:SetPoint(addon.TOPLEFT, desc, addon.BOTTOMLEFT, 0, -10);
    addon.ApplyColor(raceLabel, "SetTextColor", CT.dim_text);
    raceLabel:SetText("Race:");
    raceBox:SetSize(200, 26);
    raceBox:SetPoint(addon.LEFT, raceLabel, addon.RIGHT, 8, 0);
    addon.BgBorder(raceBox, CT.result_bg, CT.result_bdr);
    raceBoxLbl:SetPoint(addon.LEFT, raceBox, addon.LEFT, 8, 0);
    addon.ApplyColor(raceBoxLbl, "SetTextColor", CT.bright_text);
    raceBoxLbl:SetText("Select Race...");
    genderLbl:SetPoint(addon.LEFT, raceBox, addon.RIGHT, 16, 0);
    addon.ApplyColor(genderLbl, "SetTextColor", CT.dim_text);
    genderLbl:SetText("Gender:");
    for i, g in ipairs({"Male","Female"}) do
        local gb = addon.MakeBtn(panel, g, 72, 26);
        local gv = g;
        gb:SetPoint(addon.LEFT, genderLbl, addon.RIGHT, 6+(i-1)*76, 0);
        gb:SetScript(addon.OnClick, function()
            selectedGender = gv;
            for _, b in ipairs(genderBtns) do
                addon.ApplyColor(b, "SetBackdropColor", CT.btn_bg);
                addon.ApplyColor(b, "SetBackdropBorderColor", CT.btn_bdr);
                addon.ApplyColor(b, "SetTextColor", CT.btn_text);
            end
            addon.ApplyColor(gb, "SetBackdropColor", CT.nav_active);
            addon.ApplyColor(gb, "SetBackdropBorderColor", CT.nav_border);
            gb._lbl:SetTextColor(1,1,1);
        end);
        table.insert(genderBtns, gb);
    end
    -- Default Male active
    addon.ApplyColor(genderBtns[1], "SetBackdropColor", CT.nav_active);
    addon.ApplyColor(genderBtns[1], "SetBackdropBorderColor", CT.nav_border);
    genderBtns[1]._lbl:SetTextColor(1,1,1);

    -- Race dropdown popup
    local raceList = CreateFrame(addon.FRAME, nil, panel, addon.BACKDROP_TEMPLATE);
    local allRaces = addon.GetRaceNames();
    local selectedRace = nil;
    local raceRowFrames = {};
    local raceScroll, raceScrollContent, _ = addon.MakeScrollBox(raceList, 198, 298);

    raceList:SetSize(200, 300);
    raceList:SetPoint(addon.TOPLEFT, raceBox, addon.BOTTOMLEFT, 0, -2);
    raceList:SetFrameStrata("TOOLTIP");
    addon.BgBorder(raceList, CT.bg, CT.win_border);
    raceList:Hide();
    table.sort(allRaces);
    raceScroll:SetPoint(addon.TOPLEFT, raceList, addon.TOPLEFT, 1, -1);

    for i, race in ipairs(allRaces) do
        local row = CreateFrame(addon.BUTTON, nil, raceScrollContent);
        local rbg = row:CreateTexture(nil, addon.BACKGROUND);
        local rlbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
        local rv = race;

        row:SetSize(196, 22);
        row:SetPoint(addon.TOPLEFT, raceScrollContent, addon.TOPLEFT, 0, -(i-1)*22);
        rbg:SetAllPoints();
        addon.ApplyColor(rbg, "SetColorTexture", i % 2 == 0 and CT.row_even or CT.row_odd);
        rlbl:SetPoint(addon.LEFT, row, addon.LEFT, 8, 0);
        rlbl:SetJustifyH(addon.LEFT);
        addon.ApplyColor(rlbl, "SetTextColor", CT.bright_text);
        rlbl:SetText(race);

        row:SetScript(addon.OnClick, function()
            selectedRace = rv;
            raceBoxLbl:SetText(rv);
            addon.ApplyColor(raceBoxLbl, "SetTextColor", CT.spin_text);
            raceList:Hide();
            for _, r in ipairs(raceRowFrames) do
                addon.ApplyColor(r._bg, "SetColorTexture", r._ec and CT.row_even or CT.row_odd);
            end

            addon.ApplyColor(rbg, "SetColorTexture", CT.row_select);
        end);
        row:SetScript(addon.OnEnter, function()
            if selectedRace~=rv then
                addon.ApplyColor(rbg, "SetColorTexture", CT.row_hover);
            end
        end);
        row:SetScript(addon.OnLeave, function()
            if selectedRace~=rv then
                addon.ApplyColor(rbg, "SetColorTexture", i % 2 == 0 and CT.row_even or CT.row_odd);
            end
        end);

        row._bg = rbg;
        row._ec = (i % 2 == 0);
        table.insert(raceRowFrames, row);
    end

    raceScrollContent:SetHeight(#allRaces * 22 + 2);

    raceBox:SetScript(addon.OnClick, function()
        if raceList:IsShown() then
            raceList:Hide();
        else
            raceList:Show();
        end
    end);

    -- Generate button
    local generateBtn = addon.MakeBtn(panel, "Generate Names", nil, 30);
    local nameHdr = addon.MakeHeader(panel, "Generated Names  (click to copy to chat)");
    local nameBG, nameContent, nameReset = addon.MakeScrollBox(panel, nil, 200);
    local nameRowPool = CreateFramePool(addon.BUTTON, nameContent);

    generateBtn:SetPoint(addon.TOP,   raceLabel, addon.BOTTOM,  0, -14);
    generateBtn:SetPoint(addon.LEFT,  panel, addon.LEFT,   addon.PAD, 0);
    generateBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT,  -addon.PAD, 0);
    nameHdr:SetPoint(addon.TOP,  generateBtn, addon.BOTTOM, 0, -10);
    nameHdr:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    nameBG:SetPoint(addon.TOPLEFT, nameHdr, addon.BOTTOMLEFT, 0, 0);

    local function RenderNames(names)
        nameRowPool:ReleaseAll();

        for i, name in ipairs(names) do
            local even = (i % 2 == 0);
            local row = addon.AcquirePooledRow(nameRowPool, SetupRow);

            row._name = name;
            row._even = even;
            row:SetHeight(26);
            row:SetPoint(addon.TOP,   nameContent, addon.TOP,   0, -(i - 1) * 26);
            row:SetPoint(addon.LEFT,  nameContent, addon.LEFT,  0, 0);
            row:SetPoint(addon.RIGHT, nameContent, addon.RIGHT, 0, 0);
            addon.ApplyColor(row.bg, "SetColorTexture", even and CT.row_even or CT.row_odd);
            addon.ApplyColor(row.nl, "SetTextColor", CT.spin_text);
            row.nl:SetText(name);
        end

        nameContent:SetHeight(math.max(26, #names * 26 + 2));
        nameReset();
    end

    generateBtn:SetScript(addon.OnClick, function()
        if not selectedRace then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a race first.", 1, 0.8, 0.2);
            return;
        end

        raceList:Hide();
        local names = addon.GenerateNameList(selectedRace, selectedGender, 10);
        RenderNames(names);
    end);

    -- Also generate when race is selected from dropdown
    -- (handled inline above; user can click Generate)

    return panel;
end
addon.BuildNamePanel = BuildNamePanel;
