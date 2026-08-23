if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()


local UniversalScriptURL = ""

local GamesHub = {
    [1742264997] = "https://api.jnkie.com/api/v1/luascripts/public/8c99f152b4cc52196240e9c79b5a4c18c19674976ad30c5846911cce5d49e6f7/download",      -- Scp Roleplay
    [4580204640] = ""       --
}

local currentPlaceId = game.PlaceId
local currentGameId  = game.GameId

local scriptToLoad = GamesHub[currentGameId] or UniversalScriptURL

print("bulo hub: Game found! GameId: " .. tostring(currentGameId) .. " | PlaceId: " .. tostring(currentPlaceId))

local fetchSuccess, scriptText = pcall(function()
    return game:HttpGet(scriptToLoad)
end)

if not fetchSuccess or type(scriptText) ~= "string" or #scriptText == 0 then
    player:Kick("\n[bulo hub]\nNetwork Error!\nCould not fetch the script.")
    return
end

local compiledScript, compileError = loadstring(scriptText)

if not compiledScript then
    player:Kick("\n[bulo hub]\nCompilation Error!\n" .. tostring(compileError))
    return
end

print("bulo hub: Executing script...")
local execSuccess, execError = pcall(compiledScript)

if not execSuccess then
    player:Kick("\n[bulo hub]\nRuntime Error!\n" .. tostring(execError))
    return
end
