local LIB_URL = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Wisteria/source.lua"
local Wisteria = loadstring(game:HttpGet(LIB_URL))()

local Window = Wisteria.CreateWindow("Wisteria Showcase")

local Controls = Window:Tab("Controls")
local General = Controls:Section("General")

General:Label("Wisteria UI library showcase")
General:Credit("Packaged for VaultUI")
General:Button("Run callback", function()
    print("Wisteria button callback works")
end)
General:Toggle("Enable feature", function(enabled)
    print("Feature enabled:", enabled)
end)
General:KeyBind("Toggle key", Enum.KeyCode.RightShift, function()
    print("Wisteria keybind pressed")
end)

local Inputs = Controls:Section("Inputs")
Inputs:TextBox("Profile name", "Type a profile name", function(value)
    print("Profile:", value)
end)
Inputs:Slider("Intensity", 0, 100, function(value)
    print("Intensity:", value)
end)
Inputs:DropDown("Mode", { "Balanced", "Performance", "Quality" }, function(value)
    print("Mode:", value)
end)

local About = Window:Tab("About")
local Details = About:Section("Library")
Details:Label("A compact dark interface with tabs, sections, callbacks and animated controls.")
Details:Credit("Wisteria")

return Window
