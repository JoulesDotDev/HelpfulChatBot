local function coinflip(user, _)
    math.randomseed(os.time())
    local sides = {"Heads", "Tails"}
    local side = sides[math.random(2)]

    return string.format("@%s %s!", user.name, side)
end

return coinflip
