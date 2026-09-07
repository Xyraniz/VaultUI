-- Mentality / VaultUI showcase
-- The source already exposes a reusable library API; this example exercises it.

local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Mentality/source.lua"
local Mentality = loadstring(game:HttpGet(SOURCE))()

local Window = Mentality:Window({
    Name = "Mentality",
    SubName = "VaultUI component showcase",
    Logo = "100050851789190",
})

local Controls = Window:Page({
    Name = "Controls",
    Icon = "100050851789190",
    Columns = 2,
})

local General = Controls:Section({
    Name = "General",
    Description = "Core controls and callbacks",
    Side = 1,
})

local Preview = Controls:Section({
    Name = "Preview",
    Description = "Live values from the component API",
    Side = 2,
})

General:Label("Mentality is ready")

local Enabled = General:Toggle({
    Name = "Enable feature",
    Flag = "MentalityEnabled",
    Default = true,
    Callback = function(value)
        Mentality:Notification({
            Title = "Feature state",
            Description = value and "Enabled" or "Disabled",
        })
    end,
})

General:Button({
    Name = "Send notification",
    Callback = function()
        Mentality:Notification({
            Title = "Mentality",
            Description = "The callback was executed successfully.",
        })
    end,
})

local Intensity = General:Slider({
    Name = "Intensity",
    Flag = "MentalityIntensity",
    Min = 0,
    Max = 100,
    Default = 60,
    Suffix = "%",
    Decimals = 0,
    Callback = function(value)
        print("Intensity:", value)
    end,
})

local Profile = General:Dropdown({
    Name = "Profile",
    Flag = "MentalityProfile",
    Items = { "Default", "Competitive", "Minimal" },
    Default = "Default",
    Callback = function(value)
        print("Profile:", value)
    end,
})

local Message = General:Textbox({
    Flag = "MentalityMessage",
    Placeholder = "Write a message",
    Finished = true,
    Callback = function(value)
        print("Message:", value)
    end,
})

Preview:Label("Use Get() to read the current state")
Preview:Button({
    Name = "Print current values",
    Callback = function()
        print("Enabled:", Enabled:Get())
        print("Intensity:", Intensity:Get())
        print("Profile:", Profile:Get())
        print("Message:", Message:Get())
    end,
})

Window:Init()
return Window
