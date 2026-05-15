-- [[ MULTY HUB HANDSHAKE EMULATOR ]]
if not game:IsLoaded() then game.Loaded:Wait() end

repeat task.wait(0.1) until game.PlaceId ~= 0
repeat task.wait(0.1) until game:GetService("Players").LocalPlayer

-- 1. Inject global parameters to override security checks
local env = getgenv and getgenv() or _G
env.Whitelisted = true
env.IsPremium = true
env.MultyHubPremium = true
env.KeyValidated = true

-- 2. Hook and bypass the Junkie Dev key verification system API response
local oldReq
oldReq = hookfunction(request or http_request or (syn and syn.request), function(cfg)
    if cfg and cfg.Url and string.find(cfg.Url, "api.jnkie.com") then
        print("[CRACK] Spoofing server handshake verification...")
        -- Provide exactly what WindUI / Junkie expects for an authorized premium user
        return {
            StatusCode = 200,
            Headers = {["content-type"] = "application/json"},
            Body = '{"valid":true,"premium":true,"status":"success","message":"Key validated successfully!","whitelisted":true,"error":null}'
        }
    end
    return oldReq(cfg)
end)

-- 3. Standard Game URL Lookup from your original loader layout
local GAMES = {
	["4747446334"] = { name = "Blackhawk Rescue Mission 5", url = "https://jnkie.com" },
	["3701546109"] = { name = "Blackhawk Rescue Mission 5", url = "https://jnkie.com" }
}
local entry = GAMES[tostring(game.PlaceId)] or GAMES["4747446334"]

print("[CRACK] Fetching source engine payload modules...")
task.spawn(function()
    local ok, sourceCode = pcall(function() return game:HttpGet(entry.url) end)
    if ok and sourceCode then
        local compiled, err = loadstring(sourceCode)
        if compiled then
            print("[CRACK] Launching main menu window execution...")
            pcall(compiled)
        else
            warn("[CRACK] Main file compilation failed: ", err)
        end
    else
        warn("[CRACK] Failed to reach download server pipeline.")
    end
end)
