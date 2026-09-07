--[=[
    Nexonix
    A reusable Roblox UI library with windows, pages, sections, themed
    controls, notifications, keybinds, search, and config-ready flags.

    Public entry point:
        local Nexonix = loadstring(game:HttpGet(URL))()
        local window = Nexonix:Window({})

    The original source registered its library globally but did not return it,
    which made loadstring-based consumption unusable. The final return below
    preserves the global compatibility path and enables standard library use.
]=]

--[[
    Made by samet

    example/documentation is at the bottom
    date: 5/9/2026 11:40 PM

    If you have any issues or bugs, please let me know in the ticket or dms.
]]

if getgenv().Library and getgenv().Library.Exit then
    getgenv().Library:Exit()
end

local Library = getgenv().Library
if type(Library) ~= "table" then
    Library = { }
    getgenv().Library = Library
end

if not getgenv().LibraryUnloading then
    getgenv().LibraryUnloading = true

    if type(Library.Exit) == "function" then
        pcall(Library.Exit, Library)
    end

    getgenv().LibraryUnloading = false
end

local Directory = "nexonix"
local Folders = {
    "/Configs",
    "/Assets",
}

if not isfolder(Directory) then 
    makefolder(Directory)
end

for _, Folder in Folders do 
    if not isfolder(Directory .. Folder) then 
        makefolder(Directory .. Folder)
    end
end

Library.Directory = "nexonix"
Library.Folders = {
    Configs = "/Configs",
    Assets = "/Assets",
}

-- Bad executor support (atleast by a bit)
cloneref = cloneref or function(Object) return Object end 

--#region Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local CoreGui = cloneref(game:GetService("CoreGui"))
--#endregion

gethui = gethui or function() return CoreGui end

--#region Variables 
local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled or false
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())
--#endregion

local Library = { 
    Flags = { },
    MenuKeybind = tostring(Enum.KeyCode.X),

    Directory = "nexonix",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs"
    },

    FontSize = 16,

    Animation = {
        Time = 0.3,
        Style = "Quint",
        Direction = "Out"
    },

    ZIndexOrder = {
        ["OptionHolder"] = 4,
        ["KeybindWindow"] = 4, -- burp
        ["ColorpickerWindow"] = 6
    },

    Theme = nil,

    -- Ignore below
    Threads = { },
    Connections = { },
    SetFlags = { },

    ThemingStuff = { },
    ThemeMap = { },

    SearchItems = { },

    OpenFrames = { },

    KeyList = nil,

    Holder = nil,
    UnusedHolder = nil,

    Font = nil,
} do 
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

    -- Folders
    if not isfolder(Library.Directory) then 
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do 
        if not isfolder(Library.Directory .. Folder) then 
            makefolder(Library.Directory .. Folder)
        end
    end

    local Themes = {
        ["Preset"] = {
            ["Background"] = Color3.fromRGB(24, 26, 30),
            ["Inline"] = Color3.fromRGB(29, 30, 36),
            ["Accent"] = Color3.fromRGB(78, 95, 255),
            ["Tab"] = Color3.fromRGB(34, 37, 57),
            ["Dark Icon"] = Color3.fromRGB(64, 64, 73),
            ["Element"] = Color3.fromRGB(38, 38, 50),
            ["Liner"] = Color3.fromRGB(39, 39, 46),
            ["Outline"] = Color3.fromRGB(47, 49, 53),
            ["Dark Text"] = Color3.fromRGB(108, 109, 116),
            ["Text"] = Color3.fromRGB(255, 255, 255),
            ["Toggle"] = Color3.fromRGB(57, 59, 75),
            ["Hovered Element"] = Color3.fromRGB(46, 46, 54)
        }
    }

    Library.Theme = Themes.Preset

    -- Custom Font
    local CustomFont = { } do
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

            writefile(`{Library.Directory .. Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Directory .. Library.Folders.Assets}/{Name}.font`))
        end

        Library.Font = CustomFont:New("figtree-Semibold", 400, "Regular", {
            Id = "Figtree-Semibold",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Figtree-SemiBold.ttf"
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
                continue
            end

            if Property == "TextSize" then 
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then 
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then 
                if Property == "AutoButtonColor" then 
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then 
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
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

                    return
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
                continue 
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
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
                ZIndex = 1,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left", 
                UDim2.new(0, 0, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "L"
            },

            {Button = MakeEdge(
                "Right", 
                UDim2.new(1, -EdgeThickness, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2.new(0, 0, 0, 0), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom", 
                UDim2.new(0, 0, 1, -EdgeThickness), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "B"
            },
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

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return math.floor(Number * Multiplier) / Multiplier
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
            warn("Failed to get config:\n"..Result)
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
                    continue
                end

                if type(Value) == "table" and Value.Key then 
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

        if not Library.ThemeMap[Object] then 
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
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

    Library.NotifHolder = Library:Create("Frame", {
        Name = "\0",
        Parent = Library.Holder.Instance,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, GuiInset),
        AutomaticSize = Enum.AutomaticSize.X
    })
    
    Library:Create("UIPadding", {
        Name = "\0",
        Parent = Library.NotifHolder.Instance,
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12)
    })
    
    Library:Create("UIListLayout", {
        Name = "\0",
        Parent = Library.NotifHolder.Instance,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })    

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,

                Items = { }
            }

            local Items = { } do 
                Items["ColorpickerButton"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Data.Parent.Instance,
                    ImageColor3 = Color3.fromRGB(255, 74, 116),
                    AutoButtonColor = false,
                    Image = "rbxassetid://77492218953155",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0
                })                

                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0.8529205918312073, 0, 0.4096846282482147, 0),
                    Size = UDim2.new(0, 210, 0, 210),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 12, 0, 36),
                    Size = UDim2.new(1, -50, 1, -50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 74, 116)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Library.Theme["Text"],
                    Thickness = 2
                }):AddToTheme({Color = 'Text'})
                
                Items["Hue"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position = UDim2.new(1, -12, 0, 12),
                    Size = UDim2.new(0, 14, 1, -24),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                })
                
                Items["HueDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Library.Theme["Text"],
                    Thickness = 2
                }):AddToTheme({Color = 'Text'})
                
                Items["Alpha"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 12, 0, 12),
                    Size = UDim2.new(1, -50, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 74, 116)
                })
                
                Items["Checkers"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 6, 0, 6),
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    Image = "http://www.roblox.com/asset/?id=18274452449",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Checkers"].Instance,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.37, 0.5),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Checkers"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Items["AlphaDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Library.Theme["Text"],
                    Thickness = 2
                }):AddToTheme({Color = 'Text'})                

                Colorpicker.Items = Items
            end

            Colorpicker.Holder = Items["ColorpickerWindow"]

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()
        
                Items["ColorpickerButton"]:Tween({ImageColor3 = Colorpicker.Color})
                Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Transparency = 1 - Colorpicker.Alpha
                }
    
                if not IsFromAlpha then 
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false 
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 
                
                if Colorpicker.IsOpen then 
                    ColorpickerWindow.Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + GuiInset)

                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= IsSettings and not Data.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        ColorpickerWindow.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then 
                        Library.OpenFrames[Colorpicker] = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
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
    
                local SlideX = math.clamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.92)
                local SlideY = math.clamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.92)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(SlideX, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged
    
            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Hue = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.92)
    
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
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
    
                local SlideX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.92)
    
                Items["AlphaDragger"]:Tween({Position = UDim2.new(SlideX, 0, 0, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update(true)
            end
    
            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- lul
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  
    
                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.92)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.92)
    
                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 0.92)
                    
                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 0.92)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, HuePositionY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["AlphaDragger"]:Tween({Position = UDim2.new(AlphaPositionX, 0, 0, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
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
                    if Colorpicker.IsOpen then
                        if Items["ColorpickerWindow"]:IsMouseOverFrame() then 
                            return 
                        end

                        Colorpicker:SetOpen(false)
                    end
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

                Items = { },
            }

            local Items = { } do
                Items["SettingsButton"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Data.Parent.Instance,
                    AutoButtonColor = false,
                    Image = "rbxassetid://123677974615593",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0
                })
                        
                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Visible = false,
                    Size = UDim2.new(0, 231, 0, 0),
                    Position = UDim2.new(0, 45, 0, 171),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    PaddingTop = UDim.new(0, 12),
                    PaddingBottom = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["KeybindWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "rbxassetid://113351170187860",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 17),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["KeyButton"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Space",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Modes"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Modes"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["Hold"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Modes"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Hold",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Hold"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Modes"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Toggle",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })                

                Items["Toggle"]:OnHover(function()
                    if Keybind.Mode == "Toggle" then
                        return 
                    end

                    Items["Toggle"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    if Keybind.Mode == "Toggle" then
                        return 
                    end
                
                    Items["Toggle"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)

                Items["Hold"]:OnHover(function()
                    if Keybind.Mode == "Hold" then
                        return 
                    end

                    Items["Hold"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    if Keybind.Mode == "Hold" then
                        return 
                    end
                
                    Items["Hold"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)
                
                Keybind.Items = Items
            end

            Keybind.Holder = Items["KeybindWindow"]

            local Debounce = false
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["SettingsButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true 
                
                if Keybind.IsOpen then 
                    KeybindWindow.Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset)

                    KeybindWindow.Parent = Library.Holder.Instance
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings and not Data.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then 
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end

            local KeybindObject 

            if Library.KeyList then 
                KeybindObject = Library.KeyList:Add("")
            end

            local Update = function()
                if KeybindObject then 
                    KeybindObject:Set(Data.Name)
                    KeybindObject:SetStatus(Keybind.Toggled)

                    if Keybind.Mode == "Hold" then 
                        KeybindObject:SetMode(Keybind.Toggled and "Holding" or "Off")
                    else
                        KeybindObject:SetMode(Keybind.Toggled and "Toggled" or "Off")
                    end
                end
            end
    
            function Keybind:SetMode(Mode)
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Mode == "Hold" then -- cancer
                    Items["Hold"]:ChangeItemTheme({BackgroundColor3 = 'Accent', TextColor3 = 'Text'})
                    Items["Hold"]:Tween({BackgroundColor3 = Library.Theme["Accent"]})
                    
                    Items["Toggle"]:ChangeItemTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})
                    Items["Toggle"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                else
                    Items["Hold"]:ChangeItemTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})
                    Items["Hold"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                
                    Items["Toggle"]:ChangeItemTheme({BackgroundColor3 = 'Accent', TextColor3 = 'Text'})
                    Items["Toggle"]:Tween({BackgroundColor3 = Library.Theme["Accent"]})
                end
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
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

                if Data.Toggle then
                    Data.Toggle:Set(Keybind.Toggled)
                end
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
                
                Update()
            end
    
            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)
    
                    Key = Key.Name == "Backspace" and "None" or Key.Name
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
    
                    Keybind.Value = TextToDisplay
                    Items["Text"].Instance.Text = TextToDisplay
    
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
                    Items["Text"].Instance.Text = TextToDisplay
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                Keybind.Picking = false
                Update()
            end
    
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 
    
                Items["Text"].Instance.Text = ". . ."
    
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

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Keybind.IsOpen and not Items["KeybindWindow"]:IsMouseOverFrame() then
                        Keybind:SetOpen(false)
                    end
                end
            end)

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Toggle"
                Keybind:SetMode("Toggle")
            end)
    
            Items["Hold"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Hold"
                Keybind:SetMode("Hold")
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
    
            Items["SettingsButton"]:Connect("MouseButton1Down", function()
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

        Library.Notification = function(Self, Name, Duration, Color)
            local Items = { } do 
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    Size = UDim2.new(0, 300, 0, 0),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingTop = UDim.new(0, 12),
                    PaddingBottom = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance
                })
                
                Items["Duration"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Dark Text"],
                    Text = Duration .. "s",
                    Size = UDim2.new(0, 0, 0, 16),
                    Position = UDim2.new(1, 0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Dark Text'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    Size = UDim2.new(1, -25, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextYAlignment = Enum.TextYAlignment.Top
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    Position = UDim2.new(0, 0, 1, 10),
                    Size = UDim2.new(1, 25, 0, 6),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    PaddingBottom = UDim.new(0, 18)
                })                
            end

            for Index, Value in Items do 
                if Value.Instance:IsA("Frame") then
                    Value.Instance.BackgroundTransparency = 1
                elseif Value.Instance:IsA("TextLabel") then 
                    Value.Instance.TextTransparency = 1
                end
            end 

            local GetSize = function()
                local AbsSize = Items["Notification"].Instance.AbsoluteSize
                Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
                task.wait()
                Items["Notification"].Instance.Size = UDim2.new(0, AbsSize.X, 0, AbsSize.Y)
                return AbsSize
            end

            local OldDuration = Duration

            task.spawn(function()
                while task.wait(0.1) do 
                    local NewDuration = Duration - 0.1
                    Duration = NewDuration

                    Items["Duration"].Instance.Text = Library:Round(NewDuration, 0.1) .. "s"
                end
            end)

            local Size = GetSize()
            task.wait()
            Items["Notification"].Instance.Size = UDim2.new(0, 0, 0, Size.Y)

            local Info = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)

            Library:Thread(function()
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween({BackgroundTransparency = 0}, Info)
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value:Tween({TextTransparency = 0}, Info)
                    end
                end

                Items["Notification"]:Tween({Size = UDim2.new(0, Size.X, 0, Size.Y)}, Info)
                Items["Liner"]:Tween({Size = UDim2.new(0, 0, 0, 6)}, TweenInfo.new(OldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0))

                task.delay(OldDuration + 0.1, function()
                    for Index, Value in Items do 
                        if Value.Instance:IsA("Frame") then
                            Value:Tween({BackgroundTransparency = 1})
                        elseif Value.Instance:IsA("TextLabel") then 
                            Value:Tween({TextTransparency = 1})
                        end
                    end

                    Items["Notification"]:Tween({Size = UDim2.new(0, 0, 0, 0)}, Info)
                    task.wait(0.5)
                    Items["Notification"].Instance:Destroy()
                end)
            end)
        end

        Library.Watermark = function(Self, Params)
            Params = Params or { }

            local Watermark = {
                Name = Params.Name or Params.name or "Nexonix",
                Logo = Params.Logo or Params.logo or "rbxassetid://77749228793011",

                Items = { }
            }

            local Items = { } do 
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -15, 0, 15),
                    Size = UDim2.new(0, 0, 0, 50),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingRight = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Watermark.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 40, 0, 40),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Logo"].Instance
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Watermark"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Watermark.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 16),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})      
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Size = UDim2.new(0, 2, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                }):AddToTheme({BackgroundColor3 = 'Liner'})

                Watermark.Items = Items 
            end

            function Watermark:AddItem(Icon, Text)
                local NewItem = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 30),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                local NewIcon = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = NewItem.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0
                })
                
                local NewText = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = NewItem.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Text,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 28, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})           
                
                return NewText, NewItem
            end
            
            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool 
            end

            function Watermark:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            return setmetatable(Watermark, Library)
        end

        Library.KeybindList = function(Self, Params)
            Params = Params or { }

            local KeybindList = {
                Name = Params.Name or Params.name or "Keybind List",

                Items = { }
            }

            local Items = { } do 
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 15, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["KeybindList"]:MakeDraggable()
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    PaddingTop = UDim.new(0, 12),
                    PaddingBottom = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["KeybindList"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = KeybindList.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Library:Create("UISizeConstraint", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    MinSize = Vector2.new(200, 0)
                })
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Position = UDim2.new(0, 0, 0, 24),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                }):AddToTheme({BackgroundColor3 = 'Liner'})
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 35),
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                KeybindList.Items = Items 
            end

            function KeybindList:Center()
                local AbsPos = Items["KeybindList"].Instance.AbsolutePosition
                Items["KeybindList"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["KeybindList"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function KeybindList:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function KeybindList:SetVisibility(Bool)
               Items["KeybindList"].Instance.Visible = Bool 
            end 

            function KeybindList:Add(Name)
                local NewKey = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                
                local NewText = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = NewKey.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 25, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                local NewCheck = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = NewKey.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "rbxassetid://114461119629011",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Dark Icon'})
                
                local NewMode = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = NewKey.Instance,
                    TextColor3 = Library.Theme["Dark Text"],
                    Text = "Toggled",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Dark Text'})      

                function NewKey:SetStatus(Bool)
                    if Bool then 
                        NewCheck:ChangeItemTheme({ImageColor3 = "Text"})
                        NewText:ChangeItemTheme({TextColor3 = "Text"})

                        NewCheck:Tween({ImageColor3 = Library.Theme.Text})
                        NewText:Tween({TextColor3 = Library.Theme.Text})
                    else
                        NewCheck:ChangeItemTheme({ImageColor3 = "Dark Icon"})
                        NewText:ChangeItemTheme({TextColor3 = "Dark Text"})

                        NewCheck:Tween({ImageColor3 = Library.Theme["Dark Icon"]})
                        NewText:Tween({TextColor3 = Library.Theme["Dark Text"]})
                    end
                end

                function NewKey:Set(Name)
                    NewText.Instance.Text = Name
                end

                function NewKey:SetMode(Mode)
                   NewMode.Instance.Text = Mode
                end

                return NewKey
            end

            KeybindList:Center()
            Library.KeyList = KeybindList

            return setmetatable(KeybindList, Library)
        end

        Library.Tooltip = function(Self, Text)
            local Object = Self.Instance

            if not Object then 
                return 
            end
    
            if Text == "" then 
                return 
            end
    
            if Text == nil then
                return
            end
            
            local Items = { } do 
                Items["Tooltip"] = Library:Create("Frame", {
                    Name = "\0",
                    ClipsDescendants = true,
                    Parent = Library.Holder.Instance,
                    Size = UDim2.new(0, 0, 0, 35),
                    Position = UDim2.new(0, 15, 0, 530),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Tooltip"].Instance
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Tooltip"].Instance,
                    PaddingRight = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Tooltip"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Text,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 4, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Tooltip"].Instance,
                    Position = UDim2.new(0, -12, 0, 0),
                    Size = UDim2.new(0, 6, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance
                })
                
                Items["Liner2"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 3, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
            end            
            
            local GetSize = function()
                local AbsSize = Items["Tooltip"].Instance.AbsoluteSize
                Items["Tooltip"].Instance.AutomaticSize = Enum.AutomaticSize.None
                task.wait()
                Items["Tooltip"].Instance.Size = UDim2.new(0, AbsSize.X, 0, AbsSize.Y)
                return AbsSize
            end
    
            local TweenDescendants = function(Bool)
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween({BackgroundTransparency = Bool and 1 or 0})
                    elseif Value.Instance:IsA("TextLabel") then
                        Value:Tween({TextTransparency = Bool and 1 or 0})
                    end
                end
            end
    
            TweenDescendants(true)
    
            local Size = GetSize()
            Items["Tooltip"].Instance.Size = UDim2.new(0, 0, 0, Size.Y)
    
            local RenderStepped 
            
            Self:OnHover(function()
                local MouseLocation = UserInputService:GetMouseLocation()
                Items["Tooltip"].Instance.Position = UDim2.new(0, MouseLocation.X + 20, 0, MouseLocation.Y + 20)
    
                Items["Tooltip"]:Tween({Size = UDim2.new(0, Size.X, 0, Size.Y)})
                TweenDescendants(false)
    
                RenderStepped = RunService.RenderStepped:Connect(function()
                    MouseLocation = UserInputService:GetMouseLocation()
                    Items["Tooltip"].Instance.Position = UDim2.new(0, MouseLocation.X + 20, 0, MouseLocation.Y + 20)
                end)
            end, function()
                Items["Tooltip"]:Tween({Size = UDim2.new(0, 0, 0, Size.Y)})
                TweenDescendants(true)
    
                RenderStepped:Disconnect()
                RenderStepped = nil
            end)
        end

        Library.Window = function(Self, Params)
            Params = Params or { }

            local Window = {
                Logo = Params.Logo or Params.logo or "rbxassetid://77749228793011",

                IsOpen = true,
                Pages = { },
                Items = { },
                Current = nil,
            }

            local Items = { } do 
                if IsMobile then 
                    Library:Create("UIScale", {
                        Parent = Items["MainFrame"],
                        Scale = 0.65
                    })
                end

                Items["MainFrame"] = Library:Create("TextButton", {
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 765, 0, 500),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2.new(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y))
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    CornerRadius = UDim.new(0, 14)
                })
                
                Items["Side"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 65, 1, -120),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    CornerRadius = UDim.new(0, 18)
                })
                
                Items["_Avatar"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    AnchorPoint = Vector2.new(0.5, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 1, -16),
                    Size = UDim2.new(0, 42, 0, 42),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["_Avatar"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["_Avatar"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Library.Theme["Outline"],
                    Thickness = 1.2000000476837158
                }):AddToTheme({Color = 'Outline'})
                
                Items["AvatarImage"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["_Avatar"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, -6, 1, -6),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["AvatarImage"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Items["Pages"] = Library:Create("TextButton", {
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Items["Side"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, -60),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    PaddingTop = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 65),
                    BorderSizePixel = 0
                })
                
                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0.5, 0),
                    Size = UDim2.new(0, 40, 0, 40),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Logo"].Instance
                })
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 67, 0.5, 0),
                    Size = UDim2.new(0, 2, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(36, 37, 41)
                }):AddToTheme({BackgroundColor3 = 'Liner'})
                
                Items["Search"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 84, 0.5, 0),
                    Size = UDim2.new(0, 300, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Search"].Instance,
                    CornerRadius = UDim.new(0, 10)
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Search"].Instance,
                    ImageColor3 = Library.Theme["Dark Text"],
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "rbxassetid://115682280990954",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Dark Text'})
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Search"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Dark Text"],
                    PlaceholderText = "Search in this tab..",
                    Size = UDim2.new(1, -50, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 42, 0.5, 0),
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Dark Text'})
                
                Items["SettingsButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -12, 0, 12),
                    Size = UDim2.new(0, 40, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["SettingsButton"].Instance
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["SettingsButton"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "rbxassetid://77336523487505",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0
                })             
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 40, 0, 60),
                    Size = UDim2.new(1, -40, 1, -60),
                    BorderSizePixel = 0
                })                

                Items["OpenClose"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 10),
                    Size = UDim2.new(0, 100, 0, 40),
                    Selectable = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(29, 30, 36)
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Items["OpenCloseLogo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["OpenClose"].Instance,
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 25, 0, 25),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["OpenCloseLogo"].Instance
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["OpenClose"].Instance,
                    CornerRadius = UDim.new(0, 10)
                })
                
                Items["OpenAndClose"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["OpenClose"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Close",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 20, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})                

                Window.Items = Items
            end

            Window.SearchQuery = ""

            local Normalize = function(Text)
                return string.lower(tostring(Text or "")):gsub("%s+", "")
            end

            local CacheObjects = function(Holder)
                local FadeObjects = { }
            
                local Objects = Holder:GetDescendants()
                table.insert(Objects, Holder)
            
                for _, Object in Objects do
                    local Properties = Library:GetTweenProperty(Object)
            
                    if Properties then
                        if type(Properties) ~= "table" then
                            Properties = { Properties }
                        end
            
                        local Original = {}
            
                        for _, Property in Properties do
                            Original[Property] = Object[Property]
                        end
            
                        table.insert(FadeObjects, {
                            Object = Object,
                            Properties = Properties,
                            Original = Original
                        })
                    end
                end
            
                return FadeObjects
            end

            local SearchFade = function(FadeData, Show)
                local Object = FadeData.Object
                local TweenData = { }
            
                for _, Property in FadeData.Properties do
                    TweenData[Property] = Show and FadeData.Original[Property] or 1
                end
            
                Library:Tween(TweenData, nil, Object)
            end

            function Window:RegisterSearchItem(Data)
                Data = Data or {}

                local SearchItem = {
                    Name = Data.Name or Data.name or "",
                    Page = Data.Page or Data.page,
                    Instance = Data.Instance or Data.instance,
                    Holder = Data.Holder or Data.holder or Data.Instance or Data.instance,
                    OriginalSize = nil,
                    Visible = true,
                }

                if SearchItem.Holder then
                    SearchItem.OriginalSize = SearchItem.Holder.Size
                    SearchItem.FadeObjects = CacheObjects(SearchItem.Holder)
                end

                table.insert(Library.SearchItems, SearchItem)
                return SearchItem
            end

            function Window:RefreshSearch() -- fuck my ass
                local Query = Normalize(Window.SearchQuery)
            
                for Index, Item in Library.SearchItems do
                    if Item.Page ~= Window.Current then
                        continue
                    end
            
                    local Holder = Item.Holder

                    if not Holder then
                        continue
                    end
            
                    local Matched = Query == "" or Normalize(Item.Name):find(Query, 1, true) ~= nil
            
                    if Matched and not Item.Visible then
                        Item.Visible = true
                        Item.SearchToken = (Item.SearchToken or 0) + 1
            
                        Holder.Visible = true
                        Holder.Size = UDim2.new(Item.OriginalSize.X.Scale, Item.OriginalSize.X.Offset, 0, 0)
            
                        for _, FadeData in Item.FadeObjects do
                            local TweenData = {}
            
                            for _, Property in FadeData.Properties do
                                FadeData.Object[Property] = 1
                                TweenData[Property] = FadeData.Original[Property]
                            end
            
                            Library:Tween(TweenData, nil, FadeData.Object)
                        end
            
                        Library:Tween({Size = Item.OriginalSize}, nil, Holder)
                    elseif not Matched and Item.Visible then
                        Item.Visible = false
                        Item.SearchToken = (Item.SearchToken or 0) + 1
            
                        local Token = Item.SearchToken
            
                        for _, FadeData in Item.FadeObjects do
                            local TweenData = {}
            
                            for _, Property in FadeData.Properties do
                                TweenData[Property] = 1
                            end
            
                            Library:Tween(TweenData, nil, FadeData.Object)
                        end
            
                        Library:Tween({
                            Size = UDim2.new(Item.OriginalSize.X.Scale, Item.OriginalSize.X.Offset, 0, 0)
                        }, nil, Holder)
            
                        task.delay(Library.Animation.Time + 0.03, function()
                            if Item.SearchToken == Token and not Item.Visible then
                                Holder.Visible = false
                            end
                        end)
                    end
                end
            end

            Items["Input"]:Connect("Changed", function(Property)
                if Property == "Text" then
                    Window.SearchQuery = Items["Input"].Instance.Text
                    Window:RefreshSearch()
                end
            end)

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Debounce = true 

                Window.IsOpen = Bool
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

            local Settings = { 
                IsOpen = false,
                Items = { }
            } do 
                local SettingsItems = { }

                SettingsItems["SettingsWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1074, 0, 153),
                    Size = UDim2.new(0, 300, 0, 265),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create("UIStroke", {
                    Parent = SettingsItems["SettingsWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Transparency = 0.6,
                    LineJoinMode = Enum.LineJoinMode.Round,
                }):AddToTheme({Color = "Outline"})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = SettingsItems["SettingsWindow"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                SettingsItems["Content"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = SettingsItems["SettingsWindow"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Dark Icon"],
                    MidImage = "rbxassetid://81680855285439",
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -20, 1, -60),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 50),
                    BottomImage = "rbxassetid://81680855285439",
                    TopImage = "rbxassetid://81680855285439"
                }):AddToTheme({ScrollBarImageColor3 = 'Dark Icon'})
                
                SettingsItems["Pages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = SettingsItems["SettingsWindow"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 0, 30),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = SettingsItems["Pages"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Settings.Items = SettingsItems 

                local Debounce = false 

                local SettingWindow = SettingsItems["SettingsWindow"].Instance
                local SettingButton = Items["SettingsButton"].Instance

                local RenderStepped

                function Settings:SetOpen(Bool)
                    if Debounce then 
                        return 
                    end
    
                    Settings.IsOpen = Bool
    
                    Debounce = true 
                    
                    if Settings.IsOpen then 
                        SettingWindow.Position = UDim2.new(0, SettingButton.AbsolutePosition.X, 0, SettingButton.AbsolutePosition.Y + SettingButton.AbsoluteSize.Y + GuiInset)
    
                        SettingWindow.Parent = Library.Holder.Instance
                        SettingWindow.Visible = true

                        RenderStepped = RunService.RenderStepped:Connect(function()
                            SettingsItems["SettingsWindow"]:Tween({
                                Position = UDim2.new(0, SettingButton.AbsolutePosition.X, 0, SettingButton.AbsolutePosition.Y + SettingButton.AbsoluteSize.Y + 10 + GuiInset)
                            })
                        end)

                        SettingsItems["SettingsWindow"]:FadeDescendants(true, function()
                            Debounce = false
                        end)
    
                        Library.OpenFrames[Settings] = Settings 
                    else
                        SettingsItems["SettingsWindow"]:Tween({Position = UDim2.new(0, SettingButton.AbsolutePosition.X, 0, SettingButton.AbsolutePosition.Y + SettingButton.AbsoluteSize.Y - 10 + GuiInset)})
                        SettingsItems["SettingsWindow"]:FadeDescendants(false, function()
                            SettingWindow.Parent = Library.UnusedHolder.Instance
                            Debounce = false
                        end)

                        if Library.OpenFrames[Settings] then 
                            Library.OpenFrames[Settings] = nil
                        end

                        for Index, Value in Library.OpenFrames do
                            Value:SetOpen(false)
                        end

                        if RenderStepped then 
                            RenderStepped:Disconnect()
                            RenderStepped = nil
                        end
                    end
    
                    local Descendants = SettingWindow:GetDescendants()
                    table.insert(Descendants, SettingWindow)
    
                    for Index, Value in Descendants do 
                        if Value.ClassName:find("UI") then
                            continue
                        end
    
                        Value.ZIndex = Settings.IsOpen and 4 or 1
                    end
                end

                Items["SettingsButton"]:Connect("MouseButton1Down", function()
                    Settings:SetOpen(not Settings.IsOpen)
                end)

                local SettingsTabs = { }

                function Settings:AddTab(Name)
                    local NewTab = { 
                        Active = false,
                        Window = false,
                        IsSettings = nil,
                        Items = { }
                    }

                    NewTab.IsSettings = NewTab

                    NewTab.Items["Inactive"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = SettingsItems["Pages"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Name,
                        AutoButtonColor = false,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Element"]
                    }):AddToTheme({BackgroundColor3 = 'Element'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = NewTab.Items["Inactive"].Instance,
                        CornerRadius = UDim.new(0, 6)
                    })                    

                    NewTab.Items["Content"] = Library:Create("ScrollingFrame", {
                        Name = "\0",
                        Parent = SettingsItems["Content"].Instance,
                        BorderSizePixel = 0,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollBarImageColor3 = Library.Theme["Dark Icon"],
                        MidImage = "rbxassetid://81680855285439",
                        Visible = false,
                        ClipsDescendants = true,
                        ScrollBarThickness = 2,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BottomImage = "rbxassetid://81680855285439",
                        TopImage = "rbxassetid://81680855285439"
                    }):AddToTheme({ScrollBarImageColor3 = 'Dark Icon'})
                    
                    Library:Create("UIPadding", {
                        Name = "\0",
                        Parent = NewTab.Items["Content"].Instance,
                        PaddingRight = UDim.new(0, 12)
                    })
                    
                    Library:Create("UIListLayout", {
                        Name = "\0",
                        Parent = NewTab.Items["Content"].Instance,
                        Padding = UDim.new(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })                    

                    function NewTab:Turn(Bool)
                        NewTab.Active = Bool
                        NewTab.Items["Content"].Instance.Visible = Bool

                        if Bool then 
                            NewTab.Items["Inactive"]:Tween({BackgroundColor3 = Library.Theme["Accent"]})
                        else
                            NewTab.Items["Inactive"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                        end
                    end

                    NewTab.Items["Inactive"]:Connect("MouseButton1Down", function()
                        for Index, Value in SettingsTabs do 
                            Value:Turn(Value == NewTab)
                        end
                    end)

                    if #SettingsTabs == 0 then 
                        NewTab:Turn(true)
                    end

                    table.insert(SettingsTabs, NewTab)
                    return setmetatable(NewTab, Library) 
                end

                setmetatable(Settings, Library)
            end

            local ConfigsTab = Settings:AddTab("Configs")
            local ThemeTab = Settings:AddTab("Theme")
            local OtherTab = Settings:AddTab("Other")

            do -- Configs
                local ConfigName 
                local ConfigSelected 
                local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                local ConfigsDropdown = ConfigsTab:Dropdown({
                    Name = "Configs",
                    Flag = "Configs",
                    Items = { },
                    Parent = ConfigsTab.Items["Content"],
                    Multi = false,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsTab:Textbox({
                    Name = "Config name",
                    Flag = "ConfigName",
                    Placeholder = "Config name",
                    Callback = function(Value)
                        ConfigName = Value 
                    end
                })

                ConfigsTab:Button({
                    Name = "Create",
                    Callback = function()
                        if ConfigName then 
                            if ConfigName == "" then 
                                return
                            end
    
                            writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                            Library:GetConfigsList(ConfigsDropdown)
                            Library:Notification("Succesfully created config", 3, Color3.fromRGB(0, 255, 0))
                        end
                    end
                })

                ConfigsTab:Button({
                    Name = "Delete",
                    Callback = function()
                        if ConfigSelected then 
                            if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                delfile(ConfigsFolder .. ConfigSelected .. ".json")
                                Library:GetConfigsList(ConfigsDropdown)

                                Library:Notification("Succesfully deleted config", 3, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    end
                })

                ConfigsTab:Button({
                    Name = "Load",
                    Callback = function()
                        if ConfigSelected then 
                            if isfile(ConfigsFolder.. ConfigSelected .. ".json") then
                                local ConfigContent = readfile(ConfigsFolder.. ConfigSelected .. ".json")
                                local Success, Error = Library:LoadConfig(ConfigContent)

                                if Success then 
                                    Library:Notification("Succesfully loaded config", 3, Color3.fromRGB(0, 255, 0))
                                else
                                    Library:Notification("Failed to load config: \n"..Error, 3, Color3.fromRGB(255, 0, 0))
                                end
                            end
                        end
                    end
                })

                ConfigsTab:Button({
                    Name = "Save",
                    Callback = function()
                        if ConfigSelected then
                            if isfile(ConfigsFolder.. ConfigSelected .. ".json") then
                                local Success, Error = pcall(function()
                                    writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                                end)

                                if Success then 
                                    Library:Notification("Succesfully saved config", 3, Color3.fromRGB(0, 255, 0))
                                else
                                    Library:Notification("Failed to save config: \n"..Error, 3, Color3.fromRGB(255, 0, 0))
                                end
                            end
                        end
                    end
                })

                ConfigsTab:Button({
                    Name = "Refresh",
                    Callback = function()
                        Library:GetConfigsList(ConfigsDropdown)
                    end
                })

                Library:GetConfigsList(ConfigsDropdown)
            end

            do -- Theming
                for Index, Value in Library.Theme do 
                    ThemeTab:Label({Name = Index}):Colorpicker({
                        Flag = "Theme" .. Index,
                        Default = Value, 
                        Parent = ThemeTab.Items["Content"],
                        Callback = function(Value)
                        Library.Theme[Index] = Value
                        Library:ChangeTheme(Index, Value)
                    end
                    })
                end
            end

            do -- Other 
                OtherTab:Button({
                    Name = "Unload",
                    Callback = function()
                        Library:Unload()
                    end
                })
                
                OtherTab:Label({Name = "UI Bind"}):Keybind({Flag = "UIBind", Mode = "Toggle", Parent = OtherTab.Items["Content"], Default = Enum.KeyCode.RightShift, Callback = function(Value)
                    Library.MenuKeybind = Flags["UIBind"].Key
                end})

                OtherTab:Dropdown({
                    Name = "Style",
                    Items = {"Linear", "Quad", "Quart", "Back", "Bounce", "Circular", "Cubic", "Elastic", "Exponential", "Sine", "Quint"},
                    Default = "Cubic",
                    Parent = OtherTab.Items["Content"],
                    Callback = function(Value)
                        Library.Animation.Style = Value
                    end
                })

                OtherTab:Dropdown({
                    Name = "Direction",
                    Parent = OtherTab.Items["Content"],
                    Items = {"In", "Out", "InOut"},
                    Default = "Out",
                    Callback = function(Value)
                        Library.Animation.Direction = Value
                    end
                })

                OtherTab:Slider({
                    Name = "Time",
                    Min = 0,
                    Parent = OtherTab.Items["Content"],
                    Max = 1,
                    Default = 0.25,
                    Decimals = 0.01,
                    Suffix = "s",
                    Callback = function(Value)
                        Library.Animation.Time = Value
                    end
                })
            end

            Items["SettingsButton"]:OnHover(function()
                Items["SettingsButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["SettingsButton"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
            end)

            Items["OpenClose"]:Connect("MouseButton1Down", function()
                Window:SetOpen(not Window.IsOpen)
                Items["OpenAndClose"].Instance.Text = Window.IsOpen and "Close" or "Open"
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:Center()
            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Icon = Params.Icon or Params.icon or "rbxassetid://129245697782918",

                Window = Self,
                ColumnsData = { },
                Items = { },
                Active = false,
                Debounce = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Window.Items["Pages"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 41, 0, 45),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    CornerRadius = UDim.new(0, 14)
                })
                
                Items["Inline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inactive"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    CornerRadius = UDim.new(0, 14)
                })
                
                Items["Hide"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    Visible = true,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hide"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, -1),
                    Size = UDim2.new(0, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Items["Bottom"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hide"].Instance,
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.new(0.5, 0, 1, 1),
                    Size = UDim2.new(0, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Items["Right"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hide"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 1, 0.5, 0),
                    Size = UDim2.new(0, 1, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Items["Left"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hide"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 1, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Tab"]
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ImageColor3 = Library.Theme["Dark Icon"],
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 22, 0, 22),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Dark Icon'})      
                
                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 50),
                    Visible = false,
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
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
                    PaddingTop = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12),
                    PaddingBottom = UDim.new(0, 12)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
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
                    PaddingTop = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingBottom = UDim.new(0, 12)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            Library.SearchItems[Page] = { }

            Items["Inactive"]:OnHover(function()
                if Page.Active then 
                    return 
                end

                Items["Inline"]:Tween({BackgroundTransparency = 0})
            end, function()
                if Page.Active then 
                    return 
                end

                Items["Inline"]:Tween({BackgroundTransparency = 1})
            end)

            function Page:TweenSides(Bool)
                if Bool then 
                    Items["Top"]:Tween({Size = UDim2.new(0, 22, 0, 1)})
                    Items["Bottom"]:Tween({Size = UDim2.new(0, 22, 0, 1)})

                    -- 

                    Items["Left"]:Tween({Size = UDim2.new(0, 1, 0, 22)})
                    Items["Right"]:Tween({Size = UDim2.new(0, 1, 0, 22)})
                else
                    Items["Top"]:Tween({Size = UDim2.new(0, 0, 0, 1)})
                    Items["Bottom"]:Tween({Size = UDim2.new(0, 0, 0, 1)})

                    -- 

                    Items["Left"]:Tween({Size = UDim2.new(0, 1, 0, 0)})
                    Items["Right"]:Tween({Size = UDim2.new(0, 1, 0, 0)})
                end
            end

            function Page:Turn()
                local Old = Page.Window.Current 

                if Old == Page then 
                    return 
                end

                if Page.Debounce then 
                    return
                end

                if Old and Old.Debounce then 
                    return 
                end

                Page.Debounce = true 
                
                if Old then 
                    Old:TweenSides(false)
                    Old.Items["Inactive"]:Tween({BackgroundTransparency = 1})
                    Old.Items["Inline"]:Tween({BackgroundTransparency = 1})
                    Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Dark Icon"})
                    Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Dark Icon"]})
                    Old.Items["Page"]:Tween({Position = UDim2.new(0, 0, 0, 50)})

                    Old.Items["Page"]:FadeDescendants(false, function()
                        Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end)

                    Old.Active = false
                end

                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Page"].Instance.Visible = true
                Items["Page"]:FadeDescendants(true, function()
                    Page.Debounce = false
                end)

                Page:TweenSides(true)
                Items["Page"]:Tween({Position = UDim2.new(0, 0, 0, 0)})
                Items["Inactive"]:Tween({BackgroundTransparency = 0})
                Items["Inline"]:Tween({BackgroundTransparency = 0})
                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                Items["Icon"]:Tween({ImageColor3 = Library.Theme["Accent"]})

                Page.Active = true
                Page.Window.Current = Page
            end

            Items["Inline"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or { } 

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Side = Params.Side or Params.side or 1,

                Window = Self.Window,
                Page = Self,
                Items = { },
            }

            local Items = { } do 
                Items["Section"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize + 2,
                    Parent = Items["Section"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Section.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, 30),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    CornerRadius = UDim.new(0, 12)
                })
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 12),
                    Size = UDim2.new(1, -24, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    PaddingBottom = UDim.new(0, 12)
                })

                Section.Items = Items
            end 

            return setmetatable(Section, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = { } do    
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 31),
                    BorderSizePixel = 0
                })

                Items["Toggle"]:Tooltip(Toggle.Tooltip)
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Library.Theme["Dark Text"],
                    Text = Toggle.Name,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 2),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Dark Text'})
                
                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 30, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Items["Circle"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    Position = UDim2.new(0, 3, 0, 3),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Toggle"]
                }):AddToTheme({BackgroundColor3 = 'Toggle'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Circle"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                }):AddToTheme({BackgroundColor3 = 'Liner'})        
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -42, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 8)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    PaddingRight = UDim.new(0, -1)
                })
            
                Toggle.Items = Items
            end

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
            end)

            function Toggle:Set(Bool)
                Toggle.Value = Bool 

                if Bool then 
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})

                    Items["Indicator"]:Tween({BackgroundTransparency = 0.8, BackgroundColor3 = Library.Theme.Accent})
                    Items["Text"]:Tween({TextColor3 = Library.Theme.Text})  
                    
                    --local A = Items["Circle"]:Tween({Size = UDim2.new(0, 20, 0, 14)}, TweenInfo.new(Library.Animation.Time / 4.5, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction]))

                    --A.Completed:Wait()

                    Items["Circle"]:Tween({
                        AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.new(1, -3, 0, 3),
                        BackgroundColor3 = Library.Theme.Accent,
                        --Size = UDim2.new(0, 14, 0, 14)
                    })
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = "Toggle"})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Dark Text"})

                    Items["Indicator"]:Tween({BackgroundTransparency = 0, BackgroundColor3 = Library.Theme.Element})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Dark Text"]})  
                    
                    --local A = Items["Circle"]:Tween({Size = UDim2.new(0, 20, 0, 14)}, TweenInfo.new(Library.Animation.Time / 4.5, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction]))

                    --A.Completed:Wait()

                    Items["Circle"]:Tween({
                        AnchorPoint = Vector2.new(0, 0),
                        Position = UDim2.new(0, 3, 0, 3),
                        BackgroundColor3 = Library.Theme.Toggle,
                        --Size = UDim2.new(0, 14, 0, 14)
                    })
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

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Toggle = Toggle,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            function Toggle:Settings(Size)
                local Settings = { 
                    IsOpen = false,
                    Window = false,
                    Items = { },
                    IsSettings = nil
                }

                Settings.IsSettings = Settings

                local SettingsItems = { } do
                    SettingsItems["SettingsButton"] = Library:Create("ImageButton", {
                        Name = "\0",
                        Parent = Items["SubElements"].Instance,
                        AutoButtonColor = false,
                        Image = "rbxassetid://128889160605702",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 20, 0, 20),
                        BorderSizePixel = 0
                    })                    

                    SettingsItems["SettingsWindow"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Library.UnusedHolder.Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        Visible= false,
                        AutoButtonColor = false,
                        Position = UDim2.new(0, 1074, 0, 153),
                        Size = UDim2.new(0, 268, 0, Size),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }):AddToTheme({BackgroundColor3 = 'Background'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = SettingsItems["SettingsWindow"].Instance,
                        CornerRadius = UDim.new(0, 4)
                    })
                    
                    SettingsItems["Content"] = Library:Create("ScrollingFrame", {
                        Name = "\0",
                        Parent = SettingsItems["SettingsWindow"].Instance,
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BorderSizePixel = 0,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollBarImageColor3 = Library.Theme["Dark Icon"],
                        MidImage = "rbxassetid://81680855285439",
                        ScrollBarThickness = 2,
                        Size = UDim2.new(1, -20, 1, -20),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 10),
                        BottomImage = "rbxassetid://81680855285439",
                        TopImage = "rbxassetid://81680855285439"
                    }):AddToTheme({ScrollBarImageColor3 = 'Dark Icon'})
                    
                    Library:Create("UIListLayout", {
                        Name = "\0",
                        Parent = SettingsItems["Content"].Instance,
                        Padding = UDim.new(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                    
                    Library:Create("UIPadding", {
                        Name = "\0",
                        Parent = SettingsItems["Content"].Instance,
                        PaddingRight = UDim.new(0, 12)
                    })              
                    
                    Settings.Items = SettingsItems
                end

                local Debounce = false 

                local SettingWindow = SettingsItems["SettingsWindow"].Instance
                local SettingButton = SettingsItems["SettingsButton"].Instance
                local RenderStepped

                function Settings:SetOpen(Bool)
                    if Debounce then 
                        return 
                    end
    
                    Settings.IsOpen = Bool
    
                    Debounce = true 
                    
                    if Settings.IsOpen then 
                        SettingWindow.Position = UDim2.new(0, SettingButton.AbsolutePosition.X, 0, SettingButton.AbsolutePosition.Y + SettingButton.AbsoluteSize.Y + GuiInset)
    
                        SettingWindow.Parent = Library.Holder.Instance
                        SettingWindow.Visible = true

                        RenderStepped = RunService.RenderStepped:Connect(function()
                            SettingsItems["SettingsWindow"]:Tween({Position = UDim2.new(0, SettingButton.AbsolutePosition.X, 0, SettingButton.AbsolutePosition.Y + SettingButton.AbsoluteSize.Y + 10 + GuiInset)})
                        end)

                        SettingsItems["SettingsWindow"]:FadeDescendants(true, function()
                            Debounce = false
                        end)
    
                        Library.OpenFrames[Settings] = Settings 
                    else
                        SettingsItems["SettingsWindow"]:Tween({Position = UDim2.new(0, SettingButton.AbsolutePosition.X, 0, SettingButton.AbsolutePosition.Y + SettingButton.AbsoluteSize.Y - 10 + GuiInset)})
                        SettingsItems["SettingsWindow"]:FadeDescendants(false, function()
                            SettingWindow.Parent = Library.UnusedHolder.Instance
                            Debounce = false
                        end)

                        if Library.OpenFrames[Settings] then 
                            Library.OpenFrames[Settings] = nil
                        end

                        for Index, Value in Library.OpenFrames do
                            Value:SetOpen(false)
                        end

                        if RenderStepped then 
                            RenderStepped:Disconnect()
                            RenderStepped = nil
                        end
                    end
    
                    local Descendants = SettingWindow:GetDescendants()
                    table.insert(Descendants, SettingWindow)
    
                    for Index, Value in Descendants do 
                        if Value.ClassName:find("UI") then
                            continue
                        end
    
                        Value.ZIndex = Settings.IsOpen and 4 or 1
                    end
                end

                SettingsItems["SettingsButton"]:Connect("MouseButton1Down", function()
                    Settings:SetOpen(not Settings.IsOpen)
                end)

                return setmetatable(Settings, Library)
            end

            if Toggle.Window then
                Toggle.Window:RegisterSearchItem({
                    Name = Toggle.Name,
                    Page = Toggle.Page,
                    Holder = Items["Toggle"].Instance
                })
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
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Button.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Button"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 41),
                    BorderSizePixel = 0
                })

                Items["Button"]:Tooltip(Button.Tooltip)
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                }):AddToTheme({BackgroundColor3 = 'Liner'})
                
                Items["RealButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealButton"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Button.Name,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})                

                Button.Items = Items
            end

            Items["RealButton"]:OnHover(function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
            end)

            function Button:Press()
                Items["RealButton"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme.Accent})
                task.wait(0.1)
                Items["RealButton"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme.Element})
                
                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            if Button.Window then
                Button.Window:RegisterSearchItem({
                    Name = Button.Name,
                    Page = Button.Page,
                    Holder = Items["Button"].Instance
                })
            end

            Items["RealButton"]:Connect("MouseButton1Down", function()
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
                Tooltip = Params.Tooltip or Params.tooltip or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 39),
                    BorderSizePixel = 0
                })

                Items["Slider"]:Tooltip(Slider.Tooltip)
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Slider"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                }):AddToTheme({BackgroundColor3 = 'Liner'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 7),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, -5),
                    Size = UDim2.new(0, 120, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealSlider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "65%",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -15, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Items["Dragger"] = Library:Create("TextButton", {
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Items["Accent"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 8, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Dragger"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Dragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Library.Theme["Inline"],
                    Thickness = 2
                }):AddToTheme({Color = 'Inline'})                

                Slider.Items = Items 
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
            end)

            function Slider:Set(Value)
                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                Items["Accent"]:Tween({Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
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

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Items["Dragger"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
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

            if Slider.Window then
                Slider.Window:RegisterSearchItem({
                    Name = Slider.Name,
                    Page = Slider.Page,
                    Holder = Items["Slider"].Instance
                })
            end

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.RangeSlider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Default = Params.Default or Params.default or {0, 100},
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Gap = Params.Gap or Params.gap or 16,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 0,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Sliding = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 39),
                    BorderSizePixel = 0
                })
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Slider"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(39, 39, 46)
                }):AddToTheme({BackgroundColor3 = 'Liner'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 7),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, -5),
                    Size = UDim2.new(0, 120, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(38, 38, 50)
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealSlider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "65 - 100",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -15, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(78, 95, 255)
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Items["Min"] = Library:Create("TextButton", {
                    Name = "\0",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Items["Accent"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Min"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Min"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromRGB(29, 30, 36),
                    Thickness = 2
                }):AddToTheme({Color = "Inline"})        
                
                Items["Max"] = Library:Create("TextButton", {
                    Name = "\0",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Items["Accent"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Max"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Max"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromRGB(29, 30, 36),
                    Thickness = 2
                }):AddToTheme({Color = "Inline"})                          

                Slider.Items = Items 
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
            end)

            function Slider:Set(MinValue, MaxValue)
                if typeof(MinValue) == "table" then
                    MinValue, MaxValue = MinValue[1], MinValue[2]
                end
            
                MinValue = Library:Round(math.clamp(MinValue, Slider.Min, Slider.Max), Slider.Decimals)
                MaxValue = Library:Round(math.clamp(MaxValue, Slider.Min, Slider.Max), Slider.Decimals)
            
                if MinValue > MaxValue then
                    MinValue, MaxValue = MaxValue, MinValue
                end
            
                MinValue = Library:Round(math.clamp(MinValue, Slider.Min, Slider.Max), Slider.Decimals)
                MaxValue = Library:Round(math.clamp(MaxValue, Slider.Min, Slider.Max), Slider.Decimals)
            
                Slider.Value = { MinValue, MaxValue }
                Flags[Slider.Flag] = Slider.Value
            
                local MinPCT = (MinValue - Slider.Min) / (Slider.Max - Slider.Min)
                local MaxPCT = (MaxValue - Slider.Min) / (Slider.Max - Slider.Min)
            
                Items["Accent"]:Tween({
                    Position = UDim2.fromScale(MinPCT, 0),
                    Size = UDim2.fromScale(MaxPCT - MinPCT, 1)
                }, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            
                Items["Min"].Instance.Position = UDim2.fromScale(0, 0.5)
                Items["Max"].Instance.Position = UDim2.fromScale(1, 0.5)

                Items["Value"].Instance.Text = string.format("%s - %s%s", MinValue, MaxValue, Slider.Suffix)
            
                if Slider.Callback then
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            function Slider:StartDrag(Handle)
                Slider.SlidingHandle = Handle 
            end

            function Slider:StopDrag()
                Slider.SlidingHandle = nil
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["Min"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider:StartDrag(Items["Min"])
                end
            end)

            Items["Max"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider:StartDrag(Items["Max"])
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.SlidingHandle then
                        Slider:StopDrag()
                    end
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Slider.SlidingHandle then
                    local MouseX = Input.Position.X
                    local BarX = Items["RealSlider"].Instance.AbsolutePosition.X
                    local BarW = Items["RealSlider"].Instance.AbsoluteSize.X
            
                    local Scale = math.clamp((MouseX - BarX) / BarW, 0, 1)
                    local Value = Library:Round(
                        (Scale * (Slider.Max - Slider.Min)) + Slider.Min,
                        Slider.Decimals
                    )

                    local HandleGap = Slider.Gap / BarW
                    
                    if Slider.SlidingHandle == Items["Min"] then
                        local MaxPCT = (Slider.Value[2] - Slider.Min) / (Slider.Max - Slider.Min)
                        Scale = math.clamp(Scale, 0, MaxPCT - HandleGap)
                        Slider:Set((Scale * (Slider.Max - Slider.Min)) + Slider.Min, Slider.Value[2])
                    else
                        local MinPCT = (Slider.Value[1] - Slider.Min) / (Slider.Max - Slider.Min)
                        Scale = math.clamp(Scale, MinPCT + HandleGap, 1)
                        Slider:Set(Slider.Value[1], (Scale * (Slider.Max - Slider.Min)) + Slider.Min)
                    end
                end
            end) 

            Slider:Set(Slider.Default[1], Slider.Default[2])

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
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,
                Tooltip = Params.Tooltip or Params.tooltip or "",

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

            local Items = { } do 
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 37),
                    BorderSizePixel = 0
                })

                Items["Dropdown"]:Tooltip(Dropdown.Tooltip)
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Dropdown"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                }):AddToTheme({BackgroundColor3 = 'Liner'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 7),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 120, 0, 26),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "...",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Icon_"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://127296511745226",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                })                

                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 249, 0, 50),
                    BackgroundTransparency = 0.10000000149011612,
                    Position = UDim2.new(0, 15, 0, 164),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12)
                })

                Dropdown.Items = Items 
            end

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
            end)

            Dropdown.Holder = Items["OptionHolder"]

            function Dropdown:Set(Value)
                if Dropdown.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
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
                    Parent = Items["OptionHolder"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                
                local OptionText = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = OptionButton.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Value,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Dark Text'})
                
                local OptionCheck = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = OptionButton.Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://114461119629011",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(-1, 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                })                

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    Text = OptionText,
                    Check = OptionCheck,
                    IsSelected = false
                }
                
                OptionData.Button:OnHover(function()
                    if OptionData.IsSelected then return end 
                    OptionData.Text:Tween({TextColor3 = Library.Theme["Text"]})
                end, function()
                    if OptionData.IsSelected then return end 
                    OptionData.Text:Tween({TextColor3 = Library.Theme["Dark Text"]})
                end)
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionData.Check:Tween({Position = UDim2.new(1, 0, 0.5, 0)})
                        OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                        OptionData.Text:Tween({TextColor3 = Library.Theme.Text})
                    else
                        OptionData.Check:Tween({Position = UDim2.new(1, 25, 0.5, 0)})
                        OptionData.Text:ChangeItemTheme({TextColor3 = "Dark Text"})
                        OptionData.Text:Tween({TextColor3 = Library.Theme["Dark Text"]})
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
                        if Dropdown.Value == OptionData.Name then
                            return
                        end
                    
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
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            local IsSettings = Dropdown.Section and Dropdown.Section.IsSettings

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Dropdown.IsOpen = Bool

                Debounce = true 
                
                if Dropdown.IsOpen then 
                    Items["Icon_"]:Tween({Rotation = -90})
                    OptionHolder.Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + GuiInset)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X, 0, Dropdown.MaxSize)
                    
                    OptionHolder.Parent = Library.Holder.Instance
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings and not Params.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    Items["Icon_"]:Tween({Rotation = 0})
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["OptionHolder"]:FadeDescendants(false, function()
                        OptionHolder.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder + 3 or 1
                    end
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Dropdown.IsOpen and not Items["OptionHolder"]:IsMouseOverFrame() then
                        Dropdown:SetOpen(false)
                    end
                end
            end)

            if Dropdown.Window then
                Dropdown.Window:RegisterSearchItem({
                    Name = Dropdown.Name,
                    Page = Dropdown.Page,
                    Holder = Items["Dropdown"].Instance
                })
            end

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
                Tooltip = Params.Tooltip or Params.tooltip or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Label.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 31),
                    BorderSizePixel = 0
                })

                Items["Label"]:Tooltip(Label.Tooltip)
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                }):AddToTheme({BackgroundColor3 = 'Liner'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 2),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
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
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    PaddingRight = UDim.new(0, -1)
                })                

                Label.Items = Items 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool 
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
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

            if Label.Window then
                Label.Window:RegisterSearchItem({
                    Name = Label.Name,
                    Page = Label.Page,
                    Holder = Items["Label"].Instance
                })
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
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
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Numeric = Params.Numeric or Params.numeric or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Textbox.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 41),
                    BorderSizePixel = 0
                })

                Items["Textbox"]:Tooltip(Textbox.Tooltip)
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                }):AddToTheme({BackgroundColor3 = 'Liner'})
                
                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    Size = UDim2.new(1, 0, 0, 30),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Dark Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -20, 0, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    CursorPosition = -1,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Dark Text'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Input"].Instance,
                    PaddingTop = UDim.new(0, 1)
                })                

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

            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Window then
                Textbox.Window:RegisterSearchItem({
                    Name = Textbox.Name,
                    Page = Textbox.Page,
                    Holder = Items["Textbox"].Instance
                })
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
            
            return setmetatable(Textbox, Library)
        end
    end
end
        
getgenv().Library = Library
return Library
