local SynergyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/SynergyUI/source.lua"))()

local Window = SynergyUI:CreateWindow({
    Title = "Synergy Hub",
    Subtitle = "Library example",
    Theme = "Dark",
    ToggleKey = "RightShift",
    ConfigName = "synergy_example",
})

local MainTab = Window:CreateTab("Dashboard", "LayoutDashboard")

MainTab:CreateSection("Controls")

MainTab:CreateLabel("A compact example using the core SynergyUI controls.")

MainTab:CreateToggle({
    Name = "Enable notifications",
    Flag = "Notifications",
    CurrentValue = true,
    Callback = function(value)
        print("Notifications:", value)
    end,
})

MainTab:CreateCheckBox({
    Name = "Show advanced options",
    Flag = "Advanced",
    CurrentValue = false,
    Callback = function(value)
        print("Advanced options:", value)
    end,
})

MainTab:CreateSlider({
    Name = "Panel opacity",
    Flag = "Opacity",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 68,
    Callback = function(value)
        print("Opacity:", value)
    end,
})

MainTab:CreateDropdown({
    Name = "Theme preset",
    Flag = "ThemePreset",
    Options = {"Dark", "Slate", "Ocean", "Sage"},
    CurrentOption = "Dark",
    Callback = function(value)
        Window:SetTheme(value)
    end,
})

MainTab:CreateButton({
    Name = "Run test action",
    Tooltip = "Print a confirmation to the console",
    Callback = function()
        SynergyUI:Notify({
            Message = "Action completed",
            Type = "done",
        })
    end,
})

local SettingsTab = Window:CreateTab("Settings", "Settings2")
SettingsTab:CreateSection("Window")
SettingsTab:CreateKeybind({
    Name = "Toggle key",
    Flag = "Keybind",
    CurrentKeybind = "RightShift",
})
SettingsTab:CreateColorPicker({
    Name = "Accent color",
    Flag = "AccentColor",
    Color = Color3.fromRGB(88, 166, 255),
})
