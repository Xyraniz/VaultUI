-- Nexonix / VaultUI showcase
-- Nexonix now returns its library table so it can be consumed normally.

local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Nexonix/source.lua"
local Nexonix = loadstring(game:HttpGet(SOURCE))()

assert(type(Nexonix) == "table", "Nexonix did not return a library table")

local Window = Nexonix:Window({})
local Dashboard = Window:Page({
    Name = "Dashboard",
    Icon = "100050851789190",
    Columns = 2,
})

local Controls = Dashboard:Section({
    Name = "Controls",
    Side = 1,
})

local Preview = Dashboard:Section({
    Name = "Preview",
    Side = 2,
})

Controls:Label({
    Name = "Nexonix is ready",
    Tooltip = "Reusable UI library showcase",
})

local Enabled = Controls:Toggle({
    Name = "Enable feature",
    Flag = "NexonixEnabled",
    Default = true,
    Callback = function(value)
        Nexonix:Notification("Feature " .. (value and "enabled" or "disabled"), 2)
    end,
})

Controls:Button({
    Name = "Send notification",
    Callback = function()
        Nexonix:Notification("Nexonix callback executed", 2)
    end,
})

local Intensity = Controls:Slider({
    Name = "Intensity",
    Flag = "NexonixIntensity",
    Min = 0,
    Max = 100,
    Default = 60,
    Suffix = "%",
    Decimals = 0,
    Callback = function(value)
        print("Intensity:", value)
    end,
})

local Profile = Controls:Dropdown({
    Name = "Profile",
    Flag = "NexonixProfile",
    Items = { "Default", "Competitive", "Minimal" },
    Default = "Default",
    Callback = function(value)
        print("Profile:", value)
    end,
})

local Message = Controls:Textbox({
    Name = "Message",
    Flag = "NexonixMessage",
    Placeholder = "Write a message",
    Finished = true,
    Callback = function(value)
        print("Message:", value)
    end,
})

Preview:Label({
    Name = "Read current values",
})

Preview:Button({
    Name = "Print state",
    Callback = function()
        print("Enabled:", Enabled.Value)
        print("Intensity:", Intensity.Value)
        print("Profile:", Profile.Value)
        print("Message:", Message.Value)
    end,
})

return Window
