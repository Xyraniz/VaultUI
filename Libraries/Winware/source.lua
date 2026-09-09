-- Winware UI library preserved for VaultUI.
-- Author: wxnvxa | License: MIT
-- Original repository: https://github.com/wxnvxa/winware-lib
--[[
    WinWare UI Library
    Author: wxnvxa
    License: MIT
    Repository: https://github.com/wxnvxa/winware-lib
]]

do
	local Constant = 'L'..'P'..'H'..'_NO_VIRTUALIZE';
	getfenv()[Constant] = getfenv()[Constant] or function(f) return f end;
end;

local WinWare = {};

WinWare.BuiltInRegular = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Regular,Enum.FontStyle.Normal);
WinWare.BuiltInBold = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Bold,Enum.FontStyle.Normal);
WinWare.MontserratMedium = Font.new('rbxasset://fonts/families/Montserrat.json',Enum.FontWeight.Medium,Enum.FontStyle.Normal);
WinWare.MontserratSemiBold = Font.new('rbxasset://fonts/families/Montserrat.json',Enum.FontWeight.SemiBold,Enum.FontStyle.Normal);
WinWare.MontserratBold = Font.new('rbxasset://fonts/families/Montserrat.json',Enum.FontWeight.Bold,Enum.FontStyle.Normal);

WinWare.TextMetricFont = Enum.Font.Montserrat;
WinWare.GlobalSignals = {};
WinWare.UnloadEnabled = false;

local TweenService: TweenService = cloneref(game:GetService('TweenService'));
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'));
local TextService: TextService = cloneref(game:GetService('TextService'));
local RunService: RunService = cloneref(game:GetService('RunService'));
local Players: Players = cloneref(game:GetService('Players'));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local LocalPlayer: Player = Players.LocalPlayer;
local CoreGui: PlayerGui = gethui();
local Mouse: Mouse = LocalPlayer:GetMouse();
local CurrentCamera: Camera = cloneref(workspace.CurrentCamera);
local GlobalWindow = Instance.new('ScreenGui');
local ManualTween = TweenInfo.new(0.1);
local SlowyTween = TweenInfo.new(0.220,Enum.EasingStyle.Quint,Enum.EasingDirection.Out);
local FastTween = TweenInfo.new(0.05);
local VSlowTween = TweenInfo.new(0.5,Enum.EasingStyle.Quint);
local WindowFadeTween = TweenInfo.new(0.320,Enum.EasingStyle.Quint,Enum.EasingDirection.Out);
local WindowPopTween = TweenInfo.new(0.440,Enum.EasingStyle.Back,Enum.EasingDirection.Out);
local WindowHideTween = TweenInfo.new(0.220,Enum.EasingStyle.Quint,Enum.EasingDirection.In);
local Encryption = {};

local function ResolveUserThumbnail(User)
	local fallback = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", User.UserId)
	local success, image = pcall(function()
		return Players:GetUserThumbnailAsync(User.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	end)

	if success and type(image) == "string" and image ~= "" then
		return image
	end

	return fallback
end

WinWare.UserName = LocalPlayer.Name
WinWare.UserProfile = ResolveUserThumbnail(LocalPlayer)
WinWare.RandomString = LPH_NO_VIRTUALIZE(function()
	return string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4));
end);

local PreviousWinWareGui = CoreGui:FindFirstChild("WinWareUI");
if PreviousWinWareGui then
	PreviousWinWareGui:Destroy();
end;

GlobalWindow.Name = "WinWareUI";
GlobalWindow.IgnoreGuiInset = true;
GlobalWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global;
GlobalWindow.ResetOnSpawn = false;
GlobalWindow.DisplayOrder = 9999999;
GlobalWindow.OnTopOfCoreBlur = true;
GlobalWindow.Parent = CoreGui;

WinWare.Scales = {
	Small = UDim2.fromOffset(540,380),
	Mobile = UDim2.fromOffset(640,385),
	Default = UDim2.fromOffset(834, 534),
	Large = UDim2.fromOffset(800 , 600)
};

WinWare.IconColor = Color3.fromRGB(255, 255, 255);
WinWare.ScreenGui = GlobalWindow;
WinWare.Flags = {};
WinWare.AccentColor = Color3.fromRGB(0, 86, 255);

WinWare.AccentRepaintFrom = nil;
WinWare.AccentRepaintQueued = false;

WinWare.RepaintAccent = LPH_NO_VIRTUALIZE(function(self , Previous , Color)
	local Objects = WinWare.ScreenGui:GetDescendants();
	local Locked = {};

	for _ , Object in next , Objects do
		if Object:GetAttribute("WinWareNoAccent") then
			Locked[Object] = true;
		end;
	end;

	local Same = function(Value)
		return math.abs(Value.R - Previous.R) < 0.004 and math.abs(Value.G - Previous.G) < 0.004 and math.abs(Value.B - Previous.B) < 0.004;
	end;

	local IsLocked = function(Object)
		local Current = Object;

		while Current and Current ~= WinWare.ScreenGui do
			if Locked[Current] then
				return true;
			end;

			Current = Current.Parent;
		end;

		return false;
	end;

	for _ , Object in next , Objects do
		if Object:IsA("UIStroke") then
			if Same(Object.Color) and not IsLocked(Object) then
				Object.Color = Color;
			end;
		elseif Object:IsA("GuiObject") then
			if Same(Object.BackgroundColor3) and not IsLocked(Object) then
				Object.BackgroundColor3 = Color;
			end;

			if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
				if Same(Object.TextColor3) and not IsLocked(Object) then
					Object.TextColor3 = Color;
				end;
			elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
				if Same(Object.ImageColor3) and not IsLocked(Object) then
					Object.ImageColor3 = Color;
				end;
			end;
		end;
	end;
end);

WinWare.SetAccentColor = LPH_NO_VIRTUALIZE(function(self , Color)
	if typeof(Color) == "string" then
		Color = Color3.fromHex((Color:gsub("#" , "")));
	end;

	if WinWare.AccentColor == Color then
		return;
	end;

	if not WinWare.AccentRepaintFrom then
		WinWare.AccentRepaintFrom = WinWare.AccentColor;
	end;

	WinWare.AccentColor = Color;

	if WinWare.AccentRepaintQueued then
		return;
	end;

	WinWare.AccentRepaintQueued = true;

	task.defer(LPH_NO_VIRTUALIZE(function()
		local Previous = WinWare.AccentRepaintFrom;

		WinWare.AccentRepaintFrom = nil;
		WinWare.AccentRepaintQueued = false;

		if Previous and Previous ~= WinWare.AccentColor then
			WinWare:RepaintAccent(Previous , WinWare.AccentColor);
		end;
	end));
end);
WinWare.MainColor = Color3.fromRGB(11, 11, 11);
WinWare.PopupSurfaceColor = Color3.fromRGB(11, 11, 11);
WinWare.PopupSurfaceTopColor = Color3.fromRGB(21, 21, 21);
WinWare.PopupStrokeColor = Color3.fromRGB(255, 255, 255);
WinWare.PopupStrokeTransparency = 0.93;
WinWare.RegisiteryColor = {};
WinWare.NameRegisitry = {};
WinWare.IsMosueOverOtherFrame = false;
WinWare.GlobalLogo = "rbxassetid://0";
WinWare.ImageColorMapping = "rbxassetid://4155801252";

do
	local winwareLink = "https://raw.githubusercontent.com/wxnvxa/winware-lib/main/assets/%s";
	local dir = 'WinWareAssets';

	if not isfolder(dir) then
		makefolder(dir);
	end;

	local LoadAsset = LPH_NO_VIRTUALIZE(function(name)
		local path = dir..'/'..name;

		if not isfile(path) then
			local response = request({
				Url = string.format(winwareLink , name),
				Method = 'GET'
			});

			writefile(path , response.Body);
			task.wait();
		end;

		return getcustomasset(path);
	end);

	local okLogo , logo = pcall(LoadAsset , 'winware.png');
	local okMapping , mapping = pcall(LoadAsset , 'saturation_value_gradient.png');

	if okLogo then
		WinWare.GlobalLogo = logo;
	end;

	if okMapping then
		WinWare.ImageColorMapping = mapping;
	end;
end;

function WinWare:AddSignal(RBXSignal)
	if WinWare.UnloadEnabled then
		table.insert(WinWare.GlobalSignals,RBXSignal);
	end;

	return RBXSignal;
end;

function WinWare:AddQuery(ItemRoot: Frame , Name : string)
	table.insert(WinWare.NameRegisitry , {
		Root = ItemRoot,
		Idx = Name,
	});
end;

function Encryption.new(data: string)
	local bytes = {};
	local encrypt_seed = ((#data + 3782) % 111) + 1;

	string.gsub(data , '.', LPH_NO_VIRTUALIZE(function(dt)
		table.insert(bytes , tostring(dt:byte() + encrypt_seed));
	end));

	local concatbyte = table.concat(bytes,'?');

	table.clear(bytes);

	return "{"..tostring(encrypt_seed + 72667).."}?"..concatbyte;
end;

function Encryption.reverse(data: string)
	local main_data = string.split(data,'?');
	local seed_str = main_data[1]:gsub('{',''):gsub('}','');
	local seed = tonumber(seed_str);

	local ks = {};
	local real_seed = seed - 72667;

	for i,v in next , main_data do
		if i > 1 then
			local fake_byte = tonumber(v);
			table.insert(ks , string.char(fake_byte - real_seed))	
		end;
	end;

	local data = table.concat(ks);

	table.clear(ks);

	return data;
end;

do
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

	WinWare.Base64Encode = LPH_NO_VIRTUALIZE(function(data)
		return ((data:gsub('.', function(x) 
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end);

	WinWare.Base64Decode = LPH_NO_VIRTUALIZE(function(data)
		data = string.gsub(data, '[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',(b:find(x)-1)
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end))
	end);
end;

WinWare.LoadIcon = LPH_NO_VIRTUALIZE(function()
	WinWare.RobloxIcon = {
		["3d-cube-arrow-left"] = "3d-cube-arrow-left",
		["amazon"] = "amazon",
		["arm-left"] = "arm-left",
		["arm-right"] = "arm-right",
		["arrow-curl-to-left"] = "arrow-curl-to-left",
		["arrow-curl-to-right"] = "arrow-curl-to-right",
		["arrow-down-to-line"] = "arrow-down-to-line",
		["arrow-large-down"] = "arrow-large-down",
		["arrow-large-left"] = "arrow-large-left",
		["arrow-large-right"] = "arrow-large-right",
		["arrow-large-up"] = "arrow-large-up",
		["arrow-right-from-portrait-rectangle"] = "arrow-right-from-portrait-rectangle",
		["arrow-right-to-portrait-rectangle"] = "arrow-right-to-portrait-rectangle",
		["arrow-rotate-down-dashed"] = "arrow-rotate-down-dashed",
		["arrow-rotate-right"] = "arrow-rotate-right",
		["arrow-rotate-right-dashed"] = "arrow-rotate-right-dashed",
		["arrow-small-down"] = "arrow-small-down",
		["arrow-small-left"] = "arrow-small-left",
		["arrow-small-right"] = "arrow-small-right",
		["arrow-small-up"] = "arrow-small-up",
		["arrow-spin-clockwise"] = "arrow-spin-clockwise",
		["arrow-spin-clockwise-10"] = "arrow-spin-clockwise-10",
		["arrow-spin-clockwise-15"] = "arrow-spin-clockwise-15",
		["arrow-spin-clockwise-30"] = "arrow-spin-clockwise-30",
		["arrow-spin-counter-clockwise-10"] = "arrow-spin-counter-clockwise-10",
		["arrow-spin-counter-clockwise-15"] = "arrow-spin-counter-clockwise-15",
		["arrow-spin-counter-clockwise-30"] = "arrow-spin-counter-clockwise-30",
		["arrow-thick-to-left"] = "arrow-thick-to-left",
		["arrow-thick-to-right"] = "arrow-thick-to-right",
		["arrow-up-from-landscape-rectangle"] = "arrow-up-from-landscape-rectangle",
		["arrow-up-right-from-square"] = "arrow-up-right-from-square",
		["arrow-wide-short-down"] = "arrow-wide-short-down",
		["arrow-wide-short-left"] = "arrow-wide-short-left",
		["arrow-wide-short-right"] = "arrow-wide-short-right",
		["arrow-wide-short-up"] = "arrow-wide-short-up",
		["arrows-small-directional"] = "arrows-small-directional",
		["audio-wave-dotted-line"] = "audio-wave-dotted-line",
		["backpack"] = "backpack",
		["beard"] = "beard",
		["bell"] = "bell",
		["bell-clock"] = "bell-clock",
		["bell-plus"] = "bell-plus",
		["bell-slash"] = "bell-slash",
		["belt"] = "belt",
		["binoculars"] = "binoculars",
		["book-closed"] = "book-closed",
		["bookmark"] = "bookmark",
		["bow-tie"] = "bow-tie",
		["building-store"] = "building-store",
		["bullet-flying"] = "bullet-flying",
		["butterfly-wings"] = "butterfly-wings",
		["calendar"] = "calendar",
		["calendar-plus"] = "calendar-plus",
		["calendar-star"] = "calendar-star",
		["camera-small"] = "camera-small",
		["caret-small-down"] = "caret-small-down",
		["caret-small-left"] = "caret-small-left",
		["caret-small-right"] = "caret-small-right",
		["caret-small-up"] = "caret-small-up",
		["chain-link"] = "chain-link",
		["chart-four-vertical-bars"] = "chart-four-vertical-bars",
		["chart-line"] = "chart-line",
		["chart-pie"] = "chart-pie",
		["chart-scatter-plot"] = "chart-scatter-plot",
		["chart-three-vertical-bars"] = "chart-three-vertical-bars",
		["check"] = "check",
		["check-large"] = "check-large",
		["check-small"] = "check-small",
		["chevron-large-down"] = "chevron-large-down",
		["chevron-large-down-to-line"] = "chevron-large-down-to-line",
		["chevron-large-left"] = "chevron-large-left",
		["chevron-large-left-to-line"] = "chevron-large-left-to-line",
		["chevron-large-right"] = "chevron-large-right",
		["chevron-large-right-to-line"] = "chevron-large-right-to-line",
		["chevron-large-up"] = "chevron-large-up",
		["chevron-large-up-to-line"] = "chevron-large-up-to-line",
		["chevron-small-down"] = "chevron-small-down",
		["chevron-small-down-to-line"] = "chevron-small-down-to-line",
		["chevron-small-left"] = "chevron-small-left",
		["chevron-small-left-to-line"] = "chevron-small-left-to-line",
		["chevron-small-right"] = "chevron-small-right",
		["chevron-small-right-to-line"] = "chevron-small-right-to-line",
		["chevron-small-up"] = "chevron-small-up",
		["chevron-small-up-to-line"] = "chevron-small-up-to-line",
		["circle-check"] = "circle-check",
		["circle-i"] = "circle-i",
		["circle-minus"] = "circle-minus",
		["circle-person"] = "circle-person",
		["circle-person-three-horizontal-bars-wrapping-right"] = "circle-person-three-horizontal-bars-wrapping-right",
		["circle-play"] = "circle-play",
		["circle-plus"] = "circle-plus",
		["circle-question"] = "circle-question",
		["circle-slash"] = "circle-slash",
		["circle-star"] = "circle-star",
		["circle-three-dots-horizontal"] = "circle-three-dots-horizontal",
		["circle-three-dots-vertical"] = "circle-three-dots-vertical",
		["circle-x"] = "circle-x",
		["clock"] = "clock",
		["clock-dashed"] = "clock-dashed",
		["clock-spin-reverse"] = "clock-spin-reverse",
		["clock-spin-reverse-dashed"] = "clock-spin-reverse-dashed",
		["clothes-hanger"] = "clothes-hanger",
		["cloud"] = "cloud",
		["cloud-arrow-down"] = "cloud-arrow-down",
		["code"] = "code",
		["compact-makeup-brush"] = "compact-makeup-brush",
		["compass"] = "compass",
		["controller-with-cog"] = "controller-with-cog",
		["crop"] = "crop",
		["crosshairs"] = "crosshairs",
		["crosshairs-slash"] = "crosshairs-slash",
		["cube-vertexes"] = "cube-vertexes",
		["curved-rectangle-megaphone"] = "curved-rectangle-megaphone",
		["diagonal-line-pattern"] = "diagonal-line-pattern",
		["diagonal-line-pattern-sticker"] = "diagonal-line-pattern-sticker",
		["diamond-simplified"] = "diamond-simplified",
		["discord"] = "discord",
		["disguise-nose-glasses"] = "disguise-nose-glasses",
		["document-circle-slash"] = "document-circle-slash",
		["document-list-heart"] = "document-list-heart",
		["door-open-arrow-to-bottom-right"] = "door-open-arrow-to-bottom-right",
		["dress"] = "dress",
		["dual-arrows-horizontal"] = "dual-arrows-horizontal",
		["dual-arrows-to-corners"] = "dual-arrows-to-corners",
		["dual-arrows-vertical"] = "dual-arrows-vertical",
		["envelope"] = "envelope",
		["eraser"] = "eraser",
		["eye"] = "eye",
		["eye-slash"] = "eye-slash",
		["eye-with-eyeliner"] = "eye-with-eyeliner",
		["eyebrows"] = "eyebrows",
		["eyelashes"] = "eyelashes",
		["face-winking"] = "face-winking",
		["facebook"] = "facebook",
		["file-box"] = "file-box",
		["fingerprint"] = "fingerprint",
		["flag"] = "flag",
		["flame"] = "flame",
		["folder"] = "folder",
		["fountain-pen-nib"] = "fountain-pen-nib",
		["four-bars-horizontal-center-aligned"] = "four-bars-horizontal-center-aligned",
		["four-bars-horizontal-chevron-left"] = "four-bars-horizontal-chevron-left",
		["four-bars-horizontal-chevron-right"] = "four-bars-horizontal-chevron-right",
		["four-bars-horizontal-justified-aligned"] = "four-bars-horizontal-justified-aligned",
		["four-bars-horizontal-left-aligned"] = "four-bars-horizontal-left-aligned",
		["four-bars-horizontal-right-aligned"] = "four-bars-horizontal-right-aligned",
		["frame-bubble-slash"] = "frame-bubble-slash",
		["frame-bubble-soundwave"] = "frame-bubble-soundwave",
		["frame-camera"] = "frame-camera",
		["frame-camera-center"] = "frame-camera-center",
		["frame-collapsed"] = "frame-collapsed",
		["frame-corners"] = "frame-corners",
		["frame-expanded"] = "frame-expanded",
		["frame-face"] = "frame-face",
		["frame-person-torso"] = "frame-person-torso",
		["frame-record"] = "frame-record",
		["frame-single-bar-horizontal"] = "frame-single-bar-horizontal",
		["frame-soundwave"] = "frame-soundwave",
		["frame-video-camera"] = "frame-video-camera",
		["gear"] = "gear",
		["generic-dpad"] = "generic-dpad",
		["gift-box"] = "gift-box",
		["gift-card"] = "gift-card",
		["glasses"] = "glasses",
		["globe-detailed"] = "globe-detailed",
		["globe-simplified"] = "globe-simplified",
		["globe-simplipfied-speech-bubble"] = "globe-simplipfied-speech-bubble",
		["grid"] = "grid",
		["guilded"] = "guilded",
		["hack-week"] = "hack-week",
		["hammer-code"] = "hammer-code",
		["hand-curved-arrow-left"] = "hand-curved-arrow-left",
		["hand-dual-arrows"] = "hand-dual-arrows",
		["hand-ellipse"] = "hand-ellipse",
		["hand-half-ellipse"] = "hand-half-ellipse",
		["hand-two-arrows-horizontal"] = "hand-two-arrows-horizontal",
		["hashtag"] = "hashtag",
		["hat-fedora"] = "hat-fedora",
		["hat-toque"] = "hat-toque",
		["head-blank"] = "head-blank",
		["head-blush"] = "head-blush",
		["head-female"] = "head-female",
		["head-freckles"] = "head-freckles",
		["head-lips"] = "head-lips",
		["head-male"] = "head-male",
		["headphones"] = "headphones",
		["headphones-arrow-up"] = "headphones-arrow-up",
		["headphones-arrow-up-lock"] = "headphones-arrow-up-lock",
		["headphones-slash"] = "headphones-slash",
		["headphones-x"] = "headphones-x",
		["headphones-x-lock"] = "headphones-x-lock",
		["heart"] = "heart",
		["house"] = "house",
		["image"] = "image",
		["image-stacked"] = "image-stacked",
		["instagram"] = "instagram",
		["jacket"] = "jacket",
		["key"] = "key",
		["key-alt"] = "key-alt",
		["key-apostrophe"] = "key-apostrophe",
		["key-arrow-down"] = "key-arrow-down",
		["key-arrow-right"] = "key-arrow-right",
		["key-arrow-up"] = "key-arrow-up",
		["key-asterisk"] = "key-asterisk",
		["key-backspace"] = "key-backspace",
		["key-caps-lock"] = "key-caps-lock",
		["key-caret"] = "key-caret",
		["key-comma"] = "key-comma",
		["key-command"] = "key-command",
		["key-control"] = "key-control",
		["key-grave-accent"] = "key-grave-accent",
		["key-period"] = "key-period",
		["key-return"] = "key-return",
		["key-shift"] = "key-shift",
		["key-space"] = "key-space",
		["key-tab"] = "key-tab",
		["language-characters"] = "language-characters",
		["leg-left"] = "leg-left",
		["leg-right"] = "leg-right",
		["lightning-bolt"] = "lightning-bolt",
		["linkedin"] = "linkedin",
		["lips"] = "lips",
		["lipstick"] = "lipstick",
		["list-bulleted"] = "list-bulleted",
		["location-pin"] = "location-pin",
		["location-pin-map"] = "location-pin-map",
		["lock-closed"] = "lock-closed",
		["lollipop"] = "lollipop",
		["magnifying-glass"] = "magnifying-glass",
		["magnifying-glass-minus"] = "magnifying-glass-minus",
		["magnifying-glass-plus"] = "magnifying-glass-plus",
		["mascara"] = "mascara",
		["megaphone"] = "megaphone",
		["memory-card"] = "memory-card",
		["messenger"] = "messenger",
		["microphone"] = "microphone",
		["microphone-slash"] = "microphone-slash",
		["microphone-text-box"] = "microphone-text-box",
		["microphone-triangle-exclamation"] = "microphone-triangle-exclamation",
		["minus"] = "minus",
		["minus-small"] = "minus-small",
		["mirror-standing"] = "mirror-standing",
		["moments"] = "moments",
		["moon"] = "moon",
		["mouse-button-left"] = "mouse-button-left",
		["mouse-button-right"] = "mouse-button-right",
		["mouse-scrollwheel"] = "mouse-scrollwheel",
		["music-note"] = "music-note",
		["nebula"] = "nebula",
		["necklace"] = "necklace",
		["nine-dots-grid"] = "nine-dots-grid",
		["ninja"] = "ninja",
		["nose"] = "nose",
		["page"] = "page",
		["paint-brush"] = "paint-brush",
		["paint-bucket"] = "paint-bucket",
		["pants"] = "pants",
		["pants-2d-text"] = "pants-2d-text",
		["paper-airplane"] = "paper-airplane",
		["parrot"] = "parrot",
		["pause-large"] = "pause-large",
		["pause-small"] = "pause-small",
		["pencil"] = "pencil",
		["pencil-square"] = "pencil-square",
		["person"] = "person",
		["person-arrow-from-bottom-right"] = "person-arrow-from-bottom-right",
		["person-check"] = "person-check",
		["person-circle-slash"] = "person-circle-slash",
		["person-climbing"] = "person-climbing",
		["person-clock"] = "person-clock",
		["person-falling"] = "person-falling",
		["person-graduate"] = "person-graduate",
		["person-jumping"] = "person-jumping",
		["person-magnifying-glass"] = "person-magnifying-glass",
		["person-photo-camera"] = "person-photo-camera",
		["person-play"] = "person-play",
		["person-play-clock"] = "person-play-clock",
		["person-plus"] = "person-plus",
		["person-racing"] = "person-racing",
		["person-running"] = "person-running",
		["person-standing"] = "person-standing",
		["person-standing-arrow-reverse"] = "person-standing-arrow-reverse",
		["person-standing-dual-arrows-vertical"] = "person-standing-dual-arrows-vertical",
		["person-standing-gear"] = "person-standing-gear",
		["person-swimming"] = "person-swimming",
		["person-teleport"] = "person-teleport",
		["person-trash-can"] = "person-trash-can",
		["person-walking"] = "person-walking",
		["person-with-smaller-person"] = "person-with-smaller-person",
		["phone"] = "phone",
		["phone-down"] = "phone-down",
		["phone-plus"] = "phone-plus",
		["phone-volume"] = "phone-volume",
		["phone-x"] = "phone-x",
		["photo-camera"] = "photo-camera",
		["photo-camera-face"] = "photo-camera-face",
		["photo-camera-slash"] = "photo-camera-slash",
		["picture-in-picture"] = "picture-in-picture",
		["pig"] = "pig",
		["pin"] = "pin",
		["pin-slash"] = "pin-slash",
		["play-large"] = "play-large",
		["play-small"] = "play-small",
		["plus-large"] = "plus-large",
		["plus-small"] = "plus-small",
		["premium"] = "premium",
		["ps-circle"] = "ps-circle",
		["ps-dpad-down"] = "ps-dpad-down",
		["ps-dpad-left"] = "ps-dpad-left",
		["ps-dpad-right"] = "ps-dpad-right",
		["ps-dpad-up"] = "ps-dpad-up",
		["ps-l1"] = "ps-l1",
		["ps-l2"] = "ps-l2",
		["ps-l3"] = "ps-l3",
		["ps-r1"] = "ps-r1",
		["ps-r2"] = "ps-r2",
		["ps-r3"] = "ps-r3",
		["ps-square"] = "ps-square",
		["ps-stick-left"] = "ps-stick-left",
		["ps-stick-right"] = "ps-stick-right",
		["ps-triagle"] = "ps-triagle",
		["ps-x"] = "ps-x",
		["ps4-options"] = "ps4-options",
		["ps4-share"] = "ps4-share",
		["ps4-touchpad"] = "ps4-touchpad",
		["ps5-options"] = "ps5-options",
		["ps5-share"] = "ps5-share",
		["ps5-touchpad"] = "ps5-touchpad",
		["pumpkin"] = "pumpkin",
		["purse"] = "purse",
		["rectangle-list"] = "rectangle-list",
		["rectangle-numbers-counting"] = "rectangle-numbers-counting",
		["rectangle-person-with-three-horizontal-lines"] = "rectangle-person-with-three-horizontal-lines",
		["robux"] = "robux",
		["rosette-seven-point"] = "rosette-seven-point",
		["rosette-ten-point"] = "rosette-ten-point",
		["seven-point-rosette"] = "seven-point-rosette",
		["shield-check"] = "shield-check",
		["shield-lock"] = "shield-lock",
		["shirt"] = "shirt",
		["shirt-2d-text"] = "shirt-2d-text",
		["shirt-pants"] = "shirt-pants",
		["shoe-left"] = "shoe-left",
		["shoe-right"] = "shoe-right",
		["shopping-basket"] = "shopping-basket",
		["shopping-basket-check"] = "shopping-basket-check",
		["shopping-cart"] = "shopping-cart",
		["shorts"] = "shorts",
		["sidebar"] = "sidebar",
		["signal-exclamation"] = "signal-exclamation",
		["six-dots-two-column-grid"] = "six-dots-two-column-grid",
		["skip-end-large"] = "skip-end-large",
		["skip-end-small"] = "skip-end-small",
		["skip-next-large"] = "skip-next-large",
		["skip-next-small"] = "skip-next-small",
		["skip-previous-large"] = "skip-previous-large",
		["skip-previous-small"] = "skip-previous-small",
		["skip-start-large"] = "skip-start-large",
		["skip-start-small"] = "skip-start-small",
		["smartphone-portrait"] = "smartphone-portrait",
		["speaker"] = "speaker",
		["speaker-slash"] = "speaker-slash",
		["speaker-triangle-exclamation"] = "speaker-triangle-exclamation",
		["speaker-x"] = "speaker-x",
		["speech-bubble-align-center"] = "speech-bubble-align-center",
		["speech-bubble-align-left"] = "speech-bubble-align-left",
		["speech-bubble-exclamation"] = "speech-bubble-exclamation",
		["speech-bubble-round"] = "speech-bubble-round",
		["square-bone"] = "square-bone",
		["square-books"] = "square-books",
		["square-check"] = "square-check",
		["square-code"] = "square-code",
		["square-dashed-person-standing"] = "square-dashed-person-standing",
		["square-dual-arrows-horizontal"] = "square-dual-arrows-horizontal",
		["square-dual-arrows-to-corner"] = "square-dual-arrows-to-corner",
		["square-face-sound"] = "square-face-sound",
		["square-face-waving-hand"] = "square-face-waving-hand",
		["square-face-winking"] = "square-face-winking",
		["square-minus"] = "square-minus",
		["square-person"] = "square-person",
		["squares-grid-plus"] = "squares-grid-plus",
		["squares-grid-qr"] = "squares-grid-qr",
		["stacked-squares-arrow-down-left"] = "stacked-squares-arrow-down-left",
		["stacked-squares-arrow-up-right"] = "stacked-squares-arrow-up-right",
		["stacked-squares-plus"] = "stacked-squares-plus",
		["star"] = "star",
		["stop-large"] = "stop-large",
		["stop-small"] = "stop-small",
		["studio"] = "studio",
		["sun"] = "sun",
		["sweater"] = "sweater",
		["sword"] = "sword",
		["tag-sparkle"] = "tag-sparkle",
		["teletype"] = "teletype",
		["tencent-qq"] = "tencent-qq",
		["text-b-bold"] = "text-b-bold",
		["text-box-microphone"] = "text-box-microphone",
		["text-h-subscript-1"] = "text-h-subscript-1",
		["text-h-subscript-2"] = "text-h-subscript-2",
		["text-h-subscript-3"] = "text-h-subscript-3",
		["text-i-italic"] = "text-i-italic",
		["text-s-strikethrough"] = "text-s-strikethrough",
		["text-u-underline"] = "text-u-underline",
		["text-uppercase-a-lowercase-a"] = "text-uppercase-a-lowercase-a",
		["text-x-subscript-2"] = "text-x-subscript-2",
		["text-x-superscript-2"] = "text-x-superscript-2",
		["three-bars-horizontal"] = "three-bars-horizontal",
		["three-bars-horizontal-chevron-left"] = "three-bars-horizontal-chevron-left",
		["three-bars-horizontal-narrowing"] = "three-bars-horizontal-narrowing",
		["three-bars-horizontal-triangles-vertical"] = "three-bars-horizontal-triangles-vertical",
		["three-bars-vertical-triangles-horizontal"] = "three-bars-vertical-triangles-horizontal",
		["three-chevrons-enlarging-down"] = "three-chevrons-enlarging-down",
		["three-chevrons-enlarging-up"] = "three-chevrons-enlarging-up",
		["three-dots-horizontal"] = "three-dots-horizontal",
		["three-dots-vertical"] = "three-dots-vertical",
		["three-horizontal-bars-wrapping-right"] = "three-horizontal-bars-wrapping-right",
		["three-people"] = "three-people",
		["three-ring-note"] = "three-ring-note",
		["three-sliders-horizontal"] = "three-sliders-horizontal",
		["three-stacked-squares-tilted"] = "three-stacked-squares-tilted",
		["thumb-down"] = "thumb-down",
		["thumb-up"] = "thumb-up",
		["tik-tok"] = "tik-tok",
		["tilt"] = "tilt",
		["torso"] = "torso",
		["trash-can"] = "trash-can",
		["triangle-exclamation"] = "triangle-exclamation",
		["trophy"] = "trophy",
		["tshirt"] = "tshirt",
		["tshirt-2d-text"] = "tshirt-2d-text",
		["tshirt-dual-arrows"] = "tshirt-dual-arrows",
		["twitch"] = "twitch",
		["twitter"] = "twitter",
		["two-arrows-down-and-up"] = "two-arrows-down-and-up",
		["two-arrows-from-center"] = "two-arrows-from-center",
		["two-arrows-left-right"] = "two-arrows-left-right",
		["two-arrows-loop-clockwise"] = "two-arrows-loop-clockwise",
		["two-arrows-loop-clockwise-1"] = "two-arrows-loop-clockwise-1",
		["two-arrows-loop-clockwise-infinity"] = "two-arrows-loop-clockwise-infinity",
		["two-arrows-spin-clockwise"] = "two-arrows-spin-clockwise",
		["two-arrows-spin-clockwise-plus"] = "two-arrows-spin-clockwise-plus",
		["two-arrows-switch-right"] = "two-arrows-switch-right",
		["two-arrows-to-center"] = "two-arrows-to-center",
		["two-folders"] = "two-folders",
		["two-location-pins-connecting-arrow"] = "two-location-pins-connecting-arrow",
		["two-makeup-brushes"] = "two-makeup-brushes",
		["two-people"] = "two-people",
		["two-people-speech-bubble"] = "two-people-speech-bubble",
		["two-stacked-squares"] = "two-stacked-squares",
		["two-switches-horizontal"] = "two-switches-horizontal",
		["verified-backplate"] = "verified-backplate",
		["verified-check"] = "verified-check",
		["verified-mono"] = "verified-mono",
		["video-camera"] = "video-camera",
		["video-camera-arrow-to-bottom-left"] = "video-camera-arrow-to-bottom-left",
		["video-camera-arrow-to-top-right"] = "video-camera-arrow-to-top-right",
		["video-camera-slash"] = "video-camera-slash",
		["video-camera-triangle-exclamation"] = "video-camera-triangle-exclamation",
		["video-camera-x"] = "video-camera-x",
		["wallet"] = "wallet",
		["we-chat"] = "we-chat",
		["whatsapp"] = "whatsapp",
		["x"] = "x",
		["x-small"] = "x-small",
		["xbox-a"] = "xbox-a",
		["xbox-a-pressed"] = "xbox-a-pressed",
		["xbox-a-unpressed"] = "xbox-a-unpressed",
		["xbox-b"] = "xbox-b",
		["xbox-dpad"] = "xbox-dpad",
		["xbox-dpad-down"] = "xbox-dpad-down",
		["xbox-dpad-left"] = "xbox-dpad-left",
		["xbox-dpad-right"] = "xbox-dpad-right",
		["xbox-dpad-up"] = "xbox-dpad-up",
		["xbox-lb"] = "xbox-lb",
		["xbox-lt"] = "xbox-lt",
		["xbox-menu"] = "xbox-menu",
		["xbox-rb"] = "xbox-rb",
		["xbox-rt"] = "xbox-rt",
		["xbox-stick-left"] = "xbox-stick-left",
		["xbox-stick-left-directional"] = "xbox-stick-left-directional",
		["xbox-stick-left-horizontal"] = "xbox-stick-left-horizontal",
		["xbox-stick-left-vertical"] = "xbox-stick-left-vertical",
		["xbox-stick-right"] = "xbox-stick-right",
		["xbox-stick-right-directional"] = "xbox-stick-right-directional",
		["xbox-stick-right-horizontal"] = "xbox-stick-right-horizontal",
		["xbox-stick-right-vertical"] = "xbox-stick-right-vertical",
		["xbox-view"] = "xbox-view",
		["xbox-x"] = "xbox-x",
		["xbox-y"] = "xbox-y",
		["xr-headset"] = "xr-headset",
		["youtube"] = "youtube"
	};
end);

WinWare.IsMouseOverFrame = LPH_NO_VIRTUALIZE(function(self , Frame)
	if not Frame then
		return;
	end;

	if WinWare.Global3DRenderMode then
		if Frame.GuiState == Enum.GuiState.Hover or Frame.GuiState == Enum.GuiState.Press then
			return true;
		end;

		return false;
	end;

	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end);

WinWare.CreateSignal = LPH_NO_VIRTUALIZE(function(self , DefaultValue)
	local __cache = Instance.new('BindableEvent');
	local bind = {
		Value = DefaultValue,
		__event = __cache
	};

	function bind:GetValue()
		return bind.Value;
	end;

	function bind:SetValue(f)
		bind.Value = f;

		return __cache:Fire(f);
	end;

	function bind:Connect(f)
		local signal = __cache.Event:Connect(f);

		WinWare:AddSignal(signal);

		return signal;
	end;

	return bind;
end);

WinWare.SetIconMode = LPH_NO_VIRTUALIZE(function(self , Label: TextLabel , Icon: string)
	local useBold = string.lower(string.sub(Icon , -5)) == '-bold';

	if useBold then
		Label.Text = Icon:sub(1,-6);
		Label.FontFace = WinWare.BuiltInBold;
	else
		Label.Text = Icon;
		Label.FontFace = WinWare.BuiltInRegular;
	end;
end);

function WinWare:GetIconFont(icon: string)
	local useBold = string.lower(string.sub(icon , -5)) == '-bold';

	if useBold then
		return WinWare.BuiltInBold;
	end;

	return WinWare.BuiltInRegular;
end;

function WinWare:MoreThanHalfY(Value: number)
	return (WinWare.ScreenGui.AbsoluteSize.Y / 2) < Value
end;

WinWare.IsStudio = RunService:IsStudio();
WinWare.IsMobile = UserInputService.TouchEnabled;

WinWare.CreateInput = LPH_NO_VIRTUALIZE(function(self , Frame , Callback)
	local Button = Instance.new('ImageButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.ImageTransparency = 1;
	Button.Image = "rbxasset://textuers/translateIcon.png";

	if Callback then
		local bth_signal = Button.MouseButton1Click:Connect(Callback);

		return Button , bth_signal;
	end;

	return Button;
end);

WinWare.PlayAnimate = LPH_NO_VIRTUALIZE(function(Self , Info , Property)
	local Tween = TweenService:Create(Self , Info or TweenInfo.new(0.25) , Property);

	Tween:Play();

	return Tween;
end);

local function ApplyPopupGradient(Parent)
	local Gradient = Instance.new("UIGradient")
	Gradient.Name = "WinWarePopupGradient"
	Gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, WinWare.PopupSurfaceTopColor),
		ColorSequenceKeypoint.new(1, WinWare.PopupSurfaceColor),
	})
	Gradient.Rotation = 90
	Gradient.Parent = Parent
	return Gradient
end;

function WinWare:EnableTextShimmer(Label: TextLabel, Gradient: UIGradient, Options)
	if not Label or not Label:IsA("TextLabel") or not Gradient or not Gradient:IsA("UIGradient") then
		return;
	end;

	Options = Options or {};

	local BaseColor = Options.BaseColor;
	local BaseBrightness = math.clamp(Options.BaseBrightness or 0.4, 0, 1);
	local PeakColors = Options.PeakColors;
	local ColorMode = Options.ColorMode or "flow";
	local BandCountConfig = Options.BandCount or 0.6;
	local BandWidth = Options.BandWidth or 0.7;
	local SweepTime = Options.SweepTime or 1.5;
	local Rotation = Options.Rotation or 0;
	local FitToText = Options.FitToText ~= false;

	local MaxKeypoints = 20;
	local MaxBandsOnFrame = 5;
	local Epsilon = 1e-3;
	local OriginalColor = Label.TextColor3;
	local HasPalette = PeakColors ~= nil and #PeakColors > 0;
	local Base;

	if HasPalette or BaseColor then
		Label.TextColor3 = Color3.new(1, 1, 1);
		Base = BaseColor or Color3.new(
			OriginalColor.R * BaseBrightness,
			OriginalColor.G * BaseBrightness,
			OriginalColor.B * BaseBrightness
		);

		if not HasPalette then
			PeakColors = { Color3.new(1, 1, 1) };
		end;
	else
		Base = Color3.new(BaseBrightness, BaseBrightness, BaseBrightness);
		PeakColors = { Color3.new(1, 1, 1) };
	end;

	local PaletteCount = #PeakColors;
	local FlowMode = ColorMode == "flow";
	local SpreadMode = ColorMode == "spread";
	local Animated = SweepTime > 0;

	local FlowColors = table.clone(PeakColors);
	if FlowMode and Animated and #FlowColors > 1 then
		table.insert(FlowColors, FlowColors[1]);
	end;

	local FlowOffsets = {};
	for index = 1, #FlowColors do
		FlowOffsets[index] = (#FlowColors > 1) and (index - 1) / (#FlowColors - 1) or 0;
	end;

	local BandCount;
	if FlowMode then
		BandCount = math.clamp(BandCountConfig, 0.25, 3);
	else
		BandCount = math.clamp(math.floor(BandCountConfig), 1, 3);
	end;

	local MinPeriod = FlowMode
		and (#FlowOffsets / (MaxKeypoints - 2))
		or (1 / MaxBandsOnFrame);

	Gradient.Rotation = Rotation;

	local phase = 0;
	local wraps = 0;

	local function smoothstep(value)
		return value * value * (3 - 2 * value);
	end;

	local function sampleList(List, value)
		local count = #List;
		if count == 1 then
			return List[1];
		end;

		local scaled = math.clamp(value, 0, 1) * (count - 1);
		local index = math.floor(scaled);
		local from = List[index + 1];
		local to = List[math.min(index + 2, count)];
		return from:Lerp(to, scaled - index);
	end;

	local function colorAt(position, period, halfWidth)
		if FlowMode then
			return sampleList(FlowColors, ((position - phase) % period) / period);
		end;

		local index = math.floor((position - phase) / period + 0.5);
		local center = phase + index * period;
		local distance = math.abs(position - center);

		if distance >= halfWidth then
			return Base;
		end;

		local Peak;
		if SpreadMode then
			Peak = sampleList(PeakColors, (position - center + halfWidth) / (halfWidth * 2));
		else
			Peak = PeakColors[(index - wraps) % PaletteCount + 1];
		end;

		return Base:Lerp(Peak, smoothstep(1 - distance / halfWidth));
	end;

	local OffsetCache = {};
	local function offsetsFor(count)
		local cached = OffsetCache[count];
		if cached then
			return cached;
		end;

		local List = {};
		for index = 0, count - 1 do
			List[index + 1] = -1 + 2 * index / (count - 1);
		end;

		OffsetCache[count] = List;
		return List;
	end;

	local Times = {};
	local function build(period, halfWidth, samples, scale, anchorShift)
		table.clear(Times);

		local first = math.floor(-phase / period) - 1;
		local last = math.ceil((1 - phase) / period) + 1;

		for index = first, last do
			local anchor = phase + index * period + anchorShift;
			for _, offset in samples do
				local position = anchor + offset * scale;
				if position > Epsilon and position < 1 - Epsilon then
					table.insert(Times, position);
				end;
			end;
		end;

		table.sort(Times);

		local Keypoints = {
			ColorSequenceKeypoint.new(0, colorAt(0, period, halfWidth)),
		};
		local previous = 0;

		for _, position in Times do
			if #Keypoints >= MaxKeypoints - 1 then
				break;
			end;

			if position - previous >= Epsilon then
				table.insert(Keypoints, ColorSequenceKeypoint.new(position, colorAt(position, period, halfWidth)));
				previous = position;
			end;
		end;

		table.insert(Keypoints, ColorSequenceKeypoint.new(1, colorAt(1, period, halfWidth)));
		return ColorSequence.new(Keypoints);
	end;

	local RenderSignal = RunService.PreRender or RunService.RenderStepped;
	if not RenderSignal then
		return;
	end;

	local lastPhase, lastPeriod, lastHalfWidth;
	WinWare:AddSignal(RenderSignal:Connect(function(deltaTime)
		if not Label.Parent or not Label.Visible then
			return;
		end;

		local span = 1;
		if FitToText then
			span = math.clamp(Label.TextBounds.X / math.max(Label.AbsoluteSize.X, 1), 0.05, 1);
		end;

		local period = math.max(span / BandCount, MinPeriod);
		local halfWidth = math.max(period * 0.5 * math.clamp(BandWidth, 0.05, 1), 1e-4);

		if Animated then
			phase += (span / SweepTime) * deltaTime;
			while phase >= period do
				phase -= period;
				wraps = (wraps + 1) % PaletteCount;
			end;
		else
			phase = (1 - span) * 0.5;
		end;

		if phase == lastPhase and period == lastPeriod and halfWidth == lastHalfWidth then
			return;
		end;

		lastPhase, lastPeriod, lastHalfWidth = phase, period, halfWidth;

		local samples, scale, anchorShift;
		if FlowMode then
			samples, scale, anchorShift = FlowOffsets, period, 0;
		else
			local bandsOnFrame = math.ceil(1 / period) + 1;
			samples = offsetsFor(math.clamp(math.floor((MaxKeypoints - 2) / bandsOnFrame), 3, 9));
			scale, anchorShift = halfWidth, 0;
		end;

		Gradient.Color = build(period, halfWidth, samples, scale, anchorShift);
	end));
end;
function WinWare:EnableOverflowMarquee(Label: TextLabel, Options)
	if not Label or not Label:IsA("TextLabel") or Label:GetAttribute("WinWareMarqueeEnabled") then
		return;
	end;

	local fontFamily = "";
	pcall(function()
		fontFamily = Label.FontFace.Family;
	end);

	if string.find(fontFamily, "BuilderIcons", 1, true) then
		return;
	end;

	Options = Options or {};
	Label:SetAttribute("WinWareMarqueeEnabled", true);

	local HoverTarget = Options.HoverTarget or Label;
	local Hovered = false;
	local Active = false;
	local ActiveTween;
	local MarqueeViewport;
	local OriginalParent;
	local OriginalPosition;
	local OriginalSize;
	local OriginalAnchorPoint;
	local OriginalLayoutOrder;
	local OriginalZIndex;
	local OriginalAutomaticSize;
	local OriginalTextTruncate;
	local OriginalTextWrapped;
	local OriginalTextXAlignment;
	local StartGeneration = 0;

	local function GetVisibleWidth()
		if Options.GetVisibleWidth then
			local success, width = pcall(Options.GetVisibleWidth);
			if success and type(width) == "number" then
				return math.max(math.floor(width), 0);
			end;
		end;

		local width = Label.AbsoluteSize.X;
		if width <= 4 and Label.Parent and Label.Parent:IsA("GuiObject") then
			local Parent = Label.Parent;
			local leftOffset = Label.AbsolutePosition.X - Parent.AbsolutePosition.X;
			width = Parent.AbsoluteSize.X - leftOffset - 8;
		end;

		return math.max(math.floor(width), 0);
	end;

	local function GetTextWidth()
		local width = Label.TextBounds.X;
		local Params;

		pcall(function()
			Params = Instance.new("GetTextBoundsParams");
			Params.Text = Label.Text;
			Params.Font = Label.FontFace;
			Params.Size = Label.TextSize;
			Params.Width = 100000;
			width = TextService:GetTextBoundsAsync(Params).X;
		end);

		if Params then
			Params:Destroy();
		end;

		return math.ceil(width);
	end;

	local function Stop()
		StartGeneration = StartGeneration + 1;

		if not Active then
			return;
		end;

		Active = false;
		if ActiveTween then
			ActiveTween:Cancel();
			ActiveTween = nil;
		end;

		if OriginalParent and OriginalParent.Parent then
			Label.Parent = OriginalParent;
			Label.Position = OriginalPosition;
			Label.Size = OriginalSize;
			Label.AnchorPoint = OriginalAnchorPoint;
			Label.LayoutOrder = OriginalLayoutOrder;
			Label.ZIndex = OriginalZIndex;
			Label.AutomaticSize = OriginalAutomaticSize;
			Label.TextTruncate = OriginalTextTruncate;
			Label.TextWrapped = OriginalTextWrapped;
			Label.TextXAlignment = OriginalTextXAlignment;
		end;

		if MarqueeViewport then
			MarqueeViewport:Destroy();
			MarqueeViewport = nil;
		end;

		OriginalParent = nil;
		OriginalPosition = nil;
		OriginalSize = nil;
	end;

	local function Start()
		Stop();
		local Generation = StartGeneration;

		if not Hovered or not Label.Parent or not Label.Visible or Label.Text == "" or Label.TextTransparency >= 0.999 then
			return;
		end;

		local visibleWidth = GetVisibleWidth();
		local textWidth = GetTextWidth();
		if Generation ~= StartGeneration or not Hovered or not Label.Parent or visibleWidth <= 4 or textWidth <= visibleWidth + 1 then
			return;
		end;

		OriginalParent = Label.Parent;
		OriginalPosition = Label.Position;
		OriginalSize = Label.Size;
		OriginalAnchorPoint = Label.AnchorPoint;
		OriginalLayoutOrder = Label.LayoutOrder;
		OriginalZIndex = Label.ZIndex;
		OriginalAutomaticSize = Label.AutomaticSize;
		OriginalTextTruncate = Label.TextTruncate;
		OriginalTextWrapped = Label.TextWrapped;
		OriginalTextXAlignment = Label.TextXAlignment;

		local viewportSize = OriginalSize;
		if Label.AbsoluteSize.X <= 4 then
			viewportSize = UDim2.new(0, visibleWidth, OriginalSize.Y.Scale, OriginalSize.Y.Offset);
		end;

		MarqueeViewport = Instance.new("Frame");
		MarqueeViewport.Name = WinWare.RandomString();
		MarqueeViewport.BackgroundTransparency = 1;
		MarqueeViewport.BorderSizePixel = 0;
		MarqueeViewport.ClipsDescendants = true;
		MarqueeViewport.Position = OriginalPosition;
		MarqueeViewport.Size = viewportSize;
		MarqueeViewport.AnchorPoint = OriginalAnchorPoint;
		MarqueeViewport.LayoutOrder = OriginalLayoutOrder;
		MarqueeViewport.ZIndex = OriginalZIndex;
		MarqueeViewport.Parent = OriginalParent;

		Label.Parent = MarqueeViewport;
		Label.Active = false;
		Label.AnchorPoint = Vector2.zero;
		Label.AutomaticSize = Enum.AutomaticSize.None;
		Label.Position = UDim2.fromOffset(0, 0);
		Label.Size = UDim2.fromOffset(textWidth, math.max(Label.AbsoluteSize.Y, Label.TextSize + 2));
		Label.TextTruncate = Enum.TextTruncate.None;
		Label.TextWrapped = false;
		Label.TextXAlignment = Enum.TextXAlignment.Left;
		Label.ZIndex = OriginalZIndex + 1;

		Active = true;

		local overflow = textWidth - visibleWidth;
		local duration = math.clamp(overflow / 22, 2.4, 8);

		task.spawn(function()
			while Active and Hovered and Label.Parent == MarqueeViewport do
				local OutTween;
				local OutSuccess = pcall(function()
					OutTween = TweenService:Create(Label, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Position = UDim2.fromOffset(-overflow, 0),
					});
				end);

				if not OutSuccess or not OutTween or not Active or not Hovered or Label.Parent ~= MarqueeViewport then
					break;
				end;

				ActiveTween = OutTween;
				OutTween:Play();
				OutTween.Completed:Wait();

				if not Active or not Hovered or Label.Parent ~= MarqueeViewport then
					break;
				end;

				task.wait(0.45);

				if not Active or not Hovered or Label.Parent ~= MarqueeViewport then
					break;
				end;

				local BackTween;
				local BackSuccess = pcall(function()
					BackTween = TweenService:Create(Label, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Position = UDim2.fromOffset(0, 0),
					});
				end);

				if not BackSuccess or not BackTween or not Active or not Hovered or Label.Parent ~= MarqueeViewport then
					break;
				end;

				ActiveTween = BackTween;
				BackTween:Play();
				BackTween.Completed:Wait();

				if Active and Hovered then
					task.wait(0.45);
				end;
			end;
		end);
	end;

	WinWare:AddSignal(Label:GetPropertyChangedSignal("Text"):Connect(function()
		if Hovered then
			Stop();
			task.defer(Start);
		end;
	end));

	WinWare:AddSignal(HoverTarget.MouseEnter:Connect(function()
		Hovered = true;
		Start();
	end));

	WinWare:AddSignal(HoverTarget.MouseLeave:Connect(function()
		Hovered = false;
		Stop();
	end));

	WinWare:AddSignal(Label.AncestryChanged:Connect(function(_, Parent)
		if not Parent then
			Hovered = false;
			Stop();
		end;
	end));
end;

local function RegisterOverflowMarquee(Descendant)
	if not Descendant:IsA("TextLabel") then
		return;
	end;

	task.defer(function()
		if Descendant.Parent and not Descendant:GetAttribute("WinWareMarqueeEnabled") then
			local HoverTarget = Descendant.Parent:IsA("GuiObject") and Descendant.Parent or Descendant;

			WinWare:EnableOverflowMarquee(Descendant, {
				HoverTarget = HoverTarget,
			});
		end;
	end);
end;

WinWare:AddSignal(GlobalWindow.DescendantAdded:Connect(RegisterOverflowMarquee));

for _, Descendant in next, GlobalWindow:GetDescendants() do
	RegisterOverflowMarquee(Descendant);
end;

WinWare.Drag = LPH_NO_VIRTUALIZE(function(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;
	local Tween = TweenInfo.new(Speed);

	local updateInput = function(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		if WinWare.Global3DRenderMode then
			WinWare.PlayAnimate(MoveFrame,Tween,{
				Position = UDim2.fromScale(0.5,0.5)
			});
		else
			WinWare.PlayAnimate(MoveFrame,Tween,{
				Position = position
			});
		end;
	end;

	WinWare:AddSignal(InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true;
			dragStart = input.Position;
			startPos = MoveFrame.Position;

			local input_end;
			input_end = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;

					input_end:Disconnect();
				end
			end)
		end
	end));

	WinWare:AddSignal(UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end));
end);

WinWare.Rounding = LPH_NO_VIRTUALIZE(function(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end);

WinWare.ProcessParams = LPH_NO_VIRTUALIZE(function(self , Params , Fixed)
	Params = Params or {};

	local k = Params or {};

	for i,v in next , Fixed do
		k[i] = Params[i] or v;
	end;

	table.clear(Fixed);

	return k;
end);

WinWare.EnabledBlur = true;
WinWare.BlurModuleParent = workspace.CurrentCamera;

WinWare.GetCalculatePosition = LPH_NO_VIRTUALIZE(function(planePos, planeNormal, rayOrigin, rayDirection)
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;

	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;

	return rayOrigin + (a * rayDirection);
end);

WinWare.CreateBlurModule = LPH_NO_VIRTUALIZE(function(self , Frame , Signal)
	if not WinWare.EnabledBlur then
		return WinWare:AddSignal(Instance.new('BindableEvent').Event:Connect(function() return "ww"; end));
	end;

	local Part = Instance.new('Part',WinWare.BlurModuleParent);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = WinWare.RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = WinWare.RandomString();

	Part.Name = WinWare.RandomString();

	local disconnect;

	local UpdateFunction = function()
		local IsWindowActive = Signal:GetValue();

		if IsWindowActive and not WinWare.Global3DRenderMode then

			WinWare.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 1
			})

			WinWare.PlayAnimate(Part,TweenInfo.new(0.1),{
				Transparency = 0.97,
				Size = Vector3.new(1, 1, 1) * 0.01;
			})

			Part.Parent = WinWare.BlurModuleParent;
		else
			WinWare.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 0
			})

			WinWare.PlayAnimate(Part,TweenInfo.new(0.1),{
				Size = Vector3.zero,
				Transparency = 1.5,
			})

			Part.Parent = nil;

			return false;
		end;

		if IsWindowActive then
			local corner0 = Frame.AbsolutePosition;
			local corner1 = corner0 + Frame.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = WinWare.GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = WinWare.GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end;

	local rbxsignal = WinWare:AddSignal(CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction))
	local loopThread = WinWare:AddSignal(UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			pcall(UpdateFunction);
		end;
	end));

	local THREAD = task.spawn(function()
		while true do task.wait(0.1)
			pcall(UpdateFunction);
		end;
	end);

	disconnect = function()
		rbxsignal:Disconnect();
		loopThread:Disconnect();
		task.cancel(THREAD);
		Part:Destroy();
		DepthOfField:Destroy();
	end;

	Frame.Destroying:Connect(disconnect);

	WinWare.__BlurDisconnect = disconnect;

	return rbxsignal;
end);

WinWare.ApplyPopupSurface = LPH_NO_VIRTUALIZE(function(Frame , Transparency)
	Frame.BackgroundColor3 = WinWare.MainColor;
	Frame.BackgroundTransparency = Transparency or 0.06;

	local SurfaceSignal = {};

	function SurfaceSignal:GetValue()
		return Frame.Visible and Frame.BackgroundTransparency < 0.9 and Frame.AbsoluteSize.X > 4;
	end

	WinWare:CreateBlurModule(Frame , SurfaceSignal);

	return Frame;
end);

WinWare.ApplyStackedRow = LPH_NO_VIRTUALIZE(function(Handler , RowHeight , ControlHeight)
	local Row = Handler.Parent;

	if not Row or not Row:GetAttribute("ControlRow") then
		return;
	end;

	Row:SetAttribute("StackedRow" , true);
	Row.Size = UDim2.new(1, 0, 0, RowHeight);

	for _ , Item in ipairs(Row:GetChildren()) do
		if Item:IsA("TextLabel") then
			Item.Position = UDim2.new(0, 10, 0, 5);
			Item.Size = UDim2.new(1, -20, 0, RowHeight - ControlHeight - 11);
			Item.TextXAlignment = Enum.TextXAlignment.Center;
			Item.TextYAlignment = Enum.TextYAlignment.Center;
		end;
	end;

	Handler.AnchorPoint = Vector2.new(1, 1);
	Handler.Position = UDim2.new(1, -10, 1, -6);
	Handler.Size = UDim2.new(1, -20, 0, ControlHeight);
end);

local EmptyFunction = function() end;

function WinWare:RollingEffect(parent)
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.4), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient.Parent = parent

	return UIGradient;
end;

function WinWare:CreateShadow(parent , RollingEffect)
	local Shadow = {};

	local UIShadowSafe85 = Instance.new("UIStroke")
	local UIShadowSafe65 = Instance.new("UIStroke")
	local UIShadowSafe50 = Instance.new("UIStroke")
	local UIShadowSafe45 = Instance.new("UIStroke")

	UIShadowSafe85.Thickness = 6.000
	UIShadowSafe85.Transparency = 1
	UIShadowSafe85.Parent = parent

	UIShadowSafe65.Thickness = 5.000
	UIShadowSafe65.Transparency = 1
	UIShadowSafe65.Parent = parent

	UIShadowSafe50.Thickness = 4.000
	UIShadowSafe50.Transparency = 1
	UIShadowSafe50.Parent = parent

	UIShadowSafe45.Thickness = 3.000
	UIShadowSafe45.Transparency = 1
	UIShadowSafe45.Parent = parent

	local RollingEffectThread;
	local r1,r2,r3,r4;

	if RollingEffect then
		r1 = WinWare:RollingEffect(UIShadowSafe85);
		r2 = WinWare:RollingEffect(UIShadowSafe65);
		r3 = WinWare:RollingEffect(UIShadowSafe50);
		r4 = WinWare:RollingEffect(UIShadowSafe45);
	end;

	Shadow.Render = LPH_NO_VIRTUALIZE(function(self , value)
		if RollingEffectThread then
			task.cancel(RollingEffectThread);
			RollingEffectThread = nil;
		end;

		if value then
			WinWare.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 0.900
			})

			WinWare.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 0.900
			})

			WinWare.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 0.900
			})

			WinWare.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 0.900
			})

			if RollingEffect then
				RollingEffectThread = task.spawn(function()
					local level = 20;
					while true do task.wait(0.025)
						WinWare.PlayAnimate(r1 , SlowyTween , {
							Rotation = r1.Rotation + level
						});

						WinWare.PlayAnimate(r2 , SlowyTween , {
							Rotation = r2.Rotation + level
						});

						WinWare.PlayAnimate(r3 , SlowyTween , {
							Rotation = r3.Rotation + level
						});

						WinWare.PlayAnimate(r4 , SlowyTween , {
							Rotation = r4.Rotation + level
						});
					end;
				end);
			end;
		else
			WinWare.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 1
			})

			WinWare.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 1
			})

			WinWare.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 1
			})

			WinWare.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 1
			})
		end;
	end);

	return Shadow;
end;

function WinWare:CreateOptionWindow(Frame: Frame , Zindex)
	Zindex = Zindex or 9;

	local Window = {
		Signal = WinWare:CreateSignal(false),
	};

	local OptionHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")
	local UIStroke = Instance.new("UIStroke")
	local shadow = WinWare:CreateShadow(OptionHandler);

	OptionHandler.Name = WinWare.RandomString();
	OptionHandler.Parent = WinWare.ScreenGui
	OptionHandler.AnchorPoint = Vector2.new(0, 0)
	OptionHandler.BackgroundColor3 = WinWare.PopupSurfaceColor
	OptionHandler.BackgroundTransparency = 0.100
	WinWare.ApplyPopupSurface(OptionHandler , 0.040);
	OptionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OptionHandler.BorderSizePixel = 0
	OptionHandler.ClipsDescendants = true
	OptionHandler.Position = UDim2.new(255,255,255,255)
	OptionHandler.Size = UDim2.new(0, 220, 0, 75)
	OptionHandler.ZIndex = Zindex + 9

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = OptionHandler

	UIListLayout.Parent = OptionHandler
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UIStroke.Transparency = WinWare.PopupStrokeTransparency
	UIStroke.Color = WinWare.PopupStrokeColor
	UIStroke.Parent = OptionHandler
	ApplyPopupGradient(OptionHandler)

	WinWare:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		WinWare.PlayAnimate(OptionHandler , SlowyTween , {
			Size = UDim2.new(0, 220, 0, UIListLayout.AbsoluteContentSize.Y - 1)
		})
	end)));

	WinWare:AddSignal(OptionHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if OptionHandler.BackgroundTransparency > 0.9 then
			OptionHandler.Visible = false;
			UIListLayout.Parent = nil;
			OptionHandler.Parent = nil;
		else
			OptionHandler.Visible = true;
			UIListLayout.Parent = OptionHandler

			if WinWare.Global3DRenderMode then
				OptionHandler.Parent = WinWare.GlobalSurfaceGui;
			else
				OptionHandler.Parent = WinWare.ScreenGui;
			end;
		end
	end)));

	local FollowingThread;
	local SetPosition = LPH_NO_VIRTUALIZE(function()
		if WinWare:MoreThanHalfY(Frame.AbsolutePosition.Y + 65) then
			OptionHandler.AnchorPoint = Vector2.new(0,1)
		else
			OptionHandler.AnchorPoint = Vector2.new(0,0)
		end;

		OptionHandler.Position = UDim2.fromOffset(Frame.AbsolutePosition.X + 18 , Frame.AbsolutePosition.Y + 65);
	end);

	Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if FollowingThread then
			task.cancel(FollowingThread);
			FollowingThread = nil;
		end;

		if value then
			SetPosition();

			WinWare.PlayAnimate(OptionHandler , SlowyTween , {
				BackgroundTransparency = 0.100
			})

			WinWare.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = WinWare.PopupStrokeTransparency
			})

			shadow:Render(true);

			if WinWare.Global3DRenderMode then
				OptionHandler.Parent = WinWare.GlobalSurfaceGui;
			else
				OptionHandler.Parent = WinWare.ScreenGui;
			end;

			FollowingThread = task.spawn(function()
				while true do task.wait()
					SetPosition();
				end
			end)
		else
			WinWare.PlayAnimate(OptionHandler , SlowyTween , {
				BackgroundTransparency = 1
			})

			WinWare.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			shadow:Render(false);
		end;
	end);

	Window.SetRender(false);
	Window.Signal:Connect(Window.SetRender)

	local Payback = WinWare:RegisiterItem(OptionHandler , Window.Signal);

	Payback.Winbdow = Window;
	Payback.Root = OptionHandler;
	Payback.Signal = Window.Signal;

	return Payback;
end;

function WinWare:CreateModuleOptionWindow(Trigger: Frame, Zindex, Config)
	Config = WinWare:ProcessParams(Config, {
		Name = "Module",
		Width = 320,
		Height = 420,
	});

	local Window = {
		Signal = WinWare:CreateSignal(false),
	};

	local Root = Instance.new("Frame")
	local RootCorner = Instance.new("UICorner")
	local RootStroke = Instance.new("UIStroke")
	local Header = Instance.new("Frame")
	local Grip = Instance.new("TextLabel")
	local Title = Instance.new("TextLabel")
	local Close = Instance.new("TextLabel")
	local Divider = Instance.new("Frame")
	local Content = Instance.new("ScrollingFrame")
	local ContentLayout = Instance.new("UIListLayout")
	local ContentPadding = Instance.new("UIPadding")
	local Shadow = WinWare:CreateShadow(Root)

	Root.Name = WinWare.RandomString()
	Root.AnchorPoint = Vector2.new(0.5, 0.5)
	Root.BackgroundColor3 = WinWare.PopupSurfaceColor
	Root.BackgroundTransparency = 0.100
	WinWare.ApplyPopupSurface(Root , 0.040);
	Root.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Root.BorderSizePixel = 0
	Root.ClipsDescendants = true
	Root.Position = UDim2.fromScale(0.5, 0.5)
	Root.Size = UDim2.fromOffset(Config.Width, Config.Height)
	Root.Visible = false
	Root.ZIndex = Zindex + 100

	RootCorner.CornerRadius = UDim.new(0, 11)
	RootCorner.Parent = Root

	RootStroke.Color = WinWare.PopupStrokeColor
	RootStroke.Thickness = 1
	RootStroke.Transparency = WinWare.PopupStrokeTransparency
	RootStroke.Parent = Root
	ApplyPopupGradient(Root)

	Header.Name = WinWare.RandomString()
	Header.Parent = Root
	Header.BackgroundTransparency = 1
	Header.BorderSizePixel = 0
	Header.Size = UDim2.new(1, 0, 0, 54)
	Header.ZIndex = Root.ZIndex + 1

	Grip.Name = WinWare.RandomString()
	Grip.Parent = Header
	Grip.AnchorPoint = Vector2.new(0, 0.5)
	Grip.BackgroundTransparency = 1
	Grip.Position = UDim2.new(0, 12, 0.5, 0)
	Grip.Size = UDim2.fromOffset(22, 22)
	Grip.ZIndex = Header.ZIndex + 1
	Grip.FontFace = WinWare.BuiltInBold
	Grip.Text = "six-dots-two-column-grid"
	Grip.TextColor3 = Color3.fromRGB(145, 145, 145)
	Grip.TextSize = 14

	Title.Name = WinWare.RandomString()
	Title.Parent = Header
	Title.AnchorPoint = Vector2.new(0, 0.5)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 42, 0.5, 0)
	Title.Size = UDim2.new(1, -86, 0, 24)
	Title.ZIndex = Header.ZIndex + 1
	Title.FontFace = WinWare.MontserratSemiBold
	Title.Text = Config.Name
	Title.TextColor3 = Color3.fromRGB(206, 206, 206)
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left

	Close.Name = WinWare.RandomString()
	Close.Parent = Header
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundTransparency = 1
	Close.Position = UDim2.new(1, -13, 0.5, 0)
	Close.Size = UDim2.fromOffset(24, 24)
	Close.ZIndex = Header.ZIndex + 2
	Close.FontFace = WinWare.BuiltInRegular
	Close.Text = "x"
	Close.TextColor3 = Color3.fromRGB(145, 145, 145)
	Close.TextSize = 16

	Divider.Name = WinWare.RandomString()
	Divider.Parent = Root
	Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Divider.BackgroundTransparency = 0.95
	Divider.BorderSizePixel = 0
	Divider.Position = UDim2.fromOffset(0, 54)
	Divider.Size = UDim2.new(1, 0, 0, 1)
	Divider.ZIndex = Root.ZIndex + 1

	Content.Name = WinWare.RandomString()
	Content.Parent = Root
	Content.Active = true
	Content.BackgroundTransparency = 1
	Content.BorderSizePixel = 0
	Content.Position = UDim2.fromOffset(0, 55)
	Content.Size = UDim2.new(1, 0, 1, -55)
	Content.CanvasSize = UDim2.fromOffset(0, 0)
	Content.ScrollBarThickness = 2
	Content.ScrollBarImageColor3 = Color3.fromRGB(76, 76, 76)
	Content.ZIndex = Root.ZIndex + 1

	ContentPadding.PaddingTop = UDim.new(0, 4)
	ContentPadding.PaddingBottom = UDim.new(0, 8)
	ContentPadding.PaddingLeft = UDim.new(0, 8)
	ContentPadding.PaddingRight = UDim.new(0, 8)
	ContentPadding.Parent = Content

	ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Parent = Content

	WinWare:AddSignal(ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Content.CanvasSize = UDim2.fromOffset(0, ContentLayout.AbsoluteContentSize.Y + 12)
	end))

	WinWare.Drag(Header, Root, 0.15)
	WinWare:CreateInput(Close, function()
		Window.Signal:SetValue(false)
	end)

	Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			Root.Parent = WinWare.Global3DRenderMode and WinWare.GlobalSurfaceGui or WinWare.ScreenGui
			Root.Visible = true
			Root.Size = UDim2.fromOffset(Config.Width - 8, Config.Height - 8)

			local MainFrame = WinWare.MainWindowFrame;

			if MainFrame and MainFrame.Parent then
				local FramePosition = MainFrame.AbsolutePosition;
				local FrameSize = MainFrame.AbsoluteSize;
				local Viewport = WinWare.ScreenGui.AbsoluteSize;
				local TargetX = FramePosition.X + FrameSize.X + 14 + (Config.Width / 2);
				local TargetY = FramePosition.Y + (Config.Height / 2);

				if Viewport.X > 0 and TargetX + (Config.Width / 2) > Viewport.X - 8 then
					TargetX = FramePosition.X - 14 - (Config.Width / 2);
				end

				if Viewport.Y > 0 then
					local MinY = (Config.Height / 2) + 8;
					local MaxY = math.max(MinY, Viewport.Y - (Config.Height / 2) - 8);
					TargetY = math.clamp(TargetY, MinY, MaxY);
				end

				Root.Position = UDim2.fromOffset(TargetX, TargetY);
			end
			WinWare.PlayAnimate(Root, SlowyTween, {
				BackgroundTransparency = 0.100,
				Size = UDim2.fromOffset(Config.Width, Config.Height),
			})
			WinWare.PlayAnimate(RootStroke, SlowyTween, { Transparency = WinWare.PopupStrokeTransparency })
			Shadow:Render(true)
		else
			WinWare.PlayAnimate(Root, SlowyTween, {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(Config.Width - 8, Config.Height - 8),
			})
			WinWare.PlayAnimate(RootStroke, SlowyTween, { Transparency = 1 })
			Shadow:Render(false)
			task.delay(0.18, function()
				if not Window.Signal:GetValue() then
					Root.Visible = false
					Root.Parent = nil
				end
			end)
		end
	end)

	Window.Signal:Connect(Window.SetRender)
	Window.SetRender(false)

	local Controls = WinWare:RegisiterItem(Content, Window.Signal)
	Controls.Winbdow = Window
	Controls.Root = Root
	Controls.Signal = Window.Signal

	function Controls:SetTitle(name)
		Title.Text = tostring(name or "Module")
	end

	function Controls:AddSlider(Config)
		Config = Config or {}
		local Row = Controls:AddLabel(Config.Name or "Slider")
		return Row:AddSlider({
			Default = Config.Default,
			Min = Config.Min,
			Max = Config.Max,
			Type = Config.Type,
			Rounding = Config.Rounding,
			Nums = Config.Nums,
			Flag = Config.Flag,
			Callback = Config.Callback,
			Size = Config.Size or 160,
			Compact = true,
		})
	end

	function Controls:AddToggle(Config)
		Config = Config or {}
		local Row = Controls:AddLabel(Config.Name or "Toggle")
		return Row:AddToggle({
			Default = Config.Default,
			Flag = Config.Flag,
			Callback = Config.Callback,
			Compact = true,
		})
	end

	return Controls
end

function WinWare:CreateColorPicker(HandleFrame: Frame)
	local ZIndex = HandleFrame.ZIndex;

	local ColorPickerLib = {};

	local ColorPickerHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local SaViMap = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local ColorZoneSelection = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorMap = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local ColorMapSelection = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local RGBLabel = Instance.new("TextLabel")
	local UICorner_6 = Instance.new("UICorner")
	local Shadow = WinWare:CreateShadow(ColorPickerHandler);

	ColorPickerHandler.Name = WinWare.RandomString();
	ColorPickerHandler.Parent = WinWare.ScreenGui
	ColorPickerHandler.AnchorPoint = Vector2.new(0, 0)
	ColorPickerHandler.BackgroundColor3 = WinWare.PopupSurfaceColor
	ColorPickerHandler.BackgroundTransparency = 0.100
	WinWare.ApplyPopupSurface(ColorPickerHandler , 0.040);
	ColorPickerHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerHandler.BorderSizePixel = 0
	ColorPickerHandler.ClipsDescendants = true
	ColorPickerHandler.Position = UDim2.new(255, 0, 255, 20)
	ColorPickerHandler.Size = UDim2.new(0, 200, 0, 240)
	ColorPickerHandler.ZIndex = ZIndex + 125
	ColorPickerHandler:SetAttribute("WinWareNoAccent" , true);

	WinWare:AddSignal(ColorPickerHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if ColorPickerHandler.BackgroundTransparency > 0.9 then
			ColorPickerHandler.Visible = false;
			ColorPickerHandler.Parent = nil
		else
			ColorPickerHandler.Visible = true;

			if WinWare.Global3DRenderMode then
				ColorPickerHandler.Parent = WinWare.GlobalSurfaceGui;
			else
				ColorPickerHandler.Parent = WinWare.ScreenGui;
			end;
		end;
	end)));

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = ColorPickerHandler

	UIStroke.Transparency = WinWare.PopupStrokeTransparency
	UIStroke.Color = WinWare.PopupStrokeColor
	UIStroke.Parent = ColorPickerHandler
	ApplyPopupGradient(ColorPickerHandler)

	SaViMap.Name = WinWare.RandomString();
	SaViMap.Parent = ColorPickerHandler
	SaViMap.AnchorPoint = Vector2.new(0.5, 0)
	SaViMap.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
	SaViMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaViMap.BorderSizePixel = 0
	SaViMap.Position = UDim2.new(0.5, 0, 0, 5)
	SaViMap.Size = UDim2.new(0, 185, 0, 185)
	SaViMap.ZIndex = ZIndex + 126
	SaViMap.Image = WinWare.ImageColorMapping -- UNSAFE IMAGE

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = SaViMap

	ColorZoneSelection.Name = WinWare.RandomString();
	ColorZoneSelection.Parent = SaViMap
	ColorZoneSelection.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorZoneSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorZoneSelection.BackgroundTransparency = 1.000
	ColorZoneSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorZoneSelection.BorderSizePixel = 0
	ColorZoneSelection.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorZoneSelection.Size = UDim2.new(0, 10, 0, 10)
	ColorZoneSelection.ZIndex = ZIndex + 127

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = ColorZoneSelection

	UIStroke_2.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_2.Parent = ColorZoneSelection

	ColorMap.Name = WinWare.RandomString();
	ColorMap.Parent = ColorPickerHandler
	ColorMap.AnchorPoint = Vector2.new(0.5, 0)
	ColorMap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorMap.BorderSizePixel = 0
	ColorMap.Position = UDim2.new(0.5, 0, 0, 200)
	ColorMap.Size = UDim2.new(1, -15, 0, 10)
	ColorMap.ZIndex = ZIndex + 126

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Parent = ColorMap

	UICorner_4.CornerRadius = UDim.new(0, 3)
	UICorner_4.Parent = ColorMap

	ColorMapSelection.Name = WinWare.RandomString();
	ColorMapSelection.Parent = ColorMap
	ColorMapSelection.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorMapSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMapSelection.BackgroundTransparency = 1.000
	ColorMapSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorMapSelection.BorderSizePixel = 0
	ColorMapSelection.Position = UDim2.new(0, 0, 0.5, 0)
	ColorMapSelection.Size = UDim2.new(0, 5, 1, 0)
	ColorMapSelection.ZIndex = ZIndex + 126

	UIStroke_3.Thickness = 2.000
	UIStroke_3.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_3.Parent = ColorMapSelection

	UICorner_5.CornerRadius = UDim.new(0, 3)
	UICorner_5.Parent = ColorMapSelection

	RGBLabel.Name = WinWare.RandomString();
	RGBLabel.Parent = ColorPickerHandler
	RGBLabel.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
	RGBLabel.BackgroundTransparency = 0.750
	RGBLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RGBLabel.BorderSizePixel = 0
	RGBLabel.Position = UDim2.new(0, 10, 0, 217)
	RGBLabel.Size = UDim2.new(1, -20, 0, 15)
	RGBLabel.ZIndex = ZIndex + 127
	RGBLabel.FontFace = WinWare.MontserratBold
	RGBLabel.Text = "#FFFFFF"
	RGBLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	RGBLabel.TextSize = 12.000
	RGBLabel.TextTransparency = 0.400
	RGBLabel.TextXAlignment = Enum.TextXAlignment.Left

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = RGBLabel

	ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			local Viewport = WinWare.ScreenGui.AbsoluteSize;
			local TargetX = math.clamp((HandleFrame.AbsolutePosition.X + HandleFrame.AbsoluteSize.X) - 200 , 10 , math.max(10 , Viewport.X - 210));
			local TargetY = math.clamp(HandleFrame.AbsolutePosition.Y + HandleFrame.AbsoluteSize.Y + 8 , 10 , math.max(10 , Viewport.Y - 250));

			ColorPickerHandler.Position = UDim2.new(0, TargetX, 0, TargetY);
			SaViMap.BackgroundColor3 = Color3.fromHSV(ColorPickerLib.H , 1 , 1);

			WinWare.PlayAnimate(ColorPickerHandler,SlowyTween , {
				BackgroundTransparency = 0.100
			})

			WinWare.PlayAnimate(UIStroke,SlowyTween , {
				Transparency = WinWare.PopupStrokeTransparency
			})

			WinWare.PlayAnimate(SaViMap,SlowyTween , {
				BackgroundTransparency = 0,
				ImageTransparency = 0
			})

			WinWare.PlayAnimate(UIStroke_2,SlowyTween , {
				Transparency = 0
			})

			WinWare.PlayAnimate(ColorMap,SlowyTween , {
				BackgroundTransparency = 0
			})

			WinWare.PlayAnimate(UIStroke_3,SlowyTween , {
				Transparency = 0
			})

			WinWare.PlayAnimate(RGBLabel,SlowyTween , {
				BackgroundTransparency = 0.750,
				TextTransparency = 0.400
			})

			Shadow:Render(true)
		else
			WinWare.PlayAnimate(ColorPickerHandler,SlowyTween , {
				BackgroundTransparency = 1
			})

			WinWare.PlayAnimate(UIStroke,SlowyTween , {
				Transparency = 1
			})

			WinWare.PlayAnimate(SaViMap,SlowyTween , {
				BackgroundTransparency = 1,
				ImageTransparency = 1
			})

			WinWare.PlayAnimate(UIStroke_2,SlowyTween , {
				Transparency = 1
			})

			WinWare.PlayAnimate(ColorMap,SlowyTween , {
				BackgroundTransparency = 1
			})

			WinWare.PlayAnimate(UIStroke_3,SlowyTween , {
				Transparency = 1
			})

			WinWare.PlayAnimate(RGBLabel,SlowyTween , {
				BackgroundTransparency = 1,
				TextTransparency = 1
			})

			Shadow:Render(false)
		end;
	end);

	ColorPickerLib.SetRender(false);
	ColorPickerLib.Root = ColorPickerHandler;
	ColorPickerLib.H = 1;
	ColorPickerLib.S = 1;
	ColorPickerLib.V = 1;
	ColorPickerLib.Callback = EmptyFunction;

	function ColorPickerLib:Update()
		local RealColor = Color3.fromHSV(ColorPickerLib.H , ColorPickerLib.S , ColorPickerLib.V);

		WinWare.PlayAnimate(ColorZoneSelection,ManualTween,{
			Position = UDim2.fromScale(ColorPickerLib.S , 1 - ColorPickerLib.V)
		});

		WinWare.PlayAnimate(SaViMap,ManualTween,{
			BackgroundColor3 = Color3.fromHSV(ColorPickerLib.H , 1 , 1)
		});

		WinWare.PlayAnimate(ColorMapSelection,ManualTween,{
			Position = UDim2.fromScale(ColorPickerLib.H,0.5)
		});

		RGBLabel.Text = "#"..RealColor:ToHex();

		ColorPickerLib.Callback(RealColor);
	end;

	function ColorPickerLib:SetValue(Color)
		if typeof(Color) == 'string' then
			Color = Color3.fromHex(Color);
		end;

		local H , S , V = Color:ToHSV();

		ColorPickerLib.H = H;
		ColorPickerLib.S = S;
		ColorPickerLib.V = V;

		ColorPickerLib:Update();
	end;

	ColorPickerLib.IsHold = false;

	WinWare:AddSignal(ColorPickerHandler.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;
		end;
	end));

	WinWare:AddSignal(ColorPickerHandler.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = false;
		end;
	end));

	WinWare:AddSignal(ColorMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait()
				local ColorY = ColorMap.AbsolutePosition.X
				local ColorYM = ColorY + ColorMap.AbsoluteSize.X;
				local Value = math.clamp(Mouse.X, ColorY, ColorYM)
				local Code = ((Value - ColorY) / (ColorYM - ColorY));

				ColorPickerLib.H = Code;
				ColorPickerLib:Update();
			end;
		end;
	end)));

	WinWare:AddSignal(SaViMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait();
				local PosX = SaViMap.AbsolutePosition.X;
				local ScaleX = PosX + SaViMap.AbsoluteSize.X;
				local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), SaViMap.AbsolutePosition.Y;
				local ScaleY = PosY + SaViMap.AbsoluteSize.Y;
				local Vals = math.clamp(Mouse.Y, PosY, ScaleY);

				ColorPickerLib.S = (Value - PosX) / (ScaleX - PosX);
				ColorPickerLib.V = (1 - ((Vals - PosY) / (ScaleY - PosY)));
				ColorPickerLib:Update();
			end
		end
	end)));

	return ColorPickerLib;
end;

WinWare.KeyEnum = {
	One = '1',
	Two = '2',
	Three = '3',
	Four = '4',
	Five = '5',
	Six = '6',
	Seven = '7',
	Eight = '8',
	Nine = '9',
	Zero = '0',
	['Minus'] = "-",
	['Plus'] = "+",
	BackSlash = "\\",
	Slash = "/",
	Period = '.',
	Semicolon = ';',
	Colon = ":",
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftShift = "LShift",
	RightShift = "RShift",
	Return = "Enter",
	LeftBracket = "[",
	RightBracket = "]",
	Quote = "'",
	Comma = ",",
	Equals = "=",
	LeftSuper = "Super",
	RightSuper = "Super",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	Escape = "Esc",
};

WinWare.EnumReverse = {};

for i,v in next , WinWare.KeyEnum do
	WinWare.EnumReverse[v] = i;
end;

function WinWare:KeyCodeToStr(K: Enum.KeyCode)
	if typeof(K) == 'string' then
		if WinWare.KeyEnum[K] then
			return WinWare.KeyEnum[K];
		end;

		return K;
	end;

	return (WinWare.KeyEnum[K.Name] or K.Name);
end;

function WinWare:StrToKeyCode(str: string)
	if WinWare.EnumReverse[str] then
		return Enum.KeyCode[WinWare.EnumReverse[str]];
	end;

	return Enum.KeyCode[str];
end;

function WinWare:RegisiterHandler(Handler: Frame , Signal)
	local handle = {};
	local ZINdex = Handler.ZIndex;

	function handle:AddToggle(Config)
		Config = WinWare:ProcessParams(Config , {
			Default = false,
			Flag = nil,
			Callback = EmptyFunction,
			Compact = false,
		});
		local toggleWidth = Config.Compact and 30 or 50
		local toggleHeight = Config.Compact and 16 or 30
		local circleSize = Config.Compact and 12 or 23
		local circleOffPosition = Config.Compact and 8 or 15
		local circleOnPosition = Config.Compact and 22 or 35

		local Toggle = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Circle = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")

		Toggle.Name = WinWare.RandomString();
		Toggle.Parent = Handler
		Toggle.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.ClipsDescendants = true
		Toggle.Size = UDim2.fromOffset(toggleWidth, toggleHeight)
		Toggle.ZIndex = ZINdex + 13
		Toggle.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Toggle

		Circle.Name = WinWare.RandomString();
		Circle.Parent = Toggle
		Circle.AnchorPoint = Vector2.new(0.5, 0.5)
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 0
		Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Circle.BorderSizePixel = 0
		Circle.Position = UDim2.new(0, circleOffPosition, 0.5, 0)
		Circle.Size = UDim2.fromOffset(circleSize, circleSize)
		Circle.ZIndex = ZINdex + 14

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Circle

		local ToggleLib = {
			Root = Toggle	
		};

		ToggleLib.SetUI = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 0,
					BackgroundColor3 = WinWare.AccentColor
				})

				WinWare.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(243, 242, 242),
					BackgroundTransparency = 0,
					Position = UDim2.new(0, circleOnPosition, 0.5, 0)
				})
			else
				WinWare.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(11, 11, 11)
				})

				WinWare.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(77, 77, 77),
					BackgroundTransparency = 0,
					Position = UDim2.new(0, circleOffPosition, 0.5, 0)
				})
			end;
		end);

		ToggleLib.SetVisible = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ToggleLib.SetUI(Config.Default);
			else
				WinWare.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(11, 11, 11)
				})

				WinWare.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, circleOffPosition, 0.5, 0)
				})
			end;
		end);

		ToggleLib.SetUI(Config.Default);
		ToggleLib.SetVisible(Signal:GetValue());

		WinWare:CreateInput(Toggle , LPH_NO_VIRTUALIZE(function()
			Config.Default = not Config.Default;

			ToggleLib.SetUI(Config.Default);

			Config.Callback(Config.Default)
		end))

		ToggleLib.Signal = Signal:Connect(ToggleLib.SetVisible);

		function ToggleLib:GetValue()
			return Config.Default;
		end;

		function ToggleLib:SetValue(v)
			Config.Default = v;

			if Signal:GetValue() then
				ToggleLib.SetUI(Config.Default);
			end;

			Config.Callback(Config.Default)
		end;

		if Config.Flag then
			WinWare.Flags[Config.Flag] = ToggleLib;
		end;

		return ToggleLib;
	end;

	function handle:AddSlider(Config)
		Config = WinWare:ProcessParams(Config , {
			Default = 50,
			Min = 0,
			Max = 10,
			Type = "",
			Rounding = 0,
			Nums = {},
			Flag = nil,
			Size = 233,
			Callback = EmptyFunction,
			Compact = false,
		});
		Config.Min = tonumber(Config.Min) or 0
		Config.Max = tonumber(Config.Max) or Config.Min
		if Config.Max < Config.Min then
			Config.Min, Config.Max = Config.Max, Config.Min
		end
		Config.Default = WinWare.Rounding(
			math.clamp(tonumber(Config.Default) or Config.Min, Config.Min, Config.Max),
			Config.Rounding
		)

		local SliderLib = {};
		local thumbSize = Config.Compact and 12 or 18
		local thumbWidth = Config.Compact and 12 or 24
		local thumbRadius = thumbWidth / 2
		local trackInset = Config.Compact and 0 or 4

		SliderLib.GetSize = LPH_NO_VIRTUALIZE(function()
			local range = Config.Max - Config.Min
			if range == 0 then
				return 0
			end

			return math.clamp((Config.Default - Config.Min) / range, 0, 1);
		end);
		SliderLib.GetFillSize = LPH_NO_VIRTUALIZE(function(scale)
			local offset = thumbRadius - trackInset - (thumbWidth * scale)
			return UDim2.new(scale, offset, 1, -(trackInset * 2))
		end)
		SliderLib.GetThumbPosition = LPH_NO_VIRTUALIZE(function(scale)
			return UDim2.new(scale, thumbRadius - (thumbWidth * scale), 0.5, 0)
		end)

		local FullNumSize = TextService:GetTextSize(string.rep("0",(Config.Rounding + #tostring(Config.Max))+1)..tostring(Config.Type),10,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge));

		SliderLib.MaximumSize = FullNumSize.X;
		SliderLib.MaximumSize = Config.Compact and 40 or 45;

		if Config.Nums then
			local nszie = 0;

			for i,ns in next , Config.Nums do
				local size = TextService:GetTextSize(string.rep("m",string.len(tostring(ns))),10,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge));

				if nszie < size.X then
					nszie = size.X;
				end
			end;

			if SliderLib.MaximumSize < nszie then
				SliderLib.MaximumSize = nszie;
			end;
		end;

		local Slider = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ValueFrame = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextBox")
		local SlideMain = Instance.new("Frame")
		local SlideFrame = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local SlideMoving = Instance.new("Frame")
		local UICorner_4 = Instance.new("UICorner")
		local Frame = Instance.new("Frame")
		local UICorner_5 = Instance.new("UICorner")
		local boxSize = 2;

		Slider.Name = WinWare.RandomString();
		Slider.Parent = Handler
		Slider.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.ClipsDescendants = false
		Slider.Size = Config.Compact and UDim2.new(0, Config.Size, 0, 30) or UDim2.new(1, 0, 0, 26)
		Slider.ZIndex = ZINdex + 13
		Slider.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Slider

		ValueFrame.Name = WinWare.RandomString();
		ValueFrame.Parent = Slider
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.ClipsDescendants = true
		ValueFrame.Position = UDim2.new(1, 0, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, Config.Compact and 30 or 22)
		ValueFrame.ZIndex = ZINdex + 13

		UICorner_2.CornerRadius = UDim.new(0, 9)
		UICorner_2.Parent = ValueFrame

		UIStroke.Transparency = 1
		UIStroke.Color = Color3.fromRGB(255, 255, 255)
		UIStroke.Parent = ValueFrame

		ValueLabel.Name = WinWare.RandomString();
		ValueLabel.Parent = ValueFrame
		ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueLabel.BorderSizePixel = 0
		ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14
		ValueLabel.FontFace = WinWare.MontserratMedium
		ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);
		ValueLabel.TextColor3 = Color3.fromRGB(206, 206, 206)
		ValueLabel.TextSize = 13.000
		ValueLabel.ClearTextOnFocus = false;
		ValueLabel.TextTransparency = 0

		SlideMain.Name = WinWare.RandomString();
		SlideMain.Parent = Slider
		SlideMain.AnchorPoint = Vector2.new(0, 0.5)
		SlideMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SlideMain.BackgroundTransparency = 1.000
		SlideMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideMain.BorderSizePixel = 0
		SlideMain.Position = UDim2.new(0, 0, 0.5, 0)
		SlideMain.Size = UDim2.new(1, -((SliderLib.MaximumSize + 9)), 0, Config.Compact and 30 or 26)
		SlideMain.ZIndex = ZINdex + 13

		SlideFrame.Name = WinWare.RandomString();
		SlideFrame.Parent = SlideMain
		SlideFrame.AnchorPoint = Vector2.new(0, 0.5)
		SlideFrame.BackgroundColor3 = Config.Compact and Color3.fromRGB(22, 24, 25) or Color3.fromRGB(11, 11, 11)
		SlideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideFrame.BorderSizePixel = 0
		SlideFrame.ClipsDescendants = not Config.Compact
		SlideFrame.Position = UDim2.new(0, 0, 0.5, 0)
		SlideFrame.Size = UDim2.new(1, 0, 0, Config.Compact and 4 or 18)
		SlideFrame.ZIndex = ZINdex + 13

		UICorner_3.CornerRadius = UDim.new(0, Config.Compact and 2 or 9)
		UICorner_3.Parent = SlideFrame

		SlideMoving.Name = WinWare.RandomString();
		SlideMoving.Parent = SlideFrame
		SlideMoving.BackgroundColor3 = Config.Compact and Color3.fromRGB(140, 180, 255) or WinWare.AccentColor
		SlideMoving.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideMoving.BorderSizePixel = 0
		SlideMoving.Position = Config.Compact and UDim2.fromOffset(0, 0) or UDim2.fromOffset(4, 4)
		SlideMoving.Size = SliderLib.GetFillSize(SliderLib.GetSize())
		SlideMoving.ZIndex = ZINdex + 14

		UICorner_4.CornerRadius = UDim.new(0, Config.Compact and 2 or 6)
		UICorner_4.Parent = SlideMoving

		Frame.Parent = SlideFrame
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.BackgroundColor3 = Color3.fromRGB(243, 242, 242)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = SliderLib.GetThumbPosition(SliderLib.GetSize())
		Frame.Size = UDim2.fromOffset(thumbWidth, thumbSize)
		Frame.ZIndex = ZINdex + 15

		UICorner_5.CornerRadius = UDim.new(0, Config.Compact and 6 or 7)
		UICorner_5.Parent = Frame

		if not Config.Compact then
			WinWare.ApplyStackedRow(Handler , 56 , 26);
		end;

		local LoadText = LPH_NO_VIRTUALIZE(function()
			if Config.Nums[Config.Default] then
				ValueLabel.Text = Config.Nums[Config.Default]

			else
				ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);

			end;
		end);

		ValueLabel.FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
			local OutVal = WinWare:ParseInput(ValueLabel.Text , true);
			if OutVal then
				local rx = math.clamp(OutVal , Config.Min , Config.Max);
				local Value = WinWare.Rounding(rx,Config.Rounding);

				if Value then
					Config.Default = Value;

					TweenService:Create(SlideMoving , ManualTween ,{
						Size = SliderLib.GetFillSize(SliderLib.GetSize())
					}):Play();
					TweenService:Create(Frame, ManualTween, {
						Position = SliderLib.GetThumbPosition(SliderLib.GetSize())
					}):Play();

					LoadText();

					Config.Callback(Config.Default)
				else
					LoadText();
				end;

			else
				LoadText()
			end;
		end));

		SliderLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(ValueFrame,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, Config.Compact and 30 or 22)
				});

				WinWare.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 1
				});

				WinWare.PlayAnimate(ValueLabel,SlowyTween,{
					TextTransparency = 0
				});

				WinWare.PlayAnimate(SlideFrame,SlowyTween,{
					BackgroundTransparency = 0
				});

				WinWare.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 0,
					Size = SliderLib.GetFillSize(SliderLib.GetSize())
				});

				WinWare.PlayAnimate(Frame,SlowyTween,{
					BackgroundTransparency = 0,
					Position = SliderLib.GetThumbPosition(SliderLib.GetSize())
				});
			else
				WinWare.PlayAnimate(ValueFrame,SlowyTween,{
					BackgroundTransparency = 1,
				});

				WinWare.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 1
				});

				WinWare.PlayAnimate(ValueLabel,SlowyTween,{
					TextTransparency = 1
				});

				WinWare.PlayAnimate(SlideFrame,SlowyTween,{
					BackgroundTransparency = 1
				});

				WinWare.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 1,
					Size = SliderLib.GetFillSize(0)
				});

				WinWare.PlayAnimate(Frame,SlowyTween,{
					BackgroundTransparency = 1,
					Position = SliderLib.GetThumbPosition(0)
				});
			end;
		end);

		SliderLib.SetRender(Signal:GetValue());
		SliderLib.Signal = Signal:Connect(SliderLib.SetRender);

		local Update = function(Input)
			local travelWidth = math.max(SlideFrame.AbsoluteSize.X - thumbSize, 1)
			local pointerX = Input.Position.X - SlideFrame.AbsolutePosition.X - thumbRadius
			local SizeScale = math.clamp(pointerX / travelWidth, 0, 1);
			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;
			local Value = WinWare.Rounding(Main,Config.Rounding);

			Config.Default = Value;

			TweenService:Create(SlideMoving , ManualTween ,{
				Size = SliderLib.GetFillSize(SliderLib.GetSize())
			}):Play();
			TweenService:Create(Frame, ManualTween, {
				Position = SliderLib.GetThumbPosition(SliderLib.GetSize())
			}):Play();

			LoadText()


			Config.Callback(Value)
		end;

		local IsHold = false;

		do
			SlideMain.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					Update(Input)
				end
			end))

			SlideMain.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not WinWare:IsMouseOverFrame(SlideMain) then
							IsHold = false
						end;
					else
						IsHold = false
					end;
				end
			end))

			UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not WinWare:IsMouseOverFrame(SlideMain) then
								IsHold = false
							else
								Update(Input)
							end;
						else
							Update(Input)
						end;
					end;
				end;
			end));
		end;

		function SliderLib:GetValue()
			return Config.Default;
		end;

		function SliderLib:SetValue(v)
			local numberValue = tonumber(v)
			if not numberValue then
				return
			end

			Config.Default = WinWare.Rounding(math.clamp(numberValue, Config.Min, Config.Max), Config.Rounding);

			if Signal:GetValue() then
				WinWare.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 0,
					Size = SliderLib.GetFillSize(SliderLib.GetSize())
				});
				WinWare.PlayAnimate(Frame, SlowyTween, {
					BackgroundTransparency = 0,
					Position = SliderLib.GetThumbPosition(SliderLib.GetSize())
				});
			end;

			LoadText()

			Config.Callback(Config.Default);
		end;

		if Config.Flag then
			WinWare.Flags[Config.Flag] = SliderLib;
		end;

		return SliderLib;
	end;

	function handle:AddOption(OptionConfig)
		local GearIcon = typeof(OptionConfig) == "number" and OptionConfig or nil
		local ModuleConfig = nil
		if typeof(OptionConfig) == "string" then
			ModuleConfig = { Name = OptionConfig }
		elseif typeof(OptionConfig) == "table" then
			ModuleConfig = OptionConfig
		end
		local Option = Instance.new("Frame")
		local Icon = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")

		Option.Name = WinWare.RandomString();
		Option.Parent = Handler
		Option.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
		Option.BackgroundTransparency = 1.000
		Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Option.BorderSizePixel = 0
		Option.ClipsDescendants = true
		Option.Size = UDim2.new(0, 23, 0, 23)
		Option.ZIndex = ZINdex + 13
		Option.LayoutOrder = -(#Handler:GetChildren() + 5);

		Icon.Name = WinWare.RandomString();
		Icon.Parent = Option
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = ZINdex + 14
		Icon.FontFace = WinWare.BuiltInBold
		Icon.Text = (GearIcon == 1 and 'gear') or (GearIcon == 2 and 'chevron-large-right') or "three-dots-horizontal";
		Icon.TextColor3 = Color3.fromRGB(206, 206, 206)
		Icon.TextSize = 16.000
		Icon.TextTransparency = 0
		Icon.TextWrapped = true

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Option

		local Window = ModuleConfig
			and WinWare:CreateModuleOptionWindow(Option, ZINdex + 13, ModuleConfig)
			or WinWare:CreateOptionWindow(Option, ZINdex + 13)
		local reciveSignal;

		Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0
				})
			else
				WinWare.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				})
			end;
		end);

		Window.SetRender(Signal:GetValue());
		Signal:Connect(Window.SetRender);

		WinWare:CreateInput(Option , LPH_NO_VIRTUALIZE(function()
			if reciveSignal then
				reciveSignal:Disconnect();
				reciveSignal = nil;	
			end;

			Window.Signal:SetValue(not Window.Signal:GetValue());
			if not Window.Signal:GetValue() then
				return
			end

			reciveSignal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not WinWare:IsMouseOverFrame(Window.Root) and not WinWare:IsMouseOverFrame(Option) then
						if reciveSignal then
							reciveSignal:Disconnect();
							reciveSignal = nil;	
						end;

						Window.Signal:SetValue(false);
					end
				end
			end)
		end));

		return Window;
	end;

	function handle:AddColorPicker(Config)
		Config = WinWare:ProcessParams(Config , {
			Default = Color3.fromRGB(255, 255, 255),
			Callback  = EmptyFunction,
		});

		if typeof(Config.Default) == 'string' then
			Config.Default = Color3.fromHex(Config.Default:gsub('#',''));
		end;

		local ColorPickerLib = {};
		local ColorPicker = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ImageLabel = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")

		ColorPicker.Name = WinWare.RandomString();
		ColorPicker.Parent = Handler
		ColorPicker.BackgroundColor3 = Config.Default;
		ColorPicker.BackgroundTransparency = 0
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.ClipsDescendants = true
		ColorPicker.Size = UDim2.new(0, 22, 0, 22)
		ColorPicker.ZIndex = ZINdex + 13
		ColorPicker.LayoutOrder = -(#Handler:GetChildren() + 5);
		ColorPicker:SetAttribute("WinWareNoAccent" , true);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = ColorPicker

		UIStroke.Transparency = WinWare.PopupStrokeTransparency
		UIStroke.Color = WinWare.PopupStrokeColor
		UIStroke.Parent = ColorPicker

		ImageLabel.Parent = ColorPicker
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Size = UDim2.new(1, 0, 1, 0)
		ImageLabel.ZIndex = ZINdex + 11
		ImageLabel.Image = "rbxasset://textures/meshPartFallback.png"
		ImageLabel.ImageTransparency = 0.9
		ImageLabel.BackgroundTransparency = 1;
		ImageLabel.ScaleType = Enum.ScaleType.Crop

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = ImageLabel

		local BackendM = WinWare:CreateColorPicker(ColorPicker);

		BackendM:SetValue(Config.Default)
		BackendM.Callback = function(color)
			ColorPicker.BackgroundColor3 = color;
			Config.Default = color;
			Config.Callback(Config.Default);
		end;

		local signal;
		WinWare:CreateInput(ColorPicker , LPH_NO_VIRTUALIZE(function()
			if signal then
				signal:Disconnect();
				signal = nil;
			end;

			BackendM.SetRender(true);

			signal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not WinWare:IsMouseOverFrame(ColorPicker) and not WinWare:IsMouseOverFrame(BackendM.Root) then
						if signal then
							signal:Disconnect();
							signal = nil;
						end;

						BackendM.SetRender(false);
					end;
				end;
			end)
		end));

		ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(ColorPicker , SlowyTween , {
					BackgroundTransparency = 0
				})

				WinWare.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = WinWare.PopupStrokeTransparency
				})

				WinWare.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 0.9
				})
			else
				WinWare.PlayAnimate(ColorPicker , SlowyTween , {
					BackgroundTransparency = 1
				})

				WinWare.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				})

				WinWare.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 1
				})
			end;
		end);

		ColorPickerLib.SetRender(Signal:GetValue());
		Signal:Connect(ColorPickerLib.SetRender);

		function ColorPickerLib:GetValue()
			return Config.Default;
		end;

		function ColorPickerLib:SetValue(v)
			Config.Default = v;
			BackendM:SetValue(Config.Default)
		end;

		if Config.Flag then
			WinWare.Flags[Config.Flag] = ColorPickerLib;
		end;

		return ColorPickerLib;
	end;

	function handle:AddKeybind(Config)
		Config = WinWare:ProcessParams(Config,{
			Default = nil,
			Blacklist = {},
			Callback = EmptyFunction,
			Flag = nil
		});

		local KeybindLib = {};

		local Keybind = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextLabel")

		Keybind.Name = WinWare.RandomString();
		Keybind.Parent = Handler
		Keybind.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.ClipsDescendants = true
		Keybind.Size = UDim2.new(0, 46, 0, 30)
		Keybind.ZIndex = ZINdex + 13
		Keybind.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(0, 9)
		UICorner.Parent = Keybind

		UIStroke.Transparency = 1
		UIStroke.Color = WinWare.PopupStrokeColor
		UIStroke.Parent = Keybind

		ValueLabel.Name = WinWare.RandomString();
		ValueLabel.Parent = Keybind
		ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueLabel.BorderSizePixel = 0
		ValueLabel.ClipsDescendants = true
		ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14
		ValueLabel.FontFace = WinWare.MontserratMedium
		ValueLabel.Text = WinWare:KeyCodeToStr(Config.Default or "None")
		ValueLabel.TextColor3 = Color3.fromRGB(206, 206, 206)
		ValueLabel.TextSize = 13.000
		ValueLabel.TextTransparency = 0

		KeybindLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(Keybind,SlowyTween, {
					BackgroundTransparency = 0
				})

				WinWare.PlayAnimate(UIStroke,SlowyTween, {
					Transparency = 1
				})

				WinWare.PlayAnimate(ValueLabel,SlowyTween, {
					TextTransparency = 0
				})
			else
				WinWare.PlayAnimate(Keybind,SlowyTween, {
					BackgroundTransparency = 1
				})

				WinWare.PlayAnimate(UIStroke,SlowyTween, {
					Transparency = 1
				})

				WinWare.PlayAnimate(ValueLabel,SlowyTween, {
					TextTransparency = 1
				})
			end;
		end);

		function KeybindLib:Update()
			local size = TextService:GetTextSize(ValueLabel.Text,ValueLabel.TextSize,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge));

			WinWare.PlayAnimate(Keybind , SlowyTween , {
				Size = UDim2.new(0, math.max(46, size.X + 20), 0, 30)
			})
		end;

		local IsBlacklist = LPH_NO_VIRTUALIZE(function(v)
			return Config.Blacklist and (Config.Blacklist[v] or table.find(Config.Blacklist,v))
		end);

		KeybindLib:Update()

		KeybindLib.SetRender(Signal:GetValue());
		Signal:Connect(KeybindLib.SetRender);

		local IsBinding = false;
		WinWare:CreateInput(Keybind , function()
			if IsBinding then
				return;
			end;

			IsBinding = true;

			ValueLabel.Text = "...";

			KeybindLib:Update();

			local Selected = nil;

			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown and not IsBlacklist(Key.KeyCode) and not IsBlacklist(Key.KeyCode.Name) then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 and not IsBlacklist(Enum.UserInputType.MouseButton1) and not IsBlacklist("M1B") then
						Selected = "M1B";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 and not IsBlacklist(Enum.UserInputType.MouseButton2) and not IsBlacklist("M2B") then
						Selected = "M2B";
					end;
				end;
			end;

			IsBinding = false;

			local KeyName = typeof(Selected) == "string" and Selected or Selected.Name;

			Config.Default = KeyName;

			ValueLabel.Text = WinWare:KeyCodeToStr(KeyName);

			KeybindLib:Update();

			Config.Callback(KeyName)
		end)

		function KeybindLib:GetValue()
			return Config.Default;
		end;

		function KeybindLib:SetValue(v)
			Config.Default = v;
			ValueLabel.Text = WinWare:KeyCodeToStr(v);
			KeybindLib:Update();
			Config.Callback(Config.Default);
		end;

		if Config.Flag then
			WinWare.Flags[Config.Flag] = KeybindLib;
		end;

		return KeybindLib;
	end;

	function handle:AddTextInput(Config)
		Config = WinWare:ProcessParams(Config , {
			Default = "",
			Placeholder = "Placeholder",
			Callback = print,
			Flag = nil,
			Size = 100,
			Numeric = false,
		});

		local TextBoxLib = {};

		local TextInput = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")

		TextInput.Name = WinWare.RandomString();
		TextInput.Parent = Handler
		TextInput.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.ClipsDescendants = true
		TextInput.Size = UDim2.new(0, Config.Size, 0, 30)
		TextInput.ZIndex = ZINdex + 13
		TextInput.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(0, 9)
		UICorner.Parent = TextInput

		UIStroke.Transparency = 1
		UIStroke.Color = WinWare.PopupStrokeColor
		UIStroke.Parent = TextInput

		TextBox.Parent = TextInput
		TextBox.AnchorPoint = Vector2.new(0, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0, 8, 0.5, 0)
		TextBox.Size = UDim2.new(1, -16, 1, 0)
		TextBox.ZIndex = ZINdex + 14
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = WinWare.MontserratMedium
		TextBox.PlaceholderText = Config.Placeholder
		TextBox.Text = tostring(Config.Default)
		TextBox.TextColor3 = Color3.fromRGB(206, 206, 206)
		TextBox.TextSize = 14.000
		TextBox.TextTransparency = 0
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		TextBoxLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(TextInput , SlowyTween ,{
					BackgroundTransparency = 0
				})	

				WinWare.PlayAnimate(UIStroke , SlowyTween ,{
					Transparency = 1
				})	

				WinWare.PlayAnimate(TextBox , SlowyTween ,{
					TextTransparency = 0.050
				})	
			else
				WinWare.PlayAnimate(TextInput , SlowyTween ,{
					BackgroundTransparency = 1
				})	

				WinWare.PlayAnimate(UIStroke , SlowyTween ,{
					Transparency = 1
				})	

				WinWare.PlayAnimate(TextBox , SlowyTween ,{
					TextTransparency = 1
				})
			end;
		end);

		WinWare:AddSignal(TextBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
			local valout = WinWare:ParseInput(TextBox.Text , Config.Numeric);

			if Config.Numeric then
				TextBox.Text = string.gsub(TextBox.Text , '[^0-9.]','')
			end;

			if valout then
				Config.Default = valout;
				Config.Callback(valout);
			end
		end)));

		TextBoxLib.SetRender(Signal:GetValue());
		Signal:Connect(TextBoxLib.SetRender);

		function TextBoxLib:GetValue()
			return Config.Default;
		end;

		function TextBoxLib:SetValue(v)
			Config.Default = v;
			TextBox.Text = tostring(v);
			Config.Callback(Config.Default);
		end;

		if Config.Flag then
			WinWare.Flags[Config.Flag] = TextBoxLib;
		end;

		return TextBoxLib;
	end;

	function handle:AddDropdown(Config)
		Config = WinWare:ProcessParams(Config , {
			Default = nil,
			Values = {},
			Multi = false,
			Callback = EmptyFunction,
			AutoUpdate = false,
			Flag = nil,
			Size = 100
		})

		Config.Default = WinWare.ProcessDropdown(Config.Default);

		local Dropdown = Instance.new("Frame")
		local DropdownIcon = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local BasedLabel = Instance.new("TextLabel")

		Dropdown.Name = WinWare.RandomString();
		Dropdown.Parent = Handler
		Dropdown.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.ClipsDescendants = true
		Dropdown.Size = UDim2.new(0, Config.Size, 0, 30)
		Dropdown.ZIndex = ZINdex + 13
		Dropdown.LayoutOrder = -(#Handler:GetChildren() + 5);

		DropdownIcon.Name = WinWare.RandomString();
		DropdownIcon.Parent = Dropdown
		DropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
		DropdownIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropdownIcon.BackgroundTransparency = 1.000
		DropdownIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownIcon.BorderSizePixel = 0
		DropdownIcon.Position = UDim2.new(1, -2, 0.5, 0)
		DropdownIcon.Size = UDim2.new(0, 18, 0, 18)
		DropdownIcon.ZIndex = ZINdex + 14
		DropdownIcon.FontFace = WinWare.BuiltInBold
		DropdownIcon.Text = "chevron-small-down"
		DropdownIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
		DropdownIcon.TextSize = 13.000
		DropdownIcon.TextTransparency = 0.250
		DropdownIcon.TextWrapped = true

		UICorner.CornerRadius = UDim.new(0, 9)
		UICorner.Parent = Dropdown

		UIStroke.Transparency = 1
		UIStroke.Color = Color3.fromRGB(255, 255, 255)

		BasedLabel.Name = WinWare.RandomString();
		BasedLabel.Parent = Dropdown
		BasedLabel.AnchorPoint = Vector2.new(0, 0.5)
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.ClipsDescendants = true
		BasedLabel.Position = UDim2.new(0, 5, 0.5, 0)
		BasedLabel.Size = UDim2.new(1, -25, 0, 15)
		BasedLabel.ZIndex = ZINdex + 14
		BasedLabel.FontFace = WinWare.MontserratSemiBold
		BasedLabel.Text = WinWare.ParseDropdown(Config.Default);
		BasedLabel.TextColor3 = Color3.fromRGB(206, 206, 206)
		BasedLabel.TextSize = 14.000
		BasedLabel.TextTransparency = 0
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Center

		do
			local UIGradient = Instance.new("UIGradient")

			UIGradient.Transparency = NumberSequence.new(0)
			UIGradient.Parent = BasedLabel;
		end;

		WinWare:AddSignal(Dropdown.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0
			})
		end)));

		WinWare:AddSignal(Dropdown.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0
			})
		end)));

		local DropdownLib = {
			OpenSignal = WinWare:CreateSignal(false),
			Signals = {},
			Refuse = {},
		};

		DropdownLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(Dropdown , SlowyTween , {
					BackgroundTransparency = 0
				});

				WinWare.PlayAnimate(DropdownIcon , SlowyTween , {
					TextTransparency = 0.250
				});

				WinWare.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				});

				WinWare.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0
				});
			else
				WinWare.PlayAnimate(Dropdown , SlowyTween , {
					BackgroundTransparency = 1
				});

				WinWare.PlayAnimate(DropdownIcon , SlowyTween , {
					TextTransparency = 1
				});

				WinWare.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				});

				WinWare.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				});
			end
		end);

		DropdownLib.SetRender(Signal:GetValue())
		Signal:Connect(DropdownLib.SetRender);
		DropdownLib.ExtentSize = 0;

		do
			local DropdownHandler = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local DropdownScrollFrame = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			local Shadow = WinWare:CreateShadow(DropdownHandler);

			DropdownHandler.Name = WinWare.RandomString();
			DropdownHandler.Parent = WinWare.ScreenGui;
			DropdownHandler.AnchorPoint = Vector2.new(0.5, 0)
			DropdownHandler.BackgroundColor3 = WinWare.PopupSurfaceColor
			DropdownHandler.BackgroundTransparency = 0.100
			WinWare.ApplyPopupSurface(DropdownHandler , 0.040);
			DropdownHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownHandler.BorderSizePixel = 0
			DropdownHandler.ClipsDescendants = true
			DropdownHandler.Position = UDim2.new(255,255,255,255)
			DropdownHandler.Size = UDim2.new(0, 125, 0, 50)
			DropdownHandler.ZIndex = ZINdex + 125
			DropdownLib.BlockRoot = DropdownHandler;

			WinWare:AddSignal(DropdownHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
				if DropdownHandler.BackgroundTransparency > 0.9 then
					DropdownHandler.Visible = false;
					DropdownHandler.Parent = nil;
				else
					DropdownHandler.Visible = true;

					if WinWare.Global3DRenderMode then
						DropdownHandler.Parent = WinWare.GlobalSurfaceGui;
					else
						DropdownHandler.Parent = WinWare.ScreenGui;
					end;
				end;
			end));

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = DropdownHandler

			UIStroke.Transparency = WinWare.PopupStrokeTransparency
			UIStroke.Color = WinWare.PopupStrokeColor
			UIStroke.Parent = DropdownHandler
			DropdownHandler.BackgroundColor3 = WinWare.PopupSurfaceColor

			DropdownScrollFrame.Name = WinWare.RandomString();
			DropdownScrollFrame.Parent = DropdownHandler
			DropdownScrollFrame.Active = true
			DropdownScrollFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			DropdownScrollFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownScrollFrame.BackgroundTransparency = 1.000
			DropdownScrollFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownScrollFrame.BorderSizePixel = 0
			DropdownScrollFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -5)
			DropdownScrollFrame.ZIndex = ZINdex + 127
			DropdownScrollFrame.ScrollBarThickness = 0

			DropdownLib.RootItem = DropdownScrollFrame;

			UIListLayout.Parent = DropdownScrollFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			WinWare:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
				WinWare.PlayAnimate(DropdownHandler , SlowyTween , {
					Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250));
				})
			end)));

			local SetPosition = LPH_NO_VIRTUALIZE(function()
				if WinWare:MoreThanHalfY(Dropdown.AbsolutePosition.Y + Dropdown.AbsoluteSize.Y + 4) then
					DropdownHandler.AnchorPoint = Vector2.new(0.5,1)
				else
					DropdownHandler.AnchorPoint = Vector2.new(0.5,0)
				end;

				DropdownHandler.Position = UDim2.fromOffset(Dropdown.AbsolutePosition.X + (DropdownHandler.AbsoluteSize.X / 2), Dropdown.AbsolutePosition.Y + Dropdown.AbsoluteSize.Y + 4);

			end);

			DropdownLib.SetFrameRender = LPH_NO_VIRTUALIZE(function(value)
				DropdownLib.OpenSignal:SetValue(value);

				if value then
					Shadow:Render(true);

					DropdownHandler.Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250));

					SetPosition();

					WinWare.PlayAnimate(DropdownHandler , SlowyTween , {
						BackgroundTransparency = 0.100
					})

					if Config.AutoUpdate then
						DropdownLib:Generate();
					end;
				else

					WinWare.PlayAnimate(DropdownHandler , SlowyTween , {
						BackgroundTransparency = 1
					})

					Shadow:Render(false);
				end;
			end);

			DropdownLib.SetFrameRender(false);
		end;

		local SecureSignal;
		WinWare:CreateInput(Dropdown , LPH_NO_VIRTUALIZE(function()
			if SecureSignal then
				SecureSignal:Disconnect();
				SecureSignal = nil;
			end;

			DropdownLib.SetFrameRender(true);
			WinWare.IsMosueOverOtherFrame = true;

			SecureSignal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not WinWare:IsMouseOverFrame(DropdownLib.BlockRoot) and not WinWare:IsMouseOverFrame(Dropdown) then
						if SecureSignal then
							SecureSignal:Disconnect();
							SecureSignal = nil;
						end;

						WinWare.IsMosueOverOtherFrame = false;
						DropdownLib.SetFrameRender(false);
					end;
				end
			end)
		end))

		DropdownLib.IsMatch = LPH_NO_VIRTUALIZE(function(v1)
			if typeof(Config.Default) =='table' then
				if Config.Default[v1] or table.find(Config.Default , v1) then
					return true;
				end
			end

			if Config.Default == v1 then
				return true;
			end;
		end);

		function DropdownLib:Generate()
			for i,v in next , DropdownLib.RootItem:GetChildren() do
				if v:IsA('Frame') then
					v:Destroy();
				end;
			end;

			for i,v in next , DropdownLib.Signals do
				v:Disconnect();
			end;

			table.clear(DropdownLib.Signals);
			table.clear(DropdownLib.Refuse);

			local Lastone;
			for i,Value in next , Config.Values do
				local ItemFrame = Instance.new("Frame")
				local ItemLabel = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")
				local ItemStroke = Instance.new("UIStroke")

				ItemFrame.Name = WinWare.RandomString();
				ItemFrame.Parent = DropdownLib.RootItem
				ItemFrame.BackgroundColor3 = WinWare.PopupSurfaceTopColor
				ItemFrame.BackgroundTransparency = 1.000
				ItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ItemFrame.BorderSizePixel = 0
				ItemFrame.Size = UDim2.new(1, 0, 0, 25)
				ItemFrame.ZIndex = ZINdex + 1258

				ItemLabel.Name = WinWare.RandomString();
				ItemLabel.Parent = ItemFrame
				ItemLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ItemLabel.BackgroundTransparency = 1.000
				ItemLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ItemLabel.BorderSizePixel = 0
				ItemLabel.Position = UDim2.new(0, 15, 0, 4)
				ItemLabel.Size = UDim2.new(0,1, 0, 15)
				ItemLabel.ZIndex = ZINdex + 1258
				ItemLabel.FontFace = WinWare.MontserratMedium
				ItemLabel.Text = tostring(Value);
				ItemLabel.TextColor3 = Color3.fromRGB(206, 206, 206)
				ItemLabel.TextSize = 14.000
				ItemLabel.TextTransparency = 0.200
				ItemLabel.TextXAlignment = Enum.TextXAlignment.Left

				UICorner.CornerRadius = UDim.new(0, 7)
				UICorner.Parent = ItemFrame
				ItemStroke.Color = Color3.fromRGB(255, 255, 255)
				ItemStroke.Thickness = 1
				ItemStroke.Transparency = 1
				ItemStroke.Parent = nil
				local sizetext = TextService:GetTextSize(ItemLabel.Text , ItemLabel.TextSize,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge));

				DropdownLib.ExtentSize = math.max(DropdownLib.ExtentSize , sizetext.X);

				local MIcon , MarkItem = nil , nil;

				if Config.Multi then
					local Icon = Instance.new("TextLabel")

					Icon.Parent = ItemFrame;
					Icon.AnchorPoint = Vector2.new(0, 0.5)
					Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Icon.BackgroundTransparency = 1.000
					Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Icon.BorderSizePixel = 0
					Icon.Position = UDim2.new(0, 5, 0.5, 0)
					Icon.Size = UDim2.new(0, 20, 0, 20)
					Icon.ZIndex = ZINdex + 1259
					Icon.FontFace = WinWare.BuiltInBold;
					Icon.Text = "check"
					Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
					Icon.TextSize = 18.000
					Icon.TextTransparency = 1
					Icon.TextWrapped = true;

					local VisiblewOfMult = LPH_NO_VIRTUALIZE(function()
						if DropdownLib.IsMatch(Value) then
							WinWare.PlayAnimate(ItemLabel , VSlowTween , {
								TextTransparency = 0.200,
								TextColor3 = WinWare.AccentColor,
								Position = UDim2.new(0, 30, 0, 4)
							})
							WinWare.PlayAnimate(ItemFrame, SlowyTween, {
								BackgroundTransparency = 0.82
							})
							WinWare.PlayAnimate(ItemStroke, SlowyTween, {
								Transparency = 0.45
							})

							WinWare.PlayAnimate(Icon , vs , {
								TextTransparency = 0.250
							})

							Lastone = ItemLabel;
						else
							WinWare.PlayAnimate(ItemFrame, SlowyTween, {
								BackgroundTransparency = 1
							})
							WinWare.PlayAnimate(ItemStroke, SlowyTween, {
								Transparency = 1
							})

							WinWare.PlayAnimate(Icon , SlowyTween , {
								TextTransparency = 1
							})

							WinWare.PlayAnimate(ItemLabel , VSlowTween , {
								TextTransparency = 0.5,
								TextColor3 = Color3.fromRGB(206, 206, 206),
								Position = UDim2.new(0, 15, 0, 4)
							})
						end;
					end);

					MIcon = Icon;
					MarkItem = VisiblewOfMult;
				else
					local DefaultVisible = LPH_NO_VIRTUALIZE(function()
						if DropdownLib.IsMatch(Value) then
							WinWare.PlayAnimate(ItemLabel , SlowyTween , {
								TextTransparency = 0.200,
								TextColor3 = WinWare.AccentColor
							})
							WinWare.PlayAnimate(ItemFrame, SlowyTween, {
								BackgroundTransparency = 0.82
							})
							WinWare.PlayAnimate(ItemStroke, SlowyTween, {
								Transparency = 0.45
							})

							Lastone = ItemLabel;
						else
							WinWare.PlayAnimate(ItemFrame, SlowyTween, {
								BackgroundTransparency = 1
							})
							WinWare.PlayAnimate(ItemStroke, SlowyTween, {
								Transparency = 1
							})
							WinWare.PlayAnimate(ItemLabel , SlowyTween , {
								TextTransparency = 0.5,
								TextColor3 = Color3.fromRGB(206, 206, 206)
							})
						end;
					end);

					MarkItem = DefaultVisible;
				end;

				MarkItem();

				table.insert(DropdownLib.Refuse , MarkItem)

				table.insert(DropdownLib.Signals,ItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					WinWare.PlayAnimate(ItemFrame , SlowyTween , {
						BackgroundTransparency = 0.78
					})
					WinWare.PlayAnimate(ItemStroke, SlowyTween, {
						Transparency = 0.35
					})
				end)));

				table.insert(DropdownLib.Signals,ItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					WinWare.PlayAnimate(ItemFrame , SlowyTween , {
						BackgroundTransparency = DropdownLib.IsMatch(Value) and 0.82 or 1
					})
					WinWare.PlayAnimate(ItemStroke, SlowyTween, {
						Transparency = DropdownLib.IsMatch(Value) and 0.45 or 1
					})
				end)));

				table.insert(DropdownLib.Signals , DropdownLib.OpenSignal:Connect(LPH_NO_VIRTUALIZE(function(val)
					if val then
						MarkItem();
					else
						WinWare.PlayAnimate(ItemLabel , SlowyTween , {
							TextTransparency = 1
						})

						if MIcon then
							WinWare.PlayAnimate(MIcon , SlowyTween , {
								TextTransparency = 1
							})
						end;

						WinWare.PlayAnimate(ItemFrame, SlowyTween, {
							BackgroundTransparency = 1
						})
						WinWare.PlayAnimate(ItemStroke, SlowyTween, {
							Transparency = 1
						})
					end;
				end)));

				if Config.Multi then
					local _,bth_signal = WinWare:CreateInput(ItemFrame , LPH_NO_VIRTUALIZE(function()
						Config.Default[Value] = not Config.Default[Value];

						MarkItem();

						BasedLabel.Text = WinWare.ParseDropdown(Config.Default);

						Config.Callback(Config.Default);
					end));

					table.insert(DropdownLib.Signals , bth_signal);
				else
					local _,bth_signal = WinWare:CreateInput(ItemFrame , LPH_NO_VIRTUALIZE(function()
						Config.Default = Value;

						for i,v in next , DropdownLib.Refuse do
							task.spawn(v);
						end;

						BasedLabel.Text = WinWare.ParseDropdown(Config.Default);

						Config.Callback(Config.Default);
					end));

					table.insert(DropdownLib.Signals , bth_signal);
				end;
			end;
		end;

		DropdownLib:Generate();

		function DropdownLib:GetValue()
			return Config.Default;
		end;

		function DropdownLib:SetValue(v)
			Config.Default = v;

			BasedLabel.Text = WinWare.ParseDropdown(Config.Default);

			for i,v in next , DropdownLib.Refuse do
				task.spawn(v);
			end;

			Config.Callback(Config.Default);
		end;

		function DropdownLib:SetValues(a)
			Config.Values = a;

			if not Config.AutoUpdate then
				DropdownLib:Generate();
			end;
		end;

		if Config.Flag then
			WinWare.Flags[Config.Flag] = DropdownLib;
		end;

		return DropdownLib;
	end;

	return handle;
end;

WinWare.ProcessDropdown = LPH_NO_VIRTUALIZE(function(value)
	if typeof(value) == 'table' then
		local data = {};

		for i,v in next , value do
			if typeof(v) == 'boolean' and typeof(i) ~= 'number' then
				data[i] = v;
			else
				data[v] = true;
			end;
		end;

		return data;
	else
		return value;
	end;
end);

WinWare.ParseDropdown = LPH_NO_VIRTUALIZE(function(value)
	if not value then return 'Select'; end;

	local Out;

	if typeof(value) == 'table' then
		if #value > 0 then
			local x = {};

			for i,v in next , value do
				table.insert(x , tostring(v))
			end;

			Out = table.concat(x,' , ');

			table.clear(x);
		else
			local x = {};

			for i,v in next , value do
				if v == true then
					table.insert(x , tostring(i));
				end			
			end;

			Out = table.concat(x,' , ');

			table.clear(x)

			if not Out:byte() then
				Out = 'Select';
			end
		end;
	else
		Out = tostring(value or 'Select');
	end;

	return Out;
end);

function WinWare:ParseInput(Value , Numeric)
	if not Value then
		return (Numeric and nil) or "";	
	end;

	if Numeric then
		local out = string.gsub(tostring(Value), '[^0-9.%-]', '')

		if tonumber(out) then
			return tonumber(out);
		end;

		return nil;
	end;

	return Value;
end;

function WinWare:CreateToolTips(Container: Frame , Name: string , Content: string)
	local Tooltips = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local TooltipName = Instance.new("TextLabel")
	local TooltipContent = Instance.new("TextLabel")
	local Shadow = WinWare:CreateShadow(Tooltips);

	Tooltips.Name = WinWare.RandomString();
	Tooltips.BackgroundColor3 = WinWare.PopupSurfaceColor
	Tooltips.BackgroundTransparency = 0.100
	WinWare.ApplyPopupSurface(Tooltips , 0.040);
	Tooltips.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Tooltips.BorderSizePixel = 0
	Tooltips.ClipsDescendants = true
	Tooltips.Position = UDim2.new(255,255,255,255)
	Tooltips.Size = UDim2.new(0,0,0,0)
	Tooltips.ZIndex = 130

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Tooltips

	UIStroke.Transparency = WinWare.PopupStrokeTransparency
	UIStroke.Color = WinWare.PopupStrokeColor
	UIStroke.Parent = Tooltips
	ApplyPopupGradient(Tooltips)

	TooltipName.Name = WinWare.RandomString();
	TooltipName.Parent = Tooltips
	TooltipName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TooltipName.BackgroundTransparency = 1.000
	TooltipName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TooltipName.BorderSizePixel = 0
	TooltipName.Position = UDim2.new(0, 15, 0, 5)
	TooltipName.Size = UDim2.new(0, 1, 0, 20)
	TooltipName.ZIndex = 132
	TooltipName.FontFace = WinWare.MontserratBold
	TooltipName.Text = Name
	TooltipName.TextColor3 = Color3.fromRGB(255, 255, 255)
	TooltipName.TextSize = 15.000
	TooltipName.TextXAlignment = Enum.TextXAlignment.Left

	TooltipContent.Name = WinWare.RandomString();
	TooltipContent.Parent = Tooltips
	TooltipContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TooltipContent.BackgroundTransparency = 1.000
	TooltipContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TooltipContent.BorderSizePixel = 0
	TooltipContent.Position = UDim2.new(0, 15, 0, 30)
	TooltipContent.Size = UDim2.new(0, 1, 0, 15)
	TooltipContent.ZIndex = 132
	TooltipContent.FontFace = WinWare.MontserratBold
	TooltipContent.Text = Content
	TooltipContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	TooltipContent.TextSize = 12.000
	TooltipContent.TextTransparency = 0.650
	TooltipContent.TextXAlignment = Enum.TextXAlignment.Left
	TooltipContent.TextYAlignment = Enum.TextYAlignment.Top

	local ToolTip = {};

	ToolTip.Update = LPH_NO_VIRTUALIZE(function()
		local SizeName = TextService:GetTextSize(TooltipName.Text , TooltipName.TextSize , WinWare.TextMetricFont , Vector2.new(math.huge,math.huge));
		local SizeContent = TextService:GetTextSize(TooltipContent.Text , TooltipContent.TextSize , WinWare.TextMetricFont , Vector2.new(math.huge,math.huge));

		local MaxX = math.max(SizeName.X , SizeContent.X) + 65;
		local MaxY = SizeName.Y + SizeContent.Y + 30;

		WinWare.PlayAnimate(Tooltips,SlowyTween , {
			Size = UDim2.new(0,MaxX,0,MaxY)
		})
	end)

	WinWare:AddSignal(Tooltips:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if Tooltips.BackgroundTransparency > 0.9 then
			Tooltips.Visible = false;
			Tooltips.Parent = nil;
		else
			Tooltips.Visible = true;

			if WinWare.Global3DRenderMode then
				Tooltips.Parent = WinWare.GlobalSurfaceGui;
			else
				Tooltips.Parent = WinWare.ScreenGui;
			end;
		end
	end)));

	ToolTip.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			Tooltips.Position = UDim2.fromOffset(Container.AbsolutePosition.X + Container.AbsoluteSize.X , Container.AbsolutePosition.Y + (Container.AbsoluteSize.Y + 25));

			WinWare.PlayAnimate(Tooltips , SlowyTween , {
				BackgroundTransparency = 0.100
			})

			WinWare.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = WinWare.PopupStrokeTransparency
			})

			WinWare.PlayAnimate(TooltipName , SlowyTween , {
				TextTransparency = 0
			})

			WinWare.PlayAnimate(TooltipContent , SlowyTween , {
				TextTransparency = 0.650
			})

			ToolTip.Update();
			Shadow:Render(true);
		else
			WinWare.PlayAnimate(Tooltips , SlowyTween , {
				BackgroundTransparency = 1
			})

			WinWare.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			WinWare.PlayAnimate(TooltipName , SlowyTween , {
				TextTransparency = 1
			})

			WinWare.PlayAnimate(TooltipContent , SlowyTween , {
				TextTransparency = 1
			})

			Shadow:Render(false);
		end;
	end);

	ToolTip.SetRender(false);
	ToolTip.Update();

	local DelayThread;
	WinWare:AddSignal(Container.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then
			task.cancel(DelayThread);
			DelayThread = nil;
		end;

		DelayThread = task.delay(1,ToolTip.SetRender,true);
	end)));

	WinWare:AddSignal(Container.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then
			task.cancel(DelayThread);
			DelayThread = nil;
		end;

		ToolTip.SetRender(false);
		ToolTip.Update();
	end)))

	return ToolTip;
end;

function WinWare:RegisiterItem(Frame: Frame , Signel)
	local idx = {};
	local LayerIndex = Frame.ZIndex;

	function idx:AddLabel(Name: string,Warp: boolean)
		local BasedFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local UICorner = Instance.new("UICorner")

		BasedFrame.Name = WinWare.RandomString();
		BasedFrame.Parent = Frame
		BasedFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
		BasedFrame.BackgroundTransparency = 1.000
		BasedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedFrame.BorderSizePixel = 0
		BasedFrame.Size = UDim2.new(1, 0, 0, 44)
		BasedFrame.ZIndex = LayerIndex + 8
		BasedFrame:SetAttribute("ControlRow" , true)

		WinWare:AddQuery(BasedFrame , Name);

		BasedLabel.Name = WinWare.RandomString();
		BasedLabel.Parent = BasedFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 10, 0, 0)
		BasedLabel.Size = UDim2.new(0, 155, 1, 0)
		BasedLabel.ZIndex = LayerIndex + 9
		BasedLabel.FontFace = WinWare.MontserratSemiBold
		BasedLabel.Text = Name
		BasedLabel.TextColor3 = Color3.fromRGB(206, 206, 206)
		BasedLabel.TextSize = 15.000
		BasedLabel.TextTransparency = 0
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = WinWare.RandomString();
		LineFrame.Parent = BasedFrame
		LineFrame.Visible = false
		LineFrame:SetAttribute("RowDivider", true)
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LineFrame.BackgroundTransparency = 0.970
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 2)
		LineFrame.ZIndex = LayerIndex + 11

		BasedHandler.Name = WinWare.RandomString();
		BasedHandler.Parent = BasedFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedHandler.BorderSizePixel = 0
		BasedHandler.Position = UDim2.new(1, -10, 0.5, -15)
		BasedHandler.Size = UDim2.new(1, -20, 0, 30)
		BasedHandler.ZIndex = LayerIndex + 12

		UIListLayout.Parent = BasedHandler
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 5)

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = BasedFrame

		local UpdateWarp = LPH_NO_VIRTUALIZE(function()
			local size = TextService:GetTextSize(BasedLabel.Text , BasedLabel.TextSize , WinWare.TextMetricFont , Vector2.new(math.huge,math.huge));
			WinWare.PlayAnimate(BasedFrame , SlowyTween , {
				Size = UDim2.new(1, 0, 0, size.Y + 13);
			})

			BasedLabel.Size = UDim2.new(1, -35, 1, 0)
			BasedLabel.TextYAlignment = Enum.TextYAlignment.Top;
		end);

		if Warp then
			UpdateWarp();
		end;

		local handle = WinWare:RegisiterHandler(BasedHandler , Signel);
		local function UpdateLabelWidth()
			if Warp or BasedFrame:GetAttribute("StackedRow") then
				return;
			end;

			local availableWidth = BasedFrame.AbsoluteSize.X - BasedLabel.Position.X.Offset - UIListLayout.AbsoluteContentSize.X - 20;
			BasedLabel.Size = UDim2.new(0, math.max(math.floor(availableWidth), 32), 1, 0);
		end;

		WinWare:AddSignal(UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateLabelWidth));
		WinWare:AddSignal(BasedFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateLabelWidth));
		task.defer(UpdateLabelWidth);

		handle.Root = BasedFrame;

		handle.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(BasedFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				WinWare.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0
				})

				WinWare.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.970
				})
			else
				WinWare.PlayAnimate(BasedFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				WinWare.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				})

				WinWare.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				})
			end;
		end);

		function handle:SetVisible(val)
			BasedFrame.Visible = val;
		end;

		function handle:SetText(t)
			local oldtxt = BasedLabel.Text;

			BasedLabel.Text = t;

			if Warp and oldtxt ~= t then
				UpdateWarp();
			end;
		end;

		function handle:ToolTip(Content: string)
			handle.ToolTip = WinWare:CreateToolTips(BasedFrame , Name , Content);

			return handle;
		end;

		handle.SetRender(Signel:GetValue());
		Signel:Connect(handle.SetRender);

		return handle;
	end;

	function idx:AddButton(Config)
		Config = WinWare:ProcessParams(Config , {
			Icon = 'chevron-large-left',
			Name = "Button",
			Callback = EmptyFunction,
			ToolTip = nil,
		});

		local Button = {};
		local ButtonRow = Instance.new("Frame")
		local ButtonFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Icon = Instance.new("TextLabel")

		WinWare:AddQuery(ButtonRow , Config.Name);

		ButtonRow.Name = WinWare.RandomString();
		ButtonRow.Parent = Frame
		ButtonRow.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
		ButtonRow.BackgroundTransparency = 1.000
		ButtonRow.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonRow.BorderSizePixel = 0
		ButtonRow.Size = UDim2.new(1, 0, 0, 44)
		ButtonRow.ZIndex = LayerIndex + 8
		ButtonRow:SetAttribute("ControlRow" , true)

		ButtonFrame.Name = WinWare.RandomString();
		ButtonFrame.Parent = ButtonRow
		ButtonFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ButtonFrame.BackgroundColor3 = WinWare.PopupSurfaceColor
		ButtonFrame.BackgroundTransparency = 0
		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonFrame.BorderSizePixel = 0
		ButtonFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		ButtonFrame.Size = UDim2.new(1, -20, 0, 30)
		ButtonFrame.ZIndex = LayerIndex + 8

		BasedLabel.Name = WinWare.RandomString();
		BasedLabel.Parent = ButtonFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 36, 0, 6)
		BasedLabel.Size = UDim2.new(1, -46, 0, 18)
		BasedLabel.ZIndex = LayerIndex + 9
		BasedLabel.FontFace = WinWare.MontserratMedium
		BasedLabel.Text = Config.Name;
		BasedLabel.TextColor3 = Color3.fromRGB(206, 206, 206)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = WinWare.RandomString();
		LineFrame.Parent = ButtonFrame
		LineFrame.Visible = false
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		LineFrame.BackgroundTransparency = 1.000
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 2)
		LineFrame.ZIndex = LayerIndex + 11

		UICorner.CornerRadius = UDim.new(0, 9)
		UICorner.Parent = ButtonFrame


		Icon.Name = WinWare.RandomString();
		Icon.Parent = ButtonFrame
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 10, 0, 5)
		Icon.Size = UDim2.new(0, 20, 0, 20)
		Icon.ZIndex = LayerIndex + 9
		Icon.FontFace = WinWare.BuiltInBold
		Icon.Text = Config.Icon
		Icon.TextColor3 = Color3.fromRGB(206, 206, 206)
		Icon.TextSize = 19.000
		Icon.TextTransparency = 0
		Icon.TextWrapped = true

		function Button:SetText(t)
			BasedLabel.Text = t;
		end;

		function Button:SetIcon(t)
			Icon.Text = t
		end;

		local bth = WinWare:CreateInput(ButtonFrame , LPH_NO_VIRTUALIZE(function()
			Config.Callback();
		end));

		WinWare:AddSignal(bth.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(ButtonFrame , SlowyTween , {
				BackgroundColor3 = WinWare.PopupSurfaceTopColor
			});
		end)))

		WinWare:AddSignal(bth.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(ButtonFrame , SlowyTween , {
				BackgroundColor3 = WinWare.PopupSurfaceColor
			});
		end)))

		Button.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(ButtonFrame , SlowyTween , {
					BackgroundTransparency = 0
				});

				WinWare.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0
				});

				WinWare.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				WinWare.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0
				});
			else
				WinWare.PlayAnimate(ButtonFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				WinWare.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				});

				WinWare.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				WinWare.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				});
			end;
		end);

		if Config.ToolTip then
			Button.ToolTip = WinWare:CreateToolTips(ButtonFrame , Config.Name , Config.ToolTip);
		end;

		Button.SetRender(Signel:GetValue())
		Signel:Connect(Button.SetRender);

		return Button;
	end;

	function idx:AddUserFrame(Name : string , Profile: string , Expires : string)
		local UserFrame = Instance.new("Frame")
		local UserLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local LogoImage = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local UserStatusLabel = Instance.new("TextLabel")

		UserFrame.Name = WinWare.RandomString();
		UserFrame.Parent = Frame
		UserFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
		UserFrame.BackgroundTransparency = 1.000
		UserFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserFrame.BorderSizePixel = 0
		UserFrame.Size = UDim2.new(1, 0, 0, 82)
		UserFrame.ZIndex = LayerIndex + 8

		UserLabel.Name = WinWare.RandomString();
		UserLabel.Parent = UserFrame
		UserLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UserLabel.BackgroundTransparency = 1.000
		UserLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserLabel.BorderSizePixel = 0
		UserLabel.Position = UDim2.new(0, 68, 0, 22)
		UserLabel.Size = UDim2.new(1, -80, 0, 18)
		UserLabel.ZIndex = LayerIndex + 9
		UserLabel.FontFace = WinWare.MontserratSemiBold
		UserLabel.Text = Name or WinWare.UserName or 'User'
		UserLabel.TextColor3 = Color3.fromRGB(206, 206, 206)
		UserLabel.TextSize = 15.000
		UserLabel.TextTransparency = 0
		UserLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = WinWare.RandomString();
		LineFrame.Parent = UserFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LineFrame.BackgroundTransparency = 0.970
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 2)
		LineFrame.ZIndex = LayerIndex + 11

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = UserFrame

		LogoImage.Name = WinWare.RandomString();
		LogoImage.Parent = UserFrame
		LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoImage.BackgroundTransparency = 1.000
		LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoImage.BorderSizePixel = 0
		LogoImage.AnchorPoint = Vector2.new(0, 0.5)
		LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
		LogoImage.Size = UDim2.new(0, 50, 0, 50)
		LogoImage.ZIndex = LayerIndex + 9
		LogoImage.Image = Profile or WinWare.UserProfile;

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = LogoImage
		local ProfileStroke = Instance.new("UIStroke")
		ProfileStroke.Color = Color3.fromRGB(255, 255, 255)
		ProfileStroke.Thickness = 2.5
		ProfileStroke.Parent = LogoImage

		local ProfileStrokeGradient = Instance.new("UIGradient", ProfileStroke)
		ProfileStrokeGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 39, 88)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 126, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(96, 156, 255)),
		})
		ProfileStrokeGradient.Rotation = 45

		UserStatusLabel.Name = WinWare.RandomString();
		UserStatusLabel.Parent = UserFrame
		UserStatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UserStatusLabel.BackgroundTransparency = 1.000
		UserStatusLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserStatusLabel.BorderSizePixel = 0
		UserStatusLabel.Position = UDim2.new(0, 68, 0, 42)
		UserStatusLabel.Size = UDim2.new(1, -80, 0, 16)
		UserStatusLabel.ZIndex = LayerIndex + 9
		UserStatusLabel.FontFace = WinWare.MontserratSemiBold
		UserStatusLabel.Text = Expires or 'Never'
		UserStatusLabel.TextColor3 = Color3.fromRGB(145, 145, 145)
		UserStatusLabel.TextSize = 12.000
		UserStatusLabel.TextTransparency = 0
		UserStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

		local UserFrameItem = {};

		UserFrameItem.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				WinWare.PlayAnimate(UserLabel,SlowyTween,{
					TextTransparency = 0.200
				})

				WinWare.PlayAnimate(LineFrame,SlowyTween,{
					BackgroundTransparency = 0.650
				})

				WinWare.PlayAnimate(LogoImage,SlowyTween,{
					ImageTransparency = 0
				})

				WinWare.PlayAnimate(ProfileStroke,SlowyTween,{
					Transparency = 0
				})

				WinWare.PlayAnimate(UserStatusLabel,SlowyTween,{
					TextTransparency = 0.200
				})
			else
				WinWare.PlayAnimate(UserLabel,SlowyTween,{
					TextTransparency = 1
				})

				WinWare.PlayAnimate(LineFrame,SlowyTween,{
					BackgroundTransparency = 1
				})

				WinWare.PlayAnimate(LogoImage,SlowyTween,{
					ImageTransparency = 1
				})

				WinWare.PlayAnimate(ProfileStroke,SlowyTween,{
					Transparency = 1
				})

				WinWare.PlayAnimate(UserStatusLabel,SlowyTween,{
					TextTransparency = 1
				})
			end;
		end);

		UserFrameItem.SetRender(Signel:GetValue())
		Signel:Connect(UserFrameItem.SetRender);

		function UserFrameItem:SetUsername(name)
			UserLabel.Text = name or WinWare.UserName or 'User'
		end;

		function UserFrameItem:SetProfile(Profile)
			LogoImage.Image = Profile or WinWare.UserProfile;
		end;

		function UserFrameItem:SetExpires(Exp)
			UserStatusLabel.Text = Exp or 'Never';
		end;

		return UserFrameItem;
	end;

	return idx;
end;

function WinWare:CreateWindow(Config)
	Config = WinWare:ProcessParams(Config , {
		Logo = WinWare.GlobalLogo,
		Name = "WINWARE",
		Content = "",
		Size = WinWare.Scales.Default,
		ConfigFolder = "WinWareConfigs",
		Enable3DRenderer = false,
		Keybind = "Insert"
	});

	local Window = {
		Logo = Config.Logo,
		Name = Config.Name,
		Content = Config.Content,
		Size = Config.Size,
		ConfigFolder = Config.ConfigFolder,
		Signal = WinWare:CreateSignal(true),
		Tabs = {},
		CurrentTab = 1,
		Keybind = Config.Keybind,
		Enable3DRenderer = Config.Enable3DRenderer
	};

	WinWare.GlobalLogo = Window.Logo;

	local Logging = WinWare:CreateLogger();
	if not isfolder(Window.ConfigFolder) then
		makefolder(Window.ConfigFolder);
	end;

	local WindowFrame = Instance.new("CanvasGroup")
	local UICorner = Instance.new("UICorner")
	local LeftMenuFrame = Instance.new("Frame")
	local HeadFrame = Instance.new("Frame")
	local LogoImage = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local WindowName = Instance.new("TextLabel")
	local WindowContent = Instance.new("TextLabel")
	local LineFrame = Instance.new("Frame")
	local LeftScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local BottomFrame = Instance.new("Frame")
	local AccountProfile = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local AccountName = Instance.new("TextLabel")
	local ExpireLabel = Instance.new("TextLabel")
	local LineFrame_2 = Instance.new("Frame")
	local UserSettingButton = Instance.new("TextLabel")
	local RightMenuFrame = Instance.new("Frame")
	local VerticalDivider = Instance.new("Frame")
	local RightHeader = Instance.new("Frame")
	local LineFrame_3 = Instance.new("Frame")
	local ConfigFrame = Instance.new("Frame")
	local UIStroke_2 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local ConfigIcon = Instance.new("TextLabel")
	local LineFrame_4 = Instance.new("Frame")
	local ConfigName = Instance.new("TextLabel")
	local ConfigBthIcon = Instance.new("TextLabel")
	local SearchFrame = Instance.new("Frame")
	local SearchIcon = Instance.new("TextLabel")
	local SearchBox = Instance.new("TextBox")
	local TabContainer = Instance.new("Frame")

	WindowFrame.Name = WinWare.RandomString();
	WindowFrame.Parent = WinWare.ScreenGui;
	WinWare.MainWindowFrame = WindowFrame;
	WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
	WindowFrame.BackgroundTransparency = 0.040
	WindowFrame.GroupTransparency = 1
	WindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowFrame.BorderSizePixel = 0
	WindowFrame.ClipsDescendants = true
	WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	WindowFrame.Size = Window.Size
	WindowFrame.Visible = false;
	WindowFrame.Active = true;

	local renderParentWindow = LPH_NO_VIRTUALIZE(function()
		if Window.__3DRender then
			if WindowFrame.GroupTransparency > 0.9 then
				WindowFrame.Visible = false;
				WindowFrame.Parent = nil
			else
				WindowFrame.Visible = true;

				WinWare.PlayAnimate(WindowFrame,VSlowTween , {
					Position = UDim2.fromScale(0.5,0.5);
				});

				WindowFrame.Parent = Window.SurfaceGui;
			end;
		else
			if WindowFrame.GroupTransparency > 0.9 then
				WindowFrame.Visible = false;
				WindowFrame.Parent = nil
			else
				WindowFrame.Visible = true;
				WindowFrame.Parent = WinWare.ScreenGui


			end;
		end;
	end);

	WinWare:AddSignal(WindowFrame:GetPropertyChangedSignal('GroupTransparency'):Connect(renderParentWindow))

	local ScaledSize = LPH_NO_VIRTUALIZE(function(Factor)
		local Base = Window.Size;

		return UDim2.new(Base.X.Scale * Factor , math.floor(Base.X.Offset * Factor) , Base.Y.Scale * Factor , math.floor(Base.Y.Offset * Factor));
	end);

	Window.PrepareFade = LPH_NO_VIRTUALIZE(function()
		WindowFrame.GroupTransparency = 1;
		WindowFrame.Size = ScaledSize(0.940);
		WindowFrame.Visible = true;
	end);

	Window.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
		if value then
			WindowFrame.Visible = true;

			WinWare.PlayAnimate(WindowFrame , WindowFadeTween , {
				GroupTransparency = 0
			})

			WinWare.PlayAnimate(WindowFrame , WindowPopTween , {
				Size = Window.Size
			})

			Window.Shadow:Render(true);
		else
			WinWare.PlayAnimate(WindowFrame , WindowHideTween , {
				GroupTransparency = 1,
				Size = ScaledSize(0.940)
			})

			Window.Shadow:Render(false);
		end;
	end);

	Window.Shadow = WinWare:CreateShadow(WindowFrame);
	Window.Shadow:Render(false);

	task.delay(0.25,function()
		WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		Window.PrepareFade();
		Window:SetRender(true);
		WinWare:AddSignal(Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(...)
			Window:SetRender(...);
		end)))
	end)

	if WinWare.EnabledBlur then
		WinWare:CreateBlurModule(WindowFrame,Window.Signal);
	end;

	do
		local Frame = Instance.new("Frame")

		Frame.Parent = WindowFrame
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(1, 0, 0, 67)
		Frame.ZIndex = 7
		Frame.BackgroundTransparency = 1;

		WinWare.Drag(Frame , WindowFrame , 0.15)
	end

	UICorner.CornerRadius = UDim.new(0, 13)
	UICorner.Parent = WindowFrame
	local WindowStroke = Instance.new("UIStroke", WindowFrame)
	WindowStroke.Color = Color3.fromRGB(255, 255, 255)
	WindowStroke.Transparency = 0.950
	WindowStroke.Thickness = 1

	LeftMenuFrame.Name = WinWare.RandomString();
	LeftMenuFrame.Parent = WindowFrame
	LeftMenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LeftMenuFrame.BackgroundTransparency = 1.000
	LeftMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LeftMenuFrame.BorderSizePixel = 0
	LeftMenuFrame.Size = UDim2.new(0, 167, 1, 0)

	HeadFrame.Name = WinWare.RandomString();
	HeadFrame.Parent = LeftMenuFrame
	HeadFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeadFrame.BackgroundTransparency = 1.000
	HeadFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeadFrame.BorderSizePixel = 0
	HeadFrame.Size = UDim2.new(1, 0, 0, 67)
	HeadFrame.ZIndex = 7

	LogoImage.Name = WinWare.RandomString();
	LogoImage.Parent = HeadFrame
	LogoImage.AnchorPoint = Vector2.new(0, 0.5)
	LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoImage.BackgroundTransparency = 1.000
	LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoImage.BorderSizePixel = 0
	LogoImage.Position = UDim2.new(0, 0, 0.5, 0)
	LogoImage.Size = UDim2.new(0, 0, 0, 0)
	LogoImage.ZIndex = 7
	LogoImage.Image = Window.Logo
	LogoImage.ImageColor3 = WinWare.IconColor

	UICorner_2.CornerRadius = UDim.new(0, 7)
	UICorner_2.Parent = LogoImage

	WindowName.Name = WinWare.RandomString();
	WindowName.Parent = HeadFrame
	WindowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.BackgroundTransparency = 1.000
	WindowName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowName.BorderSizePixel = 0
	WindowName.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowName.Position = UDim2.fromScale(0.5, 0.5)
	WindowName.Size = UDim2.fromOffset(0, 30)
	WindowName.AutomaticSize = Enum.AutomaticSize.X
	WindowName.ZIndex = 7
	WindowName.FontFace = WinWare.MontserratBold
	WindowName.Text = Window.Name
	WindowName.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.TextSize = 20.000
	WindowName.TextXAlignment = Enum.TextXAlignment.Center
	local WindowNameGradient = Instance.new("UIGradient", WindowName)
	WindowNameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 39, 88)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(96, 156, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(27, 39, 88)),
	})
	WindowNameGradient.Rotation = 0
	WinWare:EnableTextShimmer(WindowName, WindowNameGradient, {
		BaseColor = Color3.fromRGB(27, 39, 88),
		PeakColors = { Color3.fromRGB(27, 39, 88), Color3.fromRGB(96, 156, 255) },
		BandCount = 0.6,
		BandWidth = 0.75,
		SweepTime = 2,
		FitToText = true,
	});

	WindowContent.Name = WinWare.RandomString();
	WindowContent.Parent = HeadFrame
	WindowContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.BackgroundTransparency = 1.000
	WindowContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowContent.BorderSizePixel = 0
	WindowContent.Position = UDim2.new(0, 0, 0, 0)
	WindowContent.Size = UDim2.new(0, 0, 0, 0)
	WindowContent.ZIndex = 7
	WindowContent.FontFace = WinWare.MontserratBold
	WindowContent.Text = Window.Content
	WindowContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.TextSize = 9.000
	WindowContent.TextTransparency = 0.650
	WindowContent.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame.Name = WinWare.RandomString();
	LineFrame.Parent = HeadFrame
	LineFrame.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LineFrame.BackgroundTransparency = 0.950
	LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame.BorderSizePixel = 0
	LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame.Size = UDim2.new(1, 0, 0, 1)
	LineFrame.ZIndex = 5

	LeftScrollingFrame.Name = WinWare.RandomString();
	LeftScrollingFrame.Parent = LeftMenuFrame
	LeftScrollingFrame.Active = true
	LeftScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
	LeftScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LeftScrollingFrame.BackgroundTransparency = 1.000
	LeftScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LeftScrollingFrame.BorderSizePixel = 0
	LeftScrollingFrame.Position = UDim2.new(0.5, 0, 0, 74)
	LeftScrollingFrame.Size = UDim2.new(1, -14, 1, -163)
	LeftScrollingFrame.ZIndex = 7
	LeftScrollingFrame.ScrollBarThickness = 3
	LeftScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(219, 219, 219)
	LeftScrollingFrame.ScrollBarImageTransparency = 0.850
	LeftScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	LeftScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
	LeftScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

	UIListLayout.Parent = LeftScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 0)

	WinWare:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		LeftScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 1)
		LeftScrollingFrame.ScrollingEnabled = UIListLayout.AbsoluteContentSize.Y > LeftScrollingFrame.AbsoluteSize.Y;
	end)))

	BottomFrame.Name = WinWare.RandomString();
	BottomFrame.Parent = LeftMenuFrame
	BottomFrame.AnchorPoint = Vector2.new(0, 1)
	BottomFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BottomFrame.BackgroundTransparency = 1.000
	BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BottomFrame.BorderSizePixel = 0
	BottomFrame.Position = UDim2.new(0, 0, 1, 0)
	BottomFrame.Size = UDim2.new(1, 0, 0, 82)
	BottomFrame.ZIndex = 7

	AccountProfile.Name = WinWare.RandomString();
	AccountProfile.Parent = BottomFrame
	AccountProfile.AnchorPoint = Vector2.new(0, 0.5)
	AccountProfile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AccountProfile.BackgroundTransparency = 1.000
	AccountProfile.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AccountProfile.BorderSizePixel = 0
	AccountProfile.Position = UDim2.new(0, 10, 0.5, 0)
	AccountProfile.Size = UDim2.new(0, 50, 0, 50)
	AccountProfile.ZIndex = 7
	AccountProfile.Image = WinWare.UserProfile or ""

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = AccountProfile
	local AccountStroke = Instance.new("UIStroke", AccountProfile)
	AccountStroke.Color = Color3.fromRGB(255, 255, 255)
	AccountStroke.Thickness = 2.5
	AccountStroke.Transparency = 0

	local AccountStrokeGradient = Instance.new("UIGradient", AccountStroke)
	AccountStrokeGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 39, 88)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 126, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(96, 156, 255)),
	})
	AccountStrokeGradient.Rotation = 45

	AccountName.Name = WinWare.RandomString();
	AccountName.Parent = BottomFrame
	AccountName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AccountName.BackgroundTransparency = 1.000
	AccountName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AccountName.BorderSizePixel = 0
	AccountName.Position = UDim2.new(0, 68, 0, 22)
	AccountName.Size = UDim2.new(0, 112, 0, 18)
	AccountName.ZIndex = 7
	AccountName.FontFace = WinWare.MontserratBold
	AccountName.Text = ""
	AccountName.TextColor3 = Color3.fromRGB(219, 219, 219)
	AccountName.TextSize = 15.000
	AccountName.TextXAlignment = Enum.TextXAlignment.Left
	AccountName.TextTruncate = Enum.TextTruncate.AtEnd;
	local AccountNameGradient = Instance.new("UIGradient", AccountName)
	AccountNameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(43, 62, 127)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(127, 176, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(43, 62, 127)),
	})
	AccountNameGradient.Rotation = 0
	WinWare:EnableTextShimmer(AccountName, AccountNameGradient, {
		BaseColor = Color3.fromRGB(43, 62, 127),
		PeakColors = { Color3.fromRGB(43, 62, 127), Color3.fromRGB(127, 176, 255) },
		BandCount = 0.6,
		BandWidth = 0.75,
		SweepTime = 2.2,
		FitToText = true,
	});

	ExpireLabel.Name = WinWare.RandomString();
	ExpireLabel.Parent = BottomFrame
	ExpireLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ExpireLabel.BackgroundTransparency = 1.000
	ExpireLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExpireLabel.BorderSizePixel = 0
	ExpireLabel.Position = UDim2.new(0, 68, 0, 41)
	ExpireLabel.Size = UDim2.new(0, 100, 0, 16)
	ExpireLabel.ZIndex = 7
	ExpireLabel.FontFace = WinWare.MontserratSemiBold
	ExpireLabel.Text = "Never"
	ExpireLabel.TextColor3 = Color3.fromRGB(145, 145, 145)
	ExpireLabel.TextSize = 12.000
	ExpireLabel.TextTransparency = 0
	ExpireLabel.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame_2.Name = WinWare.RandomString();
	LineFrame_2.Parent = BottomFrame
	LineFrame_2.AnchorPoint = Vector2.new(0.5, 0)
	LineFrame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LineFrame_2.BackgroundTransparency = 0.950
	LineFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_2.BorderSizePixel = 0
	LineFrame_2.Position = UDim2.new(0.5, 0, 0, 0)
	LineFrame_2.Size = UDim2.new(1, 0, 0, 1)
	LineFrame_2.ZIndex = 5

	UserSettingButton.Name = WinWare.RandomString();
	UserSettingButton.Parent = BottomFrame
	UserSettingButton.AnchorPoint = Vector2.new(1, 0.5)
	UserSettingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserSettingButton.BackgroundTransparency = 1.000
	UserSettingButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserSettingButton.BorderSizePixel = 0
	UserSettingButton.Position = UDim2.new(1, -7, 0.5, 0)
	UserSettingButton.Size = UDim2.new(0, 25, 0, 25)
	UserSettingButton.ZIndex = 7
	UserSettingButton.FontFace = WinWare.BuiltInBold
	UserSettingButton.Text = "chevron-large-right"
	UserSettingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	UserSettingButton.TextSize = 13.000
	UserSettingButton.TextTransparency = 0.5
	UserSettingButton.Visible = false

	WinWare:AddSignal(BottomFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		WinWare.PlayAnimate(UserSettingButton,SlowyTween , {
			TextTransparency = 0.25
		})		
	end)))

	WinWare:AddSignal(BottomFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		WinWare.PlayAnimate(UserSettingButton,SlowyTween , {
			TextTransparency = 0.5
		})		
	end)))

	RightMenuFrame.Name = WinWare.RandomString();
	RightMenuFrame.Parent = WindowFrame
	RightMenuFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
	RightMenuFrame.BackgroundTransparency = 1
	RightMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RightMenuFrame.BorderSizePixel = 0
	RightMenuFrame.ClipsDescendants = true
	RightMenuFrame.Position = UDim2.new(0, 167, 0, 0)
	RightMenuFrame.Size = UDim2.new(1, -167, 1, 0)
	RightMenuFrame.ZIndex = 8

	VerticalDivider.Name = WinWare.RandomString()
	VerticalDivider.Parent = RightMenuFrame
	VerticalDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	VerticalDivider.BackgroundTransparency = 0.950
	VerticalDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
	VerticalDivider.BorderSizePixel = 0
	VerticalDivider.Position = UDim2.fromOffset(0, 0)
	VerticalDivider.Size = UDim2.new(0, 1, 1, 0)
	VerticalDivider.ZIndex = 9

	RightHeader.Name = WinWare.RandomString();
	RightHeader.Parent = RightMenuFrame
	RightHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	RightHeader.BackgroundTransparency = 1.000
	RightHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RightHeader.BorderSizePixel = 0
	RightHeader.Size = UDim2.new(1, 0, 0, 67)
	RightHeader.ZIndex = 9

	LineFrame_3.Name = WinWare.RandomString();
	LineFrame_3.Parent = RightHeader
	LineFrame_3.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LineFrame_3.BackgroundTransparency = 0.950
	LineFrame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_3.BorderSizePixel = 0
	LineFrame_3.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame_3.Size = UDim2.new(1, 0, 0, 1)
	LineFrame_3.ZIndex = 9

	ConfigFrame.Name = WinWare.RandomString();
	ConfigFrame.Parent = RightHeader
	ConfigFrame.AnchorPoint = Vector2.new(0, 0.5)
	ConfigFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 22)
	ConfigFrame.BackgroundTransparency = 0.750
	ConfigFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigFrame.BorderSizePixel = 0
	ConfigFrame.Position = UDim2.new(0, 10, 0.5, 0)
	ConfigFrame.Size = UDim2.new(0, 115, 0, 30)
	ConfigFrame.ZIndex = 9
	ConfigFrame.Visible = false

	UIStroke_2.Transparency = 0.650
	UIStroke_2.Color = Color3.fromRGB(45, 45, 45)
	UIStroke_2.Parent = ConfigFrame

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = ConfigFrame

	ConfigIcon.Name = WinWare.RandomString();
	ConfigIcon.Parent = ConfigFrame
	ConfigIcon.AnchorPoint = Vector2.new(0, 0.5)
	ConfigIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigIcon.BackgroundTransparency = 1.000
	ConfigIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigIcon.BorderSizePixel = 0
	ConfigIcon.Position = UDim2.new(0, 2, 0.5, 0)
	ConfigIcon.Size = UDim2.new(0, 25, 0, 25)
	ConfigIcon.ZIndex = 9
	ConfigIcon.FontFace = WinWare.BuiltInBold
	ConfigIcon.Text = "floppy-disk"
	ConfigIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	ConfigIcon.TextSize = 16.000
	ConfigIcon.TextTransparency = 0.250
	ConfigIcon.TextWrapped = true

	LineFrame_4.Name = WinWare.RandomString();
	LineFrame_4.Parent = ConfigFrame
	LineFrame_4.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	LineFrame_4.BackgroundTransparency = 0.650
	LineFrame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_4.BorderSizePixel = 0
	LineFrame_4.Position = UDim2.new(0, 30, 0, 0)
	LineFrame_4.Size = UDim2.new(0, 1, 1, 0)

	ConfigName.Name = WinWare.RandomString();
	ConfigName.Parent = ConfigFrame
	ConfigName.AnchorPoint = Vector2.new(0, 0.5)
	ConfigName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigName.BackgroundTransparency = 1.000
	ConfigName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigName.BorderSizePixel = 0
	ConfigName.Position = UDim2.new(0, 40, 0.5, 0)
	ConfigName.Size = UDim2.new(1, -7, 0, 15)
	ConfigName.ZIndex = 9
	ConfigName.FontFace = WinWare.MontserratMedium
	ConfigName.Text = "Default"
	ConfigName.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigName.TextSize = 12.000
	ConfigName.TextTransparency = 0.350
	ConfigName.TextXAlignment = Enum.TextXAlignment.Left

	ConfigBthIcon.Name = WinWare.RandomString();
	ConfigBthIcon.Parent = ConfigFrame
	ConfigBthIcon.AnchorPoint = Vector2.new(1, 0.5)
	ConfigBthIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigBthIcon.BackgroundTransparency = 1.000
	ConfigBthIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigBthIcon.BorderSizePixel = 0
	ConfigBthIcon.Position = UDim2.new(1, -2, 0.5, 0)
	ConfigBthIcon.Size = UDim2.new(0, 25, 0, 25)
	ConfigBthIcon.ZIndex = 9
	ConfigBthIcon.FontFace = WinWare.BuiltInBold
	ConfigBthIcon.Text = "chevron-small-down"
	ConfigBthIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	ConfigBthIcon.TextSize = 16.000
	ConfigBthIcon.TextTransparency = 0.250
	ConfigBthIcon.TextWrapped = true

	Window.Website = Window.Website or "https://sorrelhub.xyz/";

	function Window:SetWebsite(Link: string)
		Window.Website = Link;
	end;

	SearchFrame.Name = WinWare.RandomString();
	SearchFrame.Parent = RightHeader
	SearchFrame.AnchorPoint = Vector2.new(1, 0.5)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	SearchFrame.BackgroundTransparency = 0.150
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.ClipsDescendants = true
	SearchFrame.Position = UDim2.new(1, -64, 0.5, 0)
	SearchFrame.Size = UDim2.new(0.6, 0, 0, 47)
	SearchFrame.ZIndex = 12
	SearchFrame.Visible = true

	local SearchCorner = Instance.new("UICorner", SearchFrame)
	SearchCorner.CornerRadius = UDim.new(0, 13)

	local SearchStroke = Instance.new("UIStroke", SearchFrame)
	SearchStroke.Color = WinWare.PopupStrokeColor
	SearchStroke.Transparency = 0.950
	SearchStroke.Thickness = 1.3

	local WebFrame = Instance.new("Frame")
	local WebIcon = Instance.new("TextLabel")

	WebFrame.Name = WinWare.RandomString();
	WebFrame.Parent = RightHeader
	WebFrame.AnchorPoint = Vector2.new(1, 0.5)
	WebFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	WebFrame.BackgroundTransparency = 0.150
	WebFrame.BorderSizePixel = 0
	WebFrame.Position = UDim2.new(1, -10, 0.5, 0)
	WebFrame.Size = UDim2.new(0, 47, 0, 47)
	WebFrame.ZIndex = 12

	local WebCorner = Instance.new("UICorner", WebFrame)
	WebCorner.CornerRadius = UDim.new(0, 13)

	local WebStroke = Instance.new("UIStroke", WebFrame)
	WebStroke.Color = WinWare.PopupStrokeColor
	WebStroke.Transparency = 0.950
	WebStroke.Thickness = 1.3

	WebIcon.Name = WinWare.RandomString();
	WebIcon.Parent = WebFrame
	WebIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	WebIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WebIcon.BackgroundTransparency = 1.000
	WebIcon.BorderSizePixel = 0
	WebIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	WebIcon.Size = UDim2.new(0, 24, 0, 24)
	WebIcon.ZIndex = 12
	WebIcon.FontFace = WinWare.BuiltInBold
	WebIcon.Text = "globe-simplified"
	WebIcon.TextColor3 = Color3.fromRGB(219, 219, 219)
	WebIcon.TextSize = 20.000
	WebIcon.TextWrapped = true

	WinWare:CreateInput(WebFrame , LPH_NO_VIRTUALIZE(function()
		setclipboard(Window.Website);

		WinWare.PlayAnimate(WebIcon , SlowyTween , {
			TextColor3 = Color3.fromRGB(60, 126, 255)
		});

		task.delay(0.7 , LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(WebIcon , SlowyTween , {
				TextColor3 = Color3.fromRGB(219, 219, 219)
			});
		end));
	end));

	SearchIcon.Name = WinWare.RandomString();
	SearchIcon.Parent = SearchFrame
	SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
	SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchIcon.BackgroundTransparency = 1.000
	SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchIcon.BorderSizePixel = 0
	SearchIcon.Position = UDim2.new(0, 12, 0.5, 0)
	SearchIcon.Size = UDim2.new(0, 26, 0, 26)
	SearchIcon.ZIndex = 12
	SearchIcon.FontFace = WinWare.BuiltInBold
	SearchIcon.Text = "magnifying-glass"
	SearchIcon.TextColor3 = Color3.fromRGB(76, 76, 76)
	SearchIcon.TextSize = 20.000
	SearchIcon.TextTransparency = 0
	SearchIcon.TextWrapped = true

	SearchBox.Name = WinWare.RandomString();
	SearchBox.Parent = SearchFrame
	SearchBox.AnchorPoint = Vector2.new(0, 0.5)
	SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.BackgroundTransparency = 1.000
	SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchBox.BorderSizePixel = 0
	SearchBox.Position = UDim2.new(0, 46, 0.5, 0)
	SearchBox.Size = UDim2.new(1, -58, 0, 28)
	SearchBox.ZIndex = 12
	SearchBox.ClearTextOnFocus = false
	SearchBox.FontFace = WinWare.MontserratMedium
	SearchBox.PlaceholderText = "Search"
	SearchBox.PlaceholderColor3 = Color3.fromRGB(76, 76, 76)
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(206, 206, 206)
	SearchBox.TextSize = 17.000
	SearchBox.TextTransparency = 0.350
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	TabContainer.Name = WinWare.RandomString();
	TabContainer.Parent = RightMenuFrame
	TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabContainer.BorderSizePixel = 0
	TabContainer.ClipsDescendants = true
	TabContainer.Position = UDim2.new(0, 0, 0, 67)
	TabContainer.Size = UDim2.new(1, 0, 1, -67)
	TabContainer.ZIndex = 5

	do
		Window.Searching = false;
		local Input = WinWare:CreateInput(SearchIcon , LPH_NO_VIRTUALIZE(function()
			Window.Searching = true;

			SearchBox:CaptureFocus();
		end));	

		local wati_for_finish = tick();
		local last_thread;
		local max_time = 0.2;

		WinWare:AddSignal(SearchBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
			if not SearchBox.Text:byte() then
				for i,v in next , WinWare.NameRegisitry do
					v.Root.Visible = true;
				end;

				return;	
			end;

			wati_for_finish = tick();

			if last_thread then
				task.cancel(last_thread);
				last_thread = nil;
			end;

			last_thread = task.delay(max_time,function()
				if SearchBox.Text:byte() and (tick() - wati_for_finish) > max_time then
					for i,v in next , WinWare.NameRegisitry do
						if string.find(string.lower(v.Idx) , string.lower(SearchBox.Text), 1, true) then
							v.Root.Visible = true;
						else
							v.Root.Visible = false;
						end;
					end;
				end;
			end);
		end)));

		WinWare:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 0.25
			})
		end)))

		WinWare:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Searching then
				WinWare.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.25
				})
			else
				WinWare.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.45
				})
			end;
		end)));
	end;

	if Window.Enable3DRenderer then
		local Part = Instance.new('Part');

		Part.Name = WinWare.RandomString();
		Part.Anchored = true;
		Part.Transparency = 1;
		Part.CanCollide = false;
		Part.CanTouch = false;
		Part.AudioCanCollide = false;
		Part.CollisionGroup = WinWare.RandomString();
		Part.CFrame = CFrame.new(0,0,0);
		Part.Size = Vector3.zero;

		local SurfaceGui = Instance.new("SurfaceGui")

		SurfaceGui.Parent = WinWare.ScreenGui;
		SurfaceGui.Adornee = Part;
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		SurfaceGui.AlwaysOnTop = true
		SurfaceGui.LightInfluence = 1.000
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
		SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
		SurfaceGui.PixelsPerStud = 40;

		Window.SurfaceGui = SurfaceGui;
		WinWare.GlobalSurfaceGui = SurfaceGui;

		local PerfectScale = Vector2.new(1920 , 1080 + 300)

		Window.Load3DBlock = LPH_NO_VIRTUALIZE(function()
			if not Window.Signal:GetValue() then
				local _,OnScreen = CurrentCamera:WorldToViewportPoint(Part.Position);

				if OnScreen then
					WinWare.PlayAnimate(Part,VSlowTween , {
						CFrame = CurrentCamera.CFrame * CFrame.new(0,0,-15) * CFrame.Angles(0,math.rad(180),0);
					});
				end;

				return
			end;

			local Dimensions = 50;

			local XY_Incom = Vector2.new(PerfectScale.X + 5, PerfectScale.Y * 1.35) / (Dimensions / 2);
			local PerfectDistance = XY_Incom.Magnitude;
			local SizeIndicator = PerfectDistance / 1.35;

			Part.Parent = WinWare.BlurModuleParent or workspace;

			WinWare.PlayAnimate(Part,VSlowTween , {
				CFrame = (CurrentCamera.CFrame * CFrame.new(0,0,-25)) * CFrame.Angles(0,math.rad(180),0);
			});

			Part.Size = Vector3.new(PerfectScale.X / SizeIndicator,PerfectScale.Y / SizeIndicator,0);
		end);

		function Window:Set3DRender(val)
			Window.__3DRender = val;
			WinWare.Global3DRenderMode = val;

			if val then
				Window.Load3DBlock();
			else


				Part.Parent = nil;
			end;

			renderParentWindow();
		end;
	end;

	function Window:AddTabLabel(Name: string)
		local TabLabel = Instance.new("TextLabel")

		local LabelOrder = (LeftScrollingFrame:GetAttribute("SidebarOrder") or 0) + 10;
		LeftScrollingFrame:SetAttribute("SidebarOrder" , LabelOrder);

		TabLabel.Name = WinWare.RandomString()
		TabLabel.Parent = LeftScrollingFrame
		TabLabel.LayoutOrder = LabelOrder
		TabLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabLabel.BackgroundTransparency = 1.000
		TabLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabLabel.BorderSizePixel = 0
		TabLabel.Size = UDim2.new(1, -7, 0, 15)
		TabLabel.ZIndex = 8
		TabLabel.FontFace = WinWare.MontserratBold
		TabLabel.Text = Name
		TabLabel.TextColor3 = Color3.fromRGB(76, 76, 76)
		TabLabel.TextSize = 12.000
		TabLabel.TextTransparency = 0
		TabLabel.TextXAlignment = Enum.TextXAlignment.Center
		if #Window.Tabs > 0 then
			TabLabel.Size = UDim2.new(1, -7, 0, 28)
			TabLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		end

		TabLabel.TextTransparency = 0;
	end;

	function Window:AddTab(Config)
		Config = WinWare:ProcessParams(Config , {
			Icon = "crosshairs",
			Name = "Tab",
			Type = "Double",
			Parent = false
		});

		local Tab = {
			Signal = WinWare:CreateSignal(false);
		};

		local TabButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local TabIcon = Instance.new("TextLabel")
		local TabContentLabel = Instance.new("TextLabel")
		local TabStroke = Instance.new("UIStroke")
		local SubIndicator = Instance.new("TextLabel")
		local SubHolder = Instance.new("Frame")
		local SubList = Instance.new("Frame")
		local SubLayout = Instance.new("UIListLayout")
		local SubLine = Instance.new("Frame")
		local SubLineCorner = Instance.new("UICorner")

		local ParentTab = Config.Parent;
		local IsSubTab = typeof(ParentTab) == "table" and ParentTab.SubList ~= nil;
		local TabRoot = IsSubTab and ParentTab.SubList or LeftScrollingFrame;

		local TabOrder = (LeftScrollingFrame:GetAttribute("SidebarOrder") or 0) + 10;
		LeftScrollingFrame:SetAttribute("SidebarOrder" , TabOrder);

		Tab.Idx = TabButton;
		Tab.SubCount = 0;
		Tab.SubExpanded = false;
		Tab.SubHolder = SubHolder;
		Tab.SubList = SubList;

		TabButton.Name = WinWare.RandomString();
		TabButton.Parent = TabRoot
		TabButton.LayoutOrder = TabOrder
		TabButton.BackgroundColor3 = Color3.fromRGB(60, 126, 255)
		TabButton.BackgroundTransparency = 1
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, -6, 0, 43)
		TabButton.ZIndex = 8

		UICorner.CornerRadius = UDim.new(0, 9)
		UICorner.Parent = TabButton
		TabStroke.Color = Color3.fromRGB(60, 126, 255)
		TabStroke.Thickness = 2
		TabStroke.Transparency = 1
		TabStroke.Parent = TabButton

		TabIcon.Name = WinWare.RandomString();
		TabIcon.Parent = TabButton
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabIcon.BorderSizePixel = 0
		TabIcon.Position = UDim2.new(0, 7, 0.5, 0)
		TabIcon.Size = UDim2.new(0, 23, 0, 23)
		TabIcon.ZIndex = 9
		TabIcon.FontFace = WinWare.BuiltInBold
		TabIcon.Text = Config.Icon;
		TabIcon.TextColor3 = WinWare.AccentColor
		TabIcon.TextSize = 18.000
		TabIcon.TextWrapped = true

		TabContentLabel.Name = WinWare.RandomString();
		TabContentLabel.Parent = TabButton
		TabContentLabel.AnchorPoint = Vector2.new(0, 0.5)
		TabContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.BackgroundTransparency = 1.000
		TabContentLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContentLabel.BorderSizePixel = 0
		TabContentLabel.Position = UDim2.new(0, 37, 0.5, 0)
		TabContentLabel.Size = UDim2.new(1, -44, 0, 18)
		TabContentLabel.ZIndex = 9
		TabContentLabel.FontFace = WinWare.MontserratSemiBold
		TabContentLabel.Text = Config.Name
		TabContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.TextSize = 15.000
		TabContentLabel.TextXAlignment = Enum.TextXAlignment.Left

		SubIndicator.Name = WinWare.RandomString();
		SubIndicator.Parent = TabButton
		SubIndicator.AnchorPoint = Vector2.new(1, 0.5)
		SubIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SubIndicator.BackgroundTransparency = 1.000
		SubIndicator.BorderSizePixel = 0
		SubIndicator.Position = UDim2.new(1, -8, 0.5, 0)
		SubIndicator.Size = UDim2.new(0, 16, 0, 16)
		SubIndicator.ZIndex = 9
		SubIndicator.FontFace = WinWare.BuiltInBold
		SubIndicator.Text = "chevron-small-down"
		SubIndicator.TextColor3 = Color3.fromRGB(219, 219, 219)
		SubIndicator.TextSize = 15.000
		SubIndicator.TextTransparency = 0.550
		SubIndicator.TextWrapped = true
		SubIndicator.Rotation = -90
		SubIndicator.Visible = false

		SubHolder.Name = WinWare.RandomString();
		SubHolder.Parent = TabRoot
		SubHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SubHolder.BackgroundTransparency = 1.000
		SubHolder.BorderSizePixel = 0
		SubHolder.ClipsDescendants = true
		SubHolder.LayoutOrder = TabOrder + 1
		SubHolder.Size = UDim2.new(1, -1, 0, 0)
		SubHolder.ZIndex = 8
		SubHolder.Visible = false

		SubLine.Name = WinWare.RandomString();
		SubLine.Parent = SubHolder
		SubLine.BackgroundColor3 = Color3.fromRGB(219, 219, 219)
		SubLine.BackgroundTransparency = 0.900
		SubLine.BorderSizePixel = 0
		SubLine.Position = UDim2.new(0, 12, 0, 6)
		SubLine.Size = UDim2.new(0, 2, 1, -12)
		SubLine.ZIndex = 8

		SubLineCorner.CornerRadius = UDim.new(1, 0)
		SubLineCorner.Parent = SubLine

		SubList.Name = WinWare.RandomString();
		SubList.Parent = SubHolder
		SubList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SubList.BackgroundTransparency = 1.000
		SubList.BorderSizePixel = 0
		SubList.Position = UDim2.new(0, 26, 0, 4)
		SubList.Size = UDim2.new(1, -32, 1, -8)
		SubList.ZIndex = 8

		SubLayout.Parent = SubList
		SubLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
		SubLayout.Padding = UDim.new(0, 2)

		Tab.RefreshSub = LPH_NO_VIRTUALIZE(function()
			SubIndicator.Visible = Tab.SubCount > 0;

			if Tab.SubExpanded and Tab.SubCount > 0 then
				SubHolder.Size = UDim2.new(1, -1, 0, Tab.SubCount * 38 + 8);
			end;
		end);

		Tab.SetSubExpanded = LPH_NO_VIRTUALIZE(function(state)
			if Tab.SubCount == 0 then
				Tab.SubExpanded = false;
				SubHolder.Visible = false;
				SubHolder.Size = UDim2.new(1, -1, 0, 0);

				return;
			end;

			Tab.SubExpanded = state;

			if state then
				SubHolder.Visible = true;

				WinWare.PlayAnimate(SubHolder , VSlowTween , {
					Size = UDim2.new(1, -1, 0, Tab.SubCount * 38 + 8)
				});

				WinWare.PlayAnimate(SubIndicator , SlowyTween , {
					Rotation = 0,
					TextTransparency = 0.250
				});
			else
				WinWare.PlayAnimate(SubHolder , VSlowTween , {
					Size = UDim2.new(1, -1, 0, 0)
				});

				WinWare.PlayAnimate(SubIndicator , SlowyTween , {
					Rotation = -90,
					TextTransparency = 0.550
				});

				task.delay(0.45 , LPH_NO_VIRTUALIZE(function()
					if not Tab.SubExpanded then
						SubHolder.Visible = false;
					end;
				end));
			end;
		end);

		if IsSubTab then
			TabButton.Size = UDim2.new(1, 0, 0, 36)
			TabButton.LayoutOrder = ParentTab.SubCount + 1
			TabIcon.Position = UDim2.new(0, 6, 0.5, 0)
			TabIcon.Size = UDim2.new(0, 20, 0, 20)
			TabIcon.TextSize = 16.000
			TabContentLabel.Position = UDim2.new(0, 32, 0.5, 0)
			TabContentLabel.Size = UDim2.new(1, -38, 0, 16)
			TabContentLabel.TextSize = 13.000
			SubHolder.LayoutOrder = ParentTab.SubCount + 2

			ParentTab.SubCount = ParentTab.SubCount + 1;
			ParentTab.RefreshSub();
		end;

		local TabFrame = Instance.new("Frame")
		local LeftScroll = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local RightScroll = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")

		TabFrame.Name = WinWare.RandomString();
		TabFrame.Parent = TabContainer
		TabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabFrame.BackgroundTransparency = 1.000
		TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabFrame.BorderSizePixel = 0
		TabFrame.ClipsDescendants = true
		TabFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.Visible = true;

		LeftScroll.Name = WinWare.RandomString();
		LeftScroll.Parent = TabFrame
		LeftScroll.Active = true
		LeftScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		LeftScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LeftScroll.BackgroundTransparency = 1.000
		LeftScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LeftScroll.BorderSizePixel = 0
		LeftScroll.ClipsDescendants = false
		LeftScroll.Position = UDim2.new(0.25, -4, 0.5, 0)
		LeftScroll.Size = UDim2.new(0.5, -14, 1, -34)
		LeftScroll.ScrollBarThickness = 0

		UIListLayout.Parent = LeftScroll
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 7)

		WinWare:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			LeftScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 1)
		end)))

		RightScroll.Name = WinWare.RandomString();
		RightScroll.Parent = TabFrame
		RightScroll.Active = true
		RightScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		RightScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		RightScroll.BackgroundTransparency = 1.000
		RightScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		RightScroll.BorderSizePixel = 0
		RightScroll.ClipsDescendants = false
		RightScroll.Position = UDim2.new(0.75, 4, 0.5, 0)
		RightScroll.Size = UDim2.new(0.5, -14, 1, -34)
		RightScroll.ScrollBarThickness = 0

		UIListLayout_2.Parent = RightScroll
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 7)

		if Config.Type == "Single" then
			UIListLayout_2:Destroy();
			RightScroll:Destroy();
			RightScroll = LeftScroll;
			UIListLayout_2 = UIListLayout;
			LeftScroll.Size = UDim2.new(1, 0, 1, -5);
			LeftScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
		else
			WinWare:AddSignal(UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				RightScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 1)
			end)))
		end;

		WinWare:AddSignal(TabIcon:GetPropertyChangedSignal('TextTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if TabIcon.TextTransparency > 0.4 then
				UIListLayout.Parent = nil;
				UIListLayout_2.Parent = nil;
				TabFrame.Visible = false;
				TabFrame.Parent = nil
			else
				UIListLayout.Parent = LeftScroll;
				UIListLayout_2.Parent = RightScroll;
				TabFrame.Visible = true;
				TabFrame.Parent = TabContainer;
			end;
		end)));

		Tab.SetValue = LPH_NO_VIRTUALIZE(function(value)
			Tab.Signal:SetValue(value);

			if value then
				WinWare.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.960
				})
				WinWare.PlayAnimate(TabStroke , SlowyTween , {Transparency = 0.900})

				WinWare.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 0,
					TextColor3 = Color3.fromRGB(60, 126, 255)
				})

				WinWare.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 0,
					TextColor3 = Color3.fromRGB(60, 126, 255)
				})
			else
				WinWare.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})
				WinWare.PlayAnimate(TabStroke , SlowyTween , {Transparency = 1})

				WinWare.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 0.5,
					TextColor3 = Color3.fromRGB(219, 219, 219)
				})

				WinWare.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 0,
					TextColor3 = Color3.fromRGB(219, 219, 219)
				})
			end;
		end);

		table.insert(Window.Tabs,Tab);

		if Window.Tabs[Window.CurrentTab] == Tab then
			Tab.SetValue(true)
		else
			Tab.SetValue(false);
		end;

		local TabInput = WinWare:CreateInput(TabButton,LPH_NO_VIRTUALIZE(function()
			for i,v in next , Window.Tabs do
				if v.Idx == TabButton then
					v.SetValue(true);
					Window.CurrentTab = i;
				else
					v.SetValue(false);
				end;
			end;

			if IsSubTab and not ParentTab.SubExpanded then
				ParentTab.SetSubExpanded(true);
			end;
		end));

		WinWare:AddSignal(TabInput.MouseButton2Click:Connect(LPH_NO_VIRTUALIZE(function()
			Tab.SetSubExpanded(not Tab.SubExpanded);
		end)));

		Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
			if value then
				Tab.SetValue(Window.Tabs[Window.CurrentTab] == Tab);
			end;
		end));

		function Tab:AddSection(Config)
			Config = WinWare:ProcessParams(Config , {
				Name = "SECTION",
				Position = 'left'
			});

			local SectionFrame = Instance.new("Frame")
			local SectionLabel = Instance.new("TextLabel")
			local SectionHandler = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")

			SectionFrame.Name = WinWare.RandomString();
			SectionFrame.Parent = (string.lower(Config.Position) == 'left' and LeftScroll) or RightScroll
			SectionFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			SectionFrame.BackgroundTransparency = 1.000
			SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionFrame.BorderSizePixel = 0
			SectionFrame.ClipsDescendants = false
			SectionFrame.Size = UDim2.new(1, -5, 0, 0)
			SectionFrame.ZIndex = 9

			SectionLabel.Name = WinWare.RandomString();
			SectionLabel.Parent = SectionFrame
			SectionLabel.AnchorPoint = Vector2.new(0.5, 0)
			SectionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionLabel.BackgroundTransparency = 1.000
			SectionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionLabel.BorderSizePixel = 0
			SectionLabel.Position = UDim2.new(0.5, 0, 0, 0)
			SectionLabel.Size = UDim2.new(1, 0, 0, 14)
			SectionLabel.ZIndex = 9
			SectionLabel.FontFace = WinWare.MontserratSemiBold
			SectionLabel.Text = Config.Name
			SectionLabel.TextColor3 = Color3.fromRGB(76, 76, 76)
			SectionLabel.TextSize = 15.000
			SectionLabel.TextTransparency = 0
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

			SectionHandler.Name = WinWare.RandomString();
			SectionHandler.Parent = SectionFrame
			SectionHandler.AnchorPoint = Vector2.new(0.5, 0)
			SectionHandler.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			SectionHandler.BackgroundTransparency = 1
			SectionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionHandler.BorderSizePixel = 0
			SectionHandler.ClipsDescendants = true
			SectionHandler.Position = UDim2.new(0.5, 0, 0, 20)
			SectionHandler.Size = UDim2.new(1, -4, 0, 0)
			SectionHandler.ZIndex = 9

			UIStroke.Transparency = 0.950
			UIStroke.Color = Color3.fromRGB(255, 255, 255)
			UIStroke.Thickness = 1
			UIStroke.Parent = SectionHandler

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = SectionHandler

			UIListLayout.Parent = SectionHandler
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.Padding = UDim.new(0, 0)

			local UpdateRowDividers = LPH_NO_VIRTUALIZE(function()
				local Rows = {};

				for _, Child in ipairs(SectionHandler:GetChildren()) do
					if Child:IsA("GuiObject") then
						table.insert(Rows, Child);
					end
				end

				for Index, Row in ipairs(Rows) do
					for _, Item in ipairs(Row:GetDescendants()) do
						if Item:GetAttribute("RowDivider") then
							Item.Visible = Index < #Rows;
						end
					end
				end
			end)

			WinWare:AddSignal(SectionHandler.ChildAdded:Connect(function()
				task.defer(UpdateRowDividers);
			end))

			WinWare:AddSignal(SectionHandler.ChildRemoved:Connect(function()
				task.defer(UpdateRowDividers);
			end))

			local SectionPadding = Instance.new("UIPadding")
			SectionPadding.PaddingTop = UDim.new(0, 0)
			SectionPadding.PaddingBottom = UDim.new(0, 0)
			SectionPadding.Parent = SectionHandler
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()


				local ContentHeight = UIListLayout.AbsoluteContentSize.Y;

				if ContentHeight <= 1 then
					WinWare.PlayAnimate(SectionFrame , VSlowTween , {
						Size = UDim2.new(1, -5, 0, 0)
					})

					WinWare.PlayAnimate(SectionHandler , VSlowTween , {
						Size = UDim2.new(1, -4, 0, 0)
					})
				else
					WinWare.PlayAnimate(SectionFrame , VSlowTween , {
						Size = UDim2.new(1, -5, 0, ContentHeight + 22)
					})

					WinWare.PlayAnimate(SectionHandler , VSlowTween , {
						Size = UDim2.new(1, -4, 0, ContentHeight)
					})
				end;
			end));

			local Section = WinWare:RegisiterItem(SectionHandler , Tab.Signal);

			Section.SetRender = LPH_NO_VIRTUALIZE(function(value)
				if value then
					WinWare.PlayAnimate(SectionLabel,SlowyTween,{
						TextTransparency = 0
					})

					WinWare.PlayAnimate(SectionHandler,SlowyTween,{
						BackgroundTransparency = 0
					})

					WinWare.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.950
					})
				else
					WinWare.PlayAnimate(SectionLabel,SlowyTween,{
						TextTransparency = 1
					})

					WinWare.PlayAnimate(SectionHandler,SlowyTween,{
						BackgroundTransparency = 1
					})

					WinWare.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 1
					})
				end;
			end);

			Section.SetRender(Tab.Signal:GetValue());
			Tab.Signal:Connect(Section.SetRender);

			return Section;
		end;

		return Tab;
	end;

	function Window:_InitConfig()
		local ConfigSignal = WinWare:CreateSignal(false);
		local ConfigLib = {
			Signals = {},
		};

		local ConfigMenu = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local UIStroke = Instance.new("UIStroke")
		local InputFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local TextInput = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")
		local LoadConfig = Instance.new("Frame")
		local Icon = Instance.new("TextLabel")
		local UICorner_3 = Instance.new("UICorner")
		local UICorner_4 = Instance.new("UICorner")

		local shadow = WinWare:CreateShadow(ConfigMenu);

		ConfigLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ConfigMenu.Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 96)

				WinWare.PlayAnimate(ConfigMenu , SlowyTween , {
					BackgroundTransparency = 0.100,
					Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 95)
				})	

				WinWare.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = WinWare.PopupStrokeTransparency
				})
				WinWare.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.200
				})	

				WinWare.PlayAnimate(UIStroke_2 , SlowyTween , {
					Transparency = 0.65
				})	

				WinWare.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				})	
				WinWare.PlayAnimate(TextInput , SlowyTween , {
					BackgroundTransparency = 0
				})	
				WinWare.PlayAnimate(TextBox , SlowyTween , {
					TextTransparency = 0.050
				})	
				WinWare.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.050
				})	

				WinWare.PlayAnimate(ConfigBthIcon , SlowyTween , {
					Rotation = 180
				})	

				shadow:Render(true)
			else
				WinWare.PlayAnimate(ConfigBthIcon , SlowyTween , {
					Rotation = 0
				})

				WinWare.PlayAnimate(ConfigMenu , SlowyTween , {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 96)
				})	

				WinWare.PlayAnimate(UIStroke_2 , SlowyTween , {
					Transparency = 1
				})	

				WinWare.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				})
				WinWare.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				})	
				WinWare.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				})	
				WinWare.PlayAnimate(TextInput , SlowyTween , {
					BackgroundTransparency = 1
				})	
				WinWare.PlayAnimate(TextBox , SlowyTween , {
					TextTransparency = 1
				})	
				WinWare.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				})	

				shadow:Render(false)
			end;
		end);

		WinWare:AddSignal(ConfigMenu:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if ConfigMenu.BackgroundTransparency > 0.9 then
				ConfigMenu.Visible = false;
				UIListLayout.Parent = nil;
				ConfigMenu.Parent = nil;
			else

				ConfigMenu.Visible = true;
				UIListLayout.Parent = ConfigMenu

				if WinWare.Global3DRenderMode then
					ConfigMenu.Parent = WinWare.GlobalSurfaceGui;
				else
					ConfigMenu.Parent = WinWare.ScreenGui;
				end;
			end
		end)))

		ConfigMenu.Name = WinWare.RandomString();
		ConfigMenu.Parent = WinWare.ScreenGui;
		ConfigMenu.AnchorPoint = Vector2.new(0.5, 0)
		ConfigMenu.BackgroundColor3 = WinWare.PopupSurfaceColor
		ConfigMenu.BackgroundTransparency = 0.100
		WinWare.ApplyPopupSurface(ConfigMenu , 0.040);
		ConfigMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ConfigMenu.BorderSizePixel = 0
		ConfigMenu.ClipsDescendants = true
		ConfigMenu.Position = UDim2.new(255,255,255,255)
		ConfigMenu.Size = UDim2.new(0, 220,0, 110)
		ConfigMenu.ZIndex = 151

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ConfigMenu

		UIListLayout.Parent = ConfigMenu
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		UIStroke.Transparency = WinWare.PopupStrokeTransparency
		UIStroke.Color = WinWare.PopupStrokeColor
		UIStroke.Parent = ConfigMenu
		ApplyPopupGradient(ConfigMenu)

		InputFrame.Name = WinWare.RandomString();
		InputFrame.Parent = ConfigMenu
		InputFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
		InputFrame.BackgroundTransparency = 1.000
		InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputFrame.BorderSizePixel = 0
		InputFrame.Size = UDim2.new(1, 0, 0, 30)
		InputFrame.ZIndex = 154

		BasedLabel.Name = WinWare.RandomString();
		BasedLabel.Parent = InputFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 11, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = 154
		BasedLabel.FontFace = WinWare.MontserratMedium
		BasedLabel.Text = "Config"
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 14.000
		BasedLabel.TextTransparency = 0.200
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = WinWare.RandomString();
		LineFrame.Parent = InputFrame
		LineFrame.Visible = false
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 2)
		LineFrame.ZIndex = 154

		BasedHandler.Name = WinWare.RandomString();
		BasedHandler.Parent = InputFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedHandler.BorderSizePixel = 0
		BasedHandler.Position = UDim2.new(1, -11, 0, 2)
		BasedHandler.Size = UDim2.new(1, -20, 0, 25)
		BasedHandler.ZIndex = 154

		UIListLayout_2.Parent = BasedHandler
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout_2.Padding = UDim.new(0, 5)

		WinWare:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			if #ConfigLib.Signals <= 0 then
				WinWare.PlayAnimate(ConfigMenu , SlowyTween , {
					Size = UDim2.new(0, 220,0, UIListLayout.AbsoluteContentSize.Y + 0);
				})
			else
				WinWare.PlayAnimate(ConfigMenu , SlowyTween , {
					Size = UDim2.new(0, 220,0, UIListLayout.AbsoluteContentSize.Y + 5);
				})
			end;

		end)));

		TextInput.Name = WinWare.RandomString();
		TextInput.Parent = BasedHandler
		TextInput.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.ClipsDescendants = true
		TextInput.Size = UDim2.new(0, 100, 0, 18)
		TextInput.ZIndex = 154

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = TextInput

		UIStroke_2.Transparency = 0.650
		UIStroke_2.Color = Color3.fromRGB(45, 45, 45)
		UIStroke_2.Parent = TextInput

		TextBox.Parent = TextInput
		TextBox.AnchorPoint = Vector2.new(0, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0, 8, 0.5, 0)
		TextBox.Size = UDim2.new(1, -16, 1, 0)
		TextBox.ZIndex = 154
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = WinWare.MontserratMedium
		TextBox.PlaceholderText = "Config Name ..."
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(206, 206, 206)
		TextBox.TextSize = 14.000
		TextBox.TextTransparency = 0
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		LoadConfig.Name = WinWare.RandomString();
		LoadConfig.Parent = BasedHandler
		LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
		LoadConfig.BackgroundTransparency = 1.000
		LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LoadConfig.BorderSizePixel = 0
		LoadConfig.ClipsDescendants = true
		LoadConfig.Size = UDim2.new(0, 20, 0, 18)
		LoadConfig.ZIndex = 153

		Icon.Name = WinWare.RandomString();
		Icon.Parent = LoadConfig
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = 153
		Icon.FontFace = WinWare.BuiltInBold
		Icon.Text = "plus-large"
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 16.000
		Icon.TextTransparency = 0.350
		Icon.TextWrapped = true

		UICorner_3.CornerRadius = UDim.new(0, 4)
		UICorner_3.Parent = LoadConfig

		UICorner_4.CornerRadius = UDim.new(0, 10)
		UICorner_4.Parent = InputFrame

		local OpenButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")

		OpenButton.Name = WinWare.RandomString();
		OpenButton.Parent = ConfigFrame
		OpenButton.AnchorPoint = Vector2.new(0, 0.5)
		OpenButton.BackgroundColor3 = WinWare.PopupSurfaceTopColor
		OpenButton.BackgroundTransparency = 1.000
		OpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OpenButton.BorderSizePixel = 0
		OpenButton.Position = UDim2.new(0, 31, 0.5, 0)
		OpenButton.Size = UDim2.new(1, -31, 1, 0)
		OpenButton.ZIndex = 10
		OpenButton.FontFace = WinWare.MontserratMedium
		OpenButton.Text = ""
		OpenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		OpenButton.TextSize = 14.000

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = OpenButton

		ConfigLib.SetRender(false);
		ConfigSignal:Connect(ConfigLib.SetRender);
		ConfigLib.UnsafeThread = nil;
		ConfigLib.SelectedConfig = "Default";

		local UpdateSize = LPH_NO_VIRTUALIZE(function()
			local size = TextService:GetTextSize(ConfigName.Text , ConfigName.TextSize,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge));

			WinWare.PlayAnimate(ConfigFrame,SlowyTween , {
				Size = UDim2.fromOffset(size.X + 75, 30)
			});
		end);

		UpdateSize();

		function ConfigLib:GetData(performance)
			local ikc = {};
			
			local cd = 0;
			for Flag,v in next , WinWare.Flags do
				if v and v.GetValue then
					local data = v:GetValue();

					if typeof(data) == 'Color3' then
						table.insert(ikc,{
							Idx = Flag,
							Value = data:ToHex(),
						});
					else
						table.insert(ikc,{
							Idx = Flag,
							Value = data
						});
					end;
				end;
				
				if performance then
					if cd % 35 == 1 then
						task.wait()
					end
				end;
				
				cd += 1;
			end;

			return WinWare.Base64Encode(Encryption.new(HttpService:JSONEncode(ikc)));
		end;

		function ConfigLib:LoadData(data)
			local coded = HttpService:JSONDecode(Encryption.reverse(WinWare.Base64Decode(data)));

			for i,v in next , coded do
				if v.Idx then
					if WinWare.Flags[v.Idx] then
						task.spawn(function()
							WinWare.Flags[v.Idx]:SetValue(v.Value)
						end)
					end;
				end;
			end;
		end;

		function ConfigLib:RefreshConfig()
			if not isfolder(Window.ConfigFolder) then
				makefolder(Window.ConfigFolder);
			end;
			
			if not isfile(Window.ConfigFolder..'/Default') then
				writefile(Window.ConfigFolder..'/Default',ConfigLib:GetData());
			end;
			
			for i,v in next,ConfigMenu:GetChildren() do
				if v:GetAttribute('ConfigItem') then
					v:Destroy();
				end;
			end;

			for i,v in next , ConfigLib.Signals do
				v:Disconnect();
			end

			table.clear(ConfigLib.Signals);

			local ConfigList = {};
			for i,v in next , listfiles(Window.ConfigFolder) do

				local name = string.sub(v , #Window.ConfigFolder + 2);

				table.insert(ConfigList , name)
			end;

			for i,ConfigNameStr in next , ConfigList do
				local ConfigItemFrame = Instance.new("Frame")
				local BasedHandler = Instance.new("Frame")
				local UIListLayout = Instance.new("UIListLayout")
				local DeleteConfig = Instance.new("Frame")
				local Icon = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")
				local LoadConfig = Instance.new("Frame")
				local Icon_2 = Instance.new("TextLabel")
				local UICorner_2 = Instance.new("UICorner")
				local UICorner_3 = Instance.new("UICorner")
				local BasedLabel = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")

				ConfigItemFrame.Name = WinWare.RandomString();
				ConfigItemFrame.Parent = ConfigMenu
				ConfigItemFrame.BackgroundColor3 = WinWare.PopupSurfaceTopColor
				ConfigItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ConfigItemFrame.BorderSizePixel = 0
				ConfigItemFrame.Size = UDim2.new(1, -10, 0, 30)
				ConfigItemFrame.ZIndex = 153
				ConfigItemFrame:SetAttribute('ConfigItem',true);

				BasedHandler.Name = WinWare.RandomString();
				BasedHandler.Parent = ConfigItemFrame
				BasedHandler.AnchorPoint = Vector2.new(1, 0)
				BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BasedHandler.BackgroundTransparency = 1.000
				BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
				BasedHandler.BorderSizePixel = 0
				BasedHandler.Position = UDim2.new(1, -11, 0, 2)
				BasedHandler.Size = UDim2.new(1, -20, 0, 25)
				BasedHandler.ZIndex = 153

				UIListLayout.Parent = BasedHandler
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				UIListLayout.Padding = UDim.new(0, 5)

				DeleteConfig.Name = WinWare.RandomString();
				DeleteConfig.Parent = BasedHandler
				DeleteConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				DeleteConfig.BackgroundTransparency = 1.000
				DeleteConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DeleteConfig.BorderSizePixel = 0
				DeleteConfig.ClipsDescendants = true
				DeleteConfig.Size = UDim2.new(0, 20, 0, 18)
				DeleteConfig.ZIndex = 153

				Icon.Name = WinWare.RandomString();
				Icon.Parent = DeleteConfig
				Icon.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon.BackgroundTransparency = 1.000
				Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon.BorderSizePixel = 0
				Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon.Size = UDim2.new(1, 0, 1, 0)
				Icon.ZIndex = 153
				Icon.FontFace = WinWare.BuiltInBold
				Icon.Text = "trash-can"
				Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
				Icon.TextSize = 16.000
				Icon.TextTransparency = 0.400
				Icon.TextWrapped = true

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = DeleteConfig

				LoadConfig.Name = WinWare.RandomString();
				LoadConfig.Parent = BasedHandler
				LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				LoadConfig.BackgroundTransparency = 1.000
				LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				LoadConfig.BorderSizePixel = 0
				LoadConfig.ClipsDescendants = true
				LoadConfig.Size = UDim2.new(0, 20, 0, 18)
				LoadConfig.ZIndex = 153

				Icon_2.Name = WinWare.RandomString();
				Icon_2.Parent = LoadConfig
				Icon_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon_2.BackgroundTransparency = 1.000
				Icon_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon_2.BorderSizePixel = 0
				Icon_2.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon_2.Size = UDim2.new(1, 0, 1, 0)
				Icon_2.ZIndex = 153
				Icon_2.FontFace = WinWare.BuiltInBold
				Icon_2.Text = "arrow-right-from-portrait-rectangle"
				Icon_2.TextColor3 = Color3.fromRGB(223, 223, 223)
				Icon_2.TextSize = 16.000
				Icon_2.TextTransparency = 0.400
				Icon_2.TextWrapped = true

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = LoadConfig

				UICorner_3.CornerRadius = UDim.new(0, 5)
				UICorner_3.Parent = ConfigItemFrame

				BasedLabel.Name = WinWare.RandomString();
				BasedLabel.Parent = ConfigItemFrame
				BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BasedLabel.BackgroundTransparency = 1.000
				BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				BasedLabel.BorderSizePixel = 0
				BasedLabel.Position = UDim2.new(0, 11, 0, 7)
				BasedLabel.Size = UDim2.new(0, 1, 0, 15)
				BasedLabel.ZIndex = 153
				BasedLabel.FontFace = WinWare.MontserratMedium
				BasedLabel.Text = ConfigNameStr
				BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				BasedLabel.TextSize = 14.000
				BasedLabel.TextTransparency = 0.200
				BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

				UIStroke.Transparency = WinWare.PopupStrokeTransparency
				UIStroke.Color = WinWare.PopupStrokeColor
				UIStroke.Parent = ConfigItemFrame

				local Render = LPH_NO_VIRTUALIZE(function(rst)
					if rst then
						WinWare.PlayAnimate(ConfigItemFrame,SlowyTween,{
							BackgroundTransparency = 0
						})

						WinWare.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 0.400
						})

						WinWare.PlayAnimate(Icon_2,SlowyTween,{
							TextTransparency = 0.400
						})

						WinWare.PlayAnimate(BasedLabel,SlowyTween,{
							TextTransparency = 0.200
						})

						WinWare.PlayAnimate(UIStroke,SlowyTween,{
							Transparency = 0.500
						})
					else
						WinWare.PlayAnimate(ConfigItemFrame,SlowyTween,{
							BackgroundTransparency = 1
						})

						WinWare.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 1
						})

						WinWare.PlayAnimate(Icon_2,SlowyTween,{
							TextTransparency = 1
						})

						WinWare.PlayAnimate(BasedLabel,SlowyTween,{
							TextTransparency = 1
						})

						WinWare.PlayAnimate(UIStroke,SlowyTween,{
							Transparency = 1
						})
					end;
				end)

				Render(ConfigSignal:GetValue());
				table.insert(ConfigLib.Signals , ConfigSignal:Connect(Render));

				table.insert(ConfigLib.Signals , ConfigItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					WinWare.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.25
					})
				end)));

				table.insert(ConfigLib.Signals , ConfigItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					WinWare.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.500
					})
				end)));

				local deleter,signal = WinWare:CreateInput(DeleteConfig,function()
					if ConfigNameStr == "Default" then
						Logging.new("trash-can","You can't delete default config!",3.5)
						return;
					end;
					
					delfile(Window.ConfigFolder..'/'..ConfigNameStr);

					UpdateSize();

					ConfigLib:RefreshConfig();

					Logging.new("trash-can",'Deleted '..tostring(ConfigNameStr),3.5)
				end);


				local _,load_signal = WinWare:CreateInput(LoadConfig,function()
					local path = Window.ConfigFolder..'/'..ConfigNameStr;

					if isfile(path) then
						local data = readfile(path);

						ConfigLib:LoadData(data);

						ConfigLib.SelectedConfig = ConfigNameStr;
						ConfigName.Text = ConfigNameStr;

						UpdateSize();

						ConfigLib:RefreshConfig();

						Logging.new("folder",'Loaded '..tostring(ConfigNameStr),3.5)
					end
				end);

				table.insert(ConfigLib.Signals , signal);
				table.insert(ConfigLib.Signals , load_signal);

				table.insert(ConfigLib.Signals , deleter.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					WinWare.PlayAnimate(Icon,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = Color3.fromRGB(223, 125, 125)
					})
				end)))

				table.insert(ConfigLib.Signals , deleter.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					WinWare.PlayAnimate(Icon,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))

				table.insert(ConfigLib.Signals , LoadConfig.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					WinWare.PlayAnimate(Icon_2,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = WinWare.AccentColor
					})
				end)))

				table.insert(ConfigLib.Signals , LoadConfig.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					WinWare.PlayAnimate(Icon_2,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))
			end;

			table.clear(ConfigList);
		end;
		
		task.delay(1,function()
			if ConfigLib.SelectedConfig == "Default" then
				local path = Window.ConfigFolder..'/Default';
				local ConfigNameStr = "Default";
				
				if isfile(path) then
					local data = readfile(path);

					ConfigLib:LoadData(data);

					ConfigLib.SelectedConfig = ConfigNameStr;
					ConfigName.Text = ConfigNameStr;

					UpdateSize();

					ConfigLib:RefreshConfig();

					Logging.new("folder","Loaded Default Config",3.5);
					
					task.spawn(function()
						while true do task.wait(5.75);
							if isfile(path) and ConfigLib.SelectedConfig == "Default" then
								writefile(Window.ConfigFolder..'/Default',ConfigLib:GetData(true));
							end;
						end;
					end);
				end;
			end;
		end);

		local hover_write = WinWare:CreateInput(ConfigIcon,function()
			local path = Window.ConfigFolder..'/'..(ConfigLib.SelectedConfig or "Default");

			if isfile(path) then
				writefile(Window.ConfigFolder..'/'..(ConfigLib.SelectedConfig or "Default"),ConfigLib:GetData());

				Logging.new("folder",'Saved '..tostring(ConfigLib.SelectedConfig),3.5)
			end;
		end);

		WinWare:AddSignal(hover_write.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(ConfigIcon,SlowyTween,{
				TextTransparency = 0.1
			})
		end)));

		WinWare:AddSignal(hover_write.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(ConfigIcon,SlowyTween,{
				TextTransparency = 0.25
			})
		end)));


		local mv = WinWare:CreateInput(LoadConfig , function()
			local cfg_name = TextBox.Text;

			if cfg_name and cfg_name:byte() and not cfg_name:find('/',1,true) and not cfg_name:find('\\',1,true) then
				cfg_name = string.sub(cfg_name , 1 , 24);

				writefile(Window.ConfigFolder..'/'..cfg_name,ConfigLib:GetData());
				ConfigLib.SelectedConfig = cfg_name;
				ConfigName.Text = cfg_name;

				Logging.new("folder",'Created '..tostring(cfg_name),3.5)

				TextBox.Text = "";

				UpdateSize();

				ConfigLib:RefreshConfig();
			end;
		end);

		WinWare:AddSignal(mv.MouseEnter:Connect(function()
			WinWare.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.1
			})
		end))

		WinWare:AddSignal(mv.MouseLeave:Connect(function()
			WinWare.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.35
			})
		end))

		ConfigLib:RefreshConfig();

		OpenButton.MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
			if ConfigLib.UnsafeThread then
				ConfigLib.UnsafeThread:Disconnect();
				ConfigLib.UnsafeThread = nil;
			end;

			ConfigSignal:SetValue(true);

			ConfigLib.UnsafeThread = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not WinWare:IsMouseOverFrame(ConfigMenu) then
						if ConfigLib.UnsafeThread then
							ConfigLib.UnsafeThread:Disconnect();
							ConfigLib.UnsafeThread = nil;
						end;

						ConfigSignal:SetValue(false);
					end;
				end;
			end)
		end));

		return ConfigLib;
	end;

	Window.Config = Window:_InitConfig();

	local UserSettings = WinWare:CreateOptionWindow(BottomFrame , BottomFrame.ZIndex + 13);
	local reciveSignal;
	WinWare:CreateInput(BottomFrame , LPH_NO_VIRTUALIZE(function()
		if reciveSignal then
			reciveSignal:Disconnect();
			reciveSignal = nil;	
		end;

		UserSettings.Signal:SetValue(true);

		reciveSignal = UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not WinWare:IsMouseOverFrame(UserSettings.Root) and not WinWare:IsMouseOverFrame(BottomFrame) and not WinWare.IsMosueOverOtherFrame then
					if reciveSignal then
						reciveSignal:Disconnect();
						reciveSignal = nil;	
					end;

					UserSettings.Signal:SetValue(false);
				end
			end
		end);
	end))

	Window.UserSettings = UserSettings;

	function Window:SetAccount(Config)
		Config = WinWare:ProcessParams(Config , {
			Profile = WinWare.UserProfile,
			Username = WinWare.UserName or LocalPlayer.Name,
			Expires = "Never",
			Lifetime = false,
		});

		local Expiration = Config.Lifetime and "Lifetime" or Config.Expires;
		if Expiration == true then
			Expiration = "Lifetime";
		elseif Expiration == nil or tostring(Expiration) == "" then
			Expiration = "Never";
		else
			local NormalizedExpiration = string.lower(tostring(Expiration));
			Expiration = (NormalizedExpiration == "lifetime" or NormalizedExpiration == "forever")
				and "Lifetime"
				or tostring(Expiration);
		end;

		AccountName.Text = Config.Username or WinWare.UserName or LocalPlayer.Name;
		AccountProfile.Image = Config.Profile or WinWare.UserProfile;
		ExpireLabel.Text = Expiration;

		Window.Username = Config.Username or WinWare.UserName or Window.Username;
		Window.Profile = Config.Profile or WinWare.UserProfile or Window.Profile;
		Window.Expires = Expiration;

		if Window.UserSettings.UserFrame then
			Window.UserSettings.UserFrame:SetUsername(Window.Username);
			Window.UserSettings.UserFrame:SetProfile(Window.Profile);
			Window.UserSettings.UserFrame:SetExpires(Window.Expires);
		else
			Window.UserSettings.UserFrame = UserSettings:AddUserFrame(Window.Username , Window.Profile , Window.Expires);
		end;
	end;

	function Window:AddLibrarySettings(Config)
		Config = Config or {};

		local Flag = Config.Flag or "WinWare";
		local LabelText = Config.Label;
		local WithConfigs = Config.Config ~= false;
		local BlurDefault = Config.Blur ~= false;
		local WatermarkDefault = Config.Watermark == true;
		local OpacityDefault = Config.Opacity or 96;
		local ScaleDefault = Config.Scale or "Default";
		local Tab = Config.Tab;
		local Settings = {};

		if LabelText == nil then
			LabelText = "SETTINGS";
		end;

		if not Tab then
			if LabelText then
				Window:AddTabLabel(LabelText);
			end;

			Tab = Window:AddTab({
				Name = Config.Name or "Settings",
				Icon = Config.Icon or "gear"
			});
		end;

		local Interface = Tab:AddSection({
			Name = "INTERFACE",
			Position = "left"
		});

		local Appearance = Tab:AddSection({
			Name = "APPEARANCE",
			Position = "right"
		});

		Settings.Tab = Tab;
		Settings.Interface = Interface;
		Settings.Appearance = Appearance;

		Settings.MenuKey = Interface:AddLabel("Menu Key"):AddKeybind({
			Flag = Flag .. ".MenuKey",
			Default = Window.Keybind,
			Callback = LPH_NO_VIRTUALIZE(function(Key)
				Window.Keybind = Key;
			end)
		});

		Settings.Scale = Interface:AddLabel("Menu Scale"):AddDropdown({
			Flag = Flag .. ".MenuScale",
			Default = ScaleDefault,
			Values = { "Small" , "Mobile" , "Default" , "Large" },
			Size = 110,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				local Scale = WinWare.Scales[Value];

				if Scale then
					Window:SetSize(Scale);
				end;
			end)
		});

		Settings.Opacity = Interface:AddLabel("Menu Opacity"):AddSlider({
			Flag = Flag .. ".MenuOpacity",
			Default = OpacityDefault,
			Min = 40,
			Max = 100,
			Type = "%",
			Size = 233,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				WindowFrame.BackgroundTransparency = 1 - (math.clamp(Value , 40 , 100) / 100);
			end)
		});

		Settings.Blur = Interface:AddLabel("Menu Blur"):AddToggle({
			Flag = Flag .. ".MenuBlur",
			Default = BlurDefault,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				WinWare.EnabledBlur = Value;

				if Value then
					if not WinWare.__BlurDisconnect then
						WinWare:CreateBlurModule(WindowFrame , Window.Signal);
					end;
				elseif WinWare.__BlurDisconnect then
					WinWare.__BlurDisconnect();

					WinWare.__BlurDisconnect = nil;
				end;
			end)
		});

		Settings.Watermark = Interface:AddLabel("Watermark"):AddToggle({
			Flag = Flag .. ".Watermark",
			Default = WatermarkDefault,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				Window:Watermark():SetRender(Value);
			end)
		});

		Settings.Accent = Appearance:AddLabel("Accent Color"):AddColorPicker({
			Flag = Flag .. ".AccentColor",
			Default = WinWare.AccentColor,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				WinWare:SetAccentColor(Value);
			end)
		});

		if Window.Enable3DRenderer then
			Settings.Render3D = Appearance:AddLabel("3D Render"):AddToggle({
				Flag = Flag .. ".Render3D",
				Default = false,
				Callback = LPH_NO_VIRTUALIZE(function(Value)
					Window:Set3DRender(Value);
				end)
			});
		end;

		Appearance:AddButton({
			Name = "Reset Position",
			Icon = "arrow-spin-clockwise",
			Callback = LPH_NO_VIRTUALIZE(function()
				WinWare.PlayAnimate(WindowFrame , VSlowTween , {
					Position = UDim2.fromScale(0.5 , 0.5)
				})
			end)
		});

		if Window.Website then
			Appearance:AddButton({
				Name = "Copy Website",
				Icon = "page",
				Callback = LPH_NO_VIRTUALIZE(function()
					setclipboard(Window.Website);

					Logging.new("page" , "Website copied" , 3.5);
				end)
			});
		end;

		if WithConfigs then
			local Configs = Tab:AddSection({
				Name = "CONFIGS",
				Position = "right"
			});

			local ConfigName = "Default";

			local GetPath = LPH_NO_VIRTUALIZE(function()
				return Window.ConfigFolder .. "/" .. ConfigName;
			end);

			Settings.Configs = Configs;

			Settings.ConfigName = Configs:AddLabel("Config Name"):AddTextInput({
				Flag = Flag .. ".ConfigName",
				Default = "Default",
				Placeholder = "Default",
				Size = 120,
				Callback = LPH_NO_VIRTUALIZE(function(Value)
					ConfigName = (Value ~= "" and Value) or "Default";
				end)
			});

			Configs:AddButton({
				Name = "Save Config",
				Icon = "check",
				Callback = LPH_NO_VIRTUALIZE(function()
					if not Window.Config then
						return;
					end;

					writefile(GetPath() , Window.Config:GetData());

					Window.Config.SelectedConfig = ConfigName;
					Window.Config:RefreshConfig();

					Logging.new("folder" , "Saved " .. ConfigName , 3.5);
				end)
			});

			Configs:AddButton({
				Name = "Load Config",
				Icon = "folder",
				Callback = LPH_NO_VIRTUALIZE(function()
					if not Window.Config or not isfile(GetPath()) then
						return;
					end;

					Window.Config:LoadData(readfile(GetPath()));

					Window.Config.SelectedConfig = ConfigName;

					Logging.new("folder" , "Loaded " .. ConfigName , 3.5);
				end)
			});

			Configs:AddButton({
				Name = "Delete Config",
				Icon = "x",
				Callback = LPH_NO_VIRTUALIZE(function()
					if not Window.Config or not isfile(GetPath()) then
						return;
					end;

					delfile(GetPath());

					Window.Config.SelectedConfig = "Default";
					Window.Config:RefreshConfig();

					Logging.new("folder" , "Deleted " .. ConfigName , 3.5);
				end)
			});
		end;

		Settings.AddSection = LPH_NO_VIRTUALIZE(function(self , SectionConfig)
			return Tab:AddSection(SectionConfig);
		end);

		Window.Settings = Settings;

		return Settings;
	end;

	function Window:SetSize(newsize)
		Window.Size = newsize;

		if Window.Signal:GetValue() then
			WinWare.PlayAnimate(WindowFrame , VSlowTween , {
				Size = Window.Size
			})
		end
	end;

	Window:SetAccount();

	WinWare:AddSignal(UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(value,ISTYPING)
		if value.KeyCode == Window.Keybind or value.KeyCode.Name == Window.Keybind then
			if not ISTYPING then
				Window:ToggleInterface()
			end
		end;
	end)));

	function Window:ToggleInterface()
		Window.Signal:SetValue(not Window.Signal:GetValue());

		if Window.__3DRender then
			Window.Load3DBlock();
		end;
	end;

	function Window:Watermark()
		if WinWare.__WatermarkCache then
			return WinWare.__WatermarkCache;
		end;

		local Watermark_lb = {};
		local Watermark = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local Shadow = WinWare:CreateShadow(Watermark);

		Watermark.Name = WinWare.RandomString();
		Watermark.Parent = WinWare.ScreenGui
		Watermark.AnchorPoint = Vector2.new(1, 0)
		Watermark.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
		Watermark.BackgroundTransparency = 0.200
		Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Watermark.BorderSizePixel = 0
		Watermark.ClipsDescendants = true
		Watermark.Position = UDim2.new(1, -10, 0, 10)
		Watermark.Size = UDim2.new(0, 120, 0, 30)
		Watermark.ZIndex = 16

		WinWare.ApplyPopupSurface(Watermark , 0.040);

		UICorner.CornerRadius = UDim.new(0, 25)
		UICorner.Parent = Watermark

		UIListLayout.Parent = Watermark
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

		local empty_space = Instance.new('Frame');

		empty_space.Size = UDim2.fromOffset(15,0);
		empty_space.BackgroundTransparency = 1;
		empty_space.Parent = Watermark;
		empty_space.LayoutOrder = 5;

		Watermark:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if Watermark.BackgroundTransparency > 0.9 then
				Watermark.Visible = false;
				Watermark.Parent = nil;
			else
				Watermark.Parent = WinWare.ScreenGui
				Watermark.Visible = true;
			end;
		end));

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			WinWare.PlayAnimate(Watermark , SlowyTween , {
				Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 5, 0, 30)
			})
		end));

		WinWare.__WatermarkCache = Watermark_lb;

		Shadow:Render(true);

		Watermark_lb.Renders = {};
		Watermark_lb.Status = true;

		function Watermark_lb:SetRender(value)
			Watermark_lb.Status = value;

			if value then
				WinWare.PlayAnimate(Watermark,SlowyTween , {
					BackgroundTransparency = 0.100
				})

				Shadow:Render(true);

				for i,v in next , Watermark_lb.Renders do
					pcall(v,true);
				end;
			else
				WinWare.PlayAnimate(Watermark,SlowyTween , {
					BackgroundTransparency = 1
				})

				Shadow:Render(false);

				for i,v in next , Watermark_lb.Renders do
					pcall(v,false);
				end;
			end
		end;

		function Watermark_lb:AddBlock(IconStr , Name)
			local InnerBlock = {};

			local Frame = Instance.new("Frame")
			local Content = Instance.new("TextLabel")
			local Icon = Instance.new("TextLabel")

			Frame.Parent = Watermark
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Size = UDim2.new(0, 50, 0, 30)

			Content.Name = WinWare.RandomString();
			Content.Parent = Frame
			Content.AnchorPoint = Vector2.new(0, 0.5)
			Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
			Content.BackgroundTransparency = 1.000
			Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Content.BorderSizePixel = 0
			Content.Position = UDim2.new(0, 35, 0.5, 0)
			Content.Size = UDim2.new(0, 1, 0, 25)
			Content.ZIndex = 17
			Content.FontFace = WinWare.MontserratBold
			Content.Text = Name
			Content.TextColor3 = Color3.fromRGB(186, 186, 186)
			Content.TextSize = 15.000
			Content.TextTransparency = 0.200
			Content.TextXAlignment = Enum.TextXAlignment.Left

			Icon.Name = WinWare.RandomString();
			Icon.Parent = Frame
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 10, 0.5, 0)
			Icon.Size = UDim2.new(0, 20, 0, 20)
			Icon.ZIndex = 17
			Icon.FontFace = WinWare.BuiltInBold;
			Icon.Text = IconStr
			Icon.TextColor3 = WinWare.AccentColor
			Icon.TextSize = 18.000
			Icon.TextTransparency = 0.250
			Icon.TextWrapped = true

			InnerBlock.Update = LPH_NO_VIRTUALIZE(function(value)
				local size = TextService:GetTextSize(Content.Text , Content.TextSize,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge))

				if InnerBlock.Visible then
					WinWare.PlayAnimate(Frame,VSlowTween,{
						Size = UDim2.new(0, size.X + 35, 0, 30)
					})
				else
					WinWare.PlayAnimate(Frame,VSlowTween,{
						Size = UDim2.new(0, 0, 0, 30)
					})
				end;
			end);

			InnerBlock.Visible = true;

			InnerBlock.Update();

			function InnerBlock:SetVisible(v)
				InnerBlock.Visible = v;

				if Watermark_lb.Status then
					InnerBlock.SetRender(v);
				end;

				InnerBlock.Update();
			end;

			InnerBlock.SetRender = LPH_NO_VIRTUALIZE(function(value)
				if value and InnerBlock.Visible then
					WinWare.PlayAnimate(Content,SlowyTween , {
						TextTransparency = 0.200
					})

					WinWare.PlayAnimate(Icon,SlowyTween , {
						TextTransparency = 0.250
					})
				else

					WinWare.PlayAnimate(Content,SlowyTween , {
						TextTransparency = 1
					})

					WinWare.PlayAnimate(Icon,SlowyTween , {
						TextTransparency = 1
					})
				end;
			end);

			table.insert(Watermark_lb.Renders,InnerBlock.SetRender);

			function InnerBlock:SetText(t)
				Content.Text = t;

				InnerBlock.Update();
			end;

			function InnerBlock:Input(func)
				local c,s = WinWare:CreateInput(Frame,func);

				return s;
			end;

			return InnerBlock;
		end;

		return Watermark_lb;
	end;

	Window:SetRender(false);

	return Window;
end;

function WinWare:CreateNotification()
	if WinWare.__Notification_Cache then
		return WinWare.__Notification_Cache;
	end;

	local Notifier = {};
	local Notification = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notification.Name = WinWare.RandomString();
	Notification.Parent = WinWare.ScreenGui;
	Notification.AnchorPoint = Vector2.new(1, 0)
	Notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Notification.BackgroundTransparency = 1.000
	Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(1, -25, 0, 25)
	Notification.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Notification
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 0)

	WinWare.__Notification_Cache = Notifier;
	Notifier.ActiveKeys = {};

	function Notifier.new(Config)
		Config = WinWare:ProcessParams(Config , {
			Title = "Notification",
			Content = "Hello World!",
			Logo = WinWare.GlobalLogo or "rbxasset://textures/ui/VerifiedBadgeNameIcon.png",
			Duration = 5,
		});

		local NotificationKey = tostring(Config.Title).."\0"..tostring(Config.Content);
		local ExistingNotification = Notifier.ActiveKeys[NotificationKey];
		if ExistingNotification then
			return ExistingNotification.Frame;
		end;

		local NotificationToken = {};
		Notifier.ActiveKeys[NotificationKey] = NotificationToken;

		if WinWare.__WatermarkCache then
			WinWare.PlayAnimate(Notification,SlowyTween , {
				Position = UDim2.new(1, -25, 0, 55)
			});
		end;

		local ContainerFrame = Instance.new("Frame")
		local NotifyFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogoImage = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local NotifyName = Instance.new("TextLabel")
		local NotifyContent = Instance.new("TextLabel");
		local shadow = WinWare:CreateShadow(NotifyFrame , true);

		ContainerFrame.Name = WinWare.RandomString();
		ContainerFrame.Parent = Notification
		ContainerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ContainerFrame.BackgroundTransparency = 1.000
		ContainerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ContainerFrame.BorderSizePixel = 0
		ContainerFrame.Size = UDim2.new(0, 0, 0, 100)
		NotificationToken.Frame = ContainerFrame;

		NotifyFrame.Name = WinWare.RandomString();
		NotifyFrame.Parent = ContainerFrame
		NotifyFrame.AnchorPoint = Vector2.new(1, 0)
		NotifyFrame.BackgroundColor3 = WinWare.PopupSurfaceColor
		NotifyFrame.BackgroundTransparency = 0.100
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.ClipsDescendants = true
		NotifyFrame.Position = UDim2.new(0, 750, 0, 0)
		NotifyFrame.Size = UDim2.new(0, 220, 0, 55)
		NotifyFrame.ZIndex = 130

		WinWare.ApplyPopupSurface(NotifyFrame , 0.040);

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = NotifyFrame

		UIStroke.Transparency = WinWare.PopupStrokeTransparency
		UIStroke.Color = WinWare.PopupStrokeColor
		UIStroke.Parent = NotifyFrame
		ApplyPopupGradient(NotifyFrame)

		LogoImage.Name = WinWare.RandomString();
		LogoImage.Parent = NotifyFrame
		LogoImage.AnchorPoint = Vector2.new(0, 0.5)
		LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoImage.BackgroundTransparency = 1.000
		LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoImage.BorderSizePixel = 0
		LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
		LogoImage.Size = UDim2.new(0, 35, 0, 35)
		LogoImage.ZIndex = 131
		LogoImage.Image = Config.Logo
		LogoImage.ImageColor3 = WinWare.IconColor;

		UICorner_2.CornerRadius = UDim.new(0, 7)
		UICorner_2.Parent = LogoImage

		NotifyName.Name = WinWare.RandomString();
		NotifyName.Parent = NotifyFrame
		NotifyName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.BackgroundTransparency = 1.000
		NotifyName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyName.BorderSizePixel = 0
		NotifyName.Position = UDim2.new(0, 50, 0, 7)
		NotifyName.Size = UDim2.new(1, -60, 0, 20)
		NotifyName.ZIndex = 132
		NotifyName.FontFace = WinWare.MontserratBold
		NotifyName.Text = Config.Title
		NotifyName.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.TextSize = 17.000
		NotifyName.TextXAlignment = Enum.TextXAlignment.Left

		NotifyContent.Name = WinWare.RandomString();
		NotifyContent.Parent = NotifyFrame
		NotifyContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.BackgroundTransparency = 1.000
		NotifyContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyContent.BorderSizePixel = 0
		NotifyContent.Position = UDim2.new(0, 50, 0, 28)
		NotifyContent.Size = UDim2.new(1, -60, 0, 15)
		NotifyContent.ZIndex = 132
		NotifyContent.FontFace = WinWare.MontserratBold
		NotifyContent.Text = Config.Content
		NotifyContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.TextSize = 12.000
		NotifyContent.TextTransparency = 0.650
		NotifyContent.TextXAlignment = Enum.TextXAlignment.Left

		local Size1 = TextService:GetTextSize(NotifyName.Text,NotifyName.TextSize,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge));
		local Size2 = TextService:GetTextSize(NotifyContent.Text,NotifyContent.TextSize,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge));

		local MainSize = math.max(Size1.X , Size2.X);

		NotifyFrame.Size = UDim2.new(0, math.clamp(MainSize + 65, 180, 280), 0, 55);

		shadow:Render(true)
		WinWare.PlayAnimate(NotifyFrame , VSlowTween , {
			Position = UDim2.new(1, 0, 0, 0)
		})

		ContainerFrame.Size = UDim2.new(0, 0, 0, 65)

		task.delay(Config.Duration or 5 , LPH_NO_VIRTUALIZE(function()

			if WinWare.__WatermarkCache then
				WinWare.PlayAnimate(Notification,SlowyTween , {
					Position = UDim2.new(1, -25, 0, 55)
				});
			end;

			shadow:Render(false)

			WinWare.PlayAnimate(NotifyFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			WinWare.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			WinWare.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 1
			})

			WinWare.PlayAnimate(NotifyName , SlowyTween , {
				TextTransparency = 1
			})

			WinWare.PlayAnimate(NotifyContent , SlowyTween , {
				TextTransparency = 1
			})

			task.wait(0.125);

			WinWare.PlayAnimate(ContainerFrame , SlowyTween , {
				Size = UDim2.new(0, 0, 0, 0)
			})

			task.wait(0.125);

			ContainerFrame:Destroy();
			if Notifier.ActiveKeys[NotificationKey] == NotificationToken then
				Notifier.ActiveKeys[NotificationKey] = nil;
			end;
		end))

		return ContainerFrame;
	end;

	return Notifier;
end;

function WinWare:CreateLogger()
	if WinWare.__LogSystem then
		return 	WinWare.__LogSystem;
	end;

	local Logging = {};
	local Log = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Log.Name = WinWare.RandomString();
	Log.Parent = WinWare.ScreenGui
	Log.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Log.BackgroundTransparency = 1.000
	Log.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Log.BorderSizePixel = 0
	Log.Position = UDim2.new(0, 25, 0, 5 + math.abs(WinWare.ScreenGui.AbsolutePosition.Y))
	Log.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Log
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 12)

	WinWare.__LogSystem = Logging;

	function Logging.new(IconStr: string , Message: string , Duration: number)
		Duration = Duration or 3;
		Message = Message or "Log";
		IconStr = IconStr or "crosshairs";

		local LogFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogContent = Instance.new("TextLabel")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local Icon = Instance.new("TextLabel")
		local Shadow = WinWare:CreateShadow(LogFrame , true);

		LogFrame.Name = WinWare.RandomString();
		LogFrame.Parent = Log
		LogFrame.AnchorPoint = Vector2.new(0.5, 0)
		LogFrame.BackgroundColor3 = WinWare.PopupSurfaceColor
		LogFrame.BackgroundTransparency =  1--0.075
		LogFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogFrame.BorderSizePixel = 0
		LogFrame.ClipsDescendants = true
		LogFrame.Position = UDim2.new(0,0,0,0)
		LogFrame.Size = UDim2.new(0, 0, 0, 20)
		LogFrame.ZIndex = 130

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = LogFrame

		UIStroke.Transparency = 1
		UIStroke.Color = WinWare.PopupStrokeColor
		UIStroke.Parent = LogFrame
		ApplyPopupGradient(LogFrame)

		LogContent.Name = WinWare.RandomString();
		LogContent.Parent = LogFrame
		LogContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.BackgroundTransparency = 1.000
		LogContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogContent.BorderSizePixel = 0
		LogContent.Position = UDim2.new(0, 25, 0, 2)
		LogContent.Size = UDim2.new(0, 200, 0, 15)
		LogContent.ZIndex = 132
		LogContent.FontFace = WinWare.MontserratBold
		LogContent.Text = Message
		LogContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.TextSize = 12.000
		LogContent.TextTransparency = 1--0.250
		LogContent.TextXAlignment = Enum.TextXAlignment.Left

		Line.Name = WinWare.RandomString();
		Line.Parent = LogFrame
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = WinWare.AccentColor
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BackgroundTransparency = 1 --0
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, -2, 0.5, 0)
		Line.Size = UDim2.new(0, 5, 1, 0)
		Line.ZIndex = 131

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = Line

		Icon.Name = WinWare.RandomString();
		Icon.Parent = LogFrame
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 7, 0, 3)
		Icon.Size = UDim2.new(0, 15, 0, 15)
		Icon.ZIndex = 133
		Icon.FontFace = WinWare.BuiltInBold
		Icon.Text = IconStr
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 13.000
		Icon.TextTransparency = 1--0.250
		Icon.TextWrapped = true

		local size = TextService:GetTextSize(LogContent.Text,LogContent.TextSize,WinWare.TextMetricFont,Vector2.new(math.huge,math.huge));

		WinWare.PlayAnimate(LogFrame , SlowyTween , {
			Size = UDim2.new(0, size.X + 35, 0, 20),
			BackgroundTransparency =  0.075
		});

		task.delay(0.15,LPH_NO_VIRTUALIZE(function()
			Shadow:Render(true);

			WinWare.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = WinWare.PopupStrokeTransparency
			});

			WinWare.PlayAnimate(LogContent , SlowyTween , {
				TextTransparency = 0.25
			});

			WinWare.PlayAnimate(Line , SlowyTween , {
				BackgroundTransparency = 0
			});

			WinWare.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.25
			});

			task.wait(Duration + 0.1);

			Shadow:Render(false);

			WinWare.PlayAnimate(LogFrame , SlowyTween , {
				BackgroundTransparency =  1
			});

			WinWare.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			});

			WinWare.PlayAnimate(LogContent , SlowyTween , {
				TextTransparency = 1
			});

			WinWare.PlayAnimate(Line , SlowyTween , {
				BackgroundTransparency = 1
			});

			WinWare.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 1
			});

			task.wait(0.25);

			LogFrame:Destroy();
		end))
	end;

	return Logging
end;

function WinWare:CreateIndicator()
	local IndicatorFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	IndicatorFrame.Name = WinWare.RandomString();
	IndicatorFrame.Parent = WinWare.ScreenGui;
	IndicatorFrame.AnchorPoint = Vector2.new(0, 0.5)
	IndicatorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	IndicatorFrame.BackgroundTransparency = 1.000
	IndicatorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	IndicatorFrame.BorderSizePixel = 0
	IndicatorFrame.Position = UDim2.new(0, 15, 0.5, 0)
	IndicatorFrame.Size = UDim2.new(0, 100, 0, 100)
	IndicatorFrame.ZIndex = 15

	UIListLayout.Parent = IndicatorFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 10)

	local Indicators = {};

	Indicators.Color = {
		Red = Color3.fromRGB(255, 102, 105),
		Green = Color3.fromRGB(135, 255, 143),
		White = Color3.fromRGB(186, 186, 186),
	};

	Indicators.Root = IndicatorFrame;

	function Indicators.new(Config)
		Config = WinWare:ProcessParams(Config , {
			Name = "Indicator",
			Icon = 'crosshairs',
			Color = 'Red',
		});

		local Indicator = {
			CurrentColor = Config.Color,	
			Visible = false,
		};

		local IndicatorItem = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIGradient = Instance.new("UIGradient")
		local Icon = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")
		local Shadow = WinWare:CreateShadow(IndicatorItem);

		IndicatorItem.Name = WinWare.RandomString();
		IndicatorItem.BackgroundColor3 = WinWare.PopupSurfaceColor
		IndicatorItem.BackgroundTransparency = 1

		WinWare.ApplyPopupSurface(IndicatorItem , 1);
		IndicatorItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
		IndicatorItem.BorderSizePixel = 0
		IndicatorItem.ClipsDescendants = true
		IndicatorItem.Size = UDim2.new(0, 85, 0, 40)
		IndicatorItem.ZIndex = 16
		IndicatorItem.Visible = false;

		IndicatorItem:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if IndicatorItem.BackgroundTransparency > 0.9 then
				IndicatorItem.Parent = nil;
				IndicatorItem.Visible = false;
			else
				IndicatorItem.Parent = IndicatorFrame;
				IndicatorItem.Visible = true;
			end;
		end))

		UICorner.CornerRadius = UDim.new(0, 25)
		UICorner.Parent = IndicatorItem

		Line.Name = WinWare.RandomString();
		Line.Parent = IndicatorItem
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 2, 0.5, 0)
		Line.BackgroundTransparency = 1;
		Line.Size = UDim2.new(0, 3, 0.649999976, 0)
		Line.ZIndex = 17

		UICorner_2.CornerRadius = UDim.new(0, 25)
		UICorner_2.Parent = Line

		UIGradient.Rotation = 90
		UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
		UIGradient.Parent = Line

		Icon.Name = WinWare.RandomString();
		Icon.Parent = IndicatorItem
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 10, 0.5, 0)
		Icon.Size = UDim2.new(0, 25, 0, 25)
		Icon.ZIndex = 17
		Icon.FontFace = WinWare.BuiltInBold;
		Icon.Text = Config.Icon
		Icon.TextColor3 = Color3.fromRGB(186, 186, 186)
		Icon.TextSize = 21.000
		Icon.TextTransparency = 1
		Icon.TextWrapped = true

		Content.Name = WinWare.RandomString();
		Content.Parent = IndicatorItem
		Content.AnchorPoint = Vector2.new(0, 0.5)
		Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Content.BackgroundTransparency = 1.000
		Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0, 40, 0.5, 0)
		Content.Size = UDim2.new(1, -40, 0, 25)
		Content.ZIndex = 17
		Content.FontFace = WinWare.MontserratBold
		Content.Text = Config.Name
		Content.TextColor3 = Color3.fromRGB(186, 186, 186)
		Content.TextSize = 20.000
		Content.TextTransparency = 1
		Content.TextXAlignment = Enum.TextXAlignment.Left

		Indicator.Update = LPH_NO_VIRTUALIZE(function()
			local text = TextService:GetTextSize(Content.Text,Content.TextSize , WinWare.TextMetricFont , Vector2.new(math.huge,math.huge));

			WinWare.PlayAnimate(IndicatorItem , SlowyTween , {
				Size = UDim2.new(0, text.X + 60, 0, 40);
			})
		end);

		Indicator.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
			Indicator.Visible = value;

			if value then
				WinWare.PlayAnimate(IndicatorItem , SlowyTween , {
					BackgroundTransparency = 0.100
				});

				WinWare.PlayAnimate(Line , SlowyTween , {
					BackgroundTransparency = 0,
					BackgroundColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				WinWare.PlayAnimate(Icon , VSlowTween , {
					TextTransparency = 0.250,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				WinWare.PlayAnimate(Content , VSlowTween , {
					TextTransparency = 0.2,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				Shadow:Render(true);
			else
				WinWare.PlayAnimate(IndicatorItem , SlowyTween , {
					BackgroundTransparency = 1
				});

				WinWare.PlayAnimate(Line , SlowyTween , {
					BackgroundTransparency = 1,
					BackgroundColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				WinWare.PlayAnimate(Icon , VSlowTween , {
					TextTransparency = 1,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				WinWare.PlayAnimate(Content , VSlowTween , {
					TextTransparency = 1,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				Shadow:Render(false);
			end;

			Indicator.Update();
		end);

		Indicator.Update();
		Indicator:SetRender(false);

		function Indicator:SetColor(new_color)
			Indicator.CurrentColor = new_color;

			if Indicator.Visible then
				Indicator:SetRender(true);
			end;
		end;

		function Indicator:SetText(name)
			Config.Name = name;

			Content.Text = Config.Name;

			Indicator.Update();
		end;

		return Indicator;
	end;

	return Indicators;
end;

function WinWare:Unload()
	if not WinWare.UnloadEnabled then
		return;	
	end;

	WinWare.ScreenGui:Destroy();

	for i,v in next , WinWare.GlobalSignals do
		pcall(v.Disconnect,v)
	end;
end;

return WinWare;