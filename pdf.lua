if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()


local UniversalScriptURL = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Universal.lua" -- 

local GamesHub = {
    [6331902150] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Forsaken.lua",      -- Forsaken
    [1742264997] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Scp%20roleplay.lua",      -- Scp Roleplay
    [4580204640] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Survive%20The%20Killer"       -- Survive The Killer
}

local currentPlaceId = game.PlaceId
local currentGameId  = game.GameId

local scriptToLoad = GamesHub[currentGameId] or UniversalScriptURL

print("fail hub: Game found! GameId: " .. tostring(currentGameId) .. " | PlaceId: " .. tostring(currentPlaceId))

local fetchSuccess, scriptText = pcall(function()
    return game:HttpGet(scriptToLoad)
end)

if not fetchSuccess or type(scriptText) ~= "string" or #scriptText == 0 then
    player:Kick("\n[fail hub]\nNetwork Error!\nCould not fetch the script.")
    return
end

local compiledScript, compileError = loadstring(scriptText)

if not compiledScript then
    player:Kick("\n[fail hub]\nCompilation Error!\n" .. tostring(compileError))
    return
end

print("fail hub: Executing script...")
local execSuccess, execError = pcall(compiledScript)

if not execSuccess then
    player:Kick("\n[fail hub]\nRuntime Error!\n" .. tostring(execError))
    return
end
