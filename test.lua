-- =========================================================
--  ADVANCED ANTI-HOOK & ANTI-DUMP LOADER (HYBRID INTEGRITY)
-- =========================================================

-- 1. Клонирование базовых функций для защиты от дальнейших хуков
local cloneFn = clonefunction or function(f) return f end

local rawGame        = game
local rawHttpGet     = cloneFn(rawGame.HttpGet)
local rawLoadstring  = cloneFn(loadstring)
local rawPcall       = cloneFn(pcall)
local rawType        = cloneFn(type)
local rawRawget      = cloneFn(rawget)

-- 2. Глубокая детекция изменений среды
local function isEnvironmentTampered()
    -- Проверка критических системных функций на подмену L-Closure
    if islclosure then
        if islclosure(rawHttpGet) or islclosure(rawLoadstring) or islclosure(rawPcall) then
            return true, "Подменена одна из базовых функций (HttpGet/loadstring/pcall)"
        end
    end

    -- Проверка встроенных флагов перехвата
    if isfunctionhooked then
        if isfunctionhooked(rawHttpGet) or isfunctionhooked(rawLoadstring) then
            return true, "Зафиксирован активный hookfunction"
        end
    end

    -- Проверка C-сигнатур через debug API
    if debug and debug.getinfo then
        local getInfo = cloneFn(debug.getinfo)
        
        local ok1, info1 = rawPcall(getInfo, rawHttpGet)
        local ok2, info2 = rawPcall(getInfo, rawLoadstring)

        if not ok1 or not info1 or info1.what ~= "C" or info1.source ~= "=[C]" then
            return true, "Нарушена C-сигнатура HttpGet"
        end
        if not ok2 or not info2 or info2.what ~= "C" or info2.source ~= "=[C]" then
            return true, "Нарушена C-сигнатура loadstring"
        end
    end

    -- Проверка целостности метатаблицы объекта game
    if getrawmetatable then
        local getMt = cloneFn(getrawmetatable)
        local ok, mt = rawPcall(getMt, rawGame)
        
        if ok and rawType(mt) == "table" then
            local nc = rawRawget(mt, "__namecall") or mt.__namecall
            local idx = rawRawget(mt, "__index") or mt.__index

            if nc and islclosure and islclosure(nc) then
                return true, "Перехвачен метаметод __namecall"
            end
            if idx and islclosure and islclosure(idx) then
                return true, "Перехвачен метаметод __index"
            end
        end
    end

    return false, "OK"
end

-- 3. Безопасный запуск по URL
local function loadSecure(scriptUrl)
    -- Этап 1: Первичный контроль целостности
    local tampered, reason = isEnvironmentTampered()
    if tampered then
        warn("[🛡️ Security]: Запуск заблокирован. Причина:", reason)
        return
    end

    -- Этап 2: Прямой вызов через сохраненный указатель (обход __namecall и __index)
    local success, scriptContent = rawPcall(rawHttpGet, rawGame, scriptUrl)
    if not success or rawType(scriptContent) ~= "string" or #scriptContent == 0 then
        warn("[🛡️ Security]: Ошибка получения файла с сервера.")
        return
    end

    -- Этап 3: Повторная проверка (если хук включили прямо во время HTTP-запроса)
    local recheckTampered, recheckReason = isEnvironmentTampered()
    if recheckTampered then
        warn("[🛡️ Security]: Перехват активирован во время загрузки:", recheckReason)
        return
    end

    -- Этап 4: Компиляция и запуск
    local compiledFunc, compileError = rawLoadstring(scriptContent)
    
    -- Очищаем сырой код из локальной памяти перед запуском
    scriptContent = nil

    if compiledFunc and rawType(compiledFunc) == "function" then
        print("[✅ Security]: Проверки пройдены. Запуск...")
        return compiledFunc()
    else
        warn("[🛡️ Security]: Ошибка компиляции кода:", compileError)
    end
end

-- =========================================================
--  ЗАПУСК
-- =========================================================
loadSecure("https://raw.githubusercontent.com/username/repository/main/script.lua")
