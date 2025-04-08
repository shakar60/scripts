--// i did not make this. - shakar
-- HTTPspy v0.0.1 / OPEN SOURCE
local RevenueGG = loadstring(game:HttpGet("https://raw.githubusercontent.com/LR7n2p/-/refs/heads/main/RevenueGG.txt"))() -- My notification
local NotificationLibrary = loadstring(game:HttpGet("https://pastebin.com/raw/wiPVTwLB"))() -- Notification

RevenueGG:Notification({
Text = "HTTPspy executed!",  Duration = 1, 
Color = Color3.fromRGB(85, 170, 255) })

local startTime = tick()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local NotificationLibrary = loadstring(game:HttpGet("https://pastebin.com/raw/wiPVTwLB"))()

local Themes = {"Dark", "Darker", "Light", "Aqua", "Amethyst", "Rose"}
local SelectedTheme = Themes[math.random(1, #Themes)]

local Window = Fluent:CreateWindow({
Title = "            (  H    T    T    P .   s   p   y  )",
SubTitle = "                 Vᴇʀsɪᴏɴ ₀.₀.₁",
TabWidth = 100,
Size = UDim2.fromOffset(466, 219),
Acrylic = false,
Theme = SelectedTheme,
MinimizeKey = Enum.KeyCode.C
})

-- deletes the folder
task.spawn(function()
    pcall(function()
        delfolder("FluentSettings")
    end)
end)

local Tabs = {
Log = Window:AddTab({ Title = "L0GS", Icon = "square" }),
}

local function getCurrentDate()
return os.date("%Y/%B/%d %I:%M %p")
end

local function Clipboard(text)
    setclipboard(text)
end

local function addLogButton(title, scriptContent, logType)
    Tabs.Log:AddButton({
        Title = title,
        Description = getCurrentDate(),
        Callback = function()
        Clipboard(scriptContent)
        NotificationLibrary:SendNotification("Success", logType .. " copied: " .. scriptContent, 5)
    end
    })
end

local OriginalHttpGet
OriginalHttpGet = hookfunction(game.HttpGet, function(self, url, ...)
    addLogButton(url, url, "HTTP Request")
    return OriginalHttpGet(self, url, ...)
end)

local OriginalHttpPost
OriginalHttpPost = hookfunction(game.HttpPost, function(self, url, ...)
    addLogButton(url, url, "HTTP Request")
    return OriginalHttpPost(self, url, ...)
end)

if syn and syn.request then
    local OriginalSynRequest
    OriginalSynRequest = hookfunction(syn.request, function(data)
        addLogButton(data.Url, data.Url, "HTTPRequest")
        return OriginalSynRequest(data)
    end)
elseif request then
    local OriginalRequest
    OriginalRequest = hookfunction(request, function(data)
        addLogButton(data.Url, data.Url, "HTTPRequest")
        return OriginalRequest(data)
    end)
else
RevenueGG:Notification({
Text = "Exploit not supported",  Duration = 15, 
Color = Color3.fromRGB(85, 170, 255) }) end

local OriginalLoadstring
OriginalLoadstring = hookfunction(loadstring, function(script, ...)
addLogButton("loadstring execution", script, "Executed Script")
return
OriginalLoadstring(script, ...) end)

local OriginalRequire
OriginalRequire = hookfunction(require, function(module)
    local scriptContent = tostring(module) or "Unknown Module"
    addLogButton("require execution", scriptContent, "Executed Script")
    return OriginalRequire(module)
end)

local OriginalPrint
OriginalPrint = hookfunction(print, function(...)
    local args = {...}
    local scriptContent = "print("

    for i, v in ipairs(args) do
    scriptContent = scriptContent .. (type(v) == "string" and '"' .. v .. '"' or tostring(v))
    if i < #args then
    scriptContent = scriptContent .. ", "
     end
end

scriptContent = scriptContent .. ")"
    
    addLogButton("print execution", scriptContent, "Executed Script")
    return OriginalPrint(...)
end)

local OriginalDebugInfo
OriginalDebugInfo = hookfunction(debug.getinfo, function(func, what)
    local info = OriginalDebugInfo(func, what)
    if info and info.source then
        addLogButton("Script Execution", info.source, "Executed Script")
        end
    return
info end)

local extraTab = Window:AddTab({ Title = "", Icon = "plus" })
extraTab:AddButton({ Title = "                                                                          Rejoin", Description = "                                                                                In case", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer) end })

extraTab:AddParagraph({
    Title = "                                            INFORMATION [?]",
    Content = "                            Author of the script : @LightGray2\nOpen Souce httpspy\nNo Afflicted with httpspy v2"
})
extraTab:AddParagraph({
    Title = "                                UI Library by",
    Content = "                                         FLUENT"
})

extraTab:AddButton({
    Title = "                                                                          OG HTTPSpy",
    Description = "                                                                                Original Script",
    Callback = function()
        setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/Blocky69/boblus-scriptz/refs/heads/main/UO-HttpSpy"))()')
RevenueGG:Notification({
    Text = "Notice: This bugs!", 
    Duration = 3
})
    end
})

-- button yes
local Noneless = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Noneless.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local deletegone = playerGui:FindFirstChild("LightGray2")
if deletegone then
    deletegone:Destroy()
end

local rizz = Instance.new("ScreenGui")
rizz.Name = "LightGray2"
rizz.Parent = playerGui

local skibidi = Instance.new("TextButton")
skibidi.Name = "DraggableButton"
skibidi.Size = UDim2.new(0, 138, 0, 50)
skibidi.Position = UDim2.new(0.5, -69, 0.2, 0)
skibidi.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
skibidi.BackgroundTransparency = 0.85
skibidi.Text = "T0GGLE"
skibidi.TextColor3 = Color3.fromRGB(0, 0, 0)
skibidi.Font = Enum.Font.Arcade
skibidi.TextSize = 20
skibidi.Parent = rizz

local corner = Instance.new("UICorner", skibidi)
corner.CornerRadius = UDim.new(1, 0)

local ncci = Instance.new("UIGradient")
ncci.Parent = skibidi
ncci.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
ncci.Rotation = 45

local dragging = false
local dragStart, startPos

skibidi.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
     dragging = true
     dragStart = input.Position
     startPos = Vector2.new(skibidi.AbsolutePosition.X, skibidi.AbsolutePosition.Y)
end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
     local delta = input.Position - dragStart
     skibidi.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    dragging = false
end
end)

-- FUNCTION OF BUTTON
skibidi.MouseButton1Click:Connect(function()
local VirtualInputManager = game:GetService("VirtualInputManager")
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
task.wait()
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
end)

RevenueGG:Notification({
    Text = "HTTPspy script loaded in" .. string.format("%.1f", tick() - startTime) .. " seconds", 
    Duration = 2, 
    Color = Color3.fromRGB(255, 0, 0)
})
task.wait(2)
print("it hooks")
task.wait(0.22)
--// created by LightGray2 //--
-- Open Source

RevenueGG:Notification({
Text = "HTTPspy is made by LightGray2 and Open source!",  Duration = 3, 
Color = Color3.fromRGB(255, 0, 0) })
