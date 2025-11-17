local NexusLib = {}
NexusLib.Flags = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function NexusLib.New(Config)
    Config = Config or {}
    local WindowName = Config.Name or "Nexus Lib"
    local AccentColor = Config.AccentColor or Color3.fromRGB(0, 120, 255)
    local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    local WindowSize = Config.Size or UDim2.new(0, 620, 0, 520)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusLib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")

    local Main = Instance.new("Frame")
    Main.Size = WindowSize
    Main.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    Main.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = AccentColor
    MainStroke.Thickness = 2
    MainStroke.Parent = Main

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = AccentColor
    TitleBar.Parent = Main

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 40, 1, 0)
    Close.Position = UDim2.new(1, -40, 0, 0)
    Close.BackgroundTransparency = 1
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 24
    Close.Parent = TitleBar
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(Main, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
    end
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    Main.Visible = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == ToggleKey then
            Main.Visible = not Main.Visible
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    Sidebar.Parent = Main

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.FillDirection = Enum.FillDirection.Vertical
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarList.Padding = UDim.new(0, 10)
    SidebarList.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -160, 1, -40)
    Content.Position = UDim2.new(0, 160, 0, 40)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local Window = {}
    local CurrentTab = nil

    function Window.Tab(Name)
        local Tab = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -20, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        TabButton.AutoButtonColor = false
        TabButton.Text = Name
        TabButton.TextColor3 = Color3.fromRGB(170, 170, 170)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 15
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 8)
        TabButton.Parent = Sidebar

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = AccentColor
        TabContent.Visible = false
        TabContent.Parent = Content

        if not CurrentTab then
            TabContent.Visible = true
            CurrentTab = TabContent
            TabButton.TextColor3 = AccentColor
        end

        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then CurrentTab.Visible = false end
            TabContent.Visible = true
            CurrentTab = TabContent
            TabButton.TextColor3 = AccentColor
        end)

        local LeftColumn = Instance.new("Frame")
        LeftColumn.Size = UDim2.new(0.5, -10, 1, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Parent = TabContent

        local RightColumn = Instance.new("Frame")
        RightColumn.Size = UDim2.new(0.5, -10, 1, 0)
        RightColumn.Position = UDim2.new(0.5, 10, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.Parent = TabContent

        local LeftList = Instance.new("UIListLayout")
        LeftList.Padding = UDim.new(0, 10)
        LeftList.Parent = LeftColumn

        local RightList = Instance.new("UIListLayout")
        RightList.Padding = UDim.new(0, 10)
        RightList.Parent = RightColumn

        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingRight = UDim.new(0, 10)
        TabPadding.PaddingTop = UDim.new(0, 10)
        TabPadding.Parent = TabContent

        function Tab.Section(Name, Side)
            local Side = Side or "Left"
            local Column = Side == "Left" and LeftColumn or RightColumn

            local Section = {}

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.Parent = Column

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame

            local SectionStroke = Instance.new("UIStroke")
            SectionStroke.Color = AccentColor
            SectionStroke.Thickness = 1
            SectionStroke.Parent = SectionFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, -20, 0, 30)
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = Name
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 15
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame

            local SectionContent = Instance.new("Frame")
            SectionContent.Size = UDim2.new(1, -20, 0, 0)
            SectionContent.Position = UDim2.new(0, 10, 0, 35)
            SectionContent.BackgroundTransparency = 1
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.Parent = SectionFrame

            local ContentList = Instance.new("UIListLayout")
            ContentList.Padding = UDim.new(0, 8)
            ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Left
            ContentList.Parent = SectionContent

            local ContentPadding = Instance.new("UIPadding")
            ContentPadding.PaddingLeft = UDim.new(0, 5)
            ContentPadding.PaddingRight = UDim.new(0, 5)
            ContentPadding.Parent = SectionContent

            function Section:Label(Text)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 24)
                Label.BackgroundTransparency = 1
                Label.Text = Text
                Label.TextColor3 = Color3.fromRGB(200, 200, 200)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SectionContent
            end

            function Section:Toggle(Config)
                Config = Config or {}
                local Name = Config.Name or "Toggle"
                local Callback = Config.Callback or function() end
                local Default = Config.Default or false
                local Flag = Config.Flag

                local Value = Default
                if Flag then NexusLib.Flags[Flag] = Value end

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 30)
                Frame.BackgroundTransparency = 1
                Frame.Parent = SectionContent

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = Name
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local Toggle = Instance.new("Frame")
                Toggle.Size = UDim2.new(0, 46, 0, 24)
                Toggle.Position = UDim2.new(1, -56, 0, 3)
                Toggle.BackgroundColor3 = Value and AccentColor or Color3.fromRGB(60, 60, 60)
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 12)
                Corner.Parent = Toggle
                Toggle.Parent = Frame

                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 20, 0, 20)
                Circle.Position = Value and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = Circle
                Circle.Parent = Toggle

                Frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Value = not Value
                        if Flag then NexusLib.Flags[Flag] = Value end
                        TweenService:Create(Toggle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = Value and AccentColor or Color3.fromRGB(60, 60, 60)}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = Value and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
                        Callback(Value)
                    end
                end)
            end

            function Section:Button(Config)
                Config = Config or {}
                local Name = Config.Name or "Button"
                local Callback = Config.Callback or function() end

                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 34)
                Button.BackgroundColor3 = AccentColor
                Button.AutoButtonColor = false
                Button.Text = Name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.Font = Enum.Font.GothamSemibold
                Button.TextSize = 14
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 8)
                Corner.Parent = Button
                Button.Parent = SectionContent

                Button.MouseButton1Down:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.new(AccentColor.r * 0.8, AccentColor.g * 0.8, AccentColor.b * 0.8)}):Play()
                end)

                Button.MouseButton1Up:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = AccentColor}):Play()
                end)

                Button.MouseButton1Click:Connect(callback)
            end

            function Section:Textbox(Config)
                Config = Config or {}
                local Name = Config.Name or "Textbox"
                local Callback = Config.Callback or function() end
                local Default = Config.Default or ""
                local Flag = Config.Flag

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 30)
                Frame.BackgroundTransparency = 1
                Frame.Parent = SectionContent

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.4, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = Name
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(0.6, 0, 1, 0)
                Box.Position = UDim2.new(0.4, 0, 0, 0)
                Box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                Box.Text = Default
                Box.TextColor3 = Color3.fromRGB(220, 220, 220)
                Box.PlaceholderText = "..."
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 14
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Box
                Box.Parent = Frame

                Box.FocusLost:Connect(function(enter)
                    if enter then
                        if Flag then NexusLib.Flags[Flag] = Box.Text end
                        Callback(Box.Text)
                    end
                end)
            end

            function Section:Slider(Config)
                Config = Config or {}
                local Name = Config.Name or "Slider"
                local Callback = Config.Callback or function() end
                local Min = Config.Min or 0
                local Max = Config.Max or 100
                local Default = Config.Default or Min
                local Precise = Config.Precise or false
                local Flag = Config.Flag

                local Value = Default
                if Flag then NexusLib.Flags[Flag] = Value end

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 50)
                Frame.BackgroundTransparency = 1
                Frame.Parent = SectionContent

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -100, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = Name .. ": " .. tostring(Value)
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, 0, 0, 8)
                SliderBar.Position = UDim2.new(0, 0, 0, 30)
                SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(0, 4)
                BarCorner.Parent = SliderBar
                SliderBar.Parent = Frame

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                Fill.BackgroundColor3 = AccentColor
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 4)
                FillCorner.Parent = Fill
                Fill.Parent = SliderBar

                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 20, 0, 20)
                Knob.Position = UDim2.new((Value - Min) / (Max - Min), -10, 0, -6)
                Knob.BackgroundColor3 = AccentColor
                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = Knob
                Knob.Parent = SliderBar

                local dragging = false

                SliderBar.InputBegan:Connect(function(input)
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
                        local mousePos = UserInputService:GetMouseLocation()

                        local relativeX = math.clamp((mousePos.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        Value = Min + (Max - Min) * relativeX
                        if not Precise then Value = math.floor(Value + 0.5) end

                        Fill.Size = UDim2.new(relativeX, 0, 1, 0)
                        Knob.Position = UDim2.new(relativeX, -10, 0, -6)
                        Label.Text = Name .. ": " .. tostring(Value)

                        if Flag then NexusLib.Flags[Flag] = Value end
                        Callback(Value)
                    end
                end)
            end

            function Section:Keybind(Config)
                Config = Config or {}
                local Name = Config.Name or "Keybind"
                local Callback = Config.Callback or function() end
                local Default = Config.Default or Enum.KeyCode.Unknown
                local Flag = Config.Flag

                local Value = Default
                if Flag then NexusLib.Flags[Flag] = Value end

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 30)
                Frame.BackgroundTransparency = 1
                Frame.Parent = SectionContent

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = Name
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local BindButton = Instance.new("TextButton")
                BindButton.Size = UDim2.new(0.4, 0, 1, 0)
                BindButton.Position = UDim2.new(0.6, 0, 0, 0)
                BindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                BindButton.Text = Value == Enum.KeyCode.Unknown and "None" or string.gsub(tostring(Value), "Enum.KeyCode.", "")
                BindButton.TextColor3 = Color3.fromRGB(220, 220, 220)
                BindButton.Font = Enum.Font.Gotham
                BindButton.TextSize = 14
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = BindButton
                BindButton.Parent = Frame

                local binding = false

                BindButton.MouseButton1Click:Connect(function()
                    BindButton.Text = "..."
                    binding = true

                    local conn = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            Value = input.KeyCode
                        elseif input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Backspace then
                            Value = Enum.KeyCode.Unknown
                        end

                        BindButton.Text = Value == Enum.KeyCode.Unknown and "None" or string.gsub(tostring(Value), "Enum.KeyCode.", "")
                        binding = false
                        if Flag then NexusLib.Flags[Flag] = Value end
                        Callback(Value)
                        conn:Disconnect()
                    end)
                end)
            end

            function Section:Dropdown(Config)
                Config = Config or {}
                local Name = Config.Name or "Dropdown"
                local List = Config.List or {}
                local Callback = Config.Callback or function() end
                local Multi = Config.Multi or false
                local Default = Config.Default
                local Flag = Config.Flag

                local Selected = Multi and {} or (Default or List[1]) or ""

                if Flag then NexusLib.Flags[Flag] = Selected end

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundTransparency = 1
                Frame.Parent = SectionContent

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -100, 0, 18)
                Label.BackgroundTransparency = 1
                Label.Text = Name
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local DropButton = Instance.new("TextButton")
                DropButton.Size = UDim2.new(1, 0, 0, 30)
                DropButton.Position = UDim2.new(0, 0, 0, 20)
                DropButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                DropButton.Text = Multi and "None" or tostring(Selected)
                DropButton.TextColor3 = Color3.fromRGB(220, 220, 220)
                DropButton.Font = Enum.Font.Gotham
                DropButton.TextSize = 14
                DropButton.TextXAlignment = Enum.TextXAlignment.Left
                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 6)
                DropCorner.Parent = DropButton
                DropButton.Parent = Frame

                local DropList = Instance.new("Frame")
                DropList.Size = UDim2.new(1, 0, 0, 0)
                DropList.Position = UDim2.new(0, 0, 1, 4)
                DropList.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                DropList.Visible = false
                DropList.ClipsDescendants = true
                local ListCorner = Instance.new("UICorner")
                ListCorner.CornerRadius = UDim.new(0, 6)
                ListCorner.Parent = DropList
                DropList.Parent = DropButton

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Padding = UDim.new(0, 2)
                ListLayout.Parent = DropList

                local SearchBox = Instance.new("TextBox")
                SearchBox.Size = UDim2.new(1, -10, 0, 26)
                SearchBox.Position = UDim2.new(0, 5, 0, 5)
                SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                SearchBox.PlaceholderText = "Search..."
                SearchBox.Text = ""
                SearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
                local SearchCorner = Instance.new("UICorner")
                SearchCorner.CornerRadius = UDim.new(0, 6)
                SearchCorner.Parent = SearchBox
                SearchBox.Parent = DropList

                local Items = {}

                local function RefreshList()
                    for _, v in ipairs(Items) do v:Destroy() end
                    Items = {}

                    local count = 0
                    for _, v in ipairs(List) do
                        if string.find(string.lower(v), string.lower(SearchBox.Text)) or SearchBox.Text == "" then
                            count = count + 1

                            local Item = Instance.new("TextButton")
                            Item.Size = UDim2.new(1, -10, 0, 26)
                            Item.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                            Item.Text = v
                            Item.TextColor3 = Color3.fromRGB(220, 220, 220)
                            Item.Font = Enum.Font.Gotham
                            Item.TextSize = 14
                            local ItemCorner = Instance.new("UICorner")
                            ItemCorner.CornerRadius = UDim.new(0, 6)
                            ItemCorner.Parent = Item
                            Item.Parent = DropList

                            if Multi and table.find(Selected, v) then
                                Item.Text = "[✓] " .. v
                            end

                            Item.MouseButton1Click:Connect(function()
                                if Multi then
                                    if table.find(Selected, v) then
                                        table.remove(Selected, table.find(Selected, v))
                                    else
                                        table.insert(Selected, v)
                                    end
                                    Item.Text = table.find(Selected, v) and "[✓] " .. v or v
                                    DropButton.Text = #Selected > 0 and table.concat(Selected, ", ") or "None"
                                else
                                    Selected = v
                                    DropButton.Text = v
                                    DropList.Visible = false
                                    TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                                end
                                if Flag then NexusLib.Flags[Flag] = Selected end
                                Callback(Selected)
                            end)

                            table.insert(Items, Item)
                        end
                    end

                    TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.clamp(count * 28 + 36, 0, 150))}):Play()
                end

                RefreshList()

                SearchBox:GetPropertyChangedSignal("Text"):Connect(RefreshList)

                DropButton.MouseButton1Click:Connect(function()
                    DropList.Visible = not DropList.Visible
                    if DropList.Visible then
                        TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.clamp(#List * 28 + 36, 0, 150))}):Play()
                    else
                        TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    end
                end)
            end

            function Section:Colorpicker(Config)
                Config = Config or {}
                local Name = Config.Name or "Colorpicker"
                local Callback = Config.Callback or function() end
                local Default = Config.Default or Color3.fromRGB(255, 255, 255)
                local Flag = Config.Flag

                local Value = Default
                if Flag then NexusLib.Flags[Flag] = Value end

                local Rainbow = false

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 30)
                Frame.BackgroundTransparency = 1
                Frame.Parent = SectionContent

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -100, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = Name
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local PickerButton = Instance.new("Frame")
                PickerButton.Size = UDim2.new(0, 30, 0, 30)
                PickerButton.Position = UDim2.new(1, -40, 0, 0)
                PickerButton.BackgroundColor3 = Value
                local PickerCorner = Instance.new("UICorner")
                PickerCorner.CornerRadius = UDim.new(0, 6)
                PickerCorner.Parent = PickerButton
                PickerButton.Parent = Frame

                local Picker = Instance.new("Frame")
                Picker.Size = UDim2.new(0, 160, 0, 170)
                Picker.Position = UDim2.new(1, -170, 0, 35)
                Picker.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Picker.Visible = false
                Picker.ZIndex = 10
                local PickerCorner = Instance.new("UICorner")
                PickerCorner.CornerRadius = UDim.new(0, 8)
                PickerCorner.Parent = Picker
                Picker.Parent = Frame

                local SatVal = Instance.new("ImageLabel")
                SatVal.Size = UDim2.new(0, 130, 0, 130)
                SatVal.Position = UDim2.new(0, 15, 0, 15)
                SatVal.BackgroundColor3 = Value
                SatVal.Image = "rbxassetid://4650897272"
                SatVal.ZIndex = 11
                local SatValCorner = Instance.new("UICorner")
                SatValCorner.CornerRadius = UDim.new(0, 6)
                SatValCorner.Parent = SatVal
                SatVal.Parent = Picker

                local Hue = Instance.new("ImageLabel")
                Hue.Size = UDim2.new(0, 18, 0, 130)
                Hue.Position = UDim2.new(0, 150, 0, 15)
                Hue.Image = "rbxassetid://4650897105"
                Hue.BackgroundTransparency = 1
                Hue.ZIndex = 11
                Hue.Parent = Picker

                local RainbowToggle = Instance.new("TextButton")
                RainbowToggle.Size = UDim2.new(1, -30, 0, 24)
                RainbowToggle.Position = UDim2.new(0, 15, 1, -35)
                RainbowToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                RainbowToggle.Text = "Rainbow: OFF"
                RainbowToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
                RainbowToggle.ZIndex = 11
                local RTCorner = Instance.new("UICorner")
                RTCorner.CornerRadius = UDim.new(0, 6)
                RTCorner.Parent = RainbowToggle
                RainbowToggle.Parent = Picker

                local PickerIndicator = Instance.new("Frame")
                PickerIndicator.Size = UDim2.new(0, 8, 0, 8)
                PickerIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                PickerIndicator.ZIndex = 12
                PickerIndicator.Parent = SatVal

                local HueIndicator = Instance.new("Frame")
                HueIndicator.Size = UDim2.new(1, 0, 0, 4)
                HueIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueIndicator.ZIndex = 12
                HueIndicator.Parent = Hue

                local H, S, V = Color3.toHSV(Value)
                PickerIndicator.Position = UDim2.new(S, -4, 1 - V, -4)

                local HuePos = UDim2.new(0, 0, H, -2)
                HueIndicator.Position = HuePos

                local DraggingPicker = false
                local DraggingHue = false

                SatVal.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        DraggingPicker = true
                    end
                end)

                Hue.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        DraggingHue = true
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        DraggingPicker = false
                        DraggingHue = false
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    if DraggingPicker then
                        local mousePos = UserInputService:GetMouseLocation()
                        local relX = math.clamp((mousePos.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((mousePos.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
                        S = relX
                        V = 1 - relY
                        PickerIndicator.Position = UDim2.new(relX, -4, relY, -4)
                        Value = Color3.fromHSV(H, S, V)
                        PickerButton.BackgroundColor3 = Value
                        if Flag then NexusLib.Flags[Flag] = Value end
                        Callback(Value)
                    end

                    if DraggingHue then
                        local mousePos = UserInputService:GetMouseLocation()
                        local relY = math.clamp((mousePos.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)
                        H = relY
                        HueIndicator.Position = UDim2.new(0, 0, relY, -2)
                        Value = Color3.fromHSV(H, S, V)
                        PickerButton.BackgroundColor3 = Value
                        SatVal.BackgroundColor3 = Value
                        if Flag then NexusLib.Flags[Flag] = Value end
                        Callback(Value)
                    end

                    if Rainbow then
                        local rainbowHue = tick() % 5 / 5
                        Value = Color3.fromHSV(rainbowHue, S, V)
                        PickerButton.BackgroundColor3 = Value
                        if Flag then NexusLib.Flags[Flag] = Value end
                        Callback(Value)
                    end
                end)

                RainbowToggle.MouseButton1Click:Connect(function()
                    Rainbow = not Rainbow
                    RainbowToggle.Text = Rainbow and "Rainbow: ON" or "Rainbow: OFF"
                end)

                PickerButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
