local gameScripts = {
    ["basketballlegends"] = 14259168147, -- Replace with the actual game name and PlaceId
}


local scriptLoaded = false
for gameName, placeId in pairs(gameScripts) do
    if game.PlaceId == placeId then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cuenhub/zenith-core/refs/heads/main/games/"..gameName))()
        scriptLoaded = true
        break
    end
end

if not scriptLoaded then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/cuenhub/zenith-core/refs/heads/main/games/unsupported.lua"))()
end
