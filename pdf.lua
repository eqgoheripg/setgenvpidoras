-- https://apis.roblox.com/universes/v1/places/286090429/universe


if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local GamesHub = {
    [6331902150] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Forsaken.lua",     -- Forsaken
    [1742264997] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Scp%20roleplay.lua",     -- Scp Roleplay
    [4580204640] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Survive%20The%20Killer",     -- survive the killer
    [1742264997] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Scp%20roleplay.lua",    --  
}

local currentPlaceId = game.PlaceId
local currentGameId  = game.GameId  -- Одинаков для всех сабплейсов!

local scriptToLoad = GamesHub[currentGameId]

if not scriptToLoad then
    player:Kick(
        "\n[fail hub]\nThis game is not supported!"
        .. "\nPlace ID: "    .. tostring(currentPlaceId)
        .. "\nGame ID: "     .. tostring(currentGameId)
    )
    return
end

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
