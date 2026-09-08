-- Elastic / VaultUI showcase
-- Exercises the searchable window and the public component API.

local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Elastic/source.lua"
local Elastic = loadstring(game:HttpGet(SOURCE))()

assert(type(Elastic) == "table", "Elastic did not return a library table")

Elastic:SetWindowKeybind(Enum.KeyCode.RightShift)

local Window = Elastic:Window()
local Visuals = Window:Tab({
    Title = "Visuals",
    Icon = "rbxassetid://11293977875",
})

local Enabled = Visuals:Toggle({
    Title = "Enable overlay",
    Flag = "ElasticOverlay",
    Default = true,
    Callback = function(value)
        print("Overlay:", value)
    end,
})

local Intensity = Visuals:Slider({
    Title = "Intensity",
    Flag = "ElasticIntensity",
    Min = 0,
    Max = 100,
    Default = 65,
    Decimal = 0,
    Suffix = "%",
    Callback = function(value)
        print("Intensity:", value)
    end,
})

local Profile = Visuals:Dropdown({
    Title = "Profile",
    Flag = "ElasticProfile",
    Options = { "Default", "Competitive", "Minimal" },
    Default = "Default",
    Callback = function(value)
        print("Profile:", value)
    end,
})

local Message = Visuals:Textbox({
    Title = "Message",
    Flag = "ElasticMessage",
    Placeholder = "Write a message",
    Default = "Ready",
    Callback = function(value)
        print("Message:", value)
    end,
})

Visuals:Button({
    Title = "Print state",
    Action = "Inspect",
    Callback = function()
        print("Enabled:", Enabled:GetValue())
        print("Intensity:", Intensity:GetValue())
        print("Profile:", Profile:GetValue())
        print("Message:", Message:GetValue())
    end,
})

local Status = Window:Watermark("Elastic <font color='#6AA0F5'>ready</font>")
Status:SetPosition("TopLeft")

return Window
