-- Vision v2 / VaultUI showcase
-- Preserved as a reusable Roblox UI library with a runnable API example.
local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Vision-v2/source.lua"
local Vision = loadstring(game:HttpGet(SOURCE))()

local Window = Vision:Create({
    Name = "Vision v2 Showcase",
    Footer = "VaultUI • Vision v2",
    ToggleKey = Enum.KeyCode.RightShift,
    LoadedCallback = function()
        print("Vision v2 loaded")
    end,
})

local home = Window:Tab({
    Name = "Home",
    Icon = "rbxassetid://11396131982",
    ActivationCallback = function()
        print("Home tab activated")
    end,
})

local controls = home:Section({ Name = "Controls" })
controls:Button({
    Name = "Show notification",
    Callback = function()
        Vision:Notify({
            Name = "Vision v2",
            Text = "The callback was executed successfully.",
            Duration = 3,
        })
    end,
})

controls:Toggle({
    Name = "Enabled",
    Default = true,
    Callback = function(value)
        print("Enabled:", value)
    end,
})

controls:Slider({
    Name = "Opacity",
    Min = 0,
    Max = 100,
    Default = 75,
    Callback = function(value)
        print("Opacity:", value)
    end,
})

local inputs = home:Section({ Name = "Inputs" })
inputs:SmallTextbox({
    Name = "Alias",
    Default = "",
    Callback = function(value)
        print("Alias:", value)
    end,
})

inputs:Dropdown({
    Name = "Theme",
    Items = { "Violet", "Graphite", "Midnight" },
    Callback = function(value)
        print("Theme:", value)
    end,
})

inputs:Colorpicker({
    Name = "Accent color",
    DefaultColor = Color3.fromRGB(132, 65, 232),
    Callback = function(color)
        print("Accent color:", color)
    end,
})

local settings = Window:Tab({
    Name = "Settings",
    Icon = "rbxassetid://10734950309",
})

local behavior = settings:Section({ Name = "Behavior" })
behavior:Keybind({
    Name = "Quick notification",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        Vision:Notify({
            Name = "Keybind pressed",
            Text = tostring(key.Name),
            Duration = 2,
        })
    end,
})

behavior:Button({
    Name = "Reset to default theme",
    Callback = function()
        Vision:SetTheme({})
        Vision:Notify({
            Name = "Theme reset",
            Text = "Vision v2 is using its default violet theme.",
            Duration = 3,
        })
    end,
})

home:Activate()
return Window
