-- 69% better by shk4k4r6o lol

for Key, Object in pairs(getgc(true)) do
    if type(Object) == "table" then
        setreadonly(Object, false)
        local indexInstance = rawget(Object, "indexInstance")
        if type(indexInstance) == "table" and indexInstance[1] == "kick" then
            setreadonly(indexInstance, false)
            rawset(Object, "Table", {"kick", function() coroutine.yield() end})
            break
        end
    end
end

local Tool = Instance.new("Tool")
Tool.RequiresHandle = false
Tool.Name = "Lock Tool"
Tool.Parent = game.Players.LocalPlayer.Backpack

local player = game.Players.LocalPlayer

local function onCharacterAdded(character)
    local existingTool = character:FindFirstChild(Tool.Name)
    if existingTool then
        existingTool:Destroy()
    end
end

local function connectCharacterAdded()
    player.CharacterAdded:Connect(onCharacterAdded)
end

connectCharacterAdded()

player.CharacterRemoving:Connect(
    function()
        Tool:Destroy()
    end
)

local MainColor = Color3.fromRGB(255, 255, 255);
getgenv().Configurations = {
    Target = {
        Enabled = true,
        Prediction = 0.16326833333333332,
        AutoPrediction = false,
        AimPart = "HumanoidRootPart",
        AutoArmor = false,
        Notify = true,
        AirPartEnabled = true,
        AirPart = "LowerTorso",
        LookAt = false,
        Spectate = false,
        AutoAir = true,
        CameraLock = {
            Enabled = true,
            UseShake = false,
            Shake = 3,
            Smoothness = true,
            SmoothnessAmount = 0.14,
            Style = "Elastic",
            Direction = "InOut"
        },
        HitPart = {
            Part = "HumanoidRootPart",
            ClosestPart = false,
            Mode = "Nearest Part" -- Options: Nearest Point, Part
        },
        FOV = {
            Show = false,
            Size = 110
        },
        Checks = {
            Enabled = true,
            Knocked = true,
            Grabbed = true,
            AntiGroundShots = true
        }
    },
    TriggerBot = {
        Enabled = false,
        Visualize = false,
        Prediction = 0.16326833333333332,
        Range = 50,
        UseDelay = false,
        Delay = 0.05
    },
    Resolver = {
        Enabled = false,
        Method = "Move Direction", -- Options: LookVector, Recalculate, Zero Prediction, Move Direction
        AntiAimViewer = false
    },
    Misc = {
        CSync = {
            Enabled = false,
            VoidSpam = false,
            DestroyCheaters = false,
            Attach = true,
            Type = "Random",
            Visualize = {
                Enabled = true,
                Type = "Dot",
                Color = MainColor,
            },
            Randomize = {
                Value = 20,
            },
            Custom = {
                X = 0,
                Y = 0,
                Z = 0,
            },
            CFrameSpeed = {
              Enabled = false,
              Speed = 1,
            },
            AutoBuy = {
                SelectedFood = "Taco",
                SelectedGun = "LMG",
            }
        },
        TargetStrafe = {
            Enabled = false,
            CSync = true,
            Type = "Randomize",
            Randomization = 3,
            Speed = 10,
            Distance = 5,
            Height = 5,
            BypassDC = false
        },
        Animation = {
            Enabled = false,
            Speed = 1,
            SelectedDance = "Floss"
        }
    },
    Visuals = {
        World = {
            Enabled = false,
            Fog = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                End = 1000,
                Start = 10000
            },
            Ambient = {
                Enabled = false,
                Color = Color3.new(1, 1, 1)
            },
            Brightness = {
                Enabled = false,
                Value = 0
            },
            ClockTime = {
                Enabled = false,
                Value = 24
            },
            WorldExposure = {
                Enabled = false,
                Value = -0.1
            }
        },
        Bullet_Trails = {
            Enabled = false,
            Width = 1.7,
            Duration = 5,
            Fade = false,
            FadeDuration = 5,
            Color = MainColor,
            Texture = "Normal" -- 12781803086
        },
        Bullet_Impacts = {
            Enabled = false,
            Width = 0.25,
            Color = MainColor,
            Duration = 5,
            Fade = false,
            FadeDuration = 5
        },
        Hit_Detection = {
            Enabled = true,
            Notify = true,
            Clone = false,
            HitEffect = true,
            HitEffectType = "Crescent Slash",
            Sound = true,
            HitSound = "NeverLose"
        },
        HighLight = {
            Enabled = true,
            Fill = MainColor,
            OutLine = Color3.fromRGB(255, 255, 255)
        },
        Line = {
            Enabled = true,
            Color = MainColor,
            Thickness = 2
        },
        Dot = {
            Enabled = false,
            Color = MainColor,
            Size = 0.5
        },
        BackTrack = {
            Enabled = false,
            Color = MainColor,
            ApplyTo = "Local Player",
            Duration = 0.1,
            Transparency = 0.5
        },
    }
}
local Notifications = {};
local Utility = {};
local Desync = {}
--
local Script = {
    Locals = {
        Angle = 0,
        Target = nil,
        AimAssistTarget = nil,
        HitPart = nil,
        AimAssistHitPart = nil,
        AimPoint = nil,
        AimAssistAimPoint = nil,
        Position = nil
    },
    Textures = {
        Normal = "rbxassetid://7151778302",
        Fog = "rbxassetid://9150635648"
    },
    World = {
        FogColor = game:GetService("Lighting").FogColor,
        FogStart = game:GetService("Lighting").FogStart,
        FogEnd = game:GetService("Lighting").FogEnd,
        Ambient = game:GetService("Lighting").Ambient,
        Brightness = game:GetService("Lighting").Brightness,
        ClockTime = game:GetService("Lighting").ClockTime,
        ExposureCompensation = game:GetService("Lighting").ExposureCompensation
    },
    HitSounds = {
        Bameware = "rbxassetid://3124331820",
        Bell = "rbxassetid://6534947240",
        Bubble = "rbxassetid://6534947588",
        Pick = "rbxassetid://1347140027",
        Pop = "rbxassetid://198598793",
        Rust = "rbxassetid://1255040462",
        Sans = "rbxassetid://3188795283",
        Fart = "rbxassetid://130833677",
        Big = "rbxassetid://5332005053",
        Vine = "rbxassetid://5332680810",
        Bruh = "rbxassetid://4578740568",
        Skeet = "rbxassetid://5633695679",
        Neverlose = "rbxassetid://6534948092",
        Fatality = "rbxassetid://6534947869",
        Bonk = "rbxassetid://5766898159",
        Minecraft = "rbxassetid://4018616850"
    },
    Guns = {
        "Revolver",
        "Double-Barrel SG",
        "High-Medium Armor",
        "Flamethrower",
        "SMG",
        "RPG",
        "P90",
        "LMG",
        "Key"
    },
    Food = {
        "Pizza",
        "Taco",
        "Chicken",
        "Cranberry",
        "Popcorn",
        "Hamburger",
        "HotDog"
    }
}

local Guns = {
   "Revolver",
   "Double-Barrel SG",
   "High-Medium Armor",
   "Flamethrower",
   "SMG",
   "RPG",
   "P90",
   "LMG",
   "Key" 
}

local Food = {
   "Pizza",
   "Taco",
   "Chicken",
   "Cranberry",
   "Popcorn",
   "Hamburger",
   "HotDog",
 }

--
--
local game_support = {
    { Number = 1, Name = "Da Hood", Argument = real_dh_arg or "UpdateMousePosI", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Siren") and workspace.Ignored.Siren:FindFirstChild("Radius") or nil },
    { Number = 2, Name = "Locker Hood", Argument = "UpdateMousePos", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 3, Name = "Hood Modded", Argument = "MousePos", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 4, Name = "Da Downhill", Argument = "MOUSE", BulletName = "Part", BulletBeamName = "gb", BulletPath = workspace },
    { Number = 5, Name = "Da Bank", Argument = "MOUSE", BulletName = "Part", BulletBeamName = "gb", BulletPath = workspace },
    { Number = 6, Name = "Da Uphill", Argument = "MOUSE", BulletName = "Part", BulletBeamName = "gb", BulletPath = workspace },
    { Number = 7, Name = "Da Strike", Argument = "MOUSE", BulletName = "Part", BulletBeamName = "gb", BulletPath = workspace },
    { Number = 8, Name = "1v1 Hood Aim Trainer", Argument = "UpdateMousePos" },
    { Number = 9, Name = "Hood Aim", Argument = "MOUSE" },
    { Number = 10, Name = "Moon Hood", Argument = "MoonUpdateMousePos" },
    { Number = 11, Name = "OG Da Hood", Argument = "UpdateMousePos", Adonis = true },
    { Number = 12, Name = "Da Hood Macro", Argument = "UpdateMousePos1" },
    { Number = 13, Name = "Da Hood VC", Argument = real_dh_arg or "UpdateMousePosI", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Siren") and workspace.Ignored.Siren:FindFirstChild("Radius") or nil },
    { Number = 15, Name = "Hood Customs", Argument = real_dh_arg or "MousePosUpdate", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 16, Name = "Hood Z", Argument = "UpdateMousePos", BulletName = "bulletray", BulletBeamName = "beam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 17, Name = "Custom FFA", Argument = "UpdateMousePos", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
    { Number = 18, Name = "Yeno Hood", Argument = "UpdateMousePos", BulletName = "BULLET_RAYS", BulletBeamName = "GunBeam", BulletPath = workspace:FindFirstChild("Ignored") or nil },
}

local connections = {}
if not LPH_OBFUSCATED then
    LPH_JIT = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_JIT_ULTRA = function(...) return ... end
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_NO_UPVALUES = function(f) return function(...) return f(...) end end
    LPH_ENCSTR = function(...) return ... end
    LPH_STRENC = function(...) return ... end
    LPH_HOOK_FIX = function(...) return ... end
    LPH_CRASH = function() return print(debug.traceback()) end
end

local wrap = LPH_NO_VIRTUALIZE(function(f)
    coroutine.resume(coroutine.create(f))
end)

local mouse_argument, bullet_beam_name, bullet_name, bullet_path

for _, support in ipairs(game_support) do
    bullet_beam_name = support.BulletBeamName
    bullet_name = support.BulletName
    bullet_path = support.BulletPath
    mouse_argument = support.Argument

    if bullet_name and bullet_beam_name and bullet_path then
        if bullet_path then
            bullet_path = bullet_path
            break
        end
    end
end


local Players           = game:GetService("Players");
local RunService        = game:GetService("RunService");
local UserInputService  = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace         = game:GetService("Workspace");
local TweenService      = game:GetService("TweenService");
local Configurations    = getgenv().Configurations -- you can just do Configurations but i defined it since i dont want that yellow indicator on my roblox lsp
local Debris            = game:GetService('Debris');
local Lighting       = game:GetService("Lighting");

local LocalPlayer       = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Drawing = Drawing.new
local crosshair_position = "Middle";
local clone_chams_tick = tick();
local is_targetting = false;
local old_hrp = nil;
local should_haalfi_destroy = false;
local Target = nil;
local Menu = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hxckerskyy/frost.lol/refs/heads/main/uilib.lua"))()

-- // Crosshair Handler \\ --
local Cursor = loadstring(game:HttpGet('https://pastebin.com/raw/bG7mehvN', true))() do
    getgenv().crosshair.enabled = false
    getgenv().crosshair.color = MainColor
    getgenv().crosshair.mode = "Middle"
end

-- // Trigger Bot FOV \\ --
local TriggerBotFOV = Drawing("Circle")
TriggerBotFOV.Transparency = 1
TriggerBotFOV.Thickness = 1
TriggerBotFOV.Radius = Configurations.TriggerBot.Range
TriggerBotFOV.Filled = false
TriggerBotFOV.Color = Color3.fromRGB(204, 255, 255)
TriggerBotFOV.Visible = false

do -- Notification Library
    local NotificationContainer = Instance.new("ScreenGui", gethui())

    local function UpdateNotifications()
        local i = 0
        for v in next, Notifications do
            if v.Holder then
                Utility:Tween(v.Holder, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0, 75 + (i * 25))})
                i = i + 1
            end
        end
    end

    local function UpdateNotifications2(Item)
        for _, v in pairs(Item) do
            if typeof(v) == "Instance" then
                task.spawn(function()
                    local tween = Utility:Tween(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                    tween.Completed:Connect(function()
                        if v.Name == "Holder" then v:Destroy() end
                    end)
                end)
                if v.ClassName == "TextLabel" then
                    Utility:Tween(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1})
                end
            end
        end
    end

    function Notifications:New(Text, Time, Color)
        Time = Time or 2
        Color = Color or Color3.fromRGB(173, 216, 230)
        Text = Text or "No text provided? "..tostring(math.random())

        local Notification = {}

        local Holder = Instance.new("Frame")
        Holder.Position = UDim2.new(0, -30, 0, 75)
        Holder.Size = UDim2.new(0, 0, 0, 23)
        Holder.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
        Holder.BorderSizePixel = 1
        Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Holder.Parent = NotificationContainer
        Notification.Holder = Holder

        local Background = Instance.new("Frame")
        Background.Size = UDim2.new(1, -4, 1, -4)
        Background.Position = UDim2.new(0, 2, 0, 2)
        Background.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        Background.BorderSizePixel = 1
        Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Background.Parent = Holder
        Notification.Background = Background

        local AccentBar = Instance.new("Frame")
        AccentBar.Size = UDim2.new(0, 1, 1, 0)
        AccentBar.BackgroundColor3 = Color
        AccentBar.Parent = Background
        Notification.AccentBar = AccentBar

        local AccentBar2 = Instance.new("Frame")
        AccentBar2.Size = UDim2.new(0, 0, 0, 1)
        AccentBar2.Position = UDim2.new(0, 0, 0, 15)
        AccentBar2.BackgroundColor3 = Color
        AccentBar2.Parent = Background
        Notification.AccentBar2 = AccentBar2

        local NotifText = Instance.new("TextLabel")
        NotifText.TextXAlignment = Enum.TextXAlignment.Left
        NotifText.Position = UDim2.new(0, 3, 0, 0)
        NotifText.Size = UDim2.new(1, 0, 1, 0)
        NotifText.Font = Enum.Font.Ubuntu
        NotifText.TextColor3 = Color3.new(1, 1, 1)
        NotifText.BackgroundTransparency = 1
        NotifText.TextSize = 12
        NotifText.Text = Text
        NotifText.Parent = Background
        Notification.NotifText = NotifText

        Holder.Size = UDim2.new(0, NotifText.TextBounds.X + 10, 0, 19)
        AccentBar2.Size = UDim2.new(0, 1, 0, 1)

        Notifications[Notification] = true

        task.spawn(function()
            Holder.Size = UDim2.new(0, NotifText.TextBounds.X + 10, 0, 19)
            UpdateNotifications()
            AccentBar2:TweenSize(UDim2.new(0, Background.AbsoluteSize.X - 1, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, Time, false)
            task.wait(Time)
            UpdateNotifications2(Notification)
            task.wait(1.2)
            Notifications[Notification] = nil
            UpdateNotifications()
        end)
    end

    function Utility:Tween(...)
        local NewTween = game:GetService("TweenService"):Create(...)
        NewTween:Play()
        return NewTween
    end
end
--
-- // math
local custom_math = {}; do
   custom_math.get_auto_prediction = LPH_NO_VIRTUALIZE(function()
        local PingStats = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local Value = tostring(PingStats)
        local PingValue = Value:split(" ")
        local PingNumber = tonumber(PingValue[1])
        
        return tonumber(PingNumber / 1000 + 0.037)
        end)
   
   custom_math.random_vector3 = LPH_NO_VIRTUALIZE(function(randomization)
		return Vector3.new(math.random(-randomization, randomization), math.random(-randomization, randomization), math.random(-randomization, randomization));
	end);
	
   custom_math.recalculate_velocity = LPH_NO_VIRTUALIZE(function(player)
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local initialPosition = rootPart.Position
        local initialTime = tick()

        task.wait()

        local finalPosition = rootPart.Position
        local finalTime = tick()

        local distanceTraveled = finalPosition - initialPosition
        local timeInterval = finalTime - initialTime
        return distanceTraveled / timeInterval
    end)
end

-- // utility
local utility = {}; do
   utility.world_to_screen = LPH_NO_VIRTUALIZE(function(position)
		local position, on_screen = Camera:WorldToViewportPoint(position);

		return {position = Vector2.new(position.X, position.Y), on_screen = on_screen};
	end);
	
	utility.has_character = LPH_NO_VIRTUALIZE(function(player)
		return (player and player.Character and player.Character:FindFirstChild("Humanoid")) and true or false;
	end);
	
	utility.new_connection = function(type, callback) --// by all matters do NOT no virtualize this
		local connection = type:Connect(callback);

		table.insert(connections, connection);

		return connection;
	end;

	utility.create_connection = function(signal_name) --// by all matters do NOT no virtualize this
		local connection = signal.new(signal_name);
		return connection;
	end;
	
	utility.drawing_new = function(type, properties)
		local drawing_object = Drawing(type);

		for property, value in properties do
			drawing_object[property] = value;
		end;

		return drawing_object;
	end;

	utility.instance_new = function(type, properties)
		local instance = Instance.new(type);

		for property, value in properties do
			instance[property] = value;
		end;

		return instance;
	end;
	
	utility.clone_character = function(player, transparency, color, material, delete_hrp)
		local delete_hrp = delete_hrp or true;

		player.Character.Archivable = true;
		local new_character = player.Character:Clone();
		new_character.Parent = workspace;
		player.Character.Archivable = false;
		
		local parts = new_character:GetChildren();
		
		for i = 1, #parts do
			local part = parts[i];
				
			if (part.ClassName == "MeshPart") then
				part.Anchored = true;
				part.CanCollide = false;
				part.Color = color;
				part.Material = Enum.Material[material];
				part.Transparency = transparency;
			else
				if part.Name ~= "HumanoidRootPart" and delete_hrp then
					part:Destroy();
				end;
			end;
			
			if part.Name == "Head" then
				local decal = part:FindFirstChild("face");
				
				if decal then decal:Destroy() end;
			end;
		end;

		return new_character;
	end;

	utility.create_beam = LPH_NO_VIRTUALIZE(function(from, to, color_1, color_2, duration, fade_enabled, fade_duration)
		local tween;
		local total_time = 0;

		local main_part = utility.instance_new("Part", {
			Parent = workspace,
			Size = Vector3.new(0, 0, 0),
			Massless = true,
			Transparency = 1,
			CanCollide = false,
			Position = from,
			Anchored = true
		});

		local part0 = utility.instance_new("Part", {
			Parent = main_part,
			Size = Vector3.new(0, 0, 0),
			Massless = true,
			Transparency = 1,
			CanCollide = false,
			Position = from,
			Anchored = true
		});

		local part1 = utility.instance_new("Part", {
			Parent = main_part,
			Size = Vector3.new(0, 0, 0),
			Massless = true,
			Transparency = 1,
			CanCollide = false,
			Position = to,
			Anchored = true
		});

		local attachment0 = utility.instance_new("Attachment", {
			Parent = part0
		});

		local attachment1 = utility.instance_new("Attachment", {
			Parent = part1
		});

		local beam = utility.instance_new("Beam", {
			Texture = "rbxassetid://446111271",
			TextureMode = Enum.TextureMode.Wrap,
			TextureLength = 10,
			LightEmission = 1,
			LightInfluence = 1,
			FaceCamera = true,
			ZOffset = -1,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, color_1),
				ColorSequenceKeypoint.new(1, color_2),
			}),
			Attachment0 = attachment0,
			Attachment1 = attachment1,
			Enabled = true,
			Parent = main_part
		});


		if fade_enabled then
			tween = utility.new_connection(RunService.Heartbeat, function(delta_time) --// credits to xander
				total_time += delta_time;
				beam.Transparency = NumberSequence.new(TweenService:GetValue((total_time / fade_duration), Enum.EasingStyle.Quad, Enum.EasingDirection.In));
			end)
		end;

		task.delay(duration, function()
			main_part:Destroy();

			if (tween) then
				tween:Disconnect();
			end;
		end);
	end);

	utility.create_impact = function(color, size, fade_enabled, fade_duration, duration, position)
		local impact = utility.instance_new("Part", {
			CanCollide = false;
			Material = Enum.Material.Neon;
			Size = Vector3.new(size, size, size);
			Color = color;
			Position = position;
			Anchored = true;
			Parent = workspace
		});

		local outline = utility.instance_new("SelectionBox", { --// credits to xander
			LineThickness = 0.01;
			Color3 = color;
			SurfaceTransparency = 1;
			Adornee = impact;
			Visible = true;
			Parent = impact
		});

		if (fade_enabled) then
			local tween_info = TweenInfo.new(duration);
			local tween = TweenService:Create(impact, tween_info, {Transparency = 1});
			local tween_outline = TweenService:Create(outline, tween_info, {Transparency = 1});

			tween:Play();
			tween_outline:Play();
		end;

		task.delay(duration, function()
			impact:Destroy()		
		end);
	end;
end

--// hit effects
local hit_effects = {}; do
hit_effects.slash = function(position)
	local part = utility.instance_new("Part", {
		Position = position,
		Anchored = true,
		Transparency = 1,
		CanCollide = false,
		Parent = workspace
	})

	local particleEmitters = {
		{ -- Crescents
			Name = "Crescents",
			Lifetime = NumberRange.new(0.19, 0.38),
			SpreadAngle = Vector2.new(-360, 360),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1932907, 0),
				NumberSequenceKeypoint.new(0.778754, 0),
				NumberSequenceKeypoint.new(1, 1)
			}),
			LightEmission = 10,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, MainColor),
				ColorSequenceKeypoint.new(0.3160622, MainColor),
				ColorSequenceKeypoint.new(0.5146805, MainColor),
				ColorSequenceKeypoint.new(1, MainColor)
			}),
			VelocitySpread = -360,
			Speed = NumberRange.new(0.0826858, 0.0826858),
			Brightness = 4,
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616),
				NumberSequenceKeypoint.new(1, 11.477972, 1.860431)
			}),
			ZOffset = 0.4542207,
			Rate = 50,
			Texture = "rbxassetid://12509373457",
			Rotation = NumberRange.new(-360, 360),
			Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		}
	}

	for _, emitterProperties in ipairs(particleEmitters) do
		local emitter = utility.instance_new("ParticleEmitter", emitterProperties)
		emitter.Parent = part
		emitter:Emit()
	end

	task.delay(1, function()
		part:Destroy()
	end)
end

hit_effects.cum = function(position)
    local part = utility.instance_new("Part", {
        Position = position,
        Anchored = true,
        Transparency = 1,
        CanCollide = false,
        Parent = workspace
    })

    local attachment = utility.instance_new("Attachment", {
        Parent = part
    })

    local foam = utility.instance_new("ParticleEmitter", {
        Name = "Foam",
        LightInfluence = 0.5,
        Lifetime = NumberRange.new(1, 1),
        SpreadAngle = Vector2.new(360, -360),
        VelocitySpread = 360,
        Squash = NumberSequence.new(1),
        Speed = NumberRange.new(20, 20),
        Brightness = 2.5,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.1016692, 0.6508875, 0.6508875),
            NumberSequenceKeypoint.new(0.6494689, 1.4201183, 0.4127519),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Enabled = false,
        Acceleration = Vector3.new(0, -66.04029846191406, 0),
        Rate = 100,
        Texture = "rbxassetid://8297030850",
        Rotation = NumberRange.new(-90, -90),
        Orientation = Enum.ParticleOrientation.VelocityParallel,
        Parent = attachment
    })

    foam:Emit()

    task.delay(1, function()
        part:Destroy()
    end)
end

hit_effects.atomic_slash = function(position)
	local part = utility.instance_new("Part", {
		Position = position,
		Anchored = true,
		Transparency = 1,
		CanCollide = false,
		Parent = workspace
	})

	local particleEmitters = {
		{ -- Crescents
			Name = "Crescents",
			Lifetime = NumberRange.new(0.19, 0.38),
			SpreadAngle = Vector2.new(-360, 360),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1932907, 0),
				NumberSequenceKeypoint.new(0.778754, 0),
				NumberSequenceKeypoint.new(1, 1)
			}),
			LightEmission = 10,
			Color = ColorSequence.new(Color3.fromRGB(160, 96, 255)),
			VelocitySpread = -360,
			Speed = NumberRange.new(0.0826858, 0.0826858),
			Brightness = 4,
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616),
				NumberSequenceKeypoint.new(1, 11.477972, 1.860431)
			}),
			ZOffset = 0.4542207,
			Rate = 50,
			Texture = "rbxassetid://12509373457",
			Rotation = NumberRange.new(-360, 360),
			Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		},
		{ -- Glow
			Name = "Glow",
			Lifetime = NumberRange.new(0.16, 0.16),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1421725, 0.6182796),
				NumberSequenceKeypoint.new(1, 1)
			}),
			Color = ColorSequence.new(Color3.fromRGB(173, 82, 252)),
			Speed = NumberRange.new(0, 0),
			Brightness = 5,
			Size = NumberSequence.new(9.1873131, 16.5032349),
			ZOffset = -0.0565939,
			Rate = 50,
			Texture = "rbxassetid://8708637750"
		},
		{ -- Effect
			Name = "Effect",
			Lifetime = NumberRange.new(0.4, 0.7),
			FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
			SpreadAngle = Vector2.new(360, -360),
			LockedToPart = true,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1070999, 0.19375),
				NumberSequenceKeypoint.new(0.7761194, 0.88125),
				NumberSequenceKeypoint.new(1, 1)
			}),
			LightEmission = 1,
			Color = ColorSequence.new(Color3.fromRGB(173, 82, 252)),
			Drag = 1,
			VelocitySpread = 360,
			Speed = NumberRange.new(0.0036749, 0.0036749),
			Brightness = 2.0999999,
			Size = NumberSequence.new(6.9680691, 9.9213123),
			ZOffset = 0.4777403,
			Rate = 50,
			Texture = "rbxassetid://9484012464",
			Rotation = NumberRange.new(50, 50),
			Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
			FlipbookMode = Enum.ParticleFlipbookMode.OneShot
		},
		{ -- Gradient1
			Name = "Gradient1",
			Lifetime = NumberRange.new(0.3, 0.3),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.15, 0.3),
				NumberSequenceKeypoint.new(1, 1)
			}),
			Color = ColorSequence.new(Color3.fromRGB(173, 82, 252)),
			Speed = NumberRange.new(0, 0),
			Brightness = 6,
			Size = NumberSequence.new(0, 11.6261358),
			ZOffset = 0.9187313,
			Rate = 50,
			Texture = "rbxassetid://8196169974"
		},
		{ -- Shards
			Name = "Shards",
			Lifetime = NumberRange.new(0.19, 0.7),
			SpreadAngle = Vector2.new(-90, 90),
			Color = ColorSequence.new(Color3.fromRGB(179, 145, 253)),
			Drag = 10,
			VelocitySpread = -90,
			Squash = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5705521, 0.4125001),
				NumberSequenceKeypoint.new(1, -0.9375)
			}),
			Speed = NumberRange.new(97.7530136, 146.9970093),
			Brightness = 4,
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118),
				NumberSequenceKeypoint.new(1, 0)
			}),
			Acceleration = Vector3.new(0, -56.961341857910156, 0),
			ZOffset = 0.5705321,
			Rate = 50,
			Texture = "rbxassetid://8030734851",
			Rotation = NumberRange.new(90, 90),
			Orientation = Enum.ParticleOrientation.VelocityParallel
		}
	}

	for _, emitterProperties in ipairs(particleEmitters) do
		local emitter = utility.instance_new("ParticleEmitter", emitterProperties)
		emitter.Parent = part
		emitter:Emit()
	end

	task.delay(1, function()
		part:Destroy()
	end)
end

hit_effects.cosmic_explosion = function(position)
	local part = utility.instance_new("Part", {
		Position = position,
		Anchored = true,
		Transparency = 1,
		CanCollide = false,
		Parent = workspace
	})

	local particleEmitters = {
		{ -- Glow
			Name = "Glow",
			Lifetime = NumberRange.new(0.16, 0.16),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)}),
			Color = ColorSequence.new(Color3.fromRGB(173, 82, 252)),
			Speed = NumberRange.new(0, 0),
			Brightness = 5,
			Size = NumberSequence.new(9.1873131, 16.5032349),
			ZOffset = -0.0565939,
			Rate = 50,
			Texture = "rbxassetid://8708637750"
		},
		{ -- Effect
			Name = "Effect",
			Lifetime = NumberRange.new(0.4, 0.7),
			FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
			SpreadAngle = Vector2.new(360, -360),
			LockedToPart = true,
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)}),
			LightEmission = 1,
			Color = ColorSequence.new(Color3.fromRGB(173, 82, 252)),
			Drag = 1,
			VelocitySpread = 360,
			Speed = NumberRange.new(0.0036749, 0.0036749),
			Brightness = 2.0999999,
			Size = NumberSequence.new(6.9680691, 9.9213123),
			ZOffset = 0.4777403,
			Rate = 50,
			Texture = "rbxassetid://9484012464",
			RotSpeed = NumberRange.new(-150, -150),
			FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
			Rotation = NumberRange.new(50, 50),
			Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		},
		{ -- Gradient1
			Name = "Gradient1",
			Lifetime = NumberRange.new(0.3, 0.3),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)}),
			Color = ColorSequence.new(Color3.fromRGB(173, 82, 252)),
			Speed = NumberRange.new(0, 0),
			Brightness = 6,
			Size = NumberSequence.new(0, 11.6261358),
			ZOffset = 0.9187313,
			Rate = 50,
			Texture = "rbxassetid://8196169974"
		},
		{ -- Shards
			Name = "Shards",
			Lifetime = NumberRange.new(0.19, 0.7),
			SpreadAngle = Vector2.new(-90, 90),
			Color = ColorSequence.new(Color3.fromRGB(173, 82, 252)),
			Drag = 10,
			VelocitySpread = -90,
			Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)}),
			Speed = NumberRange.new(97.7530136, 146.9970093),
			Brightness = 4,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)}),
			Enabled = false,
			Acceleration = Vector3.new(0, -56.961341857910156, 0),
			ZOffset = 0.5705321,
			Rate = 50,
			Texture = "rbxassetid://8030734851",
			Rotation = NumberRange.new(90, 90),
			Orientation = Enum.ParticleOrientation.VelocityParallel
		},
		{ -- Crescents
			Name = "Crescents",
			Lifetime = NumberRange.new(0.19, 0.38),
			SpreadAngle = Vector2.new(-360, 360),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)}),
			LightEmission = 10,
			Color = ColorSequence.new(Color3.fromRGB(160, 96, 255)),
			VelocitySpread = -360,
			Speed = NumberRange.new(0.0826858, 0.0826858),
			Brightness = 4,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)}),
			ZOffset = 0.4542207,
			Rate = 50,
			Texture = "rbxassetid://12509373457",
			Rotation = NumberRange.new(-360, 360),
			Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		},
		{ -- ParticleEmitter2
			Name = "ParticleEmitter2",
			FlipbookFramerate = NumberRange.new(20, 20),
			Lifetime = NumberRange.new(0.19, 0.38),
			FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
			SpreadAngle = Vector2.new(360, 360),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.209842, 0.5), NumberSequenceKeypoint.new(0.503842, 0.263333), NumberSequenceKeypoint.new(0.799842, 0.5), NumberSequenceKeypoint.new(1, 1)}),
			LightEmission = 1,
			Color = ColorSequence.new(Color3.fromRGB(173, 82, 252)),
			VelocitySpread = 360,
			Speed = NumberRange.new(0.0161231, 0.0161231),
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 4.3125), NumberSequenceKeypoint.new(0.3985056, 7.9375), NumberSequenceKeypoint.new(1, 10)}),
			ZOffset = 0.15,
			Rate = 100,
			Texture = "http://www.roblox.com/asset/?id=12394566430",
			FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
			Rotation = NumberRange.new(39, 999),
			Orientation = Enum.ParticleOrientation.VelocityParallel
		}
	}

	for _, emitterProperties in ipairs(particleEmitters) do
		local emitter = utility.instance_new("ParticleEmitter", emitterProperties)
		emitter.Parent = part
		emitter:Emit()
	end

	task.delay(1, function()
		part:Destroy()
	end)
end

hit_effects.crescent_slash = function(position)
	local part = utility.instance_new("Part", {
		Position = position,
		Anchored = true,
		Transparency = 1,
		CanCollide = false,
		Parent = workspace
	})

	local particleEmitters = {
		{ -- Glow
			Name = "Glow",
			Lifetime = NumberRange.new(0.16, 0.16),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)}),
			Color = ColorSequence.new(Color3.fromRGB(91, 177, 252)),
			Speed = NumberRange.new(0, 0),
			Brightness = 5,
			Size = NumberSequence.new(9.1873131, 16.5032349),
			Enabled = false,
			ZOffset = -0.0565939,
			Rate = 50,
			Texture = "rbxassetid://8708637750"
		},
		{ -- Gradient1
			Name = "Gradient1",
			Lifetime = NumberRange.new(0.3, 0.3),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)}),
			Color = ColorSequence.new(Color3.fromRGB(115, 201, 255)),
			Speed = NumberRange.new(0, 0),
			Brightness = 6,
			Size = NumberSequence.new(0, 11.6261358),
			Enabled = false,
			ZOffset = 0.9187313,
			Rate = 50,
			Texture = "rbxassetid://8196169974"
		},
		{ -- Shards
			Name = "Shards",
			Lifetime = NumberRange.new(0.19, 0.7),
			SpreadAngle = Vector2.new(-90, 90),
			Color = ColorSequence.new(Color3.fromRGB(108, 184, 255)),
			Drag = 10,
			VelocitySpread = -90,
			Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)}),
			Speed = NumberRange.new(97.7530136, 146.9970093),
			Brightness = 4,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)}),
			Enabled = false,
			Acceleration = Vector3.new(0, -56.961341857910156, 0),
			ZOffset = 0.5705321,
			Rate = 50,
			Texture = "rbxassetid://8030734851",
			Rotation = NumberRange.new(90, 90),
			Orientation = Enum.ParticleOrientation.VelocityParallel
		},
		{ -- ShardsDark
			Name = "ShardsDark",
			Lifetime = NumberRange.new(0.19, 0.35),
			SpreadAngle = Vector2.new(-90, 90),
			Color = ColorSequence.new(Color3.fromRGB(108, 184, 255)),
			Drag = 10,
			VelocitySpread = -90,
			Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)}),
			Speed = NumberRange.new(97.7530136, 146.9970093),
			Brightness = 4,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.290774, 0.6734411, 0.1534118), NumberSequenceKeypoint.new(1, 0)}),
			Enabled = false,
			ZOffset = 0.5705321,
			Rate = 50,
			Texture = "rbxassetid://8030734851",
			Rotation = NumberRange.new(90, 90),
			Orientation = Enum.ParticleOrientation.VelocityParallel
		},
		{ -- Specs
			Name = "Specs",
			Lifetime = NumberRange.new(0.33, 1.4),
			SpreadAngle = Vector2.new(360, -1000),
			Color = ColorSequence.new(Color3.fromRGB(98, 174, 255)),
			Drag = 10,
			VelocitySpread = 360,
			Speed = NumberRange.new(36.7492523, 146.9970093),
			Brightness = 7,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.200774, 2.0311937, 0.4363973), NumberSequenceKeypoint.new(1, 0)}),
			Enabled = false,
			Acceleration = Vector3.new(0, 36.74925231933594, 0),
			Rate = 50,
			Texture = "rbxassetid://8030760338",
			EmissionDirection = Enum.NormalId.Right
		},
		{ -- Specs1
			Name = "Specs1",
			Lifetime = NumberRange.new(0.33, 1.75),
			SpreadAngle = Vector2.new(90, -90),
			Color = ColorSequence.new(Color3.fromRGB(106, 171, 255)),
			Drag = 9,
			VelocitySpread = 90,
			Speed = NumberRange.new(42.2616425, 73.4985046),
			Brightness = 6,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.210774, 0.3978962, 0.1855686), NumberSequenceKeypoint.new(1, 0)}),
			Enabled = false,
			Acceleration = Vector3.new(0, -20.21208953857422, 0),
			ZOffset = 0.5144895,
			Rate = 50,
			Texture = "rbxassetid://8030760338"
		},
		{ -- Specs2
			Name = "Specs2",
			Lifetime = NumberRange.new(0.19, 1.2),
			SpreadAngle = Vector2.new(360, -1000),
			Color = ColorSequence.new(Color3.fromRGB(98, 174, 255)),
			Drag = 10,
			VelocitySpread = 360,
			Speed = NumberRange.new(36.7492523, 146.9970093),
			Brightness = 7,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.200774, 2.0311937, 0.4363973), NumberSequenceKeypoint.new(1, 0)}),
			Enabled = false,
			Acceleration = Vector3.new(0, 36.74925231933594, 0),
			Rate = 50,
			Texture = "rbxassetid://8030760338",
			EmissionDirection = Enum.NormalId.Right
		},
		{ -- Specs21
			Name = "Specs21",
			Lifetime = NumberRange.new(0.19, 1.35),
			SpreadAngle = Vector2.new(90, -90),
			Color = ColorSequence.new(Color3.fromRGB(106, 171, 255)),
			Drag = 12,
			VelocitySpread = 90,
			Speed = NumberRange.new(42.2616425, 73.4985046),
			Brightness = 6,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.216774, 0.5721694, 0.1855686), NumberSequenceKeypoint.new(1, 0)}),
			Enabled = false,
			Acceleration = Vector3.new(0, -20.21208953857422, 0),
			ZOffset = 0.5144895,
			Rate = 50,
			Texture = "rbxassetid://8030760338"
		},
		{ -- Crescents
			Name = "Crescents",
			Lifetime = NumberRange.new(0.19, 0.38),
			SpreadAngle = Vector2.new(-360, 360),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1932907, 0),
				NumberSequenceKeypoint.new(0.778754, 0),
				NumberSequenceKeypoint.new(1, 1)
			}),
			LightEmission = 1,
			Color = ColorSequence.new(Color3.fromRGB(92, 161, 252)),
			VelocitySpread = -360,
			Speed = NumberRange.new(0.0826858, 0.0826858),
			Brightness = 20,
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616),
				NumberSequenceKeypoint.new(1, 11.477972, 1.860431)
			}),
			ZOffset = 0.4542207,
			Rate = 50,
			Texture = "rbxassetid://12509373457",
			RotSpeed = NumberRange.new(800, 1000),
			Rotation = NumberRange.new(-360, 360),
			Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		},
		{ -- Effect
			Name = "Effect",
			Lifetime = NumberRange.new(0.4, 0.7),
			FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
			SpreadAngle = Vector2.new(360, -360),
			LockedToPart = true,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1070999, 0.19375),
				NumberSequenceKeypoint.new(0.7761194, 0.88125),
				NumberSequenceKeypoint.new(1, 1)
			}),
			LightEmission = 1,
			Color = ColorSequence.new(Color3.fromRGB(92, 161, 252)),
			Drag = 1,
			VelocitySpread = 360,
			Speed = NumberRange.new(0.0036749, 0.0036749),
			Brightness = 2.0999999,
			Size = NumberSequence.new(6.9680691, 9.9213123),
			ZOffset = 0.4777403,
			Rate = 50,
			Texture = "rbxassetid://9484012464",
			RotSpeed = NumberRange.new(-150, -150),
			Rotation = NumberRange.new(50, 50),
			Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		},
		{ -- out_Specs
			Name = "out_Specs",
			Lifetime = NumberRange.new(0.19, 1),
			SpreadAngle = Vector2.new(44, -1000),
			Color = ColorSequence.new(Color3.fromRGB(98, 174, 255)),
			Drag = 10,
			VelocitySpread = 44,
			Speed = NumberRange.new(36.7492523, 146.9970093),
			Brightness = 7,
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.244774, 0.5469525, 0.1433053),
				NumberSequenceKeypoint.new(1, 0)
			}),
			Acceleration = Vector3.new(0, -3.215559720993042, 0),
			Rate = 50,
			Texture = "rbxassetid://8030760338",
			EmissionDirection = Enum.NormalId.Right
		},
		{ -- large_shard
			Name = "large_shard",
			Lifetime = NumberRange.new(0.19, 0.28),
			SpreadAngle = Vector2.new(-90, 90),
			Color = ColorSequence.new(Color3.fromRGB(108, 184, 255)),
			Drag = 10,
			VelocitySpread = -90,
			Squash = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5705521, 0.4125001),
				NumberSequenceKeypoint.new(1, -0.9375)
			}),
			Speed = NumberRange.new(97.7530136, 146.9970093),
			Brightness = 4,
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.260774, 3.515605, 0.1534118),
				NumberSequenceKeypoint.new(1, 0)
			}),
			ZOffset = 0.5705321,
			Rate = 50,
			Texture = "rbxassetid://8030734851",
			Rotation = NumberRange.new(90, 90),
			Orientation = Enum.ParticleOrientation.VelocityParallel
		},
		{ -- ddddddddddddddddddd
			Name = "ddddddddddddddddddd",
			Lifetime = NumberRange.new(0.19, 0.37),
			SpreadAngle = Vector2.new(90, -90),
			LockedToPart = true,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.6429392, 0),
				NumberSequenceKeypoint.new(1, 0)
			}),
			LightEmission = 1,
			Color = ColorSequence.new(Color3.fromRGB(90, 184, 255), Color3.fromRGB(165, 251, 255)),
			Drag = 6,
			TimeScale = 0.7,
			VelocitySpread = 90,
			Speed = NumberRange.new(81.5833435, 110.2477646),
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.410774, 0.6711507, 0.3356177),
				NumberSequenceKeypoint.new(1, 0)
			}),
			Enabled = false,
			Acceleration = Vector3.new(0, -81.58334350585938, 0),
			ZOffset = 0.8345273,
			Rate = 50,
			Texture = "rbxassetid://1053546634",
			RotSpeed = NumberRange.new(-444, 166),
			Rotation = NumberRange.new(-360, 360)
		},
	}

	local attachment = Instance.new("Attachment")
	attachment.Name = "Attachment"
	attachment.Parent = part

	for _, emitterSettings in ipairs(particleEmitters) do
		local emitter = Instance.new("ParticleEmitter")
		for key, value in pairs(emitterSettings) do
			emitter[key] = value
		end
		emitter.Parent = attachment
	end

	local emitters = part:GetChildren()
	for _, emitter in ipairs(emitters) do
		if emitter:IsA("ParticleEmitter") then
			emitter:Emit()
		end
	end

	task.delay(1, function()
		part:Destroy()
	end)
end



	hit_effects.confetti = function(position) --// credits to xander
		local part = utility.instance_new("Part", {
			Position = position,
			Anchored = true,
			Transparency = 1,
			CanCollide = false,
			Parent = workspace
		});

		for i = 1, 5 do
			local particle1 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,1,0.886275)),ColorSequenceKeypoint.new(1,Color3.new(0,1,0.886275))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=241685484";
				Parent = part
			});
			local particle2 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0.0980392,1)),ColorSequenceKeypoint.new(1,Color3.new(0,0,1))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=241685484]";
				Parent = part
			});
			local particle3 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.901961,1,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0.933333,0))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=24168548";
				Parent = part
			});
			local particle4 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.180392,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0.180392,1,0))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=241685484";
				Parent = part
			});
			local particle5 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=241685484";
				Parent = part
			});	
		end;

		local objects = part:GetChildren();

		for i = 1, #objects do
			local object = objects[i];

			if (object.ClassName ~= "ParticleEmitter") then continue end;

			object:Emit(1);
		end;

		task.delay(3, function()
			part:Destroy();
		end);
	end;
	
	hit_effects.bubble = function(position, color) --// credits to xander once again
		local part = utility.instance_new("Part", {
			Position = position,
			Anchored = true,
			Transparency = 1,
			CanCollide = false,
			Parent = workspace
		});
        
        local particle1 = utility.instance_new("ParticleEmitter", {
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)};
            Lifetime = NumberRange.new(0.5,0.5);
            LightEmission = 1;
            LockedToPart = true;
            Orientation = Enum.ParticleOrientation.VelocityPerpendicular;
            Rate = 0;
            Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,10,0)};
            Speed = NumberRange.new(1.5,1.5);
            Texture = "rbxassetid://1084991215";
            Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0996047,0,0),NumberSequenceKeypoint.new(0.602372,0,0),NumberSequenceKeypoint.new(1,1,0)};
            ZOffset = 1;
            Parent = part
        });
        local particle2 = utility.instance_new("ParticleEmitter", {
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)};
            Lifetime = NumberRange.new(0.5,0.5);
            LightEmission = 1;
            LockedToPart = true;
            Rate = 0;
            Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,10,0)};
            Speed = NumberRange.new(0,0);
            Texture = "rbxassetid://1084991215";
            Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0996047,0,0),NumberSequenceKeypoint.new(0.601581,0,0),NumberSequenceKeypoint.new(1,1,0)};
            ZOffset = 1;
            Parent = part
        });
        local particle3 = utility.instance_new("ParticleEmitter", {
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))};
            Lifetime = NumberRange.new(0.2,0.5);
            LockedToPart = true;
            Orientation = Enum.ParticleOrientation.VelocityParallel;
            Rate = 0;
            Rotation = NumberRange.new(-90,90);
            Size = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,8.5,1.5)};
            Speed = NumberRange.new(0.1,0.1);
            SpreadAngle = Vector2.new(180,180);
            Texture = "http://www.roblox.com/asset/?id=6820680001";
            Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.200791,0,0),NumberSequenceKeypoint.new(0.699605,0,0),NumberSequenceKeypoint.new(1,1,0)};
            ZOffset = 1.5;
            Parent = part
        });

		particle1:Emit(1);
		particle2:Emit(1);
        particle3:Emit(1);

		task.delay(1, function()
			part:Destroy();
		end);
	end;
end;

-- // combat
local combat = {}; do
    combat.get_closest_part = LPH_NO_VIRTUALIZE(function(Character)
        local closestPart, closestDistance = nil, math.huge

        if Character then
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local position, onScreen = Workspace.CurrentCamera:WorldToScreenPoint(part.Position)

                    if onScreen then
                        local distance = (Vector2.new(position.X, position.Y) - mid).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPart = part
                        end
                    end
                end
            end
        end

        return closestPart
    end)

    combat.get_closest_point = LPH_NO_VIRTUALIZE(function(part)
        local mouseRay = Mouse.UnitRay
        local adjustedRay = mouseRay.Origin + (mouseRay.Direction * (part.Position - mouseRay.Origin).Magnitude)

        local point = (adjustedRay.Y >= (part.Position - part.Size / 2).Y and adjustedRay.Y <= (part.Position + part.Size / 2).Y) 
            and (part.Position + Vector3.new(0, adjustedRay.Y - part.Position.Y, 0)) 
            or part.Position

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Whitelist
        params.FilterDescendantsInstances = {part}

        local ray = Workspace:Raycast(adjustedRay, (point - adjustedRay), params)

        return ray and ray.Position or Mouse.Hit.Position
    end)

combat.get_closest_player = LPH_NO_VIRTUALIZE(function(radius)
    local closestDistance, closestPlayer = radius

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local character = player.Character
        local rootPart = character and character:FindFirstChild('HumanoidRootPart')

        if not rootPart then continue end

        local rootPosition = utility.world_to_screen(rootPart.Position)
        if not rootPosition.on_screen then continue end

        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local magnitude = (screenCenter - rootPosition.position).Magnitude

        if magnitude > closestDistance then continue end

        closestDistance = magnitude
        closestPlayer = player
    end

    return closestPlayer
end)

    combat.get_closest_triggerbot_player = LPH_NO_VIRTUALIZE(function()
        local minDistance = Configurations.TriggerBot.Range+15
        local mousePos = Camera.ViewportSize * 0.5
        local closestPlayer = nil

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    
                    if onScreen then
                        local screenPosVec2 = Vector2.new(screenPos.X, screenPos.Y)
                        local distance = (screenPosVec2 - mousePos).Magnitude

                        if distance < minDistance and distance ~= nil then
                            minDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
        
        return closestPlayer
    end)

    combat.calculate_resolver_offset = LPH_NO_VIRTUALIZE(function(player)
        local prediction = Configurations.Target.Prediction
        local offset

        if Configurations.Resolver.Enabled then
            local method = Configurations.Resolver.Method
            local rootPart = player.Character.HumanoidRootPart

            if method == "Recalculate" then
                offset = custom_math.recalculate_velocity(player) * prediction
            elseif method == "Zero Prediction" then
                offset = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z) * prediction
            elseif method == "Move Direction" then
                offset = player.Character.Humanoid.MoveDirection * 19.64285714289 * prediction
            elseif method == "LookVector" then
                offset = player.Character[Configurations.Target.HitPart.Part].CFrame.LookVector * prediction
            end
        end

        return offset
    end)

    combat.aim_viewer_calculator = LPH_NO_VIRTUALIZE(function()
        if Target and Target.Character and Configurations.Resolver.AntiAimViewer then
            local endpoint
            if Configurations.Resolver.Enabled then
                endpoint = Script.Locals.AimPoint + combat.calculate_resolver_offset(Target)
            else
                endpoint = Script.Locals.AimPoint + (Target.Character[Script.Locals.HitPart].Velocity * Configurations.Target.Prediction)
            end
            remote:FireServer(mouse_argument, endpoint)
        end
    end)
end


-- // Drawings
local Line = utility.drawing_new("Line", {
    Visible = false,
    Color = MainColor,
    Thickness = 2,
    Transparency = 0.5,
})

local Dot = utility.drawing_new("Circle", {
    Visible = false,
    Filled = false,
    Color = MainColor,
})

local c_sync_dot = utility.drawing_new("Circle", {
    Visible = false,
    Filled = true
})

local c_sync_tracer = utility.drawing_new("Line", {
    Visible = false,
    Color = MainColor,
    Thickness = 2
})

-- // Instances
local target_chams = utility.instance_new("Highlight", {
    Parent = nil,
    FillColor = MainColor,
    OutlineColor = MainColor,
})

local local_chams = utility.instance_new("Highlight", {
    Parent = nil,
    FillColor = MainColor,
    OutlineColor = MainColor,
})

local function is_in_air(player)
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then 
        return false 
    end

    local root_part = player.Character.HumanoidRootPart
    return root_part.Velocity.Y ~= 0
end

local last_heartbeat = tick()
local heartbeat_interval = 0  -- Throttle updates to ~33 FPS
do -- // connections
    do -- // silent aim connections
        utility.new_connection(RunService.Heartbeat, function()
            if tick() - last_heartbeat < heartbeat_interval then return end
            last_heartbeat = tick()
            
            -- Auto Prediction
            if Configurations.Target.AutoPrediction then
                Configurations.Target.Prediction = custom_math.get_auto_prediction()
            end

            -- Targeting logic
            if is_targetting and Target and utility.has_character(Target) then
                local hitPartName
                if Configurations.Target.HitPart.ClosestPart then
                    hitPartName = tostring(combat.get_closest_part(Target.Character))
                    if Configurations.Target.HitPart.Mode == "Nearest Part" then
                        Script.Locals.HitPart = hitPartName
                        Script.Locals.AimPoint = Target.Character[hitPartName].Position
                    elseif Configurations.Target.HitPart.Mode == "Nearest Point" then
                        Script.Locals.HitPart = hitPartName
                        Script.Locals.AimPoint = combat.get_closest_point(Target.Character[hitPartName])
                    end
                else
                    Script.Locals.HitPart = Configurations.Target.HitPart.Part
                    Script.Locals.AimPoint = Target.Character[Script.Locals.HitPart].Position
                end

                -- Calculate Position and Camera Lock
                local Position = Camera:WorldToViewportPoint(Target.Character[Script.Locals.HitPart].Position)

                if Configurations.Resolver.Enabled then
                    offset = combat.calculate_resolver_offset(Target)
                end
                
                if Configurations.Target.LookAt then
                     LocalPlayer.Character.Humanoid.AutoRotate = false
                     LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position, Vector3.new(Target.Character.HumanoidRootPart.CFrame.X, LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Y, Target.Character.HumanoidRootPart.CFrame.Z))
                else
                     LocalPlayer.Character.Humanoid.AutoRotate = true
                end
                
                if Configurations.Target.Spectate then
                     Camera.CameraSubject = Target.Character.Humanoid;
                else
                     Camera.CameraSubject = LocalPlayer.Character.Humanoid
                end
                
                if Configurations.Target.AutoArmor then
	if game.Players.LocalPlayer.Character.BodyEffects.Armor.Value < 100 then
		local Pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Ignored.Shop["[High-Medium Armor] - $2440"].Head.CFrame
		fireclickdetector(workspace.Ignored.Shop["[High-Medium Armor] - $2440"].ClickDetector)
		RunService.RenderStepped:Wait()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
	end
end
                
                --[[if Configurations.Target.AutoAir then
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = Target.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Jump then
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name ~= "Silent Aim Tool" then
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                end
            end
        end
    end
end--]]

if Configurations.Target.AutoAir then
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = Target.Character:FindFirstChild("Humanoid")
        
        if humanoid then
            local state = humanoid:GetState()
            local playerCharacter = game.Players.LocalPlayer.Character
            local tool = playerCharacter and playerCharacter:FindFirstChildOfClass("Tool")
            
            if (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall) then
                if tool and tool.Name ~= "Silent Aim Tool" then
                    tool:Activate()
                end
            end
        end
    end
end

if Configurations.Target.AutoShoot then
if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
    local playerCharacter = game.Players.LocalPlayer.Character
    local tool = playerCharacter and playerCharacter:FindFirstChildOfClass("Tool")
    local humanoid = Target.Character:FindFirstChild("Humanoid")

    if humanoid then

    if tool and tool.Name ~= "Silent Aim Tool" then
        tool:Activate()
    end
end
end
end


if Configurations.Target.AirPartEnabled then
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        if Target.Character:FindFirstChild("Humanoid"):GetState() == Enum.HumanoidStateType.Jumping or 
           Target.Character:FindFirstChild("Humanoid"):GetState() == Enum.HumanoidStateType.Freefall then
            Script.Locals.HitPart = Configurations.Target.AirPart
        end
    end
end


if Configurations.Target.Checks.AntiGroundShots and Target and Target.Character then
    if is_in_air(Target) then
        local offset = custom_math.recalculate_velocity(Target) * Configurations.Target.Prediction
        offset = Vector3.new(
            math.clamp(offset.X, -math.huge, math.huge), 
            math.clamp(offset.Y, -1, math.huge), 
            math.clamp(offset.Z, -math.huge, math.huge)
        )
    end
  end

                if Configurations.Target.CameraLock.Enabled then
                    local ShakeOffset = Vector3.new(0,0,0)
                    if Configurations.Target.CameraLock.UseShake then
                        ShakeOffset = Vector3.new(
                            math.random(-Configurations.Target.CameraLock.Shake,Configurations.Target.CameraLock.Shake),
                            math.random(-Configurations.Target.CameraLock.Shake,Configurations.Target.CameraLock.Shake),
                            math.random(-Configurations.Target.CameraLock.Shake,Configurations.Target.CameraLock.Shake)
                        ) * 0.1
                    end

                    if Configurations.Target.CameraLock.Smoothness then
                        Camera.CFrame = Camera.CFrame:Lerp(
                            CFrame.new(Camera.CFrame.Position, Target.Character[Script.Locals.HitPart].Position + Target.Character.HumanoidRootPart.Velocity * Configurations.Target.Prediction + ShakeOffset),
                            Configurations.Target.CameraLock.SmoothnessAmount
                        )
                    else
                        Camera.CFrame = CFrame.new(
                            Camera.CFrame.Position,
                            Target.Character[Script.Locals.HitPart].Position + Target.Character.HumanoidRootPart.Velocity * Configurations.Target.Prediction + ShakeOffset
                        )
                    end
                end

                -- Visuals Update
                if Configurations.Target.Enabled then
                    local predicted_position = Position

                    -- Dot
                    if Configurations.Visuals.Dot.Enabled then
                        Dot.Visible = predicted_position and true or false
                        Dot.Filled = true
                        Dot.Position = Vector2.new(predicted_position.X, predicted_position.Y)
                        Dot.Color = Configurations.Visuals.Dot.Color
                        Dot.Size = Configurations.Visuals.Dot.Size
                    end
                    
                    -- Line
                    if Configurations.Visuals.Line.Enabled then
                        local from_position = utility.world_to_screen(LocalPlayer.Character.HumanoidRootPart.Position)
                        Line.Visible = predicted_position and true or false
                        Line.From = from_position.position
                        Line.To = Vector2.new(predicted_position.X, predicted_position.Y)
                        Line.Color = Configurations.Visuals.Line.Color
                        Line.Thickness = Configurations.Visuals.Line.Thickness
                    end
                end

                -- Knocked Check
                if Configurations.Target.Checks.Knocked and Target.Character:FindFirstChild("LowerTorso") and Configurations.Target.Checks.Enabled then
                    local KOd = Target.Character:WaitForChild("BodyEffects")["K.O"].Value
                    local Grabbed = Target.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                    if KOd or Grabbed then
                        Target = nil
                    end
                end
                
                if Configurations.Misc.TargetStrafe.Enabled and 
                   (not Configurations.Misc.TargetStrafe.BypassDC or 
                    (Configurations.Misc.TargetStrafe.BypassDC and Target.Character.HumanoidRootPart.Position.Y >= -10000)) then
                    if Configurations.Target.LookAt == true then
                       Configurations.Target.LookAt = false
                       wait()
                       Configurations.Target.LookAt = true
                    end
  
                    local strafe -- Declare the variable once, outside the conditional blocks

                    if Configurations.Misc.TargetStrafe.Type == "Orbit" then
                        local current_time = tick()
                        strafe = CFrame.new(Target.Character.HumanoidRootPart.Position) * 
                                 CFrame.Angles(0, 2 * math.pi * current_time * Configurations.Misc.TargetStrafe.Speed % (2 * math.pi), 0) * 
                                 CFrame.new(0, Configurations.Misc.TargetStrafe.Height, Configurations.Misc.TargetStrafe.Distance)
                    else
                        strafe = Target.Character.HumanoidRootPart.CFrame + 
                                 custom_math.random_vector3(Configurations.Misc.TargetStrafe.Randomization)
                    end
                    
                    -- After the if-else logic, assign the value of strafe to the LocalPlayer's CFrame
                    LocalPlayer.Character.HumanoidRootPart.CFrame = strafe
                end

                -- Crosshair Update
                if getgenv().crosshair.sticky then
                    getgenv().crosshair.mode = 'custom'
                    getgenv().crosshair.position = Vector2.new(Position.X, Position.Y)
                else
                    getgenv().crosshair.mode = crosshair_position
                end
            else
                if Dot.Visible == true then
                    Dot.Visible = false
                end
                --
                if Line.Visible == true then
                    Line.Visible = false
                end
                --
                LocalPlayer.Character.Humanoid.AutoRotate = true
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
                getgenv().crosshair.mode = crosshair_position
            end

            -- Target Highlight
            if Configurations.Target.Enabled and Configurations.Visuals.HighLight.Enabled and utility.has_character(Target) then
                target_chams.Parent = Target.Character
                target_chams.FillColor = Configurations.Visuals.HighLight.Fill
                target_chams.OutlineColor = Configurations.Visuals.HighLight.OutLine
            else
                target_chams.Parent = nil
            end
        end)
    end

    do -- // misc connections
        utility.new_connection(RunService.Heartbeat, function()
        if ((Configurations.Misc.CSync.Enabled) or (Configurations.Misc.CSync.VoidSpam) or (Configurations.Misc.CSync.DestroyCheaters) and LocalPlayer.Character) then
         old_hrp = LocalPlayer.Character.HumanoidRootPart.CFrame;
         local attach = (Configurations.Misc.CSync.Attach and is_targetting and Target and Target.Character and Target.Character.HumanoidRootPart) or LocalPlayer.Character.HumanoidRootPart
         local cframe_position = {
         	["Custom"] = attach.CFrame * CFrame.new(Configurations.Misc.CSync.Custom.X, Configurations.Misc.CSync.Custom.Y, Configurations.Misc.CSync.Custom.Z),
         	["Destroy Cheaters"] = attach.CFrame * CFrame.new(9e9, 0/0, math.huge),
         	["Random"] = attach.CFrame + custom_math.random_vector3(Configurations.Misc.CSync.Randomize.Value),
             ["Void Spam"] = should_haalfi_destroy and attach.CFrame * CFrame.new(0, 0/1, math.huge) or attach.CFrame
         }
         --
         local csync_type = Configurations.Misc.CSync.VoidSpam and cframe_position["Void Spam"] or Configurations.Misc.CSync.DestroyCheaters and cframe_position["Destroy Cheaters"] or cframe_position[Configurations.Misc.CSync.Type]
         --
         LocalPlayer.Character.HumanoidRootPart.CFrame = csync_type
         --
         if (Configurations.Misc.CSync.Visualize.Enabled and Configurations.Misc.CSync.Visualize.Type == "Line" and typeof(csync_type) == "CFrame") then
						local hrp_pos = utility.world_to_screen(attach.Position);
						local desynced_pos = utility.world_to_screen(csync_type.Position);

						c_sync_tracer.Visible = true;
						c_sync_tracer.From = Vector2.new(hrp_pos.position.X, hrp_pos.position.Y);
						c_sync_tracer.To = Vector2.new(desynced_pos.position.X, desynced_pos.position.Y);
						c_sync_tracer.Color = Configurations.Misc.CSync.Visualize.Color;
					else
						c_sync_tracer.Visible = false;
					end;

					if (Configurations.Misc.CSync.Visualize.Enabled and Configurations.Misc.CSync.Visualize.Type == "Dot" and typeof(csync_type) == "CFrame") then
						local desynced_pos = utility.world_to_screen(csync_type.Position);

						c_sync_dot.Visible = true;
						c_sync_dot.Color = Configurations.Misc.CSync.Visualize.Color;
						c_sync_dot.Position = desynced_pos.position;
						c_sync_dot.Radius = 10;
					else
						c_sync_dot.Visible = false;
					end;
					
         RunService.RenderStepped:Wait()
         --
         LocalPlayer.Character.HumanoidRootPart.CFrame = old_hrp
         else
         c_sync_tracer.Visible = false;
					c_sync_dot.Visible = false;
         end
         end)
         
         task.spawn(function()
			while task.wait(0.1) do
				should_haalfi_destroy = not should_haalfi_destroy;
			end;
		end);
         
        local triggerbot_last_tick = 0
        utility.new_connection(RunService.Heartbeat, function()
            local now = tick()
            if now - triggerbot_last_tick < 0 then return end -- Throttle to ~20FPS
            triggerbot_last_tick = now

            -- Triggerbot logic
            local closestPlayer = combat.get_closest_triggerbot_player()
            if closestPlayer and Configurations.TriggerBot.Enabled then
                local hrp = closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart")

                if hrp and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    local tool = Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    local toolName = tool.Name
                    local validTool = toolName ~= "[Knife]" and toolName ~= "Wallet" and toolName ~= "Silent Aim Tool"

                    if validTool then
                        local aimPos = hrp.Position + hrp.Velocity * Configurations.TriggerBot.Prediction
                        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPos)

                        if onScreen then
                            TriggerBotFOV.Position = Vector2.new(screenPos.X, screenPos.Y)
                            TriggerBotFOV.Visible = Configurations.TriggerBot.Visualize

                            local mousePos = Camera.ViewportSize * 0.5
                            local distance = (mousePos - TriggerBotFOV.Position).magnitude

                            if Configurations.TriggerBot.UseDelay then
                                if distance <= TriggerBotFOV.Radius then
                                    task.delay(Configurations.TriggerBot.Delay, function()
                                        tool:Activate()
                                        TriggerBotFOV.Color = Color3.fromRGB(255, 0, 0) -- Red
                                    end)
                                else
                                    TriggerBotFOV.Color = MainColor -- OG
                                end
                            else
                                tool:Activate()
                                TriggerBotFOV.Color = Color3.fromRGB(255, 0, 0) -- Red
                            end
                        else
                            TriggerBotFOV.Visible = false
                        end
                    else
                        TriggerBotFOV.Visible = false
                    end
                else
                    TriggerBotFOV.Visible = false
                end
            else
                TriggerBotFOV.Visible = false
            end
        end)

        -- // VISUALS BackTrack
        local backtrack_last_tick = 0
        utility.new_connection(RunService.Heartbeat, function()
            if Configurations.Visuals.BackTrack.Enabled and tick() - backtrack_last_tick >= Configurations.Visuals.BackTrack.Duration then
                backtrack_last_tick = tick()

                local players_apply = {
                    ["Local Player"] = LocalPlayer,
                    ["Target"] = Target
                }

                -- Create a table for 'ApplyTo'
                local to_apply_table = type(Configurations.Visuals.BackTrack.ApplyTo) == "string" 
                    and {Configurations.Visuals.BackTrack.ApplyTo} 
                    or Configurations.Visuals.BackTrack.ApplyTo

                -- Iterate through players to apply the backtrack effect
                for i = 1, #to_apply_table do
                    local to_apply = to_apply_table[i]
                    local player = players_apply[to_apply]

                    if player and utility.has_character(player) then
                          local model = utility.clone_character(
                            player,
                            Configurations.Visuals.BackTrack.Transparency,
                            Configurations.Visuals.BackTrack.Color,
                            "Neon",
                            true
                        )

                        -- Schedule destruction of the clone after the backtrack duration
                        task.delay(Configurations.Visuals.BackTrack.Duration, function()
                            if model then model:Destroy() end
                        end)
                    end
                end
            end

            -- World Settings Update
            Lighting.FogColor = Configurations.Visuals.World.Enabled and Configurations.Visuals.World.Fog.Enabled and Configurations.Visuals.World.Fog.Color or Script.World.FogColor
            Lighting.FogStart = Configurations.Visuals.World.Enabled and Configurations.Visuals.World.Fog.Enabled and Configurations.Visuals.World.Fog.Start or Script.World.FogStart
            Lighting.FogEnd = Configurations.Visuals.World.Enabled and Configurations.Visuals.World.Fog.Enabled and Configurations.Visuals.World.Fog.End or Script.World.FogEnd
            Lighting.Ambient = Configurations.Visuals.World.Enabled and Configurations.Visuals.World.Ambient.Enabled and Configurations.Visuals.World.Ambient.Color or Script.World.Ambient
            Lighting.Brightness = Configurations.Visuals.World.Enabled and Configurations.Visuals.World.Brightness.Enabled and Configurations.Visuals.World.Brightness.Value or Script.World.Brightness
            Lighting.ClockTime = Configurations.Visuals.World.Enabled and Configurations.Visuals.World.ClockTime.Enabled and Configurations.Visuals.World.ClockTime.Value or Script.World.ClockTime
            Lighting.ExposureCompensation = Configurations.Visuals.World.Enabled and Configurations.Visuals.World.WorldExposure.Enabled and Configurations.Visuals.World.WorldExposure.Value or Script.World.ExposureCompensation
        end)
    end
end


Tool.Activated:Connect(function()
    if Configurations.Target.Enabled then
        is_targetting = not is_targetting
        local NewTarget = combat.get_closest_player(150)
        Target = is_targetting and NewTarget or nil
        if Configurations.Target.Notify then
            Notifications:New('Target: ' .. tostring(Target), 5, MainColor)
       end
    end
end)

do -- // hit detection
    local function FindTargetOnPart(Part)
        local Target,HitPart = nil,nil
        local Distance = 2

        for _,Player in pairs(game.Players:GetPlayers()) do
            if Player == LocalPlayer then continue end

            local Char = Player.Character
            local Root = Char and Char:FindFirstChild("HumanoidRootPart")

            for _,Obj in pairs(Char:GetChildren()) do
                if not Obj:IsA("BasePart") then continue end
                local Mag = (Obj.Position - Part.Position).Magnitude
                if Mag < Distance then
                    Distance = Mag
                    Target = Player
                    HitPart = Obj
                end
            end
        end

        return Target,HitPart
    end
local Frost = Instance.new("ScreenGui")
Frost.Name = "Frost"
Frost.Parent = game.CoreGui
Frost.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Frame = Instance.new("Frame")
Frame.Parent = Frost
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
Frame.Size = UDim2.new(0, 120, 0, 60)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

local TextButton = Instance.new("TextButton")
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
TextButton.BackgroundTransparency = 0.95
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(0, 96, 0, 35)
TextButton.Font = Enum.Font.Creepster
TextButton.Text = "Lock Button"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 18
TextButton.TextWrapped = true

TextButton.Position = UDim2.new(0.5, -48, 0.5, -17)

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Size = UDim2.new(0, 18, 0, 18)
CloseButton.Position = UDim2.new(1, -23, 0, 5)
CloseButton.Font = Enum.Font.Creepster
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.TextScaled = true
CloseButton.TextWrapped = true

local UICornerX = Instance.new("UICorner")
UICornerX.CornerRadius = UDim.new(0, 8)
UICornerX.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    Frost:Destroy()
end)

local state = true
TextButton.MouseButton1Click:Connect(function()
    if Configurations.Target.Enabled then
        is_targetting = not is_targetting
        local NewTarget = combat.get_closest_player(150)
        Target = is_targetting and NewTarget or nil
        if Configurations.Target.Notify then
            Notifications:New('Target: ' .. tostring(Target), 5, MainColor)
        end
    end
end)

local UICorner2 = Instance.new("UICorner")
UICorner2.Parent = TextButton
    local function SirenAdded(Obj)
        local Character = LocalPlayer.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        local function VerifyBullet(obj)
            return (obj.Name == bullet_name or obj:FindFirstChild("Attachment") or obj:FindFirstChild(bullet_beam_name)) and obj
        end

        local PlayerChecks = {PlayerGun = false}
        local BulletRay = VerifyBullet(Obj)
    
        if BulletRay and RootPart then
            local Mag = (RootPart.Position - BulletRay.Position).Magnitude
            if Mag <= 13 then PlayerChecks.PlayerGun = true end

            if PlayerChecks.PlayerGun then
                local GunBeam = BulletRay:WaitForChild(bullet_beam_name)
                
                local Attachment0 = GunBeam.Attachment0 -- closest to player
                local Attachment1 = GunBeam.Attachment1 -- mouse position
    
                if Configurations.Visuals.Bullet_Trails.Enabled then
                    GunBeam:Destroy()
                    utility.create_beam(BulletRay.Position, Attachment1.WorldCFrame.Position, Configurations.Visuals.Bullet_Trails.Color, Configurations.Visuals.Bullet_Trails.Color, Configurations.Visuals.Bullet_Trails.Duration, Configurations.Visuals.Bullet_Trails.Fade, Configurations.Visuals.Bullet_Trails.FadeDuration)
                end
                
                if Configurations.Visuals.Bullet_Impacts.Enabled then
                    utility.create_impact(Configurations.Visuals.Bullet_Impacts.Color, Configurations.Visuals.Bullet_Impacts.Width, Configurations.Visuals.Bullet_Impacts.Fade, Configurations.Visuals.Bullet_Impacts.FadeDuration, Configurations.Visuals.Bullet_Impacts.Duration, Attachment1.WorldPosition)
                end                
                
                if Configurations.Visuals.Hit_Detection.Enabled then
                    local Part = Instance.new('Part', workspace)
                    Part.Anchored = true
                    Part.Size = Vector3.new(0.25, 0.25, 0.25)
                    Part.Position = Attachment1.WorldCFrame.Position
                    Part.Material = Enum.Material.Neon
                    Part.Color = MainColor
                    Part.CanCollide = false
                    Part.Transparency = 1
    
                    Debris:AddItem(Part,2)
    
                    local Target,HitPart = FindTargetOnPart(Part)
                    if Target then
                        if Configurations.Visuals.Hit_Detection.Notify then
                            Menu.Notify('frost<font color="#'..tostring(MainColor:ToHex())..'">.lol</font> | '..tostring(HitPart)..' | Target : '..Target.DisplayName,1.5)                            
                        end

                        if Configurations.Visuals.Hit_Detection.Clone then
                            local new_character = utility.clone_character(Target,0.5,MainColor,"Neon")
                            task.delay(4,function() new_character:Destroy() end)
                        end

                        if Configurations.Visuals.Hit_Detection.HitEffect then
                            if Configurations.Visuals.Hit_Detection.HitEffectType == "Nova" then
                                hit_effects.bubble(Target.Character.HumanoidRootPart.CFrame.Position,MainColor)
                            elseif Configurations.Visuals.Hit_Detection.HitEffectType == "Confetti" then
                                hit_effects.confetti(Target.Character.HumanoidRootPart.CFrame.Position)
                             elseif Configurations.Visuals.Hit_Detection.HitEffectType == "Slash" then
                                 hit_effects.slash(Target.Character.HumanoidRootPart.CFrame.Position)
                             elseif Configurations.Visuals.Hit_Detection.HitEffectType == "Cosmic Explosion" then
                                 hit_effects.cosmic_explosion(Target.Character.HumanoidRootPart.CFrame.Position)
                             elseif Configurations.Visuals.Hit_Detection.HitEffectType == "Crescent Slash" then
                                 hit_effects.crescent_slash(Target.Character.HumanoidRootPart.CFrame.Position)
                             elseif Configurations.Visuals.Hit_Detection.HitEffectType == "Atomic Slash" then
                                 hit_effects.atomic_slash(Target.Character.HumanoidRootPart.CFrame.Position)
                              elseif Configurations.Visuals.Hit_Detection.HitEffectType == "Cum" then
                                 hit_effects.cum(Target.Character.HumanoidRootPart.CFrame.Position)
                            end
                        end

                        if Configurations.Visuals.Hit_Detection.Sound then
                            local Sound = utility.instance_new("Sound", {
                                SoundId = Script.HitSounds[Configurations.Visuals.Hit_Detection.HitSound],
                                Volume = 1,
                                Parent = Obj
                            })
                            Sound:Play()
                        end
                    end
                end
            end
        end
    end

    if bullet_path then bullet_path.ChildAdded:Connect(SirenAdded) end
end

do -- // Hooking
    __namecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
        local args, method = {...}, tostring(getnamecallmethod())
        
        if not checkcaller() and method == "FireServer" then
            for i, arg in pairs(args) do
                if typeof(arg) == "Vector3" then
                    if Target and Configurations.Target.Enabled and not Configurations.Resolver.AntiAimViewer then
                        args[i] = Script.Locals.AimPoint + (Configurations.Resolver.Enabled and offset or Target.Character[Script.Locals.HitPart].Velocity * Configurations.Target.Prediction)
                    end
                    return __namecall(Self, unpack(args))
                elseif type(arg) == "table" then
                    for index, element in ipairs(arg) do
                        if typeof(element) == "Vector3" and Target and Configurations.Target.Enabled and not Configurations.Resolver.AntiAimViewer then
                            arg[index] = Script.Locals.AimPoint + (Configurations.Resolver.Enabled and offset or Target.Character[Script.Locals.HitPart].Velocity * Configurations.Target.Prediction)
                        end
                    end
                end
            end
            return __namecall(Self, unpack(args))
        end
        
        return __namecall(Self, ...)
    end))

    local old
    old = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, key)
        if not checkcaller() then
            if key == "CFrame" and LocalPlayer.Character and self == LocalPlayer.Character.HumanoidRootPart and ((Configurations.Misc.CSync.Enabled) or (Configurations.Misc.CSync.DestroyCheaters) or (Configurations.Misc.CSync.VoidSpam)) and old_hrp ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
                return old_hrp
            end
        end 
        return old(self, key)
    end))
end

function Gun(Name)
    for Check = 1, 100000 do
        if game.Workspace.Ignored.Shop:FindFirstChild("[" .. Name .. "] - $" .. Check) then
            return tostring("[" .. Name .. "] - $" .. Check)
        end
    end
end

function Ammo(Name)
    for Check1 = 1, 250 do
        for Check2 = 1, 500 do
            if game.Workspace.Ignored.Shop:FindFirstChild(Check1 .. " [" .. Name .. " Ammo] - $" .. Check2) then
                return tostring(Check1 .. " [" .. Name .. " Ammo] - $" .. Check2)
            end
        end
    end
end

function Buy(Target, Delay, LagBack, Times)
    if Times == nil then
        Times = 3
    end
    local item = game.Workspace.Ignored.Shop:FindFirstChild(Target)
    if item then
        savepos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        for i = 1, Times do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.Head.CFrame * CFrame.new(0, 3, 0)
            task.wait(0.5)
            for i = 1, 10 do
                fireclickdetector(item.ClickDetector)
            end
            task.wait(0.5)
        end
        if LagBack then
            task.wait(1)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savepos
        end
        if Delay ~= nil then
            task.wait(Delay)
        end
    end
end

function BuyGunAndAmmo(GUN, times)
    if
        game.Players.LocalPlayer.Backpack:FindFirstChild("[" .. GUN .. "]") or
            game.Players.LocalPlayer.Character:FindFirstChild("[" .. GUN .. "]")
     then
        Buy(Ammo(GUN), 0.3, true, times)
    else
        Buy(Gun(GUN), 0.5, true)
    end
end

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local function locateItem(itemName)
    for price = 1, 100000 do
        local fullName = "[" .. itemName .. "] - $" .. price
        local item = game.Workspace.Ignored.Shop:FindFirstChild(fullName)
        if item then
            return item, price
        end
    end
  end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")


ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BackgroundTransparency = 1
ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.744, 0,0.145, 0)
ImageButton.Size = UDim2.new(0.0914429501, 0, 0.15372169, 0)
ImageButton.Image = "rbxassetid://86865501962131"

-- UI Visibility Toggle
local isVisible = true
local function toggleUI()
    isVisible = not isVisible
    Menu:SetVisible(isVisible)
end
ImageButton.MouseButton1Down:Connect(toggleUI)

-- Text Size Constraint
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
UITextSizeConstraint.Parent = TextButton
UITextSizeConstraint.MaxTextSize = 30

-- Character Added Event
local player = game.Players.LocalPlayer
local function onCharacterAdded(character)
    ScreenGui.Parent = player.PlayerGui
end
player.CharacterAdded:Connect(onCharacterAdded)
player.CharacterRemoving:Connect(function() ScreenGui.Parent = nil end)

-- Menu Name Update
local function MenuNameUpdate()
    while task.wait() do
        local Name = 'frost'
        local PlaceHolder = ''
        for i = 1, #Name do
            PlaceHolder = PlaceHolder .. string.sub(Name, i, i)
            Menu:SetTitle(PlaceHolder .. '<font color="#' .. tostring(Menu.Accent:ToHex()) .. '">.lol</font> | GUI')
            task.wait(0.25)
        end
    end
end
task.spawn(MenuNameUpdate)

-- Setup Menu
Menu:SetSize(500,400)
Menu.Accent = MainColor
Menu:SetVisible(true)
Menu:Init()

-- Create Tabs
local CombatTab = Menu.Tab("Main")
local MiscTab = Menu.Tab("Misc")
local VisualsTab = Menu.Tab("Visuals")

Menu.Container("Main", "Gui", "Left")
Menu.ColorPicker("Main", "Gui", "Menu Color", Menu.Accent, 1, function(value)
    Menu.Accent = value
end, "Colorpicker Tooltip")

Menu.Button("Main", "Gui", "Lock Button", function()

local Frost = Instance.new("ScreenGui")
Frost.Name = "Frost"
Frost.Parent = game.CoreGui
Frost.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Frame = Instance.new("Frame")
Frame.Parent = Frost
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
Frame.Size = UDim2.new(0, 120, 0, 60)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

local TextButton = Instance.new("TextButton")
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
TextButton.BackgroundTransparency = 0.95
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(0, 96, 0, 35)
TextButton.Font = Enum.Font.Creepster
TextButton.Text = "Lock Button"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 18
TextButton.TextWrapped = true

TextButton.Position = UDim2.new(0.5, -48, 0.5, -17)

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Size = UDim2.new(0, 18, 0, 18)
CloseButton.Position = UDim2.new(1, -23, 0, 5)
CloseButton.Font = Enum.Font.Creepster
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.TextScaled = true
CloseButton.TextWrapped = true

local UICornerX = Instance.new("UICorner")
UICornerX.CornerRadius = UDim.new(0, 8)
UICornerX.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    Frost:Destroy()
end)

local state = true
TextButton.MouseButton1Click:Connect(function()
    if Configurations.Target.Enabled then
        is_targetting = not is_targetting
        local NewTarget = combat.get_closest_player(150)
        Target = is_targetting and NewTarget or nil
        if Configurations.Target.Notify then
            Notifications:New('Target: ' .. tostring(Target), 5, MainColor)
        end
    end
end
)
end)


Menu.Container("Main", "Tools", "Right")

Menu.Button("Main", "Tools", "Lock Tool (Perm)", function()
local Tool = Instance.new("Tool")
Tool.RequiresHandle = false
Tool.Name = "Lock Tool"
Tool.Parent = game.Players.LocalPlayer.Backpack

local player = game.Players.LocalPlayer

local function connectCharacterAdded()
    player.CharacterAdded:Connect(onCharacterAdded)
end

connectCharacterAdded()

player.CharacterRemoving:Connect(
    function()
        Tool.Parent = game.Players.LocalPlayer.Backpack
    end
)
end)

Menu.Button("Main", "Tools", "Lock Tool (Lose on respawn)", function()
local Tool = Instance.new("Tool")
Tool.RequiresHandle = false
Tool.Name = "Lock Tool"
Tool.Parent = game.Players.LocalPlayer.Backpack

local player = game.Players.LocalPlayer

local function onCharacterAdded(character)
    local existingTool = character:FindFirstChild(Tool.Name)
    if existingTool then
        existingTool:Destroy()
    end
end

local function connectCharacterAdded()
    player.CharacterAdded:Connect(onCharacterAdded)
end

connectCharacterAdded()

player.CharacterRemoving:Connect(
    function()
        Tool:Destroy()
    end
)
end)

Menu.Container("Main", "Target Aim", "Left")
Menu.CheckBox("Main", "Target Aim", "Enabled", Configurations.Target.Enabled, function(a)
    Configurations.Target.Enabled = a
end)

Menu.TextBox("Main", "Target Aim", "Prediction", '0.16326833333333332', function(a)
    Configurations.Target.Prediction = a
end)

Menu.CheckBox("Main", "Target Aim", "Auto Prediction", Configurations.Target.AutoPrediction, function(a)
    Configurations.Target.AutoPrediction = a
end)

Menu.CheckBox("Main", "Target Aim", "Look At", Configurations.Target.LookAt, function(a)
    Configurations.Target.LookAt = a
end)

Menu.CheckBox("Main", "Target Aim", "Spectate", Configurations.Target.Spectate, function(a)
    Configurations.Target.Spectate = a
end)

Menu.CheckBox("Main", "Target Aim", "AutoAir", true, Configurations.Target.AutoAir, function(a)
    Configurations.Target.AutoAir = a
    end)
    
    Menu.CheckBox("Main", "Target Aim", "AutoShoot", Configurations.Target.AutoShoot, function(a)
        Configurations.Target.AutoShoot = a
        end)

Menu.CheckBox("Main", "Target Aim", "Notify", true, Configurations.Target.Notify, function(a)
    Configurations.Target.Notify = a
end)

Menu.CheckBox("Main", "Target Aim", "Camera Lock", true, Configurations.Target.CameraLock.Enabled, function(a)
    Configurations.Target.CameraLock.Enabled = a
end)

Menu.Container("Main", "Hit Part", "Left")
Menu.CheckBox("Main", "Hit Part", "Nearest Part", false, function(a)
    Configurations.Target.HitPart.ClosestPart = a
end)


Menu.ComboBox("Main", "Hit Part", "Nearest Part Mode", "Nearest Part", {"Nearest Point", "Nearest Part"}, function(a)
    Configurations.Target.HitPart.Mode = a
end)

Menu.ComboBox("Main", "Hit Part", "Hit Part", "HumanoidRootPart", {"Head", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "HumanoidRootPart", "LeftUpperLeg", "RightLowerLeg", "RightFoot", "LowerTorso"}, function(a)
    Configurations.Target.HitPart.Part = a
end)

Menu.CheckBox("Main", "Hit Part", "AirPart", true, Configurations.Target.AirPartEnabled, function(a)
            Configurations.Target.AirPartEnabled = a
            end)

Menu.ComboBox("Main", "Hit Part", "Air Part", "LowerTorso", {"Head", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "HumanoidRootPart", "LeftUpperLeg", "RightLowerLeg", "RightFoot", "LowerTorso"}, function(a)
    Configurations.Target.AirPart = a
    end)
	
Menu.Container("Main", "Trigger Bot", "Right")
Menu.CheckBox("Main", "Trigger Bot", "Enabled", false, Configurations.TriggerBot.Enabled, function(a)
    Configurations.TriggerBot.Enabled = a
end)

Menu.TextBox("Main", "Trigger Bot", "Prediction", '0.16326833333333332', function(a)
    Configurations.TriggerBot.Prediction = a
end)

Menu.CheckBox("Main", "Trigger Bot", "Visualize", Configurations.TriggerBot.Visualize, function(a)
    Configurations.TriggerBot.Visualize = a
end)

Menu.CheckBox("Main", "Trigger Bot", "Use Delay", Configurations.TriggerBot.UseDelay, function(a)
    Configurations.TriggerBot.UseDelay = a
end)

Menu.TextBox("Main", "Trigger Bot", "Delay", '0.02', function(a)
    Configurations.TriggerBot.Delay = a
end)

Menu.Slider('Main', 'Trigger Bot', 'Range', 1, 100, 2, '', 1, function(Value)
    Configurations.TriggerBot.Range = Value
end)

Menu.Container("Main", "Camera Lock Settings", "Right")
Menu.CheckBox("Main", "Camera Lock Settings", "Use Shake", Configurations.Target.CameraLock.UseShake, function(a)
    Configurations.Target.CameraLock.UseShake = a
end)

Menu.Slider("Main", "Camera Lock Settings", "Shake Value", 1, 100, 2, "", 1, function(Value)
    Configurations.Target.CameraLock.Shake = Value
end)

Menu.CheckBox("Main", "Camera Lock Settings", "Use Smoothness", Configurations.Target.CameraLock.Smoothness, function(a)
    Configurations.Target.CameraLock.Smoothness = a
end)

Menu.TextBox("Main", "Camera Lock Settings", "Smoothness Amount", "0.14", function(a)
    Configurations.Target.CameraLock.SmoothnessAmount = a
end)

Menu.ComboBox("Main", "Camera Lock Settings", "Easing Style", "Elastic", {"Elastic","Sine","Quad","Back","Linear","Exponential","Circular","Cubic","Quad","Quirt"}, function(a)
    Configurations.Target.CameraLock.Style = a
end)

Menu.ComboBox("Main", "Camera Lock Settings", "Easing Direction", "InOut", {"In","Out","InOut"}, function(a)
    Configurations.Target.CameraLock.Direction = a
end)

Menu.Container("Main", "Resolver", "Left")
Menu.CheckBox("Main", "Resolver", "Enabled", false, Configurations.Resolver.Enabled, function(a)
    Configurations.Resolver.Enabled = a
end)

Menu.CheckBox("Main", "Resolver", "Anti Aim Viewer", Configurations.Resolver.AntiAimViewer, function(a)
    Configurations.Resolver.AntiAimViewer = a
end)

Menu.ComboBox("Main", "Resolver", "Method", "Recalculate", {"Recalculate", "LookVector", "Move Direction", "Zero Prediction"}, function(a)
    Configurations.Resolver.Method = a
end)

Menu.Container("Main", "Checks", "Left")
Menu.CheckBox("Main", "Checks", "Enabled", Configurations.Target.Checks.Enabled, function(a)
    Configurations.Target.Checks.Enabled = a
end)

Menu.CheckBox("Main", "Checks", "Knocked", true, Configurations.Target.Checks.Knocked, function(a)
    Configurations.Target.Checks.Knocked = a
end)

Menu.CheckBox("Main", "Checks", "Grabbed", true, Configurations.Target.Checks.Grabbed, function(a)
    Configurations.Target.Checks.Grabbed = a
end)

Menu.CheckBox("Main", "Checks", "AntiGroundShots", true, Configurations.Target.Checks.AntiGroundShots, function(a)
    Configurations.Target.Checks.AntiGroundShots = a
end)

local TSSection = Menu.Container("Main", "Target Strafe", "Right") do
    Menu.CheckBox("Main", "Target Strafe", "Enabled", false, function(a)
        Configurations.Misc.TargetStrafe.Enabled = a
    end)
    
    Menu.CheckBox("Main", "Target Strafe", "Bypass Destroy Cheaters", false, function(a)
        Configurations.Misc.TargetStrafe.BypassDC = a
    end)
    
    Menu.ComboBox("Main", "Target Strafe", "Method", "Orbit", {"Orbit", "Randomize"}, function(a)
        Configurations.Misc.TargetStrafe.Type = a
    end)
    
    Menu.Slider("Main", "Target Strafe", "Distance", 0, 50, 9, '', 1, function(a)
        Configurations.Misc.TargetStrafe.Distance = a
    end)
    
    Menu.Slider("Main", "Target Strafe", "Speed", 0, 15, 1, '', 1, function(a)
        Configurations.Misc.TargetStrafe.Speed = a
    end)
    
    Menu.Slider("Main", "Target Strafe", "Height", 0, 15, 0, '', 1, function(a)
        Configurations.Misc.TargetStrafe.Height = a
    end)
    
    Menu.Slider("Main", "Target Strafe", "Randomization Value", 1, 50, 2, '', 1, function(Value)
        Configurations.Misc.TargetStrafe.Randomization = Value
    end)
end

local SelectedGun = "LMG"
local SelectedFood = "Taco"

Menu.Container("Misc", "Buy", "Right")

Menu.Slider('Misc', 'Buy', 'Multiplier', 1, 10, 1, '', 1, function(Value)
    autobuymultiplier = Value
end)

Menu.ComboBox('Misc', 'Buy', 'Gun', 'LMG', Guns, function(self)
    SelectedGun = self
    Configurations.Misc.AutoBuy.SelectedGun = SelectedGun
end)

Menu.Button('Misc', 'Buy', 'Buy Gun', function()
    BuyGunAndAmmo(SelectedGun, autobuymultiplier)
end)

Menu.ComboBox('Misc', 'Buy', 'Food', 'Taco', Food, function(self)
    SelectedFood = self
    Configurations.Misc.AutoBuy.SelectedFood = SelectedFood
end)

Menu.Button('Misc', 'Buy', 'Buy Food', function()
    Buy(Gun(SelectedFood), 0.3, true, 1)
end)
local Player = game.Players.LocalPlayer
local Dances = {
    Floss = 10714340543
}

local currentAnimation

local function AnimPlay(ID, SPEED)
    if currentAnimation then
        currentAnimation:Stop()
    end

    local animation = Instance.new('Animation')
    animation.AnimationId = 'rbxassetid://' .. ID

    currentAnimation = Player.Character.Humanoid:LoadAnimation(animation)
    currentAnimation:Play()
    currentAnimation:AdjustSpeed(tonumber(SPEED) or 1)

    animation:Destroy()
end

Menu.Container("Misc", "Animation", "Right")

Menu.ComboBox('Misc', 'Animation', 'Dance', 'Floss', {"Floss"}, function(self)
    Configurations.Misc.Animation.SelectedDance = self
end)

Menu.Slider('Misc', 'Animation', 'Speed', 0, 1, 0, '', 1, function(Value)
    Configurations.Misc.Animation.Speed = Value
end)

Menu.CheckBox("Misc", "Animation", "Enabled", Configurations.Misc.Animation.Enabled, function(state)
    Configurations.Misc.Animation.Enabled = state
    if Configurations.Misc.Animation.Enabled then
        local selectedDance = Dances[Configurations.Misc.Animation.SelectedDance or "Floss"]
        if selectedDance then
            AnimPlay(selectedDance, Configurations.Misc.Animation.Speed or 1)
        end
    else
        if currentAnimation then
            currentAnimation:Stop()
            currentAnimation = nil
        end
    end
end)

local Section7 = Menu.Container("Misc", "Anti Aim", "Left") do
    Menu.CheckBox("Misc", "Anti Aim", "Void Spam", false, function(a)
        Configurations.Misc.CSync.VoidSpam = a
    end)
    
    Menu.CheckBox("Misc", "Anti Aim", "Destroy Cheaters", false, function(a)
        Configurations.Misc.CSync.DestroyCheaters = a
    end)
    
    Menu.CheckBox("Misc", "Anti Aim", "Anti-Void", false, function(a)
    Workspace.FallenPartsDestroyHeight = a and -50000 or -500
end)

Menu.CheckBox("Misc", "Anti Aim", "Auto-Armor", false, function(a)
    Configurations.Target.AutoArmor = a
    end)

    
    Menu.CheckBox("Misc", "Anti Aim", "Network Desync", false, function(a)
end)
    
    Menu.CheckBox("Misc", "Anti Aim", "C-Sync", false, function(a)
        Configurations.Misc.CSync.Enabled = a
    end)
    
    Menu.ComboBox("Misc", "Anti Aim", "C-Sync Type", "Random", {"Random", "Custom"}, function(a)
        Configurations.Misc.CSync.Type = a
    end)
    
    
    Menu.Slider("Misc", "Anti Aim", "CFrame Desync Randomization", 1, 50, 1, "", 1, function(a)
        Configurations.Misc.CSync.Randomize.Value = a
    end)
    
    Menu.Slider("Misc", "Anti Aim", "CFrame Desync Customization", 1, 50, 1, "", 1, function(a)
        Configurations.Misc.CSync.Custom.X = a
        Configurations.Misc.CSync.Custom.Y = a
        Configurations.Misc.CSync.Custom.Z = a
    end)
end

Menu.Container("Misc", "CFrame Movement", "Left")
Menu.Button('Misc', 'CFrame Movement', 'Load Button', function()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "Toggle Speed"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundTransparency = 0.5
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.853, -120,-0.087, 75) -- Adjusted the position to top right corner
ToggleButton.Size = UDim2.new(0, 100, 0, 18)
ToggleButton.BackgroundColor3 = MainColor
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
local UICorner = Instance.new("UICorner")
UICorner.Parent = ToggleButton
local function onButtonClicked()
    Configurations.Misc.CSync.CFrameSpeed.Enabled = not Configurations.Misc.CSync.CFrameSpeed.Enabled
end
ToggleButton.MouseButton1Click:Connect(onButtonClicked)

game:GetService("RunService").Stepped:Connect(function()
    if Configurations.Misc.CSync.CFrameSpeed.Enabled then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * Configurations.Misc.CSync.CFrameSpeed.Speed
    end
end)
end)

Menu.Slider('Misc', 'CFrame Movement', 'Speed Amount', 1, 10, 1, '', 1, function(Value)
    Configurations.Misc.CSync.CFrameSpeed.Speed = Value
    end)

local Section7 = Menu.Container("Visuals", "Crosshair", "Right") do
    Menu.CheckBox("Visuals", "Crosshair", "Enabled", false, function(a)
        getgenv().crosshair.enabled = a
    end)
    Menu.ColorPicker("Visuals", "Crosshair", "Color", MainColor, 0, function(a)
        getgenv().crosshair.color = a
    end)
    Menu.CheckBox("Visuals", "Crosshair", "Stick To Target", false, function(a)
        getgenv().crosshair.sticky = a
    end)
    Menu.ComboBox("Visuals", "Crosshair", "Position", "Middle", {"Middle", "Mouse"}, function(a)
        crosshair_position = a
    end)

    Menu.Slider("Visuals", "Crosshair", "Thickness", 1, 5, 2.5, "", 1, function(a)
        getgenv().crosshair.width = a
    end)
    Menu.Slider("Visuals", "Crosshair", "Size", 1, 50, 10, "", 0, function(a)
        getgenv().crosshair.length = a
    end)
    Menu.Slider("Visuals", "Crosshair", "Gap", 0, 20, 11, "", 1, function(a)
        getgenv().crosshair.radius = a
    end)

    Menu.CheckBox("Visuals", "Crosshair", "Spin", getgenv().crosshair.spin, function(a)
        getgenv().crosshair.spin = a
    end)
    Menu.Slider("Visuals", "Crosshair", "Spin Speed", 1, 340, 150, "", 0, function(a)
        getgenv().crosshair.spin_speed = a
    end)

    Menu.CheckBox("Visuals", "Crosshair", "Resize", getgenv().crosshair.resize, function(a)
        getgenv().crosshair.resize = a
    end)
    Menu.Slider("Visuals", "Crosshair", "Resize Speed", 1, 22, 5, "", 0, function(a)
        getgenv().crosshair.resize_speed = a
    end)
end

local TLHightlightSection = Menu.Container("Visuals", "HighLight", "Right") do
    Menu.CheckBox("Visuals", "HighLight", "Enabled", true, function(a)
        Configurations.Visuals.HighLight.Enabled = a
    end)
    Menu.ColorPicker("Visuals", "HighLight", "Fill Color", MainColor, 0, function(a)
        Configurations.Visuals.HighLight.FillColor = a
    end)
    Menu.ColorPicker("Visuals", "HighLight", "Outline Color", Color3.fromRGB(255, 255, 255), 0, function(a)
        Configurations.Visuals.HighLight.OutLineColor = a
    end)
end

local TLBackTrackSection = Menu.Container("Visuals", "Clone Chams", "Right") do
    Menu.CheckBox("Visuals", "Clone Chams", "Enabled", true, function(a)
        Configurations.Visuals.BackTrack.Enabled = a
    end)
    Menu.Slider("Visuals", "Clone Chams", "Transparency", 0, 1, 0, "", 1, function(a)
        Configurations.Visuals.BackTrack.Transparency = a
    end)
    Menu.Slider("Visuals", "Clone Chams", "Duration", 0, 5, 0.1, "", 1, function(a)
        Configurations.Visuals.BackTrack.Duration = a
    end)
    Menu.ColorPicker("Visuals", "Clone Chams", "Color", MainColor, 0, function(a)
        Configurations.Visuals.BackTrack.Color = a
    end)
    Menu.ComboBox("Visuals", "Clone Chams", "Apply To", "Local Player", {"Local Player", "Target"}, function(a)
        Configurations.Visuals.BackTrack.ApplyTo = a
    end)
end

local HitDetectionSection = Menu.Container("Visuals", "Hit Detection", "Left") do
    Menu.CheckBox("Visuals", "Hit Detection", "Enabled", true, function(a)
        Configurations.Visuals.Hit_Detection.Enabled = a
    end)
    
    Menu.CheckBox("Visuals", "Hit Detection", "Hit Sound", true, function(a)
        Configurations.Visuals.Hit_Detection.Sound = a
    end)
    
    Menu.ComboBox("Visuals", "Hit Detection", "Sound To Play", "NeverLose", {"Bameware", "Bubble", "Pick", "Pop", "Rust", "Sans", "Fart", "Big", "Vine", "Bruh", "Skeet", "Neverlose", "Fatality", "Bonk", "Minecraft"}, function(self)
        Configurations.Visuals.Hit_Detection.HitSound = self
    end)
    
    Menu.CheckBox("Visuals", "Hit Detection", "Hit Chams", false, function(a)
        Configurations.Visuals.Hit_Detection.Clone = a
    end)
    
    Menu.CheckBox("Visuals", "Hit Detection", "Hit Logs", true, function(a)
        Configurations.Visuals.Hit_Detection.Notify = a
    end)
    
    Menu.CheckBox("Visuals", "Hit Detection", "Hit Effect", true, function(a)
        Configurations.Visuals.Hit_Detection.HitEffect = a
    end)
    
    Menu.ComboBox("Visuals", "Hit Detection", "Hit Effects Type", "Crescent Slash", {"Nova", "Confetti", "Cum", "Slash", "Atomic Slash", "Crescent Slash", "Cosmic Explosion"}, function(w)
        Configurations.Visuals.Hit_Detection.HitEffectType = w
    end)
end

local TracersSection = Menu.Container("Visuals","Bullet Tracers","Left") do
    Menu.CheckBox("Visuals","Bullet Tracers","Enabled",false,function(self)
        Configurations.Visuals.Bullet_Trails.Enabled = self
    end)
    
    Menu.ColorPicker("Visuals","Bullet Tracers","Color",MainColor,0,function(self)
        Configurations.Visuals.Bullet_Trails.Color = self
    end)
    
    Menu.Slider("Visuals", "Bullet Tracers", "Duration", 1, 5, 3, "", 1, function(a)
        Configurations.Visuals.Bullet_Trails.Duration = a
    end)
end

local ImpactSection = Menu.Container("Visuals","Bullet Impact","Left") do
    Menu.CheckBox("Visuals","Bullet Impact","Enabled",false,function(self)
        Configurations.Visuals.Bullet_Impacts.Enabled = self
    end)
    
    Menu.ColorPicker("Visuals","Bullet Impact","Color",MainColor,0,function(self)
        Configurations.Visuals.Bullet_Impacts.Color = self
    end)
    
    Menu.Slider("Visuals", "Bullet Impact", "Duration", 1, 5, 3, "", 1, function(a)
        Configurations.Visuals.Bullet_Impacts.Duration = a
    end)
    
    Menu.Slider("Visuals", "Bullet Impact", "Width", 0.1, 5, 0.25, "", 1, function(a)
        Configurations.Visuals.Bullet_Impactsl.Width = a
    end)
end

local WorldSection = Menu.Container("Visuals", "World", "Left") do
    Menu.CheckBox("Visuals", "World", "Enabled", falde, function(a)
        Configurations.Visuals.World.Enabled = a
    end)
    
    Menu.CheckBox("Visuals", "World", "Fog", true, function(a)
        Configurations.Visuals.World.Fog.Enabled = a
    end)
    
    Menu.ColorPicker("Visuals", "World", "Fog Color", MainColor, 0, function(a)
        Configurations.Visuals.World.Fog.Color = a
    end)
    
    Menu.Slider("Visuals", "World", "Fog Start", 1, 100, 1, "", 1, function(a)
        Configurations.Visuals.World.Fog.Start = a
    end)
    
    Menu.Slider("Visuals", "World", "Fog End", 1, 100, 1, "", 1, function(a)
        Configurations.Visuals.World.Fog.End = a
    end)
    
    Menu.CheckBox("Visuals", "World", "Ambient", true, function(a)
        Configurations.Visuals.World.Ambient.Enabled = a
    end)
    
    Menu.ColorPicker("Visuals", "World", "Ambient Color", MainColor, 0, function(a)
        Configurations.Visuals.World.Ambient.Color = a
    end)
    
    Menu.CheckBox("Visuals", "World", "Brightness", true, function(a)
        Configurations.Visuals.World.Brightness.Enabled = a
    end)
    
    Menu.Slider("Visuals", "World", "Brightness Amount", 0, 20, 1, "", 1, function(a)
        Configurations.Visuals.World.Brightness.Value = a
    end)
    
    Menu.CheckBox("Visuals", "World", "Clock Time", true, function(a)
        Configurations.Visuals.World.ClockTime.Enabled = a
    end)
    
    Menu.Slider("Visuals", "World", "Time (hrs / hours)", 0, 24, 1, "", 1, function(a)
        Configurations.Visuals.World.ClockTime.Value = a
    end)
    end
