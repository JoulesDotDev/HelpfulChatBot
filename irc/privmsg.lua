local Config = require('utils.config')
local Commands = require('utils.command')

function GetUser(msg)
    local separator = " :"
    local badgeStart, badgeEnd = string.find(msg, separator)
    local badgeInfo = string.sub(msg, 0, badgeStart - 1)

    separator = "!"
    local nameEnd = string.find(msg, separator)
    local name = string.sub(msg, badgeEnd + 1, nameEnd - 1)

    local broadcaster = string.find(badgeInfo, "broadcaster/1") ~= nil
    local mod = string.find(badgeInfo, ";mod=1;") ~= nil
    local vip = string.find(badgeInfo, "vip/1") ~= nil
    local subscriber = string.find(badgeInfo, ";subscriber=1;") ~= nil

    local user = {
        name = name,
        broadcaster = broadcaster,
        mod = mod,
        vip = vip,
        subscriber = subscriber
    }

    return user
end

function FilterMessage(msg)
    local user = GetUser(msg)
    local separator = "PRIVMSG " .. Config.Channel .. " :"
    local _, index = string.find(msg, separator)
    msg = string.sub(msg, index + 1)

    return user, msg
end

function Privmsg(msg)
    local user, message = FilterMessage(msg)
    if user.name == Config.Name then return end

    if string.sub(message, 1, 1) == '!' then
        return Commands:Run(user, message)
    end
end

return Privmsg
