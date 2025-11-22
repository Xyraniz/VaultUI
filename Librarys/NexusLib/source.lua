local UILib = {}
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local function RippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.ZIndex = button.ZIndex + 1
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Parent = button

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple

    TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    }):Play()

    wait(0.5)
    ripple:Destroy()
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
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
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function UILib:Notification(title, desc, duration)
    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notif.Size = UDim2.new(0, 250, 0, 70)
    notif.Position = UDim2.new(1, -260, 1, -80)
    notif.Parent = game.CoreGui:FindFirstChild("UILibGUI") or Instance.new("ScreenGui", game.CoreGui).Name = "UILibGUI"
    notif.AnchorPoint = Vector2.new(1, 1)

    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 5)

    local titleLabel = Instance.new("TextLabel", notif)
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Size = UDim2.new(1, -10, 0, 20)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1

    local descLabel = Instance.new("TextLabel", notif)
    descLabel.Text = desc
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.Size = UDim2.new(1, -10, 0, 40)
    descLabel.Position = UDim2.new(0, 5, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.TextWrapped = true

    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, -10, 1, -80)}):Play()
    wait(duration or 3)
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 260, 1, -80)}):Play()
    wait(0.3)
    notif:Destroy()
end

function UILib:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibGUI"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.ClipsDescendants = true

    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    local closeBtn = Instance.new("TextButton", titleLabel)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        screenGui:Destroy()
    end)

    local minimizeBtn = Instance.new("TextButton", titleLabel)
    minimizeBtn.Text = "-"
    minimizeBtn.Font = Enum.Font.Gotham
    minimizeBtn.TextSize = 14
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 400, 0, 30)}):Play()
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 400, 0, 250)}):Play()
        end
    end)

    MakeDraggable(titleLabel)

    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

    local tabLayout = Instance.new("UIListLayout", tabContainer)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local contentContainer = Instance.new("Frame", mainFrame)
    contentContainer.Size = UDim2.new(1, 0, 1, -60)
    contentContainer.Position = UDim2.new(0, 0, 0, 60)
    contentContainer.BackgroundTransparency = 1

    local Window = {}
    local tabs = {}
    local currentTab = nil

    function Window:Tab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Text = tabName
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 14
        tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabBtn.Size = UDim2.new(0, 100, 1, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabContainer

        local tabCorner = Instance.new("UICorner", tabBtn)
        tabCorner.CornerRadius = UDim.new(0, 5)

        local tabContent = Instance.new("ScrollingFrame", contentContainer)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 2
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false

        local contentLayout = Instance.new("UIListLayout", tabContent)
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

        tabContent.ChildAdded:Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)

        tabs[tabName] = tabContent

        tabBtn.MouseButton1Click:Connect(function()
            RippleEffect(tabBtn)
            if currentTab then
                currentTab.Visible = false
            end
            tabContent.Visible = true
            currentTab = tabContent
        end)

        if not currentTab then
            tabContent.Visible = true
            currentTab = tabContent
        end

        local Tab = {}

        function Tab:Section(sectionName)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, -10, 0, 30)
            section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            section.Parent = tabContent

            local sectionCorner = Instance.new("UICorner", section)
            sectionCorner.CornerRadius = UDim.new(0, 5)

            local sectionLabel = Instance.new("TextLabel", section)
            sectionLabel.Text = sectionName
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 14
            sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionLabel.Size = UDim2.new(1, 0, 1, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Center

            local sectionContent = Instance.new("Frame", tabContent)
            sectionContent.Size = UDim2.new(1, -20, 0, 0)
            sectionContent.Position = UDim2.new(0, 10, 0, 0)
            sectionContent.BackgroundTransparency = 1
            sectionContent.ClipsDescendants = true
            sectionContent.AutomaticSize = Enum.AutomaticSize.Y

            local sectionLayout = Instance.new("UIListLayout", sectionContent)
            sectionLayout.Padding = UDim.new(0, 5)
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local Section = {}
            function Section:Button(text, callback)
                local btn = Instance.new("TextButton")
                btn.Text = text
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn.Parent = sectionContent
                btn.AutoButtonColor = false

                local btnCorner = Instance.new("UICorner", btn)
                btnCorner.CornerRadius = UDim.new(0, 5)

                btn.MouseButton1Click:Connect(function()
                    RippleEffect(btn)
                    pcall(callback)
                end)
            end

            function Section:Toggle(text, default, callback)
                local toggled = default or false
                local toggle = Instance.new("Frame")
                toggle.Size = UDim2.new(1, 0, 0, 30)
                toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                toggle.Parent = sectionContent

                local toggleCorner = Instance.new("UICorner", toggle)
                toggleCorner.CornerRadius = UDim.new(0, 5)

                local toggleLabel = Instance.new("TextLabel", toggle)
                toggleLabel.Text = text
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.TextSize = 14
                toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                toggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
                toggleLabel.BackgroundTransparency = 1

                local toggleSwitch = Instance.new("Frame", toggle)
                toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
                toggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
                toggleSwitch.BackgroundColor3 = toggled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(100, 100, 100)

                local switchCorner = Instance.new("UICorner", toggleSwitch)
                switchCorner.CornerRadius = UDim.new(0, 10)

                local switchKnob = Instance.new("Frame", toggleSwitch)
                switchKnob.Size = UDim2.new(0, 20, 0, 20)
                switchKnob.Position = toggled and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)
                switchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                local knobCorner = Instance.new("UICorner", switchKnob)
                knobCorner.CornerRadius = UDim.new(0, 10)

                local toggleBtn = Instance.new("TextButton", toggle)
                toggleBtn.Size = UDim2.new(1, 0, 1, 0)
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.Text = ""

                toggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(100, 100, 100)}):Play()
                    TweenService:Create(switchKnob, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)}):Play()
                    pcall(callback, toggled)
                end)
            end

            function Section:Slider(text, min, max, default, callback)
                local value = default or min
                local slider = Instance.new("Frame")
                slider.Size = UDim2.new(1, 0, 0, 40)
                slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                slider.Parent = sectionContent

                local sliderCorner = Instance.new("UICorner", slider)
                sliderCorner.CornerRadius = UDim.new(0, 5)

                local sliderLabel = Instance.new("TextLabel", slider)
                sliderLabel.Text = text .. ": " .. value
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.TextSize = 14
                sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                sliderLabel.Size = UDim2.new(1, 0, 0, 20)
                sliderLabel.BackgroundTransparency = 1

                local sliderBar = Instance.new("Frame", slider)
                sliderBar.Size = UDim2.new(1, 0, 0, 5)
                sliderBar.Position = UDim2.new(0, 0, 0, 25)
                sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

                local barCorner = Instance.new("UICorner", sliderBar)
                barCorner.CornerRadius = UDim.new(0, 3)

                local sliderFill = Instance.new("Frame", sliderBar)
                sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 100)

                local fillCorner = Instance.new("UICorner", sliderFill)
                fillCorner.CornerRadius = UDim.new(0, 3)

                local sliderBtn = Instance.new("TextButton", sliderBar)
                sliderBtn.Size = UDim2.new(1, 0, 1, 0)
                sliderBtn.BackgroundTransparency = 1
                sliderBtn.Text = ""

                local dragging = false
                sliderBtn.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                RunService.RenderStepped:Connect(function()
                    if dragging then
                        local pos = math.clamp((Mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * pos)
                        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                        sliderLabel.Text = text .. ": " .. value
                        pcall(callback, value)
                    end
                end)
            end

            function Section:Dropdown(text, options, default, callback)
                local selected = default or options[1]
                local dropdown = Instance.new("Frame")
                dropdown.Size = UDim2.new(1, 0, 0, 30)
                dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                dropdown.Parent = sectionContent
                dropdown.ClipsDescendants = true

                local dropdownCorner = Instance.new("UICorner", dropdown)
                dropdownCorner.CornerRadius = UDim.new(0, 5)

                local dropdownLabel = Instance.new("TextLabel", dropdown)
                dropdownLabel.Text = text .. ": " .. selected
                dropdownLabel.Font = Enum.Font.Gotham
                dropdownLabel.TextSize = 14
                dropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                dropdownLabel.Size = UDim2.new(1, 0, 1, 0)
                dropdownLabel.BackgroundTransparency = 1

                local open = false
                local dropdownBtn = Instance.new("TextButton", dropdown)
                dropdownBtn.Size = UDim2.new(1, 0, 1, 0)
                dropdownBtn.BackgroundTransparency = 1
                dropdownBtn.Text = ""

                dropdownBtn.MouseButton1Click:Connect(function()
                    open = not open
                    local targetSize = open and UDim2.new(1, 0, 0, 30 + #options * 25) or UDim2.new(1, 0, 0, 30)
                    TweenService:Create(dropdown, TweenInfo.new(0.3), {Size = targetSize}):Play()
                end)

                local optionFrames = {}
                for i, opt in ipairs(options) do
                    local optBtn = Instance.new("TextButton", dropdown)
                    optBtn.Text = opt
                    optBtn.Font = Enum.Font.Gotham
                    optBtn.TextSize = 14
                    optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    optBtn.Size = UDim2.new(1, 0, 0, 25)
                    optBtn.Position = UDim2.new(0, 0, 0, 30 + (i-1)*25)
                    optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

                    local optCorner = Instance.new("UICorner", optBtn)
                    optCorner.CornerRadius = UDim.new(0, 5)

                    optBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        dropdownLabel.Text = text .. ": " .. selected
                        pcall(callback, selected)
                        open = false
                        TweenService:Create(dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                    end)

                    table.insert(optionFrames, optBtn)
                end

                dropdown:GetPropertyChangedSignal("Size"):Connect(function()
                    for _, optBtn in ipairs(optionFrames) do
                        optBtn.Visible = open
                    end
                end)
            end

            function Section:ColorPicker(text, default, callback)
                local color = default or Color3.fromRGB(255, 255, 255)
                local colorPicker = Instance.new("Frame")
                colorPicker.Size = UDim2.new(1, 0, 0, 150)
                colorPicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                colorPicker.Parent = sectionContent

                local cpCorner = Instance.new("UICorner", colorPicker)
                cpCorner.CornerRadius = UDim.new(0, 5)

                local cpLabel = Instance.new("TextLabel", colorPicker)
                cpLabel.Text = text
                cpLabel.Font = Enum.Font.Gotham
                cpLabel.TextSize = 14
                cpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                cpLabel.Size = UDim2.new(1, 0, 0, 20)
                cpLabel.BackgroundTransparency = 1

                local colorWheel = Instance.new("ImageLabel", colorPicker)
                colorWheel.Size = UDim2.new(0, 100, 0, 100)
                colorWheel.Position = UDim2.new(0, 10, 0, 30)
                colorWheel.Image = "rbxassetid://4155801252"
                colorWheel.BackgroundColor3 = color

                local wheelCorner = Instance.new("UICorner", colorWheel)
                wheelCorner.CornerRadius = UDim.new(0, 5)

                local colorSelector = Instance.new("Frame", colorWheel)
                colorSelector.Size = UDim2.new(0, 10, 0, 10)
                colorSelector.AnchorPoint = Vector2.new(0.5, 0.5)
                colorSelector.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

                local selectorCorner = Instance.new("UICorner", colorSelector)
                selectorCorner.CornerRadius = UDim.new(1, 0)

                local hueBar = Instance.new("Frame", colorPicker)
                hueBar.Size = UDim2.new(0, 20, 0, 100)
                hueBar.Position = UDim2.new(0, 120, 0, 30)
                hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                local hueGradient = Instance.new("UIGradient", hueBar)
                hueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }

                local hueCorner = Instance.new("UICorner", hueBar)
                hueCorner.CornerRadius = UDim.new(0, 5)

                local hueSelector = Instance.new("Frame", hueBar)
                hueSelector.Size = UDim2.new(1, 0, 0, 5)
                hueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                local h, s, v = color:ToHSV()
                colorSelector.Position = UDim2.new(s, 0, 1 - v, 0)
                hueSelector.Position = UDim2.new(0, 0, 1 - h, 0)

                local colorInput, hueInput

                colorWheel.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if colorInput then colorInput:Disconnect() end
                        colorInput = RunService.RenderStepped:Connect(function()
                            local x = math.clamp((Mouse.X - colorWheel.AbsolutePosition.X) / colorWheel.AbsoluteSize.X, 0, 1)
                            local y = math.clamp((Mouse.Y - colorWheel.AbsolutePosition.Y) / colorWheel.AbsoluteSize.Y, 0, 1)
                            colorSelector.Position = UDim2.new(x, 0, y, 0)
                            s = x
                            v = 1 - y
                            color = Color3.fromHSV(h, s, v)
                            colorWheel.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                            pcall(callback, color)
                        end)
                    end
                end)

                colorWheel.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if colorInput then colorInput:Disconnect() end
                    end
                end)

                hueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if hueInput then hueInput:Disconnect() end
                        hueInput = RunService.RenderStepped:Connect(function()
                            local y = math.clamp((Mouse.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                            hueSelector.Position = UDim2.new(0, 0, y, 0)
                            h = 1 - y
                            color = Color3.fromHSV(h, s, v)
                            colorWheel.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                            pcall(callback, color)
                        end)
                    end
                end)

                hueBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if hueInput then hueInput:Disconnect() end
                    end
                end)
            end

            function Section:Textbox(text, placeholder, callback)
                local textbox = Instance.new("Frame")
                textbox.Size = UDim2.new(1, 0, 0, 30)
                textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                textbox.Parent = sectionContent

                local tbCorner = Instance.new("UICorner", textbox)
                tbCorner.CornerRadius = UDim.new(0, 5)

                local tbLabel = Instance.new("TextLabel", textbox)
                tbLabel.Text = text
                tbLabel.Font = Enum.Font.Gotham
                tbLabel.TextSize = 14
                tbLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                tbLabel.Size = UDim2.new(0.5, 0, 1, 0)
                tbLabel.BackgroundTransparency = 1

                local tbInput = Instance.new("TextBox", textbox)
                tbInput.PlaceholderText = placeholder
                tbInput.Font = Enum.Font.Gotham
                tbInput.TextSize = 14
                tbInput.TextColor3 = Color3.fromRGB(255, 255, 255)
                tbInput.Size = UDim2.new(0.5, 0, 1, 0)
                tbInput.Position = UDim2.new(0.5, 0, 0, 0)
                tbInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                tbInput.ClearTextOnFocus = false

                local inputCorner = Instance.new("UICorner", tbInput)
                inputCorner.CornerRadius = UDim.new(0, 5)

                tbInput.FocusLost:Connect(function(enter)
                    if enter then
                        pcall(callback, tbInput.Text)
                    end
                end)
            end

            function Section:Label(text)
                local label = Instance.new("TextLabel")
                label.Text = text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextColor3 = Color3.fromRGB(200, 200, 200)
                label.Size = UDim2.new(1, 0, 0, 30)
                label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                label.Parent = sectionContent
                label.TextWrapped = true

                local labelCorner = Instance.new("UICorner", label)
                labelCorner.CornerRadius = UDim.new(0, 5)
            end

            function Section:Keybind(text, default, callback)
                local key = default or Enum.KeyCode.Unknown
                local keybind = Instance.new("Frame")
                keybind.Size = UDim2.new(1, 0, 0, 30)
                keybind.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                keybind.Parent = sectionContent

                local kbCorner = Instance.new("UICorner", keybind)
                kbCorner.CornerRadius = UDim.new(0, 5)

                local kbLabel = Instance.new("TextLabel", keybind)
                kbLabel.Text = text .. ": " .. key.Name
                kbLabel.Font = Enum.Font.Gotham
                kbLabel.TextSize = 14
                kbLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                kbLabel.Size = UDim2.new(1, 0, 1, 0)
                kbLabel.BackgroundTransparency = 1

                local kbBtn = Instance.new("TextButton", keybind)
                kbBtn.Size = UDim2.new(1, 0, 1, 0)
                kbBtn.BackgroundTransparency = 1
                kbBtn.Text = ""

                local binding = false
                kbBtn.MouseButton1Click:Connect(function()
                    binding = true
                    kbLabel.Text = text .. ": ..."
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if binding then
                        if input.KeyCode ~= Enum.KeyCode.Unknown then
                            key = input.KeyCode
                            kbLabel.Text = text .. ": " .. key.Name
                            binding = false
                        end
                    elseif input.KeyCode == key then
                        pcall(callback)
                    end
                end)
            end

            function Section:Separator()
                local sep = Instance.new("Frame")
                sep.Size = UDim2.new(1, 0, 0, 5)
                sep.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                sep.Parent = sectionContent

                local sepCorner = Instance.new("UICorner", sep)
                sepCorner.CornerRadius = UDim.new(0, 3)
            end

            function Section:ImageButton(imageId, callback)
                local imgBtn = Instance.new("ImageButton")
                imgBtn.Image = "rbxassetid://" .. imageId
                imgBtn.Size = UDim2.new(1, 0, 0, 100)
                imgBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                imgBtn.Parent = sectionContent

                local imgCorner = Instance.new("UICorner", imgBtn)
                imgCorner.CornerRadius = UDim.new(0, 5)

                imgBtn.MouseButton1Click:Connect(function()
                    RippleEffect(imgBtn)
                    pcall(callback)
                end)
            end

            function Section:ProgressBar(max, default)
                local value = default or 0
                local progress = Instance.new("Frame")
                progress.Size = UDim2.new(1, 0, 0, 20)
                progress.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                progress.Parent = sectionContent

                local progCorner = Instance.new("UICorner", progress)
                progCorner.CornerRadius = UDim.new(0, 10)

                local progFill = Instance.new("Frame", progress)
                progFill.Size = UDim2.new(value / max, 0, 1, 0)
                progFill.BackgroundColor3 = Color3.fromRGB(100, 200, 100)

                local fillCorner = Instance.new("UICorner", progFill)
                fillCorner.CornerRadius = UDim.new(0, 10)

                local Prog = {}
                function Prog:Set(newValue)
                    TweenService:Create(progFill, TweenInfo.new(0.5), {Size = UDim2.new(newValue / max, 0, 1, 0)}):Play()
                end
                return Prog
            end

            return Section
        end

        return Tab
    end

    return Window
end

return UILib