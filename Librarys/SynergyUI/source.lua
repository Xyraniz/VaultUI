local SynergyUI = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local Mouse = Players.LocalPlayer and Players.LocalPlayer:GetMouse() or nil
local _anyKeybindBinding = false

local function getDefaultParent()
    if RunService:IsStudio() then
        local player = Players.LocalPlayer
        if player then return player:WaitForChild("PlayerGui") end
    end
    return CoreGui
end

local function addCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = frame
    return corner
end

local function addStroke(frame, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.85
    stroke.Parent = frame
    return stroke
end

local function createTween(instance, duration, properties, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function addHoverEffect(button, originalColor, hoverColor, useScale)
    local scale = nil
    if useScale then
        scale = Instance.new("UIScale")
        scale.Scale = 1
        scale.Parent = button
    end
    button.MouseEnter:Connect(function()
        createTween(button, 0.18, {BackgroundColor3 = hoverColor})
        if scale then createTween(scale, 0.18, {Scale = 1.04}) end
    end)
    button.MouseLeave:Connect(function()
        createTween(button, 0.18, {BackgroundColor3 = originalColor})
        if scale then createTween(scale, 0.18, {Scale = 1}) end
    end)
end

local function ripple(button, x, y)
    task.spawn(function()
        local circle = Instance.new("ImageLabel")
        circle.Name = "Ripple"
        circle.BackgroundTransparency = 1
        circle.Image = "rbxassetid://266543268"
        circle.ImageColor3 = Color3.new(1,1,1)
        circle.ImageTransparency = 0.6
        circle.Size = UDim2.new(0, 0, 0, 0)
        circle.Position = UDim2.new(0, x, 0, y)
        circle.ZIndex = 100
        circle.Parent = button
        addCorner(circle, 999)

        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.2
        createTween(circle, 0.3, {Size = UDim2.new(0, size, 0, size), Position = UDim2.new(0.5, -size/2, 0.5, -size/2), ImageTransparency = 1})
        task.wait(0.3)
        circle:Destroy()
    end)
end

local function ensureFolder(folderPath)
    if not isfolder then return end
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end
end

local function loadConfigFromFile(configName)
    local path = "SynergyUI/Settings/" .. configName .. ".json"
    if not isfile(path) then return nil end
    local success, data = pcall(readfile, path)
    if success and data and data ~= "" then
        local decodedSuccess, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        if decodedSuccess then
            return decoded
        end
    end
    return nil
end

local function saveConfigToFile(configName, data)
    if not writefile then return end
    ensureFolder("SynergyUI")
    ensureFolder("SynergyUI/Settings")
    local path = "SynergyUI/Settings/" .. configName .. ".json"
    local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
    if success then
        pcall(writefile, path, encoded)
    end
end

local NotificationQueue = {}
local function showNextNotification()
    if #NotificationQueue == 0 then return end
    local n = table.remove(NotificationQueue, 1)

    local gui = Instance.new("ScreenGui")
    gui.Name = "SynergyToast_" .. HttpService:GenerateGUID(false)
    gui.Parent = n.Parent or getDefaultParent()
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    local colors = {
        info = Color3.fromRGB(0, 170, 255),
        done = Color3.fromRGB(0, 230, 100),
        error = Color3.fromRGB(255, 80, 80),
        warning = Color3.fromRGB(255, 160, 0)
    }
    local iconMap = {
        info = "rbxassetid://7021995683",
        done = "rbxassetid://3926305904",
        error = "rbxassetid://3926305904",
        warning = "rbxassetid://163905183"
    }
    local typeColor = n.TypeColor or colors[n.Type or "info"]
    if typeof(typeColor) ~= "Color3" then
        typeColor = colors.info
    end
    local iconId = iconMap[n.Type] or "rbxassetid://7021995683"

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 320, 0, 68)
    addCorner(frame, 14)
    addStroke(frame, Color3.fromRGB(255,255,255), 1, 0.92)

    local pos = n.Position or "TopRight"
    if pos == "TopRight" then
        frame.Position = UDim2.new(1, 330, 0, 25)
        frame.AnchorPoint = Vector2.new(1, 0)
    elseif pos == "TopLeft" then
        frame.Position = UDim2.new(0, -330, 0, 25)
        frame.AnchorPoint = Vector2.new(0, 0)
    elseif pos == "BottomRight" then
        frame.Position = UDim2.new(1, 330, 1, -93)
        frame.AnchorPoint = Vector2.new(1, 1)
    else
        frame.Position = UDim2.new(0, -330, 1, -93)
        frame.AnchorPoint = Vector2.new(0, 1)
    end

    local icon = Instance.new("ImageLabel")
    icon.Parent = frame
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 12, 0.5, -12)
    icon.Image = iconId
    icon.ImageColor3 = typeColor

    local indicator = Instance.new("Frame")
    indicator.Parent = frame
    indicator.BackgroundColor3 = typeColor
    indicator.Size = UDim2.new(0, 6, 1, 0)
    addCorner(indicator, 14)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 45, 0, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = n.Message
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 14.5
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left

    local targetPos
    if pos == "TopRight" then targetPos = UDim2.new(1, -15, 0, 25)
    elseif pos == "TopLeft" then targetPos = UDim2.new(0, 15, 0, 25)
    elseif pos == "BottomRight" then targetPos = UDim2.new(1, -15, 1, -93)
    else targetPos = UDim2.new(0, 15, 1, -93) end
    createTween(frame, 0.45, {Position = targetPos})

    task.spawn(function()
        task.wait(n.Duration or 4.2)
        local exitPos
        if pos == "TopRight" then exitPos = UDim2.new(1, 350, 0, 25)
        elseif pos == "TopLeft" then exitPos = UDim2.new(0, -350, 0, 25)
        elseif pos == "BottomRight" then exitPos = UDim2.new(1, 350, 1, -93)
        else exitPos = UDim2.new(0, -350, 1, -93) end
        createTween(frame, 0.45, {Position = exitPos})
        task.wait(0.45)
        gui:Destroy()
        if n.Callback then pcall(n.Callback) end
        showNextNotification()
    end)
end

function SynergyUI:Notify(options)
    if type(options) == "string" then
        options = { Message = options }
    end
    options.Type = options.Type or "info"
    options.Duration = options.Duration or 4.2
    options.TypeColor = options.TypeColor or (options.Type == "done" and Color3.fromRGB(0,230,100) or
                                              (options.Type == "error" and Color3.fromRGB(255,80,80) or
                                              (options.Type == "warning" and Color3.fromRGB(255,160,0) or
                                              Color3.fromRGB(0,170,255))))
    table.insert(NotificationQueue, options)
    if #NotificationQueue == 1 then showNextNotification() end
end

function SynergyUI:CreateGameNotification(options)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SynergyGameNotify_" .. HttpService:GenerateGUID(false)
    gui.Parent = options.Parent or getDefaultParent()
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = gui
    mainFrame.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Position = UDim2.new(0.5, -183, 0.5, -97)
    mainFrame.Size = UDim2.new(0, 366, 0, 0)
    mainFrame.ClipsDescendants = true
    addCorner(mainFrame, 10)
    addStroke(mainFrame, Color3.fromRGB(80,80,80), 1, 0.5)

    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = Color3.fromRGB(37,36,37)
    titleBar.Size = UDim2.new(1, 0, 0, 54)
    titleBar.BackgroundTransparency = 1

    local logo = Instance.new("ImageLabel")
    logo.Parent = titleBar
    logo.BackgroundTransparency = 1
    logo.Size = UDim2.new(0, 53, 0, 48)
    logo.Position = UDim2.new(0, 8, 0, 3)
    logo.Image = options.Image or "rbxassetid://3926305904"
    logo.ImageTransparency = 1
    addCorner(logo, 5)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, 70, 0, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = options.Title or "Notification"
    titleLabel.TextColor3 = Color3.fromRGB(225,225,225)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 1

    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 0, 0, 54)
    contentFrame.Size = UDim2.new(1, 0, 0, 0)

    local miniTitle = Instance.new("TextLabel")
    miniTitle.Parent = contentFrame
    miniTitle.BackgroundTransparency = 1
    miniTitle.Size = UDim2.new(1, -16, 0, 28)
    miniTitle.Position = UDim2.new(0, 16, 0, 5)
    miniTitle.Font = Enum.Font.GothamBold
    miniTitle.Text = options.MiniTitle or ""
    miniTitle.TextColor3 = Color3.fromRGB(225,225,225)
    miniTitle.TextSize = 14
    miniTitle.TextXAlignment = Enum.TextXAlignment.Left
    miniTitle.TextTransparency = 1

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = contentFrame
    descLabel.BackgroundTransparency = 1
    descLabel.Size = UDim2.new(1, -16, 0, 0)
    descLabel.Position = UDim2.new(0, 16, 0, 35)
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = options.Description or ""
    descLabel.TextColor3 = Color3.fromRGB(208,208,208)
    descLabel.TextSize = 14
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextTransparency = 1

    local yesFrame = Instance.new("Frame")
    yesFrame.Parent = contentFrame
    yesFrame.BackgroundColor3 = Color3.fromRGB(1, 68, 50)
    yesFrame.BackgroundTransparency = 1
    yesFrame.Size = UDim2.new(0, 164, 0, 44)
    yesFrame.Position = UDim2.new(0, 16, 0, 0)
    addCorner(yesFrame, 10)
    addStroke(yesFrame, Color3.fromRGB(1,124,91), 1, 1)

    local yesBtn = Instance.new("TextButton")
    yesBtn.Parent = yesFrame
    yesBtn.BackgroundTransparency = 1
    yesBtn.Size = UDim2.new(1, 0, 1, 0)
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Text = options.YesText or "Accept"
    yesBtn.TextColor3 = Color3.fromRGB(255,255,255)
    yesBtn.TextSize = 18
    yesBtn.TextTransparency = 1

    local noFrame = Instance.new("Frame")
    noFrame.Parent = contentFrame
    noFrame.BackgroundColor3 = Color3.fromRGB(75, 34, 36)
    noFrame.BackgroundTransparency = 1
    noFrame.Size = UDim2.new(0, 164, 0, 44)
    noFrame.Position = UDim2.new(1, -180, 0, 0)
    addCorner(noFrame, 10)
    addStroke(noFrame, Color3.fromRGB(140,63,70), 1, 1)

    local noBtn = Instance.new("TextButton")
    noBtn.Parent = noFrame
    noBtn.BackgroundTransparency = 1
    noBtn.Size = UDim2.new(1, 0, 1, 0)
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Text = options.NoText or "Cancel"
    noBtn.TextColor3 = Color3.fromRGB(255,255,255)
    noBtn.TextSize = 18
    noBtn.TextTransparency = 1

    createTween(mainFrame, 0.4, {Size = UDim2.new(0, 366, 0, 54), BackgroundTransparency = 0})
    task.wait(0.4)
    createTween(mainFrame, 0.3, {Size = UDim2.new(0, 366, 0, 195)})
    task.wait(0.3)
    createTween(titleBar, 0.2, {BackgroundTransparency = 0})
    createTween(logo, 0.2, {ImageTransparency = 0})
    createTween(titleLabel, 0.2, {TextTransparency = 0})
    task.wait(0.2)
    createTween(contentFrame, 0.2, {Size = UDim2.new(1, 0, 0, 141)})
    task.wait(0.1)
    createTween(miniTitle, 0.2, {TextTransparency = 0})
    createTween(descLabel, 0.2, {TextTransparency = 0, Size = UDim2.new(1, -16, 0, 48)})
    task.wait(0.1)
    createTween(yesFrame, 0.2, {BackgroundTransparency = 0, Position = UDim2.new(0, 16, 0, 85)})
    createTween(noFrame, 0.2, {BackgroundTransparency = 0, Position = UDim2.new(1, -180, 0, 85)})
    createTween(yesBtn, 0.2, {TextTransparency = 0})
    createTween(noBtn, 0.2, {TextTransparency = 0})
    for _, stroke in pairs({yesFrame:FindFirstChild("UIStroke"), noFrame:FindFirstChild("UIStroke")}) do
        if stroke then createTween(stroke, 0.2, {Transparency = 0}) end
    end

    local closed = false
    local function close(choice)
        if closed then return end
        closed = true
        createTween(mainFrame, 0.3, {BackgroundTransparency = 1})
        task.wait(0.3)
        gui:Destroy()
        if choice == "yes" and options.YesCallback then pcall(options.YesCallback) end
        if choice == "no" and options.NoCallback then pcall(options.NoCallback) end
    end

    yesBtn.MouseButton1Click:Connect(function() close("yes") end)
    noBtn.MouseButton1Click:Connect(function() close("no") end)
end

local ControlFactory = {}
function ControlFactory:new(parent, theme, updateThemeCallback, configHandler)
    local obj = {}
    obj.parent = parent
    obj.theme = theme
    obj.updateTheme = updateThemeCallback
    obj.controls = {}
    obj.connections = {}
    obj.configHandler = configHandler
    obj.createdControls = {}
    setmetatable(obj, { __index = ControlFactory })
    return obj
end

function ControlFactory:createLabel(text)
    local label = Instance.new("TextLabel")
    label.Parent = self.parent
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, self.theme.LabelHeight)
    label.Font = self.theme.Font
    label.Text = text
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(self.createdControls, {type = "label", instance = label})
    return label
end

function ControlFactory:createSeparator()
    local sep = Instance.new("Frame")
    sep.Parent = self.parent
    sep.BackgroundColor3 = self.theme.StrokeColor
    sep.BorderSizePixel = 0
    sep.Size = UDim2.new(1, 0, 0, 1)
    table.insert(self.createdControls, {type = "separator", instance = sep})
    return sep
end

function ControlFactory:createButton(options)
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.ButtonHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Font = self.theme.Font
    btn.Text = options.Name
    btn.TextColor3 = self.theme.Text
    btn.TextSize = self.theme.TextSizeNormal

    addHoverEffect(btn, self.theme.Element, self.theme.HoverColor, true)

    local connection = btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local x = input.Position.X - btn.AbsolutePosition.X
            local y = input.Position.Y - btn.AbsolutePosition.Y
            ripple(btn, x, y)
            local s, e = pcall(options.Callback)
            if not s then SynergyUI:Notify({Message = "Error: " .. tostring(e), Type = "error"}) end
        end
    end)

    if options.Tooltip then
        local tooltip = Instance.new("Frame")
        tooltip.Name = "Tooltip"
        tooltip.Parent = btn
        tooltip.BackgroundColor3 = self.theme.ElementDark
        tooltip.BorderSizePixel = 0
        tooltip.Position = UDim2.new(0, 0, 1, 4)
        tooltip.Size = UDim2.new(0, 0, 0, 24)
        addCorner(tooltip, 6)
        addStroke(tooltip, self.theme.StrokeColor)

        local tipLabel = Instance.new("TextLabel")
        tipLabel.Parent = tooltip
        tipLabel.BackgroundTransparency = 1
        tipLabel.Size = UDim2.new(1, -12, 1, 0)
        tipLabel.Position = UDim2.new(0, 6, 0, 0)
        tipLabel.Font = self.theme.Font
        tipLabel.Text = options.Tooltip
        tipLabel.TextColor3 = self.theme.TextMuted
        tipLabel.TextSize = self.theme.TextSizeSmall
        tipLabel.TextXAlignment = Enum.TextXAlignment.Left

        tooltip.Visible = false
        local show = btn.MouseEnter:Connect(function()
            tooltip.Visible = true
            local txtW = TextService:GetTextSize(options.Tooltip, self.theme.TextSizeSmall, self.theme.Font, Vector2.new(9999,9999)).X
            tooltip.Size = UDim2.new(0, txtW + 18, 0, 24)
        end)
        local hide = btn.MouseLeave:Connect(function() tooltip.Visible = false end)
        table.insert(self.connections, show)
        table.insert(self.connections, hide)
    end

    table.insert(self.createdControls, {type = "button", frame = frame, btn = btn, tooltip = options.Tooltip})
    return frame, connection
end

function ControlFactory:createToggle(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local state = (savedVal ~= nil and type(savedVal) == "boolean") and savedVal or (options.CurrentValue or false)

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.ToggleHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = self.theme.Font
    label.Text = options.Name
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left

    local outer = Instance.new("Frame")
    outer.Parent = frame
    outer.BackgroundColor3 = self.theme.ElementDark
    outer.Position = UDim2.new(1, -self.theme.ToggleWidth - self.theme.PaddingHorizontal, 0.5, -self.theme.ToggleHeight/2 + 1)
    outer.Size = UDim2.new(0, self.theme.ToggleWidth, 0, self.theme.ToggleHeight - 8)
    addCorner(outer, 999)

    local inner = Instance.new("Frame")
    inner.Parent = outer
    inner.BackgroundColor3 = state and self.theme.Accent or self.theme.TextMuted
    local innerSize = self.theme.ToggleHeight - 16
    inner.Position = state and UDim2.new(1, -innerSize - 4, 0.5, -innerSize/2) or UDim2.new(0, 4, 0.5, -innerSize/2)
    inner.Size = UDim2.new(0, innerSize, 0, innerSize)
    addCorner(inner, 999)

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""

    local function update(val)
        state = val
        createTween(inner, 0.25, {
            Position = state and UDim2.new(1, -innerSize - 4, 0.5, -innerSize/2) or UDim2.new(0, 4, 0.5, -innerSize/2),
            BackgroundColor3 = state and self.theme.Accent or self.theme.TextMuted
        })
        label.TextColor3 = state and self.theme.Accent or self.theme.Text
        pcall(options.Callback, state)
        if self.configHandler then self.configHandler:Set(flag, state) end
    end

    local flagObj = {
        GetValue = function() return state end,
        SetValue = function(_, v) update(v) end
    }
    self.controls[flag] = flagObj

    local connection = btn.MouseButton1Click:Connect(function() update(not state) end)
    if state then pcall(options.Callback, state) end

    table.insert(self.createdControls, {type = "toggle", frame = frame, label = label, outer = outer, inner = inner, btn = btn, stateVar = state, update = update})
    return frame, connection
end

function ControlFactory:createCheckBox(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local state = (savedVal ~= nil and type(savedVal) == "boolean") and savedVal or (options.CurrentValue or false)

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.ToggleHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = self.theme.Font
    label.Text = options.Name
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left

    local checkFrame = Instance.new("Frame")
    checkFrame.Parent = frame
    checkFrame.BackgroundColor3 = self.theme.ElementDark
    checkFrame.Position = UDim2.new(1, -self.theme.ToggleWidth - self.theme.PaddingHorizontal, 0.5, -12)
    checkFrame.Size = UDim2.new(0, 24, 0, 24)
    addCorner(checkFrame, 6)
    addStroke(checkFrame, self.theme.StrokeColor)

    local checkIcon = Instance.new("ImageLabel")
    checkIcon.Parent = checkFrame
    checkIcon.BackgroundTransparency = 1
    checkIcon.Size = UDim2.new(1, -6, 1, -6)
    checkIcon.Position = UDim2.new(0, 3, 0, 3)
    checkIcon.Image = "rbxassetid://3926305904"
    checkIcon.ImageRectOffset = Vector2.new(644, 204)
    checkIcon.ImageRectSize = Vector2.new(36, 36)
    checkIcon.ImageColor3 = self.theme.Accent
    checkIcon.ImageTransparency = state and 0 or 1

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""

    local function update(val)
        state = val
        createTween(checkIcon, 0.2, {ImageTransparency = state and 0 or 1})
        label.TextColor3 = state and self.theme.Accent or self.theme.Text
        pcall(options.Callback, state)
        if self.configHandler then self.configHandler:Set(flag, state) end
    end

    local flagObj = {
        GetValue = function() return state end,
        SetValue = function(_, v) update(v) end
    }
    self.controls[flag] = flagObj

    local connection = btn.MouseButton1Click:Connect(function() update(not state) end)
    if state then pcall(options.Callback, state) end

    table.insert(self.createdControls, {type = "checkbox", frame = frame, label = label, checkFrame = checkFrame, checkIcon = checkIcon, btn = btn, stateVar = state})
    return frame, connection
end

function ControlFactory:createSlider(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local val
    if savedVal ~= nil and type(savedVal) == "number" then
        val = math.clamp(savedVal, options.Range[1], options.Range[2])
    else
        val = options.CurrentValue or options.Range[1]
    end

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.SliderHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    label.Size = UDim2.new(0.65, 0, 0, self.theme.TextSizeNormal + 4)
    label.Font = self.theme.Font
    label.Text = options.Name
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valLabel = Instance.new("TextLabel")
    valLabel.Parent = frame
    valLabel.BackgroundTransparency = 1
    valLabel.Position = UDim2.new(1, -68 - self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    valLabel.Size = UDim2.new(0, 60, 0, self.theme.TextSizeNormal + 4)
    valLabel.Font = self.theme.Font
    valLabel.Text = tostring(val)
    valLabel.TextColor3 = self.theme.Accent
    valLabel.TextSize = self.theme.TextSizeNormal
    valLabel.TextXAlignment = Enum.TextXAlignment.Right

    local bg = Instance.new("Frame")
    bg.Parent = frame
    bg.BackgroundColor3 = self.theme.ElementDark
    bg.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + self.theme.TextSizeNormal + 8)
    bg.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal - 130, 0, self.theme.SliderBarHeight)
    addCorner(bg, self.theme.SliderBarHeight / 2)
    addStroke(bg, self.theme.StrokeColor, 1, 0.9)

    local fill = Instance.new("Frame")
    fill.Parent = bg
    fill.BackgroundColor3 = self.theme.Accent
    fill.Size = UDim2.new((val - options.Range[1]) / (options.Range[2] - options.Range[1]), 0, 1, 0)
    addCorner(fill, self.theme.SliderBarHeight / 2)

    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.theme.Accent),
        ColorSequenceKeypoint.new(1, self.theme.Accent:lerp(Color3.fromRGB(255,255,255), 0.3))
    })
    fillGradient.Rotation = 90
    fillGradient.Parent = fill

    local thumb = Instance.new("Frame")
    thumb.Parent = fill
    thumb.BackgroundColor3 = self.theme.Accent
    thumb.Position = UDim2.new(1, -8, 0.5, -8)
    thumb.Size = UDim2.new(0, 16, 0, 16)
    addCorner(thumb, 999)
    addStroke(thumb, Color3.fromRGB(255,255,255), 1.5, 0.4)

    local tooltip = Instance.new("Frame")
    tooltip.Parent = bg
    tooltip.BackgroundColor3 = self.theme.ElementDark
    tooltip.BorderSizePixel = 0
    tooltip.Position = UDim2.new(0, 0, 0, -28)
    tooltip.Size = UDim2.new(0, 40, 0, 22)
    tooltip.Visible = false
    addCorner(tooltip, 8)
    addStroke(tooltip, self.theme.Accent, 1, 0.5)
    local tooltipLabel = Instance.new("TextLabel")
    tooltipLabel.Parent = tooltip
    tooltipLabel.BackgroundTransparency = 1
    tooltipLabel.Size = UDim2.new(1, 0, 1, 0)
    tooltipLabel.Font = self.theme.Font
    tooltipLabel.Text = tostring(val)
    tooltipLabel.TextColor3 = self.theme.Text
    tooltipLabel.TextSize = 12

    local inputBg = Instance.new("Frame")
    inputBg.Parent = frame
    inputBg.BackgroundColor3 = self.theme.ElementDark
    inputBg.Position = UDim2.new(1, -68 - self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + self.theme.TextSizeNormal + 6)
    inputBg.Size = UDim2.new(0, 60, 0, 22)
    addCorner(inputBg, 8)
    addStroke(inputBg, self.theme.StrokeColor)

    local numInput = Instance.new("TextBox")
    numInput.Parent = inputBg
    numInput.BackgroundTransparency = 1
    numInput.ClearTextOnFocus = false
    numInput.Size = UDim2.new(1, 0, 1, 0)
    numInput.Font = self.theme.Font
    numInput.Text = tostring(val)
    numInput.TextColor3 = self.theme.Text
    numInput.TextSize = self.theme.TextSizeSmall
    numInput.TextXAlignment = Enum.TextXAlignment.Center

    numInput:GetPropertyChangedSignal("Text"):Connect(function()
        numInput.Text = numInput.Text:gsub("[^%d%.%-]", "")
    end)

    local dragging = false

    local function move(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local calc = options.Range[1] + pos * (options.Range[2] - options.Range[1])
        local inc = options.Increment or 1
        calc = math.floor(calc / inc + 0.5) * inc
        calc = math.clamp(calc, options.Range[1], options.Range[2])
        val = calc
        valLabel.Text = math.floor(val) == val and tostring(val) or string.format("%.2f", val)
        numInput.Text = valLabel.Text
        tooltipLabel.Text = valLabel.Text
        createTween(fill, 0.12, {Size = UDim2.new((val - options.Range[1]) / (options.Range[2] - options.Range[1]), 0, 1, 0)})
        pcall(options.Callback, val)
        if self.configHandler then self.configHandler:Set(flag, val) end
    end

    local btn = Instance.new("TextButton")
    btn.Parent = bg
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""

    local function showTooltip(pos)
        local percent = (val - options.Range[1]) / (options.Range[2] - options.Range[1])
        local xPos = bg.AbsoluteSize.X * percent - tooltip.AbsoluteSize.X/2
        tooltip.Position = UDim2.new(0, xPos, 0, -28)
        tooltip.Visible = true
    end

    local connection1 = btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            move(input)
            showTooltip()
        end
    end)

    local connection2 = UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            dragging = false
            tooltip.Visible = false
        end
    end)

    local connection3 = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            move(input)
            showTooltip()
        end
    end)

    local connection4 = numInput.FocusLost:Connect(function()
        local newVal = tonumber(numInput.Text)
        if newVal then
            newVal = math.clamp(newVal, options.Range[1], options.Range[2])
            local inc = options.Increment or 1
            newVal = math.floor(newVal / inc + 0.5) * inc
            val = newVal
            valLabel.Text = tostring(val)
            fill.Size = UDim2.new((val - options.Range[1]) / (options.Range[2] - options.Range[1]), 0, 1, 0)
            pcall(options.Callback, val)
            if self.configHandler then self.configHandler:Set(flag, val) end
        else
            numInput.Text = tostring(val)
        end
    end)

    local flagObj = {
        GetValue = function() return val end,
        SetValue = function(_, v)
            v = math.clamp(v, options.Range[1], options.Range[2])
            if options.Increment then v = math.floor(v / options.Increment + 0.5) * options.Increment end
            val = v
            valLabel.Text = tostring(v)
            numInput.Text = tostring(v)
            fill.Size = UDim2.new((v - options.Range[1]) / (options.Range[2] - options.Range[1]), 0, 1, 0)
            pcall(options.Callback, v)
            if self.configHandler then self.configHandler:Set(flag, v) end
        end
    }
    self.controls[flag] = flagObj

    table.insert(self.createdControls, {type = "slider", frame = frame, label = label, valLabel = valLabel, bg = bg, fill = fill, fillGradient = fillGradient, thumb = thumb, tooltip = tooltip, tooltipLabel = tooltipLabel, inputBg = inputBg, numInput = numInput, btn = btn, range = options.Range})
    return frame, {connection1, connection2, connection3, connection4}
end

function ControlFactory:createDropdown(options)
    local flag = options.Flag or options.Name
    local optionsList = options.Options or {}
    local multi = options.MultiSelect or false
    local searchable = options.Searchable or false
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local selected = {}
    if multi then
        if savedVal and type(savedVal) == "table" then
            for _, v in ipairs(savedVal) do selected[v] = true end
        elseif options.CurrentSelected and type(options.CurrentSelected) == "table" then
            for _, v in ipairs(options.CurrentSelected) do selected[v] = true end
        end
    else
        if savedVal and type(savedVal) == "string" and table.find(optionsList, savedVal) then
            selected = savedVal
        else
            selected = options.CurrentOption or optionsList[1] or ""
        end
    end

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.DropdownHeight)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, self.theme.DropdownHeight)
    btn.Font = self.theme.Font
    btn.Text = options.Name .. " : " .. (multi and "Select" or (selected == "" and "None" or selected))
    btn.TextColor3 = self.theme.Text
    btn.TextSize = self.theme.TextSizeNormal
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)

    local icon = Instance.new("TextLabel")
    icon.Parent = frame
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(1, -34, 0.5, -8)
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Font = Enum.Font.GothamBold
    icon.Text = "v"
    icon.TextColor3 = self.theme.TextMuted
    icon.TextSize = 14

    local container = Instance.new("ScrollingFrame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.BorderSizePixel = 0
    container.Position = UDim2.new(0, 0, 0, self.theme.DropdownHeight)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = self.theme.Accent
    container.CanvasSize = UDim2.new(0, 0, 0, 0)

    if searchable then
        local searchBox = Instance.new("TextBox")
        searchBox.Parent = container
        searchBox.BackgroundColor3 = self.theme.Element
        searchBox.Size = UDim2.new(1, -12, 0, 28)
        searchBox.Position = UDim2.new(0, 6, 0, 4)
        searchBox.Font = self.theme.Font
        searchBox.PlaceholderText = "Search..."
        searchBox.Text = ""
        searchBox.TextColor3 = self.theme.Text
        searchBox.TextSize = self.theme.TextSizeSmall
        addCorner(searchBox, 8)
        addStroke(searchBox, self.theme.StrokeColor)
        searchBox.ClearTextOnFocus = false
    end

    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)

    local isOpen = false
    local optionButtons = {}

    local function updateButtonText()
        if multi then
            local count = 0
            for _,v in pairs(selected) do if v then count = count + 1 end end
            btn.Text = options.Name .. " : " .. count .. " selected"
        else
            btn.Text = options.Name .. " : " .. (selected == "" and "None" or selected)
        end
    end

    local function rebuild(filter)
        for _, b in ipairs(optionButtons) do if b and b.Parent then b:Destroy() end end
        optionButtons = {}
        for _, opt in ipairs(optionsList) do
            if not filter or string.find(string.lower(opt), string.lower(filter)) then
                local optFrame = Instance.new("Frame")
                optFrame.Parent = container
                optFrame.BackgroundColor3 = self.theme.ElementDark
                optFrame.Size = UDim2.new(1, 0, 0, self.theme.DropdownItemHeight)
                optFrame.BorderSizePixel = 0

                local optBtn = Instance.new("TextButton")
                optBtn.Parent = optFrame
                optBtn.BackgroundTransparency = 1
                optBtn.Size = UDim2.new(1, 0, 1, 0)
                optBtn.Font = self.theme.Font
                optBtn.Text = "   " .. opt
                optBtn.TextColor3 = self.theme.TextMuted
                optBtn.TextSize = self.theme.TextSizeSmall
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                addHoverEffect(optBtn, self.theme.ElementDark, self.theme.HoverColor, false)

                if multi then
                    local check = Instance.new("Frame")
                    check.Parent = optFrame
                    check.BackgroundColor3 = selected[opt] and self.theme.Accent or self.theme.Element
                    check.Position = UDim2.new(1, -28, 0.5, -10)
                    check.Size = UDim2.new(0, 20, 0, 20)
                    addCorner(check, 6)
                    addStroke(check, self.theme.StrokeColor)
                end

                optBtn.MouseButton1Click:Connect(function()
                    if multi then
                        selected[opt] = not selected[opt]
                        local checkFrame = optFrame:FindFirstChildWhichIsA("Frame")
                        if checkFrame then
                            createTween(checkFrame, 0.2, {BackgroundColor3 = selected[opt] and self.theme.Accent or self.theme.Element})
                        end
                        updateButtonText()
                        pcall(options.Callback, opt, selected[opt])
                        if self.configHandler then self.configHandler:Set(flag, flagObj:GetValue()) end
                    else
                        selected = opt
                        updateButtonText()
                        isOpen = false
                        createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, self.theme.DropdownHeight)})
                        container.Size = UDim2.new(1, 0, 0, 0)
                        icon.Text = "v"
                        pcall(options.Callback, opt)
                        if self.configHandler then self.configHandler:Set(flag, selected) end
                    end
                end)
                table.insert(optionButtons, optBtn)
            end
        end
        container.CanvasSize = UDim2.new(0, 0, 0, #optionButtons * self.theme.DropdownItemHeight + (searchable and 40 or 8))
    end
    rebuild()

    if searchable then
        local searchBox = container:FindFirstChildWhichIsA("TextBox")
        if searchBox then
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                rebuild(searchBox.Text)
            end)
        end
    end

    local connection = btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local expandedHeight = math.min(#optionsList * self.theme.DropdownItemHeight + (searchable and 40 or 8), 200)
            local targetHeight = self.theme.DropdownHeight + expandedHeight
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, targetHeight)})
            container.Size = UDim2.new(1, 0, 0, expandedHeight)
            icon.Text = "^"
        else
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, self.theme.DropdownHeight)})
            container.Size = UDim2.new(1, 0, 0, 0)
            icon.Text = "v"
        end
    end)

    local flagObj = {
        GetValue = function()
            if multi then
                local res = {}
                for k,v in pairs(selected) do if v then table.insert(res, k) end end
                return res
            else
                return selected
            end
        end,
        SetValue = function(_, v)
            if multi then
                selected = {}
                if type(v) == "table" then for _,x in ipairs(v) do selected[x] = true end end
            else
                if table.find(optionsList, v) then selected = v end
            end
            updateButtonText()
            rebuild()
            pcall(options.Callback, v)
            if self.configHandler then self.configHandler:Set(flag, flagObj:GetValue()) end
        end,
        AddOption = function(_, opt)
            if not table.find(optionsList, opt) then
                table.insert(optionsList, opt)
                rebuild()
            end
        end,
        RemoveOption = function(_, opt)
            local idx = table.find(optionsList, opt)
            if idx then
                table.remove(optionsList, idx)
                if multi then selected[opt] = nil
                elseif selected == opt then selected = "" end
                rebuild()
                updateButtonText()
                if self.configHandler then self.configHandler:Set(flag, flagObj:GetValue()) end
            end
        end,
        ClearOptions = function()
            optionsList = {}
            selected = multi and {} or ""
            rebuild()
            updateButtonText()
            if self.configHandler then self.configHandler:Set(flag, flagObj:GetValue()) end
        end,
        Select = function(_, val)
            if multi then
                if type(val) == "table" then
                    for _,x in ipairs(val) do selected[x] = true end
                end
            else
                if table.find(optionsList, val) then selected = val end
            end
            updateButtonText()
            rebuild()
            pcall(options.Callback, val)
            if self.configHandler then self.configHandler:Set(flag, flagObj:GetValue()) end
        end
    }
    self.controls[flag] = flagObj

    table.insert(self.createdControls, {type = "dropdown", frame = frame, btn = btn, icon = icon, container = container})
    return flagObj, connection
end

function ControlFactory:createChecklist(options)
    local flag = options.Flag or options.Name
    local optionsList = options.Options or {}
    local selected = {}
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    if savedVal ~= nil and type(savedVal) == "table" then
        for _, v in ipairs(savedVal) do selected[v] = true end
    elseif options.CurrentSelected then
        for _, v in ipairs(options.CurrentSelected) do selected[v] = true end
    end

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.ChecklistHeight)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, self.theme.ChecklistHeight)
    btn.Font = self.theme.Font
    btn.Text = options.Name
    btn.TextColor3 = self.theme.Text
    btn.TextSize = self.theme.TextSizeNormal
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)

    local countLabel = Instance.new("TextLabel")
    countLabel.Parent = frame
    countLabel.BackgroundTransparency = 1
    countLabel.Position = UDim2.new(1, -80, 0.5, -10)
    countLabel.Size = UDim2.new(0, 60, 0, 20)
    countLabel.Font = self.theme.Font
    countLabel.Text = "0 selected"
    countLabel.TextColor3 = self.theme.Accent
    countLabel.TextSize = self.theme.TextSizeSmall
    countLabel.TextXAlignment = Enum.TextXAlignment.Right

    local icon = Instance.new("TextLabel")
    icon.Parent = frame
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(1, -34, 0.5, -8)
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Font = Enum.Font.GothamBold
    icon.Text = "v"
    icon.TextColor3 = self.theme.TextMuted
    icon.TextSize = 14

    local container = Instance.new("ScrollingFrame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.BorderSizePixel = 0
    container.Position = UDim2.new(0, 0, 0, self.theme.ChecklistHeight)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = self.theme.Accent
    container.CanvasSize = UDim2.new(0, 0, 0, 0)

    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)

    local function getSelectedValues()
        local result = {}
        for k, v in pairs(selected) do if v then table.insert(result, k) end end
        return result
    end

    local function updateSelectedCount()
        local count = 0
        for _, v in pairs(selected) do if v then count = count + 1 end end
        countLabel.Text = count .. " selected"
        pcall(options.Callback, selected)
        if self.configHandler then self.configHandler:Set(flag, getSelectedValues()) end
    end

    local function rebuild()
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        for _, opt in ipairs(optionsList) do
            local row = Instance.new("Frame")
            row.Parent = container
            row.BackgroundColor3 = self.theme.ElementDark
            row.BorderSizePixel = 0
            row.Size = UDim2.new(1, 0, 0, self.theme.ChecklistItemHeight)

            local toggleOuter = Instance.new("Frame")
            toggleOuter.Parent = row
            toggleOuter.BackgroundColor3 = self.theme.Element
            toggleOuter.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0.5, -10)
            toggleOuter.Size = UDim2.new(0, 20, 0, 20)
            addCorner(toggleOuter, 6)
            addStroke(toggleOuter, self.theme.StrokeColor)

            local toggleInner = Instance.new("Frame")
            toggleInner.Parent = toggleOuter
            toggleInner.BackgroundColor3 = selected[opt] and self.theme.Accent or Color3.fromRGB(60,60,60)
            toggleInner.Position = selected[opt] and UDim2.new(0.5, -6, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            toggleInner.Size = UDim2.new(0, 12, 0, 12)
            addCorner(toggleInner, 6)

            local optLabel = Instance.new("TextLabel")
            optLabel.Parent = row
            optLabel.BackgroundTransparency = 1
            optLabel.Position = UDim2.new(0, self.theme.PaddingHorizontal + 32, 0.5, -10)
            optLabel.Size = UDim2.new(1, -self.theme.PaddingHorizontal - 40, 0, 20)
            optLabel.Font = self.theme.Font
            optLabel.Text = opt
            optLabel.TextColor3 = self.theme.TextMuted
            optLabel.TextSize = self.theme.TextSizeSmall
            optLabel.TextXAlignment = Enum.TextXAlignment.Left

            local clickBtn = Instance.new("TextButton")
            clickBtn.Parent = row
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.Text = ""

            clickBtn.MouseButton1Click:Connect(function()
                selected[opt] = not selected[opt]
                createTween(toggleInner, 0.2, {
                    BackgroundColor3 = selected[opt] and self.theme.Accent or Color3.fromRGB(60,60,60),
                    Position = selected[opt] and UDim2.new(0.5, -6, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
                })
                updateSelectedCount()
            end)
        end
        container.CanvasSize = UDim2.new(0, 0, 0, #optionsList * self.theme.ChecklistItemHeight + 8)
        updateSelectedCount()
    end
    rebuild()

    local isOpen = false
    local connection = btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local expandedHeight = math.min(#optionsList * self.theme.ChecklistItemHeight + 8, 220)
            local targetHeight = self.theme.ChecklistHeight + expandedHeight
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, targetHeight)})
            container.Size = UDim2.new(1, 0, 0, expandedHeight)
            icon.Text = "^"
        else
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, self.theme.ChecklistHeight)})
            container.Size = UDim2.new(1, 0, 0, 0)
            icon.Text = "v"
        end
    end)

    local flagObj = {
        GetValue = function()
            local result = {}
            for k, v in pairs(selected) do if v then table.insert(result, k) end end
            return result
        end,
        SetValue = function(_, tbl)
            selected = {}
            for _, x in ipairs(tbl) do selected[x] = true end
            rebuild()
        end,
        AddOption = function(_, opt)
            if not table.find(optionsList, opt) then
                table.insert(optionsList, opt)
                rebuild()
            end
        end,
        RemoveOption = function(_, opt)
            local idx = table.find(optionsList, opt)
            if idx then
                table.remove(optionsList, idx)
                selected[opt] = nil
                rebuild()
            end
        end
    }
    self.controls[flag] = flagObj

    table.insert(self.createdControls, {type = "checklist", frame = frame, btn = btn, countLabel = countLabel, icon = icon, container = container})
    return flagObj, connection
end

function ControlFactory:createTextInput(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.TextInputHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    label.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, self.theme.TextSizeNormal + 4)
    label.Font = self.theme.Font
    label.Text = options.Name
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox")
    input.Parent = frame
    input.BackgroundColor3 = self.theme.ElementDark
    input.ClearTextOnFocus = false
    input.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + self.theme.TextSizeNormal + 10)
    input.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, self.theme.TextInputFieldHeight)
    input.Font = self.theme.Font
    input.Text = (savedVal ~= nil and type(savedVal) == "string") and savedVal or (options.CurrentText or "")
    input.TextColor3 = self.theme.Text
    input.TextSize = self.theme.TextSizeSmall
    input.PlaceholderText = options.Placeholder or ""
    input.PlaceholderColor3 = self.theme.TextMuted
    input.TextXAlignment = Enum.TextXAlignment.Left
    addCorner(input, self.theme.CornerRadius)
    addStroke(input, self.theme.StrokeColor)

    local inputPad = Instance.new("UIPadding")
    inputPad.Parent = input
    inputPad.PaddingLeft = UDim.new(0, 10)
    inputPad.PaddingRight = UDim.new(0, 10)

    local connection = input.FocusLost:Connect(function()
        pcall(options.Callback, input.Text)
        if self.configHandler then self.configHandler:Set(flag, input.Text) end
    end)

    local flagObj = {
        GetValue = function() return input.Text end,
        SetValue = function(_, v) input.Text = v end
    }
    self.controls[flag] = flagObj

    table.insert(self.createdControls, {type = "textinput", frame = frame, label = label, input = input})
    return flagObj, connection
end

function ControlFactory:createNumberInput(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local currentVal = (savedVal ~= nil and type(savedVal) == "number") and savedVal or (tonumber(options.CurrentValue) or 0)

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.TextInputHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    label.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, self.theme.TextSizeNormal + 4)
    label.Font = self.theme.Font
    label.Text = options.Name
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox")
    input.Parent = frame
    input.BackgroundColor3 = self.theme.ElementDark
    input.ClearTextOnFocus = false
    input.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + self.theme.TextSizeNormal + 10)
    input.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, self.theme.TextInputFieldHeight)
    input.Font = self.theme.Font
    input.Text = tostring(currentVal)
    input.TextColor3 = self.theme.Text
    input.TextSize = self.theme.TextSizeSmall
    addCorner(input, self.theme.CornerRadius)
    addStroke(input, self.theme.StrokeColor)
    input:GetPropertyChangedSignal("Text"):Connect(function()
        input.Text = input.Text:gsub("[^%d%.%-]", "")
    end)

    local connection = input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        if num then
            currentVal = num
            pcall(options.Callback, currentVal)
            if self.configHandler then self.configHandler:Set(flag, currentVal) end
        else
            input.Text = tostring(currentVal)
        end
    end)

    local flagObj = {
        GetValue = function() return currentVal end,
        SetValue = function(_, v) currentVal = tonumber(v) or 0; input.Text = tostring(currentVal); pcall(options.Callback, currentVal); if self.configHandler then self.configHandler:Set(flag, currentVal) end end
    }
    self.controls[flag] = flagObj

    table.insert(self.createdControls, {type = "numberinput", frame = frame, label = label, input = input})
    return flagObj, connection
end

local function stringToKeyCode(str)
    if not str or str == "None" then return nil end
    local success, result = pcall(function()
        return Enum.KeyCode[str]
    end)
    if success and result then
        return result
    end
    for _, v in pairs(Enum.KeyCode:GetEnumItems()) do
        if v.Name:lower() == str:lower() then
            return v
        end
    end
    return nil
end

function ControlFactory:createKeybind(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local currentStr = (savedVal ~= nil and type(savedVal) == "string") and savedVal or (options.CurrentKeybind or "None")

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.KeybindHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = self.theme.Font
    label.Text = options.Name
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bindBtn = Instance.new("TextButton")
    bindBtn.Parent = frame
    bindBtn.BackgroundColor3 = self.theme.ElementDark
    bindBtn.Position = UDim2.new(1, -self.theme.KeybindWidth - self.theme.PaddingHorizontal, 0.5, -self.theme.KeybindHeight/2)
    bindBtn.Size = UDim2.new(0, self.theme.KeybindWidth, 0, self.theme.KeybindHeight)
    bindBtn.Font = self.theme.Font
    bindBtn.Text = currentStr
    bindBtn.TextColor3 = self.theme.Accent
    bindBtn.TextSize = self.theme.TextSizeSmall
    addCorner(bindBtn, self.theme.CornerRadius)
    addStroke(bindBtn, self.theme.StrokeColor)

    local binding = false

    local connection1 = bindBtn.MouseButton1Click:Connect(function()
        binding = true
        _anyKeybindBinding = true
        bindBtn.Text = "..."
        SynergyUI:Notify({Message = "Press any key...", Duration = 2, Type = "info"})
        task.delay(5, function()
            if binding then
                binding = false
                _anyKeybindBinding = false
                bindBtn.Text = currentStr
                SynergyUI:Notify({Message = "Keybind cancelled", Type = "warning"})
            end
        end)
    end)

    local connection2 = UserInputService.InputBegan:Connect(function(input, gp)
        if binding then
            if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType.Name:find("MouseButton") then
                local keyName = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name
                if keyName == "Escape" then keyName = "None" end
                currentStr = keyName
                binding = false
                _anyKeybindBinding = false
                bindBtn.Text = currentStr
                pcall(options.Callback, currentStr)
                if self.configHandler then self.configHandler:Set(flag, currentStr) end
                SynergyUI:Notify({Message = "Keybind set to " .. currentStr, Duration = 2, Type = "done"})
            end
        elseif not gp then
            local inputName = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name
            if inputName == currentStr and currentStr ~= "None" then
                pcall(options.Callback, currentStr)
            end
        end
    end)

    local flagObj = {
        GetValue = function() return currentStr end,
        SetValue = function(_, v)
            currentStr = v
            bindBtn.Text = v
            pcall(options.Callback, v)
            if self.configHandler then self.configHandler:Set(flag, v) end
        end
    }
    self.controls[flag] = flagObj

    table.insert(self.createdControls, {type = "keybind", frame = frame, label = label, bindBtn = bindBtn})
    return flagObj, {connection1, connection2}
end

function ControlFactory:createColorPicker(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local color
    if savedVal ~= nil and type(savedVal) == "table" and savedVal.__type == "Color3" then
        color = Color3.new(savedVal.r, savedVal.g, savedVal.b)
    else
        color = options.Color or Color3.fromRGB(0, 170, 255)
    end
    local h, s, v = Color3.toHSV(color)
    local rainbowActive = false
    local rainbowTask = nil

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, self.theme.ColorPickerHeight)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = self.theme.Font
    label.Text = options.Name
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left

    local preview = Instance.new("Frame")
    preview.Parent = frame
    preview.BackgroundColor3 = color
    preview.Position = UDim2.new(1, -self.theme.ColorPickerPreviewSize - self.theme.PaddingHorizontal, 0.5, -self.theme.ColorPickerPreviewSize/2)
    preview.Size = UDim2.new(0, self.theme.ColorPickerPreviewSize, 0, self.theme.ColorPickerPreviewSize)
    addCorner(preview, self.theme.CornerRadius)
    addStroke(preview, Color3.fromRGB(255,255,255), 1.5, 0.6)

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, self.theme.ColorPickerHeight)
    btn.Text = ""

    local container = Instance.new("Frame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.Position = UDim2.new(0, 0, 0, self.theme.ColorPickerHeight)
    container.Size = UDim2.new(1, 0, 0, self.theme.ColorPickerExpandedHeight - self.theme.ColorPickerHeight)
    container.Visible = false

    local colorWheel = Instance.new("ImageLabel")
    colorWheel.Parent = container
    colorWheel.BackgroundColor3 = Color3.fromRGB(255,0,4)
    colorWheel.Position = UDim2.new(0, 12, 0, 12)
    colorWheel.Size = UDim2.new(0, 140, 0, 140)
    colorWheel.Image = "rbxassetid://4155801252"
    addCorner(colorWheel, 8)

    local colorSelection = Instance.new("ImageLabel")
    colorSelection.Parent = colorWheel
    colorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
    colorSelection.BackgroundTransparency = 1
    colorSelection.Size = UDim2.new(0, 18, 0, 18)
    colorSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
    colorSelection.Position = UDim2.new(s, 0, 1 - v, 0)

    local hueBar = Instance.new("Frame")
    hueBar.Parent = container
    hueBar.Position = UDim2.new(0, 165, 0, 12)
    hueBar.Size = UDim2.new(0, 25, 0, 140)
    addCorner(hueBar, 4)

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,4)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(234,255,0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(21,255,0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,17,255)),
        ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255,0,251)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,4))
    })
    hueGradient.Rotation = 270
    hueGradient.Parent = hueBar

    local hueSelection = Instance.new("ImageLabel")
    hueSelection.Parent = hueBar
    hueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
    hueSelection.BackgroundTransparency = 1
    hueSelection.Size = UDim2.new(0, 18, 0, 18)
    hueSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
    hueSelection.Position = UDim2.new(0.5, 0, 1 - h, 0)

    local rainbowBtn = Instance.new("TextButton")
    rainbowBtn.Parent = container
    rainbowBtn.BackgroundColor3 = self.theme.Element
    rainbowBtn.Size = UDim2.new(0, 80, 0, 26)
    rainbowBtn.Position = UDim2.new(0.5, -40, 0, 165)
    rainbowBtn.Text = "Rainbow"
    rainbowBtn.TextColor3 = self.theme.Text
    rainbowBtn.TextSize = 12
    addCorner(rainbowBtn, 8)
    addStroke(rainbowBtn, self.theme.StrokeColor)

    local function updateColorFromWheel(pos)
        local x = math.clamp((pos.X - colorWheel.AbsolutePosition.X) / colorWheel.AbsoluteSize.X, 0, 1)
        local y = math.clamp((pos.Y - colorWheel.AbsolutePosition.Y) / colorWheel.AbsoluteSize.Y, 0, 1)
        s = x
        v = 1 - y
        color = Color3.fromHSV(h, s, v)
        preview.BackgroundColor3 = color
        colorSelection.Position = UDim2.new(s, 0, 1 - v, 0)
        pcall(options.Callback, color)
        if self.configHandler then self.configHandler:Set(flag, {__type = "Color3", r = color.R, g = color.G, b = color.B}) end
    end

    local function updateHue(pos)
        local y = math.clamp((pos.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
        h = 1 - y
        color = Color3.fromHSV(h, s, v)
        preview.BackgroundColor3 = color
        colorWheel.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        hueSelection.Position = UDim2.new(0.5, 0, y, 0)
        pcall(options.Callback, color)
        if self.configHandler then self.configHandler:Set(flag, {__type = "Color3", r = color.R, g = color.G, b = color.B}) end
    end

    local function startRainbow()
        rainbowActive = true
        rainbowTask = task.spawn(function()
            local hue = 0
            while rainbowActive do
                hue = (hue + 0.01) % 1
                h, s, v = hue, 1, 1
                color = Color3.fromHSV(h, s, v)
                preview.BackgroundColor3 = color
                colorWheel.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                colorSelection.Position = UDim2.new(1, 0, 0, 0)
                hueSelection.Position = UDim2.new(0.5, 0, 1 - h, 0)
                pcall(options.Callback, color)
                if self.configHandler then self.configHandler:Set(flag, {__type = "Color3", r = color.R, g = color.G, b = color.B}) end
                task.wait(0.03)
            end
        end)
    end

    local function stopRainbow()
        rainbowActive = false
        if rainbowTask then task.cancel(rainbowTask) end
    end

    rainbowBtn.MouseButton1Click:Connect(function()
        if rainbowActive then
            stopRainbow()
            rainbowBtn.Text = "Rainbow"
        else
            startRainbow()
            rainbowBtn.Text = "Stop"
        end
    end)

    local draggingWheel = false
    colorWheel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingWheel = true
            updateColorFromWheel(input.Position)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingWheel and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateColorFromWheel(input.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and draggingWheel then
            draggingWheel = false
        end
    end)

    local draggingHue = false
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            updateHue(input.Position)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateHue(input.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and draggingHue then
            draggingHue = false
        end
    end)

    local isOpen = false
    local connection = btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        container.Visible = isOpen
        createTween(frame, 0.28, {Size = UDim2.new(1, 0, 0, isOpen and self.theme.ColorPickerExpandedHeight or self.theme.ColorPickerHeight)})
    end)

    local flagObj = {
        GetValue = function() return Color3.fromHSV(h, s, v) end,
        SetValue = function(_, newColor)
            if rainbowActive then stopRainbow() end
            local newH, newS, newV = Color3.toHSV(newColor)
            h, s, v = newH, newS, newV
            color = newColor
            preview.BackgroundColor3 = color
            colorWheel.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            colorSelection.Position = UDim2.new(s, 0, 1 - v, 0)
            hueSelection.Position = UDim2.new(0.5, 0, 1 - h, 0)
            pcall(options.Callback, color)
            if self.configHandler then self.configHandler:Set(flag, {__type = "Color3", r = color.R, g = color.G, b = color.B}) end
        end
    }
    self.controls[flag] = flagObj

    table.insert(self.createdControls, {type = "colorpicker", frame = frame, label = label, preview = preview, btn = btn, container = container, rainbowBtn = rainbowBtn})
    return flagObj, connection
end

function ControlFactory:createRadioGroup(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local selected
    if savedVal ~= nil and type(savedVal) == "string" and table.find(options.Options, savedVal) then
        selected = savedVal
    else
        selected = options.CurrentValue or options.Options[1] or ""
    end

    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, #options.Options * self.theme.RadioItemHeight + 16)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 6)
    label.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, 20)
    label.Font = self.theme.Font
    label.Text = options.Name
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left

    local radioButtons = {}

    for i, opt in ipairs(options.Options) do
        local row = Instance.new("Frame")
        row.Parent = frame
        row.BackgroundTransparency = 1
        row.Position = UDim2.new(0, 0, 0, 30 + (i-1) * self.theme.RadioItemHeight)
        row.Size = UDim2.new(1, 0, 0, self.theme.RadioItemHeight)

        local outer = Instance.new("Frame")
        outer.Parent = row
        outer.BackgroundColor3 = self.theme.ElementDark
        outer.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0.5, -10)
        outer.Size = UDim2.new(0, 20, 0, 20)
        addCorner(outer, 999)
        addStroke(outer, self.theme.StrokeColor)

        local inner = Instance.new("Frame")
        inner.Parent = outer
        inner.BackgroundColor3 = (opt == selected) and self.theme.Accent or Color3.fromRGB(60,60,60)
        inner.Position = UDim2.new(0.5, -6, 0.5, -6)
        inner.Size = UDim2.new(0, 12, 0, 12)
        addCorner(inner, 999)

        local optLabel = Instance.new("TextLabel")
        optLabel.Parent = row
        optLabel.BackgroundTransparency = 1
        optLabel.Position = UDim2.new(0, self.theme.PaddingHorizontal + 32, 0.5, -10)
        optLabel.Size = UDim2.new(1, -self.theme.PaddingHorizontal - 40, 0, 20)
        optLabel.Font = self.theme.Font
        optLabel.Text = opt
        optLabel.TextColor3 = self.theme.TextMuted
        optLabel.TextSize = self.theme.TextSizeSmall
        optLabel.TextXAlignment = Enum.TextXAlignment.Left

        local click = Instance.new("TextButton")
        click.Parent = row
        click.BackgroundTransparency = 1
        click.Size = UDim2.new(1, 0, 1, 0)
        click.Text = ""

        click.MouseButton1Click:Connect(function()
            if opt ~= selected then
                selected = opt
                for _, rb in ipairs(radioButtons) do
                    rb.Inner.BackgroundColor3 = (rb.Option == selected) and self.theme.Accent or Color3.fromRGB(60,60,60)
                end
                pcall(options.Callback, selected)
                if self.configHandler then self.configHandler:Set(flag, selected) end
            end
        end)

        table.insert(radioButtons, {Option = opt, Inner = inner})
    end

    local flagObj = {
        GetValue = function() return selected end,
        SetValue = function(_, v)
            if table.find(options.Options, v) then
                selected = v
                for _, rb in ipairs(radioButtons) do
                    rb.Inner.BackgroundColor3 = (rb.Option == selected) and self.theme.Accent or Color3.fromRGB(60,60,60)
                end
                pcall(options.Callback, selected)
                if self.configHandler then self.configHandler:Set(flag, selected) end
            end
        end
    }
    self.controls[flag] = flagObj

    table.insert(self.createdControls, {type = "radiogroup", frame = frame, label = label, radioButtons = radioButtons})
    return flagObj, nil
end

function ControlFactory:createParagraph(options)
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    title.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, 0)
    title.Font = self.theme.Font
    title.Text = options.Title or ""
    title.TextColor3 = self.theme.Accent
    title.TextSize = self.theme.TextSizeNormal
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextWrapped = true

    local imageContainer = nil
    local imageLabel = nil
    if options.Image and options.Image ~= "" then
        imageContainer = Instance.new("Frame")
        imageContainer.Parent = frame
        imageContainer.BackgroundTransparency = 1
        imageContainer.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + 0)
        imageContainer.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, 0)

        imageLabel = Instance.new("ImageLabel")
        imageLabel.Parent = imageContainer
        imageLabel.BackgroundColor3 = self.theme.ElementDark
        imageLabel.Size = UDim2.new(1, 0, 0, 120)
        imageLabel.Image = options.Image
        imageLabel.ScaleType = Enum.ScaleType.Fit
        addCorner(imageLabel, 8)
        addStroke(imageLabel, self.theme.StrokeColor, 1, 0.5)

        if options.ImageDescription and options.ImageDescription ~= "" then
            local imgDesc = Instance.new("TextLabel")
            imgDesc.Parent = imageContainer
            imgDesc.BackgroundTransparency = 1
            imgDesc.Position = UDim2.new(0, 0, 1, 4)
            imgDesc.Size = UDim2.new(1, 0, 0, 20)
            imgDesc.Font = self.theme.Font
            imgDesc.Text = options.ImageDescription
            imgDesc.TextColor3 = self.theme.TextMuted
            imgDesc.TextSize = self.theme.TextSizeSmall
            imgDesc.TextXAlignment = Enum.TextXAlignment.Center
            imgDesc.TextWrapped = true
        end
    end

    local content = Instance.new("TextLabel")
    content.Parent = frame
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + 0)
    content.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, 0)
    content.Font = self.theme.Font
    content.Text = options.Content or ""
    content.TextColor3 = self.theme.TextMuted
    content.TextSize = self.theme.TextSizeSmall
    content.TextWrapped = true
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top

    local function updateSize()
        if frame.AbsoluteSize.X <= 0 then return end
        local titleHeight = 0
        if options.Title and options.Title ~= "" then
            titleHeight = TextService:GetTextSize(options.Title, self.theme.TextSizeNormal, self.theme.Font, Vector2.new(frame.AbsoluteSize.X - 2 * self.theme.PaddingHorizontal, 9999)).Y
        end
        title.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, titleHeight)

        local imageHeight = 0
        local imageSpacing = 0
        if imageLabel then
            imageHeight = 120
            if options.ImageDescription and options.ImageDescription ~= "" then
                imageHeight = imageHeight + 24
            end
            imageContainer.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + titleHeight + (titleHeight > 0 and 8 or 0))
            imageContainer.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, imageHeight)
            imageSpacing = 12
        end

        local contentY = self.theme.PaddingVertical + titleHeight + (titleHeight > 0 and 8 or 0) + imageHeight + imageSpacing
        local contentHeight = TextService:GetTextSize(options.Content, self.theme.TextSizeSmall, self.theme.Font, Vector2.new(frame.AbsoluteSize.X - 2 * self.theme.PaddingHorizontal, 9999)).Y
        content.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, contentY)
        content.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, contentHeight)

        local totalHeight = contentY + contentHeight + self.theme.PaddingVertical
        frame.Size = UDim2.new(1, 0, 0, totalHeight)
    end

    frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
    task.defer(updateSize)
    table.insert(self.createdControls, {type = "paragraph", frame = frame, title = title, content = content, imageLabel = imageLabel})
    return frame
end

function ControlFactory:createImage(options)
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Font = self.theme.Font
    title.Text = options.Title or "Image"
    title.TextColor3 = self.theme.Text
    title.TextSize = self.theme.TextSizeNormal
    title.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel")
    arrow.Parent = frame
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -34, 0.5, -8)
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "v"
    arrow.TextColor3 = self.theme.TextMuted
    arrow.TextSize = 14

    local container = Instance.new("Frame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.Position = UDim2.new(0, 0, 0, 44)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Visible = false

    local image = Instance.new("ImageLabel")
    image.Parent = container
    image.BackgroundColor3 = self.theme.Element
    image.Size = UDim2.new(1, -20, 0, 120)
    image.Position = UDim2.new(0, 10, 0, 10)
    image.Image = options.Image or ""
    image.ScaleType = Enum.ScaleType.Fit
    addCorner(image, 8)

    if options.Description and options.Description ~= "" then
        local desc = Instance.new("TextLabel")
        desc.Parent = container
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, 10, 0, 140)
        desc.Size = UDim2.new(1, -20, 0, 30)
        desc.Font = self.theme.Font
        desc.Text = options.Description
        desc.TextColor3 = self.theme.TextMuted
        desc.TextSize = 12
        desc.TextWrapped = true
        container.Size = UDim2.new(1, 0, 0, 180)
    else
        container.Size = UDim2.new(1, 0, 0, 140)
    end

    local expanded = false
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""

    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, 44 + container.Size.Y.Offset)})
            container.Visible = true
            arrow.Text = "^"
        else
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, 44)})
            container.Visible = false
            arrow.Text = "v"
        end
    end)

    table.insert(self.createdControls, {type = "image", frame = frame, title = title, arrow = arrow, container = container})
    return frame
end

function ControlFactory:createVideo(options)
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, 0.82)

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Font = self.theme.Font
    title.Text = options.Title or "Video"
    title.TextColor3 = self.theme.Text
    title.TextSize = self.theme.TextSizeNormal
    title.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel")
    arrow.Parent = frame
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -34, 0.5, -8)
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "v"
    arrow.TextColor3 = self.theme.TextMuted
    arrow.TextSize = 14

    local container = Instance.new("Frame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.Position = UDim2.new(0, 0, 0, 44)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Visible = false

    local video = Instance.new("VideoFrame")
    video.Parent = container
    video.BackgroundColor3 = Color3.fromRGB(20,20,20)
    video.Size = UDim2.new(1, -20, 0, 150)
    video.Position = UDim2.new(0, 10, 0, 10)
    video.Video = options.Video or ""
    video.Looped = options.Looped or false
    video.Volume = options.Volume or 1
    addCorner(video, 8)

    local controlsFrame = Instance.new("Frame")
    controlsFrame.Parent = container
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Position = UDim2.new(0, 10, 0, 170)
    controlsFrame.Size = UDim2.new(1, -20, 0, 40)

    local playBtn = Instance.new("TextButton")
    playBtn.Parent = controlsFrame
    playBtn.BackgroundColor3 = self.theme.Element
    playBtn.Size = UDim2.new(0, 60, 0, 30)
    playBtn.Position = UDim2.new(0, 0, 0, 5)
    playBtn.Text = "Play"
    playBtn.TextColor3 = self.theme.Text
    playBtn.TextSize = 12
    addCorner(playBtn, 6)

    local pauseBtn = Instance.new("TextButton")
    pauseBtn.Parent = controlsFrame
    pauseBtn.BackgroundColor3 = self.theme.Element
    pauseBtn.Size = UDim2.new(0, 60, 0, 30)
    pauseBtn.Position = UDim2.new(0, 70, 0, 5)
    pauseBtn.Text = "Pause"
    pauseBtn.TextColor3 = self.theme.Text
    pauseBtn.TextSize = 12
    addCorner(pauseBtn, 6)

    playBtn.MouseButton1Click:Connect(function() video:Play() end)
    pauseBtn.MouseButton1Click:Connect(function() video:Pause() end)

    container.Size = UDim2.new(1, 0, 0, 220)

    local expanded = false
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""

    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, 44 + container.Size.Y.Offset)})
            container.Visible = true
            arrow.Text = "^"
        else
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, 44)})
            container.Visible = false
            arrow.Text = "v"
        end
    end)

    table.insert(self.createdControls, {type = "video", frame = frame, title = title, arrow = arrow, container = container})
    return frame
end

local Themes = {
    Rise = {
        Accent = Color3.fromRGB(0, 170, 255),
        Background = Color3.fromRGB(8, 8, 8),
        Sidebar = Color3.fromRGB(12, 12, 12),
        Element = Color3.fromRGB(18, 18, 18),
        ElementDark = Color3.fromRGB(13, 13, 13),
        Text = Color3.fromRGB(240,240,240),
        TextMuted = Color3.fromRGB(160,160,160),
        StrokeColor = Color3.fromRGB(35,35,35),
        HoverColor = Color3.fromRGB(26,26,26),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Dark = {
        Accent = Color3.fromRGB(100, 100, 255),
        Background = Color3.fromRGB(18, 18, 22),
        Sidebar = Color3.fromRGB(22, 22, 28),
        Element = Color3.fromRGB(28, 28, 34),
        ElementDark = Color3.fromRGB(20, 20, 24),
        Text = Color3.fromRGB(245,245,245),
        TextMuted = Color3.fromRGB(170,170,180),
        StrokeColor = Color3.fromRGB(45,45,55),
        HoverColor = Color3.fromRGB(38,38,46),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Cyberpunk = {
        Accent = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(10, 10, 20),
        Sidebar = Color3.fromRGB(15, 15, 30),
        Element = Color3.fromRGB(20, 20, 40),
        ElementDark = Color3.fromRGB(12, 12, 25),
        Text = Color3.fromRGB(0, 255, 255),
        TextMuted = Color3.fromRGB(150, 150, 200),
        StrokeColor = Color3.fromRGB(255, 0, 255),
        HoverColor = Color3.fromRGB(30, 30, 60),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 8,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    TokyoNight = {
        Accent = Color3.fromRGB(122, 162, 247),
        Background = Color3.fromRGB(26, 27, 38),
        Sidebar = Color3.fromRGB(31, 32, 45),
        Element = Color3.fromRGB(36, 37, 50),
        ElementDark = Color3.fromRGB(22, 23, 33),
        Text = Color3.fromRGB(169, 177, 214),
        TextMuted = Color3.fromRGB(133, 148, 186),
        StrokeColor = Color3.fromRGB(86, 95, 137),
        HoverColor = Color3.fromRGB(53, 55, 77),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Red = {
        Accent = Color3.fromRGB(255, 60, 80),
        Background = Color3.fromRGB(20, 15, 15),
        Sidebar = Color3.fromRGB(25, 18, 18),
        Element = Color3.fromRGB(35, 25, 25),
        ElementDark = Color3.fromRGB(25, 18, 18),
        Text = Color3.fromRGB(255, 240, 240),
        TextMuted = Color3.fromRGB(200, 180, 180),
        StrokeColor = Color3.fromRGB(100, 40, 50),
        HoverColor = Color3.fromRGB(45, 30, 30),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    BloodRed = {
        Accent = Color3.fromRGB(255, 0, 0),
        Background = Color3.fromRGB(15, 8, 8),
        Sidebar = Color3.fromRGB(20, 12, 12),
        Element = Color3.fromRGB(30, 18, 18),
        ElementDark = Color3.fromRGB(15, 10, 10),
        Text = Color3.fromRGB(255, 80, 80),
        TextMuted = Color3.fromRGB(220, 180, 180),
        StrokeColor = Color3.fromRGB(120, 30, 30),
        HoverColor = Color3.fromRGB(50, 20, 20),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    White = {
        Accent = Color3.fromRGB(0, 122, 255),
        Background = Color3.fromRGB(255, 255, 255),
        Sidebar = Color3.fromRGB(245, 245, 250),
        Element = Color3.fromRGB(250, 250, 255),
        ElementDark = Color3.fromRGB(240, 240, 245),
        Text = Color3.fromRGB(50, 50, 60),
        TextMuted = Color3.fromRGB(100, 100, 110),
        StrokeColor = Color3.fromRGB(200, 200, 210),
        HoverColor = Color3.fromRGB(230, 235, 240),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Ubuntu = {
        Accent = Color3.fromRGB(233, 84, 32),
        Background = Color3.fromRGB(48, 10, 36),
        Sidebar = Color3.fromRGB(56, 14, 42),
        Element = Color3.fromRGB(64, 18, 48),
        ElementDark = Color3.fromRGB(40, 10, 30),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(200, 180, 190),
        StrokeColor = Color3.fromRGB(172, 45, 130),
        HoverColor = Color3.fromRGB(70, 25, 50),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Glacier = {
        Accent = Color3.fromRGB(0, 191, 255),
        Background = Color3.fromRGB(240, 248, 255),
        Sidebar = Color3.fromRGB(230, 245, 255),
        Element = Color3.fromRGB(245, 252, 255),
        ElementDark = Color3.fromRGB(225, 245, 255),
        Text = Color3.fromRGB(25, 55, 75),
        TextMuted = Color3.fromRGB(70, 110, 130),
        StrokeColor = Color3.fromRGB(176, 196, 222),
        HoverColor = Color3.fromRGB(210, 230, 245),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Midnight = {
        Accent = Color3.fromRGB(147, 112, 219),
        Background = Color3.fromRGB(10, 10, 25),
        Sidebar = Color3.fromRGB(15, 15, 35),
        Element = Color3.fromRGB(20, 20, 45),
        ElementDark = Color3.fromRGB(10, 10, 25),
        Text = Color3.fromRGB(180, 200, 255),
        TextMuted = Color3.fromRGB(150, 150, 190),
        StrokeColor = Color3.fromRGB(75, 0, 130),
        HoverColor = Color3.fromRGB(35, 35, 60),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Anime = {
        Accent = Color3.fromRGB(255, 105, 180),
        Background = Color3.fromRGB(255, 240, 245),
        Sidebar = Color3.fromRGB(255, 228, 235),
        Element = Color3.fromRGB(255, 245, 250),
        ElementDark = Color3.fromRGB(255, 235, 245),
        Text = Color3.fromRGB(139, 69, 101),
        TextMuted = Color3.fromRGB(180, 130, 150),
        StrokeColor = Color3.fromRGB(255, 182, 193),
        HoverColor = Color3.fromRGB(255, 230, 240),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Femboy = {
        Accent = Color3.fromRGB(255, 105, 180),
        Background = Color3.fromRGB(255, 245, 250),
        Sidebar = Color3.fromRGB(255, 240, 245),
        Element = Color3.fromRGB(255, 250, 252),
        ElementDark = Color3.fromRGB(255, 240, 245),
        Text = Color3.fromRGB(219, 112, 147),
        TextMuted = Color3.fromRGB(180, 120, 140),
        StrokeColor = Color3.fromRGB(255, 182, 193),
        HoverColor = Color3.fromRGB(255, 235, 245),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Hanki = {
        Accent = Color3.fromRGB(255, 140, 0),
        Background = Color3.fromRGB(25, 50, 80),
        Sidebar = Color3.fromRGB(30, 60, 95),
        Element = Color3.fromRGB(35, 65, 100),
        ElementDark = Color3.fromRGB(20, 40, 65),
        Text = Color3.fromRGB(255, 180, 80),
        TextMuted = Color3.fromRGB(255, 160, 60),
        StrokeColor = Color3.fromRGB(255, 140, 0),
        HoverColor = Color3.fromRGB(40, 70, 110),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Ocean = {
        Accent = Color3.fromRGB(0, 180, 255),
        Background = Color3.fromRGB(15, 30, 50),
        Sidebar = Color3.fromRGB(20, 38, 60),
        Element = Color3.fromRGB(25, 43, 66),
        ElementDark = Color3.fromRGB(18, 33, 55),
        Text = Color3.fromRGB(220, 245, 255),
        TextMuted = Color3.fromRGB(160, 200, 230),
        StrokeColor = Color3.fromRGB(0, 140, 200),
        HoverColor = Color3.fromRGB(30, 50, 70),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Forest = {
        Accent = Color3.fromRGB(100, 255, 120),
        Background = Color3.fromRGB(20, 32, 24),
        Sidebar = Color3.fromRGB(25, 40, 28),
        Element = Color3.fromRGB(28, 45, 32),
        ElementDark = Color3.fromRGB(22, 35, 26),
        Text = Color3.fromRGB(210, 255, 220),
        TextMuted = Color3.fromRGB(170, 220, 180),
        StrokeColor = Color3.fromRGB(80, 180, 100),
        HoverColor = Color3.fromRGB(35, 55, 40),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
    Sunset = {
        Accent = Color3.fromRGB(255, 130, 90),
        Background = Color3.fromRGB(30, 20, 30),
        Sidebar = Color3.fromRGB(40, 28, 38),
        Element = Color3.fromRGB(45, 32, 43),
        ElementDark = Color3.fromRGB(35, 24, 33),
        Text = Color3.fromRGB(255, 220, 200),
        TextMuted = Color3.fromRGB(230, 180, 190),
        StrokeColor = Color3.fromRGB(200, 100, 120),
        HoverColor = Color3.fromRGB(60, 40, 50),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 24,
        ButtonHeight = 42,
        ToggleHeight = 34,
        ToggleWidth = 50,
        SliderHeight = 52,
        SliderBarHeight = 8,
        DropdownHeight = 42,
        DropdownItemHeight = 32,
        ChecklistHeight = 42,
        ChecklistItemHeight = 32,
        TextInputHeight = 76,
        TextInputFieldHeight = 34,
        KeybindHeight = 42,
        KeybindWidth = 72,
        ColorPickerHeight = 42,
        ColorPickerPreviewSize = 26,
        ColorPickerExpandedHeight = 200,
        RadioItemHeight = 34,
    },
}

local ConfigHandler = {}
ConfigHandler.__index = ConfigHandler

function ConfigHandler.new(configName)
    local self = setmetatable({}, ConfigHandler)
    self.configName = configName
    self.data = loadConfigFromFile(configName) or {}
    self.pendingSave = false
    return self
end

function ConfigHandler:Get(key)
    return self.data[key]
end

function ConfigHandler:Set(key, value)
    self.data[key] = value
    self:ScheduleSave()
end

function ConfigHandler:ScheduleSave()
    if self.pendingSave then return end
    self.pendingSave = true
    task.defer(function()
        self.pendingSave = false
        saveConfigToFile(self.configName, self.data)
    end)
end

function ConfigHandler:GetAll()
    return self.data
end

function SynergyUI:CreateWindow(options)
    options = options or {}

    if type(options.Theme) ~= "string" or not Themes[options.Theme] then
        options.Theme = "Rise"
    end

    local window = {
        Flags = {},
        Tabs = {},
        Connections = {},
        CurrentTab = nil,
        Theme = Themes[options.Theme],
        ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift,
        IsVisible = true,
        IsMinimized = false,
        OnClose = options.OnClose,
        ConfigName = options.ConfigName or "default_config",
        ConfigHandler = nil,
        AllControls = {}
    }

    if type(window.ToggleKey) == "string" and window.ToggleKey ~= "None" then
        local keyEnum = Enum.KeyCode[window.ToggleKey]
        if keyEnum then
            window.ToggleKey = keyEnum
        else
            window.ToggleKey = Enum.KeyCode.RightShift
        end
    elseif window.ToggleKey == "None" then
        window.ToggleKey = nil
    end

    if options.AccentColor then
        window.Theme.Accent = options.AccentColor
    end

    local configHandler = ConfigHandler.new(window.ConfigName)
    window.ConfigHandler = configHandler
    local savedConfig = configHandler:GetAll()

    if savedConfig.__position then
        savedConfig.__position = nil
        configHandler:ScheduleSave()
    end

    if savedConfig.__theme and Themes[savedConfig.__theme] then
        window.Theme = Themes[savedConfig.__theme]
        if options.AccentColor then window.Theme.Accent = options.AccentColor end
    end

    local strokeThickness = 2
    local gui = Instance.new("ScreenGui")
    gui.Name = "SynergyUI_" .. HttpService:GenerateGUID(false)
    gui.Parent = options.Parent or getDefaultParent()
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    window.Gui = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = gui
    mainFrame.BackgroundColor3 = window.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    addCorner(mainFrame, window.Theme.CornerRadius)
    addStroke(mainFrame, window.Theme.Accent, strokeThickness, 0.4)
    window.MainFrame = mainFrame

    if savedConfig.__size then
        local s = savedConfig.__size
        local w = math.clamp(s.xo or 560, 460, 1200)
        local h = math.clamp(s.yo or 380, 280, 820)
        mainFrame.Size = UDim2.new(0, w, 0, h)
    else
        mainFrame.Size = UDim2.new(0, 560, 0, 380)
    end

    mainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Parent = mainFrame
    topBar.BackgroundColor3 = window.Theme.Sidebar
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 42)
    addCorner(topBar, window.Theme.CornerRadius)
    topBar.ZIndex = 10

    local topBarSep = Instance.new("Frame")
    topBarSep.Parent = topBar
    topBarSep.BackgroundColor3 = window.Theme.StrokeColor
    topBarSep.BorderSizePixel = 0
    topBarSep.Position = UDim2.new(0, 0, 1, -1)
    topBarSep.Size = UDim2.new(1, 0, 0, 1)
    topBarSep.ZIndex = 10

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = topBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, window.Theme.PaddingHorizontal, 0, 0)
    titleLabel.Size = UDim2.new(0, 240, 1, 0)
    titleLabel.Font = window.Theme.Font
    titleLabel.Text = options.Title or "Synergy Hub"
    titleLabel.TextColor3 = window.Theme.Accent
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 10

    local controlContainer = Instance.new("Frame")
    controlContainer.Parent = topBar
    controlContainer.BackgroundTransparency = 1
    controlContainer.Position = UDim2.new(1, -88, 0, 0)
    controlContainer.Size = UDim2.new(0, 88, 1, 0)
    controlContainer.ZIndex = 10

    local minBtn = Instance.new("TextButton")
    minBtn.Parent = controlContainer
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    minBtn.BackgroundTransparency = 0.72
    minBtn.Position = UDim2.new(0, 14, 0.5, -10)
    minBtn.Size = UDim2.new(0, 20, 0, 20)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 210, 120)
    minBtn.TextSize = 16
    minBtn.ZIndex = 10
    addCorner(minBtn, 999)
    addHoverEffect(minBtn, minBtn.BackgroundColor3, Color3.fromRGB(255, 200, 100), false)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = controlContainer
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    closeBtn.BackgroundTransparency = 0.72
    closeBtn.Position = UDim2.new(0, 50, 0.5, -10)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 160, 160)
    closeBtn.TextSize = 11
    closeBtn.ZIndex = 10
    addCorner(closeBtn, 999)
    addHoverEffect(closeBtn, closeBtn.BackgroundColor3, Color3.fromRGB(255, 120, 120), false)

    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainFrame
    sidebar.BackgroundColor3 = window.Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Position = UDim2.new(0, 0, 0, 42)
    sidebar.Size = UDim2.new(0, 150, 1, -42 - strokeThickness)
    sidebar.ZIndex = 5
    sidebar.ScrollBarThickness = 3
    sidebar.ScrollBarImageColor3 = window.Theme.Accent
    sidebar.ScrollBarImageTransparency = 0.5
    sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
    sidebar.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    sidebar.ClipsDescendants = true
    addCorner(sidebar, window.Theme.CornerRadius)

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = sidebar
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 2)

    local sidebarPad = Instance.new("UIPadding")
    sidebarPad.Parent = sidebar
    sidebarPad.PaddingTop = UDim.new(0, 6)
    sidebarPad.PaddingBottom = UDim.new(0, 6)

    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 12)
    end)

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Parent = mainFrame
    contentArea.BackgroundColor3 = window.Theme.Background
    contentArea.BorderSizePixel = 0
    contentArea.Position = UDim2.new(0, 150, 0, 42)
    contentArea.Size = UDim2.new(1, -150 - strokeThickness, 1, -42 - strokeThickness)
    contentArea.ZIndex = 1
    addCorner(contentArea, window.Theme.CornerRadius)
    contentArea.ClipsDescendants = true

    local function addConnection(conn)
        table.insert(window.Connections, conn)
        return conn
    end

    local resizeHandle = Instance.new("Frame")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Parent = gui
    resizeHandle.BackgroundColor3 = window.Theme.Accent
    resizeHandle.BackgroundTransparency = 0.45
    resizeHandle.BorderSizePixel = 0
    resizeHandle.Size = UDim2.new(0, 5, 0, 54)
    resizeHandle.ZIndex = 150
    addCorner(resizeHandle, 999)

    window.resizeHandle = resizeHandle

    local function syncResizeHandle()
        local ap = mainFrame.AbsolutePosition
        local as = mainFrame.AbsoluteSize
        resizeHandle.Position = UDim2.new(0, ap.X + as.X + 18, 0, ap.Y + as.Y / 2 - 27)
    end

    addConnection(mainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncResizeHandle))
    addConnection(mainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncResizeHandle))
    task.defer(syncResizeHandle)

    addConnection(resizeHandle.MouseEnter:Connect(function()
        createTween(resizeHandle, 0.18, {BackgroundTransparency = 0.1, Size = UDim2.new(0, 7, 0, 54)})
    end))
    addConnection(resizeHandle.MouseLeave:Connect(function()
        createTween(resizeHandle, 0.18, {BackgroundTransparency = 0.45, Size = UDim2.new(0, 5, 0, 54)})
    end))

    local dragging = false
    local dragStart, startPos
    addConnection(topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end))

    addConnection(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))

    addConnection(UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end))

    local resizing = false
    local resizeStart, startSize
    addConnection(resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = mainFrame.Size
        end
    end))

    addConnection(UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X.Offset + delta.X, 460, 1200)
            local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 280, 820)
            mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end))

    addConnection(UserInputService.InputEnded:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            resizing = false
            configHandler:Set("__size", {xo = mainFrame.Size.X.Offset, yo = mainFrame.Size.Y.Offset})
        end
    end))

    addConnection(minBtn.MouseButton1Click:Connect(function()
        window.IsMinimized = not window.IsMinimized
        if window.IsMinimized then
            createTween(mainFrame, 0.35, {Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 42)})
            sidebar.Visible = false
            contentArea.Visible = false
            resizeHandle.Visible = false
        else
            createTween(mainFrame, 0.35, {Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 380)})
            sidebar.Visible = true
            contentArea.Visible = true
            resizeHandle.Visible = true
        end
        configHandler:Set("__minimized", window.IsMinimized)
    end))

    addConnection(closeBtn.MouseButton1Click:Connect(function()
        window:Destroy()
        if window.OnClose then pcall(window.OnClose) end
    end))

    addConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and not _anyKeybindBinding and window.ToggleKey and input.KeyCode == window.ToggleKey then
            window.IsVisible = not window.IsVisible
            gui.Enabled = window.IsVisible
        end
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape and options.CloseOnEscape then
            window:Destroy()
        end
    end))

    if savedConfig.__minimized then
        window.IsMinimized = true
        mainFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 42)
        sidebar.Visible = false
        contentArea.Visible = false
        resizeHandle.Visible = false
    end

    window.SetToggleKey = function(keyName)
        if keyName == "None" then
            window.ToggleKey = nil
        else
            local keyEnum = Enum.KeyCode[keyName]
            if keyEnum then
                window.ToggleKey = keyEnum
            end
        end
    end

    local iconMap = {}
    if options.IconSet then
        local baseUrl = "https://raw.githubusercontent.com/Synergy-Team-Official/SynergyUI-Lib/refs/heads/main/Icons/"
        local iconUrl = baseUrl .. options.IconSet .. "/dist/Icons.lua"
        local iconData = nil
        if request then
            local s, r = pcall(function() return request({Url = iconUrl, Method = "GET"}).Body end)
            if s then iconData = r end
        end
        if iconData then
            local loadFunc = loadstring(iconData)
            if loadFunc then
                local loadedMap = loadFunc()
                if type(loadedMap) == "table" then
                    iconMap = loadedMap
                end
            end
        end
    end

    function window:RefreshTheme()
        local newTheme = self.Theme
        self.MainFrame.BackgroundColor3 = newTheme.Background
        local stroke = self.MainFrame:FindFirstChild("UIStroke")
        if stroke then stroke.Color = newTheme.Accent end
        self.MainFrame:FindFirstChild("TopBar").BackgroundColor3 = newTheme.Sidebar
        self.MainFrame:FindFirstChild("TopBar"):FindFirstChild("TextLabel").TextColor3 = newTheme.Accent
        self.MainFrame:FindFirstChild("Sidebar").BackgroundColor3 = newTheme.Sidebar
        self.MainFrame:FindFirstChild("Sidebar").ScrollBarImageColor3 = newTheme.Accent
        self.MainFrame:FindFirstChild("ContentArea").BackgroundColor3 = newTheme.Background
        self.resizeHandle.BackgroundColor3 = newTheme.Accent

        for _, tab in ipairs(self.Tabs) do
            tab.Content.BackgroundColor3 = newTheme.Background
            tab.Content.ScrollBarImageColor3 = newTheme.Accent
            tab.Button.BackgroundColor3 = newTheme.Sidebar
            local tabLabel = tab.Button:FindFirstChild("TabLabel")
            if tabLabel then
                tabLabel.TextColor3 = (tab.Content.Visible) and newTheme.Accent or newTheme.TextMuted
            end
            if tab.ActiveIndicator then
                tab.ActiveIndicator.BackgroundColor3 = newTheme.Accent
                tab.ActiveIndicator.Visible = tab.Content.Visible
            end
            local img = tab.Button:FindFirstChild("ImageLabel")
            if img then
                img.ImageColor3 = tab.Content.Visible and newTheme.Accent or newTheme.TextMuted
            end

            for _, control in ipairs(tab.Controls) do
                if control.type == "label" then
                    control.instance.TextColor3 = newTheme.Text
                elseif control.type == "section" then
                    control.instance.TextColor3 = newTheme.Accent
                    control.instance.Font = newTheme.Font
                elseif control.type == "separator" then
                    control.instance.BackgroundColor3 = newTheme.StrokeColor
                elseif control.type == "button" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    local strokeBtn = control.frame:FindFirstChild("UIStroke")
                    if strokeBtn then strokeBtn.Color = newTheme.StrokeColor end
                    control.btn.TextColor3 = newTheme.Text
                elseif control.type == "toggle" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.label.TextColor3 = control.stateVar and newTheme.Accent or newTheme.Text
                    control.outer.BackgroundColor3 = newTheme.ElementDark
                    control.inner.BackgroundColor3 = control.stateVar and newTheme.Accent or newTheme.TextMuted
                elseif control.type == "checkbox" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.label.TextColor3 = control.stateVar and newTheme.Accent or newTheme.Text
                    control.checkFrame.BackgroundColor3 = newTheme.ElementDark
                    control.checkIcon.ImageColor3 = newTheme.Accent
                elseif control.type == "slider" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.label.TextColor3 = newTheme.Text
                    control.valLabel.TextColor3 = newTheme.Accent
                    control.bg.BackgroundColor3 = newTheme.ElementDark
                    control.fill.BackgroundColor3 = newTheme.Accent
                    if control.fillGradient then
                        control.fillGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, newTheme.Accent),
                            ColorSequenceKeypoint.new(1, newTheme.Accent:lerp(Color3.fromRGB(255,255,255), 0.3))
                        })
                    end
                    control.thumb.BackgroundColor3 = newTheme.Accent
                    control.tooltip.BackgroundColor3 = newTheme.ElementDark
                    local tooltipStroke = control.tooltip:FindFirstChild("UIStroke")
                    if tooltipStroke then tooltipStroke.Color = newTheme.Accent end
                    control.tooltipLabel.TextColor3 = newTheme.Text
                    control.inputBg.BackgroundColor3 = newTheme.ElementDark
                    control.numInput.TextColor3 = newTheme.Text
                elseif control.type == "dropdown" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.btn.TextColor3 = newTheme.Text
                    control.icon.TextColor3 = newTheme.TextMuted
                    control.container.BackgroundColor3 = newTheme.ElementDark
                    control.container.ScrollBarImageColor3 = newTheme.Accent
                elseif control.type == "checklist" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.btn.TextColor3 = newTheme.Text
                    control.countLabel.TextColor3 = newTheme.Accent
                    control.icon.TextColor3 = newTheme.TextMuted
                    control.container.BackgroundColor3 = newTheme.ElementDark
                    control.container.ScrollBarImageColor3 = newTheme.Accent
                elseif control.type == "textinput" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.label.TextColor3 = newTheme.Text
                    control.input.BackgroundColor3 = newTheme.ElementDark
                    control.input.TextColor3 = newTheme.Text
                    control.input.PlaceholderColor3 = newTheme.TextMuted
                elseif control.type == "numberinput" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.label.TextColor3 = newTheme.Text
                    control.input.BackgroundColor3 = newTheme.ElementDark
                    control.input.TextColor3 = newTheme.Text
                elseif control.type == "keybind" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.label.TextColor3 = newTheme.Text
                    control.bindBtn.BackgroundColor3 = newTheme.ElementDark
                    control.bindBtn.TextColor3 = newTheme.Accent
                elseif control.type == "colorpicker" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.label.TextColor3 = newTheme.Text
                    control.container.BackgroundColor3 = newTheme.ElementDark
                    control.rainbowBtn.BackgroundColor3 = newTheme.Element
                    control.rainbowBtn.TextColor3 = newTheme.Text
                elseif control.type == "radiogroup" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.label.TextColor3 = newTheme.Text
                    for _, rb in ipairs(control.radioButtons) do
                        local outer = rb.Inner.Parent
                        outer.BackgroundColor3 = newTheme.ElementDark
                        local optLabel = outer.Parent:FindFirstChildWhichIsA("TextLabel")
                        if optLabel then optLabel.TextColor3 = newTheme.TextMuted end
                    end
                elseif control.type == "paragraph" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.title.TextColor3 = newTheme.Accent
                    control.content.TextColor3 = newTheme.TextMuted
                    if control.imageLabel then
                        local strokeImg = control.imageLabel:FindFirstChild("UIStroke")
                        if strokeImg then strokeImg.Color = newTheme.StrokeColor end
                    end
                elseif control.type == "image" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.title.TextColor3 = newTheme.Text
                    control.arrow.TextColor3 = newTheme.TextMuted
                    if control.container then
                        control.container.BackgroundColor3 = newTheme.ElementDark
                    end
                elseif control.type == "video" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.title.TextColor3 = newTheme.Text
                    control.arrow.TextColor3 = newTheme.TextMuted
                    if control.container then
                        control.container.BackgroundColor3 = newTheme.ElementDark
                    end
                end
            end
        end
    end

    function window:SetAccent(color)
        window.Theme.Accent = color
        mainFrame:FindFirstChild("UIStroke").Color = color
        titleLabel.TextColor3 = color
        resizeHandle.BackgroundColor3 = color
        sidebar.ScrollBarImageColor3 = color
        for _, tab in ipairs(window.Tabs) do
            local lbl = tab.Button:FindFirstChild("TabLabel")
            if lbl then
                if lbl.TextColor3 ~= window.Theme.TextMuted then lbl.TextColor3 = color end
            else
                if tab.Button.TextColor3 ~= window.Theme.TextMuted then tab.Button.TextColor3 = color end
            end
            if tab.ActiveIndicator then tab.ActiveIndicator.BackgroundColor3 = color end
        end
        window:RefreshTheme()
    end

    function window:SetTheme(themeName)
        if Themes[themeName] then
            local newTheme = Themes[themeName]
            for k, v in pairs(newTheme) do
                window.Theme[k] = v
            end
            window:RefreshTheme()
            configHandler:Set("__theme", themeName)
        end
    end

    function window:Destroy()
        for _, conn in ipairs(window.Connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        gui:Destroy()
    end

    function window:CreateTab(name, icon)
        local iconAsset = icon
        if type(icon) == "string" and not icon:match("^rbxasset") and not icon:match("^http") then
            iconAsset = iconMap[icon] or ""
        end

        local tabBtn = Instance.new("TextButton")
        tabBtn.Parent = sidebar
        tabBtn.BackgroundColor3 = window.Theme.Sidebar
        tabBtn.BorderSizePixel = 0
        tabBtn.Size = UDim2.new(1, 0, 0, 42)
        tabBtn.Text = ""
        tabBtn.Position = UDim2.new(0, window.Theme.PaddingHorizontal + 10, 0, 0)

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "TabLabel"
        tabLabel.Parent = tabBtn
        tabLabel.BackgroundTransparency = 1
        tabLabel.Size = UDim2.new(1, 0, 1, 0)
        tabLabel.Font = window.Theme.Font
        tabLabel.TextColor3 = window.Theme.TextMuted
        tabLabel.TextSize = 14
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Text = name

        local activeIndicator = Instance.new("Frame")
        activeIndicator.Parent = tabBtn
        activeIndicator.BackgroundColor3 = window.Theme.Accent
        activeIndicator.BorderSizePixel = 0
        activeIndicator.Position = UDim2.new(0, -window.Theme.PaddingHorizontal - 10, 0.15, 0)
        activeIndicator.Size = UDim2.new(0, 3, 0.7, 0)
        activeIndicator.Visible = false
        addCorner(activeIndicator, 999)

        if iconAsset and iconAsset ~= "" then
            local iconLabel = Instance.new("ImageLabel")
            iconLabel.Parent = tabBtn
            iconLabel.BackgroundTransparency = 1
            iconLabel.Position = UDim2.new(0, 16, 0.5, -10)
            iconLabel.Size = UDim2.new(0, 20, 0, 20)
            iconLabel.Image = iconAsset
            iconLabel.ImageColor3 = window.Theme.TextMuted
            tabLabel.Position = UDim2.new(0, 46, 0, 0)
            tabLabel.Size = UDim2.new(1, -46, 1, 0)
        else
            tabLabel.TextXAlignment = Enum.TextXAlignment.Center
            tabLabel.Position = UDim2.new(0, 0, 0, 0)
            tabBtn.Position = UDim2.new(0, 0, 0, 0)
            activeIndicator.Position = UDim2.new(0, 0, 0.15, 0)
        end

        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Parent = contentArea
        scrollFrame.Active = true
        scrollFrame.BackgroundColor3 = window.Theme.Background
        scrollFrame.BorderSizePixel = 0
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.ScrollBarThickness = 5
        scrollFrame.ScrollBarImageColor3 = window.Theme.Accent
        scrollFrame.Visible = (#window.Tabs == 0)
        scrollFrame.ZIndex = 1

        local layout = Instance.new("UIListLayout")
        layout.Parent = scrollFrame
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, window.Theme.PaddingVertical)

        local padding = Instance.new("UIPadding")
        padding.Parent = scrollFrame
        padding.PaddingLeft = UDim.new(0, window.Theme.PaddingHorizontal)
        padding.PaddingRight = UDim.new(0, window.Theme.PaddingHorizontal + 6)
        padding.PaddingTop = UDim.new(0, window.Theme.PaddingVertical)
        padding.PaddingBottom = UDim.new(0, window.Theme.PaddingVertical)

        addConnection(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + window.Theme.PaddingVertical * 2)
        end))

        local tabData = {Button = tabBtn, Content = scrollFrame, ActiveIndicator = activeIndicator, Controls = {}}
        table.insert(window.Tabs, tabData)

        if #window.Tabs == 1 then
            local lbl = tabBtn:FindFirstChild("TabLabel")
            if lbl then lbl.TextColor3 = window.Theme.Accent end
            tabBtn.TextColor3 = window.Theme.Accent
            activeIndicator.Visible = true
            if iconAsset and iconAsset ~= "" then
                local img = tabBtn:FindFirstChild("ImageLabel")
                if img then img.ImageColor3 = window.Theme.Accent end
            end
            window.CurrentTab = scrollFrame
        end

        addConnection(tabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(window.Tabs) do
                local tlbl = t.Button:FindFirstChild("TabLabel")
                if tlbl then tlbl.TextColor3 = window.Theme.TextMuted end
                t.Button.TextColor3 = window.Theme.TextMuted
                t.Content.Visible = false
                if t.ActiveIndicator then t.ActiveIndicator.Visible = false end
                local img = t.Button:FindFirstChild("ImageLabel")
                if img then img.ImageColor3 = window.Theme.TextMuted end
            end
            local lbl = tabBtn:FindFirstChild("TabLabel")
            if lbl then lbl.TextColor3 = window.Theme.Accent end
            tabBtn.TextColor3 = window.Theme.Accent
            activeIndicator.Visible = true
            scrollFrame.Visible = true
            window.CurrentTab = scrollFrame
            local img = tabBtn:FindFirstChild("ImageLabel")
            if img then img.ImageColor3 = window.Theme.Accent end
        end))

        local elements = {}
        local controlFactory = ControlFactory:new(scrollFrame, window.Theme, window.SetAccent, configHandler)
        controlFactory.controls = window.Flags
        controlFactory.connections = window.Connections

        local originalCreateKeybind = controlFactory.createKeybind
        controlFactory.createKeybind = function(self, opts)
            if opts.Flag == "Keybind" then
                local originalCallback = opts.Callback
                opts.Callback = function(v)
                    if originalCallback then pcall(originalCallback, v) end
                    window.SetToggleKey(v)
                end
            end
            local flagObj, conns = originalCreateKeybind(self, opts)
            if opts.Flag == "Keybind" then
                local currentVal = flagObj.GetValue()
                window.SetToggleKey(currentVal)
            end
            return flagObj, conns
        end

        elements.CreateLabel = function(_, text) local lbl = controlFactory:createLabel(text); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return lbl end
        elements.CreateSeparator = function() local sep = controlFactory:createSeparator(); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return sep end
        elements.CreateButton = function(_, opts) local btn,conn = controlFactory:createButton(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return btn,conn end
        elements.CreateToggle = function(_, opts) local tog,conn = controlFactory:createToggle(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return tog,conn end
        elements.CreateCheckBox = function(_, opts) local chk,conn = controlFactory:createCheckBox(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return chk,conn end
        elements.CreateSlider = function(_, opts) local sld,conn = controlFactory:createSlider(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return sld,conn end
        elements.CreateDropdown = function(_, opts) local drp,conn = controlFactory:createDropdown(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return drp,conn end
        elements.CreateChecklist = function(_, opts) local chk,conn = controlFactory:createChecklist(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return chk,conn end
        elements.CreateTextInput = function(_, opts) local txt,conn = controlFactory:createTextInput(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return txt,conn end
        elements.CreateNumberInput = function(_, opts) local num,conn = controlFactory:createNumberInput(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return num,conn end
        elements.CreateKeybind = function(_, opts) local key,conn = controlFactory:createKeybind(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return key,conn end
        elements.CreateColorPicker = function(_, opts) local col,conn = controlFactory:createColorPicker(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return col,conn end
        elements.CreateRadioGroup = function(_, opts) local rad,conn = controlFactory:createRadioGroup(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return rad,conn end
        elements.CreateParagraph = function(_, opts) local para = controlFactory:createParagraph(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return para end
        elements.CreateImage = function(_, opts) local img = controlFactory:createImage(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return img end
        elements.CreateVideo = function(_, opts) local vid = controlFactory:createVideo(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return vid end

        function elements:CreateSection(name)
            local section = Instance.new("TextLabel")
            section.Parent = scrollFrame
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(1, 0, 0, 28)
            section.Font = window.Theme.Font
            section.Text = name
            section.TextColor3 = window.Theme.Accent
            section.TextSize = 15
            section.TextXAlignment = Enum.TextXAlignment.Left
            section.TextYAlignment = Enum.TextYAlignment.Center
            table.insert(tabData.Controls, {type = "section", instance = section})
            return section
        end

        return elements
    end

    return window
end

return SynergyUI
