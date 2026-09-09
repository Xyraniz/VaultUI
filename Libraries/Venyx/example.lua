-- Venyx / VaultUI showcase
-- Preserved as a reusable Roblox UI library with its original API.
local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Venyx/source.lua"
local Venyx = loadstring(game:HttpGet(SOURCE))()

local Window = Venyx.new("Venyx Showcase")
Window:setTheme("Accent", Color3.fromRGB(34, 34, 34))

local home = Window:addPage("Home", 11396131982)
local controls = home:addSection("Controls")

controls:addButton("Show notification", function()
    Window:Notify("Venyx", "The callback was executed successfully.", function()
        print("Venyx notification closed")
    end)
end)

controls:addToggle("Enabled", true, function(value)
    print("Enabled:", value)
end)

controls:addSlider("Opacity", 75, 0, 100, function(value)
    print("Opacity:", value)
end)

local inputs = home:addSection("Inputs")
inputs:addTextbox("Alias", "VaultUI", function(value)
    print("Alias:", value)
end)

inputs:addDropdown("Theme", { "Graphite", "Midnight", "Violet" }, function(value)
    print("Theme:", value)
end)

inputs:addColorPicker("Accent color", Color3.fromRGB(132, 65, 232), function(color)
    print("Accent color:", color)
end)

local settings = Window:addPage("Settings", 10734950309)
local behavior = settings:addSection("Behavior")

behavior:addKeybind("Quick notification", Enum.KeyCode.F, function(key)
    Window:Notify("Keybind pressed", tostring(key.Name))
end, function(key)
    print("Keybind changed:", key.Name)
end)

behavior:addButton("Reset theme", function()
    Window:setTheme("Accent", Color3.fromRGB(10, 10, 10))
    Window:Notify("Theme reset", "Venyx is using its default dark accent.")
end)

Window:SelectPage(home, true)
return Window
