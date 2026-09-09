--[=[
    Vice UI Library
    Preserved from the supplied library source and separated from its demo.
    Public entry point:
        local Vice = loadstring(game:HttpGet(URL))()
        local window = Vice:Create("Vice Hub", UDim2.new(0, 700, 0, 600), Enum.KeyCode.RightShift)

    API: Create, Tab, SubTab, Label, Toggle, Dropdown, Slider,
    Colorpicker, Bind, Button, and Notify.
]=]

local Global = getgenv and getgenv() or _G;
-- // söylesene bana, tüm bunlar ne zaman sona erecek?
local LibraryFunctions = {Notifications = {}, Connections = {}, Flags = {}}

if not game:IsLoaded() then game.Loaded:wait() end

-- // cleanups
if game.CoreGui:FindFirstChild("Vice") then game.CoreGui:FindFirstChild("Vice"):Destroy() end
if game.CoreGui:FindFirstChild("NotifsGui") then game.CoreGui:FindFirstChild("NotifsGui"):Destroy() end
if game.CoreGui:FindFirstChild("WatermarkUI") then game.CoreGui:FindFirstChild("WatermarkUI"):Destroy() end

local UserInputService = game:GetService('UserInputService')
local InputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')
local RenderStepped = game:GetService('RunService').RenderStepped
local LocalPlayer = game:GetService('Players').LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

function LibraryFunctions:Create(Class, Properties)
	local Object = Instance.new(Class)
	for Property, Value in next, Properties do
		Object[Property] = Value
	end
	return Object
end

function LibraryFunctions:GetMouseLocation(Inset)
	return InputService:GetMouseLocation()
end


function LibraryFunctions:Connect(Signal, Function)
	local Connection = Signal:Connect(Function)
	table.insert(self.Connections, Connection)
	return Connection
end

function LibraryFunctions:Hovering(a)
	local M = LibraryFunctions:GetMouseLocation()
	local P = a.AbsolutePosition
	local S = a.AbsoluteSize
	return (M.X >= P.X and M.X <= P.X + S.X) and (M.Y >= P.Y and M.Y <= P.Y + S.Y)
end

function LibraryFunctions:Round(Number, Increment)
	local Bracket = 1 / Increment
	return math.round(Number * Bracket) / Bracket
end

function LibraryFunctions:Tween(Object, Properties, Time, ...)
	TweenService:Create(Object, TweenInfo.new(Time, ...), Properties):Play()
end

local function GetMouseLocation(Inset)
	local Location = Userreturn InputService:GetMouseLocation()
	if not Inset then
		Location -= Vector2.new(0, 36)
	end
	return Location
end

local function CreateWatermark(title)
	local MainFrame = Instance.new("ScreenGui")
	MainFrame.Name = "WatermarkUI"
	MainFrame.Parent = game:GetService("CoreGui")
	title = title or "VICE HUB"
	local waterwarkFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local vh_title = Instance.new("TextLabel")
	local glow = Instance.new("ImageLabel")
	local vhlogo = Instance.new("ImageLabel")
	local clock = Instance.new("TextLabel")
	local line1 = Instance.new("Frame")
	local fps = Instance.new("TextLabel")
	local ping = Instance.new("TextLabel")
	local line2 = Instance.new("Frame")
	local PlayerImage = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local username = Instance.new("TextLabel")

	waterwarkFrame.Name = "waterwarkFrame"
	waterwarkFrame.Parent = MainFrame
	waterwarkFrame.Active = true
	waterwarkFrame.BackgroundColor3 = Color3.fromRGB(13, 10, 28)
	waterwarkFrame.BackgroundTransparency = 0.350
	waterwarkFrame.BorderSizePixel = 0
	waterwarkFrame.Position = UDim2.new(0, 1393, 0, -5)
	waterwarkFrame.Size = UDim2.new(0, 455, 0, 33)
	waterwarkFrame.Active = true
	waterwarkFrame.Draggable = true

	UICorner.CornerRadius = UDim.new(0, 9)
	UICorner.Parent = waterwarkFrame

	vh_title.Name = "vh_title"
	vh_title.Parent = waterwarkFrame
	vh_title.BackgroundTransparency = 1.000
	vh_title.Position = UDim2.new(0.091, 0, 0.107, 0)
	vh_title.Size = UDim2.new(0, 66, 0, 25)
	vh_title.Font = Enum.Font.GothamBold
	vh_title.Text = title or "VICE HUB"
	vh_title.TextColor3 = Color3.fromRGB(188, 188, 188)
	vh_title.TextSize = 14.000
	vh_title.TextXAlignment = Enum.TextXAlignment.Left

	glow.Name = "glow"
	glow.Parent = waterwarkFrame
	glow.BackgroundTransparency = 1.000
	glow.Position = UDim2.new(0, -14, 0, -16)
	glow.Size = UDim2.new(0.995, 30, 0.939, 30)
	glow.ZIndex = 0
	glow.Image = "rbxassetid://5028857084"
	glow.ImageColor3 = Color3.fromRGB(72, 0, 255)
	glow.ImageTransparency = 0.400
	glow.ScaleType = Enum.ScaleType.Slice
	glow.SliceCenter = Rect.new(24, 24, 276, 276)

	vhlogo.Name = "vhlogo"
	vhlogo.Parent = waterwarkFrame
	vhlogo.AnchorPoint = Vector2.new(0.5, 0)
	vhlogo.BackgroundTransparency = 1.000
	vhlogo.Position = UDim2.new(0.046, 0, 0.076, 3)
	vhlogo.Size = UDim2.new(0, 20, 0, 19)
	vhlogo.Image = "rbxassetid://10272150497"

	clock.Name = "clock"
	clock.Parent = waterwarkFrame
	clock.BackgroundTransparency = 1.000
	clock.Position = UDim2.new(0.277, 0, 0.107, 0)
	clock.Size = UDim2.new(0, 42, 0, 25)
	clock.Font = Enum.Font.GothamBold
	clock.TextColor3 = Color3.fromRGB(188, 188, 188)
	clock.TextSize = 14.000
	clock.TextXAlignment = Enum.TextXAlignment.Left

	line1.Name = "line1"
	line1.Parent = waterwarkFrame
	line1.AnchorPoint = Vector2.new(0, 0.5)
	line1.BackgroundColor3 = Color3.fromRGB(51, 45, 111)
	line1.BorderSizePixel = 0
	line1.Position = UDim2.new(0.252, 0, 0.499, 0)
	line1.Size = UDim2.new(0, 3, 0.7, 0)

	fps.Name = "fps"
	fps.Parent = waterwarkFrame
	fps.BackgroundTransparency = 1.000
	fps.Position = UDim2.new(0.395, 0, 0.107, 0)
	fps.Size = UDim2.new(0, 42, 0, 25)
	fps.Font = Enum.Font.GothamBold
	fps.TextColor3 = Color3.fromRGB(188, 188, 188)
	fps.TextSize = 14.000
	fps.TextXAlignment = Enum.TextXAlignment.Left

	ping.Name = "ping"
	ping.Parent = waterwarkFrame
	ping.BackgroundTransparency = 1.000
	ping.Position = UDim2.new(0.550, 0, 0.107, 0)
	ping.Size = UDim2.new(0, 42, 0, 25)
	ping.Font = Enum.Font.GothamBold
	ping.TextColor3 = Color3.fromRGB(188, 188, 188)
	ping.TextSize = 14.000
	ping.TextXAlignment = Enum.TextXAlignment.Left

	line2.Name = "line2"
	line2.Parent = waterwarkFrame
	line2.AnchorPoint = Vector2.new(0, 0.5)
	line2.BackgroundColor3 = Color3.fromRGB(51, 45, 111)
	line2.BorderSizePixel = 0
	line2.Position = UDim2.new(0.694, 0, 0.499, 0)
	line2.Size = UDim2.new(0, 3, 0.7, 0)

	PlayerImage.Name = "PlayerImage"
	PlayerImage.Parent = waterwarkFrame
	PlayerImage.BackgroundTransparency = 1.000
	PlayerImage.Position = UDim2.new(0.72, 0, 0.047, 0)
	PlayerImage.Size = UDim2.new(0, 27, 0, 28)
	PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id="..game.Players.LocalPlayer.UserId.."&w=100&h=100"

	UICorner_2.CornerRadius = UDim.new(0, 100)
	UICorner_2.Parent = PlayerImage

	username.Name = "username"
	username.Parent = waterwarkFrame
	username.BackgroundTransparency = 1.000
	username.Position = UDim2.new(0.80, 0, 0.107, 0)
	username.Size = UDim2.new(0, 95, 0, 25)
	username.Font = Enum.Font.GothamBold
	username.Text = game.Players.LocalPlayer.Name
	username.TextColor3 = Color3.fromRGB(188, 188, 188)
	username.TextSize = 14.000
	username.TextXAlignment = Enum.TextXAlignment.Left

	local ProfileOutline = Instance.new("UIStroke")
	ProfileOutline.Enabled = true
	ProfileOutline.Parent = PlayerImage
	ProfileOutline.Color = Color3.fromRGB(47, 4, 100)
	ProfileOutline.LineJoinMode = Enum.LineJoinMode.Round
	ProfileOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	ProfileOutline.Thickness = 1.6
	ProfileOutline.Transparency = 0.350

	task.spawn(function()
		local Stats = game:GetService("Stats")
		Stats:WaitForChild("Network"):WaitForChild("ServerStatsItem"):WaitForChild("Data Ping")

		while task.wait(0.1) do
			local result = os.date("%H:%M", os.time())
			local theping = string.split(string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1], ".")
			local thefps = string.split(Stats.Workspace.Heartbeat:GetValueString(), ".")

			fps.Text = "FPS: "..thefps[1]
			clock.Text = result
			ping.Text = "PING: "..theping[1]
		end
	end)
end


local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,StartPosition.Y.Scale,StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)
	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local PID = LocalPlayer.UserId

--- LIB START ---

local lib = {
	Animations = {
		AnimSpeed = 0.2,
		ElementsAS = 0.2
	}
}

---HOLDERS---

--local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end)
local Vice = Instance.new("ScreenGui")
--ProtectGui(Vice);
Vice.Name = "Vice"
Vice.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui
Vice.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotifsGui = Instance.new("ScreenGui")
NotifsGui.Name = "NotifsGui"
NotifsGui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui
NotifsGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotifsHolder = Instance.new("Frame")
NotifsHolder.Name = "NotifsHolder"
NotifsHolder.Parent = NotifsGui
NotifsHolder.AnchorPoint = Vector2.new(1, 0.5)
NotifsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotifsHolder.BackgroundTransparency = 1.000
NotifsHolder.Position = UDim2.new(1, -20, 0.5, 0)
NotifsHolder.Size = UDim2.new(0, 300, 1, -40)

local NotifsHolderListing = Instance.new("UIListLayout")
NotifsHolderListing.Name = "NotifsHolderListing"
NotifsHolderListing.Parent = NotifsHolder
NotifsHolderListing.SortOrder = Enum.SortOrder.LayoutOrder
NotifsHolderListing.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifsHolderListing.Padding = UDim.new(0, 5)

---HOLDERS END---

function lib:Create(ver, size, hidekey)
	local hidekey = hidekey or Enum.KeyCode.RightShift
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Vice
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(23, 20, 41)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 900, 0, 825)
	if size == '' or nil then
		MainFrame.Size = UDim2.new(0, 700, 0, 625)
	else
		MainFrame.Size = size
	end
	local PromptContainer = Instance.new('TextButton')
	PromptContainer.Size = UDim2.new(1,0,1,0)
	PromptContainer.BackgroundColor3 = Color3.fromRGB(13, 10, 28)
	PromptContainer.BackgroundTransparency = 0.25
	PromptContainer.AutoButtonColor = false
	PromptContainer.BorderSizePixel = 0
	PromptContainer.Visible = false
	PromptContainer.Parent = MainFrame
	PromptContainer.ZIndex = 20

	local MainGlow = Instance.new("ImageLabel")
	MainGlow.Name = "MainGlow"
	MainGlow.Parent = MainFrame
	MainGlow.BackgroundTransparency = 1
	MainGlow.Position = UDim2.new(0, -15, 0, -15)
	MainGlow.Size = UDim2.new(1, 30, 1, 30)
	MainGlow.ZIndex = 0
	MainGlow.Image = "rbxassetid://5028857084"
	MainGlow.ImageColor3 = Color3.fromRGB(107, 89, 222)
	MainGlow.ScaleType = Enum.ScaleType.Slice
	MainGlow.SliceCenter = Rect.new(24, 24, 276, 276)

	local PromptBackground = Instance.new('Frame')
	PromptBackground.Size = UDim2.new(0,300,0,200)
	PromptBackground.AnchorPoint = Vector2.new(0.5, 0.5)
	PromptBackground.Position = UDim2.new(0.5,40,0.5,0)
	PromptBackground.BorderSizePixel = 1
	PromptBackground.BackgroundColor3 = Color3.fromRGB(23, 20, 46)
	PromptBackground.Parent = PromptContainer
	PromptBackground.ZIndex = 21

	local PromptCorner = Instance.new("UICorner")
	PromptCorner.CornerRadius = UDim.new(0, 4)
	PromptCorner.Name = "PromptCorner"
	PromptCorner.Parent = PromptBackground

	local PromptStroke = Instance.new("UIStroke")
	PromptStroke.Enabled = true
	PromptStroke.Parent = PromptBackground
	PromptStroke.Color = Color3.fromRGB(31, 26, 61)
	PromptStroke.LineJoinMode = Enum.LineJoinMode.Round
	PromptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	PromptStroke.Thickness = 1
	PromptStroke.Transparency = 1

	local PromptTitle = Instance.new("TextLabel")
	PromptTitle.Name = "PromptTitle"
	PromptTitle.Parent = PromptBackground
	PromptTitle.AnchorPoint = Vector2.new(0, 0)
	PromptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PromptTitle.BackgroundTransparency = 1.000
	PromptTitle.Position = UDim2.new(0, 15, 0, 3)
	PromptTitle.Size = UDim2.new(0, 10, 0, 20)
	PromptTitle.Font = Enum.Font.SourceSansSemibold
	PromptTitle.Text = prompttitle or "Warning"
	--PromptTitle.Text = "<font color='rgb(107, 89, 222)'><font size='20'>»</font></font>  " .. tostring(thetext)
	PromptTitle.RichText = true
	PromptTitle.TextColor3 = Color3.new(1,1,1)
	PromptTitle.TextSize = 15
	PromptTitle.TextXAlignment = Enum.TextXAlignment.Left
	PromptTitle.ZIndex = 22

	local PromptText = Instance.new('TextLabel')
	PromptText.Name = "PromptTitle"
	PromptText.Parent = PromptBackground
	PromptText.AnchorPoint = Vector2.new(0, 0)
	PromptText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PromptText.BackgroundTransparency = 1
	PromptText.Position = UDim2.new(0, 15, 0, 40)
	PromptText.Size = UDim2.new(1, -30, 1, -100)
	PromptText.Font = Enum.Font.SourceSans
	PromptText.TextColor3 = Color3.new(1,1,1)
	PromptText.TextWrapped = true
	PromptText.TextSize = 15
	PromptText.TextXAlignment = Enum.TextXAlignment.Left
	PromptText.TextYAlignment = Enum.TextYAlignment.Top
	PromptText.ZIndex = 22

	local PromptSepTop = Instance.new('Frame')
	PromptSepTop.Size = UDim2.new(1,0,0,1)
	PromptSepTop.Position = UDim2.new(0,0,0,30)
	PromptSepTop.BackgroundColor3 = Color3.fromRGB(31, 26, 61)
	PromptSepTop.BorderSizePixel = 0
	PromptSepTop.Parent = PromptBackground
	PromptSepTop.ZIndex = 22

	local PromptSepBottom = Instance.new('Frame')
	PromptSepBottom.Size = UDim2.new(1,0,0,1)
	PromptSepBottom.Position = UDim2.new(0,0,1,-50)
	PromptSepBottom.BackgroundColor3 = Color3.fromRGB(31, 26, 61)
	PromptSepBottom.BorderSizePixel = 0
	PromptSepBottom.Parent = PromptBackground
	PromptSepBottom.ZIndex = 22

	local PromptYesButton = Instance.new('TextButton')
	PromptYesButton.Size = UDim2.new(0,100,0,30)
	PromptYesButton.AnchorPoint = Vector2.new(0,1)
	PromptYesButton.Position = UDim2.new(.5,-105,1,-10)
	PromptYesButton.BackgroundColor3 = Color3.fromRGB(107, 89, 222)
	PromptYesButton.Text = '       Yes'
	PromptYesButton.TextColor3 = Color3.new(1,1,1)
	PromptYesButton.Font = Enum.Font.SourceSansBold
	PromptYesButton.TextSize = 14
	PromptYesButton.Parent = PromptBackground
	PromptYesButton.AutoButtonColor = false
	PromptYesButton.ZIndex = 22

	local YesCorner = Instance.new("UICorner")
	YesCorner.CornerRadius = UDim.new(0, 4)
	YesCorner.Name = "PromptYesButton"
	YesCorner.Parent = PromptYesButton

	local YesImage = Instance.new('ImageLabel')
	YesImage.Image = 'rbxassetid://3926305904'
	YesImage.ImageColor3 = Color3.new(1,1,1)
	YesImage.BackgroundTransparency = 1
	YesImage.ImageRectOffset = Vector2.new(644, 204)
	YesImage.ImageRectSize = Vector2.new(36, 36)
	YesImage.ResampleMode = Enum.ResamplerMode.Pixelated
	YesImage.ScaleType = Enum.ScaleType.Stretch
	YesImage.SliceScale = 1
	YesImage.Size = UDim2.fromOffset(18,18)
	YesImage.Position = UDim2.new(0,33,.5,0)
	YesImage.AnchorPoint = Vector2.new(.5,.5)
	YesImage.Parent = PromptYesButton
	YesImage.ZIndex = 23

	local PromptNoButton = Instance.new('TextButton')
	PromptNoButton.Size = UDim2.new(0,100,0,30)
	PromptNoButton.AnchorPoint = Vector2.new(1,1)
	PromptNoButton.Position = UDim2.new(.5,105,1,-10)
	PromptNoButton.BackgroundColor3 = Color3.fromRGB(107, 89, 222)
	PromptNoButton.Text = '       No'
	PromptNoButton.TextColor3 = Color3.new(1,1,1)
	PromptNoButton.Font = Enum.Font.SourceSansBold
	PromptNoButton.TextSize = 14
	PromptNoButton.Parent = PromptBackground
	PromptNoButton.AutoButtonColor = false
	PromptNoButton.ZIndex = 22

	local NoCorner = Instance.new("UICorner")
	NoCorner.CornerRadius = UDim.new(0, 4)
	NoCorner.Name = "PromptNoButton"
	NoCorner.Parent = PromptNoButton

	local NoImage = Instance.new('ImageLabel')
	NoImage.Image = 'rbxassetid://3926305904'
	NoImage.ImageColor3 = Color3.new(1,1,1)
	NoImage.BackgroundTransparency = 1
	NoImage.ImageRectOffset = Vector2.new(924, 724)
	NoImage.ImageRectSize = Vector2.new(36, 36)
	NoImage.ScaleType = Enum.ScaleType.Stretch
	NoImage.SliceScale = 1
	NoImage.Size = UDim2.fromOffset(18,18)
	NoImage.Position = UDim2.new(0,33,.5,0)
	NoImage.AnchorPoint = Vector2.new(.5,.5)
	NoImage.Parent = PromptNoButton
	NoImage.ZIndex = 23

	UserInputService.InputBegan:Connect(function(key)
		if key.KeyCode == hidekey then
			pcall(function()
				for i, v in pairs(game.CoreGui.Vice:GetChildren()) do
					v.Visible = not v.Visible
				end
			end)
		end
	end)



	PromptText:GetPropertyChangedSignal('Text'):Connect(function()
		local size = game:GetService('TextService'):GetTextSize(PromptText.Text, PromptText.TextSize, PromptText.Font, Vector2.new(PromptText.AbsoluteSize.X,5000))
		PromptBackground.Size = UDim2.new(0,300,0,size.Y + 100)
	end)

	PromptText.Text = 'PLACEHOLDER WARNING TEXT GOES HERE'

	PromptYesButton.MouseEnter:Connect(function()
		game.TweenService:Create(PromptYesButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(42, 34, 80)}):Play()
	end)

	PromptYesButton.MouseLeave:Connect(function()
		game.TweenService:Create(PromptYesButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(107, 89, 222)}):Play()
	end)

	PromptYesButton.MouseButton1Down:Connect(function()
		game.TweenService:Create(PromptYesButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(91, 73, 143)}):Play()
	end)

	PromptYesButton.MouseButton1Up:Connect(function()
		game.TweenService:Create(PromptYesButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(42, 34, 80)}):Play()
	end)

	PromptNoButton.MouseEnter:Connect(function()
		game.TweenService:Create(PromptNoButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(42, 34, 80)}):Play()
	end)

	PromptNoButton.MouseLeave:Connect(function()
		game.TweenService:Create(PromptNoButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(107, 89, 222)}):Play()
	end)

	PromptNoButton.MouseButton1Down:Connect(function()
		game.TweenService:Create(PromptNoButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(91, 73, 143)}):Play()
	end)

	PromptNoButton.MouseButton1Up:Connect(function()
		game.TweenService:Create(PromptNoButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(42, 34, 80)}):Play()
	end)


	local MainFrameShadow = Instance.new("ImageLabel")
	MainFrameShadow.Name = "MainFrameShadow"
	MainFrameShadow.Parent = MainFrame
	MainFrameShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrameShadow.BackgroundTransparency = 1.000
	MainFrameShadow.Position = UDim2.new(0, -15, 0, -15)
	MainFrameShadow.Size = UDim2.new(1, 30, 1, 30)
	MainFrameShadow.Image = "rbxassetid://6521733637"
	MainFrameShadow.ImageColor3 = Color3.fromRGB(21, 19, 37)
	MainFrameShadow.ImageTransparency = 0.300
	MainFrameShadow.ScaleType = Enum.ScaleType.Slice
	MainFrameShadow.SliceCenter = Rect.new(19, 19, 281, 281)

	local MainFrameCorner = Instance.new("UICorner")
	MainFrameCorner.CornerRadius = UDim.new(0, 4)
	MainFrameCorner.Name = "MainFrameCorner"
	MainFrameCorner.Parent = MainFrame

	local LeftBarBack = Instance.new("Frame")
	LeftBarBack.Name = "LeftBarBack"
	LeftBarBack.Parent = MainFrame
	LeftBarBack.BackgroundColor3 = Color3.fromRGB(13, 10, 28)
	LeftBarBack.Size = UDim2.new(0, 80, 1, 0)

	local LeftBarBackCR = Instance.new("Frame")
	LeftBarBackCR.Name = "LeftBarBackCR"
	LeftBarBackCR.Parent = LeftBarBack
	LeftBarBackCR.BackgroundColor3 = Color3.fromRGB(12, 10, 26)
	LeftBarBackCR.BorderSizePixel = 0
	LeftBarBackCR.Position = UDim2.new(1, -5, 0, 0)
	LeftBarBackCR.Size = UDim2.new(0, 5, 1, 0)

	local LeftBarBackLine = Instance.new("Frame")
	LeftBarBackLine.Name = "LeftBarBackLine"
	LeftBarBackLine.Parent = LeftBarBack
	LeftBarBackLine.BackgroundColor3 = Color3.fromRGB(31, 26, 61)
	LeftBarBackLine.BorderSizePixel = 0
	LeftBarBackLine.Position = UDim2.new(1, -1, 0, 0)
	LeftBarBackLine.Size = UDim2.new(0, 1, 1, 0)

	local LeftBarBackCorner = Instance.new("UICorner")
	LeftBarBackCorner.CornerRadius = UDim.new(0, 4)
	LeftBarBackCorner.Name = "LeftBarBackCorner"
	LeftBarBackCorner.Parent = LeftBarBack

	local AllTabBtns = Instance.new("Frame")
	AllTabBtns.Name = "AllTabBtns"
	AllTabBtns.Parent = LeftBarBack
	AllTabBtns.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AllTabBtns.BackgroundTransparency = 1.000
	AllTabBtns.Position = UDim2.new(0, 0, 0, 80)
	AllTabBtns.Size = UDim2.new(1, 0, 1, -80)

	local AllTabBtnsListing = Instance.new("UIListLayout")
	AllTabBtnsListing.Name = "AllTabBtnsListing"
	AllTabBtnsListing.Parent = AllTabBtns
	AllTabBtnsListing.SortOrder = Enum.SortOrder.LayoutOrder
	AllTabBtnsListing.Padding = UDim.new(0, 10)

	local vhlogo = Instance.new("ImageLabel")
	vhlogo.Name = "vhlogo"
	vhlogo.Parent = LeftBarBack
	vhlogo.AnchorPoint = Vector2.new(0.5, 0)
	vhlogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	vhlogo.BackgroundTransparency = 1.000
	vhlogo.Position = UDim2.new(0.493750006, 0, 0.0207999982, 3)
	vhlogo.Size = UDim2.new(0, 47, 0, 46)
	vhlogo.Image = "rbxassetid://10272150497"

	local LeftBarBackCorner = Instance.new("UICorner")
	LeftBarBackCorner.CornerRadius = UDim.new(0, 5)
	LeftBarBackCorner.Name = "LeftBarBackCorner"
	LeftBarBackCorner.Parent = LeftBarBack

	local MainFrameShadow = Instance.new("ImageLabel")
	MainFrameShadow.Name = "MainFrameShadow"
	MainFrameShadow.Parent = MainFrame
	MainFrameShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrameShadow.BackgroundTransparency = 1.000
	MainFrameShadow.Position = UDim2.new(0, -15, 0, -15)
	MainFrameShadow.Size = UDim2.new(1, 30, 1, 30)
	MainFrameShadow.Image = "rbxassetid://6521733637"
	MainFrameShadow.ImageColor3 = Color3.fromRGB(21, 19, 37)
	MainFrameShadow.ImageTransparency = 0.300
	MainFrameShadow.ScaleType = Enum.ScaleType.Slice
	MainFrameShadow.SliceCenter = Rect.new(19, 19, 281, 281)

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Parent = MainFrame
	TopBar.BackgroundColor3 = Color3.fromRGB(23, 20, 46)
	TopBar.BorderSizePixel = 0
	TopBar.Position = UDim2.new(0, 80, 0, 0)
	TopBar.Size = UDim2.new(1, -80, 0, 60)

	local TopBarCorner = Instance.new("UICorner")
	TopBarCorner.CornerRadius = UDim.new(0, 4)
	TopBarCorner.Name = "TopBarCorner"
	TopBarCorner.Parent = TopBar

	local TopBarLine = Instance.new("Frame")
	TopBarLine.Name = "TopBarLine"
	TopBarLine.Parent = TopBar
	TopBarLine.BackgroundColor3 = Color3.fromRGB(31, 26, 61)
	TopBarLine.BorderSizePixel = 0
	TopBarLine.Position = UDim2.new(0, 0, 1, 0)
	TopBarLine.Size = UDim2.new(1, 0, 0, 1)

	local ProfileStuff = Instance.new("Frame")
	ProfileStuff.Name = "ProfileStuff"
	ProfileStuff.Parent = TopBar
	ProfileStuff.AnchorPoint = Vector2.new(1, 0.5)
	ProfileStuff.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ProfileStuff.BackgroundTransparency = 1.000
	ProfileStuff.Position = UDim2.new(1, 0, 0.5, 0)
	ProfileStuff.Size = UDim2.new(0, 140, 1, 0)

	local ProfileInfo = Instance.new("Frame")
	ProfileInfo.Name = "ProfileInfo"
	ProfileInfo.Parent = ProfileStuff
	ProfileInfo.AnchorPoint = Vector2.new(1, 0.5)
	ProfileInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ProfileInfo.BackgroundTransparency = 1.000
	ProfileInfo.LayoutOrder = -1
	ProfileInfo.Position = UDim2.new(1, 0, 0.5, 0)
	ProfileInfo.Size = UDim2.new(1, -40, 0, 30)

	local Username = Instance.new("TextLabel")
	Username.Name = "Username"
	Username.Parent = ProfileInfo
	Username.AnchorPoint = Vector2.new(0, 1)
	Username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Username.BackgroundTransparency = 1.000
	Username.Position = UDim2.new(0, 0, 0.5, 0)
	Username.Size = UDim2.new(1, 0, 0, 14)
	Username.Font = Enum.Font.GothamMedium
	Username.Text = LocalPlayer.Name
	Username.TextColor3 = Color3.fromRGB(255, 255, 255)
	Username.TextSize = 12.000
	Username.TextXAlignment = Enum.TextXAlignment.Left

	local Etc = Instance.new("TextLabel")
	Etc.Name = "Etc"
	Etc.Parent = ProfileInfo
	Etc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Etc.BackgroundTransparency = 1.000
	Etc.Position = UDim2.new(0, 0, 0.5, 0)
	Etc.Size = UDim2.new(1, -10, 0, 14)
	Etc.Font = Enum.Font.GothamMedium
	Etc.Text = ver
	Etc.RichText = true
	Etc.TextColor3 = Color3.fromRGB(120, 124, 123)
	Etc.TextSize = 12.000
	Etc.TextXAlignment = Enum.TextXAlignment.Left

	local ProfilePictureOutline = Instance.new("Frame")
	ProfilePictureOutline.Name = "ProfilePictureOutline"
	ProfilePictureOutline.Parent = ProfileStuff
	ProfilePictureOutline.AnchorPoint = Vector2.new(0, 0.5)
	ProfilePictureOutline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ProfilePictureOutline.BackgroundTransparency = 1.000
	ProfilePictureOutline.Position = UDim2.new(0, 0, 0.5, 0)
	ProfilePictureOutline.Size = UDim2.new(0, 30, 0, 30)

	local ProfilePicture = Instance.new("Frame")
	ProfilePicture.Name = "ProfilePicture"
	ProfilePicture.Parent = ProfilePictureOutline
	ProfilePicture.AnchorPoint = Vector2.new(0.5, 0.5)
	ProfilePicture.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ProfilePicture.BackgroundTransparency = 1.000
	ProfilePicture.Position = UDim2.new(0.5, 0, 0.5, 0)
	ProfilePicture.Size = UDim2.new(1, 0, 1, 0)

	local ProfilePictureCorner = Instance.new("UICorner")
	ProfilePictureCorner.CornerRadius = UDim.new(1, 0)
	ProfilePictureCorner.Name = "ProfilePictureCorner"
	ProfilePictureCorner.Parent = ProfilePicture

	local ProfileImage = Instance.new("ImageLabel")
	ProfileImage.Name = "ProfileImage"
	ProfileImage.Parent = ProfilePicture
	ProfileImage.BackgroundColor3 = Color3.fromRGB(40, 45, 52)
	ProfileImage.BackgroundTransparency = 0.800
	ProfileImage.Size = UDim2.new(1, 0, 1, 0)
	ProfileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. PID .. "&w=48&h=48"

	local ProfileImageCorner = Instance.new("UICorner")
	ProfileImageCorner.CornerRadius = UDim.new(1, 0)
	ProfileImageCorner.Name = "ProfileImageCorner"
	ProfileImageCorner.Parent = ProfileImage

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = ProfilePictureOutline

	local ProfileStroke = Instance.new("UIStroke", ProfileImage)
	ProfileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	ProfileStroke.Color = Color3.fromRGB(102, 82, 217)
	ProfileStroke.LineJoinMode = Enum.LineJoinMode.Round
	ProfileStroke.Thickness = 1.4
	ProfileStroke.Transparency = 0
	ProfileStroke.Name = "ProfileStroke"
	ProfileStroke.Enabled = true

	local SearchBack = Instance.new("Frame")
	SearchBack.Name = "SearchBack"
	SearchBack.Parent = TopBar
	SearchBack.BackgroundColor3 = Color3.fromRGB(143, 131, 255)
	SearchBack.BackgroundTransparency = 0.900
	SearchBack.Position = UDim2.new(0, 15, 0.5, -15)
	local AramaUzunluk = 1
	SearchBack.Size = UDim2.new(AramaUzunluk, -180, 0, 30)

	local SearchBackCorner = Instance.new("UICorner")
	SearchBackCorner.CornerRadius = UDim.new(0, 5)
	SearchBackCorner.Name = "SearchBackCorner"
	SearchBackCorner.Parent = SearchBack

	local SearchBox = Instance.new("TextBox")
	SearchBox.Name = "SearchBox"
	SearchBox.Parent = SearchBack
	SearchBox.AnchorPoint = Vector2.new(1, 0.5)
	SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.BackgroundTransparency = 1.000
	SearchBox.ClipsDescendants = true
	SearchBox.Position = UDim2.new(1, -6, 0.5, 0)
	SearchBox.Size = UDim2.new(1, -58, 1, 0)
	SearchBox.Font = Enum.Font.Gotham
	SearchBox.PlaceholderColor3 = Color3.fromRGB(143, 131, 255)
	SearchBox.PlaceholderText = "Search..."
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(143, 131, 255)
	SearchBox.TextSize = 12.000
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	local SearchIcon = Instance.new("ImageLabel")
	SearchIcon.Name = "SearchIcon"
	SearchIcon.Parent = SearchBack
	SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
	SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchIcon.BackgroundTransparency = 1.000
	SearchIcon.Position = UDim2.new(0, 10, 0.5, 0)
	SearchIcon.Size = UDim2.new(0, 18, 0, 18)
	SearchIcon.Image = "rbxassetid://9992305542"
	SearchIcon.ImageColor3 = Color3.fromRGB(143, 131, 255)

	local SearchBackLine = Instance.new("Frame")
	SearchBackLine.Name = "SearchBackLine"
	SearchBackLine.Parent = SearchBack
	SearchBackLine.AnchorPoint = Vector2.new(0, 0.5)
	SearchBackLine.BackgroundColor3 = Color3.fromRGB(143, 131, 255)
	SearchBackLine.Position = UDim2.new(0, 38, 0.5, 0)
	SearchBackLine.Size = UDim2.new(0, 1, 1, -20)

	local AllPages = Instance.new("Frame")
	AllPages.Name = "AllPages"
	AllPages.Parent = MainFrame
	AllPages.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AllPages.BackgroundTransparency = 1.000
	AllPages.Position = UDim2.new(0, 80, 0, 60)
	AllPages.Size = UDim2.new(1, -80, 1, -60)
	AllPages.ZIndex = 2

	local AllPagesFolder = Instance.new("Folder")
	AllPagesFolder.Name = "AllPagesFolder"
	AllPagesFolder.Parent = AllPages

	MakeDraggable(TopBar, MainFrame)

	local tabs = {}
	-- ups
	function tabs:Tab(title, AssID, desc1, desc2)
		local Tab = Instance.new("Frame")
		Tab.Name = "Tab"
		Tab.Parent = AllTabBtns
		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab.BackgroundTransparency = 1.000
		Tab.Size = UDim2.new(1, 0, 0, 42)

		local TabTitle = Instance.new("TextLabel")
		TabTitle.Name = "TabTitle"
		TabTitle.Parent = Tab
		TabTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TabTitle.BackgroundTransparency = 1.000
		TabTitle.BorderSizePixel = 0
		TabTitle.Position = UDim2.new(0, 0, 1, -14)
		TabTitle.Size = UDim2.new(1, 0, 0, 14)
		TabTitle.RichText = true
		TabTitle.Font = Enum.Font.GothamMedium
		TabTitle.Text = title
		TabTitle.TextColor3 = Color3.fromRGB(122, 122, 122)
		TabTitle.TextSize = 12
		TabTitle.TextTransparency = 0

		local TabImage = Instance.new("ImageLabel")
		TabImage.Name = "TabImage"
		TabImage.Parent = Tab
		TabImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabImage.BackgroundTransparency = 1.000
		TabImage.AnchorPoint = Vector2.new(0.5, 0)
		TabImage.Position = UDim2.new(0.5, 0, 0, 3)
		TabImage.Size = UDim2.new(0, 18, 0, 18)
		TabImage.Image = "http://www.roblox.com/asset/?id=" .. AssID
		TabImage.ImageColor3 = Color3.fromRGB(122, 122, 122)
		TabImage.ImageTransparency = 0

		local TabHighlight = Instance.new("Frame")
		TabHighlight.Name = "TabHighlight"
		TabHighlight.Parent = Tab
		TabHighlight.BackgroundColor3 = Color3.fromRGB(102, 88, 218)
		TabHighlight.BackgroundTransparency = 0
		TabHighlight.BorderSizePixel = 0
		TabHighlight.AnchorPoint = Vector2.new(0, 0.5)
		TabHighlight.Position = UDim2.new(0, 0, 0.5, 0)
		TabHighlight.Size = UDim2.new(0, 4, 0, 0)

		local TabInteract = Instance.new("TextButton")
		TabInteract.Name = "TabInteract"
		TabInteract.Parent = Tab
		TabInteract.AnchorPoint = Vector2.new(0.5, 0.5)
		TabInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabInteract.BackgroundTransparency = 1.000
		TabInteract.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabInteract.Size = UDim2.new(1, 0, 1, 0)
		TabInteract.Font = Enum.Font.SourceSans
		TabInteract.Text = ""
		TabInteract.TextColor3 = Color3.fromRGB(0, 0, 0)
		TabInteract.TextSize = 14.000

		local Page = Instance.new("Frame")
		Page.Name = "Page"
		Page.Parent = AllPagesFolder
		Page.AnchorPoint = Vector2.new(0.5, 0)
		Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Page.BackgroundTransparency = 1.000
		Page.Position = UDim2.new(0.5, 0, 0, 20)
		Page.Size = UDim2.new(1, 0, 1, -20)
		Page.ZIndex = 2
		Page.Visible = false

		local PageFade = Instance.new("Frame")
		PageFade.Name = "PageFade"
		PageFade.Parent = MainFrame
		PageFade.AnchorPoint = Vector2.new(1, 1)
		PageFade.BackgroundColor3 = Color3.fromRGB(23, 20, 41)
		PageFade.BackgroundTransparency = 1
		PageFade.BorderSizePixel = 0
		PageFade.Position = UDim2.new(1, 0, 1, 0)
		PageFade.Size = UDim2.new(1, -80, 1, -60)
		PageFade.ZIndex = 99
		PageFade.Visible = true

		local TabInnerTitle = Instance.new("TextLabel")
		TabInnerTitle.Name = "TabInnerTitle"
		TabInnerTitle.Parent = Page
		TabInnerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabInnerTitle.BackgroundTransparency = 1.000
		TabInnerTitle.Position = UDim2.new(0, 20, 0, 0)
		TabInnerTitle.Size = UDim2.new(0, 196, 0, 20)
		TabInnerTitle.Font = Enum.Font.GothamMedium
		TabInnerTitle.Text = desc1
		TabInnerTitle.RichText = true
		TabInnerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabInnerTitle.TextSize = 20.000
		TabInnerTitle.TextXAlignment = Enum.TextXAlignment.Left

		local TabDescription = Instance.new("TextLabel")
		TabDescription.Name = "TabDescription"
		TabDescription.Parent = Page
		TabDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabDescription.BackgroundTransparency = 1.000
		TabDescription.Position = UDim2.new(0, 22, 0, 24)
		TabDescription.Size = UDim2.new(0, 235, 0, 13)
		TabDescription.Font = Enum.Font.Gotham
		TabDescription.Text = desc2
		TabDescription.RichText = true
		TabDescription.TextColor3 = Color3.fromRGB(254, 253, 255)
		TabDescription.TextSize = 13.000
		TabDescription.TextXAlignment = Enum.TextXAlignment.Left

		local PageCont = Instance.new("Frame")
		PageCont.Name = "PageCont"
		PageCont.Parent = Page
		PageCont.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PageCont.BackgroundTransparency = 1.000
		PageCont.Position = UDim2.new(0, 0, 0, 70)
		PageCont.Size = UDim2.new(1, 0, 1, -70)

		local AllSubTabBtns = Instance.new("Frame")
		AllSubTabBtns.Name = "AllSubTabBtns"
		AllSubTabBtns.Parent = PageCont
		AllSubTabBtns.AnchorPoint = Vector2.new(0.5, 0)
		AllSubTabBtns.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		AllSubTabBtns.BackgroundTransparency = 1.000
		AllSubTabBtns.Position = UDim2.new(0.5, 0, 0, 0)
		AllSubTabBtns.Size = UDim2.new(1, -40, 0, 30)

		local AllSubTabBtnsListing = Instance.new("UIListLayout")
		AllSubTabBtnsListing.Name = "AllSubTabBtnsListing"
		AllSubTabBtnsListing.Parent = AllSubTabBtns
		AllSubTabBtnsListing.FillDirection = Enum.FillDirection.Horizontal
		AllSubTabBtnsListing.SortOrder = Enum.SortOrder.LayoutOrder
		AllSubTabBtnsListing.VerticalAlignment = Enum.VerticalAlignment.Center
		AllSubTabBtnsListing.Padding = UDim.new(0, 5)

		TabInteract.MouseButton1Click:Connect(function()
			for i, v in next, AllPagesFolder:GetChildren() do
				coroutine.wrap(function()
					wait(lib.Animations.AnimSpeed)
					v.Visible = false
				end)()
			end
			coroutine.wrap(function()
				wait(lib.Animations.AnimSpeed)
				Page.Visible = true
			end)()

			coroutine.wrap(function()
				game.TweenService:Create(PageFade, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
				wait(lib.Animations.AnimSpeed)
				game.TweenService:Create(PageFade, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
			end)()

			for i, v in next, AllTabBtns:GetDescendants() do
				if v:IsA("TextLabel") then
					game.TweenService:Create(v, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
				end
				if v:IsA("ImageLabel") then
					game.TweenService:Create(v, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Color3.fromRGB(122, 122, 122)}):Play()
				end
				if v.Name == 'TabHighlight' then
					game.TweenService:Create(v, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 4, 0, 0)}):Play()
				end
			end
			game.TweenService:Create(TabTitle, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			game.TweenService:Create(TabImage, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			game.TweenService:Create(TabHighlight, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 4, 1, 0)}):Play()
		end)

		local subtabs = {}

		local PageItems = Instance.new("Frame")
		PageItems.Name = "PageItems"
		PageItems.Parent = PageCont
		PageItems.AnchorPoint = Vector2.new(0.5, 1)
		PageItems.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PageItems.BackgroundTransparency = 1.000
		PageItems.Position = UDim2.new(0.5, 0, 1, 0)
		PageItems.Size = UDim2.new(1, 0, 1, -44)
		PageItems.Visible = true

		local AllSubPagesFolder = Instance.new("Folder")
		AllSubPagesFolder.Name = "AllSubPagesFolder"
		AllSubPagesFolder.Parent = PageItems

		function subtabs:SubTab(title, AssID)
			local SubTabBtnOutline = Instance.new("Frame")
			SubTabBtnOutline.Name = "SubTabBtnOutline"
			SubTabBtnOutline.Parent = AllSubTabBtns
			SubTabBtnOutline.BackgroundColor3 = Color3.fromRGB(107, 89, 222)
			SubTabBtnOutline.Size = UDim2.new(0, 110, 1, -4)

			local SubTabBtnOutlineCorner = Instance.new("UICorner")
			SubTabBtnOutlineCorner.CornerRadius = UDim.new(0, 4)
			SubTabBtnOutlineCorner.Name = "SubTabBtnOutlineCorner"
			SubTabBtnOutlineCorner.Parent = SubTabBtnOutline

			local SubTabBtnInline = Instance.new("Frame")
			SubTabBtnInline.Name = "SubTabBtnInline"
			SubTabBtnInline.Parent = SubTabBtnOutline
			SubTabBtnInline.AnchorPoint = Vector2.new(0.5, 0.5)
			SubTabBtnInline.BackgroundColor3 = Color3.fromRGB(23, 20, 41)
			SubTabBtnInline.Position = UDim2.new(0.5, 0, 0.5, 0)
			SubTabBtnInline.Size = UDim2.new(1, -2, 1, -2)

			local SubTabBtnInteract = Instance.new("TextButton")
			SubTabBtnInteract.Name = "SubTabBtnInteract"
			SubTabBtnInteract.Parent = SubTabBtnInline
			SubTabBtnInteract.AnchorPoint = Vector2.new(0.5, 0.5)
			SubTabBtnInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SubTabBtnInteract.BackgroundTransparency = 1.000
			SubTabBtnInteract.Position = UDim2.new(0.5, 0, 0.5, 0)
			SubTabBtnInteract.Size = UDim2.new(1, 0, 1, 0)
			SubTabBtnInteract.Font = Enum.Font.Gotham
			SubTabBtnInteract.Text = ""
			SubTabBtnInteract.TextColor3 = Color3.fromRGB(255, 255, 255)
			SubTabBtnInteract.TextSize = 12.000
			SubTabBtnInteract.TextXAlignment = Enum.TextXAlignment.Right

			SubTabBtnInteract.MouseEnter:Connect(function()
				TweenService:Create(SubTabBtnOutline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(58, 49, 110)}):Play()
			end)

			SubTabBtnInteract.MouseLeave:Connect(function()
				TweenService:Create(SubTabBtnOutline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(107, 89, 222)}):Play()
			end)

			SubTabBtnInteract.MouseButton1Down:Connect(function()
				TweenService:Create(SubTabBtnOutline, TweenInfo.new(0.075, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(43, 31, 82)}):Play()
			end)

			local SubTabBtnIcon = Instance.new("ImageLabel")
			SubTabBtnIcon.Name = "SubTabBtnIcon"
			SubTabBtnIcon.Parent = SubTabBtnInline
			SubTabBtnIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SubTabBtnIcon.BackgroundTransparency = 1.000
			SubTabBtnIcon.BorderSizePixel = 0
			SubTabBtnIcon.Position = UDim2.new(0, 3, 0.5, -9)
			SubTabBtnIcon.Size = UDim2.new(0, 18, 0, 18)
			SubTabBtnIcon.Image = "http://www.roblox.com/asset/?id=" .. AssID

			local SubTabBtnInlineCorner = Instance.new("UICorner")
			SubTabBtnInlineCorner.CornerRadius = UDim.new(0, 4)
			SubTabBtnInlineCorner.Name = "SubTabBtnInlineCorner"
			SubTabBtnInlineCorner.Parent = SubTabBtnInline

			local SubTabBtnTitle = Instance.new("TextLabel")
			SubTabBtnTitle.Name = "SubTabBtnTitle"
			SubTabBtnTitle.Parent = SubTabBtnInline
			SubTabBtnTitle.AnchorPoint = Vector2.new(1, 0.5)
			SubTabBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SubTabBtnTitle.BackgroundTransparency = 1.000
			SubTabBtnTitle.ClipsDescendants = true
			SubTabBtnTitle.Position = UDim2.new(1, -4, 0.5, 0)
			SubTabBtnTitle.Size = UDim2.new(1, -30, 1, 1)
			SubTabBtnTitle.Font = Enum.Font.Gotham
			SubTabBtnTitle.Text = title
			SubTabBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SubTabBtnTitle.TextSize = 12.000
			SubTabBtnTitle.TextXAlignment = Enum.TextXAlignment.Right

			local Left = Instance.new("ScrollingFrame")
			Left.Name = "Left"
			Left.ClipsDescendants = false
			Left.Parent = AllSubPagesFolder
			Left.AnchorPoint = Vector2.new(0, 0.5)
			Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Left.BackgroundTransparency = 1.000
			Left.Position = UDim2.new(0, 0, 0.5, 0)
			Left.Size = UDim2.new(0.5, 0, 1, 0)
			Left.Visible = false
			--Left.ZIndex = 4
			--
			Left.BorderSizePixel = 0
			Left.ScrollBarImageColor3 = Color3.new(0.254902, 0.254902, 0.254902)
			Left.CanvasSize = UDim2.new(0, 0, 0, 0)
			Left.ScrollBarThickness = 0
			Left.BorderColor3 = Color3.new(0, 0, 0)

			local LeftListing = Instance.new("UIListLayout")
			LeftListing.Name = "LeftListing"
			LeftListing.Parent = Left
			LeftListing.HorizontalAlignment = Enum.HorizontalAlignment.Left
			LeftListing.SortOrder = Enum.SortOrder.LayoutOrder
			LeftListing.Padding = UDim.new(0, 1)

			local Right = Instance.new("ScrollingFrame")
			Right.Name = "Right"
			Right.ClipsDescendants = false
			Right.Parent = AllSubPagesFolder
			Right.AnchorPoint = Vector2.new(1, 0.5)
			Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Right.BackgroundTransparency = 1.000
			Right.Position = UDim2.new(1, -1, 0.5, 0)
			Right.Size = UDim2.new(0.5, -2, 1, 0)
			Right.Visible = false
			--Right.ZIndex = 4
			Right.BorderSizePixel = 0
			Right.CanvasSize = UDim2.new(0, 0, 0, 0)
			Right.ScrollBarThickness = 0
			Right.BorderColor3 = Color3.new(0, 0, 0)

			local RightListing = Instance.new("UIListLayout")
			RightListing.Name = "RightListing"
			RightListing.Parent = Right
			RightListing.HorizontalAlignment = Enum.HorizontalAlignment.Left
			RightListing.SortOrder = Enum.SortOrder.LayoutOrder

			local SubPageFade = Instance.new("Frame")
			SubPageFade.Name = "SubPageFade"
			SubPageFade.Parent = MainFrame
			SubPageFade.AnchorPoint = Vector2.new(1, 1)
			SubPageFade.BackgroundColor3 = Color3.fromRGB(23, 20, 41)
			SubPageFade.BackgroundTransparency = 1
			SubPageFade.BorderSizePixel = 0
			SubPageFade.Position = UDim2.new(1, 0, 1, 0)
			SubPageFade.Size = UDim2.new(1, -80, 1, -190)
			SubPageFade.ZIndex = 99
			SubPageFade.Visible = true

			local FadeImage2 = Instance.new("ImageLabel",PageItems)
			FadeImage2["Name"] = "FadeImage2"
			FadeImage2["ImageColor3"] = Color3.new(0.0901961, 0.0784314, 0.160784)
			FadeImage2["BorderColor3"] = Color3.new(0, 0, 0)
			FadeImage2["AnchorPoint"] = Vector2.new(0, 1)
			FadeImage2["Image"] = "rbxassetid://7783533907"
			--FadeImage2["ImageTransparency"] = 1
			FadeImage2["BackgroundTransparency"] = 1
			FadeImage2["Position"] = UDim2.new(0, 0, 1, 0)
			FadeImage2["Size"] = UDim2.new(1, -2, 0.1, 20) -- UDim2.new(1, -2, 0.207977235, 20)
			FadeImage2["ZIndex"] = 4
			FadeImage2["Visible"] = false
			FadeImage2["BorderSizePixel"] = 0
			FadeImage2["BackgroundColor3"] = Color3.new(0, 0, 0)

			SubTabBtnInteract.MouseButton1Click:Connect(function()
				for i, v in next, AllSubPagesFolder:GetChildren() do
					coroutine.wrap(function()
						wait(lib.Animations.AnimSpeed)
						v.Visible = false
					end)()
				end
				coroutine.wrap(function()
					--LibraryFunctions:Tween(FadeImage2,{ImageTransparency=0},2)
					wait(lib.Animations.AnimSpeed)
					Left.Visible = true
					Right.Visible = true
				end)()

				coroutine.wrap(function()
					TweenService:Create(SubPageFade, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
					wait(lib.Animations.AnimSpeed)
					TweenService:Create(SubPageFade, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
				end)()

				for i, v in next, AllSubTabBtns:GetDescendants() do
					if v.Name == 'SubTabBtnInline' then
						TweenService:Create(v, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(23, 20, 41)}):Play()
					end
				end
				TweenService:Create(SubTabBtnInline, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(107, 89, 222)}):Play()
			end)

		    --LeftListing:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			--	Left.CanvasSize = UDim2.new(0, LeftListing.AbsoluteContentSize.X, 0, LeftListing.AbsoluteContentSize.Y)
			--end)

			LibraryFunctions:Connect(LeftListing:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				Left.CanvasSize = UDim2.new(0, LeftListing.AbsoluteContentSize.X, 0, LeftListing.AbsoluteContentSize.Y)
			end)
			LibraryFunctions:Connect(RightListing:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				Right.CanvasSize = UDim2.new(0, RightListing.AbsoluteContentSize.X, 0, RightListing.AbsoluteContentSize.Y)
			end)

			LibraryFunctions:Connect(Left:GetPropertyChangedSignal("AbsoluteCanvasSize"), function()
				FadeImage2.Visible = Left.AbsoluteCanvasSize.Y > Left.AbsoluteWindowSize.Y
				--FadeImage1.Visible = Left.AbsoluteCanvasSize.Y > Left.AbsoluteWindowSize.Y
			end)

			--if Left.CanvasSize == v(0, 222) then
			--	LibraryFunctions:Tween(FadeImage2,{ImageTransparency=1},1)
			--end

			local items = {}

			function items:Label(side, text, image)
				local Label = Instance.new("Frame")
				Label.Name = tostring(text)
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BorderSizePixel = 0
				Label.Size = UDim2.new(1, 0, 0, 36)

				local LabelOutline = Instance.new("UIStroke")
				LabelOutline.Enabled = true
				LabelOutline.Parent = Label
				LabelOutline.Color = Color3.fromRGB(31, 26, 61)
				LabelOutline.LineJoinMode = Enum.LineJoinMode.Miter
				LabelOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				LabelOutline.Thickness = 1
				LabelOutline.Transparency = 1

				local LabelTitle = Instance.new("TextLabel")
				LabelTitle.Name = "LabelTitle"
				LabelTitle.Parent = Label
				LabelTitle.AnchorPoint = Vector2.new(1, 0.5)
				LabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				LabelTitle.BackgroundTransparency = 1.000
				LabelTitle.Position = UDim2.new(1, 0, 0.5, 0)
				LabelTitle.Size = UDim2.new(1, -40, 1, 0)
				LabelTitle.Font = Enum.Font.GothamMedium
				LabelTitle.Text = text
				LabelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				LabelTitle.TextSize = 12.000
				LabelTitle.TextXAlignment = Enum.TextXAlignment.Left

				local LabelArrows = Instance.new("TextLabel")
				LabelArrows.Name = "LabelArrows"
				LabelArrows.Parent = Label
				LabelArrows.AnchorPoint = Vector2.new(0, 0.5)
				LabelArrows.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				LabelArrows.BackgroundTransparency = 1.000
				LabelArrows.Position = UDim2.new(0, 21, 0.5, -1)
				LabelArrows.Size = UDim2.new(0, 10, 0, 20)
				LabelArrows.Font = Enum.Font.Ubuntu
				LabelArrows.Text = "»"
				LabelArrows.TextColor3 = Color3.fromRGB(107, 89, 222)
				LabelArrows.TextSize = 20
				LabelArrows.TextXAlignment = Enum.TextXAlignment.Left

				local LabelGradient = Instance.new("UIGradient")
				LabelGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(23, 20, 46)), ColorSequenceKeypoint.new(0.08, Color3.fromRGB(26, 23, 56)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(26, 23, 56))}
				LabelGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.25)}
				LabelGradient.Name = "LabelGradient"
				LabelGradient.Parent = Label

				local label = {}

				function label:update(str)
					LabelTitle.Text = str
				end

				if side == 'Left' then
					Label.Parent = Left
				elseif side == 'Right' then
					Label.Parent = Right
				else
					Label:Destroy()
					print('please select a side for the ' .. text .. ' label')
				end

				return label
			end

			function items:Toggle(side, text, config, callback)
				text = text or "N/A"
				callback = callback or function() end
				local config = config or false
				local toggled = config

				local Toggle = Instance.new("Frame")
				Toggle.Name = tostring(text)
				Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.BackgroundTransparency = 1.000
				Toggle.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Toggle.BorderSizePixel = 0
				Toggle.Size = UDim2.new(1, 0, 0, 36)

				local ToggleOutline = Instance.new("UIStroke")
				ToggleOutline.Enabled = true
				ToggleOutline.Parent = Toggle
				ToggleOutline.Color = Color3.fromRGB(31, 26, 61)
				ToggleOutline.LineJoinMode = Enum.LineJoinMode.Miter
				ToggleOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				ToggleOutline.Thickness = 1
				ToggleOutline.Transparency = 1

				local ToggleTitle = Instance.new("TextLabel")
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = Toggle
				ToggleTitle.AnchorPoint = Vector2.new(1, 0.5)
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleTitle.BackgroundTransparency = 1.000
				ToggleTitle.Position = UDim2.new(1, 0, 0.5, 0)
				ToggleTitle.Size = UDim2.new(1, -21, 1, 0)
				ToggleTitle.Font = Enum.Font.GothamMedium
				ToggleTitle.Text = text
				ToggleTitle.TextColor3 = Color3.fromRGB(155,155,155)
				ToggleTitle.TextSize = 12.000
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

				local ToggleFrameBack = Instance.new("Frame")
				ToggleFrameBack.Name = "ToggleFrameBack"
				ToggleFrameBack.Parent = Toggle
				ToggleFrameBack.AnchorPoint = Vector2.new(1, 0.5)
				ToggleFrameBack.BackgroundColor3 = Color3.fromRGB(33, 28, 64)
				ToggleFrameBack.Position = UDim2.new(1, -12, 0.5, 0)
				ToggleFrameBack.Size = UDim2.new(0, 36, 0, 18)

				local ToggleFrameBackCorner = Instance.new("UICorner")
				ToggleFrameBackCorner.CornerRadius = UDim.new(1, 0)
				ToggleFrameBackCorner.Name = "ToggleFrameBackCorner"
				ToggleFrameBackCorner.Parent = ToggleFrameBack

				local ToggleFrameCircle = Instance.new("Frame")
				ToggleFrameCircle.Name = "ToggleFrameCircle"
				ToggleFrameCircle.Parent = ToggleFrameBack
				ToggleFrameCircle.AnchorPoint = Vector2.new(0, 0.5)
				ToggleFrameCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleFrameCircle.Position = UDim2.new(0, 3, 0.5, 0)
				ToggleFrameCircle.Size = UDim2.new(0, 14, 0, 14)

				local ToggleFrameCircleCorner = Instance.new("UICorner")
				ToggleFrameCircleCorner.CornerRadius = UDim.new(1, 0)
				ToggleFrameCircleCorner.Name = "ToggleFrameCircleCorner"
				ToggleFrameCircleCorner.Parent = ToggleFrameCircle

				local ToggleInteract = Instance.new("TextButton")
				ToggleInteract.Name = "ToggleInteract"
				ToggleInteract.Parent = Toggle
				ToggleInteract.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleInteract.BackgroundTransparency = 1.000
				ToggleInteract.Position = UDim2.new(0.5, 0, 0.5, 0)
				ToggleInteract.Size = UDim2.new(1, 0, 1, 0)
				ToggleInteract.Font = Enum.Font.SourceSans
				ToggleInteract.Text = ""
				ToggleInteract.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleInteract.TextSize = 14.000


				ToggleInteract.MouseEnter:Connect(function()
					if toggled == false then
						TweenService:Create(ToggleTitle, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
					end
				end)
				ToggleInteract.MouseLeave:Connect(function()
					if toggled == false then
						TweenService:Create(ToggleTitle, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(155,155,155)}):Play()
					end
				end)

				ToggleInteract.MouseButton1Click:Connect(function()
					if toggled == false then
						toggled = true
						TweenService:Create(ToggleFrameCircle, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0.5, 0)}):Play()
						TweenService:Create(ToggleFrameBack, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(107, 89, 222)}):Play()
					else
						toggled = false
						TweenService:Create(ToggleFrameCircle, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
						TweenService:Create(ToggleFrameBack, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(33, 28, 64)}):Play()
					end
					pcall(callback, toggled)
				end)


				-- // Toggle Settings
				if config == true then
					toggled = true
					ToggleTitle.TextColor3 = Color3.fromRGB(255,255,255)
					TweenService:Create(ToggleFrameCircle, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0.5, 0)}):Play()
					TweenService:Create(ToggleFrameBack, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(107, 89, 222)}):Play()
					pcall(callback, toggled)
				end
				if config == false then
					toggled = false
					TweenService:Create(ToggleFrameCircle, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
					TweenService:Create(ToggleFrameBack, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(33, 28, 64)}):Play()
				end
				if not config or config == nil then
					toggled = false
					TweenService:Create(ToggleFrameCircle, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
					TweenService:Create(ToggleFrameBack, TweenInfo.new(lib.Animations.ElementsAS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(33, 28, 64)}):Play()
				end

				if side == 'Left' then
					Toggle.Parent = Left
				elseif side == 'Right' then
					Toggle.Parent = Right
				else
					Toggle:Destroy()
					print('please select a side for the ' .. text .. ' toggle')
				end
			end

			function items:CounterLabel(side, text, arrow)
				text = text or "CounterLabel N/A"
				local CounterLabel = Instance.new("Frame")
				CounterLabel.Name = tostring(text)
				CounterLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				CounterLabel.BackgroundTransparency = 1
				CounterLabel.BorderSizePixel = 0
				CounterLabel.Size = UDim2.new(1, 0, 0, 36)

				local CounterLabelTitle = Instance.new("TextLabel")
				CounterLabelTitle.Name = "CounterLabelTitle"
				CounterLabelTitle.Parent = CounterLabel
				CounterLabelTitle.AnchorPoint = Vector2.new(1, 0.5)
				CounterLabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				CounterLabelTitle.BackgroundTransparency = 1.000
				CounterLabelTitle.Position = UDim2.new(1, 0, 0.5, 0)
				CounterLabelTitle.Size = UDim2.new(1, -40, 1, 0)
				CounterLabelTitle.Font = Enum.Font.GothamMedium
				CounterLabelTitle.Text = text
				CounterLabelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				CounterLabelTitle.TextSize = 12.000
				CounterLabelTitle.TextXAlignment = Enum.TextXAlignment.Left

				if arrow then
					local CounterLabelArrows = Instance.new("TextLabel")
					CounterLabelArrows.Name = "CounterLabelArrows"
					CounterLabelArrows.Parent = CounterLabel
					CounterLabelArrows.AnchorPoint = Vector2.new(0, 0.5)
					CounterLabelArrows.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					CounterLabelArrows.BackgroundTransparency = 1.000
					CounterLabelArrows.Position = UDim2.new(0, 21, 0.5, -1)
					CounterLabelArrows.Size = UDim2.new(0, 10, 0, 20)
					CounterLabelArrows.Font = Enum.Font.Ubuntu
					CounterLabelArrows.Text = "»"
					CounterLabelArrows.TextColor3 = Color3.fromRGB(107, 89, 222)
					CounterLabelArrows.TextSize = 20
					CounterLabelArrows.TextXAlignment = Enum.TextXAlignment.Left
				end

				local counterlabel = {}

				function counterlabel:update(str)
					CounterLabelTitle.Text = str
				end

				if side == 'Left' then
					CounterLabel.Parent = Left
				elseif side == 'Right' then
					CounterLabel.Parent = Right
				else
					CounterLabel:Destroy()
					print('please select a side for the ' .. text .. ' counter label')
				end

				return counterlabel
			end

			function items:Colorpicker(side, text, preset, callback)
				local ColorPickerToggled = false
				local OldToggleColor = Color3.fromRGB(0, 0, 0)
				local OldColor = Color3.fromRGB(0, 0, 0)
				local OldColorSelectionPosition = nil
				local OldHueSelectionPosition = nil
				local ColorH, ColorS, ColorV = 1, 1, 1
				local ColorPickerInput = nil
				local ColorInput = nil
				local HueInput = nil
				local Colorpicker = Instance.new("TextButton")
				Colorpicker.Name = "Colorpicker"
				Colorpicker.BackgroundColor3 = Color3.fromRGB(23, 20, 41)
				Colorpicker.Position = UDim2.new(0.022580646, 0, 0.285382837, 0)
				Colorpicker.Size = UDim2.new(0, 310, 0, 30)
				Colorpicker.BackgroundTransparency = 1.000
				Colorpicker.AutoButtonColor = false
				Colorpicker.Font = Enum.Font.Gotham
				Colorpicker.Text = ""
				Colorpicker.TextColor3 = Color3.fromRGB(255, 255, 255)
				Colorpicker.TextSize = 14.000
				--Colorpicker.Selected = true

				local Title = Instance.new("TextLabel")
				Title.Name = "Title"
				Title.Parent = Colorpicker
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Title.BackgroundTransparency = 1.000
				Title.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Title.Position = UDim2.new(0.0645161271, 0, 0, 0)
				Title.Size = UDim2.new(1, -21, 1, 0)
				Title.Font = Enum.Font.GothamMedium
				Title.Text = text
				Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title.TextSize = 12.000 --14
				Title.TextXAlignment = Enum.TextXAlignment.Left

				local BoxColor = Instance.new("Frame")
				BoxColor.Name = "Boxcolor"
				BoxColor.Parent = Colorpicker
				BoxColor.BackgroundColor3 = preset
				BoxColor.Position = UDim2.new(0.826, 0, 0.179, 0)
				BoxColor.Size = UDim2.new(0, 40, 0, 20)

				local BoxcolorCorner = Instance.new("UICorner")
				BoxcolorCorner.CornerRadius = UDim.new(0, 3)
				BoxcolorCorner.Name = "BoxcolorCorner"
				BoxcolorCorner.Parent = BoxColor

				local ColorIcon = Instance.new("ImageLabel",Colorpicker)
				ColorIcon["Image"] = "rbxassetid://10000497323"
				ColorIcon["BackgroundTransparency"] = 1
				ColorIcon["Position"] = UDim2.new(1, -80, 0.5, -9)
				ColorIcon["Size"] = UDim2.new(0, 18, 0, 18)
				ColorIcon["Name"] = "Icon"
				ColorIcon["BackgroundColor3"] = Color3.new(1, 1, 1)

				local BoxColorGlow = Instance.new("ImageLabel",BoxColor)
				BoxColorGlow["ImageColor3"] = Color3.fromRGB(0, 255, 255)
				BoxColorGlow["ScaleType"] = Enum.ScaleType.Slice
				BoxColorGlow["ImageTransparency"] = 0
				BoxColorGlow["Selectable"] = true
				BoxColorGlow["Image"] = "rbxassetid://5761504593"
				BoxColorGlow["Name"] = "4pxShadow(2px)"
				BoxColorGlow["Position"] = UDim2.new(0, -15, 0, -15)
				BoxColorGlow["SliceCenter"] = Rect.new(17, 17, 283, 283)
				BoxColorGlow["BackgroundTransparency"] = 1
				BoxColorGlow["Size"] = UDim2.new(1, 30, 1, 30)
				BoxColorGlow["BackgroundColor3"] = Color3.new(1, 1, 1)

				local ColorpickerCorner = Instance.new("UICorner")
				ColorpickerCorner.CornerRadius = UDim.new(0, 6)
				ColorpickerCorner.Name = "ColorpickerCorner"
				ColorpickerCorner.Parent = Colorpicker

				local ColorpickerFrame = Instance.new("Frame")
				ColorpickerFrame.Name = "ColorpickerFrame"
				ColorpickerFrame.Parent = Colorpicker --lel
				ColorpickerFrame.BackgroundColor3 = Color3.fromRGB(23, 20, 46)
				ColorpickerFrame.BorderSizePixel = 0
				ColorpickerFrame.Visible = false
				ColorpickerFrame.ClipsDescendants = true
				ColorpickerFrame.Position = UDim2.new(1, 0,0.3, 0)
				ColorpickerFrame.ZIndex = 104 -- Burada kaldım sikik kod
				ColorpickerFrame.Size = UDim2.new(0, 175, 0, 0)

				local ColorPickerFrameCorner = Instance.new("UICorner")
				ColorPickerFrameCorner.Name = "ColorPickerFrameCorner"
				ColorPickerFrameCorner.CornerRadius = UDim.new(0, 4)
				ColorPickerFrameCorner.Parent = ColorpickerFrame

				local Color = Instance.new("ImageLabel")
				Color.Name = "Color"
				Color.Parent = ColorpickerFrame
				Color.BackgroundColor3 = preset
				Color.BorderSizePixel = 0
				Color.Position = UDim2.new(0, 9, 0, 9)
				Color.Size = UDim2.new(0, 138, 0, 134)
				Color.ZIndex = 104
				Color.Image = "rbxassetid://4155801252"

				local ColorCorner = Instance.new("UICorner")
				ColorCorner.CornerRadius = UDim.new(0, 2)
				ColorCorner.Name = "ColorCorner"
				ColorCorner.Parent = Color

				local ColorSelection = Instance.new("ImageLabel")
				ColorSelection.Name = "ColorSelection"
				ColorSelection.Parent = Color
				ColorSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ColorSelection.ZIndex = 104
				ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				ColorSelection.BackgroundTransparency = 1.000
				ColorSelection.Position = UDim2.new(preset and select(3, Color3.toHSV(preset)))
				ColorSelection.Size = UDim2.new(0, 18, 0, 18)
				ColorSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
				ColorSelection.ScaleType = Enum.ScaleType.Fit

				local Hue = Instance.new("ImageLabel")
				Hue.Name = "Hue"
				Hue.ZIndex = 104
				Hue.Parent = ColorpickerFrame
				Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Hue.Position = UDim2.new(0, 157, 0, 9)
				Hue.Size = UDim2.new(0, 9, 0, 134)

				local HueCorner = Instance.new("UICorner")
				HueCorner.CornerRadius = UDim.new(0, 3)
				HueCorner.Name = "HueCorner"
				HueCorner.Parent = Hue

				local HueGradient = Instance.new("UIGradient")
				HueGradient.Color = ColorSequence.new {ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
				HueGradient.Rotation = 270
				HueGradient.Name = "HueGradient"
				HueGradient.Parent = Hue

				local HueSelection = Instance.new("ImageLabel")
				HueSelection.Name = "HueSelection"
				HueSelection.Parent = Hue
				HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HueSelection.BackgroundTransparency = 1.000
				HueSelection.Position = UDim2.new(0.48, 0, 1 - select(1, Color3.toHSV(preset)))
				HueSelection.Size = UDim2.new(0, 15, 0, 15)
				HueSelection.ZIndex = 105
				HueSelection.Image = "http://www.roblox.com/asset/?id=4805639000"

				local ColorUIStroke = Instance.new("UIStroke")
				ColorUIStroke.Name = "ColorUIStroke"
				ColorUIStroke.Parent = ColorpickerFrame
				ColorUIStroke.Color = Color3.fromRGB(54, 39, 107)
				ColorUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				ColorUIStroke.LineJoinMode = Enum.LineJoinMode.Round
				ColorUIStroke.Thickness = 1
				ColorUIStroke.Transparency = 0

				local function UpdateColorPicker(nope)
					BoxColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					BoxColorGlow.ImageColor3 = BoxColor.BackgroundColor3
					Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					pcall(callback, BoxColor.BackgroundColor3)
				end

				ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
				ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
				ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

				BoxColor.BackgroundColor3 = preset
				BoxColorGlow.ImageColor3 = preset
				Color.BackgroundColor3 = preset
				pcall(callback, BoxColor.BackgroundColor3)

				Color.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then
							ColorInput:Disconnect()
						end
						ColorInput = RunService.RenderStepped:Connect(function()
							local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
							ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = ColorX
							ColorV = 1 - ColorY
							UpdateColorPicker(true)
						end)
					end
				end)
				Color.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then
							ColorInput:Disconnect()
						end
					end
				end)
				Hue.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then
							HueInput:Disconnect()
						end
						HueInput = RunService.RenderStepped:Connect(function()
							local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
							HueSelection.Position = UDim2.new(0.48, 0, HueY, 0)
							ColorH = 1 - HueY
							UpdateColorPicker(true)
						end)
					end
				end)
				Hue.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then
							HueInput:Disconnect()
						end
					end
				end)
				local function colorpickerToggleOFF()
					if ColorpickerFrame.Visible == true then
						ColorPickerToggled = not ColorPickerToggled
						ColorpickerFrame:TweenSize(UDim2.new(0, 175, 0, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.2,true)
						repeat wait() until ColorpickerFrame.Size == UDim2.new(0, 175, 0, 0)
						ColorpickerFrame.Visible = false
						ColorPickerToggled = false
					end
				end

				local color_init = false
				local in_out = false
				ColorpickerFrame.MouseEnter:Connect(function()
					LibraryFunctions:Tween(ColorUIStroke, {Color = Color3.fromRGB(87, 64, 198)}, 0.2)
					color_init = true
				end)

				ColorpickerFrame.MouseLeave:Connect(function()
					LibraryFunctions:Tween(ColorUIStroke, {Color = Color3.fromRGB(54, 39, 107)}, 0.2)
					color_init = false
				end)
				ColorpickerFrame.MouseEnter:Connect(function()
					in_out = true
				end)
				ColorpickerFrame.MouseLeave:Connect(function()
					in_out = false
				end)

				UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
						if ColorpickerFrame.Visible == true and not color_init and not in_out then
							colorpickerToggleOFF()
						end
					end
				end)
				Colorpicker.MouseButton1Click:Connect(function()
					if not ColorpickerFrame.Visible == true then
						if ColorPickerToggled == false then
							ColorPickerToggled = not ColorPickerToggled -- {0, 175},{0, 156}
							ColorpickerFrame.Visible = true
							ColorpickerFrame:TweenSize(UDim2.new(0, 175, 0, 156),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.2,true)
							repeat wait() until ColorpickerFrame.Size == UDim2.new(0, 175, 0, 156)
						else
							ColorPickerToggled = not ColorPickerToggled
							ColorpickerFrame:TweenSize(UDim2.new(0, 175, 0, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.2,true)
							repeat wait() until ColorpickerFrame.Size == UDim2.new(0, 175, 0, 0)
							ColorpickerFrame.Visible = false
						end
					end
				end)
				if side == 'Left' then
					Colorpicker.Parent = Left
				elseif side == 'Right' then
					Colorpicker.Parent = Right
				else
					Colorpicker:Destroy()
					print('please select a side for the ' .. text .. ' colorpicker')
				end
			end

			function items:Button(side, text, callback, callback_2, prompttitle, promptmessage)
				assert(type(callback) == 'function', 'callback must be a function')
				local Button = Instance.new("Frame")
				Button.Name = text or ''
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.BackgroundTransparency = 1.000
				Button.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(1, 0, 0, 36)
				Button.Parent = side == 'Left' and Left or Right

				local ButtonOutline = Instance.new("UIStroke")
				ButtonOutline.Enabled = true
				ButtonOutline.Parent = Button
				ButtonOutline.Color = Color3.fromRGB(31, 26, 61)
				ButtonOutline.LineJoinMode = Enum.LineJoinMode.Miter
				ButtonOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				ButtonOutline.Thickness = 1
				ButtonOutline.Transparency = 1

				local ButtonFrame = Instance.new("TextButton")
				ButtonFrame.Name = "ButtonFrame"
				ButtonFrame.Parent = Button
				ButtonFrame.AnchorPoint = Vector2.new(1, 0.5)
				ButtonFrame.BackgroundColor3 = Color3.fromRGB(34, 28, 64)
				ButtonFrame.Position = UDim2.new(1, -12, 0.5, 0)
				ButtonFrame.Size = UDim2.new(1, -33, 0, 22)
				ButtonFrame.Font = Enum.Font.GothamMedium
				ButtonFrame.Text = text
				ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
				ButtonFrame.TextSize = 12.000
				ButtonFrame.TextXAlignment = Enum.TextXAlignment.Center
				ButtonFrame.AutoButtonColor = false

				local ButtonFrameCorner = Instance.new("UICorner")
				ButtonFrameCorner.CornerRadius = UDim.new(0, 3)
				ButtonFrameCorner.Name = "ButtonFrameCorner"
				ButtonFrameCorner.Parent = ButtonFrame

				local ButtonUIStroke = Instance.new("UIStroke")
				ButtonUIStroke.Color = Color3.fromRGB(107, 89, 222)
				ButtonUIStroke.Thickness = 0.800000011920929
				ButtonUIStroke.Parent = ButtonFrame
				ButtonUIStroke.LineJoinMode = Enum.LineJoinMode.Round
				ButtonUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				local ButtonUICorner = Instance.new("UICorner")
				ButtonUICorner.CornerRadius = UDim.new(0, 9)
				ButtonUICorner.Parent = ButtonFrame

				ButtonFrame.MouseButton1Click:Connect(function()
					if promptmessage ~= nil then
						PromptText.Text = promptmessage
						PromptTitle.Text = prompttitle or "testt"
						PromptContainer.Visible = true

						local c_yes
						local c_no

						c_yes = PromptYesButton.MouseButton1Click:Connect(function()
							c_yes:Disconnect()
							c_no:Disconnect()
							PromptContainer.Visible = false
							callback()
						end)

						c_no = PromptNoButton.MouseButton1Click:Connect(function()
							c_yes:Disconnect()
							c_no:Disconnect()
							PromptContainer.Visible = false
							callback_2()
						end)

						return
					end
					callback()
				end)

				ButtonFrame.MouseEnter:Connect(function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(42, 34, 80)}):Play()
					TweenService:Create(ButtonUIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.fromRGB(76, 70, 115)}):Play()
				end)

				ButtonFrame.MouseLeave:Connect(function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(34, 28, 64)}):Play()
					TweenService:Create(ButtonUIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.fromRGB(107, 89, 222)}):Play()
				end)

				ButtonFrame.MouseButton1Down:Connect(function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(91, 73, 143)}):Play()
				end)

				ButtonFrame.MouseButton1Up:Connect(function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(42, 34, 80)}):Play()
				end)

			end

			function items:Bind(side, text, mode, callback)
				local BindContainer = Instance.new("Frame")
				BindContainer.Name = tostring(text)
				BindContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BindContainer.BackgroundTransparency = 1.000
				BindContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
				BindContainer.BorderSizePixel = 0
				BindContainer.Size = UDim2.new(1, 0, 0, 36)

				local BindOutline = Instance.new("UIStroke")
				BindOutline.Enabled = true
				BindOutline.Parent = BindContainer
				BindOutline.Color = Color3.fromRGB(31, 26, 61)
				BindOutline.LineJoinMode = Enum.LineJoinMode.Miter
				BindOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				BindOutline.Thickness = 1
				BindOutline.Transparency = 1

				local BindTitle = Instance.new("TextLabel")
				BindTitle.Name = "BindTitle"
				BindTitle.Parent = BindContainer
				BindTitle.AnchorPoint = Vector2.new(1, 0.5)
				BindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BindTitle.BackgroundTransparency = 1.000
				BindTitle.Position = UDim2.new(1, 0, 0.5, 0)
				BindTitle.Size = UDim2.new(1, -21, 1, 0)
				BindTitle.Font = Enum.Font.GothamMedium
				BindTitle.Text = text
				BindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				BindTitle.TextSize = 12.000
				BindTitle.TextXAlignment = Enum.TextXAlignment.Left

				local KeybindFrame = Instance.new("Frame")
				KeybindFrame.Name = "KeybindFrame"
				KeybindFrame.Parent = BindContainer
				KeybindFrame.AnchorPoint = Vector2.new(1, 0.5)
				KeybindFrame.BackgroundColor3 = Color3.fromRGB(34, 28, 64)
				KeybindFrame.BackgroundTransparency = 0.450
				KeybindFrame.Position = UDim2.new(1, -12, 0.5, 0)
				KeybindFrame.Size = UDim2.new(0, 50, 0, 22)

				local KeybindFrameStroke = Instance.new("UIStroke")
				KeybindFrameStroke.Enabled = true
				KeybindFrameStroke.Parent = KeybindFrame
				KeybindFrameStroke.Color = Color3.fromRGB(54, 39, 107)
				KeybindFrameStroke.LineJoinMode = Enum.LineJoinMode.Round
				KeybindFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				KeybindFrameStroke.Thickness = 0.7
				KeybindFrameStroke.Transparency = 0

				local KeybindFrameCorner = Instance.new("UICorner")
				KeybindFrameCorner.CornerRadius = UDim.new(0, 2)
				KeybindFrameCorner.Name = "KeybindFrameCorner"
				KeybindFrameCorner.Parent = KeybindFrame

				local KeybindKeytext = Instance.new("TextLabel")
				KeybindKeytext.Name = "KeybindKeytext"
				KeybindKeytext.Parent = KeybindFrame
				KeybindKeytext.AnchorPoint = Vector2.new(0.5, 0.5)
				KeybindKeytext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeybindKeytext.BackgroundTransparency = 1.000
				KeybindKeytext.ClipsDescendants = true
				KeybindKeytext.Position = UDim2.new(.5, 0, 0.5, 0)
				KeybindKeytext.Size = UDim2.new(0, 180, 1, 0)
				KeybindKeytext.Font = Enum.Font.GothamMedium
				KeybindKeytext.Text = text
				KeybindKeytext.TextColor3 = Color3.fromRGB(255, 255, 255)
				KeybindKeytext.TextSize = 12.000
				KeybindKeytext.TextXAlignment = Enum.TextXAlignment.Center

				local Interaction = Instance.new('TextButton')
				Interaction.Size = UDim2.new(1,0,1,0)
				Interaction.Parent = BindContainer
				Interaction.Transparency = 1
				Interaction.TextTransparency = 1

				local uis = UserInputService
				local binding = false
				local state = false
				local key = 'none'

				local mousenames = {
					[Enum.UserInputType.MouseButton1] = 'MB1',
					[Enum.UserInputType.MouseButton2] = 'MB2',
					[Enum.UserInputType.MouseButton3] = 'MB3',
				}

				function set_key(keycode)
					key = keycode == nil and 'none' or keycode

					local name = 'none'
					if mousenames[key] ~= nil then
						name = mousenames[key]
					elseif key ~= nil and key.Name ~= nil then
						name = key.Name
					end

					KeybindKeytext.Text = tostring(name):upper()
					binding = false
				end

				uis.InputBegan:Connect(function(input)
					if binding then return end
					if key == 'none' or key == nil then return end

					if input.KeyCode == key or input.UserInputType == key then
						if mode == 'Toggle' then
							state = not state
							if callback ~= nil then callback(state) end
						elseif mode == 'Hold' then
							local c; c = game:GetService('RunService').RenderStepped:Connect(function(delta)
								if (input.KeyCode == key and not uis:IsKeyDown(key)) or (input.UserInputType == key and not uis:IsMouseButtonPressed(key)) then
									c:Disconnect()
									return
								end
								if callback ~= nil then callback(delta) end
							end)
						end
					end
				end)

				Interaction.MouseButton1Click:Connect(function()
					if binding then return end

					binding = true

					KeybindKeytext.Text = '. . .'

					local c; c = UserInputService.InputBegan:Connect(function(input)
						local binded = false

						if input.KeyCode == Enum.KeyCode.Backspace then
							set_key(nil)
							binded = true
						elseif mousenames[input.UserInputType] then
							set_key(input.UserInputType)
							binded = true
						elseif input.UserInputType == Enum.UserInputType.Keyboard then
							set_key(input.KeyCode)
							binded = true
						end

						if binded then
							c:Disconnect()
							binding = false
						end
					end)
				end)

				KeybindKeytext:GetPropertyChangedSignal('Text'):Connect(function()
					local size = game:GetService('TextService'):GetTextSize(KeybindKeytext.Text, KeybindKeytext.TextSize, KeybindKeytext.Font, Vector2.new(0,0))
					TweenService:Create(KeybindFrame, TweenInfo.new(0.125), {Size = UDim2.new(0,size.X + 14,0,22)}):Play()
				end)

				KeybindKeytext.Text = 'none'

				if side == 'Left' then
					BindContainer.Parent = Left
				elseif side == 'Right' then
					BindContainer.Parent = Right
				else
					BindContainer:Destroy()
					print('please select a side for the ' .. text .. ' bind')
				end
			end

			function items:Textbox(side, text, placeholdertext, clearafter, callback)
				text = text or "Textbox N/A"
				placeholdertext = placeholdertext or "Write here"
				local TextBoxContainer = Instance.new("Frame")
				TextBoxContainer.Name = tostring(text)
				TextBoxContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBoxContainer.BackgroundTransparency = 1.000
				TextBoxContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
				TextBoxContainer.BorderSizePixel = 0
				TextBoxContainer.Size = UDim2.new(1, 0, 0, 36)

				local TextBoxOutline = Instance.new("UIStroke")
				TextBoxOutline.Enabled = true
				TextBoxOutline.Parent = TextBoxContainer
				TextBoxOutline.Color = Color3.fromRGB(31, 26, 61)
				TextBoxOutline.LineJoinMode = Enum.LineJoinMode.Miter
				TextBoxOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				TextBoxOutline.Thickness = 1
				TextBoxOutline.Transparency = 1

				local TextBoxTitle = Instance.new("TextLabel")
				TextBoxTitle.Name = "TextBoxTitle"
				TextBoxTitle.Parent = TextBoxContainer
				TextBoxTitle.AnchorPoint = Vector2.new(1, 0.5)
				TextBoxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBoxTitle.BackgroundTransparency = 1.000
				TextBoxTitle.Position = UDim2.new(1, 0, 0.5, 0)
				TextBoxTitle.Size = UDim2.new(1, -21, 1, 0)
				TextBoxTitle.Font = Enum.Font.GothamMedium
				TextBoxTitle.Text = text
				TextBoxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextBoxTitle.TextSize = 12.000
				TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left

				local TextBoxFrame = Instance.new("Frame")
				TextBoxFrame.Name = "TextBoxFrame"
				TextBoxFrame.Parent = TextBoxContainer
				TextBoxFrame.AnchorPoint = Vector2.new(1, 0.5)
				TextBoxFrame.BackgroundColor3 = Color3.fromRGB(34, 28, 64)
				TextBoxFrame.Position = UDim2.new(1, -12, 0.5, 0)
				TextBoxFrame.Size = UDim2.new(0, 115, 0, 19)

				local TextboxFrameCorner = Instance.new("UICorner")
				TextboxFrameCorner.CornerRadius = UDim.new(0, 2)
				TextboxFrameCorner.Name = "TextboxFrameCorner"
				TextboxFrameCorner.Parent = TextBoxFrame

				local Textbox = Instance.new("TextBox")
				Textbox.Name = "Textbox"
				Textbox.Parent = TextBoxFrame
				Textbox.BackgroundTransparency = 1.000
				Textbox.Size = UDim2.new(1, 0, 1, 0)
				Textbox.Font = Enum.Font.GothamMedium
				Textbox.PlaceholderText = placeholdertext
				Textbox.Text = ""
				Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
				Textbox.TextSize = 12
				Textbox.TextWrapped = true

				local TextboxUIStroke = Instance.new("UIStroke")
				TextboxUIStroke.Color = Color3.fromRGB(121, 121, 124)
				TextboxUIStroke.Parent = TextBoxFrame
				TextboxUIStroke.Thickness = 0.7
				TextboxUIStroke.Transparency = 0.17

				Textbox.Focused:Connect(function()
					TextBoxFrame:TweenSize(UDim2.new(0, 125, 0, 19),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.1,true)
					TweenService:Create(TextboxUIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.fromRGB(200, 200, 200)}):Play()
				end)
				TextBoxFrame.MouseEnter:Connect(function()
					TweenService:Create(TextboxUIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.fromRGB(200, 200,200)}):Play()
				end)

				TextBoxFrame.MouseLeave:Connect(function()
					TweenService:Create(TextboxUIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.fromRGB(121, 121, 124)}):Play()
				end)
				Textbox.FocusLost:Connect(function(ep)
					if ep then
						if #Textbox.Text > 0 then
							pcall(callback, Textbox.Text)
							TextBoxFrame:TweenSize(UDim2.new(0, 115, 0, 19),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.1, true)
							if clearafter then
								Textbox.Text = ""
							end
						end
					end
				end)
				if side == 'Left' then
					TextBoxContainer.Parent = Left
				elseif side == 'Right' then
					TextBoxContainer.Parent = Right
				else
					TextBoxContainer:Destroy()
					print('please select a side for the ' .. text .. ' textbox')
				end
			end

			function items:Slider(side, text, start, min, max, inc, callback)
				local dragging = false
				--start = start or min --or 5
				local Slider = Instance.new("Frame")
				Slider.Name = tostring(text)
				Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Slider.BackgroundTransparency = 1.000
				Slider.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Slider.BorderSizePixel = 0
				Slider.Size = UDim2.new(1, 0, 0, 36)

				local SliderOutline = Instance.new("UIStroke")
				SliderOutline.Enabled = true
				SliderOutline.Parent = Slider
				SliderOutline.Color = Color3.fromRGB(31, 26, 61)
				SliderOutline.LineJoinMode = Enum.LineJoinMode.Miter
				SliderOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				SliderOutline.Thickness = 1
				SliderOutline.Transparency = 1

				local SliderTitle = Instance.new("TextLabel")
				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Slider
				SliderTitle.AnchorPoint = Vector2.new(0, 0.5)
				SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.BackgroundTransparency = 1.000
				SliderTitle.ClipsDescendants = true
				SliderTitle.Position = UDim2.new(0, 21, 0.5, 0)
				SliderTitle.Size = UDim2.new(0, 180, 1, 0)
				SliderTitle.Font = Enum.Font.GothamMedium
				SliderTitle.Text = text
				SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.TextSize = 12.000
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

				local SlideBack = Instance.new("Frame")
				SlideBack.Name = "SlideBack"
				SlideBack.Parent = Slider
				SlideBack.AnchorPoint = Vector2.new(1, 0.5)
				SlideBack.BackgroundColor3 = Color3.fromRGB(33, 28, 64)
				SlideBack.BorderSizePixel = 0
				SlideBack.Position = UDim2.new(1, -62, 0.5, 0)
				SlideBack.Size = UDim2.new(0, 130, 0, 2)

				local SlideCircle = Instance.new("Frame")
				SlideCircle.Name = "SlideCircle"
				SlideCircle.Parent = SlideBack
				SlideCircle.AnchorPoint = Vector2.new(0.5, 0.5)
				SlideCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SlideCircle.Position = UDim2.new(0, 0, 0.5, 0)
				SlideCircle.Size = UDim2.new(0, 12, 0, 12)
				SlideCircle.ZIndex = 2

				local SlideCircleCorner = Instance.new("UICorner")
				SlideCircleCorner.CornerRadius = UDim.new(1, 0)
				SlideCircleCorner.Name = "SlideCircleCorner"
				SlideCircleCorner.Parent = SlideCircle

				local SlideBackLight = Instance.new("Frame")
				SlideBackLight.Name = "SlideBackLight"
				SlideBackLight.Parent = SlideBack
				SlideBackLight.AnchorPoint = Vector2.new(0, 0.5)
				SlideBackLight.BackgroundColor3 = Color3.fromRGB(107, 89, 222)
				SlideBackLight.BorderSizePixel = 0
				SlideBackLight.Position = UDim2.new(0, 0, 0.5, 0)
				SlideBackLight.Size = UDim2.new(0, 0, 0, 2)

				local SlideBackLightCorner = Instance.new("UICorner")
				SlideBackLightCorner.CornerRadius = UDim.new(1, 0)
				SlideBackLightCorner.Name = "SlideBackLightCorner"
				SlideBackLightCorner.Parent = SlideBackLight

				local SliderValue = Instance.new("TextBox")
				SliderValue.Name = "SliderValue"
				SliderValue.Parent = Slider
				SliderValue.BackgroundColor3 = Color3.fromRGB(61, 34, 134)
				SliderValue.BackgroundTransparency = 0.810
				SliderValue.Position = UDim2.new(0.797999978, 21, 0.222000003, 0)
				SliderValue.Size = UDim2.new(0, 27, 0, 16)
				SliderValue.Font = Enum.Font.Gotham
				SliderValue.Text = min
				SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderValue.TextSize = 12
				SliderValue.TextXAlignment = Enum.TextXAlignment.Center
				SliderValue.TextWrapped = true

				local SliderValCorner = Instance.new("UICorner")
				SliderValCorner.CornerRadius = UDim.new(0, 3)
				SliderValCorner.Parent = SliderValue

				local SliderValStroke = Instance.new("UIStroke")
				SliderValStroke.Enabled = true
				SliderValStroke.Parent = SliderValue
				SliderValStroke.Color = Color3.fromRGB(54, 39, 107)
				SliderValStroke.LineJoinMode = Enum.LineJoinMode.Round
				SliderValStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				SliderValStroke.Thickness = 1
				SliderValStroke.Transparency = 0.4

				if side == 'Left' then
					Slider.Parent = Left
				elseif side == 'Right' then
					Slider.Parent = Right
				else
					Slider:Destroy()
					print('please select a side for the ' .. text .. ' slider')
				end

				local function move(Input)
					local XSize = math.clamp((Input.Position.X - SlideBack.AbsolutePosition.X) / SlideBack.AbsoluteSize.X, 0, 1)
					local Increment = inc and (max / ((max - min) / (inc * 4))) or (max >= 50 and max / ((max - min) / 4)) or (max >= 25 and max / ((max - min) / 2)) or (max / (max - min))
					local SizeRounded = UDim2.new((math.round(XSize * ((max / Increment) * 4)) / ((max / Increment) * 4)), 0, 0, 2)
					local PosRoundedCircle = UDim2.new((math.round(XSize * ((max / Increment) * 4)) / ((max / Increment) * 4)), 0, 0.5, 0)
					SlideBackLight:TweenSize(SizeRounded, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
					SlideCircle:TweenPosition(PosRoundedCircle, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
					local Val = math.round((((SizeRounded.X.Scale * max) / max) * (max - min) + min) * 20) / 20
					SliderValue.Text = tostring(Val)
					pcall(callback, tonumber(Val))
				end
				local cfg = {Value = start}
				function SetStart(val)
					local a = math.floor(tostring(val and (val / max) * (max - min) + min) or 0)
					SlideCircle.Position = UDim2.new((val or 0) / max, 0, 1, 0)
					--[[ with animation:SlideBackLight:TweenSize(UDim2.new((val or 0) / max, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 3, true) / SlideCircle:TweenPosition(UDim2.new((val or 0) / max, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 3, true)]]
					SlideBackLight.Size = UDim2.new((val or 0) / max, 0, 1, 0)
					SliderValue.Text = tostring(cfg.Value)
					cfg.Value = val
					return pcall(callback, tonumber(cfg.Value))
				end
				SetStart(start)

				SlideCircle.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						move(input)
					end
				end)
				SlideCircle.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						move(input)
					end
				end)
				SlideBack.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						move(input)
					end
				end)
				SlideBack.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						move(input)
					end
				end)
				SlideBackLight.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						move(input)
					end
				end)
				SlideBackLight.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						move(input)
					end
				end)
				game:GetService("UserInputService").InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						move(input)
					end
				end)
				SliderValue.FocusLost:Connect(function(ep)
					if ep then
						if (tonumber(SliderValue.Text) > max) then SliderValue.Text = tostring(max) pcall(callback, tostring(SliderValue.Text))TweenService:Create(SlideBackLight,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Size = UDim2.new((tonumber(SliderValue.Text)) / max, 0, 0, 2)}):Play()
						else pcall(callback, tostring(SliderValue.Text))
							TweenService:Create(SlideBackLight,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Size = UDim2.new((tonumber(SliderValue.Text)) / max, 0, 0, 2)}):Play() end
						if (tonumber(SliderValue.Text) < min) then SliderValue.Text = tostring(min) pcall(callback, tostring(SliderValue.Text))
							TweenService:Create(SlideBackLight,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Size = UDim2.new((tonumber(SliderValue.Text)) / max, 0, 0, 2)}):Play()
						else pcall(callback, tostring(SliderValue.Text)) TweenService:Create(SlideBackLight,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Size = UDim2.new((tonumber(SliderValue.Text)) / max, 0, 0, 2)}):Play() end
						if (tonumber(SliderValue.Text) <= min) then pcall(callback, tostring(SliderValue.Text))
							TweenService:Create(SlideBackLight,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Size = UDim2.new(0, 0, 0, 3)}):Play()
						end
						--circle slide
						if (tonumber(SliderValue.Text) > max)  then
							SliderValue.Text = tostring(max)
							TweenService:Create(SlideCircle,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Position = UDim2.new((tonumber(SliderValue.Text)) / max, 0, 0, 2)}):Play()
						else TweenService:Create(SlideCircle,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Position = UDim2.new((tonumber(SliderValue.Text)) / max, 0, 0, 2)}):Play() end
						if (tonumber(SliderValue.Text) < min) then SliderValue.Text = tostring(min)
							TweenService:Create(SlideCircle,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Position = UDim2.new((tonumber(SliderValue.Text)) / max, 0, 0, 2)}):Play()
						else TweenService:Create(SlideCircle,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Position = UDim2.new((tonumber(SliderValue.Text)) / max, 0, 0, 2)}):Play() end
						if (tonumber(SliderValue.Text) <= min) then TweenService:Create(SlideCircle,TweenInfo.new(.3, Enum.EasingStyle.Quad),{Position = UDim2.new(0, 0, 0, 3)}):Play() end
					end
				end)
			end

			function items:Dropdown(side, text, default, options, cb, multi)
				local opened = false
				assert(type(options) == "table", "options must be a table")
				assert(type(cb) == "function", "callback must be a function")

				local Dropdown = Instance.new("Frame")
				Dropdown.Name = text or ''
				Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dropdown.BackgroundTransparency = 1.000
				Dropdown.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Dropdown.BorderSizePixel = 0
				Dropdown.Size = UDim2.new(1, 0, 0, 36)

				local DropdownOutline = Instance.new("UIStroke")
				DropdownOutline.Enabled = true
				DropdownOutline.Parent = Dropdown
				DropdownOutline.Color = Color3.fromRGB(31, 26, 61)
				DropdownOutline.LineJoinMode = Enum.LineJoinMode.Miter
				DropdownOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				DropdownOutline.Thickness = 1
				DropdownOutline.Transparency = 1

				local DropdownTitle = Instance.new("TextLabel")
				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = Dropdown
				DropdownTitle.AnchorPoint = Vector2.new(0, 0.5)
				DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownTitle.BackgroundTransparency = 1.000
				DropdownTitle.ClipsDescendants = true
				DropdownTitle.Position = UDim2.new(0, 21, 0.5, 0)
				DropdownTitle.Size = UDim2.new(0, 180, 1, 0)
				DropdownTitle.Font = Enum.Font.GothamMedium
				DropdownTitle.Text = text
				DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownTitle.TextSize = 12.000
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

				local DropdownDropFrame = Instance.new("Frame")
				DropdownDropFrame.Name = "DropdownDropFrame"
				DropdownDropFrame.Parent = Dropdown
				DropdownDropFrame.AnchorPoint = Vector2.new(1, 0.5)
				DropdownDropFrame.BackgroundColor3 = Color3.fromRGB(34, 28, 64)
				DropdownDropFrame.Position = UDim2.new(1, -12, 0.5, 0)
				DropdownDropFrame.Size = UDim2.new(0, 173, 0, 22)

				local DropdownDropFrameCorner = Instance.new("UICorner")
				DropdownDropFrameCorner.CornerRadius = UDim.new(0, 2)
				DropdownDropFrameCorner.Name = "DropdownDropFrameCorner"
				DropdownDropFrameCorner.Parent = DropdownDropFrame

				local DropdownInteract = Instance.new("TextButton")
				DropdownInteract.Name = "DropdownInteract"
				DropdownInteract.Parent = DropdownDropFrame
				DropdownInteract.AnchorPoint = Vector2.new(0, 0.5)
				DropdownInteract.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				DropdownInteract.BorderColor3 = Color3.fromRGB(27, 42, 53)
				DropdownInteract.Position = UDim2.new(0, 0, 0.5, 0)
				DropdownInteract.Size = UDim2.new(1, 0, 1, 0)
				DropdownInteract.AutoButtonColor = false
				DropdownInteract.Font = Enum.Font.SourceSans
				DropdownInteract.Text = ""
				DropdownInteract.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropdownInteract.TextSize = 14.000
				DropdownInteract.BackgroundTransparency = 1

				local DropdownDropFrameArrowHolder = Instance.new("Frame")
				DropdownDropFrameArrowHolder.Name = "DropdownDropFrameArrowHolder"
				DropdownDropFrameArrowHolder.Parent = DropdownDropFrame
				DropdownDropFrameArrowHolder.AnchorPoint = Vector2.new(1, 0.5)
				DropdownDropFrameArrowHolder.BackgroundColor3 = Color3.fromRGB(107, 89, 222)
				DropdownDropFrameArrowHolder.Position = UDim2.new(1, -2, 0.5, 0)
				DropdownDropFrameArrowHolder.Size = UDim2.new(0, 14, 0, 16)

				local DropdownDropFrameArrowHolderCorner = Instance.new("UICorner")
				DropdownDropFrameArrowHolderCorner.CornerRadius = UDim.new(0, 4)
				DropdownDropFrameArrowHolderCorner.Name = "DropdownDropFrameArrowHolderCorner"
				DropdownDropFrameArrowHolderCorner.Parent = DropdownDropFrameArrowHolder

				local DropdownArrow = Instance.new("ImageLabel")
				DropdownArrow.Name = "DropdownArrow"
				DropdownArrow.Parent = DropdownDropFrameArrowHolder
				DropdownArrow.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownArrow.BackgroundTransparency = 1.000
				DropdownArrow.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownArrow.Size = UDim2.new(1, 0, 1, 0)
				DropdownArrow.Image = "rbxassetid://10125383411"

				local DropdownSelected = Instance.new("TextLabel")
				DropdownSelected.Name = "DropdownSelected"
				DropdownSelected.Parent = DropdownDropFrame
				DropdownSelected.AnchorPoint = Vector2.new(0, 0.5)
				DropdownSelected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.BackgroundTransparency = 1.000
				DropdownSelected.ClipsDescendants = false
				DropdownSelected.Position = UDim2.new(0, 4, 0.5, 0)
				DropdownSelected.Size = UDim2.new(1, -24, 1, 0)
				DropdownSelected.Visible = true
				DropdownSelected.Font = Enum.Font.Gotham
				DropdownSelected.Text = string.format(default)
				DropdownSelected.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.TextSize = 12.000
				DropdownSelected.TextXAlignment = Enum.TextXAlignment.Left

				local DropdownChildFrameOutline = Instance.new("Frame")
				DropdownChildFrameOutline.Name = "DropdownChildFrame"
				DropdownChildFrameOutline.Parent = DropdownDropFrame
				DropdownChildFrameOutline.AnchorPoint = Vector2.new(0.5, 0)
				DropdownChildFrameOutline.BackgroundColor3 = Color3.fromRGB(34, 28, 64)
				DropdownChildFrameOutline.Position = UDim2.new(0.5, 0, 0, 0)
				DropdownChildFrameOutline.Size = UDim2.new(1, 0, 0, 100)
				DropdownChildFrameOutline.BackgroundTransparency = 1
				DropdownChildFrameOutline.Visible = false
				DropdownChildFrameOutline.ZIndex = 99

				local DropdownChildFrameOutlineCorner = Instance.new("UICorner")
				DropdownChildFrameOutlineCorner.CornerRadius = UDim.new(0, 4)
				DropdownChildFrameOutlineCorner.Name = "DropdownChildFrameOutlineCorner"
				DropdownChildFrameOutlineCorner.Parent = DropdownChildFrameOutline

				local DropdownChildFrame = Instance.new("Frame")
				DropdownChildFrame.Name = "DropdownChildFrame"
				DropdownChildFrame.Parent = DropdownChildFrameOutline
				DropdownChildFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownChildFrame.BackgroundColor3 = Color3.fromRGB(22, 20, 45)
				DropdownChildFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownChildFrame.Size = UDim2.new(1, -2, 1, -2)
				DropdownChildFrame.BackgroundTransparency = 1
				DropdownChildFrame.ZIndex = 99

				local DropdownChildFrameCorner = Instance.new("UICorner")
				DropdownChildFrameCorner.CornerRadius = UDim.new(0, 4)
				DropdownChildFrameCorner.Name = "DropdownChildFrameCorner"
				DropdownChildFrameCorner.Parent = DropdownChildFrame

				local DropdownChildFrameScroll = Instance.new("ScrollingFrame")
				DropdownChildFrameScroll.Name = "DropdownChildFrameScroll"
				DropdownChildFrameScroll.Parent = DropdownChildFrame
				DropdownChildFrameScroll.Active = true
				DropdownChildFrameScroll.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownChildFrameScroll.BackgroundColor3 = Color3.fromRGB(33, 28, 64)
				DropdownChildFrameScroll.BackgroundTransparency = 1.000
				DropdownChildFrameScroll.BorderSizePixel = 0
				DropdownChildFrameScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownChildFrameScroll.Size = UDim2.new(1, 0, 1, -8)
				DropdownChildFrameScroll.ScrollBarThickness = 0
				DropdownChildFrameScroll.ZIndex = 99

				local DropdownChildFrameScrollListing = Instance.new("UIListLayout")
				DropdownChildFrameScrollListing.Name = "DropdownChildFrameScrollListing"
				DropdownChildFrameScrollListing.Parent = DropdownChildFrameScroll
				DropdownChildFrameScrollListing.HorizontalAlignment = Enum.HorizontalAlignment.Center
				DropdownChildFrameScrollListing.SortOrder = Enum.SortOrder.LayoutOrder
				DropdownChildFrameScrollListing.Padding = UDim.new(0, 1)

				DropdownChildFrameScrollListing:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					DropdownChildFrameScroll.CanvasSize = UDim2.new(0, 0, 0, DropdownChildFrameScrollListing.AbsoluteContentSize.Y)
				end)

				DropdownInteract.MouseEnter:Connect(function()
					TweenService:Create(DropdownDropFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(42, 34, 80)}):Play()
				end)
				DropdownInteract.MouseLeave:Connect(function()
					TweenService:Create(DropdownDropFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(34, 28, 64)}):Play()
				end)

				local debounce = false
				local opened

				local function toggle()
					DropdownChildFrameOutline.Visible = true
					if (debounce) then return end

					opened = not opened

					if (not opened) then
						debounce = true
					end

					local tween = TweenService:Create(DropdownChildFrame, TweenInfo.new(.2), {BackgroundTransparency = opened and 0 or 1})
					TweenService:Create(DropdownChildFrameOutline, TweenInfo.new(.2), {BackgroundTransparency = opened and 0 or 1}):Play()
					for i,v in next, DropdownChildFrameScroll:GetDescendants() do
						if v:IsA('TextButton') then
							game.TweenService:Create(v, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = opened and 0 or 1}):Play()
						end
						if v:IsA('TextLabel') then
							game.TweenService:Create(v, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = opened and 0 or 1}):Play()
						end
						if v:IsA('ImageLabel') then
							game.TweenService:Create(v, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = opened and 0 or 1}):Play()
						end
					end

					tween:Play()
					if (not opened) then
						wait(.2)
						debounce = false
					end

					DropdownChildFrame.Visible = opened
				end

				local function dropdownoff()
					if DropdownChildFrame.Visible == true then
						opened = true
						debounce = false
						local tween = TweenService:Create(DropdownChildFrame, TweenInfo.new(.2), {BackgroundTransparency = 1})
						TweenService:Create(DropdownChildFrameOutline, TweenInfo.new(.2), {BackgroundTransparency = 1}):Play()
						for i,v in next, DropdownChildFrameScroll:GetDescendants() do
							if v:IsA('TextButton') then
								game.TweenService:Create(v, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
							end
							if v:IsA('TextLabel') then
								game.TweenService:Create(v, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
							end
							if v:IsA('ImageLabel') then
								game.TweeanService:Create(v, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
							end
						end
						tween:Play()
						opened = false
						debounce = false
						DropdownChildFrame.Visible = false
					end
				end

				DropdownInteract.InputBegan:Connect(function(inp)
					if (inp.UserInputType == Enum.UserInputType.MouseButton1) then
						toggle()
					end
				end)

				local in_drop = false
				local in_drop2 = false
				DropdownInteract.MouseEnter:Connect(function()
					in_drop = true
				end)
				DropdownInteract.MouseLeave:Connect(function()
					in_drop = false
				end)
				DropdownChildFrameScroll.MouseEnter:Connect(function()
					in_drop2 = true
				end)
				DropdownChildFrameScroll.MouseLeave:Connect(function()
					in_drop2 = false
				end)
				UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
						if DropdownChildFrameScroll.Visible == true and not in_drop and not in_drop2 then
							dropdownoff()
							--DropdownScroll.Visible = false
							--DropdownScroll.CanvasPosition = Vector2.new(0,0)
						end
					end
				end)

				local pressed = false
				for _, opt in next, options do
					local DropdownBtn = Instance.new("TextButton")
					DropdownBtn.Name = "DropdownBtn"
					DropdownBtn.Parent = DropdownChildFrameScroll
					DropdownBtn.BackgroundColor3 = Color3.fromRGB(22, 20, 45)
					DropdownBtn.Size = UDim2.new(1, -8, 0, 22)
					DropdownBtn.Font = Enum.Font.SourceSans
					DropdownBtn.Text = ""
					DropdownBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
					DropdownBtn.TextSize = 14.000
					DropdownBtn.AutoButtonColor = false
					DropdownBtn.BackgroundTransparency = 1
					DropdownBtn.ZIndex = 99

					local DropdownBtnTitle = Instance.new("TextLabel")
					DropdownBtnTitle.Name = "DropdownBtnTitle"
					DropdownBtnTitle.Parent = DropdownBtn
					DropdownBtnTitle.AnchorPoint = Vector2.new(1, 0.5)
					DropdownBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					DropdownBtnTitle.BackgroundTransparency = 1.000
					DropdownBtnTitle.ClipsDescendants = true
					DropdownBtnTitle.Position = UDim2.new(1, 0, 0.5, 0)
					DropdownBtnTitle.Size = UDim2.new(1, -6, 1, 0)
					DropdownBtnTitle.Font = Enum.Font.Gotham
					DropdownBtnTitle.Text = tostring(opt)
					DropdownBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
					DropdownBtnTitle.TextSize = 12.000
					DropdownBtnTitle.TextXAlignment = Enum.TextXAlignment.Left
					DropdownBtnTitle.TextTransparency = 1
					DropdownBtnTitle.ZIndex = 99

					local DropdownBtnCorner = Instance.new("UICorner")
					DropdownBtnCorner.CornerRadius = UDim.new(0, 4)
					DropdownBtnCorner.Name = "DropdownBtnCorner"
					DropdownBtnCorner.Parent = DropdownBtn

					DropdownBtn.MouseButton1Click:Connect(function()
						if (pressed) then return end
						pressed = true
						DropdownSelected.Text = string.format(opt)
						coroutine.wrap(cb)(opt)
						toggle()
						pressed = false
					end)
					DropdownBtn.MouseEnter:Connect(function()
						TweenService:Create(DropdownBtn, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(107, 89, 222)}):Play()
					end)
					DropdownBtn.MouseLeave:Connect(function()
						TweenService:Create(DropdownBtn, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(22, 20, 45)}):Play()
					end)
				end

				if side == 'Left' then
					Dropdown.Parent = Left
				elseif side == 'Right' then
					Dropdown.Parent = Right
				else
					Dropdown:Destroy()
					print('please select a side for the ' .. text .. ' dropdown')
				end
			end


			---SEARCH BAR FUNCTION---
			local function Refresh()
				local entry = string.lower(SearchBox.Text)
				for i,v in pairs(Left:GetChildren()) do
					if v:IsA("Frame") then
						if entry ~= "" then
							local Script = string.lower(v.Name)
							if string.find(Script, entry) then
								v.Visible = true
							else
								v.Visible = false
							end
						else
							v.Visible = true
						end
					end
				end
				for i,v in pairs(Right:GetChildren()) do
					if v:IsA("Frame") then
						if entry ~= "" then
							local Script = string.lower(v.Name)
							if string.find(Script, entry) then
								v.Visible = true
							else
								v.Visible = false
							end
						else
							v.Visible = true
						end
					end
				end
			end
			SearchBox.Changed:Connect(Refresh)
			---JUST STUFF---
			return items
		end
		return subtabs
	end
	return tabs
end
function lib:Notify(title, desc, dur)
	local Notification = Instance.new("Frame")
	Notification.Name = "Notification"
	Notification.Parent = NotifsHolder
	Notification.BackgroundColor3 = Color3.fromRGB(23, 20, 41)
	Notification.Size = UDim2.new(1, 0, 0, 60)
	Notification.AnchorPoint = Vector2.new(0, 0.5)
	Notification.Position = UDim2.new(1, 20, 0.5, 0)
	Notification.BackgroundTransparency = 1

	local NotificationBack = Instance.new("Frame")
	NotificationBack.Name = "NotificationBack"
	NotificationBack.Parent = Notification
	NotificationBack.BackgroundColor3 = Color3.fromRGB(23, 20, 41)
	NotificationBack.Size = UDim2.new(1, 0, 1, 0)
	NotificationBack.AnchorPoint = Vector2.new(0, 0.5)
	NotificationBack.Position = UDim2.new(1, 20, 0.5, 0)
	NotificationBack.BackgroundTransparency = 1

	local NotificationShadow = Instance.new("ImageLabel")
	NotificationShadow.Name = "NotificationShadow"
	NotificationShadow.Parent = NotificationBack
	NotificationShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NotificationShadow.BackgroundTransparency = 1.000
	NotificationShadow.Position = UDim2.new(0, -15, 0, -15)
	NotificationShadow.Size = UDim2.new(1, 30, 1, 30)
	NotificationShadow.Image = "rbxassetid://6521733637"
	NotificationShadow.ImageColor3 = Color3.fromRGB(21, 19, 37)
	NotificationShadow.ImageTransparency = 0.300
	NotificationShadow.ScaleType = Enum.ScaleType.Slice
	NotificationShadow.SliceCenter = Rect.new(19, 19, 281, 281)

	local NotificationCorner = Instance.new("UICorner")
	NotificationCorner.CornerRadius = UDim.new(0, 4)
	NotificationCorner.Name = "NotificationCorner"
	NotificationCorner.Parent = NotificationBack

	local NotificationLine = Instance.new("Frame")
	NotificationLine.Name = "NotificationLine"
	NotificationLine.Parent = NotificationBack
	NotificationLine.BackgroundColor3 = Color3.fromRGB(31, 26, 61)
	NotificationLine.BorderSizePixel = 0
	NotificationLine.Position = UDim2.new(0, 0, 0, 20)
	NotificationLine.Size = UDim2.new(1, 0, 0, 1)
	NotificationLine.BackgroundTransparency = 1

	local NotificationDurationLine = Instance.new("Frame")
	NotificationDurationLine.Name = "NotificationDurationLine"
	NotificationDurationLine.Parent = NotificationBack
	NotificationDurationLine.BackgroundColor3 = Color3.fromRGB(89, 75, 176)
	NotificationDurationLine.BorderSizePixel = 0
	NotificationDurationLine.Position = UDim2.new(0, 0, 0, 20)
	NotificationDurationLine.Size = UDim2.new(1, 0, 0, 1)
	NotificationDurationLine.BackgroundTransparency = 1

	local NotificationTitle = Instance.new("TextLabel")
	NotificationTitle.Name = "NotificationTitle"
	NotificationTitle.Parent = NotificationBack
	NotificationTitle.AnchorPoint = Vector2.new(0, 0)
	NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NotificationTitle.BackgroundTransparency = 1.000
	NotificationTitle.Position = UDim2.new(0, 10, 0, 0)
	NotificationTitle.Size = UDim2.new(1, -10, 0, 20)
	NotificationTitle.Font = Enum.Font.GothamMedium
	NotificationTitle.Text = title
	NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	NotificationTitle.TextSize = 12.000
	NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
	NotificationTitle.TextTransparency = 1

	local NotificationGlow = Instance.new("ImageLabel")
	NotificationGlow.Name = "NotificationGlow"
	NotificationGlow.Parent = NotificationBack
	NotificationGlow.BackgroundTransparency = 1.000
	NotificationGlow.Position = UDim2.new(0, -15, 0, -15)
	NotificationGlow.Size = UDim2.new(0.995714188, 30, 0.983333349, 30)
	NotificationGlow.ZIndex = 0
	NotificationGlow.Image = "rbxassetid://5028857084"
	NotificationGlow.ImageColor3 = Color3.fromRGB(107, 89, 222)
	NotificationGlow.ScaleType = Enum.ScaleType.Slice
	NotificationGlow.SliceCenter = Rect.new(24, 24, 276, 276)

	local NotificationDesc = Instance.new("TextLabel")
	NotificationDesc.Name = "NotificationDesc"
	NotificationDesc.Parent = NotificationBack
	NotificationDesc.AnchorPoint = Vector2.new(1, 1)
	NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NotificationDesc.BackgroundTransparency = 1.000
	NotificationDesc.Position = UDim2.new(1, 0, 1, 8)
	NotificationDesc.Size = UDim2.new(1, -10, 1, -16)
	NotificationDesc.Font = Enum.Font.Gotham
	NotificationDesc.Text = desc
	NotificationDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
	NotificationDesc.TextSize = 12.000
	NotificationDesc.TextWrapped = true
	NotificationDesc.TextXAlignment = Enum.TextXAlignment.Left
	NotificationDesc.TextYAlignment = Enum.TextYAlignment.Top
	NotificationDesc.TextTransparency = 1

	coroutine.wrap(function()
		for i,v in next, NotificationBack:GetChildren() do
			if v:IsA('Frame') then
				game.TweenService:Create(v, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
			elseif v:IsA('TextLabel') then
				game.TweenService:Create(v, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 0}):Play()
			end
		end
		TweenService:Create(NotificationDurationLine, TweenInfo.new(dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 1)}):Play()
		TweenService:Create(NotificationBack, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0.5, 0)}):Play()
		TweenService:Create(NotificationBack, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

		wait(lib.Animations.AnimSpeed)
		wait(dur)

		TweenService:Create(NotificationBack, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0.5, 0)}):Play()
		for i,v in next, NotificationBack:GetChildren() do
			if v:IsA('Frame') then
				game.TweenService:Create(v, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1.000}):Play()
			elseif v:IsA('TextLabel') then
				game.TweenService:Create(v, TweenInfo.new(lib.Animations.AnimSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1.000}):Play()
			end
		end
		wait(lib.Animations.AnimSpeed)
		Notification:Destroy()
	end)()
end

return lib
