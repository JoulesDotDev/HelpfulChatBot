local items = {
    rock = {beats = "scissors", loses = "paper"},
    paper = {beats = "rock", loses = "scissors"},
    scissors = {beats = "paper", loses = "rock"}
}

local itemNames = {"rock", "paper", "scissors"}

local function rps(user, msg)
    local parameters = {}

    for token in string.gmatch(msg, "[^%s]+") do
        table.insert(parameters, token)
    end

    local item = parameters[2]
    if item ~= "rock" and item ~= "paper" and item ~= "scissors" then
        local invalid = "@%s invalid item (rock, paper, scissors)"
        return string.format(invalid, user.name)
    end

    math.randomseed(os.time())
    local bot = itemNames[math.random(#itemNames)]
    if bot == item then
        local response = "@%s I picked %s, it's a tie :/"
        return string.format(response, user.name, bot)
    end

    local checkBot = items[bot]
    if checkBot.beats == item then
        local response = "@%s I picked %s, you lose :D"
        return string.format(response, user.name, bot)
    elseif checkBot.loses == item then
        local response = "@%s I picked %s, you win :("
        return string.format(response, user.name, bot)
    end
end

return rps
