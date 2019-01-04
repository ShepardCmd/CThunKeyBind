--
-- C'Thun Key Bind - World of Warcraft Add'On for key binding.
-- Author: Alexander Iglin (savinggalaxyforfood@gmail.com)
--

SlashCmdList["CTHUN"] = function(msg)
    ProcessInput(msg)
end
SLASH_CTHUN1 = "/cthun"

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent", function(_, _, _)
    PrintChatMessage("Hi, ".. UnitName("Player").. "! You can type \"/cthun\" to start binding abilities and items on keys.")
end)

function ProcessInput(msg)
    --DEFAULT_CHAT_FRAME:AddMessage("You've entered: ".. msg)
    if msg then
        msg = trim(msg)
        if msg == "" or string.upper(msg) == "HELP" or string.upper(msg) == "USAGE" or string.upper(msg) == "H" then
            PrintHelp()
            return 0
        end
        local words = {}
        for word in msg:gmatch("%w+") do
--    for word in msg:gmatch("%S+") do
        --PrintChatMessage("Word: ".. word)
            table.insert(words, word)
        end
        local action_type
        if (words[2] == "Hspell") then
            action_type = "SPELL"
        elseif (words[2] == "Hitem") then
            action_type = "ITEM"
        else
            PrintChatMessage("Incorrect command: you can only bind key to a spell or item!")
            return 1
        end
        local key = strupper(words[table.getn(words)])
        local spell_or_item_id = tonumber(words[3])
        SaveKeyBinding(action_type, spell_or_item_id, key)
        return 0
    else
        PrintHelp()
    end
end

function PrintHelp()
    PrintChatMessage("To bind spell or item on a specific key, print in chat: ")
    PrintChatMessage("/cthun [spell or item linked via Shift key] KEY")
    PrintChatMessage("Example (binding 'Solar Wrath' spell to the key 'E'):")
    local link = GetSpellLink(190984)
    PrintChatMessage("/cthun ".. link.. " E")
end

function SaveKeyBinding(action_type, spell_or_item_id, key)
    --PrintChatMessage("action_type=".. action_type)
    --PrintChatMessage("spell or item id=".. spell_or_item_id)
    --PrintChatMessage("key=".. key)
    local ok
    if (action_type == "SPELL") then
--        local spellName, spellSubName = GetSpellBookItemName(spell_or_item_id, BOOKTYPE_SPELL)
        local spellName, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spell_or_item_id)
        --DEFAULT_CHAT_FRAME:AddMessage("spellName=".. spellName)
--        ok = SetBinding(key, action_type + " " + spellName);
        ok = SetBindingSpell(key, spellName);
    else
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
        itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
        isCraftingReagent = GetItemInfo(spell_or_item_id)
        --DEFAULT_CHAT_FRAME:AddMessage("itemName=".. itemName)
--        ok = SetBinding(key, action_type + " " + itemName);
        ok = SetBindingItem(key, itemName);
    end
    if (ok == 1) then
        PrintChatMessage("Binding failed, please, check your command!")
    else
        UpdateActionBars(spell_or_item_id, key)
        SaveBindings(2) -- 2 for CHARACTER_BINDINGS, 1 for ACCOUNT_BINDINGS
        PrintChatMessage("Binded successfully!")
    end
end

function UpdateActionBars(spell_or_item_id, key)
    --local bars={"Action","MultiBarBottomLeft","MultiBarBottomRight","MultiBarLeft","MultiBarRight"}
    local bars={"MultiBarBottomLeft","MultiBarBottomRight","MultiBarLeft","MultiBarRight"}
    for bar=1,#bars do
        for button=1,12 do
            local buttonName = bars[bar].."Button"..button
            if (GetActionInfo(_G[buttonName].action)) then
                local _, id, _ = GetActionInfo(_G[buttonName].action)
                if id == spell_or_item_id then
                    --PrintChatMessage("Found item with id ".. id.. " in button ".. buttonName)
                    local ok = SetBindingClick(key, buttonName);
                end
            end
        end
    end
end

function PrintChatMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("[C'Thun]: ".. msg, 255/255, 0/255, 255/255)
end

--function ListBars()
--    local bars={"Action","MultiBarBottomLeft","MultiBarBottomRight","MultiBarLeft","MultiBarRight"}
--    for bar=1,#bars do
--        for button=1,12 do
--            local buttonName = bars[bar].."Button"..button
--            print(buttonName,"contains",GetActionInfo(_G[buttonName].action))
--        end
--    end
--end
--
--function ReportActionButtons()
--    local lActionSlot = 0;
--    for lActionSlot = 1, 120 do
--        local lActionText = GetActionText(lActionSlot);
--        local lActionTexture = GetActionTexture(lActionSlot);
--        if lActionTexture then
--            local lMessage = "Slot " .. lActionSlot .. ": [" .. lActionTexture .. "]";
--            if lActionText then
--                lMessage = lMessage .. " \"" .. lActionText .. "\"";
--            end
--            DEFAULT_CHAT_FRAME:AddMessage(lMessage);
--        end
--    end
--end

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