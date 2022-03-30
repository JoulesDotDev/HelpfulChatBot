local Irc = require("irc.module")

local Message = {}

function Message:Process(msg)
    if string.find(msg, "PRIVMSG") then return Irc.Privmsg(msg) end
end

return Message
