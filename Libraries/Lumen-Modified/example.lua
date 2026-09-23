-- Lumen Modified example: public API coverage.
-- Source: https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Lumen-Modified/source.lua

local LumenModified = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Lumen-Modified/source.lua"
))()

local Window = LumenModified:Window({
    Title = "Lumen Modified Showcase",
    Footer = "VaultUI / Lumen Modified",
    Logo = 10734910430,
})

local Dashboard = Window:Page({ Icon = 10723407389 })
local Settings = Window:Page({ Icon = 10734950309 })
local Controls = Dashboard:SubPage({ Name = "Controls" })
local Preferences = Settings:SubPage({ Name = "Preferences" })

local Main = Controls:Section({
    Name = "Main controls",
    Side = "Left",
    Icon = 10709782497,
})

Main:Label({ Text = "Lumen Modified is a single-file Roblox UI library." }):Toggle({
    State = true,
    Callback = function(value)
        print("Lumen Modified enabled:", value)
    end,
})

Main:Slider({
    Name = "Intensity",
    Suffix = "%",
    Value = 65,
    Min = 0,
    Max = 100,
    Increment = 1,
    Callback = function(value)
        print("Intensity:", value)
    end,
})

Main:Dropdown({
    Name = "Profile",
    Options = { "Balanced", "Performance", "Quality" },
    Value = "Balanced",
    Callback = function(value)
        print("Profile:", value)
    end,
})

Main:Button({
    Name = "Show notification",
    Callback = function()
        LumenModified.Notify({
            Title = "Lumen Modified",
            Content = "The single-file library is working.",
            Type = "Success",
            Duration = 3,
        })
    end,
})

local Appearance = Controls:Section({
    Name = "Appearance",
    Side = "Right",
    Icon = 10734910430,
})
Appearance:Colorpicker({
    Name = "Accent",
    Color = Color3.fromRGB(138, 156, 229),
    Transparency = 0,
    Callback = function(color)
        print("Accent:", color)
    end,
})

local General = Preferences:Section({
    Name = "General",
    Side = "Left",
    Icon = 10734950309,
})
General:Input({
    Name = "Workspace",
    Value = "VaultUI",
    Placeholder = "Workspace name",
    Callback = function(value)
        print("Workspace:", value)
    end,
})
General:Keybind({
    Name = "Toggle menu",
    Key = Enum.KeyCode.LeftAlt,
    Type = "Toggle",
    Callback = function(value)
        print("Menu state:", value)
    end,
})

LumenModified.SetWatermark("Lumen Modified", true)
LumenModified.Notify({
    Title = "Lumen Modified",
    Content = "Loaded from one source.lua file.",
    Type = "Info",
    Duration = 3,
})

return Window
