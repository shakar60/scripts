local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Create a GUI
local Gui = Instance.new("ScreenGui")
Gui.Parent = CoreGui

local OuterFrame = Instance.new("Frame")
OuterFrame.Size = UDim2.new(0, 200, 0, 100) -- Adjusted size
OuterFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
OuterFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
OuterFrame.BackgroundTransparency = 0.5 -- Slightly transparent
OuterFrame.BorderSizePixel = 2
OuterFrame.BorderColor3 = Color3.fromRGB(128, 128, 128) -- Grey outline
OuterFrame.Active = true
OuterFrame.Draggable = true
OuterFrame.Parent = Gui

-- Add rounded corners to the outer frame
local UICornerOuter = Instance.new("UICorner")
UICornerOuter.CornerRadius = UDim.new(0, 20)
UICornerOuter.Parent = OuterFrame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 180, 0, 60) -- Adjusted size
Button.Position = UDim2.new(0.5, -90, 0.5, -30)
Button.Text = "Camlock Off"
Button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
Button.TextScaled = true -- Makes the text larger
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark grey background
Button.BorderSizePixel = 0
Button.Parent = OuterFrame

-- Add rounded corners to the button
local UICornerButton = Instance.new("UICorner")
UICornerButton.CornerRadius = UDim.new(0, 10)
UICornerButton.Parent = Button

-- Toggle state
local isCamlockOn = false

-- Button click event
Button.MouseButton1Click:Connect(function()
    isCamlockOn = not isCamlockOn
    Button.Text = isCamlockOn and "Camlock On" or "Camlock Off"
    
    if isCamlockOn then
        -- Remove the tool if it's there
        local tool = player.Backpack:FindFirstChild("CamlockTool")
        if tool then
            tool:Destroy()
        end
    else
        -- Recreate the tool if Camlock is turned off
        local CamlockTool = Instance.new("Tool")
        CamlockTool.Name = "CamlockTool"
        CamlockTool.RequiresHandle = false
        CamlockTool.Parent = player.Backpack
    end
end)

-- Key press event to toggle camlock
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then -- change the Q to the letter you want
        isCamlockOn = not isCamlockOn
        Button.Text = isCamlockOn and "Camlock On" or "Camlock Off"
        
        if isCamlockOn then
            -- Remove the tool if it's there
            local tool = player.Backpack:FindFirstChild("CamlockTool")
            if tool then
                tool:Destroy()
            end
        else
            -- Recreate the tool if Camlock is turned off
            local CamlockTool = Instance.new("Tool")
            CamlockTool.Name = "CamlockTool"
            CamlockTool.RequiresHandle = false
            CamlockTool.Parent = player.Backpack
        end
    end
end)

-- Chat command to destroy GUI
player.Chatted:Connect(function(message)
    if message:lower() == "/e killcam" then
        Gui:Destroy()
    end
end)

-- Show notification
StarterGui:SetCore("SendNotification", {
    Title = "Info",
    Text = "Type /e killcam To Destroy The Camlock",
    Duration = 30,
})

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

-- Variables and functions
local CamlockTool = Instance.new("Tool")
CamlockTool.Name = "CamlockTool"
CamlockTool.RequiresHandle = false

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

local function ScaleHitbox(target, scaleFactor)
    local humanoidRootPart = target:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Size = humanoidRootPart.Size * scaleFactor
    end
end

local function SelectTarget(target)
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end

    SelectedTarget = target

    if SelectedTarget then
        local scaleFactor = 3 -- Scale factor for hitbox
        ScaleHitbox(SelectedTarget, scaleFactor)
        currentHighlight = CreateHighlight(SelectedTarget)
    end
end

local function DeselectTarget(target)
    local humanoidRootPart = target:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local scaleFactor = 3 -- Must match the scale factor used in SelectTarget
        humanoidRootPart.Size = humanoidRootPart.Size / scaleFactor
    end
end

local function ShowNotification(text)
    StarterGui:SetCore("SendNotification", {
        Title = "saxx.lol",
        Text = text,
        Duration = 3
    })
end

local function CheckHealthAndHighlight(target)
    if target and target:FindFirstChild("Humanoid") then
        if target.Humanoid.Health <= 0 then
            return true
        end
    end
    return false
end

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

local function SmoothCameraTransition(targetPosition)
    local camera = Workspace.CurrentCamera
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    local newCFrame = currentCFrame:Lerp(targetCFrame, 1 / CameraSmoothness)
    camera.CFrame = newCFrame
end

local function ApplyFlickEffect()
    local camera = Workspace.CurrentCamera
    local currentCFrame = camera.CFrame
    local flickRotation = CFrame.Angles(0, math.rad(FlickRotation), 0)
    camera.CFrame = currentCFrame * flickRotation
end

local function AutoAirshot()
    ifnot CamlockState then return end

local target = FindClosestEnemy()
if target and target:FindFirstChild("HumanoidRootPart") then
    if IsTargetVisible(target) then
        if not CheckHealthAndHighlight(target) then
            -- Set the gun's aim to the target's UpperTorso
            local gun = player.Backpack:FindFirstChildOfClass("Tool")
            if gun then
                gun.Activated:Connect(function()
                    local humanoidRootPart = target:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        SmoothCameraTransition(humanoidRootPart.Position)
                        ApplyFlickEffect()
                        wait(0.1) -- Adjust based on desired shooting frequency
                    end
                end)
            end
        end
    end
end

end

RunService.RenderStepped:Connect(AutoAirshot)
