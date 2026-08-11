local NexusLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/UI-Libs/main/Librarys/NexusLib/Source.lua"))()

local Window = NexusLib:Window("Synergy Hub", "Zombie Attack", "", Enum.KeyCode.RightControl)

local Tab1 = Window:Tab("Main")

Tab1:Button("Button", function()
    print("hi")
end)

Tab1:Toggle("Toggle", false, function(value)
    print(value)
end)

Tab1:Slider("Slider", 1, 100, 25, function(value)
    print(value)
end)

Tab1:Dropdown("Dropdown", {"yo","sus","pro"}, function(value)
    print(value)
end)

Tab1:Textbox("Textbox", "", true, function(value)
    print(value)
end)

Tab1:Seperator("Seperator")
Tab1:Line() 
