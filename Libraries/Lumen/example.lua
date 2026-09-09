local Lumen = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Lumen/source.lua"
))()

local Window = Lumen:Window({
    Title = "Lumen Showcase",
    Footer = "VaultUI / Lumen",
})

local Combat = Window:Page({ Icon = 89784578844770 })
local Settings = Window:Page({ Icon = 89784578844770 })

local Aimbot = Combat:SubPage({ Name = "Aimbot" })
local AntiAim = Combat:SubPage({ Name = "Anti-Aim" })

local Main = Aimbot:Section({
    Name = "Main",
    Side = "Left",
    Icon = 107651426482528,
})

local Enabled = Main:Label({ Text = "Enable aimbot" })
Enabled:Toggle({
    State = false,
    Callback = function(state)
        print("Aimbot enabled:", state)
    end,
})
Enabled:Keybind({
    Title = "Aimbot key",
    Key = Enum.KeyCode.RightShift,
    Type = "Toggle",
    Callback = function(state)
        print("Aimbot key state:", state)
    end,
})
Enabled:Colorpicker({
    Color = Color3.fromRGB(138, 156, 229),
    Transparency = 0,
    Callback = function(color, transparency)
        print("Aimbot color:", color, transparency)
    end,
})

Main:Slider({
    Name = "Field of view",
    Suffix = "°",
    Value = 67,
    Min = 1,
    Max = 120,
    Increment = 1,
    Callback = function(value)
        print("FOV:", value)
    end,
})

Main:Dropdown({
    Name = "Target part",
    Options = { "Head", "Torso", "Random" },
    Value = "Head",
    Callback = function(value)
        print("Target part:", value)
    end,
})

local Filters = Aimbot:Section({
    Name = "Filters",
    Side = "Right",
    Icon = 107651426482528,
})

Filters:Dropdown({
    Name = "ESP features",
    Multi = true,
    Options = { "Box", "Name", "Health" },
    Value = { "Box" },
    Callback = function(values)
        print("ESP features:", table.concat(values, ", "))
    end,
})

Filters:Input({
    Name = "Discord",
    Value = "discord.gg/robloxuis",
    Placeholder = "invite link",
    Callback = function(value)
        print("Discord:", value)
    end,
})

local AntiAimSection = AntiAim:Section({
    Name = "Anti-Aim",
    Side = "Left",
    Icon = 107651426482528,
})

AntiAimSection:Label({ Text = "Choose an anti-aim profile" }):Toggle({
    State = true,
    Callback = function(state)
        print("Anti-aim enabled:", state)
    end,
})

local Preferences = Settings:SubPage({ Name = "Preferences" })
local General = Preferences:Section({
    Name = "General",
    Side = "Left",
    Icon = 107651426482528,
})

General:Input({
    Name = "Profile",
    Value = "Default",
    Placeholder = "profile name",
    Callback = function(value)
        print("Profile:", value)
    end,
})

General:Dropdown({
    Name = "Theme",
    Options = { "Midnight", "Slate", "Violet" },
    Value = "Midnight",
    Callback = function(value)
        print("Theme:", value)
    end,
})

return Window
