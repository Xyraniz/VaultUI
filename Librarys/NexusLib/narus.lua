local NexusLib = {RainbowColorValue = 0, HueSelectionPosition = 0}
local PresetColor = Color3.fromRGB(66, 134, 255)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CloseBind = Enum.KeyCode.RightControl

local NexusGui = Instance.new("ScreenGui")
NexusGui.Name = "NexusLib"
NexusGui.Parent = game:GetService("CoreGui")
NexusGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NexusGui.ResetOnSpawn = false

coroutine.wrap(function()
	while task.wait() do
		NexusLib.RainbowColorValue = NexusLib.RainbowColorValue + 0.005
		if NexusLib.RainbowColorValue >= 1 then
			NexusLib.RainbowColorValue = 0
		end
		NexusLib.HueSelectionPosition = NexusLib.HueSelectionPosition + 1
		if NexusLib.HueSelectionPosition >= 80 then
			NexusLib.HueSelectionPosition = 0
		end
	end
end)()

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

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
			local Delta = input.Position - DragStart
			object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		end
	end)
end

function NexusLib:Window(text, bottom, mainclr, toclose)
	CloseBind = toclose or Enum.KeyCode.RightControl
	PresetColor = mainclr or Color3.fromRGB(66, 134, 255)
	local fs = false
	local uitoggled = false
	local minimized = false
	local originalSize = UDim2.new(0, 620, 0, 440)

	local MainFrame = Instance.new("Frame")
	local MainCorner = Instance.new("UICorner")
	local TopBar = Instance.new("Frame")
	local TopCorner = Instance.new("UICorner")
	local Title = Instance.new("TextLabel")
	local BottomText = Instance.new("TextLabel")
	local MinimizeBtn = Instance.new("TextButton")
	local CloseBtn = Instance.new("TextButton")
	local LeftFrame = Instance.new("Frame")
	local LeftCorner = Instance.new("UICorner")
	local Glow = Instance.new("ImageLabel")
	local TabHold = Instance.new("Frame")
	local TabLayout = Instance.new("UIListLayout")
	local ContainerFolder = Instance.new("Folder")
	local UIScale = Instance.new("UIScale")

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = NexusGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	MainFrame.ClipsDescendants = true

	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = MainFrame

	UIScale.Parent = MainFrame
	RunService.Heartbeat:Connect(function()
		local vp = workspace.CurrentCamera.ViewportSize
		UIScale.Scale = math.min(vp.X / 1400, vp.Y / 900, 1)
	end)

	TopBar.Name = "TopBar"
	TopBar.Parent = MainFrame
	TopBar.BackgroundColor3 = Color3.fromRGB(35, 38, 43)
	TopBar.Size = UDim2.new(1, 0, 0, 45)

	TopCorner.CornerRadius = UDim.new(0, 10)
	TopCorner.Parent = TopBar

	Title.Name = "Title"
	Title.Parent = TopBar
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.AnchorPoint = Vector2.new(0, 0.5)
	Title.Size = UDim2.new(0, 400, 1, 0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = text
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left

	MinimizeBtn.Name = "MinimizeBtn"
	MinimizeBtn.Parent = TopBar
	MinimizeBtn.BackgroundTransparency = 1
	MinimizeBtn.Position = UDim2.new(1, -90, 0, 0)
	MinimizeBtn.Size = UDim2.new(0, 45, 1, 0)
	MinimizeBtn.Font = Enum.Font.GothamBold
	MinimizeBtn.Text = "–"
	MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
	MinimizeBtn.TextSize = 28

	CloseBtn.Name = "CloseBtn"
	CloseBtn.Parent = TopBar
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Position = UDim2.new(1, -45, 0, 0)
	CloseBtn.Size = UDim2.new(0, 45, 1, 0)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.Text = "×"
	CloseBtn.TextColor3 = Color3.new(1, 1, 1)
	CloseBtn.TextSize = 24

	LeftFrame.Name = "LeftFrame"
	LeftFrame.Parent = MainFrame
	LeftFrame.BackgroundColor3 = Color3.fromRGB(35, 38, 43)
	LeftFrame.Position = UDim2.new(0, 0, 0, 45)
	LeftFrame.Size = UDim2.new(0, 190, 1, -45)

	LeftCorner.CornerRadius = UDim.new(0, 10)
	LeftCorner.Parent = LeftFrame

	Glow.Name = "Glow"
	Glow.Parent = MainFrame
	Glow.BackgroundTransparency = 1
	Glow.Position = UDim2.new(0, -15, 0, -15)
	Glow.Size = UDim2.new(1, 30, 1, 30)
	Glow.Image = "rbxassetid://4996891970"
	Glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Glow.ScaleType = Enum.ScaleType.Slice
	Glow.SliceCenter = Rect.new(20, 20, 280, 280)

	BottomText.Name = "BottomText"
	BottomText.Parent = LeftFrame
	BottomText.BackgroundTransparency = 1
	BottomText.Position = UDim2.new(0.05, 0, 0.08, 0)
	BottomText.Size = UDim2.new(0, 160, 0, 28)
	BottomText.Font = Enum.Font.Gotham
	BottomText.Text = bottom or ""
	BottomText.TextColor3 = Color3.new(1, 1, 1)
	BottomText.TextTransparency = 0.4
	BottomText.TextSize = 13
	BottomText.TextXAlignment = Enum.TextXAlignment.Left

	TabHold.Name = "TabHold
	TabHold.Parent = LeftFrame
	TabHold.BackgroundTransparency = 1
	TabHold.Position = UDim2.new(0, 0, 0.15, 0)
	TabHold.Size = UDim2.new(1, 0, 0.85, 0)

	TabLayout.Parent = TabHold
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 4)

	ContainerFolder.Name = "ContainerFolder"
	ContainerFolder.Parent = MainFrame

	MakeDraggable(TopBar, MainFrame)

	MainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.6, true)

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			MinimizeBtn.Text = "+"
			LeftFrame.Visible = false
			ContainerFolder.Visible = false
			MainFrame:TweenSize(UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
		else
			MinimizeBtn.Text = "–"
			LeftFrame.Visible = true
			ContainerFolder.Visible = true
			MainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
		task.delay(0.6, function()
			NexusGui:Destroy()
		end)
	end)

	UserInputService.InputBegan:Connect(function(io, p)
		if io.KeyCode == CloseBind and not p then
			uitoggled = not uitoggled
			if uitoggled then
				MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.6, true)
				task.delay(0.6, function() NexusGui.Enabled = false end)
			else
				NexusGui.Enabled = true
				MainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.6, true)
				if minimized then
					minimized = false
					MinimizeBtn.Text = "–"
					LeftFrame.Visible = true
					ContainerFolder.Visible = true
				end
			end
		end
	end)

	function NexusLib:Notification(desc, buttontitle)
		for _, v in pairs(MainFrame:GetChildren()) do
			if v.Name == "NotificationBase" then v:Destroy() end
		end
		local NotificationBase = Instance.new("TextButton")
		local NotificationBaseCorner = Instance.new("UICorner")
		local NotificationFrame = Instance.new("Frame")
		local NotificationFrameCorner = Instance.new("UICorner")
		local NotificationFrameGlow = Instance.new("ImageLabel")
		local NotificationTitle = Instance.new("TextLabel")
		local CloseBtnNoti = Instance.new("TextButton")
		local CloseBtnCorner = Instance.new("UICorner")
		local NotificationDesc = Instance.new("TextLabel")

		NotificationBase.Name = "NotificationBase"
		NotificationBase.Parent = MainFrame
		NotificationBase.BackgroundColor3 = Color3.fromRGB(0,0,0)
		NotificationBase.BackgroundTransparency = 0.45
		NotificationBase.Size = UDim2.new(1,0,1,0)
		NotificationBase.AutoButtonColor = false
		NotificationBase.Text = ""
		NotificationBase.ZIndex = 100

		NotificationBaseCorner.Parent = NotificationBase

		NotificationFrame.Name = "NotificationFrame"
		NotificationFrame.Parent = NotificationBase
		NotificationFrame.AnchorPoint = Vector2.new(0.5,0.5)
		NotificationFrame.BackgroundColor3 = Color3.fromRGB(35,38,43)
		NotificationFrame.ClipsDescendants = true
		NotificationFrame.Position = UDim2.new(0.5,0,0.5,0)
		NotificationFrame.Size = UDim2.new(0,0,0,0)
		NotificationFrame.ZIndex = 101

		NotificationFrameCorner.CornerRadius = UDim.new(0,10)
		NotificationFrameCorner.Parent = NotificationFrame

		NotificationFrameGlow.Name = "Glow"
		NotificationFrameGlow.Parent = NotificationFrame
		NotificationFrameGlow.BackgroundTransparency = 1
		NotificationFrameGlow.Position = UDim2.new(0,-15,0,-15)
		NotificationFrameGlow.Size = UDim2.new(1,30,1,30)
		NotificationFrameGlow.Image = "rbxassetid://4996891970"
		NotificationFrameGlow.ImageColor3 = Color3.fromRGB(0,0,0)
		NotificationFrameGlow.ScaleType = Enum.ScaleType.Slice
		NotificationFrameGlow.SliceCenter = Rect.new(20,20,280,280)
		NotificationFrameGlow.ZIndex = 100

		NotificationTitle.Name = "NotificationTitle"
		NotificationTitle.Parent = NotificationFrame
		NotificationTitle.BackgroundTransparency = 1
		NotificationTitle.Position = UDim2.new(0.04,0,0.07,0)
		NotificationTitle.Size = UDim2.new(0,300,0,40)
		NotificationTitle.Font = Enum.Font.GothamBold
		NotificationTitle.Text = text.." | NOTIFICATION"
		NotificationTitle.TextColor3 = Color3.new(1,1,1)
		NotificationTitle.TextSize = 20
		NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotificationTitle.TextTransparency = 1

		CloseBtnNoti.Name = "CloseBtn"
		CloseBtnNoti.Parent = NotificationFrame
		CloseBtnNoti.BackgroundColor3 = Color3.fromRGB(50,53,59)
		CloseBtnNoti.Position = UDim2.new(0.04,0,0.72,0)
		CloseBtnNoti.Size = UDim2.new(0,366,0,43)
		CloseBtnNoti.AutoButtonColor = false
		CloseBtnNoti.Font = Enum.Font.Gotham
		CloseBtnNoti.Text = buttontitle or "Alright"
		CloseBtnNoti.TextColor3 = Color3.new(1,1,1)
		CloseBtnNoti.TextSize = 15
		CloseBtnNoti.BackgroundTransparency = 1

		CloseBtnCorner.CornerRadius = UDim.new(0,6)
	CloseBtnCorner.Parent = CloseBtnNoti

		NotificationDesc.Name = "NotificationDesc"
		NotificationDesc.Parent = NotificationFrame
		NotificationDesc.BackgroundTransparency = 1
		NotificationDesc.Position = UDim2.new(0.04,0,0.25,0)
		NotificationDesc.Size = UDim2.new(0,360,0,80)
		NotificationDesc.Font = Enum.Font.Gotham
		NotificationDesc.Text = desc
		NotificationDesc.TextColor3 = Color3.new(1,1,1)
		NotificationDesc.TextSize = 16
		NotificationDesc.TextWrapped = true
		NotificationDesc.TextTransparency = 1

		CloseBtnNoti.MouseButton1Click:Connect(function()
			TweenService:Create(NotificationDesc, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			TweenService:Create(CloseBtnNoti, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
			TweenService:Create(NotificationTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			task.delay(0.4, function()
				NotificationFrame:TweenSize(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
				task.wait(0.6)
				NotificationBase:Destroy()
			end)
		end)

		NotificationFrame:TweenSize(UDim2.new(0,400,0,214), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
		task.wait(0.4)
		TweenService:Create(NotificationDesc, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
		TweenService:Create(CloseBtnNoti, TweenInfo.new(0.3), {TextTransparency = 0.3, BackgroundTransparency = 0}):Play()
		TweenService:Create(NotificationTitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	end

	local Tabs = {}
	function Tabs:Tab(text,ico)
		local Tab = Instance.new("TextButton")
		local TabIcon = Instance.new("ImageLabel")
		local TabTitle = Instance.new("TextLabel")
		local Selector = Instance.new("Frame")

		Selector.Name = "Selector"
		Selector.Parent = Tab
		Selector.BackgroundColor3 = PresetColor
		Selector.Size = UDim2.new(0,5,1,0)
		Selector.Position = UDim2.new(0,0,0,0)
		Selector.BorderSizePixel = 0
		Selector.Visible = false

		Tab.Name = "Tab"
		Tab.Parent = TabHold
		Tab.BackgroundColor3 = Color3.fromRGB(35,38,43)
		Tab.BorderSizePixel = 0
		Tab.Size = UDim2.new(1,0,0,40)
		Tab.AutoButtonColor = false
		Tab.Text = ""

		TabIcon.Name = "TabIcon"
		TabIcon.Parent = Tab
		TabIcon.BackgroundTransparency = 1
		TabIcon.Position = UDim2.new(0.1,0,0.25,0)
		TabIcon.Size = UDim2.new(0,24,0,24)
		TabIcon.Image = ico or ""
		TabIcon.ImageTransparency = 0.3

		TabTitle.Name = "TabTitle"
		TabTitle.Parent = Tab
		TabTitle.BackgroundTransparency = 1
		TabTitle.Position = UDim2.new(0.25,0,0.2,0)
		TabTitle.Size = UDim2.new(0,200,0,40)
		TabTitle.Font = Enum.Font.Gotham
		TabTitle.Text = text
		TabTitle.TextColor3 = Color3.new(1,1,1)
		TabTitle.TextSize = 15
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left
		TabTitle.TextTransparency = 0.3

		local Container = Instance.new("ScrollingFrame")
		local ContainerLayout = Instance.new("UIListLayout")

		Container.Name = "Container"
		Container.Parent = ContainerFolder
		Container.Active = true
		Container.BackgroundTransparency = 1
		Container.BorderSizePixel = 0
		Container.Position = UDim2.new(0,200,0,55)
		Container.Size = UDim2.new(0,410,0,370)
		Container.CanvasSize = UDim2.new(0,0,0,0)
		Container.ScrollBarThickness = 4
		Container.Visible = false
		Container.ScrollBarImageColor3 = Color3.fromRGB(71,76,84)

		ContainerLayout.Parent = Container
		ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContainerLayout.Padding = UDim.new(0,10)

		if fs == false then
			fs = true
			Selector.Visible = true
			Tab.BackgroundTransparency = 0
			TabIcon.ImageTransparency = 0
			TabTitle.TextTransparency = 0
			Container.Visible = true
		end

		Tab.MouseButton1Click:Connect(function()
			for _,v in pairs(TabHold:GetChildren()) do
				if v:IsA("TextButton") then
					v.Selector.Visible = false
					TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					TweenService:Create(v.TabIcon, TweenInfo.new(0.3), {ImageTransparency = 0.3}):Play()
					TweenService:Create(v.TabTitle, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
				end
			end
			for _,v in pairs(ContainerFolder:GetChildren()) do
				if v.Name == "Container" then v.Visible = false end
			end
			Selector.Visible = true
			Container.Visible = true
			TweenService:Create(Tab, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
			TweenService:Create(TabIcon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
			TweenService:Create(TabTitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		end)

		local ContainerContent = {}

		function ContainerContent:Button(text,desc,callback)
			desc = desc == "" and "There is no description for this button." or desc
			local BtnDescToggled = false
			local Button = Instance.new("TextButton")
			local ButtonCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Circle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local CircleSmall = Instance.new("Frame")
			local CircleSmallCorner = Instance.new("UICorner")
			local Description = Instance.new("TextLabel")
			local ArrowBtn = Instance.new("ImageButton")
			local ArrowIco = Instance.new("ImageLabel")

			Button.Name = "Button"
			Button.Parent = Container
			Button.BackgroundColor3 = Color3.fromRGB(35,38,43)
			Button.ClipsDescendants = true
			Button.Size = UDim2.new(0,400,0,43)
			Button.AutoButtonColor = false
			Button.Text = ""

			ButtonCorner.CornerRadius = UDim.new(0,6)
			ButtonCorner.Parent = Button

			Title.Parent = Button
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.07,0,0,0)
			Title.Size = UDim2.new(0,340,1,0)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.new(1,1,1)
			Title.TextSize = 15
			Title.TextTransparency = 0.3
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Circle.Parent = Title
			Circle.AnchorPoint = Vector2.new(0.5,0.5)
			Circle.BackgroundColor3 = Color3.fromRGB(211,211,211)
			Circle.Position = UDim2.new(-0.15,0,0.5,0)
			Circle.Size = UDim2.new(0,12,0,12)

			CircleCorner.CornerRadius = UDim.new(2,6)
			CircleCorner.Parent = Circle

			CircleSmall.Parent = Circle
			CircleSmall.AnchorPoint = Vector2.new(0.5,0.5)
			CircleSmall.BackgroundColor3 = Color3.fromRGB(64,68,75)
			CircleSmall.BackgroundTransparency = 1
			CircleSmall.Position = UDim2.new(0.5,0,0.5,0)
			CircleSmall.Size = UDim2.new(0,9,0,9)

			CircleSmallCorner.CornerRadius = UDim.new(2,6)
			CircleSmallCorner.Parent = CircleSmall

			Description.Parent = Title
			Description.BackgroundTransparency = 1
			Description.Position = UDim2.new(-0.2,0,0.8,0)
			Description.Size = UDim2.new(0,400,0,31)
			Description.Font = Enum.Font.Gotham
			Description.Text = desc
			Description.TextColor3 = Color3.new(1,1,1)
			Description.TextSize = 15
			Description.TextTransparency = 1
			Description.TextWrapped = true
			Description.TextXAlignment = Enum.TextXAlignment.Left

			ArrowBtn.Parent = Button
			ArrowBtn.BackgroundTransparency = 1
			ArrowBtn.Position = UDim2.new(0.9,0,0,0)
			ArrowBtn.Size = UDim2.new(0,33,0,37)
			ArrowBtn.Image = "http://www.roblox.com/asset/?id=6034818372"

			ArrowIco.Parent = ArrowBtn
			ArrowIco.AnchorPoint = Vector2.new(0.5,0.5)
			ArrowIco.BackgroundTransparency = 1
			ArrowIco.Position = UDim2.new(0.5,0,0.5,0)
			ArrowIco.Size = UDim2.new(0,28,0,24)
			ArrowIco.Image = "http://www.roblox.com/asset/?id=6034818372"
			ArrowIco.ImageTransparency = 0.3

			Button.MouseEnter:Connect(function()
				TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
			end)
			Button.MouseLeave:Connect(function()
				TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
			end)

			Button.MouseButton1Click:Connect(function()
				pcall(callback)
			end)

			ArrowBtn.MouseButton1Click:Connect(function()
				BtnDescToggled = not BtnDescToggled
				if BtnDescToggled then
					Button:TweenSize(UDim2.new(0,400,0,74), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = PresetColor, TextTransparency = 0}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = PresetColor, ImageTransparency = 0, Rotation = 180}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Description, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
				else
					Button:TweenSize(UDim2.new(0,400,0,43), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0.3, Rotation = 0}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					TweenService:Create(Description, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
				end
				task.wait(0.4)
				Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
			end)
			Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
		end

		function ContainerContent:Toggle(text,desc,default,callback)
			desc = desc == "" and "There is no description for this toggle." or desc
			local Toggled = default or false
			local ToggleDescToggled = false
			local Toggle = Instance.new("TextButton")
			local ToggleCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Circle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local CircleSmall = Instance.new("Frame")
			local CircleSmallCorner = Instance.new("UICorner")
			local ToggleFrame = Instance.new("Frame")
			local ToggleFrameCorner = Instance.new("UICorner")
			local ToggleCircle = Instance.new("Frame")
			local ToggleCircleCorner = Instance.new("UICorner")
			local Description = Instance.new("TextLabel")
			local ArrowBtn = Instance.new("ImageButton")
			local ArrowIco = Instance.new("ImageLabel")

			Toggle.Name = "Toggle"
			Toggle.Parent = Container
			Toggle.BackgroundColor3 = Color3.fromRGB(35,38,43)
			Toggle.ClipsDescendants = true
			Toggle.Size = UDim2.new(0,400,0,43)
			Toggle.AutoButtonColor = false
			Toggle.Text = ""

			ToggleCorner.CornerRadius = UDim.new(0,6)
			ToggleCorner.Parent = Toggle

			Title.Parent = Toggle
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.07,0,0,0)
			Title.Size = UDim2.new(0,340,1,0)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.new(1,1,1)
			Title.TextSize = 15
			Title.TextTransparency = 0.3
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Circle.Parent = Title
			Circle.AnchorPoint = Vector2.new(0.5,0.5)
			Circle.BackgroundColor3 = Color3.fromRGB(211,211,211)
			Circle.Position = UDim2.new(-0.15,0,0.5,0)
			Circle.Size = UDim2.new(0,12,0,12)

			CircleCorner.CornerRadius = UDim.new(2,6)
			CircleCorner.Parent = Circle

			CircleSmall.Parent = Circle
			CircleSmall.AnchorPoint = Vector2.new(0.5,0.5)
			CircleSmall.BackgroundColor3 = Color3.fromRGB(64,68,75)
			CircleSmall.BackgroundTransparency = 1
			CircleSmall.Position = UDim2.new(0.5,0,0.5,0)
			CircleSmall.Size = UDim2.new(0,9,0,9)

			CircleSmallCorner.CornerRadius = UDim.new(2,6)
			CircleSmallCorner.Parent = CircleSmall

			ToggleFrame.Parent = Circle
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(226,227,227)
			ToggleFrame.Position = UDim2.new(2.8,0,0,0)
			ToggleFrame.Size = UDim2.new(0,30,0,12)

			ToggleFrameCorner.Parent = ToggleFrame

			ToggleCircle.Parent = ToggleFrame
			ToggleCircle.BackgroundColor3 = Toggled and PresetColor or Color3.new(1,1,1)
			ToggleCircle.Position = Toggled and UDim2.new(0.45,0,-0.27,0) or UDim2.new(0,0,-0.27,0)
			ToggleCircle.Size = UDim2.new(0,18,0,18)

			ToggleCircleCorner.CornerRadius = UDim.new(2,8)
			ToggleCircleCorner.Parent = ToggleCircle

			Description.Parent = Title
			Description.BackgroundTransparency = 1
			Description.Position = UDim2.new(-0.2,0,0.8,0)
			Description.Size = UDim2.new(0,400,0,31)
			Description.Font = Enum.Font.Gotham
			Description.Text = desc
			Description.TextColor3 = Color3.new(1,1,1)
			Description.TextSize = 15
			Description.TextTransparency = 1
			Description.TextWrapped = true
			Description.TextXAlignment = Enum.TextXAlignment.Left

			ArrowBtn.Parent = Toggle
			ArrowBtn.BackgroundTransparency = 1
			ArrowBtn.Position = UDim2.new(0.9,0,0,0)
			ArrowBtn.Size = UDim2.new(0,33,0,37)
			ArrowBtn.Image = "http://www.roblox.com/asset/?id=6034818372"

			ArrowIco.Parent = ArrowBtn
			ArrowIco.AnchorPoint = Vector2.new(0.5,0.5)
			ArrowIco.BackgroundTransparency = 1
			ArrowIco.Position = UDim2.new(0.5,0,0.5,0)
			ArrowIco.Size = UDim2.new(0,28,0,24)
			ArrowIco.Image = "http://www.roblox.com/asset/?id=6034818372"
			ArrowIco.ImageTransparency = 0.3

			Toggle.MouseEnter:Connect(function()
				TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
			end)
			Toggle.MouseLeave:Connect(function()
				TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
			end)

			Toggle.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				if Toggled then
					ToggleCircle:TweenPosition(UDim2.new(0.45,0,-0.27,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.3,true)
					TweenService:Create(ToggleCircle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
				else
					ToggleCircle:TweenPosition(UDim2.new(0,0,-0.27,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.3,true)
					TweenService:Create(ToggleCircle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
				end
				pcall(callback, Toggled)
			end)

			ArrowBtn.MouseButton1Click:Connect(function()
				ToggleDescToggled = not ToggleDescToggled
				if ToggleDescToggled then
					Toggle:TweenSize(UDim2.new(0,400,0,74), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = PresetColor, TextTransparency = 0}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = PresetColor, ImageTransparency = 0, Rotation = 180}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Description, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
				else
					Toggle:TweenSize(UDim2.new(0,400,0,43), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0.3, Rotation = 0}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					TweenService:Create(Description, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
				end
				task.wait(0.4)
				Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
			end)
			if default then
				ToggleCircle:TweenPosition(UDim2.new(0.45,0,-0.27,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.3,true)
				TweenService:Create(ToggleCircle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
				Toggled = true
				pcall(callback, true)
			end
			Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
		end

		function ContainerContent:Slider(text,desc,min,max,start,callback)
			local SliderDescToggled = false
			local dragging = false
			desc = desc == "" and "There is no description for this slider." or desc
			local Slider = Instance.new("TextButton")
			local SliderCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Circle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local CircleSmall = Instance.new("Frame")
			local CircleSmallCorner = Instance.new("UICorner")
			local Description = Instance.new("TextLabel")
			local SlideFrame = Instance.new("Frame")
			local CurrentValueFrame = Instance.new("Frame")
			local SlideCircle = Instance.new("ImageButton")
			local ArrowBtn = Instance.new("ImageButton")
			local ArrowIco = Instance.new("ImageLabel")
			local Value = Instance.new("TextLabel")

			Slider.Name = "Slider"
			Slider.Parent = Container
			Slider.BackgroundColor3 = Color3.fromRGB(35,38,43)
			Slider.ClipsDescendants = true
			Slider.Size = UDim2.new(0,400,0,60)
			Slider.AutoButtonColor = false
			Slider.Text = ""

			SliderCorner.CornerRadius = UDim.new(0,6)
			SliderCorner.Parent = Slider

			Title.Parent = Slider
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.07,0,0,0)
			Title.Size = UDim2.new(0,340,0,42)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.new(1,1,1)
			Title.TextSize = 15
			Title.TextTransparency = 0.3
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Circle.Parent = Title
			Circle.AnchorPoint = Vector2.new(0.5,0.5)
			Circle.BackgroundColor3 = Color3.fromRGB(211,211,211)
			Circle.Position = UDim2.new(-0.15,0,0.5,0)
			Circle.Size = UDim2.new(0,12,0,12)

			CircleCorner.CornerRadius = UDim.new(2,6)
			CircleCorner.Parent = Circle

			CircleSmall.Parent = Circle
			CircleSmall.AnchorPoint = Vector2.new(0.5,0.5)
			CircleSmall.BackgroundColor3 = Color3.fromRGB(64,68,75)
			CircleSmall.BackgroundTransparency = 1
			CircleSmall.Position = UDim2.new(0.5,0,0.5,0)
			CircleSmall.Size = UDim2.new(0,9,0,9)

			CircleSmallCorner.CornerRadius = UDim.new(2,6)
			CircleSmallCorner.Parent = CircleSmall

			Description.Parent = Title
			Description.BackgroundTransparency = 1
			Description.Position = UDim2.new(-0.2,0,1.4,0)
			Description.Size = UDim2.new(0,400,0,31)
			Description.Font = Enum.Font.Gotham
			Description.Text = desc
			Description.TextColor3 = Color3.new(1,1,1)
			Description.TextSize = 15
			Description.TextTransparency = 0.3
			Description.TextWrapped = true
			Description.TextXAlignment = Enum.TextXAlignment.Left

			SlideFrame.Parent = Title
			SlideFrame.BackgroundColor3 = Color3.fromRGB(235,234,235)
			SlideFrame.BorderSizePixel = 0
			SlideFrame.Position = UDim2.new(-0.2,0,0.98,0)
			SlideFrame.Size = UDim2.new(0,400,0,4)

			CurrentValueFrame.Parent = SlideFrame
			CurrentValueFrame.BackgroundColor3 = PresetColor
			CurrentValueFrame.BorderSizePixel = 0
			CurrentValueFrame.Size = UDim2.new((start or min)/max,0,0,4)

			SlideCircle.Parent = SlideFrame
			SlideCircle.BackgroundTransparency = 1
			SlideCircle.Position = UDim2.new((start or min)/max,-6,-1.5,0)
			SlideCircle.Size = UDim2.new(0,14,0,14)
			SlideCircle.Image = "rbxassetid://3570695787"
			SlideCircle.ImageColor3 = PresetColor

			Value.Parent = SlideFrame
			Value.BackgroundTransparency = 1
			Value.Position = UDim2.new(0,0,-1.8,0)
			Value.Size = UDim2.new(1,0,0,20)
			Value.Font = Enum.Font.GothamBold
			Value.Text = tostring(start or min)
			Value.TextColor3 = Color3.new(1,1,1)
			Value.TextSize = 14

			ArrowBtn.Parent = Slider
			ArrowBtn.BackgroundTransparency = 1
			ArrowBtn.Position = UDim2.new(0.9,0,0,0)
			ArrowBtn.Size = UDim2.new(0,33,0,37)
			ArrowBtn.Image = "http://www.roblox.com/asset/?id=6034818372"

			ArrowIco.Parent = ArrowBtn
			ArrowIco.AnchorPoint = Vector2.new(0.5,0.5)
			ArrowIco.BackgroundTransparency = 1
			ArrowIco.Position = UDim2.new(0.5,0,0.5,0)
			ArrowIco.Size = UDim2.new(0,28,0,24)
			ArrowIco.Image = "http://www.roblox.com/asset/?id=6034818372"
			ArrowIco.ImageTransparency = 0.3

			local function Update(input)
				local pos = math.clamp((input.Position.X - SlideFrame.AbsolutePosition.X) / SlideFrame.AbsoluteSize.X,0,1)
				CurrentValueFrame.Size = UDim2.new(pos,0,0,4)
				SlideCircle.Position = UDim2.new(pos,-6,-1.5,0)
				local val = min + (max - min) * pos
				Value.Text = math.floor(val)
				pcall(callback, math.floor(val))
			end

			SlideCircle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
				end
			end)

			SlideCircle.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					Update(input)
				end
			end)

			ArrowBtn.MouseButton1Click:Connect(function()
				SliderDescToggled = not SliderDescToggled
				if SliderDescToggled then
					Slider:TweenSize(UDim2.new(0,400,0,91), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = PresetColor, TextTransparency = 0}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = PresetColor, ImageTransparency = 0, Rotation = 180}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Description, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
				else
					Slider:TweenSize(UDim2.new(0,400,0,60), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0.3, Rotation = 0}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					TweenService:Create(Description, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
				end
				task.wait(0.4)
				Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
			end)
			Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
		end

		function ContainerContent:Dropdown(text, list, callback)
			local DropToggled = false
			local FrameSize = 0
			local ItemCount = 0
			local Dropdown = Instance.new("TextButton")
			local DropdownCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Circle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local CircleSmall = Instance.new("Frame")
			local CircleSmallCorner = Instance.new("UICorner")
			local ArrowIco = Instance.new("ImageLabel")
			local DropItemHolder = Instance.new("ScrollingFrame")
			local DropLayout = Instance.new("UIListLayout")

			Dropdown.Name = "Dropdown"
			Dropdown.Parent = Container
			Dropdown.BackgroundColor3 = Color3.fromRGB(35,38,43)
			Dropdown.ClipsDescendants = true
			Dropdown.Size = UDim2.new(0,400,0,43)
			Dropdown.AutoButtonColor = false
			Dropdown.Text = ""

			DropdownCorner.CornerRadius = UDim.new(0,6)
			DropdownCorner.Parent = Dropdown

			Title.Parent = Dropdown
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.07,0,0,0)
			Title.Size = UDim2.new(0,340,1,0)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.new(1,1,1)
			Title.TextSize = 15
			Title.TextTransparency = 0.3
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Circle.Parent = Title
			Circle.AnchorPoint = Vector2.new(0.5,0.5)
			Circle.BackgroundColor3 = Color3.fromRGB(211,211,211)
			Circle.Position = UDim2.new(-0.15,0,0.5,0)
			Circle.Size = UDim2.new(0,12,0,12)

			CircleCorner.CornerRadius = UDim.new(2,6)
			CircleCorner.Parent = Circle

			CircleSmall.Parent = Circle
			CircleSmall.AnchorPoint = Vector2.new(0.5,0.5)
			CircleSmall.BackgroundColor3 = Color3.fromRGB(64,68,75)
			CircleSmall.BackgroundTransparency = 1
			CircleSmall.Position = UDim2.new(0.5,0,0.5,0)
			CircleSmall.Size = UDim2.new(0,9,0,9)

			CircleSmallCorner.CornerRadius = UDim.new(2,6)
			CircleSmallCorner.Parent = CircleSmall

			ArrowIco.Parent = Dropdown
			ArrowIco.AnchorPoint = Vector2.new(0.5,0.5)
			ArrowIco.BackgroundTransparency = 1
			ArrowIco.Position = UDim2.new(0.9,0,0.5,0)
			ArrowIco.Size = UDim2.new(0,28,0,24)
			ArrowIco.Image = "http://www.roblox.com/asset/?id=6034818372"
			ArrowIco.ImageTransparency = 0.3

			DropItemHolder.Name = "DropItemHolder"
			DropItemHolder.Parent = Dropdown
			DropItemHolder.BackgroundTransparency = 1
			DropItemHolder.BorderSizePixel = 0
			DropItemHolder.Position = UDim2.new(0,0,1,0)
			DropItemHolder.Size = UDim2.new(1,0,0,100)
			DropItemHolder.CanvasSize = UDim2.new(0,0,0,0)
			DropItemHolder.ScrollBarThickness = 4
			DropItemHolder.Visible = false

			DropLayout.Parent = DropItemHolder
			DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
			DropLayout.Padding = UDim.new(0,4)

			Dropdown.MouseButton1Click:Connect(function()
				DropToggled = not DropToggled
				if DropToggled then
					Dropdown:TweenSize(UDim2.new(0,400,0,143), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					DropItemHolder.Visible = true
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = PresetColor, TextTransparency = 0}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = PresetColor, ImageTransparency = 0, Rotation = 180}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
				else
					Dropdown:TweenSize(UDim2.new(0,400,0,43), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					DropItemHolder.Visible = false
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0.3, Rotation = 0}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				end
				task.wait(0.4)
				Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
			end)

			local DropFunc = {}
			for i, v in pairs(list) do
				ItemCount = ItemCount + 1
				local Item = Instance.new("TextButton")
				local ItemCorner = Instance.new("UICorner")

				Item.Name = "Item"
				Item.Parent = DropItemHolder
				Item.BackgroundColor3 = Color3.fromRGB(35,38,43)
				Item.Size = UDim2.new(1,0,0,30)
				Item.AutoButtonColor = false
				Item.Text = v
				Item.TextColor3 = Color3.new(1,1,1)
				Item.TextSize = 14
				Item.Font = Enum.Font.Gotham
				Item.TextTransparency = 0.3

				ItemCorner.CornerRadius = UDim.new(0,6)
				ItemCorner.Parent = Item

				Item.MouseEnter:Connect(function()
					TweenService:Create(Item, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
				end)
				Item.MouseLeave:Connect(function()
					TweenService:Create(Item, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
				end)

				Item.MouseButton1Click:Connect(function()
					pcall(callback, v)
					Title.Text = text .. " : " .. v
					DropToggled = false
					Dropdown:TweenSize(UDim2.new(0,400,0,43), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					DropItemHolder.Visible = false
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0.3, Rotation = 0}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					task.wait(0.4)
					Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
				end)
			end
			DropItemHolder.CanvasSize = UDim2.new(0,0,0,DropLayout.AbsoluteContentSize.Y)
			function DropFunc:Clear()
				for i,v in pairs(DropItemHolder:GetChildren()) do
					if v:IsA("TextButton") then v:Destroy() end
				end
				ItemCount = 0
			end
			function DropFunc:Add(text)
				ItemCount = ItemCount + 1
				local Item = Instance.new("TextButton")
				local ItemCorner = Instance.new("UICorner")
				Item.Name = "Item"
				Item.Parent = DropItemHolder
				Item.BackgroundColor3 = Color3.fromRGB(35,38,43)
				Item.Size = UDim2.new(1,0,0,30)
				Item.AutoButtonColor = false
				Item.Text = text
				Item.TextColor3 = Color3.new(1,1,1)
				Item.TextSize = 14
				Item.Font = Enum.Font.Gotham
				Item.TextTransparency = 0.3

				ItemCorner.CornerRadius = UDim.new(0,6)
				ItemCorner.Parent = Item

				Item.MouseEnter:Connect(function()
					TweenService:Create(Item, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
				end)
				Item.MouseLeave:Connect(function()
					TweenService:Create(Item, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
				end)

				Item.MouseButton1Click:Connect(function()
					pcall(callback, text)
					Title.Text = text .. " : " .. text
					DropToggled = false
					Dropdown:TweenSize(UDim2.new(0,400,0,43), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					DropItemHolder.Visible = false
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0.3, Rotation = 0}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					task.wait(0.4)
					Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
				end)
				DropItemHolder.CanvasSize = UDim2.new(0,0,0,DropLayout.AbsoluteContentSize.Y)
			end
			return DropFunc
		end

		function ContainerContent:Colorpicker(text,preset,callback)
			local ColorPickerToggled = false
			local OldToggleColor = Color3.fromRGB(0,0,0)
			local OldColor = Color3.fromRGB(0,0,0)
			local OldColorSelectionPosition = nil
			local OldHueSelectionPosition = nil
			local ColorH, ColorS, ColorV = 1, 1, 1
			local RainbowColorPicker = false
			local ColorInput = nil
			local HueInput = nil

			local Colorpicker = Instance.new("Frame")
			local ColorpickerCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Circle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local CircleSmall = Instance.new("Frame")
			local CircleSmallCorner = Instance.new("UICorner")
			local Hue = Instance.new("ImageLabel")
			local HueCorner = Instance.new("UICorner")
			local HueGradient = Instance.new("UIGradient")
			local HueSelection = Instance.new("ImageLabel")
			local Color = Instance.new("ImageLabel")
			local ColorCorner = Instance.new("UICorner")
			local ColorSelection = Instance.new("ImageLabel")
			local Toggle = Instance.new("TextLabel")
			local ToggleFrame = Instance.new("Frame")
			local ToggleFrameCorner = Instance.new("UICorner")
			local ToggleCircle = Instance.new("Frame")
			local ToggleCircleCorner = Instance.new("UICorner")
			local Confirm = Instance.new("TextButton")
			local ConfirmCorner = Instance.new("UICorner")
			local ConfirmTitle = Instance.new("TextLabel")
			local BoxColor = Instance.new("Frame")
			local BoxColorCorner = Instance.new("UICorner")
			local ColorpickerBtn = Instance.new("TextButton")
			local ToggleBtn = Instance.new("TextButton")

			Colorpicker.Name = "Colorpicker"
			Colorpicker.Parent = Container
			Colorpicker.BackgroundColor3 = Color3.fromRGB(35,38,43)
			Colorpicker.ClipsDescendants = true
			Colorpicker.Size = UDim2.new(0,400,0,43)

			ColorpickerCorner.CornerRadius = UDim.new(0,6)
			ColorpickerCorner.Parent = Colorpicker

			Title.Parent = Colorpicker
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.07,0,0,0)
			Title.Size = UDim2.new(0,340,1,0)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.new(1,1,1)
			Title.TextSize = 15
			Title.TextTransparency = 0.3
			Title.TextXAlignment = Enum.TextXAlignment.Left

			ColorpickerBtn.Parent = Title
			ColorpickerBtn.BackgroundTransparency = 1
			ColorpickerBtn.Size = UDim2.new(1,0,1,0)
			ColorpickerBtn.Text = ""
			ColorpickerBtn.AutoButtonColor = false

			Circle.Parent = Title
			Circle.AnchorPoint = Vector2.new(0.5,0.5)
			Circle.BackgroundColor3 = Color3.fromRGB(211,211,211)
			Circle.Position = UDim2.new(-0.15,0,0.5,0)
			Circle.Size = UDim2.new(0,12,0,12)

			CircleCorner.CornerRadius = UDim.new(2,6)
			CircleCorner.Parent = Circle

			CircleSmall.Parent = Circle
			CircleSmall.AnchorPoint = Vector2.new(0.5,0.5)
			CircleSmall.BackgroundColor3 = Color3.fromRGB(64,68,75)
			CircleSmall.BackgroundTransparency = 1
			CircleSmall.Position = UDim2.new(0.5,0,0.5,0)
			CircleSmall.Size = UDim2.new(0,9,0,9)

			CircleSmallCorner.CornerRadius = UDim.new(2,6)
			CircleSmallCorner.Parent = CircleSmall

			Hue.Parent = Colorpicker
			Hue.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Hue.Position = UDim2.new(0.07,0,1.1,0)
			Hue.Size = UDim2.new(0,25,0,120)

			HueCorner.CornerRadius = UDim.new(0,3)
			HueCorner.Parent = Hue

			HueGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
				ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,255,0)),
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0,255,0)),
				ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,255)),
				ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
				ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255,0,255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
			}
			HueGradient.Rotation = 270
			HueGradient.Parent = Hue

			HueSelection.Parent = Hue
			HueSelection.AnchorPoint = Vector2.new(0.5,0.5)
			HueSelection.BackgroundTransparency = 1
			HueSelection.Position = UDim2.new(0.5,0,1 - select(1, Color3.toHSV(preset or PresetColor)))
			HueSelection.Size = UDim2.new(0,18,0,18)
			HueSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
			HueSelection.Visible = false

			Color.Parent = Colorpicker
			Color.BackgroundColor3 = preset or PresetColor
			Color.Position = UDim2.new(0.07,40,1.1,0)
			Color.Size = UDim2.new(0,340,0,120)
			Color.Image = "rbxassetid://4155801252"

			ColorCorner.CornerRadius = UDim.new(0,3)
			ColorCorner.Parent = Color

			ColorSelection.Parent = Color
			ColorSelection.AnchorPoint = Vector2.new(0.5,0.5)
			ColorSelection.BackgroundTransparency = 1
			ColorSelection.Position = UDim2.new(preset and select(3, Color3.toHSV(preset)) or 0.5,0,0.5,0)
			ColorSelection.Size = UDim2.new(0,18,0,18)
			ColorSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
			ColorSelection.Visible = false

			Toggle.Parent = Colorpicker
			Toggle.BackgroundTransparency = 1
			Toggle.Position = UDim2.new(0.07,0,3.3,0)
			Toggle.Size = UDim2.new(0,120,0,38)
			Toggle.Font = Enum.Font.Gotham
			Toggle.Text = "Rainbow"
			Toggle.TextColor3 = Color3.new(1,1,1)
			Toggle.TextSize = 14
			Toggle.TextTransparency = 0.3
			Toggle.TextXAlignment = Enum.TextXAlignment.Left

			ToggleFrame.Parent = Toggle
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(226,227,227)
			ToggleFrame.Position = UDim2.new(0.8,0,0.5,0)
			ToggleFrame.Size = UDim2.new(0,30,0,12)

			ToggleFrameCorner.Parent = ToggleFrame

			ToggleCircle.Parent = ToggleFrame
			ToggleCircle.BackgroundColor3 = Color3.new(1,1,1)
			ToggleCircle.Position = UDim2.new(0,0,-0.27,0)
			ToggleCircle.Size = UDim2.new(0,18,0,18)

			ToggleCircleCorner.CornerRadius = UDim.new(2,8)
			ToggleCircleCorner.Parent = ToggleCircle

			Confirm.Parent = Colorpicker
			Confirm.BackgroundColor3 = Color3.fromRGB(50,53,59)
			Confirm.Position = UDim2.new(0.07,0,3.9,0)
			Confirm.Size = UDim2.new(0,120,0,38)
			Confirm.AutoButtonColor = false
			Confirm.Text = "Confirm"
			Confirm.TextColor3 = Color3.new(1,1,1)
			Confirm.TextSize = 14

			ConfirmCorner.CornerRadius = UDim.new(0,6)
			ConfirmCorner.Parent = Confirm

			BoxColor.Parent = Colorpicker
			BoxColor.BackgroundColor3 = preset or PresetColor
			BoxColor.Position = UDim2.new(0.85,0,3.5,0)
			BoxColor.Size = UDim2.new(0,40,0,25)

			BoxColorCorner.CornerRadius = UDim.new(0,6)
			BoxColorCorner.Parent = BoxColor

			ToggleBtn.Parent = Toggle
			ToggleBtn.BackgroundTransparency = 1
			ToggleBtn.Size = UDim2.new(1,0,1,0)
			ToggleBtn.Text = ""

			ColorpickerBtn.MouseEnter:Connect(function()
				TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
			end)
			ColorpickerBtn.MouseLeave:Connect(function()
				TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
			end)

			local function UpdateColorPicker()
				BoxColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
				Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
				pcall(callback, BoxColor.BackgroundColor3)
			end

			ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
			ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
			ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

			BoxColor.BackgroundColor3 = preset or PresetColor
			Color.BackgroundColor3 = preset or PresetColor
			pcall(callback, BoxColor.BackgroundColor3)

			Color.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if RainbowColorPicker then return end
					if ColorInput then ColorInput:Disconnect() end
					ColorInput = RunService.RenderStepped:Connect(function()
						local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
						local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
						ColorSelection.Position = UDim2.new(ColorX,0,ColorY,0)
						ColorS = ColorX
						ColorV = 1 - ColorY
						UpdateColorPicker()
					end)
				end
			end)

			Color.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if ColorInput then ColorInput:Disconnect() end
				end
			end)

			Hue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if RainbowColorPicker then return end
					if HueInput then HueInput:Disconnect() end
					HueInput = RunService.RenderStepped:Connect(function()
						local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
						HueSelection.Position = UDim2.new(0.5,0,HueY,0)
						ColorH = 1 - HueY
						UpdateColorPicker()
					end)
				end
			end)

			Hue.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if HueInput then HueInput:Disconnect() end
				end
			end)

			ToggleBtn.MouseButton1Click:Connect(function()
				RainbowColorPicker = not RainbowColorPicker
				if RainbowColorPicker then
					ToggleCircle:TweenPosition(UDim2.new(0.45,0,-0.27,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.3,true)
					TweenService:Create(ToggleCircle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
					OldToggleColor = BoxColor.BackgroundColor3
					OldColor = Color.BackgroundColor3
					OldColorSelectionPosition = ColorSelection.Position
					OldHueSelectionPosition = HueSelection.Position

					while RainbowColorPicker do
						BoxColor.BackgroundColor3 = Color3.fromHSV(NexusLib.RainbowColorValue, 1, 1)
						Color.BackgroundColor3 = Color3.fromHSV(NexusLib.RainbowColorValue, 1, 1)
						ColorSelection.Position = UDim2.new(1,0,0,0)
						HueSelection.Position = UDim2.new(0.5,0, NexusLib.HueSelectionPosition / 80,0)
						pcall(callback, BoxColor.BackgroundColor3)
						task.wait()
					end
				else
					ToggleCircle:TweenPosition(UDim2.new(0,0,-0.27,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.3,true)
					TweenService:Create(ToggleCircle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
					BoxColor.BackgroundColor3 = OldToggleColor
					Color.BackgroundColor3 = OldColor
					ColorSelection.Position = OldColorSelectionPosition
					HueSelection.Position = OldHueSelectionPosition
					pcall(callback, BoxColor.BackgroundColor3)
				end
				if ColorInput then ColorInput:Disconnect() end
				if HueInput then HueInput:Disconnect() end
			end)

			ColorpickerBtn.MouseButton1Click:Connect(function()
				ColorPickerToggled = not ColorPickerToggled
				if ColorPickerToggled then
					Colorpicker:TweenSize(UDim2.new(0,400,0,200), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					HueSelection.Visible = true
					ColorSelection.Visible = true
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = PresetColor, TextTransparency = 0}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
				else
					Colorpicker:TweenSize(UDim2.new(0,400,0,43), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					HueSelection.Visible = false
					ColorSelection.Visible = false
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				end
				task.wait(0.4)
				Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
			end)

			Confirm.MouseButton1Click:Connect(function()
				ColorPickerToggled = false
				Colorpicker:TweenSize(UDim2.new(0,400,0,43), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
				HueSelection.Visible = false
				ColorSelection.Visible = false
				TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
				TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				task.wait(0.4)
				Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
			end)
			Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
		end

		function ContainerContent:Textbox(text,desc,disappear,callback)
			desc = desc == "" and "There is no description for this textbox." or desc
			local TextboxDescToggled = false
			local Textbox = Instance.new("TextButton")
			local TextboxCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Circle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local CircleSmall = Instance.new("Frame")
			local CircleSmallCorner = Instance.new("UICorner")
			local Description = Instance.new("TextLabel")
			local TextboxFrame = Instance.new("Frame")
			local TextboxFrameCorner = Instance.new("UICorner")
			local TextBox = Instance.new("TextBox")
			local ArrowBtn = Instance.new("ImageButton")
			local ArrowIco = Instance.new("ImageLabel")

			Textbox.Name = "Textbox"
			Textbox.Parent = Container
			Textbox.BackgroundColor3 = Color3.fromRGB(35,38,43)
			Textbox.ClipsDescendants = true
			Textbox.Size = UDim2.new(0,400,0,43)
			Textbox.AutoButtonColor = false
			Textbox.Text = ""

			TextboxCorner.CornerRadius = UDim.new(0,6)
			TextboxCorner.Parent = Textbox

			Title.Parent = Textbox
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.07,0,0,0)
			Title.Size = UDim2.new(0,340,1,0)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.new(1,1,1)
			Title.TextSize = 15
			Title.TextTransparency = 0.3
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Circle.Parent = Title
			Circle.AnchorPoint = Vector2.new(0.5,0.5)
			Circle.BackgroundColor3 = Color3.fromRGB(211,211,211)
			Circle.Position = UDim2.new(-0.15,0,0.5,0)
			Circle.Size = UDim2.new(0,12,0,12)

			CircleCorner.CornerRadius = UDim.new(2,6)
			CircleCorner.Parent = Circle

			CircleSmall.Parent = Circle
			CircleSmall.AnchorPoint = Vector2.new(0.5,0.5)
			CircleSmall.BackgroundColor3 = Color3.fromRGB(64,68,75)
			CircleSmall.BackgroundTransparency = 1
			CircleSmall.Position = UDim2.new(0.5,0,0.5,0)
			CircleSmall.Size = UDim2.new(0,9,0,9)

			CircleSmallCorner.CornerRadius = UDim.new(2,6)
			CircleSmallCorner.Parent = CircleSmall

			Description.Parent = Title
			Description.BackgroundTransparency = 1
			Description.Position = UDim2.new(-0.2,0,0.8,0)
			Description.Size = UDim2.new(0,400,0,31)
			Description.Font = Enum.Font.Gotham
			Description.Text = desc
			Description.TextColor3 = Color3.new(1,1,1)
			Description.TextSize = 15
			Description.TextTransparency = 1
			Description.TextWrapped = true
			Description.TextXAlignment = Enum.TextXAlignment.Left

			TextboxFrame.Parent = Title
			TextboxFrame.BackgroundColor3 = Color3.fromRGB(50,53,59)
			TextboxFrame.Position = UDim2.new(1.8,0,0.2,0)
			TextboxFrame.Size = UDim2.new(0,150,0,26)

			TextboxFrameCorner.CornerRadius = UDim.new(0,4)
			TextboxFrameCorner.Parent = TextboxFrame

			TextBox.Parent = TextboxFrame
			TextBox.BackgroundTransparency = 1
			TextBox.Size = UDim2.new(1,0,1,0)
			TextBox.Font = Enum.Font.Gotham
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.new(1,1,1)
			TextBox.TextSize = 14
			TextBox.TextTransparency = 0.3

			ArrowBtn.Parent = Textbox
			ArrowBtn.BackgroundTransparency = 1
			ArrowBtn.Position = UDim2.new(0.9,0,0,0)
			ArrowBtn.Size = UDim2.new(0,33,0,37)
			ArrowBtn.Image = "http://www.roblox.com/asset/?id=6034818372"

			ArrowIco.Parent = ArrowBtn
			ArrowIco.AnchorPoint = Vector2.new(0.5,0.5)
			ArrowIco.BackgroundTransparency = 1
			ArrowIco.Position = UDim2.new(0.5,0,0.5,0)
			ArrowIco.Size = UDim2.new(0,28,0,24)
			ArrowIco.Image = "http://www.roblox.com/asset/?id=6034818372"
			ArrowIco.ImageTransparency = 0.3

			TextBox.FocusLost:Connect(function(ep)
				if ep then
					if #TextBox.Text > 0 then
						pcall(callback, TextBox.Text)
						if disappear then
							TextBox.Text = ""
						end
					end
				end
			end)

			ArrowBtn.MouseButton1Click:Connect(function()
				TextboxDescToggled = not TextboxDescToggled
				if TextboxDescToggled then
					Textbox:TweenSize(UDim2.new(0,400,0,74), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = PresetColor, TextTransparency = 0}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = PresetColor, ImageTransparency = 0, Rotation = 180}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Description, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
				else
					Textbox:TweenSize(UDim2.new(0,400,0,43), Enum.EasingDirection.Out, Enum.EasingStyle.Quart,0.6,true)
					TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextTransparency = 0.3}):Play()
					TweenService:Create(ArrowIco, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0.3, Rotation = 0}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
					TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					TweenService:Create(Description, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
				end
				task.wait(0.4)
				Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
			end)
			Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
		end

		function ContainerContent:Bind(text,presetbind,callback)
			local Key = presetbind.Name
			local Bind = Instance.new("TextButton")
			local BindCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Circle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local CircleSmall = Instance.new("Frame")
			local CircleSmallCorner = Instance.new("UICorner")
			local BindLabel = Instance.new("TextLabel")

			Bind.Name = "Bind"
			Bind.Parent = Container
			Bind.BackgroundColor3 = Color3.fromRGB(35,38,43)
			Bind.ClipsDescendants = true
			Bind.Size = UDim2.new(0,400,0,43)
			Bind.AutoButtonColor = false
			Bind.Text = ""

			BindCorner.CornerRadius = UDim.new(0,6)
			BindCorner.Parent = Bind

			Title.Parent = Bind
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.07,0,0,0)
			Title.Size = UDim2.new(0,340,1,0)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.new(1,1,1)
			Title.TextSize = 15
			Title.TextTransparency = 0.3
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Circle.Parent = Title
			Circle.AnchorPoint = Vector2.new(0.5,0.5)
			Circle.BackgroundColor3 = Color3.fromRGB(211,211,211)
			Circle.Position = UDim2.new(-0.15,0,0.5,0)
			Circle.Size = UDim2.new(0,12,0,12)

			CircleCorner.CornerRadius = UDim.new(2,6)
			CircleCorner.Parent = Circle

			CircleSmall.Parent = Circle
			CircleSmall.AnchorPoint = Vector2.new(0.5,0.5)
			CircleSmall.BackgroundColor3 = Color3.fromRGB(64,68,75)
			CircleSmall.BackgroundTransparency = 1
			CircleSmall.Position = UDim2.new(0.5,0,0.5,0)
			CircleSmall.Size = UDim2.new(0,9,0,9)

			CircleSmallCorner.CornerRadius = UDim.new(2,6)
			CircleSmallCorner.Parent = CircleSmall

			BindLabel.Parent = Title
			BindLabel.BackgroundTransparency = 1
			BindLabel.Position = UDim2.new(2.5,0,0,0)
			BindLabel.Size = UDim2.new(0,100,1,0)
			BindLabel.Font = Enum.Font.Gotham
			BindLabel.Text = Key
			BindLabel.TextColor3 = Color3.new(1,1,1)
			BindLabel.TextSize = 14
			BindLabel.TextTransparency = 0.3
			BindLabel.TextXAlignment = Enum.TextXAlignment.Right

			Bind.MouseEnter:Connect(function()
				TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
			end)
			Bind.MouseLeave:Connect(function()
				TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
			end)

			Bind.MouseButton1Click:Connect(function()
				BindLabel.Text = "..."
				TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = PresetColor}):Play()
				TweenService:Create(BindLabel, TweenInfo.new(0.3), {TextColor3 = PresetColor}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = PresetColor}):Play()
				TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
				local inputwait = UserInputService.InputBegan:wait()
				if inputwait.KeyCode.Name ~= "Unknown" then
					BindLabel.Text = inputwait.KeyCode.Name
					Key = inputwait.KeyCode.Name
				end
				TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1)}):Play()
				TweenService:Create(BindLabel, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1)}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(211,211,211)}):Play()
				TweenService:Create(CircleSmall, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			end)

			UserInputService.InputBegan:Connect(function(input, gp)
				if not gp and input.KeyCode.Name == Key then
					pcall(callback)
				end
			end)

			Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
		end

		function ContainerContent:Label(text)
			local Label = Instance.new("TextButton")
			local LabelCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")

			Label.Name = "Label"
			Label.Parent = Container
			Label.BackgroundColor3 = Color3.fromRGB(35,38,43)
			Label.Size = UDim2.new(0,400,0,43)
			Label.AutoButtonColor = false
			Label.Text = ""

			LabelCorner.CornerRadius = UDim.new(0,6)
			LabelCorner.Parent = Label

			Title.Parent = Label
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0.07,0,0,0)
			Title.Size = UDim2.new(0,340,1,0)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.new(1,1,1)
			Title.TextSize = 15
			Title.TextTransparency = 0.3
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
		end

		function ContainerContent:Line()
			local Line = Instance.new("Frame")
			local LineCorner = Instance.new("UICorner")

			Line.Name = "Line"
			Line.Parent = Container
			Line.BackgroundColor3 = Color3.fromRGB(64,68,75)
			Line.Size = UDim2.new(0,400,0,4)

			LineCorner.CornerRadius = UDim.new(0,6)
			LineCorner.Parent = Line

			Container.CanvasSize = UDim2.new(0,0,0,ContainerLayout.AbsoluteContentSize.Y)
		end

		return ContainerContent
	end
	return Tabs
end
return NexusLib