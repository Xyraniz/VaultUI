local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/refs/heads/main/Libraries/Kavo-UI/source.lua"))()

local Library = Kavo.CreateLib("Kavo Showcase", "Ocean")

local MainTab = Library:NewTab("Main")

local ActionsSection = MainTab:NewSection("Actions")

local ActionButton = ActionsSection:NewButton(
	"Run Action",
	"Fires the callback below and prints a message to the console",
	function()
	end
)

ActionsSection:NewButton(
	"Rename Action Button",
	"Demonstrates ButtonFunction:UpdateButton() changing the label at runtime",
	function()
		ActionButton:UpdateButton("Label Changed")
	end
)

local TogglesSection = MainTab:NewSection("Toggles")

TogglesSection:NewToggle(
	"Sound Feedback",
	"Prints the current state every time this is switched",
	function(state)
	end
)

local AutoRefreshToggle = TogglesSection:NewToggle(
	"Auto Refresh",
	"Starts pre-enabled via TogFunction:UpdateToggle()",
	function(state)
	end
)
AutoRefreshToggle:UpdateToggle(nil, true)

local InputSection = MainTab:NewSection("Input")

InputSection:NewTextBox(
	"Display Name",
	"Type a value and press Enter to submit it",
	function(text)
	end
)

local CustomTab = Library:NewTab("Customization")

local SlidersSection = CustomTab:NewSection("Sliders")

SlidersSection:NewSlider(
	"Opacity",
	"Drag to set a value between 0 and 100",
	100, 0,
	function(value)
	end
)

SlidersSection:NewSlider(
	"Refresh Rate",
	"Drag to set a value between 1 and 60",
	60, 1,
	function(value)
	end
)

local DropdownSection = CustomTab:NewSection("Dropdown")

local ThemeDropdown = DropdownSection:NewDropdown(
	"Interface Theme",
	"Selecting an item fires the callback with the chosen value",
	{"Ocean", "Midnight", "GrapeTheme", "BloodTheme", "Sentinel", "Serpent", "DarkTheme", "LightTheme"},
	function(selected)
	end
)

DropdownSection:NewButton(
	"Reload Dropdown Options",
	"Demonstrates DropFunction:Refresh() replacing the item list",
	function()
		ThemeDropdown:Refresh({"Ocean", "Midnight", "Synapse"})
	end
)

local ColorSection = CustomTab:NewSection("Color Picker")

ColorSection:NewColorPicker(
	"Accent Color",
	"Picking a color updates the interface's SchemeColor live",
	Color3.fromRGB(86, 76, 251),
	function(color)
		Kavo:ChangeColor("SchemeColor", color)
	end
)

local UtilTab = Library:NewTab("Utility")

local KeybindSection = UtilTab:NewSection("Keybinds")

KeybindSection:NewKeybind(
	"Toggle Interface",
	"Hides or shows the whole window using Kavo:ToggleUI()",
	Enum.KeyCode.RightControl,
	function()
		Kavo:ToggleUI()
	end
)

KeybindSection:NewKeybind(
	"Print Timestamp",
	"Prints the current time when the bound key is pressed",
	Enum.KeyCode.F,
	function()
	end
)

local HiddenSection = UtilTab:NewSection("Extra", true)

HiddenSection:NewButton(
	"Hidden Section Entry",
	"This button lives inside a section created with hidden = true",
	function()
	end
)

local AboutTab = Library:NewTab("About")

local InfoSection = AboutTab:NewSection("Library Info")

InfoSection:NewButton(
	"Kavo UI Library",
	"Source: github.com/Xyraniz/VaultUI",
	function()
	end
)
