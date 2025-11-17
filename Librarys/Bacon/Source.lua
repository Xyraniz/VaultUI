-- BaconLib v1.2 by H3x0R
_BLVersion = "1.2"
_BLChangelog = [[
    v1.1:
        Added keybinds, sliders, and you have asked, so you got dropdowns too!
        Made custom smooth drag because Roblox's sucks.
        Made the gui delete on re-execution.
        Fixed a bug where Container.Size.Y.Offset would increase if close is used too fast.
        Revised code.
        [PRERELEASE-BUGFIX]: Fixed where the slider wouldn't give the correct value.
        [PRERELEASE-BUGFIX]: Fixed where the slider would be off when you move the ui and change.
    v1.2:
        Added callbacks for textboxes.
        Bugfixes.
]]

repeat game:GetService("RunService").RenderStepped:Wait() until game:IsLoaded() == true

local library = {}
local nextAllignmentAnchor = 10

for _, gui in pairs(game:GetService("CoreGui").RobloxGui:GetChildren()) do
    if gui:IsA("ScreenGui") and string.match(gui.Name, "_BACONLIB") then
        gui:Destroy()
    end
end

for _, gui in pairs(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
    if gui:IsA("ScreenGui") and string.match(gui.Name, "_BACONLIB") then
        gui:Destroy()
    end
end

function library:CreateWindow(name, keyCode)
	if name == nil then error("Specify a name.", 0) return false end
	if not typeof(name) == "string" then error("Specify your name as a string.", 0) return false end
	
	local randomize = Instance.new("ScreenGui")
	local TopBar = Instance.new("Frame")
	local Container = Instance.new("Frame")
	local TopLabel = Instance.new("TextLabel")
	local SizeToggle = Instance.new("TextButton")
	local listLayout = Instance.new("UIListLayout")
	
	randomize.Name = tostring(math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9).."_BACONLIB")
	randomize.Parent = game:GetService("CoreGui").RobloxGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	randomize.DisplayOrder = 100
	randomize.ResetOnSpawn = false
	
	TopBar.Name = "TopBar"
	TopBar.Parent = randomize
	-- Custom drag system added.
	--TopBar.Active = true
	--TopBar.Draggable = true
	TopBar.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	TopBar.BorderSizePixel = 0
	TopBar.Position = UDim2.new(0.489757448, 0, 0.489311516, 0)
	TopBar.Size = UDim2.new(0, 240, 0, 30)
	TopBar.ZIndex = 0
	
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	
	local dragging;
    local dragInput;
    local dragStart;
    local startPos;
    
    local function change(a)
    	local diff = a.Position - dragStart
        local tween = TweenService:Create(TopBar, tweenInfo, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + diff.X, startPos.Y.Scale, startPos.Y.Offset + diff.Y)})
        
        tween:Play()
    end
    
    TopBar.InputBegan:Connect(function(a)
        if a.UserInputType == Enum.UserInputType.MouseButton1 or a.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = a.Position
		    startPos = TopBar.Position
		    
		    a.Changed:Connect(function()
		        if a.UserInputState == Enum.UserInputState.End then
		            dragging = false
		        end
		    end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(a)
        if a.UserInputType == Enum.UserInputType.MouseMovement or a.UserInputType == Enum.UserInputType.Touch then
            dragInput = a
        end
    end)
    
    UserInputService.InputChanged:Connect(function(a)
        if a == dragInput and dragging == true then
            change(a)
        end
    end)
	
	-- This is a good spot to put the keybind code so...
	if keyCode == nil then -- this will keep older UIs from breaking
	    keyCode = Enum.KeyCode.RightShift
	end
	
	warn(name..": Press ["..tostring(keyCode).."] to show/hide the UI.")
	UserInputService.InputBegan:Connect(function()
	    if UserInputService:IsKeyDown(keyCode) then
	        if randomize.Enabled == false then
	            randomize.Enabled = true
	        else
	            randomize.Enabled = false
	        end
	    end
	end)
	
	Container.Name = "Container"
	Container.Parent = TopBar
	Container.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	Container.BorderSizePixel = 0
	Container.ClipsDescendants = true
	Container.Position = UDim2.new(-0.000485992437, 0, 0.974092603, 0)
	Container.Size = UDim2.new(0, 240, 0, 0)
	
	TopLabel.Name = "TopLabel"
	TopLabel.Parent = TopBar
	TopLabel.Active = true
	TopLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TopLabel.BackgroundTransparency = 1.000
	TopLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopLabel.BorderSizePixel = 0
	TopLabel.Position = UDim2.new(0.0291666668, 0, -0.00833333377, 0)
	TopLabel.Selectable = true
	TopLabel.Size = UDim2.new(0, 202, 0, 30)
	TopLabel.ZIndex = 0
	TopLabel.Text = name
	TopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TopLabel.TextSize = 14.000
	TopLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	TopLabel.TextWrapped = true
	TopLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	SizeToggle.Name = "SizeToggle"
	SizeToggle.Parent = TopBar
	SizeToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	SizeToggle.BackgroundTransparency = 1.000
	SizeToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SizeToggle.BorderSizePixel = 0
	SizeToggle.Position = UDim2.new(0.872619033, 0, -0.00833332539, 0)
	SizeToggle.Size = UDim2.new(0, 30, 0, 30)
	SizeToggle.Modal = true
	SizeToggle.Text = "-"
	SizeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	SizeToggle.TextScaled = true
	SizeToggle.TextSize = 14.000
	SizeToggle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	SizeToggle.TextWrapped = true
	
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = Container
	
	-- Setup the scripting part
	spawn(function()
		local TweenService = game:GetService("TweenService") 
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local tween
		
		local open = true
		local debounce = false
		
		local savedOffset = 0
		SizeToggle.MouseButton1Down:Connect(function()
			if debounce == false then
				debounce = true
				if open == true then
					savedOffset = Container.Size.Y.Offset
					tween = TweenService:Create(Container, tweenInfo, {Size = Container.Size - UDim2.new(0, 0, 0, Container.Size.Y.Offset)})
					tween:Play()
					SizeToggle.Text = "+"
					open = false
				else
					tween = TweenService:Create(Container, tweenInfo, {Size = Container.Size + UDim2.new(0, 0, 0, savedOffset)})
					tween:Play()
					SizeToggle.Text = "-"
					open = true
				end
				
				wait(0.35)
				debounce = false
			end
		end)
	end)
	
	-- Align GUI
	TopBar.Position = UDim2.new(0, nextAllignmentAnchor, 0, 10)
	nextAllignmentAnchor = nextAllignmentAnchor + 250
	
	return randomize
end

local Notifications = {}

function library:CreateNotification(title, txt)
	local ScreenGui = Instance.new("ScreenGui")
	local a_notif_owo = Instance.new("Frame")
	local TopBar = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local Container = Instance.new("Frame")
	local Text = Instance.new("TextLabel")
	
	ScreenGui.Name = tostring(math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9)..math.random(0, 9).."_BACONLIB")
	ScreenGui.Parent = game:GetService("CoreGui").RobloxGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	a_notif_owo.Name = "a_notif_owo"
	a_notif_owo.Parent = ScreenGui
	a_notif_owo.Active = true
	a_notif_owo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	a_notif_owo.BackgroundTransparency = 0.900
	a_notif_owo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	a_notif_owo.BorderSizePixel = 0
	a_notif_owo.Size = UDim2.new(0, 278, 0, 146)
	
	TopBar.Name = "TopBar"
	TopBar.Parent = a_notif_owo
	TopBar.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	TopBar.BorderSizePixel = 0
	TopBar.Size = UDim2.new(0, 278, 0, 29)
	TopBar.ZIndex = 999 - #Notifications
	
	Title.Name = "Title"
	Title.Parent = TopBar
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0, 0, -0.00985222869, 0)
	Title.Size = UDim2.new(0, 278, 0, 27)
	Title.Font = Enum.Font.SourceSans
	Title.Text = title
	Title.TextColor3 = Color3.fromRGB(208, 208, 208)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true
	
	Container.Name = "Container"
	Container.Parent = TopBar
	Container.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	Container.BorderSizePixel = 0
	Container.Position = UDim2.new(0, 0, 0.975474417, 0)
	Container.Size = UDim2.new(0, 278, 0, 118)
	Container.ZIndex = 998
	
	Text.Name = "Text"
	Text.Parent = Container
	Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Text.BackgroundTransparency = 1.000
	Text.Size = UDim2.new(0, 278, 0, 118)
	Text.Font = Enum.Font.SourceSans
	Text.Text = txt --"actz kiss 3dsboy08"
	Text.TextColor3 = Color3.fromRGB(208, 208, 208)
	Text.TextSize = 25.000
	Text.TextWrapped = true
	Text.TextYAlignment = Enum.TextYAlignment.Top
	
	local Frame = a_notif_owo
	
	local Dimensions = workspace.CurrentCamera.ViewportSize
	local ScreenX = Dimensions.X
	local ScreenY = Dimensions.Y
	
	local Padding = 25
	
	local PaddingX = ScreenX - Padding
	local PaddingY = (ScreenY - Padding) - (Padding + 8)
	
	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	
	Frame.Position = UDim2.new(0, ScreenX, 0, ScreenY)
	--wait(3)
	if #Notifications > 0 then
		local Frame2 = Notifications[#Notifications]
		--print(Frame2.Position.Y.Offset)
		local Tween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0, (PaddingX - Frame.Size.X.Offset), 0, ((Frame2.Position.Y.Offset - Padding) - Frame2.Size.Y.Offset))})
		Tween:Play()
		--print("played")
	else
		local Tween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0, (PaddingX - Frame.Size.X.Offset), 0, (PaddingY - Frame.Size.Y.Offset))})
		Tween:Play()
	end
	
	table.insert(Notifications, Frame)
	coroutine.wrap(function()
		wait(4)
		table.remove(Notifications, table.find(Notifications, Frame))
		
		local Tween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0, ScreenX, 0, (Frame.Position.Y.Offset))})
		Tween:Play()
	end)()
end

function increase(window)
	window.TopBar.Container.Size = UDim2.new(0, 240, 0, window.TopBar.Container.Size.Y.Offset + 40)
end

function library:CreateLabel(window, text)
	if not window:IsA("ScreenGui") then error("Specify a gui.", 0) return false end
	if not window:FindFirstChild("TopBar") then error("That's not a gui created by the library!", 0) return false end
	if not typeof(text) == "string" then error("The second argument isn't a string!", 0) return false end
	
	local omg_its_a_label = Instance.new("Frame")
	local Label = Instance.new("TextLabel")
	
	omg_its_a_label.LayoutOrder = 1
	omg_its_a_label.Name = "omg_its_a_label"
	omg_its_a_label.Parent = window.TopBar.Container
	omg_its_a_label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	omg_its_a_label.BackgroundTransparency = 1.000
	omg_its_a_label.BorderColor3 = Color3.fromRGB(0, 0, 0)
	omg_its_a_label.BorderSizePixel = 0
	omg_its_a_label.Size = UDim2.new(0, 240, 0, 40)
	
	Label.Name = "Label"
	Label.Parent = omg_its_a_label
	Label.Active = true
	Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Label.BackgroundTransparency = 1.000
	Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label.BorderSizePixel = 0
	Label.Position = UDim2.new(0.0291666668, 0, 0.125, 0)
	Label.Selectable = true
	Label.Size = UDim2.new(0, 227, 0, 30)
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 15.000
	Label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextWrapped = true
	increase(window)
	
	return Label
end

function library:CreateButton(window, text, func)
	if not window:IsA("ScreenGui") then error("Specify a gui.", 0) return false end
	if not window:FindFirstChild("TopBar") then error("That's not a gui created by the library!", 0) return false end
	if not typeof(text) == "string" then error("The second argument isn't a string!", 0) return false end
	if not typeof(func) == "function" then error("The third argument isn't a function!", 0) return false end
	
	local xd_button_yey = Instance.new("Frame")
	local Button = Instance.new("TextButton")
	
	xd_button_yey.LayoutOrder = 1
	xd_button_yey.Name = "xd_button_yey"
	xd_button_yey.Parent = window.TopBar.Container
	xd_button_yey.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	xd_button_yey.BackgroundTransparency = 1.000
	xd_button_yey.BorderColor3 = Color3.fromRGB(0, 0, 0)
	xd_button_yey.BorderSizePixel = 0
	xd_button_yey.Size = UDim2.new(0, 240, 0, 40)
	
	Button.Name = "Button"
	Button.Parent = xd_button_yey
	Button.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Button.BorderSizePixel = 0
	Button.Position = UDim2.new(0.0291666668, 0, 0.125, 0)
	Button.Size = UDim2.new(0, 227, 0, 30)
	Button.Text = text
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextSize = 15.000
	Button.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextWrapped = true
	increase(window)
	Button.MouseButton1Down:Connect(func)
	
	return Button
end

function library:CreateTextBox(window, font, placeholderText, text, callback)
	if not window:IsA("ScreenGui") then error("Specify a gui.", 0) return false end
	if not window:FindFirstChild("TopBar") then error("That's not a gui created by the library!", 0) return false end
	if not typeof(font) == "EnumItem" then error("The second argument isn't a font enum!", 0) return false end
	if not typeof(text) == "string" then error("The third argument isn't a string!", 0) return false end
	if not typeof(placeholderText) == "string" then error("The fourth argument isn't a string!", 0) return false end
	
	local o_no_its_a_textbox = Instance.new("Frame")
	local _TextBox = Instance.new("TextBox")
	
	o_no_its_a_textbox.LayoutOrder = 1
	o_no_its_a_textbox.Name = "o_no_its_a_textbox"
	o_no_its_a_textbox.Parent = window.TopBar.Container
	o_no_its_a_textbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	o_no_its_a_textbox.BackgroundTransparency = 1.000
	o_no_its_a_textbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	o_no_its_a_textbox.BorderSizePixel = 0
	o_no_its_a_textbox.Size = UDim2.new(0, 240, 0, 40)
	
	_TextBox.Name = "TextBox"
	_TextBox.Parent = o_no_its_a_textbox
	_TextBox.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	_TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	_TextBox.BorderSizePixel = 0
	_TextBox.Position = UDim2.new(0.0291666668, 0, 0.125, 0)
	_TextBox.Size = UDim2.new(0, 227, 0, 30)
	_TextBox.ClearTextOnFocus = false
	_TextBox.Font = font
	_TextBox.Text = text
	_TextBox.PlaceholderText = placeholderText
	_TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	_TextBox.TextScaled = true
	_TextBox.TextSize = 15.000
	_TextBox.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	_TextBox.TextWrapped = true
	_TextBox.InputBegan:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Return then
	        if callback and type(callback) == "function" then callback(_TextBox.Text) end
	    end
	end)
	
	increase(window)
	
	return _TextBox
end

function library:CreateToggle(window, text, currentState, func)
	if not window:IsA("ScreenGui") then error("Specify a gui.", 0) return false end
	if not window:FindFirstChild("TopBar") then error("That's not a gui created by the library!", 0) return false end
	if not typeof(text) == "string" then error("The second argument isn't a string!", 0) return false end
	if not typeof(currentState) == "boolean" then error("The third argument isn't a boolean!", 0) return false end
	if not typeof(func) == "function" then error("The fourth argument isn't a function!", 0) return false end
	
	local wow_a_toggle_owo = Instance.new("Frame")
	local ToggleBtn = Instance.new("TextButton")
	local ToggleBtn_Roundify_4px = Instance.new("ImageLabel")
	local ToggleLabel = Instance.new("TextLabel")
	
	wow_a_toggle_owo.LayoutOrder = 1
	wow_a_toggle_owo.Name = "wow_a_toggle_owo"
	wow_a_toggle_owo.Parent = window.TopBar.Container
	wow_a_toggle_owo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	wow_a_toggle_owo.BackgroundTransparency = 1.000
	wow_a_toggle_owo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	wow_a_toggle_owo.BorderSizePixel = 0
	wow_a_toggle_owo.Size = UDim2.new(0, 240, 0, 40)
	
	ToggleBtn.Name = "ToggleBtn"
	ToggleBtn.Parent = wow_a_toggle_owo
	ToggleBtn.Active = false
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ToggleBtn.BackgroundTransparency = 1.000
	ToggleBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ToggleBtn.BorderSizePixel = 0
	ToggleBtn.Position = UDim2.new(0.850000024, 0, 0, 5)
	ToggleBtn.Selectable = false
	ToggleBtn.Size = UDim2.new(0, 30, 0, 30)
	ToggleBtn.Text = ""
	ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
	ToggleBtn.TextSize = 1.000
	ToggleBtn.TextTransparency = 1.000
	ToggleBtn.TextWrapped = true
	
	ToggleBtn_Roundify_4px.Name = "ToggleBtn_Roundify_4px"
	ToggleBtn_Roundify_4px.Parent = ToggleBtn
	ToggleBtn_Roundify_4px.AnchorPoint = Vector2.new(0.5, 0.5)
	ToggleBtn_Roundify_4px.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ToggleBtn_Roundify_4px.BackgroundTransparency = 1.000
	ToggleBtn_Roundify_4px.Position = UDim2.new(0.5, 0, 0.5, 0)
	ToggleBtn_Roundify_4px.Size = UDim2.new(1, 0, 1, 0)
	ToggleBtn_Roundify_4px.Image = "rbxassetid://3570695787"
	
	if currentState == false then
		ToggleBtn_Roundify_4px.ImageColor3 = Color3.fromRGB(255, 57, 60)
	else
		ToggleBtn_Roundify_4px.ImageColor3 = Color3.fromRGB(96, 188, 25)
	end
	ToggleBtn_Roundify_4px.ScaleType = Enum.ScaleType.Slice
	ToggleBtn_Roundify_4px.SliceCenter = Rect.new(100, 100, 100, 100)
	ToggleBtn_Roundify_4px.SliceScale = 0.040
	
	ToggleLabel.Name = "ToggleLabel"
	ToggleLabel.Parent = wow_a_toggle_owo
	ToggleLabel.Active = true
	ToggleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ToggleLabel.BackgroundTransparency = 1.000
	ToggleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ToggleLabel.BorderSizePixel = 0
	ToggleLabel.Position = UDim2.new(0.0291666668, 0, 0.125, 0)
	ToggleLabel.Selectable = true
	ToggleLabel.Size = UDim2.new(0, 190, 0, 30)
	ToggleLabel.Text = text
	ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleLabel.TextSize = 15.000
	ToggleLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	ToggleLabel.TextWrapped = true
	ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
	increase(window)
	
	local TweenService = game:GetService("TweenService")
	local red = Color3.fromRGB(255, 57, 60)
	local green = Color3.fromRGB(96, 188, 25)
	
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	
	local toggled = currentState
	ToggleBtn.MouseButton1Down:Connect(function()
		-- warn("M C N U G G E T  G O O D  F O R  Y O U")
		
		local tween
		if toggled == true then
			toggled = false
			tween = TweenService:Create(ToggleBtn_Roundify_4px, tweenInfo, {ImageColor3 = red})
		else
			toggled = true
			tween = TweenService:Create(ToggleBtn_Roundify_4px, tweenInfo, {ImageColor3 = green})
		end
		
		tween:Play()
		--print(toggled)
		func(toggled)
	end)
	
	return ToggleBtn
end

function library:CreateSlider(window, name, min, max, current, callback)
	local woah_a_slider = Instance.new("Frame")
	local Bar = Instance.new("TextButton")
	local Current = Instance.new("Frame")
	local Value = Instance.new("TextLabel")
	local Label = Instance.new("TextLabel")
	
	woah_a_slider.LayoutOrder = 1
	woah_a_slider.Name = "woah_a_slider"
	woah_a_slider.Parent = window.TopBar.Container
	woah_a_slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	woah_a_slider.BackgroundTransparency = 1.000
	woah_a_slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
	woah_a_slider.BorderSizePixel = 0
	woah_a_slider.Size = UDim2.new(0, 240, 0, 56)
	
	Bar.Name = "Bar"
	Bar.Parent = woah_a_slider
	Bar.AnchorPoint = Vector2.new(0.5, 0.5)
	Bar.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Bar.BorderSizePixel = 0
	Bar.ClipsDescendants = true
	Bar.Position = UDim2.new(0, 120, 0, 34)
	Bar.Size = UDim2.new(0, 227, 0, 24)
	Bar.AutoButtonColor = false
	Bar.Font = Enum.Font.SourceSans
	Bar.Text = ""
	Bar.TextColor3 = Color3.fromRGB(0, 0, 0)
	Bar.TextSize = 14.000
	
	Current.Name = "Current"
	Current.Parent = Bar
	Current.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
	Current.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Current.BorderSizePixel = 0
	Current.Size = UDim2.new(0.5, 0, 1, 0)
	
	Value.Name = "Value"
	Value.Parent = Bar
	Value.Active = true
	Value.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Value.BackgroundTransparency = 1.000
	Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Value.BorderSizePixel = 0
	Value.Position = UDim2.new(-0.00183696998, 0, -0.0833333358, 2)
	Value.Size = UDim2.new(0, 227, 0, 24)
	Value.Text = tostring(current)
	Value.TextColor3 = Color3.fromRGB(255, 255, 255)
	Value.TextScaled = true
	Value.TextSize = 15.000
	Value.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	Value.TextWrapped = true
	
	Label.Name = "Label"
	Label.Parent = woah_a_slider
	Label.Active = true
	Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Label.BackgroundTransparency = 1.000
	Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label.BorderSizePixel = 0
	Label.Position = UDim2.new(0.0289999992, 0, 0, 2)
	Label.Selectable = true
	Label.Size = UDim2.new(0, 202, 0, 18)
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextScaled = true
	Label.TextSize = 15.000
	Label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextWrapped = true
	Label.TextXAlignment = Enum.TextXAlignment.Left
	
	coroutine.wrap(function()
		local script = Instance.new('LocalScript', Bar)
		script.Name = "FAKESCRIPT"
		
		function getSize(Bar, min, max)
			max = max - min -- i hate math
			
			local BarSize = Bar.AbsoluteSize.X
			local CurrBarSize = Bar.Current.Size.X.Offset
			local Value = min + (max * (CurrBarSize / BarSize))
			local Size = math.floor(Value)
			
			return Size
		end
		
		function setSize(Bar, max, min, curr)
			Bar.Current.Size = UDim2.new(0, ((curr / (max + min)) * Bar.AbsoluteSize.X), 1, 0)
		end
		
		local UserInputService = game:GetService("UserInputService")
		
		local TweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		
		local Bar = script.Parent
		local CurrBar = Bar.Current
		local ValueTxt = Bar.Value
		
		local PlayerMouse = game:GetService("Players").LocalPlayer:GetMouse()
		
		local isDown = false
		local currSize = current
		
		Bar.MouseButton1Down:Connect(function()
			isDown = true
			repeat game:GetService("RunService").RenderStepped:Wait() until isDown == false
			callback(currSize)
		end)
		
		UserInputService.InputEnded:Connect(function(input, gp)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				isDown = false
			end
		end)
		
		setSize(Bar, max, min, current)
		
		PlayerMouse.Move:Connect(function()
			if isDown == true then
				local tween;
		        
				if PlayerMouse.X < Bar.AbsolutePosition.X then
					tween = TweenService:Create(CurrBar, tweenInfo, {Size = UDim2.new(0, 0, 1, 0)})
				elseif PlayerMouse.X > (Bar.AbsolutePosition.X + Bar.AbsoluteSize.X) then
					tween = TweenService:Create(CurrBar, tweenInfo, {Size = UDim2.new(0, Bar.AbsoluteSize.X, 1, 0)})
				else
					tween = TweenService:Create(CurrBar, tweenInfo, {Size = UDim2.new(0, (PlayerMouse.X - Bar.AbsolutePosition.X), 1, 0)})
				end
				
				tween:Play()
				
				currSize = getSize(Bar, min, max)
				ValueTxt.Text = currSize
			end
		end)
	end)()
	
	window.TopBar.Container.Size = UDim2.new(0, 240, 0, window.TopBar.Container.Size.Y.Offset + 56)
	
	return Bar
end

function library:CreateKeyBind(window, name, key, callback)
	local yes_a_keybind = Instance.new("Frame")
	local Bind = Instance.new("TextButton")
	local Label = Instance.new("TextLabel")
	local beingChosen = false
	key = string.lower(key)
	
	yes_a_keybind.LayoutOrder = 1
	yes_a_keybind.Name = "yes_a_keybind"
	yes_a_keybind.Parent = window.TopBar.Container
	yes_a_keybind.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	yes_a_keybind.BackgroundTransparency = 1.000
	yes_a_keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
	yes_a_keybind.BorderSizePixel = 0
	yes_a_keybind.Size = UDim2.new(0, 240, 0, 43)
	
	Bind.Name = "Bind"
	Bind.Parent = yes_a_keybind
	Bind.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	Bind.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Bind.BorderSizePixel = 0
	Bind.Position = UDim2.new(0.725000024, 0, 0.125, 0)
	Bind.Size = UDim2.new(0, 60, 0, 30)
	Bind.Text = string.upper(key)
	Bind.TextColor3 = Color3.fromRGB(255, 255, 255)
	Bind.TextSize = 15.000
	Bind.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	Bind.TextWrapped = true
	
	Label.Name = "Label"
	Label.Parent = yes_a_keybind
	Label.Active = true
	Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Label.BackgroundTransparency = 1.000
	Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label.BorderSizePixel = 0
	Label.Position = UDim2.new(0.0291666668, 0, 0.125, 0)
	Label.Selectable = true
	Label.Size = UDim2.new(0, 161, 0, 30)
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextScaled = true
	Label.TextSize = 15.000
	Label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextWrapped = true
	
	local Players = game:GetService("Players")
	local Mouse = Players.LocalPlayer:GetMouse()
	Bind.MouseButton1Down:Connect(function()
		beingChosen = true
		local Key = nil
		
		Bind.Text = "..."
		connection = Mouse.KeyDown:Connect(function(Key)
			Key = string.lower(Key)
			key = Key
			Bind.Text = string.upper(key)
			wait(0.1)
			beingChosen = false
			connection:Disconnect()
		end)
	end)
		
	keybindconnection = Mouse.KeyDown:Connect(function(Key)
		if beingChosen == true then return end
		if string.lower(Key) == key then
			callback(string.lower(Key))
		end
	end)
	
	destroyedconnection = window.Parent.ChildRemoved:Connect(function(object)
	    if object == window then
    	    keybindconnection:Disconnect()
    	    destroyedconnection:Disconnect()
    	end
	end)
	
	window.TopBar.Container.Size = UDim2.new(0, 240, 0, window.TopBar.Container.Size.Y.Offset + 43)
	
	return Bind
end

local dropdownSizes = {}
function library:CreateDropdown(window, name)
	local kek_dropdown_lol = Instance.new("Frame")
	local DropFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local SizeToggle = Instance.new("TextButton")
	local TopLabel = Instance.new("TextLabel")
	
	kek_dropdown_lol.LayoutOrder = 1
	kek_dropdown_lol.Name = "kek_dropdown_lol"
	kek_dropdown_lol.Parent = window.TopBar.Container
	kek_dropdown_lol.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	kek_dropdown_lol.BackgroundTransparency = 0.500
	kek_dropdown_lol.BorderColor3 = Color3.fromRGB(0, 0, 0)
	kek_dropdown_lol.BorderSizePixel = 0
	kek_dropdown_lol.Position = UDim2.new(-0.00416666688, 0, 0.0811688304, 0)
	kek_dropdown_lol.Size = UDim2.new(0, 240, 0, 30)
	
	table.insert(dropdownSizes, #dropdownSizes + 1, DropFrame.Size)
	DropFrame.LayoutOrder = 1
	DropFrame.Name = #dropdownSizes -- iteration free lol
	DropFrame.Parent = window.TopBar.Container
	DropFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	DropFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropFrame.BorderSizePixel = 0
	DropFrame.ClipsDescendants = true
	DropFrame.Position = UDim2.new(0, 0, 1, 0)
	DropFrame.Size = UDim2.new(0, 240, 0, 0)
	
	UIListLayout.Parent = DropFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	SizeToggle.Name = #dropdownSizes
	SizeToggle.Parent = kek_dropdown_lol
	SizeToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	SizeToggle.BackgroundTransparency = 1.000
	SizeToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SizeToggle.BorderSizePixel = 0
	SizeToggle.Position = UDim2.new(0.872619033, 0, -0.00833332539, 0)
	SizeToggle.Size = UDim2.new(0, 30, 0, 30)
	SizeToggle.Modal = true
	SizeToggle.Text = "+"
	SizeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	SizeToggle.TextScaled = true
	SizeToggle.TextSize = 14.000
	SizeToggle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	SizeToggle.TextWrapped = true
	
	TopLabel.Name = "TopLabel"
	TopLabel.Parent = kek_dropdown_lol
	TopLabel.Active = true
	TopLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TopLabel.BackgroundTransparency = 1.000
	TopLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopLabel.BorderSizePixel = 0
	TopLabel.Position = UDim2.new(0.0291666668, 0, 0.100000001, 0)
	TopLabel.Selectable = true
	TopLabel.Size = UDim2.new(0, 202, 0, 23)
	TopLabel.Text = name
	TopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TopLabel.TextSize = 14.000
	TopLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	TopLabel.TextWrapped = true
	TopLabel.TextXAlignment = Enum.TextXAlignment.Left
	window.TopBar.Container.Size = UDim2.new(0, 240, 0, window.TopBar.Container.Size.Y.Offset + 30)
	
	local TweenService = game:GetService("TweenService") 
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local savedOffset;
	local tween;
	local tween2;
	local tween3;
	
	local open = false
	local debounce = false
	SizeToggle.MouseButton1Down:Connect(function()
		if debounce == false then
			debounce = true
			
			if open == true then
				savedOffset = dropdownSizes[tonumber(DropFrame.Name)] or DropFrame.Size
				tween = TweenService:Create(DropFrame, tweenInfo, {Size = DropFrame.Size - UDim2.new(0, 0, 0, DropFrame.Size.Y.Offset)})
				tween:Play()
				
				tween2 = TweenService:Create(window.TopBar.Container, tweenInfo, {Size = UDim2.new(0, 240, 0, window.TopBar.Container.Size.Y.Offset - savedOffset.Y.Offset)})
				tween2:Play()
				
				tween3 = TweenService:Create(kek_dropdown_lol, tweenInfo, {Size = UDim2.new(0, 240, 0, kek_dropdown_lol.Size.Y.Offset - savedOffset.Y.Offset)})
				--tween3:Play()
				SizeToggle.Text = "+"
				open = false
			else
				savedOffset = dropdownSizes[tonumber(DropFrame.Name)] or DropFrame.Size
				tween = TweenService:Create(DropFrame, tweenInfo, {Size = DropFrame.Size + UDim2.new(0, 0, 0, savedOffset.Y.Offset)})
				tween:Play()
				
				tween2 = TweenService:Create(window.TopBar.Container, tweenInfo, {Size = UDim2.new(0, 240, 0, window.TopBar.Container.Size.Y.Offset + savedOffset.Y.Offset)})
				tween2:Play()
				
				tween3 = TweenService:Create(kek_dropdown_lol, tweenInfo, {Size = UDim2.new(0, 240, 0, kek_dropdown_lol.Size.Y.Offset + savedOffset.Y.Offset)})
				--tween3:Play()
				SizeToggle.Text = "-"
				open = true
			end
			
			wait(0.2)
			debounce = false
		end
	end)
	
	return kek_dropdown_lol
end

function library:NewDropdownButton(window, dropdown, name, action)
    local num = dropdown:FindFirstChildWhichIsA("TextButton").Name
    
	local DR_FRAME = Instance.new("Frame")
	DR_FRAME.Name = "DR_FRAME"
	DR_FRAME.Parent = window.TopBar.Container[num] -- hacky method but will do
	DR_FRAME.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	DR_FRAME.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DR_FRAME.BorderSizePixel = 0
	DR_FRAME.Size = UDim2.new(0, 240, 0, 30)
	
	local Button = Instance.new("TextButton")
	Button.Name = "Button"
	Button.Parent = DR_FRAME
	Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Button.BackgroundTransparency = 1.000
	Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Button.BorderSizePixel = 0
	Button.Size = UDim2.new(0, 240, 0, 30)
	Button.Text = name
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextSize = 14.000
	Button.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextWrapped = true
	
	Button.MouseButton1Down:Connect(function()
		action(Button.Name)
	end)
	
	if dropdownSizes[tonumber(num)] then
		table.insert(dropdownSizes, tonumber(num), UDim2.new(0, 240, 0, dropdownSizes[tonumber(num)].Y.Offset + 30))
	else
		table.insert(dropdownSizes, tonumber(num), UDim2.new(0, 240, 0, 30))
	end
	
	return Button
end

function library:GetContainer(window)
	if not window:IsA("ScreenGui") then error("Specify a gui.", 0) return false end
	if not window:FindFirstChild("TopBar") then error("That's not a gui created by the library!", 0) return false end
	
	return window.TopBar.Container
end

function library:GetTopBar(window)
	if not window:IsA("ScreenGui") then error("Specify a gui.", 0) return false end
	if not window:FindFirstChild("TopBar") then error("That's not a gui created by the library!", 0) return false end
	
	return window.TopBar
end

function library:GetInfo()
    return _BLVersion, _BLChangelog
end

return library
