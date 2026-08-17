local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

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
    raceLabel:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
    raceLabel:SetText("Race:");
    raceBox:SetSize(200, 26);
    raceBox:SetPoint(addon.LEFT, raceLabel, addon.RIGHT, 8, 0);
    addon.BgBorder(raceBox, CT.result_bg[1],CT.result_bg[2],CT.result_bg[3], CT.result_bdr[1],CT.result_bdr[2],CT.result_bdr[3]);
    raceBoxLbl:SetPoint(addon.LEFT, raceBox, addon.LEFT, 8, 0);
    raceBoxLbl:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
    raceBoxLbl:SetText("Select Race...");
    genderLbl:SetPoint(addon.LEFT, raceBox, addon.RIGHT, 16, 0);
    genderLbl:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
    genderLbl:SetText("Gender:");
    for i, g in ipairs({"Male","Female"}) do
        local gb = addon.MakeBtn(panel, g, 72, 26);
        local gv = g;
        gb:SetPoint(addon.LEFT, genderLbl, addon.RIGHT, 6+(i-1)*76, 0);
        gb:SetScript(addon.OnClick, function()
            selectedGender = gv;
            for _, b in ipairs(genderBtns) do
                b:SetBackdropColor(CT.btn_bg[1],CT.btn_bg[2],CT.btn_bg[3]);
                b:SetBackdropBorderColor(CT.btn_bdr[1],CT.btn_bdr[2],CT.btn_bdr[3],1);
                b._lbl:SetTextColor(CT.btn_text[1],CT.btn_text[2],CT.btn_text[3]);
            end
            gb:SetBackdropColor(CT.nav_active[1],CT.nav_active[2],CT.nav_active[3]);
            gb:SetBackdropBorderColor(CT.nav_border[1],CT.nav_border[2],CT.nav_border[3],1);
            gb._lbl:SetTextColor(1,1,1);
        end);
        table.insert(genderBtns, gb);
    end
    -- Default Male active
    genderBtns[1]:SetBackdropColor(CT.nav_active[1],CT.nav_active[2],CT.nav_active[3]);
    genderBtns[1]:SetBackdropBorderColor(CT.nav_border[1],CT.nav_border[2],CT.nav_border[3],1);
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
    addon.BgBorder(raceList, CT.bg[1],CT.bg[2],CT.bg[3], CT.win_border[1],CT.win_border[2],CT.win_border[3]);
    raceList:Hide();
    table.sort(allRaces);
    raceScroll:SetPoint(addon.TOPLEFT, raceList, addon.TOPLEFT, 1, -1);

    for i, race in ipairs(allRaces) do
        local row = CreateFrame(addon.BUTTON, nil, raceScrollContent);
        local rbg = row:CreateTexture(nil,addon.BACKGROUND);
        local rlbl = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
        local rv = race;

        row:SetSize(196, 22);
        row:SetPoint(addon.TOPLEFT, raceScrollContent, addon.TOPLEFT, 0, -(i-1)*22);
        rbg:SetAllPoints();
        rbg:SetColorTexture(i%2==0 and CT.row_even[1] or CT.row_odd[1],
                            i%2==0 and CT.row_even[2] or CT.row_odd[2],
                            i%2==0 and CT.row_even[3] or CT.row_odd[3], 1);
        rlbl:SetPoint(addon.LEFT, row, addon.LEFT, 8, 0);
        rlbl:SetJustifyH(addon.LEFT);
        rlbl:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
        rlbl:SetText(race);

        row:SetScript(addon.OnClick, function()
            selectedRace = rv;
            raceBoxLbl:SetText(rv);
            raceBoxLbl:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
            raceList:Hide();
            for _, r in ipairs(raceRowFrames) do
                r._bg:SetColorTexture(r._ec and CT.row_even[1] or CT.row_odd[1],r._ec and CT.row_even[2] or CT.row_odd[2],r._ec and CT.row_even[3] or CT.row_odd[3],1);
            end

            rbg:SetColorTexture(CT.row_select[1],CT.row_select[2],CT.row_select[3],1);
        end);
        row:SetScript(addon.OnEnter, function()
            if selectedRace~=rv then
                rbg:SetColorTexture(CT.row_hover[1],CT.row_hover[2],CT.row_hover[3],1);
            end
        end);
        row:SetScript(addon.OnLeave, function()
            if selectedRace~=rv then
                rbg:SetColorTexture(i%2==0 and CT.row_even[1] or CT.row_odd[1],i%2==0 and CT.row_even[2] or CT.row_odd[2],i%2==0 and CT.row_even[3] or CT.row_odd[3],1);
            end
        end);

        row._bg = rbg;
        row._ec = (i%2==0);
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
    local nameRows = {};

    generateBtn:SetPoint(addon.TOP,   raceLabel, addon.BOTTOM,  0, -14);
    generateBtn:SetPoint(addon.LEFT,  panel, addon.LEFT,   addon.PAD, 0);
    generateBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT,  -addon.PAD, 0);
    nameHdr:SetPoint(addon.TOP,  generateBtn, addon.BOTTOM, 0, -10);
    nameHdr:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    nameBG:SetPoint(addon.TOPLEFT, nameHdr, addon.BOTTOMLEFT, 0, 0);

    local function RenderNames(names)
        for _, r in ipairs(nameRows) do
            r:Hide();
        end

        nameRows = {};

        for i, name in ipairs(names) do
            local even = (i%2==0);
            local row = CreateFrame(addon.BUTTON, nil, nameContent);
            local rb = row:CreateTexture(nil,addon.BACKGROUND);
            local nl = row:CreateFontString(nil,addon.OVERLAY);
            local copyHint = row:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
            local n = name;
            
            row:SetHeight(26);
            row:SetPoint(addon.TOP,   nameContent, addon.TOP,   0, -(i-1)*26);
            row:SetPoint(addon.LEFT,  nameContent, addon.LEFT,  0, 0);
            row:SetPoint(addon.RIGHT, nameContent, addon.RIGHT, 0, 0);
            rb:SetAllPoints();
            rb:SetColorTexture(even and CT.row_even[1] or CT.row_odd[1],
                               even and CT.row_even[2] or CT.row_odd[2],
                               even and CT.row_even[3] or CT.row_odd[3], 1);
            nl:SetFont(addon.GAME_FONT, 13, addon.EMPTY_STRING);
            nl:SetPoint(addon.LEFT, row, addon.LEFT, 12, 0);
            nl:SetJustifyH(addon.LEFT);
            nl:SetTextColor(CT.spin_text[1],CT.spin_text[2],CT.spin_text[3]);
            nl:SetText(name);
            copyHint:SetPoint(addon.RIGHT, row, addon.RIGHT, -10, 0);
            copyHint:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
            copyHint:SetText("click to copy");
            copyHint:Hide();

            row:SetScript(addon.OnClick, function()
                -- Copy to default chat editbox
                ChatFrame_OpenChat(n);
            end);

            row:SetScript(addon.OnEnter, function()
                rb:SetColorTexture(CT.row_hover[1],CT.row_hover[2],CT.row_hover[3],1);
                copyHint:Show();
            end);

            row:SetScript(addon.OnLeave, function()
                rb:SetColorTexture(even and CT.row_even[1] or CT.row_odd[1],
                                   even and CT.row_even[2] or CT.row_odd[2],
                                   even and CT.row_even[3] or CT.row_odd[3], 1);
                copyHint:Hide();
            end);
            
            table.insert(nameRows, row);
        end

        nameContent:SetHeight(math.max(26, #names*26+2));
        nameReset();
    end

    generateBtn:SetScript(addon.OnClick, function()
        if not selectedRace then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a race first.", 1,0.8,0.2);
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
