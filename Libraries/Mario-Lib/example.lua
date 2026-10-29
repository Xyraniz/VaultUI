local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
if type(shared) == "table" and type(shared.SynergyUtilityLibrary) == "table" then
    pcall(function()
        shared.SynergyUtilityLibrary:Unload()
    end)
end
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Mario-Lib/source.lua"))()

if type(shared) == "table" then
    shared.SynergyUtilityLibrary = Library
end

local Window = Library:CreateWindow({
    Title = "Synergy Utility",
    SubTitle = "Client Control",
    Size = Vector2.new(860, 590),
    Scale = UserInputService.TouchEnabled and 0.85 or 1,
    Theme = "Dark",
    Language = "EN",
    MenuKey = "RightControl",
    ConfigFolder = "SynergyUtilities",
    WatermarkTitle = "Synergy Utility",
    Watermark = true,
    Intro = false
})

local State = {
    SpeedEnabled = false,
    Speed = 26,
    SpeedLimits = { 8, 90 },
    LockSpeed = false,
    JumpEnabled = false,
    JumpPower = 65,
    InfiniteJump = false,
    AutoJump = false,
    Noclip = false,
    FOVEnabled = false,
    FOV = 85,
    LightingEnabled = false,
    ClockTime = 14,
    Brightness = 2,
    Ambient = Color3.fromRGB(170, 170, 190),
    OutdoorAmbient = Color3.fromRGB(160, 160, 180),
    Fullbright = false,
    NoFog = false,
    HiddenEffects = {},
    SelectedPlayer = nil,
    SelectedPlayers = {},
    ShowHighlights = false,
    HighlightColor = Color3.fromRGB(170, 90, 255),
    PlayerRange = { 0, 2000 },
    PlayerRows = 10,
    AutoRefresh = true,
    TrackDistance = true,
    NotificationTitle = "Synergy Utility",
    NotificationDuration = 4,
    NotificationType = "Info",
    NotificationRepeat = 1,
    EnabledTypes = { Info = true, Success = true, Warning = true, Error = true },
    NotificationsSent = 0,
    Actions = 0,
    Unloaded = false
}

local Connections = {}
local CharacterDefaults = setmetatable({}, { __mode = "k" })
local CameraDefaults = setmetatable({}, { __mode = "k" })
local CollisionDefaults = setmetatable({}, { __mode = "k" })
local EffectDefaults = setmetatable({}, { __mode = "k" })
local Highlights = {}
local OriginalLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd
}

local function Connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Connections, connection)
    return connection
end

local function Notify(title, message, kind, duration)
    Library:Notify({
        Title = title,
        Content = message,
        Type = kind or "Info",
        Duration = duration or 4
    })
end

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetHumanoid(character)
    character = character or GetCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function GetRoot(character)
    character = character or GetCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function GetPlayer(name)
    return type(name) == "string" and Players:FindFirstChild(name) or nil
end

local function SnapshotHumanoid(humanoid)
    if humanoid and not CharacterDefaults[humanoid] then
        CharacterDefaults[humanoid] = {
            WalkSpeed = humanoid.WalkSpeed,
            JumpPower = humanoid.JumpPower,
            JumpHeight = humanoid.JumpHeight,
            UseJumpPower = humanoid.UseJumpPower
        }
    end
    return humanoid and CharacterDefaults[humanoid]
end

local function ApplyMovement()
    local humanoid = GetHumanoid()
    if not humanoid then
        return
    end

    local original = SnapshotHumanoid(humanoid)
    if State.SpeedEnabled then
        humanoid.WalkSpeed = math.clamp(State.Speed, State.SpeedLimits[1], State.SpeedLimits[2])
    elseif original then
        humanoid.WalkSpeed = original.WalkSpeed
    end

    if State.JumpEnabled then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = State.JumpPower
    elseif original then
        humanoid.UseJumpPower = original.UseJumpPower
        humanoid.JumpPower = original.JumpPower
        humanoid.JumpHeight = original.JumpHeight
    end
end

local function RestoreMovement()
    for humanoid, original in pairs(CharacterDefaults) do
        if humanoid and humanoid.Parent then
            humanoid.WalkSpeed = original.WalkSpeed
            humanoid.UseJumpPower = original.UseJumpPower
            humanoid.JumpPower = original.JumpPower
            humanoid.JumpHeight = original.JumpHeight
        end
    end
end

local function RestoreCollision()
    for part, canCollide in pairs(CollisionDefaults) do
        if part and part.Parent then
            part.CanCollide = canCollide
        end
        CollisionDefaults[part] = nil
    end
end

local function ApplyCamera()
    local camera = Workspace.CurrentCamera
    if not camera then
        return
    end
    if CameraDefaults[camera] == nil then
        CameraDefaults[camera] = camera.FieldOfView
    end
    camera.FieldOfView = State.FOVEnabled and State.FOV or CameraDefaults[camera]
end

local function RestoreCamera()
    for camera, original in pairs(CameraDefaults) do
        if camera and camera.Parent then
            camera.FieldOfView = original
        end
    end
    local camera = Workspace.CurrentCamera
    local humanoid = GetHumanoid()
    if camera and humanoid then
        camera.CameraSubject = humanoid
    end
end

local function RestoreCameraSubject()
    local camera = Workspace.CurrentCamera
    local humanoid = GetHumanoid()
    if camera and humanoid then
        camera.CameraSubject = humanoid
    end
end

local function ApplyLighting()
    Lighting.ClockTime = State.LightingEnabled and State.ClockTime or OriginalLighting.ClockTime
    Lighting.Brightness = State.Fullbright and 3 or
        (State.LightingEnabled and State.Brightness or OriginalLighting.Brightness)
    Lighting.Ambient = State.Fullbright and Color3.new(1, 1, 1) or
        (State.LightingEnabled and State.Ambient or OriginalLighting.Ambient)
    Lighting.OutdoorAmbient = State.Fullbright and Color3.new(1, 1, 1) or
        (State.LightingEnabled and State.OutdoorAmbient or OriginalLighting.OutdoorAmbient)
    Lighting.GlobalShadows = State.Fullbright and false or OriginalLighting.GlobalShadows
    Lighting.FogEnd = State.NoFog and 1000000 or OriginalLighting.FogEnd
end

local EffectClasses = {
    Blur = "BlurEffect",
    Bloom = "BloomEffect",
    SunRays = "SunRaysEffect",
    ColorCorrection = "ColorCorrectionEffect",
    DepthOfField = "DepthOfFieldEffect"
}

local function ApplyEffects()
    for effect, original in pairs(EffectDefaults) do
        if effect and effect.Parent then
            effect.Enabled = original
        end
        EffectDefaults[effect] = nil
    end
    for _, descendant in ipairs(Lighting:GetDescendants()) do
        if descendant:IsA("PostEffect") then
            for name, className in pairs(EffectClasses) do
                if State.HiddenEffects[name] and descendant:IsA(className) then
                    EffectDefaults[descendant] = descendant.Enabled
                    descendant.Enabled = false
                    break
                end
            end
        end
    end
end

local function ClearHighlights()
    for player, highlight in pairs(Highlights) do
        highlight:Destroy()
        Highlights[player] = nil
    end
end

local function ApplyHighlights()
    if not State.ShowHighlights then
        ClearHighlights()
        return
    end

    for player, highlight in pairs(Highlights) do
        local root = GetRoot(player.Character)
        local ownRoot = GetRoot()
        local distance = root and ownRoot and (root.Position - ownRoot.Position).Magnitude or math.huge
        if not State.SelectedPlayers[player.Name] or not player.Character
            or distance < State.PlayerRange[1] or distance > State.PlayerRange[2] then
            highlight:Destroy()
            Highlights[player] = nil
        end
    end

    for name, enabled in pairs(State.SelectedPlayers) do
        local player = enabled and GetPlayer(name)
        if player and player ~= LocalPlayer and player.Character then
            local root = GetRoot(player.Character)
            local ownRoot = GetRoot()
            local distance = root and ownRoot and (root.Position - ownRoot.Position).Magnitude or math.huge
            if distance >= State.PlayerRange[1] and distance <= State.PlayerRange[2] then
                local highlight = Highlights[player]
                if not highlight or not highlight.Parent then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "SynergyPlayerHighlight"
                    highlight.Adornee = player.Character
                    highlight.FillTransparency = 0.6
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = player.Character
                    Highlights[player] = highlight
                end
                highlight.FillColor = State.HighlightColor
                highlight.OutlineColor = State.HighlightColor
            end
        end
    end
end

local function CopyText(value)
    if type(setclipboard) == "function" then
        setclipboard(tostring(value))
        Notify("Clipboard", "Value copied successfully.", "Success")
    else
        Notify("Clipboard", "This executor does not support setclipboard.", "Warning")
    end
end

local function GetPing()
    local ok, ping = pcall(function()
        return math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5)
    end)
    return ok and ping or 0
end

local function GetDistance(player)
    local ownRoot = GetRoot()
    local targetRoot = player and player.Character and GetRoot(player.Character)
    if not ownRoot or not targetRoot then
        return nil
    end
    return (ownRoot.Position - targetRoot.Position).Magnitude
end

local Dashboard = Window:AddTab("Dashboard", "home", "Live session overview and quick actions")
local Overview = Dashboard:AddLeftGroupbox("Session Overview", "star")
Overview:AddMarquee("SYNERGY UTILITY  |  Movement  |  Camera  |  Lighting  |  Players  |  Interface")
Overview:AddBadge("SESSION ACTIVE", { Color = "Good" })
Overview:AddSeparatorText("LIVE TELEMETRY")
local FpsStat = Overview:AddStat("DashFPS", { Title = "Frame Rate", Value = 60, Suffix = " FPS", Icon = "star", Color = "Good", NoSave = true })
local PingStat = Overview:AddStat("DashPing", { Title = "Latency", Value = 0, Suffix = " ms", Icon = "target", Color = "Blue", NoSave = true })
local PlayerStat = Overview:AddStat("DashPlayers", { Title = "Online Players", Value = #Players:GetPlayers(), Icon = "person", Color = "Coin", NoSave = true })
local HealthBar = Overview:AddProgressBar("DashHealth", { Text = "Character Health", Max = 100, Default = 100, NoSave = true })
local CharacterStatus = Overview:AddStatus("DashStatus", { Text = "Character", Status = "Loading", Color = "Risky", NoSave = true })
Overview:AddKbd("RightControl")

local SessionGroup = Dashboard:AddRightGroupbox("Server Information", "qblock")
SessionGroup:AddParagraph({
    Title = "Connected Server",
    Content = "Session details are updated locally. Use the buttons below to copy server identifiers."
})
local SessionTable = SessionGroup:AddTable("DashServerTable", {
    Headers = { "Property", "Value" },
    Rows = {
        { "Place ID", tostring(game.PlaceId) },
        { "Players", tostring(#Players:GetPlayers()) },
        { "Server", game.JobId ~= "" and game.JobId:sub(1, 12) .. "..." or "Studio" },
        { "Device", UserInputService.TouchEnabled and "Touch" or "Desktop" }
    }
})
SessionGroup:AddButton({
    Text = "Copy Place ID",
    Style = "Primary",
    Icon = "qblock",
    Func = function()
        CopyText(game.PlaceId)
    end
}):AddButton({
    Text = "Copy Job ID",
    Style = "Default",
    Func = function()
        CopyText(game.JobId)
    end
})
SessionGroup:AddDivider()
local RuntimeInfo = SessionGroup:AddChild("RuntimeDetails", { Height = 150, Border = true })
RuntimeInfo:AddLabel("Current Player: " .. LocalPlayer.Name)
RuntimeInfo:AddLabel("Display Name: " .. LocalPlayer.DisplayName)
RuntimeInfo:AddLabel("User ID: " .. tostring(LocalPlayer.UserId))
RuntimeInfo:AddLabel("Library Version: " .. tostring(Library.Version))
RuntimeInfo:AddButton({
    Text = "View Session",
    Style = "Success",
    Func = function()
        Window:Sheet({
            Title = "Session Details",
            Build = function(body)
                body:AddParagraph({
                    Title = "Active Session",
                    Content = "These values belong to the current Roblox client."
                })
                body:AddLabel("Username: " .. LocalPlayer.Name)
                body:AddLabel("Place ID: " .. tostring(game.PlaceId))
                body:AddLabel("Game ID: " .. tostring(game.GameId))
                body:AddLabel("Job ID: " .. tostring(game.JobId))
                body:AddButton({ Text = "Copy Game ID", Func = function()
                    CopyText(game.GameId)
                end })
                body:AddButton({ Text = "Close", Style = "Primary", Func = function()
                    Library.CloseSheet()
                end })
            end
        })
    end
})

Window:AddTabSection("CHARACTER")
local Movement = Window:AddTab("Movement", "person", "Movement settings and character controls")
local SpeedGroup = Movement:AddLeftGroupbox("Speed Control", "target")
local SpeedToggle = SpeedGroup:AddToggle("MoveSpeedEnabled", {
    Text = "Custom Walk Speed",
    Description = "Override your character's walking speed.",
    Default = false,
    Tooltip = "Enabled values may be restricted by the game's server.",
    Callback = function(value)
        State.SpeedEnabled = value
        ApplyMovement()
    end
})
SpeedToggle:AddKeyPicker("MoveSpeedKey", { Default = "LeftShift", Mode = "Toggle" })
local SpeedSlider = SpeedGroup:AddSlider("MoveSpeed", {
    Text = "Walk Speed", Min = 8, Max = 120, Default = 26, Suffix = " studs/s",
    Callback = function(value)
        State.Speed = value
        if State.SpeedEnabled then
            ApplyMovement()
        end
    end
})
SpeedGroup:AddRangeSlider("MoveSpeedLimits", {
    Text = "Allowed Speed Range",
    Min = 8, Max = 120, Default = { 8, 90 }, Suffix = " studs/s",
    Callback = function(value)
        State.SpeedLimits = { value[1], value[2] }
        if State.SpeedEnabled then
            ApplyMovement()
        end
    end
})
SpeedGroup:AddSegmented("MoveSpeedPreset", {
    Text = "Movement Preset",
    Values = { "Walk", "Run", "Sprint" },
    Default = "Run",
    Callback = function(value)
        local values = { Walk = 16, Run = 26, Sprint = 44 }
        SpeedSlider:SetValue(values[value] or 26)
    end
})
SpeedGroup:AddCheckbox("MoveLockSpeed", {
    Text = "Keep Speed Applied",
    Description = "Reapply speed if another local script resets it.",
    Default = false,
    Callback = function(value)
        State.LockSpeed = value
    end
})

local JumpGroup = Movement:AddRightGroupbox("Jump Control", "star")
JumpGroup:AddToggle("MoveJumpEnabled", {
    Text = "Custom Jump Power",
    Default = false,
    Callback = function(value)
        State.JumpEnabled = value
        ApplyMovement()
    end
})
JumpGroup:AddSlider("MoveJumpPower", {
    Text = "Jump Power", Min = 20, Max = 180, Default = 65,
    Callback = function(value)
        State.JumpPower = value
        if State.JumpEnabled then
            ApplyMovement()
        end
    end
})
JumpGroup:AddToggle("MoveInfiniteJump", {
    Text = "Infinite Jump",
    Description = "Jump again while airborne.",
    Callback = function(value)
        State.InfiniteJump = value
    end
})
JumpGroup:AddCheckbox("MoveAutoJump", {
    Text = "Auto Jump",
    Description = "Automatically jump while moving on the ground.",
    Callback = function(value)
        State.AutoJump = value
    end
})
JumpGroup:AddToggle("MoveNoclip", {
    Text = "Noclip",
    Description = "Disable collision for your character locally.",
    Callback = function(value)
        State.Noclip = value
        if not value then
            RestoreCollision()
        end
    end
})
JumpGroup:AddButton({
    Text = "Restore Movement",
    Style = "Warning",
    Func = function()
        Library.Toggles.MoveSpeedEnabled:SetValue(false)
        Library.Toggles.MoveJumpEnabled:SetValue(false)
        Library.Toggles.MoveInfiniteJump:SetValue(false)
        Library.Toggles.MoveNoclip:SetValue(false)
        Library.Options.MoveAutoJump:SetValue(false)
        RestoreMovement()
        Notify("Movement", "Character movement restored.", "Success")
    end
})

local View = Window:AddTab("Camera & World", "eye", "Camera, lighting and post-processing")
local CameraGroup = View:AddLeftGroupbox("Camera", "eye")
CameraGroup:AddToggle("CameraFOVEnabled", {
    Text = "Custom Field of View",
    Default = false,
    Callback = function(value)
        State.FOVEnabled = value
        ApplyCamera()
    end
})
local FOVSlider = CameraGroup:AddSlider("CameraFOV", {
    Text = "Field of View", Min = 40, Max = 120, Default = 85, Suffix = " deg",
    Callback = function(value)
        State.FOV = value
        if State.FOVEnabled then
            ApplyCamera()
        end
    end
})
CameraGroup:AddSegmented("CameraFOVPreset", {
    Text = "FOV Preset",
    Values = { "Normal", "Wide", "Ultra" },
    Default = "Wide",
    Callback = function(value)
        local presets = { Normal = 70, Wide = 85, Ultra = 105 }
        FOVSlider:SetValue(presets[value] or 85)
    end
})
CameraGroup:AddButton({
    Text = "Reset Camera",
    Style = "Default",
    Func = function()
        Library.Toggles.CameraFOVEnabled:SetValue(false)
        RestoreCamera()
        Notify("Camera", "Camera restored.", "Success")
    end
})

local LightGroup = View:AddRightGroupbox("Environment", "flower")
LightGroup:AddToggle("WorldLightingEnabled", {
    Text = "Custom Lighting",
    Callback = function(value)
        State.LightingEnabled = value
        ApplyLighting()
    end
})
local TimeSlider = LightGroup:AddSlider("WorldClockTime", {
    Text = "Time of Day", Min = 0, Max = 24, Default = 14, Rounding = 1, Suffix = " h",
    Callback = function(value)
        State.ClockTime = value
        ApplyLighting()
    end
})
LightGroup:AddSegmented("WorldTimePreset", {
    Text = "Time Preset",
    Values = { "Morning", "Day", "Night" },
    Default = "Day",
    Callback = function(value)
        TimeSlider:SetValue(({ Morning = 8, Day = 14, Night = 0 })[value] or 14)
    end
})
LightGroup:AddSlider("WorldBrightness", {
    Text = "Brightness", Min = 0, Max = 5, Default = 2, Rounding = 1,
    Callback = function(value)
        State.Brightness = value
        ApplyLighting()
    end
})
LightGroup:AddColorPicker("WorldAmbient", {
    Text = "Ambient Color",
    Default = State.Ambient,
    Callback = function(value)
        State.Ambient = value
        ApplyLighting()
    end
})
LightGroup:AddLabel("Outdoor Ambient"):AddColorPicker("WorldOutdoorAmbient", {
    Default = State.OutdoorAmbient,
    Callback = function(value)
        State.OutdoorAmbient = value
        ApplyLighting()
    end
})
LightGroup:AddToggle("WorldFullbright", {
    Text = "Fullbright",
    Callback = function(value)
        State.Fullbright = value
        ApplyLighting()
    end
})
LightGroup:AddCheckbox("WorldNoFog", {
    Text = "Disable Fog",
    Callback = function(value)
        State.NoFog = value
        ApplyLighting()
    end
})

local EffectsGroup = View:AddLeftGroupbox("Post-Processing", "star")
EffectsGroup:AddParagraph({
    Title = "Local Effects",
    Content = "Select the effects to disable. Existing effects are restored when you clear the selection."
})
local EffectList = EffectsGroup:AddListBox("WorldDisabledEffects", {
    Text = "Disabled Effects",
    Values = { "Blur", "Bloom", "SunRays", "ColorCorrection", "DepthOfField" },
    Multi = true,
    Height = 5,
    Default = {},
    Callback = function(value)
        State.HiddenEffects = value
        ApplyEffects()
    end
})
EffectsGroup:AddButton({
    Text = "Restore World",
    Style = "Warning",
    Func = function()
        Library.Toggles.WorldLightingEnabled:SetValue(false)
        Library.Toggles.WorldFullbright:SetValue(false)
        Library.Options.WorldNoFog:SetValue(false)
        EffectList:SetValue({})
        ApplyLighting()
        ApplyEffects()
        Notify("World", "Lighting and post-processing restored.", "Success")
    end
})

Window:AddTabSection("PLAYERS & TOOLS")
local PlayerTab = Window:AddTab("Players", "person", "Player selection, spectating and local highlighting")
local SelectionGroup = PlayerTab:AddLeftGroupbox("Target Selection", "target")
local SingleDropdown = SelectionGroup:AddDropdown("PlayersTarget", {
    Text = "Target Player",
    SpecialType = "Player",
    Searchable = true,
    AllowNull = true,
    Callback = function(value)
        State.SelectedPlayer = value
    end
})
local MultiDropdown = SelectionGroup:AddDropdown("PlayersSelected", {
    Text = "Highlight Targets",
    SpecialType = "Player",
    Searchable = true,
    Multi = true,
    Default = {},
    Callback = function(value)
        State.SelectedPlayers = value
        ApplyHighlights()
    end
})
SelectionGroup:AddToggle("PlayersHighlight", {
    Text = "Highlight Selected Players",
    Default = false,
    Callback = function(value)
        State.ShowHighlights = value
        ApplyHighlights()
    end
})
SelectionGroup:AddLabel("Highlight Color"):AddColorPicker("PlayersHighlightColor", {
    Default = State.HighlightColor,
    Callback = function(value)
        State.HighlightColor = value
        ApplyHighlights()
    end
})
SelectionGroup:AddRangeSlider("PlayersDistanceRange", {
    Text = "Highlight Distance",
    Min = 0, Max = 5000, Default = { 0, 2000 }, Suffix = " studs",
    Callback = function(value)
        State.PlayerRange = { value[1], value[2] }
        ApplyHighlights()
    end
})
SelectionGroup:AddButton({
    Text = "Spectate",
    Style = "Primary",
    Func = function()
        local target = GetPlayer(State.SelectedPlayer)
        local humanoid = target and target.Character and GetHumanoid(target.Character)
        local camera = Workspace.CurrentCamera
        if not humanoid or not camera then
            Notify("Spectate", "Select a spawned player first.", "Warning")
            return
        end
        camera.CameraSubject = humanoid
        State.Actions += 1
        Notify("Spectate", "Watching " .. target.Name, "Success")
    end
}):AddButton({
    Text = "Stop Spectating",
    Style = "Default",
    Func = function()
        RestoreCameraSubject()
    end
})
SelectionGroup:AddButton({
    Text = "Copy Target Username",
    Func = function()
        if State.SelectedPlayer then
            CopyText(State.SelectedPlayer)
        else
            Notify("Players", "Select a player first.", "Warning")
        end
    end
}):AddButton({
    Text = "Clear Highlights",
    Style = "Danger",
    Func = function()
        Library.Toggles.PlayersHighlight:SetValue(false)
        MultiDropdown:SetValue({})
        ClearHighlights()
    end
})

local DirectoryGroup = PlayerTab:AddRightGroupbox("Player Directory", "person")
local TargetStatus = DirectoryGroup:AddStatus("PlayersTargetStatus", {
    Text = "Selected Target", Status = "None", Color = "Risky", NoSave = true
})
local DistanceStat = DirectoryGroup:AddStat("PlayersTargetDistance", {
    Title = "Target Distance", Value = "-", Suffix = " studs", Icon = "target", NoSave = true
})
DirectoryGroup:AddCheckbox("PlayersTrackDistance", {
    Text = "Track Distance",
    Default = true,
    Callback = function(value)
        State.TrackDistance = value
    end
})
DirectoryGroup:AddSelectable("PlayersAutoRefresh", {
    Text = "Auto Refresh Directory",
    Default = true,
    Callback = function(value)
        State.AutoRefresh = value
    end
})
DirectoryGroup:AddStepper("PlayersRowLimit", {
    Text = "Visible Players",
    Min = 3, Max = 20, Step = 1, Default = 10,
    Callback = function(value)
        State.PlayerRows = value
    end
})
local PlayersTable = DirectoryGroup:AddTable("PlayersDirectory", {
    Headers = { "Username", "Distance" },
    Rows = { { "Loading...", "-" } }
})
local function RefreshDirectory()
    local rows = {}
    local players = Players:GetPlayers()
    table.sort(players, function(a, b)
        return a.Name:lower() < b.Name:lower()
    end)
    for index, player in ipairs(players) do
        if index > State.PlayerRows then
            break
        end
        local distance = GetDistance(player)
        rows[#rows + 1] = {
            player.Name,
            distance and string.format("%.0f", distance) or "-"
        }
    end
    PlayersTable:SetRows(rows)
end
DirectoryGroup:AddButton({
    Text = "Refresh Directory",
    Style = "Success",
    Func = RefreshDirectory
}):AddButton({
    Text = "Copy Player List",
    Func = function()
        local names = {}
        for _, player in ipairs(Players:GetPlayers()) do
            names[#names + 1] = player.Name
        end
        CopyText(table.concat(names, "\n"))
    end
})

Window:AddVisualsTab({
    Name = "ESP & Radar",
    Icon = "eye",
    Description = "Native player visuals and radar controls",
    Preview = true
})

local ToolsTab = Window:AddTab("Utilities", "qblock", "Actions, notifications and interface interactions")
local NotifyGroup = ToolsTab:AddLeftGroupbox("Notifications", "star")
NotifyGroup:AddInput("ToolsNotificationTitle", {
    Text = "Notification Title", Default = "Synergy Utility",
    Placeholder = "Enter a title", MaxLength = 45, Finished = true,
    Callback = function(value)
        State.NotificationTitle = value ~= "" and value or "Synergy Utility"
    end
})
local MessageInput = NotifyGroup:AddInput("ToolsNotificationMessage", {
    Text = "Message", Default = "Everything is running correctly.",
    Placeholder = "Enter your message", MaxLength = 180, Finished = true
})
NotifyGroup:AddDropdown("ToolsNotificationType", {
    Text = "Notification Type",
    Values = { "Info", "Success", "Warning", "Error" },
    Default = "Info",
    Callback = function(value)
        State.NotificationType = value
    end
})
NotifyGroup:AddSlider("ToolsNotificationDuration", {
    Text = "Display Duration",
    Min = 1, Max = 12, Default = 4, Rounding = 1, Suffix = " s",
    Callback = function(value)
        State.NotificationDuration = value
    end
})
NotifyGroup:AddStepper("ToolsNotificationRepeat", {
    Text = "Messages Per Action",
    Min = 1, Max = 5, Step = 1, Default = 1,
    Callback = function(value)
        State.NotificationRepeat = value
    end
})
NotifyGroup:AddListBox("ToolsAllowedNotifications", {
    Text = "Allowed Notification Types",
    Values = { "Info", "Success", "Warning", "Error" },
    Height = 4,
    Multi = true,
    Default = { "Info", "Success", "Warning", "Error" },
    Callback = function(value)
        State.EnabledTypes = value
    end
})
local NotificationProgress = NotifyGroup:AddProgressBar("ToolsNotificationProgress", {
    Text = "Notification Activity",
    Max = 20, Default = 0, NoSave = true
})
local NotificationStat = NotifyGroup:AddStat("ToolsNotificationCount", {
    Title = "Notifications Sent", Value = 0, Icon = "star", Color = "Blue", NoSave = true
})
NotifyGroup:AddButton({
    Text = "Send Notification",
    Style = "Primary",
    Func = function()
        if not State.EnabledTypes[State.NotificationType] then
            Notify("Notification Filter", "This notification type is disabled.", "Warning")
            return
        end
        for index = 1, State.NotificationRepeat do
            task.delay((index - 1) * 0.15, function()
                if State.Unloaded then
                    return
                end
                Notify(State.NotificationTitle, MessageInput.Value, State.NotificationType, State.NotificationDuration)
                State.NotificationsSent += 1
                NotificationStat:SetValue(State.NotificationsSent)
                NotificationProgress:SetValue(State.NotificationsSent % 21)
            end)
        end
    end
})

local ActionGroup = ToolsTab:AddRightGroupbox("Quick Actions", "target")
ActionGroup:AddParagraph({
    Title = "Interactive Actions",
    Content = "Dialogs, side panels, button styles and live control updates are available here."
})
ActionGroup:AddButton({
    Text = "Success",
    Style = "Success",
    Func = function()
        Notify("Action Complete", "The success button was pressed.", "Success")
        State.Actions += 1
    end
}):AddButton({
    Text = "Warning",
    Style = "Warning",
    Func = function()
        Notify("Warning", "The warning button was pressed.", "Warning")
        State.Actions += 1
    end
})
ActionGroup:AddButton({
    Text = "Show Confirmation",
    Style = "Primary",
    Func = function()
        Window:Dialog({
            Title = "Confirm Action",
            Content = "This will increase the action counter and close the confirmation window.",
            Buttons = {
                { Text = "Cancel", Style = "Default" },
                { Text = "Confirm", Style = "Success", Callback = function()
                    State.Actions += 1
                    Notify("Confirmed", "Action confirmed successfully.", "Success")
                end }
            }
        })
    end
})
ActionGroup:AddButton({
    Text = "Open Side Panel",
    Style = "Default",
    Func = function()
        Window:Sheet({
            Title = "Control Panel",
            Build = function(body)
                body:AddParagraph({
                    Title = "Quick Preferences",
                    Content = "Settings in this panel control the same live state as the main window."
                })
                body:AddButton({ Text = "Enable Fullbright", Style = "Success", Func = function()
                    Library.Toggles.WorldFullbright:SetValue(true)
                end })
                body:AddButton({ Text = "Restore Lighting", Style = "Warning", Func = function()
                    Library.Toggles.WorldFullbright:SetValue(false)
                    Library.Toggles.WorldLightingEnabled:SetValue(false)
                end })
                body:AddButton({ Text = "Center Camera", Style = "Default", Func = RestoreCamera })
                body:AddButton({ Text = "Close Panel", Style = "Primary", Func = function()
                    Library.CloseSheet()
                end })
            end
        })
    end
})
ActionGroup:AddButton({
    Text = "Clear Notifications",
    Style = "Danger",
    DoubleClick = true,
    Func = function()
        State.NotificationsSent = 0
        NotificationStat:SetValue(0)
        NotificationProgress:SetValue(0)
        Notify("Notifications", "Local notification counters have been reset.", "Success")
    end
})
local ActionStatus = ActionGroup:AddStatus("ToolsActionStatus", {
    Text = "Action Status", Status = "Ready", Color = "Good", NoSave = true
})
local ActionCount = ActionGroup:AddStat("ToolsActionCount", {
    Title = "Completed Actions", Value = 0, Color = "Coin", Icon = "star", NoSave = true
})
ActionGroup:AddSeparatorText("CONTROL SHORTCUTS")
ActionGroup:AddKeybind("ToolsNotifyKey", {
    Text = "Quick Notification",
    Default = "K",
    Mode = "Toggle",
    Callback = function(active)
        if active then
            Notify("Quick Shortcut", "Keybind activated.", "Info")
        end
    end
})
ActionGroup:AddLabel("Custom Button Shortcut"):AddKeyPicker("ToolsMenuKey", {
    Default = "RightAlt",
    Mode = "Toggle",
    Callback = function(active)
        if active then
            Window:Toggle()
        end
    end
})

local SettingsTab = Window:AddSettingsTab()
SettingsTab:AddRightGroupbox("Additional Controls", "star"):AddParagraph({
    Title = "Synergy Utility",
    Content = "Use the built-in settings to change themes, language, scaling, menu key, watermark, particles, floating button and saved configurations."
})
Library:OnUnload(function()
    State.Unloaded = true
    if type(shared) == "table" and shared.SynergyUtilityLibrary == Library then
        shared.SynergyUtilityLibrary = nil
    end
    for _, connection in ipairs(Connections) do
        connection:Disconnect()
    end
    table.clear(Connections)
    RestoreCollision()
    RestoreMovement()
    RestoreCamera()
    ClearHighlights()
    State.HiddenEffects = {}
    ApplyEffects()
    State.LightingEnabled = false
    State.Fullbright = false
    State.NoFog = false
    ApplyLighting()
end)

Connect(UserInputService.JumpRequest, function()
    if State.InfiniteJump then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Connect(RunService.Stepped, function()
    if not State.Noclip then
        return
    end
    local character = GetCharacter()
    if not character then
        return
    end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if CollisionDefaults[part] == nil then
                CollisionDefaults[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end)

local frameCount = 0
Connect(RunService.RenderStepped, function()
    frameCount += 1
end)

Connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    ApplyCamera()
end)

Connect(LocalPlayer.CharacterAdded, function(character)
    task.defer(function()
        local humanoid = character:WaitForChild("Humanoid", 10)
        if State.Unloaded or not humanoid then
            return
        end
        SnapshotHumanoid(humanoid)
        ApplyMovement()
        ApplyCamera()
    end)
end)

Connect(Players.PlayerRemoving, function(player)
    if Highlights[player] then
        Highlights[player]:Destroy()
        Highlights[player] = nil
    end
    task.defer(function()
        if not State.Unloaded then
            RefreshDirectory()
        end
    end)
end)
Connect(Players.PlayerAdded, function()
    RefreshDirectory()
end)

Library:Every(0.3, function()
    if State.Unloaded then
        return
    end
    if State.LockSpeed and State.SpeedEnabled then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = math.clamp(State.Speed, State.SpeedLimits[1], State.SpeedLimits[2])
        end
    end
    if State.AutoJump then
        local humanoid = GetHumanoid()
        if humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0.1
            and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local lastDirectory = 0
local lastHighlight = 0
Library:Every(1, function()
    if State.Unloaded then
        return
    end
    FpsStat:SetValue(frameCount)
    frameCount = 0
    PingStat:SetValue(GetPing())
    PlayerStat:SetValue(#Players:GetPlayers())

    local humanoid = GetHumanoid()
    if humanoid then
        HealthBar.Max = math.max(1, humanoid.MaxHealth)
        HealthBar:SetValue(math.max(0, humanoid.Health))
        CharacterStatus:SetValue(humanoid.Health > 0 and "Alive" or "Dead", humanoid.Health > 0 and "Good" or "Danger")
    else
        HealthBar:SetValue(0)
        CharacterStatus:SetValue("Loading", "Risky")
    end

    local target = GetPlayer(State.SelectedPlayer)
    local distance = target and GetDistance(target)
    TargetStatus:SetValue(target and target.Name or "None", target and "Good" or "Risky")
    DistanceStat:SetValue(State.TrackDistance and distance and math.floor(distance + 0.5) or "-")
    ActionCount:SetValue(State.Actions)
    ActionStatus:SetValue(State.Actions > 0 and "Active" or "Ready", "Good")

    local timeNow = os.clock()
    if State.AutoRefresh and timeNow - lastDirectory >= 3 then
        lastDirectory = timeNow
        RefreshDirectory()
    end
    if State.ShowHighlights and timeNow - lastHighlight >= 1 then
        lastHighlight = timeNow
        ApplyHighlights()
    end
end)

RefreshDirectory()
ApplyCamera()
Library:LoadAutoloadConfig()
Notify("Synergy Utility", "Client controls loaded successfully.", "Success", 4)