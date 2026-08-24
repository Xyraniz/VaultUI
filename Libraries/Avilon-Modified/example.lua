-- Avilon-Modified / VaultUI
-- Test script using the API exposed by source.lua

local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/refs/heads/main/Libraries/Avilon-Modified/source.lua"

local loaded, Library = pcall(function()
    local chunk = loadstring(game:HttpGet(SOURCE))
    assert(type(chunk) == "function", "source.lua did not return an executable chunk")
    return chunk()
end)

if not loaded then
    error(("[Avilon] Could not load source.lua: %s"):format(tostring(Library)), 0)
end

assert(type(Library) == "table", "[Avilon] source.lua did not return the library")

local Window
local Status
local ActiveToggle
local PulseCount = 0

Window = Library:Window({
    Name = "VaultUI",
    SubName = "Avilon",
    ThemePreset = "Emerald",
    Size = UDim2.fromOffset(900, 570),
    BackgroundStrength = 0.28,
    TabsBackgroundStrength = 0.22,
    ShowGrid = false
})

local Diagnostics = Window:Page({
    Name = "Diagnostics"
})

local Controls = Diagnostics:SubPage({
    Name = "Controls",
    Description = "Values, states and callbacks"
})

local Left = Controls:Section({
    Name = "Status",
    Description = "Received events",
    Side = 1
})

local Right = Controls:Section({
    Name = "Parameters",
    Description = "Interactive controls",
    Side = 2
})

Status = Left:Label({
    Name = "Status"
})
Status:SetText("Ready")

ActiveToggle = Left:Toggle({
    Name = "Active process",
    Flag = "ActiveProcess",
    Default = true,
    Callback = function(Value)
        Status:SetText(Value and "Active process" or "Process stopped")
    end
})

Left:Button({
    Name = "Log event",
    Callback = function()
        PulseCount += 1
        Status:SetText(("Logged events: %d"):format(PulseCount))
    end
})

Left:Button({
    Name = "Reset status",
    Callback = function()
        PulseCount = 0
        ActiveToggle:Set(true)
        Status:SetText("Status reset")
    end
})

local Mode = Right:Dropdown({
    Name = "Read mode",
    Flag = "ReadMode",
    Items = {
        "Automatic",
        "Manual",
        "Supervision"
    },
    Default = "Automatic",
    Callback = function(Value)
        Status:SetText(("Mode: %s"):format(tostring(Value)))
    end
})

local Channels = Right:Dropdown({
    Name = "Channels",
    Flag = "Channels",
    Items = {
        "Input",
        "Output",
        "Events"
    },
    Multi = true,
    Default = {
        "Input",
        "Events"
    },
    Callback = function(Value)
        Status:SetText(("Channels: %s"):format(table.concat(Value, ", ")))
    end
})

local Threshold = Right:Slider({
    Name = "Threshold",
    Flag = "Threshold",
    Min = 0,
    Max = 100,
    Default = 65,
    Decimals = 0,
    Suffix = "%",
    Callback = function(Value)
        Status:SetText(("Threshold: %d%%"):format(Value))
    end
})

local Identifier = Right:Textbox({
    Name = "Identifier",
    Flag = "Identifier",
    Default = "session-01",
    Placeholder = "Enter an identifier",
    Finished = false,
    Callback = function(Value)
        if Value ~= "" then
            Status:SetText(("Identifier: %s"):format(Value))
        end
    end
})

local Accent = Right:Colorpicker({
    Name = "Accent color",
    Flag = "AccentColor",
    Default = Color3.fromRGB(46, 204, 113),
    Callback = function(Value)
        Window:SetTheme({
            Accent = Value
        })
    end
})

local KeybindLabel = Right:Label({
    Name = "Toggle process"
})

local ProcessKeybind = KeybindLabel:Keybind({
    Name = "Toggle process",
    Flag = "ToggleProcess",
    Default = Enum.KeyCode.G,
    Mode = "Toggle",
    Callback = function(Value)
        ActiveToggle:Set(Value)
    end
})

-- The bind runs its callback on initialization; the initial state is left active.
ActiveToggle:Set(true)

local WindowPage = Window:Page({
    Name = "Window"
})

local WindowControls = WindowPage:SubPage({
    Name = "Actions",
    Description = "Public window methods"
})

local WindowSection = WindowControls:Section({
    Name = "Appearance",
    Description = "Changes applied instantly",
    Side = 1
})

WindowSection:Toggle({
    Name = "Background grid",
    Flag = "Grid",
    Default = false,
    Callback = function(Value)
        Window:SetGrid(Value, 0.84)
    end
})

WindowSection:Slider({
    Name = "Background strength",
    Flag = "BackgroundStrength",
    Min = 0,
    Max = 100,
    Default = 28,
    Decimals = 0,
    Suffix = "%",
    Callback = function(Value)
        Window:SetBackgroundStrength(Value / 100, 0.22)
    end
})

WindowSection:Button({
    Name = "Center window",
    Callback = function()
        Window:Center()
    end
})

WindowSection:Button({
    Name = "Hide window",
    Callback = function()
        Window:SetOpen(false)
    end
})

local ThemeSection = WindowControls:Section({
    Name = "Theme",
    Description = "Presets included in the library",
    Side = 2
})

ThemeSection:Button({
    Name = "Emerald theme",
    Callback = function()
        Window:SetTheme({Preset = "Emerald"})
    end
})

ThemeSection:Button({
    Name = "Rose theme",
    Callback = function()
        Window:SetTheme({Preset = "Rose"})
    end
})

ThemeSection:Button({
    Name = "Dark theme",
    Callback = function()
        Window:SetTheme({Preset = "Dark"})
    end
})

-- This page uses the settings function exposed by the library itself.
Library:CreateSettingsPage()

-- CreateSettingsPage initialises its bind to None; it is set afterwards so that RightShift
-- controls the window independently of the settings page.
Library.MenuKeybind = "Enum.KeyCode.RightShift"

Window:SetOpen(true)
Window:Center()

return {
    Library = Library,
    Window = Window,
    Controls = Controls,
    Mode = Mode,
    Channels = Channels,
    Threshold = Threshold,
    Identifier = Identifier,
    Accent = Accent,
    ProcessKeybind = ProcessKeybind
}
