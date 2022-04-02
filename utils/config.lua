local Config = {
    Server = "irc.chat.twitch.tv",
    Channel = "#getpost",
    Name = "helpfulchatbot",
    Pass = os.getenv("BOT_OAUTH"),
    Port = 6667
}

return Config
