local Daino = {}
Daino.__index = Daino

local THEME = {
    Background = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(153, 27, 69),
    AccentBright = Color3.fromRGB(181, 32, 81),
    AccentText = Color3.fromRGB(186, 32, 84),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(132, 132, 132),
}

local function safeCallback(callback, ...)
    if type(callback) ~= "function" then
        return
    end
    pcall(callback, ...)
end

local function clamp(value, minimum, maximum)
    if value < minimum then
        return minimum
    end
    if value > maximum then
        return maximum
    end
    return value
end

local function rounded(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 5)
    corner.Parent = instance
    return corner
end

local function styleText(instance, font, size, color, alignment)
    instance.Font = font or Enum.Font.SourceSansBold
    instance.TextSize = size or 15
    instance.TextColor3 = color or THEME.Text
    if alignment then
        instance.TextXAlignment = alignment
    end
end

local function isPointerInput(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function makeDraggable(frame)
    local userInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput
    local dragStart
    local startPosition

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if not isPointerInput(input) then
            return
        end
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    userInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

local function getGuiParent()
    local ok, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and coreGui then
        return coreGui
    end
    local players = game:GetService("Players")
    return players.LocalPlayer:WaitForChild("PlayerGui")
end

local function createTextButton(parent, text, size, color)
    local button = Instance.new("TextButton")
    button.BackgroundColor3 = color or THEME.Accent
    button.BorderSizePixel = 0
    button.Size = size
    button.Text = tostring(text or "")
    button.AutoButtonColor = true
    styleText(button, Enum.Font.SourceSansBold, 15, THEME.Text)
    rounded(button, 5)
    button.Parent = parent
    return button
end

function Daino:new(title, description)
    local window = setmetatable({}, Daino)
    title = tostring(title or "Daino")
    description = tostring(description or "")

    local parent = getGuiParent()
    local old = parent:FindFirstChild("Whiteui")
    if old then
        old:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Whiteui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = parent

    local background = Instance.new("Frame")
    background.Name = "Background"
    background.BackgroundColor3 = THEME.Background
    background.BorderSizePixel = 0
    background.Position = UDim2.new(0, 676, 0, 266)
    background.Size = UDim2.new(0, 567, 0, 310)
    background.Parent = screenGui
    rounded(background, 6)
    makeDraggable(background)

    local tabList = Instance.new("Frame")
    tabList.Name = "TabList"
    tabList.BackgroundColor3 = THEME.Sidebar
    tabList.BorderSizePixel = 0
    tabList.Size = UDim2.new(0, 128, 0, 310)
    tabList.Parent = background
    rounded(tabList, 6)

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.BackgroundTransparency = 1
    banner.Position = UDim2.new(0, 0, 0, 7)
    banner.Size = UDim2.new(0, 128, 0, 56)
    banner.Parent = tabList

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 39, 0, 0)
    titleLabel.Size = UDim2.new(0, 78, 0, 26)
    titleLabel.Text = title
    titleLabel.Parent = banner
    styleText(titleLabel, Enum.Font.SourceSansBold, 16, THEME.AccentBright, Enum.TextXAlignment.Left)

    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Name = "Description"
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Position = UDim2.new(0, 39, 0, 19)
    descriptionLabel.Size = UDim2.new(0, 78, 0, 24)
    descriptionLabel.Text = description
    descriptionLabel.TextWrapped = true
    descriptionLabel.Parent = banner
    styleText(descriptionLabel, Enum.Font.SourceSansBold, 13, THEME.Muted, Enum.TextXAlignment.Left)

    local logo = Instance.new("ImageButton")
    logo.Name = "Logo"
    logo.BackgroundTransparency = 1
    logo.Position = UDim2.new(0, 8, 0, 9)
    logo.Size = UDim2.new(0, 25, 0, 25)
    logo.Image = "rbxassetid://8324568288"
    logo.ImageRectOffset = Vector2.new(50, 800)
    logo.ImageRectSize = Vector2.new(50, 50)
    logo.Parent = banner

    local tabButtons = Instance.new("ScrollingFrame")
    tabButtons.Name = "Tabs"
    tabButtons.Active = true
    tabButtons.BackgroundTransparency = 1
    tabButtons.BorderSizePixel = 0
    tabButtons.Position = UDim2.new(0, 0, 0, 51)
    tabButtons.Size = UDim2.new(0, 128, 0, 259)
    tabButtons.ScrollBarThickness = 0
    tabButtons.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabButtons.Parent = tabList

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 15)
    tabLayout.Parent = tabButtons

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 7)
    tabPadding.Parent = tabButtons

    local contentFolder = Instance.new("Folder")
    contentFolder.Name = "Content"
    contentFolder.Parent = background

    local tabs = {}
    local activeTab

    local function selectTab(tab)
        for _, item in ipairs(tabs) do
            item.button.TextTransparency = item == tab and 0 or 0.5
            item.page.Visible = item == tab
        end
        activeTab = tab
    end

    function window:Tap(text)
        local tab = {}
        local label = tostring(text or "Tab")

        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton"
        tabButton.BackgroundTransparency = 1
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(0, 128, 0, 18)
        tabButton.Text = label
        tabButton.TextTransparency = 0.5
        tabButton.TextWrapped = true
        tabButton.Parent = tabButtons
        tabButton.AutoButtonColor = false
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        styleText(tabButton, Enum.Font.SourceSansBold, 16, THEME.Text, Enum.TextXAlignment.Left)

        local tabButtonPadding = Instance.new("UIPadding")
        tabButtonPadding.PaddingLeft = UDim.new(0, 15)
        tabButtonPadding.Parent = tabButton

        local page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. tostring(#tabs + 1)
        page.Active = true
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Position = UDim2.new(0.22575, 0, 0, 0)
        page.Size = UDim2.new(0, 439, 0, 310)
        page.ScrollBarThickness = 6
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = contentFolder

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 3)
        pageLayout.Parent = page

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.Parent = page

        tab.button = tabButton
        tab.page = page
        tabs[#tabs + 1] = tab

        tabButton.MouseButton1Click:Connect(function()
            selectTab(tab)
        end)

        if not activeTab then
            selectTab(tab)
        end

        local controls = {}

        function controls:Button(textValue, callback)
            local row = Instance.new("Frame")
            row.Name = "Button"
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Size = UDim2.new(0, 432, 0, 32)
            row.Parent = page

            local button = createTextButton(row, textValue, UDim2.new(0, 251, 0, 25), THEME.Accent)
            button.Position = UDim2.new(0, 81, 0, 6)
            button.BackgroundColor3 = THEME.Background
            button.TextColor3 = THEME.AccentBright
            button.MouseButton1Click:Connect(function()
                safeCallback(callback)
            end)
            return button
        end

        function controls:Label(textValue)
            local row = Instance.new("Frame")
            row.Name = "Label"
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Size = UDim2.new(0, 432, 0, 26)
            row.Parent = page

            local labelControl = Instance.new("TextLabel")
            labelControl.Name = "LabelText"
            labelControl.BackgroundTransparency = 1
            labelControl.Size = UDim2.new(0, 390, 0, 26)
            labelControl.Position = UDim2.new(0, 42, 0, 0)
            labelControl.Text = tostring(textValue or "")
            labelControl.Parent = row
            styleText(labelControl, Enum.Font.SourceSansBold, 15, THEME.Accent, Enum.TextXAlignment.Left)
            return labelControl
        end

        function controls:Toggle(textValue, initialValue, callback)
            local state = initialValue == true
            local row = Instance.new("Frame")
            row.Name = "Toggle"
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Size = UDim2.new(0, 432, 0, 32)
            row.Parent = page

            local box = Instance.new("Frame")
            box.Name = "ToggleFrame"
            box.BackgroundColor3 = THEME.Accent
            box.BorderSizePixel = 0
            box.Position = UDim2.new(0, 46, 0, 2)
            box.Size = UDim2.new(0, 27, 0, 26)
            box.Parent = row
            rounded(box, 6)

            local check = Instance.new("ImageButton")
            check.Name = "Check"
            check.BackgroundColor3 = THEME.Background
            check.BorderSizePixel = 0
            check.Position = UDim2.new(0, 1, 0, 1)
            check.Size = UDim2.new(0, 25, 0, 24)
            check.Image = "rbxassetid://3926305904"
            check.ImageColor3 = Color3.fromRGB(120, 20, 52)
            check.ImageRectOffset = Vector2.new(312, 4)
            check.ImageRectSize = Vector2.new(24, 24)
            check.Parent = box
            rounded(check, 6)

            local labelControl = Instance.new("TextLabel")
            labelControl.Name = "ToggleText"
            labelControl.BackgroundTransparency = 1
            labelControl.Position = UDim2.new(1.333, 0, 0, 0)
            labelControl.Size = UDim2.new(0, 344, 0, 26)
            labelControl.Text = tostring(textValue or "")
            labelControl.Parent = box
            styleText(labelControl, Enum.Font.SourceSansBold, 16, THEME.Accent, Enum.TextXAlignment.Left)

            local function render()
                check.ImageTransparency = state and 0 or 1
            end

            local toggle = {}
            function toggle:Set(value, fireCallback)
                state = value == true
                render()
                if fireCallback ~= false then
                    safeCallback(callback, state)
                end
            end
            function toggle:Get()
                return state
            end

            check.MouseButton1Click:Connect(function()
                toggle:Set(not state, true)
            end)
            render()
            return toggle
        end

        function controls:Line()
            local row = Instance.new("Frame")
            row.Name = "Line"
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Size = UDim2.new(0, 432, 0, 32)
            row.Parent = page

            local line = Instance.new("Frame")
            line.Name = "LineElement"
            line.BackgroundColor3 = THEME.Accent
            line.BorderSizePixel = 0
            line.Position = UDim2.new(0, 16, 0, 12)
            line.Size = UDim2.new(0, 408, 0, 3)
            line.Parent = row
            rounded(line, 2)
            return line
        end

        function controls:Dropdown(textValue, values, callback)
            local titleText = tostring(textValue or "Dropdown")
            local row = Instance.new("Frame")
            row.Name = "Dropdown"
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Size = UDim2.new(0, 432, 0, 32)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.Parent = page

            local header = Instance.new("Frame")
            header.Name = "DropdownFrame"
            header.BackgroundColor3 = THEME.Accent
            header.BorderSizePixel = 0
            header.Position = UDim2.new(0, 31, 0, 5)
            header.Size = UDim2.new(0, 361, 0, 23)
            header.Parent = row
            rounded(header, 6)

            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "DropdownText"
            textLabel.BackgroundTransparency = 1
            textLabel.Position = UDim2.new(0, 24, 0, 0)
            textLabel.Size = UDim2.new(0, 306, 0, 22)
            textLabel.Text = titleText
            textLabel.Parent = header
            styleText(textLabel, Enum.Font.SourceSansBold, 16, THEME.Text, Enum.TextXAlignment.Left)

            local click = Instance.new("ImageButton")
            click.Name = "Click"
            click.BackgroundTransparency = 1
            click.Position = UDim2.new(1, -38, 0, -1)
            click.Size = UDim2.new(0, 25, 0, 25)
            click.Image = "rbxassetid://3926305904"
            click.ImageRectOffset = Vector2.new(564, 284)
            click.ImageRectSize = Vector2.new(36, 36)
            click.Rotation = 90
            click.Parent = header

            local listFrame = Instance.new("Frame")
            listFrame.Name = "DropdownList"
            listFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            listFrame.BackgroundTransparency = 0
            listFrame.BorderSizePixel = 0
            listFrame.Position = UDim2.new(0, 0, 0, 35)
            listFrame.Size = UDim2.new(0, 433, 0, 35)
            listFrame.AutomaticSize = Enum.AutomaticSize.Y
            listFrame.Visible = false
            listFrame.Parent = row
            rounded(listFrame, 3)

            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Padding = UDim.new(0, 4)
            listLayout.Parent = listFrame

            local listPadding = Instance.new("UIPadding")
            listPadding.PaddingBottom = UDim.new(0, 10)
            listPadding.PaddingLeft = UDim.new(0, 40)
            listPadding.PaddingTop = UDim.new(0, 10)
            listPadding.Parent = listFrame

            local open = false
            local selected
            local dropdown = {}

            local function setOpen(value)
                open = value == true
                listFrame.Visible = open
                click.Rotation = open and 360 or 90
            end

            click.MouseButton1Click:Connect(function()
                setOpen(not open)
            end)

            function dropdown:Add(items)
                if type(items) ~= "table" then
                    return
                end
                for _, item in ipairs(items) do
                    local option = createTextButton(
                        listFrame,
                        tostring(item),
                        UDim2.new(0, 343, 0, 24),
                        THEME.AccentText
                    )
                    option.MouseButton1Click:Connect(function()
                        selected = tostring(item)
                        textLabel.Text = titleText .. " : " .. selected
                        setOpen(false)
                        safeCallback(callback, selected)
                    end)
                end
            end
            function dropdown:Set(value, fireCallback)
                selected = tostring(value)
                textLabel.Text = titleText .. " : " .. selected
                if fireCallback ~= false then
                    safeCallback(callback, selected)
                end
            end
            function dropdown:Get()
                return selected
            end

            dropdown:Add(values)
            return dropdown
        end

        function controls:TextBox(placeholder, callback)
            local row = Instance.new("Frame")
            row.Name = "TextBox"
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Size = UDim2.new(0, 432, 0, 32)
            row.Parent = page

            local boxFrame = Instance.new("Frame")
            boxFrame.BackgroundColor3 = THEME.Accent
            boxFrame.BorderSizePixel = 0
            boxFrame.Position = UDim2.new(0, 81, 0, 6)
            boxFrame.Size = UDim2.new(0, 251, 0, 25)
            boxFrame.Parent = row
            rounded(boxFrame, 5)

            local textBox = Instance.new("TextBox")
            textBox.BackgroundColor3 = THEME.Background
            textBox.BorderSizePixel = 0
            textBox.Position = UDim2.new(0, 2, 0, 1)
            textBox.Size = UDim2.new(0, 246, 0, 22)
            textBox.Text = ""
            textBox.PlaceholderText = tostring(placeholder or "")
            textBox.ClearTextOnFocus = false
            textBox.Parent = boxFrame
            styleText(textBox, Enum.Font.SourceSansBold, 14, THEME.Accent, Enum.TextXAlignment.Left)
            rounded(textBox, 5)

            textBox.FocusLost:Connect(function()
                if #textBox.Text > 0 then
                    safeCallback(callback, textBox.Text)
                else
                    textBox.Text = ""
                end
            end)
            return textBox
        end

        function controls:Slider(textValue, minimum, maximum, defaultValue, callback)
            local minValue = tonumber(minimum) or 0
            local maxValue = tonumber(maximum) or 100
            if maxValue < minValue then
                minValue, maxValue = maxValue, minValue
            end
            local initial = tonumber(defaultValue)
            if initial == nil then
                initial = minValue
            end
            initial = clamp(initial, minValue, maxValue)

            local row = Instance.new("Frame")
            row.Name = "Slider"
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Size = UDim2.new(0, 432, 0, 37)
            row.Parent = page

            local caption = Instance.new("TextLabel")
            caption.Name = "TextSlider"
            caption.BackgroundTransparency = 1
            caption.Position = UDim2.new(0, 25, 0, 2)
            caption.Size = UDim2.new(0, 223, 0, 14)
            caption.Text = tostring(textValue or "Slider")
            caption.Parent = row
            styleText(caption, Enum.Font.SourceSansBold, 14, THEME.Accent, Enum.TextXAlignment.Left)

            local valueFrame = Instance.new("Frame")
            valueFrame.BackgroundColor3 = THEME.Accent
            valueFrame.BorderSizePixel = 0
            valueFrame.Position = UDim2.new(0, 28, 0, 22)
            valueFrame.Size = UDim2.new(0, 34, 0, 14)
            valueFrame.Parent = row
            rounded(valueFrame, 2)

            local valueBox = Instance.new("TextBox")
            valueBox.BackgroundColor3 = THEME.Background
            valueBox.BorderSizePixel = 0
            valueBox.Position = UDim2.new(0, 1, 0, 1)
            valueBox.Size = UDim2.new(0, 32, 0, 12)
            valueBox.Text = ""
            valueBox.ClearTextOnFocus = false
            valueBox.Parent = valueFrame
            styleText(valueBox, Enum.Font.SourceSansBold, 12, THEME.Accent, Enum.TextXAlignment.Center)
            rounded(valueBox, 2)

            local reset = Instance.new("ImageButton")
            reset.BackgroundTransparency = 1
            reset.Position = UDim2.new(0, 56, 0, 21)
            reset.Size = UDim2.new(0, 16, 0, 16)
            reset.Image = "rbxassetid://3926305904"
            reset.ImageRectOffset = Vector2.new(244, 684)
            reset.ImageRectSize = Vector2.new(36, 36)
            reset.ImageColor3 = THEME.AccentBright
            reset.Parent = row

            local decrease = Instance.new("ImageButton")
            decrease.BackgroundTransparency = 1
            decrease.Position = UDim2.new(0, 78, 0, 20)
            decrease.Size = UDim2.new(0, 17, 0, 17)
            decrease.Image = "rbxassetid://3926307971"
            decrease.ImageRectOffset = Vector2.new(884, 284)
            decrease.ImageRectSize = Vector2.new(36, 36)
            decrease.ImageColor3 = THEME.Accent
            decrease.Parent = row

            local increase = Instance.new("ImageButton")
            increase.BackgroundTransparency = 1
            increase.Position = UDim2.new(0, 101, 0, 19)
            increase.Size = UDim2.new(0, 19, 0, 19)
            increase.Image = "rbxassetid://3926307971"
            increase.ImageRectOffset = Vector2.new(324, 364)
            increase.ImageRectSize = Vector2.new(36, 36)
            increase.ImageColor3 = THEME.Accent
            increase.Parent = row

            local track = Instance.new("TextButton")
            track.Name = "SliderTrack"
            track.BackgroundTransparency = 1
            track.BorderSizePixel = 0
            track.Position = UDim2.new(0, 130, 0, 25)
            track.Size = UDim2.new(0, 296, 0, 6)
            track.Text = ""
            track.Parent = row

            local fill = Instance.new("Frame")
            fill.Name = "SliderFill"
            fill.BackgroundColor3 = THEME.Accent
            fill.BorderSizePixel = 0
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.Parent = track
            rounded(fill, 3)

            local value = initial
            local dragging = false
            local moveConnection
            local releaseConnection
            local userInputService = game:GetService("UserInputService")
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local trackWidth = 296
            local step = 10

            local function setValue(nextValue, fireCallback)
                nextValue = tonumber(nextValue) or minValue
                if maxValue ~= minValue then
                    nextValue = clamp(nextValue, minValue, maxValue)
                else
                    nextValue = minValue
                end
                value = math.floor(nextValue)
                local ratio = maxValue == minValue and 0 or (value - minValue) / (maxValue - minValue)
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                valueBox.Text = tostring(value)
                if fireCallback ~= false then
                    safeCallback(callback, value)
                end
            end

            local function valueFromMouse()
                local position = mouse.X - track.AbsolutePosition.X
                local ratio = clamp(position / trackWidth, 0, 1)
                return minValue + (maxValue - minValue) * ratio
            end

            local function stopDragging()
                dragging = false
                if moveConnection then
                    moveConnection:Disconnect()
                    moveConnection = nil
                end
                if releaseConnection then
                    releaseConnection:Disconnect()
                    releaseConnection = nil
                end
            end

            track.MouseButton1Down:Connect(function()
                dragging = true
                setValue(valueFromMouse(), true)
                moveConnection = mouse.Move:Connect(function()
                    if dragging then
                        setValue(valueFromMouse(), true)
                    end
                end)
                releaseConnection = userInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        setValue(valueFromMouse(), true)
                        stopDragging()
                    end
                end)
            end)

            valueBox.FocusLost:Connect(function()
                setValue(valueBox.Text, true)
            end)
            increase.MouseButton1Click:Connect(function()
                setValue(value + step, true)
            end)
            decrease.MouseButton1Click:Connect(function()
                setValue(value - step, true)
            end)
            reset.MouseButton1Click:Connect(function()
                setValue(initial, true)
            end)

            local slider = {}
            function slider:Set(nextValue, fireCallback)
                setValue(nextValue, fireCallback ~= false)
            end
            function slider:Get()
                return value
            end

            setValue(initial, false)
            return slider
        end

        return controls
    end

    window.Gui = screenGui
    window.Background = background
    window.Tabs = tabs
    return window
end

return Daino
