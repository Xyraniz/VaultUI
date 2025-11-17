local NexusLib = {}
NexusLib.Flags = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
function NexusLib.New(Config)
    Config = Config or {}
    local WindowName = Config.Name or "Nexus Lib"
    local AccentColor = Config.AccentColor or Color3.fromRGB(0, 120, 255)
    local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusLib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 660, 0, 540)
    Main.Position = UDim2.new(0.5, -330, 0.5, -270)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = Main
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = AccentColor
    MainStroke.Thickness = 1.6
    MainStroke.Parent = Main
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 44)
    TitleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    TitleBar.Parent = Main
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 14)
    TitleBarCorner.Parent = TitleBar
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -160, 1, 0)
    Title.Position = UDim2.new(0, 54, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 17
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    local Hamburger = Instance.new("ImageButton")
    Hamburger.Size = UDim2.new(0, 32, 0, 32)
    Hamburger.Position = UDim2.new(0, 12, 0, 6)
    Hamburger.BackgroundTransparency = 1
    Hamburger.Image = "rbxassetid://7072706613"
    Hamburger.ImageColor3 = Color3.fromRGB(220, 220, 220)
    Hamburger.Parent = TitleBar
    local Minimize = Instance.new("TextButton")
    Minimize.Size = UDim2.new(0, 44, 1, 0)
    Minimize.Position = UDim2.new(1, -88, 0, 0)
    Minimize.BackgroundTransparency = 1
    Minimize.Text = "—"
    Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.Font = Enum.Font.GothamBold
    Minimize.TextSize = 26
    Minimize.Parent = TitleBar
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 44, 1, 0)
    Close.Position = UDim2.new(1, -44, 0, 0)
    Close.BackgroundTransparency = 1
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 22
    Close.Parent = TitleBar
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    local MinimizedBar = Instance.new("Frame")
    MinimizedBar.Size = UDim2.new(0, 220, 0, 44)
    MinimizedBar.Position = UDim2.new(0, 20, 1, -64)
    MinimizedBar.BackgroundColor3 = AccentColor
    MinimizedBar.Visible = false
    MinimizedBar.Parent = ScreenGui
    local MinimizedCorner = Instance.new("UICorner")
    MinimizedCorner.CornerRadius = UDim.new(0, 10)
    MinimizedCorner.Parent = MinimizedBar
    local MinimizedLabel = Instance.new("TextLabel")
    MinimizedLabel.Size = UDim2.new(1, 0, 1, 0)
    MinimizedLabel.BackgroundTransparency = 1
    MinimizedLabel.Text = WindowName
    MinimizedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizedLabel.Font = Enum.Font.GothamBold
    MinimizedLabel.TextSize = 15
    MinimizedLabel.Parent = MinimizedBar
    MinimizedBar.MouseButton1Click:Connect(function()
        MinimizedBar.Visible = false
        Main.Visible = true
    end)
    Minimize.MouseButton1Click:Connect(function()
        Main.Visible = false
        MinimizedBar.Visible = true
    end)
    local dragging, dragInput, dragStart, startPos
    local function updateInput(input)
        local delta = input.Position - dragStart
        TweenService:Create(Main, TweenInfo.new(0.15), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
    end
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
            updateInput(input)
        end
    end)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 190, 1, -44)
    Sidebar.Position = UDim2.new(0, 0, 0, 44)
    Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    Sidebar.Parent = Main
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 12)
    SidebarList.Parent = Sidebar
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, -190, 1, -44)
    Content.Position = UDim2.new(0, 190, 0, 44)
    Content.BackgroundTransparency = 1
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageColor3 = AccentColor
    Content.Parent = Main
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 16)
    ContentPadding.PaddingRight = UDim.new(0, 16)
    ContentPadding.PaddingTop = UDim.new(0, 12)
    ContentPadding.Parent = Content
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 12)
    ContentList.Parent = Content
    local SidebarOpen = not IsMobile
    if IsMobile then
        Sidebar.Position = UDim2.new(0, -190, 0, 44)
        Content.Position = UDim2.new(0, 0, 0, 44)
        Content.Size = UDim2.new(1, 0, 1, -44)
    end
    Hamburger.MouseButton1Click:Connect(function()
        SidebarOpen = not SidebarOpen
        TweenService:Create(Sidebar, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = SidebarOpen and UDim2.new(0, 0, 0, 44) or UDim2.new(0, -190, 0, 44)}):Play()
        TweenService:Create(Content, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
            Position = SidebarOpen and UDim2.new(0, 190, 0, 44) or UDim2.new(0, 0, 0, 44),
            Size = SidebarOpen and UDim2.new(1, -190, 1, -44) or UDim2.new(1, 0, 1, -44)
        }):Play()
    end)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == ToggleKey then
            Main.Visible = not Main.Visible
            if not Main.Visible then MinimizedBar.Visible = false end
        end
    end)
    function NexusLib.Notify(text, duration)
        duration = duration or 5
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(0, 320, 0, 70)
        Notif.Position = UDim2.new(1, 20, 1, -80)
        Notif.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
        Notif.Parent = ScreenGui
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = Notif
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = AccentColor
        Stroke.Thickness = 1.4
        Stroke.Parent = Notif
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -20, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 15
        Label.TextWrapped = true
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Notif
        TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -340, 1, -80)}):Play()
        task.wait(0.3)
        TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -20, 1, -80)}):Play()
        task.wait(duration)
        TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 340, 1, -80)}):Play()
        task.wait(0.4)
        Notif:Destroy()
    end
    local Window = {}
    local CurrentTab = nil
    function Window.Tab(Name)
        local Tab = {}
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -24, 0, 44)
        Button.Position = UDim2.new(0, 12, 0, 0)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        Button.AutoButtonColor = false
        Button.Text = " " .. Name
        Button.TextColor3 = Color3.fromRGB(190, 190, 190)
        Button.Font = Enum.Font.GothamSemibold
        Button.TextSize = 16
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 10)
        Button.Parent = Sidebar
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Size = UDim2.new(1, 0, 0, 0)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
        ContentFrame.Visible = false
        ContentFrame.Parent = Content
        local List = Instance.new("UIListLayout")
        List.Padding = UDim.new(0, 12)
        List.Parent = ContentFrame
        if not CurrentTab then
            ContentFrame.Visible = true
            CurrentTab = ContentFrame
            Button.BackgroundColor3 = AccentColor
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        Button.MouseButton1Click:Connect(function()
            if CurrentTab then CurrentTab.Visible = false end
            ContentFrame.Visible = true
            CurrentTab = ContentFrame
            for _, b in ipairs(Sidebar:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
                    b.TextColor3 = Color3.fromRGB(190, 190, 190)
                end
            end
            TweenService:Create(Button, TweenInfo.new(0.25), {BackgroundColor3 = AccentColor}):Play()
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        function Tab.Section(Name)
            local Section = {}
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 48)
            Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
            Frame.AutomaticSize = Enum.AutomaticSize.Y
            Frame.Parent = ContentFrame
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 12)
            Corner.Parent = Frame
            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -50, 0, 44)
            Title.BackgroundTransparency = 1
            Title.Text = Name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 17
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Position = UDim2.new(0, 18, 0, 0)
            Title.Parent = Frame
            local Arrow = Instance.new("ImageLabel")
            Arrow.Size = UDim2.new(0, 22, 0, 22)
            Arrow.Position = UDim2.new(1, -40, 0, 11)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = "rbxassetid://7072720373"
            Arrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
            Arrow.Rotation = 90
            Arrow.Parent = Frame
            local ContentArea = Instance.new("Frame")
            ContentArea.Size = UDim2.new(1, -24, 0, 0)
            ContentArea.Position = UDim2.new(0, 12, 0, 48)
            ContentArea.BackgroundTransparency = 1
            ContentArea.AutomaticSize = Enum.AutomaticSize.Y
            ContentArea.Parent = Frame
            local AreaList = Instance.new("UIListLayout")
            AreaList.Padding = UDim.new(0, 9)
            AreaList.Parent = ContentArea
            local AreaPadding = Instance.new("UIPadding")
            AreaPadding.PaddingLeft = UDim.new(0, 8)
            AreaPadding.PaddingRight = UDim.new(0, 8)
            AreaPadding.Parent = ContentArea
            local Open = true
            Title.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Open = not Open
                    TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Rotation = Open and 90 or 0}):Play()
                    ContentArea.Visible = Open
                end
            end)
            function Section:Label(text)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 28)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(200, 200, 200)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ContentArea
            end
            function Section:Toggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local callback = cfg.Callback or function() end
                local default = cfg.Default or false
                local flag = cfg.Flag
                local value = default
                if flag then NexusLib.Flags[flag] = value end
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = ContentArea
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -70, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Color3.fromRGB(230, 230, 230)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ToggleFrame
                local Switch = Instance.new("Frame")
                Switch.Size = UDim2.new(0, 54, 0, 28)
                Switch.Position = UDim2.new(1, -62, 0, 4)
                Switch.BackgroundColor3 = value and AccentColor or Color3.fromRGB(70, 70, 80)
                local SC = Instance.new("UICorner")
                SC.CornerRadius = UDim.new(1, 0)
                SC.Parent = Switch
                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 24, 0, 24)
                Circle.Position = value and UDim2.new(1, -27, 0, 2) or UDim2.new(0, 2, 0, 2)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                local CC = Instance.new("UICorner")
                CC.CornerRadius = UDim.new(1, 0)
                CC.Parent = Circle
                Circle.Parent = Switch
                Switch.Parent = ToggleFrame
                ToggleFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        value = not value
                        if flag then NexusLib.Flags[flag] = value end
                        TweenService:Create(Switch, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = value and AccentColor or Color3.fromRGB(70, 70, 80)}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = value and UDim2.new(1, -27, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
                        callback(value)
                    end
                end)
            end
            function Section:Button(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Button"
                local callback = cfg.Callback or function() end
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.BackgroundColor3 = AccentColor
                Button.AutoButtonColor = false
                Button.Text = name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.Font = Enum.Font.GothamSemibold
                Button.TextSize = 15
                local BC = Instance.new("UICorner")
                BC.CornerRadius = UDim.new(0, 10)
                BC.Parent = Button
                Button.Parent = ContentArea
                Button.MouseButton1Down:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor:Lerp(Color3.new(0,0,0), 0.3)}):Play()
                end)
                Button.MouseButton1Up:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
                end)
                Button.MouseButton1Click:Connect(callback)
            end
            function Section:Textbox(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Textbox"
                local callback = cfg.Callback or function() end
                local default = cfg.Default or ""
                local flag = cfg.Flag
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundTransparency = 1
                Frame.Parent = ContentArea
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.4, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Color3.fromRGB(230, 230, 230)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(0.6, 0, 1, 0)
                Box.Position = UDim2.new(0.4, 0, 0, 0)
                Box.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
                Box.Text = default
                Box.TextColor3 = Color3.fromRGB(230, 230, 230)
                Box.PlaceholderText = "Enter text..."
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 15
                local BC = Instance.new("UICorner")
                BC.CornerRadius = UDim.new(0, 8)
                BC.Parent = Box
                Box.Parent = Frame
                Box.FocusLost:Connect(function(enter)
                    if enter and callback then
                        if flag then NexusLib.Flags[flag] = Box.Text end
                        callback(Box.Text)
                    end
                end)
            end
            function Section:Slider(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Slider"
                local callback = cfg.Callback or function() end
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local default = cfg.Default or min
                local precise = cfg.Precise or false
                local flag = cfg.Flag
                local value = default
                if flag then NexusLib.Flags[flag] = value end
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 56)
                Frame.BackgroundTransparency = 1
                Frame.Parent = ContentArea
                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, -100, 0, 24)
                Title.BackgroundTransparency = 1
                Title.Text = name .. ": " .. tostring(value)
                Title.TextColor3 = Color3.fromRGB(230, 230, 230)
                Title.Font = Enum.Font.Gotham
                Title.TextSize = 15
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = Frame
                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 10)
                Track.Position = UDim2.new(0, 0, 0, 34)
                Track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                local TC = Instance.new("UICorner")
                TC.CornerRadius = UDim.new(0, 5)
                TC.Parent = Track
                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = AccentColor
                local FC = Instance.new("UICorner")
                FC.CornerRadius = UDim.new(0, 5)
                FC.Parent = Fill
                Fill.Parent = Track
                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 22, 0, 22)
                Knob.Position = UDim2.new((value - min) / (max - min), -11, 0, -6)
                Knob.BackgroundColor3 = AccentColor
                local KC = Instance.new("UICorner")
                KC.CornerRadius = UDim.new(1, 0)
                KC.Parent = Knob
                Knob.Parent = Track
                Track.Parent = Frame
                local dragging = false
                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                RunService.RenderStepped:Connect(function()
                    if dragging then
                        local mouse = UserInputService:GetMouseLocation()
                        local percent = math.clamp((mouse.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        value = min + (max - min) * percent
                        if not precise then value = math.floor(value + 0.5) end
                        Fill.Size = UDim2.new(percent, 0, 1, 0)
                        Knob.Position = UDim2.new(percent, -11, 0, -6)
                        Title.Text = name .. ": " .. tostring(value)
                        if flag then NexusLib.Flags[flag] = value end
                        callback(value)
                    end
                end)
            end
            function Section:Keybind(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Keybind"
                local callback = cfg.Callback or function() end
                local default = cfg.Default or Enum.KeyCode.Unknown
                local flag = cfg.Flag
                local value = default
                if flag then NexusLib.Flags[flag] = value end
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundTransparency = 1
                Frame.Parent = ContentArea
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.55, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Color3.fromRGB(230, 230, 230)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                local Bind = Instance.new("TextButton")
                Bind.Size = UDim2.new(0.45, 0, 1, 0)
                Bind.Position = UDim2.new(0.55, 0, 0, 0)
                Bind.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
                Bind.Text = value == Enum.KeyCode.Unknown and "None" or string.gsub(tostring(value), "Enum.KeyCode.", "")
                Bind.TextColor3 = Color3.fromRGB(230, 230, 230)
                Bind.Font = Enum.Font.Gotham
                Bind.TextSize = 15
                local BC = Instance.new("UICorner")
                BC.CornerRadius = UDim.new(0, 8)
                BC.Parent = Bind
                Bind.Parent = Frame
                local binding = false
                Bind.MouseButton1Click:Connect(function()
                    Bind.Text = "..."
                    binding = true
                    local conn = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            value = input.KeyCode
                        elseif input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Backspace then
                            value = Enum.KeyCode.Unknown
                        end
                        Bind.Text = value == Enum.KeyCode.Unknown and "None" or string.gsub(tostring(value), "Enum.KeyCode.", "")
                        binding = false
                        if flag then NexusLib.Flags[flag] = value end
                        callback(value)
                        conn:Disconnect()
                    end)
                end)
            end
            function Section:Dropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Dropdown"
                local list = cfg.List or {}
                local callback = cfg.Callback or function() end
                local multi = cfg.Multi or false
                local default = cfg.Default
                local flag = cfg.Flag
                local selected = multi and {} or (default or list[1]) or ""
                if flag then NexusLib.Flags[flag] = selected end
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 40)
                Frame.BackgroundTransparency = 1
                Frame.Parent = ContentArea
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -100, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Color3.fromRGB(230, 230, 230)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                local Drop = Instance.new("Frame")
                Drop.Size = UDim2.new(1, 0, 0, 36)
                Drop.Position = UDim2.new(0, 0, 0, 20)
                Drop.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
                local DC = Instance.new("UICorner")
                DC.CornerRadius = UDim.new(0, 10)
                DC.Parent = Drop
                local DropLabel = Instance.new("TextLabel")
                DropLabel.Size = UDim2.new(1, -40, 1, 0)
                DropLabel.BackgroundTransparency = 1
                DropLabel.Text = multi and "None" or tostring(selected)
                DropLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropLabel.Font = Enum.Font.Gotham
                DropLabel.TextSize = 15
                DropLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropLabel.Position = UDim2.new(0, 12, 0, 0)
                DropLabel.Parent = Drop
                local Arrow = Instance.new("ImageLabel")
                Arrow.Size = UDim2.new(0, 20, 0, 20)
                Arrow.Position = UDim2.new(1, -32, 0, 8)
                Arrow.BackgroundTransparency = 1
                Arrow.Image = "rbxassetid://7072720373"
                Arrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
                Arrow.Parent = Drop
                local ListFrame = Instance.new("Frame")
                ListFrame.Size = UDim2.new(1, 0, 0, 0)
                ListFrame.Position = UDim2.new(0, 0, 1, 4)
                ListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
                ListFrame.Visible = false
                ListFrame.ClipsDescendants = true
                local LC = Instance.new("UICorner")
                LC.CornerRadius = UDim.new(0, 10)
                LC.Parent = ListFrame
                ListFrame.Parent = Drop
                local Search = Instance.new("TextBox")
                Search.Size = UDim2.new(1, -12, 0, 32)
                Search.Position = UDim2.new(0, 6, 0, 6)
                Search.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                Search.PlaceholderText = "Search..."
                Search.Text = ""
                Search.TextColor3 = Color3.fromRGB(230, 230, 230)
                local SC = Instance.new("UICorner")
                SC.CornerRadius = UDim.new(0, 8)
                SC.Parent = Search
                Search.Parent = ListFrame
                local Items = {}
                local function refresh()
                    for _, v in ipairs(Items) do v:Destroy() end
                    Items = {}
                    local height = 38
                    for _, v in ipairs(list) do
                        if string.find(string.lower(v), string.lower(Search.Text)) or Search.Text == "" then
                            height = height + 34
                            local Item = Instance.new("TextButton")
                            Item.Size = UDim2.new(1, -12, 0, 32)
                            Item.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                            Item.Text = v
                            Item.TextColor3 = Color3.fromRGB(230, 230, 230)
                            Item.Font = Enum.Font.Gotham
                            Item.TextSize = 15
                            local IC = Instance.new("UICorner")
                            IC.CornerRadius = UDim.new(0, 8)
                            IC.Parent = Item
                            Item.Parent = ListFrame
                            if multi and table.find(selected, v) then
                                Item.Text = "[✓] " .. v
                            end
                            Item.MouseButton1Click:Connect(function()
                                if multi then
                                    if table.find(selected, v) then
                                        table.remove(selected, table.find(selected, v))
                                    else
                                        table.insert(selected, v)
                                    end
                                    Item.Text = table.find(selected, v) and "[✓] " .. v or v
                                    DropLabel.Text = #selected > 0 and table.concat(selected, ", ") or "None"
                                else
                                    selected = v
                                    DropLabel.Text = v
                                    ListFrame.Visible = false
                                    TweenService:Create(ListFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                                end
                                if flag then NexusLib.Flags[flag] = selected end
                                callback(selected)
                            end)
                            table.insert(Items, Item)
                        end
                    end
                    TweenService:Create(ListFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, math.clamp(height, 38, 200))}):Play()
                end
                refresh()
                Search:GetPropertyChangedSignal("Text"):Connect(refresh)
                Drop.MouseButton1Click:Connect(function()
                    ListFrame.Visible = not ListFrame.Visible
                    if ListFrame.Visible then
                        refresh()
                    else
                        TweenService:Create(ListFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    end
                end)
                Drop.Parent = Frame
            end
            function Section:Colorpicker(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Colorpicker"
                local callback = cfg.Callback or function() end
                local default = cfg.Default or Color3.fromRGB(255, 255, 255)
                local flag = cfg.Flag
                local value = default
                if flag then NexusLib.Flags[flag] = value end
                local rainbow = false
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundTransparency = 1
                Frame.Parent = ContentArea
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Color3.fromRGB(230, 230, 230)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                local PickerBtn = Instance.new("Frame")
                PickerBtn.Size = UDim2.new(0, 40, 0, 40)
                PickerBtn.Position = UDim2.new(1, -40, 0, 0)
                PickerBtn.BackgroundColor3 = value
                local PC = Instance.new("UICorner")
                PC.CornerRadius = UDim.new(0, 10)
                PC.Parent = PickerBtn
                PickerBtn.Parent = Frame
                local Picker = Instance.new("Frame")
                Picker.Size = UDim2.new(0, 180, 0, 190)
                Picker.Position = UDim2.new(1, -190, 0, 40)
                Picker.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                Picker.Visible = false
                Picker.ZIndex = 10
                local PRC = Instance.new("UICorner")
                PRC.CornerRadius = UDim.new(0, 12)
                PRC.Parent = Picker
                Picker.Parent = Frame
                local SatVal = Instance.new("ImageLabel")
                SatVal.Size = UDim2.new(0, 140, 0, 140)
                SatVal.Position = UDim2.new(0, 16, 0, 16)
                SatVal.BackgroundColor3 = value
                SatVal.Image = "rbxassetid://4650897272"
                SatVal.ZIndex = 11
                local SVC = Instance.new("UICorner")
                SVC.CornerRadius = UDim.new(0, 8)
                SVC.Parent = SatVal
                SatVal.Parent = Picker
                local Hue = Instance.new("ImageLabel")
                Hue.Size = UDim2.new(0, 18, 0, 140)
                Hue.Position = UDim2.new(0, 160, 0, 16)
                Hue.Image = "rbxassetid://4650897105"
                Hue.BackgroundTransparency = 1
                Hue.ZIndex = 11
                Hue.Parent = Picker
                local RainbowBtn = Instance.new("TextButton")
                RainbowBtn.Size = UDim2.new(1, -32, 0, 28)
                RainbowBtn.Position = UDim2.new(0, 16, 1, -40)
                RainbowBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                RainbowBtn.Text = "Rainbow: OFF"
                RainbowBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
                RainbowBtn.ZIndex = 11
                local RBC = Instance.new("UICorner")
                RBC.CornerRadius = UDim.new(0, 8)
                RBC.Parent = RainbowBtn
                RainbowBtn.Parent = Picker
                local PickerInd = Instance.new("Frame")
                PickerInd.Size = UDim2.new(0, 10, 0, 10)
                PickerInd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                PickerInd.ZIndex = 12
                PickerInd.Parent = SatVal
                local HueInd = Instance.new("Frame")
                HueInd.Size = UDim2.new(1, 0, 0, 6)
                HueInd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueInd.ZIndex = 12
                HueInd.Parent = Hue
                local h, s, v = Color3.toHSV(value)
                PickerInd.Position = UDim2.new(s, -5, 1 - v, -5)
                HueInd.Position = UDim2.new(0, 0, h, -3)
                local draggingPicker, draggingHue = false, false
                SatVal.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingPicker = true end
                end)
                Hue.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingHue = true end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        draggingPicker = false
                        draggingHue = false
                    end
                end)
                RunService.RenderStepped:Connect(function()
                    if draggingPicker then
                        local mouse = UserInputService:GetMouseLocation()
                        local relX = math.clamp((mouse.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((mouse.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        PickerInd.Position = UDim2.new(relX, -5, relY, -5)
                        value = Color3.fromHSV(h, s, v)
                        PickerBtn.BackgroundColor3 = value
                        if flag then NexusLib.Flags[flag] = value end
                        callback(value)
                    end
                    if draggingHue then
                        local mouse = UserInputService:GetMouseLocation()
                        local relY = math.clamp((mouse.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)
                        h = relY
                        HueInd.Position = UDim2.new(0, 0, relY, -3)
                        value = Color3.fromHSV(h, s, v)
                        PickerBtn.BackgroundColor3 = value
                        SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        if flag then NexusLib.Flags[flag] = value end
                        callback(value)
                    end
                    if rainbow then
                        local hue = tick() % 6 / 6
                        value = Color3.fromHSV(hue, s, v)
                        PickerBtn.BackgroundColor3 = value
                        if flag then NexusLib.Flags[flag] = value end
                        callback(value)
                    end
                end)
                RainbowBtn.MouseButton1Click:Connect(function()
                    rainbow = not rainbow
                    RainbowBtn.Text = rainbow and "Rainbow: ON" or "Rainbow: OFF"
                end)
                PickerBtn.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        Picker.Visible = not Picker.Visible
                    end
                end)
            end
            return Section
        end
        return Tab
    end
    return Window
end
return NexusLib
