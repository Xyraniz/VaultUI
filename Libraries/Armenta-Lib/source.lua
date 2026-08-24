
return (function()
	local Theme = {
		Dark = {
			Background = Color3.fromRGB(8, 8, 9),
			Topbar = Color3.fromRGB(13, 13, 15),
			TopbarBorder = Color3.fromRGB(35, 35, 38),
			Accent = Color3.fromRGB(238, 238, 242),
			AccentLine = Color3.fromRGB(170, 170, 178),
			TextPrimary = Color3.fromRGB(242, 242, 245),
			TextSecondary = Color3.fromRGB(174, 174, 182),
			TextMuted = Color3.fromRGB(128, 128, 136),
			Element = Color3.fromRGB(20, 20, 22),
			ElementHover = Color3.fromRGB(31, 31, 34),
			ElementBorder = Color3.fromRGB(43, 43, 47),
			Outline = Color3.fromRGB(48, 48, 52),
			ToggleOn = Color3.fromRGB(235, 235, 240),
			ToggleOff = Color3.fromRGB(49, 49, 54),
			ToggleKnob = Color3.fromRGB(12, 12, 14),
			Border = Color3.fromRGB(38, 38, 42),
			ScrollBar = Color3.fromRGB(76, 76, 82),
			Shadow = Color3.fromRGB(0, 0, 0),
			Sidebar = Color3.fromRGB(11, 11, 13),
			SidebarText = Color3.fromRGB(142, 142, 150),
			SidebarTextActive = Color3.fromRGB(245, 245, 248),
			TabActive = Color3.fromRGB(27, 27, 30),
			TabHover = Color3.fromRGB(35, 35, 39),
			Font = Enum.Font.SourceSans,
			FontBold = Enum.Font.SourceSansBold,
			FontSize = 16,
			FontSizeTitle = 18,
			FontSizeSmall = 14,
			Padding = 10,
			CornerRadius = 8,
			TopbarHeight = 44,






			ElementHeight = 36,
			DescHeight = 52,
			Spacing = 6,
			SidebarWidth = 150,
		},
		Light = {
			Background = Color3.fromRGB(242, 242, 247),
			Topbar = Color3.fromRGB(232, 232, 240),
			TopbarBorder = Color3.fromRGB(218, 218, 228),
			Accent = Color3.fromRGB(0, 115, 235),
			AccentLine = Color3.fromRGB(0, 130, 245),
			TextPrimary = Color3.fromRGB(28, 28, 36),
			TextSecondary = Color3.fromRGB(98, 98, 112),
			TextMuted = Color3.fromRGB(85, 85, 98),
			Element = Color3.fromRGB(222, 222, 232),
			ElementHover = Color3.fromRGB(212, 212, 224),
			ElementBorder = Color3.fromRGB(208, 208, 218),
			Outline = Color3.fromRGB(200, 200, 215),
			ToggleOn = Color3.fromRGB(0, 165, 75),
			ToggleOff = Color3.fromRGB(178, 178, 190),
			ToggleKnob = Color3.fromRGB(242, 242, 248),
			Border = Color3.fromRGB(208, 208, 220),
			ScrollBar = Color3.fromRGB(178, 178, 192),
			Shadow = Color3.fromRGB(0, 0, 0),
			Sidebar = Color3.fromRGB(235, 235, 242),
			SidebarText = Color3.fromRGB(105, 105, 120),
			SidebarTextActive = Color3.fromRGB(28, 28, 36),
			TabActive = Color3.fromRGB(212, 212, 224),
			TabHover = Color3.fromRGB(200, 200, 215),
			Font = Enum.Font.SourceSans,
			FontBold = Enum.Font.SourceSansBold,
			FontSize = 16,
			FontSizeTitle = 18,
			FontSizeSmall = 14,
			Padding = 10,
			CornerRadius = 8,
			TopbarHeight = 44,
			ElementHeight = 36,
			DescHeight = 52,
			Spacing = 6,
			SidebarWidth = 150,
		},
		Amoled = {
			Background = Color3.fromRGB(0, 0, 0),
			Topbar = Color3.fromRGB(7, 7, 10),
			TopbarBorder = Color3.fromRGB(18, 18, 26),
			Accent = Color3.fromRGB(140, 80, 255),
			AccentLine = Color3.fromRGB(140, 80, 255),
			TextPrimary = Color3.fromRGB(210, 210, 220),
			TextSecondary = Color3.fromRGB(130, 130, 145),
			TextMuted = Color3.fromRGB(125, 125, 142),
			Element = Color3.fromRGB(13, 13, 18),
			ElementHover = Color3.fromRGB(22, 22, 30),
			ElementBorder = Color3.fromRGB(25, 25, 36),
			Outline = Color3.fromRGB(16, 16, 24),
			ToggleOn = Color3.fromRGB(140, 80, 255),
			ToggleOff = Color3.fromRGB(22, 22, 32),
			ToggleKnob = Color3.fromRGB(195, 195, 210),
			Border = Color3.fromRGB(16, 16, 24),
			ScrollBar = Color3.fromRGB(40, 40, 56),
			Shadow = Color3.fromRGB(0, 0, 0),
			Sidebar = Color3.fromRGB(3, 3, 6),
			SidebarText = Color3.fromRGB(135, 135, 152),
			SidebarTextActive = Color3.fromRGB(210, 210, 220),
			TabActive = Color3.fromRGB(13, 13, 18),
			TabHover = Color3.fromRGB(22, 22, 30),
			Font = Enum.Font.SourceSans,
			FontBold = Enum.Font.SourceSansBold,
			FontSize = 16,
			FontSizeTitle = 18,
			FontSizeSmall = 14,
			Padding = 10,
			CornerRadius = 8,
			TopbarHeight = 44,
			ElementHeight = 36,
			DescHeight = 52,
			Spacing = 6,
			SidebarWidth = 150,
		},
	}

	function Theme:Override(base, overrides)
		base = type(base) == "string" and self[base] or base
		if not base then
			base = self.Dark
		end
		local m = {}
		for k, v in pairs(base) do
			m[k] = v
		end
		for k, v in pairs(overrides or {}) do
			m[k] = v
		end
		return m
	end

	local function registerAccentTheme(name, accent, accentLine, background, topbar, element, hover, sidebar)
		Theme[name] = Theme:Override(Theme.Dark, {
			Background = background,
			Topbar = topbar,
			TopbarBorder = hover,
			Accent = accent,
			AccentLine = accentLine,
			Element = element,
			ElementHover = hover,
			ElementBorder = hover:Lerp(Color3.new(1, 1, 1), 0.12),
			Outline = hover,
			ToggleOn = accent,
			ToggleOff = hover,
			ToggleKnob = Color3.fromRGB(248, 248, 250),
			Border = hover,
			ScrollBar = accent:Lerp(background, 0.5),
			Sidebar = sidebar,
			TabActive = element,
			TabHover = hover,
		})
	end

	registerAccentTheme("Midnight", Color3.fromRGB(92, 135, 255), Color3.fromRGB(121, 162, 255), Color3.fromRGB(7, 10, 20), Color3.fromRGB(11, 15, 28), Color3.fromRGB(18, 23, 39), Color3.fromRGB(28, 35, 55), Color3.fromRGB(8, 12, 23))
	registerAccentTheme("Violet", Color3.fromRGB(145, 92, 255), Color3.fromRGB(178, 132, 255), Color3.fromRGB(12, 8, 19), Color3.fromRGB(18, 12, 28), Color3.fromRGB(26, 18, 39), Color3.fromRGB(39, 27, 57), Color3.fromRGB(14, 9, 23))
	registerAccentTheme("Crimson", Color3.fromRGB(238, 68, 91), Color3.fromRGB(255, 101, 120), Color3.fromRGB(18, 7, 10), Color3.fromRGB(27, 10, 14), Color3.fromRGB(38, 17, 22), Color3.fromRGB(55, 24, 31), Color3.fromRGB(21, 8, 12))
	registerAccentTheme("Emerald", Color3.fromRGB(42, 204, 129), Color3.fromRGB(83, 229, 158), Color3.fromRGB(6, 15, 11), Color3.fromRGB(9, 23, 17), Color3.fromRGB(15, 34, 26), Color3.fromRGB(23, 49, 38), Color3.fromRGB(7, 18, 13))
	registerAccentTheme("Ocean", Color3.fromRGB(37, 174, 226), Color3.fromRGB(79, 207, 247), Color3.fromRGB(5, 13, 18), Color3.fromRGB(8, 20, 27), Color3.fromRGB(13, 30, 39), Color3.fromRGB(20, 44, 56), Color3.fromRGB(6, 16, 22))
	registerAccentTheme("Amber", Color3.fromRGB(244, 174, 54), Color3.fromRGB(255, 203, 91), Color3.fromRGB(17, 12, 5), Color3.fromRGB(25, 18, 8), Color3.fromRGB(36, 27, 13), Color3.fromRGB(52, 39, 20), Color3.fromRGB(20, 14, 6))
	registerAccentTheme("Rose", Color3.fromRGB(239, 91, 155), Color3.fromRGB(255, 132, 183), Color3.fromRGB(18, 8, 14), Color3.fromRGB(27, 12, 21), Color3.fromRGB(39, 18, 30), Color3.fromRGB(56, 27, 43), Color3.fromRGB(21, 9, 16))
	registerAccentTheme("Cyber", Color3.fromRGB(51, 235, 220), Color3.fromRGB(163, 255, 74), Color3.fromRGB(4, 12, 13), Color3.fromRGB(7, 20, 21), Color3.fromRGB(11, 30, 31), Color3.fromRGB(18, 45, 45), Color3.fromRGB(5, 16, 17))
	registerAccentTheme("Slate", Color3.fromRGB(139, 157, 181), Color3.fromRGB(185, 197, 214), Color3.fromRGB(10, 12, 15), Color3.fromRGB(16, 19, 24), Color3.fromRGB(24, 28, 35), Color3.fromRGB(36, 42, 51), Color3.fromRGB(12, 14, 18))
	registerAccentTheme("Coffee", Color3.fromRGB(201, 145, 99), Color3.fromRGB(231, 181, 137), Color3.fromRGB(16, 11, 8), Color3.fromRGB(24, 17, 12), Color3.fromRGB(35, 25, 18), Color3.fromRGB(50, 36, 26), Color3.fromRGB(19, 13, 9))

	local U = {}

	local function makeDescriptionResponsive(label)
		local parent = label.Parent
		if not parent or not parent:IsA("GuiObject") then
			return
		end

		local baseDescriptionHeight = math.max(16, label.Size.Y.Offset)
		local baseParentYScale = parent.Size.Y.Scale
		local baseParentHeight = parent.Size.Y.Offset
		local updateQueued = false

		label.TextWrapped = true
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.AutomaticSize = Enum.AutomaticSize.Y

		local function updateHeight()
			updateQueued = false
			if not label.Parent or label.Parent ~= parent then
				return
			end

			local measuredHeight = math.max(baseDescriptionHeight, math.ceil(label.TextBounds.Y))
			local growth = math.max(0, measuredHeight - baseDescriptionHeight)
			local managedBaseHeight = parent:GetAttribute("FyyDescriptionBaseHeight") or baseParentHeight
			local expectedHeight = managedBaseHeight + growth
			parent:SetAttribute("FyyDescriptionGrowth", growth)

			local current = parent.Size
			if current.Y.Scale ~= baseParentYScale or current.Y.Offset ~= expectedHeight then
				parent.Size = UDim2.new(current.X.Scale, current.X.Offset, baseParentYScale, expectedHeight)
			end
		end

		local function queueUpdate()
			if updateQueued then
				return
			end
			updateQueued = true
			task.defer(updateHeight)
		end

		label:GetPropertyChangedSignal("TextBounds"):Connect(queueUpdate)
		label:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueUpdate)

		queueUpdate()
	end

	function U.Create(c, props, children)
		local inst = Instance.new(c)
		if props then
			for k, v in pairs(props) do
				inst[k] = v
			end
		end
		if children then
			for _, ch in ipairs(children) do
				ch.Parent = inst
			end
		end
		if c == "TextLabel" and inst.Name == "Description" then
			makeDescriptionResponsive(inst)
		elseif
			c == "TextLabel"
			and (inst.Name == "Label" or inst.Name == "Text")
			and (not props or props.TextTruncate == nil)
			and not inst.TextWrapped
		then
			inst.TextTruncate = Enum.TextTruncate.AtEnd
		end
		return inst
	end

	local LIBRARY_VERSION = "0.22.5"
	local CONFIG_V2_SCHEMA = "FyyUI.Config.v2"
	local MAX_CONFIG_JSON_BYTES = 64 * 1024
	local MAX_CONFIG_VALUES = 512
	local MAX_CONFIG_ARRAY_ITEMS = 256
	local MAX_CONFIG_STRING_BYTES = 16 * 1024
	local MAX_CONFIG_NODES = 8192


	local IconModule = nil
	local DEFAULT_ICON_URL = "https://raw.githubusercontent.com/FyyWannaFly/FyyUI/main/vendor/footagesus-icons/lucide/dist/Icons.lua"

	local function loadRemoteIconModule(url)
		url = url or DEFAULT_ICON_URL
		local raw
		local httpMethods = {
			function()
				return game:HttpGet(url)
			end,
			function()
				return game:GetService("HttpService"):GetAsync(url)
			end,
		}
		for _, method in ipairs(httpMethods) do
			local ok, result = pcall(method)
			if ok and type(result) == "string" and result ~= "" then
				raw = result
				break
			end
		end
		if not raw then
			return false, "Failed to download icon module"
		end

		local compiler = loadstring
		if type(compiler) ~= "function" then
			return false, "loadstring is unavailable"
		end
		local compiled, compileError = compiler(raw)
		if not compiled then
			return false, compileError or "Failed to compile icon module"
		end
		local ok, module = pcall(compiled)
		if not ok then
			return false, module
		end
		if type(module) ~= "table" then
			return false, "Icon module must return a table"
		end
		IconModule = module
		return true, module
	end






	local function isFiniteNumber(value)
		return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
	end

	local function consumeConfigBudget(budget, bytes)
		budget.Nodes = budget.Nodes + 1
		if budget.Nodes > MAX_CONFIG_NODES then
			return false, "config has too many values"
		end
		budget.Bytes = budget.Bytes + bytes
		if budget.Bytes > MAX_CONFIG_JSON_BYTES then
			return false, "config is too large"
		end
		return true
	end

	local function copyJSONSafeValue(value, budget, seen, depth)
		local valueType = type(value)
		if valueType == "string" then
			if #value > MAX_CONFIG_STRING_BYTES then
				return nil, "string value is too large"
			end
			local withinBudget, budgetError = consumeConfigBudget(budget, #value + 2)
			if not withinBudget then
				return nil, budgetError
			end
			return value
		end
		if valueType == "boolean" then
			local withinBudget, budgetError = consumeConfigBudget(budget, 5)
			if not withinBudget then
				return nil, budgetError
			end
			return value
		end
		if valueType == "number" then
			if not isFiniteNumber(value) then
				return nil, "expected finite number"
			end
			local withinBudget, budgetError = consumeConfigBudget(budget, 32)
			if not withinBudget then
				return nil, budgetError
			end
			return value
		end
		if valueType ~= "table" then
			return nil, "expected JSON-safe value"
		end
		if depth >= 8 then
			return nil, "config value is nested too deeply"
		end
		if seen[value] then
			return nil, "config value contains a cycle"
		end
		local withinBudget, budgetError = consumeConfigBudget(budget, 2)
		if not withinBudget then
			return nil, budgetError
		end

		seen[value] = true
		local count, maxIndex = 0, 0
		for index in pairs(value) do
			if type(index) ~= "number" or index < 1 or index % 1 ~= 0 then
				seen[value] = nil
				return nil, "expected dense array"
			end
			count = count + 1
			if count > MAX_CONFIG_ARRAY_ITEMS then
				seen[value] = nil
				return nil, "config array is too large"
			end
			if index > maxIndex then
				maxIndex = index
			end
		end
		if count ~= maxIndex then
			seen[value] = nil
			return nil, "expected dense array"
		end
		local copied = {}
		for index = 1, count do
			local item, err = copyJSONSafeValue(value[index], budget, seen, depth + 1)
			if err then
				seen[value] = nil
				return nil, err
			end
			copied[index] = item
		end
		seen[value] = nil
		return copied
	end

	local function estimateJSONSafeValueBytes(value)
		local valueType = type(value)
		if valueType == "string" then
			return (#value * 6) + 2
		end
		if valueType == "boolean" then
			return 5
		end
		if valueType == "number" then
			return 32
		end
		local total = 2
		for index = 1, #value do
			total = total + estimateJSONSafeValueBytes(value[index]) + 1
		end
		return total
	end

	local function validateConfigV2Envelope(snapshot)
		if type(snapshot) ~= "table" then
			return false, "Invalid config v2: expected a table"
		end
		local allowed = { Schema = true, SchemaVersion = true, Version = true, Values = true }
		for key in pairs(snapshot) do
			if not allowed[key] then
				return false, "Invalid config v2: unexpected envelope field"
			end
		end
		if snapshot.Schema ~= CONFIG_V2_SCHEMA or snapshot.SchemaVersion ~= 2 then
			return false, "Invalid config v2: unsupported schema"
		end
		if type(snapshot.Version) ~= "string" or snapshot.Version == "" or #snapshot.Version > 64 then
			return false, "Invalid config v2: invalid Version"
		end
		if type(snapshot.Values) ~= "table" then
			return false, "Invalid config v2: missing Values table"
		end

		local count = 0
		local budget = { Nodes = 4, Bytes = 64 }
		local normalized = {
			Schema = CONFIG_V2_SCHEMA,
			SchemaVersion = 2,
			Version = snapshot.Version,
			Values = {},
		}
		for flag, value in pairs(snapshot.Values) do
			count = count + 1
			if count > MAX_CONFIG_VALUES then
				return false, "Invalid config v2: too many values"
			end
			if type(flag) ~= "string" or flag == "" or #flag > 128 then
				return false, "Invalid config v2: invalid flag"
			end
			local withinBudget, budgetError = consumeConfigBudget(budget, #flag + 4)
			if not withinBudget then
				return false, "Invalid config v2: " .. budgetError
			end
			local copied, err = copyJSONSafeValue(value, budget, {}, 0)
			if err then
				return false, "Invalid config v2: " .. err
			end
			normalized.Values[flag] = copied
		end
		return true, normalized
	end

	local function destroyedResult(controller)
		if controller._destroyed then
			return true, false, "destroyed"
		end
		return false
	end

	local function destroyedFactoryResult(owner)
		if owner._destroyed or (owner.Menu and owner.Menu._destroyed) or (owner._menu and owner._menu._destroyed) then
			return true, nil, "destroyed"
		end
		return false
	end

	local function resolveIcon(icon)
		if not icon or type(icon) ~= "string" then
			return nil
		end

		if icon:find("^rbxassetid://") then
			return { Image = icon }
		end

		if IconModule then

			if IconModule.Icon2 then
				local ok, result = pcall(IconModule.Icon2, IconModule, icon)
				if ok and result then
					return {
						Image = result[1],
						ImageRectSize = result[2].ImageRectSize,
						ImageRectOffset = result[2].ImageRectPosition,
					}
				end

			elseif type(IconModule) == "table" then

				local name = icon
				local colon = icon:find(":")
				if colon then
					name = icon:sub(colon + 1)
				end
				local assetId = IconModule[name]
				if assetId then
					return { Image = assetId }
				end
			end
		end
		return nil
	end





	local function renderIcon(parent, icon, extra)
		if not parent or not icon then
			return nil
		end
		local resolved = resolveIcon(icon)
		if not resolved then
			return nil
		end
		if resolved.Text then
			local props = {
				Name = "Icon",
				Size = UDim2.fromOffset(18, 18),
				BackgroundTransparency = 1,
				Text = resolved.Text,
				Font = Enum.Font.SourceSans,
				TextSize = 16,
				TextColor3 = Color3.fromRGB(200, 200, 210),
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = parent,
			}
			if extra then
				for k, v in pairs(extra) do
					if k == "ImageColor3" then
						props.TextColor3 = v
					elseif k == "ImageTransparency" then
						props.TextTransparency = v
					elseif k ~= "Image" and k ~= "ImageRectSize" and k ~= "ImageRectOffset" then
						props[k] = v
					end
				end
			end
			return U.Create("TextLabel", props)
		else
			local props = {
				Name = "Icon",
				Size = UDim2.fromOffset(18, 18),
				BackgroundTransparency = 1,
				Image = resolved.Image,
				Parent = parent,
			}
			if resolved.ImageRectSize then
				props.ImageRectSize = resolved.ImageRectSize
			end
			if resolved.ImageRectOffset then
				props.ImageRectOffset = resolved.ImageRectOffset
			end
			if extra then
				for k, v in pairs(extra) do
					if k == "TextColor3" then
						if extra.ImageColor3 == nil then
							props.ImageColor3 = v
						end
					elseif k == "TextTransparency" then
						if extra.ImageTransparency == nil then
							props.ImageTransparency = v
						end
					elseif
						k ~= "Text"
						and k ~= "Font"
						and k ~= "TextSize"
						and k ~= "TextXAlignment"
						and k ~= "TextYAlignment"
					then
						props[k] = v
					end
				end
			end
			return U.Create("ImageLabel", props)
		end
	end



	local function applyIconToLabel(label, resolved)
		if not label or not resolved then
			return
		end
		if resolved.Image then
			label.Image = resolved.Image
			if resolved.ImageRectSize then
				label.ImageRectSize = resolved.ImageRectSize
			end
			if resolved.ImageRectOffset then
				label.ImageRectOffset = resolved.ImageRectOffset
			end
		elseif resolved.Text then
			label.Text = resolved.Text
		end
	end

	local function updateRenderedIcon(label, icon, parent, extra)
		local resolved = resolveIcon(icon)
		if not resolved then
			return label
		end
		local sameType = label
			and ((resolved.Text and label:IsA("TextLabel")) or (resolved.Image and label:IsA("ImageLabel")))
		if sameType then
			applyIconToLabel(label, resolved)
			return label
		end
		if label then
			label:Destroy()
		end
		return renderIcon(parent, icon, extra)
	end

	local function cleanupController(controller)
		if controller._destroyed then
			return
		end
		controller._destroyed = true
		local menu = controller._menu
		if not menu then
			return
		end
		menu:_untrackFlagged(controller)
		if menu._activeDropdown == controller then
			menu:HideDropdownPopup()
		end
	end


	local Collapsible, Columns



	do
		IconModule = {
		["a-arrow-down"] = "rbxassetid://92867583610071",
		["a-arrow-up"] = "rbxassetid://132318504999733",
		["a-large-small"] = "rbxassetid://111491496660216",
		["accessibility"] = "rbxassetid://114029945302017",
		["activity"] = "rbxassetid://94212016861936",
		["air-vent"] = "rbxassetid://81517226012329",
		["airplay"] = "rbxassetid://115020759309179",
		["alarm-clock-check"] = "rbxassetid://76437352099157",
		["alarm-clock-minus"] = "rbxassetid://77364179863205",
		["alarm-clock-off"] = "rbxassetid://97904885874823",
		["alarm-clock-plus"] = "rbxassetid://80468822979214",
		["alarm-clock"] = "rbxassetid://126259032907535",
		["alarm-smoke"] = "rbxassetid://96965448419685",
		["album"] = "rbxassetid://127358331163602",
		["align-center-horizontal"] = "rbxassetid://81570549209434",
		["align-center-vertical"] = "rbxassetid://118470463752466",
		["align-end-horizontal"] = "rbxassetid://139502909745427",
		["align-end-vertical"] = "rbxassetid://96528869059554",
		["align-horizontal-distribute-center"] = "rbxassetid://97220086126656",
		["align-horizontal-distribute-end"] = "rbxassetid://106128590702022",
		["align-horizontal-distribute-start"] = "rbxassetid://76074660002997",
		["align-horizontal-justify-center"] = "rbxassetid://75732302772427",
		["align-horizontal-justify-end"] = "rbxassetid://129167626402283",
		["align-horizontal-justify-start"] = "rbxassetid://130161830325281",
		["align-horizontal-space-around"] = "rbxassetid://91646106782950",
		["align-horizontal-space-between"] = "rbxassetid://103886093046990",
		["align-start-horizontal"] = "rbxassetid://125674804697729",
		["align-start-vertical"] = "rbxassetid://105020230154823",
		["align-vertical-distribute-center"] = "rbxassetid://93791183635525",
		["align-vertical-distribute-end"] = "rbxassetid://139354223511433",
		["align-vertical-distribute-start"] = "rbxassetid://74961997822126",
		["align-vertical-justify-center"] = "rbxassetid://134754696166569",
		["align-vertical-justify-end"] = "rbxassetid://92569381441969",
		["align-vertical-justify-start"] = "rbxassetid://99692844572718",
		["align-vertical-space-around"] = "rbxassetid://96206012459190",
		["align-vertical-space-between"] = "rbxassetid://124998077349706",
		["ambulance"] = "rbxassetid://78599995190651",
		["ampersand"] = "rbxassetid://75272915739209",
		["ampersands"] = "rbxassetid://126947193455996",
		["amphora"] = "rbxassetid://137370389604364",
		["anchor"] = "rbxassetid://92181172123618",
		["angry"] = "rbxassetid://74237056000103",
		["annoyed"] = "rbxassetid://80064369052011",
		["antenna"] = "rbxassetid://99628923540956",
		["anvil"] = "rbxassetid://100203029845919",
		["aperture"] = "rbxassetid://83396154449972",
		["app-window-mac"] = "rbxassetid://79587216113811",
		["app-window"] = "rbxassetid://93142176757189",
		["apple"] = "rbxassetid://104349242902442",
		["archive-restore"] = "rbxassetid://78956681942188",
		["archive-x"] = "rbxassetid://75830115088395",
		["archive"] = "rbxassetid://122180020814574",
		["armchair"] = "rbxassetid://105384358373973",
		["arrow-big-down-dash"] = "rbxassetid://137987229582002",
		["arrow-big-down"] = "rbxassetid://81081164158885",
		["arrow-big-left-dash"] = "rbxassetid://97827621354677",
		["arrow-big-left"] = "rbxassetid://85973092492641",
		["arrow-big-right-dash"] = "rbxassetid://117825834972403",
		["arrow-big-right"] = "rbxassetid://82960676755590",
		["arrow-big-up-dash"] = "rbxassetid://99260194327483",
		["arrow-big-up"] = "rbxassetid://93136954756149",
		["arrow-down-0-1"] = "rbxassetid://120961896217875",
		["arrow-down-1-0"] = "rbxassetid://93474255891850",
		["arrow-down-a-z"] = "rbxassetid://99554596207900",
		["arrow-down-from-line"] = "rbxassetid://132045845807798",
		["arrow-down-left"] = "rbxassetid://102899325237364",
		["arrow-down-narrow-wide"] = "rbxassetid://129105261655061",
		["arrow-down-right"] = "rbxassetid://123109928624974",
		["arrow-down-to-dot"] = "rbxassetid://101675355931221",
		["arrow-down-to-line"] = "rbxassetid://87050478931254",
		["arrow-down-up"] = "rbxassetid://85780258549577",
		["arrow-down-wide-narrow"] = "rbxassetid://88461733425991",
		["arrow-down-z-a"] = "rbxassetid://76115279362232",
		["arrow-down"] = "rbxassetid://98764963621439",
		["arrow-left-from-line"] = "rbxassetid://87857914437603",
		["arrow-left-right"] = "rbxassetid://131324733048447",
		["arrow-left-to-line"] = "rbxassetid://118645136026970",
		["arrow-left"] = "rbxassetid://102531941843733",
		["arrow-right-from-line"] = "rbxassetid://74073639809355",
		["arrow-right-left"] = "rbxassetid://77015754304300",
		["arrow-right-to-line"] = "rbxassetid://78632510329852",
		["arrow-right"] = "rbxassetid://113692007244654",
		["arrow-up-0-1"] = "rbxassetid://105257823943016",
		["arrow-up-1-0"] = "rbxassetid://134175521693798",
		["arrow-up-a-z"] = "rbxassetid://77763416595160",
		["arrow-up-down"] = "rbxassetid://81019887641527",
		["arrow-up-from-dot"] = "rbxassetid://124408496673275",
		["arrow-up-from-line"] = "rbxassetid://95777664626453",
		["arrow-up-left"] = "rbxassetid://123490598231261",
		["arrow-up-narrow-wide"] = "rbxassetid://73006024672636",
		["arrow-up-right"] = "rbxassetid://129280608535523",
		["arrow-up-to-line"] = "rbxassetid://108818207813537",
		["arrow-up-wide-narrow"] = "rbxassetid://87437426951568",
		["arrow-up-z-a"] = "rbxassetid://107546173611884",
		["arrow-up"] = "rbxassetid://89282378235317",
		["arrows-up-from-line"] = "rbxassetid://133710016938621",
		["asterisk"] = "rbxassetid://88552752106723",
		["at-sign"] = "rbxassetid://79059152889146",
		["atom"] = "rbxassetid://73167696981648",
		["audio-lines"] = "rbxassetid://70930641819242",
		["audio-waveform"] = "rbxassetid://86462036665209",
		["award"] = "rbxassetid://132740088158419",
		["axe"] = "rbxassetid://132405197863294",
		["axis-3d"] = "rbxassetid://122438676546804",
		["baby"] = "rbxassetid://93472926933440",
		["backpack"] = "rbxassetid://140420225386018",
		["badge-alert"] = "rbxassetid://101829200081951",
		["badge-cent"] = "rbxassetid://133345018873154",
		["badge-check"] = "rbxassetid://76078495178149",
		["badge-dollar-sign"] = "rbxassetid://127139803581141",
		["badge-euro"] = "rbxassetid://120016477674659",
		["badge-indian-rupee"] = "rbxassetid://75659682309981",
		["badge-info"] = "rbxassetid://131995373201472",
		["badge-japanese-yen"] = "rbxassetid://99081574588615",
		["badge-minus"] = "rbxassetid://140321561183881",
		["badge-percent"] = "rbxassetid://121359224294885",
		["badge-plus"] = "rbxassetid://100325578561866",
		["badge-pound-sterling"] = "rbxassetid://119688217279444",
		["badge-question-mark"] = "rbxassetid://121464963737502",
		["badge-russian-ruble"] = "rbxassetid://108839463659864",
		["badge-swiss-franc"] = "rbxassetid://91447608372740",
		["badge-turkish-lira"] = "rbxassetid://137839965873529",
		["badge-x"] = "rbxassetid://122931434733842",
		["badge"] = "rbxassetid://116620312917084",
		["baggage-claim"] = "rbxassetid://86922213051957",
		["ban"] = "rbxassetid://90767043015246",
		["banana"] = "rbxassetid://140713420056179",
		["bandage"] = "rbxassetid://129660129590770",
		["banknote-arrow-down"] = "rbxassetid://139366449345199",
		["banknote-arrow-up"] = "rbxassetid://133758343082529",
		["banknote-x"] = "rbxassetid://95348701438065",
		["banknote"] = "rbxassetid://104840231536668",
		["barcode"] = "rbxassetid://118473018143689",
		["barrel"] = "rbxassetid://130647115622774",
		["baseline"] = "rbxassetid://124677132511270",
		["bath"] = "rbxassetid://76031400297942",
		["battery-charging"] = "rbxassetid://80139357470047",
		["battery-full"] = "rbxassetid://70906718268972",
		["battery-low"] = "rbxassetid://139659256984314",
		["battery-medium"] = "rbxassetid://105934079398915",
		["battery-plus"] = "rbxassetid://91931341486966",
		["battery-warning"] = "rbxassetid://115230083817257",
		["battery"] = "rbxassetid://70765800346189",
		["beaker"] = "rbxassetid://80902539995520",
		["bean-off"] = "rbxassetid://98164436608714",
		["bean"] = "rbxassetid://89491967076869",
		["bed-double"] = "rbxassetid://73820193212911",
		["bed-single"] = "rbxassetid://113423940880634",
		["bed"] = "rbxassetid://97726529032925",
		["beef"] = "rbxassetid://105850162318915",
		["beer-off"] = "rbxassetid://120333134736361",
		["beer"] = "rbxassetid://116404978807744",
		["bell-dot"] = "rbxassetid://93161277118810",
		["bell-electric"] = "rbxassetid://100277767266983",
		["bell-minus"] = "rbxassetid://126334890449727",
		["bell-off"] = "rbxassetid://78560046118930",
		["bell-plus"] = "rbxassetid://77014333795836",
		["bell-ring"] = "rbxassetid://94612128913941",
		["bell"] = "rbxassetid://97392696311902",
		["between-horizontal-end"] = "rbxassetid://81602774794322",
		["between-horizontal-start"] = "rbxassetid://76112384929846",
		["between-vertical-end"] = "rbxassetid://72817612571631",
		["between-vertical-start"] = "rbxassetid://85278312190301",
		["biceps-flexed"] = "rbxassetid://82004462003936",
		["bike"] = "rbxassetid://102930322246035",
		["binary"] = "rbxassetid://91751953950088",
		["binoculars"] = "rbxassetid://101460003267896",
		["biohazard"] = "rbxassetid://95956532900432",
		["bird"] = "rbxassetid://132284145117371",
		["birdhouse"] = "rbxassetid://83999157401433",
		["bitcoin"] = "rbxassetid://95459240442938",
		["blend"] = "rbxassetid://111679612185257",
		["blinds"] = "rbxassetid://71164165283925",
		["blocks"] = "rbxassetid://72212693357737",
		["bluetooth-connected"] = "rbxassetid://96315134002985",
		["bluetooth-off"] = "rbxassetid://80600044218117",
		["bluetooth-searching"] = "rbxassetid://100673019606426",
		["bluetooth"] = "rbxassetid://90506573139443",
		["bold"] = "rbxassetid://116141470019166",
		["bolt"] = "rbxassetid://102881251417484",
		["bomb"] = "rbxassetid://139223800924636",
		["bone"] = "rbxassetid://111242153474115",
		["book-a"] = "rbxassetid://104067275658465",
		["book-alert"] = "rbxassetid://124159928044853",
		["book-audio"] = "rbxassetid://109208148317037",
		["book-check"] = "rbxassetid://115999656081696",
		["book-copy"] = "rbxassetid://108543407492005",
		["book-dashed"] = "rbxassetid://127430784795958",
		["book-down"] = "rbxassetid://101011730128222",
		["book-headphones"] = "rbxassetid://108670200799574",
		["book-heart"] = "rbxassetid://112788845135284",
		["book-image"] = "rbxassetid://80808285757226",
		["book-key"] = "rbxassetid://116024426170705",
		["book-lock"] = "rbxassetid://118765061220571",
		["book-marked"] = "rbxassetid://73211024251780",
		["book-minus"] = "rbxassetid://112724962046282",
		["book-open-check"] = "rbxassetid://130848362492667",
		["book-open-text"] = "rbxassetid://100629528672195",
		["book-open"] = "rbxassetid://129845326810392",
		["book-plus"] = "rbxassetid://140267785051233",
		["book-text"] = "rbxassetid://94011772484232",
		["book-type"] = "rbxassetid://97817304725443",
		["book-up-2"] = "rbxassetid://130161620853665",
		["book-up"] = "rbxassetid://98640174079190",
		["book-user"] = "rbxassetid://128489189240523",
		["book-x"] = "rbxassetid://118754548186537",
		["book"] = "rbxassetid://125383279695672",
		["bookmark-check"] = "rbxassetid://93940443347986",
		["bookmark-minus"] = "rbxassetid://96807096039910",
		["bookmark-plus"] = "rbxassetid://121469724491615",
		["bookmark-x"] = "rbxassetid://112272342584706",
		["bookmark"] = "rbxassetid://121093149326239",
		["boom-box"] = "rbxassetid://99901322535868",
		["bot-message-square"] = "rbxassetid://96145330292478",
		["bot-off"] = "rbxassetid://140417690560013",
		["bot"] = "rbxassetid://80451686744860",
		["bottle-wine"] = "rbxassetid://131675403196921",
		["bow-arrow"] = "rbxassetid://124089655150375",
		["box"] = "rbxassetid://101768155599700",
		["boxes"] = "rbxassetid://136372617578355",
		["braces"] = "rbxassetid://117761094704041",
		["brackets"] = "rbxassetid://74368995728099",
		["brain-circuit"] = "rbxassetid://70547962410202",
		["brain-cog"] = "rbxassetid://132039205501538",
		["brain"] = "rbxassetid://92424107303177",
		["brick-wall-fire"] = "rbxassetid://92980588705520",
		["brick-wall-shield"] = "rbxassetid://75954432775071",
		["brick-wall"] = "rbxassetid://112878522258821",
		["briefcase-business"] = "rbxassetid://129135125207283",
		["briefcase-conveyor-belt"] = "rbxassetid://108665725653714",
		["briefcase-medical"] = "rbxassetid://119917756334087",
		["briefcase"] = "rbxassetid://96754188164225",
		["bring-to-front"] = "rbxassetid://132975903553748",
		["brush-cleaning"] = "rbxassetid://71728977448805",
		["brush"] = "rbxassetid://127035535799640",
		["bubbles"] = "rbxassetid://106183424168227",
		["bug-off"] = "rbxassetid://88020025049245",
		["bug-play"] = "rbxassetid://80107955888092",
		["bug"] = "rbxassetid://83626408925438",
		["building-2"] = "rbxassetid://77873775611951",
		["building"] = "rbxassetid://110616258983082",
		["bus-front"] = "rbxassetid://89863432456045",
		["bus"] = "rbxassetid://133798469717463",
		["cable-car"] = "rbxassetid://128643682205596",
		["cable"] = "rbxassetid://128449944504901",
		["cake-slice"] = "rbxassetid://136769828413242",
		["cake"] = "rbxassetid://103131590503275",
		["calculator"] = "rbxassetid://74915716529646",
		["calendar-1"] = "rbxassetid://98458364171044",
		["calendar-arrow-down"] = "rbxassetid://108415736543437",
		["calendar-arrow-up"] = "rbxassetid://70574654109118",
		["calendar-check-2"] = "rbxassetid://120231170248276",
		["calendar-check"] = "rbxassetid://71551019465748",
		["calendar-clock"] = "rbxassetid://119132152594595",
		["calendar-cog"] = "rbxassetid://122402172360287",
		["calendar-days"] = "rbxassetid://99072017568595",
		["calendar-fold"] = "rbxassetid://117368871270394",
		["calendar-heart"] = "rbxassetid://88839008103676",
		["calendar-minus-2"] = "rbxassetid://98846170279891",
		["calendar-minus"] = "rbxassetid://137354318924383",
		["calendar-off"] = "rbxassetid://109726151749217",
		["calendar-plus-2"] = "rbxassetid://112264562093883",
		["calendar-plus"] = "rbxassetid://125266115249843",
		["calendar-range"] = "rbxassetid://103641849247576",
		["calendar-search"] = "rbxassetid://92010083223634",
		["calendar-sync"] = "rbxassetid://78082218499697",
		["calendar-x-2"] = "rbxassetid://107518051061147",
		["calendar-x"] = "rbxassetid://106703374806500",
		["calendar"] = "rbxassetid://114792700814035",
		["camera-off"] = "rbxassetid://81057636835256",
		["camera"] = "rbxassetid://79950339943067",
		["candy-cane"] = "rbxassetid://71689468772492",
		["candy-off"] = "rbxassetid://110232752314832",
		["candy"] = "rbxassetid://107812129154678",
		["cannabis"] = "rbxassetid://98792006538601",
		["captions-off"] = "rbxassetid://105223545364193",
		["captions"] = "rbxassetid://104960225031445",
		["car-front"] = "rbxassetid://87380942739063",
		["car-taxi-front"] = "rbxassetid://122455403384057",
		["car"] = "rbxassetid://121065933462582",
		["caravan"] = "rbxassetid://120070979471783",
		["card-sim"] = "rbxassetid://134490550095771",
		["carrot"] = "rbxassetid://119118221444304",
		["case-lower"] = "rbxassetid://129303130603241",
		["case-sensitive"] = "rbxassetid://125410273293056",
		["case-upper"] = "rbxassetid://111633433531325",
		["cassette-tape"] = "rbxassetid://137065788934157",
		["cast"] = "rbxassetid://98202245922071",
		["castle"] = "rbxassetid://119275077187784",
		["cat"] = "rbxassetid://124252153404931",
		["cctv"] = "rbxassetid://99979894766624",
		["chart-area"] = "rbxassetid://123446436762366",
		["chart-bar-big"] = "rbxassetid://72336824986044",
		["chart-bar-decreasing"] = "rbxassetid://107217459044963",
		["chart-bar-increasing"] = "rbxassetid://88268905998571",
		["chart-bar-stacked"] = "rbxassetid://98478751113024",
		["chart-bar"] = "rbxassetid://105389816384108",
		["chart-candlestick"] = "rbxassetid://125676898615697",
		["chart-column-big"] = "rbxassetid://98598733210787",
		["chart-column-decreasing"] = "rbxassetid://73586137373563",
		["chart-column-increasing"] = "rbxassetid://120421615068601",
		["chart-column-stacked"] = "rbxassetid://86031449675105",
		["chart-column"] = "rbxassetid://97915995538580",
		["chart-gantt"] = "rbxassetid://88811660555940",
		["chart-line"] = "rbxassetid://101833156055618",
		["chart-network"] = "rbxassetid://104027882693561",
		["chart-no-axes-column-decreasing"] = "rbxassetid://123371717192542",
		["chart-no-axes-column-increasing"] = "rbxassetid://140383830943049",
		["chart-no-axes-column"] = "rbxassetid://94078751170351",
		["chart-no-axes-combined"] = "rbxassetid://121424233161912",
		["chart-no-axes-gantt"] = "rbxassetid://131936541106368",
		["chart-pie"] = "rbxassetid://113412261630136",
		["chart-scatter"] = "rbxassetid://108217585014571",
		["chart-spline"] = "rbxassetid://90307460742494",
		["check-check"] = "rbxassetid://95183312173858",
		["check-line"] = "rbxassetid://115122343485290",
		["check"] = "rbxassetid://93898873302694",
		["chef-hat"] = "rbxassetid://121744015002573",
		["cherry"] = "rbxassetid://139519182403183",
		["chess-bishop"] = "rbxassetid://121701705580238",
		["chess-king"] = "rbxassetid://90885687223462",
		["chess-knight"] = "rbxassetid://96467707042169",
		["chess-pawn"] = "rbxassetid://111318574652751",
		["chess-queen"] = "rbxassetid://98304702099749",
		["chess-rook"] = "rbxassetid://76223925830262",
		["chevron-down"] = "rbxassetid://134243273101015",
		["chevron-first"] = "rbxassetid://105243363790238",
		["chevron-last"] = "rbxassetid://89268452603731",
		["chevron-left"] = "rbxassetid://73780377692148",
		["chevron-right"] = "rbxassetid://92473583511724",
		["chevron-up"] = "rbxassetid://122444883127455",
		["chevrons-down-up"] = "rbxassetid://139404716013205",
		["chevrons-down"] = "rbxassetid://100524612205956",
		["chevrons-left-right-ellipsis"] = "rbxassetid://125035817741526",
		["chevrons-left-right"] = "rbxassetid://87910685945204",
		["chevrons-left"] = "rbxassetid://82617201744347",
		["chevrons-right-left"] = "rbxassetid://87149546686569",
		["chevrons-right"] = "rbxassetid://139121276490483",
		["chevrons-up-down"] = "rbxassetid://131833120209646",
		["chevrons-up"] = "rbxassetid://100467452364672",
		["chromium"] = "rbxassetid://128165143739006",
		["church"] = "rbxassetid://113714744350666",
		["cigarette-off"] = "rbxassetid://77797883078452",
		["circle-alert"] = "rbxassetid://83898160590116",
		["circle-arrow-down"] = "rbxassetid://95901860261344",
		["circle-arrow-left"] = "rbxassetid://102148876968988",
		["circle-arrow-out-down-left"] = "rbxassetid://140598097856694",
		["circle-arrow-out-down-right"] = "rbxassetid://119952801379305",
		["circle-arrow-out-up-left"] = "rbxassetid://132858212688303",
		["circle-arrow-out-up-right"] = "rbxassetid://81783743753173",
		["circle-arrow-right"] = "rbxassetid://70786767999559",
		["circle-arrow-up"] = "rbxassetid://84395128546494",
		["circle-check-big"] = "rbxassetid://93202927221730",
		["circle-check"] = "rbxassetid://85262178816537",
		["circle-chevron-down"] = "rbxassetid://137069490345718",
		["circle-chevron-left"] = "rbxassetid://130250009740827",
		["circle-chevron-right"] = "rbxassetid://125943696958495",
		["circle-chevron-up"] = "rbxassetid://111223574026321",
		["circle-dashed"] = "rbxassetid://126799443883746",
		["circle-divide"] = "rbxassetid://106398997754208",
		["circle-dollar-sign"] = "rbxassetid://91106238890387",
		["circle-dot-dashed"] = "rbxassetid://111451232827180",
		["circle-dot"] = "rbxassetid://82947033619201",
		["circle-ellipsis"] = "rbxassetid://91687150884779",
		["circle-equal"] = "rbxassetid://95133963751438",
		["circle-fading-arrow-up"] = "rbxassetid://104648212910336",
		["circle-fading-plus"] = "rbxassetid://91847890443490",
		["circle-gauge"] = "rbxassetid://108157549473765",
		["circle-minus"] = "rbxassetid://133556159576809",
		["circle-off"] = "rbxassetid://97923456918886",
		["circle-parking-off"] = "rbxassetid://128369410981252",
		["circle-parking"] = "rbxassetid://124034962915196",
		["circle-pause"] = "rbxassetid://139337739700879",
		["circle-percent"] = "rbxassetid://133311912860256",
		["circle-play"] = "rbxassetid://120408917249739",
		["circle-plus"] = "rbxassetid://113157136350384",
		["circle-pound-sterling"] = "rbxassetid://105476153083828",
		["circle-power"] = "rbxassetid://140676030155098",
		["circle-question-mark"] = "rbxassetid://97516698664325",
		["circle-slash-2"] = "rbxassetid://136766902186549",
		["circle-slash"] = "rbxassetid://125206439913049",
		["circle-small"] = "rbxassetid://73685402843600",
		["circle-star"] = "rbxassetid://120318414957104",
		["circle-stop"] = "rbxassetid://87400503942659",
		["circle-user-round"] = "rbxassetid://95489465399880",
		["circle-user"] = "rbxassetid://136220511671311",
		["circle-x"] = "rbxassetid://76821953846248",
		["circle"] = "rbxassetid://130359823580534",
		["circuit-board"] = "rbxassetid://107695264369312",
		["citrus"] = "rbxassetid://139018222976433",
		["clapperboard"] = "rbxassetid://132660667070200",
		["clipboard-check"] = "rbxassetid://92649798577170",
		["clipboard-clock"] = "rbxassetid://123957515687745",
		["clipboard-copy"] = "rbxassetid://125851897718493",
		["clipboard-list"] = "rbxassetid://96460215958908",
		["clipboard-minus"] = "rbxassetid://107968008485671",
		["clipboard-paste"] = "rbxassetid://74382068849983",
		["clipboard-pen-line"] = "rbxassetid://77711589791615",
		["clipboard-pen"] = "rbxassetid://75290966822953",
		["clipboard-plus"] = "rbxassetid://134285318675662",
		["clipboard-type"] = "rbxassetid://89949374318028",
		["clipboard-x"] = "rbxassetid://102222456890103",
		["clipboard"] = "rbxassetid://89601995828423",
		["clock-1"] = "rbxassetid://129363225422045",
		["clock-10"] = "rbxassetid://104332695855541",
		["clock-11"] = "rbxassetid://119023205186105",
		["clock-12"] = "rbxassetid://117789618723068",
		["clock-2"] = "rbxassetid://134710777209413",
		["clock-3"] = "rbxassetid://136385631189327",
		["clock-4"] = "rbxassetid://121808839832144",
		["clock-5"] = "rbxassetid://85082019959457",
		["clock-6"] = "rbxassetid://71009733505593",
		["clock-7"] = "rbxassetid://103111188546225",
		["clock-8"] = "rbxassetid://110059272125337",
		["clock-9"] = "rbxassetid://77610027126437",
		["clock-alert"] = "rbxassetid://97157344465162",
		["clock-arrow-down"] = "rbxassetid://92349314416042",
		["clock-arrow-up"] = "rbxassetid://111484286332629",
		["clock-check"] = "rbxassetid://85231630218857",
		["clock-fading"] = "rbxassetid://93205297285245",
		["clock-plus"] = "rbxassetid://93367709263150",
		["clock"] = "rbxassetid://121808839832144",
		["closed-caption"] = "rbxassetid://99832644030788",
		["cloud-alert"] = "rbxassetid://91967273658626",
		["cloud-check"] = "rbxassetid://97318598202432",
		["cloud-cog"] = "rbxassetid://96497764065749",
		["cloud-download"] = "rbxassetid://121435581993566",
		["cloud-drizzle"] = "rbxassetid://139525315752605",
		["cloud-fog"] = "rbxassetid://76650233148776",
		["cloud-hail"] = "rbxassetid://72320462748242",
		["cloud-lightning"] = "rbxassetid://133517088924849",
		["cloud-moon-rain"] = "rbxassetid://127667837827018",
		["cloud-moon"] = "rbxassetid://71938114737914",
		["cloud-off"] = "rbxassetid://131907154501444",
		["cloud-rain-wind"] = "rbxassetid://107414583736721",
		["cloud-rain"] = "rbxassetid://105547081967408",
		["cloud-snow"] = "rbxassetid://72307126270226",
		["cloud-sun-rain"] = "rbxassetid://99041604425705",
		["cloud-sun"] = "rbxassetid://86114208148727",
		["cloud-upload"] = "rbxassetid://93307473217005",
		["cloud"] = "rbxassetid://121226497050352",
		["cloudy"] = "rbxassetid://105360479023346",
		["clover"] = "rbxassetid://74925550436750",
		["club"] = "rbxassetid://108490365816628",
		["code-xml"] = "rbxassetid://130150477351734",
		["code"] = "rbxassetid://107380207681249",
		["codepen"] = "rbxassetid://135643965971885",
		["codesandbox"] = "rbxassetid://106911852964823",
		["coffee"] = "rbxassetid://106864403231093",
		["cog"] = "rbxassetid://116544501716299",
		["coins"] = "rbxassetid://116510979641930",
		["columns-2"] = "rbxassetid://113004100221850",
		["columns-3-cog"] = "rbxassetid://121589691981064",
		["columns-3"] = "rbxassetid://115223357399375",
		["columns-4"] = "rbxassetid://130807991968419",
		["combine"] = "rbxassetid://79908476334048",
		["command"] = "rbxassetid://93648221906330",
		["compass"] = "rbxassetid://115123411028382",
		["component"] = "rbxassetid://110027788875080",
		["computer"] = "rbxassetid://77480056459407",
		["concierge-bell"] = "rbxassetid://140384259310436",
		["cone"] = "rbxassetid://97759550688437",
		["construction"] = "rbxassetid://106539489968173",
		["contact-round"] = "rbxassetid://71907624112229",
		["contact"] = "rbxassetid://75868297719012",
		["container"] = "rbxassetid://91507237573499",
		["contrast"] = "rbxassetid://112796643981497",
		["cookie"] = "rbxassetid://73159504540002",
		["cooking-pot"] = "rbxassetid://94959783129799",
		["copy-check"] = "rbxassetid://91177247988892",
		["copy-minus"] = "rbxassetid://109524509933035",
		["copy-plus"] = "rbxassetid://113618379616952",
		["copy-slash"] = "rbxassetid://93805787810390",
		["copy-x"] = "rbxassetid://106557557978061",
		["copy"] = "rbxassetid://78979572434545",
		["copyleft"] = "rbxassetid://78559055698593",
		["copyright"] = "rbxassetid://129433635747111",
		["corner-down-left"] = "rbxassetid://90473561177832",
		["corner-down-right"] = "rbxassetid://86512767702085",
		["corner-left-down"] = "rbxassetid://139876989150630",
		["corner-left-up"] = "rbxassetid://126228268096099",
		["corner-right-down"] = "rbxassetid://89237035551302",
		["corner-right-up"] = "rbxassetid://112851237026705",
		["corner-up-left"] = "rbxassetid://84669279763024",
		["corner-up-right"] = "rbxassetid://115099889693145",
		["cpu"] = "rbxassetid://77549309870247",
		["creative-commons"] = "rbxassetid://90408210735312",
		["credit-card"] = "rbxassetid://99163352872346",
		["croissant"] = "rbxassetid://130710485559420",
		["crop"] = "rbxassetid://116344601101413",
		["cross"] = "rbxassetid://101833377863588",
		["crosshair"] = "rbxassetid://134242818164054",
		["crown"] = "rbxassetid://127843403295538",
		["cuboid"] = "rbxassetid://75618807946111",
		["cup-soda"] = "rbxassetid://121098640829562",
		["currency"] = "rbxassetid://90551250119972",
		["cylinder"] = "rbxassetid://90569677179169",
		["dam"] = "rbxassetid://76874486231393",
		["database-backup"] = "rbxassetid://103403210984699",
		["database-zap"] = "rbxassetid://131199921258418",
		["database"] = "rbxassetid://126791525623846",
		["decimals-arrow-left"] = "rbxassetid://120198500638749",
		["decimals-arrow-right"] = "rbxassetid://118263047146797",
		["delete"] = "rbxassetid://126279426372342",
		["dessert"] = "rbxassetid://71508133278830",
		["diameter"] = "rbxassetid://97429051503783",
		["diamond-minus"] = "rbxassetid://128989071438290",
		["diamond-percent"] = "rbxassetid://107717860105959",
		["diamond-plus"] = "rbxassetid://134701163723675",
		["diamond"] = "rbxassetid://105846996304890",
		["dice-1"] = "rbxassetid://112650149591038",
		["dice-2"] = "rbxassetid://112278274566793",
		["dice-3"] = "rbxassetid://118526270626312",
		["dice-4"] = "rbxassetid://113365650364004",
		["dice-5"] = "rbxassetid://72768312430593",
		["dice-6"] = "rbxassetid://85376239182543",
		["dices"] = "rbxassetid://81268120302865",
		["diff"] = "rbxassetid://135052708609715",
		["disc-2"] = "rbxassetid://91419420404185",
		["disc-3"] = "rbxassetid://135470554736048",
		["disc-album"] = "rbxassetid://74693460404344",
		["disc"] = "rbxassetid://101908120120777",
		["divide"] = "rbxassetid://136678191878278",
		["dna-off"] = "rbxassetid://89612426361540",
		["dna"] = "rbxassetid://74007982981741",
		["dock"] = "rbxassetid://121997427160252",
		["dog"] = "rbxassetid://71920105558570",
		["dollar-sign"] = "rbxassetid://127320961224019",
		["donut"] = "rbxassetid://72204922742657",
		["door-closed-locked"] = "rbxassetid://74027613267551",
		["door-closed"] = "rbxassetid://136249099949073",
		["door-open"] = "rbxassetid://91306356501736",
		["dot"] = "rbxassetid://137321056643916",
		["download"] = "rbxassetid://134814648082393",
		["drafting-compass"] = "rbxassetid://99701976182841",
		["drama"] = "rbxassetid://110297795801577",
		["dribbble"] = "rbxassetid://80231809663849",
		["drill"] = "rbxassetid://108644821412796",
		["drone"] = "rbxassetid://117299095794783",
		["droplet-off"] = "rbxassetid://119365002225172",
		["droplet"] = "rbxassetid://100597455015098",
		["droplets"] = "rbxassetid://140111846025180",
		["drum"] = "rbxassetid://136979060344890",
		["drumstick"] = "rbxassetid://104662462521709",
		["dumbbell"] = "rbxassetid://80277236776212",
		["ear-off"] = "rbxassetid://87421916192807",
		["ear"] = "rbxassetid://121894949934209",
		["earth-lock"] = "rbxassetid://88814147073745",
		["earth"] = "rbxassetid://76231597751076",
		["eclipse"] = "rbxassetid://114829622118222",
		["egg-fried"] = "rbxassetid://90622538210545",
		["egg-off"] = "rbxassetid://92288321309285",
		["egg"] = "rbxassetid://117851493400222",
		["ellipsis-vertical"] = "rbxassetid://117978708573781",
		["ellipsis"] = "rbxassetid://140019550645825",
		["equal-approximately"] = "rbxassetid://105382689698323",
		["equal-not"] = "rbxassetid://76864449458032",
		["equal"] = "rbxassetid://123467780715624",
		["eraser"] = "rbxassetid://133957773112410",
		["ethernet-port"] = "rbxassetid://75391715149314",
		["euro"] = "rbxassetid://72229646524456",
		["ev-charger"] = "rbxassetid://97906158859623",
		["expand"] = "rbxassetid://137492887754537",
		["external-link"] = "rbxassetid://129331830773832",
		["eye-closed"] = "rbxassetid://111063268625789",
		["eye-off"] = "rbxassetid://135928786788378",
		["eye"] = "rbxassetid://100033680381365",
		["facebook"] = "rbxassetid://72098528632192",
		["factory"] = "rbxassetid://102170024318039",
		["fan"] = "rbxassetid://78391400440696",
		["fast-forward"] = "rbxassetid://121615540167909",
		["feather"] = "rbxassetid://91872927606406",
		["fence"] = "rbxassetid://123451565578029",
		["ferris-wheel"] = "rbxassetid://79729205796176",
		["figma"] = "rbxassetid://134182122852301",
		["file-archive"] = "rbxassetid://77018106869967",
		["file-axis-3d"] = "rbxassetid://133912328009885",
		["file-badge"] = "rbxassetid://74564895394477",
		["file-box"] = "rbxassetid://119264004071690",
		["file-braces-corner"] = "rbxassetid://77253337986109",
		["file-braces"] = "rbxassetid://95314128621234",
		["file-chart-column-increasing"] = "rbxassetid://134449481172067",
		["file-chart-column"] = "rbxassetid://82048481252560",
		["file-chart-line"] = "rbxassetid://71954360551345",
		["file-chart-pie"] = "rbxassetid://81072193564497",
		["file-check-corner"] = "rbxassetid://76295552859171",
		["file-check"] = "rbxassetid://82604001452455",
		["file-clock"] = "rbxassetid://102325208830990",
		["file-code-corner"] = "rbxassetid://78293841184371",
		["file-code"] = "rbxassetid://130978036895504",
		["file-cog"] = "rbxassetid://101385347151368",
		["file-diff"] = "rbxassetid://96147216772241",
		["file-digit"] = "rbxassetid://89220220354580",
		["file-down"] = "rbxassetid://120650154178290",
		["file-exclamation-point"] = "rbxassetid://102821865889635",
		["file-headphone"] = "rbxassetid://100533735901986",
		["file-heart"] = "rbxassetid://132214916401696",
		["file-image"] = "rbxassetid://123334057511782",
		["file-input"] = "rbxassetid://124728604166044",
		["file-key"] = "rbxassetid://118790255921100",
		["file-lock"] = "rbxassetid://72170228691242",
		["file-minus-corner"] = "rbxassetid://119263271735124",
		["file-minus"] = "rbxassetid://111014798459222",
		["file-music"] = "rbxassetid://134948051536671",
		["file-output"] = "rbxassetid://92146832572911",
		["file-pen-line"] = "rbxassetid://104622936345006",
		["file-pen"] = "rbxassetid://79556179730240",
		["file-play"] = "rbxassetid://89006821567838",
		["file-plus-corner"] = "rbxassetid://76544604043974",
		["file-plus"] = "rbxassetid://78881710800060",
		["file-question-mark"] = "rbxassetid://127617422859576",
		["file-scan"] = "rbxassetid://129480105228213",
		["file-search-corner"] = "rbxassetid://90974165234008",
		["file-search"] = "rbxassetid://97780235974933",
		["file-signal"] = "rbxassetid://122070252538165",
		["file-sliders"] = "rbxassetid://85787771732439",
		["file-spreadsheet"] = "rbxassetid://134501869359270",
		["file-stack"] = "rbxassetid://138929929862605",
		["file-symlink"] = "rbxassetid://91865722036510",
		["file-terminal"] = "rbxassetid://116757454755476",
		["file-text"] = "rbxassetid://90496405707281",
		["file-type-corner"] = "rbxassetid://124902230275209",
		["file-type"] = "rbxassetid://115272552799361",
		["file-up"] = "rbxassetid://131173039312748",
		["file-user"] = "rbxassetid://99552018455009",
		["file-video-camera"] = "rbxassetid://81719056173960",
		["file-volume"] = "rbxassetid://111264764438958",
		["file-x-corner"] = "rbxassetid://87554136773609",
		["file-x"] = "rbxassetid://107333775515154",
		["file"] = "rbxassetid://74748492079329",
		["files"] = "rbxassetid://102806336233202",
		["film"] = "rbxassetid://120978945609706",
		["fingerprint"] = "rbxassetid://112173305232811",
		["fire-extinguisher"] = "rbxassetid://111643493006960",
		["fish-off"] = "rbxassetid://89756724887508",
		["fish-symbol"] = "rbxassetid://118475177681618",
		["fish"] = "rbxassetid://124360663785796",
		["flag-off"] = "rbxassetid://112944528856799",
		["flag-triangle-left"] = "rbxassetid://88045221285272",
		["flag-triangle-right"] = "rbxassetid://108292480304566",
		["flag"] = "rbxassetid://78183383236196",
		["flame-kindling"] = "rbxassetid://139728976917928",
		["flame"] = "rbxassetid://98218034436456",
		["flashlight-off"] = "rbxassetid://79780362871740",
		["flashlight"] = "rbxassetid://100286985600444",
		["flask-conical-off"] = "rbxassetid://112597970025298",
		["flask-conical"] = "rbxassetid://128406680901165",
		["flask-round"] = "rbxassetid://127508287324940",
		["flip-horizontal-2"] = "rbxassetid://103726993598186",
		["flip-horizontal"] = "rbxassetid://122937530107837",
		["flip-vertical-2"] = "rbxassetid://103836358956328",
		["flip-vertical"] = "rbxassetid://108003917346888",
		["flower-2"] = "rbxassetid://72934574245145",
		["flower"] = "rbxassetid://86129438272762",
		["focus"] = "rbxassetid://87493973153317",
		["fold-horizontal"] = "rbxassetid://92835712442240",
		["fold-vertical"] = "rbxassetid://108873727253656",
		["folder-archive"] = "rbxassetid://97312009460206",
		["folder-check"] = "rbxassetid://128492920904557",
		["folder-clock"] = "rbxassetid://111964836738545",
		["folder-closed"] = "rbxassetid://118286209350843",
		["folder-code"] = "rbxassetid://70624096349370",
		["folder-cog"] = "rbxassetid://85299519462846",
		["folder-dot"] = "rbxassetid://138687772725278",
		["folder-down"] = "rbxassetid://118044108459225",
		["folder-git-2"] = "rbxassetid://101394054141166",
		["folder-git"] = "rbxassetid://121885778095158",
		["folder-heart"] = "rbxassetid://79104747211105",
		["folder-input"] = "rbxassetid://90699920697871",
		["folder-kanban"] = "rbxassetid://78313285104072",
		["folder-key"] = "rbxassetid://85270407596791",
		["folder-lock"] = "rbxassetid://119201572260567",
		["folder-minus"] = "rbxassetid://85648718999010",
		["folder-open-dot"] = "rbxassetid://74741494767354",
		["folder-open"] = "rbxassetid://76018996254888",
		["folder-output"] = "rbxassetid://101532447937612",
		["folder-pen"] = "rbxassetid://112770491173911",
		["folder-plus"] = "rbxassetid://91865663406119",
		["folder-root"] = "rbxassetid://103333751154693",
		["folder-search-2"] = "rbxassetid://71276453442655",
		["folder-search"] = "rbxassetid://110568075123861",
		["folder-symlink"] = "rbxassetid://127485747227189",
		["folder-sync"] = "rbxassetid://91544602659796",
		["folder-tree"] = "rbxassetid://85577554337861",
		["folder-up"] = "rbxassetid://72008269765857",
		["folder-x"] = "rbxassetid://91699618247635",
		["folder"] = "rbxassetid://80846616596607",
		["folders"] = "rbxassetid://110351216219061",
		["footprints"] = "rbxassetid://139192589041315",
		["forklift"] = "rbxassetid://72030930983101",
		["forward"] = "rbxassetid://97545944739523",
		["frame"] = "rbxassetid://109080612832751",
		["framer"] = "rbxassetid://108384807262391",
		["frown"] = "rbxassetid://124407301067982",
		["fuel"] = "rbxassetid://106447647274511",
		["fullscreen"] = "rbxassetid://77793665526178",
		["funnel-plus"] = "rbxassetid://100780233821928",
		["funnel-x"] = "rbxassetid://70984385812555",
		["funnel"] = "rbxassetid://108829540827529",
		["gallery-horizontal-end"] = "rbxassetid://74672430161161",
		["gallery-horizontal"] = "rbxassetid://80004001442122",
		["gallery-thumbnails"] = "rbxassetid://136219289862706",
		["gallery-vertical-end"] = "rbxassetid://106461402088317",
		["gallery-vertical"] = "rbxassetid://119299431466725",
		["gamepad-2"] = "rbxassetid://92483947987410",
		["gamepad-directional"] = "rbxassetid://84342305212226",
		["gamepad"] = "rbxassetid://121607283959010",
		["gauge"] = "rbxassetid://110273524101447",
		["gavel"] = "rbxassetid://78952298198456",
		["gem"] = "rbxassetid://112904952151156",
		["georgian-lari"] = "rbxassetid://98084432591687",
		["ghost"] = "rbxassetid://113822048130017",
		["gift"] = "rbxassetid://109855212076373",
		["git-branch-minus"] = "rbxassetid://97385010649411",
		["git-branch-plus"] = "rbxassetid://125944221134316",
		["git-branch"] = "rbxassetid://90490195516649",
		["git-commit-horizontal"] = "rbxassetid://133646041800147",
		["git-commit-vertical"] = "rbxassetid://122098032990350",
		["git-compare-arrows"] = "rbxassetid://84874426520216",
		["git-compare"] = "rbxassetid://91945124438792",
		["git-fork"] = "rbxassetid://89954992404765",
		["git-graph"] = "rbxassetid://86166832019304",
		["git-merge"] = "rbxassetid://131833355158059",
		["git-pull-request-arrow"] = "rbxassetid://94507974577439",
		["git-pull-request-closed"] = "rbxassetid://78070600389091",
		["git-pull-request-create-arrow"] = "rbxassetid://127422677061091",
		["git-pull-request-create"] = "rbxassetid://105929577383926",
		["git-pull-request-draft"] = "rbxassetid://76173459869943",
		["git-pull-request"] = "rbxassetid://138463010991471",
		["github"] = "rbxassetid://120349554354380",
		["gitlab"] = "rbxassetid://114054627192933",
		["glass-water"] = "rbxassetid://115526102400988",
		["glasses"] = "rbxassetid://87936407455373",
		["globe-lock"] = "rbxassetid://134065526704402",
		["globe"] = "rbxassetid://114238209622913",
		["goal"] = "rbxassetid://120517954878160",
		["gpu"] = "rbxassetid://95577823614219",
		["graduation-cap"] = "rbxassetid://93771896340220",
		["grape"] = "rbxassetid://134760640415561",
		["grid-2x2-check"] = "rbxassetid://138468840220821",
		["grid-2x2-plus"] = "rbxassetid://91811610580247",
		["grid-2x2-x"] = "rbxassetid://72407303981388",
		["grid-2x2"] = "rbxassetid://99050491897640",
		["grid-3x2"] = "rbxassetid://95528684210010",
		["grid-3x3"] = "rbxassetid://70419024781206",
		["grip-horizontal"] = "rbxassetid://136255899715930",
		["grip-vertical"] = "rbxassetid://137183678565296",
		["grip"] = "rbxassetid://109058783556768",
		["group"] = "rbxassetid://107643418926671",
		["guitar"] = "rbxassetid://75915531867926",
		["ham"] = "rbxassetid://74465607934635",
		["hamburger"] = "rbxassetid://93086916815495",
		["hammer"] = "rbxassetid://83545120140895",
		["hand-coins"] = "rbxassetid://126990543175462",
		["hand-fist"] = "rbxassetid://83341608917591",
		["hand-grab"] = "rbxassetid://88867162163985",
		["hand-heart"] = "rbxassetid://117507367668412",
		["hand-helping"] = "rbxassetid://89897738419446",
		["hand-metal"] = "rbxassetid://113619498548713",
		["hand-platter"] = "rbxassetid://88594727743168",
		["hand"] = "rbxassetid://130703864968637",
		["handbag"] = "rbxassetid://135675846264061",
		["handshake"] = "rbxassetid://78442115255814",
		["hard-drive-download"] = "rbxassetid://73913801230614",
		["hard-drive-upload"] = "rbxassetid://85762133615118",
		["hard-drive"] = "rbxassetid://88183305858463",
		["hard-hat"] = "rbxassetid://128050846767382",
		["hash"] = "rbxassetid://82890331678520",
		["hat-glasses"] = "rbxassetid://101165538224815",
		["haze"] = "rbxassetid://108857561768901",
		["hdmi-port"] = "rbxassetid://103693661037020",
		["heading-1"] = "rbxassetid://118129315662110",
		["heading-2"] = "rbxassetid://110209069670094",
		["heading-3"] = "rbxassetid://90267885237062",
		["heading-4"] = "rbxassetid://129625620307602",
		["heading-5"] = "rbxassetid://120386663181267",
		["heading-6"] = "rbxassetid://90959079775093",
		["heading"] = "rbxassetid://129254312067735",
		["headphone-off"] = "rbxassetid://85038251615641",
		["headphones"] = "rbxassetid://118833729589183",
		["headset"] = "rbxassetid://129269236787694",
		["heart-crack"] = "rbxassetid://110987638564119",
		["heart-handshake"] = "rbxassetid://111483078692002",
		["heart-minus"] = "rbxassetid://96827380163326",
		["heart-off"] = "rbxassetid://89748414415617",
		["heart-plus"] = "rbxassetid://94877796283249",
		["heart-pulse"] = "rbxassetid://129352925579546",
		["heart"] = "rbxassetid://116559368303288",
		["heater"] = "rbxassetid://140478466880916",
		["helicopter"] = "rbxassetid://111557171735930",
		["hexagon"] = "rbxassetid://127592089339199",
		["highlighter"] = "rbxassetid://77411555641113",
		["history"] = "rbxassetid://123980022019922",
		["hop-off"] = "rbxassetid://103386036934034",
		["hop"] = "rbxassetid://82778923997672",
		["hospital"] = "rbxassetid://105868763850707",
		["hotel"] = "rbxassetid://132283390859718",
		["hourglass"] = "rbxassetid://86160434939203",
		["house-heart"] = "rbxassetid://136054771868597",
		["house-plug"] = "rbxassetid://71438263712075",
		["house-plus"] = "rbxassetid://118495165208309",
		["house-wifi"] = "rbxassetid://126495519725698",
		["house"] = "rbxassetid://98755624629571",
		["ice-cream-bowl"] = "rbxassetid://124867218454386",
		["ice-cream-cone"] = "rbxassetid://90751397288639",
		["id-card-lanyard"] = "rbxassetid://90761480469224",
		["id-card"] = "rbxassetid://75354294622640",
		["image-down"] = "rbxassetid://78972295741235",
		["image-minus"] = "rbxassetid://101066016918565",
		["image-off"] = "rbxassetid://81934811700938",
		["image-play"] = "rbxassetid://129501806784210",
		["image-plus"] = "rbxassetid://70391970623917",
		["image-up"] = "rbxassetid://126610009605241",
		["image-upscale"] = "rbxassetid://106963545024679",
		["images"] = "rbxassetid://79350649395557",
		["import"] = "rbxassetid://116545008906029",
		["inbox"] = "rbxassetid://112591360302868",
		["indian-rupee"] = "rbxassetid://113038778381805",
		["infinity"] = "rbxassetid://98083086936965",
		["info"] = "rbxassetid://124560466474914",
		["inspection-panel"] = "rbxassetid://70905313146088",
		["instagram"] = "rbxassetid://119864798614855",
		["italic"] = "rbxassetid://96220378864282",
		["iteration-ccw"] = "rbxassetid://140221832794083",
		["iteration-cw"] = "rbxassetid://95534489554662",
		["japanese-yen"] = "rbxassetid://106362863465813",
		["joystick"] = "rbxassetid://99416790224739",
		["kanban"] = "rbxassetid://125934100055431",
		["kayak"] = "rbxassetid://136107544609389",
		["key-round"] = "rbxassetid://83619031955390",
		["key-square"] = "rbxassetid://94621420033649",
		["key"] = "rbxassetid://96510194465420",
		["keyboard-music"] = "rbxassetid://121058541758636",
		["keyboard-off"] = "rbxassetid://92466375369772",
		["keyboard"] = "rbxassetid://121474456068237",
		["lamp-ceiling"] = "rbxassetid://80032758469141",
		["lamp-desk"] = "rbxassetid://85290686983238",
		["lamp-floor"] = "rbxassetid://104585881375892",
		["lamp-wall-down"] = "rbxassetid://91271394132073",
		["lamp-wall-up"] = "rbxassetid://132141464337445",
		["lamp"] = "rbxassetid://110730830653382",
		["land-plot"] = "rbxassetid://96449039620294",
		["landmark"] = "rbxassetid://76885079756393",
		["languages"] = "rbxassetid://90816903776498",
		["laptop-minimal-check"] = "rbxassetid://114352019833865",
		["laptop-minimal"] = "rbxassetid://136705765566068",
		["laptop"] = "rbxassetid://111387063244975",
		["lasso-select"] = "rbxassetid://105609719912753",
		["lasso"] = "rbxassetid://121072936884007",
		["laugh"] = "rbxassetid://104491311361166",
		["layers-2"] = "rbxassetid://70536710516357",
		["layers"] = "rbxassetid://81973586053257",
		["layout-dashboard"] = "rbxassetid://139929981863901",
		["layout-grid"] = "rbxassetid://81344910161871",
		["layout-list"] = "rbxassetid://87462136296578",
		["layout-panel-left"] = "rbxassetid://125092469751491",
		["layout-panel-top"] = "rbxassetid://91943941515944",
		["layout-template"] = "rbxassetid://115564446417985",
		["leaf"] = "rbxassetid://119951075637174",
		["leafy-green"] = "rbxassetid://105146290493154",
		["lectern"] = "rbxassetid://106166425183862",
		["library-big"] = "rbxassetid://106794530191412",
		["library"] = "rbxassetid://114334671982047",
		["life-buoy"] = "rbxassetid://81168450671956",
		["ligature"] = "rbxassetid://111397873269411",
		["lightbulb-off"] = "rbxassetid://83795722296178",
		["lightbulb"] = "rbxassetid://103871245626488",
		["line-squiggle"] = "rbxassetid://109555164424447",
		["link-2-off"] = "rbxassetid://76885956296867",
		["link-2"] = "rbxassetid://86072351557466",
		["link"] = "rbxassetid://131607023382430",
		["linkedin"] = "rbxassetid://132842789255788",
		["list-check"] = "rbxassetid://72374358471156",
		["list-checks"] = "rbxassetid://99809353635593",
		["list-chevrons-down-up"] = "rbxassetid://137409641500711",
		["list-chevrons-up-down"] = "rbxassetid://81825351389084",
		["list-collapse"] = "rbxassetid://124505247702401",
		["list-end"] = "rbxassetid://77650610048119",
		["list-filter-plus"] = "rbxassetid://96385120752336",
		["list-filter"] = "rbxassetid://103321376129527",
		["list-indent-decrease"] = "rbxassetid://137879979228193",
		["list-indent-increase"] = "rbxassetid://79051053161201",
		["list-minus"] = "rbxassetid://138507965142671",
		["list-music"] = "rbxassetid://126380635781840",
		["list-ordered"] = "rbxassetid://83212528113913",
		["list-plus"] = "rbxassetid://112384738137814",
		["list-restart"] = "rbxassetid://91703153577421",
		["list-start"] = "rbxassetid://84828348299727",
		["list-todo"] = "rbxassetid://132980603752108",
		["list-tree"] = "rbxassetid://97685396239010",
		["list-video"] = "rbxassetid://93648525452489",
		["list-x"] = "rbxassetid://113025303988861",
		["list"] = "rbxassetid://113179976918783",
		["loader-circle"] = "rbxassetid://116535712789945",
		["loader-pinwheel"] = "rbxassetid://108513357940900",
		["loader"] = "rbxassetid://78408734580845",
		["locate-fixed"] = "rbxassetid://137367361548433",
		["locate-off"] = "rbxassetid://73729216338137",
		["locate"] = "rbxassetid://84467676590391",
		["lock-keyhole-open"] = "rbxassetid://110863509313073",
		["lock-keyhole"] = "rbxassetid://78672912777756",
		["lock-open"] = "rbxassetid://93597915325122",
		["lock"] = "rbxassetid://134724289526879",
		["log-in"] = "rbxassetid://103768533135201",
		["log-out"] = "rbxassetid://84895399304975",
		["logs"] = "rbxassetid://89772091251787",
		["lollipop"] = "rbxassetid://84681611583044",
		["luggage"] = "rbxassetid://76619236486400",
		["magnet"] = "rbxassetid://135162361226972",
		["mail-check"] = "rbxassetid://86921536259917",
		["mail-minus"] = "rbxassetid://81989813236553",
		["mail-open"] = "rbxassetid://122785416858638",
		["mail-plus"] = "rbxassetid://104886401588341",
		["mail-question-mark"] = "rbxassetid://126540170949819",
		["mail-search"] = "rbxassetid://135616173775287",
		["mail-warning"] = "rbxassetid://81495303676089",
		["mail-x"] = "rbxassetid://74607841705644",
		["mail"] = "rbxassetid://103945161245599",
		["mailbox"] = "rbxassetid://82765503320335",
		["mails"] = "rbxassetid://90673453450080",
		["map-minus"] = "rbxassetid://129525760577747",
		["map-pin-check-inside"] = "rbxassetid://107130529843809",
		["map-pin-check"] = "rbxassetid://118110914690154",
		["map-pin-house"] = "rbxassetid://80546885029816",
		["map-pin-minus-inside"] = "rbxassetid://79005529692964",
		["map-pin-minus"] = "rbxassetid://74518762643623",
		["map-pin-off"] = "rbxassetid://82474689391020",
		["map-pin-pen"] = "rbxassetid://113515395277504",
		["map-pin-plus-inside"] = "rbxassetid://134639656514430",
		["map-pin-plus"] = "rbxassetid://91875228967029",
		["map-pin-x-inside"] = "rbxassetid://126235934252379",
		["map-pin-x"] = "rbxassetid://101085273547316",
		["map-pin"] = "rbxassetid://84279202219901",
		["map-pinned"] = "rbxassetid://103963788475034",
		["map-plus"] = "rbxassetid://129388826743495",
		["map"] = "rbxassetid://95107167260947",
		["mars-stroke"] = "rbxassetid://131973193186828",
		["mars"] = "rbxassetid://111287112372511",
		["martini"] = "rbxassetid://82977695401058",
		["maximize-2"] = "rbxassetid://73085922906397",
		["maximize"] = "rbxassetid://76045941763188",
		["medal"] = "rbxassetid://79016002264450",
		["megaphone-off"] = "rbxassetid://124280774193935",
		["megaphone"] = "rbxassetid://118759541854879",
		["meh"] = "rbxassetid://132197867028557",
		["memory-stick"] = "rbxassetid://93212591343119",
		["menu"] = "rbxassetid://77021539815611",
		["merge"] = "rbxassetid://126201866476775",
		["message-circle-code"] = "rbxassetid://112865244991651",
		["message-circle-dashed"] = "rbxassetid://81525157881897",
		["message-circle-heart"] = "rbxassetid://101990756073677",
		["message-circle-more"] = "rbxassetid://92856823884663",
		["message-circle-off"] = "rbxassetid://134955643890328",
		["message-circle-plus"] = "rbxassetid://106562979649273",
		["message-circle-question-mark"] = "rbxassetid://107700302759934",
		["message-circle-reply"] = "rbxassetid://137071749508334",
		["message-circle-warning"] = "rbxassetid://119020096067894",
		["message-circle-x"] = "rbxassetid://126843387725536",
		["message-circle"] = "rbxassetid://127255077587058",
		["message-square-code"] = "rbxassetid://110968863152123",
		["message-square-dashed"] = "rbxassetid://107653455516238",
		["message-square-diff"] = "rbxassetid://75472190472625",
		["message-square-dot"] = "rbxassetid://127806382463916",
		["message-square-heart"] = "rbxassetid://75612811742074",
		["message-square-lock"] = "rbxassetid://81268215619563",
		["message-square-more"] = "rbxassetid://120139782405970",
		["message-square-off"] = "rbxassetid://99961019005789",
		["message-square-plus"] = "rbxassetid://76934450256199",
		["message-square-quote"] = "rbxassetid://116670768629340",
		["message-square-reply"] = "rbxassetid://130985622754637",
		["message-square-share"] = "rbxassetid://131017005324026",
		["message-square-text"] = "rbxassetid://94899503194205",
		["message-square-warning"] = "rbxassetid://138432903962261",
		["message-square-x"] = "rbxassetid://137285463279462",
		["message-square"] = "rbxassetid://83881670383280",
		["messages-square"] = "rbxassetid://97532166733358",
		["mic-off"] = "rbxassetid://82123034444822",
		["mic-vocal"] = "rbxassetid://99082286164362",
		["mic"] = "rbxassetid://89640799126523",
		["microchip"] = "rbxassetid://73937907669903",
		["microscope"] = "rbxassetid://116875530102782",
		["microwave"] = "rbxassetid://108411735353008",
		["milestone"] = "rbxassetid://101618292325920",
		["milk-off"] = "rbxassetid://72388480962742",
		["milk"] = "rbxassetid://96221903896918",
		["minimize-2"] = "rbxassetid://116269596042539",
		["minimize"] = "rbxassetid://121304296213645",
		["minus"] = "rbxassetid://118026365011536",
		["monitor-check"] = "rbxassetid://86651948439229",
		["monitor-cloud"] = "rbxassetid://85931096038318",
		["monitor-cog"] = "rbxassetid://94345128715799",
		["monitor-dot"] = "rbxassetid://130394010063680",
		["monitor-down"] = "rbxassetid://97466933743423",
		["monitor-off"] = "rbxassetid://74395526657953",
		["monitor-pause"] = "rbxassetid://76002184067562",
		["monitor-play"] = "rbxassetid://133018824306217",
		["monitor-smartphone"] = "rbxassetid://84335680433378",
		["monitor-speaker"] = "rbxassetid://81744810060380",
		["monitor-stop"] = "rbxassetid://98708958984757",
		["monitor-up"] = "rbxassetid://96035360858377",
		["monitor-x"] = "rbxassetid://126265210441423",
		["monitor"] = "rbxassetid://72664649203050",
		["moon-star"] = "rbxassetid://82782200506348",
		["moon"] = "rbxassetid://83380517901735",
		["motorbike"] = "rbxassetid://94580787368233",
		["mountain-snow"] = "rbxassetid://105315495740588",
		["mountain"] = "rbxassetid://73269957566415",
		["mouse-off"] = "rbxassetid://75267871697595",
		["mouse-pointer-2-off"] = "rbxassetid://104701076865632",
		["mouse-pointer-2"] = "rbxassetid://117093892862228",
		["mouse-pointer-ban"] = "rbxassetid://106849413057133",
		["mouse-pointer-click"] = "rbxassetid://107150227368485",
		["mouse-pointer"] = "rbxassetid://72322454962935",
		["mouse"] = "rbxassetid://73096068864710",
		["move-3d"] = "rbxassetid://103365982054003",
		["move-diagonal-2"] = "rbxassetid://117298577948096",
		["move-diagonal"] = "rbxassetid://101433481954184",
		["move-down-left"] = "rbxassetid://102819433534567",
		["move-down-right"] = "rbxassetid://101479760041877",
		["move-down"] = "rbxassetid://70510115135583",
		["move-horizontal"] = "rbxassetid://88513523439149",
		["move-left"] = "rbxassetid://137614740247980",
		["move-right"] = "rbxassetid://132455779472989",
		["move-up-left"] = "rbxassetid://139079815540148",
		["move-up-right"] = "rbxassetid://105885140592646",
		["move-up"] = "rbxassetid://84505444262658",
		["move-vertical"] = "rbxassetid://86234730730899",
		["move"] = "rbxassetid://116138709011735",
		["music-2"] = "rbxassetid://134397426600888",
		["music-3"] = "rbxassetid://94466120066498",
		["music-4"] = "rbxassetid://132459323665838",
		["music"] = "rbxassetid://113343203848535",
		["navigation-2-off"] = "rbxassetid://116569611780763",
		["navigation-2"] = "rbxassetid://81889066747907",
		["navigation-off"] = "rbxassetid://87003270290777",
		["navigation"] = "rbxassetid://79308213542922",
		["network"] = "rbxassetid://127410729922644",
		["newspaper"] = "rbxassetid://123479530460544",
		["nfc"] = "rbxassetid://76822396542242",
		["non-binary"] = "rbxassetid://78442360386235",
		["notebook-pen"] = "rbxassetid://140380614761023",
		["notebook-tabs"] = "rbxassetid://127371085570083",
		["notebook-text"] = "rbxassetid://93061585217270",
		["notebook"] = "rbxassetid://136132108664987",
		["notepad-text-dashed"] = "rbxassetid://135793446376219",
		["notepad-text"] = "rbxassetid://93404682958966",
		["nut-off"] = "rbxassetid://78795397311573",
		["nut"] = "rbxassetid://127146410705656",
		["octagon-alert"] = "rbxassetid://140438367956051",
		["octagon-minus"] = "rbxassetid://74720436795421",
		["octagon-pause"] = "rbxassetid://103161463909039",
		["octagon-x"] = "rbxassetid://90498161006311",
		["octagon"] = "rbxassetid://120803515514852",
		["omega"] = "rbxassetid://70414080018786",
		["option"] = "rbxassetid://100776883894054",
		["orbit"] = "rbxassetid://108926136860562",
		["origami"] = "rbxassetid://136020626667101",
		["package-2"] = "rbxassetid://70394974762575",
		["package-check"] = "rbxassetid://102374216055130",
		["package-minus"] = "rbxassetid://114492858789692",
		["package-open"] = "rbxassetid://132890233237818",
		["package-plus"] = "rbxassetid://129261988138366",
		["package-search"] = "rbxassetid://95465120894145",
		["package-x"] = "rbxassetid://70818501607442",
		["package"] = "rbxassetid://97261141732706",
		["paint-bucket"] = "rbxassetid://124275586663284",
		["paint-roller"] = "rbxassetid://115248074358348",
		["paintbrush-vertical"] = "rbxassetid://105151296591292",
		["paintbrush"] = "rbxassetid://125572663700289",
		["palette"] = "rbxassetid://86350350950064",
		["panda"] = "rbxassetid://132509022802512",
		["panel-bottom-close"] = "rbxassetid://74287004071159",
		["panel-bottom-dashed"] = "rbxassetid://131084651621603",
		["panel-bottom-open"] = "rbxassetid://107768659586540",
		["panel-bottom"] = "rbxassetid://132127145048511",
		["panel-left-close"] = "rbxassetid://126579818823552",
		["panel-left-dashed"] = "rbxassetid://75536606374585",
		["panel-left-open"] = "rbxassetid://111075816195767",
		["panel-left-right-dashed"] = "rbxassetid://110100707973959",
		["panel-left"] = "rbxassetid://97419752870313",
		["panel-right-close"] = "rbxassetid://139528655524132",
		["panel-right-dashed"] = "rbxassetid://94959793877311",
		["panel-right-open"] = "rbxassetid://118114419142794",
		["panel-right"] = "rbxassetid://116365035443156",
		["panel-top-bottom-dashed"] = "rbxassetid://134737235653344",
		["panel-top-close"] = "rbxassetid://83578325777808",
		["panel-top-dashed"] = "rbxassetid://70522913169237",
		["panel-top-open"] = "rbxassetid://137959875507454",
		["panel-top"] = "rbxassetid://75838479462875",
		["panels-left-bottom"] = "rbxassetid://72996856149149",
		["panels-right-bottom"] = "rbxassetid://90659068960726",
		["panels-top-left"] = "rbxassetid://79858853850600",
		["paperclip"] = "rbxassetid://92088291163453",
		["parentheses"] = "rbxassetid://78950955173096",
		["parking-meter"] = "rbxassetid://84652733960568",
		["party-popper"] = "rbxassetid://111626795712193",
		["pause"] = "rbxassetid://74873705394436",
		["paw-print"] = "rbxassetid://112218825427601",
		["pc-case"] = "rbxassetid://122978648019101",
		["pen-line"] = "rbxassetid://109108135755303",
		["pen-off"] = "rbxassetid://84807123119438",
		["pen-tool"] = "rbxassetid://106145404953445",
		["pen"] = "rbxassetid://72037878096321",
		["pencil-line"] = "rbxassetid://88392917053533",
		["pencil-off"] = "rbxassetid://103330927652832",
		["pencil-ruler"] = "rbxassetid://110120288284597",
		["pencil"] = "rbxassetid://137986121120732",
		["pentagon"] = "rbxassetid://79184802179890",
		["percent"] = "rbxassetid://130155041032013",
		["person-standing"] = "rbxassetid://125020872044147",
		["philippine-peso"] = "rbxassetid://91173798254675",
		["phone-call"] = "rbxassetid://70555587592860",
		["phone-forwarded"] = "rbxassetid://113269614319737",
		["phone-incoming"] = "rbxassetid://82863576359288",
		["phone-missed"] = "rbxassetid://130156165198376",
		["phone-off"] = "rbxassetid://133318623553383",
		["phone-outgoing"] = "rbxassetid://104576478735825",
		["phone"] = "rbxassetid://128804946640049",
		["pi"] = "rbxassetid://74936036243146",
		["piano"] = "rbxassetid://85008880789520",
		["pickaxe"] = "rbxassetid://105888023317688",
		["picture-in-picture-2"] = "rbxassetid://112803319544468",
		["picture-in-picture"] = "rbxassetid://80579597835123",
		["piggy-bank"] = "rbxassetid://79498575790721",
		["pilcrow-left"] = "rbxassetid://103803000849583",
		["pilcrow-right"] = "rbxassetid://104881733911870",
		["pilcrow"] = "rbxassetid://139512780392871",
		["pill-bottle"] = "rbxassetid://118394692404597",
		["pill"] = "rbxassetid://73280534813448",
		["pin-off"] = "rbxassetid://127696372451750",
		["pin"] = "rbxassetid://120978111007514",
		["pipette"] = "rbxassetid://133167932934404",
		["pizza"] = "rbxassetid://126964453193501",
		["plane-landing"] = "rbxassetid://122555692211889",
		["plane-takeoff"] = "rbxassetid://117179478829575",
		["plane"] = "rbxassetid://126985561580989",
		["play"] = "rbxassetid://135609604299893",
		["plug-2"] = "rbxassetid://97912386476366",
		["plug-zap"] = "rbxassetid://74506269884055",
		["plug"] = "rbxassetid://99782373064495",
		["plus"] = "rbxassetid://111774323017047",
		["pocket-knife"] = "rbxassetid://134075428063965",
		["pocket"] = "rbxassetid://136686762542964",
		["podcast"] = "rbxassetid://109577075549215",
		["pointer-off"] = "rbxassetid://95488389312794",
		["pointer"] = "rbxassetid://92615117311099",
		["popcorn"] = "rbxassetid://139446511232750",
		["popsicle"] = "rbxassetid://112696318077073",
		["pound-sterling"] = "rbxassetid://127482649469130",
		["power-off"] = "rbxassetid://118768311012214",
		["power"] = "rbxassetid://96479131758775",
		["presentation"] = "rbxassetid://106134583757890",
		["printer-check"] = "rbxassetid://130273549443689",
		["printer"] = "rbxassetid://76080649734247",
		["projector"] = "rbxassetid://103281856385283",
		["proportions"] = "rbxassetid://130046855997237",
		["puzzle"] = "rbxassetid://136837798892463",
		["pyramid"] = "rbxassetid://107811442374127",
		["qr-code"] = "rbxassetid://105329945723350",
		["quote"] = "rbxassetid://103271711590001",
		["rabbit"] = "rbxassetid://98580518804206",
		["radar"] = "rbxassetid://138528222906635",
		["radiation"] = "rbxassetid://104499586848433",
		["radical"] = "rbxassetid://132758286926047",
		["radio-receiver"] = "rbxassetid://129598303378835",
		["radio-tower"] = "rbxassetid://93958663130054",
		["radio"] = "rbxassetid://85611589536956",
		["radius"] = "rbxassetid://89814505307129",
		["rail-symbol"] = "rbxassetid://134295386306962",
		["rainbow"] = "rbxassetid://132488862841895",
		["rat"] = "rbxassetid://127400975953159",
		["ratio"] = "rbxassetid://126369423897295",
		["receipt-cent"] = "rbxassetid://91557573925201",
		["receipt-euro"] = "rbxassetid://94015722210295",
		["receipt-indian-rupee"] = "rbxassetid://89718170439990",
		["receipt-japanese-yen"] = "rbxassetid://132472560758851",
		["receipt-pound-sterling"] = "rbxassetid://73934967569625",
		["receipt-russian-ruble"] = "rbxassetid://105164576936853",
		["receipt-swiss-franc"] = "rbxassetid://72503668620116",
		["receipt-text"] = "rbxassetid://138483536013737",
		["receipt-turkish-lira"] = "rbxassetid://91950765836342",
		["receipt"] = "rbxassetid://77877895901792",
		["rectangle-circle"] = "rbxassetid://100642423153903",
		["rectangle-ellipsis"] = "rbxassetid://112919953980965",
		["rectangle-goggles"] = "rbxassetid://98605436666727",
		["rectangle-horizontal"] = "rbxassetid://90224199814966",
		["rectangle-vertical"] = "rbxassetid://117277050590967",
		["recycle"] = "rbxassetid://140417023381961",
		["redo-2"] = "rbxassetid://70451039017914",
		["redo-dot"] = "rbxassetid://94252981719732",
		["redo"] = "rbxassetid://116150342119054",
		["refresh-ccw-dot"] = "rbxassetid://106702246753270",
		["refresh-ccw"] = "rbxassetid://117913330389477",
		["refresh-cw-off"] = "rbxassetid://140179498843054",
		["refresh-cw"] = "rbxassetid://138133190015277",
		["refrigerator"] = "rbxassetid://102614042652753",
		["regex"] = "rbxassetid://100727200791841",
		["remove-formatting"] = "rbxassetid://112833162022628",
		["repeat-1"] = "rbxassetid://130144534857095",
		["repeat-2"] = "rbxassetid://85927537182704",
		["repeat"] = "rbxassetid://121886242955173",
		["replace-all"] = "rbxassetid://127862728198635",
		["replace"] = "rbxassetid://128404082279430",
		["reply-all"] = "rbxassetid://71723137343562",
		["reply"] = "rbxassetid://109788633497028",
		["rewind"] = "rbxassetid://95205297521988",
		["ribbon"] = "rbxassetid://94265331526851",
		["rocket"] = "rbxassetid://87412317685854",
		["rocking-chair"] = "rbxassetid://110420269495360",
		["roller-coaster"] = "rbxassetid://112426178972099",
		["rose"] = "rbxassetid://126336840238769",
		["rotate-3d"] = "rbxassetid://76300551576392",
		["rotate-ccw-key"] = "rbxassetid://74976035240976",
		["rotate-ccw-square"] = "rbxassetid://90515853170424",
		["rotate-ccw"] = "rbxassetid://110116685948665",
		["rotate-cw-square"] = "rbxassetid://77095448159303",
		["rotate-cw"] = "rbxassetid://84183336178654",
		["route-off"] = "rbxassetid://106350402024079",
		["route"] = "rbxassetid://89968303228953",
		["router"] = "rbxassetid://102130331994471",
		["rows-2"] = "rbxassetid://112556185960101",
		["rows-3"] = "rbxassetid://117215586961375",
		["rows-4"] = "rbxassetid://125646021959055",
		["rss"] = "rbxassetid://131789058984793",
		["ruler-dimension-line"] = "rbxassetid://70673861371412",
		["ruler"] = "rbxassetid://81432445547423",
		["russian-ruble"] = "rbxassetid://126357936542156",
		["sailboat"] = "rbxassetid://87110567187540",
		["salad"] = "rbxassetid://128864507821603",
		["sandwich"] = "rbxassetid://104573187458917",
		["satellite-dish"] = "rbxassetid://136742443888305",
		["satellite"] = "rbxassetid://134967053164645",
		["saudi-riyal"] = "rbxassetid://102282769104635",
		["save-all"] = "rbxassetid://116946975799440",
		["save-off"] = "rbxassetid://87085435778560",
		["save"] = "rbxassetid://126116963775616",
		["scale-3d"] = "rbxassetid://72414199620352",
		["scale"] = "rbxassetid://108203682317477",
		["scaling"] = "rbxassetid://122360365318466",
		["scan-barcode"] = "rbxassetid://96889457154761",
		["scan-eye"] = "rbxassetid://99244790601968",
		["scan-face"] = "rbxassetid://109959345069668",
		["scan-heart"] = "rbxassetid://106280819776142",
		["scan-line"] = "rbxassetid://126544908146540",
		["scan-qr-code"] = "rbxassetid://105409149549927",
		["scan-search"] = "rbxassetid://80009010551347",
		["scan-text"] = "rbxassetid://73702396787766",
		["scan"] = "rbxassetid://123104789658180",
		["school"] = "rbxassetid://76351530290068",
		["scissors-line-dashed"] = "rbxassetid://122237447974173",
		["scissors"] = "rbxassetid://118665510911274",
		["screen-share-off"] = "rbxassetid://107677572669805",
		["screen-share"] = "rbxassetid://85137895705653",
		["scroll-text"] = "rbxassetid://97321022666868",
		["scroll"] = "rbxassetid://74072101474951",
		["search-check"] = "rbxassetid://75442076191356",
		["search-code"] = "rbxassetid://117114794592802",
		["search-slash"] = "rbxassetid://96483932261041",
		["search-x"] = "rbxassetid://137319957522951",
		["search"] = "rbxassetid://121018724060431",
		["section"] = "rbxassetid://91732188298948",
		["send-horizontal"] = "rbxassetid://111734392411664",
		["send-to-back"] = "rbxassetid://75340312862253",
		["send"] = "rbxassetid://127751956873796",
		["separator-horizontal"] = "rbxassetid://84864453699927",
		["separator-vertical"] = "rbxassetid://84031801478581",
		["server-cog"] = "rbxassetid://138470287250966",
		["server-crash"] = "rbxassetid://132810618000212",
		["server-off"] = "rbxassetid://114048751507723",
		["server"] = "rbxassetid://92188766517878",
		["settings-2"] = "rbxassetid://135684703553372",
		["settings"] = "rbxassetid://80758916183665",
		["shapes"] = "rbxassetid://129989433311409",
		["share-2"] = "rbxassetid://71210767962065",
		["share"] = "rbxassetid://87340985053299",
		["sheet"] = "rbxassetid://134902122480171",
		["shell"] = "rbxassetid://140212943563599",
		["shield-alert"] = "rbxassetid://114995877719925",
		["shield-ban"] = "rbxassetid://108765041044649",
		["shield-check"] = "rbxassetid://87354736164608",
		["shield-ellipsis"] = "rbxassetid://114794739892123",
		["shield-half"] = "rbxassetid://117842634172647",
		["shield-minus"] = "rbxassetid://89965059528921",
		["shield-off"] = "rbxassetid://133426959132690",
		["shield-plus"] = "rbxassetid://100664857995498",
		["shield-question-mark"] = "rbxassetid://135722075265150",
		["shield-user"] = "rbxassetid://124832775645347",
		["shield-x"] = "rbxassetid://73370117343811",
		["shield"] = "rbxassetid://110987169760162",
		["ship-wheel"] = "rbxassetid://130797795829448",
		["ship"] = "rbxassetid://83995100553930",
		["shirt"] = "rbxassetid://106579555405966",
		["shopping-bag"] = "rbxassetid://71885477293226",
		["shopping-basket"] = "rbxassetid://138646411956433",
		["shopping-cart"] = "rbxassetid://128420521375441",
		["shovel"] = "rbxassetid://102465000512056",
		["shower-head"] = "rbxassetid://75884944024117",
		["shredder"] = "rbxassetid://122125164414463",
		["shrimp"] = "rbxassetid://102625900815307",
		["shrink"] = "rbxassetid://90953687918880",
		["shrub"] = "rbxassetid://127326280714343",
		["shuffle"] = "rbxassetid://132382786975101",
		["sigma"] = "rbxassetid://126884244870899",
		["signal-high"] = "rbxassetid://130436670012270",
		["signal-low"] = "rbxassetid://73674683500458",
		["signal-medium"] = "rbxassetid://125003021367019",
		["signal-zero"] = "rbxassetid://130045332414754",
		["signal"] = "rbxassetid://78424889355261",
		["signature"] = "rbxassetid://114402748013000",
		["signpost-big"] = "rbxassetid://115780185675001",
		["signpost"] = "rbxassetid://106584743791433",
		["siren"] = "rbxassetid://134210267818039",
		["skip-back"] = "rbxassetid://70466132711334",
		["skip-forward"] = "rbxassetid://124844823753990",
		["skull"] = "rbxassetid://137726256442333",
		["slack"] = "rbxassetid://96089719516736",
		["slash"] = "rbxassetid://117792185664263",
		["slice"] = "rbxassetid://95810504278179",
		["sliders-horizontal"] = "rbxassetid://85538382643347",
		["sliders-vertical"] = "rbxassetid://101190569086853",
		["smartphone-charging"] = "rbxassetid://102837532613995",
		["smartphone-nfc"] = "rbxassetid://82326425754446",
		["smartphone"] = "rbxassetid://96623008834511",
		["smile-plus"] = "rbxassetid://131981881472144",
		["smile"] = "rbxassetid://105880397565283",
		["snail"] = "rbxassetid://70904536548363",
		["snowflake"] = "rbxassetid://101235206534566",
		["soap-dispenser-droplet"] = "rbxassetid://77258480479465",
		["sofa"] = "rbxassetid://114427687218324",
		["solar-panel"] = "rbxassetid://132448188047921",
		["soup"] = "rbxassetid://115092551871618",
		["space"] = "rbxassetid://87072088914178",
		["spade"] = "rbxassetid://131444449466462",
		["sparkle"] = "rbxassetid://111044800239623",
		["sparkles"] = "rbxassetid://138635884129147",
		["speaker"] = "rbxassetid://96227183003618",
		["speech"] = "rbxassetid://87013139446349",
		["spell-check-2"] = "rbxassetid://81556731785534",
		["spell-check"] = "rbxassetid://91913483031334",
		["spline-pointer"] = "rbxassetid://84842840956804",
		["spline"] = "rbxassetid://129406685807412",
		["split"] = "rbxassetid://105112438805988",
		["spool"] = "rbxassetid://124541981347743",
		["spotlight"] = "rbxassetid://77571742539344",
		["spray-can"] = "rbxassetid://128372039366326",
		["sprout"] = "rbxassetid://100091687832508",
		["square-activity"] = "rbxassetid://89496630185293",
		["square-arrow-down-left"] = "rbxassetid://108194680296901",
		["square-arrow-down-right"] = "rbxassetid://99403846801050",
		["square-arrow-down"] = "rbxassetid://135962519626588",
		["square-arrow-left"] = "rbxassetid://111671474549238",
		["square-arrow-out-down-left"] = "rbxassetid://125714881756353",
		["square-arrow-out-down-right"] = "rbxassetid://89971003001390",
		["square-arrow-out-up-left"] = "rbxassetid://103759986579087",
		["square-arrow-out-up-right"] = "rbxassetid://91221896066807",
		["square-arrow-right"] = "rbxassetid://113920471701361",
		["square-arrow-up-left"] = "rbxassetid://112424670290693",
		["square-arrow-up-right"] = "rbxassetid://76602291406940",
		["square-arrow-up"] = "rbxassetid://106998604646718",
		["square-asterisk"] = "rbxassetid://89186832353625",
		["square-bottom-dashed-scissors"] = "rbxassetid://79076980104803",
		["square-chart-gantt"] = "rbxassetid://104034017316411",
		["square-check-big"] = "rbxassetid://115320390907184",
		["square-check"] = "rbxassetid://134682053539509",
		["square-chevron-down"] = "rbxassetid://91032307924592",
		["square-chevron-left"] = "rbxassetid://73143404829510",
		["square-chevron-right"] = "rbxassetid://90612077729930",
		["square-chevron-up"] = "rbxassetid://85565910197337",
		["square-code"] = "rbxassetid://81604576616881",
		["square-dashed-bottom-code"] = "rbxassetid://100354801563230",
		["square-dashed-bottom"] = "rbxassetid://101102319625624",
		["square-dashed-kanban"] = "rbxassetid://90388067649847",
		["square-dashed-mouse-pointer"] = "rbxassetid://121016142178467",
		["square-dashed-top-solid"] = "rbxassetid://117157577548540",
		["square-dashed"] = "rbxassetid://136905537847606",
		["square-divide"] = "rbxassetid://99894657101970",
		["square-dot"] = "rbxassetid://116613421354866",
		["square-equal"] = "rbxassetid://110283363706707",
		["square-function"] = "rbxassetid://86075219551088",
		["square-kanban"] = "rbxassetid://114537101260131",
		["square-library"] = "rbxassetid://73810931222081",
		["square-m"] = "rbxassetid://117662700410577",
		["square-menu"] = "rbxassetid://104067089444415",
		["square-minus"] = "rbxassetid://116764432015770",
		["square-mouse-pointer"] = "rbxassetid://76141850603920",
		["square-parking-off"] = "rbxassetid://100857293535141",
		["square-parking"] = "rbxassetid://133116656122387",
		["square-pause"] = "rbxassetid://86608552787615",
		["square-pen"] = "rbxassetid://120239476110475",
		["square-percent"] = "rbxassetid://87111930314567",
		["square-pi"] = "rbxassetid://75383328781618",
		["square-pilcrow"] = "rbxassetid://131854284699367",
		["square-play"] = "rbxassetid://108186325238481",
		["square-plus"] = "rbxassetid://114713264461873",
		["square-power"] = "rbxassetid://129240437805187",
		["square-radical"] = "rbxassetid://132645931868292",
		["square-round-corner"] = "rbxassetid://104592745113567",
		["square-scissors"] = "rbxassetid://110601255612411",
		["square-sigma"] = "rbxassetid://113231244246816",
		["square-slash"] = "rbxassetid://105477013908757",
		["square-split-horizontal"] = "rbxassetid://76095370148660",
		["square-split-vertical"] = "rbxassetid://88589192032058",
		["square-square"] = "rbxassetid://136555087357875",
		["square-stack"] = "rbxassetid://100463396619394",
		["square-star"] = "rbxassetid://94506958703720",
		["square-stop"] = "rbxassetid://80018708472943",
		["square-terminal"] = "rbxassetid://83969264476798",
		["square-user-round"] = "rbxassetid://86484997229302",
		["square-user"] = "rbxassetid://70771214183445",
		["square-x"] = "rbxassetid://125136183850190",
		["square"] = "rbxassetid://86304921356806",
		["squares-exclude"] = "rbxassetid://102345385822324",
		["squares-intersect"] = "rbxassetid://120869602570119",
		["squares-subtract"] = "rbxassetid://131484650948795",
		["squares-unite"] = "rbxassetid://96673080107843",
		["squircle-dashed"] = "rbxassetid://129936702532522",
		["squircle"] = "rbxassetid://82426632573807",
		["squirrel"] = "rbxassetid://112864252085343",
		["stamp"] = "rbxassetid://92370779813368",
		["star-half"] = "rbxassetid://117449275562979",
		["star-off"] = "rbxassetid://75742832732503",
		["star"] = "rbxassetid://136141469398409",
		["step-back"] = "rbxassetid://108672750005121",
		["step-forward"] = "rbxassetid://126131872136145",
		["stethoscope"] = "rbxassetid://122331031702148",
		["sticker"] = "rbxassetid://79938203791608",
		["sticky-note"] = "rbxassetid://111894074643919",
		["store"] = "rbxassetid://90338129673705",
		["stretch-horizontal"] = "rbxassetid://87665042192343",
		["stretch-vertical"] = "rbxassetid://95265463417122",
		["strikethrough"] = "rbxassetid://103417324549613",
		["subscript"] = "rbxassetid://74553514785183",
		["sun-dim"] = "rbxassetid://129141645592715",
		["sun-medium"] = "rbxassetid://130278807964710",
		["sun-moon"] = "rbxassetid://75752898854559",
		["sun-snow"] = "rbxassetid://112791898014579",
		["sun"] = "rbxassetid://110150589884127",
		["sunrise"] = "rbxassetid://134705665494098",
		["sunset"] = "rbxassetid://75904872203588",
		["superscript"] = "rbxassetid://96887696590118",
		["swatch-book"] = "rbxassetid://126786244872453",
		["swiss-franc"] = "rbxassetid://113497920041625",
		["switch-camera"] = "rbxassetid://76841154349737",
		["sword"] = "rbxassetid://124448418211665",
		["swords"] = "rbxassetid://81872698913435",
		["syringe"] = "rbxassetid://123891270479254",
		["table-2"] = "rbxassetid://95751552281545",
		["table-cells-merge"] = "rbxassetid://95363715175258",
		["table-cells-split"] = "rbxassetid://114799086088649",
		["table-columns-split"] = "rbxassetid://111011625447949",
		["table-of-contents"] = "rbxassetid://135044763275414",
		["table-properties"] = "rbxassetid://125062886015372",
		["table-rows-split"] = "rbxassetid://96443733673997",
		["table"] = "rbxassetid://109109148250737",
		["tablet-smartphone"] = "rbxassetid://133680859813404",
		["tablet"] = "rbxassetid://128403991264386",
		["tablets"] = "rbxassetid://80835787970735",
		["tag"] = "rbxassetid://129104970103940",
		["tags"] = "rbxassetid://107179263080798",
		["tally-1"] = "rbxassetid://115301298241643",
		["tally-2"] = "rbxassetid://110363186864027",
		["tally-3"] = "rbxassetid://97655344572540",
		["tally-4"] = "rbxassetid://102633494371890",
		["tally-5"] = "rbxassetid://88031817475886",
		["tangent"] = "rbxassetid://123263132981724",
		["target"] = "rbxassetid://87563802520297",
		["telescope"] = "rbxassetid://91755049143647",
		["tent-tree"] = "rbxassetid://76698322463977",
		["tent"] = "rbxassetid://109779587826330",
		["terminal"] = "rbxassetid://106783148545356",
		["test-tube-diagonal"] = "rbxassetid://75662704378840",
		["test-tube"] = "rbxassetid://98801015650164",
		["test-tubes"] = "rbxassetid://92555361447433",
		["text-align-center"] = "rbxassetid://84051028246390",
		["text-align-end"] = "rbxassetid://130041738343555",
		["text-align-justify"] = "rbxassetid://80279880143030",
		["text-align-start"] = "rbxassetid://134489585487649",
		["text-cursor-input"] = "rbxassetid://107551944047171",
		["text-cursor"] = "rbxassetid://115984654447300",
		["text-initial"] = "rbxassetid://129458097472087",
		["text-quote"] = "rbxassetid://139278366448736",
		["text-search"] = "rbxassetid://92345384671606",
		["text-select"] = "rbxassetid://117087320884956",
		["text-wrap"] = "rbxassetid://114804318314018",
		["theater"] = "rbxassetid://108558145549163",
		["thermometer-snowflake"] = "rbxassetid://121876188028425",
		["thermometer-sun"] = "rbxassetid://106693240074310",
		["thermometer"] = "rbxassetid://106546011492311",
		["thumbs-down"] = "rbxassetid://87794009914015",
		["thumbs-up"] = "rbxassetid://111137070767020",
		["ticket-check"] = "rbxassetid://105428777212507",
		["ticket-minus"] = "rbxassetid://78966299769328",
		["ticket-percent"] = "rbxassetid://80834774406405",
		["ticket-plus"] = "rbxassetid://110086734392189",
		["ticket-slash"] = "rbxassetid://89045681172265",
		["ticket-x"] = "rbxassetid://88674114109926",
		["ticket"] = "rbxassetid://126527071492145",
		["tickets-plane"] = "rbxassetid://100367018248695",
		["tickets"] = "rbxassetid://135268612687833",
		["timer-off"] = "rbxassetid://110916370767271",
		["timer-reset"] = "rbxassetid://110052125369932",
		["timer"] = "rbxassetid://85473888890506",
		["toggle-left"] = "rbxassetid://85887872573050",
		["toggle-right"] = "rbxassetid://90411952142550",
		["toilet"] = "rbxassetid://80930782432931",
		["tool-case"] = "rbxassetid://87533537832522",
		["tornado"] = "rbxassetid://88358291515768",
		["torus"] = "rbxassetid://70855707283051",
		["touchpad-off"] = "rbxassetid://78784008075456",
		["touchpad"] = "rbxassetid://74882354908014",
		["tower-control"] = "rbxassetid://95937619060532",
		["toy-brick"] = "rbxassetid://86293483924633",
		["tractor"] = "rbxassetid://103376704722051",
		["traffic-cone"] = "rbxassetid://74110220470369",
		["train-front-tunnel"] = "rbxassetid://105194827005114",
		["train-front"] = "rbxassetid://125237934215370",
		["train-track"] = "rbxassetid://77451032453723",
		["tram-front"] = "rbxassetid://93315182364998",
		["transgender"] = "rbxassetid://135530817673639",
		["trash-2"] = "rbxassetid://109843431391323",
		["trash"] = "rbxassetid://106723740584310",
		["tree-deciduous"] = "rbxassetid://123124389219004",
		["tree-palm"] = "rbxassetid://103846705893963",
		["tree-pine"] = "rbxassetid://124662547202594",
		["trees"] = "rbxassetid://121203841375919",
		["trello"] = "rbxassetid://130987241149527",
		["trending-down"] = "rbxassetid://139309232226438",
		["trending-up-down"] = "rbxassetid://85083293981691",
		["trending-up"] = "rbxassetid://81819858538839",
		["triangle-alert"] = "rbxassetid://125920361880643",
		["triangle-dashed"] = "rbxassetid://124324079103935",
		["triangle-right"] = "rbxassetid://116930791412791",
		["triangle"] = "rbxassetid://126330486745540",
		["trophy"] = "rbxassetid://131545003268773",
		["truck-electric"] = "rbxassetid://111873446387359",
		["truck"] = "rbxassetid://86662707764771",
		["turkish-lira"] = "rbxassetid://114589876174070",
		["turntable"] = "rbxassetid://129870346487856",
		["turtle"] = "rbxassetid://118295081560334",
		["tv-minimal-play"] = "rbxassetid://99201833426972",
		["tv-minimal"] = "rbxassetid://100382201729427",
		["tv"] = "rbxassetid://135687724791776",
		["twitch"] = "rbxassetid://71383308134888",
		["twitter"] = "rbxassetid://88791703276842",
		["type-outline"] = "rbxassetid://80108627791690",
		["type"] = "rbxassetid://133543553793564",
		["umbrella-off"] = "rbxassetid://72395143739955",
		["umbrella"] = "rbxassetid://127502210274589",
		["underline"] = "rbxassetid://123709229216544",
		["undo-2"] = "rbxassetid://113885292059932",
		["undo-dot"] = "rbxassetid://132055277744844",
		["undo"] = "rbxassetid://111258459077271",
		["unfold-horizontal"] = "rbxassetid://117128358526398",
		["unfold-vertical"] = "rbxassetid://116593025265499",
		["ungroup"] = "rbxassetid://106674800451003",
		["university"] = "rbxassetid://84652528263642",
		["unlink-2"] = "rbxassetid://128131898892572",
		["unlink"] = "rbxassetid://139835795227752",
		["unplug"] = "rbxassetid://90171381619874",
		["upload"] = "rbxassetid://138212042425501",
		["usb"] = "rbxassetid://117230058949613",
		["user-check"] = "rbxassetid://81775205032725",
		["user-cog"] = "rbxassetid://92795491530865",
		["user-lock"] = "rbxassetid://78892639693821",
		["user-minus"] = "rbxassetid://126976941957511",
		["user-pen"] = "rbxassetid://87445472574836",
		["user-plus"] = "rbxassetid://118514469915884",
		["user-round-check"] = "rbxassetid://118794737621941",
		["user-round-cog"] = "rbxassetid://78239503290053",
		["user-round-minus"] = "rbxassetid://98944176636447",
		["user-round-pen"] = "rbxassetid://108155244324878",
		["user-round-plus"] = "rbxassetid://113301899567470",
		["user-round-search"] = "rbxassetid://71565774381870",
		["user-round-x"] = "rbxassetid://122367980560930",
		["user-round"] = "rbxassetid://136485052187963",
		["user-search"] = "rbxassetid://101335649828115",
		["user-star"] = "rbxassetid://98777846316000",
		["user-x"] = "rbxassetid://139748155894754",
		["user"] = "rbxassetid://81589895647169",
		["users-round"] = "rbxassetid://103005444008339",
		["users"] = "rbxassetid://115398113982385",
		["utensils-crossed"] = "rbxassetid://109520762270383",
		["utensils"] = "rbxassetid://139952569804235",
		["utility-pole"] = "rbxassetid://101965541238242",
		["variable"] = "rbxassetid://104743088438151",
		["vault"] = "rbxassetid://108049164599845",
		["vector-square"] = "rbxassetid://86713728565344",
		["vegan"] = "rbxassetid://119489190688082",
		["venetian-mask"] = "rbxassetid://102636443033920",
		["venus-and-mars"] = "rbxassetid://120227752103771",
		["venus"] = "rbxassetid://82891342220859",
		["vibrate-off"] = "rbxassetid://113446447326246",
		["vibrate"] = "rbxassetid://108330910738733",
		["video-off"] = "rbxassetid://132239189859305",
		["video"] = "rbxassetid://107587444636945",
		["videotape"] = "rbxassetid://114816894323398",
		["view"] = "rbxassetid://118717253976805",
		["voicemail"] = "rbxassetid://134313454010227",
		["volleyball"] = "rbxassetid://83889351124153",
		["volume-1"] = "rbxassetid://98514588731639",
		["volume-2"] = "rbxassetid://89344380902620",
		["volume-off"] = "rbxassetid://103047478058767",
		["volume-x"] = "rbxassetid://139252359189540",
		["volume"] = "rbxassetid://103236289817396",
		["vote"] = "rbxassetid://89409762851246",
		["wallet-cards"] = "rbxassetid://129728715308337",
		["wallet-minimal"] = "rbxassetid://137800448816116",
		["wallet"] = "rbxassetid://132331555762628",
		["wallpaper"] = "rbxassetid://74682121235494",
		["wand-sparkles"] = "rbxassetid://82546429942392",
		["wand"] = "rbxassetid://114580617777835",
		["warehouse"] = "rbxassetid://78388887451080",
		["washing-machine"] = "rbxassetid://104194127573858",
		["watch"] = "rbxassetid://130544621618405",
		["waves-ladder"] = "rbxassetid://101808619355514",
		["waves"] = "rbxassetid://96340135183647",
		["waypoints"] = "rbxassetid://102450133666017",
		["webcam"] = "rbxassetid://104148487911129",
		["webhook-off"] = "rbxassetid://96370548093471",
		["webhook"] = "rbxassetid://112812457747322",
		["weight"] = "rbxassetid://103860559844854",
		["wheat-off"] = "rbxassetid://133294844612307",
		["wheat"] = "rbxassetid://85261952080359",
		["whole-word"] = "rbxassetid://90111083954485",
		["wifi-cog"] = "rbxassetid://110500263326209",
		["wifi-high"] = "rbxassetid://81954601342139",
		["wifi-low"] = "rbxassetid://138217335635913",
		["wifi-off"] = "rbxassetid://74113634330106",
		["wifi-pen"] = "rbxassetid://91290205064712",
		["wifi-sync"] = "rbxassetid://84043971055177",
		["wifi-zero"] = "rbxassetid://124286465246123",
		["wifi"] = "rbxassetid://104669375183960",
		["wind-arrow-down"] = "rbxassetid://127753987414870",
		["wind"] = "rbxassetid://114551690399915",
		["wine-off"] = "rbxassetid://108294164302317",
		["wine"] = "rbxassetid://115743721332829",
		["workflow"] = "rbxassetid://99186544029189",
		["worm"] = "rbxassetid://115752311548091",
		["wrench"] = "rbxassetid://112148279212860",
		["x"] = "rbxassetid://110786993356448",
		["youtube"] = "rbxassetid://123663668456341",
		["zap-off"] = "rbxassetid://81385483183652",
		["zap"] = "rbxassetid://130551565616516",
		["zoom-in"] = "rbxassetid://127956924984803",
		["zoom-out"] = "rbxassetid://108334162607319",
		["balloon"] = "rbxassetid://97489111621526",
		["beef-off"] = "rbxassetid://99869959725200",
		["book-search"] = "rbxassetid://132585409504950",
		["calendars"] = "rbxassetid://130944763042289",
		["cannabis-off"] = "rbxassetid://101938500363812",
		["cctv-off"] = "rbxassetid://75925370187295",
		["cigarette"] = "rbxassetid://137149549886852",
		["circle-pile"] = "rbxassetid://116353155251541",
		["cloud-backup"] = "rbxassetid://111649579696132",
		["cloud-sync"] = "rbxassetid://79393911188593",
		["database-search"] = "rbxassetid://92017137080138",
		["ellipse"] = "rbxassetid://71559658267482",
		["fingerprint-pattern"] = "rbxassetid://80934710831288",
		["fishing-hook"] = "rbxassetid://121038780855899",
		["fishing-rod"] = "rbxassetid://71754848048049",
		["form"] = "rbxassetid://72999643971000",
		["git-merge-conflict"] = "rbxassetid://85677801675703",
		["globe-off"] = "rbxassetid://77775243585824",
		["globe-x"] = "rbxassetid://109268097029296",
		["hd"] = "rbxassetid://71682790698278",
		["image"] = "rbxassetid://112751259236831",
		["layers-plus"] = "rbxassetid://77587765623057",
		["lens-concave"] = "rbxassetid://94819631937027",
		["lens-convex"] = "rbxassetid://74736504195474",
		["line-dot-right-horizontal"] = "rbxassetid://104718593155221",
		["line-style"] = "rbxassetid://90176717785772",
		["map-pin-search"] = "rbxassetid://89065012915078",
		["message-circle-check"] = "rbxassetid://132772297689418",
		["message-square-check"] = "rbxassetid://125789987055668",
		["metronome"] = "rbxassetid://101991829345965",
		["mirror-rectangular"] = "rbxassetid://109046769760336",
		["mirror-round"] = "rbxassetid://121534049429097",
		["mouse-left"] = "rbxassetid://99144293708743",
		["mouse-right"] = "rbxassetid://88331710212594",
		["printer-x"] = "rbxassetid://103002721801548",
		["radio-off"] = "rbxassetid://80359258046586",
		["road"] = "rbxassetid://120251329173530",
		["scooter"] = "rbxassetid://100035452787934",
		["search-alert"] = "rbxassetid://127597984617505",
		["shelving-unit"] = "rbxassetid://80116568514793",
		["shield-cog-corner"] = "rbxassetid://111694066132698",
		["shield-cog"] = "rbxassetid://129235695057857",
		["sport-shoe"] = "rbxassetid://120495992692630",
		["square-arrow-right-enter"] = "rbxassetid://138867831495334",
		["square-arrow-right-exit"] = "rbxassetid://133688575845430",
		["square-centerline-dashed-horizontal"] = "rbxassetid://77780104374341",
		["square-centerline-dashed-vertical"] = "rbxassetid://107878435803525",
		["stone"] = "rbxassetid://135161057497830",
		["toolbox"] = "rbxassetid://85341033903792",
		["towel-rack"] = "rbxassetid://125223915620991",
		["user-key"] = "rbxassetid://105403041782190",
		["user-round-key"] = "rbxassetid://124547549008939",
		["van"] = "rbxassetid://122066377022942",
		["waves-arrow-down"] = "rbxassetid://129215220911792",
		["waves-arrow-up"] = "rbxassetid://102314705716217",
		["weight-tilde"] = "rbxassetid://112081212176951",
		["x-line-top"] = "rbxassetid://140592656289509",
		["zodiac-aquarius"] = "rbxassetid://74560047770362",
		["zodiac-aries"] = "rbxassetid://73255859670234",
		["zodiac-cancer"] = "rbxassetid://131985162532947",
		["zodiac-capricorn"] = "rbxassetid://97859568140652",
		["zodiac-gemini"] = "rbxassetid://80997588122992",
		["zodiac-leo"] = "rbxassetid://75509406718106",
		["zodiac-libra"] = "rbxassetid://113222735060218",
		["zodiac-ophiuchus"] = "rbxassetid://129180108892480",
		["zodiac-pisces"] = "rbxassetid://95845819440327",
		["zodiac-sagittarius"] = "rbxassetid://82651026742181",
		["zodiac-scorpio"] = "rbxassetid://113640924054631",
		["zodiac-taurus"] = "rbxassetid://123053219704400",
		["zodiac-virgo"] = "rbxassetid://99462994613661",


		["fyyui-floating-logo"] = "rbxassetid://90051950241069",
	}
	end

	task.spawn(function()
		local ok, err = loadRemoteIconModule()
		if not ok then end
	end)

	local Toggle = {}
	Toggle.__index = Toggle

	function Toggle.new(parent, options, theme)
		local self = setmetatable({}, Toggle)
		self._setValueNoCallbackPosition = 3
		self.Text = options.Text or "Toggle"
		self.Description = options.Description
		self.Value = options.Default or false
		self.Callback = options.Callback or function() end
		self.Flag = options.Flag
		self.Enabled = true
		self.Theme = theme
		self.HasDesc = self.Description ~= nil and self.Description ~= ""
		local h = self.HasDesc and theme.DescHeight or theme.ElementHeight

		self.Container = U.Create("Frame", {
			Name = "Toggle",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Parent = parent,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = self.Container })

		self.Label = U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, -68, 0, 20),
			Position = UDim2.fromOffset(10, self.HasDesc and 6 or (h + 6 - 20) / 2 + 1),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = self.Container,
		})

		if self.HasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -68, 0, 16),
				Position = UDim2.fromOffset(10, 28),
				BackgroundTransparency = 1,
				Text = self.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = self.Container,
			})
		end

		self._tweenTrack = nil

		self.Track = U.Create("ImageButton", {
			Name = "Track",
			Size = UDim2.fromOffset(18, 18),
			Position = self.HasDesc and UDim2.new(1, -30, 0, 20) or UDim2.new(1, -30, 0.5, -9),
			BackgroundColor3 = self.Value and theme.ToggleOn or theme.ToggleOff,
			AutoButtonColor = false,
			Parent = self.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = self.Track })
		self._trackStroke = U.Create("UIStroke", {
			Color = self.Value and theme.ToggleOn or theme.ElementBorder,
			Transparency = self.Value and 0 or 0.15,
			Thickness = 1,
			Parent = self.Track,
		})
		self.Track.MouseEnter:Connect(function()
			if not self.Enabled then
				return
			end
			self.Track.BackgroundColor3 = self.Value and self.Theme.ToggleOn or self.Theme.ElementHover
		end)
		self.Track.MouseLeave:Connect(function()
			if not self.Enabled then
				return
			end
			self.Track.BackgroundColor3 = self.Value and self.Theme.ToggleOn or self.Theme.ToggleOff
		end)
		self.Track.Activated:Connect(function()
			if not self.Enabled then
				return
			end
			self:SetValue(not self.Value)
		end)

		return self
	end

	function Toggle:_animate(value, instant)
		if self._tweenTrack then
			self._tweenTrack:Cancel()
		end
		local ts = game:GetService("TweenService")
		if instant then
			self.Track.BackgroundColor3 = value and self.Theme.ToggleOn or self.Theme.ToggleOff
			self._trackStroke.Color = value and self.Theme.ToggleOn or self.Theme.ElementBorder
			self._trackStroke.Transparency = value and 0 or 0.15
		else
			local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			self._tweenTrack = ts:Create(self.Track, ti, {
				BackgroundColor3 = value and self.Theme.ToggleOn or self.Theme.ToggleOff,
			})
			self._tweenTrack:Play()
			ts:Create(self._trackStroke, ti, {
				Color = value and self.Theme.ToggleOn or self.Theme.ElementBorder,
				Transparency = value and 0 or 0.15,
			}):Play()
		end
	end

	function Toggle:SetValue(value, instant, noCallback)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if type(value) ~= "boolean" then
			return false, "expected boolean"
		end
		if self.Value == value then
			return true
		end
		self.Value = value
		self:_animate(value, instant)
		if not noCallback then
			task.spawn(function()
				self.Callback(value)
			end)
		end
		return true
	end

	function Toggle:GetValue()
		return self.Value
	end
	function Toggle:SetEnabled(enabled)
		self.Enabled = enabled
		local t = enabled and 0 or 0.5
		self.Track.BackgroundTransparency = t
	end
	function Toggle:SetText(text)
		self.Text = text
		self.Label.Text = text
	end
	function Toggle:SetDescription(desc)
		self.Description = desc
		local d = self.Container:FindFirstChild("Description")
		if d then
			d.Text = desc or ""
		end
	end
	function Toggle:Destroy()
		if self._destroyed then
			return
		end
		cleanupController(self)
		if self.Container then
			self.Container:Destroy()
		end
	end

	function Toggle:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		self.Container.BackgroundColor3 = theme.Element
		local stroke = self.Container:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = theme.ElementBorder
		end
		self.Label.Font = theme.Font
		self.Label.TextSize = theme.FontSize
		self.Label.TextColor3 = theme.TextPrimary
		local desc = self.Container:FindFirstChild("Description")
		if desc then
			desc.Font = theme.Font
			desc.TextSize = theme.FontSizeSmall
			desc.TextColor3 = theme.TextMuted
		end
		self.Track.BackgroundColor3 = self.Value and theme.ToggleOn or theme.ToggleOff
		if self._trackStroke then
			self._trackStroke.Color = self.Value and theme.ToggleOn or theme.ElementBorder
			self._trackStroke.Transparency = self.Value and 0 or 0.15
		end
	end

	local Slider = {}
	Slider.__index = Slider

	function Slider.new(parent, options, theme)
		local self = setmetatable({}, Slider)
		self.Text = options.Text or "Slider"
		self.Description = options.Description
		self.Min = options.Min == nil and 0 or options.Min
		self.Max = options.Max == nil and 100 or options.Max
		self.Step = options.Step == nil and 1 or options.Step
		assert(
			isFiniteNumber(self.Min) and isFiniteNumber(self.Max) and self.Min <= self.Max,
			"FyyUI Slider: Min and Max must be finite numbers with Min <= Max"
		)
		assert(isFiniteNumber(self.Step) and self.Step > 0, "FyyUI Slider: Step must be a finite number greater than zero")
		local default = options.Default == nil and self.Min or options.Default
		assert(isFiniteNumber(default), "FyyUI Slider: Default must be a finite number")
		self.Value = math.clamp(default, self.Min, self.Max)
		self.Suffix = options.Suffix or ""
		self.Callback = options.Callback or function() end
		self.Flag = options.Flag
		self.Theme = theme
		self.HasDesc = self.Description ~= nil and self.Description ~= ""
		self._inOneToOneColumn = options._inOneToOneColumn == true
		local baseH = self.HasDesc and theme.DescHeight or theme.ElementHeight

		local h = baseH + 24
		local textWidth = -92
		local textY = self.HasDesc and 6 or 7

		self.Container = U.Create("Frame", {
			Name = "Slider",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Parent = parent,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = self.Container })

		self.Label = U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, textWidth, 0, 20),
			Position = UDim2.fromOffset(10, textY),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = self.Container,
		})

		self.ValueLabel = U.Create("TextLabel", {
			Name = "Value",
			Size = UDim2.fromOffset(54, 20),
			Position = UDim2.new(1, -68, 0, textY),
			BackgroundTransparency = 1,
			Text = tostring(self.Value) .. self.Suffix,
			Font = theme.FontBold,
			TextSize = theme.FontSize,
			TextColor3 = theme.Accent,
			TextXAlignment = Enum.TextXAlignment.Right,
			RichText = true,
			Parent = self.Container,
		})

		local trackH = 7
		local fillPct = (self.Max ~= self.Min) and (self.Value - self.Min) / (self.Max - self.Min) or 0

		self.Track = U.Create("ImageButton", {
			Name = "Track",
			Size = UDim2.new(1, -24, 0, 18),
			Position = UDim2.new(0, 12, 1, -22),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Parent = self.Container,
		})
		self.Rail = U.Create("Frame", {
			Name = "Rail",
			Size = UDim2.new(1, 0, 0, trackH),
			Position = UDim2.new(0, 0, 0.5, -trackH / 2),
			BackgroundColor3 = theme.ElementHover,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = self.Track,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = self.Rail })

		self.Fill = U.Create("Frame", {
			Name = "Fill",
			Size = UDim2.new(fillPct, 0, 1, 0),
			BackgroundColor3 = theme.Accent,
			BorderSizePixel = 0,
			Parent = self.Rail,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = self.Fill })

		local uis = game:GetService("UserInputService")

		local function roundToStep(v)
			return math.round(v / self.Step) * self.Step
		end

		local dragging = false
		local activeTrackTouch = false
		local function valueFromInput(input)
			local absPos = self.Track.AbsolutePosition.X
			local size = self.Track.AbsoluteSize.X
			if size <= 0 then
				return nil
			end
			local pct = math.clamp((input.Position.X - absPos) / size, 0, 1)
			local val = self.Min + (self.Max - self.Min) * pct
			return math.clamp(roundToStep(val), self.Min, self.Max)
		end
		local dragCon
		dragCon = uis.InputChanged:Connect(function(input, processed)
			local t = input.UserInputType
			if t ~= Enum.UserInputType.MouseMovement and t ~= Enum.UserInputType.Touch then
				return
			end
			if dragging then
				if processed and t == Enum.UserInputType.MouseMovement then
					return
				end
				local val = valueFromInput(input)
				if val then
					self:SetValue(val)
				end
			end
		end)

		self._sliderEndCon = uis.InputEnded:Connect(function(input)
			local t = input.UserInputType
			if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
				dragging = false
				activeTrackTouch = false
			end
		end)
		self._dragCon = dragCon


		self.Track.InputBegan:Connect(function(input)
			local t = input.UserInputType
			if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
				dragging = true
				activeTrackTouch = t == Enum.UserInputType.Touch
			end
			if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
				local val = valueFromInput(input)
				if val then
					self:SetValue(val)
				end
			end
		end)

		if self.HasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -24, 0, 16),
				Position = UDim2.fromOffset(12, 34),
				BackgroundTransparency = 1,
				Text = self.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = self.Container,
			})
		end

		return self
	end

	function Slider:_updateKnobPos()

		local pct = (self.Max ~= self.Min) and (self.Value - self.Min) / (self.Max - self.Min) or 0
		pct = math.clamp(pct, 0, 1)
		self.Fill.Size = UDim2.new(pct, 0, 1, 0)
	end

	function Slider:SetValue(v, noCallback)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if not isFiniteNumber(v) then
			return false, "expected finite number"
		end
		v = math.clamp(v, self.Min, self.Max)
		if self.Value == v then
			return true
		end
		self.Value = v
		local pct = (self.Max ~= self.Min) and (v - self.Min) / (self.Max - self.Min) or 0
		pct = math.clamp(pct, 0, 1)
		if self._valueTween then
			self._valueTween:Cancel()
		end
		self._valueTween = game:GetService("TweenService"):Create(
			self.Fill,
			TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{ Size = UDim2.new(pct, 0, 1, 0) }
		)
		self._valueTween:Play()
		self.ValueLabel.Text = tostring(v) .. self.Suffix
		if not noCallback then
			task.spawn(function()
				self.Callback(v)
			end)
		end
		return true
	end

	function Slider:GetValue()
		return self.Value
	end
	function Slider:Destroy()
		if self._destroyed then
			return
		end
		cleanupController(self)
		if self._dragCon then
			self._dragCon:Disconnect()
		end
		if self._sliderEndCon then
			self._sliderEndCon:Disconnect()
		end
		if self.Container then
			self.Container:Destroy()
		end
	end

	function Slider:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		self.Container.BackgroundColor3 = theme.Element
		local stroke = self.Container:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = theme.ElementBorder
		end
		self.Label.Font = theme.Font
		self.Label.TextSize = theme.FontSize
		self.Label.TextColor3 = theme.TextPrimary
		self.ValueLabel.Font = theme.FontBold
		self.ValueLabel.TextSize = theme.FontSize
		self.ValueLabel.TextColor3 = theme.Accent
		local desc = self.Container:FindFirstChild("Description")
		if desc then
			desc.Font = theme.Font
			desc.TextSize = theme.FontSizeSmall
			desc.TextColor3 = theme.TextMuted
		end
		self.Rail.BackgroundColor3 = theme.ElementHover
		self.Fill.BackgroundColor3 = theme.Accent
	end

	local ColorPicker = {}
	ColorPicker.__index = ColorPicker

	function ColorPicker.new(parent, options, theme)
		options = options or {}
		local self = setmetatable({}, ColorPicker)
		self._setValueNoCallbackPosition = 3
		self.Text = options.Text or "Color"
		self.Description = options.Description
		self.Callback = options.Callback or function() end
		self.Flag = options.Flag
		self._isColorPicker = true
		self.Theme = theme
		self.Open = options.Open == true
		self.HasDesc = self.Description ~= nil and self.Description ~= ""
		self.Value = typeof(options.Default) == "Color3" and options.Default or theme.Accent
		self.Hue, self.Saturation, self.Brightness = self.Value:ToHSV()

		local baseH = self.HasDesc and theme.DescHeight or theme.ElementHeight
		self._closedHeight = baseH + 6
		self._openHeight = self._closedHeight + 116
		self.Container = U.Create("Frame", {
			Name = "ColorPicker",
			Size = UDim2.new(1, -12, 0, self.Open and self._openHeight or self._closedHeight),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = parent,
		})
		self.Container:SetAttribute(
			"FyyDescriptionBaseHeight",
			self.Open and self._openHeight or self._closedHeight
		)
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Container })
		U.Create("UIStroke", {
			Color = theme.ElementBorder,
			Transparency = 0.6,
			Thickness = 1,
			Parent = self.Container,
		})

		self.Label = U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, -54, 0, 20),
			Position = UDim2.fromOffset(10, self.HasDesc and 6 or (baseH + 6 - 20) / 2 + 1),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = self.Container,
		})
		if self.HasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -54, 0, 16),
				Position = UDim2.fromOffset(10, 28),
				BackgroundTransparency = 1,
				Text = self.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = self.Container,
			})
		end

		self.Swatch = U.Create("ImageButton", {
			Name = "Swatch",
			Size = UDim2.fromOffset(20, 20),
			Position = UDim2.new(1, -32, 0, (self._closedHeight - 20) / 2),
			BackgroundColor3 = self.Value,
			AutoButtonColor = false,
			Parent = self.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.Swatch })
		self._swatchStroke = U.Create("UIStroke", {
			Color = theme.TextPrimary,
			Transparency = 0.65,
			Thickness = 1,
			Parent = self.Swatch,
		})

		self.PickerArea = U.Create("Frame", {
			Name = "PickerArea",
			Size = UDim2.fromOffset(128, 108),
			Position = UDim2.new(0.5, -64, 0, self._closedHeight + 2),
			BackgroundTransparency = 1,
			Visible = self.Open,
			Parent = self.Container,
		})
		local function updateDescriptionLayout()
			local descriptionGrowth = self.Container:GetAttribute("FyyDescriptionGrowth") or 0
			self.PickerArea.Position = UDim2.new(0.5, -64, 0, self._closedHeight + descriptionGrowth + 2)
			local targetHeight = (self.Open and self._openHeight or self._closedHeight) + descriptionGrowth
			self.Container.Size = UDim2.new(1, -12, 0, targetHeight)
		end
		self.Container:GetAttributeChangedSignal("FyyDescriptionGrowth"):Connect(updateDescriptionLayout)
		task.defer(updateDescriptionLayout)
		local squareSize = 88
		self.SV = U.Create("ImageButton", {
			Name = "SaturationValue",
			Size = UDim2.fromOffset(squareSize, squareSize),
			Position = UDim2.fromOffset(4, 4),
			BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1),
			AutoButtonColor = false,
			ClipsDescendants = true,
			Parent = self.PickerArea,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.SV })
		self._svStroke = U.Create("UIStroke", {
			Color = theme.TextPrimary,
			Thickness = 2,
			Transparency = 0.72,
			Parent = self.SV,
		})

		local whiteLayer = U.Create("Frame", {
			Name = "WhiteLayer",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Parent = self.SV,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = whiteLayer })
		U.Create("UIGradient", {
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Parent = whiteLayer,
		})
		local blackLayer = U.Create("Frame", {
			Name = "BlackLayer",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			Parent = self.SV,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = blackLayer })
		U.Create("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(1, 0),
			}),
			Parent = blackLayer,
		})
		self.SVCursor = U.Create("Frame", {
			Name = "Cursor",
			Size = UDim2.fromOffset(9, 9),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ZIndex = 4,
			Parent = self.SV,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.SVCursor })
		U.Create("UIStroke", {
			Color = Color3.new(1, 1, 1),
			Thickness = 1.5,
			Transparency = 0.05,
			Parent = self.SVCursor,
		})

		self.HueBar = U.Create("ImageButton", {
			Name = "Hue",
			Size = UDim2.fromOffset(16, squareSize),
			Position = UDim2.fromOffset(100, 4),
			BackgroundColor3 = Color3.new(1, 1, 1),
			AutoButtonColor = false,
			ClipsDescendants = false,
			Parent = self.PickerArea,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.HueBar })
		U.Create("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
				ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
			}),
			Parent = self.HueBar,
		})
		self.HueCursor = U.Create("Frame", {
			Name = "HueCursor",
			Size = UDim2.new(1, 4, 0, 3),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, self.Hue, 0),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			ZIndex = 4,
			Parent = self.HueBar,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.HueCursor })

		self.HexLabel = U.Create("TextLabel", {
			Name = "Hex",
			Size = UDim2.fromOffset(120, 14),
			Position = UDim2.fromOffset(4, 94),
			BackgroundTransparency = 1,
			Font = theme.FontBold,
			TextSize = theme.FontSizeSmall,
			TextColor3 = theme.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = self.PickerArea,
		})

		function self:_refreshVisuals()
			self.Value = Color3.fromHSV(self.Hue, self.Saturation, self.Brightness)
			self.SV.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
			self.Swatch.BackgroundColor3 = self.Value
			self.SVCursor.Position = UDim2.fromScale(self.Saturation, 1 - self.Brightness)
			self.HueCursor.Position = UDim2.new(0.5, 0, self.Hue, 0)
			self.HexLabel.Text = string.format(
				"#%02X%02X%02X",
				math.floor(self.Value.R * 255 + 0.5),
				math.floor(self.Value.G * 255 + 0.5),
				math.floor(self.Value.B * 255 + 0.5)
			)
		end

		local function fireChanged()
			self:_refreshVisuals()
			local value = self.Value
			task.spawn(function()
				self.Callback(value)
			end)
		end
		local function updateSV(input)
			local size = self.SV.AbsoluteSize
			if size.X <= 0 or size.Y <= 0 then
				return
			end
			self.Saturation = math.clamp((input.Position.X - self.SV.AbsolutePosition.X) / size.X, 0, 1)
			self.Brightness = 1 - math.clamp((input.Position.Y - self.SV.AbsolutePosition.Y) / size.Y, 0, 1)
			fireChanged()
		end
		local function updateHue(input)
			local height = self.HueBar.AbsoluteSize.Y
			if height <= 0 then
				return
			end
			self.Hue = math.clamp((input.Position.Y - self.HueBar.AbsolutePosition.Y) / height, 0, 1)
			fireChanged()
		end

		local draggingSV, draggingHue = false, false
		self.SV.InputBegan:Connect(function(input)
			local kind = input.UserInputType
			if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
				draggingSV = true
				updateSV(input)
			end
		end)
		self.HueBar.InputBegan:Connect(function(input)
			local kind = input.UserInputType
			if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
				draggingHue = true
				updateHue(input)
			end
		end)
		local uis = game:GetService("UserInputService")
		self._pickerMoveCon = uis.InputChanged:Connect(function(input)
			local kind = input.UserInputType
			if kind ~= Enum.UserInputType.MouseMovement and kind ~= Enum.UserInputType.Touch then
				return
			end
			if draggingSV then
				updateSV(input)
			elseif draggingHue then
				updateHue(input)
			end
		end)
		self._pickerEndCon = uis.InputEnded:Connect(function(input)
			local kind = input.UserInputType
			if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
				draggingSV = false
				draggingHue = false
			end
		end)
		self.Swatch.Activated:Connect(function()
			self:SetOpen(not self.Open)
		end)
		self:_refreshVisuals()
		return self
	end

	function ColorPicker:SetOpen(open, instant)
		if self._destroyed then
			return false, "destroyed"
		end
		self.Open = open == true
		self.Container:SetAttribute(
			"FyyDescriptionBaseHeight",
			self.Open and self._openHeight or self._closedHeight
		)
		if self.Open then
			self.PickerArea.Visible = true
		end
		local descriptionGrowth = self.Container:GetAttribute("FyyDescriptionGrowth") or 0
		local target = (self.Open and self._openHeight or self._closedHeight) + descriptionGrowth
		if self._sizeTween then
			self._sizeTween:Cancel()
		end
		if instant then
			self.Container.Size = UDim2.new(1, -12, 0, target)
			self.PickerArea.Visible = self.Open
		else
			self._sizeTween = game:GetService("TweenService"):Create(
				self.Container,
				TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Size = UDim2.new(1, -12, 0, target) }
			)
			if not self.Open then
				self._sizeTween.Completed:Connect(function()
					if not self.Open and self.PickerArea then
						self.PickerArea.Visible = false
					end
				end)
			end
			self._sizeTween:Play()
		end
		return true
	end

	function ColorPicker:SetValue(value, instant, noCallback)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if type(value) == "table" and #value == 3 then
			value = Color3.new(value[1], value[2], value[3])
		end
		if typeof(value) ~= "Color3" then
			return false, "expected Color3"
		end
		self.Hue, self.Saturation, self.Brightness = value:ToHSV()
		self:_refreshVisuals()
		if not noCallback then
			task.spawn(function()
				self.Callback(self.Value)
			end)
		end
		return true
	end

	function ColorPicker:SetColor(value, noCallback)
		return self:SetValue(value, false, noCallback)
	end

	function ColorPicker:GetValue()
		return self.Value
	end

	function ColorPicker:Destroy()
		if self._destroyed then
			return
		end
		cleanupController(self)
		if self._pickerMoveCon then
			self._pickerMoveCon:Disconnect()
		end
		if self._pickerEndCon then
			self._pickerEndCon:Disconnect()
		end
		if self.Container then
			self.Container:Destroy()
		end
	end

	function ColorPicker:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		self.Container.BackgroundColor3 = theme.Element
		local stroke = self.Container:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = theme.ElementBorder
		end
		self.Label.Font = theme.Font
		self.Label.TextSize = theme.FontSize
		self.Label.TextColor3 = theme.TextPrimary
		local desc = self.Container:FindFirstChild("Description")
		if desc then
			desc.Font = theme.Font
			desc.TextSize = theme.FontSizeSmall
			desc.TextColor3 = theme.TextMuted
		end
		self.HexLabel.Font = theme.FontBold
		self.HexLabel.TextSize = theme.FontSizeSmall
		self.HexLabel.TextColor3 = theme.TextMuted
		self._swatchStroke.Color = theme.TextPrimary
		if self._svStroke then
			self._svStroke.Color = theme.TextPrimary
		end
	end

	local Dropdown = {}
	Dropdown.__index = Dropdown

	function Dropdown.new(parent, options, theme, menuRef)
		local self = setmetatable({}, Dropdown)
		self._menu = menuRef
		self.Text = options.Text or "Dropdown"
		self.Description = options.Description
		assert(options.Options == nil or type(options.Options) == "table", "FyyUI Dropdown: Options must be a table")
		self.Options = options.Options or {}
		local function hasOption(value)
			for _, option in ipairs(self.Options) do
				if option == value then
					return true
				end
			end
			return false
		end
		self.Multi = options.Multi or false

		self.AllowNone = options.AllowNone
		if self.AllowNone == nil then
			self.AllowNone = true
		end
		self.Value = ""
		if options.Default ~= nil then
			self.Value = options.Default
		elseif self.Options[1] and not options.Placeholder then
			self.Value = self.Options[1]
		end

		if not self.Multi and not self.AllowNone and #self.Options > 0 and (self.Value == nil or self.Value == "") then
			self.Value = self.Options[1]
		end
		if not self.Multi and self.Value ~= nil and self.Value ~= "" and not hasOption(self.Value) then
			self.Value = self.AllowNone and "" or self.Options[1] or ""
		end
		self.Placeholder = options.Placeholder or "Not selected"
		self._selected = {}
		self._selectedCount = 0
		if self.Multi then
			local defaults = {}
			if type(options.Default) == "table" then
				defaults = options.Default
			elseif options.Default ~= nil then
				defaults = { options.Default }
			end
			for _, v in ipairs(defaults) do
				if hasOption(v) and not self._selected[v] then
					self._selected[v] = true
					self._selectedCount = self._selectedCount + 1
				end
			end
		end
		self.Callback = options.Callback or function() end
		self.Flag = options.Flag
		self.Theme = theme
		self.Open = false
		self.HasDesc = self.Description ~= nil and self.Description ~= ""

		local h = (self.HasDesc and theme.DescHeight or theme.ElementHeight) + 38

		self.Container = U.Create("Frame", {
			Name = "Dropdown",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Parent = parent,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = self.Container })

		U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, -20, 0, 20),
			Position = UDim2.fromOffset(10, 6),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = self.Container,
		})

		self.SelectBtn = U.Create("ImageButton", {
			Name = "Select",
			Size = UDim2.new(1, -20, 0, 32),
			Position = UDim2.new(0, 10, 1, -38),
			BackgroundColor3 = theme.Background,
			AutoButtonColor = false,
			Parent = self.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = self.SelectBtn })
		self._selectStroke = U.Create("UIStroke", {
			Color = theme.ElementBorder,
			Thickness = 1,
			Transparency = 0.15,
			Parent = self.SelectBtn,
		})
		local function initSelectText()
			return self:_displayText()
		end
		local function initSelectColor()
			if self.Multi then
				return self._selectedCount > 0 and theme.TextPrimary or theme.TextMuted
			end
			return (self.Value and self.Value ~= "") and theme.TextPrimary or theme.TextMuted
		end
		self.SelectText = U.Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, -38, 1, 0),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = initSelectText(),
			TextColor3 = initSelectColor(),
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = self.SelectBtn,
		})

		self._arrowDown = resolveIcon("chevron-down") or { Image = "rbxassetid://134243273101015" }
		self._arrow = renderIcon(self.SelectBtn, "chevron-down", {
			Name = "Arrow",
			Size = UDim2.fromOffset(15, 15),
			Position = UDim2.new(1, -22, 0.5, -7),
			ImageColor3 = theme.TextMuted,
		})

		self.SelectBtn.MouseEnter:Connect(function()
			if self.Open then
				return
			end
			game:GetService("TweenService"):Create(
				self._selectStroke,
				TweenInfo.new(0.14),
				{ Color = self.Theme.Accent, Transparency = 0.35 }
			):Play()
		end)
		self.SelectBtn.MouseLeave:Connect(function()
			if self.Open then
				return
			end
			game:GetService("TweenService"):Create(
				self._selectStroke,
				TweenInfo.new(0.14),
				{ Color = self.Theme.ElementBorder, Transparency = 0.15 }
			):Play()
		end)


		local selectedIdx = 0
		for i, opt in ipairs(self.Options) do
			if opt == self.Value then
				selectedIdx = i
				break
			end
		end


		self.SelectBtn.Activated:Connect(function()
			if not self._menu then
				return
			end
			if self._menu._activePopupFrame and self._menu._activeDropdown == self then
				self.Open = false
				if self._arrow then
					game:GetService("TweenService"):Create(self._arrow, TweenInfo.new(0.16), { Rotation = 0 }):Play()
				end
				self._menu:HideDropdownPopup()
				return
			end
			if self._menu._activePopupFrame then
				self._menu:HideDropdownPopup()
			end
			local pos = self.SelectBtn.AbsolutePosition
			local siz = self.SelectBtn.AbsoluteSize
			self._selIdx = 0
			for i, opt in ipairs(self.Options) do
				if opt == self.Value then
					self._selIdx = i
					break
				end
			end
			local shown = self._menu:ShowDropdownPopup(
				pos,
				siz,
				self.Options,
				self._selIdx,
				function(idx, val)
					self:SetValue(val)
				end,
				self.Multi,
				self
			)
			if shown then
				self.Open = true
				self._selectStroke.Color = self.Theme.Accent
				self._selectStroke.Transparency = 0
				if self._arrow then
					game:GetService("TweenService"):Create(self._arrow, TweenInfo.new(0.18), { Rotation = 180 }):Play()
				end
				self._menu._activeDropdown = self
			else
				self.Open = false
				if self._arrow then
					self._arrow.Rotation = 0
				end
			end
		end)

		if self.HasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -20, 0, 16),
				Position = UDim2.fromOffset(10, 28),
				BackgroundTransparency = 1,
				Text = self.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = self.Container,
			})
		end


		if options.Tooltip and menuRef then
			menuRef:BindTooltip(self.Container, options.Tooltip)
		end

		return self
	end

	function Dropdown:_updateDisplay()

		self.SelectText.Text = self:_displayText()
		if self.Multi then
			self.SelectText.TextColor3 = (self._selectedCount > 0) and self.Theme.TextPrimary or self.Theme.TextMuted
		else
			self.SelectText.TextColor3 = (self.Value ~= "") and self.Theme.TextPrimary or self.Theme.TextMuted
		end
	end

	function Dropdown:SetValue(v, noCallback)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if self.Multi then

			if not self:_optIndex(self.Options, v) then
				return false, "unknown option"
			end
			if self._selected[v] then
				self._selected[v] = nil
				self._selectedCount = math.max(0, self._selectedCount - 1)
			else
				self._selected[v] = true
				self._selectedCount = self._selectedCount + 1
			end

			self.SelectText.Text = self:_displayText()
			self.SelectText.TextColor3 = (self._selectedCount > 0) and self.Theme.TextPrimary or self.Theme.TextMuted
			if not noCallback then
				local snapshot = self:GetValue()
				task.spawn(function()
					self.Callback(snapshot)
				end)
			end
			return true
		end


		if v == self.Value then
			if self.AllowNone then

				self.Value = ""
				self.SelectText.Text = self.Placeholder
				self.SelectText.TextColor3 = self.Theme.TextMuted
				if self._selectStroke then
					self._selectStroke.Transparency = 0.8
				end
				self._selIdx = 0
				self.Open = false
				if self._arrow then
					applyIconToLabel(self._arrow, self._arrowDown)
					self._arrow.Rotation = 0
				end
				if self._menu and self._menu._activeDropdown == self then
					self._menu._activeDropdown = nil
					self._menu:HideDropdownPopup()
				end
				if not noCallback then
					task.spawn(function()
						self.Callback("")
					end)
				end
				return true
			end
			if self._arrow then
				applyIconToLabel(self._arrow, self._arrowDown)
				self._arrow.Rotation = 0
			end
			if self._menu and self._menu._activeDropdown == self then
				self._menu._activeDropdown = nil
				self._menu:HideDropdownPopup()
			end
			return true
		end

		if not self.AllowNone and #self.Options > 0 and v == "" then
			if self._arrow then
				applyIconToLabel(self._arrow, self._arrowDown)
				self._arrow.Rotation = 0
			end
			if self._menu and self._menu._activeDropdown == self then
				self._menu._activeDropdown = nil
				self._menu:HideDropdownPopup()
			end
			return true
		end
		if v ~= "" and not self:_optIndex(self.Options, v) then
			return false, "unknown option"
		end
		self.Value = v
		self.SelectText.Text = self:_displayText()
		self.SelectText.TextColor3 = (self.Value ~= "") and self.Theme.TextPrimary or self.Theme.TextMuted
		if self._selectStroke then
			self._selectStroke.Transparency = (self.Value ~= "") and 0.5 or 0.8
		end
		self._selIdx = 0
		for i, opt in ipairs(self.Options) do
			if opt == v then
				self._selIdx = i
				break
			end
		end
		self.Open = false
		if self._arrow then
			applyIconToLabel(self._arrow, self._arrowDown)
			self._arrow.Rotation = 0
		end
		if self._menu and self._menu._activeDropdown == self then
			self._menu._activeDropdown = nil
			self._menu:HideDropdownPopup()
		end
		if not noCallback then
			task.spawn(function()
				self.Callback(v)
			end)
		end
		return true
	end

	function Dropdown:GetValue()
		if self.Multi then
			local result = {}
			for _, opt in ipairs(self.Options) do
				if self._selected[opt] then
					table.insert(result, opt)
				end
			end
			return result
		end
		return self.Value
	end

	function Dropdown:SetOptions(options, preferredValue, noCallback)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if options == nil then
			options = {}
		end
		if type(options) ~= "table" then
			return false, "expected options table"
		end
		local oldValue = self:GetValue()
		local function sameSelection(a, b)
			if type(a) ~= "table" or type(b) ~= "table" then
				return a == b
			end
			if #a ~= #b then
				return false
			end
			for i, value in ipairs(a) do
				if b[i] ~= value then
					return false
				end
			end
			return true
		end


		self.Options = {}
		for i, option in ipairs(options) do
			self.Options[i] = option
		end
		options = self.Options

		if self.Multi then

			local optSet = {}
			for _, opt in ipairs(options) do
				optSet[opt] = true
			end
			for k in pairs(self._selected) do
				if not optSet[k] then
					self._selected[k] = nil
					self._selectedCount = math.max(0, self._selectedCount - 1)
				end
			end
		else

			local newValue
			if preferredValue ~= nil then
				if self:_optIndex(options, preferredValue) then
					newValue = preferredValue
				elseif #options == 0 or self.AllowNone then
					newValue = ""
				else
					newValue = options[1]
				end
			elseif self.Value ~= "" and self:_optIndex(options, self.Value) then
				newValue = self.Value
			elseif #options == 0 or self.AllowNone then
				newValue = ""
			else
				newValue = options[1]
			end

			self.Value = newValue


			if self._selectStroke then
				self._selectStroke.Transparency = (self.Value ~= "" and self.Value ~= (options[1] or "")) and 0.5 or 0.8
			end


			self._selIdx = 0
			for i, opt in ipairs(options) do
				if opt == self.Value then
					self._selIdx = i
					break
				end
			end
		end


		self:_updateDisplay()


		if self._menu and self._menu._activeDropdown == self and self._menu._activePopupFrame then
			self._menu._activeDropdown = nil
			self._menu:HideDropdownPopup()
			if #options > 0 then
				local pos = self.SelectBtn.AbsolutePosition
				local siz = self.SelectBtn.AbsoluteSize
				local selIdx = 0
				for i, opt in ipairs(options) do
					if opt == self.Value then
						selIdx = i
						break
					end
				end
				local shown = self._menu:ShowDropdownPopup(pos, siz, options, selIdx, function(idx, val)
					self:SetValue(val)
				end, self.Multi, self)
				if shown then
					self.Open = true
					self._selectStroke.Color = self.Theme.Accent
					self._selectStroke.Transparency = 0
					if self._arrow then
						self._arrow.Rotation = 180
					end
					self._menu._activeDropdown = self
				else
					self.Open = false
					if self._arrow then
						applyIconToLabel(self._arrow, self._arrowDown)
						self._arrow.Rotation = 0
					end
				end
			end
		end


		if not noCallback then
			if self.Multi then
				local newValue = self:GetValue()
				if not sameSelection(oldValue, newValue) then
					task.spawn(function()
						self.Callback(newValue)
					end)
				end
			else
				local newValue = self.Value
				if newValue ~= oldValue then
					task.spawn(function()
						self.Callback(newValue)
					end)
				end
			end
		end
		return true
	end





	function Dropdown:_displayText()
		if self.Multi then
			if self._selectedCount == 0 then
				return self.Placeholder
			end
			local first
			local extras = 0
			for _, opt in ipairs(self.Options) do
				if self._selected[opt] then
					if first == nil then
						first = opt
					else
						extras = extras + 1
					end
				end
			end
			if extras == 0 then
				return tostring(first)
			end
			return tostring(first) .. " +" .. extras
		end
		return (self.Value ~= "") and tostring(self.Value) or self.Placeholder
	end

	function Dropdown:_optIndex(list, value)
		for i, v in ipairs(list) do
			if v == value then
				return i
			end
		end
		return nil
	end

	function Dropdown:Refresh(options, preferredValue, noCallback)
		if options ~= nil then
			return self:SetOptions(options, preferredValue, noCallback)
		else

			return self:SetOptions(self.Options, self.Value, noCallback)
		end
	end

	function Dropdown:Destroy()
		if self._destroyed then
			return
		end
		cleanupController(self)
		if self.Container then
			self.Container:Destroy()
		end
	end

	function Dropdown:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		self.Container.BackgroundColor3 = theme.Element
		local stroke = self.Container:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = theme.ElementBorder
		end
		local lbl = self.Container:FindFirstChild("Label")
		if lbl then
			lbl.Font = theme.Font
			lbl.TextSize = theme.FontSize
			lbl.TextColor3 = theme.TextPrimary
		end
		local desc = self.Container:FindFirstChild("Description")
		if desc then
			desc.Font = theme.Font
			desc.TextSize = theme.FontSizeSmall
			desc.TextColor3 = theme.TextMuted
		end
		self.SelectBtn.BackgroundColor3 = theme.Background
		self.SelectText.Font = theme.Font
		self.SelectText.TextSize = theme.FontSize
		self.SelectText.TextColor3 = theme.TextPrimary
		if self._selectStroke then
			self._selectStroke.Color = self.Open and theme.Accent or theme.ElementBorder
			self._selectStroke.Transparency = self.Open and 0 or 0.15
		end
		if self._arrow then
			if self._arrow:IsA("ImageLabel") then
				self._arrow.ImageColor3 = theme.TextMuted
			else
				self._arrow.TextColor3 = theme.TextMuted
			end
		end
	end

	local Keybind = {}
	Keybind.__index = Keybind

	function Keybind.new(parent, options, theme, menuRef)
		local self = setmetatable({}, Keybind)
		self.Text = options.Text or "Keybind"
		self.Description = options.Description
		self.Mode = options.Mode or "Toggle"
		assert(self.Mode == "Toggle" or self.Mode == "Hold", "FyyUI Keybind: Mode must be Toggle or Hold")
		self.Callback = options.Callback or function() end
		self.Flag = options.Flag
		self.Theme = theme
		self._menu = menuRef
		self._inputType = nil
		self._keyCode = nil
		self._capturing = false
		self._active = false

		self.HasDesc = self.Description ~= nil and self.Description ~= ""
		local h = self.HasDesc and theme.DescHeight or theme.ElementHeight
		local btnW = 100
		local btnOff = btnW + 12

		self.Container = U.Create("Frame", {
			Name = "Keybind",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Parent = parent,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = self.Container })


		self.Label = U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, -(btnW + 20), 0, 20),
			Position = UDim2.fromOffset(10, self.HasDesc and 6 or (h + 6 - 20) / 2 + 1),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = self.Container,
		})


		self.CaptureBtn = U.Create("TextButton", {
			Name = "CaptureBtn",
			Size = UDim2.fromOffset(btnW, 26),
			Position = self.HasDesc and UDim2.new(1, -btnOff, 0, 16) or UDim2.new(1, -btnOff, 0.5, -13),
			BackgroundColor3 = theme.ElementHover,
			BackgroundTransparency = 0,
			Text = "",
			AutoButtonColor = false,
			Parent = self.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.CaptureBtn })

		self.KeyLabel = U.Create("TextLabel", {
			Name = "KeyLabel",
			Size = UDim2.new(1, -8, 1, 0),
			Position = UDim2.fromOffset(4, 0),
			BackgroundTransparency = 1,
			Text = "None",
			Font = theme.FontBold,
			TextSize = theme.FontSizeSmall,
			TextColor3 = theme.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = self.CaptureBtn,
		})


		if options.Default ~= nil then
			self:SetValue(options.Default)
		end


		if self.HasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -(btnW + 20), 0, 16),
				Position = UDim2.fromOffset(10, 28),
				BackgroundTransparency = 1,
				Text = self.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = self.Container,
			})
		end


		self.CaptureBtn.MouseEnter:Connect(function()
			if self._capturing then
				return
			end
			self.CaptureBtn.BackgroundColor3 = theme.Element
		end)
		self.CaptureBtn.MouseLeave:Connect(function()
			if self._capturing then
				return
			end
			self.CaptureBtn.BackgroundColor3 = theme.ElementHover
		end)
		self.CaptureBtn.MouseButton1Click:Connect(function()
			self:_toggleCapture()
		end)


		if menuRef then
			menuRef:_registerKeybind(self)
		end


		if options.Tooltip and menuRef then
			menuRef:BindTooltip(self.Container, options.Tooltip)
		end

		return self
	end

	function Keybind:_formatKeyName()
		if not self._keyCode then
			return "None"
		end
		local s = tostring(self._keyCode)
		if self._inputType == "MouseButton" then
			return (s:match("Enum%.UserInputType%.(.+)")) or s
		end
		return (s:match("Enum%.KeyCode%.(.+)")) or "?"
	end

	function Keybind:_updateDisplay()
		local name = self:_formatKeyName()
		self.KeyLabel.Text = name
		self.KeyLabel.TextColor3 = self._keyCode and self.Theme.TextPrimary or self.Theme.TextMuted
	end

	function Keybind:_toggleCapture()
		if self._capturing then
			self:_exitCapture()
			return
		end
		self._capturing = true
		self.KeyLabel.Text = "..."
		self.KeyLabel.TextColor3 = self.Theme.Accent
		self.CaptureBtn.BackgroundColor3 = self.Theme.Accent
		if self._menu then
			self._menu._capturingKeybind = self
		end
	end

	function Keybind:_exitCapture()
		self._capturing = false
		if self._menu then
			self._menu._capturingKeybind = nil
		end
		self.CaptureBtn.BackgroundColor3 = self.Theme.ElementHover
		self:_updateDisplay()
	end

	function Keybind:_onInput(input)
		if self.Mode == "Hold" then
			self._active = true
			self.Callback(true, input)
		else
			self._active = not self._active
			self.Callback(self._active, input)
		end
	end

	function Keybind:_onInputEnd(input)
		if self.Mode == "Hold" then
			self._active = false
			self.Callback(false, input)
		end
	end

	function Keybind:_setFromInput(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			self._inputType = "Keyboard"
			self._keyCode = input.KeyCode
		elseif
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.MouseButton3
		then
			self._inputType = "MouseButton"
			self._keyCode = input.UserInputType
		end
		self:_updateDisplay()
	end

	function Keybind:SetValue(v)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if v == nil then
			self._inputType = nil
			self._keyCode = nil
			self:_updateDisplay()
			return true
		end
		if typeof(v) == "EnumItem" then
			if v.EnumType == Enum.KeyCode then
				self._inputType = "Keyboard"
				self._keyCode = v
				self:_updateDisplay()
				return true
			elseif
				v.EnumType == Enum.UserInputType
				and (
					v == Enum.UserInputType.MouseButton1
					or v == Enum.UserInputType.MouseButton2
					or v == Enum.UserInputType.MouseButton3
				)
			then
				self._inputType = "MouseButton"
				self._keyCode = v
				self:_updateDisplay()
				return true
			end
		end
		if type(v) == "string" then

			for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do
				if item.Name == v then
					self._inputType = "Keyboard"
					self._keyCode = item
					self:_updateDisplay()
					return true
				end
			end
			for _, item in ipairs(Enum.UserInputType:GetEnumItems()) do
				if
					item.Name == v
					and (
						item == Enum.UserInputType.MouseButton1
						or item == Enum.UserInputType.MouseButton2
						or item == Enum.UserInputType.MouseButton3
					)
				then
					self._inputType = "MouseButton"
					self._keyCode = item
					self:_updateDisplay()
					return true
				end
			end
		end
		return false, "expected a KeyCode, MouseButton input, key name, or nil"
	end

	function Keybind:GetValue()
		if not self._keyCode then
			return nil
		end
		local s = tostring(self._keyCode)
		if self._inputType == "Keyboard" then
			return (s:match("Enum%.KeyCode%.(.+)"))
		else
			return (s:match("Enum%.UserInputType%.(.+)"))
		end
	end

	function Keybind:SetMode(mode)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if mode ~= "Toggle" and mode ~= "Hold" then
			return false, "expected Toggle or Hold"
		end
		self.Mode = mode
		return true
	end

	function Keybind:Destroy()
		if self._destroyed then
			return
		end
		cleanupController(self)
		if self._menu then
			self._menu:_unregisterKeybind(self)
			if self._menu._capturingKeybind == self then
				self._menu._capturingKeybind = nil
			end
		end
		if self.Container then
			self.Container:Destroy()
		end
	end

	function Keybind:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		self.Container.BackgroundColor3 = theme.Element
		local stroke = self.Container:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = theme.ElementBorder
		end
		self.Label.Font = theme.Font
		self.Label.TextSize = theme.FontSize
		self.Label.TextColor3 = theme.TextPrimary
		local desc = self.Container:FindFirstChild("Description")
		if desc then
			desc.Font = theme.Font
			desc.TextSize = theme.FontSizeSmall
			desc.TextColor3 = theme.TextMuted
		end
		if not self._capturing then
			self.CaptureBtn.BackgroundColor3 = theme.ElementHover
		end
		self.KeyLabel.Font = theme.FontBold
		self.KeyLabel.TextSize = theme.FontSizeSmall
		self:_updateDisplay()
	end

	local TextInput = {}
	TextInput.__index = TextInput

	function TextInput.new(parent, options, theme)
		local self = setmetatable({}, TextInput)
		self.Text = options.Text or "Input"
		self.Description = options.Description
		self.Placeholder = options.Placeholder or ""
		self.ClearTextOnFocus = options.ClearTextOnFocus or false
		self.Numeric = options.Numeric or false
		self.Callback = options.Callback or function() end
		self.Flag = options.Flag
		self.Theme = theme
		self._lastValidValue = nil
		self._value = ""

		self.HasDesc = self.Description ~= nil and self.Description ~= ""
		local h = self.HasDesc and theme.DescHeight or theme.ElementHeight
		local textBoxW = 100
		local textBoxOff = textBoxW + 12

		self.Container = U.Create("Frame", {
			Name = "TextInput",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Parent = parent,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = self.Container })


		self.Label = U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, -(textBoxW + 20), 0, 20),
			Position = UDim2.fromOffset(10, self.HasDesc and 6 or (h + 6 - 20) / 2 + 1),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = self.Container,
		})


		self.TextBox = U.Create("TextBox", {
			Name = "TextBox",
			Size = UDim2.fromOffset(textBoxW, 26),
			Position = self.HasDesc and UDim2.new(1, -textBoxOff, 0, 16) or UDim2.new(1, -textBoxOff, 0.5, -13),
			BackgroundColor3 = theme.ElementHover,
			BackgroundTransparency = 0,
			Text = "",
			PlaceholderText = self.Placeholder,
			Font = theme.Font,
			TextSize = theme.FontSizeSmall,
			TextColor3 = theme.TextPrimary,
			PlaceholderColor3 = theme.TextMuted,
			ClearTextOnFocus = self.ClearTextOnFocus,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = self.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.TextBox })


		if options.Default ~= nil then
			self:SetValue(tostring(options.Default), true)
		end


		self.TextBox.MouseEnter:Connect(function()
			self.TextBox.BackgroundColor3 = theme.Element
		end)
		self.TextBox.MouseLeave:Connect(function()
			self.TextBox.BackgroundColor3 = theme.ElementHover
		end)


		self.TextBox.Focused:Connect(function()
			self.TextBox.BackgroundColor3 = theme.Element
		end)


		self.TextBox.FocusLost:Connect(function(enterPressed)
			self.TextBox.BackgroundColor3 = theme.ElementHover
			if self.Numeric then
				local num = tonumber(self.TextBox.Text)
				if num ~= nil then
					self._lastValidValue = num
					self._value = tostring(num)
					self.TextBox.Text = self._value
				else

					if self._lastValidValue ~= nil then
						self._value = tostring(self._lastValidValue)
					else
						self._value = ""
					end
					self.TextBox.Text = self._value
				end
			else
				self._value = self.TextBox.Text
			end
			task.spawn(function()
				self.Callback(self._value, enterPressed)
			end)
		end)


		if self.HasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -(textBoxW + 20), 0, 16),
				Position = UDim2.fromOffset(10, 28),
				BackgroundTransparency = 1,
				Text = self.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = self.Container,
			})
		end

		return self
	end

	function TextInput:SetValue(value, noCallback)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if self.Numeric then
			if value == nil or value == "" then
				self._lastValidValue = nil
				self._value = ""
				if self.TextBox then
					self.TextBox.Text = self._value
				end
			else
				local num = tonumber(value)
				if num == nil or not isFiniteNumber(num) then
					return false, "expected finite number"
				end
				self._lastValidValue = num
				self._value = tostring(num)
				if self.TextBox then
					self.TextBox.Text = self._value
				end
			end
		else
			self._value = tostring(value)
			if self.TextBox then
				self.TextBox.Text = self._value
			end
		end
		if not noCallback then
			task.spawn(function()
				self.Callback(self._value, false)
			end)
		end
		return true
	end

	function TextInput:GetValue()
		if self.Numeric then
			return tonumber(self._value) or 0
		end
		return self._value
	end

	function TextInput:IsEmpty()
		return self._value == ""
	end

	function TextInput:Focus()
		if not self._destroyed and self.TextBox then
			self.TextBox:CaptureFocus()
		end
	end

	function TextInput:Destroy()
		if self._destroyed then
			return
		end
		cleanupController(self)
		if self.Container then
			self.Container:Destroy()
		end
	end

	function TextInput:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		self.Container.BackgroundColor3 = theme.Element
		local stroke = self.Container:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = theme.ElementBorder
		end
		self.Label.Font = theme.Font
		self.Label.TextSize = theme.FontSize
		self.Label.TextColor3 = theme.TextPrimary
		local desc = self.Container:FindFirstChild("Description")
		if desc then
			desc.Font = theme.Font
			desc.TextSize = theme.FontSizeSmall
			desc.TextColor3 = theme.TextMuted
		end
		self.TextBox.BackgroundColor3 = theme.ElementHover
		self.TextBox.Font = theme.Font
		self.TextBox.TextSize = theme.FontSizeSmall
		self.TextBox.TextColor3 = theme.TextPrimary
		self.TextBox.PlaceholderColor3 = theme.TextMuted
	end

	local Checkbox = {}
	Checkbox.__index = Checkbox

	function Checkbox.new(parent, options, theme)
		local self = setmetatable({}, Checkbox)
		self._setValueNoCallbackPosition = 3
		self.Text = options.Text or "Checkbox"
		self.Value = options.Default or false
		self.Callback = options.Callback or function() end
		self.Flag = options.Flag
		self.Theme = theme
		self.HasDesc = options.Description ~= nil and options.Description ~= ""
		local h = self.HasDesc and theme.DescHeight or theme.ElementHeight

		self.Container = U.Create("ImageButton", {
			Name = "Checkbox",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Selectable = true,
			Active = true,
			Parent = parent,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = self.Container })


		local boxSize = 18
		self.Box = U.Create("Frame", {
			Name = "Box",
			Size = UDim2.fromOffset(boxSize, boxSize),
			Position = self.HasDesc and UDim2.new(1, -(boxSize + 12), 0, 20)
				or UDim2.new(1, -(boxSize + 12), 0.5, -boxSize / 2),
			BackgroundColor3 = self.Value and theme.ToggleOn or theme.ToggleOff,
			BackgroundTransparency = 0,
			Parent = self.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = self.Box })
		self._boxStroke = U.Create("UIStroke", {
			Color = self.Value and theme.ToggleOn or theme.ElementBorder,
			Transparency = self.Value and 0 or 0.15,
			Thickness = 1,
			Parent = self.Box,
		})


		self.Label = U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, -(boxSize + 24), 0, 20),
			Position = UDim2.fromOffset(10, self.HasDesc and 6 or (h + 6 - 20) / 2 + 1),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = self.Container,
		})
		if self.HasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -(boxSize + 24), 0, 16),
				Position = UDim2.fromOffset(10, 28),
				BackgroundTransparency = 1,
				Text = options.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = self.Container,
			})
		end


		self.Container.MouseEnter:Connect(function()
			self.Box.BackgroundColor3 = self.Value and self.Theme.ToggleOn or self.Theme.ElementHover
		end)
		self.Container.MouseLeave:Connect(function()
			self.Box.BackgroundColor3 = self.Value and self.Theme.ToggleOn or self.Theme.ToggleOff
		end)
		self.Container.Activated:Connect(function()
			self:SetValue(not self.Value)
		end)

		return self
	end

	function Checkbox:SetValue(v, instant, noCallback)
		local isDestroyed, result, err = destroyedResult(self)
		if isDestroyed then
			return result, err
		end
		if type(v) ~= "boolean" then
			return false, "expected boolean"
		end
		if self.Value == v then
			return true
		end
		self.Value = v
		local ts = game:GetService("TweenService")
		local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		if instant then
			self.Box.BackgroundColor3 = v and self.Theme.ToggleOn or self.Theme.ToggleOff
			self._boxStroke.Color = v and self.Theme.ToggleOn or self.Theme.ElementBorder
			self._boxStroke.Transparency = v and 0 or 0.15
		else
			ts:Create(self.Box, ti, {
				BackgroundColor3 = v and self.Theme.ToggleOn or self.Theme.ToggleOff,
			}):Play()
			ts:Create(self._boxStroke, ti, {
				Color = v and self.Theme.ToggleOn or self.Theme.ElementBorder,
				Transparency = v and 0 or 0.15,
			}):Play()
		end
		if not noCallback then
			task.spawn(function()
				self.Callback(v)
			end)
		end
		return true
	end
	function Checkbox:GetValue()
		return self.Value
	end
	function Checkbox:Destroy()
		if self._destroyed then
			return
		end
		cleanupController(self)
		if self.Container then
			self.Container:Destroy()
		end
	end

	function Checkbox:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		self.Container.BackgroundColor3 = theme.Element
		local stroke = self.Container:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = theme.ElementBorder
		end
		self.Label.Font = theme.Font
		self.Label.TextSize = theme.FontSize
		self.Label.TextColor3 = theme.TextPrimary
		local desc = self.Container:FindFirstChild("Description")
		if desc then
			desc.Font = theme.Font
			desc.TextSize = theme.FontSizeSmall
			desc.TextColor3 = theme.TextMuted
		end
		self.Box.BackgroundColor3 = self.Value and theme.ToggleOn or theme.ToggleOff
		if self._boxStroke then
			self._boxStroke.Color = self.Value and theme.ToggleOn or theme.ElementBorder
			self._boxStroke.Transparency = self.Value and 0 or 0.15
		end
	end



	function Checkbox.new(parent, options, theme)
		local normalized = {}
		for key, value in pairs(options or {}) do
			normalized[key] = value
		end
		if normalized.Text == nil then
			normalized.Text = "Checkbox"
		end
		return Toggle.new(parent, normalized, theme)
	end

	local Column = {}
	Column.__index = Column


	function Column:_mount(c, opts)
		if not c then
			return nil
		end
		table.insert(self.Components, c)
		if c.Flag and self._menu then
			self._menu:_trackFlagged(c)
		end
		if opts.Tooltip and self._menu and c.Container then
			self._menu:BindTooltip(c.Container, opts.Tooltip)
		end
		self._columns:_updateHeight()
		return c
	end

	function Column.new(columns, index, theme, menuRef)
		local self = setmetatable({}, Column)
		self._columns = columns
		self._menu = menuRef
		self.Theme = theme
		self.Components = {}
		self.Content = U.Create("Frame", {
			Name = "Column" .. index,
			Size = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = columns.Container,
		})
		self._layout = U.Create("UIListLayout", {
			Padding = UDim.new(0, theme.Spacing),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = self.Content,
		})

		self._layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if not columns._destroyed and not self._destroyed then
				columns:_updateHeight()
			end
		end)
		return self
	end

	function Column:_contentHeight()
		return self._layout and self._layout.AbsoluteContentSize.Y or 0
	end


	function Column:Toggle(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		return self:_mount(Toggle.new(self.Content, opts, self.Theme), opts)
	end

	function Column:Checkbox(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		return self:_mount(Checkbox.new(self.Content, opts, self.Theme), opts)
	end

	function Column:Slider(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		if self._columns._isOneToOne then
			local clo = {}
			for k, v in pairs(opts) do
				clo[k] = v
			end
			clo._inOneToOneColumn = true
			opts = clo
		end
		return self:_mount(Slider.new(self.Content, opts, self.Theme), opts)
	end

	function Column:ColorPicker(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		return self:_mount(ColorPicker.new(self.Content, opts, self.Theme), opts)
	end

	function Column:Dropdown(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local dropdownOpts = {}
		for k, v in pairs(opts) do
			dropdownOpts[k] = v
		end
		dropdownOpts._compactControl = true
		return self:_mount(Dropdown.new(self.Content, dropdownOpts, self.Theme, self._menu), opts)
	end

	function Column:Keybind(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		return self:_mount(Keybind.new(self.Content, opts, self.Theme, self._menu), opts)
	end

	function Column:Input(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		return self:_mount(TextInput.new(self.Content, opts, self.Theme), opts)
	end

	function Column:Collapsible(title, opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local c = Collapsible.new(self.Content, title, opts, self.Theme)
		c._menu = self._menu
		if self._columns._isOneToOne then
			c._inOneToOne = true
		end
		table.insert(self.Components, c)
		self._columns:_updateHeight()
		return c
	end

	function Column:Columns(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local columns = Columns.new(self.Content, opts, self.Theme, self._menu, function()
			self._columns:_updateHeight()
		end)
		table.insert(self.Components, columns)
		self._columns:_updateHeight()
		return columns
	end


	function Column:Button(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local theme = self.Theme
		local hasDesc = opts.Description ~= nil and opts.Description ~= ""
		local h = hasDesc and theme.DescHeight or theme.ElementHeight
		local btn = {}
		btn.Container = U.Create("ImageButton", {
			Name = "Button",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = self.Content,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = btn.Container })
		renderIcon(btn.Container, opts.Icon or "rocket", {
			Name = "Pointer",
			Size = UDim2.fromOffset(26, 26),
			Position = hasDesc and UDim2.new(1, -38, 0, 16) or UDim2.new(1, -38, 0.5, -13),
			ImageTransparency = 0.5,
		})
		local ix = 10
		if hasDesc then
			U.Create("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -54, 0, 20),
				Position = UDim2.fromOffset(ix, 5),
				BackgroundTransparency = 1,
				Text = opts.Text or "Button",
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = opts.Color or theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Container,
			})
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -54, 0, 16),
				Position = UDim2.fromOffset(ix, 27),
				BackgroundTransparency = 1,
				Text = opts.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = btn.Container,
			})
		else
			U.Create("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -54, 0, 20),
				Position = UDim2.fromOffset(ix, (h + 6 - 20) / 2 + 1),
				BackgroundTransparency = 1,
				Text = opts.Text or "Button",
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = opts.Color or theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Container,
			})
		end
		local _sc = U.Create("UIScale", { Parent = btn.Container })
		btn.Container.MouseEnter:Connect(function()
			btn.Container.BackgroundColor3 = theme.ElementHover
			btn.Container.BackgroundTransparency = 0
		end)
		btn.Container.MouseLeave:Connect(function()
			btn.Container.BackgroundColor3 = theme.Element
			btn.Container.BackgroundTransparency = 0
		end)
		btn.Container.MouseButton1Down:Connect(function()
			game:GetService("TweenService"):Create(_sc, TweenInfo.new(0.05), { Scale = 0.97 }):Play()
		end)
		btn.Container.MouseButton1Up:Connect(function()
			game:GetService("TweenService"):Create(_sc, TweenInfo.new(0.08), { Scale = 1 }):Play()
		end)
		btn.Container.MouseButton1Click:Connect(function()
			if opts.Callback then
				opts.Callback()
			end
		end)
		btn.Destroy = function()
			if btn.Container then
				btn.Container:Destroy()
			end
		end
		local _btnColor = opts.Color
		btn.ApplyTheme = function(_, t)
			t = t or _
			if not btn.Container then
				return
			end
			btn.Container.BackgroundColor3 = t.Element
			local stroke = btn.Container:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = t.ElementBorder
			end
			local text = btn.Container:FindFirstChild("Text")
			if text then
				text.Font = t.Font
				text.TextSize = t.FontSize
				text.TextColor3 = _btnColor or t.TextPrimary
			end
			local desc = btn.Container:FindFirstChild("Description")
			if desc then
				desc.Font = t.Font
				desc.TextSize = t.FontSizeSmall
				desc.TextColor3 = t.TextMuted
			end
		end
		table.insert(self.Components, btn)
		self._columns:_updateHeight()
		return btn
	end

	function Column:Label(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local theme = self.Theme
		local hasDesc = opts.Description ~= nil and opts.Description ~= ""
		local h = hasDesc and theme.DescHeight or theme.ElementHeight
		local lbl = {}
		local _lblColor = opts.Color
		local _lblTextSize = opts.TextSize or theme.FontSize
		lbl.Container = U.Create(
			"Frame",
			{ Name = "Label", Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, Parent = self.Content }
		)
		lbl.TextLabel = U.Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, 0, 0, hasDesc and 20 or h),
			Position = UDim2.fromOffset(0, hasDesc and 2 or (h - 20) / 2 + 1),
			BackgroundTransparency = 1,
			Text = opts.Text or "",
			Font = theme.Font,
			TextSize = _lblTextSize,
			TextColor3 = _lblColor or theme.TextSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = lbl.Container,
		})
		if hasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, 0, 0, 16),
				Position = UDim2.fromOffset(0, 24),
				BackgroundTransparency = 1,
				Text = opts.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = lbl.Container,
			})
		end
		lbl.SetText = function(text)
			lbl.TextLabel.Text = text
		end
		lbl.SetColor = function(c)
			lbl.TextLabel.TextColor3 = c
		end
		lbl.Destroy = function()
			if lbl.Container then
				lbl.Container:Destroy()
			end
		end
		lbl.ApplyTheme = function(_, t)
			t = t or _
			if not lbl.TextLabel then
				return
			end
			lbl.TextLabel.Font = t.Font
			lbl.TextLabel.TextSize = _lblTextSize
			lbl.TextLabel.TextColor3 = _lblColor or t.TextSecondary
			local d = lbl.Container:FindFirstChild("Description")
			if d then
				d.Font = t.Font
				d.TextSize = t.FontSizeSmall
				d.TextColor3 = t.TextMuted
			end
		end
		table.insert(self.Components, lbl)
		self._columns:_updateHeight()
		return lbl
	end

	function Column:BoldLabel(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local theme = self.Theme
		local hasDesc = opts.Description ~= nil and opts.Description ~= ""
		local h = hasDesc and theme.DescHeight or theme.ElementHeight
		local lbl = {}
		local _blblColor = opts.Color
		local _blblTextSize = opts.TextSize or theme.FontSizeTitle
		lbl.Container = U.Create(
			"Frame",
			{ Name = "BoldLabel", Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, Parent = self.Content }
		)
		lbl.TextLabel = U.Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, 0, 0, hasDesc and 22 or h),
			Position = UDim2.fromOffset(0, hasDesc and 2 or (h - 22) / 2 + 1),
			BackgroundTransparency = 1,
			Text = opts.Text or "",
			Font = theme.FontBold,
			TextSize = _blblTextSize,
			TextColor3 = _blblColor or theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = lbl.Container,
		})
		if hasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, 0, 0, 16),
				Position = UDim2.fromOffset(0, 24),
				BackgroundTransparency = 1,
				Text = opts.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = lbl.Container,
			})
		end
		lbl.SetText = function(text)
			lbl.TextLabel.Text = text
		end
		lbl.SetColor = function(c)
			lbl.TextLabel.TextColor3 = c
		end
		lbl.Destroy = function()
			if lbl.Container then
				lbl.Container:Destroy()
			end
		end
		lbl.ApplyTheme = function(_, t)
			t = t or _
			if not lbl.TextLabel then
				return
			end
			lbl.TextLabel.Font = t.FontBold
			lbl.TextLabel.TextSize = _blblTextSize
			lbl.TextLabel.TextColor3 = _blblColor or t.TextPrimary
			local d = lbl.Container:FindFirstChild("Description")
			if d then
				d.Font = t.Font
				d.TextSize = t.FontSizeSmall
				d.TextColor3 = t.TextMuted
			end
		end
		table.insert(self.Components, lbl)
		self._columns:_updateHeight()
		return lbl
	end

	function Column:Divider()
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		local div = {}
		div.Container = U.Create("Frame", {
			Name = "Divider",
			Size = UDim2.new(1, -20, 0, 1),
			Position = UDim2.fromOffset(10, 0),
			BackgroundColor3 = self.Theme.Border,
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			Parent = self.Content,
		})
		div.ApplyTheme = function(_, t)
			t = t or _
			if div.Container then
				div.Container.BackgroundColor3 = t.Border
			end
		end
		table.insert(self.Components, div)
		self._columns:_updateHeight()
		return div
	end

	function Column:Destroy()
		if self._destroyed then
			return
		end
		self._destroyed = true
		for _, c in ipairs(self.Components) do
			if c.Destroy then
				c:Destroy()
			end
		end
		self.Components = {}
		if self.Content then
			self.Content:Destroy()
		end
	end

	function Column:ApplyTheme(theme)
		self.Theme = theme
		if not self.Content then
			return
		end
		if self._layout then
			self._layout.Padding = UDim.new(0, theme.Spacing)
		end
		for _, c in ipairs(self.Components) do
			if c.ApplyTheme then
				c:ApplyTheme(theme)
			end
		end
	end


	Columns = {}
	Columns.__index = Columns

	function Columns.new(parent, options, theme, menuRef, parentUpdateCallback)
		local self = setmetatable({}, Columns)
		self._destroyed = false
		self._menu = menuRef
		self.Theme = theme
		self.Components = {}
		self._parentUpdate = parentUpdateCallback


		self._ratio = options.Ratio or { 1, 1 }
		self._gap = options.Gap or 8
		self._stackCompact = options.StackOnCompact ~= false
		assert(
			type(self._ratio) == "table" and #self._ratio >= 2,
			"Columns: Ratio must be a table with at least 2 positive finite numbers"
		)
		for _, v in ipairs(self._ratio) do
			assert(isFiniteNumber(v) and v > 0, "Columns: each Ratio value must be a positive finite number")
		end
		assert(isFiniteNumber(self._gap) and self._gap >= 0, "Columns: Gap must be a non-negative finite number")

		self._isOneToOne = #self._ratio == 2 and self._ratio[1] == self._ratio[2]


		self.Container = U.Create("Frame", {
			Name = "Columns",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = parent,
		})


		self._containerSizing = self.Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not self._destroyed then
				self:_updateHeight()
			end
		end)


		self._columns = {}
		self._nextColumn = 1
		for i = 1, #self._ratio do
			local col = Column.new(self, i, theme, menuRef)
			table.insert(self._columns, col)
			table.insert(self.Components, col)
		end


		task.spawn(function()
			if not self._destroyed then
				self:_updateHeight()
			end
		end)

		return self
	end

	function Columns:_isCompact()
		if not self._stackCompact then
			return false
		end
		if self._menu and self._menu._compact ~= nil then
			return self._menu._compact
		end

		if self._menu and self._menu.CompactBreakpoint then
			local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
			if viewport.X <= self._menu.CompactBreakpoint then
				return true
			end
		end

		if self.Container then
			local w = self.Container.AbsoluteSize.X
			if w > 0 and w < 400 then
				return true
			end
		end
		return false
	end

	function Columns:_updateHeight()
		if self._destroyed or self._updating then
			return
		end
		self._updating = true

		local compact = self:_isCompact()
		local numCols = #self._columns
		local containerW = self.Container.AbsoluteSize.X


		local colHeights = {}
		local maxH = 0
		local sumH = 0
		for i, col in ipairs(self._columns) do
			local h = col:_contentHeight()
			colHeights[i] = h
			if h > maxH then
				maxH = h
			end
			sumH = sumH + h
		end

		if compact and numCols > 0 then

			local y = 0
			for i = 1, numCols do
				local h = colHeights[i]
				local col = self._columns[i]
				col.Content.Size = UDim2.new(1, 0, 0, h)
				col.Content.Position = UDim2.fromOffset(0, y)
				if i < numCols then
					y = y + h + self._gap
				end
			end
			self.Container.Size = UDim2.new(1, 0, 0, sumH + math.max(0, numCols - 1) * self._gap)
		elseif numCols > 0 then

			local totalRatio = 0
			for _, r in ipairs(self._ratio) do
				totalRatio = totalRatio + r
			end
			local availableW = math.max(0, containerW - self._gap * (numCols - 1))
			local x = 0
			for i = 1, numCols do
				local w = math.floor(availableW * self._ratio[i] / totalRatio)
				local col = self._columns[i]
				col.Content.Size = UDim2.fromOffset(w, maxH)
				col.Content.Position = UDim2.fromOffset(math.floor(x), 0)
				if i < numCols then
					x = x + w + self._gap
				end
			end
			self.Container.Size = UDim2.new(1, 0, 0, maxH)
		end

		self._updating = false


		if self._parentUpdate then
			self._parentUpdate()
		end
	end


	function Columns:Column(idx)
		if self._destroyed then
			return nil, "destroyed"
		end
		if idx ~= nil then
			return self._columns[idx]
		end
		local col = self._columns[self._nextColumn]
		if col then
			self._nextColumn = self._nextColumn + 1
		end
		return col
	end

	function Columns:Destroy()
		if self._destroyed then
			return
		end
		self._destroyed = true
		if self._containerSizing then
			self._containerSizing:Disconnect()
			self._containerSizing = nil
		end
		for _, col in ipairs(self._columns) do
			col:Destroy()
		end
		self._columns = {}
		self.Components = {}
		if self.Container then
			self.Container:Destroy()
		end
	end

	function Columns:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		for _, col in ipairs(self._columns) do
			col:ApplyTheme(theme)
		end
	end

	Collapsible = {}
	Collapsible.__index = Collapsible

	function Collapsible.new(parent, title, options, theme)
		local self = setmetatable({}, Collapsible)
		self.Theme = theme
		self.Components = {}
		self._isOpen = options and options.DefaultOpen ~= false
		self._tween = nil
		self._closed = false


		self.Container = U.Create("Frame", {
			Name = "Collapsible",
			Size = UDim2.new(1, -12, 0, 34),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = parent,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = self.Container })


		self.Header = U.Create("ImageButton", {
			Name = "Header",
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = theme.ElementHover,
			BackgroundTransparency = 0.3,
			AutoButtonColor = false,
			Parent = self.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Header })

		self.Arrow = renderIcon(self.Header, self._isOpen and "chevron-down" or "chevron-right", {
			Name = "Arrow",
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.new(1, -24, 0.5, -8),
			BackgroundTransparency = 1,
			ImageColor3 = theme.TextSecondary,
			TextColor3 = theme.TextSecondary,
			Active = false,
		})

		self.Title = U.Create("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.fromOffset(12, 0),
			BackgroundTransparency = 1,
			Text = title,
			Font = theme.FontBold,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			Active = false,
			Parent = self.Header,
		})




		self.Content = U.Create("Frame", {
			Name = "Content",
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.fromOffset(0, 34),
			BackgroundTransparency = 1,
			Visible = self._isOpen,
			Parent = self.Container,
		})
		local layout = U.Create("UIListLayout", {
			Padding = UDim.new(0, theme.Spacing),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = self.Content,
		})
		local contentPadding = U.Create("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			Parent = self.Content,
		})
		self._layout = layout
		self._contentPadding = contentPadding


		self._layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if not self._closed then
				self:_updateSize()
			end
		end)


		self.Header.MouseEnter:Connect(function()
			self.Header.BackgroundColor3 = theme.TabHover
			self.Header.BackgroundTransparency = 0
		end)
		self.Header.MouseLeave:Connect(function()
			self.Header.BackgroundColor3 = theme.ElementHover
			self.Header.BackgroundTransparency = 0.3
		end)
		self.Header.MouseButton1Click:Connect(function()
			self:ToggleOpen()
		end)


		task.spawn(function()
			task.wait()
			if not self._closed then
				self:_updateSize(true)
			end
		end)

		return self
	end

	function Collapsible:_contentHeight()
		local layoutHeight = self._layout and self._layout.AbsoluteContentSize.Y or 0
		local paddingTop = self._contentPadding and self._contentPadding.PaddingTop.Offset or 0
		local paddingBottom = self._contentPadding and self._contentPadding.PaddingBottom.Offset or 0
		return layoutHeight + paddingTop + paddingBottom
	end

	function Collapsible:SetOpen(v)
		if self._destroyed then
			return false, "destroyed"
		end
		if type(v) ~= "boolean" then
			return false, "expected boolean"
		end
		if self._isOpen == v then
			return true
		end
		self._isOpen = v
		local transitionId = (self._transitionId or 0) + 1
		self._transitionId = transitionId
		if self.Arrow then
			self.Arrow = updateRenderedIcon(self.Arrow, v and "chevron-down" or "chevron-right", self.Header, {
				Name = "Arrow",
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(1, -24, 0.5, -8),
				BackgroundTransparency = 1,
				ImageColor3 = self.Theme.TextSecondary,
				TextColor3 = self.Theme.TextSecondary,
				Active = false,
			})
		end
		if self._tween then
			self._tween:Cancel()
		end
		if not self.Container then
			return false, "missing container"
		end
		if v and self.Content then
			self.Content.Visible = true
		end
		local contentHeight = self:_contentHeight()
		if self.Content then
			self.Content.Size = UDim2.new(1, 0, 0, contentHeight)
		end
		local targetH = v and (34 + contentHeight) or 34
		local function finishTransition()
			if self._transitionId == transitionId and not self._isOpen and self.Content then
				self.Content.Visible = false
			end
		end
		if self._menu then
			self._tween = self._menu:_transition(
				self.Container,
				0.25,
				{ Size = UDim2.new(1, -12, 0, targetH) },
				nil,
				nil,
				finishTransition
			)
		else
			self._tween = game:GetService("TweenService"):Create(
				self.Container,
				TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Size = UDim2.new(1, -12, 0, targetH) }
			)
			self._tween.Completed:Connect(finishTransition)
			self._tween:Play()
		end
		return true
	end

	function Collapsible:ToggleOpen()
		self:SetOpen(not self._isOpen)
	end

	function Collapsible:Open()
		self:SetOpen(true)
	end
	function Collapsible:Close()
		self:SetOpen(false)
	end

	function Collapsible:_updateSize(instant)
		if self._closed or not self._layout or not self.Container or not self.Container.Parent then
			return
		end
		if self._tween then
			self._tween:Cancel()
		end
		local contentHeight = self:_contentHeight()
		if self.Content then
			self.Content.Size = UDim2.new(1, 0, 0, contentHeight)
		end
		local targetH = self._isOpen and (34 + contentHeight) or 34
		if instant then
			self.Container.Size = UDim2.new(1, -12, 0, targetH)
		else
			if self._menu then
				self._tween = self._menu:_transition(self.Container, 0.15, { Size = UDim2.new(1, -12, 0, targetH) })
			else
				self._tween = game:GetService("TweenService"):Create(
					self.Container,
					TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Size = UDim2.new(1, -12, 0, targetH) }
				)
				self._tween:Play()
			end
		end
	end


	function Collapsible:Toggle(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local c = Toggle.new(self.Content, opts, self.Theme)
		table.insert(self.Components, c)
		if c.Flag and self._menu then
			self._menu:_trackFlagged(c)
		end
		if opts.Tooltip and self._menu then
			self._menu:BindTooltip(c.Container, opts.Tooltip)
		end
		self:_updateSize()
		return c
	end
	function Collapsible:Checkbox(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local c = Checkbox.new(self.Content, opts, self.Theme)
		table.insert(self.Components, c)
		if c.Flag and self._menu then
			self._menu:_trackFlagged(c)
		end
		if opts.Tooltip and self._menu then
			self._menu:BindTooltip(c.Container, opts.Tooltip)
		end
		self:_updateSize()
		return c
	end
	function Collapsible:Slider(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		if self._inOneToOne then
			local clo = {}
			for k, v in pairs(opts) do
				clo[k] = v
			end
			clo._inOneToOneColumn = true
			opts = clo
		end
		local c = Slider.new(self.Content, opts, self.Theme)
		table.insert(self.Components, c)
		if c.Flag and self._menu then
			self._menu:_trackFlagged(c)
		end
		if opts.Tooltip and self._menu then
			self._menu:BindTooltip(c.Container, opts.Tooltip)
		end
		self:_updateSize()
		return c
	end
	function Collapsible:ColorPicker(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local c = ColorPicker.new(self.Content, opts, self.Theme)
		table.insert(self.Components, c)
		if c.Flag and self._menu then
			self._menu:_trackFlagged(c)
		end
		if opts.Tooltip and self._menu then
			self._menu:BindTooltip(c.Container, opts.Tooltip)
		end
		self:_updateSize()
		return c
	end
	function Collapsible:Dropdown(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local dropdownOpts = {}
		for k, v in pairs(opts) do
			dropdownOpts[k] = v
		end
		dropdownOpts._compactControl = true
		local c = Dropdown.new(self.Content, dropdownOpts, self.Theme, self._menu or nil)
		table.insert(self.Components, c)
		if c.Flag and self._menu then
			self._menu:_trackFlagged(c)
		end
		if opts.Tooltip and self._menu then
			self._menu:BindTooltip(c.Container, opts.Tooltip)
		end
		self:_updateSize()
		return c
	end
	function Collapsible:Keybind(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local c = Keybind.new(self.Content, opts, self.Theme, self._menu or nil)
		table.insert(self.Components, c)
		if c.Flag and self._menu then
			self._menu:_trackFlagged(c)
		end
		if opts.Tooltip and self._menu then
			self._menu:BindTooltip(c.Container, opts.Tooltip)
		end
		self:_updateSize()
		return c
	end
	function Collapsible:Input(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local c = TextInput.new(self.Content, opts, self.Theme)
		table.insert(self.Components, c)
		if c.Flag and self._menu then
			self._menu:_trackFlagged(c)
		end
		if opts.Tooltip and self._menu then
			self._menu:BindTooltip(c.Container, opts.Tooltip)
		end
		self:_updateSize()
		return c
	end
	function Collapsible:Button(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local theme = self.Theme
		local hasDesc = opts.Description ~= nil and opts.Description ~= ""
		local h = hasDesc and theme.DescHeight or theme.ElementHeight
		local btn = {}
		btn.Container = U.Create("ImageButton", {
			Name = "Button",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = self.Content,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = btn.Container })
		renderIcon(btn.Container, opts.Icon or "rocket", {
			Name = "Pointer",
			Size = UDim2.fromOffset(26, 26),
			Position = hasDesc and UDim2.new(1, -38, 0, 16) or UDim2.new(1, -38, 0.5, -13),
			ImageTransparency = 0.5,
		})
		local ix = 10
		if hasDesc then
			U.Create("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -54, 0, 20),
				Position = UDim2.fromOffset(ix, 5),
				BackgroundTransparency = 1,
				Text = opts.Text or "Button",
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = opts.Color or theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Container,
			})
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -54, 0, 16),
				Position = UDim2.fromOffset(ix, 27),
				BackgroundTransparency = 1,
				Text = opts.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = btn.Container,
			})
		else
			U.Create("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -54, 0, 20),
				Position = UDim2.fromOffset(ix, (h + 6 - 20) / 2 + 1),
				BackgroundTransparency = 1,
				Text = opts.Text or "Button",
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = opts.Color or theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Container,
			})
		end
		local _sc = U.Create("UIScale", { Parent = btn.Container })
		btn.Container.MouseEnter:Connect(function()
			btn.Container.BackgroundColor3 = theme.ElementHover
			btn.Container.BackgroundTransparency = 0
		end)
		btn.Container.MouseLeave:Connect(function()
			btn.Container.BackgroundColor3 = theme.Element
			btn.Container.BackgroundTransparency = 0
		end)
		btn.Container.MouseButton1Down:Connect(function()
			game:GetService("TweenService"):Create(_sc, TweenInfo.new(0.05), { Scale = 0.97 }):Play()
		end)
		btn.Container.MouseButton1Up:Connect(function()
			game:GetService("TweenService"):Create(_sc, TweenInfo.new(0.08), { Scale = 1 }):Play()
		end)
		btn.Container.MouseButton1Click:Connect(function()
			if opts.Callback then
				opts.Callback()
			end
		end)
		btn.Destroy = function()
			if btn.Container then
				btn.Container:Destroy()
			end
		end
		local _btnColor = opts.Color
		btn.ApplyTheme = function(_, t)
			t = t or _
			if not btn.Container then
				return
			end
			btn.Container.BackgroundColor3 = t.Element
			local s = btn.Container:FindFirstChildOfClass("UIStroke")
			if s then
				s.Color = t.ElementBorder
			end
			local txt = btn.Container:FindFirstChild("Text")
			if txt then
				txt.Font = t.Font
				txt.TextSize = t.FontSize
				txt.TextColor3 = _btnColor or t.TextPrimary
			end
			local d = btn.Container:FindFirstChild("Description")
			if d then
				d.Font = t.Font
				d.TextSize = t.FontSizeSmall
				d.TextColor3 = t.TextMuted
			end
		end
		if opts.Tooltip and self._menu then
			self._menu:BindTooltip(btn.Container, opts.Tooltip)
		end
		table.insert(self.Components, btn)
		self:_updateSize()
		return btn
	end
	function Collapsible:Label(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local theme = self.Theme
		local hasDesc = opts.Description ~= nil and opts.Description ~= ""
		local h = hasDesc and theme.DescHeight or theme.ElementHeight
		local lbl = {}
		local _lblColor = opts.Color
		local _lblTextSize = opts.TextSize or theme.FontSize
		lbl.Container = U.Create(
			"Frame",
			{ Name = "Label", Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, Parent = self.Content }
		)
		lbl.TextLabel = U.Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, 0, 0, hasDesc and 20 or h),
			Position = UDim2.fromOffset(0, hasDesc and 2 or (h - 20) / 2 + 1),
			BackgroundTransparency = 1,
			Text = opts.Text or "",
			Font = theme.Font,
			TextSize = _lblTextSize,
			TextColor3 = _lblColor or theme.TextSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = lbl.Container,
		})
		if hasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, 0, 0, 16),
				Position = UDim2.fromOffset(0, 24),
				BackgroundTransparency = 1,
				Text = opts.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = lbl.Container,
			})
		end
		lbl.Destroy = function()
			if lbl.Container then
				lbl.Container:Destroy()
			end
		end
		lbl.ApplyTheme = function(_, t)
			t = t or _
			if not lbl.TextLabel then
				return
			end
			lbl.TextLabel.Font = t.Font
			lbl.TextLabel.TextSize = _lblTextSize
			lbl.TextLabel.TextColor3 = _lblColor or t.TextSecondary
			local d = lbl.Container:FindFirstChild("Description")
			if d then
				d.Font = t.Font
				d.TextSize = t.FontSizeSmall
				d.TextColor3 = t.TextMuted
			end
		end
		table.insert(self.Components, lbl)
		self:_updateSize()
		return lbl
	end
	function Collapsible:BoldLabel(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local theme = self.Theme
		local hasDesc = opts.Description ~= nil and opts.Description ~= ""
		local h = hasDesc and theme.DescHeight or theme.ElementHeight
		local lbl = {}
		local _blblColor = opts.Color
		local _blblTextSize = opts.TextSize or theme.FontSizeTitle
		lbl.Container = U.Create(
			"Frame",
			{ Name = "BoldLabel", Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, Parent = self.Content }
		)
		lbl.TextLabel = U.Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, 0, 0, hasDesc and 22 or h),
			Position = UDim2.fromOffset(0, hasDesc and 2 or (h - 22) / 2 + 1),
			BackgroundTransparency = 1,
			Text = opts.Text or "",
			Font = theme.FontBold,
			TextSize = _blblTextSize,
			TextColor3 = _blblColor or theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = lbl.Container,
		})
		if hasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, 0, 0, 16),
				Position = UDim2.fromOffset(0, 24),
				BackgroundTransparency = 1,
				Text = opts.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = lbl.Container,
			})
		end
		lbl.Destroy = function()
			if lbl.Container then
				lbl.Container:Destroy()
			end
		end
		lbl.ApplyTheme = function(_, t)
			t = t or _
			if not lbl.TextLabel then
				return
			end
			lbl.TextLabel.Font = t.FontBold
			lbl.TextLabel.TextSize = _blblTextSize
			lbl.TextLabel.TextColor3 = _blblColor or t.TextPrimary
			local d = lbl.Container:FindFirstChild("Description")
			if d then
				d.Font = t.Font
				d.TextSize = t.FontSizeSmall
				d.TextColor3 = t.TextMuted
			end
		end
		table.insert(self.Components, lbl)
		self:_updateSize()
		return lbl
	end
	function Collapsible:Divider()
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		local div = {}
		div.Container = U.Create("Frame", {
			Name = "Divider",
			Size = UDim2.new(1, -20, 0, 1),
			Position = UDim2.fromOffset(10, 0),
			BackgroundColor3 = self.Theme.Border,
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			Parent = self.Content,
		})
		div.ApplyTheme = function(_, t)
			t = t or _
			if div.Container then
				div.Container.BackgroundColor3 = t.Border
			end
		end
		table.insert(self.Components, div)
		self:_updateSize()
		return div
	end
	function Collapsible:Columns(opts)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		opts = opts or {}
		local c = Columns.new(self.Content, opts, self.Theme, self._menu, function()
			self:_updateSize()
		end)
		table.insert(self.Components, c)
		return c
	end
	function Collapsible:Destroy()
		if self._destroyed then
			return
		end
		self._destroyed = true
		self._closed = true
		if self._tween then
			self._tween:Cancel()
		end
		for _, c in ipairs(self.Components) do
			if c.Destroy then
				c:Destroy()
			end
		end
		self.Components = {}
		if self.Container then
			self.Container:Destroy()
		end
	end

	function Collapsible:ApplyTheme(theme)
		self.Theme = theme
		if not self.Container then
			return
		end
		self.Container.BackgroundColor3 = theme.Element
		local stroke = self.Container:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = theme.ElementBorder
		end
		self.Header.BackgroundColor3 = theme.ElementHover
		if self.Arrow then
			if self.Arrow:IsA("ImageLabel") then
				self.Arrow.ImageColor3 = theme.TextSecondary
			end
			if self.Arrow:IsA("TextLabel") then
				self.Arrow.TextColor3 = theme.TextSecondary
			end
		end
		self.Title.Font = theme.FontBold
		self.Title.TextSize = theme.FontSize
		self.Title.TextColor3 = theme.TextPrimary
		if self._layout then
			self._layout.Padding = UDim.new(0, theme.Spacing)
		end
		for _, c in ipairs(self.Components) do
			if c.ApplyTheme then
				c:ApplyTheme(theme)
			end
		end
	end

	local Tab = {}
	Tab.__index = Tab

	function Tab.new(menu, options)
		local self = setmetatable({}, Tab)
		self.Menu = menu
		self.Text = options.Text or "Tab"
		self.Theme = menu.Theme
		self.Components = {}
		local theme = self.Theme

		self.TabButton = U.Create("ImageButton", {
			Name = "TabButton",
			Size = UDim2.new(1, -6, 0, 38),
			Position = UDim2.fromOffset(3, 0),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Parent = menu.SidebarList,
		})
		menu:_makeSelectable(self.TabButton)
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.TabButton })

		self._glow = U.Create("Frame", {
			Name = "Glow",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = self.TabButton,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self._glow })

		local _tabIcon = renderIcon(self.TabButton, options.Icon, {
			Size = UDim2.fromOffset(18, 18),
			Position = UDim2.fromOffset(14, 10),
		})
		local textX = _tabIcon and 40 or 18
		local textW = _tabIcon and -44 or -22
		U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, textW, 1, 0),
			Position = UDim2.fromOffset(textX, 0),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.SidebarText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = self.TabButton,
		})
		self.Container = U.Create("ScrollingFrame", {
			Name = "TabContent",
			Size = UDim2.new(1, -12, 1, -12),
			Position = UDim2.fromOffset(6, 6),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = theme.ScrollBar,
			ScrollBarImageTransparency = 0.4,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Visible = false,
			Parent = menu.ContentArea,
		})
		local contentPadding = U.Create("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 12),
			Parent = self.Container,
		})
		local listLayout = U.Create("UIListLayout", {
			Padding = UDim.new(0, theme.Spacing),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = self.Container,
		})
		listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if self.Container then
				self.Container.CanvasSize = UDim2.new(
					0,
					0,
					0,
					listLayout.AbsoluteContentSize.Y
						+ contentPadding.PaddingTop.Offset
						+ contentPadding.PaddingBottom.Offset
				)
			end
		end)

		self.TabButton.Activated:Connect(function()
			menu:SelectTab(self)
		end)
		self.TabButton.SelectionGained:Connect(function()
			if menu:_selectionIsAvailable() then
				menu:SelectTab(self)
			end
		end)
		self.TabButton.MouseEnter:Connect(function()
			if menu.ActiveTab ~= self then
				self.TabButton.BackgroundTransparency = 0
				self.TabButton.BackgroundColor3 = theme.TabHover
			end
		end)
		self.TabButton.MouseLeave:Connect(function()
			if menu.ActiveTab ~= self then
				self.TabButton.BackgroundTransparency = 1
			end
		end)


		if options.Tooltip and menu then
			menu:BindTooltip(self.TabButton, options.Tooltip)
		end

		table.insert(menu.Tabs, self)
		if #menu.Tabs == 1 then
			menu:SelectTab(self)
		end

		return self
	end

	function Tab:Toggle(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local toggle = Toggle.new(self.Container, options, self.Theme)
		table.insert(self.Components, toggle)
		self.Menu:_makeSelectable(toggle.Track)
		if toggle.Flag then
			self.Menu:_trackFlagged(toggle)
		end
		if options.Tooltip and self.Menu then
			self.Menu:BindTooltip(toggle.Container, options.Tooltip)
		end
		return toggle
	end

	function Tab:Button(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local theme = self.Theme
		local hasDesc = options.Description ~= nil and options.Description ~= ""
		local h = hasDesc and theme.DescHeight or theme.ElementHeight
		local btn = {}
		local _btnTextColor = options.Color

		btn.Container = U.Create("ImageButton", {
			Name = "Button",
			Size = UDim2.new(1, -12, 0, h + 6),
			Position = UDim2.fromOffset(6, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = self.Container,
		})
		self.Menu:_makeSelectable(btn.Container)
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn.Container })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = btn.Container })


		renderIcon(btn.Container, options.Icon or "rocket", {
			Name = "Pointer",
			Size = UDim2.fromOffset(26, 26),
			Position = hasDesc and UDim2.new(1, -38, 0, 16) or UDim2.new(1, -38, 0.5, -13),
			ImageTransparency = 0.5,
		})
		local btnIconX = 10
		local btnIconW = -54

		if hasDesc then
			U.Create("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, btnIconW, 0, 20),
				Position = UDim2.fromOffset(btnIconX, 5),
				BackgroundTransparency = 1,
				Text = options.Text or "Button",
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = options.Color or theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Container,
			})
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, btnIconW, 0, 16),
				Position = UDim2.fromOffset(btnIconX, 27),
				BackgroundTransparency = 1,
				Text = options.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Container,
			})
		else
			U.Create("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, btnIconW, 0, 20),
				Position = UDim2.fromOffset(btnIconX, (h + 6 - 20) / 2 + 1),
				BackgroundTransparency = 1,
				Text = options.Text or "Button",
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = options.Color or theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Container,
			})
		end

		btn.Container.MouseEnter:Connect(function()
			btn.Container.BackgroundColor3 = theme.ElementHover
			btn.Container.BackgroundTransparency = 0
		end)
		btn.Container.MouseLeave:Connect(function()
			btn.Container.BackgroundColor3 = theme.Element
			btn.Container.BackgroundTransparency = 0
		end)
		local _scale = U.Create("UIScale", { Parent = btn.Container })
		btn._scaleTween = nil
		btn.Container.MouseButton1Down:Connect(function()
			if btn._scaleTween then
				btn._scaleTween:Cancel()
			end
			btn.Container.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			btn._scaleTween =
				game:GetService("TweenService")
					:Create(_scale, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.97 })
			btn._scaleTween:Play()
		end)
		btn.Container.MouseButton1Up:Connect(function()
			if btn._scaleTween then
				btn._scaleTween:Cancel()
			end
			btn.Container.BackgroundColor3 = theme.ElementHover
			btn._scaleTween =
				game:GetService("TweenService")
					:Create(_scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 })
			btn._scaleTween:Play()
		end)
		btn.Container.MouseButton1Click:Connect(function()
			if options.Callback then
				options.Callback()
			end
		end)
		btn.SetText = function(text)
			local t = btn.Container:FindFirstChild("Text")
			if t then
				t.Text = text
			end
		end
		btn.SetCallback = function(cb)
			options.Callback = cb
		end
		btn.Destroy = function()
			if btn.Container then
				btn.Container:Destroy()
			end
		end
		btn.ApplyTheme = function(_, t)
			t = t or _
			if not btn.Container then
				return
			end
			btn.Container.BackgroundColor3 = t.Element
			local stroke = btn.Container:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = t.ElementBorder
			end
			local txt = btn.Container:FindFirstChild("Text")
			if txt then
				txt.Font = t.Font
				txt.TextSize = t.FontSize
				txt.TextColor3 = _btnTextColor or t.TextPrimary
			end
			local desc = btn.Container:FindFirstChild("Description")
			if desc then
				desc.Font = t.Font
				desc.TextSize = t.FontSizeSmall
				desc.TextColor3 = t.TextMuted
			end
		end

		if options.Tooltip and self.Menu then
			self.Menu:BindTooltip(btn.Container, options.Tooltip)
		end
		table.insert(self.Components, btn)
		return btn
	end

	function Tab:Label(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local hasDesc = options.Description ~= nil and options.Description ~= ""
		local h = hasDesc and self.Theme.DescHeight or self.Theme.ElementHeight
		local lbl = {}
		local _labelColor = options.Color
		local _labelTextSize = options.TextSize or self.Theme.FontSize

		lbl.Container = U.Create("Frame", {
			Name = "Label",
			Size = UDim2.new(1, 0, 0, h),
			BackgroundTransparency = 1,
			Parent = self.Container,
		})

		lbl.TextLabel = U.Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, 0, 0, hasDesc and 20 or h),
			Position = UDim2.fromOffset(0, hasDesc and 2 or (h - 20) / 2 + 1),
			BackgroundTransparency = 1,
			Text = options.Text or "",
			Font = self.Theme.Font,
			TextSize = _labelTextSize,
			TextColor3 = _labelColor or self.Theme.TextSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = lbl.Container,
		})

		if hasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, 0, 0, 16),
				Position = UDim2.fromOffset(0, 24),
				BackgroundTransparency = 1,
				Text = options.Description,
				Font = self.Theme.Font,
				TextSize = self.Theme.FontSizeSmall,
				TextColor3 = self.Theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = lbl.Container,
			})
		end

		lbl.SetText = function(text)
			lbl.TextLabel.Text = text
		end
		lbl.SetColor = function(c)
			lbl.TextLabel.TextColor3 = c
		end
		lbl.Destroy = function()
			if lbl.Container then
				lbl.Container:Destroy()
			end
		end
		lbl.ApplyTheme = function(_, t)
			t = t or _
			if not lbl.TextLabel then
				return
			end
			lbl.TextLabel.Font = t.Font
			lbl.TextLabel.TextSize = _labelTextSize
			lbl.TextLabel.TextColor3 = _labelColor or t.TextSecondary
			local d = lbl.Container:FindFirstChild("Description")
			if d then
				d.Font = t.Font
				d.TextSize = t.FontSizeSmall
				d.TextColor3 = t.TextMuted
			end
		end

		table.insert(self.Components, lbl)
		return lbl
	end

	function Tab:BoldLabel(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local hasDesc = options.Description ~= nil and options.Description ~= ""
		local h = hasDesc and self.Theme.DescHeight or self.Theme.ElementHeight
		local lbl = {}
		local _blColor = options.Color
		local _blTextSize = options.TextSize or self.Theme.FontSizeTitle

		lbl.Container = U.Create("Frame", {
			Name = "BoldLabel",
			Size = UDim2.new(1, 0, 0, h),
			BackgroundTransparency = 1,
			Parent = self.Container,
		})

		lbl.TextLabel = U.Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, 0, 0, hasDesc and 22 or h),
			Position = UDim2.fromOffset(0, hasDesc and 2 or (h - 22) / 2 + 1),
			BackgroundTransparency = 1,
			Text = options.Text or "",
			Font = self.Theme.FontBold,
			TextSize = _blTextSize,
			TextColor3 = _blColor or self.Theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = lbl.Container,
		})

		if hasDesc then
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, 0, 0, 16),
				Position = UDim2.fromOffset(0, 24),
				BackgroundTransparency = 1,
				Text = options.Description,
				Font = self.Theme.Font,
				TextSize = self.Theme.FontSizeSmall,
				TextColor3 = self.Theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = lbl.Container,
			})
		end

		lbl.SetText = function(text)
			lbl.TextLabel.Text = text
		end
		lbl.SetColor = function(c)
			lbl.TextLabel.TextColor3 = c
		end
		lbl.Destroy = function()
			if lbl.Container then
				lbl.Container:Destroy()
			end
		end
		lbl.ApplyTheme = function(_, t)
			t = t or _
			if not lbl.TextLabel then
				return
			end
			lbl.TextLabel.Font = t.FontBold
			lbl.TextLabel.TextSize = _blTextSize
			lbl.TextLabel.TextColor3 = _blColor or t.TextPrimary
			local d = lbl.Container:FindFirstChild("Description")
			if d then
				d.Font = t.Font
				d.TextSize = t.FontSizeSmall
				d.TextColor3 = t.TextMuted
			end
		end

		table.insert(self.Components, lbl)
		return lbl
	end

	function Tab:Divider()
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		local div = {}
		div.Container = U.Create("Frame", {
			Name = "Divider",
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundTransparency = 1,
			Parent = self.Container,
		})
		U.Create("Frame", {
			Name = "Line",
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundColor3 = self.Theme.Border,
			BorderSizePixel = 0,
			Parent = div.Container,
		})
		div.Destroy = function()
			if div.Container then
				div.Container:Destroy()
			end
		end
		div.ApplyTheme = function(_, t)
			t = t or _
			local line = div.Container:FindFirstChild("Line")
			if line then
				line.BackgroundColor3 = t.Border
			end
		end
		table.insert(self.Components, div)
		return div
	end

	function Tab:Slider(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local slider = Slider.new(self.Container, options, self.Theme)
		table.insert(self.Components, slider)
		if slider.Flag then
			self.Menu:_trackFlagged(slider)
		end
		if options.Tooltip and self.Menu then
			self.Menu:BindTooltip(slider.Container, options.Tooltip)
		end
		return slider
	end

	function Tab:ColorPicker(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local picker = ColorPicker.new(self.Container, options, self.Theme)
		table.insert(self.Components, picker)
		if picker.Flag then
			self.Menu:_trackFlagged(picker)
		end
		if options.Tooltip and self.Menu then
			self.Menu:BindTooltip(picker.Container, options.Tooltip)
		end
		return picker
	end

	function Tab:Dropdown(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local dd = Dropdown.new(self.Container, options, self.Theme, self.Menu)
		table.insert(self.Components, dd)
		if dd.Flag then
			self.Menu:_trackFlagged(dd)
		end
		if options.Tooltip and self.Menu then
			self.Menu:BindTooltip(dd.Container, options.Tooltip)
		end
		return dd
	end

	function Tab:Keybind(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local kb = Keybind.new(self.Container, options, self.Theme, self.Menu)
		table.insert(self.Components, kb)
		if kb.Flag then
			self.Menu:_trackFlagged(kb)
		end
		if options.Tooltip and self.Menu then
			self.Menu:BindTooltip(kb.Container, options.Tooltip)
		end
		return kb
	end

	function Tab:Input(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local ti = TextInput.new(self.Container, options, self.Theme)
		table.insert(self.Components, ti)
		if ti.Flag then
			self.Menu:_trackFlagged(ti)
		end
		if options.Tooltip and self.Menu then
			self.Menu:BindTooltip(ti.Container, options.Tooltip)
		end
		return ti
	end


	function Tab:Checkbox(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		options = options or {}
		local c = Checkbox.new(self.Container, options, self.Theme)
		table.insert(self.Components, c)
		self.Menu:_makeSelectable(c.Container)
		if c.Flag then
			self.Menu:_trackFlagged(c)
		end
		if options.Tooltip and self.Menu then
			self.Menu:BindTooltip(c.Container, options.Tooltip)
		end
		return c
	end
	function Tab:Collapsible(title, options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		local c = Collapsible.new(self.Container, title, options, self.Theme)
		c._menu = self.Menu
		table.insert(self.Components, c)
		return c
	end
	function Tab:Columns(options)
		if destroyedFactoryResult(self) then
			return nil, "destroyed"
		end
		local c = Columns.new(self.Container, options or {}, self.Theme, self.Menu)
		table.insert(self.Components, c)
		return c
	end
	function Tab:Destroy()
		if self._destroyed then
			return
		end
		self._destroyed = true
		if self.Menu and not self.Menu._destroyed then
			local removedIndex
			for i, tab in ipairs(self.Menu.Tabs) do
				if tab == self then
					removedIndex = i
					table.remove(self.Menu.Tabs, i)
					break
				end
			end
			if self.Menu.ActiveTab == self then
				local replacement = removedIndex and self.Menu.Tabs[math.min(removedIndex, #self.Menu.Tabs)] or nil
				if replacement then
					self.Menu:SelectTab(replacement)
				else
					self.Menu.ActiveTab = nil
					if self.Menu.ActiveBar then
						self.Menu.ActiveBar.BackgroundTransparency = 1
					end
				end
			elseif self.Menu.ActiveTab and self.Menu.ActiveBar then
				self.Menu:_positionActiveBar(self.Menu.ActiveTab, false)
			end
		end
		for _, c in ipairs(self.Components) do
			if c.Destroy then
				c:Destroy()
			end
		end
		self.Components = {}
		if self.Container then
			self.Container:Destroy()
		end
		if self.TabButton then
			self.TabButton:Destroy()
		end
	end

	function Tab:ApplyTheme(theme)
		self.Theme = theme
		if not self.TabButton then
			return
		end

		local lbl = self.TabButton:FindFirstChild("Label")
		if lbl then
			lbl.Font = theme.Font
			lbl.TextSize = theme.FontSize
		end

		if self.Container then
			self.Container.ScrollBarImageColor3 = theme.ScrollBar
			local layout = self.Container:FindFirstChildOfClass("UIListLayout")
			if layout then
				layout.Padding = UDim.new(0, theme.Spacing)
			end
		end

		for _, c in ipairs(self.Components) do
			if c.ApplyTheme then
				c:ApplyTheme(theme)
			end
		end

		if self.Menu and self.Menu.ActiveTab == self then
			self.TabButton.BackgroundTransparency = 0
			self.TabButton.BackgroundColor3 = theme.TabActive
			if self._glow then
				self._glow.BackgroundTransparency = 0.85
			end
			if lbl then
				lbl.TextColor3 = theme.SidebarTextActive
			end
		else
			self.TabButton.BackgroundTransparency = 1
			if lbl then
				lbl.TextColor3 = theme.SidebarText
			end
		end
	end

	local Menu = {}
	Menu.__index = Menu

	function Menu:_viewportSize()
		local camera = workspace.CurrentCamera
		return camera and camera.ViewportSize or Vector2.new(1920, 1080)
	end



	function Menu:_transition(instance, duration, properties, style, direction, onCompleted)
		if not instance then
			return nil
		end
		if self._reducedMotion then
			for property, value in pairs(properties) do
				instance[property] = value
			end
			if onCompleted then
				onCompleted()
			end
			return nil
		end
		local tween = game:GetService("TweenService"):Create(
			instance,
			TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
			properties
		)
		if onCompleted then
			tween.Completed:Connect(onCompleted)
		end
		tween:Play()
		return tween
	end





	function Menu:_resetWinHover()
		if not self.Topbar then
			return
		end
		for _, child in ipairs(self.Topbar:GetChildren()) do
			if child:IsA("ImageButton") then
				self:_transition(child, 0.12, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				local stroke = child:FindFirstChildOfClass("UIStroke")
				if stroke then
					self:_transition(stroke, 0.12, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				end
				local icon = child:FindFirstChild("Icon")
				if icon then
					self:_transition(icon, 0.12, { ImageColor3 = Color3.fromRGB(150, 150, 165) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local scale = icon:FindFirstChildOfClass("UIScale")
					if scale then
						self:_transition(scale, 0.12, { Scale = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					end
				end
			end
		end
	end


	function Menu:_nextSelectionOrder()
		self._selectionOrder = (self._selectionOrder or 0) + 1
		return self._selectionOrder
	end

	function Menu:_makeSelectable(instance)
		if not instance then
			return instance
		end
		instance.Selectable = true
		instance.Active = true
		instance.SelectionOrder = self:_nextSelectionOrder()
		return instance
	end

	function Menu:_selectionIsAvailable()
		if self._destroyed or self._capturingKeybind then
			return false
		end
		return game:GetService("UserInputService"):GetFocusedTextBox() == nil
	end

	function Menu:_isGamepadNavigation()
		return tostring(game:GetService("UserInputService"):GetLastInputType()):find("Gamepad", 1, true) ~= nil
	end

	function Menu:_beginTransientFocus(fallback)
		if not self:_selectionIsAvailable() or not self:_isGamepadNavigation() then
			return nil
		end
		local selected = game:GetService("GuiService").SelectedObject
		if selected and self.Gui and selected:IsDescendantOf(self.Gui) then
			return selected
		end
		return fallback
	end

	function Menu:_restoreTransientFocus(target)
		if not target or not target.Parent or not self:_selectionIsAvailable() then
			return
		end
		game:GetService("GuiService").SelectedObject = target
	end

	function Menu:_modalSize(preferredWidth, preferredHeight, minimumWidth, minimumHeight)
		local viewport = self:_viewportSize()
		local usableWidth = math.max(1, viewport.X - self.SafePadding * 2)
		local usableHeight = math.max(1, viewport.Y - self.SafePadding * 2)
		return math.min(preferredWidth, math.max(math.min(minimumWidth, usableWidth), usableWidth)),
			math.min(preferredHeight, math.max(math.min(minimumHeight, usableHeight), usableHeight))
	end

	function Menu:_applyResponsiveLayout()
		if self._destroyed or not self.Frame then
			return
		end
		local viewport = self:_viewportSize()
		local safe = self.SafePadding
		local scale = self.Scale or 1
		local usableWidth = math.max(1, (viewport.X - safe * 2) / scale)
		local usableHeight = math.max(1, (viewport.Y - safe * 2) / scale)
		local baseSize = self._responsiveBaseSize or self.Frame.Size
		local needsCompact = self.Responsive
			and (
				viewport.X <= self.CompactBreakpoint
				or baseSize.X.Offset > usableWidth
				or baseSize.Y.Offset > usableHeight
			)
		self._compact = needsCompact
		if not self.Responsive then
			return
		end
		if self._activePopupFrame then
			self:HideDropdownPopup()
		end

		if self.Maximized then
			self.Frame.Size = UDim2.fromOffset(usableWidth, usableHeight)
			self.Frame.Position = UDim2.fromOffset(safe, safe)
			self._responsiveApplied = true
		elseif needsCompact then
			self.Frame.Size =
				UDim2.fromOffset(math.min(baseSize.X.Offset, usableWidth), math.min(baseSize.Y.Offset, usableHeight))
			self.Frame.Position = UDim2.fromOffset(safe, safe)
			self._responsiveApplied = true
		elseif self._responsiveApplied then
			self.Frame.Size = baseSize
			self.Frame.Position = self._responsiveBasePosition or self._initialPos
			self._responsiveApplied = false
		end
		local sidebarWidth = needsCompact and math.min(self.Theme.SidebarWidth, 86) or self.Theme.SidebarWidth
		if self.Sidebar and self.ContentArea then
			self.Sidebar.Size = UDim2.new(0, sidebarWidth, 1, -(self.Theme.TopbarHeight + 4))
			self.ContentArea.Size = UDim2.new(1, -(sidebarWidth + 8), 1, -(self.Theme.TopbarHeight + 6))
			self.ContentArea.Position = UDim2.new(0, sidebarWidth + 6, 0, self.Theme.TopbarHeight + 4)
			if self.SidebarLine then
				self.SidebarLine.Position = UDim2.new(0, sidebarWidth + 4, 0, self.Theme.TopbarHeight + 6)
			end
		end
		if self.Minimized then
			self._minPrevSize = self.Frame.Size
			self._minPrevPos = self.Frame.Position
		end

		if self._updateShadow then
			self._updateShadow()
		end
		if self._tooltipActive then
			self:_updateTooltipPosition()
		end
		if self.NotifBox then
			self.NotifBox.Size = UDim2.new(0, math.min(320, viewport.X - safe * 2), 1, -(safe * 2))
			self.NotifBox.Position = UDim2.new(1, -safe, 1, -safe)
		end
		if self._paletteFrame then
			local palW, palH = self:_modalSize(380, 310, 180, 180)
			self._paletteFrame.Size = UDim2.fromOffset(palW, palH)
		end
	end

	function Menu:_bindResponsiveViewport()
		if not self.Responsive then
			return
		end
		local function bindCamera(camera)
			if self._cameraViewportCon then
				self._cameraViewportCon:Disconnect()
				self._cameraViewportCon = nil
			end
			if camera then
				self._cameraViewportCon = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					self:_applyResponsiveLayout()
				end)
			end
			self:_applyResponsiveLayout()
		end
		self._cameraCon = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			if not self._destroyed then
				bindCamera(workspace.CurrentCamera)
			end
		end)
		bindCamera(workspace.CurrentCamera)
	end

	function Menu.new(options, theme)

		local defaultFloatingResolved = resolveIcon("fyyui-floating-logo")
		-- Keep the window header text-only. Branding is shown exclusively on
		-- the floating restore button while the window is minimized.
		local defaultFloatingLogoAsset = defaultFloatingResolved and defaultFloatingResolved.Image
		local floatingLogoAsset = defaultFloatingLogoAsset
		if options.Logo == false then
			floatingLogoAsset = nil
		elseif type(options.Logo) == "string" then
			local resolved = resolveIcon(options.Logo)
			floatingLogoAsset = (resolved and resolved.Image) or options.Logo
		end
		local preloadAssets = {}
		if floatingLogoAsset then table.insert(preloadAssets, floatingLogoAsset) end
		local contentProvider = game:GetService("ContentProvider")
		local pending = {}
		for _, asset in ipairs(preloadAssets) do pending[asset] = true end
		local preloadStartedAt = os.clock()
		while next(pending) and os.clock() - preloadStartedAt < 15 do
			local observed = {}
			pcall(function()
				contentProvider:PreloadAsync(preloadAssets, function(asset, status)
					observed[asset] = true
					if status == Enum.AssetFetchStatus.Success then pending[asset] = nil end
				end)
			end)
			for _, asset in ipairs(preloadAssets) do
				if not observed[asset] and contentProvider:GetAssetFetchStatus(asset) == Enum.AssetFetchStatus.Success then
					pending[asset] = nil
				end
			end
			if next(pending) then task.wait(0.25) end
		end
		if next(pending) then
			warn("FyyUI: logo preload timed out; continuing with Roblox asset loading")
		end

		local self = setmetatable({}, Menu)
		self.Options = options
		self.Theme = theme
		assert(
			options.Stats == nil or type(options.Stats) == "boolean" or type(options.Stats) == "table",
			"FyyUI Menu: Stats must be a boolean or table"
		)
		assert(options.Support == nil or type(options.Support) == "table", "FyyUI Menu: Support must be a table")
		local statsOptions = type(options.Stats) == "table" and options.Stats or {}
		assert(
			statsOptions.Enabled == nil or type(statsOptions.Enabled) == "boolean",
			"FyyUI Menu: Stats.Enabled must be a boolean"
		)
		assert(
			statsOptions.TabName == nil or (type(statsOptions.TabName) == "string" and statsOptions.TabName ~= ""),
			"FyyUI Menu: Stats.TabName must be a non-empty string"
		)
		for _, key in ipairs({ "ShowProfile", "ShowGame", "ShowServer", "ShowSupport" }) do
			assert(
				statsOptions[key] == nil or type(statsOptions[key]) == "boolean",
				("FyyUI Menu: Stats.%s must be a boolean"):format(key)
			)
		end
		local supportOptions = options.Support or {}
		for _, key in ipairs({ "Title", "Description", "ButtonText", "Discord" }) do
			assert(
				supportOptions[key] == nil or type(supportOptions[key]) == "string",
				("FyyUI Menu: Support.%s must be a string"):format(key)
			)
		end
		assert(
			supportOptions.ButtonIcon == nil
				or type(supportOptions.ButtonIcon) == "string"
				or type(supportOptions.ButtonIcon) == "number"
				or type(supportOptions.ButtonIcon) == "table",
			"FyyUI Menu: Support.ButtonIcon must be a supported icon value"
		)
		assert(
			supportOptions.Callback == nil or type(supportOptions.Callback) == "function",
			"FyyUI Menu: Support.Callback must be a function"
		)
		self.StatsConfig = {
			Enabled = options.Stats == true or (type(options.Stats) == "table" and statsOptions.Enabled ~= false),
			TabName = statsOptions.TabName or "Overview",
			TabIcon = statsOptions.TabIcon or "user-round",
			ShowProfile = statsOptions.ShowProfile ~= false,
			ShowGame = statsOptions.ShowGame ~= false,
			ShowServer = statsOptions.ShowServer ~= false,
			ShowSupport = statsOptions.ShowSupport ~= false,
		}
		self.SupportConfig = supportOptions
		self.Tabs = {}
		self._flagRegistry = {}
		self._pendingConfigValues = {}
		self._configTabs = {}
		self._keybindList = {}
		self._capturingKeybind = nil
		self._selectionOrder = 0

		self._paletteOpen = false
		self._paletteOverlay = nil
		self._paletteFrame = nil
		self._paletteSearchBox = nil
		self._paletteResults = nil
		self._paletteEmpty = nil
		self._paletteIndex = {}
		self._paletteFilteredResults = {}
		self._paletteResultButtons = {}
		self._paletteSelectedIndex = 0
		self._overviewConns = {}
		self._destroyCallbacks = {}
		self._minimizeChangedCallbacks = {}
		self._inputCapturePrefix = ("FyyUI_%s_%s"):format(
			tostring(self):gsub("[^%w]", ""),
			tostring(os.clock()):gsub("%D", "")
		)
		self._capturedActions = {}
		self.Minimized = false
		self._restoring = false
		self._minimizeToken = 0
		local paletteMaxResults = options.PaletteMaxResults == nil and 60 or options.PaletteMaxResults
		assert(
			isFiniteNumber(paletteMaxResults) and paletteMaxResults >= 1,
			"FyyUI Menu: PaletteMaxResults must be a positive number"
		)
		self._paletteMaxResults = math.floor(paletteMaxResults)
		self._paletteConns = {}
		self.ActiveTab = nil
		self.Visible = options.Visible ~= false
		self.MinSize = options.MinSize or Vector2.new(320, 300)
		self.MaxSize = options.MaxSize or Vector2.new(850, 560)
		assert(
			typeof(self.MinSize) == "Vector2" and typeof(self.MaxSize) == "Vector2",
			"FyyUI Menu: MinSize and MaxSize must be Vector2 values"
		)
		assert(
			isFiniteNumber(self.MinSize.X) and isFiniteNumber(self.MinSize.Y) and self.MinSize.X > 0 and self.MinSize.Y > 0,
			"FyyUI Menu: MinSize must be positive"
		)
		assert(
			isFiniteNumber(self.MaxSize.X)
				and isFiniteNumber(self.MaxSize.Y)
				and self.MaxSize.X >= self.MinSize.X
				and self.MaxSize.Y >= self.MinSize.Y,
			"FyyUI Menu: MaxSize must be at least MinSize"
		)
		self.Resizable = options.Resizable or false
		assert(
			options.Responsive == nil or type(options.Responsive) == "boolean",
			"FyyUI Menu: Responsive must be a boolean"
		)
		self.Responsive = options.Responsive ~= false
		local compactBreakpoint = options.CompactBreakpoint == nil and 640 or options.CompactBreakpoint
		assert(
			isFiniteNumber(compactBreakpoint) and compactBreakpoint > 0,
			"FyyUI Menu: CompactBreakpoint must be a positive finite number"
		)
		self.CompactBreakpoint = math.floor(compactBreakpoint)
		self._compact = false
		local safePadding = options.SafePadding == nil and 12 or options.SafePadding
		assert(
			isFiniteNumber(safePadding) and safePadding >= 0,
			"FyyUI Menu: SafePadding must be a non-negative finite number"
		)
		self.SafePadding = safePadding
		local touchTargetSize = options.TouchTargetSize == nil and 36 or options.TouchTargetSize
		assert(
			isFiniteNumber(touchTargetSize) and touchTargetSize >= 24,
			"FyyUI Menu: TouchTargetSize must be a finite number of at least 24"
		)
		self.TouchTargetSize = math.floor(touchTargetSize)
		local requestedScale = options.Scale == nil and 1 or options.Scale
		assert(isFiniteNumber(requestedScale), "FyyUI Menu: Scale must be a finite number")
		self.Scale = math.clamp(requestedScale, 0.75, 1.35)
		assert(
			options.ReducedMotion == nil or type(options.ReducedMotion) == "boolean",
			"FyyUI Menu: ReducedMotion must be a boolean"
		)
		self._reducedMotion = options.ReducedMotion == true


		self._tooltips = {}
		self._tooltipActive = false
		self._tooltipPending = false
		self._tooltipTarget = nil
		self._tooltipTween = nil
		self._mousePos = Vector2.new(0, 0)

		local size
		if options.Size then
			assert(typeof(options.Size) == "UDim2", "FyyUI Menu: Size must be a UDim2")
			local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
			size = Vector2.new(
				options.Size.X.Offset + options.Size.X.Scale * viewport.X,
				options.Size.Y.Offset + options.Size.Y.Scale * viewport.Y
			)
		else
			size = Vector2.new(601, 344)
		end
		size = Vector2.new(
			math.clamp(size.X, self.MinSize.X, self.MaxSize.X),
			math.clamp(size.Y, self.MinSize.Y, self.MaxSize.Y)
		)
		local pos = options.Position or UDim2.new(0.5, -size.X / 2, 0.5, -size.Y / 2)
		self._initialSize = UDim2.fromOffset(size.X, size.Y)
		self._initialPos = pos
		self._responsiveBaseSize = self._initialSize
		self._responsiveBasePosition = pos

		self.GuiParent = options.Parent or game:GetService("CoreGui")

		self.Gui = U.Create("ScreenGui", {
			Name = options.Title or "FyyUI",
			DisplayOrder = 100,
			IgnoreGuiInset = true,
			Enabled = self.Visible,
		})

		self.Frame = U.Create("Frame", {
			Name = "Main",
			Size = UDim2.fromOffset(size.X, size.Y),
			Position = pos,
			BackgroundColor3 = theme.Background,
			BackgroundTransparency = options.BackgroundTransparency or (options.Transparent and 0.15 or 0),
			BorderSizePixel = 0,
			Parent = self.Gui,
		})
		self._baseBackgroundTransparency = self.Frame.BackgroundTransparency
		U.Create("UICorner", { CornerRadius = UDim.new(0, theme.CornerRadius), Parent = self.Frame })

		self._uiScale = U.Create("UIScale", { Parent = self.Frame, Scale = self.Scale })

		if options.HasOutline ~= false then
			U.Create("UIStroke", {
				Color = theme.Outline,
				Thickness = 1,
				Transparency = 0.25,
				Parent = self.Frame,
			})
		end

		if options.Shadow then
			local shadowFrame = U.Create("Frame", {
				Name = "Shadow",
				Size = UDim2.fromOffset(size.X + 16, size.Y + 16),
				Position = UDim2.fromOffset(-8, -8),
				BackgroundColor3 = theme.Shadow,
				BackgroundTransparency = 0.55,
				BorderSizePixel = 0,
				ZIndex = 0,
				Parent = self.Gui,
			})
			U.Create("UICorner", { CornerRadius = UDim.new(0, theme.CornerRadius + 2), Parent = shadowFrame })
			self._shadow = shadowFrame
			self._updateShadow = function()
				if not self._shadow then
					return
				end
				local s = self.Frame.Size
				self._shadow.Size = UDim2.fromOffset(s.X.Offset + 16, s.Y.Offset + 16)
				self._shadow.Position = UDim2.fromOffset(self.Frame.Position.X.Offset - 8, self.Frame.Position.Y.Offset - 8)
			end
		end


		self.Topbar = U.Create("Frame", {
			Name = "Topbar",
			Size = UDim2.new(1, 0, 0, theme.TopbarHeight),
			BackgroundColor3 = theme.Topbar,
			BorderSizePixel = 0,
			Parent = self.Frame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, theme.CornerRadius), Parent = self.Topbar })
		U.Create("Frame", {
			Name = "Fill",
			Size = UDim2.new(1, 0, 0, theme.CornerRadius),
			Position = UDim2.new(0, 0, 1, -theme.CornerRadius),
			BackgroundColor3 = theme.Topbar,
			BorderSizePixel = 0,
			Parent = self.Topbar,
		})
		self.TopbarDragSurface = U.Create("Frame", {
			Name = "DragSurface",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = true,
			Parent = self.Topbar,
		})

		local topCfg = options.Topbar or {}
		local btnType = topCfg.ButtonsType or "Default"
		local titleAlign = topCfg.TitleAlignment or "Left"
		local leftMargin = 10
		local rightMargin = 10


		if btnType == "Mac" then
			local btnColors = {
				Close = Color3.fromRGB(255, 95, 87),
				Minimize = Color3.fromRGB(255, 189, 46),
				Maximize = Color3.fromRGB(39, 201, 63),
			}
			local btnSize = 12
			local hitSize = 44
			local spacing = 4

			local macIconNames = { Close = "x", Minimize = "minus", Maximize = "scan" }
			local function macBtn(name, color, action)
				local b = U.Create("ImageButton", {
					Name = name,
					Size = UDim2.fromOffset(hitSize, hitSize),
					Position = UDim2.new(0, rightMargin, 0, 0),
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					ZIndex = 3,
					Parent = self.Topbar,
				})
				self:_makeSelectable(b)
				local dot = U.Create("Frame", {
					Name = "Dot",
					Size = UDim2.fromOffset(btnSize, btnSize),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = color,
					BorderSizePixel = 0,
					Parent = b,
				})
				U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
				renderIcon(b, macIconNames[name], {
					Name = "Icon",
					Size = UDim2.fromOffset(8, 8),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageColor3 = Color3.fromRGB(60, 60, 72),
					ZIndex = 4,
				})
				b.Activated:Connect(action)
				rightMargin = rightMargin + hitSize + spacing
				return b
			end

			macBtn("Close", btnColors.Close, function()
				self:_confirmClose()
			end)
			macBtn("Minimize", btnColors.Minimize, function()
				if self.Minimized then
					self:_restore()
				else
					self:_minimize()
				end
			end)
			macBtn("Maximize", btnColors.Maximize, function()
				self:_toggleMaximize()
			end)

			leftMargin = rightMargin + 8
			rightMargin = 10
		else
			local WIN_ICONS = {
				Minimize = "rbxassetid://118026365011536",
				Maximize = "rbxassetid://123104789658180",
				Close = "rbxassetid://110786993356448",
			}
			local function winBtn(name, action, xOff, hoverC)
				local b = U.Create("ImageButton", {
					Name = name,
					Size = UDim2.fromOffset(44, 44),
					Position = UDim2.new(1, xOff, 0, 0),
					BackgroundTransparency = 1,
					BackgroundColor3 = hoverC,
					AutoButtonColor = false,
					ZIndex = 3,
					Parent = self.Topbar,
				})
				self:_makeSelectable(b)
				U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = b })

				local stroke = U.Create("UIStroke", {
					Color = hoverC,
					Thickness = 1,
					Transparency = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = b,
				})
				U.Create("UIGradient", {
					Color = ColorSequence.new(hoverC, Color3.new(1, 1, 1)),
					Rotation = 90,
					Parent = stroke,
				})
				local icon = U.Create("ImageLabel", {
					Name = "Icon",
					Size = UDim2.fromOffset(18, 18),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ImageColor3 = Color3.fromRGB(150, 150, 165),
					Image = WIN_ICONS[name],
					ZIndex = 4,
					Parent = b,
				})
				local iconScale = U.Create("UIScale", { Scale = 1, Parent = icon })
				b.MouseEnter:Connect(function()
					self:_transition(b, 0.15, { BackgroundTransparency = 0.15 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					self:_transition(stroke, 0.15, { Transparency = 0.45 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					self:_transition(icon, 0.15, { ImageColor3 = Color3.fromRGB(235, 235, 245) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					self:_transition(iconScale, 0.2, { Scale = 1.15 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				end)
				b.MouseLeave:Connect(function()
					self:_transition(b, 0.18, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					self:_transition(stroke, 0.18, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					self:_transition(icon, 0.18, { ImageColor3 = Color3.fromRGB(150, 150, 165) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					self:_transition(iconScale, 0.18, { Scale = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				end)
				b.Activated:Connect(action)
				return b
			end
			winBtn("Close", function()
				self:_confirmClose()
			end, -44, Color3.fromRGB(200, 60, 60))
			winBtn("Maximize", function()
				self:_resetWinHover()
				self:_toggleMaximize()
			end, -88, Color3.fromRGB(45, 45, 55))
			winBtn("Minimize", function()
				if self.Minimized then
					self:_resetWinHover()
					self:_restore()
				else
					self:_resetWinHover()
					self:_minimize()
				end
			end, -132, Color3.fromRGB(45, 45, 55))
		end


		local _logoImage = floatingLogoAsset
		local function animateFloatingBorder(stroke)
			task.spawn(function()
				local bright = true
				while not self._destroyed and stroke and stroke.Parent do
					local targetColor = bright and self.Theme.AccentLine or self.Theme.Accent
					local tween = game:GetService("TweenService"):Create(
						stroke,
						TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{
							Color = targetColor,
							Transparency = bright and 0.05 or 0.42,
							Thickness = bright and 3 or 1.5,
						}
					)
					tween:Play()
					tween.Completed:Wait()
					bright = not bright
				end
			end)
		end


		local function createLogo(parent, name, assets, size, position, anchorPoint, zidx)
			local logo = U.Create("ImageLabel", {
				Name = name,
				Size = size,
				Position = position,
				AnchorPoint = anchorPoint or Vector2.zero,
				BackgroundTransparency = 1,
				Image = assets[1],
				ImageTransparency = 0,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = zidx,
				Parent = parent,
			})
			return logo
		end

		self._titleText = options.Title or "FyyUI"
		local titleX = leftMargin + 12
		local titleSize = 17
		local titleGap = 5
		self.TitleAccent = U.Create("TextLabel", {
			Name = "TitleAccent",
			Size = UDim2.fromOffset(30, theme.TopbarHeight),
			Position = UDim2.fromOffset(titleX, 0),
			BackgroundTransparency = 1,
			Text = "Fyy",
			Font = Enum.Font.BuilderSansExtraBold,
			TextSize = titleSize,
			TextColor3 = theme.Accent,
			TextStrokeColor3 = theme.AccentLine,
			TextStrokeTransparency = 0.78,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = false,
			ZIndex = 2,
			Parent = self.Topbar,
		})
		self._titleGradient = U.Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, theme.Accent),
				ColorSequenceKeypoint.new(0.5, theme.AccentLine),
				ColorSequenceKeypoint.new(1, theme.Accent),
			}),
			Rotation = 18,
			Offset = Vector2.new(-1, 0),
			Parent = self.TitleAccent,
		})
		self.Title = U.Create("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -(titleX + 40), 1, 0),
			Position = UDim2.fromOffset(titleX, 0),
			BackgroundTransparency = 1,
			Text = "",
			Font = Enum.Font.BuilderSansBold,
			TextSize = titleSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = titleAlign == "Right" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
			ZIndex = 2,
			Parent = self.Topbar,
		})
		self._refreshTitle = function()
			local branded = titleAlign ~= "Right" and #self._titleText >= 3
			self._titleBranded = branded
			self.TitleAccent.Visible = branded
			if branded then
				local remainder = self._titleText:sub(4):gsub("^%s+", "")
				local initials = self._titleText:sub(1, 3)
				local accentWidth = game:GetService("TextService"):GetTextSize(
					initials,
					titleSize,
					Enum.Font.BuilderSansExtraBold,
					Vector2.new(200, theme.TopbarHeight)
				).X
				self.TitleAccent.Text = initials
				self.TitleAccent.Size = UDim2.fromOffset(accentWidth + 2, theme.TopbarHeight)
				self.Title.Text = remainder
				self.Title.Position = UDim2.fromOffset(titleX + accentWidth + titleGap, 0)
				self.Title.Size = UDim2.new(1, -(titleX + accentWidth + titleGap + 40), 1, 0)
			else
				self.Title.Text = self._titleText
				self.Title.Position = UDim2.fromOffset(titleX, 0)
				self.Title.Size = UDim2.new(1, -(titleX + 40), 1, 0)
			end
		end
		self._refreshTitle()
		if not self._reducedMotion then
			task.spawn(function()
				while not self._destroyed and self._titleGradient and self._titleGradient.Parent do
					self._titleGradient.Offset = Vector2.new(-1, 0)
					local sweep = game:GetService("TweenService"):Create(
						self._titleGradient,
						TweenInfo.new(1.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{ Offset = Vector2.new(1, 0) }
					)
					sweep:Play()
					sweep.Completed:Wait()
					task.wait(0.18)
				end
			end)
		else
			self._titleGradient.Offset = Vector2.zero
		end


		self.AccentLine = U.Create("Frame", {
			Name = "AccentLine",
			Size = UDim2.new(1, -20, 0, 2),
			Position = UDim2.new(0, 10, 1, 0),
			BackgroundColor3 = theme.AccentLine,
			BorderSizePixel = 0,
			Parent = self.Topbar,
		})
		self.Topbar.MouseEnter:Connect(function()
			if self.AccentLine then
				self.AccentLine.BackgroundColor3 = theme.Accent
			end
		end)
		self.Topbar.MouseLeave:Connect(function()
			if self.AccentLine then
				self.AccentLine.BackgroundColor3 = theme.AccentLine
			end
		end)


		local sbw = theme.SidebarWidth
		self.Sidebar = U.Create("Frame", {
			Name = "Sidebar",
			Size = UDim2.new(0, sbw, 1, -(theme.TopbarHeight + 4)),
			Position = UDim2.new(0, 2, 0, theme.TopbarHeight + 4),
			BackgroundColor3 = theme.Sidebar,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = self.Frame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Sidebar })

		self.SidebarList = U.Create("ScrollingFrame", {
			Name = "TabList",
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Parent = self.Sidebar,
		})
		local sidebarListLayout = U.Create("UIListLayout", {
			Padding = UDim.new(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = self.SidebarList,
		})
		sidebarListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if self.SidebarList then
				self.SidebarList.CanvasSize = UDim2.new(0, 0, 0, sidebarListLayout.AbsoluteContentSize.Y)
			end
		end)


		self._sidebarScrollCon = self.SidebarList:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			if self.ActiveTab and self.ActiveBar and self.SidebarList then
				self:_positionActiveBar(self.ActiveTab, false)
			end
		end)


		self.ActiveBar = U.Create("Frame", {
			Name = "ActiveBar",
			Size = UDim2.fromOffset(4, 20),
			Position = UDim2.fromOffset(5, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = theme.Accent,
			BorderSizePixel = 0,
			ZIndex = 2,
			Parent = self.Sidebar,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.ActiveBar })


		self.ContentArea = U.Create("Frame", {
			Name = "Content",
			Size = UDim2.new(1, -(sbw + 8), 1, -(theme.TopbarHeight + 6)),
			Position = UDim2.new(0, sbw + 6, 0, theme.TopbarHeight + 4),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Parent = self.Frame,
		})


		self._activePopupFrame = nil
		self._popupUISCon = nil


		self.SidebarLine = U.Create("Frame", {
			Name = "SidebarLine",
			Size = UDim2.new(0, 1, 1, -(theme.TopbarHeight + 10)),
			Position = UDim2.new(0, sbw + 4, 0, theme.TopbarHeight + 6),
			BackgroundColor3 = theme.Border,
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			ZIndex = 1,
			Parent = self.Frame,
		})


		self._notifGui = U.Create("ScreenGui", {
			Name = "FyyUI_Notifs",
			DisplayOrder = 200,
			IgnoreGuiInset = true,
			Enabled = self.Visible,
			Parent = self.GuiParent,
		})
		self.NotifBox = U.Create("Frame", {
			Name = "Notifications",
			Size = UDim2.new(0, 320, 1, -(self.SafePadding * 2)),
			Position = UDim2.new(1, -self.SafePadding, 1, -self.SafePadding),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 50,
			Parent = self._notifGui,
		})
		self._activeNotifs = {}


		local requestedFloatingSize = options.FloatingButtonSize
		if not isFiniteNumber(requestedFloatingSize) then
			requestedFloatingSize = math.max(58, self.TouchTargetSize + 12)
		end
		local floatingButtonSize = math.clamp(requestedFloatingSize, 48, 84)

		if _logoImage then
			self._minGui = U.Create("ScreenGui", {
				Name = "FyyUI_Min",
				DisplayOrder = 999,
				ResetOnSpawn = false,
				Enabled = false,
			})
			local iconSize = floatingButtonSize
			self._minInitialPos = UDim2.new(0, self.SafePadding, 0.5, -(iconSize / 2))
			self._minFrame = U.Create("ImageButton", {
				Name = "MinIcon",
				Size = UDim2.fromOffset(iconSize, iconSize),
				Position = self._minInitialPos,
				BackgroundColor3 = theme.Element,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Active = true,
				Parent = self._minGui,
			})
			self._minScale = U.Create("UIScale", { Parent = self._minFrame, Scale = 1 })
			U.Create("UICorner", { CornerRadius = UDim.new(0, math.floor(iconSize * 0.24)), Parent = self._minFrame })
			self._minStroke = U.Create("UIStroke", {
				Color = theme.Accent,
				Thickness = 2,
				Transparency = 0.2,
				Parent = self._minFrame,
			})
			animateFloatingBorder(self._minStroke)
			local minAssets = { _logoImage }
			if _logoImage ~= defaultFloatingLogoAsset then
				table.insert(minAssets, defaultFloatingLogoAsset)
			end
			local minIcon = createLogo(
				self._minFrame,
				"Icon",
				minAssets,
				UDim2.new(1, -8, 1, -8),
				UDim2.fromScale(0.5, 0.5),
				Vector2.new(0.5, 0.5),
				1
			)
			U.Create("UICorner", { CornerRadius = UDim.new(0, math.floor(iconSize * 0.2)), Parent = minIcon })


			local dragging, dragStart, startPos, didDrag
			self._minFrame.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					if self._restoring then
						return
					end
					dragging = true
					didDrag = false
					dragStart = i.Position
					startPos = self._minFrame.Position
				end
			end)
			self._minFrame.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					dragging = false
					if not didDrag then
						self:_restore()
					end
				end
			end)
			self._minDragInputCon = game:GetService("UserInputService").InputChanged:Connect(function(i)
				if
					dragging
					and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch)
				then
					local delta = i.Position - dragStart
					if delta.Magnitude > 5 then
						didDrag = true
					end
					self._minFrame.Position = UDim2.new(
						startPos.X.Scale,
						startPos.X.Offset + delta.X,
						startPos.Y.Scale,
						startPos.Y.Offset + delta.Y
					)
					self._minSavedPos = self._minFrame.Position
				end
			end)
		else

			self._noLogoRestoreGui = U.Create("ScreenGui", {
				Name = "FyyUI_NoLogoRestore",
				DisplayOrder = 999,
				ResetOnSpawn = false,
				Enabled = false,
			})
			self._noLogoRestoreBtn = U.Create("TextButton", {
				Name = "RestoreBtn",
				Size = UDim2.fromOffset(floatingButtonSize, floatingButtonSize),
				Position = UDim2.new(0.5, -(floatingButtonSize / 2), 0.5, -(floatingButtonSize / 2)),
				BackgroundColor3 = theme.Element,
				BackgroundTransparency = 0,
				Text = "Ă˘ËÂ°",
				Font = Enum.Font.GothamBold,
				TextSize = 24,
				TextColor3 = theme.TextPrimary,
				AutoButtonColor = false,
				Parent = self._noLogoRestoreGui,
			})
			U.Create("UICorner", {
				CornerRadius = UDim.new(0, math.floor(floatingButtonSize * 0.24)),
				Parent = self._noLogoRestoreBtn,
			})
			self._noLogoStroke = U.Create("UIStroke", {
				Color = theme.Accent,
				Thickness = 2,
				Transparency = 0.2,
				Parent = self._noLogoRestoreBtn,
			})
			animateFloatingBorder(self._noLogoStroke)

			local nlDragging, nlDragStart, nlStartPos, nlDidDrag
			self._noLogoRestoreBtn.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					if self._restoring then
						return
					end
					nlDragging = true
					nlDidDrag = false
					nlDragStart = i.Position
					nlStartPos = self._noLogoRestoreBtn.Position
				end
			end)
			self._noLogoRestoreBtn.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					nlDragging = false
					if not nlDidDrag then
						self:_restore()
					end
				end
			end)
			self._noLogoDragCon = game:GetService("UserInputService").InputChanged:Connect(function(i)
				if
					nlDragging
					and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch)
				then
					local delta = i.Position - nlDragStart
					if delta.Magnitude > 5 then
						nlDidDrag = true
					end
					self._noLogoRestoreBtn.Position = UDim2.new(
						nlStartPos.X.Scale,
						nlStartPos.X.Offset + delta.X,
						nlStartPos.Y.Scale,
						nlStartPos.Y.Offset + delta.Y
					)
					self._noLogoSavedPos = self._noLogoRestoreBtn.Position
				end
			end)
		end


		self._tooltipLabel = U.Create("TextLabel", {
			Name = "Tooltip",
			Size = UDim2.fromOffset(0, 0),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 50000,
			Visible = false,
			Text = "",
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			RichText = true,
			Parent = self.Frame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = self._tooltipLabel })
		U.Create("UIStroke", { Color = theme.Outline, Thickness = 1, Transparency = 0.25, Parent = self._tooltipLabel })

		self:_dragging()

		self.Gui.Parent = self.GuiParent
		self:_bindResponsiveViewport()

		if self.Resizable then
			self:_resizable()
		end


		do
			local uis = game:GetService("UserInputService")
			self._keybindInputCon = uis.InputBegan:Connect(function(input, gpe)

				if
					self.Visible
					and not self.Minimized
					and not self._capturingKeybind
					and input.UserInputType == Enum.UserInputType.Keyboard
					and input.KeyCode == Enum.KeyCode.K
					and (uis:IsKeyDown(Enum.KeyCode.LeftControl) or uis:IsKeyDown(Enum.KeyCode.RightControl))
				then
					local focusedBox = uis:GetFocusedTextBox()
					if focusedBox and focusedBox ~= self._paletteSearchBox then
						return
					end
					self:ToggleCommandPalette()
					return
				end


				if self._capturingKeybind then
					local kb = self._capturingKeybind

					if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
						kb:_exitCapture()
						return
					end

					if
						input.UserInputType == Enum.UserInputType.Keyboard
						or input.UserInputType == Enum.UserInputType.MouseButton1
						or input.UserInputType == Enum.UserInputType.MouseButton2
						or input.UserInputType == Enum.UserInputType.MouseButton3
					then
						kb:_setFromInput(input)
						kb:_exitCapture()
					end
					return
				end


				if self._paletteOpen and input.UserInputType == Enum.UserInputType.Keyboard then
					local k = input.KeyCode
					if
						k == Enum.KeyCode.Up
						or k == Enum.KeyCode.Down
						or k == Enum.KeyCode.Return
						or k == Enum.KeyCode.Escape
					then
						return
					end
				end


				if gpe then
					return
				end


				for _, kb in ipairs(self._keybindList) do
					if kb._keyCode then
						local match = false
						if input.UserInputType == Enum.UserInputType.Keyboard and kb._inputType == "Keyboard" then
							match = input.KeyCode == kb._keyCode
						elseif kb._inputType == "MouseButton" then
							match = input.UserInputType == kb._keyCode
						end
						if match then
							kb:_onInput(input)
						end
					end
				end
			end)

			self._keybindEndCon = uis.InputEnded:Connect(function(input, gpe)
				if gpe then
					return
				end
				for _, kb in ipairs(self._keybindList) do
					if kb.Mode == "Hold" and kb._keyCode then
						local match = false
						if input.UserInputType == Enum.UserInputType.Keyboard and kb._inputType == "Keyboard" then
							match = input.KeyCode == kb._keyCode
						elseif kb._inputType == "MouseButton" then
							match = input.UserInputType == kb._keyCode
						end
						if match then
							kb:_onInputEnd(input)
						end
					end
				end
			end)
		end


		local uis = game:GetService("UserInputService")
		self._mouseCon = uis.InputChanged:Connect(function(input, gpe)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				self._mousePos = input.Position
				if self._tooltipActive and self._tooltipLabel and self._tooltipLabel.Visible then
					self:_updateTooltipPosition()
				end
			end
		end)
		self:_createOverview()

		return self
	end
	function Menu:_positionActiveBar(tab, animate)
		if not tab or not self.ActiveBar then
			return
		end
		local tabIdx = 0
		for i, candidate in ipairs(self.Tabs) do
			if candidate == tab then
				tabIdx = i
				break
			end
		end
		if tabIdx == 0 then
			return
		end

		if self._activeBarTween then
			self._activeBarTween:Cancel()
			self._activeBarTween = nil
		end

		local scrollY = self.SidebarList and self.SidebarList.CanvasPosition.Y or 0
		local barY = (tabIdx - 1) * 40 + 9 - scrollY
		local position = UDim2.fromOffset(5, barY)
		local viewportHeight = self.SidebarList and self.SidebarList.AbsoluteSize.Y or 0
		local barHeight = math.max(self.ActiveBar.Size.Y.Offset, self.ActiveBar.AbsoluteSize.Y)
		local isInsideViewport = viewportHeight <= 0 or (barY + barHeight > 0 and barY < viewportHeight)
		self.ActiveBar.Visible = isInsideViewport
		self.ActiveBar.BackgroundTransparency = 0
		if not isInsideViewport then
			self.ActiveBar.Position = position
			return
		end
		if animate then
			local tween = self:_transition(self.ActiveBar, 0.22, { Position = position })
			self._activeBarTween = tween
			if tween then
				tween.Completed:Connect(function()
					if self._activeBarTween == tween then
						self._activeBarTween = nil
					end
				end)
			else
				self._activeBarTween = nil
			end
		else
			self.ActiveBar.Position = position
		end
	end

	function Menu:SelectTab(tab)
		if self.ActiveTab == tab then
			return
		end
		self:HideDropdownPopup()
		if self.ActiveTab and self.ActiveTab._isOverview then
			self:_releaseInput("OverviewWheel")
			self:_releaseInput("OverviewTouch")
		end
		local offsetY = 36


		local hadPrevTab = self.ActiveTab ~= nil
		if self.ActiveTab then
			local old = self.ActiveTab
			old.Container.Visible = false
			old.Container.Position = UDim2.fromOffset(6, 6)
			old.TabButton.BackgroundTransparency = 1
			if old._glow then
				old._glow.BackgroundTransparency = 1
			end
			local lbl = old.TabButton:FindFirstChild("Label")
			if lbl then
				lbl.TextColor3 = self.Theme.SidebarText
			end
		end

		self.ActiveTab = tab
		if tab then

			tab.Container.Position = UDim2.fromOffset(6, offsetY)
			tab.Container.Visible = true
			self:_transition(tab.Container, 0.22, { Position = UDim2.fromOffset(6, 6) })

			self:_positionActiveBar(tab, hadPrevTab)


			tab.TabButton.BackgroundTransparency = 0
			tab.TabButton.BackgroundColor3 = self.Theme.TabActive
			if tab._glow then
				tab._glow.BackgroundTransparency = 0.85
			end
			local lbl = tab.TabButton:FindFirstChild("Label")
			if lbl then
				lbl.TextColor3 = self.Theme.SidebarTextActive
			end
		end
	end

	function Menu:ShowDropdownPopup(atPos, atSize, opts, selectedIdx, onClick, isMulti, dd)
		if self._destroyed or not self.Gui or not self.Frame then
			return false, "destroyed"
		end
		if type(opts) ~= "table" then
			return false, "expected options table"
		end
		self:HideDropdownPopup()
		self._popupFocusReturn = self:_beginTransientFocus(dd and dd.SelectBtn)
		self._popupGen = (self._popupGen or 0) + 1

		local uis = game:GetService("UserInputService")
		local theme = self.Theme
		local frameAbs = self.Frame.AbsolutePosition
		local frameSiz = self.Frame.AbsoluteSize
		atPos = typeof(atPos) == "Vector2" and atPos or frameAbs
		atSize = typeof(atSize) == "Vector2" and atSize or Vector2.new(0, 0)
		local py = 0
		isMulti = isMulti or false
		dd = dd or self._activeDropdown



		local viewport = self:_viewportSize()
		local textService = game:GetService("TextService")
		local longestOptionWidth = 0
		for _, option in ipairs(opts) do
			local measured = textService:GetTextSize(tostring(option), theme.FontSize, theme.Font, Vector2.new(1000, 100)).X
			longestOptionWidth = math.max(longestOptionWidth, measured)
		end
		local PANEL_CHROME = 36
		local MIN_W = 140
		local PREF_W = math.ceil(math.max(MIN_W, longestOptionWidth + PANEL_CHROME))
		local COMFORT_W = math.min(140, PREF_W)
		local USABLE_W = 80
		local rightEdge = frameAbs.X + frameSiz.X
		local rightRoom = viewport.X - rightEdge - 4
		local leftRoom = frameAbs.X - 4
		local w, px
		local placement
		if not self._compact and rightRoom >= COMFORT_W then

			w = math.min(PREF_W, rightRoom - 6)
			px = frameSiz.X + 6
			placement = "ExteriorRight"
		elseif not self._compact and leftRoom >= COMFORT_W then

			w = math.min(PREF_W, leftRoom - 6)
			px = -(w + 6)
			placement = "ExteriorLeft"
		else

			placement = "InteriorRight"
			local interiorPadding = 8
			w = math.min(PREF_W, math.max(USABLE_W, frameSiz.X - interiorPadding * 2))
			px = frameSiz.X - interiorPadding - w
		end


		local OPT_H = math.max(32, self.TouchTargetSize)
		local triggerTop = atPos.Y - frameAbs.Y
		local desiredH = math.max(44, (#opts * OPT_H) + math.max(0, #opts - 1) * 2 + 12)
		local clampedH = math.min(desiredH, frameSiz.Y)
		if placement == "InteriorRight" then
			local topInset = self.Topbar.AbsoluteSize.Y + 8
			local bottomInset = 8
			clampedH = math.min(clampedH, math.max(44, frameSiz.Y - topInset - bottomInset))
			local belowY = triggerTop + atSize.Y + 4
			local aboveY = triggerTop - clampedH - 4
			if belowY + clampedH <= frameSiz.Y - bottomInset then
				py = belowY
			elseif aboveY >= topInset then
				py = aboveY
			else
				py = topInset
			end
		else
			py = math.clamp(triggerTop, 0, math.max(0, frameSiz.Y - clampedH))
		end
		local popupParent = self.Frame
		local targetPx = px
		local startPx = placement == "ExteriorLeft" and (px - 14) or (px + 14)


		if placement == "InteriorRight" then
			self._popupCloser = U.Create("ImageButton", {
				Name = "DropdownCloser",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Modal = true,
				ZIndex = 9999,
				Parent = self.Frame,
			})
			self._popupCloser.Activated:Connect(function()
				self:HideDropdownPopup()
			end)
		end
		local popup = U.Create("Frame", {
			Name = "DropdownPopup",
			Size = UDim2.fromOffset(w, clampedH),
			Position = UDim2.fromOffset(startPx, py),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = theme.Background,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 10000,
			Parent = popupParent,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = popup })

		local content = U.Create("Frame", {
			Name = "Content",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10001,
			Parent = popup,
		})

		local firstOptionButton
		if #opts > 0 then

			local optionList = U.Create("ScrollingFrame", {
				Name = "OptionList",
				Size = UDim2.new(1, -16, 1, -8),
				Position = UDim2.fromOffset(8, 6),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = theme.ScrollBar,
				CanvasSize = UDim2.fromOffset(0, (#opts * OPT_H) + math.max(0, #opts - 1) * 2),
				ZIndex = 10001,
				Parent = content,
			})
			local optionLayout = U.Create("UIListLayout", {
				Padding = UDim.new(0, 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = optionList,
			})


			for i, opt in ipairs(opts) do
				local sel = false
				if isMulti then
					sel = dd and dd._selected[opt] or false
				else
					sel = dd and tostring(opt) == tostring(dd.Value) or false
				end
				local btn = U.Create("TextButton", {
					Name = "Option",
					Size = UDim2.new(1, -6, 0, OPT_H),
					Text = "",
					BackgroundColor3 = theme.ElementHover,
					BackgroundTransparency = sel and 0.25 or 1,
					AutoButtonColor = false,
					ZIndex = 10001,
					Parent = optionList,
				})
				self:_makeSelectable(btn)
				if not firstOptionButton then
					firstOptionButton = btn
				end
				U.Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = btn })
				local accentLine = U.Create("Frame", {
					Name = "ActiveLine",
					Size = sel and UDim2.fromOffset(3, 18) or UDim2.fromOffset(3, 0),
					Position = UDim2.new(0, 5, 0.5, sel and -9 or 0),
					BackgroundColor3 = theme.Accent,
					BackgroundTransparency = sel and 0 or 1,
					BorderSizePixel = 0,
					ZIndex = 10002,
					Parent = btn,
				})
				U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accentLine })
				local textOffset = 16
				U.Create("TextLabel", {
					Name = "Label",
					Size = UDim2.new(1, -(textOffset + 4), 1, 0),
					Position = UDim2.fromOffset(textOffset, 0),
					BackgroundTransparency = 1,
					Text = tostring(opt),
					Font = theme.Font,
					TextSize = theme.FontSize,
					TextColor3 = theme.SidebarTextActive,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 10002,
					Parent = btn,
				})
				btn.Activated:Connect(function()
					if isMulti then
						if dd then
							dd:SetValue(opt)
							local isSel = dd._selected[opt]
							game:GetService("TweenService"):Create(
								btn,
								TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
								{ BackgroundTransparency = isSel and 0.25 or 1 }
							):Play()
							game:GetService("TweenService"):Create(
								accentLine,
								TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
								{
									Size = isSel and UDim2.fromOffset(3, 18) or UDim2.fromOffset(3, 0),
									Position = UDim2.new(0, 5, 0.5, isSel and -9 or 0),
									BackgroundTransparency = isSel and 0 or 1,
								}
							):Play()
						end
					else
						game:GetService("TweenService"):Create(
							btn,
							TweenInfo.new(0.12),
							{ BackgroundTransparency = 0.2 }
						):Play()
						game:GetService("TweenService"):Create(
							accentLine,
							TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
							{
								Size = UDim2.fromOffset(3, 18),
								Position = UDim2.new(0, 5, 0.5, -9),
								BackgroundTransparency = 0,
							}
						):Play()
						task.delay(0.1, function()
							onClick(i, opt)
						end)
					end
				end)
				btn.MouseEnter:Connect(function()
					game:GetService("TweenService"):Create(btn, TweenInfo.new(0.1), {
						BackgroundTransparency = 0.55,
					}):Play()
				end)
				btn.MouseLeave:Connect(function()
					local curSel = isMulti and (dd and dd._selected[opt])
						or (not isMulti and dd and tostring(opt) == tostring(dd.Value))
					if curSel then
						btn.BackgroundColor3 = theme.ElementHover
						btn.BackgroundTransparency = 0.25
					else
						btn.BackgroundColor3 = theme.ElementHover
						btn.BackgroundTransparency = 1
					end
				end)
			end
		else

			U.Create("TextLabel", {
				Name = "EmptyState",
				Size = UDim2.new(1, -12, 1, 0),
				Position = UDim2.fromOffset(6, 0),
				Text = "No options",
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = theme.TextMuted,
				TextTransparency = 0.4,
				BackgroundTransparency = 1,
				ZIndex = 10001,
				Parent = content,
			})
		end

		self._activePopupFrame = popup
		self._activePopupModal = false
		self._activePopupPlacement = placement
		self._activePopupBounds = {
			X = px,
			Y = py,
			Width = w,
			Height = clampedH,
			Placement = placement,
		}
		self:_transition(
			popup,
			0.2,
			{ Position = UDim2.fromOffset(targetPx, py) },
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.Out
		)
		if self._popupFocusReturn and firstOptionButton then
			game:GetService("GuiService").SelectedObject = firstOptionButton
		end


		local closeGen = self._popupGen
		self._popupUISCon = uis.InputBegan:Connect(function(input, gpe)
			if gpe then
				return
			end
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				task.wait()
				if closeGen ~= self._popupGen then
					return
				end
				local activePopup = self._activePopupFrame
				if not activePopup then
					return
				end
				local point, popupPos, popupSize = input.Position, activePopup.AbsolutePosition, activePopup.AbsoluteSize
				local insidePopup = point.X >= popupPos.X
					and point.X <= popupPos.X + popupSize.X
					and point.Y >= popupPos.Y
					and point.Y <= popupPos.Y + popupSize.Y
				if not insidePopup then
					self:HideDropdownPopup()
				end
			end
		end)
		return true
	end

	function Menu:HideDropdownPopup()
		if self._popupUISCon then
			self._popupUISCon:Disconnect()
			self._popupUISCon = nil
		end
		if self._activePopupFrame then
			local popup = self._activePopupFrame
			local placement = self._activePopupPlacement
			local bounds = self._activePopupBounds
			self._activePopupFrame = nil
			self._activePopupPlacement = nil
			self._activePopupBounds = nil
			local closeX = bounds and bounds.X or popup.Position.X.Offset
			if placement == "ExteriorLeft" then
				closeX = closeX - 14
			else
				closeX = closeX + 14
			end
			local closeY = bounds and bounds.Y or popup.Position.Y.Offset
			local closeProps = { Position = UDim2.fromOffset(closeX, closeY) }
			self:_transition(popup, 0.14, closeProps, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
				pcall(function()
					popup:Destroy()
				end)
			end)
		end
		if self._activePopupOverlay then
			self._activePopupOverlay:Destroy()
			self._activePopupOverlay = nil
		end
		if self._popupCloser then
			self._popupCloser:Destroy()
			self._popupCloser = nil
		end
		self._activePopupModal = nil
		self._activePopupPlacement = nil
		self._activePopupBounds = nil
		local focusReturn = self._popupFocusReturn
		self._popupFocusReturn = nil
		self:_restoreTransientFocus(focusReturn)
		if self._activeDropdown then
			self._activeDropdown.Open = false
			if self._activeDropdown._arrow then
				game:GetService("TweenService"):Create(
					self._activeDropdown._arrow,
					TweenInfo.new(0.16),
					{ Rotation = 0 }
				):Play()
			end
			if self._activeDropdown._selectStroke then
				self._activeDropdown._selectStroke.Color = self._activeDropdown.Theme.ElementBorder
				self._activeDropdown._selectStroke.Transparency = 0.15
			end
			self._activeDropdown = nil
		end
	end

	function Menu:Tab(options)
		if self._destroyed then
			return nil, "destroyed"
		end
		options = options or {}
		return Tab.new(self, options)
	end
	function Menu:_createOverview()
		if not self.StatsConfig.Enabled or self._overviewTab then
			return self._overviewTab
		end
		local theme = self.Theme
		local cfg = self.StatsConfig
		local support = self.SupportConfig
		local tab = Tab.new(self, { Text = cfg.TabName, Icon = cfg.TabIcon, Tooltip = "Account and session overview" })
		self._overviewTab = tab
		tab._isOverview = true
		local root = tab.Container
		local overviewConns = {}
		root.Name = "OverviewContent"
		root.ScrollBarThickness = 0
		root.ScrollingEnabled = false
		root.CanvasSize = UDim2.fromOffset(0, 0)
		root.Active = true
		local overviewHovered = false
		local function releaseOverviewInput()
			overviewHovered = false
			self:_releaseInput("OverviewWheel")
			self:_releaseInput("OverviewTouch")
		end
		table.insert(
			overviewConns,
			root.MouseEnter:Connect(function()
				if self.ActiveTab == tab and self.Visible and not self.Minimized then
					overviewHovered = true
					self:_captureInput("OverviewWheel", { Enum.UserInputType.MouseWheel })
					self:_captureInput("OverviewTouch", { Enum.UserInputType.Touch })
				end
			end)
		)
		table.insert(
			overviewConns,
			root.MouseLeave:Connect(function()
				if overviewHovered then
					releaseOverviewInput()
				end
			end)
		)
		for _, child in ipairs(root:GetChildren()) do
			if child:IsA("UIListLayout") or child:IsA("UIPadding") then
				child:Destroy()
			end
		end

		local themed = {}
		local textStyles = {}
		local icons = {}
		local profileEnabled = cfg.ShowProfile
		local infoEnabled = cfg.ShowGame or cfg.ShowServer
		local supportEnabled = cfg.ShowSupport and (support.Discord or support.Callback)
		local contentTop = 40
		local contentBottom = 276
		local sectionGap = 8
		local profileHeight = profileEnabled and 88 or 0
		local infoHeight = infoEnabled and 76 or 0
		local supportHeight = supportEnabled and 56 or 0
		local totalHeight = profileHeight
			+ infoHeight
			+ supportHeight
			+ (profileEnabled and infoEnabled and sectionGap or 0)
			+ (infoEnabled and supportEnabled and sectionGap or 0)
			+ (profileEnabled and not infoEnabled and supportEnabled and sectionGap or 0)
		local sectionY = contentTop + math.max(0, math.floor((contentBottom - contentTop - totalHeight) / 2))
		local function card(name, position, size, radius)
			local frame = U.Create("Frame", {
				Name = name,
				Position = position,
				Size = size,
				BackgroundColor3 = theme.Element,
				BorderSizePixel = 0,
				Parent = root,
			})
			U.Create("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = frame })
			local stroke = U.Create("UIStroke", {
				Color = theme.ElementBorder,
				Transparency = 0.6,
				Thickness = 1,
				Parent = frame,
			})
			table.insert(themed, { kind = "card", frame = frame, stroke = stroke })
			return frame
		end
		local function label(parent, text, position, size, font, textSize, color, colorRole, fontRole)
			local value = U.Create("TextLabel", {
				Position = position,
				Size = size,
				BackgroundTransparency = 1,
				Text = text,
				Font = font,
				TextSize = textSize,
				TextColor3 = color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = parent,
			})
			table.insert(textStyles, {
				label = value,
				colorRole = colorRole,
				fontRole = fontRole,
			})
			return value
		end

		label(
			root,
			string.upper(cfg.TabName),
			UDim2.fromOffset(2, 0),
			UDim2.new(1, -4, 0, 20),
			theme.FontBold,
			16,
			theme.TextPrimary,
			"TextPrimary",
			"FontBold"
		)
		label(
			root,
			"Your account and current session",
			UDim2.fromOffset(2, 19),
			UDim2.new(1, -4, 0, 16),
			theme.Font,
			13,
			theme.TextMuted,
			"TextMuted",
			"Font"
		)

		local players = game:GetService("Players")
		local player = players.LocalPlayer
		if cfg.ShowProfile then
			local profile = card("Profile", UDim2.new(0, 0, 0, sectionY), UDim2.new(1, 0, 0, profileHeight), 10)
			local accent = U.Create("Frame", {
				Name = "Accent",
				Position = UDim2.fromOffset(0, 12),
				Size = UDim2.fromOffset(3, 64),
				BackgroundColor3 = theme.Accent,
				BorderSizePixel = 0,
				Parent = profile,
			})
			table.insert(themed, { kind = "accent", frame = accent })
			local avatar = U.Create("ImageLabel", {
				Name = "Avatar",
				Position = UDim2.fromOffset(12, 12),
				Size = UDim2.fromOffset(64, 64),
				BackgroundColor3 = theme.ElementHover,
				BorderSizePixel = 0,
				Parent = profile,
			})
			U.Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = avatar })
			local avatarStroke =
				U.Create("UIStroke", { Color = theme.Accent, Transparency = 0.65, Thickness = 1, Parent = avatar })
			table.insert(themed, { kind = "avatar", frame = avatar, stroke = avatarStroke })
			local displayName = player and player.DisplayName or "Player"
			local userName = player and ("@" .. player.Name) or "@unknown"
			local accountInfo = player and (("%d days | ID %d"):format(player.AccountAge, player.UserId))
				or "Account unavailable"
			label(
				profile,
				displayName,
				UDim2.fromOffset(88, 13),
				UDim2.new(1, -174, 0, 20),
				theme.FontBold,
				16,
				theme.TextPrimary,
				"TextPrimary",
				"FontBold"
			)
			label(
				profile,
				userName,
				UDim2.fromOffset(88, 34),
				UDim2.new(1, -102, 0, 18),
				theme.Font,
				14,
				theme.TextSecondary,
				"TextSecondary",
				"Font"
			)
			label(
				profile,
				accountInfo,
				UDim2.fromOffset(88, 55),
				UDim2.new(1, -102, 0, 16),
				theme.Font,
				13,
				theme.TextMuted,
				"TextMuted",
				"Font"
			)
			label(
				profile,
				"Ready",
				UDim2.new(1, -80, 0, 14),
				UDim2.fromOffset(68, 18),
				theme.FontBold,
				13,
				Color3.fromRGB(70, 220, 120),
				"Status",
				"FontBold"
			).TextXAlignment =
				Enum.TextXAlignment.Right
			if player then
				task.spawn(function()
					local ok, image = pcall(
						players.GetUserThumbnailAsync,
						players,
						player.UserId,
						Enum.ThumbnailType.HeadShot,
						Enum.ThumbnailSize.Size150x150
					)
					if ok and avatar and avatar.Parent then
						avatar.Image = image
					end
				end)
			end
		end

		if profileEnabled then
			sectionY += profileHeight + ((infoEnabled or supportEnabled) and sectionGap or 0)
		end
		local showGame, showServer = cfg.ShowGame, cfg.ShowServer
		local rowY = sectionY
		local rowGap = 8
		local function infoCard(name, xScale, xOffset, widthScale, widthOffset, iconName)
			local info = card(name, UDim2.new(xScale, xOffset, 0, rowY), UDim2.new(widthScale, widthOffset, 0, 76), 8)
			local icon = renderIcon(info, iconName, {
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(1, -26, 0, 10),
				ImageColor3 = theme.TextMuted,
			})
			if icon then
				table.insert(icons, { icon = icon, role = "TextMuted" })
			end
			return info
		end
		local gameCard = showGame
			and infoCard("Game", 0, 0, showServer and 0.5 or 1, showServer and -(rowGap / 2) or 0, "gamepad-2")
		local serverCard = showServer
			and infoCard(
				"Server",
				showGame and 0.5 or 0,
				showGame and (rowGap / 2) or 0,
				showGame and 0.5 or 1,
				showGame and -(rowGap / 2) or 0,
				"server"
			)
		if gameCard then
			label(
				gameCard,
				"GAME",
				UDim2.fromOffset(12, 8),
				UDim2.new(1, -44, 0, 16),
				theme.FontBold,
				12,
				theme.TextMuted,
				"TextMuted",
				"FontBold"
			)
			local gameName = label(
				gameCard,
				"Current Experience",
				UDim2.fromOffset(12, 29),
				UDim2.new(1, -24, 0, 19),
				theme.FontBold,
				15,
				theme.TextPrimary,
				"TextPrimary",
				"FontBold"
			)
			label(
				gameCard,
				"Place " .. tostring(game.PlaceId),
				UDim2.fromOffset(12, 51),
				UDim2.new(1, -24, 0, 15),
				theme.Font,
				12,
				theme.TextMuted,
				"TextMuted",
				"Font"
			)
			task.spawn(function()
				local marketplace = game:GetService("MarketplaceService")
				local fetched, details = pcall(marketplace.GetProductInfo, marketplace, game.PlaceId)
				if fetched and details and gameName and gameName.Parent then
					gameName.Text = details.Name or gameName.Text
				end
			end)
		end
		if serverCard then
			label(
				serverCard,
				"SERVER",
				UDim2.fromOffset(12, 8),
				UDim2.new(1, -44, 0, 16),
				theme.FontBold,
				12,
				theme.TextMuted,
				"TextMuted",
				"FontBold"
			)
			local playerCount = label(
				serverCard,
				"",
				UDim2.fromOffset(12, 29),
				UDim2.new(1, -24, 0, 19),
				theme.FontBold,
				15,
				theme.TextPrimary,
				"TextPrimary",
				"FontBold"
			)
			local function updatePlayers()
				if playerCount and playerCount.Parent then
					playerCount.Text = ("%d / %d Players"):format(#players:GetPlayers(), players.MaxPlayers)
				end
			end
			updatePlayers()
			label(
				serverCard,
				"Connected",
				UDim2.fromOffset(12, 51),
				UDim2.new(1, -24, 0, 15),
				theme.Font,
				12,
				Color3.fromRGB(70, 220, 120),
				"Status",
				"Font"
			)
			table.insert(overviewConns, players.PlayerAdded:Connect(updatePlayers))
			table.insert(self._overviewConns, overviewConns[#overviewConns])
			table.insert(
				overviewConns,
				players.PlayerRemoving:Connect(function()
					task.defer(updatePlayers)
				end)
			)
			table.insert(self._overviewConns, overviewConns[#overviewConns])
		end

		if infoEnabled then
			sectionY += infoHeight + (supportEnabled and sectionGap or 0)
		end
		if supportEnabled then
			local supportCard = card("Support", UDim2.new(0, 0, 0, sectionY), UDim2.new(1, 0, 0, supportHeight), 8)
			label(
				supportCard,
				support.Title or "Need Support?",
				UDim2.fromOffset(12, 8),
				UDim2.new(1, -158, 0, 19),
				theme.FontBold,
				15,
				theme.TextPrimary,
				"TextPrimary",
				"FontBold"
			)
			label(
				supportCard,
				support.Description or "Get help or join the community",
				UDim2.fromOffset(12, 29),
				UDim2.new(1, -158, 0, 16),
				theme.Font,
				12,
				theme.TextMuted,
				"TextMuted",
				"Font"
			)
			local button = U.Create("ImageButton", {
				Name = "SupportButton",
				Position = UDim2.new(1, -138, 0.5, -14),
				Size = UDim2.fromOffset(126, 28),
				BackgroundColor3 = theme.ElementHover,
				AutoButtonColor = false,
				Parent = supportCard,
			})
			self:_makeSelectable(button)
			U.Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = button })
			local buttonStroke =
				U.Create("UIStroke", { Color = theme.Accent, Transparency = 0.5, Thickness = 1, Parent = button })
			local supportIcon = renderIcon(
				button,
				support.ButtonIcon or "message-circle",
				{ Size = UDim2.fromOffset(15, 15), Position = UDim2.fromOffset(9, 7), ImageColor3 = theme.TextPrimary }
			)
			if supportIcon then
				table.insert(icons, { icon = supportIcon, role = "TextPrimary" })
			end
			local supportLabel = label(
				button,
				support.ButtonText or "Join Discord",
				UDim2.fromOffset(30, 0),
				UDim2.new(1, -36, 1, 0),
				theme.FontBold,
				13,
				theme.TextPrimary,
				"TextPrimary",
				"FontBold"
			)
			supportLabel.TextXAlignment = Enum.TextXAlignment.Center
			table.insert(themed, { kind = "button", frame = button, stroke = buttonStroke })
			button.Activated:Connect(function()
				local url = support.Discord
				if type(support.Callback) == "function" then
					task.spawn(support.Callback, url)
					return
				end
				local env = type(getgenv) == "function" and getgenv() or _G
				local clipboard = type(env) == "table" and rawget(env, "setclipboard") or nil
				if type(clipboard) == "function" and url then
					local copied = pcall(clipboard, url)
					if copied then
						self:Notify({
							Title = "Discord Copied",
							Content = "Invite link copied to clipboard.",
							Type = "Success",
						})
					else
						self:Notify({ Title = "Discord", Content = url, Type = "Info" })
					end
				elseif url then
					self:Notify({ Title = "Discord", Content = url, Type = "Info" })
				end
			end)
		end
		local baseDestroy = tab.Destroy
		tab.Destroy = function(overview)
			if overview._destroyed then
				return
			end
			for _, connection in ipairs(overviewConns) do
				connection:Disconnect()
				for i = #self._overviewConns, 1, -1 do
					if self._overviewConns[i] == connection then
						table.remove(self._overviewConns, i)
					end
				end
			end
			releaseOverviewInput()
			table.clear(overviewConns)
			if self._overviewTab == overview then
				self._overviewTab = nil
			end
			baseDestroy(overview)
		end
		tab.ApplyTheme = function(overview, newTheme)
			overview.Theme = newTheme
			for _, entry in ipairs(themed) do
				if entry.frame and entry.frame.Parent then
					if entry.kind == "accent" then
						entry.frame.BackgroundColor3 = newTheme.Accent
					elseif entry.kind == "button" or entry.kind == "avatar" then
						entry.frame.BackgroundColor3 = newTheme.ElementHover
					else
						entry.frame.BackgroundColor3 = newTheme.Element
					end
				end
				if entry.stroke and entry.stroke.Parent then
					entry.stroke.Color = (entry.kind == "button" or entry.kind == "avatar") and newTheme.Accent
						or newTheme.ElementBorder
				end
			end
			for _, entry in ipairs(textStyles) do
				if entry.label and entry.label.Parent then
					entry.label.Font = newTheme[entry.fontRole]
					entry.label.TextColor3 = entry.colorRole == "Status" and Color3.fromRGB(70, 220, 120)
						or newTheme[entry.colorRole]
				end
			end
			for _, entry in ipairs(icons) do
				if entry.icon and entry.icon.Parent then
					if entry.icon:IsA("ImageLabel") then
						entry.icon.ImageColor3 = newTheme[entry.role]
					elseif entry.icon:IsA("TextLabel") then
						entry.icon.TextColor3 = newTheme[entry.role]
					end
				end
			end
			theme = newTheme
			Tab.ApplyTheme(overview, newTheme)
		end

		tab._overviewThemed = themed
		return tab
	end
	function Menu:_trackFlagged(ctrl)
		if ctrl.Flag then
			ctrl._menu = self
			if self._flagRegistry[ctrl.Flag] ~= nil then
				warn(("[FyyUI] Duplicate Flag '%s' Ă˘âŹâ overwriting previous controller"):format(ctrl.Flag))
			end
			self._flagRegistry[ctrl.Flag] = ctrl
			local pending = self._pendingConfigValues and self._pendingConfigValues[ctrl.Flag]
			if pending then
				local setter = ctrl.SetValue or ctrl.SetKey
				if setter then
					local ok = pcall(setter, ctrl, pending.Value, pending.NoCallbacks)
					if ok then
						self._pendingConfigValues[ctrl.Flag] = nil
					end
				end
			end
		end
	end

	function Menu:_untrackFlagged(ctrl)
		if ctrl and ctrl.Flag and self._flagRegistry[ctrl.Flag] == ctrl then
			self._flagRegistry[ctrl.Flag] = nil
		end
	end

	function Menu:_registerKeybind(kb)
		table.insert(self._keybindList, kb)
	end

	function Menu:_unregisterKeybind(kb)
		for i, v in ipairs(self._keybindList) do
			if v == kb then
				table.remove(self._keybindList, i)
				break
			end
		end
	end

	function Menu:ExportConfig(options)
		if self._destroyed then
			return nil, "destroyed"
		end
		if options ~= nil and type(options) ~= "table" then
			return nil, "Invalid config export options"
		end
		local schemaVersion = options and options.SchemaVersion
		if schemaVersion ~= nil and schemaVersion ~= 2 then
			return nil, "Unsupported config schema version"
		end
		local isV2 = schemaVersion == 2
		local snapshot = isV2
				and {
					Schema = CONFIG_V2_SCHEMA,
					SchemaVersion = 2,
					Version = LIBRARY_VERSION,
					Values = {},
				}
			or {
				Schema = "FyyUI.Config.v1",
				Version = LIBRARY_VERSION,
				Values = {},
			}
		local estimatedBytes = 64
		for flag, ctrl in pairs(self._flagRegistry) do
			local value
			if ctrl.Numeric and ctrl.IsEmpty and ctrl:IsEmpty() then
				value = ""
			else
				value = ctrl:GetValue()
			end
			if ctrl._isColorPicker and typeof(value) == "Color3" then
				value = { value.R, value.G, value.B }
			end
			if isV2 then
				if type(flag) ~= "string" or flag == "" or #flag > 128 then
					return nil, "Invalid config v2: invalid flag"
				end
				if value == nil then

				elseif ctrl._capturing ~= nil and typeof(value) == "EnumItem" then
					value = value.Name
				end
				if value ~= nil then
					local copied, err = copyJSONSafeValue(value, { Nodes = 0, Bytes = 0 }, {}, 0)
					if err then
						return nil, "Invalid config v2 for " .. flag .. ": " .. err
					end
					estimatedBytes = estimatedBytes + (#flag * 6) + estimateJSONSafeValueBytes(copied) + 4
					if estimatedBytes > MAX_CONFIG_JSON_BYTES then
						return nil, "Config JSON is too large"
					end
					snapshot.Values[flag] = copied
				end
			else
				snapshot.Values[flag] = value
			end
		end
		return snapshot
	end

	function Menu:ImportConfig(snapshot, options)
		if self._destroyed then
			return false, "destroyed"
		end
		if type(snapshot) ~= "table" then
			return false, "Invalid config: expected a table"
		end
		if snapshot.SchemaVersion ~= nil or snapshot.Schema == CONFIG_V2_SCHEMA then
			local validEnvelope, normalizedOrError = validateConfigV2Envelope(snapshot)
			if not validEnvelope then
				return false, normalizedOrError
			end
			snapshot = normalizedOrError
		end
		if type(snapshot.Values) ~= "table" then
			return false, "Invalid config: missing Values table"
		end
		local noCallbacks = options and options.NoCallbacks == true
		local details = { Applied = {}, Failed = {}, Unknown = {}, Pending = {} }
		local function validateValue(ctrl, value)
			if ctrl._destroyed then
				return false, "destroyed"
			end
			if ctrl._isColorPicker then
				if type(value) ~= "table" or #value ~= 3 then
					return false, "expected RGB array"
				end
				for index = 1, 3 do
					if not isFiniteNumber(value[index]) or value[index] < 0 or value[index] > 1 then
						return false, "expected RGB values between 0 and 1"
					end
				end
				return true
			end
			if ctrl.Multi then
				if type(value) ~= "table" then
					return false, "expected options table"
				end
				local count, maxIndex = 0, 0
				for index, option in pairs(value) do
					if type(index) ~= "number" or index < 1 or index % 1 ~= 0 then
						return false, "expected dense options array"
					end
					count = count + 1
					maxIndex = math.max(maxIndex, index)
					if not ctrl:_optIndex(ctrl.Options, option) then
						return false, "unknown option"
					end
				end
				if count ~= maxIndex then
					return false, "expected dense options array"
				end
				return true
			end
			if ctrl.Numeric then
				if value == "" then
					return true
				end
				local number = tonumber(value)
				if not isFiniteNumber(number) then
					return false, "expected finite number"
				end
				return true
			end
			if ctrl.Options then
				if value == "" then
					if ctrl.AllowNone or #ctrl.Options == 0 then
						return true
					end
					return false, "selection required"
				end
				if not ctrl:_optIndex(ctrl.Options, value) then
					return false, "unknown option"
				end
				return true
			end
			if ctrl._capturing ~= nil then
				if value == nil then
					return true
				end
				if typeof(value) == "EnumItem" then
					if value.EnumType == Enum.KeyCode then
						return true
					end
					return value == Enum.UserInputType.MouseButton1
						or value == Enum.UserInputType.MouseButton2
						or value == Enum.UserInputType.MouseButton3
				end
				if type(value) == "string" then
					for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do
						if item.Name == value then
							return true
						end
					end
					for _, item in ipairs(Enum.UserInputType:GetEnumItems()) do
						if
							item.Name == value
							and (
								item == Enum.UserInputType.MouseButton1
								or item == Enum.UserInputType.MouseButton2
								or item == Enum.UserInputType.MouseButton3
							)
						then
							return true
						end
					end
				end
				return false, "expected a KeyCode, MouseButton input, key name, or nil"
			end
			if type(ctrl.Value) == "boolean" and type(value) ~= "boolean" then
				return false, "expected boolean"
			end
			if ctrl.Min ~= nil and ctrl.Max ~= nil and not isFiniteNumber(value) then
				return false, "expected finite number"
			end
			return true
		end


		for flag, value in pairs(snapshot.Values) do
			local ctrl = self._flagRegistry[flag]
			if ctrl then
				local valid, validationError = validateValue(ctrl, value)
				if not valid then
					table.insert(details.Failed, { Flag = flag, Error = validationError })
				end
			end
		end
		if #details.Failed > 0 then
			return false, details
		end

		for flag, value in pairs(snapshot.Values) do
			local ctrl = self._flagRegistry[flag]
			if ctrl then
				local ok, applied, err = pcall(function()
					if ctrl.Multi then

						local targetSet = {}
						if type(value) == "table" then
							for _, opt in ipairs(value) do
								targetSet[opt] = true
							end
						end
						for _, opt in ipairs(ctrl.Options) do
							local isSelected = ctrl._selected[opt] == true
							local shouldSelect = targetSet[opt] == true
							if isSelected ~= shouldSelect then
								local changed, changeErr = ctrl:SetValue(opt, noCallbacks)
								if changed == false then
									return false, changeErr
								end
							end
						end
						return true
					else
						if ctrl._setValueNoCallbackPosition == 3 then
							return ctrl:SetValue(value, false, noCallbacks)
						else
							return ctrl:SetValue(value, noCallbacks)
						end
					end
				end)
				if ok and applied ~= false then
					table.insert(details.Applied, flag)
				elseif ok then
					table.insert(details.Failed, { Flag = flag, Error = tostring(err or "setter rejected value") })
				else
					table.insert(details.Failed, { Flag = flag, Error = tostring(applied) })
				end
			else
				table.insert(details.Unknown, flag)
				if options and options.DeferUnknown == true then
					self._pendingConfigValues[flag] = { Value = value, NoCallbacks = noCallbacks }
					table.insert(details.Pending, flag)
				end
			end
		end
		if #details.Failed > 0 then
			return false, details
		end
		return true, details
	end

	function Menu:ExportConfigJSON()
		if self._destroyed then
			return nil, "destroyed"
		end
		local snapshot, exportError = self:ExportConfig({ SchemaVersion = 2 })
		if not snapshot then
			return nil, exportError
		end
		local serviceOk, httpService = pcall(function()
			return game:GetService("HttpService")
		end)
		if not serviceOk or not httpService then
			return nil, "JSON support is unavailable"
		end
		local encodedOk, encodedOrError = pcall(function()
			return httpService:JSONEncode(snapshot)
		end)
		if not encodedOk or type(encodedOrError) ~= "string" then
			return nil, "Failed to encode config JSON"
		end
		if #encodedOrError > MAX_CONFIG_JSON_BYTES then
			return nil, "Config JSON is too large"
		end
		return encodedOrError
	end

	function Menu:ImportConfigJSON(json, options)
		if self._destroyed then
			return false, "destroyed"
		end
		if type(json) ~= "string" then
			return false, "Invalid config JSON: expected a string"
		end
		if #json > MAX_CONFIG_JSON_BYTES then
			return false, "Invalid config JSON: input is too large"
		end
		local serviceOk, httpService = pcall(function()
			return game:GetService("HttpService")
		end)
		if not serviceOk or not httpService then
			return false, "JSON support is unavailable"
		end
		local decodedOk, snapshotOrError = pcall(function()
			return httpService:JSONDecode(json)
		end)
		if not decodedOk then
			return false, "Invalid config JSON"
		end
		return self:ImportConfig(snapshotOrError, options)
	end

	local ConfigTabController = {}
	ConfigTabController.__index = ConfigTabController

	local function configEnvironment()
		return type(getgenv) == "function" and getgenv() or _G
	end

	local function sanitizeProfileName(name)
		if type(name) ~= "string" then
			return nil, "expected profile name"
		end
		name = name:match("^%s*(.-)%s*$") or ""
		if name == "" or #name > 48 or name:find("[\\/%.:]") or not name:match("^[%w _%-]+$") then
			return nil, "profile names may contain letters, numbers, spaces, _ and -"
		end
		return name
	end

	local function defaultConfigStorage(folder)
		local env = configEnvironment()
		for _, key in ipairs({ "isfolder", "makefolder", "isfile", "readfile", "writefile", "listfiles", "delfile" }) do
			if type(env[key]) ~= "function" then
				return nil, "persistent storage is unavailable"
			end
		end
		local function ensureFolder()
			if not env.isfolder(folder) then
				env.makefolder(folder)
			end
		end
		return {
			List = function()
				ensureFolder()
				local profiles = {}
				for _, path in ipairs(env.listfiles(folder)) do
					local file = tostring(path):gsub("\\", "/"):match("([^/]+)%.json$")
					if file and file ~= ".autoload" then
						table.insert(profiles, file)
					end
				end
				table.sort(profiles)
				return profiles
			end,
			Read = function(name)
				ensureFolder()
				local path = folder .. "/" .. name .. ".json"
				if not env.isfile(path) then
					return nil, "profile not found"
				end
				return env.readfile(path)
			end,
			Write = function(name, json)
				ensureFolder()
				env.writefile(folder .. "/" .. name .. ".json", json)
				return true
			end,
			Delete = function(name)
				local path = folder .. "/" .. name .. ".json"
				if env.isfile(path) then
					env.delfile(path)
				end
				return true
			end,
		}
	end

	local function normalizeStorage(storage, folder)
		if storage == nil then
			return defaultConfigStorage(folder)
		end
		if type(storage) ~= "table" then
			return nil, "Storage must be a table"
		end
		for _, method in ipairs({ "List", "Read", "Write", "Delete" }) do
			if type(storage[method]) ~= "function" then
				return nil, "Storage must provide List, Read, Write and Delete"
			end
		end
		return storage
	end

	function ConfigTabController:_notify(title, content, kind)
		self.Menu:Notify({ Title = title, Content = content, Type = kind or "Info", Duration = 3 })
	end

	function ConfigTabController:_call(method, ...)
		if not self.Storage then
			return false, self.StorageError
		end
		local ok, result, extra = pcall(self.Storage[method], ...)
		if not ok then
			return false, tostring(result)
		end
		if result == nil or result == false then
			return false, extra or "storage operation failed"
		end
		return true, result
	end

	function ConfigTabController:GetProfiles()
		local ok, profiles = self:_call("List")
		return ok and profiles or nil, ok and nil or profiles
	end

	function ConfigTabController:Refresh(preferred)
		local profiles, err = self:GetProfiles()
		if not profiles then
			if self.Status then
				self.Status.TextLabel.Text = self.StorageError or err
			end
			return false, err
		end
		self.Profiles = profiles
		local selected = preferred or self.SelectedProfile or self.DefaultProfile
		local options = profiles
		if #options == 0 then
			options = { "No profiles" }
			selected = "No profiles"
		elseif not table.find(options, selected) then
			selected = options[1]
		end
		self.SelectedProfile = selected ~= "No profiles" and selected or nil
		self.ProfileDropdown:SetOptions(options, selected, true)
		if self.Status then
			self.Status.TextLabel.Text = self.SelectedProfile and ("Selected: " .. self.SelectedProfile)
				or "No saved profiles"
		end
		return true, self.Profiles
	end

	function ConfigTabController:Save(name)
		name = name or self.NameInput:GetValue()
		if name == "" then
			name = self.SelectedProfile or self.DefaultProfile
		end
		local safe, err = sanitizeProfileName(name)
		if not safe then
			return false, err
		end
		local json, exportError = self.Menu:ExportConfigJSON()
		if not json then
			return false, exportError
		end
		local ok, writeError = self:_call("Write", safe, json)
		if not ok then
			return false, writeError
		end
		self.SelectedProfile = safe
		self.NameInput:SetValue(safe, true)
		self:Refresh(safe)
		return true, safe
	end

	function ConfigTabController:Load(name)
		local safe, err = sanitizeProfileName(name or self.SelectedProfile)
		if not safe then
			return false, err
		end
		local ok, json = self:_call("Read", safe)
		if not ok then
			return false, json
		end
		local imported, details =
			self.Menu:ImportConfigJSON(json, { NoCallbacks = not self.LoadCallbacks, DeferUnknown = true })
		if not imported then
			return false, details
		end
		self.SelectedProfile = safe
		return true, details
	end

	function ConfigTabController:Delete(name)
		local safe, err = sanitizeProfileName(name or self.SelectedProfile)
		if not safe then
			return false, err
		end
		local ok, deleteError = self:_call("Delete", safe)
		if not ok then
			return false, deleteError
		end
		if self.AutoloadProfile == safe then
			self:ClearAutoload()
		end
		self.SelectedProfile = nil
		self:Refresh()
		return true
	end

	function ConfigTabController:_writeAutoload()
		local httpService = game:GetService("HttpService")
		local ok, metadata = pcall(httpService.JSONEncode, httpService, {
			Enabled = self.AutoloadEnabled,
			Profile = self.AutoloadProfile,
		})
		if not ok then
			return false, "failed to encode autoload metadata"
		end
		return self:_call("Write", ".autoload", metadata)
	end

	function ConfigTabController:SetAutoload(name)
		local safe, err = sanitizeProfileName(name or self.SelectedProfile)
		if not safe then
			return false, err
		end
		self.AutoloadEnabled, self.AutoloadProfile = true, safe
		self.AutoloadToggle:SetValue(true, true, true)
		local ok, writeError = self:_writeAutoload()
		if ok then
			self.AutoloadStatus.TextLabel.Text = "Autoload: " .. safe
		end
		return ok, writeError or safe
	end

	function ConfigTabController:ClearAutoload()
		self.AutoloadEnabled, self.AutoloadProfile = false, nil
		self.AutoloadToggle:SetValue(false, true, true)
		local ok, err = self:_writeAutoload()
		self.AutoloadStatus.TextLabel.Text = "Autoload is disabled"
		return ok, err
	end

	function ConfigTabController:_readAutoload()
		local ok, json = self:_call("Read", ".autoload")
		if not ok then
			return false, json
		end
		local httpService = game:GetService("HttpService")
		local decodedOk, decoded = pcall(httpService.JSONDecode, httpService, json)
		if not decodedOk or type(decoded) ~= "table" then
			return false, "invalid autoload metadata"
		end
		local safe = sanitizeProfileName(decoded.Profile)
		self.AutoloadEnabled = decoded.Enabled == true and safe ~= nil
		self.AutoloadProfile = safe
		self.AutoloadToggle:SetValue(self.AutoloadEnabled, true, true)
		self.AutoloadStatus.TextLabel.Text = self.AutoloadEnabled and ("Autoload: " .. safe) or "Autoload is disabled"
		return true
	end

	function ConfigTabController:Destroy()
		if self._destroyed then
			return
		end
		if self.Tab and not self.Tab._destroyed then
			self.Tab:Destroy()
		end
		self._destroyed = true
	end

	function Menu:ConfigTab(options)
		if self._destroyed then
			return nil, "destroyed"
		end
		options = options or {}
		assert(type(options) == "table", "FyyUI ConfigTab: options must be a table")
		local folder = options.Folder or "FyyUI/Configs"
		assert(type(folder) == "string" and folder ~= "" and not folder:find("%.%."), "FyyUI ConfigTab: invalid Folder")
		local storage, storageError = normalizeStorage(options.Storage, folder)
		local controller = setmetatable({
			Menu = self,
			Folder = folder,
			Storage = storage,
			StorageError = storageError,
			DefaultProfile = options.DefaultProfile or "Default",
			LoadCallbacks = options.LoadCallbacks == true,
			AllowDelete = options.AllowDelete ~= false,
			AllowImportExport = options.AllowImportExport ~= false,
			Profiles = {},
		}, ConfigTabController)
		local tab = self:Tab({ Text = options.Text or "Config", Icon = options.Icon or "settings-2" })
		controller.Tab = tab
		tab._configController = controller
		table.insert(self._configTabs, controller)
		local baseTabDestroy = tab.Destroy
		tab.Destroy = function(configTab)
			for i = #self._configTabs, 1, -1 do
				if self._configTabs[i] == controller then
					table.remove(self._configTabs, i)
				end
			end
			controller._destroyed = true
			baseTabDestroy(configTab)
		end

		local profiles = tab:Collapsible("Configurations", { DefaultOpen = true })
		controller.ProfileDropdown = profiles:Dropdown({
			Text = "Profile",
			Options = { "No profiles" },
			Default = "No profiles",
			Callback = function(value)
				if value ~= "No profiles" then
					controller.SelectedProfile = value
					if controller.NameInput then
						controller.NameInput:SetValue(value, true)
					end
				end
			end,
		})
		controller.NameInput =
			profiles:Input({ Text = "Profile Name", Placeholder = controller.DefaultProfile, ClearOnFocus = false })
		local profileActions = profiles:Columns({ Count = 2, Ratios = { 1, 1 }, Gap = 8 })
		profileActions:Column(1):Button({
			Text = "Save Config",
			Icon = "save",
			Callback = function()
				local ok, result = controller:Save()
				controller:_notify(ok and "Config Saved" or "Save Failed", tostring(result), ok and "Success" or "Error")
			end,
		})
		profileActions:Column(2):Button({
			Text = "Load Config",
			Icon = "folder-open",
			Callback = function()
				local ok, result = controller:Load()
				controller:_notify(
					ok and "Config Loaded" or "Load Failed",
					ok and tostring(controller.SelectedProfile) or tostring(result),
					ok and "Success" or "Error"
				)
			end,
		})
		local profileManage = profiles:Columns({ Count = 2, Ratios = { 1, 1 }, Gap = 8 })
		profileManage:Column(1):Button({
			Text = "Refresh",
			Icon = "refresh-cw",
			Callback = function()
				controller:Refresh()
			end,
		})
		if controller.AllowDelete then
			profileManage:Column(2):Button({
				Text = "Delete Config",
				Icon = "trash-2",
				Color = Color3.fromRGB(235, 95, 95),
				Callback = function()
					local ok, result = controller:Delete()
					controller:_notify(
						ok and "Config Deleted" or "Delete Failed",
						ok and "Selected profile deleted." or tostring(result),
						ok and "Success" or "Error"
					)
				end,
			})
		end
		controller.Status = profiles:Label({ Text = storage and "No saved profiles" or storageError })

		local autoload = tab:Collapsible("Autoload", { DefaultOpen = true })
		controller.AutoloadToggle = autoload:Toggle({
			Text = "Load on Execute",
			Default = false,
			Callback = function(enabled)
				controller.AutoloadEnabled = enabled
				controller:_writeAutoload()
			end,
		})
		controller.AutoloadStatus = autoload:Label({ Text = "Autoload is disabled" })
		local autoActions = autoload:Columns({ Count = 2, Ratios = { 1, 1 }, Gap = 8 })
		autoActions:Column(1):Button({
			Text = "Set Selected",
			Icon = "zap",
			Callback = function()
				local ok, result = controller:SetAutoload()
				controller:_notify(
					ok and "Autoload Set" or "Autoload Failed",
					tostring(result),
					ok and "Success" or "Error"
				)
			end,
		})
		autoActions:Column(2):Button({
			Text = "Clear Autoload",
			Icon = "x",
			Callback = function()
				local ok, result = controller:ClearAutoload()
				controller:_notify(
					ok and "Autoload Cleared" or "Autoload Failed",
					ok and "Autoload is disabled." or tostring(result),
					ok and "Success" or "Error"
				)
			end,
		})

		if controller.AllowImportExport then
			local transfer = tab:Collapsible("Import & Export", { DefaultOpen = true })
			controller.JsonInput =
				transfer:Input({ Text = "Config JSON", Placeholder = "Paste JSON", ClearOnFocus = false })
			local transferActions = transfer:Columns({ Count = 2, Ratios = { 1, 1 }, Gap = 8 })
			transferActions:Column(1):Button({
				Text = "Copy JSON",
				Icon = "copy",
				Callback = function()
					local json, err = self:ExportConfigJSON()
					if not json then
						controller:_notify("Export Failed", tostring(err), "Error")
						return
					end
					controller.JsonInput:SetValue(json, true)
					local env = configEnvironment()
					local copied = type(env.setclipboard) == "function" and pcall(env.setclipboard, json)
					controller:_notify(
						"Config Exported",
						copied and "JSON copied to clipboard." or "JSON placed in the input field.",
						"Success"
					)
				end,
			})
			transferActions:Column(2):Button({
				Text = "Import JSON",
				Icon = "download",
				Callback = function()
					local ok, details = self:ImportConfigJSON(
						controller.JsonInput:GetValue(),
						{ NoCallbacks = not controller.LoadCallbacks, DeferUnknown = true }
					)
					controller:_notify(
						ok and "Config Imported" or "Import Failed",
						ok and ("Applied %d values."):format(#details.Applied) or tostring(details),
						ok and "Success" or "Error"
					)
				end,
			})
		end

		controller:Refresh()
		controller:_readAutoload()
		if options.AutoLoad ~= false and controller.AutoloadEnabled and controller.AutoloadProfile then
			local ok, err = controller:Load(controller.AutoloadProfile)
			if not ok then
				controller:_notify("Autoload Failed", tostring(err), "Warning")
			end
		end
		return controller
	end
	function Menu:Notify(options)
		if self._destroyed or not self.NotifBox then
			return nil, "destroyed"
		end
		options = options or {}
		local title = options.Title or ""
		local content = options.Content or (options.Text and tostring(options.Text)) or ""
		local duration = options.Duration == nil and 3 or options.Duration
		assert(isFiniteNumber(duration) and duration >= 0, "FyyUI Notify: Duration must be a non-negative finite number")
		local notifType = options.Type or "Info"
		local theme = self.Theme


		local typeDefs = {
			Info = { accent = Color3.fromRGB(0, 130, 250), icon = "info" },
			Success = { accent = Color3.fromRGB(0, 180, 80), icon = "circle-check" },
			Warning = { accent = Color3.fromRGB(220, 180, 40), icon = "triangle-alert" },
			Error = { accent = Color3.fromRGB(220, 60, 60), icon = "circle-x" },
		}
		local cfg = typeDefs[notifType] or typeDefs.Info
		local iconData = resolveIcon(cfg.icon)


		local PAD = 12
		local GAP = 5
		local CARD_W = 320
		local ICON_SZ = 20
		local hasTitle = title ~= ""
		local hasContent = content ~= ""


		local contentW = CARD_W - PAD * 2
		local contentH = 0
		local textSvc = game:GetService("TextService")
		if hasContent then
			local sz = textSvc:GetTextSize(content, theme.FontSize, theme.Font, Vector2.new(contentW, 1000))
			contentH = sz.Y
		end


		local bodyTop = PAD + ICON_SZ
		if hasContent then
			bodyTop = bodyTop + GAP + contentH
		end
		local cardH = math.max(bodyTop + PAD + 3, 54)


		local frame = U.Create("Frame", {
			Name = "Notification",
			Size = UDim2.fromOffset(CARD_W, cardH),
			BackgroundColor3 = theme.Element,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = self.NotifBox,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = frame })
		U.Create("UIStroke", { Color = theme.ElementBorder, Transparency = 0.6, Thickness = 1, Parent = frame })


		if iconData and iconData.Image then
			U.Create("ImageLabel", {
				Name = "Icon",
				Size = UDim2.fromOffset(ICON_SZ, ICON_SZ),
				Position = UDim2.fromOffset(PAD, PAD),
				BackgroundTransparency = 1,
				Image = iconData.Image,
				ImageColor3 = cfg.accent,
				Parent = frame,
			})
		end


		local titleLabel
		if hasTitle then
			local titleX = iconData and (PAD + ICON_SZ + 8) or PAD
			titleLabel = U.Create("TextLabel", {
				Name = "Title",
				Size = UDim2.new(0, CARD_W - titleX - PAD, 0, theme.FontSize + 2),
				Position = UDim2.fromOffset(titleX, PAD),
				BackgroundTransparency = 1,
				Text = title,
				Font = theme.FontBold,
				TextSize = theme.FontSize,
				TextColor3 = theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = false,
				Parent = frame,
			})
		end


		local contentLabel
		if hasContent then
			local contentY = PAD + ICON_SZ + GAP
			contentLabel = U.Create("TextLabel", {
				Name = "Content",
				Size = UDim2.new(0, contentW, 0, contentH),
				Position = UDim2.fromOffset(PAD, contentY),
				BackgroundTransparency = 1,
				Text = content,
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = theme.TextSecondary,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				Parent = frame,
			})
		end


		local progressTrack = U.Create("Frame", {
			Name = "ProgressTrack",
			Size = UDim2.new(1, -(PAD * 2), 0, 3),
			Position = UDim2.fromOffset(PAD, cardH - 9),
			BackgroundColor3 = theme.ElementHover,
			BorderSizePixel = 0,
			Parent = frame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = progressTrack })
		local progressFill = U.Create("Frame", {
			Name = "ProgressFill",
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromOffset(0, 0),
			BackgroundColor3 = cfg.accent,
			BorderSizePixel = 0,
			Parent = progressTrack,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = progressFill })


		local ts = game:GetService("TweenService")
		local dismissed = false
		local progressTween
		local enterTween
		local dismissTask


		local record = {
			frame = frame,
			h = cardH,
			dismiss = nil,
			posTween = nil,
		}
		table.insert(self._activeNotifs, record)
		frame.AnchorPoint = Vector2.new(0, 1)
		self:_reflowNotifs(not self._reducedMotion, record)
		local bottomOffset = 0
		local GAP_BETWEEN = 4
		for _, rec in ipairs(self._activeNotifs) do
			if rec == record then
				break
			end
			bottomOffset = bottomOffset + rec.h + GAP_BETWEEN
		end
		local targetPosition = UDim2.new(0, 0, 1, -bottomOffset)


		if not self._reducedMotion then
			frame.Position = UDim2.new(0, 24, 1, 0)
			frame.BackgroundTransparency = 1
			for _, child in ipairs(frame:GetChildren()) do
				if child:IsA("TextLabel") then
					child.TextTransparency = 1
				end
				if child:IsA("ImageLabel") then
					child.ImageTransparency = 1
				end
				if child:IsA("Frame") then
					child.BackgroundTransparency = 1
				end
				if child:IsA("UIStroke") then
					child.Transparency = 1
				end
			end
			if progressTrack then
				progressTrack.BackgroundTransparency = 1
			end
			if progressFill then
				progressFill.BackgroundTransparency = 1
			end


			enterTween = self:_transition(frame, 0.3, {
				Position = targetPosition,
				BackgroundTransparency = 0,
			}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)


			for _, child in ipairs(frame:GetChildren()) do
				if child:IsA("TextLabel") then
					self:_transition(child, 0.25, { TextTransparency = 0 })
				elseif child:IsA("ImageLabel") then
					self:_transition(child, 0.25, { ImageTransparency = 0 })
				elseif child:IsA("Frame") then
					self:_transition(child, 0.25, { BackgroundTransparency = 0 })
				elseif child:IsA("UIStroke") then
					self:_transition(child, 0.25, { Transparency = 0.6 })
				end
			end
			if progressTrack then
				self:_transition(progressTrack, 0.25, { BackgroundTransparency = 0 })
			end
			if progressFill then
				self:_transition(progressFill, 0.25, { BackgroundTransparency = 0 })
			end
		else
			frame.Position = targetPosition
			frame.BackgroundTransparency = 0
		end


		local function dismiss()
			if dismissed or not frame or not frame.Parent then
				return false
			end
			dismissed = true


			if dismissTask then
				task.cancel(dismissTask)
				dismissTask = nil
			end
			if progressTween then
				progressTween:Cancel()
				progressTween = nil
			end
			if enterTween then
				enterTween:Cancel()
				enterTween = nil
			end


			if record.posTween then
				record.posTween:Cancel()
				record.posTween = nil
			end



			local exitPosition = frame.Position


			for i, rec in ipairs(self._activeNotifs) do
				if rec.frame == frame then
					table.remove(self._activeNotifs, i)
					break
				end
			end

			if not self._reducedMotion then


				self:_reflowNotifs(true)


				self:_transition(
					frame,
					0.3,
					{
						Position = UDim2.new(
							exitPosition.X.Scale,
							exitPosition.X.Offset + 40,
							exitPosition.Y.Scale,
							exitPosition.Y.Offset
						),
						BackgroundTransparency = 1,
					},
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.In,
					function()
						if frame and frame.Parent then
							frame:Destroy()
						end
					end
				)
				for _, child in ipairs(frame:GetDescendants()) do
					if child:IsA("TextLabel") then
						self:_transition(child, 0.2, { TextTransparency = 1 })
					elseif child:IsA("ImageLabel") then
						self:_transition(child, 0.2, { ImageTransparency = 1 })
					elseif child:IsA("Frame") then
						self:_transition(child, 0.2, { BackgroundTransparency = 1 })
					elseif child:IsA("UIStroke") then
						self:_transition(child, 0.2, { Transparency = 1 })
					end
				end
			else

				if frame then
					frame:Destroy()
				end
				self:_reflowNotifs(false)
			end
			return true
		end
		record.dismiss = dismiss


		if duration > 0 then
			if not self._reducedMotion then
				progressTween = ts:Create(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
					Size = UDim2.new(0, 0, 1, 0),
				})
				progressTween:Play()
			end
			dismissTask = task.delay(duration, function()
				if self._destroyed or dismissed or not frame or not frame.Parent then
					return
				end
				dismissTask = nil
				dismiss()
			end)
		end


		local handle = {}
		function handle:Dismiss()
			return dismiss()
		end
		function handle:Update(...)
			if dismissed or not frame or not frame.Parent then
				return false, "dismissed"
			end
			local args = { ... }

			if #args == 1 and type(args[1]) == "string" then
				content = args[1]
				title = ""
				hasTitle = false
				hasContent = content ~= ""
			elseif #args >= 2 then
				title = tostring(args[1] or "")
				content = tostring(args[2] or "")
				hasTitle = title ~= ""
				hasContent = content ~= ""
			end


			contentH = 0
			if hasContent then
				local sz = textSvc:GetTextSize(content, theme.FontSize, theme.Font, Vector2.new(contentW, 1000))
				contentH = sz.Y
			end
			local newBodyTop = PAD + ICON_SZ
			if hasContent then
				newBodyTop = newBodyTop + GAP + contentH
			end
			local newCardH = math.max(newBodyTop + PAD + 3, 54)


			if titleLabel then
				titleLabel.Text = title
				titleLabel.Visible = hasTitle
			elseif hasTitle then

				local titleX = iconData and (PAD + ICON_SZ + 8) or PAD
				titleLabel = U.Create("TextLabel", {
					Name = "Title",
					Size = UDim2.new(0, CARD_W - titleX - PAD, 0, theme.FontSize + 2),
					Position = UDim2.fromOffset(titleX, PAD),
					BackgroundTransparency = 1,
					Text = title,
					Font = theme.FontBold,
					TextSize = theme.FontSize,
					TextColor3 = theme.TextPrimary,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = false,
					Parent = frame,
				})
			end
			if not hasTitle and titleLabel then
				titleLabel.Visible = false
			end

			if contentLabel then
				contentLabel.Text = content
				contentLabel.Size = UDim2.new(0, contentW, 0, contentH)
				local newContentY = PAD + ICON_SZ + GAP
				contentLabel.Position = UDim2.fromOffset(PAD, newContentY)
				contentLabel.Visible = hasContent
			elseif hasContent then
				local contentY = PAD + ICON_SZ + GAP
				contentLabel = U.Create("TextLabel", {
					Name = "Content",
					Size = UDim2.new(0, contentW, 0, contentH),
					Position = UDim2.fromOffset(PAD, contentY),
					BackgroundTransparency = 1,
					Text = content,
					Font = theme.Font,
					TextSize = theme.FontSize,
					TextColor3 = theme.TextSecondary,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					Parent = frame,
				})
			end
			if not hasContent and contentLabel then
				contentLabel.Visible = false
			end


			frame.Size = UDim2.fromOffset(CARD_W, newCardH)
			record.h = newCardH
			progressTrack.Position = UDim2.fromOffset(PAD, newCardH - 9)


			self:_reflowNotifs(not self._reducedMotion)
			return true
		end

		return handle
	end

	function Menu:_reflowNotifs(animated, excludedRecord)
		if self._destroyed or not self._activeNotifs then
			return
		end
		if animated and self._reducedMotion then
			animated = false
		end
		local bottomOffset = 0
		local GAP = 4
		for i = 1, #self._activeNotifs do
			local rec = self._activeNotifs[i]
			local frame = rec.frame
			local target = UDim2.new(0, 0, 1, -bottomOffset)
			if rec ~= excludedRecord then
				bottomOffset = bottomOffset + rec.h + GAP
			end
			if rec ~= excludedRecord and frame and frame.Parent then
				if animated then

					if rec.posTween then
						rec.posTween:Cancel()
						rec.posTween = nil
					end
					rec.posTween = self:_transition(frame, 0.25, {
						Position = target,
					}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				else
					frame.Position = target
				end
			end
		end
	end
	function Menu:_captureInput(key, inputTypes)
		local contextActionService = game:GetService("ContextActionService")
		local actionName = self._inputCapturePrefix .. "_" .. key
		if self._capturedActions[actionName] then
			return actionName
		end
		contextActionService:BindActionAtPriority(actionName, function()
			return Enum.ContextActionResult.Sink
		end, false, 3100, table.unpack(inputTypes))
		self._capturedActions[actionName] = true
		return actionName
	end

	function Menu:_releaseInput(key)
		local actionName = self._inputCapturePrefix .. "_" .. key
		if not self._capturedActions[actionName] then
			return
		end
		game:GetService("ContextActionService"):UnbindAction(actionName)
		self._capturedActions[actionName] = nil
	end

	function Menu:_releaseAllInputCaptures()
		local contextActionService = game:GetService("ContextActionService")
		for actionName in pairs(self._capturedActions or {}) do
			contextActionService:UnbindAction(actionName)
		end
		table.clear(self._capturedActions)
	end

	function Menu:_dragging()
		local dragSurface = self.TopbarDragSurface or self.Topbar
		local frame = self.Frame
		local shadow = self._shadow
		local dragging, dragInput, ds, sp
		local uis = game:GetService("UserInputService")
		local CLAMP_MARGIN = 40

		local function stopDragging(input)
			if not dragging then
				return
			end
			local t = input and input.UserInputType
			if dragInput and input and input ~= dragInput and t ~= Enum.UserInputType.MouseButton1 then
				return
			end
			dragging = false
			dragInput = nil
			self:_releaseInput("WindowDrag")
		end

		dragSurface.InputBegan:Connect(function(input)
			local t = input.UserInputType
			if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
				self:HideDropdownPopup()
				dragging = true
				dragInput = input
				ds = input.Position
				sp = frame.Position
				if t == Enum.UserInputType.Touch then
					self:_captureInput("WindowDrag", { Enum.UserInputType.Touch })
				end
			end
		end)
		self._dragInputCon = uis.InputChanged:Connect(function(input)
			local t = input.UserInputType
			local isMouseDrag = dragging and dragInput and dragInput.UserInputType == Enum.UserInputType.MouseButton1
			local isTouchDrag = dragging
				and dragInput
				and dragInput.UserInputType == Enum.UserInputType.Touch
				and input == dragInput
			if (isMouseDrag and t == Enum.UserInputType.MouseMovement) or isTouchDrag then
				local delta = input.Position - ds

				local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
				local fs = frame.AbsoluteSize
				local rawX = sp.X.Scale * viewport.X + sp.X.Offset + delta.X
				local rawY = sp.Y.Scale * viewport.Y + sp.Y.Offset + delta.Y
				local clampedX = math.clamp(rawX, -fs.X + CLAMP_MARGIN, viewport.X - CLAMP_MARGIN)
				local clampedY = math.clamp(rawY, -fs.Y + CLAMP_MARGIN, viewport.Y - CLAMP_MARGIN)
				frame.Position = UDim2.new(
					sp.X.Scale,
					clampedX - sp.X.Scale * viewport.X,
					sp.Y.Scale,
					clampedY - sp.Y.Scale * viewport.Y
				)
				if shadow then
					shadow.Position = UDim2.new(
						sp.X.Scale,
						clampedX - sp.X.Scale * viewport.X - 8,
						sp.Y.Scale,
						clampedY - sp.Y.Scale * viewport.Y - 8
					)
				end
			end
		end)
		dragSurface.InputEnded:Connect(stopDragging)
		self._dragEndCon = uis.InputEnded:Connect(function(input)
			if
				input == dragInput
				or (
					dragInput
					and dragInput.UserInputType == Enum.UserInputType.MouseButton1
					and input.UserInputType == Enum.UserInputType.MouseButton1
				)
			then
				stopDragging(input)
			end
		end)
	end

	function Menu:_closeTransientUi()
		self:HideDropdownPopup()
		self:_releaseAllInputCaptures()
		self:CloseCommandPalette()
		self._tooltipPending = false
		self._tooltipTarget = nil
		self:_hideTooltip()
		if self._confirmPopup then
			local confirm = self._confirmPopup
			self._confirmPopup = nil
			for _, instance in pairs(confirm) do
				pcall(function()
					instance:Destroy()
				end)
			end
		end
	end

	function Menu:_setInternalsVisible(visible)
		if self.Sidebar then
			self.Sidebar.Visible = visible
		end
		if self.ContentArea then
			self.ContentArea.Visible = visible
		end
		if self.SidebarLine then
			self.SidebarLine.Visible = visible
		end
		if self.TitleAccent then
			self.TitleAccent.Visible = visible and self._titleBranded
		end
		if self.Title then
			self.Title.Visible = visible
		end
		if self.Topbar then
			for _, child in ipairs(self.Topbar:GetChildren()) do
				if child:IsA("ImageButton") then
					child.Visible = visible
				end
			end
		end
	end

	function Menu:_setMinIconTransparency(transparency, duration)
		local icon = self._minFrame and self._minFrame:FindFirstChild("Icon")
		if not icon then
			return
		end
		if duration then
			self:_transition(icon, duration, { ImageTransparency = transparency }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		else
			icon.ImageTransparency = transparency
		end
	end

	function Menu:_emitMinimizeChanged(minimized)
		for _, callback in ipairs(self._minimizeChangedCallbacks or {}) do
			local ok, err = pcall(callback, minimized)
			if not ok then
				warn("FyyUI minimize callback failed: " .. tostring(err))
			end
		end
	end

	function Menu:_setMenuTransitionVisual(scale, backgroundTransparency, shadowTransparency, outlineTransparency)
		if self._uiScale then
			self._uiScale.Scale = scale or self.Scale
		end
		if self.Frame and backgroundTransparency ~= nil then
			self.Frame.BackgroundTransparency = backgroundTransparency
		end
		if self._shadow and shadowTransparency ~= nil then
			self._shadow.BackgroundTransparency = shadowTransparency
		end
		local outline = self.Frame and self.Frame:FindFirstChildOfClass("UIStroke")
		if outline and outlineTransparency ~= nil then
			outline.Transparency = outlineTransparency
		end
	end

	function Menu:_refreshRestoredLayout()
		self:_applyResponsiveLayout(true)
		if not self.ContentArea then
			return
		end
		for _, child in ipairs(self.ContentArea:GetChildren()) do
			if child:IsA("ScrollingFrame") then
				local layout = child:FindFirstChildOfClass("UIListLayout")
				if layout then
					local padding = child:FindFirstChildOfClass("UIPadding")
					local paddingY = padding and (padding.PaddingTop.Offset + padding.PaddingBottom.Offset) or 0
					child.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + paddingY)
				end
			end
		end
	end

	function Menu:_minimize()
		if self._destroyed then
			return
		end
		if self.Minimized then
			return true
		end
		self:_resetWinHover()
		self:_releaseInput("OverviewWheel")
		self:_releaseInput("OverviewTouch")
		self:_releaseInput("WindowDrag")
		self:_closeTransientUi()
		self:_setInternalsVisible(false)
		self.Minimized = true
		self:_emitMinimizeChanged(true)
		self._minPrevSize = self.Frame.Size
		self._minPrevPos = self.Frame.Position

		self._minimizeToken = (self._minimizeToken or 0) + 1
		self:_setMenuTransitionVisual(self.Scale, self._baseBackgroundTransparency, 0.55, 0.25)
		if self._minGui then
			self._minFrame.Position = self._minSavedPos or self._minInitialPos
			self._minFrame.Active = true
			self._minFrame.BackgroundTransparency = 0
			if self._minScale then
				self._minScale.Scale = 1
			end
			self:_setMinIconTransparency(0)
			self._minGui.Enabled = true
			self._minGui.Parent = self.GuiParent
			self.Gui.Enabled = false
		elseif self._noLogoRestoreGui then
			if self._noLogoRestoreBtn and self._noLogoSavedPos then
				self._noLogoRestoreBtn.Position = self._noLogoSavedPos
			end
			self._noLogoRestoreGui.Enabled = true
			self._noLogoRestoreGui.Parent = self.GuiParent
			self.Gui.Enabled = false
		end
		return true
	end

	function Menu:_restore()
		if self._destroyed or self._restoring or not self.Minimized then
			return
		end
		self:_resetWinHover()
		self._restoring = true
		self._minimizeToken = (self._minimizeToken or 0) + 1
		local restoreToken = self._minimizeToken
		self.Minimized = false
		local guiWasEnabled = self.Gui.Enabled
		local minGuiWasEnabled = self._minGui and self._minGui.Enabled or false
		local noLogoGuiWasEnabled = self._noLogoRestoreGui and self._noLogoRestoreGui.Enabled or false

		local restorePos = self._minPrevPos or self._initialPos
		self.Frame.Size = self._minPrevSize or self._initialSize
		self.Frame.Position = restorePos + UDim2.fromOffset(0, 8)
		self:_setMenuTransitionVisual(self.Scale * 0.96, math.min(1, self._baseBackgroundTransparency + 0.72), 1, 1)
		self.Gui.Enabled = true
		self:_refreshRestoredLayout()
		if self._minFrame and self._minGui and self._minGui.Enabled then
			self._minFrame.Active = false
			self:_transition(
				self._minFrame,
				0.12,
				{ BackgroundTransparency = 1 },
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.In
			)
			if self._minScale then
				self:_transition(self._minScale, 0.12, { Scale = 0.9 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			end
			self:_setMinIconTransparency(1, 0.1)
			local function hideMinimizeGui()
				if self._destroyed or self._minimizeToken ~= restoreToken then
					return
				end
				self._minGui.Enabled = false
			end
			if self._reducedMotion then
				hideMinimizeGui()
			else
				task.delay(0.12, hideMinimizeGui)
			end
		elseif self._noLogoRestoreGui then
			self._noLogoRestoreGui.Enabled = false
		end

		local pending = self._shadow and 3 or 2
		local function finishRestore()
			pending -= 1
			if pending <= 0 then
				if self._destroyed or self._minimizeToken ~= restoreToken then
					if not self._destroyed then
						self.Minimized = true
						self.Gui.Enabled = guiWasEnabled
						if self._minGui then
							self._minGui.Enabled = minGuiWasEnabled
						end
						if self._noLogoRestoreGui then
							self._noLogoRestoreGui.Enabled = noLogoGuiWasEnabled
						end
					end
					self._restoring = false
					return
				end
				self:_setInternalsVisible(true)
				self._restoring = false
				if self._minFrame then
					self._minFrame.Active = true
					self._minFrame.BackgroundTransparency = 0
					if self._minScale then
						self._minScale.Scale = 1
					end
					self:_setMinIconTransparency(0)
				end
				if self._noLogoRestoreGui then
					self._noLogoRestoreGui.Enabled = false
				end
				self:_refreshRestoredLayout()
				local activeTab = self.ActiveTab
				if activeTab and activeTab.Components then
					for _, comp in ipairs(activeTab.Components) do
						if type(comp) == "table" and type(comp._updateSize) == "function" then
							pcall(comp._updateSize, comp, true)
						end
					end
				end
			end
		end
		self:_transition(
			self.Frame,
			0.24,
			{ Position = restorePos, BackgroundTransparency = self._baseBackgroundTransparency },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			finishRestore
		)
		self:_transition(
			self._uiScale,
			0.24,
			{ Scale = self.Scale },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out,
			finishRestore
		)
		if self._shadow then
			self:_transition(self._shadow, 0.22, { BackgroundTransparency = 0.55 }, nil, nil, finishRestore)
		else


		end
	end

	function Menu:_toggleMaximize()
		if self._destroyed or self._maximizing then
			return
		end
		self._maximizing = true
		self.Maximized = not self.Maximized
		self.Gui.Enabled = true
		if self.Minimized then
			self.Minimized = false
			self:_setInternalsVisible(true)
			if self._minGui then
				self._minGui.Enabled = false
			end
			if self._noLogoRestoreGui then
				self._noLogoRestoreGui.Enabled = false
			end
		end

		if self._maximizeTween then
			self._maximizeTween:Cancel()
		end
		local viewport = self:_viewportSize()
		local targetSize, targetPosition
		if self.Maximized then
			self._maxPrevPos = self.Frame.Position
			self._maxPrevSize = self.Frame.Size
			targetSize = UDim2.fromOffset(viewport.X - 40, viewport.Y - 40)
			targetPosition = UDim2.fromOffset(20, 20)
		else
			targetSize = self._maxPrevSize or self._initialSize
			targetPosition = self._maxPrevPos or self._initialPos
		end

		self._maximizeTween = self:_transition(
			self.Frame,
			0.25,
			{ Size = targetSize, Position = targetPosition },
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.Out,
			function()
				if self._destroyed then
					return
				end
				self._maximizing = false
				self._maximizeTween = nil
				if self._updateShadow then
					self._updateShadow()
				end
			end
		)
	end

	function Menu:_resizable()
		local grip = U.Create("ImageButton", {
			Name = "ResizeGrip",
			Size = UDim2.fromOffset(44, 44),
			Position = UDim2.new(1, -44, 1, -44),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Active = true,
			Parent = self.Frame,
		})
		local gripVisual = U.Create("Frame", {
			Name = "Visual",
			Size = UDim2.fromOffset(14, 14),
			Position = UDim2.new(1, -14, 1, -14),
			BackgroundColor3 = self.Theme.TextMuted,
			BackgroundTransparency = 0.6,
			BorderSizePixel = 0,
			Parent = grip,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = gripVisual })

		local frame = self.Frame
		local shadow = self._shadow
		local uis = game:GetService("UserInputService")
		local resizing, rs, rsiz, resizeInputObj

		grip.InputBegan:Connect(function(input)
			local t = input.UserInputType
			if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
				resizing = true
				resizeInputObj = input
				rs = input.Position
				rsiz = frame.Size
			end
		end)
		self._resizeInputCon = uis.InputChanged:Connect(function(input, _)
			local t = input.UserInputType


			local isOurTouch = (t == Enum.UserInputType.Touch and input == resizeInputObj)
			if ((t == Enum.UserInputType.MouseMovement) or isOurTouch) and resizing then
				local delta = input.Position - rs
				local nw = math.max(200, rsiz.X.Offset + delta.X)
				local nh = math.max(140, rsiz.Y.Offset + delta.Y)
				if self.MinSize then
					nw = math.max(nw, self.MinSize.X)
					nh = math.max(nh, self.MinSize.Y)
				end
				if self.MaxSize then
					nw = math.min(nw, self.MaxSize.X)
					nh = math.min(nh, self.MaxSize.Y)
				end
				frame.Size = UDim2.fromOffset(nw, nh)
				if not self._responsiveApplied and not self.Maximized then
					self._responsiveBaseSize = frame.Size
					self._responsiveBasePosition = frame.Position
				end
				if shadow then
					shadow.Size = UDim2.fromOffset(nw + 16, nh + 16)
				end
			end
		end)
		self._resizeEndCon = uis.InputEnded:Connect(function(input, _)
			local t = input.UserInputType



			if resizing then
				if t == Enum.UserInputType.MouseButton1 or (t == Enum.UserInputType.Touch and input == resizeInputObj) then
					resizing = false
					resizeInputObj = nil
				end
			end
		end)
	end

	function Menu:SetVisible(v)
		if self._destroyed then
			return false, "destroyed"
		end
		if type(v) ~= "boolean" then
			return false, "expected boolean"
		end
		self.Visible = v
		if not self.Gui then
			return false, "missing gui"
		end
		if v then

			if self.Minimized then
				self.Gui.Enabled = false
				if self._minGui then
					self._minGui.Enabled = true
					self._minGui.Parent = self.GuiParent
				elseif self._noLogoRestoreGui then
					self._noLogoRestoreGui.Enabled = true
					self._noLogoRestoreGui.Parent = self.GuiParent
				end
			else
				self.Gui.Enabled = true
				self:_setMenuTransitionVisual(self.Scale, self._baseBackgroundTransparency, 0.55, 0.25)
				self:_setInternalsVisible(true)
			end
			if self._notifGui then
				self._notifGui.Enabled = true
			end
		else

			self:_releaseInput("OverviewWheel")
			self:_releaseInput("WindowDrag")
			self:_closeTransientUi()
			if self._minGui then
				self._minGui.Enabled = false
			end
			if self._noLogoRestoreGui then
				self._noLogoRestoreGui.Enabled = false
			end
			if self._notifGui then
				self._notifGui.Enabled = false
			end
			self.Gui.Enabled = false
		end
		return true
	end

	function Menu:ToggleVisibility()
		return self:SetVisible(not self.Visible)
	end
	function Menu:GetVisible()
		return self.Visible
	end
	function Menu:SetTitle(t)
		if self._destroyed or not self.Title then
			return false, "destroyed"
		end
		if type(t) ~= "string" then
			return false, "expected string"
		end
		self._titleText = t
		self._refreshTitle()
		return true
	end

	function Menu:_confirmClose()
		if self._confirmPopup then
			return
		end

		self:HideDropdownPopup()
		self._confirmFocusReturn = self:_beginTransientFocus(self.Topbar)
		local theme = self.Theme
		local frame = self.Frame


		local overlay = U.Create("ImageButton", {
			Name = "ConfirmOverlay",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10,
			AutoButtonColor = false,
			Parent = frame,
		})


		local shadow = U.Create("Frame", {
			Size = UDim2.fromOffset(268, 138),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.65,
			BorderSizePixel = 0,
			ZIndex = 11,
			Parent = frame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = shadow })


		local popup = U.Create("Frame", {
			Name = "ConfirmPop",
			Size = UDim2.fromOffset(260, 130),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = theme.Sidebar,
			BackgroundTransparency = 0.1,
			BorderSizePixel = 0,
			ZIndex = 12,
			Parent = frame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = popup })
		U.Create("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.88, Thickness = 1, Parent = popup })


		U.Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 40),
			Position = UDim2.fromOffset(10, 18),
			BackgroundTransparency = 1,
			Text = "Close Menu?",
			Font = theme.FontBold,
			TextSize = 20,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Center,
			ZIndex = 13,
			Parent = popup,
		})
		U.Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 20),
			Position = UDim2.fromOffset(10, 54),
			BackgroundTransparency = 1,
			Text = "Are you sure you want to exit?",
			Font = theme.Font,
			TextSize = 14,
			TextColor3 = theme.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Center,
			ZIndex = 13,
			Parent = popup,
		})


		local function makeBtn(text, xOff, defColor, hovColor, cb)
			local b = U.Create("ImageButton", {
				Size = UDim2.fromOffset(100, 30),
				Position = UDim2.fromOffset(xOff, 85),
				BackgroundColor3 = defColor,
				BackgroundTransparency = 0.25,
				AutoButtonColor = false,
				ZIndex = 14,
				Parent = popup,
			})
			self:_makeSelectable(b)
			U.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = b })
			local bs = U.Create("UIScale", { Parent = b, Scale = 1 })
			U.Create("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = text,
				Font = theme.FontBold,
				TextSize = 15,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 15,
				Parent = b,
			})
			b.MouseEnter:Connect(function()
				self:_transition(b, 0.12, { BackgroundColor3 = hovColor, BackgroundTransparency = 0.05 })
			end)
			b.MouseLeave:Connect(function()
				self:_transition(b, 0.12, { BackgroundColor3 = defColor, BackgroundTransparency = 0.25 })
			end)
			b.MouseButton1Down:Connect(function()
				self:_transition(bs, 0.05, { Scale = 0.95 })
			end)
			b.MouseButton1Up:Connect(function()
				self:_transition(bs, 0.08, { Scale = 1 })
			end)
			b.Activated:Connect(cb)
			return b
		end

		self._confirmPopup = { popup = popup, overlay = overlay, shadow = shadow }


		self:_transition(overlay, 0.2, { BackgroundTransparency = 0.5 })


		local closing = false
		local function closePopup(cb)
			if closing then
				return
			end
			closing = true
			self:_transition(overlay, 0.2, { BackgroundTransparency = 1 }, nil, nil, function()
				if self._destroyed then
					return
				end
				if overlay then
					overlay:Destroy()
				end
				if popup then
					popup:Destroy()
				end
				if shadow then
					shadow:Destroy()
				end
				self._confirmPopup = nil
				local focusReturn = self._confirmFocusReturn
				self._confirmFocusReturn = nil
				self:_restoreTransientFocus(focusReturn)
				if cb then
					cb()
				end
			end)
		end

		local noButton = makeBtn("No", 20, Color3.fromRGB(55, 55, 68), Color3.fromRGB(75, 75, 90), function()
			closePopup(nil)
		end)
		makeBtn("Yes", 140, Color3.fromRGB(170, 45, 45), Color3.fromRGB(210, 60, 60), function()
			closePopup(function()
				self:Destroy()
			end)
		end)
		if self._confirmFocusReturn then
			game:GetService("GuiService").SelectedObject = noButton
		end
	end

	function Menu:OnDestroy(callback)
		if type(callback) ~= "function" then
			return false, "expected function"
		end
		if self._destroyed then
			local ok, err = pcall(callback)
			if not ok then
				warn("FyyUI OnDestroy callback failed: " .. tostring(err))
			end
			return false, "destroyed"
		end
		table.insert(self._destroyCallbacks, callback)
		return true
	end

	function Menu:OnMinimizeChanged(callback)
		if type(callback) ~= "function" then
			return false, "expected function"
		end
		if self._destroyed then
			return false, "destroyed"
		end
		table.insert(self._minimizeChangedCallbacks, callback)
		return true
	end

	function Menu:Destroy()
		if self._destroyed then
			return
		end
		self:_closeTransientUi()
		self:_releaseAllInputCaptures()
		self._destroyed = true
		self._minimizeChangedCallbacks = {}
		self.Visible = false
		self.Minimized = false
		self:_emitMinimizeChanged(false)
		self._minimizeToken = (self._minimizeToken or 0) + 1
		if self._activeNotifs then
			local activeNotifs = table.clone(self._activeNotifs)
			for _, record in ipairs(activeNotifs) do
				if record.frame then
					record.frame:Destroy()
				end
			end
			table.clear(self._activeNotifs)
		end


		if self._heartbeatCon then
			self._heartbeatCon:Disconnect()
			self._heartbeatCon = nil
		end
		for _, connection in ipairs(self._overviewConns or {}) do
			connection:Disconnect()
		end
		self._overviewConns = {}
		if self._popupUISCon then
			self._popupUISCon:Disconnect()
			self._popupUISCon = nil
		end
		if self._dragInputCon then
			self._dragInputCon:Disconnect()
			self._dragInputCon = nil
		end
		if self._dragEndCon then
			self._dragEndCon:Disconnect()
			self._dragEndCon = nil
		end
		if self._minDragInputCon then
			self._minDragInputCon:Disconnect()
			self._minDragInputCon = nil
		end
		if self._noLogoDragCon then
			self._noLogoDragCon:Disconnect()
			self._noLogoDragCon = nil
		end
		if self._sidebarScrollCon then
			self._sidebarScrollCon:Disconnect()
			self._sidebarScrollCon = nil
		end
		if self._resizeInputCon then
			self._resizeInputCon:Disconnect()
			self._resizeInputCon = nil
		end
		if self._resizeEndCon then
			self._resizeEndCon:Disconnect()
			self._resizeEndCon = nil
		end
		if self._cameraCon then
			self._cameraCon:Disconnect()
			self._cameraCon = nil
		end
		if self._cameraViewportCon then
			self._cameraViewportCon:Disconnect()
			self._cameraViewportCon = nil
		end
		if self._keybindInputCon then
			self._keybindInputCon:Disconnect()
			self._keybindInputCon = nil
		end
		if self._keybindEndCon then
			self._keybindEndCon:Disconnect()
			self._keybindEndCon = nil
		end
		if self._scaleTween then
			self._scaleTween:Cancel()
			self._scaleTween = nil
		end
		if self._activeBarTween then
			self._activeBarTween:Cancel()
			self._activeBarTween = nil
		end


		if self._notifGui then
			self._notifGui:Destroy()
			self._notifGui = nil
		end
		if self._minGui then
			self._minGui:Destroy()
			self._minGui = nil
		end
		if self._noLogoRestoreGui then
			self._noLogoRestoreGui:Destroy()
			self._noLogoRestoreGui = nil
		end


		if self._confirmPopup then
			if self._confirmPopup.overlay then
				self._confirmPopup.overlay:Destroy()
			end
			if self._confirmPopup.popup then
				self._confirmPopup.popup:Destroy()
			end
			if self._confirmPopup.shadow then
				self._confirmPopup.shadow:Destroy()
			end
			self._confirmPopup = nil
		end


		if self._activePopupFrame then
			self._activePopupFrame:Destroy()
			self._activePopupFrame = nil
		end
		if self._activePopupOverlay then
			self._activePopupOverlay:Destroy()
			self._activePopupOverlay = nil
		end
		if self._activeDropdown then
			self._activeDropdown = nil
		end


		self._tooltipPending = false
		self._tooltipTarget = nil
		self._tooltipActive = false
		if self._tooltipTween then
			self._tooltipTween:Cancel()
			self._tooltipTween = nil
		end
		if self._mouseCon then
			self._mouseCon:Disconnect()
			self._mouseCon = nil
		end
		for _, data in pairs(self._tooltips) do
			if data.unbind then
				data.unbind()
			end
		end
		self._tooltips = {}
		if self._tooltipLabel then
			self._tooltipLabel:Destroy()
			self._tooltipLabel = nil
		end


		for _, tab in ipairs(self.Tabs) do
			tab:Destroy()
		end
		self.Tabs = {}


		if self.Gui then
			self.Gui:Destroy()
			self.Gui = nil
		end

		local destroyCallbacks = self._destroyCallbacks or {}
		self._destroyCallbacks = {}
		for _, callback in ipairs(destroyCallbacks) do
			local ok, err = pcall(callback)
			if not ok then
				warn("FyyUI OnDestroy callback failed: " .. tostring(err))
			end
		end
	end
	function Menu:_ApplyTheme(theme)
		if not self.Frame then
			return
		end


		self.Frame.BackgroundColor3 = theme.Background
		local corner = self.Frame:FindFirstChildOfClass("UICorner")
		if corner then
			corner.CornerRadius = UDim.new(0, theme.CornerRadius)
		end
		local frameStroke = self.Frame:FindFirstChildOfClass("UIStroke")
		if frameStroke then
			frameStroke.Color = theme.Outline
		end


		if self._shadow then
			self._shadow.BackgroundColor3 = theme.Shadow
			local shadowCorner = self._shadow:FindFirstChildOfClass("UICorner")
			if shadowCorner then
				shadowCorner.CornerRadius = UDim.new(0, theme.CornerRadius + 2)
			end
		end


		self.Topbar.BackgroundColor3 = theme.Topbar
		local topCorner = self.Topbar:FindFirstChildOfClass("UICorner")
		if topCorner then
			topCorner.CornerRadius = UDim.new(0, theme.CornerRadius)
		end
		local topFill = self.Topbar:FindFirstChild("Fill")
		if topFill then
			topFill.BackgroundColor3 = theme.Topbar
		end


		self.Title.TextColor3 = theme.TextPrimary
		self.Title.Font = Enum.Font.BuilderSansBold
		self.Title.TextSize = 17
		if self.TitleAccent then
			self.TitleAccent.TextColor3 = theme.Accent
			self.TitleAccent.TextStrokeColor3 = theme.AccentLine
			self.TitleAccent.Font = Enum.Font.BuilderSansExtraBold
			self.TitleAccent.TextSize = 17
		end
		if self._titleGradient then
			self._titleGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, theme.Accent),
				ColorSequenceKeypoint.new(0.5, theme.AccentLine),
				ColorSequenceKeypoint.new(1, theme.Accent),
			})
		end
		if self._refreshTitle then
			self._refreshTitle()
		end


		if self.AccentLine then
			self.AccentLine.BackgroundColor3 = theme.AccentLine
		end


		self.Sidebar.BackgroundColor3 = theme.Sidebar


		if self.ActiveBar then
			self.ActiveBar.BackgroundColor3 = theme.Accent
		end


		local grip = self.Frame:FindFirstChild("ResizeGrip")
		if grip then
			local visual = grip:FindFirstChild("Visual")
			if visual then
				visual.BackgroundColor3 = theme.TextMuted
			end
		end


		if self._noLogoRestoreBtn then
			self._noLogoRestoreBtn.BackgroundColor3 = theme.Element
			self._noLogoRestoreBtn.TextColor3 = theme.TextPrimary
			local restoreStroke = self._noLogoRestoreBtn:FindFirstChildOfClass("UIStroke")
			if restoreStroke then
				restoreStroke.Color = theme.Accent
			end
		end
		if self._minFrame then
			self._minFrame.BackgroundColor3 = theme.Element
			local minStroke = self._minFrame:FindFirstChildOfClass("UIStroke")
			if minStroke then
				minStroke.Color = theme.Accent
			end
		end
		if self.SidebarLine then
			self.SidebarLine.BackgroundColor3 = theme.Border
		end


		if self._confirmPopup then
			local pop = self._confirmPopup.popup
			if pop then
				pop.BackgroundColor3 = theme.Sidebar
				local labels = pop:FindFirstChildOfClass("TextLabel")

				for _, lbl in ipairs(pop:GetChildren()) do
					if lbl:IsA("TextLabel") then
						lbl.Font = theme.Font
					end
				end
			end
		end


		if self.NotifBox then
			for _, notif in ipairs(self.NotifBox:GetChildren()) do
				if notif:IsA("Frame") then
					notif.BackgroundColor3 = theme.Element
					local stroke = notif:FindFirstChildOfClass("UIStroke")
					if stroke then
						stroke.Color = theme.ElementBorder
					end
					local icon = notif:FindFirstChild("Icon")
					if icon and icon:IsA("ImageLabel") then
						icon.ImageColor3 = icon.ImageColor3
					end
					local titleLbl = notif:FindFirstChild("Title")
					if titleLbl and titleLbl:IsA("TextLabel") then
						titleLbl.Font = theme.FontBold
						titleLbl.TextSize = theme.FontSize
						titleLbl.TextColor3 = theme.TextPrimary
					end
					local contentLbl = notif:FindFirstChild("Content")
					if contentLbl and contentLbl:IsA("TextLabel") then
						contentLbl.Font = theme.Font
						contentLbl.TextSize = theme.FontSize
						contentLbl.TextColor3 = theme.TextSecondary
					end
					local track = notif:FindFirstChild("ProgressTrack")
					if track and track:IsA("Frame") then
						track.BackgroundColor3 = theme.ElementHover
					end
				end
			end
		end


		for _, tab in ipairs(self.Tabs) do
			tab:ApplyTheme(theme)
		end


		if self._tooltipLabel then
			self._tooltipLabel.BackgroundColor3 = theme.Element
			self._tooltipLabel.Font = theme.Font
			self._tooltipLabel.TextSize = theme.FontSize
			self._tooltipLabel.TextColor3 = theme.TextPrimary
			local stroke = self._tooltipLabel:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = theme.Outline
			end
		end


		if self._paletteFrame then
			self._paletteFrame.BackgroundColor3 = theme.Background
			local stroke = self._paletteFrame:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = theme.Outline
			end
			if self._paletteSearchBox then
				self._paletteSearchBox.BackgroundColor3 = theme.Element
				self._paletteSearchBox.Font = theme.Font
				self._paletteSearchBox.TextSize = theme.FontSize
				self._paletteSearchBox.TextColor3 = theme.TextPrimary
				self._paletteSearchBox.PlaceholderColor3 = theme.TextMuted
			end
			if self._paletteResults then
				self._paletteResults.ScrollBarImageColor3 = theme.ScrollBar
			end
			if self._paletteEmpty then
				self._paletteEmpty.Font = theme.Font
				self._paletteEmpty.TextSize = theme.FontSizeSmall
				self._paletteEmpty.TextColor3 = theme.TextMuted
			end
			if self._paletteSearchBox then
				self:_filterPaletteResults(self._paletteSearchBox.Text)
			end
		end
	end

	function Menu:SetTheme(themeOrName)
		if self._destroyed then
			return false, "destroyed"
		end
		if type(themeOrName) == "string" then
			local builtin = Theme[themeOrName]
			if not builtin then
				return false, "Unknown built-in theme: " .. tostring(themeOrName)
			end
			self.Theme = builtin
		elseif type(themeOrName) == "table" then
			self.Theme = Theme:Override(Theme.Dark, themeOrName)
		else
			return false, "Expected a theme name (string) or theme table"
		end
		self:_ApplyTheme(self.Theme)
		return true
	end

	function Menu:SetScale(value)
		if self._destroyed then
			return false, "destroyed"
		end
		if not isFiniteNumber(value) then
			return false, "expected finite number"
		end
		value = math.clamp(value, 0.75, 1.35)
		self.Scale = value
		self:_applyResponsiveLayout()
		if not self._uiScale then
			return true
		end
		if self._reducedMotion then
			self._uiScale.Scale = value
		else
			if self._scaleTween then
				self._scaleTween:Cancel()
			end
			self._scaleTween = game:GetService("TweenService"):Create(
				self._uiScale,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Scale = value }
			)
			self._scaleTween:Play()
		end
		return true
	end

	function Menu:GetScale()
		if self._destroyed then
			return nil, "destroyed"
		end
		return self.Scale
	end







	function Menu:BindTooltip(instance, text)
		if self._destroyed or not instance then
			return function() end
		end


		if self._tooltips[instance] then
			self._tooltips[instance].unbind()
		end

		local conns = {}
		local boundInstance = instance

		local function disconnectAll()
			for _, c in ipairs(conns) do
				c:Disconnect()
			end
			conns = {}
			if self._tooltips then
				self._tooltips[boundInstance] = nil
			end
			if self._tooltipTarget == boundInstance then
				self._tooltipPending = false
				self._tooltipTarget = nil
				self:_hideTooltip()
			end
		end


		table.insert(
			conns,
			instance.MouseEnter:Connect(function()
				if self._destroyed then
					return
				end
				self._tooltipPending = true
				self._tooltipTarget = instance
				task.delay(0.4, function()
					if not self._tooltipPending or self._tooltipTarget ~= instance or self._destroyed then
						return
					end
					if not instance or not instance.Parent then
						self._tooltipPending = false
						self._tooltipTarget = nil
						return
					end
					self:_showTooltip(text)
				end)
			end)
		)


		table.insert(
			conns,
			instance.MouseLeave:Connect(function()
				self._tooltipPending = false
				self._tooltipTarget = nil
				self:_hideTooltip()
			end)
		)


		table.insert(
			conns,
			instance.InputBegan:Connect(function(input)
				if
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.MouseButton2
					or input.UserInputType == Enum.UserInputType.MouseButton3
				then
					self._tooltipPending = false
					self._tooltipTarget = nil
					self:_hideTooltip()
				end
			end)
		)

		self._tooltips[instance] = { unbind = disconnectAll, text = text }
		return disconnectAll
	end

	function Menu:_showTooltip(text)
		if self._destroyed or not self._tooltipLabel then
			return
		end
		local label = self._tooltipLabel


		label.Text = text
		label.Size = UDim2.fromOffset(2000, 26)
		local tb = label.TextBounds
		local tw = math.min(math.max(tb.X + 16, 24), 300)
		local th = math.max(tb.Y + 8, 26)
		label.Size = UDim2.fromOffset(tw, th)


		local frameAbsPos = self.Frame.AbsolutePosition
		local frameSize = self.Frame.AbsoluteSize
		local relX = math.clamp(self._mousePos.X - frameAbsPos.X + 12, 0, math.max(0, frameSize.X - tw))
		local relY = math.clamp(self._mousePos.Y - frameAbsPos.Y + 20, 0, math.max(0, frameSize.Y - th))
		label.Position = UDim2.fromOffset(relX, relY)


		label.Visible = true
		label.BackgroundTransparency = 1
		label.TextTransparency = 1
		if self._tooltipTween then
			self._tooltipTween:Cancel()
		end
		self._tooltipTween = self:_transition(label, 0.12, {
			BackgroundTransparency = 0.08,
			TextTransparency = 0,
		})
		self._tooltipActive = true
	end

	function Menu:_hideTooltip()
		if not self._tooltipLabel or not self._tooltipActive then
			return
		end
		self._tooltipActive = false
		if self._tooltipTween then
			self._tooltipTween:Cancel()
			self._tooltipTween = nil
		end

		local label = self._tooltipLabel
		self:_transition(
			label,
			0.08,
			{
				BackgroundTransparency = 1,
				TextTransparency = 1,
			},
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In,
			function()
				label.Visible = false
			end
		)
	end

	function Menu:_updateTooltipPosition()
		if not self._tooltipLabel or not self._tooltipLabel.Visible then
			return
		end
		local label = self._tooltipLabel
		local size = label.Size
		local tw = size.X.Offset
		local th = size.Y.Offset
		local frameAbsPos = self.Frame.AbsolutePosition
		local frameSize = self.Frame.AbsoluteSize
		local relX = math.clamp(self._mousePos.X - frameAbsPos.X + 12, 0, math.max(0, frameSize.X - tw))
		local relY = math.clamp(self._mousePos.Y - frameAbsPos.Y + 20, 0, math.max(0, frameSize.Y - th))
		label.Position = UDim2.fromOffset(relX, relY)
	end



	function Menu:_buildPaletteIndex()
		self._paletteIndex = {}
		for _, tab in ipairs(self.Tabs) do
			if not tab._destroyed then
				table.insert(self._paletteIndex, {
					type = "tab",
					text = tab.Text,
					tab = tab,
					collapsible = nil,
					ref = nil,
				})
				self:_indexTabComponents(tab.Components, tab, nil)
			end
		end
	end

	function Menu:_indexTabComponents(components, tab, collapsible)
		for _, comp in ipairs(components) do
			if type(comp) == "table" and comp._destroyed then
				continue
			end

			if type(comp) == "table" and comp._closed ~= nil then
				if comp.Title then
					table.insert(self._paletteIndex, {
						type = "section",
						text = comp.Title.Text,
						tab = tab,
						collapsible = comp,
						ref = comp,
					})
				end
				if comp.Components then
					self:_indexTabComponents(comp.Components, tab, comp)
				end
			else
				local text = nil
				if type(comp) == "table" then
					if comp.Text then
						text = tostring(comp.Text)
					end
					if not text and comp.Container and not comp.Container:IsA("ScrollingFrame") then
						local txtChild = comp.Container:FindFirstChild("Text")
						if txtChild and txtChild:IsA("TextLabel") then
							text = txtChild.Text
						end
					end
				end
				if text and text ~= "" then
					table.insert(self._paletteIndex, {
						type = "component",
						text = text,
						tab = tab,
						collapsible = collapsible,
						ref = comp,
					})
				end
			end
		end
	end


	function Menu:_filterPaletteResults(query)
		for _, btn in ipairs(self._paletteResultButtons) do
			pcall(function()
				btn:Destroy()
			end)
		end
		self._paletteResultButtons = {}

		local q = query:lower()
		local filtered = {}
		for _, item in ipairs(self._paletteIndex) do
			if (#q == 0 or item.text:lower():find(q, 1, true)) and #filtered < self._paletteMaxResults then
				table.insert(filtered, item)
			end
		end
		self._paletteFilteredResults = filtered

		if self._paletteEmpty then
			self._paletteEmpty.Visible = #filtered == 0
		end
		if not self._paletteFrame then
			return
		end
		local theme = self.Theme

		for i, result in ipairs(filtered) do
			local btn = U.Create("TextButton", {
				Name = "Result",
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundTransparency = 0.6,
				AutoButtonColor = false,
				Text = "",
				ZIndex = 100002,
				Parent = self._paletteResults,
			})

			local selection = U.Create("Frame", {
				Name = "Selection",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 100002,
				Parent = btn,
			})
			U.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = selection })

			U.Create("TextLabel", {
				Name = "Label",
				Size = UDim2.new(1, -70, 1, 0),
				Position = UDim2.fromOffset(10, 0),
				BackgroundTransparency = 1,
				Text = result.text,
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 100003,
				Parent = btn,
			})

			local src = result.type == "tab" and "Tab"
				or (result.type == "section" and "Section")
				or (result.collapsible and result.collapsible.Title.Text or result.tab.Text)
			U.Create("TextLabel", {
				Name = "Source",
				Size = UDim2.new(0, 60, 1, 0),
				Position = UDim2.new(1, -64, 0, 0),
				BackgroundTransparency = 1,
				Text = src,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 100003,
				Parent = btn,
			})

			btn.MouseButton1Click:Connect(function()
				self:_paletteActivateResult(result)
			end)
			table.insert(self._paletteResultButtons, btn)
		end

		if #filtered == 0 then
			self._paletteSelectedIndex = 0
		else
			self._paletteSelectedIndex = math.clamp(self._paletteSelectedIndex, 1, #filtered)
		end
		self:_updatePaletteSelection()
	end

	function Menu:_updatePaletteSelection()
		for i, btn in ipairs(self._paletteResultButtons) do
			local sel = btn:FindFirstChild("Selection")
			if sel then
				if i == self._paletteSelectedIndex then
					sel.BackgroundColor3 = self.Theme.Accent
					sel.BackgroundTransparency = 0.55
				else
					sel.BackgroundTransparency = 1
				end
			end
		end
	end

	function Menu:_paletteSelectNext()
		local n = #self._paletteFilteredResults
		if n == 0 then
			return
		end
		self._paletteSelectedIndex = self._paletteSelectedIndex + 1
		if self._paletteSelectedIndex > n then
			self._paletteSelectedIndex = 1
		end
		self:_updatePaletteSelection()
	end

	function Menu:_paletteSelectPrev()
		local n = #self._paletteFilteredResults
		if n == 0 then
			return
		end
		self._paletteSelectedIndex = self._paletteSelectedIndex - 1
		if self._paletteSelectedIndex < 1 then
			self._paletteSelectedIndex = n
		end
		self:_updatePaletteSelection()
	end

	function Menu:_paletteActivateSelected()
		local results = self._paletteFilteredResults or {}
		local idx = self._paletteSelectedIndex
		if idx > 0 and idx <= #results then
			self:_paletteActivateResult(results[idx])
		end
	end

	function Menu:_paletteActivateResult(result)
		if not result then
			return
		end
		if result.type == "tab" then
			self:SelectTab(result.tab)
			self:CloseCommandPalette()
			return
		end

		self:SelectTab(result.tab)
		local needsOpen = result.collapsible and not result.collapsible._isOpen
		if needsOpen then
			result.collapsible:Open()
		end
		self:CloseCommandPalette()
		local target = result.ref
		local container = target and (target.Container or (target.Title and target.Container))
		if container then
			if needsOpen then
				task.wait(0.26)
			end
			self:_emphasizeComponent(result.tab, container)
		end
	end

	function Menu:_emphasizeComponent(tab, container)
		if not tab.Container or not container or not container:IsDescendantOf(tab.Container) then
			return
		end
		local scroll = tab.Container

		task.spawn(function()
			task.wait(0.05)
			if not scroll or not container or not container:IsDescendantOf(scroll) then
				return
			end
			local absC = container.AbsolutePosition
			local absS = scroll.AbsolutePosition
			local relY = absC.Y - absS.Y + scroll.CanvasPosition.Y - 16
			local ts = game:GetService("TweenService")
			ts:Create(scroll, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				CanvasPosition = Vector2.new(0, math.max(0, relY)),
			}):Play()
		end)

		local origColor = container.BackgroundColor3
		local origTrans = container.BackgroundTransparency
		container.BackgroundColor3 = self.Theme.Accent
		container.BackgroundTransparency = 0.65
		task.delay(0.5, function()
			if not container or container.Parent == nil then
				return
			end
			local ts = game:GetService("TweenService")
			ts:Create(container, TweenInfo.new(0.4), { BackgroundTransparency = origTrans }):Play()
			task.delay(0.1, function()
				if container then
					container.BackgroundColor3 = origColor
				end
			end)
		end)
	end

	function Menu:OpenCommandPalette()
		if self._destroyed or not self.Visible or self.Minimized then
			return false, "not visible"
		end
		if self._paletteOpen then
			self:CloseCommandPalette()
		end
		self:HideDropdownPopup()
		self:_buildPaletteIndex()
		self._paletteOpen = true
		self._paletteSelectedIndex = 0

		local gui = self.Gui
		local theme = self.Theme
		local ts = game:GetService("TweenService")
		local uis = game:GetService("UserInputService")


		self._paletteOverlay = U.Create("ImageButton", {
			Name = "PaletteOverlay",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 100000,
			AutoButtonColor = false,
			Parent = gui,
			Visible = false,
		})
		self._paletteOverlay.MouseButton1Click:Connect(function()
			self:CloseCommandPalette()
		end)


		local palW, palH = self:_modalSize(380, 310, 180, 180)
		self._paletteFrame = U.Create("Frame", {
			Name = "CommandPalette",
			Size = UDim2.fromOffset(palW, palH),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = theme.Background,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 100001,
			Parent = gui,
			Visible = false,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self._paletteFrame })
		U.Create("UIStroke", { Color = theme.Outline, Thickness = 1, Transparency = 0.15, Parent = self._paletteFrame })


		self._paletteSearchBox = U.Create("TextBox", {
			Name = "SearchBox",
			Size = UDim2.new(1, -16, 0, 34),
			Position = UDim2.fromOffset(8, 8),
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 0,
			Text = "",
			PlaceholderText = "Search tabs and components...",
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			PlaceholderColor3 = theme.TextMuted,
			ClearTextOnFocus = false,
			ZIndex = 100002,
			Parent = self._paletteFrame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self._paletteSearchBox })


		self._paletteResults = U.Create("ScrollingFrame", {
			Name = "Results",
			Size = UDim2.new(1, -16, 1, -(34 + 12)),
			Position = UDim2.fromOffset(8, 34 + 8 + 4),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = theme.ScrollBar,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ZIndex = 100002,
			Parent = self._paletteFrame,
		})
		local resLayout = U.Create("UIListLayout", {
			Padding = UDim.new(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = self._paletteResults,
		})
		resLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if self._paletteResults then
				self._paletteResults.CanvasSize = UDim2.new(0, 0, 0, resLayout.AbsoluteContentSize.Y)
			end
		end)


		self._paletteEmpty = U.Create("TextLabel", {
			Name = "EmptyState",
			Size = UDim2.new(1, -16, 0, 60),
			Position = UDim2.fromOffset(8, 34 + 8 + 4),
			BackgroundTransparency = 1,
			Text = "No results found",
			Font = theme.Font,
			TextSize = theme.FontSizeSmall,
			TextColor3 = theme.TextMuted,
			TextXAlignment = Enum.TextXAlignment.Center,
			ZIndex = 100002,
			Visible = false,
			Parent = self._paletteFrame,
		})


		self:_filterPaletteResults("")


		local conns = {}
		table.insert(
			conns,
			self._paletteSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
				self:_filterPaletteResults(self._paletteSearchBox.Text)
			end)
		)
		table.insert(
			conns,
			uis.InputBegan:Connect(function(pi, pgpe)
				if not self._paletteOpen then
					return
				end
				if pi.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end
				local pk = pi.KeyCode
				if pk == Enum.KeyCode.Escape then
					self:CloseCommandPalette()
				elseif pk == Enum.KeyCode.Up then
					self:_paletteSelectPrev()
				elseif pk == Enum.KeyCode.Down then
					self:_paletteSelectNext()
				elseif pk == Enum.KeyCode.Return then
					self:_paletteActivateSelected()
				end
			end)
		)
		self._paletteConns = conns


		self._paletteOverlay.Visible = true
		self._paletteFrame.Visible = true


		self:_transition(self._paletteOverlay, 0.15, { BackgroundTransparency = 0.45 })
		self._paletteFrame.Size = UDim2.fromOffset(0, 0)
		self:_transition(self._paletteFrame, 0.2, { Size = UDim2.fromOffset(palW, palH) })


		task.spawn(function()
			task.wait(0.1)
			if self._paletteSearchBox then
				self._paletteSearchBox:CaptureFocus()
			end
		end)
		return true
	end

	function Menu:CloseCommandPalette()
		if not self._paletteOpen then
			return
		end
		self._paletteOpen = false

		if self._paletteConns then
			for _, c in ipairs(self._paletteConns) do
				pcall(function()
					c:Disconnect()
				end)
			end
			self._paletteConns = {}
		end
		self._paletteResultButtons = {}
		self._paletteFilteredResults = {}
		self._paletteSelectedIndex = 0

		if self._paletteOverlay then
			self._paletteOverlay:Destroy()
			self._paletteOverlay = nil
		end
		if self._paletteFrame then
			self._paletteFrame:Destroy()
			self._paletteFrame = nil
		end
		self._paletteSearchBox = nil
		self._paletteResults = nil
		self._paletteEmpty = nil
	end

	function Menu:ToggleCommandPalette()
		if self._paletteOpen then
			self:CloseCommandPalette()
		else
			self:OpenCommandPalette()
		end
	end

	local FyyUI = { Version = LIBRARY_VERSION, Theme = Theme }

	function FyyUI.SetIconModule(mod)
		IconModule = mod
	end

	function FyyUI.LoadRemoteIconModule(url)
		return loadRemoteIconModule(url)
	end
	function FyyUI.GetIconModule()
		return IconModule
	end

	function FyyUI.Menu(options)
		options = options or {}
		local name = options.Theme or "Dark"
		local theme = type(name) == "string" and Theme[name] or name
		if not theme then
			theme = Theme.Dark
		end
		if type(theme) == "table" then
			theme = Theme:Override(Theme.Dark, theme)
		end
		if options.ColorOverride then
			theme = Theme:Override(theme, options.ColorOverride)
		end
		return Menu.new(options, theme)
	end

	return FyyUI
end)()
