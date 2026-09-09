local LIB_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Zolar/source.lua"
local Zolar = loadstring(game:HttpGet(LIB_URL))()

local Window = Zolar:Window({
	Name = "Zolar Example",
	Icon = "layers",
	Accent = Color3.fromRGB(179, 165, 255),
})

local Home = Window:Tab({
	Name = "Home",
	Icon = "home",
})
local Controls = Home:SubTab({
	Name = "Controls",
	Icon = "sliders-horizontal",
})

local General = Controls:Section({
	Name = "General",
	Side = 1,
})
General:Label({ Name = "Zolar UI library showcase" })
General:Paragraph({
	Title = "Welcome",
	Content = "A clean example of Zolar's fluent API.",
})
local Enabled = General:Toggle({
	Name = "Enable feature",
	Flag = "Enabled",
	Default = true,
	Callback = function(value) end,
})
Enabled:Colorpicker({
	Name = "Feature color",
	Flag = "FeatureColor",
	Default = Color3.fromRGB(179, 165, 255),
	Callback = function(color, alpha) end,
})
Enabled:Keybind({
	Name = "Feature key",
	Flag = "FeatureKey",
	Default = Enum.KeyCode.RightShift,
	Callback = function(value) end,
})

local Values = Controls:Section({
	Name = "Values",
	Side = 2,
})
Values:Slider({
	Name = "Intensity",
	Flag = "Intensity",
	Min = 0,
	Max = 100,
	Default = 50,
	Decimals = 1,
	Suffix = "%",
	Callback = function(value) end,
})
Values:Dropdown({
	Name = "Mode",
	Flag = "Mode",
	Items = { "Balanced", "Performance", "Quality" },
	Default = "Balanced",
	Callback = function(value) end,
})
Values:Textbox({
	Name = "Profile name",
	Placeholder = "Type a profile name",
	Default = "Default",
	Finished = true,
	Callback = function(value) end,
})
Values:Button({
	Name = "Show notification",
	Callback = function()
		Zolar:Notification({
			Title = "Zolar",
			Content = "The notification API is working.",
			Duration = 3,
		})
	end,
})

local Appearance = Window:Tab({
	Name = "Appearance",
	Icon = "palette",
})
local Theme = Appearance:SubTab({
	Name = "Theme",
	Icon = "paintbrush",
})
local ThemeSection = Theme:Section({
	Name = "Theme controls",
	Side = 1,
})
ThemeSection:Colorpicker({
	Name = "Accent",
	Default = Color3.fromRGB(179, 165, 255),
	Callback = function(color, alpha)
		Zolar:SetAccent(color)
	end,
})
ThemeSection:Label({ Name = "Config and watermark APIs are also available." })

local Watermark = Zolar:Watermark({
	Name = "Zolar Example",
	Icon = "layers",
})

-- Lifecycle and persistence helpers include:
-- Zolar:Unload(), Zolar:SaveConfigFile("example"),
-- Zolar:LoadConfigFile("example"), and Watermark:SetVisible(false).
