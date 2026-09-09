local LIB_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Vice/source.lua"
local Vice = loadstring(game:HttpGet(LIB_URL))()

local Main = Vice:Create(
	'<font color="rgb(107, 89, 222)">VICE HUB</font>',
	UDim2.new(0, 700, 0, 600),
	Enum.KeyCode.RightShift
)

local Legit = Main:Tab(
	"LEGITBOT",
	10063288907,
	"Legitbot Options",
	"A compact example of Vice controls."
)
local Visual = Main:Tab(
	"VISUAL",
	10191671863,
	"Visual Customization",
	"Explore toggles, dropdowns, sliders and colors."
)
local Misc = Main:Tab(
	"OTHERS",
	10063472975,
	"Other Settings",
	"General library controls."
)

local Aim = Legit:SubTab("Aimbot", 10063461239)
Aim:Label("Left", "Targeting")
Aim:Toggle("Left", "Enable Aim Assist", true, function(value) end)
Aim:Toggle("Left", "Target Players", true, function(value) end)
Aim:Dropdown("Left", "Target Bone", "Head", { "Head", "Torso", "Legs" }, function(value) end)
Aim:Slider("Left", "Field of view", 120, 10, 360, 1, function(value) end)
Aim:Colorpicker("Left", "FOV Color", Color3.fromRGB(110, 107, 255), function(color) end)
Aim:Bind("Right", "Aim Assist Key", "Hold", function(value) end)
Aim:Button("Right", "Show notification", function()
	Vice:Notify("Vice", "The notification API is working.", 3)
end)

Visual:Label("Left", "Player ESP")
Visual:Toggle("Left", "Enable ESP", false, function(value) end)
Visual:Toggle("Left", "Box ESP", false, function(value) end)
Visual:Toggle("Left", "Name ESP", false, function(value) end)
Visual:Slider("Left", "Max distance", 150, 1, 300, 1, function(value) end)
Visual:Label("Right", "Chams")
Visual:Toggle("Right", "Enable Chams", true, function(value) end)
Visual:Dropdown("Right", "Material", "Plastic", { "Plastic", "Neon", "ForceField", "Glass" }, function(value) end)
Visual:Colorpicker("Right", "Chams Color", Color3.fromRGB(107, 151, 255), function(color) end)

Misc:Label("Left", "Interface")
Misc:Toggle("Left", "Show watermark", true, function(value) end)
Misc:Button("Left", "Reset settings", function() end)
Misc:Dropdown("Right", "Theme", "Violet", { "Violet", "Midnight", "Monochrome" }, function(value) end)
Misc:Slider("Right", "Animation speed", 0.2, 0.05, 1, 0.05, function(value) end)

-- The returned tab objects also expose SubTab, Label, Toggle, Dropdown,
-- Slider, Colorpicker, Bind and Button. Vice:Notify(title, description,
-- duration) can be called from any callback.
