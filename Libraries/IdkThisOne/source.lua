-- IdkThisOne UI library preserved for VaultUI.
-- Original runtime logic and public API retained.

if getgenv().Library then 
    getgenv().Library:Unload()
end

local Library do
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local InstanceNew = Instance.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower

    local RectNew = Rect.new

    Library = {
        Flags = { },

        MenuKeybind = tostring(Enum.KeyCode.Z), 

        Tween = {
            Time = 0.25,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        },

        Folders = {
            Directory = "zoophack",
            Configs = "zoophack/Configs",
            Assets = "zoophack/Assets",
            Themes = "zoophack/Themes"
        },

        Images = { -- you're welcome to reupload the images and replace it with your own links
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/horizontalhue.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
            ["Scrollbar"] =  { "Scrollbar.png", "https://github.com/sametexe001/images/blob/main/scrollbar.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        Themes = { },
        
        CurrentFrames = { },

        ThemeColorpickers = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        UnusedHolder = nil,
        NotifHolder = nil,
        Font = nil,
        BoldFont = nil,
    }

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

    Library.__index = Library

    Library.Pages.__index = Library.Pages
    Library.Sections.__index = Library.Sections

    -- Files
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    for Index, Image in Library.Images do
        if not isfile(Library.Folders.Assets .. "/" .. Image[1]) then
            writefile(Library.Folders.Assets .. "/" .. Image[1], game:HttpGet(Image[2]))
        end
    end

    local Themes = {
        ["Default"] = {
            ["Background"] = FromRGB(14, 14, 14),
            ["Inline"] = FromRGB(11, 11, 11),
            ["Text"] = FromRGB(255, 255, 255),
            ["Element"] =  FromRGB(11, 11, 11),
            ["Image"] =  FromRGB(255, 255, 255),
            ["Accent"] = FromRGB(181, 116, 16),
            ["Light Accent"] = FromRGB(255, 156, 6),
            ["Border"] = FromRGB(24, 24, 24)
        }
    }

    Library.Theme = TableClone(Themes["Default"])
    Library.Themes = Themes

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local RawGui = self
            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    RawGui.Debounce = true 
                end
            end)

            self:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false

                    RawGui.Debounce = false 
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        RawGui.Debounce = true 
                        Set(Input)
                    end
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local RawGui = self
            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("TextButton", {
				Parent = Gui,
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 8, 0, 8),
				Position = UDim2New(1, 0, 1, 0),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
                ZIndex = 2000,
                Visible = true,
                Text = ""
			})

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                end
            end)

            ResizeButton:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement and Resizing and not RawGui.Debounce then
					ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

					Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
					Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

					Tween:Create(Gui, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("Inter", 200, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Inter.ttf"
        })

        CustomFont:New("InterBold", 200, "Bold", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterBold.ttf"
        })

        Library.Font = CustomFont:Get("Inter")
        Library.BoldFont = CustomFont:Get("InterBold")
    end

    -- Library
    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true,
        Enabled = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        BorderColor3 = FromRGB(0, 0, 0),
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2New(0, 15, 0, 55),
        Size = UDim2New(0, 0, 1, -55),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    }) 

    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Padding = UDimNew(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder
    }) 

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance or Frame

        local AbsolutePosition = Frame.AbsolutePosition
        local AbsoluteSize = Frame.AbsoluteSize

        if Mouse.X >= AbsolutePosition.X and Mouse.X <= AbsolutePosition.X + AbsoluteSize.X and Mouse.Y >= AbsolutePosition.Y and Mouse.Y <= AbsolutePosition.Y + AbsoluteSize.Y then    
            return true
        end

        return false 
    end

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end
        
        getgenv().Library = nil
        Library = nil 
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)

        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            Library:Notification("Error!", "Error caught in function, report this to the devs:\n"..Result, 5)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("Connection_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("Flag Number %s %s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = self:SafeCall(function()
            for Index, Value in self.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = self:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = self.SetFlags[Index]

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
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(self.Folders.Configs .. "/" .. Config) then 
            delfile(self.Folders.Configs .. "/" .. Config)
            self:Notification("Success", "Deleted config " .. Config, 5)
        end
    end

    Library.SaveConfig = function(self, Config)
        if isfile(self.Folders.Configs .. "/" .. Config) then
            writefile(self.Folders.Configs .. "/" .. Config, self:GetConfig())
            self:Notification("Success", "Saved config " .. Config, 5)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(self.Folders.Configs, self.Folders.Directory .. "/", "")

        for Index, Value in listfiles(self.Folders.Configs) do
            local FileName = StringGSub(Value, self.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                end
            end
        end
    end

    Library.GetTransparencyPropertyFromItem = function(self, Item)
        if Item:IsA("Frame") then
            return {"BackgroundTransparency"}
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.FadeItem = function(self, Item, Property, Visibility, Speed)
        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.Notification = function(self, Text, Description, Duration)
        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = Library.NotifHolder.Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UICorner", {
                Parent = Items["Notification"].Instance,
                CornerRadius = UDimNew(0, 4)
            }) 

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Text,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({BackgroundColor3 = "Text"})

            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            }) 

            Items["Description"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                TextWrapped = true,
                Name = "====sa0dSA=DSAJGjmsaM",
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = Description,
                Size = UDim2New(0, 0, 0, 15),
                Position = UDim2New(0, 0, 0, 18),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Library.Font,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Description"]:AddToTheme({TextColor3 = "Text"})
        end

        Items["Notification"].Instance.BackgroundTransparency = 1
        local OldSize = Items["Notification"].Instance.AbsoluteSize
        Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)
        for Index, Value in Items["Notification"].Instance:GetDescendants() do
            if Value:IsA("UIStroke") then 
                Value.Transparency = 1
            elseif Value:IsA("TextLabel") then 
                Value.TextTransparency = 1
            elseif Value:IsA("Frame") then 
                Value.BackgroundTransparency = 1
            end
        end

        Library:Thread(function()
            Items["Notification"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, OldSize.X, 0, OldSize.Y)})
            
            task.wait(0.06)

            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("UIStroke") then
                    Tween:Create(Value, nil, {Transparency = 0}, true)
                elseif Value:IsA("TextLabel") then
                    if Value.Name ~= "====sa0dSA=DSAJGjmsaM" then 
                        Tween:Create(Value, nil, {TextTransparency = 0}, true)
                    else
                        Tween:Create(Value, nil, {TextTransparency = 0.5}, true)
                    end
                elseif Value:IsA("Frame") then
                    Tween:Create(Value, nil, {BackgroundTransparency = 0}, true)
                end
            end

            task.delay(Duration + 0.1, function()
                for Index, Value in Items["Notification"].Instance:GetDescendants() do
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 1}, true)
                    elseif Value:IsA("TextLabel") then
                        Tween:Create(Value, nil, {TextTransparency = 1}, true)
                    elseif Value:IsA("Frame") then
                        Tween:Create(Value, nil, {BackgroundTransparency = 1}, true)
                    end
                end

                task.wait(0.06)

                Items["Notification"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})

                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

    Library.CreateColorpicker = function(self, Data)
        Data = Data or { }
        
        local Colorpicker = {
            Window = Data.Window,
            Tab = Data.Tab,
            Section = Data.Section,

            Flag = Data.Flag,

            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            Color = FromRGB(0, 0, 0),
            HexValue = "",
            
            IsOpen = false,
        }

        Library.Flags[Colorpicker.Flag] = { }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                BorderSizePixel = 0,
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 15, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(0, 181, 6)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["ColorpickerButton"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            local CalculateCount = function(Index)
                local MaxButtonsAdded = 5

                local Column = Index % MaxButtonsAdded
            
                local ButtonSize = Items["ColorpickerButton"].Instance.AbsoluteSize
                local Spacing = 4
            
                local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - ButtonSize.X
            
                Items["ColorpickerButton"].Instance.Position = UDim2New(1, Data.IsToggle and -XPosition - 20 or -XPosition, 0.5, 0)
            end

            CalculateCount(Data.Count)

            Items["ColorpickerWindow"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + 25, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 243, 0, 213),
                Visible = false,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(14, 14, 14)
            })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})

            Instances:Create("UICorner", {
                Parent = Items["ColorpickerWindow"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                ImageColor3 = FromRGB(0, 0, 0),
                ImageTransparency = 0.5799999833106995,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = -1,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.6000000238418579,
                Name = "\0",
                Size = UDim2New(1, 55, 1, 55),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  

            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, -60),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(0, 181, 6)
            }) 

            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Saturation"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Value"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Value"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["Palette"].Instance,
                CornerRadius = UDimNew(0, 4)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0, 10),
                Size = UDim2New(0, 8, 0, 8),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Color = FromRGB(255, 255, 255),
                Thickness = 2.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }) 

            Instances:Create("UICorner", {
                Parent = Items["PaletteDragger"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                Position = UDim2New(0, 0, 1, -35),
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 14),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(0, 181, 6)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Alpha"].Instance,
                CornerRadius = UDimNew(0, 4)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Checkers"),
                TileSize = UDim2New(0, 6, 0, 6),
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Checkers"].Instance,
                CornerRadius = UDimNew(0, 6)
            }) 

            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 2),
                Size = UDim2New(0, 10, 0, 10),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                Color = FromRGB(255, 255, 255),
                Thickness = 2.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }) 

            Instances:Create("UICorner", {
                Parent = Items["AlphaDragger"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Items["Hue"] = Instances:Create("ImageButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, -40),
                Size = UDim2New(1, 0, 0, 14),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIGradient", {
                Parent = Items["Hue"].Instance,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Hue"].Instance,
                CornerRadius = UDimNew(0, 4)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 15, 0, 2),
                Size = UDim2New(0, 10, 0, 10),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Color = FromRGB(255, 255, 255),
                Thickness = 2.4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }) 

            Instances:Create("UICorner", {
                Parent = Items["HueDragger"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["ColorpickerWindow"].Instance,
                PaddingTop = UDimNew(0, 8),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            }) 

            Items["RainbowToggle"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["RainbowToggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = "Rainbow",
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["RainbowToggle"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 15, 0, 15),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["Indicator"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Check"] = Instances:Create("ImageLabel", {
                Parent = Items["Indicator"].Instance,
                ImageColor3 = FromRGB(0, 0, 0),
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(1, -1, 1, -3),
                ImageTransparency = 0,
                Visible = false,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://135757045959142",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, -1, 0.5, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["Indicator"].Instance,
                ImageTransparency = 1,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = 4,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.6000000238418579,
                ImageColor3 = FromRGB(181, 116, 16),
                Size = UDim2New(1, 15, 1, 15),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Shadow"]:AddToTheme({ImageColor3 = "Accent"})
        end

        local SlidingPalette = false 
        local SlidingHue = false 
        local SlidingAlpha = false

        local Debounce = false

        local OnRainbowToggled

        local IsRainbow = false

        local SetRainbow = function(Bool)
            IsRainbow = Bool

            if OnRainbowToggled then 
                OnRainbowToggled(IsRainbow)
            end

            Library.Flags[Data.Flag .. "RainbowToggle"] = IsRainbow

            if IsRainbow then 
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Light Accent"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
                Items["Check"].Instance.Visible = true 
                Items["Shadow"]:Tween(nil, {ImageTransparency = 0.5})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme["Light Accent"]})
            else
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Border"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["Text"]:Tween(nil, {TextTransparency = 0.5})
                Items["Check"].Instance.Visible = false 
                Items["Shadow"]:Tween(nil, {ImageTransparency = 1})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Border})
            end
        end

        Items["RainbowToggle"]:Connect("MouseButton1Down", function()
            SetRainbow(not IsRainbow)
        end)

        Library.SetFlags[Data.Flag .. "RainbowToggle"] = SetRainbow

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then 
                return 
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            self.Saturation = ValueX
            self.Value = ValueY
            
            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.95)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.91)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            self:Update()
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then 
                return 
            end

            local ValueX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 1)
            
            self.Hue = ValueX

            local SlideX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 0.95)

            Items["HueDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 2)})
            self:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then
                return 
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
            
            self.Alpha = ValueX

            local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.95)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 2)})
            self:Update(true)
        end

        function Colorpicker:Update(IsFromAlpha)
            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            Items["ColorpickerButton"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
            Items["Palette"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = FromHSV(self.Hue, 1, 1)})

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Color, self.Alpha)
            end
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then 
                Color = FromRGB(Color[1], Color[2], Color[3])
                Alpha = Color[4]
            elseif type(Color) == "string" then 
                Color = FromHex(Color)
            end

            self.Hue, self.Saturation, self.Value = Color:ToHSV()
            self.Alpha = Alpha or 0

            local ColorPositionX = MathClamp(1 - self.Saturation, 0, 0.95)
            local ColorPositionY = MathClamp(1 - self.Value, 0, 0.91)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(ColorPositionX, 0, ColorPositionY, 0)})

            local HuePositionX = MathClamp(self.Hue, 0, 0.95)

            Items["HueDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(HuePositionX, 0, 0, 2)})

            local AlphaPositionX = MathClamp(self.Alpha, 0, 0.95)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 2)})
            self:Update()
        end

        function Colorpicker:Get()
            return Colorpicker.Color, Colorpicker.Alpha
        end

        function Colorpicker:SetVisibility(Bool)
            Items["ColorpickerButton"].Instance.Visible = Bool
        end

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + 25, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + 15)
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if Colorpicker.IsOpen then 
                    if not StringFind(Value.ClassName, "UI") then
                        Value.ZIndex = 1001
                    end
                else
                    if not StringFind(Value.ClassName, "UI") then
                        Value.ZIndex = 1
                    end
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Colorpicker.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Colorpicker.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = Bool
            end)
        end

        local OldColor = Colorpicker.Color

        OnRainbowToggled = function(Bool)
            if Bool then
                OldColor = Colorpicker.Color
                Library:Thread(function()
                    while task.wait() do 
                        local RainbowHue = MathAbs(MathSin(tick() * 0.32))
                        local Color = FromHSV(RainbowHue, 1, 1)

                        Colorpicker:Set(Color, Colorpicker.Alpha)

                        if not IsRainbow then
                            Colorpicker:Set(OldColor, Colorpicker.Alpha)
                            break
                        end
                    end
                end)
            end
        end

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false
                    end
                end)
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingHue = true
                Colorpicker:SlideHue(Input)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false
                    end
                end)
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                SlidingAlpha = true
                Colorpicker:SlideAlpha(Input)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingAlpha = false
                    end
                end)
            end
        end)

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                if SlidingPalette then 
                    Colorpicker:SlidePalette(Input)
                elseif SlidingHue then 
                    Colorpicker:SlideHue(Input)
                elseif SlidingAlpha then 
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and Colorpicker.IsOpen and not Debounce and not Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Data.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        return Colorpicker
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = {
            Logo = Data.Logo or Data.logo or "123748867365417",
            Size = Data.Size or Data.size or UDim2New(0, 681, 0, 480),
            FadeSpeed = Data.FadeSpeed or Data.fadespeed or 0.2,
            PagePadding = Data.PagePadding or Data.pagepadding or 19,

            Pages = { },
            SubPages = { },
            Items = { },

            IsOpen = false
        }

        local Items = { } do
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 0),
                Name = "\0",
                Position = UDim2New(0, Camera.ViewportSize.X / 3.5, 0, Camera.ViewportSize.Y / 3.5),
                Size = Window.Size,
                Visible = false,
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(14, 14, 14)
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})

            Items["MainFrame"]:MakeDraggable()
            Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["MainFrame"].Instance,
                ImageColor3 = FromRGB(0, 0, 0),
                ImageTransparency = 0.5799999833106995,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = -1,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.6000000238418579,
                Name = "\0",
                Size = UDim2New(1, 55, 1, 55),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Sidebar"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 70, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Logo"] = Instances:Create("ImageLabel", {
                Parent = Items["Sidebar"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 45, 0, 45),
                AnchorPoint = Vector2New(0.5, 0),
                Image = "rbxassetid://" .. Window.Logo,
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0, 12),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Logo"]:AddToTheme({ImageColor3 = "Image"})

            Items["Shadow2"] = Instances:Create("ImageLabel", {
                Parent = Items["Logo"].Instance,
                ScaleType = Enum.ScaleType.Slice,
                Name = "\0",
                ImageTransparency = 0.7200000286102295,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 5, 1, 5),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.8999999761581421,
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147))
            })  Items["Shadow2"]:AddToTheme({ImageColor3 = "Image"})

            Instances:Create("Frame", {
                Parent = Items["Sidebar"].Instance,
                Size = UDim2New(0, 1, 1, 0),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(24, 24, 24)
            }):AddToTheme({BackgroundColor3 = "Border"})

            Items["Pages"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Sidebar"].Instance,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                ScrollBarImageTransparency = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = Library.Theme.Accent,
                MidImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BottomImage = Library:GetImage("Scrollbar"),
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 77),
                Size = UDim2New(1, 0, 1, -103),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Pages"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                Padding = UDimNew(0, Window.PagePadding),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Instances:Create("UICorner", {
                Parent = Items["MainFrame"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Avatar"] = Instances:Create("ImageLabel", {
                Parent = Items["Sidebar"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 34, 0, 34),
                AnchorPoint = Vector2New(0.5, 1),
                Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 1, -18),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Avatar"].Instance.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

            Instances:Create("UICorner", {
                Parent = Items["Avatar"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Avatar"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 71, 0, 0),
                Size = UDim2New(1, -71, 1, 0),
                ZIndex = 2,
                ClipsDescendants = true,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
        end

        local Debounce = false 

        function Window:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Window.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["MainFrame"].Instance.Visible = true
            end

            local Descendants = Items["MainFrame"].Instance:GetDescendants()
            TableInsert(Descendants, Items["MainFrame"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["MainFrame"].Instance.Visible = Bool
            end)
        end

        Library:Connect(UserInputService.InputBegan, function(Input, Gpe)
            if Gpe then 
                return 
            end

            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        Window.Items = Items

        Window:SetOpen(true)
        return setmetatable(Window, Library)
    end

    Library.Seperator = function(self)
        return Instances:Create("Frame", {
            Parent = self.Items["Pages"].Instance,
            Name = "\0",
            Size = UDim2New(0, 40, 0, 1),
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(24, 24, 24)
        }):AddToTheme({BackgroundColor3 = "Border"})
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Icon = Data.Icon or Data.icon or "109391165290124",
            Search = Data.Search or Data.search or false,

            Items = { },

            Active = false,
        }

        local Items = { } do
            Items["Inactive"] = Instances:Create("ImageButton", {
                Parent = Page.Window.Items["Pages"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                Name = "\0",
                Image = "rbxassetid://" .. Page.Icon,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 25, 0, 25),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Inactive"]:AddToTheme({ImageColor3 = "Image"})

            Items["PageContent"] = Instances:Create("Frame", {
                Parent = Page.Window.Items["Inline"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                Visible = false,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["SubPages"] = Instances:Create("Frame", {
                Parent = Items["PageContent"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 15, 0, 15),
                Size = UDim2New(1, -30, 0, 24),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["SubPages"].Instance,
                Padding = UDimNew(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal
            }) 

            Items["Columns"] = Instances:Create("Frame", {
                Parent = Items["PageContent"].Instance,
                Size = UDim2New(1, 0, 1, -55),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 55),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["Columns"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("Frame", {
                Parent = Items["PageContent"].Instance,
                Size = UDim2New(1, 0, 0, 1),
                Name = "\0",
                Position = Page.Search and UDim2New(0, 0, 0, 99) or UDim2New(0, 0, 0, 54),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(24, 24, 24)
            }):AddToTheme({BackgroundColor3 = "Border"})

            if Page.Search then
                Items["SubPages"].Instance.Position = UDim2New(0, 15, 0, 60)
                Items["Columns"].Instance.Position = UDim2New(0, 0, 0, 100)
                Items["Columns"].Instance.Size = UDim2New(1, 0, 1, -100)

                Items["Search"] = Instances:Create("TextBox", {
                    Parent = Items["PageContent"].Instance,
                    FontFace = Library.Font,
                    Active = false,
                    Selectable = false,
                    PlaceholderColor3 = FromRGB(175, 175, 175),
                    ZIndex = 2,
                    TextSize = 14,
                    Size = UDim2New(0, 313, 0, 30),
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Name = "\0",
                    PlaceholderText = "Search",
                    Position = UDim2New(0, 15, 0, 15),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    CursorPosition = -1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(14, 14, 14)
                })  Items["Search"]:AddToTheme({BackgroundColor3 = "Background", TextColor3 = "Text"})

                Instances:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    CornerRadius = UDimNew(0, 4)
                }) 

                Instances:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Color = FromRGB(24, 24, 24),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UIPadding", {
                    Parent = Items["Search"].Instance,
                    PaddingLeft = UDimNew(0, 8)
                }) 
            end
        end

        local Debounce = false 

        function Page:Turn(Bool)
            if Debounce then 
                return 
            end

            Page.Active = true

            Debounce = true 

            if Bool then 
                Items["PageContent"].Instance.Visible = true
                Items["PageContent"].Instance.Parent = Page.Window.Items["Inline"].Instance
                Items["Inactive"]:Tween(nil, {ImageTransparency = 0})
            else
                Items["Inactive"]:Tween(nil, {ImageTransparency = 0.5})
            end

            local Descendants = Items["PageContent"].Instance:GetDescendants()
            TableInsert(Descendants, Items["PageContent"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Page.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Page.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["PageContent"].Instance.Visible = Bool
                Items["PageContent"].Instance.Parent = Bool and Page.Window.Items["Inline"].Instance or Library.UnusedHolder.Instance
                if Page.Search then 
                    Items["Columns"]:Tween(nil, {Position = Bool and UDim2New(0, 0, 0, 100) or UDim2New(0, 0, 1, 0)})
                else
                    Items["Columns"]:Tween(nil, {Position = Bool and UDim2New(0, 0, 0, 55) or UDim2New(0, 0, 1, 0)})
                end
            end)            
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in Page.Window.Pages do
                Value:Turn(Value == Page)
            end
        end)

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        Page.Items = Items

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

    Library.Pages.SubPage = function(self, Data)
        Data = Data or { }

        local SubPage = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "SubPage",

            Items = { },
            SearchItems = { },

            Active = false,
        }

        local Items = { } do 
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = SubPage.Page.Items["SubPages"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = SubPage.Name,
                AutoButtonColor = false,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 100, 1, 0),
                BorderSizePixel = 0,
                ZIndex = 3,
                TextSize = 14,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["Inactive"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Inline"})

            Instances:Create("UICorner", {
                Parent = Items["Inactive"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Border"})

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["Inactive"].Instance,
                Visible = true,
                ImageTransparency = 1,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.6000000238418579,
                ImageColor3 = FromRGB(181, 116, 16),
                Size = UDim2New(1, 30, 1, 30),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Shadow"]:AddToTheme({ImageColor3 = "Accent"})

            Items["PageContent"] = Instances:Create("Frame", {
                Parent = SubPage.Page.Items["Columns"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                Visible = false,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Right"] = Instances:Create("ScrollingFrame", {
                Parent = Items["PageContent"].Instance,
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                AnchorPoint = Vector2New(1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(181, 116, 16),
                MidImage = Library:GetImage("Scrollbar"),
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 2,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(1, -2, 0, 2),
                Size = UDim2New(0.5, -4, 1, -6),
                BottomImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Right"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIPadding", {
                Parent = Items["Right"].Instance,
                PaddingTop = UDimNew(0, 12),
                PaddingBottom = UDimNew(0, 14),
                PaddingRight = UDimNew(0, 14),
                PaddingLeft = UDimNew(0, 7)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Right"].Instance,
                Padding = UDimNew(0, 14),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Items["Left"] = Instances:Create("ScrollingFrame", {
                Parent = Items["PageContent"].Instance,
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(181, 116, 16),
                MidImage = Library:GetImage("Scrollbar"),
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 2,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 2),
                Size = UDim2New(0.5, -4, 1, -6),
                BottomImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Left"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIPadding", {
                Parent = Items["Left"].Instance,
                PaddingTop = UDimNew(0, 12),
                PaddingBottom = UDimNew(0, 14),
                PaddingRight = UDimNew(0, 7),
                PaddingLeft = UDimNew(0, 14)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Left"].Instance,
                Padding = UDimNew(0, 14),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
        end

        local Debounce = false 

        function SubPage:Turn(Bool)
            if Debounce then 
                return 
            end

            SubPage.Active = true

            Debounce = true 

            if Bool then 
                Items["PageContent"].Instance.Visible = true
                Items["Inactive"]:ChangeItemTheme({TextColor3 = "Text", BackgroundColor3 = "Accent"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Light Accent"})

                Items["Inactive"]:Tween(nil, {TextTransparency = 0, BackgroundColor3 = Library.Theme.Accent})
                Items["Shadow"]:Tween(nil, {ImageTransparency = 0.6})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme["Light Accent"]})
            else
                Items["Inactive"]:ChangeItemTheme({TextColor3 = "Text", BackgroundColor3 = "Inline"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Border"})

                Items["Inactive"]:Tween(nil, {TextTransparency = 0.5, BackgroundColor3 = Library.Theme.Inline})
                Items["Shadow"]:Tween(nil, {ImageTransparency = 1})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Border})
            end

            local Descendants = Items["PageContent"].Instance:GetDescendants()
            TableInsert(Descendants, Items["PageContent"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, SubPage.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, SubPage.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["PageContent"].Instance.Visible = Bool
            end)            
        end

        local RenderStepped

        if SubPage.Page.Search then 
            SubPage.Page.Items["Search"]:Connect("Focused", function()
                RenderStepped = RunService.RenderStepped:Connect(function()
                    for Index, Value in SubPage.SearchItems do 
                        local Element = Value.Element
                        local Section = Value.Section

                        if StringFind(StringLower(Element.Instance.Text), StringLower(SubPage.Page.Items["Search"].Instance.Text)) and SubPage.Page.Items["Search"].Instance.Text ~= "" then
                            Element:ChangeItemTheme({TextColor3 = "Accent"})
                            Element:Tween(nil, {TextColor3 = Library.Theme.Accent})
                        else
                            Element:ChangeItemTheme({TextColor3 = "Text"})
                            Element:Tween(nil, {TextColor3 = Library.Theme.Text})
                        end
                    end
                end)
            end)

            SubPage.Page.Items["Search"]:Connect("FocusLost", function()
                RenderStepped:Disconnect()
                RenderStepped = nil
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in SubPage.Window.SubPages do
                Value:Turn(Value == SubPage)
            end
        end)

        if #SubPage.Window.Pages == 0 then 
            SubPage:Turn(true)
        end

        SubPage.Items = Items

        TableInsert(SubPage.Window.SubPages, SubPage)
        return setmetatable(SubPage, Library.Pages)
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = { 
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or "Left",

            Items = { },
        }

        local Items = { } do
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Side:lower() == "left" and Section.Page.Items["Left"].Instance or Section.Page.Items["Right"].Instance,
                BorderSizePixel = 0,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 45),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(14, 14, 14)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Background"})

            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.BoldFont,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 7, 0, 6),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Size = UDim2New(1, 0, 0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 27),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(24, 24, 24)
            }):AddToTheme({BackgroundColor3 = "Border"})

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0, 38),
                Size = UDim2New(1, -20, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 7),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 12)
            }) 

            Instances:Create("UICorner", {
                Parent = Items["Section"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 
        end

        function Section:SetVisibility(Bool)
           Items["Section"].Instance.Visible = Bool 
        end

        Section.Items = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end,

            Value = false,

            Count = 0
        }

        local Items = { } do
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Items["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 15, 0, 15),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["Indicator"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Check"] = Instances:Create("ImageLabel", {
                Parent = Items["Indicator"].Instance,
                ImageColor3 = FromRGB(0, 0, 0),
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(1, -3, 1, -3),
                Visible = false,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://135757045959142",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, -1, 0.5, -1),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["Indicator"].Instance,
                Visible = true,
                ImageTransparency = 1,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = 4,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.6000000238418579,
                ImageColor3 = FromRGB(181, 116, 16),
                Size = UDim2New(1, 15, 1, 15),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Shadow"]:AddToTheme({ImageColor3 = "Accent"})

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = Toggle.Name,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
        end

        function Toggle:Get()
            return Toggle.Value
        end

        function Toggle:Set(Value, IsKeybind)
            if IsKeybind then 
                Value = IsKeybind.Toggled
                Toggle.Value = Value
            else
                Toggle.Value =  Value 
            end

            Library.Flags[Toggle.Flag] = Value 

            if Value then 
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Light Accent"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
                Items["Check"].Instance.Visible = true 
                Items["Shadow"]:Tween(nil, {ImageTransparency = 0.5})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme["Light Accent"]})
            else
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["UIStroke"]:ChangeItemTheme({Color = "Border"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["Text"]:Tween(nil, {TextTransparency = 0.5})
                Items["Check"].Instance.Visible = false
                Items["Shadow"]:Tween(nil, {ImageTransparency = 1})
                Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Border})
            end

            if Toggle.Callback then 
                Library:SafeCall(Toggle.Callback, Value)
            end
        end

        function Toggle:SetVisiblity(Bool)
            Items["Toggle"].Instance.Visible = Bool
        end

        function Toggle:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.new(1, 1, 1),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or 0,

                Parent = Items["Toggle"],
                Count = Toggle.Count,
                IsToggle = true,
            }

            Toggle.Count += 1
            Colorpicker.Count = Toggle.Count

            local SearchData = {
                Name = Toggle.Name,
                Element = Items["Text"],
                Section = Colorpicker.Section
            }

            TableInsert(Colorpicker.Page.SearchItems, SearchData)

            local Extension = Library:CreateColorpicker(Colorpicker)
            return Extension
        end

        function Toggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,

                Key = nil,
                Picking = false,
                Value = "",
                Toggled = false,
                Count = Toggle.Count,
            }

            Toggle.Count += 1
            Keybind.Count = Toggle.Count

            local SubItems = { } do 
                SubItems["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Items["Toggle"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0,
                    Text = "None",
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(1, 0.5),
                    ZIndex = 4,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  SubItems["KeyButton"]:AddToTheme({TextColor3 = "Text"})

                local CalculateCount = function(Index)
                    local MaxButtonsAdded = 5

                    local Column = Index % MaxButtonsAdded
                
                    local ButtonSize = SubItems["KeyButton"].Instance.AbsoluteSize
                    local Spacing = 4
                
                    local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - ButtonSize.X
                
                    SubItems["KeyButton"].Instance.Position = UDim2New(1, Index == 1 and -XPosition - 24 or -XPosition, 0.5, 0)
                end

                CalculateCount(Keybind.Count)
                
                function Keybind:Get()
                    return Keybind.Toggled, Keybind.Key
                end

                function Keybind:SetVisibility(Bool)
                    SubItems["KeyButton"].Instance.Visible = Bool
                end

                function Keybind:Set(Key)
                    if StringFind(tostring(Key), "Enum") then 
                        Keybind.Key = tostring(Key)

                        Key = Key.Name == "Backspace" and "None" or Key.Name

                        local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                        local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                        Keybind.Value = TextToDisplay
                        SubItems["KeyButton"].Instance.Text = TextToDisplay

                        Library.Flags[Keybind.Flag] = {
                            Mode = Keybind.Mode,
                            Key = Keybind.Key,
                            Toggled = Keybind.Toggled
                        }

                        if Keybind.Callback then 
                            Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                        end

                    elseif TableFind({"Hold", "Toggle", "Always"}, Key) then 
                        Keybind.Mode = Key

                        Keybind:SetMode(Keybind.Mode)

                        if Keybind.Callback then 
                            Library:SafeCall(Keybind.Callback, Keybind.Toggled)
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

                        local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                        local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                        TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                        Keybind.Value = TextToDisplay
                        SubItems["KeyButton"].Instance.Text = TextToDisplay

                        if Keybind.Callback then 
                            Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                        end
                    end

                    Keybind.Picking = false 
                    SubItems["KeyButton"]:ChangeItemTheme({TextColor3 = "Text"})
                    SubItems["KeyButton"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end

                function Keybind:SetMode(Mode)
                    if Keybind.Mode == "Always" then 
                        Keybind.Toggled = true
                    else
                        Keybind.Toggled = false
                    end

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Keybind.Callback then 
                        Library:SafeCall(Keybind.Callback, Keybind.Toggled)
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

                    Toggle:Set(nil, Keybind)

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Keybind.Callback then 
                        Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                    end 
                end

                SubItems["KeyButton"]:Connect("MouseButton1Click", function()
                    if Keybind.Picking then 
                        return
                    end

                    Keybind.Picking = true

                    SubItems["KeyButton"]:ChangeItemTheme({TextColor3 = "Accent"})
                    SubItems["KeyButton"]:Tween(nil, {TextColor3 = Library.Theme.Accent})

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

                Library:Connect(UserInputService.InputBegan, function(Input)
                    if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Value == "None" then 
                            return 
                        end
                        
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        end
                    end
                end)

                Library:Connect(UserInputService.InputEnded, function(Input)
                    if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then 
                        if Keybind.Value == "None" then 
                            return 
                        end

                        if Keybind.Mode == "Hold" then 
                            Keybind:Press(false)
                        end
                    end
                end)

                if Keybind.Default then
                    Keybind:Set({Key = Keybind.Default, Mode = Keybind.Mode or "Toggle"})
                end

                Library.SetFlags[Keybind.Flag] = function(Value)
                    Keybind:Set(Value)
                end

                return Keybind
            end
        end

        local SearchData = {
            Name = Toggle.Name,
            Element = Items["Text"],
            Section = Toggle.Section,
        }

        TableInsert(Toggle.Page.SearchItems, SearchData)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Toggle:Set(not Toggle.Value)
        end)

        if Toggle.Default then 
            Toggle:Set(Toggle.Default)
        end

        Library.SetFlags[Toggle.Flag] = function(Value)
            Toggle:Set(Value)
        end

        return Toggle
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Button",
            Callback = Data.Callback or Data.callback or function() end
        }

        local Items = { } do
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Button.Section.Items["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 20),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})

            Instances:Create("UICorner", {
                Parent = Items["Button"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Button"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Border"})
        end

        function Button:Press()
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
            Items["UIStroke"]:ChangeItemTheme({Color = "Light Accent"})

            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
            Items["UIStroke"]:Tween(nil, {Color = Library.Theme["Light Accent"]})

            task.wait(0.1)

            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})
            Items["UIStroke"]:ChangeItemTheme({Color = "Border"})

            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            Items["UIStroke"]:Tween(nil, {Color = Library.Theme.Border})

            Library:SafeCall(Button.Callback)
        end

        function Button:SetVisibility(Bool)
            Items["Button"].Instance.Visible = Bool
        end

        function Button:SubButton(Data)
            local SubButton = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local ButtonHolder = Instances:Create("Frame", {
                Parent = Button.Section.Items["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Button"].Instance.Parent = ButtonHolder.Instance
            Items["Button"].Instance.Size =  UDim2New(0.48, 1, 0, 20)

            local SubItems = { } do
                SubItems["SubButton"] = Instances:Create("TextButton", {
                    Parent = ButtonHolder.Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = SubButton.Name,
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0,
                    Name = "\0",
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0.48, 1, 0, 20),
                    ZIndex = 4,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(11, 11, 11)
                })  SubItems["SubButton"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})

                Instances:Create("UICorner", {
                    Parent = SubItems["SubButton"].Instance,
                    CornerRadius = UDimNew(0, 3)
                }) 

                SubItems["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = SubItems["SubButton"].Instance,
                    Color = FromRGB(24, 24, 24),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }) 
            end

            function SubButton:Press()
                SubItems["SubButton"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                SubItems["UIStroke"]:ChangeItemTheme({Color = "Light Accent"})

                SubItems["SubButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                SubItems["UIStroke"]:Tween(nil, {Color = Library.Theme["Light Accent"]})

                task.wait(0.1)

                SubItems["SubButton"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                SubItems["UIStroke"]:ChangeItemTheme({Color = "Border"})

                SubItems["SubButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                SubItems["UIStroke"]:Tween(nil, {Color = Library.Theme.Border})

                Library:SafeCall(SubButton.Callback)
            end

            function SubButton:SetVisibility(Bool)
                SubItems["SubButton"].Instance.Visible = Bool
            end

            local SearchData = {
                Name = SubButton.Name,
                Element = SubItems["SubButton"],
                Section = SubButton.Section
            }

            TableInsert(SubButton.Page.SearchItems, SearchData)

            SubItems["SubButton"]:Connect("MouseButton1Down", function()
                SubButton:Press()
            end)
            
            return SubButton
        end

        local SearchData = {
            Name = Button.Name,
            Element = Items["Button"],
            Section = Button.Section
        }

        TableInsert(Button.Page.SearchItems, SearchData)

        Items["Button"]:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return Button
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }

        local Slider = { 
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Default = Data.Default or Data.default or 0,
            Max = Data.Max or Data.max or 100,
            Suffix = Data.Suffix or Data.suffix or "",
            Decimals = Data.Decimals or Data.decimals or 1,
            Callback = Data.Callback or Data.callback or function() end,

            Value = 0,
            Sliding = false
        }

        local Items = { } do
            Items["Slider"] = Instances:Create("Frame", {
                Parent = Slider.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 28),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Slider.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "0.873",
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

            Items["RealSlider"] = Instances:Create("Frame", {
                Parent = Items["Slider"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})

            Items["Accent"] = Instances:Create("Frame", {
                Parent = Items["RealSlider"].Instance,
                Name = "\0",
                Size = UDim2New(0.6729999780654907, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(181, 116, 16)
            })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["Shadow"] = Instances:Create("ImageLabel", {
                Parent = Items["Accent"].Instance,
                ImageColor3 = FromRGB(181, 116, 16),
                ImageTransparency = 0.6800000071525574,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = 4,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.6000000238418579,
                Name = "\0",
                Size = UDim2New(1, 15, 1, 15),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Shadow"]:AddToTheme({ImageColor3 = "Accent"})

            Items["Drag"] = Instances:Create("TextButton", {
                Parent = Items["Accent"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                Name = "\0",
                Position = UDim2New(1, -8, 0.5, 0),
                Size = UDim2New(0, 15, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(181, 116, 16)
            })  Items["Drag"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["Shadow2"] = Instances:Create("ImageLabel", {
                Parent = Items["Drag"].Instance,
                ImageColor3 = FromRGB(181, 116, 16),
                ImageTransparency = 0.6800000071525574,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://112971167999062",
                ZIndex = 4,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                SliceScale = 0.6000000238418579,
                Name = "\0",
                Size = UDim2New(1, 15, 1, 15),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Shadow2"]:AddToTheme({ImageColor3 = "Accent"})

            Instances:Create("UICorner", {
                Parent = Items["Drag"].Instance,
                CornerRadius = UDimNew(1, 0)
            }) 
        end

        function Slider:Get()
            return Slider.Value
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)

            Library.Flags[Slider.Flag] = Slider.Value

            Items["Accent"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
            Items["Value"].Instance.Text = StringFormat("%s%s", tostring(Slider.Value), Slider.Suffix)

            if Slider.Callback then 
                Library:SafeCall(Slider.Callback, Slider.Value)
            end
        end

        function Slider:SetVisibility(Bool)
            Items["Slider"].Instance.Visible = Bool
        end

        local SearchData = {
            Name = Slider.Name,
            Element = Items["Text"],
            Section = Slider.Section,
        }
        
        TableInsert(Slider.Page.SearchItems, SearchData)

        Items["Drag"]:Connect("MouseButton1Down", function(Input)
            Slider.Sliding = true 

            local SizeX = ((UserInputService:GetMouseLocation().X - 15) - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
            local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

            Slider:Set(MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max))
        end)

        Items["Drag"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Slider.Sliding = false 
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement and Slider.Sliding then
                local SizeX = ((Input.Position.X - 1) - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max))
            end
        end)

        if Slider.Default then
            Slider:Set(Slider.Default)
        end

        Library.SetFlags[Slider.Flag] = function(Value)
            Slider:Set(Value)
        end

        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { "One", "Two", "Three" },
            Default = Data.Default or Data.default or nil,
            MaxSize = Data.MaxSize or Data.maxsize or 75,
            Callback = Data.Callback or Data.callback or function() end,
            Multi = Data.Multi or Data.multi or false,

            Value = { },
            IsOpen = false,
            Options = { },
        }

        local Items = { } do
            Items["Dropdown"] = Instances:Create("Frame", {
                Parent = Dropdown.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 42),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Dropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["OptionHolder"] = Instances:Create("TextButton", {
                Parent = Items["Dropdown"].Instance,
                AutoButtonColor = false,
                Visible = false,
                Text = "",
                Size = UDim2New(1, 0, 0, Dropdown.MaxSize),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 25,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Holder"] = Instances:Create("ScrollingFrame", {
                Parent = Items["OptionHolder"].Instance,
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 25,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(181, 116, 16),
                MidImage = Library:GetImage("Scrollbar"),
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 2,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 5, 0, 5),
                Size = UDim2New(1, -10, 1, -10),
                BottomImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Holder"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIListLayout", {
                Parent = Items["Holder"].Instance,
                Padding = UDimNew(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Items["RealDropdown"] = Instances:Create("TextButton", {
                Parent = Items["Dropdown"].Instance,
                AutoButtonColor = false,
                Text = "",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 21),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIStroke", {
                Parent = Items["RealDropdown"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["RealDropdown"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(255, 255, 255),
                Text = "--",
                Name = "\0",
                TextTruncate = Enum.TextTruncate.AtEnd,
                Size = UDim2New(1, -35, 1, 0),
                Position = UDim2New(0, 4, 0, 1),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

            Items["OpenIcon"] = Instances:Create("ImageLabel", {
                Parent = Items["RealDropdown"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 10, 0, 10),
                AnchorPoint = Vector2New(1, 0.5),
                Image = "rbxassetid://86523506890491",
                BackgroundTransparency = 1,
                Position = UDim2New(1, -6, 0.5, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["OpenIcon"]:AddToTheme({ImageColor3 = "Image"})
        end

        local Debounce = false

        function Dropdown:Set(Option)
            if Data.Multi then
                if type(Option) ~= "table" then 
                    return
                end

                Dropdown.Value = Option
                Library.Flags[Dropdown.Flag] = Dropdown.Value

                for Index, Value in Option do 
                    local OptionData = Dropdown.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end

                Items["Value"].Instance.Text = TableConcat(Option, ", ")
            else
                local OptionData = Dropdown.Options[Option]

                if not OptionData then 
                    return 
                end

                OptionData.Selected = true  
                OptionData:Toggle("Active")

                Dropdown.Value = OptionData.Name
                Library.Flags[Dropdown.Flag] = Dropdown.Value

                for Index, Value in Dropdown.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end

                Items["Value"].Instance.Text = Dropdown.Value
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Dropdown.Value)
            end
        end

        function Dropdown:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Dropdown.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["OptionHolder"].Instance.Visible = true
            end

            local Descendants = Items["OptionHolder"].Instance:GetDescendants()
            TableInsert(Descendants, Items["OptionHolder"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Dropdown.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool,  Dropdown.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["OptionHolder"].Instance.Visible = Bool
            end)
        end

        function Dropdown:Remove(Option)
            if Dropdown.Options[Option] then
                Dropdown.Options[Option].Button:Clean()
            end

            Dropdown.Options[Option] = nil
        end

        function Dropdown:Refresh(List)
            for Index, Value in Dropdown.Options do 
                Dropdown:Remove(Value.Name)
            end

            for Index, Value in List do 
                Dropdown:Add(Value)
            end
        end

        function Dropdown:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["Holder"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = Option,
                Name = "\0",
                AutoButtonColor = false,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 25,
                TextSize = 14,
                BackgroundColor3 = FromRGB(14, 14, 14)
            })  OptionButton:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Background"})

            Instances:Create("UICorner", {
                Parent = OptionButton.Instance,
                CornerRadius = UDimNew(0, 4)
            }) 

            local UIPadding = Instances:Create("UIPadding", {
                Parent = OptionButton.Instance,
                PaddingLeft = UDimNew(0, 7)
            }) 
        
            local OptionData = {
                Name = Option,
                Button = OptionButton,
                Padding = UIPadding,
                Selected = false
            }

            function OptionData:Toggle(Status)
                if Status == "Active" then
                    OptionData.Button:ChangeItemTheme({TextColor3 = "Accent"})
                    OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Accent, BackgroundTransparency = 0, TextTransparency = 0})
                    UIPadding:Tween(nil, {PaddingLeft = UDimNew(0, 12)})
                else
                    OptionData.Button:ChangeItemTheme({TextColor3 = "Text"})
                    OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, TextTransparency = 0.5})
                    UIPadding:Tween(nil, {PaddingLeft = UDimNew(0, 7)})
                end
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Dropdown.Multi then 
                    local Index = TableFind(Dropdown.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Dropdown.Value, Index)
                    else
                        TableInsert(Dropdown.Value, OptionData.Name)
                    end

                    Library.Flags[Dropdown.Flag] = Dropdown.Value

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                    Items["Value"].Instance.Text = TextFormat
                else
                    if OptionData.Selected then
                        Dropdown.Value = OptionData.Name

                        OptionData:Toggle("Active")
                        Items["Value"].Instance.Text = OptionData.Name

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Dropdown.Value = nil

                        OptionData:Toggle("Inactive")
                        Items["Value"].Instance.Text = "--"

                        Library.Flags[Dropdown.Flag] = Dropdown.Value
                    end
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Dropdown.Value)
                end
            end

            OptionData.Button:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Dropdown.Options[Option] = OptionData
            return OptionData
        end

        function Dropdown:SetVisibility(Bool)
            Items["Dropdown"].Instance.Visible = Bool
        end
        
        local SearchData = {
            Name = Dropdown.Name,
            Element = Items["Text"],
            Section = Dropdown.Section
        }

        TableInsert(Dropdown.Page.SearchItems, SearchData)

        Items["RealDropdown"]:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and Dropdown.IsOpen and not Debounce and not Library:IsMouseOverFrame(Items["OptionHolder"]) then
                Dropdown:SetOpen(false)
            end
        end)

        for Index, Value in Dropdown.Items do 
            Dropdown:Add(Value)
        end

        if Dropdown.Default then
            Dropdown:Set(Dropdown.Default)
        end

        Library.SetFlags[Dropdown.Flag] = function(Value)
            Dropdown:Set(Value)
        end

        return Dropdown
    end

    Library.Sections.Label = function(self, Text, Alignment)
        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Text or "Label",
            Alignment = Alignment or "Left",

            Count = 0
        }
        
        local Items = { } do
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 15),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
        end

        function Label:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.new(1, 1, 1),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or 0,

                Parent = Items["Label"],
                Count = Label.Count
            }

            Label.Count += 1
            Colorpicker.Count = Label.Count

            local SearchData = {
                Name = Label.Name,
                Element = Items["Text"],
                Section = Colorpicker.Section
            }

            TableInsert(Colorpicker.Page.SearchItems, SearchData)

            local Extension = Library:CreateColorpicker(Colorpicker)
            return Extension
        end

        return Label
    end

    Library.Sections.Keybind = function(self, Data)
        Data = Data or { }

        local Keybind = { 
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Keybind",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
            Callback = Data.Callback or Data.callback or function() end,
            Mode = Data.Mode or Data.mode or "Toggle",

            Key = nil,
            Value = "",
            Toggled = false,
            Picking = false
        }

        Library.Flags[Keybind.Flag] = { }

        local Items = { } do
            Items["Keybind"] = Instances:Create("Frame", {
                Parent = Keybind.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 42),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Keybind"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Keybind.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["RealKeybind"] = Instances:Create("TextButton", {
                Parent = Items["Keybind"].Instance,
                AutoButtonColor = false,
                Text = "",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 21),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["RealKeybind"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIStroke", {
                Parent = Items["RealKeybind"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UICorner", {
                Parent = Items["RealKeybind"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealKeybind"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(255, 255, 255),
                Text = "None",
                Name = "\0",
                BorderSizePixel = 0,
                Size = UDim2New(1, -16, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0, 1),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
        end

        function Keybind:Get()
            return Keybind.Toggled, Keybind.Key
        end

        function Keybind:SetVisibility(Bool)
            Items["Keybind"].Instance.Visible = Bool
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["Value"].Instance.Text = TextToDisplay

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                end

            elseif TableFind({"Hold", "Toggle", "Always"}, Key) then 
                Keybind.Mode = Key

                Keybind:SetMode(Keybind.Mode)

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
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

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["Value"].Instance.Text = TextToDisplay

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                end
            end

            Keybind.Picking = false 
            Items["Value"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Value"]:Tween(nil, {TextColor3 = Library.Theme.Text})
        end

        function Keybind:SetMode(Mode)
            if Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            else
                Keybind.Toggled = false
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Keybind.Callback then 
                Library:SafeCall(Keybind.Callback, Keybind.Toggled)
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

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Keybind.Callback then 
                Library:SafeCall(Keybind.Callback, Keybind.Toggled)
            end 
        end

        local SearchData = {
            Name = Keybind.Name,
            Element = Items["Text"],
            Section = Keybind.Section
        }

        TableInsert(Keybind.Page.SearchItems, SearchData)

        Items["RealKeybind"]:Connect("MouseButton1Click", function()
            if Keybind.Picking then 
                return
            end

            Keybind.Picking = true

            Items["Value"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Value"]:Tween(nil, {TextColor3 = Library.Theme.Accent})

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

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Value == "None" then 
                    return 
                end
                
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                end
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then 
                if Keybind.Value == "None" then 
                    return 
                end

                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                end
            end
        end)

        if Keybind.Default then
            Keybind:Set({Key = Keybind.Default, Mode = Keybind.Mode or "Toggle"})
        end

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or "",
            Callback = Data.Callback or Data.callback or function() end,
            Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",

            Value = ""
        }

        local Items = { } do 
            Items["Textbox"] = Instances:Create("Frame", {
                Parent = Textbox.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 42),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Textbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 4,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Input"] = Instances:Create("TextBox", {
                Parent = Items["Textbox"].Instance,
                FontFace = Library.Font,
                BorderSizePixel = 0,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                ZIndex = 4,
                Size = UDim2New(1, 0, 0, 21),
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Name = "\0",
                PlaceholderColor3 = FromRGB(175, 175, 175),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Textbox.Placeholder,
                TextSize = 14,
                BackgroundColor3 = FromRGB(11, 11, 11)
            })  Items["Input"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element"})

            Instances:Create("UICorner", {
                Parent = Items["Input"].Instance,
                CornerRadius = UDimNew(0, 3)
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Input"].Instance,
                Color = FromRGB(24, 24, 24),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIPadding", {
                Parent = Items["Input"].Instance,
                PaddingTop = UDimNew(0, 1),
                PaddingLeft = UDimNew(0, 4)
            }) 
        end

        function Textbox:Get()
            return Textbox.Value
        end

        function Textbox:Set(Value)
            Items["Input"].Instance.Text = Value

            Textbox.Value = Value

            Library.Flags[Textbox.Flag] = Value

            if Textbox.Callback then
                Library:SafeCall(Textbox.Callback, Textbox.Value)
            end
        end

        function Textbox:SetVisibility(Bool)
            Items["Textbox"].Instance.Visible = Bool
        end

        local SearchData = {
            Name = Textbox.Name,
            Element = Items["Text"],
            Section = Textbox.Section,
        }

        TableInsert(Textbox.Page.SearchItems, SearchData)

        Items["Input"]:Connect("FocusLost", function()
            Textbox:Set(Items["Input"].Instance.Text)
        end)

        if Textbox.Default then
            Textbox:Set(Textbox.Default)
        end

        Library.SetFlags[Textbox.Flag] = function(Value)
            Textbox:Set(Value)
        end

        return Textbox
    end
end

getgenv().Library = Library
return Library