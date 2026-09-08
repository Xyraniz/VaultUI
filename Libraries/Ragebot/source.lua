-- Ragebot Menu / VaultUI library
-- Original interface preserved and wrapped as a reusable constructor.
-- Default visibility key: INSERT. Configure with Settings.Keybind.

local Ragebot = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function buildWindow(Settings)

    -- Services (simplified)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")


    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RagebotUI"
    ScreenGui.Parent = (gethui and gethui()) or CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false


    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -421.5, 0.5, -287.5)
    MainFrame.Size = UDim2.new(0, 843, 0, 575)
    MainFrame.Visible = false
    MainFrame.Active = true
    -- Draggable removed - will add custom drag only for header


    -- Corner for main frame
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 60)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    -- Logo Icon
    local LogoIcon = Instance.new("ImageLabel")
    LogoIcon.Parent = Header
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Position = UDim2.new(0, 20, 0, 12)
    LogoIcon.Size = UDim2.new(0, 36, 0, 36)
    LogoIcon.Image = "rbxassetid://97446581390925"
    LogoIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    LogoIcon.ScaleType = Enum.ScaleType.Fit

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 70, 0, 18)
    Title.Size = UDim2.new(0, 200, 0, 24)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Ragebot"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left



    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.Size = UDim2.new(0, 70, 0, 515)

    -- Tab system
    local currentTab = 2
    local tabs = {}

    -- Sidebar icons with tab switching
    local sidebarIcons = {
        {icon = "rbxassetid://98370306170658", y = 15, name = "Legitbot", size = {16.9, 16.9}},
        {icon = "rbxassetid://107512202152283", y = 85, active = true, name = "Ragebot", size = {19, 19}},
        {icon = "rbxassetid://127827492424396", y = 155, name = "Enemy", size = {28, 26}},
        {icon = "rbxassetid://100545076798978", y = 225, name = "World", size = {32, 32}},
        {icon = "rbxassetid://107710676270056", y = 295, name = "SkinChanger", size = {48, 46}},
        {icon = "rbxassetid://103915348216097", y = 365, name = "Misc", size = {37, 35}},
        {icon = "rbxassetid://97047003599965", y = 435, name = "Config", size = {20, 20}}
    }

    for index, iconData in ipairs(sidebarIcons) do
        local IconFrame = Instance.new("Frame")
        IconFrame.Parent = Sidebar
        IconFrame.Name = "Tab_" .. index
        IconFrame.BackgroundColor3 = iconData.active and Color3.fromRGB(25, 25, 25) or Color3.fromRGB(18, 18, 18)
        IconFrame.BorderSizePixel = 0
        IconFrame.Position = UDim2.new(0, 0, 0, iconData.y)
        IconFrame.Size = UDim2.new(1, 0, 0, 60)

        local ActiveIndicator = Instance.new("Frame")
        ActiveIndicator.Parent = IconFrame
        ActiveIndicator.Name = "Indicator"
        ActiveIndicator.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
        ActiveIndicator.BorderSizePixel = 0
        ActiveIndicator.Position = UDim2.new(0, 0, 0, 0)
        ActiveIndicator.Size = UDim2.new(0, iconData.active and 4 or 0, 1, 0)

        -- Icon - either ImageLabel or TextLabel
        if iconData.isText then
            -- Text icon (gear) - will be replaced with image later
            local Icon = Instance.new("TextLabel")
            Icon.Parent = IconFrame
            Icon.BackgroundTransparency = 1
            Icon.Size = UDim2.new(1, 0, 1, 0)
            Icon.Font = Enum.Font.GothamBold
            Icon.Text = iconData.icon
            Icon.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White gear
            Icon.TextSize = 20
        else
            -- Image icon with custom size
            local Icon = Instance.new("ImageLabel")
            Icon.Parent = IconFrame
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0.5, -iconData.size[1]/2, 0.5, -iconData.size[2]/2)
            Icon.Size = UDim2.new(0, iconData.size[1], 0, iconData.size[2])
            Icon.Image = iconData.icon
            Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
            Icon.ScaleType = Enum.ScaleType.Fit
        end

        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = IconFrame
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Text = ""
        TabButton.ZIndex = 3

        TabButton.MouseButton1Click:Connect(function()
            -- Deactivate all tabs
            for i, tab in ipairs(tabs) do
                local frame = Sidebar:FindFirstChild("Tab_" .. i)
                if frame then
                    local indicator = frame:FindFirstChild("Indicator")
                    TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 18, 18)}):Play()
                    TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 1, 0)}):Play()
                end
                if tab.content then
                    tab.content.Visible = false
                end
            end

            -- Activate current tab
            currentTab = index
            TweenService:Create(IconFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            TweenService:Create(ActiveIndicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 1, 0)}):Play()

            -- Update header title
            Title.Text = iconData.name

            if tabs[index] and tabs[index].content then
                tabs[index].content.Visible = true
            end

            print("Switched to tab: " .. iconData.name)
        end)

        -- Hover effect
        TabButton.MouseEnter:Connect(function()
            if currentTab ~= index then
                TweenService:Create(IconFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play()
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if currentTab ~= index then
                TweenService:Create(IconFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18, 18, 18)}):Play()
            end
        end)

        tabs[index] = {name = iconData.name, frame = IconFrame, content = nil}
    end

    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 70, 0, 60)
    ContentFrame.Size = UDim2.new(1, -70, 1, -60)
    ContentFrame.ClipsDescendants = true

    -- Tab Content Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = ContentFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.Visible = true

    -- GLOBALS Section
    local GlobalsSection = Instance.new("Frame")
    GlobalsSection.Name = "GlobalsSection"
    GlobalsSection.Parent = TabContainer
    GlobalsSection.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    GlobalsSection.BorderSizePixel = 0
    GlobalsSection.Position = UDim2.new(0, 18, 0, 18)
    GlobalsSection.Size = UDim2.new(0, 350, 0, 475)
    GlobalsSection.ClipsDescendants = false

    local GlobalsCorner = Instance.new("UICorner")
    GlobalsCorner.CornerRadius = UDim.new(0, 6)
    GlobalsCorner.Parent = GlobalsSection

    -- GLOBALS Title
    local GlobalsTitle = Instance.new("TextLabel")
    GlobalsTitle.Parent = GlobalsSection
    GlobalsTitle.BackgroundTransparency = 1
    GlobalsTitle.Position = UDim2.new(0, 15, 0, 10)
    GlobalsTitle.Size = UDim2.new(1, -30, 0, 25)
    GlobalsTitle.Font = Enum.Font.GothamBold
    GlobalsTitle.Text = "GLOBALS"
    GlobalsTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    GlobalsTitle.TextSize = 12
    GlobalsTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- AIMBOT Section
    local AimbotSection = Instance.new("Frame")
    AimbotSection.Name = "AimbotSection"
    AimbotSection.Parent = TabContainer
    AimbotSection.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    AimbotSection.BorderSizePixel = 0
    AimbotSection.Position = UDim2.new(0, 385, 0, 18)
    AimbotSection.Size = UDim2.new(0, 350, 0, 475)
    AimbotSection.ClipsDescendants = false

    local AimbotCorner = Instance.new("UICorner")
    AimbotCorner.CornerRadius = UDim.new(0, 6)
    AimbotCorner.Parent = AimbotSection

    -- AIMBOT Title
    local AimbotTitle = Instance.new("TextLabel")
    AimbotTitle.Parent = AimbotSection
    AimbotTitle.BackgroundTransparency = 1
    AimbotTitle.Position = UDim2.new(0, 15, 0, 10)
    AimbotTitle.Size = UDim2.new(1, -30, 0, 25)
    AimbotTitle.Font = Enum.Font.GothamBold
    AimbotTitle.Text = "AIMBOT"
    AimbotTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    AimbotTitle.TextSize = 12
    AimbotTitle.TextXAlignment = Enum.TextXAlignment.Left


    -- ========================================
    -- HELPER FUNCTIONS (MUST BE DEFINED BEFORE USE!)
    -- ========================================

    -- NOTE: Visuals tab and other content will be created AFTER
    -- all helper functions are defined (at the end of the file)



    -- Helper function to create color picker with gradient square + hue bar
    local function createColorPicker(parent, yPos, label, defaultColor)
        local currentColor = defaultColor or Color3.fromRGB(255, 255, 255)
        local currentHue = 0
        local currentSat = 1
        local currentVal = 1
        local pickerOpen = false

        local ColorFrame = Instance.new("Frame")
        ColorFrame.Parent = parent
        ColorFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        ColorFrame.BorderSizePixel = 0
        ColorFrame.Position = UDim2.new(0, 15, 0, yPos)
        ColorFrame.Size = UDim2.new(1, -30, 0, 30)
        ColorFrame.ClipsDescendants = false
        ColorFrame.ZIndex = 5

        local ColorCorner = Instance.new("UICorner")
        ColorCorner.CornerRadius = UDim.new(0, 4)
        ColorCorner.Parent = ColorFrame

        local Label = Instance.new("TextLabel")
        Label.Parent = ColorFrame
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.Size = UDim2.new(0, 220, 1, 0)
        Label.Font = Enum.Font.Gotham
        Label.Text = label
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 6

        -- Color preview box
        local ColorPreview = Instance.new("TextButton")
        ColorPreview.Parent = ColorFrame
        ColorPreview.BackgroundColor3 = currentColor
        ColorPreview.BorderColor3 = Color3.fromRGB(60, 60, 60)
        ColorPreview.BorderSizePixel = 1
        ColorPreview.Position = UDim2.new(1, -28, 0.5, -10)
        ColorPreview.Size = UDim2.new(0, 20, 0, 20)
        ColorPreview.Text = ""
        ColorPreview.ZIndex = 6

        local PreviewCorner = Instance.new("UICorner")
        PreviewCorner.CornerRadius = UDim.new(0, 3)
        PreviewCorner.Parent = ColorPreview

        -- Color palette panel
        local PalettePanel = Instance.new("Frame")
        PalettePanel.Parent = ScreenGui
        PalettePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        PalettePanel.BorderSizePixel = 0
        PalettePanel.Position = UDim2.new(0, 0, 0, 0)
        PalettePanel.Size = UDim2.new(0, 0, 0, 0)
        PalettePanel.Visible = false
        PalettePanel.ClipsDescendants = true
        PalettePanel.ZIndex = 30

        local PaletteCorner = Instance.new("UICorner")
        PaletteCorner.CornerRadius = UDim.new(0, 6)
        PaletteCorner.Parent = PalettePanel

        -- Gradient Square (Saturation + Value)
        local GradientSquare = Instance.new("ImageButton")
        GradientSquare.Parent = PalettePanel
        GradientSquare.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
        GradientSquare.BorderSizePixel = 0
        GradientSquare.Position = UDim2.new(0, 10, 0, 10)
        GradientSquare.Size = UDim2.new(0, 180, 0, 180)
        GradientSquare.AutoButtonColor = false
        GradientSquare.ZIndex = 31

        local SquareCorner = Instance.new("UICorner")
        SquareCorner.CornerRadius = UDim.new(0, 4)
        SquareCorner.Parent = GradientSquare

        -- White to Transparent gradient (Saturation)
        local SatGradient = Instance.new("Frame")
        SatGradient.Parent = GradientSquare
        SatGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SatGradient.BackgroundTransparency = 0
        SatGradient.BorderSizePixel = 0
        SatGradient.Size = UDim2.new(1, 0, 1, 0)
        SatGradient.ZIndex = 32

        local SatGradientUI = Instance.new("UIGradient")
        SatGradientUI.Parent = SatGradient
        SatGradientUI.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        SatGradientUI.Rotation = 0

        local SatCorner = Instance.new("UICorner")
        SatCorner.CornerRadius = UDim.new(0, 4)
        SatCorner.Parent = SatGradient

        -- Black gradient (Value)
        local ValGradient = Instance.new("Frame")
        ValGradient.Parent = GradientSquare
        ValGradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ValGradient.BackgroundTransparency = 0
        ValGradient.BorderSizePixel = 0
        ValGradient.Size = UDim2.new(1, 0, 1, 0)
        ValGradient.ZIndex = 33

        local ValGradientUI = Instance.new("UIGradient")
        ValGradientUI.Parent = ValGradient
        ValGradientUI.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
        ValGradientUI.Rotation = 90

        local ValCorner = Instance.new("UICorner")
        ValCorner.CornerRadius = UDim.new(0, 4)
        ValCorner.Parent = ValGradient

        -- Picker cursor
        local PickerCursor = Instance.new("Frame")
        PickerCursor.Parent = GradientSquare
        PickerCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PickerCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PickerCursor.BorderSizePixel = 2
        PickerCursor.Position = UDim2.new(currentSat, -5, 1 - currentVal, -5)
        PickerCursor.Size = UDim2.new(0, 10, 0, 10)
        PickerCursor.ZIndex = 34

        local CursorCorner = Instance.new("UICorner")
        CursorCorner.CornerRadius = UDim.new(1, 0)
        CursorCorner.Parent = PickerCursor

        -- Hue bar (vertical rainbow)
        local HueBar = Instance.new("ImageButton")
        HueBar.Parent = PalettePanel
        HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HueBar.BorderSizePixel = 0
        HueBar.Position = UDim2.new(0, 200, 0, 10)
        HueBar.Size = UDim2.new(0, 20, 0, 180)
        HueBar.AutoButtonColor = false
        HueBar.ZIndex = 31

        local HueCorner = Instance.new("UICorner")
        HueCorner.CornerRadius = UDim.new(0, 4)
        HueCorner.Parent = HueBar

        local HueGradient = Instance.new("UIGradient")
        HueGradient.Parent = HueBar
        HueGradient.Rotation = 90
        HueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        })

        -- Hue cursor
        local HueCursor = Instance.new("Frame")
        HueCursor.Parent = HueBar
        HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HueCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
        HueCursor.BorderSizePixel = 2
        HueCursor.Position = UDim2.new(0.5, -8, currentHue, -3)
        HueCursor.Size = UDim2.new(1, 6, 0, 6)
        HueCursor.ZIndex = 32

        local HueCursorCorner = Instance.new("UICorner")
        HueCursorCorner.CornerRadius = UDim.new(0, 2)
        HueCursorCorner.Parent = HueCursor

        -- Current color preview
        local CurrentColorBox = Instance.new("Frame")
        CurrentColorBox.Parent = PalettePanel
        CurrentColorBox.BackgroundColor3 = currentColor
        CurrentColorBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
        CurrentColorBox.BorderSizePixel = 1
        CurrentColorBox.Position = UDim2.new(0, 10, 0, 200)
        CurrentColorBox.Size = UDim2.new(0, 50, 0, 25)
        CurrentColorBox.ZIndex = 31

        local CurrentCorner = Instance.new("UICorner")
        CurrentCorner.CornerRadius = UDim.new(0, 3)
        CurrentCorner.Parent = CurrentColorBox

        -- Hex label
        local HexLabel = Instance.new("TextLabel")
        HexLabel.Parent = PalettePanel
        HexLabel.BackgroundTransparency = 1
        HexLabel.Position = UDim2.new(0, 70, 0, 200)
        HexLabel.Size = UDim2.new(0, 150, 0, 25)
        HexLabel.Font = Enum.Font.Gotham
        HexLabel.Text = "#ffffff"
        HexLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        HexLabel.TextSize = 12
        HexLabel.TextXAlignment = Enum.TextXAlignment.Left
        HexLabel.ZIndex = 31

        -- Update color function
        local function updateColor()
            currentColor = Color3.fromHSV(currentHue, currentSat, currentVal)
            ColorPreview.BackgroundColor3 = currentColor
            CurrentColorBox.BackgroundColor3 = currentColor
            GradientSquare.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)

            local r = math.floor(currentColor.R * 255)
            local g = math.floor(currentColor.G * 255)
            local b = math.floor(currentColor.B * 255)
            HexLabel.Text = string.format("#%02x%02x%02x", r, g, b)
        end

        -- Gradient square interaction
        local draggingSquare = false

        local function updateSquare(input)
            local pos = GradientSquare.AbsolutePosition
            local size = GradientSquare.AbsoluteSize
            local mouse = input.Position

            currentSat = math.clamp((mouse.X - pos.X) / size.X, 0, 1)
            currentVal = 1 - math.clamp((mouse.Y - pos.Y) / size.Y, 0, 1)

            PickerCursor.Position = UDim2.new(currentSat, -5, 1 - currentVal, -5)
            updateColor()
        end

        GradientSquare.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSquare = true
                updateSquare(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingSquare and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSquare(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSquare = false
            end
        end)

        -- Hue bar interaction
        local draggingHue = false

        local function updateHue(input)
            local pos = HueBar.AbsolutePosition
            local size = HueBar.AbsoluteSize
            local mouse = input.Position

            currentHue = math.clamp((mouse.Y - pos.Y) / size.Y, 0, 1)
            HueCursor.Position = UDim2.new(0.5, -8, currentHue, -3)
            updateColor()
        end

        HueBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingHue = true
                updateHue(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateHue(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingHue = false
            end
        end)

        -- Toggle palette
        ColorPreview.MouseButton1Click:Connect(function()
            pickerOpen = not pickerOpen
            PalettePanel.Visible = pickerOpen

            if pickerOpen then
                local previewPos = ColorPreview.AbsolutePosition
                PalettePanel.Position = UDim2.new(0, previewPos.X - 230, 0, previewPos.Y - 10)
                TweenService:Create(PalettePanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 230, 0, 235)}):Play()
            else
                TweenService:Create(PalettePanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 230, 0, 0)}):Play()
                task.wait(0.2)
                PalettePanel.Visible = false
            end
        end)

        -- Update palette position when menu moves
        MainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if pickerOpen and PalettePanel.Visible then
                local previewPos = ColorPreview.AbsolutePosition
                PalettePanel.Position = UDim2.new(0, previewPos.X - 230, 0, previewPos.Y - 10)
            end
        end)

        -- Hover effect
        ColorFrame.MouseEnter:Connect(function()
            TweenService:Create(ColorFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(32, 32, 32)
            }):Play()
        end)

        ColorFrame.MouseLeave:Connect(function()
            TweenService:Create(ColorFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            }):Play()
        end)

        return ColorFrame, currentColor
    end
    local function createToggle(parent, yPos, label, enabled, hasSettings, hasColorPicker, defaultColor)
        local toggleState = enabled

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Parent = parent
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Position = UDim2.new(0, 15, 0, yPos)
        ToggleFrame.Size = UDim2.new(1, -30, 0, 30)
        ToggleFrame.ClipsDescendants = false
        ToggleFrame.ZIndex = 5

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 4)
        ToggleCorner.Parent = ToggleFrame

        local Label = Instance.new("TextLabel")
        Label.Parent = ToggleFrame
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.Size = UDim2.new(0, 200, 1, 0)
        Label.Font = Enum.Font.Gotham
        Label.Text = label
        Label.TextColor3 = toggleState and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 6

        -- Color picker (INLINE - same row as gear icon)
        if hasColorPicker then
            local currentColor = defaultColor or Color3.fromRGB(255, 255, 255)
            local currentHue = 0
            local currentSat = 1
            local currentVal = 1
            local pickerOpen = false

            -- Color preview box (positioned like gear icon)
            local ColorPreview = Instance.new("TextButton")
            ColorPreview.Parent = ToggleFrame
            ColorPreview.BackgroundColor3 = currentColor
            ColorPreview.BorderColor3 = Color3.fromRGB(60, 60, 60)
            ColorPreview.BorderSizePixel = 1
            ColorPreview.Position = UDim2.new(1, -70, 0.5, -10)
            ColorPreview.Size = UDim2.new(0, 20, 0, 20)
            ColorPreview.Text = ""
            ColorPreview.ZIndex = 10

            local PreviewCorner = Instance.new("UICorner")
            PreviewCorner.CornerRadius = UDim.new(0, 3)
            PreviewCorner.Parent = ColorPreview

            -- Palette panel
            local PalettePanel = Instance.new("Frame")
            PalettePanel.Parent = ScreenGui
            PalettePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            PalettePanel.BorderSizePixel = 0
            PalettePanel.Position = UDim2.new(0, 0, 0, 0)
            PalettePanel.Size = UDim2.new(0, 0, 0, 0)
            PalettePanel.Visible = false
            PalettePanel.ClipsDescendants = true
            PalettePanel.ZIndex = 30

            local PaletteCorner = Instance.new("UICorner")
            PaletteCorner.CornerRadius = UDim.new(0, 6)
            PaletteCorner.Parent = PalettePanel

            -- Gradient Square
            local GradientSquare = Instance.new("ImageButton")
            GradientSquare.Parent = PalettePanel
            GradientSquare.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
            GradientSquare.BorderSizePixel = 0
            GradientSquare.Position = UDim2.new(0, 10, 0, 10)
            GradientSquare.Size = UDim2.new(0, 180, 0, 180)
            GradientSquare.AutoButtonColor = false
            GradientSquare.ZIndex = 31

            local SquareCorner = Instance.new("UICorner")
            SquareCorner.CornerRadius = UDim.new(0, 4)
            SquareCorner.Parent = GradientSquare

            local SatGradient = Instance.new("Frame")
            SatGradient.Parent = GradientSquare
            SatGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SatGradient.BackgroundTransparency = 0
            SatGradient.BorderSizePixel = 0
            SatGradient.Size = UDim2.new(1, 0, 1, 0)
            SatGradient.ZIndex = 32

            local SatGradientUI = Instance.new("UIGradient")
            SatGradientUI.Parent = SatGradient
            SatGradientUI.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
            SatGradientUI.Rotation = 0

            local SatCorner = Instance.new("UICorner")
            SatCorner.CornerRadius = UDim.new(0, 4)
            SatCorner.Parent = SatGradient

            local ValGradient = Instance.new("Frame")
            ValGradient.Parent = GradientSquare
            ValGradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            ValGradient.BackgroundTransparency = 0
            ValGradient.BorderSizePixel = 0
            ValGradient.Size = UDim2.new(1, 0, 1, 0)
            ValGradient.ZIndex = 33

            local ValGradientUI = Instance.new("UIGradient")
            ValGradientUI.Parent = ValGradient
            ValGradientUI.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
            ValGradientUI.Rotation = 90

            local ValCorner = Instance.new("UICorner")
            ValCorner.CornerRadius = UDim.new(0, 4)
            ValCorner.Parent = ValGradient

            local PickerCursor = Instance.new("Frame")
            PickerCursor.Parent = GradientSquare
            PickerCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            PickerCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            PickerCursor.BorderSizePixel = 2
            PickerCursor.Position = UDim2.new(currentSat, -5, 1 - currentVal, -5)
            PickerCursor.Size = UDim2.new(0, 10, 0, 10)
            PickerCursor.ZIndex = 34

            local CursorCorner = Instance.new("UICorner")
            CursorCorner.CornerRadius = UDim.new(1, 0)
            CursorCorner.Parent = PickerCursor

            -- Hue bar
            local HueBar = Instance.new("ImageButton")
            HueBar.Parent = PalettePanel
            HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueBar.BorderSizePixel = 0
            HueBar.Position = UDim2.new(0, 200, 0, 10)
            HueBar.Size = UDim2.new(0, 20, 0, 180)
            HueBar.AutoButtonColor = false
            HueBar.ZIndex = 31

            local HueCorner = Instance.new("UICorner")
            HueCorner.CornerRadius = UDim.new(0, 4)
            HueCorner.Parent = HueBar

            local HueGradient = Instance.new("UIGradient")
            HueGradient.Parent = HueBar
            HueGradient.Rotation = 90
            HueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })

            local HueCursor = Instance.new("Frame")
            HueCursor.Parent = HueBar
            HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            HueCursor.BorderSizePixel = 2
            HueCursor.Position = UDim2.new(0.5, -8, currentHue, -3)
            HueCursor.Size = UDim2.new(1, 6, 0, 6)
            HueCursor.ZIndex = 32

            local HueCursorCorner = Instance.new("UICorner")
            HueCursorCorner.CornerRadius = UDim.new(0, 2)
            HueCursorCorner.Parent = HueCursor

            local CurrentColorBox = Instance.new("Frame")
            CurrentColorBox.Parent = PalettePanel
            CurrentColorBox.BackgroundColor3 = currentColor
            CurrentColorBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
            CurrentColorBox.BorderSizePixel = 1
            CurrentColorBox.Position = UDim2.new(0, 10, 0, 200)
            CurrentColorBox.Size = UDim2.new(0, 50, 0, 25)
            CurrentColorBox.ZIndex = 31

            local CurrentCorner = Instance.new("UICorner")
            CurrentCorner.CornerRadius = UDim.new(0, 3)
            CurrentCorner.Parent = CurrentColorBox

            local HexLabel = Instance.new("TextLabel")
            HexLabel.Parent = PalettePanel
            HexLabel.BackgroundTransparency = 1
            HexLabel.Position = UDim2.new(0, 70, 0, 200)
            HexLabel.Size = UDim2.new(0, 150, 0, 25)
            HexLabel.Font = Enum.Font.Gotham
            HexLabel.Text = "#ffffff"
            HexLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            HexLabel.TextSize = 12
            HexLabel.TextXAlignment = Enum.TextXAlignment.Left
            HexLabel.ZIndex = 31

            local function updateColor()
                currentColor = Color3.fromHSV(currentHue, currentSat, currentVal)
                ColorPreview.BackgroundColor3 = currentColor
                CurrentColorBox.BackgroundColor3 = currentColor
                GradientSquare.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)

                local r = math.floor(currentColor.R * 255)
                local g = math.floor(currentColor.G * 255)
                local b = math.floor(currentColor.B * 255)
                HexLabel.Text = string.format("#%02x%02x%02x", r, g, b)
            end

            local draggingSquare = false
            local function updateSquare(input)
                local pos = GradientSquare.AbsolutePosition
                local size = GradientSquare.AbsoluteSize
                local mouse = input.Position

                currentSat = math.clamp((mouse.X - pos.X) / size.X, 0, 1)
                currentVal = 1 - math.clamp((mouse.Y - pos.Y) / size.Y, 0, 1)

                PickerCursor.Position = UDim2.new(currentSat, -5, 1 - currentVal, -5)
                updateColor()
            end

            GradientSquare.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSquare = true
                    updateSquare(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSquare and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSquare(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSquare = false
                end
            end)

            local draggingHue = false
            local function updateHue(input)
                local pos = HueBar.AbsolutePosition
                local size = HueBar.AbsoluteSize
                local mouse = input.Position

                currentHue = math.clamp((mouse.Y - pos.Y) / size.Y, 0, 1)
                HueCursor.Position = UDim2.new(0.5, -8, currentHue, -3)
                updateColor()
            end

            HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = true
                    updateHue(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateHue(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = false
                end
            end)

            -- Toggle palette
            ColorPreview.MouseButton1Click:Connect(function()
                pickerOpen = not pickerOpen
                PalettePanel.Visible = pickerOpen

                if pickerOpen then
                    local previewPos = ColorPreview.AbsolutePosition
                    PalettePanel.Position = UDim2.new(0, previewPos.X - 230, 0, previewPos.Y - 10)
                    TweenService:Create(PalettePanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 230, 0, 235)}):Play()
                else
                    TweenService:Create(PalettePanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 230, 0, 0)}):Play()
                    task.wait(0.2)
                    PalettePanel.Visible = false
                end
            end)

            MainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                if pickerOpen and PalettePanel.Visible then
                    local previewPos = ColorPreview.AbsolutePosition
                    PalettePanel.Position = UDim2.new(0, previewPos.X - 230, 0, previewPos.Y - 10)
                end
            end)

            ColorPreview.MouseEnter:Connect(function()
                if not pickerOpen then
                    ColorPreview.BorderColor3 = Color3.fromRGB(100, 100, 100)
                end
            end)

            ColorPreview.MouseLeave:Connect(function()
                if not pickerOpen then
                    ColorPreview.BorderColor3 = Color3.fromRGB(60, 60, 60)
                end
            end)
        end

        -- Settings icon
        if hasSettings then
            local SettingsButton = Instance.new("TextButton")
            SettingsButton.Parent = ToggleFrame
            SettingsButton.BackgroundTransparency = 1
            SettingsButton.Position = UDim2.new(1, -70, 0, 0)
            SettingsButton.Size = UDim2.new(0, 28, 1, 0)
            SettingsButton.Font = Enum.Font.Gotham
            SettingsButton.Text = "⚙"
            SettingsButton.TextColor3 = Color3.fromRGB(130, 130, 130)
            SettingsButton.TextSize = 14
            SettingsButton.ZIndex = 10

            local settingsOpen = false

            -- Settings panel
            local SettingsPanel = Instance.new("Frame")
            SettingsPanel.Parent = ScreenGui
            SettingsPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SettingsPanel.BorderSizePixel = 0
            SettingsPanel.Position = UDim2.new(0, 0, 0, 0)
            SettingsPanel.Size = UDim2.new(0, 0, 0, 0)
            SettingsPanel.Visible = false
            SettingsPanel.ClipsDescendants = true
            SettingsPanel.ZIndex = 25

            local PanelCorner = Instance.new("UICorner")
            PanelCorner.CornerRadius = UDim.new(0, 6)
            PanelCorner.Parent = SettingsPanel

            -- Shadow effect
            local Shadow = Instance.new("ImageLabel")
            Shadow.Parent = SettingsPanel
            Shadow.BackgroundTransparency = 1
            Shadow.Position = UDim2.new(0, -15, 0, -15)
            Shadow.Size = UDim2.new(1, 30, 1, 30)
            Shadow.ZIndex = 24
            Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            Shadow.ImageTransparency = 0.7

            -- Panel title
            local PanelTitle = Instance.new("TextLabel")
            PanelTitle.Parent = SettingsPanel
            PanelTitle.BackgroundTransparency = 1
            PanelTitle.Position = UDim2.new(0, 10, 0, 8)
            PanelTitle.Size = UDim2.new(1, -20, 0, 20)
            PanelTitle.Font = Enum.Font.GothamBold
            PanelTitle.Text = label .. " Settings"
            PanelTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
            PanelTitle.TextSize = 12
            PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
            PanelTitle.ZIndex = 21

            -- Placeholder content
            local PlaceholderText = Instance.new("TextLabel")
            PlaceholderText.Parent = SettingsPanel
            PlaceholderText.BackgroundTransparency = 1
            PlaceholderText.Position = UDim2.new(0, 10, 0, 35)
            PlaceholderText.Size = UDim2.new(1, -20, 0, 80)
            PlaceholderText.Font = Enum.Font.Gotham
            PlaceholderText.Text = "Settings options will\nbe configured later"
            PlaceholderText.TextColor3 = Color3.fromRGB(150, 150, 150)
            PlaceholderText.TextSize = 11
            PlaceholderText.TextWrapped = true
            PlaceholderText.ZIndex = 21

            SettingsButton.MouseButton1Click:Connect(function()
                settingsOpen = not settingsOpen
                SettingsPanel.Visible = settingsOpen

                if settingsOpen then
                    -- Position panel next to the toggle frame
                    local framePos = ToggleFrame.AbsolutePosition
                    local frameSize = ToggleFrame.AbsoluteSize
                    SettingsPanel.Position = UDim2.new(0, framePos.X + frameSize.X + 10, 0, framePos.Y - 10)

                    TweenService:Create(SettingsPanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 250, 0, 120)}):Play()
                    SettingsButton.TextColor3 = Color3.fromRGB(60, 160, 255)
                else
                    TweenService:Create(SettingsPanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                    SettingsButton.TextColor3 = Color3.fromRGB(130, 130, 130)
                    task.wait(0.2)
                    SettingsPanel.Visible = false
                end
                print(label .. " settings: " .. tostring(settingsOpen))
            end)

            -- Update panel position when menu moves
            MainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                if settingsOpen and SettingsPanel.Visible then
                    local framePos = ToggleFrame.AbsolutePosition
                    local frameSize = ToggleFrame.AbsoluteSize
                    SettingsPanel.Position = UDim2.new(0, framePos.X + frameSize.X + 10, 0, framePos.Y - 10)
                end
            end)

            SettingsButton.MouseEnter:Connect(function()
                if not settingsOpen then
                    SettingsButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end)

            SettingsButton.MouseLeave:Connect(function()
                if not settingsOpen then
                    SettingsButton.TextColor3 = Color3.fromRGB(130, 130, 130)
                end
            end)
        end

        -- Toggle button background
        local ToggleBg = Instance.new("Frame")
        ToggleBg.Parent = ToggleFrame
        ToggleBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ToggleBg.BorderSizePixel = 0
        ToggleBg.Position = UDim2.new(1, -38, 0.5, -10)
        ToggleBg.Size = UDim2.new(0, 32, 0, 20)
        ToggleBg.ZIndex = 6

        local BgCorner = Instance.new("UICorner")
        BgCorner.CornerRadius = UDim.new(1, 0)
        BgCorner.Parent = ToggleBg

        local ToggleButton = Instance.new("Frame")
        ToggleButton.Parent = ToggleBg
        ToggleButton.BackgroundColor3 = toggleState and Color3.fromRGB(60, 160, 255) or Color3.fromRGB(60, 60, 60)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Position = toggleState and UDim2.new(0, 14, 0, 2) or UDim2.new(0, 2, 0, 2)
        ToggleButton.Size = UDim2.new(0, 16, 0, 16)
        ToggleButton.ZIndex = 7

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(1, 0)
        ButtonCorner.Parent = ToggleButton

        -- Click functionality (FULL SIZE - gear and color picker will be on top with ZIndex 10)
        local ClickButton = Instance.new("TextButton")
        ClickButton.Parent = ToggleFrame
        ClickButton.BackgroundTransparency = 1
        ClickButton.Position = UDim2.new(0, 0, 0, 0)
        ClickButton.Size = UDim2.new(1, 0, 1, 0)  -- FULL SIZE!
        ClickButton.Text = ""
        ClickButton.ZIndex = 8

        ClickButton.MouseButton1Click:Connect(function()
            toggleState = not toggleState

            -- Animate toggle
            TweenService:Create(ToggleButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Position = toggleState and UDim2.new(0, 14, 0, 2) or UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = toggleState and Color3.fromRGB(60, 160, 255) or Color3.fromRGB(60, 60, 60)
            }):Play()

            TweenService:Create(Label, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                TextColor3 = toggleState and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(200, 200, 200)
            }):Play()

            print(label .. ": " .. tostring(toggleState))
        end)

        -- Hover effect
        ClickButton.MouseEnter:Connect(function()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(32, 32, 32)
            }):Play()
        end)

        ClickButton.MouseLeave:Connect(function()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            }):Play()
        end)

        return ToggleFrame, toggleState
    end

    -- Helper function to create slider with working functionality
    local function createSlider(parent, yPos, label, defaultValue, minValue, maxValue, hasOverride)
        local sliderValue = defaultValue
        local dragging = false

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Parent = parent
        SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Position = UDim2.new(0, 15, 0, yPos)
        SliderFrame.Size = UDim2.new(1, -30, 0, 30)

        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 4)
        SliderCorner.Parent = SliderFrame

        local Label = Instance.new("TextLabel")
        Label.Parent = SliderFrame
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.Size = UDim2.new(0, 150, 1, 0)
        Label.Font = Enum.Font.Gotham
        Label.Text = label
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left

        if hasOverride then
            local OverrideLabel = Instance.new("TextLabel")
            OverrideLabel.Parent = SliderFrame
            OverrideLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            OverrideLabel.BorderSizePixel = 0
            OverrideLabel.Position = UDim2.new(0, 165, 0.5, -8)
            OverrideLabel.Size = UDim2.new(0, 22, 0, 16)
            OverrideLabel.Font = Enum.Font.GothamBold
            OverrideLabel.Text = "HB"
            OverrideLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
            OverrideLabel.TextSize = 8

            local OverrideCorner = Instance.new("UICorner")
            OverrideCorner.CornerRadius = UDim.new(0, 2)
            OverrideCorner.Parent = OverrideLabel
        end

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Parent = SliderFrame
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -45, 0, 0)
        ValueLabel.Size = UDim2.new(0, 38, 1, 0)
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.Text = tostring(sliderValue)
        ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ValueLabel.TextSize = 13
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local SliderTrack = Instance.new("Frame")
        SliderTrack.Parent = SliderFrame
        SliderTrack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        SliderTrack.BorderSizePixel = 0
        SliderTrack.Position = UDim2.new(0, hasOverride and 195 or 170, 0.5, -2)
        SliderTrack.Size = UDim2.new(0, hasOverride and 80 or 105, 0, 4)

        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(1, 0)
        TrackCorner.Parent = SliderTrack

        local SliderFill = Instance.new("Frame")
        SliderFill.Parent = SliderTrack
        SliderFill.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
        SliderFill.BorderSizePixel = 0
        SliderFill.Size = UDim2.new((sliderValue - minValue) / (maxValue - minValue), 0, 1, 0)

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = SliderFill

        local SliderThumb = Instance.new("Frame")
        SliderThumb.Parent = SliderTrack
        SliderThumb.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
        SliderThumb.BorderSizePixel = 0
        SliderThumb.Position = UDim2.new((sliderValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
        SliderThumb.Size = UDim2.new(0, 16, 0, 16)
        SliderThumb.ZIndex = 2

        local ThumbCorner = Instance.new("UICorner")
        ThumbCorner.CornerRadius = UDim.new(1, 0)
        ThumbCorner.Parent = SliderThumb

        -- Slider interaction
        local function updateSlider(input)
            local trackPos = SliderTrack.AbsolutePosition.X
            local trackSize = SliderTrack.AbsoluteSize.X
            local mousePos = input.Position.X

            local delta = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
            sliderValue = math.floor(minValue + (maxValue - minValue) * delta)

            ValueLabel.Text = tostring(sliderValue)
            SliderFill.Size = UDim2.new(delta, 0, 1, 0)
            SliderThumb.Position = UDim2.new(delta, -8, 0.5, -8)

            print(label .. ": " .. sliderValue)
        end

        SliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        SliderThumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        -- Hover effect
        SliderFrame.MouseEnter:Connect(function()
            TweenService:Create(SliderFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(32, 32, 32)
            }):Play()
        end)

        SliderFrame.MouseLeave:Connect(function()
            TweenService:Create(SliderFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            }):Play()
        end)

        return SliderFrame, sliderValue
    end

    -- NEW Simple dropdown function
    local function createDropdown(parent, yPos, label, defaultValue, options)
        local selectedValue = defaultValue
        local isOpen = false

        -- Main container
        local Container = Instance.new("Frame")
        Container.Parent = parent
        Container.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Container.BorderSizePixel = 0
        Container.Position = UDim2.new(0, 15, 0, yPos)
        Container.Size = UDim2.new(1, -30, 0, 30)
        Container.ClipsDescendants = false
        Container.ZIndex = 5

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = Container

        -- Label
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Parent = Container
        NameLabel.BackgroundTransparency = 1
        NameLabel.Position = UDim2.new(0, 12, 0, 0)
        NameLabel.Size = UDim2.new(0, 100, 1, 0)
        NameLabel.Font = Enum.Font.Gotham
        NameLabel.Text = label
        NameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        NameLabel.TextSize = 13
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.ZIndex = 6

        -- Value display button
        local ValueButton = Instance.new("TextButton")
        ValueButton.Parent = Container
        ValueButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        ValueButton.BorderSizePixel = 0
        ValueButton.Position = UDim2.new(0, 120, 0, 3)
        ValueButton.Size = UDim2.new(0, 180, 0, 24)
        ValueButton.Font = Enum.Font.Gotham
        ValueButton.Text = "  " .. selectedValue
        ValueButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        ValueButton.TextSize = 12
        ValueButton.TextXAlignment = Enum.TextXAlignment.Left
        ValueButton.AutoButtonColor = false
        ValueButton.ZIndex = 10

        local ValueCorner = Instance.new("UICorner")
        ValueCorner.CornerRadius = UDim.new(0, 4)
        ValueCorner.Parent = ValueButton

        -- Arrow
        local ArrowLabel = Instance.new("TextLabel")
        ArrowLabel.Parent = ValueButton
        ArrowLabel.BackgroundTransparency = 1
        ArrowLabel.Position = UDim2.new(1, -20, 0, 0)
        ArrowLabel.Size = UDim2.new(0, 20, 1, 0)
        ArrowLabel.Font = Enum.Font.Gotham
        ArrowLabel.Text = "▼"
        ArrowLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        ArrowLabel.TextSize = 10
        ArrowLabel.ZIndex = 11

        -- Options container - use ScreenGui parent to go outside bounds
        local OptionsFrame = Instance.new("ScrollingFrame")
        OptionsFrame.Parent = ScreenGui  -- PARENT = ScreenGui to escape clipping!
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.Position = UDim2.new(0, 0, 0, 0)
        OptionsFrame.Size = UDim2.new(0, 0, 0, 0)
        OptionsFrame.Visible = false
        OptionsFrame.ScrollBarThickness = 4
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 26)
        OptionsFrame.ZIndex = 100

        local OptionsCorner = Instance.new("UICorner")
        OptionsCorner.CornerRadius = UDim.new(0, 4)
        OptionsCorner.Parent = OptionsFrame

        local OptionsList = Instance.new("UIListLayout")
        OptionsList.Parent = OptionsFrame
        OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsList.Padding = UDim.new(0, 2)

        -- Create options
        for i, optionText in ipairs(options) do
            local OptionBtn = Instance.new("TextButton")
            OptionBtn.Parent = OptionsFrame
            OptionBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            OptionBtn.BorderSizePixel = 0
            OptionBtn.Size = UDim2.new(1, -4, 0, 24)
            OptionBtn.Font = Enum.Font.Gotham
            OptionBtn.Text = "  " .. optionText
            OptionBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            OptionBtn.TextSize = 12
            OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
            OptionBtn.AutoButtonColor = false
            OptionBtn.ZIndex = 101

            OptionBtn.MouseButton1Click:Connect(function()
                selectedValue = optionText
                ValueButton.Text = "  " .. selectedValue
                isOpen = false
                OptionsFrame.Visible = false
                OptionsFrame.Size = UDim2.new(0, 0, 0, 0)
                ArrowLabel.Rotation = 0
                print(label .. ": " .. selectedValue)
            end)

            OptionBtn.MouseEnter:Connect(function()
                OptionBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end)

            OptionBtn.MouseLeave:Connect(function()
                OptionBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            end)
        end

        -- Toggle dropdown
        ValueButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            OptionsFrame.Visible = isOpen

            if isOpen then
                -- Position below button using AbsolutePosition
                local btnPos = ValueButton.AbsolutePosition
                local btnSize = ValueButton.AbsoluteSize
                local maxHeight = math.min(#options * 26, 150)

                OptionsFrame.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + btnSize.Y + 2)
                OptionsFrame.Size = UDim2.new(0, btnSize.X, 0, maxHeight)
                ArrowLabel.Rotation = 180
            else
                OptionsFrame.Size = UDim2.new(0, 0, 0, 0)
                ArrowLabel.Rotation = 0
            end
        end)

        -- Update position when menu moves
        MainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if isOpen and OptionsFrame.Visible then
                local btnPos = ValueButton.AbsolutePosition
                local btnSize = ValueButton.AbsoluteSize
                OptionsFrame.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + btnSize.Y + 2)
            end
        end)

        -- Hover
        ValueButton.MouseEnter:Connect(function()
            if not isOpen then
                ValueButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            end
        end)

        ValueButton.MouseLeave:Connect(function()
            if not isOpen then
                ValueButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
            end
        end)

        return Container
    end

    -- Create GLOBALS controls
    createToggle(GlobalsSection, 40, "Master switch", true, false, false)
    createToggle(GlobalsSection, 75, "Bunnyhop", false, false, false)
    createToggle(GlobalsSection, 110, "Auto strafer", false, true, false)
    createToggle(GlobalsSection, 145, "Accurate walk", false, false, true, Color3.fromRGB(255, 255, 255))
    createToggle(GlobalsSection, 180, "Quick stop", false, true, false)
    createToggle(GlobalsSection, 215, "Stop color 1", false, false, true, Color3.fromRGB(60, 160, 255))
    createToggle(GlobalsSection, 250, "Stop color 2", false, false, true, Color3.fromRGB(255, 100, 100))
    createToggle(GlobalsSection, 285, "Aimbot", false, true, false)
    createSlider(GlobalsSection, 320, "FOV", 180, 1, 180, false)
    createToggle(GlobalsSection, 355, "Use psilent", false, false, false)
    createToggle(GlobalsSection, 390, "Antiaim", true, false, false)
    createDropdown(GlobalsSection, 425, "Config", "Rifle", {"Scout", "AWP", "Auto-Snipers", "Deagle", "R8", "Heavy-Pistol", "Pistol", "Rifle"})

    -- Create AIMBOT controls
    createDropdown(AimbotSection, 40, "Hitscan", "None", {"None", "Head", "Chest", "Body", "Arms", "Legs", "Auto"})
    createSlider(AimbotSection, 75, "Head point scale", 100, 0, 100, false)
    createSlider(AimbotSection, 110, "Body point scale", 100, 0, 100, false)
    createSlider(AimbotSection, 145, "Min damage", 100, 0, 100, false)
    createSlider(AimbotSection, 180, "Min damage override", 100, 0, 100, true)
    createSlider(AimbotSection, 215, "Hit chance", 100, 0, 100, false)
    createToggle(AimbotSection, 250, "Force shoot", false, false)
    createToggle(AimbotSection, 285, "Auto scope", false, false)
    createToggle(AimbotSection, 320, "Auto stop", false, false)
    createToggle(AimbotSection, 355, "Auto stop between shots", false, false)
    createToggle(AimbotSection, 390, "Prefer body aim", false, false)
    createToggle(AimbotSection, 425, "Prefer safe point", false, false)


    -- Link tab content
    tabs[2].content = TabContainer

    -- Create Visuals Tab (Tab 3) - Now that functions are defined!
    local VisualsContainer = Instance.new("Frame")
    VisualsContainer.Name = "VisualsContainer"
    VisualsContainer.Parent = ContentFrame
    VisualsContainer.BackgroundTransparency = 1
    VisualsContainer.Size = UDim2.new(1, 0, 1, 0)
    VisualsContainer.Visible = false

    local VisualsLeft = Instance.new("Frame")
    VisualsLeft.Name = "VisualsLeft"
    VisualsLeft.Parent = VisualsContainer
    VisualsLeft.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    VisualsLeft.BorderSizePixel = 0
    VisualsLeft.Position = UDim2.new(0, 20, 0, 20)
    VisualsLeft.Size = UDim2.new(0, 455, 0, 540)
    VisualsLeft.ClipsDescendants = true

    local VisualsLeftCorner = Instance.new("UICorner")
    VisualsLeftCorner.CornerRadius = UDim.new(0, 6)
    VisualsLeftCorner.Parent = VisualsLeft

    local VisualsLeftTitle = Instance.new("TextLabel")
    VisualsLeftTitle.Parent = VisualsLeft
    VisualsLeftTitle.BackgroundTransparency = 1
    VisualsLeftTitle.Position = UDim2.new(0, 15, 0, 10)
    VisualsLeftTitle.Size = UDim2.new(1, -30, 0, 30)
    VisualsLeftTitle.Font = Enum.Font.GothamBold
    VisualsLeftTitle.Text = "ESP / CHAMS"
    VisualsLeftTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    VisualsLeftTitle.TextSize = 12
    VisualsLeftTitle.TextXAlignment = Enum.TextXAlignment.Left

    local VisualsRight = Instance.new("Frame")
    VisualsRight.Name = "VisualsRight"
    VisualsRight.Parent = VisualsContainer
    VisualsRight.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    VisualsRight.BorderSizePixel = 0
    VisualsRight.Position = UDim2.new(0, 490, 0, 20)
    VisualsRight.Size = UDim2.new(0, 455, 0, 540)
    VisualsRight.ClipsDescendants = true

    local VisualsRightCorner = Instance.new("UICorner")
    VisualsRightCorner.CornerRadius = UDim.new(0, 6)
    VisualsRightCorner.Parent = VisualsRight

    local VisualsRightTitle = Instance.new("TextLabel")
    VisualsRightTitle.Parent = VisualsRight
    VisualsRightTitle.BackgroundTransparency = 1
    VisualsRightTitle.Position = UDim2.new(0, 15, 0, 10)
    VisualsRightTitle.Size = UDim2.new(1, -30, 0, 30)
    VisualsRightTitle.Font = Enum.Font.GothamBold
    VisualsRightTitle.Text = "WORLD"
    VisualsRightTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    VisualsRightTitle.TextSize = 12
    VisualsRightTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Visuals tab is empty for now
    -- Add controls here later

    tabs[3].content = VisualsContainer


    -- Dragging functionality (ONLY for header!)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Toggle menu with the configured key (INSERT by default).
    local menuVisible = false
    local toggleKey = (Settings and Settings.Keybind) or Enum.KeyCode.Insert

    local WindowObj = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Tabs = tabs,
        Visible = false,
    }

    function WindowObj:SetVisible(state)
        self.Visible = state == true
        MainFrame.Visible = self.Visible
        return self.Visible
    end

    function WindowObj:ToggleVisibility()
        return self:SetVisible(not self.Visible)
    end

    function WindowObj:GetVisible()
        return self.Visible
    end

    function WindowObj:Destroy()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
        self.Visible = false
    end


    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == toggleKey then
            menuVisible = not menuVisible
            WindowObj.Visible = menuVisible
            MainFrame.Visible = menuVisible

            if WindowObj.OnVisibilityChanged then
                WindowObj.OnVisibilityChanged(menuVisible)
            end
        end
    end)


    return WindowObj
end

Ragebot.new = buildWindow
Ragebot.CreateWindow = buildWindow
Ragebot.Window = buildWindow

return Ragebot
