local LIB_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Midnight/source.lua"
local Midnight = loadstring(game:HttpGet(LIB_URL))()

local Window = Midnight:Window({
	Name = "Midnight Example",
})

local MainPage = Window:Page({
	Name = "Overview",
	Icon = "rbxassetid://7368471234",
	Columns = 2,
})

local Overview = MainPage:Section({
	Name = "Welcome",
	Side = 1,
})
Overview:Label("Midnight UI library showcase")
Overview:Toggle({
	Name = "Enable feature",
	Flag = "EnableFeature",
	Default = true,
	Callback = function(value) end,
})
Overview:Button():Add("Notify", function()
	Midnight:Notification("Midnight", "The notification API is working.", 3)
end)

local Settings = MainPage:Section({
	Name = "Settings",
	Side = 2,
})
Settings:Slider({
	Name = "Intensity",
	Flag = "Intensity",
	Min = 0,
	Max = 100,
	Default = 50,
	Decimals = 1,
	Suffix = "%",
	Callback = function(value) end,
})
Settings:Dropdown({
	Name = "Mode",
	Flag = "Mode",
	Items = { "Balanced", "Performance", "Quality" },
	Default = "Balanced",
	Callback = function(value) end,
})
Settings:Label("Use the RightShift key to toggle the window.")

local AdvancedPage = Window:Page({
	Name = "Advanced",
	Icon = "rbxassetid://7368471234",
	Columns = 1,
})

local Appearance = AdvancedPage:Section({
	Name = "Appearance",
	Side = 1,
})
local accent = Appearance:Toggle({
	Name = "Accent control",
	Flag = "AccentControl",
	Default = true,
	Callback = function(value) end,
})
accent:Colorpicker({
	Flag = "AccentColor",
	Default = Color3.fromRGB(0, 255, 255),
	Alpha = 1,
	Callback = function(color, alpha) end,
})
accent:Keybind({
	Flag = "AccentKeybind",
	Default = Enum.KeyCode.RightShift,
	Mode = "Toggle",
	Callback = function(value) end,
})

local Watermark = Midnight:Watermark("Midnight Example")
local KeyList = Midnight:KeybindList()

-- Window:SetOpen(false), Window:Minimize(true), Window:SetBackgroundImage(...),
-- Watermark:SetVisibility(false), KeyList:SetVisibility(false), and
-- Midnight:Unload() are available for lifecycle control.
