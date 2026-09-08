-- Vision v2 UI library preserved for VaultUI. Original API and runtime logic retained.
-- Public entry points: Create, Tab, Section, controls, Notify, Popup, and Destroy.

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

local Mouse = LocalPlayer:GetMouse()
local ConnectionBin = {}
local ControlsConnectionBin = {}

-- Var
local ThemeInstances = {
	["Main"] = {},
	["MainTrue"] = {},
	["Secondary"] = {},
	["SecondaryTrue"] = {},
	["Tertiary"] = {},
	["TertiaryTrue"] = {},
	["Text"] = {},
	["PlaceholderText"] = {},
	["Textbox"] = {},
	["NavBar"] = {},
	["Theme"] = {},
	["ThemeTrue"] = {},
}

local ThemeColor = {
	Main = ColorSequence.new({ -- 6
		ColorSequenceKeypoint.new(0.000, Color3.fromRGB(45, 45, 45)),
		ColorSequenceKeypoint.new(1.000, Color3.fromRGB(39, 39, 39)),
	}),
	MainTrue = Color3.fromRGB(45, 45, 45),
	Secondary = ColorSequence.new({ -- 7
		ColorSequenceKeypoint.new(0.000, Color3.fromRGB(31, 31, 31)),
		ColorSequenceKeypoint.new(1.000, Color3.fromRGB(24, 24, 24)),
	}),
	SecondaryTrue = Color3.fromRGB(31, 31, 31),
	Tertiary = ColorSequence.new({ -- 4
		ColorSequenceKeypoint.new(0.000, Color3.fromRGB(31, 31, 31)),
		ColorSequenceKeypoint.new(1.000, Color3.fromRGB(27, 27, 27)),
	}),
	TertiaryTrue = Color3.fromRGB(31, 31, 31),
	Text = Color3.fromRGB(255, 255, 255),
	PlaceholderText = Color3.fromRGB(175, 175, 175),
	Textbox = Color3.fromRGB(61, 61, 61),
	NavBar = ColorSequence.new({ -- 9
		ColorSequenceKeypoint.new(0.000, Color3.fromRGB(35, 35, 35)),
		ColorSequenceKeypoint.new(1.000, Color3.fromRGB(24, 24, 24)),
	}),
	NavBarTrue = Color3.fromRGB(35, 35, 35),
	Theme = ColorSequence.new({
		ColorSequenceKeypoint.new(0.000, Color3.fromRGB(132, 65, 232)),
		ColorSequenceKeypoint.new(1.000, Color3.fromRGB(132, 65, 185)),
	}),
	ThemeTrue = Color3.fromRGB(132, 65, 232),
}

local Library = {
	MainFrameHover = false,
	Sliding = false,
	Loaded = false,
	CurrentTheme = {
		Main = ThemeColor.MainTrue,
		Secondary = ThemeColor.SecondaryTrue,
		Tertiary = ThemeColor.TertiaryTrue,
		Text = ThemeColor.Text,
		PlaceholderText = ThemeColor.PlaceholderText,
		Textbox = ThemeColor.Textbox,
		NavBar = ThemeColor.NavBarTrue,
		Theme = ThemeColor.ThemeTrue,
	},
}

pcall(function()
	getgenv().VisionUILibrary:Destroy()
end)

pcall(function()
	getgenv().VisionUILibrary = Library
end)

local LibSettings = {
	DragSpeed = 0.07,
	SoundVolume = 0.5,
	HoverSound = "rbxassetid://10066931761",
	ClickSound = "rbxassetid://6895079853",
	PopupSound = "rbxassetid://225320558",
}

local TabIndex = 0

-- Lib
local LibFrame = {}
do
	-- StarterGui.Vision Lib v2
	LibFrame["1"] = Instance.new("ScreenGui")
	LibFrame["1"]["Name"] = [[VisionLibv2]]
	LibFrame["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
	LibFrame["1"]["Parent"] = (RunService:IsStudio() and LocalPlayer.PlayerGui) or game:GetService("CoreGui")
	LibFrame["1"]["IgnoreGuiInset"] = false

	-- StarterGui.Vision Lib v2
	LibFrame["2"] = Instance.new("ScreenGui")
	LibFrame["2"]["Name"] = [[VisionLibOverlay]]
	LibFrame["2"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
	LibFrame["2"]["Parent"] = (RunService:IsStudio() and LocalPlayer.PlayerGui) or game:GetService("CoreGui")
	LibFrame["2"]["IgnoreGuiInset"] = true

	-- StarterGui.Vision Lib v2.NotifFrame
	LibFrame["81"] = Instance.new("Frame", LibFrame["1"])
	LibFrame["81"]["Active"] = true
	LibFrame["81"]["BorderSizePixel"] = 0
	LibFrame["81"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
	LibFrame["81"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
	LibFrame["81"]["BackgroundTransparency"] = 1
	LibFrame["81"]["Size"] = UDim2.new(0.154, 0, 0, 0)
	LibFrame["81"]["Position"] = UDim2.new(0.925, 0, 0.995, 0)
	LibFrame["81"]["Name"] = [[NotifFrame]]

	-- StarterGui.Vision Lib v2.NotifFrame.UIListLayout
	LibFrame["82"] = Instance.new("UIListLayout", LibFrame["81"])
	LibFrame["82"]["VerticalAlignment"] = Enum.VerticalAlignment.Bottom
	LibFrame["82"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right
	LibFrame["82"]["Padding"] = UDim.new(0, 5)
	LibFrame["82"]["SortOrder"] = Enum.SortOrder.LayoutOrder

	-- StarterGui.Vision Lib v2.NotifFrame.UIPadding
	LibFrame["83"] = Instance.new("UIPadding", LibFrame["81"])
	LibFrame["83"]["PaddingRight"] = UDim.new(0, 40)
	LibFrame["83"]["PaddingBottom"] = UDim.new(0, 40)
end

function Library:Tween(object, options, callback)
	local options = Library:PlaceDefaults({
		Length = 2,
		Style = Enum.EasingStyle.Quint,
		Direction = Enum.EasingDirection.Out,
	}, options)

	callback = callback or function()
		return
	end

	local tweeninfo = TweenInfo.new(options.Length, options.Style, options.Direction)

	local Tween = TweenService:Create(object, tweeninfo, options.Goal)
	Tween:Play()

	table.insert(
		ConnectionBin,
		Tween.Completed:Connect(function()
			callback()
		end)
	)
	return Tween
end

function Library:ResizeCanvas(Tab)
	local NumChild = 0
	local ChildOffset = 0

	for i, v in pairs(Tab:GetChildren()) do
		if v:IsA("Frame") then
			NumChild = NumChild + 1
			ChildOffset = ChildOffset + v.Size.Y.Offset
		end
	end

	local NumChildOffset = NumChild * 5

	local CanvasSizeY = NumChildOffset + ChildOffset + 10

	Library:Tween(Tab, {
		Length = 0.5,
		Goal = { CanvasSize = UDim2.new(0, 0, 0, CanvasSizeY) },
	})
end

function Library:CalGradient(BaseColor, Diff)
	local h, s, v = BaseColor:ToHSV()

	local p0 = Color3.fromHSV(h, s, v)
	local p1

	Diff = Diff / 100

	if (v - Diff) < 0 then
		p1 = Color3.fromHSV(h, s, 0)
	else
		p1 = Color3.fromHSV(h, s, v - Diff)
	end

	return ColorSequence.new({ ColorSequenceKeypoint.new(0.000, p0), ColorSequenceKeypoint.new(1.000, p1) })
end

function Library:ResizeSection(Section)
	local SectionContainer = Section:WaitForChild("SectionContainer")

	local NumChild = 0
	local ChildOffset = 0

	for i, v in pairs(SectionContainer:GetChildren()) do
		if v:IsA("Frame") then
			NumChild = NumChild + 1
			ChildOffset = ChildOffset + v.Size.Y.Offset
		end
	end

	local NumChildOffset = NumChild * 5

	local ContainerSize = NumChildOffset + ChildOffset + 10
	local SectionSize = ContainerSize + 26

	Library:Tween(SectionContainer, {
		Length = 0.5,
		Goal = { Size = UDim2.new(0, 458, 0, ContainerSize) },
	})

	Library:Tween(Section, {
		Length = 0.5,
		Goal = { Size = UDim2.new(0, 458, 0, SectionSize) },
	})
end

function Library:PlaceDefaults(defaults, options)
	defaults = defaults or {}
	options = options or {}
	for option, value in next, options do
		defaults[option] = value
	end

	return defaults
end

function Library:SetDragSpeed(DragSpeed)
	if DragSpeed < 0 then
		DragSpeed = 0
	end
	if DragSpeed > 100 then
		DragSpeed = 100
	end

	LibSettings.DragSpeed = DragSpeed / 100

	return
end

function Library:SetVolume(Volume)
	if Volume < 0 then
		Volume = 0
	end
	if Volume > 100 then
		Volume = 100
	end

	LibSettings.SoundVolume = Volume / 100

	return
end

function Library:SetHoverSound(SoundID)
	LibSettings.HoverSound = SoundID

	return
end

function Library:SetClickSound(SoundID)
	LibSettings.ClickSound = SoundID

	return
end

function Library:SetPopupSound(SoundID)
	LibSettings.PopupSound = SoundID

	return
end

function Library:PlaySound(SoundID)
	local NotifSound = Instance.new("Sound")
	NotifSound.Name = "NotificationSound"
	NotifSound.SoundId = SoundID
	NotifSound.Parent = game:GetService("SoundService")
	NotifSound.PlaybackSpeed = Random.new():NextNumber(0.98, 1.02)
	NotifSound.Volume = LibSettings.SoundVolume
	NotifSound:Play()

	task.spawn(function()
		NotifSound.Ended:Wait()
		NotifSound:Destroy()
	end)

	return
end

function Library:ToolTip(Text)
	local ToolTip = {}

	Library:PlaySound(LibSettings.HoverSound)

	do
		-- StarterGui.ScreenGui.ToolTip
		ToolTip["2"] = Instance.new("TextLabel", LibFrame["1"])
		ToolTip["2"]["BorderSizePixel"] = 0
		ToolTip["2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
		ToolTip["2"]["TextSize"] = 12
		ToolTip["2"]["Text"] = Text
		ToolTip["2"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
		ToolTip["2"]["Name"] = [[ToolTip]]
		ToolTip["2"]["Font"] = Enum.Font.Gotham
		ToolTip["2"]["BackgroundTransparency"] = 0.5
		ToolTip["2"]["Position"] = UDim2.new(0, Mouse.X, 0, Mouse.Y)
		local Bound = TextService:GetTextSize(
			Text,
			12,
			Enum.Font.Gotham,
			Vector2.new(ToolTip["2"].AbsoluteSize.X, ToolTip["2"].AbsoluteSize.Y)
		)
		ToolTip["2"]["Size"] = UDim2.new(0, (Bound.X + 28), 0, 18)
	end

	local RSSync = RunService.Heartbeat:Connect(function()
		ToolTip["2"].Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
	end)

	do
		function ToolTip:Destroy()
			RSSync:Disconnect()
			ToolTip["2"]:Destroy()
		end
	end

	return ToolTip
end

function Library:SetTheme(Theme)
	Theme = Library:PlaceDefaults({
		Main = ThemeColor.MainTrue,
		Secondary = ThemeColor.SecondaryTrue,
		Tertiary = ThemeColor.TertiaryTrue,
		Text = ThemeColor.Text,
		PlaceholderText = ThemeColor.PlaceholderText,
		Textbox = ThemeColor.Textbox,
		NavBar = ThemeColor.NavBarTrue,
		Theme = ThemeColor.ThemeTrue,
	}, Theme or {})

	Library.CurrentTheme = Theme

	ThemeColor = {
		Main = Library:CalGradient(Theme.Main, 6),
		MainTrue = Theme.Main,
		Secondary = Library:CalGradient(Theme.Secondary, 7),
		SecondaryTrue = Theme.Secondary,
		Tertiary = Library:CalGradient(Theme.Tertiary, 4),
		TertiaryTrue = Theme.Tertiary,
		Text = Theme.Text,
		PlaceholderText = Theme.PlaceholderText,
		Textbox = Theme.Textbox,
		NavBar = Library:CalGradient(Theme.NavBar, 9),
		NavBarTrue = Theme.NavBar,
		Theme = Library:CalGradient(Theme.Theme, 47),
		ThemeTrue = Theme.Theme,
	}

	for i, v in next, ThemeInstances.Main do
		pcall(function()
			v.Color = ThemeColor.Main
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.Main
		end)
	end

	for i, v in next, ThemeInstances.MainTrue do
		pcall(function()
			v.Color = ThemeColor.MainTrue
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.MainTrue
		end)
		pcall(function()
			v.ImageColor3 = ThemeColor.MainTrue
		end)
	end

	for i, v in next, ThemeInstances.Secondary do
		pcall(function()
			v.Color = ThemeColor.Secondary
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.Secondary
		end)
	end

	for i, v in next, ThemeInstances.SecondaryTrue do
		pcall(function()
			v.Color = ThemeColor.SecondaryTrue
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.SecondaryTrue
		end)
	end

	for i, v in next, ThemeInstances.Tertiary do
		pcall(function()
			v.Color = ThemeColor.Tertiary
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.Tertiary
		end)
	end

	for i, v in next, ThemeInstances.TertiaryTrue do
		pcall(function()
			v.Color = ThemeColor.TertiaryTrue
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.TertiaryTrue
		end)
	end

	for i, v in next, ThemeInstances.Text do
		pcall(function()
			v.TextColor3 = ThemeColor.Text
		end)
	end

	for i, v in next, ThemeInstances.PlaceholderText do
		pcall(function()
			v.PlaceholderColor3 = ThemeColor.PlaceholderText
		end)
	end

	for i, v in next, ThemeInstances.Textbox do
		pcall(function()
			v.Color = ThemeColor.Textbox
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.Textbox
		end)
		pcall(function()
			v.ImageColor3 = ThemeColor.Textbox
		end)
	end

	for i, v in next, ThemeInstances.NavBar do
		pcall(function()
			v.Color = ThemeColor.NavBar
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.NavBar
		end)
	end

	for i, v in next, ThemeInstances.Theme do
		pcall(function()
			v.Color = ThemeColor.Theme
		end)
		pcall(function()
			v.BackgroundColor3 = ThemeColor.Theme
		end)
	end

	for i, v in next, ThemeInstances.ThemeTrue do
		pcall(function()
			if v:FindFirstChild("ToggleVal").Value == true then
				v.BackgroundColor3 = ThemeColor.ThemeTrue
			end
		end)
	end

	task.spawn(function()
		task.wait(0.2)

		for i, v in next, ThemeInstances.Main do
			pcall(function()
				v.Color = ThemeColor.Main
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Main
			end)
		end

		for i, v in next, ThemeInstances.MainTrue do
			pcall(function()
				v.Color = ThemeColor.MainTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.MainTrue
			end)
			pcall(function()
				v.ImageColor3 = ThemeColor.MainTrue
			end)
		end

		for i, v in next, ThemeInstances.Secondary do
			pcall(function()
				v.Color = ThemeColor.Secondary
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Secondary
			end)
		end

		for i, v in next, ThemeInstances.SecondaryTrue do
			pcall(function()
				v.Color = ThemeColor.SecondaryTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.SecondaryTrue
			end)
		end

		for i, v in next, ThemeInstances.Tertiary do
			pcall(function()
				v.Color = ThemeColor.Tertiary
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Tertiary
			end)
		end

		for i, v in next, ThemeInstances.TertiaryTrue do
			pcall(function()
				v.Color = ThemeColor.TertiaryTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.TertiaryTrue
			end)
		end

		for i, v in next, ThemeInstances.Text do
			pcall(function()
				v.TextColor3 = ThemeColor.Text
			end)
		end

		for i, v in next, ThemeInstances.PlaceholderText do
			pcall(function()
				v.PlaceholderColor3 = ThemeColor.PlaceholderText
			end)
		end

		for i, v in next, ThemeInstances.Textbox do
			pcall(function()
				v.Color = ThemeColor.Textbox
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Textbox
			end)
			pcall(function()
				v.ImageColor3 = ThemeColor.Textbox
			end)
		end

		for i, v in next, ThemeInstances.NavBar do
			pcall(function()
				v.Color = ThemeColor.NavBar
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.NavBar
			end)
		end

		for i, v in next, ThemeInstances.Theme do
			pcall(function()
				v.Color = ThemeColor.Theme
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Theme
			end)
		end

		for i, v in next, ThemeInstances.ThemeTrue do
			pcall(function()
				if v:FindFirstChild("ToggleVal").Value == true then
					v.BackgroundColor3 = ThemeColor.ThemeTrue
				end
			end)
		end
	end)

	task.spawn(function()
		task.wait(1)

		for i, v in next, ThemeInstances.Main do
			pcall(function()
				v.Color = ThemeColor.Main
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Main
			end)
		end

		for i, v in next, ThemeInstances.MainTrue do
			pcall(function()
				v.Color = ThemeColor.MainTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.MainTrue
			end)
			pcall(function()
				v.ImageColor3 = ThemeColor.MainTrue
			end)
		end

		for i, v in next, ThemeInstances.Secondary do
			pcall(function()
				v.Color = ThemeColor.Secondary
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Secondary
			end)
		end

		for i, v in next, ThemeInstances.SecondaryTrue do
			pcall(function()
				v.Color = ThemeColor.SecondaryTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.SecondaryTrue
			end)
		end

		for i, v in next, ThemeInstances.Tertiary do
			pcall(function()
				v.Color = ThemeColor.Tertiary
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Tertiary
			end)
		end

		for i, v in next, ThemeInstances.TertiaryTrue do
			pcall(function()
				v.Color = ThemeColor.TertiaryTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.TertiaryTrue
			end)
		end

		for i, v in next, ThemeInstances.Text do
			pcall(function()
				v.TextColor3 = ThemeColor.Text
			end)
		end

		for i, v in next, ThemeInstances.PlaceholderText do
			pcall(function()
				v.PlaceholderColor3 = ThemeColor.PlaceholderText
			end)
		end

		for i, v in next, ThemeInstances.Textbox do
			pcall(function()
				v.Color = ThemeColor.Textbox
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Textbox
			end)
			pcall(function()
				v.ImageColor3 = ThemeColor.Textbox
			end)
		end

		for i, v in next, ThemeInstances.NavBar do
			pcall(function()
				v.Color = ThemeColor.NavBar
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.NavBar
			end)
		end

		for i, v in next, ThemeInstances.Theme do
			pcall(function()
				v.Color = ThemeColor.Theme
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Theme
			end)
		end

		for i, v in next, ThemeInstances.ThemeTrue do
			pcall(function()
				if v:FindFirstChild("ToggleVal").Value == true then
					v.BackgroundColor3 = ThemeColor.ThemeTrue
				end
			end)
		end
	end)

	task.spawn(function()
		task.wait(5)

		for i, v in next, ThemeInstances.Main do
			pcall(function()
				v.Color = ThemeColor.Main
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Main
			end)
		end

		for i, v in next, ThemeInstances.MainTrue do
			pcall(function()
				v.Color = ThemeColor.MainTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.MainTrue
			end)
			pcall(function()
				v.ImageColor3 = ThemeColor.MainTrue
			end)
		end

		for i, v in next, ThemeInstances.Secondary do
			pcall(function()
				v.Color = ThemeColor.Secondary
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Secondary
			end)
		end

		for i, v in next, ThemeInstances.SecondaryTrue do
			pcall(function()
				v.Color = ThemeColor.SecondaryTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.SecondaryTrue
			end)
		end

		for i, v in next, ThemeInstances.Tertiary do
			pcall(function()
				v.Color = ThemeColor.Tertiary
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Tertiary
			end)
		end

		for i, v in next, ThemeInstances.TertiaryTrue do
			pcall(function()
				v.Color = ThemeColor.TertiaryTrue
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.TertiaryTrue
			end)
		end

		for i, v in next, ThemeInstances.Text do
			pcall(function()
				v.TextColor3 = ThemeColor.Text
			end)
		end

		for i, v in next, ThemeInstances.PlaceholderText do
			pcall(function()
				v.PlaceholderColor3 = ThemeColor.PlaceholderText
			end)
		end

		for i, v in next, ThemeInstances.Textbox do
			pcall(function()
				v.Color = ThemeColor.Textbox
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Textbox
			end)
			pcall(function()
				v.ImageColor3 = ThemeColor.Textbox
			end)
		end

		for i, v in next, ThemeInstances.NavBar do
			pcall(function()
				v.Color = ThemeColor.NavBar
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.NavBar
			end)
		end

		for i, v in next, ThemeInstances.Theme do
			pcall(function()
				v.Color = ThemeColor.Theme
			end)
			pcall(function()
				v.BackgroundColor3 = ThemeColor.Theme
			end)
		end

		for i, v in next, ThemeInstances.ThemeTrue do
			pcall(function()
				if v:FindFirstChild("ToggleVal").Value == true then
					v.BackgroundColor3 = ThemeColor.ThemeTrue
				end
			end)
		end
	end)
end

function Library:Create(options)
	options = Library:PlaceDefaults({
		Name = "Vision UI Lib v2",
		Footer = "By Loco_CTO, Sius and BruhOOFBoi",
		ToggleKey = Enum.KeyCode.RightShift,
		LoadedCallback = function()
			return
		end,
		KeySystem = false,
		Key = "123456",
		MaxAttempts = 5,
		DiscordLink = nil,
		ToggledRelativeYOffset = nil,
	}, options or {})

	local Gui = {
		CurrentTab = nil,
		CurrentTabIndex = 0,
		TweeningToggle = false,
		ToggleKey = options.ToggleKey,
		Hidden = false,
		MaxAttempts = options.MaxAttempts,
		DiscordLink = options.DiscordLink,
		Key = options.Key,
		KeySystem = options.KeySystem,
	}

	local StartAnimation = {}

	task.spawn(function()
		repeat
			task.wait()
		until Library.Loaded
		options.LoadedCallback()

		if options.ToggledRelativeYOffset ~= nil then
			Library:Tween(Gui["2"], {
				Length = 0.3,
				Goal = { Position = UDim2.new(0.5, 0, 0, Mouse.ViewSizeY - options.ToggledRelativeYOffset - 221) },
			})
		end
	end)

	do
		-- StarterGui.Vision Lib v2.GuiFrame
		Gui["2"] = Instance.new("Frame", LibFrame["1"])
		Gui["2"]["BorderSizePixel"] = 0
		Gui["2"]["AutoLocalize"] = false
		Gui["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Gui["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Gui["2"]["BackgroundTransparency"] = 1
		Gui["2"]["Size"] = UDim2.new(0, 498, 0, 496)
		Gui["2"]["ClipsDescendants"] = true
		Gui["2"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
		Gui["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
		Gui["2"]["Name"] = [[GuiFrame]]
		Gui["2"]["Visible"] = false

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar
		Gui["3"] = Instance.new("Frame", Gui["2"])
		Gui["3"]["ZIndex"] = 2
		Gui["3"]["BorderSizePixel"] = 0
		Gui["3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Gui["3"]["Size"] = UDim2.new(0, 498, 0, 40)
		Gui["3"]["Position"] = UDim2.new(0, 0, 0, 455)
		Gui["3"]["Name"] = [[NavBar]]

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar.UICorner
		Gui["4"] = Instance.new("UICorner", Gui["3"])
		Gui["4"]["CornerRadius"] = UDim.new(0, 4)

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar.Time
		Gui["5"] = Instance.new("TextLabel", Gui["3"])
		Gui["5"]["BorderSizePixel"] = 0
		Gui["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Gui["5"]["TextSize"] = 14
		Gui["5"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Gui["5"]

		Gui["5"]["Size"] = UDim2.new(0, 89, 0, 40)
		Gui["5"]["Text"] = [[14:12]]
		Gui["5"]["Name"] = [[Time]]
		Gui["5"]["Font"] = Enum.Font.GothamBold
		Gui["5"]["BackgroundTransparency"] = 1

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar.TabButtonContainer
		Gui["6"] = Instance.new("ScrollingFrame", Gui["3"])
		Gui["6"]["Active"] = true
		Gui["6"]["ScrollingDirection"] = Enum.ScrollingDirection.X
		Gui["6"]["BorderSizePixel"] = 0
		Gui["6"]["CanvasSize"] = UDim2.new(0, 439, 0, 0)
		Gui["6"]["MidImage"] = [[]]
		Gui["6"]["TopImage"] = [[]]
		Gui["6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Gui["6"]["HorizontalScrollBarInset"] = Enum.ScrollBarInset.Always
		Gui["6"]["BackgroundTransparency"] = 1
		Gui["6"]["Size"] = UDim2.new(0, 350, 0, 40)
		Gui["6"]["ScrollBarThickness"] = 2
		Gui["6"]["Position"] = UDim2.new(0, 86, 0, 0)
		Gui["6"]["Name"] = [[TabButtonContainer]]
		Gui["6"]["BottomImage"] = [[]]

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar.TabButtonContainer.UIListLayout
		Gui["7"] = Instance.new("UIListLayout", Gui["6"])
		Gui["7"]["FillDirection"] = Enum.FillDirection.Horizontal
		Gui["7"]["Padding"] = UDim.new(0, 7)
		Gui["7"]["SortOrder"] = Enum.SortOrder.LayoutOrder

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar.TabButtonContainer.UIPadding
		Gui["c"] = Instance.new("UIPadding", Gui["6"])
		Gui["c"]["PaddingTop"] = UDim.new(0, 6)
		Gui["c"]["PaddingLeft"] = UDim.new(0, 3)

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar.LeftControl
		Gui["15"] = Instance.new("TextButton", Gui["3"])
		Gui["15"]["BorderSizePixel"] = 0
		Gui["15"]["AutoButtonColor"] = false
		Gui["15"]["TextSize"] = 14
		Gui["15"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Gui["15"]["TextColor3"] = Color3.fromRGB(96, 96, 96)
		Gui["15"]["Size"] = UDim2.new(0, 18, 0, 40)
		Gui["15"]["Name"] = [[LeftControl]]
		Gui["15"]["Text"] = [[<]]
		Gui["15"]["Font"] = Enum.Font.GothamBold
		Gui["15"]["Position"] = UDim2.new(0, 458, 0, 0)
		Gui["15"]["BackgroundTransparency"] = 1

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar.RightControl
		Gui["16"] = Instance.new("TextButton", Gui["3"])
		Gui["16"]["BorderSizePixel"] = 0
		Gui["16"]["AutoButtonColor"] = false
		Gui["16"]["TextSize"] = 14
		Gui["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Gui["16"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Gui["16"]
		Gui["16"]["Size"] = UDim2.new(0, 18, 0, 40)
		Gui["16"]["Name"] = [[RightControl]]
		Gui["16"]["Text"] = [[>]]
		Gui["16"]["Font"] = Enum.Font.GothamBold
		Gui["16"]["Position"] = UDim2.new(0, 475, 0, 0)
		Gui["16"]["BackgroundTransparency"] = 1

		-- StarterGui.Vision Lib v2.GuiFrame.NavBar.UIGradient
		Gui["17"] = Instance.new("UIGradient", Gui["3"])
		Gui["17"]["Rotation"] = 90
		Gui["17"]["Color"] = ThemeColor.NavBar

		ThemeInstances["NavBar"][#ThemeInstances["NavBar"] + 1] = Gui["17"]

		-- StarterGui.Vision Lib v2.GuiFrame.MainFrame
		Gui["18"] = Instance.new("Frame", Gui["2"])
		Gui["18"]["BorderSizePixel"] = 0
		Gui["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Gui["18"]["Size"] = UDim2.new(0, 498, 0, 452)
		Gui["18"]["Name"] = [[MainFrame]]
		Gui["18"]["ClipsDescendants"] = true

		-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.UICorner
		Gui["19"] = Instance.new("UICorner", Gui["18"])
		Gui["19"]["CornerRadius"] = UDim.new(0, 4)

		-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.UIGradient
		Gui["1a"] = Instance.new("UIGradient", Gui["18"])
		Gui["1a"]["Rotation"] = 90
		Gui["1a"]["Color"] = ThemeColor.Main

		ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Gui["1a"]

		-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Seperator
		Gui["1b"] = Instance.new("Frame", Gui["18"])
		Gui["1b"]["ZIndex"] = 2
		Gui["1b"]["BorderSizePixel"] = 0
		Gui["1b"]["BackgroundColor3"] = ThemeColor.Textbox

		ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Gui["1b"]

		Gui["1b"]["Size"] = UDim2.new(0, 496, 0, 2)
		Gui["1b"]["BorderColor3"] = ThemeColor.Textbox

		ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Gui["1b"]

		Gui["1b"]["Position"] = UDim2.new(0, 0, 0, 33)
		Gui["1b"]["Name"] = [[Seperator]]

		-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Title
		Gui["1c"] = Instance.new("TextLabel", Gui["18"])
		Gui["1c"]["BorderSizePixel"] = 0
		Gui["1c"]["TextXAlignment"] = Enum.TextXAlignment.Left
		Gui["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Gui["1c"]["TextSize"] = 15
		Gui["1c"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Gui["1c"]
		Gui["1c"]["Size"] = UDim2.new(0, 212, 0, 27)
		Gui["1c"]["Text"] = [[Home Tab]]
		Gui["1c"]["Name"] = [[Title]]
		Gui["1c"]["Font"] = Enum.Font.GothamBold
		Gui["1c"]["BackgroundTransparency"] = 1
		Gui["1c"]["Position"] = UDim2.new(0, 14, 0, 5)
	end

	function Library:ResizeTabCanvas()
		local NumChild = 0
		local ChildOffset = 0

		for i, v in pairs(Gui["6"]:GetChildren()) do
			if v:IsA("TextButton") then
				NumChild = NumChild + 1
				ChildOffset = ChildOffset + v.Size.X.Offset
			end
		end

		local NumChildOffset = NumChild * 7

		local CanvasSizeX = NumChildOffset + ChildOffset + 7

		Library:Tween(Gui["6"], {
			Length = 0.5,
			Goal = { CanvasSize = UDim2.new(0, CanvasSizeX, 0, 0) },
		})

		task.spawn(function()
			task.wait(1)

			local MaxPos = Gui["6"].CanvasSize.X.Offset - Gui["6"].Size.X.Offset

			if Gui["6"].CanvasPosition.X > 0 then
				Library:Tween(Gui["15"], {
					Length = 0.1,
					Goal = { TextColor3 = Color3.fromRGB(255, 255, 255) },
				})
			else
				Library:Tween(Gui["15"], {
					Length = 0.1,
					Goal = { TextColor3 = Color3.fromRGB(96, 96, 96) },
				})
			end

			if Gui["6"].CanvasPosition.X < MaxPos then
				Library:Tween(Gui["16"], {
					Length = 0.1,
					Goal = { TextColor3 = Color3.fromRGB(255, 255, 255) },
				})
			else
				Library:Tween(Gui["16"], {
					Length = 0.1,
					Goal = { TextColor3 = Color3.fromRGB(96, 96, 96) },
				})
			end
		end)
	end

	table.insert(
		ConnectionBin,
		Gui["6"]:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			local MaxPos = Gui["6"].CanvasSize.X.Offset - Gui["6"].Size.X.Offset

			if Gui["6"].CanvasPosition.X > 0 then
				Library:Tween(Gui["15"], {
					Length = 0.1,
					Goal = { TextColor3 = Color3.fromRGB(255, 255, 255) },
				})
			else
				Library:Tween(Gui["15"], {
					Length = 0.1,
					Goal = { TextColor3 = Color3.fromRGB(96, 96, 96) },
				})
			end

			if Gui["6"].CanvasPosition.X < MaxPos then
				Library:Tween(Gui["16"], {
					Length = 0.1,
					Goal = { TextColor3 = Color3.fromRGB(255, 255, 255) },
				})
			else
				Library:Tween(Gui["16"], {
					Length = 0.1,
					Goal = { TextColor3 = Color3.fromRGB(96, 96, 96) },
				})
			end
		end)
	)

	do
		-- StarterGui.Vision Lib v2.StartAnimationFrame
		StartAnimation["91"] = Instance.new("Frame", LibFrame["1"])
		StartAnimation["91"]["BorderSizePixel"] = 0
		StartAnimation["91"]["AutoLocalize"] = false
		StartAnimation["91"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		StartAnimation["91"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
		StartAnimation["91"]["BackgroundTransparency"] = 1
		StartAnimation["91"]["Size"] = UDim2.new(0, 498, 0, 498)
		StartAnimation["91"]["ClipsDescendants"] = true
		StartAnimation["91"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
		StartAnimation["91"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
		StartAnimation["91"]["Name"] = [[StartAnimationFrame]]

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main
		StartAnimation["92"] = Instance.new("Frame", StartAnimation["91"])
		StartAnimation["92"]["ZIndex"] = 2
		StartAnimation["92"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		StartAnimation["92"]["Size"] = UDim2.new(0, 310, 0, 0)
		StartAnimation["92"]["Position"] = UDim2.new(0.186, 0, 0.167, 0)
		StartAnimation["92"]["Name"] = [[Main]]
		StartAnimation["92"]["ClipsDescendants"] = true
		StartAnimation["92"]["BorderSizePixel"] = 0

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.UIGradient
		StartAnimation["93"] = Instance.new("UIGradient", StartAnimation["92"])
		StartAnimation["93"]["Rotation"] = 90
		StartAnimation["93"]["Color"] = ThemeColor.Main

		ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = StartAnimation["93"]

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.UICorner
		StartAnimation["94"] = Instance.new("UICorner", StartAnimation["92"])
		StartAnimation["94"]["CornerRadius"] = UDim.new(0, 4)

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.Title
		StartAnimation["95"] = Instance.new("TextLabel", StartAnimation["92"])
		StartAnimation["95"]["ZIndex"] = 2
		StartAnimation["95"]["BorderSizePixel"] = 0
		StartAnimation["95"]["TextXAlignment"] = Enum.TextXAlignment.Left
		StartAnimation["95"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		StartAnimation["95"]["TextSize"] = 20
		StartAnimation["95"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = StartAnimation["95"]
		StartAnimation["95"]["Size"] = UDim2.new(0, 255, 0, 32)
		StartAnimation["95"]["Text"] = options.Name
		StartAnimation["95"]["Name"] = [[Title]]
		StartAnimation["95"]["Font"] = Enum.Font.GothamMedium
		StartAnimation["95"]["BackgroundTransparency"] = 1
		StartAnimation["95"]["Position"] = UDim2.new(0, 10, 0, 5)

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.Title
		StartAnimation["96"] = Instance.new("TextLabel", StartAnimation["92"])
		StartAnimation["96"]["ZIndex"] = 2
		StartAnimation["96"]["BorderSizePixel"] = 0
		StartAnimation["96"]["TextXAlignment"] = Enum.TextXAlignment.Left
		StartAnimation["96"]["TextYAlignment"] = Enum.TextYAlignment.Top
		StartAnimation["96"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		StartAnimation["96"]["TextSize"] = 11
		StartAnimation["96"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = StartAnimation["96"]
		StartAnimation["96"]["Size"] = UDim2.new(0, 255, 0, 18)
		StartAnimation["96"]["Text"] = options.Footer
		StartAnimation["96"]["Name"] = [[Title]]
		StartAnimation["96"]["Font"] = Enum.Font.Gotham
		StartAnimation["96"]["BackgroundTransparency"] = 1
		StartAnimation["96"]["Position"] = UDim2.new(0, 12, 0, 32)

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.LoadBack
		StartAnimation["97"] = Instance.new("Frame", StartAnimation["92"])
		StartAnimation["97"]["ZIndex"] = 2
		StartAnimation["97"]["BackgroundColor3"] = ThemeColor.Textbox

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = StartAnimation["97"]

		StartAnimation["97"]["Size"] = UDim2.new(0, 285, 0, 6)
		StartAnimation["97"]["Position"] = UDim2.new(0.03870967775583267, 0, 0.942219614982605, 0)
		StartAnimation["97"]["Name"] = [[LoadBack]]

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.LoadBack.UICorner
		StartAnimation["98"] = Instance.new("UICorner", StartAnimation["97"])
		StartAnimation["98"]["CornerRadius"] = UDim.new(0, 7)

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.LoadBack.LoadFront
		StartAnimation["99"] = Instance.new("Frame", StartAnimation["97"])
		StartAnimation["99"]["ZIndex"] = 2
		StartAnimation["99"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		StartAnimation["99"]["Size"] = UDim2.new(0.035087719559669495, 0, 1, 0)
		StartAnimation["99"]["Position"] = UDim2.new(-0.007017544005066156, 0, 0, 0)
		StartAnimation["99"]["Name"] = [[LoadFront]]

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.LoadBack.LoadFront.UICorner
		StartAnimation["9a"] = Instance.new("UICorner", StartAnimation["99"])
		StartAnimation["9a"]["CornerRadius"] = UDim.new(0, 7)

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.LoadBack.LoadFront.UIGradient
		StartAnimation["9b"] = Instance.new("UIGradient", StartAnimation["99"])
		StartAnimation["9b"]["Color"] = ThemeColor.Tertiary

		ThemeInstances["Tertiary"][#ThemeInstances["Tertiary"] + 1] = StartAnimation["9b"]

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.CharAva
		StartAnimation["9c"] = Instance.new("ImageLabel", StartAnimation["92"])
		StartAnimation["9c"]["ZIndex"] = 2
		StartAnimation["9c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		StartAnimation["9c"]["Image"] = Players:GetUserThumbnailAsync(
			LocalPlayer.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size100x100
		)
		StartAnimation["9c"]["Size"] = UDim2.new(0, 70, 0, 70)
		StartAnimation["9c"]["Name"] = [[CharAva]]
		StartAnimation["9c"]["Position"] = UDim2.new(0, 12, 0, 49)
		StartAnimation["9c"]["BackgroundTransparency"] = 1
		StartAnimation["9c"]["ImageTransparency"] = 1

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.CharAva.UICorner
		StartAnimation["9d"] = Instance.new("UICorner", StartAnimation["9c"])
		StartAnimation["9d"]["CornerRadius"] = UDim.new(1, 8)

		-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.WelcomeText
		StartAnimation["9e"] = Instance.new("TextLabel", StartAnimation["92"])
		StartAnimation["9e"]["TextWrapped"] = true
		StartAnimation["9e"]["ZIndex"] = 2
		StartAnimation["9e"]["TextXAlignment"] = Enum.TextXAlignment.Left
		StartAnimation["9e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		StartAnimation["9e"]["TextSize"] = 19
		StartAnimation["9e"]["TextTransparency"] = 1
		StartAnimation["9e"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = StartAnimation["9e"]
		StartAnimation["9e"]["Size"] = UDim2.new(0, 282, 0, 70)
		StartAnimation["9e"]["Text"] = [[Welcome, ]] .. Players.LocalPlayer.Name
		StartAnimation["9e"]["Name"] = [[WelcomeText]]
		StartAnimation["9e"]["Font"] = Enum.Font.GothamMedium
		StartAnimation["9e"]["BackgroundTransparency"] = 1
		StartAnimation["9e"]["Position"] = UDim2.new(0, 98, 0, 49)
	end

	local KeySystem = {}

	-- Start animation
	do
		task.spawn(function()
			Library.Sliding = true

			Library:Tween(StartAnimation["92"], {
				Length = 1,
				Goal = { Size = UDim2.new(0, 310, 0, 230) },
			})

			task.wait(1)

			Library:Tween(StartAnimation["99"], {
				Length = 0.5,
				Direction = Enum.EasingDirection.In,
				Goal = { Size = UDim2.new(1, 0, 1, 0) },
			})
			task.wait(0.6)

			Library:Tween(StartAnimation["97"], {
				Length = 0.5,
				Goal = { BackgroundTransparency = 1 },
			})

			Library:Tween(StartAnimation["99"], {
				Length = 0.5,
				Goal = { BackgroundTransparency = 1 },
			})

			local KeyChecked = false

			if options.KeySystem then
				KeySystem = {
					CorrectKey = false,
					KeyTextboxHover = false,
					Attempts = Gui.MaxAttempts,
				}

				local KeyConnectionBin = {}

				do
					-- StarterGui.Vision Lib v2.StartAnimationFrame.Main.Key
					KeySystem["a0"] = Instance.new("Frame", StartAnimation["92"])
					KeySystem["a0"]["ZIndex"] = 3
					KeySystem["a0"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = KeySystem["a0"]

					KeySystem["a0"]["Size"] = UDim2.new(0, 253, 0, 20)
					KeySystem["a0"]["Position"] = UDim2.new(0, 28, 0, 33)
					KeySystem["a0"]["Name"] = [[Key]]

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.Key.UICorner
					KeySystem["a1"] = Instance.new("UICorner", KeySystem["a0"])
					KeySystem["a1"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.Key.UIStroke
					KeySystem["a2"] = Instance.new("UIStroke", KeySystem["a0"])
					KeySystem["a2"]["Color"] = ThemeColor.MainTrue

					ThemeInstances["MainTrue"][#ThemeInstances["MainTrue"] + 1] = KeySystem["a2"]

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.Key.TextBox
					KeySystem["a4"] = Instance.new("TextBox", KeySystem["a0"])
					KeySystem["a4"]["CursorPosition"] = -1
					KeySystem["a4"]["PlaceholderColor3"] = ThemeColor.PlaceholderText

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = KeySystem["a4"]

					KeySystem["a4"]["ZIndex"] = 3
					KeySystem["a4"]["RichText"] = true
					KeySystem["a4"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = KeySystem["a4"]
					KeySystem["a4"]["TextXAlignment"] = Enum.TextXAlignment.Left
					KeySystem["a4"]["TextSize"] = 11
					KeySystem["a4"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = KeySystem["a4"]

					KeySystem["a4"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
					KeySystem["a4"]["PlaceholderText"] = [[Key | e.g abc123]]
					KeySystem["a4"]["Size"] = UDim2.new(0.8999999761581421, 0, 0.8999999761581421, 0)
					KeySystem["a4"]["Text"] = [[]]
					KeySystem["a4"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
					KeySystem["a4"]["Font"] = Enum.Font.Gotham

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.Key.TextBox.UICorner
					KeySystem["a5"] = Instance.new("UICorner", KeySystem["a4"])
					KeySystem["a5"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.KeySystemTitle
					KeySystem["a6"] = Instance.new("TextLabel", StartAnimation["92"])
					KeySystem["a6"]["ZIndex"] = 2
					KeySystem["a6"]["BorderSizePixel"] = 0
					KeySystem["a6"]["TextXAlignment"] = Enum.TextXAlignment.Left
					KeySystem["a6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					KeySystem["a6"]["TextSize"] = 11
					KeySystem["a6"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = KeySystem["a6"]
					KeySystem["a6"]["Size"] = UDim2.new(0, 158, 0, 16)
					KeySystem["a6"]["Text"] = [[Key System]]
					KeySystem["a6"]["Name"] = [[KeySystemTitle]]
					KeySystem["a6"]["Font"] = Enum.Font.GothamMedium
					KeySystem["a6"]["BackgroundTransparency"] = 1
					KeySystem["a6"]["Position"] = UDim2.new(0, 34, 0, 14)

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.KeySystemNote
					KeySystem["a8"] = Instance.new("Frame", StartAnimation["92"])
					KeySystem["a8"]["ZIndex"] = 3
					KeySystem["a8"]["BackgroundColor3"] = ThemeColor.TertiaryTrue
					KeySystem["a8"]["Size"] = UDim2.new(0, 215, 0, 50)
					KeySystem["a8"]["Position"] = UDim2.new(0, 49, 0, 61)
					KeySystem["a8"]["Name"] = [[KeySystemNote]]

					ThemeInstances["TertiaryTrue"][#ThemeInstances["TertiaryTrue"] + 1] = KeySystem["a8"]

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.KeySystemNote.TextLabel
					KeySystem["a9"] = Instance.new("TextLabel", KeySystem["a8"])
					KeySystem["a9"]["TextWrapped"] = true
					KeySystem["a9"]["ZIndex"] = 2
					KeySystem["a9"]["TextXAlignment"] = Enum.TextXAlignment.Left
					KeySystem["a9"]["TextYAlignment"] = Enum.TextYAlignment.Top
					KeySystem["a9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					KeySystem["a9"]["TextSize"] = 9
					KeySystem["a9"]["TextColor3"] = ThemeColor.PlaceholderText

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = KeySystem["a9"]

					KeySystem["a9"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
					KeySystem["a9"]["Size"] = UDim2.new(0.949999988079071, 0, 0.800000011920929, 0)
					KeySystem["a9"]["Text"] = [[Note: Join our discord to get the key!]]
					KeySystem["a9"]["Font"] = Enum.Font.Gotham
					KeySystem["a9"]["BackgroundTransparency"] = 1
					KeySystem["a9"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)

					KeySystem["a0"]["BackgroundTransparency"] = 1
					KeySystem["a4"]["BackgroundTransparency"] = 1
					KeySystem["a8"]["BackgroundTransparency"] = 1
					KeySystem["a4"]["TextTransparency"] = 1
					KeySystem["a9"]["TextTransparency"] = 1
					KeySystem["a6"]["TextTransparency"] = 1

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.KeySystemNote.UICorner
					KeySystem["aa"] = Instance.new("UICorner", KeySystem["a8"])

					-- Methods
					do
						table.insert(
							KeyConnectionBin,
							KeySystem["a0"].MouseEnter:Connect(function()
								Library:Tween(KeySystem["a2"], {
									Length = 0.2,
									Goal = { Color = ThemeColor.SecondaryTrue },
								})

								KeySystem.KeyTextboxHover = true
								Library:PlaySound(LibSettings.HoverSound)
							end)
						)

						table.insert(
							KeyConnectionBin,
							KeySystem["a0"].MouseLeave:Connect(function()
								Library:Tween(KeySystem["a2"], {
									Length = 0.2,
									Goal = { Color = ThemeColor.MainTrue },
								})

								KeySystem.KeyTextboxHover = false
							end)
						)

						table.insert(
							KeyConnectionBin,
							KeySystem["a4"].FocusLost:Connect(function()
								local keyEntered = KeySystem["a4"]["Text"]

								if keyEntered ~= "" then
									if keyEntered == Gui.Key then
										KeySystem.CorrectKey = true

										Library:ForceNotify({
											Name = "KeySystem",
											Text = "Correct key!",
											Icon = "rbxassetid://11401835376",
											Duration = 3,
										})
									else
										KeySystem.Attempts = KeySystem.Attempts - 1

										Library:ForceNotify({
											Name = "KeySystem",
											Text = "Incorrect key! You still have "
												.. tostring(KeySystem.Attempts)
												.. " attempts left!",
											Icon = "rbxassetid://11401835376",
											Duration = 3,
										})
									end

									KeySystem["a4"]["Text"] = ""

									if KeySystem.Attempts == 0 then
										game.Players.LocalPlayer:Kick("Too many failed attempts")
									end

									if KeySystem.KeyTextboxHover then
										Library:Tween(KeySystem["a2"], {
											Length = 0.2,
											Goal = { Color = Color3.fromRGB(93, 93, 93) },
										})
									else
										Library:Tween(KeySystem["a2"], {
											Length = 0.2,
											Goal = { Color = ThemeColor.SecondaryTrue },
										})
									end
								end
							end)
						)
					end
				end

				do
					-- Others tween
					do
						Library:Tween(StartAnimation["92"], {
							Length = 1,
							Goal = { Position = UDim2.new(0, 92, 0, 159) },
						})

						Library:Tween(StartAnimation["92"], {
							Length = 1,
							Goal = { Size = UDim2.new(0, 310, 0, 154) },
						})

						Library:Tween(StartAnimation["96"], {
							Length = 0.7,
							Goal = { TextTransparency = 1 },
						})

						Library:Tween(StartAnimation["95"], {
							Length = 0.7,
							Goal = { TextTransparency = 1 },
						})
					end

					task.wait(1)

					-- Ui tween
					do
						Library:Tween(KeySystem["a4"], {
							Length = 0.7,
							Goal = { TextTransparency = 0 },
						})

						Library:Tween(KeySystem["a9"], {
							Length = 0.7,
							Goal = { TextTransparency = 0 },
						})

						Library:Tween(KeySystem["a6"], {
							Length = 0.7,
							Goal = { TextTransparency = 0 },
						})

						Library:Tween(KeySystem["a8"], {
							Length = 0.7,
							Goal = { BackgroundTransparency = 0 },
						})

						Library:Tween(KeySystem["a4"], {
							Length = 0.7,
							Goal = { BackgroundTransparency = 0 },
						})

						Library:Tween(KeySystem["a0"], {
							Length = 0.7,
							Goal = { BackgroundTransparency = 0 },
						})
					end
				end

				if Gui.DiscordLink ~= nil then
					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.DiscordServerButton
					KeySystem["ab"] = Instance.new("TextButton", StartAnimation["92"])
					KeySystem["ab"]["TextStrokeTransparency"] = 0
					KeySystem["ab"]["ZIndex"] = 3
					KeySystem["ab"]["AutoButtonColor"] = false
					KeySystem["ab"]["TextSize"] = 12
					KeySystem["ab"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					KeySystem["ab"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = KeySystem["ab"]
					KeySystem["ab"]["Size"] = UDim2.new(0, 100, 0, 19)
					KeySystem["ab"]["Name"] = [[DiscordServerButton]]
					KeySystem["ab"]["Text"] = [[Copy discord invite]]
					KeySystem["ab"]["Font"] = Enum.Font.Gotham
					KeySystem["ab"]["Position"] = UDim2.new(0, 104, 0, 118)
					KeySystem["ab"]["MaxVisibleGraphemes"] = 0

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.DiscordServerButton.TextLabel
					KeySystem["ac"] = Instance.new("TextLabel", KeySystem["ab"])
					KeySystem["ac"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					KeySystem["ac"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255)
					KeySystem["ac"]["TextSize"] = 9
					KeySystem["ac"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = KeySystem["ac"]
					KeySystem["ac"]["Size"] = UDim2.new(1, 0, 1, 0)
					KeySystem["ac"]["Text"] = [[Copy discord invite]]
					KeySystem["ac"]["Font"] = Enum.Font.GothamMedium
					KeySystem["ac"]["BackgroundTransparency"] = 1

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.DiscordServerButton.UIStroke
					KeySystem["ad"] = Instance.new("UIStroke", KeySystem["ab"])
					KeySystem["ad"]["Color"] = Color3.fromRGB(89, 102, 243)
					KeySystem["ad"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.DiscordServerButton.UIGradient
					KeySystem["ae"] = Instance.new("UIGradient", KeySystem["ab"])
					KeySystem["ae"]["Rotation"] = 90
					KeySystem["ae"]["Color"] = ColorSequence.new({
						ColorSequenceKeypoint.new(0.000, Color3.fromRGB(89, 102, 243)),
						ColorSequenceKeypoint.new(0.516, Color3.fromRGB(78, 90, 213)),
						ColorSequenceKeypoint.new(1.000, Color3.fromRGB(63, 74, 172)),
					})

					-- StarterGui.Vision Lib v2.KeySystemFrame.Main.DiscordServerButton.UICorner
					KeySystem["af"] = Instance.new("UICorner", KeySystem["ab"])
					KeySystem["af"]["CornerRadius"] = UDim.new(0, 4)

					KeySystem["ab"]["BackgroundTransparency"] = 1
					KeySystem["ac"]["TextTransparency"] = 1
					KeySystem["ad"]["Transparency"] = 1

					do
						Library:Tween(KeySystem["ad"], {
							Length = 0.7,
							Goal = { Transparency = 0 },
						})

						Library:Tween(KeySystem["ab"], {
							Length = 0.7,
							Goal = { BackgroundTransparency = 0 },
						})

						Library:Tween(KeySystem["ac"], {
							Length = 0.7,
							Goal = { TextTransparency = 0 },
						})
					end

					-- Handler
					do
						table.insert(
							KeyConnectionBin,
							KeySystem["ab"].MouseEnter:Connect(function()
								Library:Tween(KeySystem["ad"], {
									Length = 0.2,
									Goal = { Color = Color3.fromRGB(137, 145, 213) },
								})

								Library:PlaySound(LibSettings.HoverSound)
							end)
						)

						table.insert(
							KeyConnectionBin,
							KeySystem["ab"].MouseLeave:Connect(function()
								Library:Tween(KeySystem["ad"], {
									Length = 0.2,
									Goal = { Color = Color3.fromRGB(89, 102, 243) },
								})
							end)
						)

						table.insert(
							KeyConnectionBin,
							KeySystem["ab"].MouseButton1Click:Connect(function()
								Library:PlaySound(LibSettings.ClickSound)
								task.spawn(function()
									Library:ForceNotify({
										Name = "Discord",
										Text = "Copied the discord link to clipboard!",
										Icon = "rbxassetid://11401835376",
										Duration = 3,
									})

									Library:Tween(KeySystem["ad"], {
										Length = 0.2,
										Goal = { Color = Color3.fromRGB(183, 188, 213) },
									})

									task.wait(0.2)

									Library:Tween(KeySystem["ad"], {
										Length = 0.2,
										Goal = { Color = Color3.fromRGB(137, 145, 213) },
									})
								end)

								pcall(function()
									setclipboard(Gui.DiscordLink)
								end)
							end)
						)
					end
				end

				repeat
					task.wait()
				until KeySystem.CorrectKey

				do
					do
						Library:Tween(KeySystem["a4"], {
							Length = 0.7,
							Goal = { TextTransparency = 1 },
						})

						Library:Tween(KeySystem["a9"], {
							Length = 0.7,
							Goal = { TextTransparency = 1 },
						})

						Library:Tween(KeySystem["a6"], {
							Length = 0.7,
							Goal = { TextTransparency = 1 },
						})

						Library:Tween(KeySystem["a8"], {
							Length = 0.7,
							Goal = { BackgroundTransparency = 1 },
						})

						Library:Tween(KeySystem["a4"], {
							Length = 0.7,
							Goal = { BackgroundTransparency = 1 },
						})

						Library:Tween(KeySystem["a0"], {
							Length = 0.7,
							Goal = { BackgroundTransparency = 1 },
						})

						Library:Tween(KeySystem["a2"], {
							Length = 0.7,
							Goal = { Transparency = 1 },
						})
					end

					if Gui.DiscordLink ~= nil then
						do
							Library:Tween(KeySystem["ad"], {
								Length = 0.7,
								Goal = { Transparency = 1 },
							})

							Library:Tween(KeySystem["ab"], {
								Length = 0.7,
								Goal = { BackgroundTransparency = 1 },
							})

							Library:Tween(KeySystem["ac"], {
								Length = 0.7,
								Goal = { TextTransparency = 1 },
							})
						end
					end
				end

				task.wait(1)

				Library:Tween(StartAnimation["96"], {
					Length = 0.7,
					Goal = { TextTransparency = 0 },
				})

				Library:Tween(StartAnimation["95"], {
					Length = 0.7,
					Goal = { TextTransparency = 0 },
				})

				task.spawn(function()
					task.wait(1)
					KeySystem["a0"]:Destroy()

					for i, v in next, KeyConnectionBin do
						v:Disconnect()
					end
				end)

				KeyChecked = true
			else
				KeyChecked = true
			end

			repeat
				task.wait()
			until KeyChecked

			task.wait(0.3)

			Library:Tween(StartAnimation["92"], {
				Length = 1,
				Goal = { Position = UDim2.new(0, 0, 0, 0) },
			})

			Library:Tween(StartAnimation["92"], {
				Length = 1,
				Goal = { Size = UDim2.new(0, 498, 0, 452) },
			})

			Library:Tween(StartAnimation["9e"], {
				Length = 0.7,
				Goal = { TextTransparency = 0 },
			})

			Library:Tween(StartAnimation["9c"], {
				Length = 0.7,
				Goal = { ImageTransparency = 0 },
			})

			Library:Tween(StartAnimation["9c"], {
				Length = 0.7,
				Goal = { BackgroundTransparency = 0 },
			})

			task.wait(1)

			Gui["2"]["Size"] = UDim2.new(0, 498, 0, 0)
			Gui["2"]["Visible"] = true

			task.wait(1.8)

			Library:Tween(StartAnimation["96"], {
				Length = 0.7,
				Goal = { TextTransparency = 1 },
			})

			Library:Tween(StartAnimation["95"], {
				Length = 0.7,
				Goal = { TextTransparency = 1 },
			})

			Library:Tween(StartAnimation["9e"], {
				Length = 0.7,
				Goal = { TextTransparency = 1 },
			})

			Library:Tween(StartAnimation["9c"], {
				Length = 0.7,
				Goal = { ImageTransparency = 1 },
			})

			Library:Tween(StartAnimation["9c"], {
				Length = 0.7,
				Goal = { BackgroundTransparency = 1 },
			})

			task.wait(0.1)

			Gui["3"]["Position"] = UDim2.new(0, 0, 0, 300)
			Gui["2"]["Size"] = UDim2.new(0, 498, 0, 498)

			Library:Tween(Gui["3"], {
				Length = 1.5,
				Goal = { Position = UDim2.new(0, 0, 0, 455) },
			})

			task.wait(2)

			Library:Tween(StartAnimation["92"], {
				Length = 0.5,
				Goal = { BackgroundTransparency = 1 },
			})

			Library.Sliding = false
			Library.Loaded = true

			task.spawn(function()
				task.wait(1)

				Library:SetTheme({})
			end)
		end)
	end

	function Gui:Tab(options)
		options = Library:PlaceDefaults({
			Name = "Tab",
			Icon = "rbxassetid://11396131982",
			Color = Color3.new(1, 0.290196, 0.290196),
			ActivationCallback = function()
				return
			end,
			DeativationCallback = function()
				return
			end,
		}, options or {})

		local Tab = {
			Active = false,
			Hover = false,
			Index = TabIndex,
		}

		TabIndex = TabIndex + 1

		if Gui.KeySystem then
			repeat
				task.wait()
			until KeySystem.CorrectKey
		end

		do
			-- StarterGui.Vision Lib v2.GuiFrame.NavBar.TabButtonContainer.TabButton
			Tab["8"] = Instance.new("TextButton", Gui["6"])
			Tab["8"]["BorderSizePixel"] = 0
			Tab["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
			Tab["8"]["Size"] = UDim2.new(0, 28, 0, 28)
			Tab["8"]["Name"] = [[TabButton]]
			Tab["8"]["Text"] = [[]]
			Tab["8"]["AutoButtonColor"] = true

			-- StarterGui.Vision Lib v2.GuiFrame.NavBar.TabButtonContainer.TabButton.UICorner
			Tab["9"] = Instance.new("UICorner", Tab["8"])
			Tab["9"]["CornerRadius"] = UDim.new(0, 5)

			-- StarterGui.Vision Lib v2.GuiFrame.NavBar.TabButtonContainer.TabButton.UIGradient
			Tab["a"] = Instance.new("UIGradient", Tab["8"])
			Tab["a"]["Rotation"] = 45
			Tab["a"]["Color"] = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 125, 125)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(31, 31, 31)),
			})

			-- StarterGui.Vision Lib v2.GuiFrame.NavBar.TabButtonContainer.TabButton.ImageLabel
			Tab["b"] = Instance.new("ImageLabel", Tab["8"])
			Tab["b"]["ZIndex"] = 2
			Tab["b"]["BorderSizePixel"] = 0
			Tab["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
			Tab["b"]["ImageColor3"] = Color3.fromRGB(245, 245, 245)
			Tab["b"]["Image"] = options.Icon
			Tab["b"]["Size"] = UDim2.new(0, 22, 0, 22)
			Tab["b"]["BackgroundTransparency"] = 1
			Tab["b"]["Position"] = UDim2.new(0.1071428582072258, 0, 0.1071428582072258, 0)
		end

		-- Container
		do
			-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container
			Tab["1d"] = Instance.new("ScrollingFrame", Gui["18"])
			Tab["1d"]["Active"] = true
			Tab["1d"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
			Tab["1d"]["BorderSizePixel"] = 0
			Tab["1d"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
			Tab["1d"]["CanvasPosition"] = Vector2.new(0, 150)
			Tab["1d"]["ScrollBarImageTransparency"] = 1
			Tab["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
			Tab["1d"]["BackgroundTransparency"] = 1
			Tab["1d"]["Size"] = UDim2.new(0, 498, 0, 417)
			Tab["1d"]["ScrollBarImageColor3"] = Color3.fromRGB(20, 20, 20)
			Tab["1d"]["ScrollBarThickness"] = 5
			Tab["1d"]["Position"] = UDim2.new(0, 0, 0, 35)
			Tab["1d"]["Name"] = [[Container]]
			Tab["1d"]["Visible"] = false

			-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.UIPadding
			Tab["7c"] = Instance.new("UIPadding", Tab["1d"])
			Tab["7c"]["PaddingTop"] = UDim.new(0, 5)
			Tab["7c"]["PaddingLeft"] = UDim.new(0, 20)

			-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.UIListLayout
			Tab["7d"] = Instance.new("UIListLayout", Tab["1d"])
			Tab["7d"]["Padding"] = UDim.new(0, 5)
			Tab["7d"]["SortOrder"] = Enum.SortOrder.LayoutOrder
		end

		function Tab:Section(options)
			options = Library:PlaceDefaults({
				Name = "Section",
			}, options or {})

			local Section = {}

			-- Section and Container
			do
				-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame
				Section["1e"] = Instance.new("Frame", Tab["1d"])
				Section["1e"]["BorderSizePixel"] = 0
				Section["1e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
				Section["1e"]["Size"] = UDim2.new(0, 458, 0, 385)
				Section["1e"]["Position"] = UDim2.new(0, 0, 0, -150)
				Section["1e"]["Name"] = [[SectionFrame]]

				-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.UIGradient
				Section["1f"] = Instance.new("UIGradient", Section["1e"])
				Section["1f"]["Rotation"] = 90
				Section["1f"]["Color"] = ThemeColor.Secondary

				ThemeInstances["Secondary"][#ThemeInstances["Secondary"] + 1] = Section["1f"]

				-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionLabel
				Section["20"] = Instance.new("TextLabel", Section["1e"])
				Section["20"]["BorderSizePixel"] = 0
				Section["20"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Section["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
				Section["20"]["TextSize"] = 12
				Section["20"]["TextColor3"] = ThemeColor.Text

				ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Section["20"]
				Section["20"]["Size"] = UDim2.new(0, 408, 0, 18)
				Section["20"]["Text"] = options.Name
				Section["20"]["Name"] = [[SectionLabel]]
				Section["20"]["Font"] = Enum.Font.GothamMedium
				Section["20"]["BackgroundTransparency"] = 1
				Section["20"]["Position"] = UDim2.new(0, 8, 0, 6)

				-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer
				Section["21"] = Instance.new("Frame", Section["1e"])
				Section["21"]["BorderSizePixel"] = 0
				Section["21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
				Section["21"]["BackgroundTransparency"] = 1
				Section["21"]["Size"] = UDim2.new(0, 458, 0, 425)
				Section["21"]["Position"] = UDim2.new(0, 0, 0, 26)
				Section["21"]["Name"] = [[SectionContainer]]

				-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.UIListLayout
				Section["22"] = Instance.new("UIListLayout", Section["21"])
				Section["22"]["Padding"] = UDim.new(0, 5)
				Section["22"]["SortOrder"] = Enum.SortOrder.LayoutOrder

				-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.UIPadding
				Section["23"] = Instance.new("UIPadding", Section["21"])
				Section["23"]["PaddingLeft"] = UDim.new(0, 17)

				-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.UICorner
				Section["7a"] = Instance.new("UICorner", Section["1e"])
				Section["7a"]["CornerRadius"] = UDim.new(0, 4)

				-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.UIStroke
				Section["7b"] = Instance.new("UIStroke", Section["1e"])
				Section["7b"]["Color"] = ThemeColor.SecondaryTrue

				ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Section["7b"]
			end

			table.insert(
				ConnectionBin,
				Section["1e"]:GetPropertyChangedSignal("Size"):Connect(function()
					Library:ResizeCanvas(Tab["1d"])
				end)
			)

			function Section:Button(options)
				options = Library:PlaceDefaults({
					Name = "Button",
					Callback = function()
						return
					end,
				}, options or {})

				local Button = {
					Hover = false,
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Button
					Button["74"] = Instance.new("Frame", Section["21"])
					Button["74"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Button["74"]["Size"] = UDim2.new(0, 423, 0, 34)
					Button["74"]["Position"] = UDim2.new(0, 17, 0, 22)
					Button["74"]["Name"] = [[Button]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Button.UICorner
					Button["75"] = Instance.new("UICorner", Button["74"])
					Button["75"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Button.UIGradient
					Button["76"] = Instance.new("UIGradient", Button["74"])
					Button["76"]["Rotation"] = 90
					Button["76"]["Color"] = ThemeColor.Main

					ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Button["76"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Button.Label
					Button["77"] = Instance.new("TextLabel", Button["74"])
					Button["77"]["BorderSizePixel"] = 0
					Button["77"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Button["77"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Button["77"]["TextSize"] = 13
					Button["77"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Button["77"]
					Button["77"]["Size"] = UDim2.new(0, 301, 0, 33)
					Button["77"]["Text"] = options.Name
					Button["77"]["Name"] = [[Label]]
					Button["77"]["Font"] = Enum.Font.GothamMedium
					Button["77"]["BackgroundTransparency"] = 1
					Button["77"]["Position"] = UDim2.new(0, 21, 0, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Button.UIStroke
					Button["78"] = Instance.new("UIStroke", Button["74"])
					Button["78"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Button["78"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Button.ImageLabel
					Button["79"] = Instance.new("ImageLabel", Button["74"])
					Button["79"]["BorderSizePixel"] = 0
					Button["79"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Button["79"]["Image"] = [[rbxassetid://11400928498]]
					Button["79"]["Size"] = UDim2.new(0, 21, 0, 21)
					Button["79"]["BackgroundTransparency"] = 1
					Button["79"]["Position"] = UDim2.new(0.9219858050346375, 0, 0.1764705926179886, 0)
				end

				-- Handler
				do
					table.insert(
						Button.Connections,
						Button["74"].MouseEnter:Connect(function()
							Library:Tween(Button["78"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.MainTrue },
							})

							Button.Hover = true
							Library:PlaySound(LibSettings.HoverSound)
						end)
					)

					table.insert(
						Button.Connections,
						Button["74"].MouseLeave:Connect(function()
							Library:Tween(Button["78"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.SecondaryTrue },
							})

							Button.Hover = false
						end)
					)

					table.insert(
						Button.Connections,
						UserInputService.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and Button.Hover then
								Library:PlaySound(LibSettings.ClickSound)
								Library:Tween(Button["78"], {
									Length = 0.2,
									Goal = { Color = Color3.fromRGB(86, 86, 86) },
								})

								Library:Tween(Button["79"], {
									Length = 0.2,
									Goal = { ImageColor3 = ThemeColor.ThemeTrue },
								})

								-- Callback
								do
									task.spawn(function()
										options.Callback()
									end)
								end

								task.wait(0.2)
								Library:Tween(Button["79"], {
									Length = 0.2,
									Goal = { ImageColor3 = Color3.fromRGB(255, 255, 255) },
								})

								if Button.Hover then
									Library:Tween(Button["78"], {
										Length = 0.2,
										Goal = { Color = ThemeColor.MainTrue },
									})
								else
									Library:Tween(Button["78"], {
										Length = 0.2,
										Goal = { Color = ThemeColor.SecondaryTrue },
									})
								end
							end
						end)
					)
				end

				-- Methods
				do
					function Button:Destroy()
						table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, Button.Connections))

						local TotalConnection = #Button.Connections
						local Disconnected = 0
						for i, v in next, Button.Connections do
							pcall(function()
								v:Disconnect()
								Disconnected = Disconnected + 1
							end)
						end

						Button["74"]:Destroy()
						print(
							"Removed button, "
								.. tostring(Disconnected)
								.. " connections out of "
								.. TotalConnection
								.. " were disconnected."
						)

						task.spawn(function()
							Library:ResizeSection(Section["1e"])
							Library:ResizeCanvas(Tab["1d"])
						end)
					end

					table.insert(ControlsConnectionBin, Button.Connections)

					function Button:SetName(name)
						Button["77"]["Text"] = name
					end
				end

				table.insert(
					Button.Connections,
					Button["74"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)

				return Button
			end

			function Section:Toggle(options)
				options = Library:PlaceDefaults({
					Name = "Toggle",
					Default = false,
					Callback = function()
						return
					end,
				}, options or {})

				local Toggle = {
					Hover = false,
					Bool = options.Default,
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle
					Toggle["24"] = Instance.new("Frame", Section["21"])
					Toggle["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Toggle["24"]["Size"] = UDim2.new(0, 423, 0, 34)
					Toggle["24"]["Position"] = UDim2.new(0, 17, 0, 22)
					Toggle["24"]["Name"] = [[Toggle]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle.UICorner
					Toggle["25"] = Instance.new("UICorner", Toggle["24"])
					Toggle["25"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle.UIGradient
					Toggle["26"] = Instance.new("UIGradient", Toggle["24"])
					Toggle["26"]["Rotation"] = 90
					Toggle["26"]["Color"] = ThemeColor.Main

					ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Toggle["26"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle.Toggle
					Toggle["27"] = Instance.new("TextButton", Toggle["24"])
					Toggle["27"]["BorderSizePixel"] = 0
					Toggle["27"]["AutoButtonColor"] = false
					Toggle["27"]["TextSize"] = 14
					Toggle["27"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Toggle["27"]

					Toggle["27"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
					Toggle["27"]["Size"] = UDim2.new(0, 38, 0, 18)
					Toggle["27"]["Name"] = [[Toggle]]
					Toggle["27"]["Text"] = [[]]
					Toggle["27"]["Font"] = Enum.Font.SourceSans
					Toggle["27"]["Position"] = UDim2.new(0, 373, 0, 8)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle.Toggle.UICorner
					Toggle["28"] = Instance.new("UICorner", Toggle["27"])
					Toggle["28"]["CornerRadius"] = UDim.new(2, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle.Toggle.Indicator
					Toggle["2a"] = Instance.new("TextLabel", Toggle["27"])
					Toggle["2a"]["BackgroundColor3"] = Color3.fromRGB(177, 177, 177)
					Toggle["2a"]["TextSize"] = 14
					Toggle["2a"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
					Toggle["2a"]["Size"] = UDim2.new(0, 23, 0, 20)
					Toggle["2a"]["Text"] = [[]]
					Toggle["2a"]["Name"] = [[Indicator]]
					Toggle["2a"]["Font"] = Enum.Font.SourceSans
					Toggle["2a"]["Position"] = UDim2.new(0, 0, 0, -1)

					ThemeInstances["ThemeTrue"][#ThemeInstances["ThemeTrue"] + 1] = Toggle["2a"]

					Toggle["29"] = Instance.new("BoolValue", Toggle["2a"])
					Toggle["29"]["Name"] = [[ToggleVal]]
					Toggle["29"]["Value"] = options.Default

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle.Toggle.Indicator.UICorner
					Toggle["2b"] = Instance.new("UICorner", Toggle["2a"])
					Toggle["2b"]["CornerRadius"] = UDim.new(1, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle.Label
					Toggle["2d"] = Instance.new("TextLabel", Toggle["24"])
					Toggle["2d"]["BorderSizePixel"] = 0
					Toggle["2d"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Toggle["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Toggle["2d"]["TextSize"] = 13
					Toggle["2d"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Toggle["2d"]
					Toggle["2d"]["Size"] = UDim2.new(0, 301, 0, 33)
					Toggle["2d"]["Text"] = options.Name
					Toggle["2d"]["Name"] = [[Label]]
					Toggle["2d"]["Font"] = Enum.Font.GothamMedium
					Toggle["2d"]["BackgroundTransparency"] = 1
					Toggle["2d"]["Position"] = UDim2.new(0, 21, 0, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Toggle.UIStroke
					Toggle["2e"] = Instance.new("UIStroke", Toggle["24"])
					Toggle["2e"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Toggle["2e"]
				end

				table.insert(
					Toggle.Connections,
					Toggle["24"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				-- Handler
				do
					table.insert(
						Toggle.Connections,
						Toggle["24"].MouseEnter:Connect(function()
							Library:Tween(Toggle["2e"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.MainTrue },
							})

							Library:PlaySound(LibSettings.HoverSound)
							Toggle.Hover = true
						end)
					)

					table.insert(
						Toggle.Connections,
						Toggle["24"].MouseLeave:Connect(function()
							Library:Tween(Toggle["2e"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.SecondaryTrue },
							})

							Toggle.Hover = false
						end)
					)

					table.insert(
						Toggle.Connections,
						UserInputService.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and Toggle.Hover then
								Library:PlaySound(LibSettings.ClickSound)
								Library:Tween(Toggle["2e"], {
									Length = 0.2,
									Goal = { Color = Color3.fromRGB(86, 86, 86) },
								})

								Toggle:Set()
								task.wait(0.2)
								if Toggle.Hover then
									Library:Tween(Toggle["2e"], {
										Length = 0.2,
										Goal = { Color = ThemeColor.MainTrue },
									})
								else
									Library:Tween(Toggle["2e"], {
										Length = 0.2,
										Goal = { Color = ThemeColor.SecondaryTrue },
									})
								end
							end
						end)
					)
				end

				-- Methods
				do
					function Toggle:Destroy()
						table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, Toggle.Connections))

						local TotalConnection = #Toggle.Connections
						local Disconnected = 0
						for i, v in next, Toggle.Connections do
							pcall(function()
								v:Disconnect()
								Disconnected = Disconnected + 1
							end)
						end

						Toggle["24"]:Destroy()
						print(
							"Removed toggle, "
								.. tostring(Disconnected)
								.. " connections out of "
								.. TotalConnection
								.. " were disconnected."
						)

						task.spawn(function()
							Library:ResizeSection(Section["1e"])
							Library:ResizeCanvas(Tab["1d"])
						end)
					end

					table.insert(ControlsConnectionBin, Toggle.Connections)

					function Toggle:Toggle(toggle)
						if toggle then
							Toggle.Bool = true
							Toggle["29"]["Value"] = true

							task.spawn(function()
								Library:Tween(Toggle["2a"], {
									Length = 0.2,
									Goal = { Position = UDim2.new(0, 15, 0, -1) },
								})

								Library:Tween(Toggle["2a"], {
									Length = 0.2,
									Goal = { BackgroundColor3 = ThemeColor.ThemeTrue },
								})
							end)
						else
							Toggle.Bool = false
							Toggle["29"]["Value"] = false

							task.spawn(function()
								Library:Tween(Toggle["2a"], {
									Length = 0.2,
									Goal = { Position = UDim2.new(0, 0, 0, -1) },
								})

								Library:Tween(Toggle["2a"], {
									Length = 0.2,
									Goal = { BackgroundColor3 = Color3.fromRGB(177, 177, 177) },
								})
							end)
						end

						task.spawn(function()
							options.Callback(Toggle.Bool)
						end)
					end

					function Toggle:Set(bool)
						if type(bool) == "boolean" then
							Toggle:Toggle(bool)
						else
							if Toggle.Bool then
								Toggle:Toggle(false)
							else
								Toggle:Toggle(true)
							end
						end
					end

					function Toggle:SetName(name)
						Toggle["2d"]["Text"] = name
					end
				end

				Toggle:Set(options.Default)

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)

				return Toggle
			end

			function Section:Slider(options)
				options = Library:PlaceDefaults({
					Name = "Slider",
					Max = 100,
					Min = 0,
					Default = 50,
					Callback = function()
						return
					end,
				}, options or {})

				local Slider = {
					Hover = false,
					OldVal = options.Default,
					TextboxHover = false,
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider
					Slider["36"] = Instance.new("Frame", Section["21"])
					Slider["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Slider["36"]["Size"] = UDim2.new(0, 423, 0, 34)
					Slider["36"]["Position"] = UDim2.new(0, 17, 0, 104)
					Slider["36"]["Name"] = [[Slider]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.UICorner
					Slider["37"] = Instance.new("UICorner", Slider["36"])
					Slider["37"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.UIGradient
					Slider["38"] = Instance.new("UIGradient", Slider["36"])
					Slider["38"]["Rotation"] = 90
					Slider["38"]["Color"] = ThemeColor.Main

					ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Slider["38"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.Label
					Slider["39"] = Instance.new("TextLabel", Slider["36"])
					Slider["39"]["BorderSizePixel"] = 0
					Slider["39"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Slider["39"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Slider["39"]["TextSize"] = 13
					Slider["39"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Slider["39"]
					Slider["39"]["Size"] = UDim2.new(0, 301, 0, 33)
					Slider["39"]["Text"] = options.Name
					Slider["39"]["Name"] = [[Label]]
					Slider["39"]["Font"] = Enum.Font.GothamMedium
					Slider["39"]["BackgroundTransparency"] = 1
					Slider["39"]["Position"] = UDim2.new(0, 21, 0, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.Slider
					Slider["3a"] = Instance.new("Frame", Slider["36"])
					Slider["3a"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Slider["3a"]

					Slider["3a"]["Size"] = UDim2.new(0, 136, 0, 10)
					Slider["3a"]["Position"] = UDim2.new(0, 229, 0, 12)
					Slider["3a"]["Name"] = [[Slider]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.Slider.UICorner
					Slider["3b"] = Instance.new("UICorner", Slider["3a"])
					Slider["3b"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.Slider.Sliderbackground
					Slider["3c"] = Instance.new("Frame", Slider["3a"])
					Slider["3c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Slider["3c"]["Size"] = UDim2.new(0.49264705181121826, 0, 0.9444444179534912, 0)
					Slider["3c"]["Name"] = [[Sliderbackground]]
					Slider["3c"]["BorderSizePixel"] = 0

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.Slider.Sliderbackground.UICorner
					Slider["3d"] = Instance.new("UICorner", Slider["3c"])
					Slider["3d"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.Slider.Sliderbackground.ThemeColorGradient
					Slider["3e"] = Instance.new("UIGradient", Slider["3c"])
					Slider["3e"]["Name"] = [[ThemeColorGradient]]
					Slider["3e"]["Rotation"] = 90
					Slider["3e"]["Color"] = ThemeColor.Theme

					ThemeInstances["Theme"][#ThemeInstances["Theme"] + 1] = Slider["3e"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.UIStroke
					Slider["40"] = Instance.new("UIStroke", Slider["36"])
					Slider["40"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Slider["40"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.TextBox
					Slider["3g"] = Instance.new("TextBox", Slider["36"])
					Slider["3g"]["CursorPosition"] = -1
					Slider["3g"]["PlaceholderColor3"] = ThemeColor.PlaceholderText

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Slider["3g"]

					Slider["3g"]["RichText"] = true
					Slider["3g"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Slider["3g"]
					Slider["3g"]["TextSize"] = 11
					Slider["3g"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Slider["3g"]

					Slider["3g"]["PlaceholderText"] = [[]]
					Slider["3g"]["Size"] = UDim2.new(0, 45, 0, 18)
					Slider["3g"]["Text"] = [[]]
					Slider["3g"]["Position"] = UDim2.new(0, 373, 0, 6)
					Slider["3g"]["Font"] = Enum.Font.Gotham
					Slider["3g"]["BorderSizePixel"] = 0

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Slider.TextBox
					Slider["41"] = Instance.new("UICorner", Slider["3g"])
					Slider["41"]["CornerRadius"] = UDim.new(0, 4)
				end

				table.insert(
					Slider.Connections,
					Slider["36"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				-- Handler
				do
					local MouseDown

					table.insert(
						Slider.Connections,
						Slider["36"].MouseEnter:Connect(function()
							Slider.Hover = true
							Library:PlaySound(LibSettings.HoverSound)

							Library:Tween(Slider["40"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.MainTrue },
							})
						end)
					)

					table.insert(
						Slider.Connections,
						Slider["36"].MouseLeave:Connect(function()
							Slider.Hover = false

							Library:Tween(Slider["40"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.SecondaryTrue },
							})
						end)
					)

					table.insert(
						Slider.Connections,
						Slider["3g"].MouseEnter:Connect(function()
							Slider.TextboxHover = true
							Library:PlaySound(LibSettings.HoverSound)
						end)
					)

					table.insert(
						Slider.Connections,
						Slider["3g"].MouseLeave:Connect(function()
							Slider.TextboxHover = false
						end)
					)

					table.insert(
						Slider.Connections,
						Slider["3g"].Focused:Connect(function()
							Slider["3g"]["Text"] = [[]]

							Library.Sliding = true
							Library:PlaySound(LibSettings.ClickSound)
						end)
					)

					table.insert(
						Slider.Connections,
						Slider["3g"].FocusLost:Connect(function()
							local success = pcall(function()
								local NumVal = tonumber(Slider["3g"].Text)
								if NumVal <= options.Max and NumVal >= options.Min then
									Slider.OldVal = NumVal
									Slider:SetValue(NumVal)
								else
									Slider["3g"].Text = Slider.OldVal
								end
							end)

							if not success then
								Slider["3g"].Text = Slider.OldVal
							end

							Library.Sliding = false
						end)
					)

					table.insert(
						Slider.Connections,
						UserInputService.InputBegan:Connect(function(key)
							if
								key.UserInputType == Enum.UserInputType.MouseButton1
								and Slider.Hover
								and not Slider.TextboxHover
							then
								Library.Sliding = true
								MouseDown = true

								while RunService.RenderStepped:wait() and MouseDown do
									local percentage = math.clamp(
										(Mouse.X - Slider["3a"].AbsolutePosition.X) / Slider["3a"].AbsoluteSize.X,
										0,
										1
									)
									local Value = ((options.Max - options.Min) * percentage) + options.Min
									Value = math.floor(Value)

									if Value ~= Slider.OldVal then
										options.Callback(Value)
									end
									Slider.OldVal = Value
									Slider["3g"]["Text"] = Value

									Library:Tween(Slider["3c"], {
										Length = 0.06,
										Goal = {
											Size = UDim2.fromScale(
												((Value - options.Min) / (options.Max - options.Min)),
												1
											),
										},
									})
								end
								Library.Sliding = false
							end
						end)
					)

					table.insert(
						Slider.Connections,
						UserInputService.InputEnded:Connect(function(key)
							if key.UserInputType == Enum.UserInputType.MouseButton1 then
								MouseDown = false
							end
						end)
					)
				end

				-- Methods
				do
					function Slider:SetValue(Value)
						Value = math.floor(Value)

						Library:Tween(Slider["3c"], {
							Length = 1,
							Goal = { Size = UDim2.fromScale(((Value - options.Min) / (options.Max - options.Min)), 1) },
						})

						Slider["3g"]["Text"] = Value
						Slider.OldVal = Value
						options.Callback(Value)
					end

					function Slider:SetName(name)
						Slider["39"]["Text"] = name
					end

					function Slider:Destroy()
						table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, Slider.Connections))

						local TotalConnection = #Slider.Connections
						local Disconnected = 0
						for i, v in next, Slider.Connections do
							pcall(function()
								v:Disconnect()
								Disconnected = Disconnected + 1
							end)
						end

						Slider["36"]:Destroy()
						print(
							"Removed slider, "
								.. tostring(Disconnected)
								.. " connections out of "
								.. TotalConnection
								.. " were disconnected."
						)

						task.spawn(function()
							Library:ResizeSection(Section["1e"])
							Library:ResizeCanvas(Tab["1d"])
						end)
					end

					table.insert(ControlsConnectionBin, Slider.Connections)
				end

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)

				Slider:SetValue(options.Default)

				return Slider
			end

			function Section:Keybind(options)
				options = Library:PlaceDefaults({
					Name = "Keybind",
					Default = Enum.KeyCode.Return,
					Callback = function()
						return
					end,
					UpdateKeyCallback = function()
						return
					end,
				}, options or {})

				local Keybind = {
					Focused = false,
					Keybind = options.Default,
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Keybind
					Keybind["59"] = Instance.new("Frame", Section["21"])
					Keybind["59"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Keybind["59"]["Size"] = UDim2.new(0, 423, 0, 34)
					Keybind["59"]["Position"] = UDim2.new(0, 17, 0, 104)
					Keybind["59"]["Name"] = [[Keybind]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Keybind.UICorner
					Keybind["5a"] = Instance.new("UICorner", Keybind["59"])
					Keybind["5a"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Keybind.UIGradient
					Keybind["5b"] = Instance.new("UIGradient", Keybind["59"])
					Keybind["5b"]["Rotation"] = 90
					Keybind["5b"]["Color"] = ThemeColor.Main

					ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Keybind["5b"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Keybind.Label
					Keybind["5c"] = Instance.new("TextLabel", Keybind["59"])
					Keybind["5c"]["BorderSizePixel"] = 0
					Keybind["5c"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Keybind["5c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Keybind["5c"]["TextSize"] = 13
					Keybind["5c"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Keybind["5c"]
					Keybind["5c"]["Size"] = UDim2.new(0, 301, 0, 33)
					Keybind["5c"]["Text"] = options.Name
					Keybind["5c"]["Name"] = [[Label]]
					Keybind["5c"]["Font"] = Enum.Font.GothamMedium
					Keybind["5c"]["BackgroundTransparency"] = 1
					Keybind["5c"]["Position"] = UDim2.new(0, 21, 0, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Keybind.TextButton
					Keybind["5d"] = Instance.new("TextButton", Keybind["59"])
					Keybind["5d"]["AutoButtonColor"] = false
					Keybind["5d"]["TextSize"] = 11
					Keybind["5d"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Keybind["5d"]

					Keybind["5d"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Keybind["5d"]
					Keybind["5d"]["Size"] = UDim2.new(0, 80, 0, 21)
					Keybind["5d"]["Text"] = [[]]
					Keybind["5d"]["Font"] = Enum.Font.Gotham
					Keybind["5d"]["Position"] = UDim2.new(0.7900000214576721, 0, 0.17599999904632568, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Keybind.TextButton.UICorner
					Keybind["5e"] = Instance.new("UICorner", Keybind["5d"])
					Keybind["5e"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Keybind.UIStroke
					Keybind["5g"] = Instance.new("UIStroke", Keybind["59"])
					Keybind["5g"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Keybind["5g"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Keybind.TextButton.TextLabel
					Keybind["60"] = Instance.new("TextLabel", Keybind["5d"])
					Keybind["60"]["BorderSizePixel"] = 0
					Keybind["60"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Keybind["60"]["TextSize"] = 10
					Keybind["60"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Keybind["60"]
					Keybind["60"]["Size"] = UDim2.new(0, 79, 0, 21)
					Keybind["60"]["Text"] = [[LeftShift]]
					Keybind["60"]["Font"] = Enum.Font.Gotham
					Keybind["60"]["BackgroundTransparency"] = 1

					local keybindText = string.gsub(tostring(Keybind.Keybind), "Enum.KeyCode.", "")

					Keybind["60"]["Text"] = keybindText
				end

				table.insert(
					Keybind.Connections,
					Keybind["59"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				-- Methods
				do
					table.insert(
						Keybind.Connections,
						Keybind["59"].MouseEnter:Connect(function()
							Library:Tween(Keybind["5g"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.MainTrue },
							})

							Library:PlaySound(LibSettings.HoverSound)
						end)
					)

					table.insert(
						Keybind.Connections,
						Keybind["59"].MouseLeave:Connect(function()
							Library:Tween(Keybind["5g"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.SecondaryTrue },
							})
						end)
					)

					table.insert(
						Keybind.Connections,
						Keybind["5d"].MouseButton1Click:Connect(function()
							Library:PlaySound(LibSettings.ClickSound)
							Keybind.Focused = true

							Keybind["60"]["Text"] = "..."
						end)
					)

					table.insert(
						Keybind.Connections,
						UserInputService.InputBegan:Connect(function(input, GameProcess)
							if input.UserInputType == Enum.UserInputType.Keyboard then
								if input.KeyCode == Keybind.Keybind then
									pcall(function()
										options.Callback()
									end)
								end

								if Keybind.Focused then
									Keybind.Keybind = input.KeyCode
									local keybindText = string.gsub(tostring(Keybind.Keybind), "Enum.KeyCode.", "")
									Keybind["60"]["Text"] = keybindText
									pcall(function()
										options.UpdateKeyCallback(input.KeyCode)
									end)

									Keybind.Focused = false
								end
							end
						end)
					)

					-- Methods
					do
						function Keybind:SetName(name)
							Keybind["5c"]["Text"] = name
						end

						function Keybind:Destroy()
							table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, Keybind.Connections))

							local TotalConnection = #Keybind.Connections
							local Disconnected = 0
							for i, v in next, Keybind.Connections do
								pcall(function()
									v:Disconnect()
									Disconnected = Disconnected + 1
								end)
							end

							Keybind["59"]:Destroy()
							print(
								"Removed keybind, "
									.. tostring(Disconnected)
									.. " connections out of "
									.. TotalConnection
									.. " were disconnected."
							)

							task.spawn(function()
								Library:ResizeSection(Section["1e"])
								Library:ResizeCanvas(Tab["1d"])
							end)
						end

						table.insert(ControlsConnectionBin, Keybind.Connections)
					end
				end

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)

				return Keybind
			end

			function Section:SmallTextbox(options)
				options = Library:PlaceDefaults({
					Name = "Small Textbox",
					Default = "Text",
					Callback = function()
						return
					end,
				}, options or {})

				local Textbox = {
					Hover = false,
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1
					Textbox["2e"] = Instance.new("Frame", Section["21"])
					Textbox["2e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Textbox["2e"]["Size"] = UDim2.new(0, 423, 0, 34)
					Textbox["2e"]["Position"] = UDim2.new(0, 17, 0, 104)
					Textbox["2e"]["Name"] = [[Textbox1]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.UICorner
					Textbox["2f"] = Instance.new("UICorner", Textbox["2e"])
					Textbox["2f"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.UIGradient
					Textbox["30"] = Instance.new("UIGradient", Textbox["2e"])
					Textbox["30"]["Rotation"] = 90
					Textbox["30"]["Color"] = ThemeColor.Main

					ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Textbox["30"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.Label
					Textbox["31"] = Instance.new("TextLabel", Textbox["2e"])
					Textbox["31"]["BorderSizePixel"] = 0
					Textbox["31"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Textbox["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Textbox["31"]["TextSize"] = 13
					Textbox["31"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Textbox["31"]
					Textbox["31"]["Size"] = UDim2.new(0, 301, 0, 33)
					Textbox["31"]["Text"] = options.Name
					Textbox["31"]["Name"] = [[Label]]
					Textbox["31"]["Font"] = Enum.Font.GothamMedium
					Textbox["31"]["BackgroundTransparency"] = 1
					Textbox["31"]["Position"] = UDim2.new(0, 21, 0, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.UIStroke
					Textbox["32"] = Instance.new("UIStroke", Textbox["2e"])
					Textbox["32"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Textbox["32"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.Frame
					Textbox["33"] = Instance.new("Frame", Textbox["2e"])
					Textbox["33"]["BorderSizePixel"] = 0
					Textbox["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Textbox["33"]["BackgroundTransparency"] = 1
					Textbox["33"]["Size"] = UDim2.new(0.9810874462127686, 0, 1, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.Frame.TextBox
					Textbox["34"] = Instance.new("TextBox", Textbox["33"])
					Textbox["34"]["PlaceholderColor3"] = ThemeColor.PlaceholderText

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Textbox["34"]

					Textbox["34"]["RichText"] = true
					Textbox["34"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Textbox["34"]
					Textbox["34"]["TextSize"] = 11
					Textbox["34"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Textbox["34"]

					Textbox["34"]["Size"] = UDim2.new(0, 92, 0, 21)
					Textbox["34"]["Text"] = [[]]
					Textbox["34"]["Position"] = UDim2.new(0.7612293362617493, 0, 0.1764705926179886, 0)
					Textbox["34"]["Font"] = Enum.Font.Gotham
					Textbox["34"]["TextWrapped"] = false
					Textbox["34"]["PlaceholderText"] = [[...]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.Frame.TextBox.UICorner
					Textbox["35"] = Instance.new("UICorner", Textbox["34"])
					Textbox["35"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.Frame.TextBox.UIGradient
					Textbox["36"] = Instance.new("UIGradient", Textbox["34"])
					Textbox["36"]["Color"] = ColorSequence.new({
						ColorSequenceKeypoint.new(0.000, Color3.fromRGB(75, 75, 75)),
						ColorSequenceKeypoint.new(1.000, Color3.fromRGB(99, 99, 99)),
					})

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox1.Frame.UIListLayout
					Textbox["37"] = Instance.new("UIListLayout", Textbox["33"])
					Textbox["37"]["VerticalAlignment"] = Enum.VerticalAlignment.Center
					Textbox["37"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right
					Textbox["37"]["SortOrder"] = Enum.SortOrder.LayoutOrder
				end

				table.insert(
					Textbox.Connections,
					Textbox["2e"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				-- Handler
				do
					table.insert(
						Textbox.Connections,
						Textbox["2e"].MouseEnter:Connect(function()
							Library:Tween(Textbox["32"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.MainTrue },
							})

							Library:PlaySound(LibSettings.HoverSound)
						end)
					)

					table.insert(
						Textbox.Connections,
						Textbox["2e"].MouseLeave:Connect(function()
							Library:Tween(Textbox["32"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.SecondaryTrue },
							})
						end)
					)

					table.insert(
						Textbox.Connections,
						Textbox["34"].Focused:Connect(function()
							Library:PlaySound(LibSettings.ClickSound)
							Textbox["34"].Text = ""

							Library.Sliding = true
						end)
					)

					table.insert(
						Textbox.Connections,
						Textbox["34"].FocusLost:Connect(function()
							Library.Sliding = false

							task.spawn(function()
								options.Callback(Textbox["34"].Text)
							end)
						end)
					)

					table.insert(
						Textbox.Connections,
						Textbox["34"]:GetPropertyChangedSignal("Text"):Connect(function()
							if Textbox["34"].Text == "" then
								Library:Tween(Textbox["34"], {
									Length = 0.2,
									Goal = { Size = UDim2.new(0, 35, 0, 21) },
								})
							else
								local Bound = TextService:GetTextSize(
									Textbox["34"].Text,
									Textbox["34"].TextSize,
									Textbox["34"].Font,
									Vector2.new(Textbox["34"].AbsoluteSize.X, Textbox["34"].AbsoluteSize.Y)
								)

								Library:Tween(Textbox["34"], {
									Length = 0.2,
									Goal = { Size = UDim2.new(0, (Bound.X + 18), 0, 21) },
								})
							end
						end)
					)
				end

				-- Methods
				do
					function Textbox:SetText(Text)
						Textbox["34"].Text = Text
					end

					function Textbox:SetName(Name)
						Textbox["31"].Text = Name
					end

					function Textbox:Destroy()
						table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, Textbox.Connections))

						local TotalConnection = #Textbox.Connections
						local Disconnected = 0
						for i, v in next, Textbox.Connections do
							pcall(function()
								v:Disconnect()
								Disconnected = Disconnected + 1
							end)
						end

						Textbox["2e"]:Destroy()
						print(
							"Removed textbox, "
								.. tostring(Disconnected)
								.. " connections out of "
								.. TotalConnection
								.. " were disconnected."
						)

						task.spawn(function()
							Library:ResizeSection(Section["1e"])
							Library:ResizeCanvas(Tab["1d"])
						end)
					end

					table.insert(ControlsConnectionBin, Textbox.Connections)
				end

				Textbox:SetText(options.Default)

				do
					if Textbox["34"].Text == "" then
						Library:Tween(Textbox["34"], {
							Length = 0.2,
							Goal = { Size = UDim2.new(0, 35, 0, 21) },
						})
					else
						local Bound = TextService:GetTextSize(
							Textbox["34"].Text,
							Textbox["34"].TextSize,
							Textbox["34"].Font,
							Vector2.new(Textbox["34"].AbsoluteSize.X, Textbox["34"].AbsoluteSize.Y)
						)

						Library:Tween(Textbox["34"], {
							Length = 0.2,
							Goal = { Size = UDim2.new(0, (Bound.X + 18), 0, 21) },
						})
					end
				end

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)

				return Textbox
			end

			function Section:BigTextbox(options)
				options = Library:PlaceDefaults({
					Name = "Big Textbox",
					Default = "",
					PlaceHolderText = "Placeholder | Text",
					ResetOnFocus = false,
					Callback = function()
						return
					end,
				}, options or {})

				local BigTextbox = {
					Hover = false,
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2
					BigTextbox["66"] = Instance.new("Frame", Section["21"])
					BigTextbox["66"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					BigTextbox["66"]["Size"] = UDim2.new(0, 423, 0, 69)
					BigTextbox["66"]["Position"] = UDim2.new(0, 0, 0, 262)
					BigTextbox["66"]["Name"] = [[Textbox2]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.UICorner
					BigTextbox["67"] = Instance.new("UICorner", BigTextbox["66"])
					BigTextbox["67"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.UIGradient
					BigTextbox["68"] = Instance.new("UIGradient", BigTextbox["66"])
					BigTextbox["68"]["Rotation"] = 90
					BigTextbox["68"]["Color"] = ThemeColor.Main

					ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = BigTextbox["68"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.Label
					BigTextbox["69"] = Instance.new("TextLabel", BigTextbox["66"])
					BigTextbox["69"]["BorderSizePixel"] = 0
					BigTextbox["69"]["TextXAlignment"] = Enum.TextXAlignment.Left
					BigTextbox["69"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					BigTextbox["69"]["TextSize"] = 13
					BigTextbox["69"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = BigTextbox["69"]
					BigTextbox["69"]["Size"] = UDim2.new(0, 301, 0, 33)
					BigTextbox["69"]["Text"] = options.Name
					BigTextbox["69"]["Name"] = [[Label]]
					BigTextbox["69"]["Font"] = Enum.Font.GothamMedium
					BigTextbox["69"]["BackgroundTransparency"] = 1
					BigTextbox["69"]["Position"] = UDim2.new(0, 21, 0, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.UIStroke
					BigTextbox["6a"] = Instance.new("UIStroke", BigTextbox["66"])
					BigTextbox["6a"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = BigTextbox["6a"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.Option 1
					BigTextbox["6b"] = Instance.new("Frame", BigTextbox["66"])
					BigTextbox["6b"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = BigTextbox["6b"]

					BigTextbox["6b"]["Size"] = UDim2.new(0, 407, 0, 27)
					BigTextbox["6b"]["Position"] = UDim2.new(0, 8, 0, 32)
					BigTextbox["6b"]["Name"] = [[Option 1]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.Option 1.UICorner
					BigTextbox["6c"] = Instance.new("UICorner", BigTextbox["6b"])
					BigTextbox["6c"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.Option 1.UIStroke
					BigTextbox["6d"] = Instance.new("UIStroke", BigTextbox["6b"])
					BigTextbox["6d"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = BigTextbox["6d"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.Option 1.TextBox
					BigTextbox["6f"] = Instance.new("TextBox", BigTextbox["6b"])
					BigTextbox["6f"]["PlaceholderColor3"] = ThemeColor.PlaceholderText

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = BigTextbox["6f"]

					BigTextbox["6f"]["RichText"] = true
					BigTextbox["6f"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = BigTextbox["6f"]
					BigTextbox["6f"]["TextXAlignment"] = Enum.TextXAlignment.Left
					BigTextbox["6f"]["TextSize"] = 11
					BigTextbox["6f"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = BigTextbox["6f"]

					BigTextbox["6f"]["PlaceholderText"] = options.PlaceHolderText
					BigTextbox["6f"]["Size"] = UDim2.new(0, 389, 0, 21)
					BigTextbox["6f"]["Text"] = [[]]
					BigTextbox["6f"]["Position"] = UDim2.new(0, 13, 0, 2)
					BigTextbox["6f"]["Font"] = Enum.Font.Gotham
					BigTextbox["6f"]["BackgroundTransparency"] = 1
					BigTextbox["6f"]["AutomaticSize"] = Enum.AutomaticSize.Y
					BigTextbox["6f"]["TextWrapped"] = true
					BigTextbox["6f"]["ClearTextOnFocus"] = false

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.Option 1.TextBox.UICorner
					BigTextbox["70"] = Instance.new("UICorner", BigTextbox["6f"])
					BigTextbox["70"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Textbox2.Open
					BigTextbox["71"] = Instance.new("ImageButton", BigTextbox["66"])
					BigTextbox["71"]["ScaleType"] = Enum.ScaleType.Crop
					BigTextbox["71"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					BigTextbox["71"]["Image"] = [[rbxassetid://11401860490]]
					BigTextbox["71"]["Size"] = UDim2.new(0, 23, 0, 18)
					BigTextbox["71"]["Name"] = [[Open]]
					BigTextbox["71"]["Position"] = UDim2.new(0, 390, 0, 7)
					BigTextbox["71"]["BackgroundTransparency"] = 1
				end

				table.insert(
					BigTextbox.Connections,
					BigTextbox["66"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				table.insert(
					BigTextbox.Connections,
					BigTextbox["6b"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:Tween(BigTextbox["66"], {
							Length = 0.2,
							Goal = { Size = UDim2.new(0, 423, 0, (BigTextbox["6b"].Size.Y.Offset + 42)) },
						})
					end)
				)

				-- Handler
				do
					table.insert(
						BigTextbox.Connections,
						BigTextbox["66"].MouseEnter:Connect(function()
							Library:Tween(BigTextbox["6a"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.MainTrue },
							})

							Library:PlaySound(LibSettings.HoverSound)
						end)
					)

					table.insert(
						BigTextbox.Connections,
						BigTextbox["66"].MouseLeave:Connect(function()
							Library:Tween(BigTextbox["6a"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.SecondaryTrue },
							})
						end)
					)

					table.insert(
						BigTextbox.Connections,
						BigTextbox["6f"].Focused:Connect(function()
							Library:PlaySound(LibSettings.ClickSound)
							if options.ResetOnFocus then
								BigTextbox["6f"].Text = ""
							end

							Library.Sliding = true
						end)
					)

					table.insert(
						BigTextbox.Connections,
						BigTextbox["6f"].FocusLost:Connect(function()
							Library.Sliding = false

							task.spawn(function()
								options.Callback(BigTextbox["6f"].Text)
							end)

							local Val
							repeat
								Val = BigTextbox["6f"].TextBounds.Y

								Library:Tween(BigTextbox["6f"], {
									Length = 0.2,
									Goal = { Size = UDim2.new(0, 389, 0, (BigTextbox["6f"].TextBounds.Y + 10)) },
								})

								Library:Tween(BigTextbox["6b"], {
									Length = 0.2,
									Goal = { Size = UDim2.new(0, 407, 0, (BigTextbox["6f"].TextBounds.Y + 16)) },
								})

							until Val == BigTextbox["6f"].TextBounds.Y

							Library:Tween(BigTextbox["66"], {
								Length = 0.2,
								Goal = { Size = UDim2.new(0, 423, 0, (BigTextbox["6b"].Size.Y.Offset + 42)) },
							})
						end)
					)

					table.insert(
						BigTextbox.Connections,
						BigTextbox["6f"]:GetPropertyChangedSignal("Text"):Connect(function()
							local Val
							repeat
								Val = BigTextbox["6f"].TextBounds.Y
								BigTextbox["6f"].Size = UDim2.new(0, 389, 0, (BigTextbox["6f"].TextBounds.Y + 10))
								BigTextbox["6b"].Size = UDim2.new(0, 407, 0, (BigTextbox["6f"].TextBounds.Y + 16))
							until Val == BigTextbox["6f"].TextBounds.Y
						end)
					)
				end

				-- Methods
				do
					function BigTextbox:SetText(Text)
						BigTextbox["6f"].Text = Text
					end

					function BigTextbox:SetName(Name)
						BigTextbox["69"].Text = Name
					end

					function BigTextbox:Destroy()
						table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, BigTextbox.Connections))

						local TotalConnection = #BigTextbox.Connections
						local Disconnected = 0
						for i, v in next, BigTextbox.Connections do
							pcall(function()
								v:Disconnect()
								Disconnected = Disconnected + 1
							end)
						end

						BigTextbox["66"]:Destroy()
						print(
							"Removed bigTextbox, "
								.. tostring(Disconnected)
								.. " connections out of "
								.. TotalConnection
								.. " were disconnected."
						)

						task.spawn(function()
							Library:ResizeSection(Section["1e"])
							Library:ResizeCanvas(Tab["1d"])
						end)
					end

					table.insert(ControlsConnectionBin, BigTextbox.Connections)
				end

				BigTextbox:SetText(options.Default)

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)

				return BigTextbox
			end

			function Section:Dropdown(options)
				options = Library:PlaceDefaults({
					Name = "Dropdown",
					Items = {},
					Callback = function(item)
						return
					end,
				}, options or {})

				local Dropdown = {
					Items = options.Items,
					SelectedItem = nil,
					ContainerOpened = false,
					NameText = options.Name,
					Hover = false,
					SearchHover = false,
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown
					Dropdown["46"] = Instance.new("Frame", Section["21"])
					Dropdown["46"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Dropdown["46"]["Size"] = UDim2.new(0, 423, 0, 34)
					Dropdown["46"]["ClipsDescendants"] = true
					Dropdown["46"]["Position"] = UDim2.new(0, 0, 0, 117)
					Dropdown["46"]["Name"] = [[Dropdown]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.UICorner
					Dropdown["47"] = Instance.new("UICorner", Dropdown["46"])
					Dropdown["47"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Label
					Dropdown["48"] = Instance.new("TextLabel", Dropdown["46"])
					Dropdown["48"]["BorderSizePixel"] = 0
					Dropdown["48"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Dropdown["48"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Dropdown["48"]["TextSize"] = 13
					Dropdown["48"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Dropdown["48"]
					Dropdown["48"]["Size"] = UDim2.new(0, 301, 0, 33)
					Dropdown["48"]["Text"] = options.Name
					Dropdown["48"]["Name"] = [[Label]]
					Dropdown["48"]["Font"] = Enum.Font.GothamMedium
					Dropdown["48"]["BackgroundTransparency"] = 1
					Dropdown["48"]["Position"] = UDim2.new(0, 21, 0, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Open
					Dropdown["49"] = Instance.new("ImageButton", Dropdown["46"])
					Dropdown["49"]["ScaleType"] = Enum.ScaleType.Crop
					Dropdown["49"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Dropdown["49"]["Image"] = [[rbxassetid://11400266375]]
					Dropdown["49"]["Size"] = UDim2.new(0, 14, 0, 10)
					Dropdown["49"]["Name"] = [[Open]]
					Dropdown["49"]["Position"] = UDim2.new(0, 397, 0, 10)
					Dropdown["49"]["BackgroundTransparency"] = 1

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.UIStroke
					Dropdown["4a"] = Instance.new("UIStroke", Dropdown["46"])
					Dropdown["4a"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Dropdown["4a"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Container
					Dropdown["4b"] = Instance.new("Frame", Dropdown["46"])
					Dropdown["4b"]["BorderSizePixel"] = 0
					Dropdown["4b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Dropdown["4b"]["BackgroundTransparency"] = 1
					Dropdown["4b"]["Size"] = UDim2.new(0, 423, 0, 72)
					Dropdown["4b"]["Position"] = UDim2.new(0, 0, 0, 59)
					Dropdown["4b"]["Name"] = [[Container]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Container.UIListLayout
					Dropdown["4c"] = Instance.new("UIListLayout", Dropdown["4b"])
					Dropdown["4c"]["Padding"] = UDim.new(0, 4)
					Dropdown["4c"]["SortOrder"] = Enum.SortOrder.LayoutOrder

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Container.UIPadding
					Dropdown["57"] = Instance.new("UIPadding", Dropdown["4b"])
					Dropdown["57"]["PaddingLeft"] = UDim.new(0, 8)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.UIGradient
					Dropdown["58"] = Instance.new("UIGradient", Dropdown["46"])
					Dropdown["58"]["Rotation"] = 90
					Dropdown["58"]["Color"] = ThemeColor.Main

					ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Dropdown["58"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Frame
					Dropdown["59"] = Instance.new("Frame", Dropdown["46"])
					Dropdown["59"]["BorderSizePixel"] = 0
					Dropdown["59"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Dropdown["59"]["BackgroundTransparency"] = 1
					Dropdown["59"]["Size"] = UDim2.new(0, 390, 0, 34)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Frame.UIListLayout
					Dropdown["5a"] = Instance.new("UIListLayout", Dropdown["59"])
					Dropdown["5a"]["VerticalAlignment"] = Enum.VerticalAlignment.Center
					Dropdown["5a"]["FillDirection"] = Enum.FillDirection.Horizontal
					Dropdown["5a"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Right
					Dropdown["5a"]["Padding"] = UDim.new(0, 8)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Frame.TextLabel
					Dropdown["5b"] = Instance.new("TextLabel", Dropdown["59"])
					Dropdown["5b"]["BorderSizePixel"] = 0
					Dropdown["5b"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Dropdown["5b"]

					Dropdown["5b"]["TextSize"] = 9
					Dropdown["5b"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Dropdown["5b"]
					Dropdown["5b"]["Size"] = UDim2.new(0, 50, 0, 15)
					Dropdown["5b"]["Font"] = Enum.Font.Gotham

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Frame.TextLabel.UICorner
					Dropdown["5c"] = Instance.new("UICorner", Dropdown["5b"])
					Dropdown["5c"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.TextBox
					Dropdown["5e"] = Instance.new("TextBox", Dropdown["46"])
					Dropdown["5e"]["CursorPosition"] = -1
					Dropdown["5e"]["PlaceholderColor3"] = ThemeColor.PlaceholderText

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Dropdown["5e"]

					Dropdown["5e"]["BorderSizePixel"] = 0
					Dropdown["5e"]["TextSize"] = 9
					Dropdown["5e"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Dropdown["5e"]["BackgroundColor3"] = ThemeColor.SecondaryTrue
					Dropdown["5e"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Dropdown["5e"]
					Dropdown["5e"]["FontFace"] = Font.new(
						[[rbxasset://fonts/families/GothamSSm.json]],
						Enum.FontWeight.Regular,
						Enum.FontStyle.Normal
					)
					Dropdown["5e"]["PlaceholderText"] = [[ Search]]
					Dropdown["5e"]["Size"] = UDim2.new(0, 397, 0, 9)
					Dropdown["5e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
					Dropdown["5e"]["Text"] = [[]]
					Dropdown["5e"]["Position"] = UDim2.new(0, 13, 0, 38)

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Dropdown["5e"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.TextBox.UIStroke
					Dropdown["5f"] = Instance.new("UIStroke", Dropdown["5e"])
					Dropdown["5f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border
					Dropdown["5f"]["Color"] = ThemeColor.SecondaryTrue
					Dropdown["5f"]["LineJoinMode"] = Enum.LineJoinMode.Round
					Dropdown["5f"]["Thickness"] = 7

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Dropdown["5f"]
				end

				table.insert(
					Dropdown.Connections,
					Dropdown["46"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				-- Handler
				do
					table.insert(
						Dropdown.Connections,
						Dropdown["46"].MouseEnter:Connect(function()
							Dropdown.Hover = true
							Library:PlaySound(LibSettings.HoverSound)

							Library:Tween(Dropdown["4a"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.MainTrue },
							})
						end)
					)

					table.insert(
						Dropdown.Connections,
						Dropdown["46"].MouseLeave:Connect(function()
							Dropdown.Hover = false

							Library:Tween(Dropdown["4a"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.SecondaryTrue },
							})
						end)
					)

					table.insert(
						Dropdown.Connections,
						Dropdown["5e"].MouseEnter:Connect(function()
							Dropdown.SearchHover = true
						end)
					)

					table.insert(
						Dropdown.Connections,
						Dropdown["5e"].MouseLeave:Connect(function()
							Dropdown.SearchHover = false
						end)
					)

					table.insert(
						Dropdown.Connections,
						Dropdown["5e"]:GetPropertyChangedSignal("Text"):Connect(function()
							if Dropdown["5e"].Text == "" then
								for i, v in pairs(Dropdown["4b"]:GetChildren()) do
									if v:IsA("Frame") then
										v.Visible = true
									end
								end
							else
								for i, v in pairs(Dropdown["4b"]:GetChildren()) do
									if v:IsA("Frame") then
										if string.find(string.lower(v.Name), string.lower(Dropdown["5e"].Text)) then
											v.Visible = true
										else
											v.Visible = false
										end
									end
								end
							end

							Dropdown:ResizeContainer()
						end)
					)

					table.insert(
						Dropdown.Connections,
						UserInputService.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and Dropdown.Hover then
								Library:PlaySound(LibSettings.ClickSound)
								Library:Tween(Dropdown["4a"], {
									Length = 0.2,
									Goal = { Color = Color3.fromRGB(86, 86, 86) },
								})

								if Dropdown.Hover then
									Library:Tween(Dropdown["4a"], {
										Length = 0.2,
										Goal = { Color = ThemeColor.MainTrue },
									})
								else
									Library:Tween(Dropdown["4a"], {
										Length = 0.2,
										Goal = { Color = ThemeColor.SecondaryTrue },
									})
								end

								do
									if Dropdown.ContainerOpened and not Dropdown.SearchHover then
										Dropdown.ContainerOpened = false

										Library:Tween(Dropdown["46"], {
											Length = 0.5,
											Goal = { Size = UDim2.fromOffset(423, 34) },
										})

										task.wait(0.7)
									else
										Dropdown.ContainerOpened = true

										do
											local NumChild = 0

											for i, v in pairs(Dropdown["4b"]:GetChildren()) do
												if v:IsA("Frame") and v.Visible == true then
													NumChild = NumChild + 1
												end
											end

											local FrameYOffset = 27 * NumChild + 4 * NumChild + 38 + 23

											Library:Tween(Dropdown["46"], {
												Length = 0.5,
												Goal = { Size = UDim2.fromOffset(423, FrameYOffset) },
											})
										end
									end

									task.wait(0.7)
								end
							end
						end)
					)
				end

				-- Methods
				do
					function Dropdown:ResizeContainer()
						if Dropdown.ContainerOpened then
							local NumChild = 0

							for i, v in pairs(Dropdown["4b"]:GetChildren()) do
								if v:IsA("Frame") and v.Visible == true then
									NumChild = NumChild + 1
								end
							end

							local FrameYOffset = 27 * NumChild + 4 * NumChild + 38 + 23

							Library:Tween(Dropdown["46"], {
								Length = 0.5,
								Goal = { Size = UDim2.fromOffset(423, FrameYOffset) },
							})
						end
					end

					function Dropdown:AddItem(value)
						local DropdownOption = {
							Hover = false,
							CallbackVal = value,
						}

						do
							-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Container.Option 1
							DropdownOption["4d"] = Instance.new("Frame", Dropdown["4b"])
							DropdownOption["4d"]["BackgroundColor3"] = ThemeColor.Textbox

							ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = DropdownOption["4d"]

							DropdownOption["4d"]["Size"] = UDim2.new(0, 407, 0, 27)
							DropdownOption["4d"]["Position"] = UDim2.new(0, 7, 0, 22)
							DropdownOption["4d"]["Name"] = tostring(DropdownOption.CallbackVal)
							DropdownOption["4d"]["Visible"] = true

							-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Container.Option 1.UICorner
							DropdownOption["4e"] = Instance.new("UICorner", DropdownOption["4d"])
							DropdownOption["4e"]["CornerRadius"] = UDim.new(0, 4)

							-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Container.Option 1.Label
							DropdownOption["4f"] = Instance.new("TextLabel", DropdownOption["4d"])
							DropdownOption["4f"]["BorderSizePixel"] = 0
							DropdownOption["4f"]["TextXAlignment"] = Enum.TextXAlignment.Left
							DropdownOption["4f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
							DropdownOption["4f"]["TextSize"] = 13
							DropdownOption["4f"]["TextColor3"] = ThemeColor.Text

							ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = DropdownOption["4f"]
							DropdownOption["4f"]["Size"] = UDim2.new(0, 301, 0, 33)
							DropdownOption["4f"]["Text"] = tostring(value)
							DropdownOption["4f"]["Name"] = [[Label]]
							DropdownOption["4f"]["Font"] = Enum.Font.GothamMedium
							DropdownOption["4f"]["BackgroundTransparency"] = 1
							DropdownOption["4f"]["Position"] = UDim2.new(0, 14, 0, -3)

							-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Dropdown.Container.Option 1.UIStroke
							DropdownOption["50"] = Instance.new("UIStroke", DropdownOption["4d"])
							DropdownOption["50"]["Color"] = ThemeColor.MainTrue

							ThemeInstances["MainTrue"][#ThemeInstances["MainTrue"] + 1] = DropdownOption["50"]
						end

						table.insert(
							ConnectionBin,
							DropdownOption["4d"].MouseEnter:Connect(function()
								DropdownOption.Hover = true
								Library:PlaySound(LibSettings.HoverSound)

								Library:Tween(DropdownOption["50"], {
									Length = 0.5,
									Goal = { Color = ThemeColor.SecondaryTrue },
								})
							end)
						)

						table.insert(
							ConnectionBin,
							DropdownOption["4d"].MouseLeave:Connect(function()
								DropdownOption.Hover = false

								Library:Tween(DropdownOption["50"], {
									Length = 0.5,
									Goal = { Color = ThemeColor.MainTrue },
								})
							end)
						)

						table.insert(
							ConnectionBin,
							UserInputService.InputBegan:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 and DropdownOption.Hover then
									Library:PlaySound(LibSettings.ClickSound)
									Library:Tween(DropdownOption["50"], {
										Length = 0.2,
										Goal = { Color = Color3.fromRGB(86, 86, 86) },
									})

									task.spawn(function()
										options.Callback(DropdownOption.CallbackVal)
									end)

									if DropdownOption.Hover then
										Library:Tween(DropdownOption["50"], {
											Length = 0.2,
											Goal = { Color = ThemeColor.MainTrue },
										})
									else
										Library:Tween(DropdownOption["50"], {
											Length = 0.2,
											Goal = { Color = ThemeColor.SecondaryTrue },
										})
									end

									Dropdown.SelectedItem = DropdownOption.CallbackVal
									Dropdown["5b"].Text = tostring(Dropdown.SelectedItem)

									local Val
									repeat
										Val = Dropdown["5b"].TextBounds.X

										Library:Tween(Dropdown["5b"], {
											Length = 0.2,
											Goal = {
												Size = UDim2.new(0, (Dropdown["5b"].TextBounds.X + 14), 0, 21),
											},
										})
									until Val == Dropdown["5b"].TextBounds.X

									Library:Tween(Dropdown["5b"], {
										Length = 0.2,
										Goal = { Size = UDim2.new(0, (Dropdown["5b"].TextBounds.X + 14), 0, 21) },
									})
								end
							end)
						)

						if Dropdown.SelectedItem == nil then
							Dropdown.SelectedItem = DropdownOption.CallbackVal
							Dropdown["5b"].Text = tostring(Dropdown.SelectedItem)

							local Val
							repeat
								Val = Dropdown["5b"].TextBounds.X

								Library:Tween(Dropdown["5b"], {
									Length = 0.2,
									Goal = {
										Size = UDim2.new(0, (Dropdown["5b"].TextBounds.X + 14), 0, 21),
									},
								})
							until Val == Dropdown["5b"].TextBounds.X

							Library:Tween(Dropdown["5b"], {
								Length = 0.2,
								Goal = { Size = UDim2.new(0, (Dropdown["5b"].TextBounds.X + 14), 0, 21) },
							})
						end

						Dropdown:ResizeContainer()
					end

					function Dropdown:Clear()
						for i, v in pairs(Dropdown["4b"]:GetChildren()) do
							if v:IsA("Frame") then
								v:Destroy()
							end
						end

						local FrameYOffset = 34 + 4

						Dropdown:ResizeContainer()
					end

					function Dropdown:UpdateList(options)
						options = Library:PlaceDefaults({
							Items = {},
							Replace = true,
						}, options or {})

						if options.Replace then
							for i, v in pairs(Dropdown["4b"]:GetChildren()) do
								if v:IsA("Frame") then
									v:Destroy()
								end
							end
						end

						for i, v in pairs(options.Items) do
							Dropdown:AddItem(v)
						end
					end
				end

				do
					task.spawn(function()
						for i, v in pairs(options.Items) do
							Dropdown:AddItem(v)
						end
					end)
				end

				function Dropdown:Destroy()
					table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, Dropdown.Connections))

					local TotalConnection = #Dropdown.Connections
					local Disconnected = 0
					for i, v in next, Dropdown.Connections do
						pcall(function()
							v:Disconnect()
							Disconnected = Disconnected + 1
						end)
					end

					Dropdown["46"]:Destroy()
					print(
						"Removed dropdown, "
							.. tostring(Disconnected)
							.. " connections out of "
							.. TotalConnection
							.. " were disconnected."
					)

					task.spawn(function()
						Library:ResizeSection(Section["1e"])
						Library:ResizeCanvas(Tab["1d"])
					end)
				end

				table.insert(ControlsConnectionBin, Dropdown.Connections)

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)

				return Dropdown
			end

			function Section:Label(options)
				options = Library:PlaceDefaults({
					Name = "Label",
				}, options or {})

				local Label = {
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Label
					Label["78"] = Instance.new("Frame", Section["21"])
					Label["78"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Label["78"]["Size"] = UDim2.new(0, 423, 0, 34)
					Label["78"]["Position"] = UDim2.new(0, 17, 0, 22)
					Label["78"]["Name"] = [[Label]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Label.UICorner
					Label["79"] = Instance.new("UICorner", Label["78"])
					Label["79"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Label.UIGradient
					Label["7a"] = Instance.new("UIGradient", Label["78"])
					Label["7a"]["Rotation"] = 90
					Label["7a"]["Color"] = ThemeColor.Tertiary

					ThemeInstances["Tertiary"][#ThemeInstances["Tertiary"] + 1] = Label["7a"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Label.Label
					Label["7b"] = Instance.new("TextLabel", Label["78"])
					Label["7b"]["RichText"] = true
					Label["7b"]["BorderSizePixel"] = 0
					Label["7b"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Label["7b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Label["7b"]["TextSize"] = 13
					Label["7b"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Label["7b"]
					Label["7b"]["Name"] = "Label"
					Label["7b"]["Text"] = options.Name
					Label["7b"]["Font"] = Enum.Font.GothamMedium
					Label["7b"]["BackgroundTransparency"] = 1
					Label["7b"]["Position"] = UDim2.new(0, 21, 0, 0)
					Label["7b"]["TextWrapped"] = true

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Label.UIStroke
					Label["7c"] = Instance.new("UIStroke", Label["78"])
					Label["7c"]["Color"] = ThemeColor.MainTrue

					ThemeInstances["MainTrue"][#ThemeInstances["MainTrue"] + 1] = Label["7c"]
				end

				table.insert(
					Label.Connections,
					Label["78"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				-- Methods
				do
					function Label:SetName(name)
						Label["7b"]["Text"] = name

						local Val
						repeat
							Val = Label["7b"].TextBounds.Y

							Label["78"]["Size"] = UDim2.new(0, 423, 0, Label["7b"].TextBounds.Y + 21)
							Label["7b"]["Size"] = UDim2.new(0, 398, 0, Label["7b"].TextBounds.Y + 21)
						until Val == Label["7b"].TextBounds.Y
					end

					function Label:Destroy()
						table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, Label.Connections))

						local TotalConnection = #Label.Connections
						local Disconnected = 0
						for i, v in next, Label.Connections do
							pcall(function()
								v:Disconnect()
								Disconnected = Disconnected + 1
							end)
						end

						Label["78"]:Destroy()
						print(
							"Removed label, "
								.. tostring(Disconnected)
								.. " connections out of "
								.. TotalConnection
								.. " were disconnected."
						)

						task.spawn(function()
							Library:ResizeSection(Section["1e"])
							Library:ResizeCanvas(Tab["1d"])
						end)
					end

					table.insert(ControlsConnectionBin, Label.Connections)
				end

				task.spawn(function()
					local Val
					repeat
						Val = Label["7b"].TextBounds.Y

						Label["78"]["Size"] = UDim2.new(0, 423, 0, Label["7b"].TextBounds.Y + 21)
						Label["7b"]["Size"] = UDim2.new(0, 398, 0, Label["7b"].TextBounds.Y + 21)
					until Val == Label["7b"].TextBounds.Y
				end)

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)

				return Label
			end

			function Section:Colorpicker(options)
				options = Library:PlaceDefaults({
					Name = "Colorpicker",
					DefaultColor = Color3.new(1, 1, 1),
					Callback = function()
						return
					end,
				}, options or {})

				local Colorpicker = {
					ColorH = 1,
					ColorS = 1,
					ColorV = 1,
					Toggled = false,
					OldVal = nil,
					Connections = {},
				}

				do
					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker
					Colorpicker["7d"] = Instance.new("Frame", Section["21"])
					Colorpicker["7d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["7d"]["Size"] = UDim2.new(0, 423, 0, 34)
					Colorpicker["7d"]["ClipsDescendants"] = true
					Colorpicker["7d"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
					Colorpicker["7d"]["Position"] = UDim2.new(0, 0, 1.1666666269302368, 0)
					Colorpicker["7d"]["Name"] = [[Colorpicker]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.UICorner
					Colorpicker["7e"] = Instance.new("UICorner", Colorpicker["7d"])
					Colorpicker["7e"]["CornerRadius"] = UDim.new(0, 5)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.UIStroke
					Colorpicker["4a"] = Instance.new("UIStroke", Colorpicker["7d"])
					Colorpicker["4a"]["Color"] = ThemeColor.SecondaryTrue

					ThemeInstances["SecondaryTrue"][#ThemeInstances["SecondaryTrue"] + 1] = Colorpicker["4a"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Hue
					Colorpicker["7f"] = Instance.new("ImageLabel", Colorpicker["7d"])
					Colorpicker["7f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["7f"]["AnchorPoint"] = Vector2.new(0.5, 0)
					Colorpicker["7f"]["Size"] = UDim2.new(0, 14, 0, 148)
					Colorpicker["7f"]["Name"] = [[Hue]]
					Colorpicker["7f"]["Position"] = UDim2.new(0, 369, 0, 38)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Hue.HueCorner
					Colorpicker["80"] = Instance.new("UICorner", Colorpicker["7f"])
					Colorpicker["80"]["Name"] = [[HueCorner]]
					Colorpicker["80"]["CornerRadius"] = UDim.new(0, 3)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Hue.HueGradient
					Colorpicker["81"] = Instance.new("UIGradient", Colorpicker["7f"])
					Colorpicker["81"]["Name"] = [[HueGradient]]
					Colorpicker["81"]["Rotation"] = 270
					Colorpicker["81"]["Color"] = ColorSequence.new({
						ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 0, 5)),
						ColorSequenceKeypoint.new(0.087, Color3.fromRGB(239, 0, 255)),
						ColorSequenceKeypoint.new(0.230, Color3.fromRGB(18, 0, 255)),
						ColorSequenceKeypoint.new(0.443, Color3.fromRGB(3, 176, 255)),
						ColorSequenceKeypoint.new(0.582, Color3.fromRGB(167, 255, 0)),
						ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 26, 26)),
					})

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Hue.Frame
					Colorpicker["82"] = Instance.new("Frame", Colorpicker["7f"])
					Colorpicker["82"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["82"]["Size"] = UDim2.new(0, 25, 0, 5)
					Colorpicker["82"]["Position"] = UDim2.new(-0.3571428656578064, 0, 0.8500000238418579, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Hue.Frame.UICorner
					Colorpicker["83"] = Instance.new("UICorner", Colorpicker["82"])
					Colorpicker["83"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Color
					Colorpicker["84"] = Instance.new("ImageLabel", Colorpicker["7d"])
					Colorpicker["84"]["ZIndex"] = 10
					Colorpicker["84"]["BackgroundColor3"] = Color3.fromRGB(255, 4, 8)
					Colorpicker["84"]["AnchorPoint"] = Vector2.new(0.5, 0)
					Colorpicker["84"]["Image"] = [[rbxassetid://4155801252]]
					Colorpicker["84"]["Size"] = UDim2.new(0, 300, 0, 148)
					Colorpicker["84"]["Name"] = [[Color]]
					Colorpicker["84"]["Position"] = UDim2.new(0, 195, 0, 38)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Color.ColorCorner
					Colorpicker["85"] = Instance.new("UICorner", Colorpicker["84"])
					Colorpicker["85"]["Name"] = [[ColorCorner]]
					Colorpicker["85"]["CornerRadius"] = UDim.new(0, 3)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Color.ColorSelection
					Colorpicker["86"] = Instance.new("ImageLabel", Colorpicker["84"])
					Colorpicker["86"]["BorderSizePixel"] = 0
					Colorpicker["86"]["ScaleType"] = Enum.ScaleType.Fit
					Colorpicker["86"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["86"]["BorderMode"] = Enum.BorderMode.Inset
					Colorpicker["86"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
					Colorpicker["86"]["Image"] = [[http://www.roblox.com/asset/?id=4805639000]]
					Colorpicker["86"]["Size"] = UDim2.new(0, 18, 0, 18)
					Colorpicker["86"]["Name"] = [[ColorSelection]]
					Colorpicker["86"]["BackgroundTransparency"] = 1
					Colorpicker["86"]["Position"] = UDim2.new(0.8784236311912537, 0, 0.16129031777381897, 0)
					Colorpicker["86"]["ImageTransparency"] = 1

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.UIGradient
					Colorpicker["87"] = Instance.new("UIGradient", Colorpicker["7d"])
					Colorpicker["87"]["Rotation"] = 90
					Colorpicker["87"]["Color"] = ThemeColor.Main

					ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Colorpicker["87"]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Box
					Colorpicker["88"] = Instance.new("Frame", Colorpicker["7d"])
					Colorpicker["88"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
					Colorpicker["88"]["AnchorPoint"] = Vector2.new(1, 0.5)
					Colorpicker["88"]["Size"] = UDim2.new(0, 21, 0, 21)
					Colorpicker["88"]["Position"] = UDim2.new(0, 412, 0, 16)
					Colorpicker["88"]["Name"] = [[Box]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Box.UICorner
					Colorpicker["89"] = Instance.new("UICorner", Colorpicker["88"])
					Colorpicker["89"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.Label
					Colorpicker["8a"] = Instance.new("TextLabel", Colorpicker["7d"])
					Colorpicker["8a"]["BorderSizePixel"] = 0
					Colorpicker["8a"]["TextXAlignment"] = Enum.TextXAlignment.Left
					Colorpicker["8a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["8a"]["TextSize"] = 13
					Colorpicker["8a"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["8a"]
					Colorpicker["8a"]["Size"] = UDim2.new(0, 301, 0, 33)
					Colorpicker["8a"]["Text"] = options.Name
					Colorpicker["8a"]["Name"] = [[Label]]
					Colorpicker["8a"]["Font"] = Enum.Font.GothamMedium
					Colorpicker["8a"]["BackgroundTransparency"] = 1
					Colorpicker["8a"]["Position"] = UDim2.new(0, 21, 0, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder
					Colorpicker["8b"] = Instance.new("Frame", Colorpicker["7d"])
					Colorpicker["8b"]["BorderSizePixel"] = 0
					Colorpicker["8b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["8b"]["BackgroundTransparency"] = 1
					Colorpicker["8b"]["Size"] = UDim2.new(0, 400, 0, 36)
					Colorpicker["8b"]["Position"] = UDim2.new(0, 10, 0, 192)
					Colorpicker["8b"]["Name"] = [[HSVHolder]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Hue
					Colorpicker["8c"] = Instance.new("Frame", Colorpicker["8b"])
					Colorpicker["8c"]["BorderSizePixel"] = 0
					Colorpicker["8c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["8c"]["BackgroundTransparency"] = 1
					Colorpicker["8c"]["Size"] = UDim2.new(0, 91, 0, 37)
					Colorpicker["8c"]["Name"] = [[Hue]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Hue.TextLabel
					Colorpicker["8d"] = Instance.new("TextLabel", Colorpicker["8c"])
					Colorpicker["8d"]["TextWrapped"] = true
					Colorpicker["8d"]["BorderSizePixel"] = 0
					Colorpicker["8d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["8d"]["TextSize"] = 11
					Colorpicker["8d"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["8d"]
					Colorpicker["8d"]["Size"] = UDim2.new(0, 45, 0, 25)
					Colorpicker["8d"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
					Colorpicker["8d"]["Text"] = [[Hue]]
					Colorpicker["8d"]["Font"] = Enum.Font.Gotham
					Colorpicker["8d"]["BackgroundTransparency"] = 1
					Colorpicker["8d"]["Position"] = UDim2.new(-0.0012891516089439392, 0, 0.13513514399528503, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Hue.TextBox
					Colorpicker["8e"] = Instance.new("TextBox", Colorpicker["8c"])
					Colorpicker["8e"]["ZIndex"] = 5
					Colorpicker["8e"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["8e"]
					Colorpicker["8e"]["TextWrapped"] = true
					Colorpicker["8e"]["TextSize"] = 11
					Colorpicker["8e"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Colorpicker["8e"]

					Colorpicker["8e"]["Size"] = UDim2.new(0, 42, 0, 18)
					Colorpicker["8e"]["Text"] = [[256]]
					Colorpicker["8e"]["Position"] = UDim2.new(0.4914590120315552, 0, 0.25, 0)
					Colorpicker["8e"]["Font"] = Enum.Font.Gotham

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Red.TextBox.UICorner
					Colorpicker["8f"] = Instance.new("UICorner", Colorpicker["8e"])
					Colorpicker["8f"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.UIListLayout
					Colorpicker["90"] = Instance.new("UIListLayout", Colorpicker["8b"])
					Colorpicker["90"]["FillDirection"] = Enum.FillDirection.Horizontal
					Colorpicker["90"]["SortOrder"] = Enum.SortOrder.LayoutOrder

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Sat
					Colorpicker["91"] = Instance.new("Frame", Colorpicker["8b"])
					Colorpicker["91"]["BorderSizePixel"] = 0
					Colorpicker["91"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["91"]["BackgroundTransparency"] = 1
					Colorpicker["91"]["Size"] = UDim2.new(0, 91, 0, 37)
					Colorpicker["91"]["Name"] = [[Sat]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Sat.TextLabel
					Colorpicker["92"] = Instance.new("TextLabel", Colorpicker["91"])
					Colorpicker["92"]["TextWrapped"] = true
					Colorpicker["92"]["BorderSizePixel"] = 0
					Colorpicker["92"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["92"]["TextSize"] = 11
					Colorpicker["92"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["92"]
					Colorpicker["92"]["Size"] = UDim2.new(0, 45, 0, 25)
					Colorpicker["92"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
					Colorpicker["92"]["Text"] = [[Sat]]
					Colorpicker["92"]["Font"] = Enum.Font.Gotham
					Colorpicker["92"]["BackgroundTransparency"] = 1
					Colorpicker["92"]["Position"] = UDim2.new(-0.0012891516089439392, 0, 0.13513514399528503, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Sat.TextBox
					Colorpicker["93"] = Instance.new("TextBox", Colorpicker["91"])
					Colorpicker["93"]["ZIndex"] = 5
					Colorpicker["93"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["93"]
					Colorpicker["93"]["TextWrapped"] = true
					Colorpicker["93"]["TextSize"] = 11
					Colorpicker["93"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Colorpicker["93"]

					Colorpicker["93"]["Size"] = UDim2.new(0, 42, 0, 18)
					Colorpicker["93"]["Text"] = [[256]]
					Colorpicker["93"]["Position"] = UDim2.new(0.4914590120315552, 0, 0.25, 0)
					Colorpicker["93"]["Font"] = Enum.Font.Gotham

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Sat.TextBox.UICorner
					Colorpicker["94"] = Instance.new("UICorner", Colorpicker["93"])
					Colorpicker["94"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Value
					Colorpicker["95"] = Instance.new("Frame", Colorpicker["8b"])
					Colorpicker["95"]["BorderSizePixel"] = 0
					Colorpicker["95"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["95"]["BackgroundTransparency"] = 1
					Colorpicker["95"]["Size"] = UDim2.new(0, 91, 0, 37)
					Colorpicker["95"]["Name"] = [[Value]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Value.TextLabel
					Colorpicker["96"] = Instance.new("TextLabel", Colorpicker["95"])
					Colorpicker["96"]["TextWrapped"] = true
					Colorpicker["96"]["BorderSizePixel"] = 0
					Colorpicker["96"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["96"]["TextSize"] = 11
					Colorpicker["96"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["96"]
					Colorpicker["96"]["Size"] = UDim2.new(0, 45, 0, 25)
					Colorpicker["96"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
					Colorpicker["96"]["Text"] = [[Value]]
					Colorpicker["96"]["Font"] = Enum.Font.Gotham
					Colorpicker["96"]["BackgroundTransparency"] = 1
					Colorpicker["96"]["Position"] = UDim2.new(-0.0012891516089439392, 0, 0.13513514399528503, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Value.TextBox
					Colorpicker["97"] = Instance.new("TextBox", Colorpicker["95"])
					Colorpicker["97"]["ZIndex"] = 5
					Colorpicker["97"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["97"]
					Colorpicker["97"]["TextWrapped"] = true
					Colorpicker["97"]["TextSize"] = 11
					Colorpicker["97"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Colorpicker["97"]

					Colorpicker["97"]["Size"] = UDim2.new(0, 42, 0, 18)
					Colorpicker["97"]["Text"] = [[256]]
					Colorpicker["97"]["Position"] = UDim2.new(0.4914590120315552, 0, 0.25, 0)
					Colorpicker["97"]["Font"] = Enum.Font.Gotham

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HSVHolder.Value.TextBox.UICorner
					Colorpicker["98"] = Instance.new("UICorner", Colorpicker["97"])
					Colorpicker["98"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HexTextbox
					Colorpicker["99"] = Instance.new("Frame", Colorpicker["7d"])
					Colorpicker["99"]["ZIndex"] = 5
					Colorpicker["99"]["BorderSizePixel"] = 0
					Colorpicker["99"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["99"]["BackgroundTransparency"] = 1
					Colorpicker["99"]["Size"] = UDim2.new(0, 91, 0, 37)
					Colorpicker["99"]["Position"] = UDim2.new(0, 300, 0, 192)
					Colorpicker["99"]["Name"] = [[HexTextbox]]

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HexTextbox.TextLabel
					Colorpicker["9a"] = Instance.new("TextLabel", Colorpicker["99"])
					Colorpicker["9a"]["TextWrapped"] = true
					Colorpicker["9a"]["BorderSizePixel"] = 0
					Colorpicker["9a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["9a"]["TextSize"] = 11
					Colorpicker["9a"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["9a"]
					Colorpicker["9a"]["Size"] = UDim2.new(0, 64, 0, 25)
					Colorpicker["9a"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
					Colorpicker["9a"]["Text"] = [[Hex Code]]
					Colorpicker["9a"]["Font"] = Enum.Font.Gotham
					Colorpicker["9a"]["BackgroundTransparency"] = 1
					Colorpicker["9a"]["Position"] = UDim2.new(-0.14590352773666382, 0, 0.13513512909412384, 0)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HexTextbox.TextBox
					Colorpicker["9b"] = Instance.new("TextBox", Colorpicker["99"])
					Colorpicker["9b"]["CursorPosition"] = -1
					Colorpicker["9b"]["ZIndex"] = 5
					Colorpicker["9b"]["TextColor3"] = ThemeColor.Text

					ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Colorpicker["9b"]
					Colorpicker["9b"]["TextWrapped"] = true
					Colorpicker["9b"]["TextSize"] = 11
					Colorpicker["9b"]["BackgroundColor3"] = ThemeColor.Textbox

					ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Colorpicker["9b"]

					Colorpicker["9b"]["Size"] = UDim2.new(0, 63, 0, 18)
					Colorpicker["9b"]["Text"] = [[#f1eaff]]
					Colorpicker["9b"]["Position"] = UDim2.new(0.5354151725769043, 0, 0.25, 0)
					Colorpicker["9b"]["Font"] = Enum.Font.Gotham

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.HexTextbox.TextBox.UICorner
					Colorpicker["9c"] = Instance.new("UICorner", Colorpicker["9b"])
					Colorpicker["9c"]["CornerRadius"] = UDim.new(0, 4)

					-- StarterGui.Vision Lib v2.GuiFrame.MainFrame.Container.SectionFrame.SectionContainer.Colorpicker.ToggleDetector
					Colorpicker["9d"] = Instance.new("TextButton", Colorpicker["7d"])
					Colorpicker["9d"]["TextSize"] = 14
					Colorpicker["9d"]["TextTransparency"] = 1
					Colorpicker["9d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
					Colorpicker["9d"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
					Colorpicker["9d"]["Size"] = UDim2.new(0, 423, 0, 34)
					Colorpicker["9d"]["Name"] = [[ToggleDetector]]
					Colorpicker["9d"]["Font"] = Enum.Font.SourceSans
					Colorpicker["9d"]["BackgroundTransparency"] = 1
				end

				table.insert(
					Colorpicker.Connections,
					Colorpicker["7d"]:GetPropertyChangedSignal("Size"):Connect(function()
						Library:ResizeSection(Section["1e"])
					end)
				)

				-- Methods
				do
					function Colorpicker:UpdateColorPicker()
						Library:Tween(Colorpicker["88"], {
							Length = 0.5,
							Goal = {
								BackgroundColor3 = Color3.fromHSV(
									Colorpicker.ColorH,
									Colorpicker.ColorS,
									Colorpicker.ColorV
								),
							},
						})

						Library:Tween(Colorpicker["84"], {
							Length = 0.5,
							Goal = { BackgroundColor3 = Color3.fromHSV(Colorpicker.ColorH, 1, 1) },
						})
						pcall(function()
							if
								Colorpicker.OldVal
								~= Color3.fromHSV(Colorpicker.ColorH, Colorpicker.ColorS, Colorpicker.ColorV)
							then
								options.Callback(
									Color3.fromHSV(Colorpicker.ColorH, Colorpicker.ColorS, Colorpicker.ColorV)
								)
							end
						end)
						Colorpicker.OldVal = Color3.fromHSV(Colorpicker.ColorH, Colorpicker.ColorS, Colorpicker.ColorV)
						Colorpicker:updateTextboxVal()
					end

					function Colorpicker:SetColor(Color)
						local H, S, V = Color:ToHSV()
						Colorpicker.ColorH = H
						Colorpicker.ColorS = S
						Colorpicker.ColorV = V

						Library:Tween(Colorpicker["82"], {
							Length = 0.5,
							Goal = { Position = UDim2.new(-0.357, 0, H, 0) },
						})

						local VisualColorY = 1 - Colorpicker.ColorV

						Library:Tween(Colorpicker["86"], {
							Length = 0.5,
							Goal = { Position = UDim2.new(Colorpicker.ColorS, 0, VisualColorY, 0) },
						})
						Colorpicker:UpdateColorPicker()
					end

					function Colorpicker:updateTextboxVal()
						Colorpicker["8e"]["Text"] = math.floor(Colorpicker.ColorH * 256)
						Colorpicker["93"]["Text"] = math.floor(Colorpicker.ColorS * 256)
						Colorpicker["97"]["Text"] = math.floor(Colorpicker.ColorV * 256)

						Colorpicker["9b"].Text = Colorpicker.OldVal:ToHex()
					end

					function Colorpicker:Destroy()
						table.remove(ControlsConnectionBin, table.find(ControlsConnectionBin, Colorpicker.Connections))

						local TotalConnection = #Colorpicker.Connections
						local Disconnected = 0
						for i, v in next, Colorpicker.Connections do
							pcall(function()
								v:Disconnect()
								Disconnected = Disconnected + 1
							end)
						end

						Colorpicker["7d"]:Destroy()
						print(
							"Removed colorpicker, "
								.. tostring(Disconnected)
								.. " connections out of "
								.. TotalConnection
								.. " were disconnected."
						)

						task.spawn(function()
							Library:ResizeSection(Section["1e"])
							Library:ResizeCanvas(Tab["1d"])
						end)
					end
				end

				-- Handler
				do
					table.insert(
						Colorpicker.Connections,
						Colorpicker["7d"].MouseEnter:Connect(function()
							Library:Tween(Colorpicker["4a"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.MainTrue },
							})

							Library:PlaySound(LibSettings.HoverSound)
						end)
					)

					table.insert(
						Colorpicker.Connections,
						Colorpicker["7d"].MouseLeave:Connect(function()
							Library:Tween(Colorpicker["4a"], {
								Length = 0.5,
								Goal = { Color = ThemeColor.SecondaryTrue },
							})
						end)
					)

					Colorpicker.ColorH = 1
						- (
							1
							- math.clamp(
									Colorpicker["82"].AbsolutePosition.Y - Colorpicker["7f"].AbsolutePosition.Y,
									0,
									Colorpicker["7f"].AbsoluteSize.Y
								)
								/ Colorpicker["7f"].AbsoluteSize.Y
						)
					Colorpicker.ColorS = (
						math.clamp(
							Colorpicker["86"].AbsolutePosition.X - Colorpicker["84"].AbsolutePosition.X,
							0,
							Colorpicker["84"].AbsoluteSize.X
						) / Colorpicker["84"].AbsoluteSize.X
					)
					Colorpicker.ColorV = 1
						- (
							math.clamp(
								Colorpicker["86"].AbsolutePosition.Y - Colorpicker["84"].AbsolutePosition.Y,
								0,
								Colorpicker["84"].AbsoluteSize.Y
							) / Colorpicker["84"].AbsoluteSize.Y
						)

					table.insert(
						Colorpicker.Connections,
						Colorpicker["9d"].MouseButton1Click:Connect(function()
							Library:PlaySound(LibSettings.ClickSound)
							Colorpicker.Toggled = not Colorpicker.Toggled

							if Colorpicker.Toggled then
								Library:Tween(Colorpicker["86"], {
									Length = 0.5,
									Goal = { ImageTransparency = 0 },
								})

								Library:Tween(Colorpicker["7d"], {
									Length = 0.5,
									Goal = { Size = UDim2.fromOffset(423, 231) },
								})
							else
								Library:Tween(Colorpicker["86"], {
									Length = 0.5,
									Goal = { ImageTransparency = 1 },
								})

								Library:Tween(Colorpicker["7d"], {
									Length = 0.5,
									Goal = { Size = UDim2.fromOffset(423, 35) },
								})
							end
						end)
					)

					local SelectingColor

					table.insert(
						Colorpicker.Connections,
						Colorpicker["84"].InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								Library:PlaySound(LibSettings.ClickSound)

								if SelectingColor then
									SelectingColor:Disconnect()
								end

								Library.Sliding = true
								SelectingColor = RunService.RenderStepped:Connect(function()
									local ColorX = (
										math.clamp(
											Mouse.X - Colorpicker["84"].AbsolutePosition.X,
											0,
											Colorpicker["84"].AbsoluteSize.X
										) / Colorpicker["84"].AbsoluteSize.X
									)
									local ColorY = (
										math.clamp(
											Mouse.Y - Colorpicker["84"].AbsolutePosition.Y,
											0,
											Colorpicker["84"].AbsoluteSize.Y
										) / Colorpicker["84"].AbsoluteSize.Y
									)
									Colorpicker["86"].Position = UDim2.new(ColorX, 0, ColorY, 0)
									Colorpicker.ColorS = ColorX
									Colorpicker.ColorV = 1 - ColorY
									Colorpicker:UpdateColorPicker()
								end)
							end
						end)
					)

					table.insert(
						Colorpicker.Connections,
						Colorpicker["84"].InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								Library:PlaySound(LibSettings.ClickSound)

								if SelectingColor then
									SelectingColor:Disconnect()
								end
								Library.Sliding = false
							end
						end)
					)

					local SelectingHue

					table.insert(
						Colorpicker.Connections,
						Colorpicker["7f"].InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								Library:PlaySound(LibSettings.ClickSound)

								if SelectingHue then
									SelectingHue:Disconnect()
								end

								Library.Sliding = true
								SelectingHue = RunService.RenderStepped:Connect(function()
									local HueY = (
										1
										- math.clamp(
												Mouse.Y - Colorpicker["7f"].AbsolutePosition.Y,
												0,
												Colorpicker["7f"].AbsoluteSize.Y
											)
											/ Colorpicker["7f"].AbsoluteSize.Y
									)
									local VisualHueY = (
										math.clamp(
											Mouse.Y - Colorpicker["7f"].AbsolutePosition.Y,
											0,
											Colorpicker["7f"].AbsoluteSize.Y
										) / Colorpicker["7f"].AbsoluteSize.Y
									)

									Colorpicker["82"].Position = UDim2.new(-0.357, 0, VisualHueY, 0)
									Colorpicker.ColorH = 1 - HueY

									Colorpicker:UpdateColorPicker()
								end)
							end
						end)
					)

					table.insert(
						Colorpicker.Connections,
						Colorpicker["7f"].InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								Library:PlaySound(LibSettings.ClickSound)

								if SelectingHue then
									SelectingHue:Disconnect()
								end
								Library.Sliding = false
							end
						end)
					)

					local function checkHex(hex)
						local success, result = pcall(function()
							return Color3.fromHex(hex)
						end)

						return success
					end

					local function checkValidHSV(hsv)
						if hsv >= 0 and hsv <= 1 then
							return true
						else
							return false
						end
					end

					table.insert(
						Colorpicker.Connections,
						Colorpicker["9b"].FocusLost:Connect(function()
							local HexCode = Colorpicker["9b"].Text
							local isHex = checkHex(HexCode)
							if isHex then
								Colorpicker:SetColor(Color3.fromHex(HexCode))
							else
								Colorpicker:updateTextboxVal()
							end
						end)
					)

					table.insert(
						Colorpicker.Connections,
						Colorpicker["8e"].FocusLost:Connect(function()
							local numVal
							local success = pcall(function()
								local ColorCode = tonumber(Colorpicker["8e"].Text)
								ColorCode = ColorCode / 256
								local valid = checkValidHSV(ColorCode)

								if valid then
									Colorpicker:SetColor(
										Color3.fromHSV(ColorCode, Colorpicker.ColorS, Colorpicker.ColorV)
									)
								else
									Colorpicker:updateTextboxVal()
								end
							end)

							if not success then
								Colorpicker:updateTextboxVal()
							end
						end)
					)

					table.insert(
						Colorpicker.Connections,
						Colorpicker["93"].FocusLost:Connect(function()
							local numVal
							local success = pcall(function()
								local ColorCode = tonumber(Colorpicker["93"].Text)
								ColorCode = ColorCode / 256
								local valid = checkValidHSV(ColorCode)

								if valid then
									Colorpicker:SetColor(
										Color3.fromHSV(Colorpicker.ColorH, ColorCode, Colorpicker.ColorV)
									)
								else
									Colorpicker:updateTextboxVal()
								end
							end)

							if not success then
								Colorpicker:updateTextboxVal()
							end
						end)
					)

					table.insert(
						Colorpicker.Connections,
						Colorpicker["97"].FocusLost:Connect(function()
							local numVal
							local success = pcall(function()
								local ColorCode = tonumber(Colorpicker["97"].Text)
								ColorCode = ColorCode / 256
								local valid = checkValidHSV(ColorCode)

								if valid then
									Colorpicker:SetColor(
										Color3.fromHSV(Colorpicker.ColorH, Colorpicker.ColorS, ColorCode)
									)
								else
									Colorpicker:updateTextboxVal()
								end
							end)

							if not success then
								Colorpicker:updateTextboxVal()
							end
						end)
					)

					table.insert(ControlsConnectionBin, Colorpicker.Connections)
				end

				Colorpicker:SetColor(options.DefaultColor)

				task.spawn(function()
					Library:ResizeSection(Section["1e"])
					Library:ResizeCanvas(Tab["1d"])
				end)
				return Colorpicker
			end

			--[[
			function Section:Template(options)
				options = Library:PlaceDefaults({
					Name = "Template",
					Callback = function() return end
				}, options or {})

				local Template = {
					Hover = false
				}

				do
				end

				-- Handler
				do
				end

				-- Methods
				do
					
				end

				return Template
			end
			]]
			--

			return Section
		end

		-- Handler
		do
			local ToolTip

			table.insert(
				ConnectionBin,
				Tab["8"].MouseEnter:Connect(function()
					Library:PlaySound(LibSettings.HoverSound)
					ToolTip = Library:ToolTip(options.Name)
					Tab.Hover = true

					local tweeninfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
					local tween = TweenService:Create(Tab["a"], tweeninfo, { Rotation = 180 })
					tween:Play()

					tween.Completed:Wait()

					repeat
						local rot = Tab["a"].Rotation + 45

						if rot == 405 then
							rot = 45
						end

						local tweeninfo = TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
						local tween = TweenService:Create(Tab["a"], tweeninfo, { Rotation = rot })
						tween:Play()

						tween.Completed:Wait()

						if Tab["a"].Rotation == 360 then
							Tab["a"].Rotation = 0
						end
					until Tab.Hover == false
				end)
			)

			table.insert(
				ConnectionBin,
				Tab["8"].MouseLeave:Connect(function()
					ToolTip:Destroy()

					Library:Tween(Tab["a"], {
						Length = 0.3,
						Goal = { Rotation = 45 },
					})

					Tab.Hover = false
				end)
			)

			table.insert(
				ConnectionBin,
				UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Tab.Hover then
						Library:PlaySound(LibSettings.ClickSound)
						if Gui.CurrentTab == Tab and not Gui.Hidden then
							Library:Tween(Gui["18"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, 0, 0, 452) },
							})

							Library:Tween(Gui["18"], {
								Length = 0.3,
								Goal = { Size = UDim2.new(0, 498, 0, 0) },
							})

							Gui.Hidden = true
						else
							Library:Tween(Gui["18"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, 0, 0, 0) },
							})

							Library:Tween(Gui["18"], {
								Length = 0.3,
								Goal = { Size = UDim2.new(0, 498, 0, 452) },
							})

							Gui.Hidden = false
						end

						Tab:Activate()
					end
				end)
			)

			function Tab:Activate()
				if not Tab.Active then
					if Gui.CurrentTab ~= nil then
						Gui.CurrentTab:Deactivate(Tab.Index)
					end

					task.spawn(function()
						options.ActivationCallback()
					end)

					task.spawn(function()
						local Color = options.Color
						local h, s, v = Color:ToHSV()
						local NewV = v - 0.75
						if NewV < 0 then
							NewV = 0
						end

						local p0 = Color3.fromHSV(h, s, v)
						local p1 = Color3.fromHSV(h, s, NewV)

						local defaultP0 = Instance.new("Color3Value")
						defaultP0.Value = Color3.fromRGB(125, 125, 125)

						local defaultP1 = Instance.new("Color3Value")
						defaultP1.Value = Color3.fromRGB(31, 31, 31)

						Library:Tween(defaultP0, {
							Length = 0.5,
							Goal = { Value = p0 },
						})

						local TweenCompleted = false

						Library:Tween(defaultP1, {
							Length = 0.5,
							Goal = { Value = p1 },
						}, function()
							TweenCompleted = true
						end)

						repeat
							Tab["a"]["Color"] = ColorSequence.new({
								ColorSequenceKeypoint.new(0, defaultP0.Value),
								ColorSequenceKeypoint.new(1, defaultP1.Value),
							})
							RunService.RenderStepped:Wait()
						until TweenCompleted
					end)

					Tab.Active = true

					task.spawn(function()
						while Tab.Active do
							local rot = Tab["a"].Rotation + 45

							if rot == 405 then
								rot = 45
							end

							local tweeninfo = TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
							local tween = TweenService:Create(Tab["a"], tweeninfo, { Rotation = rot })
							tween:Play()

							tween.Completed:Wait()

							if Tab["a"].Rotation == 360 then
								Tab["a"].Rotation = 0
							end
						end
					end)

					if Gui.CurrentTabIndex < Tab.Index then
						task.spawn(function()
							task.wait(0.3)
							Gui["1c"]["Text"] = options.Name
							Gui["1c"]["Position"] = UDim2.new(0, 498, 0, 5)
							Tab["1d"]["Position"] = UDim2.new(0, 498, 0, 35)
							Tab["1d"]["Visible"] = true

							Library:Tween(Gui["1c"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, 14, 0, 5) },
							})

							Library:Tween(Tab["1d"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, 0, 0, 35) },
							})
						end)
					else
						task.spawn(function()
							task.wait(0.3)
							Gui["1c"]["Text"] = options.Name
							Gui["1c"]["Position"] = UDim2.new(0, -498, 0, 5)
							Tab["1d"]["Position"] = UDim2.new(0, -498, 0, 35)
							Tab["1d"]["Visible"] = true

							Library:Tween(Gui["1c"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, 14, 0, 5) },
							})

							Library:Tween(Tab["1d"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, 0, 0, 35) },
							})
						end)
					end

					Gui.CurrentTabIndex = Tab.Index
					Gui.CurrentTab = Tab
				end
			end

			function Tab:Deactivate(newtabindex)
				if Tab.Active then
					Tab.Active = false

					task.spawn(function()
						options.DeativationCallback()
					end)

					task.spawn(function()
						local Color = options.Color
						local h, s, v = Color:ToHSV()
						local NewV = v - 0.75
						if NewV < 0 then
							NewV = 0
						end

						local p0 = Color3.fromHSV(h, s, v)
						local p1 = Color3.fromHSV(h, s, NewV)

						local defaultP0 = Instance.new("Color3Value")
						defaultP0.Value = p0

						local defaultP1 = Instance.new("Color3Value")
						defaultP1.Value = p1

						Library:Tween(defaultP0, {
							Length = 0.5,
							Goal = { Value = Color3.fromRGB(125, 125, 125) },
						})

						local TweenCompleted = false

						Library:Tween(defaultP1, {
							Length = 0.5,
							Goal = { Value = Color3.fromRGB(31, 31, 31) },
						}, function()
							TweenCompleted = true
						end)

						repeat
							Tab["a"]["Color"] = ColorSequence.new({
								ColorSequenceKeypoint.new(0, defaultP0.Value),
								ColorSequenceKeypoint.new(1, defaultP1.Value),
							})
							RunService.RenderStepped:Wait()
						until TweenCompleted
					end)

					if Gui.CurrentTabIndex < newtabindex then
						task.spawn(function()
							Library:Tween(Gui["1c"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, -498, 0, 5) },
							})

							Library:Tween(Tab["1d"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, -498, 0, 35) },
							})

							task.wait(0.3)
							Tab["1d"]["Visible"] = false
						end)
					else
						task.spawn(function()
							Library:Tween(Gui["1c"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, 498, 0, 5) },
							})

							Library:Tween(Tab["1d"], {
								Length = 0.3,
								Goal = { Position = UDim2.new(0, 498, 0, 35) },
							})

							task.wait(0.3)
							Tab["1d"]["Visible"] = false
						end)
					end
				end
			end

			if Gui.CurrentTab == nil then
				Tab:Activate()
			end
		end

		Library:ResizeTabCanvas()

		return Tab
	end

	-- Handler
	do
		table.insert(
			ConnectionBin,
			UserInputService.InputBegan:Connect(function(input)
				if Library.MainFrameHover then
					if input.UserInputType == Enum.UserInputType.MouseButton1 and not Library.Sliding then
						local ObjectPosition =
							Vector2.new(Mouse.X - Gui["2"].AbsolutePosition.X, Mouse.Y - Gui["2"].AbsolutePosition.Y)

						while
							RunService.RenderStepped:wait()
							and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						do
							if not Library.Sliding then
								Library:Tween(Gui["2"], {
									Goal = {
										Position = UDim2.fromOffset(
											Mouse.X
												- ObjectPosition.X
												+ (Gui["2"].Size.X.Offset * Gui["2"].AnchorPoint.X),
											Mouse.Y
												- ObjectPosition.Y
												+ (Gui["2"].Size.Y.Offset * Gui["2"].AnchorPoint.Y)
										),
									},
									Style = Enum.EasingStyle.Linear,
									Direction = Enum.EasingDirection.InOut,
									Length = LibSettings.DragSpeed,
								})
							end
						end
					end
				end
			end)
		)

		table.insert(
			ConnectionBin,
			Gui["2"].MouseEnter:Connect(function()
				Library.MainFrameHover = true
			end)
		)

		table.insert(
			ConnectionBin,
			Gui["2"].MouseLeave:Connect(function()
				Library.MainFrameHover = false
			end)
		)
	end

	-- Nav Clock
	do
		task.spawn(function()
			while wait() do
				local t = tick()
				local sec = math.floor(t % 60)
				local min = math.floor((t / 60) % 60)
				local hour = math.floor((t / 3600) % 24)

				if string.len(sec) < 2 then
					sec = "0" .. tostring(sec)
				end

				if string.len(min) < 2 then
					min = "0" .. tostring(min)
				end

				if string.len(hour) < 2 then
					hour = "0" .. tostring(hour)
				end

				Gui["5"]["Text"] = hour .. ":" .. min .. ":" .. sec
			end
		end)
	end

	-- Toggle Handler
	function Gui:Toggled(bool)
		if not Library.Loaded then
			return
		end

		Gui.TweeningToggle = true
		if bool == nil then
			if Gui["2"].Visible then
				Library:Tween(Gui["2"], {
					Length = 1,
					Goal = { Size = UDim2.new(0, 498, 0, 0) },
				})

				task.wait(1)
				Gui["2"].Visible = false
			else
				Gui["2"].Visible = true
				Library:Tween(Gui["2"], {
					Length = 1,
					Goal = { Size = UDim2.new(0, 498, 0, 496) },
				})

				task.wait(1)
			end
		elseif bool then
			Gui["2"].Visible = true
			Library:Tween(Gui["2"], {
				Length = 1,
				Goal = { Size = UDim2.new(0, 498, 0, 496) },
			})

			task.wait(1)
		elseif not bool then
			Library:Tween(Gui["2"], {
				Length = 1,
				Goal = { Size = UDim2.new(0, 498, 0, 0) },
			})

			task.wait(1)
			Gui["2"].Visible = false
		end

		Gui.TweeningToggle = false
	end

	function Gui:TaskBarOnly(bool)
		if bool then
			Library:Tween(Gui["18"], {
				Length = 0.3,
				Goal = { Position = UDim2.new(0, 0, 0, 452) },
			})

			Library:Tween(Gui["18"], {
				Length = 0.3,
				Goal = { Size = UDim2.new(0, 498, 0, 0) },
			})

			Gui.Hidden = true
		else
			Library:Tween(Gui["18"], {
				Length = 0.3,
				Goal = { Position = UDim2.new(0, 0, 0, 0) },
			})

			Library:Tween(Gui["18"], {
				Length = 0.3,
				Goal = { Size = UDim2.new(0, 498, 0, 452) },
			})

			Gui.Hidden = false
		end
	end

	do
		table.insert(
			ConnectionBin,
			UserInputService.InputBegan:Connect(function(input)
				if input.KeyCode == Gui.ToggleKey then
					if not Gui.TweeningToggle then
						Gui:Toggled()
					end
				end
			end)
		)
	end

	function Gui:ChangeTogglekey(key)
		Gui.ToggleKey = key
	end

	return Gui
end

function Library:Notify(options)
	options = Library:PlaceDefaults({
		Name = "Ring Ring",
		Text = "Notification!!",
		Icon = "rbxassetid://11401835376",
		Sound = "rbxassetid://6647898215",
		Duration = 5,
		Callback = function()
			return
		end,
	}, options or {})

	local Notification = {}

	do
		-- StarterGui.Vision Lib v2.NotifFrame.Notif
		Notification["84"] = Instance.new("Frame", LibFrame["81"])
		Notification["84"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["84"]["Size"] = UDim2.new(0, 257, 0, 0)
		Notification["84"]["ClipsDescendants"] = true
		Notification["84"]["Position"] = UDim2.new(0, -41, 0, 0)
		Notification["84"]["Name"] = [[Notif]]
		Notification["84"]["ClipsDescendants"] = true
		Notification["84"]["BorderSizePixel"] = 0

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.UICorner
		Notification["85"] = Instance.new("UICorner", Notification["84"])
		Notification["85"]["CornerRadius"] = UDim.new(0, 4)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.ImageLabel
		Notification["86"] = Instance.new("ImageLabel", Notification["84"])
		Notification["86"]["BorderSizePixel"] = 0
		Notification["86"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["86"]["Image"] = options.Icon
		Notification["86"]["Size"] = UDim2.new(0, 18, 0, 16)
		Notification["86"]["BackgroundTransparency"] = 1
		Notification["86"]["Position"] = UDim2.new(0, 10, 0, 5)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.ImageLabel.ThemeColorGradient
		Notification["87"] = Instance.new("UIGradient", Notification["86"])
		Notification["87"]["Name"] = [[ThemeColorGradient]]
		Notification["87"]["Rotation"] = 90
		Notification["87"]["Color"] = ThemeColor.Theme

		ThemeInstances["Theme"][#ThemeInstances["Theme"] + 1] = Notification["87"]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.NotifName
		Notification["88"] = Instance.new("TextLabel", Notification["84"])
		Notification["88"]["BorderSizePixel"] = 0
		Notification["88"]["TextXAlignment"] = Enum.TextXAlignment.Left
		Notification["88"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["88"]["TextSize"] = 12
		Notification["88"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Notification["88"]
		Notification["88"]["Size"] = UDim2.new(0, 206, 0, 21)
		Notification["88"]["Text"] = options.Name
		Notification["88"]["Name"] = [[NotifName]]
		Notification["88"]["Font"] = Enum.Font.GothamMedium
		Notification["88"]["BackgroundTransparency"] = 1
		Notification["88"]["Position"] = UDim2.new(0, 34, 0, 3)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.NotifName.ThemeColorGradient
		Notification["89"] = Instance.new("UIGradient", Notification["88"])
		Notification["89"]["Name"] = [[ThemeColorGradient]]
		Notification["89"]["Rotation"] = 90
		Notification["89"]["Color"] = ThemeColor.Theme

		ThemeInstances["Theme"][#ThemeInstances["Theme"] + 1] = Notification["89"]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.NotifText
		Notification["8a"] = Instance.new("TextLabel", Notification["84"])
		Notification["8a"]["TextWrapped"] = true
		Notification["8a"]["BorderSizePixel"] = 0
		Notification["8a"]["TextXAlignment"] = Enum.TextXAlignment.Left
		Notification["8a"]["TextYAlignment"] = Enum.TextYAlignment.Top
		Notification["8a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["8a"]["TextSize"] = 10
		Notification["8a"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Notification["8a"]
		Notification["8a"]["Size"] = UDim2.new(0, 242, 0, 28)
		Notification["8a"]["Text"] = options.Text
		Notification["8a"]["Name"] = [[NotifText]]
		Notification["8a"]["Font"] = Enum.Font.GothamMedium
		Notification["8a"]["BackgroundTransparency"] = 1
		Notification["8a"]["Position"] = UDim2.new(0, 10, 0, 23)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.TimeBarBack
		Notification["8b"] = Instance.new("Frame", Notification["84"])
		Notification["8b"]["BorderSizePixel"] = 0
		Notification["8b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["8b"]["Size"] = UDim2.new(0, 239, 0, 5)
		Notification["8b"]["Position"] = UDim2.new(0.03501945361495018, 0, 0.7903226017951965, 0)
		Notification["8b"]["Name"] = [[TimeBarBack]]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.TimeBarBack.Frame
		Notification["8c"] = Instance.new("Frame", Notification["8b"])
		Notification["8c"]["BorderSizePixel"] = 0
		Notification["8c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["8c"]["Size"] = UDim2.new(0.5, 0, 1, 0)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.TimeBarBack.Frame.ThemeColorGradient
		Notification["8d"] = Instance.new("UIGradient", Notification["8c"])
		Notification["8d"]["Name"] = [[ThemeColorGradient]]
		Notification["8d"]["Rotation"] = 90
		Notification["8d"]["Color"] = ThemeColor.Theme

		ThemeInstances["Theme"][#ThemeInstances["Theme"] + 1] = Notification["8d"]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.TimeBarBack.UIGradient
		Notification["8e"] = Instance.new("UIGradient", Notification["8b"])
		Notification["8e"]["Rotation"] = 90
		Notification["8e"]["Color"] = ThemeColor.Tertiary

		ThemeInstances["Tertiary"][#ThemeInstances["Tertiary"] + 1] = Notification["8e"]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.UIGradient
		Notification["8f"] = Instance.new("UIGradient", Notification["84"])
		Notification["8f"]["Rotation"] = 90
		Notification["8f"]["Color"] = ThemeColor.Main

		ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Notification["8f"]
	end

	do
		task.spawn(function()
			repeat
				task.wait()
			until Library.Loaded

			local Completed = false

			Library:PlaySound(options.Sound)

			Library:Tween(Notification["84"], {
				Length = 0.5,
				Goal = { Size = UDim2.new(0, 257, 0, 62) },
			})

			Library:Tween(Notification["8c"], {
				Length = options.Duration,
				Style = Enum.EasingStyle.Linear,
				Goal = { Size = UDim2.new(1, 0, 1, 0) },
			}, function()
				Completed = true
			end)

			repeat
				task.wait()
			until Completed

			local Completed = false

			Library:Tween(Notification["84"], {
				Length = 0.5,
				Goal = { Size = UDim2.new(0, 257, 0, 0) },
			}, function()
				Completed = true
			end)

			repeat
				task.wait()
			until Completed

			options.Callback()
			Notification["84"]:Destroy()
		end)
	end
end

function Library:ForceNotify(options)
	options = Library:PlaceDefaults({
		Name = "Ring Ring",
		Text = "Notification!!",
		Icon = "rbxassetid://11401835376",
		Sound = "rbxassetid://6647898215",
		Duration = 5,
		Callback = function()
			return
		end,
	}, options or {})

	local Notification = {}

	do
		-- StarterGui.Vision Lib v2.NotifFrame.Notif
		Notification["84"] = Instance.new("Frame", LibFrame["81"])
		Notification["84"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["84"]["Size"] = UDim2.new(0, 257, 0, 0)
		Notification["84"]["ClipsDescendants"] = true
		Notification["84"]["Position"] = UDim2.new(0, -41, 0, 0)
		Notification["84"]["Name"] = [[Notif]]
		Notification["84"]["ClipsDescendants"] = true
		Notification["84"]["BorderSizePixel"] = 0

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.UICorner
		Notification["85"] = Instance.new("UICorner", Notification["84"])
		Notification["85"]["CornerRadius"] = UDim.new(0, 4)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.ImageLabel
		Notification["86"] = Instance.new("ImageLabel", Notification["84"])
		Notification["86"]["BorderSizePixel"] = 0
		Notification["86"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["86"]["Image"] = options.Icon
		Notification["86"]["Size"] = UDim2.new(0, 18, 0, 16)
		Notification["86"]["BackgroundTransparency"] = 1
		Notification["86"]["Position"] = UDim2.new(0, 10, 0, 5)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.ImageLabel.ThemeColorGradient
		Notification["87"] = Instance.new("UIGradient", Notification["86"])
		Notification["87"]["Name"] = [[ThemeColorGradient]]
		Notification["87"]["Rotation"] = 90
		Notification["87"]["Color"] = ThemeColor.Theme

		ThemeInstances["Theme"][#ThemeInstances["Theme"] + 1] = Notification["87"]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.NotifName
		Notification["88"] = Instance.new("TextLabel", Notification["84"])
		Notification["88"]["BorderSizePixel"] = 0
		Notification["88"]["TextXAlignment"] = Enum.TextXAlignment.Left
		Notification["88"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["88"]["TextSize"] = 12
		Notification["88"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Notification["88"]
		Notification["88"]["Size"] = UDim2.new(0, 206, 0, 21)
		Notification["88"]["Text"] = options.Name
		Notification["88"]["Name"] = [[NotifName]]
		Notification["88"]["Font"] = Enum.Font.GothamMedium
		Notification["88"]["BackgroundTransparency"] = 1
		Notification["88"]["Position"] = UDim2.new(0, 34, 0, 3)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.NotifName.ThemeColorGradient
		Notification["89"] = Instance.new("UIGradient", Notification["88"])
		Notification["89"]["Name"] = [[ThemeColorGradient]]
		Notification["89"]["Rotation"] = 90
		Notification["89"]["Color"] = ThemeColor.Theme

		ThemeInstances["Theme"][#ThemeInstances["Theme"] + 1] = Notification["89"]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.NotifText
		Notification["8a"] = Instance.new("TextLabel", Notification["84"])
		Notification["8a"]["TextWrapped"] = true
		Notification["8a"]["BorderSizePixel"] = 0
		Notification["8a"]["TextXAlignment"] = Enum.TextXAlignment.Left
		Notification["8a"]["TextYAlignment"] = Enum.TextYAlignment.Top
		Notification["8a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["8a"]["TextSize"] = 10
		Notification["8a"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Notification["8a"]
		Notification["8a"]["Size"] = UDim2.new(0, 242, 0, 28)
		Notification["8a"]["Text"] = options.Text
		Notification["8a"]["Name"] = [[NotifText]]
		Notification["8a"]["Font"] = Enum.Font.GothamMedium
		Notification["8a"]["BackgroundTransparency"] = 1
		Notification["8a"]["Position"] = UDim2.new(0, 10, 0, 23)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.TimeBarBack
		Notification["8b"] = Instance.new("Frame", Notification["84"])
		Notification["8b"]["BorderSizePixel"] = 0
		Notification["8b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["8b"]["Size"] = UDim2.new(0, 239, 0, 5)
		Notification["8b"]["Position"] = UDim2.new(0.03501945361495018, 0, 0.7903226017951965, 0)
		Notification["8b"]["Name"] = [[TimeBarBack]]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.TimeBarBack.Frame
		Notification["8c"] = Instance.new("Frame", Notification["8b"])
		Notification["8c"]["BorderSizePixel"] = 0
		Notification["8c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Notification["8c"]["Size"] = UDim2.new(0.5, 0, 1, 0)

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.TimeBarBack.Frame.ThemeColorGradient
		Notification["8d"] = Instance.new("UIGradient", Notification["8c"])
		Notification["8d"]["Name"] = [[ThemeColorGradient]]
		Notification["8d"]["Rotation"] = 90
		Notification["8d"]["Color"] = ThemeColor.Theme

		ThemeInstances["Theme"][#ThemeInstances["Theme"] + 1] = Notification["8d"]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.TimeBarBack.UIGradient
		Notification["8e"] = Instance.new("UIGradient", Notification["8b"])
		Notification["8e"]["Rotation"] = 90
		Notification["8e"]["Color"] = ThemeColor.Tertiary

		ThemeInstances["Tertiary"][#ThemeInstances["Tertiary"] + 1] = Notification["8e"]

		-- StarterGui.Vision Lib v2.NotifFrame.Notif.UIGradient
		Notification["8f"] = Instance.new("UIGradient", Notification["84"])
		Notification["8f"]["Rotation"] = 90
		Notification["8f"]["Color"] = ThemeColor.Main

		ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Notification["8f"]
	end

	do
		task.spawn(function()
			local Completed = false

			Library:Tween(Notification["84"], {
				Length = 0.5,
				Goal = { Size = UDim2.new(0, 257, 0, 62) },
			})

			Library:Tween(Notification["8c"], {
				Length = options.Duration,
				Style = Enum.EasingStyle.Linear,
				Goal = { Size = UDim2.new(1, 0, 1, 0) },
			}, function()
				Completed = true
			end)

			Library:PlaySound(options.Sound)

			repeat
				task.wait()
			until Completed

			local Completed = false

			Library:Tween(Notification["84"], {
				Length = 0.5,
				Goal = { Size = UDim2.new(0, 257, 0, 0) },
			}, function()
				Completed = true
			end)

			repeat
				task.wait()
			until Completed

			options.Callback()
			Notification["84"]:Destroy()
		end)
	end
end

function Library:Popup(options)
	local Prompt = {}
	options = Library:PlaceDefaults({
		Name = "Popup",
		Text = "Do you want to accept?",
		Options = { "Yes", "No" },
		Callback = function()
			return
		end,
	}, options or {})

	do
		-- StarterGui.Vision Lib v2.Prompt
		Prompt["1e9"] = Instance.new("Frame", LibFrame["2"])
		Prompt["1e9"]["ZIndex"] = 10
		Prompt["1e9"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
		Prompt["1e9"]["BackgroundTransparency"] = 1
		Prompt["1e9"]["Size"] = UDim2.new(1, 0, 1, 0)
		Prompt["1e9"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
		Prompt["1e9"]["Visible"] = true
		Prompt["1e9"]["Name"] = [[Prompt]]
		Prompt["1e9"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Prompt["1e9"]["ClipsDescendants"] = true

		-- StarterGui.Vision Lib v2.Prompt.Prompt
		Prompt["1ea"] = Instance.new("Frame", Prompt["1e9"])
		Prompt["1ea"]["ZIndex"] = 11
		Prompt["1ea"]["BorderSizePixel"] = 0
		Prompt["1ea"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Prompt["1ea"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
		Prompt["1ea"]["Size"] = UDim2.new(0, 0, 0, 0)
		Prompt["1ea"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
		Prompt["1ea"]["Name"] = [[Prompt]]
		Prompt["1ea"]["ClipsDescendants"] = true

		-- StarterGui.Vision Lib v2.Prompt.Prompt.UICorner
		Prompt["1eb"] = Instance.new("UICorner", Prompt["1ea"])
		Prompt["1eb"]["CornerRadius"] = UDim.new(0, 4)

		-- StarterGui.Vision Lib v2.Prompt.Prompt.UIGradient
		Prompt["1ec"] = Instance.new("UIGradient", Prompt["1ea"])
		Prompt["1ec"]["Rotation"] = 90
		Prompt["1ec"]["Color"] = ThemeColor.Main

		ThemeInstances["Main"][#ThemeInstances["Main"] + 1] = Prompt["1ec"]

		-- StarterGui.Vision Lib v2.Prompt.Prompt.Controls
		Prompt["1ed"] = Instance.new("Frame", Prompt["1ea"])
		Prompt["1ed"]["ZIndex"] = 15
		Prompt["1ed"]["BorderSizePixel"] = 0
		Prompt["1ed"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Prompt["1ed"]["BackgroundTransparency"] = 1
		Prompt["1ed"]["Size"] = UDim2.new(0, 400, 0, 30)
		Prompt["1ed"]["Position"] = UDim2.new(0, -1, 0, 109)
		Prompt["1ed"]["Name"] = [[Controls]]

		-- StarterGui.Vision Lib v2.Prompt.Prompt.Controls.UIListLayout
		Prompt["1ee"] = Instance.new("UIListLayout", Prompt["1ed"])
		Prompt["1ee"]["FillDirection"] = Enum.FillDirection.Horizontal
		Prompt["1ee"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center
		Prompt["1ee"]["Padding"] = UDim.new(0, 20)
		Prompt["1ee"]["SortOrder"] = Enum.SortOrder.LayoutOrder

		-- StarterGui.Vision Lib v2.Prompt.Prompt.Frame
		Prompt["1f7"] = Instance.new("Frame", Prompt["1ea"])
		Prompt["1f7"]["ZIndex"] = 12
		Prompt["1f7"]["BorderSizePixel"] = 0
		Prompt["1f7"]["BackgroundColor3"] = ThemeColor.Textbox
		Prompt["1f7"]["Size"] = UDim2.new(0, 371, 0, 1)
		Prompt["1f7"]["Position"] = UDim2.new(0, 14, 0, 35)

		ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = Prompt["1f7"]

		-- StarterGui.Vision Lib v2.Prompt.Prompt.Frame.TerrainDetail
		Prompt["1f8"] = Instance.new("TerrainDetail", Prompt["1f7"])

		-- StarterGui.Vision Lib v2.Prompt.Prompt.Description
		Prompt["1f9"] = Instance.new("TextLabel", Prompt["1ea"])
		Prompt["1f9"]["TextWrapped"] = true
		Prompt["1f9"]["ZIndex"] = 11
		Prompt["1f9"]["TextYAlignment"] = Enum.TextYAlignment.Top
		Prompt["1f9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Prompt["1f9"]["FontFace"] =
			Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Prompt["1f9"]["TextSize"] = 13
		Prompt["1f9"]["TextColor3"] = ThemeColor.PlaceholderText

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Prompt["1f9"]

		Prompt["1f9"]["Size"] = UDim2.new(0, 360, 0, 95)
		Prompt["1f9"]["Text"] = options.Text
		Prompt["1f9"]["Name"] = [[Description]]
		Prompt["1f9"]["BackgroundTransparency"] = 1
		Prompt["1f9"]["Position"] = UDim2.new(0, 20, 0, 44)

		-- StarterGui.Vision Lib v2.Prompt.Prompt.Title
		Prompt["1fa"] = Instance.new("TextLabel", Prompt["1ea"])
		Prompt["1fa"]["TextWrapped"] = true
		Prompt["1fa"]["ZIndex"] = 11
		Prompt["1fa"]["TextYAlignment"] = Enum.TextYAlignment.Top
		Prompt["1fa"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		Prompt["1fa"]["FontFace"] =
			Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		Prompt["1fa"]["TextSize"] = 16
		Prompt["1fa"]["TextColor3"] = ThemeColor.Text

		ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = Prompt["1fa"]

		Prompt["1fa"]["Size"] = UDim2.new(0, 400, 0, 20)
		Prompt["1fa"]["Text"] = options.Name
		Prompt["1fa"]["Name"] = [[Title]]
		Prompt["1fa"]["BackgroundTransparency"] = 1
		Prompt["1fa"]["Position"] = UDim2.new(0, 0, 0, 12)
	end

	do
		Library:Tween(Prompt["1e9"], {
			Goal = {
				BackgroundTransparency = 0.65,
			},
			Style = Enum.EasingStyle.Quart,
			Direction = Enum.EasingDirection.Out,
			Length = 0.5,
		})

		Library:Tween(Prompt["1ea"], {
			Goal = {
				Size = UDim2.new(0, 400, 0, 146),
			},
			Style = Enum.EasingStyle.Quart,
			Direction = Enum.EasingDirection.Out,
			Length = 0.5,
		})

		Library:PlaySound(LibSettings.PopupSound)
	end

	do
		for i, text in next, options.Options do
			do
				local PromptOption = {}
				-- StarterGui.Vision Lib v2.Prompt.Prompt.Controls.B1
				PromptOption["1ef"] = Instance.new("TextButton", Prompt["1ed"])
				PromptOption["1ef"]["ZIndex"] = 11
				PromptOption["1ef"]["BorderSizePixel"] = 0
				PromptOption["1ef"]["BackgroundColor3"] = ThemeColor.Textbox

				ThemeInstances["Textbox"][#ThemeInstances["Textbox"] + 1] = PromptOption["1ef"]

				PromptOption["1ef"]["TextSize"] = 14
				PromptOption["1ef"]["FontFace"] = Font.new(
					[[rbxasset://fonts/families/GothamSSm.json]],
					Enum.FontWeight.Regular,
					Enum.FontStyle.Normal
				)
				PromptOption["1ef"]["TextColor3"] = ThemeColor.Text

				ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = PromptOption["1ef"]
				PromptOption["1ef"]["Size"] = UDim2.new(0, 120, 0, 30)
				PromptOption["1ef"]["LayoutOrder"] = 1
				PromptOption["1ef"]["Name"] = [[B1]]
				PromptOption["1ef"]["Text"] = ""
				PromptOption["1ef"]["Position"] = UDim2.new(0, 68, 0, 567)

				-- StarterGui.Vision Lib v2.PromptOption.PromptOption.Controls.B1.UICorner
				PromptOption["1f0"] = Instance.new("UICorner", PromptOption["1ef"])
				PromptOption["1f0"]["CornerRadius"] = UDim.new(0, 4)

				-- StarterGui.Vision Lib v2.PromptOption.PromptOption.Controls.B1.NameLabel
				PromptOption["1f2"] = Instance.new("TextLabel", PromptOption["1ef"])
				PromptOption["1f2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
				PromptOption["1f2"]["FontFace"] = Font.new(
					[[rbxasset://fonts/families/GothamSSm.json]],
					Enum.FontWeight.Regular,
					Enum.FontStyle.Normal
				)
				PromptOption["1f2"]["TextSize"] = 11
				PromptOption["1f2"]["TextColor3"] = ThemeColor.Text

				ThemeInstances["Text"][#ThemeInstances["Text"] + 1] = PromptOption["1f2"]
				PromptOption["1f2"]["Size"] = UDim2.new(0, 120, 0, 30)
				PromptOption["1f2"]["Text"] = tostring(text)
				PromptOption["1f2"]["Name"] = [[NameLabel]]
				PromptOption["1f2"]["BackgroundTransparency"] = 1

				table.insert(
					ConnectionBin,
					PromptOption["1ef"].MouseButton1Click:Connect(function()
						Library:PlaySound(LibSettings.ClickSound)

						Library:Tween(Prompt["1e9"], {
							Goal = {
								BackgroundTransparency = 1,
							},
							Style = Enum.EasingStyle.Quart,
							Direction = Enum.EasingDirection.Out,
							Length = 0.5,
						})

						Library:Tween(Prompt["1ea"], {
							Goal = {
								Size = UDim2.new(0, 0, 0, 0),
							},
							Style = Enum.EasingStyle.Quart,
							Direction = Enum.EasingDirection.Out,
							Length = 0.5,
						})

						do
							task.spawn(function()
								options.Callback(text)
							end)
						end

						task.spawn(function()
							task.wait(1.5)

							Prompt["1e9"]:Destroy()
						end)
					end)
				)

				table.insert(
					ConnectionBin,
					PromptOption["1ef"].MouseEnter:Connect(function()
						Library:PlaySound(LibSettings.HoverSound)
					end)
				)
			end
		end
	end
end

function Library:Destroy()
	local DestroyedConnection = 0
	local DestroyedControlConection = 0
	local TotalControlConnections = 0
	local TotalConnections = #ConnectionBin
	local TotalControls = #ControlsConnectionBin

	for i, v in next, ConnectionBin do
		pcall(function()
			v:Disconnect()

			DestroyedConnection += 1
		end)
	end

	for i, controls in next, ControlsConnectionBin do
		for i, event in next, controls do
			TotalControlConnections = TotalControlConnections + 1

			pcall(function()
				event:Disconnect()

				DestroyedControlConection += 1
			end)
		end
	end

	print(
		"Disconnected "
			.. tostring(DestroyedConnection)
			.. " connections out of "
			.. tostring(TotalConnections)
			.. " connections."
	)

	print(
		"Disconnected "
			.. tostring(DestroyedControlConection)
			.. " connections out of "
			.. tostring(TotalControlConnections)
			.. " connections in "
			.. TotalControls
			.. " controls."
	)

	LibFrame["1"]:Destroy()
	LibFrame["2"]:Destroy()
end

return Library