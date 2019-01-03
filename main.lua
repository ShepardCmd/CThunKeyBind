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
        DEFAULT_CHAT_FRAME:AddMessage("Binded sucessfully!")
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