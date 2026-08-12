    --https://v3rmillion.net/member.php?action=profile&uid=1715331
    local Lib = {}
    if game.CoreGui:FindFirstChild("Lib") then
        game.CoreGui:FindFirstChild("Lib"):Destroy()
    end
    local ScreenGui = Instance.new("ScreenGui",game.CoreGui)
    ScreenGui.Name = "Lib"
    local roundDecimals = function(num, places)
        places = math.pow(10, places or 0)
        num = num * places
        if num >= 0 then 
            num = math.floor(num + 0.5) 
        else 
            num = math.ceil(num - 0.5) 
        end
        return num / places
    end
    local Usp = game:GetService("UserInputService")
    local visible = true
    local Usable = true
    if _G.HideKeybind == nil then
        _G.HideKeybind = Enum.KeyCode.RightControl
    end
    Usp.InputBegan:Connect(function(key)
        if key.KeyCode == _G.HideKeybind and Usable then
            Usable = false
    		for i,v in pairs(ScreenGui:GetChildren()) do
    		    spawn(function()
        		    if visible == true then
        			    v:TweenPosition(UDim2.new(0,v.AbsolutePosition.X,0,v.AbsolutePosition.Y - 500),Enum.EasingDirection.In,Enum.EasingStyle.Sine,0.5,true)
        			    wait(0.5)
        			    v.Visible = false
        			else
        			    v.Visible = true
        			    v:TweenPosition(UDim2.new(0,v.AbsolutePosition.X,0,v.AbsolutePosition.Y + 500),Enum.EasingDirection.In,Enum.EasingStyle.Sine,0.5,true)
        		    end
    		    end)
		        wait(0.05)
            end
            Usable = true
    		visible = not visible
    	end
    end)
    function Lib:CreateWindow(Name)
        local Window = {}

        local Main = Instance.new("ImageLabel")
        local glow = Instance.new("ImageLabel")
        local buttonHolder = Instance.new("Frame")
        local Corner = Instance.new("UICorner")
        local holder = Instance.new("Frame")
        local UIPadding = Instance.new("UIPadding")
        local UIListLayout = Instance.new("UIListLayout")
        local Title = Instance.new("Frame")
        local Title_2 = Instance.new("TextLabel")
        local Minimize = Instance.new("TextButton")
        local glow_2 = Instance.new("ImageLabel")

        Main.Name = "Main"
        Main.Parent = ScreenGui
        Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Main.BackgroundTransparency = 1.000
        Main.Position = UDim2.new(0, 15, 0, 15)
        Main.Size = UDim2.new(0, 150, 0, 206)
        Main.Image = "rbxassetid://3570695787"
        Main.ImageColor3 = Color3.fromRGB(35, 35, 35)
        Main.ScaleType = Enum.ScaleType.Slice
        Main.SliceCenter = Rect.new(100, 100, 100, 100)
        Main.SliceScale = 0.040
        Main.Name = "Main"
        Main.Parent = ScreenGui
        Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Main.BorderSizePixel = 0
        Main.Position = UDim2.new(0, #ScreenGui:GetChildren() * 170 - 155, 0, 15)
        Main.Size = UDim2.new(0, 150, 0, 25)

        glow.Name = "glow"
        glow.Parent = Main
        glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        glow.BackgroundTransparency = 1.000
        glow.BorderSizePixel = 0
        glow.Position = UDim2.new(0, -15, 0, -15)
        glow.Size = UDim2.new(1, 30, 1, 30)
        glow.Image = "rbxassetid://4905552912"
        glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        glow.ScaleType = Enum.ScaleType.Slice
        glow.SliceCenter = Rect.new(20, 20, 280, 280)

        buttonHolder.Name = "buttonHolder"
        buttonHolder.Parent = Main
        buttonHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        buttonHolder.BackgroundTransparency = 1.000
        buttonHolder.BorderSizePixel = 0
        buttonHolder.Position = UDim2.new(0, 0, 0, 25)
        buttonHolder.Size = UDim2.new(1, 0, 0, 200)

        holder.Name = "holder"
        holder.Parent = buttonHolder
        holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        holder.BackgroundTransparency = 1.000
        holder.Size = UDim2.new(1, 0, 1, 0)

        UIPadding.Parent = holder
        UIPadding.PaddingLeft = UDim.new(0, 5)

        UIListLayout.Parent = holder
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        Title.Name = "Title"
        Title.Parent = Main
        Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Title.BackgroundTransparency = 1.000
        Title.BorderSizePixel = 0
        Title.Size = UDim2.new(1, 0, 0, 25)
        Title.ZIndex = 2

        Title_2.Name = "Title"
        Title_2.Parent = Title
        Title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title_2.BackgroundTransparency = 1.000
        Title_2.Position = UDim2.new(0, 5, 0, 0)
        Title_2.Size = UDim2.new(1, -5, 1, 0)
        Title_2.ZIndex = 2
        Title_2.Font = Enum.Font.GothamBold
        Title_2.Text = Name
        Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title_2.TextSize = 15.000
        Title_2.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        Title_2.TextStrokeTransparency = 0.920
        Title_2.TextXAlignment = Enum.TextXAlignment.Left

        Minimize.Name = "Minimize"
        Minimize.Parent = Title
        Minimize.Active = false
        Minimize.AnchorPoint = Vector2.new(1, 0.5)
        Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Minimize.BackgroundTransparency = 1.000
        Minimize.Position = UDim2.new(1, 0, 0.5, 0)
        Minimize.Selectable = false
        Minimize.Size = UDim2.new(0, 25, 0, 25)
        Minimize.ZIndex = 2
        Minimize.Font = Enum.Font.GothamBold
        Minimize.Text = "-"
        Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
        Minimize.TextSize = 12.000
        Minimize.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        Minimize.TextStrokeTransparency = 0.920

        glow_2.Name = "glow"
        glow_2.Parent = Title
        glow_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        glow_2.BackgroundTransparency = 1.000
        glow_2.BorderSizePixel = 0
        glow_2.Position = UDim2.new(0, -15, 0, -15)
        glow_2.Size = UDim2.new(1, 30, 1, 30)
        glow_2.Image = "rbxassetid://4905552912"
        glow_2.ImageColor3 = Color3.fromRGB(0, 0, 0)
        glow_2.ScaleType = Enum.ScaleType.Slice
        glow_2.SliceCenter = Rect.new(20, 20, 280, 280)

        local CurrentSize = 25
        local Invis = {}
        MinimizeUsable = true;
        Minimize.MouseButton1Click:Connect(function()
            if MinimizeUsable == true then
                if Minimize.Text == "-" then
                    CurrentSize = Main.AbsoluteSize.Y
                    Minimize.Text = "+"
                    for i,v in pairs(holder:GetChildren()) do
                        if v:IsA("Frame") or v:IsA("ImageLabel") then
                            if v.Visible == true then
                                table.insert(Invis,i,v)
                                v.Visible = false
                            end
                        end
                    end
                    MinimizeUsable = false;
                    Main:TweenSize(UDim2.new(0, 150, 0, 25), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                    wait(0.2)
                    MinimizeUsable = true;
                else
                    Minimize.Text = "-"
                    MinimizeUsable = false;
                    Main:TweenSize(UDim2.new(0, 150, 0, CurrentSize), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                    wait(0.15)
                    for i,v in pairs(Invis) do
                        v.Visible = true
                    end
                    Invis = {}
                    wait(0.05)
                    MinimizeUsable = true;
                end
            end
        end)
        local function Update(Size,Part)
            Main.Size = Main.Size + UDim2.new(0,0,0,Size)
            for i,v in pairs(holder:GetChildren()) do
                if v:IsA("Frame") then
                    v.LayoutOrder = i - 2
                    v.Name = i - 2
                end
            end
        end
        
        local Player = game.Players.LocalPlayer
        local Mouse = Player:GetMouse()
        function AddDrag(frame1,frame2)
        	frame1.InputBegan:connect(function(inp)
        	    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        	        local inpPos = inp.Position
        	        repeat game:GetService("RunService").RenderStepped:wait()
        	            frame2:TweenPosition(UDim2.new(0,Mouse.X - frame1.AbsoluteSize.X/2,0,Mouse.Y-frame1.AbsoluteSize.Y + 15),'Out','Linear',0.08,true)
        	        until inp.UserInputState == Enum.UserInputState.End
        	    end
        	end)
        end
        AddDrag(Title_2,Main)
        
        function Window:Button(name, callback)
            local callback = callback or function() end
            local Button = Instance.new("Frame")
            local Text = Instance.new("TextButton")

            Button.Name = "Button"
            Button.Parent = holder
            Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundTransparency = 1.000
            Button.Size = UDim2.new(1, 0, 0, 25)

            Text.Name = "Text"
            Text.Parent = Button
            Text.Active = false
            Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text.BackgroundTransparency = 1.000
            Text.Selectable = false
            Text.Size = UDim2.new(1, 0, 1, 0)
            Text.Font = Enum.Font.GothamBold
            Text.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextSize = 12.000
            Text.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextStrokeTransparency = 0.920
            Text.TextXAlignment = Enum.TextXAlignment.Left
            Text.Text = name
            Text.MouseButton1Click:Connect(function()
                spawn(callback)
            end)
            Update(25)
        end
        
        function Window:Button2(name, options, callback)
            local callback = callback or function() end
            local flag = options.flag
            local location = options.location
            local default = options.default or false
            local Button = Instance.new("Frame")
            local Text = Instance.new("TextButton")

            Button.Name = "Button"
            Button.Parent = holder
            Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundTransparency = 1.000
            Button.Size = UDim2.new(1, 0, 0, 25)
            
            Text.Name = "Text"
            Text.Parent = Button
            Text.Active = false
            Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text.BackgroundTransparency = 1.000
            Text.Selectable = false
            Text.Size = UDim2.new(1, 0, 1, 0)
            Text.Font = Enum.Font.GothamBold
            Text.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextSize = 12.000
            Text.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextStrokeTransparency = 0.920
            Text.TextXAlignment = Enum.TextXAlignment.Left
            Text.Text = name
            location[flag] = Text
            if default ~= false then
                Text.TextColor3 = default
            end
            Text.MouseButton1Click:Connect(function()
                spawn(callback)
            end)
            Update(25)
        end

        function Window:Toggle(name, options, callback)
            local default = options.default or false
            local location = options.location or self.flags
            local flag = options.flag or ""
            local callback = callback or function() end
            if default == false then
                location[flag] = false
            else
                location[flag] = default
                spawn(callback)
            end

            local Toggle = Instance.new("Frame")
            local Holder = Instance.new("Frame")
            local toggle = Instance.new("TextButton")
            local Text_2 = Instance.new("TextButton")

            Toggle.Name = "Toggle"
            Toggle.Parent = holder
            Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.BackgroundTransparency = 1.000
            Toggle.Size = UDim2.new(1, 0, 0, 25)
            
            Holder.Name = "Holder"
            Holder.Parent = Toggle
            Holder.AnchorPoint = Vector2.new(1, 0.5)
            Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Holder.BackgroundTransparency = 1.000
            Holder.ClipsDescendants = true
            Holder.Position = UDim2.new(1, 0, 0.5, 0)
            Holder.Size = UDim2.new(0, 25, 0, 25)
            
            toggle.Name = "On"
            toggle.Parent = Holder
            toggle.Active = false
            toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggle.BackgroundTransparency = 1.000
            toggle.Selectable = false
            toggle.Size = UDim2.new(1, 0, 1, 0)
            toggle.Font = Enum.Font.GothamBold
            toggle.TextColor3 = Color3.fromRGB(0, 255, 0)
            toggle.TextSize = 12.000
            toggle.TextStrokeColor3 = Color3.fromRGB(0, 255, 0)
            toggle.TextStrokeTransparency = 0.920
            toggle.TextXAlignment = Enum.TextXAlignment.Left
            
            if default then
                toggle.Text = "On"
                toggle.TextColor3 = Color3.fromRGB(0,255,0)
                toggle.TextStrokeColor3 = Color3.fromRGB(0, 255, 0)
            else
                toggle.Text = "Off"
                toggle.TextColor3 = Color3.fromRGB(255,0,0)
                toggle.TextStrokeColor3 = Color3.fromRGB(255,0,0)
            end

            Text_2.Name = "Text"
            Text_2.Parent = Toggle
            Text_2.Active = false
            Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text_2.BackgroundTransparency = 1.000
            Text_2.Selectable = false
            Text_2.Size = UDim2.new(1, 0, 1, 0)
            Text_2.Font = Enum.Font.GothamBold
            Text_2.Text = name
            Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text_2.TextSize = 12.000
            Text_2.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Text_2.TextStrokeTransparency = 0.920
            Text_2.TextXAlignment = Enum.TextXAlignment.Left

            Text_2.MouseButton1Click:Connect(function()
                if toggle.Text == "On" then
                    toggle.Text = "Off"
                    location[flag] = false
                    toggle.TextColor3 = Color3.fromRGB(255,0,0)
                else
                    toggle.Text = "On"
                    location[flag] = true
                    toggle.TextColor3 = Color3.fromRGB(0,255,0)
                end
                spawn(callback)
            end)
            Update(25)
        end

        function Window:Slider(name, options, callback)
            local default = options.default or options.min
            local min = options.min or 0
            local max = options.max or 1
            local location = options.location or self.flags
            local precise = options.precise or false
            local flag = options.flag or ""
            local callback = callback or function() end

            local Slider = Instance.new("Frame")
            local Text = Instance.new("TextLabel")
            local sliderHolder = Instance.new("Frame")
            local Main2 = Instance.new("ImageLabel")
            local Fill = Instance.new("ImageLabel")
            local UISizeConstraint = Instance.new("UISizeConstraint")
            local Holder = Instance.new("Frame")
            local Text_6 = Instance.new("TextBox")
            
            Holder.Name = "Holder"
            Holder.Parent = Slider
            Holder.AnchorPoint = Vector2.new(1, 0)
            Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Holder.BackgroundTransparency = 1
            Holder.ClipsDescendants = true
            Holder.Position = UDim2.new(0.965517223, 0, 0.13333334, -2)
            Holder.Size = UDim2.new(0.694068968, 0, 0.466666669, 0)
            Holder.ZIndex = 10

            Text_6.Name = "Text"
            Text_6.Parent = Holder
            Text_6.Active = false
            Text_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text_6.BackgroundTransparency = 1
            Text_6.Position = UDim2.new(-0.0320001729, 0, 0.159999996, 0)
            Text_6.Selectable = false
            Text_6.Size = UDim2.new(1, 0, 1, 0)
            Text_6.Font = Enum.Font.GothamBold
            Text_6.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
            Text_6.PlaceholderText = "0"
            Text_6.Text = ""
            Text_6.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text_6.TextSize = 12.000
            Text_6.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Text_6.TextStrokeTransparency = 0.920
            Text_6.TextXAlignment = Enum.TextXAlignment.Right
            Text_6.FocusLost:Connect(function()
                if not tonumber(Text_6.Text) then
                    Text_6.Text = tonumber(location[flag])
                else
                    Text_6.Text = tonumber(Text_6.Text)
                    Fill.Size = UDim2.new(0,134/math.ceil(min +max) * tonumber(Text_6.Text),0,6)
                    location[flag] = tonumber(Text_6.Text)
                    spawn(callback)
                end
            end)

            Slider.Name = "Slider"
            Slider.Parent = holder
            Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Slider.BackgroundTransparency = 1.000
            Slider.Size = UDim2.new(1, 0, 0, 30)

            Text.Name = "Text"
            Text.Parent = Slider
            Text.Active = false
            Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text.BackgroundTransparency = 1.000
            Text.Position = UDim2.new(0, 0, 0, 2)
            Text.Selectable = false
            Text.Size = UDim2.new(1, 0, 0.5, 0)
            Text.Font = Enum.Font.GothamBold
            Text.Text = name
            Text.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextSize = 12
            Text.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextStrokeTransparency = 0.920
            Text.TextXAlignment = Enum.TextXAlignment.Left

            sliderHolder.Name = "sliderHolder"
            sliderHolder.Parent = Slider
            sliderHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderHolder.BackgroundTransparency = 1.000
            sliderHolder.Position = UDim2.new(0, -5, 0, 15)
            sliderHolder.Size = UDim2.new(1, 5, 0.5, 0)

            Main2.Name = "Main"
            Main2.Parent = sliderHolder
            Main2.AnchorPoint = Vector2.new(0.5, 0.5)
            Main2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Main2.BackgroundTransparency = 1.000
            Main2.Position = UDim2.new(0.5, 0, 0.5, 0)
            Main2.Size = UDim2.new(1, -10, 0, 6)
            Main2.Image = "rbxassetid://3570695787"
            Main2.ImageColor3 = Color3.fromRGB(45, 45, 45)
            Main2.ScaleType = Enum.ScaleType.Slice
            Main2.SliceCenter = Rect.new(100, 100, 100, 100)
            Main2.SliceScale = 0.120

            Fill.Name = "Fill"
            Fill.Parent = Main2
            Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Fill.BackgroundTransparency = 1.000
            Fill.Size = UDim2.new(0, 50, 0, 6)
            Fill.Image = "rbxassetid://3570695787"
            Fill.ScaleType = Enum.ScaleType.Slice
            Fill.SliceCenter = Rect.new(100, 100, 100, 100)
            Fill.SliceScale = 0.120

            UISizeConstraint.Parent = Fill
            UISizeConstraint.MaxSize = Vector2.new(140, 6)
            UISizeConstraint.MinSize = Vector2.new(6,6)

                location[flag] = default
                Text_6.Text = default
                Fill.Size = UDim2.new(0,134/(min +(max - min)) * default,0,6)

            local MouseDown = nil
            local function MakeChange()
                MouseDown = true 
                local Check
                spawn(function()
                    repeat game:GetService("RunService").RenderStepped:wait()
                        Fill.Size = UDim2.new(0,-(Fill.AbsolutePosition.X - game.Players.LocalPlayer:GetMouse().X - 3),0,6)
                    until MouseDown == false
                    Check:Disconnect()
                end)
                Check = Fill.Changed:Connect(function()
                    if precise then
                        location[flag] = min + math.ceil(((max - min)/134) * (Fill.AbsoluteSize.X - 6))
                        Text_6.Text = tostring(location[flag])
                    else
                        location[flag] = min + roundDecimals(((max - min)/134) * (Fill.AbsoluteSize.X - 6),2)
                        Text_6.Text = location[flag]
                    end
                    spawn(callback)
                    if MouseDown == false then
                        Check:Disconnect()
                    end
                end)
            end
            Fill.InputBegan:connect(function(inp)
                if inp.UserInputType.Value == 0 then 
                    MakeChange()
                end
            end)
            Fill.InputEnded:connect(function(inp)
                if inp.UserInputType.Value == 0 then 
                    MouseDown = false
                end
            end)
            local Player = game:GetService("Players").LocalPlayer
            local Mouse = Player:GetMouse()
            Mouse.Button1Up:Connect(function()
                MouseDown = false
            end)
            Update(30)
        end

        function Window:Dropdown(name, options, callback)
            local location   = options.location or self.flags
            local flag       = options.flag or ""
            local flag2      = options.flag2 or false
            local callback   = callback or function() end
            local PlayerList = options.PlayerList or false
            local Search = options.search or false
            local DropdownType = options.Dropdown or false
            if PlayerList then
                options.list = {}
                for a,b in pairs(game:GetService("Players"):GetChildren()) do
                    options.list[a] = b.Name;
                end
            elseif type(options.list) ~= "table" then
                options.list = options.list:GetChildren()
            end
            location[flag] = options.list[1]
            local Dropdown = Instance.new("Frame")
            local Text = Instance.new("TextButton")
            local Button = Instance.new("Frame")
            local TextButton = Instance.new("ImageLabel")
            local Frame = Instance.new("Frame")
            local TextBox = Instance.new("TextBox")
            local Frame_2 = Instance.new("Frame")
            local Holder = Instance.new("ImageLabel")
            local ScrollingFrame = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")

            local function FixCanvas()
                local Amount = 0
                for i,v in pairs(ScrollingFrame:GetChildren()) do
                    if v:IsA("TextButton") then
                        if v.Visible == true then
                            Amount = Amount + 1
                        end
                    end
                end
                ScrollingFrame.CanvasSize = UDim2.new(0,0,0,Amount * 20)
            end

            Dropdown.Name = "Dropdown"
            Dropdown.Parent = holder
            Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.BackgroundTransparency = 1.000
            Dropdown.Size = UDim2.new(1, 0, 0, 25)

            Update(25)
            
            local function Del(value)
                for i,v in pairs(ScrollingFrame:GetChildren()) do
                    if v:IsA("TextButton") then
                        v.Visible = value
                    end
                end
            end
            Text.Name = "Text"
            Text.Parent = Dropdown
            Text.Active = false
            Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text.BackgroundTransparency = 1.000
            Text.Selectable = false
            Text.Size = UDim2.new(1, 0, 1, 0)
            Text.Font = Enum.Font.GothamBold
            Text.Text = tostring(options.list[1])
            Text.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextSize = 12.000
            Text.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextStrokeTransparency = 0.920
            Text.TextXAlignment = Enum.TextXAlignment.Left

            DropDownUsable = true;
            Text.MouseButton1Click:Connect(function()
                if DropDownUsable == true then
                    if TextButton.Rotation == 0 then
                        TextButton.Rotation = 180
                        Frame.LayoutOrder = tonumber(Dropdown.Name)
                        Holder.LayoutOrder = tonumber(Dropdown.Name)
                        Holder.Visible = true
                        Frame.Visible = true
                        if Search then
                            TextBox.Visible = true
                        end
                        Holder.Size = UDim2.new(0, 140, 0, 1) 
                        DropDownUsable = false
                        Holder:TweenSize(UDim2.new(0, 140, 0, 100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                        Main:TweenSize(UDim2.new(0, 150, 0, Main.AbsoluteSize.Y + 100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                        wait(0.2)
                        DropDownUsable = true
                        Del(true)
                        if DropdownType == "Update" then
                            spawn(callback)
                        end
                        for i,v in pairs(options.list) do
                            local Text_2 = Instance.new("TextButton")
                            Text_2.Name = tostring(v)
                            Text_2.Parent = ScrollingFrame
                            Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            Text_2.BackgroundTransparency = 1.000
                            Text_2.Size = UDim2.new(0, 132, 0, 20)
                            Text_2.Font = Enum.Font.GothamBold
                            Text_2.Text = "  "..tostring(v)
                            Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
                            Text_2.TextSize = 12.000
                            Text_2.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
                            Text_2.TextStrokeTransparency = 0.920
                            Text_2.TextXAlignment = Enum.TextXAlignment.Left
                            Text_2.ZIndex = 3
                            Text_2.MouseButton1Click:Connect(function()
                                for i,v in pairs(Holder:GetChildren()) do
                                    if v:IsA("TextButton") and v ~= Text_2 then
                                        v.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
                                    elseif v:IsA("TextButton") and v == Text_2 then
                                        v.TextStrokeColor3 = Color3.fromRGB(200, 200, 200)
                                    end
                                end
                                location[flag] = v
                                Text.Text = tostring(location[flag])
                                if DropdownType ~= "Update" then
                                    spawn(callback)
                                end
                                Del(false)
                                if Search then
                                    TextBox.Visible = false
                                    TextBox.Text = ""
                                end
                                DropDownUsable = false;
                                Main:TweenSize(UDim2.new(0, 150, 0, Main.AbsoluteSize.Y - 100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                                Holder:TweenSize(UDim2.new(0, 140, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                                wait(0.2)
                                DropDownUsable = true;
                                TextButton.Rotation = 0
                                Holder.Visible = false
                                for i,v in pairs(ScrollingFrame:GetChildren()) do
                                    if v:IsA("TextButton") then
                                        v:Destroy()
                                    end
                                end
                                if PlayerList then
                                    options.list = {}
                                    for a,b in pairs(game:GetService("Players"):GetChildren()) do
                                        options.list[a] = b.Name
                                    end
                                end
                            end)
                            FixCanvas()
                        end
                    else
                        Del(false)
                        if Search then
                            TextBox.Visible = false
                            TextBox.Text = ""
                        end
                        DropDownUsable = false;
                        Main:TweenSize(UDim2.new(0, 150, 0, Main.AbsoluteSize.Y - 100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                        Holder:TweenSize(UDim2.new(0, 140, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                        ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
                        for i,v in pairs(ScrollingFrame:GetChildren()) do
                            if v:IsA("TextButton") then
                                v:Destroy()
                            end
                        end
                        wait(0.2)
                        DropDownUsable = true;
                        TextButton.Rotation = 0
                        Holder.Visible = false
                        if PlayerList then
                            options.list = {}
                            for a,b in pairs(game:GetService("Players"):GetChildren()) do
                                options.list[a] = b.Name
                            end
                        end
                    end
                end
            end)

            Button.Name = "Button"
            Button.Parent = Dropdown
            Button.AnchorPoint = Vector2.new(1, 0.5)
            Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundTransparency = 1.000
            Button.ClipsDescendants = true
            Button.Position = UDim2.new(1, 0, 0.5, 0)
            Button.Size = UDim2.new(0, 25, 0, 25)

            TextButton.Name = "TextButton"
            TextButton.Parent = Button
            TextButton.Active = true
            TextButton.AnchorPoint = Vector2.new(0, 0.5)
            TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.BackgroundTransparency = 1.000
            TextButton.BorderColor3 = Color3.fromRGB(35, 35, 35)
            TextButton.Position = UDim2.new(0, 0, 0.5, 0)
            TextButton.Selectable = true
            TextButton.Size = UDim2.new(1, -5, 1, -5)
            TextButton.ZIndex = 2
            TextButton.Image = "http://www.roblox.com/asset/?id=5585095509"

            Holder.Name = "Holder"
            Holder.Parent = holder
            Holder.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
            Holder.Visible = false
            Holder.Position = UDim2.new(0, 0,0, 22)
            Holder.Size = UDim2.new(0, 140, 0, 1)
            Holder.ZIndex = 3
            Holder.BorderSizePixel = 0

            ScrollingFrame.Parent = Holder
            ScrollingFrame.Active = true
            ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ScrollingFrame.BackgroundTransparency = 1.000
            ScrollingFrame.BorderSizePixel = 0
            ScrollingFrame.Size = UDim2.new(0, 137, 0, 100)
            ScrollingFrame.ScrollBarThickness = 4
            ScrollingFrame.ZIndex = 3
            ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)

            UIListLayout.Parent = ScrollingFrame
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            TextBox.Parent = Text
            TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            TextBox.BackgroundTransparency = 0
            TextBox.Position = UDim2.new(0, 0, 0, 0)
            TextBox.Size = UDim2.new(1,-25,1,0)
            TextBox.Font = Enum.Font.GothamBold
            TextBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
            TextBox.PlaceholderText = name.."..."
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 12.000
            TextBox.TextStrokeTransparency = 0.920
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.Visible = false
            TextBox.BorderSizePixel = 0
            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                for i,v in pairs(ScrollingFrame:GetChildren()) do
                    if v:IsA("TextButton") then
                        if string.match(v.Text:lower(),TextBox.Text:lower()) then
                            v.Visible = true
                            FixCanvas()
                        else
                            v.Visible = false
                            FixCanvas()
                        end
                    end
                end
            end)
        end
        function Window:Bind(name, options, callback)
            local location     = options.location or self.flags
            local flag         = options.flag or ""
            local callback     = callback or function() end
            local default      = options.default or false

            location[flag]     = default

            local Hotkey = Instance.new("Frame")
            local Key = Instance.new("TextButton")
            local Text_4 = Instance.new("TextButton")

            Hotkey.Name = "Hotkey"
            Hotkey.Parent = holder
            Hotkey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Hotkey.BackgroundTransparency = 1.000
            Hotkey.Size = UDim2.new(1, 0, 0, 25)
            
            Key.Name = "Key"
            Key.Parent = Hotkey
            Key.Active = false
            Key.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Key.BackgroundTransparency = 1.000
            Key.Position = UDim2.new(0.420689642, 0, 0, 0)
            Key.Selectable = false
            Key.Size = UDim2.new(0.524137914, 0, 1, 0)
            Key.Font = Enum.Font.GothamBold
            Key.Text = "F"
            Key.TextColor3 = Color3.fromRGB(255, 255, 255)
            Key.TextSize = 12.000
            Key.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Key.TextStrokeTransparency = 0.920
            Key.TextXAlignment = Enum.TextXAlignment.Right

            if default ~= false then
                Key.Text = string.sub(tostring(default),14,999)
            end

            Text_4.Name = "Text"
            Text_4.Parent = Hotkey
            Text_4.Active = false
            Text_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text_4.BackgroundTransparency = 1.000
            Text_4.Selectable = false
            Text_4.Size = UDim2.new(1, 0, 1, 0)
            Text_4.Font = Enum.Font.GothamBold
            Text_4.Text = name
            Text_4.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text_4.TextSize = 12.000
            Text_4.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Text_4.TextStrokeTransparency = 0.920
            Text_4.TextXAlignment = Enum.TextXAlignment.Left

            local Player = game:GetService("Players").LocalPlayer
            local Mouse = Player:GetMouse()
            local Usable = true
            local Paterns = {{"Right","R"},{"Left","L"},{"Control","Ctrl"}}
            local function CheckName(key)
                local Name = string.sub(tostring(key.KeyCode),14,999)
                for i,v in pairs(Paterns) do
                    Name = string.gsub(Name,v[1],v[2])
                end
                return Name
            end
            Check = game:GetService("UserInputService").InputBegan:Connect(function(key)
                if Usable == true and not game:GetService("UserInputService"):GetFocusedTextBox() then
                    if key.KeyCode == location[flag] then
                        spawn(callback)
                    end
                    if not Hotkey:IsDescendantOf(game) then
                        Check:Disconnect()
                    end
                end
            end)

            Text_4.MouseButton1Click:Connect(function()
                Key.Text = "..."
                Usable = false
                Check = game:GetService("UserInputService").InputBegan:Connect(function(key)
                    if key.KeyCode ~= Enum.KeyCode.Unknown and not game:GetService("UserInputService"):GetFocusedTextBox() and key.KeyCode ~= Enum.KeyCode.Escape then
                        Key.Text = CheckName(key)
                        location[flag] = key.KeyCode
                        Check:Disconnect() 
                        wait(0.1)
                        Usable = true
                    elseif key.KeyCode == Enum.KeyCode.Escape then
                        Key.Text = "nil"
                        location[flag] = nil
                        Check:Disconnect() 
                        wait(0.1)
                        Usable = true
                    end
                end)
            end)

            Update(25)
        end

        function Window:Box(name, options, callback)
            local type = options.type or "" or false
            local default = options.default or false
            local hold = options.hold or false
            local location = options.location or self.flags;
            local flag = options.flag or "";
            local callback = callback or function() end;

            local TextBox = Instance.new("Frame")
            local TextLabel = Instance.new("TextLabel")
            local TextBox_2 = Instance.new("TextBox")
            local Frame = Instance.new("Frame")

            TextBox.Name = "TextBox"
            TextBox.Parent = holder
            TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.BackgroundTransparency = 1.000
            TextBox.Size = UDim2.new(1, 0, 0, 25)

            TextLabel.Parent = TextBox
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Size = UDim2.new(0, 79, 1, 0)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.Text = name
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 12.000
            TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextStrokeTransparency = 0.920
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            TextBox_2.Parent = TextBox
            TextBox_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox_2.BackgroundTransparency = 1.000
            TextBox_2.BorderSizePixel = 0
            TextBox_2.Position = UDim2.new(0.420689642, 0, 0, 0)
            TextBox_2.Size = UDim2.new(0, 76, 0, 25)
            TextBox_2.Font = Enum.Font.GothamBold
            TextBox_2.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
            TextBox_2.Text = ""
            TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox_2.TextSize = 12.000
            TextBox_2.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            TextBox_2.TextStrokeTransparency = 0.920
            TextBox_2.TextXAlignment = Enum.TextXAlignment.Left

            if hold ~= false then
                TextBox_2.PlaceholderText = hold.."...";
            else
                TextBox_2.PlaceholderText = "Text...";
            end
            
            if default ~= false then
                TextBox_2.Text = default;
				location[flag] = default;
            end
            
            TextBox_2:GetPropertyChangedSignal("Text"):Connect(function()
                if not tonumber(TextBox_2.Text) and type == "number" then
                    TextBox_2.Text = TextBox_2.Text:gsub("%D+", "")
                end
            end)
            
            Frame.Parent = TextBox
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BorderSizePixel = 0
            Frame.Position = UDim2.new(0.420689642, 0, 0.75999999, 0)
            Frame.Size = UDim2.new(0, 78, 0, 1)
            
            TextBox_2.FocusLost:Connect(function()
                location[flag] = TextBox_2.Text
                spawn(callback)
            end)

            Update(25)
        end

        function Window:Search(options)
            Color = options or false

            if Color == false then
                Color = Color3.fromRGB(255,255,0)
            end

            local Search = Instance.new("Frame")
            local Text = Instance.new("TextBox")
            local Holder = Instance.new("Frame")
            local TextButton = Instance.new("ImageLabel")

            Search.Name = "Search"
            Search.Parent = holder
            Search.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Search.BackgroundTransparency = 1.000
            Search.Size = UDim2.new(1, 0, 0, 25)
            
            Text.Name = "Text"
            Text.Parent = Search
            Text.Active = false
            Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text.BackgroundTransparency = 1.000
            Text.Selectable = false
            Text.Size = UDim2.new(1, 0, 1, 0)
            Text.Font = Enum.Font.GothamBold
            Text.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
            Text.PlaceholderText = "Search"
            Text.Text = ""
            Text.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextSize = 12.000
            Text.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextStrokeTransparency = 0.920
            Text.TextXAlignment = Enum.TextXAlignment.Left

            Holder.Name = "Holder"
            Holder.Parent = Search
            Holder.AnchorPoint = Vector2.new(1, 0.5)
            Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Holder.BackgroundTransparency = 1.000
            Holder.ClipsDescendants = true
            Holder.Position = UDim2.new(1, 0, 0.5, 0)
            Holder.Size = UDim2.new(0, 25, 0, 25)

            TextButton.Name = "TextButton"
            TextButton.Parent = Holder
            TextButton.Active = true
            TextButton.AnchorPoint = Vector2.new(0, 0.5)
            TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.BackgroundTransparency = 1.000
            TextButton.BorderColor3 = Color3.fromRGB(35, 35, 35)
            TextButton.Position = UDim2.new(0, 0, 0.5, 0)
            TextButton.Selectable = true
            TextButton.Size = UDim2.new(1, -8, 1, -8)
            TextButton.ZIndex = 2
            TextButton.Image = "http://www.roblox.com/asset/?id=5585103223"

            Text:GetPropertyChangedSignal("Text"):Connect(function()
                for i,v in pairs(ScreenGui:GetDescendants()) do
                    if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("TextBox") then
                        if string.match(v.Text:lower(),Text.Text:lower()) and v ~= Text and Text.Text ~= "" and Text.Text ~= " " and v.Text ~= "Off" and v.Text ~= "On" then
                            v.TextColor3 = Color
                        elseif v.Text ~= "Off" and v.Text ~= "On" then
                            v.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
            end)
            Text.Focused:Connect(function()
                Text.TextColor3 = Color3.fromRGB(255,255,255)
            end)
            Text.FocusLost:Connect(function()
                Text.TextColor3 = Color3.fromRGB(200,200,200)
                for i,v in pairs(ScreenGui:GetDescendants()) do
                    if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("TextBox") then
                        if v ~= Text and Text.Text ~= "" and Text.Text ~= " " and v.Text ~= "Off" and v.Text ~= "On" then
                            v.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
            end)

            Update(25)
        end
        function Window:Section(text)
            local Title = Instance.new("Frame")
            local Title_2 = Instance.new("TextLabel")
            local minimize = Instance.new("TextButton")
            local glow = Instance.new("ImageLabel")
            
            Title.Name = "Title"
            Title.Parent = holder
            Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Title.BackgroundTransparency = 1.000
            Title.BorderSizePixel = 0
            Title.Size = UDim2.new(1, 0, 0, 25)
            Title.ZIndex = 2
            
            Title_2.Name = "Title"
            Title_2.Parent = Title
            Title_2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Title_2.BackgroundTransparency = 0
            Title_2.Position = UDim2.new(0, -5, 0, 0)
            Title_2.Size = UDim2.new(1, 5, 1, 0)
            Title_2.ZIndex = 2
            Title_2.Font = Enum.Font.GothamBold
            Title_2.Text = " "..text
            Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_2.TextSize = 13.000
            Title_2.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Title_2.TextStrokeTransparency = 0.920
            Title_2.TextXAlignment = Enum.TextXAlignment.Left
            Title_2.BorderSizePixel = 0
            
            minimize.Name = "Minimize"
            minimize.Parent = Title
            minimize.Active = false
            minimize.AnchorPoint = Vector2.new(1, 0.5)
            minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            minimize.BackgroundTransparency = 1.000
            minimize.Position = UDim2.new(1, 0, 0.5, 0)
            minimize.Selectable = false
            minimize.Size = UDim2.new(0, 25, 0, 25)
            minimize.ZIndex = 3
            minimize.Font = Enum.Font.GothamBold
            minimize.Text = "-"
            minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
            minimize.TextSize = 12.000
            minimize.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            minimize.TextStrokeTransparency = 0.920
            
            glow.Name = "glow"
            glow.Parent = Title_2
            glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            glow.BackgroundTransparency = 1.000
            glow.BorderSizePixel = 0
            glow.Position = UDim2.new(0, -15, 0, -15)
            glow.Size = UDim2.new(1, 30, 1, 30)
            glow.Image = "rbxassetid://4905552912"
            glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            glow.ScaleType = Enum.ScaleType.Slice
            glow.SliceCenter = Rect.new(20, 20, 280, 280)

            local CurrentSize = 25
            local function Visible(value)
                for i,v in pairs(holder:GetChildren()) do
                    if v:IsA("Frame") or v:IsA("ImageLabel") then
                        if tonumber(v.Name) then
                            if tonumber(v.Name) > tonumber(Title.Name) and not v:FindFirstChild("Title") and v ~= Title then
                                v.Visible = value
                            elseif v:FindFirstChild("Title") and v ~= Title and tonumber(v.Name) > tonumber(Title.Name) then
                                return
                            end
                        end
                    end
                end
            end
            local function GetNumbers()
                local Number = 0
                for i,v in pairs(holder:GetChildren()) do
                    if v:IsA("Frame") or v:IsA("ImageLabel") then
                        if tonumber(v.Name) then
                            if tonumber(v.Name) > tonumber(Title.Name) and not v:FindFirstChild("Title") and v ~= Title then
                                if v:FindFirstChild("sliderHolder") then
                                    Number = Number + 30
                                else
                                    Number = Number + 25
                                end
                            elseif v:FindFirstChild("Title") and v ~= Title and tonumber(v.Name) > tonumber(Title.Name) then
                                return Number
                            end
                        end
                    end
                end
                return Number
            end
            local function CreateAnimation(Numbers)
                local Frame = Instance.new("Frame",holder)
                Frame.LayoutOrder = tonumber(Title.Name)
                Frame.Size = UDim2.new(0,140,0,Numbers)
                Frame.BackgroundTransparency = 1.000
                return Frame
            end
            Minimize2Usable = true;
            minimize.MouseButton1Click:Connect(function()
                local Numbers = GetNumbers()
                if Minimize2Usable == true then
                    if minimize.Text == "-" then
                        minimize.Text = "+"
                        Visible(false)
                        local Frame = CreateAnimation(Numbers)
                        Minimize2Usable = false;
                        Frame:TweenSize(UDim2.new(0, 150, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                        Main:TweenSize(UDim2.new(0, 150, 0, Main.AbsoluteSize.Y - Numbers), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                        wait(0.2)
                        Minimize2Usable = true;
                        Frame:Destroy()
                    else
                        minimize.Text = "-"
                        local Frame = CreateAnimation(0)
                        Minimize2Usable = false;
                        Frame:TweenSize(UDim2.new(0, 150, 0, Numbers), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                        Main:TweenSize(UDim2.new(0, 150, 0,Main.AbsoluteSize.Y + Numbers), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                        wait(0.2)
                        Minimize2Usable = true;
                        Frame:Destroy()
                        Visible(true)
                    end
                end
            end)
            Update(25)
        end
        function Window:Label(text)
            local Frame = Instance.new("Frame")
            local TextLabel = Instance.new("TextLabel")
            local Frame_2 = Instance.new("Frame")

            Frame.Parent = holder
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BackgroundTransparency = 1.000
            Frame.Size = UDim2.new(1, 0, 0, 25)

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 12.000
            TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextStrokeTransparency = 0.920
            TextLabel.Text = text

            Frame_2.Parent = Frame
            Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame_2.BorderSizePixel = 0
            Frame_2.Position = UDim2.new(0.303000003, 0, 0.800000012, 0)
            Frame_2.Size = UDim2.new(0, 57, 0, 1)

            Update(25)
        end
        return Window
    end
    return Lib 
