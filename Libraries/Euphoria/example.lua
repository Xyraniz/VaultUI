-- Euphoria / VaultUI showcase
-- Demonstrates the library, tab, module, and direct control APIs.

local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Euphoria/source.lua"
local Euphoria = loadstring(game:HttpGet(SOURCE))()

assert(type(Euphoria) == "table", "Euphoria did not return a library table")

local Library = Euphoria:init("Euphoria Showcase")
local Dashboard = Library:create_tab("Dashboard", "rbxassetid://10734950326")

local CurrentIntensity = 60
local CurrentMessage = ""
local CurrentProfile = "Default"

Dashboard:create_divider("Overview")
Dashboard:create_button({
    title = "Send notification",
    callback = function()
        Library:notify({
            title = "Euphoria",
            content = "The callback executed successfully.",
            duration = 2,
            notify_type = "normal",
        })
    end,
})

Dashboard:create_slider({
    title = "Intensity",
    minimum = 0,
    maximum = 100,
    default = CurrentIntensity,
    rounding = 0,
    callback = function(value)
        CurrentIntensity = value
        print("Intensity:", value)
    end,
})

Dashboard:create_textbox({
    title = "Message",
    placeholder = "Write a message",
    callback = function(value)
        CurrentMessage = value
        print("Message:", value)
    end,
})

Dashboard:create_dropdown({
    title = "Profile",
    options = { "Default", "Competitive", "Minimal" },
    default = CurrentProfile,
    callback = function(value)
        CurrentProfile = value
        print("Profile:", value)
    end,
})

Dashboard:create_checkbox({
    title = "Enable notifications",
    default = true,
    callback = function(enabled)
        print("Notifications:", enabled)
    end,
})

local Advanced = Dashboard:create_module({
    title = "Advanced controls",
    default = false,
    callback = function(open)
        print("Advanced module:", open)
    end,
})

Advanced:create_divider("Module settings")
Advanced:create_checkbox({
    title = "Use adaptive scale",
    default = true,
    callback = function(value)
        print("Adaptive scale:", value)
    end,
})

Advanced:create_slider({
    title = "Scale",
    minimum = 0.75,
    maximum = 1.25,
    default = 1,
    rounding = 2,
    callback = function(value)
        print("Scale:", value)
    end,
})

Advanced:create_button({
    title = "Print values",
    callback = function()
        print("Intensity:", CurrentIntensity)
        print("Message:", CurrentMessage)
        print("Profile:", CurrentProfile)
    end,
})

return Library
