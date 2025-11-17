local NexusLib = {
    Elements = {},
    Themes = {},
    ThemeObjects = {},
    Flags = {},
    Connections = {},
    SelectedTheme = "Dark",
    Folder = "NexusLib_Configs",
    SaveConfig = false
}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Nexus = Instance.new("ScreenGui")
Nexus.Name = "NexusLib"
if syn and syn.protect_gui then
    syn.protect_gui(Nexus)
    Nexus.Parent = game.CoreGui
else
    Nexus.Parent = game.CoreGui
end
NexusLib.Themes = {
    Dark = {
        Main = Color3.fromRGB(30, 30, 30),
        Second = Color3.fromRGB(40, 40, 40),
        Stroke = Color3.fromRGB(60, 60, 60),
        Divider = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Accent = Color3.fromRGB(44, 120, 224)
    },
    Light = {
        Main = Color3.fromRGB(240, 240, 240),
        Second = Color3.fromRGB(220, 220, 220),
        Stroke = Color3.fromRGB(180, 180, 180),
        Divider = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(30, 30, 30),
        TextDark = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(44, 120, 224)
    },
    Custom = {
        Main = Color3.fromRGB(36, 36, 36),
        Second = Color3.fromRGB(34, 34, 34),
        Stroke = Color3.fromRGB(42, 42, 42),
        Divider = Color3.fromRGB(115, 41, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(102, 41, 255)
    }
}
local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3}
local BlacklistedKeys = {Enum.KeyCode.Unknown, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Up, Enum.KeyCode.Left, Enum.KeyCode.Down, Enum.KeyCode.Right, Enum.KeyCode.Slash, Enum.KeyCode.Tab, Enum.KeyCode.Backspace, Enum.KeyCode.Escape}
local function CheckKey(Table, Key)
    for _, v in next, Table do
        if v == Key then
            return true
        end
    end
    return false
end
local function AddConnection(Signal, Function)
    local Conn = Signal:Connect(Function)
    table.insert(NexusLib.Connections, Conn)
    return Conn
end
local function Create(Name, Properties, Children)
    local Object = Instance.new(Name)
    for i, v in next, Properties or {} do
        Object[i] = v
    end
    for i, v in next, Children or {} do
        v.Parent = Object
    end
    return Object
end
local function CreateElement(ElementName, ElementFunction)
    NexusLib.Elements[ElementName] = function(...)
        return ElementFunction(...)
    end
end
local function MakeElement(ElementName, ...)
    local ElementFunc = NexusLib.Elements[ElementName]
    if ElementFunc then
        return ElementFunc(...)
    end
    return nil
end
local function SetProps(Element, Props)
    for Property, Value in pairs(Props) do
        Element[Property] = Value
    end
    return Element
end
local function SetChildren(Element, Children)
    for _, Child in pairs(Children) do
        if typeof(Child) == "Instance" then
            Child.Parent = Element
        end
    end
    return Element
end
local function ReturnProperty(Object)
    if Object:IsA("Frame") or Object:IsA("TextButton") then
        return "BackgroundColor3"
    elseif Object:IsA("ScrollingFrame") then
        return "ScrollBarImageColor3"
    elseif Object:IsA("UIStroke") then
        return "Color"
    elseif Object:IsA("TextLabel") or Object:IsA("TextBox") then
        return "TextColor3"
    elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
        return "ImageColor3"
    end
    return "BackgroundColor3"
end
local function AddThemeObject(Object, Type)
    if not NexusLib.ThemeObjects[Type] then
        NexusLib.ThemeObjects[Type] = {}
    end
    table.insert(NexusLib.ThemeObjects[Type], Object)
    Object[ReturnProperty(Object)] = NexusLib.Themes[NexusLib.SelectedTheme][Type]
    return Object
end
local function SetTheme()
    for TypeName, Objects in pairs(NexusLib.ThemeObjects) do
        for _, Object in ipairs(Objects) do
            Object[ReturnProperty(Object)] = NexusLib.Themes[NexusLib.SelectedTheme][TypeName]
        end
    end
end
local function PackColor(Color)
    return {R = math.floor(Color.R * 255), G = math.floor(Color.G * 255), B = math.floor(Color.B * 255)}
end
local function UnpackColor(Color)
    return Color3.fromRGB(Color.R, Color.G, Color.B)
end
local function LoadCfg(Config)
    local Data = HttpService:JSONDecode(Config)
    for flagName, flagValue in pairs(Data) do
        if NexusLib.Flags[flagName] then
            spawn(function()
                local flag = NexusLib.Flags[flagName]
                if flag.Type == "Colorpicker" then
                    flag:Set(UnpackColor(flagValue))
                else
                    flag:Set(flagValue)
                end
            end)
        end
    end
end
local function SaveCfg(Name)
    if not NexusLib.SaveConfig then return end
    local Data = {}
    for i, v in pairs(NexusLib.Flags) do
        if v and v.Save then
            if v.Type == "Colorpicker" then
                Data[i] = PackColor(v.Value)
            else
                Data[i] = v.Value
            end
        end
    end
    writefile(NexusLib.Folder .. "/" .. Name .. ".txt", HttpService:JSONEncode(Data))
end
local function AddDraggingFunctionality(DragPoint, Main)
    local Dragging, DragStart, StartPos
    AddConnection(DragPoint.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = Main.Position
        end
    end)
    AddConnection(DragPoint.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    AddConnection(UserInputService.InputChanged, function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - DragStart
            TweenService:Create(Main, TweenInfo.new(0.01, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end
CreateElement("Corner", function(Scale, Offset)
    local Corner = Create("UICorner", {
        CornerRadius = UDim.new(Scale or 0, Offset or 10)
    })
    return Corner
end)
CreateElement("Stroke", function(Color, Thickness)
    local Stroke = Create("UIStroke", {
        Color = Color or Color3.fromRGB(255, 255, 255),
        Thickness = Thickness or 1
    })
    return Stroke
end)
CreateElement("List", function(Scale, Offset)
    local List = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(Scale or 0, Offset or 0)
    })
    return List
end)
CreateElement("Padding", function(Bottom, Left, Right, Top)
    local Padding = Create("UIPadding", {
        PaddingBottom = UDim.new(0, Bottom or 4),
        PaddingLeft = UDim.new(0, Left or 4),
        PaddingRight = UDim.new(0, Right or 4),
        PaddingTop = UDim.new(0, Top or 4)
    })
    return Padding
end)
CreateElement("TFrame", function()
    local TFrame = Create("Frame", {
        BackgroundTransparency = 1
    })
    return TFrame
end)
CreateElement("Frame", function(Color)
    local Frame = Create("Frame", {
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    return Frame
end)
CreateElement("RoundFrame", function(Color, Scale, Offset)
    local Frame = Create("Frame", {
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(Scale, Offset)
        })
    })
    return Frame
end)
CreateElement("Button", function()
    local Button = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    return Button
end)
CreateElement("ScrollFrame", function(Color, Width)
    local ScrollFrame = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        ScrollBarImageColor3 = Color,
        BorderSizePixel = 0,
        ScrollBarThickness = Width or 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    return ScrollFrame
end)
CreateElement("Image", function(ImageID)
    local ImageNew = Create("ImageLabel", {
        Image = ImageID,
        BackgroundTransparency = 1
    })
    return ImageNew
end)
CreateElement("Label", function(Text, TextSize, Transparency)
    local Label = Create("TextLabel", {
        Text = Text or "",
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextTransparency = Transparency or 0,
        TextSize = TextSize or 15,
        Font = Enum.Font.Gotham,
        RichText = true,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    return Label
end)
local NotificationHolder = SetProps(SetChildren(MakeElement("TFrame"), {
    SetProps(MakeElement("List"), {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 5)
    })
}), {
    Position = UDim2.new(1, -25, 1, -25),
    Size = UDim2.new(0, 300, 1, -25),
    AnchorPoint = Vector2.new(1, 1),
    Parent = Nexus
})
function NexusLib:MakeNotification(NotificationConfig)
    spawn(function()
        NotificationConfig.Name = NotificationConfig.Name or "Notification"
        NotificationConfig.Content = NotificationConfig.Content or "Test"
        NotificationConfig.Image = NotificationConfig.Image or "rbxassetid://4384403532"
        NotificationConfig.Time = NotificationConfig.Time or 5
        local NotificationParent = SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = NotificationHolder
        })
        local NotificationFrame = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(25, 25, 25), 0, 10), {
            Parent = NotificationParent,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(1, -55, 0, 0),
            BackgroundTransparency = 0,
            AutomaticSize = Enum.AutomaticSize.Y
        }), {
            MakeElement("Stroke", Color3.fromRGB(93, 93, 93), 1.2),
            MakeElement("Padding", 12, 12, 12, 12),
            SetProps(MakeElement("Image", NotificationConfig.Image), {
                Size = UDim2.new(0, 20, 0, 20),
                ImageColor3 = Color3.fromRGB(240, 240, 240),
                Name = "Icon"
            }),
            SetProps(MakeElement("Label", NotificationConfig.Name, 15), {
                Size = UDim2.new(1, -30, 0, 20),
                Position = UDim2.new(0, 30, 0, 0),
                Font = Enum.Font.GothamBold,
                Name = "Title"
            }),
            SetProps(MakeElement("Label", NotificationConfig.Content, 14), {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 25),
                Font = Enum.Font.GothamSemibold,
                Name = "Content",
                AutomaticSize = Enum.AutomaticSize.Y,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextWrapped = true
            })
        })
        TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        wait(NotificationConfig.Time - 0.88)
        TweenService:Create(NotificationFrame.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
        TweenService:Create(NotificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.6}):Play()
        wait(0.3)
        TweenService:Create(NotificationFrame.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Transparency = 0.9}):Play()
        TweenService:Create(NotificationFrame.Title, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.4}):Play()
        TweenService:Create(NotificationFrame.Content, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.5}):Play()
        wait(0.05)
        NotificationFrame:TweenPosition(UDim2.new(1, 20, 0, 0), 'In', 'Quint', 0.8, true)
        wait(1.35)
        NotificationFrame:Destroy()
        NotificationParent:Destroy()
    end)
end
function NexusLib:Init()
    if NexusLib.SaveConfig then
        if isfile(NexusLib.Folder .. "/" .. game.GameId .. ".txt") then
            LoadCfg(readfile(NexusLib.Folder .. "/" .. game.GameId .. ".txt"))
            NexusLib:MakeNotification({
                Name = "Configuration",
                Content = "Auto-loaded configuration for the game " .. game.GameId .. ".",
                Time = 3
            })
        end
    end
end
local function CreateElementFunctions(Container)
    local ElementFunction = {}
    function ElementFunction:AddLabel(LabelConfig)
        LabelConfig = LabelConfig or {}
        LabelConfig.Name = LabelConfig.Name or "Label"
        LabelConfig.Default = LabelConfig.Default or ""
        local Label = {Value = LabelConfig.Default, Type = "Label"}
        local LabelFrame = AddThemeObject(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
            Size = UDim2.new(1, 0, 0, 38),
            Parent = Container
        }), "Second")
        local LabelLabel = AddThemeObject(SetProps(MakeElement("Label", LabelConfig.Name, 15), {
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            Font = Enum.Font.GothamBold,
            Name = "Content"
        }), "Text")
        LabelLabel.Parent = LabelFrame
        function Label:Set(Value)
            Label.Value = Value
            LabelLabel.Text = Value
        end
        Label:Set(Label.Value)
        return Label
    end
    function ElementFunction:AddToggle(ToggleConfig)
        ToggleConfig = ToggleConfig or {}
        ToggleConfig.Name = ToggleConfig.Name or "Toggle"
        ToggleConfig.Default = ToggleConfig.Default or false
        ToggleConfig.Callback = ToggleConfig.Callback or function() end
        ToggleConfig.Flag = ToggleConfig.Flag or nil
        ToggleConfig.Save = ToggleConfig.Save or false
        local Toggle = {Value = ToggleConfig.Default, Save = ToggleConfig.Save, Type = "Toggle"}
        local Click = SetProps(MakeElement("Button"), {
            Size = UDim2.new(1, 0, 1, 0)
        })
        local Checkmark = AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072721685"), {
            Name = "Checkmark",
            Size = UDim2.new(0, 20, 0, 20),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            ImageTransparency = Toggle.Value and 0 or 1
        }), "TextDark")
        local ToggleBox = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(1, -12, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5)
        }), {
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
            Checkmark
        })
        local ToggleFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
            Size = UDim2.new(1, 0, 0, 38),
            Parent = Container
        }), {
            AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name, 15), {
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.GothamBold,
                Name = "Content"
            }), "Text"),
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
            ToggleBox,
            Click
        }), "Second")
        AddConnection(Click.MouseEnter, function()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(NexusLib.Themes[NexusLib.SelectedTheme].Second.R * 255 + 3, NexusLib.Themes[NexusLib.SelectedTheme].Second.G * 255 + 3, NexusLib.Themes[NexusLib.SelectedTheme].Second.B * 255 + 3)}):Play()
        end)
        AddConnection(Click.MouseLeave, function()
            TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = NexusLib.Themes[NexusLib.SelectedTheme].Second}):Play()
        end)
        AddConnection(Click.Activated, function()
            Toggle.Value = not Toggle.Value
            TweenService:Create(Checkmark, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = Toggle.Value and 0 or 1}):Play()
            ToggleConfig.Callback(Toggle.Value)
            SaveCfg(game.GameId)
        end)
        if ToggleConfig.Flag then
            NexusLib.Flags[ToggleConfig.Flag] = Toggle
        end
        function Toggle:Set(Value)
            Toggle.Value = Value
            TweenService:Create(Checkmark, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = Value and 0 or 1}):Play()
            ToggleConfig.Callback(Toggle.Value)
        end
        Toggle:Set(Toggle.Value)
        return Toggle
    end
    function ElementFunction:AddSlider(SliderConfig)
        SliderConfig = SliderConfig or {}
        SliderConfig.Name = SliderConfig.Name or "Slider"
        SliderConfig.Min = SliderConfig.Min or 0
        SliderConfig.Max = SliderConfig.Max or 100
        SliderConfig.Increment = SliderConfig.Increment or 1
        SliderConfig.Default = SliderConfig.Default or 50
        SliderConfig.Callback = SliderConfig.Callback or function() end
        SliderConfig.Flag = SliderConfig.Flag or nil
        SliderConfig.Save = SliderConfig.Save or false
        local Slider = {Value = SliderConfig.Default, Save = SliderConfig.Save, Type = "Slider"}
        local Dragging = false
        local SliderDrag = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
            Size = UDim2.new(0, 0, 1, 0)
        }), {
            AddThemeObject(MakeElement("Stroke"), "Stroke")
        }), "Accent")
        local SliderLabel = AddThemeObject(SetProps(MakeElement("Label",""..SliderConfig.Default.."",14), {
            Size = UDim2.new(1, 0, 1, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Font = Enum.Font.GothamBold,
            TextTransparency = 0.4
        }), "Text")
        local SliderButton = SetProps(MakeElement("Button"), {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        })
        local SliderFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
            Size = UDim2.new(1, 0, 0, 38),
            Parent = Container
        }), {
            AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 15), {
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.GothamBold,
                Name = "Content"
            }), "Text"),
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
            SliderDrag,
            SliderLabel,
            SliderButton
        }), "Second")
        SliderLabel.Text = SliderConfig.Name .. ": " .. Slider.Value
        local function UpdateSlider()
            local Percentage = math.clamp((Slider.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1)
            TweenService:Create(SliderDrag, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(Percentage, 0, 1, 0)}):Play()
            SliderLabel.Text = SliderConfig.Name .. ": " .. Slider.Value
        end
        AddConnection(SliderButton.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
            end
        end)
        AddConnection(SliderButton.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end)
        AddConnection(UserInputService.InputChanged, function(Input)
            if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                local SizeScale = math.clamp((Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                Slider.Value = SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)
                Slider.Value = math.round(Slider.Value / SliderConfig.Increment) * SliderConfig.Increment
                UpdateSlider()
                SliderConfig.Callback(Slider.Value)
                SaveCfg(game.GameId)
            end
        end)
        function Slider:Set(Value)
            Slider.Value = math.clamp(math.round(Value / SliderConfig.Increment) * SliderConfig.Increment, SliderConfig.Min, SliderConfig.Max)
            UpdateSlider()
            SliderConfig.Callback(Slider.Value)
        end
        if SliderConfig.Flag then
            NexusLib.Flags[SliderConfig.Flag] = Slider
        end
        Slider:Set(Slider.Value)
        return Slider
    end
    function ElementFunction:AddDropdown(DropdownConfig)
        DropdownConfig = DropdownConfig or {}
        DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
        DropdownConfig.Options = DropdownConfig.Options or {}
        DropdownConfig.Default = DropdownConfig.Default or DropdownConfig.Options[1]
        DropdownConfig.Callback = DropdownConfig.Callback or function() end
        DropdownConfig.Flag = DropdownConfig.Flag or nil
        DropdownConfig.Save = DropdownConfig.Save or false
        local Dropdown = {Value = DropdownConfig.Default, Toggled = false, Options = DropdownConfig.Options, Save = DropdownConfig.Save, Type = "Dropdown"}
        local MaxElements = 5
        local DropdownList = SetProps(MakeElement("List"), {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 1)
        })
        local DropdownContainerHolder = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 4), {
            Size = UDim2.new(1, 0, 1, 0)
        }), {
            DropdownList,
            SetProps(MakeElement("Padding"), {
                PaddingTop = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingBottom = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2)
            })
        }), "Stroke")
        local DropdownContainer = SetProps(MakeElement("Frame"), {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        })
        DropdownContainer.Parent = DropdownContainerHolder
        local Click = SetProps(MakeElement("Button"), {
            Size = UDim2.new(1, 0, 1, 0)
        })
        local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
            Size = UDim2.new(1, 0, 0, 38),
            Parent = Container
        }), {
            AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 15), {
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.GothamBold,
                Name = "Content"
            }), "Text"),
            AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072706796"), {
                Size = UDim2.new(0, 20, 0, 20),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Rotation = 0,
                Name = "Ico"
            }), "Text"),
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
            SetProps(MakeElement("Frame"), {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                Name = "Line",
                Visible = false
            }),
            DropdownContainerHolder
        }), "Second")
        DropdownContainerHolder.Parent = DropdownFrame
        function Dropdown:Refresh(Options, Delete)
            Dropdown.Options = Options
            if Delete then
                Dropdown.Value = nil
                DropdownFrame.Content.Text = DropdownConfig.Name
            end
            for _, v in next, DropdownContainer:GetChildren() do
                if v:IsA("Frame") then
                    v:Destroy()
                end
            end
            for _, option in ipairs(Dropdown.Options) do
                local OptionFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 28)
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", option, 13), {
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.Gotham
                    }), "TextDark"),
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    SetProps(MakeElement("Button"), {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Name = "Click"
                    })
                }), "Second")
                OptionFrame.Parent = DropdownContainer
                local OptionClick = OptionFrame.Click
                AddConnection(OptionClick.MouseEnter, function()
                    TweenService:Create(OptionFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(NexusLib.Themes[NexusLib.SelectedTheme].Second.R * 255 + 3, NexusLib.Themes[NexusLib.SelectedTheme].Second.G * 255 + 3, NexusLib.Themes[NexusLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                end)
                AddConnection(OptionClick.MouseLeave, function()
                    TweenService:Create(OptionFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = NexusLib.Themes[NexusLib.SelectedTheme].Second}):Play()
                end)
                AddConnection(OptionClick.Activated, function()
                    Dropdown:Set(option)
                    Dropdown.Toggled = false
                    TweenService:Create(DropdownFrame.Ico, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    DropdownFrame.Line.Visible = false
                end)
            end
            DropdownContainerHolder.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y + 4)
        end
        function Dropdown:Set(Value)
            if not table.find(Dropdown.Options, Value) then
                Dropdown.Value = nil
                DropdownFrame.Content.Text = DropdownConfig.Name
                return
            end
            Dropdown.Value = Value
            DropdownFrame.Content.Text = Value
            DropdownConfig.Callback(Value)
            SaveCfg(game.GameId)
        end
        AddConnection(Click.Activated, function()
            Dropdown.Toggled = not Dropdown.Toggled
            DropdownFrame.Line.Visible = Dropdown.Toggled
            TweenService:Create(DropdownFrame.Ico, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = Dropdown.Toggled and 180 or 0}):Play()
            if #Dropdown.Options > MaxElements then
                TweenService:Create(DropdownFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, 38 + (MaxElements * 28)) or UDim2.new(1, 0, 0, 38)}):Play()
            else
                TweenService:Create(DropdownFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownList.AbsoluteContentSize.Y + 38) or UDim2.new(1, 0, 0, 38)}):Play()
            end
        end)
        Dropdown:Refresh(Dropdown.Options, false)
        Dropdown:Set(Dropdown.Value)
        if DropdownConfig.Flag then
            NexusLib.Flags[DropdownConfig.Flag] = Dropdown
        end
        return Dropdown
    end
    function ElementFunction:AddBind(BindConfig)
        BindConfig = BindConfig or {}
        BindConfig.Name = BindConfig.Name or "Bind"
        BindConfig.Default = BindConfig.Default or Enum.KeyCode.Unknown
        BindConfig.Hold = BindConfig.Hold or false
        BindConfig.Callback = BindConfig.Callback or function() end
        BindConfig.Flag = BindConfig.Flag or nil
        BindConfig.Save = BindConfig.Save or false
        local Bind = {Value = BindConfig.Default, Binding = false, Type = "Bind", Save = BindConfig.Save}
        local Holding = false
        local Click = SetProps(MakeElement("Button"), {
            Size = UDim2.new(1, 0, 1, 0)
        })
        local BindBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(1, -12, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5)
        }), {
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
            AddThemeObject(SetProps(MakeElement("Label", "NONE", 14), {
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Center,
                Name = "Value"
            }), "Text")
        }), "Main")
        local BindFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
            Size = UDim2.new(1, 0, 0, 38),
            Parent = Container
        }), {
            AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 15), {
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.GothamBold,
                Name = "Content"
            }), "Text"),
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
            BindBox,
            Click
        }), "Second")
        AddConnection(BindBox.Value:GetPropertyChangedSignal("Text"), function()
            TweenService:Create(BindBox, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, BindBox.Value.TextBounds.X + 16, 0, 24)}):Play()
        end)
        AddConnection(Click.Activated, function()
            if Bind.Binding then return end
            Bind.Binding = true
            BindBox.Value.Text = "..."
        end)
        AddConnection(UserInputService.InputBegan, function(Input)
            if UserInputService:GetFocusedTextBox() then return end
            if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
                if BindConfig.Hold then
                    Holding = true
                    BindConfig.Callback(Holding)
                else
                    BindConfig.Callback()
                end
            elseif Bind.Binding then
                local Key
                pcall(function()
                    if not CheckKey(BlacklistedKeys, Input.KeyCode) then
                        Key = Input.KeyCode
                    end
                end)
                pcall(function()
                    if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then
                        Key = Input.UserInputType
                    end
                end)
                Key = Key or Bind.Value
                Bind:Set(Key)
                SaveCfg(game.GameId)
            end
        end)
        AddConnection(UserInputService.InputEnded, function(Input)
            if Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value then
                if BindConfig.Hold and Holding then
                    Holding = false
                    BindConfig.Callback(Holding)
                end
            end
        end)
        AddConnection(Click.MouseEnter, function()
            TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(NexusLib.Themes[NexusLib.SelectedTheme].Second.R * 255 + 3, NexusLib.Themes[NexusLib.SelectedTheme].Second.G * 255 + 3, NexusLib.Themes[NexusLib.SelectedTheme].Second.B * 255 + 3)}):Play()
        end)
        AddConnection(Click.MouseLeave, function()
            TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = NexusLib.Themes[NexusLib.SelectedTheme].Second}):Play()
        end)
        function Bind:Set(Key)
            Bind.Binding = false
            Bind.Value = Key or Bind.Value
            Bind.Value = Bind.Value.Name or Bind.Value
            BindBox.Value.Text = Bind.Value
        end
        Bind:Set(BindConfig.Default)
        if BindConfig.Flag then
            NexusLib.Flags[BindConfig.Flag] = Bind
        end
        return Bind
    end
    function ElementFunction:AddTextbox(TextboxConfig)
        TextboxConfig = TextboxConfig or {}
        TextboxConfig.Name = TextboxConfig.Name or "Textbox"
        TextboxConfig.Default = TextboxConfig.Default or ""
        TextboxConfig.TextDisappear = TextboxConfig.TextDisappear or false
        TextboxConfig.Callback = TextboxConfig.Callback or function() end
        TextboxConfig.Flag = TextboxConfig.Flag or nil
        TextboxConfig.Save = TextboxConfig.Save or false
        local Textbox = {Value = TextboxConfig.Default, Type = "Textbox", Save = TextboxConfig.Save}
        local Click = SetProps(MakeElement("Button"), {
            Size = UDim2.new(1, 0, 1, 0)
        })
        local TextboxActual = AddThemeObject(Create("TextBox", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            PlaceholderColor3 = Color3.fromRGB(210,210,210),
            PlaceholderText = "Input",
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextSize = 14,
            ClearTextOnFocus = false
        }), "Text")
        local TextContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(1, -12, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5)
        }), {
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
            TextboxActual
        }), "Main")
        local TextboxFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
            Size = UDim2.new(1, 0, 0, 38),
            Parent = Container
        }), {
            AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name, 15), {
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.GothamBold,
                Name = "Content"
            }), "Text"),
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
            TextContainer,
            Click
        }), "Second")
        AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), function()
            TweenService:Create(TextContainer, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, TextboxActual.TextBounds.X + 16, 0, 24)}):Play()
        end)
        AddConnection(TextboxActual.FocusLost, function()
            Textbox.Value = TextboxActual.Text
            TextboxConfig.Callback(TextboxActual.Text)
            if TextboxConfig.TextDisappear then
                TextboxActual.Text = ""
            end
            SaveCfg(game.GameId)
        end)
        TextboxActual.Text = TextboxConfig.Default
        AddConnection(Click.MouseEnter, function()
            TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(NexusLib.Themes[NexusLib.SelectedTheme].Second.R * 255 + 3, NexusLib.Themes[NexusLib.SelectedTheme].Second.G * 255 + 3, NexusLib.Themes[NexusLib.SelectedTheme].Second.B * 255 + 3)}):Play()
        end)
        AddConnection(Click.MouseLeave, function()
            TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = NexusLib.Themes[NexusLib.SelectedTheme].Second}):Play()
        end)
        AddConnection(Click.Activated, function()
            TextboxActual:CaptureFocus()
        end)
        function Textbox:Set(Value)
            TextboxActual.Text = Value
            Textbox.Value = Value
        end
        if TextboxConfig.Flag then
            NexusLib.Flags[TextboxConfig.Flag] = Textbox
        end
        return Textbox
    end
    function ElementFunction:AddColorpicker(ColorpickerConfig)
        ColorpickerConfig = ColorpickerConfig or {}
        ColorpickerConfig.Name = ColorpickerConfig.Name or "Colorpicker"
        ColorpickerConfig.Default = ColorpickerConfig.Default or Color3.fromRGB(255,255,255)
        ColorpickerConfig.Callback = ColorpickerConfig.Callback or function() end
        ColorpickerConfig.Flag = ColorpickerConfig.Flag or nil
        ColorpickerConfig.Save = ColorpickerConfig.Save or false
        local Colorpicker = {Value = ColorpickerConfig.Default, Type = "Colorpicker", Save = ColorpickerConfig.Save, Toggled = false}
        local ColorInput, HueInput
        local DefaultH, DefaultS, DefaultV = Color3.toHSV(ColorpickerConfig.Default)
        local ColorH, ColorS, ColorV = DefaultH, DefaultS, DefaultV
        local ColorSelection = Create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(DefaultS, 0, 1 - DefaultV, 0),
            ScaleType = Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://4805639000"
        })
        local HueSelection = Create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0.5, 0, 1 - DefaultH, 0),
            ScaleType = Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://4805639000"
        })
        local Color = Create("ImageLabel", {
            Size = UDim2.new(1, -25, 1, 0),
            Visible = false,
            Image = "rbxassetid://4155801252"
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
            ColorSelection
        })
        local Hue = Create("Frame", {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -20, 0, 0),
            Visible = false
        }, {
            Create("UIGradient", {Rotation = 270, Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
                ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),
                ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),
                ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),
                ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))
            }}),
            Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
            HueSelection
        })
        local ColorpickerContainer = Create("Frame", {
            Position = UDim2.new(0, 0, 0, 32),
            Size = UDim2.new(1, 0, 1, -32),
            BackgroundTransparency = 1,
            ClipsDescendants = true
        }, {
            Hue,
            Color,
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 35),
                PaddingRight = UDim.new(0, 35),
                PaddingBottom = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 17)
            })
        })
        local Click = SetProps(MakeElement("Button"), {
            Size = UDim2.new(1, 0, 1, 0)
        })
        local ColorpickerBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(1, -12, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5)
        }), {
            AddThemeObject(MakeElement("Stroke"), "Stroke")
        }), "Main")
        local ColorpickerFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
            Size = UDim2.new(1, 0, 0, 38),
            Parent = Container
        }), {
            SetProps(SetChildren(MakeElement("TFrame"), {
                AddThemeObject(SetProps(MakeElement("Label", ColorpickerConfig.Name, 15), {
                    Size = UDim2.new(1, -12, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    Font = Enum.Font.GothamBold,
                    Name = "Content"
                }), "Text"),
                ColorpickerBox,
                Click,
                AddThemeObject(SetProps(MakeElement("Frame"), {
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, -1),
                    Name = "Line",
                    Visible = false
                }), "Stroke"),
            }), {
                Size = UDim2.new(1, 0, 0, 38),
                ClipsDescendants = true,
                Name = "F"
            }),
            ColorpickerContainer,
            AddThemeObject(MakeElement("Stroke"), "Stroke"),
        }), "Second")
        local function UpdateColorPicker()
            ColorpickerBox.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
            Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
            Colorpicker.Value = ColorpickerBox.BackgroundColor3
            ColorpickerConfig.Callback(Colorpicker.Value)
            SaveCfg(game.GameId)
        end
        UpdateColorPicker()
        AddConnection(Click.Activated, function()
            Colorpicker.Toggled = not Colorpicker.Toggled
            TweenService:Create(ColorpickerFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 148) or UDim2.new(1, 0, 0, 38)}):Play()
            Color.Visible = Colorpicker.Toggled
            Hue.Visible = Colorpicker.Toggled
            ColorpickerFrame.F.Line.Visible = Colorpicker.Toggled
        end)
        AddConnection(Color.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if ColorInput then
                    ColorInput:Disconnect()
                end
                ColorInput = AddConnection(RunService.RenderStepped, function()
                    local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
                    local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
                    ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
                    ColorS = ColorX
                    ColorV = 1 - ColorY
                    UpdateColorPicker()
                end)
            end
        end)
        AddConnection(Color.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if ColorInput then
                    ColorInput:Disconnect()
                end
            end
        end)
        AddConnection(Hue.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if HueInput then
                    HueInput:Disconnect()
                end
                HueInput = AddConnection(RunService.RenderStepped, function()
                    local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
                    HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
                    ColorH = 1 - HueY
                    UpdateColorPicker()
                end)
            end
        end)
        AddConnection(Hue.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if HueInput then
                    HueInput:Disconnect()
                end
            end
        end)
        function Colorpicker:Set(Value)
            Colorpicker.Value = Value
            ColorH, ColorS, ColorV = Color3.toHSV(Value)
            ColorpickerBox.BackgroundColor3 = Colorpicker.Value
            ColorSelection.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
            HueSelection.Position = UDim2.new(0.5, 0, 1 - ColorH, 0)
            ColorpickerConfig.Callback(Colorpicker.Value)
        end
        Colorpicker:Set(Colorpicker.Value)
        if ColorpickerConfig.Flag then
            NexusLib.Flags[ColorpickerConfig.Flag] = Colorpicker
        end
        return Colorpicker
    end
    function ElementFunction:AddSection(SectionConfig)
        SectionConfig = SectionConfig or {}
        SectionConfig.Name = SectionConfig.Name or "Section"
        local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 0, 26),
            Parent = Container
        }), {
            AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name, 14), {
                Size = UDim2.new(1, -12, 0, 16),
                Position = UDim2.new(0, 0, 0, 3),
                Font = Enum.Font.GothamSemibold
            }), "TextDark"),
            SetChildren(SetProps(MakeElement("TFrame"), {
                AnchorPoint = Vector2.new(0, 0),
                Size = UDim2.new(1, 0, 1, -24),
                Position = UDim2.new(0, 0, 0, 23),
                Name = "Holder"
            }), {
                MakeElement("List", 0, 6)
            }),
        })
        AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 31)
            SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
        end)
        return CreateElementFunctions(SectionFrame.Holder)
    end
    return ElementFunction
end
function NexusLib:CreateWindow(WindowConfig)
    WindowConfig = WindowConfig or {}
    WindowConfig.Name = WindowConfig.Name or "Nexus Lib"
    WindowConfig.Theme = WindowConfig.Theme or "Dark"
    WindowConfig.SaveConfig = WindowConfig.SaveConfig or false
    WindowConfig.ToggleKey = WindowConfig.ToggleKey or Enum.KeyCode.RightShift
    WindowConfig.ShowIcon = WindowConfig.ShowIcon or false
    WindowConfig.Icon = WindowConfig.Icon or ""
    NexusLib.SelectedTheme = WindowConfig.Theme
    NexusLib.SaveConfig = WindowConfig.SaveConfig
    NexusLib.Folder = WindowConfig.ConfigFolder or "NexusLib_Configs"
    if NexusLib.SaveConfig then
        if not isfolder(NexusLib.Folder) then
            makefolder(NexusLib.Folder)
        end
    end
    local FirstTab = true
    local Minimized = false
    local UIHidden = false
    local TabHolder = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 4), {
        Size = UDim2.new(1, 0, 1, -50)
    }), {
        MakeElement("List"),
        MakeElement("Padding", 8, 0, 0, 8)
    }), "Divider")
    AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
    end)
    local CloseBtn = SetChildren(SetProps(MakeElement("Button"), {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1
    }), {
        AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072725342"), {
            Position = UDim2.new(0, 9, 0, 6),
            Size = UDim2.new(0, 18, 0, 18)
        }), "Text")
    })
    local MinimizeBtn = SetChildren(SetProps(MakeElement("Button"), {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1
    }), {
        AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072719338"), {
            Position = UDim2.new(0, 9, 0, 6),
            Size = UDim2.new(0, 18, 0, 18),
            Name = "Ico"
        }), "Text")
    })
    local DragPoint = SetProps(MakeElement("TFrame"), {
        Size = UDim2.new(1, 0, 0, 50)
    })
    local WindowStuff = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10), {
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 0, 0, 50)
    }), {
        AddThemeObject(SetProps(MakeElement("Frame"), {
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, 0)
        }), "Second"),
        AddThemeObject(SetProps(MakeElement("Frame"), {
            Size = UDim2.new(0, 10, 1, 0),
            Position = UDim2.new(1, -10, 0, 0)
        }), "Second"),
        AddThemeObject(SetProps(MakeElement("Frame"), {
            Size = UDim2.new(0, 1, 1, 0),
            Position = UDim2.new(1, -1, 0, 0)
        }), "Stroke"),
        TabHolder,
        SetChildren(SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 0, 1, -50)
        }), {
            AddThemeObject(SetProps(MakeElement("Frame"), {
                Size = UDim2.new(1, 0, 0, 1)
            }), "Stroke"),
            AddThemeObject(SetChildren(SetProps(MakeElement("Frame"), {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 32, 0, 32),
                Position = UDim2.new(0, 10, 0.5, 0)
            }), {
                SetProps(MakeElement("Image", "https://www.roblox.com/headshot-thumbnail/image?userId=".. LocalPlayer.UserId .."&width=420&height=420&format=png"), {
                    Size = UDim2.new(1, 0, 1, 0)
                }),
                AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://4031889928"), {
                    Size = UDim2.new(1, 0, 1, 0),
                }), "Second"),
                MakeElement("Corner", 1)
            }), "Divider"),
            SetChildren(SetProps(MakeElement("TFrame"), {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 32, 0, 32),
                Position = UDim2.new(0, 10, 0.5, 0)
            }), {
                AddThemeObject(MakeElement("Stroke"), "Stroke"),
                MakeElement("Corner", 1)
            }),
            AddThemeObject(SetProps(MakeElement("Label", LocalPlayer.DisplayName, 13), {
                Size = UDim2.new(1, -60, 0, 13),
                Position = UDim2.new(0, 50, 0, 12),
                Font = Enum.Font.GothamBold,
                ClipsDescendants = true
            }), "Text")
        }),
    }), "Second")
    local WindowName = AddThemeObject(SetProps(MakeElement("Label", WindowConfig.Name, 14), {
        Size = UDim2.new(1, -30, 2, 0),
        Position = UDim2.new(0, 25, 0, -24),
        Font = Enum.Font.GothamBlack,
        TextSize = 20
    }), "Text")
    local WindowTopBarLine = AddThemeObject(SetProps(MakeElement("Frame"), {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1)
    }), "Stroke")
    local MainWindow = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10), {
        Parent = Nexus,
        Position = UDim2.new(0.5, -307, 0.5, -172),
        Size = UDim2.new(0, 615, 0, 344),
        ClipsDescendants = true
    }), {
        SetChildren(SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 0, 50),
            Name = "TopBar"
        }), {
            WindowName,
            WindowTopBarLine,
            AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 7), {
                Size = UDim2.new(0, 70, 0, 30),
                Position = UDim2.new(1, -90, 0, 10)
            }), {
                AddThemeObject(MakeElement("Stroke"), "Stroke"),
                AddThemeObject(SetProps(MakeElement("Frame"), {
                    Size = UDim2.new(0, 1, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0)
                }), "Stroke"),
                CloseBtn,
                MinimizeBtn
            }), "Second"),
        }),
        DragPoint,
        WindowStuff
    }), "Main")
    if WindowConfig.ShowIcon then
        WindowName.Position = UDim2.new(0, 50, 0, -24)
        local WindowIcon = SetProps(MakeElement("Image", WindowConfig.Icon), {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 25, 0, 15)
        })
        WindowIcon.Parent = MainWindow.TopBar
    end
    AddDraggingFunctionality(DragPoint, MainWindow)
    AddConnection(CloseBtn.Activated, function()
        MainWindow.Visible = false
        UIHidden = true
        NexusLib:MakeNotification({
            Name = "Interface Hidden",
            Content = "Tap " .. tostring(WindowConfig.ToggleKey) .. " to reopen the interface",
            Time = 3
        })
    end)
    AddConnection(UserInputService.InputBegan, function(Input)
        if Input.KeyCode == WindowConfig.ToggleKey and UIHidden then
            MainWindow.Visible = true
            UIHidden = false
        end
    end)
    AddConnection(MinimizeBtn.Activated, function()
        if Minimized then
            TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 615, 0, 344)}):Play()
            MinimizeBtn.Ico.Image = "rbxassetid://7072719338"
            wait(0.02)
            MainWindow.ClipsDescendants = false
            WindowStuff.Visible = true
            WindowTopBarLine.Visible = true
        else
            MainWindow.ClipsDescendants = true
            WindowTopBarLine.Visible = false
            WindowStuff.Visible = false
            MinimizeBtn.Ico.Image = "rbxassetid://7072720870"
            TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 615, 0, 50)}):Play()
        end
        Minimized = not Minimized
    end)
    local TabFunction = {}
    function TabFunction:AddTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "New Tab"
        TabConfig.Icon = TabConfig.Icon or ""
        local TabFrame = SetChildren(SetProps(MakeElement("Button"), {
            Size = UDim2.new(1, 0, 0, 30),
            Parent = TabHolder
        }), {
            AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 14), {
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.GothamSemibold
            }), "Text"),
            AddThemeObject(SetProps(MakeElement("Image", TabConfig.Icon), {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, -8, 0, 5)
            }), "TextDark")
        })
        local TabContainer = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 4), {
            Size = UDim2.new(1, -150, 1, -50),
            Position = UDim2.new(0, 150, 0, 50),
            Parent = MainWindow,
        }), {
            MakeElement("List", 0, 6),
            MakeElement("Padding", 8, 8, 8, 8)
        }), "Divider")
        AddConnection(TabContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabContainer.UIListLayout.AbsoluteContentSize.Y + 14)
        end)
        if FirstTab then
            FirstTab = false
            TabFrame.BackgroundColor3 = NexusLib.Themes[NexusLib.SelectedTheme].Second
            TabContainer.Visible = true
        else
            TabFrame.BackgroundColor3 = NexusLib.Themes[NexusLib.SelectedTheme].Main
            TabContainer.Visible = false
        end
        AddConnection(TabFrame.Activated, function()
            for i, v in next, TabHolder:GetChildren() do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = NexusLib.Themes[NexusLib.SelectedTheme].Main
                end
            end
            for i, v in next, MainWindow:GetChildren() do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabFrame.BackgroundColor3 = NexusLib.Themes[NexusLib.SelectedTheme].Second
            TabContainer.Visible = true
        end)
        return CreateElementFunctions(TabContainer)
    end
    return TabFunction
end
function NexusLib:Destroy()
    Nexus:Destroy()
end
function NexusLib:SetTheme(ThemeName)
    NexusLib.SelectedTheme = ThemeName or "Dark"
    SetTheme()
end
return NexusLib
