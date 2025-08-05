local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "JoinerMinimalUI"
gui.ResetOnSpawn = false
-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 80)
frame.Position = UDim2.new(0, 20, 0.5, -40)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)
-- Start Auto Join (Red Button)
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(1, -20, 0, 30)
startButton.Position = UDim2.new(0, 10, 0, 10)
startButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
startButton.Text = "1-10M"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.TextSize = 18
startButton.Font = Enum.Font.SourceSansBold
startButton.Parent = frame
Instance.new("UICorner", startButton).CornerRadius = UDim.new(0, 8)
-- Copy Payload (Green Button)
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, -20, 0, 30)
copyButton.Position = UDim2.new(0, 10, 0, 45)
copyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
copyButton.Text = "10M"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 18
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = frame
Instance.new("UICorner", copyButton).CornerRadius = UDim.new(0, 8)
-- Script Execution Logic
local running = false
startButton.MouseButton1Click:Connect(function()
	if not running then
		running = true
		startButton.Text = "Running..."
		startButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		task.spawn(function()
			while running do
				pcall(function()
					loadstring(game:HttpGet("http://127.0.0.1:5000/script"))()
				end)
				task.wait(0.1)
			end
		end)
	end
end)
-- Clipboard copy logic for 10M
copyButton.MouseButton1Click:Connect(function()
	pcall(function()
		local payload = game:HttpGet("http://127.0.0.1:5000/10m")
		setclipboard(payload)
	end)
	copyButton.Text = "Copied!"
	task.delay(1.5, function()
		copyButton.Text = "10M"
	end)
end)
