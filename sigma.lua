-- [[ MULTY HUB STABLE RUNTIME EXPLOITER ]]
if not game:IsLoaded() then game.Loaded:Wait() end

repeat task.wait(0.1) until game.PlaceId ~= 0
repeat task.wait(0.1) until game:GetService("Players").LocalPlayer

-- 1. Establish absolute environment premium bypass parameters
local env = getgenv and getgenv() or _G
env.Whitelisted = true
env.IsPremium = true
env.MultyHubPremium = true
env.KeyValidated = true

-- 2. Mock a fully successful offline authorization module structure 
local FakeLibrary = {
    check_key = function() return {valid = true, premium = true, whitelisted = true} end,
    get_key_link = function() return "https://google.com", nil end,
    load_script = function() print("[BYPASS] Core script thread redirected.") end
}

-- 3. Intercept compilation requests and inject the functional mock module
local oldLoadstring
oldLoadstring = hookfunction(loadstring, function(source, name)
    if type(source) == "string" and (string.find(source, "check_key") or string.find(source, "verifyOpen")) then
        print("[CRACK] Whitelist Library Intercepted. Injecting bypass table...")
        -- Force the compiler to load our pre-built verified runtime table
        return function() return FakeLibrary end
    end
    return oldLoadstring(source, name)
end)

-- 4. Overwrite HTTP requests to intercept background verification routines
local oldRequest
oldRequest = hookfunction(request or http_request or (syn and syn.request), function(cfg)
    if cfg and cfg.Url and string.find(cfg.Url, "://jnkie.com") then
        return {
            StatusCode = 200,
            Body = '{"valid":true,"premium":true,"whitelisted":true,"status":"success","error":null}'
        }
    end
    return oldRequest(cfg)
end)

-- 5. Force-load the main cheat options panel directly through an isolated routine
local payloadURL = "https://://jnkie.com/api/v1/luascripts/public/c1d9891c5990d92853439b6e0a31adacba9209631ef18b9817dd0a31fc79ba0b/download"
print("[CRACK] Opening runtime environment channel...")

task.spawn(function()
    local success, content = pcall(function() return game:HttpGet(payloadURL) end)
    if success and content then
        local compiledFunction, err = loadstring(content)
        if compiledFunction then
            print("[CRACK] Initializing cheat window threads...")
            
            -- Run the main script body safely using a protected coroutine handler
            coroutine.wrap(function()
                local ok, runErr = pcall(compiledFunction)
                if not ok then
                    warn("[CRACK] Thread wrapper crash absorbed: ", runErr)
                end
            end)()
        else
            warn("[CRACK] Engine compilation blocked: ", err)
        end
    else
        warn("[CRACK] Unable to download main script structure.")
    end
end)
