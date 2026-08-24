local SynergyUI = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local _anyKeybindBinding = false
local localizationState = {
    Language = "en",
    FallbackLanguage = "en",
    Translations = {
        en = {
            Accept = "Accept",
            Cancel = "Cancel",
            Search = "Search...",
            Select = "Select",
            None = "None",
            Selected = "selected",
            Progress = "Progress",
            Alert = "Alert",
            Confirm = "Confirm",
            Prompt = "Prompt",
            Continue = "Continue",
            Close = "Close",
            Copy = "Copy",
            Copied = "Copied",
            Loading = "Loading",
            Rainbow = "Rainbow",
            Stop = "Stop",
            Play = "Play",
            Pause = "Pause",
            Image = "Image",
            Video = "Video",
            Notification = "Notification",
        },
    },
    Objects = {},
    Windows = {},
}

local function localizedValue(value)
    if type(value) ~= "string" then
        return value
    end
    if value:sub(1, 1) ~= "@" then
        return value
    end
    local key = value:sub(2)
    local language = localizationState.Translations[localizationState.Language]
    local fallback = localizationState.Translations[localizationState.FallbackLanguage]
    return (language and language[key]) or (fallback and fallback[key]) or key
end

local function registerLocalizedObject(object, property, resolver)
    if not object or type(resolver) ~= "function" then
        return
    end
    localizationState.Objects[object] = {
        Object = object,
        Property = property,
        Resolver = resolver,
    }
    object[property] = resolver()
end

local function bindLocalizedText(object, property, value)
    if type(value) == "table" and value.Key then
        value = value.Key
    end
    if type(value) == "string" and value:sub(1, 1) == "@" then
        registerLocalizedObject(object, property, function()
            return localizedValue(value)
        end)
    else
        object[property] = value
    end
end

local function bindLocalizedResolver(object, property, resolver)
    registerLocalizedObject(object, property, resolver)
end

local function updateLocalization()
    for object, data in pairs(localizationState.Objects) do
        if object and object.Parent ~= nil then
            local ok, value = pcall(data.Resolver)
            if ok then
                object[data.Property] = value
            end
        else
            localizationState.Objects[object] = nil
        end
    end
end

local function cloneTable(value)
    if type(value) ~= "table" then
        return value
    end
    local result = {}
    for key, child in pairs(value) do
        result[key] = cloneTable(child)
    end
    return result
end

local function normalizeAssetId(value)
    if type(value) == "number" then
        return "rbxassetid://" .. tostring(value)
    end
    if type(value) == "string" then
        if value:match("^%d+$") then
            return "rbxassetid://" .. value
        end
        if value:match("^rbxassetid://%d+$") then
            return value
        end
    end
    return nil
end

function SynergyUI:AddTranslations(language, translations)
    if type(language) ~= "string" or type(translations) ~= "table" then
        return false
    end
    localizationState.Translations[language] = localizationState.Translations[language] or {}
    for key, value in pairs(translations) do
        localizationState.Translations[language][key] = value
    end
    updateLocalization()
    return true
end

function SynergyUI:SetLanguage(language)
    if type(language) ~= "string" then
        return false
    end
    localizationState.Language = language
    updateLocalization()
    for _, window in ipairs(localizationState.Windows) do
        if window and window.UpdateTitleLayout then
            window.UpdateTitleLayout()
        end
    end
    return true
end

function SynergyUI:GetLanguage()
    return localizationState.Language
end

function SynergyUI:GetTranslations()
    return localizationState.Translations
end

function SynergyUI:Localization(config)
    if type(config) ~= "table" then
        return false
    end
    if type(config.FallbackLanguage) == "string" then
        localizationState.FallbackLanguage = config.FallbackLanguage
    end
    if type(config.Translations) == "table" then
        for language, translations in pairs(config.Translations) do
            self:AddTranslations(language, translations)
        end
    end
    if type(config.Language) == "string" then
        self:SetLanguage(config.Language)
    end
    return true
end

function SynergyUI:Locations(config)
    return self:Localization(config)
end

SynergyUI.Localize = function(value)
    return localizedValue(value)
end
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
local ConnectionBag = {}
ConnectionBag.__index = ConnectionBag
function ConnectionBag.new()
    return setmetatable({Items = {}, Closed = false}, ConnectionBag)
end
function ConnectionBag:Add(item)
    if item and not self.Closed then
        table.insert(self.Items, item)
    end
    return item
end
function ConnectionBag:AddConnection(connection)
    return self:Add(connection)
end
function ConnectionBag:AddCleanup(cleanup)
    return self:Add(cleanup)
end
function ConnectionBag:Cleanup()
    if self.Closed then return end
    self.Closed = true
    for index = #self.Items, 1, -1 do
        local item = self.Items[index]
        if type(item) == "function" then
            pcall(item)
        elseif item and type(item.Disconnect) == "function" then
            pcall(function() item:Disconnect() end)
        elseif item and type(item.Destroy) == "function" then
            pcall(function() item:Destroy() end)
        end
    end
    self.Items = {}
end

local OverlayHandle = {}
OverlayHandle.__index = OverlayHandle
function OverlayHandle:SetContent(content)
    if self.Content and self.Content ~= content then
        self.Content.Parent = nil
    end
    self.Content = content
    if content then
        content.Parent = self.Frame
        content.Position = UDim2.new(0, 0, 0, 0)
        content.Size = UDim2.new(1, 0, 1, 0)
        content.Visible = true
    end
    return self
end
function OverlayHandle:GetSize()
    local width = self.Width
    local height = self.Height
    if self.WidthProvider then
        local ok, value = pcall(self.WidthProvider)
        if ok and tonumber(value) then width = tonumber(value) end
    end
    if self.HeightProvider then
        local ok, value = pcall(self.HeightProvider)
        if ok and tonumber(value) then height = tonumber(value) end
    end
    width = math.max(self.MinWidth, math.floor(width or self.MinWidth))
    height = math.max(self.MinHeight, math.floor(height or self.MinHeight))
    if self.MaxWidth then width = math.min(width, self.MaxWidth) end
    if self.MaxHeight then height = math.min(height, self.MaxHeight) end
    return width, height
end
function OverlayHandle:UpdatePosition()
    if self.Destroyed or not self.Anchor or not self.Anchor.Parent or not self.Frame.Parent then return end
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    local width, height = self:GetSize()
    local padding = self.Padding
    local anchorPosition = self.Anchor.AbsolutePosition
    local anchorSize = self.Anchor.AbsoluteSize
    local x = math.clamp(anchorPosition.X, padding, math.max(padding, viewport.X - width - padding))
    local spaceBelow = viewport.Y - (anchorPosition.Y + anchorSize.Y) - padding
    local spaceAbove = anchorPosition.Y - padding
    local y
    if spaceBelow >= height or spaceBelow >= spaceAbove then
        y = anchorPosition.Y + anchorSize.Y + padding
    else
        y = anchorPosition.Y - height - padding
    end
    y = math.clamp(y, padding, math.max(padding, viewport.Y - height - padding))
    self.Frame.Position = UDim2.fromOffset(x, y)
    self.Frame.Size = UDim2.fromOffset(width, height)
end
function OverlayHandle:Open()
    if self.Destroyed then return self end
    self.Manager:CloseOthers(self)
    self:UpdatePosition()
    self.Opened = true
    self.Frame.Visible = true
    if self.OnOpen then pcall(self.OnOpen, self) end
    return self
end
function OverlayHandle:Close()
    if self.Destroyed then return self end
    local wasOpen = self.Opened
    self.Opened = false
    self.Frame.Visible = false
    if wasOpen and self.OnClose then pcall(self.OnClose, self) end
    return self
end
function OverlayHandle:Destroy()
    if self.Destroyed then return end
    self:Close()
    self.Destroyed = true
    if self.Frame then self.Frame:Destroy() end
    for index = #self.Manager.Handles, 1, -1 do
        if self.Manager.Handles[index] == self then
            table.remove(self.Manager.Handles, index)
            break
        end
    end
end

local OverlayManager = {}
OverlayManager.__index = OverlayManager
function OverlayManager.new(parent, resourceBag)
    local self = setmetatable({Handles = {}, ResourceBag = resourceBag, Destroyed = false}, OverlayManager)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SynergyOverlays_" .. HttpService:GenerateGUID(false)
    gui.Parent = parent or getDefaultParent()
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.Gui = gui
    if resourceBag then
        resourceBag:AddCleanup(function() self:Destroy() end)
    end
    self:Track(UserInputService.InputBegan:Connect(function(input)
        if self.Destroyed then return end
        local point = input.Position
        if input.KeyCode == Enum.KeyCode.Escape then
            self:CloseAll()
            return
        end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        for _, handle in ipairs(self.Handles) do
            if handle.Opened and handle.CloseOnOutsideClick then
                local insideOverlay = point.X >= handle.Frame.AbsolutePosition.X and point.X <= handle.Frame.AbsolutePosition.X + handle.Frame.AbsoluteSize.X and point.Y >= handle.Frame.AbsolutePosition.Y and point.Y <= handle.Frame.AbsolutePosition.Y + handle.Frame.AbsoluteSize.Y
                local insideAnchor = handle.Anchor and point.X >= handle.Anchor.AbsolutePosition.X and point.X <= handle.Anchor.AbsolutePosition.X + handle.Anchor.AbsoluteSize.X and point.Y >= handle.Anchor.AbsolutePosition.Y and point.Y <= handle.Anchor.AbsolutePosition.Y + handle.Anchor.AbsoluteSize.Y
                if not insideOverlay and not insideAnchor then
                    handle:Close()
                end
            end
        end
    end))
    return self
end
function OverlayManager:Track(connection)
    if self.ResourceBag then self.ResourceBag:AddConnection(connection) end
    return connection
end
function OverlayManager:Create(config)
    config = config or {}
    local handle = setmetatable({
        Manager = self,
        Kind = config.Kind or "Overlay",
        Anchor = config.Anchor,
        Width = config.Width or 220,
        Height = config.Height or 180,
        MinWidth = config.MinWidth or 120,
        MaxWidth = config.MaxWidth,
        MinHeight = config.MinHeight or 24,
        MaxHeight = config.MaxHeight or 400,
        WidthProvider = config.WidthProvider,
        HeightProvider = config.HeightProvider,
        Padding = config.Padding or 8,
        CloseOnOutsideClick = config.CloseOnOutsideClick ~= false,
        Exclusive = config.Exclusive ~= false,
        OnOpen = config.OnOpen,
        OnClose = config.OnClose,
        Opened = false,
        Destroyed = false,
    }, OverlayHandle)
    local frame = Instance.new("Frame")
    frame.Name = config.Name or "Overlay"
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = config.ZIndex or 500
    frame.Parent = self.Gui
    handle.Frame = frame
    table.insert(self.Handles, handle)
    if handle.Anchor then
        self:Track(handle.Anchor:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if handle.Opened then handle:UpdatePosition() end
        end))
        self:Track(handle.Anchor:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if handle.Opened then handle:UpdatePosition() end
        end))
    end
    return handle
end
function OverlayManager:CloseOthers(active)
    if not active.Exclusive then return end
    for _, handle in ipairs(self.Handles) do
        if handle ~= active and handle.Opened and handle.Kind == active.Kind then
            handle:Close()
        end
    end
end
function OverlayManager:CloseAll()
    for _, handle in ipairs(self.Handles) do
        if handle.Opened then handle:Close() end
    end
end
function OverlayManager:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    for index = #self.Handles, 1, -1 do
        self.Handles[index]:Destroy()
    end
    self.Handles = {}
    if self.Gui then self.Gui:Destroy() end
end

local function addHoverEffect(button, originalColor, hoverColor, useScale, connectionBag)
    local scale = nil
    if useScale then
        scale = Instance.new("UIScale")
        scale.Scale = 1
        scale.Parent = button
    end
    local enterConnection = button.MouseEnter:Connect(function()
        createTween(button, 0.18, {BackgroundColor3 = hoverColor})
        if scale then createTween(scale, 0.18, {Scale = 1.04}) end
    end)
    local leaveConnection = button.MouseLeave:Connect(function()
        createTween(button, 0.18, {BackgroundColor3 = originalColor})
        if scale then createTween(scale, 0.18, {Scale = 1}) end
    end)
    if connectionBag then
        connectionBag:AddConnection(enterConnection)
        connectionBag:AddConnection(leaveConnection)
    end
end
local function createChevron(parent, color)
    local holder = Instance.new("Frame")
    holder.Name = "Chevron"
    holder.Parent = parent
    holder.BackgroundTransparency = 1
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Position = UDim2.new(1, -24, 0.5, 0)
    holder.Size = UDim2.new(0, 20, 0, 20)
    holder.Rotation = 0
    local left = Instance.new("Frame")
    left.Name = "Left"
    left.Parent = holder
    left.AnchorPoint = Vector2.new(0.5, 0.5)
    left.BackgroundColor3 = color
    left.BackgroundTransparency = 0
    left.BorderSizePixel = 0
    left.Position = UDim2.new(0.5, -4, 0.5, -1)
    left.Rotation = 45
    left.Size = UDim2.new(0, 9, 0, 2)
    addCorner(left, 2)
    local right = Instance.new("Frame")
    right.Name = "Right"
    right.Parent = holder
    right.AnchorPoint = Vector2.new(0.5, 0.5)
    right.BackgroundColor3 = color
    right.BackgroundTransparency = 0
    right.BorderSizePixel = 0
    right.Position = UDim2.new(0.5, 4, 0.5, -1)
    right.Rotation = -45
    right.Size = UDim2.new(0, 9, 0, 2)
    addCorner(right, 2)
    return holder
end
local function setChevronColor(chevron, color)
    local left = chevron:FindFirstChild("Left")
    local right = chevron:FindFirstChild("Right")
    if left then left.BackgroundColor3 = color end
    if right then right.BackgroundColor3 = color end
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
        done = "rbxassetid://85262178816537",
        error = "rbxassetid://76821953846248",
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
    options = options or {}
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
    bindLocalizedText(titleLabel, "Text", options.Title or "@Notification")
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
    bindLocalizedText(miniTitle, "Text", options.MiniTitle or "")
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
    bindLocalizedText(descLabel, "Text", options.Description or "")
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
    bindLocalizedText(yesBtn, "Text", options.YesText or "@Accept")
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
    bindLocalizedText(noBtn, "Text", options.NoText or "@Cancel")
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
local function createDialog(options)
    options = options or {}
    local dialogType = options.Type or "confirm"
    local owner = options.OwnerWindow
    local parent = options.Parent or (owner and owner.Gui and owner.Gui.Parent) or getDefaultParent()
    local gui = Instance.new("ScreenGui")
    gui.Name = "SynergyDialog_" .. HttpService:GenerateGUID(false)
    gui.Parent = parent
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    local shade = Instance.new("Frame")
    shade.Parent = gui
    shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shade.BackgroundTransparency = 0.42
    shade.BorderSizePixel = 0
    shade.Size = UDim2.new(1, 0, 1, 0)
    shade.ZIndex = 200
    local card = Instance.new("Frame")
    card.Parent = shade
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 12)
    card.Size = UDim2.new(0, 390, 0, dialogType == "prompt" and 238 or 202)
    card.BackgroundColor3 = options.BackgroundColor or Color3.fromRGB(16, 16, 18)
    card.BorderSizePixel = 0
    card.ZIndex = 201
    addCorner(card, 16)
    addStroke(card, options.AccentColor or Color3.fromRGB(0, 170, 255), 1, 0.35)
    local accent = Instance.new("Frame")
    accent.Parent = card
    accent.BackgroundColor3 = options.AccentColor or Color3.fromRGB(0, 170, 255)
    accent.BorderSizePixel = 0
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.Size = UDim2.new(1, 0, 0, 3)
    accent.ZIndex = 202
    addCorner(accent, 16)
    local title = Instance.new("TextLabel")
    title.Parent = card
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 22, 0, 22)
    title.Size = UDim2.new(1, -44, 0, 26)
    title.Font = Enum.Font.GothamBold
    bindLocalizedText(title, "Text", options.Title or (dialogType == "alert" and "@Alert" or dialogType == "prompt" and "@Prompt" or "@Confirm"))
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.TextSize = 17
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 202
    local content = Instance.new("TextLabel")
    content.Parent = card
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 22, 0, 55)
    content.Size = UDim2.new(1, -44, 0, dialogType == "prompt" and 42 or 74)
    content.Font = Enum.Font.Gotham
    bindLocalizedText(content, "Text", options.Content or options.Description or "")
    content.TextColor3 = Color3.fromRGB(190, 190, 195)
    content.TextSize = 13
    content.TextWrapped = true
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.ZIndex = 202
    local input
    if dialogType == "prompt" then
        input = Instance.new("TextBox")
        input.Parent = card
        input.BackgroundColor3 = Color3.fromRGB(27, 27, 30)
        input.BackgroundTransparency = 0
        input.BorderSizePixel = 0
        input.Position = UDim2.new(0, 22, 0, 105)
        input.Size = UDim2.new(1, -44, 0, 38)
        input.ClearTextOnFocus = false
        input.Font = Enum.Font.Gotham
        input.Text = tostring(options.DefaultText or "")
        input.PlaceholderText = tostring(options.Placeholder or "")
        input.PlaceholderColor3 = Color3.fromRGB(120, 120, 125)
        input.TextColor3 = Color3.fromRGB(235, 235, 238)
        input.TextSize = 13
        input.TextXAlignment = Enum.TextXAlignment.Left
        input.ZIndex = 202
        addCorner(input, 9)
        local inputPadding = Instance.new("UIPadding")
        inputPadding.Parent = input
        inputPadding.PaddingLeft = UDim.new(0, 10)
        inputPadding.PaddingRight = UDim.new(0, 10)
        addStroke(input, Color3.fromRGB(55, 55, 60), 1, 0.45)
    end
    local buttonRow = Instance.new("Frame")
    buttonRow.Parent = card
    buttonRow.BackgroundTransparency = 1
    buttonRow.Position = UDim2.new(0, 22, 1, -58)
    buttonRow.Size = UDim2.new(1, -44, 0, 38)
    buttonRow.ZIndex = 202
    local layout = Instance.new("UIListLayout")
    layout.Parent = buttonRow
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = dialogType == "alert" and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 9)
    local secondary
    if dialogType ~= "alert" then
        secondary = Instance.new("TextButton")
        secondary.Parent = buttonRow
        secondary.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
        secondary.BorderSizePixel = 0
        secondary.Size = UDim2.new(0, 108, 0, 36)
        secondary.Font = Enum.Font.GothamMedium
        bindLocalizedText(secondary, "Text", options.CancelText or "@Cancel")
        secondary.TextColor3 = Color3.fromRGB(205, 205, 210)
        secondary.TextSize = 13
        secondary.ZIndex = 203
        addCorner(secondary, 9)
        addStroke(secondary, Color3.fromRGB(70, 70, 76), 1, 0.5)
    end
    local primary = Instance.new("TextButton")
    primary.Parent = buttonRow
    primary.BackgroundColor3 = options.AccentColor or Color3.fromRGB(0, 170, 255)
    primary.BorderSizePixel = 0
    primary.Size = UDim2.new(0, dialogType == "alert" and 112 or 108, 0, 36)
    primary.Font = Enum.Font.GothamBold
    bindLocalizedText(primary, "Text", options.ConfirmText or options.OkText or (dialogType == "prompt" and "@Continue" or "@Accept"))
    primary.TextColor3 = Color3.fromRGB(255, 255, 255)
    primary.TextSize = 13
    primary.ZIndex = 203
    addCorner(primary, 9)
    local dialogConnections = {}
    local dialog = {
        Gui = gui,
        Input = input,
        Closed = false,
        Connections = dialogConnections,
    }
    if owner and owner.Dialogs then
        table.insert(owner.Dialogs, dialog)
    end
    local function removeFromOwner()
        if not owner or not owner.Dialogs then
            return
        end
        for index = #owner.Dialogs, 1, -1 do
            if owner.Dialogs[index] == dialog then
                table.remove(owner.Dialogs, index)
                break
            end
        end
    end
    local function invoke(callback, ...)
        if type(callback) == "function" then
            pcall(callback, ...)
        end
    end
    local function close(result, invokeCallback)
        if dialog.Closed then
            return
        end
        dialog.Closed = true
        if invokeCallback then
            if dialogType == "confirm" then
                if result and options.ConfirmCallback then
                    invoke(options.ConfirmCallback, dialog)
                elseif not result and options.CancelCallback then
                    invoke(options.CancelCallback, dialog)
                end
            elseif dialogType == "prompt" then
                invoke(options.Callback, result, dialog)
            else
                invoke(options.Callback, dialog)
            end
            if dialogType == "confirm" then
                invoke(options.Callback, result, dialog)
            end
        end
        for _, connection in ipairs(dialogConnections) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
        removeFromOwner()
        createTween(card, 0.2, {Position = UDim2.new(0.5, 0, 0.5, 10), BackgroundTransparency = 1})
        createTween(shade, 0.2, {BackgroundTransparency = 1})
        task.delay(0.22, function()
            if gui then
                gui:Destroy()
            end
        end)
    end
    function dialog:Close(result)
        close(result, true)
    end
    function dialog:Destroy()
        if dialog.Closed then
            return
        end
        dialog.Closed = true
        for _, connection in ipairs(dialogConnections) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
        removeFromOwner()
        if gui then
            gui:Destroy()
        end
    end
    table.insert(dialogConnections, primary.MouseButton1Click:Connect(function()
        if dialogType == "prompt" then
            close(input and input.Text or "", true)
        elseif dialogType == "confirm" then
            close(true, true)
        else
            close(true, true)
        end
    end))
    if secondary then
        table.insert(dialogConnections, secondary.MouseButton1Click:Connect(function()
            if dialogType == "prompt" then
                close(nil, true)
            else
                close(false, true)
            end
        end))
    end
    table.insert(dialogConnections, shade.InputBegan:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and options.CloseOnOverlay ~= false then
            close(false, true)
        end
    end))
    table.insert(dialogConnections, UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
        if not gameProcessed and inputObject.KeyCode == Enum.KeyCode.Escape and options.CloseOnEscape ~= false and not dialog.Closed then
            close(false, true)
        end
    end))
    createTween(card, 0.28, {Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0})
    createTween(shade, 0.22, {BackgroundTransparency = 0.42})
    if input then
        task.defer(function()
            if input.Parent then
                input:CaptureFocus()
            end
        end)
    end
    return dialog
end

function SynergyUI:Alert(options)
    if type(options) == "string" then
        options = {Content = options}
    end
    options = options or {}
    options.Type = "alert"
    return createDialog(options)
end

function SynergyUI:Confirm(options)
    if type(options) == "string" then
        options = {Content = options}
    end
    options = options or {}
    options.Type = "confirm"
    return createDialog(options)
end

function SynergyUI:Prompt(options)
    if type(options) == "string" then
        options = {Content = options}
    end
    options = options or {}
    options.Type = "prompt"
    return createDialog(options)
end

local ControlFactory = {}
function ControlFactory:new(parent, theme, updateThemeCallback, configHandler, overlayManager, connectionBag)
    local obj = {}
    obj.parent = parent
    obj.theme = theme
    obj.updateTheme = updateThemeCallback
    obj.controls = {}
    obj.connections = {}
    obj.configHandler = configHandler
    obj.createdControls = {}
    obj.overlayManager = overlayManager
    obj.connectionBag = connectionBag
    setmetatable(obj, { __index = ControlFactory })
    return obj
end
function ControlFactory:track(item)
    if type(item) == "table" then
        for _, value in ipairs(item) do self:track(value) end
        return item
    end
    if item then
        if self.connections then table.insert(self.connections, item) end
        if self.connectionBag then self.connectionBag:AddConnection(item) end
    end
    return item
end
function ControlFactory:createLabel(text)
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.LabelHeight)
    addCorner(frame, self.theme.CornerRadius)
    local stroke = addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local accent = Instance.new("Frame")
    accent.Parent = frame
    accent.BackgroundColor3 = self.theme.Accent
    accent.BorderSizePixel = 0
    accent.AnchorPoint = Vector2.new(0, 0.5)
    accent.Position = UDim2.new(0, self.theme.PaddingHorizontal / 2, 0.5, 0)
    accent.Size = UDim2.new(0, 3, 0, self.theme.LabelHeight - 20)
    addCorner(accent, 999)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal + 8, 0, 0)
    label.Size = UDim2.new(1, -(self.theme.PaddingHorizontal * 2 + 8), 1, 0)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", text)
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(self.createdControls, {type = "label", frame = frame, instance = label, stroke = stroke, accent = accent})
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
function ControlFactory:createProgressBar(options)
    options = options or {}
    local flag = options.Flag or options.Name or "Progress"
    local range = options.Range
    local minValue = tonumber(options.Min or (range and range[1])) or 0
    local maxValue = tonumber(options.Max or (range and range[2])) or 100
    if maxValue <= minValue then
        maxValue = minValue + 1
    end
    local savedValue = self.configHandler and self.configHandler:Get(flag)
    local value = tonumber(savedValue) or tonumber(options.CurrentValue) or minValue
    value = math.clamp(value, minValue, maxValue)
    local height = self.theme.ProgressBarHeight or 54
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.BorderSizePixel = 0
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    label.Size = UDim2.new(0.62, 0, 0, self.theme.TextSizeNormal + 4)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name or "@Progress")
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0.62, 0, 0, self.theme.PaddingVertical)
    valueLabel.Size = UDim2.new(0.38, -self.theme.PaddingHorizontal, 0, self.theme.TextSizeNormal + 4)
    valueLabel.Font = self.theme.Font
    valueLabel.TextColor3 = self.theme.Accent
    valueLabel.TextSize = self.theme.TextSizeSmall
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    local barBg = Instance.new("Frame")
    barBg.Parent = frame
    barBg.BackgroundColor3 = self.theme.ElementDark
    barBg.BackgroundTransparency = self.theme.ElementDarkTransparency
    barBg.Position = UDim2.new(0, self.theme.PaddingHorizontal, 1, -self.theme.PaddingVertical - 10)
    barBg.Size = UDim2.new(1, -self.theme.PaddingHorizontal * 2, 0, 8)
    barBg.BorderSizePixel = 0
    addCorner(barBg, 4)
    local barStroke = addStroke(barBg, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local fill = Instance.new("Frame")
    fill.Parent = barBg
    fill.BackgroundColor3 = self.theme.Accent
    fill.BorderSizePixel = 0
    addCorner(fill, 4)
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.theme.Accent),
        ColorSequenceKeypoint.new(1, self.theme.Accent:lerp(Color3.fromRGB(255,255,255), 0.25)),
    })
    fillGradient.Parent = fill
    local function formatValue(current)
        if type(options.Format) == "function" then
            local ok, result = pcall(options.Format, current, (current - minValue) / (maxValue - minValue))
            if ok and result ~= nil then
                return tostring(result)
            end
        end
        if options.ShowPercentage then
            return tostring(math.floor(((current - minValue) / (maxValue - minValue)) * 100 + 0.5)) .. "%"
        end
        return tostring(current)
    end
    local function applyValue(current, fireCallback)
        current = tonumber(current) or minValue
        current = math.clamp(current, minValue, maxValue)
        value = current
        local ratio = (value - minValue) / (maxValue - minValue)
        valueLabel.Text = options.ShowValue == false and "" or formatValue(value)
        createTween(fill, 0.18, {Size = UDim2.new(ratio, 0, 1, 0)})
        if fireCallback then
            pcall(options.Callback, value, ratio)
            if self.configHandler then
                self.configHandler:Set(flag, value)
            end
        end
    end
    applyValue(value, false)
    local flagObj = {
        Frame = frame,
        GetValue = function() return value end,
        GetPercentage = function() return (value - minValue) / (maxValue - minValue) end,
        SetValue = function(_, newValue) applyValue(newValue, true) end,
        SetProgress = function(_, newValue) applyValue(newValue, true) end,
    }
    self.controls[flag] = flagObj
    table.insert(self.createdControls, {
        type = "progressbar",
        frame = frame,
        label = label,
        valueLabel = valueLabel,
        barBg = barBg,
        barStroke = barStroke,
        fill = fill,
        fillGradient = fillGradient,
    })
    return flagObj
end

function ControlFactory:createButton(options)
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.ButtonHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Font = self.theme.Font
    bindLocalizedText(btn, "Text", options.Name)
    btn.TextColor3 = self.theme.Text
    btn.TextSize = self.theme.TextSizeNormal
    addHoverEffect(btn, self.theme.Element, self.theme.HoverColor, true, self.connectionBag)
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
        tooltip.BackgroundTransparency = self.theme.ElementDarkTransparency
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
        bindLocalizedText(tipLabel, "Text", options.Tooltip)
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
        self:track(show)
        self:track(hide)
    end
    table.insert(self.createdControls, {type = "button", frame = frame, btn = btn, tooltip = options.Tooltip})
    return frame, connection
end
function ControlFactory:createToggle(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local state
    if savedVal ~= nil and type(savedVal) == "boolean" then
        state = savedVal
    elseif options.CurrentValue ~= nil then
        state = options.CurrentValue
    else
        state = false
    end
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.ToggleHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name)
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left
    local outer = Instance.new("Frame")
    outer.Parent = frame
    outer.BackgroundColor3 = self.theme.ElementDark
    outer.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    table.insert(self.createdControls, {type = "toggle", frame = frame, label = label, outer = outer, inner = inner, btn = btn, getState = function() return state end, update = update})
    return frame, connection
end
function ControlFactory:createCheckBox(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local state
    if savedVal ~= nil and type(savedVal) == "boolean" then
        state = savedVal
    elseif options.CurrentValue ~= nil then
        state = options.CurrentValue
    else
        state = false
    end
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.ToggleHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name)
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left
    local checkFrame = Instance.new("Frame")
    checkFrame.Parent = frame
    checkFrame.BackgroundColor3 = self.theme.ElementDark
    checkFrame.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    table.insert(self.createdControls, {type = "checkbox", frame = frame, label = label, checkFrame = checkFrame, checkIcon = checkIcon, btn = btn, getState = function() return state end})
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
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.SliderHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    label.Size = UDim2.new(0.65, 0, 0, self.theme.TextSizeNormal + 4)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name)
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
    bg.BackgroundTransparency = self.theme.ElementDarkTransparency
    bg.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + self.theme.TextSizeNormal + 8)
    bg.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal - 130, 0, self.theme.SliderBarHeight)
    addCorner(bg, self.theme.SliderBarHeight / 2)
    addStroke(bg, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
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
    tooltip.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    inputBg.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    self:track(numInput:GetPropertyChangedSignal("Text"):Connect(function()
        numInput.Text = numInput.Text:gsub("[^%d%.%-]", "")
    end))
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
        if type(savedVal) == "table" then
            for _, v in ipairs(savedVal) do
                if table.find(optionsList, v) then
                    selected[v] = true
                end
            end
        elseif type(options.CurrentSelected) == "table" then
            for _, v in ipairs(options.CurrentSelected) do
                if table.find(optionsList, v) then
                    selected[v] = true
                end
            end
        end
    else
        if type(savedVal) == "string" and table.find(optionsList, savedVal) then
            selected = savedVal
        elseif options.CurrentOption and table.find(optionsList, options.CurrentOption) then
            selected = options.CurrentOption
        else
            selected = optionsList[1] or ""
        end
    end
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.DropdownHeight)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, self.theme.DropdownHeight)
    btn.Font = self.theme.Font
    btn.Text = ""
    btn.TextColor3 = self.theme.Text
    btn.TextSize = self.theme.TextSizeNormal
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    local icon = createChevron(btn, self.theme.TextMuted)
    local container = Instance.new("ScrollingFrame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.BackgroundTransparency = self.theme.ElementDarkTransparency
    container.BorderSizePixel = 0
    container.Position = UDim2.new(0, 0, 0, self.theme.DropdownHeight)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = self.theme.Accent
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    addCorner(container, self.theme.CornerRadius)
    addStroke(container, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    if searchable then
        local searchBox = Instance.new("TextBox")
        searchBox.Parent = container
        searchBox.BackgroundColor3 = self.theme.Element
        searchBox.BackgroundTransparency = self.theme.ElementTransparency
        searchBox.Size = UDim2.new(1, -12, 0, 28)
        searchBox.Position = UDim2.new(0, 6, 0, 4)
        searchBox.Font = self.theme.Font
        bindLocalizedText(searchBox, "PlaceholderText", "@Search")
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
    local flagObj
    local dropdownOverlay
    local function getButtonText()
        if multi then
            local count = 0
            for _,v in pairs(selected) do if v then count = count + 1 end end
            return localizedValue(options.Name) .. " : " .. count .. " " .. localizedValue("@Selected")
        end
        return localizedValue(options.Name) .. " : " .. (selected == "" and localizedValue("@None") or localizedValue(selected))
    end
    local function updateButtonText()
        btn.Text = getButtonText()
    end
    bindLocalizedResolver(btn, "Text", getButtonText)
    local function rebuild(filter)
        for _, b in ipairs(optionButtons) do if b and b.Parent then b:Destroy() end end
        optionButtons = {}
        for _, opt in ipairs(optionsList) do
            if not filter or string.find(string.lower(opt), string.lower(filter)) then
                local optFrame = Instance.new("Frame")
                optFrame.Parent = container
                optFrame.BackgroundColor3 = self.theme.ElementDark
                optFrame.BackgroundTransparency = self.theme.ElementDarkTransparency
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
                self:track(optBtn.MouseButton1Click:Connect(function()
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
                        if dropdownOverlay then
                            dropdownOverlay:Close()
                        else
                            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, self.theme.DropdownHeight)})
                            container.Size = UDim2.new(1, 0, 0, 0)
                        end
                        createTween(icon, 0.18, {Rotation = 0})
                        pcall(options.Callback, opt)
                        if self.configHandler then self.configHandler:Set(flag, selected) end
                    end
                end))
                table.insert(optionButtons, optBtn)
            end
        end
        container.CanvasSize = UDim2.new(0, 0, 0, #optionButtons * self.theme.DropdownItemHeight + (searchable and 40 or 8))
    end
    rebuild()
    if searchable then
        local searchBox = container:FindFirstChildWhichIsA("TextBox")
        if searchBox then
            self:track(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                rebuild(searchBox.Text)
            end))
        end
    end
    if self.overlayManager then
        dropdownOverlay = self.overlayManager:Create({
            Name = "DropdownOverlay",
            Kind = "Dropdown",
            Anchor = btn,
            Width = 220,
            MaxHeight = 200,
            HeightProvider = function()
                return math.min(#optionButtons * self.theme.DropdownItemHeight + (searchable and 40 or 8), 200)
            end,
            OnClose = function()
                isOpen = false
                createTween(icon, 0.18, {Rotation = 0})
            end,
        })
        dropdownOverlay:SetContent(container)
    end
    local connection = btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local expandedHeight = math.min(#optionsList * self.theme.DropdownItemHeight + (searchable and 40 or 8), 200)
            local targetHeight = self.theme.DropdownHeight + expandedHeight
            if dropdownOverlay then
                dropdownOverlay:Open()
            else
                createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, targetHeight)})
                container.Size = UDim2.new(1, 0, 0, expandedHeight)
            end
            createTween(icon, 0.18, {Rotation = 180})
        else
            if dropdownOverlay then
                dropdownOverlay:Close()
            else
                createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, self.theme.DropdownHeight)})
                container.Size = UDim2.new(1, 0, 0, 0)
            end
            createTween(icon, 0.18, {Rotation = 0})
        end
    end)
    flagObj = {
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
    if options.Callback then
        if multi then
            local hasSelected = false
            for _, v in pairs(selected) do
                if v then hasSelected = true; break end
            end
            if hasSelected then
                pcall(options.Callback, flagObj:GetValue())
            end
        else
            if selected ~= "" then
                pcall(options.Callback, selected)
            end
        end
    end
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
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.ChecklistHeight)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, self.theme.ChecklistHeight)
    btn.Font = self.theme.Font
    bindLocalizedText(btn, "Text", options.Name)
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
    countLabel.Text = ""
    countLabel.TextColor3 = self.theme.Accent
    countLabel.TextSize = self.theme.TextSizeSmall
    countLabel.TextXAlignment = Enum.TextXAlignment.Right
    local icon = createChevron(btn, self.theme.TextMuted)
    local container = Instance.new("ScrollingFrame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    local function getSelectedCountText()
        local count = 0
        for _, v in pairs(selected) do if v then count = count + 1 end end
        return count .. " " .. localizedValue("@Selected")
    end
    local function updateSelectedCount()
        countLabel.Text = getSelectedCountText()
        pcall(options.Callback, selected)
        if self.configHandler then self.configHandler:Set(flag, getSelectedValues()) end
    end
    bindLocalizedResolver(countLabel, "Text", getSelectedCountText)
    local function rebuild()
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        for _, opt in ipairs(optionsList) do
            local row = Instance.new("Frame")
            row.Parent = container
            row.BackgroundColor3 = self.theme.ElementDark
            row.BackgroundTransparency = self.theme.ElementDarkTransparency
            row.BorderSizePixel = 0
            row.Size = UDim2.new(1, 0, 0, self.theme.ChecklistItemHeight)
            local toggleOuter = Instance.new("Frame")
            toggleOuter.Parent = row
            toggleOuter.BackgroundColor3 = self.theme.Element
            toggleOuter.BackgroundTransparency = self.theme.ElementTransparency
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
            createTween(icon, 0.18, {Rotation = 180})
        else
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, self.theme.ChecklistHeight)})
            container.Size = UDim2.new(1, 0, 0, 0)
            createTween(icon, 0.18, {Rotation = 0})
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
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.TextInputHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    label.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, self.theme.TextSizeNormal + 4)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name)
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left
    local input = Instance.new("TextBox")
    input.Parent = frame
    input.BackgroundColor3 = self.theme.ElementDark
    input.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.TextInputHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    label.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, self.theme.TextSizeNormal + 4)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name)
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left
    local input = Instance.new("TextBox")
    input.Parent = frame
    input.BackgroundColor3 = self.theme.ElementDark
    input.BackgroundTransparency = self.theme.ElementDarkTransparency
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
function ControlFactory:createKeybind(options)
    local flag = options.Flag or options.Name
    local savedVal = self.configHandler and self.configHandler:Get(flag)
    local currentStr = (savedVal ~= nil and type(savedVal) == "string") and savedVal or (options.CurrentKeybind or "None")
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.KeybindHeight)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name)
    label.TextColor3 = self.theme.Text
    label.TextSize = self.theme.TextSizeNormal
    label.TextXAlignment = Enum.TextXAlignment.Left
    local bindBtn = Instance.new("TextButton")
    bindBtn.Parent = frame
    bindBtn.BackgroundColor3 = self.theme.ElementDark
    bindBtn.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, self.theme.ColorPickerHeight)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name)
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
    container.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    rainbowBtn.BackgroundTransparency = self.theme.ElementTransparency
    rainbowBtn.Size = UDim2.new(0, 80, 0, 26)
    rainbowBtn.Position = UDim2.new(0.5, -40, 0, 165)
    rainbowBtn.Text = localizedValue("@Rainbow")
    rainbowBtn.TextColor3 = self.theme.Text
    rainbowBtn.TextSize = 12
    addCorner(rainbowBtn, 8)
    addStroke(rainbowBtn, self.theme.StrokeColor)
    bindLocalizedResolver(rainbowBtn, "Text", function()
        return localizedValue(rainbowActive and "@Stop" or "@Rainbow")
    end)
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
    self:track(rainbowBtn.MouseButton1Click:Connect(function()
        if rainbowActive then
            stopRainbow()
            rainbowBtn.Text = localizedValue("@Rainbow")
        else
            startRainbow()
            rainbowBtn.Text = localizedValue("@Stop")
        end
    end))
    if self.connectionBag then self.connectionBag:AddCleanup(stopRainbow) end
    local draggingWheel = false
    self:track(colorWheel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingWheel = true
            updateColorFromWheel(input.Position)
        end
    end))
    self:track(UserInputService.InputChanged:Connect(function(input)
        if draggingWheel and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateColorFromWheel(input.Position)
        end
    end))
    self:track(UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and draggingWheel then
            draggingWheel = false
        end
    end))
    local draggingHue = false
    self:track(hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            updateHue(input.Position)
        end
    end))
    self:track(UserInputService.InputChanged:Connect(function(input)
        if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateHue(input.Position)
        end
    end))
    self:track(UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and draggingHue then
            draggingHue = false
        end
    end))
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
    if options.CurrentValue and table.find(options.Options, options.CurrentValue) then
        selected = options.CurrentValue
    elseif savedVal ~= nil and type(savedVal) == "string" and table.find(options.Options, savedVal) then
        selected = savedVal
    else
        selected = options.Options[1] or ""
    end
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, #options.Options * self.theme.RadioItemHeight + 16)
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 6)
    label.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, 20)
    label.Font = self.theme.Font
    bindLocalizedText(label, "Text", options.Name)
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
        outer.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical)
    title.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, 0)
    title.Font = self.theme.Font
    bindLocalizedText(title, "Text", options.Title or "")
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
        imageLabel.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    local paragraphContent = options.Content or ""
    local content = Instance.new("TextLabel")
    content.Parent = frame
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, self.theme.PaddingVertical + 0)
    content.Size = UDim2.new(1, -2 * self.theme.PaddingHorizontal, 0, 0)
    content.Font = self.theme.Font
    content.Text = paragraphContent
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
        local contentHeight = TextService:GetTextSize(paragraphContent, self.theme.TextSizeSmall, self.theme.Font, Vector2.new(frame.AbsoluteSize.X - 2 * self.theme.PaddingHorizontal, 9999)).Y
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
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Font = self.theme.Font
    bindLocalizedText(title, "Text", options.Title or "@Image")
    title.TextColor3 = self.theme.Text
    title.TextSize = self.theme.TextSizeNormal
    title.TextXAlignment = Enum.TextXAlignment.Left
    local arrow = createChevron(frame, self.theme.TextMuted)
    arrow.Position = UDim2.new(1, -24, 0, 22)
    local container = Instance.new("Frame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.BackgroundTransparency = self.theme.ElementDarkTransparency
    container.Position = UDim2.new(0, 0, 0, 44)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Visible = false
    local image = Instance.new("ImageLabel")
    image.Parent = container
    image.BackgroundColor3 = self.theme.Element
    image.BackgroundTransparency = self.theme.ElementTransparency
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
            createTween(arrow, 0.18, {Rotation = 180})
        else
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, 44)})
            container.Visible = false
            createTween(arrow, 0.18, {Rotation = 0})
        end
    end)
    table.insert(self.createdControls, {type = "image", frame = frame, title = title, arrow = arrow, container = container})
    return frame
end
function ControlFactory:createVideo(options)
    local frame = Instance.new("Frame")
    frame.Parent = self.parent
    frame.BackgroundColor3 = self.theme.Element
    frame.BackgroundTransparency = self.theme.ElementTransparency
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.ClipsDescendants = true
    addCorner(frame, self.theme.CornerRadius)
    addStroke(frame, self.theme.StrokeColor, 1, self.theme.StrokeTransparency)
    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, self.theme.PaddingHorizontal, 0, 0)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Font = self.theme.Font
    bindLocalizedText(title, "Text", options.Title or "@Video")
    title.TextColor3 = self.theme.Text
    title.TextSize = self.theme.TextSizeNormal
    title.TextXAlignment = Enum.TextXAlignment.Left
    local arrow = createChevron(frame, self.theme.TextMuted)
    arrow.Position = UDim2.new(1, -24, 0, 22)
    local container = Instance.new("Frame")
    container.Parent = frame
    container.BackgroundColor3 = self.theme.ElementDark
    container.BackgroundTransparency = self.theme.ElementDarkTransparency
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
    playBtn.BackgroundTransparency = self.theme.ElementTransparency
    playBtn.Size = UDim2.new(0, 60, 0, 30)
    playBtn.Position = UDim2.new(0, 0, 0, 5)
    bindLocalizedText(playBtn, "Text", "@Play")
    playBtn.TextColor3 = self.theme.Text
    playBtn.TextSize = 12
    addCorner(playBtn, 6)
    local pauseBtn = Instance.new("TextButton")
    pauseBtn.Parent = controlsFrame
    pauseBtn.BackgroundColor3 = self.theme.Element
    pauseBtn.BackgroundTransparency = self.theme.ElementTransparency
    pauseBtn.Size = UDim2.new(0, 60, 0, 30)
    pauseBtn.Position = UDim2.new(0, 70, 0, 5)
    bindLocalizedText(pauseBtn, "Text", "@Pause")
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
            createTween(arrow, 0.18, {Rotation = 180})
        else
            createTween(frame, 0.25, {Size = UDim2.new(1, 0, 0, 44)})
            container.Visible = false
            createTween(arrow, 0.18, {Rotation = 0})
        end
    end)
    table.insert(self.createdControls, {type = "video", frame = frame, title = title, arrow = arrow, container = container})
    return frame
end
local Themes = {
    Dark = {

        Accent = Color3.fromRGB(88, 166, 255),
        Background = Color3.fromRGB(11, 14, 19),
        Sidebar = Color3.fromRGB(16, 20, 27),
        Element = Color3.fromRGB(22, 28, 37),
        ElementDark = Color3.fromRGB(14, 18, 24),
        Text = Color3.fromRGB(239, 243, 249),
        TextMuted = Color3.fromRGB(153, 165, 183),
        StrokeColor = Color3.fromRGB(53, 66, 86),
        HoverColor = Color3.fromRGB(31, 40, 52),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 14,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 38,
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
        ElementTransparency = 0.24,
        ElementDarkTransparency = 0.36,
        SidebarTransparency = 0.18,
        BackgroundTransparency = 0.12,
                StrokeTransparency = 0.68,

    },
    Slate = {

        Accent = Color3.fromRGB(124, 157, 186),
        Background = Color3.fromRGB(23, 28, 35),
        Sidebar = Color3.fromRGB(30, 37, 46),
        Element = Color3.fromRGB(39, 47, 58),
        ElementDark = Color3.fromRGB(27, 33, 42),
        Text = Color3.fromRGB(235, 240, 244),
        TextMuted = Color3.fromRGB(165, 177, 188),
        StrokeColor = Color3.fromRGB(74, 89, 105),
        HoverColor = Color3.fromRGB(52, 64, 77),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 38,
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
        ElementTransparency = 0.2,
        ElementDarkTransparency = 0.34,
        SidebarTransparency = 0.16,
        BackgroundTransparency = 0.1,
                StrokeTransparency = 0.66,

    },
    Ivory = {

        Accent = Color3.fromRGB(171, 112, 66),
        Background = Color3.fromRGB(244, 241, 235),
        Sidebar = Color3.fromRGB(235, 231, 222),
        Element = Color3.fromRGB(250, 247, 240),
        ElementDark = Color3.fromRGB(226, 221, 210),
        Text = Color3.fromRGB(48, 48, 46),
        TextMuted = Color3.fromRGB(112, 107, 99),
        StrokeColor = Color3.fromRGB(196, 186, 171),
        HoverColor = Color3.fromRGB(239, 232, 219),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 14,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 38,
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
        ElementTransparency = 0.08,
        ElementDarkTransparency = 0.2,
        SidebarTransparency = 0.07,
        BackgroundTransparency = 0.05,
                StrokeTransparency = 0.48,

    },
    Sage = {

        Accent = Color3.fromRGB(91, 145, 111),
        Background = Color3.fromRGB(20, 29, 25),
        Sidebar = Color3.fromRGB(26, 38, 32),
        Element = Color3.fromRGB(34, 49, 41),
        ElementDark = Color3.fromRGB(16, 26, 21),
        Text = Color3.fromRGB(231, 242, 234),
        TextMuted = Color3.fromRGB(157, 183, 165),
        StrokeColor = Color3.fromRGB(65, 93, 75),
        HoverColor = Color3.fromRGB(43, 64, 52),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 14,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 38,
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
        ElementTransparency = 0.22,
        ElementDarkTransparency = 0.36,
        SidebarTransparency = 0.18,
        BackgroundTransparency = 0.12,
                StrokeTransparency = 0.67,

    },
    Burgundy = {

        Accent = Color3.fromRGB(213, 114, 125),
        Background = Color3.fromRGB(35, 19, 24),
        Sidebar = Color3.fromRGB(47, 25, 31),
        Element = Color3.fromRGB(61, 32, 40),
        ElementDark = Color3.fromRGB(29, 15, 20),
        Text = Color3.fromRGB(249, 235, 237),
        TextMuted = Color3.fromRGB(202, 159, 167),
        StrokeColor = Color3.fromRGB(119, 61, 72),
        HoverColor = Color3.fromRGB(78, 42, 51),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 14,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 38,
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
        ElementTransparency = 0.24,
        ElementDarkTransparency = 0.38,
        SidebarTransparency = 0.18,
        BackgroundTransparency = 0.12,
                StrokeTransparency = 0.68,

    },
    Sandstone = {

        Accent = Color3.fromRGB(197, 143, 82),
        Background = Color3.fromRGB(38, 31, 23),
        Sidebar = Color3.fromRGB(49, 40, 29),
        Element = Color3.fromRGB(62, 50, 36),
        ElementDark = Color3.fromRGB(29, 23, 17),
        Text = Color3.fromRGB(246, 237, 221),
        TextMuted = Color3.fromRGB(196, 174, 143),
        StrokeColor = Color3.fromRGB(122, 91, 54),
        HoverColor = Color3.fromRGB(78, 63, 44),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 12,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 38,
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
        ElementTransparency = 0.22,
        ElementDarkTransparency = 0.36,
        SidebarTransparency = 0.18,
        BackgroundTransparency = 0.12,
                StrokeTransparency = 0.67,

    },
    Ocean = {

        Accent = Color3.fromRGB(83, 177, 190),
        Background = Color3.fromRGB(12, 28, 36),
        Sidebar = Color3.fromRGB(17, 39, 49),
        Element = Color3.fromRGB(24, 52, 63),
        ElementDark = Color3.fromRGB(9, 23, 30),
        Text = Color3.fromRGB(225, 243, 246),
        TextMuted = Color3.fromRGB(145, 190, 198),
        StrokeColor = Color3.fromRGB(49, 103, 114),
        HoverColor = Color3.fromRGB(32, 72, 82),
        Font = Enum.Font.GothamMedium,
        CornerRadius = 14,
        PaddingHorizontal = 14,
        PaddingVertical = 8,
        TextSizeNormal = 14,
        TextSizeSmall = 13,
        LabelHeight = 38,
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
        ElementTransparency = 0.22,
        ElementDarkTransparency = 0.36,
        SidebarTransparency = 0.18,
        BackgroundTransparency = 0.12,
                StrokeTransparency = 0.67,

    },
}
local ThemeEngine = {}
ThemeEngine.DefaultColors = {
    Canvas = Color3.fromRGB(8, 10, 14),
    Surface1 = Color3.fromRGB(14, 17, 23),
    Surface2 = Color3.fromRGB(20, 24, 32),
    SurfaceHover = Color3.fromRGB(27, 32, 42),
    Border = Color3.fromRGB(43, 50, 63),
    TextPrimary = Color3.fromRGB(245, 247, 250),
    TextSecondary = Color3.fromRGB(157, 166, 181),
    TextPlaceholder = Color3.fromRGB(112, 122, 140),
    Accent = Color3.fromRGB(74, 154, 255),
    AccentHover = Color3.fromRGB(101, 174, 255),
    AccentPressed = Color3.fromRGB(44, 122, 221),
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Danger = Color3.fromRGB(248, 113, 113),
}
ThemeEngine.DefaultMetrics = {
    Radius = 12,
    Padding = 14,
    Gap = 7,
    ControlHeight = 42,
}
ThemeEngine.DefaultMotion = {
    Fast = 0.12,
    Normal = 0.22,
    Window = 0.35,
}
local function themeColor(theme, colors, semanticName, legacyName, fallback)
    if colors[semanticName] ~= nil then return colors[semanticName] end
    if theme[legacyName] ~= nil then return theme[legacyName] end
    return fallback
end
function ThemeEngine:Normalize(theme)
    theme = theme or {}
    local colors = theme.Colors or {}
    for key, value in pairs(self.DefaultColors) do
        colors[key] = themeColor(theme, colors, key, ({Canvas = "Background", Surface1 = "Element", Surface2 = "ElementDark", SurfaceHover = "HoverColor", Border = "StrokeColor", TextPrimary = "Text", TextSecondary = "TextMuted", TextPlaceholder = "TextMuted", Accent = "Accent"})[key] or key, value)
    end
    colors.Primary = colors.Primary or colors.Accent
    colors.PrimaryHover = colors.PrimaryHover or colors.AccentHover
    colors.PrimaryPressed = colors.PrimaryPressed or colors.AccentPressed
    theme.Colors = colors
    local metrics = theme.Metrics or {}
    metrics.Radius = metrics.Radius or theme.CornerRadius or self.DefaultMetrics.Radius
    metrics.Padding = metrics.Padding or theme.PaddingHorizontal or self.DefaultMetrics.Padding
    metrics.Gap = metrics.Gap or self.DefaultMetrics.Gap
    metrics.ControlHeight = metrics.ControlHeight or theme.ButtonHeight or self.DefaultMetrics.ControlHeight
    theme.Metrics = metrics
    local motion = theme.Motion or {}
    motion.Fast = motion.Fast or self.DefaultMotion.Fast
    motion.Normal = motion.Normal or self.DefaultMotion.Normal
    motion.Window = motion.Window or self.DefaultMotion.Window
    theme.Motion = motion
    theme.Background = colors.Canvas
    theme.Element = colors.Surface1
    theme.ElementDark = colors.Surface2
    theme.HoverColor = colors.SurfaceHover
    theme.StrokeColor = colors.Border
    theme.Text = colors.TextPrimary
    theme.TextMuted = colors.TextSecondary
    theme.Accent = colors.Accent
    theme.CornerRadius = metrics.Radius
    theme.PaddingHorizontal = metrics.Padding
    theme.AnimationFast = motion.Fast
    theme.AnimationNormal = motion.Normal
    theme.AnimationWindow = motion.Window
    return theme
end
function ThemeEngine:Clone(theme)
    return self:Normalize(cloneTable(theme))
end
for name, theme in pairs(Themes) do
    Themes[name] = ThemeEngine:Normalize(theme)
end
function SynergyUI:RegisterTheme(name, theme)
    if type(name) ~= "string" or type(theme) ~= "table" then return false end
    local normalized = ThemeEngine:Clone(theme)
    normalized.Name = name
    Themes[name] = normalized
    return true
end
function SynergyUI:GetThemes()
    local result = {}
    for name in pairs(Themes) do table.insert(result, name) end
    table.sort(result)
    return result
end
function SynergyUI:GetTheme(name)
    if type(name) ~= "string" or not Themes[name] then return nil end
    return ThemeEngine:Clone(Themes[name])
end

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
    if type(options.Localization) == "table" then
        SynergyUI:Localization(options.Localization)
    end
    if type(options.Language) == "string" then
        SynergyUI:SetLanguage(options.Language)
    end
    local requestedTheme = options.Theme
    if type(requestedTheme) ~= "table" and (type(requestedTheme) ~= "string" or not Themes[requestedTheme]) then
        requestedTheme = "Dark"
    end
    local selectedTheme = type(requestedTheme) == "table" and ThemeEngine:Clone(requestedTheme) or ThemeEngine:Clone(Themes[requestedTheme])
    local window = {
        Title = options.Title or "Synergy Hub",
        Subtitle = options.Subtitle,
        Background = options.Background or options.BackgroundAsset,
        BackgroundImage = nil,
        Dialogs = {},
        Flags = {},
        Tabs = {},
        Connections = {},
        CurrentTab = nil,
        Theme = selectedTheme,
        ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift,
        IsVisible = true,
        IsMinimized = false,
        Destroyed = false,
        OnOpenCallback = options.OnOpen,
        OnCloseCallback = options.OnClose,
        OnDestroyCallback = options.OnDestroy,
        Lifecycle = {Open = {}, Close = {}, Destroy = {}},
        Resources = ConnectionBag.new(),
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
        window.Theme = ThemeEngine:Clone(Themes[savedConfig.__theme])
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
    window.OverlayManager = OverlayManager.new(gui.Parent, window.Resources)
    table.insert(localizationState.Windows, window)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = gui
    mainFrame.BackgroundColor3 = window.Theme.Background
    mainFrame.BackgroundTransparency = window.Theme.BackgroundTransparency
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    addCorner(mainFrame, window.Theme.CornerRadius)
    local mainStroke = addStroke(mainFrame, window.Theme.Accent, strokeThickness, 0.4)
    local mainStrokeGradient = Instance.new("UIGradient")
    mainStrokeGradient.Parent = mainStroke
    mainStrokeGradient.Rotation = 90
    mainStrokeGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(1, 0.15)
    })
    window.MainFrame = mainFrame
    local backgroundAsset = normalizeAssetId(window.Background)
    local backgroundImage
    if backgroundAsset then
        backgroundImage = Instance.new("ImageLabel")
        backgroundImage.Name = "BackgroundImage"
        backgroundImage.Parent = mainFrame
        backgroundImage.BackgroundTransparency = 1
        backgroundImage.BorderSizePixel = 0
        backgroundImage.Size = UDim2.new(1, 0, 1, 0)
        backgroundImage.Position = UDim2.new(0, 0, 0, 0)
        backgroundImage.Image = backgroundAsset
        backgroundImage.ImageTransparency = math.clamp(tonumber(options.BackgroundImageTransparency) or 0.52, 0, 1)
        backgroundImage.ScaleType = typeof(options.BackgroundScaleType) == "EnumItem" and options.BackgroundScaleType or Enum.ScaleType.Crop
        backgroundImage.ZIndex = 0
        addCorner(backgroundImage, window.Theme.CornerRadius)
    end
    window.BackgroundImage = backgroundImage
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
    topBar.BackgroundTransparency = window.Theme.SidebarTransparency
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 42)
    addCorner(topBar, window.Theme.CornerRadius)
    topBar.ZIndex = 10
    local topBarMask = Instance.new("Frame")
    topBarMask.Name = "TopBarMask"
    topBarMask.Parent = topBar
    topBarMask.BackgroundColor3 = window.Theme.Sidebar
    topBarMask.BackgroundTransparency = window.Theme.SidebarTransparency
    topBarMask.BorderSizePixel = 0
    topBarMask.Position = UDim2.new(0, 0, 1, -window.Theme.CornerRadius)
    topBarMask.Size = UDim2.new(1, 0, 0, window.Theme.CornerRadius)
    topBarMask.ZIndex = 9
    local topBarSep = Instance.new("Frame")
    topBarSep.Parent = topBar
    topBarSep.BackgroundColor3 = window.Theme.StrokeColor
    topBarSep.BorderSizePixel = 0
    topBarSep.Position = UDim2.new(0, 0, 1, -1)
    topBarSep.Size = UDim2.new(1, 0, 0, 1)
    topBarSep.ZIndex = 10
    local topBarSheen = Instance.new("Frame")
    topBarSheen.Name = "TopBarSheen"
    topBarSheen.Parent = topBar
    topBarSheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topBarSheen.BackgroundTransparency = 0.9
    topBarSheen.BorderSizePixel = 0
    topBarSheen.Position = UDim2.new(0, 0, 0, 0)
    topBarSheen.Size = UDim2.new(1, 0, 0, 1)
    topBarSheen.ZIndex = 11
    local titleGroup = Instance.new("Frame")
    titleGroup.Name = "TitleGroup"
    titleGroup.Parent = topBar
    titleGroup.BackgroundTransparency = 1
    titleGroup.Position = UDim2.new(0, window.Theme.PaddingHorizontal, 0, 0)
    titleGroup.Size = UDim2.new(1, -window.Theme.PaddingHorizontal - 106, 1, 0)
    titleGroup.ClipsDescendants = true
    titleGroup.ZIndex = 10
    local titleLayout = Instance.new("UIListLayout")
    titleLayout.Parent = titleGroup
    titleLayout.FillDirection = Enum.FillDirection.Horizontal
    titleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    titleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    titleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    titleLayout.Padding = UDim.new(0, 7)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Parent = titleGroup
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0, 0, 1, 0)
    titleLabel.AutomaticSize = Enum.AutomaticSize.X
    titleLabel.Font = window.Theme.Font
    bindLocalizedText(titleLabel, "Text", options.Title or "Synergy Hub")
    titleLabel.TextColor3 = window.Theme.Accent
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.ZIndex = 10
    local subtitleLabel
    if options.Subtitle ~= nil and tostring(options.Subtitle) ~= "" then
        subtitleLabel = Instance.new("TextLabel")
        subtitleLabel.Name = "SubtitleLabel"
        subtitleLabel.Parent = titleGroup
        subtitleLabel.BackgroundTransparency = 1
        subtitleLabel.Size = UDim2.new(0, 0, 1, 0)
        subtitleLabel.AutomaticSize = Enum.AutomaticSize.X
        subtitleLabel.Font = window.Theme.Font
        bindLocalizedText(subtitleLabel, "Text", options.Subtitle)
        subtitleLabel.TextColor3 = window.Theme.TextMuted
        subtitleLabel.TextSize = 11
        subtitleLabel.TextTransparency = 0.08
        subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
        subtitleLabel.ZIndex = 10
    end
    local function updateTitleLayout()
        local available = math.max(titleGroup.AbsoluteSize.X, 250)
        local titleWidth = TextService:GetTextSize(titleLabel.Text or "", titleLabel.TextSize, titleLabel.Font, Vector2.new(1000, 42)).X + 2
        local subtitleWidth = 0
        if subtitleLabel then
            subtitleWidth = TextService:GetTextSize(subtitleLabel.Text or "", subtitleLabel.TextSize, subtitleLabel.Font, Vector2.new(1000, 42)).X + 2
        end
        local gap = subtitleLabel and 7 or 0
        local maxTitleWidth = math.max(120, available - subtitleWidth - gap)
        titleLabel.Size = UDim2.new(0, math.min(titleWidth, maxTitleWidth), 1, 0)
        if subtitleLabel then
            local remaining = math.max(80, available - titleLabel.Size.X.Offset - gap)
            subtitleLabel.Size = UDim2.new(0, math.min(subtitleWidth, remaining), 1, 0)
        end
    end
    window.Resources:AddConnection(titleGroup:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateTitleLayout))
    task.defer(updateTitleLayout)
    window.TitleGroup = titleGroup
    window.TitleLabel = titleLabel
    window.SubtitleLabel = subtitleLabel
    window.UpdateTitleLayout = updateTitleLayout
    local controlContainer = Instance.new("Frame")
    controlContainer.Name = "ControlContainer"
    controlContainer.Parent = topBar
    controlContainer.BackgroundTransparency = 1
    controlContainer.Position = UDim2.new(1, -88, 0, 0)
    controlContainer.Size = UDim2.new(0, 88, 1, 0)
    controlContainer.ZIndex = 10
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinimizeButton"
    minBtn.Parent = controlContainer
    minBtn.BackgroundColor3 = window.Theme.ElementDark
    minBtn.BackgroundTransparency = 0.35
    minBtn.Position = UDim2.new(0, 14, 0.5, -10)
    minBtn.Size = UDim2.new(0, 20, 0, 20)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Text = "-"
    minBtn.TextColor3 = window.Theme.TextMuted
    minBtn.TextSize = 16
    minBtn.ZIndex = 10
    addCorner(minBtn, 999)
    addStroke(minBtn, window.Theme.StrokeColor, 1, 0.6)
    addHoverEffect(minBtn, minBtn.BackgroundColor3, window.Theme.HoverColor, false, window.Resources)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Parent = controlContainer
    closeBtn.BackgroundColor3 = window.Theme.ElementDark
    closeBtn.BackgroundTransparency = 0.35
    closeBtn.Position = UDim2.new(0, 50, 0.5, -10)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = window.Theme.TextMuted
    closeBtn.TextSize = 11
    closeBtn.ZIndex = 10
    addCorner(closeBtn, 999)
    local closeBtnStroke = addStroke(closeBtn, window.Theme.StrokeColor, 1, 0.6)
    local closeDangerColor = Color3.fromRGB(232, 68, 68)
    window.Resources:AddConnection(closeBtn.MouseEnter:Connect(function()
        createTween(closeBtn, 0.18, {BackgroundColor3 = closeDangerColor, BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255,255,255)})
        createTween(closeBtnStroke, 0.18, {Color = closeDangerColor, Transparency = 0.2})
    end))
    window.Resources:AddConnection(closeBtn.MouseLeave:Connect(function()
        createTween(closeBtn, 0.18, {BackgroundColor3 = window.Theme.ElementDark, BackgroundTransparency = 0.35, TextColor3 = window.Theme.TextMuted})
        createTween(closeBtnStroke, 0.18, {Color = window.Theme.StrokeColor, Transparency = 0.6})
    end))
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainFrame
    sidebar.BackgroundColor3 = window.Theme.Sidebar
    sidebar.BackgroundTransparency = window.Theme.SidebarTransparency
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
    local sidebarMask = Instance.new("Frame")
    sidebarMask.Name = "SidebarMask"
    sidebarMask.Parent = mainFrame
    sidebarMask.BackgroundColor3 = window.Theme.Sidebar
    sidebarMask.BackgroundTransparency = window.Theme.SidebarTransparency
    sidebarMask.BorderSizePixel = 0
    sidebarMask.Position = UDim2.new(0, 150 - window.Theme.CornerRadius, 0, 42)
    sidebarMask.Size = UDim2.new(0, window.Theme.CornerRadius, 1, -42 - strokeThickness)
    sidebarMask.ZIndex = 4
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
    contentArea.BackgroundTransparency = window.Theme.BackgroundTransparency
    contentArea.BorderSizePixel = 0
    contentArea.Position = UDim2.new(0, 150, 0, 42)
    contentArea.Size = UDim2.new(1, -150 - strokeThickness, 1, -42 - strokeThickness)
    contentArea.ZIndex = 1
    addCorner(contentArea, window.Theme.CornerRadius)
    contentArea.ClipsDescendants = true
    local function addConnection(conn)
        if conn then
            table.insert(window.Connections, conn)
            window.Resources:AddConnection(conn)
        end
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
    end))
    addConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and not _anyKeybindBinding and window.ToggleKey and input.KeyCode == window.ToggleKey then
            window:Toggle()
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
    function window:SetToggleKey(keyName)
        if keyName == "None" then
            window.ToggleKey = nil
        else
            local keyEnum = Enum.KeyCode[keyName]
            if keyEnum then
                window.ToggleKey = keyEnum
            end
        end
        return window
    end
    local function fireLifecycle(eventName, ...)
        for _, callback in ipairs(window.Lifecycle[eventName] or {}) do
            pcall(callback, window, ...)
        end
    end
    function window:OnOpen(callback)
        if type(callback) == "function" then table.insert(window.Lifecycle.Open, callback) end
        return window
    end
    function window:OnClose(callback)
        if type(callback) == "function" then table.insert(window.Lifecycle.Close, callback) end
        return window
    end
    function window:OnDestroy(callback)
        if type(callback) == "function" then table.insert(window.Lifecycle.Destroy, callback) end
        return window
    end
    function window:IsOpen()
        return window.IsVisible and not window.Destroyed
    end
    function window:Open()
        if window.Destroyed then return window end
        if window.IsVisible then return window end
        window.IsVisible = true
        gui.Enabled = true
        if window.OnOpenCallback then pcall(window.OnOpenCallback, window) end
        fireLifecycle("Open")
        return window
    end
    function window:Close()
        if window.Destroyed or not window.IsVisible then return window end
        if window.OverlayManager then window.OverlayManager:CloseAll() end
        window.IsVisible = false
        gui.Enabled = false
        if window.OnCloseCallback then pcall(window.OnCloseCallback, window) end
        fireLifecycle("Close")
        return window
    end
    function window:Toggle()
        if window:IsOpen() then return window:Close() end
        return window:Open()
    end
    local iconMap = {}
    if options.IconSet ~= false then
        local iconCommit = "03461a61928eb42028daeffe56268e3fff294fba"
        local baseUrl = "https://raw.githubusercontent.com/Xyraniz/SynergyUI/" .. iconCommit .. "/src/Icons/"
        local fetch = request or (syn and syn.request) or (http and http.request) or http_request
        local function fetchIconSet(setName)
            if type(setName) ~= "string" or not setName:match("^[%w_-]+$") then
                return nil
            end
            local iconUrl = baseUrl .. setName .. "/Icons.lua"
            local body = nil
            if fetch then
                local ok, res = pcall(function() return fetch({Url = iconUrl, Method = "GET"}) end)
                if ok and res and res.Body then body = res.Body end
            end
            if not body then
                local ok, res = pcall(game.HttpGet, game, iconUrl)
                if ok then body = res end
            end
            if not body then return nil end
            local loadFunc = loadstring(body)
            if not loadFunc then return nil end
            local ok, loadedMap = pcall(loadFunc)
            if ok and type(loadedMap) == "table" then return loadedMap end
            return nil
        end
        local function registerIcon(iconName, value, loadedMap)
            if type(iconName) ~= "string" then
                return
            end
            if type(value) == "string" then
                if iconMap[iconName] == nil then
                    iconMap[iconName] = {Image = value}
                end
                return
            end
            if type(value) ~= "table" then
                return
            end
            local image = value.Image
            local spritesheets = loadedMap and loadedMap.Spritesheets
            if type(image) == "number" and type(spritesheets) == "table" then
                image = spritesheets[image] or spritesheets[tostring(image)]
            end
            if type(image) ~= "string" then
                return
            end
            local descriptor = {Image = image}
            if value.ImageRectPosition then
                descriptor.ImageRectPosition = value.ImageRectPosition
            end
            if value.ImageRectSize then
                descriptor.ImageRectSize = value.ImageRectSize
            end
            if value.Parts then
                descriptor.Parts = value.Parts
            end
            if iconMap[iconName] == nil then
                iconMap[iconName] = descriptor
            end
        end
        local function mergeIconSet(loadedMap)
            if type(loadedMap) ~= "table" then
                return
            end
            for iconName, value in pairs(loadedMap) do
                if iconName ~= "Icons" and iconName ~= "Spritesheets" then
                    registerIcon(iconName, value, loadedMap)
                end
            end
            if type(loadedMap.Icons) == "table" then
                for iconName, value in pairs(loadedMap.Icons) do
                    registerIcon(iconName, value, loadedMap)
                end
            end
        end
        local setsToLoad = {"lucide", "gravity", "craft", "geist", "sfsymbols", "solar"}
        if type(options.IconSet) == "string" then
            setsToLoad = {options.IconSet}
        elseif type(options.IconSet) == "table" then
            setsToLoad = options.IconSet
        end
        for _, setName in ipairs(setsToLoad) do
            mergeIconSet(fetchIconSet(setName))
        end
    end
    function window:RefreshTheme()
        self.Theme = ThemeEngine:Normalize(self.Theme)
        local newTheme = self.Theme
        self.MainFrame.BackgroundColor3 = newTheme.Background
        self.MainFrame.BackgroundTransparency = newTheme.BackgroundTransparency
        local stroke = self.MainFrame:FindFirstChild("UIStroke")
        if stroke then stroke.Color = newTheme.Accent end
        local topBarRef = self.MainFrame:FindFirstChild("TopBar")
        topBarRef.BackgroundColor3 = newTheme.Sidebar
        topBarRef.BackgroundTransparency = newTheme.SidebarTransparency
        titleLabel.TextColor3 = newTheme.Accent
        titleLabel.Font = newTheme.Font
        if subtitleLabel then
            subtitleLabel.TextColor3 = newTheme.TextMuted
            subtitleLabel.Font = newTheme.Font
        end
        local controlContainerRef = topBarRef:FindFirstChild("ControlContainer")
        if controlContainerRef then
            local minBtnRef = controlContainerRef:FindFirstChild("MinimizeButton")
            local closeBtnRef = controlContainerRef:FindFirstChild("CloseButton")
            if minBtnRef then
                minBtnRef.BackgroundColor3 = newTheme.ElementDark
                minBtnRef.BackgroundTransparency = newTheme.ElementDarkTransparency
                minBtnRef.TextColor3 = newTheme.TextMuted
                local minStroke = minBtnRef:FindFirstChild("UIStroke")
                if minStroke then minStroke.Color = newTheme.StrokeColor end
            end
            if closeBtnRef then
                closeBtnRef.BackgroundColor3 = newTheme.ElementDark
                closeBtnRef.BackgroundTransparency = newTheme.ElementDarkTransparency
                closeBtnRef.TextColor3 = newTheme.TextMuted
                local closeStroke = closeBtnRef:FindFirstChild("UIStroke")
                if closeStroke then closeStroke.Color = newTheme.StrokeColor end
            end
        end
        self.MainFrame:FindFirstChild("Sidebar").BackgroundColor3 = newTheme.Sidebar
        self.MainFrame:FindFirstChild("Sidebar").BackgroundTransparency = newTheme.SidebarTransparency
        self.MainFrame:FindFirstChild("Sidebar").ScrollBarImageColor3 = newTheme.Accent
        self.MainFrame:FindFirstChild("ContentArea").BackgroundColor3 = newTheme.Background
        self.MainFrame:FindFirstChild("ContentArea").BackgroundTransparency = newTheme.BackgroundTransparency
        self.resizeHandle.BackgroundColor3 = newTheme.Accent
        for _, tab in ipairs(self.Tabs) do
            tab.Content.BackgroundColor3 = newTheme.Background
            tab.Content.BackgroundTransparency = newTheme.BackgroundTransparency
            tab.Content.ScrollBarImageColor3 = newTheme.Accent
            tab.Button.BackgroundTransparency = 1
            if tab.Surface then
                tab.Surface.BackgroundColor3 = newTheme.Sidebar
                tab.Surface.BackgroundTransparency = tab.Content.Visible and math.max(newTheme.SidebarTransparency - 0.5, 0.12) or newTheme.SidebarTransparency
            end
            if tab.SurfaceStroke then
                tab.SurfaceStroke.Color = tab.Content.Visible and newTheme.Accent or newTheme.Text
                tab.SurfaceStroke.Transparency = tab.Content.Visible and 0.55 or 1
            end
            local tabLabel = tab.Button:FindFirstChild("TabLabel")
            if tabLabel then
                tabLabel.TextColor3 = (tab.Content.Visible) and newTheme.Accent or newTheme.TextMuted
                tabLabel.TextTransparency = tab.Content.Visible and 0 or 0.18
            end
            if tab.ActiveIndicator then
                tab.ActiveIndicator.BackgroundColor3 = newTheme.Accent
                tab.ActiveIndicator.Visible = tab.Content.Visible
            end
            local img = tab.Button:FindFirstChild("ImageLabel")
            if img then
                img.ImageColor3 = tab.Content.Visible and newTheme.Accent or newTheme.TextMuted
                img.ImageTransparency = tab.Content.Visible and 0 or 0.25
            end
            for _, control in ipairs(tab.Controls) do
                if control.type == "label" then
                    control.instance.TextColor3 = newTheme.Text
                    if control.frame then control.frame.BackgroundColor3 = newTheme.Element end
                    if control.stroke then control.stroke.Color = newTheme.StrokeColor end
                    if control.accent then control.accent.BackgroundColor3 = newTheme.Accent end
                elseif control.type == "section" then
                    control.instance.TextColor3 = newTheme.Accent
                    control.instance.Font = newTheme.Font
                elseif control.type == "separator" then
                    control.instance.BackgroundColor3 = newTheme.StrokeColor
                elseif control.type == "button" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    local strokeBtn = control.frame:FindFirstChild("UIStroke")
                    if strokeBtn then strokeBtn.Color = newTheme.StrokeColor end
                    control.btn.TextColor3 = newTheme.Text
                elseif control.type == "toggle" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = (control.getState and control.getState() or false) and newTheme.Accent or newTheme.Text
                    control.outer.BackgroundColor3 = newTheme.ElementDark
                    control.outer.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.inner.BackgroundColor3 = (control.getState and control.getState() or false) and newTheme.Accent or newTheme.TextMuted
                elseif control.type == "checkbox" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = (control.getState and control.getState() or false) and newTheme.Accent or newTheme.Text
                    control.checkFrame.BackgroundColor3 = newTheme.ElementDark
                    control.checkFrame.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.checkIcon.ImageColor3 = newTheme.Accent
                elseif control.type == "slider" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = newTheme.Text
                    control.valLabel.TextColor3 = newTheme.Accent
                    control.bg.BackgroundColor3 = newTheme.ElementDark
                    control.bg.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.fill.BackgroundColor3 = newTheme.Accent
                    if control.fillGradient then
                        control.fillGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, newTheme.Accent),
                            ColorSequenceKeypoint.new(1, newTheme.Accent:lerp(Color3.fromRGB(255,255,255), 0.3))
                        })
                    end
                    control.thumb.BackgroundColor3 = newTheme.Accent
                    control.tooltip.BackgroundColor3 = newTheme.ElementDark
                    control.tooltip.BackgroundTransparency = newTheme.ElementDarkTransparency
                    local tooltipStroke = control.tooltip:FindFirstChild("UIStroke")
                    if tooltipStroke then tooltipStroke.Color = newTheme.Accent end
                    control.tooltipLabel.TextColor3 = newTheme.Text
                    control.inputBg.BackgroundColor3 = newTheme.ElementDark
                    control.inputBg.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.numInput.TextColor3 = newTheme.Text
                elseif control.type == "progressbar" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = newTheme.Text
                    control.valueLabel.TextColor3 = newTheme.Accent
                    control.barBg.BackgroundColor3 = newTheme.ElementDark
                    control.barBg.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.fill.BackgroundColor3 = newTheme.Accent
                    if control.fillGradient then
                        control.fillGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, newTheme.Accent),
                            ColorSequenceKeypoint.new(1, newTheme.Accent:lerp(Color3.fromRGB(255,255,255), 0.25)),
                        })
                    end
                    local barStroke = control.barBg:FindFirstChild("UIStroke")
                    if barStroke then
                        barStroke.Color = newTheme.StrokeColor
                    end
                elseif control.type == "dropdown" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.btn.TextColor3 = newTheme.Text
                    setChevronColor(control.icon, newTheme.TextMuted)
                    control.container.BackgroundColor3 = newTheme.ElementDark
                    control.container.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.container.ScrollBarImageColor3 = newTheme.Accent
                elseif control.type == "checklist" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.btn.TextColor3 = newTheme.Text
                    control.countLabel.TextColor3 = newTheme.Accent
                    setChevronColor(control.icon, newTheme.TextMuted)
                    control.container.BackgroundColor3 = newTheme.ElementDark
                    control.container.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.container.ScrollBarImageColor3 = newTheme.Accent
                elseif control.type == "textinput" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = newTheme.Text
                    control.input.BackgroundColor3 = newTheme.ElementDark
                    control.input.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.input.TextColor3 = newTheme.Text
                    control.input.PlaceholderColor3 = newTheme.TextMuted
                elseif control.type == "numberinput" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = newTheme.Text
                    control.input.BackgroundColor3 = newTheme.ElementDark
                    control.input.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.input.TextColor3 = newTheme.Text
                elseif control.type == "keybind" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = newTheme.Text
                    control.bindBtn.BackgroundColor3 = newTheme.ElementDark
                    control.bindBtn.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.bindBtn.TextColor3 = newTheme.Accent
                elseif control.type == "colorpicker" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = newTheme.Text
                    control.container.BackgroundColor3 = newTheme.ElementDark
                    control.container.BackgroundTransparency = newTheme.ElementDarkTransparency
                    control.rainbowBtn.BackgroundColor3 = newTheme.Element
                    control.rainbowBtn.BackgroundTransparency = newTheme.ElementTransparency
                    control.rainbowBtn.TextColor3 = newTheme.Text
                elseif control.type == "radiogroup" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.label.TextColor3 = newTheme.Text
                    for _, rb in ipairs(control.radioButtons) do
                        local outer = rb.Inner.Parent
                        outer.BackgroundColor3 = newTheme.ElementDark
                        outer.BackgroundTransparency = newTheme.ElementDarkTransparency
                        local optLabel = outer.Parent:FindFirstChildWhichIsA("TextLabel")
                        if optLabel then optLabel.TextColor3 = newTheme.TextMuted end
                    end
                elseif control.type == "paragraph" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.title.TextColor3 = newTheme.Accent
                    control.content.TextColor3 = newTheme.TextMuted
                    if control.imageLabel then
                        local strokeImg = control.imageLabel:FindFirstChild("UIStroke")
                        if strokeImg then strokeImg.Color = newTheme.StrokeColor end
                    end
                elseif control.type == "image" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.title.TextColor3 = newTheme.Text
                    setChevronColor(control.arrow, newTheme.TextMuted)
                    if control.container then
                        control.container.BackgroundColor3 = newTheme.ElementDark
                        control.container.BackgroundTransparency = newTheme.ElementDarkTransparency
                    end
                elseif control.type == "video" then
                    control.frame.BackgroundColor3 = newTheme.Element
                    control.frame.BackgroundTransparency = newTheme.ElementTransparency
                    control.title.TextColor3 = newTheme.Text
                    setChevronColor(control.arrow, newTheme.TextMuted)
                    if control.container then
                        control.container.BackgroundColor3 = newTheme.ElementDark
                        control.container.BackgroundTransparency = newTheme.ElementDarkTransparency
                    end
                end
            end
        end
    end
    function window:SetTitle(value)
        window.Title = value
        bindLocalizedText(titleLabel, "Text", value)
        updateTitleLayout()
    end
    function window:SetSubtitle(value)
        window.Subtitle = value
        if subtitleLabel then
            subtitleLabel:Destroy()
            subtitleLabel = nil
            window.SubtitleLabel = nil
        end
        if value ~= nil and tostring(value) ~= "" then
            subtitleLabel = Instance.new("TextLabel")
            subtitleLabel.Name = "SubtitleLabel"
            subtitleLabel.Parent = titleGroup
            subtitleLabel.BackgroundTransparency = 1
            subtitleLabel.Size = UDim2.new(0, 0, 1, 0)
            subtitleLabel.AutomaticSize = Enum.AutomaticSize.X
            subtitleLabel.Font = window.Theme.Font
            bindLocalizedText(subtitleLabel, "Text", value)
            subtitleLabel.TextColor3 = window.Theme.TextMuted
            subtitleLabel.TextSize = 11
            subtitleLabel.TextTransparency = 0.08
            subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            subtitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
            subtitleLabel.ZIndex = 10
            window.SubtitleLabel = subtitleLabel
        end
        updateTitleLayout()
    end
    function window:SetBackground(asset, transparency)
        local assetId = normalizeAssetId(asset)
        if not assetId then
            if window.BackgroundImage then
                window.BackgroundImage:Destroy()
                window.BackgroundImage = nil
            end
            window.Background = nil
            return false
        end
        if not window.BackgroundImage then
            window.BackgroundImage = Instance.new("ImageLabel")
            window.BackgroundImage.Name = "BackgroundImage"
            window.BackgroundImage.Parent = mainFrame
            window.BackgroundImage.BackgroundTransparency = 1
            window.BackgroundImage.BorderSizePixel = 0
            window.BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
            window.BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
            window.BackgroundImage.ScaleType = Enum.ScaleType.Crop
            window.BackgroundImage.ZIndex = 0
            addCorner(window.BackgroundImage, window.Theme.CornerRadius)
        end
        window.Background = asset
        window.BackgroundImage.Image = assetId
        if transparency ~= nil then
            window.BackgroundImage.ImageTransparency = math.clamp(tonumber(transparency) or 0, 0, 1)
        end
        return true
    end
    function window:RefreshLocalization()
        updateLocalization()
        updateTitleLayout()
    end
    function window:SetLanguage(language)
        return SynergyUI:SetLanguage(language)
    end
    function window:Alert(options)
        options = options or {}
        options.OwnerWindow = window
        return SynergyUI:Alert(options)
    end
    function window:Confirm(options)
        options = options or {}
        options.OwnerWindow = window
        return SynergyUI:Confirm(options)
    end
    function window:Prompt(options)
        options = options or {}
        options.OwnerWindow = window
        return SynergyUI:Prompt(options)
    end
    function window:SetAccent(color)
        window.Theme = ThemeEngine:Normalize(window.Theme)
        window.Theme.Accent = color
        window.Theme.Colors.Accent = color
        window.Theme.Colors.Primary = color
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
    function window:SetTheme(themeValue)
        local selected
        local selectedName
        if type(themeValue) == "string" and Themes[themeValue] then
            selected = ThemeEngine:Clone(Themes[themeValue])
            selectedName = themeValue
        elseif type(themeValue) == "table" then
            selected = ThemeEngine:Clone(themeValue)
            selectedName = selected.Name
        end
        if selected then
            window.Theme = selected
            window:RefreshTheme()
            if selectedName then configHandler:Set("__theme", selectedName) end
        end
        return window
    end
    function window:Destroy()
        if window.Destroyed then return window end
        if window.IsVisible then window:Close() end
        window.Destroyed = true
        for index = #window.Dialogs, 1, -1 do
            local dialog = window.Dialogs[index]
            if dialog and dialog.Destroy then dialog:Destroy() end
        end
        if window.OverlayManager then window.OverlayManager:CloseAll() end
        if window.OnDestroyCallback then pcall(window.OnDestroyCallback, window) end
        fireLifecycle("Destroy")
        window.Resources:Cleanup()
        for index = #localizationState.Windows, 1, -1 do
            if localizationState.Windows[index] == window then
                table.remove(localizationState.Windows, index)
            end
        end
        if gui then gui:Destroy() end
        return window
    end
    function window:CreateTab(name, icon)
        local iconAsset = icon
        if type(icon) == "string" and not icon:match("^rbxasset") and not icon:match("^http") then
            iconAsset = iconMap[icon] or ""
        end
        local iconImage = type(iconAsset) == "table" and iconAsset.Image or iconAsset
        local tabBtn = Instance.new("TextButton")
        tabBtn.Parent = sidebar
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Size = UDim2.new(1, 0, 0, 42)
        tabBtn.Text = ""
        tabBtn.Position = UDim2.new(0, window.Theme.PaddingHorizontal + 10, 0, 0)
        tabBtn.ZIndex = 1

        -- Superficie interior redondeada para tabs, inspirada en la jerarquÃ­a
        -- de capas de WindUI, pero implementada con primitives nativas.
        local tabSurface = Instance.new("Frame")
        tabSurface.Name = "TabSurface"
        tabSurface.Parent = tabBtn
        tabSurface.BackgroundColor3 = window.Theme.Sidebar
        tabSurface.BackgroundTransparency = window.Theme.SidebarTransparency
        tabSurface.BorderSizePixel = 0
        tabSurface.Position = UDim2.new(0, 6, 0, 2)
        tabSurface.Size = UDim2.new(1, -12, 1, -4)
        tabSurface.ZIndex = 1
        addCorner(tabSurface, math.max(window.Theme.CornerRadius - 3, 4))
        local tabSurfaceStroke = addStroke(tabSurface, window.Theme.Text, 1, 1)
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "TabLabel"
        tabLabel.Parent = tabBtn
        tabLabel.BackgroundTransparency = 1
        tabLabel.Size = UDim2.new(1, 0, 1, 0)
        tabLabel.Font = window.Theme.Font
        tabLabel.TextColor3 = window.Theme.TextMuted
        tabLabel.TextSize = 14
        tabLabel.TextTransparency = 0.18
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.ZIndex = 2
        bindLocalizedText(tabLabel, "Text", name)
        local tabState = {Active = false}
        tabBtn.MouseEnter:Connect(function()
            if not tabState.Active then
                createTween(tabSurface, 0.15, {BackgroundTransparency = math.max(window.Theme.SidebarTransparency - 0.32, 0.08)})
                createTween(tabSurfaceStroke, 0.15, {Color = window.Theme.StrokeColor, Transparency = 0.7})
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if not tabState.Active then
                createTween(tabSurface, 0.15, {BackgroundTransparency = window.Theme.SidebarTransparency})
                createTween(tabSurfaceStroke, 0.15, {Color = window.Theme.Text, Transparency = 1})
            end
        end)
        local activeIndicator = Instance.new("Frame")
        activeIndicator.Parent = tabBtn
        activeIndicator.BackgroundColor3 = window.Theme.Accent
        activeIndicator.BorderSizePixel = 0
        activeIndicator.Position = UDim2.new(0, -window.Theme.PaddingHorizontal - 10, 0.15, 0)
        activeIndicator.Size = UDim2.new(0, 3, 0.7, 0)
        activeIndicator.Visible = false
        activeIndicator.ZIndex = 3
        addCorner(activeIndicator, 999)
        if iconImage and iconImage ~= "" then
            local iconLabel = Instance.new("ImageLabel")
            iconLabel.Parent = tabBtn
            iconLabel.BackgroundTransparency = 1
            iconLabel.Position = UDim2.new(0, 16, 0.5, -10)
            iconLabel.Size = UDim2.new(0, 20, 0, 20)
            iconLabel.Image = iconImage
            if type(iconAsset) == "table" then
                if iconAsset.ImageRectPosition then
                    iconLabel.ImageRectOffset = iconAsset.ImageRectPosition
                end
                if iconAsset.ImageRectSize then
                    iconLabel.ImageRectSize = iconAsset.ImageRectSize
                end
            end
            iconLabel.ImageColor3 = window.Theme.TextMuted
            iconLabel.ImageTransparency = 0.25
            iconLabel.ZIndex = 2
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
        scrollFrame.BackgroundTransparency = window.Theme.BackgroundTransparency
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
        local tabData = {Button = tabBtn, Surface = tabSurface, SurfaceStroke = tabSurfaceStroke, Content = scrollFrame, ActiveIndicator = activeIndicator, Controls = {}, State = tabState}
        table.insert(window.Tabs, tabData)
        if #window.Tabs == 1 then
            local lbl = tabBtn:FindFirstChild("TabLabel")
            if lbl then lbl.TextColor3 = window.Theme.Accent end
            tabBtn.TextColor3 = window.Theme.Accent
            activeIndicator.Visible = true
            tabState.Active = true
            tabSurface.BackgroundTransparency = math.max(window.Theme.SidebarTransparency - 0.5, 0.12)
            tabSurfaceStroke.Color = window.Theme.Accent
            tabSurfaceStroke.Transparency = 0.55
            tabLabel.TextTransparency = 0
            if iconAsset and iconAsset ~= "" then
                local img = tabBtn:FindFirstChild("ImageLabel")
                if img then
                    img.ImageColor3 = window.Theme.Accent
                    img.ImageTransparency = 0
                end
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
                if t.State then t.State.Active = false end
                createTween(t.Surface, 0.15, {BackgroundTransparency = window.Theme.SidebarTransparency})
                createTween(t.SurfaceStroke, 0.15, {Color = window.Theme.Text, Transparency = 1})
                local img = t.Button:FindFirstChild("ImageLabel")
                if img then img.ImageColor3 = window.Theme.TextMuted end
            end
            local lbl = tabBtn:FindFirstChild("TabLabel")
            if lbl then lbl.TextColor3 = window.Theme.Accent end
            tabBtn.TextColor3 = window.Theme.Accent
            activeIndicator.Visible = true
            tabState.Active = true
            createTween(tabSurface, 0.15, {BackgroundTransparency = math.max(window.Theme.SidebarTransparency - 0.5, 0.12)})
            createTween(tabSurfaceStroke, 0.15, {Color = window.Theme.Accent, Transparency = 0.55})
            createTween(tabLabel, 0.15, {TextTransparency = 0})
            scrollFrame.Visible = true
            window.CurrentTab = scrollFrame
            local img = tabBtn:FindFirstChild("ImageLabel")
            if img then
                img.ImageColor3 = window.Theme.Accent
                createTween(img, 0.15, {ImageTransparency = 0})
            end
        end))
        local elements = {}
        local controlFactory = ControlFactory:new(scrollFrame, window.Theme, window.SetAccent, configHandler, window.OverlayManager, window.Resources)
        controlFactory.controls = window.Flags
        controlFactory.connections = window.Connections
        local originalCreateKeybind = controlFactory.createKeybind
        controlFactory.createKeybind = function(self, opts)
            if opts.Flag == "Keybind" then
                local originalCallback = opts.Callback
                opts.Callback = function(v)
                    if originalCallback then pcall(originalCallback, v) end
                    window:SetToggleKey(v)
                end
            end
            local flagObj, conns = originalCreateKeybind(self, opts)
            if opts.Flag == "Keybind" then
                local currentVal = flagObj.GetValue()
                window:SetToggleKey(currentVal)
            end
            return flagObj, conns
        end
        elements.CreateLabel = function(_, text) local lbl = controlFactory:createLabel(text); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return lbl end
        elements.CreateSeparator = function() local sep = controlFactory:createSeparator(); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return sep end
        elements.CreateButton = function(_, opts) local btn,conn = controlFactory:createButton(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return btn,conn end
        elements.CreateToggle = function(_, opts) local tog,conn = controlFactory:createToggle(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return tog,conn end
        elements.CreateCheckBox = function(_, opts) local chk,conn = controlFactory:createCheckBox(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return chk,conn end
        elements.CreateSlider = function(_, opts) local sld,conn = controlFactory:createSlider(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return sld,conn end
        elements.CreateProgressBar = function(_, opts) local bar = controlFactory:createProgressBar(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return bar end
        elements.CreateDropdown = function(_, opts) local drp,conn = controlFactory:createDropdown(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return drp,conn end
        elements.CreateChecklist = function(_, opts) local chk,conn = controlFactory:createChecklist(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return chk,conn end
        elements.CreateTextInput = function(_, opts) local txt,conn = controlFactory:createTextInput(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return txt,conn end
        elements.CreateNumberInput = function(_, opts) local num,conn = controlFactory:createNumberInput(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return num,conn end
        elements.CreateKeybind = function(_, opts) local key,conn = controlFactory:createKeybind(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return key,conn end
        elements.CreateColorPicker = function(_, opts) local col,conn = controlFactory:createColorPicker(opts); controlFactory:track(conn); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return col,conn end
        elements.CreateRadioGroup = function(_, opts) local rad,conn = controlFactory:createRadioGroup(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return rad,conn end
        elements.CreateParagraph = function(_, opts) local para = controlFactory:createParagraph(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return para end
        elements.CreateImage = function(_, opts) local img = controlFactory:createImage(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return img end
        elements.CreateVideo = function(_, opts) local vid = controlFactory:createVideo(opts); table.insert(tabData.Controls, controlFactory.createdControls[#controlFactory.createdControls]); return vid end
        elements.CreateProgress = elements.CreateProgressBar
        function elements:CreateSection(name)
            local section = Instance.new("TextLabel")
            section.Parent = scrollFrame
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(1, 0, 0, 28)
            section.Font = window.Theme.Font
            bindLocalizedText(section, "Text", name)
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
