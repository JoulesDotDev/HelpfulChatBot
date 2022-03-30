local function call(user, _)
    if not user.mod and not user.broadcaster then return nil end

    return string.format("I'm here @%s", user.name)
end

return call
