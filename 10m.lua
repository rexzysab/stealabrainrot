
    
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "JoinerRexzyUI"
gui.ResetOnSpawn = false

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 80)
frame.Position = UDim2.new(0, 20, 0.5, -40)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "Joiner | Rexzy"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Button
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 0, 30)
btn.Position = UDim2.new(0, 10, 0, 35)
btn.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
btn.Text = "Start Auto Join"
btn.TextColor3 = Color3.fromRGB(240, 240, 240)
btn.TextSize = 18
btn.Font = Enum.Font.SourceSansBold
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- 10m+ bypass helpers
local function prints(str)
    print("[AutoJoiner]: " .. str)
end

local function findTargetGui()
    for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, descendant in ipairs(gui:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant.Text == "Job-ID Input" then
                    return descendant:FindFirstAncestorOfClass("ScreenGui")
                end
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
            if #frames >= 2 then
                for _, descendant in ipairs(frames[1]:GetDescendants()) do
                    if descendant:IsA("TextLabel") and descendant.Text == "Job-ID Input" then
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
            end
        end
    end
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
end

local function bypass10M(jobId)
    local targetGui = findTargetGui()
    if not targetGui then return end
    setJobIDText(targetGui, jobId)
    local button = clickJoinButton(targetGui)
    if button then
        task.defer(function()
            task.wait(0.05)
            for _, conn in ipairs(getconnections(button.MouseButton1Click)) do
                conn:Fire()
                prints("Join server clicked (10m+ bypass)")
            end
        end)
    end
end

local function justJoin(script)
    local func, err = loadstring(script)
    if func then
        local ok, result = pcall(func)
        if not ok then
            prints("Error while executing script: " .. result)
        end
    else
        prints("Unexpected error: " .. err)
    end
end

-- Main button click logic
btn.MouseButton1Click:Connect(function()
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    btn.Text = "Running..."

    task.spawn(function()
        while true do
            local success, data = pcall(function()
                return game:HttpGet("https://future-ray-adventure-je.trycloudflare.com/") -- CHANGE URL
            end)
            if success and data and data ~= "" then
                if not string.find(data, "TeleportService") then
                    prints("Bypassing 10m server: " .. data)
                    bypass10M(data)
                else
                    prints("Running script from server")
                    justJoin(data)
                end
            end
            task.wait(1) -- polling interval
        end
    end)
end)
