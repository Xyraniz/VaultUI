-- Swin
-- A reusable Roblox UI library adapted from the supplied Swin interface.
-- The public Interface API is preserved; the small runtime below replaces the
-- original external Assets, Framework, and Utilities modules so this source
-- file can be loaded directly with loadstring.
local cloneref = cloneref or function(value) return value end
local function swinService(name)
    local ok, service = pcall(game.GetService, game, name)
    return ok and service or nil
end

local Services = setmetatable({
    Players = swinService("Players"),
    Lighting = swinService("Lighting"),
    CoreGui = (gethui and gethui()) or (cloneref and cloneref(swinService("CoreGui"))) or swinService("CoreGui"),
    Stats = swinService("Stats"),
}, { __index = function(self, key) return swinService(key) end })

local function unwrap(value)
    return type(value) == "table" and rawget(value, "_obj") or value
end

local function themeColor(name)
    return (Framework and Framework.Theme and Framework.Theme.Colors[name]) or Color3.fromRGB(255, 255, 255)
end

local ProxyMethods = {}
local ProxyMeta = {}
ProxyMeta.__index = function(self, key)
    if key == "_obj" then return rawget(self, "_obj") end
    if key == "Add" then
        return function(proxy, styles)
            local object = rawget(proxy, "_obj")
            for property, value in pairs(styles or {}) do
                if type(value) == "string" and Framework.Theme.Colors[value] then
                    property = property == "Color" and "Color" or property
                    value = themeColor(value)
                end
                pcall(function() object[property] = unwrap(value) end)
            end
            return proxy
        end
    end
    local object = rawget(self, "_obj")
    local value = object and object[key]
    if type(value) == "function" then
        return function(_, ...)
            return value(object, ...)
        end
    end
    return value
end
ProxyMeta.__newindex = function(self, key, value)
    local object = rawget(self, "_obj")
    if object then pcall(function() object[key] = unwrap(value) end) end
end
ProxyMeta.__tostring = function(self) return tostring(rawget(self, "_obj")) end

local function proxy(object)
    return setmetatable({ _obj = object }, ProxyMeta)
end

local Framework = {
    CurrentFont = Font and Font.fromEnum and Font.fromEnum(Enum.Font.Gotham) or Enum.Font.Gotham,
    CurrentSize = 12,
    Theme = { Colors = {
        Window = Color3.fromRGB(20, 20, 24),
        Active = Color3.fromRGB(235, 235, 240),
        Inactive = Color3.fromRGB(145, 145, 155),
        Middle = Color3.fromRGB(29, 29, 34),
        Outline = Color3.fromRGB(52, 52, 62),
        Outline2 = Color3.fromRGB(75, 75, 88),
        Accent = Color3.fromRGB(154, 124, 255),
        Text = Color3.fromRGB(220, 220, 228),
        LineGradient = ColorSequence.new(Color3.fromRGB(154, 124, 255), Color3.fromRGB(52, 52, 62)),
    }},
    Services = Services,
}
function Framework:New(className, properties)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        pcall(function() object[property] = unwrap(value) end)
    end
    return proxy(object)
end
function Framework:Tween(target, properties, _, _, _, callback)
    target = unwrap(target)
    for property, value in pairs(properties or {}) do pcall(function() target[property] = unwrap(value) end) end
    if callback then task.defer(callback) end
    return target
end
Framework.TweenTheme = Framework.Tween
function Framework:Connect(signal, callback) return signal:Connect(callback) end
function Framework:Drag(target) return target end
function Framework:Resize(target) return target end
function Framework:Glow() end
function Framework:FadeIn() end
function Framework:UpdateOutline() end
function Framework:UpdateWindow() end
function Framework:UpdateMiddle() end
function Framework:UpdateInactive() end
function Framework:UpdateActive() end
function Framework:UpdateAccent() end
function Framework:SetFontSize(size) self.CurrentSize = size end
function Framework:ApplyFontSettings() end
function Framework:Unload()
    if Interface and Interface.ScreenGui then Interface.ScreenGui:Destroy() end
    if Interface and Interface.WatermarkGui and Interface.WatermarkGui.Background then Interface.WatermarkGui.Background:Destroy() end
end

local Assets = {
    Images = { Require = function(_, name)
        local icons = { Logo = "rbxassetid://93984335181980", Info = "rbxassetid://7072725342", Search = "rbxassetid://6031154871", Settings = "rbxassetid://6031280882" }
        return icons[name] or icons.Logo
    end },
    Fonts = setmetatable({}, { __index = function() return Framework.CurrentFont end }),
}
local Utilities = {}
local Interface
Interface = {
    Open = true,
    CanOpen = true,
    Font = Framework.CurrentFont, -- Font.new([[rbxassetid://12187365977]], Enum.FontWeight.SemiBold)
    FontSize = Framework.CurrentSize, -- 11

    -- Binds
    Bind = Enum.KeyCode.RightShift,
    Unload_Bind = Enum.KeyCode.Delete,
    nilkeys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.UserInputType.MouseMovement},
    KeyNames = {
        LeftShift = "LS", RightShift = "RS",
        LeftControl = "LC", RightControl = "RC",
        LeftAlt = "LA", RightAlt = "RA",
        CapsLock = "CAP",

        F1 = "F1", F2 = "F2", F3 = "F3", F4 = "F4",
        F5 = "F5", F6 = "F6", F7 = "F7", F8 = "F8",
        F9 = "F9", F10 = "F10", F11 = "F11", F12 = "F12",

        Insert = "INS", Delete = "DEL",
        Home = "HOM", End = "END",
        PageUp = "PU", PageDown = "PD",

        Up = "UP", Down = "DN", Left = "LT", Right = "RT",

        Zero = "0", One = "1", Two = "2", Three = "3",
        Four = "4", Five = "5", Six = "6", Seven = "7",
        Eight = "8", Nine = "9",

        A = "A", B = "B", C = "C", D = "D", E = "E",
        F = "F", G = "G", H = "H", I = "I", J = "J",
        K = "K", L = "L", M = "M", N = "N", O = "O",
        P = "P", Q = "Q", R = "R", S = "S", T = "T",
        U = "U", V = "V", W = "W", X = "X", Y = "Y", Z = "Z",

        Minus = "-", Equals = "=",
        LeftBracket = "[", RightBracket = "]",
        BackSlash = "\\", Slash = "/",
        Period = ".", Comma = ",",
        Quote = "'", Semicolon = ";",
        Backquote = "`",

        Return = "ENT", Backspace = "BSP",
        Tab = "TAB", Escape = "ESC", Space = "SPC",

        KeypadZero = "K0", KeypadOne = "K1", KeypadTwo = "K2",
        KeypadThree = "K3", KeypadFour = "K4", KeypadFive = "K5",
        KeypadSix = "K6", KeypadSeven = "K7", KeypadEight = "K8",
        KeypadNine = "K9", KeypadEnter = "KE",
        KeypadMinus = "K-", KeypadPlus = "K+",
        KeypadPeriod = "K.", KeypadDivide = "K/", KeypadMultiply = "K*",

        MouseButton1 = "M1",
        MouseButton2 = "M2",
        MouseButton3 = "M3",
    };

    -- UI & objects
    UnnamedFlags = 0,
    Holder = nil,
    ScreenGui = nil,
    WatermarkGui = nil,
    IndicatorGui = nil,
    NotificationGUI = nil,
    UID_Data = nil,
    Notifs = {},
    Pages = {},
    Sections = {},
    Flags = {},
    Friends = {},
    Priorities = {},
};  

-- Variables
local Mouse = Services.Players.LocalPlayer:GetMouse();
local Blur = cloneref(Instance.new("BlurEffect", Services.Lighting));
Interface.UID_Data = { uid="local", first_execution="N/A", last_execution="N/A", discord_username="local", in_game=true };

local Flags = {};
Interface.__index = Interface;
Interface.Pages.__index = Interface.Pages;
Interface.Sections.__index = Interface.Sections;   

do -- Interface Functions
    -- Flags
    function Interface.NextFlag()
        Interface.UnnamedFlags = Interface.UnnamedFlags + 1;
        return string.format("%.14g", Interface.UnnamedFlags);
    end;

    -- Colorpicker
    function Interface:RGBA(r, g, b, alpha)
        local rgb = Color3.fromRGB(r, g, b)
        local mt = table.clone(getrawmetatable(rgb))

        setreadonly(mt, false)
        local old = mt.__index

        mt.__index = newcclosure(function(self, key)
            if key:lower() == "transparency" then
                return alpha
            end

            return old(self, key)
        end)

        setrawmetatable(rgb, mt)

        return rgb;
    end;

    -- Config
    function Interface:GetConfig()
        local Config = ""
        for Index, Value in pairs(self.Flags) do
            if Index ~= "ConfigConfig_List" and Index ~= "ConfigConfig_Load" and Index ~= "ConfigConfig_Save" then
                local Value2 = Value
                local Final = ""
                if typeof(Value2) == "Color3" then
                    local hue, sat, val = Value2:ToHSV()
                    Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
                elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency ~= nil then
                    local hue, sat, val = Value2.Color:ToHSV()
                    Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
                elseif typeof(Value2) == "table" and Value.Mode then
                    local Values = Value.current
                    Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
                elseif Value2 ~= nil then
                    if typeof(Value2) == "boolean" then
                        Value2 = ("bool(%s)"):format(tostring(Value2))
                    elseif typeof(Value2) == "table" then
                        local New = "table("
                        for _, Value3 in pairs(Value2) do
                            New = New .. Value3 .. ","
                        end
                        if New:sub(#New) == "," then
                            New = New:sub(1, #New - 1)
                        end
                        Value2 = New .. ")"
                    elseif typeof(Value2) == "string" then
                        Value2 = ("string(%s)"):format(Value2)
                    elseif typeof(Value2) == "number" then
                        Value2 = ("number(%s)"):format(Value2)
                    end
                    Final = Value2
                end
                Config = Config .. Index .. ": " .. tostring(Final) .. "\n"
            end
        end
        return Config
    end;

    function Interface:LoadConfig(Config)
        local Table = string.split(Config, "\n")
        local Table2 = {}
        for _, Value in pairs(Table) do
            local Table3 = string.split(Value, ":")
            if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
                local Value = Table3[2]:sub(2, #Table3[2])
                if Value:sub(1, 3) == "rgb" then
                    local Table4 = string.split(Value:sub(5, #Value - 1), ",")
                    local h, s, v = tonumber(Table4[1]), tonumber(Table4[2]), tonumber(Table4[3])
                    local t = tonumber(Table4[4]) or 1
                    if typeof(Flags[Table3[1]]) == "table" and Flags[Table3[1]].Color and Flags[Table3[1]].Transparency ~= nil then
                        Value = {Color = Color3.fromHSV(h, s, v), Transparency = t}
                    else
                        Value = Color3.fromHSV(h, s, v)
                    end
                elseif Value:sub(1, 3) == "key" then
                    local Table4 = string.split(Value:sub(5, #Value - 1), ",")
                    if Table4[1] == "nil" and Table4[2] == "nil" then
                        Table4[1] = nil
                        Table4[2] = nil
                    end
                    Value = Table4
                elseif Value:sub(1, 4) == "bool" then
                    local Bool = Value:sub(6, #Value - 1)
                    Value = Bool == "true"
                elseif Value:sub(1, 5) == "table" then
                    local Table4 = string.split(Value:sub(7, #Value - 1), ",")
                    Value = Table4
                elseif Value:sub(1, 6) == "string" then
                    local String = Value:sub(8, #Value - 1)
                    Value = String
                elseif Value:sub(1, 6) == "number" then
                    local Number = tonumber(Value:sub(8, #Value - 1))
                    Value = Number
                end
                Table2[Table3[1]] = Value
            end
        end
        for i, v in pairs(Table2) do
            if Flags[i] then
                if typeof(Flags[i]) == "table" then
                    Flags[i]:Set(v)
                else
                    Flags[i](v)
                end
            end
        end
    end;
end;

do -- Interface Elements
    local Pages = Interface.Pages;
    local Sections = Interface.Sections;
    local AllColorHolders = {};
    local GlobalSavedColors = {};
    local ColorHolderSetters = {};

    -- Notification
    function Interface:UpdateNotifsPositions()
        for i, v in ipairs(Interface.Notifs) do
            Framework:Tween(v.Container, { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 20 + (i * 38)) }, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;
    end;

    function Interface:Notification(message, duration)
        local notification = {Container = nil, Objects = {}}
        local Position = Vector2.new(20, 20)

        local NotifContainer = Framework:New("Frame", {
            Parent = Framework:New("ScreenGui", {
                Parent = (gethui and gethui()) or (cloneref and cloneref(Services.CoreGui)) or Services.CoreGui,
                Name = "Notifications",
                IgnoreGuiInset = Enum.ScreenInsets.DeviceSafeInsets,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                DisplayOrder = 11
            }),
            Name = "NotifContainer",
            Position = UDim2.new(0,Position.X, 0, Position.Y),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0,0,0,16),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 99999999
        }):Add({BackgroundColor3 = "Window"});

        Interface.NotificationGUI = NotifContainer;
        notification.Container = NotifContainer;

        local Inline = Framework:New("Frame", {
            AutomaticSize = Enum.AutomaticSize.X,
            Name = "Inline",
            Parent = NotifContainer,
            Position = UDim2.new(0.01, 0, 0.02, 0),
            Size = UDim2.new(0, 0, 0, 28),
            BackgroundTransparency = 1
        }):Add({BackgroundColor3 = "Window"})
        table.insert(notification.Objects, Inline)

        local SubTabStroke = Framework:New("UIStroke", {
            Enabled = true,
            Transparency = 1,
            Parent = Inline,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1
        }):Add({Color = "Outline"});
        
        Framework:New('UICorner', {
            Parent = Inline,
            CornerRadius = UDim.new(0, 5)
        });

        local Icon = Framework:New("ImageLabel", {
            Parent = Inline,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,64,0,64),
            Position = UDim2.new(0,-19,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            Image = Assets.Images:Require("Info"),
            ImageTransparency = 1,
            ZIndex = 99999
        }):Add({ImageColor3 = "Accent"})
        table.insert(notification.Objects, Icon)

        local Value = Framework:New("TextLabel", {
            Name = "Value",
            Parent = Inline,
            FontFace = Interface.Font,
            TextSize = Interface.FontSize,
            Text = message,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0,0,1,0),
            BackgroundTransparency = 1,
            TextTransparency = 1
        }):Add({TextColor3 = "Accent"})
        table.insert(notification.Objects, Value)

        Framework:New("UIPadding", {
            Parent = Value,
            PaddingLeft = UDim.new(0, 26),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 1)
        });

        function notification:remove()
            table.remove(Interface.Notifs, table.find(Interface.Notifs, notification))
            Interface:UpdateNotifsPositions(Position)
            task.wait(0.5)
            notification.Container:Destroy()
        end

        task.spawn(function()
            Inline.Position = UDim2.new(Inline.Position.X.Scale, Inline.Position.X.Offset, Inline.Position.Y.Scale, -25)
            Framework:Tween(SubTabStroke, {Transparency = 0}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
            for _,v in next, notification.Objects do
                if v:IsA("Frame") then
                    Framework:Tween(v, {BackgroundTransparency = 0}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
                end
            end
            Framework:Tween(Inline, {Position = UDim2.new(Inline.Position.X.Scale, Inline.Position.X.Offset, Inline.Position.Y.Scale, 0)}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            Framework:Tween(Value, {TextTransparency = 0}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            Framework:Tween(Icon, {ImageTransparency = 0}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            task.wait(duration)
            Framework:Tween(Inline, {Position = UDim2.new(Inline.Position.X.Scale, Inline.Position.X.Offset, Inline.Position.Y.Scale, -25)}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            for _,v in next, notification.Objects do
                if v:IsA("Frame") then
                    Framework:Tween(v, {BackgroundTransparency = 1}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                end
            end
            Framework:Tween(SubTabStroke, {Transparency = 1}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
            Framework:Tween(Value, {TextTransparency = 1}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            Framework:Tween(Icon, {ImageTransparency = 1}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end)

        task.delay(duration, function()
            notification:remove()
        end)

        table.insert(Interface.Notifs, notification)
        NotifContainer.AnchorPoint = Vector2.new(0.5, 0)
        NotifContainer.Position = UDim2.new(0.5, 0, 0, 20 + (table.find(Interface.Notifs, notification) * 38))
        Interface:UpdateNotifsPositions(Position)

        return notification;
    end;

    -- Window
    function Interface:Window(Prop)
        Prop = Prop or {};
        --
        local Window = ({
            Name        = Prop.Name or Prop.name,
            Icon        = Prop.Icon or Prop.icon,
            Size        = Prop.Size or Prop.size,
            Dragging    = { false, UDim2.new(0, 0, 0, 0) },
            PageAmmount = Prop.Amount or Prop.amount or 5,
            Elements    = {},
            Sections    = {},
            Pages       = {},
        });
        --
        Window.Background = Framework:New('TextButton', {
            Parent = Framework:New("ScreenGui", {
                Parent = Services.CoreGui, -- (gethui and gethui()) or (cloneref and cloneref(Services.CoreGui)) or Services.CoreGui,
                Name = Window.Name,
                IgnoreGuiInset = Enum.ScreenInsets.DeviceSafeInsets, 
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling, 
                DisplayOrder = 10
            }),
            AnchorPoint = Vector2.new(0, 0),
            Size = Window.Size,
            AutoButtonColor = false,
            Text = "",
            ZIndex = 10,
        }):Add({BackgroundColor3 = "Window"});

        Framework:New("ImageLabel", {
            Visible = true;
            ZIndex = -1,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ScaleType = Enum.ScaleType.Slice,
            Image = "rbxassetid://93984335181980",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,48,1,48),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            ImageColor3 = Color3.new(0, 0, 0),
            Parent = Window.Background
        }):Add({ImageColor3 = "Window"});

        local BG = Window.Background;
        Interface.ScreenGui = BG.Parent;

        Framework:New("UIStroke", {
            Enabled = true,
            Parent = BG,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1
        }):Add({Color = "Outline"});

        Window.BackgroundT = Framework:New("TextButton", {
            Parent = BG.Parent,
            AutoButtonColor = false,
            Text = "",
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0,99999,0,99999),
            BackgroundTransparency = 0.4,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = -1
        });

        local Dropper = {
            MinSize = 16;
            MaxSize = 50;
            FallTimeMin = 4;
            FallTimeMax = 10;
            SpawnRate = 0.15;
        };
        do -- Effects
            function Dropper.Spawn()
                local size = math.random(Dropper.MinSize, Dropper.MaxSize)

                local flake = Framework:New("ImageLabel", {
                    Parent = BG.Parent;
                    Size = UDim2.fromOffset(size, size);
                    BackgroundTransparency = 1;
                    Position = UDim2.new(math.random(), 0, -0.05, 0);
                    Image = Assets.Images:Require("Logo");
                    ImageTransparency = 0;
                    ZIndex = -1;
                }):Add({ ImageColor3 = "Accent" })

                local endY = 1.1
                local duration = math.random(Dropper.FallTimeMin, Dropper.FallTimeMax)

                Framework:Tween(flake, { Position = UDim2.new(flake.Position.X.Scale, 0, endY, 0) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, function()
                    if flake and flake._obj and flake._obj.Parent then
                        flake:Destroy()
                    end
                end)
            end;

            task.spawn(function()
                while task.wait(Dropper.SpawnRate) do
                    Dropper.Spawn()
                end
            end);
        end;

        Framework:New('UICorner', {
            Parent = BG,
            CornerRadius = UDim.new(0, 4)
        });

        -- Top
        Window.Top = Framework:New('Frame', { 
            Parent = BG,
            Size = UDim2.new(1, 0, 0, 60),
            Position = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1,
            Name = "Top",
        });

        Framework:New('Frame', { -- Outlines
            Name = "TopSeperator",
            Parent = Window.Top,
            Size = UDim2.new(1,0,0,1),
            Position = UDim2.new(0,0,1,0),
            ZIndex = 2,
        }):Add({BackgroundColor3 = "Outline"});

        Framework:New('Frame', { -- Outlines
            Name = "LogoSeperator",
            Parent = Window.Top,
            Size = UDim2.new(0,1,1,0),
            Position = UDim2.new(0,70,0,0),
            ZIndex = 2,
        }):Add({BackgroundColor3 = "Outline"});

        Window.LogoHolder = Framework:New('Frame', {
            Name = "LogoHolder",
            Parent = Window.Top,
            Size = UDim2.new(0,70,1,0),
            BackgroundTransparency = 1,
        });

        Window.Logo = Framework:New('ImageLabel', {
            Parent = Window.LogoHolder,
            BackgroundTransparency = 1,
            Image = Assets.Images:Require("Logo"),
            Size = UDim2.new(0,70,1,0),
        }):Add({ImageColor3 = "Accent"});

        Window.SearchBox = Framework:New('Frame', {
            Name = "SearchBox",
            Parent = Window.Top,
            Size = UDim2.new(0,205,1,0),
            Position = UDim2.new(0,70,0,0),
            BackgroundTransparency = 1,
        });

        Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 0);
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Horizontal;
            VerticalAlignment = Enum.VerticalAlignment.Top;
            Parent = Window.SearchBox;
        });

        Window.SearchHolder = Framework:New('Frame', {
            Name = "SearchHolder",
            Parent = Window.SearchBox,
            Size = UDim2.new(0.8,0,1,0),
            Position = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1,
        });

        Framework:New('ImageLabel', {
            Parent = Window.SearchHolder,
            BackgroundTransparency = 1,
            Image = Assets.Images:Require("Search"),
            Size = UDim2.new(0,14,0,14),
            Position = UDim2.new(0,-8,0,22),
        }):Add({ImageColor3 = "Inactive"});

        Window.SearchText = Framework:New("TextBox", {
            Name = "SearchText";
            Text = "Search...";
            FontFace = Interface.Font;
            TextSize = Interface.FontSize;
            TextXAlignment = Enum.TextXAlignment.Left;
            Parent = Window.SearchHolder;
            Size = UDim2.new(1,0,1,0);
            Position = UDim2.new(0,14,0,0);
            BackgroundTransparency = 1;
            TextTruncate = Enum.TextTruncate.AtEnd;
            ClearTextOnFocus = false;
        }):Add({TextColor3 = "Inactive"})

        Framework:Connect(Window.SearchText.Focused, function()
            if Window.SearchText.Text == "Search..." then
                Window.SearchText.Text = ""
            end
        end)

        Framework:Connect(Window.SearchText.FocusLost, function(enterPressed)
            if Window.SearchText.Text == "" then
                Window.SearchText.Text = "Search..."
            end
        end)

        local function UpdateSearchResults(query)
            query = string.lower(query)
            for _, obj in ipairs(Interface.ScreenGui:GetDescendants()) do
                if obj.Name == "SectionContent" and obj:IsA("Frame") then
                    for _, item in ipairs(obj:GetChildren()) do
                        if item:IsA("GuiObject") then
                            if query == "" or query == "search..." then
                                item.Visible = true
                            else
                                if string.find(string.lower(item.Name), query, 1, true) then
                                    item.Visible = true
                                else
                                    item.Visible = false
                                end
                            end
                        end
                    end
                end
            end
        end

        Framework:Connect(Window.SearchText:GetPropertyChangedSignal("Text"), function()
            UpdateSearchResults(Window.SearchText.Text)
        end)

        Framework:Connect(Window.SearchText.FocusLost, function()
            if Window.SearchText.Text == "" or Window.SearchText.Text == "Search..." then
                Window.SearchText.Text = "Search..."
                UpdateSearchResults("")
            end
        end)

        Window.TabContainer = Framework:New('Frame', {
            Name = "TabHolder",
            Parent = Window.Top,
            Size = UDim2.new(1,-290,1,0),
            Position = UDim2.new(1,-10,0,0),
            AnchorPoint = Vector2.new(1,0),
            BackgroundTransparency = 1,
        });

        -- Middle
        Window.Middle = Framework:New('TextButton', {
            Name = "Middle",
            Parent = BG,
            Size = UDim2.new(1, 0, 1, -100),
            ZIndex = -1,
            Position = UDim2.new(0, 0, 0, 60),
            BackgroundTransparency = 0,
            AutoButtonColor = false,
            Text = "",
        }):Add({BackgroundColor3 = "Middle"});

        -- Bottom
        Window.Bottom = Framework:New('Frame', { 
            Parent = BG,
            Size = UDim2.new(1, 0, 0, 40),
            AnchorPoint = Vector2.new(0,1),
            Position = UDim2.new(0,0,1,0),
            BackgroundTransparency = 1,
            Name = "Bottom",
        });

        Window.MenuKey = Framework:New('TextLabel', {
            Name = "MenuKey",
            Text = "",
            FontFace = Interface.Font;
            TextSize = Interface.FontSize;
            TextXAlignment = Enum.TextXAlignment.Right,
            TextYAlignment = Enum.TextYAlignment.Center,
            Parent = Window.Bottom,
            Size = UDim2.new(0,100,1,0),
            Position = UDim2.new(1,-100,0,0),
            BackgroundTransparency = 1,
        }):Add({TextColor3 = "Active"});

        Framework:New("UIPadding", {
            PaddingRight = UDim.new(0, 8);
            Parent = Window.MenuKey
        });

        Framework:New('Frame', { -- Outlines
            Name = "BottomSeperator",
            Parent = Window.Bottom,
            Size = UDim2.new(1,0,0,1),
            Position = UDim2.new(0,0,0,0),
            ZIndex = 2,
        }):Add({BackgroundColor3 = "Outline"});

        Window.DiscordHolder = Framework:New('Frame', { 
            Parent = Window.Bottom,
            Size = UDim2.new(0, 50, 1, 0),
            Position = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1,
            Name = "DiscordHolder",
            ZIndex = 2;
        });
        
        Window.Expiry = Framework:New('TextLabel', {
            Text = "",
            AutomaticSize = Enum.AutomaticSize.XY,
            FontFace = Interface.Font;
            TextSize = Interface.FontSize;
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Parent = Window.DiscordHolder,
            RichText = true,
            Size = UDim2.new(-1,0,1,0),
            Position = UDim2.new(1,0,0,0),
            BackgroundTransparency = 1,
        }):Add({TextColor3 = "Active"});

        Framework:New('TextLabel', {
            Text = "",
            AutomaticSize = Enum.AutomaticSize.XY,
            FontFace = Interface.Font;
            TextSize = Interface.FontSize;
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Parent = Window.DiscordHolder,
            RichText = true,
            Size = UDim2.new(-1,0,1,0),
            Position = UDim2.new(1,0,0,0),
            BackgroundTransparency = 1,
        }):Add({TextColor3 = "Accent"});

        Framework:New("UIListLayout", {
            Parent = Window.DiscordHolder,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            FillDirection = Enum.FillDirection.Horizontal,
        });

        Framework:New("UIPadding", {
            PaddingLeft = UDim.new(0, 10);
            Parent = Window.DiscordHolder
        });

        --[[Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 0);
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Horizontal;
            VerticalAlignment = Enum.VerticalAlignment.Center;
            Parent = Window.DiscordHolder;
        });

        Window.DiscordAvatar = Framework:New("ImageLabel", {
            Parent = Window.DiscordHolder;
            ZIndex = 2;
            BackgroundTransparency = 1;
            Position = UDim2.new(1, -45, 0, 5);
            Size = UDim2.new(1, -15, 1, -15);
            BorderSizePixel = 0;
            Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
        });
        Framework:New("UICorner", { Parent = Window.DiscordAvatar; CornerRadius = UDim.new(1, 0) });

        local id, hash, _url, _file;
        do -- Profile
            if (Discord) then
                id = Discord.id;
                hash = Discord.avatar;
                if id and hash then
                    _url = "https://cdn.discordapp.com/avatars/" .. id .. "/" .. hash .. ".png";
                    _file = gamepath.."Images/avatar_" .. id .. ".png";
                end;
            end;
            --
            if (_url and _file and not isfile(_file)) then
                local success, data = pcall(function() return game:HttpGet(_url, true); end);
                if success then
                    writefile(_file, data);
                else
                    Window.DiscordAvatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
                end;
            end;
        end;
        Window.DiscordAvatar.Image = (_file and isfile(_file) and (pcall(function() return getcustomasset(_file); end) and getcustomasset(_file) or "rbxasset://textures/ui/GuiImagePlaceholder.png")) or "rbxasset://textures/ui/GuiImagePlaceholder.png";

        Framework:New('Frame', { -- Outlines
            Name = "DiscordSeperator",
            Parent = Window.Bottom,
            Size = UDim2.new(0,1,1,0),
            Position = UDim2.new(0,50,0,0),
            ZIndex = 2,
        }):Add({BackgroundColor3 = "Outline"});]]

        Window.Resize = Framework:New('TextButton', {
            Parent = Window.Bottom,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0,15,0.3,0),
            Position = UDim2.new(1,0,1,0),
            ZIndex = 2,
            AutoButtonColor = false,
            Text = "",
        });

        -- Other
        Services.UserInputService.MouseIconEnabled = false;
        Window.Cursor = Framework:New('ImageLabel', {
            Parent = BG.Parent,
            BackgroundTransparency = 1,
            Image = Assets.Images:Require("Cursor"),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(Mouse.X, Mouse.Y),
            Size = UDim2.fromOffset(18, 18),
            ImageColor3 = Color3.fromRGB(200, 200, 200),
            ZIndex = 99999,
            Rotation = -45
        });

        Mouse.Move:Connect(function()
            local mouse_pos = Services.UserInputService:GetMouseLocation();
            local inset = Services.GuiService:GetGuiInset();
            Window.Cursor.Position = UDim2.fromOffset(mouse_pos.X - inset.X + 4, mouse_pos.Y - inset.Y + 65);
        end);

        Framework:Resize(
            Window.Resize,
            BG,
            Window.Cursor,
            Assets.Images:Require("Cursor"),
            Assets.Images:Require("ResizeCursor")
        );

        -- Ui Controls
        do
            local state = {
                pos = UDim2.new(0.5,-BG.AbsoluteSize.X/2,1.1,0);
                target = UDim2.new(0.5,-BG.AbsoluteSize.X/2,0.5,-BG.AbsoluteSize.Y/2);
            };
            Framework:Drag(BG, 10, state)

            local ModalElement = Framework:New('TextButton', {
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 0, 0, 0);
                Visible = true;
                Text = '';
                Modal = false;
                Parent = Interface.ScreenGui;
            });

            do -- Open/Close
                Framework:Tween(Blur, {Size = Interface.Open and 10 or 0}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);

                local oldMouse = Services.UserInputService.MouseIconEnabled;
                Framework:Connect(Services.UserInputService.InputBegan, function(input, gpe)
                    if gpe then return end
                    if not Interface.CanOpen then return end
                    if Interface.Bind and (input.KeyCode == Interface.Bind or input.UserInputType == Interface.Bind) then
                        Interface.CanOpen = false
                        Interface.Open = not Interface.Open
                        ModalElement.Modal = Interface.Open

                        Framework:Tween(Blur, {Size = Interface.Open and 10 or 0}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        Framework:Tween(Window.BackgroundT, {BackgroundTransparency = Interface.Open and 0.4 or 1}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        Framework:Tween(Window.Cursor, {ImageTransparency = Interface.Open and 0 or 1}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

                        for _, flake in ipairs(BG.Parent:GetChildren()) do
                            if flake:IsA("ImageLabel") and flake.Image == Assets.Images:Require("Logo") then
                                if Interface.Open then
                                    Framework:Tween(flake, {ImageTransparency = 0}, 0.3, Enum.EasingStyle.Linear)
                                else
                                    Framework:Tween(flake, {ImageTransparency = 1}, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, function()
                                        flake:Destroy()
                                    end)
                                end
                            end
                        end

                        if Interface.Open then
                            oldMouse = Services.UserInputService.MouseIconEnabled;
                            Services.UserInputService.MouseIconEnabled = false;
                            Interface.ScreenGui.Enabled = true;
                            state.target = UDim2.new(0.5, -BG.AbsoluteSize.X/2, 0.5, -BG.AbsoluteSize.Y/2);
                            task.delay(0.3, function() Interface.CanOpen = true end);
                        else
                            state.target = UDim2.new(0.5, -BG.AbsoluteSize.X/2, 1.1, 0);
                            task.delay(0.3, function()
                                Services.UserInputService.MouseIconEnabled = oldMouse;
                                Interface.ScreenGui.Enabled = false;
                                Interface.CanOpen = true;
                            end);
                        end;
                    end;
                end);
                ModalElement.Modal = Interface.Open;
            end;
        end;

        Window.Elements = {
            TabHolder = Window.TabContainer,
            Holder = Window.Middle,
            Base = Window.Background,
        };
        --
        function Window:UpdateTabs()
            for _, v in pairs(Window.Pages) do
                v:Turn(v.Open);
            end;
        end;
        --
        function Window:Watermark()
            local Watermark = { };
            Interface.WatermarkGui = Watermark;

            Watermark.Background = Framework:New("TextButton", {
                Parent = Framework:New("ScreenGui", {
                    Parent = (gethui and gethui()) or (cloneref and cloneref(Services.CoreGui)) or Services.CoreGui,
                    Name = "Watermark",
                    IgnoreGuiInset = Enum.ScreenInsets.DeviceSafeInsets, 
                    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, 
                    DisplayOrder = 11
                }),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, -1000, 0.5, -550),
                Size = UDim2.new(0, 200, 0, 30),
                AutomaticSize = Enum.AutomaticSize.X,
                AutoButtonColor = false,
                Text = "",
                ZIndex = 10,
                Name = "Watermark"
            }):Add({BackgroundColor3 = "Window"});

            Framework:Glow(Watermark.Background, Color3.new(0, 0, 0));

            Framework:New("UIStroke", {
                Enabled = true,
                Parent = Watermark.Background,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 1
            }):Add({Color = "Outline"});

            Framework:New('UICorner', {
                Parent = Watermark.Background,
                CornerRadius = UDim.new(0, 4)
            });

            Framework:New("Frame", {
                Parent = Watermark.Background,
                Position = UDim2.new(0, 2, 0, 3),
                Size = UDim2.new(0, 2, 1, -6),
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
            }):Add({BackgroundColor3 = "Accent"});

            Framework:New("Frame", {
                Parent = Watermark.Background,
                Position = UDim2.new(1, -2, 0, 3),
                Size = UDim2.new(0, -2, 1, -6),
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
            }):Add({BackgroundColor3 = "Accent"});

            Framework:New("ImageLabel", {
                Parent = Watermark.Background,
                Position = UDim2.new(0, 4, 0, 0),
                Size = UDim2.new(0, 30, 1, 0),
                BackgroundTransparency = 1,
                Image = Assets.Images:Require("Logo"),
                ImageTransparency = 0,
                ZIndex = 1,
            }):Add({ImageColor3 = "Accent"});

            Watermark.Label = Framework:New("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                RichText = true,
                AutomaticSize = Enum.AutomaticSize.X,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextStrokeTransparency = 1,
                TextSize = Interface.FontSize,
                FontFace = Interface.Font,
                Position = UDim2.new(0, 25, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                Parent = Watermark.Background,
            }):Add({TextColor3 = "Active"});

            Framework:New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = Watermark.Label,
            });

            Framework:Drag(Watermark.Background, 10, { pos = Watermark.Background.Position, target = Watermark.Background.Position });

            function Watermark:SetVisible(State)
                self.Background.Visible = State;
            end;

            function Watermark:UpdateText(NewText, Options)
                Options = Options or {};
                local FinalText = NewText;
                local Parts = {};

                local function Colorize(Value)
                    local c = Framework.Theme.Colors.Accent
                    return string.format('<font color="#%02x%02x%02x">%s</font>', 
                        math.clamp(c.R*255, 0, 255), 
                        math.clamp(c.G*255, 0, 255), 
                        math.clamp(c.B*255, 0, 255), 
                        tostring(Value)
                    );
                end;

                if Options.Version then
                    local version = (not LPH_OBFUSCATED) and "Developer" or "Public"
                    table.insert(Parts,
                        '<font color="#'..string.format("%02x%02x%02x",
                            Framework.Theme.Colors.Active.R*255,
                            Framework.Theme.Colors.Active.G*255,
                            Framework.Theme.Colors.Active.B*255
                        )..'">Version: </font>'..Colorize(version)
                    );
                end;

                if Options.UID then 
                    local uid = (Interface.UID_Data and Interface.UID_Data.uid) or "..."
                    local uids_active = (Interface.UID_Data and Interface.UID_Data.uids_active) or "..."
                    local text = tostring(uid) .. "/" .. tostring(uids_active)
                    table.insert(Parts, '<font color="#'..string.format("%02x%02x%02x", Framework.Theme.Colors.Active.R*255, Framework.Theme.Colors.Active.G*255, Framework.Theme.Colors.Active.B*255)..'">UID: </font>'..Colorize(text)); 
                end;

                if Options.PlayerCount then
                    local players = Services.Players:GetPlayers()
                    local playerCount = #players
                    local maxPlayers = Services.Players.MaxPlayers
                    local text = string.format("%d/%d", playerCount, maxPlayers)
                    table.insert(Parts, '<font color="#'..string.format("%02x%02x%02x", Framework.Theme.Colors.Active.R*255, Framework.Theme.Colors.Active.G*255, Framework.Theme.Colors.Active.B*255)..'">Players: </font>'..Colorize(text));
                end;

                if Options.Ping then
                    local stats = Framework.Services.Stats.Network.ServerStatsItem
                    local ping = (stats and stats:FindFirstChild("Data Ping") and math.floor(stats["Data Ping"]:GetValue())) or "..."
                    table.insert(Parts, '<font color="#'..string.format("%02x%02x%02x", Framework.Theme.Colors.Active.R*255, Framework.Theme.Colors.Active.G*255, Framework.Theme.Colors.Active.B*255)..'">Ping: </font>'..Colorize(ping));
                end;

                if #Parts > 0 then 
                    FinalText = FinalText.." | "..table.concat(Parts, " | "); 
                end;

                self.Label.Text = FinalText;

                task.defer(function()
                    if self.Label and self.Background then
                        local Width = self.Label.TextBounds.X;
                        self.Background.Size = UDim2.new(0, Width, self.Background.Size.Y.Scale, self.Background.Size.Y.Offset);
                    end;
                end);
            end;

            task.spawn(function()
                while task.wait(1) do
                    Watermark:UpdateText("s.win", { Username = true, UID = true, PlayerCount = true, Ping = true, Version = true });
                end;
            end);

            return Watermark;
        end;
        Window:Watermark();
        --
        function Window:IndicatorGui()
            local Indicator = { Keybinds = {} };
            Interface.IndicatorGui = Indicator;
            --
            Indicator.Background = Framework:New("TextButton", {
                Parent = Framework:New("ScreenGui", {
                    Parent = (gethui and gethui()) or (cloneref and cloneref(Services.CoreGui)) or Services.CoreGui,
                    Name = "Indicator",
                    IgnoreGuiInset = Enum.ScreenInsets.DeviceSafeInsets, 
                    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, 
                    DisplayOrder = 11
                }),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, -1116, 0.5, -50),
                Size = UDim2.new(0, 200, 0, 40),
                AutomaticSize = Enum.AutomaticSize.XY,
                AutoButtonColor = false,
                Text = "",
                ZIndex = 10,
                Name = "Indicator"
            }):Add({BackgroundColor3 = "Window"});

            Framework:Glow(Indicator.Background, Color3.new(0, 0, 0))

            Framework:New("UIStroke", {
                Enabled = true,
                Parent = Indicator.Background,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 1
            }):Add({Color = "Outline"});

            Framework:New('UICorner', {
                Parent = Indicator.Background,
                CornerRadius = UDim.new(0, 5)
            });

            Indicator.Label = Framework:New("TextLabel", {
                Name = "Label";
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                RichText = true;
                Text = "Keybind List";
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Center;
                TextStrokeTransparency = 1;
                TextSize = Interface.FontSize;
                FontFace = Interface.Font;
                Size = UDim2.new(1, 0, 0, 30);
                Parent = Indicator.Background;
            }):Add({TextColor3 = "Accent"});

            Framework:New("UIPadding", {
                Name = "UIPadding";
                PaddingLeft = UDim.new(0, 30);
                Parent = Indicator.Label
            });

            Framework:New("ImageLabel", {
                Parent = Indicator.Background;
                Position = UDim2.new(0, 8, 0, 7),
                Size = UDim2.new(0, 16, 0, 16);
                BackgroundTransparency = 1;
                Image = Assets.Images:Require("Keyboard");
                ImageTransparency = 0;
                ZIndex = 1;
            }):Add({ImageColor3 = "Accent"});

            Indicator.List = Framework:New("Frame", {
                Parent = Indicator.Background,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 0),
                Position = UDim2.new(0, 5, 0, 40),
                AutomaticSize = Enum.AutomaticSize.Y
            });

            Framework:New("UIPadding", {
                Name = "UIPadding";
                PaddingLeft = UDim.new(0, 3);
                PaddingBottom = UDim.new(0, 8);
                Parent = Indicator.List
            });

            Indicator.ListLayout = Framework:New("UIListLayout", {
                Parent = Indicator.List,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            });

            Framework:New("Frame", {
                Parent = Indicator.Background,
                Position = UDim2.new(0, 5, 0, 30),
                Size = UDim2.new(1, -10, 0, 1),
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
            }):Add({BackgroundColor3 = "Outline"});

            Framework:Drag(Indicator.Background, 10, { pos = Indicator.Background.Position, target = Indicator.Background.Position });

            function Indicator:SetVisible(State)
                self.Background.Visible = State;
            end;

            function Indicator:NewKey(Key, Name)
                local Holder = Framework:New("Frame", {
                    Parent = self.List,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,0,0),
                    Visible = false
                })

                Framework:New("UIListLayout", {
                    Parent = Holder,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    Padding = UDim.new(0, 4),
                })

                local NameLabel = Framework:New("TextLabel", {
                    Parent = Holder,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Interface.Font,
                    TextSize = Interface.FontSize,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextTransparency = 1,
                }):Add({ TextColor3 = "Active" }) 

                local KeyLabel = Framework:New("TextLabel", {
                    Parent = Holder,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Interface.Font,
                    TextSize = Interface.FontSize,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextTransparency = 1,
                }):Add({ TextColor3 = "Accent" }) 

                local KeyValue = {}
                local SizeTween, FadeTween

                local function GetLineHeight()
                    return math.max(NameLabel.TextBounds.Y, KeyLabel.TextBounds.Y)
                end

                function KeyValue:SetVisible(State)
                    if State then
                        Holder.Visible = true

                        local height = GetLineHeight()

                        if SizeTween then SizeTween:Cancel() end
                        if FadeTween then FadeTween:Cancel() end

                        Holder.Size = UDim2.new(1,0,0,height)
                        
                        SizeTween = Framework:Tween(Holder, { Size = UDim2.new(1,0,0,height) }, 0.15)
                        Framework:Tween(NameLabel, { TextTransparency = 0 }, 0.15)
                        Framework:Tween(KeyLabel,  { TextTransparency = 0 }, 0.15)

                    else
                        if FadeTween then FadeTween:Cancel() end
                        if SizeTween then SizeTween:Cancel() end

                        Framework:Tween(NameLabel, { TextTransparency = 1 }, 0.15)
                        Framework:Tween(KeyLabel,  { TextTransparency = 1 }, 0.15)

                        SizeTween = Framework:Tween(Holder, { Size = UDim2.new(1,0,0,0) }, 0.15, nil, nil, function()
                            Holder.Visible = false
                        end)
                    end
                end

                function KeyValue:Update(NKey, NewName)
                    NameLabel.Text = tostring(NewName) .. ":"
                    KeyLabel.Text  = "[" .. tostring(NKey) .. "]"

                    if Holder.Visible then
                        local height = GetLineHeight()
                        if SizeTween then SizeTween:Cancel() end
                        SizeTween = Framework:Tween(Holder, { Size = UDim2.new(1,0,0,height) }, 0.15)
                    end
                end

                KeyValue:Update(Key, Name)
                return KeyValue;
            end;

            return Indicator;
        end;
        Window:IndicatorGui();
        --
        return setmetatable(Window, Interface);
    end;

    -- Tab
    function Interface:Tab(Prop)
        Prop = Prop or {};
        --
        local Page = ({
            Name       = ( Prop.Name or Prop.name or "page" ),
            Icon       = ( Prop.icon or Prop.Icon or "" ),
            Size       = ( Prop.size or Prop.Size or UDim2.new(0, 16, 0, 16)),
            SubTabOpen = ( Prop.SubTabs or false ),
            Window     = self,
            Open       = false,
            Sections   = {},
            Pages      = {},
            Elements   = {},
            Sub_Tabs   = {},
        });
        --
        if (not Page.Window.Elements.TabHolder:FindFirstChild("UIListLayout")) then
            Framework:New("UIListLayout", {
                Name = "UIListLayout";
                Padding = UDim.new(0, 10);
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder;
                FillDirection = Enum.FillDirection.Horizontal;
                VerticalAlignment = Enum.VerticalAlignment.Top;
                Parent = Page.Window.Elements.TabHolder;
            });
        end;

        local parent = Prop.parent or Page.Window.Elements.TabHolder;
        Page.TabButton = Framework:New("TextButton", {
            Name = Page.Name;
            AutoButtonColor = false;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(0, 70, 1, 0);
            Text = "";
            Parent = parent;
        });

       Framework:New("UIGradient", {
            Rotation = -90,
            Parent = Page.TabButton,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.69),   
                NumberSequenceKeypoint.new(1, 1)  
            },
        }):Add({Color = "LineGradient"});

        Page.TabLine = Framework:New("Frame", {
            Name = "TabLine";
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 1, -1);
            Size = UDim2.new(1, 0, 0, 1);
            Parent = Page.TabButton;
        }):Add({BackgroundColor3 = "Accent"});

        Page.TabButtonHolder = Framework:New("Frame", {
            Name = "TabButtonHolder";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            Parent = Page.TabButton;
        });

        Framework:New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = Page.TabButtonHolder
        });

        Page.TextButton = Framework:New("TextLabel", {
            Name = "TextButton";
            Text = Page.Name;
            FontFace = Interface.Font;
            TextColor3 = Color3.fromRGB(220, 210, 210);
            TextSize = Interface.FontSize;
            BackgroundTransparency = 1;
            TextStrokeTransparency = 1;
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X; 
            Size = UDim2.new(0, 0, 1, 0); 
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Center;
            Parent = Page.TabButtonHolder;
        });

        Page.TabButtonHolder2 = Framework:New("Frame", {
            Name = "TabButtonHolder2";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            Parent = Page.TabButton;
        });

        Framework:New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = Page.TabButtonHolder2
        });

        Page.ImageButton = Framework:New("ImageLabel", {
            Name = "ImageButton";
            Image = Page.Icon;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Size = Page.Size;
            Parent = Page.TabButtonHolder2;
        });

        Page.NewPage = Framework:New("ScrollingFrame", {
            Name = "NewPage";
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 0, 12);
            Size = UDim2.new(1, -4, 1, -20);
            ScrollBarThickness = 3;
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
            Visible = false;
            CanvasSize = UDim2.new(0, 0, 1.25, 0),
            Parent = Page.Window.Elements.Holder;
        }):Add({ScrollBarImageColor3 = "Accent"});

        local ScrollingLine = Page.Window.Elements.Holder:FindFirstChild("ScrollingLine")
        if not ScrollingLine then
            ScrollingLine = Framework:New("Frame", {
                Name = "ScrollingLine";
                BackgroundTransparency = 0;
                BorderSizePixel = 0;
                Parent = Page.Window.Elements.Holder;
                ZIndex = -1;
            }):Add({BackgroundColor3 = "Outline"});

            Framework:New("UICorner", {
                Parent = ScrollingLine,
                CornerRadius = UDim.new(1, 0);
            });
        end

        local Left = Framework:New("Frame", {
            Name = "Left";
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 8, 0, 0),
            Size = UDim2.new(0.5, -16, 1, 0);
            ZIndex = 2;
            Parent = Page.NewPage;
        });

        Framework:New("UIPadding", {
            Name = "UIPadding";
            PaddingTop = UDim.new(0, 30);
            Parent = Left
        });

        Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 40);
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Left;
        });

        local Right = Framework:New("Frame", {
            Name = "Right";
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0.5, 4, 0, 0);
            Size = UDim2.new(0.5, -16, 1, 0);
            Parent = Page.NewPage;
        });

        Framework:New("UIPadding", {
            Name = "UIPadding";
            PaddingTop = UDim.new(0, 30);
            Parent = Right
        });

        Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 40);
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Right;
        });

        local Sub_Tabs = Framework:New("Frame", {
            Name = "SubTabs";
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Size = UDim2.new(1, -50, 0, 30);
            Position = UDim2.new(0, 149, 0, 15);
            Visible = false;
            Parent = Page.Window.Elements.Holder;
        }):Add({BackgroundColor3 = "Outline"});

        local SubTabHolder = Framework:New("Frame", {
            Name = "SubTabsHolder";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            Position = UDim2.new(0, 0, 0, 0);
            Parent = Sub_Tabs;
        });
        
        Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Horizontal;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = SubTabHolder;
        });

        do -- AutoSize
            local Tabs, spacing, padding = {}, 10, 15
            for _, v in pairs(parent:GetChildren()) do if v:IsA("GuiObject") and not v:IsA("UIListLayout") and not v:IsA("UIGridLayout") then table.insert(Tabs, v) end end
            if #Tabs > 0 then
                local totalWidth, widths = 0, {};

                for _, tab in ipairs(Tabs) do
                    local holder, layout = tab:FindFirstChild("TabButtonHolder"), tab:FindFirstChild("TabButtonHolder") and tab:FindFirstChild("TabButtonHolder"):FindFirstChildOfClass("UIListLayout")
                    local width = (holder and layout and layout.AbsoluteContentSize.X + padding*2) or 50
                    table.insert(widths, width)
                    totalWidth = totalWidth + width + spacing
                end

                totalWidth = totalWidth - spacing
                local scale, currentX = 1 / totalWidth, 0

                for i, tab in ipairs(Tabs) do
                    local width = widths[i] * scale
                    tab.Size, tab.Position = UDim2.new(width, 0, 1, 0), UDim2.new(currentX, 0, 0, 0)
                    currentX = currentX + width + spacing*scale
                end;
            end;
        end;

        function Page:Turn(bool)
            Page.Open = bool;
            if not Page.SubTabOpen then
                Page.NewPage.Visible = Page.Open;
                Framework:Tween(ScrollingLine, { Size = UDim2.new(0, 4, 1, -20), Position = UDim2.new(1, -8, 0, 12) }, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            else
                Framework:Tween(ScrollingLine, { Size = UDim2.new(0, 4, 1, -80), Position = UDim2.new(1, -8, 0, 72) }, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                Framework:Tween(Sub_Tabs, { Position = Page.Open and UDim2.new(0, 9, 0, 15) or UDim2.new(0, 149, 0, 15) }, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
                Sub_Tabs.Visible = Page.Open;
                for _, v in pairs(Page.Sub_Tabs) do v:Turn(v.Open); end;
            end;

            if Page.Open then
                Framework:FadeIn(Page.NewPage);
            end;

            Framework:Tween(Page.TabButton, { BackgroundTransparency = bool and 0 or 1 }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
            Framework:Tween(Page.TabLine, { BackgroundTransparency = bool and 0 or 1 }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
            Framework:TweenTheme(Page.ImageButton, { ImageColor3 = bool and "Accent" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
            Framework:TweenTheme(Page.TextButton, { TextColor3 = bool and "Active" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
        end;

        Framework:Connect(Page.TabButton.MouseButton1Down, function()
            if (not Page.Open) then
                for _, v in pairs(Page.Window.Pages) do
                    if v.Open and v ~= Page then
                        v:Turn(false);
                    end
                end
                Page:Turn(true);
            end;
        end);

        function Page:UpdateSubTabs()
            for _, v in pairs(Page.Sub_Tabs) do
                v:Turn(v.Open);
            end;
        end;
        --
        Page.Elements = {
            Left = Page.SubTabOpen and nil or Left,
            Right = Page.SubTabOpen and nil or Right,
            Sub_Tab_Holder = SubTabHolder,
            New_Page = NewPage,
            ScrollingLine = ScrollingLine,
        };

		if #Page.Window.Pages == 0 then
            Page:Turn(true);
        end;
        Page.Window.Pages[#Page.Window.Pages + 1] = Page;
        Interface.Pages[#Interface.Pages + 1] = Page;
        Page.Window:UpdateTabs();
        return setmetatable(Page, Interface.Pages);
    end;

    -- Subtab
    function Pages:SubTab(Prop)
        Prop = Prop or {};
        --
        local SubTab = {
            Name     = ( Prop.Name or Prop.name or "Test" ),
            Page     = self,
            Open     = false,
            Sections = {},
            Elements = {},
        };
        --
        local NewSubTab = Framework:New("TextButton", {
            Name = "NewSubTab";
            BackgroundTransparency = 0;
            BorderSizePixel = 1;
            Size = UDim2.new(0, 0, 1, 0);
            Parent = SubTab.Page.Elements.Sub_Tab_Holder;
            Text = SubTab.Name;
            FontFace = Interface.Font;
            AutoButtonColor = false;
            TextSize = Interface.FontSize;
            TextStrokeTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Center;
            TextYAlignment = Enum.TextYAlignment.Center;
        }):Add({BackgroundColor3 = "Middle", BorderColor3 = "Outline", TextColor3 = "Inactive"});
        task.defer(function()
            local padding = 69;
            NewSubTab.Size = UDim2.new(0, NewSubTab.TextBounds.X + padding, 1, 0)
        end);

        local SubTabStroke = Framework:New("UIStroke", {
            Enabled = true,
            Parent = NewSubTab,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1
        }):Add({Color = "Outline"});

        Framework:New('UICorner', {
            Parent = NewSubTab,
            CornerRadius = UDim.new(0, 5)
        });

        local NewPage = Framework:New("ScrollingFrame", {
            Name = "NewPage";
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 0, 66);
            Size = UDim2.new(1, -4, 1, -74);
            ScrollBarThickness = 3;
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
            Visible = false;
            CanvasSize = UDim2.new(0, 0, 1.25, 0),
            Parent = SubTab.Page.Window.Elements.Holder;
        }):Add({ScrollBarImageColor3 = "Accent"});

        local Left = Framework:New("Frame", {
            Name = "Left";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 8, 0, 0);
            Size = UDim2.new(0.5, -16, 1, 0);
            ZIndex = 2;
            Parent = NewPage;
        });

        Framework:New("UIPadding", {
            Name = "UIPadding";
            PaddingTop = UDim.new(0, 20);
            Parent = Left
        });

        Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 40);
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Left;
        });

        local Right = Framework:New("Frame", {
            Name = "Right";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0.5, 4, 0, 0),
            Size = UDim2.new(0.5, -16, 1, 0);
            Parent = NewPage;
        });

        Framework:New("UIPadding", {
            Name = "UIPadding";
            PaddingTop = UDim.new(0, 20);
            Parent = Right
        });

        Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 40);
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Right;
        });

        function SubTab:Turn(bool)
            SubTab.Open = bool;
            NewPage.Visible = SubTab.Open and SubTab.Page.Open;

            if SubTab.Open then
                Framework:FadeIn(NewPage);
            end;

            Framework:TweenTheme(SubTabStroke, { Color = SubTab.Open and "Outline" or "Middle" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Framework:TweenTheme(NewSubTab, { TextColor3 = SubTab.Open and "Active" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end;
        --
        Framework:Connect(NewSubTab.MouseButton1Down, function()
            if not SubTab.Open then
                SubTab:Turn(true);
                for _, v in pairs(SubTab.Page.Sub_Tabs) do
                    if v.Open and v ~= SubTab then
                        v:Turn(false);
                    end;
                end;
            end;
        end);
        --
        SubTab.Elements = {
            Left = Left,
            Right = Right,
            Button = NewSubTab,
            Main = NewPage
        };

        local Scrolling_Line = SubTab.Page.Elements.ScrollingLine;
        if #SubTab.Page.Sub_Tabs == 0 then
            SubTab:Turn(true);

            task.defer(function()
                if (Scrolling_Line) then
                    Framework:Tween(Scrolling_Line, { Size = UDim2.new(0,4,1,-80), Position = UDim2.new(1,-8,0,72)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                end;
            end);
        end;

        SubTab.Page.Sub_Tabs[#SubTab.Page.Sub_Tabs + 1] = SubTab;
        SubTab.Page:UpdateSubTabs();
        return setmetatable(SubTab, Interface.Pages);
    end;

    -- Section
    function Pages:Section(Prop)
        Prop = Prop or {};
        --
        local Section = {
            Name      = Prop.Name or "Section",
            Page      = self,
            Side      = (Prop.side or Prop.Side or "left"):lower(),
            Zindex    = (Prop.Zindex or Prop.zindex or 1),
            Collapsed = false,
            Elements  = {},
            Content   = {},
            Sections  = {}
        };
        --
        local SectionHolder = Framework:New("Frame", {
            Name = "SectionHolder";
            AutomaticSize = Enum.AutomaticSize.Y;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            Size = UDim2.new(1, 0, 0, 20);
            Parent = Section.Side == "left" and Section.Page.Elements.Left or Section.Side == "right" and Section.Page.Elements.Right;
            ZIndex = 10 - #Section.Page.Sections
        }):Add({BackgroundColor3 = "Window"});

        Framework:New('UICorner', {
            Parent = SectionHolder,
            CornerRadius = UDim.new(0, 5)
        });

        local Title = Framework:New("TextLabel", {
            Name = "Title";
            FontFace = Interface.Font;
            TextSize = Interface.FontSize;
            Text = Section.Name;
            TextStrokeTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 5, 0, -25);
            Size = UDim2.new(0, 0, 0, 20);
            AutomaticSize = Enum.AutomaticSize.X;
            Parent = SectionHolder
        }):Add({TextColor3 = "Inactive"})

        local padding = 5;
        local Collapse = Framework:New("TextButton", {
            Name = "Collapse";
            Text = "︿";
            Font = Enum.Font.GothamBlack; 
            TextSize = 16;
            TextStrokeTransparency = 1;
            BackgroundTransparency = 1;
            AutoButtonColor = false;
            BorderSizePixel = 0;
            Size = UDim2.new(0, 14, 0, 14);
            Position = UDim2.new(1, padding, 0, 8);
            Rotation = 180;
            Parent = Title;
        }):Add({TextColor3 = "Inactive"});

        local SectionContent = Framework:New("Frame", {
            Name = "SectionContent";
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 8, 0, 10);
            Size = UDim2.new(1, -16, 0, 0);
            Parent = SectionHolder;
        });

        Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 12);
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = SectionContent
        });

        local UIPadding = Framework:New("UIPadding", {
            Name = "UIPadding";
            PaddingBottom = UDim.new(0, 10);
            Parent = SectionContent
        });

        local originalSize = SectionHolder.Size;
        local originalPosition = SectionContent.Position;
        local collapsedY = 0;
        local expandedY = 8;
        Collapse.MouseButton1Click:Connect(function()
            Section.Collapsed = (not Section.Collapsed);

            if (Section.Collapsed) then
                for _, obj in ipairs(SectionContent:GetDescendants()) do
                    if obj:IsA("GuiObject") and obj.Visible == true then
                        obj:SetAttribute("WasVisibleBeforeCollapse", true);
                        obj.Visible = false;
                    end;
                end;
                UIPadding.PaddingBottom = UDim.new(0, 0)
                Framework:Tween(SectionHolder, { Size = UDim2.new(1, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                Framework:Tween(SectionContent, { Position = UDim2.new(0, 8, 0, 0) }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                Framework:Tween(Collapse, { Rotation = 0, Position = UDim2.new(Collapse.Position.X.Scale, Collapse.Position.X.Offset, 0, collapsedY) }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            else
                UIPadding.PaddingBottom = UDim.new(0, 10)
                Framework:Tween(SectionHolder, { Size = originalSize }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                Framework:Tween(SectionContent, { Position = originalPosition }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                Framework:Tween(Collapse, { Rotation = 180, Position = UDim2.new(Collapse.Position.X.Scale, Collapse.Position.X.Offset, 0, expandedY) }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                --
                for _, obj in ipairs(SectionContent:GetDescendants()) do
                    if obj:IsA("GuiObject") and obj:GetAttribute("WasVisibleBeforeCollapse") then
                        obj.Visible = true;
                        obj:SetAttribute("WasVisibleBeforeCollapse", nil);
                    end;
                end;
            end;
        end);
        --
        Section.Elements = {
            SectionContent = SectionContent
        };

        Section.Page.Sections[#Section.Page.Sections + 1] = Section
        return setmetatable(Section, Interface.Sections)
    end;

    -- Label
    function Sections:Label(Prop)
        Prop = Prop or {};
        --
        local Label = {
            Window  = self.Window,
            Page    = self.Page,
            Section = self,
            Name    = (Prop.Name or Prop.name),
        };
        --
        Label.NewLabel = Framework:New("TextButton", {
            Name = Label.Name;
            Text = "";
            AutoButtonColor = false;
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, 12);
            Parent = Label.Section.Elements.SectionContent;
        });

        Label.Title = Framework:New("TextLabel", {
            Name = Label.Name;
            FontFace = Interface.Font;
            TextSize = Interface.FontSize;
            Text = Label.Name;
            TextStrokeTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(0, 0, 0, 20);
            AutomaticSize = Enum.AutomaticSize.X;
            Visible = true;
            Parent = Label.NewLabel
        }):Add({TextColor3 = "Inactive"})

        return Label;
    end;

    -- InfoLabel
    function Sections:InfoLabel(Prop)
        Prop = Prop or {};
        --
        local InfoLabel = {
            Window  = self.Window,
            Page    = self.Page,
            Section = self,
            Name1   = (Prop.Name1 or Prop.name1 or ""),
            Name2   = (Prop.Name2 or Prop.name2 or ""),
        };
        --
        InfoLabel.NewLabel = Framework:New("TextButton", {
            Name = InfoLabel.Name1..InfoLabel.Name2,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 12),
            Parent = InfoLabel.Section.Elements.SectionContent,
        });

        Framework:New("TextLabel", {
            Name = "LeftLabel",
            FontFace = Interface.Font,
            TextSize = Interface.FontSize,
            Text = InfoLabel.Name1,
            TextStrokeTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            Visible = true,
            Parent = InfoLabel.NewLabel
        }):Add({TextColor3 = "Inactive"});

        Framework:New("TextLabel", {
            Name = "RightLabel",
            FontFace = Interface.Font,
            TextSize = Interface.FontSize,
            Text = InfoLabel.Name2,
            TextStrokeTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            Visible = true,
            Parent = InfoLabel.NewLabel
        }):Add({TextColor3 = "Active"});

        return InfoLabel;
    end;

    -- Divider
    function Sections:Divider(Prop)
        Prop = Prop or {};
        --
        local Divider = {
            Window = self.Window;
            Page = self.Page;
            Section = self;
        };
        --
        Divider.NewDivider = Framework:New("Frame", {
            Name = "DividerContainer";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 1);
            Parent = Divider.Section.Elements.SectionContent;
        });

        local Inline = Framework:New("Frame", {
            Name = "Inline";
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 1);
            Parent = Divider.NewDivider;
        }):Add({BackgroundColor3 = "Outline"});

        return Divider;
    end;

    -- Toggle
    function Sections:Toggle(Prop)
        Prop = Prop or {};
        --
        local Toggle = {
            Window   = self.Window,
            Page     = self.Page,
            Section  = self,
            Risky    = ( Prop.Risky or Prop.risky or false ),
            Name     = ( Prop.Name or Prop.name or "Toggle" ),
            Default  = ( Prop.default or Prop.Default or false ),
            Callback = ( Prop.callback or Prop.Callback or Prop.callBack or Prop.CallBack or function() end ),
            Flag     = ( Prop.flag or Prop.Flag or Interface.NextFlag() ),
            Toggled  = false,
            Elements = {},
            NoButton = (Prop.NoButton or Prop.noButton or false),
            Colorpickers = 0
        };
        --
        local parentFrame;
        if Prop.ForceParent then
            parentFrame = Prop.ForceParent
        elseif self.Elements and self.Elements.SectionContent then
            parentFrame = self.Elements.SectionContent
        else
            parentFrame = self.Section.Elements.SectionContent
        end
        --
        Toggle.NewToggle = Framework:New("Frame", {
            ZIndex = -3,
            Name = Toggle.Name;
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, 20);
            Parent = parentFrame;
        });

        if (Toggle.Risky) then
            Toggle.RiskyImage = Framework:New("ImageLabel", {
                Name = "Risky";
                Image = "http://www.roblox.com/asset/?id=12487510294", --"http://www.roblox.com/asset/?id=15808071731", 
                Position = UDim2.new(0, 0, 0, 1);
                Size = UDim2.new(0, 21, 0, 20);
                ImageColor3 = Color3.fromRGB(200, 80, 90);
                BackgroundTransparency = 1;
                Parent = Toggle.NewToggle;
                Visible = Toggle.Risky;
            });

            Toggle.RiskyFrame = Framework:New("TextButton", {
                Name = "Risky Frame";
                Size = UDim2.new(1, 0, 1, 0);
                Text = "",
                AutoButtonColor = false,
                Parent = Toggle.Section.Page.Elements.Main;
                BackgroundTransparency = 1;
                Visible = false;
                ZIndex = 9999;
            }):Add({BackgroundColor3 = "Middle"});

            Toggle.RiskyTitle = Framework:New("TextLabel", {
                Name = "RiskyTitle";
                FontFace = Interface.Font;
                TextSize = Interface.FontSize;
                Text = "WARNING: " .. Toggle.Name .. " is a risky feature. Are you sure you want to enable it?";
                TextStrokeTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Center;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                TextTransparency = 1;
                AnchorPoint = Vector2.new(0.5, 1);
                Position = UDim2.new(0.5, 0, 0.5, -60);
                TextWrapped = true;
                Size = UDim2.new(0, 150, 0, 30);
                AutomaticSize = Enum.AutomaticSize.X;
                Visible = true;
                Parent = Toggle.RiskyFrame;
            }):Add({TextColor3 = "Active"});

            Toggle.ButtonHolder = Framework:New("Frame", {
                Name = "ButtonHolder";
                Size = UDim2.new(0, 300, 0, 40);
                AnchorPoint = Vector2.new(0.5, 0.5);
                Position = UDim2.new(0.5, 0, 0.5, -25);
                BackgroundTransparency = 1;
                Visible = true;
                Parent = Toggle.RiskyFrame;
            });

            Toggle.Layout = Framework:New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                Padding = UDim.new(0, 20);
                Parent = Toggle.ButtonHolder;
            });

            Toggle.LeftButton = Framework:New("TextButton", {
                Name = "LeftButton";
                Size = UDim2.new(0, 120, 1, 0);
                Text = "YES";
                AutoButtonColor = false;
                TextStrokeTransparency = 1;
                FontFace = Interface.Font;
                TextSize = Interface.FontSize;
                BackgroundTransparency = 1;
                TextTransparency = 1;
                Parent = Toggle.ButtonHolder;
            }):Add({BackgroundColor3 = "Window", TextColor3 = "Active"});

            Toggle.RightButtonStroke = Framework:New("UIStroke", {
                Enabled = true,
                Parent = Toggle.LeftButton,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 1
            }):Add({Color = "Outline"});

            Framework:New("UICorner", {
                Parent = Toggle.LeftButton;
                CornerRadius = UDim.new(0, 4);
            });

            Toggle.RightButton = Framework:New("TextButton", {
                Name = "RightButton";
                Size = UDim2.new(0, 120, 1, 0);
                Text = "NO";
                AutoButtonColor = false;
                TextStrokeTransparency = 1;
                FontFace = Interface.Font;
                TextSize = Interface.FontSize;
                BackgroundTransparency = 1;
                TextTransparency = 1;
                Parent = Toggle.ButtonHolder;
            }):Add({BackgroundColor3 = "Window", TextColor3 = "Active"});

            Toggle.LeftButtonStroke = Framework:New("UIStroke", {
                Enabled = true,
                Parent = Toggle.RightButton,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 1
            }):Add({Color = "Outline"});

            Framework:New("UICorner", {
                Parent = Toggle.RightButton;
                CornerRadius = UDim.new(0, 4);
            });

            Toggle.LeftButton.MouseEnter:Connect(function()
                Framework:TweenTheme(Toggle.LeftButton, { TextColor3 = "Accent" }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            end)

            Toggle.LeftButton.MouseLeave:Connect(function()
                Framework:TweenTheme(Toggle.LeftButton, { TextColor3 = "Active" }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            end)

            Toggle.RightButton.MouseEnter:Connect(function()
                Framework:TweenTheme(Toggle.RightButton, { TextColor3 = "Accent" }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            end)

            Toggle.RightButton.MouseLeave:Connect(function()
                Framework:TweenTheme(Toggle.RightButton, { TextColor3 = "Active" }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            end)
        end;

        Toggle.Frame = Framework:New("TextButton", {
            Text = "";
            AutoButtonColor = false;
            Name = "Toggle Frame";
            Position = Toggle.Risky and UDim2.new(0, 30, 0, 2) or UDim2.new(0, 0, 0, 2);
            Size = UDim2.new(0, 18, 0, 18);
            Parent = Toggle.NewToggle;
        }):Add({BackgroundColor3 = "Window"})

        Framework:New("UIStroke", {
            Enabled = true,
            Parent = Toggle.Frame,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1
        }):Add({Color = "Outline"});

        Framework:New("UICorner", {
            Parent = Toggle.Frame;
            CornerRadius = UDim.new(0, 4);
        });

        Toggle.Tick = Framework:New("ImageLabel", {
            Name = "Tick";
            Image = "http://www.roblox.com/asset/?id=6972510111",
            Position = UDim2.new(0, 3, 0, 3);
            Size = UDim2.new(1, -6, 1, -6);
            BackgroundTransparency = 1;
            Parent = Toggle.Frame;
            Visible = Toggle.Default;
        }):Add({ImageColor3 = "Middle"});

        Toggle.Title = Framework:New("TextLabel", {
            Name = Toggle.Name;
            FontFace = Interface.Font;
            TextSize = Interface.FontSize;
            Text = Toggle.Name;
            TextStrokeTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 28, 0, 0);
            Size = UDim2.new(0, 0, 0, 20);
            AutomaticSize = Enum.AutomaticSize.X;
            Visible = true;
            Parent = Toggle.Frame
        }):Add({TextColor3 = "Inactive"})

        local function SetState()
            if (Toggle.Risky and not Toggle.Toggled) then
                for _, v in pairs(Toggle.Section.Page.Elements.Main:GetChildren()) do
                    if v.Name == "Risky Frame" then
                        v.Visible = false;
                        v.BackgroundTransparency = 1;
                    end;
                end;

                Toggle.RiskyFrame.Visible = true;
                Toggle.RiskyFrame.BackgroundTransparency = 1;
                Toggle.RiskyTitle.TextTransparency = 1;
                Toggle.LeftButton.TextTransparency = 1;
                Toggle.RightButton.TextTransparency = 1;
                Toggle.LeftButton.BackgroundTransparency = 1;
                Toggle.RightButton.BackgroundTransparency = 1;

                Framework:Tween(Toggle.RiskyFrame, { BackgroundTransparency = 0.25 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.RiskyTitle, { TextTransparency = 0 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.LeftButton, { BackgroundTransparency = 0, TextTransparency = 0 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.LeftButtonStroke, { Transparency = 0 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                Framework:Tween(Toggle.RightButton, { BackgroundTransparency = 0, TextTransparency = 0 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.RightButtonStroke, { Transparency = 0 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

                return;
            end;

            Toggle.Toggled = not Toggle.Toggled;
            Toggle.Tick.Visible = Toggle.Toggled;
            Interface.Flags[Toggle.Flag] = Toggle.Toggled;
            Toggle.Callback(Toggle.Toggled);
            Framework:Tween(Toggle.Tick, { ImageTransparency = Toggle.Toggled and 0 or 1 }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            Framework:TweenTheme(Toggle.Frame, { BackgroundColor3 = Toggle.Toggled and "Accent" or "Window" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
            Framework:TweenTheme(Toggle.Title, { TextColor3 = Toggle.Toggled and "Active" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
        end;

        Framework:Connect(Toggle.Frame.MouseButton1Down, SetState);

        if (Toggle.Risky) then
            Toggle.LeftButton.MouseButton1Down:Connect(function()
                Framework:Tween(Toggle.LeftButtonStroke, { Transparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                Framework:Tween(Toggle.RightButtonStroke, { Transparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                Framework:Tween(Toggle.RiskyFrame, { BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.RiskyTitle, { TextTransparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.LeftButton, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.RightButton, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, function()
                    Toggle.RiskyFrame.Visible = false;
                    Toggle.Toggled = true;
                    Toggle.Tick.Visible = true;
                    Interface.Flags[Toggle.Flag] = true;
                    Toggle.Callback(true);
                    Framework:Tween(Toggle.Tick, { ImageTransparency = 0 }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    Framework:TweenTheme(Toggle.Frame, { BackgroundColor3 = "Accent" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                    Framework:TweenTheme(Toggle.Title, { TextColor3 = "Active" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                end);
            end);

            Toggle.RightButton.MouseButton1Down:Connect(function()
                Framework:Tween(Toggle.LeftButtonStroke, { Transparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                Framework:Tween(Toggle.RightButtonStroke, { Transparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                Framework:Tween(Toggle.RiskyFrame, { BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.RiskyTitle, { TextTransparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.LeftButton, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                Framework:Tween(Toggle.RightButton, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, function()
                    Toggle.RiskyFrame.Visible = false;
                end);
            end);
        end;

        function Toggle:Tooltip(Prop)
            Prop = Prop or {};
            --
            local Tooltip = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
                Name = (Prop.Name or Prop.name or "Tooltip"),
            };
            --
            Tooltip.NewTooltip = Framework:New("Frame", {
                Name = Tooltip.Name,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0),
                Parent = Interface.ScreenGui,
                Visible = false,
                ZIndex = 10,
            }):Add({BackgroundColor3 = "Outline"}); 

            Framework:New("UIStroke", {
                Enabled = true,
                Parent = Tooltip.NewTooltip,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 1
            }):Add({Color = "Outline"});

            Framework:New("UICorner", {
                Parent = Tooltip.NewTooltip,
                CornerRadius = UDim.new(0, 4)
            });

            Tooltip.Text = Framework:New("TextLabel", {
                Name = "TooltipText",
                Text = Tooltip.Name,
                FontFace = Interface.Font,
                TextSize = Interface.FontSize - 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Parent = Tooltip.NewTooltip,
                ZIndex = 999999,
                AutomaticSize = Enum.AutomaticSize.X
            }):Add({TextColor3 = "Active"});

            local padding = 6
            local function UpdateTooltipSize()
                local tb = Tooltip.Text.TextBounds
                Tooltip.NewTooltip.Size = UDim2.new(0, tb.X + padding * 2, 0, 30)
                Tooltip.Text.Position = UDim2.new(0, padding, 0, 0)
                Tooltip.Text.Size = UDim2.new(0, tb.X, 1, 0)
            end

            Framework:Connect(Toggle.Frame.MouseEnter, function()
                local absPos = Toggle.NewToggle.AbsolutePosition
                local absSize = Toggle.NewToggle.AbsoluteSize

                Tooltip.NewTooltip.Position = UDim2.new(0, absPos.X + 30, 0, absPos.Y + absSize.Y + 65)
                Tooltip.NewTooltip.Visible = true
                Tooltip.Text.TextTransparency = 1

                task.wait()
                UpdateTooltipSize()

                Framework:Tween(Tooltip.NewTooltip, { Size = Tooltip.NewTooltip.Size, BackgroundTransparency = 0 }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                Framework:Tween(Tooltip.Text, { TextTransparency = 0 }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end)

            Framework:Connect(Toggle.Frame.MouseLeave, function()
                Framework:Tween(Tooltip.Text, { TextTransparency = 1 }, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                Framework:Tween(Tooltip.NewTooltip, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                task.delay(0.2, function()
                    Tooltip.NewTooltip.Visible = false
                end)
            end)

            return Toggle;
        end;

        function Toggle:Keybind(Prop)
            Prop = Prop or {};
            --
            local Keybind = {
                Section = self,
                State = (Prop.default or Prop.Default or nil),
                Mode = (Prop.mode or Prop.Mode or "Toggle"),
                UseKey = (Prop.UseKey or false),
                Ignore = (Prop.ignore or Prop.Ignore or false),
                Callback = (Prop.callback or Prop.Callback or function() end),
                Flag = (Prop.flag or Prop.Flag or Interface.NextFlag()),
                Binding = nil,
            };
            --
            local State, Key = false;
            local ListValue;
            if not Keybind.Ignore then
                local safeKey = (Keybind.State == nil) and "None" or Keybind.State
                local safeName = (Toggle.Name == nil) and "None" or Toggle.Name

                ListValue = Interface.IndicatorGui:NewKey(safeKey, safeName);
            end;
            --
            local NewKeybind = Framework:New("TextButton", {
                Name = Toggle.Name,
                AnchorPoint = Vector2.new(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Text = "",
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0, -55, 0, 24),
                AutoButtonColor = false,
                Parent = Toggle.NewToggle
            });

            local KeybindBg = Framework:New("Frame", {
                Name = "Toggle Frame";
                BackgroundTransparency = 0,
                Size = UDim2.new(0, 55, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Parent = NewKeybind;
            }):Add({BackgroundColor3 = "Outline"});

            Framework:New("UICorner", {
                Parent = KeybindBg;
                CornerRadius = UDim.new(0, 4);
            });

            local Value = Framework:New("TextLabel", {
                Name = "Value",
                FontFace = Interface.Font,
                Text = "MB2",
                TextSize = Interface.FontSize,
                TextStrokeTransparency = 1,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindBg
            }):Add({TextColor3 = "Active"});

            local KeybindImage = Framework:New("ImageLabel", {
                Parent = Value;
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 16, 1, -8);
                BackgroundTransparency = 1;
                Image = "rbxassetid://16081386298";
                ImageTransparency = 0;
                ZIndex = 1;
            }):Add({ImageColor3 = "Accent"});

            local KeybindPadding = Framework:New("UIPadding", { Name = "UIPadding", Parent = Value });

            Framework:New("UIListLayout", {
                Name = "UIListLayout";
                Padding = UDim.new(0, 0);
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder;
                FillDirection = Enum.FillDirection.Vertical;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                Parent = Value;
            });

            local ModeBox = Framework:New("Frame", {
                Name = "ModeBox",
                AnchorPoint = Vector2.new(0, 0.5),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 65, 0, 60),
                Visible = false,
                BackgroundTransparency = 1,
                ZIndex = 10,
                Parent = Interface.ScreenGui
            }):Add({ BackgroundColor3 = "Outline" })

            Framework:New("UICorner", {
                Parent = ModeBox,
                CornerRadius = UDim.new(0, 4)
            })

            local Hold = Framework:New("TextButton", {
                Name = "Hold",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0.333, 0),
                ZIndex = 2,
                FontFace = Interface.Font,
                Text = "Hold",
                TextSize = Interface.FontSize,
                TextStrokeTransparency = 1,
                Parent = ModeBox
            })

            local ToggleMode = Framework:New("TextButton", {
                Name = "Toggle",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.333, 0),
                Size = UDim2.new(1, 0, 0.333, 0),
                ZIndex = 2,
                FontFace = Interface.Font,
                Text = "Toggle",
                TextSize = Interface.FontSize,
                TextStrokeTransparency = 1,
                Parent = ModeBox
            })

            local Always = Framework:New("TextButton", {
                Name = "Always",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.667, 0),
                Size = UDim2.new(1, 0, 0.333, 0),
                ZIndex = 2,
                FontFace = Interface.Font,
                Text = "Always",
                TextSize = Interface.FontSize,
                TextStrokeTransparency = 1,
                Parent = ModeBox
            })

            Framework:TweenTheme(Hold, { TextColor3 = Keybind.Mode == "Hold" and "Accent" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Framework:TweenTheme(ToggleMode, { TextColor3 = Keybind.Mode == "Toggle" and "Accent" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Framework:TweenTheme(Always, { TextColor3 = Keybind.Mode == "Always" and "Accent" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

            local function set(newkey)
                if newkey == nil then
                    Key = nil
                    Value.Text = "..."
                    KeybindImage.Image = Assets.Images:Require("Keyboard")
                    KeybindImage.Visible = true
                    KeybindPadding.PaddingLeft = UDim.new(0, 6)
                    KeybindPadding.PaddingRight = UDim.new(0, -21)
                    if Keybind.Flag then
                        Interface.Flags[Keybind.Flag] = Key
                        Keybind.Callback(Key)
                    end
                    Interface.Flags[Keybind.Flag .. "_KEY"] = nil
                    if ListValue then ListValue:Update("None", Toggle.Name) end
                    if ListValue then ListValue:SetVisible(false) end
                    return
                end

                if string.find(tostring(newkey), "Enum") then
                    if Keybind.Connection then
                        Keybind.Connection:Disconnect()
                        if Keybind.Flag then Interface.Flags[Keybind.Flag] = false end
                        Keybind.Callback(false)
                    end

                    if tostring(newkey):find("Enum.KeyCode.") then
                        newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                        KeybindImage.Image = Assets.Images:Require("Keyboard")
                        KeybindImage.Visible = true
                        KeybindPadding.PaddingLeft = UDim.new(0, 6)
                        KeybindPadding.PaddingRight = UDim.new(0, -21)
                    elseif tostring(newkey):find("Enum.UserInputType.") then
                        newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                        KeybindImage.Image = "rbxassetid://16081386298"
                        KeybindImage.Visible = true
                        KeybindPadding.PaddingLeft = UDim.new(0, 10)
                        KeybindPadding.PaddingRight = UDim.new(0, -12)
                    end

                    if newkey == Enum.KeyCode.Backspace then
                        Key = nil
                        Value.Text = "..."
                        KeybindImage.Image = Assets.Images:Require("Keyboard")
                        KeybindImage.Visible = true
                        KeybindPadding.PaddingLeft = UDim.new(0, 6)
                        KeybindPadding.PaddingRight = UDim.new(0, -21)
                        if Keybind.Flag then
                            Interface.Flags[Keybind.Flag] = Key
                            Keybind.Callback(Key)
                        end
                        if ListValue then ListValue:Update("None", Toggle.Name) end
                        if ListValue then ListValue:SetVisible(false) end
                    else
                        Key = newkey
                        local keyName = tostring(newkey):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
                        Value.Text = Interface.KeyNames[keyName] or keyName
                        if Keybind.Flag then
                            Interface.Flags[Keybind.Flag] = Key
                            Keybind.Callback(Key)
                        end
                        if ListValue then ListValue:Update(keyName, Toggle.Name) end
                        if ListValue then ListValue:SetVisible(true) end
                    end

                    Interface.Flags[Keybind.Flag .. "_KEY"] = newkey

                elseif table.find({"Always", "Toggle", "Hold"}, newkey) then
                    Interface.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
                    Keybind.Mode = newkey
                    if Keybind.Mode == "Always" then
                        State = true
                        if Keybind.Flag then Interface.Flags[Keybind.Flag] = State end
                        Keybind.Callback(true)
                        if ListValue then ListValue:SetVisible(true) end
                    end
                else
                    State = newkey
                    if Keybind.Flag then Interface.Flags[Keybind.Flag] = newkey end
                    Keybind.Callback(newkey)
                    if ListValue then ListValue:SetVisible(newkey) end
                end
            end

            set(Keybind.State)
            set(Keybind.Mode)

            NewKeybind.MouseButton1Click:Connect(function()
                if Keybind.Binding then return end
                Value.Text = "..."

                Keybind.Binding = Framework:Connect(Services.UserInputService.InputBegan, function(input, gpe)
                    gpe = false

                    local newKey
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        newKey = input.KeyCode
                    else
                        newKey = input.UserInputType
                    end

                    set(newKey)

                    if Keybind.Binding then
                        Keybind.Binding:Disconnect()
                        Keybind.Binding = nil
                    end
                end)
            end)

            Framework:Connect(Services.UserInputService.InputBegan, function(inp, gpe)
                if gpe then return end
                if inp.UserInputType ~= Enum.UserInputType.Keyboard and inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.MouseButton2 and inp.UserInputType ~= Enum.UserInputType.MouseButton3 then return end
                if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
                    if Keybind.Mode == "Hold" then
                        if Keybind.Flag then Interface.Flags[Keybind.Flag] = true end
                        Keybind.Connection = Framework:Connect(Services.RunService.RenderStepped, function()
                            if Keybind.Callback then Keybind.Callback(true) end
                        end)
                        if ListValue then ListValue:SetVisible(true) end
                    elseif Keybind.Mode == "Toggle" then
                        State = not State
                        if Keybind.Flag then Interface.Flags[Keybind.Flag] = State end
                        Keybind.Callback(State)
                        if ListValue then ListValue:SetVisible(State) end
                    end
                end
            end)

            Framework:Connect(Services.UserInputService.InputEnded, function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard and inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.MouseButton2 and inp.UserInputType ~= Enum.UserInputType.MouseButton3 then return end
                if Keybind.Mode == "Hold" and not Keybind.UseKey and (inp.KeyCode == Key or inp.UserInputType == Key) then
                    if Keybind.Connection then
                        Keybind.Connection:Disconnect()
                        if Keybind.Flag then Interface.Flags[Keybind.Flag] = false end
                        if Keybind.Callback then Keybind.Callback(false) end
                        Keybind.Connection = nil
                        if ListValue then ListValue:SetVisible(false) end
                    end
                end
            end)

            Framework:Connect(NewKeybind.MouseButton2Down, function()
                if ModeBox.Visible then return end

                local absPos, absSize = KeybindBg.AbsolutePosition, KeybindBg.AbsoluteSize
                ModeBox.Position = UDim2.new(0, absPos.X + 55, 0, absPos.Y + absSize.Y/2 - 30 + 110)
                ModeBox.BackgroundTransparency = 1
                ModeBox.Visible = true

                Framework:Tween(ModeBox, {BackgroundTransparency = 0}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                for _, btn in ipairs({Hold, ToggleMode, Always}) do
                    Framework:Tween(btn, {TextTransparency = 0}, 0.25)
                    if btn:FindFirstChildOfClass("UIStroke") then
                        Framework:Tween(btn.UIStroke, {Transparency = 0}, 0.2)
                    end
                end

                if ModeBox:FindFirstChildOfClass("UIStroke") then
                    Framework:Tween(ModeBox.UIStroke, {Transparency = 0}, 0.2)
                end

                ToggleMode.ZIndex = 5
            end)

            local function CloseModeBox()
                Framework:Tween(ModeBox, {BackgroundTransparency = 1, Position = ModeBox.Position + UDim2.new(0,0,0,13)}, 0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
                    ModeBox.Visible = false
                    ToggleMode.ZIndex = 1
                end)
                for _, btn in ipairs({Hold, ToggleMode, Always}) do
                    Framework:Tween(btn, {TextTransparency = 1}, 0.13)
                    if btn:FindFirstChildOfClass("UIStroke") then
                        Framework:Tween(btn.UIStroke, {Transparency = 1}, 0.13)
                    end
                end
                if ModeBox:FindFirstChildOfClass("UIStroke") then
                    Framework:Tween(ModeBox.UIStroke, {Transparency = 1}, 0.13)
                end
            end

            local function ThemeAndClose(first, second, third, value)
                local completed = 0
                local function checkClose()
                    completed = completed + 1
                    if completed == 3 then
                        CloseModeBox()
                    end
                end
                Framework:TweenTheme(first, {TextColor3 = value == 1 and "Accent" or "Inactive"}, 0.2, nil, nil, checkClose)
                Framework:TweenTheme(second, {TextColor3 = value == 2 and "Accent" or "Inactive"}, 0.2, nil, nil, checkClose)
                Framework:TweenTheme(third, {TextColor3 = value == 3 and "Accent" or "Inactive"}, 0.2, nil, nil, checkClose)
            end

            Framework:Connect(Hold.MouseButton1Down, function()
                set("Hold")
                ThemeAndClose(Hold, ToggleMode, Always, 1)
            end)

            Framework:Connect(ToggleMode.MouseButton1Down, function()
                set("Toggle")
                ThemeAndClose(Hold, ToggleMode, Always, 2)
            end)

            Framework:Connect(Always.MouseButton1Down, function()
                set("Always")
                ThemeAndClose(Hold, ToggleMode, Always, 3)
            end)

            Framework:Connect(Services.UserInputService.InputBegan, function(Input)
                if ModeBox.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local AbsPos, AbsSize = ModeBox.AbsolutePosition, ModeBox.AbsoluteSize
                    local mouseX, mouseY = Mouse.X, Mouse.Y
                    if not (mouseX >= AbsPos.X and mouseX <= AbsPos.X + AbsSize.X and mouseY >= AbsPos.Y and mouseY <= AbsPos.Y + AbsSize.Y) then
                        CloseModeBox()
                    end
                end
            end)

            Interface.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
            Interface.Flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
            Flags[Keybind.Flag] = set
            Flags[Keybind.Flag .. "_KEY"] = set
            Flags[Keybind.Flag .. "_KEY STATE"] = set
            --
            function Keybind:Set(value)
                set(value)
            end

            self.KeybindObject = Keybind;
            return Keybind;
        end;

        function Toggle:Colorpicker(Prop)
            Prop = Prop or {};
            --
            local Colorpicker = {
                State = (Prop.default or Prop.Default or Framework.Theme.Colors.Accent),
                Alpha = (Prop.transparency or Prop.Transparency or 1),
                Callback = (Prop.callback or Prop.Callback or function() end),
                Flag = (Prop.flag or Prop.Flag or Interface.NextFlag()),
            };
            --
            Toggle.Colorpickers = Toggle.Colorpickers + 1
            local parent = Toggle.NewToggle
            local count = Toggle.Colorpickers
            local default = Colorpicker.State
            local defaultalpha = Colorpicker.Alpha
            local flag = Colorpicker.Flag
            local callback = Colorpicker.Callback

            local iconSize = 14
            local spacing = 6
            local offset = (count - 1) * (iconSize + spacing)

            local Icon = Framework:New("TextButton", {
                Name = "Icon",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -(iconSize + offset), 0.5, 0),
                Size = UDim2.new(0, iconSize, 0, iconSize),
                Text = "",
                AutoButtonColor = false,
                Parent = parent
            });

            Framework:New('UICorner', {Parent = Icon, CornerRadius = UDim.new(1, 0)})

            local ColorInline = Framework:New("TextButton", {
                AutoButtonColor = false,
                Text = "",
                Visible = false,
                Name = "ColorInline",
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(0, 15, 1, 20),
                Size = UDim2.new(0, 190, 0, 220),
                Parent = Icon
            }):Add({BackgroundColor3 = "Outline"})
            Framework:New('UICorner', {Parent = ColorInline, CornerRadius = UDim.new(0, 5)})

            local ColorFrame = Framework:New("Frame", {
                Name = "ColorFrame",
                BorderSizePixel = 0,
                Position = UDim2.new(1, -24, 1, -49),
                Size = UDim2.new(0, 14, 0, 14),
                Parent = ColorInline
            })
            Framework:New('UICorner', {Parent = ColorFrame, CornerRadius = UDim.new(1, 0)})

            local Color = Framework:New("TextButton", {
                Name = "Color",
                FontFace = Interface.Font,
                Text = "",
                TextColor3 = Color3.fromRGB(0, 0, 0),
                TextSize = Interface.FontSize,
                AutoButtonColor = false,
                BackgroundColor3 = default,
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                Position = UDim2.new(0, 8, 0, 8),
                Size = UDim2.new(1, -40, 1, -70),
                Parent = ColorInline
            });

            local CircleC = Framework:New("Frame", {
                Name = "CircleC",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0, 0),
                Position = UDim2.fromOffset(Mouse.X, Mouse.Y),
                Size = UDim2.fromOffset(6, 6),
                ZIndex = 9,
                Parent = Color
            });
            Framework:New('UICorner', {Parent = CircleC, CornerRadius = UDim.new(1, 0)});
            Framework:New("UIStroke", { 
                Enabled = true, 
                Parent = CircleC, 
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                LineJoinMode = Enum.LineJoinMode.Round, 
                Thickness = 2 
            }):Add({Color = "Active"});

            local Hue = Framework:New("ImageButton", {
                Name = "Hue",
                Image = "http://www.roblox.com/asset/?id=14684557999",
                AutoButtonColor = false,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                Position = UDim2.new(1, -24, 0, 8),
                Size = UDim2.new(0, 16, 1, -70),
                Parent = ColorInline
            });
            
            local HueLine = Framework:New("Frame", {
                Name = "HueLine",
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0, 0),
                Position = UDim2.new(0, 0, 0, 10),
                Size = UDim2.new(1, 0, 0, 3),
                ZIndex = 9,
                Parent = Hue
            }):Add({BackgroundColor3 = "Active"});

            local Alpha = Framework:New("TextBox", {
                Name = "Alpha",
                PlaceholderText = "0–100",
                Text = tostring(math.floor(defaultalpha * 100)) .. "%",
                ClearTextOnFocus = false,
                FontFace = Interface.Font,
                TextSize = Interface.FontSize,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 88, 1, -52),
                Size = UDim2.new(1, -120, 0, 20),
                Parent = ColorInline
            }):Add({TextColor3 = "Active", BackgroundColor3 = "Outline"})
            Framework:New('UICorner', {Parent = Alpha, CornerRadius = UDim.new(0, 4)})

            Framework:New("UIStroke", {
                Enabled = true,
                Parent = Alpha,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 1
            }):Add({Color = "Outline2"})

            local HexColor = Framework:New("TextBox", {
                Name = "HexColor",
                PlaceholderText = "",
                Text = "",
                ClearTextOnFocus = false,
                FontFace = Interface.Font,
                TextSize = Interface.FontSize,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 8, 1, -52),
                Size = UDim2.new(1, -120, 0, 20),
                Parent = ColorInline
            }):Add({TextColor3 = "Active", BackgroundColor3 = "Outline"})
            Framework:New('UICorner', {Parent = HexColor, CornerRadius = UDim.new(0, 4)})

            Framework:New("UIStroke", {
                Enabled = true,
                Parent = HexColor,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 1
            }):Add({Color = "Outline2"})

            local Sat = Framework:New("ImageLabel", {
                Name = "Sat",
                Image = "http://www.roblox.com/asset/?id=14684562507",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = Color
            })

            local Val = Framework:New("ImageLabel", {
                Name = "Val",
                Image = "http://www.roblox.com/asset/?id=14684563800",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = Color
            })

            local ColorHolder = Framework:New("Frame", {
                Name = "ColorHolder",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 1, -22),
                Size = UDim2.new(1, -18, 0, 15),
                Parent = ColorInline
            })
            table.insert(AllColorHolders, ColorHolder)

            Framework:New("UIPadding", { Name = "UIPadding", PaddingLeft = UDim.new(0, 1), Parent = ColorHolder })
            Framework:New("UIListLayout", {
                Name = "UIListLayout",
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = ColorHolder
            })

            local CustomColorButton = Framework:New("TextButton", {
                Name = "CustomColorButton",
                FontFace = Interface.Font,
                Text = "+",
                TextSize = 14,
                AutoButtonColor = false,
                TextStrokeTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 15, 1, 0),
                Parent = ColorHolder
            }):Add({BackgroundColor3 = "Outline2", TextColor3 = "Active"})
            Framework:New('UICorner', {Parent = CustomColorButton, CornerRadius = UDim.new(0, 4)})

            local hue, sat, val = default:ToHSV()
            local hsv = default:ToHSV()
            local alpha = defaultalpha
            local slidingsaturation, slidinghue = false, false

            local function Color3ToHex(c)
                return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
            end

            local function HexToColor3(hex)
                hex = hex:gsub("#","")
                if #hex == 6 then
                    return Color3.new(tonumber(hex:sub(1,2),16)/255, tonumber(hex:sub(3,4),16)/255, tonumber(hex:sub(5,6),16)/255)
                end
            end

            local function update()
                local real_pos = Services.UserInputService:GetMouseLocation()
                local mouse_position = Vector2.new(real_pos.X + 2, real_pos.Y - 54)
                local rel_palette = (mouse_position - Color.AbsolutePosition)
                local rel_hue = (mouse_position - Hue.AbsolutePosition)

                if slidingsaturation then
                    sat = math.clamp(1 - rel_palette.X / Color.AbsoluteSize.X, 0, 1)
                    val = math.clamp(1 - rel_palette.Y / Color.AbsoluteSize.Y, 0, 1)
                elseif slidinghue then
                    hue = math.clamp(rel_hue.Y / Hue.AbsoluteSize.Y, 0, 1)

                    local hueY = hue * Hue.AbsoluteSize.Y
                    Framework:Tween(HueLine, {Position = UDim2.new(0, 0, 0, hueY - HueLine.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                end

                hsv = Color3.fromHSV(hue, sat, val)
                Color.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                ColorFrame.BackgroundColor3 = hsv
                Icon.BackgroundColor3 = hsv
                HexColor.Text = Color3ToHex(hsv)

                local circleX = (1 - sat) * Color.AbsoluteSize.X
                local circleY = (1 - val) * Color.AbsoluteSize.Y
                Framework:Tween(CircleC, {Position = UDim2.new(0, circleX - CircleC.AbsoluteSize.X/2, 0, circleY - CircleC.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                local state = {Color = hsv, Transparency = alpha}
                if flag then
                    Interface.Flags[flag] = Interface:RGBA(hsv.R * 255, hsv.G * 255, hsv.B * 255, alpha)
                end
                callback(state)
            end;

            local circleX = (1 - sat) * Color.AbsoluteSize.X
            local circleY = (1 - val) * Color.AbsoluteSize.Y
            Framework:Tween(CircleC, {Position = UDim2.new(0, circleX - CircleC.AbsoluteSize.X/2, 0, circleY - CircleC.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            HexColor.Text = Color3ToHex(Color3.fromHSV(hue, sat, val))

            HexColor.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    local c = HexToColor3(HexColor.Text)
                    if c then
                        hue, sat, val = c:ToHSV()
                        hsv = c
                        Icon.BackgroundColor3 = hsv
                        Color.BackgroundColor3 = Color3.fromHSV(hue,1,1)
                        ColorFrame.BackgroundColor3 = hsv
                        HexColor.Text = Color3ToHex(hsv)
                        local state = {Color = hsv, Transparency = alpha}
                        if flag then
                            Interface.Flags[flag] = Interface:RGBA(hsv.R*255,hsv.G*255,hsv.B*255, alpha)
                        end
                        callback(state)
                    else
                        HexColor.Text = Color3ToHex(hsv)
                    end
                end
            end)

            Alpha.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    local text = Alpha.Text:gsub("%%", "") 
                    local num = tonumber(text)
                    if num then
                        num = math.clamp(num, 0, 100)
                        alpha = num / 100
                        Alpha.Text = tostring(num) .. "%"
                        update()
                    else
                        Alpha.Text = tostring(math.floor(alpha * 100)) .. "%" 
                    end
                end
            end)

            local function set(color, a, ignoreAlpha)
                local input = color
                if type(input) == "table" then
                    if #input == 4 then
                        color = Color3.fromRGB(input[1], input[2], input[3])
                        if not ignoreAlpha then
                            alpha = input[4] or a
                            Alpha.Text = tostring(math.floor(alpha * 100)) .. "%"
                        end
                    elseif #input == 3 then
                        color = Color3.fromRGB(input[1], input[2], input[3])
                    else
                        a = input[4]
                        color = Color3.fromHSV(input[1], input[2], input[3])
                    end
                elseif type(color) == "string" then
                    color = Color3.fromHex(color)
                end

                hue, sat, val = color:ToHSV()
                hsv = Color3.fromHSV(hue, sat, val)

                Color.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                ColorFrame.BackgroundColor3 = hsv
                Icon.BackgroundColor3 = hsv
                HexColor.Text = Color3ToHex(hsv)

                if not ignoreAlpha and a ~= nil then
                    alpha = tonumber(a)
                    Alpha.Text = ("%d%%"):format(alpha * 100)
                end

                local circleX = (1 - sat) * Color.AbsoluteSize.X
                local circleY = (1 - val) * Color.AbsoluteSize.Y
                Framework:Tween(CircleC, {Position = UDim2.new(0, circleX - CircleC.AbsoluteSize.X/2, 0, circleY - CircleC.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                local hueY = hue * Hue.AbsoluteSize.Y
                Framework:Tween(HueLine, {Position = UDim2.new(0, 0, 0, hueY - HueLine.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                if flag then
                    Interface.Flags[flag] = Interface:RGBA(hsv.R*255,hsv.G*255,hsv.B*255, alpha)
                end

                callback({Color=hsv, Transparency=alpha});
            end;

            Flags[flag] = set
            set(default, defaultalpha)
            ColorHolderSetters[ColorHolder] = set

            CustomColorButton.MouseButton1Click:Connect(function()
                if #GlobalSavedColors < 6 then
                    table.insert(GlobalSavedColors, {hue, sat, val})
                    for _, holder in pairs(AllColorHolders) do
                        local colorToSave = {hue, sat, val} 
                        local btn = Framework:New("TextButton", {
                            Name = "SavedColor",
                            BackgroundColor3 = Color3.fromHSV(unpack(colorToSave)),
                            BorderSizePixel = 0,
                            Size = UDim2.new(0, 15, 1, 0),
                            Text = "",
                            AutoButtonColor = false,
                            Parent = holder
                        })
                        Framework:New('UICorner', {Parent = btn, CornerRadius = UDim.new(0, 4)})
                        btn.MouseButton1Click:Connect(function()
                            ColorHolderSetters[holder](Color3.fromHSV(unpack(colorToSave)), nil, true)

                            local h, s, v = unpack(colorToSave)
                            local circleX = (1 - s) * Color.AbsoluteSize.X
                            local circleY = (1 - v) * Color.AbsoluteSize.Y
                            Framework:Tween(CircleC, {Position = UDim2.new(0, circleX - CircleC.AbsoluteSize.X/2, 0, circleY - CircleC.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                            local hueY = h * Hue.AbsoluteSize.Y
                            Framework:Tween(HueLine, {Position = UDim2.new(0, 0, 0, hueY - HueLine.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        end)
                    end
                end
            end)

            for _, savedColor in pairs(GlobalSavedColors) do
                local btn = Framework:New("TextButton", {
                    Name = "SavedColor",
                    BackgroundColor3 = Color3.fromHSV(unpack(savedColor)),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 15, 1, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ColorHolder
                })
                Framework:New('UICorner', {Parent = btn, CornerRadius = UDim.new(0, 4)})
                btn.MouseButton1Click:Connect(function()
                    ColorHolderSetters[ColorHolder](Color3.fromHSV(unpack(savedColor))) 

                    local h, s, v = unpack(savedColor)
                    local circleX = (1 - s) * Color.AbsoluteSize.X
                    local circleY = (1 - v) * Color.AbsoluteSize.Y
                    Framework:Tween(CircleC, {Position = UDim2.new(0, circleX - CircleC.AbsoluteSize.X/2, 0, circleY - CircleC.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                    local hueY = h * Hue.AbsoluteSize.Y
                    Framework:Tween(HueLine, {Position = UDim2.new(0, 0, 0, hueY - HueLine.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                end)
            end

            do -- Default Color
                local defaultColor = Colorpicker.State
                local dh, ds, dv = defaultColor:ToHSV()

                local defaultButton = Framework:New("TextButton", {
                    Name = "SavedColor_Default",
                    BackgroundColor3 = defaultColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 15, 1, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ColorHolder
                })
                Framework:New('UICorner', {Parent = defaultButton, CornerRadius = UDim.new(0, 4)})

                defaultButton.MouseButton1Click:Connect(function()
                    ColorHolderSetters[ColorHolder](Color3.fromHSV(dh, ds, dv))

                    local circleX = (1 - ds) * Color.AbsoluteSize.X
                    local circleY = (1 - dv) * Color.AbsoluteSize.Y
                    Framework:Tween(CircleC, {Position = UDim2.new(0, circleX - CircleC.AbsoluteSize.X/2, 0, circleY - CircleC.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                    local hueY = dh * Hue.AbsoluteSize.Y
                    Framework:Tween(HueLine, {Position = UDim2.new(0, 0, 0, hueY - HueLine.AbsoluteSize.Y/2)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                end)
            end

            for _, obj in pairs({Sat, Hue, Alpha}) do
                obj.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if obj == Sat then slidingsaturation = true end
                        if obj == Hue then slidinghue = true end
                        update()
                    end
                end)
                obj.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if obj == Sat then slidingsaturation = false end
                        if obj == Hue then slidinghue = false end
                        update()
                    end
                end)
            end

            Framework:Connect(Services.UserInputService.InputChanged, function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if slidinghue or slidingsaturation then
                        update()
                    end
                end
            end)

            Framework:Connect(Services.UserInputService.InputBegan, function(Input)
                if ColorInline.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouseX, mouseY = Mouse.X, Mouse.Y
                    local function IsOver(Frame)
                        local absPos, absSize = Frame.AbsolutePosition, Frame.AbsoluteSize
                        return mouseX >= absPos.X and mouseX <= absPos.X + absSize.X and mouseY >= absPos.Y and mouseY <= absPos.Y + absSize.Y
                    end

                    if not (IsOver(ColorInline) or IsOver(Icon) or IsOver(parent)) then
                        Framework:Tween(ColorInline, {Position = UDim2.new(0, 15, 1, 20)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, function()
                            ColorInline.Visible = false
                            parent.ZIndex = 1
                        end)
                    end
                end
            end)

            Icon.MouseButton1Down:Connect(function()
                if ColorInline.Visible then
                    Framework:Tween(ColorInline, {Position = UDim2.new(0, 15, 1, 20)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, function()
                        ColorInline.Visible = false
                        parent.ZIndex = 1
                    end)
                else
                    ColorInline.Visible = true
                    ColorInline.Position = UDim2.new(0, 15, 1, 20)
                    parent.ZIndex = 5
                    slidinghue, slidingsaturation = false, false

                    Framework:Tween(ColorInline, {Position = UDim2.new(0, 15, 1, 5)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                end
            end)

            function Colorpicker:Set(color)
                set(color)
            end

            self.ColorpickerObject = Colorpicker;
            return Colorpicker;
        end;

        function Toggle:Option(Prop)
            Prop = Prop or {};
            --
            local Option = {
                Toggle = self,
                Section = self.Section,
                Elements = {},
                Open = false,
                Tweening = false
            };
            --
            Option.NewOption = Framework:New("TextButton", {
                ZIndex = -1,
                Name = "OptionContainer",
                AnchorPoint = Vector2.new(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Text = "",
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                AutoButtonColor = false,
                Parent = Toggle.NewToggle
            });

            local offset = 14;
            if self.KeybindObject then offset = 78 end;
            if self.ColorpickerObject then offset = 38 end;
            Option.NewOption.Position = UDim2.new(1, -offset, 0.5, 0);

            Option.OptionBg = Framework:New("ImageLabel", {
                Image = "http://www.roblox.com/asset/?id=11385161073",
                Name = "OptionFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = Option.NewOption
            }):Add({ ImageColor3 = "Inactive" });

            local OptionHolder = Framework:New("Frame", {
                Name = "OptionHolder",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 200, 0, 0),
                Visible = false,
                ZIndex = 1,
                Parent = Option.OptionBg
            }):Add({ BackgroundColor3 = "Window" })

            local OptionContent = Framework:New("Frame", {
                Name = "OptionContent",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 8, 0, 10),
                Size = UDim2.new(1, -16, 0, 0),
                ZIndex = 1,
                Visible = false,
                Parent = OptionHolder
            });

            Framework:New("UICorner", { Parent = OptionHolder, CornerRadius = UDim.new(0, 5) });

            Framework:New("UIListLayout", {
                Name = "UIListLayout",
                Padding = UDim.new(0, 12),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = OptionContent
            });

            Framework:New("UIPadding", {
                Name = "UIPadding",
                PaddingBottom = UDim.new(0, 10),
                Parent = OptionContent
            });

            Option.Elements.SectionContent = OptionContent

            local function Open()
                Option.Open = true
                Option.NewOption.ZIndex = 2
                Toggle.NewToggle.ZIndex = -2

                Framework:TweenTheme(Option.OptionBg, { ImageColor3 = "Accent" }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                OptionHolder.Visible = true
                OptionContent.Visible = true

                OptionHolder.Position = UDim2.new(0, -185, 0, 5),
                Framework:Tween(OptionHolder, {Position = UDim2.new(0, -185, 0, 20)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end

            local function Close()
                Option.Open = false
                Option.NewOption.ZIndex = 1
                Toggle.NewToggle.ZIndex = -3

                Framework:TweenTheme(Option.OptionBg, { ImageColor3 = "Inactive" }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                OptionHolder.Visible = false;
                OptionContent.Visible = false;
                OptionHolder.Position = UDim2.new(0, -185, 0, 5)
            end;

            Option.NewOption.MouseButton1Click:Connect(function()
                if Option.Open then
                    Close()
                else
                    Open()
                end
            end)

            function Option:Toggle(tProp)
                tProp = tProp or {}
                tProp.ForceParent = self.Elements.SectionContent
                return Sections.Toggle(self, tProp)
            end;

            function Option:Slider(sProp)
                sProp = sProp or {}
                sProp.ForceParent = self.Elements.SectionContent
                return Sections.Slider(self, sProp)
            end;

            function Option:Dropdown(dProp)
                dProp = dProp or {}
                dProp.ForceParent = self.Elements.SectionContent
                return Sections.Dropdown(self, dProp)
            end;

            setmetatable(Option, { __index = self });
            return Option;
        end;

        Toggle.Set = function(bool)
            bool = type(bool) == "boolean" and bool or false;
            if Toggle.Toggled ~= bool then SetState(); end;
        end;
        --
        Toggle.Set(Toggle.Default);
        Interface.Flags[Toggle.Flag] = Toggle.Default;
        Flags[Toggle.Flag] = Toggle.Set;
        return Toggle;
    end;

    -- Slider
    function Sections:Slider(Prop)
        Prop = Prop or {};
        --
        local Slider = {
            Window       = self.Window,
            Page         = self.Page,
            Section      = self,
            Name         = (Prop.name or Prop.Name or nil),
            Min          = (Prop.min or Prop.Min or Prop.minimum or Prop.Minimum or 0),
            State        = (Prop.state or Prop.State or Prop.def or Prop.Def or Prop.default or Prop.Default or 10),
            Max          = (Prop.max or Prop.Max or Prop.maximum or Prop.Maximum or 100),
            Sub          = (Prop.suffix or Prop.Suffix or Prop.ending or Prop.Ending or Prop.prefix or Prop.Prefix or Prop.measurement or Prop.Measurement or ""),
            Decimals     = (Prop.decimals or Prop.Decimals or 1),
            ShowDecimals = (Prop.ShowDecimals or Prop.showdecimals),
            Callback     = (Prop.callback or Prop.Callback or Prop.callBack or Prop.CallBack or function() end),
            Flag         = (Prop.flag or Prop.Flag or Prop.pointer or Prop.Pointer or Interface.NextFlag()),
            Disabled     = (Prop.Disabled or Prop.disable or nil),
        };
        --
        local slider_name = ("[value]" .. Slider.Sub)
        --
        local parentFrame
        if Prop.ForceParent then
            parentFrame = Prop.ForceParent
        elseif Slider.Elements and Slider.Elements.SectionContent then
            parentFrame = Slider.Elements.SectionContent
        else
            parentFrame = Slider.Section.Elements.SectionContent
        end
        --
        local NewSlider = Framework:New("Frame", {
            ZIndex = -1,
            Name = Slider.Name,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 30),
            Parent = parentFrame,
        });

        local Inline = Framework:New("TextButton", {
            Name = "SliderInline",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -8),
            Size = UDim2.new(1, 0, 0, 8),
            FontFace = Interface.Font,
            Text = "",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = Interface.FontSize,
            AutoButtonColor = false,
            Parent = NewSlider,
        }):Add({BackgroundColor3 = "Window"});

        Framework:New("UIStroke", {
            Enabled = true,
            Parent = Inline,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1
        }):Add({Color = "Outline"});

        Framework:New("UICorner", {
            Parent = Inline;
            CornerRadius = UDim.new(1, 0);
        });

        local Accent = Framework:New("TextButton", {
            Name = "Slider_Accent",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            FontFace = Interface.Font,
            Text = "",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = Interface.FontSize,
            AutoButtonColor = false,
            Parent = Inline,
        }):Add({BackgroundColor3 = "Accent"});

        Framework:New("UICorner", {
            Parent = Accent;
            CornerRadius = UDim.new(1, 0);
        });

        local SliderCircle = Framework:New("Frame", {
            Name = "Slider_Circle",
            Size = UDim2.new(0, 8, 0, 8),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = Inline,
        }):Add({BackgroundColor3 = "Active"});

        Framework:New("UICorner", {
            Parent = SliderCircle,
            CornerRadius = UDim.new(1, 0),
        });

        local Value = Framework:New("TextLabel", {
            Name = "Value",
            FontFace = Interface.Font,
            Text = "0",
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 1,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, 4),
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = NewSlider,
        }):Add({TextColor3 = "Active"});

        Framework:New("TextLabel", {
            Name = "Title",
            FontFace = Interface.Font,
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, 4),
            Text = Slider.Name or "",
            Visible = Slider.Name ~= nil,
            Parent = NewSlider,
        }):Add({TextColor3 = "Active"});

        -- functions
        local Sliding = false;
            
        local function is_set(value)
            value = math.clamp(value, Slider.Min, Slider.Max)

            local factor = 10 ^ (Slider.ShowDecimals and Slider.Decimals or 0)
            value = math.floor(value * factor + 0.5) / factor

            local autopos = (value - Slider.Min) / (Slider.Max - Slider.Min)

            local circleWidth = SliderCircle.AbsoluteSize.X
            local inlineWidth = Inline.AbsoluteSize.X
            if inlineWidth > 0 then
                local circleUDim = circleWidth / inlineWidth
                autopos = math.clamp(autopos, 0, 1 - circleUDim)
            end

            Framework:Tween(Accent, {Size = UDim2.new(autopos, 3, 1, 0)}, 0.1, Enum.EasingStyle.Linear)
            Framework:Tween(SliderCircle, {Position = UDim2.new(autopos, 0, 0.5, 0)}, 0.1, Enum.EasingStyle.Linear)

            if Slider.Disabled and value == Slider.Min then
                Value.Text = Slider.Disabled
            else
                if Slider.ShowDecimals then
                    if value == math.floor(value) then
                        Value.Text = slider_name:gsub("%[value%]", tostring(value) .. ".0")
                    else
                        Value.Text = slider_name:gsub("%[value%]", tostring(value))
                    end
                else
                    Value.Text = slider_name:gsub("%[value%]", tostring(math.floor(value + 0.5)))
                end
            end

            Val = value
            Interface.Flags[Slider.Flag] = value
            Slider.Callback(value)
        end

        local function is_sliding(input)
            local relative = (input.Position.X - Inline.AbsolutePosition.X) / Inline.AbsoluteSize.X
            local value = Slider.Min + (Slider.Max - Slider.Min) * relative
            is_set(value)
        end;

        for _, obj in pairs({Inline, Accent, SliderCircle}) do
            Framework:Connect(obj.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    is_sliding(input)
                end
            end)
            Framework:Connect(obj.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Sliding = false end
            end)
        end;

        Framework:Connect(Services.UserInputService.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and Sliding then
                is_sliding(input);
            end
        end);

        function Slider:Set(value)
            is_set(value);
        end;

        Flags[Slider.Flag] = is_set;
        Interface.Flags[Slider.Flag] = Slider.State;
        is_set(Slider.State);

        return Slider;
    end;

    -- Keybind
    function Sections:Keybind(Prop)
        Prop = Prop or {};
        --
        local Keybind = {
            Section = self,
            Name     = ( Prop.name or Prop.Name ),
            State    = ( Prop.default or Prop.Default or nil ),
            Mode     = ( Prop.mode or Prop.Mode or "Toggle" ),
            UseKey   = ( Prop.UseKey or false ),
            Ignore   = ( Prop.ignore or Prop.Ignore or false ),
            Callback = ( Prop.callback or Prop.Callback or function() end ),
            Flag     = ( Prop.flag or Prop.Flag or Interface.NextFlag() ),
            Binding  = nil,
        };
        --
        local State, Key = false;
        local ListValue;
        if not Keybind.Ignore then
            local safeKey = (Keybind.State == nil) and "None" or Keybind.State
            local safeName = (Keybind.Name == nil) and "None" or Keybind.Name

            ListValue = Interface.IndicatorGui:NewKey(safeKey, safeName);
        end
        --
        local NewBind = Framework:New("Frame", {
            Name = Keybind.Name,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 24),
			Parent = Keybind.Section.Elements.SectionContent
        });

        local Title = Framework:New("TextLabel", {
			Name = "Title",
			FontFace = Interface.Font,
			TextSize = Interface.FontSize,
			TextStrokeTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Parent = NewBind,
			Text = Keybind.Name
        }):Add({TextColor3 = "Active"});

        local NewKeybind = Framework:New("TextButton", {
            Name = "SectionBind",
            AnchorPoint = Vector2.new(0, 0.5),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Text = "",
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0, -55, 1, 0),
            AutoButtonColor = false,
            Parent = NewBind
        });

        local KeybindBg = Framework:New("Frame", {
            Name = "Toggle Frame";
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 55, 1, 0),
            Position = UDim2.new(0, 0, 0, 1),
            Parent = NewKeybind;
        }):Add({BackgroundColor3 = "Outline"});

        Framework:New("UICorner", {
            Parent = KeybindBg;
            CornerRadius = UDim.new(0, 4);
        });

        local Value = Framework:New("TextLabel", {
            Name = "Value",
            FontFace = Interface.Font,
            Text = "MB2",
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 1,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = KeybindBg
        }):Add({TextColor3 = "Active"});

        local KeybindImage = Framework:New("ImageLabel", {
            Parent = Value;
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 16, 1, -8);
            BackgroundTransparency = 1;
            Image = "rbxassetid://16081386298";
            ImageTransparency = 0;
            ZIndex = 1;
        }):Add({ImageColor3 = "Accent"});

        local KeybindPadding = Framework:New("UIPadding", {
            Name = "UIPadding";
            Parent = Value
        });

        Framework:New("UIListLayout", {
            Name = "UIListLayout";
            Padding = UDim.new(0, 0);
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Vertical;
            VerticalAlignment = Enum.VerticalAlignment.Center;
            Parent = Value;
        });

        local ModeBox = Framework:New("Frame", {
            Name = "ModeBox",
            AnchorPoint = Vector2.new(0, 0.5),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 65, 0, 60),
            Visible = false,
            BackgroundTransparency = 1,
            ZIndex = 10,
            Parent = Interface.ScreenGui
        }):Add({ BackgroundColor3 = "Outline" })
        
        Framework:New("UICorner", {
            Parent = ModeBox,
            CornerRadius = UDim.new(0, 4)
        })

        local Hold = Framework:New("TextButton", {
            Name = "Hold",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0.333, 0),
            ZIndex = 2,
            FontFace = Interface.Font,
            Text = "Hold",
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 1,
            Parent = ModeBox
        })

        local ToggleMode = Framework:New("TextButton", {
            Name = "Toggle",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.333, 0),
            Size = UDim2.new(1, 0, 0.333, 0),
            ZIndex = 2,
            FontFace = Interface.Font,
            Text = "Toggle",
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 1,
            Parent = ModeBox
        })

        local Always = Framework:New("TextButton", {
            Name = "Always",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.667, 0),
            Size = UDim2.new(1, 0, 0.333, 0),
            ZIndex = 2,
            FontFace = Interface.Font,
            Text = "Always",
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 1,
            Parent = ModeBox
        })

        Framework:TweenTheme(Hold, { TextColor3 = Keybind.Mode == "Hold" and "Accent" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        Framework:TweenTheme(ToggleMode, { TextColor3 = Keybind.Mode == "Toggle" and "Accent" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        Framework:TweenTheme(Always, { TextColor3 = Keybind.Mode == "Always" and "Accent" or "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

        local function set(newkey)
            if newkey == nil then
                Key = nil
                Value.Text = "..."
                KeybindImage.Image = Assets.Images:Require("Keyboard")
                KeybindImage.Visible = true
                KeybindPadding.PaddingLeft = UDim.new(0, 6)
                KeybindPadding.PaddingRight = UDim.new(0, -21)
                if Keybind.Flag then
                    Interface.Flags[Keybind.Flag] = Key
                    Keybind.Callback(Key)
                end
                Interface.Flags[Keybind.Flag .. "_KEY"] = nil
                if ListValue then ListValue:Update("None", Keybind.Name) end
                if ListValue then ListValue:SetVisible(false) end
                return
            end

            if string.find(tostring(newkey), "Enum") then
                if Keybind.Connection then
                    Keybind.Connection:Disconnect()
                    if Keybind.Flag then Interface.Flags[Keybind.Flag] = false end
                    Keybind.Callback(false)
                end

                if tostring(newkey):find("Enum.KeyCode.") then
                    newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                    KeybindImage.Image = Assets.Images:Require("Keyboard")
                    KeybindImage.Visible = true
                    KeybindPadding.PaddingLeft = UDim.new(0, 6)
                    KeybindPadding.PaddingRight = UDim.new(0, -21)
                elseif tostring(newkey):find("Enum.UserInputType.") then
                    newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                    KeybindImage.Image = "rbxassetid://16081386298"
                    KeybindImage.Visible = true
                    KeybindPadding.PaddingLeft = UDim.new(0, 10)
                    KeybindPadding.PaddingRight = UDim.new(0, -12)
                end

                if newkey == Enum.KeyCode.Backspace then
                    Key = nil
                    Value.Text = "..."
                    KeybindImage.Image = Assets.Images:Require("Keyboard")
                    KeybindImage.Visible = true
                    KeybindPadding.PaddingLeft = UDim.new(0, 6)
                    KeybindPadding.PaddingRight = UDim.new(0, -21)
                    if Keybind.Flag then
                        Interface.Flags[Keybind.Flag] = Key
                        Keybind.Callback(Key)
                    end
                    if ListValue then ListValue:Update("None", Keybind.Name) end
                    if ListValue then ListValue:SetVisible(false) end
                else
                    Key = newkey
                    local keyName = tostring(newkey):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
                    Value.Text = Interface.KeyNames[keyName] or keyName
                    if Keybind.Flag then
                        Interface.Flags[Keybind.Flag] = Key
                        Keybind.Callback(Key)
                    end
                    if ListValue then ListValue:Update(keyName, Keybind.Name) end
                    if ListValue then ListValue:SetVisible(true) end
                end

                Interface.Flags[Keybind.Flag .. "_KEY"] = newkey

            elseif table.find({"Always", "Toggle", "Hold"}, newkey) then
                Interface.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
                Keybind.Mode = newkey
                if Keybind.Mode == "Always" then
                    State = true
                    if Keybind.Flag then Interface.Flags[Keybind.Flag] = State end
                    Keybind.Callback(true)
                    if ListValue then ListValue:SetVisible(true) end
                end
            else
                State = newkey
                if Keybind.Flag then Interface.Flags[Keybind.Flag] = newkey end
                Keybind.Callback(newkey)
                if ListValue then ListValue:SetVisible(newkey) end
            end
        end

        set(Keybind.State)
        set(Keybind.Mode)

        NewKeybind.MouseButton1Click:Connect(function()
            if Keybind.Binding then return end
            Value.Text = "..."

            Keybind.Binding = Framework:Connect(Services.UserInputService.InputBegan, function(input, gpe)
                gpe = false

                local newKey
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    newKey = input.KeyCode
                else
                    newKey = input.UserInputType
                end

                set(newKey)

                if Keybind.Binding then
                    Keybind.Binding:Disconnect()
                    Keybind.Binding = nil
                end
            end)
        end)

        Framework:Connect(Services.UserInputService.InputBegan, function(inp, gpe)
            if gpe then return end
            if inp.UserInputType ~= Enum.UserInputType.Keyboard and inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.MouseButton2 and inp.UserInputType ~= Enum.UserInputType.MouseButton3 then return end
            if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
                if Keybind.Mode == "Hold" then
                    if Keybind.Flag then Interface.Flags[Keybind.Flag] = true end
                    Keybind.Connection = Framework:Connect(Services.RunService.RenderStepped, function()
                        if Keybind.Callback then Keybind.Callback(true) end
                    end)
                    if ListValue then ListValue:SetVisible(true) end
                elseif Keybind.Mode == "Toggle" then
                    State = not State
                    if Keybind.Flag then Interface.Flags[Keybind.Flag] = State end
                    Keybind.Callback(State)
                    if ListValue then ListValue:SetVisible(State) end
                end
            end
        end)

        Framework:Connect(Services.UserInputService.InputEnded, function(inp)
            if inp.UserInputType ~= Enum.UserInputType.Keyboard and inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.MouseButton2 and inp.UserInputType ~= Enum.UserInputType.MouseButton3 then return end
            if Keybind.Mode == "Hold" and not Keybind.UseKey and (inp.KeyCode == Key or inp.UserInputType == Key) then
                if Keybind.Connection then
                    Keybind.Connection:Disconnect()
                    if Keybind.Flag then Interface.Flags[Keybind.Flag] = false end
                    if Keybind.Callback then Keybind.Callback(false) end
                    Keybind.Connection = nil
                    if ListValue then ListValue:SetVisible(false) end
                end
            end
        end)

        Framework:Connect(NewKeybind.MouseButton2Down, function()
            if ModeBox.Visible then return end

            local absPos, absSize = KeybindBg.AbsolutePosition, KeybindBg.AbsoluteSize
            ModeBox.Position = UDim2.new(0, absPos.X + 55, 0, absPos.Y + absSize.Y/2 - 30 + 110)
            ModeBox.BackgroundTransparency = 1
            ModeBox.Visible = true

            Framework:Tween(ModeBox, {BackgroundTransparency = 0}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            for _, btn in ipairs({Hold, ToggleMode, Always}) do
                Framework:Tween(btn, {TextTransparency = 0}, 0.25)
                if btn:FindFirstChildOfClass("UIStroke") then
                    Framework:Tween(btn.UIStroke, {Transparency = 0}, 0.2)
                end
            end

            if ModeBox:FindFirstChildOfClass("UIStroke") then
                Framework:Tween(ModeBox.UIStroke, {Transparency = 0}, 0.2)
            end

            ToggleMode.ZIndex = 5
        end)

        local function CloseModeBox()
            Framework:Tween(ModeBox, {BackgroundTransparency = 1, Position = ModeBox.Position + UDim2.new(0,0,0,13)}, 0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
                ModeBox.Visible = false
                ToggleMode.ZIndex = 1
            end)
            for _, btn in ipairs({Hold, ToggleMode, Always}) do
                Framework:Tween(btn, {TextTransparency = 1}, 0.13)
                if btn:FindFirstChildOfClass("UIStroke") then
                    Framework:Tween(btn.UIStroke, {Transparency = 1}, 0.13)
                end
            end
            if ModeBox:FindFirstChildOfClass("UIStroke") then
                Framework:Tween(ModeBox.UIStroke, {Transparency = 1}, 0.13)
            end
        end

        local function ThemeAndClose(first, second, third, value)
            local completed = 0
            local function checkClose()
                completed = completed + 1
                if completed == 3 then
                    CloseModeBox()
                end
            end
            Framework:TweenTheme(first, {TextColor3 = value == 1 and "Accent" or "Inactive"}, 0.2, nil, nil, checkClose)
            Framework:TweenTheme(second, {TextColor3 = value == 2 and "Accent" or "Inactive"}, 0.2, nil, nil, checkClose)
            Framework:TweenTheme(third, {TextColor3 = value == 3 and "Accent" or "Inactive"}, 0.2, nil, nil, checkClose)
        end

        Framework:Connect(Hold.MouseButton1Down, function()
            set("Hold")
            ThemeAndClose(Hold, ToggleMode, Always, 1)
        end)

        Framework:Connect(ToggleMode.MouseButton1Down, function()
            set("Toggle")
            ThemeAndClose(Hold, ToggleMode, Always, 2)
        end)

        Framework:Connect(Always.MouseButton1Down, function()
            set("Always")
            ThemeAndClose(Hold, ToggleMode, Always, 3)
        end)

        Framework:Connect(Services.UserInputService.InputBegan, function(Input)
            if ModeBox.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ModeBox.AbsolutePosition, ModeBox.AbsoluteSize
                local mouseX, mouseY = Mouse.X, Mouse.Y
                if not (mouseX >= AbsPos.X and mouseX <= AbsPos.X + AbsSize.X and mouseY >= AbsPos.Y and mouseY <= AbsPos.Y + AbsSize.Y) then
                    CloseModeBox()
                end
            end
        end)

        Interface.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
        Interface.Flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
        Flags[Keybind.Flag] = set
        Flags[Keybind.Flag .. "_KEY"] = set
        Flags[Keybind.Flag .. "_KEY STATE"] = set
        --
        function Keybind:Set(value)
            set(value)
        end

        return Keybind;
    end;

    -- Button
    function Sections:Button(Prop)
        Prop = Prop or {};
        --
        local Button = {
            Window   = self.Window,
            Page     = self.Page,
            Section  = self,
            Name     = (Prop.name or Prop.Name),
            Callback = (Prop.callback or Prop.Callback or function() end),
            _paired  = false,
        };
        --
        local lastButton = self._lastButton
        local pairMode = lastButton and not lastButton._paired
        if pairMode then
            Button.NewButton = Framework:New("TextButton", {
                ZIndex = -3,
                Name = Button.Name,
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 0,
                Position = UDim2.new(1, 8, 0, 0),
                Size = UDim2.new(1, 4, 0, 30),
                Parent = lastButton.NewButton,
            }):Add({BackgroundColor3 = "Accent"})

            lastButton.NewButton.Size = UDim2.new(0.5, -6, 0, 30)
            lastButton._paired = true
            self._lastButton = nil
        else
            Button.NewButton = Framework:New("TextButton", {
                ZIndex = -3,
                Name = Button.Name,
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 0,
                Size = UDim2.new(1, 0, 0, 30),
                Parent = Button.Section.Elements.SectionContent,
            }):Add({BackgroundColor3 = "Accent"})

            self._lastButton = Button
        end;

        Framework:New("UICorner", {
            Parent = Button.NewButton,
            CornerRadius = UDim.new(0, 4),
        });

        Button.Text = Framework:New("TextLabel", {
            Name = "Text",
            FontFace = Interface.Font,
            Text = string.upper(Button.Name),
            TextSize = Interface.FontSize,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Button.NewButton,
        }):Add({TextColor3 = "Middle"})

        Framework:Connect(Button.NewButton.MouseButton1Down, function()
            Button.Callback();
        end);

        function Button:Button(nextProps)
            return self.Section:Button(nextProps);
        end;

        return Button;
    end;

    -- Dropdown
    function Sections:Dropdown(Prop)
        local Prop = Prop or {};
        --
        local Dropdown = {
            Window      = self.Window,
            Page        = self.Page,
            Section     = self,
            Open        = false,
            Name        = (Prop.Name or Prop.name or nil),
            Options     = ( Prop.options or Prop.Options or Prop.values or Prop.Values or {"1","2","3",} ),
            Max         = ( Prop.Max or Prop.max or nil ),
            ScrollMax   = ( Prop.ScrollingMax or Prop.scrollingmax or nil ),
            State       = ( Prop.default or Prop.Default or nil ),
            Callback    = ( Prop.callback or Prop.Callback or function() end ),
            Flag        = ( Prop.flag or Prop.Flag or Interface.NextFlag() ),
            OptionInsts = {},
        };
        --
        local NewList = Framework:New("Frame", {
            ZIndex = -3,
            Name = Dropdown.Name,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
            Parent = (Prop.ForceParent or Dropdown.Section.Elements.SectionContent)
        });

        local Inline = Framework:New("TextButton", {
            Name = "Inline",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -26),
            Size = UDim2.new(1, 0, 0, 26),
            TextStrokeTransparency = 1,
            FontFace = Interface.Font,
            Text = "",
            BackgroundTransparency = 0,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = Interface.FontSize,
            AutoButtonColor = false,
            Parent = NewList
        }):Add({BackgroundColor3 = "Window"});

        Framework:New("UIStroke", {
            Name = "UIStroke",
            BorderStrokePosition = Enum.BorderStrokePosition.Inner,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1,
            Parent = Inline
        }):Add({Color = "Outline"});

        Framework:New("UICorner", {
            Parent = Inline;
            CornerRadius = UDim.new(0, 4);
        });

        local Value = Framework:New("TextLabel", {
            Name = "Value",
            FontFace = Interface.Font,
            Text = "None",
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0, 0),
            TextTruncate = Enum.TextTruncate.AtEnd,
            Size = UDim2.new(1, -120, 1, 0),
            Parent = Inline
        }):Add({TextColor3 = "Active"});

        local Icon = Framework:New("ImageLabel", {
            Parent = Inline;
            Position = UDim2.new(1, -20, 0, 6),
            Size = UDim2.new(0, 14, 0, 14);
            BackgroundTransparency = 1;
            Image = "http://www.roblox.com/asset/?id=115086301008251";
            ImageTransparency = 0;
        }):Add({ImageColor3 = "Inactive"});

        local ContentOutline = Framework:New("ScrollingFrame", {
            Name = "ContentOutline",
            ScrollingEnabled = false,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0,0,0,0),
            ClipsDescendants = true,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, 4),
            Size = UDim2.new(1, 0, 0, 0),
            Visible = false,
            Parent = Inline
        }):Add({BackgroundColor3 = "Outline", ScrollBarImageColor3 = "Accent"});

        Framework:New("UICorner", {
            Parent = ContentOutline;
            CornerRadius = UDim.new(0, 4);
        });

        local UIList = Framework:New("UIListLayout", {
            Name = "UIListLayout",
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ContentOutline
        })

        local function UpdateCanvasSize()
            local maxVisible = 10
            local optionCount = #Dropdown.Options
            local itemHeight = 18
            local padding = 2
            local visibleCount = math.min(optionCount, maxVisible)

            local frameHeight = visibleCount * itemHeight + (visibleCount - 1) * padding + 4
            ContentOutline.Size = UDim2.new(1, 0, 0, frameHeight)

            local totalHeight = optionCount * itemHeight + (optionCount - 1) * padding + 4
            ContentOutline.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

            ContentOutline.ScrollingEnabled = optionCount > maxVisible
            ContentOutline.ScrollBarThickness = optionCount > maxVisible and 3 or 0
        end

        local function TweenOutlineSize(open)
            local maxVisible = 10
            local optionCount = #Dropdown.Options
            local itemHeight = 18
            local padding = 2
            local visibleCount = math.min(optionCount, maxVisible)
            local frameHeight = visibleCount * itemHeight + (visibleCount - 1) * padding + 4

            if not open then
                Framework:Tween(ContentOutline, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                return
            end

            ContentOutline.Visible = true
            ContentOutline.Size = UDim2.new(1, 0, 0, 0)

            Framework:Tween(ContentOutline, { Size = UDim2.new(1, 0, 0, frameHeight) }, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        end

        Framework:New("UIPadding", {
            Name = "UIPadding",
            PaddingBottom = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
            Parent = ContentOutline
        });

        Framework:New("TextLabel", {
            Name = "Title",
            FontFace = Interface.Font,
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 10),
            Parent = NewList,
            Visible = Dropdown.Name ~= nil and true or false,
            Text = Dropdown.Name ~= nil and Dropdown.Name or ""
        }):Add({TextColor3 = "Active"});
        --
        local dropdownOpen = false
        local recentlyClicked = false
        Framework:Connect(Inline.MouseButton1Down, function()
            if recentlyClicked then return end
            recentlyClicked = true
            task.spawn(function()
                task.wait(0.15)
                recentlyClicked = false
            end)

            if dropdownOpen then
                dropdownOpen = false
                Framework:TweenTheme(Icon, { ImageColor3 = "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                for _, inst in next, Dropdown.OptionInsts do
                    local btn = inst.button
                    local text = inst.text
                    if btn and text then
                        Framework:Tween(text, { TextTransparency = 1 }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        Framework:Tween(btn, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    end
                end
                TweenOutlineSize(false)
                task.delay(0.25, function()
                    ContentOutline.Visible = false
                    NewList.ZIndex = -3
                end)
            else
                dropdownOpen = true
                ContentOutline.Visible = true
                NewList.ZIndex = 5
                ContentOutline.Size = UDim2.new(1, 0, 0, 0)
                UpdateCanvasSize()
                TweenOutlineSize(true)
                Framework:TweenTheme(Icon, { ImageColor3 = "Accent" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                for _, inst in next, Dropdown.OptionInsts do
                    local btn = inst.button
                    local text = inst.text
                    if btn and text then
                        text.TextTransparency = 1
                        btn.Size = UDim2.new(1, 0, 0, 0)
                        Framework:Tween(text, { TextTransparency = 0 }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        Framework:Tween(btn, { Size = UDim2.new(1, 0, 0, 18) }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    end
                end
            end
        end)

        Framework:Connect(Services.UserInputService.InputBegan, function(Input)
            if recentlyClicked then return end
            if dropdownOpen and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = Services.UserInputService:GetMouseLocation()
                local pos1, size1 = ContentOutline.AbsolutePosition, ContentOutline.AbsoluteSize
                local pos2, size2 = Inline.AbsolutePosition, Inline.AbsoluteSize
                local insideContent = mouse.X >= pos1.X and mouse.X <= pos1.X + size1.X and mouse.Y >= pos1.Y and mouse.Y <= pos1.Y + size1.Y
                local insideInline = mouse.X >= pos2.X and mouse.X <= pos2.X + size2.X and mouse.Y >= pos2.Y and mouse.Y <= pos2.Y + size2.Y

                if not insideContent and not insideInline then
                    dropdownOpen = false
                    Framework:TweenTheme(Icon, { ImageColor3 = "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                    for _, inst in next, Dropdown.OptionInsts do
                        local btn = inst.button
                        local text = inst.text
                        if btn and text then
                            Framework:Tween(text, { TextTransparency = 1 }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                            Framework:Tween(btn, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        end
                    end

                    local tween = TweenOutlineSize(false)
                    if tween and tween.Completed then
                        tween.Completed:Connect(function()
                            ContentOutline.Visible = false
                            NewList.ZIndex = -3
                        end)
                    end
                end
            end
        end)

        local chosen = Dropdown.Max and {} or nil
        local Count = 0
        --
        local function handleoptionclick(option, button, text)
            button.MouseButton1Down:Connect(function()
                if Dropdown.Max then
                    if table.find(chosen, option) then
                        table.remove(chosen, table.find(chosen, option))
                        local textchosen = {}
                        for _, opt in next, chosen do table.insert(textchosen, opt) end
                        Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",")
                        Framework:TweenTheme(text, { TextColor3 = "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        Interface.Flags[Dropdown.Flag] = chosen
                        Dropdown.Callback(chosen)
                    else
                        if #chosen == Dropdown.Max then
                            Dropdown.OptionInsts[chosen[1]].accent.Visible = false
                            table.remove(chosen, 1)
                        end
                        table.insert(chosen, option)
                        local textchosen = {}
                        for _, opt in next, chosen do table.insert(textchosen, opt) end
                        Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",")
                        Framework:TweenTheme(text, { TextColor3 = "Accent" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        Interface.Flags[Dropdown.Flag] = chosen
                        Dropdown.Callback(chosen)
                    end
                else
                    for opt, tbl in next, Dropdown.OptionInsts do
                        if opt ~= option then
                            Framework:TweenTheme(tbl.text, { TextColor3 = "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        end
                    end

                    chosen = option
                    Value.Text = option
                    Framework:TweenTheme(text, { TextColor3 = "Accent" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                    for _, inst in next, Dropdown.OptionInsts do
                        local btn = inst.button
                        local txt = inst.text
                        if btn and txt then
                            Framework:Tween(txt, { TextTransparency = 1 }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                            Framework:Tween(btn, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        end
                    end

                    TweenOutlineSize(false)
                    task.delay(0.25, function()
                        dropdownOpen = false
                        ContentOutline.Visible = false
                        NewList.ZIndex = -3
                        Framework:TweenTheme(Icon, { ImageColor3 = "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    end)

                    Interface.Flags[Dropdown.Flag] = option
                    Dropdown.Callback(option)
                end
            end)
        end
        --
        local function createoptions(tbl)
            for _, option in next, tbl do
                Dropdown.OptionInsts[option] = {}
                local NewOption = Framework:New("TextButton", {
                    Name = "NewOption",
                    FontFace = Interface.Font,
                    Text = "",
                    TextSize = Interface.FontSize,
                    TextStrokeTransparency = 1,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 0),
                    Parent = ContentOutline
                }):Add({TextColor3 = "Accent"})

                Dropdown.OptionInsts[option].button = NewOption._obj

                local OptionLabel = Framework:New("TextLabel", {
                    Name = "OptionLabel",
                    FontFace = Interface.Font,
                    Text = option,
                    TextSize = Interface.FontSize,
                    TextStrokeTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 4, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = NewOption
                }):Add({TextColor3 = "Inactive"})

                Dropdown.OptionInsts[option].text = OptionLabel
                Count += 1
                handleoptionclick(option, NewOption, OptionLabel)
            end
        end
        createoptions(Dropdown.Options)
        UpdateCanvasSize()
        --
        local set; set = function(option)
            if Dropdown.Max then
                table.clear(chosen)
                option = type(option) == "table" and option or {}

                for opt, tbl in next, Dropdown.OptionInsts do
                    if not table.find(option, opt) then
                        Framework:TweenTheme(tbl.text, { TextColor3 = "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                    end
                end

                for i, opt in next, option do
                    if table.find(Dropdown.Options, opt) and #chosen < Dropdown.Max then
                        table.insert(chosen, opt)
                        Framework:TweenTheme(Dropdown.OptionInsts[opt].text, { TextColor3 = "Accent" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                    end
                end

                local textchosen = {}
                local cutobject = false

                for _, opt in next, chosen do
                    table.insert(textchosen, opt)
                end

                Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

                Interface.Flags[Dropdown.Flag] = chosen
                Dropdown.Callback(chosen)
            end
        end
        --
        function Dropdown:Set(option)
            if Dropdown.Max then
                set(option)
            else
                for opt, tbl in next, Dropdown.OptionInsts do
                    if opt ~= option then
                        Framework:TweenTheme(tbl.text, { TextColor3 = "Inactive" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                    end
                end
                if table.find(Dropdown.Options, option) then
                    chosen = option
                    Framework:TweenTheme(Dropdown.OptionInsts[option].text, { TextColor3 = "Accent" }, 0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                    Value.Text = option
                    Interface.Flags[Dropdown.Flag] = chosen
                    Dropdown.Callback(chosen)
                else
                    chosen = nil
                    Value.Text = "None"
                    Interface.Flags[Dropdown.Flag] = chosen
                    Dropdown.Callback(chosen)
                end
            end
        end
        --
        function Dropdown:Refresh(tbl)
            local oldChoice = Interface.Flags[Dropdown.Flag]
            local wasMulti = Dropdown.Max ~= nil
            local wasOpen = ContentOutline.Visible

            local existing = {}
            for opt, _ in next, Dropdown.OptionInsts do
                existing[opt] = true
            end

            for opt, inst in next, Dropdown.OptionInsts do
                if not table.find(tbl, opt) then
                    if inst.button then
                        coroutine.wrap(function()
                            inst.button:Destroy()
                        end)()
                    end
                    Dropdown.OptionInsts[opt] = nil
                end
            end

            for _, opt in ipairs(tbl) do
                if not Dropdown.OptionInsts[opt] then
                    Dropdown.OptionInsts[opt] = {}
                    local NewOption = Framework:New("TextButton", {
                        Name = "NewOption",
                        FontFace = Interface.Font,
                        Text = "",
                        TextSize = Interface.FontSize,
                        TextStrokeTransparency = 1,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, wasOpen and 18 or 0),
                        Parent = ContentOutline
                    }):Add({TextColor3 = "Accent"})

                    Dropdown.OptionInsts[opt].button = NewOption._obj

                    local OptionLabel = Framework:New("TextLabel", {
                        Name = "OptionLabel",
                        FontFace = Interface.Font,
                        Text = opt,
                        TextSize = Interface.FontSize,
                        TextStrokeTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 4, 0, 0),
                        Size = UDim2.new(1, 0, 1, 0),
                        Parent = NewOption
                    }):Add({TextColor3 = "Inactive"})

                    Dropdown.OptionInsts[opt].text = OptionLabel
                    handleoptionclick(opt, NewOption, OptionLabel)
                end
            end

            Dropdown.Options = tbl

            if wasMulti then
                local validChoices = {}
                if type(oldChoice) == "table" then
                    for _, choice in ipairs(oldChoice) do
                        if table.find(tbl, choice) then
                            table.insert(validChoices, choice)
                        end
                    end
                end
                chosen = validChoices
                Interface.Flags[Dropdown.Flag] = validChoices
                Dropdown:Set(validChoices)
            else
                if oldChoice and table.find(tbl, oldChoice) then
                    chosen = oldChoice
                    Interface.Flags[Dropdown.Flag] = chosen
                    Dropdown:Set(chosen)
                else
                    chosen = nil
                    Interface.Flags[Dropdown.Flag] = chosen
                    Dropdown:Set(nil)
                end
            end
        end
        --
        if Dropdown.Max then
            Flags[Dropdown.Flag] = set
        else
            Flags[Dropdown.Flag] = Dropdown
        end
        Dropdown:Set(Dropdown.State)
        return Dropdown
    end;

    -- ListBox
    function Sections:ListBox(Prop)
        local Prop = Prop or {};
        --
        local ListBox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Open = false,
            Max = (Prop.Max or Prop.max),
            Options = (Prop.options or Prop.Options),
            State = (Prop.default or Prop.Default),
            Callback = (Prop.callback or Prop.Callback or function() end),
            Flag = (Prop.flag or Prop.Flag or Interface.NextFlag()),
            OptionInsts = {},
            Multi = (Prop.Multi or Prop.multi),
            Icon = (Prop.Icon ~= false)
        };
        --
        if ListBox.Multi then
            ListBox.State = type(ListBox.State) == "table" and ListBox.State or {};
            Interface.Flags[ListBox.Flag] = ListBox.State;
        end

        local NewList = Framework:New("TextButton", {
            Name = "NewList",
            FontFace = Interface.Font,
            Text = "",
            TextSize = Interface.FontSize,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = ListBox.Section.Elements.SectionContent
        });

        local ContentInline = Framework:New("Frame", {
            Name = "ContentInline",
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, 0, 0, 0),
            Parent = NewList
        }):Add({BackgroundColor3 = "Window"});

        Framework:New("UIListLayout", {Parent = ContentInline, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder});

        local chosen = ListBox.Multi and {} or nil

        local function apply()
            if Interface.IgnoreFlag then return end
            for opt, tbl in next, ListBox.OptionInsts do
                local active = ListBox.Multi and table.find(chosen, opt) or (chosen == opt)
                Framework:TweenTheme(tbl.text, {TextColor3 = active and "Active" or "Inactive"}, 0.3)
                Framework:TweenTheme(tbl.button, {BackgroundColor3 = active and "Outline" or "Window"}, 0.3)
                if tbl.image then
                    Framework:TweenTheme(tbl.image, {ImageColor3 = active and "Accent" or "Inactive"}, 0.3)
                end
            end
        end

        local function toggle(option)
            if ListBox.Multi then
                local i = table.find(chosen, option)
                if i then
                    table.remove(chosen, i)
                else
                    table.insert(chosen, option)
                end
                Interface.Flags[ListBox.Flag] = chosen
                ListBox.Callback(chosen)
            else
                chosen = option
                Interface.Flags[ListBox.Flag] = option
                ListBox.Callback(option)
            end
            apply()
        end

        local function handleoptionclick(option, button)
            button.MouseButton1Down:Connect(function()
                toggle(option)
            end)
        end

        local function createoptions(tbl)
            local maxOptions = ListBox.Max and math.min(ListBox.Max, #tbl) or #tbl
            for i = 1, maxOptions do
                local option = tbl[i]
                ListBox.OptionInsts[option] = {}

                local NewOption = Framework:New("TextButton", {
                    Name = "NewOption",
                    FontFace = Interface.Font,
                    Text = "",
                    TextSize = Interface.FontSize,
                    AutoButtonColor = false,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 24),
                    Parent = ContentInline
                }):Add({BackgroundColor3 = "Window"});

                Framework:New("UICorner", {Parent = NewOption, CornerRadius = UDim.new(0, 4)})

                local FileImage
                if ListBox.Icon then
                    FileImage = Framework:New("ImageLabel", {
                        Parent = NewOption,
                        Position = UDim2.new(0, 4, 0, 4),
                        Size = UDim2.new(0, 16, 0, 16),
                        BackgroundTransparency = 1,
                        Image = Assets.Images:Require("File"),
                        ImageTransparency = 0,
                        ZIndex = 1,
                    }):Add({ImageColor3 = "Inactive"})
                end

                local OptionLabel = Framework:New("TextLabel", {
                    Name = "OptionLabel",
                    FontFace = Interface.Font,
                    Text = option,
                    TextSize = Interface.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(ListBox.Icon and 0 or 0, ListBox.Icon and 26 or 4, 0, 0),
                    Size = UDim2.new(1, -4, 1, 0),
                    Parent = NewOption
                }):Add({TextColor3 = "Inactive"})

                ListBox.OptionInsts[option].text = OptionLabel
                ListBox.OptionInsts[option].button = NewOption
                ListBox.OptionInsts[option].image = FileImage

                handleoptionclick(option, NewOption)
            end
        end

        createoptions(ListBox.Options)

        function ListBox:Set(option, silent)
            if ListBox.Multi then
                chosen = {}
                if type(option) == "table" then
                    for _, v in next, option do
                        if table.find(ListBox.Options, v) then
                            table.insert(chosen, v)
                        end
                    end
                elseif table.find(ListBox.Options, option) then
                    table.insert(chosen, option)
                end
                Interface.Flags[ListBox.Flag] = chosen
                if not silent then ListBox.Callback(chosen) end
                apply()
                return
            end

            if table.find(ListBox.Options, option) then
                chosen = option
                apply()
                if not Interface.IgnoreFlag then
                    Interface.Flags[ListBox.Flag] = chosen
                end
                if not silent then
                    ListBox.Callback(chosen)
                end
            else
                chosen = nil
                Interface.Flags[ListBox.Flag] = nil
                if not silent then
                    ListBox.Callback(nil)
                end
            end
        end

        function ListBox:Refresh(tbl)
            local old = chosen or Interface.Flags[ListBox.Flag]

            for _, opt in next, ListBox.OptionInsts do
                opt.button:Destroy()
            end

            table.clear(ListBox.OptionInsts)
            ListBox.Options = tbl
            createoptions(tbl)

            task.defer(function()
                ListBox:Set(old, true)
            end)
        end

        Flags[ListBox.Flag] = ListBox
        if not ListBox.State and #ListBox.Options > 0 and not ListBox.Multi then
            ListBox.State = ListBox.Options[1]
        end

        ListBox:Set(ListBox.State);
        return ListBox;
    end;

    -- Textbox
    function Sections:Textbox(Prop)
        Prop = Prop or {};
        --
        local Textbox = {
            Window      = self.Window,
            Page        = self.Page,
            Section     = self,
            Name        = ( Prop.Name or Prop.name ),
            Placeholder = ( Prop.Placeholder or Prop.placeholder ),
            Callback    = ( Prop.callback or Prop.Callback or function() end ),
            Flag        = ( Prop.flag or Prop.Flag or Interface.NextFlag() ),
        };
        --
        do
            Textbox.NewBox = Framework:New("TextButton", {
                Name = Textbox.Name,
                Text = "",
                TextColor3 = Color3.fromRGB(0, 0, 0),
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 24),
                Parent = Textbox.Section.Elements.SectionContent
            }):Add({TextColor3 = "Inactive", BackgroundColor3 = "Outline"});

            Framework:New("UICorner", { Parent = Textbox.NewBox, CornerRadius = UDim.new(0, 4) });
            
            Textbox.Value = Framework:New("TextBox", {
                Name = "Value",
                FontFace = Interface.Font,
                Text = Textbox.Placeholder,        
                TextSize = Interface.FontSize,
                TextStrokeTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                TextTruncate = Enum.TextTruncate.AtEnd,
                ClearTextOnFocus = false,
                Parent = Textbox.NewBox
            }):Add({TextColor3 = "Inactive", PlaceholderColor3 = "Inactive"});
        end;
        -- 
        Textbox.Value._obj.Focused:Connect(function()
            if Textbox.Value.Text == Textbox.Placeholder then
                Textbox.Value.Text = "";
            end;
        end);
        Textbox.Value._obj.FocusLost:Connect(function()
            if Textbox.Value.Text == "" then
                Textbox.Value.Text = Textbox.Placeholder;
            else
                Textbox.Callback(Textbox.Value.Text);
                Interface.Flags[Textbox.Flag] = Textbox.Value.Text;
            end;
        end);
        --
        local function set(str)
            Textbox.Value.Text = str
            Interface.Flags[Textbox.Flag] = str
            Textbox.Callback(str)
        end;
        -- 
        Flags[Textbox.Flag] = set;
        return Textbox;
    end;

    -- Preview
    function Sections:Preview(Prop)
        Prop = Prop or {};
        --
        local Preview = {
            Window      = self.Window,
            Page        = self.Page,
            Section     = self,
        };
        --
        do

        end;
    end;
    
    -- Playerlist
    function Pages:PlayerList(Prop)
        Prop = Prop or {};
        --
        local Playerlist = {
            Page = self,
            Players = {},
            CurrentPlayer = nil;
            LastPlayer = nil;
            Flag = ( Prop.flag or Prop.Flag or Prop.pointer or Prop.Pointer or Interface.NextFlag() ),
        };
        --
        local NewPlayer = Framework:New("Frame", {
            Name = "NewPlayer",
            BorderSizePixel = 0,
            Size = UDim2.new(1, -23, 1, -5),
            Position = UDim2.new(0, 10, 0, 1),
            Parent = Playerlist.Page.Elements.Main
        }):Add({BackgroundColor3 = "Window"});

        Framework:New("UIStroke", {
            Name = "UIStroke",
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1,
            Parent = NewPlayer
        }):Add({Color = "Outline"});

        Framework:New('UICorner', {
            Parent = NewPlayer,
            CornerRadius = UDim.new(0, 4)
        });

        local SectionTop = Framework:New("Frame", {
            Name = "SectionTop",
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = NewPlayer
        }):Add({BackgroundColor3 = "Window"});

        local SectionName = Framework:New("TextLabel", {
            Name = "SectionName",
            FontFace = Interface.Font,
            Text = "Player List",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 0,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, 3),
            Size = UDim2.new(1, 0, 1, 0),
            Parent = SectionTop
        })

        local List = Framework:New("ScrollingFrame", {
            Name = "List",
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            ScrollBarThickness = 3;
            Active = true,
            BorderColor3 = Color3.fromRGB(50,50,50),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, 25),
            Size = UDim2.new(1, -10, 0, 255),
            Parent = NewPlayer
        }):Add({BackgroundColor3 = "Window", ScrollBarImageColor3 = "Accent"});

        Framework:New('UICorner', {
            Parent = List,
            CornerRadius = UDim.new(0, 4)
        });

        Framework:New("UIStroke", {
            Name = "UIStroke",
            LineJoinMode = Enum.LineJoinMode.Round,
            Parent = List
        }):Add({Color = "Outline"});

        Framework:New("UIListLayout", {
            Name = "UIListLayout",
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = List
        })

        local ImageLabel = Framework:New("ImageLabel", {
            Name = "ImageLabel",
            Image = "",
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderColor3 = Color3.fromRGB(50,50,50),
            Position = UDim2.new(0, 5, 1, -75),
            Size = UDim2.new(0, 70, 0, 70),
            Parent = NewPlayer
        })

        Framework:New('UICorner', {
            Parent = ImageLabel,
            CornerRadius = UDim.new(0, 5)
        });

        Framework:New("UIStroke", {
            Name = "UIStroke",
            LineJoinMode = Enum.LineJoinMode.Round,
            Parent = ImageLabel
        }):Add({Color = "Outline"});

        local PlayerName1 = Framework:New("TextLabel", {
            Name = "PlayerName",
            FontFace = Interface.Font,
            Text = "Select a Player.",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 0,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 80, 1, -75),
            Size = UDim2.new(1, -459, 0, 70),
            Parent = NewPlayer
        })

        local Priority = Framework:New("TextButton", {
            Name = "Priority",
            FontFace = Interface.Font,
            Text = "",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = Interface.FontSize,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -105, 1, -70),
            Size = UDim2.new(0, 100, 0, 25),
            Parent = NewPlayer
        }):Add({BackgroundColor3 = "Window"});

        Framework:New('UICorner', {
            Parent = Priority,
            CornerRadius = UDim.new(0, 5)
        });

        Framework:New("UIStroke", {
            Name = "UIStroke",
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Parent = Priority
        }):Add({Color = "Outline"});

        local PriorityLabel = Framework:New("TextLabel", {
            Name = "PriorityLabel",
            FontFace = Interface.Font,
            Text = "Prioritize",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Priority
        })

        local Friend = Framework:New("TextButton", {
            Name = "Friend",
            FontFace = Interface.Font,
            Text = "",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = Interface.FontSize,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -105, 1, -34),
            Size = UDim2.new(0, 100, 0, 25),
            Parent = NewPlayer
        }):Add({BackgroundColor3 = "Window"});

        Framework:New('UICorner', {
            Parent = Friend,
            CornerRadius = UDim.new(0, 5)
        });

        Framework:New("UIStroke", {
            Name = "UIStroke",
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Parent = Friend
        }):Add({Color = "Outline"});

        local FriendLabel = Framework:New("TextLabel", {
            Name = "FriendLabel",
            FontFace = Interface.Font,
            Text = "Friendly",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = Interface.FontSize,
            TextStrokeTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Friend
        })

        --// Main
        local chosen = nil
        local optioninstances = {}
        local function handleoptionclick(option, button, accent)
            button.MouseButton1Click:Connect(function()
                chosen = option
                Interface.Flags[Playerlist.Flag] = option
                Playerlist.CurrentPlayer = option
                --
                for opt, tbl in next, optioninstances do
                    if opt ~= option then
                        tbl.accent.Visible = false
                    end
                end
                accent.Visible = true
                --
                if Playerlist.CurrentPlayer ~= Playerlist.LastPlayer then
                    Playerlist.LastPlayer = Playerlist.CurrentPlayer;
                    PlayerName1.Text = ("Id : %s\nDisplay Name : %s\nName : %s\nAccount Age : %s\nHealth: %s\nTeam: %s"):format(
                        Playerlist.CurrentPlayer.UserId,
                        Playerlist.CurrentPlayer.DisplayName ~= "" and Playerlist.CurrentPlayer.DisplayName or Playerlist.CurrentPlayer.Name,
                        Playerlist.CurrentPlayer.Name,
                        Playerlist.CurrentPlayer.AccountAge,
                        Playerlist.CurrentPlayer.Character and Playerlist.CurrentPlayer.Character:FindFirstChild("Humanoid") and Playerlist.CurrentPlayer.Character.Humanoid.Health or "N/A",
                        Playerlist.CurrentPlayer.Team and Playerlist.CurrentPlayer.Team.Name or "No Team"
                    );
                    local imagedata = Services.Players:GetUserThumbnailAsync(Playerlist.CurrentPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

                    ImageLabel.Image = imagedata
                end;
            end)
        end
        --
        local function createoptions(tbl)
            for i, option in next, tbl do
                optioninstances[option] = {}

                local NewPlayer1 = Framework:New("TextButton", {
                    Name = "NewPlayer",
                    FontFace = Interface.Font,
                    Text = "",
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = Interface.FontSize,
                    AutoButtonColor = false,
                    BorderColor3 = Color3.fromRGB(50,50,50),
                    Size = UDim2.new(1, 0, 0, 15),
                    Parent = List
                }):Add({BackgroundColor3 = "Outline"});

                local PlayerName = Framework:New("TextLabel", {
                    Name = "PlayerName",
                    FontFace = Interface.Font,
                    Text = option.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = Interface.FontSize,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 6, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = NewPlayer1
                })

                local PlayerStatus = Framework:New("TextLabel", {
                    Name = "PlayerStatus",
                    FontFace = Interface.Font,
                    Text = option == Services.Players.LocalPlayer and "Local Player" or table.find(Interface.Friends, option) and "Friendly" or table.find(Interface.Priorities, option) and "Priority" or "None",
                    TextColor3 = option == Services.Players.LocalPlayer and Color3.fromRGB(0, 170, 255) or table.find(Interface.Friends, option) and Color3.fromRGB(0,255,0) or table.find(Interface.Priorities, option) and Color3.fromRGB(255,0,0) or Color3.fromRGB(255,255,255),
                    TextSize = Interface.FontSize,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, -3, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = NewPlayer1
                })

                local AccentLine = Framework:New("Frame", {
                    Name = "AccentLine",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 2, 1, 0),
                    Visible = false,
                    Parent = NewPlayer1
                }):Add({BackgroundColor3 = "Accent"});

                optioninstances[option].button = NewPlayer1
                optioninstances[option].text = PlayerName
                optioninstances[option].status = PlayerStatus
                optioninstances[option].accent = AccentLine
                
                if option == chosen then
                    chosen = option
                    Interface.Flags[Playerlist.Flag] = option
                    Playerlist.CurrentPlayer = option
                    --
                    for opt, tbl in next, optioninstances do
                        if opt ~= option then
                            tbl.accent.Visible = false
                        end
                    end
                    AccentLine.Visible = true
                    --
                    if Playerlist.CurrentPlayer ~= Playerlist.LastPlayer then
                        Playerlist.LastPlayer = Playerlist.CurrentPlayer;
                        PlayerName1.Text = ("Id : %s\nDisplay Name : %s\nName : %s\nAccount Age : %s"):format(Playerlist.CurrentPlayer.UserId, Playerlist.CurrentPlayer.DisplayName ~= "" and Playerlist.CurrentPlayer.DisplayName or Playerlist.CurrentPlayer.Name, Playerlist.CurrentPlayer.Name, Playerlist.CurrentPlayer.AccountAge)
                        --
                        local imagedata = Services.Players:GetUserThumbnailAsync(Playerlist.CurrentPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

                        ImageLabel.Image = imagedata
                    end;
                end

                if option ~= Services.Players.LocalPlayer then
                    handleoptionclick(option, NewPlayer1, AccentLine)
                end
            end
        end
        --
        function Playerlist:Refresh(tbl, dontchange)
            content = table.clone(tbl)

            for _, opt in next, optioninstances do
                coroutine.wrap(function()
                    opt.button:Remove()
                end)()
            end

            table.clear(optioninstances)

            createoptions(content)

            if dontchange then
                chosen = Playerlist.CurrentPlayer
                Playerlist.CurrentPlayer = chosen
            else
                chosen = nil
                Playerlist.CurrentPlayer = nil
            end
            Interface.Flags[Playerlist.Flag] = chosen
        end
        --
        Priority.MouseButton1Click:Connect(function()
            if Playerlist.CurrentPlayer == nil then return end

            if not optioninstances[Playerlist.CurrentPlayer] then
                Playerlist.CurrentPlayer = nil
                PlayerName1.Text = "Select a Player."
                return
            end

            if table.find(Interface.Friends, Playerlist.CurrentPlayer) then
                table.remove(Interface.Friends, table.find(Interface.Friends, Playerlist.CurrentPlayer))
            end

            if not table.find(Interface.Priorities, Playerlist.CurrentPlayer) then
                table.insert(Interface.Priorities, Playerlist.CurrentPlayer)
                optioninstances[Playerlist.CurrentPlayer].status.Text = "Priority"
                optioninstances[Playerlist.CurrentPlayer].status.TextColor3 = Color3.fromRGB(255, 0, 0)
            else
                table.remove(Interface.Priorities, table.find(Interface.Priorities, Playerlist.CurrentPlayer))
                optioninstances[Playerlist.CurrentPlayer].status.Text = "None"
                optioninstances[Playerlist.CurrentPlayer].status.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        --
        Friend.MouseButton1Click:Connect(function()
            if Playerlist.CurrentPlayer == nil then return end

            if not optioninstances[Playerlist.CurrentPlayer] then
                Playerlist.CurrentPlayer = nil
                PlayerName1.Text = "Select a Player."
                return
            end

            if table.find(Interface.Priorities, Playerlist.CurrentPlayer) then
                table.remove(Interface.Priorities, table.find(Interface.Priorities, Playerlist.CurrentPlayer))
            end

            if not table.find(Interface.Friends, Playerlist.CurrentPlayer) then
                table.insert(Interface.Friends, Playerlist.CurrentPlayer)
                optioninstances[Playerlist.CurrentPlayer].status.Text = "Friendly"
                optioninstances[Playerlist.CurrentPlayer].status.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                table.remove(Interface.Friends, table.find(Interface.Friends, Playerlist.CurrentPlayer))
                optioninstances[Playerlist.CurrentPlayer].status.Text = "None"
                optioninstances[Playerlist.CurrentPlayer].status.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        --
        createoptions(Services.Players:GetPlayers())
        --
        Services.Players.PlayerAdded:Connect(function()
            Playerlist:Refresh(Services.Players:GetPlayers(), true)
        end)
        --
        Services.Players.PlayerRemoving:Connect(function()
            Playerlist:Refresh(Services.Players:GetPlayers(), true)
        end)
        -- Fix
        Playerlist.Page.Elements.Left.Size = UDim2.new(0.5, -5,0.5, -80)
        Playerlist.Page.Elements.Right.Size = UDim2.new(0.5, -5,0.5, -80)
        Playerlist.Page.Elements.Left.Position = UDim2.new(0, 0,0.5, 85)
        Playerlist.Page.Elements.Right.Position = UDim2.new(0.5, 5,0.5, 85)
    end;
end;

do -- Settings
    function Interface:General(Tab)
        do
            local Settings = Tab:Section({Name = "UI Settings"});
            Settings:Label({Name = "UI"})
            Settings:Keybind({Name = "Menu Key", Flag = "Menu Key", UseKey = true, Mode = "Toggle", Callback = function(Key)
                Interface.Bind = Key;
            end});
            Settings:Slider({ Name = "Text Size", Min = 1, Max = 18, Default = Interface.FontSize, Callback = function(Value)
                Framework:SetFontSize(Value)
            end});
            Settings:Dropdown({ Name = "Font", Options = {"Montserrat", "Elektr", "Smallest Pixel", "ProggyTiny", "TempleOs", "ProggyClean", "Retro", "QuinqueFive", "Micro", "Ubuntu"}, Default = "Montserrat", Callback = function(selected)
                local Fonts = {
                    ["Montserrat"] = Assets.Fonts.Montserrat,
                    ["Smallest Pixel"] = Assets.Fonts.SmallestPixel,
                    ["TempleOs"] = Assets.Fonts.Templeos,
                    ["ProggyTiny"] = Assets.Fonts.ProggyTiny,
                    ["ProggyClean"] = Assets.Fonts.ProggyClean,
                    ["Retro"] = Assets.Fonts.Retro,
                    ["QuinqueFive"] = Assets.Fonts.QuinqueFive,
                    ["Micro"] = Assets.Fonts.Micro,
                    ["Elektr"] = Assets.Fonts.Elektr,
                    ["Ubuntu"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold),
                };
                Framework.CurrentFont = Fonts[selected];
                Framework:ApplyFontSettings();
            end});
        end;
        --
        do
            local Colors = Tab:Section({Name = "UI Themes", Side = "Right"});
            Colors:Label({Name = "Themes"});
            Colors:Toggle({Name = "Accent", Flag = "Accent"}):Colorpicker({Transparency = 0, Flag = "Accent Color", Callback = function(state)
                Framework:UpdateAccent(state.Color, state.Transparency);
            end});
            Colors:Toggle({Name = "Window", Flag = "Window"}):Colorpicker({Transparency = 0, Flag = "Window Color", Default = Framework.Theme.Colors.Window, Callback = function(state)
                Framework:UpdateWindow(state.Color, state.Transparency);
            end});
            Colors:Toggle({Name = "Active", Flag = "Active"}):Colorpicker({Transparency = 0, Flag = "Active Color", Default = Framework.Theme.Colors.Active, Callback = function(state)
                Framework:UpdateActive(state.Color, state.Transparency);
            end});
            Colors:Toggle({Name = "Inactive", Flag = "Inactive"}):Colorpicker({Transparency = 0, Flag = "Inactive Color", Default = Framework.Theme.Colors.Inactive, Callback = function(state)
                Framework:UpdateInactive(state.Color, state.Transparency);
            end});
            Colors:Toggle({Name = "Middle", Flag = "Middle"}):Colorpicker({Transparency = 0, Flag = "Middle Color", Default = Framework.Theme.Colors.Middle, Callback = function(state)
                Framework:UpdateMiddle(state.Color, state.Transparency);
            end});
            Colors:Toggle({Name = "Outline", Flag = "Outline"}):Colorpicker({Transparency = 0, Flag = "Outline Color", Default = Framework.Theme.Colors.Outline, Callback = function(state)
                Framework:UpdateOutline(state.Color, state.Transparency);
            end});
            Colors:Toggle({Name = "Outline2", Flag = "Outline2"}):Colorpicker({Transparency = 0, Flag = "Outline2 Color", Default = Framework.Theme.Colors.Outline2, Callback = function(state)
                Framework:UpdateOutline2(state.Color, state.Transparency);
            end});
        end;
        --
        do
            local VisualIndicators = Tab:Section({Name = "Indicator Display"});
            VisualIndicators:Toggle({Name = "Show Keybinds", Flag = "Show Keybinds", Default = true, Callback = function(State)
                Interface.IndicatorGui:SetVisible(State);
            end});
            VisualIndicators:Toggle({Name = "Show Watermark", Flag = "Show Watermark", Default = true, Callback = function(State)
                Interface.WatermarkGui:SetVisible(State);
            end});
        end;
        --
        do
            local Uninject = Tab:Section({Name = "Unload", Side = "Right"});
            Uninject:Button({Name = "Unload", Callback = function()
                Framework:Tween(Blur, {Size = 0}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
                Framework:Unload();
            end});
        end;
    end;
    --
    function Interface:Configs(Tab)
        local ConfigList;
        local configpath = gamepath.."Configs/";
        local CurrentList = {};
        --
        local function cfg_list()
            local List = {};
            if not isfolder(gamepath) then makefolder(gamepath) end;
            if not isfolder(configpath) then makefolder(configpath) end;

            for _, file in ipairs(listfiles(configpath)) do
                local name = (file:gsub("\\","/")):match("s.win/Configs/(.*)%.cfg");
                if name and name ~= "autoload" then 
                    List[#List + 1] = name
                end
            end

            table.sort(List);
            local old = Interface.Flags["cfg_list"]; 
            CurrentList = List;
            ConfigList:Refresh(List);

            if old and table.find(List, old) then ConfigList:Set(old, true) end;
            if refreshAutoloadList then refreshAutoloadList() end;
        end;
        --
        do
            local Presets = Tab:Section({Name = "Presets", Side = "Left"});
            Presets:Textbox({Name = "Config Name", Flag = "cfg_name", Placeholder = "Enter config name..."});
            ConfigList = Presets:ListBox({Flag = "cfg_list", Options = {}, Max = 5});
            
            Presets:Divider({});

            Presets:Button({Name = "Create", Callback = function()
                local config_name = Interface.Flags["cfg_name"];
                if config_name ~= "" and not isfile(configpath .. config_name .. ".cfg") then
                    local t = os.date("%m/%d/%Y %H:%M")
                    writefile(configpath .. config_name .. ".cfg", "@lastmodified:"..t.."\n@createdby:local\n"..Interface:GetConfig());
                    Interface:Notification("Created [".. config_name .."].", 3);
                    cfg_list();
                end
            end});

            cfg_list();
        end;
        --
        do
            local Configuration = Tab:Section({Name = "Configuration", Side = "Right"});

            local ConfigName = Configuration:InfoLabel({ Name1 = "Name: ", Name2 = "None" }); 
            local ConfigBy = Configuration:InfoLabel({ Name1 = "Created by: ", Name2 = "local" }); 
            local ConfigPath = Configuration:InfoLabel({ Name1 = "Last modified: ", Name2 = "none" });
            Configuration:Divider({});

            do
                local oldSet = ConfigList.Set
                function ConfigList:Set(value, ...)
                    oldSet(self, value, ...)
                    if value then
                        ConfigName.NewLabel.RightLabel.Text = value .. ".cfg";
                        local raw = readfile("s.win/Configs/" .. value .. ".cfg")
                        local t = raw:match("@lastmodified:(.-)\n") or "none"
                        local c = raw:match("@createdby:(.-)\n") or "Unknown"
                        ConfigPath.NewLabel.RightLabel.Text = t
                        ConfigBy.NewLabel.RightLabel.Text = c
                    else
                        ConfigName.NewLabel.RightLabel.Text = "none";
                        ConfigPath.NewLabel.RightLabel.Text = "none";
                        ConfigBy.NewLabel.RightLabel.Text = "Unknown";
                    end
                end
            end

            Configuration:Button({Name = "Load", Callback = function()
                local c = Interface.Flags["cfg_list"];
                if c then
                    local raw = readfile("s.win/Configs/" .. c .. ".cfg")
                    local t = raw:match("@lastmodified:(.-)\n") or "none"
                    local u = raw:match("@createdby:(.-)\n") or "Unknown"
                    ConfigPath.NewLabel.RightLabel.Text = t
                    ConfigBy.NewLabel.RightLabel.Text = u
                    raw = raw:gsub("^@lastmodified:.-\n", ""):gsub("^@createdby:.-\n", "")
                    local lock = Interface.Flags["cfg_list"]; 
                    Interface.IgnoreFlag = true;
                    Interface:LoadConfig(raw);
                    Interface.IgnoreFlag = false;
                    Interface.Flags["cfg_list"] = lock; 
                    Interface:Notification("Loaded [".. c .."].", 3);
                end;
            end}):Button({Name = "Save", Callback = function()
                local c = Interface.Flags["cfg_list"];
                if c then
                    local raw_existing = ""
                    if isfile("s.win/Configs/" .. c .. ".cfg") then
                        raw_existing = readfile("s.win/Configs/" .. c .. ".cfg")
                    end
                    local existing_creator = raw_existing:match("@createdby:(.-)\n") or "Unknown"
                    local t = os.date("%m/%d/%Y %H:%M")
                    writefile("s.win/Configs/" .. c .. ".cfg", "@lastmodified:"..t.."\n@createdby:"..existing_creator.."\n"..Interface:GetConfig());
                    ConfigPath.NewLabel.RightLabel.Text = t
                    Interface:Notification("Saved [".. c .."].", 3);
                end;
            end});
            
            Configuration:Button({Name = "Delete", Callback = function()
                local c = Interface.Flags["cfg_list"];
                if c then
                    delfile("s.win/Configs/" .. c .. ".cfg");
                    Interface:Notification("Deleted [".. c .."].", 3);
                    task.wait(0.1);
                    cfg_list();
                end;
            end});
        end;
        --
        do
            local Autoload = Tab:Section({Name = "Autoload", Side = "Left"});
            local autoloadPath = gamepath.."Configs/autoload.cfg";

            local AutoloadList = Autoload:ListBox({Options = {}, Max = 5, Flag = "Config_Autoload_Options"});

            function refreshAutoloadList()
                local List = {};
                if not isfolder(gamepath) then makefolder(gamepath) end
                if not isfolder(gamepath.."Configs/") then makefolder(gamepath.."Configs/") end
                for _, file in ipairs(listfiles(gamepath.."Configs/")) do
                    local name = (file:gsub("\\","/")):match("s.win/Configs/(.*)%.cfg");
                    if name and name ~= "autoload" then
                        List[#List + 1] = name
                    end
                end
                table.sort(List)
                AutoloadList:Refresh(List)
            end

            refreshAutoloadList()

            Autoload:Divider({});

            Autoload:Button({Name = "Set", Callback = function()
                local selected = Interface.Flags["Config_Autoload_Options"]
                if selected then
                    writefile(autoloadPath, selected)
                    Interface:Notification("Autoload set to ["..selected.."]", 3)
                end
            end})

            Autoload:Button({Name = "Disable", Callback = function()
                if isfile(autoloadPath) then
                    delfile(autoloadPath)
                    Interface:Notification("Autoload disabled.", 3)
                    refreshAutoloadList()
                end
            end})

            if isfile(autoloadPath) then
                local cfgName = readfile(autoloadPath)
                local cfgFile = gamepath.."Configs/"..cfgName..".cfg"
                if isfile(cfgFile) then
                    Interface:LoadConfig(readfile(cfgFile))
                    Interface:Notification("Autoloaded ["..cfgName.."]", 3)
                end
            end
        end;
    end;
end;

return Interface;