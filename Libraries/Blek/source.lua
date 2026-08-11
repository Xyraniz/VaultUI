--// Destroy other instances
for _,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "dark_UI" then
        v:Destroy()
    end
end

local dark_UI = Instance.new("ScreenGui")
dark_UI.Name = "dark_UI"
dark_UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
dark_UI.Parent = game.CoreGui

local Library = {}
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HTTPService = game:GetService("HttpService")

function Library:Create(table)
    local windowName = table.Name

    local main = Instance.new("Frame")
    main.Name = "main"
    main.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    main.Position = UDim2.fromScale(0.244, 0.292)
    main.Size = UDim2.fromOffset(488, 299)

    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Font = Enum.Font.Gotham
    title.Text = windowName
    title.TextColor3 = Color3.fromRGB(168, 168, 168)
    title.TextSize = 20
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromScale(0.41, 0.0543)
    title.Size = UDim2.fromOffset(83, 28)
    title.Parent = main

    local uICorner = Instance.new("UICorner")
    uICorner.Name = "uICorner"
    uICorner.Parent = main

    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "tabContainer"
    tabContainer.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    tabContainer.Position = UDim2.fromScale(0.0342, 0.188)
    tabContainer.Size = UDim2.fromOffset(454, 30)

    local uICorner1 = Instance.new("UICorner")
    uICorner1.Name = "uICorner1"
    uICorner1.CornerRadius = UDim.new(0, 6)
    uICorner1.Parent = tabContainer

    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.Name = "uIListLayout"
    uIListLayout.Padding = UDim.new(0, 8)
    uIListLayout.FillDirection = Enum.FillDirection.Horizontal
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.Parent = tabContainer

    local uIPadding = Instance.new("UIPadding")
    uIPadding.Name = "uIPadding"
    uIPadding.PaddingLeft = UDim.new(0, 7)
    uIPadding.PaddingTop = UDim.new(0, 4)
    uIPadding.Parent = tabContainer

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "shadow"
    shadow.Image = "rbxassetid://297774371"
    shadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
    shadow.ImageTransparency = 0.3
    shadow.SliceCenter = Rect.new(20, 20, 280, 280)
    shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.fromScale(0.224, 0.272)
    shadow.Selectable = true
    shadow.Size = UDim2.fromOffset(529, 331)
    shadow.ZIndex = -1
    shadow.Parent = dark_UI

    tabContainer.Parent = main
    main.Parent = dark_UI
    main.AnchorPoint = Vector2.new(0.5,0.5)
    shadow.AnchorPoint = Vector2.new(0.5,0.5)

    main.Position = UDim2.new(0.5,0,0.5,0)
    shadow.Position = UDim2.new(0.5,0,0.5,0)

    local tabHandler = {}

    function tabHandler:Exit()
        dark_UI:Destroy()
    end

    function tabHandler:Tab(name)
        --// Creating the yttab
        local main1 = Instance.new("TextButton")
        main1.Name = name
        main1.Font = Enum.Font.Gotham
        main1.Text = name
        main1.TextColor3 = Color3.fromRGB(195, 195, 195)
        main1.TextSize = 13
        main1.TextTransparency = 0.5
        main1.AutomaticSize = Enum.AutomaticSize.X
        main1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        main1.BackgroundTransparency = 1
        main1.Size = UDim2.fromOffset(10, 24)
        main1.Parent = tabContainer

        --// Creating the container
        local container = Instance.new("Frame")
        container.Name = "container"
        container.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
        container.Position = UDim2.fromScale(0.0342, 0.31)
        container.Size = UDim2.fromOffset(454, 183)
        
        local uICorner2 = Instance.new("UICorner")
        uICorner2.Name = "uICorner2"
        uICorner2.CornerRadius = UDim.new(0, 6)
        uICorner2.Parent = container
        
        local holder = Instance.new("ScrollingFrame")
        holder.Name = "holder"
        holder.ScrollBarImageColor3 = Color3.fromRGB(76, 76, 76)
        holder.ScrollBarThickness = 2
        holder.ScrollingDirection = Enum.ScrollingDirection.Y
        holder.Active = true
        holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        holder.BackgroundTransparency = 1
        holder.BorderColor3 = Color3.fromRGB(33, 33, 33)
        holder.Position = UDim2.fromScale(0.0022, 0.00404)
        holder.Size = UDim2.fromOffset(452, 182)

        local uIPadding1 = Instance.new("UIPadding")
        uIPadding1.Name = "uIPadding1"
        uIPadding1.PaddingLeft = UDim.new(0, 5)
        uIPadding1.PaddingTop = UDim.new(0, 7)
        uIPadding1.Parent = holder

        local uIListLayout1 = Instance.new("UIListLayout")
        uIListLayout1.Name = "uIListLayout1"
        uIListLayout1.Padding = UDim.new(0, 3)
        uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
        uIListLayout1.Parent = holder

        local uICorner11 = Instance.new("UICorner")
        uICorner11.Name = "uICorner11"
        uICorner11.CornerRadius = UDim.new(0, 6)
        uICorner11.Parent = holder

        holder.Parent = container
        container.Parent = main
        container.Visible = false

        --// Event
        main1.MouseButton1Click:Connect(function()
            for _,v in pairs(game.CoreGui:FindFirstChild('dark_UI').main:GetChildren()) do
                if v.Name == "container" then
                    v.Visible = false
                end
            end
            for _,v in pairs(game.CoreGui['dark_UI'].main.tabContainer:GetChildren()) do
                if v:IsA('TextButton') then
                    game:GetService('TweenService'):Create(v, TweenInfo.new(0.3), {TextTransparency = 0.5}):Play()
                end
            end
            container.Visible = true
            game:GetService('TweenService'):Create(main1, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        end)

        --// Elements
        local ElementHandler = {}
        function ElementHandler:Label(text)
            local label = Instance.new("Frame")
            label.Name = "label"
            label.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            label.Size = UDim2.fromOffset(441, 32)
            label.Parent = holder
    
            local uICorner3 = Instance.new("UICorner")
            uICorner3.Name = "uICorner3"
            uICorner3.CornerRadius = UDim.new(0, 6)
            uICorner3.Parent = label

            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "textLabel"
            textLabel.Font = Enum.Font.Gotham
            textLabel.Text = text
            textLabel.TextColor3 = Color3.fromRGB(195, 195, 195)
            textLabel.TextSize = 13
            textLabel.TextStrokeColor3 = Color3.fromRGB(195, 195, 195)
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.BackgroundTransparency = 1
            textLabel.Position = UDim2.fromScale(0.0181, 0)
            textLabel.Size = UDim2.fromOffset(1, 32)
            textLabel.Parent = label
        end

        function ElementHandler:Button(text, callback)
            text = text or "Button"
            callback = callback or function() end

            local button = Instance.new("TextButton")
            button.Name = "button"
            button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            button.Position = UDim2.fromScale(0, 0.135)
            button.Size = UDim2.fromOffset(441, 32)
            button.Text = ""
            button.AutoButtonColor = false

            local uICorner12 = Instance.new("UICorner")
            uICorner12.Name = "uICorner12"
            uICorner12.CornerRadius = UDim.new(0, 6)
            uICorner12.Parent = button

            local textLabel5 = Instance.new("TextLabel")
            textLabel5.Name = "textLabel5"
            textLabel5.Font = Enum.Font.Gotham
            textLabel5.Text = text
            textLabel5.TextColor3 = Color3.fromRGB(195, 195, 195)
            textLabel5.TextSize = 13
            textLabel5.TextStrokeColor3 = Color3.fromRGB(195, 195, 195)
            textLabel5.TextXAlignment = Enum.TextXAlignment.Left
            textLabel5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textLabel5.BackgroundTransparency = 1
            textLabel5.Position = UDim2.fromScale(0.0181, 0)
            textLabel5.Size = UDim2.fromOffset(1, 32)
            textLabel5.Parent = button

            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Name = "imageLabel"
            imageLabel.Image = "http://www.roblox.com/asset/?id=9584292194"
            imageLabel.ImageColor3 = Color3.fromRGB(195, 195, 195)
            imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Position = UDim2.fromScale(0.943, 0.219)
            imageLabel.Size = UDim2.fromOffset(18, 18)
            imageLabel.Parent = button

            button.Parent = holder

            button.MouseEnter:Connect(function()
                game:GetService('TweenService'):Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(43,43,43)}):Play()
            end)

            button.MouseLeave:Connect(function()
                game:GetService('TweenService'):Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(38,38,38)}):Play()
            end)

            button.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        function ElementHandler:Slider(text, default, min, max, callback) -- slider stuff mainly not made by me
            text = text or "Slider"
            callback = callback or function() end

            local slider = Instance.new("TextButton")
            slider.Name = "slider"
            slider.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            slider.Size = UDim2.fromOffset(441, 32)
            slider.Text = ""
            slider.AutoButtonColor = false

            local uICorner4 = Instance.new("UICorner")
            uICorner4.Name = "uICorner4"
            uICorner4.CornerRadius = UDim.new(0, 6)
            uICorner4.Parent = slider

            local textLabel1 = Instance.new("TextLabel")
            textLabel1.Name = "textLabel1"
            textLabel1.Font = Enum.Font.Gotham
            textLabel1.Text = text
            textLabel1.TextColor3 = Color3.fromRGB(195, 195, 195)
            textLabel1.TextSize = 13
            textLabel1.TextStrokeColor3 = Color3.fromRGB(195, 195, 195)
            textLabel1.TextXAlignment = Enum.TextXAlignment.Left
            textLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textLabel1.BackgroundTransparency = 1
            textLabel1.Position = UDim2.fromScale(0.0181, 0)
            textLabel1.Size = UDim2.fromOffset(1, 32)
            textLabel1.Parent = slider

            local frame = Instance.new("Frame")
            frame.Name = "frame"
            frame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            frame.Position = UDim2.fromScale(0.753, 0.375)
            frame.Size = UDim2.fromOffset(102, 8)

            local uICorner5 = Instance.new("UICorner")
            uICorner5.Name = "uICorner5"
            uICorner5.CornerRadius = UDim.new(0, 3)
            uICorner5.Parent = frame

            local frame1 = Instance.new("Frame")
            frame1.Name = "frame1"
            frame1.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            frame1.Position = UDim2.fromScale(-0.00207, 0)
            frame1.Size = UDim2.fromOffset(44, 8)

            local uICorner6 = Instance.new("UICorner")
            uICorner6.Name = "uICorner6"
            uICorner6.CornerRadius = UDim.new(0, 3)
            uICorner6.Parent = frame1

            frame1.Parent = frame

            frame.Parent = slider

            local textLabel2 = Instance.new("TextLabel")
            textLabel2.Name = "textLabel2"
            textLabel2.Font = Enum.Font.Gotham
            textLabel2.Text = "7"
            textLabel2.TextColor3 = Color3.fromRGB(195, 195, 195)
            textLabel2.TextSize = 13
            textLabel2.TextStrokeColor3 = Color3.fromRGB(195, 195, 195)
            textLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Position = UDim2.fromScale(0.653, 0)
            textLabel2.Size = UDim2.fromOffset(44, 32)
            textLabel2.Parent = slider

            slider.Parent = holder
            textLabel2.Text = tostring(default)

            local hovered = false
            local down = false

            slider.MouseEnter:Connect(function()
                hovered = true
                game:GetService('TweenService'):Create(slider, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(43,43,43)}):Play()
            end)

            slider.MouseLeave:Connect(function()
                if not down then
                    game:GetService('TweenService'):Create(slider, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(38,38,38)}):Play()
                end
            end)
    
            game:GetService('UserInputService').InputEnded:connect(function(key)
                if key.UserInputType == Enum.UserInputType.MouseButton1 then
                    down = false
                    game:GetService('TweenService'):Create(slider, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(38,38,38)}):Play()
                end
            end)
    
            slider.MouseButton1Down:connect(function()
                game:GetService('TweenService'):Create(slider, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(47,47,47)}):Play()
                down = true
                while RunService.RenderStepped:wait() and down do
                    local percentage = math.clamp((Mouse.X - frame1.AbsolutePosition.X) / (frame1.AbsoluteSize.X), 0, 1)
                    local value = ((max - min) * percentage) + min
                    value = math.floor(value)
                    textLabel2.Text = value
                    local tween = game:GetService('TweenService'):Create(frame1, TweenInfo.new(0.06), {Size = UDim2.fromScale(percentage, 1)}):Play()
                    callback(value)
                end
            end)
        end

        function ElementHandler:Toggle(text, callback)
            text = text or "Toggle"
            callback = callback or function() end

            local toggle1 = Instance.new("TextButton")
            toggle1.Name = "toggle1"
            toggle1.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            toggle1.Size = UDim2.fromOffset(441, 32)
            toggle1.Text = ""
            toggle1.AutoButtonColor = false

            local uICorner9 = Instance.new("UICorner")
            uICorner9.Name = "uICorner9"
            uICorner9.CornerRadius = UDim.new(0, 6)
            uICorner9.Parent = toggle1

            local textLabel4 = Instance.new("TextLabel")
            textLabel4.Name = "textLabel4"
            textLabel4.Font = Enum.Font.Gotham
            textLabel4.Text = text
            textLabel4.TextColor3 = Color3.fromRGB(195, 195, 195)
            textLabel4.TextSize = 13
            textLabel4.TextStrokeColor3 = Color3.fromRGB(195, 195, 195)
            textLabel4.TextXAlignment = Enum.TextXAlignment.Left
            textLabel4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textLabel4.BackgroundTransparency = 1
            textLabel4.Position = UDim2.fromScale(0.0181, 0)
            textLabel4.Size = UDim2.fromOffset(1, 32)
            textLabel4.Parent = toggle1

            local frame3 = Instance.new("Frame")
            frame3.Name = "frame3"
            frame3.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            frame3.Position = UDim2.fromScale(0.943, 0.219)
            frame3.Size = UDim2.fromOffset(18, 18)

            local uICorner10 = Instance.new("UICorner")
            uICorner10.Name = "uICorner10"
            uICorner10.CornerRadius = UDim.new(0, 3)
            uICorner10.Parent = frame3

            local uIStroke1 = Instance.new("UIStroke")
            uIStroke1.Name = "uIStroke1"
            uIStroke1.Color = Color3.fromRGB(76, 76, 76)
            uIStroke1.Parent = frame3

            frame3.Parent = toggle1

            toggle1.Parent = holder

            local tog = false

            toggle1.MouseEnter:Connect(function()
                game:GetService('TweenService'):Create(toggle1, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(43,43,43)}):Play()
            end)

            toggle1.MouseLeave:Connect(function()
                game:GetService('TweenService'):Create(toggle1, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(38,38,38)}):Play()
            end)

            toggle1.MouseButton1Click:Connect(function()
                tog = not tog
                callback(tog)
                if tog then
                    game:GetService('TweenService'):Create(frame3, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(23, 143, 75)}):Play()
                    game:GetService('TweenService'):Create(uIStroke1, TweenInfo.new(0.2), {Color = Color3.fromRGB(32, 202, 106)}):Play()
                else
                    game:GetService('TweenService'):Create(frame3, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                    game:GetService('TweenService'):Create(uIStroke1, TweenInfo.new(0.2), {Color = Color3.fromRGB(76, 76, 76)}):Play()
                end
            end)
        end

        function ElementHandler:Textbox(text, callback)
            text = text or "Textbox"
            callback = callback or function() end

            local textbox = Instance.new("Frame")
            textbox.Name = "textbox"
            textbox.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            textbox.Size = UDim2.fromOffset(441, 32)

            local uICorner13 = Instance.new("UICorner")
            uICorner13.Name = "uICorner13"
            uICorner13.CornerRadius = UDim.new(0, 6)
            uICorner13.Parent = textbox

            local textLabel6 = Instance.new("TextLabel")
            textLabel6.Name = "textLabel6"
            textLabel6.Font = Enum.Font.Gotham
            textLabel6.Text = text
            textLabel6.TextColor3 = Color3.fromRGB(195, 195, 195)
            textLabel6.TextSize = 13
            textLabel6.TextStrokeColor3 = Color3.fromRGB(195, 195, 195)
            textLabel6.TextXAlignment = Enum.TextXAlignment.Left
            textLabel6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textLabel6.BackgroundTransparency = 1
            textLabel6.Position = UDim2.fromScale(0.0181, 0)
            textLabel6.Size = UDim2.fromOffset(1, 32)
            textLabel6.Parent = textbox

            local textBox = Instance.new("TextBox")
            textBox.Name = "textBox"
            textBox.Font = Enum.Font.SourceSans
            textBox.Text = ""
            textBox.TextColor3 = Color3.fromRGB(195, 195, 195)
            textBox.TextSize = 12
            textBox.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            textBox.Position = UDim2.fromScale(0.864, 0.188)
            textBox.Size = UDim2.fromOffset(52, 19)

            local uICorner14 = Instance.new("UICorner")
            uICorner14.Name = "uICorner14"
            uICorner14.CornerRadius = UDim.new(0, 6)
            uICorner14.Parent = textBox

            textBox.Parent = textbox
            textbox.Parent = holder

            textbox.MouseEnter:Connect(function()
                game:GetService('TweenService'):Create(textbox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(43,43,43)}):Play()
            end)

            textbox.MouseLeave:Connect(function()
                game:GetService('TweenService'):Create(textbox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(38,38,38)}):Play()
            end)

            textBox.FocusLost:Connect(function()
                callback(textBox.Text)
            end)
        end

        return ElementHandler
    end
    --// Drag - not by me
    main.MouseEnter:Connect(function()
        local Input = main.InputBegan:connect(function(Key)
            if Key.UserInputType == Enum.UserInputType.MouseButton1 then
                local ObjectPosition = Vector2.new(Mouse.X - main.AbsolutePosition.X, Mouse.Y - main.AbsolutePosition.Y)
                while RunService.RenderStepped:wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local FrameX, FrameY = math.clamp(Mouse.X - ObjectPosition.X, 0, dark_UI.AbsoluteSize.X - main.AbsoluteSize.X), math.clamp(Mouse.Y - ObjectPosition.Y, 0, dark_UI.AbsoluteSize.Y - main.AbsoluteSize.Y)
                    game:GetService('TweenService'):Create(main, TweenInfo.new(0.1), {Position = UDim2.fromOffset(FrameX + (main.Size.X.Offset * main.AnchorPoint.X), FrameY + (main.Size.Y.Offset * main.AnchorPoint.Y))}):Play()
                    game:GetService('TweenService'):Create(shadow, TweenInfo.new(0.1), {Position = UDim2.fromOffset(FrameX + (main.Size.X.Offset * main.AnchorPoint.X), FrameY + (main.Size.Y.Offset * main.AnchorPoint.Y))}):Play()
                end
            end
        end)
    end)

    --// Make the first tab visible
    game.CoreGui['dark_UI'].main.tabContainer.ChildAdded:Connect(function()
        game.CoreGui['dark_UI'].main:FindFirstChild('container').Visible = true
        pcall(function()
            repeat wait() until game.CoreGui['dark_UI'].main:FindFirstChild('tabContainer'):FindFirstChildWhichIsA('TextButton')
        end)
        game:GetService('TweenService'):Create(game.CoreGui['dark_UI'].main:FindFirstChild('tabContainer'):FindFirstChildWhichIsA('TextButton'), TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    end)

    spawn(function()
        if table.StartupSound.Toggle and table.StartupSound.SoundID ~= nil then
            local sound = Instance.new('Sound', game.CoreGui)
            sound.Name = "Startup Sound"
            sound.SoundId = "rbxassetid://6958727243"
            sound.Volume = 1.5
            sound.TimePosition = table.StartupSound.TimePosition
            sound:Play()
            sound.Stopped:Wait()
            sound:Destroy()
        end
    end)

    return tabHandler
end

return Library
