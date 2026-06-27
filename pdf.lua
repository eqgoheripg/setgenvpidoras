-- https://apis.roblox.com/universes/v1/places/286090429/universe


if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local GamesHub = {
    [9229146348] = "https://raw.githubusercontent.com/Xenon150/JUST-ONE-MORE-ASYM/refs/heads/main/JUST_ONE_MORE_ASYM.lua", -- JUST ONE MORE ASYM
    [6035872082] = "https://raw.githubusercontent.com/Xenon150/Rivals/refs/heads/main/Rivals.lua", -- Rivals
    [3620011279] = "https://raw.githubusercontent.com/Xenon150/Raf2/refs/heads/main/Raf2.lua", -- Raf2
    [3647333358] = "https://raw.githubusercontent.com/Xenon150/evade12/refs/heads/main/evade.lua", -- Evade
    [1742264997] = "https://raw.githubusercontent.com/Xenon150/SCP-_Roleplay/refs/heads/main/SCP_Roleplay.lua", -- SCP roleplay
    [3140407822] = "https://raw.githubusercontent.com/Xenon150/Brother-s_Vow/refs/heads/main/brother's_vow.lua", -- Brother's Vow
    [2440500124] = "https://raw.githubusercontent.com/Xenon150/Doors/refs/heads/main/doors.lua", -- Doors
    [3317064564] = "https://raw.githubusercontent.com/Xenon150/Centaura/refs/heads/main/Centaura.lua", -- Centaura
    [8202280624] = "https://raw.githubusercontent.com/Xenon150/bitebynight/refs/heads/main/bitebynight.lua", --  Bite By Night
    [9787206684] = "https://raw.githubusercontent.com/Xenon150/121/refs/heads/main/luckyblock.lua", -- be a lucky block or smth
    [3876150506] = "https://raw.githubusercontent.com/Xenon150/lucky/refs/heads/main/lucky.lua", -- drive world
    [7326934954] = "https://raw.githubusercontent.com/Xenon150/99/refs/heads/main/99.lua", -- 99 nights
    [4777817887] = "https://raw.githubusercontent.com/Xenon150/bladeball/refs/heads/main/bladeball.lua", -- blade ball
    [9787206684] = "https://raw.githubusercontent.com/Xenon150/byaluckyblock/refs/heads/main/block.lua", -- lucky block
    [994732206] = "https://raw.githubusercontent.com/Xenon150/fruit/refs/heads/main/Fruit.lua", -- blox fruit
    [111958650] = "https://raw.githubusercontent.com/bulohubsik/Scriptsbulosha/refs/heads/main/arsenal.lua", -- arsenal
    [1119466531] = "https://raw.githubusercontent.com/Xenon150/speed/refs/heads/main/121", -- Legends Of Speed 
}

local currentPlaceId = game.PlaceId
local currentGameId  = game.GameId  -- Одинаков для всех сабплейсов!

local scriptToLoad = GamesHub[currentGameId]

if not scriptToLoad then
    player:Kick(
        "\n[Xenon Hub]\nThis game is not supported!"
        .. "\nPlace ID: "    .. tostring(currentPlaceId)
        .. "\nGame ID: "     .. tostring(currentGameId)
    )
    return
end

print("Xenon Loader: Game found! GameId: " .. tostring(currentGameId) .. " | PlaceId: " .. tostring(currentPlaceId))

local fetchSuccess, scriptText = pcall(function()
    return game:HttpGet(scriptToLoad)
end)

if not fetchSuccess or type(scriptText) ~= "string" or #scriptText == 0 then
    player:Kick("\n[Xenon Hub]\nNetwork Error!\nCould not fetch the script.")
    return
end

local compiledScript, compileError = loadstring(scriptText)

if not compiledScript then
    player:Kick("\n[Xenon Hub]\nCompilation Error!\n" .. tostring(compileError))
    return
end

print("Xenon Loader: Executing script...")
local execSuccess, execError = pcall(compiledScript)

if not execSuccess then
    player:Kick("\n[Xenon Hub]\nRuntime Error!\n" .. tostring(execError))
    return
end
