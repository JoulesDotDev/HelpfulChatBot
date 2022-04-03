local sqlite3 = require("lsqlite3")

local function create(user, msg)
    if not user.mod and not user.broadcaster then return nil end

    local created = os.time(os.date("!*t"))

    local parameters = {}

    for token in string.gmatch(msg, "[^%s]+") do
        table.insert(parameters, token)
    end

    local name = parameters[2]
    local value = parameters[3]

    if name == nil or value == nil then
        local response = "@%s Usage: !create <name> <value>"
        return string.format(response, user.name)
    end

    if string.match(name, "%W") then
        local response = "@%s command name should be alphanumeric"
        return string.format(response, user.name)
    end

    if #name > 25 then
        local response = "@%s command name should be 25 characters or less"
        return string.format(response, user.name)
    end

    if #value > 50 then
        local response = "@%s command value should be 50 characters or less"
        return string.format(response, user.name)
    end

    local db = sqlite3.open("bot.db")

    local createCommand =
        "CREATE TABLE IF NOT EXISTS commands (id INTEGER PRIMARY KEY, name VARCHAR(25) NOT NULL, value VARCHAR(50) NOT NULL)"
    local result = db:exec(createCommand)
    if result ~= sqlite3.OK then
        return string.format("@%s create machine broke", user.name)
    end

    local selectCommand = "SELECT * FROM commands WHERE name = ?"
    local stmt = db:prepare(selectCommand)
    result = stmt:bind_values(name)
    if result ~= sqlite3.OK then
        return string.format("@%s create machine broke", user.name)
    end

    while stmt:step() == sqlite3.ROW do
        local response = "@%s command \"%s\" already exists"
        return string.format(response, user.name, name)
    end

    result = stmt:finalize()
    if result ~= sqlite3.OK then
        return string.format("@%s create machine broke", user.name)
    end

    stmt = db:prepare("INSERT INTO commands (name, value) VALUES (?, ?)")
    result = stmt:bind_values(name, value)
    if result ~= sqlite3.OK then
        return string.format("@%s create machine broke", user.name)
    end

    while stmt:step() ~= sqlite3.DONE do
        stmt:step()
    end

    result = stmt:finalize()
    if result ~= sqlite3.OK then
        return string.format("@%s create machine broke", user.name)
    end

    db:close()

    print(os.time(os.date("!*t")), created)

    return string.format("@%s command \"%s\" created successfully", user.name, name)
end

return create
