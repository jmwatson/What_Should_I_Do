local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

local function SetupRow(row)
    row.bg = row:CreateTexture(nil, addon.BACKGROUND);
    row.bg:SetAllPoints();
    row.nl = row:CreateFontString(nil, addon.OVERLAY);
    row.nl:SetFont(addon.GAME_FONT, 13, addon.EMPTY_STRING);
    row.nl:SetPoint(addon.LEFT, row, addon.LEFT, 12, 0);
    row.nl:SetJustifyH(addon.LEFT);
    row.copyHint = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    row.copyHint:SetPoint(addon.RIGHT, row, addon.RIGHT, -10, 0);
    addon.ApplyColor(row.copyHint, "SetTextColor", CT.dim_text);
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

local NamesPanelMixin = {};

function NamesPanelMixin:MakeGenderBtn(gender)
    local offset = gender == "Male" and 0 or 1;
    local btn = addon.MakeBtn(self, gender, 72, 26);
    btn:SetPoint(addon.LEFT, self.genderLbl, addon.RIGHT, 6 + offset * 76, 0);
    btn:SetScript(addon.OnClick, function()
        self.selectedGender = gender;
        for _, b in ipairs(self.genderBtns) do
            addon.ApplyColor(b, "SetBackdropColor", CT.btn_bg);
            addon.ApplyColor(b, "SetBackdropBorderColor", CT.btn_bdr);
            addon.ApplyColor(b._lbl, "SetTextColor", CT.btn_text);
        end
        addon.ApplyColor(btn, "SetBackdropColor", CT.nav_active);
        addon.ApplyColor(btn, "SetBackdropBorderColor", CT.nav_border);
        addon.ApplyColor(btn._lbl, "SetTextColor", addon.BLACK);
    end);

    return btn;
end

function NamesPanelMixin:RenderNames(names)
    self.nameRowPool:ReleaseAll();

    for i, name in ipairs(names) do
        local row = addon.AcquirePooledRow(self.nameRowPool, SetupRow);

        row._name = name;
        row._even = (i % 2 == 0);
        row:SetHeight(26);
        row:SetPoint(addon.TOP,   self.nameContent, addon.TOP,   0, -(i - 1) * 26);
        row:SetPoint(addon.LEFT,  self.nameContent, addon.LEFT,  0, 0);
        row:SetPoint(addon.RIGHT, self.nameContent, addon.RIGHT, 0, 0);
        addon.ApplyColor(row.bg, "SetColorTexture", row._even and CT.row_even or CT.row_odd);
        addon.ApplyColor(row.nl, "SetTextColor", CT.spin_text);
        row.nl:SetText(name);
        row:Show();
    end

    self.nameContent:SetHeight(math.max(26, #names * 26 + 2));
    self.nameReset();
end

function NamesPanelMixin:SelectRace(row)
    self.selectedRace = row._name;
    self.raceBoxLbl:SetText(row._name);
    addon.ApplyColor(self.raceBoxLbl, "SetTextColor", CT.spin_text);
    self.raceList:Hide();

    for _, r in ipairs(self.raceRowFrames) do
        addon.ApplyColor(r._bg, "SetColorTexture", r._even and CT.row_even or CT.row_odd);
    end

    addon.ApplyColor(row._bg, "SetColorTexture", CT.row_select);
end

local function BuildNamePanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, NamesPanelMixin);

    panel.header = addon.MakeHeader(panel, addon.NAMES_LABEL);
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    panel.desc = addon.MakeLabel(panel, "Pick a race and gender to generate a list of names.", panel.header, addon.BOTTOMLEFT, 4, -8);
    panel.raceLbl = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.raceLbl:SetPoint(addon.TOPLEFT, panel.desc, addon.BOTTOMLEFT, 0, -10);
    panel.raceLbl:SetText("Race:");
    panel.raceBox = CreateFrame(addon.BUTTON, nil, panel, addon.BACKDROP_TEMPLATE);
    panel.raceBox:SetSize(200, 26);
    panel.raceBox:SetPoint(addon.LEFT, panel.raceLbl, addon.RIGHT, 8, 0);
    panel.raceBoxLbl = panel.raceBox:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
    panel.raceBoxLbl:SetPoint(addon.LEFT, panel.raceBox, addon.LEFT, 8, 0);
    panel.raceBoxLbl:SetText("Select Race...");
    panel.genderLbl = panel:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL)
    panel.genderLbl:SetPoint(addon.LEFT, panel.raceBox, addon.RIGHT, 16, 0);
    panel.genderLbl:SetText("Gender:");
    panel.selectedGender = "Male";
    panel.genderBtns = {
        panel:MakeGenderBtn("Male");
        panel:MakeGenderBtn("Female");
    };

    addon.ApplyColor(panel.raceLbl, "SetTextColor", CT.dim_text);
    addon.BgBorder(panel.raceBox, CT.result_bg, CT.result_bdr);
    addon.ApplyColor(panel.raceBoxLbl, "SetTextColor", CT.bright_text);
    addon.ApplyColor(panel.genderLbl, "SetTextColor", CT.dim_text);

    -- Default Male active
    addon.ApplyColor(panel.genderBtns[1], "SetBackdropColor", CT.nav_active);
    addon.ApplyColor(panel.genderBtns[1], "SetBackdropBorderColor", CT.nav_border);
    addon.ApplyColor(panel.genderBtns[1]._lbl, "SetTextColor", addon.BLACK);

    -- Race dropdown popup
    panel.raceList = CreateFrame(addon.FRAME, nil, panel, addon.BACKDROP_TEMPLATE);
    panel.allRaces = addon.GetRaceNames();
    panel.selectedRace = nil;
    panel.raceRowFrames = {};
    panel.raceScroll, panel.raceContent, _ = addon.MakeScrollBox(panel.raceList, 198, 298);

    panel.raceList:SetSize(200, 300);
    panel.raceList:SetPoint(addon.TOPLEFT, panel.raceBox, addon.BOTTOMLEFT, 0, -2);
    panel.raceList:SetFrameStrata("TOOLTIP");
    addon.BgBorder(panel.raceList, CT.bg, CT.win_border);
    panel.raceList:Hide();
    table.sort(panel.allRaces);
    panel.raceScroll:SetPoint(addon.TOPLEFT, panel.raceList, addon.TOPLEFT, 1, -1);

    for i, race in ipairs(panel.allRaces) do
        local row = CreateFrame(addon.BUTTON, nil, panel.raceContent);
        row._bg = row:CreateTexture(nil, addon.BACKGROUND);
        row._lbl = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
        row._name = race;
        row._even = (i % 2 == 0);

        row:SetSize(196, 22);
        row:SetPoint(addon.TOPLEFT, panel.raceContent, addon.TOPLEFT, 0, -(i - 1) * 22);
        row._bg:SetAllPoints();
        addon.ApplyColor(row._bg, "SetColorTexture", i % 2 == 0 and CT.row_even or CT.row_odd);
        row._lbl:SetPoint(addon.LEFT, row, addon.LEFT, 8, 0);
        row._lbl:SetJustifyH(addon.LEFT);
        addon.ApplyColor(row._lbl, "SetTextColor", CT.bright_text);
        row._lbl:SetText(row._name);

        row:SetScript(addon.OnClick, function() panel:SelectRace(row); end);
        row:SetScript(addon.OnEnter, function()
            if panel.selectedRace ~= row._name then
                addon.ApplyColor(row._bg, "SetColorTexture", CT.row_hover);
            end
        end);
        row:SetScript(addon.OnLeave, function()
            if panel.selectedRace ~= row._name then
                addon.ApplyColor(row._bg, "SetColorTexture", i % 2 == 0 and CT.row_even or CT.row_odd);
            end
        end);

        table.insert(panel.raceRowFrames, row);
    end

    panel.raceContent:SetHeight(#panel.allRaces * 22 + 2);

    panel.raceBox:SetScript(addon.OnClick, function()
        if panel.raceList:IsShown() then
            panel.raceList:Hide();
        else
            panel.raceList:Show();
        end
    end);

    -- Generate button
    panel.generateBtn = addon.MakeBtn(panel, "Generate Names", nil, 30);
    panel.nameHdr = addon.MakeHeader(panel, "Generated Names  (click to copy to chat)");
    panel.nameBG, panel.nameContent, panel.nameReset = addon.MakeScrollBox(panel, nil, 200);
    panel.nameRowPool = CreateFramePool(addon.BUTTON, panel.nameContent);

    panel.generateBtn:SetPoint(addon.TOP,   panel.raceLbl, addon.BOTTOM,  0, -14);
    panel.generateBtn:SetPoint(addon.LEFT,  panel, addon.LEFT,   addon.PAD, 0);
    panel.generateBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT,  -addon.PAD, 0);
    panel.nameHdr:SetPoint(addon.TOP,  panel.generateBtn, addon.BOTTOM, 0, -10);
    panel.nameHdr:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.nameBG:SetPoint(addon.TOPLEFT, panel.nameHdr, addon.BOTTOMLEFT, 0, 0);

    panel.generateBtn:SetScript(addon.OnClick, function()
        if not panel.selectedRace then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a race first.", 1, 0.8, 0.2);
            return;
        end

        panel.raceList:Hide();
        local names = addon.GenerateNameList(panel.selectedRace, panel.selectedGender, 10);
        panel:RenderNames(names);
    end);

    return panel;
end
addon.BuildNamePanel = BuildNamePanel;
