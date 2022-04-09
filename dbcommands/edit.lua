-- import sqlite3
local sqlite3 = require("lsqlite3")

local function edit(user, msg)
    -- check if user is mod
    if not user.mod and not user.broadcaster then return nil end

    -- parse parameters
    local parameters = {}

    -- split msg into tokens
    for token in string.gmatch(msg, "[^%s]+") do
        table.insert(parameters, token)
    end

    -- get name and value
    local name = string.lower(parameters[2])
    local value = parameters[3]

    -- check if name and value are valid
    if name == nil or value == nil then
        local response = "@%s Usage: !edit <name> <value>"
        return string.format(response, user.name)
    end

    -- check if value is 50 characters or less
    if #value > 50 then
        local response = "@%s command value should be 50 characters or less"
        return string.format(response, user.name)
    end

    -- don't delete command if it exists in Commands
    if Commands[name] ~= nil then
        local response = "@%s command can't be edited"
        return string.format(response, user.name)
    end

    -- create table commands if it doesn't exist
    local db = sqlite3.open("bot.db")
    local createCommand =
        "CREATE TABLE IF NOT EXISTS commands (id INTEGER PRIMARY KEY, name VARCHAR(25) NOT NULL, value VARCHAR(50) NOT NULL)"
    local result = db:exec(createCommand)
    if result ~= sqlite3.OK then
        db:close()
        return string.format("@%s create machine broke", user.name)
    end

    -- check if command exists in database
    local selectCommand = "SELECT * FROM commands WHERE name = ?"
    local stmt = db:prepare(selectCommand)
    result = stmt:bind_values(name)
    if result ~= sqlite3.OK then
        db:close()
        return string.format("@%s create machine broke", user.name)
    end
    -- iterate over rows
    while stmt:step() == sqlite3.ROW do
        -- update command value
        local updateCommand = "UPDATE commands SET value = ? WHERE name = ?"
        local stmt = db:prepare(updateCommand)
        local result = stmt:bind_values(value, name)
        if result ~= sqlite3.OK then
            db:close()
            return string.format("@%s create machine broke", user.name)
        end
        -- white statment is not done call all steps
        while true do
            local step = stmt:step()
            if step == sqlite3.DONE then
                break
            elseif step == sqlite3.ERROR then
                db:close()
                return string.format("@%s create machine broke", user.name)
            end
        end
        -- finalize statement
        result = stmt:finalize()
        if result ~= sqlite3.OK then
            db:close()
            return string.format("@%s create machine broke", user.name)
        end

        db:close()
        -- return command value
        return string.format("@%s command \"%s\" updated", user.name, name)
    end
    -- finalize statement
    result = stmt:finalize()
    if result ~= sqlite3.OK then
        db:close()
        return string.format("@%s create machine broke", user.name)
    end

    db:close()
    -- response if command doesn't exist
    return string.format("@%s command \"%s\" doesn't exist", user.name, name)
end

return edit
