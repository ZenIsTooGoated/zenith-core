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
    }
}

for gameName, ids in pairs(gameScripts) do
    if (ids.placeId and game.PlaceId == ids.placeId) or (ids.gameId and game.GameId == ids.gameId) then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cuenhub/zenith-core/refs/heads/main/games/"..gameName..".lua"))()
        return
    end
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/cuenhub/zenith-core/refs/heads/main/games/unsupported.lua"))()
