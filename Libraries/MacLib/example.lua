-- MacLib example
-- Preserved usage example for the MacLib UI library.
local MacLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/MacLib/source.lua"
))()

local Window = MacLib:Window({
    Title = "MacLib Showcase",
    Subtitle = "A compact macOS-inspired Roblox UI library",
    Size = UDim2.fromOffset(868, 650),
    DragStyle = 1,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
    ShowUserInfo = true,
})

Window:GlobalSetting({
    Name = "UI Blur",
    Default = Window:GetAcrylicBlurState(),
    Callback = function(enabled)
        Window:SetAcrylicBlurState(enabled)
        Window:Notify({
            Title = Window.Settings.Title,
            Description = (enabled and "Enabled" or "Disabled") .. " UI Blur",
            Lifetime = 3,
        })
    end,
})

local group = Window:TabGroup()
local mainTab = group:Tab({ Name = "Demo", Image = "rbxassetid://18821914323" })
local settingsTab = group:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" })
local main = mainTab:Section({ Side = "Left" })
local right = mainTab:Section({ Side = "Right" })

main:Header({ Name = "Controls" })
main:Button({
    Name = "Show notification",
    Callback = function()
        Window:Notify({
            Title = "MacLib",
            Description = "The callback was executed successfully.",
            Lifetime = 3,
        })
    end,
})
main:Toggle({
    Name = "Enabled",
    Default = true,
    Callback = function(value)
        print("Enabled:", value)
    end,
}, "Enabled")
main:Slider({
    Name = "Opacity",
    Default = 75,
    Minimum = 0,
    Maximum = 100,
    DisplayMethod = "Percent",
    Precision = 0,
    Callback = function(value)
        print("Opacity:", value)
    end,
}, "Opacity")
main:Dropdown({
    Name = "Theme",
    Options = { "Graphite", "Silver", "Midnight" },
    Default = 1,
    Required = true,
    Callback = function(value)
        print("Theme:", value)
    end,
}, "Theme")

right:Header({ Name = "Inputs" })
right:Input({
    Name = "Alias",
    Placeholder = "Type an alias",
    AcceptedCharacters = "All",
    Callback = function(value)
        Window:Notify({
            Title = "Alias updated",
            Description = value == "" and "No alias provided." or value,
            Lifetime = 3,
        })
    end,
}, "Alias")
right:Colorpicker({
    Name = "Accent color",
    Default = Color3.fromRGB(0, 200, 255),
    Callback = function(color)
        print("Accent color:", color)
    end,
}, "AccentColor")
right:Keybind({
    Name = "Quick notification",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        Window:Notify({
            Title = "Keybind pressed",
            Description = tostring(key.Name),
            Lifetime = 2,
        })
    end,
}, "QuickNotification")
right:Paragraph({
    Header = "MacLib",
    Body = "A reusable window, tab, section, and control API with notifications and configuration helpers.",
})

MacLib:SetFolder("MacLib")
settingsTab:InsertConfigSection("Left")
mainTab:Select()
