-- Armenta-Lib API test script
-- The script downloads the library, compiles it with loadstring, and exercises its public API.

local LIBRARY_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/refs/heads/main/Libraries/Armenta-Lib/source.lua"

local function loadArmentaLib(url)
	assert(type(loadstring) == "function", "loadstring is unavailable in this environment")

	local requestOk, source = pcall(game.HttpGet, game, url)
	assert(requestOk and type(source) == "string" and #source > 0, "Armenta-Lib source could not be downloaded")

	local chunk, compileError = loadstring(source)
	assert(type(chunk) == "function", "Armenta-Lib compilation failed: " .. tostring(compileError))

	local runOk, library = pcall(chunk)
	assert(runOk and type(library) == "table", "Armenta-Lib initialization failed: " .. tostring(library))
	assert(type(library.Menu) == "function", "Armenta-Lib Menu API is missing")
	assert(type(library.Theme) == "table", "Armenta-Lib Theme API is missing")

	return library
end

local FyyUI = loadArmentaLib(LIBRARY_URL)
assert(type(FyyUI.GetIconModule()) == "table", "Armenta-Lib icon module is not initialized")

local Window

local function formatValue(value)
	if type(value) == "table" then
		local parts = {}
		for _, item in ipairs(value) do
			table.insert(parts, tostring(item))
		end
		return "[" .. table.concat(parts, ", ") .. "]"
	end

	if typeof(value) == "Color3" then
		return string.format(
			"#%02X%02X%02X",
			math.floor(value.R * 255 + 0.5),
			math.floor(value.G * 255 + 0.5),
			math.floor(value.B * 255 + 0.5)
		)
	end

	return tostring(value)
end

local function notify(title, content, notificationType, duration)
	if not Window then
		return nil, "window is not initialized"
	end

	return Window:Notify({
		Title = title,
		Content = content,
		Type = notificationType or "Info",
		Duration = duration or 4,
	})
end

local function reportValue(title, value)
	notify(title, "Current value: " .. formatValue(value), "Info", 3)
end

-- A custom in-memory storage backend lets ConfigTab work without executor file APIs.
local profileStore = {}
local profileStorage = {
	List = function()
		local profiles = {}
		for name in pairs(profileStore) do
			if name ~= ".autoload" then
				table.insert(profiles, name)
			end
		end
		table.sort(profiles)
		return profiles
	end,

	Read = function(name)
		local value = profileStore[name]
		if value == nil then
			return nil, "profile not found"
		end
		return value
	end,

	Write = function(name, value)
		profileStore[name] = value
		return true
	end,

	Delete = function(name)
		profileStore[name] = nil
		return true
	end,
}

Window = FyyUI.Menu({
	Title = "Armenta-Lib Test",
	Theme = "Midnight",
	ColorOverride = {
		Accent = Color3.fromRGB(104, 153, 255),
		AccentLine = Color3.fromRGB(158, 191, 255),
	},
	Logo = false,
	Size = UDim2.fromOffset(780, 520),
	MinSize = Vector2.new(360, 320),
	MaxSize = Vector2.new(900, 620),
	Resizable = true,
	Responsive = true,
	CompactBreakpoint = 680,
	SafePadding = 14,
	TouchTargetSize = 40,
	Scale = 1,
	ReducedMotion = false,
	Shadow = true,
	HasOutline = true,
	PaletteMaxResults = 80,
	Topbar = {
		ButtonsType = "Mac",
		TitleAlignment = "Left",
	},
	Stats = {
		Enabled = true,
		TabName = "Session",
		TabIcon = "activity",
		ShowProfile = true,
		ShowGame = true,
		ShowServer = true,
		ShowSupport = true,
	},
	Support = {
		Title = "Armenta-Lib support",
		Description = "Use the callback to verify support actions.",
		ButtonText = "Support callback",
		ButtonIcon = "message-circle",
		Discord = "https://discord.com/",
		Callback = function(url)
			notify("Support callback", "Received URL: " .. tostring(url), "Success", 5)
		end,
	},
})

Window:OnDestroy(function()
	print("[Armenta-Lib] Window destroyed")
end)

Window:OnMinimizeChanged(function(minimized)
	print("[Armenta-Lib] Minimized: " .. tostring(minimized))
end)

-- Controls tab: every primitive control and its public value API.
local controlsTab = Window:Tab({
	Text = "Controls",
	Icon = "sliders-horizontal",
	Tooltip = "Toggle, slider, dropdown, color, text, checkbox, and keybind controls",
})

controlsTab:BoldLabel({
	Text = "Primitive controls",
	Description = "Each row is connected to a real callback and a configuration flag.",
})
controlsTab:Label({
	Text = "Change values, then use the Runtime tab to read, replace, export, and restore them.",
	Description = "The controls are intentionally independent so every setter can be checked.",
})
controlsTab:Divider()

local audioToggle = controlsTab:Toggle({
	Text = "Audio output",
	Description = "Boolean state with SetValue, GetValue, and SetEnabled.",
	Default = true,
	Flag = "controls.audio_output",
	Tooltip = "Toggle audio output",
	Callback = function(value)
		notify("Audio output", value and "Enabled" or "Disabled", "Info", 3)
	end,
})

local volumeSlider = controlsTab:Slider({
	Text = "Master volume",
	Description = "Numeric range with a five-point step and a percent suffix.",
	Min = 0,
	Max = 100,
	Step = 5,
	Default = 70,
	Suffix = "%",
	Flag = "controls.master_volume",
	Tooltip = "Drag the volume rail",
	Callback = function(value)
		reportValue("Master volume", value)
	end,
})

local qualityDropdown = controlsTab:Dropdown({
	Text = "Render quality",
	Description = "Single selection with AllowNone disabled.",
	Options = { "Balanced", "Performance", "Quality" },
	Default = "Balanced",
	AllowNone = false,
	Flag = "controls.render_quality",
	Tooltip = "Choose one render profile",
	Callback = function(value)
		reportValue("Render quality", value)
	end,
})

local channelDropdown = controlsTab:Dropdown({
	Text = "Enabled channels",
	Description = "Multi-selection dropdown backed by an array value.",
	Options = { "World", "Combat", "Visuals", "Audio" },
	Default = { "World", "Visuals" },
	Multi = true,
	Placeholder = "Choose channels",
	Flag = "controls.enabled_channels",
	Tooltip = "Choose several channels",
	Callback = function(value)
		reportValue("Enabled channels", value)
	end,
})

local accentPicker = controlsTab:ColorPicker({
	Text = "Accent color",
	Description = "Color3 value with HSV picker and RGB config serialization.",
	Default = Color3.fromRGB(104, 153, 255),
	Flag = "visual.accent_color",
	Tooltip = "Open the color picker",
	Callback = function(value)
		reportValue("Accent color", value)
	end,
})

local playerAlias = controlsTab:Input({
	Text = "Player alias",
	Description = "TextInput value with placeholder and focus behavior.",
	Placeholder = "Enter an alias",
	Default = "Test subject",
	ClearTextOnFocus = false,
	Flag = "profile.player_alias",
	Tooltip = "Enter a display alias",
	Callback = function(value, enterPressed)
		notify("Player alias", formatValue(value) .. " | Enter: " .. tostring(enterPressed), "Info", 3)
	end,
})

local frameBudget = controlsTab:Input({
	Text = "Frame budget",
	Description = "Numeric TextInput that rejects invalid values on focus loss.",
	Placeholder = "Milliseconds",
	Default = 16,
	Numeric = true,
	ClearTextOnFocus = false,
	Flag = "render.frame_budget",
	Tooltip = "Enter a finite number",
	Callback = function(value)
		reportValue("Frame budget", value)
	end,
})

local shortcutKeybind = controlsTab:Keybind({
	Text = "Visibility shortcut",
	Description = "Toggle mode; press the assigned key to hide or restore the menu.",
	Default = "RightShift",
	Mode = "Toggle",
	Flag = "controls.visibility_shortcut",
	Tooltip = "Click the key field to capture another key",
	Callback = function(value)
		Window:ToggleVisibility()
		notify("Visibility shortcut", "Menu visibility: " .. tostring(Window:GetVisible()), "Info", 3)
	end,
})

local diagnosticsCheckbox = controlsTab:Checkbox({
	Text = "Send diagnostics",
	Description = "Checkbox control with the same boolean setter contract.",
	Default = true,
	Flag = "diagnostics.send_enabled",
	Tooltip = "Enable diagnostic messages",
	Callback = function(value)
		reportValue("Send diagnostics", value)
	end,
})

-- Layout tab: columns, nested columns, and collapsible content.
local layoutTab = Window:Tab({
	Text = "Layout",
	Icon = "layout-dashboard",
	Tooltip = "Responsive columns and collapsible groups",
})

layoutTab:BoldLabel({
	Text = "Responsive layout",
	Description = "Resize the window or narrow the viewport to exercise column stacking.",
})
layoutTab:Label({
	Text = "The same builders are available from tabs, columns, and collapsible groups.",
	Description = "The nested group below also checks height propagation.",
})

local columns = layoutTab:Columns({
	Ratio = { 3, 2 },
	Gap = 10,
	StackOnCompact = true,
})

local leftColumn = columns:Column(1)
local rightColumn = columns:Column(2)

leftColumn:BoldLabel({
	Text = "Primary column",
	Description = "A two-column parent with its own controls.",
})
leftColumn:Button({
	Text = "Run primary action",
	Description = "Button callback with an icon and description.",
	Icon = "play",
	Tooltip = "Run the primary column callback",
	Callback = function()
		notify("Primary action", "The primary column callback ran.", "Success", 3)
	end,
})
leftColumn:Slider({
	Text = "Refresh interval",
	Description = "Slider mounted inside a column.",
	Min = 1,
	Max = 60,
	Step = 1,
	Default = 15,
	Suffix = " s",
	Flag = "layout.refresh_interval",
	Callback = function(value)
		reportValue("Refresh interval", value)
	end,
})

local rightColumnToggle = rightColumn:Toggle({
	Text = "Compact spacing",
	Description = "Toggle mounted in the second column.",
	Default = false,
	Flag = "layout.compact_spacing",
	Callback = function(value)
		reportValue("Compact spacing", value)
	end,
})
rightColumn:ColorPicker({
	Text = "Column marker",
	Description = "Color picker mounted in the second column.",
	Default = Color3.fromRGB(42, 204, 129),
	Flag = "layout.column_marker",
	Callback = function(value)
		reportValue("Column marker", value)
	end,
})

local advancedGroup = leftColumn:Collapsible("Nested controls", {
	DefaultOpen = true,
})
advancedGroup:Label({
	Text = "Nested group content",
	Description = "This content expands and contracts with the group.",
})
advancedGroup:Divider()
advancedGroup:Toggle({
	Text = "Nested toggle",
	Default = true,
	Flag = "layout.nested_toggle",
	Callback = function(value)
		reportValue("Nested toggle", value)
	end,
})
advancedGroup:Dropdown({
	Text = "Nested mode",
	Options = { "Local", "Remote", "Offline" },
	Default = "Local",
	AllowNone = false,
	Flag = "layout.nested_mode",
	Callback = function(value)
		reportValue("Nested mode", value)
	end,
})

local nestedColumns = advancedGroup:Columns({
	Ratio = { 1, 1 },
	Gap = 8,
	StackOnCompact = true,
})
nestedColumns:Column(1):Button({
	Text = "Nested button",
	Icon = "mouse-pointer-click",
	Callback = function()
		notify("Nested button", "The nested button callback ran.", "Success", 3)
	end,
})
nestedColumns:Column(2):Checkbox({
	Text = "Nested checkbox",
	Default = false,
	Flag = "layout.nested_checkbox",
	Callback = function(value)
		reportValue("Nested checkbox", value)
	end,
})

-- Runtime tab: setters, getters, themes, notifications, config serialization, and lifecycle.
local runtimeTab = Window:Tab({
	Text = "Runtime",
	Icon = "terminal",
	Tooltip = "Runtime methods and serialization checks",
})

runtimeTab:BoldLabel({
	Text = "Runtime checks",
	Description = "Use these actions after changing values in the other tabs.",
})
local runtimeStatus = runtimeTab:Label({
	Text = "Ready. Library version: " .. tostring(FyyUI.Version),
	Description = "The status row is updated through Label.SetText.",
})
runtimeTab:Divider()

local temporaryRow = runtimeTab:Label({
	Text = "Temporary row: call Destroy to remove this row.",
	Description = "This row exists only to verify component cleanup.",
})

local readValuesButton
readValuesButton = runtimeTab:Button({
	Text = "Read current values",
	Description = "Calls GetValue on every stateful control.",
	Icon = "scan-search",
	Tooltip = "Read all control values",
	Callback = function()
		local summary = table.concat({
			"Audio: " .. formatValue(audioToggle:GetValue()),
			"Volume: " .. formatValue(volumeSlider:GetValue()),
			"Quality: " .. formatValue(qualityDropdown:GetValue()),
			"Channels: " .. formatValue(channelDropdown:GetValue()),
			"Accent: " .. formatValue(accentPicker:GetValue()),
			"Alias: " .. formatValue(playerAlias:GetValue()),
			"Budget: " .. formatValue(frameBudget:GetValue()),
			"Shortcut: " .. formatValue(shortcutKeybind:GetValue()),
			"Diagnostics: " .. formatValue(diagnosticsCheckbox:GetValue()),
			"Column toggle: " .. formatValue(rightColumnToggle:GetValue()),
		}, " | ")
		runtimeStatus.SetText(summary)
		readValuesButton.SetText("Values read")
		notify("Control values", summary, "Info", 6)
		task.delay(2, function()
			if readValuesButton and readValuesButton.Container and readValuesButton.Container.Parent then
				readValuesButton.SetText("Read current values")
			end
		end)
	end,
})

runtimeTab:Input({
	Text = "Window title",
	Description = "Focus the field, type a title, and press Enter or click away.",
	Placeholder = "Enter a window title",
	Default = "Armenta-Lib Test",
	ClearTextOnFocus = false,
	Callback = function(value)
		if value ~= "" then
			Window:SetTitle(value)
			runtimeStatus.SetText("Window title changed to: " .. value)
		end
	end,
})

runtimeTab:Button({
	Text = "Apply Emerald theme",
	Description = "Uses Menu.SetTheme with a built-in theme name.",
	Icon = "palette",
	Callback = function()
		local ok, err = Window:SetTheme("Emerald")
		notify("Built-in theme", ok and "Emerald applied." or tostring(err), ok and "Success" or "Error", 4)
	end,
})

runtimeTab:Button({
	Text = "Apply custom theme",
	Description = "Uses Theme.Override and Menu.SetTheme with a theme table.",
	Icon = "paintbrush",
	Callback = function()
		local customTheme = FyyUI.Theme:Override("Dark", {
			Accent = Color3.fromRGB(239, 91, 155),
			AccentLine = Color3.fromRGB(255, 132, 183),
		})
		local ok, err = Window:SetTheme(customTheme)
		notify("Custom theme", ok and "Custom accent applied." or tostring(err), ok and "Success" or "Error", 4)
	end,
})

runtimeTab:Button({
	Text = "Adjust scale",
	Description = "Reads the current scale, then uses Menu.SetScale with a clamped value.",
	Icon = "maximize-2",
	Callback = function()
		local current = Window:GetScale()
		local nextScale = current >= 1.1 and 0.9 or 1.1
		local ok, err = Window:SetScale(nextScale)
		runtimeStatus.SetText("Scale: " .. tostring(Window:GetScale()))
		notify("Menu scale", ok and tostring(nextScale) or tostring(err), ok and "Success" or "Error", 3)
	end,
})

runtimeTab:Button({
	Text = "Open command palette",
	Description = "Opens the searchable palette; Ctrl+K is also supported by the library.",
	Icon = "command",
	Callback = function()
		local opened, err = Window:OpenCommandPalette()
		if opened then
			notify("Command palette", "Palette opened. Press Escape to close it.", "Info", 3)
		else
			notify("Command palette", tostring(err), "Warning", 3)
		end
	end,
})

runtimeTab:Button({
	Text = "Notification lifecycle",
	Description = "Creates a notification, updates it, and dismisses it through its handle.",
	Icon = "bell-ring",
	Callback = function()
		local handle, err = Window:Notify({
			Title = "Lifecycle check",
			Content = "Initial notification content.",
			Type = "Info",
			Duration = 8,
		})
		if not handle then
			notify("Notification lifecycle", tostring(err), "Error", 4)
			return
		end

		task.delay(1, function()
			handle:Update("Lifecycle check", "The notification content was updated.")
		end)
		task.delay(3, function()
			handle:Dismiss()
		end)
	end,
})

runtimeTab:Button({
	Text = "Round-trip table config",
	Description = "Exports the v2 table envelope and imports it without callbacks.",
	Icon = "braces",
	Callback = function()
		local snapshot, exportError = Window:ExportConfig({ SchemaVersion = 2 })
		if not snapshot then
			notify("Table config", tostring(exportError), "Error", 4)
			return
		end

		local imported, details = Window:ImportConfig(snapshot, { NoCallbacks = true })
		local applied = details and details.Applied and #details.Applied or 0
		notify(
			"Table config",
			imported and ("Applied values: " .. tostring(applied)) or "Import failed: " .. tostring(details),
			imported and "Success" or "Error",
			4
		)
	end,
})

runtimeTab:Button({
	Text = "Round-trip JSON config",
	Description = "Encodes the v2 envelope with HttpService and imports it again.",
	Icon = "file-braces",
	Callback = function()
		local json, exportError = Window:ExportConfigJSON()
		if not json then
			notify("JSON config", tostring(exportError), "Error", 4)
			return
		end

		local imported, details = Window:ImportConfigJSON(json, { NoCallbacks = true })
		local applied = details and details.Applied and #details.Applied or 0
		notify(
			"JSON config",
			imported and ("JSON length: " .. tostring(#json) .. " | Applied: " .. tostring(applied))
				or "Import failed: " .. tostring(details),
			imported and "Success" or "Error",
			5
		)
	end,
})

runtimeTab:Button({
	Text = "Set sample values silently",
	Description = "Uses noCallback arguments where the control supports them.",
	Icon = "wand-sparkles",
	Callback = function()
		audioToggle:SetValue(false, true, true)
		volumeSlider:SetValue(25, true)
		qualityDropdown:SetValue("Performance", true)
		channelDropdown:SetValue("Audio", true)
		accentPicker:SetColor(Color3.fromRGB(239, 91, 155), true)
		playerAlias:SetValue("Silent sample", true)
		frameBudget:SetValue(20, true)
		shortcutKeybind:SetValue("LeftAlt")
		diagnosticsCheckbox:SetValue(false, true, true)
		rightColumnToggle:SetValue(true, true, true)
		runtimeStatus.SetText("Sample values applied without callbacks.")
		notify("Silent setters", "Sample values applied.", "Success", 4)
	end,
})

runtimeTab:Button({
	Text = "Refresh quality options",
	Description = "Replaces dropdown options and selects a new valid entry.",
	Icon = "refresh-cw",
	Callback = function()
		local ok, err = qualityDropdown:SetOptions(
			{ "Balanced", "Performance", "Quality", "Battery" },
			"Battery",
			true
		)
		notify("Quality options", ok and "Battery selected." or tostring(err), ok and "Success" or "Error", 4)
	end,
})

runtimeTab:Button({
	Text = "Hide for one second",
	Description = "Checks SetVisible and GetVisible, then restores the menu automatically.",
	Icon = "eye-off",
	Callback = function()
		local wasVisible = Window:GetVisible()
		Window:SetVisible(false)
		runtimeStatus.SetText("Visible: " .. tostring(Window:GetVisible()))
		task.delay(1, function()
			if Window:GetVisible() == false then
				Window:SetVisible(wasVisible)
				runtimeStatus.SetText("Visible: " .. tostring(Window:GetVisible()))
			end
		end)
	end,
})

runtimeTab:Button({
	Text = "Destroy temporary row",
	Description = "Calls the returned Label destroy function without destroying the menu.",
	Icon = "eraser",
	Callback = function()
		if temporaryRow then
			temporaryRow.Destroy()
			temporaryRow = nil
			notify("Component cleanup", "Temporary row destroyed.", "Success", 3)
		else
			notify("Component cleanup", "Temporary row is already destroyed.", "Info", 3)
		end
	end,
})

runtimeTab:Button({
	Text = "Reload icon module",
	Description = "Optional remote icon-module load through FyyUI.LoadRemoteIconModule.",
	Icon = "cloud-download",
	Callback = function()
		local callOk, loaded, detail = pcall(FyyUI.LoadRemoteIconModule)
		if not callOk then
			notify("Icon module", tostring(loaded), "Error", 5)
		elseif loaded then
			notify("Icon module", "Remote icon module loaded.", "Success", 4)
		else
			notify("Icon module", tostring(detail), "Warning", 5)
		end
	end,
})

runtimeTab:Button({
	Text = "Restore default title",
	Description = "Calls Menu.SetTitle with a known value.",
	Icon = "type",
	Callback = function()
		Window:SetTitle("Armenta-Lib Test")
		runtimeStatus.SetText("Window title restored.")
	end,
})

runtimeTab:Button({
	Text = "Destroy window",
	Description = "Final lifecycle test; OnDestroy callbacks will run.",
	Icon = "x",
	Color = Color3.fromRGB(235, 95, 95),
	Callback = function()
		Window:Destroy()
	end,
})

-- ConfigTab uses the in-memory backend above, so Save, Load, Delete, Autoload,
-- Import, Export, Refresh, and profile selection can be tested without disk access.
Window:ConfigTab({
	Text = "Profiles",
	Icon = "database",
	Folder = "ArmentaLibTestProfiles",
	Storage = profileStorage,
	DefaultProfile = "LocalTest",
	LoadCallbacks = true,
	AllowDelete = true,
	AllowImportExport = true,
	AutoLoad = false,
})

notify("Armenta-Lib ready", "All test tabs were created successfully.", "Success", 5)

return Window
