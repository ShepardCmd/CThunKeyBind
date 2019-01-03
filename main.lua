--
-- C'Thun Key Bind - World of Warcraft Add'On for key binding.
-- Author: Alexander Iglin (savinggalaxyforfood@gmail.com)
--

--message('C\'Thun calls!')

--local btn = CreateFrame("BUTTON", "MyBindingHandlingButton")
--SetBindingClick("SHIFT-T", btn:GetName())
--btn:SetScript("OnClick", function(self, button, down)
--    -- As we have not specified the button argument to SetBindingClick,
--    -- the binding will be mapped to a LeftButton click.
--    print("You triggered the binding using", button)
--end)

SlashCmdList["CTHUN"] = function(msg)
    ProcessInput(msg)
end
SLASH_CTHUN1 = "/cthun"

function ProcessInput(msg)
    DEFAULT_CHAT_FRAME:AddMessage("You've entered: ".. msg)
    msg = trim(msg)
    local words = {}
    for word in msg:gmatch("%w+") do
--    for word in msg:gmatch("%S+") do
        DEFAULT_CHAT_FRAME:AddMessage("Word: ".. word)
        table.insert(words, word)
    end
--    local action_type = strupper(words[1])
    local action_type
    if (words[2] == "Hspell") then
        action_type = "SPELL"
    elseif (words[2] == "Hitem") then
        action_type = "ITEM"
    else
        DEFAULT_CHAT_FRAME:AddMessage("Incorrect command: you can only bind key to a spell or item!".. word)
        return 1
    end
--    ChatFrame1:AddMessage("action_type=".. action_type)
    local key = strupper(words[table.getn(words)])
--    ChatFrame1:AddMessage("key=".. key)
    local spell_or_item_id = words[3]
--    local spell = strsub(msg, strlen(action_type) + 1, strlen(msg) - strlen(key))
--    spell = trim(spell)
--    ChatFrame1:AddMessage("spell=".. spell)
--    ChatFrame1:AddMessage("spellId=".. words[3])
--    ChatFrame1:AddMessage("info = ".. GetSpellInfo(words[3]))
    SaveBinding(action_type, spell_or_item_id, key)
    return 0
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent", function(_, _, _)
    DEFAULT_CHAT_FRAME:AddMessage("Hi, ".. UnitName("Player").. "! You can type \"/cthun\" to start binding abilities and macros on keys.")
    ListBars()
end)

function SaveBinding(action_type, spell_or_item_id, key)
    DEFAULT_CHAT_FRAME:AddMessage("action_type=".. action_type)
    DEFAULT_CHAT_FRAME:AddMessage("spell or item id=".. spell_or_item_id)
    DEFAULT_CHAT_FRAME:AddMessage("key=".. key)
    local ok
    if (action_type == "SPELL") then
--        local spellName, spellSubName = GetSpellBookItemName(spell_or_item_id, BOOKTYPE_SPELL)
        local spellName, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spell_or_item_id)
        DEFAULT_CHAT_FRAME:AddMessage("spellName=".. spellName)
--        ok = SetBinding(key, action_type + " " + spellName);
        ok = SetBindingSpell(key, spellName);
    else
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
        itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
        isCraftingReagent = GetItemInfo(spell_or_item_id)
        DEFAULT_CHAT_FRAME:AddMessage("itemName=".. itemName)
--        ok = SetBinding(key, action_type + " " + itemName);
        ok = SetBindingItem(key, itemName);
    end
    if (ok == 1) then
        DEFAULT_CHAT_FRAME:AddMessage("Binding failed, please, check your command!")
    else
        DEFAULT_CHAT_FRAME:AddMessage("Binded successfully!")
        UpdateActionBars(spell_or_item_id, key)
        SaveBindings(CHARACTER_BINDINGS)
    end
end

function UpdateActionBars(spell_or_item_id, key)
    local bars={"Action","MultiBarBottomLeft","MultiBarBottomRight","MultiBarLeft","MultiBarRight"}
    for bar=1,#bars do
        for button=1,12 do
            DEFAULT_CHAT_FRAME:AddMessage("Checking button ".. button);
            local buttonName = bars[bar].."Button"..button
            DEFAULT_CHAT_FRAME:AddMessage("buttonName=".. buttonName);
            if (GetActionInfo(_G[buttonName].action)) then
                DEFAULT_CHAT_FRAME:AddMessage("actionInfo=".. GetActionInfo(_G[buttonName].action));
                local actionType, id, subType = GetActionInfo(_G[buttonName].action)
                if id == spell_or_item_id then
                    DEFAULT_CHAT_FRAME:AddMessage("Found item with id ".. id.. " in button ".. buttonName);
                    local ok = SetBindingClick(key, buttonName);
                end
            end
        end
    end
end

function UpdateActionSlots(spell_or_item_id, key)
    for slot = 1, 120 do
        local actionType, id, subType = GetActionInfo(slot)
        DEFAULT_CHAT_FRAME:AddMessage(actionType.. "; ".. id.. "; ".. subType);
        if (id == spell_or_item_id) then
            DEFAULT_CHAT_FRAME:AddMessage("Found item with id ".. id.. " in slot ".. slot);
            --ok = SetBindingClick(key, "buttonName"[, "button"]);
        end
    end
end

function ListBars()
    local bars={"Action","MultiBarBottomLeft","MultiBarBottomRight","MultiBarLeft","MultiBarRight"}
    for bar=1,#bars do
        for button=1,12 do
            local buttonName = bars[bar].."Button"..button
            print(buttonName,"contains",GetActionInfo(_G[buttonName].action))
        end
    end
end

function ReportActionButtons()
    local lActionSlot = 0;
    for lActionSlot = 1, 120 do
        local lActionText = GetActionText(lActionSlot);
        local lActionTexture = GetActionTexture(lActionSlot);
        if lActionTexture then
            local lMessage = "Slot " .. lActionSlot .. ": [" .. lActionTexture .. "]";
            if lActionText then
                lMessage = lMessage .. " \"" .. lActionText .. "\"";
            end
            DEFAULT_CHAT_FRAME:AddMessage(lMessage);
        end
    end
end

function trim(s)
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
end
--local EventFrame = CreateFrame("Frame")
--EventFrame:RegisterEvent("PLAYER_LOGIN")
--EventFrame:SetScript("OnEvent", function(self,event,...)
--    if type(CharacterVar) ~= "number" then
--        CharacterVar = 1
--        ChatFrame1:AddMessage('WhyHelloThar '.. UnitName("Player")..". I do believe this is the first time we've met. Nice to meet you!")
--    else
--        if CharacterVar == 1 then
--            ChatFrame1:AddMessage('WhyHelloThar '.. UnitName("Player")..". How nice to see you again. I do believe I've seen you " .. CharacterVar .. " time before.")
--        else
--            ChatFrame1:AddMessage('WhyHelloThar '.. UnitName("Player")..". How nice to see you again. I do believe I've seen you " .. CharacterVar .. " times before.")
--        end
--        CharacterVar = CharacterVar + 1
--    end
--end)