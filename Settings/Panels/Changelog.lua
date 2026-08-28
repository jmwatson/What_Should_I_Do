local _, addon = ...;
local CT = addon.DB.COLOR_TABLE;

local function BuildChangelogPanel(contentArea)
    local panel = addon.MakePanel(contentArea);
    local scrollBG, content, _ = addon.MakeScrollBox(panel, addon.SET_CW, addon.SET_H - 50);
    scrollBG:SetPoint(addon.TOPLEFT, panel, addon.TOPLEFT, addon.SET_PAD, -addon.SET_PAD);

    local yOff = -6;
    for _, block in ipairs(addon.CHANGELOG) do
        local versionHeader = addon.MakeHeader(content, "v"..block.version, addon.SET_CW - 4);
        versionHeader:SetPoint(addon.TOPLEFT, content, addon.TOPLEFT, 0, yOff);
        yOff = yOff - 34;

        for _, entry in ipairs(block.entries) do
            local isNew = entry.type == "new";
            local tag = content:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
            local txt = content:CreateFontString(nil,addon.OVERLAY,addon.NORMAL_SMALL);
            -- Measure wrapped height (approx 14px per line, min 18)
            local lineCount = math.max(1, math.ceil(#entry.text / 72));

            tag:SetPoint(addon.TOPLEFT, content, addon.TOPLEFT, 8, yOff);
            tag:SetText(isNew and "|cff44cc44[New]|r" or "|cffcc4444[Fix]|r");
            txt:SetPoint(addon.TOPLEFT, content, addon.TOPLEFT, 52, yOff);
            txt:SetPoint(addon.RIGHT,   content, addon.RIGHT,  -8, 0);
            txt:SetJustifyH(addon.LEFT);
            txt:SetWordWrap(true);
            addon.ApplyColor(txt, "SetTextColor", CT.dim_text);
            txt:SetText(entry.text);

            yOff = yOff - (lineCount * 14) - 6;
        end

        yOff = yOff - 10;  -- gap between versions
    end

    content:SetHeight(math.abs(yOff) + 20);

    return panel;
end
addon.BuildChangelogPanel = BuildChangelogPanel;