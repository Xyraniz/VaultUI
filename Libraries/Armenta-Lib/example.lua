if getgenv then
	if getgenv().__ArmentaLibExample then
		pcall(function()
			getgenv().__ArmentaLibExample:Destroy()
		end)
	end
end

local LIB_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/refs/heads/main/Libraries/Armenta-Lib/source.lua"

local FyyUI = loadstring(game:HttpGet(LIB_URL))()

local Menu = FyyUI.Menu({
	Title = "Armenta-Lib Test Suite",
	Theme = "Violet",
	Size = UDim2.fromOffset(700, 470),
	MinSize = Vector2.new(440, 340),
	MaxSize = Vector2.new(920, 640),
	Resizable = true,
	Shadow = true,
	HasOutline = true,
	Responsive = true,
	Scale = 1,
	Stats = {
		Enabled = true,
		TabName = "Overview",
		TabIcon = "layout-dashboard",
		ShowProfile = true,
		ShowGame = true,
		ShowServer = true,
		ShowSupport = true,
	},
	Support = {
		Title = "Questions About This Menu",
		Description = "This window exists to test every widget the library ships with.",
		ButtonText = "Open Repository",
		Discord = "https://github.com/Xyraniz/VaultUI",
		ButtonIcon = "github",
	},
})

if getgenv then
	getgenv().__ArmentaLibExample = Menu
end

local CombatTab = Menu:Tab({ Text = "Combat", Icon = "sword" })
local VisualsTab = Menu:Tab({ Text = "Visuals", Icon = "eye" })
local MovementTab = Menu:Tab({ Text = "Movement", Icon = "footprints" })
local InterfaceTab = Menu:Tab({ Text = "Interface", Icon = "sliders-horizontal" })
local ConfigTab = Menu:ConfigTab({
	Text = "Config",
	Icon = "save",
	Folder = "ArmentaLibExample",
	DefaultProfile = "Default",
	LoadCallbacks = true,
	AllowDelete = true,
	AllowImportExport = true,
})

CombatTab:BoldLabel({ Text = "Targeting", Description = "Core aim assist controls." })

CombatTab:Toggle({
	Text = "Aim Assist",
	Description = "Enables the primary targeting routine.",
	Default = false,
	Flag = "AimAssistEnabled",
	Tooltip = "Master switch for targeting features.",
	Callback = function(value)
		Menu:Notify({
			Title = "Aim Assist",
			Content = value and "Enabled" or "Disabled",
			Type = value and "Success" or "Info",
			Duration = 2,
		})
	end,
})

CombatTab:Slider({
	Text = "Field of View",
	Description = "Radius used when scanning for a target.",
	Min = 10,
	Max = 200,
	Step = 1,
	Default = 90,
	Suffix = " px",
	Flag = "AimFOV",
	Callback = function(value) end,
})

CombatTab:Dropdown({
	Text = "Target Priority",
	Description = "Which part is preferred when multiple candidates qualify.",
	Options = { "Head", "Torso", "Closest to Crosshair", "Random" },
	Default = "Head",
	Flag = "TargetPriority",
	Callback = function(value) end,
})

CombatTab:Keybind({
	Text = "Hold to Assist",
	Description = "Aim assist is only active while this input is held.",
	Mode = "Hold",
	Default = Enum.UserInputType.MouseButton2,
	Flag = "AimAssistKey",
	Callback = function(active) end,
})

CombatTab:Divider()

CombatTab:BoldLabel({ Text = "Combat Extras" })

local combatColumns = CombatTab:Columns({ Ratio = { 1, 1 }, Gap = 8, StackOnCompact = true })

combatColumns:Column(1):Toggle({
	Text = "Auto Block",
	Default = false,
	Flag = "AutoBlock",
	Callback = function(value) end,
})

combatColumns:Column(2):Toggle({
	Text = "Auto Fire",
	Default = false,
	Flag = "AutoFire",
	Callback = function(value) end,
})

combatColumns:Column(1):Slider({
	Text = "Damage Scale",
	Min = 0.5,
	Max = 3,
	Step = 0.1,
	Default = 1,
	Suffix = "x",
	Flag = "DamageScale",
})

combatColumns:Column(2):Slider({
	Text = "Fire Rate",
	Min = 1,
	Max = 20,
	Step = 1,
	Default = 8,
	Suffix = "/s",
	Flag = "FireRate",
})

local targetingAdvanced = CombatTab:Collapsible("Advanced Targeting", { DefaultOpen = false })

targetingAdvanced:Dropdown({
	Text = "Team Filters",
	Description = "Select which teams may be targeted.",
	Options = { "Enemies", "Allies", "Neutral" },
	Multi = true,
	Default = { "Enemies" },
	Flag = "TeamFilters",
	Callback = function(values) end,
})

targetingAdvanced:Slider({
	Text = "Prediction",
	Min = 0,
	Max = 100,
	Step = 5,
	Default = 20,
	Suffix = "%",
	Flag = "AimPrediction",
})

targetingAdvanced:Toggle({
	Text = "Ignore Obstructions",
	Default = false,
	Flag = "IgnoreWalls",
})

VisualsTab:BoldLabel({ Text = "Overlay", Description = "Player highlighting and tracers." })

VisualsTab:Toggle({
	Text = "Player Overlay",
	Description = "Draws an outline on visible players.",
	Default = true,
	Flag = "OverlayEnabled",
	Tooltip = "Toggles the entire overlay system.",
	Callback = function(value) end,
})

VisualsTab:ColorPicker({
	Text = "Overlay Color",
	Description = "Color used for the outline.",
	Default = Color3.fromRGB(145, 92, 255),
	Flag = "OverlayColor",
	Callback = function(color) end,
})

VisualsTab:Dropdown({
	Text = "Overlay Style",
	Options = { "Outline", "Corner Brackets", "Filled", "None" },
	Default = "Outline",
	Flag = "OverlayStyle",
	Callback = function(value) end,
})

VisualsTab:Slider({
	Text = "Tracer Thickness",
	Min = 1,
	Max = 10,
	Step = 1,
	Default = 2,
	Suffix = " px",
	Flag = "TracerThickness",
})

VisualsTab:Toggle({
	Text = "Model Highlight",
	Default = false,
	Flag = "ChamsEnabled",
	Callback = function(value) end,
})

VisualsTab:ColorPicker({
	Text = "Highlight Color",
	Default = Color3.fromRGB(51, 235, 220),
	Flag = "ChamsColor",
})

local envSection = VisualsTab:Collapsible("Environment", { DefaultOpen = false })

envSection:Toggle({ Text = "Full Bright", Default = false, Flag = "FullBright" })
envSection:Dropdown({
	Text = "Time of Day",
	Options = { "Sunrise", "Noon", "Sunset", "Midnight" },
	Default = "Noon",
	Flag = "TimeOfDay",
})

local envColumns = envSection:Columns({ Ratio = { 1, 1 }, Gap = 8 })
envColumns:Column(1):Toggle({ Text = "Hide Skybox", Default = false, Flag = "HideSkybox" })
envColumns:Column(2):Toggle({ Text = "Disable Shadows", Default = false, Flag = "DisableShadows" })

MovementTab:BoldLabel({ Text = "Character" })

MovementTab:Slider({
	Text = "Walk Speed",
	Min = 16,
	Max = 300,
	Step = 1,
	Default = 16,
	Suffix = " studs/s",
	Flag = "WalkSpeed",
	Callback = function(value)
		local player = game:GetService("Players").LocalPlayer
		local character = player and player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = value
		end
	end,
})

MovementTab:Slider({
	Text = "Jump Power",
	Min = 50,
	Max = 300,
	Step = 5,
	Default = 50,
	Suffix = "",
	Flag = "JumpPower",
	Callback = function(value)
		local player = game:GetService("Players").LocalPlayer
		local character = player and player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = value
		end
	end,
})

MovementTab:Toggle({
	Text = "Infinite Jump",
	Default = false,
	Flag = "InfiniteJump",
	Callback = function(value) end,
})

MovementTab:Toggle({
	Text = "Noclip",
	Default = false,
	Flag = "NoclipEnabled",
	Callback = function(value) end,
})

MovementTab:Keybind({
	Text = "Noclip Hotkey",
	Description = "Press to toggle Noclip without opening the menu.",
	Mode = "Toggle",
	Default = Enum.KeyCode.N,
	Flag = "NoclipKey",
	Callback = function(active) end,
})

MovementTab:Input({
	Text = "Custom Speed",
	Description = "Type a value and press Enter to apply it.",
	Placeholder = "e.g. 45",
	Numeric = true,
	ClearTextOnFocus = false,
	Flag = "CustomSpeedInput",
	Callback = function(value, enterPressed) end,
})

MovementTab:Button({
	Text = "Reset Movement Values",
	Description = "Restores Walk Speed and Jump Power sliders to default.",
	Icon = "rotate-ccw",
	Callback = function()
		Menu:Notify({
			Title = "Movement",
			Content = "Values reset to default.",
			Type = "Info",
			Duration = 2,
		})
	end,
})

InterfaceTab:BoldLabel({ Text = "Appearance" })

InterfaceTab:Dropdown({
	Text = "Theme",
	Description = "Switches the menu color scheme instantly.",
	Options = {
		"Dark",
		"Light",
		"Amoled",
		"Midnight",
		"Violet",
		"Crimson",
		"Emerald",
		"Ocean",
		"Amber",
		"Rose",
		"Cyber",
		"Slate",
		"Coffee",
	},
	Default = "Violet",
	Callback = function(value)
		Menu:SetTheme(value)
	end,
})

InterfaceTab:Slider({
	Text = "UI Scale",
	Min = 0.75,
	Max = 1.35,
	Step = 0.05,
	Default = 1,
	Suffix = "x",
	Callback = function(value)
		Menu:SetScale(value)
	end,
})

InterfaceTab:Checkbox({
	Text = "Reduced Motion",
	Description = "Disables non-essential animations.",
	Default = false,
	Callback = function(value) end,
})

InterfaceTab:Divider()

InterfaceTab:BoldLabel({ Text = "Utilities" })

local utilityColumns = InterfaceTab:Columns({ Ratio = { 1, 1 }, Gap = 8 })

utilityColumns:Column(1):Button({
	Text = "Command Palette",
	Description = "Opens the searchable component list.",
	Icon = "search",
	Callback = function()
		Menu:OpenCommandPalette()
	end,
})

utilityColumns:Column(2):Button({
	Text = "Minimize Window",
	Description = "Collapses the menu to a floating icon.",
	Icon = "minimize-2",
	Callback = function()
		Menu:ToggleVisibility()
	end,
})

InterfaceTab:Label({
	Text = "Press <b>Right Control</b> at any time to show or hide this window.",
})

InterfaceTab:BoldLabel({ Text = "Notification Types" })

local notifyColumns = InterfaceTab:Columns({ Ratio = { 1, 1, 1, 1 }, Gap = 6, StackOnCompact = true })

notifyColumns:Column(1):Button({
	Text = "Info",
	Icon = "info",
	Callback = function()
		Menu:Notify({ Title = "Info", Content = "This is an informational message.", Type = "Info" })
	end,
})

notifyColumns:Column(2):Button({
	Text = "Success",
	Icon = "circle-check",
	Callback = function()
		Menu:Notify({ Title = "Success", Content = "The action completed.", Type = "Success" })
	end,
})

notifyColumns:Column(3):Button({
	Text = "Warning",
	Icon = "triangle-alert",
	Callback = function()
		Menu:Notify({ Title = "Warning", Content = "Double check this setting.", Type = "Warning" })
	end,
})

notifyColumns:Column(4):Button({
	Text = "Error",
	Icon = "circle-x",
	Callback = function()
		Menu:Notify({ Title = "Error", Content = "Something went wrong.", Type = "Error" })
	end,
})

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if input.KeyCode == Enum.KeyCode.RightControl then
		Menu:ToggleVisibility()
	end
end)

Menu:OnMinimizeChanged(function(minimized) end)

Menu:OnDestroy(function()
	if getgenv then
		getgenv().__ArmentaLibExample = nil
	end
end)

Menu:Notify({
	Title = "Armenta-Lib",
	Content = "Test suite loaded. Press Right Control to hide the window.",
	Type = "Success",
	Duration = 4,
})
