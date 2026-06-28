if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local GamesHub = {
    [110175021189594] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Ability%20Arena.lua_e07b8d1a-cf89-430b-99b3-a77bb086e762.luau",
    [106986181033085] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Ability%20Arena.lua_e07b8d1a-cf89-430b-99b3-a77bb086e762.luau",
    [10230942274] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Ability%20Arena.lua_e07b8d1a-cf89-430b-99b3-a77bb086e762.luau",
    [135434213652028] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.luau",
    [114234929420007] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.luau",
    [108194354348181] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.luau",
    [101836176558619] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.luau",
    [7633926880] = "https://raw.githubusercontent.com/eqgoheripg/scripts/refs/heads/main/Bloxstrike.luau",
}

local currentPlaceId = game.PlaceId
local currentGameId  = game.GameId

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

-- Используем xpcall для перехвата детальной ошибки внутри скачанного скрипта
local execSuccess, execError = xpcall(compiledScript, debug.traceback)

if not execSuccess then
    -- Выводим полный лог ошибки в консоль (F9) красным цветом
    warn("\n[fail hub] CRITICAL ERROR INSIDE FETCHED SCRIPT:\n" .. tostring(execError))
    
    -- Кикаем игрока с понятным уведомлением
    player:Kick(
        "\n[fail hub]\nRuntime Error inside the script!"
        .. "\nCheck developer console (F9) for details."
        .. "\nError short: " .. tostring(execError):match("^.-:%d+: .-")
    )
    return
end
