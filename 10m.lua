(function()
repeat wait() until game:IsLoaded()
local HttpsURL = “https://logging-newsletters-discussion-one.trycloudflare.com/” – change port if you changed it in your server
local PollInterval = 1 – seconds between requests

```
local function prints(str)
    print("[AutoJoiner]: " .. str)
end

local function findTargetGui()
    for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
        if not gui:IsA("ScreenGui") then continue end

        for _, descendant in ipairs(gui:GetDescendants()) do
            if descendant:IsA("TextLabel") and descendant.Text == "Job-ID Input" then
                return descendant:FindFirstAncestorOfClass("ScreenGui")
            end
        end
    end
end

local function setJobIDText(targetGui, text)
    for _, btn in ipairs(targetGui:GetDescendants()) do
        if btn:IsA("TextButton") then
            local frames = {}

            for _, child in ipairs(btn:GetChildren()) do
                if child:IsA("Frame") then
                    table.insert(frames, child)
                end
            end
            if #frames < 2 then continue end

            local foundLabel = false
            for _, descendant in ipairs(frames[1]:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant.Text == "Job-ID Input" then
                    foundLabel = true
                    break
                end
            end
            if not foundLabel then continue end

            for _, subFrame in ipairs(frames[2]:GetChildren()) do
                if subFrame:IsA("Frame") then
                    for _, obj in ipairs(subFrame:GetDescendants()) do
                        if obj:IsA("TextBox") then
                            obj.Text = text
                            prints("Textbox updated: " .. text .. " (10m+ bypass)")
                            return obj
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function clickJoinButton(targetGui)
    local function findButton(base)
        for _, btn in ipairs(base:GetDescendants()) do
            if btn:IsA("TextButton") then
                for _, content in ipairs(btn:GetDescendants()) do
                    if content:IsA("TextLabel") and content.Text == "Join Job-ID" then
                        return btn
                    end
                end
            end
        end
    end

    local current = targetGui
    for _ = 1, 4 do
        local button = findButton(current)
        if button then return button end
        current = current.Parent
        if not current then break end
    end
    return nil
end

local function bypass10M(jobId)
    local targetGui = findTargetGui()
    local textBox = setJobIDText(targetGui, jobId)
    local button = clickJoinButton(targetGui)

    task.defer(function()
        task.wait(0.05) -- change to your preferred value (if removed = will be zeros)
        for _, conn in ipairs(getconnections(button.MouseButton1Click)) do
            conn:Fire()
            prints("Join server clicked (10m+ bypass)")
        end
    end)
end

local function justJoin(script)
    local func, err = loadstring(script)
    if func then
        local ok, result = pcall(func)
        if not ok then
            prints("Error while executing script: " .. result)
        end
    else
        prints("Some unexpected error: " .. err)
    end
end

local function makeHttpRequest()
    local HttpService = game:GetService("HttpService")
    
    local success, response = pcall(function()
        return HttpService:GetAsync(HttpsURL, false)
    end)
    
    if success and response then
        return response
    else
        return nil
    end
end

local function pollServer()
    while true do
        local response = makeHttpRequest()
        
        if response and response ~= "" then
            if not string.find(response, "TeleportService") then
                prints("Bypassing 10m server: " .. response)
                bypass10M(response)
            else
                prints("Running the script: " .. response)
                justJoin(response)
            end
        end
        
        wait(PollInterval)
    end
end

local function connect()
    prints("Starting HTTPS polling from " .. HttpsURL)
    prints("Poll interval: " .. PollInterval .. " seconds")
    
    local success, err = pcall(pollServer)
    if not success then
        prints("Error in polling loop: " .. err)
        wait(5)
        connect() -- restart
    end
end

connect()
```

end)()
– Modified from WebSocket to HTTPS polling
– Original: https://github.com/notasnek/roblox-autojoiner
