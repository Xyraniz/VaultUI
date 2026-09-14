-- Sentinel
-- A compact Roblox UI library with tabs, buttons, toggles, sliders,
-- keybinds, labels, dropdowns, dragging, and resizing.
--
-- Public API:
--   Sentinel:Window(title)
--   window:Tab(title)
--   tab:Button(title, callback)
--   tab:Toggle(title, value, callback)
--   tab:Label(text), tab:Slider(title, min, max, default, callback)
--   tab:KeyBind(text, keyCode, callback)
--   tab:Dropdown(title, options, callback)
--   dropdown:RefreshDropdown(options)
--
-- The original behaviour and method signatures are preserved; this copy is
-- formatted and documented for use as a reusable VaultUI library entry.

pcall(function()
	game:GetService("CoreGui"):FindFirstChild("ui"):Remove()
end)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
function Library:Window(title)
	local ui = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local UICorner_9 = Instance.new("UICorner")
	local Shadow = Instance.new("ImageLabel")
	local tabs = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Cover = Instance.new("Frame")
	local TabsList = Instance.new("UIListLayout")
	local Top = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local Cover_2 = Instance.new("Frame")
	local Line = Instance.new("Frame")
	local Logo = Instance.new("ImageLabel")
	local Close = Instance.new("ImageButton")
	local GameName = Instance.new("TextLabel")
	local Pages = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local UICorner = Instance.new("UICorner")
	local TabsContainer = Instance.new("Frame")
	local TabsList = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")
	local tabs = Instance.new("Frame")
	local Resize = Instance.new("ImageButton")
	local Cover = Instance.new("Frame")

	ui.Name = "ui"
	ui.Parent = game.CoreGui
	ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Main.Name = "Main"
	Main.Parent = ui
	Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.377, 0, 0.368, 0)
	Main.Size = UDim2.new(0, 470, 0, 283)
	Main.Active = true
	Main.Selectable = true
	Main.Draggable = true

	UICorner_9.CornerRadius = UDim.new(0, 6)
	UICorner_9.Parent = Main

	Shadow.Name = "Shadow"
	Shadow.Parent = Main
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Shadow.BackgroundTransparency = 1.000
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	Shadow.Size = UDim2.new(1, 30, 1, 30)
	Shadow.ZIndex = 0
	Shadow.Image = "rbxassetid://5554236805"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(23, 23, 277, 277)

	tabs.Name = "tabs"
	tabs.Parent = Main
	tabs.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	tabs.BorderSizePixel = 0
	tabs.Position = UDim2.new(0, 0, 0, 35)
	tabs.Size = UDim2.new(0, 122, 1, -35)

	UICorner_2.CornerRadius = UDim.new(0, 6)
	UICorner_2.Parent = tabs

	Cover.Name = "Cover"
	Cover.Parent = tabs
	Cover.AnchorPoint = Vector2.new(1, 0.5)
	Cover.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	Cover.BorderSizePixel = 0
	Cover.Position = UDim2.new(1, 0, 0.5, 0)
	Cover.Size = UDim2.new(0, 5, 1, 0)

	UICorner_2.Parent = tabs

	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 34)

	UICorner_5.CornerRadius = UDim.new(0, 6)
	UICorner_5.Parent = Top

	Cover_2.Name = "Cover"
	Cover_2.Parent = Top
	Cover_2.AnchorPoint = Vector2.new(0.5, 1)
	Cover_2.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	Cover_2.BorderSizePixel = 0
	Cover_2.Position = UDim2.new(0.5, 0, 1, 0)
	Cover_2.Size = UDim2.new(1, 0, 0, 4)

	Line.Name = "Line"
	Line.Parent = Top
	Line.AnchorPoint = Vector2.new(0.5, 1)
	Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Line.BackgroundTransparency = 0.920
	Line.Position = UDim2.new(0.5, 0, 1, 1)
	Line.Size = UDim2.new(1, 0, 0, 1)

	Logo.Name = "Logo"
	Logo.Parent = Top
	Logo.AnchorPoint = Vector2.new(0, 0.5)
	Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Logo.BackgroundTransparency = 1.000
	Logo.Position = UDim2.new(0, 4, 0.5, 0)
	Logo.Size = UDim2.new(0, 26, 0, 30)
	Logo.Image = "http://www.roblox.com/asset/?id=7803241868"
	Logo.ImageColor3 = Color3.fromRGB(232, 17, 85)

	Close.Name = "Close"
	Close.Parent = Top
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Close.BackgroundTransparency = 1.000
	Close.Position = UDim2.new(1, -6, 0.5, 0)
	Close.Size = UDim2.new(0, 20, 0, 20)
	Close.Image = "http://www.roblox.com/asset/?id=7755372427"
	Close.ImageColor3 = Color3.fromRGB(199, 199, 199)
	Close.ScaleType = Enum.ScaleType.Crop
	Close.MouseButton1Click:connect(function()
		ui:Remove()
	end)
	Close.MouseEnter:connect(function()
		TweenService:Create(
			Close,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ ImageColor3 = Color3.fromRGB(255, 255, 255) },
			true
		):Play()
	end)

	Close.MouseLeave:connect(function()
		TweenService:Create(
			Close,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ ImageColor3 = Color3.fromRGB(166, 166, 166) },
			true
		):Play()
	end)

	Resize.Name = "Resize"
	Resize.Parent = Main
	Resize.AnchorPoint = Vector2.new(1, 1)
	Resize.BackgroundTransparency = 1.000
	Resize.Position = UDim2.new(1, -4, 1, -4)
	Resize.Size = UDim2.new(0, 16, 0, 16)
	Resize.ZIndex = 2
	Resize.Image = "rbxassetid://3926307971"
	Resize.ImageColor3 = Color3.fromRGB(186, 13, 68)
	Resize.ImageRectOffset = Vector2.new(204, 364)
	Resize.ImageRectSize = Vector2.new(36, 36)

	GameName.Name = "GameName"
	GameName.Parent = Top
	GameName.AnchorPoint = Vector2.new(0, 0.5)
	GameName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GameName.BackgroundTransparency = 1.000
	GameName.Position = UDim2.new(0, 32, 0.5, 0)
	GameName.Size = UDim2.new(0, 165, 0, 22)
	GameName.Font = Enum.Font.Gotham
	GameName.Text = title or "Game Name"
	GameName.TextColor3 = Color3.fromRGB(232, 17, 85)
	GameName.TextSize = 14.000
	GameName.TextXAlignment = Enum.TextXAlignment.Left

	Pages.Name = "Pages"
	Pages.Parent = Main
	Pages.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Pages.BorderSizePixel = 0
	Pages.Position = UDim2.new(0, 130, 0, 42)
	Pages.Size = UDim2.new(1, -138, 1, -50)

	tabs.Name = "tabs"
	tabs.Parent = Main
	tabs.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	tabs.BorderSizePixel = 0
	tabs.Position = UDim2.new(0, 0, 0, 35)
	tabs.Size = UDim2.new(0, 122, 1, -35)

	TabsContainer.Name = "TabsContainer"
	TabsContainer.Parent = tabs
	TabsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabsContainer.BackgroundTransparency = 1.000
	TabsContainer.Size = UDim2.new(1, 0, 1, 0)

	TabsList.Name = "TabsList"
	TabsList.Parent = TabsContainer
	TabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabsList.SortOrder = Enum.SortOrder.LayoutOrder
	TabsList.Padding = UDim.new(0, 5)

	UIPadding.Parent = TabsContainer
	UIPadding.PaddingTop = UDim.new(0, 5)
	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = tabs

	Cover.Name = "Cover"
	Cover.Parent = tabs
	Cover.AnchorPoint = Vector2.new(1, 0.5)
	Cover.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	Cover.BorderSizePixel = 0
	Cover.Position = UDim2.new(1, 0, 0.5, 0)
	Cover.Size = UDim2.new(0, 5, 1, 0)

	local function GRIR_fake_script() -- Resize.LocalScript
		local script = Instance.new("LocalScript", Resize)

		local mouse = game.Players.LocalPlayer:GetMouse()
		local input = game:GetService("UserInputService")

		local main = main

		local locationX = input:GetMouseLocation().X
		local locationY = input:GetMouseLocation().Y

		local defaultX = 470
		local defaultY = 283

		Resize.MouseButton1Down:Connect(function()
			locationX = input:GetMouseLocation().X
			locationY = input:GetMouseLocation().Y
			local moveConnection
			local releaseConnection
			moveConnection = mouse.Move:Connect(function()
				local DeltaX = input:GetMouseLocation().X - locationX
				local DeltaY = input:GetMouseLocation().Y - locationY

				Main.Size = Main.Size + UDim2.new(0, DeltaX, 0, DeltaY)
				locationX = input:GetMouseLocation().X
				locationY = input:GetMouseLocation().Y
			end)
			releaseConnection = input.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					moveConnection:disconnect()
					releaseConnection:disconnect()
				end
			end)
		end)

		Main.Changed:Connect(function()
			if Main.Size.X.Offset < defaultX then
				Main.Size = UDim2.new(0, defaultX, 0, Main.Size.Y.Offset)
			end
			if Main.Size.Y.Offset < defaultY then
				Main.Size = UDim2.new(0, Main.Size.X.Offset, 0, defaultY)
			end
		end)
	end
	coroutine.wrap(GRIR_fake_script)()

	local Tabs = {}
	function Tabs:Tab(title)
		local UIListLayout = Instance.new("UIListLayout")
		local UIPadding = Instance.new("UIPadding")
		local Page = Instance.new("ScrollingFrame")
		local UICorner = Instance.new("UICorner")
		local TabButton = Instance.new("TextButton")

		TabButton.Name = "TabButton"
		TabButton.Parent = TabsContainer
		TabButton.BackgroundColor3 = Color3.fromRGB(232, 17, 85)
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, -12, 0, 30)
		TabButton.AutoButtonColor = false
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = title or "Home"
		TabButton.TextColor3 = Color3.fromRGB(72, 72, 72)
		TabButton.TextSize = 14.000

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = TabButton

		Page.Name = "Page"
		Page.Visible = false
		Page.Parent = Pages
		Page.Active = true
		Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Page.BackgroundTransparency = 1.000
		Page.BorderSizePixel = 0
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.CanvasPosition = Vector2.new(0, 0)
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Color3.fromRGB(255, 24, 101)

		UIListLayout.Parent = Page
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 6)

		UIPadding.Parent = Page
		UIPadding.PaddingTop = UDim.new(0, 5)

		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
		end)

		TabButton.MouseButton1Click:Connect(function()
			for _, v in next, Pages:GetChildren() do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
				Page.Visible = true
			end
			for _, v in next, TabsContainer:GetChildren() do
				if v.Name == "TabButton" then
					TweenService:Create(
						v,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 1 }
					):Play()
					TweenService:Create(
						v,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ TextColor3 = Color3.fromRGB(72, 72, 72) }
					):Play()
					TweenService:Create(
						TabButton,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 0.6 }
					):Play()
					TweenService:Create(
						TabButton,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ TextColor3 = Color3.fromRGB(255, 255, 255) }
					):Play()
				end
			end
		end)

		local TabFunctions = {}
		function TabFunctions:Button(title, callback)
			local Button = Instance.new("TextButton")
			local UICorner = Instance.new("UICorner")

			callback = callback or function() end

			Button.Name = "Button"
			Button.Text = title or "Button"
			Button.Parent = Page
			Button.BackgroundColor3 = Color3.fromRGB(134, 10, 49)
			Button.BorderSizePixel = 0
			Button.Size = UDim2.new(1, -6, 0, 34)
			Button.AutoButtonColor = false
			Button.Font = Enum.Font.Gotham
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 14.000

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Button

			Button.MouseEnter:Connect(function()
				TweenService:Create(
					Button,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ BackgroundColor3 = Color3.fromRGB(134, 10, 49) }
				):Play()
			end)

			Button.MouseLeave:Connect(function()
				TweenService:Create(
					Button,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ BackgroundColor3 = Color3.fromRGB(185, 13, 68) }
				):Play()
			end)

			Button.MouseButton1Click:Connect(function()
				callback()
			end)
		end
		function TabFunctions:Toggle(title, value, callback)
			local Toggle = Instance.new("TextButton")
			local UICorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Toggle_2 = Instance.new("Frame")
			local Stroke = Instance.new("UIStroke")
			local Checked = Instance.new("ImageLabel")
			value = value or false

			Toggle.Name = "Toggle"
			Toggle.Parent = Page
			Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Toggle.Size = UDim2.new(1, -6, 0, 34)
			Toggle.AutoButtonColor = false
			Toggle.Font = Enum.Font.SourceSans
			Toggle.Text = ""
			Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
			Toggle.TextSize = 14.000

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Toggle

			Title.Name = "Title"
			Title.Parent = Toggle
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 8, 0, 0)
			Title.Size = UDim2.new(1, -6, 1, 0)
			Title.Font = Enum.Font.Gotham
			Title.Text = "Toggle"
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 14.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Toggle_2.Name = "Toggle"
			Toggle_2.Parent = Toggle
			Toggle_2.AnchorPoint = Vector2.new(1, 0.5)
			Toggle_2.BackgroundColor3 = Color3.fromRGB(161, 12, 59)
			Toggle_2.BackgroundTransparency = 1.000
			Toggle_2.BorderSizePixel = 0
			Toggle_2.Position = UDim2.new(1, -8, 0.5, 0)
			Toggle_2.Size = UDim2.new(0, 14, 0, 14)

			Checked.Name = "Checked"
			Checked.Parent = Toggle_2
			Checked.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Checked.BackgroundTransparency = 1.000
			Checked.Position = UDim2.new(-0.214285731, 0, -0.214285731, 0)
			Checked.Size = UDim2.new(0, 20, 0, 20)
			Checked.Image = "http://www.roblox.com/asset/?id=7812909048"
			Checked.ImageTransparency = 1
			Checked.ScaleType = Enum.ScaleType.Fit

			Stroke.Parent = Toggle_2
			Stroke.LineJoinMode = Enum.LineJoinMode.Round
			Stroke.Thickness = 2
			Stroke.Color = Color3.fromRGB(161, 12, 59)
			Toggle.MouseEnter:Connect(function()
				TweenService:Create(
					Toggle,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ BackgroundColor3 = Color3.fromRGB(40, 40, 40) },
					true
				):Play()
			end)

			Toggle.MouseLeave:Connect(function()
				TweenService:Create(
					Toggle,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{ BackgroundColor3 = Color3.fromRGB(35, 35, 35) },
					true
				):Play()
			end)

			local toggled = value
			if toggled then
				TweenService:Create(
					Toggle_2,
					TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ BackgroundTransparency = 0 },
					true
				):Play()
				callback(toggled)
			end

			Toggle.MouseButton1Click:Connect(function()
				if toggled then
					toggled = false
					TweenService:Create(
						Toggle_2,
						TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 1 },
						true
					):Play()
					TweenService:Create(
						Checked,
						TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ ImageTransparency = 1 },
						true
					):Play()
				else
					toggled = true
					TweenService:Create(
						Toggle_2,
						TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 0 },
						true
					):Play()
					TweenService:Create(
						Checked,
						TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ ImageTransparency = 0 },
						true
					):Play()
				end
				callback(toggled)
			end)
		end
		function TabFunctions:Label(labeltext)
			local TextLabel = Instance.new("TextLabel")
			local UICorner_6 = Instance.new("UICorner")

			TextLabel.Parent = Page
			TextLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.198795184, 0, 0.0214592274, 0)
			TextLabel.Size = UDim2.new(1, -6, 0, 34)
			TextLabel.Font = Enum.Font.Gotham
			TextLabel.Text = "  " .. labeltext or "   Label"
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextSize = 14.000
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UICorner_6.CornerRadius = UDim.new(0, 6)
			UICorner_6.Parent = TextLabel
		end
		function TabFunctions:Slider(title, min, max, def, callback)
			local dragging = false
			local Slider = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local SliderClick = Instance.new("TextButton")
			local UICorner_2 = Instance.new("UICorner")
			local SliderDrag = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local Value = Instance.new("TextLabel")

			Slider.Name = "Slider"
			Slider.Parent = Page
			Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Slider.Position = UDim2.new(0, 0, 0.515021443, 0)
			Slider.Size = UDim2.new(1, -6, 0, 48)

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Slider

			Title.Name = "Title"
			Title.Parent = Slider
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 8, 0, 0)
			Title.Size = UDim2.new(1, -6, 0, 34)
			Title.Font = Enum.Font.Gotham
			Title.Text = title or "Slider"
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 14.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			SliderClick.Name = "SliderClick"
			SliderClick.Parent = Slider
			SliderClick.AnchorPoint = Vector2.new(0.5, 1)
			SliderClick.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
			SliderClick.Position = UDim2.new(0.5, 0, 1, -8)
			SliderClick.Size = UDim2.new(1, -12, 0, 6)
			SliderClick.AutoButtonColor = false
			SliderClick.Text = ""

			UICorner_2.CornerRadius = UDim.new(0, 6)
			UICorner_2.Parent = SliderClick

			SliderDrag.Name = "SliderDrag"
			SliderDrag.Parent = SliderClick
			SliderDrag.BackgroundColor3 = Color3.fromRGB(188, 14, 69)
			SliderDrag.Size = UDim2.new(0, 120, 1, 0)

			UICorner_3.CornerRadius = UDim.new(0, 6)
			UICorner_3.Parent = SliderDrag

			Value.Name = "Value"
			Value.Parent = Slider
			Value.AnchorPoint = Vector2.new(1, 0)
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1.000
			Value.Position = UDim2.new(1, -10, 0, 0)
			Value.Size = UDim2.new(1, 0, 0, 34)
			Value.Font = Enum.Font.Gotham
			Value.Text = tostring(def)
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = 14.000
			Value.TextXAlignment = Enum.TextXAlignment.Right

			callback = callback or function() end

			local function slide(input)
				local pos = UDim2.new(
					math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1),
					0,
					0,
					6
				)
				SliderDrag:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
				local s = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
				Value.Text = tostring(s)
				callback(s)
			end

			SliderClick.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slide(input)
					dragging = true
				end
			end)

			SliderClick.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					slide(input)
				end
			end)
		end
		function TabFunctions:KeyBind(text, keypreset, callback)
			local binding = false
			callback = callback or function() end
			local Key = keypreset.Name
			local KeyBind = Instance.new("TextButton")
			local UICorner_7 = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local CurrentKey = Instance.new("TextLabel")
			local UICorner_8 = Instance.new("UICorner")

			KeyBind.Name = "KeyBind"
			KeyBind.Parent = Page
			KeyBind.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			KeyBind.Size = UDim2.new(1, -6, 0, 34)
			KeyBind.AutoButtonColor = false
			KeyBind.Font = Enum.Font.SourceSans
			KeyBind.Text = ""
			KeyBind.TextColor3 = Color3.fromRGB(0, 0, 0)
			KeyBind.TextSize = 14.000

			UICorner_7.CornerRadius = UDim.new(0, 6)
			UICorner_7.Parent = KeyBind

			Title.Name = "Title"
			Title.Parent = KeyBind
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 8, 0, 0)
			Title.Size = UDim2.new(1, -6, 1, 0)
			Title.Font = Enum.Font.Gotham
			Title.Text = text or "KeyBind"
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 14.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			CurrentKey.Name = "CurrentKey"
			CurrentKey.Parent = KeyBind
			CurrentKey.AnchorPoint = Vector2.new(1, 0.5)
			CurrentKey.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
			CurrentKey.Position = UDim2.new(1, -6, 0.5, 0)
			CurrentKey.Size = UDim2.new(-0, 46, 0, 24)
			CurrentKey.Font = Enum.Font.Gotham
			CurrentKey.Text = Key or ". . ."
			CurrentKey.TextColor3 = Color3.fromRGB(255, 255, 255)
			CurrentKey.TextSize = 14.000

			UICorner_8.CornerRadius = UDim.new(0, 4)
			UICorner_8.Parent = CurrentKey

			KeyBind.MouseButton1Click:Connect(function()
				CurrentKey.Text = ". . ."
				local a, b = game:GetService("UserInputService").InputBegan:wait()
				if a.KeyCode.Name ~= "Unknown" then
					CurrentKey.Text = a.KeyCode.Name
					Key = a.KeyCode.Name
				end
			end)

			game:GetService("UserInputService").InputBegan:connect(function(current, ok)
				if not ok then
					if current.KeyCode.Name == Key then
						callback(Key)
					end
				end
			end)
		end
		function TabFunctions:Dropdown(title, list, callback)
			list = list or {}
			callback = callback or function() end
			local Dropdown = Instance.new("Frame")
			local UIListLayout_69 = Instance.new("UIListLayout")
			local Choose = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local arrow = Instance.new("ImageButton")
			local OptionHolder = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local OptionList = Instance.new("UIListLayout")
			local UIPadding = Instance.new("UIPadding")

			Dropdown.Name = "Dropdown"
			Dropdown.Parent = Page
			Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Dropdown.BackgroundTransparency = 1.000
			Dropdown.BorderColor3 = Color3.fromRGB(27, 42, 53)
			Dropdown.BorderSizePixel = 0
			Dropdown.ClipsDescendants = true
			Dropdown.Position = UDim2.new(0, 0, -0.296137333, 0)
			Dropdown.Size = UDim2.new(1, -6, 0, 34)

			UIListLayout_69.Parent = Dropdown
			UIListLayout_69.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout_69.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_69.Padding = UDim.new(0, 5)

			local dropped = false
			Choose.Name = "Choose"
			Choose.Parent = Dropdown
			Choose.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Choose.BorderSizePixel = 0
			Choose.Size = UDim2.new(1, 0, 0, 34)

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Choose

			Title.Name = "Title"
			Title.Parent = Choose
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 8, 0, 0)
			Title.Size = UDim2.new(1, -6, 1, 0)
			Title.Font = Enum.Font.Gotham
			Title.Text = title or "Dropdowm"
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 14.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			arrow.Name = "arrow"
			arrow.Parent = Choose
			arrow.AnchorPoint = Vector2.new(1, 0.5)
			arrow.BackgroundTransparency = 1.000
			arrow.LayoutOrder = 10
			arrow.Position = UDim2.new(1, -2, 0.5, 0)
			arrow.Size = UDim2.new(0, 28, 0, 28)
			arrow.ZIndex = 2
			arrow.Image = "rbxassetid://3926307971"
			arrow.ImageColor3 = Color3.fromRGB(161, 12, 59)
			arrow.ImageRectOffset = Vector2.new(324, 524)
			arrow.ImageRectSize = Vector2.new(36, 36)
			arrow.ScaleType = Enum.ScaleType.Crop

			OptionHolder.Name = "OptionHolder"
			OptionHolder.Parent = Dropdown
			OptionHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			OptionHolder.BorderSizePixel = 0
			OptionHolder.Size = UDim2.new(1, 0, 1, -38)

			UICorner_2.CornerRadius = UDim.new(0, 6)
			UICorner_2.Parent = OptionHolder

			OptionList.Name = "OptionList"
			OptionList.Parent = OptionHolder
			OptionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
			OptionList.SortOrder = Enum.SortOrder.LayoutOrder
			OptionList.Padding = UDim.new(0, 5)

			UIPadding.Parent = OptionHolder
			UIPadding.PaddingTop = UDim.new(0, 8)

			Choose.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					if not dropped then
						Dropdown:TweenSize(
							UDim2.new(1, -7, 0, UIListLayout_69.AbsoluteContentSize.Y),
							Enum.EasingDirection.Out,
							Enum.EasingStyle.Quad,
							0.15,
							true
						)
						TweenService:Create(
							arrow,
							TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{ Rotation = 180 },
							true
						):Play()
						dropped = true
					else
						TweenService:Create(
							arrow,
							TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{ Rotation = 0 },
							true
						):Play()
						Dropdown:TweenSize(
							UDim2.new(1, -7, 0, 34),
							Enum.EasingDirection.Out,
							Enum.EasingStyle.Quad,
							0.12
						)
						dropped = false
					end
				end
			end)

			for i, v in next, list do
				local Option = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")

				Option.Name = "Option"
				Option.Parent = OptionHolder
				Option.BackgroundColor3 = Color3.fromRGB(134, 10, 49)
				Option.BorderSizePixel = 0
				Option.Size = UDim2.new(1, -16, 0, 30)
				Option.AutoButtonColor = false
				Option.Font = Enum.Font.Gotham
				Option.Text = v
				Option.TextColor3 = Color3.fromRGB(255, 255, 255)
				Option.TextSize = 14.000

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = Option

				Option.MouseButton1Click:Connect(function()
					callback(v)
					dropped = false
					TweenService:Create(
						arrow,
						TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ Rotation = 0 }
					):Play()
					Dropdown:TweenSize(
						UDim2.new(1, -5, 0, 34),
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Quart,
						0.15,
						true
					)
					Title.Text = title .. ": " .. v
				end)
				OptionHolder:TweenSize(
					UDim2.new(1, 0, 0, OptionList.AbsoluteContentSize.Y + 15),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					0.15,
					true
				)
			end

			local DropdownFunc = {}
			function DropdownFunc:RefreshDropdown(newlist)
				dropped = false
				TweenService
					:Create(
						arrow,
						TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ Rotation = 0 }
					)
					:Play()
				Dropdown:TweenSize(
					UDim2.new(1, -5, 0, 34),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					0.15,
					true
				)

				local newlist = newlist or {}
				for i, v in next, OptionHolder:GetChildren() do
					if v:IsA("TextButton") then
						v:Destroy()
					end
				end

				for i, v in next, newlist do
					local Option = Instance.new("TextButton")
					local UICorner = Instance.new("UICorner")

					Option.Name = "Option"
					Option.Parent = OptionHolder
					Option.BackgroundColor3 = Color3.fromRGB(134, 10, 49)
					Option.BorderSizePixel = 0
					Option.Size = UDim2.new(1, -16, 0, 30)
					Option.AutoButtonColor = false
					Option.Font = Enum.Font.Gotham
					Option.Text = v
					Option.TextColor3 = Color3.fromRGB(255, 255, 255)
					Option.TextSize = 14.000

					UICorner.CornerRadius = UDim.new(0, 6)
					UICorner.Parent = Option

					Option.MouseButton1Click:Connect(function()
						callback(v)
						dropped = false
						TweenService:Create(
							arrow,
							TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{ Rotation = 0 }
						):Play()
						Dropdown:TweenSize(
							UDim2.new(1, -5, 0, 34),
							Enum.EasingDirection.Out,
							Enum.EasingStyle.Quart,
							0.2,
							true
						)
						Title.Text = title .. ": " .. v
					end)
				end
				OptionHolder:TweenSize(
					UDim2.new(1, 0, 0, OptionList.AbsoluteContentSize.Y + 15),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					0.15,
					true
				)
			end
			return DropdownFunc
		end
		return TabFunctions
	end
	return Tabs
end
return Library
