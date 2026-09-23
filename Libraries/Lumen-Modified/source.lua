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

local PopupZ = 20

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
	["RightShift"]        = "RShift",
	["LeftShift"]         = "LShift",
	["RightControl"]      = "RCtrl",
	["LeftControl"]       = "LCtrl",
	["LeftAlt"]           = "LAlt",
	["RightAlt"]          = "RAlt",
	["MouseButton1"]      = "MB1",
	["MouseButton2"]      = "MB2",
	["MouseButton3"]      = "MB3"
}

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

local function Overwrite(to_overwrite, overwrite_with)
	for i, v in pairs(overwrite_with) do
		if v ~= to_overwrite[i] then

		if type(v) == "table" and type(to_overwrite[i]) == "table" then
			Overwrite(to_overwrite[i], v)
		elseif type(v) == "table" then
			to_overwrite[i] = Overwrite({}, v)
		else
			to_overwrite[i] = v
		end
		end
	end

	return to_overwrite
end

local Lucide = {
	activity = 10709752035,
	aperture = 10709761813,
	bell = 10709775704,
	box = 10709782497,
	circle = 10709798174,
	cloud = 10709806740,
	cog = 10709810948,
	cpu = 10709813383,
	crosshair = 10709818534,
	eye = 10723346959,
	file = 10723374641,
	flame = 10723376114,
	folder = 10723387563,
	gamepad = 10723395457,
	grid = 10723404936,
	hash = 10723405975,
	heart = 10723406885,
	["help-circle"] = 10723406988,
	home = 10723407389,
	info = 10723415903,
	key = 10723416652,
	layers = 10723424505,
	list = 10723433811,
	lock = 10723434711,
	menu = 10734887784,
	["message-square"] = 10734888228,
	moon = 10734897102,
	["mouse-pointer"] = 10734898476,
	move = 10734900011,
	palette = 10734910430,
	save = 10734941499,
	scan = 10734942565,
	search = 10734943674,
	settings = 10734950309,
	shield = 10734951847,
	sliders = 10734963400,
	star = 10734966248,
	sun = 10734974297,
	sword = 10734975486,
	swords = 10734975692,
	target = 10734977012,
	terminal = 10734982144,
	zap = 10734975486,
	sparkles = 10734966248,
	user = 10747373176,
	users = 10747373426,
	wifi = 10747382504,
	wrench = 10747383470,
}

local function ResolveIcon(Icon: number | string?): string
	if Icon == nil or Icon == "" then
		return ""
	end
	if type(Icon) == "number" then
		return "rbxassetid://" .. tostring(Icon)
	end
	local AsString = tostring(Icon)
	if AsString:match("^rbxasset") then
		return AsString
	end
	-- bare numeric string → asset id
	if AsString:match("^%d+$") then
		return "rbxassetid://" .. AsString
	end

	local Name = AsString:lower():gsub("^lucide:", ""):gsub("%s+", "-")
	local Id = Lucide[Name] or Lucide[Name:gsub("-", "")]
	if Id then
		return "rbxassetid://" .. tostring(Id)
	end
	-- unknown name: empty (caller can hide), never force hash
	return ""
end

local function ClampToScreen(Object: GuiObject, Position: UDim2): UDim2
	local Camera = workspace.CurrentCamera
	local Viewport = Camera and Camera.ViewportSize or V2(1920, 1080)
	local GuiService = Services:GetService("GuiService")
	local Inset = GuiService:GetGuiInset()
	local Size = Object.AbsoluteSize
	if Size.X <= 0 or Size.Y <= 0 then
		if Size.X <= 0 then Size = V2(280, 200) end
	end

	local IgnoresInset = false
	local Node = Object
	while Node do
		if Node:IsA("ScreenGui") then
			IgnoresInset = Node.IgnoreGuiInset == true
			break
		end
		Node = Node.Parent
	end

	local Pad = 6
	local UsableW = Viewport.X
	local UsableH = Viewport.Y
	local MinX = Pad
	local MinY = Pad
	if IgnoresInset then

		MinY = Inset.Y + Pad
		UsableH = Viewport.Y
	else

		UsableH = Viewport.Y - Inset.Y
	end

	local MaxX = math.max(MinX, UsableW - Size.X - Pad)
	local MaxY = math.max(MinY, UsableH - Size.Y - Pad)

	local X = MC(Position.X.Offset, MinX, MaxX)
	local Y = MC(Position.Y.Offset, MinY, MaxY)

	return UD2(Position.X.Scale, X, Position.Y.Scale, Y)
end

local function BindDrag(Object: GuiObject, Handle: GuiObject?, ClampScreen: boolean?, IgnoreUnder: GuiObject?)
	Handle = Handle or Object
	ClampScreen = ClampScreen == true

	local Dragging = false
	local DragStart: Vector3
	local StartPosition: UDim2
	local CurrentDelta = V2(0, 0)
	local RenderConn: RBXScriptConnection?

	local function ApplyPosition(Position: UDim2)
		if ClampScreen then
			Position = ClampToScreen(Object, Position)
		end
		Object.Position = Position
	end

	local function StopDrag()
		Dragging = false
		if RenderConn then
			RenderConn:Disconnect()
			RenderConn = nil
		end
	end

	local function IsIgnored(Input: InputObject): boolean
		if not IgnoreUnder then
			return false
		end
		local Pos = Input.Position
		local Objects = Client.PlayerGui:GetGuiObjectsAtPosition(Pos.X, Pos.Y)

		local Abs = IgnoreUnder.AbsolutePosition
		local Size = IgnoreUnder.AbsoluteSize
		if Pos.X >= Abs.X and Pos.X <= Abs.X + Size.X and Pos.Y >= Abs.Y and Pos.Y <= Abs.Y + Size.Y then
			return true
		end
		for _, Gui in Objects do
			if Gui == IgnoreUnder or Gui:IsDescendantOf(IgnoreUnder) then
				return true
			end
		end
		return false
	end

	Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType ~= UIT.MouseButton1 and Input.UserInputType ~= UIT.Touch then
			return
		end
		if IsIgnored(Input) then
			return
		end

		Dragging = true
		DragStart = Input.Position
		StartPosition = Object.Position
		CurrentDelta = V2(0, 0)

		if ClampScreen and Library.OpenPopup and Library.OpenPopup.Close then
			Library.OpenPopup.Close()
		end

		local Connection
		Connection = Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				StopDrag()
				Connection:Disconnect()
			end
		end)

		if RenderConn then
			RenderConn:Disconnect()
		end

		RenderConn = RunService.RenderStepped:Connect(function()
			if not Dragging then
				return
			end

			local Target = UD2(
				StartPosition.X.Scale,
				StartPosition.X.Offset + CurrentDelta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + CurrentDelta.Y
			)
			if ClampScreen then
				Target = ClampToScreen(Object, Target)
			end
			Object.Position = Object.Position:Lerp(Target, 0.88)
		end)
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if not Dragging or (Input.UserInputType ~= UIT.MouseMovement and Input.UserInputType ~= UIT.Touch) then
			return
		end

		CurrentDelta = V2(Input.Position.X - DragStart.X, Input.Position.Y - DragStart.Y)
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == UIT.MouseButton1 or Input.UserInputType == UIT.Touch then
			if Dragging then

				ApplyPosition(UD2(
					StartPosition.X.Scale,
					StartPosition.X.Offset + CurrentDelta.X,
					StartPosition.Y.Scale,
					StartPosition.Y.Offset + CurrentDelta.Y
				))
				StopDrag()
			end
		end
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

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if not Library.OpenPopup then
		return
	end
	if Input.UserInputType ~= UIT.MouseButton1 and Input.UserInputType ~= UIT.Touch then
		return
	end

	local Popup = Library.OpenPopup
	local Pos = Input.Position

	local function Inside(Gui: GuiObject?): boolean
		if not Gui or not Gui.Visible then
			return false
		end
		local A = Gui.AbsolutePosition
		local S = Gui.AbsoluteSize
		return Pos.X >= A.X and Pos.X <= A.X + S.X and Pos.Y >= A.Y and Pos.Y <= A.Y + S.Y
	end

	local Root = Popup.Frame or Popup._Frame
	if not Root then
		for _, Name in { "ColorpickerFrame", "Popup", "Options" } do
			local Child = Library._Instance:FindFirstChild(Name)
			if Child and Child.Visible then
				Root = Child
				break
			end
		end
	end

	if Root and Inside(Root) then
		return
	end

	if Popup.Button and Inside(Popup.Button) then
		return
	end
	if Popup.Settings and Inside(Popup.Settings) then
		return
	end

	if Popup.Close then
		Popup.Close()
	elseif Popup.Toggle then
		Popup.Toggle(false)
	elseif Popup.Open then
		Popup.Open(false)
	end
end)

local SectionDrag = {
	Active = false,
	Section = nil :: any,
	Ghost = nil :: Frame?,
	Placeholder = nil :: Frame?,
	SourceParent = nil :: Frame?,
	SourceOrder = 0,
	TargetParent = nil :: Frame?,
	TargetIndex = 0,
	Offset = V2(0, 0),
	DragHeight = 60,
	DragWidth = 200,
	RenderConn = nil :: RBXScriptConnection?,
}

local function ClearSectionDragVisuals()
	if SectionDrag.Ghost then
		SectionDrag.Ghost:Destroy()
		SectionDrag.Ghost = nil
	end
	if SectionDrag.Placeholder then
		SectionDrag.Placeholder:Destroy()
		SectionDrag.Placeholder = nil
	end
end

local function ListColumnSections(Column: Frame, Exclude: Frame?): { Frame }
	local List = {}
	for _, Child in Column:GetChildren() do
		if Child:IsA("Frame") and Child.Name == "Section" and Child ~= Exclude then
			TIS(List, Child)
		end
	end
	table.sort(List, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)
	return List
end

local function RelayoutColumn(Column: Frame, Placeholder: Frame?, InsertIndex: number, Exclude: Frame?)
	local Sections = ListColumnSections(Column, Exclude)

	InsertIndex = MC(InsertIndex, 0, #Sections)

	if Placeholder then
		Placeholder.Parent = Column
		Placeholder.LayoutOrder = InsertIndex * 2
		Placeholder.Visible = true
	end

	for Index, SectionFrame in Sections do

		local Slot = Index - 1
		if Slot >= InsertIndex then
			Slot = Slot + 1
		end
		SectionFrame.LayoutOrder = Slot * 2
	end
end

local function NormalizeColumnOrders(Column: Frame)
	local Sections = ListColumnSections(Column, nil)
	for Index, SectionFrame in Sections do
		SectionFrame.LayoutOrder = Index - 1
	end
end

local function StopSectionDrag(Commit: boolean)
	if not SectionDrag.Active then
		return
	end

	SectionDrag.Active = false

	if SectionDrag.RenderConn then
		SectionDrag.RenderConn:Disconnect()
		SectionDrag.RenderConn = nil
	end

	local Section = SectionDrag.Section
	if not Section then
		ClearSectionDragVisuals()
		return
	end

	local Frame = Section.Frame
	local TargetColumn = SectionDrag.TargetParent or SectionDrag.SourceParent
	local InsertIndex = SectionDrag.TargetIndex or 0

	ClearSectionDragVisuals()

	if Commit and TargetColumn then

		local Sections = ListColumnSections(TargetColumn, Frame)
		InsertIndex = MC(InsertIndex, 0, #Sections)

		Frame.Parent = TargetColumn
		Frame.Visible = true
		Frame.BackgroundTransparency = 0
		Section.Side = TargetColumn.Name

		local Order = 0
		for Index, Sibling in Sections do
			if Index - 1 == InsertIndex then
				Frame.LayoutOrder = Order
				Order = Order + 1
			end
			Sibling.LayoutOrder = Order
			Order = Order + 1
		end
		if InsertIndex >= #Sections then
			Frame.LayoutOrder = Order
		end

		if SectionDrag.SourceParent and SectionDrag.SourceParent ~= TargetColumn then
			NormalizeColumnOrders(SectionDrag.SourceParent)
		end
		NormalizeColumnOrders(TargetColumn)
		if SectionDrag.SourceParent and SectionDrag.SourceParent ~= TargetColumn then
			NormalizeColumnOrders(SectionDrag.SourceParent)
		end
		pcall(function() Library.SaveLayout() end)

	else
		Frame.Parent = SectionDrag.SourceParent
		Frame.LayoutOrder = SectionDrag.SourceOrder
		Frame.Visible = true
		Frame.BackgroundTransparency = 0
		if SectionDrag.SourceParent then
			NormalizeColumnOrders(SectionDrag.SourceParent)
		end
	end

	SectionDrag.Section = nil
	SectionDrag.SourceParent = nil
	SectionDrag.TargetParent = nil
end

local function GetColumnAtPosition(PageFrame: Frame, ScreenPos: Vector2): Frame?
	local Left = PageFrame:FindFirstChild("Left")
	local Right = PageFrame:FindFirstChild("Right")
	if not Left or not Right then
		return nil
	end

	local MidX = (Left.AbsolutePosition.X + Left.AbsoluteSize.X + Right.AbsolutePosition.X) * 0.5
	if ScreenPos.X < MidX then
		return Left :: Frame
	end
	return Right :: Frame
end

local function ComputeInsertIndex(Column: Frame, ScreenY: number, Exclude: Frame?): number
	local Candidates = ListColumnSections(Column, Exclude)

	for Index, Child in Candidates do
		local Mid = Child.AbsolutePosition.Y + Child.AbsoluteSize.Y * 0.5
		if ScreenY < Mid then
			return Index - 1
		end
	end

	return #Candidates
end

local function EnsurePlaceholder(Height: number): Frame
	if SectionDrag.Placeholder then
		return SectionDrag.Placeholder
	end

	local Placeholder = Add("Frame", {
		Name = "SectionPlaceholder";
		BackgroundColor3 = RGB(78, 88, 129);
		BackgroundTransparency = 0.65;
		BorderSizePixel = 0;
		Size = UD2(1, 0, 0, Height);
		ZIndex = 5;
	}) :: Frame
	Add("UICorner", { Parent = Placeholder; CornerRadius = UD(0, 5); })
	Add("UIStroke", {
		Parent = Placeholder;
		ApplyStrokeMode = ASM.Border;
		Color = RGB(138, 156, 229);
		Thickness = 1.5;
		Transparency = 0.2;
	})

	SectionDrag.Placeholder = Placeholder
	return Placeholder
end

local function UpdateSectionDrag(MousePos: Vector2)
	if not SectionDrag.Active or not SectionDrag.Section then
		return
	end

	local Section = SectionDrag.Section
	local Frame = Section.Frame
	local PageFrame = Section.PageFrame
	if not PageFrame then
		return
	end

	if SectionDrag.Ghost then
		local Target = UFO(MousePos.X - SectionDrag.Offset.X, MousePos.Y - SectionDrag.Offset.Y)
		SectionDrag.Ghost.Position = SectionDrag.Ghost.Position:Lerp(Target, 0.45)
	end

	local Column = GetColumnAtPosition(PageFrame, MousePos)
	if not Column then
		return
	end

	local InsertIndex = ComputeInsertIndex(Column, MousePos.Y, Frame)
	SectionDrag.TargetParent = Column
	SectionDrag.TargetIndex = InsertIndex

	local Placeholder = EnsurePlaceholder(SectionDrag.DragHeight)
	Placeholder.Size = UD2(1, 0, 0, SectionDrag.DragHeight)

	RelayoutColumn(Column, Placeholder, InsertIndex, Frame)

	local PageLeft = PageFrame:FindFirstChild("Left")
	local PageRight = PageFrame:FindFirstChild("Right")
	local Other = if Column == PageLeft then PageRight else PageLeft
	if Other and Other ~= Column then

		if SectionDrag.Placeholder and SectionDrag.Placeholder.Parent == Other then
			SectionDrag.Placeholder.Parent = Column
		end
		RelayoutColumn(Other :: Frame, nil, 0, Frame)
	end
end

local function BeginSectionDrag(Section: any, Input: InputObject)
	if SectionDrag.Active then
		return
	end

	local Frame = Section.Frame
	if not Frame:FindFirstChild("Header") then
		return
	end

	SectionDrag.Active = true
	SectionDrag.Section = Section
	SectionDrag.SourceParent = Frame.Parent :: Frame
	SectionDrag.SourceOrder = Frame.LayoutOrder
	SectionDrag.TargetParent = SectionDrag.SourceParent
	SectionDrag.TargetIndex = Frame.LayoutOrder
	SectionDrag.DragHeight = math.max(Frame.AbsoluteSize.Y, 60)
	SectionDrag.DragWidth = Frame.AbsoluteSize.X
	SectionDrag.Offset = V2(
		Input.Position.X - Frame.AbsolutePosition.X,
		Input.Position.Y - Frame.AbsolutePosition.Y
	)

	Frame.Visible = false
	Frame.Parent = Library._Instance

	local Ghost = Frame:Clone()
	Ghost.Name = "SectionGhost"
	Ghost.Parent = Library._Instance
	Ghost.Visible = true
	Ghost.BackgroundTransparency = 0.2
	Ghost.Size = UFO(SectionDrag.DragWidth, SectionDrag.DragHeight)
	Ghost.Position = UFO(
		Input.Position.X - SectionDrag.Offset.X,
		Input.Position.Y - SectionDrag.Offset.Y
	)
	Ghost.ZIndex = PopupZ + 5
	Ghost.AutomaticSize = AS.None

	for _, Desc in Ghost:GetDescendants() do
		if Desc:IsA("GuiObject") then
			if Desc:IsA("TextLabel") or Desc:IsA("TextButton") or Desc:IsA("TextBox") then
				Desc.TextTransparency = math.min(Desc.TextTransparency + 0.3, 0.8)
			elseif Desc:IsA("ImageLabel") or Desc:IsA("ImageButton") then
				Desc.ImageTransparency = math.min(Desc.ImageTransparency + 0.3, 0.8)
			elseif Desc:IsA("Frame") and Desc.BackgroundTransparency < 1 then
				Desc.BackgroundTransparency = math.min(Desc.BackgroundTransparency + 0.15, 0.85)
			end
		end
	end

	SectionDrag.Ghost = Ghost

	local Placeholder = EnsurePlaceholder(SectionDrag.DragHeight)
	local SourceSections = ListColumnSections(SectionDrag.SourceParent, Frame)
	local StartIndex = 0
	for Index, Sibling in SourceSections do
		if Sibling.LayoutOrder >= SectionDrag.SourceOrder then
			StartIndex = Index - 1
			break
		end
		StartIndex = Index
	end
	SectionDrag.TargetIndex = StartIndex
	RelayoutColumn(SectionDrag.SourceParent, Placeholder, StartIndex, Frame)

	if SectionDrag.RenderConn then
		SectionDrag.RenderConn:Disconnect()
	end

	SectionDrag.RenderConn = RunService.RenderStepped:Connect(function()
		if not SectionDrag.Active then
			return
		end
		local Mouse = UserInputService:GetMouseLocation()
		local GuiService = Services:GetService("GuiService")
		local Inset = GuiService:GetGuiInset()
		UpdateSectionDrag(V2(Mouse.X, Mouse.Y - Inset.Y))
	end)

	UpdateSectionDrag(V2(Input.Position.X, Input.Position.Y))
end

UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType ~= UIT.MouseButton1 and Input.UserInputType ~= UIT.Touch then
		return
	end
	if SectionDrag.Active then
		StopSectionDrag(true)
	end
end)

local function SectionBuilder(Container: Frame)
	return function(self: Library, propertyTable: {})
		local Section = Overwrite({
			Name = "",
			Icon = "box",
			Side = "Left",
		}, propertyTable or {})
		setmetatable(Section, { __index = Library.Elements })

		local Column = Container[Section.Side]
		local NextOrder = 0
		for _, Child in Column:GetChildren() do
			if Child:IsA("Frame") and Child.Name == "Section" then
				NextOrder = math.max(NextOrder, Child.LayoutOrder + 1)
			end
		end

		local SectionFrame = Add("Frame", {
			Parent = Column;
			Name = "Section";
			AutomaticSize = AS.Y;
			BackgroundColor3 = RGB(15, 14, 15);
			BorderColor3 = RGB(0, 0, 0);
			BorderSizePixel = 0;
			Size = UFS(1, 0);
			LayoutOrder = NextOrder;
		}) :: Frame
		local Header = Add("Frame", {
			Parent = SectionFrame;
			Name = "Header";
			BackgroundColor3 = RGB(20, 20, 21);
			BorderColor3 = RGB(0, 0, 0);
			BorderSizePixel = 0;
			Size = UD2(1, 0, 0, 35);
		}) :: Frame
		local Elements = Add("Frame", {
			Parent = SectionFrame;
			Name = "Elements";
			AutomaticSize = AS.Y;
			BackgroundColor3 = RGB(255, 255, 255);
			BackgroundTransparency = 1;
			BorderColor3 = RGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UFO(0, 35);
			Size = UFS(1, 0);
		}) :: Frame
		Add("UICorner", { Parent = SectionFrame; CornerRadius = UD(0, 5); })
		Add("UICorner", { Parent = Header; BottomLeftRadius = UD(0, 0); BottomRightRadius = UD(0, 0); TopLeftRadius = UD(0, 5); TopRightRadius = UD(0, 5); })
		Add("ImageLabel", {
			Parent = Header;
			Name = "Icon";
			BackgroundColor3 = RGB(255, 255, 255);
			BackgroundTransparency = 1;
			BorderColor3 = RGB(0, 0, 0);
			BorderSizePixel = 0;
			Image = ResolveIcon(Section.Icon);
			Position = UFS(0, 0.5);
			Size = UFO(16, 16);
		})
		Add("UIListLayout", {
			Parent = Header;
			FillDirection = FD.Horizontal;
			Padding = UD(0, 5);
			SortOrder = SO.LayoutOrder;
			VerticalAlignment = VFA.Center;
		})
		Add("UIPadding", { Parent = Header; PaddingLeft = UD(0, 10); })
		Add("TextLabel", {
			Parent = Header;
			Name = "Title";
			AutomaticSize = AS.XY;
			BackgroundColor3 = RGB(255, 255, 255);
			BackgroundTransparency = 1;
			BorderColor3 = RGB(0, 0, 0);
			BorderSizePixel = 0;
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			LayoutOrder = 1;
			Text = Section.Name;
			TextColor3 = RGB(255, 255, 255);
			TextSize = 14;
		})
		local SectionStroke = Add("UIStroke", { Parent = SectionFrame; ApplyStrokeMode = ASM.Border; Color = Library.Theme.SectionBorder; Thickness = 1; })
		Library.ThemeLink(SectionFrame, "BackgroundColor3", "Surface")
		Library.ThemeLink(SectionStroke, "Color", "SectionBorder")
		Add("UIPadding", {
			Parent = Elements;
			PaddingBottom = UD(0, 10);
			PaddingLeft = UD(0, 10);
			PaddingRight = UD(0, 10);
			PaddingTop = UD(0, 10);
		})
		Add("UIListLayout", { Parent = Elements; Padding = UD(0, 10); SortOrder = SO.LayoutOrder; })

		Section.Content = Elements
		Section.Frame = SectionFrame
		Section.PageFrame = Container
		Section.Side = Section.Side

		local DragThreshold = 6

		Header.InputBegan:Connect(function(Input)
			if Input.UserInputType ~= UIT.MouseButton1 and Input.UserInputType ~= UIT.Touch then
				return
			end
			if SectionDrag.Active then
				return
			end

			local PressPos = Input.Position
			local MoveConn: RBXScriptConnection?
			local EndConn: RBXScriptConnection?

			local function Cleanup()
				if MoveConn then
					MoveConn:Disconnect()
					MoveConn = nil
				end
				if EndConn then
					EndConn:Disconnect()
					EndConn = nil
				end
			end

			MoveConn = UserInputService.InputChanged:Connect(function(MoveInput)
				if MoveInput.UserInputType ~= UIT.MouseMovement and MoveInput.UserInputType ~= UIT.Touch then
					return
				end
				if SectionDrag.Active then
					Cleanup()
					return
				end

				local Delta = (MoveInput.Position - PressPos).Magnitude
				if Delta >= DragThreshold then
					Cleanup()
					BeginSectionDrag(Section, MoveInput)
				end
			end)

			EndConn = Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Cleanup()
				end
			end)
		end)

		TIS(Library.Sections, Section)
		return Section
	end
end

local function PageContent(Entry: {}, Container: Frame, Registry: {}, OnOpen: (() -> ())?, OnClose: (() -> ())?)
	local ContentFrame = Add("Frame", { Parent = Container; Name = "PageFrame"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(0, 0, 0, 12); Size = UFS(1, 1); Visible = false; }) :: Frame

	local function MakeColumn(Name: string, Props: {}): ScrollingFrame
		local Column = Add("ScrollingFrame", {
			Parent = ContentFrame;
			Name = Name;
			BackgroundColor3 = RGB(255, 255, 255);
			BackgroundTransparency = 1;
			BorderColor3 = RGB(0, 0, 0);
			BorderSizePixel = 0;
			ScrollBarThickness = 0;
			ScrollBarImageColor3 = RGB(78, 88, 129);
			ScrollBarImageTransparency = 1;
			ScrollingDirection = SBD.Y;
			CanvasSize = UD2(0, 0, 0, 0);
			AutomaticCanvasSize = AS.Y;
			ElasticBehavior = Enum.ElasticBehavior.Never;
			ClipsDescendants = true;
		}) :: ScrollingFrame

		for Key, Value in Props do
			Column[Key] = Value
		end

		Add("UIListLayout", { Parent = Column; Padding = UD(0, 12); SortOrder = SO.LayoutOrder; })

		Add("UIPadding", {
			Parent = Column;
			PaddingLeft = UD(0, 2);
			PaddingRight = UD(0, 6);
			PaddingTop = UD(0, 2);
			PaddingBottom = UD(0, 8);
		})

		return Column
	end

	local Left = MakeColumn("Left", {
		Size = UD2(0.5, -6, 1, 0);
	})
	local Right = MakeColumn("Right", {
		AnchorPoint = V2(1, 0);
		Position = UFS(1, 0);
		Size = UD2(0.5, -6, 1, 0);
	})

	Entry.Frame = ContentFrame
	Entry.Section = SectionBuilder(ContentFrame)
	Library.PageFrames = Library.PageFrames or {}
	Library.PageFrames[ContentFrame] = Entry

	Entry.IsOpen = false

	Entry.Open = function()

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
		Callback = function() end
	}, propertyTable or {})

	local Decimals = MM(#(tostring(Slider.Increment):match("%.(%d+)") or ""), 4)

	local SliderFrame = Add("Frame", { Parent = self.Content; Name = "SliderFrame"; AutomaticSize = AS.Y; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 0); }) :: Frame
	local Button = Add("TextButton", { Parent = SliderFrame; Name = "Button"; AutoButtonColor = false; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Position = UFO(0, 18); Size = UD2(1, 0, 0, 12); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
	local Overlay = Add("Frame", { Parent = Button; Name = "Overlay"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(0, 0, 1, 0); }) :: Frame
	local Circle = Add("Frame", { Parent = Button; Name = "Circle"; AnchorPoint = V2(1, 0.5); BackgroundColor3 = RGB(0, 0, 0); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(1, -3, 0.5, 0); Size = UFO(8, 8); }) :: Frame
	Add("TextLabel", { Parent = SliderFrame; Name = "Title"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UFO(0, 9); Text = Slider.Name; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.2; })
	local Amount = Add("TextLabel", { Parent = SliderFrame; Name = "Amount"; AnchorPoint = V2(1, 0); AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Position = UFS(1, 0); Size = UFO(0, 9); Text = ""; TextColor3 = RGB(255, 255, 255); TextSize = 13; }) :: TextLabel
	Add("UICorner", { Parent = Button; CornerRadius = UD(0, 5); })
	local SliderGrad = Add("UIGradient", { Parent = Overlay; Color = CS{ CSK(0, Library.Theme.AccentDark), CSK(1, Library.Theme.Accent) }; Rotation = -90; })
	Library.ThemeLink(SliderGrad, "Gradient", "AccentDark", "Accent")
	Add("UICorner", { Parent = Overlay; CornerRadius = UD(0, 5); })
	Add("UICorner", { Parent = Circle; CornerRadius = UD(1, 0); })

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

	if propertyTable and propertyTable.Flag then
		Slider.Flag = propertyTable.Flag
		Library.RegisterFlag(Slider.Flag, { Value = Slider.Value; Set = Slider.Set })
	end

	Slider.Set(Slider.Value)
	return Slider
end

Library.Elements.Dropdown = function(self: Library, propertyTable: {})
	local Dropdown = Overwrite({
		Name = "",
		Options = {},
		Value = "",
		Multi = false,
		Search = false,
		Callback = function() end,
	}, propertyTable or {})

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

	local Buttons = {}

	local function GetMultiValue(): { string }
		if type(Dropdown.Value) ~= "table" then
			return {}
		end
		return Dropdown.Value
	end

	local function IsSelected(Option: string): boolean
		if Dropdown.Multi then
			return TF(GetMultiValue(), Option) ~= nil
		end
		return Dropdown.Value == Option
	end

	local function Highlight()
		for _, Button in Buttons do
			local Selected = IsSelected(Button.Text)
			Tween(Button, {
				BackgroundTransparency = Selected and 0 or 1;
				TextTransparency = Selected and 0.15 or 0.45;
				BackgroundColor3 = Selected and RGB(28, 30, 38) or RGB(20, 20, 21);
			}, 0.1)
		end
	end

	local function Choose(Option: string)
		if not Dropdown.Multi then
			Dropdown.Set(Option)
			Dropdown.Open(false)
			return
		end

		local Selected = TC(GetMultiValue())
		local Index = TF(Selected, Option)

		if Index then
			TR(Selected, Index)
		else
			TIS(Selected, Option)
		end

		Dropdown.Set(Selected)
	end

	local SearchBoxDrop = nil
	if Dropdown.Search then
		SearchBoxDrop = Add("TextBox", {
			Parent = OptionList;
			Name = "SearchBox";
			BackgroundColor3 = RGB(20, 20, 21);
			BorderSizePixel = 0;
			ClearTextOnFocus = false;
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			PlaceholderText = "Search…";
			PlaceholderColor3 = RGB(255, 255, 255);
			Text = "";
			TextColor3 = RGB(255, 255, 255);
			TextSize = 13;
			TextTransparency = 0.2;
			TextXAlignment = TXA.Left;
			Size = UD2(1, 0, 0, 26);
			LayoutOrder = -1;
		})
		Add("UIPadding", { Parent = SearchBoxDrop; PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); })
		Add("UICorner", { Parent = SearchBoxDrop; CornerRadius = UD(0, 5); })
		SearchBoxDrop:GetPropertyChangedSignal("Text"):Connect(function()
			Build()
		end)
	end

	local function Build()
		for _, Button in Buttons do
			Button:Destroy()
		end

		table.clear(Buttons)

		local Filter = SearchBoxDrop and SearchBoxDrop.Text:lower() or ""
		local VisibleOptions = {}
		for _, Option in Dropdown.Options do
			if Filter == "" or tostring(Option):lower():find(Filter, 1, true) then
				TIS(VisibleOptions, Option)
			end
		end

		for Index, Option in VisibleOptions do
			local Button = Add("TextButton", { Parent = OptionList; Name = Option; AutoButtonColor = false; BackgroundColor3 = RGB(20, 20, 21); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); LayoutOrder = Index; Size = UD2(1, 0, 0, 22); Text = Option; TextColor3 = RGB(255, 255, 255); TextSize = 13; TextTransparency = 0.5; TextWrapped = true; TextXAlignment = TXA.Left; }) :: TextButton
			Add("UIPadding", { Parent = Button; PaddingLeft = UD(0, 10); PaddingRight = UD(0, 10); })

			local First = Index == 1
			local Last = Index == #VisibleOptions

			Add("UICorner", { Parent = Button;
				TopLeftRadius = First and UD(0, 5) or UD(0, 0);
				TopRightRadius = First and UD(0, 5) or UD(0, 0);
				BottomLeftRadius = Last and UD(0, 5) or UD(0, 0);
				BottomRightRadius = Last and UD(0, 5) or UD(0, 0);
			})

			Button.MouseEnter:Connect(function()
				if not IsSelected(Option) then
					Tween(Button, { BackgroundTransparency = 0.35; BackgroundColor3 = Library.Theme.SurfaceAlt }, 0.08)
				end
			end)
			Button.MouseLeave:Connect(function()
				local Selected = IsSelected(Option)
				Tween(Button, {
					BackgroundTransparency = Selected and 0 or 1;
					BackgroundColor3 = Selected and RGB(28, 30, 38) or RGB(20, 20, 21);
				}, 0.08)
			end)
			Button.Activated:Connect(function()
				Choose(Option)
			end)

			TIS(Buttons, Button)
		end

		Highlight()
	end

	Dropdown.Set = function(Value: string | { string })
		if Dropdown.Multi then
			if type(Value) ~= "table" then
				Value = Value ~= nil and Value ~= "" and { tostring(Value) } or {}
			end
			Dropdown.Value = Value
			InputText.Text = #Value > 0 and TCC(Value, ", ") or "None"
		else
			Dropdown.Value = Value
			InputText.Text = tostring(Value or "")
		end

		if Dropdown.Flag then
			Library.Flags[Dropdown.Flag] = Library.Flags[Dropdown.Flag] or {}
			Library.Flags[Dropdown.Flag].Value = Dropdown.Value
			Library.Flags[Dropdown.Flag].Set = Dropdown.Set
		end

		Highlight()
		Dropdown.Callback(Dropdown.Value)
	end

	Dropdown.UpdateOptions = function(NewOptions: { string })
		Dropdown.Options = NewOptions
		Build()

		if Dropdown.Multi then
			local Kept = {}
			local Current = type(Dropdown.Value) == "table" and Dropdown.Value or {}
			for _, Option in Current do
				if TF(NewOptions, Option) then
					TIS(Kept, Option)
				end
			end

			Dropdown.Set(Kept)
		elseif not TF(NewOptions, Dropdown.Value) then
			Dropdown.Set(NewOptions[1] or "")
		end
	end

	Dropdown.Frame = OptionList
	Dropdown.Button = ButtonFrame

	Dropdown.Close = function()
		Dropdown.Open(false)
	end

	Dropdown.Open = function(State: boolean?)
		if State == nil then
			State = not OptionList.Visible
		end

		if State then
			ClaimPopup(Dropdown)

			OptionList.Size = UFO(InputFrame.AbsoluteSize.X, 0)

			local Target = UFO(
				InputFrame.AbsolutePosition.X,
				InputFrame.AbsolutePosition.Y + InputFrame.AbsoluteSize.Y + 4
			)

			OptionList.Position = Target - UFO(0, 8)
			OptionList.Visible = true
			Tween(OptionList, { Position = Target }, 0.22, ES.Quint)
		else
			OptionList.Visible = false
			ReleasePopup(Dropdown)
		end

		Tween(Icon, { Rotation = State and 180 or 0 }, 0.18)
	end

	local LastToggle = 0

	local function Activate()
		if os.clock() - LastToggle < 0.18 then
			return
		end
		LastToggle = os.clock()

		Dropdown.Open(not OptionList.Visible)
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

	if propertyTable and propertyTable.Flag then
		Dropdown.Flag = propertyTable.Flag
		Library.RegisterFlag(Dropdown.Flag, { Value = Dropdown.Value; Set = Dropdown.Set })
	end

	if Dropdown.Multi then

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
		Callback = function() end,
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

	Box.FocusLost:Connect(function()
		Input.Set(Box.Text)
	end)

	InputFrame.InputBegan:Connect(function(InputObject)
		if InputObject.UserInputType ~= UIT.MouseButton1 and InputObject.UserInputType ~= UIT.Touch then
			return
		end

		Box:CaptureFocus()
	end)

	if propertyTable and propertyTable.Flag then
		Input.Flag = propertyTable.Flag
		Library.RegisterFlag(Input.Flag, { Value = Input.Value; Set = Input.Set })
	end

	TIS(Library.Searchable, { Frame = TextBox; Text = Input.Name; Section = self })
	return Input
end

Library.Elements.Button = function(self: Library, propertyTable: {})
	local Button = Overwrite({
		Name = "Button";
		Callback = function() end;
		Height = 30;
		Width = 1;
	}, propertyTable or {})

	local Width = typeof(Button.Width) == "number" and MC(Button.Width, 0.2, 1) or 1

	local ParentFrame = self.Content
	if Width < 0.999 then
		if not self._ButtonRow or self._ButtonRowRemain < Width - 0.001 then
			self._ButtonRow = Add("Frame", {
				Parent = self.Content;
				Name = "ButtonRow";
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Size = UD2(1, 0, 0, Button.Height);
			})
			Add("UIListLayout", {
				Parent = self._ButtonRow;
				FillDirection = FD.Horizontal;
				Padding = UD(0, 8);
				SortOrder = SO.LayoutOrder;
			})
			self._ButtonRowRemain = 1
		end
		ParentFrame = self._ButtonRow
		self._ButtonRowRemain = self._ButtonRowRemain - Width
		if self._ButtonRowRemain <= 0.05 then
			self._ButtonRow = nil
			self._ButtonRowRemain = 0
		end
	else
		self._ButtonRow = nil
		self._ButtonRowRemain = 0
	end

	local Frame = Add("Frame", {
		Parent = ParentFrame;
		Name = "ButtonFrame";
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Size = UD2(Width, Width < 1 and -4 or 0, 1, 0);
	})
	if Width >= 0.999 then
		Frame.Size = UD2(1, 0, 0, Button.Height)
	end

	local Click = Add("TextButton", {
		Parent = Frame;
		Name = "Click";
		AutoButtonColor = false;
		BackgroundColor3 = RGB(22, 22, 24);
		BorderSizePixel = 0;
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		Size = UFS(1, 1);
		Text = Button.Name;
		TextColor3 = RGB(255, 255, 255);
		TextSize = 13;
		TextTransparency = 0.12;
	})
	Add("UICorner", { Parent = Click; CornerRadius = UD(0, 6); })
	local BtnStroke = Add("UIStroke", { Parent = Click; ApplyStrokeMode = ASM.Border; Color = Library.Theme.Border; })
	Library.ThemeLink(BtnStroke, "Color", "Border")
	local Grad = Add("UIGradient", {
		Parent = Click;
		Color = CS{ CSK(0, Library.Theme.AccentDark), CSK(1, Library.Theme.Accent) };
		Rotation = -90;
		Enabled = false;
	})
	Library.ThemeLink(Grad, "Gradient", "AccentDark", "Accent")
	Library.ThemeLink(Click, "BackgroundColor3", "SurfaceAlt")

	Click.MouseEnter:Connect(function()
		Grad.Enabled = true
		Tween(Click, { BackgroundColor3 = RGB(255, 255, 255); TextColor3 = RGB(12, 12, 14); TextTransparency = 0 }, 0.12)
	end)
	Click.MouseLeave:Connect(function()
		Grad.Enabled = false
		Tween(Click, { BackgroundColor3 = Library.Theme.SurfaceAlt; TextColor3 = Library.Theme.Text; TextTransparency = 0.12 }, 0.12)
	end)
	Click.Activated:Connect(function()
		Button.Callback()
	end)

	Button.SetText = function(Text: string)
		Button.Name = Text
		Click.Text = Text
	end
	Button.Frame = Frame
	Button.Click = Click

	TIS(Library.Searchable, { Frame = Frame; Text = Button.Name; Section = self })
	return Button
end

Library.Elements.Paragraph = function(self: Library, propertyTable: {})
	local Paragraph = Overwrite({
		Title = "";
		Body = "";
	}, propertyTable or {})

	local Frame = Add("Frame", {
		Parent = self.Content;
		Name = "Paragraph";
		AutomaticSize = AS.Y;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Size = UFS(1, 0);
	})
	if Paragraph.Title ~= "" then
		Add("TextLabel", {
			Parent = Frame;
			BackgroundTransparency = 1;
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			Size = UD2(1, 0, 0, 16);
			Text = Paragraph.Title;
			TextColor3 = RGB(255, 255, 255);
			TextSize = 13;
			TextTransparency = 0.15;
			TextXAlignment = TXA.Left;
		})
	end
	local Body = Add("TextLabel", {
		Parent = Frame;
		BackgroundTransparency = 1;
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		Position = Paragraph.Title ~= "" and UFO(0, 18) or UFO(0, 0);
		AutomaticSize = AS.Y;
		Size = UD2(1, 0, 0, 0);
		Text = Paragraph.Body;
		TextColor3 = RGB(255, 255, 255);
		TextSize = 12;
		TextTransparency = 0.45;
		TextWrapped = true;
		TextXAlignment = TXA.Left;
		TextYAlignment = TYA.Top;
	})
	Paragraph.Frame = Frame
	Paragraph.SetBody = function(Text: string)
		Paragraph.Body = Text
		Body.Text = Text
	end
	Paragraph.SetTitle = function(Text: string)
		Paragraph.Title = Text
	end

	TIS(Library.Searchable, { Frame = Frame; Text = Paragraph.Title .. " " .. Paragraph.Body; Section = self })
	return Paragraph
end

Library.SubElements.Toggle = function(self: Library, propertyTable: {})
	local Toggle = Overwrite({
		State = false,
		Callback = function() end
	}, propertyTable or {})

	local Button = Add("TextButton", { Parent = self.LeftContent; Name = "Toggle"; AutoButtonColor = false; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFO(28, 14); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
	local Indicator = Add("Frame", { Parent = Button; Name = "Indicator"; AnchorPoint = V2(1, 0.5); BackgroundColor3 = RGB(0, 0, 0); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(1, -3, 0.5, 0); Size = UFO(10, 10); ZIndex = 2; }) :: Frame
	local Overlay = Add("Frame", { Parent = Button; Name = "Overlay"; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(1, 1); }) :: Frame
	Add("UICorner", { Parent = Button; CornerRadius = UD(0, 6); })
	Add("UICorner", { Parent = Indicator; CornerRadius = UD(1, 0); })
	Add("UICorner", { Parent = Overlay; CornerRadius = UD(0, 6); })
	local ToggleGrad = Add("UIGradient", { Parent = Overlay; Color = CS{ CSK(0, Library.Theme.AccentDark), CSK(1, Library.Theme.Accent) }; Rotation = -90; })
	Library.ThemeLink(ToggleGrad, "Gradient", "AccentDark", "Accent")

	Toggle.Set = function(state: boolean?, Silent: boolean?)
		state = state or not Toggle.State
		Toggle.State = state

		Tween(Overlay, { BackgroundTransparency = state and 0 or 1 }, 0.1)
		Tween(Indicator, { Position = state and UD2(1, -3, 0.5, 0) or UD2(0, 3, 0.5, 0), AnchorPoint = state and V2(1, 0.5) or V2(0, 0.5)}, 0.1)

		if Toggle.Flag then
			Library.Flags[Toggle.Flag] = Library.Flags[Toggle.Flag] or {}
			Library.Flags[Toggle.Flag].Value = state
			Library.Flags[Toggle.Flag].Set = Toggle.Set
		end

		if not Silent and Library.NotifyToggles and Library.Notify then
			local Label = self.Text or Toggle.Flag or "Toggle"
			Library.Notify({
				Title = Label;
				Text = state and "Enabled" or "Disabled";
				Type = state and "Success" or "Info";
				Duration = 1.6;
			})
		end

		Toggle.Callback(state)
	end

	if propertyTable and propertyTable.Flag then
		Toggle.Flag = propertyTable.Flag
		Library.RegisterFlag(Toggle.Flag, { Value = Toggle.State; Set = Toggle.Set })
	end

	Button.Activated:Connect(function()
		Toggle.Set()
	end)

	Toggle.Set(Toggle.State, true)
	return Toggle
end

Library.SubElements.Keybind = function(self: Library, propertyTable: {})
	local Keybind = Overwrite({
		Title = "",
		State = false,
		Type = "Toggle",
		Callback = function() end,
	}, propertyTable or {})

	local Settings = Add("ImageButton", { Parent = self.RightContent; Name = "Settings"; AutoButtonColor = false; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Image = "rbxassetid://132030186847627"; ImageTransparency = 0.5; ResampleMode = Enum.ResamplerMode.Pixelated; Size = UFO(15, 15); }) :: ImageButton
	Keybind.Settings = Settings

	local Popup = Add("Frame", { Parent = Library._Instance; Name = "Popup"; Active = true; BackgroundColor3 = RGB(9, 8, 8); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(0.3753760755062103, 0.30920326709747314); Size = UFO(180, 119); Visible = false; ZIndex = PopupZ; }) :: Frame
	Keybind.Frame = Popup

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

	local Listening = false

	local function Format(Key: EnumItem?): string
		if not Key then
			return "—"
		end
		return Keys[Key.Name] or Key.Name
	end

	local function Matches(Input: InputObject): boolean
		return Keybind.Key ~= nil and (Input.KeyCode == Keybind.Key or Input.UserInputType == Keybind.Key)
	end

	Keybind.Set = function(Key: EnumItem?)
		Keybind.Key = Key
		KeyButton.Text = Format(Key)
		local Title = Keybind.Title ~= "" and Keybind.Title or (self.Text or "Keybind")
		Library.KeybindRegistry = Library.KeybindRegistry or {}
		Library.KeybindRegistry[Title] = {
			Name = Title;
			KeyText = Format(Key);
			Active = Keybind.State == true;
			Mode = Keybind.Type or "Toggle";
		}
		Library.UpdateKeybindList(Title, Format(Key), Keybind.State, Keybind.Type)
	end

	Keybind.SetType = function(Type: string)
		Keybind.Type = Type
		local Held = Type == "Hold"

		local function Mode(Button: TextButton, Gradient: UIGradient, Label: TextLabel, Active: boolean)
			if Active then
				Gradient.Enabled = true
			end

			local Fade = Tween(Button, { BackgroundColor3 = Active and RGB(255, 255, 255) or RGB(20, 20, 21) }, 0.15)
			Tween(Label, { TextColor3 = Active and RGB(0, 0, 0) or RGB(255, 255, 255); TextTransparency = Active and 0 or 0.5 }, 0.15)

			if not Active then
				Fade.Completed:Once(function()

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
		local Title = Keybind.Title ~= "" and Keybind.Title or (self.Text or "Keybind")
		Library.KeybindRegistry = Library.KeybindRegistry or {}
		if Library.KeybindRegistry[Title] then
			Library.KeybindRegistry[Title].Active = Keybind.State == true
			Library.KeybindRegistry[Title].Mode = Keybind.Type or "Toggle"
		end
		Library.UpdateKeybindList(Title, Format(Keybind.Key), Keybind.State, Keybind.Type)
		Keybind.Callback(Keybind.State)
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Keybind.Type ~= "Hold" or not Keybind.State or not Matches(Input) then
			return
		end

		Keybind.State = false
		local Title = Keybind.Title ~= "" and Keybind.Title or (self.Text or "Keybind")
		Library.KeybindRegistry = Library.KeybindRegistry or {}
		if Library.KeybindRegistry[Title] then
			Library.KeybindRegistry[Title].Active = false
		end
		Library.UpdateKeybindList(Title, Format(Keybind.Key), false, Keybind.Type)
		Keybind.Callback(false)
	end)

	BindDrag(Popup, Header)

	if propertyTable and propertyTable.Flag then
		Keybind.Flag = propertyTable.Flag
		Library.RegisterFlag(Keybind.Flag, { Value = Keybind.Key; Set = Keybind.Set })
	end

	Keybind.SetType(Keybind.Type)
	Keybind.Set(Keybind.Key)

	task.defer(function()
		local Title = Keybind.Title ~= "" and Keybind.Title or (self.Text or "Keybind")
		Library.UpdateKeybindList(Title, Format(Keybind.Key), false, Keybind.Type)
	end)
	return Keybind
end

Library.SubElements.Colorpicker = function(self: Library, propertyTable: {})
	local Colorpicker = Overwrite({
		Title = "",
		Color = RGB(255, 0, 0),
		Transparency = 0,
		Callback = function() end,
	}, propertyTable or {})

	local Hue, Saturation, Value = Colorpicker.Color:ToHSV()

	local Button = Add("TextButton", { Parent = self.RightContent; Name = "Button"; AutoButtonColor = false; BackgroundColor3 = RGB(255, 255, 255); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFO(15, 15); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; }) :: TextButton
	Add("UICorner", { Parent = Button; CornerRadius = UD(0, 7); })
	Add("UIGradient", { Parent = Button; Color = CS{ CSK(0, RGB(163, 163, 163)), CSK(1, RGB(255, 255, 255)) }; Rotation = -90; })

	Colorpicker.Button = Button

	local ColorpickerFrame = Add("Frame", { Parent = Library._Instance; Name = "ColorpickerFrame"; Active = true; AutomaticSize = AS.Y; BackgroundColor3 = RGB(9, 8, 8); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(0.3759043514728546, 0.058557264506816864); Size = UFO(199, 0); Visible = false; ZIndex = PopupZ; }) :: Frame
	Colorpicker.Frame = ColorpickerFrame

	Add("TextButton", { Parent = ColorpickerFrame; Name = "Catcher"; AutoButtonColor = false; BackgroundTransparency = 1; BorderSizePixel = 0; Size = UFS(1, 1); Text = ""; })
	local Header = Add("Frame", { Parent = ColorpickerFrame; Name = "Header"; BackgroundColor3 = RGB(20, 20, 21); BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(1, 0, 0, 35); }) :: Frame

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

	local function Update()
		Colorpicker.Color = HSV(Hue, Saturation, Value)

		SaturationGradient.Color = CS{ CSK(0, RGB(255, 255, 255)), CSK(1, HSV(Hue, 1, 1)) }
		AlphaGradient.Color = CS{ CSK(0, RGB(255, 255, 255)), CSK(1, Colorpicker.Color) }

		Tween(SaturationCursor, { Position = UFS(Saturation, 1 - Value), BackgroundColor3 = Colorpicker.Color }, 0.08)
		Tween(HueCursor, { AnchorPoint = V2(1 - Hue, 0), Position = UD2(1 - Hue, 0, 0, -2) }, 0.08)
		Tween(AlphaCursor, { AnchorPoint = V2(1 - Colorpicker.Transparency, 0), Position = UD2(1 - Colorpicker.Transparency, 0, 0, -2) }, 0.08)

		Tween(Button, { BackgroundColor3 = Colorpicker.Color, BackgroundTransparency = Colorpicker.Transparency }, 0.15)

		if Colorpicker.Flag and Library.Flags[Colorpicker.Flag] then
			Library.Flags[Colorpicker.Flag].Value = Colorpicker.Color
			Library.Flags[Colorpicker.Flag].Transparency = Colorpicker.Transparency
		end

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

	if propertyTable and propertyTable.Flag then
		Colorpicker.Flag = propertyTable.Flag
		Library.RegisterFlag(Colorpicker.Flag, {
			Value = Colorpicker.Color;
			Transparency = Colorpicker.Transparency;
			Set = Colorpicker.Set;
		})
	end

	Colorpicker.Set(Colorpicker.Color, Colorpicker.Transparency)
	return Colorpicker
end

Library._Instance = Add("ScreenGui", { Parent = RunService:IsStudio() and Client.PlayerGui or Services:GetService("CoreGui"); Name = "Window"; ZIndexBehavior = ZIB.Sibling; }) :: ScreenGui

Library.Window = function(self: Library, propertyTable: {})
	local Window = Overwrite({
		Title = "",
		Footer = "",
		Logo = nil,
		Icon = nil,
	}, propertyTable or {})

	local Canvas = Add("Frame", { Parent = self._Instance; Name = "Canvas"; BackgroundColor3 = Library.Theme.Background; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFO(658, 461); }) :: Frame
	Library.ThemeLink(Canvas, "BackgroundColor3", "Background")
	local Sidebar = Add("Frame", { Parent = Canvas; Name = "Sidebar"; BackgroundColor3 = Library.Theme.Surface; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UD2(0, 75, 1, 0); }) :: Frame
	Library.ThemeLink(Sidebar, "BackgroundColor3", "Surface")

	-- Author logo (only if Logo / Icon provided — no default hashtag)
	local LogoSrc = Window.Logo or Window.Icon
	local LogoH = (LogoSrc and LogoSrc ~= "") and 58 or 8
	local LogoWrap = Add("Frame", {
		Parent = Sidebar;
		Name = "Logo";
		BackgroundTransparency = 1;
		Size = UD2(1, 0, 0, LogoH);
		BorderSizePixel = 0;
		Visible = LogoH > 8;
	})
	Add("UIPadding", {
		Parent = LogoWrap;
		PaddingTop = UD(0, 10);
	})
	local LogoBtn = Add("ImageLabel", {
		Parent = LogoWrap;
		AnchorPoint = V2(0.5, 0.5);
		Position = UFS(0.5, 0.55);
		Size = UFO(32, 32);
		BackgroundTransparency = 1;
		Image = ResolveIcon(LogoSrc);
		ImageColor3 = RGB(255, 255, 255);
		ImageTransparency = 0;
		ScaleType = SCL.Fit;
		ZIndex = 3;
		Visible = LogoWrap.Visible;
	})
	local LogoGlow = Add("ImageLabel", {
		Parent = LogoWrap;
		AnchorPoint = V2(0.5, 0.5);
		Position = UFS(0.5, 0.55);
		Size = UFO(64, 64);
		BackgroundTransparency = 1;
		Image = "rbxassetid://8992230677";
		ImageColor3 = Library.Theme.Accent;
		ImageTransparency = 0.75;
		ZIndex = 1;
		Visible = LogoWrap.Visible;
	})
	Library.ThemeLink(LogoGlow, "ImageColor3", "Accent")
	local LogoGlow2 = Add("ImageLabel", {
		Parent = LogoWrap;
		AnchorPoint = V2(0.5, 0.5);
		Position = UFS(0.5, 0.55);
		Size = UFO(42, 42);
		BackgroundTransparency = 1;
		Image = "rbxassetid://8992230677";
		ImageColor3 = Library.Theme.Accent;
		ImageTransparency = 0.88;
		ZIndex = 2;
		Visible = LogoWrap.Visible;
	})
	Library.ThemeLink(LogoGlow2, "ImageColor3", "Accent")
	Window.LogoImage = LogoBtn

	local PageButtons = Add("ScrollingFrame", {
		Parent = Sidebar;
		Name = "PageButtons";
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UFO(0, LogoH);
		Size = UD2(1, 0, 1, -LogoH);
		CanvasSize = UD2(0, 0, 0, 0);
		AutomaticCanvasSize = AS.Y;
		ScrollBarThickness = 0;
		ScrollingDirection = SBD.Y;
		ClipsDescendants = true;
		Active = true;
		Selectable = false;
	})
	Add("UIListLayout", {
		Parent = PageButtons;
		Padding = UD(0, 5);
		HorizontalAlignment = HFA.Center;
		SortOrder = SO.LayoutOrder;
	})

	Window.TabEditMode = false
	-- Very small lock/reorder toggle
	local EditRow = Add("Frame", {
		Parent = Sidebar;
		Name = "TabEdit";
		AnchorPoint = V2(0.5, 1);
		Position = UD2(0.5, 0, 1, -6);
		Size = UFO(22, 10);
		BackgroundTransparency = 1;
		ZIndex = 5;
	})
	local EditTrack = Add("Frame", {
		Parent = EditRow;
		Size = UFS(1, 1);
		BackgroundColor3 = Library.Theme.SurfaceAlt;
		BorderSizePixel = 0;
	})
	Add("UICorner", { Parent = EditTrack; CornerRadius = UD(1, 0); })
	Library.ThemeLink(EditTrack, "BackgroundColor3", "SurfaceAlt")
	local EditKnob = Add("Frame", {
		Parent = EditTrack;
		Size = UFO(8, 8);
		Position = UD2(0, 1, 0.5, 0);
		AnchorPoint = V2(0, 0.5);
		BackgroundColor3 = RGB(140, 144, 155);
		BorderSizePixel = 0;
		ZIndex = 6;
	})
	Add("UICorner", { Parent = EditKnob; CornerRadius = UD(1, 0); })
	local EditHit = Add("TextButton", {
		Parent = EditRow;
		Size = UFS(1, 1);
		BackgroundTransparency = 1;
		Text = "";
		ZIndex = 7;
	})
	EditHit.Activated:Connect(function()
		Window.TabEditMode = not Window.TabEditMode
		local On = Window.TabEditMode
		Tween(EditKnob, {
			Position = On and UD2(1, -1, 0.5, 0) or UD2(0, 1, 0.5, 0);
			AnchorPoint = On and V2(1, 0.5) or V2(0, 0.5);
			BackgroundColor3 = On and Library.Theme.Accent or RGB(180, 184, 200);
		}, 0.12)
		Tween(EditTrack, {
			BackgroundColor3 = On and Library.Theme.AccentDark or Library.Theme.SurfaceAlt;
		}, 0.12)
		Library.Notify({
			Title = "Tabs";
			Text = On and "Drag tabs to rearrange" or "Tab order locked";
			Type = "Info";
			Duration = 1.5;
		})
	end)
	Window.TabEditButton = EditHit
	PageButtons.Size = UD2(1, 0, 1, -LogoH - 28)
	Window.SetLogo = function(_, Icon)
		local Img = ResolveIcon(Icon)
		LogoBtn.Image = Img
		local Show = type(Img) == "string" and Img ~= ""
		LogoWrap.Visible = Show
		LogoBtn.Visible = Show
		LogoGlow.Visible = Show
		LogoGlow2.Visible = Show
		local H = Show and 58 or 8
		LogoWrap.Size = UD2(1, 0, 0, H)
		PageButtons.Position = UFO(0, H)
		PageButtons.Size = UD2(1, 0, 1, -H - 28)
	end

	local Header = Add("Frame", { Parent = Canvas; Name = "Header"; BackgroundColor3 = Library.Theme.SurfaceAlt; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(75, 0); Size = UD2(1, -75, 0, 50); }) :: Frame
	Library.ThemeLink(Header, "BackgroundColor3", "SurfaceAlt")
	local SubPages = Add("Frame", { Parent = Header; Name = "SubPages"; AutomaticSize = AS.X; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Size = UFS(0, 1); }) :: Frame
	local Search = Add("Frame", { Parent = Header; Name = "Search"; LayoutOrder = 1; Active = true; AnchorPoint = V2(1, 0); AutomaticSize = AS.X; BackgroundColor3 = Library.Theme.Background; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFS(1, 0); Selectable = true; Size = UD2(0, 200, 1, 0); }) :: Frame
	local Pages = Add("Frame", { Parent = Canvas; Name = "Pages"; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UFO(75, 50); Size = UD2(1, -75, 1, -75); }) :: Frame
	local Footer = Add("Frame", { Parent = Canvas; Name = "Footer"; AnchorPoint = V2(0, 1); BackgroundColor3 = Library.Theme.Surface; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; Position = UD2(0, 75, 1, 0); Size = UD2(1, -75, 0, 25); }) :: Frame
	Library.ThemeLink(Footer, "BackgroundColor3", "Surface")
	local SearchBox = Add("TextBox", { Parent = Search; Name = "TextLabel"; Active = false; AutomaticSize = AS.X; ClearTextOnFocus = false; LayoutOrder = 1; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); PlaceholderColor3 = RGB(255, 255, 255); PlaceholderText = "Search function"; Selectable = false; Size = UFS(0, 1); Text = ""; TextColor3 = RGB(255, 255, 255); TextSize = 14; TextTransparency = 0.5; }) :: TextBox
	Add("UIStroke", { Parent = Canvas; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
	Add("UICorner", { Parent = Canvas; CornerRadius = UD(0, 5); })
	Add("UICorner", { Parent = Sidebar; BottomLeftRadius = UD(0, 5); BottomRightRadius = UD(0, 0); TopLeftRadius = UD(0, 5); TopRightRadius = UD(0, 0); })
	Add("UIStroke", { Parent = Sidebar; ApplyStrokeMode = ASM.Border; Color = RGB(36, 37, 37); })
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
	BindDrag(Canvas, Header, true, Search)

	Window.Canvas = Canvas
	TIS(Library.Windows, Window)
	Add("UIScale", { Parent = Canvas; Scale = Library.UIScale })

	local function CenterCanvas()
		local Camera = workspace.CurrentCamera
		if not Camera or not Canvas.Parent then
			return
		end
		local Viewport = Camera.ViewportSize
		local W, H = 658, 461
		local Scale = Library.UIScale or 1
		local GuiService = Services:GetService("GuiService")
		local Inset = GuiService:GetGuiInset()
		local X = math.floor((Viewport.X - W * Scale) * 0.5)
		local Y = math.floor((Viewport.Y - Inset.Y - H * Scale) * 0.5)
		Canvas.Position = ClampToScreen(Canvas, UFO(math.max(4, X), math.max(4, Y)))
	end
	CenterCanvas()
	task.defer(CenterCanvas)
	task.delay(0.05, CenterCanvas)

	Library.SetWatermark(Library.Watermark.Text, Library.Watermark.Enabled)
	Library.SetKeybindList(Library.KeybindList.Enabled)
	if Library._MountKeySystem then
		Library._MountKeySystem(Window)
	end
	task.defer(CenterCanvas)

	do
		local Cam = workspace.CurrentCamera
		if Cam then
			Cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				if Canvas and Canvas.Parent then
					Canvas.Position = ClampToScreen(Canvas, Canvas.Position)
				end
			end)
		end
	end

	Search.InputBegan:Connect(function(Input)
		if Input.UserInputType == UIT.MouseButton1 or Input.UserInputType == UIT.Touch then
			SearchBox:CaptureFocus()
		end
	end)

	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local Query = SearchBox.Text:lower()
		local Matched = {}
		local FirstOwner = nil

		for _, Entry in Library.Searchable do
			local Visible = Query == "" or Entry.Text:lower():find(Query, 1, true) ~= nil
			Entry.Frame.Visible = Visible

			if Visible then
				Matched[Entry.Section] = true
				if Query ~= "" and not FirstOwner and Entry.Section and Entry.Section.PageFrame then
					FirstOwner = (Library.PageFrames or {})[Entry.Section.PageFrame]
				end
			end
		end

		for _, Section in Library.Sections do
			Section.Frame.Visible = Query == "" or Matched[Section] == true
		end

		if Query ~= "" and FirstOwner then
			local Owner = FirstOwner
			if Owner.ParentPage then
				if not Owner.ParentPage.IsOpen then
					Owner.ParentPage.Open()
				end
				if not Owner.IsOpen then
					Owner.Open()
				end
			elseif not Owner.IsOpen then
				Owner.Open()
			end
		end
	end)

	Window.Pages = {}
	Window.Page = function(self: Library, propertyTable: {})
		local Page = Overwrite({
			Icon = "box"
		}, propertyTable or {})

		Page.SubPages = {}
		Page.ActiveSubPage = nil
		Page.Opened = false

		local PageButton = Add("TextButton", {
			Parent = PageButtons;
			Name = "PageButton";
			AutoButtonColor = false;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Size = UFO(45, 45);
			Text = "";
			ClipsDescendants = false;
			LayoutOrder = #Window.Pages;
		}) :: TextButton

		-- Soft radial selection bloom (centered behind icon)
		local GlowImage = Add("ImageLabel", {
			Parent = PageButton;
			Name = "GlowImage";
			AnchorPoint = V2(0.5, 0.5);
			Position = UFS(0.5, 0.5);
			Size = UFO(52, 52);
			BackgroundTransparency = 1;
			Image = "rbxassetid://8992230677";
			ImageColor3 = Library.Theme.Accent;
			ImageTransparency = 1;
			ZIndex = 1;
			BorderSizePixel = 0;
		})
		Library.ThemeLink(GlowImage, "ImageColor3", "Accent")
		local GlowInner = Add("ImageLabel", {
			Parent = PageButton;
			Name = "GlowInner";
			AnchorPoint = V2(0.5, 0.5);
			Position = UFS(0.5, 0.5);
			Size = UFO(36, 36);
			BackgroundTransparency = 1;
			Image = "rbxassetid://8992230677";
			ImageColor3 = Library.Theme.Accent;
			ImageTransparency = 1;
			ZIndex = 2;
			BorderSizePixel = 0;
		})
		Library.ThemeLink(GlowInner, "ImageColor3", "Accent")

		local PageIcon = Add("ImageLabel", {
			Parent = PageButton;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Image = ResolveIcon(Page.Icon);
			ImageTransparency = 0.45;
			ImageColor3 = RGB(255, 255, 255);
			ScaleType = SCL.Fit;
			Size = UFS(1, 1);
			ZIndex = 3;
		}) :: ImageLabel
		Add("UIPadding", {
			Parent = PageButton;
			PaddingBottom = UD(0, 12);
			PaddingLeft = UD(0, 12);
			PaddingRight = UD(0, 12);
			PaddingTop = UD(0, 12);
		})

		Page.Button = PageButton
		Page.GlowImage = GlowImage
		Page.GlowInner = GlowInner
		Page.IconLabel = PageIcon
		Page.LayoutOrder = PageButton.LayoutOrder

		PageContent(Page, Pages, Window.Pages, function()
			Page.Opened = true
			Tween(GlowImage, { ImageTransparency = 0.62 }, 0.22)
			Tween(GlowInner, { ImageTransparency = 0.78 }, 0.22)
			Tween(PageIcon, { ImageTransparency = 0, ImageColor3 = Library.Theme.Accent }, 0.2)

			for _, SubPage in Page.SubPages do
				SubPage.Button.Visible = true
			end

			if Page.ActiveSubPage then
				Page.Frame.Visible = false
				Page.ActiveSubPage.Open()
			end
		end, function()
			Page.Opened = false
			Tween(GlowImage, { ImageTransparency = 1 }, 0.16)
			Tween(GlowInner, { ImageTransparency = 1 }, 0.16)
			Tween(PageIcon, { ImageTransparency = 0.45, ImageColor3 = RGB(255, 255, 255) }, 0.16)

			for _, SubPage in Page.SubPages do
				SubPage.Button.Visible = false
			end

			if Page.ActiveSubPage then
				Page.ActiveSubPage.Close()
			end
		end)

		-- Drag-reorder: ghost snaps in-list only
		do
			local Dragging = false
			local Ghost = nil
			local Placeholder = nil

			local function ClearGhost()
				if Ghost then pcall(function() Ghost:Destroy() end) Ghost = nil end
				if Placeholder then pcall(function() Placeholder:Destroy() end) Placeholder = nil end
			end

			local function OrderedPages()
				local List = {}
				for _, P in Window.Pages do
					if P ~= Page and P.Button and P.Button.Parent then
						TIS(List, P)
					end
				end
				table.sort(List, function(a, b)
					return (a.Button.LayoutOrder or 0) < (b.Button.LayoutOrder or 0)
				end)
				return List
			end

			local function ApplyInsert(InsertIndex)
				local List = OrderedPages()
				InsertIndex = MC(InsertIndex, 0, #List)
				if Placeholder then
					Placeholder.LayoutOrder = InsertIndex * 2
				end
				for Index, P in List do
					local Slot = Index - 1
					if Slot >= InsertIndex then
						Slot = Slot + 1
					end
					P.Button.LayoutOrder = Slot * 2
					P.LayoutOrder = P.Button.LayoutOrder
				end
			end

			PageButton.InputBegan:Connect(function(Input)
				if not Window.TabEditMode then return end
				if Input.UserInputType ~= UIT.MouseButton1 and Input.UserInputType ~= UIT.Touch then return end
				if Dragging then return end
				Dragging = true
				local OriginOrder = PageButton.LayoutOrder

				ClearGhost()
				PageButton.Visible = false

				-- Outline-only slot (no solid blue fill)
				Placeholder = Add("Frame", {
					Parent = PageButtons;
					Name = "TabPlaceholder";
					Size = UFO(45, 45);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					LayoutOrder = OriginOrder;
				})
				local PhStroke = Add("UIStroke", {
					Parent = Placeholder;
					Color = Library.Theme.Accent;
					Transparency = 0.35;
					Thickness = 1.5;
				})
				Add("UICorner", { Parent = Placeholder; CornerRadius = UD(0, 8); })

				Ghost = Add("Frame", {
					Parent = Library._Instance;
					Name = "TabGhost";
					Size = UFO(45, 45);
					BackgroundTransparency = 1;
					ZIndex = 120;
				})
				Add("ImageLabel", {
					Parent = Ghost;
					BackgroundTransparency = 1;
					Size = UFS(1, 1);
					Image = PageIcon.Image;
					ImageColor3 = Library.Theme.Accent;
					ImageTransparency = 0.2;
					ScaleType = SCL.Fit;
				})
				Add("UIPadding", {
					Parent = Ghost;
					PaddingBottom = UD(0, 12);
					PaddingLeft = UD(0, 12);
					PaddingRight = UD(0, 12);
					PaddingTop = UD(0, 12);
				})

				local function ClampGhostY(MouseY)
					local Top = PageButtons.AbsolutePosition.Y
					local Bot = Top + PageButtons.AbsoluteSize.Y - 45
					local GX = PageButtons.AbsolutePosition.X + (PageButtons.AbsoluteSize.X - 45) * 0.5
					local GY = MC(MouseY - 22, Top, math.max(Top, Bot))
					return GX, GY
				end

				local Abs = PageButton.AbsolutePosition
				local GX, GY = ClampGhostY(Abs.Y + 22)
				Ghost.Position = UFO(GX, GY)

				local MoveConn
				local EndConn
				MoveConn = UserInputService.InputChanged:Connect(function(Move)
					if not Dragging then return end
					if Move.UserInputType ~= UIT.MouseMovement and Move.UserInputType ~= UIT.Touch then return end
					local gx, gy = ClampGhostY(Move.Position.Y)
					if Ghost then
						Ghost.Position = UFO(gx, gy)
					end
					local List = OrderedPages()
					local Insert = #List
					for Index, P in List do
						local Mid = P.Button.AbsolutePosition.Y + P.Button.AbsoluteSize.Y * 0.5
						if Move.Position.Y < Mid then
							Insert = Index - 1
							break
						end
						Insert = Index
					end
					ApplyInsert(Insert)
				end)
				EndConn = UserInputService.InputEnded:Connect(function(End)
					if End.UserInputType ~= UIT.MouseButton1 and End.UserInputType ~= UIT.Touch then return end
					if not Dragging then return end
					Dragging = false
					if MoveConn then MoveConn:Disconnect() end
					if EndConn then EndConn:Disconnect() end
					local FinalOrder = Placeholder and Placeholder.LayoutOrder or OriginOrder
					ClearGhost()
					PageButton.Visible = true
					PageButton.LayoutOrder = FinalOrder
					Page.LayoutOrder = FinalOrder
					local All = {}
					for _, P in Window.Pages do
						if P.Button and P.Button.Parent then
							TIS(All, P)
						end
					end
					table.sort(All, function(a, b)
						return (a.Button.LayoutOrder or 0) < (b.Button.LayoutOrder or 0)
					end)
					for Index, P in All do
						P.Button.LayoutOrder = Index - 1
						P.LayoutOrder = Index - 1
					end
					pcall(function() Library.SaveLayout() end)
				end)
			end)
		end

		Page.SubPage = function(self: Library, propertyTable: {})
			local SubPage = Overwrite({
				Name = "",
			}, propertyTable or {})

			local SubPageButton = Add("TextButton", { Parent = SubPages; Name = "SubPageButton"; AutoButtonColor = false; AutomaticSize = AS.X; BackgroundColor3 = Library.Theme.Background; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal); Size = UFS(0, 1); Text = ""; TextColor3 = RGB(0, 0, 0); TextSize = 14; Visible = Page.Opened; }) :: TextButton
			local SubGrad = Add("UIGradient", { Parent = SubPageButton; Color = CS{ CSK(0, Library.Theme.AccentDark), CSK(1, Library.Theme.Accent) }; Rotation = -70; })
			Library.ThemeLink(SubGrad, "Gradient", "AccentDark", "Accent")
			local SubPageLabel = Add("TextLabel", { Parent = SubPageButton; Name = "Label"; AutomaticSize = AS.XY; BackgroundColor3 = RGB(255, 255, 255); BackgroundTransparency = 1; BorderColor3 = RGB(0, 0, 0); BorderSizePixel = 0; FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal); Size = UFS(1, 1); Text = SubPage.Name; TextColor3 = RGB(255, 255, 255); TextSize = 14; TextTransparency = 0.5; }) :: TextLabel
			Add("UIPadding", { Parent = SubPageButton; PaddingLeft = UD(0, 14); PaddingRight = UD(0, 14); })
			Add("UICorner", { Parent = SubPageButton; CornerRadius = UD(0, 5); })

			SubPage.Button = SubPageButton

			SubPage.ParentPage = Page
			PageContent(SubPage, Pages, Page.SubPages, function()

				Page.ActiveSubPage = SubPage
				Page.Frame.Visible = false

				Tween(SubPageButton, { BackgroundColor3 = RGB(255, 255, 255) }, 0.15)
				Tween(SubPageLabel, { TextTransparency = 0 }, 0.15)
			end, function()
				Tween(SubPageButton, { BackgroundColor3 = Library.Theme.Background }, 0.15)
				Tween(SubPageLabel, { TextTransparency = 0.5 }, 0.15)
			end)

			SubPageButton.Activated:Connect(SubPage.Open)

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

Library.Theme = {
	Accent = RGB(138, 156, 229),
	AccentDark = RGB(78, 88, 129),
	Background = RGB(9, 8, 8),
	Surface = RGB(15, 14, 15),
	SurfaceAlt = RGB(20, 20, 21),
	Border = RGB(36, 37, 37),
	SectionBorder = RGB(32, 33, 36),
	Text = RGB(255, 255, 255),
	TextDim = RGB(180, 184, 200),
}

Library.DefaultTheme = {
	Accent = RGB(138, 156, 229),
	AccentDark = RGB(78, 88, 129),
	Background = RGB(9, 8, 8),
	Surface = RGB(15, 14, 15),
	SurfaceAlt = RGB(20, 20, 21),
	Border = RGB(36, 37, 37),
	SectionBorder = RGB(32, 33, 36),
	Text = RGB(255, 255, 255),
	TextDim = RGB(180, 184, 200),
}

Library.ThemeLinks = {}

Library.ThemeLink = function(Object: Instance, Property: string, Key: string, Key2: string?)
	if not Object then
		return
	end
	TIS(Library.ThemeLinks, { Object = Object; Property = Property; Key = Key; Key2 = Key2 })
end

Library.ApplyTheme = function()
	local T = Library.Theme
	if not T then
		return
	end

	-- Always derive AccentDark from Accent when accent changes
	if T.Accent then
		local H, S, V = T.Accent:ToHSV()
		T.AccentDark = HSV(H, math.clamp(S * 0.95, 0, 1), math.max(V * 0.55, 0.12))
	end

	local function PaintGrad(Grad: UIGradient?)
		if Grad and Grad:IsA("UIGradient") then
			Grad.Color = CS{ CSK(0, T.AccentDark or T.Accent), CSK(1, T.Accent) }
		end
	end

	-- ThemeLink registry
	local Alive = {}
	for _, Link in Library.ThemeLinks do
		if Link.Object and Link.Object.Parent then
			TIS(Alive, Link)
			if Link.Property == "Gradient" and Link.Object:IsA("UIGradient") then
				PaintGrad(Link.Object)
			elseif Link.Property and T[Link.Key] ~= nil then
				pcall(function()
					Link.Object[Link.Property] = T[Link.Key]
				end)
			end
		end
	end
	Library.ThemeLinks = Alive

	for _, Win in Library.Windows do
		local Canvas = Win.Canvas
		if not Canvas then
			continue
		end
		pcall(function() Canvas.BackgroundColor3 = T.Background end)
		local Stroke = Canvas:FindFirstChildOfClass("UIStroke")
		if Stroke then pcall(function() Stroke.Color = T.Border end) end

		local Header = Canvas:FindFirstChild("Header")
		if Header then
			Header.BackgroundColor3 = T.SurfaceAlt
			local Hs = Header:FindFirstChildOfClass("UIStroke")
			if Hs then Hs.Color = T.Border end
			local Search = Header:FindFirstChild("Search")
			if Search and Search:IsA("GuiObject") then
				Search.BackgroundColor3 = T.Background
			end
		end
		local Footer = Canvas:FindFirstChild("Footer")
		if Footer then
			Footer.BackgroundColor3 = T.Surface
			local Fs = Footer:FindFirstChildOfClass("UIStroke")
			if Fs then Fs.Color = T.Border end
			for _, L in Footer:GetChildren() do
				if L:IsA("TextLabel") then
					L.TextColor3 = T.Text
				end
			end
		end
		local Sidebar = Canvas:FindFirstChild("Sidebar")
		if Sidebar then
			Sidebar.BackgroundColor3 = T.Surface
			local Logo = Sidebar:FindFirstChild("Logo")
			if Logo then
				for _, Ch in Logo:GetChildren() do
					if Ch:IsA("ImageLabel") then
						Ch.ImageColor3 = T.Accent
					end
				end
			end
			local PB = Sidebar:FindFirstChild("PageButtons")
			if PB and PB:IsA("ScrollingFrame") then
				PB.ScrollBarImageColor3 = T.Accent
			end
		end

		for _, Page in (Win.Pages or {}) do
			if Page.Gradient then PaintGrad(Page.Gradient) end
			if Page.Indicator then
				pcall(function() Page.Indicator.BackgroundColor3 = RGB(255, 255, 255) end)
			end
			if Page.IndicatorGlow then
				pcall(function()
					if Page.IndicatorGlow:IsA("Frame") then
						Page.IndicatorGlow.BackgroundColor3 = T.Accent
					elseif Page.IndicatorGlow:IsA("ImageLabel") then
						Page.IndicatorGlow.ImageColor3 = T.Accent
					end
				end)
			end
			if Page.IndicatorBloom then
				pcall(function() Page.IndicatorBloom.ImageColor3 = T.Accent end)
			end
			if Page.IconLabel then
				if Page.Opened then
					Page.IconLabel.ImageTransparency = 0
					Page.IconLabel.ImageColor3 = RGB(255, 255, 255)
				else
					Page.IconLabel.ImageTransparency = 0.5
					Page.IconLabel.ImageColor3 = RGB(255, 255, 255)
				end
			end
			for _, Sub in (Page.SubPages or {}) do
				local Btn = Sub.Button
				if Btn then
					local Grad = Btn:FindFirstChildOfClass("UIGradient")
					PaintGrad(Grad)
					if not (Page.ActiveSubPage == Sub) then
						Btn.BackgroundColor3 = T.Background
					end
				end
			end
		end
	end

	-- Sections / elements walk
	for _, Section in (Library.Sections or {}) do
		local Frame = Section.Frame
		if Frame and Frame.Parent then
			pcall(function() Frame.BackgroundColor3 = T.Surface end)
			local St = Frame:FindFirstChildOfClass("UIStroke")
			if St then pcall(function() St.Color = T.SectionBorder or T.Border end) end
		end
	end

	if Library.Watermark and Library.Watermark.Frame then
		Library.Watermark.Frame.BackgroundColor3 = T.Surface
		local Stroke = Library.Watermark.Frame:FindFirstChildOfClass("UIStroke")
		if Stroke then Stroke.Color = T.Border end
		if Library.Watermark.Accent then
			Library.Watermark.Accent.BackgroundColor3 = T.Accent
			PaintGrad(Library.Watermark.Accent:FindFirstChildOfClass("UIGradient"))
		end
		if Library.Watermark.Label then
			Library.Watermark.Label.TextColor3 = T.Text
		end
	end
	if Library.KeybindList and Library.KeybindList.Frame then
		Library.KeybindList.Frame.BackgroundColor3 = T.Surface
		local Stroke = Library.KeybindList.Frame:FindFirstChildOfClass("UIStroke")
		if Stroke then Stroke.Color = T.Border end
		if Library.KeybindList.Accent then
			Library.KeybindList.Accent.BackgroundColor3 = T.Accent
			PaintGrad(Library.KeybindList.Accent:FindFirstChildOfClass("UIGradient"))
		end
		local Header = Library.KeybindList.Frame:FindFirstChild("Header")
		if Header then Header.BackgroundColor3 = T.SurfaceAlt end
	end
end

Library.Folder = "Noctro"
Library.ConfigExtension = ".json"
Library.Autoload = nil
Library.MenuKey = EKC.LeftAlt
Library.MenuOpen = true
Library.Windows = {}
Library.Auth = {
	Enabled = false;
	Validated = true;
	Token = nil;
	ExpiresAt = nil;
	ShowExpiry = false;
	WatermarkExpiry = false;
	Options = nil;
}

local function HasFS(): boolean
	return typeof(writefile) == "function" and typeof(readfile) == "function"
end

local function EnsureFolder()
	if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
		if not isfolder(Library.Folder) then
			pcall(makefolder, Library.Folder)
		end
	end
end

Library.SetConfigFolder = function(Path: string)
	if type(Path) ~= "string" or Path == "" then
		return Library.Folder
	end
	Path = Path:gsub("^/+", ""):gsub("/+$", ""):gsub("%.%.", "")
	if Path == "" then
		Path = "Noctro"
	end
	Library.Folder = Path
	EnsureFolder()
	return Library.Folder
end

local function ConfigPath(Name: string): string
	return Library.Folder .. "/" .. Name .. Library.ConfigExtension
end

local function EncodeColor(Color: Color3): { number }
	return { MR(Color.R * 255), MR(Color.G * 255), MR(Color.B * 255) }
end

local function DecodeColor(Value: any): Color3?
	if typeof(Value) == "Color3" then
		return Value
	end
	if type(Value) == "table" and #Value >= 3 then
		return RGB(Value[1], Value[2], Value[3])
	end
	return nil
end


Library.GetLayout = function()
	local Layout = {
		Tabs = {};
		Sections = {};
		KeybindList = nil;
		Watermark = nil;
	}
	for _, Win in Library.Windows do
		for _, Page in (Win.Pages or {}) do
			local Id = tostring(Page.Icon or "") .. ":" .. tostring(Page.Button and Page.Button.LayoutOrder or 0)
			if Page.Button then
				TIS(Layout.Tabs, {
					Icon = Page.Icon;
					Order = Page.Button.LayoutOrder;
				})
			end
			for _, Sub in (Page.SubPages or {}) do
				-- sections live under subpages via Library.Sections
			end
		end
	end
	for _, Section in (Library.Sections or {}) do
		if Section.Frame then
			TIS(Layout.Sections, {
				Name = Section.Name;
				Side = Section.Side;
				Order = Section.Frame.LayoutOrder;
			})
		end
	end
	if Library.KeybindList and Library.KeybindList.Frame then
		local P = Library.KeybindList.Frame.Position
		Layout.KeybindList = { X = P.X.Offset; Y = P.Y.Offset }
	end
	if Library.Watermark and Library.Watermark.Frame then
		local P = Library.Watermark.Frame.Position
		Layout.Watermark = { X = P.X.Offset; Y = P.Y.Offset }
	end
	return Layout
end

Library.SaveLayout = function()
	-- persisted via next config save; also write layout.json if FS available
	if not HasFS or not HasFS() then
		return
	end
	EnsureFolder()
	local Ok, Enc = pcall(function()
		return game:GetService("HttpService"):JSONEncode(Library.GetLayout())
	end)
	if Ok and Enc and writefile then
		pcall(writefile, Library.Folder .. "/layout.json", Enc)
	end
end

Library.ApplyLayout = function(Layout)
	if type(Layout) ~= "table" then return end
	if type(Layout.Tabs) == "table" then
		for _, Win in Library.Windows do
			for _, Entry in Layout.Tabs do
				for _, Page in (Win.Pages or {}) do
					if Page.Icon == Entry.Icon and Page.Button and type(Entry.Order) == "number" then
						Page.Button.LayoutOrder = Entry.Order
						Page.LayoutOrder = Entry.Order
					end
				end
			end
		end
	end
	if type(Layout.Sections) == "table" then
		for _, Entry in Layout.Sections do
			for _, Section in (Library.Sections or {}) do
				if Section.Name == Entry.Name and Section.Frame then
					if Entry.Order then Section.Frame.LayoutOrder = Entry.Order end
					if Entry.Side and Section.Side ~= Entry.Side then
						-- move column if possible
						local Frame = Section.Frame
						local Parent = Frame.Parent and Frame.Parent.Parent
						if Parent then
							local Col = Parent:FindFirstChild(Entry.Side)
							if Col then
								Frame.Parent = Col
								Section.Side = Entry.Side
							end
						end
					end
				end
			end
		end
	end
	if Layout.KeybindList and Library.KeybindList and Library.KeybindList.Frame then
		local X, Y = Layout.KeybindList.X, Layout.KeybindList.Y
		if type(X) == "number" and type(Y) == "number" then
			Library.KeybindList.Frame.Position = ClampToScreen(Library.KeybindList.Frame, UFO(X, Y))
		end
	end
	if Layout.Watermark and Library.Watermark and Library.Watermark.Frame then
		local X, Y = Layout.Watermark.X, Layout.Watermark.Y
		if type(X) == "number" and type(Y) == "number" then
			Library.Watermark.Frame.Position = ClampToScreen(Library.Watermark.Frame, UFO(X, Y))
		end
	end
end

Library.GetConfig = function()
	local Data = {
		Flags = {};
		Theme = {};
		Layout = Library.GetLayout and Library.GetLayout() or {};
		MenuKey = Library.MenuKey and Library.MenuKey.Name or "LeftAlt";
	}

	for Flag, Entry in Library.Flags do
		local Value = Entry.Value
		if typeof(Value) == "Color3" then
			Data.Flags[Flag] = {
				Type = "Color3";
				Color = EncodeColor(Value);
				Transparency = Entry.Transparency or 0;
			}
		elseif typeof(Value) == "EnumItem" then
			Data.Flags[Flag] = { Type = "Enum"; EnumType = tostring(Value.EnumType); Name = Value.Name }
		elseif type(Value) == "table" then
			Data.Flags[Flag] = { Type = "table"; Value = Value }
		else
			Data.Flags[Flag] = { Type = type(Value); Value = Value }
		end
	end

	for Key, Color in Library.Theme do
		if typeof(Color) == "Color3" then
			Data.Theme[Key] = EncodeColor(Color)
		end
	end

	if Library.KeybindList and Library.KeybindList.Frame then
		local P = Library.KeybindList.Frame.Position
		Data.KeybindListPos = { X = P.X.Offset; Y = P.Y.Offset }
	elseif Library.KeybindList and Library.KeybindList.SavedPos then
		Data.KeybindListPos = Library.KeybindList.SavedPos
	end

	return Data
end

Library.SetFlag = function(Flag: string, Value: any, Transparency: number?)
	local Entry = Library.Flags[Flag]
	if not Entry then
		return
	end
	if Entry.Set then
		if Transparency ~= nil then
			Entry.Set(Value, Transparency)
		elseif type(Value) == "boolean" then

			Entry.Set(Value, true)
		else
			Entry.Set(Value)
		end
	else
		Entry.Value = Value
	end
end

Library.LoadConfigData = function(Data: {})
	if type(Data) ~= "table" then
		return
	end

	if type(Data.Theme) == "table" then
		for Key, Value in Data.Theme do
			local Color = DecodeColor(Value)
			if Color then
				Library.Theme[Key] = Color
			end
		end
	end

	if type(Data.KeybindListPos) == "table" then
		Library.KeybindList = Library.KeybindList or {}
		Library.KeybindList.SavedPos = {
			X = tonumber(Data.KeybindListPos.X) or 18;
			Y = tonumber(Data.KeybindListPos.Y) or 200;
		}
		if Library.KeybindList.Frame then
			local Pos = UFO(Library.KeybindList.SavedPos.X, Library.KeybindList.SavedPos.Y)
			Library.KeybindList.Frame.Position = ClampToScreen(Library.KeybindList.Frame, Pos)
		end
	end

	if type(Data.MenuKey) == "string" and EKC[Data.MenuKey] then
		Library.MenuKey = EKC[Data.MenuKey]
	end

	if type(Data.Flags) == "table" then
		for Flag, Packed in Data.Flags do
			local Entry = Library.Flags[Flag]
			if Entry and type(Packed) == "table" then
				local Type = Packed.Type
				if Type == "Color3" then
					local Color = DecodeColor(Packed.Color)
					if Color then
						Library.SetFlag(Flag, Color, Packed.Transparency)
					end
				elseif Type == "Enum" and Packed.Name then
					local EnumRoot = Enum
					local EnumType = EnumRoot[Packed.EnumType]
					if EnumType and EnumType[Packed.Name] then
						Library.SetFlag(Flag, EnumType[Packed.Name])
					end
				elseif Type == "table" then
					Library.SetFlag(Flag, Packed.Value)
				else
					Library.SetFlag(Flag, Packed.Value)
				end
			end
		end
	end
end

Library.SaveConfig = function(Name: string)
	if not HasFS() then
		warn("[Noctro] writefile/readfile unavailable in this environment")
		return false
	end
	EnsureFolder()
	Name = tostring(Name or "default"):gsub("[^%w%-%_ ]", "")
	if Name == "" then Name = "default" end
	local Data = Library.GetConfig()
	Data.Name = Name
	Data.SavedAt = os.date("%Y-%m-%d %H:%M:%S")
	local Ok, Encoded = pcall(function()
		return game:GetService("HttpService"):JSONEncode(Data)
	end)
	if not Ok then
		warn("[Noctro] failed to encode config", Encoded)
		return false
	end
	local Path = ConfigPath(Name)
	local WOk, WErr = pcall(writefile, Path, Encoded)
	if not WOk then
		warn("[Noctro] writefile failed", WErr)
		return false
	end
	return true
end

Library.LoadConfig = function(Name: string)
	if not HasFS() then
		warn("[Noctro] writefile/readfile unavailable in this environment")
		return false
	end
	Name = tostring(Name or "default")
	local Path = ConfigPath(Name)
	local Exists = true
	if typeof(isfile) == "function" then
		Exists = isfile(Path)
	end
	if not Exists then
		warn("[Noctro] config not found:", Name)
		return false
	end
	local ROk, Raw = pcall(readfile, Path)
	if not ROk then
		warn("[Noctro] readfile failed", Raw)
		return false
	end
	local Ok, Data = pcall(function()
		return game:GetService("HttpService"):JSONDecode(Raw)
	end)
	if not Ok or type(Data) ~= "table" then
		warn("[Noctro] invalid config:", Name)
		return false
	end
	Library.LoadConfigData(Data)
	if Library.ApplyTheme then
		Library.ApplyTheme()
	end
	if Library.SyncThemePickers then
		Library.SyncThemePickers()
	end
	return true
end

Library.DeleteConfig = function(Name: string)
	if not delfile or not isfile then
		return false
	end
	local Path = ConfigPath(Name)
	if isfile(Path) then
		delfile(Path)
		return true
	end
	return false
end

Library.ListConfigs = function(): { string }
	local List = {}
	if not listfiles then
		return List
	end
	EnsureFolder()
	local Ok, Files = pcall(listfiles, Library.Folder)
	if not Ok or type(Files) ~= "table" then
		return List
	end
	for _, Path in Files do
		local Name = tostring(Path):match("([^/\\]+)%.json$")
		if Name then
			TIS(List, Name)
		end
	end
	table.sort(List)
	return List
end

Library.SetAutoload = function(Name: string?)
	Library.Autoload = Name
	if writefile then
		EnsureFolder()
		writefile(Library.Folder .. "/autoload.txt", Name or "")
	end
end

Library.GetAutoload = function(): string?
	if Library.Autoload then
		return Library.Autoload
	end
	if isfile and isfile(Library.Folder .. "/autoload.txt") then
		local Name = readfile(Library.Folder .. "/autoload.txt")
		if Name ~= "" then
			Library.Autoload = Name
			return Name
		end
	end
	return nil
end

Library.RegisterFlag = function(Flag: string, Entry: {})
	if not Flag or Flag == "" then
		return
	end
	Library.Flags[Flag] = Entry
end

Library.LoadingScreen = function(self: Library, propertyTable: {})
	local Props = Overwrite({
		Title = "Noctro";
		Subtitle = "Loading…";
		Duration = 1.6;
	}, propertyTable or {})

	local Gui = Add("ScreenGui", {
		Parent = RunService:IsStudio() and Client.PlayerGui or Services:GetService("CoreGui");
		Name = "NoctroLoading";
		ZIndexBehavior = ZIB.Sibling;
		IgnoreGuiInset = true;
	})

	local Card = Add("Frame", {
		Parent = Gui;
		AnchorPoint = V2(0.5, 0.5);
		Position = UFS(0.5, 0.5);
		Size = UFO(280, 120);
		BackgroundColor3 = Library.Theme.Surface;
		BorderSizePixel = 0;
		ZIndex = 50;
	})
	Add("UIShadow", { Parent = Card; BlurRadius = UD(0, 24); Spread = UFO(6, 6); Transparency = 0.55; })
	Add("UICorner", { Parent = Card; CornerRadius = UD(0, 8); })
	Add("UIStroke", { Parent = Card; ApplyStrokeMode = ASM.Border; Color = Library.Theme.Border; })
	Add("TextLabel", {
		Parent = Card;
		BackgroundTransparency = 1;
		Position = UFO(0, 28);
		Size = UD2(1, 0, 0, 22);
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		Text = Props.Title;
		TextColor3 = Library.Theme.Text;
		TextSize = 18;
	})
	Add("TextLabel", {
		Parent = Card;
		BackgroundTransparency = 1;
		Position = UFO(0, 54);
		Size = UD2(1, 0, 0, 18);
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		Text = Props.Subtitle;
		TextColor3 = Library.Theme.Text;
		TextTransparency = 0.45;
		TextSize = 13;
	})
	local BarBG = Add("Frame", {
		Parent = Card;
		BackgroundColor3 = Library.Theme.SurfaceAlt;
		BorderSizePixel = 0;
		Position = UD2(0.5, 0, 1, -28);
		AnchorPoint = V2(0.5, 0);
		Size = UD2(0.7, 0, 0, 6);
	})
	Add("UICorner", { Parent = BarBG; CornerRadius = UD(1, 0); })
	local Bar = Add("Frame", {
		Parent = BarBG;
		BackgroundColor3 = Library.Theme.Accent;
		BorderSizePixel = 0;
		Size = UD2(0, 0, 1, 0);
	})
	Add("UICorner", { Parent = Bar; CornerRadius = UD(1, 0); })
	Add("UIGradient", {
		Parent = Bar;
		Color = CS{ CSK(0, Library.Theme.AccentDark), CSK(1, Library.Theme.Accent) };
		Rotation = -90;
	})

	Tween(Bar, { Size = UD2(1, 0, 1, 0) }, Props.Duration, ES.Quad, ED.Out)

	local Done = Instance.new("BindableEvent")
	task.delay(Props.Duration + 0.15, function()
		Tween(Card, { BackgroundTransparency = 1 }, 0.3)
		for _, D in Card:GetDescendants() do
			if D:IsA("TextLabel") then
				Tween(D, { TextTransparency = 1 }, 0.25)
			elseif D:IsA("Frame") and D ~= Card then
				Tween(D, { BackgroundTransparency = 1 }, 0.25)
			end
		end
		task.wait(0.35)
		Gui:Destroy()
		Done:Fire()
	end)

	Done.Event:Wait()
	Done:Destroy()
	return Gui
end

Library.UIScale = 1

Library.SetScale = function(Scale: number)
	Scale = MC(Scale / (Scale > 2 and 100 or 1), 0.75, 1.25)
	Library.UIScale = Scale
	for _, Win in Library.Windows do
		if Win.Canvas then
			local Existing = Win.Canvas:FindFirstChildOfClass("UIScale")
			if not Existing then
				Existing = Add("UIScale", { Parent = Win.Canvas })
			end

			local Abs = Win.Canvas.AbsolutePosition
			local Size = Win.Canvas.AbsoluteSize
			local Center = Abs + Size * 0.5
			Existing.Scale = Scale
			task.defer(function()
				if not Win.Canvas or not Win.Canvas.Parent then return end
				local NewSize = Win.Canvas.AbsoluteSize
				local NewPos = Center - NewSize * 0.5
				Win.Canvas.Position = ClampToScreen(Win.Canvas, UFO(NewPos.X, NewPos.Y))
			end)
		end
	end
end

Library.Watermark = {
	Enabled = true;
	Text = "Noctro";
	Frame = nil :: Frame?;
}

Library.KeybindList = {
	Enabled = true;
	Frame = nil :: Frame?;
	Rows = {} :: { [string]: Frame };
}

local function EnsureOverlayGui()
	if Library._Overlay then
		return Library._Overlay
	end
	Library._Overlay = Add("ScreenGui", {
		Parent = RunService:IsStudio() and Client.PlayerGui or Services:GetService("CoreGui");
		Name = "NoctroOverlay";
		ZIndexBehavior = ZIB.Sibling;
		IgnoreGuiInset = true;
	})
	return Library._Overlay
end

Library.NotifyPosition = "Top Right"
Library.Notifications = {}

Library.SetWatermark = function(Text: string?, Enabled: boolean?)
	if Enabled ~= nil then
		Library.Watermark.Enabled = Enabled
	end
	if Text ~= nil then
		Library.Watermark.Text = Text
	end

	local Gui = EnsureOverlayGui()
	if Library.Watermark.Frame then
		Library.Watermark.Frame:Destroy()
		Library.Watermark.Frame = nil
	end

	local Frame = Add("Frame", {
		Parent = Gui;
		Name = "Watermark";
		AnchorPoint = V2(0.5, 0);
		Position = UD2(0.5, 0, 0, 12);
		AutomaticSize = AS.X;
		Size = UFO(0, 32);
		BackgroundColor3 = Library.Theme.Surface;
		BorderSizePixel = 0;
		ZIndex = 120;
		Visible = Library.Watermark.Enabled == true;
	})
	Add("UICorner", { Parent = Frame; CornerRadius = UD(0, 7); })
	Add("UIStroke", { Parent = Frame; ApplyStrokeMode = ASM.Border; Color = Library.Theme.Border; })
	Add("UIShadow", { Parent = Frame; BlurRadius = UD(0, 16); Spread = UFO(4, 4); Transparency = 0.7; })
	Add("UIPadding", { Parent = Frame; PaddingLeft = UD(0, 10); PaddingRight = UD(0, 12); })
	Add("UIListLayout", {
		Parent = Frame;
		FillDirection = FD.Horizontal;
		Padding = UD(0, 8);
		VerticalAlignment = VFA.Center;
		SortOrder = SO.LayoutOrder;
	})

	local Logo = Add("Frame", {
		Parent = Frame;
		BackgroundColor3 = Library.Theme.Accent;
		BorderSizePixel = 0;
		Size = UFO(16, 16);
		LayoutOrder = 0;
	})
	Add("UICorner", { Parent = Logo; CornerRadius = UD(0, 4); })
	Add("UIGradient", {
		Parent = Logo;
		Color = CS{ CSK(0, Library.Theme.AccentDark), CSK(1, Library.Theme.Accent) };
		Rotation = -45;
	})

	local function Chip(Text: string, Order: number, Dim: boolean?): TextLabel
		return Add("TextLabel", {
			Parent = Frame;
			BackgroundTransparency = 1;
			AutomaticSize = AS.X;
			Size = UFO(0, 32);
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			Text = Text;
			TextColor3 = Dim and RGB(150, 154, 170) or RGB(235, 236, 240);
			TextSize = 12;
			LayoutOrder = Order;
		})
	end

	local function Sep(Order: number)
		return Chip("-", Order, true)
	end

	local CleanText = tostring(Library.Watermark.Text or "Noctro")

	local Built = {}
	for i = 1, #CleanText do
		local c = CleanText:sub(i, i)
		local b = string.byte(c)
		if (b >= 48 and b <= 57) or (b >= 65 and b <= 90) or (b >= 97 and b <= 122) or c == " " or c == "-" or c == "_" then
			table.insert(Built, c)
		else
			table.insert(Built, " ")
		end
	end
	CleanText = table.concat(Built)
	CleanText = CleanText:gsub("%s+", " ")
	CleanText = CleanText:gsub("^%s+", ""):gsub("%s+$", "")
	if CleanText == "" then
		CleanText = "Noctro"
	end

	if CleanText:match("^%d+$") then
		CleanText = "Noctro"
	end

	local Title = Chip(CleanText, 1, false)
	local Order = 2
	if Library.Auth and Library.Auth.Validated and Library.Auth.WatermarkExpiry and Library.Auth.ExpiresAt and Library.FormatExpiry then
		Sep(Order)
		Order = Order + 1
		Chip(Library.FormatExpiry(Library.Auth.ExpiresAt), Order, true)
		Order = Order + 1
	end
	Sep(Order)
	Order = Order + 1
	local FpsL = Chip("0 fps", Order, true)
	Order = Order + 1
	Sep(Order)
	Order = Order + 1
	local PingL = Chip("0 ms", Order, true)
	Order = Order + 1
	Sep(Order)
	Order = Order + 1
	local TimeL = Chip(os.date("%H:%M:%S"), Order, true)

	Library.Watermark.Frame = Frame
	Library.Watermark.Label = Title
	Library.Watermark.Stats = FpsL
	Library.Watermark.Accent = Logo

	if Library.Watermark._StatsConn then
		Library.Watermark._StatsConn:Disconnect()
	end
	local Frames, Last = 0, os.clock()
	Library.Watermark._StatsConn = RunService.RenderStepped:Connect(function()
		if not Library.Watermark.Enabled or not Frame.Parent then
			return
		end
		Frames = Frames + 1
		local Now = os.clock()
		if Now - Last >= 1 then
			FpsL.Text = string.format("%d fps", Frames)
			local Ping = 0
			pcall(function()
				Ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			PingL.Text = string.format("%d ms", Ping)
			TimeL.Text = os.date("%H:%M:%S")
			Frames = 0
			Last = Now
		end
	end)
end

Library.SetKeybindList = function(Enabled: boolean?)
	if Enabled ~= nil then
		Library.KeybindList.Enabled = Enabled
	end

	local Gui = EnsureOverlayGui()
	if Library.KeybindList.Frame then
		Library.KeybindList.Frame:Destroy()
		Library.KeybindList.Frame = nil
		Library.KeybindList.Rows = {}
	end

	local T = Library.Theme
	local Panel = Add("Frame", {
		Parent = Gui;
		Name = "KeybindList";
		Position = UFO(18, math.floor((workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 800) * 0.35));
		Size = UFO(280, 0);
		AutomaticSize = AS.Y;
		BackgroundColor3 = T.Surface;
		BorderSizePixel = 0;
		Visible = Library.KeybindList.Enabled == true;
		ZIndex = 120;
		Active = true;
	})
	Add("UICorner", { Parent = Panel; CornerRadius = UD(0, 10); })
	Add("UIStroke", { Parent = Panel; ApplyStrokeMode = ASM.Border; Color = RGB(30, 30, 36); })
	Add("UIPadding", {
		Parent = Panel;
		PaddingTop = UD(0, 12);
		PaddingBottom = UD(0, 10);
		PaddingLeft = UD(0, 12);
		PaddingRight = UD(0, 12);
	})
	Add("UIListLayout", {
		Parent = Panel;
		SortOrder = SO.LayoutOrder;
		Padding = UD(0, 10);
	})

	local Header = Add("TextButton", {
		Parent = Panel;
		Name = "Header";
		Size = UD2(1, 0, 0, 22);
		BackgroundTransparency = 1;
		Text = "";
		AutoButtonColor = false;
		LayoutOrder = 0;
		ZIndex = 121;
	})
	local HeaderIcon = Add("Frame", {
		Parent = Header;
		BackgroundColor3 = T.Accent;
		Size = UFO(8, 8);
		Position = UFO(0, 7);
		BorderSizePixel = 0;
	})
	Add("UICorner", { Parent = HeaderIcon; CornerRadius = UD(1, 0); })
	Add("UIGradient", {
		Parent = HeaderIcon;
		Color = CS{ CSK(0, T.AccentDark), CSK(1, T.Accent) };
		Rotation = -90;
	})
	Add("TextLabel", {
		Parent = Header;
		BackgroundTransparency = 1;
		Position = UFO(16, 0);
		Size = UD2(1, -16, 1, 0);
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		Text = "Keybind list";
		TextColor3 = T.Text;
		TextSize = 14;
		TextXAlignment = TXA.Left;
	})

	local Body = Add("Frame", {
		Parent = Panel;
		Name = "Body";
		BackgroundTransparency = 1;
		Size = UD2(1, 0, 0, 0);
		AutomaticSize = AS.Y;
		LayoutOrder = 1;
		ClipsDescendants = true;
	})
	Add("UIListLayout", { Parent = Body; SortOrder = SO.LayoutOrder; Padding = UD(0, 8); })

	local Cols = Add("Frame", {
		Parent = Body;
		Name = "Cols";
		BackgroundTransparency = 1;
		Size = UD2(1, 0, 0, 16);
		LayoutOrder = 1;
	})
	local function Col(Text: string, Pos: UDim2, Size: UDim2, Align: Enum.TextXAlignment)
		Add("TextLabel", {
			Parent = Cols;
			BackgroundTransparency = 1;
			Position = Pos;
			Size = Size;
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			Text = Text;
			TextColor3 = RGB(160, 160, 165);
			TextSize = 12;
			TextXAlignment = Align;
		})
	end
	Col("Function", UFO(6, 0), UFO(118, 16), TXA.Left)
	Col("Hotkey", UFO(128, 0), UFO(72, 16), TXA.Center)
	Col("Status", UFO(200, 0), UFO(56, 16), TXA.Right)

	Add("Frame", {
		Parent = Body;
		Name = "Divider";
		Size = UD2(1, 0, 0, 1);
		BackgroundColor3 = RGB(21, 21, 23);
		BorderSizePixel = 0;
		LayoutOrder = 2;
	})

	local Rows = Add("Frame", {
		Parent = Body;
		Name = "Rows";
		BackgroundTransparency = 1;
		Size = UD2(1, 0, 0, 0);
		AutomaticSize = AS.Y;
		LayoutOrder = 3;
	})
	Add("UIListLayout", { Parent = Rows; SortOrder = SO.LayoutOrder; Padding = UD(0, 2); })

	BindDrag(Panel, Header, true)
	Panel:GetPropertyChangedSignal("Position"):Connect(function()
		local P = Panel.Position
		Library.KeybindList.SavedPos = { X = P.X.Offset; Y = P.Y.Offset }
	end)
	task.defer(function()
		if not (Panel and Panel.Parent) then return end
		if Library.KeybindList.SavedPos then
			Panel.Position = ClampToScreen(Panel, UFO(Library.KeybindList.SavedPos.X, Library.KeybindList.SavedPos.Y))
		else
			Panel.Position = ClampToScreen(Panel, Panel.Position)
		end
	end)

	Library.KeybindList.Frame = Panel
	Library.KeybindList.Body = Body
	Library.KeybindList.RowsFolder = Rows
	Library.KeybindList.Rows = {}
	Library.KeybindList.Accent = HeaderIcon

	for _, Entry in pairs(Library.KeybindRegistry or {}) do
		Library.UpdateKeybindList(Entry.Name, Entry.KeyText, Entry.Active, Entry.Mode)
	end
end

Library.UpdateKeybindList = function(Name: string, KeyText: string, Active: boolean?, Mode: string?)
	if not Library.KeybindList.Enabled then
		return
	end
	if not Library.KeybindList.Frame or not Library.KeybindList.RowsFolder then
		Library.SetKeybindList(true)
	end

	Mode = Mode or "Toggle"
	KeyText = KeyText or "—"
	local Rows = Library.KeybindList.Rows
	local Folder = Library.KeybindList.RowsFolder
	local T = Library.Theme
	local Row = Rows[Name]

	if not Row then
		local Frame = Add("TextButton", {
			Parent = Folder;
			Text = "";
			AutoButtonColor = false;
			BackgroundColor3 = RGB(25, 25, 29);
			BackgroundTransparency = 1;
			Size = UD2(1, 0, 0, 26);
			BorderSizePixel = 0;
			ZIndex = 122;
		})
		Add("UICorner", { Parent = Frame; CornerRadius = UD(0, 6); })

		local NameLbl = Add("TextLabel", {
			Parent = Frame;
			Name = "Name";
			BackgroundTransparency = 1;
			Position = UFO(6, 0);
			Size = UFO(118, 26);
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			Text = Name;
			TextColor3 = T.Text;
			TextSize = 12;
			TextXAlignment = TXA.Left;
			TextTruncate = ETT.AtEnd;
		})
		local KeyLbl = Add("TextLabel", {
			Parent = Frame;
			Name = "Key";
			BackgroundTransparency = 1;
			Position = UFO(128, 0);
			Size = UFO(72, 26);
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			Text = KeyText;
			TextColor3 = T.Text;
			TextSize = 12;
			TextXAlignment = TXA.Center;
			TextTruncate = ETT.AtEnd;
		})
		local StatusLbl = Add("TextLabel", {
			Parent = Frame;
			Name = "Status";
			BackgroundTransparency = 1;
			Position = UFO(200, 0);
			Size = UFO(56, 26);
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			Text = Mode;
			TextColor3 = RGB(160, 160, 165);
			TextSize = 12;
			TextXAlignment = TXA.Right;
		})

		Frame.MouseEnter:Connect(function()
			if Frame:GetAttribute("Active") then return end
			Tween(Frame, { BackgroundTransparency = 0.55 }, 0.12)
		end)
		Frame.MouseLeave:Connect(function()
			if Frame:GetAttribute("Active") then
				Tween(Frame, { BackgroundTransparency = 0 }, 0.12)
			else
				Tween(Frame, { BackgroundTransparency = 1 }, 0.12)
			end
		end)

		Row = { Frame = Frame; Name = NameLbl; Key = KeyLbl; Status = StatusLbl }
		Rows[Name] = Row
	end

	Row.Key.Text = KeyText
	Row.Status.Text = Mode
	Row.Frame:SetAttribute("Active", Active == true)

	if Active then
		Tween(Row.Frame, { BackgroundTransparency = 0 }, 0.12)
		Row.Name.TextColor3 = T.Text
		Row.Key.TextColor3 = T.Accent
		Row.Status.TextColor3 = T.Accent
	else
		Tween(Row.Frame, { BackgroundTransparency = 1 }, 0.12)
		Row.Name.TextColor3 = T.Text
		Row.Key.TextColor3 = T.Text
		Row.Status.TextColor3 = RGB(160, 160, 165)
	end
end

Library._NotifyOrder = 0
Library._Toasts = {}
Library.MaxNotifications = 4
Library.NotifyToggles = true

Library.Notify = function(propertyTable: {})
	local Props = Overwrite({
		Title = "Notification";
		Text = "";
		Content = nil;
		Duration = 4;
		Type = "Info";
		Icon = nil;
	}, propertyTable or {})

	local Content = Props.Content or Props.Text or Props.Message or ""
	local Duration = Props.Duration or 4
	local T = Library.Theme

	local TypeColor = T.Text
	if Props.Type == "Success" then
		TypeColor = RGB(150, 220, 170)
	elseif Props.Type == "Warning" or Props.Type == "Warn" then
		TypeColor = RGB(240, 176, 108)
	elseif Props.Type == "Error" then
		TypeColor = RGB(240, 120, 120)
	end

	local Gui = EnsureOverlayGui()
	if not Library._NotifyHost then
		Library._NotifyHost = Add("Frame", {
			Parent = Gui;
			Name = "Notifications";
			BackgroundTransparency = 1;
			Size = UFO(220, 0);
			AutomaticSize = AS.Y;
			ZIndex = 200;
		})
		Add("UIListLayout", {
			Parent = Library._NotifyHost;
			Padding = UD(0, 10);
			SortOrder = SO.LayoutOrder;
			HorizontalAlignment = HFA.Right;
		})
	end

	local Pos = Library.NotifyPosition or "Top Right"
	local Layout = Library._NotifyHost:FindFirstChildOfClass("UIListLayout")
	if Pos == "Top Left" then
		Library._NotifyHost.AnchorPoint = V2(0, 0)
		Library._NotifyHost.Position = UFO(16, 16)
		Layout.HorizontalAlignment = HFA.Left
	elseif Pos == "Bottom Left" then
		Library._NotifyHost.AnchorPoint = V2(0, 1)
		Library._NotifyHost.Position = UD2(0, 16, 1, -16)
		Layout.HorizontalAlignment = HFA.Left
	elseif Pos == "Bottom Right" then
		Library._NotifyHost.AnchorPoint = V2(1, 1)
		Library._NotifyHost.Position = UD2(1, -16, 1, -16)
		Layout.HorizontalAlignment = HFA.Right
	else
		Library._NotifyHost.AnchorPoint = V2(1, 0)
		Library._NotifyHost.Position = UD2(1, -16, 0, 16)
		Layout.HorizontalAlignment = HFA.Right
	end

	Library._NotifyOrder = (Library._NotifyOrder or 0) + 1

	local HasBody = Content ~= ""
	local CardH = HasBody and 52 or 36
	local SlideDir = (string.find(Pos, "Left") and -1) or 1

	local Slot = Add("Frame", {
		Parent = Library._NotifyHost;
		Size = UD2(1, 0, 0, CardH + 4);
		BackgroundTransparency = 1;
		LayoutOrder = Library._NotifyOrder;
		ClipsDescendants = false;
	})

	local Shell = Add("Frame", {
		Parent = Slot;
		Position = UFO(280 * SlideDir, 0);
		Size = UD2(1, 0, 0, CardH);
		BackgroundTransparency = 1;
	})

	local Shadow = Add("ImageLabel", {
		Parent = Shell;
		Position = UFO(-12, -12);
		Size = UD2(1, 24, 1, 24);
		BackgroundTransparency = 1;
		Image = "rbxassetid://6014261993";
		ImageColor3 = RGB(0, 0, 0);
		ImageTransparency = 1;
		ScaleType = SCL.Slice;
		SliceCenter = Rect.new(49, 49, 450, 450);
		ZIndex = 0;
	})

	local Card = Add("CanvasGroup", {
		Parent = Shell;
		Size = UFS(1, 1);
		BackgroundColor3 = T.Background or RGB(14, 14, 16);
		BorderSizePixel = 0;
		GroupTransparency = 1;
		ZIndex = 1;
	})
	Add("UICorner", { Parent = Card; CornerRadius = UD(0, 8); })
	local CardStroke = Add("UIStroke", {
		Parent = Card;
		ApplyStrokeMode = ASM.Border;
		Color = T.Border or RGB(30, 30, 36);
		Thickness = 1;
	})

	Add("Frame", {
		Parent = Card;
		Size = UD2(1, 0, 0, 1);
		BackgroundColor3 = RGB(255, 255, 255);
		BackgroundTransparency = 0.93;
		BorderSizePixel = 0;
		ZIndex = 2;
	})

	local Body = Add("Frame", {
		Parent = Card;
		Size = UD2(1, 0, 1, -6);
		BackgroundTransparency = 1;
		ZIndex = 3;
	})
	Add("UIPadding", {
		Parent = Body;
		PaddingLeft = UD(0, 10);
		PaddingRight = UD(0, 6);
		PaddingTop = UD(0, 6);
		PaddingBottom = UD(0, 4);
	})

	Add("TextLabel", {
		Parent = Body;
		BackgroundTransparency = 1;
		Size = UD2(1, -16, 0, 14);
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		Text = Props.Title or "Notification";
		TextColor3 = TypeColor;
		TextSize = 12;
		TextXAlignment = TXA.Left;
		TextTruncate = ETT.AtEnd;
		ZIndex = 4;
	})

	local Close = Add("TextButton", {
		Parent = Body;
		AnchorPoint = V2(1, 0);
		Position = UD2(1, 0, 0, -2);
		Size = UFO(16, 16);
		BackgroundTransparency = 1;
		Text = "x";
		TextColor3 = RGB(140, 144, 155);
		TextSize = 12;
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		AutoButtonColor = false;
		ZIndex = 5;
	})
	Close.MouseEnter:Connect(function()
		Tween(Close, { TextColor3 = T.Text }, 0.12)
	end)
	Close.MouseLeave:Connect(function()
		Tween(Close, { TextColor3 = RGB(140, 144, 155) }, 0.15)
	end)

	if HasBody then
		Add("TextLabel", {
			Parent = Body;
			BackgroundTransparency = 1;
			Position = UFO(0, 15);
			Size = UD2(1, -4, 0, 14);
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			Text = Content;
			TextColor3 = RGB(155, 158, 168);
			TextSize = 11;
			TextXAlignment = TXA.Left;
			TextTruncate = ETT.AtEnd;
			ZIndex = 4;
		})
	end

	local BarBG = Add("Frame", {
		Parent = Card;
		AnchorPoint = V2(0, 1);
		Position = UD2(0, 10, 1, -4);
		Size = UD2(1, -20, 0, 2);
		BackgroundColor3 = T.SurfaceAlt or RGB(28, 28, 30);
		BorderSizePixel = 0;
		ZIndex = 5;
	})
	Add("UICorner", { Parent = BarBG; CornerRadius = UD(1, 0); })
	local Bar = Add("Frame", {
		Parent = BarBG;
		Size = UFS(1, 1);
		BackgroundColor3 = T.Accent;
		BorderSizePixel = 0;
	})
	Add("UICorner", { Parent = Bar; CornerRadius = UD(1, 0); })

	Tween(Shell, { Position = UFO(0, 0) }, 0.35, ES.Quint)
	Tween(Card, { GroupTransparency = 0 }, 0.22)
	Tween(Shadow, { ImageTransparency = 0.7 }, 0.3)
	Tween(Bar, { Size = UD2(0, 0, 1, 0) }, Duration, ES.Linear)

	local Closed = false
	local function Dismiss()
		if Closed then return end
		Closed = true
		for i, Fn in Library._Toasts do
			if Fn == Dismiss then
				table.remove(Library._Toasts, i)
				break
			end
		end
		Slot.ClipsDescendants = true
		Tween(Shell, { Position = UFO(280 * SlideDir, 0) }, 0.25, ES.Quint)
		Tween(Card, { GroupTransparency = 1 }, 0.18)
		Tween(CardStroke, { Transparency = 1 }, 0.12)
		Tween(Shadow, { ImageTransparency = 1 }, 0.18)
		task.delay(0.2, function()
			Tween(Slot, { Size = UD2(1, 0, 0, 0) }, 0.18, ES.Quint)
			task.delay(0.2, function()
				Slot:Destroy()
			end)
		end)
	end

	task.delay(Duration, Dismiss)
	Close.Activated:Connect(Dismiss)
	TIS(Library._Toasts, Dismiss)

	while #Library._Toasts > (Library.MaxNotifications or 4) do
		local Oldest = table.remove(Library._Toasts, 1)
		if Oldest then Oldest() end
	end

	return { Dismiss = Dismiss }
end

Library.Unload = function()
	Library.ToggleMenu(false)
	if Library.Watermark.Frame then Library.Watermark.Frame.Visible = false end
	if Library.KeybindList.Frame then Library.KeybindList.Frame.Visible = false end
	if Library._NotifyHost then Library._NotifyHost.Visible = false end
	for _, Win in Library.Windows do
		if Win.Canvas then
			Win.Canvas:Destroy()
		end
	end
	table.clear(Library.Windows)
	if Library._Instance then
		Library._Instance:Destroy()
	end
	Library.Notify({ Title = "Noctro"; Text = "Unloaded"; Duration = 2 })
end

Library.ToggleMenu = function(State: boolean?)
	if Library.Auth and Library.Auth.Enabled and not Library.Auth.Validated then
		State = true
	end
	if State == nil then
		State = not Library.MenuOpen
	end
	Library.MenuOpen = State
	for _, Win in Library.Windows do
		if Win.Canvas then
			Win.Canvas.Visible = State
		end
	end
	if Library.OpenPopup and Library.OpenPopup.Close then
		Library.OpenPopup.Close()
	end
end

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then
		return
	end
	if Library.MenuKey and Input.KeyCode == Library.MenuKey then
		Library.ToggleMenu()
	end
end)

Library.BuildConfigPage = function(self: Library, Window: any)
	local Page = Window:Page({ Icon = "save" })
	local Manager = Page:SubPage({ Name = "Configs" })
	local ThemePage = Page:SubPage({ Name = "Theme" })
	local MenuPage = Page:SubPage({ Name = "Menu" })

	local ListSection = Manager:Section({ Name = "Configs"; Side = "Left"; Icon = "folder" })
	local ActionsSection = Manager:Section({ Name = "Actions"; Side = "Right"; Icon = "settings" })
	local ThemeSection = ThemePage:Section({ Name = "Colors"; Side = "Left"; Icon = "palette" })
	local ThemePrev = ThemePage:Section({ Name = "Preview"; Side = "Right"; Icon = "eye" })
	local MenuSection = MenuPage:Section({ Name = "Menu"; Side = "Left"; Icon = "settings" })
	local NotifySection = MenuPage:Section({ Name = "Notifications"; Side = "Right"; Icon = "bell" })

	local Selected = { Name = nil :: string? }
	local ListRows = {} :: { [string]: TextButton }

	local ListHost = Add("Frame", {
		Parent = ListSection.Content;
		Name = "ConfigList";
		BackgroundColor3 = Library.Theme.Background;
		BorderSizePixel = 0;
		Size = UD2(1, 0, 0, 160);
	})
	Add("UICorner", { Parent = ListHost; CornerRadius = UD(0, 6); })
	Add("UIStroke", { Parent = ListHost; ApplyStrokeMode = ASM.Border; Color = Library.Theme.Border; })
	local ListScroll = Add("ScrollingFrame", {
		Parent = ListHost;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Size = UFS(1, 1);
		CanvasSize = UD2(0, 0, 0, 0);
		AutomaticCanvasSize = AS.Y;
		ScrollBarThickness = 2;
		ScrollBarImageColor3 = Library.Theme.Accent;
	})
	Add("UIListLayout", { Parent = ListScroll; Padding = UD(0, 2); SortOrder = SO.LayoutOrder; })
	Add("UIPadding", { Parent = ListScroll; PaddingTop = UD(0, 4); PaddingBottom = UD(0, 4); PaddingLeft = UD(0, 4); PaddingRight = UD(0, 4); })

	local function PaintRows()
		for Name, Row in ListRows do
			local On = Selected.Name == Name
			Row.TextColor3 = On and Library.Theme.Accent or RGB(200, 204, 220)
			Row.BackgroundTransparency = On and 0.85 or 1
			Row.BackgroundColor3 = Library.Theme.Accent
		end
	end

	local function SelectConfig(Name: string)
		Selected.Name = Name
		if ConfigInput then
			ConfigInput.Set(Name)
		end
		PaintRows()
	end

	local function RebuildList()
		for _, Row in ListRows do
			Row:Destroy()
		end
		table.clear(ListRows)
		local Names = Library.ListConfigs()
		if #Names == 0 then
			local Empty = Add("TextLabel", {
				Parent = ListScroll;
				BackgroundTransparency = 1;
				Size = UD2(1, 0, 0, 28);
				FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
				Text = "No configs yet";
				TextColor3 = RGB(120, 124, 140);
				TextSize = 12;
			})
			ListRows["__empty"] = Empty :: any
		else
			for i, Name in Names do
				local Row = Add("TextButton", {
					Parent = ListScroll;
					AutoButtonColor = false;
					BackgroundColor3 = Library.Theme.Accent;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Size = UD2(1, 0, 0, 26);
					FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
					Text = "  " .. Name;
					TextColor3 = RGB(200, 204, 220);
					TextSize = 13;
					TextXAlignment = TXA.Left;
					LayoutOrder = i;
				})
				Add("UICorner", { Parent = Row; CornerRadius = UD(0, 4); })
				Row.Activated:Connect(function()
					SelectConfig(Name)
				end)
				ListRows[Name] = Row
			end
		end
		if Selected.Name and ListRows[Selected.Name] then
			PaintRows()
		elseif #Names > 0 then
			SelectConfig(Names[1])
		end
	end

	local ConfigInput = ActionsSection:Input({
		Name = "New name (for Save)";
		Value = "default";
		Placeholder = "name";
		Flag = "ConfigName";

	})

	local function SelectedName(): string?
		return Selected.Name
	end

	ActionsSection:Button({
		Name = "Save";
		Width = 0.5;
		Callback = function()
			local Name = Selected.Name
			if not Name or Name == "" then
				local Typed = ConfigInput and ConfigInput.Value
				if type(Typed) == "string" and Typed ~= "" then
					Name = Typed
				else
					Library.Notify({ Title = "Config"; Content = "Select a config or type a name"; Type = "Warning" })
					return
				end
			end
			if Library.SaveConfig(Name) then
				SelectConfig(Name)
				RebuildList()
				Library.Notify({ Title = "Config"; Content = "Saved " .. Name; Type = "Success" })
			else
				Library.Notify({ Title = "Config"; Content = "Save failed — executor FS?"; Type = "Error" })
			end
		end;
	})
	ActionsSection:Button({
		Name = "Load";
		Width = 0.5;
		Callback = function()
			local Name = SelectedName()
			if not Name then
				Library.Notify({ Title = "Config"; Content = "Select a config in the list first"; Type = "Warning" })
				return
			end
			if Library.LoadConfig(Name) then
				Library.ApplyTheme()
				if Library.SyncThemePickers then
					Library.SyncThemePickers()
				end
				SelectConfig(Name)
				Library.Notify({ Title = "Config"; Content = "Loaded " .. Name; Type = "Success" })
			else
				Library.Notify({ Title = "Config"; Content = "Failed to load " .. Name; Type = "Error" })
			end
		end;
	})
	ActionsSection:Button({
		Name = "Delete";
		Width = 0.5;
		Callback = function()
			local Name = SelectedName()
			if not Name then
				Library.Notify({ Title = "Config"; Content = "Select a config in the list first"; Type = "Warning" })
				return
			end
			Library.DeleteConfig(Name)
			Selected.Name = nil
			RebuildList()
			Library.Notify({ Title = "Config"; Content = "Deleted " .. Name; Type = "Info" })
		end;
	})
	ActionsSection:Button({
		Name = "Refresh";
		Width = 0.5;
		Callback = function()
			RebuildList()
			Library.Notify({ Title = "Config"; Content = "List refreshed"; Type = "Info"; Duration = 1.5 })
		end;
	})
	ActionsSection:Button({
		Name = "Set autoload";
		Callback = function()
			local Name = SelectedName()
			if not Name then
				Library.Notify({ Title = "Config"; Content = "Select a config in the list first"; Type = "Warning" })
				return
			end
			Library.SetAutoload(Name)
			Library.Notify({ Title = "Config"; Content = "Autoload set to " .. Name; Type = "Success" })
		end;
	})

	RebuildList()

	local ThemePickers = {}

	local function ThemePicker(LabelText: string, Key: string)
		local Row = ThemeSection:Label({ Text = LabelText })
		local Picker = Row:Colorpicker({
			Color = Library.Theme[Key];
			Flag = "Theme" .. Key;
			Callback = function(Color)
				Library.Theme[Key] = Color
				if Key == "Accent" then
					local H, S, V = Color:ToHSV()
					Library.Theme.AccentDark = HSV(H, S, math.max(V * 0.55, 0.15))
				end
				Library.ApplyTheme()
			end;
		})
		ThemePickers[Key] = Picker
	end

	ThemePicker("Accent", "Accent")
	ThemePicker("Background", "Background")
	ThemePicker("Surface", "Surface")
	ThemePicker("Surface alt", "SurfaceAlt")
	ThemePicker("Border", "Border")
	ThemePicker("Section border", "SectionBorder")
	ThemePicker("Text", "Text")

	Library.SyncThemePickers = function()
		for Key, Picker in pairs(ThemePickers) do
			local Color = Library.Theme[Key]
			if Color and Picker and Picker.Set then
				Picker.Set(Color, 0)
			end
		end
	end

	ThemePrev:Paragraph({
		Title = "Live theme";
		Body = "Changes apply immediately to the menu, watermark, and keybind list.";
	})
	ThemePrev:Button({
		Name = "Reset theme";
		Callback = function()
			for Key, Color in pairs(Library.DefaultTheme) do
				Library.Theme[Key] = Color
			end
			Library.ApplyTheme()
			if Library.SyncThemePickers then
				Library.SyncThemePickers()
			end
			Library.Notify({ Title = "Theme"; Content = "Reset to default"; Type = "Info" })
		end;
	})

	local MenuKeyLabel = MenuSection:Label({ Text = "Menu key" })
	MenuKeyLabel:Keybind({
		Title = "Menu";
		Key = Library.MenuKey;
		Type = "Toggle";
		Flag = "MenuKeybind";
		Callback = function() end;
	})
	task.defer(function()
		local Flag = Library.Flags["MenuKeybind"]
		if Flag then
			local OldSet = Flag.Set
			Flag.Set = function(Key)
				if OldSet then OldSet(Key) end
				if Key then Library.MenuKey = Key end
			end
		end
	end)

	MenuSection:Slider({
		Name = "UI scale";
		Suffix = "%";
		Value = math.floor(Library.UIScale * 100);
		Min = 75;
		Max = 125;
		Increment = 5;
		Flag = "UIScale";
		Callback = function(Value)
			Library.SetScale(Value / 100)
		end;
	})
	local WM = MenuSection:Label({ Text = "Watermark" })
	WM:Toggle({
		State = Library.Watermark.Enabled;
		Flag = "WatermarkEnabled";
		Callback = function(State)
			Library.SetWatermark(nil, State)
		end;
	})
	local KBL = MenuSection:Label({ Text = "Keybind list" })
	KBL:Toggle({
		State = Library.KeybindList.Enabled;
		Flag = "KeybindListEnabled";
		Callback = function(State)
			Library.SetKeybindList(State)
		end;
	})
	MenuSection:Button({
		Name = "Hide menu";
		Width = 0.5;
		Callback = function()
			Library.ToggleMenu(false)
			Library.Notify({ Title = "Noctro"; Text = "Menu hidden - press menu key"; Duration = 2 })
		end;
	})
	MenuSection:Button({
		Name = "Unload";
		Width = 0.5;
		Callback = function()
			Library.Unload()
		end;
	})
	if Library.Auth and Library.Auth.Enabled then
		MenuSection:Button({
			Name = "Sign out";
			Callback = function()
				Library.SignOut()
			end;
		})
	end

	NotifySection:Dropdown({
		Name = "Position";
		Options = { "Top Left", "Top Right", "Bottom Left", "Bottom Right" };
		Value = Library.NotifyPosition;
		Flag = "NotifyPosition";
		Callback = function(Value)
			Library.NotifyPosition = Value
		end;
	})
	local NT = NotifySection:Label({ Text = "Notify on toggles" })
	NT:Toggle({
		State = Library.NotifyToggles ~= false;
		Flag = "NotifyToggles";
		Callback = function(State)
			Library.NotifyToggles = State
		end;
	})
	NotifySection:Button({
		Name = "Test notification";
		Callback = function()
			Library.Notify({ Title = "Noctro"; Text = "This is a test notification"; Type = "Success" })
		end;
	})

	local Autoload = Library.GetAutoload()
	if Autoload then
		Library.LoadConfig(Autoload)
		Library.ApplyTheme()
		if Library.SyncThemePickers then
			Library.SyncThemePickers()
		end
		SelectConfig(Autoload)
	end

	return Page
end


Library.FormatExpiry = function(ExpiresAt)
	if not ExpiresAt or type(ExpiresAt) ~= "number" then
		return "Lifetime"
	end
	local Left = math.floor(ExpiresAt - os.time())
	if Left <= 0 then
		return "Expired"
	end
	local Days = math.floor(Left / 86400)
	local Hours = math.floor((Left % 86400) / 3600)
	local Mins = math.floor((Left % 3600) / 60)
	local Parts = {}
	if Days > 0 then
		table.insert(Parts, string.format("%dd", Days))
	end
	if Hours > 0 then
		table.insert(Parts, string.format("%dh", Hours))
	end
	if Mins > 0 and Days == 0 then
		table.insert(Parts, string.format("%dm", Mins))
	end
	if #Parts == 0 then
		return "1m"
	end
	return table.concat(Parts, " ")
end

Library.GetKeyExpiryText = function()
	if not Library.Auth or not Library.Auth.Validated then
		return ""
	end
	return Library.FormatExpiry(Library.Auth.ExpiresAt)
end

Library.KeySystem = function(self, propertyTable)
	local Opts = Overwrite({
		Title = "Login";
		Note = "";
		Placeholder = "License key";
		ButtonText = "Sign in";
		Remember = true;
		RememberFile = "auth_key.txt";
		ShowExpiry = true;
		WatermarkExpiry = false;
		GetKey = nil;
		Validate = nil;
	}, propertyTable or {})

	Library.Auth.Enabled = true
	Library.Auth.Validated = false
	Library.Auth.Token = nil
	Library.Auth.ExpiresAt = nil
	Library.Auth.ShowExpiry = Opts.ShowExpiry == true
	Library.Auth.WatermarkExpiry = Opts.WatermarkExpiry == true
	Library.Auth.Options = Opts
	return Opts
end

local function AuthRememberPath()
	local Opts = Library.Auth and Library.Auth.Options
	local Name = (Opts and Opts.RememberFile) or "auth_key.txt"
	return Library.Folder .. "/" .. Name
end

local function ReadRememberedKey()
	if not HasFS() then
		return nil
	end
	local Path = AuthRememberPath()
	local Ok, Data = pcall(function()
		if isfile and isfile(Path) then
			return readfile(Path)
		end
		return nil
	end)
	if Ok and type(Data) == "string" and Data ~= "" then
		return Data
	end
	return nil
end

local function WriteRememberedKey(Key, Remember)
	if not HasFS() then
		return
	end
	EnsureFolder()
	local Path = AuthRememberPath()
	if Remember and Key and Key ~= "" then
		pcall(writefile, Path, Key)
	else
		pcall(function()
			if isfile and isfile(Path) and delfile then
				delfile(Path)
			elseif writefile then
				writefile(Path, "")
			end
		end)
	end
end

local function RunValidate(Key, Finish)
	local Opts = Library.Auth.Options
	if not Opts or type(Opts.Validate) ~= "function" then
		Finish(true, nil, nil)
		return
	end
	local called = false
	local function SafeFinish(Success, ExpiresAt, Err)
		if called then return end
		called = true
		Finish(Success, ExpiresAt, Err)
	end
	local Ok, A, B, C = pcall(function()
		return Opts.Validate(Key, SafeFinish)
	end)
	if not Ok then
		SafeFinish(false, nil, tostring(A))
		return
	end
	if A == true or A == false then
		SafeFinish(A, B, C)
	end
end


Library.SignOut = function()
	if not Library.Auth or not Library.Auth.Enabled then
		return
	end
	WriteRememberedKey(nil, false)
	Library.Auth.Validated = false
	Library.Auth.Token = nil
	Library.Auth.ExpiresAt = nil
	for _, Win in Library.Windows do
		if Win.Canvas then
			local Footer = Win.Canvas:FindFirstChild("Footer")
			if Footer then
				local Exp = Footer:FindFirstChild("KeyExpiry")
				if Exp then Exp:Destroy() end
			end
			if Library._MountKeySystem then
				Library._MountKeySystem(Win)
			end
		end
	end
	Library.Notify({ Title = "Key system"; Content = "Signed out"; Type = "Info"; Duration = 2 })
end

Library._MountKeySystem = function(Window)
	if not Library.Auth or not Library.Auth.Enabled or Library.Auth.Validated then
		return
	end
	local Canvas = Window and Window.Canvas
	if not Canvas then
		return
	end
	local Opts = Library.Auth.Options or {}
	local T = Library.Theme

	local Hidden = {}
	for _, Ch in ipairs(Canvas:GetChildren()) do
		if Ch:IsA("GuiObject") and Ch.Name ~= "UIScale" then
			Hidden[Ch] = Ch.Visible
			Ch.Visible = false
		end
	end

	task.defer(function()
		local Camera = workspace.CurrentCamera
		if Camera and Canvas.Parent then
			local Viewport = Camera.ViewportSize
			local Size = Canvas.AbsoluteSize
			if Size.X <= 0 then Size = V2(658, 461) end
			local GuiService = Services:GetService("GuiService")
			local Inset = GuiService:GetGuiInset()
			Canvas.Position = ClampToScreen(Canvas, UFO(
				math.floor((Viewport.X - Size.X) * 0.5),
				math.floor((Viewport.Y - Inset.Y - Size.Y) * 0.5)
			))
		end
	end)

	local Layer = Add("Frame", {
		Parent = Canvas;
		Name = "KeySystem";
		Size = UFS(1, 1);
		BackgroundColor3 = T.Background or RGB(9, 8, 8);
		BorderSizePixel = 0;
		ZIndex = 80;
		Active = true;
	})
	Add("UICorner", { Parent = Layer; CornerRadius = UD(0, 5); })
	Add("UIStroke", { Parent = Layer; ApplyStrokeMode = ASM.Border; Color = T.Border or RGB(36, 37, 37); })
	Add("UIShadow", { Parent = Layer; BlurRadius = UD(0, 20); Spread = UFO(5, 5); Transparency = 0.65; })
	Library.ThemeLink(Layer, "BackgroundColor3", "Background")
	BindDrag(Canvas, Layer, true)

	local Hair = Add("Frame", {
		Parent = Layer;
		Size = UD2(1, 0, 0, 1);
		BackgroundColor3 = RGB(255, 255, 255);
		BackgroundTransparency = 0.93;
		BorderSizePixel = 0;
		ZIndex = 81;
	})

	local AccentGlow = Add("ImageLabel", {
		Parent = Layer;
		AnchorPoint = V2(0.5, 0.5);
		Position = UFS(0.5, 0.42);
		Size = UFO(480, 360);
		BackgroundTransparency = 1;
		Image = "rbxassetid://8992230677";
		ImageColor3 = T.Accent;
		ImageTransparency = 0.9;
		ZIndex = 80;
	})
	Library.ThemeLink(AccentGlow, "ImageColor3", "Accent")

	local SideGlow = Add("ImageLabel", {
		Parent = Layer;
		AnchorPoint = V2(0, 1);
		Position = UD2(0, -20, 1, 20);
		Size = UFO(220, 180);
		BackgroundTransparency = 1;
		Image = "rbxassetid://8992230677";
		ImageColor3 = T.AccentDark or T.Accent;
		ImageTransparency = 0.92;
		ZIndex = 80;
	})

	local Form = Add("Frame", {
		Parent = Layer;
		AnchorPoint = V2(0.5, 0.5);
		Position = UFS(0.5, 0.5);
		Size = UFO(300, 0);
		AutomaticSize = AS.Y;
		BackgroundTransparency = 1;
		ZIndex = 81;
	})

	Add("TextLabel", {
		Parent = Form;
		BackgroundTransparency = 1;
		Size = UD2(1, 0, 0, 28);
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		Text = Opts.Title or "Login";
		TextColor3 = T.Text or RGB(255, 255, 255);
		TextSize = 22;
		ZIndex = 82;
	})

	local Under = Add("Frame", {
		Parent = Form;
		AnchorPoint = V2(0.5, 0);
		Position = UD2(0.5, 0, 0, 32);
		Size = UFO(56, 2);
		BackgroundColor3 = T.Accent;
		BorderSizePixel = 0;
		ZIndex = 82;
	})
	Library.ThemeLink(Under, "BackgroundColor3", "Accent")

	local KeyWrap = Add("Frame", {
		Parent = Form;
		Position = UFO(0, 52);
		Size = UD2(1, 0, 0, 42);
		BackgroundColor3 = T.Surface or RGB(15, 14, 15);
		BorderSizePixel = 0;
		ZIndex = 82;
	})
	Add("UICorner", { Parent = KeyWrap; CornerRadius = UD(0, 6); })
	Add("UIStroke", { Parent = KeyWrap; ApplyStrokeMode = ASM.Border; Color = T.Border or RGB(36, 37, 37); })
	Library.ThemeLink(KeyWrap, "BackgroundColor3", "Surface")
	local KeyIcon = Add("ImageLabel", {
		Parent = KeyWrap;
		AnchorPoint = V2(0, 0.5);
		Position = UD2(0, 12, 0.5, 0);
		Size = UFO(14, 14);
		BackgroundTransparency = 1;
		ImageColor3 = RGB(140, 144, 155);
		ZIndex = 83;
	})
	pcall(function() KeyIcon.Image = ResolveIcon("key-round") end)
	local KeyBox = Add("TextBox", {
		Parent = KeyWrap;
		Position = UFO(36, 0);
		Size = UD2(1, -48, 1, 0);
		BackgroundTransparency = 1;
		PlaceholderText = Opts.Placeholder or "License key";
		PlaceholderColor3 = RGB(120, 124, 135);
		Text = "";
		TextColor3 = T.Text;
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		TextSize = 13;
		TextXAlignment = TXA.Left;
		ClearTextOnFocus = false;
		ZIndex = 83;
	})

	local SignIn = Add("TextButton", {
		Parent = Form;
		Position = UFO(0, 106);
		Size = UD2(1, 0, 0, 42);
		BackgroundColor3 = RGB(255, 255, 255);
		AutoButtonColor = false;
		Text = Opts.ButtonText or "Sign in";
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		TextSize = 14;
		TextColor3 = RGB(0, 0, 0);
		BorderSizePixel = 0;
		ZIndex = 82;
	})
	Add("UICorner", { Parent = SignIn; CornerRadius = UD(0, 6); })
	local SignGrad = Add("UIGradient", {
		Parent = SignIn;
		Color = CS{ CSK(0, T.AccentDark or RGB(78, 88, 129)), CSK(1, T.Accent or RGB(138, 156, 229)) };
		Rotation = -70;
	})
	Library.ThemeLink(SignGrad, "Gradient", "AccentDark", "Accent")

	local RememberOn = Opts.Remember ~= false
	local RememberRow = Add("Frame", {
		Parent = Form;
		Position = UFO(0, 158);
		Size = UD2(1, 0, 0, 20);
		BackgroundTransparency = 1;
		ZIndex = 82;
	})
	local RememberBtn = Add("TextButton", {
		Parent = RememberRow;
		Size = UFO(18, 18);
		BackgroundColor3 = T.Surface or RGB(15, 14, 15);
		Text = "";
		AutoButtonColor = false;
		BorderSizePixel = 0;
		ZIndex = 83;
	})
	Add("UICorner", { Parent = RememberBtn; CornerRadius = UD(0, 4); })
	local RemStroke = Add("UIStroke", { Parent = RememberBtn; Color = T.Border or RGB(36, 37, 37); Thickness = 1; })
	local Check = Add("TextLabel", {
		Parent = RememberBtn;
		Size = UFS(1, 1);
		BackgroundTransparency = 1;
		Text = "✓";
		TextColor3 = T.Accent;
		TextSize = 13;
		Font = Enum.Font.GothamBold;
		TextTransparency = RememberOn and 0 or 1;
		ZIndex = 84;
	})
	if RememberOn then
		RememberBtn.BackgroundColor3 = T.Accent
		Check.TextColor3 = RGB(255, 255, 255)
		RemStroke.Transparency = 1
	end
	Add("TextLabel", {
		Parent = RememberRow;
		Position = UFO(22, 0);
		Size = UD2(1, -22, 1, 0);
		BackgroundTransparency = 1;
		Text = "Remember me";
		TextColor3 = RGB(160, 160, 165);
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		TextSize = 12;
		TextXAlignment = TXA.Left;
		ZIndex = 83;
	})
	RememberBtn.Activated:Connect(function()
		RememberOn = not RememberOn
		Tween(RememberBtn, { BackgroundColor3 = RememberOn and Library.Theme.Accent or Library.Theme.Surface }, 0.12)
		Tween(Check, { TextTransparency = RememberOn and 0 or 1; TextColor3 = RememberOn and RGB(255, 255, 255) or Library.Theme.Accent }, 0.12)
		Tween(RemStroke, { Transparency = RememberOn and 1 or 0 }, 0.12)
	end)

	local Error = Add("TextLabel", {
		Parent = Form;
		Position = UFO(0, 198);
		Size = UD2(1, 0, 0, 16);
		BackgroundTransparency = 1;
		Text = "";
		TextColor3 = RGB(240, 120, 120);
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		TextSize = 12;
		ZIndex = 82;
	})

	local NoteY = 178
	if type(Opts.GetKey) == "string" and Opts.GetKey ~= "" then
		local GetBtn = Add("TextButton", {
			Parent = Form;
			Position = UFO(0, NoteY);
			Size = UD2(1, 0, 0, 16);
			BackgroundTransparency = 1;
			Text = "Get a key";
			TextColor3 = T.Accent;
			FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
			TextSize = 12;
			AutoButtonColor = false;
			ZIndex = 82;
		})
		GetBtn.Activated:Connect(function()
			pcall(function()
				if setclipboard then
					setclipboard(Opts.GetKey)
					Library.Notify({ Title = "Key system"; Content = "Link copied"; Type = "Info"; Duration = 2 })
				end
			end)
		end)
	end

	local Loading = Add("Frame", {
		Parent = Canvas;
		Name = "AuthLoading";
		Size = UFS(1, 1);
		BackgroundColor3 = T.Background or RGB(9, 8, 8);
		BorderSizePixel = 0;
		Visible = false;
		ZIndex = 90;
	})
	Add("UICorner", { Parent = Loading; CornerRadius = UD(0, 5); })
	Add("UIStroke", { Parent = Loading; ApplyStrokeMode = ASM.Border; Color = T.Border or RGB(36, 37, 37); })
	Add("UIShadow", { Parent = Loading; BlurRadius = UD(0, 20); Spread = UFO(5, 5); Transparency = 0.65; })
	Library.ThemeLink(Loading, "BackgroundColor3", "Background")
	local Spin = Add("ImageLabel", {
		Parent = Loading;
		AnchorPoint = V2(0.5, 0.5);
		Position = UD2(0.5, 0, 0.48, 0);
		Size = UFO(40, 40);
		BackgroundTransparency = 1;
		Image = "rbxassetid://4965945816";
		ImageColor3 = T.Accent;
		ZIndex = 91;
	})
	Library.ThemeLink(Spin, "ImageColor3", "Accent")
	Add("TextLabel", {
		Parent = Loading;
		AnchorPoint = V2(0.5, 0);
		Position = UD2(0.5, 0, 0.48, 28);
		Size = UFO(160, 18);
		BackgroundTransparency = 1;
		Text = "Signing in...";
		TextColor3 = RGB(160, 160, 165);
		FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
		TextSize = 13;
		ZIndex = 91;
	})
	local SpinConn = RunService.RenderStepped:Connect(function(dt)
		if Loading.Visible then
			Spin.Rotation = (Spin.Rotation + dt * 240) % 360
		end
	end)

	local function RevealMenu()
		Layer:Destroy()
		Loading:Destroy()
		if SpinConn then SpinConn:Disconnect() end
		for Ch, Vis in pairs(Hidden) do
			if Ch and Ch.Parent then
				Ch.Visible = Vis ~= false
			end
		end
		if Library.Auth.ShowExpiry and Library.Auth.ExpiresAt and Window.Canvas then
			local Footer = Window.Canvas:FindFirstChild("Footer")
			if Footer then
				local Exp = Footer:FindFirstChild("KeyExpiry")
				if not Exp then
					Exp = Add("TextLabel", {
						Parent = Footer;
						Name = "KeyExpiry";
						AnchorPoint = V2(0.5, 0.5);
						Position = UFS(0.5, 0.5);
						AutomaticSize = AS.X;
						Size = UFO(0, 13);
						BackgroundTransparency = 1;
						FontFace = FN("rbxassetid://12187365364", FW.SemiBold, FS.Normal);
						TextColor3 = Library.Theme.Accent;
						TextSize = 12;
						TextTransparency = 0.15;
					})
					Library.ThemeLink(Exp, "TextColor3", "Accent")
				end
				local function Tick()
					if not Exp or not Exp.Parent then return end
					Exp.Text = "Key · " .. Library.FormatExpiry(Library.Auth.ExpiresAt)
					if Library.Auth.ExpiresAt and os.time() >= Library.Auth.ExpiresAt then
						Library.Auth.Validated = false
						Library.Auth.Token = nil
						Library.Notify({ Title = "Key system"; Content = "License expired"; Type = "Error" })
						pcall(function() Library.Unload() end)
					end
				end
				Tick()
				task.spawn(function()
					while Exp and Exp.Parent and Library.Auth and Library.Auth.Validated do
						Tick()
						task.wait(30)
					end
				end)
			end
		end
		if Library.Auth.WatermarkExpiry and Library.SetWatermark then
			local Base = Library.Watermark.BaseText or Library.Watermark.Text or "Noctro"
			Library.SetWatermark(Base, Library.Watermark.Enabled)
		end
		Library.Notify({ Title = "Key system"; Content = "Welcome back"; Type = "Success"; Duration = 2.5 })
	end

	local Busy = false
	local function Attempt(Key)
		if Busy then return end
		Key = tostring(Key or ""):gsub("^%s+", ""):gsub("%s+$", "")
		if Key == "" then
			Error.Text = "Enter a license key."
			return
		end
		Busy = true
		Error.Text = ""
		Layer.Visible = false
		Loading.Visible = true

		local finished = false
		local function Finish(Success, ExpiresAt, Err)
			if finished then return end
			finished = true
			if Success then
				Library.Auth.Validated = true
				Library.Auth.Token = tostring(os.clock()) .. tostring(math.random(100000, 999999))
				Library.Auth.ExpiresAt = (type(ExpiresAt) == "number" and ExpiresAt) or nil
				WriteRememberedKey(Key, RememberOn)
				task.delay(0.55, RevealMenu)
			else
				Loading.Visible = false
				Layer.Visible = true
				Error.Text = Err or "Invalid key."
				Busy = false
			end
		end

		task.spawn(function()
			RunValidate(Key, Finish)
		end)
	end

	SignIn.Activated:Connect(function()
		Attempt(KeyBox.Text)
	end)
	KeyBox.FocusLost:Connect(function(Enter)
		if Enter then Attempt(KeyBox.Text) end
	end)

	local Saved = ReadRememberedKey()
	if Saved then
		KeyBox.Text = Saved
		task.defer(function() Attempt(Saved) end)
	end
end


return Library