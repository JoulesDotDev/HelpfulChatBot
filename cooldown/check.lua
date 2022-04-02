local Cooldowns = require("cooldown.cooldowns")

local cooldown = 3

local function Store(command, user)
    if Cooldowns[command] ~= nil and Cooldowns[command][user.name] ~= nil then
        if os.time(os.date("!*t")) < Cooldowns[command][user.name] + cooldown then
            return false
        end
    end
    return true
end

return Store
