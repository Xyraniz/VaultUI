-- Winware / VaultUI showcase
-- Author: wxnvxa | License: MIT
-- Original repository: https://github.com/wxnvxa/winware-lib
local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Winware/source.lua"
local WinWare = loadstring(game:HttpGet(SOURCE))()

WinWare.AccentColor = Color3.fromRGB(0, 86, 255)
WinWare.MenuKeybind = Enum.KeyCode.RightShift

local Window = WinWare:CreateWindow({
    Name = "Winware Showcase",
    Content = "VaultUI example",
    Size = WinWare.Scales.Default,
    Keybind = WinWare.MenuKeybind,
    ConfigFolder = "WinwareVaultUI",
})

local mainTab = Window:AddTab({
    Name = "Home",
    Icon = "home",
})

local controls = mainTab:AddSection({
    Name = "Controls",
    Position = "left",
})

controls:AddButton({
    Name = "Show notification",
    Icon = "bell",
    Callback = function()
        WinWare:CreateNotification().new({
            Title = "Winware",
            Content = "The callback was executed successfully.",
            Duration = 4,
        })
    end,
})

controls:AddLabel("Enabled"):AddToggle({
    Default = true,
    Callback = function(value)
        print("Enabled:", value)
    end,
})

controls:AddLabel("Opacity"):AddSlider({
    Min = 0,
    Max = 100,
    Default = 75,
    Type = "%",
    Callback = function(value)
        print("Opacity:", value)
    end,
})

local inputs = mainTab:AddSection({
    Name = "Inputs",
    Position = "right",
})

inputs:AddLabel("Theme"):AddDropdown({
    Values = { "Default", "Midnight", "Ocean" },
    Default = "Default",
    Callback = function(value)
        print("Theme:", value)
    end,
})

inputs:AddLabel("Alias"):AddTextInput({
    Default = "VaultUI",
    Placeholder = "Enter an alias",
    Callback = function(value)
        print("Alias:", value)
    end,
})

inputs:AddLabel("Quick notification"):AddKeybind({
    Default = Enum.KeyCode.F,
    Callback = function(value)
        print("Quick notification key:", value)
        WinWare:CreateLogger().new("bell", "Keybind pressed", 3)
    end,
})

local appearance = Window:AddTab({
    Name = "Appearance",
    Icon = "palette",
})

local colors = appearance:AddSection({
    Name = "Theme",
    Position = "left",
})

colors:AddLabel("Accent color"):AddColorPicker({
    Default = Color3.fromRGB(0, 86, 255),
    Callback = function(color)
        WinWare:SetAccentColor(color)
    end,
})

Window:AddLibrarySettings({
    Name = "Settings",
    Config = true,
    Blur = true,
    Watermark = false,
})

return Window
