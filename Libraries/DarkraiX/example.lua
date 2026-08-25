local DarkraiX = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/DarkraiX/source.lua", true))()

local Library = DarkraiX:Window("Darkrai X","","",Enum.KeyCode.RightControl)

Tab1 = Library:Tab("Main")

Tab1:Button("Button",function()
    print("hi")
end)

Tab1:Toggle("Toggle",false,function(value)
    print(value)
end)

Tab1:Slider("Slider",1,100,25,function(value)
    print(value)
end)

Tab1:Dropdown("Dropdown",{"yo","sus","pro"},function(value)
    print(value)
end)

Tab1:Textbox("Textbox","",true,function(value)
    print(value)
end)

Tab1:Seperator("Seperator")
Tab1:Line()
