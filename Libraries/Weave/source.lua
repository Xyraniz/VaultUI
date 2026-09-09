--[=[
    Weave UI Library
    Preserved and cleaned from the supplied Roblox UI export.
    Public entry point:
        local Weave = loadstring(game:HttpGet(URL))()
        local window = Weave:CreateWindow({ Name = "My Hub" })

    The public API is exposed through Weave:CreateWindow and its
    Window, Tab, Section, and element methods.
]=]

-- Instances: 36 | Scripts: 1 | Modules: 0 | Tags: 0
local G2L = {};

-- CoreGui.weave
G2L["1"] = Instance.new("ScreenGui");
G2L["1"]["Name"] = [[weave]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
G2L["1"]["ResetOnSpawn"] = false;
G2L["1"]["IgnoreGuiInset"] = true;
G2L["1"]["DisplayOrder"] = 9999;
G2L["2"] = Instance.new("LocalScript", G2L["1"]);
G2L["2"]["Name"] = [[weave_Driver]];
G2L["2"]["Disabled"] = true;
G2L["3"] = Instance.new("Frame", G2L["1"]);
G2L["3"]["BorderSizePixel"] = 0;
G2L["3"]["BackgroundTransparency"] = 1;
G2L["3"]["Size"] = UDim2.new(0, 670, 0, 478);
G2L["3"]["Position"] = UDim2.new(0.5, -335, 0.5, -239);
G2L["3"]["Name"] = [[window]];
G2L["4"] = Instance.new("Frame", G2L["3"]);
G2L["4"]["BorderSizePixel"] = 0;
G2L["4"]["BackgroundTransparency"] = 1;
G2L["4"]["Size"] = UDim2.new(0, 176, 1, 0);
G2L["4"]["Name"] = [[nav]];
G2L["5"] = Instance.new("Frame", G2L["4"]);
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["5"]["Size"] = UDim2.new(1, 0, 0, 42);
G2L["5"]["Name"] = [[brand]];
G2L["6"] = Instance.new("UICorner", G2L["5"]);
G2L["6"]["CornerRadius"] = UDim.new(0, 4);
G2L["7"] = Instance.new("Frame", G2L["5"]);
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["7"]["BackgroundTransparency"] = 0;
G2L["7"]["ZIndex"] = 1;
G2L["7"]["Size"] = UDim2.new(1, 0, 0, 4);
G2L["7"]["Position"] = UDim2.new(0, 0, 1, -4);
G2L["8"] = Instance.new("Frame", G2L["5"]);
G2L["8"]["BorderSizePixel"] = 0;
G2L["8"]["BackgroundColor3"] = Color3.fromRGB(215, 96, 20);
G2L["8"]["ZIndex"] = 2;
G2L["8"]["Size"] = UDim2.new(1, 0, 0, 2);
G2L["8"]["Position"] = UDim2.new(0, 0, 1, -2);
G2L["8"]["Name"] = [[underline]];
G2L["9"] = Instance.new("TextLabel", G2L["5"]);
G2L["9"]["ZIndex"] = 3;
G2L["9"]["TextSize"] = 17;
G2L["9"]["TextXAlignment"] = Enum.TextXAlignment.Center;
G2L["9"]["TextYAlignment"] = Enum.TextYAlignment.Center;
G2L["9"]["TextTruncate"] = Enum.TextTruncate.AtEnd;
G2L["9"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["9"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["9"]["TextTransparency"] = 0;
G2L["9"]["RichText"] = false;
G2L["9"]["BackgroundTransparency"] = 1;
G2L["9"]["Size"] = UDim2.new(1, -20, 1, -2);
G2L["9"]["Text"] = [[Weave]];
G2L["9"]["Name"] = [[logo]];
G2L["9"]["Position"] = UDim2.new(0, 10, 0, 0);
G2L["a"] = Instance.new("Frame", G2L["4"]);
G2L["a"]["BorderSizePixel"] = 0;
G2L["a"]["BackgroundColor3"] = Color3.fromRGB(16, 16, 16);
G2L["a"]["BackgroundTransparency"] = 0.125;
G2L["a"]["ClipsDescendants"] = false;
G2L["a"]["Size"] = UDim2.new(1, 0, 1, -84);
G2L["a"]["Position"] = UDim2.new(0, 0, 0, 42);
G2L["a"]["Name"] = [[tabs]];
G2L["b"] = Instance.new("ScrollingFrame", G2L["a"]);
G2L["b"]["BorderSizePixel"] = 0;
G2L["b"]["BackgroundTransparency"] = 1;
G2L["b"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["b"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
G2L["b"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["b"]["ScrollBarThickness"] = 2;
G2L["b"]["ScrollBarImageColor3"] = Color3.fromRGB(28, 28, 28);
G2L["b"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
G2L["b"]["ClipsDescendants"] = true;
G2L["b"]["Name"] = [[list]];
G2L["c"] = Instance.new("UIListLayout", G2L["b"]);
G2L["c"]["FillDirection"] = Enum.FillDirection.Vertical;
G2L["c"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["c"]["Padding"] = UDim.new(0, 1);
G2L["d"] = Instance.new("Frame", G2L["4"]);
G2L["d"]["BorderSizePixel"] = 0;
G2L["d"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
G2L["d"]["Size"] = UDim2.new(1, 0, 0, 42);
G2L["d"]["Position"] = UDim2.new(0, 0, 1, -42);
G2L["d"]["Name"] = [[profile]];
G2L["e"] = Instance.new("UICorner", G2L["d"]);
G2L["e"]["CornerRadius"] = UDim.new(0, 4);
G2L["f"] = Instance.new("Frame", G2L["d"]);
G2L["f"]["BorderSizePixel"] = 0;
G2L["f"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
G2L["f"]["BackgroundTransparency"] = 0;
G2L["f"]["ZIndex"] = 1;
G2L["f"]["Size"] = UDim2.new(1, 0, 0, 4);
G2L["f"]["Position"] = UDim2.new(0, 0, 0, 0);
G2L["10"] = Instance.new("Frame", G2L["d"]);
G2L["10"]["BorderSizePixel"] = 0;
G2L["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["10"]["BackgroundTransparency"] = 0.90196078431373;
G2L["10"]["ZIndex"] = 3;
G2L["10"]["Size"] = UDim2.new(1, 0, 0, 1);
G2L["10"]["Name"] = [[line]];
G2L["11"] = Instance.new("ImageLabel", G2L["d"]);
G2L["11"]["BorderSizePixel"] = 0;
G2L["11"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
G2L["11"]["ZIndex"] = 3;
G2L["11"]["Image"] = [[]];
G2L["11"]["Size"] = UDim2.new(0, 24, 0, 24);
G2L["11"]["Position"] = UDim2.new(0, 15, 0.5, -12);
G2L["11"]["Name"] = [[avatar]];
G2L["12"] = Instance.new("UICorner", G2L["11"]);
G2L["12"]["CornerRadius"] = UDim.new(0, 12);
G2L["13"] = Instance.new("TextLabel", G2L["d"]);
G2L["13"]["ZIndex"] = 3;
G2L["13"]["TextSize"] = 17;
G2L["13"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["13"]["TextYAlignment"] = Enum.TextYAlignment.Center;
G2L["13"]["TextTruncate"] = Enum.TextTruncate.AtEnd;
G2L["13"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["13"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["13"]["TextTransparency"] = 0;
G2L["13"]["RichText"] = false;
G2L["13"]["BackgroundTransparency"] = 1;
G2L["13"]["Size"] = UDim2.new(1, -92, 1, 0);
G2L["13"]["Text"] = [[Player]];
G2L["13"]["Name"] = [[username]];
G2L["13"]["Position"] = UDim2.new(0, 47, 0, 0);
G2L["14"] = Instance.new("TextLabel", G2L["d"]);
G2L["14"]["ZIndex"] = 3;
G2L["14"]["TextSize"] = 17;
G2L["14"]["TextXAlignment"] = Enum.TextXAlignment.Right;
G2L["14"]["TextYAlignment"] = Enum.TextYAlignment.Center;
G2L["14"]["TextTruncate"] = Enum.TextTruncate.AtEnd;
G2L["14"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["14"]["TextColor3"] = Color3.fromRGB(100, 100, 100);
G2L["14"]["TextTransparency"] = 0;
G2L["14"]["RichText"] = false;
G2L["14"]["BackgroundTransparency"] = 1;
G2L["14"]["Size"] = UDim2.new(0, 60, 0, 42);
G2L["14"]["Text"] = [[Free]];
G2L["14"]["Name"] = [[expiry]];
G2L["14"]["Position"] = UDim2.new(1, -75, 0, 0);
G2L["15"] = Instance.new("Frame", G2L["3"]);
G2L["15"]["BorderSizePixel"] = 0;
G2L["15"]["BackgroundTransparency"] = 1;
G2L["15"]["Size"] = UDim2.new(1, -185, 1, 0);
G2L["15"]["Position"] = UDim2.new(0, 185, 0, 0);
G2L["15"]["Name"] = [[main]];
G2L["16"] = Instance.new("Frame", G2L["15"]);
G2L["16"]["BorderSizePixel"] = 0;
G2L["16"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["16"]["ZIndex"] = 2;
G2L["16"]["Size"] = UDim2.new(1, 0, 0, 42);
G2L["16"]["Name"] = [[header]];
G2L["17"] = Instance.new("UICorner", G2L["16"]);
G2L["17"]["CornerRadius"] = UDim.new(0, 4);
G2L["18"] = Instance.new("Frame", G2L["16"]);
G2L["18"]["BorderSizePixel"] = 0;
G2L["18"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["18"]["BackgroundTransparency"] = 0;
G2L["18"]["ZIndex"] = 2;
G2L["18"]["Size"] = UDim2.new(1, 0, 0, 4);
G2L["18"]["Position"] = UDim2.new(0, 0, 1, -4);
G2L["19"] = Instance.new("Frame", G2L["16"]);
G2L["19"]["BorderSizePixel"] = 0;
G2L["19"]["BackgroundColor3"] = Color3.fromRGB(215, 96, 20);
G2L["19"]["ZIndex"] = 3;
G2L["19"]["Size"] = UDim2.new(1, 0, 0, 2);
G2L["19"]["Position"] = UDim2.new(0, 0, 1, -2);
G2L["19"]["Name"] = [[underline]];
G2L["1a"] = Instance.new("ImageLabel", G2L["16"]);
G2L["1a"]["ZIndex"] = 4;
G2L["1a"]["Image"] = [[]];
G2L["1a"]["ImageColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a"]["ImageTransparency"] = 0;
G2L["1a"]["BackgroundTransparency"] = 1;
G2L["1a"]["Size"] = UDim2.new(0, 16, 0, 16);
G2L["1a"]["Name"] = [[icon]];
G2L["1a"]["Position"] = UDim2.new(0, 15, 0.5, -8);
G2L["1b"] = Instance.new("TextLabel", G2L["16"]);
G2L["1b"]["ZIndex"] = 4;
G2L["1b"]["TextSize"] = 17;
G2L["1b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1b"]["TextYAlignment"] = Enum.TextYAlignment.Center;
G2L["1b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["1b"]["TextColor3"] = Color3.fromRGB(100, 100, 100);
G2L["1b"]["TextTransparency"] = 0;
G2L["1b"]["RichText"] = false;
G2L["1b"]["BackgroundTransparency"] = 1;
G2L["1b"]["Size"] = UDim2.new(0, 200, 1, -2);
G2L["1b"]["Text"] = [[]];
G2L["1b"]["Name"] = [[name]];
G2L["1b"]["Position"] = UDim2.new(0, 40, 0, 0);
G2L["1c"] = Instance.new("ImageLabel", G2L["16"]);
G2L["1c"]["ZIndex"] = 4;
G2L["1c"]["Image"] = [[rbxassetid://92473583511724]];
G2L["1c"]["ImageColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c"]["ImageTransparency"] = 0;
G2L["1c"]["BackgroundTransparency"] = 1;
G2L["1c"]["Visible"] = false;
G2L["1c"]["Size"] = UDim2.new(0, 12, 0, 12);
G2L["1c"]["Name"] = [[arrow]];
G2L["1d"] = Instance.new("TextLabel", G2L["16"]);
G2L["1d"]["ZIndex"] = 4;
G2L["1d"]["TextSize"] = 17;
G2L["1d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1d"]["TextYAlignment"] = Enum.TextYAlignment.Center;
G2L["1d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
G2L["1d"]["TextColor3"] = Color3.fromRGB(215, 96, 20);
G2L["1d"]["TextTransparency"] = 0;
G2L["1d"]["RichText"] = false;
G2L["1d"]["BackgroundTransparency"] = 1;
G2L["1d"]["Visible"] = false;
G2L["1d"]["Size"] = UDim2.new(0, 200, 1, -2);
G2L["1d"]["Text"] = [[]];
G2L["1d"]["Name"] = [[subtab]];
G2L["1e"] = Instance.new("Frame", G2L["15"]);
G2L["1e"]["BorderSizePixel"] = 0;
G2L["1e"]["BackgroundColor3"] = Color3.fromRGB(16, 16, 16);
G2L["1e"]["Size"] = UDim2.new(1, 0, 1, -42);
G2L["1e"]["Position"] = UDim2.new(0, 0, 0, 42);
G2L["1e"]["Name"] = [[body]];
--  the MENU UI CORNER FOR THE FRAME
G2L["1f"] = Instance.new("UICorner", G2L["1e"]);
G2L["1f"]["CornerRadius"] = UDim.new(0, 4);
-- CoreGui.weave.window.main.body.Frame
G2L["20"] = Instance.new("Frame", G2L["1e"]);
G2L["20"]["BorderSizePixel"] = 0;
G2L["20"]["BackgroundColor3"] = Color3.fromRGB(16, 16, 16);
G2L["20"]["BackgroundTransparency"] = 0;
G2L["20"]["ZIndex"] = 1;
G2L["20"]["Size"] = UDim2.new(1, 0, 0, 4);
G2L["20"]["Position"] = UDim2.new(0, 0, 0, 0);
G2L["21"] = Instance.new("CanvasGroup", G2L["1e"]);
G2L["21"]["BorderSizePixel"] = 0;
G2L["21"]["BackgroundTransparency"] = 1;
G2L["21"]["GroupTransparency"] = 1;
G2L["21"]["ZIndex"] = 2;
G2L["21"]["ClipsDescendants"] = true;
G2L["21"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["21"]["Name"] = [[content]];
G2L["22"] = Instance.new("UIPadding", G2L["21"]);
G2L["22"]["PaddingLeft"] = UDim.new(0, 15);
G2L["22"]["PaddingRight"] = UDim.new(0, 15);
G2L["22"]["PaddingTop"] = UDim.new(0, 15);
G2L["22"]["PaddingBottom"] = UDim.new(0, 15);
G2L["23"] = Instance.new("Frame", G2L["3"]);
G2L["23"]["BorderSizePixel"] = 0;
G2L["23"]["BackgroundTransparency"] = 1;
G2L["23"]["ClipsDescendants"] = false;
G2L["23"]["ZIndex"] = 40;
G2L["23"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["23"]["Name"] = [[popupLayer]];
G2L["24"] = Instance.new("Frame", G2L["1"]);
G2L["24"]["BorderSizePixel"] = 0;
G2L["24"]["BackgroundTransparency"] = 1;
G2L["24"]["ClipsDescendants"] = false;
G2L["24"]["ZIndex"] = 100;
G2L["24"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["24"]["Name"] = [[floatLayer]];
local function C_2()
local script = G2L["2"];
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local VERSION = "1.0.0"
local ICON = {
	["skull"] = "rbxassetid://137726256442333",
	["crosshair"] = "rbxassetid://134242818164054",
	["eye"] = "rbxassetid://100033680381365",
	["settings"] = "rbxassetid://80758916183665",
	["brush"] = "rbxassetid://127035535799640",
	["code"] = "rbxassetid://107380207681249",
	["file"] = "rbxassetid://74748492079329",
	["chevron-down"] = "rbxassetid://134243273101015",
	["chevron-right"] = "rbxassetid://92473583511724",
	["check"] = "rbxassetid://93898873302694",
	["user"] = "rbxassetid://81589895647169",
	["palette"] = "rbxassetid://86350350950064",
	["zap"] = "rbxassetid://130551565616516",
}
local function resolveIcon(v)
	if v == nil or v == "" then
		return nil
	end
	if type(v) == "number" then
		return "rbxassetid://" .. v
	end
	v = tostring(v)
	if ICON[v] then
		return ICON[v]
	end
	if v:match("^rbxasset") or v:match("^http") then
		return v
	end
	if v:match("^%d+$") then
		return "rbxassetid://" .. v
	end
	return nil
end

local function rgb(r, g, b, a)
	return { c = Color3.fromRGB(r, g, b), a = (a or 255) / 255 }
end

local THEME = {
	Scheme = rgb(215, 96, 20),
	Text = rgb(255, 255, 255),
	TextDisabled = rgb(100, 100, 100),
	WindowBg = rgb(16, 16, 16),
	ChildBg = rgb(20, 20, 20),
	PopupBg = rgb(31, 31, 31),
	Border = rgb(255, 255, 255, 15),
	BorderShadow = rgb(255, 255, 255, 25),
	FrameBg = rgb(16, 16, 16),
	FrameBgHovered = rgb(21, 21, 21),
	FrameBgActive = rgb(26, 26, 26),
	ScrollbarGrab = rgb(28, 28, 28),
	ScrollbarGrabHovered = rgb(33, 33, 33),
	Button = rgb(26, 26, 26),
	ButtonHovered = rgb(31, 31, 31),
	ButtonActive = rgb(36, 36, 36),
	Header = rgb(26, 26, 26),
	TextSelectedBg = rgb(215, 96, 20, 120),
}

local STYLE = {
	WindowRounding = 4,
	ChildRounding = 4,
	FrameRounding = 2,
	PopupRounding = 0,
	FramePadding = Vector2.new(12, 8),
	ItemSpacing = Vector2.new(8, 4),
	ItemInnerSpacing = Vector2.new(6, 9),
}

local WINDOW = Vector2.new(670, 478)
local NAV_W = 176
local MAIN_X = 185
local BAR_H = 42
local TAB_H = 38
local SECTION_HEAD = 33

local FAMILY = "rbxasset://fonts/families/GothamSSm.json"
local FONT = {
	[0] = Font.new(FAMILY, Enum.FontWeight.Medium),
	[1] = Font.new(FAMILY, Enum.FontWeight.Bold),
	[2] = Font.new(FAMILY, Enum.FontWeight.Medium),
	[3] = Font.new(FAMILY, Enum.FontWeight.Bold),
}
local SIZE = { [0] = 14, [1] = 14, [2] = 17, [3] = 17 }

local MEASURE_FONT = {
	[0] = Enum.Font.GothamMedium,
	[1] = Enum.Font.GothamBold,
	[2] = Enum.Font.GothamMedium,
	[3] = Enum.Font.GothamBold,
}
local widthCache = {}
local function textSize(str, fontIdx, wrapX)
	local key = fontIdx .. "\0" .. (wrapX or 9999) .. "\0" .. str
	local hit = widthCache[key]
	if hit then
		return hit
	end
	local ok, sz = pcall(function()
		return TextService:GetTextSize(
			str, SIZE[fontIdx], MEASURE_FONT[fontIdx], Vector2.new(wrapX or 9999, 10000)
		)
	end)
	local out = ok and sz or Vector2.new(#str * SIZE[fontIdx] * 0.55, SIZE[fontIdx])
	widthCache[key] = out
	return out
end
local function textWidth(str, fontIdx)
	return textSize(str, fontIdx).X
end

local function step(v, target, speed, dt)
	return v + (target - v) * math.min(speed * dt, 1)
end

local function colAnim(inactive, active, t)
	return {
		c = inactive.c:Lerp(active.c, t),
		a = inactive.a + (active.a - inactive.a) * t,
	}
end

local function mk(class, props, parent)
	local i = Instance.new(class)
	for k, v in pairs(props) do
		i[k] = v
	end
	if parent then
		i.Parent = parent
	end
	return i
end

local function frame(props, parent)
	props.BorderSizePixel = 0
	if props.BackgroundColor3 == nil then
		props.BackgroundTransparency = props.BackgroundTransparency or 1
	end
	return mk("Frame", props, parent)
end

local function corner(parent, radius)
	return mk("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function stroke(parent, col, thickness, mode)
	return mk("UIStroke", {
		Color = col.c,
		Transparency = 1 - col.a,
		Thickness = thickness or 1,
		ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border,
	}, parent)
end

local function roundSide(f, radius, side)
	corner(f, radius)
	local cover = frame({
		BackgroundColor3 = f.BackgroundColor3,
		BackgroundTransparency = f.BackgroundTransparency,
		Size = UDim2.new(1, 0, 0, radius),
		Position = side == "Top" and UDim2.new(0, 0, 1, -radius) or UDim2.new(0, 0, 0, 0),
		ZIndex = f.ZIndex,
	}, f)
	return cover
end

local function label(text, fontIdx, col, parent, props)
	local l = mk("TextLabel", {
		BackgroundTransparency = 1,
		FontFace = FONT[fontIdx],
		TextSize = SIZE[fontIdx],
		Text = text,
		TextColor3 = col.c,
		TextTransparency = 1 - col.a,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		RichText = false,
		Size = UDim2.new(1, 0, 1, 0),
	}, parent)
	for k, v in pairs(props or {}) do
		l[k] = v
	end
	return l
end

local function icon(assetId, col, parent, props)
	local i = mk("ImageLabel", {
		BackgroundTransparency = 1,
		Image = assetId or "",
		ImageColor3 = col.c,
		ImageTransparency = 1 - col.a,
		Size = UDim2.fromOffset(16, 16),
	}, parent)
	for k, v in pairs(props or {}) do
		i[k] = v
	end
	return i
end

local function hitbox(parent, props)
	local b = mk("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 20,
	}, parent)
	for k, v in pairs(props or {}) do
		b[k] = v
	end
	return b
end

local function tracked(button)
	local s = { hover = false, held = false }
	button.MouseEnter:Connect(function()
		s.hover = true
	end)
	button.MouseLeave:Connect(function()
		s.hover, s.held = false, false
	end)
	button.MouseButton1Down:Connect(function()
		s.held = true
	end)
	button.MouseButton1Up:Connect(function()
		s.held = false
	end)
	return s
end

local function mousePos()
	local m = UserInputService:GetMouseLocation()
	local inset = GuiService:GetGuiInset()
	return Vector2.new(m.X + inset.X, m.Y + inset.Y)
end

local function toLocal(host, absPos)
	local o = host.AbsolutePosition
	return absPos.X - o.X, absPos.Y - o.Y
end

local function parentGui(gui)
	local ok = pcall(function()
		gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	end)
	if not ok then
		gui.Parent = LP:WaitForChild("PlayerGui")
	end
	return gui
end

local Weave = {
	Version = VERSION,
	Flags = {},
	Theme = THEME,
	Style = STYLE,
	Icons = ICON,
	Windows = {},
}

local toastGui, toastList

local function ensureToastLayer()
	if toastGui and toastGui.Parent then
		return
	end
	toastGui = parentGui(mk("ScreenGui", {
		Name = "weave_toasts",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 10000,
	}))
	toastList = frame({
		Name = "list",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -18, 0, 18),
		Size = UDim2.fromOffset(300, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
	}, toastGui)
	mk("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
	}, toastList)
end

local toastSeq = 0

function Weave:Notify(cfg)
	cfg = cfg or {}
	ensureToastLayer()

	local title = tostring(cfg.Title or "Notification")
	local content = tostring(cfg.Content or "")
	local duration = tonumber(cfg.Duration) or 6
	local img = resolveIcon(cfg.Image or cfg.Icon)

	local W, PAD, GAP = 290, 12, 6
	local textX = img and (PAD + 18 + 8) or PAD
	local wrapW = W - textX - PAD
	local titleH = SIZE[1] + 2
	local bodyH = content ~= "" and textSize(content, 0, wrapW).Y or 0

	local actions = {}
	if type(cfg.Actions) == "table" then
		for _, a in pairs(cfg.Actions) do
			if type(a) == "table" then
				table.insert(actions, a)
			end
		end
	end
	local actH = #actions > 0 and (GAP + 24) or 0
	local H = PAD * 2 + titleH + (bodyH > 0 and (GAP + bodyH) or 0) + actH

	toastSeq += 1
	local card = mk("CanvasGroup", {
		Name = "toast",
		BackgroundColor3 = THEME.PopupBg.c,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(W, H),
		GroupTransparency = 1,
		LayoutOrder = toastSeq,
	}, toastList)
	corner(card, STYLE.FrameRounding * 2)
	stroke(card, THEME.Border)

	local inner = frame({ Name = "inner", Size = UDim2.fromScale(1, 1) }, card)

	frame({
		Name = "bar",
		Size = UDim2.new(0, 2, 1, 0),
		BackgroundColor3 = THEME.Scheme.c,
		ZIndex = 3,
	}, inner)

	if img then
		icon(img, THEME.Scheme, inner, {
			Position = UDim2.fromOffset(PAD, PAD),
			Size = UDim2.fromOffset(18, 18),
		})
	end

	label(title, 1, THEME.Text, inner, {
		Position = UDim2.fromOffset(textX, PAD),
		Size = UDim2.new(1, -textX - PAD, 0, titleH),
	})
	if bodyH > 0 then
		label(content, 0, THEME.TextDisabled, inner, {
			Position = UDim2.fromOffset(textX, PAD + titleH + GAP),
			Size = UDim2.new(1, -textX - PAD, 0, bodyH),
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
		})
	end

	local finished = false
	local function dismiss()
		if finished then
			return
		end
		finished = true
		local out = TweenService:Create(card, TweenInfo.new(0.25), {
			GroupTransparency = 1,
			Position = UDim2.fromOffset(40, 0),
		})
		out:Play()
		out.Completed:Connect(function()
			card:Destroy()
		end)
	end

	if #actions > 0 then
		local row = frame({
			Name = "actions",
			Position = UDim2.fromOffset(textX, PAD + titleH + (bodyH > 0 and (GAP + bodyH) or 0) + GAP),
			Size = UDim2.new(1, -textX - PAD, 0, 24),
		}, inner)
		mk("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
		}, row)

		for i, a in ipairs(actions) do
			local name = tostring(a.Name or "Okay")
			local b = mk("TextButton", {
				Name = name,
				BackgroundColor3 = THEME.Button.c,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = name,
				FontFace = FONT[1],
				TextSize = SIZE[0],
				TextColor3 = THEME.Text.c,
				Size = UDim2.fromOffset(textWidth(name, 1) + 20, 24),
				LayoutOrder = i,
			}, row)
			corner(b, STYLE.FrameRounding)
			b.MouseEnter:Connect(function()
				TweenService:Create(b, TweenInfo.new(0.12), {
					BackgroundColor3 = THEME.ButtonHovered.c,
				}):Play()
			end)
			b.MouseLeave:Connect(function()
				TweenService:Create(b, TweenInfo.new(0.12), {
					BackgroundColor3 = THEME.Button.c,
				}):Play()
			end)
			b.MouseButton1Click:Connect(function()
				if a.Callback then
					task.spawn(a.Callback)
				end
				dismiss()
			end)
		end
	end

	card.Position = UDim2.fromOffset(40, 0)
	TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		GroupTransparency = 0,
		Position = UDim2.fromOffset(0, 0),
	}):Play()

	task.delay(duration, dismiss)

	return { Dismiss = dismiss }
end

local function envFn(name)
	local ok, fn = pcall(function()
		return (getgenv and getgenv() or _G)[name]
	end)
	if ok and type(fn) == "function" then
		return fn
	end
	return nil
end

local FS = {
	write = envFn("writefile"),
	read = envFn("readfile"),
	isfile = envFn("isfile"),
	mkdir = envFn("makefolder"),
	isdir = envFn("isfolder"),
}
local FS_OK = type(FS.write) == "function" and type(FS.read) == "function" and type(FS.isfile) == "function"

local MOUSE_NAMES = {
	[Enum.UserInputType.MouseButton1] = "LMB",
	[Enum.UserInputType.MouseButton2] = "RMB",
	[Enum.UserInputType.MouseButton3] = "MMB",
}

local function keyName(bind)
	local mouse = MOUSE_NAMES[bind]
	if mouse then
		return mouse
	end
	local n = tostring(bind):gsub("^Enum%.%w+%.", "")
	if #n == 1 then
		return n
	end
	return string.upper(n)
end

local function toBind(v)
	if typeof(v) == "EnumItem" then
		return v
	end
	if type(v) ~= "string" then
		return nil
	end
	local name = v:gsub("^Enum%.%w+%.", "")
	for _, ty in ipairs({ Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3 }) do
		if MOUSE_NAMES[ty] == name:upper() then
			return ty
		end
	end
	for _, k in ipairs(Enum.KeyCode:GetEnumItems()) do
		if k.Name:lower() == name:lower() then
			return k
		end
	end
	for _, t in ipairs(Enum.UserInputType:GetEnumItems()) do
		if t.Name:lower() == name:lower() then
			return t
		end
	end
	return nil
end

local function encodeValue(v)
	if typeof(v) == "Color3" then
		return { __rgb = { math.round(v.R * 255), math.round(v.G * 255), math.round(v.B * 255) } }
	elseif typeof(v) == "EnumItem" then
		return { __key = v.Name }
	end
	return v
end

local function decodeValue(v)
	if type(v) == "table" then
		if type(v.__rgb) == "table" then
			return Color3.fromRGB(v.__rgb[1] or 0, v.__rgb[2] or 0, v.__rgb[3] or 0)
		elseif v.__key then
			return toBind(v.__key)
		end
	end
	return v
end

function Weave:CreateWindow(cfg)
	cfg = cfg or {}

	local name = tostring(cfg.Name or "Weave")
	local brandText = tostring(cfg.LoadingTitle or cfg.Title or name)
	local subtitle = cfg.Subtitle or cfg.LoadingSubtitle

	local function axis(a, fallback)
		if type(a) == "number" then
			return a
		elseif typeof(a) == "UDim" then
			return a.Offset
		end
		return fallback
	end
	local sizeCfg = cfg.Size
	local W, H = WINDOW.X, WINDOW.Y
	if sizeCfg then
		W = axis(sizeCfg.X or sizeCfg[1], W)
		H = axis(sizeCfg.Y or sizeCfg[2], H)
	end
	W = math.max(W, 480)
	H = math.max(H, 320)

	local ANIM = {}
	local CONNS = {}
	local function onFrame(fn)
		table.insert(ANIM, fn)
		return fn
	end
	local function bind(conn)
		table.insert(CONNS, conn)
		return conn
	end

	local gui = parentGui(G2L["1"]:Clone());
	gui["Name"] = cfg.GuiName or "weave";

	local window = gui["window"];
	window["Size"] = UDim2.new(0, W, 0, H);
	window["Position"] = UDim2.new(0.5, -W / 2, 0.5, -H / 2);

	local UI = {
		curTab = 0,
		nextTab = 0,
		anim = 0,
		animDst = 1,
		contentAnim = 0,
		contentAnimDst = 1,
		tabs = {},
	}

	local nav = window["nav"];
	local brand = nav["brand"];
	local brandLabel = brand["logo"];
	brandLabel["Text"] = brandText;

	local tabsHolder = nav["tabs"];
	local tabList = tabsHolder["list"];

	local profile = nav["profile"];
	local avatar = profile["avatar"];
	task.spawn(function()
		local ok, url = pcall(function()
			return Players:GetUserThumbnailAsync(
				LP.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size48x48
			)
		end)
		if ok and url then
			avatar.Image = url
		end
	end)

	profile["username"]["Text"] = cfg.Username or LP.Name;
	local planLabel = profile["expiry"];
	planLabel["Text"] = tostring(subtitle or "Free");

	local main = window["main"];
	local mainHeader = main["header"];

	local hdIcon = mainHeader["icon"];
	local hdName = mainHeader["name"];
	local hdArrow = mainHeader["arrow"];
	local hdSub = mainHeader["subtab"];

	local function headerBtn(btnName, glyph, xOff, fn)
		local b = mk("TextButton", {
			Name = btnName,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, xOff, 0.5, -1),
			Size = UDim2.fromOffset(20, 20),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = glyph,
			FontFace = FONT[1],
			TextSize = SIZE[0],
			TextColor3 = THEME.TextDisabled.c,
			ZIndex = 5,
		}, mainHeader)
		local st = tracked(b)
		local hov = 0
		b.MouseButton1Click:Connect(fn)
		onFrame(function(dt)
			hov = step(hov, st.hover and 1 or 0, 14, dt)
			local c = colAnim(THEME.TextDisabled, THEME.Text, hov)
			b.TextColor3 = c.c
			b.TextTransparency = 1 - c.a
		end)
		return b
	end

	local body = main["body"];

	local content = body["content"];

	local popupLayer = window["popupLayer"];

	local floatLayer = gui["floatLayer"];

	local function pageFor(tab, subIdx)
		local existing = tab.pages[subIdx]
		if existing then
			return existing
		end

		local holder = frame({
			Name = ("page_%d_%d"):format(tab.index, subIdx),
			Size = UDim2.fromScale(1, 1),
			Visible = false,
		}, content)
		tab.pages[subIdx] = holder

		local function column(side)
			local col = mk("ScrollingFrame", {
				Name = side,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0.5, -STYLE.ItemSpacing.X / 2, 1, 0),
				Position = side == "left" and UDim2.new(0, 0, 0, 0)
					or UDim2.new(0.5, STYLE.ItemSpacing.X / 2, 0, 0),
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = THEME.ScrollbarGrab.c,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ClipsDescendants = true,
			}, holder)
			mk("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
			}, col)
			return col
		end

		tab.columns[subIdx] = { left = column("left"), right = column("right"), n = 0 }
		return holder
	end

	local function activePage()
		local tab = UI.tabs[UI.curTab]
		return tab and tab.pages[tab.curSubtab]
	end

	local function showActivePage()
		for _, tab in ipairs(UI.tabs) do
			for _, h in pairs(tab.pages) do
				h.Visible = false
			end
		end
		local p = activePage()
		if p then
			p.Visible = true
		end
	end

	local WIDGET_ORDER = setmetatable({}, { __mode = "k" })
	local function nextOrder(parent)
		local n = (WIDGET_ORDER[parent] or 0) + 1
		WIDGET_ORDER[parent] = n
		return n
	end

	local function offFrame(fn)
		local i = table.find(ANIM, fn)
		if i then
			table.remove(ANIM, i)
		end
	end

	local drag = nil

	local function endDrag()
		if drag then
			local d = drag
			drag = nil
			if d.ended then
				d.ended()
			end
		end
	end

	local function beginDrag(move, ended)
		endDrag()
		drag = { move = move, ended = ended }
		move(mousePos())
	end

	bind(UserInputService.InputChanged:Connect(function(input)
		if not drag then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			drag.move(mousePos())
		end
	end))

	local shown = true
	local toggleKey = toBind(cfg.ToggleKey or cfg.KeybindToggle) or Enum.KeyCode.RightShift
	local keybinds = {}
	local listening = nil
	local dirty

	local function markDirty()
		if dirty then
			dirty()
		end
	end

	local function setShown(state)
		shown = state and true or false
		gui.Enabled = shown
	end

	bind(UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if listening then
			listening.feed(input)
			return
		end
		if gameProcessed then
			return
		end
		if input.KeyCode == toggleKey or input.UserInputType == toggleKey then
			setShown(not shown)
		end
		for _, kb in ipairs(keybinds) do
			kb.press(input)
		end
	end))

	bind(UserInputService.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			endDrag()
		end
		for _, kb in ipairs(keybinds) do
			kb.release(input)
		end
	end))

	local elements = {}

	local function register(el, instance, flag)
		el.Instance = instance
		el.Flag = flag
		el.Visible = true

		function el:SetVisible(state)
			self.Visible = state and true or false
			instance.Visible = self.Visible
		end

		function el:Destroy()
			if el.onDestroy then
				el.onDestroy()
			end
			if flag and Weave.Flags[flag] == el then
				Weave.Flags[flag] = nil
			end
			local i = table.find(elements, el)
			if i then
				table.remove(elements, i)
			end
			instance:Destroy()
		end

		table.insert(elements, el)
		if flag then
			Weave.Flags[flag] = el
		end
		return el
	end

	local function makeToggle(parent, o)
		local el = {}
		local text = tostring(o.Name or "Toggle")
		local v = o.CurrentValue and true or false

		local row = frame({
			Name = text,
			Size = UDim2.new(1, 0, 0, 18),
			LayoutOrder = nextOrder(parent),
		}, parent)

		local box = frame({
			Name = "box",
			Size = UDim2.fromOffset(18, 18),
			BackgroundColor3 = THEME.FrameBg.c,
		}, row)
		corner(box, STYLE.FrameRounding)
		stroke(box, THEME.Border)

		local fill = frame({
			Name = "fill",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = THEME.Scheme.c,
			BackgroundTransparency = 1,
			ZIndex = 2,
		}, box)
		corner(fill, STYLE.FrameRounding)

		local mark = icon(ICON.check, THEME.Text, box, {
			Name = "mark",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(0, 0),
			ZIndex = 3,
		})

		label(text, 0, THEME.Text, row, {
			Position = UDim2.new(0, 18 + STYLE.ItemInnerSpacing.X, 0, 0),
			Size = UDim2.new(1, -18 - STYLE.ItemInnerSpacing.X, 1, 0),
		})

		local btn = hitbox(row)
		local st = tracked(btn)

		local function apply(nv, fire)
			v = nv and true or false
			el.CurrentValue = v
			if fire and o.Callback then
				task.spawn(o.Callback, v)
			end
		end

		btn.MouseButton1Click:Connect(function()
			apply(not v, true)
			markDirty()
		end)

		local obj = { anim = 0, hover = 0 }
		onFrame(function(dt)
			obj.anim = step(obj.anim, v and 1 or 0, 14, dt)
			obj.hover = step(obj.hover, (st.hover and not v) and 1 or 0, 14, dt)

			box.BackgroundColor3 = colAnim(THEME.FrameBg, THEME.FrameBgHovered, obj.hover).c
			fill.BackgroundTransparency = 1 - obj.anim
			mark.Size = UDim2.fromOffset(9 * obj.anim, 9 * obj.anim)
			mark.ImageTransparency = 1 - obj.anim
		end)

		el.Type = "Toggle"
		el.CurrentValue = v
		function el:Get()
			return v
		end
		function el:Set(nv, fire)
			apply(nv, fire ~= false)
		end
		return register(el, row, o.Flag)
	end

	local function makeButton(parent, o)
		local el = {}
		local text = tostring(o.Name or "Button")

		local b = mk("TextButton", {
			Name = text,
			BackgroundColor3 = THEME.Button.c,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = text,
			FontFace = FONT[1],
			TextSize = SIZE[1],
			TextColor3 = THEME.Text.c,
			Size = UDim2.new(1, 0, 0, o.Height or 32),
			LayoutOrder = nextOrder(parent),
		}, parent)
		corner(b, STYLE.FrameRounding)

		local st = tracked(b)
		local obj = { held = 0, hover = 0 }
		b.MouseButton1Click:Connect(function()
			if o.Callback then
				task.spawn(o.Callback)
			end
		end)
		onFrame(function(dt)
			obj.held = step(obj.held, st.held and 1 or 0, 14, dt)
			obj.hover = step(obj.hover, st.hover and 1 or 0, 14, dt)
			b.BackgroundColor3 = colAnim(
				colAnim(THEME.Button, THEME.ButtonHovered, obj.hover),
				THEME.ButtonActive,
				obj.held
			).c
		end)

		el.Type = "Button"
		function el:Get()
			return text
		end
		function el:Set(nv)
			text = tostring(nv)
			b.Text = text
		end
		function el:Fire()
			if o.Callback then
				task.spawn(o.Callback)
			end
		end
		return register(el, b, nil)
	end

	local function makeSlider(parent, o)
		local el = {}
		local text = tostring(o.Name or "Slider")
		local range = o.Range or { 0, 100 }
		local min, max = tonumber(range[1]) or 0, tonumber(range[2]) or 100
		if max < min then
			min, max = max, min
		end

		local inc = tonumber(o.Increment) or 0
		local decimals = 0
		if inc > 0 and inc < 1 then
			decimals = math.max(0, math.ceil(-math.log10(inc) - 1e-9))
		end
		local fmt = o.Format or ("%." .. decimals .. "f")
		local suffix = o.Suffix and (" " .. tostring(o.Suffix)) or ""

		local function quantise(n)
			n = math.clamp(n, min, max)
			if inc > 0 then
				n = min + math.floor((n - min) / inc + 0.5) * inc
			end
			local m = 10 ^ decimals
			return math.clamp(math.floor(n * m + 0.5) / m, min, max)
		end

		local v = quantise(tonumber(o.CurrentValue) or min)

		local row = frame({
			Name = text,
			Size = UDim2.new(1, 0, 0, SIZE[0] + STYLE.ItemInnerSpacing.Y * 1.25 + 6),
			LayoutOrder = nextOrder(parent),
		}, parent)

		label(text, 0, THEME.TextDisabled, row, {
			Size = UDim2.new(1, -70, 0, SIZE[0]),
			TextYAlignment = Enum.TextYAlignment.Top,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local valueLbl = label("", 0, THEME.Text, row, {
			Name = "value",
			Size = UDim2.new(0, 70, 0, SIZE[0]),
			Position = UDim2.new(1, -70, 0, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Top,
		})

		local trackY = SIZE[0] + STYLE.ItemInnerSpacing.Y * 1.25

		local function stepBox(nm, glyph, xPos)
			local b = mk("TextButton", {
				Name = nm,
				BackgroundColor3 = THEME.Button.c,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = glyph,
				FontFace = FONT[1],
				TextSize = SIZE[1],
				TextColor3 = THEME.Text.c,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(xPos, xPos == 1 and -16 or 0, 0, trackY + 3 - 8),
				ZIndex = 3,
			}, row)
			corner(b, STYLE.FrameRounding)

			local bst = tracked(b)
			local a = { v = 0 }
			onFrame(function(dt)
				a.v = step(a.v, bst.hover and 1 or 0, 14, dt)
				b.BackgroundColor3 = colAnim(THEME.Button, THEME.ButtonHovered, a.v).c
			end)
			return b
		end

		local minus = stepBox("erase", "-", 0)
		local plus = stepBox("add", "+", 1)

		local track = frame({
			Name = "track",
			Position = UDim2.new(0, 23, 0, trackY),
			Size = UDim2.new(1, -46, 0, 6),
			BackgroundColor3 = THEME.FrameBg.c,
		}, row)
		corner(track, 3)

		local fill = frame({
			Name = "fill",
			Size = UDim2.fromScale(0, 1),
			BackgroundColor3 = THEME.Scheme.c,
			ZIndex = 2,
		}, track)
		corner(fill, 3)

		local grab = frame({
			Name = "grab",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromOffset(12, 12),
			BackgroundColor3 = THEME.Text.c,
			ZIndex = 3,
		}, track)
		corner(grab, 6)

		local hit = hitbox(row, {
			Position = UDim2.new(0, 23, 0, trackY - 8),
			Size = UDim2.new(1, -46, 0, 22),
		})
		local st = tracked(hit)
		local dragging = false

		local function apply(nv, fire)
			v = quantise(nv)
			el.CurrentValue = v
			if fire and o.Callback then
				task.spawn(o.Callback, v)
			end
		end

		hit.MouseButton1Down:Connect(function()
			dragging = true
			beginDrag(function(m)
				local a = track.AbsolutePosition.X
				local w = math.max(track.AbsoluteSize.X, 1)
				apply(min + (max - min) * math.clamp((m.X - a) / w, 0, 1), true)
			end, function()
				dragging = false
				markDirty()
			end)
		end)

		local stepAmt = inc > 0 and inc or ((max - min) > 1 and 1 or 0.1)
		minus.MouseButton1Click:Connect(function()
			apply(v - stepAmt, true)
			markDirty()
		end)
		plus.MouseButton1Click:Connect(function()
			apply(v + stepAmt, true)
			markDirty()
		end)

		local obj = { grab = 0, rad = 6, anim = 0 }
		onFrame(function(dt)
			local t = (max > min) and (v - min) / (max - min) or 0
			local w = track.AbsoluteSize.X

			obj.grab = step(obj.grab, t * w, 24, dt)
			obj.rad = step(obj.rad, dragging and 7 or (st.hover and 5 or 6), 16, dt)
			obj.anim = step(obj.anim, (st.hover or dragging) and 1 or 0, 14, dt)

			track.BackgroundColor3 = colAnim(THEME.FrameBg, THEME.FrameBgHovered, obj.anim).c
			fill.Size = UDim2.new(0, obj.grab, 1, 0)
			grab.Position = UDim2.new(0, obj.grab, 0.5, 0)
			grab.Size = UDim2.fromOffset(obj.rad * 2, obj.rad * 2)

			valueLbl.Text = fmt:format(v) .. suffix
		end)

		el.Type = "Slider"
		el.CurrentValue = v
		function el:Get()
			return v
		end
		function el:Set(nv, fire)
			apply(tonumber(nv) or min, fire ~= false)
		end
		return register(el, row, o.Flag)
	end

	local function makeDropdown(parent, tab, o)
		local el = {}
		local text = tostring(o.Name or "Dropdown")
		local options = {}
		for _, v in ipairs(o.Options or {}) do
			table.insert(options, tostring(v))
		end
		if #options == 0 then
			options = { "" }
		end

		local function indexOf(want)
			if type(want) == "number" then
				return math.clamp(math.floor(want), 1, #options)
			end
			for i, opt in ipairs(options) do
				if opt == tostring(want) then
					return i
				end
			end
			return 1
		end

		local cur = indexOf(o.CurrentOption or 1)
		local open = false

		local row = frame({
			Name = text,
			Size = UDim2.new(1, 0, 0, SIZE[0] + STYLE.ItemInnerSpacing.Y + 32),
			LayoutOrder = nextOrder(parent),
		}, parent)

		label(text, 0, THEME.TextDisabled, row, {
			Size = UDim2.new(1, 0, 0, SIZE[0]),
			TextYAlignment = Enum.TextYAlignment.Top,
		})
		local preview = label("", 0, THEME.Text, row, {
			Name = "preview",
			Position = UDim2.new(0, 12, 0, SIZE[0] + STYLE.ItemInnerSpacing.Y),
			Size = UDim2.new(1, -12 - 60, 0, 32),
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 2,
		})

		local frameBox = frame({
			Name = "frame",
			Position = UDim2.new(0, 0, 0, SIZE[0] + STYLE.ItemInnerSpacing.Y),
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = THEME.Button.c,
		}, row)
		corner(frameBox, STYLE.FrameRounding)

		local arrow = icon(ICON["chevron-down"], THEME.TextDisabled, frameBox, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(1, -math.floor(13 / 2) - 3, 0.5, 0),
			Size = UDim2.fromOffset(13, 13),
			Rotation = -90,
			ZIndex = 3,
		})

		local btn = hitbox(row)
		local st = tracked(btn)

		local drawer = frame({
			Name = "popup",
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = THEME.PopupBg.c,
			ClipsDescendants = true,
			Visible = false,
			ZIndex = 50,
		}, popupLayer)
		corner(drawer, STYLE.FrameRounding * 2)

		local list = frame({
			Name = "list",
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 5),
			AutomaticSize = Enum.AutomaticSize.Y,
		}, drawer)
		mk("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),
		}, list)

		local function close()
			open = false
			if tab.openCombo == el then
				tab.openCombo = nil
			end
		end

		local rowAnims, rowBtns = {}, {}

		local function buildRows()
			for _, fn in ipairs(rowAnims) do
				offFrame(fn)
			end
			for _, b in ipairs(rowBtns) do
				b:Destroy()
			end
			rowAnims, rowBtns = {}, {}

			for i, opt in ipairs(options) do
				local e = mk("TextButton", {
					Name = opt,
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Text = opt,
					FontFace = FONT[0],
					TextSize = SIZE[0],
					TextColor3 = THEME.TextDisabled.c,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 24),
					LayoutOrder = i,
				}, list)
				table.insert(rowBtns, e)

				local est = tracked(e)
				local eobj = { anim = 0, hover = 0 }
				e.MouseButton1Click:Connect(function()
					cur = i
					el.CurrentOption = options[cur]
					el.Index = cur
					preview.Text = options[cur]
					if o.Callback then
						task.spawn(o.Callback, options[cur], cur)
					end
					close()
					markDirty()
				end)
				table.insert(rowAnims, onFrame(function(dt)
					eobj.anim = step(eobj.anim, cur == i and 1 or 0, 14, dt)
					eobj.hover = step(eobj.hover, est.hover and 1 or 0, 14, dt)
					local c = colAnim(
						colAnim(THEME.TextDisabled, THEME.Text, eobj.hover),
						THEME.Scheme,
						eobj.anim
					)
					e.TextColor3 = c.c
					e.TextTransparency = 1 - c.a
				end))
			end
		end
		buildRows()

		local obj = { anim = 0, popup = 0, hover = 0, rad = math.pi / 2 }
		onFrame(function(dt)
			obj.anim = step(obj.anim, (st.hover or open) and 1 or 0, 14, dt)
			obj.popup = step(obj.popup, open and 1 or 0, 14, dt)
			obj.hover = step(obj.hover, st.hover and 1 or 0, 14, dt)
			obj.rad = step(obj.rad, open and math.pi * 1.5 or math.pi / 2, 14, dt)

			frameBox.BackgroundColor3 = colAnim(THEME.Button, THEME.ButtonHovered, obj.anim).c
			local aCol = colAnim(THEME.TextDisabled, THEME.Text, obj.anim)
			arrow.ImageColor3 = aCol.c
			arrow.ImageTransparency = 1 - aCol.a
			arrow.Rotation = math.deg(obj.rad) - 180

			if open then
				local x, y = toLocal(popupLayer, frameBox.AbsolutePosition)
				drawer.Position = UDim2.fromOffset(x, y + 32)
				drawer.Size = UDim2.new(0, frameBox.AbsoluteSize.X, 0, list.AbsoluteSize.Y * obj.popup + 10)
				drawer.Visible = true
			elseif obj.popup < 0.01 then
				drawer.Visible = false
			end
		end)

		btn.MouseButton1Click:Connect(function()
			local other = tab.openCombo
			if other and other ~= el then
				other.Close()
			end
			if open then
				close()
			else
				open = true
				tab.openCombo = el
			end
		end)

		preview.Text = options[cur]

		el.Type = "Dropdown"
		el.CurrentOption = options[cur]
		el.Index = cur
		el.Options = options
		function el:Get()
			return options[cur], cur
		end
		function el:Set(want, fire)
			cur = indexOf(want)
			el.CurrentOption = options[cur]
			el.Index = cur
			preview.Text = options[cur]
			if fire ~= false and o.Callback then
				task.spawn(o.Callback, options[cur], cur)
			end
		end
		function el:Refresh(newOptions, keep)
			options = {}
			for _, v in ipairs(newOptions or {}) do
				table.insert(options, tostring(v))
			end
			if #options == 0 then
				options = { "" }
			end
			el.Options = options
			cur = keep and indexOf(el.CurrentOption) or 1
			el.CurrentOption = options[cur]
			el.Index = cur
			preview.Text = options[cur]
			buildRows()
		end
		el.Close = close
		el.onDestroy = function()
			close()
			for _, fn in ipairs(rowAnims) do
				offFrame(fn)
			end
			drawer:Destroy()
		end
		return register(el, row, o.Flag)
	end

	local function makeInput(parent, o)
		local el = {}
		local text = tostring(o.Name or "Input")
		local val = tostring(o.CurrentValue or o.Default or "")

		local row = frame({
			Name = text,
			Size = UDim2.new(1, 0, 0, SIZE[0] + STYLE.ItemInnerSpacing.Y + 32),
			LayoutOrder = nextOrder(parent),
		}, parent)

		label(text, 0, THEME.TextDisabled, row, {
			Size = UDim2.new(1, 0, 0, SIZE[0]),
			TextYAlignment = Enum.TextYAlignment.Top,
		})

		local field = mk("TextBox", {
			BackgroundColor3 = THEME.FrameBg.c,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, SIZE[0] + STYLE.ItemInnerSpacing.Y),
			Size = UDim2.new(1, 0, 0, 32),
			PlaceholderText = tostring(o.PlaceholderText or text),
			PlaceholderColor3 = THEME.TextDisabled.c,
			Text = val,
			FontFace = FONT[0],
			TextSize = SIZE[0],
			TextColor3 = THEME.Text.c,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			ClearTextOnFocus = false,
			ClipsDescendants = false,
			ZIndex = 2,
		}, row)
		corner(field, STYLE.FrameRounding)
		stroke(field, THEME.Border)
		mk("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}, field)

		local obj = { anim = 0, hover = 0 }
		local focused, hovering = false, false
		field.Focused:Connect(function()
			focused = true
		end)
		field.FocusLost:Connect(function(enter)
			focused = false
			val = field.Text
			el.CurrentValue = val
			if o.Callback then
				task.spawn(o.Callback, val, enter)
			end
			if o.RemoveTextAfterFocusLost then
				field.Text = ""
				val = ""
				el.CurrentValue = ""
			end
			markDirty()
		end)
		field:GetPropertyChangedSignal("Text"):Connect(function()
			if focused and o.OnChanged then
				task.spawn(o.OnChanged, field.Text)
			end
		end)
		field.MouseEnter:Connect(function()
			hovering = true
		end)
		field.MouseLeave:Connect(function()
			hovering = false
		end)

		onFrame(function(dt)
			obj.anim = step(obj.anim, focused and 1 or 0, 14, dt)
			obj.hover = step(obj.hover, hovering and 1 or 0, 14, dt)
			field.BackgroundColor3 = colAnim(
				colAnim(THEME.FrameBg, THEME.FrameBgHovered, obj.hover),
				THEME.FrameBgActive,
				obj.anim
			).c
		end)

		el.Type = "Input"
		el.CurrentValue = val
		function el:Get()
			return field.Text
		end
		function el:Set(s, fire)
			field.Text = tostring(s)
			val = field.Text
			el.CurrentValue = val
			if fire ~= false and o.Callback then
				task.spawn(o.Callback, val, false)
			end
		end
		return register(el, row, o.Flag)
	end

	local function makeKeybind(parent, o)
		local el = {}
		local text = tostring(o.Name or "Keybind")
		local key = toBind(o.CurrentKeybind or o.CurrentValue) or Enum.UserInputType.MouseButton1

		local row = frame({
			Name = text,
			Size = UDim2.new(1, 0, 0, 27),
			LayoutOrder = nextOrder(parent),
		}, parent)

		label(text, 0, THEME.TextDisabled, row, {
			Size = UDim2.new(1, -70, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local kb = mk("TextButton", {
			Name = "key",
			BackgroundColor3 = THEME.FrameBg.c,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = keyName(key),
			FontFace = FONT[0],
			TextSize = SIZE[0],
			TextColor3 = THEME.Text.c,
			Size = UDim2.fromOffset(60, 27),
			Position = UDim2.new(1, -60, 0, 0),
			ZIndex = 2,
		}, row)
		corner(kb, STYLE.FrameRounding)

		local kst = tracked(kb)
		local obj = { anim = 0, hover = 0 }

		kb.MouseButton1Click:Connect(function()
			if listening == el then
				listening = nil
				obj.anim = 0
			else
				listening = el
				obj.anim = 1
			end
		end)

		function el.feed(input)
			local ty = input.UserInputType
			if MOUSE_NAMES[ty] then
				key = ty
			elseif ty == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Escape then
					listening = nil
					obj.anim = 0
					return
				end
				key = input.KeyCode
			else
				return
			end
			listening = nil
			obj.anim = 0
			kb.Text = keyName(key)
			el.CurrentKeybind = keyName(key)
			el.CurrentValue = key
			if o.ChangedCallback then
				task.spawn(o.ChangedCallback, key)
			end
			markDirty()
		end

		function el.press(input)
			if listening or not el.Enabled then
				return
			end
			if input.KeyCode == key or input.UserInputType == key then
				if o.Callback then
					task.spawn(o.Callback, o.HoldToInteract and true or nil)
				end
			end
		end

		function el.release(input)
			if not (o.HoldToInteract and el.Enabled) then
				return
			end
			if input.KeyCode == key or input.UserInputType == key then
				if o.Callback then
					task.spawn(o.Callback, false)
				end
			end
		end

		onFrame(function(dt)
			obj.hover = step(obj.hover, (kst.hover or listening == el) and 1 or 0, 14, dt)
			kb.BackgroundColor3 = colAnim(
				colAnim(THEME.FrameBg, THEME.FrameBgHovered, obj.hover),
				THEME.FrameBgActive,
				obj.anim
			).c
			local t = colAnim(THEME.Text, THEME.Scheme, obj.anim)
			kb.TextColor3 = t.c
			kb.TextTransparency = 1 - t.a
		end)

		el.Type = "Keybind"
		el.Enabled = true
		el.CurrentKeybind = keyName(key)
		el.CurrentValue = key
		function el:Get()
			return key
		end
		function el:Set(nk, fire)
			key = toBind(nk) or key
			kb.Text = keyName(key)
			el.CurrentKeybind = keyName(key)
			el.CurrentValue = key
			if fire ~= false and o.ChangedCallback then
				task.spawn(o.ChangedCallback, key)
			end
		end
		el.onDestroy = function()
			if listening == el then
				listening = nil
			end
			local i = table.find(keybinds, el)
			if i then
				table.remove(keybinds, i)
			end
		end

		table.insert(keybinds, el)
		return register(el, row, o.Flag)
	end

	local HUE_SEQ = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
		ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
		ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
		ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
		ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
		ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
	})

	local function makeColorPicker(parent, o)
		local el = {}
		local text = tostring(o.Name or "Colour")
		local col3 = o.Color or o.CurrentValue or THEME.Scheme.c
		local alphaEnabled = o.Alpha ~= nil and o.Alpha ~= false or o.Transparency ~= nil

		local h, s, v = Color3.toHSV(col3)
		local alpha = tonumber(o.Alpha) or 1
		local open, placed = false, false

		local row = frame({
			Name = text,
			Size = UDim2.new(1, 0, 0, 16),
			LayoutOrder = nextOrder(parent),
		}, parent)

		label(text, 0, THEME.Text, row, {
			Size = UDim2.new(1, -26, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})

		local swatch = frame({
			Name = "swatch",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.fromOffset(16, 16),
			BackgroundColor3 = col3,
		}, row)
		corner(swatch, STYLE.FrameRounding)
		stroke(swatch, THEME.Border)

		local btn = hitbox(row)

		local PAD = 10
		local HEAD_H, SQ_H, BAR_W, ALPHA_H, GAP = 22, 140, 16, 12, 8
		local PANEL_W = 240
		local BODY_H = SQ_H + (alphaEnabled and (GAP + ALPHA_H) or 0) + GAP + SIZE[0]
		local PANEL_H = PAD * 2 + HEAD_H + GAP + BODY_H

		local panel = mk("CanvasGroup", {
			Name = "colorpanel",
			BackgroundColor3 = THEME.PopupBg.c,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(PANEL_W, PANEL_H),
			GroupTransparency = 1,
			Visible = false,
			ZIndex = 50,
		}, floatLayer)
		corner(panel, STYLE.FrameRounding * 2)
		stroke(panel, THEME.Border, 1, Enum.ApplyStrokeMode.Contextual)

		local header = frame({
			Name = "header",
			Position = UDim2.fromOffset(PAD, PAD),
			Size = UDim2.new(1, -PAD * 2, 0, HEAD_H),
		}, panel)
		label(text, 1, THEME.Text, header, {
			Size = UDim2.new(1, -22, 1, 0),
		})

		local grip = hitbox(header, { Name = "grip", ZIndex = 20 })
		local closeBtn = mk("TextButton", {
			Name = "close",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(18, 18),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "X",
			FontFace = FONT[1],
			TextSize = SIZE[0],
			TextColor3 = THEME.TextDisabled.c,
			ZIndex = 25,
		}, header)

		local pbody = frame({
			Name = "body",
			Position = UDim2.fromOffset(PAD, PAD + HEAD_H + GAP),
			Size = UDim2.new(1, -PAD * 2, 0, BODY_H),
		}, panel)

		local sq = frame({
			Name = "sv",
			Size = UDim2.new(1, -(BAR_W + GAP), 0, SQ_H),
			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
		}, pbody)
		corner(sq, 4)

		local satLayer = frame({
			Name = "sat",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
		}, sq)
		corner(satLayer, 4)
		mk("UIGradient", {
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}, satLayer)

		local valLayer = frame({
			Name = "val",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			ZIndex = 2,
		}, sq)
		corner(valLayer, 4)
		mk("UIGradient", {
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(1, 0),
			}),
			Rotation = 90,
		}, valLayer)

		local svGrab = frame({
			Name = "grab",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(11, 11),
			BackgroundTransparency = 1,
			ZIndex = 4,
		}, sq)
		corner(svGrab, 6)
		mk("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2 }, svGrab)
		local svHit = hitbox(sq, { Name = "hit", ZIndex = 20 })

		local hueBar = frame({
			Name = "hue",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.fromOffset(BAR_W, SQ_H),
			BackgroundColor3 = Color3.new(1, 1, 1),
		}, pbody)
		corner(hueBar, 4)
		mk("UIGradient", { Color = HUE_SEQ, Rotation = 90 }, hueBar)

		local hueGrab = frame({
			Name = "grab",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(1, 4, 0, 4),
			BackgroundColor3 = Color3.new(1, 1, 1),
			ZIndex = 4,
		}, hueBar)
		corner(hueGrab, 2)
		mk("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.5, Thickness = 1 }, hueGrab)
		local hueHit = hitbox(hueBar, { Name = "hit", ZIndex = 20 })

		local alphaBar, alphaFill, alphaGrab, alphaHit
		if alphaEnabled then
			alphaBar = frame({
				Name = "alpha",
				Position = UDim2.fromOffset(0, SQ_H + GAP),
				Size = UDim2.new(1, 0, 0, ALPHA_H),
				BackgroundColor3 = THEME.FrameBg.c,
			}, pbody)
			corner(alphaBar, 4)

			alphaFill = frame({
				Name = "fill",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromHSV(h, s, v),
				ZIndex = 2,
			}, alphaBar)
			corner(alphaFill, 4)
			mk("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0),
				}),
			}, alphaFill)

			alphaGrab = frame({
				Name = "grab",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.new(0, 4, 1, 4),
				BackgroundColor3 = Color3.new(1, 1, 1),
				ZIndex = 4,
			}, alphaBar)
			corner(alphaGrab, 2)
			mk("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.5, Thickness = 1 }, alphaGrab)
			alphaHit = hitbox(alphaBar, { Name = "hit", ZIndex = 20 })
		end

		local rgbBox = frame({
			Name = "rgb",
			Position = UDim2.fromOffset(0, BODY_H - SIZE[0]),
			Size = UDim2.new(1, 0, 0, SIZE[0]),
		}, pbody)
		local rgbVals = {}
		local CELL = (PANEL_W - PAD * 2) / 3
		for i, ch in ipairs({ "R", "G", "B" }) do
			label(ch, 0, THEME.TextDisabled, rgbBox, {
				Name = ch .. "_lbl",
				Size = UDim2.fromOffset(12, SIZE[0]),
				Position = UDim2.fromOffset((i - 1) * CELL, 0),
			})
			rgbVals[ch] = label("0", 0, THEME.Text, rgbBox, {
				Name = ch .. "_val",
				Size = UDim2.fromOffset(CELL - 14, SIZE[0]),
				Position = UDim2.fromOffset((i - 1) * CELL + 14, 0),
			})
		end

		local function refresh(fire)
			local c = Color3.fromHSV(h, s, v)

			swatch.BackgroundColor3 = c
			swatch.BackgroundTransparency = alphaEnabled and (1 - alpha) or 0

			sq.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			svGrab.Position = UDim2.fromScale(s, 1 - v)
			hueGrab.Position = UDim2.fromScale(0.5, h)

			if alphaEnabled then
				alphaFill.BackgroundColor3 = c
				alphaGrab.Position = UDim2.fromScale(alpha, 0.5)
			end

			rgbVals.R.Text = tostring(math.round(c.R * 255))
			rgbVals.G.Text = tostring(math.round(c.G * 255))
			rgbVals.B.Text = tostring(math.round(c.B * 255))

			el.CurrentValue = c
			el.Color = c
			el.Alpha = alpha

			if fire and o.Callback then
				task.spawn(o.Callback, c, alpha)
			end
		end

		local function bindBar(hit, mode)
			hit.MouseButton1Down:Connect(function()
				beginDrag(function(m)
					if mode == "sv" then
						local p, z = sq.AbsolutePosition, sq.AbsoluteSize
						s = math.clamp((m.X - p.X) / math.max(z.X, 1), 0, 1)
						v = 1 - math.clamp((m.Y - p.Y) / math.max(z.Y, 1), 0, 1)
					elseif mode == "hue" then
						local p, z = hueBar.AbsolutePosition, hueBar.AbsoluteSize
						h = math.clamp((m.Y - p.Y) / math.max(z.Y, 1), 0, 1)
					else
						local p, z = alphaBar.AbsolutePosition, alphaBar.AbsoluteSize
						alpha = math.clamp((m.X - p.X) / math.max(z.X, 1), 0, 1)
					end
					refresh(true)
				end, markDirty)
			end)
		end
		bindBar(svHit, "sv")
		bindBar(hueHit, "hue")
		if alphaEnabled then
			bindBar(alphaHit, "alpha")
		end

		grip.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				local start = mousePos()
				local from = panel.Position
				beginDrag(function(m)
					local d = m - start
					panel.Position = UDim2.fromOffset(from.X.Offset + d.X, from.Y.Offset + d.Y)
					placed = true
				end)
			end
		end)

		local function snapToSwatch()
			local x, y = toLocal(floatLayer, swatch.AbsolutePosition)
			local lz = floatLayer.AbsoluteSize
			panel.Position = UDim2.fromOffset(
				math.clamp(x + 22, 0, math.max(lz.X - PANEL_W, 0)),
				math.clamp(y - 4, 0, math.max(lz.Y - PANEL_H, 0))
			)
		end

		btn.MouseButton1Click:Connect(function()
			open = not open
			if open and not placed then
				snapToSwatch()
			end
		end)
		closeBtn.MouseButton1Click:Connect(function()
			open = false
		end)

		local closeSt = tracked(closeBtn)
		local fade = 0
		onFrame(function(dt)
			fade = step(fade, open and 1 or 0, 21, dt)
			panel.GroupTransparency = 1 - fade
			panel.Visible = fade > 0.01
			closeBtn.TextColor3 = colAnim(
				THEME.TextDisabled,
				THEME.Text,
				closeSt.hover and 1 or 0
			).c
		end)

		refresh(false)

		el.Type = "ColorPicker"
		function el:Get()
			return Color3.fromHSV(h, s, v), alpha
		end
		function el:Set(c3, alphaVal, fire)
			if typeof(c3) == "Color3" then
				local nh, ns, nv = Color3.toHSV(c3)
				if not (c3.R == c3.G and c3.G == c3.B) then
					h = nh
				end
				s, v = ns, nv
			end
			alpha = tonumber(alphaVal) or alpha
			refresh(fire ~= false)
		end
		el.onDestroy = function()
			panel:Destroy()
		end
		return register(el, row, o.Flag)
	end

	local function makeLabel(parent, o)
		local el = {}
		local text = tostring(o.Name or o.Text or "")

		local l = label(text, 0, THEME.Text, parent, {
			Name = "label",
			Size = UDim2.new(1, 0, 0, SIZE[0]),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = nextOrder(parent),
		})
		if o.Icon then
			local img = resolveIcon(o.Icon)
			if img then
				icon(img, THEME.Scheme, l, {
					Position = UDim2.fromOffset(0, 1),
					Size = UDim2.fromOffset(14, 14),
				})
				l.Text = "      " .. text
			end
		end

		el.Type = "Label"
		el.CurrentValue = text
		function el:Get()
			return l.Text
		end
		function el:Set(s)
			l.Text = tostring(s)
			el.CurrentValue = l.Text
		end
		return register(el, l, nil)
	end

	local function makeParagraph(parent, o)
		local el = {}
		local title = tostring(o.Title or o.Name or "")
		local content = tostring(o.Content or "")

		local box = frame({
			Name = title ~= "" and title or "paragraph",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = nextOrder(parent),
		}, parent)
		mk("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		}, box)

		local titleLbl = label(title, 1, THEME.Text, box, {
			Name = "title",
			Size = UDim2.new(1, 0, 0, SIZE[1] + 2),
			Visible = title ~= "",
			LayoutOrder = 1,
		})
		local bodyLbl = label(content, 0, THEME.TextDisabled, box, {
			Name = "content",
			Size = UDim2.new(1, 0, 0, SIZE[0]),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = 2,
		})

		el.Type = "Paragraph"
		function el:Get()
			return bodyLbl.Text
		end
		function el:Set(t, c)
			if t ~= nil then
				titleLbl.Text = tostring(t)
				titleLbl.Visible = titleLbl.Text ~= ""
			end
			if c ~= nil then
				bodyLbl.Text = tostring(c)
			end
		end
		return register(el, box, nil)
	end

	local function makeDivider(parent)
		local el = {}
		local holder = frame({
			Name = "divider",
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = THEME.Border.c,
			BackgroundTransparency = 1 - THEME.Border.a,
			LayoutOrder = nextOrder(parent),
		}, parent)
		el.Type = "Divider"
		function el:Get()
			return nil
		end
		function el:Set() end
		return register(el, holder, nil)
	end

	local Section = {}
	Section.__index = Section

	local function makeSection(tab, o)
		local name = tostring(o.Name or "Section")
		local side = o.Side

		local subIdx = tab.curSubtab or 1
		if o.Subtab ~= nil then
			if type(o.Subtab) == "number" then
				subIdx = o.Subtab
			else
				subIdx = table.find(tab.subtabs, tostring(o.Subtab)) or subIdx
			end
		end
		local cols = tab.columns[subIdx] or tab.columns[1]

		if side ~= "left" and side ~= "right" then
			cols.n += 1
			side = (cols.n % 2 == 1) and "left" or "right"
		end
		local parent = cols[side]
		local height = tonumber(o.Height)

		local box = frame({
			Name = name,
			Size = UDim2.new(1, 0, 0, height or SECTION_HEAD),
			AutomaticSize = height and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
			BackgroundColor3 = THEME.ChildBg.c,
			ClipsDescendants = height ~= nil,
			LayoutOrder = nextOrder(parent),
		}, parent)
		corner(box, STYLE.ChildRounding)

		local head = frame({
			Name = "head",
			Size = UDim2.new(1, 0, 0, SECTION_HEAD),
			BackgroundColor3 = THEME.Header.c,
			ZIndex = 2,
		}, box)
		roundSide(head, STYLE.ChildRounding, "Top")

		frame({
			Name = "line",
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1),
			BackgroundColor3 = THEME.BorderShadow.c,
			BackgroundTransparency = 1 - THEME.BorderShadow.a,
			ZIndex = 3,
		}, head)

		local headLbl = label(name, 1, THEME.Text, head, {
			Position = UDim2.new(0, 13, 0, 0),
			Size = UDim2.new(1, -26, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 3,
		})

		local inner
		if height then
			inner = mk("ScrollingFrame", {
				Name = "inner",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, SECTION_HEAD + 1),
				Size = UDim2.new(1, 0, 1, -SECTION_HEAD - 1),
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = THEME.ScrollbarGrab.c,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ZIndex = 2,
			}, box)
		else
			inner = frame({
				Name = "inner",
				Position = UDim2.new(0, 0, 0, SECTION_HEAD + 1),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2,
			}, box)
		end
		mk("UIPadding", {
			PaddingLeft = UDim.new(0, 13),
			PaddingRight = UDim.new(0, 13),
			PaddingTop = UDim.new(0, 15),
			PaddingBottom = UDim.new(0, 15),
		}, inner)
		mk("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 14),
		}, inner)

		local self = setmetatable({
			Name = name,
			Instance = box,
			Inner = inner,
			Tab = tab,
			Side = side,
		}, Section)
		self._head = headLbl
		return self
	end

	function Section:CreateButton(o)
		return makeButton(self.Inner, o or {})
	end
	function Section:CreateToggle(o)
		return makeToggle(self.Inner, o or {})
	end
	function Section:CreateSlider(o)
		return makeSlider(self.Inner, o or {})
	end
	function Section:CreateDropdown(o)
		return makeDropdown(self.Inner, self.Tab, o or {})
	end
	function Section:CreateInput(o)
		return makeInput(self.Inner, o or {})
	end
	function Section:CreateKeybind(o)
		return makeKeybind(self.Inner, o or {})
	end
	function Section:CreateColorPicker(o)
		return makeColorPicker(self.Inner, o or {})
	end
	function Section:CreateLabel(o)
		return makeLabel(self.Inner, type(o) == "table" and o or { Name = o })
	end
	function Section:CreateParagraph(o)
		return makeParagraph(self.Inner, o or {})
	end
	function Section:CreateDivider()
		return makeDivider(self.Inner)
	end
	function Section:SetName(n)
		self.Name = tostring(n)
		self._head.Text = self.Name
		self.Instance.Name = self.Name
	end
	function Section:SetVisible(state)
		self.Instance.Visible = state and true or false
	end
	function Section:Destroy()
		self.Instance:Destroy()
	end
	Section.CreateTextbox = Section.CreateInput
	Section.CreateBind = Section.CreateKeybind
	Section.CreateColourPicker = Section.CreateColorPicker

	local Tab = {}
	Tab.__index = Tab

	local function selectTab(idx)
		if UI.nextTab ~= idx then
			UI.nextTab = idx
			UI.animDst = 0
		end
	end

	local function makeTab(name, iconKey, subtabs)
		local index = #UI.tabs + 1
		local tab = setmetatable({
			index = index,
			Name = tostring(name or ("Tab " .. index)),
			icon = resolveIcon(iconKey),
			subtabs = subtabs or {},
			curSubtab = 1,
			nextSubtab = 1,
			pages = {},
			columns = {},
			openCombo = nil,
			sections = {},
		}, Tab)
		UI.tabs[index] = tab

		local holder = frame({
			Name = tab.Name,
			Size = UDim2.new(1, 0, 0, TAB_H),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = index,
		}, tabList)
		tab.Instance = holder

		local row = frame({
			Name = "row",
			Size = UDim2.new(1, 0, 0, TAB_H),
		}, holder)

		local tIcon = icon(tab.icon, THEME.TextDisabled, row, {
			Position = UDim2.new(0, 15, 0.5, -8),
			Visible = tab.icon ~= nil,
		})
		local tName = label(tab.Name, 2, THEME.TextDisabled, row, {
			Position = UDim2.new(0, tab.icon and 40 or 18, 0, 0),
			Size = UDim2.new(1, -65, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		tab._nameLabel = tName

		local arrow
		if #tab.subtabs > 0 then
			arrow = icon(ICON["chevron-down"], THEME.Text, row, {
				Size = UDim2.fromOffset(12, 12),
				Position = UDim2.new(1, -25, 0.5, -6),
				Rotation = -90,
			})
		end

		frame({
			Name = "sep",
			Size = UDim2.new(1, -40, 0, 1),
			Position = UDim2.new(0, 40, 1, -1),
			BackgroundColor3 = THEME.Border.c,
			BackgroundTransparency = 1 - THEME.Border.a * 0.5,
			ZIndex = 2,
		}, row)

		local btn = hitbox(row)
		local st = tracked(btn)

		local drawer, drawerList
		local drawerAlpha = { v = 0 }
		if #tab.subtabs > 0 then
			drawer = frame({
				Name = "subtabs",
				Position = UDim2.new(0, 0, 0, TAB_H),
				Size = UDim2.new(1, 0, 0, 0),
				ClipsDescendants = true,
			}, holder)

			drawerList = frame({
				Name = "list",
				Position = UDim2.new(0, 40, 0, 0),
				Size = UDim2.new(1, -40, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
			}, drawer)
			mk("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
			}, drawerList)
			mk("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
			}, drawerList)

			for i, subName in ipairs(tab.subtabs) do
				local sub = mk("TextButton", {
					Name = subName,
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Text = subName,
					FontFace = FONT[0],
					TextSize = SIZE[0],
					TextColor3 = THEME.TextDisabled.c,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, SIZE[0] + 2),
					LayoutOrder = i,
				}, drawerList)

				local sst = tracked(sub)
				local sobj = { anim = 0, hover = 0 }

				sub.MouseButton1Click:Connect(function()
					if tab.nextSubtab ~= i then
						tab.nextSubtab = i
						UI.contentAnimDst = 0
					end
				end)

				onFrame(function(dt)
					local selected = tab.nextSubtab == i
					sobj.anim = step(sobj.anim, selected and 1 or 0, 14, dt)
					sobj.hover = step(sobj.hover, sst.hover and 1 or 0, 14, dt)
					local c = colAnim(
						colAnim(THEME.TextDisabled, THEME.Text, sobj.hover),
						THEME.Scheme,
						sobj.anim
					)
					sub.TextColor3 = c.c
					sub.TextTransparency = 1 - c.a * drawerAlpha.v
				end)

				pageFor(tab, i)
			end
		else
			pageFor(tab, 1)
		end

		btn.MouseButton1Click:Connect(function()
			selectTab(index)
		end)

		local obj = { cur = 0, hover = 0, rad = math.pi / 2 }
		onFrame(function(dt)
			local selected = UI.nextTab == index
			obj.cur = step(obj.cur, selected and 1 or 0, 14, dt)
			obj.hover = step(obj.hover, st.hover and 1 or 0, 14, dt)
			obj.rad = step(obj.rad, selected and math.pi * 1.5 or math.pi / 2, 14, dt)

			local c = colAnim(
				colAnim(THEME.TextDisabled, { c = THEME.Text.c, a = 0.75 }, obj.hover),
				THEME.Text,
				obj.cur
			)
			tIcon.ImageColor3 = c.c
			tIcon.ImageTransparency = 1 - c.a
			tName.TextColor3 = c.c
			tName.TextTransparency = 1 - c.a
			tName.FontFace = FONT[selected and 3 or 2]

			if arrow then
				arrow.Rotation = math.deg(obj.rad) - 180
			end

			if drawer then
				drawerAlpha.v = obj.cur
				drawer.Size = UDim2.new(1, 0, 0, drawerList.AbsoluteSize.Y * obj.cur)
				drawer.Visible = obj.cur > 0.01
			end
		end)

		if index == 1 then
			UI.curTab, UI.nextTab = 1, 1
			showActivePage()
		end

		return tab
	end

	function Tab:_default()
		local sub = self.curSubtab or 1
		self._defaults = self._defaults or {}
		if not self._defaults[sub] then
			self._defaults[sub] = makeSection(self, { Name = self.Name })
		end
		return self._defaults[sub]
	end

	function Tab:CreateSection(o)
		local opts = type(o) == "table" and o or { Name = o }
		local sec = makeSection(self, opts)
		table.insert(self.sections, sec)
		return sec
	end

	function Tab:CreateButton(o)
		return self:_default():CreateButton(o)
	end
	function Tab:CreateToggle(o)
		return self:_default():CreateToggle(o)
	end
	function Tab:CreateSlider(o)
		return self:_default():CreateSlider(o)
	end
	function Tab:CreateDropdown(o)
		return self:_default():CreateDropdown(o)
	end
	function Tab:CreateInput(o)
		return self:_default():CreateInput(o)
	end
	function Tab:CreateKeybind(o)
		return self:_default():CreateKeybind(o)
	end
	function Tab:CreateColorPicker(o)
		return self:_default():CreateColorPicker(o)
	end
	function Tab:CreateLabel(o)
		return self:_default():CreateLabel(o)
	end
	function Tab:CreateParagraph(o)
		return self:_default():CreateParagraph(o)
	end
	function Tab:CreateDivider()
		return self:_default():CreateDivider()
	end
	Tab.CreateTextbox = Tab.CreateInput
	Tab.CreateBind = Tab.CreateKeybind
	Tab.CreateColourPicker = Tab.CreateColorPicker

	function Tab:Select()
		selectTab(self.index)
	end
	function Tab:SelectSubtab(want)
		local idx = want
		if type(want) == "string" then
			idx = table.find(self.subtabs, want) or 1
		end
		if self.nextSubtab ~= idx then
			self.nextSubtab = idx
			if UI.curTab == self.index then
				UI.contentAnimDst = 0
			else
				self.curSubtab = idx
			end
		end
	end
	function Tab:SetName(n)
		self.Name = tostring(n)
		self._nameLabel.Text = self.Name
		self.Instance.Name = self.Name
	end
	function Tab:SetVisible(state)
		self.Instance.Visible = state and true or false
	end

	onFrame(function()
		local tab = UI.tabs[UI.curTab]
		if not tab then return end

		local sub = tab.subtabs[tab.curSubtab]
		local hasSubs = sub ~= nil

		local baseX = tab.icon and 40 or 18

		hdIcon.Image = tab.icon or ""
		hdIcon.Visible = tab.icon ~= nil
		hdIcon.ImageTransparency = 1 - UI.anim

		hdName.Text = tab.Name
		hdName.Position = UDim2.new(0, baseX, 0, 0)
		local nameCol = hasSubs and THEME.TextDisabled or THEME.Text
		hdName.TextColor3 = nameCol.c
		hdName.TextTransparency = 1 - nameCol.a * UI.anim

		hdArrow.Visible = hasSubs
		hdSub.Visible = hasSubs
		if hasSubs then
			local w = textWidth(tab.Name, 2)
			hdArrow.Position = UDim2.new(0, baseX + 7 + w, 0.5, -6)
			hdArrow.ImageTransparency = 1 - UI.anim * UI.contentAnim

			hdSub.Text = sub
			hdSub.Position = UDim2.new(0, baseX + 20 + w, 0, 0)
			hdSub.TextTransparency = 1 - UI.anim * UI.contentAnim
		end

		content.GroupTransparency = 1 - UI.anim * UI.contentAnim
	end)

	local function handleAnims(dt)
		UI.anim = step(UI.anim, UI.animDst, 21, dt)
		UI.contentAnim = step(UI.contentAnim, UI.contentAnimDst, 21, dt)

		if UI.animDst == 0 and UI.anim < 0.01 then
			UI.curTab = UI.nextTab
			UI.animDst = 1
			showActivePage()
		end

		local tab = UI.tabs[UI.curTab]
		if tab and UI.contentAnimDst == 0 and UI.contentAnim < 0.01 then
			tab.curSubtab = tab.nextSubtab
			UI.contentAnimDst = 1
			showActivePage()
		end
	end

	local grip = hitbox(window, {
		Name = "grip",
		Size = UDim2.new(1, 0, 0, BAR_H),
		ZIndex = 0,
	})
	grip.MouseButton1Down:Connect(function()
		local start = mousePos()
		local from = window.Position
		beginDrag(function(m)
			local d = m - start
			window.Position = UDim2.new(
				from.X.Scale, from.X.Offset + d.X,
				from.Y.Scale, from.Y.Offset + d.Y
			)
		end)
	end)

	local destroyWindow
	headerBtn("close", "X", -22, function()
		if destroyWindow then
			destroyWindow()
		end
	end)

	local pump = RunService.RenderStepped:Connect(function(dt)
		handleAnims(dt)
		for i = #ANIM, 1, -1 do
			local ok, err = pcall(ANIM[i], dt)
			if not ok then warn("[weave] anim error: " .. tostring(err)) end
		end
	end)
	table.insert(CONNS, pump)

	local cfgSaving = cfg.ConfigurationSaving or {}
	local cfgEnabled = cfgSaving.Enabled and FS_OK
	local cfgFolder = tostring(cfgSaving.FolderName or "Weave")
	local cfgFile = tostring(cfgSaving.FileName or name)
	local cfgPath = cfgFolder .. "/" .. cfgFile .. ".json"

	local function SaveConfiguration()
		if not cfgEnabled then
			return
		end
		local t = {}
		for _, el in ipairs(elements) do
			if el.Flag then
				if el.Type == "ColorPicker" then
					local c, a = el:Get()
					local enc = encodeValue(c)
					enc.__a = a
					t[el.Flag] = enc
				else
					t[el.Flag] = encodeValue((el:Get()))
				end
			end
		end
		if FS.mkdir and not (FS.isdir and FS.isdir(cfgFolder)) then
			pcall(FS.mkdir, cfgFolder)
		end
		pcall(FS.write, cfgPath, HttpService:JSONEncode(t))
	end

	local function LoadConfiguration()
		if not cfgEnabled then
			return
		end
		if not (FS.isfile and FS.isfile(cfgPath)) then
			return
		end
		local ok, raw = pcall(FS.read, cfgPath)
		if not ok or not raw then
			return
		end
		local ok2, t = pcall(function()
			return HttpService:JSONDecode(raw)
		end)
		if not ok2 or type(t) ~= "table" then
			return
		end
		for flag, encoded in pairs(t) do
			local el = Weave.Flags[flag]
			if el and el.Set then
				if el.Type == "ColorPicker" then
					local a = type(encoded) == "table" and encoded.__a or nil
					pcall(el.Set, el, decodeValue(encoded), a, false)
				else
					pcall(el.Set, el, decodeValue(encoded), false)
				end
			end
		end
	end

	local saveQueued = false
	dirty = function()
		if not cfgEnabled or saveQueued then return end
		saveQueued = true
		task.delay(2, function()
			saveQueued = false
			SaveConfiguration()
		end)
	end

	local keyCfg = cfg.KeySettings or {}
	local keyEnabled = cfg.KeySystem and true or false
	local keyValid = false

	local function checkKey(input)
		local expected = keyCfg.Key
		if type(expected) == "table" then
			for _, k in ipairs(expected) do
				if tostring(k) == input then return true end
			end
			return false
		end
		return tostring(expected) == input
	end

	if keyEnabled then
		window.Visible = false

		local keyFolder = tostring(keyCfg.FolderName or cfgFolder)
		local keyFile = keyFolder .. "/" .. tostring(keyCfg.FileName) .. ".txt"

		local function unlock()
			keyValid = true
			window.Visible = true
			LoadConfiguration()
		end

		if keyCfg.SaveKey and FS_OK and FS.isfile and FS.isfile(keyFile) then
			local ok, saved = pcall(FS.read, keyFile)
			if ok and saved and checkKey(saved:gsub("%s+", "")) then
				unlock()
			end
		end

		if not keyValid then
			local KW, KH = 340, 160
			local kpanel = mk("CanvasGroup", {
				Name = "keyPrompt",
				Size = UDim2.fromOffset(KW, KH),
				Position = UDim2.new(0.5, -KW / 2, 0.5, -KH / 2),
				BackgroundColor3 = THEME.WindowBg.c,
				BackgroundTransparency = 1 - THEME.WindowBg.a,
				ZIndex = 200,
			}, floatLayer)
			corner(kpanel, STYLE.WindowRounding)
			stroke(kpanel, THEME.Border)

			label(tostring(keyCfg.Title or name), 3, THEME.Text, kpanel, {
				Size = UDim2.new(1, -20, 0, 28),
				Position = UDim2.new(0, 10, 0, 8),
				TextXAlignment = Enum.TextXAlignment.Center,
			})
			label(tostring(keyCfg.Subtitle or "Enter your key"), 0, THEME.TextDisabled, kpanel, {
				Size = UDim2.new(1, -20, 0, 18),
				Position = UDim2.new(0, 10, 0, 36),
				TextXAlignment = Enum.TextXAlignment.Center,
			})
			if keyCfg.Note then
				label(tostring(keyCfg.Note), 0, THEME.TextDisabled, kpanel, {
					Size = UDim2.new(1, -20, 0, 16),
					Position = UDim2.new(0, 10, 0, 54),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextTransparency = 0.4,
				})
			end

			local kbox = mk("TextBox", {
				Name = "keyInput",
				Size = UDim2.new(1, -20, 0, 30),
				Position = UDim2.new(0, 10, 0, 80),
				BackgroundColor3 = THEME.FrameBg.c,
				BackgroundTransparency = 1 - THEME.FrameBg.a,
				TextColor3 = THEME.Text.c,
				PlaceholderText = "Key...",
				PlaceholderColor3 = THEME.TextDisabled.c,
				FontFace = FONT[0],
				TextSize = SIZE[0],
				ClearTextOnFocus = false,
				ZIndex = 201,
			}, kpanel)
			corner(kbox, STYLE.FrameRounding)
			mk("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, kbox)

			local kbtn = mk("TextButton", {
				Name = "submit",
				Size = UDim2.new(1, -20, 0, 28),
				Position = UDim2.new(0, 10, 0, 118),
				BackgroundColor3 = THEME.Scheme.c,
				BackgroundTransparency = 1 - THEME.Scheme.a,
				Text = "Submit",
				TextColor3 = THEME.Text.c,
				FontFace = FONT[1],
				TextSize = SIZE[0],
				ZIndex = 201,
			}, kpanel)
			corner(kbtn, STYLE.FrameRounding)

			local function tryKey()
				local input = kbox.Text:gsub("%s+", "")
				if checkKey(input) then
					if keyCfg.SaveKey and FS_OK then
						if FS.mkdir and not (FS.isdir and FS.isdir(keyFolder)) then
							pcall(FS.mkdir, keyFolder)
						end
						pcall(FS.write, keyFile, input)
					end
					kpanel:Destroy()
					unlock()
				else
					kbox.Text = ""
					kbox.PlaceholderText = "Invalid key — try again"
				end
			end

			kbtn.MouseButton1Click:Connect(tryKey)
			kbox.FocusLost:Connect(function(enter) if enter then tryKey() end end)
		end
	else
		LoadConfiguration()
	end

	local Window = {}

	function Window:CreateTab(tabName, iconKey, subtabs)
		local t = makeTab(tabName, iconKey, subtabs)
		return t
	end

	function Window:SelectTab(want)
		if type(want) == "number" then
			selectTab(want)
		else
			for _, t in ipairs(UI.tabs) do
				if t.Name == tostring(want) then
					selectTab(t.index)
					break
				end
			end
		end
	end

	function Window:SetTitle(n)
		brandLabel.Text = tostring(n)
	end

	function Window:SetSubtitle(n)
		planLabel.Text = tostring(n)
	end

	function Window:Show()
		setShown(true)
	end

	function Window:Hide()
		setShown(false)
	end

	function Window:Toggle()
		setShown(not shown)
	end

	function Window:SetToggleKey(k)
		toggleKey = toBind(k) or Enum.KeyCode.RightShift
	end

	function Window:SaveConfiguration()
		SaveConfiguration()
	end

	function Window:LoadConfiguration()
		LoadConfiguration()
	end

	function Window:Destroy()
		for _, conn in ipairs(CONNS) do conn:Disconnect() end
		table.clear(ANIM)
		gui:Destroy()
		for i, w in ipairs(Weave.Windows) do
			if w == Window then
				table.remove(Weave.Windows, i)
				break
			end
		end
	end

	destroyWindow = function() Window:Destroy() end

	table.insert(Weave.Windows, Window)
	return Window
end

return Weave
