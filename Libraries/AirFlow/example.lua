-- AirFlow example: a small showcase that exercises the public API.
-- Source: https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/AirFlow/source.lua

local AirFlow =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/AirFlow/source.lua"))()

local Window = AirFlow.CreateWindow({
	Title = "AirFlow",
	LoadingSubtitle = "A polished, lightweight Roblox UI library",
	ToggleUIKeybind = "RightControl",
	Size = UDim2.fromOffset(640, 480),
	Loading = false,
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "AirFlow",
		FileName = "Example",
	},
})

local Elements = Window:Tab({
	Name = "Elements",
	Desc = "One of everything",
	Icon = "layout-grid",
})

Elements:Section("Example section")

Elements:Button({
	Name = "Example button",
	Desc = "A standard callback button",
	Icon = "sparkles",
	Callback = function()
		AirFlow:Notify({
			Title = "Example button",
			Content = "The callback fired successfully.",
			Type = "Success",
		})
	end,
})

Elements:Button({
	Name = "Example primary button",
	Style = "Primary",
	Callback = function()
		print("AirFlow primary button clicked")
	end,
})

Elements:Toggle({
	Name = "Example toggle",
	Desc = "A stateful boolean control",
	Flag = "ExampleToggle",
	Default = true,
	Callback = function(value)
		print("Example toggle:", value)
	end,
})

Elements:Slider({
	Name = "Example slider",
	Flag = "ExampleSlider",
	Min = 0,
	Max = 100,
	Step = 1,
	Default = 50,
	Suffix = "%",
	Callback = function(value)
		print("Example slider:", value)
	end,
})

Elements:Stepper({
	Name = "Example stepper",
	Flag = "ExampleStepper",
	Min = 0,
	Max = 10,
	Step = 1,
	Default = 5,
	Callback = function(value)
		print("Example stepper:", value)
	end,
})

Elements:Dropdown({
	Name = "Example dropdown",
	Options = { "First", "Second", "Third" },
	Default = "First",
	Callback = function(value)
		print("Example dropdown:", value)
	end,
})

Elements:Input({
	Name = "Example input",
	Desc = "Text input with a callback",
	Placeholder = "Type something",
	Default = "AirFlow",
	Callback = function(value, finished)
		print("Example input:", value, finished)
	end,
})

Elements:Keybind({
	Name = "Example keybind",
	Default = Enum.KeyCode.K,
	Callback = function(key)
		print("Example keybind:", key)
	end,
})

Elements:ColorPicker({
	Name = "Example color",
	Color = Color3.fromRGB(235, 199, 246),
	Callback = function(color)
		print("Example color:", color)
	end,
})

Elements:Progress({
	Name = "Example progress",
	Min = 0,
	Max = 100,
	Default = 0.65,
	ShowPercentage = true,
	Callback = function(value, ratio)
		print("Example progress:", value, ratio)
	end,
})

Elements:Paragraph({
	Name = "About AirFlow",
	Content = "AirFlow keeps the original interface behaviour while exposing a reusable, documented API for tabs, controls, configuration, notifications, dialogs, and window lifecycle management.",
})

Elements:Divider()
Elements:Label({ Text = "Press Right Control to toggle the window." })

AirFlow:Notify({
	Title = "AirFlow loaded",
	Content = "The example is ready.",
	Type = "Success",
	Duration = 4,
})

return Window
