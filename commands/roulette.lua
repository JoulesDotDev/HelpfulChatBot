local function roulette(user, _)
    local bullet = math.random(3)
    if bullet == 1 then
        return { string.format("@%s You died!", user.name), string.format("/timeout @%s 1 you died", user.name)}
    else
        return string.format("@%s You lived!", user.name)
    end
end

return roulette