-- AirFlow
-- A reusable Roblox UI library with tabs, controls, configuration,
-- notifications, dialogs, keyboard toggling, responsive sizing, and theming.
--
-- Public entry points:
--   AirFlow.CreateWindow(options) / AirFlow.Window(options)
--   window:Tab(options), window:Toggle(), window:Notify(), window:Dialog()
--   tab:Section(), tab:Button(), tab:Toggle(), tab:Slider(), tab:Stepper()
--   tab:Dropdown(), tab:Input(), tab:Keybind(), tab:ColorPicker()
--   tab:Progress(), tab:Paragraph(), tab:Label(), tab:Divider()
--
-- The implementation remains behaviour-compatible with the original AirFlow
-- release; this repository applies formatting and API documentation only.

local T = game:GetService("TweenService")
local q = game:GetService("UserInputService")
local ad = game:GetService("GuiService")
local U = game:GetService("RunService")
local C = game:GetService("HttpService")
local D = game:GetService("Players")
local E = D.LocalPlayer
local f = {}
f.Flags = {}
f.Windows = {}
local function l(b, c)
	local a = {}
	if type(b) == "string" then
		a.Name = b
	elseif type(b) == "table" then
		for b, c in pairs(b) do
			a[b] = c
		end
	end
	for b, c in pairs(c or {}) do
		if a[c] == nil and a[b] ~= nil then
			a[c] = a[b]
		end
	end
	if a.Range then
		a.Min = a.Min or a.Range[1]
		a.Max = a.Max or a.Range[2]
	end
	return a
end
local function n(e, b, a, d, g)
	a._type = g
	a._frame = d
	a._listeners = a._listeners or {}
	local c = e and e.Window
	if b.Flag then
		f.Flags[b.Flag] = a
		if c then
			local a = b.Callback
			b.Callback = function(...)
				if type(a) == "function" then
					a(...)
				end
				c:_autoSave()
			end
		end
	end
	function a:Destroy()
		if a._destroyed then
			return
		end
		a._destroyed = true
		for b, a in ipairs(a._listeners) do
			a()
		end
		a._listeners = {}
		if b.Flag and f.Flags[b.Flag] == a then
			f.Flags[b.Flag] = nil
		end
		if c then
			c._controlsDirty = true
		end
		if d then
			d:Destroy()
		end
	end
	return a
end
f.Theme = {
	Background = Color3.fromRGB(20, 16, 20),
	Surface = Color3.fromRGB(24, 19, 24),
	Surface2 = Color3.fromRGB(28, 22, 28),
	Surface3 = Color3.fromRGB(42, 36, 43),
	Stroke = Color3.fromRGB(40, 32, 41),
	StrokeHover = Color3.fromRGB(88, 70, 90),
	Accent = Color3.fromRGB(235, 199, 246),
	AccentDark = Color3.fromRGB(24, 18, 26),
	Text = Color3.fromRGB(233, 229, 234),
	Muted = Color3.fromRGB(125, 115, 126),
	Warning = Color3.fromRGB(240, 176, 108),
	Success = Color3.fromRGB(150, 220, 170),
	Error = Color3.fromRGB(240, 120, 120),
}
f.Assets =
	{ Shadow = "rbxassetid://6014261993", Glow = "rbxassetid://8992230677", Logo = "rbxassetid://103859712365480" }
local A
local function I()
	if A ~= nil then
		return A
	end
	local b, a = pcall(function()
		local a =
			game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua")
		return loadstring(a)()
	end)
	if b and type(a) == "table" then
		A = a
	else
		A = false
		warn("[AirFlow] lucide icons unavailable: " .. tostring(a))
	end
	return A
end
local ae = {
	ValleySans = {
		Regular = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-Regular.ttf",
		Medium = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-Medium.ttf",
		SemiBold = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-SemiBold.ttf",
	},
}
local V = {
	Regular = { 400, Enum.FontWeight.Regular },
	Medium = { 500, Enum.FontWeight.Medium },
	SemiBold = { 600, Enum.FontWeight.SemiBold },
	Bold = { 700, Enum.FontWeight.Bold },
}
function f:LoadFont(b)
	local e = "function"
	b = l(b, {})
	if type(writefile) ~= e or type(isfile) ~= e or typeof(getcustomasset) ~= e then
		warn("[AirFlow] custom fonts need writefile, isfile and getcustomasset")
		return false
	end
	local a = b.Name or "CustomFont"
	local g = b.Weights or ae[a]
	if type(g) ~= "table" then
		warn("[AirFlow] no font weights for " .. a)
		return false
	end
	local d = b.Folder or "AirFlowFonts"
	pcall(function()
		if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(d) then
			makefolder(d)
		end
	end)
	local h = {}
	for b, e in pairs(g) do
		local c = V[b]
		if c then
			local f, g = d .. "/" .. a .. "-" .. b .. ".ttf", true
			if not isfile(f) then
				g = pcall(function()
					writefile(f, game:HttpGet(e))
				end)
			end
			if g then
				table.insert(h, { name = b, weight = c[1], style = "normal", assetId = getcustomasset(f) })
			else
				warn("[AirFlow] could not download " .. b .. " weight of " .. a)
			end
		end
	end
	if #h == 0 then
		return false
	end
	local i = d .. "/" .. a .. ".json"
	local j = pcall(function()
		writefile(i, C:JSONEncode({ name = a, faces = h }))
	end)
	if not j then
		return false
	end
	local k = getcustomasset(i)
	local function c(a, c)
		local b = V[a]
		if b and g[a] then
			return Font.new(k, b[2])
		end
		return c
	end
	f.Fonts.Regular = c("Regular", f.Fonts.Regular)
	f.Fonts.Medium = c("Medium", c("Regular", f.Fonts.Medium))
	f.Fonts.Bold = c("SemiBold", c("Bold", f.Fonts.Bold))
	return true
end
function f:PreloadIcons()
	return I() ~= false
end
local function af(a)
	if typeof(a) == "table" then
		return a.Image, a.RectOffset, a.RectSize
	end
	if type(a) ~= "string" then
		return nil
	end
	if a:find("^rbxassetid://") or a:find("^rbxasset://") or a:find("^http") then
		return a
	end
	local d = a:gsub("^lucide:", "")
	local b = I()
	if not b then
		return nil
	end
	local c = b.Icons and b.Icons[d] or b[d]
	if type(c) == "table" then
		local a = c.Image
		if type(a) == "number" then
			a = "rbxassetid://" .. tostring(a)
		end
		local d = b.Spritesheets and b.Spritesheets[tostring(a)] or a
		return d, c.ImageRectPosition, c.ImageRectSize
	elseif type(c) == "string" then
		return c
	end
	warn("[AirFlow] unknown lucide icon: " .. d)
	return nil
end
local J = "rbxasset://fonts/families/BuilderSans.json"
f.Fonts = {
	Regular = Font.new(J, Enum.FontWeight.Regular),
	Medium = Font.new(J, Enum.FontWeight.Medium),
	Bold = Font.new(J, Enum.FontWeight.SemiBold),
}
local a = f.Theme
local t = f.Assets
local i = f.Fonts
local m = q.TouchEnabled and not q.KeyboardEnabled
f.Touch = m
local K = m and 54 or 48
local v = m and 70 or 64
local L = m and 40 or 34
local s = m and 34 or 28
local W = {}
local function b(e, f, a, b, c)
	a = a or 0.2
	if a <= 0 then
		for a, b in pairs(f) do
			e[a] = b
		end
		return nil
	end
	b = b or Enum.EasingStyle.Quart
	c = c or Enum.EasingDirection.Out
	local g = a .. b.Name .. c.Name
	local d = W[g]
	if not d then
		d = TweenInfo.new(a, b, c)
		W[g] = d
	end
	local h = T:Create(e, d, f)
	h:Play()
	return h
end
local function c(d, b, c)
	local a = Instance.new(d)
	for b, c in pairs(b) do
		if b ~= "Parent" then
			a[b] = c
		end
	end
	if c then
		for c, b in ipairs(c) do
			b.Parent = a
		end
	end
	if b.Parent then
		a.Parent = b.Parent
	end
	return a
end
local function e(a, b)
	return c("UICorner", { CornerRadius = b or UDim.new(0, 8), Parent = a })
end
local function h(b, d, e, f)
	return c("UIStroke", {
		Color = d or a.Stroke,
		Transparency = e or 0,
		Thickness = f or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = b,
	})
end
local function o(a, b, d, e, f)
	return c("UIPadding", {
		PaddingLeft = UDim.new(0, b or 0),
		PaddingRight = UDim.new(0, d or 0),
		PaddingTop = UDim.new(0, e or 0),
		PaddingBottom = UDim.new(0, f or 0),
		Parent = a,
	})
end
local function d(d)
	local b = {
		BackgroundTransparency = 1,
		TextColor3 = a.Text,
		TextSize = 14,
		FontFace = i.Medium,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}
	for a, c in pairs(d) do
		b[a] = c
	end
	return c("TextLabel", b)
end
local function x(d, e, f, g, h)
	local b = c("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = f,
		Size = e,
		BackgroundTransparency = 1,
		Image = t.Glow,
		ImageColor3 = Color3.fromRGB(226, 218, 230),
		ImageTransparency = g,
		ZIndex = 0,
		Parent = d,
	})
	c(
		"UIGradient",
		{ Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), a.Accent), Rotation = h or 90, Parent = b }
	)
	return b
end
local function M(a)
	return c("Frame", {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		ZIndex = 0,
		Parent = a,
	})
end
local function u(a, c)
	local b, d, e = af(c)
	if not b then
		return
	end
	a.Image = b
	a.ImageRectOffset = d or Vector2.zero
	a.ImageRectSize = e or Vector2.zero
end
local function ag()
	local b
	pcall(function()
		if typeof(gethui) == "function" then
			b = gethui()
		end
	end)
	if typeof(b) == "Instance" then
		return b
	end
	local a
	pcall(function()
		a = game:GetService("CoreGui")
		local b = Instance.new("Folder")
		b.Parent = a
		b:Destroy()
	end)
	if a then
		return a
	end
	return E:WaitForChild("PlayerGui")
end
local X, Y = nil, Vector2.zero
local function r()
	local a = time()
	if X ~= a then
		X = a
		Y = ad:GetGuiInset()
	end
	return q:GetMouseLocation() - Y
end
local function p(a)
	return a.UserInputType == Enum.UserInputType.MouseButton1 or a.UserInputType == Enum.UserInputType.Touch
end
local function N(a)
	return a.UserInputType == Enum.UserInputType.MouseMovement or a.UserInputType == Enum.UserInputType.Touch
end
local function y(d, e, f, g)
	local a = c("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = g,
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
		Parent = d,
	})
	local b = c("ImageLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ImageColor3 = f,
		ScaleType = Enum.ScaleType.Fit,
		Parent = a,
	})
	u(b, e)
	return a, b
end
local function Z(j, g, k)
	local h = c("Frame", {
		AnchorPoint = Vector2.new(g, 0.5),
		Position = UDim2.new(g, k, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		BackgroundTransparency = 1,
		Parent = j,
	})
	local e = {}
	local f = c("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
		ImageColor3 = a.Muted,
		ScaleType = Enum.ScaleType.Fit,
		Parent = h,
	})
	u(f, "chevron-down")
	if f.Image ~= "" then
		function e:Set(c)
			b(f, { Rotation = c and 180 or 0, ImageColor3 = c and a.Accent or a.Muted }, 0.3, Enum.EasingStyle.Quint)
		end
		return e
	end
	f:Destroy()
	local function i(b, c)
		return d({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(18, 18),
			Text = "›",
			TextSize = 22,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextColor3 = a.Muted,
			TextTransparency = c,
			Rotation = b,
			Parent = h,
		})
	end
	local l = i(90, 0)
	local m = i(270, 1)
	function e:Set(c)
		b(l, { TextTransparency = c and 1 or 0 }, 0.2)
		b(m, { TextTransparency = c and 0 or 1, TextColor3 = c and a.Accent or a.Muted }, 0.2)
	end
	return e
end
local O = {}
local function ah(f)
	local g = r()
	local h = math.max(f.AbsoluteSize.X, f.AbsoluteSize.Y) * 2.2
	local d = table.remove(O)
	if not d then
		d = c("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = a.Accent, BorderSizePixel = 0 })
		e(d, UDim.new(1, 0))
	end
	d.Position = UDim2.fromOffset(g.X - f.AbsolutePosition.X, g.Y - f.AbsolutePosition.Y)
	d.Size = UDim2.fromOffset(0, 0)
	d.BackgroundTransparency = 0.82
	d.ZIndex = f.ZIndex + 1
	d.Parent = f
	b(d, { Size = UDim2.fromOffset(h, h), BackgroundTransparency = 1 }, 0.55)
	task.delay(0.55, function()
		d.Parent = nil
		if #O < 4 then
			table.insert(O, d)
		else
			d:Destroy()
		end
	end)
end
local function w(c)
	if not c then
		return
	end
	b(c, { Color = a.Accent, Transparency = 0.2 }, 0.08)
	task.delay(0.12, function()
		b(c, { Color = a.Stroke, Transparency = 0 }, 0.35)
	end)
end
local function F(c, d)
	c.MouseEnter:Connect(function()
		b(d, { Color = a.StrokeHover }, 0.12)
	end)
	c.MouseLeave:Connect(function()
		b(d, { Color = a.Stroke }, 0.25)
	end)
end
local ai = {
	[Enum.KeyCode.LeftControl] = "LCtrl",
	[Enum.KeyCode.RightControl] = "RCtrl",
	[Enum.KeyCode.LeftShift] = "LShift",
	[Enum.KeyCode.RightShift] = "RShift",
	[Enum.KeyCode.LeftAlt] = "LAlt",
	[Enum.KeyCode.RightAlt] = "RAlt",
	[Enum.KeyCode.Return] = "Enter",
	[Enum.KeyCode.Escape] = "Esc",
	[Enum.KeyCode.Backspace] = "Backspace",
}
local function P(a)
	if a == nil then
		return "None"
	end
	return ai[a] or a.Name
end
local function k(a, ...)
	if type(a) ~= "function" then
		return
	end
	local b, c = pcall(a, ...)
	if not b then
		warn("[AirFlow] callback error: " .. tostring(c))
	end
end
local function aa(e, f, a)
	local b = 0
	local c = tostring(a)
	local d = c:find("%.")
	if d then
		b = #c - d
	end
	local g = "%." .. b .. "f"
	return {
		snap = function(b)
			b = math.floor(b / a + 0.5) * a
			return math.clamp(b, e, f)
		end,
		format = function(a)
			return string.format(g, a)
		end,
	}
end
local function B(f, g, i, k)
	local d = {
		Size = UDim2.new(1, 0, 0, i),
		BackgroundColor3 = a.Surface2,
		BorderSizePixel = 0,
		LayoutOrder = f:_nextOrder(),
		Parent = f.List,
	}
	if g == "TextButton" then
		d.AutoButtonColor = false
		d.Text = ""
	end
	local b = c(g, d)
	b:SetAttribute("NoDrag", true)
	e(b)
	local j = h(b, a.Stroke)
	return b, j
end
local function G(b, f, g, c)
	local e, h
	if g then
		local j = (v - 38) / 2
		e = d({ Position = UDim2.fromOffset(14, j), Size = UDim2.new(1, -(14 + c), 0, 18), Text = f, Parent = b })
		h = d({
			Position = UDim2.fromOffset(14, j + 20),
			Size = UDim2.new(1, -(14 + c), 0, 17),
			Text = g,
			TextSize = 13,
			FontFace = i.Regular,
			TextColor3 = a.Muted,
			Parent = b,
		})
	else
		e = d({ Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -(14 + c), 1, 0), Text = f, Parent = b })
	end
	return e, h
end
local function z(h, a, i, j, c, k)
	a = l(a, i)
	local d = a.Desc and v or K
	local b, e = B(h, j or "Frame", d, a)
	F(b, e)
	local f, g
	if c then
		f, g = G(b, a.Name or k, a.Desc, c)
	end
	return a, b, e, d, f, g
end
local function H(a, b, c)
	if a then
		a.Size = UDim2.new(1, -(14 + c), a.Size.Y.Scale, a.Size.Y.Offset)
	end
	if b then
		b.Size = UDim2.new(1, -(14 + c), 0, b.Size.Y.Offset)
	end
end
local j = {}
j.__index = j
function j:_nextOrder()
	self._order += 1
	return self._order
end
function j:Section(b)
	if type(b) == "table" then
		b = b.Name or b.Title or ""
	end
	local f = c("Frame", {
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		LayoutOrder = self:_nextOrder(),
		Parent = self.List,
	})
	local e = d({
		Position = UDim2.fromOffset(2, 8),
		Size = UDim2.new(0, 0, 0, 16),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = string.upper(b),
		TextSize = 12,
		TextColor3 = a.Muted,
		TextTruncate = Enum.TextTruncate.None,
		Parent = f,
	})
	local g = c("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0, 16),
		Size = UDim2.new(1, -12, 0, 1),
		BackgroundColor3 = a.Stroke,
		BorderSizePixel = 0,
		Parent = f,
	})
	e:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		g.Size = UDim2.new(1, -(e.AbsoluteSize.X + 14), 0, 1)
	end)
	task.defer(function()
		g.Size = UDim2.new(1, -(e.AbsoluteSize.X + 14), 0, 1)
	end)
	return n(self, {}, {
		Set = function(b, a)
			e.Text = string.upper(a)
		end,
	}, f, "Section")
end
function j:Divider()
	local b = c("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = a.Stroke,
		BorderSizePixel = 0,
		LayoutOrder = self:_nextOrder(),
		Parent = self.List,
	})
	return n(self, {}, {}, b, "Divider")
end
function j:Label(b)
	b = l(b, { Name = "Text", Title = "Text" })
	local c = d({
		Size = UDim2.new(1, 0, 0, 18),
		Text = b.Text or "",
		TextSize = 13,
		FontFace = i.Regular,
		TextColor3 = b.Color or a.Muted,
		LayoutOrder = self:_nextOrder(),
		Parent = self.List,
	})
	o(c, 2)
	local e = {
		Set = function(b, a)
			c.Text = tostring(a)
		end,
		Get = function()
			return c.Text
		end,
	}
	if type(b.Update) == "function" then
		local a, d = math.max(tonumber(b.UpdateRate) or 1, 0.05), true
		e._listeners = e._listeners or {}
		table.insert(e._listeners, function()
			d = false
		end)
		task.spawn(function()
			while d and c.Parent do
				local e, d = pcall(b.Update)
				if e and d ~= nil then
					c.Text = tostring(d)
				elseif not e then
					warn("[AirFlow] label update error: " .. tostring(d))
				end
				task.wait(a)
			end
		end)
		function e:SetUpdateRate(b)
			a = math.max(tonumber(b) or a, 0.05)
		end
	end
	return n(self, b, e, c, "Label")
end
function j:Paragraph(b)
	b = l(b, { Title = "Name" })
	local e = B(self, "Frame", 0, b)
	e.AutomaticSize = Enum.AutomaticSize.Y
	o(e, 14, 14, 11, 12)
	c("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = e })
	d({ Size = UDim2.new(1, 0, 0, 14), Text = b.Name or "", LayoutOrder = 1, Parent = e })
	local f = d({
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = b.Content or "",
		TextSize = 13,
		FontFace = i.Regular,
		TextColor3 = a.Muted,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.None,
		TextYAlignment = Enum.TextYAlignment.Top,
		LayoutOrder = 2,
		Parent = e,
	})
	return n(self, b, {
		Set = function(b, a)
			f.Text = a
		end,
	}, e, "Paragraph")
end
function j:Button(d)
	d = l(d, { Title = "Name", Description = "Desc" })
	local e = d.Style == "Primary"
	local h = d.Desc and v or K
	local c, f = B(self, "TextButton", h, d)
	c.ClipsDescendants = true
	if e then
		c.BackgroundColor3 = a.Accent
		c.BackgroundTransparency = 0.12
		f.Color = a.Accent
		f.Transparency = 0.4
		c.MouseEnter:Connect(function()
			b(c, { BackgroundTransparency = 0 }, 0.12)
			b(f, { Transparency = 0 }, 0.12)
		end)
		c.MouseLeave:Connect(function()
			b(c, { BackgroundTransparency = 0.12 }, 0.25)
			b(f, { Transparency = 0.4 }, 0.25)
		end)
	else
		F(c, f)
	end
	local i, g = e and a.AccentDark or a.Text, 0
	if d.Icon then
		y(c, d.Icon, e and a.AccentDark or a.Accent, UDim2.new(0, 14, 0.5, 0))
		g = 26
	end
	local j = G(c, d.Name or "Button", d.Desc, 30)
	if g > 0 then
		for b, a in ipairs(c:GetChildren()) do
			if a:IsA("TextLabel") then
				a.Position += UDim2.fromOffset(g, 0)
				a.Size -= UDim2.fromOffset(g, 0)
			end
		end
	end
	if e then
		for b, a in ipairs(c:GetChildren()) do
			if a:IsA("TextLabel") then
				a.TextColor3 = i
			end
		end
	end
	y(c, "chevron-right", e and a.AccentDark or a.Muted, UDim2.new(1, -30, 0.5, 0))
	c.MouseButton1Click:Connect(function()
		ah(c)
		k(d.Callback)
	end)
	return n(self, d, {
		SetText = function(b, a)
			j.Text = a
		end,
	}, c, "Button")
end
function j:Toggle(f)
	local i, o
	f, i, o = z(
		self,
		f,
		{ Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default" },
		"TextButton",
		56,
		"Toggle"
	)
	local g = c("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = m and UDim2.fromOffset(44, 24) or UDim2.fromOffset(36, 20),
		BackgroundColor3 = a.Surface3,
		BorderSizePixel = 0,
		Parent = i,
	})
	e(g, UDim.new(1, 0))
	h(g, a.Stroke)
	local j = c("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = m and UDim2.fromOffset(18, 18) or UDim2.fromOffset(14, 14),
		BackgroundColor3 = a.Muted,
		BorderSizePixel = 0,
		Parent = g,
	})
	e(j, UDim.new(1, 0))
	local q = c("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 24, 1, 24),
		BackgroundTransparency = 1,
		Image = t.Glow,
		ImageColor3 = a.Accent,
		ImageTransparency = 1,
		ZIndex = 0,
		Parent = g,
	})
	local d = { Value = f.Default == true }
	local function p(h)
		local e = d.Value
		local f = h and 0.25 or 0
		b(g, { BackgroundColor3 = e and a.Accent or a.Surface3 }, f)
		b(q, { ImageTransparency = e and 0.75 or 1 }, f)
		local c = m and 18 or 14
		b(j, {
			Position = e and UDim2.new(0, (m and 44 or 36) - 3 - c, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
			BackgroundColor3 = e and a.AccentDark or a.Muted,
		}, f, Enum.EasingStyle.Back)
		if h then
			b(j, { Size = UDim2.fromOffset(c + 4, c - 2) }, 0.08)
			task.delay(0.08, function()
				b(j, { Size = UDim2.fromOffset(c, c) }, 0.2, Enum.EasingStyle.Back)
			end)
		end
	end
	local l = false
	function d:Set(a, b)
		a = a == true
		if a == d.Value then
			return
		end
		d.Value = a
		p(true)
		if not l then
			w(o)
		end
		if not b then
			k(f.Callback, a)
		end
	end
	function d:Get()
		return d.Value
	end
	p(false)
	i.MouseButton1Click:Connect(function()
		l = true
		d:Set(not d.Value)
		l = false
	end)
	local r = n(self, f, d, i, "Toggle")
	if d.Value then
		k(f.Callback, true)
	end
	return r
end
function j:Slider(g)
	local C = "Frame"
	g = l(g, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default", Increment = "Step" })
	local o = g.Min or 0
	local D = g.Max or 100
	local V = g.Step or 1
	local I = g.Suffix or ""
	local J = aa(o, D, V)
	local y, Q = B(self, C, v, g)
	F(y, Q)
	d({ Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -120, 0, 18), Text = g.Name or "Slider", Parent = y })
	local q = c(C, {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 9),
		Size = UDim2.fromOffset(40, 24),
		BackgroundColor3 = a.Surface,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = y,
	})
	e(q, UDim.new(0, 6))
	local K = h(q)
	local z = d({
		Size = UDim2.new(1, 0, 1, 0),
		TextSize = 13,
		TextColor3 = a.Accent,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.None,
		Parent = q,
	})
	local j = c("TextBox", {
		Position = UDim2.fromOffset(9, 0),
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = a.Text,
		TextSize = 13,
		FontFace = i.Medium,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Visible = false,
		Parent = q,
	})
	c("UISizeConstraint", { MinSize = Vector2.new(14, 0), Parent = j })
	local L = d({
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = I,
		TextSize = 13,
		TextColor3 = a.Accent,
		TextTruncate = Enum.TextTruncate.None,
		Visible = false,
		Parent = q,
	})
	local E, G =
		c("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 2,
			Parent = q,
		}), false
	local function H(c)
		local a
		if G then
			a = 9 + j.AbsoluteSize.X / self.Window.Scale.Scale + L.TextBounds.X + 9
			L.Position = UDim2.fromOffset(9 + j.AbsoluteSize.X / self.Window.Scale.Scale, 0)
		else
			a = z.TextBounds.X + 18
		end
		a = math.max(a, 36)
		if c then
			q.Size = UDim2.fromOffset(a, 24)
		else
			b(q, { Size = UDim2.fromOffset(a, 24) }, 0.2)
		end
	end
	z:GetPropertyChangedSignal("TextBounds"):Connect(function()
		if not G then
			H(false)
		end
	end)
	j:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if G then
			H(false)
		end
	end)
	local u = c(C, {
		Position = UDim2.new(0, 14, 0, v - 18),
		Size = UDim2.new(1, -28, 0, 5),
		BackgroundColor3 = a.Surface3,
		BorderSizePixel = 0,
		Parent = y,
	})
	e(u, UDim.new(1, 0))
	local R = c(C, { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = a.Accent, BorderSizePixel = 0, Parent = u })
	e(R, UDim.new(1, 0))
	local x = c("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		Image = t.Glow,
		ImageColor3 = a.Accent,
		ImageTransparency = 0.85,
		ZIndex = 2,
		Parent = u,
	})
	local A = c(C, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = a.Accent,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = u,
	})
	e(A, UDim.new(1, 0))
	local O = c("TextButton", {
		Position = UDim2.new(0, 8, 0, v - (m and 37 or 31)),
		Size = UDim2.new(1, -16, 0, m and 40 or 28),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 4,
		Parent = y,
	})
	local f, s = { Value = math.clamp(g.Default or o, o, D) }, false
	E.MouseEnter:Connect(function()
		b(K, { Color = a.StrokeHover }, 0.12)
	end)
	E.MouseLeave:Connect(function()
		if not j:IsFocused() then
			b(K, { Color = a.Stroke }, 0.2)
		end
	end)
	E.MouseButton1Click:Connect(function()
		G = true
		j.Text = J.format(f.Value)
		z.Visible = false
		j.Visible = true
		L.Visible = I ~= ""
		E.Visible = false
		b(K, { Color = a.StrokeHover }, 0.12)
		j:CaptureFocus()
		task.defer(H, false)
	end)
	j.FocusLost:Connect(function()
		local c = tonumber(j.Text)
		G = false
		j.Visible = false
		L.Visible = false
		z.Visible = true
		E.Visible = true
		b(K, { Color = a.Stroke }, 0.2)
		if c then
			f:Set(c)
		end
		H(false)
	end)
	O.MouseEnter:Connect(function()
		if not s then
			b(x, { ImageTransparency = 0.78, Size = UDim2.fromOffset(34, 34) }, 0.15)
		end
	end)
	O.MouseLeave:Connect(function()
		if not s then
			b(x, { ImageTransparency = 0.85, Size = UDim2.fromOffset(28, 28) }, 0.2)
		end
	end)
	local S = J.snap
	local function M()
		return D - o == 0 and 0 or (f.Value - o) / (D - o)
	end
	local function P(c, d, a)
		a = a or Enum.EasingStyle.Linear
		b(R, { Size = UDim2.new(c, 0, 1, 0) }, d, a)
		b(A, { Position = UDim2.new(c, 0, 0.5, 0) }, d, a)
		b(x, { Position = UDim2.new(c, 0, 0.5, 0) }, d, a)
	end
	local function T(a, b)
		P(M(), a, b)
		z.Text = J.format(f.Value) .. I
	end
	local function W(b)
		local a = M()
		local c = math.max(u.AbsoluteSize.X, 1)
		local d = (a >= b and 1 or -1) * (5 / c)
		P(math.clamp(a + d, 0, 1), 0.22, Enum.EasingStyle.Quint)
		task.delay(0.22, function()
			if not s then
				P(M(), 0.18, Enum.EasingStyle.Quint)
			end
		end)
		z.Text = J.format(f.Value) .. I
	end
	local function X()
		b(A, { Size = UDim2.fromOffset(14, 12) }, 0.08)
		b(x, { Size = UDim2.fromOffset(32, 32), ImageTransparency = 0.78 }, 0.12)
		task.delay(0.1, function()
			b(A, { Size = UDim2.fromOffset(12, 12) }, 0.25, Enum.EasingStyle.Quint)
			b(x, { Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85 }, 0.25)
		end)
	end
	function f:Set(a, b)
		a = S(tonumber(a) or o)
		if a == f.Value then
			return
		end
		local c = M()
		f.Value = a
		if s then
			T(0.05)
		else
			W(c)
			X()
			w(Q)
		end
		if not b then
			k(g.Callback, a)
		end
	end
	function f:Get()
		return f.Value
	end
	local function U(a)
		local b = math.clamp((a - u.AbsolutePosition.X) / u.AbsoluteSize.X, 0, 1)
		f:Set(o + (D - o) * b)
	end
	O.InputBegan:Connect(function(a)
		if p(a) then
			s = true
			b(A, { Size = UDim2.fromOffset(16, 16) }, 0.15, Enum.EasingStyle.Back)
			b(x, { Size = UDim2.fromOffset(44, 44), ImageTransparency = 0.7 }, 0.15)
			U(r().X)
		end
	end)
	self.Window:_listen("Changed", function(a)
		if s and N(a) then
			U(r().X)
		end
	end, f)
	self.Window:_listen("Ended", function(a)
		if s and p(a) then
			s = false
			b(A, { Size = UDim2.fromOffset(12, 12) }, 0.2)
			b(x, { Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85 }, 0.2)
		end
	end, f)
	f.Value = S(f.Value)
	T(0)
	task.defer(H, true)
	return n(self, g, f, y, "Slider")
end
function j:Dropdown(f)
	local y = "Frame"
	f = l(f, {
		Title = "Name",
		Description = "Desc",
		CurrentOption = "Default",
		Value = "Default",
		MultipleOptions = "Multi",
		Values = "Options",
	})
	if f.Multi and type(f.Default) ~= "table" and f.Default ~= nil then
		f.Default = { f.Default }
	elseif not f.Multi and type(f.Default) == "table" then
		f.Default = f.Default[1]
	end
	local r = f.Multi == true
	local o = f.Options or {}
	local p, O, v
	f, p, O, v = z(self, f, {}, y)
	p.ClipsDescendants = true
	local I = c(
		"TextButton",
		{ Size = UDim2.new(1, 0, 0, v), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = p }
	)
	local S, T = G(I, f.Name or "Dropdown", f.Desc, 180)
	local q = c(y, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(60, s),
		BackgroundColor3 = a.Surface,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = I,
	})
	e(q, UDim.new(0, 6))
	local U = h(q)
	local J = d({
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -34, 1, 0),
		TextColor3 = a.Muted,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.None,
		ClipsDescendants = true,
		Parent = q,
	})
	local V = Z(q, 1, -6)
	local A, x =
		d({
			Size = UDim2.fromOffset(0, s),
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 13,
			Visible = false,
			Parent = q,
		}), ""
	local function W()
		A.Text = x
		if A.TextBounds.X <= 146 then
			return x
		end
		local a = x
		while #a > 1 do
			a = a:sub(1, -2)
			A.Text = a .. ".."
			if A.TextBounds.X <= 146 then
				return a .. ".."
			end
		end
		return ".."
	end
	local function P(c)
		local a = math.clamp(J.TextBounds.X + 10 + 34, 60, 190)
		H(S, T, a + 20)
		if c then
			q.Size = UDim2.fromOffset(a, s)
		else
			b(q, { Size = UDim2.fromOffset(a, s) }, 0.2)
		end
	end
	J:GetPropertyChangedSignal("TextBounds"):Connect(function()
		P(false)
	end)
	local K = c(
		y,
		{ Position = UDim2.new(0, 10, 0, v), Size = UDim2.new(1, -20, 0, 0), BackgroundTransparency = 1, Parent = p }
	)
	c("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = K })
	local g = { Open = false }
	local j = {}
	local m, B = {}, ""
	local X = f.SearchAfter or 6
	local t = c(y, {
		Size = UDim2.new(1, 0, 0, L),
		BackgroundColor3 = a.Surface,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 0,
		Visible = false,
		Parent = K,
	})
	e(t, UDim.new(0, 6))
	local Y = h(t, a.Stroke, 1)
	local C = c("TextBox", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -20, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Search",
		PlaceholderColor3 = a.Muted,
		TextColor3 = a.Text,
		TextSize = 13,
		FontFace = i.Regular,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		TextTransparency = 1,
		Parent = t,
	})
	local function Q(a)
		return B == "" or string.find(string.lower(tostring(a)), B, 1, true) ~= nil
	end
	if r then
		for b, a in ipairs(f.Default or {}) do
			j[a] = true
		end
	elseif f.Default ~= nil then
		j[f.Default] = true
	end
	local function D()
		if r then
			local a = {}
			for c, b in ipairs(o) do
				if j[b] then
					table.insert(a, b)
				end
			end
			return a
		end
		for b, a in ipairs(o) do
			if j[a] then
				return a
			end
		end
		return nil
	end
	local function E()
		local c = D()
		if r then
			x = #c > 0 and table.concat(c, ", ") or "None"
		else
			x = c ~= nil and tostring(c) or "None"
		end
		J.Text = W()
		for e, d in pairs(m) do
			local c = j[e] == true
			if d.On ~= c then
				d.On = c
				b(d.Label, { TextColor3 = c and a.Text or a.Muted }, 0.15)
				if g.Open then
					b(d.Check, { ImageTransparency = c and 0 or 1 }, 0.15)
					b(
						d.CheckScale,
						{ Scale = c and 1 or 0.6 },
						c and 0.3 or 0.15,
						c and Enum.EasingStyle.Back or Enum.EasingStyle.Quint
					)
				end
			end
		end
	end
	local function aa()
		local a = 0
		for c, b in ipairs(o) do
			if Q(b) then
				a += 1
			end
		end
		return a
	end
	local function M()
		for a, b in pairs(m) do
			b.Frame.Visible = Q(a)
		end
	end
	local function N()
		local a = aa() + (t.Visible and 1 or 0)
		return v + a * (L + 4) + 8
	end
	local function F(c)
		g.Open = c
		t.Visible = #o > X
		if not c then
			B = ""
			C.Text = ""
			M()
		end
		b(p, { Size = UDim2.new(1, 0, 0, c and N() or v) }, 0.3, Enum.EasingStyle.Quint)
		b(t, { BackgroundTransparency = c and 0 or 1 }, 0.2)
		b(Y, { Transparency = c and 0 or 1 }, 0.2)
		b(C, { TextTransparency = c and 0 or 1 }, 0.2)
		V:Set(c)
		b(U, { Color = c and a.StrokeHover or a.Stroke }, 0.2)
		local function d(d)
			if not d.Stroke then
				d.Stroke = h(d.Frame, a.Stroke, 1)
			end
			local e = c and d.On
			b(d.Check, { ImageTransparency = e and 0 or 1 }, 0.18)
			d.CheckScale.Scale = e and 1 or 0.6
			b(d.Label, { TextTransparency = c and 0 or 1 }, 0.18)
			b(d.Stroke, { Transparency = c and 0 or 1 }, 0.18)
			b(d.Frame, { BackgroundTransparency = c and 0 or 1 }, 0.18)
		end
		if c then
			local a = (g._openGeneration or 0) + 1
			g._openGeneration = a
			task.spawn(function()
				local b = true
				for f, e in ipairs(o) do
					local c = m[e]
					if c and c.Frame.Visible then
						if not b then
							task.wait(0.025)
							if g._openGeneration ~= a or not g.Open then
								return
							end
						end
						b = false
						d(c)
					end
				end
			end)
		else
			local b = (g._openGeneration or 0) + 1
			g._openGeneration = b
			local a = {}
			for d, c in ipairs(o) do
				local b = m[c]
				if b and b.Frame.Visible then
					table.insert(a, b)
				end
			end
			task.spawn(function()
				for c = #a, 1, -1 do
					d(a[c])
					if c > 1 then
						task.wait(0.015)
						if g._openGeneration ~= b or g.Open then
							return
						end
					end
				end
			end)
		end
	end
	local function R()
		local h = {}
		for a, b in ipairs(o) do
			h[b] = a
		end
		for a, b in pairs(m) do
			if not h[a] then
				b.Frame:Destroy()
				m[a] = nil
			end
		end
		for n, g in ipairs(o) do
			local o = m[g]
			if o then
				o.Frame.LayoutOrder = n
				continue
			end
			local h = c("TextButton", {
				Size = UDim2.new(1, 0, 0, L),
				BackgroundColor3 = a.Surface,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = n,
				Parent = K,
			})
			e(h, UDim.new(0, 6))
			local i = c("ImageLabel", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				BackgroundTransparency = 1,
				ImageColor3 = a.Accent,
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Parent = h,
			})
			u(i, "check")
			local p = c("UIScale", { Scale = 0.6, Parent = i })
			local l = d({
				Position = UDim2.fromOffset(12, -1),
				Size = UDim2.new(1, -36, 1, 0),
				Text = tostring(g),
				TextSize = 13,
				TextColor3 = a.Muted,
				TextTransparency = 1,
				Parent = h,
			})
			h.MouseEnter:Connect(function()
				b(l, { TextColor3 = a.Text }, 0.15)
				local c = m[g]
				if c and c.Stroke then
					b(c.Stroke, { Color = a.StrokeHover }, 0.12)
				end
			end)
			h.MouseLeave:Connect(function()
				b(l, { TextColor3 = j[g] and a.Text or a.Muted }, 0.2)
				local c = m[g]
				if c and c.Stroke then
					b(c.Stroke, { Color = a.Stroke }, 0.2)
				end
			end)
			h.MouseButton1Click:Connect(function()
				if j[g] then
					j[g] = nil
				else
					if not r then
						j = {}
					end
					j[g] = true
				end
				E()
				k(f.Callback, D())
				if not r and j[g] then
					F(false)
				end
			end)
			m[g] = { Frame = h, Label = l, Check = i, CheckScale = p, Stroke = nil, On = nil }
		end
		M()
		if g.Open then
			p.Size = UDim2.new(1, 0, 0, N())
		end
	end
	function g:Set(a, b)
		j = {}
		if r then
			for b, a in ipairs(type(a) == "table" and a or { a }) do
				j[a] = true
			end
		elseif a ~= nil then
			j[a] = true
		end
		E()
		w(O)
		if not b then
			k(f.Callback, D())
		end
	end
	function g:Get()
		return D()
	end
	function g:Refresh(a, b)
		o = a or {}
		if not b then
			j = {}
		end
		R()
		E()
		if g.Open then
			F(true)
		end
	end
	function g:SetOpen(a)
		F(a == true)
	end
	I.MouseButton1Click:Connect(function()
		F(not g.Open)
	end)
	C:GetPropertyChangedSignal("Text"):Connect(function()
		B = string.lower(C.Text)
		M()
		if g.Open then
			b(p, { Size = UDim2.new(1, 0, 0, N()) }, 0.2, Enum.EasingStyle.Quint)
		end
	end)
	R()
	E()
	task.defer(P, true)
	return n(self, f, g, p, "Dropdown")
end
function j:Input(f)
	local l, p, t, q, r
	f, l, p, t, q, r = z(self, f, {
		Title = "Name",
		Description = "Desc",
		PlaceholderText = "Placeholder",
		CurrentValue = "Default",
		Value = "Default",
	}, "Frame", 160, "Input")
	local g = c("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(170, 30),
		BackgroundColor3 = a.Surface,
		BorderSizePixel = 0,
		Parent = l,
	})
	e(g, UDim.new(0, 6))
	local s = h(g)
	local m = f.Icon
	if m then
		y(g, m, a.Muted, UDim2.new(0, 8, 0.5, 0))
	end
	local d = c("TextBox", {
		Position = UDim2.fromOffset(m and 30 or 8, 0),
		Size = UDim2.new(1, m and -38 or -16, 1, 0),
		BackgroundTransparency = 1,
		Text = f.Default or "",
		PlaceholderText = f.Placeholder or "",
		PlaceholderColor3 = a.Muted,
		TextColor3 = a.Text,
		TextSize = 14,
		FontFace = i.Regular,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		TextTruncate = Enum.TextTruncate.None,
		ClipsDescendants = true,
		Parent = g,
	})
	g.ClipsDescendants = true
	local o = false
	local u = (m and 30 or 8) + 8
	local function j(f)
		local h = l.AbsoluteSize.X / self.Window.Scale.Scale
		local c = math.clamp(h - 14 - 110 - 20, 100, 200)
		local i = d.Text
		local e = d.TextBounds.X
		if #i == 0 then
			e = math.min(d.TextBounds.X, 90)
		end
		local a = math.clamp(e + u + 12, 90, c) + (o and 8 or 0)
		a = math.min(a, c + 8)
		H(q, r, a + 20)
		if f then
			g.Size = UDim2.fromOffset(a, 30)
		else
			b(g, { Size = UDim2.fromOffset(a, 30) }, 0.18)
		end
	end
	l:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		j(true)
	end)
	d:GetPropertyChangedSignal("Text"):Connect(function()
		j(false)
	end)
	d:GetPropertyChangedSignal("TextBounds"):Connect(function()
		j(false)
	end)
	task.defer(j, true)
	d.Focused:Connect(function()
		o = true
		b(s, { Color = a.StrokeHover }, 0.15)
		j(false)
	end)
	d.FocusLost:Connect(function(c)
		o = false
		b(s, { Color = a.Stroke }, 0.15)
		j(false)
		if f.Numeric then
			local a = tonumber(d.Text)
			if not a then
				d.Text = ""
				return
			end
		end
		k(f.Callback, d.Text, c)
	end)
	return n(self, f, {
		Set = function(b, a)
			d.Text = tostring(a)
			w(p)
		end,
		Get = function()
			return d.Text
		end,
	}, l, "Input")
end
function j:Keybind(g)
	local o, p, u, q, r
	g, o, p, u, q, r = z(
		self,
		g,
		{ Title = "Name", Description = "Desc", CurrentKeybind = "Default", Value = "Default" },
		"Frame",
		110,
		"Keybind"
	)
	if type(g.Default) == "string" then
		g.Default = Enum.KeyCode[g.Default]
	end
	local i = c("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(44, s),
		BackgroundColor3 = a.Surface,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ClipsDescendants = true,
		Parent = o,
	})
	e(i, UDim.new(0, 6))
	local v = h(i)
	local j = d({
		Size = UDim2.new(1, 0, 1, 0),
		TextSize = 13,
		TextColor3 = a.Muted,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.None,
		Parent = i,
	})
	local f = { Value = g.Default, Listening = false }
	local function t(c)
		local a = math.max(j.TextBounds.X + 20, m and 44 or 36)
		H(q, r, a + 20)
		if c then
			i.Size = UDim2.fromOffset(a, s)
		else
			b(i, { Size = UDim2.fromOffset(a, s) }, 0.2)
		end
	end
	j:GetPropertyChangedSignal("TextBounds"):Connect(function()
		t(false)
	end)
	local function l()
		j.Text = f.Listening and "..." or P(f.Value)
		b(v, { Color = f.Listening and a.StrokeHover or a.Stroke }, 0.15)
		b(j, { TextColor3 = f.Listening and a.Accent or a.Muted }, 0.15)
	end
	function f:Set(a, b)
		local c = f.Listening
		f.Value = a
		f.Listening = false
		l()
		if not c then
			w(p)
		end
		if not b then
			k(g.OnChanged, a)
		end
	end
	i.MouseButton1Click:Connect(function()
		f.Listening = not f.Listening
		l()
	end)
	self.Window:_listen("Began", function(a, b)
		if a.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		if f.Listening then
			self.Window._consumedKey = a.KeyCode
			self.Window._consumedAt = os.clock()
			if a.KeyCode == Enum.KeyCode.Escape then
				f.Listening = false
				l()
			else
				f:Set(a.KeyCode)
			end
			return
		end
		if not b and f.Value ~= nil and a.KeyCode == f.Value then
			k(g.Callback, a.KeyCode)
		end
	end, f)
	l()
	task.defer(t, true)
	function f:Get()
		return f.Value
	end
	return n(self, g, f, o, "Keybind")
end
function j:ColorPicker(j)
	local D, l, E, F = "Default", "Frame", "TextButton", "UIGradient"
	local m, K, u
	j, m, K, u = z(self, j, { Title = "Name", Description = "Desc", Color = D, CurrentValue = D, Value = D }, l)
	m.ClipsDescendants = true
	local A = c(
		E,
		{ Size = UDim2.new(1, 0, 0, u), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = m }
	)
	G(A, j.Name or "Color", j.Desc, 90)
	local H = c(l, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -34, 0.5, 0),
		Size = UDim2.fromOffset(36, 20),
		BorderSizePixel = 0,
		Parent = A,
	})
	e(H, UDim.new(0, 6))
	h(H, a.Stroke)
	local S = Z(A, 1, -12)
	local o = c(l, {
		Position = UDim2.fromOffset(14, u + 2),
		Size = UDim2.new(1, -28, 0, 156),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = m,
	})
	local g = c(E, {
		Size = UDim2.new(1, -30, 0, 110),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ClipsDescendants = true,
		Parent = o,
	})
	e(g, UDim.new(0, 6))
	local T = c(F, { Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 0, 0)), Parent = g })
	local U =
		c(l, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = g })
	c(F, {
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
		Rotation = 90,
		Parent = U,
	})
	local v = c(l, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundTransparency = 1,
		ZIndex = 3,
		Parent = g,
	})
	e(v, UDim.new(1, 0))
	h(v, Color3.new(1, 1, 1), 0, 2)
	local q = c(E, {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.fromOffset(14, 110),
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = o,
	})
	e(q, UDim.new(0, 6))
	c(F, {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.16666666666666666, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.3333333333333333, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.6666666666666666, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.8333333333333334, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		}),
		Rotation = 90,
		Parent = q,
	})
	local x = c(l, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.fromOffset(18, 5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = q,
	})
	e(x, UDim.new(1, 0))
	h(x, a.AccentDark, 0.4)
	local I = c(l, {
		Position = UDim2.fromOffset(6, 122),
		Size = UDim2.fromOffset(118, 28),
		BackgroundColor3 = a.Surface,
		BorderSizePixel = 0,
		Parent = o,
	})
	e(I, UDim.new(0, 6))
	local L = h(I)
	local s = c("TextBox", {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -24, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		TextTruncate = Enum.TextTruncate.None,
		ClipsDescendants = false,
		TextColor3 = a.Text,
		TextSize = 13,
		FontFace = i.Regular,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = I,
	})
	local V = d({
		Position = UDim2.fromOffset(134, 122),
		Size = UDim2.new(1, -134, 0, 28),
		TextXAlignment = Enum.TextXAlignment.Right,
		TextSize = 13,
		FontFace = i.Regular,
		TextColor3 = a.Muted,
		Parent = o,
	})
	local f = { Open = false }
	local y, B, C = Color3.toHSV(j.Default or a.Accent)
	local t
	local function M(a)
		return string.format(
			"#%02X%02X%02X",
			math.floor(a.R * 255 + 0.5),
			math.floor(a.G * 255 + 0.5),
			math.floor(a.B * 255 + 0.5)
		)
	end
	local function O(c)
		local a = Color3.fromHSV(y, B, C)
		f.Value = a
		H.BackgroundColor3 = a
		T.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(y, 1, 1))
		b(v, { Position = UDim2.fromScale(B, 1 - C) }, c, Enum.EasingStyle.Linear)
		b(x, { Position = UDim2.new(0.5, 0, y, 0) }, c, Enum.EasingStyle.Linear)
		if not s:IsFocused() then
			s.Text = M(a)
		end
		V.Text = string.format(
			"RGB %d, %d, %d",
			math.floor(a.R * 255 + 0.5),
			math.floor(a.G * 255 + 0.5),
			math.floor(a.B * 255 + 0.5)
		)
	end
	local function J(a, b)
		O(a)
		if not b then
			k(j.Callback, f.Value)
		end
	end
	function f:Set(a, b)
		y, B, C = Color3.toHSV(a)
		J(0.25, b)
		w(K)
	end
	function f:Get()
		return f.Value
	end
	local function P(a)
		f.Open = a
		b(m, { Size = UDim2.new(1, 0, 0, a and u + 168 or u) }, 0.35, Enum.EasingStyle.Quint)
		S:Set(a)
		if a then
			o.Visible = true
		else
			task.delay(0.35, function()
				if not f.Open then
					o.Visible = false
				end
			end)
		end
	end
	function f:SetOpen(a)
		P(a == true)
	end
	A.MouseButton1Click:Connect(function()
		P(not f.Open)
	end)
	local function Q(a)
		B = math.clamp((a.X - g.AbsolutePosition.X) / g.AbsoluteSize.X, 0, 1)
		C = 1 - math.clamp((a.Y - g.AbsolutePosition.Y) / g.AbsoluteSize.Y, 0, 1)
		J(0.04)
	end
	local function R(a)
		y = math.clamp((a.Y - q.AbsolutePosition.Y) / q.AbsoluteSize.Y, 0, 0.999)
		J(0.04)
	end
	g.InputBegan:Connect(function(a)
		if p(a) then
			t = "sv"
			b(v, { Size = UDim2.fromOffset(14, 14) }, 0.15, Enum.EasingStyle.Back)
			Q(r())
		end
	end)
	q.InputBegan:Connect(function(a)
		if p(a) then
			t = "hue"
			b(x, { Size = UDim2.fromOffset(20, 7) }, 0.15, Enum.EasingStyle.Back)
			R(r())
		end
	end)
	self.Window:_listen("Changed", function(b)
		if not t or not N(b) then
			return
		end
		local a = r()
		if t == "sv" then
			Q(a)
		else
			R(a)
		end
	end, f)
	self.Window:_listen("Ended", function(a)
		if t and p(a) then
			t = nil
			b(v, { Size = UDim2.fromOffset(10, 10) }, 0.2)
			b(x, { Size = UDim2.fromOffset(18, 5) }, 0.2)
		end
	end, f)
	s.Focused:Connect(function()
		b(L, { Color = a.StrokeHover }, 0.15)
	end)
	s.FocusLost:Connect(function()
		b(L, { Color = a.Stroke }, 0.15)
		local c, d, e = s.Text:match("^%s*#?(%x%x)(%x%x)(%x%x)%s*$")
		if c then
			f:Set(Color3.fromRGB(tonumber(c, 16), tonumber(d, 16), tonumber(e, 16)))
		else
			s.Text = M(f.Value)
		end
	end)
	O(0)
	return n(self, j, f, m, "ColorPicker")
end
function j:Stepper(g)
	local o, t, J, u, v
	g, o, t, J, u, v = z(
		self,
		g,
		{ Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default", Increment = "Step" },
		"Frame",
		150,
		"Stepper"
	)
	local l = g.Min or 0
	local q = g.Max or 100
	local x = g.Step or 1
	local K = g.Suffix or ""
	local y = aa(l, q, x)
	local j = c("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(0, s),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = a.Surface,
		BorderSizePixel = 0,
		Parent = o,
	})
	e(j, UDim.new(0, 6))
	local A = h(j)
	c("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Parent = j,
	})
	local function B(e, f)
		local d = c("TextButton", {
			Size = UDim2.fromOffset(s, s),
			BackgroundTransparency = 1,
			Text = e,
			TextColor3 = a.Muted,
			TextSize = 18,
			FontFace = i.Medium,
			AutoButtonColor = false,
			LayoutOrder = f,
			Parent = j,
		})
		d.MouseEnter:Connect(function()
			b(d, { TextColor3 = a.Accent }, 0.12)
		end)
		d.MouseLeave:Connect(function()
			b(d, { TextColor3 = a.Muted }, 0.2)
		end)
		return d
	end
	local C = B("−", 1)
	local m = d({
		Size = UDim2.new(0, 30, 1, 0),
		TextSize = 13,
		TextColor3 = a.Accent,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.None,
		LayoutOrder = 2,
		Parent = j,
	})
	local D = B("+", 3)
	local function E(c)
		local a = math.max(m.TextBounds.X + 12, 30)
		if c then
			m.Size = UDim2.new(0, a, 1, 0)
		else
			b(m, { Size = UDim2.new(0, a, 1, 0) }, 0.2)
		end
	end
	m:GetPropertyChangedSignal("TextBounds"):Connect(function()
		E(false)
	end)
	j:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		H(u, v, j.AbsoluteSize.X / self.Window.Scale.Scale + 20)
	end)
	local f = { Value = math.clamp(g.Default or l, l, q) }
	local L, r = y.snap, false
	local function F()
		m.Text = y.format(f.Value) .. K
		b(C, { TextTransparency = f.Value <= l and 0.6 or 0 }, 0.15)
		b(D, { TextTransparency = f.Value >= q and 0.6 or 0 }, 0.15)
	end
	function f:Set(a, b)
		a = L(tonumber(a) or l)
		if a == f.Value then
			return
		end
		f.Value = a
		F()
		if not r then
			w(t)
		end
		if not b then
			k(g.Callback, a)
		end
	end
	function f:Get()
		return f.Value
	end
	local function G(c)
		r = true
		f:Set(f.Value + c * x)
		r = false
		b(A, { Color = a.StrokeHover }, 0.08)
		task.delay(0.12, function()
			b(A, { Color = a.Stroke }, 0.2)
		end)
	end
	local function I(b, c)
		local a = false
		b.InputBegan:Connect(function(b)
			if not p(b) then
				return
			end
			a = true
			G(c)
			task.delay(0.4, function()
				while a do
					G(c)
					task.wait(0.07)
				end
			end)
		end)
		b.InputEnded:Connect(function(b)
			if p(b) then
				a = false
			end
		end)
		b.MouseLeave:Connect(function()
			a = false
		end)
	end
	I(C, -1)
	I(D, 1)
	F()
	task.defer(E, true)
	return n(self, g, f, o, "Stepper")
end
function j:Progress(f)
	f = l(f, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default" })
	local h, s = B(self, "Frame", f.Desc and v + 10 or K + 10, f)
	F(h, s)
	local j = f.Desc and (v - 38) / 2 - 2 or 12
	d({ Position = UDim2.fromOffset(14, j), Size = UDim2.new(1, -110, 0, 18), Text = f.Name or "Progress", Parent = h })
	if f.Desc then
		d({
			Position = UDim2.fromOffset(14, j + 20),
			Size = UDim2.new(1, -110, 0, 17),
			Text = f.Desc,
			TextSize = 13,
			FontFace = i.Regular,
			TextColor3 = a.Muted,
			Parent = h,
		})
	end
	local o = d({
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, j),
		Size = UDim2.fromOffset(90, 18),
		TextXAlignment = Enum.TextXAlignment.Right,
		TextSize = 13,
		TextColor3 = a.Accent,
		Parent = h,
	})
	local p = c("Frame", {
		Position = UDim2.new(0, 14, 1, -16),
		Size = UDim2.new(1, -28, 0, 5),
		BackgroundColor3 = a.Surface3,
		BorderSizePixel = 0,
		Parent = h,
	})
	e(p, UDim.new(1, 0))
	local m = c(
		"Frame",
		{ Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = f.Color or a.Accent, BorderSizePixel = 0, Parent = p }
	)
	e(m, UDim.new(1, 0))
	local g = { Value = math.clamp(f.Default or 0, 0, 1) }
	local q = f.Format
	local function r(c)
		local a = g.Value
		b(m, { Size = UDim2.new(a, 0, 1, 0) }, c, Enum.EasingStyle.Quint)
		if type(q) == "function" then
			o.Text = tostring(q(a))
		else
			o.Text = string.format("%d%%", math.floor(a * 100 + 0.5))
		end
	end
	function g:Set(a, b)
		a = math.clamp(tonumber(a) or 0, 0, 1)
		if a == g.Value then
			return
		end
		g.Value = a
		r(0.35)
		if not b then
			k(f.Callback, a)
		end
	end
	function g:Get()
		return g.Value
	end
	function g:SetColor(a)
		m.BackgroundColor3 = a
	end
	r(0)
	return n(self, f, g, h, "Progress")
end
function j:ConfigManager(d)
	d = l(d, {})
	local a = self.Window
	local b = {}
	self:Section(d.Name or "Configs")
	local e = self:Input({
		Name = "Config name",
		Placeholder = a.ConfigName,
		Callback = function(a, c)
			if c and #a > 0 then
				b:Save(a)
			end
		end,
	})
	local c = self:Dropdown({
		Name = "Saved configs",
		Options = a:ListConfigs(),
		Default = a.ConfigName,
		Callback = function(a)
			if a then
				e:Set(a)
			end
		end,
	})
	function b:Refresh()
		c:Refresh(a:ListConfigs(), true)
	end
	function b:Save(d)
		d = d or c:Get() or a.ConfigName
		local e, f = a:SaveConfig(d)
		b:Refresh()
		c:Set(d, true)
		a:Notify({
			Title = e and "Config saved" or "Save failed",
			Content = e and d or tostring(f),
			Type = e and "Success" or "Error",
			Duration = 3,
		})
	end
	function b:Load(b)
		b = b or c:Get()
		if not b then
			return
		end
		local d, e = a:LoadConfig(b)
		a:Notify({
			Title = d and "Config loaded" or "Load failed",
			Content = d and b or tostring(e),
			Type = d and "Success" or "Error",
			Duration = 3,
		})
	end
	function b:Delete(d)
		d = d or c:Get()
		if not d then
			return
		end
		local e, f = a:DeleteConfig(d)
		b:Refresh()
		a:Notify({
			Title = e and "Config deleted" or "Delete failed",
			Content = e and d or tostring(f),
			Type = e and "Info" or "Error",
			Duration = 3,
		})
	end
	self:Button({
		Name = "Save",
		Desc = "Writes every flagged element to the selected name",
		Icon = "save",
		Style = "Primary",
		Callback = function()
			local a = e:Get()
			b:Save(#a > 0 and a or nil)
		end,
	})
	self:Button({
		Name = "Load",
		Icon = "folder-open",
		Callback = function()
			b:Load()
		end,
	})
	self:Button({
		Name = "Delete",
		Icon = "trash-2",
		Callback = function()
			local d = c:Get()
			if not d then
				return
			end
			a:Confirm({
				Title = "Delete config",
				Content = "Remove " .. d .. "? This cannot be undone.",
				Icon = "trash-2",
				ConfirmText = "Delete",
				Callback = function()
					b:Delete(d)
				end,
			})
		end,
	})
	self:Toggle({
		Name = "Auto save",
		Desc = "Save whenever a flagged element changes",
		Default = a._autoSaveEnabled,
		Callback = function(b)
			a._autoSaveEnabled = b
		end,
	})
	return b
end
for a, b in pairs(table.clone(j)) do
	if type(b) == "function" and a:sub(1, 1) ~= "_" and a:sub(1, 6) ~= "Create" then
		j["Create" .. a] = b
	end
end
local function aj()
	local a
	pcall(function()
		if typeof(identifyexecutor) == "function" then
			a = (identifyexecutor())
		elseif typeof(getexecutorname) == "function" then
			a = getexecutorname()
		end
	end)
	if type(a) == "string" and #a > 0 then
		return a
	end
	return U:IsStudio() and "Studio" or "Unknown"
end
local function ak()
	local b, a = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	end)
	if b and type(a) == "table" and a.Name then
		return a.Name
	end
	return "Unknown game"
end
local al = {
	US = "United States",
	GB = "United Kingdom",
	DE = "Germany",
	FR = "France",
	NL = "Netherlands",
	SG = "Singapore",
	JP = "Japan",
	AU = "Australia",
	BR = "Brazil",
	IN = "India",
	HK = "Hong Kong",
	CA = "Canada",
}
local function am(a)
	task.spawn(function()
		local b = request or http_request or syn and syn.request or http and http.request
		local c
		if type(b) == "function" then
			pcall(function()
				local a = b({ Url = "https://ipinfo.io/json", Method = "GET" })
				local d = type(a) == "table" and (a.Body or a.body) or nil
				if type(d) == "string" then
					local a = C:JSONDecode(d)
					if type(a) == "table" and a.country then
						local b = al[a.country] or a.country
						c = a.city and a.city .. ", " .. b or b
					end
				end
			end)
		end
		a(c or "Unavailable")
	end)
end
local an = { Success = a.Success, Warning = a.Warning, Error = a.Error }
local g = {}
g.__index = g
function f.Window(ab, k)
	local G, p, H, L, I, A = "AirflowUI", "Frame", "CanvasGroup", "UIListLayout", "AbsoluteSize", "table"
	k = l(k, { Name = "Title", LoadingSubtitle = "Subtitle", ToggleUIKeybind = "Keybind" })
	if type(k.Keybind) == "string" then
		k.Keybind = Enum.KeyCode[k.Keybind]
	end
	local V = k.Size or UDim2.fromOffset(640, 480)
	local N = k.Keybind or Enum.KeyCode.RightControl
	local j = setmetatable({
		Tabs = {},
		CurrentTab = nil,
		Open = true,
		Keybind = N,
		_connections = {},
		_controls = {},
		_inputListeners = { Began = {}, Changed = {}, Ended = {}, Render = {} },
		_frameSteps = {},
		_destroyed = false,
	}, g)
	local function B(a)
		return function(...)
			for b, a in ipairs(j._inputListeners[a]) do
				a(...)
			end
		end
	end
	local W = B("Render")
	table.insert(
		j._connections,
		U.RenderStepped:Connect(function(a)
			W(a)
			for c, b in ipairs(j._frameSteps) do
				b(a)
			end
		end)
	)
	table.insert(j._connections, q.InputBegan:Connect(B("Began")))
	table.insert(j._connections, q.InputChanged:Connect(B("Changed")))
	table.insert(j._connections, q.InputEnded:Connect(B("Ended")))
	local s = c("ScreenGui", {
		Name = k.Name or G,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 999,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	j.Gui = s
	local z = c(p, {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = V,
		BackgroundTransparency = 1,
		Parent = s,
	})
	j.Root = z
	local O = c("UIScale", { Parent = z })
	j.Scale = O
	local Q = c("ImageLabel", {
		Position = UDim2.fromOffset(-25, -25),
		Size = UDim2.new(1, 50, 1, 50),
		BackgroundTransparency = 1,
		Image = t.Shadow,
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		Parent = z,
	})
	j.Shadow = Q
	local n = c(H, {
		Name = "Body",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = a.Background,
		BorderSizePixel = 0,
		Parent = z,
	})
	j.Body = n
	e(n, UDim.new(0, 10))
	j.BodyStroke = h(n, a.Stroke)
	M(n)
	x(n, UDim2.fromOffset(500, 180), UDim2.new(0.5, 0, 1, 8), 0.86, 270)
	x(n, UDim2.fromOffset(130, 60), UDim2.new(0, -10, 1, -10), 0.75, 90)
	x(n, UDim2.fromOffset(520, 240), UDim2.new(1, -14, 0, 10), 0.92, 90)
	local C = c(p, { Name = "Sidebar", Size = UDim2.new(0, 170, 1, 0), BackgroundTransparency = 1, Parent = n })
	c(p, {
		Position = UDim2.new(0, 170, 0, 28),
		Size = UDim2.new(0, 1, 1, -56),
		BackgroundColor3 = a.Stroke,
		BorderSizePixel = 0,
		Parent = n,
	})
	local J = c(p, { Name = "Header", Size = UDim2.new(1, 0, 0, 72), BackgroundTransparency = 1, Parent = C })
	local X = c("ImageLabel", {
		Position = UDim2.fromOffset(22, 27),
		Size = UDim2.fromOffset(30, 28),
		BackgroundTransparency = 1,
		Image = "",
		ImageColor3 = a.Accent,
		ScaleType = Enum.ScaleType.Fit,
		Parent = J,
	})
	u(X, k.Icon or t.Logo)
	d({
		Position = UDim2.fromOffset(60, 25),
		Size = UDim2.new(1, -70, 0, 20),
		Text = k.Title or "Airflow",
		TextSize = 20,
		Parent = J,
	})
	d({
		Position = UDim2.fromOffset(60, 45),
		Size = UDim2.new(1, -70, 0, 14),
		Text = k.Subtitle or "",
		TextSize = 13,
		FontFace = i.Regular,
		TextColor3 = a.Muted,
		Parent = J,
	})
	local v = c("ScrollingFrame", {
		Name = "Tabs",
		Position = UDim2.fromOffset(0, 80),
		Size = UDim2.new(1, 0, 1, -116),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		Parent = C,
	})
	j.TabList = v
	o(v, 16, 16, 4, 4)
	c(L, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = v })
	local D = c(p, {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromOffset(6, 0),
		Size = UDim2.fromOffset(3, 18),
		BackgroundColor3 = a.Accent,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 2,
		Parent = C,
	})
	e(D, UDim.new(1, 0))
	j.Indicator = D
	local R = v.CanvasPosition.Y
	table.insert(j._frameSteps, function()
		local b = v.CanvasPosition.Y
		if b == R or not j.CurrentTab or not j._introDone then
			return
		end
		R = b
		local a = j:_indicatorY(j.CurrentTab)
		local c = v.Position.Y.Offset
		local d = c + v.AbsoluteSize.Y / j.Scale.Scale
		D.Visible = a > c and a < d
		D.Position = UDim2.fromOffset(6, a)
	end)
	local S = c(
		p,
		{ Position = UDim2.new(0, 22, 1, -36), Size = UDim2.new(1, -44, 0, 22), BackgroundTransparency = 1, Parent = C }
	)
	local y = c(p, {
		Size = UDim2.fromOffset(0, 22),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = a.Surface,
		BorderSizePixel = 0,
		Parent = S,
	})
	e(y, UDim.new(0, 5))
	h(y)
	o(y, 7, 7)
	local Y = d({
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = P(N),
		TextSize = 11,
		TextColor3 = a.Muted,
		TextTruncate = Enum.TextTruncate.None,
		Parent = y,
	})
	j._keyChipLabel = Y
	local Z = d({
		Size = UDim2.new(1, 0, 1, 0),
		Text = m and "or tap the pill" or "to hide",
		TextSize = 12,
		FontFace = i.Regular,
		TextColor3 = a.Muted,
		Parent = S,
	})
	local function T()
		Z.Position = UDim2.fromOffset(y.AbsoluteSize.X / j.Scale.Scale + 8, 0)
	end
	y:GetPropertyChangedSignal(I):Connect(T)
	task.defer(T)
	local E = c(p, {
		Name = "Content",
		Position = UDim2.fromOffset(171, 0),
		Size = UDim2.new(1, -171, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = n,
	})
	j.Content = E
	j._outLayer = c(H, {
		Name = "TransitionOut",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 2,
		Parent = E,
	})
	j._inLayer = c(H, {
		Name = "TransitionIn",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 3,
		Parent = E,
	})
	local w = c("TextButton", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, 14),
		Size = UDim2.fromOffset(34, 34),
		BackgroundColor3 = a.Surface2,
		BackgroundTransparency = 1,
		Text = "×",
		TextColor3 = a.Muted,
		TextSize = 28,
		FontFace = i.Bold,
		AutoButtonColor = false,
		ZIndex = 5,
		Parent = E,
	})
	o(w, 0, 0, 1, 0)
	e(w, UDim.new(0, 8))
	w.MouseEnter:Connect(function()
		b(w, { BackgroundTransparency = 0, TextColor3 = a.Text }, 0.15)
	end)
	w.MouseLeave:Connect(function()
		b(w, { BackgroundTransparency = 1, TextColor3 = a.Muted }, 0.2)
	end)
	w.MouseButton1Click:Connect(function()
		j:Toggle(false)
	end)
	local K = c(p, {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -20, 1, -20),
		Size = UDim2.new(0, 280, 1, -40),
		BackgroundTransparency = 1,
		Parent = s,
	})
	local function aa()
		K.Size = UDim2.new(0, math.min(280, s.AbsoluteSize.X - 40), 1, -40)
	end
	table.insert(j._connections, s:GetPropertyChangedSignal(I):Connect(aa))
	c(L, {
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 4),
		Parent = K,
	})
	j.NotifyHolder = K
	j._notifyOrder = 0
	j._toasts = {}
	j.MaxNotifications = k.MaxNotifications or 4
	j._controlsDirty = true
	table.insert(
		j._connections,
		n.DescendantAdded:Connect(function()
			j._controlsDirty = true
		end)
	)
	table.insert(
		j._connections,
		n.DescendantRemoving:Connect(function()
			j._controlsDirty = true
		end)
	)
	j:_enableDrag()
	j.MaxSize = k.MaxSize
	j.KeepOnScreen = k.KeepOnScreen ~= false
	j:_enableResize(k.MinSize or Vector2.new(480, 360))
	local F = k.ConfigurationSaving
	if type(F) == A and F.Enabled ~= false then
		j.ConfigFolder = F.FolderName or G
		j.ConfigName = F.FileName or "default"
		j._autoSaveEnabled = true
	else
		j.ConfigFolder = G
		j.ConfigName = "default"
		j._autoSaveEnabled = false
	end
	table.insert(
		j._connections,
		q.InputBegan:Connect(function(a, b)
			if b then
				return
			end
			if a.UserInputType == Enum.UserInputType.Keyboard and a.KeyCode == j.Keybind then
				task.defer(function()
					local b = j._consumedKey == a.KeyCode and os.clock() - (j._consumedAt or 0) < 0.2
					j._consumedKey = nil
					if not b and not j._destroyed then
						j:Toggle(not j.Open)
					end
				end)
			end
		end)
	)
	pcall(function()
		if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
			syn.protect_gui(s)
		end
	end)
	s.Parent = k.Parent or ag()
	O.Scale = 0.9
	n.GroupTransparency = 1
	Q.ImageTransparency = 1
	j.BodyStroke.Transparency = 1
	z.Visible = false
	j:_fitToScreen(true)
	table.insert(
		j._connections,
		s:GetPropertyChangedSignal(I):Connect(function()
			j:_fitToScreen()
			j:_clampToScreen()
		end)
	)
	if k.OpenButton ~= nil and k.OpenButton ~= false or k.OpenButton == nil and m then
		j:_createOpenButton(type(k.OpenButton) == A and k.OpenButton or {})
	end
	j._introDone = false
	table.insert(f.Windows, j)
	if k.Home then
		j:_buildHome(type(k.Home) == A and k.Home or {})
	end
	local r = k.Loading
	if type(r) == A then
		k.LoadingDuration = r.Duration or k.LoadingDuration
		k.LoadingText = r.Text or r.Subtitle or k.LoadingText
		k.LoadingSteps = r.Steps or k.LoadingSteps
		k.LoadingTitle = r.Title or k.LoadingTitle
		r = r.Enabled ~= false
	end
	if r == false then
		task.defer(function()
			j:_playIntro()
		end)
	else
		j:_showLoader(k)
	end
	return j
end
f.CreateWindow = f.Window
function f:Notify(b)
	local a = f.Windows[#f.Windows]
	if a then
		return a:Notify(b)
	end
end
function f:Confirm(b)
	local a = f.Windows[#f.Windows]
	if a then
		return a:Confirm(b)
	end
end
function f:Dialog(b)
	local a = f.Windows[#f.Windows]
	if a then
		return a:Dialog(b)
	end
end
local function Q(a, c)
	local b, d = c.AbsolutePosition, c.AbsoluteSize
	return a.X >= b.X and a.X <= b.X + d.X and a.Y >= b.Y and a.Y <= b.Y + d.Y
end
local function ao(c, b, d)
	local a = c
	while a and a ~= b and a:IsA("GuiObject") do
		if not a.Visible then
			return false
		end
		local c = a.Parent
		if c and c ~= b and c:IsA("GuiObject") and (c.ClipsDescendants or c:IsA("ScrollingFrame")) and not Q(d, c) then
			return false
		end
		a = c
	end
	return true
end
function g:_refreshControls()
	local a = {}
	for c, b in ipairs(self.Body:GetDescendants()) do
		if b:IsA("GuiButton") or b:IsA("TextBox") or b:GetAttribute("NoDrag") then
			table.insert(a, b)
		end
	end
	self._controls = a
	self._controlsDirty = false
end
function g:_overControl(a)
	if self._dialog then
		return true
	end
	if self._controlsDirty then
		self:_refreshControls()
	end
	for c, b in ipairs(self._controls) do
		if b.Parent and Q(a, b) and ao(b, self.Body, a) then
			return true
		end
	end
	return false
end
function g:_enableDrag()
	local a = false
	local c = Vector2.zero
	local b
	local function d()
		local a = self.Root
		return a.AbsolutePosition + a.AbsoluteSize * a.AnchorPoint - self.Gui.AbsolutePosition
	end
	table.insert(
		self._connections,
		q.InputBegan:Connect(function(e)
			if not p(e) then
				return
			end
			if not self.Open or not self.Root.Visible then
				return
			end
			local b = r()
			if not Q(b, self.Body) or self:_overControl(b) then
				return
			end
			a = true
			c = b - d()
		end)
	)
	table.insert(
		self._connections,
		q.InputEnded:Connect(function(c)
			if not a then
				return
			end
			if p(c) then
				a, b = false, nil
				self:_clampToScreen()
			end
		end)
	)
	table.insert(self._frameSteps, function(f)
		if not a then
			return
		end
		b = r() - c
		local g = d()
		local h = 1 - math.exp(-f * 45)
		local e = g:Lerp(b, h)
		self.Root.Position = UDim2.fromOffset(e.X, e.Y)
	end)
end
local function ab(a, d, e)
	if not a.Visible and not e then
		return
	end
	a.Visible = false
	task.delay(d, function()
		if not a.Parent then
			return
		end
		local d = c("UIScale", { Scale = 0.94, Parent = a })
		a.Visible = true
		b(d, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
		task.delay(0.4, function()
			d:Destroy()
		end)
	end)
end
function g:_revealCards(a, c)
	if a._revealed then
		return
	end
	a._revealed = true
	local b = 0
	for d, a in ipairs(a.List:GetChildren()) do
		if a:IsA("GuiObject") then
			ab(a, (c or 0) + b * 0.035)
			b += 1
		end
	end
end
function g:_playIntro(c)
	if self._introDone then
		return
	end
	self._introDone = true
	task.delay(1, function()
		self._autoSaveReady = true
	end)
	local a, d, e, f = self.Root, self.Body, self.Shadow, self.Scale
	if self.CurrentTab then
		self:_revealCards(self.CurrentTab, c and 0.15 or 0.25)
	end
	a.Visible = true
	if c then
		f.Scale = self._fitScale or 1
		a.Position = UDim2.fromScale(0.5, 0.5)
		b(d, { GroupTransparency = 0 }, 0.3)
		b(self.BodyStroke, { Transparency = 0 }, 0.3)
		b(e, { ImageTransparency = 0.6 }, 0.3)
	else
		a.Position = UDim2.new(0.5, 0, 0.5, 24)
		b(f, { Scale = self._fitScale or 1 }, 0.5, Enum.EasingStyle.Back)
		b(a, { Position = UDim2.fromScale(0.5, 0.5) }, 0.5, Enum.EasingStyle.Quint)
		b(d, { GroupTransparency = 0 }, 0.35)
		b(self.BodyStroke, { Transparency = 0 }, 0.35)
	end
	if not c then
		b(e, { ImageTransparency = 0.6 }, 0.5)
	end
	for a, b in ipairs(self.Tabs) do
		ab(b._button, 0.1 + a * 0.05, true)
	end
	self.Indicator.Visible = false
	task.delay(0.15 + #self.Tabs * 0.05, function()
		if self.CurrentTab then
			self:_placeIndicator(self.CurrentTab)
		end
	end)
end
function g:_showLoader(g)
	local j = "Frame"
	local m = g.LoadingDuration or 1.6
	local w = self.Gui
	local f = c("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 16),
		Size = UDim2.fromOffset(300, 132),
		BackgroundColor3 = a.Background,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		ZIndex = 10,
		Parent = w,
	})
	local y = e(f, UDim.new(0, 12))
	local z = h(f, a.Stroke, 1)
	M(f)
	x(f, UDim2.fromOffset(320, 140), UDim2.new(1, -20, 0, -20), 0.85, 90)
	x(f, UDim2.fromOffset(240, 100), UDim2.new(0, 10, 1, 10), 0.9, 270)
	local o = c("UIScale", { Scale = 0.92, Parent = f })
	local p = c("ImageLabel", {
		Position = UDim2.fromOffset(-25, -25),
		Size = UDim2.new(1, 50, 1, 50),
		BackgroundTransparency = 1,
		Image = t.Shadow,
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		ZIndex = 0,
		Parent = f,
	})
	local q = c(
		j,
		{ Position = UDim2.fromOffset(24, 26), Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1, Parent = f }
	)
	local r = c("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.5, 0.5),
		Rotation = -14,
		BackgroundTransparency = 1,
		ImageColor3 = a.Accent,
		ImageTransparency = 1,
		ScaleType = Enum.ScaleType.Fit,
		Parent = q,
	})
	u(r, g.Icon or t.Logo)
	task.delay(0.15, function()
		b(r, { Size = UDim2.fromScale(0.85, 0.85), Rotation = 0, ImageTransparency = 0 }, 0.6, Enum.EasingStyle.Back)
	end)
	d({
		Position = UDim2.fromOffset(78, 30),
		Size = UDim2.new(1, -100, 0, 22),
		Text = g.LoadingTitle or g.Title or "Airflow",
		TextSize = 20,
		Parent = f,
	})
	local A = d({
		Position = UDim2.fromOffset(78, 52),
		Size = UDim2.new(1, -100, 0, 16),
		Text = g.LoadingText or g.Subtitle or "Loading",
		TextSize = 13,
		FontFace = i.Regular,
		TextColor3 = a.Muted,
		Parent = f,
	})
	local k = c(j, {
		Position = UDim2.new(0, 24, 1, -30),
		Size = UDim2.new(1, -48, 0, 4),
		BackgroundColor3 = a.Surface3,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = f,
	})
	e(k, UDim.new(1, 0))
	local l = c(j, { Size = UDim2.fromScale(0, 1), BackgroundColor3 = a.Accent, BorderSizePixel = 0, Parent = k })
	e(l, UDim.new(1, 0))
	local n = c(j, {
		Position = UDim2.fromScale(-0.4, 0),
		Size = UDim2.fromScale(0.4, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = k,
	})
	c("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = n,
	})
	b(f, { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }, 0.4, Enum.EasingStyle.Quint)
	b(o, { Scale = 1 }, 0.5, Enum.EasingStyle.Back)
	b(p, { ImageTransparency = 0.6 }, 0.4)
	local s = T:Create(
		n,
		TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1),
		{ Position = UDim2.fromScale(1, 0) }
	)
	s:Play()
	b(l, { Size = UDim2.fromScale(0.85, 1) }, m * 0.8, Enum.EasingStyle.Quart)
	task.spawn(I)
	local v = g.LoadingSteps or { "Preparing interface", "Loading icons", "Almost there" }
	for a, b in ipairs(v) do
		task.delay(m * (a - 1) / #v, function()
			if f.Parent then
				A.Text = b
			end
		end)
	end
	task.delay(m, function()
		b(l, { Size = UDim2.fromScale(1, 1) }, 0.25, Enum.EasingStyle.Quint)
		task.delay(0.25, function()
			s:Cancel()
			for c, a in ipairs(f:GetChildren()) do
				if a:IsA("TextLabel") then
					b(a, { TextTransparency = 1 }, 0.15)
				end
			end
			for c, a in ipairs(q:GetChildren()) do
				b(a, { ImageTransparency = 1 }, 0.15)
			end
			b(k, { BackgroundTransparency = 1 }, 0.15)
			b(l, { BackgroundTransparency = 1 }, 0.15)
			b(n, { BackgroundTransparency = 1 }, 0.1)
			local a = self._fitScale or 1
			local c = self.Root.Size
			b(
				f,
				{ Size = UDim2.fromOffset(c.X.Offset * a, c.Y.Offset * a), Position = UDim2.fromScale(0.5, 0.5) },
				0.5,
				Enum.EasingStyle.Quint
			)
			b(y, { CornerRadius = UDim.new(0, 10) }, 0.5, Enum.EasingStyle.Quint)
			b(o, { Scale = 1 }, 0.5, Enum.EasingStyle.Quint)
			task.delay(0.28, function()
				self:_playIntro(true)
				b(f, { GroupTransparency = 1 }, 0.25)
				b(z, { Transparency = 1 }, 0.2)
				b(p, { ImageTransparency = 1 }, 0.2)
			end)
			task.delay(0.6, function()
				f:Destroy()
			end)
		end)
	end)
end
function g:_fitToScreen(d)
	local a = self.Gui.AbsoluteSize
	if a.X == 0 or a.Y == 0 then
		return
	end
	local c = self.Root.Size
	local e = math.min(1, (a.X - 24) / math.max(c.X.Offset, 1), (a.Y - 24) / math.max(c.Y.Offset, 1))
	self._fitScale = math.max(e, 0.45)
	if self._introDone and self.Open then
		if d then
			self.Scale.Scale = self._fitScale
		else
			b(self.Scale, { Scale = self._fitScale }, 0.2)
		end
	end
end
function g:_clampToScreen()
	if not self.KeepOnScreen then
		return
	end
	local a = self.Gui.AbsoluteSize
	local d = self.Root
	local c = d.AbsoluteSize / 2
	local e = d.AbsolutePosition + c - self.Gui.AbsolutePosition
	local f = Vector2.new(
		math.clamp(e.X, math.min(c.X, a.X / 2), math.max(a.X - c.X, a.X / 2)),
		math.clamp(e.Y, math.min(c.Y, a.Y / 2), math.max(a.Y - c.Y, a.Y / 2))
	)
	if (f - e).Magnitude > 0.5 then
		b(d, { Position = UDim2.fromOffset(f.X, f.Y) }, 0.25, Enum.EasingStyle.Quint)
	end
end
function g:_createOpenButton(j)
	local f = self.Gui
	local b = c("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 14),
		Size = UDim2.fromOffset(0, 40),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = a.Background,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 30,
		Parent = f,
	})
	e(b, UDim.new(1, 0))
	h(b, a.Stroke)
	o(b, 12, 16)
	local l = c("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1,
		ImageColor3 = a.Accent,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 31,
		Parent = b,
	})
	u(l, j.Icon or t.Logo)
	d({
		Position = UDim2.fromOffset(28, 0),
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = j.Title or "Airflow",
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.None,
		ZIndex = 31,
		Parent = b,
	})
	self.OpenButton = b
	local g, i = false, false
	local k = Vector2.zero
	b.InputBegan:Connect(function(a)
		if p(a) then
			g, i = true, false
			k = r() - b.AbsolutePosition
		end
	end)
	table.insert(
		self._connections,
		q.InputChanged:Connect(function(a)
			if not g then
				return
			end
			if N(a) then
				local a = r() - k - f.AbsolutePosition
				if (a - (b.AbsolutePosition - f.AbsolutePosition)).Magnitude > 3 then
					i = true
				end
				b.AnchorPoint = Vector2.new(0, 0)
				b.Position = UDim2.fromOffset(
					math.clamp(a.X, 0, math.max(f.AbsoluteSize.X - b.AbsoluteSize.X, 0)),
					math.clamp(a.Y, 0, math.max(f.AbsoluteSize.Y - b.AbsoluteSize.Y, 0))
				)
			end
		end)
	)
	table.insert(
		self._connections,
		q.InputEnded:Connect(function(a)
			if g and p(a) then
				g = false
				if not i then
					self:Toggle()
				end
			end
		end)
	)
end
function g:_enableResize(i)
	local j = self.MaxSize or Vector2.new(math.huge, math.huge)
	local f = c("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, 4, 1, 4),
		Size = UDim2.fromOffset(32, 32),
		BackgroundTransparency = 1,
		Active = true,
		ZIndex = 20,
		Parent = self.Root,
	})
	local g, d =
		c("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, -16, 0.5, -16),
			Size = UDim2.fromOffset(96, 96),
			BackgroundTransparency = 1,
			Image = "rbxassetid://120997033468887",
			ImageColor3 = a.Accent,
			ImageTransparency = 0.8,
			ZIndex = 20,
			Parent = f,
		}), false
	local h = self.Root.Size
	local k = Vector2.zero
	local e
	f.InputBegan:Connect(function(a)
		if p(a) then
			d = true
			h = self.Root.Size
			k = r()
			b(g, { ImageTransparency = 0.35 }, 0.1)
		end
	end)
	f.MouseEnter:Connect(function()
		if not d then
			b(g, { ImageTransparency = 0.35 }, 0.1)
		end
	end)
	f.MouseLeave:Connect(function()
		if not d then
			b(g, { ImageTransparency = 0.8 }, 0.17)
		end
	end)
	table.insert(
		self._connections,
		q.InputEnded:Connect(function(a)
			if d and p(a) then
				d = false
				b(g, { ImageTransparency = 0.8 }, 0.17)
				if e then
					self.Root.Size = UDim2.fromOffset(e.X, e.Y)
					e = nil
				end
				self:_fitToScreen()
				self:_clampToScreen()
			end
		end)
	)
	table.insert(self._frameSteps, function(f)
		if not d then
			return
		end
		local b = (r() - k) / self.Scale.Scale
		e = Vector2.new(math.clamp(h.X.Offset + b.X * 2, i.X, j.X), math.clamp(h.Y.Offset + b.Y * 2, i.Y, j.Y))
		local c = Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset)
		local g = 1 - math.exp(-f * 35)
		local a = c:Lerp(e, g)
		a = Vector2.new(math.floor(a.X + 0.5), math.floor(a.Y + 0.5))
		if a ~= c then
			self.Root.Size = UDim2.fromOffset(a.X, a.Y)
		end
	end)
end
local function R(a, b)
	return a.ConfigFolder .. "/" .. b .. ".json"
end
local function S()
	local a = "function"
	return type(writefile) == a and type(readfile) == a and type(isfile) == a
end
local function ap(a)
	if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(a) then
		makefolder(a)
	end
end
local function aq(c)
	local b = c._type
	local a = c:Get()
	if b == "Keybind" then
		return { Type = b, Value = a and a.Name or nil }
	elseif b == "ColorPicker" then
		return { Type = b, Value = { a.R, a.G, a.B } }
	end
	return { Type = b, Value = a }
end
local function ar(b, e, c)
	local d = b._type
	local a = e.Value
	if d == "Keybind" then
		b:Set(a and Enum.KeyCode[a] or nil, c)
	elseif d == "ColorPicker" then
		if type(a) == "table" then
			b:Set(Color3.new(a[1], a[2], a[3]), c)
		end
	elseif a ~= nil then
		b:Set(a, c)
	end
end
function g:SaveConfig(a)
	a = a or self.ConfigName
	if not S() then
		return false, "file API unavailable"
	end
	ap(self.ConfigFolder)
	local b = {}
	for c, a in pairs(f.Flags) do
		if a._type and type(a.Get) == "function" then
			b[c] = aq(a)
		end
	end
	local c, d = pcall(function()
		writefile(R(self, a), C:JSONEncode(b))
	end)
	if c then
		self.ConfigName = a
	end
	return c, d
end
function g:LoadConfig(a, d)
	a = a or self.ConfigName
	if not S() then
		return false, "file API unavailable"
	end
	local b = R(self, a)
	if not isfile(b) then
		return false, "no config named " .. a
	end
	local e, c = pcall(function()
		return C:JSONDecode(readfile(b))
	end)
	if not e or type(c) ~= "table" then
		return false, "config is not valid JSON"
	end
	local g = self._autoSaveEnabled
	self._autoSaveEnabled = false
	for c, b in pairs(c) do
		local a = f.Flags[c]
		if a and type(a.Set) == "function" and type(b) == "table" and b.Type == a._type then
			pcall(ar, a, b, d == true)
		end
	end
	self._autoSaveEnabled = g
	self._autoSaveReady = true
	self.ConfigName = a
	return true
end
function g:DeleteConfig(a)
	if not S() or type(delfile) ~= "function" then
		return false, "file API unavailable"
	end
	local b = R(self, a)
	if not isfile(b) then
		return false, "no config named " .. a
	end
	delfile(b)
	return true
end
function g:ListConfigs()
	local a = {}
	if type(listfiles) ~= "function" or type(isfolder) ~= "function" or not isfolder(self.ConfigFolder) then
		return a
	end
	for d, c in ipairs(listfiles(self.ConfigFolder)) do
		local b = c:match("([^/\\]+)%.json$")
		if b then
			table.insert(a, b)
		end
	end
	table.sort(a)
	return a
end
function g:_autoSave()
	if not self._autoSaveEnabled or self._destroyed or not self._autoSaveReady then
		return
	end
	if self._autoSavePending then
		return
	end
	self._autoSavePending = true
	task.delay(0.5, function()
		self._autoSavePending = false
		if not self._destroyed then
			self:SaveConfig(self.ConfigName)
		end
	end)
end
local function as(f, g, h)
	local b = c("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, -10),
		Size = UDim2.fromOffset(200, 70),
		BackgroundTransparency = 1,
		Parent = f,
	})
	local e = c("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.fromOffset(26, 26),
		BackgroundTransparency = 1,
		ImageColor3 = a.Muted,
		ImageTransparency = 0.15,
		ScaleType = Enum.ScaleType.Fit,
		Parent = b,
	})
	u(e, g)
	local j = d({
		Position = UDim2.fromOffset(0, 36),
		Size = UDim2.new(1, 0, 0, 16),
		Text = h,
		TextSize = 13,
		FontFace = i.Regular,
		TextColor3 = a.Muted,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = b,
	})
	return b, j, e
end
local function at(g, i, f, j)
	local b = c("Frame", {
		Size = UDim2.new(0.5, -4, 0, 62),
		BackgroundColor3 = a.Surface2,
		BorderSizePixel = 0,
		LayoutOrder = i,
		Parent = g,
	})
	e(b)
	h(b)
	b:SetAttribute("NoDrag", true)
	if f then
		y(b, f, a.Muted, UDim2.new(0, 14, 0, 21))
	end
	d({
		Position = UDim2.fromOffset(f and 36 or 14, 12),
		Size = UDim2.new(1, -(f and 50 or 28), 0, 16),
		Text = j,
		TextSize = 12,
		TextColor3 = a.Muted,
		Parent = b,
	})
	return d({
		Position = UDim2.fromOffset(14, 34),
		Size = UDim2.new(1, -28, 0, 18),
		Text = "…",
		TextSize = 15,
		Parent = b,
	})
end
local function ac(c)
	local a = {}
	local function d(b)
		for c, b in ipairs(b:GetChildren()) do
			if b:IsA("TextLabel") or b:IsA("TextButton") or b:IsA("TextBox") then
				table.insert(a, { b, "TextTransparency", b.TextTransparency })
			elseif b:IsA("ImageLabel") or b:IsA("ImageButton") then
				table.insert(a, { b, "ImageTransparency", b.ImageTransparency })
			elseif b:IsA("UIStroke") then
				table.insert(a, { b, "Transparency", b.Transparency })
			elseif b:IsA("Frame") then
				table.insert(a, { b, "BackgroundTransparency", b.BackgroundTransparency })
			end
			d(b)
		end
	end
	if c:IsA("Frame") then
		table.insert(a, { c, "BackgroundTransparency", c.BackgroundTransparency })
	end
	d(c)
	for c, a in ipairs(a) do
		a[1][a[2]] = 1
		b(a[1], { [a[2]] = a[3] }, 0.28)
	end
end
local function au(a, c)
	c = c or 0
	a.GroupTransparency = 1
	a.Position = UDim2.fromOffset(0, c + 14)
	a.Visible = true
	b(a, { GroupTransparency = 0, Position = UDim2.fromOffset(0, c) }, 0.32, Enum.EasingStyle.Quint)
end
function g:_buildHome(f)
	local g, n, p, w = "Frame", "UIListLayout", "NoDrag", "Executor"
	local m = self:Tab({ Name = f.Name or "Home", Desc = f.Desc, Icon = f.Icon or "house" })
	local q = m.List
	local x = f.Pages or f.Tabs
	local r = {}
	local s
	if type(x) == "table" and #x > 0 then
		s = c(g, { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 1, Parent = q })
		c(n, {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
			Parent = s,
		})
	end
	local y = f.Greeting
	if y == nil then
		local a = tonumber(os.date("%H")) or 12
		local b = a < 12 and "morning" or (a < 18 and "afternoon" or "evening")
		y = "Good " .. b .. "."
	end
	local j = c(g, {
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundColor3 = a.Surface2,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Parent = q,
	})
	j:SetAttribute(p, true)
	e(j)
	h(j)
	local z = c("ImageLabel", {
		Position = UDim2.fromOffset(12, 11),
		Size = UDim2.fromOffset(36, 36),
		BackgroundColor3 = a.Surface,
		BorderSizePixel = 0,
		Parent = j,
	})
	e(z, UDim.new(0, 8))
	h(z)
	task.spawn(function()
		local b, a = pcall(function()
			return D:GetUserThumbnailAsync(E.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if b and a then
			z.Image = a
		end
	end)
	d({
		Position = UDim2.fromOffset(58, 11),
		Size = UDim2.new(1, -72, 0, 18),
		Text = (f.Welcome or "Hello, ") .. E.DisplayName,
		TextSize = 15,
		Parent = j,
	})
	d({
		Position = UDim2.fromOffset(58, 30),
		Size = UDim2.new(1, -72, 0, 16),
		Text = y,
		TextSize = 13,
		FontFace = i.Regular,
		TextColor3 = a.Muted,
		Parent = j,
	})
	local t = c(g, {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Parent = q,
	})
	c(n, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = t })
	if f.Sections ~= false then
		local b = c(g, { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 1, Parent = t })
		local e = d({
			Position = UDim2.fromOffset(2, 6),
			Size = UDim2.new(0, 0, 0, 16),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = string.upper(f.SectionName or "System info"),
			TextSize = 12,
			TextColor3 = a.Muted,
			TextTruncate = Enum.TextTruncate.None,
			Parent = b,
		})
		local i = c(g, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0, 14),
			Size = UDim2.new(1, -12, 0, 1),
			BackgroundColor3 = a.Stroke,
			BorderSizePixel = 0,
			Parent = b,
		})
		local function h()
			i.Size = UDim2.new(1, -(e.AbsoluteSize.X + 14), 0, 1)
		end
		e:GetPropertyChangedSignal("AbsoluteSize"):Connect(h)
		task.defer(h)
	end
	local C = c(g, {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Parent = t,
	})
	c("UIGridLayout", {
		CellSize = UDim2.new(0.5, -4, 0, 62),
		CellPadding = UDim2.fromOffset(8, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = C,
	})
	local N = f.Stats or { "FPS", "Ping", w, "Game", "Region", "Time" }
	local F = {}
	for b, a in ipairs(N) do
		F[a] = true
	end
	local G = 0
	local function l(a, b, c)
		if not F[a] then
			return nil
		end
		G += 1
		return at(C, G, b, c)
	end
	local H = l("FPS", "activity", "FPS")
	local I = l("Ping", "wifi", "Ping")
	local J = l(w, "terminal", w)
	local A = l("Game", "gamepad-2", "Game")
	local B = l("Region", "globe", "Server region")
	local K = l("Time", "clock", "Time of day")
	local L = l("Players", "users", "Players")
	local M = l("Uptime", "timer", "Session")
	if J then
		J.Text = aj()
	end
	if A then
		A.Text = "Loading"
		task.spawn(function()
			A.Text = ak()
		end)
	end
	if B then
		B.Text = "Loading"
		am(function(a)
			B.Text = a
		end)
	end
	local v = 0
	local O = os.clock()
	self:_listen("Render", function()
		v += 1
	end)
	task.spawn(function()
		while not self._destroyed and m.List.Parent and m._page.Parent do
			if not self.Open or self.CurrentTab ~= m then
				v = 0
				task.wait(1)
				continue
			end
			if H then
				H.Text = tostring(v)
			end
			v = 0
			if I then
				local a, b = pcall(function()
					return math.floor(E:GetNetworkPing() * 1e3)
				end)
				I.Text = (a and b or 0) .. " ms"
			end
			if K then
				K.Text = os.date(f.TimeFormat or "%H:%M")
			end
			if L then
				L.Text = #D:GetPlayers() .. " / " .. D.MaxPlayers
			end
			if M then
				local a = math.floor(os.clock() - O)
				M.Text = string.format("%d:%02d", math.floor(a / 60), a % 60)
			end
			task.wait(1)
		end
	end)
	table.insert(r, { Title = f.SectionName or "Details", Icon = f.TabIcon or "layout-grid", Frame = t })
	if s then
		for j, b in ipairs(x) do
			local f = c(g, {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Visible = false,
				LayoutOrder = 3,
				Parent = q,
			})
			c(n, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = f })
			if type(b.Content) == "string" then
				local j = c(g, {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = a.Surface2,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Parent = f,
				})
				j:SetAttribute(p, true)
				e(j)
				h(j)
				o(j, 14, 14, 12, 14)
				d({
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = b.Content,
					TextSize = 13,
					FontFace = i.Regular,
					TextColor3 = a.Muted,
					TextWrapped = true,
					TextTruncate = Enum.TextTruncate.None,
					TextYAlignment = Enum.TextYAlignment.Top,
					Parent = j,
				})
			end
			if type(b.Entries) == "table" then
				for m, b in ipairs(b.Entries) do
					local j = c(g, {
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = a.Surface2,
						BorderSizePixel = 0,
						LayoutOrder = m,
						Parent = f,
					})
					j:SetAttribute(p, true)
					e(j)
					h(j)
					o(j, 14, 14, 12, 14)
					c(n, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = j })
					local l =
						c(g, { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = 1, Parent = j })
					d({
						Size = UDim2.new(1, -70, 1, 0),
						Text = b.Title or b.Version or "Update",
						TextSize = 14,
						Parent = l,
					})
					if b.Date or b.Tag then
						local f = c(g, {
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.fromOffset(0, 20),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = a.Surface,
							BorderSizePixel = 0,
							Parent = l,
						})
						e(f, UDim.new(0, 5))
						h(f)
						o(f, 8, 8)
						d({
							Size = UDim2.new(0, 0, 1, 0),
							AutomaticSize = Enum.AutomaticSize.X,
							Text = b.Tag or b.Date,
							TextSize = 11,
							TextColor3 = a.Muted,
							TextTruncate = Enum.TextTruncate.None,
							Parent = f,
						})
					end
					local k = b.Content or b.Body
					if type(b.Changes) == "table" then
						k = "• " .. table.concat(b.Changes, "\n• ")
					end
					if k then
						d({
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							Text = k,
							TextSize = 13,
							FontFace = i.Regular,
							TextColor3 = a.Muted,
							TextWrapped = true,
							TextTruncate = Enum.TextTruncate.None,
							TextYAlignment = Enum.TextYAlignment.Top,
							LayoutOrder = 2,
							Parent = j,
						})
					end
				end
			end
			if type(b.Build) == "function" then
				k(b.Build, f)
				for b, a in ipairs(f:GetChildren()) do
					if a:IsA("GuiObject") then
						a:SetAttribute(p, true)
					end
				end
			end
			table.insert(r, { Title = b.Name or b.Title or "Page", Icon = b.Icon, Frame = f })
		end
		local f = {}
		local function l(c, d)
			local e = self._homeIndex ~= c
			self._homeIndex = c
			j.Visible = c == 1
			if c == 1 and e and not d then
				ac(j)
			end
			for i, k in ipairs(r) do
				local g = i == c
				local j = k.Frame
				j.Visible = g
				if g and e and not d then
					for b, a in ipairs(j:GetChildren()) do
						if a:IsA("GuiObject") then
							ac(a)
						end
					end
				end
				local h = f[i]
				if h then
					b(h.Frame, { BackgroundTransparency = g and 0 or 1 }, 0.15)
					b(h.Stroke, { Transparency = g and 0 or 1 }, 0.15)
					b(h.Label, { TextColor3 = g and a.Text or a.Muted }, 0.15)
					if h.Icon then
						b(h.Icon, { ImageColor3 = g and a.Accent or a.Muted }, 0.15)
					end
				end
			end
		end
		for i, k in ipairs(r) do
			local g = c("TextButton", {
				Size = UDim2.fromOffset(0, 32),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = a.Surface2,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = i,
				Parent = s,
			})
			e(g, UDim.new(0, 7))
			local m = h(g, a.Stroke, 1)
			o(g, 12, 12)
			local j
			if k.Icon then
				j = c("ImageLabel", {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.fromOffset(14, 14),
					BackgroundTransparency = 1,
					ImageColor3 = a.Muted,
					ScaleType = Enum.ScaleType.Fit,
					Parent = g,
				})
				u(j, k.Icon)
			end
			local n = d({
				Position = UDim2.fromOffset(j and 20 or 0, 0),
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = k.Title,
				TextSize = 13,
				TextColor3 = a.Muted,
				TextTruncate = Enum.TextTruncate.None,
				Parent = g,
			})
			f[i] = { Frame = g, Stroke = m, Label = n, Icon = j }
			g.MouseEnter:Connect(function()
				if self._homeIndex ~= i then
					b(g, { BackgroundTransparency = 0.4 }, 0.12)
					b(m, { Transparency = 0.5 }, 0.12)
				end
			end)
			g.MouseLeave:Connect(function()
				if self._homeIndex ~= i then
					b(g, { BackgroundTransparency = 1 }, 0.2)
					b(m, { Transparency = 1 }, 0.2)
				end
			end)
			g.MouseButton1Click:Connect(function()
				l(i)
			end)
		end
		l(1)
	end
	m._order = 10
	self.Home = m
	return m
end
function g:Tab(g, t)
	g = l(g, { Title = "Name", Description = "Desc" })
	if t ~= nil and g.Icon == nil then
		g.Icon = t
	end
	local f = setmetatable({ Name = g.Name or "Tab", Window = self, _order = 0 }, j)
	local k = c("TextButton", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = a.Surface2,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = #self.Tabs + 1,
		Parent = self.TabList,
	})
	e(k)
	local q = h(k, a.Stroke, 1)
	f._button = k
	local r = g.Icon ~= nil
	if r then
		local b = c("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 12, 0.5, 0),
			Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 1,
			ImageColor3 = a.Muted,
			ScaleType = Enum.ScaleType.Fit,
			Parent = k,
		})
		u(b, g.Icon)
		f._icon = b
	end
	f._label = d({
		Position = UDim2.fromOffset(r and 36 or 14, 0),
		Size = UDim2.new(1, -(r and 44 or 22), 1, 0),
		Text = f.Name,
		TextColor3 = a.Muted,
		Parent = k,
	})
	local m = c("Frame", {
		Name = f.Name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = self.Content,
	})
	f._page = m
	d({ Position = UDim2.fromOffset(24, 20), Size = UDim2.new(1, -72, 0, 24), Text = f.Name, TextSize = 22, Parent = m })
	if g.Desc then
		d({
			Position = UDim2.fromOffset(24, 44),
			Size = UDim2.new(1, -72, 0, 16),
			Text = g.Desc,
			TextSize = 13,
			FontFace = i.Regular,
			TextColor3 = a.Muted,
			Parent = m,
		})
	end
	local v = g.Desc and 70 or 58
	local n = c("ScrollingFrame", {
		Position = UDim2.fromOffset(0, v),
		Size = UDim2.new(1, 0, 1, -v),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = a.Accent,
		ScrollBarImageTransparency = 0.5,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		Parent = m,
	})
	o(n, 24, 24, 2, 24)
	c("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = n })
	f.List = n
	local s, p = as(m, g.Icon or "layout-grid", g.EmptyText or "Nothing here yet"), 0
	n.ChildAdded:Connect(function(a)
		if a:IsA("GuiObject") then
			p += 1
			s.Visible = false
		end
	end)
	n.ChildRemoved:Connect(function(a)
		if a:IsA("GuiObject") then
			p = math.max(p - 1, 0)
			s.Visible = p <= 0
		end
	end)
	s.Visible = true
	k.MouseEnter:Connect(function()
		if self.CurrentTab ~= f then
			b(k, { BackgroundTransparency = 0.4 }, 0.12)
			b(q, { Transparency = 0.5 }, 0.12)
		end
	end)
	k.MouseLeave:Connect(function()
		if self.CurrentTab ~= f then
			b(k, { BackgroundTransparency = 1 }, 0.2)
			b(q, { Transparency = 1 }, 0.2)
		end
	end)
	k.MouseButton1Click:Connect(function()
		self:SelectTab(f)
	end)
	f._stroke = q
	if not self._introDone then
		k.Visible = false
	end
	table.insert(self.Tabs, f)
	if #self.Tabs == 1 then
		task.defer(function()
			self:SelectTab(f)
		end)
	end
	return f
end
g.CreateTab = g.Tab
function g:Dialog(j)
	local s = "TextTransparency"
	j = l(j, { Text = "Content", Message = "Content" })
	if self._dialog then
		self._dialog.Close()
	end
	local f = 18
	local q = c("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 40,
		Parent = self.Body,
	})
	local g = c("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 10),
		Size = UDim2.fromOffset(300, 120),
		BackgroundColor3 = a.Background,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 41,
		Parent = q,
	})
	e(g, UDim.new(0, 10))
	local u = h(g, a.Stroke, 1)
	local v = c("UIScale", { Scale = 0.94, Parent = g })
	local m, t = {}, 0
	if j.Icon then
		local c, b = y(g, j.Icon, a.Accent, UDim2.new(0, f, 0, f + 9))
		b.ImageTransparency = 1
		c.ZIndex = 42
		b.ZIndex = 42
		table.insert(m, { b, "ImageTransparency", 0 })
		t = 24
	end
	local x = d({
		Position = UDim2.fromOffset(f + t, f),
		Size = UDim2.new(1, -(f * 2 + t), 0, 18),
		Text = j.Title or "Are you sure?",
		TextSize = 15,
		TextTransparency = 1,
		ZIndex = 42,
		Parent = g,
	})
	table.insert(m, { x, s, 0 })
	local n = 0
	if j.Content then
		local b = d({
			Position = UDim2.fromOffset(f, f + 24),
			Size = UDim2.new(1, -f * 2, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = j.Content,
			TextSize = 13,
			FontFace = i.Regular,
			TextColor3 = a.Muted,
			TextWrapped = true,
			TextTransparency = 1,
			TextTruncate = Enum.TextTruncate.None,
			TextYAlignment = Enum.TextYAlignment.Top,
			ZIndex = 42,
			Parent = g,
		})
		table.insert(m, { b, s, 0 })
		n = math.max(b.TextBounds.Y, 16) + 6
		b:GetPropertyChangedSignal("TextBounds"):Connect(function()
			local a = math.max(b.TextBounds.Y, 16) + 6
			if a ~= n then
				n = a
				g.Size = UDim2.fromOffset(300, f + 24 + n + 12 + 34 + f)
				local b = g:FindFirstChild("ButtonRow")
				if b then
					b.Position = UDim2.fromOffset(f, f + 24 + n + 12)
				end
			end
		end)
	end
	local w = c("Frame", {
		Name = "ButtonRow",
		Position = UDim2.fromOffset(f, f + 24 + n + 12),
		Size = UDim2.new(1, -f * 2, 0, 34),
		BackgroundTransparency = 1,
		ZIndex = 42,
		Parent = g,
	})
	c("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = w,
	})
	g.Size = UDim2.fromOffset(300, f + 24 + n + 12 + 34 + f)
	local p, r = {}, false
	function p.Close()
		if r then
			return
		end
		r = true
		if self._dialog == p then
			self._dialog = nil
		end
		b(q, { BackgroundTransparency = 1 }, 0.18)
		b(g, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 8) }, 0.18, Enum.EasingStyle.Quint)
		b(v, { Scale = 0.96 }, 0.18, Enum.EasingStyle.Quint)
		b(u, { Transparency = 1 }, 0.12)
		for c, a in ipairs(m) do
			b(a[1], { [a[2]] = 1 }, 0.12)
		end
		task.delay(0.2, function()
			q:Destroy()
		end)
	end
	for q, j in ipairs(j.Buttons or {}) do
		local g = j.Variant == "Primary"
		local f = c("TextButton", {
			Size = UDim2.fromOffset(0, 34),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = g and a.Accent or a.Surface2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ClipsDescendants = true,
			LayoutOrder = q,
			ZIndex = 43,
			Parent = w,
		})
		e(f, UDim.new(0, 7))
		local i = h(f, g and a.Accent or a.Stroke, 1)
		o(f, 14, 14)
		local t = d({
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = j.Title or j.Name or "OK",
			TextSize = 13,
			TextColor3 = g and a.AccentDark or a.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextTransparency = 1,
			ZIndex = 44,
			Parent = f,
		})
		local l = g and 0.12 or 0
		local n = g and 0.4 or 0
		table.insert(m, { f, "BackgroundTransparency", l })
		table.insert(m, { i, "Transparency", n })
		table.insert(m, { t, s, 0 })
		f.MouseEnter:Connect(function()
			if r then
				return
			end
			if g then
				b(f, { BackgroundTransparency = 0 }, 0.12)
				b(i, { Transparency = 0 }, 0.12)
			else
				b(i, { Color = a.StrokeHover }, 0.12)
			end
		end)
		f.MouseLeave:Connect(function()
			if r then
				return
			end
			if g then
				b(f, { BackgroundTransparency = l }, 0.2)
				b(i, { Transparency = n }, 0.2)
			else
				b(i, { Color = a.Stroke }, 0.2)
			end
		end)
		f.MouseButton1Click:Connect(function()
			p.Close()
			k(j.Callback)
		end)
	end
	if j.CloseOnBackdrop ~= false then
		q.MouseButton1Click:Connect(function()
			p.Close()
			k(j.OnCancel)
		end)
	end
	self._dialog = p
	b(q, { BackgroundTransparency = 0.45 }, 0.25)
	b(g, { BackgroundTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }, 0.3, Enum.EasingStyle.Quint)
	b(u, { Transparency = 0 }, 0.25)
	b(v, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
	for c, a in ipairs(m) do
		b(a[1], { [a[2]] = a[3] }, 0.25)
	end
	return p
end
function g:Confirm(a)
	a = l(a, { Text = "Content", Message = "Content" })
	return self:Dialog({
		Title = a.Title or "Are you sure?",
		Content = a.Content,
		Icon = a.Icon,
		OnCancel = a.OnCancel,
		Buttons = {
			{ Title = a.CancelText or "Cancel", Callback = a.OnCancel },
			{ Title = a.ConfirmText or "Confirm", Variant = "Primary", Callback = a.Callback },
		},
	})
end
function g:_listen(e, c, a)
	local b = self._inputListeners[e]
	table.insert(b, c)
	local function d()
		for a, d in ipairs(b) do
			if d == c then
				table.remove(b, a)
				break
			end
		end
	end
	if a then
		a._listeners = a._listeners or {}
		table.insert(a._listeners, d)
	end
	return d
end
function g:_indicatorY(a)
	local b = self.TabList
	local c = self.Scale.Scale
	return (a._button.AbsolutePosition.Y - b.AbsolutePosition.Y + a._button.AbsoluteSize.Y / 2) / c
		+ b.Position.Y.Offset
end
function g:_placeIndicator(d)
	local a = self.Indicator
	local c = self:_indicatorY(d)
	if not a.Visible then
		a.Visible = true
		a.Position = UDim2.fromOffset(6, c)
		a.Size = UDim2.fromOffset(3, 0)
	end
	b(a, { Position = UDim2.fromOffset(6, c), Size = UDim2.fromOffset(3, 18) }, 0.35, Enum.EasingStyle.Back)
end
function g:SelectTab(c)
	if self.CurrentTab == c then
		return
	end
	local d = self.CurrentTab
	self.CurrentTab = c
	self:_settleTransition()
	local f = (self._transitionGeneration or 0) + 1
	self._transitionGeneration = f
	if d then
		b(d._button, { BackgroundTransparency = 1 }, 0.2)
		b(d._stroke, { Transparency = 1 }, 0.2)
		b(d._label, { TextColor3 = a.Muted }, 0.2)
		if d._icon then
			b(d._icon, { ImageColor3 = a.Muted }, 0.2)
		end
		local c = self._outLayer
		d._page.Parent = c
		self._outPage = d._page
		c.GroupTransparency = 0
		c.Position = UDim2.fromOffset(0, 0)
		c.Visible = true
		b(c, { GroupTransparency = 1, Position = UDim2.fromOffset(0, -10) }, 0.18)
		task.delay(0.18, function()
			if self._transitionGeneration == f then
				self:_settleOut()
			end
		end)
	end
	b(c._button, { BackgroundTransparency = 0 }, 0.2)
	b(c._stroke, { Transparency = 0 }, 0.2)
	b(c._label, { TextColor3 = a.Text }, 0.2)
	if c._icon then
		b(c._icon, { ImageColor3 = a.Accent }, 0.2)
	end
	self:_placeIndicator(c)
	local e = c._page
	e.Position = UDim2.fromOffset(0, 0)
	e.Visible = true
	e.Parent = self._inLayer
	self._inPage = e
	au(self._inLayer)
	task.delay(0.32, function()
		if self._transitionGeneration == f then
			self:_settleIn()
		end
	end)
end
function g:_settleOut()
	local a = self._outPage
	if a then
		a.Parent = self.Content
		a.Visible = false
		self._outPage = nil
	end
	self._outLayer.Visible = false
end
function g:_settleIn()
	local a = self._inPage
	if a then
		a.Parent = self.Content
		a.Position = UDim2.fromOffset(0, 0)
		self._inPage = nil
	end
	self._inLayer.Visible = false
end
function g:_settleTransition()
	self:_settleOut()
	self:_settleIn()
end
function g:Toggle(a)
	if not self._introDone then
		return
	end
	if a == nil then
		a = not self.Open
	end
	if a == self.Open then
		return
	end
	self.Open = a
	if a then
		self.Root.Visible = true
		b(self.Scale, { Scale = self._fitScale or 1 }, 0.4, Enum.EasingStyle.Back)
		b(self.Body, { GroupTransparency = 0 }, 0.25)
		b(self.BodyStroke, { Transparency = 0 }, 0.25)
		b(self.Shadow, { ImageTransparency = 0.6 }, 0.3)
	else
		b(self.Scale, { Scale = (self._fitScale or 1) * 0.94 }, 0.2, Enum.EasingStyle.Quint)
		b(self.Body, { GroupTransparency = 1 }, 0.16)
		b(self.BodyStroke, { Transparency = 1 }, 0.12)
		b(self.Shadow, { ImageTransparency = 1 }, 0.16)
		task.delay(0.2, function()
			if not self.Open then
				self.Root.Visible = false
			end
		end)
	end
end
function g:SetKeepOnScreen(a)
	self.KeepOnScreen = a ~= false
	if self.KeepOnScreen then
		self:_clampToScreen()
	end
end
function g:SetKeybind(a)
	self.Keybind = a
	self._keyChipLabel.Text = P(a)
end
function g:Notify(f)
	local k = "Frame"
	f = l(f, { Text = "Content", Message = "Content", Image = "Icon" })
	local u = f.Duration or 4
	local s = an[f.Type] or a.Text
	self._notifyOrder += 1
	local j = c(k, {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = self._notifyOrder,
		Parent = self.NotifyHolder,
	})
	local r = c(k, {
		Position = UDim2.fromOffset(320, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = j,
	})
	local v = c("ImageLabel", {
		Position = UDim2.fromOffset(-20, -20),
		Size = UDim2.new(1, 40, 1, 40),
		BackgroundTransparency = 1,
		Image = t.Shadow,
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		ZIndex = 0,
		Parent = r,
	})
	local g = c("CanvasGroup", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = a.Background,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = r,
	})
	e(g, UDim.new(0, 10))
	local B = h(g, a.Stroke)
	M(g)
	x(g, UDim2.fromOffset(260, 120), UDim2.new(1, -10, 0, -10), 0.86, 90)
	local m = c(
		k,
		{ Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = g }
	)
	o(m, 16, 16, 14, 24)
	local n = 0
	if f.Icon then
		y(m, f.Icon, s == a.Text and a.Accent or s, UDim2.new(0, 0, 0, 8))
		n = 24
	end
	d({
		Position = UDim2.fromOffset(n, 0),
		Size = UDim2.new(1, -28 - n, 0, 16),
		Text = f.Title or "Notification",
		TextSize = 14,
		TextColor3 = s,
		Parent = m,
	})
	local p = c("TextButton", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 6, 0, -5),
		Size = UDim2.fromOffset(24, 24),
		BackgroundTransparency = 1,
		Text = "×",
		TextColor3 = a.Muted,
		TextSize = 22,
		FontFace = i.Bold,
		AutoButtonColor = false,
		Parent = m,
	})
	p.MouseEnter:Connect(function()
		b(p, { TextColor3 = a.Text }, 0.15)
	end)
	p.MouseLeave:Connect(function()
		b(p, { TextColor3 = a.Muted }, 0.2)
	end)
	if f.Content then
		d({
			Position = UDim2.fromOffset(n, 21),
			Size = UDim2.new(1, -n, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = f.Content,
			TextSize = 13,
			FontFace = i.Regular,
			TextColor3 = a.Muted,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.None,
			TextYAlignment = Enum.TextYAlignment.Top,
			Parent = m,
		})
	end
	local w = c(k, {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 16, 1, -8),
		Size = UDim2.new(1, -32, 0, 3),
		BackgroundColor3 = a.Surface3,
		BorderSizePixel = 0,
		Parent = g,
	})
	e(w, UDim.new(1, 0))
	local z = c(k, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = a.Accent, BorderSizePixel = 0, Parent = w })
	e(z, UDim.new(1, 0))
	task.defer(function()
		if j.Parent then
			b(j, { Size = UDim2.new(1, 0, 0, g.AbsoluteSize.Y) }, 0.3, Enum.EasingStyle.Quint)
		end
	end)
	b(r, { Position = UDim2.fromOffset(0, 0) }, 0.5, Enum.EasingStyle.Back)
	b(g, { GroupTransparency = 0 }, 0.3)
	b(v, { ImageTransparency = 0.6 }, 0.4)
	b(z, { Size = UDim2.fromScale(0, 1) }, u, Enum.EasingStyle.Linear)
	local A = false
	local function q()
		if A then
			return
		end
		A = true
		for a, b in ipairs(self._toasts) do
			if b == q then
				table.remove(self._toasts, a)
				break
			end
		end
		b(r, { Position = UDim2.fromOffset(320, 0) }, 0.3, Enum.EasingStyle.Quint)
		b(g, { GroupTransparency = 1 }, 0.2)
		b(B, { Transparency = 1 }, 0.15)
		b(v, { ImageTransparency = 1 }, 0.2)
		task.delay(0.22, function()
			j.ClipsDescendants = true
			b(j, { Size = UDim2.new(1, 0, 0, -4) }, 0.22, Enum.EasingStyle.Quint)
			task.delay(0.24, function()
				j:Destroy()
			end)
		end)
	end
	task.delay(u, q)
	p.MouseButton1Click:Connect(q)
	table.insert(self._toasts, q)
	while #self._toasts > self.MaxNotifications do
		local a = table.remove(self._toasts, 1)
		a()
	end
	return { Dismiss = q }
end
function g:Destroy()
	if self._destroyed then
		return
	end
	self._destroyed = true
	for a, b in ipairs(f.Windows) do
		if b == self then
			table.remove(f.Windows, a)
			break
		end
	end
	for b, a in ipairs(self._connections) do
		a:Disconnect()
	end
	self._connections = {}
	b(self.Scale, { Scale = 0.9 }, 0.2)
	b(self.Body, { GroupTransparency = 1 }, 0.2)
	b(self.BodyStroke, { Transparency = 1 }, 0.12)
	b(self.Shadow, { ImageTransparency = 1 }, 0.2)
	task.delay(0.22, function()
		self.Gui:Destroy()
	end)
end
return f
