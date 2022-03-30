local Cooldowns = require("cooldown.cooldowns")

local function Store(command, user)
    if user.mod or user.broadcaster then return end

    if Cooldowns[command] == nil then Cooldowns[command] = {} end
    Cooldowns[command][user.name] = os.time(os.date("!*t"))
end

return Store
