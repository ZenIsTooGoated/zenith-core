local githubRepo = "https://raw.githubusercontent.com/cuenhub/zenith-core/tree/main/games/"
local supportedGames = {
    [14259168147] = "basketballlegends.lua", 
}

debug.setmemorycategory("Loader")
local function loadScript(scriptUrl)
    local success, response = pcall(function()
        return game:HttpGet(scriptUrl)
    end)

    if success then
        local func, loadErr = loadstring(response)
        if not func then
            warn("error loading script: " .. (loadErr or "unknown error"))
            return
        end
        pcall(func)
    else
        warn("failed to fetch script: " .. (response or "unknown error"))
    end
end

local placeId = game.PlaceId
local scriptName = supportedGames[placeId]

if scriptName then
    local scriptUrl = githubRepo .. scriptName
    loadScript(scriptUrl)
else
    print("game not supported.")
end
