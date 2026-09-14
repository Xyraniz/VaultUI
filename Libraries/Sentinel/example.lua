-- Sentinel example: coverage of the original public API.
-- Source: https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Sentinel/source.lua

local Sentinel =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Sentinel/source.lua"))()

local Window = Sentinel:Window("Sentinel Example")
local Elements = Window:Tab("Elements")
local Settings = Window:Tab("Settings")

Elements:Label("Sentinel controls")

Elements:Button("Example button", function()
	print("Sentinel button clicked")
end)

Elements:Toggle("Example toggle", true, function(value)
	print("Sentinel toggle:", value)
end)

Elements:Slider("Example slider", 0, 100, 50, function(value)
	print("Sentinel slider:", value)
end)

Elements:Dropdown("Example dropdown", {
	"First option",
	"Second option",
	"Third option",
}, function(value)
	print("Sentinel dropdown:", value)
end)

Elements:KeyBind("Example keybind", Enum.KeyCode.K, function(key)
	print("Sentinel keybind:", key)
end)

Settings:Label("Settings")
Settings:Button("Refresh dropdown options", function()
	local dropdown = Settings:Dropdown("Dynamic options", { "Loading..." }, function(value)
		print("Selected:", value)
	end)

	task.delay(0.5, function()
		dropdown:RefreshDropdown({
			"Balanced",
			"Performance",
			"Quality",
		})
	end)
end)

Settings:Toggle("Enable notifications", false, function(value)
	print("Notifications:", value)
end)

return Window
