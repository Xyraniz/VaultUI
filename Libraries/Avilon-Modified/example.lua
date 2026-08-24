local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Avilon-Modified/source.lua"))()

local Window = Library:Window({
    Name = "Avilon Dashboard",
    SubName = "Movement and display controls",
    Size = Vector2.new(820, 520),
    ThemePreset = "Emerald",
    ShowGrid = true,
    GridTransparency = 0.88
})

local MainPage = Window:Page({
    Name = "Dashboard",
    Icon = "rbxassetid://102973834692853"
})

local Controls = MainPage:SubPage({
    Name = "Controls",
    Description = "Adjust local movement and interface settings"
})

local Movement = Controls:Section({
    Name = "Movement",
    Description = "Character values",
    Side = 1
})

local Visuals = Controls:Section({
    Name = "Visuals",
    Description = "Window preferences",
    Side = 2
})

local player = game:GetService("Players").LocalPlayer
local speed = 16
local jumpPower = 50

Movement:Button({
    Name = "Reset character values",
    Callback = function()
        speed = 16
        jumpPower = 50
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            humanoid.JumpPower = jumpPower
        end
    end
})

Movement:Toggle({
    Name = "Enable movement tuning",
    Flag = "MovementEnabled",
    Default = true,
    Callback = function(enabled)
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = enabled and speed or 16
            humanoid.JumpPower = enabled and jumpPower or 50
        end
    end
})

Movement:Slider({
    Name = "Walk speed",
    Flag = "WalkSpeed",
    Min = 8,
    Max = 32,
    Default = speed,
    Suffix = " studs",
    Callback = function(value)
        speed = value
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

Movement:Slider({
    Name = "Jump power",
    Flag = "JumpPower",
    Min = 30,
    Max = 100,
    Default = jumpPower,
    Suffix = " power",
    Callback = function(value)
        jumpPower = value
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
        end
    end
})

Visuals:Dropdown({
    Name = "Accent preset",
    Flag = "AccentPreset",
    Items = { "Emerald", "Rose", "Ruby", "Dark" },
    Default = "Emerald",
    Callback = function(value)
        Window:SetTheme({Preset = value})
    end
})

Visuals:Colorpicker({
    Name = "Highlight color",
    Flag = "HighlightColor",
    Default = Color3.fromRGB(46, 204, 113),
    Callback = function(value)
        Window:SetTheme({["Accent"] = value})
    end
})

Visuals:Textbox({
    Name = "Window subtitle",
    Flag = "WindowSubtitle",
    Default = "Movement and display controls",
    Placeholder = "Enter a subtitle",
    Finished = true,
    Callback = function(value)
        Window.SubName = value
    end
})

Visuals:Label({Name = "Press RightShift to toggle the window"}):Keybind({
    Name = "Window toggle",
    Flag = "WindowToggle",
    Default = Enum.KeyCode.RightShift,
    Mode = "Toggle",
    Callback = function()
        Window:SetOpen(not Window.IsOpen)
    end
})
