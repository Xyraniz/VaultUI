local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/WindUI-Shiny/source.lua"))()

local Window = WindUI:CreateWindow({
    Title = "WindUI Workspace",
    Icon = "layout-dashboard",
    Author = "VaultUI",
    Folder = "VaultUI/WindUI-Shiny",
    Theme = "Dark",
    Size = UDim2.fromOffset(760, 520),
    SideBarWidth = 190,
    ToggleKey = Enum.KeyCode.RightShift,
    ScrollBarEnabled = true,
    HideSearchBar = false,
    Transparent = false,
    Acrylic = false
})

local Overview = Window:Tab({
    Title = "Overview",
    Icon = "layout-dashboard",
    Desc = "Local character and session controls"
})

local Appearance = Window:Tab({
    Title = "Appearance",
    Icon = "palette",
    Desc = "Window and theme settings"
})

Overview:Section({
    Title = "Session"
})

Overview:Paragraph({
    Title = "WindUI-Shiny",
    Desc = "A source-grounded element layout for a local Roblox interface."
})

local player = game:GetService("Players").LocalPlayer
local walkSpeed = 16

Overview:Button({
    Title = "Reset movement",
    Desc = "Restore the default humanoid speed",
    Icon = "rotate-ccw",
    Callback = function()
        walkSpeed = 16
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = walkSpeed
        end
    end
})

Overview:Toggle({
    Title = "Apply movement value",
    Desc = "Use the selected speed on the local humanoid",
    Value = true,
    Callback = function(enabled)
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = enabled and walkSpeed or 16
        end
    end
})

Overview:Slider({
    Title = "Walk speed",
    Desc = "Select a value between 8 and 32",
    Value = {Min = 8, Max = 32, Default = walkSpeed},
    Step = 1,
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

Overview:Dropdown({
    Title = "Active profile",
    Desc = "Select the profile displayed by the interface",
    Values = { "Balanced", "Fast", "Precise" },
    Value = "Balanced",
    AllowNone = false,
    Callback = function(value)
        print(value)
    end
})

Appearance:Section({
    Title = "Window"
})

Appearance:Toggle({
    Title = "Show panel background",
    Desc = "Keep the main panel surface visible",
    Value = true,
    Callback = function(value)
        Window:SetPanelBackgroundVisible(value)
    end
})

Appearance:Segmented({
    Title = "Theme",
    Values = { "Dark", "Light", "Rose" },
    Value = "Dark",
    Callback = function(value)
        WindUI:SetTheme(value)
    end
})

Appearance:Input({
    Title = "Workspace label",
    Desc = "Store a label for the current session",
    Placeholder = "Enter a label",
    Value = "Main workspace",
    ClearTextOnFocus = false,
    Callback = function(value)
        print(value)
    end
})

Appearance:Progress({
    Title = "Session readiness",
    Desc = "Example progress element",
    Value = {Min = 0, Max = 100, Default = 72},
    ShowValue = true,
    Suffix = "%"
})
