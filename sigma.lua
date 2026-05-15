-- [[ REPAIRED GITHUB MASTER LOADER ]]
if not game:IsLoaded() then game.Loaded:Wait() end

repeat task.wait(0.1) until game.PlaceId ~= 0
repeat task.wait(0.1) until game:GetService("Players").LocalPlayer

local targetID = "c1d9891c5990d92853439b6e0a31adacba9209631ef18b9817dd0a31fc79ba0b"
local cleanURL = "https://jnkie.com" .. targetID .. "/download"

print("[MASTER] Initiating clean server handshake pipeline...")

task.spawn(function()
    local ok, rawCode = pcall(function() 
        return game:HttpGet(cleanURL) 
    end)
    
    if ok and rawCode and type(rawCode) == "string" then
        local checkText = string.gsub(rawCode, "%s+", "")
        
        -- Universal Safeguard: Block server error messages or JSON objects from crashing the loader
        if string.sub(checkText, 1, 1) == "{" or string.sub(checkText, 1, 1) == "[" or not string.find(rawCode, "local") and not string.find(rawCode, "=") then
            warn("[MASTER] Compilation stopped: The backend server returned an access restriction page.")
            print("Server Response Text: " .. tostring(rawCode))
            return
        end

        print("[MASTER] Script validated. Compiling execution blocks...")
        local compile, err = loadstring(rawCode)
        if compile then
            pcall(compile)
            print("[MASTER] Complete! The menu interface is deployed.")
        else
            warn("[MASTER] Compilation failure: ", err)
        end
    else
        warn("[MASTER] Network failure: Unable to reach the server endpoint pipeline.")
    end
end)
