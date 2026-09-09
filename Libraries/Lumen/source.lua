--[=[
           _,    _   _    ,_
      .o888P     Y8o8Y     Y888o.
     d88888      88888      88888b
    d888888b_  _d88888b_  _d888888b
    8888888888888888888888888888888
    8888888888888888888888888888888
    YJGS8P"Y888P"Y888P"Y888P"Y8888P
     Y888   '8'   Y8P   '8'   888Y
      '8o          V          o8'
        `                     `

    example usage:

    local Lumen = require(script.Parent.Lumen)

    local Window = Lumen:Window({ Title = "Lumen"; Footer = ".gg/robloxuis" })

    --@ pages fill the sidebar; the first one added opens automatically
    local Combat = Window:Page({ Icon = 89784578844770 })
    local Settings = Window:Page({ Icon = 89784578844770 })

    --@ a sub page is a full page reached through a pill button in the header row.
    --@ once a page has sub pages, they own its content area, so don't mix
    --@ Page:Section and Page:SubPage on the same page
    local Aimbot = Combat:SubPage({ Name = "Aimbot" })
    local AntiAim = Combat:SubPage({ Name = "Anti-Aim" })

    --@ sections stack in the Left or Right column of their page or sub page
    local Section = Aimbot:Section({ Name = "Main"; Side = "Left"; Icon = 107651426482528 })

    --@ a label is a row; toggles, keybinds and colorpickers attach onto it
    local Label = Section:Label({ Text = "Enable aimbot" })

    Label:Toggle({ State = false; Callback = function(State) print(State) end })
    Label:Keybind({ Key = Enum.KeyCode.RightShift; Type = "Hold"; Callback = function(State) print(State) end })
    Label:Colorpicker({ Color = Color3.fromRGB(255, 0, 0); Transparency = 0; Callback = function(Color, Transparency) print(Color, Transparency) end })

    local Slider = Section:Slider({ Name = "Field of view"; Suffix = "°"; Value = 67; Min = 1; Max = 120; Increment = 1; Callback = print })
    local Dropdown = Section:Dropdown({ Name = "Target part"; Options = { "Head", "Torso", "Random" }; Value = "Head"; Callback = print })
    local Modes = Section:Dropdown({ Name = "ESP"; Multi = true; Options = { "Box", "Name", "Health" }; Value = { "Box" }; Callback = print })
    local Input = Section:Input({ Name = "Discord"; Value = "discord.gg/robloxuis"; Placeholder = "invite link"; Callback = print })

    --@ everything exposes a setter for changing it from code
    Slider.Set(90)
    Dropdown.Set("Torso")
    Modes.Set({ "Box", "Health" })
    Dropdown.UpdateOptions({ "Head", "Torso", "Limbs" })
    Input.Set("discord.gg/lumen")
    AntiAim.Open()
--]=]

--@ abbreviations
local CSK = ColorSequenceKeypoint.new
local NSK = NumberSequenceKeypoint.new
local BSP = Enum.BorderStrokePosition
local ASM = Enum.ApplyStrokeMode
local UFA = Enum.UIFlexAlignment
local TXA = Enum.TextXAlignment
local TYA = Enum.TextYAlignment
local UIT = Enum.UserInputType
local ETT = Enum.TextTruncate
local UFO = UDim2.fromOffset
local UFS = UDim2.fromScale
local EGS = Enum.GuiState
local EKC = Enum.KeyCode
local TCC = table.concat
local TIS = table.insert
local TR = table.remove
local TU = table.unpack
local TC = table.clone
local TF = table.find
local MC = math.clamp
local MR = math.round
local MF = math.floor
local MM = math.min
local MH = math.huge
local ED = Enum.EasingDirection
local AS = Enum.AutomaticSize
local FD = Enum.FillDirection
local ES = Enum.EasingStyle
local FW = Enum.FontWeight
local SO = Enum.SortOrder
local FS = Enum.FontStyle
local EF = Enum.Font
local TI = TweenInfo.new
local SF = string.format
local V2 = Vector2.new
local UD2 = UDim2.new
local UD = UDim.new
local FN = Font.new
local RGB = Color3.fromRGB
local HSV = Color3.fromHSV
local CS = ColorSequence.new
local NS = NumberSequence.new
local SCT = Enum.SizeConstraint
local SCL = Enum.ScaleType
local ZIB = Enum.ZIndexBehavior
local AT = Enum.AutomaticSize
local HFA = Enum.HorizontalAlignment
local VFA = Enum.VerticalAlignment
local LC = Enum.LineJoinMode
local SBD = Enum.ScrollingDirection
local SBA = Enum.ScrollBarInset


--@ beginning
local Library = {
	Elements = {};
	SubElements = {};

	Flags = {};
	Threads = {};

	Searchable = {};
	Sections = {};
}

Library.__index = Library
Library.Elements.__index = Library.Elements
Library.SubElements.__index = Library.SubElements

--@ the screengui sorts siblings by ZIndex, so popups need to outrank the window frame
local PopupZ = 20

export type Library = setmetatable<{}, typeof(Library)>

--@ dependencies
cloneref = cloneref or function(...) return ... end
gethui = gethui or function(...) return cloneref(game:GetService("CoreGui")) end

local Services = {
	GetService = function(self, service)
		return cloneref(game:GetService(service))
	end,
} :: ServiceProvider

local UserInputService = Services:GetService("UserInputService")
local PlayerService = Services:GetService("Players")
local RunService = Services:GetService("RunService")
local TweenService = Services:GetService("TweenService")

local Client = PlayerService.LocalPlayer

local Keys = {
	["Unknown"]           = "Unknown",
	["Backspace"]         = "Back",
	["Tab"]               = "Tab",
	["Clear"]             = "Clear",
	["Return"]            = "Return",
	["Pause"]             = "Pause",
	["Escape"]            = "Escape",
	["Space"]             = "Space",
	["QuotedDouble"]      = '"',
	["Hash"]              = "#",
	["Dollar"]            = "$",
	["Percent"]           = "%",
	["Ampersand"]         = "&",
	["Quote"]             = "'",
	["LeftParenthesis"]   = "(",
	["RightParenthesis"]  = " )",
	["Asterisk"]          = "*",
	["Plus"]              = "+",
	["Comma"]             = ",",
	["Minus"]             = "-",
	["Period"]            = ".",
	["Slash"]             = "`",
	["Three"]             = "3",
	["Seven"]             = "7",
	["Eight"]             = "8",
	["Colon"]             = ":",
	["Semicolon"]         = ";",
	["LessThan"]          = "<",
	["GreaterThan"]       = ">",
	["Question"]          = "?",
	["Equals"]            = "=",
	["At"]                = "@",
	["LeftBracket"]       = "LeftBracket",
	["RightBracket"]      = "RightBracked",
	["BackSlash"]         = "BackSlash",
	["Caret"]             = "^",
	["Underscore"]        = "_",
	["Backquote"]         = "`",
	["LeftCurly"]         = "{",
	["Pipe"]              = "|",
	["RightCurly"]        = "}",
	["Tilde"]             = "~",
	["Delete"]            = "Delete",
	["End"]               = "End",
	["KeypadZero"]        = "Keypad0",
	["KeypadOne"]         = "Keypad1",
	["KeypadTwo"]         = "Keypad2",
	["KeypadThree"]       = "Keypad3",
	["KeypadFour"]        = "Keypad4",
	["KeypadFive"]        = "Keypad5",
	["KeypadSix"]         = "Keypad6",
	["KeypadSeven"]       = "Keypad7",
	["KeypadEight"]       = "Keypad8",
	["KeypadNine"]        = "Keypad9",
	["KeypadPeriod"]      = "KeypadP",
	["KeypadDivide"]      = "KeypadD",
	["KeypadMultiply"]    = "KeypadM",
	["KeypadMinus"]       = "KeypadM",
	["KeypadPlus"]        = "KeypadP",
	["KeypadEnter"]       = "KeypadE",
	["KeypadEquals"]      = "KeypadE",
	["Insert"]            = "Insert",
	["Home"]              = "Home",
	["PageUp"]            = "PageUp",
	["PageDown"]          = "PageDown",
	["RightShift"]        = "RightShift",
	["LeftShift"]         = "LeftShift",
	["RightControl"]      = "RightControl",
	["LeftControl"]       = "LeftControl",
	["LeftAlt"]           = "LeftAlt",
	["RightAlt"]          = "RightAlt"
}

--@ functions
local function Add(class: string, propertyTable: { [string]: any }?): Instance
	local _Instance = Instance.new(class)

	if propertyTable then
		for Property, Value in propertyTable do
			local Success, Error = pcall(function()
				_Instance[Property] = Value
			end)

			if not Success then
				local Line = debug.info(2, "l")
				warn(`error on line {Line}: {Error}`)
			end
		end
	end

	return _Instance
end

local function Overwrite<T>(to_overwrite: T, overwrite_with: {}): T
	for i, v in pairs(overwrite_with) do
		if v == to_overwrite[i] then
			continue
		end
		to_overwrite[i] = type(v) == "table" and Overwrite(to_overwrite[i] or {}, v) or v
	end

	return to_overwrite
end

local function BindDrag(Object: GuiObject, Handle: GuiObject?)
	Handle = Handle or Object

	local Dragging = false
	local DragStart: Vector3
	local StartPosition: UDim2

	Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType ~= UIT.MouseButton1 and Input.UserInputType ~= UIT.Touch then
			return
		end

		Dragging = true
		DragStart = Input.Position
		StartPosition = Object.Position

		local Connection
		Connection = Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Dragging = false
				Connection:Disconnect()
			end
		end)
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if not Dragging or (Input.UserInputType ~= UIT.MouseMovement and Input.UserInputType ~= UIT.Touch) then
			return
		end

		local Delta = Input.Position - DragStart
		Object.Position = UD2(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
	end)
end

local function BindSlider(Object: GuiObject, Callback: (Alpha: Vector2) -> ())
	local Sliding = false

	local function Update(Input: InputObject)
		local Origin = Object.AbsolutePosition
		local Size = Object.AbsoluteSize

		Callback(V2(
			Size.X > 0 and MC((Input.Position.X - Origin.X) / Size.X, 0, 1) or 0,
			Size.Y > 0 and MC((Input.Position.Y - Origin.Y) / Size.Y, 0, 1) or 0
		))
	end

	Object.InputBegan:Connect(function(Input)
		if Input.UserInputType ~= UIT.MouseButton1 and Input.UserInputType ~= UIT.Touch then
			return
		end

		Sliding = true
		Update(Input)

		local Connection
		Connection = Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Sliding = false
				Connection:Disconnect()
			end
		end)
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if not Sliding or (Input.UserInputType ~= UIT.MouseMovement and Input.UserInputType ~= UIT.Touch) then
			return
		end

		Update(Input)
	end)
end

local function Tween(Object: Instance, propertyTable: {}, Duration: number?, Style: Enum.EasingStyle?, Direction: Enum.EasingDirection?)
	local Tween = TweenService:Create(Object, TI(Duration or 0.2, Style or ES.Quad, Direction or ED.Out), propertyTable)
	Tween:Play()

	return Tween
end

local function ClaimPopup(Element: {})
	if Library.OpenPopup and Library.OpenPopup ~= Element then
		Library.OpenPopup.Close()
	end

	Library.OpenPopup = Element
end

local function ReleasePopup(Element: {})
	if Library.OpenPopup == Element then
		Library.OpenPopup = nil
	end
end

--@ section
--@ built against whichever container holds the Left and Right columns, so a page and a
--@ sub page can both hand out sections without duplicating any of this
local function SectionBuilder(Container: Frame)
	return function(self: Library, propertyTable: {})
		local Section = Overwrite({
			Name = "",
			Icon = 107651426482528,
			Side = "Left",
		}, propertyTable or {})
		setmetatable(Section, { __index = Library.Elements })

		local SectionFrame = Add("Frame", { Parent = Container[Section.Side]; Name = "Section"; AutomaticSize = AS.Y; BackgroundColor3 = RGB(15, 14, 15); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 0); }) :: Frame
		local Header = Add("Frame", { Parent = SectionFrame; Name = "Header"; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(1, 0, 0, 35); }) :: Frame
		local Elements = Add("Frame", { Parent = SectionFrame; Name = "Elements"; AutomaticSize = AS.Y; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(0, 35); Size = UFS(1, 0); }) :: Frame
		Add("UICorner", { Parent = SectionFrame; CornerRadius = UD(0, 5); })
		Add("UICorner", { Parent = Header; BottomLeftRadius = UD(0, 0); BottomRightRadius = UD(0, 0); TopLeftRadius = UD(0, 5); TopRightRadius = UD(0, 5); })
		Add("ImageLabel", { Parent = Header; Name = "Icon"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://" .. tostring(Section.Icon); Position = UFS(0, 0.5); Size = UFO(16, 16); })
		Add("UIListLayout", { Parent = Header; FillDirection = FD.Horizontal; Padding = UD(0, 5); SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; })
		Add("UIPadding", { Parent = Header; PaddingLeft = UD(0, 10); })
		Add("TextLabel", { Parent = Header; Name = "Title"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); LayoutOrder = 1; Text = Section.Name; TextColor3 = RGB(255, 255, 255); TextSize = 14; })
		Add("UIStroke", { Parent = SectionFrame; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
		Add("UIPadding", { Parent = Elements; PaddingBottom = UD(0, 10); PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); PaddingTop = UD(0, 10); })
		Add("UIListLayout", { Parent = Elements; Padding = UD(0, 10); SortOrder = SO.LayoutOrder; })

		Section.Content = Elements
		Section.Frame = SectionFrame

		TIS(Library.Sections, Section)
		return Section
	end
end

--@ page content
--@ shared by Window.Page and Page.SubPage. A sub page is built by this exact function, just
--@ parented to its owning page's frame instead of the window's Pages frame, and registered
--@ into that page's own registry instead of Window.Pages - mechanically it IS a page, only
--@ reachable through a different button. OnOpen/OnClose let the caller layer trigger-button
--@ styling on top without duplicating the frame, slide animation, or mutual exclusion below.
local function PageContent(Entry: {}, Container: Frame, Registry: {}, OnOpen: (() -> ())?, OnClose: (() -> ())?)
	local ContentFrame = Add("Frame", { Parent = Container; Name = "PageFrame"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(0, 0, 0, 12); Size = UFS(1, 1); Visible = false; }) :: Frame
	local Left = Add("Frame", { Parent = ContentFrame; Name = "Left"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(0.5, -6, 1, 0); }) :: Frame
	local Right = Add("Frame", { Parent = ContentFrame; Name = "Right"; AnchorPoint = V2(1, 0); BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(1, 0); Size = UD2(0.5, -6, 1, 0); }) :: Frame
	Add("UIListLayout", { Parent = Left; Padding = UD(0, 12); SortOrder = SO.LayoutOrder; })
	Add("UIListLayout", { Parent = Right; Padding = UD(0, 12); SortOrder = SO.LayoutOrder; })

	Entry.Frame = ContentFrame
	Entry.Section = SectionBuilder(ContentFrame)

	--@ tracked as a flag rather than read off ContentFrame.Visible, because a page with an
	--@ active sub page counts as open while its own frame stays hidden
	Entry.IsOpen = false

	Entry.Open = function()
		--@ reclicking the open tab shouldn't replay the slide or restyle anything
		if Entry.IsOpen then
			return
		end

		Entry.IsOpen = true

		for _, Other in Registry do
			if Other ~= Entry and Other.IsOpen then
				Other.Close()
			end
		end

		ContentFrame.Position = UD2(0, 0, 0, 12)
		ContentFrame.Visible = true
		Tween(ContentFrame, { Position = UD2(0, 0, 0, 0) }, 0.3, ES.Quint)

		if OnOpen then
			OnOpen()
		end
	end

	Entry.Close = function()
		Entry.IsOpen = false
		ContentFrame.Visible = false

		if OnClose then
			OnClose()
		end
	end

	TIS(Registry, Entry)
	return Entry
end

--@ elements
Library.Elements.Label = function(self: Library, propertyTable: {})
	local Label = Overwrite({
		Text = "",
	}, propertyTable or {})
	setmetatable(Label, { __index = Library.SubElements })
	
	local LabelFrame = Add("Frame", { Parent = self.Content; Name = "LabelFrame";BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(1, 0, 0, 14); }) :: Frame 
	local LeftContent = Add("Frame", { Parent = LabelFrame; Name = "LeftContent"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; }) :: Frame 
	local RightContent = Add("Frame", { Parent = LabelFrame; Name = "RightContent"; AnchorPoint = V2(1, 0); AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(1, 0); }) :: Frame 
	Add("TextLabel", { LayoutOrder = 99; Parent = LeftContent; Name = "Label"; AnchorPoint = V2(0, 0.5); AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Position = UD2(0, 38, 0.5, 0); Size = UFO(0, 9); Text = Label.Text; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.2; }) 
	Add("UIListLayout", { Parent = LeftContent; FillDirection = FD.Horizontal; Padding = UD(0, 10); SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; }) 
	Add("UIListLayout", { Parent = RightContent; FillDirection = FD.Horizontal; HorizontalAlignment = HFA.Right; Padding = UD(0, 5); SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; }) 

	Label.RightContent = RightContent
	Label.LeftContent = LeftContent

	TIS(Library.Searchable, { Frame = LabelFrame; Text = Label.Text; Section = self })
	return Label
end

Library.Elements.Slider = function(self: Library, propertyTable: {})
	local Slider = Overwrite({
		Name = "FOV Radius",
		Suffix = "°",
		Value = 1,
		Increment = 0.1,
		Max = 1,
		Min = 0,
		Callback = print
	}, propertyTable or {})

	local Decimals = MM(#(tostring(Slider.Increment):match("%.(%d+)") or ""), 4)

	local SliderFrame = Add("Frame", { Parent = self.Content; Name = "SliderFrame"; AutomaticSize = AS.Y; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 0); }) :: Frame
	local Button = Add("TextButton", { Parent = SliderFrame; Name = "Button"; AutoButtonColor = false; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Position = UFO(0, 18); Size = UD2(1, 0, 0, 12); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
	local Overlay = Add("Frame", { Parent = Button; Name = "Overlay"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(0, 0, 1, 0); }) :: Frame
	local Circle = Add("Frame", { Parent = Button; Name = "Circle"; AnchorPoint = V2(1, 0.5); BackgroundColor3 = RGB(0, 0, 0); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(1, -3, 0.5, 0); Size = UFO(8, 8); }) :: Frame
	Add("TextLabel", { Parent = SliderFrame; Name = "Title"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UFO(0, 9); Text = Slider.Name; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.2; })
	local Amount = Add("TextLabel", { Parent = SliderFrame; Name = "Amount"; AnchorPoint = V2(1, 0); AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Position = UFS(1, 0); Size = UFO(0, 9); Text = ""; TextColor3 = RGB(255, 255, 255); TextSize = 13; }) :: TextLabel
	Add("UICorner", { Parent = Button; CornerRadius = UD(0, 5); })
	Add("UIGradient", { Parent = Overlay; Color = CS{ CSK(0, RGB(78, 88, 129)), CSK(1, RGB(138, 156, 229)) }; Rotation = -90; })
	Add("UICorner", { Parent = Overlay; CornerRadius = UD(0, 5); })
	Add("UICorner", { Parent = Circle; CornerRadius = UD(1, 0); })

	--@ slider state
	Slider.Set = function(Value: number)
		Value = MC(MR(Value / Slider.Increment) * Slider.Increment, Slider.Min, Slider.Max)
		Slider.Value = tonumber(SF(`%.{Decimals}f`, Value))

		local Range = Slider.Max - Slider.Min
		local Alpha = Range > 0 and (Slider.Value - Slider.Min) / Range or 0
		local Fade = MC(1 - Alpha / 0.05, 0, 1)

		Tween(Overlay, { Size = UD2(Alpha, 0, 1, 0); BackgroundTransparency = Fade }, 0.08)
		Tween(Circle, { Position = UD2(Alpha, -3, 0.5, 0); BackgroundTransparency = Fade }, 0.08)

		Amount.Text = SF(`%.{Decimals}f`, Slider.Value) .. Slider.Suffix
		Slider.Callback(Slider.Value)
	end

	BindSlider(Button, function(Alpha)
		Slider.Set(Slider.Min + (Slider.Max - Slider.Min) * Alpha.X)
	end)

	TIS(Library.Searchable, { Frame = SliderFrame; Text = Slider.Name; Section = self })

	Slider.Set(Slider.Value)
	return Slider
end

Library.Elements.Dropdown = function(self: Library, propertyTable: {})
	local Dropdown = Overwrite({
		Name = "",
		Options = {},
		Value = "",
		Multi = false,
		Callback = print,
	}, propertyTable or {})

	--@ the root is the button that swallows clicks here, rather than a child catcher like the
	--@ other popups use. A child would be laid out by the UIListLayout below, and a scale
	--@ sized list item feeds its own height back into the list's AutomaticSize
	local OptionList = Add("TextButton", { Parent = Library._Instance; Name = "Options"; AutoButtonColor = false; AutomaticSize = AS.Y; BackgroundColor3 = RGB(15, 14, 15); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(0.3761225640773773, 0.42204996943473816); Size = UFO(253, 0); Text = ""; Visible = false; ZIndex = PopupZ; }) :: TextButton
	Add("UICorner", { Parent = OptionList; CornerRadius = UD(0, 5); })
	Add("UIStroke", { Parent = OptionList; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
	Add("UIPadding", { Parent = OptionList; })
	Add("UIShadow", { Parent = OptionList; BlurRadius = UD(0, 20); Spread = UFO(5, 5); Transparency = 0.65; })
	Add("UIListLayout", { Parent = OptionList; SortOrder = SO.LayoutOrder; })

	local ButtonFrame = Add("Frame", { Parent = self.Content; Name = "ButtonFrame"; Active = true; AutomaticSize = AS.Y; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 0); }) :: Frame
	local InputFrame = Add("Frame", { Parent = ButtonFrame; Name = "InputFrame"; Active = true; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(0, 18); Selectable = true; Size = UD2(1, 0, 0, 22); }) :: Frame
	Add("TextLabel", { Parent = ButtonFrame; Name = "Title"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UFO(0, 9); Text = Dropdown.Name; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.2; })
	Add("UICorner", { Parent = InputFrame; CornerRadius = UD(0, 5); })
	Add("UIPadding", { Parent = InputFrame; PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); })
	local Icon = Add("ImageLabel", { Parent = InputFrame; Name = "Icon"; AnchorPoint = V2(1, 0.5); BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://95865107607162"; ImageTransparency = 0.2; Position = UFS(1, 0.5); ResampleMode = Enum.ResamplerMode.Pixelated; ScaleType = SCL.Fit; Size = UFO(14, 14); }) :: ImageLabel
	local InputText = Add("TextButton", { Parent = InputFrame; Name = "Input"; BackgroundColor3 = RGB(20, 20, 21); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UD2(1, -24, 1, 0); Text = ""; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.2; TextTruncate = ETT.SplitWord; TextXAlignment = TXA.Left; }) :: TextButton

	--@ dropdown state
	local Buttons = {}

	local function IsSelected(Option: string): boolean
		if Dropdown.Multi then
			return TF(Dropdown.Value, Option) ~= nil
		end

		return Dropdown.Value == Option
	end

	local function Highlight()
		for _, Button in Buttons do
			local Selected = IsSelected(Button.Text)
			Tween(Button, { BackgroundTransparency = Selected and 0 or 1; TextTransparency = Selected and 0.2 or 0.5 }, 0.1)
		end
	end

	--@ a multi dropdown toggles the entry and stays open; a single one commits and closes
	local function Choose(Option: string)
		if not Dropdown.Multi then
			Dropdown.Set(Option)
			Dropdown.Open(false)
			return
		end

		--@ cloned so the caller's table is never mutated behind its back
		local Selected = TC(Dropdown.Value)
		local Index = TF(Selected, Option)

		if Index then
			TR(Selected, Index)
		else
			TIS(Selected, Option)
		end

		Dropdown.Set(Selected)
	end

	local function Build()
		for _, Button in Buttons do
			Button:Destroy()
		end

		table.clear(Buttons)

		for Index, Option in Dropdown.Options do
			local Button = Add("TextButton", { Parent = OptionList; Name = Option; AutoButtonColor = false; BackgroundColor3 = RGB(20, 20, 21); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); LayoutOrder = Index; Size = UD2(1, 0, 0, 22); Text = Option; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.5; TextWrapped = true; TextXAlignment = TXA.Left; }) :: TextButton
			Add("UIPadding", { Parent = Button; PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); })

			--@ UICorner doesn't clip children, so the end options have to carry the list's
			--@ rounding themselves or their square corners spill past it. A lone option is
			--@ both first and last, so it rounds all four.
			local First = Index == 1
			local Last = Index == #Dropdown.Options

			Add("UICorner", { Parent = Button;
				TopLeftRadius = First and UD(0, 5) or UD(0, 0);
				TopRightRadius = First and UD(0, 5) or UD(0, 0);
				BottomLeftRadius = Last and UD(0, 5) or UD(0, 0);
				BottomRightRadius = Last and UD(0, 5) or UD(0, 0);
			})

			Button.Activated:Connect(function()
				Choose(Option)
			end)

			TIS(Buttons, Button)
		end

		Highlight()
	end

	Dropdown.Set = function(Value: string | { string })
		Dropdown.Value = Value

		if Dropdown.Multi then
			InputText.Text = #Value > 0 and TCC(Value, ", ") or "None"
		else
			InputText.Text = Value
		end

		Highlight()
		Dropdown.Callback(Value)
	end

	Dropdown.UpdateOptions = function(NewOptions: { string })
		Dropdown.Options = NewOptions
		Build()

		--@ selections that no longer exist in the list have to be dropped
		if Dropdown.Multi then
			local Kept = {}

			for _, Option in Dropdown.Value do
				if TF(NewOptions, Option) then
					TIS(Kept, Option)
				end
			end

			Dropdown.Set(Kept)
		elseif not TF(NewOptions, Dropdown.Value) then
			Dropdown.Set(NewOptions[1] or "")
		end
	end

	Dropdown.Close = function()
		Dropdown.Open(false)
	end

	Dropdown.Open = function(State: boolean?)
		if State == nil then
			State = not OptionList.Visible
		end

		if State then
			ClaimPopup(Dropdown)

			--@ the list tracks the control's width instead of the mockup's fixed 253
			OptionList.Size = UFO(InputFrame.AbsoluteSize.X, 0)

			local Target = UFO(
				InputFrame.AbsolutePosition.X,
				InputFrame.AbsolutePosition.Y + InputFrame.AbsoluteSize.Y + 4
			)

			OptionList.Position = Target - UFO(0, 10)
			OptionList.Visible = true
			Tween(OptionList, { Position = Target }, 0.25, ES.Quint)
		else
			OptionList.Visible = false
			ReleasePopup(Dropdown)
		end

		Tween(Icon, { Rotation = State and 180 or 0 }, 0.2)
	end

	--@ InputText is a button and InputFrame is Active, so both sink the click instead of
	--@ letting it reach ButtonFrame; every layer of the row has to open the list itself
	local LastToggle = 0

	local function Activate()
		--@ in case one click ever registers on more than one layer
		if os.clock() - LastToggle < 0.1 then
			return
		end

		LastToggle = os.clock()
		Dropdown.Open()
	end

	for _, Object in { ButtonFrame, InputFrame } do
		Object.InputBegan:Connect(function(Input)
			if Input.UserInputType ~= UIT.MouseButton1 and Input.UserInputType ~= UIT.Touch then
				return
			end

			Activate()
		end)
	end

	InputText.Activated:Connect(Activate)

	TIS(Library.Searchable, { Frame = ButtonFrame; Text = Dropdown.Name; Section = self })

	Build()

	if Dropdown.Multi then
		--@ nothing is preselected, unlike a single dropdown which always holds a value
		Dropdown.Set(type(Dropdown.Value) == "table" and Dropdown.Value or {})
	else
		Dropdown.Set(Dropdown.Value ~= "" and Dropdown.Value or Dropdown.Options[1] or "")
	end

	return Dropdown
end

Library.Elements.Input = function(self: Library, propertyTable: {})
	local Input = Overwrite({
		Name = "",
		Value = "",
		Placeholder = "",
		Callback = print,
	}, propertyTable or {})

	local TextBox = Add("Frame", { Parent = self.Content; Name = "TextBox"; AutomaticSize = AS.Y; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 0); }) :: Frame
	local InputFrame = Add("Frame", { Parent = TextBox; Name = "InputFrame"; Active = true; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(0, 18); Selectable = true; Size = UD2(1, 0, 0, 22); }) :: Frame
	Add("TextLabel", { Parent = TextBox; Name = "Title"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UFO(0, 9); Text = Input.Name; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.2; })
	local Box = Add("TextBox", { Parent = InputFrame; Name = "Input"; BackgroundColor3 = RGB(20, 20, 21); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; ClearTextOnFocus = false; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); PlaceholderColor3 = RGB(255, 255, 255); PlaceholderText = Input.Placeholder; Size = UD2(1, -24, 1, 0); Text = Input.Value; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.2; TextTruncate = ETT.SplitWord; TextXAlignment = TXA.Left; }) :: TextBox
	Add("ImageLabel", { Parent = InputFrame; Name = "Icon"; AnchorPoint = V2(1, 0.5); BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://96386750273341"; ImageTransparency = 0.2; Position = UFS(1, 0.5); ResampleMode = Enum.ResamplerMode.Pixelated; Size = UFO(14, 14); })
	Add("UIPadding", { Parent = InputFrame; PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); })
	Add("UICorner", { Parent = InputFrame; CornerRadius = UD(0, 5); })

	Input.Set = function(Value: string)
		Input.Value = Value
		Box.Text = Value

		Input.Callback(Value)
	end

	--@ commits on enter or on clicking away rather than per keystroke
	Box.FocusLost:Connect(function()
		Input.Set(Box.Text)
	end)

	--@ the icon and the padding are part of the field you'd expect to click into, and
	--@ InputFrame is Active so it swallows those clicks before the box ever sees them
	InputFrame.InputBegan:Connect(function(InputObject)
		if InputObject.UserInputType ~= UIT.MouseButton1 and InputObject.UserInputType ~= UIT.Touch then
			return
		end

		Box:CaptureFocus()
	end)

	TIS(Library.Searchable, { Frame = TextBox; Text = Input.Name; Section = self })
	return Input
end

--@ sub elements
Library.SubElements.Toggle = function(self: Library, propertyTable: {})
	local Toggle = Overwrite({
		State = false,
		Callback = print
	}, propertyTable or {})
	
	local Button = Add("TextButton", { Parent = self.LeftContent; Name = "Toggle"; AutoButtonColor = false; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFO(28, 14); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton 
	local Indicator = Add("Frame", { Parent = Button; Name = "Indicator"; AnchorPoint = V2(1, 0.5); BackgroundColor3 = RGB(0, 0, 0); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(1, -3, 0.5, 0); Size = UFO(10, 10); ZIndex = 2; }) :: Frame 
	local Overlay = Add("Frame", { Parent = Button; Name = "Overlay"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 1); }) :: Frame 
	Add("UICorner", { Parent = Button; CornerRadius = UD(0, 6); }) 
	Add("UICorner", { Parent = Indicator; CornerRadius = UD(1, 0); }) 
	Add("UICorner", { Parent = Overlay; CornerRadius = UD(0, 6); }) 
	Add("UIGradient", { Parent = Overlay; Color = CS{ CSK(0, RGB(78, 88, 129)), CSK(1, RGB(138, 156, 229)) }; Rotation = -90; }) 

	Toggle.Set = function(state: boolean?)
		state = state or not Toggle.State
		Toggle.State = state

		Tween(Overlay, { BackgroundTransparency = state and 0 or 1 }, 0.1)
		Tween(Indicator, { Position = state and UD2(1, -3, 0.5, 0) or UD2(0, 3, 0.5, 0), AnchorPoint = state and V2(1, 0.5) or V2(0, 0.5)}, 0.1)

		Toggle.Callback(state)
	end

	Button.Activated:Connect(function()
		Toggle.Set()
	end)

	Toggle.Set(Toggle.State)
	return Toggle
end

Library.SubElements.Keybind = function(self: Library, propertyTable: {})
	local Keybind = Overwrite({
		Title = "",
		State = false,
		Type = "Toggle",
		Callback = print,
	}, propertyTable or {})

	local Settings = Add("ImageButton", { Parent = self.RightContent; Name = "Settings"; AutoButtonColor = false; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://132030186847627"; ImageTransparency = 0.5; ResampleMode = Enum.ResamplerMode.Pixelated; Size = UFO(15, 15); }) :: ImageButton

	local Popup = Add("Frame", { Parent = Library._Instance; Name = "Popup"; Active = true; BackgroundColor3 = RGB(9, 8, 8); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(0.3753760755062103, 0.30920326709747314); Size = UFO(180, 119); Visible = false; ZIndex = PopupZ; }) :: Frame
	--@ buttons are the only thing that reliably swallows a click. Created first so it sits
	--@ under the contents, and scale sized so it stays out of the AutomaticSize maths
	Add("TextButton", { Parent = Popup; Name = "Catcher"; AutoButtonColor = false; BackgroundTransparency = 1; BorderSizePixel = 0; Size = UFS(1, 1); Text = ""; })
	local Header = Add("Frame", { Parent = Popup; Name = "Header"; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(1, 0, 0, 35); }) :: Frame
	local Page = Add("Frame", { Parent = Popup; Name = "Page"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(0, 35); Size = UD2(1, 0, 1, -35); }) :: Frame
	local KeyButton = Add("TextButton", { Parent = Page; Name = "KeyButton"; AutoButtonColor = false; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UD2(1, 0, 0, 25); Text = ""; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.5; }) :: TextButton
	local Options = Add("Frame", { Parent = Page; Name = "Options"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(0, 35); Size = UD2(1, 0, 1, -35); }) :: Frame
	local HoldButton = Add("TextButton", { Parent = Options; Name = "HoldButton"; AutoButtonColor = false; AutomaticSize = AS.X; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFS(0, 1); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
	local ToggleButton = Add("TextButton", { Parent = Options; Name = "ToggleButton"; AutoButtonColor = false; AutomaticSize = AS.X; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFS(0, 1); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
	Add("UICorner", { Parent = Popup; CornerRadius = UD(0, 5); })
	Add("UIStroke", { Parent = Popup; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
	Add("UIShadow", { Parent = Popup; BlurRadius = UD(0, 20); Spread = UFO(5, 5); Transparency = 0.65; })
	Add("UICorner", { Parent = Header; BottomLeftRadius = UD(0, 0); BottomRightRadius = UD(0, 0); TopLeftRadius = UD(0, 5); TopRightRadius = UD(0, 5); })
	Add("UIStroke", { Parent = Header; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
	Add("UIPadding", { Parent = Header; PaddingBottom = UD(0, 10); PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); PaddingTop = UD(0, 10); })
	Add("UIListLayout", { Parent = Header; FillDirection = FD.Horizontal; HorizontalFlex = UFA.SpaceBetween; SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; })
	Add("TextLabel", { Parent = Header; Name = "Label"; AnchorPoint = V2(0, 0.5); AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Position = UD2(0, 38, 0.5, 0); Size = UFO(0, 9); Text = Keybind.Title ~= "" and Keybind.Title or self.Text; TextColor3 = RGB(255, 255, 255); TextSize = 13; })
	local CloseButton = Add("ImageButton", { Parent = Header; Name = "CloseButton"; AutoButtonColor = false; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://76308464050634"; Size = UFO(15, 15); }) :: ImageButton
	Add("UIStroke", { Parent = KeyButton; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
	Add("UICorner", { Parent = KeyButton; CornerRadius = UD(0, 5); })
	Add("UIPadding", { Parent = Page; PaddingBottom = UD(0, 12); PaddingLeft = UD(0, 12); PaddingRight = UD(0, 12); PaddingTop = UD(0, 12); })
	Add("UIListLayout", { Parent = Options; FillDirection = FD.Horizontal; HorizontalAlignment = HFA.Center; HorizontalFlex = UFA.Fill; Padding = UD(0, 10); SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; })
	local HoldLabel = Add("TextLabel", { Parent = HoldButton; Name = "Label"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UFS(1, 1); Text = "Hold"; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextLabel
	Add("UIPadding", { Parent = HoldButton; PaddingLeft = UD(0, 14); PaddingRight = UD(0, 14); })
	Add("UICorner", { Parent = HoldButton; CornerRadius = UD(0, 5); })
	local HoldGradient = Add("UIGradient", { Parent = HoldButton; Color = CS{ CSK(0, RGB(78, 88, 129)), CSK(1, RGB(138, 156, 229)) }; Rotation = -90; }) :: UIGradient
	local ToggleGradient = Add("UIGradient", { Parent = ToggleButton; Color = CS{ CSK(0, RGB(78, 88, 129)), CSK(1, RGB(138, 156, 229)) }; Enabled = false; Rotation = -90; }) :: UIGradient
	local ToggleLabel = Add("TextLabel", { Parent = ToggleButton; Name = "Label"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UFS(1, 1); Text = "Toggle"; TextColor3 = RGB(255, 255, 255); TextSize = 14; TextTransparency = 0.5; }) :: TextLabel
	Add("UIPadding", { Parent = ToggleButton; PaddingLeft = UD(0, 14); PaddingRight = UD(0, 14); })
	Add("UICorner", { Parent = ToggleButton; CornerRadius = UD(0, 5); })

	--@ keybind state
	local Listening = false

	local function Format(Key: EnumItem?): string
		if not Key then
			return "NONE"
		end

		return Keys[Key.Name] or Key.Name
	end

	local function Matches(Input: InputObject): boolean
		return Keybind.Key ~= nil and (Input.KeyCode == Keybind.Key or Input.UserInputType == Keybind.Key)
	end

	Keybind.Set = function(Key: EnumItem?)
		Keybind.Key = Key
		KeyButton.Text = Format(Key)
	end

	Keybind.SetType = function(Type: string)
		Keybind.Type = Type
		local Held = Type == "Hold"

		--@ the gradient only tints the white background, so switching it off while that
		--@ background is still fading leaves the button bare white for the whole tween
		local function Mode(Button: TextButton, Gradient: UIGradient, Label: TextLabel, Active: boolean)
			if Active then
				Gradient.Enabled = true
			end

			local Fade = Tween(Button, { BackgroundColor3 = Active and RGB(255, 255, 255) or RGB(20, 20, 21) }, 0.15)
			Tween(Label, { TextColor3 = Active and RGB(0, 0, 0) or RGB(255, 255, 255); TextTransparency = Active and 0 or 0.5 }, 0.15)

			if not Active then
				Fade.Completed:Once(function()
					--@ skipped if a switch back re-armed this button mid-fade
					if Keybind.Type == Type then
						Gradient.Enabled = false
					end
				end)
			end
		end

		Mode(HoldButton, HoldGradient, HoldLabel, Held)
		Mode(ToggleButton, ToggleGradient, ToggleLabel, not Held)

		if Held and Keybind.State then
			Keybind.State = false
			Keybind.Callback(false)
		end
	end

	Keybind.Close = function()
		Keybind.Open(false)
	end

	Keybind.Open = function(State: boolean?)
		if State == nil then
			State = not Popup.Visible
		end

		if State then
			ClaimPopup(Keybind)

			local Target = UFO(
				Settings.AbsolutePosition.X + Settings.AbsoluteSize.X - Popup.AbsoluteSize.X,
				Settings.AbsolutePosition.Y + Settings.AbsoluteSize.Y + 8
			)

			Popup.Position = Target - UFO(0, 10)
			Popup.Visible = true
			Tween(Popup, { Position = Target }, 0.25, ES.Quint)
		else
			Listening = false
			Keybind.Set(Keybind.Key)
			Popup.Visible = false
			ReleasePopup(Keybind)
		end

		Tween(Settings, { ImageTransparency = State and 0 or 0.5 }, 0.15)
	end

	KeyButton.Activated:Connect(function()
		Listening = true
		KeyButton.Text = "..."
	end)

	HoldButton.Activated:Connect(function()
		Keybind.SetType("Hold")
	end)

	ToggleButton.Activated:Connect(function()
		Keybind.SetType("Toggle")
	end)

	Settings.Activated:Connect(function()
		Keybind.Open()
	end)

	CloseButton.Activated:Connect(function()
		Keybind.Open(false)
	end)

	UserInputService.InputBegan:Connect(function(Input, GameProcessed)
		if Listening then
			--@ the click that armed the prompt lands here, so ignore presses on the button itself
			if Input.UserInputType == UIT.MouseButton1 and KeyButton.GuiState ~= EGS.Idle then
				return
			end

			Listening = false

			if Input.KeyCode == EKC.Backspace or Input.KeyCode == EKC.Escape then
				Keybind.Set(nil)
			elseif Input.UserInputType == UIT.Keyboard then
				Keybind.Set(Input.KeyCode)
			elseif Input.UserInputType == UIT.MouseButton1 or Input.UserInputType == UIT.MouseButton2 or Input.UserInputType == UIT.MouseButton3 then
				Keybind.Set(Input.UserInputType)
			else
				Keybind.Set(Keybind.Key)
			end

			return
		end

		if GameProcessed or not Matches(Input) then
			return
		end

		Keybind.State = Keybind.Type == "Hold" or not Keybind.State
		Keybind.Callback(Keybind.State)
	end)

	--@ deliberately ignores GameProcessed, otherwise a hold can get stuck on
	UserInputService.InputEnded:Connect(function(Input)
		if Keybind.Type ~= "Hold" or not Keybind.State or not Matches(Input) then
			return
		end

		Keybind.State = false
		Keybind.Callback(false)
	end)

	BindDrag(Popup, Header)

	Keybind.SetType(Keybind.Type)
	Keybind.Set(Keybind.Key)
	return Keybind
end

Library.SubElements.Colorpicker = function(self: Library, propertyTable: {})
	local Colorpicker = Overwrite({
		Title = "",
		Color = RGB(255, 0, 0),
		Transparency = 0,
		Callback = print,
	}, propertyTable or {})

	local Hue, Saturation, Value = Colorpicker.Color:ToHSV()

	local Button = Add("TextButton", { Parent = self.RightContent; Name = "Button"; AutoButtonColor = false; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFO(15, 15); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
	Add("UICorner", { Parent = Button; CornerRadius = UD(0, 7); })
	Add("UIGradient", { Parent = Button; Color = CS{ CSK(0, RGB(163, 163, 163)), CSK(1, RGB(255, 255, 255)) }; Rotation = -90; })

	local ColorpickerFrame = Add("Frame", { Parent = Library._Instance; Name = "ColorpickerFrame"; Active = true; AutomaticSize = AS.Y; BackgroundColor3 = RGB(9, 8, 8); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(0.3759043514728546, 0.058557264506816864); Size = UFO(199, 0); Visible = false; ZIndex = PopupZ; }) :: Frame
	--@ buttons are the only thing that reliably swallows a click. Created first so it sits
	--@ under the contents, and scale sized so it stays out of the AutomaticSize maths
	Add("TextButton", { Parent = ColorpickerFrame; Name = "Catcher"; AutoButtonColor = false; BackgroundTransparency = 1; BorderSizePixel = 0; Size = UFS(1, 1); Text = ""; })
	local Header = Add("Frame", { Parent = ColorpickerFrame; Name = "Header"; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(1, 0, 0, 35); }) :: Frame
	--@ its height has to come from its own contents. A scale height would be ignored by the
	--@ frame's AutomaticSize, leaving the frame only as tall as the header while everything
	--@ below it rendered outside the frame and took no input
	local Page = Add("Frame", { Parent = ColorpickerFrame; Name = "Page"; AutomaticSize = AS.Y; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(0, 35); Size = UD2(1, 0, 0, 0); }) :: Frame
	local SaturationBox = Add("Frame", { Parent = Page; Name = "SaturationBox"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(1, 0, 0, 175); }) :: Frame
	local ValueOverlay = Add("Frame", { Parent = SaturationBox; Name = "ValueOverlay"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 1); }) :: Frame
	local SaturationCursor = Add("TextButton", { Parent = SaturationBox; Name = "SaturationCursor"; AnchorPoint = V2(0.5, 0.5); AutoButtonColor = false; BackgroundColor3 = RGB(255, 0, 0); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Position = UFS(1, 0); Size = UFO(10, 10); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
	local HueSlider = Add("Frame", { Parent = Page; Name = "HueSlider"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(1, 0, 0, 12); }) :: Frame
	local HueCursor = Add("Frame", { Parent = HueSlider; Name = "HueCursor"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(0, -2); Size = UD2(0, 10, 1, 4); }) :: Frame
	local AlphaSlider = Add("Frame", { Parent = Page; Name = "AlphaSlider"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(1, 0, 0, 12); }) :: Frame
	local AlphaCursor = Add("Frame", { Parent = AlphaSlider; Name = "AlphaCursor"; AnchorPoint = V2(1, 0); BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(1, 0, 0, -2); Size = UD2(0, 10, 1, 4); }) :: Frame
	Add("UICorner", { Parent = ColorpickerFrame; CornerRadius = UD(0, 5); })
	Add("UIStroke", { Parent = ColorpickerFrame; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
	Add("UIShadow", { Parent = ColorpickerFrame; BlurRadius = UD(0, 20); Spread = UFO(5, 5); Transparency = 0.65; })
	Add("UICorner", { Parent = Header; BottomLeftRadius = UD(0, 0); BottomRightRadius = UD(0, 0); TopLeftRadius = UD(0, 5); TopRightRadius = UD(0, 5); })
	Add("UIStroke", { Parent = Header; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
	Add("UIPadding", { Parent = Header; PaddingBottom = UD(0, 10); PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); PaddingTop = UD(0, 10); })
	Add("UIListLayout", { Parent = Header; FillDirection = FD.Horizontal; HorizontalFlex = UFA.SpaceBetween; SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; })
	Add("TextLabel", { Parent = Header; Name = "Label"; AnchorPoint = V2(0, 0.5); AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Position = UD2(0, 38, 0.5, 0); Size = UFO(0, 9); Text = Colorpicker.Title ~= "" and Colorpicker.Title or self.Text; TextColor3 = RGB(255, 255, 255); TextSize = 13; })
	local CloseButton = Add("ImageButton", { Parent = Header; Name = "CloseButton"; AutoButtonColor = false; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://76308464050634"; Size = UFO(15, 15); }) :: ImageButton
	Add("UIPadding", { Parent = Page; PaddingBottom = UD(0, 12); PaddingLeft = UD(0, 12); PaddingRight = UD(0, 12); PaddingTop = UD(0, 12); })
	Add("UICorner", { Parent = SaturationBox; CornerRadius = UD(0, 5); })
	Add("UIGradient", { Parent = ValueOverlay; Color = CS{ CSK(0, RGB(0, 0, 0)), CSK(1, RGB(0, 0, 0)) }; Rotation = -90; Transparency = NS{ NSK(0, 0), NSK(1, 1) }; })
	Add("UICorner", { Parent = ValueOverlay; CornerRadius = UD(0, 4); })
	local SaturationGradient = Add("UIGradient", { Parent = SaturationBox; Color = CS{ CSK(0, RGB(255, 255, 255)), CSK(1, RGB(255, 0, 0)) }; }) :: UIGradient
	Add("UIStroke", { Parent = SaturationBox; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
	Add("UICorner", { Parent = SaturationCursor; CornerRadius = UD(1, 0); })
	Add("UIShadow", { Parent = SaturationCursor; BlurRadius = UD(0, 5); Spread = UFO(5, 5); Transparency = 0.48; })
	Add("UIStroke", { Parent = SaturationCursor; ApplyStrokeMode = ASM.Border; Color = RGB(255, 255, 255); })
	Add("UIListLayout", { Parent = Page; Padding = UD(0, 10); SortOrder = SO.LayoutOrder; })
	Add("UICorner", { Parent = HueSlider; CornerRadius = UD(0, 5); })
	Add("UICorner", { Parent = HueCursor; CornerRadius = UD(0, 3); })
	Add("UIShadow", { Parent = HueCursor; BlurRadius = UD(0, 5); Spread = UFO(5, 5); Transparency = 0.48; })
	Add("UIGradient", { Parent = HueSlider; Color = CS{ CSK(0, RGB(255, 0, 1)), CSK(0.167, RGB(255, 0, 255)), CSK(0.333, RGB(0, 0, 255)), CSK(0.5, RGB(0, 255, 225)), CSK(0.667, RGB(0, 255, 0)), CSK(0.833, RGB(255, 255, 0)), CSK(1, RGB(255, 0, 0)) }; Transparency = NS{ NSK(0, 0), NSK(0.481, 0.29374998807907104), NSK(1, 0) }; })
	Add("UICorner", { Parent = AlphaSlider; CornerRadius = UD(0, 5); })
	Add("UICorner", { Parent = AlphaCursor; CornerRadius = UD(0, 3); })
	Add("UIShadow", { Parent = AlphaCursor; BlurRadius = UD(0, 5); Spread = UFO(5, 5); Transparency = 0.48; })
	local AlphaGradient = Add("UIGradient", { Parent = AlphaSlider; Color = CS{ CSK(0, RGB(255, 255, 255)), CSK(1, RGB(255, 0, 0)) }; }) :: UIGradient

	--@ colorpicker state
	local function Update()
		Colorpicker.Color = HSV(Hue, Saturation, Value)

		SaturationGradient.Color = CS{ CSK(0, RGB(255, 255, 255)), CSK(1, HSV(Hue, 1, 1)) }
		AlphaGradient.Color = CS{ CSK(0, RGB(255, 255, 255)), CSK(1, Colorpicker.Color) }

		Tween(SaturationCursor, { Position = UFS(Saturation, 1 - Value), BackgroundColor3 = Colorpicker.Color }, 0.08)
		Tween(HueCursor, { AnchorPoint = V2(1 - Hue, 0), Position = UD2(1 - Hue, 0, 0, -2) }, 0.08)
		Tween(AlphaCursor, { AnchorPoint = V2(1 - Colorpicker.Transparency, 0), Position = UD2(1 - Colorpicker.Transparency, 0, 0, -2) }, 0.08)

		Tween(Button, { BackgroundColor3 = Colorpicker.Color, BackgroundTransparency = Colorpicker.Transparency }, 0.15)

		Colorpicker.Callback(Colorpicker.Color, Colorpicker.Transparency)
	end

	Colorpicker.Set = function(Color: Color3?, Transparency: number?)
		if Color then
			Hue, Saturation, Value = Color:ToHSV()
		end

		Colorpicker.Transparency = MC(Transparency or Colorpicker.Transparency, 0, 1)
		Update()
	end

	Colorpicker.Close = function()
		Colorpicker.Toggle(false)
	end

	Colorpicker.Toggle = function(State: boolean?)
		if State == nil then
			State = not ColorpickerFrame.Visible
		end

		if State then
			ClaimPopup(Colorpicker)

			local Target = UFO(
				Button.AbsolutePosition.X + Button.AbsoluteSize.X - ColorpickerFrame.AbsoluteSize.X,
				Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 8
			)

			ColorpickerFrame.Position = Target - UFO(0, 10)
			ColorpickerFrame.Visible = true
			Tween(ColorpickerFrame, { Position = Target }, 0.25, ES.Quint)
		else
			ColorpickerFrame.Visible = false
			ReleasePopup(Colorpicker)
		end
	end

	BindSlider(HueSlider, function(Alpha)
		Hue = 1 - Alpha.X
		Update()
	end)

	BindSlider(SaturationBox, function(Alpha)
		Saturation, Value = Alpha.X, 1 - Alpha.Y
		Update()
	end)

	BindSlider(AlphaSlider, function(Alpha)
		Colorpicker.Transparency = 1 - Alpha.X
		Update()
	end)

	Button.Activated:Connect(function()
		Colorpicker.Toggle()
	end)

	CloseButton.Activated:Connect(function()
		Colorpicker.Toggle(false)
	end)

	BindDrag(ColorpickerFrame, Header)

	Colorpicker.Set(Colorpicker.Color, Colorpicker.Transparency)
	return Colorpicker
end


--@ window
Library._Instance = Add("ScreenGui", { Parent = RunService:IsStudio() and Client.PlayerGui or Services:GetService("CoreGui"); Name = "Window"; ZIndexBehavior = ZIB.Sibling; }) :: ScreenGui

 

Library.Window = function(self: Library, propertyTable: {})
	local Window = Overwrite({
		Title = "",
		Footer = "",
	}, propertyTable or {})

	local Canvas = Add("Frame", { Parent = self._Instance; Name = "Canvas"; BackgroundColor3 = RGB(9, 8, 8); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFO(658, 461); }) :: Frame 
	local Sidebar = Add("Frame", { Parent = Canvas; Name = "Sidebar"; BackgroundColor3 = RGB(15, 14, 15); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(0, 75, 1, 0); }) :: Frame 
	local PageButtons = Add("Frame", { Parent = Sidebar; Name = "PageButtons"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 1); }) :: Frame 
	local Header = Add("Frame", { Parent = Canvas; Name = "Header"; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(76, 0); Size = UD2(1, -76, 0, 50); }) :: Frame 
	local SubPages = Add("Frame", { Parent = Header; Name = "SubPages"; AutomaticSize = AS.X; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(0, 1); }) :: Frame 
	local Search = Add("Frame", { Parent = Header; Name = "Search"; LayoutOrder = 1; Active = true; AnchorPoint = V2(1, 0); AutomaticSize = AS.X; BackgroundColor3 = RGB(9, 8, 8); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(1, 0); Selectable = true; Size = UD2(0, 200, 1, 0); }) :: Frame 
	local Pages = Add("Frame", { Parent = Canvas; Name = "Pages"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(75, 50); Size = UD2(1, -75, 1, -50); }) :: Frame 
	local Footer = Add("Frame", { Parent = Canvas; Name = "Footer"; AnchorPoint = V2(0, 1); BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(0, 76, 1, 0); Size = UD2(1, -76, 0, 25); }) :: Frame 
	local SearchBox = Add("TextBox", { Parent = Search; Name = "TextLabel"; Active = false; AutomaticSize = AS.X; ClearTextOnFocus = false; LayoutOrder = 1; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); PlaceholderColor3 = RGB(255, 255, 255); PlaceholderText = "Search function"; Selectable = false; Size = UFS(0, 1); Text = ""; TextColor3 = RGB(255, 255, 255); TextSize = 14; TextTransparency = 0.5; }) :: TextBox
	Add("UIStroke", { Parent = Canvas; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); }) 
	Add("UICorner", { Parent = Canvas; CornerRadius = UD(0, 5); }) 
	Add("UICorner", { Parent = Sidebar; BottomLeftRadius = UD(0, 5); BottomRightRadius = UD(0, 0); TopLeftRadius = UD(0, 5); TopRightRadius = UD(0, 0); }) 
	Add("UIStroke", { Parent = Sidebar; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); }) 
	Add("UIListLayout", { Parent = PageButtons; HorizontalAlignment = HFA.Center; Padding = UD(0, 5); SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; }) 
	Add("UICorner", { Parent = Header; BottomLeftRadius = UD(0, 0); BottomRightRadius = UD(0, 0); TopLeftRadius = UD(0, 0); TopRightRadius = UD(0, 5); }) 
	Add("UIStroke", { Parent = Header; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); }) 
	Add("UIListLayout", { Parent = SubPages; FillDirection = FD.Horizontal; Padding = UD(0, 10); SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; }) 
	Add("UIPadding", { Parent = Header; PaddingBottom = UD(0, 10); PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); PaddingTop = UD(0, 10); }) 
	Add("UIPadding", { Parent = Search; PaddingLeft = UD(0, 8); PaddingRight = UD(0, 8); }) 
	Add("UICorner", { Parent = Search; CornerRadius = UD(0, 5); }) 
	Add("UIListLayout", { Parent = Search; FillDirection = FD.Horizontal; Padding = UD(0, 5); SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; }) 
	Add("ImageLabel", { Parent = Search; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; LayoutOrder = 0; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://82536262318754"; ImageTransparency = 0.5; ResampleMode = Enum.ResamplerMode.Pixelated; Size = UFO(15, 15); }) 
	Add("UIListLayout", { Parent = Header; FillDirection = FD.Horizontal; HorizontalFlex = UFA.SpaceBetween; SortOrder = SO.LayoutOrder; VerticalAlignment = VFA.Center; }) 
	Add("UIPadding", { Parent = Pages; PaddingBottom = UD(0, 12); PaddingLeft = UD(0, 12); PaddingRight = UD(0, 12); PaddingTop = UD(0, 12); }) 
	Add("UIShadow", { Parent = Canvas; BlurRadius = UD(0, 20); Spread = UFO(5, 5); Transparency = 0.65; }) 
	Add("UICorner", { Parent = Footer; BottomLeftRadius = UD(0, 0); BottomRightRadius = UD(0, 5); TopLeftRadius = UD(0, 0); TopRightRadius = UD(0, 0); }) 
	Add("UIStroke", { Parent = Footer; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); }) 
	Add("UIPadding", { Parent = Footer; PaddingBottom = UD(0, 10); PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); PaddingTop = UD(0, 10); }) 
	Add("TextLabel", { Parent = Footer; AnchorPoint = V2(0, 0.5); AutomaticSize = AS.X; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Position = UFS(0, 0.5); Size = UFO(0, 13); Text = Window.Title; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.5; }) 
	Add("TextLabel", { Parent = Footer; AnchorPoint = V2(1, 0.5); AutomaticSize = AS.X; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Position = UFS(1, 0.5); Size = UFO(0, 13); Text = Window.Footer; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.5; }) 
	BindDrag(Canvas, Header)

	--@ the icon and the padding around the box are part of the bar you'd expect to click
	Search.InputBegan:Connect(function(Input)
		if Input.UserInputType == UIT.MouseButton1 or Input.UserInputType == UIT.Touch then
			SearchBox:CaptureFocus()
		end
	end)

	--@ search hides non matching elements and any section left with nothing in it
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local Query = SearchBox.Text:lower()
		local Matched = {}

		for _, Entry in Library.Searchable do
			--@ plain find, so a query like "fov (" can't blow up as a malformed pattern
			local Visible = Query == "" or Entry.Text:lower():find(Query, 1, true) ~= nil

			Entry.Frame.Visible = Visible

			if Visible then
				Matched[Entry.Section] = true
			end
		end

		for _, Section in Library.Sections do
			Section.Frame.Visible = Query == "" or Matched[Section] == true
		end
	end)

	--@ tab
	Window.Pages = {}
	Window.Page = function(self: Library, propertyTable: {})
		local Page = Overwrite({
			Icon = 89784578844770
		}, propertyTable or {})

		Page.SubPages = {}
		Page.ActiveSubPage = nil
		Page.Opened = false

		local PageButton = Add("TextButton", { Parent = PageButtons; Name = "PageButton"; AutoButtonColor = false; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFO(45, 45); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
		Add("UICorner", { Parent = PageButton; CornerRadius = UD(1, 0); })
		Add("UIGradient", { Parent = PageButton; Color = CS{ CSK(0, RGB(81, 91, 129)), CSK(1, RGB(127, 142, 202)) }; Rotation = -70; })
		local PageIcon = Add("ImageLabel", { Parent = PageButton; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://" .. tostring(Page.Icon); ImageTransparency = 0.5; ResampleMode = Enum.ResamplerMode.Pixelated; Size = UFS(1, 1); }) :: ImageLabel
		Add("UIPadding", { Parent = PageButton; PaddingBottom = UD(0, 12); PaddingLeft = UD(0, 12); PaddingRight = UD(0, 12); PaddingTop = UD(0, 12); })

		--@ a page's own trigger styling, layered on top of the shared frame/slide/Section
		--@ logic. Also toggles its sub page buttons - those only make sense to click while
		--@ this page is the one open. A page that has sub pages never shows its own frame;
		--@ it hands the content area to whichever sub page was last active
		PageContent(Page, Pages, Window.Pages, function()
			Page.Opened = true
			Tween(PageButton, { BackgroundTransparency = 0 })
			Tween(PageIcon, { ImageTransparency = 0, ImageColor3 = RGB(0, 0, 0) })

			for _, SubPage in Page.SubPages do
				SubPage.Button.Visible = true
			end

			if Page.ActiveSubPage then
				Page.Frame.Visible = false
				Page.ActiveSubPage.Open()
			end
		end, function()
			Page.Opened = false
			Tween(PageButton, { BackgroundTransparency = 1 })
			Tween(PageIcon, { ImageTransparency = 0.5, ImageColor3 = RGB(255, 255, 255) })

			for _, SubPage in Page.SubPages do
				SubPage.Button.Visible = false
			end

			--@ the sub page frame is a sibling of the page frames, so it has to be hidden
			--@ here or it would linger over the next page. Which one was active is kept, so
			--@ reopening the page restores it
			if Page.ActiveSubPage then
				Page.ActiveSubPage.Close()
			end
		end)

		--@ sub page
		--@ a sub page IS a page: built by the same PageContent, parented to the window's
		--@ content area as a sibling of every page frame, just registered into
		--@ Page.SubPages instead of Window.Pages and reached through this pill button in
		--@ the header row instead of the sidebar
		Page.SubPage = function(self: Library, propertyTable: {})
			local SubPage = Overwrite({
				Name = "",
			}, propertyTable or {})

			--@ shared header row, so this only shows while its own page is open
			local SubPageButton = Add("TextButton", { Parent = SubPages; Name = "SubPageButton"; AutoButtonColor = false; AutomaticSize = AS.X; BackgroundColor3 = RGB(9, 8, 8); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFS(0, 1); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; Visible = Page.Opened; }) :: TextButton
			Add("UIGradient", { Parent = SubPageButton; Color = CS{ CSK(0, RGB(81, 91, 129)), CSK(1, RGB(127, 142, 202)) }; Rotation = -70; })
			local SubPageLabel = Add("TextLabel", { Parent = SubPageButton; Name = "Label"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UFS(1, 1); Text = SubPage.Name; TextColor3 = RGB(255, 255, 255); TextSize = 14; TextTransparency = 0.5; }) :: TextLabel
			Add("UIPadding", { Parent = SubPageButton; PaddingLeft = UD(0, 14); PaddingRight = UD(0, 14); })
			Add("UICorner", { Parent = SubPageButton; CornerRadius = UD(0, 5); })

			SubPage.Button = SubPageButton

			PageContent(SubPage, Pages, Page.SubPages, function()
				--@ opening a sub page takes over the content area from the page itself
				Page.ActiveSubPage = SubPage
				Page.Frame.Visible = false

				Tween(SubPageButton, { BackgroundColor3 = RGB(255, 255, 255) }, 0.15)
				Tween(SubPageLabel, { TextTransparency = 0 }, 0.15)
			end, function()
				Tween(SubPageButton, { BackgroundColor3 = RGB(9, 8, 8) }, 0.15)
				Tween(SubPageLabel, { TextTransparency = 0.5 }, 0.15)
			end)

			SubPageButton.Activated:Connect(SubPage.Open)

			--@ the first sub page becomes the page's content, but only shows right away if
			--@ its page is the one currently open - its frame lives beside every page frame
			--@ now, so opening it blind would draw it over whatever page is on screen
			if #Page.SubPages == 1 then
				Page.ActiveSubPage = SubPage

				if Page.Opened then
					SubPage.Open()
				end
			else
				SubPage.Close()
			end

			return SubPage
		end

		PageButton.Activated:Connect(Page.Open)

		if #Window.Pages == 1 then
			Page.Open()
		else
			Page.Close()
		end

		return Page
	end

	return Window
end

--@ ending
return Library