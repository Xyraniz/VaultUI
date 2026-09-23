-- Hirimi example: single-file library usage covering the public API.
-- Source: https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Hirimi/source.lua

local Hirimi = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Hirimi/source.lua"))()

local Window = Hirimi:createWindow({
    title = "Hirimi Example",
    logo = "rbxassetid://109103782993270",
    sidebar = {
        width = 160,
        searchBar = { placeholderText = "Search controls...", realTime = true },
    },
    size = { responsive = false, dragSizeable = true, scale = 0.75, realtimeResize = true },
    theme = "Light",
    acrylic = true,
    keybind = Enum.KeyCode.LeftControl,
})

local Main = Window:addGroup({ title = "Main", collapsible = false })
local Options = Window:addGroup({ title = "Options", collapsible = true })
local Home = Main:addTab({ title = "Home", icon = "rbxassetid://10723407389" })
local Settings = Options:addTab({ title = "Settings", icon = "rbxassetid://10734950020" })

Home:addParagraph({
    title = "Hirimi UI library",
    desc = "A bundled, single-file build with themes, controls and notifications.",
})

local enabled = Home:addToggle("enabled", {
    title = "Enable feature",
    desc = "Demonstrates a reactive toggle.",
    value = true,
})
enabled:onChanged(function(value)
    print("Hirimi enabled:", value)
end)

local intensity = Home:addSlider("intensity", {
    title = "Intensity",
    desc = "Choose a value from 1 to 100.",
    min = 1,
    max = 100,
    step = 1,
    value = 50,
})
intensity:onChanged(function(value)
    print("Hirimi intensity:", value)
end)

Home:addDropdown("profile", {
    title = "Profile",
    desc = "Select the active profile.",
    options = { "Balanced", "Performance", "Quality" },
    value = "Balanced",
}):onChanged(function(value)
    print("Hirimi profile:", value)
end)

Home:addButton({
    title = "Show notification",
    callback = function()
        Hirimi:notify({
            title = "Hirimi",
            desc = "The bundled library is working.",
            duration = 3,
        })
    end,
})

Settings:addInput("workspace", {
    title = "Workspace label",
    desc = "Store a label for this session.",
    placeHolder = "Enter a label...",
    value = "VaultUI",
}):onChanged(function(value)
    print("Workspace:", value)
end)

Settings:addButton({
    title = "Use light theme",
    callback = function()
        Hirimi:setTheme("Light")
    end,
})

Hirimi:notify({
    title = "Hirimi Example",
    desc = "Loaded from one source.lua file.",
    duration = 3,
})

return Window
