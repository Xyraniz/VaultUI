local library = {
    Elements = {},
    Themes = {},
    ThemeObjects = {},
    Flags = {},
    Connections = {},
    SelectedTheme = "Dark",
    Folder = "GamerLib_Configs",
    SaveConfig = true
}

library.Themes = {
    Dark = {
        Main = Color3.fromRGB(30, 30, 30),
        Second = Color3.fromRGB(40, 40, 40),
        Stroke = Color3.fromRGB(60, 60, 60),
        Divider = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Accent = Color3.fromRGB(102, 41, 255)
    },
    Light = {
        Main = Color3.fromRGB(240, 240, 240),
        Second = Color3.fromRGB(220, 220, 220),
        Stroke = Color3.fromRGB(180, 180, 180),
        Divider = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(30, 30, 30),
        TextDark = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(44, 120, 224)
    }
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local gui = Instance.new("ScreenGui")
gui.Name = "GamerLib"
if syn then
    if pcall(function() syn.protect_gui(gui) end) then
        gui.Parent = game.CoreGui
    else
        gui.Parent = gethui() or game.CoreGui
    end
else
    gui.Parent = gethui() or game.CoreGui
end

if type(gethui) == "function" then
    for _, Interface in ipairs(gethui():GetChildren()) do
        if Interface.Name == gui.Name and Interface ~= gui then
            pcall(function() Interface:Destroy() end)
        end
    end
else
    for _, Interface in ipairs(game.CoreGui:GetChildren()) do
        if Interface.Name == gui.Name and Interface ~= gui then
            pcall(function() Interface:Destroy() end)
        end
    end
end

function library:IsRunning()
    if type(gethui) == "function" then
        return gui.Parent == gethui()
    else
        return gui.Parent == game:GetService("CoreGui")
    end
end

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

local function tableFind(t, value)
    for i, v in pairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

local function AddConnection(Signal, Function)
    if not gui or not gui.Parent then
        return nil
    end
    if not library:IsRunning() then
        return nil
    end

    if not Signal or typeof(Signal) ~= "RBXScriptSignal" or not Signal.Connect then return nil end

    local success, connection = pcall(function()
        return Signal:Connect(Function)
    end)

    if success and connection then
        table.insert(library.Connections, connection)

        local destroyConnection
        destroyConnection = gui.Destroying:Connect(function()
            if connection.Connected then
                connection:Disconnect()
            end
            if destroyConnection then
                destroyConnection:Disconnect()
            end
        end)

        return connection
    end

    return nil
end

local ConnectionCleanup
if gui then
    ConnectionCleanup = AddConnection(gui.Destroying, function()
        for _, Connection in ipairs(library.Connections) do
            Connection:Disconnect()
        end
        library.Connections = {}
    end)
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
    library.Elements[ElementName] = function(...)
        return ElementFunction(...)
    end
end

local function MakeElement(ElementName, ...)
    local ElementFunc = library.Elements[ElementName]
    if ElementFunc then
        return ElementFunc(...)
    end
    warn("Element not found:", ElementName)
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

local function Round(Number, Factor)
    return math.floor(Number / Factor + 0.5) * Factor
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
    if not library.ThemeObjects[Type] then
        library.ThemeObjects[Type] = {}
    end
    table.insert(library.ThemeObjects[Type], Object)
    Object[ReturnProperty(Object)] = library.Themes[library.SelectedTheme][Type]
    return Object
end

local function SetTheme()
    for TypeName, Objects in pairs(library.ThemeObjects) do
        for _, Object in ipairs(Objects) do
            Object[ReturnProperty(Object)] = library.Themes[library.SelectedTheme][TypeName]
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
    local success, data = pcall(function()
        return HttpService:JSONDecode(Config)
    end)

    if not success or typeof(data) ~= "table" then 
        warn("Invalid config data")
        return 
    end

    for flagName, flagValue in pairs(data) do
        if library.Flags[flagName] then
            spawn(function() 
                pcall(function()
                    local flag = library.Flags[flagName]
                    if flag.Type == "Colorpicker" then
                        flag:Set(UnpackColor(flagValue))
                    else
                        flag:Set(flagValue)
                    end    
                end)
            end)
        end
    end
end

local function SaveCfg(Name)
    if not library.SaveConfig then return end

    local success, result = pcall(function()
        local Data = {}
        for i,v in pairs(library.Flags) do
            if v and v.Save then
                if v.Type == "Colorpicker" then
                    Data[i] = PackColor(v.Value)
                else
                    Data[i] = v.Value
                end
            end    
        end

        if not isfolder(library.Folder) then
            makefolder(library.Folder)
        end

        local jsonData = HttpService:JSONEncode(Data)
        pcall(writefile, library.Folder .. "/" .. Name .. ".txt", jsonData)
        return true
    end)

    if not success then
        warn("Error saving config:", result)
    end
end

local function AddDraggingFunctionality(DragPoint, Main)
    local Dragging = false
    local DragStart, StartPos
    local CurrentInput

    local function Update(input)
        if not Dragging or not DragStart or not StartPos then return end
        if not workspace.CurrentCamera then return end
        if CurrentInput and input ~= CurrentInput then return end

        local delta = input.Position - DragStart
        local viewport = workspace.CurrentCamera.ViewportSize

        local newX = StartPos.X.Offset + delta.X
        local newY = StartPos.Y.Offset + delta.Y

        newX = math.clamp(newX, 0, viewport.X - Main.AbsoluteSize.X)
        newY = math.clamp(newY, 0, viewport.Y - Main.AbsoluteSize.Y)

        Main.Position = UDim2.new(0, newX, 0, newY)
    end

    AddConnection(DragPoint.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if not Dragging then
                Dragging = true
                CurrentInput = input
                DragStart = input.Position
                StartPos = Main.Position

                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local connection
                    connection = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            CurrentInput = nil
                            if connection then
                                connection:Disconnect()
                            end
                        end
                    end)
                end
            end
        end
    end)

    AddConnection(DragPoint.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if CurrentInput == input then
                Dragging = false
                CurrentInput = nil
            end
        end
    end)

    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if Dragging and CurrentInput then
            if (input.UserInputType == Enum.UserInputType.MouseMovement and CurrentInput.UserInputType == Enum.UserInputType.MouseButton1) or 
               (input.UserInputType == Enum.UserInputType.Touch and CurrentInput.UserInputType == Enum.UserInputType.Touch and input == CurrentInput) then
                Update(input)
            end
        end
    end)

    local function cleanup()
        Dragging = false
        CurrentInput = nil
        if connection then
            connection:Disconnect()
        end
    end

    Main.AncestryChanged:Connect(function()
        if not Main.Parent then
            cleanup()
        end
    end)

    DragPoint.AncestryChanged:Connect(function()
        if not DragPoint.Parent then
            cleanup()
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

library.rainbowI = 0

library.rainbowVal = Color3.fromRGB(255, 0, 0)

coroutine.wrap(function()
    while true do
        for i = 0, 359 do
            library.rainbowI = i / 359
            library.rainbowVal = Color3.fromHSV(library.rainbowI, 1, 1)
            wait()
        end
    end
end)()

gui.Enabled = false

local gradientColor = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 41, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(142, 61, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 74, 255))}

local gradientSection = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 41, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(122, 41, 255))}

local shadowGradient = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 36, 36))}

local main = MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Main, 0, 10)

SetProps(main, {

Name = "main",

Parent = gui,

Position = UDim2.new(0.5, -200, 0.5, -135),

Size = UDim2.new(0, 400, 0, 270),

})

local Search = SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 4), {

Name = "Search",

Position = UDim2.new(0, 4, 0, 46),

Size = UDim2.new(1, -8, 0, 26),

}), {

AddThemeObject(MakeElement("Stroke"), "Stroke"),

SetProps(MakeElement("TextBox"), {

Name = "textbox",

BackgroundTransparency = 1,

Position = UDim2.new(0, 30, 0, 0),

Size = UDim2.new(1, -30, 1, 0),

Font = Enum.Font.Gotham,

PlaceholderText = "Search",

Text = "",

TextColor3 = library.Themes[library.SelectedTheme].Text,

TextSize = 14,

TextXAlignment = Enum.TextXAlignment.Left,

}),

SetChildren(SetProps(MakeElement("Image", "http://www.roblox.com/asset/?id=4645651350"), {

Name = "icon",

BackgroundTransparency = 1,

Position = UDim2.new(0, 2, 0, 1),

Size = UDim2.new(0, 24, 0, 24),

}), {

Instance.new("UIGradient", {

Color = gradientColor,

Rotation = 45,

})

})

})

Search.Parent = main

local border = SetProps(MakeElement("Frame"), {

Name = "border",

BackgroundColor3 = library.Themes[library.SelectedTheme].Second,

BorderColor3 = library.Themes[library.SelectedTheme].Stroke,

BorderSizePixel = 1,

Position = UDim2.new(0, 5, 0, 78),

Size = UDim2.new(0, 390, 0, 186),

})

border.Parent = main

local shadow1 = SetProps(MakeElement("Frame"), {

Name = "shadow",

BackgroundColor3 = Color3.fromRGB(255, 255, 255),

BackgroundTransparency = 0.1,

BorderSizePixel = 0,

Position = UDim2.new(0, 0, 1, -8),

Size = UDim2.new(1, 0, 0, 8),

})

shadow1.Parent = border

Instance.new("UIGradient", shadow1).Color = shadowGradient

Instance.new("UIGradient", shadow1).Rotation = 270

Instance.new("UIGradient", shadow1).Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}

local shadow2 = SetProps(MakeElement("Frame"), {

Name = "shadow",

BackgroundColor3 = Color3.fromRGB(255, 255, 255),

BackgroundTransparency = 0.1,

BorderSizePixel = 0,

Size = UDim2.new(1, 0, 0, 8),

})

shadow2.Parent = border

Instance.new("UIGradient", shadow2).Color = shadowGradient

Instance.new("UIGradient", shadow2).Rotation = 90

Instance.new("UIGradient", shadow2).Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}

local bar = SetProps(MakeElement("Frame"), {

Name = "bar",

BorderSizePixel = 0,

BackgroundColor3 = Color3.fromRGB(255, 255, 255),

Size = UDim2.new(1, 0, 0, 4),

Position = UDim2.new(0, 0, 0, 0),

})

bar.Parent = main

Instance.new("UIGradient", bar).Color = gradientColor

local bottom = SetProps(MakeElement("Frame"), {

Name = "bottom",

BorderSizePixel = 0,

BackgroundColor3 = library.Themes[library.SelectedTheme].Second,

Position = UDim2.new(0, 0, 0, 4),

Size = UDim2.new(1, 0, 0, 34),

})

bottom.Parent = main

local shadow3 = SetProps(MakeElement("Frame"), {

BackgroundTransparency = 0.1,

BackgroundColor3 = Color3.fromRGB(255, 255, 255),

BorderSizePixel = 0,

Name = "shadow",

Position = UDim2.new(0, 0, 1, 0),

Size = UDim2.new(1, 0, 0, 8),

})

shadow3.Parent = bottom

local title = SetProps(MakeElement("Label", "Gamer Lib", 14), {

Name = "Title",

Position = UDim2.new(0, 10, 0.5, -10),

Size = UDim2.new(0, 70, 0, 24),

Font = Enum.Font.GothamSemibold,

TextColor3 = Color3.fromRGB(255, 255, 255),

})

title.Parent = bottom

Instance.new("UIGradient", title).Color = gradientColor

local topcontainer = SetProps(MakeElement("TFrame"), {

Name = "topcontainer",

BackgroundTransparency = 1,

Position = UDim2.new(0, 88, 0, 9),

Size = UDim2.new(1, -90, 0.73, 0),

})

topcontainer.Parent = bottom

MakeElement("List", 0, 2).Parent = topcontainer

local modal = Instance.new("TextButton", main)

modal.Modal = true

modal.BackgroundTransparency = 1

modal.Text = ""

AddDraggingFunctionality(bottom, main)

Search.textbox:GetPropertyChangedSignal("Text"):Connect(function()

local Entry = Search.textbox.Text:lower()

if Entry ~= "" then

for i,v in next, library.currentSection:GetChildren() do

if not v:IsA("UIPadding") and not v:IsA("UIListLayout") then

local label = v:FindFirstChild("Content")

local button = v:FindFirstChild("button")

local find = false

if label and label.Text:lower():sub(1, #Entry) == Entry then

v.Visible = true

find = true

end

if button and button:FindFirstChild("Content") and button.Content.Text:lower():sub(1, #Entry) == Entry then

v.Visible = true

find = true

end

if not find then

v.Visible = false

end

end

end

elseif library.currentSection then

for i,v in next, library.currentSection:GetChildren() do

if not v:IsA("UIPadding") and not v:IsA("UIListLayout") then

v.Visible = true

end

end

end

library.currentSectionObject:Update()

end)

local function GetElements(Container)

local elements = {

Label = function(self, labelName)

SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Name = "holder",

Parent = Container,

Size = UDim2.new(1, 0, 0, 38),

}), {

AddThemeObject(SetProps(MakeElement("Label", labelName, 15), {

Size = UDim2.new(1, -12, 1, 0),

Position = UDim2.new(0, 12, 0, 0),

Font = Enum.Font.GothamBold,

Name = "Content"

}), "Text"),

AddThemeObject(MakeElement("Stroke"), "Stroke"),

})

end,

Toggle = function(self, toggleName, callback)

local callback = callback or function() end

local Toggle = {Value = false, Type = "Toggle", Save = true}

local Click = MakeElement("Button")

local ToggleBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Main, 0, 4), {

Size = UDim2.new(0, 24, 0, 24),

Position = UDim2.new(1, -12, 0.5, 0),

AnchorPoint = Vector2.new(1, 0.5)

}), {

AddThemeObject(MakeElement("Stroke"), "Stroke"),

AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072721685"), {

Size = UDim2.new(0, 20, 0, 20),

Position = UDim2.new(0, 2, 0, 2),

ImageTransparency = 0.5,

Name = "Ico"

}), "Text")

}), "Main")

local ToggleFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Size = UDim2.new(1, 0, 0, 38),

Parent = Container

}), {

AddThemeObject(SetProps(MakeElement("Label", toggleName, 15), {

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

TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 3, library.Themes[library.SelectedTheme].Second.G * 255 + 3, library.Themes[library.SelectedTheme].Second.B * 255 + 3)}):Play()

end)

AddConnection(Click.MouseLeave, function()

TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = library.Themes[library.SelectedTheme].Second}):Play()

end)

AddConnection(Click.MouseButton1Up, function()

TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 3, library.Themes[library.SelectedTheme].Second.G * 255 + 3, library.Themes[library.SelectedTheme].Second.B * 255 + 3)}):Play()

end)

AddConnection(Click.MouseButton1Down, function()

TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 6, library.Themes[library.SelectedTheme].Second.G * 255 + 6, library.Themes[library.SelectedTheme].Second.B * 255 + 6)}):Play()

end)

AddConnection(Click.MouseButton1Click, function()

Toggle.Value = not Toggle.Value

TweenService:Create(ToggleBox.Ico, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = Toggle.Value and 0 or 0.5}):Play()

callback(Toggle.Value)

SaveCfg(game.GameId)

end)

library.Flags[toggleName] = Toggle

return Toggle

end,

Box = function(self, boxName, callback)

local callback = callback or function() end

local Textbox = {Value = "", Type = "Textbox", Save = true}

local Click = MakeElement("Button")

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

local TextContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Main, 0, 4), {

Size = UDim2.new(0, 24, 0, 24),

Position = UDim2.new(1, -12, 0.5, 0),

AnchorPoint = Vector2.new(1, 0.5)

}), {

AddThemeObject(MakeElement("Stroke"), "Stroke"),

TextboxActual

}), "Main")

local TextboxFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Size = UDim2.new(1, 0, 0, 38),

Parent = Container

}), {

AddThemeObject(SetProps(MakeElement("Label", boxName, 15), {

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

callback(TextboxActual.Text)

SaveCfg(game.GameId)

end)

AddConnection(Click.MouseEnter, function()

TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 3, library.Themes[library.SelectedTheme].Second.G * 255 + 3, library.Themes[library.SelectedTheme].Second.B * 255 + 3)}):Play()

end)

AddConnection(Click.MouseLeave, function()

TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = library.Themes[library.SelectedTheme].Second}):Play()

end)

AddConnection(Click.MouseButton1Up, function()

TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 3, library.Themes[library.SelectedTheme].Second.G * 255 + 3, library.Themes[library.SelectedTheme].Second.B * 255 + 3)}):Play()

TextboxActual:CaptureFocus()

end)

AddConnection(Click.MouseButton1Down, function()

TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 6, library.Themes[library.SelectedTheme].Second.G * 255 + 6, library.Themes[library.SelectedTheme].Second.B * 255 + 6)}):Play()

end)

library.Flags[boxName] = Textbox

return Textbox

end,

Slider = function(self, sliderName, properties, callback)

local callback = callback or function() end

properties = properties or {}

local min = properties.min or 0

local max = properties.max or 100

local increment = properties.precise and 0.01 or 1

local default = properties.default or min

local Slider = {Value = default, Type = "Slider", Save = true}

local dragging = false

local SliderBar = AddThemeObject(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Size = UDim2.new(1, 0, 0, 38),

Parent = Container

}), "Second")

local SliderFill = AddThemeObject(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Accent, 0, 5), {

Size = UDim2.new((default or min) / max, 0, 1, 0),

}), "Accent")

local SliderLabel = AddThemeObject(SetProps(MakeElement("Label", sliderName, 15), {

Size = UDim2.new(1, -12, 1, 0),

Position = UDim2.new(0, 12, 0, 0),

Font = Enum.Font.GothamBold,

Name = "Content"

}), "Text")

local ValueLabel = AddThemeObject(SetProps(MakeElement("Label", tostring(default), 13), {

Size = UDim2.new(1, 0, 1, 0),

BackgroundTransparency = 1,

TextSize = 13,

Font = Enum.Font.GothamBold,

Name = "Value",

TextColor3 = library.Themes[library.SelectedTheme].Accent

}), "Accent")

SetChildren(SliderBar, {

SliderLabel,

AddThemeObject(MakeElement("Stroke"), "Stroke"),

SliderFill,

ValueLabel

})

AddConnection(SliderBar.InputBegan, function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = true

end

end)

AddConnection(SliderBar.InputEnded, function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = false

end

end)

AddConnection(UserInputService.InputChanged, function(input)

if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

local SizeScale = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)

Slider.Value = min + ((max - min) * SizeScale)

ValueLabel.Text = tostring(Round(Slider.Value, increment))

TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(SizeScale, 0, 1, 0)}):Play()

callback(Slider.Value)

SaveCfg(game.GameId)

end

end)

library.Flags[sliderName] = Slider

return Slider

end,

Bind = function(self, bindName, defaultKey, callback)

local callback = callback or function() end

local Bind = {Value = defaultKey, Binding = false, Type = "Bind", Save = true}

local Holding = false

local Click = MakeElement("Button")

local BindBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Main, 0, 4), {

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

local BindFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Size = UDim2.new(1, 0, 0, 38),

Parent = Container

}), {

AddThemeObject(SetProps(MakeElement("Label", bindName, 15), {

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

AddConnection(Click.InputEnded, function(Input)

if Input.UserInputType == Enum.UserInputType.MouseButton1 then

if Bind.Binding then return end

Bind.Binding = true

BindBox.Value.Text = "..."

end

end)

AddConnection(UserInputService.InputBegan, function(Input)

if UserInputService:GetFocusedTextBox() then return end

if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then

if false then

Holding = true

callback(Holding)

else

callback()

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

if false and Holding then

Holding = false

callback(Holding)

end

end

end)

AddConnection(Click.MouseEnter, function()

TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 3, library.Themes[library.SelectedTheme].Second.G * 255 + 3, library.Themes[library.SelectedTheme].Second.B * 255 + 3)}):Play()

end)

AddConnection(Click.MouseLeave, function()

TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = library.Themes[library.SelectedTheme].Second}):Play()

end)

AddConnection(Click.MouseButton1Up, function()

TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 3, library.Themes[library.SelectedTheme].Second.G * 255 + 3, library.Themes[library.SelectedTheme].Second.B * 255 + 3)}):Play()

end)

AddConnection(Click.MouseButton1Down, function()

TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 6, library.Themes[library.SelectedTheme].Second.G * 255 + 6, library.Themes[library.SelectedTheme].Second.B * 255 + 6)}):Play()

end)

function Bind:Set(Key)

Bind.Binding = false

Bind.Value = Key or Bind.Value

Bind.Value = Bind.Value.Name or Bind.Value

BindBox.Value.Text = Bind.Value

end

Bind:Set(defaultKey)

library.Flags[bindName] = Bind

return Bind

end,

Button = function(self, buttonName, callback)

local callback = callback or function() end

local Click = MakeElement("Button")

local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Size = UDim2.new(1, 0, 0, 38),

Parent = Container

}), {

AddThemeObject(SetProps(MakeElement("Label", buttonName, 15), {

Size = UDim2.new(1, -12, 1, 0),

Position = UDim2.new(0, 12, 0, 0),

Font = Enum.Font.GothamBold,

Name = "Content"

}), "Text"),

AddThemeObject(MakeElement("Stroke"), "Stroke"),

Click

}), "Second")

AddConnection(Click.MouseEnter, function()

TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 3, library.Themes[library.SelectedTheme].Second.G * 255 + 3, library.Themes[library.SelectedTheme].Second.B * 255 + 3)}):Play()

end)

AddConnection(Click.MouseLeave, function()

TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = library.Themes[library.SelectedTheme].Second}):Play()

end)

AddConnection(Click.MouseButton1Up, function()

TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 3, library.Themes[library.SelectedTheme].Second.G * 255 + 3, library.Themes[library.SelectedTheme].Second.B * 255 + 3)}):Play()

callback()

end)

AddConnection(Click.MouseButton1Down, function()

TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(library.Themes[library.SelectedTheme].Second.R * 255 + 6, library.Themes[library.SelectedTheme].Second.G * 255 + 6, library.Themes[library.SelectedTheme].Second.B * 255 + 6)}):Play()

end)

end,

Dropdown = function(self, name, list, callback)

local callback = callback or function() end

local Dropdown = {Value = list[1], Options = list, Toggled = false, Type = "Dropdown", Save = true}

local Click = MakeElement("Button")

local DropdownBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Main, 0, 4), {

Size = UDim2.new(0, 24, 0, 24),

Position = UDim2.new(1, -12, 0.5, 0),

AnchorPoint = Vector2.new(1, 0.5)

}), {

AddThemeObject(MakeElement("Stroke"), "Stroke"),

AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072725342"), {

Size = UDim2.new(0, 20, 0, 20),

Position = UDim2.new(0, 2, 0, 2),

Name = "Ico"

}), "Text")

}), "Main")

local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Size = UDim2.new(1, 0, 0, 38),

Parent = Container

}), {

AddThemeObject(SetProps(MakeElement("Label", name, 15), {

Size = UDim2.new(1, -12, 1, 0),

Position = UDim2.new(0, 12, 0, 0),

Font = Enum.Font.GothamBold,

Name = "Content"

}), "Text"),

AddThemeObject(MakeElement("Stroke"), "Stroke"),

DropdownBox,

Click,

SetProps(MakeElement("TFrame"), {

Size = UDim2.new(1, 0, 0, 0),

Position = UDim2.new(0, 0, 0, 38),

Name = "DropFrame",

BackgroundTransparency = 1

}),

}), "Second")

local DropList = MakeElement("List")

DropList.Parent = DropdownFrame.DropFrame

AddConnection(DropList:GetPropertyChangedSignal("AbsoluteContentSize"), function()

DropdownFrame.DropFrame.Size = UDim2.new(1, 0, 0, DropList.AbsoluteContentSize.Y)

end)

function Dropdown:Refresh(Options, Delete)

Dropdown.Options = Options

if Delete then

Dropdown.Value = nil

end

for _, v in next, DropdownFrame.DropFrame:GetChildren() do

if v:IsA("TextButton") then

v:Destroy()

end

end

for _, v in next, Dropdown.Options do

local Button = MakeElement("Button")

local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Size = UDim2.new(1, 0, 0, 28),

Parent = DropdownFrame.DropFrame

}), {

AddThemeObject(SetProps(MakeElement("Label", v, 14), {

Size = UDim2.new(1, -12, 1, 0),

Position = UDim2.new(0, 12, 0, 0),

Font = Enum.Font.GothamSemibold,

Name = "Title"

}), "Text"),

AddThemeObject(MakeElement("Stroke"), "Stroke"),

Button

}), "Second")

AddConnection(Button.MouseButton1Click, function()

Dropdown.Value = v

Dropdown:Toggle(false)

callback(v)

SaveCfg(game.GameId)

end)

end

end

function Dropdown:Toggle(Bool)

Dropdown.Toggled = Bool

TweenService:Create(DropdownBox.Ico, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = Bool and 180 or 0}):Play()

TweenService:Create(DropdownFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, DropList.AbsoluteContentSize.Y + 38) or UDim2.new(1, 0, 0, 38)}):Play()

end

function Dropdown:Set(Value)

Dropdown.Value = Value

callback(Value)

SaveCfg(game.GameId)

end

Dropdown:Refresh(Dropdown.Options, false)

Dropdown:Set(Dropdown.Value)

library.Flags[name] = Dropdown

return Dropdown

end,

ColorPicker = function(self, pickerName, defaultColor, callback)

local callback = callback or function() end

local Colorpicker = {Value = defaultColor, Toggled = false, Type = "Colorpicker", Save = true}

local rainbow = false

local ColorInput, HueInput

local DefaultH, DefaultS, DefaultV = Color3.toHSV(defaultColor)

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

Create("UIGradient", {

Rotation = 270,

Color = ColorSequence.new{

ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), 

ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), 

ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), 

ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), 

ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), 

ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), 

ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))

}

}),

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

local Click = MakeElement("Button")

local ColorpickerBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Main, 0, 4), {

Size = UDim2.new(0, 24, 0, 24),

Position = UDim2.new(1, -12, 0.5, 0),

AnchorPoint = Vector2.new(1, 0.5)

}), {

AddThemeObject(MakeElement("Stroke"), "Stroke")

}), "Main")

local ColorpickerFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 5), {

Size = UDim2.new(1, 0, 0, 38),

Parent = Container

}), {

SetProps(SetChildren(MakeElement("TFrame"), {

AddThemeObject(SetProps(MakeElement("Label", pickerName, 15), {

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

local RainbowFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", library.Themes[library.SelectedTheme].Second, 0, 4), {

Size = UDim2.new(1, 0, 0, 24),

Position = UDim2.new(0, 0, 0, 120),

}), {

AddThemeObject(MakeElement("Stroke"), "Stroke"),

AddThemeObject(SetProps(MakeElement("Label", "Rainbow: OFF", 14), {

Size = UDim2.new(1, 0, 1, 0),

Font = Enum.Font.GothamBold,

Name = "label"

}), "Text"),

}), "Second")

RainbowFrame.Parent = ColorpickerContainer

Instance.new("UIGradient", RainbowFrame).Rotation = -90

Instance.new("UIGradient", RainbowFrame).Color = gradientSection

local function UpdateColorPicker()

ColorpickerBox.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)

Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)

Colorpicker.Value = ColorpickerBox.BackgroundColor3

callback(Colorpicker.Value)

SaveCfg(game.GameId)

end

UpdateColorPicker()

AddConnection(Click.MouseButton1Click, function()

Colorpicker.Toggled = not Colorpicker.Toggled

TweenService:Create(ColorpickerFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 172) or UDim2.new(1, 0, 0, 38)}):Play()

Color.Visible = Colorpicker.Toggled

Hue.Visible = Colorpicker.Toggled

ColorpickerFrame.F.Line.Visible = Colorpicker.Toggled

end)

AddConnection(Color.InputBegan, function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

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

if input.UserInputType == Enum.UserInputType.MouseButton1 then

if ColorInput then

ColorInput:Disconnect()

end

end

end)

AddConnection(Hue.InputBegan, function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

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

if input.UserInputType == Enum.UserInputType.MouseButton1 then

if HueInput then

HueInput:Disconnect()

end

end

end)

AddConnection(RainbowFrame.MouseButton1Click, function()

rainbow = not rainbow

RainbowFrame.label.Text = "Rainbow: " .. (rainbow and "ON" or "OFF")

if rainbow then

spawn(function()

while rainbow do

ColorH = library.rainbowI

HueSelection.Position = UDim2.new(0.5, 0, 1 - ColorH, 0)

Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)

UpdateColorPicker()

wait()

end

end)

end

end)

function Colorpicker:Set(Value)

Colorpicker.Value = Value

ColorH, ColorS, ColorV = Color3.toHSV(Value)

ColorpickerBox.BackgroundColor3 = Colorpicker.Value

ColorSelection.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)

HueSelection.Position = UDim2.new(0.5, 0, 1 - ColorH, 0)

callback(Colorpicker.Value)

end

Colorpicker:Set(Colorpicker.Value)

library.Flags[pickerName] = Colorpicker

return Colorpicker

end

}

return elements

end

local function CreateSection(name)

local sectionSelector = Create("ImageButton", {

Parent = main.bar.bottom.topcontainer,

BackgroundTransparency = 1,

Size = UDim2.new(0, 60, 1, 0),

Image = "rbxassetid://4641155773",

ImageColor3 = Color3.fromRGB(255, 255, 255),

ScaleType = Enum.ScaleType.Slice,

SliceCenter = Rect.new(4, 4, 296, 296),

SliceScale = 1,

})

local grad = Instance.new("UIGradient")

grad.Color = gradientSection

grad.Parent = sectionSelector

Create("TextLabel", {

Parent = sectionSelector,

BackgroundTransparency = 1,

Text = name,

Size = UDim2.new(1, 0, 1, 0),

TextColor3 = Color3.fromRGB(255, 255, 255),

})

local boxContainer = SetProps(MakeElement("ScrollFrame", library.Themes[library.SelectedTheme].Divider, 4), {

Name = "box",

Parent = main.border,

BorderSizePixel = 0,

BackgroundColor3 = library.Themes[library.SelectedTheme].Second,

Position = UDim2.new(0, 1, 0, 1),

Size = UDim2.new(1, -2, 1, -2),

BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",

TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",

ScrollBarThickness = 4,

CanvasSize = UDim2.new(0, 0, 0, 0),

})

SetChildren(boxContainer, {

MakeElement("Padding", 2, 2, 2, 2),

MakeElement("List", 0, 5),

})

local section = GetElements(boxContainer)

AddConnection(boxContainer:GetPropertyChangedSignal("AbsoluteContentSize"), function()

section:Update()

end)

function section:Update()

local canvas = UDim2.new(0, 0, 0, 0)

for i, v in next, boxContainer:GetChildren() do

if not v:IsA("UIPadding") and not v:IsA("UIListLayout") and v.Visible then

canvas = canvas + UDim2.new(0, 0, 0, v.AbsoluteSize.Y + 5)

end

end

TweenService:Create(boxContainer, TweenInfo.new(0.1), {CanvasSize = canvas}):Play()

end

sectionSelector.MouseButton1Click:Connect(function()

if library.currentSection then

library.currentSectionSelector:FindFirstChild("UIGradient").Color = gradientSection

library.currentSection.Visible = false

end

sectionSelector:FindFirstChild("UIGradient").Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))}

library.currentSection = boxContainer

library.currentSectionSelector = sectionSelector

library.currentSection.Visible = true

library.currentSectionObject = section

end)

if not library.currentSection then

library.currentSection = boxContainer

library.currentSectionSelector = sectionSelector

boxContainer.Visible = true

sectionSelector:FindFirstChild("UIGradient").Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))}

library.currentSectionObject = section

end

return section

end

function library:Init()

if library.SaveConfig then    

    pcall(function()

        if isfile(library.Folder .. "/" .. game.GameId .. ".txt") then

            LoadCfg(readfile(library.Folder .. "/" .. game.GameId .. ".txt"))

        end

    end)        

end    

end

function library:Ready()

gui.Enabled = true

end

library:Init()

return library
