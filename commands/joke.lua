local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require('cjson')
local jokeToken = os.getenv("M3O_JOKES")

local function getJoke()
    local reqbody = {count = 1}
    local respbody = {}

    local result, respcode, respheaders, respstatus = http.request({
        method = "POST",
        url = "https://api.m3o.com/v1/joke/Random",
        source = ltn12.source.table(reqbody),
        headers = {
            ["content-type"] = "application/json",
            ["Authorization"] = "Bearer " .. jokeToken
        },
        sink = ltn12.sink.table(respbody)
    })

    respbody = table.concat(respbody)
    respbody = string.gsub(respbody, "\\n", " ")
    local tab = {}
    local function convert() tab = json.decode(respbody) end
    if not pcall(convert) then return nil end

    local joke = tab.jokes[1].body
    return joke
end

local function joke(user, _)
    local jokeText = getJoke()
    while #jokeText > 100 do
        jokeText = getJoke()
        if jokeText == nil then
            return string.format("@%s Joke machine broke", user.name)
        end
    end

    return string.format("@%s Here's a joke: %s", user.name, jokeText)
end

return joke
