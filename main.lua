local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "JoinerRexzyUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 190)
frame.Position = UDim2.new(0, 20, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Joiner | Rexzy"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

local buttons = {}

local function createButton(text, order, scriptEndpoint)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 30 + ((order - 1) * 40))
    button.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(240, 240, 240)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSansBold
    button.AutoButtonColor = false
    button.Parent = frame

    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 10)

    buttons[button] = {
        originalText = text,
        running = false,
        loop = nil,
        url = scriptEndpoint
    }

    button.MouseButton1Click:Connect(function()
        local btnData = buttons[button]
        btnData.running = not btnData.running

        if btnData.running then
            button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            button.Text = "Running..."

            btnData.loop = task.spawn(function()
                while btnData.running do
                    pcall(function()
                        local payload = game:HttpGet(btnData.url)
                        local loadedFunc = loadstring(payload)
                        if typeof(loadedFunc) == "function" then
                            task.spawn(loadedFunc)
                        end
                    end)
                end
            end)
        else
            btnData.running = false
            button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            button.Text = "Stopped"

            task.delay(3, function()
                if not btnData.running then
                    button.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
                    button.Text = btnData.originalText
                end
            end)
        end
    end)
end

createButton("Start auto join", 1, "https://explains-ohio-contents-rev.trycloudflare.com/script")
createButton("1-3M", 2, "https://explains-ohio-contents-rev.trycloudflare.com/1-3m-script")
createButton("3-6M", 3, "https://explains-ohio-contents-rev.trycloudflare.com/3-6m-script")
createButton("6-9M", 4, "https://explains-ohio-contents-rev.trycloudflare.com/6-9m-script")
