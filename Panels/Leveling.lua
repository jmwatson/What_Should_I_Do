local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;

local function BuildLevelingPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    local header = addon.MakeHeader(panel, "Leveling Wheel");
    local description = addon.MakeLabel(panel, "Spin a class -> pick a character -> spin an expansion.", header, addon.BOTTOMLEFT, 4, -8);
    -- Auto-pick character toggle
    local autoPickLbl = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    local autoPick = false;
    local autoPickBtn = addon.MakeBtn(panel, "Off", 60, 24);

    header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    autoPickLbl:SetPoint(addon.TOPLEFT, description, addon.BOTTOMLEFT, 0, -8);
    addon.ApplyColor(autoPickLbl, "SetTextColor", CT.dim_text);
    autoPickLbl:SetText("Auto-pick a character after class spin:");
    autoPickBtn:SetPoint(addon.LEFT, autoPickLbl, addon.RIGHT, 8, 0);
    autoPickBtn:SetScript(addon.OnClick, function()
        autoPick = not autoPick;
        if autoPick then
            autoPickBtn._lbl:SetText("On");
            addon.ApplyColor(autoPickBtn, "SetBackdropColor", CT.nav_active);
            addon.ApplyColor(autoPickBtn, "SetBackdropBorderColor", CT.nav_border);
            addon.ApplyColor(autoPickBtn._lbl, "SetTextColor", addon.BLACK);
        else
            autoPickBtn._lbl:SetText("Off");
            addon.ApplyColor(autoPickBtn, "SetBackdropColor", CT.btn_bg);
            addon.ApplyColor(autoPickBtn, "SetBackdropBorderColor", CT.btn_bdr);
            addon.ApplyColor(autoPickBtn._lbl, "SetTextColor", CT.btn_text);
        end
    end);

    local classBox, classLabel = addon.MakeResult(panel, nil, 52, "CLASS");
    classBox:SetPoint(addon.TOPLEFT, autoPickLbl, addon.BOTTOMLEFT, 0, -10);
    classLabel:SetText("Class");

    local spinClassBtn = addon.MakeBtn(panel, "Spin Class", nil, 30);
    spinClassBtn:SetPoint(addon.TOP, classBox, addon.BOTTOM, 0, -10);
    spinClassBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    spinClassBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);

    local charHdr = addon.MakeHeader(panel, "Characters of that class  (click to select)");
    charHdr:SetPoint(addon.TOPLEFT, spinClassBtn, addon.BOTTOMLEFT, 0, -10);

    local listBG, listContent, listReset = addon.MakeScrollBox(panel, nil, 110);
    listBG:SetPoint(addon.TOPLEFT, charHdr, addon.BOTTOMLEFT, 0, 0);

    local noneLabel = listContent:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    noneLabel:SetPoint(addon.TOPLEFT, listContent, addon.TOPLEFT, 8, -8);
    noneLabel:SetTextColor(0.65, 0.30, 0.30);
    noneLabel:Hide();

    local characterRowPool = CreateFramePool(addon.BUTTON, listContent);
    local firstRow = nil;

    local expBox, expLabel = addon.MakeResult(panel, nil, 52, "EXPANSION");
    expBox:SetPoint(addon.TOPLEFT, listBG, addon.BOTTOMLEFT, 0, -10);
    expLabel:SetText("Expansion")

    local spinExpBtn = addon.MakeBtn(panel, "Spin Expansion", nil, 30);
    spinExpBtn:SetPoint(addon.TOP, expBox, addon.BOTTOM, 0, -10);
    spinExpBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    spinExpBtn:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);
    spinExpBtn:SetEnabled(false)

    local spinAllBtn = addon.MakeBtn(panel, "Spin All Steps", nil, 30);
    spinAllBtn:SetPoint(addon.TOP, expBox, addon.BOTTOM, 0, -10);
    spinAllBtn:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    spinAllBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);

    local noteLbl = panel:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
    noteLbl:SetPoint(addon.TOPLEFT, spinExpBtn, addon.BOTTOMLEFT, 0, -10);
    noteLbl:SetTextColor(CT.dim_text[1], CT.dim_text[2], CT.dim_text[3]);
    noteLbl:SetText("Roster fills automatically as you log into each character.");

    local pickedClass=nil;
    local selectedChar=nil;

    local function ClearList()
        characterRowPool:ReleaseAll();
        noneLabel:Hide();
        firstRow=nil;
        selectedChar=nil;
        listContent:SetHeight(110);
        listReset();
    end

    local function PopulateList(class)
        ClearList();
        local matches={};
        for _,ch in ipairs(DB.seenChars) do
            local excluded = DB.excludedChars and DB.excludedChars[ch.name];
            if ch.class==class and (ch.level or 0) < 90 and not excluded then
                table.insert(matches,ch);
            end
        end
        if #matches==0 then
            noneLabel:SetText("No "..class.."s available for leveling. (Max level characters are excluded.)");
            noneLabel:Show();
            listContent:SetHeight(30);
            return;
        end
        for i,ch in ipairs(matches) do
            local even=(i%2==0);
            local row = characterRowPool:Acquire();
            if not row.bg then
                row.bg = row:CreateTexture(nil, addon.BACKGROUND);
                row.bg:SetAllPoints();
                row.fs = row:CreateFontString(nil, addon.OVERLAY, addon.NORMAL_SMALL);
                row.fs:SetPoint(addon.LEFT, row, addon.LEFT, 10, 0);
                row.fs:SetJustifyH(addon.LEFT);
            end

            row:SetHeight(24);
            row:SetPoint(addon.TOP,   listContent, addon.TOP,   0, -(i-1)*24);
            row:SetPoint(addon.LEFT,  listContent, addon.LEFT,  0, 0);
            row:SetPoint(addon.RIGHT, listContent, addon.RIGHT, 0, 0);
            addon.ApplyColor(row.bg, "SetColorTexture", even and CT.row_even or CT.row_odd);
            local cc=addon.CLASS_INFO[ch.class] or {r=0.8, g=0.8, b=0.8};
            row.fs:SetText(string.format("|cff%02x%02x%02x%s|r  |cffaaaaaa%s|r  |cffffcc00Lv %d|r%s",
                cc.r*255, cc.g*255, cc.b*255, ch.name, ch.race or addon.EMPTY_STRING, ch.level or 0,
                ch.current and "  |cff55cc55(you)|r" or addon.EMPTY_STRING));
            local charData=ch;
            row:SetScript(addon.OnClick, function()
                selectedChar=charData;
                for r in characterRowPool:EnumerateActive() do
                    local re = r._even;
                    addon.ApplyColor(r.bg, "SetColorTexture", re and CT.row_even or CT.row_odd);
                end
                addon.ApplyColor(row.bg, "SetColorTexture", CT.row_select);
            end)
            row:SetScript(addon.OnEnter, function()
                if selectedChar~=charData then
                    addon.ApplyColor(row.bg, "SetColorTexture", CT.row_hover);
                end
            end);
            row:SetScript(addon.OnLeave, function()
                if selectedChar~=charData then
                    addon.ApplyColor(row.bg, "SetColorTexture", even and CT.row_even or CT.row_odd);
                end
            end);
            row._even=even;
            row._charData=ch;
            if i==1 then firstRow=row; end
        end
        listContent:SetHeight(math.max(24,#matches*24+2));
    end

    local function DoSpinClass(onDone)
        local pool={};
        for _, clsInfo in ipairs(addon.CLASS_INFO) do table.insert(pool, clsInfo.name); end
        addon.StopSlot();
        selectedChar=nil;
        classLabel:SetText("Class");
        addon.ApplyColor(classLabel, "SetTextColor", CT.dim_text);
        expLabel:SetText("Expansion");
        addon.ApplyColor(expLabel, "SetTextColor", CT.dim_text);
        spinExpBtn:SetEnabled(false);
        ClearList();
        addon.ApplyColor(classLabel, "SetTextColor", CT.bright_text);
        addon.StartSlot(classLabel, pool, function(winner)
            local cc=addon.CLASS_INFO[winner];
            if cc then
                addon.ApplyColor(classLabel, "SetTextColor", {cc.r, cc.g, cc.b});
            end
            PopulateList(winner);
            spinExpBtn:SetEnabled(true);

            -- Auto-pick: spin a random eligible character from the list
            if autoPick then
                local eligible = {};
                for row in characterRowPool:EnumerateActive() do
                    table.insert(eligible, row);
                end
                if #eligible > 0 then
                    -- Small delay so the class slot finishes visually first
                    C_Timer.After(0.3, function()
                        local pick = eligible[math.random(#eligible)];
                        -- Simulate a click on that row
                        pick:GetScript(addon.OnClick)(pick);
                        -- Flash the selected row so user sees it
                        if pick.bg then
                            addon.ApplyColor(pick.bg, "SetColorTexture", addon.MulRGB(CT.spin_text, {0.6, 0.6, 0.6}));
                            C_Timer.After(0.15, function()
                                addon.ApplyColor(pick.bg, "SetColorTexture", CT.row_select);
                            end);
                        end
                    end);
                end
            end

            if onDone then onDone(winner); end
        end);
    end

    spinClassBtn:SetScript(addon.OnClick, function()
        spinClassBtn:SetEnabled(false);
        spinAllBtn:SetEnabled(false);
        DoSpinClass(function(_)
            spinClassBtn:SetEnabled(true);
            spinAllBtn:SetEnabled(true);
        end);
    end);

    spinExpBtn:SetScript(addon.OnClick, function()
        if not selectedChar then
            UIErrorsFrame:AddMessage("|cffd5a742What Should I Do?:|r Select a character first.",1,0.8,0.2);
            return;
        end
        local pool = addon.GetExpansionPool(selectedChar.level or 1);
        if #pool == 1 then
            expLabel:SetText(pool[1]);
            addon.ApplyColor(expLabel, "SetTextColor", CT.spin_text);
            return;
        end
        addon.StopSlot();
        spinExpBtn:SetEnabled(false);
        addon.ApplyColor(expLabel, "SetTextColor", CT.bright_text);
        addon.StartSlot(expLabel, pool, function(_)
            addon.ApplyColor(expLabel, "SetTextColor", CT.spin_text);
            spinExpBtn:SetEnabled(true);
        end);
    end);

    spinAllBtn:SetScript(addon.OnClick, function()
        spinClassBtn:SetEnabled(false);
        spinAllBtn:SetEnabled(false);
        spinExpBtn:SetEnabled(false);
        DoSpinClass(function(winner)
            local autoChar=nil;
            for _,ch in ipairs(DB.seenChars) do
                local excluded = DB.excludedChars and DB.excludedChars[ch.name];
                if ch.class==winner and (ch.level or 0) < 90 and not excluded then
                    autoChar=ch;
                    break;
                end
            end
            if autoChar then
                selectedChar=autoChar;
                if firstRow then
                    addon.ApplyColor(firstRow.bg, "SetColorTexture", CT.row_select);
                end
                local pool=addon.GetExpansionPool(autoChar.level or 1);
                if #pool==1 then
                    expLabel:SetText(pool[1]);
                    addon.ApplyColor(expLabel, "SetTextColor", CT.spin_text);
                    spinClassBtn:SetEnabled(true);
                    spinExpBtn:SetEnabled(true);
                    spinAllBtn:SetEnabled(true);
                else
                    addon.ApplyColor(expLabel, "SetTextColor", CT.bright_text);
                    addon.StartSlot(expLabel, pool, function(_)
                        addon.ApplyColor(expLabel, "SetTextColor", CT.spin_text);
                        spinClassBtn:SetEnabled(true);
                        spinExpBtn:SetEnabled(true);
                        spinAllBtn:SetEnabled(true);
                    end);
                end
            else
                spinClassBtn:SetEnabled(true);
                spinExpBtn:SetEnabled(true);
                spinAllBtn:SetEnabled(true);
            end
        end);
    end);

    return panel;
end
addon.BuildLevelingPanel = BuildLevelingPanel;
