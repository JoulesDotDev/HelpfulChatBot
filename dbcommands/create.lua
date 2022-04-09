-- import sqlite3
local sqlite3 = require("lsqlite3")

local function create(user, msg)
    -- check if user is mod or broadcaster
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
        local response = "@%s Usage: !create <name> <value>"
        return string.format(response, user.name)
    end
    -- check if name is alphanumeric
    if string.match(name, "%W") then
        local response = "@%s command name should be alphanumeric"
        return string.format(response, user.name)
    end
    -- check if name is 25 characters or less
    if #name > 25 then
        local response = "@%s command name should be 25 characters or less"
        return string.format(response, user.name)
    end
    -- check if value is 50 characters or less
    if #value > 50 then
        local response = "@%s command value should be 50 characters or less"
        return string.format(response, user.name)
    end
    -- check if commands exists in Commands
    if Commands[name] ~= nil then
        local response = "@%s command already exists"
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
        -- return command value
        db:close()
        return string.format("@%s command \"%s\" already exists", user.name,
                             name)
    end
    -- finalize statement
    result = stmt:finalize()
    if result ~= sqlite3.OK then
        db:close()
        return string.format("@%s create machine broke", user.name)
    end
    -- insert command into database
    local insertCommand = "INSERT INTO commands (name, value) VALUES (?, ?)"
    stmt = db:prepare(insertCommand)
    result = stmt:bind_values(name, value)
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
    -- return success message
    db:close()
    return string.format("@%s command \"%s\" created", user.name, name)
end

return create
