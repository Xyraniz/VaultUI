-- Concorde / VaultUI showcase
-- Demonstrates the public API without enabling optional ESP/config persistence.

local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Concorde/source.lua"
local Concorde = loadstring(game:HttpGet(SOURCE))()

local Window = Concorde.new({
    Subtitle = "A precise Roblox interface library",
    Accent = Color3.fromRGB(229, 72, 93),
    Background = Color3.fromRGB(11, 12, 16),
    Sidebar = Color3.fromRGB(14, 15, 20),
    Keybind = Enum.KeyCode.RightShift,
})

local Overview, Settings = Window:AddTab("home", "Overview"):AddSubPage("Controls")
local Display, Advanced = Window:AddTab("sliders-horizontal", "Settings"):AddSubPage("Appearance")

Window:Title("Concorde controls", Overview)
Window:Toggle("Enable notifications", true, Overview, {
    callback = function(enabled)
        Window.Notify(enabled and "Notifications enabled" or "Notifications disabled")
    end,
})
Window:Slider("Opacity", "%", Overview, 0, 100, 85, function(value)
    print("Opacity:", value)
end)
Window:Dropdown("Profile", "Default", { "Default", "Competitive", "Minimal" }, Overview, function(profile)
    print("Profile:", profile)
end)
Window:Button("Send notification", Overview, function()
    Window.Notify("Concorde is ready")
end)

Window:Title("Appearance", Display)
Window:ColorTile("Accent color", Color3.fromRGB(229, 72, 93), Display, function(color)
    print("Accent color:", color)
end)
Window:RangeSlider("Visible distance", "m", Display, 0, 500, 25, 150, function(low, high)
    print("Distance:", low, high)
end)
Window:TextBox("Type a message", Display, function(text)
    Window.Notify(text)
end)

-- The returned object can be used for additional tabs and custom callbacks.
return Window
