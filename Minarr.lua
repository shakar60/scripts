if getgenv().key ~= "Minarr" then return end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

if UserInputService.TouchEnabled then
    local DrawingLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheRealXORA/Roblox/refs/heads/Main/Scripts%20/UI%20Libraries/Basic%20Drawing.lua"))()
    getfenv().Drawing = DrawingLib
else return end

local FilePath = "Minarr.json"
getgenv().Config = {
    Enabled = true,
    Size = 150,
    Thickness = 2,
    Transparency = 0.8,
    Filled = false,
    Position = "Crosshair",
    Prediction = 0.165,
    SelectedParts = {"HumanoidRootPart"},
    CurrentPart = "HumanoidRootPart",
    Checks = {
        ["Wall Check"] = true,
        ["KO Check"] = true,
        ["Forcefield Check"] = false,
        ["Team Check"] = false,
        ["Friend Check"] = false,
        ["Vehicle Check"] = false
    }
}

local function SaveConfig() writefile(FilePath, HttpService:JSONEncode(Config)) end
local function LoadConfig()
    if isfile(FilePath) then
        local ok, data = pcall(HttpService.JSONDecode, HttpService, readfile(FilePath))
        if ok then for k, v in pairs(data) do Config[k] = v end end
    end
end
LoadConfig()

local Silent = nil
getgenv().enemy = nil
local GuiInset = GuiService:GetGuiInset()
local LastPartTick = tick()

local Client = { Crosshair = nil }
local function FindCrosshair()
    if not LocalPlayer:FindFirstChild("PlayerGui") then return end
    for _, g in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
        if g.ClassName ~= "ScreenGui" then continue end
        for _, frame in ipairs(g:GetChildren()) do
            if frame.ClassName ~= "Frame" or frame.Name:lower() ~= "aim" then continue end
            if #frame:GetChildren() > 6 then continue end
            for _, bar in ipairs(frame:GetChildren()) do
                local n = bar.Name:lower()
                if n == "top" or n == "bottom" or n == "right" or n == "left" then
                    Client.Crosshair = frame
                    return
                end
            end
        end
    end
end
task.spawn(function()
    while true do FindCrosshair() task.wait(2) end
end)

task.spawn(function()
    while task.wait(1) do
        local instances = getnilinstances and getnilinstances() or {}
        for _, inst in ipairs(instances) do
            if inst.ClassName == "LocalScript" and inst.Name == "LocalScript" then
                local ok, env = pcall(getsenv, inst)
                if ok and type(env) == "table" and type(env.mobileShiftLockMousePos) == "function" then
                    inst.Name = "Guns Framework"
                    local global = env._G
                    env._G = setmetatable({}, {
                        __index = function(_, key)
                            if key == "MOUSE_POSITION" and Config.Enabled then
                                local e = getgenv().enemy
                                local char = e and e.Character
                                if char then
                                    local p = char:FindFirstChild(Config.CurrentPart)
                                    if p then
                                        local ok2, vel = pcall(function() return p.AssemblyLinearVelocity end)
                                        return p.Position + ((ok2 and vel or Vector3.zero) * Config.Prediction)
                                    end
                                end
                            end
                            return rawget(global, key)
                        end,
                        __newindex = function(_, key, value)
                            if key == "MOUSE_POSITION" and Config.Enabled then
                                local e = getgenv().enemy
                                local char = e and e.Character
                                if char then
                                    local p = char:FindFirstChild(Config.CurrentPart)
                                    if p then
                                        local ok2, vel = pcall(function() return p.AssemblyLinearVelocity end)
                                        rawset(global, key, p.Position + ((ok2 and vel or Vector3.zero) * Config.Prediction))
                                        return
                                    end
                                end
                            end
                            rawset(global, key, value)
                        end
                    })
                    break
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if #Config.SelectedParts > 1 then
        if tick() - LastPartTick >= 0.5 then
            Config.CurrentPart = Config.SelectedParts[math.random(1, #Config.SelectedParts)]
            LastPartTick = tick()
        end
    elseif #Config.SelectedParts == 1 then
        Config.CurrentPart = Config.SelectedParts[1]
    else
        Config.CurrentPart = "HumanoidRootPart"
    end
end)

local WallParams = RaycastParams.new()
WallParams.FilterType = Enum.RaycastFilterType.Exclude

local function GetTarget()
    if not Config.Enabled or not Silent then return nil end
    local closest, shortest = nil, Config.Size
    local camPos = Camera.CFrame.Position
    local silentPos = Silent.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        local char = plr.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild(Config.CurrentPart) or char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then continue end
        if Config.Checks["KO Check"] then
            local be = char:FindFirstChild("BodyEffects")
            if be then
                local ko = be:FindFirstChild("K.O")
                local dead = be:FindFirstChild("Dead")
                if (ko and ko.Value) or (dead and dead.Value) then continue end
            end
        end
        if Config.Checks["Team Check"] and plr.Team == LocalPlayer.Team and plr.Team ~= nil then continue end
        if Config.Checks["Forcefield Check"] and char:FindFirstChildOfClass("ForceField") then continue end
        if Config.Checks["Vehicle Check"] and hum.SeatPart then continue end
        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen then continue end
        local mag = (Vector2.new(screenPos.X, screenPos.Y) - silentPos).Magnitude
        if mag < shortest then
            if Config.Checks["Wall Check"] then
                WallParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
                if workspace:Raycast(camPos, root.Position - camPos, WallParams) then continue end
            end
            shortest = mag
            closest = plr
        end
    end
    return closest
end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "LavenderSilentAim"
gui.ResetOnSpawn = false

local MINIMIZED_H = 50
local FULL_H = 440
local FULL_W = 240
local minimized = false
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, FULL_W, 0, FULL_H)
Main.Position = UDim2.new(0.5, -120, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local Overlay = Instance.new("Frame", gui)
Overlay.BackgroundTransparency = 1
Overlay.Size = UDim2.new(0, FULL_W, 0, FULL_H)
Overlay.Position = Main.Position

RunService.Heartbeat:Connect(function()
    Overlay.Position = Main.Position
    Overlay.Size = Main.Size
end)

local titleBar = Instance.new("Frame", Main)
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundTransparency = 1

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Silent Aim\nFor Minarr"
titleLabel.TextColor3 = Color3.fromRGB(150, 130, 180)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local function makeTopBtn(icon, xOffset)
    local btn = Instance.new("TextButton", titleBar)
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, xOffset, 0, 10)
    btn.BackgroundColor3 = Color3.fromRGB(230, 220, 250)
    btn.Text = icon
    btn.TextColor3 = Color3.fromRGB(150, 130, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local closeBtn = makeTopBtn("X", -40)
local minBtn = makeTopBtn("-", -75)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    if Silent then Silent.Visible = false end
end)

local ChecksGUI, HitpartsGUI

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        if ChecksGUI then ChecksGUI.Visible = false end
        if HitpartsGUI then HitpartsGUI.Visible = false end
    end
    TweenService:Create(Main, tweenInfo, {
        Size = minimized and UDim2.new(0, FULL_W, 0, MINIMIZED_H) or UDim2.new(0, FULL_W, 0, FULL_H)
    }):Play()
    minBtn.Text = minimized and "+" or "-"
end)

local MainScroll = Instance.new("ScrollingFrame", Main)
MainScroll.Size = UDim2.new(1, -20, 1, -60)
MainScroll.Position = UDim2.new(0, 10, 0, 55)
MainScroll.BackgroundTransparency = 1
MainScroll.ScrollBarThickness = 0
MainScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local listLayout = Instance.new("UIListLayout", MainScroll)
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MainScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

local function CreateButton(parent, text, callback, order)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(160, 150, 190)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.LayoutOrder = order or 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

local function CreateBox(parent, label, key, order)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(1, 0, 0, 45)
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.Text = label .. ": " .. tostring(Config[key])
    box.TextColor3 = Color3.fromRGB(160, 150, 190)
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 14
    box.LayoutOrder = order or 0
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text:match("%d+%.?%d*"))
        if v then
            Config[key] = v
            box.Text = label .. ": " .. tostring(v)
            SaveConfig()
        end
    end)
    return box
end

CreateButton(MainScroll, "Enabled: " .. (Config.Enabled and "On" or "Off"), function(b)
    Config.Enabled = not Config.Enabled
    b.Text = "Enabled: " .. (Config.Enabled and "On" or "Off")
    SaveConfig()
end, 1)

CreateBox(MainScroll, "Prediction", "Prediction", 2)
CreateBox(MainScroll, "Size", "Size", 3)

CreateButton(MainScroll, "Filled: " .. (Config.Filled and "On" or "Off"), function(b)
    Config.Filled = not Config.Filled
    b.Text = "Filled: " .. (Config.Filled and "On" or "Off")
    SaveConfig()
end, 4)

CreateButton(MainScroll, "Position: " .. Config.Position, function(b)
    local m = {"Mouse", "Center", "Crosshair"}
    local idx = table.find(m, Config.Position) or 1
    Config.Position = m[idx % #m + 1]
    b.Text = "Position: " .. Config.Position
    SaveConfig()
end, 5)

local function CreateSideMenu(name, offsetX)
    local f = Instance.new("Frame", Overlay)
    f.Name = name
    f.Size = UDim2.new(0, 180, 0, 325)
    f.Position = UDim2.new(0, offsetX, 0, 60)
    f.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
    f.Visible = false
    f.Active = true
    f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 15)

    local title = Instance.new("TextLabel", f)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Text = name
    title.TextColor3 = Color3.fromRGB(150, 130, 180)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.BackgroundTransparency = 1

    return f
end

ChecksGUI   = CreateSideMenu("Checks",   -190)
HitpartsGUI = CreateSideMenu("Hitparts", FULL_W + 10)

CreateButton(MainScroll, "Checks", function()
    ChecksGUI.Visible = not ChecksGUI.Visible
end, 6)

CreateButton(MainScroll, "Hitparts", function()
    HitpartsGUI.Visible = not HitpartsGUI.Visible
end, 7)

local function FillSideList(parent, items, configKey, isTable, multiSelect)
    local scroll = Instance.new("ScrollingFrame", parent)
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, #items * 46)

    local ll = Instance.new("UIListLayout", scroll)
    ll.Padding = UDim.new(0, 8)

    for _, item in ipairs(items) do
        local b = Instance.new("TextButton", scroll)
        b.Size = UDim2.new(1, 0, 0, 38)
        b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        b.TextColor3 = Color3.fromRGB(160, 150, 190)
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 13
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)

        local function refresh()
            if multiSelect then
                b.Text = (table.find(Config[configKey], item) and "● " or "o ") .. item
            else
                b.Text = (Config[configKey][item] and "● " or "o ") .. item
            end
        end
        refresh()

        b.MouseButton1Click:Connect(function()
            if multiSelect then
                local exists = table.find(Config[configKey], item)
                if exists then table.remove(Config[configKey], exists)
                else table.insert(Config[configKey], item) end
            else
                Config[configKey][item] = not Config[configKey][item]
            end
            refresh()
            SaveConfig()
        end)
    end
end

FillSideList(ChecksGUI,   {"Wall Check","KO Check","Forcefield Check","Team Check","Friend Check","Vehicle Check"}, "Checks", true, false)
FillSideList(HitpartsGUI, {"Head","HumanoidRootPart","UpperTorso","LowerTorso"}, "SelectedParts", false, true)

RunService.RenderStepped:Connect(function()
    if not Silent then Silent = Drawing.new("Circle") end
    Silent.Visible      = Config.Enabled
    Silent.Radius       = Config.Size
    Silent.Thickness    = Config.Thickness
    Silent.Filled       = Config.Filled
    Silent.Transparency = Config.Transparency
    Silent.Color        = Color3.fromRGB(255, 182, 193)
    if Config.Position == "Crosshair" and Client.Crosshair then
        local abs = Client.Crosshair.AbsolutePosition
        local sz  = Client.Crosshair.AbsoluteSize
        Silent.Position = Vector2.new(abs.X + sz.X / 2, abs.Y + sz.Y / 2 + GuiInset.Y)
    elseif Config.Position == "Center" then
        Silent.Position = Camera.ViewportSize / 2
    else
        Silent.Position = UserInput:GetMouseLocation()
    end
    getgenv().enemy = GetTarget()
end)
