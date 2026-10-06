-- Nexonix / VaultUI showcase
-- Larger page icons with real Roblox image assets and a separate icon for every tab.

local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Nexonix/source.lua"
local Nexonix = loadstring(game:HttpGet(SOURCE))()

assert(type(Nexonix) == "table", "Nexonix did not return a library table")

local Assets = {
    Logo = "rbxassetid://7733799901",       -- gamepad
    Home = "rbxassetid://7733960981",       -- home
    Controls = "rbxassetid://7734053495",   -- settings
    Preview = "rbxassetid://7733964126",    -- image
    About = "rbxassetid://7733914390",      -- book
}

local Window = Nexonix:Window({
    Logo = Assets.Logo,
})

local Dashboard = Window:Page({
    Name = "Dashboard",
    Icon = Assets.Home,
    Columns = 2,
})

local ControlsPage = Window:Page({
    Name = "Controls",
    Icon = Assets.Controls,
    Columns = 2,
})

local PreviewPage = Window:Page({
    Name = "Preview",
    Icon = Assets.Preview,
    Columns = 2,
})

local AboutPage = Window:Page({
    Name = "About",
    Icon = Assets.About,
    Columns = 1,
})

local Overview = Dashboard:Section({
    Name = "Overview",
    Side = 1,
})

local Status = Dashboard:Section({
    Name = "Status",
    Side = 2,
})

Overview:Label({
    Name = "Nexonix is ready",
    Tooltip = "The library loaded and all four icon tabs are available.",
})

Overview:Button({
    Name = "Send notification",
    Callback = function()
        Nexonix:Notification("Nexonix callback executed", 2)
    end,
})

local Enabled = Overview:Toggle({
    Name = "Enable feature",
    Flag = "NexonixEnabled",
    Default = true,
    Callback = function(value)
        Nexonix:Notification("Feature " .. (value and "enabled" or "disabled"), 2)
    end,
})

Status:Label({
    Name = "Tab icons use Roblox image assets",
    Tooltip = "The page icon size is set in the library source.",
})

Status:Button({
    Name = "Print current state",
    Callback = function()
        print("Enabled:", Enabled.Value)
    end,
})

local Adjustments = ControlsPage:Section({
    Name = "Adjustments",
    Side = 1,
})

local Options = ControlsPage:Section({
    Name = "Options",
    Side = 2,
})

local Intensity = Adjustments:Slider({
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

local Profile = Options:Dropdown({
    Name = "Profile",
    Flag = "NexonixProfile",
    Items = { "Default", "Competitive", "Minimal" },
    Default = "Default",
    Callback = function(value)
        print("Profile:", value)
    end,
})

local Message = Options:Textbox({
    Name = "Message",
    Flag = "NexonixMessage",
    Placeholder = "Write a message",
    Finished = true,
    Callback = function(value)
        print("Message:", value)
    end,
})

local Gallery = PreviewPage:Section({
    Name = "Asset preview",
    Side = 1,
})

Gallery:Label({
    Name = "Roblox hosted icon assets",
    Tooltip = "These same assets are used in the sidebar tabs and window logo.",
})

Gallery:Button({
    Name = "Show preview notification",
    Callback = function()
        Nexonix:Notification("Preview tab is working", 2)
    end,
})

local Notes = AboutPage:Section({
    Name = "About this example",
    Side = 1,
})

Notes:Label({
    Name = "Four pages with distinct image icons",
    Tooltip = "Dashboard, Controls, Preview, and About.",
})

Notes:Label({
    Name = "Icon assets are configurable",
    Tooltip = "Change the asset IDs in the Assets table at the top.",
})

Notes:Button({
    Name = "Print demo values",
    Callback = function()
        print("Enabled:", Enabled.Value)
        print("Intensity:", Intensity.Value)
        print("Profile:", Profile.Value)
        print("Message:", Message.Value)
    end,
})

return Window
