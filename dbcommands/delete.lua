-- import sqlite3
local sqlite3 = require("lsqlite3")

local function delete(user, msg)
    -- check if user is mod
    if not user.mod and not user.broadcaster then return nil end

    -- parse parameters
    local parameters = {}
    -- split msg into tokens
    for token in string.gmatch(msg, "[^%s]+") do
        table.insert(parameters, token)
    end
    -- get name
    local name = string.lower(parameters[2])
    -- don't delete command if it exists in Commands
    if Commands[name] ~= nil then
        local response = "@%s command can't be deleted"
        return string.format(response, user.name)
    end
    -- create database if it doesn't exist
    local db = sqlite3.open("bot.db")
    local createCommand =
        "CREATE TABLE IF NOT EXISTS commands (id INTEGER PRIMARY KEY, name VARCHAR(25) NOT NULL, value VARCHAR(50) NOT NULL)"
    local result = db:exec(createCommand)
    if result ~= sqlite3.OK then
        db:close()
        return string.format("@%s create machine broke", user.name)
    end
    -- delete command from database
    local deleteCommand = "DELETE FROM commands WHERE name = ?"
    local stmt = db:prepare(deleteCommand)
    local result = stmt:bind_values(name)
    if result ~= sqlite3.OK then
        db:close()
        return string.format("@%s delete machine broke", user.name)
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
    -- check finalize
    if result ~= sqlite3.OK then
        db:close()
        return string.format("@%s delete machine broke", user.name)
    end
    -- success message
    db:close()
    local response = "@%s if the command existed, it was succesfully deleted"
    return string.format(response, user.name)
end

return delete
