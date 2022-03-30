local Commands = require("commands.module")

local Command = {}

function Command:Run(user, msg)
    local _, index = string.find(msg, " ")
    local command = ""
    if index ~= nil then
        command = string.sub(msg, 2, index - 1)
    else
        command = string.sub(msg, 2)
    end

    if Commands[command] ~= nil then return Commands[command](user, msg) end
end

return Command
