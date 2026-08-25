local LIB_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/SynergyUI/source.lua"
local SynergyUI = loadstring(game:HttpGet(LIB_URL))()

local Window = SynergyUI:CreateWindow({
	Title = "SynergyUI Test Suite",
	Subtitle = "Full API Coverage",
	Theme = "Ocean",
	ToggleKey = "RightShift",
	ConfigName = "SynergyUIExampleConfig",
	CloseOnEscape = false,
	OnOpen = function(window) end,
	OnClose = function(window) end,
	OnDestroy = function(window) end,
})

local CombatTab = Window:CreateTab("Combat", "sword")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local PlayerTab = Window:CreateTab("Player", "footprints")
local ContentTab = Window:CreateTab("Content", "layout-list")
local InterfaceTab = Window:CreateTab("Interface", "sliders-horizontal")

CombatTab:CreateSection("Targeting")

CombatTab:CreateToggle({
	Name = "Aim Assist",
	Flag = "AimAssist",
	CurrentValue = false,
	Callback = function(value)
		SynergyUI:Notify({
			Message = value and "Aim Assist enabled" or "Aim Assist disabled",
			Type = value and "done" or "info",
			Duration = 2,
		})
	end,
})

CombatTab:CreateSlider({
	Name = "Field of View",
	Flag = "AimFOV",
	Range = { 10, 200 },
	Increment = 1,
	CurrentValue = 90,
	Callback = function(value) end,
})

CombatTab:CreateDropdown({
	Name = "Target Priority",
	Flag = "TargetPriority",
	Options = { "Head", "Torso", "Closest to Crosshair", "Random" },
	CurrentOption = "Head",
	Callback = function(value) end,
})

CombatTab:CreateKeybind({
	Name = "Aim Hotkey",
	Flag = "AimHotkey",
	CurrentKeybind = "MouseButton2",
	Callback = function(key) end,
})

CombatTab:CreateSeparator()
CombatTab:CreateSection("Combat Extras")

CombatTab:CreateToggle({
	Name = "Auto Block",
	Flag = "AutoBlock",
	CurrentValue = false,
	Callback = function(value) end,
})

CombatTab:CreateToggle({
	Name = "Auto Fire",
	Flag = "AutoFire",
	CurrentValue = false,
	Callback = function(value) end,
})

CombatTab:CreateSlider({
	Name = "Damage Scale",
	Flag = "DamageScale",
	Range = { 0.5, 3 },
	Increment = 0.1,
	CurrentValue = 1,
	Callback = function(value) end,
})

CombatTab:CreateChecklist({
	Name = "Team Filters",
	Flag = "TeamFilters",
	Options = { "Enemies", "Allies", "Neutral" },
	CurrentSelected = { "Enemies" },
	Callback = function(selected) end,
})

CombatTab:CreateRadioGroup({
	Name = "Target Mode",
	Flag = "TargetMode",
	Options = { "Closest", "Lowest Health", "Highest Threat" },
	CurrentValue = "Closest",
	Callback = function(value) end,
})

VisualsTab:CreateSection("Overlay")

VisualsTab:CreateToggle({
	Name = "Player Overlay",
	Flag = "OverlayEnabled",
	CurrentValue = true,
	Callback = function(value) end,
})

VisualsTab:CreateColorPicker({
	Name = "Overlay Color",
	Flag = "OverlayColor",
	Color = Color3.fromRGB(37, 174, 226),
	Callback = function(color) end,
})

VisualsTab:CreateDropdown({
	Name = "Overlay Style",
	Flag = "OverlayStyle",
	Options = { "Outline", "Corner Brackets", "Filled", "None" },
	CurrentOption = "Outline",
	Callback = function(value) end,
})

VisualsTab:CreateSlider({
	Name = "Tracer Thickness",
	Flag = "TracerThickness",
	Range = { 1, 10 },
	Increment = 1,
	CurrentValue = 2,
	Callback = function(value) end,
})

VisualsTab:CreateColorPicker({
	Name = "Highlight Color",
	Flag = "HighlightColor",
	Color = Color3.fromRGB(51, 235, 220),
	Callback = function(color) end,
})

VisualsTab:CreateCheckBox({
	Name = "Full Bright",
	Flag = "FullBright",
	CurrentValue = false,
	Callback = function(value) end,
})

VisualsTab:CreateDropdown({
	Name = "Time of Day",
	Flag = "TimeOfDay",
	Options = { "Sunrise", "Noon", "Sunset", "Midnight" },
	CurrentOption = "Noon",
	Searchable = true,
	Callback = function(value) end,
})

PlayerTab:CreateSection("Character")

PlayerTab:CreateSlider({
	Name = "Walk Speed",
	Flag = "WalkSpeed",
	Range = { 16, 300 },
	Increment = 1,
	CurrentValue = 16,
	Callback = function(value)
		local player = game:GetService("Players").LocalPlayer
		local character = player and player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = value
		end
	end,
})

PlayerTab:CreateSlider({
	Name = "Jump Power",
	Flag = "JumpPower",
	Range = { 50, 300 },
	Increment = 5,
	CurrentValue = 50,
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

PlayerTab:CreateToggle({
	Name = "Infinite Jump",
	Flag = "InfiniteJump",
	CurrentValue = false,
	Callback = function(value) end,
})

PlayerTab:CreateToggle({
	Name = "Noclip",
	Flag = "NoclipEnabled",
	CurrentValue = false,
	Callback = function(value) end,
})

PlayerTab:CreateKeybind({
	Name = "Noclip Hotkey",
	Flag = "NoclipHotkey",
	CurrentKeybind = "N",
	Callback = function(key) end,
})

PlayerTab:CreateNumberInput({
	Name = "Custom Speed Value",
	Flag = "CustomSpeedValue",
	CurrentValue = 16,
	Callback = function(value) end,
})

PlayerTab:CreateTextInput({
	Name = "Nickname Override",
	Flag = "NicknameOverride",
	Placeholder = "Leave empty to use your real name",
	CurrentText = "",
	Callback = function(value) end,
})

ContentTab:CreateParagraph({
	Title = "About This Panel",
	Content = "This tab exists to demonstrate the Paragraph, Image, Video and Progress Bar controls side by side.",
})

ContentTab:CreateImage({
	Title = "Preview Image",
	Image = "rbxassetid://124448418211665",
	Description = "Expandable image entry with a caption underneath.",
})

ContentTab:CreateVideo({
	Title = "Trailer (assign your own Video asset)",
	Video = "",
	Looped = false,
	Volume = 0.5,
})

local renderProgress = ContentTab:CreateProgressBar({
	Name = "Render Progress",
	Flag = "RenderProgress",
	Min = 0,
	Max = 100,
	CurrentValue = 0,
	ShowPercentage = true,
	Callback = function(value, ratio) end,
})

ContentTab:CreateButton({
	Name = "Simulate Progress",
	Tooltip = "Animates the Render Progress bar from 0 to 100",
	Callback = function()
		task.spawn(function()
			for i = 0, 100, 5 do
				renderProgress:SetValue(i)
				task.wait(0.05)
			end
		end)
	end,
})

InterfaceTab:CreateSection("Appearance")

InterfaceTab:CreateDropdown({
	Name = "Theme",
	Options = { "Dark", "Slate", "Ivory", "Sage", "Burgundy", "Sandstone", "Ocean" },
	CurrentOption = "Ocean",
	Callback = function(value)
		Window:SetTheme(value)
	end,
})

InterfaceTab:CreateColorPicker({
	Name = "Accent Color",
	Flag = "AccentColorOverride",
	Color = Color3.fromRGB(37, 174, 226),
	Callback = function(color)
		Window:SetAccent(color)
	end,
})

InterfaceTab:CreateTextInput({
	Name = "Window Title",
	Placeholder = "SynergyUI Test Suite",
	CurrentText = "SynergyUI Test Suite",
	Callback = function(value)
		Window:SetTitle(value)
	end,
})

InterfaceTab:CreateTextInput({
	Name = "Window Subtitle",
	Placeholder = "Full API Coverage",
	CurrentText = "Full API Coverage",
	Callback = function(value)
		Window:SetSubtitle(value)
	end,
})

InterfaceTab:CreateKeybind({
	Name = "Menu Toggle Key",
	Flag = "Keybind",
	CurrentKeybind = "RightShift",
	Callback = function(key) end,
})

InterfaceTab:CreateSeparator()
InterfaceTab:CreateSection("Dialogs")

InterfaceTab:CreateButton({
	Name = "Show Alert",
	Callback = function()
		Window:Alert({
			Title = "Heads Up",
			Content = "This is a single-button alert dialog.",
			ConfirmText = "Got It",
		})
	end,
})

InterfaceTab:CreateButton({
	Name = "Show Confirm",
	Callback = function()
		Window:Confirm({
			Title = "Confirm Action",
			Content = "Are you sure you want to continue?",
			ConfirmText = "Yes",
			CancelText = "No",
			ConfirmCallback = function()
				SynergyUI:Notify({ Message = "Confirmed", Type = "done" })
			end,
			CancelCallback = function()
				SynergyUI:Notify({ Message = "Cancelled", Type = "warning" })
			end,
		})
	end,
})

InterfaceTab:CreateButton({
	Name = "Show Prompt",
	Callback = function()
		Window:Prompt({
			Title = "Enter a Value",
			Content = "Type something below and press Continue.",
			Placeholder = "Type here",
			Callback = function(text, dialog)
				if text and text ~= "" then
					SynergyUI:Notify({ Message = "You typed: " .. text, Type = "done" })
				end
			end,
		})
	end,
})

InterfaceTab:CreateButton({
	Name = "Show Game Notification",
	Callback = function()
		task.spawn(function()
			SynergyUI:CreateGameNotification({
				Title = "Event Started",
				MiniTitle = "Double XP Weekend",
				Description = "Would you like to enable notifications for future events?",
				YesText = "Enable",
				NoText = "No Thanks",
				YesCallback = function()
					SynergyUI:Notify({ Message = "Event notifications enabled", Type = "done" })
				end,
				NoCallback = function()
					SynergyUI:Notify({ Message = "Event notifications skipped", Type = "info" })
				end,
			})
		end)
	end,
})

InterfaceTab:CreateSeparator()
InterfaceTab:CreateSection("Notification Types")

InterfaceTab:CreateButton({
	Name = "Notify: Info",
	Callback = function()
		SynergyUI:Notify({ Message = "This is an informational message.", Type = "info" })
	end,
})

InterfaceTab:CreateButton({
	Name = "Notify: Done",
	Callback = function()
		SynergyUI:Notify({ Message = "The action completed successfully.", Type = "done" })
	end,
})

InterfaceTab:CreateButton({
	Name = "Notify: Warning",
	Callback = function()
		SynergyUI:Notify({ Message = "Double check this setting.", Type = "warning" })
	end,
})

InterfaceTab:CreateButton({
	Name = "Notify: Error",
	Callback = function()
		SynergyUI:Notify({ Message = "Something went wrong.", Type = "error" })
	end,
})

InterfaceTab:CreateLabel("Press Right Shift at any time to show or hide this window.")

SynergyUI:Notify({
	Message = "SynergyUI test suite loaded.",
	Type = "done",
	Duration = 4,
})
