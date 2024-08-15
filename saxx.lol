-- Create GUI
local function createGUI()
    local Player = game.Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "saxxGui"
    MainGui.Parent = PlayerGui
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = MainGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Frame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "saxx.lol"
    TitleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.SourceSans
    TitleLabel.TextSize = 24
    TitleLabel.Parent = Frame
    
    local function createToggle(name, position)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0.1, 0)
        ToggleFrame.Position = position
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = Frame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Text = name
        ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
        ToggleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.Font = Enum.Font.SourceSans
        ToggleLabel.TextSize = 18
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0.4, 0, 1, 0)
        ToggleButton.Position = UDim2.new(0.6, 0, 0, 0)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.Text = "Off"
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.TextSize = 18
        ToggleButton.Parent = ToggleFrame
        
        return ToggleButton
    end
    
    local highlightToggle = createToggle("Highlight", UDim2.new(0, 0, 0.1, 0))
    local camlockToggle = createToggle("Camlock", UDim2.new(0, 0, 0.2, 0))
    
    local function createInput(name, position)
        local InputFrame = Instance.new("Frame")
        InputFrame.Size = UDim2.new(1, 0, 0.1, 0)
        InputFrame.Position = position
        InputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        InputFrame.BorderSizePixel = 0
        InputFrame.Parent = Frame
        
        local InputLabel = Instance.new("TextLabel")
        InputLabel.Text = name
        InputLabel.Size = UDim2.new(0.3, 0, 1, 0)
        InputLabel.Position = UDim2.new(0, 0, 0, 0)
        InputLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        InputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        InputLabel.Font = Enum.Font.SourceSans
        InputLabel.TextSize = 18
        InputLabel.Parent = InputFrame
        
        local InputBox = Instance.new("TextBox")
        InputBox.Size = UDim2.new(0.7, 0, 1, 0)
        InputBox.Position = UDim2.new(0.3, 0, 0, 0)
        InputBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        InputBox.Text = ""
        InputBox.Font = Enum.Font.SourceSans
        InputBox.TextSize = 18
        InputBox.Parent = InputFrame
        
        return InputBox
    end
    
    local predictionInput = createInput("Prediction", UDim2.new(0, 0, 0.3, 0))
    local smoothnessInput = createInput("Smoothness", UDim2.new(0, 0, 0.4, 0))
    local shakeInput = createInput("Shake", UDim2.new(0, 0, 0.5, 0))
    
    local function createDropdown(name, position, options)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, 0, 0.1, 0)
        DropdownFrame.Position = position
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.Parent = Frame
        
        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Text = name
        DropdownLabel.Size = UDim2.new(0.3, 0, 1, 0)
        DropdownLabel.Position = UDim2.new(0, 0, 0, 0)
        DropdownLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownLabel.Font = Enum.Font.SourceSans
        DropdownLabel.TextSize = 18
        DropdownLabel.Parent = DropdownFrame
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Size = UDim2.new(0.7, 0, 1, 0)
        DropdownButton.Position = UDim2.new(0.3, 0, 0, 0)
        DropdownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownButton.Text = "Select"
        DropdownButton.Font = Enum.Font.SourceSans
        DropdownButton.TextSize = 18
        DropdownButton.Parent = DropdownFrame
        
        local DropdownList = Instance.new("Frame")
        DropdownList.Size = UDim2.new(1, 0, 0, #options * 30)
        DropdownList.Position = UDim2.new(0, 0, 1, 0)
        DropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        DropdownList.Visible = false
        DropdownList.Parent = DropdownFrame
        
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Position = UDim2.new(0, 0, (i - 1) * 30, 0)
            OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.Text = option
            OptionButton.Font = Enum.Font.SourceSans
            OptionButton.TextSize = 18
            OptionButton.Parent = DropdownList
            
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option
                DropdownList.Visible = false
            end)
        end
        
        DropdownButton.MouseButton1Click:Connect(function()
            DropdownList.Visible = not DropdownList.Visible
        end)
        
        return DropdownButton
    end
    
    local hitPartDropdown = createDropdown("HitPart", UDim2.new(0, 0, 0.6, 0), {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"})
    
    -- Initialize settings
    local settings = {
        highlight = false,
        camlock = false,
        prediction = predictionInput.Text,
        smoothness = smoothnessInput.Text,
        shake = shakeInput.Text,
        hitPart = hitPartDropdown.Text
    }
    
    -- Toggle Functions
    highlightToggle.MouseButton1Click:Connect(function()
        settings.highlight = not settings.highlight
        highlightToggle.Text = settings.highlight and "On" or "Off"
    end)
    
    camlockToggle.MouseButton1Click:Connect(function()
settings.camlock = not settings.camlock
camlockToggle.Text = settings.camlock and “On” or “Off”
end)

predictionInput.FocusLost:Connect(function()
    settings.prediction = predictionInput.Text
end)

smoothnessInput.FocusLost:Connect(function()
    settings.smoothness = smoothnessInput.Text
end)

shakeInput.FocusLost:Connect(function()
    settings.shake = shakeInput.Text
end)

hitPartDropdown.MouseButton1Click:Connect(function()
    settings.hitPart = hitPartDropdown.Text
end)

end

createGUI()
