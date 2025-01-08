local gameScripts = {
    ["basketballlegends"] = {
        placeId = 14259168147,
        gameId = 4931927012,
    },

    ["cbro"] = {
        placeId = 301549746,
        gameId = 115797356,
    },
    ["tower of hell"] = {
        placeId = 1962086868,
        gameId = 703124385,
    },
    ["arsenal"] = {
        placeId = 286090429,
        gameId = 111958650,
    },
    ["fisch"] = {
        placeId = 16732694052,
        gameId = 5750914919,
    }
}

for gameName, ids in pairs(gameScripts) do
    if (ids.placeId and game.PlaceId == ids.placeId) or (ids.gameId and game.GameId == ids.gameId) then
        local success, errorMsg = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/cuenhub/zenith-core/refs/heads/main/games/"..gameName..".lua"))()
        end)
        
        if not success then
            warn("error loading script for " .. gameName .. ": " .. errorMsg)
        end
        
        return
    end
end

local success, errorMsg = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/cuenhub/zenith-core/refs/heads/main/games/unsupported.lua"))()
end)

if not success then
    warn("error loading unsupported game script: " .. errorMsg)
end
