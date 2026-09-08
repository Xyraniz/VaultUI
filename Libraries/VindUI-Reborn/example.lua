-- VindUI-Reborn / VaultUI showcase
-- Demonstrates the public Window -> Tab -> control API.

local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/VindUI-Reborn/source.lua"
local VindUI = loadstring(game:HttpGet(SOURCE))()

assert(type(VindUI) == "table", "VindUI-Reborn did not return a library table")

VindUI:SetScaleRange(0.8, 1.15)
VindUI:SetBlurEnabled(true)

local Window = VindUI:CreateWindow({
    Size = UDim2.fromOffset(720, 500),
    ToggleKey = Enum.KeyCode.RightShift,
})
Window:SetTitle("VindUI-Reborn", "VaultUI component showcase")

local Controls = Window:AddTab({
    Name = "Controls",
    Icon = "sliders-horizontal",
})

Controls:AddLabel("A clean, searchable control surface")
Controls:AddSection({ Text = "Interaction", Icon = "mouse-pointer-2" })

local Enabled = Controls:AddToggle({
    Text = "Enable feature",
    Description = "Updates the live status card.",
    Default = true,
    Callback = function(value)
        VindUI:Notify({
            Title = "Feature state",
            Text = value and "Enabled" or "Disabled",
            Type = "info",
            Duration = 2,
        })
    end,
})

local Intensity = Controls:AddSlider({
    Text = "Intensity",
    Description = "A snapped value between 0 and 100.",
    Min = 0,
    Max = 100,
    Increment = 5,
    Default = 65,
    Suffix = "%",
    Callback = function(value)
        print("Intensity:", value)
    end,
})

local Profile = Controls:AddDropdown({
    Text = "Profile",
    Options = { "Default", "Competitive", "Minimal" },
    Default = "Default",
    Callback = function(value)
        print("Profile:", value)
    end,
})

local Message = Controls:AddTextbox({
    Text = "Message",
    Placeholder = "Write a message",
    Default = "Ready",
    Callback = function(value)
        print("Message:", value)
    end,
})

Controls:AddColorPicker({
    Text = "Accent color",
    Default = Color3.fromRGB(226, 232, 228),
    Callback = function(color)
        print("Accent color:", color)
    end,
})

Controls:AddKeybind({
    Text = "Quick action",
    Default = Enum.KeyCode.F,
    Callback = function()
        VindUI:Notify({ Title = "VindUI-Reborn", Text = "Keybind pressed", Duration = 2 })
    end,
})

Controls:AddButton({
    Text = "Print current state",
    Description = "Reads values from the returned component handles.",
    Callback = function()
        print("Enabled:", Enabled:Get())
        print("Intensity:", Intensity:Get())
        print("Profile:", Profile:Get())
        print("Message:", Message:Get())
    end,
})

local status = Controls:AddParagraph({
    Title = "Ready",
    Content = "VindUI-Reborn is loaded and searchable.",
})

return Window
