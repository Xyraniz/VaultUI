local LIB_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Weave/source.lua"
local Weave = loadstring(game:HttpGet(LIB_URL))()

local Window = Weave:CreateWindow({
	Name = "Weave Example",
	Title = "Weave",
	Subtitle = "API showcase",
	ToggleKey = "RightShift",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "VaultUI",
		FileName = "WeaveExample",
	},
})

local Dashboard = Window:CreateTab("Dashboard", "eye")
local Controls = Window:CreateTab("Controls", "settings", { "Inputs", "Appearance" })
local About = Window:CreateTab("About", "file")

Dashboard:CreateSection({ Name = "Welcome" }):CreateParagraph({
	Title = "Weave",
	Content = "A compact dark UI library with animated navigation, controls, configuration saving, and a key system.",
})

local status = Dashboard:CreateLabel({ Name = "Ready" })
Dashboard:CreateButton({
	Name = "Send notification",
	Callback = function()
		Weave:Notify({
			Title = "Weave",
			Content = "The callback is working.",
			Duration = 3,
		})
	end,
})

local inputSection = Controls:CreateSection({ Name = "Inputs", Subtab = "Inputs" })
inputSection:CreateToggle({
	Name = "Enable feature",
	Flag = "EnableFeature",
	CurrentValue = true,
	Callback = function(value)
		status:Set(value and "Feature enabled" or "Feature disabled")
	end,
})
inputSection:CreateSlider({
	Name = "Intensity",
	Flag = "Intensity",
	Range = { 0, 100 },
	Increment = 1,
	CurrentValue = 50,
	Callback = function(value)
		status:Set("Intensity: " .. tostring(value))
	end,
})
inputSection:CreateDropdown({
	Name = "Mode",
	Flag = "Mode",
	Options = { "Balanced", "Performance", "Quality" },
	CurrentOption = "Balanced",
	Callback = function(value) end,
})
inputSection:CreateInput({
	Name = "Profile name",
	Flag = "ProfileName",
	CurrentValue = "Player",
	PlaceholderText = "Enter a name",
	Callback = function(value) end,
})
inputSection:CreateKeybind({
	Name = "Action key",
	Flag = "ActionKey",
	CurrentKeybind = "RightShift",
	Callback = function(key) end,
})

local appearanceSection = Controls:CreateSection({ Name = "Appearance", Subtab = "Appearance" })
appearanceSection:CreateColorPicker({
	Name = "Accent color",
	Flag = "AccentColor",
	Color = Color3.fromRGB(215, 96, 20),
	Callback = function(color) end,
})
appearanceSection:CreateLabel({ Name = "Theme controls are saved with the configuration." })
appearanceSection:CreateDivider()

About:CreateParagraph({
	Title = "Preserved source",
	Content = "This example is part of VaultUI. Weave keeps the original dark orange visual language while exposing a reusable Roblox library API.",
})
About:CreateButton({
	Name = "Save configuration",
	Callback = function()
		Window:SaveConfiguration()
	end,
})
About:CreateButton({
	Name = "Load configuration",
	Callback = function()
		Window:LoadConfiguration()
	end,
})

-- Window:Hide(), Window:Show(), Window:Toggle(), Window:SetTitle(),
-- Window:SetSubtitle(), Window:SetToggleKey(), and Window:Destroy() are
-- also available when the host script needs lifecycle control.
