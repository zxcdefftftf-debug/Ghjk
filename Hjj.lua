-- MODE_CHEAT | MODERN UI 2026 | KEY: SERIY-290
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- УСИЛЕННЫЙ АНТИ-БАН (HOOKING)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "Ban" or method == "FireServer" and tostring(self):lower():find("anticheat") then return end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 400); MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200); MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); MainFrame.BorderSizePixel = 0; MainFrame.Visible = false; MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame); Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "MODE_CHEAT"; Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.TextSize = 20

local TimeLabel = Instance.new("TextLabel", ScreenGui); TimeLabel.Size = UDim2.new(0, 150, 0, 30); TimeLabel.Position = UDim2.new(0, 10, 0, 10); TimeLabel.BackgroundTransparency = 1; TimeLabel.TextColor3 = Color3.new(1,1,1); TimeLabel.Font = Enum.Font.Code
RunService.RenderStepped:Connect(function() TimeLabel.Text = os.date("%H:%M:%S") end)

-- LOGIC
local Toggles = {Aimbot = false, WallBang = false, ESP = false}
local function CreateBtn(name, y)
    local btn = Instance.new("TextButton", MainFrame); btn.Size = UDim2.new(0, 260, 0, 40); btn.Position = UDim2.new(0, 20, 0, y); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Code
    btn.MouseButton1Click:Connect(function() Toggles[name] = not Toggles[name]; btn.BackgroundColor3 = Toggles[name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 40) end)
end

CreateBtn("Aimbot", 60); CreateBtn("WallBang", 110); CreateBtn("ESP", 160)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    -- AIMBOT LOGIC
    if Toggles.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest, min = nil, 999
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local dist = (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize/2).Magnitude
                if dist < min then closest = p.Character.Head; min = dist end
            end
        end
        if closest then Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position) end
    end

    -- ESP LOGIC
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("ESPHighlight")
            if Toggles.ESP then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineTransparency = 0
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- LOGIN
local LoginFrame = Instance.new("Frame", ScreenGui); LoginFrame.Size = UDim2.new(0, 200, 0, 100); LoginFrame.Position = UDim2.new(0.5, -100, 0.5, -50); LoginFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local Input = Instance.new("TextBox", LoginFrame); Input.Size = UDim2.new(0, 180, 0, 40); Input.Position = UDim2.new(0, 10, 0, 10); Input.PlaceholderText = "KEY"
local CheckBtn = Instance.new("TextButton", LoginFrame); CheckBtn.Size = UDim2.new(0, 180, 0, 30); CheckBtn.Position = UDim2.new(0, 10, 0, 60); CheckBtn.Text = "LOGIN"
CheckBtn.MouseButton1Click:Connect(function() if Input.Text == "SERIY-290" then LoginFrame:Destroy(); MainFrame.Visible = true end end)
