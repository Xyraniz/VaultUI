-- IdkThisOne / VaultUI showcase
-- Preserved as a reusable Roblox UI library with its original API.
local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/IdkThisOne/source.lua"
local Library = loadstring(game:HttpGet(SOURCE))()

Library.MenuKeybind = tostring(Enum.KeyCode.RightShift)
local Window = Library:Window({
    Size = UDim2.new(0, 681, 0, 480),
    FadeSpeed = 0.2,
})

local home = Window:Page({
    Icon = "109391165290124",
    Search = true,
})
local homeTab = home:SubPage({ Name = "Home" })
local controls = homeTab:Section({ Name = "Controls", Side = "Left" })

controls:Button({
    Name = "Show notification",
    Callback = function()
        Library:Notification("IdkThisOne", "The callback was executed successfully.", 4)
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

local inputs = homeTab:Section({ Name = "Inputs", Side = "Right" })
inputs:Textbox({
    Name = "Alias",
    Default = "VaultUI",
    Placeholder = "Enter an alias",
    Callback = function(value)
        print("Alias:", value)
    end,
})

inputs:Dropdown({
    Name = "Theme",
    Items = { "Default", "Midnight", "Amber" },
    Default = "Default",
    Callback = function(value)
        print("Theme:", value)
    end,
})

inputs:Keybind({
    Name = "Quick notification",
    Default = Enum.KeyCode.F,
    Mode = "Toggle",
    Callback = function(value)
        print("Quick notification:", value)
    end,
})

local appearance = Window:Page({ Icon = "10734950309" })
local appearanceTab = appearance:SubPage({ Name = "Appearance" })
local colors = appearanceTab:Section({ Name = "Colors", Side = "Left" })
colors:Toggle({
    Name = "Accent color",
    Default = true,
}):Colorpicker({
    Name = "Accent color",
    Default = Color3.fromRGB(181, 116, 16),
    Callback = function(color)
        print("Accent color:", color)
    end,
})

homeTab:Turn(true)
return Window
