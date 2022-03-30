local socket = require("socket")
local Config = require("utils.config")
local Message = require("utils.message")

local client, err = socket.tcp()
if not client then error(err) end

local Bot = Config
Bot.Client = client

function Bot:Connect()
    self.Client:settimeout(1)
    self.Client:connect(self.Server, self.Port)
    self:Login()
end

function Bot:Login()
    self.Client:send("PASS " .. self.Pass .. "\r\n")
    self.Client:send("NICK " .. self.Name .. "\r\n")
    self.Client:send("JOIN " .. self.Channel .. "\r\n")
    self.Client:send("CAP REQ :twitch.tv/tags" .. "\r\n")
    self.Client:send("JOIN " .. "\r\n")
end

function Bot:Message(msg)
    if msg == nil then return end
    local template = "PRIVMSG %s :%s" .. "\r\n"
    local privmsg = string.format(template, self.Channel, msg)
    self.Client:send(privmsg)
end

function Bot:Read()
    local msg = self.Client:receive()
    if msg == "PING :tmi.twitch.tv" then
        self.Client:send("PONG :tmi.twitch.tv")
    end
    if msg ~= nil then self:Message(Message:Process(msg)) end
end

return Bot
