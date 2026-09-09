-- Made by samet
-- Example at bottom

if getgenv().Library and getgenv().Library.Exit then
    getgenv().Library:Exit()
end

-- Bad executor support (atleast by a bit)
cloneref = cloneref or function(Object) return Object end 

--#region Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = cloneref(game:GetService("CoreGui"))
--#endregion

local IconsURL = "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
local Icons

pcall(function()
    local src = game.HttpGetAsync and game:HttpGetAsync(IconsURL) or HttpService:GetAsync(IconsURL)
    Icons = loadstring(src)()
end)

if Icons then
    Icons.SetIconsType("lucide")
end

local function CreateIcon(iconName, size, colorOrTheme)
    -- Check if it's an asset id (starts with rbxassetid or is a number)
    if type(iconName) == "string" and (iconName:match("^rbxassetid://") or iconName:match("^%d+$")) then
        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.Size = size or UDim2.fromOffset(18, 18)
        if type(iconName) == "string" and iconName:match("^%d+$") then
            img.Image = "rbxassetid://" .. iconName
        else
            img.Image = iconName
        end
        if typeof(colorOrTheme) == "Color3" then
            img.ImageColor3 = colorOrTheme
        end
        return img
    end
    
    -- Try Lucide icons (pass iconName directly - Icons library handles "lucide:" prefix)
    if Icons then
        local colors = {}
        if typeof(colorOrTheme) == "string" then
            colors = { colorOrTheme }
        elseif typeof(colorOrTheme) == "Color3" then
            colors = { colorOrTheme }
        else
            colors = { Color3.fromRGB(230, 230, 235) }
        end

        local ok, iconObj = pcall(function()
            return Icons.Image({
                Icon = iconName,
                Size = size or UDim2.fromOffset(18, 18),
                Colors = colors,
            })
        end)

        if ok and iconObj and iconObj.IconFrame then
            local frame = iconObj.IconFrame
            frame.BackgroundTransparency = 1
            return frame
        end
    end

    -- Fallback
    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.Size = size or UDim2.fromOffset(18, 18)
    img.ImageColor3 = (typeof(colorOrTheme) == "Color3" and colorOrTheme) or Color3.fromRGB(230, 230, 235)
    img.Image = "rbxassetid://0"
    return img
end

local function ResolveIconImage(instance)
    if not instance then
        return nil
    end
    if instance:IsA("ImageLabel") then
        return instance
    end
    return instance:FindFirstChildWhichIsA("ImageLabel", true)
end

-- Helper to check if an icon string is a lucide icon
local function IsLucideIcon(iconName)
    return type(iconName) == "string" and iconName:match("^lucide:")
end

-- Helper to check if an icon string is an asset id
local function IsAssetId(iconName)
    return type(iconName) == "string" and (iconName:match("^rbxassetid://") or iconName:match("^%d+$"))
end

-- Get the proper image string for asset ids
local function GetAssetImage(iconName)
    if type(iconName) == "string" and iconName:match("^%d+$") then
        return "rbxassetid://" .. iconName
    end
    return iconName
end

-- Apply icon to an ImageLabel - handles both asset ids and lucide icons
-- For lucide icons, creates the icon and parents it to a container frame
local function ApplyIconToContainer(container, iconName, size, colorOrTheme)
    if not iconName then return nil end
    
    -- If it's an asset ID, we can set it directly on an ImageLabel
    if IsAssetId(iconName) then
        local img = Instance.new("ImageLabel")
        img.Name = "IconImage"
        img.BackgroundTransparency = 1
        img.Size = size or UDim2.fromScale(1, 1)
        img.Position = UDim2.fromScale(0.5, 0.5)
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Image = GetAssetImage(iconName)
        img.BorderSizePixel = 0
        if typeof(colorOrTheme) == "Color3" then
            img.ImageColor3 = colorOrTheme
        end
        img.Parent = container
        return img
    end
    
    -- If it's a lucide icon, use the Icons library
    if IsLucideIcon(iconName) and Icons then
        local colors = {}
        if typeof(colorOrTheme) == "string" then
            colors = { colorOrTheme }
        elseif typeof(colorOrTheme) == "Color3" then
            colors = { colorOrTheme }
        else
            colors = { Color3.fromRGB(230, 230, 235) }
        end
        
        local ok, iconObj = pcall(function()
            return Icons.Image({
                Icon = iconName,
                Size = size or UDim2.fromScale(1, 1),
                Colors = colors,
            })
        end)
        
        if ok and iconObj and iconObj.IconFrame then
            local frame = iconObj.IconFrame
            frame.Name = "IconImage"
            frame.BackgroundTransparency = 1
            frame.Position = UDim2.fromScale(0.5, 0.5)
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Parent = container
            return frame
        end
    end
    
    -- Fallback - try to use Icons library without lucide: prefix
    if Icons then
        local colors = {}
        if typeof(colorOrTheme) == "Color3" then
            colors = { colorOrTheme }
        else
            colors = { Color3.fromRGB(230, 230, 235) }
        end
        
        local ok, iconObj = pcall(function()
            return Icons.Image({
                Icon = iconName,
                Size = size or UDim2.fromScale(1, 1),
                Colors = colors,
            })
        end)
        
        if ok and iconObj and iconObj.IconFrame then
            local frame = iconObj.IconFrame
            frame.Name = "IconImage"
            frame.BackgroundTransparency = 1
            frame.Position = UDim2.fromScale(0.5, 0.5)
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Parent = container
            return frame
        end
    end
    
    return nil
end

gethui = gethui or function() return CoreGui end

--#region Variables 
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = cloneref(LocalPlayer:GetMouse())

local IsMobile = UserInputService.TouchEnabled or false
--#endregion

local Library = { 
    Flags = { },
    MenuKeybind = tostring(Enum.KeyCode.RightControl),

    Directory = "AtherHub",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs"
    },

    FontSize = 14,

    Animation = {
        Time = 0.3,
        Style = "Cubic",
        Direction = "Out"
    },

    Theme = nil,

    AutoSave = true,

    -- Ignore below
    Threads = { },
    Connections = { },
    Notifications = { },
    SetFlags = { },

    OpenFrames = { },

    ThemingStuff = { },
    ThemeMap = { },

    Holder = nil,
    UnusedHolder = nil,

    Font = nil
} do 
    Library.__index = Library

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

    local Flags = Library.Flags 
    local SetFlags = Library.SetFlags

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
            ["Background"] = Color3.fromRGB(18, 18, 20),
            ["Inline"] = Color3.fromRGB(15, 15, 16),
            ["Accent Start"] = Color3.fromRGB(175, 102, 126),
            ["Accent End"] = Color3.fromRGB(114, 75, 135),
            ["Text"] = Color3.fromRGB(220, 229, 247),
            ["Text 2"] = Color3.fromRGB(145, 151, 163),
            ["Element"] = Color3.fromRGB(24, 24, 27),
            ["Hovered Element"] = Color3.fromRGB(32, 32, 36),
            ["Topbar"] = Color3.fromRGB(28, 28, 29)
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

        Library.Font = CustomFont:New("InterSemiBold", 400, "Regular", {
            Id = "InterSemiBold",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"
        })
    end

    Library.Exit = function(Self)
        for _, Connection in Library.Connections do 
            Connection.Connection:Disconnect()
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
        local Connection = {
            Signal = Signal,
            Callback = Callback,
            Connection = nil
        }

        Library:Thread(function()
            if Self.Instance then
                if Self.Instance[Signal] then
                if IsMobile then 
                    if Signal == "MouseButton1Down" or Signal == "MouseButton1Click" then
                        local lastFire = 0
                        local function safeCallback(...)
                            local now = tick()
                            if now - lastFire < 0.15 then return end
                            lastFire = now
                            Callback(...)
                        end

                        -- Connect native mouse event (works on Delta Mobile and most executors)
                        local nativeConn = Self.Instance[Signal]:Connect(safeCallback)

                        -- Also connect InputBegan as fallback (for standard Roblox mobile)
                        -- Check both Touch AND MouseButton1 since executors vary
                        local touchConn = Self.Instance.InputBegan:Connect(function(Input)
                            if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                safeCallback()
                            end
                        end)

                        -- Wrap both connections for proper cleanup
                        Connection.Connection = {
                            Disconnect = function(self)
                                pcall(function() nativeConn:Disconnect() end)
                                pcall(function() touchConn:Disconnect() end)
                            end
                        }

                        return -- return so it doesnt proceed further
                    end 
                end

                    Connection.Connection = Self.Instance[Signal]:Connect(Callback)
                else
                    Connection.Connection = Signal:Connect(Callback)
                end
            else
                Connection.Connection = Signal:Connect(Callback)
            end
        end)

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
    
            -- Preserve the original scale values so elements anchored to bottom/right stay relative
            Self:Tween({Position = UDim2.new(StartPosition.X.Scale, NewX, StartPosition.Y.Scale, NewY)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
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

        -- Mobile fallback: for executors where GuiObject.InputBegan doesn't fire for touch
        -- Use MouseButton1Down on GuiButton instances + global InputEnded to manage drag state
        if IsMobile then
            if Gui:IsA("GuiButton") then
                Gui.MouseButton1Down:Connect(function(x, y)
                    if Dragging then return end
                    Dragging = true
                    DragStart = Vector3.new(x, y, 0)
                    StartPosition = Gui.Position
                end)
            end

            Library:Connect(UserInputService.InputEnded, function(Input)
                if (Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1) then
                    if Dragging then
                        Dragging = false
                        if InputChanged then
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end
                end
            end)
        end
    
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
        local ResizeHandler = { CanResize = true }
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
            })  Button:AddToTheme({BackgroundColor3 = "Accent End"})

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
            if not ResizeHandler.CanResize then 
                return
            end

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
            if not ResizeHandler.CanResize then 
                return
            end

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

            -- Mobile fallback: for executors where GuiObject.InputBegan doesn't fire for touch
            if IsMobile then
                Value.Button.Instance.MouseButton1Down:Connect(function()
                    BeginResizing(Value.Side)
                end)
            end
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

        return ResizeHandler
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

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        DisplayOrder = 999999
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        DisplayOrder = 999999
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
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 24, 0, 18),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(183, 242, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })                

                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 13, 0, 113),
                    Size = UDim2.new(0, 215, 0, 215),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                }):AddToTheme({BackgroundColor3 = "Background"})
                
                Library:Create("UICorner", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0"
                })
                
                Items["Palette"] = Library:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 1, -100),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(183, 242, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0"
                })
                
                Items["Saturation"] = Library:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0",
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0"
                })
                
                Items["Value"] = Library:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 1, 1, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Value"].Instance,
                    Name = "\0"
                })
                
                Items["PaletteDragger"] = Library:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 15),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 10, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Thickness = 1.600000023841858,
                    Color = Color3.fromRGB(255, 255, 255)
                })
                
                Items["Hue"] = Library:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -55),
                    Size = UDim2.new(1, -20, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["HueInline"] = Library:Create("TextButton", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["HueInline"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["HueInline"].Instance,
                    Name = "\0",
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
                    Parent = Items["HueInline"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 5, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Alpha"] = Library:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -20),
                    Size = UDim2.new(1, -20, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(183, 242, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["AlphaDragger"] = Library:Create("Frame", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 5, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["AlphaDragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Checkers"] = Library:Create("ImageLabel", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Tile,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    TileSize = UDim2.new(0, 6, 0, 6),
                    Image = "http://www.roblox.com/asset/?id=18274452449",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Checkers"].Instance,
                    Name = "\0",
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.37, 0.5),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Checkers"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 6)
                })                

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
    
                if not IsFromAlpha then 
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false 
            local RenderStepped 

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 
                
                if Colorpicker.IsOpen then 
                    Items["ColorpickerWindow"].Instance.Position = UDim2.new(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y)

                    Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 10)})
                    
                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Debounce = false 

                        RenderStepped = RunService.RenderStepped:Connect(function()
                            Items["ColorpickerWindow"].Instance.Position = UDim2.new(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 10)
                        end)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Colorpicker then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y - 10)})
                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        Items["ColorpickerWindow"].Instance.Parent = Library.UnusedHolder.Instance
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
    
                Items["HueDragger"]:Tween({Position = UDim2.new(SlideX, 0, 0, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
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
    
                local SlideX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.98)
    
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
    
                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.985)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.985)
    
                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 0.99)
                    
                local HuePositionX = math.clamp(Colorpicker.Hue, 0, 0.98)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["HueDragger"]:Tween({Position = UDim2.new(HuePositionX, 0, 0, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
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
    
            Items["HueInline"]:Connect("InputBegan", function(Input)
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

            -- Mobile fallback: for executors where GuiObject.InputBegan doesn't fire for touch
            if IsMobile then
                Items["Palette"].Instance.MouseButton1Down:Connect(function(x, y)
                    if SlidingPalette then return end
                    SlidingPalette = true
                    Colorpicker:SlidePalette({Position = Vector3.new(x, y, 0)})
                end)

                Items["HueInline"].Instance.MouseButton1Down:Connect(function(x, y)
                    if SlidingHue then return end
                    SlidingHue = true
                    Colorpicker:SlideHue({Position = Vector3.new(x, y, 0)})
                end)

                Items["Alpha"].Instance.MouseButton1Down:Connect(function(x, y)
                    if SlidingAlpha then return end
                    SlidingAlpha = true
                    Colorpicker:SlideAlpha({Position = Vector3.new(x, y, 0)})
                end)

                Library:Connect(UserInputService.InputEnded, function(Input)
                    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if SlidingPalette then
                            SlidingPalette = false
                            if PaletteChanged then PaletteChanged:Disconnect() PaletteChanged = nil end
                        end
                        if SlidingHue then
                            SlidingHue = false
                            if HueChanged then HueChanged:Disconnect() HueChanged = nil end
                        end
                        if SlidingAlpha then
                            SlidingAlpha = false
                            if AlphaChanged then AlphaChanged:Disconnect() AlphaChanged = nil end
                        end
                    end
                end)
            end
    
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

            local Items = { } do
                Items["KeyButton"] = Library:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "BackSpace",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                }):AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element"})

                Items["KeyButton"]:OnHover(function()
                    Items["KeyButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    Items["KeyButton"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)
                
                Library:Create("UICorner", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Library:Create("UIPadding", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    PaddingBottom = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })                

                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 9, 0, 10),
                    Size = UDim2.new(0, 241, 0, 71),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0"
                })                
                
                Keybind.Items = Items
            end

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
                end
            })

            ModeDropdown.Items.Dropdown.Instance.Position = UDim2.new(0, 10, 0, 10)
            ModeDropdown.Items.Dropdown.Instance.Size = UDim2.new(1, -20, 1, -20)

            local Debounce = false
            local RenderStepped  

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true 
                
                if Keybind.IsOpen then 
                    Items["KeybindWindow"].Instance.Position = UDim2.new(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y)

                    Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 10)})
                    
                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false 

                        RenderStepped = RunService.RenderStepped:Connect(function()
                            Items["KeybindWindow"].Instance.Position = UDim2.new(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 10)
                        end)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Keybind then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y - 10)})
                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
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
    
                    Library.Flags[Keybind.Flag] = {
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
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                Keybind.Picking = false
            end
    
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                if Keybind.Disabled then 
                    return 
                end

                Keybind.Picking = true 
    
                Items["KeyButton"].Instance.Text = "press a key"
    
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

        Library.CheckForAutoLoad = function()
            if not isfile(Library.Directory .. "/autoload.json") then
                return
            end

            local ConfigContent = readfile(Library.Directory .. "/autoload.json")

            if not ConfigContent or ConfigContent == "" then 
                return 
            end
    
            Library:LoadConfig(ConfigContent)
        end

        Library.Window = function(Self, Params)
            Params = Params or { }

            if Params.Folder or Params.folder then
                local OldDirectory = Library.Directory
                Library.Directory ..= Params.Folder or Params.folder .. "/"

                -- Ensure parent directory exists
                if not isfolder(OldDirectory) then
                    makefolder(OldDirectory)
                end

                -- Create new subdirectory if it doesn't exist
                if not isfolder(Library.Directory) then 
                    makefolder(Library.Directory)
                end
    
                -- Create required subfolders
                for _, Folder in Library.Folders do 
                    if not isfolder(Library.Directory .. Folder) then 
                        makefolder(Library.Directory .. Folder)
                    end
                end

                -- Migrate autoload.json from old directory if it exists and new one doesn't
                if isfile(OldDirectory .. "/autoload.json") and not isfile(Library.Directory .. "/autoload.json") then
                    pcall(function()
                        local oldContent = readfile(OldDirectory .. "/autoload.json")
                        if oldContent and oldContent ~= "" then
                            writefile(Library.Directory .. "/autoload.json", oldContent)
                        end
                    end)
                end
            end

            if not isfile(Library.Directory .. "/autoload.json") then
                writefile(Library.Directory .. "/autoload.json", "")
            end

            local Window = {
                Name = Params.Name or Params.name or '<font color="rgb(175, 102, 126)">ather.</font>hub',
                Logo = Params.Logo or Params.logo or "rbxassetid://133218922939038",

                IsOpen = true,
                IsMinimized = false,
                IsFullScreen = false,
                ResizeHandler = nil,
                PremiumState = nil,
                PremiumControls = { },
                Pages = { },
                Items = { }
            }

            if IsMobile then 
                Library:Create("UIScale", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Scale = 0.65
                })
            end

            local OriginalSize = UDim2.new(0, 850, 0, 600)

            local Items = { } do 
                Items["MainFrame"] = Library:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 850, 0, 600),
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                }):AddToTheme({BackgroundColor3 = "Background"})

                Items["MainFrame"]:MakeDraggable()
                Window.ResizeHandler = Items["MainFrame"]:MakeResizeable(Vector2.new(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y))
                
                Library:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0"
                })
                
                Items["Top"] = Library:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(28, 28, 29)
                }):AddToTheme({BackgroundColor3 = "Topbar"})
                
                Library:Create("UICorner", {
                    Parent = Items["Top"].Instance,
                    Name = "\0"
                })
                
                Library:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 6),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(28, 28, 29)
                }):AddToTheme({BackgroundColor3 = "Topbar"})
                
                Items["Logo"] = Library:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Logo"].Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                Items["Title"] = Library:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    RichText = true,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = Window.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    TextWrapped = false,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 42, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 17,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Items["_"] = Library:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["_"].Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                    }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                Items["CloseButton"] = Library:Create("ImageButton", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    ImageColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://135014211526638",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({ImageColor3 = "Text"})
                
                Items["FullScreenButton"] = Library:Create("ImageButton", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    ImageColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://79119806011839",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -37, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({ImageColor3 = "Text"})
                
                Items["MinimizeButton"] = Library:Create("ImageButton", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    ImageColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://117286241528046",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -65, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({ImageColor3 = "Text"})
                
                Items["Pages"] = Library:Create("ScrollingFrame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 46),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 225, 1, -61),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65),
                    ScrollBarImageTransparency = 0.5
                })
                
                Library:Create("UIPadding", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 5)
                })

                Library:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Items["Content"] = Library:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Position = UDim2.new(0, 225, 0, 51),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -240, 1, -66),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(15, 15, 16)
                }):AddToTheme({BackgroundColor3 = "Inline"})
                
                Library:Create("UICorner", {
                    Parent = Items["Content"].Instance,
                    Name = "\0"
                })          
                
                Items["DialogBackground"] = Library:Create("TextButton", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.20000000298023224,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 99,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                })

                Library:Create("UICorner", {
                    Parent = Items["DialogBackground"].Instance,
                    Name = "\0"
                })
                
                Window.Items = Items
            end

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

            -- Toggle Button with Logo (supports both asset ids and lucide icons)
            -- Same size for both PC and Mobile: 70x70, bottom left corner
            local toggleSize = UDim2.new(0, 70, 0, 70)
            local togglePos = UDim2.new(0, 20, 1, -90)
            local toggleAnchor = Vector2.new(0, 1)
            local toggleIconSize = UDim2.fromOffset(42, 42)

            Items["ToggleButton"] = Library:Create("TextButton", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = toggleAnchor,
                Position = togglePos,
                Size = toggleSize,
                BackgroundColor3 = Color3.fromRGB(24, 24, 27),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            }):AddToTheme({BackgroundColor3 = "Element"})

            Library:Create("UICorner", {
                Parent = Items["ToggleButton"].Instance,
                Name = "\0",
                CornerRadius = UDim.new(0, 10)
            })

            Library:Create("UIStroke", {
                Parent = Items["ToggleButton"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(37, 37, 37),
                Thickness = 1.5
            })

            -- Add the logo icon to the toggle button
            local toggleIcon = CreateIcon(Window.Logo, toggleIconSize, Color3.fromRGB(220, 229, 247))
            toggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            toggleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
            toggleIcon.Parent = Items["ToggleButton"].Instance

            Items["ToggleButton"]:MakeDraggable()

            Items["ToggleButton"]:Connect("MouseButton1Down", function()
                Window:SetOpen(not Window.IsOpen)
            end)

            Items["MainFrame"].Instance.Size = UDim2.new(0, 50, 0, 50)
            Items["Top"]:FadeDescendants(false, Debounce)
            Items["Pages"]:FadeDescendants(false, Debounce)
            Items["Content"]:FadeDescendants(false, Debounce)
            Items["MainFrame"].Instance.Visible = true
            Items["MainFrame"]:Tween({BackgroundTransparency = 0})
            task.wait(Library.Animation.Time - 0.05)
            Items["MainFrame"]:Tween({Size = UDim2.new(0, 850, 0, 600)}, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            task.wait(1)
            Items["Top"]:FadeDescendants(true, Debounce)
            Items["Pages"]:FadeDescendants(true, Debounce)
            Items["Content"]:FadeDescendants(true, Debounce)

            function Window:Center()
                local AbsPos = Items["MainFrame"].Instance.AbsolutePosition
                Items["MainFrame"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["MainFrame"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y)
                return UDim2.new(0, AbsPos.X, 0, AbsPos.Y)
            end

            function Window:Dialog(Data)
                Items["DialogBackground"].Instance.Visible = true

                local NewPrompt = { }

                local PromptItems = { } do
                    PromptItems["Dialog"] = Library:Create("Frame", {
                        Parent = Items["DialogBackground"].Instance,
                        Name = "\0",
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 350, 0, 155),
                        ZIndex = 99,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(15, 15, 16)
                    }):AddToTheme({BackgroundColor3 = "Inline"})
                    
                    Library:Create("UICorner", {
                        Parent = PromptItems["Dialog"].Instance,
                        Name = "\0",
                        CornerRadius = UDim.new(0, 6)
                    })
                    
                    PromptItems["Title"] = Library:Create("TextLabel", {
                        Parent = PromptItems["Dialog"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = Data.Title,
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2.new(0, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 10),
                        BorderSizePixel = 0,
                        ZIndex = 99,
                        TextSize = 16,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):AddToTheme({TextColor3 = "Text"})
                    
                    PromptItems["Description"] = Library:Create("TextLabel", {
                        Parent = PromptItems["Dialog"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextTransparency = 0.5,
                        Text = Data.Description,
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2.new(0, 0, 0, 15),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 35),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        ZIndex = 99,
                        TextSize = 14,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):AddToTheme({TextColor3 = "Text"})
                    
                    Library:Create("UIStroke", {
                        Parent = PromptItems["Dialog"].Instance,
                        Name = "\0",
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = Color3.fromRGB(26, 26, 26),
                        Thickness = 1.399999976158142
                    })  
                    
                    PromptItems["Buttons"] = Library:Create("Frame", {
                        Parent = PromptItems["Dialog"].Instance,
                        Name = "\0",
                        AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, 10, 1, -10),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(1, -20, 0, 25),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    })
                    
                    Library:Create("UIListLayout", {
                        Parent = PromptItems["Buttons"].Instance,
                        Name = "\0",
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                end

                function NewPrompt:AddButton(Name, Callback)
                    local ButtonItems = { } do 
                        ButtonItems["ButtonBackground"] = Library:Create("TextButton", {
                            Parent = PromptItems["Buttons"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Text = "",
                            AutoButtonColor = false,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 25),
                            ZIndex = 99,
                            TextSize = 14,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        })
                        
                        Library:Create("UICorner", {
                            Parent = ButtonItems["ButtonBackground"].Instance,
                            Name = "\0",
                            CornerRadius = UDim.new(0, 5)
                        })
                        
                        Library:Create("UIGradient", {
                            Parent = ButtonItems["ButtonBackground"].Instance,
                            Name = "\0",
                            Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                        }
                        }):AddToTheme({Color = function()
                            return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                        end})
                        
                        ButtonItems["Button"] = Library:Create("TextButton", {
                            Parent = ButtonItems["ButtonBackground"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Text = "",
                            AutoButtonColor = false,
                            AnchorPoint = Vector2.new(1, 0),
                            BorderSizePixel = 0,
                            Position = UDim2.new(1, 1, 0, 0),
                            Size = UDim2.new(1, -2, 1, 0),
                            ZIndex = 99,
                            TextSize = 14,
                            BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                        }):AddToTheme({BackgroundColor3 = "Element"})
                        
                        Library:Create("UICorner", {
                            Parent = ButtonItems["Button"].Instance,
                            Name = "\0",
                            CornerRadius = UDim.new(0, 5)
                        })
                        
                        ButtonItems["Text"] = Library:Create("TextLabel", {
                            Parent = ButtonItems["ButtonBackground"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextColor3 = Color3.fromRGB(220, 229, 247),
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Text = Name,
                            AutomaticSize = Enum.AutomaticSize.X,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Size = UDim2.new(0, 0, 0, 15),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, -1),
                            BorderSizePixel = 0,
                            ZIndex = 99,
                            TextSize = 14,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }):AddToTheme({TextColor3 = "Text"})
                    end

                    local Press = function()
                        ButtonItems["Button"]:Tween({Size = UDim2.new(0, 0, 1, 0)})
                        task.wait(0.2)
                        ButtonItems["Button"]:Tween({Size = UDim2.new(1, -2, 1, 0)})
                        
                        Library:SafeCall(Callback)
                        NewPrompt:Exit()
                    end

                    ButtonItems["Button"]:Connect("MouseButton1Down", function()
                        Press()
                    end)
                end

                function NewPrompt:Exit()
                    PromptItems["Dialog"]:FadeDescendants(true)
                    task.delay(Library.Animation.Time - 0.05, function()
                        Items["DialogBackground"].Instance.Visible = false 
                    end)
                end

                return NewPrompt
            end

            function Window:Minimize(Bool)
                Window.IsMinimized = Bool 

                if Window.IsMinimized then
                    Items["MainFrame"]:Tween({Size = UDim2.new(0, Items["Title"].Instance.TextBounds.X + 200, 0, 35)})
                    Window.ResizeHandler.CanResize = false
                    Items["Content"].Instance.Visible = false
                    Items["Pages"].Instance.Visible = false

                    for Index, Value in Library.OpenFrames do 
                        Value:SetOpen(false)
                    end
                else
                    Items["MainFrame"]:Tween({Size = OriginalSize})
                    Window.ResizeHandler.CanResize = true
                    Items["Content"].Instance.Visible = true
                    Items["Pages"].Instance.Visible = true

                    for Index, Value in Library.OpenFrames do 
                        Value:SetOpen(false)
                    end
                end
            end

            function Window:FullScreen(Bool)
                Window.IsFullScreen = Bool
                    
                if Window.IsFullScreen then
                    Items["MainFrame"]:Tween({Size = UDim2.new(1, 0, 1, 0)})
                    Items["MainFrame"]:Tween({Position = UDim2.new(0, 0, 0, 0)})
                else
                    Items["MainFrame"]:Tween({Size = OriginalSize})
                    Items["MainFrame"]:Tween({Position = UDim2.new(0, Camera.ViewportSize.X / 3 - 100, 0, Camera.ViewportSize.Y / 3 - 100)})
                end
            end

            -- Notification System
            local NotificationHolder = Instance.new("Frame")
            NotificationHolder.Name = "NotificationHolder"
            NotificationHolder.BackgroundTransparency = 1
            NotificationHolder.Position = UDim2.new(1, -20, 1, -20)
            NotificationHolder.AnchorPoint = Vector2.new(1, 1)
            NotificationHolder.Size = UDim2.new(0, 300, 1, -40)
            NotificationHolder.Parent = Library.Holder.Instance

            local NotificationLayout = Instance.new("UIListLayout")
            NotificationLayout.Padding = UDim.new(0, 8)
            NotificationLayout.FillDirection = Enum.FillDirection.Vertical
            NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
            NotificationLayout.Parent = NotificationHolder

            function Window:Notify(Data)
                Data = Data or {}
                local Title = Data.Title or "Notification"
                local Description = Data.Description or ""
                local Duration = Data.Duration or 5
                local Icon = Data.Icon or "bell"

                -- Main notification frame
                local NotifFrame = Instance.new("Frame")
                NotifFrame.Name = "Notification"
                NotifFrame.BackgroundColor3 = Library.Theme and Library.Theme.Background or Color3.fromRGB(18, 18, 20)
                NotifFrame.Size = UDim2.new(1, 0, 0, 0)
                NotifFrame.AutomaticSize = Enum.AutomaticSize.Y
                NotifFrame.ClipsDescendants = true
                NotifFrame.Parent = NotificationHolder

                local NotifCorner = Instance.new("UICorner")
                NotifCorner.CornerRadius = UDim.new(0, 6)
                NotifCorner.Parent = NotifFrame

                local NotifStroke = Instance.new("UIStroke")
                NotifStroke.Color = Library.Theme and Library.Theme.Outline or Color3.fromRGB(37, 37, 37)
                NotifStroke.Thickness = 1
                NotifStroke.Parent = NotifFrame

                local NotifPadding = Instance.new("UIPadding")
                NotifPadding.PaddingTop = UDim.new(0, 10)
                NotifPadding.PaddingBottom = UDim.new(0, 10)
                NotifPadding.PaddingLeft = UDim.new(0, 12)
                NotifPadding.PaddingRight = UDim.new(0, 12)
                NotifPadding.Parent = NotifFrame

                -- Title label
                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Name = "Title"
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.Position = UDim2.new(0, 0, 0, 0)
                TitleLabel.Size = UDim2.new(1, 0, 0, 18)
                TitleLabel.Font = Enum.Font.GothamBold
                TitleLabel.Text = Title
                TitleLabel.TextColor3 = Library.Theme and Library.Theme.Text or Color3.fromRGB(230, 230, 235)
                TitleLabel.TextSize = 14
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                TitleLabel.Parent = NotifFrame

                -- Description label
                local DescLabel = Instance.new("TextLabel")
                DescLabel.Name = "Description"
                DescLabel.BackgroundTransparency = 1
                DescLabel.Position = UDim2.new(0, 0, 0, 24)
                DescLabel.Size = UDim2.new(1, 0, 0, 0)
                DescLabel.AutomaticSize = Enum.AutomaticSize.Y
                DescLabel.Font = Enum.Font.Gotham
                DescLabel.Text = Description
                DescLabel.TextColor3 = Library.Theme and Library.Theme["Text Dark"] or Color3.fromRGB(150, 150, 155)
                DescLabel.TextSize = 12
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.TextWrapped = true
                DescLabel.Parent = NotifFrame

                -- Progress bar at bottom
                local ProgressBg = Instance.new("Frame")
                ProgressBg.Name = "ProgressBg"
                ProgressBg.BackgroundColor3 = Library.Theme and Library.Theme.Inline or Color3.fromRGB(30, 30, 32)
                ProgressBg.Size = UDim2.new(1, 24, 0, 3)
                ProgressBg.Position = UDim2.new(0, -12, 1, 7)
                ProgressBg.BorderSizePixel = 0
                ProgressBg.Parent = NotifFrame

                local ProgressBar = Instance.new("Frame")
                ProgressBar.Name = "ProgressBar"
                ProgressBar.BackgroundColor3 = Library.Theme and Library.Theme["Accent Start"] or Color3.fromRGB(175, 102, 126)
                ProgressBar.Size = UDim2.new(1, 0, 1, 0)
                ProgressBar.BorderSizePixel = 0
                ProgressBar.Parent = ProgressBg

                local ProgressGradient = Instance.new("UIGradient")
                ProgressGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Library.Theme and Library.Theme["Accent Start"] or Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Library.Theme and Library.Theme["Accent End"] or Color3.fromRGB(114, 75, 130))
                }
                ProgressGradient.Parent = ProgressBar

                -- Animate in
                NotifFrame.BackgroundTransparency = 1
                NotifStroke.Transparency = 1
                TitleLabel.TextTransparency = 1
                DescLabel.TextTransparency = 1
                ProgressBg.BackgroundTransparency = 1
                ProgressBar.BackgroundTransparency = 1

                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                TweenService:Create(NotifFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
                TweenService:Create(NotifStroke, tweenInfo, {Transparency = 0}):Play()
                TweenService:Create(TitleLabel, tweenInfo, {TextTransparency = 0}):Play()
                TweenService:Create(DescLabel, tweenInfo, {TextTransparency = 0}):Play()
                TweenService:Create(ProgressBg, tweenInfo, {BackgroundTransparency = 0}):Play()
                TweenService:Create(ProgressBar, tweenInfo, {BackgroundTransparency = 0}):Play()

                -- Animate progress bar
                local progressTween = TweenService:Create(ProgressBar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
                progressTween:Play()

                -- Remove after duration
                task.delay(Duration, function()
                    local fadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    TweenService:Create(NotifFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
                    TweenService:Create(NotifStroke, fadeInfo, {Transparency = 1}):Play()
                    TweenService:Create(TitleLabel, fadeInfo, {TextTransparency = 1}):Play()
                    TweenService:Create(DescLabel, fadeInfo, {TextTransparency = 1}):Play()
                    TweenService:Create(ProgressBg, fadeInfo, {BackgroundTransparency = 1}):Play()
                    TweenService:Create(ProgressBar, fadeInfo, {BackgroundTransparency = 1}):Play()
                    task.wait(0.35)
                    NotifFrame:Destroy()
                end)

                return NotifFrame
            end

            function Window:UpdatePrem(State)
                local IsEnabled = State and true or false

                Window.PremiumState = IsEnabled

                for _, Control in Window.PremiumControls do
                    if Control and Control.UpdatePrem then
                        Control:UpdatePrem(IsEnabled)
                    end
                end
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Items["CloseButton"]:Connect("MouseButton1Down", function()
                Items["Top"]:FadeDescendants(false, Debounce)
                Items["Pages"]:FadeDescendants(false, Debounce)
                Items["Content"]:FadeDescendants(false, Debounce)
                task.wait(Library.Animation.Time - 0.05)
                local frame = Items["MainFrame"].Instance
                local absPos = frame.AbsolutePosition
                local absSize = frame.AbsoluteSize
                local centerX = absPos.X + absSize.X / 2
                local centerY = absPos.Y + absSize.Y / 2
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.Position = UDim2.new(0, centerX, 0, centerY)
                Items["MainFrame"]:Tween({Size = UDim2.new(0, 50, 0, 50)}, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                task.wait(0.95)
                Items["MainFrame"]:Tween({BackgroundTransparency = 1})
                task.wait(1)
                Library:Exit()
            end)

            Items["MinimizeButton"]:Connect("MouseButton1Down", function()
                if Window.IsFullScreen then 
                    Window:FullScreen(false)
                end

                Window:Minimize(not Window.IsMinimized)
            end)

            Items["FullScreenButton"]:Connect("MouseButton1Down", function()
                if Window.IsMinimized then 
                    Window:Minimize(false)
                end

                Window:FullScreen(not Window.IsFullScreen)
            end)

            Library:Connect(Players.PlayerRemoving, function(Player)
                if Player == LocalPlayer and Library.AutoSave then 
                    print("IM OUT! 1.3 seconds")
                    writefile(Library.Directory .. "/autoload.json", Library:GetConfig())
                end
            end)

            Library.Windoww = Window
            Window:Center()
            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",
                Description = Params.Description or Params.description or "Nigger cupcake",
                Icon = Params.Icon or Params.icon or "rbxassetid://111233133354469",
                Search = Params.Search or Params.search or false,

                Window = Self,
                SubPages = { },
                Items = { },
                SearchItems = { },
                CurrentPage = nil,
                Active = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 60),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(15, 15, 16)
                }):AddToTheme({BackgroundColor3 = "Inline"})
                
                Library:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0"
                })
                
                Items["IconBackground"] = Library:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 40, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["IconBackground"].Instance,
                    Name = "\0"
                })
                
                Items["UIStroke"] = Library:Create("UIStroke", {
                    Parent = Items["IconBackground"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromRGB(37, 37, 37),
                    Thickness = 1.399999976158142
                })
                
                Items["Gradient"] = Library:Create("UIGradient", {
                    Parent = Items["UIStroke"].Instance,
                    Name = "\0",
                    Enabled = false,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                -- Icon container frame (supports both asset ids and lucide icons)
                Items["IconContainer"] = Library:Create("Frame", {
                    Parent = Items["IconBackground"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                -- Apply the icon (asset id or lucide)
                if IsAssetId(Page.Icon) then
                    Items["Icon"] = Library:Create("ImageLabel", {
                        Parent = Items["IconContainer"].Instance,
                        Name = "\0",
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = GetAssetImage(Page.Icon),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):AddToTheme({ImageColor3 = "Text"})
                else
                    -- Lucide icon
                    local iconCreated = ApplyIconToContainer(Items["IconContainer"].Instance, Page.Icon, UDim2.new(1, 0, 1, 0), Library.Theme.Text)
                    if iconCreated then
                        Items["Icon"] = { Instance = iconCreated, Tween = function() end, ChangeItemTheme = function() end }
                    else
                        -- Fallback to empty ImageLabel
                        Items["Icon"] = Library:Create("ImageLabel", {
                            Parent = Items["IconContainer"].Instance,
                            Name = "\0",
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Image = "",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(1, 0, 1, 0),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }):AddToTheme({ImageColor3 = "Text"})
                    end
                end
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    TextTransparency = 0.5,
                    Text = Page.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 62, 0, 12),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Items["Description"] = Library:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    TextTransparency = 0.800000011920929,
                    Text = Page.Description,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 62, 0, 32),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})                

                Items["Page"] = Library:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Items["SubPages"] = Library:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 65),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    ScrollingDirection = Enum.ScrollingDirection.X,
                    AutomaticCanvasSize = Enum.AutomaticSize.X,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65),
                    ScrollBarImageTransparency = 0.5
                })                

                Library:Create("UIListLayout", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    Padding = UDim.new(0, 12),
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    PaddingTop = UDim.new(0, 12)
                })                

                Items["Columns"] = Library:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 75),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, -75),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                if Page.Search then 
                    Items["Columns"].Instance.Position = UDim2.new(0, 0, 0, 115)
                    Items["Columns"].Instance.Size = UDim2.new(1, 0, 1, -115)

                    Items["Search"] = Library:Create("Frame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        Position = UDim2.new(0, 10, 0, 80),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(1, -20, 0, 35),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                    }):AddToTheme({BackgroundColor3 = "Background"})
                    
                    Library:Create("UICorner", {
                        Parent = Items["Search"].Instance,
                        Name = "\0"
                    })
                    
                    Items["Input"] = Library:Create("TextBox", {
                        Parent = Items["Search"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = Color3.fromRGB(220, 229, 247),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        Size = UDim2.new(0, 0, 0, 15),
                        Position = UDim2.new(0, 38, 0.5, -1),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        PlaceholderColor3 = Color3.fromRGB(145, 151, 163),
                        AutomaticSize = Enum.AutomaticSize.X,
                        PlaceholderText = "Search..",
                        TextSize = 14,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Text 2"})
                    
                    Items["Icon__"] = Library:Create("ImageLabel", {
                        Parent = Items["Search"].Instance,
                        Name = "\0",
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Image = "rbxassetid://79227204687245",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0.5, 0),
                        Size = UDim2.new(0, 18, 0, 18),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):AddToTheme({ImageColor3 = "Text"})                    
                end

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end
                
                Debounce = true

                Page.Active = Bool 

                if Bool then 
                    if Page.Search then
                        Items["Columns"]:Tween({Position = UDim2.new(0, 0, 0, 100)}) 
                    else
                        Items["Columns"]:Tween({Position = UDim2.new(0, 0, 0, 60)})
                    end

                    Items["UIStroke"].Instance.Color = Color3.fromRGB(255, 255, 255)
                    Items["Gradient"].Instance.Enabled = true 

                    Items["Text"]:Tween({TextTransparency = 0})
                    Items["Description"]:ChangeItemTheme({TextColor3 = "Accent End"})
                    Items["Description"]:Tween({TextTransparency = 0, TextColor3 = Library.Theme["Accent End"]})

                    Items["Inactive"]:Tween({BackgroundTransparency = 0})
                else
                    if Page.Search then
                        Items["Columns"]:Tween({Position = UDim2.new(0, 0, 0, 120)}) 
                    else
                        Items["Columns"]:Tween({Position = UDim2.new(0, 0, 0, 80)})
                    end
                    Items["Gradient"].Instance.Enabled = false 
                    Items["UIStroke"].Instance.Color = Color3.fromRGB(37, 37, 37)

                    Items["Text"]:Tween({TextTransparency = 0.5})
                    Items["Description"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Description"]:Tween({TextTransparency = 0.8, TextColor3 = Library.Theme["Text"]})

                    Items["Inactive"]:Tween({BackgroundTransparency = 1})
                end

                Items["Page"]:FadeDescendants(Bool, function()
                    Debounce = false

                    if Bool then
                        Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                    else
                        task.delay(Library.Animation.Time, function()
                            if not Page.Active then
                                Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                            end
                        end)
                    end
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if Page.Search then
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    for Index, Value in Page.SearchItems do
                        local Name = Value.Name
                        local Element = Value.Item

                        if string.find(string.lower(Name), string.lower(Items["Input"].Instance.Text)) then
                            if Items["Input"].Instance.Text ~= "" then 
                                Element.Instance.Visible  = true 
                            else
                                Element.Instance.Visible  = true 
                            end
                        else
                            Element.Instance.Visible = false
                        end 
                    end
                end)
            end

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.SubPage = function(Self, Params)
            Params = Params or { }

            local Page = {
                Icon = Params.Icon or Params.icon or "rbxassetid://134546249616852",
                Name = Params.Name or Params.name or "",
                DisplayName = (Params.DisplayName ~= nil and Params.DisplayName) or (Params.displayName ~= nil and Params.displayName) or true,

                Window = Self.Window,
                Page = Self,
                ColumnsData = { },
                Items = { },
                Switching = false,
                Active = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("ImageButton", {
                    Parent = Page.Page.Items["SubPages"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 60, 1, 0)
                })
                
                -- Icon container for SubPage (supports both asset ids and lucide icons)
                Items["IconContainer"] = Library:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 38, 0, 38),
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                -- Track the actual ImageLabel for gradient parenting
                local gradientTarget = nil
                
                -- Apply the icon (asset id or lucide)
                if IsAssetId(Page.Icon) then
                    Items["Icon"] = Library:Create("ImageLabel", {
                        Parent = Items["IconContainer"].Instance,
                        Name = "\0",
                        ImageColor3 = Color3.fromRGB(220, 229, 247),
                        ImageTransparency = 0.800000011920929,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(1, 0, 1, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = GetAssetImage(Page.Icon),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):AddToTheme({ImageColor3 = "Text"})
                    gradientTarget = Items["Icon"].Instance
                else
                    -- Lucide icon - create the icon inside the container
                    local iconCreated = ApplyIconToContainer(Items["IconContainer"].Instance, Page.Icon, UDim2.new(1, 0, 1, 0), Library.Theme.Text)
                    if iconCreated then
                        -- Set transparency on the resolved ImageLabel inside
                        local resolvedImg = ResolveIconImage(iconCreated)
                        if resolvedImg then
                            resolvedImg.ImageTransparency = 0.8
                            gradientTarget = resolvedImg
                        elseif iconCreated:IsA("ImageLabel") then
                            iconCreated.ImageTransparency = 0.8
                            gradientTarget = iconCreated
                        end
                        Items["Icon"] = { 
                            Instance = iconCreated, 
                            Tween = function(self, props) 
                                -- Apply to the resolved ImageLabel inside
                                local img = ResolveIconImage(iconCreated)
                                if img then
                                    TweenService:Create(img, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction]), props):Play()
                                end
                            end, 
                            ChangeItemTheme = function(self, themeProps) 
                                -- Lucide icons don't need theme changes in the same way
                            end 
                        }
                    else
                        -- Fallback to empty ImageLabel
                        Items["Icon"] = Library:Create("ImageLabel", {
                            Parent = Items["IconContainer"].Instance,
                            Name = "\0",
                            ImageColor3 = Color3.fromRGB(220, 229, 247),
                            ImageTransparency = 0.800000011920929,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Size = UDim2.new(1, 0, 1, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Image = "",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            ZIndex = 2,
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }):AddToTheme({ImageColor3 = "Text"})
                        gradientTarget = Items["Icon"].Instance
                    end
                end
                
                Items["IconGradient"] = Library:Create("UIGradient", {
                    Parent = gradientTarget or Items["IconContainer"].Instance,
                    Name = "\0",
                    Enabled = false,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                Items["Shadow"] = Library:Create("ImageLabel", {
                    Parent = Items["IconContainer"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 5, 1, 5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 1,
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Shadow"].Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})

                -- Optional name label below icon (when DisplayName = true)
                if Page.DisplayName and Page.Name and #Page.Name > 0 then
                    Items["NameLabel"] = Library:Create("TextLabel", {
                        Parent = Items["Inactive"].Instance,
                        Name = "\0",
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        TextSize = 10,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        TextYAlignment = Enum.TextYAlignment.Top,
                        Size = UDim2.new(1, -4, 0, 14),
                        Position = UDim2.new(0.5, 0, 0, 38),
                        AnchorPoint = Vector2.new(0.5, 0),
                        BackgroundTransparency = 1,
                        Text = Page.Name,
                        Font = Enum.Font.GothamMedium,
                        TextColor3 = Color3.fromRGB(220, 229, 247),
                        TextTransparency = 0.8,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):AddToTheme({TextColor3 = "Text"})
                    Items["NameLabelGradient"] = Library:Create("UIGradient", {
                        Parent = Items["NameLabel"].Instance,
                        Name = "\0",
                        Enabled = false,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                        }
                    }):AddToTheme({Color = function()
                        return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                    end})
                end
                
                Items["Page"] = Library:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Parent = Items["LeftColumn"].Instance,
                    Name = "\0",
                    PaddingBottom = UDim.new(0, 15),
                    PaddingTop = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 15)
                })
                
                Library:Create("UIListLayout", {
                    Parent = Items["LeftColumn"].Instance,
                    Name = "\0",
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Parent = Items["RightColumn"].Instance,
                    Name = "\0",
                    PaddingBottom = UDim.new(0, 15),
                    PaddingTop = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 15)
                })
                
                Library:Create("UIListLayout", {
                    Parent = Items["RightColumn"].Instance,
                    Name = "\0",
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })           
                
                Page.ColumnsData[1] = Items["LeftColumn"].Instance
                Page.ColumnsData[2] = Items["RightColumn"].Instance

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Debounce = true

                Page.Active = Bool 

                if Bool then 
                    Items["Shadow"]:Tween({ImageTransparency = 0.7})
                    Items["IconGradient"].Instance.Enabled = true 
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent End"})
                    Items["Icon"]:Tween({ImageColor3 = Color3.fromRGB(255, 255, 255), ImageTransparency = 0})
                    if Items["NameLabel"] then
                        Items["NameLabelGradient"].Instance.Enabled = true
                        Items["NameLabel"]:Tween({TextColor3 = Color3.fromRGB(255, 255, 255), TextTransparency = 0})
                    end
                    if Page.Page.Search then 
                        Page.Page.CurrentPage = Page
                    end
                else
                    Items["Shadow"]:Tween({ImageTransparency = 1})
                    Items["IconGradient"].Instance.Enabled = false 
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})
                    Items["Icon"]:Tween({ImageColor3 = Library.Theme.Text, ImageTransparency = 0.8})
                    if Items["NameLabel"] then
                        Items["NameLabelGradient"].Instance.Enabled = false
                        Items["NameLabel"]:Tween({TextColor3 = Library.Theme.Text, TextTransparency = 0.8})
                    end
                end

                Items["Page"]:FadeDescendants(Bool, function()
                    Debounce = false

                    if Bool then
                        Items["Page"].Instance.Parent = Page.Page.Items["Columns"].Instance
                    else
                        task.delay(Library.Animation.Time, function()
                            if not Page.Active then
                                Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                            end
                        end)
                    end
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Page.SubPages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Page.SubPages == 0 then 
                Page:Turn(true)
            end

            table.insert(Page.Page.SubPages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or { } 

            local ParentWindow = rawget(Self, "Window")
            if type(ParentWindow) ~= "table" then
                ParentWindow = Self
            end

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Side = Params.Side or Params.side or 1,

                Window = ParentWindow,
                Page = Self,
                Items = { },
            }

            local Items = { } do 
                Items["Section"] = Library:Create("Frame", {
                    Parent = Section.Page.ColumnsData[Section.Side],
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    TextTransparency = 0.699999988079071,
                    Text = Section.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Items["Inline"] = Library:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    Position = UDim2.new(0, 0, 0, 25),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, -25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                }):AddToTheme({BackgroundColor3 = "Background"})
                
                Items["Content"] = Library:Create("Frame", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 14),
                    PaddingLeft = UDim.new(0, 28),
                    PaddingRight = UDim.new(0, 28)
                })

                Library:Create("UIPadding", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    PaddingBottom = UDim.new(0, 10),
                    PaddingTop = UDim.new(0, 1),
                })                

                Library:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0"
                })                

                Section.Items = Items
            end 

            return setmetatable(Section, Library)
        end

        local function UpdatePremiumOverlay(Items, ParentKey, State)
            local IsEnabled = State and true or false

            if IsEnabled and not Items["Background"] then
                Items["Background"] = Library:Create("TextButton", {
                    Parent = Items[ParentKey].Instance,
                    Name = "\0",
                    Active = false,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 99999,
                    BackgroundTransparency = 0.20000000298023224,
                    Position = UDim2.new(0, -20, 0, 0),
                    Size = UDim2.new(1, 40, 1, 0),
                    Selectable = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                }):AddToTheme({BackgroundColor3 = "Background"})

                Library:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
            end

            if Items["Background"] then
                Items["Background"].Instance.Visible = IsEnabled
            end
        end

        local function TrackWindowPremiumControl(Control)
            local Window = Control and Control.Window

            if type(Window) ~= "table" then
                return
            end

            Window.PremiumControls = Window.PremiumControls or { }

            if not table.find(Window.PremiumControls, Control) then
                table.insert(Window.PremiumControls, Control)
            end

            if Window.PremiumState ~= nil and Control.UpdatePrem then
                Control:UpdatePrem(Window.PremiumState)
            end
        end

        local function IsPremiumLocked(Control)
            return Control and Control.Premium == true
        end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Premium = Params.Premium or Params.premium or false,
                Default = Params.Default or Params.default or false,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Items = { } do 
                Items["Toggle"] = Library:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                if Toggle.Premium then 
                    Items["Background"] = Library:Create("TextButton", {
                        Parent = Items["Toggle"].Instance,
                        Name = "\0",
                        Active = false,
                        ZIndex = 99999, 
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 0.20000000298023224,
                        Position = UDim2.new(0, -20, 0, 0),
                        Size = UDim2.new(1, 40, 1, 0),
                        Selectable = false,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                    }):AddToTheme({BackgroundColor3 = "Background"})
                    
                    Library:Create("UICorner", {
                        Parent = Items["Background"].Instance,
                        Name = "\0",
                        CornerRadius = UDim.new(0, 5)
                    })
                end                    
                
                Items["Indicator"] = Library:Create("TextButton", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, -20, 0.5, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 27),
                    Text = "",
                    AutoButtonColor = false
                }):AddToTheme({BackgroundColor3 = "Element"})
                
                Library:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Items["Inline"] = Library:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    TextTransparency = 0.699999988079071,
                    Text = Toggle.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, -1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"}) 

                Items["SubElements"] = Library:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })  
                
                Items["AddKeybind"] = Library:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(0, 150, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(18, 13, 17)
                }):AddToTheme({BackgroundColor3 = "Background"})
                
                Library:Create("UICorner", {
                    Parent = Items["AddKeybind"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Library:Create("UIStroke", {
                    Parent = Items["AddKeybind"].Instance,
                    Name = "\0",
                    Color = Color3.fromRGB(26, 23, 25),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Inline"})
                
                Items["addText"] = Library:Create("TextLabel", {
                    Parent = Items["AddKeybind"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(210, 210, 210),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "Add Keybind",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = "Text"}) 

                Items["Toggle"]:OnHover(function()
                    if Toggle.Value then 
                        return 
                    end

                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    if Toggle.Value then 
                        return 
                    end
                    
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)
            
                Toggle.Items = Items
            end
            
            local IsKeybindThingOpen = false
            local CanTheyAddAKeybind = true

            function Toggle:SetOpen(Bool)
                if IsPremiumLocked(Toggle) then
                    return
                end

                if not CanTheyAddAKeybind then 
                    return 
                end

                IsKeybindThingOpen = Bool

                if IsKeybindThingOpen then 
                    Items["AddKeybind"].Instance.Visible = true
                    Items["AddKeybind"]:FadeDescendants(true)
                    Items["AddKeybind"].Instance.Parent = Library.Holder.Instance

                    Items["AddKeybind"].Instance.Position = UDim2.new(0, Items["Indicator"].Instance.AbsolutePosition.X, 0, Items["Indicator"].Instance.AbsolutePosition.Y + Items["Indicator"].Instance.AbsoluteSize.Y + 5)
                    
                    Items["AddKeybind"].Instance.ZIndex = 9999
                    Items["addText"].Instance.ZIndex = 9999
                else
                    Items["AddKeybind"]:FadeDescendants(false, function()
                        Items["AddKeybind"].Instance.Visible = false
                    end)

                    Items["AddKeybind"].Instance.Parent = Library.UnusedHolder.Instance
                end
            end

            function Toggle:Set(Bool)
                if IsPremiumLocked(Toggle) then
                    return
                end

                Toggle.Value = Bool 

                if Bool then 
                    Items["Inline"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(0, 14, 0, 14)})
                    Items["Text"]:Tween({TextTransparency = 0})
                else
                    Items["Inline"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)})
                    Items["Text"]:Tween({TextTransparency = 0.7})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:UpdatePrem(State)
                local IsEnabled = State and true or false

                Toggle.Premium = IsEnabled
                UpdatePremiumOverlay(Items, "Toggle", IsEnabled)
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
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Items["Indicator"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Items["Toggle"]:Connect("MouseButton2Down", function()
                Toggle:SetOpen(not IsKeybindThingOpen)
            end)

            Items["AddKeybind"]:Connect("MouseButton1Down", function()
                if not CanTheyAddAKeybind then
                    return 
                end

                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Name = Toggle.Name,
                    Flag = Toggle.Name .. "_Keybind",
                    Default = Enum.KeyCode.Backspace,
                    Callback = function() end,
                    Mode = "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Name = Keybind.Name,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })
                
                Toggle:SetOpen(false)
                CanTheyAddAKeybind = false
            end)

            if Toggle.Page.Page.Search then
                local SearchData = {
                    Item = Items["Toggle"],
                    Name = Toggle.Name 
                }

                table.insert(Toggle.Page.Page.SearchItems, SearchData)
            end

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            TrackWindowPremiumControl(Toggle)
            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or { }

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Premium = Params.Premium or Params.premium or false,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Items = { } do 
                Items["ButtonBackground"] = Library:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                if Button.Premium then 
                    Items["Background"] = Library:Create("TextButton", {
                        Parent = Items["ButtonBackground"].Instance,
                        Name = "\0",
                        Active = false,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 99999, 
                        BackgroundTransparency = 0.20000000298023224,
                        Position = UDim2.new(0, -20, 0, 0),
                        Size = UDim2.new(1, 40, 1, 0),
                        Selectable = false,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                    }):AddToTheme({BackgroundColor3 = "Background"})
                    
                    Library:Create("UICorner", {
                        Parent = Items["Background"].Instance,
                        Name = "\0",
                        CornerRadius = UDim.new(0, 5)
                    })
                end
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["ButtonBackground"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = Button.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["ButtonBackground"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["ButtonBackground"].Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                Items["Button"] = Library:Create("TextButton", {
                    Parent = Items["ButtonBackground"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 1, 0, 0),
                    Size = UDim2.new(1, -2, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                }):AddToTheme({BackgroundColor3 = "Element"})
                
                Library:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })          
                
                Items["Button"]:OnHover(function()
                    Items["Button"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()    
                    Items["Button"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)

                Button.Items = Items
            end

            function Button:Press()
                if IsPremiumLocked(Button) then
                    return
                end

                Items["Button"]:Tween({Size = UDim2.new(0, 0, 1, 0)})
                task.wait(0.2)
                Items["Button"]:Tween({Size = UDim2.new(1, -2, 1, 0)})
                
                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:UpdatePrem(State)
                local IsEnabled = State and true or false

                Button.Premium = IsEnabled
                UpdatePremiumOverlay(Items, "ButtonBackground", IsEnabled)
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            if Button.Page.Page.Search then
                local SearchData = {
                    Item = Items["ButtonBackground"],
                    Name = Button.Name 
                }

                table.insert(Button.Page.Page.SearchItems, SearchData)
            end

            TrackWindowPremiumControl(Button)
            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Premium = Params.Premium or Params.premium or false,
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

            local Items = { } do 
                Items["Slider"] = Library:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                if Slider.Premium then 
                    Items["Background"] = Library:Create("TextButton", {
                        Parent = Items["Slider"].Instance,
                        Name = "\0",
                        Active = false,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 99999, 
                        BackgroundTransparency = 0.20000000298023224,
                        Position = UDim2.new(0, -20, 0, 0),
                        Size = UDim2.new(1, 40, 1, 0),
                        Selectable = false,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                    }):AddToTheme({BackgroundColor3 = "Background"})
                    
                    Library:Create("UICorner", {
                        Parent = Items["Background"].Instance,
                        Name = "\0",
                        CornerRadius = UDim.new(0, 5)
                    })
                end
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 10),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                }):AddToTheme({BackgroundColor3 = "Element"})
                
                Library:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(1, 0)
                })
                
                Items["Accent"] = Library:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                Items["Value"] = Library:Create("TextLabel", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "50%",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 5, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Library:Create("UIStroke", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    Transparency = 0.6000000238418579
                })
                
                Items["Minus"] = Library:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "-",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -20, 1, 0),
                    Size = UDim2.new(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Items["Plus"] = Library:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "+",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 20, 1, 0),
                    Size = UDim2.new(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})    
                
                Items["RealSlider"]:OnHover(function()
                    Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)

                Slider.Items = Items 
            end

            function Slider:Set(Value)
                if IsPremiumLocked(Slider) then
                    return
                end

                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                Items["Accent"]:Tween({Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)
                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:UpdatePrem(State)
                local IsEnabled = State and true or false

                Slider.Premium = IsEnabled
                UpdatePremiumOverlay(Items, "Slider", IsEnabled)
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

            -- Mobile fallback: for executors where GuiObject.InputBegan doesn't fire for touch
            if IsMobile then
                Items["RealSlider"].Instance.MouseButton1Down:Connect(function(x, y)
                    if Slider.Sliding then return end
                    Slider.Sliding = true
                    local fakeInput = {Position = Vector3.new(x, y, 0)}
                    local Value = Slider:GetSize(fakeInput)
                    Slider:Set(Value)
                end)

                Library:Connect(UserInputService.InputEnded, function(Input)
                    if (Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1) then
                        if Slider.Sliding then
                            Slider.Sliding = false
                            if InputChanged then
                                InputChanged:Disconnect()
                                InputChanged = nil
                            end
                        end
                    end
                end)
            end

            Items["Plus"]:Connect("MouseButton1Down", function()
                Slider:Set(Slider.Value + Slider.Decimals)
            end)

            Items["Minus"]:Connect("MouseButton1Down", function()
                Slider:Set(Slider.Value - Slider.Decimals)
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            if Slider.Page.Page.Search then
                local SearchData = {
                    Item = Items["Slider"],
                    Name = Slider.Name 
                }

                table.insert(Slider.Page.Page.SearchItems, SearchData)
            end

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            TrackWindowPremiumControl(Slider)
            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or { }

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                MaxSize = Params.MaxSize or Params.maxsize or 250,
                Default = Params.Default or Params.default or "",
                Premium = Params.Premium or Params.premium or false,
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

            local Items = { } do 
                Items["Dropdown"] = Library:Create("Frame", {
                    Parent = Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 52),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                
                if Dropdown.Premium then 
                    Items["Background"] = Library:Create("TextButton", {
                        Parent = Items["Dropdown"].Instance,
                        Name = "\0",
                        Active = false,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 99999, 
                        BackgroundTransparency = 0.20000000298023224,
                        Position = UDim2.new(0, -20, 0, 0),
                        Size = UDim2.new(1, 40, 1, 0),
                        Selectable = false,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                    }):AddToTheme({BackgroundColor3 = "Background"})
                    
                    Library:Create("UICorner", {
                        Parent = Items["Background"].Instance,
                        Name = "\0",
                        CornerRadius = UDim.new(0, 5)
                    })
                end
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Items["DropdownBackground"] = Library:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["DropdownBackground"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["DropdownBackground"].Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                Items["RealDropdown"] = Library:Create("TextButton", {
                    Parent = Items["DropdownBackground"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 3, 0, 0),
                    Size = UDim2.new(1, -2, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                }):AddToTheme({BackgroundColor3 = "Element"})
                
                Library:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(1, -35, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0.5, -1),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Library:Create("UIGradient", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.897, 0.4312499761581421),
                    NumberSequenceKeypoint.new(1, 1)
                }
                })
                
                Items["Arrow"] = Library:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://130111928866688",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 11, 0, 6),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({ImageColor3 = "Text"})   
                
                Items["OptionHolder"] = Library:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = Dropdown.Name,
                    FontFace = Library.Font,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1189, 0, 104),
                    Size = UDim2.new(0, 263, 0, 146),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                }):AddToTheme({BackgroundColor3 = "Background"})
                
                Library:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0"
                })
                
                Items["Search"] = Library:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Position = UDim2.new(0, 10, 0, 10),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -20, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 26)
                }):AddToTheme({BackgroundColor3 = "Element"})
                
                Library:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    Name = "\0"
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "rbxassetid://79227204687245",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({ImageColor3 = "Text"})
                
                Items["Input"] = Library:Create("TextBox", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Size = UDim2.new(1, -46, 0, 15),
                    Position = UDim2.new(0, 38, 0.5, -1),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = Color3.fromRGB(145, 151, 163),
                    AutomaticSize = Enum.AutomaticSize.None,
                    PlaceholderText = "Search..",
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Text 2"})
                
                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Color3.fromRGB(175, 102, 126),
                    MidImage = "rbxassetid://81680855285439",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -20, 1, -60),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 50),
                    BottomImage = "rbxassetid://81680855285439",
                    TopImage = "rbxassetid://81680855285439",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({ScrollBarImageColor3 = "Accent Start"})
                
                Library:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })             
                
                Library:Create("UIPadding", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    PaddingRight = UDim.new(0, 10)
                })         
                
                Items["RealDropdown"]:OnHover(function()
                    Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)

                Dropdown.Items = Items 
            end

            function Dropdown:Set(Value)
                if IsPremiumLocked(Dropdown) then
                    return
                end

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
                            Value.Selected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionBackground = Library:Create("TextButton", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = OptionBackground.Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Library:Create("UIGradient", {
                    Parent = OptionBackground.Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                local OptionButton = Library:Create("TextButton", {
                    Parent = OptionBackground.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 3, 0, 0),
                    Size = UDim2.new(1, -2, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                })
                
                Library:Create("UICorner", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                local OptionText = Library:Create("TextLabel", {
                    Parent = OptionBackground.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    TextTransparency = 0.5,
                    Text = Value,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, -1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})     

                local OptionData = {
                    RealButton = OptionBackground,
                    Background = OptionBackground,
                    Button = OptionButton,
                    Text = OptionText,
                    Name = Value,
                    IsSelected = false
                }
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionData.Text:Tween({TextTransparency = 0, Position = UDim2.new(0, 10, 0.5, -1)})
                        OptionData.Background:Tween({BackgroundTransparency = 0})
                        OptionData.Button:Tween({BackgroundTransparency = 0})
                    else
                        OptionData.Text:Tween({TextTransparency = 0.5, Position = UDim2.new(0, 0, 0.5, -1)})
                        OptionData.Background:Tween({BackgroundTransparency = 1})
                        OptionData.Button:Tween({BackgroundTransparency = 1})
                    end
                end

                function OptionData:Set()
                    if IsPremiumLocked(Dropdown) then
                        return
                    end

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

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or ""
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
                    Dropdown.Options[Option].RealButton.Instance:Destroy()
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

            function Dropdown:UpdatePrem(State)
                local IsEnabled = State and true or false

                Dropdown.Premium = IsEnabled
                UpdatePremiumOverlay(Items, "Dropdown", IsEnabled)
            end

            local Debounce = false 
            local RenderStepped 

            function Dropdown:SetOpen(Bool)
                if IsPremiumLocked(Dropdown) then
                    return
                end

                if Debounce then 
                    return 
                end

                Dropdown.IsOpen = Bool

                Debounce = true 
                
                if Dropdown.IsOpen then 
                    Items["Arrow"]:Tween({Rotation = -90})

                    Items["OptionHolder"].Instance.Position = UDim2.new(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y)
                    Items["OptionHolder"].Instance.Size = UDim2.new(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, Dropdown.MaxSize)
                    
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y + 10)})
                    
                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false 

                        RenderStepped = RunService.RenderStepped:Connect(function()
                            Items["OptionHolder"].Instance.Position = UDim2.new(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y + 10)
                            Items["OptionHolder"].Instance.Size = UDim2.new(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, Dropdown.MaxSize)
                        end)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Dropdown and not Params.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    Items["Arrow"]:Tween({Rotation = 0})

                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y - 10)})
                    Items["OptionHolder"]:FadeDescendants(false, function()
                        Items["OptionHolder"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                table.insert(Descendants, Items["OptionHolder"].Instance)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = Dropdown.IsOpen and 3 or 1
                end
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

            Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                for Index, Value in Dropdown.Options do 
                    if string.find(string.lower(Value.Name), string.lower(Items["Input"].Instance.Text)) then
                        Value.RealButton.Instance.Visible = true
                    else
                        Value.RealButton.Instance.Visible = false
                    end
                end
            end)

            if not Params.Parent then
                Items["RealDropdown"]:Connect("Changed", function(Property)
                    if Property == "AbsolutePosition" and Dropdown.IsOpen then
                        Dropdown.IsOpen = not Items["OptionHolder"]:IsClipped(Dropdown.Section.Items["Section"].Instance.Parent)
                        Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    end
                end)
            end

            for Index, Value in Dropdown.OptionItems do 
                Dropdown:Add(Value)
            end
            
            if not Params.Parent then
                if Dropdown.Page.Page.Search then
                    local SearchData = {
                        Item = Items["Dropdown"],
                        Name = Dropdown.Name 
                    }

                    table.insert(Dropdown.Page.Page.SearchItems, SearchData)
                end
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            TrackWindowPremiumControl(Dropdown)
            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or { }

            local Label = {
                Name = Params.Name or Params.name or "Label",
                Premium = Params.Premium or Params.premium or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Items = { } do 
                Items["Label"] = Library:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                if Label.Premium then 
                    Items["Background"] = Library:Create("TextButton", {
                        Parent = Items["Label"].Instance,
                        Name = "\0",
                        Active = false,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 99999, 
                        BackgroundTransparency = 0.20000000298023224,
                        Position = UDim2.new(0, -20, 0, 0),
                        Size = UDim2.new(1, 40, 1, 0),
                        Selectable = false,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                    }):AddToTheme({BackgroundColor3 = "Background"})
                    
                    Library:Create("UICorner", {
                        Parent = Items["Background"].Instance,
                        Name = "\0",
                        CornerRadius = UDim.new(0, 5)
                    })
                end
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = Label.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubElements"] = Library:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Label.Items = Items 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool 
            end

            function Label:UpdatePrem(State)
                local IsEnabled = State and true or false

                Label.Premium = IsEnabled
                UpdatePremiumOverlay(Items, "Label", IsEnabled)
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
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
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
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

            if Label.Page.Page.Search then
                local SearchData = {
                    Item = Items["Label"],
                    Name = Label.Name 
                }

                table.insert(Label.Page.Page.SearchItems, SearchData)
            end

            Label:SetText(Label.Name)

            TrackWindowPremiumControl(Label)
            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or { }

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Numeric = Params.Numeric or Params.numeric or false,
                Premium = Params.Premium or Params.premium or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Items = { } do 
                Items["Textbox"] = Library:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 52),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                if Textbox.Premium then 
                    Items["Background"] = Library:Create("TextButton", {
                        Parent = Items["Textbox"].Instance,
                        Name = "\0",
                        Active = false,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 99999, 
                        BackgroundTransparency = 0.20000000298023224,
                        Position = UDim2.new(0, -20, 0, 0),
                        Size = UDim2.new(1, 40, 1, 0),
                        Selectable = false,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                    }):AddToTheme({BackgroundColor3 = "Background"})
                    
                    Library:Create("UICorner", {
                        Parent = Items["Background"].Instance,
                        Name = "\0",
                        CornerRadius = UDim.new(0, 5)
                    })
                end
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Items["Background"] = Library:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    Active = true,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 25),
                    Selectable = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 102, 126)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 75, 130))
                }
                }):AddToTheme({Color = function()
                    return ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme["Accent Start"]),ColorSequenceKeypoint.new(1, Library.Theme["Accent End"])}
                end})
                
                Items["Inline"] = Library:Create("TextButton", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 3, 0, 0),
                    Size = UDim2.new(1, -2, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                }):AddToTheme({BackgroundColor3 = "Element"})
                
                Library:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 5)
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Color3.fromRGB(145, 151, 163),
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 14,
                    Size = UDim2.new(1, -20, 0, 15),
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0.5, -1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Text 2"})
                
                Library:Create("UIGradient", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.897, 0.4312499761581421),
                    NumberSequenceKeypoint.new(1, 1)
                }
                })                

                Items["Inline"]:OnHover(function()
                    Items["Inline"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    Items["Inline"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)

                if IsMobile then
                    Items["Inline"]:Connect("MouseButton1Click", function()
                        Items["Input"].Instance:CaptureFocus()
                    end)
                end

                Textbox.Items = Items
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:UpdatePrem(State)
                local IsEnabled = State and true or false

                Textbox.Premium = IsEnabled
                UpdatePremiumOverlay(Items, "Textbox", IsEnabled)
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if IsPremiumLocked(Textbox) then
                    return
                end

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

            if Textbox.Page.Page.Search then
                local SearchData = {
                    Item = Items["Textbox"],
                    Name = Textbox.Name 
                }

                table.insert(Textbox.Page.Page.SearchItems, SearchData)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
            
            TrackWindowPremiumControl(Textbox)
            return setmetatable(Textbox, Library)
        end

        Library.Status = function(Self, Params)
            Params = Params or { }

            local Paragraph = {
                Name = Params.Name or Params.name or "Label",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Items = { } do 
                Items["Paragraph"] = Library:Create("Frame", {
                    Parent = Paragraph.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Parent = Items["Paragraph"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = Paragraph.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})
                
                Items["Statuses"] = Library:Create("Frame", {
                    Parent = Items["Paragraph"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 18),
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIListLayout", {
                    Parent = Items["Statuses"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Paragraph.Items = Items 
            end

            function Paragraph:AddStatus(Text)
                local NewStatus = Library:Create("TextLabel", {
                    Parent = Items["Statuses"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    TextTransparency = 0.5,
                    Text = Text,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})

                function NewStatus:Set(Text)
                    NewStatus.Instance.Text = Text
                end

                return NewStatus
            end

            function Paragraph:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool 
            end

            function Paragraph:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            if Paragraph.Page.Page.Search then
                local SearchData = {
                    Item = Items["Paragraph"],
                    Name = Paragraph.Name 
                }

                table.insert(Paragraph.Page.Page.SearchItems, SearchData)
            end

            Paragraph:SetText(Paragraph.Name)

            return setmetatable(Paragraph, Library)
        end

        Library.List = function(Self, Params)
            Params = Params or { }

            local List = {
                Callback = Params.Callback or Params.callback or function() end,
                ListItems = Params.Items or Params.items or { },

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Options = { },
                Items = { },
            }

            local Items = { } do 
                List.Page.Items.RightColumn.Instance:Destroy()
                List.Page.Items.LeftColumn.Instance:FindFirstChildOfClass("UIPadding").PaddingRight = UDim.new(0, 15)

                Items["List"] = Library:Create("Frame", {
                    Parent = List.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 250),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                })
                
                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0, 1),
                    Size = UDim2.new(1, 0, 0, 200),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Library:Create("UIStroke", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    Color = Color3.fromRGB(15, 15, 16)
                }):AddToTheme({Color = 'Inline'})
                
                Library:Create("UICorner", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 6)
                })
                
                Items["Fade"] = Library:Create("Frame", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                Library:Create("UICorner", {
                    Parent = Items["Fade"].Instance,
                    Name = "\0",
                    CornerRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIGradient", {
                    Parent = Items["Fade"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.15, 0.96875),
                    NumberSequenceKeypoint.new(0.262, 0.8062499761581421),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["Search"] = Library:Create("Frame", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    Position = UDim2.new(0, 0, 0, 5),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(15, 15, 16)
                }):AddToTheme({BackgroundColor3 = "Inline"})
                
                Library:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    Name = "\0"
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(220, 229, 247),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 38, 0.5, -1),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = Color3.fromRGB(145, 151, 163),
                    AutomaticSize = Enum.AutomaticSize.X,
                    PlaceholderText = "Search..",
                    TextSize = 14,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Text 2"})
                
                Items["Icon__"] = Library:Create("ImageLabel", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = "rbxassetid://79227204687245",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({ImageColor3 = "Text"})
                
                Library:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    Color = Color3.fromRGB(15, 15, 16)
                })
            end

            function List:Add(Name)
                local IsEven = #List.Items % 2 == 0

                local NewItemOption = Library:Create("TextButton", {
                    Parent = Items["Holder"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    LayoutOrder = #List.Items,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(15, 15, 16)
                })

                local ColorSelected
                local ColorThemeSelected

                if IsEven then
                    ColorSelected = Library.Theme.Inline
                    ColorThemeSelected = "Inline"
                    NewItemOption.Instance.BackgroundColor3 = Library.Theme.Inline
                    NewItemOption:AddToTheme({BackgroundColor3 = "Inline"})
                else
                    ColorSelected = Library.Theme.Background
                    ColorThemeSelected = "Background"
                    NewItemOption.Instance.BackgroundColor3 = Library.Theme.Background
                    NewItemOption:AddToTheme({BackgroundColor3 = "Background"})
                end
                
                if #List.Items == 0 then
                    Library:Create("UICorner", {
                        Parent = NewItemOption.Instance,
                        Name = "\0",
                        CornerRadius = UDim.new(0, 6)
                    })
                
                    Library:Create("Frame", {
                        Parent = NewItemOption.Instance,
                        Name = "\0",
                        AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(1, 0, 0, 5),
                        BorderSizePixel = 0,
                        BackgroundColor3 = ColorSelected
                    }):AddToTheme({BackgroundColor3 = ColorThemeSelected})
                end
                
                local StatHolder = Library:Create("Frame", {
                    Parent = NewItemOption.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Library:Create("UIListLayout", {
                    Parent = StatHolder.Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    FillDirection = Enum.FillDirection.Horizontal
                })               
                
                Library:Create("UIPadding", {
                    Parent = StatHolder.Instance,
                    Name = "\0",
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })                

                local NewStat = {
                    Name = Name,
                    StatHolder = StatHolder,
                    OrigColor = ColorSelected,
                    Button = NewItemOption,
                    Order = 0,
                }

                function NewStat:AddStat(Text)
                    return Library:Create("TextLabel", {
                        Parent = StatHolder.Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Text = Text,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 0, 15),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 14,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):AddToTheme({TextColor3 = "Text"})
                end

                table.insert(List.Items, NewStat)
                return NewStat
            end

            local Dragging = nil

            function List:GetLabelUnderMouse(MouseY)
                for _, Stat in ipairs(List.Items) do
                    local Pos = Stat.Button.Instance.AbsolutePosition.Y
                    local Size = Stat.Button.Instance.AbsoluteSize.Y
            
                    if MouseY >= Pos and MouseY <= Pos + Size then
                        return Stat
                    end
                end
            end

            for Index, Value in List.ListItems do 
                local NewStat = List:Add(Value[1])
                
                for _, Value2 in Value do 
                    NewStat:AddStat(Value2)
                end
            end

            for Index, Value in List.Items do 
                Value.Button:Connect("MouseButton1Down", function()
                    Dragging = Value
                    Value.Button:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end)
            end

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        local MouseY = Input.Position.Y
                        local Target = List:GetLabelUnderMouse(MouseY)
                
                        if Target and Target ~= Dragging then
                            Dragging.Button.Instance.LayoutOrder, Target.Button.Instance.LayoutOrder = Target.Button.Instance.LayoutOrder, Dragging.Button.Instance.LayoutOrder
                        end
                    end
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Dragging.Button:Tween({BackgroundColor3 = Dragging.OrigColor})
                        Dragging = nil
                    end
                end
            end)

            Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                for Index, Value in List.Items do
                    if string.find(string.lower(Value.Name), string.lower(Items["Input"].Instance.Text)) then
                        Value.Button.Instance.Visible = true
                    else
                        Value.Button.Instance.Visible = false
                    end
                end
            end)

            return setmetatable(List, Library)
        end

        Library.CreateSettingsPage = function(Self)
            local SettingsPage = Self:Page({Name = "Settings", Icon = "rbxassetid://103129505225192", Description = "Configs & Theming"})
            
            local GeneralSubTab = SettingsPage:SubPage({Name = "General", Icon = "rbxassetid://72301479762701"})
            GeneralSubTab.Items.RightColumn.Instance:Destroy()
            GeneralSubTab.Items.LeftColumn.Instance:FindFirstChildOfClass("UIPadding").PaddingRight = UDim.new(0, 15)

            return GeneralSubTab
        end

        Library.CreateConfigsSection = function(Self)
            local ConfigsSection = Self:Section({Name = "Settings", Side = 1})

            do
                local ConfigName 
                local ConfigSelected 
                local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                local ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs",
                    Flag = "ConfigsDropdown",
                    Items = { },
                    Multi = false,
                    Callback = function(Value)
                        ConfigSelected = Value 
                    end
                })

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

                            local configData = Library:GetConfig()
                            writefile(ConfigsFolder .. ConfigName .. ".json", configData)
                            writefile(Library.Directory .. "/autoload.json", configData)
                            Library:GetConfigsList(ConfigsDropdown)
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        local Dialog = Library.Windoww:Dialog({
                            Title = "Warning",
                            Description = "Are you sure you want to delete this config?",
                        })

                        Dialog:AddButton("Confirm", function()
                            if ConfigSelected then 
                                if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    delfile(ConfigsFolder .. ConfigSelected .. ".json")
                                    Library:GetConfigsList(ConfigsDropdown)
                                end
                            end
                        end)

                        Dialog:AddButton("Cancel", function() end)
                    end
                })

                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        local Dialog = Library.Windoww:Dialog({
                            Title = "Warning",
                            Description = "Are you sure you want to load this config?",
                        })

                        Dialog:AddButton("Confirm", function()
                            if ConfigSelected then 
                                if isfile(ConfigsFolder.. ConfigSelected .. ".json") then
                                    local ConfigContent = readfile(ConfigsFolder.. ConfigSelected .. ".json")
                                    local Success, Error = Library:LoadConfig(ConfigContent)
                                end
                            end
                        end)

                        Dialog:AddButton("Cancel", function() end)
                    end
                })

                ConfigsSection:Button({
                    Name = "Save",
                    Callback = function()
                        local Dialog = Library.Windoww:Dialog({
                            Title = "Warning",
                            Description = "Are you sure you want to save this config?",
                        })

                        Dialog:AddButton("Confirm", function()
                            if ConfigSelected then
                                if isfile(ConfigsFolder.. ConfigSelected .. ".json") then
                                    local Success, Error = pcall(function()
                                        writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                                    end)
                                end
                            end
                        end)

                        Dialog:AddButton("Cancel", function() end)
                    end
                })

                ConfigsSection:Label({Name = "UI Keybind"}):Keybind({
                    Flag = "UIToggleKeybind",
                    Default = Enum.KeyCode.X,
                    Mode = "Toggle",
                    Callback  = function(Keybind)
                        Library.MenuKeybind = Flags["UIToggleKeybind"].Key
                    end
                })

                ConfigsSection:Toggle({
                    Name = "Auto Save",
                    Flag = "Auto Save",
                    Default = true,
                    Callback = function(Value)
                        Library.AutoSave = Value
                    end
                })

                Library:GetConfigsList(ConfigsDropdown)
            end
        end

        Library.CreateThemingSection = function(Self)
            local ThemeSection = Self:Section({Name = "Theme", Side = 1})

            do 
                for Index, Value in Library.Theme do 
                    ThemeSection:Label({Name = Index}):Colorpicker({
                        Flag = Index,
                        Default = Value,
                        Callback = function(Value)
                            Library.Theme[Index] = Value,
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                end
            end
        end
    end
end

-- local Window = Library:Window({
--     Name = '<font color="rgb(175, 102, 126)">SAMET UI.</font>hub',
--     Logo = "rbxassetid://133218922939038"
-- })

-- local Combat = Window:Page({
--     Name = "Combat", 
--     Description = "combat page", 
--     Icon = "lucide:house",
--     Search = false, -- will decide if the page will have a search functionality or nott
-- })

-- local Visuals = Window:Page({Name = "Visuals", Description = "visuals page", Icon = "rbxassetid://111233133354469", Search = false})
-- local Misc = Window:Page({Name = "Misc", Description = "misc page", Icon = "rbxassetid://111233133354469", Search = false})

-- local MovementSubPage = Combat:SubPage({Icon = "rbxassetid://134546249616852"})
-- local CombatSubPage = Combat:SubPage({Icon = "rbxassetid://134546249616852"})
-- local VisualsSubPage = Visuals:SubPage({Icon = "rbxassetid://134546249616852"})
-- local MiscSubPage = Misc:SubPage({Icon = "rbxassetid://134546249616852"})

-- local SettingsPage = Window:CreateSettingsPage()
-- SettingsPage:CreateConfigsSection()
-- SettingsPage:CreateThemingSection()

-- local SectionLeft = MovementSubPage:Section({
--     Name = "Section Left",
--     Side = 1
-- })

-- local SectionRight = MovementSubPage:Section({
--     Name = "Section Right",
--     Side = 2
-- })

-- local ListSection = CombatSubPage:Section({
--     Name = "List Section",
--     Side = 1
-- })

-- local example toggle = SectionLeft:Toggle({
--     Name = "Toggle",
--     Flag = "Toggle",
--     Default = false,
--     Callback = function(Value)
--         print(Value)
--     end
-- })

-- SectionLeft:Button({
--     Name = "Button",
--     Callback = function()
--         print("Button")
--     end
-- })

-- SectionLeft:Slider({
--     Name = "Slider",
--     Flag = "Slider",
--     Default = 50,
--     Min = 0,
--     Max = 100,
--     Decimals = 1,
--     Suffix = "%",
--     Callback = function(Value)
--         print(Value)
--     end
-- })

-- SectionLeft:Dropdown({
--     Name = "Dropdown",
--     Flag = "Dropdown",
--     Items = { "Item 1", "Item 2", "Item 3" },
--     Default = "Item 1",
--     Callback = function(Value)
--         print(Value)
--     end
-- })

-- SectionLeft:Label({Name = "This is a label by itself"})
-- SectionLeft:Label({Name = "This is a label but colorpicker"}):Colorpicker({
--     Flag = "Colorpicker",
--     Default = Color3.fromRGB(255, 255, 255),
--     Callback = function(Value)
--         print(Value)
--     end
-- })

-- SectionLeft:Label({Name = "This is a label but keybind"}):Keybind({
--     Name = "Keybind",
--     Flag = "Keybind",
--     Default = Enum.KeyCode.E,
--     Callback = function(Value)
--         print(Value)
--     end
-- })

-- SectionLeft:Textbox({
--     Name = "Textbox",
--     Flag = "Textbox",
--     Default = "Text",
--     Numeric = false,
--     Finished = false,
--     Callback = function(Value)
--         print(Value)
--     end
-- })

-- local Status = SectionLeft:Status({Name = "status"})

-- for Index = 1, 5 do 
--     local newsttatus = Status:AddStatus("value: " .. Index)
--     --newstatus:Set("new value: " .. Index)
-- end

-- ListSection:List({
--     Items = {
--         {"Item 1", "1$", "10$"},
--         {"Item 2", "2$", "20$"},
--         {"Item 3", "3$", "30$"},
--         {"Item 4", "4$", "40$"},
--         {"Item 5", "5$", "50$"},
--         {"Item 6", "6$", "60$"},
--         {"Item 7", "7$", "70$"},
--         {"Item 8", "8$", "80$"},
--         {"Item 9", "9$", "90$"},
--         {"Item 10", "10$", "100$"},
--     },
--     Callback = function(Value)
--         print(Value)
--     end
-- })

-- Library:CheckForAutoLoad()

getgenv().Library = Library
return Library