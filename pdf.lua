if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local GamesHub = {
    [1742264997] = "https://api.jnkie.com/api/v1/luascripts/public/8c99f152b4cc52196240e9c79b5a4c18c19674976ad30c5846911cce5d49e6f7/download", -- SCP Roleplay
    [7239319209] = "https://api.jnkie.com/api/v1/luascripts/public/723aac2fcb8192264bef1dd55fc537c0faa2633e122f6960c9b2cb77d00c01e3/download", -- ohio
}

local currentGameId  = game.GameId
local currentPlaceId = game.PlaceId

local scriptToLoad = GamesHub[currentGameId]

if not scriptToLoad or scriptToLoad == "" then
    print("bulo hub: game not supported (GameId: " .. tostring(currentGameId) .. ")")
    player:Kick("\n[bulo hub]\nGame not supported.\nGameId: " .. tostring(currentGameId))
    return
end

print("bulo hub: Game found! GameId: " .. tostring(currentGameId) .. " | PlaceId: " .. tostring(currentPlaceId))

local fetchSuccess, scriptText = pcall(function()
    return game:HttpGet(scriptToLoad)
end)

if not fetchSuccess or type(scriptText) ~= "string" or #scriptText == 0 then
    print("bulo hub: fetch error: " .. tostring(scriptText))
    player:Kick("\n[bulo hub]\nNetwork Error!\nCould not fetch the script.")
    return
end

print("bulo hub: got " .. #scriptText .. " bytes")
print("bulo hub: head -> " .. string.sub(scriptText, 1, 150):gsub("\n", " "))

local compiledScript, compileError = loadstring(scriptText)

if not compiledScript then
    print("bulo hub: compile error: " .. tostring(compileError))
    player:Kick("\n[bulo hub]\nCompilation Error!\n" .. tostring(compileError))
    return
end

print("bulo hub: Executing script...")
local execSuccess, execError = pcall(compiledScript)

if not execSuccess then
    print("bulo hub: runtime error: " .. tostring(execError))
    player:Kick("\n[bulo hub]\nRuntime Error!\n" .. tostring(execError))
end
