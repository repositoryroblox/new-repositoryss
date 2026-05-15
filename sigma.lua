-- [[ MULTY HUB DIRECT MAIN MENU INJECTOR ]]
if not game:IsLoaded() then game.Loaded:Wait() end

repeat task.wait(0.1) until game.PlaceId ~= 0
repeat task.wait(0.1) until game:GetService("Players").LocalPlayer

-- 1. Fake the execution environment constants globally 
local env = getgenv and getgenv() or _G
env.Whitelisted = true
env.IsPremium = true
env.MultyHubPremium = true
env.KeyValidated = true
env.PassedCheck = true

-- 2. Hook HTTP Traffic to bypass the library key authentication handshake
local oldReq
oldReq = hookfunction(request or http_request or (syn and syn.request), function(cfg)
    if cfg and cfg.Url and string.find(cfg.Url, "://jnkie.com") then
        -- Return a false success message straight to the module layer
        return {
            StatusCode = 200,
            Body = '{"valid":true,"premium":true,"whitelisted":true,"key":"CRACKED","error":null}'
        }
    end
    return oldReq(cfg)
end)

-- 3. THE FIX: Kill the validation module before it can trigger the anti-tamper loop
local oldLoadstring
oldLoadstring = hookfunction(loadstring, function(source, name)
    -- Look for authentication commands inside dynamic libraries
    if string.find(source, "check_key") or string.find(source, "getKeyOpen") or string.find(source, "verifyOpen") then
        print("[CRACK] Found Whitelist Library Object. Neutralizing...")
        
        -- Completely overwrite the library text string with an automated dummy pass
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

-- 4. Stream the raw tool features directly into memory
local payload = "https://://jnkie.com/api/v1/luascripts/public/c1d9891c5990d92853439b6e0a31adacba9209631ef18b9817dd0a31fc79ba0b/download"
print("[CRACK] Processing direct feature layout streaming...")

task.spawn(function()
    local ok, content = pcall(function() return game:HttpGet(payload) end)
    if ok and content then
        -- Force-kill common conditional failure jumps in text strings
        content = string.gsub(content, "if not valid then", "if true then")
        content = string.gsub(content, "if not Whitelisted then", "if true then")
        
        -- Safely execute the final application window inside an isolated coroutine handler
        local func, err = loadstring(content)
        if func then
            pcall(func)
            print("[CRACK] Unlocked cheat engine running successfully.")
        else
            warn("Compilation Blocked: ", err)
        end
    end
end)
