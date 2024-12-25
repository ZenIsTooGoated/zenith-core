local gameScripts = {
    ["basketballlegends"] = 14259168147,
}


local scriptLoaded = false
for gameName, placeId in pairs(gameScripts) do
    if game.PlaceId == placeId then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cuenhub/zenith-core/refs/heads/main/games/"..gameName..".lua"))()
        scriptLoaded = true
        break
    end
end

if not scriptLoaded then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/cuenhub/zenith-core/refs/heads/main/games/unsupported.lua"))()
end
