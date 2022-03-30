local Config = require('utils.config')
local Commands = require('utils.command')

local Message = {}

function Message:Process(msg)
    if string.find(msg, "PRIVMSG") then return self:UserMessage(msg) end
end

function Message:FilterMessage(msg)
    print(msg)
    local separator = " :"
    local _, indexStart = string.find(msg, separator)
    separator = "!"
    local _, indexEnd = string.find(msg, separator)
    local user = string.sub(msg, indexStart + 1, indexEnd - 1)
    separator = "PRIVMSG " .. Config.Channel .. " :"
    local _, index = string.find(msg, separator)
    msg = string.sub(msg, index + 1)

    return user, msg
end

function Message:UserMessage(msg)
    local user, message = self:FilterMessage(msg)
    if user == Config.Name then return end

    if string.sub(message, 1, 1) == '!' then
        return Commands:Run(user, message)
    end
end

return Message
