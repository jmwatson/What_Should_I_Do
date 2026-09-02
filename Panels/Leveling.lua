local _, addon = ...;
local DB = addon.DB;
local CT = addon.Runtime.COLOR_TABLE;

local LevelingPanelMixin = {};

function LevelingPanelMixin:AutoPick()
    self.autoPick = not self.autoPick;
    if self.autoPick then
        self.autoPickBtn._lbl:SetText("On");
        addon.ApplyColor(self.autoPickBtn, "SetBackdropColor", CT.nav_active);
        addon.ApplyColor(self.autoPickBtn, "SetBackdropBorderColor", CT.nav_border);
        addon.ApplyColor(self.autoPickBtn._lbl, "SetTextColor", addon.BLACK);
    else
        self.autoPickBtn._lbl:SetText("Off");
        addon.ApplyColor(self.autoPickBtn, "SetBackdropColor", CT.btn_bg);
        addon.ApplyColor(self.autoPickBtn, "SetBackdropBorderColor", CT.btn_bdr);
        addon.ApplyColor(self.autoPickBtn._lbl, "SetTextColor", CT.btn_text);
    end
end

function LevelingPanelMixin:SetSpinButtonsEnabled(enabled)
    self.spinClassBtn:SetEnabled(enabled);
    self.spinExpBtn:SetEnabled(enabled);
    self.spinAllBtn:SetEnabled(enabled);
end

function LevelingPanelMixin:GetEligibleChars(class)
    local matches = {};

    for key, ch in pairs(DB.seenChars) do
        local excluded = DB.excludedChars and DB.excludedChars[key];

        if ch.class == class and (ch.level or 0) < 90 and not excluded then
            table.insert(matches, ch);
        end
    end

    -- Order by name > level > realm
    table.sort(matches, function(a, b)
        if a.name ~= b.name then
            return a.name < b.name;
        end

        if a.level ~= b.level then
            return a.level < b.level;
        end

        return (a.realm or addon.EMPTY_STRING) < (b.realm or addon.EMPTY_STRING);
    end);

    return matches;
end

function LevelingPanelMixin:ClearList()
    self.characterRowPool:ReleaseAll();

    if self.autoPickTimer then
        self.autoPickTimer:Cancel();
        self.autoPickTimer = nil;
    end

    if self.autoPickFlashTimer then
        self.autoPickFlashTimer:Cancel();
        self.autoPickFlashTimer = nil;
    end

    if self.noneLabel then
        self.noneLabel:Hide();
    end

    self.selectedChar=nil;
    self.listContent:SetHeight(110);
    self.listReset();
end

function LevelingPanelMixin:SelectRow(row)
    self.selectedChar = row._charData;

    for r in self.characterRowPool:EnumerateActive() do
        addon.ApplyColor(r.bg, "SetColorTexture", r._even and CT.row_even or CT.row_odd);
    end

    addon.ApplyColor(row.bg, "SetColorTexture", CT.row_select);
end

---@param class string
function LevelingPanelMixin:PopulateList(class)
    self:ClearList();
    local matches = self:GetEligibleChars(class);

    if #matches == 0 then
        if not self.noneLabel then
            self.noneLabel = self.listContent:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
            self.noneLabel:SetPoint(addon.TOPLEFT, self.listContent, addon.TOPLEFT, 8, -8);
            addon.ApplyColor(self.noneLabel, "SetTextColor", {0.65, 0.3, 0.3});
        end

        self.noneLabel:SetText("No "..class.."s available for leveling. (Max level characters are excluded.)");
        self.noneLabel:Show();
        self.listContent:SetHeight(30);
        return;
    end

    for i, ch in ipairs(matches) do
        local even = (i % 2 == 0);
        local row = self.characterRowPool:Acquire();

        if not row.bg then
            row.bg = row:CreateTexture(nil, addon.BACKGROUND);
            row.bg:SetAllPoints();
            row.fs = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
            row.fs:SetPoint(addon.LEFT, row, addon.LEFT, 10, 0);
            row.fs:SetJustifyH(addon.LEFT);
        end

        row:Show();
        row:SetHeight(24);
        row:ClearAllPoints();
        row:SetPoint(addon.TOP,   self.listContent, addon.TOP,   0, -(i - 1) * 24);
        row:SetPoint(addon.LEFT,  self.listContent, addon.LEFT,  0, 0);
        row:SetPoint(addon.RIGHT, self.listContent, addon.RIGHT, 0, 0);

        local cc = addon.GetClassColor(ch.class) or {r=0.8, g=0.8, b=0.8};
        cc = addon.MulRGBL(cc, {255, 255, 255});
        addon.ApplyColor(row.bg, "SetColorTexture", even and CT.row_even or CT.row_odd);
        row.fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s|r  |cffffcc00Lv %d|r%s",
            cc.r, cc.g, cc.b, ch.name, ch.race or addon.EMPTY_STRING, ch.level or 0,
            ch.current and "  |cff55cc55(you)|r" or addon.EMPTY_STRING));
        
        row._even = even;
        row._charData = ch;

        row:SetScript(addon.OnClick, function() self:SelectRow(row); end);
        row:SetScript(addon.OnEnter, function()
            if self.selectedChar ~= ch then
                addon.ApplyColor(row.bg, "SetColorTexture", CT.row_hover);
            end
        end);
        row:SetScript(addon.OnLeave, function()
            if self.selectedChar ~= ch then
                addon.ApplyColor(row.bg, "SetColorTexture", even and CT.row_even or CT.row_odd);
            end
        end);
    end

    self.listContent:SetHeight(math.max(24, #matches * 24 + 2));
end

function LevelingPanelMixin:DoSpinClass(onDone)
    local pool={};

    for _, clsInfo in pairs(addon.CLASS_INFO) do
        table.insert(pool, clsInfo.name);
    end

    addon.StopSlot();
    self.selectedChar = nil;
    self.classLabel:SetText("Class");
    self.expLabel:SetText("Expansion");
    self.spinExpBtn:SetEnabled(false);
    self:ClearList();

    addon.ApplyColor(self.expLabel, "SetTextColor", CT.dim_text);
    addon.ApplyColor(self.classLabel, "SetTextColor", CT.bright_text);

    addon.StartSlot(self.classLabel, pool, function(winner)
        local cc = addon.CLASS_INFO[winner];

        if cc then
            addon.ApplyRGB(self.classLabel, "SetTextColor", cc.colors);
        end

        self:PopulateList(winner);
        self.spinExpBtn:SetEnabled(true);

        -- Auto-pick: spin a random eligible character from the list
        if self.autoPick then
            local eligible = {};

            for row in self.characterRowPool:EnumerateActive() do
                table.insert(eligible, row);
            end

            if #eligible > 0 then
                -- Small delay so the class slot finishes visually first
                self.autoPickTimer = C_Timer.NewTimer(0.3, function()
                    self.autoPickTimer = nil;
                    local pick = eligible[math.random(#eligible)];
                    self:SelectRow(pick);
                    -- Flash the selected row so user sees it
                    addon.ApplyColor(pick.bg, "SetColorTexture", addon.MulColor(CT.spin_text, {0.6, 0.6, 0.6}));
                    self.autoPickFlashTimer = C_Timer.NewTimer(0.15, function()
                        self.autoPickFlashTimer = nil;
                        addon.ApplyColor(pick.bg, "SetColorTexture", CT.row_select);
                    end);
                end);
            end
        end

        if onDone then onDone(winner); end
    end);
end

function LevelingPanelMixin:FindRowForChar(char)
    for row in self.characterRowPool:EnumerateActive() do
        if row._charData == char then
            return row;
        end
    end

    return nil;
end

function LevelingPanelMixin:SpinExpansionFor(char, onDone)
    local pool = addon.GetExpansionPool(char.level or 1);

    if #pool == 1 then
        self.expLabel:SetText(pool[1]);
        addon.ApplyColor(self.expLabel, "SetTextColor", CT.spin_text);
        if onDone then onDone() end
        return;
    end

    addon.StopSlot();
    addon.ApplyColor(self.expLabel, "SetTextColor", CT.bright_text);
    addon.StartSlot(self.expLabel, pool, function(_)
        addon.ApplyColor(self.expLabel, "SetTextColor", CT.spin_text);
        if onDone then onDone() end
    end);
end

function LevelingPanelMixin:SpinClassBtnClick()
    self.spinClassBtn:SetEnabled(false);
    self.spinAllBtn:SetEnabled(false);
    self:DoSpinClass(function(_)
        self.spinClassBtn:SetEnabled(true);
        self.spinAllBtn:SetEnabled(true);
    end);
end

function LevelingPanelMixin:SpinExpBtnClick()
    if not self.selectedChar then
        UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a character first.", 1, 0.8, 0.2);
        return;
    end
    
    self.spinExpBtn:SetEnabled(false);
    self:SpinExpansionFor(self.selectedChar, function()
        self.spinExpBtn:SetEnabled(true);
    end);
end

function LevelingPanelMixin:SpinAllBtnClick()
    self:SetSpinButtonsEnabled(false);
    self:DoSpinClass(function(winner)
        local autoChar = self:GetEligibleChars(winner)[1];

        if not autoChar then
            self:SetSpinButtonsEnabled(true);
            return;
        end

        local row = self:FindRowForChar(autoChar);

        if row then
            self:SelectRow(row);
        else
            self.selectedChar = autoChar;
        end

        self:SpinExpansionFor(autoChar, function()
            self:SetSpinButtonsEnabled(true);
        end);
    end);
end

local function BuildLevelingPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    Mixin(panel, LevelingPanelMixin);

    panel.header = addon.MakeHeader(panel, "Leveling Wheel");
    panel.header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    panel.desc = addon.MakeLabel(panel, "Spin a class -> pick a character -> spin an expansion.", panel.header, addon.BOTTOMLEFT, 4, -8);
    panel.autoPickLbl = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    panel.autoPickLbl:SetPoint(addon.TOPLEFT, panel.desc, addon.BOTTOMLEFT, 0, -8);
    panel.autoPickLbl:SetText("Auto-pick a character after class spin:");
    panel.autoPick = false;
    panel.autoPickBtn = addon.MakeBtn(panel, "Off", 60, 24);
    panel.autoPickBtn:SetPoint(addon.LEFT, panel.autoPickLbl, addon.RIGHT, 8, 0);
    panel.classBox, panel.classLabel = addon.MakeResult(panel, nil, 52, "CLASS");
    panel.classBox:SetPoint(addon.TOPLEFT, panel.autoPickLbl, addon.BOTTOMLEFT, 0, -10);
    panel.classLabel:SetText("Class");
    panel.spinClassBtn = addon.MakeBtn(panel, "Spin Class", nil, 30);
    panel.spinClassBtn:SetPoint(addon.TOP, panel.classBox, addon.BOTTOM, 0, -10);
    panel.spinClassBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.spinClassBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    panel.charHdr = addon.MakeHeader(panel, "Characters of that class  (click to select)");
    panel.charHdr:SetPoint(addon.TOPLEFT, panel.spinClassBtn, addon.BOTTOMLEFT, 0, -10);
    panel.listBG, panel.listContent, panel.listReset = addon.MakeScrollBox(panel, nil, 110);
    panel.listBG:SetPoint(addon.TOPLEFT, panel.charHdr, addon.BOTTOMLEFT, 0, 0);
    panel.noneLabel = panel.listContent:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    panel.noneLabel:SetPoint(addon.TOPLEFT, panel.listContent, addon.TOPLEFT, 8, -8);
    panel.noneLabel:SetTextColor(0.65, 0.30, 0.30);
    panel.noneLabel:Hide();

    panel.characterRowPool = CreateFramePool(addon.BUTTON, panel.listContent);

    panel.expBox, panel.expLabel = addon.MakeResult(panel, nil, 52, "EXPANSION");
    panel.expBox:SetPoint(addon.TOPLEFT, panel.listBG, addon.BOTTOMLEFT, 0, -10);
    panel.expLabel:SetText("Expansion")
    panel.spinExpBtn = addon.MakeBtn(panel, "Spin Expansion", nil, 30);
    panel.spinExpBtn:SetPoint(addon.TOP, panel.expBox, addon.BOTTOM, 0, -10);
    panel.spinExpBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    panel.spinExpBtn:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);
    panel.spinExpBtn:SetEnabled(false)
    panel.spinAllBtn = addon.MakeBtn(panel, "Spin All Steps", nil, 30);
    panel.spinAllBtn:SetPoint(addon.TOP, panel.expBox, addon.BOTTOM, 0, -10);
    panel.spinAllBtn:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    panel.spinAllBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    panel.noteLbl = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    panel.noteLbl:SetPoint(addon.TOPLEFT, panel.spinExpBtn, addon.BOTTOMLEFT, 0, -10);
    panel.noteLbl:SetText("Roster fills automatically as you log into each character.");

    addon.ApplyColor(panel.autoPickLbl, "SetTextColor", CT.dim_text);
    addon.ApplyColor(panel.noteLbl, "SetTextColor", CT.dim_text);

    panel.pickedClass=nil;
    panel.selectedChar=nil;

    panel.autoPickBtn:SetScript(addon.OnClick, function() panel:AutoPick(); end);
    panel.spinClassBtn:SetScript(addon.OnClick, function() panel:SpinClassBtnClick(); end);
    panel.spinExpBtn:SetScript(addon.OnClick, function() panel:SpinExpBtnClick(); end);
    panel.spinAllBtn:SetScript(addon.OnClick, function() panel:SpinAllBtnClick(); end);

    return panel;
end
addon.BuildLevelingPanel = BuildLevelingPanel;
