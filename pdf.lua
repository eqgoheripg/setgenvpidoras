if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local GamesHub = {
    [2820580801] = "https://api.jnkie.com/api/v1/luascripts/public/723aac2fcb8192264bef1dd55fc537c0faa2633e122f6960c9b2cb77d00c01e3/download", -- ohio
}

local currentGameId  = game.GameId
local currentPlaceId = game.PlaceId

local scriptToLoad = GamesHub[currentGameId]

if not scriptToLoad or scriptToLoad == "" then
    print("ixa: game not supported (GameId: " .. tostring(currentGameId) .. ")")
    player:Kick("\n[ixa]\nGame not supported.\nGameId: " .. tostring(currentGameId))
    return
end

print("ixa: Game found! GameId: " .. tostring(currentGameId) .. " | PlaceId: " .. tostring(currentPlaceId))

local fetchSuccess, scriptText = pcall(function()
    return game:HttpGet(scriptToLoad)
end)

if not fetchSuccess or type(scriptText) ~= "string" or #scriptText == 0 then
    print("ixa: fetch error: " .. tostring(scriptText))
    player:Kick("\n[ixa]\nNetwork Error!\nCould not fetch the script.")
    return
end

local compiledScript, compileError = loadstring(scriptText)

if not compiledScript then
    print("ixa: compile error: " .. tostring(compileError))
    player:Kick("\n[bulo hub]\nCompilation Error!\n" .. tostring(compileError))
    return
end

print("ixa: Executing script...")
local execSuccess, execError = pcall(compiledScript)

if not execSuccess then
    print("ixa: runtime error: " .. tostring(execError))
    player:Kick("\n[ixa]\nRuntime Error!\n" .. tostring(execError))
end
