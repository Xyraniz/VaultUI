-- Ragebot / VaultUI showcase
-- The original interface is now exposed as a reusable library constructor.
local SOURCE = "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Ragebot/source.lua"
local Ragebot = loadstring(game:HttpGet(SOURCE))()

local Window = Ragebot.new({
    Keybind = Enum.KeyCode.Insert,
})

Window.OnVisibilityChanged = function(visible)
    print("Ragebot menu:", visible and "opened" or "closed")
end

-- The menu starts hidden, matching the original INSERT-toggle behavior.
Window:SetVisible(true)

-- Public handles for embedding the interface into a larger script:
-- Window.MainFrame, Window.ScreenGui, Window.Tabs
-- Window:SetVisible(false), Window:ToggleVisibility(), Window:Destroy()
return Window
