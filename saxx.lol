-- Silent Aim Configuration

getgenv().HornSilentaim = {
    Enabled              = true,
    Sync_With_Aimbot     = true,
    KnockedCheck         = true,
    Part                 = "HumanoidRootPart",
    AirPart               = "HumanoidRootPart",
    Use_Radius            = false,
    Radius                = 200
}

-- Services

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Variables

local CamlockState = true
local SelectedTarget = nil
local Prediction = 0.1455
local JumpOffset = 2.50
local currentHighlight = nil
local AutoClickerEnabled = true
local CameraSmoothness = 0.073
local JumpSmoothness = 0.1
local FlickSmoothness = 0.1
local CurrentJumpOffset = 2.50
local FlickRotation = 1.25

-- Function to create and adjust the highlight effect

local function CreateHighlight(target)
    local highlight = Instance.new("Highlight")
    highlight.Parent = target
    highlight.Adornee = target
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0.5
    highlight.FillTransparency = 0.5
    return highlight
end

-- Function to scale the hitbox of the target

local function ScaleHitbox(target, scaleFactor)
    local humanoidRootPart = target:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Size = humanoidRootPart.Size * scaleFactor
    end
end

-- Function to select and highlight the target

local function SelectTarget(target)
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end
    SelectedTarget = target
    if SelectedTarget then
        local scaleFactor = 3
        ScaleHitbox(SelectedTarget, scaleFactor)
        currentHighlight = CreateHighlight(SelectedTarget)
    end
end

-- Function to deselect and reset target hitbox

local function DeselectTarget(target)
    local humanoidRootPart = target:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local scaleFactor = 3
        humanoidRootPart.Size = humanoidRootPart.Size / scaleFactor
    end
end

-- Show a notification

local function ShowNotification(text)
    StarterGui:SetCore("SendNotification", {
        Title = "saxx.lol",
        Text = text,
        Duration = 3
    })
end

-- Check health and update highlight

local function CheckHealthAndHighlight(target)
    if target and target:FindFirstChild("Humanoid") then
        if target.Humanoid.Health <= 0 then
            return true
        end
    end
    return false
end

-- Find the closest visible enemy

local function FindClosestEnemy()
    local closestDistance = math.huge
    local closestPlayer = nil
    local centerPosition = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character.Humanoid.Health > 0 then
                local position, isVisible = Workspace.CurrentCamera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                if isVisible then
                    local distance = (centerPosition - Vector2.new(position.X, position.Y)).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = character
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Check if the target is visible

local function IsTargetVisible(target)
    if target and target:FindFirstChild("HumanoidRootPart") then
        local targetPosition = target.HumanoidRootPart.Position
        local cameraPosition = Workspace.CurrentCamera.CFrame.Position
        local ray = Ray.new(cameraPosition, (targetPosition - cameraPosition).unit * (cameraPosition - targetPosition).magnitude)
        local hitPart, hitPosition = Workspace:FindPartOnRay(ray, LocalPlayer.Character, false, true)
        return hitPart == target.HumanoidRootPart
    end
    return false
end

-- Smoothly interpolate camera position and orientation

local function SmoothCameraTransition(targetPosition)
    local camera = Workspace.CurrentCamera
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    local newCFrame = currentCFrame:Lerp(targetCFrame, 1 / CameraSmoothness)
    camera.CFrame = newCFrame
end

-- Smoothly apply a flick effect to the camera

local function ApplyFlickEffect()
    local camera = Workspace.CurrentCamera
    local currentCFrame = camera.CFrame
    local flickRotation = CFrame.Angles(0, math.rad(FlickRotation), 0)
    camera.CFrame = currentCFrame * flickRotation
end

-- Auto airshot function with enhanced targeting and smooth jump offset

local function AutoAirshot()
    if CamlockState and SelectedTarget then
        local head = SelectedTarget:FindFirstChild("Head")
        local humanoidRootPart = SelectedTarget:FindFirstChild("HumanoidRootPart")
        local upperTorso = SelectedTarget:FindFirstChild("UpperTorso")
        local humanoid = SelectedTarget:FindFirstChild("Humanoid")
        if head and humanoidRootPart and humanoid then
            local targetPosition = upperTorso and upperTorso.Position or head.Position
            targetPosition = targetPosition + humanoidRootPart.Velocity * Prediction
            if humanoidRootPart.Velocity.Y > 0 then
                local desiredJumpOffset = JumpOffset
                CurrentJumpOffset = CurrentJumpOffset + (desiredJumpOffset - CurrentJumpOffset) * JumpSmoothness
                targetPosition = targetPosition + Vector3.new(0, CurrentJumpOffset, 0)
                ApplyFlickEffect()
            else
                CurrentJumpOffset = 0
            end
            SmoothCameraTransition(targetPosition)
            if IsTargetVisible(SelectedTarget) then
                local equippedTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if equippedTool and equippedTool ~= CamlockTool then
                    local tool = equippedTool
                    if AutoClickerEnabled and humanoidRootPart.Velocity.Y > 0 then
                        if not tool.Activated then
                            tool:Activate()
                        end
                        print("Firing with tool: " .. tool.Name)
                    end
                end
            end
            if CheckHealthAndHighlight(SelectedTarget) and humanoidRootPart.Velocity.Y < -0.1 then
                CamlockState = false
                DeselectTarget(SelectedTarget)
                if currentHighlight then
                    currentHighlight:Destroy()
                    currentHighlight = nil
                end
                print("Camlock OFF - Target's health is 0 and falling")
            end
        end
    end
end

-- Update camera and handle auto airshot

RunService.Heartbeat:Connect(function()
    AutoAirshot()
end)

-- Key binding for Camlock toggle

local function ToggleCamlock()
    if not CamlockState then
        local closestEnemy = FindClosestEnemy()
        if closestEnemy then
            SelectTarget(closestEnemy)
            CamlockState = true
            ShowNotification("Camlock ON - Target Locked")
        else
            ShowNotification("No valid target found")
        end
    else
        CamlockState = false
        if currentHighlight then
            currentHighlight:Destroy()
            currentHighlight = nil
        end
        if SelectedTarget then
            DeselectTarget(SelectedTarget)
        end
        ShowNotification("Camlock OFF")
    end
end

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        ToggleCamlock()
    end
end)

-- player highlighter source code

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local localPlayer = Players.LocalPlayer
local targetPlayer = nil
local highlighting = false
local highlightColor = Color3.fromRGB(255, 0, 0) -- Red color

-- Function to highlight the target player
local function highlightPlayer(player)
    if player and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                local highlight = Instance.new("BoxHandleAdornment")
                highlight.Name = "ESPHighlight"
                highlight.Size = part.Size
                highlight.Color3 = highlightColor
                highlight.Transparency = 0.5
                highlight.AlwaysOnTop = true
                highlight.Adornee = part
                highlight.ZIndex = 0
                highlight.Parent = part
            end
        end
    end
end

-- Function to remove the highlight
local function removeHighlight(player)
    if player and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") and part:FindFirstChild("ESPHighlight") then
                part.ESPHighlight:Destroy()
            end
        end
    end
end

-- Function to handle key press
local function onKeyPress(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        if highlighting then
            removeHighlight(targetPlayer)
            targetPlayer = nil
            highlighting = false
        else
            local mouse = localPlayer:GetMouse()
            local target = mouse.Target
            if target and target:IsDescendantOf(workspace) then
                local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
                if targetPlayer and targetPlayer ~= localPlayer then
                    highlightPlayer(targetPlayer)
                    highlighting = true
                end
            end
        end
    end
end

-- Connect the key press event
UserInputService.InputBegan:Connect(onKeyPress)


-- saxx.lol gui source

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "saxx.lol"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0.5, -100, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(128, 128, 128)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local UICornerOuter = Instance.new("UICorner")
UICornerOuter.CornerRadius = UDim.new(0, 20)
UICornerOuter.Parent = frame

local saxxButton = Instance.new("TextButton")
saxxButton.Name = "saxxButton"
saxxButton.Size = UDim2.new(0, 180, 0, 60)
saxxButton.Position = UDim2.new(0.5, -90, 0, 10)
saxxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
saxxButton.BorderSizePixel = 0
saxxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saxxButton.Text = "saxx.lol"
saxxButton.Font = Enum.Font.SourceSans
saxxButton.TextSize = 24
saxxButton.TextScaled = true
saxxButton.Parent = frame

local UICornerButton = Instance.new("UICorner")
UICornerButton.CornerRadius = UDim.new(0, 10)
UICornerButton.Parent = saxxButton

local espButton = Instance.new("TextButton")
espButton.Name = "espButton"
espButton.Size = UDim2.new(0, 160, 0, 40)
espButton.Position = UDim2.new(0.5, -80, 0.5, 10)
espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
espButton.BorderSizePixel = 0
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Text = "player esp"
espButton.Font = Enum.Font.SourceSans
espButton.TextSize = 16
espButton.TextScaled = true
espButton.Parent = frame

local UICornerEsp = Instance.new("UICorner")
UICornerEsp.CornerRadius = UDim.new(0, 5)
UICornerEsp.Parent = espButton

local isGuiOn = false
local isRemoved = false

saxxButton.MouseButton1Click:Connect(function()
    isGuiOn = not isGuiOn
    
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
end)

espButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/shakar60/scripts/main/esp",true))()
    espButton:Destroy()
    frame:TweenSize(UDim2.new(0, 200, 0, 90), "Out", "Quad", 0.3, true)
    
    StarterGui:SetCore("SendNotification", {
        Title = "Info";
        Text = "Esp Script Executed (Rejoin To Turn It Off Because You Cant Turn It Off)";
        Duration = 15;
    })
end)

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        isGuiOn = not isGuiOn
    end
end)

player.Chatted:Connect(function(message)
    if message:lower() == "/e killsaxx" then
        if gui and not isRemoved then
            gui:Destroy()
            isGuiOn = false
            isRemoved = true
            
            StarterGui:SetCore("SendNotification", {
                Title = "Info";
                Text = "the saxx.lol has been removed.";
                Duration = 15;
            })
        end
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Info";
    Text = "Type /e killsaxx to kill the saxx.lol gui.";
    Duration = 15;
})

--credits notification

StarterGui:SetCore("SendNotification", {
    Title = "Credits";
    Text = "Credits To sh4k4r6o For Making All The Button And Esp Stuff,\";
    Duration = 25;
})
