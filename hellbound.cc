local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = game.Players.LocalPlayer:GetMouse()
local CamlockState = false
local Prediction = 0.2
local HorizontalPrediction = 0.15
local VerticalPrediction = 0.15
local XPrediction = 20
local YPrediction = 20

function FindNearestEnemy()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    local CenterPosition = Vector2.new(game:GetService("GuiService"):GetScreenResolution().X / 2, game:GetService("GuiService"):GetScreenResolution().Y / 2)

    for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0 then
                local Position, IsVisibleOnViewport = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
                if IsVisibleOnViewport then
                    local Distance = (CenterPosition - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character.HumanoidRootPart
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

local enemy = nil
local glowingPart = nil

-- Function to aim the camera at the nearest enemy's HumanoidRootPart
RunService.Heartbeat:Connect(function()
    if CamlockState == true then
        if enemy then
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.p, enemy.Position + enemy.Velocity * Prediction)
            
            if glowingPart then
                glowingPart.Enabled = true
                glowingPart.Parent = enemy
                glowingPart.Face = Enum.NormalId.Front
            end
        end
    else
        if glowingPart then
            glowingPart:Destroy() -- Remove glowing effect by destroying the part
        end
    end
end)

local Hellbound = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

-- Properties:
Hellbound.Name = "Hellbound"
Hellbound.Parent = game.CoreGui
Hellbound.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = Hellbound
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Blue color
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
Frame.Size = UDim2.new(0, 202, 0, 70)
Frame.Active = true
Frame.Draggable = true

local function TopContainer()
    Frame.Position = UDim2.new(0.5, -Frame.AbsoluteSize.X / 2, 0, -Frame.AbsoluteSize.Y / 2)
end

TopContainer()
Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(TopContainer)

UICorner.Parent = Frame

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 5.000
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0792079195, 0, 0.18571429, 0)
TextButton.Size = UDim2.new(0, 170, 0, 44)
TextButton.Font = Enum.Font.SourceSansSemibold
TextButton.Text = "hellbound OFF" -- Changed text
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 11.000
TextButton.TextWrapped = true

-- Add UIStroke for rainbow effect
UIStroke.Parent = Frame
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(255, 255, 255) -- Initial color

-- Function to create a rainbow effect for the UIStroke and text color
local function RainbowEffect()
    local hue = 0
    while true do
        hue = (hue + 1) % 360
        local color = Color3.fromHSV(hue / 360, 1, 1)
        UIStroke.Color = color
        TextButton.TextColor3 = color
        wait(0.01)
    end
end

-- Start the rainbow effect
spawn(RainbowEffect)

TextButton.MouseButton1Click:Connect(function()
    CamlockState = not CamlockState
    TextButton.Text = CamlockState and "hellbound ON" or "hellbound OFF" -- Changed text for both states
    enemy = CamlockState and FindNearestEnemy() or nil
    
    if CamlockState then
        glowingPart = Instance.new("SurfaceLight")
        glowingPart.Color = Color3.fromRGB(0, 0, 255) -- Blue glow color
        glowingPart.Brightness = 10 -- Brighter glow
    else
        if glowingPart then
            glowingPart:Destroy() -- Remove glowing effect by destroying the part
        end
    end
end)

UICorner_2.Parent = TextButton
