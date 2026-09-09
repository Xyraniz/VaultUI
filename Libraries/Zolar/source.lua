--[=[
    Zolar UI Library
    Preserved from the supplied library source and formatted for VaultUI.
    Public entry point:
        local Zolar = loadstring(game:HttpGet(URL))()
        local window = Zolar:Window({ Name = "My Hub" })

    API: Window, Tab, SubTab, Section, controls, notifications,
    themes, configs, and watermark.
]=]

if getgenv().Zolar and getgenv().Zolar.Unload then
    getgenv().Zolar:Unload()
end

local Library = { } do
    local cloneref = cloneref or function(Object)
        return Object
    end

    local Players = cloneref(game:GetService("Players"))
    local UserInputService = cloneref(game:GetService("UserInputService"))
    local RunService = cloneref(game:GetService("RunService"))
    local TweenService = cloneref(game:GetService("TweenService"))
    local HttpService = cloneref(game:GetService("HttpService"))
    local GuiService = cloneref(game:GetService("GuiService"))
    local TextService = cloneref(game:GetService("TextService"))
    local StatsService = cloneref(game:GetService("Stats"))
    local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
    local ContentProvider = cloneref(game:GetService("ContentProvider"))

    local LocalPlayer = Players.LocalPlayer
    local GuiInset = GuiService:GetGuiInset().Y
    local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

    local GetHui = gethui or function()
        return cloneref(game:GetService("CoreGui"))
    end

    Library.Directory = "Zolar"
    Library.ConfigFolder = "Zolar/Configs"
    Library.AssetsFolder = "Zolar/Assets"

    if isfolder then
        for _, Folder in { Library.Directory, Library.ConfigFolder, Library.AssetsFolder } do
            if not isfolder(Folder) then
                makefolder(Folder)
            end
        end
    end

    local UiFont
    local UiFontBold

    local CustomFont = { } do
        local FontMagics = {
            "\0\1\0\0",
            "OTTO",
            "true",
            "ttcf",
            "wOFF"
        }

        local function LooksLikeFont(Body)
            if type(Body) ~= "string" or #Body < 4096 then
                return false
            end

            local Head = string.sub(Body, 1, 4)

            for _, Magic in FontMagics do
                if Head == Magic then
                    return true
                end
            end

            return false
        end

        function CustomFont:New(Name, Weight, Style, Data)
            local JsonPath = Library.AssetsFolder .. "/" .. Name .. ".json"
            local FontPath = Library.AssetsFolder .. "/" .. Name .. ".ttf"

            if isfile(FontPath) and not LooksLikeFont(readfile(FontPath)) then
                pcall(delfile, FontPath)
            end

            if not isfile(FontPath) then
                local Body = game:HttpGet(Data.Url)

                if not LooksLikeFont(Body) then
                    return nil
                end

                writefile(FontPath, Body)
            end

            local FontData = {
                name = Name,
                faces = {
                    {
                        name = "Regular",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(FontPath)
                    }
                }
            }

            writefile(JsonPath, HttpService:JSONEncode(FontData))

            local Asset = getcustomasset(JsonPath)
            return Font.new(Asset, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end

        local MainOk, MainFont = pcall(function()
            return CustomFont:New("Inter", 400, "normal", {
                Url = "https://github.com/Da7mu/font/raw/refs/heads/main/Inter%20Medium%20500.ttf"
            })
        end)

        if not MainOk then warn(MainFont) end

        UiFont = (MainOk and MainFont) or Font.fromEnum(Enum.Font.GothamMedium)
        UiFontBold = UiFont
    end

    Library.Font = UiFont
    Library.TitleFont = UiFontBold

    local IconPack

    pcall(function()
        local Url = "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
        IconPack = loadstring(game:HttpGetAsync(Url))()
        IconPack.SetIconsType("lucide")
    end)

    local function ResolveIcon(Icon)
        if type(Icon) == "number" then
            return "rbxassetid://" .. Icon
        end

        if type(Icon) ~= "string" then
            return "rbxassetid://0"
        end

        if string.match(Icon, "^rbxassetid://") or string.match(Icon, "^rbxasset://") then
            return Icon
        end

        if string.match(Icon, "^%d+$") then
            return "rbxassetid://" .. Icon
        end

        if IconPack then
            local Ok, Result = pcall(function()
                return IconPack.GetIcon(Icon)
            end)

            if Ok and Result and Result ~= "rbxassetid://0" then
                return Result
            end
        end

        return "rbxassetid://0"
    end

    local function ToVector2(Value)
        if typeof(Value) == "Vector2" then
            return Value
        end

        if type(Value) == "table" then
            return Vector2.new(Value[1] or Value.X or 0, Value[2] or Value.Y or 0)
        end

        return Vector2.new(0, 0)
    end

    local function ApplyIcon(Object, Icon)
        if not Icon then return end

        local Image, Offset, Size = ResolveIcon(Icon)

        Object.Image = Image
        Object.ImageRectOffset = ToVector2(Offset)
        Object.ImageRectSize = ToVector2(Size)
    end

    local function MeasureText(Text, Size, Width, FontFace)
        local Ok, Bounds = pcall(function()
            return TextService:GetTextBoundsAsync({
                Text = Text,
                Font = FontFace or UiFont,
                Size = Size,
                Width = Width
            })
        end)

        if Ok and Bounds then
            return Bounds
        end

        local Estimate = math.min(#Text * Size * 0.52, Width)
        return Vector2.new(Estimate, Size * 1.25)
    end

    Library.__index = Library
    Library.Version = "1.1"
    Library.WindowWidth = 716
    Library.WindowHeight = 540

    Library.Theme = {
        Background = Color3.fromRGB(20, 22, 26),
        Section = Color3.fromRGB(23, 26, 30),
        Element = Color3.fromRGB(27, 31, 35),
        Light = Color3.fromRGB(34, 39, 44),
        Hover = Color3.fromRGB(38, 43, 49),
        Line = Color3.fromRGB(27, 31, 35),
        Text = Color3.fromRGB(255, 255, 255),
        DimText = Color3.fromRGB(120, 120, 120),
        DimIcon = Color3.fromRGB(120, 120, 120),
        Accent = Color3.fromRGB(179, 165, 255)
    }

    Library.AccentPresets = {
        Color3.fromRGB(179, 165, 255),
        Color3.fromRGB(120, 132, 255),
        Color3.fromRGB(96, 170, 255),
        Color3.fromRGB(72, 214, 168),
        Color3.fromRGB(245, 130, 120)
    }

    local function MakePreset(Name, Colors)
        local Preset = {
            Name = Name,
            Swatch = Colors.Accent
        }

        for Key, Value in Colors do
            Preset[Key] = Value
        end

        return Preset
    end

    Library.ThemePresets = {
        MakePreset("Default", Library.Theme),
        MakePreset("Azure", {
            Background = Color3.fromRGB(16, 20, 30),
            Section = Color3.fromRGB(20, 25, 37),
            Element = Color3.fromRGB(25, 31, 46),
            Light = Color3.fromRGB(33, 41, 60),
            Hover = Color3.fromRGB(39, 48, 70),
            Line = Color3.fromRGB(25, 31, 46),
            Text = Color3.fromRGB(233, 239, 250),
            DimText = Color3.fromRGB(110, 120, 142),
            DimIcon = Color3.fromRGB(110, 120, 142),
            Accent = Color3.fromRGB(96, 150, 255)
        }),
        MakePreset("Emerald", {
            Background = Color3.fromRGB(14, 24, 20),
            Section = Color3.fromRGB(18, 30, 25),
            Element = Color3.fromRGB(23, 37, 31),
            Light = Color3.fromRGB(30, 48, 40),
            Hover = Color3.fromRGB(36, 56, 47),
            Line = Color3.fromRGB(23, 37, 31),
            Text = Color3.fromRGB(232, 244, 238),
            DimText = Color3.fromRGB(106, 128, 118),
            DimIcon = Color3.fromRGB(106, 128, 118),
            Accent = Color3.fromRGB(76, 214, 148)
        }),
        MakePreset("Ocean", {
            Background = Color3.fromRGB(14, 23, 28),
            Section = Color3.fromRGB(18, 28, 34),
            Element = Color3.fromRGB(23, 35, 42),
            Light = Color3.fromRGB(30, 45, 54),
            Hover = Color3.fromRGB(36, 53, 63),
            Line = Color3.fromRGB(23, 35, 42),
            Text = Color3.fromRGB(230, 240, 244),
            DimText = Color3.fromRGB(104, 122, 132),
            DimIcon = Color3.fromRGB(104, 122, 132),
            Accent = Color3.fromRGB(72, 200, 214)
        }),
        MakePreset("Rose", {
            Background = Color3.fromRGB(26, 17, 21),
            Section = Color3.fromRGB(32, 21, 26),
            Element = Color3.fromRGB(39, 26, 32),
            Light = Color3.fromRGB(50, 33, 41),
            Hover = Color3.fromRGB(58, 39, 48),
            Line = Color3.fromRGB(39, 26, 32),
            Text = Color3.fromRGB(245, 234, 238),
            DimText = Color3.fromRGB(132, 110, 118),
            DimIcon = Color3.fromRGB(132, 110, 118),
            Accent = Color3.fromRGB(240, 118, 150)
        })
    }

    Library.ThemeKeys = {
        "Background",
        "Section",
        "Element",
        "Light",
        "Line",
        "Text",
        "DimText"
    }

    local function DeriveTheme()
        local T = Library.Theme

        T.AccentDark = T.Accent:Lerp(Color3.new(0, 0, 0), 0.44)
        T.AccentDeep = T.Accent:Lerp(Color3.new(0, 0, 0), 0.24)
        T.Ripple = T.Accent:Lerp(Color3.new(1, 1, 1), 0.12)
        T.AccentSoft = T.Accent:Lerp(T.Background, 0.72)
    end

    DeriveTheme()

    Library.Flags = { }
    Library.SetFlags = { }
    Library.Connections = { }
    Library.Threads = { }
    Library.ThemingStuff = { }
    Library.ThemeMap = { }
    Library.AccentGradients = { }
    Library.AccentShadows = { }
    Library.OpenFrames = { }
    Library.Windows = { }
    Library.Notifs = { }
    Library.TouchButtons = { }
    Library.TouchShields = { }
    Library.Searchables = { }
    Library.MenuKeybind = Enum.KeyCode.RightControl
    Library.Binding = false
    Library.UserScale = 1
    Library.Silent = false
    Library.ThemeDirty = false
    Library.PreloadDirty = false
    Library.PreloadClock = 0
    Library.Preloaded = setmetatable({ }, { __mode = "k" })
    Library.Animation = {
        Time = 0.25,
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out
    }

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Instance = Instance.new(Class)
        }

        for Property, Value in Properties do
            if Property == "Name" then
                Data.Instance.Name = "\0"
                continue
            end

            Data.Instance[Property] = Value
        end

        if Class == "ImageLabel" or Class == "ImageButton" then
            Library.PreloadDirty = true
        end

        return setmetatable(Data, Library)
    end

    Library.PreloadAll = function(Self)
        local Roots = {
            Library.Holder,
            Library.PopupHolder,
            Library.UnusedHolder
        }

        local Assets = { }

        for _, Root in Roots do
            if not Root or not Root.Instance then continue end

            for _, Child in Root.Instance:GetDescendants() do
                if Library.Preloaded[Child] then continue end
                if not Child:IsA("ImageLabel") and not Child:IsA("ImageButton") then continue end
                if Child.Image == "" then continue end

                Library.Preloaded[Child] = true
                table.insert(Assets, Child)
            end
        end

        if #Assets == 0 then return end

        Library:Thread(function()
            pcall(function()
                ContentProvider:PreloadAsync(Assets)
            end)
        end)
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if type(Signal) == "string" and Self.Instance then
            local IsClick = Signal == "MouseButton1Down" or Signal == "MouseButton1Click"

            if IsMobile and IsClick and Self.Instance:IsA("GuiButton") then
                local LastFire = 0

                local function Fire(Input)
                    local Now = os.clock()
                    if Now - LastFire < 0.25 then return end
                    LastFire = Now
                    Callback(Input)
                end

                table.insert(Library.TouchButtons, {
                    Instance = Self.Instance,
                    Fire = Fire
                })

                Connection = Self.Instance.Activated:Connect(function(Input)
                    Fire(Input)
                end)
            else
                Connection = Self.Instance[Signal]:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)
        coroutine.resume(NewThread)
        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.SafeCall = function(Self, Function, ...)
        if type(Function) ~= "function" then return end

        local Success, Result = pcall(Function, ...)
        if not Success then warn(Result) end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        Float = Float or 1

        local Result = math.floor(Number / Float + 0.5) * Float
        local Places = math.max(0, math.ceil(-math.log(Float, 10)))

        return tonumber(string.format("%." .. Places .. "f", Result))
    end

    Library.Tween = function(Self, Properties, Info, RawItem)
        local Object = RawItem or Self.Instance

        Info = Info or TweenInfo.new(
            Library.Animation.Time,
            Library.Animation.Style,
            Library.Animation.Direction
        )

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, RawItem)
        local Object = RawItem or Self.Instance

        if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then
            return { "Transparency" }
        elseif Object.ClassName == "UIShadow" then
            return { "Transparency" }
        end
    end

    Library.RestingValues = setmetatable({ }, { __mode = "k" })
    Library.Baselines = setmetatable({ }, { __mode = "k" })
    Library.FadeTokens = setmetatable({ }, { __mode = "k" })

    local function BumpFadeToken(Root)
        local Next = (Library.FadeTokens[Root] or 0) + 1
        Library.FadeTokens[Root] = Next
        return Next
    end

    local function CollectFadeable(Root)
        local Children = Root:GetDescendants()
        table.insert(Children, Root)
        return Children
    end

    local function ForEachFadeable(Children, Handler)
        for _, Child in Children do
            local Properties = Library:GetTweenProperty(Child)
            if not Properties then continue end

            for _, Property in Properties do
                Handler(Child, Property)
            end
        end
    end

    local function RestoreResting(Children)
        ForEachFadeable(Children, function(Child, Property)
            local Resting = Library:ReleaseResting(Child, Property)

            if Resting ~= nil then
                Child[Property] = Resting
            end
        end)
    end

    Library.SetBaseline = function(Self, Object, Property, Value)
        local Store = Library.Baselines[Object]

        if not Store then
            Store = { }
            Library.Baselines[Object] = Store
        end

        Store[Property] = Value
    end

    Library.CaptureResting = function(Self, Object, Property)
        local Store = Library.RestingValues[Object]

        if not Store then
            Store = { }
            Library.RestingValues[Object] = Store
        end

        if Store[Property] == nil then
            local Base = Library.Baselines[Object]
            local Known = Base and Base[Property]

            Store[Property] = Known ~= nil and Known or Object[Property]

            if Known == nil then
                Library:SetBaseline(Object, Property, Store[Property])
            end
        end

        return Store[Property]
    end

    Library.ReleaseResting = function(Self, Object, Property)
        local Store = Library.RestingValues[Object]
        if not Store then return nil end

        local Value = Store[Property]
        Store[Property] = nil

        return Value
    end

    Library.StampResting = function(Self, Object, Property, Value)
        local Store = Library.RestingValues[Object]

        if not Store then
            Store = { }
            Library.RestingValues[Object] = Store
        end

        Store[Property] = Value
        Library:SetBaseline(Object, Property, Value)
    end

    Library.HardRestore = function(Self)
        local Root = Self.Instance
        BumpFadeToken(Root)

        ForEachFadeable(CollectFadeable(Root), function(Child, Property)
            local Base = Library.Baselines[Child]
            if not Base then return end

            Library:ReleaseResting(Child, Property)

            if Base[Property] ~= nil then
                pcall(function()
                    Child[Property] = Base[Property]
                end)
            end
        end)
    end

    Library.Fade = function(Self, Property, Visibility, RawItem)
        local Object = RawItem or Self.Instance
        local Resting = Library:CaptureResting(Object, Property)
        local Target = Visibility and Resting or 1

        if Visibility then
            Object[Property] = 1
        end

        local Ok = pcall(function()
            Library:Tween({ [Property] = Target }, nil, Object)
        end)

        if not Ok then
            pcall(function()
                Object[Property] = Target
            end)
        end
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        local Root = Self.Instance
        local Token = BumpFadeToken(Root)

        if Visibility then
            Root.Visible = true
        end

        local Children = CollectFadeable(Root)

        ForEachFadeable(Children, function(Child, Property)
            Library:Fade(Property, Visibility, Child)
        end)

        task.delay(Library.Animation.Time + 0.03, function()
            if Library.FadeTokens[Root] == Token then
                Root.Visible = Visibility
                RestoreResting(Children)
            end

            if Callback then Callback() end
        end)
    end

    Library.CancelFade = function(Self)
        BumpFadeToken(Self.Instance)
    end

    Library.ResetFade = function(Self)
        local Root = Self.Instance
        BumpFadeToken(Root)
        RestoreResting(CollectFadeable(Root))
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties
        }

        for Property, Value in Properties do
            if type(Value) == "string" then
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
        if not Library.ThemeMap[Object] then return end
        Library.ThemeMap[Object].Properties = Properties
    end

    local function AccentSequence()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Theme.Accent),
            ColorSequenceKeypoint.new(1, Library.Theme.AccentDark)
        })
    end

    Library.RegisterGradient = function(Self, Gradient)
        Gradient.Color = AccentSequence()
        table.insert(Library.AccentGradients, Gradient)
    end

    Library.ApplyThemeInstant = function(Self)
        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" then
                    Item.Item[Property] = Library.Theme[Value]
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end

        for _, Gradient in Library.AccentGradients do
            Gradient.Color = AccentSequence()
        end

        for _, Shadow in Library.AccentShadows do
            pcall(function()
                Shadow.Color = Library.Theme.Accent
            end)
        end
    end

    Library.SetAccent = function(Self, Color)
        Library.Theme.Accent = Color
        DeriveTheme()
        Library.ThemeDirty = true
    end

    Library.SetThemeColor = function(Self, Key, Color)
        Library.Theme[Key] = Color
        DeriveTheme()
        Library.ThemeDirty = true
    end

    Library.SetTheme = function(Self, Preset)
        if type(Preset) == "string" then
            for _, Entry in Library.ThemePresets do
                if Entry.Name == Preset then
                    Preset = Entry
                    break
                end
            end
        end

        if type(Preset) ~= "table" then return end

        for Key, Value in Preset do
            if Key ~= "Name" and Key ~= "Swatch" and typeof(Value) == "Color3" then
                Library.Theme[Key] = Value
            end
        end

        DeriveTheme()
        Library.ThemeDirty = true
    end

    Library.OnHover = function(Self, OnEnter, OnLeave)
        Library:Connect(Self.Instance.MouseEnter, OnEnter)
        Library:Connect(Self.Instance.MouseLeave, OnLeave)
    end

    Library.GetScreenScale = function(Self)
        if Library.UIScale and Library.UIScale.Instance then
            return Library.UIScale.Instance.Scale
        end

        return 1
    end

    local function IsOverObject(Object)
        local Position = UserInputService:GetMouseLocation() - Vector2.new(0, GuiInset)
        local Corner = Object.AbsolutePosition
        local Size = Object.AbsoluteSize

        return Position.X >= Corner.X
        and Position.X <= Corner.X + Size.X
        and Position.Y >= Corner.Y
        and Position.Y <= Corner.Y + Size.Y
    end

    Library.IsMouseOverFrame = function(Self)
        return IsOverObject(Self.Instance)
    end

    local function IsOverAnyPopup()
        for Panel in Library.TouchShields do
            if not Panel.Parent then continue end
            if not Panel.Visible then continue end
            if IsOverObject(Panel) then return true end
        end

        return false
    end

    Library.MakeDraggable = function(Self, Handle)
        local Gui = Self.Instance
        Handle = Handle or Gui
        Handle.Active = true

        local Dragging = false
        local DragStart
        local StartPosition
        local InputChanged

        local function Set(Input)
            local Scale = Library:GetScreenScale()
            local DragDelta = (Input.Position - DragStart) / Scale
            local NewX = StartPosition.X + DragDelta.X
            local NewY = StartPosition.Y + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize / Scale
            local GuiSize = Gui.AbsoluteSize / Scale
            local Anchor = Gui.AnchorPoint

            NewX = math.clamp(NewX, GuiSize.X * Anchor.X, ScreenSize.X - GuiSize.X * (1 - Anchor.X))
            NewY = math.clamp(NewY, GuiSize.Y * Anchor.Y, ScreenSize.Y - GuiSize.Y * (1 - Anchor.Y))

            local Info = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            Self:Tween({ Position = UDim2.fromOffset(NewX, NewY) }, Info)
        end

        Library:Connect(Handle.InputBegan, function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not IsClick and not IsTouch then return end
            if IsOverAnyPopup() then return end

            Dragging = true
            DragStart = Input.Position

            local Scale = Library:GetScreenScale()
            local ParentSize = Gui.Parent.AbsoluteSize / Scale

            StartPosition = Vector2.new(
                Gui.Position.X.Scale * ParentSize.X + Gui.Position.X.Offset,
                Gui.Position.Y.Scale * ParentSize.Y + Gui.Position.Y.Offset
            )

            if InputChanged then return end

            InputChanged = Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    InputChanged:Disconnect()
                    InputChanged = nil
                end
            end)
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsMove or IsTouch) and Dragging then
                Set(Input)
            end
        end)
    end

    Library.Unload = function(Self)
        for _, Connection in Library.Connections do
            pcall(function()
                Connection:Disconnect()
            end)
        end

        for _, Thread in Library.Threads do
            pcall(coroutine.close, Thread)
        end

        for _, Root in { Library.Holder, Library.PopupHolder, Library.UnusedHolder } do
            if Root then Root.Instance:Destroy() end
        end

        getgenv().Zolar = nil
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = GetHui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 1000
    })

    Library.PopupHolder = Library:Create("ScreenGui", {
        Parent = GetHui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 1001
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = GetHui(),
        Name = "\0",
        Enabled = false,
        ResetOnSpawn = false
    })

    do
        local Probe = Library:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(1, 1),
            BorderSizePixel = 0
        })

        task.defer(function()
            GuiInset = -Probe.Instance.AbsolutePosition.Y
            Probe.Instance:Destroy()
        end)
    end

    Library.UIScale = Library:Create("UIScale", {
        Parent = Library.Holder.Instance,
        Scale = 1
    })

    Library.PopupScale = Library:Create("UIScale", {
        Parent = Library.PopupHolder.Instance,
        Scale = 1
    })

    local function Corner(Object, Radius)
        Library:Create("UICorner", {
            Parent = Object,
            CornerRadius = UDim.new(0, Radius)
        })
    end

    local function MakeFrame(Params)
        local Frame = Library:Create("Frame", {
            Parent = Params.Parent,
            Name = "\0",
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.fromOffset(0, 0),
            AnchorPoint = Params.Anchor or Vector2.new(0, 0),
            BackgroundTransparency = Params.Color and 0 or 1,
            ZIndex = Params.Z or 1,
            ClipsDescendants = Params.Clip or false,
            BorderSizePixel = 0,
            BackgroundColor3 = Params.Color and Library.Theme[Params.Color] or Color3.new(1, 1, 1)
        })

        if Params.Color then
            Frame:AddToTheme({ BackgroundColor3 = Params.Color })
        end

        if Params.Raw then
            Frame.Instance.BackgroundColor3 = Params.Raw
            Frame.Instance.BackgroundTransparency = Params.Alpha or 0
        end

        if Params.Round then
            Corner(Frame.Instance, Params.Round)
        end

        return Frame
    end

    local function MakeText(Params)
        return Library:Create("TextLabel", {
            Parent = Params.Parent,
            Name = "\0",
            FontFace = Params.Bold and UiFontBold or UiFont,
            Text = Params.Text or "",
            TextSize = Params.TextSize or 15,
            TextColor3 = Library.Theme[Params.Color or "Text"],
            BackgroundTransparency = 1,
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.fromOffset(0, 0),
            AnchorPoint = Params.Anchor or Vector2.new(0, 0),
            TextXAlignment = Params.Align or Enum.TextXAlignment.Left,
            TextTruncate = Params.Truncate and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None,
            TextWrapped = Params.Wrap or false,
            ZIndex = Params.Z or 1,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = Params.Color or "Text" })
    end

    local function MakeImage(Params)
        local Raw = Params.Raw

        local Image = Library:Create("ImageLabel", {
            Parent = Params.Parent,
            Name = "\0",
            BackgroundTransparency = 1,
            ImageColor3 = Raw or Library.Theme[Params.Color or "DimIcon"],
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.fromOffset(16, 16),
            AnchorPoint = Params.Anchor or Vector2.new(0, 0),
            ScaleType = Params.Fit and Enum.ScaleType.Fit or Enum.ScaleType.Stretch,
            ZIndex = Params.Z or 1,
            BorderSizePixel = 0
        })

        if not Raw then
            Image:AddToTheme({ ImageColor3 = Params.Color or "DimIcon" })
        end

        ApplyIcon(Image.Instance, Params.Icon)
        return Image
    end

    local function MakeButton(Params)
        return Library:Create("TextButton", {
            Parent = Params.Parent,
            Name = "\0",
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.new(1, 0, 1, 0),
            AnchorPoint = Params.Anchor or Vector2.new(0, 0),
            ZIndex = Params.Z or 5,
            BorderSizePixel = 0
        })
    end

    local function MakeInput(Params)
        local Input = Library:Create("TextBox", {
            Parent = Params.Parent,
            Name = "\0",
            FontFace = UiFont,
            TextColor3 = Library.Theme.Text,
            PlaceholderColor3 = Library.Theme.DimText,
            PlaceholderText = Params.Placeholder or "",
            Text = Params.Text or "",
            TextSize = Params.TextSize or 15,
            ClearTextOnFocus = false,
            CursorPosition = -1,
            BackgroundTransparency = 1,
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.new(1, 0, 1, 0),
            TextXAlignment = Params.Align or Enum.TextXAlignment.Left,
            ZIndex = Params.Z or 6,
            BorderSizePixel = 0
        }):AddToTheme({
            TextColor3 = "Text",
            PlaceholderColor3 = "DimText"
        })

        if IsMobile then
            local Focus = MakeButton({
                Parent = Params.Parent,
                Pos = Params.Pos,
                Size = Params.Size or UDim2.new(1, 0, 1, 0),
                Z = (Params.Z or 6) + 2
            })

            Focus:Connect("MouseButton1Down", function()
                Input.Instance:CaptureFocus()
            end)
        end

        return Input
    end

    local function MakeShadow(Parent, Color, Spread, Blur, Transparency)
        local Ok, Shadow = pcall(function()
            local S = Instance.new("UIShadow")
            S.Name = "\0"
            S.Color = Color
            S.Spread = Spread
            S.BlurRadius = Blur
            S.Transparency = Transparency
            S.Parent = Parent
            return S
        end)

        if Ok and Shadow then return Shadow end

        return nil
    end

    local function MakeAccentShadow(Parent, Spread, Blur, Transparency)
        local Shadow = MakeShadow(Parent, Library.Theme.Accent, Spread, Blur, Transparency)

        if Shadow then
            table.insert(Library.AccentShadows, Shadow)
        end

        return Shadow
    end

    Library.DimCount = 0
    Library.Dims = { }

    for Index = 1, 3 do
        local Dim = Library:Create("Frame", {
            Parent = Library.UnusedHolder.Instance,
            Name = "\0",
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = Index == 3 and 28 or 15,
            BorderSizePixel = 0
        })

        Corner(Dim.Instance, 10)
        Library.Dims[Index] = Dim
    end

    Library.Dim = Library.Dims[1]

    Library.SetDim = function(Self, Bool)
        Library.DimCount = math.max(0, Library.DimCount + (Bool and 1 or -1))

        local Window = Library.Windows[1]
        if not Window then return end

        local Info = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Shown = Library.DimCount > 0
        local Target = Shown and 0.55 or 1

        local Hosts = {
            Window.Items.Main.Instance,
            Window.Items.Rail.Instance,
            Window.Items.SubBar.Instance
        }

        for Index, Dim in Library.Dims do
            Library:StampResting(Dim.Instance, "BackgroundTransparency", Target)

            if Shown then
                Dim.Instance.Parent = Hosts[Index]
                Dim.Instance.Visible = true
            end

            Library:Tween({ BackgroundTransparency = Target }, Info, Dim.Instance)
        end

        if Shown then return end

        task.delay(0.28, function()
            if Library.DimCount > 0 then return end

            for _, Dim in Library.Dims do
                Dim.Instance.Visible = false
                Dim.Instance.Parent = Library.UnusedHolder.Instance
            end
        end)
    end

    Library.CloseAllPopups = function(Self)
        for _, Value in Library.OpenFrames do
            if Value.SetOpen then Value:SetOpen(false) end
        end
    end

    local function UpdateScale()
        local Scale = Library.UserScale

        if IsMobile and workspace.CurrentCamera then
            local Viewport = workspace.CurrentCamera.ViewportSize
            local FitX = (Viewport.X * 0.94) / Library.WindowWidth
            local FitY = (Viewport.Y * 0.9) / Library.WindowHeight
            Scale = Scale * math.clamp(math.min(FitX, FitY), 0.3, 1)
        end

        local Old = Library.UIScale.Instance.Scale
        local Centers = { }

        for Index, Window in Library.Windows do
            local Root = Window.Items and Window.Items.Root
            if not Root then continue end

            local Pos = Root.Instance.Position
            local Size = Root.Instance.Size

            Centers[Index] = Vector2.new(
                (Pos.X.Offset + Size.X.Offset / 2) * Old,
                (Pos.Y.Offset + Size.Y.Offset / 2) * Old
            )
        end

        Library.UIScale.Instance.Scale = Scale
        Library.PopupScale.Instance.Scale = Scale

        if IsMobile then
            for _, Window in Library.Windows do
                if Window.Center then Window:Center() end
            end

            return
        end

        local Viewport = workspace.CurrentCamera.ViewportSize

        for Index, Window in Library.Windows do
            local Root = Window.Items and Window.Items.Root
            local Center = Centers[Index]

            if not Root or not Center then continue end

            local Size = Root.Instance.Size
            local HalfX = Size.X.Offset / 2
            local HalfY = Size.Y.Offset / 2
            local LimitX = Viewport.X / Scale
            local LimitY = Viewport.Y / Scale

            local NewX = math.clamp(Center.X / Scale - HalfX, 0, math.max(LimitX - HalfX * 2, 0))
            local NewY = math.clamp(Center.Y / Scale - HalfY, 0, math.max(LimitY - HalfY * 2, 0))

            Root.Instance.Position = UDim2.fromOffset(NewX, NewY)
        end
    end

    Library.SetUIScale = function(Self, Multiplier)
        Library.UserScale = Multiplier
        Library:CloseAllPopups()
        UpdateScale()
    end

    UpdateScale()

    Library:Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
        task.wait()
        UpdateScale()
    end)

    local function PointInside(Position, Object)
        local Corner = Object.AbsolutePosition
        local Size = Object.AbsoluteSize

        return Position.X >= Corner.X
        and Position.X <= Corner.X + Size.X
        and Position.Y >= Corner.Y
        and Position.Y <= Corner.Y + Size.Y
    end

    do
        local TouchStart

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.Touch then
                TouchStart = Input.Position
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if not IsMobile then return end
            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not TouchStart then return end

            local Delta = Input.Position - TouchStart
            if math.abs(Delta.X) > 12 or math.abs(Delta.Y) > 12 then return end

            local Position = Input.Position
            local ShieldLevel = 0

            for Panel, Level in Library.TouchShields do
                local Live = Panel:IsDescendantOf(Library.Holder.Instance)
                or Panel:IsDescendantOf(Library.PopupHolder.Instance)

                if Live and PointInside(Position, Panel) then
                    ShieldLevel = math.max(ShieldLevel, Level)
                end
            end

            local Best

            for _, Data in Library.TouchButtons do
                local Object = Data.Instance
                if not Object or not Object.Visible then continue end
                if not PointInside(Position, Object) then continue end
                if Object.ZIndex < ShieldLevel then continue end

                if not Best or Object.ZIndex >= Best.Instance.ZIndex then
                    Best = Data
                end
            end

            if Best then Best.Fire(Input) end
        end)
    end

    local function AxisFraction(Input, Object, Axis)
        local Base = Object.AbsolutePosition[Axis]
        local Span = Object.AbsoluteSize[Axis]

        if Span == 0 then return 0 end

        return math.clamp((Input.Position[Axis] - Base) / Span, 0, 1)
    end

    local function AttachDrag(Hit, Handlers)
        local Watcher
        local Active = false

        Hit:Connect("InputBegan", function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not IsClick and not IsTouch then return end

            Active = true
            Handlers.OnGrab(Input)

            if Watcher then return end

            Watcher = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then return end

                Active = false

                if Handlers.OnRelease then Handlers.OnRelease() end

                Watcher:Disconnect()
                Watcher = nil
            end)
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsMove or IsTouch) and Active then
                Handlers.OnMove(Input)
            end
        end)
    end

    local function PlaceBelow(GetAnchor)
        return function(Extra)
            local Anchor = GetAnchor()
            local Scale = Library:GetScreenScale()
            local X = Anchor.AbsolutePosition.X / Scale
            local Y = Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset

            return UDim2.fromOffset(X, Y / Scale + (Extra or 0))
        end
    end

    local function PlaceBeside(GetAnchor)
        return function(Extra)
            local Anchor = GetAnchor()
            local Scale = Library:GetScreenScale()
            local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
            local X = Right / Scale + 8
            local Y = (Anchor.AbsolutePosition.Y + GuiInset) / Scale

            return UDim2.fromOffset(X, Y + (Extra or 0))
        end
    end

    local function RetreatUp(Current)
        return UDim2.fromOffset(Current.X.Offset, Current.Y.Offset - 8)
    end

    local function RetreatLeft(Current)
        return UDim2.fromOffset(Current.X.Offset - 8, Current.Y.Offset)
    end

    local function AttachPopup(Config)
        local Popup = Config.Popup
        local Frame = Config.Frame
        local Level = Config.Level
        local Place = Config.Place
        local GetAnchor = Config.GetAnchor
        local From = Config.From or -6
        local To = Config.To or 6
        local Retreat = Config.Retreat or RetreatUp

        local KeepOpen = Config.KeepOpen or function(Value)
            return Value == Popup or Value == Popup.Host
        end

        function Popup:SetOpen(Bool)
            if Popup.Debounce then return end
            if Popup.IsOpen == Bool then return end

            Popup.IsOpen = Bool
            Popup.Debounce = true

            if Popup.OnState then Popup.OnState(Bool) end

            if Popup.Host and Popup.Host.SetChildDim then
                Popup.Host.SetChildDim(Bool)
            end

            if Bool then
                if Config.OnOpen then Config.OnOpen() end

                Frame.Instance.Parent = Library.PopupHolder.Instance
                Frame.Instance.Position = Place(From)
                Frame.Instance.Visible = true
                Library.TouchShields[Frame.Instance] = Level
                Library:SetDim(true)
                Frame:Tween({ Position = Place(To) })

                for _, Value in Library.OpenFrames do
                    if not KeepOpen(Value) then
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Popup] = Popup

                Frame:FadeDescendants(true, function()
                    Popup.Debounce = false
                end)
            else
                if Config.OnClose then Config.OnClose() end

                Library.OpenFrames[Popup] = nil
                Library:SetDim(false)
                Frame:Tween({ Position = Retreat(Frame.Instance.Position) })

                Frame:FadeDescendants(false, function()
                    Popup.Debounce = false
                    if Popup.IsOpen then return end
                    Library.TouchShields[Frame.Instance] = nil
                    Frame.Instance.Parent = Library.UnusedHolder.Instance
                end)
            end
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not IsClick and not IsTouch then return end
            if not Popup.IsOpen then return end
            if Config.HoldOpen and Config.HoldOpen() then return end
            if Frame:IsMouseOverFrame() then return end
            if IsOverObject(GetAnchor()) then return end

            Popup:SetOpen(false)
        end)

        return Popup
    end

    local function MakeAccentRow(Params)
        local Z = Params.Z

        local Row = MakeFrame({
            Parent = Params.Parent,
            Pos = Params.Pos,
            Size = Params.Size,
            Color = Params.Color or "Section",
            Round = 5,
            Z = Z
        })

        Row.Instance.BackgroundTransparency = 1

        local Line = MakeFrame({
            Parent = Row.Instance,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, Params.LineX, 0.5, 0),
            Size = UDim2.fromOffset(3, 0),
            Color = "Accent",
            Round = 4,
            Z = Z + 1
        })

        local Shadow = MakeAccentShadow(
            Line.Instance,
            UDim2.fromOffset(3, 15),
            UDim.new(0, 10),
            0
        )

        if Shadow then
            Shadow.Transparency = 1
        end

        local Label = MakeText({
            Parent = Row.Instance,
            Text = Params.Text,
            TextSize = Params.TextSize,
            Pos = UDim2.fromOffset(Params.TextX, 0),
            Size = Params.LabelSize,
            Color = "DimText",
            Truncate = true,
            Z = Z + 1
        })

        local Hit = MakeButton({
            Parent = Row.Instance,
            Z = Z + 2
        })

        local function SetActive(Active, Instant)
            Library:StampResting(Row.Instance, "BackgroundTransparency", Active and 0 or 1)
            Label:ChangeItemTheme({ TextColor3 = Active and "Text" or "DimText" })

            local Info = Instant and TweenInfo.new(0) or nil
            local Color = Active and Library.Theme.Text or Library.Theme.DimText
            local TextX = Active and Params.TextActiveX or Params.TextX

            Library:Tween({ BackgroundTransparency = Active and 0 or 1 }, Info, Row.Instance)
            Library:Tween({ Size = UDim2.fromOffset(3, Active and Params.LineH or 0) }, Info, Line.Instance)
            Library:Tween({
                TextColor3 = Color,
                Position = UDim2.fromOffset(TextX, 0)
            }, Info, Label.Instance)

            if not Shadow then return end

            Library:StampResting(Shadow, "Transparency", Active and 0 or 1)

            if Params.SnapShadow or Instant then
                Shadow.Transparency = Active and 0 or 1
            else
                Library:Tween({ Transparency = Active and 0 or 1 }, Info, Shadow)
            end
        end

        return {
            Row = Row,
            Line = Line,
            Label = Label,
            Hit = Hit,
            Shadow = Shadow,
            SetActive = SetActive
        }
    end

    local function MakeOptionPopup(GetAnchor, Level, WidthOverride)
        Level = Level or 40

        local Popup = {
            IsOpen = false,
            Debounce = false,
            Order = { },
            Host = nil,
            OnPick = function() end
        }

        local Items = { }
        local RowHeight = 30
        local SearchHeight = 30

        Items.Frame = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(150, 0),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = Level
        })

        Items.Frame.Instance.Visible = false

        Items.SearchHolder = MakeFrame({
            Parent = Items.Frame.Instance,
            Size = UDim2.new(1, 0, 0, SearchHeight),
            Color = "Element",
            Z = Level + 5
        })

        Items.SearchHolder.Instance.Visible = false

        MakeImage({
            Parent = Items.SearchHolder.Instance,
            Icon = "search",
            Pos = UDim2.fromOffset(9, (SearchHeight - 13) / 2),
            Size = UDim2.fromOffset(13, 13),
            Color = "DimText",
            Z = Level + 7
        })

        Items.Search = MakeInput({
            Parent = Items.SearchHolder.Instance,
            Placeholder = "Search...",
            Pos = UDim2.fromOffset(27, 0),
            Size = UDim2.new(1, -32, 1, 0),
            TextSize = 14,
            Z = Level + 6
        })

        MakeFrame({
            Parent = Items.SearchHolder.Instance,
            Pos = UDim2.new(0, 6, 1, -1),
            Size = UDim2.new(1, -12, 0, 1),
            Color = "Line",
            Z = Level + 6
        })

        Items.Scroll = Library:Create("ScrollingFrame", {
            Parent = Items.Frame.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = Level + 4,
            BorderSizePixel = 0
        })

        Library:Create("UIListLayout", {
            Parent = Items.Scroll.Instance,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 3)
        })

        Library:Create("UIPadding", {
            Parent = Items.Scroll.Instance,
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4)
        })

        Popup.Items = Items

        local function ApplySearch(Query)
            Query = string.lower(Query)

            for _, Data in Popup.Order do
                local Match = Query == ""
                or string.find(string.lower(Data.Name), Query, 1, true) ~= nil

                Data.Row.Instance.Visible = Match
            end
        end

        Library:Connect(Items.Search.Instance:GetPropertyChangedSignal("Text"), function()
            ApplySearch(Items.Search.Instance.Text)
        end)

        function Popup:AddRow(Text)
            local Built = MakeAccentRow({
                Parent = Items.Scroll.Instance,
                Size = UDim2.new(1, -4, 0, RowHeight - 4),
                Text = Text,
                TextSize = 14,
                LabelSize = UDim2.new(1, -20, 1, 0),
                LineX = 8,
                LineH = 16,
                TextX = 11,
                TextActiveX = 20,
                Z = Level + 1
            })

            local Data = {
                Name = Text,
                Selected = false,
                Row = Built.Row
            }

            function Data:Set(Active, Instant)
                Data.Selected = Active
                Built.SetActive(Active, Instant)
            end

            Built.Row:OnHover(function()
                if Data.Selected then return end
                Library:Tween({ BackgroundTransparency = 0.7 }, nil, Built.Row.Instance)
            end, function()
                if Data.Selected then return end
                Library:Tween({ BackgroundTransparency = 1 }, nil, Built.Row.Instance)
            end)

            Built.Hit:Connect("MouseButton1Down", function()
                Popup.OnPick(Data)
            end)

            table.insert(Popup.Order, Data)
            return Data
        end

        function Popup:Clear()
            for _, Data in Popup.Order do
                Data.Row.Instance:Destroy()
            end

            Popup.Order = { }
        end

        return AttachPopup({
            Popup = Popup,
            Frame = Items.Frame,
            Level = Level,
            GetAnchor = GetAnchor,
            Place = PlaceBelow(GetAnchor),
            OnOpen = function()
                local Anchor = GetAnchor()
                local Scale = Library:GetScreenScale()
                local ShowSearch = #Popup.Order > 8
                local Width = WidthOverride or (Anchor.AbsoluteSize.X / Scale)
                local ListHeight = math.min(#Popup.Order * RowHeight + 8, 168)

                Items.Search.Instance.Text = ""
                ApplySearch("")

                Items.SearchHolder.Instance.Visible = ShowSearch

                if ShowSearch then
                    Items.Scroll.Instance.Position = UDim2.fromOffset(0, SearchHeight)
                    Items.Scroll.Instance.Size = UDim2.new(1, 0, 1, -SearchHeight)
                    Items.Frame.Instance.Size = UDim2.fromOffset(Width, ListHeight + SearchHeight)
                else
                    Items.Scroll.Instance.Position = UDim2.fromOffset(0, 0)
                    Items.Scroll.Instance.Size = UDim2.new(1, 0, 1, 0)
                    Items.Frame.Instance.Size = UDim2.fromOffset(Width, ListHeight)
                end
            end,
            OnClose = function()
                Items.Search.Instance.Text = ""
            end
        })
    end

    local function MakeSwatch(Parent, RightOffset, Default, Z)
        local Swatch = { }
        local Base = Z or 3

        Swatch.Halo = MakeFrame({
            Parent = Parent,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, RightOffset, 0.5, 0),
            Size = UDim2.fromOffset(22, 22),
            Round = 20,
            Z = Base
        })

        Swatch.Halo.Instance.BackgroundColor3 = Default
        Swatch.Halo.Instance.BackgroundTransparency = 0.72

        Swatch.Core = MakeFrame({
            Parent = Swatch.Halo.Instance,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.fromOffset(12, 12),
            Raw = Default,
            Round = 20,
            Z = Base + 1
        })

        Swatch.Shadow = MakeShadow(
            Swatch.Core.Instance,
            Default,
            UDim2.fromOffset(0, 0),
            UDim.new(0, 6),
            0.35
        )

        Swatch.Hit = MakeButton({
            Parent = Swatch.Halo.Instance,
            Z = Base + 2
        })

        function Swatch:SetColor(Color, Alpha)
            Alpha = Alpha or 0

            Library:StampResting(Swatch.Core.Instance, "BackgroundTransparency", Alpha)
            Library:StampResting(Swatch.Halo.Instance, "BackgroundTransparency", 0.72)

            Swatch.Halo:Tween({ BackgroundColor3 = Color })
            Swatch.Core:Tween({
                BackgroundColor3 = Color,
                BackgroundTransparency = Alpha
            })

            if Swatch.Shadow then
                pcall(function()
                    Swatch.Shadow.Color = Color
                end)
            end
        end

        return Swatch
    end

    local function MakeColorPopup(GetAnchor, Title, Default, DefaultAlpha, OnChanged)
        local Picker = {
            Hue = 0,
            Saturation = 0,
            Value = 1,
            Transparency = DefaultAlpha or 0,
            Color = Color3.new(1, 1, 1),
            IsOpen = false,
            Debounce = false
        }

        local Items = { }
        local Level = 120
        local Field = 150
        local PanelW = Field + 32
        local CursorSize = 14
        local CursorThickness = 2

        Items.Window = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(PanelW, Field + 110),
            Color = "Section",
            Round = 8,
            Z = Level
        })

        Items.Window.Instance.Visible = false

        Items.Field = Library:Create("ImageButton", {
            Parent = Items.Window.Instance,
            Name = "\0",
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
            Position = UDim2.fromOffset(16, 16),
            Size = UDim2.fromOffset(Field, Field),
            ZIndex = Level + 1,
            BorderSizePixel = 0
        })

        Corner(Items.Field.Instance, 8)

        Items.Tint = MakeFrame({
            Parent = Items.Field.Instance,
            Size = UDim2.new(1, 0, 1, 0),
            Raw = Color3.new(1, 1, 1),
            Round = 8,
            Z = Level + 2
        })

        Library:Create("UIGradient", {
            Parent = Items.Tint.Instance,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
        })

        Items.Shade = MakeFrame({
            Parent = Items.Field.Instance,
            Size = UDim2.new(1, 0, 1, 0),
            Raw = Color3.new(0, 0, 0),
            Round = 8,
            Z = Level + 3
        })

        Library:Create("UIGradient", {
            Parent = Items.Shade.Instance,
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            })
        })

        local function MakeCursor(Parent, Pos, Z)
            local Cursor = MakeFrame({
                Parent = Parent,
                Anchor = Vector2.new(0.5, 0.5),
                Pos = Pos,
                Size = UDim2.fromOffset(CursorSize, CursorSize),
                Raw = Color3.new(1, 1, 1),
                Alpha = 1,
                Round = 20,
                Z = Z
            })

            Library:Create("UIStroke", {
                Parent = Cursor.Instance,
                Color = Color3.new(1, 1, 1),
                Thickness = CursorThickness
            })

            return Cursor
        end

        Items.FieldCursor = MakeCursor(
            Items.Field.Instance,
            UDim2.new(0.5, 0, 0.5, 0),
            Level + 4
        )

        local function MakeBar(Y)
            local Bar = Library:Create("ImageButton", {
                Parent = Items.Window.Instance,
                Name = "\0",
                AutoButtonColor = false,
                Position = UDim2.fromOffset(16, Y),
                Size = UDim2.fromOffset(Field, 10),
                ZIndex = Level + 1,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.new(1, 1, 1)
            })

            Corner(Bar.Instance, 5)

            local Cursor = MakeCursor(
                Bar.Instance,
                UDim2.new(1, 0, 0.5, 0),
                Level + 3
            )

            return Bar, Cursor
        end

        Items.HueBar, Items.HueCursor = MakeBar(Field + 30)

        Library:Create("UIGradient", {
            Parent = Items.HueBar.Instance,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
        })

        Items.AlphaBar, Items.AlphaCursor = MakeBar(Field + 50)

        local AlphaGradient = Library:Create("UIGradient", {
            Parent = Items.AlphaBar.Instance,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
        })

        Items.Hex = MakeFrame({
            Parent = Items.Window.Instance,
            Pos = UDim2.fromOffset(16, Field + 72),
            Size = UDim2.fromOffset(Field, 26),
            Color = "Element",
            Round = 5,
            Clip = true,
            Z = Level + 1
        })

        Items.HexInput = MakeInput({
            Parent = Items.Hex.Instance,
            Text = "#FFFFFF",
            Placeholder = "#FFFFFF",
            Pos = UDim2.fromOffset(9, 0),
            Size = UDim2.new(1, -18, 1, 0),
            TextSize = 14,
            Z = Level + 2
        })

        local Grabbing = nil
        local SlideInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        local function Refresh(Instant)
            Picker.Color = Color3.fromHSV(Picker.Hue, Picker.Saturation, Picker.Value)

            local Pure = Color3.fromHSV(Picker.Hue, 1, 1)
            local Info = Instant and TweenInfo.new(0) or SlideInfo

            AlphaGradient.Instance.Color = ColorSequence.new(Picker.Color)
            Library:Tween({ BackgroundColor3 = Pure }, Info, Items.Field.Instance)

            Library:Tween({
                Position = UDim2.new(Picker.Saturation, 0, 1 - Picker.Value, 0)
            }, Info, Items.FieldCursor.Instance)

            Library:Tween({ Position = UDim2.new(Picker.Hue, 0, 0.5, 0) }, Info, Items.HueCursor.Instance)
            Library:Tween({ Position = UDim2.new(Picker.Transparency, 0, 0.5, 0) }, Info, Items.AlphaCursor.Instance)

            if not Items.HexInput.Instance:IsFocused() then
                Items.HexInput.Instance.Text = "#" .. string.upper(Picker.Color:ToHex())
            end

            Library:SafeCall(OnChanged, Picker.Color, Picker.Transparency)
        end

        function Picker:Set(Color, Alpha, Silent)
            if type(Color) == "table" then
                Color = Color3.fromRGB(Color[1], Color[2], Color[3])
            end

            if type(Color) == "string" then
                Color = Color3.fromHex(Color)
            end

            Picker.Hue, Picker.Saturation, Picker.Value = Color:ToHSV()
            Picker.Transparency = Alpha or Picker.Transparency or 0

            if Silent then
                Picker.Color = Color3.fromHSV(Picker.Hue, Picker.Saturation, Picker.Value)
                return
            end

            Refresh(true)
        end

        local function Slide(Input)
            if Grabbing == "Field" then
                Picker.Saturation = AxisFraction(Input, Items.Field.Instance, "X")
                Picker.Value = 1 - AxisFraction(Input, Items.Field.Instance, "Y")
            elseif Grabbing == "Hue" then
                Picker.Hue = AxisFraction(Input, Items.HueBar.Instance, "X")
            elseif Grabbing == "Alpha" then
                Picker.Transparency = AxisFraction(Input, Items.AlphaBar.Instance, "X")
            else
                return
            end

            Refresh()
        end

        local function Grabber(Object, Mode)
            local Watcher

            Library:Connect(Object.InputBegan, function(Input)
                local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
                local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

                if not IsClick and not IsTouch then return end

                Grabbing = Mode
                Slide(Input)

                if Watcher then return end

                Watcher = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        if Grabbing == Mode then Grabbing = nil end
                        Watcher:Disconnect()
                        Watcher = nil
                    end
                end)
            end)
        end

        Grabber(Items.Field.Instance, "Field")
        Grabber(Items.HueBar.Instance, "Hue")
        Grabber(Items.AlphaBar.Instance, "Alpha")

        Library:Connect(UserInputService.InputChanged, function(Input)
            local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsMove or IsTouch) and Grabbing then
                Slide(Input)
            end
        end)

        Items.HexInput:Connect("FocusLost", function()
            local Text = string.gsub(Items.HexInput.Instance.Text, "#", "")

            local Ok, Color = pcall(function()
                return Color3.fromHex(Text)
            end)

            if Ok and Color then
                Picker:Set(Color, Picker.Transparency)
            else
                Refresh(true)
            end
        end)

        AttachPopup({
            Popup = Picker,
            Frame = Items.Window,
            Level = Level,
            GetAnchor = GetAnchor,
            Place = PlaceBeside(GetAnchor)
        })

        Picker:Set(Default or Library.Theme.Accent, Picker.Transparency)
        return Picker
    end

    local function KeyName(Key)
        if not Key then return "None" end

        local Text = tostring(Key)
        Text = string.gsub(Text, "Enum.KeyCode.", "")
        Text = string.gsub(Text, "Enum.UserInputType.", "")

        return Text
    end

    local function ParseKey(Value)
        if type(Value) ~= "string" or Value == "None" then
            return nil
        end

        local Name = string.gsub(Value, "Enum.KeyCode.", "")
        Name = string.gsub(Name, "Enum.UserInputType.", "")

        local Ok, Key = pcall(function()
            return Enum.KeyCode[Name]
        end)

        if Ok and Key then return Key end

        return nil
    end

    local function CaptureKey(State, Display, OnPicked)
        if State.Picking then return end

        State.Picking = true
        Library.Binding = true
        Display.Text = ". . ."

        task.wait()

        local Connection

        Connection = UserInputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then return end

            Connection:Disconnect()

            local IsBack = Input.KeyCode == Enum.KeyCode.Backspace
            local IsEsc = Input.KeyCode == Enum.KeyCode.Escape

            if IsBack or IsEsc then
                OnPicked(nil)
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                OnPicked(Input.KeyCode)
            else
                OnPicked(Input.UserInputType)
            end

            task.defer(function()
                Library.Binding = false
            end)
        end)
    end

    local function KeyMatches(Input, Key)
        return Input.KeyCode == Key or Input.UserInputType == Key
    end

    Library.Notification = function(Self, Params)
        if Library.Silent then return end

        Params = Params or { }

        local Title = Params.Name or Params.Title or "Notification"
        local Content = Params.Description or Params.Content or ""
        local Icon = Params.Icon or "bell"
        local Accent = Params.Color or Library.Theme.Accent
        local Duration = Params.Duration or 5

        local CardW = 300
        local Bounds = Vector2.new(0, 0)

        if Content ~= "" then
            Bounds = MeasureText(Content, 14, CardW - 26, UiFont)
        end

        local CardH = 38 + (Content ~= "" and Bounds.Y + 6 or 0) + 18
        local Items = { }

        Items.Frame = MakeFrame({
            Parent = Library.Holder.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, 340, 0, 15),
            Size = UDim2.fromOffset(CardW, CardH),
            Color = "Section",
            Round = 10,
            Z = 80
        })

        Items.Icon = MakeImage({
            Parent = Items.Frame.Instance,
            Icon = Icon,
            Pos = UDim2.fromOffset(13, 11),
            Size = UDim2.fromOffset(18, 18),
            Raw = Accent,
            Z = 81
        })

        Items.Title = MakeText({
            Parent = Items.Frame.Instance,
            Text = Title,
            TextSize = 15,
            Pos = UDim2.fromOffset(40, 10),
            Size = UDim2.new(1, -70, 0, 20),
            Color = "Text",
            Truncate = true,
            Z = 81
        })

        Items.Close = MakeImage({
            Parent = Items.Frame.Instance,
            Icon = "x",
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -13, 0, 13),
            Size = UDim2.fromOffset(14, 14),
            Color = "DimText",
            Z = 82
        })

        Items.CloseHit = MakeButton({
            Parent = Items.Frame.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -8, 0, 8),
            Size = UDim2.fromOffset(24, 24),
            Z = 83
        })

        if Content ~= "" then
            Items.Body = MakeText({
                Parent = Items.Frame.Instance,
                Text = Content,
                TextSize = 14,
                Pos = UDim2.fromOffset(13, 35),
                Size = UDim2.new(1, -26, 0, Bounds.Y),
                Color = "DimText",
                Wrap = true,
                Z = 81
            })

            Items.Body.Instance.TextYAlignment = Enum.TextYAlignment.Top
        end

        Items.BarBack = MakeFrame({
            Parent = Items.Frame.Instance,
            Pos = UDim2.new(0, 13, 1, -12),
            Size = UDim2.new(1, -26, 0, 5),
            Color = "Element",
            Round = 4,
            Z = 81
        })

        Items.BarFill = MakeFrame({
            Parent = Items.BarBack.Instance,
            Size = UDim2.new(1, 0, 1, 0),
            Raw = Color3.new(1, 1, 1),
            Round = 4,
            Z = 82
        })

        Library:RegisterGradient(Library:Create("UIGradient", {
            Parent = Items.BarFill.Instance
        }).Instance)

        local Notif = {
            Items = Items,
            Dead = false,
            Height = CardH
        }

        table.insert(Library.Notifs, Notif)

        local function StackHeight(Stop)
            local Y = 15

            for _, Value in Library.Notifs do
                if Value == Stop then break end
                if Value.Dead then continue end

                Y += Value.Height + 10
            end

            return Y
        end

        local function Reflow()
            local Info = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local Y = 15

            for _, Value in Library.Notifs do
                if Value.Dead then continue end

                Library:Tween({ Position = UDim2.new(1, -15, 0, Y) }, Info, Value.Items.Frame.Instance)
                Y += Value.Height + 10
            end
        end

        local StartY = StackHeight(Notif)
        local SlideIn = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        Items.Frame.Instance.Position = UDim2.new(1, 340, 0, StartY)
        Items.Frame:Tween({ Position = UDim2.new(1, -15, 0, StartY) }, SlideIn)

        local function Dismiss()
            if Notif.Dead then return end
            Notif.Dead = true

            local Fade = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local Current = Items.Frame.Instance.Position
            local Lift = UDim2.new(1, -15, 0, Current.Y.Offset - 14)

            Library:Tween({ Position = Lift }, Fade, Items.Frame.Instance)
            Items.Frame:FadeDescendants(false)

            task.delay(0.3, function()
                local Index = table.find(Library.Notifs, Notif)
                if Index then table.remove(Library.Notifs, Index) end

                Items.Frame.Instance:Destroy()
                Reflow()
            end)
        end

        Items.CloseHit:Connect("MouseButton1Down", Dismiss)

        local Countdown = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        Library:Tween({ Size = UDim2.new(0, 0, 1, 0) }, Countdown, Items.BarFill.Instance)

        task.delay(Duration, Dismiss)
    end

    Library.Window = function(Self, Params)
        Params = Params or { }

        local W = Library.WindowWidth
        local H = Library.WindowHeight
        local TopH = 51
        local Gap = 10
        local RailW = 60
        local RailH = 340
        local SubW = 260
        local SubH = 50
        local MainX = RailW + Gap
        local RailY = math.floor((H - RailH) / 2)
        local SubX = MainX + math.floor((W - SubW) / 2)
        local SubY = H - math.floor(SubH / 2)
        local RootW = MainX + W
        local RootH = SubY + SubH
        local ColW = math.floor((W - 46) / 2)
        local Col2X = ColW + 16
        local SubCenterX = MainX + math.floor(W / 2)
        local MaxSubW = W - 120

        local Window = {
            Name = Params.Name or "ZOLAR",
            Icon = Params.Icon or "layers",
            IsOpen = true,
            Tabs = { },
            Current = nil,
            ContentW = W - 30,
            ContentH = H - 96,
            ColW = ColW,
            Col2X = Col2X,
            Items = { }
        }

        if Params.Accent then
            Library:SetAccent(Params.Accent)
        end

        local Items = { }
        local Viewport = workspace.CurrentCamera.ViewportSize
        local Scale = Library:GetScreenScale()

        Items.Root = MakeFrame({
            Parent = Library.Holder.Instance,
            Pos = UDim2.fromOffset(
                Viewport.X / (2 * Scale) - RootW / 2,
                Viewport.Y / (2 * Scale) - RootH / 2
            ),
            Size = UDim2.fromOffset(RootW, RootH),
            Z = 1
        })

        Items.Main = MakeFrame({
            Parent = Items.Root.Instance,
            Pos = UDim2.fromOffset(MainX, 0),
            Size = UDim2.fromOffset(W, H),
            Color = "Background",
            Round = 10,
            Clip = true,
            Z = 1
        })

        Items.Rail = MakeFrame({
            Parent = Items.Root.Instance,
            Pos = UDim2.fromOffset(0, RailY),
            Size = UDim2.fromOffset(RailW, RailH),
            Color = "Section",
            Round = 10,
            Z = 1
        })

        Items.SubBar = MakeFrame({
            Parent = Items.Root.Instance,
            Pos = UDim2.fromOffset(SubX, SubY),
            Size = UDim2.fromOffset(SubW, SubH),
            Color = "Section",
            Round = 10,
            Clip = true,
            Z = 20
        })

        Items.TopBar = MakeFrame({
            Parent = Items.Main.Instance,
            Size = UDim2.fromOffset(W, TopH),
            Color = "Section",
            Round = 10,
            Z = 2
        })

        MakeFrame({
            Parent = Items.TopBar.Instance,
            Pos = UDim2.fromOffset(0, TopH - 12),
            Size = UDim2.fromOffset(W, 12),
            Color = "Section",
            Z = 2
        })

        Items.TopLine = MakeFrame({
            Parent = Items.Main.Instance,
            Pos = UDim2.fromOffset(0, 50),
            Size = UDim2.fromOffset(W, 1),
            Color = "Element",
            Z = 3
        })

        Items.HubIcon = MakeImage({
            Parent = Items.TopBar.Instance,
            Icon = Window.Icon,
            Pos = UDim2.fromOffset(10, 10),
            Size = UDim2.fromOffset(30, 30),
            Raw = Color3.new(1, 1, 1),
            Fit = true,
            Z = 3
        })

        Items.Search = MakeFrame({
            Parent = Items.TopBar.Instance,
            Pos = UDim2.fromOffset(50, 11),
            Size = UDim2.fromOffset(280, 30),
            Color = "Element",
            Round = 5,
            Z = 3
        })

        MakeImage({
            Parent = Items.Search.Instance,
            Icon = "search",
            Pos = UDim2.fromOffset(7, 7),
            Size = UDim2.fromOffset(16, 16),
            Color = "DimText",
            Z = 4
        })

        Items.SearchBox = MakeInput({
            Parent = Items.Search.Instance,
            Placeholder = "search",
            Pos = UDim2.fromOffset(30, -1),
            Size = UDim2.new(1, -38, 1, 0),
            TextSize = 15,
            Z = 4
        })

        Items.Username = MakeText({
            Parent = Items.TopBar.Instance,
            Text = LocalPlayer.DisplayName,
            TextSize = 15,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -56, 0, 8),
            Size = UDim2.fromOffset(240, 18),
            Color = "Text",
            Align = Enum.TextXAlignment.Right,
            Truncate = true,
            Z = 3
        })

        Items.Version = MakeFrame({
            Parent = Items.TopBar.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -56, 0, 29),
            Size = UDim2.fromOffset(36, 14),
            Color = "Background",
            Round = 3,
            Z = 3
        })

        Library:Create("UIStroke", {
            Parent = Items.Version.Instance,
            Color = Library.Theme.Element,
            Thickness = 1
        }):AddToTheme({ Color = "Element" })

        MakeText({
            Parent = Items.Version.Instance,
            Text = "v" .. Library.Version,
            TextSize = 12,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "DimText",
            Align = Enum.TextXAlignment.Center,
            Z = 4
        })

        local function MakeAvatar(Parent, Props)
            local Avatar = Library:Create("ImageLabel", {
                Parent = Parent,
                Name = "\0",
                AnchorPoint = Props.Anchor or Vector2.new(0, 0),
                Position = Props.Pos,
                Size = UDim2.fromOffset(Props.Size, Props.Size),
                BackgroundColor3 = Library.Theme.Element,
                ZIndex = Props.Z,
                BorderSizePixel = 0,
                Image = "rbxthumb://type=AvatarHeadShot&id="
                .. LocalPlayer.UserId
                .. "&w=" .. Props.Res .. "&h=" .. Props.Res
            }):AddToTheme({ BackgroundColor3 = "Element" })

            Corner(Avatar.Instance, Props.Round)
            return Avatar
        end

        Items.Avatar = MakeAvatar(Items.TopBar.Instance, {
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -10, 0.5, 0),
            Size = 30,
            Res = 60,
            Round = 20,
            Z = 3
        })

        Items.ProfileHit = MakeButton({
            Parent = Items.TopBar.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -4, 0, 8),
            Size = UDim2.fromOffset(42, 36),
            Z = 5
        })

        local Profile = {
            IsOpen = false,
            Debounce = false
        }

        local ProfileW = 240

        local ProfilePanel = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(ProfileW, 272),
            Color = "Section",
            Round = 10,
            Z = 45
        })

        ProfilePanel.Instance.Visible = false

        MakeAvatar(ProfilePanel.Instance, {
            Pos = UDim2.fromOffset(14, 14),
            Size = 42,
            Res = 100,
            Round = 21,
            Z = 46
        })

        MakeText({
            Parent = ProfilePanel.Instance,
            Text = LocalPlayer.DisplayName,
            TextSize = 15,
            Pos = UDim2.fromOffset(68, 16),
            Size = UDim2.fromOffset(ProfileW - 82, 20),
            Color = "Text",
            Truncate = true,
            Z = 46
        })

        MakeText({
            Parent = ProfilePanel.Instance,
            Text = "@" .. LocalPlayer.Name,
            TextSize = 13,
            Pos = UDim2.fromOffset(68, 37),
            Size = UDim2.fromOffset(ProfileW - 82, 16),
            Color = "DimText",
            Truncate = true,
            Z = 46
        })

        local function ProfileDivider(Y)
            MakeFrame({
                Parent = ProfilePanel.Instance,
                Pos = UDim2.fromOffset(14, Y),
                Size = UDim2.fromOffset(ProfileW - 28, 1),
                Color = "Element",
                Z = 46
            })
        end

        local function ProfileStat(Y, Label, Value)
            MakeText({
                Parent = ProfilePanel.Instance,
                Text = Label,
                TextSize = 14,
                Pos = UDim2.fromOffset(14, Y),
                Size = UDim2.fromOffset(100, 18),
                Color = "DimText",
                Z = 46
            })

            MakeText({
                Parent = ProfilePanel.Instance,
                Text = Value,
                TextSize = 14,
                Anchor = Vector2.new(1, 0),
                Pos = UDim2.new(1, -14, 0, Y),
                Size = UDim2.fromOffset(120, 18),
                Color = "Text",
                Align = Enum.TextXAlignment.Right,
                Truncate = true,
                Z = 46
            })
        end

        ProfileDivider(68)
        ProfileStat(79, "User ID", tostring(LocalPlayer.UserId))
        ProfileStat(105, "Account age", tostring(LocalPlayer.AccountAge) .. " days")

        local IdHit = MakeButton({
            Parent = ProfilePanel.Instance,
            Pos = UDim2.fromOffset(10, 76),
            Size = UDim2.fromOffset(ProfileW - 20, 24),
            Z = 47
        })

        IdHit:Connect("MouseButton1Down", function()
            if setclipboard then
                pcall(setclipboard, tostring(LocalPlayer.UserId))
            end

            Library:Notification({
                Name = "User ID copied",
                Description = "Your user id is now in the clipboard.",
                Icon = "copy",
                Duration = 3
            })
        end)

        local RefreshProfilePos

        ProfileDivider(134)

        MakeText({
            Parent = ProfilePanel.Instance,
            Text = "Interface scale",
            TextSize = 14,
            Pos = UDim2.fromOffset(14, 146),
            Size = UDim2.fromOffset(140, 18),
            Color = "DimText",
            Z = 46
        })

        local ScaleValue = MakeText({
            Parent = ProfilePanel.Instance,
            Text = "100%",
            TextSize = 14,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -14, 0, 146),
            Size = UDim2.fromOffset(60, 18),
            Color = "Text",
            Align = Enum.TextXAlignment.Right,
            Z = 46
        })

        local ScaleTrack = MakeFrame({
            Parent = ProfilePanel.Instance,
            Pos = UDim2.fromOffset(14, 172),
            Size = UDim2.fromOffset(ProfileW - 28, 8),
            Color = "Light",
            Round = 20,
            Z = 46
        })

        local ScaleFill = MakeFrame({
            Parent = ScaleTrack.Instance,
            Size = UDim2.new(0.5, 0, 1, 0),
            Raw = Color3.new(1, 1, 1),
            Round = 20,
            Z = 47
        })

        Library:RegisterGradient(Library:Create("UIGradient", {
            Parent = ScaleFill.Instance
        }).Instance)

        local ScaleKnob = MakeFrame({
            Parent = ScaleTrack.Instance,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.fromOffset(12, 12),
            Raw = Color3.fromRGB(197, 197, 197),
            Round = 20,
            Z = 48
        })

        local ScaleHit = MakeButton({
            Parent = ProfilePanel.Instance,
            Pos = UDim2.fromOffset(8, 166),
            Size = UDim2.fromOffset(ProfileW - 16, 22),
            Z = 49
        })

        local ScaleGrab = false
        local ScalePercent = 100

        local function ApplyScale(Input)
            local Base = ScaleTrack.Instance
            local Span = (Input.Position.X - Base.AbsolutePosition.X) / Base.AbsoluteSize.X

            ScalePercent = Library:Round(50 + math.clamp(Span, 0, 1) * 100, 5)

            local Normal = (ScalePercent - 50) / 100

            ScaleValue.Instance.Text = tostring(ScalePercent) .. "%"
            ScaleFill.Instance.Size = UDim2.new(Normal, 0, 1, 0)
            ScaleKnob.Instance.Position = UDim2.new(Normal, 0, 0.5, 0)
        end

        ScaleHit:Connect("InputBegan", function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not IsClick and not IsTouch then return end

            ScaleGrab = true
            ApplyScale(Input)
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsClick or IsTouch) and ScaleGrab then
                ScaleGrab = false
                Library.UserScale = ScalePercent / 100
                UpdateScale()

                if RefreshProfilePos then RefreshProfilePos() end
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsMove or IsTouch) and ScaleGrab then
                ApplyScale(Input)
            end
        end)

        MakeText({
            Parent = ProfilePanel.Instance,
            Text = "Menu toggle",
            TextSize = 14,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 14, 0, 205),
            Size = UDim2.fromOffset(110, 20),
            Color = "DimText",
            Z = 46
        })

        local KeyIcon = MakeImage({
            Parent = ProfilePanel.Instance,
            Icon = "command",
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -14, 0, 205),
            Size = UDim2.fromOffset(16, 16),
            Color = "DimText",
            Z = 46
        })

        local KeyIconHit = MakeButton({
            Parent = ProfilePanel.Instance,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -8, 0, 205),
            Size = UDim2.fromOffset(26, 26),
            Z = 48
        })

        KeyIconHit:OnHover(function()
            KeyIcon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            KeyIcon:Tween({ ImageColor3 = Library.Theme.DimText })
        end)

        local KeyPanelW = 170

        local KeyPanel = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(KeyPanelW, 72),
            Color = "Section",
            Round = 8,
            Z = 46
        })

        KeyPanel.Instance.Visible = false

        MakeText({
            Parent = KeyPanel.Instance,
            Text = "Menu keybind",
            TextSize = 12,
            Pos = UDim2.fromOffset(11, 8),
            Size = UDim2.fromOffset(KeyPanelW - 22, 14),
            Color = "DimText",
            Truncate = true,
            Z = 47
        })

        local KeyBox = MakeFrame({
            Parent = KeyPanel.Instance,
            Pos = UDim2.fromOffset(9, 32),
            Size = UDim2.fromOffset(KeyPanelW - 18, 30),
            Color = "Light",
            Round = 5,
            Clip = true,
            Z = 47
        })

        local KeyText = MakeText({
            Parent = KeyBox.Instance,
            Text = KeyName(Library.MenuKeybind),
            TextSize = 13,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Truncate = true,
            Z = 48
        })

        local KeyBoxHit = MakeButton({
            Parent = KeyBox.Instance,
            Z = 49
        })

        local KeyState = {
            IsOpen = false,
            Debounce = false,
            Picking = false,
            Host = Profile
        }

        local function KeyPlace(Off)
            local Anchor = KeyIcon.Instance
            local PScale = Library:GetScreenScale()
            local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
            local PX = Right / PScale + 8 + (Off or 0)
            local PY = (Anchor.AbsolutePosition.Y + GuiInset) / PScale - 4

            return UDim2.fromOffset(PX, PY)
        end

        AttachPopup({
            Popup = KeyState,
            Frame = KeyPanel,
            Level = 46,
            GetAnchor = function()
                return KeyIconHit.Instance
            end,
            Place = KeyPlace,
            From = -6,
            To = 2,
            Retreat = RetreatLeft
        })

        KeyIconHit:Connect("MouseButton1Down", function()
            KeyState:SetOpen(not KeyState.IsOpen)
        end)

        KeyBoxHit:Connect("MouseButton1Click", function()
            if KeyState.Picking then return end

            KeyState.Picking = true
            Library.Binding = true
            KeyText.Instance.Text = ". . ."

            task.wait()

            local Connection

            Connection = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end

                Connection:Disconnect()

                if Input.KeyCode ~= Enum.KeyCode.Escape then
                    Library.MenuKeybind = Input.KeyCode
                end

                KeyText.Instance.Text = KeyName(Library.MenuKeybind)
                KeyState.Picking = false

                task.defer(function()
                    Library.Binding = false
                end)
            end)
        end)

        local UnloadButton = MakeFrame({
            Parent = ProfilePanel.Instance,
            Pos = UDim2.fromOffset(14, 236),
            Size = UDim2.fromOffset(ProfileW - 28, 28),
            Color = "Light",
            Round = 6,
            Clip = true,
            Z = 46
        })

        MakeText({
            Parent = UnloadButton.Instance,
            Text = "Unload",
            TextSize = 14,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Z = 47
        })

        local UnloadHit = MakeButton({
            Parent = UnloadButton.Instance,
            Z = 48
        })

        UnloadButton:OnHover(function()
            UnloadButton:Tween({ BackgroundColor3 = Library.Theme.Hover })
        end, function()
            UnloadButton:Tween({ BackgroundColor3 = Library.Theme.Light })
        end)

        UnloadHit:Connect("MouseButton1Down", function()
            Window:SetOpen(false)

            task.delay(Library.Animation.Time + 0.12, function()
                Library:Unload()
            end)
        end)

        local function ProfilePlace(Extra)
            local Anchor = Items.Avatar.Instance
            local PScale = Library:GetScreenScale()
            local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
            local X = Right / PScale - ProfileW
            local Y = Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset

            return UDim2.fromOffset(X, Y / PScale + (Extra or 0))
        end

        RefreshProfilePos = function()
            if Profile.IsOpen then
                ProfilePanel.Instance.Position = ProfilePlace(10)
            end
        end

        AttachPopup({
            Popup = Profile,
            Frame = ProfilePanel,
            Level = 45,
            GetAnchor = function()
                return Items.ProfileHit.Instance
            end,
            Place = ProfilePlace,
            From = -2,
            To = 10,
            HoldOpen = function()
                return KeyState.IsOpen
            end
        })

        Window.Profile = Profile

        Items.ProfileHit:Connect("MouseButton1Down", function()
            Profile:SetOpen(not Profile.IsOpen)
        end)

        Items.Content = MakeFrame({
            Parent = Items.Main.Instance,
            Pos = UDim2.fromOffset(15, 65),
            Size = UDim2.fromOffset(W - 30, H - 96),
            Clip = true,
            Z = 2
        })

        Window.Items = Items

        Items.Root:MakeDraggable(Items.Main.Instance)
        Items.Root:MakeDraggable(Items.Rail.Instance)

        table.insert(Library.Windows, Window)

        function Window:Center()
            local CScale = Library:GetScreenScale()
            local Vp = workspace.CurrentCamera.ViewportSize

            Items.Root.Instance.Position = UDim2.fromOffset(
                Vp.X / (2 * CScale) - RootW / 2,
                Vp.Y / (2 * CScale) - RootH / 2
            )
        end

        function Window:LayoutRail()
            local Count = #Window.Tabs
            local NewH = Count > 0 and (50 * Count + 10) or RailH
            local NewY = math.floor((H - NewH) / 2)

            Items.Rail.Instance.Size = UDim2.fromOffset(RailW, NewH)
            Items.Rail.Instance.Position = UDim2.fromOffset(0, NewY)
        end

        function Window:FitSubBar(Instant)
            local Tab = Window.Current
            if not Tab or not Tab.SubLayout then return end
            if #Tab.Subs == 0 then return end

            local ContentScale = Library:GetScreenScale()
            local Content = Tab.SubLayout.AbsoluteContentSize.X / ContentScale + 16

            if Content <= 16 then return end

            local Overflow = Content > MaxSubW
            local Target = math.min(Content, MaxSubW)
            local NewX = SubCenterX - math.floor(Target / 2)

            local Info = Instant and TweenInfo.new(0)
            or TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            Library:Tween({
                Position = UDim2.fromOffset(NewX, SubY),
                Size = UDim2.fromOffset(Target, SubH)
            }, Info, Items.SubBar.Instance)

            local Row = Tab.Items.SubRow.Instance
            Row.ScrollingEnabled = Overflow
            Row.ScrollBarThickness = Overflow and 3 or 0
        end

        function Window:LayoutSubBar(Instant)
            Window:FitSubBar(Instant)
        end

        function Window:SetOpen(Bool)
            Window.IsOpen = Bool

            if not Bool then
                Library:CloseAllPopups()
            end

            local Sub = Window.Current and Window.Current.Current
            if Sub and Sub.SnapVisible then
                Sub:SnapVisible()
            end

            if Bool and Window.PlayIntro then
                Window:PlayIntro()
            else
                Items.Root:FadeDescendants(Bool)
            end
        end

        Library:Connect(UserInputService.InputBegan, function(Input, Processed)
            if Processed or Library.Binding then return end

            if Input.KeyCode == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        local function RunSearch(Query)
            Query = string.lower(Query)

            for _, Data in Library.Searchables do
                if Data.Window ~= Window then continue end

                local Match = Query == ""
                or string.find(string.lower(Data.Name), Query, 1, true) ~= nil

                if not Match and Data.Section then
                    Match = string.find(string.lower(Data.Section.Name), Query, 1, true) ~= nil
                end

                Data.Visible = Match

                if Data.Section then
                    Data.Section.Dirty = true
                end
            end

            for _, Tab in Window.Tabs do
                for _, Sub in Tab.Subs do
                    for _, Section in Sub.Sections do
                        if Section.Dirty then
                            Section.Dirty = false
                            Section:Reflow()
                        end
                    end
                end
            end

            local Tab = Window.Current
            local Sub = Tab and Tab.Current

            if Sub and #Sub.Sections > 0 then
                local Sig = tostring(Sub)

                for _, Section in Sub.Sections do
                    for _, Data in Section.Rows do
                        Sig ..= Data.Visible ~= false and "1" or "0"
                    end
                end

                if Sig ~= Window.SearchSig then
                    Window.SearchSig = Sig
                    Sub:Show()
                end
            end
        end

        local SearchToken = 0

        Library:Connect(Items.SearchBox.Instance:GetPropertyChangedSignal("Text"), function()
            SearchToken += 1

            local Token = SearchToken

            task.delay(0.1, function()
                if Token ~= SearchToken then return end
                RunSearch(Items.SearchBox.Instance.Text)
            end)
        end)

        function Window:PlayIntro()
            local Base = Items.Root.Instance.Position
            local Rise = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            Items.Root.Instance.Position = UDim2.fromOffset(
                Base.X.Offset,
                Base.Y.Offset + 24
            )

            Items.Root:FadeDescendants(true)
            Library:Tween({ Position = Base }, Rise, Items.Root.Instance)
        end

        task.defer(function()
            Window:PlayIntro()
        end)

        return setmetatable(Window, Library)
    end

    Library.Tab = function(Self, Params)
        Params = Params or { }

        local Window = Self

        local Tab = {
            Name = Params.Name or "Tab",
            Icon = Params.Icon or "circle",
            Window = Window,
            Subs = { },
            Current = nil,
            Active = false,
            Items = { }
        }

        local Items = { }
        local Index = #Window.Tabs
        local RowY = 10 + Index * 50

        Items.Row = MakeFrame({
            Parent = Window.Items.Rail.Instance,
            Pos = UDim2.fromOffset(10, RowY),
            Size = UDim2.fromOffset(40, 40),
            Color = "Element",
            Round = 8,
            Clip = true,
            Z = 3
        })

        Items.Row.Instance.BackgroundTransparency = 1

        Items.Bar = MakeFrame({
            Parent = Window.Items.Rail.Instance,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 0, 0, RowY + 20),
            Size = UDim2.fromOffset(3, 0),
            Color = "Accent",
            Round = 4,
            Z = 4
        })

        Items.BarShadow = MakeAccentShadow(
            Items.Bar.Instance,
            UDim2.fromOffset(3, 15),
            UDim.new(0, 10),
            0
        )

        if Items.BarShadow then
            Items.BarShadow.Transparency = 1
        end

        Items.Icon = MakeImage({
            Parent = Items.Row.Instance,
            Icon = Tab.Icon,
            Pos = UDim2.fromOffset(10, 10),
            Size = UDim2.fromOffset(20, 20),
            Color = "DimIcon",
            Z = 4
        })

        Items.Hit = MakeButton({
            Parent = Items.Row.Instance,
            Z = 6
        })

        Items.SubRow = Library:Create("ScrollingFrame", {
            Parent = Window.Items.SubBar.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageColor3 = Library.Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.X,
            ScrollingEnabled = false,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            CanvasSize = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 21,
            BorderSizePixel = 0
        }):AddToTheme({ ScrollBarImageColor3 = "Accent" })

        Items.SubRow.Instance.Visible = false

        Items.SubLayout = Library:Create("UIListLayout", {
            Parent = Items.SubRow.Instance,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })

        Library:Create("UIPadding", {
            Parent = Items.SubRow.Instance,
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8)
        })

        Window.Items.Root:MakeDraggable(Items.SubRow.Instance)

        Tab.SubLayout = Items.SubLayout.Instance

        Library:Connect(Tab.SubLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            if Window.Current == Tab then
                Window:FitSubBar(true)
            end
        end)

        Tab.Items = Items

        function Tab:SetVisual(Active)
            Tab.Active = Active

            Library:StampResting(Items.Row.Instance, "BackgroundTransparency", Active and 0 or 1)

            if Items.BarShadow then
                Library:StampResting(Items.BarShadow, "Transparency", Active and 0 or 1)
                Items.BarShadow.Transparency = Active and 0 or 1
            end

            Items.Icon:ChangeItemTheme({ ImageColor3 = Active and "Accent" or "DimIcon" })
            Items.Icon:Tween({
                ImageColor3 = Active and Library.Theme.Accent or Library.Theme.DimIcon
            })

            Items.Row:Tween({ BackgroundTransparency = Active and 0 or 1 })
            Items.Bar:Tween({ Size = UDim2.fromOffset(3, Active and 16 or 0) })
        end

        Items.Row:OnHover(function()
            if Tab.Active then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            if Tab.Active then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.DimIcon })
        end)

        local function EnterFirstSub()
            local Sub = Tab.Current or Tab.Subs[1]
            if not Sub then return end

            Tab.Current = Sub

            for _, Other in Tab.Subs do
                Other:SetVisual(Other == Sub)
            end

            Sub:Show()
        end

        function Tab:Select()
            if Window.Current == Tab then return end

            Library:CloseAllPopups()

            if Window.Current then
                Window.Current:SetVisual(false)
                Window.Current.Items.SubRow.Instance.Visible = false

                if Window.Current.Current then
                    Window.Current.Current:Hide()
                end
            end

            Window.Current = Tab
            Tab:SetVisual(true)
            Items.SubRow.Instance.Visible = true

            EnterFirstSub()
            Window:LayoutSubBar()
        end

        Items.Hit:Connect("MouseButton1Down", function()
            Tab:Select()
        end)

        table.insert(Window.Tabs, Tab)
        Window:LayoutRail()

        if #Window.Tabs == 1 then
            Window.Current = Tab
            Tab:SetVisual(true)
            Items.SubRow.Instance.Visible = true

            task.defer(function()
                EnterFirstSub()
                Window:LayoutSubBar()
            end)
        end

        return setmetatable(Tab, Library)
    end

    Library.SubTab = function(Self, Params)
        Params = Params or { }

        local Tab = Self
        local Window = Tab.Window

        local SubTab = {
            Name = Params.Name or "SubTab",
            Icon = Params.Icon or "circle",
            Tab = Tab,
            Window = Window,
            Sections = { },
            Columns = { },
            Active = false,
            ShowToken = 0,
            Items = { }
        }

        local Items = { }
        local ContentW = Window.ContentW
        local ContentH = Window.ContentH
        local ColW = Window.ColW
        local Col2X = Window.Col2X

        local TextW = math.ceil(MeasureText(SubTab.Name, 15, 300, UiFont).X)
        local CollapsedW = 40
        local ExpandedW = 37 + TextW + 12

        SubTab.CollapsedW = CollapsedW
        SubTab.ExpandedW = ExpandedW

        Items.Pill = MakeFrame({
            Parent = Tab.Items.SubRow.Instance,
            Size = UDim2.fromOffset(CollapsedW, 30),
            Color = "Element",
            Round = 5,
            Clip = true,
            Z = 22
        })

        Items.Pill.Instance.BackgroundTransparency = 1
        Items.Pill.Instance.LayoutOrder = #Tab.Subs

        Items.Icon = MakeImage({
            Parent = Items.Pill.Instance,
            Icon = SubTab.Icon,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 11, 0.5, 0),
            Size = UDim2.fromOffset(18, 18),
            Color = "DimIcon",
            Z = 23
        })

        Items.Label = MakeText({
            Parent = Items.Pill.Instance,
            Text = SubTab.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 37, 0.5, 0),
            Size = UDim2.fromOffset(TextW + 8, 20),
            Color = "Text",
            Z = 23
        })

        Items.Label.Instance.TextTransparency = 1

        local function SyncWidth()
            local Bounds = math.ceil(Items.Label.Instance.TextBounds.X)
            if Bounds <= 0 then return end

            ExpandedW = 37 + Bounds + 12
            SubTab.ExpandedW = ExpandedW
            Items.Label.Instance.Size = UDim2.fromOffset(Bounds + 8, 20)

            if Tab.Current == SubTab then
                Items.Pill.Instance.Size = UDim2.fromOffset(ExpandedW, 30)
                Window:FitSubBar(true)
            end
        end

        Library:Connect(Items.Label.Instance:GetPropertyChangedSignal("TextBounds"), SyncWidth)
        task.defer(SyncWidth)

        Items.Hit = MakeButton({
            Parent = Items.Pill.Instance,
            Z = 25
        })

        Items.Page = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(ContentW, ContentH),
            Z = 3
        })

        Items.Page.Instance.Visible = false

        local function MakeColumn(X)
            local Scroll = Library:Create("ScrollingFrame", {
                Parent = Items.Page.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                ScrollBarThickness = 0,
                ScrollBarImageTransparency = 1,
                Selectable = false,
                Active = true,
                Position = UDim2.fromOffset(X, 0),
                Size = UDim2.fromOffset(ColW, ContentH),
                CanvasSize = UDim2.fromOffset(0, 0),
                ZIndex = 3,
                BorderSizePixel = 0
            })

            local Column = {
                Scroll = Scroll,
                Width = ColW,
                Sections = { }
            }

            function Column:Reflow()
                local Y = 0

                for _, Section in Column.Sections do
                    Section.Y = Y
                    Section.Items.Holder.Instance.Position = UDim2.fromOffset(0, Y)
                    Y += Section.Height + 16
                end

                Scroll.Instance.CanvasSize = UDim2.fromOffset(0, math.max(Y - 16, 0))
            end

            return Column
        end

        SubTab.Columns[1] = MakeColumn(0)
        SubTab.Columns[2] = MakeColumn(Col2X)
        SubTab.Items = Items

        function SubTab:SetVisual(Active, Instant)
            Library:StampResting(Items.Pill.Instance, "BackgroundTransparency", Active and 0 or 1)
            Library:StampResting(Items.Label.Instance, "TextTransparency", Active and 0 or 1)

            local Info = Instant and TweenInfo.new(0)
            or TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            local Width = Active and ExpandedW or CollapsedW

            Library:Tween({ Size = UDim2.fromOffset(Width, 30) }, Info, Items.Pill.Instance)
            Library:Tween({ TextTransparency = Active and 0 or 1 }, Info, Items.Label.Instance)

            Items.Icon:ChangeItemTheme({ ImageColor3 = Active and "Accent" or "DimIcon" })
            Items.Icon:Tween({
                ImageColor3 = Active and Library.Theme.Accent or Library.Theme.DimIcon
            }, Info)

            Items.Pill:Tween({ BackgroundTransparency = Active and 0 or 1 }, Info)
        end

        Items.Pill:OnHover(function()
            if Tab.Current == SubTab then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            if Tab.Current == SubTab then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.DimIcon })
        end)

        local RowIn = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local Sink = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        local PageSlide = 22
        local RowSlide = 18
        local SectionStep = 0.07
        local RowStep = 0.045

        local function ForEachSectionPart(Section, Handler)
            local Parts = Section.Items

            local Objects = {
                Parts.Header.Instance,
                Parts.HeaderFill.Instance,
                Parts.Label.Instance,
                Parts.Frame.Instance,
                Parts.BodyFill.Instance
            }

            for _, Object in Objects do
                local Properties = Library:GetTweenProperty(Object)
                if not Properties then continue end

                for _, Property in Properties do
                    Handler(Object, Property)
                end
            end
        end

        local function PrimeParts(Section)
            ForEachSectionPart(Section, function(Object, Property)
                Library:CaptureResting(Object, Property)
                Object[Property] = 1
            end)
        end

        local function RevealParts(Section)
            ForEachSectionPart(Section, function(Object, Property)
                local Resting = Library:CaptureResting(Object, Property)
                Library:Tween({ [Property] = Resting }, nil, Object)
            end)
        end

        local function ForEachRow(Handler)
            for _, Column in SubTab.Columns do
                for _, Section in Column.Sections do
                    for _, Data in Section.Rows do
                        Handler(Data, Section)
                    end
                end
            end
        end

        local function LayoutPage()
            for _, Column in SubTab.Columns do
                for _, Section in Column.Sections do
                    Section.Items.Holder.Instance.Position = UDim2.fromOffset(0, Section.Y)
                    Section.Items.Frame.Instance.Position = UDim2.fromOffset(0, 26)

                    for _, Data in Section.Rows do
                        Data.Frame:CancelFade()
                        Data.Frame.Instance.Visible = Data.Visible ~= false
                    end
                end
            end
        end

        local function CleanPage()
            Items.Page.Instance.Position = UDim2.fromOffset(0, 0)
            Items.Page:HardRestore()

            LayoutPage()

            ForEachRow(function(Data)
                Data.Frame.Instance.Position = UDim2.fromOffset(0, Data.Y)
            end)
        end

        function SubTab:Show()
            SubTab.ShowToken += 1

            local Token = SubTab.ShowToken
            SubTab.Active = true

            Items.Page:CancelFade()
            Items.Page.Instance.Parent = Window.Items.Content.Instance
            Items.Page.Instance.Position = UDim2.fromOffset(0, 0)
            Items.Page.Instance.Visible = true

            Library:SafeCall(SubTab.PageIntro)

            if #SubTab.Sections == 0 then return end

            LayoutPage()

            local Order = 0

            for _, Column in SubTab.Columns do
                for _, Section in Column.Sections do
                    Order += 1
                    PrimeParts(Section)

                    for _, Data in Section.Rows do
                        Data.Frame:CancelFade()
                        Data.Frame.Instance.Visible = false
                    end

                    local Slot = Order

                    task.delay((Slot - 1) * SectionStep, function()
                        if SubTab.ShowToken ~= Token or not SubTab.Active then return end

                        RevealParts(Section)

                        for RowIndex, Data in Section.Rows do
                            if Data.Visible == false then continue end

                            task.delay(RowIndex * RowStep, function()
                                local Home = UDim2.fromOffset(0, Data.Y)

                                Data.Frame.Instance.Visible = true

                                if SubTab.ShowToken ~= Token or not SubTab.Active then
                                    Data.Frame.Instance.Position = Home
                                    return
                                end

                                Data.Frame.Instance.Position = UDim2.fromOffset(RowSlide, Data.Y)
                                Library:Tween({ Position = Home }, RowIn, Data.Frame.Instance)
                                Data.Frame:FadeDescendants(true)
                            end)
                        end
                    end)
                end
            end
        end

        function SubTab:Hide(OnDone)
            SubTab.Active = false
            SubTab.ShowToken += 1

            local Token = SubTab.ShowToken

            Library:SafeCall(SubTab.PageOutro)

            ForEachRow(function(Data)
                Data.Frame:CancelFade()
            end)

            Library:Tween({
                Position = UDim2.fromOffset(-PageSlide, 0)
            }, Sink, Items.Page.Instance)

            Items.Page:FadeDescendants(false, function()
                if SubTab.ShowToken == Token and not SubTab.Active then
                    Items.Page:ResetFade()
                    CleanPage()

                    Items.Page.Instance.Visible = false
                    Items.Page.Instance.Parent = Library.UnusedHolder.Instance
                end

                if OnDone then Library:SafeCall(OnDone) end
            end)
        end

        function SubTab:SnapVisible()
            SubTab.ShowToken += 1
            SubTab.Active = true

            Items.Page:CancelFade()
            CleanPage()

            Items.Page.Instance.Visible = true
        end

        Items.Hit:Connect("MouseButton1Down", function()
            if Tab.Current == SubTab then return end

            Library:CloseAllPopups()

            if Tab.Current then
                Tab.Current:SetVisual(false)
                Tab.Current:Hide()
            end

            Tab.Current = SubTab
            SubTab:SetVisual(true)
            SubTab:Show()

            Window:LayoutSubBar()
        end)

        table.insert(Tab.Subs, SubTab)

        if #Tab.Subs == 1 then
            Tab.Current = SubTab
            SubTab:SetVisual(true, true)
        end

        if Window.Current == Tab then
            Window:LayoutSubBar()
        end

        return setmetatable(SubTab, Library)
    end

    Library.Section = function(Self, Params)
        Params = Params or { }

        local SubTab = Self
        local Side = Params.Side or 1

        if Side == "Right" then Side = 2 end
        if Side == "Left" then Side = 1 end

        local Column = SubTab.Columns[Side] or SubTab.Columns[1]

        local Section = {
            Name = Params.Name or "Section",
            SubTab = SubTab,
            Column = Column,
            Width = Column.Width,
            Y = 0,
            Height = 0,
            Rows = { },
            Dirty = false,
            Items = { }
        }

        local Items = { }

        Items.Holder = MakeFrame({
            Parent = Column.Scroll.Instance,
            Size = UDim2.fromOffset(Column.Width, 40),
            Z = 3
        })

        local HeaderTextW = math.ceil(MeasureText(Section.Name, 15, 240, UiFont).X)
        local HeaderW = HeaderTextW + 26

        Items.Header = MakeFrame({
            Parent = Items.Holder.Instance,
            Pos = UDim2.fromOffset(0, 1),
            Size = UDim2.fromOffset(HeaderW, 25),
            Color = "Section",
            Round = 10,
            Z = 3
        })

        Items.HeaderFill = MakeFrame({
            Parent = Items.Header.Instance,
            Pos = UDim2.fromOffset(0, 15),
            Size = UDim2.fromOffset(HeaderW, 10),
            Color = "Section",
            Z = 3
        })

        Items.Label = MakeText({
            Parent = Items.Header.Instance,
            Text = Section.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 13, 0.5, 1),
            Size = UDim2.fromOffset(HeaderTextW + 6, 20),
            Color = "Text",
            Z = 4
        })

        local function SyncHeader()
            local Bounds = math.ceil(Items.Label.Instance.TextBounds.X)
            if Bounds <= 0 then return end

            HeaderTextW = Bounds
            HeaderW = Bounds + 26

            Items.Label.Instance.Size = UDim2.fromOffset(Bounds + 6, 20)
            Items.Header.Instance.Size = UDim2.fromOffset(HeaderW, 25)
            Items.HeaderFill.Instance.Size = UDim2.fromOffset(HeaderW, 10)
        end

        Library:Connect(Items.Label.Instance:GetPropertyChangedSignal("TextBounds"), SyncHeader)
        task.defer(SyncHeader)

        Items.Frame = MakeFrame({
            Parent = Items.Holder.Instance,
            Pos = UDim2.fromOffset(0, 26),
            Size = UDim2.fromOffset(Column.Width, 14),
            Color = "Section",
            Round = 10,
            Z = 3
        })

        Items.BodyFill = MakeFrame({
            Parent = Items.Frame.Instance,
            Pos = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(10, 10),
            Color = "Section",
            Z = 3
        })

        Section.Items = Items

        function Section:Reflow()
            local Y = 8
            local Visible = 0

            for _, Data in Section.Rows do
                local Shown = Data.Visible ~= false

                Data.Frame.Instance.Visible = Shown

                if not Shown then continue end

                Data.Y = Y
                Data.Frame.Instance.Position = UDim2.fromOffset(0, Y)
                Y += Data.Height
                Visible += 1
            end

            local FrameHeight = Visible > 0 and (Y + 8) or 0

            Items.Frame.Instance.Size = UDim2.fromOffset(Section.Width, FrameHeight)
            Items.Holder.Instance.Visible = Visible > 0
            Section.Height = Visible > 0 and (26 + FrameHeight) or 0
            Items.Holder.Instance.Size = UDim2.fromOffset(Section.Width, math.max(Section.Height, 1))

            Column:Reflow()
        end

        function Section:AddRow(Height, SearchName)
            local Frame = MakeFrame({
                Parent = Items.Frame.Instance,
                Size = UDim2.fromOffset(Section.Width, Height),
                Z = 4
            })

            local Data = {
                Frame = Frame,
                Height = Height,
                Y = 0,
                Visible = true,
                Name = SearchName or Section.Name,
                Section = Section,
                Window = SubTab.Window
            }

            table.insert(Section.Rows, Data)
            table.insert(Library.Searchables, Data)

            Section:Reflow()
            return Frame, Data
        end

        table.insert(SubTab.Sections, Section)
        table.insert(Column.Sections, Section)
        Section:Reflow()

        return setmetatable(Section, Library)
    end

    Library.Toggle = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Toggle = {
            Name = Params.Name or "Toggle",
            Default = Params.Default or false,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = false,
            Visual = nil,
            Token = 0,
            Items = { }
        }

        local Row = Section:AddRow(32, Toggle.Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Toggle.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 15, 0.5, 0),
            Size = UDim2.fromOffset(Section.Width - 80, 20),
            Color = "DimText",
            Truncate = true,
            Z = 5
        })

        Items.Box = MakeFrame({
            Parent = Row.Instance,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -15, 0.5, 0),
            Size = UDim2.fromOffset(35, 21),
            Color = "Element",
            Round = 10,
            Clip = true,
            Z = 5
        })

        Items.Circle = MakeFrame({
            Parent = Items.Box.Instance,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 4, 0.5, 0),
            Size = UDim2.fromOffset(13, 13),
            Color = "DimText",
            Round = 20,
            Z = 6
        })

        MakeAccentShadow(
            Items.Circle.Instance,
            UDim2.fromOffset(3, 3),
            UDim.new(0, 5),
            0.7
        )

        Items.Hit = MakeButton({
            Parent = Row.Instance,
            Size = UDim2.new(1, 0, 1, 0),
            Z = 8
        })

        Toggle.Items = Items

        local Pad = 4
        local InnerW = 35 - Pad * 2
        local LeftPos = UDim2.new(0, Pad, 0.5, 0)
        local RightPos = UDim2.new(1, -Pad, 0.5, 0)
        local Small = UDim2.fromOffset(13, 13)

        function Toggle.SetVisual(State, Instant)
            State = State and true or false
            if Toggle.Visual == State then return end
            Toggle.Visual = State

            Toggle.Token += 1
            local Token = Toggle.Token

            local BoxColor = State and "Light" or "Element"
            local CircleKey = State and "Accent" or "DimText"
            local CircleColor = Library.Theme[CircleKey]
            local LabelColor = State and "Text" or "DimText"

            local StartAnchor = State and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
            local StartPos = State and LeftPos or RightPos
            local EndAnchor = State and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
            local EndPos = State and RightPos or LeftPos

            Items.Box:ChangeItemTheme({ BackgroundColor3 = BoxColor })
            Items.Label:ChangeItemTheme({ TextColor3 = LabelColor })
            Items.Circle:ChangeItemTheme({ BackgroundColor3 = CircleKey })

            if Instant then
                Items.Box.Instance.BackgroundColor3 = Library.Theme[BoxColor]
                Items.Label.Instance.TextColor3 = Library.Theme[LabelColor]
                Items.Circle.Instance.BackgroundColor3 = CircleColor
                Items.Circle.Instance.Size = Small
                Items.Circle.Instance.AnchorPoint = EndAnchor
                Items.Circle.Instance.Position = EndPos
                return
            end

            local Grow = TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local Snap = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local Fade = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            Library:Tween({ BackgroundColor3 = Library.Theme[BoxColor] }, Fade, Items.Box.Instance)
            Library:Tween({ TextColor3 = Library.Theme[LabelColor] }, Fade, Items.Label.Instance)
            Library:Tween({ BackgroundColor3 = CircleColor }, Fade, Items.Circle.Instance)

            Items.Circle.Instance.AnchorPoint = StartAnchor
            Items.Circle.Instance.Position = StartPos
            Library:Tween({ Size = UDim2.fromOffset(InnerW, 13) }, Grow, Items.Circle.Instance)

            task.delay(0.08, function()
                if Toggle.Token ~= Token then return end

                Items.Circle.Instance.AnchorPoint = EndAnchor
                Items.Circle.Instance.Position = EndPos
                Library:Tween({ Size = Small }, Snap, Items.Circle.Instance)
            end)
        end

        function Toggle:Set(Bool)
            Toggle.Value = Bool and true or false

            if Toggle.Flag then
                Library.Flags[Toggle.Flag] = Toggle.Value
            end

            Toggle.SetVisual(Toggle.Value, false)
            Library:SafeCall(Toggle.Callback, Toggle.Value)
        end

        function Toggle:Get()
            return Toggle.Value
        end

        Items.Hit:Connect("MouseButton1Down", function()
            Toggle:Set(not Toggle.Value)
        end)

        Toggle.SlotX = -58

        local function TakeSlot(Width)
            local X = Toggle.SlotX
            Toggle.SlotX -= Width + 8
            Items.Label.Instance.Size = UDim2.fromOffset(Section.Width + Toggle.SlotX - 15, 20)
            return X
        end

        local function SlotIcon(X, Icon)
            local Glyph = MakeImage({
                Parent = Row.Instance,
                Icon = Icon,
                Anchor = Vector2.new(1, 0.5),
                Pos = UDim2.new(1, X, 0.5, 0),
                Size = UDim2.fromOffset(16, 16),
                Color = "DimText",
                Z = 6
            })

            local Hit = MakeButton({
                Parent = Row.Instance,
                Anchor = Vector2.new(1, 0.5),
                Pos = UDim2.new(1, X + 2, 0.5, 0),
                Size = UDim2.fromOffset(22, 22),
                Z = 9
            })

            Hit:OnHover(function()
                Glyph:Tween({ ImageColor3 = Library.Theme.Text })
            end, function()
                Glyph:Tween({ ImageColor3 = Library.Theme.DimText })
            end)

            return Glyph, Hit
        end

        local function SidePlace(Anchor)
            return function(Off)
                local PScale = Library:GetScreenScale()
                local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
                local PX = Right / PScale + 8 + (Off or 0)
                local PY = (Anchor.AbsolutePosition.Y + GuiInset) / PScale - 4

                return UDim2.fromOffset(PX, PY)
            end
        end

        function Toggle:Colorpicker(CParams)
            CParams = CParams or { }

            local Picker = {
                Color = CParams.Default or Library.Theme.Accent,
                Transparency = CParams.Transparency or 0
            }

            local X = TakeSlot(22)
            local Swatch = MakeSwatch(Row.Instance, X, Picker.Color, 6)

            local Inner = MakeColorPopup(function()
                return Swatch.Halo.Instance
            end, CParams.Name or Toggle.Name, Picker.Color, Picker.Transparency, function(Color, Alpha)
                Picker.Color = Color
                Picker.Transparency = Alpha
                Swatch:SetColor(Color, Alpha)

                if CParams.Flag then
                    Library.Flags[CParams.Flag] = {
                        __color = Color:ToHex(),
                        __alpha = Alpha
                    }
                end

                Library:SafeCall(CParams.Callback, Color, Alpha)
            end)

            Swatch.Hit:Connect("MouseButton1Down", function()
                Inner:SetOpen(not Inner.IsOpen)
            end)

            if CParams.Flag then
                Library.SetFlags[CParams.Flag] = function(Color, Alpha)
                    Inner:Set(Color, Alpha)
                end
            end

            function Picker:Set(Color, Alpha)
                Inner:Set(Color, Alpha)
            end

            Picker.Picker = Inner
            return Picker
        end

        function Toggle:Keybind(KParams)
            KParams = KParams or { }

            local Keybind = {
                Key = KParams.Default,
                Mode = KParams.Mode or "Toggle",
                Flag = KParams.Flag,
                Picking = false,
                IsOpen = false,
                Debounce = false
            }

            local X = TakeSlot(20)
            local BindIcon, BindHit = SlotIcon(X, "command")

            local PanelW = 160

            local Panel = MakeFrame({
                Parent = Library.UnusedHolder.Instance,
                Size = UDim2.fromOffset(PanelW, 128),
                Color = "Section",
                Round = 8,
                Z = 40
            })

            Panel.Instance.Visible = false

            MakeText({
                Parent = Panel.Instance,
                Text = "Keybind",
                TextSize = 12,
                Pos = UDim2.fromOffset(11, 7),
                Size = UDim2.fromOffset(PanelW - 22, 14),
                Color = "DimText",
                Z = 41
            })

            local KeyBox = MakeFrame({
                Parent = Panel.Instance,
                Pos = UDim2.fromOffset(8, 26),
                Size = UDim2.fromOffset(PanelW - 16, 26),
                Color = "Light",
                Round = 5,
                Z = 41
            })

            local PanelKey = MakeText({
                Parent = KeyBox.Instance,
                Text = "None",
                TextSize = 13,
                Size = UDim2.new(1, 0, 1, 0),
                Color = "Text",
                Align = Enum.TextXAlignment.Center,
                Truncate = true,
                Z = 42
            })

            local KeyHit = MakeButton({
                Parent = KeyBox.Instance,
                Z = 43
            })

            local ModeRows = { }

            local function ModeRow(Y, ModeName)
                local Built = MakeAccentRow({
                    Parent = Panel.Instance,
                    Pos = UDim2.fromOffset(8, Y),
                    Size = UDim2.fromOffset(PanelW - 16, 28),
                    Color = "Element",
                    Text = ModeName,
                    TextSize = 13,
                    LabelSize = UDim2.new(1, -18, 1, 0),
                    LineX = 6,
                    LineH = 14,
                    TextX = 10,
                    TextActiveX = 17,
                    SnapShadow = true,
                    Z = 41
                })

                Built.Hit:Connect("MouseButton1Down", function()
                    Keybind:SetMode(ModeName)
                end)

                table.insert(ModeRows, {
                    Name = ModeName,
                    SetActive = Built.SetActive
                })
            end

            ModeRow(60, "Toggle")
            ModeRow(92, "Hold")

            local function SaveFlag()
                if not Keybind.Flag then return end

                Library.Flags[Keybind.Flag] = {
                    Key = Keybind.Key and tostring(Keybind.Key) or "None",
                    Mode = Keybind.Mode
                }
            end

            function Keybind:SetMode(Mode, Instant)
                Keybind.Mode = Mode

                for _, Data in ModeRows do
                    Data.SetActive(Data.Name == Mode, Instant)
                end

                SaveFlag()
            end

            function Keybind:Set(Key)
                Keybind.Key = Key
                PanelKey.Instance.Text = KeyName(Key)
                Keybind.Picking = false

                SaveFlag()
            end

            AttachPopup({
                Popup = Keybind,
                Frame = Panel,
                Level = 40,
                GetAnchor = function()
                    return BindHit.Instance
                end,
                Place = SidePlace(BindIcon.Instance),
                From = -6,
                To = 2,
                Retreat = RetreatLeft
            })

            BindHit:Connect("MouseButton1Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            KeyHit:Connect("MouseButton1Click", function()
                CaptureKey(Keybind, PanelKey.Instance, function(Key)
                    Keybind:Set(Key)
                end)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input, Processed)
                if Processed or Keybind.Picking or not Keybind.Key then return end
                if not KeyMatches(Input, Keybind.Key) then return end

                if Keybind.Mode == "Hold" then
                    Toggle:Set(true)
                else
                    Toggle:Set(not Toggle.Value)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Keybind.Mode ~= "Hold" or not Keybind.Key then return end
                if not KeyMatches(Input, Keybind.Key) then return end

                Toggle:Set(false)
            end)

            if Keybind.Flag then
                Library.SetFlags[Keybind.Flag] = function(Value)
                    if type(Value) == "table" then
                        if Value.Mode then Keybind:SetMode(Value.Mode, true) end
                        Value = Value.Key
                    end

                    Keybind:Set(ParseKey(Value))
                end
            end

            Keybind:SetMode(Keybind.Mode, true)
            Keybind:Set(Keybind.Key)

            return Keybind
        end

        function Toggle:Extra(EParams)
            EParams = EParams or { }

            if Toggle.ExtraPanel then
                return Toggle.ExtraPanel
            end

            local Extra = {
                IsOpen = false,
                Debounce = false,
                NextY = 30,
                Width = EParams.Width or 220
            }

            local X = TakeSlot(20)
            local ExtraIcon, ExtraHit = SlotIcon(X, "settings-2")

            local Frame = MakeFrame({
                Parent = Library.UnusedHolder.Instance,
                Size = UDim2.fromOffset(Extra.Width, 38),
                Color = "Section",
                Round = 8,
                Z = 2
            })

            Frame.Instance.Visible = false

            MakeText({
                Parent = Frame.Instance,
                Text = Toggle.Name,
                TextSize = 12,
                Pos = UDim2.fromOffset(12, 8),
                Size = UDim2.fromOffset(Extra.Width - 24, 14),
                Color = "DimText",
                Truncate = true,
                Z = 3
            })

            local ChildDim = MakeFrame({
                Parent = Frame.Instance,
                Size = UDim2.new(1, 0, 1, 0),
                Raw = Color3.new(0, 0, 0),
                Alpha = 1,
                Round = 8,
                Z = 30
            })

            ChildDim.Instance.Visible = false
            Library:StampResting(ChildDim.Instance, "BackgroundTransparency", 1)

            local DimShown = false

            function Extra.SetChildDim(Bool)
                if DimShown == Bool then return end
                DimShown = Bool

                local Info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local Target = Bool and 0.5 or 1

                Library:StampResting(ChildDim.Instance, "BackgroundTransparency", Target)

                if Bool then
                    ChildDim.Instance.Visible = true
                end

                Library:Tween({ BackgroundTransparency = Target }, Info, ChildDim.Instance)

                if Bool then return end

                task.delay(0.24, function()
                    if not DimShown then ChildDim.Instance.Visible = false end
                end)
            end

            function Extra:AddRow(Height, SearchName)
                local RowFrame = MakeFrame({
                    Parent = Frame.Instance,
                    Pos = UDim2.fromOffset(0, Extra.NextY),
                    Size = UDim2.fromOffset(Extra.Width, Height),
                    Z = 3
                })

                local Data = {
                    Frame = RowFrame,
                    Height = Height,
                    Y = Extra.NextY,
                    Visible = true,
                    Name = SearchName or Toggle.Name
                }

                Extra.NextY += Height
                Frame.Instance.Size = UDim2.fromOffset(Extra.Width, Extra.NextY + 8)

                return RowFrame, Data
            end

            local function HasOpenChild()
                for _, Value in Library.OpenFrames do
                    if Value.Host == Extra then return true end
                end

                return false
            end

            AttachPopup({
                Popup = Extra,
                Frame = Frame,
                Level = 2,
                GetAnchor = function()
                    return ExtraHit.Instance
                end,
                Place = SidePlace(ExtraIcon.Instance),
                From = -6,
                To = 2,
                Retreat = RetreatLeft,
                KeepOpen = function(Value)
                    return Value == Extra or Value.Host == Extra
                end,
                HoldOpen = HasOpenChild,
                OnClose = function()
                    for _, Value in Library.OpenFrames do
                        if Value.Host == Extra then Value:SetOpen(false) end
                    end
                end
            })

            ExtraHit:Connect("MouseButton1Down", function()
                Extra:SetOpen(not Extra.IsOpen)
            end)

            setmetatable(Extra, {
                __index = function(_, Key)
                    local Builder = Library[Key]
                    if type(Builder) ~= "function" then return nil end

                    return function(SelfArg, BuildParams)
                        local Element = Builder(SelfArg, BuildParams)

                        if type(Element) == "table" then
                            if rawget(Element, "Popup") then Element.Popup.Host = Extra end
                            if rawget(Element, "Picker") then Element.Picker.Host = Extra end
                        end

                        return Element
                    end
                end
            })

            Toggle.ExtraPanel = Extra
            return Extra
        end

        Toggle.Value = Toggle.Default

        if Toggle.Flag then
            Library.Flags[Toggle.Flag] = Toggle.Value

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end
        end

        Toggle.SetVisual(Toggle.Value, true)
        Library:SafeCall(Toggle.Callback, Toggle.Value)

        return setmetatable(Toggle, Library)
    end

    local SlideInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local KnobColor = Color3.fromRGB(197, 197, 197)

    local function MakeKnob(Parent)
        local Knob = MakeFrame({
            Parent = Parent,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(13, 13),
            Raw = KnobColor,
            Round = 20,
            Z = 7
        })

        MakeShadow(Knob.Instance, KnobColor, UDim2.fromOffset(0, 0), UDim.new(0, 5), 0.5)
        return Knob
    end

    local function BuildSliderRow(Section, Name, SearchName)
        local Row = Section:AddRow(44, SearchName or Name)
        local Width = Section.Width
        local TrackW = Width - 30
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Name,
            TextSize = 15,
            Pos = UDim2.fromOffset(15, 3),
            Size = UDim2.fromOffset(Width - 120, 20),
            Color = "Text",
            Truncate = true,
            Z = 5
        })

        Items.Value = MakeText({
            Parent = Row.Instance,
            Text = "",
            TextSize = 15,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -15, 0, 3),
            Size = UDim2.fromOffset(100, 20),
            Color = "DimText",
            Align = Enum.TextXAlignment.Right,
            Truncate = true,
            Z = 5
        })

        Items.Track = MakeFrame({
            Parent = Row.Instance,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 15, 0, 32),
            Size = UDim2.fromOffset(TrackW, 10),
            Color = "Element",
            Round = 20,
            Z = 5
        })

        Items.Fill = MakeFrame({
            Parent = Items.Track.Instance,
            Size = UDim2.fromOffset(0, 10),
            Raw = Color3.new(1, 1, 1),
            Round = 20,
            Z = 6
        })

        Library:RegisterGradient(Library:Create("UIGradient", {
            Parent = Items.Fill.Instance
        }).Instance)

        Items.Hit = MakeButton({
            Parent = Row.Instance,
            Pos = UDim2.fromOffset(9, 22),
            Size = UDim2.fromOffset(TrackW + 12, 22),
            Z = 8
        })

        Items.TrackWidth = TrackW
        return Items
    end

    Library.Slider = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Slider = {
            Name = Params.Name or "Slider",
            Min = Params.Min or 0,
            Max = Params.Max or 100,
            Default = Params.Default or 0,
            Decimals = Params.Decimals or 1,
            Suffix = Params.Suffix or "",
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = 0,
            Sliding = false
        }

        local Items = BuildSliderRow(Section, Slider.Name)
        local TrackW = Items.TrackWidth

        Slider.Items = Items
        Items.Knob = MakeKnob(Items.Track.Instance)

        function Slider:Set(Value, Instant)
            local Clamped = math.clamp(Value, Slider.Min, Slider.Max)
            Slider.Value = Library:Round(Clamped, Slider.Decimals)

            if Slider.Flag then
                Library.Flags[Slider.Flag] = Slider.Value
            end

            local Span = Slider.Max - Slider.Min
            local Fraction = Span == 0 and 0 or (Slider.Value - Slider.Min) / Span
            local Info = Instant and TweenInfo.new(0) or SlideInfo

            Library:Tween({ Size = UDim2.fromOffset(Fraction * TrackW, 10) }, Info, Items.Fill.Instance)
            Library:Tween({ Position = UDim2.new(Fraction, 0, 0.5, 0) }, Info, Items.Knob.Instance)

            Items.Value.Instance.Text = tostring(Slider.Value) .. Slider.Suffix
            Library:SafeCall(Slider.Callback, Slider.Value)
        end

        function Slider:Get()
            return Slider.Value
        end

        local function Calculate(Input)
            local Fraction = AxisFraction(Input, Items.Track.Instance, "X")
            return Slider.Min + (Slider.Max - Slider.Min) * Fraction
        end

        local function Apply(Input)
            Slider:Set(Calculate(Input))
        end

        AttachDrag(Items.Hit, {
            OnGrab = function(Input)
                Slider.Sliding = true
                Apply(Input)
            end,
            OnMove = Apply,
            OnRelease = function()
                Slider.Sliding = false
            end
        })

        Slider:Set(Slider.Default, true)

        if Slider.Flag then
            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end
        end

        return setmetatable(Slider, Library)
    end

    Library.RangeSlider = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Slider = {
            Name = Params.Name or "Range",
            Min = Params.Min or 0,
            Max = Params.Max or 100,
            Default = Params.Default,
            Decimals = Params.Decimals or 1,
            Suffix = Params.Suffix or "",
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = { 0, 0 },
            Grabbing = nil
        }

        Slider.MinGap = Params.MinGap or Slider.Decimals
        Slider.Default = Slider.Default or { Slider.Min, Slider.Max }

        local Items = BuildSliderRow(Section, Slider.Name)
        local TrackW = Items.TrackWidth

        Slider.Items = Items
        Items.MinKnob = MakeKnob(Items.Track.Instance)
        Items.MaxKnob = MakeKnob(Items.Track.Instance)

        local function Normalize(Value)
            local Span = Slider.Max - Slider.Min
            return Span == 0 and 0 or (Value - Slider.Min) / Span
        end

        function Slider:Set(MinValue, MaxValue, Instant)
            if type(MinValue) == "table" then
                MinValue, MaxValue = MinValue[1], MinValue[2]
            end

            MinValue = math.clamp(MinValue or Slider.Min, Slider.Min, Slider.Max)
            MaxValue = math.clamp(MaxValue or Slider.Max, Slider.Min, Slider.Max)

            MinValue = Library:Round(MinValue, Slider.Decimals)
            MaxValue = Library:Round(MaxValue, Slider.Decimals)

            if MinValue > MaxValue then
                MinValue, MaxValue = MaxValue, MinValue
            end

            Slider.Value = { MinValue, MaxValue }

            if Slider.Flag then
                Library.Flags[Slider.Flag] = Slider.Value
            end

            local MinF = Normalize(MinValue)
            local MaxF = Normalize(MaxValue)
            local Info = Instant and TweenInfo.new(0) or SlideInfo

            Library:Tween({
                Position = UDim2.fromOffset(MinF * TrackW, 0),
                Size = UDim2.fromOffset((MaxF - MinF) * TrackW, 10)
            }, Info, Items.Fill.Instance)

            Library:Tween({ Position = UDim2.new(MinF, 0, 0.5, 0) }, Info, Items.MinKnob.Instance)
            Library:Tween({ Position = UDim2.new(MaxF, 0, 0.5, 0) }, Info, Items.MaxKnob.Instance)

            local Text = tostring(MinValue) .. Slider.Suffix
            Text = Text .. " - " .. tostring(MaxValue) .. Slider.Suffix

            Items.Value.Instance.Text = Text
            Library:SafeCall(Slider.Callback, Slider.Value)
        end

        function Slider:Get()
            return Slider.Value
        end

        local function Apply(Input)
            local Point = AxisFraction(Input, Items.Track.Instance, "X")
            local Value = Slider.Min + (Slider.Max - Slider.Min) * Point

            if Slider.Grabbing == "Min" then
                Slider:Set(math.min(Value, Slider.Value[2] - Slider.MinGap), Slider.Value[2])
            else
                Slider:Set(Slider.Value[1], math.max(Value, Slider.Value[1] + Slider.MinGap))
            end
        end

        AttachDrag(Items.Hit, {
            OnGrab = function(Input)
                local Point = AxisFraction(Input, Items.Track.Instance, "X")
                local MinF = Normalize(Slider.Value[1])
                local MaxF = Normalize(Slider.Value[2])

                Slider.Grabbing = math.abs(Point - MinF) <= math.abs(Point - MaxF) and "Min" or "Max"
                Apply(Input)
            end,
            OnMove = Apply,
            OnRelease = function()
                Slider.Grabbing = nil
            end
        })

        Slider:Set(Slider.Default[1], Slider.Default[2], true)

        if Slider.Flag then
            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end
        end

        return setmetatable(Slider, Library)
    end

    local function MakeFieldRow(Section, Name, SearchName)
        local Row = Section:AddRow(54, SearchName or Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Name,
            TextSize = 15,
            Pos = UDim2.fromOffset(15, 4),
            Size = UDim2.fromOffset(Section.Width - 30, 18),
            Color = "DimText",
            Truncate = true,
            Z = 5
        })

        Items.Box = MakeFrame({
            Parent = Row.Instance,
            Pos = UDim2.fromOffset(15, 24),
            Size = UDim2.fromOffset(Section.Width - 30, 30),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 5
        })

        return Items
    end

    local function MakeSweep(Parent, Z)
        local Sweep = MakeFrame({
            Parent = Parent,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 1, 0),
            Color = "Accent",
            Round = 6,
            Z = Z
        })

        Sweep.Instance.BackgroundTransparency = 1
        Library:StampResting(Sweep.Instance, "BackgroundTransparency", 1)

        return Sweep
    end

    local function PlaySweep(Sweep)
        local In = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local Out = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        Sweep.Size = UDim2.new(0, 0, 1, 0)
        Sweep.BackgroundTransparency = 1

        Library:Tween({
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.15
        }, In, Sweep)

        task.delay(0.17, function()
            Library:Tween({
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundTransparency = 1
            }, Out, Sweep)
        end)
    end

    local function HoverSwap(Frame)
        Frame:OnHover(function()
            Frame:Tween({ BackgroundColor3 = Library.Theme.Hover })
        end, function()
            Frame:Tween({ BackgroundColor3 = Library.Theme.Element })
        end)
    end

    Library.Dropdown = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Dropdown = {
            Name = Params.Name or "Dropdown",
            Options = Params.Items or Params.Options or { },
            Default = Params.Default,
            Multi = Params.Multi or false,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = nil,
            Items = { }
        }

        if Dropdown.Multi then
            Dropdown.Value = { }
        end

        local Items = MakeFieldRow(Section, Dropdown.Name)

        Items.Selected = MakeText({
            Parent = Items.Box.Instance,
            Text = "None",
            TextSize = 15,
            Pos = UDim2.fromOffset(11, 0),
            Size = UDim2.new(1, -34, 1, 0),
            Color = "Text",
            Truncate = true,
            Z = 6
        })

        Items.Arrow = MakeImage({
            Parent = Items.Box.Instance,
            Icon = "chevron-down",
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.fromOffset(14, 14),
            Color = "DimText",
            Z = 6
        })

        Items.Hit = MakeButton({
            Parent = Items.Box.Instance,
            Z = 7
        })

        Dropdown.Items = Items

        local Popup = MakeOptionPopup(function()
            return Items.Box.Instance
        end)

        Popup.OnState = function(Open)
            Items.Arrow:Tween({ Rotation = Open and 180 or 0 })
        end

        Dropdown.Popup = Popup

        local function Report()
            if Dropdown.Flag then
                Library.Flags[Dropdown.Flag] = Dropdown.Value
            end

            if Dropdown.Multi then
                Items.Selected.Instance.Text = #Dropdown.Value > 0
                and table.concat(Dropdown.Value, ", ")
                or "None"
            else
                Items.Selected.Instance.Text = Dropdown.Value ~= nil
                and tostring(Dropdown.Value)
                or "None"
            end

            Library:SafeCall(Dropdown.Callback, Dropdown.Value)
        end

        Popup.OnPick = function(Data)
            if Dropdown.Multi then
                local Index = table.find(Dropdown.Value, Data.Name)

                if Index then
                    table.remove(Dropdown.Value, Index)
                    Data:Set(false)
                else
                    table.insert(Dropdown.Value, Data.Name)
                    Data:Set(true)
                end
            else
                Dropdown.Value = Data.Name

                for _, Other in Popup.Order do
                    Other:Set(Other == Data)
                end
            end

            Report()
        end

        function Dropdown:Refresh(List)
            Popup:Clear()
            Dropdown.Options = List

            for _, Option in List do
                Popup:AddRow(tostring(Option))
            end
        end

        function Dropdown:Set(Value)
            if Dropdown.Multi then
                if type(Value) ~= "table" then return end

                Dropdown.Value = Value

                for _, Data in Popup.Order do
                    Data:Set(table.find(Value, Data.Name) ~= nil, true)
                end
            else
                local Found = false

                for _, Data in Popup.Order do
                    if Data.Name == Value then Found = true end
                end

                if not Found then return end

                Dropdown.Value = Value

                for _, Data in Popup.Order do
                    Data:Set(Data.Name == Value, true)
                end
            end

            Report()
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        Items.Hit:Connect("MouseButton1Down", function()
            Popup:SetOpen(not Popup.IsOpen)
        end)

        HoverSwap(Items.Box)

        for _, Option in Dropdown.Options do
            Popup:AddRow(tostring(Option))
        end

        if Dropdown.Default ~= nil then
            Dropdown:Set(Dropdown.Default)
        end

        if Dropdown.Flag then
            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end
        end

        return setmetatable(Dropdown, Library)
    end

    Library.Button = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Button = {
            Name = Params.Name or "Button",
            Callback = Params.Callback or function() end,
            Items = { }
        }

        local Row = Section:AddRow(36, Button.Name)
        local Items = { Row = Row }

        Items.Frame = MakeFrame({
            Parent = Row.Instance,
            Pos = UDim2.fromOffset(15, 3),
            Size = UDim2.fromOffset(Section.Width - 30, 30),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 5
        })

        Items.Sweep = MakeSweep(Items.Frame.Instance, 6)

        Items.Label = MakeText({
            Parent = Items.Frame.Instance,
            Text = Button.Name,
            TextSize = 15,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Truncate = true,
            Z = 7
        })

        Items.Hit = MakeButton({
            Parent = Items.Frame.Instance,
            Z = 8
        })

        Button.Items = Items
        HoverSwap(Items.Frame)

        function Button:Press()
            PlaySweep(Items.Sweep.Instance)
            Library:SafeCall(Button.Callback)
        end

        function Button:SetText(Text)
            Items.Label.Instance.Text = tostring(Text)
        end

        Items.Hit:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return setmetatable(Button, Library)
    end

    Library.Textbox = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Textbox = {
            Name = Params.Name or "Textbox",
            Default = Params.Default or "",
            Placeholder = Params.Placeholder or "...",
            Finished = Params.Finished or false,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = "",
            Items = { }
        }

        local Items = MakeFieldRow(Section, Textbox.Name)

        Items.Input = MakeInput({
            Parent = Items.Box.Instance,
            Placeholder = Textbox.Placeholder,
            Pos = UDim2.fromOffset(11, 0),
            Size = UDim2.new(1, -22, 1, 0),
            TextSize = 15,
            Z = 6
        })

        Textbox.Items = Items

        function Textbox:Set(Value)
            Textbox.Value = tostring(Value)
            Items.Input.Instance.Text = Textbox.Value

            if Textbox.Flag then
                Library.Flags[Textbox.Flag] = Textbox.Value
            end

            Library:SafeCall(Textbox.Callback, Textbox.Value)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        if Textbox.Finished then
            Items.Input:Connect("FocusLost", function(Enter)
                if Enter then
                    Textbox:Set(Items.Input.Instance.Text)
                end
            end)
        else
            Library:Connect(Items.Input.Instance:GetPropertyChangedSignal("Text"), function()
                Textbox:Set(Items.Input.Instance.Text)
            end)
        end

        if Textbox.Default ~= "" then
            Textbox:Set(Textbox.Default)
        end

        if Textbox.Flag then
            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
        end

        return setmetatable(Textbox, Library)
    end

    Library.Keybind = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Keybind = {
            Name = Params.Name or "Keybind",
            Key = Params.Default,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Picking = false,
            IsOpen = false,
            Debounce = false,
            Items = { }
        }

        local Row = Section:AddRow(32, Keybind.Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Keybind.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.fromOffset(Section.Width - 60, 20),
            Color = "Text",
            Truncate = true,
            Z = 5
        })

        Items.Icon = MakeImage({
            Parent = Row.Instance,
            Icon = "command",
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -16, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            Color = "DimText",
            Z = 6
        })

        Items.Hit = MakeButton({
            Parent = Row.Instance,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.fromOffset(30, 26),
            Z = 8
        })

        Items.Hit:OnHover(function()
            Items.Icon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            Items.Icon:Tween({ ImageColor3 = Library.Theme.DimText })
        end)

        Keybind.Items = Items

        local PanelW = 170

        local Panel = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(PanelW, 72),
            Color = "Section",
            Round = 8,
            Z = 40
        })

        Panel.Instance.Visible = false

        MakeText({
            Parent = Panel.Instance,
            Text = Keybind.Name,
            TextSize = 12,
            Pos = UDim2.fromOffset(11, 8),
            Size = UDim2.fromOffset(PanelW - 22, 14),
            Color = "DimText",
            Truncate = true,
            Z = 41
        })

        local KeyBox = MakeFrame({
            Parent = Panel.Instance,
            Pos = UDim2.fromOffset(9, 32),
            Size = UDim2.fromOffset(PanelW - 18, 30),
            Color = "Light",
            Round = 5,
            Clip = true,
            Z = 41
        })

        local PanelKey = MakeText({
            Parent = KeyBox.Instance,
            Text = "None",
            TextSize = 13,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Truncate = true,
            Z = 42
        })

        local KeyHit = MakeButton({
            Parent = KeyBox.Instance,
            Z = 43
        })

        function Keybind:Set(Key)
            Keybind.Key = Key
            PanelKey.Instance.Text = KeyName(Key)
            Keybind.Picking = false

            if Keybind.Flag then
                Library.Flags[Keybind.Flag] = Key and tostring(Key) or "None"
            end
        end

        function Keybind:Get()
            return Keybind.Key
        end

        AttachPopup({
            Popup = Keybind,
            Frame = Panel,
            Level = 40,
            GetAnchor = function()
                return Items.Hit.Instance
            end,
            Place = function(Off)
                local Anchor = Items.Icon.Instance
                local PScale = Library:GetScreenScale()
                local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
                local PX = Right / PScale + 8 + (Off or 0)
                local PY = (Anchor.AbsolutePosition.Y + GuiInset) / PScale - 4

                return UDim2.fromOffset(PX, PY)
            end,
            From = -6,
            To = 2,
            Retreat = RetreatLeft
        })

        Items.Hit:Connect("MouseButton1Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        KeyHit:Connect("MouseButton1Click", function()
            CaptureKey(Keybind, PanelKey.Instance, function(Key)
                Keybind:Set(Key)
            end)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input, Processed)
            if Processed or Keybind.Picking or not Keybind.Key then return end
            if not KeyMatches(Input, Keybind.Key) then return end

            Library:SafeCall(Keybind.Callback, Keybind.Key)
        end)

        Keybind:Set(Keybind.Key)

        if Keybind.Flag then
            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(ParseKey(Value))
            end
        end

        return setmetatable(Keybind, Library)
    end

    Library.Colorpicker = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Colorpicker = {
            Name = Params.Name or "Color",
            Default = Params.Default or Library.Theme.Accent,
            Transparency = Params.Transparency or 0,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Color = Params.Default or Library.Theme.Accent,
            Items = { }
        }

        local Row = Section:AddRow(32, Colorpicker.Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Colorpicker.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.fromOffset(Section.Width - 60, 20),
            Color = "Text",
            Truncate = true,
            Z = 5
        })

        Items.Swatch = MakeSwatch(Row.Instance, -13, Colorpicker.Default, 5)
        Colorpicker.Items = Items

        local Picker = MakeColorPopup(function()
            return Items.Swatch.Halo.Instance
        end, Colorpicker.Name, Colorpicker.Default, Colorpicker.Transparency, function(Color, Alpha)
            Colorpicker.Color = Color
            Colorpicker.Transparency = Alpha
            Items.Swatch:SetColor(Color, Alpha)

            if Colorpicker.Flag then
                Library.Flags[Colorpicker.Flag] = {
                    __color = Color:ToHex(),
                    __alpha = Alpha
                }
            end

            Library:SafeCall(Colorpicker.Callback, Color, Alpha)
        end)

        Colorpicker.Picker = Picker

        function Colorpicker:Set(Color, Alpha)
            Picker:Set(Color, Alpha)
        end

        function Colorpicker:Get()
            return Colorpicker.Color, Colorpicker.Transparency
        end

        Items.Swatch.Hit:Connect("MouseButton1Down", function()
            Picker:SetOpen(not Picker.IsOpen)
        end)

        if Colorpicker.Flag then
            Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
                Picker:Set(Color, Alpha)
            end
        end

        return setmetatable(Colorpicker, Library)
    end

    Library.Label = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Label = {
            Name = Params.Name or "Label",
            Items = { }
        }

        local Row = Section:AddRow(24, Label.Name)

        Label.Items.Text = MakeText({
            Parent = Row.Instance,
            Text = Label.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.fromOffset(Section.Width - 28, 20),
            Color = "DimText",
            Truncate = true,
            Z = 5
        })

        function Label:Set(Text)
            Label.Items.Text.Instance.Text = tostring(Text)
        end

        return setmetatable(Label, Library)
    end

    Library.Paragraph = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Paragraph = {
            Title = Params.Title or Params.Name or "Paragraph",
            Content = Params.Content or "",
            Items = { }
        }

        local Width = Section.Width - 28
        local TitleBounds = MeasureText(Paragraph.Title, 15, Width, UiFont)
        local BodyBounds = MeasureText(Paragraph.Content, 14, Width, UiFont)
        local Total = TitleBounds.Y + BodyBounds.Y + 16

        local Row = Section:AddRow(Total, Paragraph.Title .. " " .. Paragraph.Content)

        local function Block(Text, TextSize, Y, Height, Color)
            local Item = MakeText({
                Parent = Row.Instance,
                Text = Text,
                TextSize = TextSize,
                Pos = UDim2.fromOffset(14, Y),
                Size = UDim2.fromOffset(Width, Height),
                Color = Color,
                Wrap = true,
                Z = 5
            })

            Item.Instance.TextYAlignment = Enum.TextYAlignment.Top
            return Item
        end

        Paragraph.Items.Title = Block(Paragraph.Title, 15, 6, TitleBounds.Y, "Text")
        Paragraph.Items.Body = Block(Paragraph.Content, 14, TitleBounds.Y + 8, BodyBounds.Y, "DimText")

        function Paragraph:SetTitle(Text)
            Paragraph.Items.Title.Instance.Text = tostring(Text)
        end

        function Paragraph:SetContent(Text)
            Paragraph.Items.Body.Instance.Text = tostring(Text)
        end

        return setmetatable(Paragraph, Library)
    end

    Library.ThemeConfig = function(Self, Params)
        Params = Params or { }

        local SubTab = Self
        local Window = SubTab.Window
        local Page = SubTab.Items.Page
        local ContentH = Window.ContentH
        local ColW = Window.ColW
        local Col2X = Window.Col2X

        SubTab.Columns[1].Scroll.Instance.Visible = false
        SubTab.Columns[2].Scroll.Instance.Visible = false

        local Config = {
            Rows = { },
            Selected = nil,
            IntroToken = 0,
            Items = { }
        }

        local Items = Config.Items

        local function ConfigPath(Name)
            return Library.ConfigFolder .. "/" .. Name .. ".json"
        end

        Items.CreateBox = MakeFrame({
            Parent = Page.Instance,
            Pos = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(ColW, 40),
            Z = 3
        })

        Items.NameBox = MakeFrame({
            Parent = Items.CreateBox.Instance,
            Size = UDim2.fromOffset(ColW - 94, 40),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 4
        })

        MakeImage({
            Parent = Items.NameBox.Instance,
            Icon = "pencil",
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 12, 0.5, 0),
            Size = UDim2.fromOffset(14, 14),
            Color = "DimText",
            Z = 5
        })

        Items.NameInput = MakeInput({
            Parent = Items.NameBox.Instance,
            Placeholder = "config name",
            Pos = UDim2.fromOffset(34, 0),
            Size = UDim2.new(1, -44, 1, 0),
            TextSize = 15,
            Z = 5
        })

        Items.Create = MakeFrame({
            Parent = Items.CreateBox.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, 0, 0, 0),
            Size = UDim2.fromOffset(84, 40),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 4
        })

        HoverSwap(Items.Create)
        Items.CreateSweep = MakeSweep(Items.Create.Instance, 5)

        MakeText({
            Parent = Items.Create.Instance,
            Text = "Create",
            TextSize = 15,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Z = 6
        })

        Items.CreateHit = MakeButton({
            Parent = Items.Create.Instance,
            Z = 7
        })

        Items.ListHolder = MakeFrame({
            Parent = Page.Instance,
            Pos = UDim2.fromOffset(0, 52),
            Size = UDim2.fromOffset(ColW, ContentH - 52),
            Z = 3
        })

        Items.List = Library:Create("ScrollingFrame", {
            Parent = Items.ListHolder.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
            Selectable = false,
            Active = true,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.fromOffset(0, 0),
            ZIndex = 3,
            BorderSizePixel = 0
        })

        Library:Create("UIListLayout", {
            Parent = Items.List.Instance,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })

        Items.InfoPanel = MakeFrame({
            Parent = Page.Instance,
            Pos = UDim2.fromOffset(Col2X, 0),
            Size = UDim2.fromOffset(ColW, 204),
            Color = "Section",
            Round = 10,
            Z = 3
        })

        MakeText({
            Parent = Items.InfoPanel.Instance,
            Text = "Config info",
            TextSize = 15,
            Pos = UDim2.fromOffset(14, 12),
            Size = UDim2.fromOffset(ColW - 28, 20),
            Color = "Text",
            Z = 4
        })

        local InfoRows = { }

        local function InfoRow(Index, Icon, Label)
            local Y = 44 + (Index - 1) * 32

            MakeImage({
                Parent = Items.InfoPanel.Instance,
                Icon = Icon,
                Pos = UDim2.fromOffset(14, Y + 3),
                Size = UDim2.fromOffset(14, 14),
                Color = "DimIcon",
                Z = 4
            })

            MakeText({
                Parent = Items.InfoPanel.Instance,
                Text = Label,
                TextSize = 15,
                Pos = UDim2.fromOffset(36, Y),
                Size = UDim2.fromOffset(ColW - 170, 20),
                Color = "DimText",
                Z = 4
            })

            local Value = MakeText({
                Parent = Items.InfoPanel.Instance,
                Text = "-",
                TextSize = 15,
                Anchor = Vector2.new(1, 0),
                Pos = UDim2.new(1, -14, 0, Y),
                Size = UDim2.fromOffset(150, 20),
                Color = "Text",
                Align = Enum.TextXAlignment.Right,
                Truncate = true,
                Z = 4
            })

            if Index < 5 then
                MakeFrame({
                    Parent = Items.InfoPanel.Instance,
                    Pos = UDim2.fromOffset(14, Y + 27),
                    Size = UDim2.fromOffset(ColW - 28, 1),
                    Color = "Element",
                    Z = 4
                })
            end

            return Value
        end

        InfoRows.Version = InfoRow(1, "layers", "Config version")
        InfoRows.Compatible = InfoRow(2, "link", "Compatibility")
        InfoRows.Created = InfoRow(3, "clock", "Created")
        InfoRows.Creator = InfoRow(4, "user", "Creator")
        InfoRows.Elements = InfoRow(5, "box", "Saved flags")

        local function ShowInfo(Name)
            if not Name then
                for _, Value in InfoRows do
                    Value.Instance.Text = "-"
                end

                return
            end

            local Data = { }

            pcall(function()
                Data = HttpService:JSONDecode(readfile(ConfigPath(Name)))
            end)

            local Count = 0

            for Key in Data do
                if string.sub(Key, 1, 2) ~= "__" then
                    Count += 1
                end
            end

            local Same = Data.__version == Library.Version

            InfoRows.Version.Instance.Text = Data.__version or "Unknown"
            InfoRows.Compatible.Instance.Text = Same and "Compatible" or "Outdated"
            InfoRows.Created.Instance.Text = Data.__created or "Unknown"
            InfoRows.Creator.Instance.Text = Data.__creator or "Unknown"
            InfoRows.Elements.Instance.Text = tostring(Count) .. " flags"
        end

        Items.ThemePanel = MakeFrame({
            Parent = Page.Instance,
            Pos = UDim2.fromOffset(Col2X, 216),
            Size = UDim2.fromOffset(ColW, 194),
            Color = "Section",
            Round = 10,
            Z = 3
        })

        MakeText({
            Parent = Items.ThemePanel.Instance,
            Text = "Theme",
            TextSize = 15,
            Pos = UDim2.fromOffset(14, 8),
            Size = UDim2.fromOffset(ColW - 28, 20),
            Color = "Text",
            Z = 4
        })

        local RefreshThemeUI
        local PresetDots = { }

        local function SelectPreset(Target)
            for _, Dot in PresetDots do
                Library:Tween({ Thickness = Dot == Target and 2 or 0 }, nil, Dot.Ring.Instance)
            end
        end

        MakeText({
            Parent = Items.ThemePanel.Instance,
            Text = "Presets",
            TextSize = 15,
            Pos = UDim2.fromOffset(14, 34),
            Size = UDim2.fromOffset(100, 20),
            Color = "DimText",
            Z = 4
        })

        for Index, Preset in Library.ThemePresets do
            local Dot = MakeFrame({
                Parent = Items.ThemePanel.Instance,
                Anchor = Vector2.new(1, 0),
                Pos = UDim2.new(1, -14 - (#Library.ThemePresets - Index) * 28, 0, 35),
                Size = UDim2.fromOffset(18, 18),
                Raw = Preset.Swatch or Preset.Accent,
                Round = 20,
                Z = 4
            })

            Dot.Ring = Library:Create("UIStroke", {
                Parent = Dot.Instance,
                Color = Color3.new(1, 1, 1),
                Thickness = 0
            })

            local Hit = MakeButton({
                Parent = Dot.Instance,
                Z = 5
            })

            Hit:Connect("MouseButton1Down", function()
                Library:SetTheme(Preset)
                SelectPreset(Dot)

                if RefreshThemeUI then
                    RefreshThemeUI()
                end
            end)

            table.insert(PresetDots, Dot)
        end

        PresetDots[1].Ring.Instance.Thickness = 2

        local ThemeCells = {
            { "Background", "Background" },
            { "Section", "Sections" },
            { "Element", "Elements" },
            { "Light", "Boxes" },
            { "Text", "Text" },
            { "DimText", "Dim text" }
        }

        local ThemeCellList = { }
        local CellW = math.floor((ColW - 42) / 2)

        for Index, Entry in ThemeCells do
            local Key = Entry[1]
            local CellX = 14 + ((Index - 1) % 2) * (CellW + 14)
            local CellY = 66 + math.floor((Index - 1) / 2) * 30

            MakeText({
                Parent = Items.ThemePanel.Instance,
                Text = Entry[2],
                TextSize = 15,
                Pos = UDim2.fromOffset(CellX, CellY),
                Size = UDim2.fromOffset(CellW - 28, 20),
                Color = "DimText",
                Truncate = true,
                Z = 4
            })

            local Swatch = MakeSwatch(Items.ThemePanel.Instance, 0, Library.Theme[Key], 4)

            Swatch.Halo.Instance.AnchorPoint = Vector2.new(0, 0)
            Swatch.Halo.Instance.Position = UDim2.fromOffset(CellX + CellW - 22, CellY - 1)

            local CellPicker = MakeColorPopup(function()
                return Swatch.Halo.Instance
            end, Entry[2], Library.Theme[Key], 0, function(Color)
                Swatch:SetColor(Color)
                Library:SetThemeColor(Key, Color)
            end)

            Swatch.Hit:Connect("MouseButton1Down", function()
                CellPicker:SetOpen(not CellPicker.IsOpen)
            end)

            table.insert(ThemeCellList, {
                Key = Key,
                Swatch = Swatch,
                Picker = CellPicker
            })
        end

        MakeText({
            Parent = Items.ThemePanel.Instance,
            Text = "Accent",
            TextSize = 15,
            Pos = UDim2.fromOffset(14, 160),
            Size = UDim2.fromOffset(ColW - 60, 20),
            Color = "DimText",
            Truncate = true,
            Z = 4
        })

        Items.Swatch = MakeSwatch(Items.ThemePanel.Instance, -14, Library.Theme.Accent, 4)
        Items.Swatch.Halo.Instance.AnchorPoint = Vector2.new(1, 0.5)
        Items.Swatch.Halo.Instance.Position = UDim2.new(1, -14, 0, 170)

        local Picker = MakeColorPopup(function()
            return Items.Swatch.Halo.Instance
        end, "Accent", Library.Theme.Accent, 0, function(Color)
            Items.Swatch:SetColor(Color)
            Library:SetAccent(Color)
        end)

        Items.Swatch.Hit:Connect("MouseButton1Down", function()
            Picker:SetOpen(not Picker.IsOpen)
        end)

        RefreshThemeUI = function()
            Items.Swatch:SetColor(Library.Theme.Accent)
            Picker:Set(Library.Theme.Accent, 0, true)

            for _, Cell in ThemeCellList do
                Cell.Swatch:SetColor(Library.Theme[Cell.Key])
                Cell.Picker:Set(Library.Theme[Cell.Key], 0, true)
            end
        end

        local RefreshList

        local function AddRow(Index, Name)
            local Slot = MakeFrame({
                Parent = Items.List.Instance,
                Size = UDim2.fromOffset(ColW, 44),
                Clip = true,
                Z = 4
            })

            Slot.Instance.LayoutOrder = Index

            local Row = MakeFrame({
                Parent = Slot.Instance,
                Size = UDim2.fromOffset(ColW, 44),
                Color = "Section",
                Round = 8,
                Z = 4
            })

            local Bar = MakeFrame({
                Parent = Row.Instance,
                Anchor = Vector2.new(0, 0.5),
                Pos = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(3, 0),
                Color = "Accent",
                Round = 4,
                Z = 6
            })

            local BarShadow = MakeAccentShadow(
                Bar.Instance,
                UDim2.fromOffset(3, 15),
                UDim.new(0, 10),
                0
            )

            if BarShadow then
                BarShadow.Transparency = 1
            end

            local Label = MakeText({
                Parent = Row.Instance,
                Text = Name,
                TextSize = 15,
                Anchor = Vector2.new(0, 0.5),
                Pos = UDim2.new(0, 15, 0.5, 0),
                Size = UDim2.fromOffset(ColW - 130, 20),
                Color = "DimText",
                Truncate = true,
                Z = 5
            })

            local Data = {
                Name = Name,
                Slot = Slot,
                Row = Row
            }

            local function IconButton(Offset, Icon, Callback)
                local Image = MakeImage({
                    Parent = Row.Instance,
                    Icon = Icon,
                    Anchor = Vector2.new(1, 0.5),
                    Pos = UDim2.new(1, Offset, 0.5, 0),
                    Size = UDim2.fromOffset(15, 15),
                    Color = "DimText",
                    Z = 5
                })

                local Hit = MakeButton({
                    Parent = Row.Instance,
                    Anchor = Vector2.new(1, 0.5),
                    Pos = UDim2.new(1, Offset + 7, 0.5, 0),
                    Size = UDim2.fromOffset(28, 28),
                    Z = 6
                })

                Hit:OnHover(function()
                    Image:Tween({ ImageColor3 = Library.Theme.Text })
                end, function()
                    Image:Tween({ ImageColor3 = Library.Theme.DimText })
                end)

                Hit:Connect("MouseButton1Down", Callback)
            end

            IconButton(-66, "download", function()
                local Created

                pcall(function()
                    Created = HttpService:JSONDecode(readfile(ConfigPath(Name))).__created
                end)

                writefile(ConfigPath(Name), Library:GetConfig(Created))
                ShowInfo(Name)

                Library:Notification({
                    Name = "Config saved",
                    Description = "Current values were written into \"" .. Name .. "\".",
                    Icon = "download"
                })
            end)

            IconButton(-40, "share-2", function()
                if setclipboard then
                    pcall(function()
                        setclipboard(readfile(ConfigPath(Name)))
                    end)
                end

                Library:Notification({
                    Name = "Config copied",
                    Description = "\"" .. Name .. "\" was copied to your clipboard.",
                    Icon = "share-2"
                })
            end)

            IconButton(-14, "trash-2", function()
                if Data.Removing then return end
                Data.Removing = true

                if delfile and isfile and isfile(ConfigPath(Name)) then
                    delfile(ConfigPath(Name))
                end

                if Config.Selected == Name then
                    Config.Selected = nil
                    ShowInfo(nil)
                end

                local Index = table.find(Config.Rows, Data)
                if Index then table.remove(Config.Rows, Index) end

                local Sink = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                Library:Tween({ Size = UDim2.fromOffset(ColW, 0) }, Sink, Slot.Instance)
                Row:FadeDescendants(false)

                Library:Notification({
                    Name = "Config deleted",
                    Description = "\"" .. Name .. "\" was removed.",
                    Icon = "trash-2"
                })

                task.delay(0.3, function()
                    Slot.Instance:Destroy()

                    local NewHeight = #Config.Rows * 52
                    Items.List.Instance.CanvasSize = UDim2.fromOffset(0, math.max(NewHeight - 8, 0))
                end)
            end)

            function Data:SetSelected(Active)
                local Key = Active and "Text" or "DimText"

                Label:ChangeItemTheme({ TextColor3 = Key })
                Label:Tween({ TextColor3 = Library.Theme[Key] })
                Library:Tween({ Size = UDim2.fromOffset(3, Active and 16 or 0) }, nil, Bar.Instance)

                if BarShadow then
                    Library:StampResting(BarShadow, "Transparency", Active and 0 or 1)
                    BarShadow.Transparency = Active and 0 or 1
                end
            end

            local Hit = MakeButton({
                Parent = Row.Instance,
                Size = UDim2.new(1, -96, 1, 0),
                Z = 5
            })

            Hit:Connect("MouseButton1Down", function()
                Config.Selected = Name

                for _, Other in Config.Rows do
                    Other:SetSelected(Other == Data)
                end

                ShowInfo(Name)
                Library:LoadConfigFile(Name)

                if RefreshThemeUI then
                    RefreshThemeUI()
                end

                Library:Notification({
                    Name = "Config loaded",
                    Description = "All values were restored from \"" .. Name .. "\".",
                    Icon = "check"
                })
            end)

            table.insert(Config.Rows, Data)
            return Data
        end

        RefreshList = function()
            for _, Data in Config.Rows do
                Data.Slot.Instance:Destroy()
            end

            Config.Rows = { }

            for Index, Name in Library:ListConfigs() do
                local Data = AddRow(Index, Name)
                Data:SetSelected(Name == Config.Selected)
            end

            local Height = #Config.Rows * 52
            Items.List.Instance.CanvasSize = UDim2.fromOffset(0, math.max(Height - 8, 0))
        end

        Items.CreateHit:Connect("MouseButton1Down", function()
            PlaySweep(Items.CreateSweep.Instance)

            local Name = string.gsub(Items.NameInput.Instance.Text, "[^%w _%-]", "")

            if Name == "" then
                Library:Notification({
                    Name = "Config name required",
                    Description = "Type a name into the box before creating.",
                    Icon = "triangle-alert"
                })

                return
            end

            if isfile and isfile(ConfigPath(Name)) then
                Library:Notification({
                    Name = "Name already used",
                    Description = "A config called \"" .. Name .. "\" already exists.",
                    Icon = "triangle-alert"
                })

                return
            end

            writefile(ConfigPath(Name), Library:GetConfig())
            Items.NameInput.Instance.Text = ""
            Config.Selected = Name
            RefreshList()
            ShowInfo(Name)

            Library:Notification({
                Name = "Config created",
                Description = "\"" .. Name .. "\" now holds your current values.",
                Icon = "plus"
            })
        end)

        local Blocks = {
            { Frame = Items.CreateBox, Home = UDim2.fromOffset(0, 0) },
            { Frame = Items.ListHolder, Home = UDim2.fromOffset(0, 52) },
            { Frame = Items.InfoPanel, Home = UDim2.fromOffset(Col2X, 0) },
            { Frame = Items.ThemePanel, Home = UDim2.fromOffset(Col2X, 216) }
        }

        local BlockSlide = 30
        local BlockStep = 0.06

        SubTab.PageIntro = function()
            Config.IntroToken += 1

            local Token = Config.IntroToken
            local Slide = TweenInfo.new(0.36, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            for _, Block in Blocks do
                Block.Frame:CancelFade()
                Block.Frame.Instance.Visible = false
                Block.Frame.Instance.Position = Block.Home + UDim2.fromOffset(BlockSlide, 0)
            end

            for Index, Block in Blocks do
                task.delay((Index - 1) * BlockStep, function()
                    Block.Frame.Instance.Visible = true

                    if Config.IntroToken ~= Token then
                        Block.Frame.Instance.Position = Block.Home
                        return
                    end

                    Block.Frame:FadeDescendants(true)
                    Library:Tween({ Position = Block.Home }, Slide, Block.Frame.Instance)
                end)
            end
        end

        SubTab.PageOutro = function()
            Config.IntroToken += 1

            local Token = Config.IntroToken
            local Slide = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

            for Index, Block in Blocks do
                local Away = Block.Home + UDim2.fromOffset(-BlockSlide, 0)

                task.delay((Index - 1) * BlockStep, function()
                    if Config.IntroToken ~= Token then return end

                    Block.Frame:FadeDescendants(false)
                    Library:Tween({ Position = Away }, Slide, Block.Frame.Instance)
                end)
            end
        end

        function Config:Refresh()
            RefreshList()
        end

        RefreshList()
        ShowInfo(nil)

        return Config
    end

    Library.Watermark = function(Self, Params)
        Params = Params or { }

        if Library.WatermarkBar then
            return Library.WatermarkBar
        end

        local Icon = Params.Icon or (Self and Self.Icon) or "layers"
        local Items = { }
        local Order = 0

        Items.Bar = MakeFrame({
            Parent = Library.Holder.Instance,
            Anchor = Vector2.new(0.5, 0),
            Pos = UDim2.new(0.5, 0, 0, 14),
            Size = UDim2.fromOffset(0, 32),
            Color = "Section",
            Round = 8,
            Z = 60
        })

        Items.Bar.Instance.AutomaticSize = Enum.AutomaticSize.X

        Library:Create("UIPadding", {
            Parent = Items.Bar.Instance,
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        })

        Library:Create("UIListLayout", {
            Parent = Items.Bar.Instance,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })

        local function NextOrder()
            Order += 1
            return Order
        end

        Items.Icon = MakeImage({
            Parent = Items.Bar.Instance,
            Icon = Icon,
            Size = UDim2.fromOffset(20, 20),
            Raw = Color3.new(1, 1, 1),
            Fit = true,
            Z = 61
        })

        Items.Icon.Instance.LayoutOrder = NextOrder()

        local function Separator()
            local Sep = MakeFrame({
                Parent = Items.Bar.Instance,
                Size = UDim2.fromOffset(1, 14),
                Color = "Light",
                Z = 61
            })

            Sep.Instance.LayoutOrder = NextOrder()
        end

        local function Stat(Text)
            local Label = MakeText({
                Parent = Items.Bar.Instance,
                Text = Text,
                TextSize = 14,
                Size = UDim2.fromOffset(0, 16),
                Color = "DimText",
                Z = 61
            })

            Label.Instance.AutomaticSize = Enum.AutomaticSize.X
            Label.Instance.LayoutOrder = NextOrder()

            return Label
        end

        Separator()
        local GameStat = Stat("...")
        Separator()
        local FpsStat = Stat("0 fps")
        Separator()
        local PingStat = Stat("0 ms")
        Separator()
        local TimeStat = Stat(os.date("%I:%M %p"))

        Library:Thread(function()
            local Ok, Info = pcall(function()
                return MarketplaceService:GetProductInfo(game.PlaceId)
            end)

            GameStat.Instance.Text = (Ok and Info and Info.Name) or "Unknown"
        end)

        local Frames = 0

        Library:Connect(RunService.RenderStepped, function()
            Frames += 1
        end)

        Library:Thread(function()
            while task.wait(0.5) do
                if not Items.Bar.Instance.Parent then break end

                FpsStat.Instance.Text = tostring(Frames * 2) .. " fps"
                Frames = 0

                local Ping = 0

                pcall(function()
                    local Stat = StatsService.Network.ServerStatsItem["Data Ping"]
                    Ping = math.floor(Stat:GetValue())
                end)

                PingStat.Instance.Text = tostring(Ping) .. " ms"
                TimeStat.Instance.Text = os.date("%I:%M %p")
            end
        end)

        Items.Bar:MakeDraggable()
        Library.WatermarkBar = Items.Bar

        local Watermark = { Instance = Items.Bar.Instance }

        function Watermark:SetIcon(NewIcon)
            ApplyIcon(Items.Icon.Instance, NewIcon)
        end

        function Watermark:SetName()
        end

        function Watermark:SetVisible(Bool)
            Items.Bar:FadeDescendants(Bool)
        end

        return Watermark
    end

    Library.GetConfig = function(Self, Created)
        local Config = { }

        for Index, Value in Library.Flags do
            if typeof(Value) == "Color3" then
                Config[Index] = { __color = Value:ToHex() }
            else
                Config[Index] = Value
            end
        end

        local ThemeColors = { }

        for _, Key in Library.ThemeKeys do
            ThemeColors[Key] = Library.Theme[Key]:ToHex()
        end

        Config.__accent = Library.Theme.Accent:ToHex()
        Config.__theme = ThemeColors
        Config.__created = Created or os.date("%d.%m.%Y %H:%M")
        Config.__version = Library.Version
        Config.__creator = LocalPlayer.DisplayName

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Ok, Decoded = pcall(function()
            return HttpService:JSONDecode(Config)
        end)

        if not Ok or type(Decoded) ~= "table" then return false end

        Library.Silent = true

        for Index, Value in Decoded do
            local SetFunction = Library.SetFlags[Index]
            if not SetFunction then continue end

            if type(Value) == "table" and Value.__color then
                SetFunction(Color3.fromHex(Value.__color), Value.__alpha)
            else
                SetFunction(Value)
            end
        end

        if type(Decoded.__theme) == "table" then
            for Key, Hex in Decoded.__theme do
                local OkColor, Color = pcall(Color3.fromHex, Hex)
                if OkColor then Library.Theme[Key] = Color end
            end

            DeriveTheme()
            Library.ThemeDirty = true
        end

        if type(Decoded.__accent) == "string" then
            local OkColor, Color = pcall(Color3.fromHex, Decoded.__accent)
            if OkColor then Library:SetAccent(Color) end
        end

        Library.Silent = false
        return true
    end

    Library.SaveConfigFile = function(Self, Name)
        if not writefile then return false end

        writefile(Library.ConfigFolder .. "/" .. Name .. ".json", Library:GetConfig())
        return true
    end

    Library.LoadConfigFile = function(Self, Name)
        if not isfile then return false end

        local Path = Library.ConfigFolder .. "/" .. Name .. ".json"
        if not isfile(Path) then return false end

        return Library:LoadConfig(readfile(Path))
    end

    Library.ListConfigs = function(Self)
        local Result = { }

        if not listfiles then return Result end

        for _, File in listfiles(Library.ConfigFolder) do
            if string.sub(File, -5) ~= ".json" then continue end

            local Name = string.match(File, "([^/\\]+)%.json$")
            if Name then table.insert(Result, Name) end
        end

        return Result
    end

    Library:Connect(RunService.Heartbeat, function(Delta)
        if Library.ThemeDirty then
            Library.ThemeDirty = false
            Library:ApplyThemeInstant()
        end

        if not Library.PreloadDirty then return end

        Library.PreloadClock += Delta or 0

        if Library.PreloadClock >= 0.35 then
            Library.PreloadDirty = false
            Library.PreloadClock = 0
            Library:PreloadAll()
        end
    end)

    getgenv().Zolar = Library
end

return Library