local FyyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Armenta-Lib/source.lua"))()

local Menu = FyyUI.Menu({
    Title = "Armenta Workspace",
    Theme = "Dark",
    Stats = "VaultUI",
    Support = "Controls and configuration",
    Resizable = true,
    Responsive = true,
    MinSize = Vector2.new(520, 360),
    MaxSize = Vector2.new(1080, 720),
    Scale = 1,
    ReducedMotion = false
})

local Controls = Menu:Tab({
    Text = "Controls",
    Icon = "settings",
    Tooltip = "Adjust local values"
})

local Display = Menu:Tab({
    Text = "Display",
    Icon = "palette",
    Tooltip = "Choose interface preferences"
})

Controls:BoldLabel({
    Text = "Character controls",
    Description = "Values are applied to the local character when available"
})

local player = game:GetService("Players").LocalPlayer
local walkSpeed = 16
local jumpPower = 50

Controls:Button({
    Text = "Reset movement",
    Description = "Restore the default Roblox humanoid values",
    Icon = "rotate-ccw",
    Callback = function()
        walkSpeed = 16
        jumpPower = 50
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = walkSpeed
            humanoid.JumpPower = jumpPower
        end
    end
})

Controls:Toggle({
    Text = "Apply movement values",
    Description = "Enable the selected speed and jump power",
    Flag = "ApplyMovement",
    Default = true,
    Callback = function(enabled)
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = enabled and walkSpeed or 16
            humanoid.JumpPower = enabled and jumpPower or 50
        end
    end
})

Controls:Slider({
    Text = "Walk speed",
    Description = "Movement speed applied to the humanoid",
    Flag = "WalkSpeed",
    Min = 8,
    Max = 32,
    Step = 1,
    Default = walkSpeed,
    Suffix = " studs",
    Callback = function(value)
        walkSpeed = value
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

Controls:Slider({
    Text = "Jump power",
    Description = "Vertical force applied to the humanoid",
    Flag = "JumpPower",
    Min = 30,
    Max = 100,
    Step = 1,
    Default = jumpPower,
    Suffix = " power",
    Callback = function(value)
        jumpPower = value
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
        end
    end
})

Display:BoldLabel({
    Text = "Interface preferences",
    Description = "These values demonstrate the native display factories"
})

Display:Dropdown({
    Text = "Theme",
    Description = "Choose a built-in color system",
    Options = { "Dark", "Slate", "Rose", "Amber" },
    Default = "Dark",
    Flag = "Theme",
    Callback = function(value)
        Menu:SetTheme(value)
    end
})

Display:ColorPicker({
    Text = "Accent color",
    Description = "Set the highlight used by controls",
    Default = Color3.fromRGB(122, 138, 255),
    Flag = "AccentColor",
    Callback = function(value)
        Menu:SetTheme({Accent = value})
    end
})

Display:Input({
    Text = "Status label",
    Description = "Change the text used by the status card",
    Placeholder = "Type a status",
    Default = "Ready",
    ClearTextOnFocus = false,
    Callback = function(value)
        print(value)
    end
})

Display:Checkbox({
    Text = "Compact spacing",
    Description = "Keep the example ready for narrow screens",
    Flag = "CompactSpacing",
    Default = false,
    Callback = function(value)
        print(value)
    end
})
