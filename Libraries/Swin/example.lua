-- Swin example: exercises the public Window, Tab, Section and control APIs.
-- Source: https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Swin/source.lua

local Swin = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Swin/source.lua"))()

local Window = Swin:Window({
    Name = "Swin Example",
    Size = UDim2.fromOffset(760, 520),
    Amount = 4,
})

local Overview = Window:Tab({ Name = "Overview", Icon = "home" })
local Settings = Window:Tab({ Name = "Settings", Icon = "settings" })

local Controls = Overview:Section({ Name = "Controls", Side = "Left" })
Controls:Label({ Name = "Swin reusable UI library" })
Controls:Button({
    Name = "Show notification",
    Callback = function()
        Swin:Notification("Swin is working.", 3)
    end,
})
Controls:Toggle({
    Name = "Enable feature",
    Flag = "example_enabled",
    Default = true,
    Callback = function(enabled)
        print("Swin toggle:", enabled)
    end,
})
Controls:Slider({
    Name = "Intensity",
    Flag = "example_intensity",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Swin slider:", value)
    end,
})
Controls:Dropdown({
    Name = "Profile",
    Flag = "example_profile",
    Options = { "Balanced", "Performance", "Quality" },
    Default = "Balanced",
    Callback = function(value)
        print("Swin profile:", value)
    end,
})

local Appearance = Settings:Section({ Name = "Appearance", Side = "Right" })
Appearance:Textbox({
    Name = "Workspace label",
    Flag = "workspace_label",
    Placeholder = "Enter a label",
    Callback = function(value)
        print("Workspace label:", value)
    end,
})
Appearance:Keybind({
    Name = "Quick notification",
    Flag = "quick_notification",
    Default = Enum.KeyCode.K,
    Callback = function()
        Swin:Notification("Quick action triggered.", 2)
    end,
})
Appearance:Divider({})
Appearance:Label({ Name = "Press the configured key to test the callback." })

Window:Watermark()
Swin:Notification("Swin Example loaded.", 3)

return Window
