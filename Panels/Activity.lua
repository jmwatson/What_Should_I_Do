local _, addon = ...;
local DB = addon.DB;
local CT = DB.COLOR_TABLE;
local lastCat = nil;

local function ResetSub(subLabel, spinSubBtn, spinBothBtn)
    local function _ResetSub()
        subLabel:SetText("Sub-Activity");
        subLabel:SetTextColor(CT.dim_text[1],CT.dim_text[2],CT.dim_text[3]);
        spinSubBtn:SetEnabled(false);
        spinBothBtn:SetEnabled(false);
        lastCat = nil;
    end
    return _ResetSub;
end

local function CatSlotStart(catLabel, spinCatBtn, spinBothBtn, spinSubBtn)
    local function _CatSlotStart(w)
        lastCat=w;
        catLabel:SetTextColor(CT.spin_text[1], CT.spin_text[2], CT.spin_text[3]);
        spinCatBtn:SetEnabled(true);
        spinSubBtn:SetEnabled(true);
        spinBothBtn:SetEnabled(true);
    end
    return _CatSlotStart;
end

local function SubSlotStart(subLabel, spinSubBtn)
    local function _SubSlotStart(_)
        subLabel:SetTextColor(CT.spin_text[1], CT.spin_text[2], CT.spin_text[3]);
        spinSubBtn:SetEnabled(true);
    end
    return _SubSlotStart;
end

local function BothSlotStart(catLabel, subLabel, spinCatBtn, spinSubBtn, spinBothBtn)
    local function _BothSlotStart(w)
        lastCat = w
        catLabel:SetTextColor(CT.spin_text[1], CT.spin_text[2], CT.spin_text[3]);
        local sub = addon.GetSubActivities(w);
        
        if sub and #sub > 0 then
            subLabel:SetTextColor(CT.bright_text[1], CT.bright_text[2], CT.bright_text[3]);
            addon.StartSlot(subLabel, sub, function(_)
                subLabel:SetTextColor(CT.spin_text[1], CT.spin_text[2], CT.spin_text[3]);
                spinCatBtn:SetEnabled(true);
                spinSubBtn:SetEnabled(true);
                spinBothBtn:SetEnabled(true);
            end);
        else
            subLabel:SetText("(none)");
            spinCatBtn:SetEnabled(true);
            spinBothBtn:SetEnabled(true);
        end
    end
    return _BothSlotStart;
end

local function CatBtnOnClick(catLabel, spinCatBtn, Reset)
    local function _CatBtnOnClick()
        local pool = addon.GetActivities();

        -- Early out if no activities available
        if #pool==0 then
            return;
        end

        addon.StopSlot();
        catLabel:SetTextColor(CT.bright_text[1], CT.bright_text[2], CT.bright_text[3]);
        spinCatBtn:SetEnabled(false);
        Reset();
        addon.StartSlot(catLabel, pool, CatSlotStart);
    end
    return _CatBtnOnClick;
end

local function SubBtnOnClick(subLabel, spinSubBtn)
    local function _SubBtnOnClick()
        if not lastCat then
            return;
        end
        
        local pool = addon.GetSubActivities(lastCat);
        
        if not pool or #pool == 0 then
            subLabel:SetText("(none)");
            return;
        end

        addon.StopSlot();
        subLabel:SetTextColor(CT.bright_text[1], CT.bright_text[2], CT.bright_text[3]);
        spinSubBtn:SetEnabled(false);
        addon.StartSlot(subLabel, pool, SubSlotStart(subLabel, spinSubBtn));
    end
    return _SubBtnOnClick;
end

local function BothBtnOnClick(catLabel, spinCatBtn, Reset)
    local function _BothBtnOnClick()
        local pool = addon.GetActivities();
        
        if #pool == 0 then
            return;
        end

        addon.StopSlot();
        catLabel:SetTextColor(CT.bright_text[1],CT.bright_text[2],CT.bright_text[3]);
        spinCatBtn:SetEnabled(false);
        Reset();
        addon.StartSlot(catLabel, pool, BothSlotStart);
    end
    return _BothBtnOnClick;
end

local function BuildActivityPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    local header = addon.MakeHeader(panel, "Activity Wheel");
    local description = addon.MakeLabel(panel, "Spin a category, then spin a sub-activity.", header, addon.BOTTOMLEFT, 4, -8);
    local catBox, catLabel = addon.MakeResult(panel, nil, 52, "CATEGORY");
    local subBox, subLabel = addon.MakeResult(panel, nil, 52, "SUB-ACTIVITY");
    local spinCatBtn = addon.MakeBtn(panel, "Spin Category", nil, 30);
    local spinSubBtn = addon.MakeBtn(panel, "Spin Sub-Activity", nil, 30);
    local spinBothBtn = addon.MakeBtn(panel, "Spin Both", nil, 30);

    header:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.PAD, -addon.PAD);
    catBox:SetPoint(addon.TOPLEFT, description, addon.BOTTOMLEFT, -4, -12);
    catLabel:SetText("Category");
    spinCatBtn:SetPoint(addon.TOP, subBox, addon.BOTTOMLEFT, 0, -14);
    spinCatBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    spinCatBtn:SetPoint(addon.RIGHT, panel, addon.CENTER, -3, 0);
    subBox:SetPoint(addon.TOPLEFT, catBox, addon.BOTTOMLEFT, 0, -10);
    subLabel:SetText("Sub-Activity");
    spinSubBtn:SetPoint(addon.TOP, subBox, addon.BOTTOMLEFT, 0, -14);
    spinSubBtn:SetPoint(addon.LEFT, panel, addon.CENTER, 3, 0);
    spinSubBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    spinSubBtn:SetEnabled(false);
    spinBothBtn:SetPoint(addon.TOP, spinCatBtn, addon.BOTTOM, 0, -6);
    spinBothBtn:SetPoint(addon.LEFT, panel, addon.LEFT, addon.PAD, 0);
    spinBothBtn:SetPoint(addon.RIGHT, panel, addon.RIGHT, -addon.PAD, 0);
    spinCatBtn:SetScript(addon.OnClick, CatBtnOnClick(catLabel, spinCatBtn, ResetSub(subLabel, spinSubBtn, spinBothBtn)));
    spinBothBtn:SetScript(addon.OnClick, BothBtnOnClick(catLabel, spinCatBtn, ResetSub(subLabel, spinSubBtn, spinBothBtn)));
    spinSubBtn:SetScript(addon.OnClick, SubBtnOnClick(subLabel, spinSubBtn));

    return panel;
end
addon.BuildActivityPanel = BuildActivityPanel;
