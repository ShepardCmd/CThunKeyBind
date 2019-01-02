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
    ChatFrame1:AddMessage("You've entered: ".. msg)
    msg = trim(msg)
    local words = {}
    for word in msg:gmatch("%w+") do
        ChatFrame1:AddMessage("Word: ".. word)
        table.insert(words, word)
    end
    local action_type = strupper(words[1])
    local key = strupper(words[table.getn(key)])
    local spell = strsub(msg, strlen(action_type) + 1, strlen(msg) - table.getn(key) - 1)
    spell = trim(spell)
end

local EventFrame = CreateFrame("SayHelloFrame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent", function(_, _, _)
    ChatFrame1:AddMessage("Hi, ".. UnitName("Player").. "! You can type \"/cthun\" to start binding abilities and macros on keys.")
end)

function saveBinding(action_type, spell, key)

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