local Aether = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Aether/source.lua"
))()

local Window = Aether:Window({
    Name = "Aether Showcase",
    Logo = "lucide:sparkles",
})

local Combat = Window:Page({
    Name = "Combat",
    Description = "Combat controls",
    Icon = "lucide:crosshair",
    Search = false,
})

local Visuals = Window:Page({
    Name = "Visuals",
    Description = "Visual preferences",
    Icon = "lucide:eye",
    Search = false,
})

local Movement = Combat:SubPage({ Icon = "lucide:move-3d" })
local Targeting = Combat:SubPage({ Icon = "lucide:locate-fixed" })
local Appearance = Visuals:SubPage({ Icon = "lucide:palette" })

local MovementSection = Movement:Section({
    Name = "Movement",
    Side = 1,
})

MovementSection:Toggle({
    Name = "Enable movement assist",
    Flag = "MovementAssist",
    Default = false,
    Callback = function(value)
        print("Movement assist:", value)
    end,
})

MovementSection:Slider({
    Name = "Walk speed",
    Flag = "WalkSpeed",
    Default = 16,
    Min = 8,
    Max = 32,
    Decimals = 1,
    Suffix = " studs",
    Callback = function(value)
        print("Walk speed:", value)
    end,
})

MovementSection:Dropdown({
    Name = "Movement profile",
    Flag = "MovementProfile",
    Items = { "Balanced", "Fast", "Precise" },
    Default = "Balanced",
    Callback = function(value)
        print("Movement profile:", value)
    end,
})

local TargetingSection = Targeting:Section({
    Name = "Targeting",
    Side = 1,
})

TargetingSection:Button({
    Name = "Run target check",
    Callback = function()
        print("Target check complete")
    end,
})

TargetingSection:Label({ Name = "Target highlight" }):Colorpicker({
    Flag = "TargetHighlight",
    Default = Color3.fromRGB(183, 242, 255),
    Callback = function(value)
        print("Target highlight:", value)
    end,
})

TargetingSection:Label({ Name = "Target keybind" }):Keybind({
    Name = "Target keybind",
    Flag = "TargetKeybind",
    Default = Enum.KeyCode.E,
    Callback = function(value)
        print("Target keybind state:", value)
    end,
})

local VisualsSection = Appearance:Section({
    Name = "Visuals",
    Side = 1,
})

VisualsSection:Textbox({
    Name = "Overlay label",
    Flag = "OverlayLabel",
    Default = "Aether",
    Numeric = false,
    Finished = false,
    Callback = function(value)
        print("Overlay label:", value)
    end,
})

local Status = VisualsSection:Status({ Name = "Session status" })
Status:AddStatus("Aether loaded")
Status:AddStatus("Showcase ready")

return Window
