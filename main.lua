local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "JoinerRexzyUI"
gui.ResetOnSpawn = false

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 70)
frame.Position = UDim2.new(0, 20, 0.5, -35)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true -- Needed for dragging
frame.Draggable = true -- Enables drag
frame.Parent = gui

-- UICorner for rounded edges
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Joiner | Rexzy"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 30)
button.Position = UDim2.new(0, 10, 1, -35)
button.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
button.Text = "Start auto join"
button.TextColor3 = Color3.fromRGB(240, 240, 240)
button.TextSize = 20
button.Font = Enum.Font.SourceSansBold
button.AutoButtonColor = false
button.Parent = frame

-- UICorner for button
local buttonCorner = Instance.new("UICorner", button)
buttonCorner.CornerRadius = UDim.new(0, 10)

-- Function to run payload repeatedly
local running = false
local loop

button.MouseButton1Click:Connect(function()
	if not running then
		running = true
		button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		button.Text = "Running..."

		-- Start loop
		loop = task.spawn(function()
			while running do
				pcall(function()
					loadstring(game:HttpGet("http://127.0.0.1:5000"))()
				end)
				task.wait(0.1)
			end
		end)
	end
end)
