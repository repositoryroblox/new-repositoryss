-- [[ MULTY HUB STABLE SANDBOX BYPASS ]]
if not game:IsLoaded() then game.Loaded:Wait() end

repeat task.wait(0.1) until game.PlaceId ~= 0
repeat task.wait(0.1) until game:GetService("Players").LocalPlayer

-- 1. Create a deep environmental spoof layer inside your executor
local env = getgenv and getgenv() or _G
env.Whitelisted = true
env.IsPremium = true
env.MultyHubPremium = true
env.KeyValidated = true

-- 2. Hook HTTP Traffic to trick any library handshakes or external checks
local oldRequest
oldRequest = hookfunction(request or http_request or (syn and syn.request), function(cfg)
    if cfg and cfg.Url and string.find(cfg.Url, "://jnkie.com") then
        print("[BYPASS] Network handshake spoofed.")
        return {
            StatusCode = 200,
            Body = '{"valid":true,"premium":true,"whitelisted":true,"status":"success","error":null}'
        }
    end
    return oldRequest(cfg)
end)

-- 3. Hook loadstring compilation to intercept and neutralize the Whitelist library
local oldLoadstring
oldLoadstring = hookfunction(loadstring, function(source, name)
    if type(source) == "string" and (string.find(source, "check_key") or string.find(source, "verifyOpen")) then
        print("[BYPASS] Whitelist validation engine neutralized.")
        
        -- Completely swap the verification module text code with a dummy pass layout
        source = [[
            local Lib = {}
            function Lib.check_key() return {valid = true, premium = true} end
            function Lib.get_key_link() return "https://google.com" end
            function Lib.load_script() print("Bypassed Library Load") end
            return Lib
        ]]
    end
    return oldLoadstring(source, name)
end)

-- 4. Stream the raw feature script safely using an isolated thread
local payloadURL = "https://://jnkie.com/api/v1/luascripts/public/c1d9891c5990d92853439b6e0a31adacba9209631ef18b9817dd0a31fc79ba0b/download"
print("[BYPASS] Opening protected compilation stream...")

task.spawn(function()
    local success, content = pcall(function() 
        return game:HttpGet(payloadURL) 
    end)
    
    if success and content then
        -- We no longer use string.gsub here. This fixes the compilation error.
        local compiledFunction, err = loadstring(content)
        if compiledFunction then
            print("[BYPASS] Launching main cheat window layout...")
            pcall(compiledFunction)
        else
            warn("[BYPASS] Code compilation failed: ", err)
        end
    else
        warn("[BYPASS] Could not download feature script from server.")
    end
end)
