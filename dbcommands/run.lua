-- import sqlite3
local sqlite3 = require("lsqlite3")

local function run(command)
    -- open bot.db
    local db = sqlite3.open("bot.db")

    -- create table commands if it doesn't exist
    local createCommand =
        "CREATE TABLE IF NOT EXISTS commands (id INTEGER PRIMARY KEY, name VARCHAR(25) NOT NULL, value VARCHAR(50) NOT NULL)"
    local result = db:exec(createCommand)
    if result ~= sqlite3.OK then
        return string.format("create machine broke")
    end

    -- find command in database
    local findCommand = "SELECT * FROM commands WHERE name = ?"

    -- prepare statement
    local stmt = db:prepare(findCommand)
    -- bind values
    result = stmt:bind_values(command)
    -- check if statement is ok
    if result ~= sqlite3.OK then db:close() return nil end
    -- iterate over rows
    while stmt:step() == sqlite3.ROW do
        -- get command value
        local value = stmt:get_value(2)
        -- return command value
        db:close()
        return value
    end
end

return run
