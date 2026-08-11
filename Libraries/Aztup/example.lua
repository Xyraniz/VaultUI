local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/refs/heads/main/Libraries/Aztup/source.lua"))();


local Gamer = library:CreateSection("A");
Gamer:Toggle("B");
Gamer:Box("C");
Gamer:ColorPicker("D");
Gamer:Dropdown("E", {"A", "B", "C"});
Gamer:Button("Gamer Button");

local Gamer2 = library:CreateSection("B");
Gamer2:Toggle("B");
Gamer2:Box("C");
Gamer2:ColorPicker("D");
Gamer2:Dropdown("E", {"A", "B", "C"});
Gamer2:Button("Gamer Button");

library:Ready();
