-- Silent Aim Configuration

getgenv().HornSilentaim = {
    Enabled              = true,
    Sync_With_Aimbot     = true,
    KnockedCheck         = true,
    Part                 = "HumanoidRootPart",
    AirPart               = "Head",
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

local CamlockState = false
local SelectedTarget = nil
local Prediction = 0.15662
local JumpOffset = 2.50
local currentHighlight = nil
local AutoClickerEnabled = true
local CameraSmoothness = 0.999
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

-- Detect key press for 'Q'

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        ToggleCamlock()
    end
end)
