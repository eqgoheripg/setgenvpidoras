-- https://apis.roblox.com/universes/v1/places/286090429/universe


if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local GamesHub = {
    [110175021189594] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Ability%20Arena.lua", -- Ability Arena 1
    [106986181033085] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Ability%20Arena.lua", -- Ability Arena 2
    [10230942274] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Ability%20Arena.lua", -- Ability Arena 3
    [135434213652028] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.lua", -- Bloxstrike 1
    [114234929420007] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.lua", -- Bloxstrike 2
    [108194354348181] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.lua", -- Bloxstrike 3
    [101836176558619] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.lua", -- Bloxstrike 4
    [7633926880] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.lua",     -- Bloxstrike 5
    [18687417158] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Forsaken.lua",     -- Forsaken
    [83645629621104] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Forsaken.lua",     -- Forsaken
    [86454545238517] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Forsaken.lua",     -- Forsaken
    [6331902150] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Forsaken.lua",     -- Forsaken
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
