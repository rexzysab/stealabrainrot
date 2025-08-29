local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJoinUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Title.Text = "Rexzy Joiner"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local HttpService = game:GetService("HttpService")

local function formatMoney(num)
    return string.format("%.1fM", num / 1000000)
end

local function parseInput(str)
    local num = tonumber(str)
    if num then
        return math.clamp(num * 1000000, 1000000, 10000000)
    end
    return nil
end

local hwid = "unknown_hwid"
pcall(function()
    hwid = game:GetService("RbxAnalyticsService"):GetClientId()
end)

local cfgFile = "autojoin_"..hwid..".json"

local function loadConfig()
    if isfile and isfile(cfgFile) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(cfgFile))
        end)
        if success and type(data) == "table" then
            return data
        end
    end
    return { MinMS = 1000000 }
end

local function saveConfig(cfg)
    if writefile then
        writefile(cfgFile, HttpService:JSONEncode(cfg))
    end
end

local config = loadConfig()
local MinMS = config.MinMS or 1000000

local AutoJoinEnabled = false
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1, -20, 0, 35)
Toggle.Position = UDim2.new(0, 10, 0, 50)
Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Toggle.Text = "Auto Join: OFF"
Toggle.TextColor3 = Color3.fromRGB(255, 100, 100)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 16
Toggle.Parent = MainFrame

Toggle.MouseButton1Click:Connect(function()
    AutoJoinEnabled = not AutoJoinEnabled
    Toggle.Text = "Auto Join: " .. (AutoJoinEnabled and "ON" or "OFF")
    Toggle.TextColor3 = AutoJoinEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

-- Min Label
local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(1, -20, 0, 25)
MinLabel.Position = UDim2.new(0, 10, 0, 95)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "Min M/s: " .. formatMoney(MinMS)
MinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextSize = 14
MinLabel.Parent = MainFrame

-- Min TextBox
local MinBox = Instance.new("TextBox")
MinBox.Size = UDim2.new(1, -20, 0, 25)
MinBox.Position = UDim2.new(0, 10, 0, 120)
MinBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
MinBox.Text = tostring(MinMS/1000000)
MinBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBox.Font = Enum.Font.Gotham
MinBox.TextSize = 14
MinBox.ClearTextOnFocus = false
MinBox.Parent = MainFrame

MinBox.FocusLost:Connect(function()
    local val = parseInput(MinBox.Text)
    if val then
        MinMS = val
        MinLabel.Text = "Min M/s: " .. formatMoney(val)
        saveConfig({ MinMS = MinMS })
        MinBox.Text = tostring(MinMS/1000000)
    else
        MinBox.Text = tostring(MinMS/1000000)
    end
end)

if not WebSocket then
    warn("Your executor does not support WebSocket.")
    return
end

local ws, err = WebSocket.connect("ws://5.255.97.147:6767/script")
if not ws then
    warn("WebSocket Error:", tostring(err))
    return
end

local function parseMoney(str)
    if not str then return 0 end
    local num, suffix = str:match("(%d+%.?%d*)([MK]?)")
    num = tonumber(num)
    if not num then return 0 end

    if suffix == "M" then
        return num * 1000000
    elseif suffix == "K" then
        return num * 1000
    else
        return num
    end
end

ws.OnMessage:Connect(function(msg)
    local success, data = pcall(function()
        return HttpService:JSONDecode(msg)
    end)
    if not success or type(data) ~= "table" then return end

    if AutoJoinEnabled and data.type == "server_update" and data.data and data.data.join_script then
        local moneyStr = data.data.money or "$0/s"
        local moneyVal = parseMoney(moneyStr)

        if moneyVal >= MinMS then
            print("[AutoJoin] Joining server with "..moneyStr)
            local func, err = loadstring(data.data.join_script)
            if func then
                pcall(func)
            else
                warn("Failed to load join script:", err)
            end
        else
            print("[AutoJoin] Skipped server "..moneyStr.." < Min "..formatMoney(MinMS))
        end
    end
end)
