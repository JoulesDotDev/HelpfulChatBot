local Commands = require("commands.module")
local Cooldown = require("cooldown.module")

local Command = {}

function Command:Run(user, msg)
    local _, index = string.find(msg, " ")
    local command = ""
    if index ~= nil then
        command = string.sub(msg, 2, index - 1)
    else
        command = string.sub(msg, 2)
    end

    if Commands[command] ~= nil then
        if Cooldown.check(command, user) then
            local response = Commands[command](user, msg)
            if response ~= nil then Cooldown.store(command, user) end
            return response
        end
    end
end

return Command
