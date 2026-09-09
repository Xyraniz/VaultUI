local LIB_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Fluriore/source.lua"
local Fluriore = loadstring(game:HttpGet(LIB_URL))()

local Tabs = Fluriore:MakeGui({
	NameHub = "Fluriore Example",
	Description = "VaultUI showcase",
	Color = Color3.fromRGB(255, 0, 255),
	["Tab Width"] = 138,
})

local MainTab = Tabs:CreateTab({
	Name = "Overview",
	Icon = "rbxassetid://16851841101",
})

local MainSection = MainTab:AddSection("Welcome")
MainSection:AddParagraph({
	Title = "Fluriore",
	Content = "A compact dark interface with animated tabs, collapsible sections, notifications, and configurable controls.",
})
MainSection:AddButton({
	Title = "Show notification",
	Content = "Test the notification system",
	Callback = function()
		Fluriore:MakeNotify({
			Title = "Fluriore",
			Description = "Callback",
			Content = "The notification API is working.",
			Color = Color3.fromRGB(255, 0, 255),
			Delay = 3,
		})
	end,
})

local ControlsTab = Tabs:CreateTab({
	Name = "Controls",
	Icon = "rbxassetid://16851841101",
})

local Controls = ControlsTab:AddSection("Inputs")
Controls:AddToggle({
	Title = "Enable feature",
	Content = "Toggle a sample setting",
	Default = true,
	Callback = function(value) end,
})
Controls:AddSlider({
	Title = "Intensity",
	Content = "Choose a value from 0 to 100",
	Min = 0,
	Max = 100,
	Default = 50,
	Callback = function(value) end,
})
Controls:AddInput({
	Title = "Profile name",
	Content = "Enter a name for the example profile",
	Callback = function(value) end,
})
Controls:AddDropdown({
	Title = "Mode",
	Content = "Select one or more modes",
	Options = { "Balanced", "Performance", "Quality" },
	Default = { "Balanced" },
	Multi = false,
	Callback = function(value) end,
})

local Dynamic = ControlsTab:AddSection("Runtime")
local dynamicDropdown = Dynamic:AddDropdown({
	Title = "Dynamic options",
	Content = "This dropdown can be refreshed at runtime",
	Options = { "First", "Second" },
	Default = { "First" },
	Callback = function(value) end,
})
Dynamic:AddButton({
	Title = "Refresh options",
	Content = "Replace the dropdown contents",
	Callback = function()
		dynamicDropdown:Refresh({ "Updated", "Another option", "Final option" }, { "Updated" })
	end,
})

-- Returned objects also expose Set methods for live updates. For example:
-- dynamicDropdown:Set({ "Another option" })
-- dynamicDropdown:Clear()
-- Fluriore:MakeGui() returns the Tabs object; MakeNotify() returns a
-- notification object with Close() for manual dismissal.
