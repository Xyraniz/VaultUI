if getgenv().Library and getgenv().Library.Exit then
    getgenv().Library:Exit()
end

cloneref = cloneref or function(Object) return Object end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local CoreGui = cloneref(game:GetService("CoreGui"))

gethui = gethui or function() return CoreGui end

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())
local IsMobile = UserInputService.TouchEnabled or false

local Library = {
    Flags = { },
    RemoteAssetCache = { },
    MenuKeybind = "None",
    Directory = "Avilon",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs"
    },
    FontSize = 14,
    Animation = {
        Time = 0.25,
        Style = "Quart",
        Direction = "Out"
    },
    Theme = nil,
    Threads = { },
    Connections = { },
    SetFlags = { },
    ThemingStuff = { },
    ThemeMap = { },
    OpenFrames = { },
    Holder = nil,
    UnusedHolder = nil,
    SearchItems = { },
    CurrentPage = nil,
    Font = nil
}
do
    Library.__index = Library

    local Flags = Library.Flags
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    if not isfolder(Library.Directory) then
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do
        if not isfolder(Library.Directory .. Folder) then
            makefolder(Library.Directory .. Folder)
        end
    end

    local RemoteAssetsFolder = string.format("%s%s/RemoteAssets", Library.Directory, Library.Folders.Assets)
    if not isfolder(RemoteAssetsFolder) then
        pcall(makefolder, RemoteAssetsFolder)
    end

    local Themes = {
        ["Preset"] = {
            ["Accent"] = Color3.fromRGB(0, 120, 212),
            ["Accent 2"] = Color3.fromRGB(30, 33, 40),
            ["Accent 3"] = Color3.fromRGB(200, 200, 200),
            ["Accent 4"] = Color3.fromRGB(240, 240, 240),
            ["Background"] = Color3.fromRGB(17, 18, 22),
            ["Foreground"] = Color3.fromRGB(25, 27, 31),
            ["TextPrimary"] = Color3.fromRGB(255, 255, 255),
            ["TextSecondary"] = Color3.fromRGB(180, 180, 180),
            ["Border"] = Color3.fromRGB(45, 48, 55)
        },
        ["Emerald"] = {
            ["Accent"] = Color3.fromRGB(46, 204, 113),
            ["Accent 2"] = Color3.fromRGB(21, 33, 28),
            ["Accent 3"] = Color3.fromRGB(179, 255, 214),
            ["Accent 4"] = Color3.fromRGB(242, 255, 247),
            ["Background"] = Color3.fromRGB(12, 18, 15),
            ["Foreground"] = Color3.fromRGB(18, 26, 22),
            ["TextPrimary"] = Color3.fromRGB(244, 255, 248),
            ["TextSecondary"] = Color3.fromRGB(164, 194, 176),
            ["Border"] = Color3.fromRGB(39, 58, 47)
        },
        ["Rose"] = {
            ["Accent"] = Color3.fromRGB(255, 92, 138),
            ["Accent 2"] = Color3.fromRGB(41, 28, 34),
            ["Accent 3"] = Color3.fromRGB(255, 204, 218),
            ["Accent 4"] = Color3.fromRGB(255, 242, 246),
            ["Background"] = Color3.fromRGB(20, 15, 18),
            ["Foreground"] = Color3.fromRGB(30, 22, 27),
            ["TextPrimary"] = Color3.fromRGB(255, 247, 250),
            ["TextSecondary"] = Color3.fromRGB(201, 172, 183),
            ["Border"] = Color3.fromRGB(63, 45, 53)
        },
        ["Dark"] = {
            ["Accent"] = Color3.fromRGB(0, 120, 212),
            ["Accent 2"] = Color3.fromRGB(20, 20, 25),
            ["Accent 3"] = Color3.fromRGB(180, 180, 200),
            ["Accent 4"] = Color3.fromRGB(220, 220, 230),
            ["Background"] = Color3.fromRGB(10, 10, 12),
            ["Foreground"] = Color3.fromRGB(18, 18, 22),
            ["TextPrimary"] = Color3.fromRGB(255, 255, 255),
            ["TextSecondary"] = Color3.fromRGB(170, 170, 180),
            ["Border"] = Color3.fromRGB(30, 30, 35)
        },
        ["Ruby"] = {
            ["Accent"] = Color3.fromRGB(200, 30, 30),
            ["Accent 2"] = Color3.fromRGB(40, 18, 18),
            ["Accent 3"] = Color3.fromRGB(255, 150, 150),
            ["Accent 4"] = Color3.fromRGB(255, 220, 220),
            ["Background"] = Color3.fromRGB(15, 10, 10),
            ["Foreground"] = Color3.fromRGB(25, 16, 16),
            ["TextPrimary"] = Color3.fromRGB(255, 240, 240),
            ["TextSecondary"] = Color3.fromRGB(200, 170, 170),
            ["Border"] = Color3.fromRGB(55, 30, 30)
        }
    }

    Library.Themes = Themes
    Library.Theme = Themes.Preset

    local CustomFont = { }
    do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(string.format("%s%s/%s.font", Library.Directory, Library.Folders.Assets, Name), HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(string.format("%s%s/%s.font", Library.Directory, Library.Folders.Assets, Name)))
        end

        Library.Font = CustomFont:New("InterSemiBold", 400, "Regular", {
            Id = "InterSemiBold",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"
        })
    end

    Library.Exit = function(Self)
        for _, Connection in Library.Connections do
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do
            coroutine.close(Thread)
        end

        if Self.Holder then
            Self.Holder.Instance:Destroy()
        end

        if Self.UnusedHolder then
            Self.UnusedHolder.Instance:Destroy()
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
            elseif Property == "TextSize" then
                Data.Instance[Property] = Library.FontSize
            elseif Property == "Name" then
                Data.Instance[Property] = "\0"
            elseif Class == "TextButton" then
                if Property == "AutoButtonColor" then
                    Data.Instance[Property] = false
                elseif Property == "Text" then
                    Data.Instance[Property] = ""
                else
                    Data.Instance[Index] = Property
                end
            else
                Data.Instance[Index] = Property
            end
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)

        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then
                if IsMobile and Signal == "MouseButton1Down" then
                    Connection = Self.Instance.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Callback(Input)
                        end
                    end)
                    table.insert(Library.Connections, Connection)
                    return Connection
                end

                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then
            return
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return { }
        end

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({
            [Property] = Visibility and OldTransparency or 1
        }, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then
            Self.Instance.Visible = true
        end

        local NewTween

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then
            elseif type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        if not NewTween then
            if Callback and type(Callback) == "function" then
                Callback()
            end

            Self.Instance.Visible = Visibility
            return
        end

        Library:Connect(NewTween.Completed, function()
            if Callback and type(Callback) == "function" then
                Callback()
            end

            Self.Instance.Visible = Visibility
        end)
    end

    Library.MakeDraggable = function(Self)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local Dragging = false
        local DragStart
        local StartPosition

        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize

            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)

            Self:Tween({Position = UDim2.new(0, NewX, 0, NewY)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end

        local InputChanged

        Self:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position

                if InputChanged then
                    return
                end

                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)

        return Dragging
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance

        local Resizing = false
        local CurrentSide = nil

        local StartMouse = nil
        local StartPosition = nil
        local StartSize = nil

        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })
            Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge("Left", UDim2.new(0, 0, 0, 0), UDim2.new(0, EdgeThickness, 1, 0)), Side = "L"},
            {Button = MakeEdge("Right", UDim2.new(1, -EdgeThickness, 0, 0), UDim2.new(0, EdgeThickness, 1, 0)), Side = "R"},
            {Button = MakeEdge("Top", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, EdgeThickness)), Side = "T"},
            {Button = MakeEdge("Bottom", UDim2.new(0, 0, 1, -EdgeThickness), UDim2.new(1, 0, 0, EdgeThickness)), Side = "B"},
        }

        local BeginResizing = function(Side)
            Resizing = true
            CurrentSide = Side

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false
            CurrentSide = nil

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then
                return
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y

            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end

            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end

            Self:Tween({Position = UDim2.fromOffset(x, y)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Self:Tween({Size = UDim2.fromOffset(w, h)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then
            return
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
            and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.CompareVectors = function(Self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(Self, Column)
        if not Self.Instance then
            return
        end

        local Parent = Column
        local Object = Self.Instance

        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Decimals)
        if type(Number) ~= "number" or not (Number == Number) then
            return 0
        end

        local Multiplier = 10 ^ (Decimals or 0)

        return math.floor((Number * Multiplier) + 0.5) / Multiplier
    end

    Library.GetConfig = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n" .. Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                elseif type(Value) == "table" and Value.Key then
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemingStuff[Object] then
            return
        end

        Library.ThemingStuff[Object].Properties = Properties
        Library.ThemingStuff[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then
            return
        end

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.SanitizeAssetName = function(Self, Value)
        Value = tostring(Value or "")

        if Value == "" then
            return "asset"
        end

        Value = Value:gsub("^https?://", "")
        Value = Value:gsub("[^%w%._%-]", "_")

        if #Value > 120 then
            Value = Value:sub(1, 120)
        end

        return Value
    end
                    
    Library.CacheRemoteAsset = function(Self, Asset)
        if type(Asset) ~= "string" or Asset == "" then
            return nil
        end

        if Library.RemoteAssetCache[Asset] then
            return Library.RemoteAssetCache[Asset]
        end

        if not (isfile and writefile and getcustomasset) then
            return nil
        end

        local CachedPath = string.format("%s%s/RemoteAssets/%s.png", Library.Directory, Library.Folders.Assets, Library:SanitizeAssetName(Asset))

        if isfile(CachedPath) then
            local CustomAsset = getcustomasset(CachedPath)
            Library.RemoteAssetCache[Asset] = CustomAsset
            return CustomAsset
        end

        local Content = nil
        local Success = false

        if not Success and game and game.HttpGet then
            Success, Content = pcall(function()
                return game:HttpGet(Asset)
            end)
        end

        if not Success and syn and syn.request then
            Success, Content = pcall(function()
                local resp = syn.request({
                    Url = Asset,
                    Method = "GET",
                    Headers = { ["Content-Type"] = "application/octet-stream" }
                })
                return resp.Body
            end)
        end

        if not Success and http_request then
            Success, Content = pcall(function()
                local resp = http_request({
                    Url = Asset,
                    Method = "GET",
                    Headers = { ["Content-Type"] = "application/octet-stream" }
                })
                return resp.Body
            end)
        end

        if not Success and HttpService then
            Success, Content = pcall(function()
                local resp = HttpService:RequestAsync({
                    Url = Asset,
                    Method = "GET",
                    Headers = { ["Content-Type"] = "application/octet-stream" }
                })
                return resp.Body
            end)
        end

        if Success and type(Content) == "string" and Content ~= "" then
            pcall(writefile, CachedPath, Content)
        end

        if isfile(CachedPath) then
            local CustomAsset = getcustomasset(CachedPath)
            Library.RemoteAssetCache[Asset] = CustomAsset
            return CustomAsset
        end

        return nil
    end

    Library.NormalizeAsset = function(Self, Asset)
        if type(Asset) == "number" then
            return "rbxassetid://" .. tostring(math.floor(Asset))
        end

        if type(Asset) ~= "string" or Asset == "" then
            return nil
        end

        if string.find(Asset, "rbxassetid://", 1, true) or string.find(Asset, "rbxthumb://", 1, true) then
            return Asset
        end

        if string.find(string.lower(Asset), "http", 1, true) == 1 then
            local CachedAsset = Library:CacheRemoteAsset(Asset)
            if CachedAsset then
                return CachedAsset
            end
            return nil
        end
                        
        local Digits = Asset:match("%d+")
        if Digits then
            return "rbxassetid://" .. Digits
        end

        return nil
    end
                    
    Library.ResolveScaleType = function(Self, ScaleType)
        if typeof(ScaleType) == "EnumItem" then
            return ScaleType
        end

        if type(ScaleType) ~= "string" then
            return Enum.ScaleType.Tile
        end

        ScaleType = string.lower(ScaleType)

        if ScaleType == "fit" then
            return Enum.ScaleType.Fit
        elseif ScaleType == "stretch" then
            return Enum.ScaleType.Stretch
        elseif ScaleType == "crop" then
            return Enum.ScaleType.Crop
        end

        return Enum.ScaleType.Tile
    end

    Library.CopyTheme = function(Self, ThemeTable)
        local NewTheme = { }

        if type(ThemeTable) ~= "table" then
            return NewTheme
        end

        for Key, Value in ThemeTable do
            NewTheme[Key] = Value
        end

        return NewTheme
    end

    Library.NormalizeThemeColor = function(Self, Value)
        if typeof(Value) == "Color3" then
            return Value
        end

        if type(Value) == "string" then
            local Hex = Value:gsub("#", "")

            if #Hex == 6 then
                local R = tonumber(Hex:sub(1, 2), 16)
                local G = tonumber(Hex:sub(3, 4), 16)
                local B = tonumber(Hex:sub(5, 6), 16)

                if R and G and B then
                    return Color3.fromRGB(R, G, B)
                end
            end
        elseif type(Value) == "table" then
            local R = Value.R or Value.r or Value[1]
            local G = Value.G or Value.g or Value[2]
            local B = Value.B or Value.b or Value[3]

            if type(R) == "number" and type(G) == "number" and type(B) == "number" then
                if R <= 1 and G <= 1 and B <= 1 then
                    return Color3.new(R, G, B)
                end

                return Color3.fromRGB(R, G, B)
            end
        end

        return nil
    end

    Library.SetThemeColors = function(Self, ThemeOverrides)
        if type(ThemeOverrides) ~= "table" then
            return Library.Theme
        end

        for ThemeName, ThemeColor in ThemeOverrides do
            local NormalizedColor = Library:NormalizeThemeColor(ThemeColor)

            if NormalizedColor then
                Library.Theme[ThemeName] = NormalizedColor
                Library:ChangeTheme(ThemeName, NormalizedColor)
            end
        end

        return Library.Theme
    end

    Library.UseThemePreset = function(Self, PresetName, ThemeOverrides)
        local BaseTheme = Library.Themes[PresetName] or Library.Themes.Preset
        local NextTheme = Library:CopyTheme(BaseTheme)

        if type(ThemeOverrides) == "table" then
            for ThemeName, ThemeColor in ThemeOverrides do
                local NormalizedColor = Library:NormalizeThemeColor(ThemeColor)

                if NormalizedColor then
                    NextTheme[ThemeName] = NormalizedColor
                end
            end
        end

        return Library:SetThemeColors(NextTheme)
    end

    Library.GetThemeColors = function(Self)
        return Library:CopyTheme(Library.Theme)
    end

    Library.NormalizeUnitInterval = function(Self, Value, Default)
        if type(Value) ~= "number" then
            return Default
        end

        return math.clamp(Value, 0, 1)
    end

    Library.GetResponsiveWindowSize = function(Self, RequestedSize)
        local BaseSize

        if typeof(RequestedSize) == "UDim2" then
            BaseSize = Vector2.new(RequestedSize.X.Offset, RequestedSize.Y.Offset)
        elseif typeof(RequestedSize) == "Vector2" then
            BaseSize = RequestedSize
        else
            BaseSize = Vector2.new(750, 400)
        end

        local Viewport = (Camera and Camera.ViewportSize) or Vector2.new(1366, 768)
        local WidthBoost = IsMobile and 1.05 or 1.01
        local HeightBoost = IsMobile and 1.06 or 1.025

        local Width = math.floor((BaseSize.X * WidthBoost) + 0.5)
        local Height = math.floor((BaseSize.Y * HeightBoost) + 0.5)

        local MaxWidth = math.max(320, math.floor(Viewport.X * (IsMobile and 0.92 or 0.8)))
        local MaxHeight = math.max(260, math.floor(Viewport.Y * (IsMobile and 0.82 or 0.84)))

        local MinWidth = math.min(IsMobile and 332 or 650, MaxWidth)
        local MinHeight = math.min(IsMobile and 262 or 375, MaxHeight)

        Width = math.clamp(Width, MinWidth, MaxWidth)
        Height = math.clamp(Height, MinHeight, MaxHeight)

        return UDim2.fromOffset(Width, Height)
    end

    Library.GlobalUpdateOpenFrames = function(Self)
        for _, Item in Library.OpenFrames do
            local IsOpen = Item.IsOpen
            local AttachedButton = Item.AttachedButton
            local Frame = Item.Frame

            local CanUpdateNow = Item.CanUpdateNow

            if CanUpdateNow and IsOpen then
                Frame.Position = UDim2.new(0, AttachedButton.AbsolutePosition.X, 0, AttachedButton.AbsolutePosition.Y + AttachedButton.AbsoluteSize.Y + 10 + GuiInset)
            end
        end
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Library.Theme["TextPrimary"],
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,

                Items = { }
            }

            local Items = { }
            do
                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0.7665995955467224, 0, 0.16584157943725586, 0),
                    Size = UDim2.new(0, 211, 0, 184),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromRGB(32, 35, 42)
                })

                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 1, -70),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    BackgroundColor3 = Library.Theme["Accent 4"],
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })

                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })

                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 10, 0, 10),
                    BackgroundColor3 = Library.Theme["Accent 4"],
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    Color = Library.Theme["TextPrimary"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["Hue"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -38),
                    Size = UDim2.new(1, -20, 0, 10),
                    BackgroundColor3 = Library.Theme["Accent 4"],
                    BorderSizePixel = 0
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Library.Theme["Accent"]),
                        ColorSequenceKeypoint.new(0.17, Library.Theme["Accent"]),
                        ColorSequenceKeypoint.new(0.33, Library.Theme["Accent"]),
                        ColorSequenceKeypoint.new(0.5, Library.Theme["Accent"]),
                        ColorSequenceKeypoint.new(0.67, Library.Theme["Accent"]),
                        ColorSequenceKeypoint.new(0.83, Library.Theme["Accent"]),
                        ColorSequenceKeypoint.new(1, Library.Theme["Accent"])
                    }
                })

                Items["HueDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BackgroundColor3 = Library.Theme["Accent 4"],
                    Size = UDim2.new(0, 4, 1, 6),
                    BorderSizePixel = 0
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["Alpha"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -20, 0, 10),
                    BackgroundColor3 = Library.Theme["Accent 4"],
                    BorderSizePixel = 0
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["AlphaDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 4, 1, 6),
                    BackgroundColor3 = Library.Theme["Accent 4"],
                    ZIndex = 2,
                    BorderSizePixel = 0
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["AlphaColor"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["AlphaColor"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["AlphaColor"].Instance,
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    }
                })

                Items["ColorpickerButton"] = Data.Items["ColorpickerButton"]
                Items["ActualColorpickerButton"] = Data.Items["RealColorpicker"]

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Items["ColorpickerButton"]:Tween({BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Transparency = 1 - Colorpicker.Alpha
                }

                Data.Items["Value"].Instance.Text = "#" .. Colorpicker.HexValue

                if not IsFromAlpha then
                    Items["AlphaColor"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false
            local RenderStepped
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            Colorpicker.AttachedButton = ColorpickerButton
            Colorpicker.CanUpdateNow = false
            Colorpicker.Frame = ColorpickerWindow

            function Colorpicker:SetOpen(Bool)
                if Debounce then
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true

                if Colorpicker.IsOpen then
                    Data.Items["Text"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})
                    Data.Items["Value"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})

                    ColorpickerWindow.Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + GuiInset)

                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 10 + GuiInset)})

                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Colorpicker.CanUpdateNow = true
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        Value:SetOpen(false)
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker
                else
                    Data.Items["Text"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})
                    Data.Items["Value"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})

                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        ColorpickerWindow.Parent = Library.UnusedHolder.Instance
                        Colorpicker.CanUpdateNow = false
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then
                        Library.OpenFrames[Colorpicker] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                    else
                        Value.ZIndex = Colorpicker.IsOpen and 4 or 1
                    end
                end

                Items["PaletteDragger"].Instance.ZIndex = 5
                Items["HueDragger"].Instance.ZIndex = 5
                Items["AlphaDragger"].Instance.ZIndex = 5
            end

            local SlidingPalette = false
            local PaletteChanged

            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = math.clamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = math.clamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.98)
                local SlideY = math.clamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.98)

                Items["PaletteDragger"]:Tween({Position = UDim2.new(SlideX, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end

                local ValueX = math.clamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 1)

                Colorpicker.Hue = ValueX

                local SlideX = math.clamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 0.985)

                Items["HueDragger"]:Tween({Position = UDim2.new(SlideX, 0, 0.5, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            local SlidingAlpha = false
            local AlphaChanged

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local ValueX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

                Colorpicker.Alpha = ValueX

                local SlideX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.985)

                Items["AlphaDragger"]:Tween({Position = UDim2.new(SlideX, 0, 0.5, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update(true)
            end

            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color
                end

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0

                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.985)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.985)

                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 0.99)

                local HuePositionX = math.clamp(Colorpicker.Hue, 0, 0.98)

                Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["HueDragger"]:Tween({Position = UDim2.new(HuePositionX, 0, 0.5, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["AlphaDragger"]:Tween({Position = UDim2.new(AlphaPositionX, 0, 0.5, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            Items["ActualColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true

                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false

                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true

                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true

                    Colorpicker:SlideAlpha(Input)

                    if AlphaChanged then
                        return
                    end

                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false

                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end

                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not Colorpicker.IsOpen then
                        return
                    end

                    if Items["ColorpickerWindow"]:IsMouseOverFrame() then
                        return
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end

            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = { }
            }

            local Items = { }
            do
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "Space",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0.036217302083969116, 0, 0.17202970385551453, 0),
                    Size = UDim2.new(0, 249, 0, 75),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromRGB(32, 35, 42)
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Keybind.Items = Items
            end

            local Debounce = false
            local RenderStepped
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Keybind.Flag .. "ModeDropdown",
                Parent = Items["KeybindWindow"],
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end
            })

            ModeDropdown.Items.Dropdown.Instance.Position = UDim2.new(0, 10, 0, 10)
            ModeDropdown.Items.Dropdown.Instance.Size = UDim2.new(1, -20, 0, 55)

            Keybind.AttachedButton = KeyButton
            Keybind.CanUpdateNow = false
            Keybind.Frame = KeybindWindow

            function Keybind:SetOpen(Bool)
                if Debounce then
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true

                if Keybind.IsOpen then
                    KeybindWindow.Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset)

                    KeybindWindow.Parent = Library.Holder.Instance
                    KeybindWindow.Visible = true
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + 10 + GuiInset)})

                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false
                        Keybind.CanUpdateNow = true
                    end)

                    for Index, Value in Library.OpenFrames do
                        Value:SetOpen(false)
                    end

                    Library.OpenFrames[Keybind] = Keybind
                else
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                        Keybind.CanUpdateNow = false
                    end)

                    if Library.OpenFrames[Keybind] then
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                    else
                        Value.ZIndex = Keybind.IsOpen and 10 or 1
                    end
                end
            end

            function Keybind:SetMode(Mode)
                ModeDropdown:Set(Mode)

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then
                    Keybind.Toggled = true
                end

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end

                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                elseif table.find({ "Toggle", "Hold", "Always" }, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                Keybind.Picking = false
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true

                Items["KeyButton"].Instance.Text = "..."

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "None" then
                    return
                end

                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Items["KeybindWindow"]:IsMouseOverFrame() or ModeDropdown.Items.OptionHolder:IsMouseOverFrame() then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then
                        Keybind:Press(true)
                    end
                end
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            if Data.Default then
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end

            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items
        end

        Library.Window = function(Self, Params)
            Params = Params or { }

            local ThemePreset = Params.ThemePreset or Params.themepreset
            local ThemeOverrides = Params.Theme or Params.theme

            if ThemePreset then
                Library:UseThemePreset(ThemePreset, ThemeOverrides)
            elseif type(ThemeOverrides) == "table" then
                Library:SetThemeColors(ThemeOverrides)
            end

            local RequestedSize = Params.Size or Params.size
            local WindowSize = Library:GetResponsiveWindowSize(RequestedSize)
            local SideWidth = Params.SideWidth or Params.sidebarwidth or (IsMobile and 220 or 224)
            local TopHeight = Params.TopHeight or Params.topheight or (IsMobile and 78 or 74)
            local SearchHeight = Params.SearchHeight or Params.searchheight or 40

            local BackgroundImage = Library:NormalizeAsset(
                Params.BackgroundImage or Params.backgroundimage or
                Params.BackgroundAsset or Params.backgroundasset or
                Params.BackgroundId or Params.backgroundid or
                Params.RbxBackground or Params.rbxbackground or
                Params.Background or Params.background
            ) or "rbxassetid://100072076855987"

            local BackgroundScaleType = Library:ResolveScaleType(
                Params.BackgroundMode or Params.backgroundmode or
                Params.BackgroundScaleType or Params.backgroundscaletype or
                "Stretch"
            )

            local SideBackgroundScaleType = Library:ResolveScaleType(
                Params.SideBackgroundMode or Params.sidebackgroundmode or
                Params.TabsBackgroundMode or Params.tabsbackgroundmode or
                Params.SideBackgroundScaleType or Params.sidebackgroundscaletype or
                Params.TabsBackgroundScaleType or Params.tabsbackgroundscaletype or
                "Stretch"
            )

            local BackgroundStrength = Library:NormalizeUnitInterval(
                Params.BackgroundStrength or Params.backgroundstrength or
                Params.BackgroundVisibility or Params.backgroundvisibility,
                0.68
            )

            local TabsBackgroundStrength = Library:NormalizeUnitInterval(
                Params.TabsBackgroundStrength or Params.tabsbackgroundstrength or
                Params.SideBackgroundStrength or Params.sidebackgroundstrength,
                math.clamp(BackgroundStrength - 0.14, 0, 1)
            )

            local ContentBackgroundTransparency = Params.BackgroundTransparency or Params.backgroundtransparency or (0.82 - (0.72 * BackgroundStrength))
            local ContentBackgroundShadeTransparency = Params.BackgroundShadeTransparency or Params.backgroundshadetransparency or (0.72 + (0.25 * BackgroundStrength))
            local ContentBackgroundColor = Params.BackgroundColor or Params.backgroundcolor or Color3.fromRGB(255, 255, 255)

            local SideBackgroundTransparency = Params.SideBackgroundTransparency or Params.sidebackgroundtransparency or Params.TabsBackgroundTransparency or Params.tabsbackgroundtransparency or (0.88 - (0.55 * TabsBackgroundStrength))
            local SideBackgroundShadeTransparency = Params.SideBackgroundShadeTransparency or Params.sidebackgroundshadetransparency or Params.TabsBackgroundShadeTransparency or Params.tabsbackgroundshadetransparency or (0.62 + (0.25 * TabsBackgroundStrength))
            local SideBackgroundColor = Params.SideBackgroundColor or Params.sidebackgroundcolor or Params.TabsBackgroundColor or Params.tabsbackgroundcolor or ContentBackgroundColor
            local GridEnabled = Params.ShowGrid

            if GridEnabled == nil then
                GridEnabled = Params.showgrid
            end

            if GridEnabled == nil then
                GridEnabled = Params.BackgroundGrid
            end

            if GridEnabled == nil then
                GridEnabled = Params.backgroundgrid
            end

            if GridEnabled == nil then
                GridEnabled = true
            end

            local GridTransparency = Params.GridTransparency or Params.gridtransparency or 0.83

            local BackgroundTileSize = Params.BackgroundTileSize or Params.backgroundtilesize or (IsMobile and 52 or 42)
            if type(BackgroundTileSize) == "number" then
                BackgroundTileSize = UDim2.fromOffset(BackgroundTileSize, BackgroundTileSize)
            end

            if typeof(BackgroundTileSize) ~= "UDim2" then
                BackgroundTileSize = UDim2.fromOffset(IsMobile and 52 or 42, IsMobile and 52 or 42)
            end

            local Window = {
                Name = Params.Name or Params.name or "Window",
                SubName = Params.SubName or Params.subname or "",
                Logo = Params.Logo or Params.logo or "rbxassetid://114856413138528",

                IsOpen = true,
                Pages = { },
                Items = { }
            }

            local Items = { }
            do
                Items["MainFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = WindowSize,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                })

                Items["WindowScale"] = Library:Create("UIScale", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Scale = 1
                })

                Items["FrameGlow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 42, 0, 42),
                    ZIndex = 0,
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    ImageTransparency = 0.84,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = "Accent"})

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library.Theme["Background"]),
                        ColorSequenceKeypoint.new(1, Library.Theme["Foreground"])
                    })
                }):AddToTheme({
                    Color = function()
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Library.Theme["Background"]),
                            ColorSequenceKeypoint.new(1, Library.Theme["Foreground"])
                        })
                    end
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Color = Library.Theme["Border"],
                    Thickness = 1.25,
                    Transparency = 0.15
                }):AddToTheme({Color = "Border"})

                Items["CloseButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = 16,
                    Parent = Items["MainFrame"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "X",
                    AutoButtonColor = false,
                    BackgroundColor3 = Library.Theme["Accent 2"],
                    BackgroundTransparency = 0.3,
                    Position = UDim2.new(1, -38, 0, 12),
                    Size = UDim2.new(0, 26, 0, 26),
                    BorderSizePixel = 0,
                    ZIndex = 9999
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["CloseButton"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CloseButton"].Instance,
                    Color = Library.Theme["Border"],
                    Transparency = 0.35
                }):AddToTheme({Color = "Border"})

                Items["CloseButton"]:OnHover(function()
                    Items["CloseButton"]:Tween({
                        BackgroundTransparency = 0.05,
                        TextColor3 = Library.Theme["Accent"]
                    }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end, function()
                    Items["CloseButton"]:Tween({
                        BackgroundTransparency = 0.3,
                        TextColor3 = Library.Theme["TextPrimary"]
                    }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end)

                Items["CloseButton"]:Connect("MouseButton1Click", function()
                    Library:Exit()
                end)

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2.new(IsMobile and 320 or 620, IsMobile and 240 or 350))

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    CornerRadius = UDim.new(0, 10)
                })

                Items["TopAccent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Size = UDim2.new(1, 0, 0, 3),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = "Accent"})

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["TopAccent"].Instance,
                    Rotation = 0,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library.Theme["Accent"]),
                        ColorSequenceKeypoint.new(0.5, Library.Theme["Accent 3"]),
                        ColorSequenceKeypoint.new(1, Library.Theme["Accent"])
                    })
                }):AddToTheme({
                    Color = function()
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Library.Theme["Accent"]),
                            ColorSequenceKeypoint.new(0.5, Library.Theme["Accent 3"]),
                            ColorSequenceKeypoint.new(1, Library.Theme["Accent"])
                        })
                    end
                })

                Items["TopAccentSheen"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["TopAccent"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(-0.35, 0, 0.5, 0),
                    Size = UDim2.new(0.32, 0, 1, 0),
                    BackgroundColor3 = Library.Theme["Accent 4"],
                    BackgroundTransparency = 0.18,
                    BorderSizePixel = 0,
                    ZIndex = 3
                }):AddToTheme({BackgroundColor3 = "Accent 4"})

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["TopAccentSheen"].Instance,
                    Rotation = 0,
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.2, 0.7),
                        NumberSequenceKeypoint.new(0.5, 0.1),
                        NumberSequenceKeypoint.new(0.8, 0.7),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                })

                Items["TopAccentPulse"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["TopAccent"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0.18, 0, 1, 0),
                    BackgroundColor3 = Library.Theme["Accent 3"],
                    BackgroundTransparency = 0.72,
                    BorderSizePixel = 0,
                    ZIndex = 2
                }):AddToTheme({BackgroundColor3 = "Accent 3"})

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["TopAccentPulse"].Instance,
                    Rotation = 0,
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.5, 0.15),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                })

                Items["Side"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, SideWidth, 1, 0),
                    BorderSizePixel = 0
                })

                Items["SideBackgroundArt"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    Image = BackgroundImage,
                    ImageTransparency = SideBackgroundTransparency,
                    ImageColor3 = SideBackgroundColor,
                    ScaleType = SideBackgroundScaleType,
                    TileSize = BackgroundTileSize,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1
                })

                Items["SideBackgroundShade"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"],
                    BackgroundTransparency = SideBackgroundShadeTransparency
                }):AddToTheme({BackgroundColor3 = "Background"})

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                })
                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, TopHeight),
                    BorderSizePixel = 0
                })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                })

                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    ImageColor3 = Library.Theme["TextPrimary"],
                    Size = UDim2.new(0, 44, 0, 44),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = "TextPrimary"})

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = 25,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = Window.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 65, 0.5, -8),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = "TextPrimary"})

                Items["SubTitle"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Window.SubName,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 67, 0.5, 12),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = "TextSecondary"})

                Items["Pages"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, TopHeight),
                    Size = UDim2.new(1, 0, 1, -TopHeight),
                    BorderSizePixel = 0,
                    ScrollBarThickness = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    PaddingRight = UDim.new(0, 1)
                })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, SideWidth, 0, 0),
                    Size = UDim2.new(1, -SideWidth, 1, 0),
                    BorderSizePixel = 0
                })

                Items["BackgroundArt"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Image = BackgroundImage,
                    ImageTransparency = ContentBackgroundTransparency,
                    ImageColor3 = ContentBackgroundColor,
                    ScaleType = BackgroundScaleType,
                    TileSize = BackgroundTileSize,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1
                })

                Items["BackgroundShade"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"],
                    BackgroundTransparency = ContentBackgroundShadeTransparency
                }):AddToTheme({BackgroundColor3 = "Background"})

                Items["Grid"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Visible = GridEnabled,
                    ImageColor3 = Library.Theme["Border"],
                    ScaleType = Enum.ScaleType.Tile,
                    Image = "rbxassetid://100072076855987",
                    BackgroundTransparency = 1,
                    ImageTransparency = GridTransparency,
                    Size = UDim2.new(1, 0, 1, 0),
                    TileSize = UDim2.new(0, 36, 0, 36),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = "Border"})

                Items["Search"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Position = UDim2.new(0, 50, 0, 80),
                    Size = UDim2.new(1, -100, 0, SearchHeight),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Search"].Instance,
                    Color = Library.Theme["Border"],
                    Transparency = 0.32
                }):AddToTheme({Color = "Border"})

                Items["SearchIcon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Search"].Instance,
                    ImageColor3 = Color3.fromRGB(143, 147, 167),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "rbxassetid://101277274908578",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0
                })

                Items["SearchInput"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Search"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "",
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 38, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = Color3.fromRGB(143, 147, 167),
                    AutomaticSize = Enum.AutomaticSize.X,
                    PlaceholderText = "Search"
                })

                Items["Search"]:OnHover(function()
                    Items["Search"]:Tween({
                        BackgroundColor3 = Library.Theme["Accent 2"]
                    }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end, function()
                    if not Items["SearchInput"].Instance:IsFocused() then
                        Items["Search"]:Tween({
                            BackgroundColor3 = Library.Theme["Foreground"]
                        }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    end
                end)

                Library:Connect(Items["SearchInput"].Instance.Focused, function()
                    Items["Search"]:Tween({
                        BackgroundColor3 = Library.Theme["Accent 2"]
                    }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    if Items["Search"].Instance:FindFirstChildOfClass("UIStroke") then
                        Library:Tween({
                            Transparency = 0.08
                        }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), Items["Search"].Instance:FindFirstChildOfClass("UIStroke"))
                    end
                end)

                Library:Connect(Items["SearchInput"].Instance.FocusLost, function()
                    Items["Search"]:Tween({
                        BackgroundColor3 = Library.Theme["Foreground"]
                    }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    if Items["Search"].Instance:FindFirstChildOfClass("UIStroke") then
                        Library:Tween({
                            Transparency = 0.32
                        }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), Items["Search"].Instance:FindFirstChildOfClass("UIStroke"))
                    end
                end)

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Search"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })

                Items["ContentDescription"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Content"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "Adjust settings and interface behavior",
                    AnchorPoint = Vector2.new(0.5, 0),
                    Size = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 45),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["ContentTitle"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Content"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "Aimbot",
                    AnchorPoint = Vector2.new(0.5, 0),
                    Size = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 20),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                if IsMobile then
                    local MinimizeSize = Params.MinimizeSize or Params.minimizesize or 68
                    Items["OpenAndClose"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Library.Holder.Instance,
                        TextColor3 = Library.Theme["TextPrimary"],
                        Text = "",
                        AutoButtonColor = false,
                        Position = UDim2.new(0, 36, 0, 208),
                        Size = UDim2.fromOffset(MinimizeSize, MinimizeSize),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    })

                    Items["OpenAndClose"]:MakeDraggable()

                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["OpenAndClose"].Instance,
                        CornerRadius = UDim.new(0, 8)
                    })

                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = Items["OpenAndClose"].Instance,
                        Color = Library.Theme["Border"],
                        Transparency = 0.25
                    }):AddToTheme({Color = "Border"})

                    Items["Logo"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items["OpenAndClose"].Instance,
                        ImageColor3 = Library.Theme["Accent"],
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = Window.Logo,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.fromOffset(MinimizeSize * 0.6, MinimizeSize * 0.6),
                        BorderSizePixel = 0
                    }):AddToTheme({ImageColor3 = 'Accent 4'})

                    Items["OpenAndClose"]:OnHover(function()
                        Items["OpenAndClose"]:Tween({
                            BackgroundColor3 = Library.Theme["Accent 2"]
                        }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    end, function()
                        Items["OpenAndClose"]:Tween({
                            BackgroundColor3 = Library.Theme["Background"]
                        }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    end)

                    Items["OpenAndClose"]:Connect("MouseButton1Down", function()
                        Window:SetOpen(not Window.IsOpen)
                    end)
                end

                Window.Items = Items
            end

            local Debounce = false
            local AccentAnimationOffset = math.random()

            Library:Connect(RunService.RenderStepped, function()
                if not Items["TopAccent"].Instance.Parent then
                    return
                end

                local Clock = os.clock() + AccentAnimationOffset
                local SheenTravel = ((Clock * 0.22) % 1.8) - 0.45
                local PulseCenter = 0.5 + (math.sin(Clock * 1.4) * 0.18)
                local PulseWidth = 0.14 + ((math.sin(Clock * 1.9) + 1) * 0.04)

                Items["TopAccentSheen"].Instance.Position = UDim2.new(SheenTravel, 0, 0.5, 0)
                Items["TopAccentPulse"].Instance.Position = UDim2.new(PulseCenter, 0, 0.5, 0)
                Items["TopAccentPulse"].Instance.Size = UDim2.new(PulseWidth, 0, 1, 0)

                if Window.IsOpen and not Debounce then
                    Items["FrameGlow"].Instance.ImageTransparency = 0.845 - ((math.sin(Clock * 1.2) + 1) * 0.018)
                end
            end)

            function Window:SetBackground(BackgroundData)
                local Data = type(BackgroundData) == "table" and BackgroundData or {Image = BackgroundData}
                local Asset = Library:NormalizeAsset(Data.Image or Data.Asset or Data.Id or Data.Background or Data.BackgroundImage or Data.BackgroundAsset or Data.BackgroundId)
                local Strength = Library:NormalizeUnitInterval(Data.Strength or Data.BackgroundStrength or Data.Visibility or Data.BackgroundVisibility, nil)
                local SideStrength = Library:NormalizeUnitInterval(Data.SideStrength or Data.TabsStrength or Data.TabsBackgroundStrength or Data.SideBackgroundStrength, nil)

                if Asset then
                    Items["BackgroundArt"].Instance.Image = Asset
                    Items["SideBackgroundArt"].Instance.Image = Asset
                end

                if Strength ~= nil then
                    Items["BackgroundArt"].Instance.ImageTransparency = 0.82 - (0.72 * Strength)
                    Items["BackgroundShade"].Instance.BackgroundTransparency = 0.72 + (0.25 * Strength)
                end

                if SideStrength ~= nil then
                    Items["SideBackgroundArt"].Instance.ImageTransparency = 0.88 - (0.55 * SideStrength)
                    Items["SideBackgroundShade"].Instance.BackgroundTransparency = 0.62 + (0.25 * SideStrength)
                elseif Strength ~= nil then
                    local AutoSideStrength = math.clamp(Strength - 0.14, 0, 1)
                    Items["SideBackgroundArt"].Instance.ImageTransparency = 0.88 - (0.55 * AutoSideStrength)
                    Items["SideBackgroundShade"].Instance.BackgroundTransparency = 0.62 + (0.25 * AutoSideStrength)
                end

                if Data.Transparency ~= nil then
                    Items["BackgroundArt"].Instance.ImageTransparency = Data.Transparency
                elseif Data.ImageTransparency ~= nil then
                    Items["BackgroundArt"].Instance.ImageTransparency = Data.ImageTransparency
                end

                if Data.ContentTransparency ~= nil then
                    Items["BackgroundArt"].Instance.ImageTransparency = Data.ContentTransparency
                elseif Data.ContentImageTransparency ~= nil then
                    Items["BackgroundArt"].Instance.ImageTransparency = Data.ContentImageTransparency
                end

                if Data.SideTransparency ~= nil then
                    Items["SideBackgroundArt"].Instance.ImageTransparency = Data.SideTransparency
                elseif Data.SideImageTransparency ~= nil then
                    Items["SideBackgroundArt"].Instance.ImageTransparency = Data.SideImageTransparency
                elseif Data.TabsTransparency ~= nil then
                    Items["SideBackgroundArt"].Instance.ImageTransparency = Data.TabsTransparency
                elseif Data.TabsImageTransparency ~= nil then
                    Items["SideBackgroundArt"].Instance.ImageTransparency = Data.TabsImageTransparency
                elseif Data.Transparency ~= nil then
                    Items["SideBackgroundArt"].Instance.ImageTransparency = math.clamp(Data.Transparency + 0.08, 0, 0.95)
                elseif Data.ImageTransparency ~= nil then
                    Items["SideBackgroundArt"].Instance.ImageTransparency = math.clamp(Data.ImageTransparency + 0.08, 0, 0.95)
                end

                if Data.Color then
                    Items["BackgroundArt"].Instance.ImageColor3 = Data.Color
                    Items["SideBackgroundArt"].Instance.ImageColor3 = Data.Color
                end

                if Data.ContentColor then
                    Items["BackgroundArt"].Instance.ImageColor3 = Data.ContentColor
                elseif Data.ContentImageColor then
                    Items["BackgroundArt"].Instance.ImageColor3 = Data.ContentImageColor
                end

                if Data.SideColor then
                    Items["SideBackgroundArt"].Instance.ImageColor3 = Data.SideColor
                elseif Data.SideImageColor then
                    Items["SideBackgroundArt"].Instance.ImageColor3 = Data.SideImageColor
                elseif Data.TabsColor then
                    Items["SideBackgroundArt"].Instance.ImageColor3 = Data.TabsColor
                elseif Data.TabsImageColor then
                    Items["SideBackgroundArt"].Instance.ImageColor3 = Data.TabsImageColor
                end

                if Data.Rotation ~= nil then
                    Items["BackgroundArt"].Instance.Rotation = Data.Rotation
                    Items["SideBackgroundArt"].Instance.Rotation = Data.Rotation
                end

                local NewScaleType = Data.ScaleType or Data.Mode
                if NewScaleType ~= nil then
                    Items["BackgroundArt"].Instance.ScaleType = Library:ResolveScaleType(NewScaleType)
                end

                local NewSideScaleType = Data.SideScaleType or Data.SideMode or Data.TabsScaleType or Data.TabsMode
                if NewSideScaleType ~= nil then
                    Items["SideBackgroundArt"].Instance.ScaleType = Library:ResolveScaleType(NewSideScaleType)
                elseif NewScaleType ~= nil then
                    Items["SideBackgroundArt"].Instance.ScaleType = Library:ResolveScaleType("Crop")
                end

                local NewTileSize = Data.TileSize
                if type(NewTileSize) == "number" then
                    NewTileSize = UDim2.fromOffset(NewTileSize, NewTileSize)
                end

                if typeof(NewTileSize) == "UDim2" then
                    Items["BackgroundArt"].Instance.TileSize = NewTileSize
                    Items["SideBackgroundArt"].Instance.TileSize = NewTileSize
                end

                local NewGridState = Data.ShowGrid
                if NewGridState == nil then
                    NewGridState = Data.BackgroundGrid
                end

                if NewGridState == nil then
                    NewGridState = Data.GridEnabled
                end

                if type(NewGridState) == "boolean" then
                    Items["Grid"].Instance.Visible = NewGridState
                end

                if Data.GridTransparency ~= nil then
                    Items["Grid"].Instance.ImageTransparency = Data.GridTransparency
                end

                if Data.ShadeTransparency ~= nil then
                    Items["BackgroundShade"].Instance.BackgroundTransparency = Data.ShadeTransparency
                end

                if Data.ContentShadeTransparency ~= nil then
                    Items["BackgroundShade"].Instance.BackgroundTransparency = Data.ContentShadeTransparency
                end

                if Data.SideShadeTransparency ~= nil then
                    Items["SideBackgroundShade"].Instance.BackgroundTransparency = Data.SideShadeTransparency
                elseif Data.TabsShadeTransparency ~= nil then
                    Items["SideBackgroundShade"].Instance.BackgroundTransparency = Data.TabsShadeTransparency
                elseif Data.ShadeTransparency ~= nil then
                    Items["SideBackgroundShade"].Instance.BackgroundTransparency = math.clamp(Data.ShadeTransparency + 0.16, 0, 1)
                end
            end

            function Window:SetBackgroundStrength(Strength, TabsStrength)
                return Window:SetBackground({
                    Strength = Strength,
                    TabsStrength = TabsStrength
                })
            end

            function Window:SetBackgroundImage(Image, Options)
                local Data = type(Options) == "table" and Options or { }
                Data.Image = Image
                return Window:SetBackground(Data)
            end

            function Window:SetGrid(Bool, Transparency)
                if type(Bool) == "boolean" then
                    Items["Grid"].Instance.Visible = Bool
                end

                if Transparency ~= nil then
                    Items["Grid"].Instance.ImageTransparency = Transparency
                end
            end

            function Window:SetTheme(ThemeData)
                if type(ThemeData) ~= "table" then
                    return Library.Theme
                end

                local PresetName = ThemeData.Preset or ThemeData.preset or ThemeData.ThemePreset or ThemeData.themepreset
                if PresetName then
                    return Library:UseThemePreset(PresetName, ThemeData.Colors or ThemeData.colors or ThemeData.Theme or ThemeData.theme)
                end

                return Library:SetThemeColors(ThemeData)
            end

            function Window:GetTheme()
                return Library:GetThemeColors()
            end

            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Window.IsOpen = Bool

                if Bool then
                    Items["WindowScale"].Instance.Scale = 0.965
                    Items["FrameGlow"].Instance.ImageTransparency = 0.9
                    Items["TopAccentSheen"].Instance.Position = UDim2.new(-0.35, 0, 0.5, 0)
                    Items["TopAccentPulse"].Instance.BackgroundTransparency = 0.72
                    Items["WindowScale"]:Tween({Scale = 1}, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Items["FrameGlow"]:Tween({ImageTransparency = 0.84}, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    Items["TopAccentPulse"]:Tween({BackgroundTransparency = 0.58}, TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                else
                    Items["WindowScale"]:Tween({Scale = 0.965}, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
                    Items["FrameGlow"]:Tween({ImageTransparency = 0.94}, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
                    Items["TopAccentPulse"]:Tween({BackgroundTransparency = 0.82}, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
                end

                Items["MainFrame"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)

                for Index, Value in Library.OpenFrames do
                    Value:SetOpen(false)
                end
            end

            function Window:Center()
                local AbsPos = Items["MainFrame"].Instance.AbsolutePosition
                Items["MainFrame"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["MainFrame"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            Library:Connect(Items["SearchInput"].Instance:GetPropertyChangedSignal("Text"), function()
                local PageSearchData = Library.SearchItems[Library.CurrentPage]

                if not PageSearchData then
                    return
                end

                for Index, Value in PageSearchData do
                    local Name = Value.Name
                    local Element = Value.Item

                    if string.find(string.lower(Name), string.lower(Items["SearchInput"].Instance.Text)) then
                        if Items["SearchInput"].Instance.Text ~= "" then
                            Element.Instance.Visible = true
                        else
                            Element.Instance.Visible = true
                        end
                    else
                        Element.Instance.Visible = false
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if Window.IsOpen then
                    Library:GlobalUpdateOpenFrames()
                end
            end)

            Window:Center()
            Window:SetBackground({
                Image = BackgroundImage,
                Strength = BackgroundStrength,
                TabsStrength = TabsBackgroundStrength,
                ContentTransparency = ContentBackgroundTransparency,
                SideTransparency = SideBackgroundTransparency,
                ContentShadeTransparency = ContentBackgroundShadeTransparency,
                SideShadeTransparency = SideBackgroundShadeTransparency,
                ContentColor = ContentBackgroundColor,
                SideColor = SideBackgroundColor,
                ScaleType = BackgroundScaleType,
                SideScaleType = SideBackgroundScaleType,
                TileSize = BackgroundTileSize,
                Rotation = Params.BackgroundRotation or Params.backgroundrotation
            })
            Items["WindowScale"].Instance.Scale = 0.975
            Items["WindowScale"]:Tween({Scale = 1}, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",
                Icon = Params.Icon or Params.icon or "rbxassetid://102973834692853",

                Window = Self,
                Pages = { },
                Items = { },
                Active = false
            }

            local Items = { }
            do
                Items["Inactive"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Page.Window.Items["Pages"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Accent 2"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    CornerRadius = UDim.new(0, 8)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    Color = Library.Theme["Border"],
                    Transparency = 0.82,
                    Thickness = 1
                }):AddToTheme({Color = "Border"})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    PaddingBottom = UDim.new(0, 15),
                    PaddingTop = UDim.new(0, 15),
                    PaddingLeft = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 15)
                })

                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    Visible = false,
                    ImageColor3 = Library.Theme["TextPrimary"],
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 1,
                    Parent = Items["Inactive"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = Page.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                Items["ThreeDots"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    ImageColor3 = Color3.fromRGB(88, 90, 103),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://74238102610040",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -15, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0
                })

                Items["SubPages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    Visible = false,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Position = UDim2.new(0, 0, 0, 118),
                    Size = UDim2.new(1, 0, 1, -118),
                    BorderSizePixel = 0
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    PaddingRight = UDim.new(0, 15),
                    PaddingLeft = UDim.new(0, 15)
                })

                Page.Items = Items
            end

            local Debounce = false

            Items["Inactive"]:OnHover(function()
                if not Page.Active then
                    Items["Inactive"]:Tween({
                        BackgroundTransparency = 0.94,
                        BackgroundColor3 = Library.Theme["Foreground"]
                    }, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Accent 4"]}, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end, function()
                if not Page.Active then
                    Items["Inactive"]:Tween({
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Library.Theme["Accent 2"]
                    }, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextPrimary"]}, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end)

            function Page:Turn(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Page.Active = Bool

                if Bool then
                    Items["Inactive"]:Tween({
                        BackgroundTransparency = 0.9,
                        BackgroundColor3 = Library.Theme["Foreground"]
                    })
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Accent 4"]})
                    Items["ThreeDots"]:Tween({ImageColor3 = Library.Theme["Accent 3"]})
                    Items["SubPages"].Instance.Visible = true
                else
                    Items["Inactive"]:Tween({BackgroundTransparency = 1})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})
                    Items["ThreeDots"]:Tween({ImageColor3 = Color3.fromRGB(88, 90, 103)})
                    Items["SubPages"].Instance.Visible = false
                end

                Items["Page"]:FadeDescendants(Bool, function()
                    Debounce = false

                    if Items["Page"].Instance.Visible then
                        Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                    else
                        Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end
                end)
            end

            Items["Inactive"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    local startPos = Input.Position
                    local connection
                    connection = UserInputService.InputEnded:Connect(function(EndInput)
                        if EndInput.UserInputType == Input.UserInputType then
                            if (EndInput.Position - startPos).Magnitude < 10 then
                                for Index, Value in Page.Window.Pages do
                                    Value:Turn(Value == Page)
                                end
                            end
                            connection:Disconnect()
                        end
                    end)
                end
            end)

            if #Page.Window.Pages == 0 then
                Page:Turn(true)
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.SubPage = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",
                Icon = Params.Icon or Params.icon or "rbxassetid://102973834692853",
                Description = Params.Description or Params.description or "",

                Window = Self.Window,
                Page = Self,
                ColumnsData = { },
                Items = { },
                Active = false
            }

            local Items = { }
            do
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Page.Items["SubPages"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent 2"]
                }):AddToTheme({BackgroundColor3 = 'Accent 2'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    CornerRadius = UDim.new(0, 5)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    Color = Library.Theme["Border"],
                    Transparency = 0.86,
                    Thickness = 1
                }):AddToTheme({Color = "Border"})

                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    Visible = false,
                    ImageColor3 = Library.Theme["TextPrimary"],
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = function()
                    return Color3.fromRGB(117, 117, 131)
                end})

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inactive"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Page.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = function()
                    return Color3.fromRGB(117, 117, 131)
                end})

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Visible = false,
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Library.Theme["Border"],
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 15),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 15)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Library.Theme["Border"],
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 15),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 15),
                    PaddingLeft = UDim.new(0, 1)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            Library.SearchItems[Page] = { }

            local Debounce = false

            Items["Inactive"]:OnHover(function()
                if not Page.Active then
                    Items["Inactive"]:Tween({
                        BackgroundTransparency = 0.95,
                        BackgroundColor3 = Library.Theme["Foreground"]
                    }, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Accent 4"]}, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end, function()
                if not Page.Active then
                    Items["Inactive"]:Tween({
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Library.Theme["Accent 2"]
                    }, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextSecondary"]}, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end)

            function Page:Turn(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Page.Active = Bool

                if Bool then
                    Items["Inactive"]:Tween({
                        BackgroundTransparency = 0.92,
                        BackgroundColor3 = Library.Theme["Foreground"]
                    })

                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent 3"})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Accent 3"})

                    Items["Text"]:Tween({TextColor3 = Library.Theme["Accent 4"]})

                    Library.CurrentPage = Page

                    Page.Window.Items.ContentTitle.Instance.Text = Page.Name
                    Page.Window.Items.ContentDescription.Instance.Text = Page.Description
                else
                    Items["Inactive"]:Tween({BackgroundTransparency = 1})

                    Items["Icon"]:ChangeItemTheme({ImageColor3 = function()
                        return Color3.fromRGB(117, 117, 131)
                    end})

                    Items["Text"]:ChangeItemTheme({TextColor3 = function()
                        return Color3.fromRGB(117, 117, 131)
                    end})

                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})
                end

                Items["Page"]:FadeDescendants(Bool, function()
                    Debounce = false

                    if Items["Page"].Instance.Visible then
                        Items["Page"].Instance.Parent = Page.Page.Items["Page"].Instance
                    else
                        Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Click", function()
                for Index, Value in Page.Page.Pages do
                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Page.Pages == 0 then
                Page:Turn(true)
            end

            table.insert(Page.Page.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or { }

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Description = Params.Description or Params.description or "",
                Side = Params.Side or Params.side or 1,

                Window = Self.Window,
                Page = Self,
                Items = { },
            }

            local Items = { }
            do
                Items["Section"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Size = UDim2.new(1, 0, 0, 85),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Section"].Instance
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    Color = Color3.fromRGB(32, 35, 42)
                })

                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    Size = UDim2.new(1, 0, 0, 55),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance
                })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(32, 35, 42)
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["Accent 4"],
                    Text = Section.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 15, 0, 10),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ZIndex = 2
                }):AddToTheme({TextColor3 = 'Accent 4'})

                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    ImageColor3 = Library.Theme["TextPrimary"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.6000000238418579,
                    Size = UDim2.new(1, 15, 1, 15),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})

                Items["Description"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Section.Description,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 15, 0, 30),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ZIndex = 2
                })

                Items["Collapse"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    ImageColor3 = Library.Theme["TextSecondary"],
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://106481458734001",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0
                })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 55),
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Section.Items = Items
            end

            local IsCollapsed = false

            Items["Collapse"]:Connect("MouseButton1Down", function()
                IsCollapsed = not IsCollapsed
                Items["Content"].Instance.Visible = IsCollapsed

                Items["Collapse"]:Tween({Rotation = IsCollapsed and 0 or 180})
            end)

            return setmetatable(Section, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Items = { }
            do
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Toggle.Section.Items["Content"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Toggle.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["CheckImage"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ImageTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "rbxassetid://110577018362920",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                })

                Items["Toggle"]:OnHover(function()
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Accent 2"]})
                end, function()
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})
                end)

                Toggle.Items = Items
            end

            function Toggle:Set(Bool)
                Toggle.Value = Bool

                if Bool then
                    Items["Inline"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(1, 0, 1, 0)})
                    Items["CheckImage"]:Tween({ImageTransparency = 0})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})
                else
                    Items["Inline"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)})
                    Items["CheckImage"]:Tween({ImageTransparency = 1})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            if Library.SearchItems[Toggle.Page] then
                local SearchData = {
                    Name = Toggle.Name,
                    Item = Items["Toggle"]
                }

                table.insert(Library.SearchItems[Toggle.Page], SearchData)
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or { }

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Items = { }
            do
                Items["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Button.Section.Items["Content"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = Button.Name,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["Button"]:OnHover(function()
                    Items["Button"]:Tween({BackgroundColor3 = Library.Theme["Accent 2"]})
                end, function()
                    Items["Button"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})
                end)

                Button.Items = Items
            end

            function Button:Press()
                Items["Button"]:Tween({BackgroundColor3 = Library.Theme["Accent 4"]})
                task.wait(0.1)
                Items["Button"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})

                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            if Library.SearchItems[Button.Page] then
                local SearchData = {
                    Name = Button.Name,
                    Item = Items["Button"]
                }

                table.insert(Library.SearchItems[Button.Page], SearchData)
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 0,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = { }
            }

            local Items = { }
            do
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Slider.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["Minus"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Minus"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["MinusText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Minus"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "-",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["MinusText"].Instance,
                    PaddingBottom = UDim.new(0, 3)
                })

                Items["Plus"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, 0, 1, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Plus"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["PlusText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Plus"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "+",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["PlusText"].Instance,
                    PaddingBottom = UDim.new(0, 3)
                })

                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 30, 1, -5),
                    Size = UDim2.new(1, -60, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent 4"]
                }):AddToTheme({BackgroundColor3 = 'Accent 4'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["Dragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent 3"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Dragger"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Dragger"].Instance,
                    Thickness = 1.5,
                    Color = Library.Theme["Border"]
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "50",
                    AnchorPoint = Vector2.new(1, 0),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["RealSlider"]:OnHover(function()
                    Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Accent 2"]})
                end, function()
                    Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})
                end)

                Items["Plus"]:OnHover(function()
                    Items["Plus"]:Tween({BackgroundColor3 = Library.Theme["Accent 2"]})
                end, function()
                    Items["Plus"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})
                end)

                Items["Minus"]:OnHover(function()
                    Items["Minus"]:Tween({BackgroundColor3 = Library.Theme["Accent 2"]})
                end, function()
                    Items["Minus"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})
                end)

                Slider.Items = Items
            end

            function Slider:Set(Value)
                if type(Value) ~= "number" or Value ~= Value then
                    Value = Slider.Default
                end
                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                local barWidth = Items["RealSlider"].Instance.AbsoluteSize.X
                local ratio = 0
                if barWidth > 0 and Slider.Max > Slider.Min then
                    ratio = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
                    ratio = math.clamp(ratio, 0, 1)
                end
                Items["Accent"]:Tween({Size = UDim2.new(ratio, 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))

                local draggerOffset = 0
                Items["Dragger"]:Tween({Position = UDim2.new(ratio, draggerOffset, 0.5, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))

                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local sliderBar = Items["RealSlider"].Instance
                local barWidth = sliderBar.AbsoluteSize.X
                if barWidth <= 0 then
                    return Slider.Value
                end
                local relativeX = Input.Position.X - sliderBar.AbsolutePosition.X
                local t = math.clamp(relativeX / barWidth, 0, 1)
                local newValue = Slider.Min + (Slider.Max - Slider.Min) * t
                if newValue ~= newValue then
                    return Slider.Value
                end
                return newValue
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            if Library.SearchItems[Slider.Page] then
                local SearchData = {
                    Name = Slider.Name,
                    Item = Items["Slider"]
                }

                table.insert(Library.SearchItems[Slider.Page], SearchData)
            end

            local InputChanged

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)
                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})
                    Items["Value"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil

                            Items["Text"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})
                            Items["Value"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)
                        Slider:Set(Value)
                    end
                end
            end)

            Items["Plus"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    local step = 10 ^ (-Slider.Decimals)
                    Slider:Set(Slider.Value + step)
                end
            end)

            Items["Minus"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    local step = 10 ^ (-Slider.Decimals)
                    Slider:Set(Slider.Value - step)
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or { }

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                MaxSize = Params.MaxSize or Params.maxsize or 120,
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                IsOpen = false,
                Items = { }
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = { }
            do
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 55),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "...",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["ArrowIcon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ImageColor3 = Library.Theme["TextSecondary"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://99324149494042",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                })

                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 22, 0, 139),
                    Size = UDim2.new(0, 259, 0, 97),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Color = Color3.fromRGB(32, 35, 42),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ScrollBarImageColor3 = Library.Theme["Border"],
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    Size = UDim2.new(1, -20, 1, -20),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["RealDropdown"]:OnHover(function()
                    Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Accent 2"]})
                end, function()
                    Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})
                end)

                Dropdown.Items = Items
            end

            function Dropdown:Set(Value)
                if Dropdown.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                        else
                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Library.Theme["Accent 2"]
                }):AddToTheme({BackgroundColor3 = 'Accent 2'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = OptionButton.Instance,
                    CornerRadius = UDim.new(0, 5)
                })

                local OptionText = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = OptionButton.Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Value,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = function()
                    return Color3.fromRGB(117, 117, 131)
                end})

                local AccentCircle = Library:Create("Frame", {
                    Name = "\0",
                    Parent = OptionButton.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 6, 0, 6),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent 3"]
                }):AddToTheme({BackgroundColor3 = 'Accent 3'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = AccentCircle.Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                local OptionData = {
                    Button = OptionButton,
                    AccentCircle = AccentCircle,
                    OptionText = OptionText,
                    Name = Value,
                    IsSelected = false
                }

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionText:ChangeItemTheme({TextColor3 = "Accent 3"})

                        AccentCircle:Tween({BackgroundTransparency = 0})
                        OptionText:Tween({Position = UDim2.new(0, 28, 0.5, 0), TextColor3 = Library.Theme["Accent 3"]})
                        OptionButton:Tween({BackgroundTransparency = 0})
                    else
                        OptionText:ChangeItemTheme({TextColor3 = function()
                            return Color3.fromRGB(117, 117, 131)
                        end})

                        AccentCircle:Tween({BackgroundTransparency = 1})
                        OptionText:Tween({Position = UDim2.new(0, 0, 0.5, 0), TextColor3 = Library.Theme["TextSecondary"]})
                        OptionButton:Tween({BackgroundTransparency = 1})
                    end
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do
                    Dropdown:Add(Value)
                end
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false
            local RenderStepped
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            Dropdown.AttachedButton = RealDropdown
            Dropdown.CanUpdateNow = false
            Dropdown.Frame = OptionHolder

            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true

                if Dropdown.IsOpen then
                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})
                    Items["Value"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})

                    OptionHolder.Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + GuiInset)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X, 0, Dropdown.MaxSize)

                    OptionHolder.Parent = Library.Holder.Instance
                    OptionHolder.Visible = true
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + 10 + GuiInset)})

                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false
                        Dropdown.CanUpdateNow = true
                    end)

                    for Index, Value in Library.OpenFrames do
                        if not Params.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown
                else
                    Items["Text"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})
                    Items["Value"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})

                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["OptionHolder"]:FadeDescendants(false, function()
                        OptionHolder.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                        Dropdown.CanUpdateNow = false
                    end)

                    if Library.OpenFrames[Dropdown] then
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                    else
                        if not Params.Parent then
                            Value.ZIndex = Dropdown.IsOpen and 3 or 1
                        else
                            Value.ZIndex = Dropdown.IsOpen and 6 or 1
                        end
                    end
                end
            end

            if Library.SearchItems[Dropdown.Page] then
                local SearchData = {
                    Name = Dropdown.Name,
                    Item = Items["Dropdown"]
                }

                table.insert(Library.SearchItems[Dropdown.Page], SearchData)
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Items["OptionHolder"]:IsMouseOverFrame() then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    Dropdown.IsOpen = not Items["OptionHolder"]:IsClipped(Dropdown.Section.Items["Section"].Instance.Parent)
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            for Index, Value in Dropdown.OptionItems do
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or { }

            local Label = {
                Name = Params.Name or Params.name or "Label",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Items = { }
            do
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Label.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = Label.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Label.Items = Items
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            if Library.SearchItems[Label.Page] then
                local SearchData = {
                    Name = Label.Name,
                    Item = Items["Label"]
                }

                table.insert(Library.SearchItems[Label.Page], SearchData)
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        Library.Colorpicker = function(Self, Params)
            Params = Params or { }

            local Colorpicker = {
                Name = Params.Name or Params.name or "Colorpicker",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or Library.Theme["TextPrimary"],
                Callback = Params.Callback or Params.callback or function() end,
                Alpha = Params.Alpha or Params.alpha or 0,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { },
            }

            local Items = { }
            do
                Items["Colorpicker"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Colorpicker.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 55),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Colorpicker"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Colorpicker.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["RealColorpicker"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Colorpicker"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealColorpicker"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealColorpicker"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "#7482ff",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 38, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["PaletteIcon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealColorpicker"].Instance,
                    ImageColor3 = Library.Theme["TextSecondary"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://125763227537432",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0
                })

                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealColorpicker"].Instance,
                    TextColor3 = Library.Theme["TextPrimary"],
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["RealColorpicker"]:OnHover(function()
                    Items["RealColorpicker"]:Tween({BackgroundColor3 = Library.Theme["Accent 2"]})
                end, function()
                    Items["RealColorpicker"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})
                end)

                Colorpicker.Items = Items
            end

            local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                Name = Colorpicker.Name,
                Default = Colorpicker.Default,
                Items = Items,
                Flag = Colorpicker.Flag,
                Callback = Colorpicker.Callback
            })

            if Library.SearchItems[Colorpicker.Page] then
                local SearchData = {
                    Name = Colorpicker.Name,
                    Item = Items["Colorpicker"]
                }

                table.insert(Library.SearchItems[Colorpicker.Page], SearchData)
            end

            return setmetatable(Colorpicker, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or { }

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Numeric = Params.Numeric or Params.numeric or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Items = { }
            do
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Textbox.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 55),
                    BorderSizePixel = 0
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Textbox"].Instance,
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    ClipsDescendants = true,
                    AnchorPoint = Vector2.new(0, 1),
                    Size = UDim2.new(1, 0, 0, 30),
                    Position = UDim2.new(0, 0, 1, 0),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Foreground"]
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    Active = true,
                    Selectable = true,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["TextSecondary"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -20, 0, 15),
                    TextColor3 = Library.Theme["TextSecondary"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BorderSizePixel = 0
                })

                Items["Background"]:OnHover(function()
                    Items["Background"]:Tween({BackgroundColor3 = Library.Theme["Accent 2"]})
                end, function()
                    Items["Background"]:Tween({BackgroundColor3 = Library.Theme["Foreground"]})
                end)

                Textbox.Items = Items
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            if Library.SearchItems[Textbox.Page] then
                local SearchData = {
                    Name = Textbox.Name,
                    Item = Items["Textbox"]
                }

                table.insert(Library.SearchItems[Textbox.Page], SearchData)
            end

            Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                if Textbox.Finished then
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end

                Items["Text"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})
                Items["Input"]:Tween({TextColor3 = Library.Theme["TextSecondary"]})
            end)

            if not Textbox.Finished then
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            Items["Input"]:Connect("Focused", function()
                Items["Text"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})
                Items["Input"]:Tween({TextColor3 = Library.Theme["TextPrimary"]})
            end)

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return setmetatable(Textbox, Library)
        end

        Library.CreateSettingsPage = function(Self)
            local SettingsPage = Self:Page({Name = "Settings", Icon = "rbxassetid://118813823415057"})

            local GeneralSubPage = SettingsPage:SubPage({Name = "General", Description = "Save & load configs", Icon = "rbxassetid://74595432438103"})

            do
                local ConfigsSection = GeneralSubPage:Section({Name = "Configs", Description = "Save & load configs", Side = 1})
                local ConfigName
                local ConfigSelected
                local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                local ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs",
                    Flag = "ConfigsDropdown",
                    Items = { },
                    Multi = false,
                    MaxSize = 150,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                Library:GetConfigsList(ConfigsDropdown)

                ConfigsSection:Textbox({
                    Name = "Config name",
                    Flag = "ConfigName",
                    Placeholder = "Config name",
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if ConfigName then
                            if ConfigName == "" then
                                return
                            end

                            writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                            Library:GetConfigsList(ConfigsDropdown)
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if ConfigSelected then
                            if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                delfile(ConfigsFolder .. ConfigSelected .. ".json")
                                Library:GetConfigsList(ConfigsDropdown)
                            end
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if ConfigSelected then
                            if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                local ConfigContent = readfile(ConfigsFolder .. ConfigSelected .. ".json")
                                local Success, Error = Library:LoadConfig(ConfigContent)
                            end
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Save",
                    Callback = function()
                        if ConfigSelected then
                            if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                pcall(function()
                                    writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                                end)
                            end
                        end
                    end
                })

                ConfigsSection:Label({Name = "UI Bind"}):Keybind({Flag = "UIBind", Mode = "Toggle", Default = "None", Callback = function(Value)
                    Library.MenuKeybind = Flags["UIBind"].Key
                end})

                ConfigsSection:Button({
                    Name = "Unload",
                    Callback = function()
                        Library:Exit()
                    end
                })
            end

            do
                local ThemingSection = GeneralSubPage:Section({Name = "Theming", Description = "Adjust interface colors", Side = 2})

                for Index, Value in Library.Theme do
                    ThemingSection:Colorpicker({Name = Index, Flag = Index, Default = Value, Callback = function(Value)
                        Library.Theme[Index] = Value
                        Library:ChangeTheme(Index, Value)
                    end})
                end
            end
        end
    end
end

getgenv().Library = Library
return Library
