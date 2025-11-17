local NexusLib = {}
NexusLib.__index = NexusLib

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local defaultThemes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(100, 65, 165),
        Text = Color3.fromRGB(255, 255, 255),
        Secondary = Color3.fromRGB(40, 40, 40),
        Border = Color3.fromRGB(50, 50, 50),
        Highlight = Color3.fromRGB(120, 85, 185),
        Disabled = Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.Gotham,
        Gradient = ColorSequence.new(Color3.fromRGB(100, 65, 165), Color3.fromRGB(140, 85, 205)),
        Shadow = ColorSequence.new(Color3.fromRGB(20, 20, 20), Color3.fromRGB(40, 40, 40)),
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(100, 65, 165),
        Text = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(220, 220, 220),
        Border = Color3.fromRGB(200, 200, 200),
        Highlight = Color3.fromRGB(120, 85, 185),
        Disabled = Color3.fromRGB(180, 180, 180),
        Font = Enum.Font.Gotham,
        Gradient = ColorSequence.new(Color3.fromRGB(100, 65, 165), Color3.fromRGB(140, 85, 205)),
        Shadow = ColorSequence.new(Color3.fromRGB(200, 200, 200), Color3.fromRGB(220, 220, 220)),
    },
    Custom = {}
}

local screenSize = workspace.CurrentCamera.ViewportSize
local isMobile = UserInputService.TouchEnabled and screenSize.Y > screenSize.X * 0.75

function NexusLib.new(options)
    options = options or {}
    local self = setmetatable({}, NexusLib)
    self.Theme = deepCopy(defaultThemes[options.Theme or "Dark"])
    self.Font = self.Theme.Font
    self.Flags = {}
    self.Callbacks = {}
    self.Windows = {}
    self.Notifications = {}
    self.RainbowHue = 0
    self.RainbowEnabled = false
    self.Configs = {}
    self.CurrentConfig = ""
    self.Watermark = nil
    self.Tooltips = {}
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Parent = CoreGui
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 100

    RunService:BindToRenderStep("RainbowUpdate", Enum.RenderPriority.Camera.Value - 1, function(delta)
        if self.RainbowEnabled then
            self.RainbowHue = (self.RainbowHue + delta) % 1
            self.Theme.Accent = Color3.fromHSV(self.RainbowHue, 1, 1)
            self.Theme.Highlight = Color3.fromHSV(self.RainbowHue, 0.8, 1)
            self:UpdateTheme()
        end
    end)

    return self
end

function NexusLib:UpdateTheme()
    for _, window in ipairs(self.Windows) do
        window.Frame.BackgroundColor3 = self.Theme.Background
        window.Frame.BorderColor3 = self.Theme.Border
        window.Title.TextColor3 = self.Theme.Text
        for _, tab in ipairs(window.Tabs) do
            tab.Button.BackgroundColor3 = self.Theme.Secondary
            tab.Button.TextColor3 = self.Theme.Text
            tab.Container.BackgroundColor3 = self.Theme.Secondary
            for _, section in ipairs(tab.Sections) do
                section.Frame.BackgroundColor3 = self.Theme.Background
                section.Frame.BorderColor3 = self.Theme.Border
                section.Title.TextColor3 = self.Theme.Text
                for _, element in ipairs(section.Elements) do
                    self:UpdateElementTheme(element)
                end
            end
        end
    end
    if self.Watermark then
        self.Watermark.TextColor3 = self.Theme.Text
        self.Watermark.BackgroundColor3 = self.Theme.Background
    end
end

function NexusLib:UpdateElementTheme(element)
    if element.Type == "Toggle" then
        element.Label.TextColor3 = self.Theme.Text
        element.Toggle.BackgroundColor3 = self.Theme.Secondary
        element.Toggle.BorderColor3 = self.Theme.Border
        element.Toggle.Fill.BackgroundColor3 = self.Theme.Accent
    elseif element.Type == "Button" then
        element.Button.BackgroundColor3 = self.Theme.Accent
        element.Button.TextColor3 = self.Theme.Text
    elseif element.Type == "Slider" then
        element.Label.TextColor3 = self.Theme.Text
        element.Slider.BackgroundColor3 = self.Theme.Secondary
        element.Slider.Fill.BackgroundColor3 = self.Theme.Accent
        element.Value.TextColor3 = self.Theme.Text
    elseif element.Type == "Dropdown" then
        element.Label.TextColor3 = self.Theme.Text
        element.Dropdown.BackgroundColor3 = self.Theme.Secondary
        element.Dropdown.TextColor3 = self.Theme.Text
        for _, opt in ipairs(element.Options) do
            opt.BackgroundColor3 = self.Theme.Background
            opt.TextColor3 = self.Theme.Text
        end
    elseif element.Type == "ColorPicker" then
        element.Label.TextColor3 = self.Theme.Text
        element.Picker.BackgroundColor3 = element.Color
    elseif element.Type == "Keybind" then
        element.Label.TextColor3 = self.Theme.Text
        element.Bind.BackgroundColor3 = self.Theme.Secondary
        element.Bind.TextColor3 = self.Theme.Text
    elseif element.Type == "TextBox" then
        element.Label.TextColor3 = self.Theme.Text
        element.Box.BackgroundColor3 = self.Theme.Secondary
        element.Box.TextColor3 = self.Theme.Text
    elseif element.Type == "Label" then
        element.Label.TextColor3 = self.Theme.Text
    elseif element.Type == "ProgressBar" then
        element.Label.TextColor3 = self.Theme.Text
        element.Bar.BackgroundColor3 = self.Theme.Secondary
        element.Bar.Fill.BackgroundColor3 = self.Theme.Accent
    elseif element.Type == "List" then
        element.Label.TextColor3 = self.Theme.Text
        element.List.BackgroundColor3 = self.Theme.Secondary
        for _, item in ipairs(element.Items) do
            item.TextColor3 = self.Theme.Text
        end
    end
end

function NexusLib:Tween(object, properties)
    local tweenInfo = TweenInfo.new(properties.Time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    properties.Time = nil
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function NexusLib:Dragger(frame, parent)
    local dragging = false
    local dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function NexusLib:CreateWindow(options)
    options = options or {}
    local window = {}
    window.Title = options.Title or "NexusLib Window"
    window.Size = isMobile and UDim2.new(0.9, 0, 0.8, 0) or options.Size or UDim2.new(0, 500, 0, 350)
    window.Position = options.Position or UDim2.new(0.5, -window.Size.X.Offset / 2, 0.5, -window.Size.Y.Offset / 2)
    window.Tabs = {}
    window.Visible = true

    window.Frame = Instance.new("Frame")
    window.Frame.Size = window.Size
    window.Frame.Position = window.Position
    window.Frame.BackgroundColor3 = self.Theme.Background
    window.Frame.BorderColor3 = self.Theme.Border
    window.Frame.BorderSizePixel = 1
    window.Frame.Parent = self.ScreenGui

    window.TitleBar = Instance.new("Frame")
    window.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    window.TitleBar.BackgroundColor3 = self.Theme.Secondary
    window.TitleBar.Parent = window.Frame

    window.Title = Instance.new("TextLabel")
    window.Title.Size = UDim2.new(1, 0, 1, 0)
    window.Title.BackgroundTransparency = 1
    window.Title.Text = window.Title
    window.Title.TextColor3 = self.Theme.Text
    window.Title.Font = self.Font
    window.Title.TextSize = 14
    window.Title.Parent = window.TitleBar

    window.TabContainer = Instance.new("Frame")
    window.TabContainer.Size = UDim2.new(1, 0, 0, 30)
    window.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    window.TabContainer.BackgroundTransparency = 1
    window.TabContainer.Parent = window.Frame

    window.TabLayout = Instance.new("UIListLayout")
    window.TabLayout.FillDirection = Enum.FillDirection.Horizontal
    window.TabLayout.Parent = window.TabContainer

    window.ContentContainer = Instance.new("Frame")
    window.ContentContainer.Size = UDim2.new(1, 0, 1, -60)
    window.ContentContainer.Position = UDim2.new(0, 0, 0, 60)
    window.ContentContainer.BackgroundTransparency = 1
    window.ContentContainer.Parent = window.Frame

    self:Dragger(window.TitleBar, window.Frame)

    table.insert(self.Windows, window)
    return window
end

function NexusLib:CreateTab(window, options)
    options = options or {}
    local tab = {}
    tab.Title = options.Title or "Tab"
    tab.Sections = {}
    tab.Visible = false

    tab.Button = Instance.new("TextButton")
    tab.Button.Size = UDim2.new(0, 100, 1, 0)
    tab.Button.BackgroundColor3 = self.Theme.Secondary
    tab.Button.Text = tab.Title
    tab.Button.TextColor3 = self.Theme.Text
    tab.Button.Font = self.Font
    tab.Button.TextSize = 14
    tab.Button.Parent = window.TabContainer

    tab.Container = Instance.new("ScrollingFrame")
    tab.Container.Size = UDim2.new(1, 0, 1, 0)
    tab.Container.BackgroundColor3 = self.Theme.Secondary
    tab.Container.ScrollBarThickness = 4
    tab.Container.Visible = false
    tab.Container.Parent = window.ContentContainer

    tab.Layout = Instance.new("UIListLayout")
    tab.Layout.Padding = UDim.new(0, 5)
    tab.Layout.Parent = tab.Container

    tab.Button.MouseButton1Click:Connect(function()
        for _, t in ipairs(window.Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = self.Theme.Secondary
        end
        tab.Container.Visible = true
        tab.Button.BackgroundColor3 = self.Theme.Accent
    end)

    table.insert(window.Tabs, tab)
    if #window.Tabs == 1 then
        tab.Button.BackgroundColor3 = self.Theme.Accent
        tab.Container.Visible = true
    end
    return tab
end

function NexusLib:CreateSection(tab, options)
    options = options or {}
    local section = {}
    section.Title = options.Title or "Section"
    section.Elements = {}

    section.Frame = Instance.new("Frame")
    section.Frame.Size = UDim2.new(1, -10, 0, 0)
    section.Frame.BackgroundColor3 = self.Theme.Background
    section.Frame.BorderColor3 = self.Theme.Border
    section.Frame.BorderSizePixel = 1
    section.Frame.AutomaticSize = Enum.AutomaticSize.Y
    section.Frame.Parent = tab.Container

    section.Title = Instance.new("TextLabel")
    section.Title.Size = UDim2.new(1, 0, 0, 20)
    section.Title.BackgroundTransparency = 1
    section.Title.Text = section.Title
    section.Title.TextColor3 = self.Theme.Text
    section.Title.Font = self.Font
    section.Title.TextSize = 12
    section.Title.Parent = section.Frame

    section.Container = Instance.new("Frame")
    section.Container.Size = UDim2.new(1, 0, 1, -20)
    section.Container.Position = UDim2.new(0, 0, 0, 20)
    section.Container.BackgroundTransparency = 1
    section.Container.Parent = section.Frame

    section.Layout = Instance.new("UIListLayout")
    section.Layout.Padding = UDim.new(0, 5)
    section.Layout.Parent = section.Container

    section.Padding = Instance.new("UIPadding")
    section.Padding.PaddingLeft = UDim.new(0, 5)
    section.Padding.Parent = section.Container

    table.insert(tab.Sections, section)
    return section
end

function NexusLib:CreateToggle(section, options)
    options = options or {}
    local element = {}
    element.Type = "Toggle"
    element.Name = options.Name or "Toggle"
    element.Default = options.Default or false
    element.Callback = options.Callback or function() end
    element.Flag = options.Flag
    if element.Flag then self.Flags[element.Flag] = element.Default end

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 20)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, -40, 1, 0)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Name
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    element.Toggle = Instance.new("TextButton")
    element.Toggle.Size = UDim2.new(0, 30, 0, 16)
    element.Toggle.Position = UDim2.new(1, -30, 0, 2)
    element.Toggle.BackgroundColor3 = self.Theme.Secondary
    element.Toggle.BorderColor3 = self.Theme.Border
    element.Toggle.Text = ""
    element.Toggle.Parent = element.Frame

    element.Fill = Instance.new("Frame")
    element.Fill.Size = element.Default and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 1, 0)
    element.Fill.BackgroundColor3 = self.Theme.Accent
    element.Fill.Parent = element.Toggle

    local toggled = element.Default
    element.Toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        self:Tween(element.Fill, {Size = toggled and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 1, 0)})
        if element.Flag then self.Flags[element.Flag] = toggled end
        element.Callback(toggled)
    end)

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateButton(section, options)
    options = options or {}
    local element = {}
    element.Type = "Button"
    element.Name = options.Name or "Button"
    element.Callback = options.Callback or function() end

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 20)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Button = Instance.new("TextButton")
    element.Button.Size = UDim2.new(1, 0, 1, 0)
    element.Button.BackgroundColor3 = self.Theme.Accent
    element.Button.Text = element.Name
    element.Button.TextColor3 = self.Theme.Text
    element.Button.Font = self.Font
    element.Button.TextSize = 12
    element.Button.Parent = element.Frame

    element.Button.MouseButton1Click:Connect(element.Callback)

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateSlider(section, options)
    options = options or {}
    local element = {}
    element.Type = "Slider"
    element.Name = options.Name or "Slider"
    element.Min = options.Min or 0
    element.Max = options.Max or 100
    element.Default = options.Default or element.Min
    element.Precise = options.Precise or false
    element.Callback = options.Callback or function() end
    element.Flag = options.Flag
    if element.Flag then self.Flags[element.Flag] = element.Default end

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 30)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, 0, 0, 15)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Name
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    element.Slider = Instance.new("Frame")
    element.Slider.Size = UDim2.new(1, 0, 0, 10)
    element.Slider.Position = UDim2.new(0, 0, 0, 15)
    element.Slider.BackgroundColor3 = self.Theme.Secondary
    element.Slider.Parent = element.Frame

    element.Fill = Instance.new("Frame")
    element.Fill.Size = UDim2.new((element.Default - element.Min) / (element.Max - element.Min), 0, 1, 0)
    element.Fill.BackgroundColor3 = self.Theme.Accent
    element.Fill.Parent = element.Slider

    element.Value = Instance.new("TextLabel")
    element.Value.Size = UDim2.new(1, 0, 1, 0)
    element.Value.BackgroundTransparency = 1
    element.Value.Text = tostring(element.Default)
    element.Value.TextColor3 = self.Theme.Text
    element.Value.Font = self.Font
    element.Value.TextSize = 12
    element.Value.Parent = element.Slider

    local dragging = false
    element.Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    element.Slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = math.clamp((input.Position.X - element.Slider.AbsolutePosition.X) / element.Slider.AbsoluteSize.X, 0, 1)
            local value = element.Min + (element.Max - element.Min) * relativeX
            if not element.Precise then value = math.floor(value) end
            element.Fill.Size = UDim2.new(relativeX, 0, 1, 0)
            element.Value.Text = tostring(value)
            if element.Flag then self.Flags[element.Flag] = value end
            element.Callback(value)
        end
    end)

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateDropdown(section, options)
    options = options or {}
    local element = {}
    element.Type = "Dropdown"
    element.Name = options.Name or "Dropdown"
    element.OptionsList = options.Options or {}
    element.Default = options.Default or element.OptionsList[1]
    element.Multi = options.Multi or false
    element.Callback = options.Callback or function() end
    element.Flag = options.Flag
    if element.Flag then self.Flags[element.Flag] = element.Default end

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 20)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, 0, 1, 0)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Name
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    element.Dropdown = Instance.new("TextButton")
    element.Dropdown.Size = UDim2.new(0, 150, 1, 0)
    element.Dropdown.Position = UDim2.new(1, -150, 0, 0)
    element.Dropdown.BackgroundColor3 = self.Theme.Secondary
    element.Dropdown.Text = element.Default
    element.Dropdown.TextColor3 = self.Theme.Text
    element.Dropdown.Font = self.Font
    element.Dropdown.TextSize = 12
    element.Dropdown.Parent = element.Frame

    element.DropFrame = Instance.new("ScrollingFrame")
    element.DropFrame.Size = UDim2.new(1, 0, 0, 0)
    element.DropFrame.Position = UDim2.new(0, 0, 1, 0)
    element.DropFrame.BackgroundColor3 = self.Theme.Background
    element.DropFrame.Visible = false
    element.DropFrame.ScrollBarThickness = 4
    element.DropFrame.Parent = element.Dropdown

    element.DropLayout = Instance.new("UIListLayout")
    element.DropLayout.Parent = element.DropFrame

    element.Options = {}
    for _, opt in ipairs(element.OptionsList) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 20)
        button.BackgroundColor3 = self.Theme.Background
        button.Text = opt
        button.TextColor3 = self.Theme.Text
        button.Font = self.Font
        button.TextSize = 12
        button.Parent = element.DropFrame
        button.MouseButton1Click:Connect(function()
            if element.Multi then
                -- Handle multi select
            else
                element.Dropdown.Text = opt
                element.DropFrame.Visible = false
                if element.Flag then self.Flags[element.Flag] = opt end
                element.Callback(opt)
            end
        end)
        table.insert(element.Options, button)
    end

    element.Dropdown.MouseButton1Click:Connect(function()
        element.DropFrame.Visible = not element.DropFrame.Visible
        local height = #element.OptionsList * 20
        self:Tween(element.DropFrame, {Size = element.DropFrame.Visible and UDim2.new(1, 0, 0, math.min(height, 100)) or UDim2.new(1, 0, 0, 0)})
    end)

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateColorPicker(section, options)
    options = options or {}
    local element = {}
    element.Type = "ColorPicker"
    element.Name = options.Name or "ColorPicker"
    element.Default = options.Default or Color3.fromRGB(255, 255, 255)
    element.Callback = options.Callback or function() end
    element.Flag = options.Flag
    if element.Flag then self.Flags[element.Flag] = element.Default end
    element.Color = element.Default

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 20)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, -40, 1, 0)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Name
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    element.Picker = Instance.new("TextButton")
    element.Picker.Size = UDim2.new(0, 30, 0, 16)
    element.Picker.Position = UDim2.new(1, -30, 0, 2)
    element.Picker.BackgroundColor3 = element.Color
    element.Picker.Text = ""
    element.Picker.Parent = element.Frame

    element.PickFrame = Instance.new("Frame")
    element.PickFrame.Size = UDim2.new(0, 150, 0, 150)
    element.PickFrame.Position = UDim2.new(1, 5, 0, 0)
    element.PickFrame.BackgroundColor3 = self.Theme.Background
    element.PickFrame.Visible = false
    element.PickFrame.Parent = element.Frame

    -- Add saturation, hue, etc. similar to provided script, but expanded

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateKeybind(section, options)
    options = options or {}
    local element = {}
    element.Type = "Keybind"
    element.Name = options.Name or "Keybind"
    element.Default = options.Default or Enum.KeyCode.Unknown
    element.Callback = options.Callback or function() end
    element.Flag = options.Flag
    if element.Flag then self.Flags[element.Flag] = element.Default end

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 20)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, -100, 1, 0)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Name
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    element.Bind = Instance.new("TextButton")
    element.Bind.Size = UDim2.new(0, 80, 1, 0)
    element.Bind.Position = UDim2.new(1, -80, 0, 0)
    element.Bind.BackgroundColor3 = self.Theme.Secondary
    element.Bind.Text = tostring(element.Default.Name)
    element.Bind.TextColor3 = self.Theme.Text
    element.Bind.Font = self.Font
    element.Bind.TextSize = 12
    element.Bind.Parent = element.Frame

    local binding = false
    element.Bind.MouseButton1Click:Connect(function()
        binding = true
        element.Bind.Text = "..."
    end)
    UserInputService.InputBegan:Connect(function(input)
        if binding then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                element.Bind.Text = input.KeyCode.Name
                if element.Flag then self.Flags[element.Flag] = input.KeyCode end
                element.Callback(input.KeyCode)
                binding = false
            end
        end
    end)

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateTextBox(section, options)
    options = options or {}
    local element = {}
    element.Type = "TextBox"
    element.Name = options.Name or "TextBox"
    element.Default = options.Default or ""
    element.Callback = options.Callback or function() end
    element.Flag = options.Flag
    if element.Flag then self.Flags[element.Flag] = element.Default end

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 20)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, -160, 1, 0)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Name
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    element.Box = Instance.new("TextBox")
    element.Box.Size = UDim2.new(0, 150, 1, 0)
    element.Box.Position = UDim2.new(1, -150, 0, 0)
    element.Box.BackgroundColor3 = self.Theme.Secondary
    element.Box.Text = element.Default
    element.Box.TextColor3 = self.Theme.Text
    element.Box.Font = self.Font
    element.Box.TextSize = 12
    element.Box.Parent = element.Frame

    element.Box.FocusLost:Connect(function()
        if element.Flag then self.Flags[element.Flag] = element.Box.Text end
        element.Callback(element.Box.Text)
    end)

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateLabel(section, options)
    options = options or {}
    local element = {}
    element.Type = "Label"
    element.Text = options.Text or "Label"

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 20)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, 0, 1, 0)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Text
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateProgressBar(section, options)
    options = options or {}
    local element = {}
    element.Type = "ProgressBar"
    element.Name = options.Name or "ProgressBar"
    element.Min = options.Min or 0
    element.Max = options.Max or 100
    element.Default = options.Default or 0
    element.Callback = options.Callback or function() end

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 30)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, 0, 0, 15)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Name
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    element.Bar = Instance.new("Frame")
    element.Bar.Size = UDim2.new(1, 0, 0, 10)
    element.Bar.Position = UDim2.new(0, 0, 0, 15)
    element.Bar.BackgroundColor3 = self.Theme.Secondary
    element.Bar.Parent = element.Frame

    element.Fill = Instance.new("Frame")
    element.Fill.Size = UDim2.new((element.Default - element.Min) / (element.Max - element.Min), 0, 1, 0)
    element.Fill.BackgroundColor3 = self.Theme.Accent
    element.Fill.Parent = element.Bar

    function element:Set(value)
        value = math.clamp(value, element.Min, element.Max)
        self:Tween(element.Fill, {Size = UDim2.new((value - element.Min) / (element.Max - element.Min), 0, 1, 0)})
        element.Callback(value)
    end

    table.insert(section.Elements, element)
    return element
end

function NexusLib:CreateList(section, options)
    options = options or {}
    local element = {}
    element.Type = "List"
    element.Name = options.Name or "List"
    element.ItemsList = options.Items or {}
    element.Callback = options.Callback or function() end

    element.Frame = Instance.new("Frame")
    element.Frame.Size = UDim2.new(1, 0, 0, 100)
    element.Frame.BackgroundTransparency = 1
    element.Frame.Parent = section.Container

    element.Label = Instance.new("TextLabel")
    element.Label.Size = UDim2.new(1, 0, 0, 20)
    element.Label.BackgroundTransparency = 1
    element.Label.Text = element.Name
    element.Label.TextColor3 = self.Theme.Text
    element.Label.Font = self.Font
    element.Label.TextSize = 12
    element.Label.TextXAlignment = Enum.TextXAlignment.Left
    element.Label.Parent = element.Frame

    element.List = Instance.new("ScrollingFrame")
    element.List.Size = UDim2.new(1, 0, 1, -20)
    element.List.Position = UDim2.new(0, 0, 0, 20)
    element.List.BackgroundColor3 = self.Theme.Secondary
    element.List.ScrollBarThickness = 4
    element.List.Parent = element.Frame

    element.Layout = Instance.new("UIListLayout")
    element.Layout.Parent = element.List

    element.Items = {}
    for _, item in ipairs(element.ItemsList) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = item
        label.TextColor3 = self.Theme.Text
        label.Font = self.Font
        label.TextSize = 12
        label.Parent = element.List
        table.insert(element.Items, label)
    end

    function element:Add(item)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = item
        label.TextColor3 = self.Theme.Text
        label.Font = self.Font
        label.TextSize = 12
        label.Parent = element.List
        table.insert(element.Items, label)
    end

    function element:Remove(item)
        for i, lbl in ipairs(element.Items) do
            if lbl.Text == item then
                lbl:Destroy()
                table.remove(element.Items, i)
                break
            end
        end
    end

    table.insert(section.Elements, element)
    return element
end

function NexusLib:Notify(options)
    options = options or {}
    local notification = {}
    notification.Title = options.Title or "Notification"
    notification.Description = options.Description or "Description"
    notification.Duration = options.Duration or 5
    notification.Callback = options.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(1, -210, 1, -60 - (#self.Notifications * 60))
    frame.BackgroundColor3 = self.Theme.Background
    frame.BorderColor3 = self.Theme.Border
    frame.Parent = self.ScreenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = notification.Title
    title.TextColor3 = self.Theme.Text
    title.Font = self.Font
    title.TextSize = 12
    title.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, 0, 1, -20)
    desc.Position = UDim2.new(0, 0, 0, 20)
    desc.BackgroundTransparency = 1
    desc.Text = notification.Description
    desc.TextColor3 = self.Theme.Text
    desc.Font = self.Font
    desc.TextSize = 10
    desc.Parent = frame

    table.insert(self.Notifications, frame)
    self:Tween(frame, {Position = UDim2.new(1, -210, 1, -60 - (#self.Notifications * 60) + 60)})
    wait(notification.Duration)
    self:Tween(frame, {Position = UDim2.new(1, 0, frame.Position.Y.Scale, frame.Position.Y.Offset)}, function()
        frame:Destroy()
        table.remove(self.Notifications, table.find(self.Notifications, frame))
        for i, notif in ipairs(self.Notifications) do
            self:Tween(notif, {Position = UDim2.new(1, -210, 1, -60 - (i * 60) + 60)})
        end
    end)
end

function NexusLib:SetTheme(themeName)
    if defaultThemes[themeName] then
        self.Theme = deepCopy(defaultThemes[themeName])
        self:UpdateTheme()
    end
end

function NexusLib:SetCustomTheme(customTheme)
    self.Theme = customTheme
    self:UpdateTheme()
end

function NexusLib:ToggleRainbow(enabled)
    self.RainbowEnabled = enabled
end

function NexusLib:CreateWatermark(text)
    self.Watermark = Instance.new("TextLabel")
    self.Watermark.Size = UDim2.new(0, 200, 0, 20)
    self.Watermark.Position = UDim2.new(0, 10, 0, 10)
    self.Watermark.BackgroundColor3 = self.Theme.Background
    self.Watermark.Text = text
    self.Watermark.TextColor3 = self.Theme.Text
    self.Watermark.Font = self.Font
    self.Watermark.TextSize = 12
    self.Watermark.Parent = self.ScreenGui
end

function NexusLib:SaveConfig(configName)
    local config = {}
    for flag, value in pairs(self.Flags) do
        config[flag] = value
    end
    self.Configs[configName] = config
    -- Save to file or HttpService if needed
end

function NexusLib:LoadConfig(configName)
    if self.Configs[configName] then
        for flag, value in pairs(self.Configs[configName]) do
            self.Flags[flag] = value
            -- Update UI elements bound to flags
        end
    end
end

function NexusLib:AddTooltip(element, text)
    local tooltip = Instance.new("TextLabel")
    tooltip.Size = UDim2.new(0, 150, 0, 20)
    tooltip.BackgroundColor3 = self.Theme.Background
    tooltip.Text = text
    tooltip.TextColor3 = self.Theme.Text
    tooltip.Font = self.Font
    tooltip.TextSize = 10
    tooltip.Visible = false
    tooltip.Parent = self.ScreenGui

    element.Frame.MouseEnter:Connect(function()
        tooltip.Position = UDim2.new(0, Mouse.X + 10, 0, Mouse.Y + 10)
        tooltip.Visible = true
    end)
    element.Frame.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)

    table.insert(self.Tooltips, tooltip)
end

return NexusLib
