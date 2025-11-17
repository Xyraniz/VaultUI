local function initLibrary()
    local library = {flags = {}, callbacks = {}, rainbowI = 0};

    local GetService = game.GetService;
    local Players = GetService(game, "Players");
    local RunService = GetService(game, "RunService");
    local CoreGui = GetService(game, "CoreGui");
    local TweenService = GetService(game, "TweenService");
    local UserInputService = GetService(game, "UserInputService");

    local LocalPlayer = Players.LocalPlayer;

    do -- library funcs
        coroutine.wrap(function()
            while true do
                for i = 0, 359 do
                    library.rainbowI = i / 359;
                    library.rainbowVal = Color3.fromHSV(i / 359, 1, 1);
                    wait();
                end;
            end;
        end)();

        function library:Create(class, data)
            local obj = Instance.new(class);
            for i, v in next, data do
                if i ~= 'Parent' then
                    if typeof(v) == "Instance" then
                        v.Parent = obj;
                    else
                        obj[i] = v
                    end
                end
            end

            obj.Parent = data.Parent;
            return obj;
        end;

        function library:Dragger(main, second)
            local dragging;
            local dragInput;
            local dragStart;
            local startPos;

            local function update(input)
                local delta = input.Position - dragStart;
                second:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y),'Out','Sine',0.01,true);
            end;

            main.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true;
                    dragStart = input.Position;
                    startPos = second.Position;

                    repeat wait() until input.UserInputState == Enum.UserInputState.End;
                    dragging = false;
                end;
            end);

            main.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    dragInput = input;
                end;
            end);

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    update(input);
                end;
            end);
        end;

        function library:Tween(instance, properties, callback)
            local callback = callback or function() end;
            local time = properties.time;
            properties.time = nil;
            local anim = TweenService:Create(instance, TweenInfo.new(time), properties);

            anim.Completed:Connect(callback);
            anim:Play();
            return anim;
        end;

        local ui_Settings = {
            mainColor = Color3.fromRGB(36, 36, 36);
            bottomColor = Color3.fromRGB(34, 34, 34);
            borderColor = Color3.fromRGB(42, 42, 42);
            scrollingBarColor = Color3.fromRGB(115, 41, 255);
            toggleColor = Color3.fromRGB(34, 34, 34);
            toggleBorderColor = Color3.fromRGB(102, 41, 255);
            boxColor = Color3.fromRGB(32, 32, 32);
            boxBorderColor = Color3.fromRGB(102, 41, 255);
            gradientColorSection = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 41, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(122, 41, 255))};
            gradientColor = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 41, 255)), ColorSequenceKeypoint.new(0, Color3.fromRGB(142, 61, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 74, 255))};
            shadowGradientColor = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 36, 36))};
        };

        UserInputService.InputBegan:Connect(function(input)
            for i, v in next, library.flags do
                if(v == input.KeyCode) then
                    library.callbacks[i]();
                elseif(v == input.UserInputType) then
                    library.callbacks[i]();
                end;
            end;
        end);

        local gui = Instance.new("ScreenGui", CoreGui);
        gui.Enabled = false;
        library.gui = gui;

        local main = library:Create("Frame", {
            Name = "main";
            Parent = gui;
            Position = UDim2.new(0.5, -200, 0.5, -135);
            BorderSizePixel = 0;
            BackgroundColor3 = ui_Settings.mainColor; -- main color
            Size = UDim2.new(0, 400,0, 270);
            library:Create("ImageLabel", {
                Name = "Search";
                BackgroundTransparency = 1.000;
                Position = UDim2.new(0, 4, 0, 46);
                Size = UDim2.new(1, -8, 0, 26);
                Image = "rbxassetid://4641155515";
                ImageColor3 = Color3.fromRGB(30, 30, 30);
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(4, 4, 296, 296);
                library:Create("TextBox", {
                    Name = "textbox";
                    BackgroundTransparency = 1.000;
                    Position = UDim2.new(1, -362, 0, 0);
                    Size = UDim2.new(1, -30, 1, 0);
                    Font = Enum.Font.Gotham;
                    PlaceholderText = "Search";
                    Text = "";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });
                library:Create("ImageLabel", {
                    Name = "icon";
                    BackgroundTransparency = 1.000;
                    Position = UDim2.new(0, 2, 0, 1);
                    Size = UDim2.new(0, 24, 0, 24);
                    Image = "http://www.roblox.com/asset/?id=4645651350";
                    library:Create("UIGradient", {
                        Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 133, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 74, 255))};
                        Rotation = 45;
                    });
                });
            });
            library:Create("Frame", {
                Name = "border";
                BackgroundColor3 = ui_Settings.bottomColor;
                BorderColor3 = ui_Settings.borderColor;
                BorderSizePixel = 1;
                Position = UDim2.new(0, 5, 0, 78);
                Size = UDim2.new(0, 390, 0, 186);
                library:Create("Frame", {
                    Name = "shadow";
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 0.100;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 1, -8);
                    Size = UDim2.new(1, 0, 0, 8);
                    library:Create("UIGradient", {
                        Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 36, 36))};
                        Rotation = 270;
                        Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)};
                    });
                });
                library:Create("Frame", {
                    Name = "shadow";
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 0.100;
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 0, 8);
                    library:Create("UIGradient", {
                        Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 36, 36))};
                        Rotation = 90;
                        Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)};
                    });
                });
            });
            library:Create("Frame", {
                Name = "bar";
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255); -- bar color
                Size = UDim2.new(1, 0,0, 4);
                Position = UDim2.new(0, 0, 0, 0);
                library:Create("UIGradient", {
                    Color = ui_Settings.gradientColor;
                });
                library:Create("Frame", {
                    Name = "bottom";
                    BorderSizePixel = 0;
                    BackgroundColor3 = ui_Settings.bottomColor;
                    Position = UDim2.new(0, 0, 0, 4);
                    Size = UDim2.new(1, 0, 0, 34);
                    library:Create("Frame", {
                        BackgroundTransparency = 0.1;
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BorderSizePixel = 0;
                        Name = "shadow";
                        Position = UDim2.new(0, 0, 1, 0);
                    });
                    library:Create("TextLabel", {
                        Name = "Title";
                        BackgroundTransparency = 1;
                        Position = UDim2.new(0, 10, 0.5, -10);
                        Size = UDim2.new(0, 70, 0, 24);
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        Text = "Gamer Lib";
                        Font = "GothamSemibold";
                        TextSize = 14;
                        library:Create("UIGradient", {
                            Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 133, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 74, 255))}
                        });
                    });
                    library:Create("Frame", {
                        Name = "topcontainer";
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        Position = UDim2.new(0, 88, 0, 9);
                        Size = UDim2.new(1, -90, 0.73, 0);
                        library:Create("UIListLayout", {
                            Padding = UDim.new(0, 2);
                            FillDirection = "Horizontal";
                            HorizontalAlignment = "Left";
                            SortOrder = "LayoutOrder";
                            VerticalAlignment = "Top";
                        });
                    });
                });
            });
        });

        local modal = Instance.new("TextButton", main);
        modal.Modal = true;
        modal.BackgroundTransparency = 1;
        modal.Text = "";

        main.Search.textbox.Changed:Connect(function()
            local Entry = main.Search.textbox.Text:lower();

            if(Entry ~= "") then
                for i,v in next, library.currentSection:GetChildren() do
                    if(not v:IsA("UIPadding") and not v:IsA("UIListLayout")) then
                        local label = v:FindFirstChild("label");
                        local button = v:FindFirstChild("button");

                        local find = false;
                        if(label and label.Text:gsub("%s", ""):lower():sub(1, #Entry) == Entry) then
                            v.Visible = true;
                            find = true;
                        end;

                        if(button and button:FindFirstChild("label") and button.label.Text:gsub("%s", ""):lower():sub(1, #Entry) == Entry) then
                            v.Visible = true;
                            find = true;
                        end;

                        if(not find) then
                            v.Visible = false;
                        end;
                    end;
                end;
            elseif library.currentSection then
                for i,v in next, library.currentSection:GetChildren() do
                    if(not v:IsA("UIPadding") and not v:IsA("UIListLayout")) then
                        v.Visible = true;
                    end;
                end;
            end;

            library.currentSectionObject:Update();
        end);

        library:Dragger(main.bar.bottom, main);
        function library:Ready()
            gui.Enabled = true;
        end;

        function library:CreateSection(name)
            local topContainer = gui.main.bar.bottom.topcontainer;

            local sectionSelector = library:Create("ImageButton", {
                Parent = topContainer;
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 60, 1, 0);
                Image = "rbxassetid://4641155773";
                ImageColor3 = Color3.fromRGB(255, 255, 255);
                ScaleType = "Slice";
                SliceCenter = Rect.new(4, 4, 296, 296);
                SliceScale = 1;
                Name = "back";
                library:Create("UIGradient", {
                    Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 41, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(132, 41, 255))}
                });
                library:Create("TextLabel", {
                    BackgroundTransparency = 1;
                    Text = name;
                    Size = UDim2.new(1, 0, 1, 0);
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                });
            });

            local boxContainer = library:Create("ScrollingFrame", {
                Name = "box";
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(34, 34, 34);
                Parent = main.border;
                Position = UDim2.new(0, 1, 0, 1);
                Size = UDim2.new(1, -2, 1, -2);
                BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
                TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
                ScrollBarThickness = 4;
                CanvasSize = UDim2.new(0, 0, 0, 0);
                library:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 2);
                    PaddingLeft = UDim.new(0, 2);
                });
                library:Create("UIListLayout", {
                    Padding = UDim.new(0, 5);
                    FillDirection = "Vertical";
                    HorizontalAlignment = "Left";
                    VerticalAlignment = "Top";
                });
            });

            local section = {};

            boxContainer.ChildAdded:Connect(function(Obj)
                section:Update();
            end);

            if(not library.currentSection) then
                library.currentSectionSelector = sectionSelector;
                library.currentSection = boxContainer;
                library.currentSectionObject = section;

                library.currentSectionSelector.ImageColor3 = Color3.fromRGB(150, 150, 150);
                boxContainer.Visible = true;
            else
                boxContainer.Visible = false;
            end;

            sectionSelector.MouseButton1Click:Connect(function()
                if(library.currentSection) then
                    library.currentSectionSelector.ImageColor3 = Color3.fromRGB(255, 255, 255);
                    library.currentSection.Visible = false;
                end;

                sectionSelector.ImageColor3 = Color3.fromRGB(150, 150, 150);
                boxContainer.Visible = true;
                library.currentSectionSelector = sectionSelector;
                library.currentSection = boxContainer;
            end);

            function section:Update()
                local CanvasSize = UDim2.new(0, 0, 0, 85)
                for i,v in next, boxContainer:GetChildren() do
                    if(not v:IsA("UIListLayout") and not v:IsA("UIPadding") and v.Visible) then
                        CanvasSize = CanvasSize + UDim2.new(0, 0, 0, v.AbsoluteSize.Y + 5);
                    end;
                end;

                library:Tween(boxContainer, {time = 0.1, CanvasSize = CanvasSize});
            end;

            function section:Label(labelName)
                local holder = library:Create("Frame", {
                    Name = "holder";
                    Parent = boxContainer;
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 0, 350);
                    Size = UDim2.new(1, 0, 0, 18);
                    library:Create("TextLabel", {
                        Name = "label";
                        BackgroundTransparency = 1.000;
                        Size = UDim2.new(1, 0, 1, 0);
                        Font = "Gotham";
                        Text = labelName;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 12.000;
                    });
                });
            end;

            function section:Toggle(toggleName, callback)
                local callback = callback or function() end;
                local toggle = false;

                library.flags[toggleName] = toggle;

                local holder = library:Create("Frame", {
                    BackgroundTransparency = 1;
                    Parent = boxContainer;
                    Size = UDim2.new(1, -20, 0, 18);
                    Name = "holder";
                    library:Create("TextLabel", {
                        Name = "label";
                        BackgroundTransparency = 1;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        Position = UDim2.new(0, 22, 0, 0);
                        Size = UDim2.new(1, -22, 1, 0);
                        Font = "Gotham";
                        TextXAlignment = "Left";
                        TextSize = 12;
                        Text = toggleName;
                    });
                    library:Create("TextButton", {
                        Name = "toggle";
                        AutoButtonColor = false;
                        BackgroundColor3 = ui_Settings.toggleColor;
                        BorderColor3 = ui_Settings.toggleBorderColor;
                        BorderSizePixel = 1;
                        Size = UDim2.new(0, 16, 0, 16);
                        Text = "";
                        library:Create("Frame", {
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                            Size = toggle and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 0, 0);
                            Name = "fill";
                            BorderSizePixel = 0;
                            library:Create("UIGradient", {
                                Color = ui_Settings.gradientColorSection;
                                Rotation = 45;
                            });
                        });
                        library:Create("UIListLayout", {
                            FillDirection = "Vertical";
                            HorizontalAlignment = "Center";
                            VerticalAlignment = "Center";
                        });
                        library:Create("UIPadding", {
                            PaddingBottom = UDim.new(0, 1);
                            PaddingTop = UDim.new(0, 1);
                            PaddingLeft = UDim.new(0, 1);
                            PaddingRight = UDim.new(0, 1);
                        });
                    });
                });

                local function onClick()
                    toggle = not toggle;
                    library:Tween(holder.toggle.fill, {time = 0.1, Size = toggle and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 0, 0)});
                    library.flags[toggleName] = toggle;
                    callback(toggle);
                end;

                holder.toggle.MouseButton1Click:Connect(onClick);
                return holder;
            end;

            function section:Box(boxName, callback)
                local holder = library:Create("Frame", {
                    Size = UDim2.new(1, -20, 0, 18);
                    BackgroundTransparency = 1;
                    Name = "holder";
                    Parent = boxContainer;
                    library:Create("TextLabel", {
                        BackgroundTransparency = 1;
                        Name = "label";
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        Text = boxName;
                        TextSize = 12;
                        Font = "Gotham";
                        Size = UDim2.new(1, 0, 1, 0);
                        TextXAlignment = "Left";
                    });
                    library:Create("TextBox", {
                        BackgroundColor3 = Color3.fromRGB(32, 32, 32);
                        BorderColor3 = ui_Settings.boxBorderColor;
                        BorderSizePixel = 1;
                        Name = "textbox";
                        TextSize = 14;
                        Position = UDim2.new(1, -160, 0, 0);
                        Size = UDim2.new(0, 160, 1, 0);
                        PlaceholderColor3 = Color3.fromRGB(200, 200, 200);
                        PlaceholderText = "Value";
                        Text = "";
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        Font = "SourceSans";
                    });
                });

                holder.textbox.FocusLost:Connect(function(Enter)
                    if(Enter) then
                        library.flags[boxName] = holder.textbox.Text;
                        callback(holder.textbox.Text);
                    end;
                end);
            end;

            function section:Slider(sliderName, properties, callback)
                local callback = callback or function() end;
                library.flags[sliderName] = properties.min;

                local holder = library:Create("Frame", {
                    Size = UDim2.new(1, -20, 0, 36);
                    BackgroundTransparency = 1;
                    Name = "holder";
                    Parent = boxContainer;
                    library:Create("TextLabel", {
                        Name = "label";
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Size = UDim2.new(1, 0, 0, 17);
                        Font = "Gotham";
                        Text = sliderName;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 12.000;
                        TextXAlignment = "Left";
                    });
                    library:Create("TextButton", {
                        Name = "slider";
                        BackgroundColor3 = Color3.fromRGB(34, 34, 34);
                        BorderColor3 = Color3.fromRGB(102, 41, 255);
                        Position = UDim2.new(0, 0, 1, -19);
                        Size = UDim2.new(1, 0, 0, 16);
                        AutoButtonColor = false;
                        Font = "SourceSans";
                        Text = "";
                        TextColor3 = Color3.fromRGB(0, 0, 0);
                        TextSize = 14.000;
                        library:Create("TextLabel", {
                            Name = "value";
                            BackgroundTransparency = 1;
                            Size = UDim2.new(1, 0, 1, 0);
                            Font = "SourceSans";
                            Text = properties.default and tostring(properties.default) or tostring(properties.min);
                            TextColor3 = Color3.fromRGB(255, 255, 255);
                            TextSize = 14.000;
                            ZIndex = 2;
                        });
                        library:Create("Frame", {
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                            Position = UDim2.new(0, 1, 0, 1);
                            Name = "fill";
                            Size = UDim2.new(0, 0, 1, -2);
                            BorderSizePixel = 0;
                            library:Create("UIGradient", {
                                Color = ui_Settings.gradientColorSection;
                                Rotation = 90;
                            });
                        });
                    });
                });

                local Connection;
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if(Connection) then
                            Connection:Disconnect();
                            Connection = nil;
                        end;
                    end;
                end);

                holder.slider.MouseButton1Down:Connect(function()
                    if(Connection) then
                        Connection:Disconnect();
                    end;

                    Connection = RunService.Heartbeat:Connect(function()
                        local mouse = UserInputService:GetMouseLocation();
                        local percent = math.clamp((mouse.X - holder.slider.AbsolutePosition.X) / (holder.slider.AbsoluteSize.X), 0, 1);
                        local Value = properties.min + (properties.max - properties.min) * percent;

                        if not properties.precise then
                            Value = math.floor(Value);
                        end;

                        Value = tonumber(string.format("%.2f", Value));

                        library:Tween(holder.slider.fill, {time = 0.1, Size = UDim2.new(percent, 0, 1, -2)})
                        holder.slider.value.Text = tostring(Value);
                        library.flags[sliderName] = Value;

                        callback(Value);
                    end);
                end);
            end;

            function section:Bind(bindName, defaultKey, callback)
                local callback = callback or function() end;
                local input = defaultKey and tostring(defaultKey):gsub("Enum.", ""):gsub("UserInputType.", ""):gsub("KeyCode.", "") or "None";
                library.callbacks[bindName] = callback;
                library.flags[bindName] = defaultKey;

                local holder = library:Create("Frame", {
                    Name = "holder";
                    Parent = boxContainer;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    LayoutOrder = 2;
                    Position = UDim2.new(0, 10, 0, 76);
                    Size = UDim2.new(1, -20, 0, 18);
                    library:Create("TextLabel", {
                        Name = "label";
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Size = UDim2.new(1, 0, 1, 0);
                        Font = "Gotham";
                        Text = bindName;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 12.000;
                        TextXAlignment = "Left";
                    });
                    library:Create("TextButton", {
                        Name = "keybind";
                        BackgroundColor3 = Color3.fromRGB(34, 34, 34);
                        BorderColor3 = Color3.fromRGB(102, 41, 255);
                        ClipsDescendants = true;
                        Position = UDim2.new(1, -80, 0, 0);
                        Size = UDim2.new(0, 80, 1, 0);
                        AutoButtonColor = false;
                        Font = Enum.Font.SourceSans;
                        Text = input;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                    });
                });

                local whitelistedType = {
                    [Enum.KeyCode.LeftShift] = "L-Shift",
                    [Enum.KeyCode.RightShift] = "R-Shift",
                    [Enum.KeyCode.LeftControl] = "L-Ctrl",
                    [Enum.KeyCode.RightControl] = "R-Ctrl",
                    [Enum.KeyCode.LeftAlt] = "L-Alt",
                    [Enum.KeyCode.RightAlt] = "R-Alt",
                    [Enum.KeyCode.CapsLock] = "CAPS",
                    [Enum.KeyCode.One] = "1",
                    [Enum.KeyCode.Two] = "2",
                    [Enum.KeyCode.Three] = "3",
                    [Enum.KeyCode.Four] = "4",
                    [Enum.KeyCode.Five] = "5",
                    [Enum.KeyCode.Six] = "6",
                    [Enum.KeyCode.Seven] = "7",
                    [Enum.KeyCode.Eight] = "8",
                    [Enum.KeyCode.Nine] = "9",
                    [Enum.KeyCode.Zero] = "0",
                    [Enum.KeyCode.KeypadOne] = "Num-1",
                    [Enum.KeyCode.KeypadTwo] = "Num-2",
                    [Enum.KeyCode.KeypadThree] = "Num-3",
                    [Enum.KeyCode.KeypadFour] = "Num-4",
                    [Enum.KeyCode.KeypadFive] = "Num-5",
                    [Enum.KeyCode.KeypadSix] = "Num-6",
                    [Enum.KeyCode.KeypadSeven] = "Num-7",
                    [Enum.KeyCode.KeypadEight] = "Num-8",
                    [Enum.KeyCode.KeypadNine] = "Num-9",
                    [Enum.KeyCode.KeypadZero] = "Num-0",
                    [Enum.KeyCode.Minus] = "-",
                    [Enum.KeyCode.Equals] = "=",
                    [Enum.KeyCode.Tilde] = "~",
                    [Enum.KeyCode.LeftBracket] = "[",
                    [Enum.KeyCode.RightBracket] = "]",
                    [Enum.KeyCode.RightParenthesis] = ")",
                    [Enum.KeyCode.LeftParenthesis] = "(",
                    [Enum.KeyCode.Semicolon] = ";",
                    [Enum.KeyCode.Quote] = "'",
                    [Enum.KeyCode.BackSlash] = "\\",
                    [Enum.KeyCode.Comma] = ",",
                    [Enum.KeyCode.Period] = ".",
                    [Enum.KeyCode.Slash] = "/",
                    [Enum.KeyCode.Asterisk] = "*",
                    [Enum.KeyCode.Plus] = "+",
                    [Enum.KeyCode.Period] = ".",
                    [Enum.KeyCode.Backquote] = "`",
                    [Enum.UserInputType.MouseButton1] = "Button-1",
                    [Enum.UserInputType.MouseButton2] = "Button-2",
                    [Enum.UserInputType.MouseButton3] = "Button-3",
                };

                holder.keybind.MouseButton1Click:Connect(function()
                    holder.keybind.Text = ". . .";
                    local connection;
                    connection = UserInputService.InputBegan:Connect(function(input)
                        connection:Disconnect();
                        wait();

                        local KeyCodeName = whitelistedType[input.KeyCode] or whitelistedType[input.UserInputType];

                        holder.keybind.Text = KeyCodeName or tostring(input.KeyCode):gsub("Enum.KeyCode.", "");
                        if(input.UserInputType == Enum.UserInputType.Keyboard) then
                            library.flags[bindName] = input.KeyCode;
                        else
                            library.flags[bindName] = input.UserInputType;
                        end;
                    end);
                end);
            end;

            function section:Button(buttonName, callback)
                local callback = callback or function() end;
                local holder = library:Create("Frame", {
                    Name = "holder";
                    Parent = boxContainer;
                    BackgroundTransparency = 1.000;
                    Position = UDim2.new(0, 10, 0, 148);
                    Size = UDim2.new(1, -20, 0, 18);
                    library:Create("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        Size = UDim2.new(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        Text = "";
                        Name = "button";
                        AutoButtonColor = false;
                        library:Create("TextLabel", {
                            Name = "label";
                            BackgroundTransparency = 1;
                            Size = UDim2.new(1, 0, 1, 0);
                            Font = "SourceSans";
                            TextSize = 14;
                            TextColor3 = Color3.fromRGB(255, 255, 255);
                            Text = buttonName;
                        });
                        library:Create("UIGradient", {
                            Rotation = 90;
                            Color = ui_Settings.gradientColorSection;
                        });
                    });
                });

                holder.button.MouseButton1Click:Connect(callback);
            end;

            function section:Dropdown(name, list, callback)
                local callback = callback or function() end;
                local toggle = false;

                local holder = library:Create("Frame", {
                    Name = "holder";
                    BackgroundTransparency = 1.000;
                    LayoutOrder = 3;
                    Position = UDim2.new(0, 10, 0, 98);
                    Size = UDim2.new(1, -20, 0, 36);
                    Parent = boxContainer;
                    library:Create("TextLabel", {
                        Name = "label";
                        BackgroundTransparency = 1.000;
                        Size = UDim2.new(1, 0, 0, 18);
                        Font = Enum.Font.Gotham;
                        Text = name;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 12.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    });
                    library:Create("TextButton", {
                        Name = "dropdown";
                        BackgroundColor3 = Color3.fromRGB(102, 41, 255);
                        BorderColor3 = Color3.fromRGB(102, 41, 255);
                        Size = UDim2.new(1, 0, 0, 18);
                        AutoButtonColor = false;
                        Font = "SourceSans";
                        Text = "";
                        TextColor3 = Color3.fromRGB(0, 0, 0);
                        TextSize = 14.000;
                        Position = UDim2.new(0, 0, 0, 18);
                        library:Create("ImageLabel", {
                            Name = "icon";
                            BackgroundTransparency = 1.000;
                            Position = UDim2.new(1, -18, 0, 0);
                            Size = UDim2.new(0, 18, 0, 16);
                            Image = "http://www.roblox.com/asset/?id=4641587888";
                            ZIndex = 2;
                        });
                        library:Create("TextLabel", {
                            Name = "label";
                            BackgroundTransparency = 1.000;
                            Position = UDim2.new(0, 4, 0, 0);
                            Size = UDim2.new(1, -4, 0, 18);
                            Font = Enum.Font.Gotham;
                            Text = "Drop value";
                            TextColor3 = Color3.fromRGB(255, 255, 255);
                            TextSize = 12.000;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            ZIndex = 2;
                        });
                        library:Create("Frame", {
                            Name = "dropframe";
                            BackgroundColor3 = Color3.fromRGB(32, 32, 32);
                            BorderColor3 = Color3.fromRGB(102, 41, 255);
                            BorderSizePixel = 0;
                            ClipsDescendants = true;
                            Position = UDim2.new(0, -1, 1, 1);
                            Size = UDim2.new(1, 2, 0, 0);
                            library:Create("UIListLayout", {
                                SortOrder = "LayoutOrder";
                                Padding = UDim.new(0, 2);
                            });
                        });
                        library:Create("Frame", {
                            Name = "fill";
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                            BorderSizePixel = 0;
                            Position = UDim2.new(0, 1, 0, 1);
                            Size = UDim2.new(1, 0, 1, 0);
                            library:Create("UIGradient", {
                                Rotation = 90;
                                Color = ui_Settings.gradientColorSection;
                            });
                        });
                    });
                });

                for i, v in next, list do
                    local button = library:Create("TextButton", {
                        Name = "button";
                        Text = v;
                        Parent = holder.dropdown.dropframe;
                        BackgroundColor3 = Color3.fromRGB(32, 32, 32);
                        BorderColor3 = Color3.fromRGB(255, 255, 255);
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 0, 16);
                        Font = "SourceSans";
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                        ZIndex = 1;
                    });

                    button.MouseButton1Click:Connect(function()
                        toggle = false;
                        holder.dropdown.label.Text = v;
                        library:Tween(holder.dropdown.icon, {time = 0.1, Rotation = 180});
                        library:Tween(holder, {time = 0.1, Size = UDim2.new(1, -20, 0, 35)});
                        library:Tween(holder.dropdown.dropframe, {time = 0.1, Size = UDim2.new(1, 2, 0, 0)}, self.Update);
                        callback(button.Text);
                    end);
                end;

                holder.dropdown.MouseButton1Click:Connect(function()
                    toggle = not toggle;
                    local TotalY = 0;
                    for i, v in next, holder.dropdown.dropframe:GetChildren() do
                        if(v:IsA("TextButton")) then
                            TotalY = TotalY + v.AbsoluteSize.Y + 2;
                        end;
                    end;

                    if(toggle) then
                        library:Tween(holder.dropdown.icon, {time = 0.1, Rotation = 0});
                        library:Tween(holder, {time = 0.1, Size = UDim2.new(1, -20, 0, TotalY + 50)});
                        library:Tween(holder.dropdown.dropframe, {time = 0.1, Size = UDim2.new(1, 2, 0, TotalY)}, self.Update);
                    else
                        library:Tween(holder.dropdown.icon, {time = 0.1, Rotation = 180});
                        library:Tween(holder, {time = 0.1, Size = UDim2.new(1, -20, 0, 36)});
                        library:Tween(holder.dropdown.dropframe, {time = 0.1, Size = UDim2.new(1, 2, 0, 0)}, self.Update);
                    end;
                end);
            end;

            function section:ColorPicker(pickerName, defaultColor, callback)
                local callback = callback or function() end;
                local defaultColor = defaultColor or Color3.fromRGB(102, 41, 255);
                local rainbowToggle = false;
                local Mouse = Players.LocalPlayer:GetMouse();

                local holder = library:Create("Frame", {
                    Name = "holder";
                    Parent = boxContainer;
                    BackgroundTransparency = 1.000;
                    Position = UDim2.new(0, 10, 0, 172);
                    Size = UDim2.new(1, -20, 0, 18);
                    library:Create("TextLabel", {
                        Name = "label";
                        BackgroundTransparency = 1.000;
                        Size = UDim2.new(1, 0, 1, 0);
                        Font = "Gotham";
                        Text = pickerName;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 12.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    });
                    library:Create("TextButton", {
                        Name = "colorpicker";
                        BackgroundColor3 = Color3.fromRGB(34, 34, 34);
                        BorderColor3 = Color3.fromRGB(102, 41, 255);
                        Position = UDim2.new(1, -16, 0, 0);
                        Size = UDim2.new(0, 16, 0, 16);
                        AutoButtonColor = false;
                        Font = Enum.Font.SourceSans;
                        Text = "";
                        TextColor3 = Color3.fromRGB(0, 0, 0);
                        TextSize = 14.000;
                        library:Create("Frame", {
                            Name = "colorframe";
                            BackgroundColor3 = Color3.fromRGB(32, 32, 32);
                            BorderColor3 = Color3.fromRGB(102, 41, 255);
                            Position = UDim2.new(0, -148, 1, 6);
                            Size = UDim2.new(0, 144, 0, 139);
                            Visible = false;
                            ZIndex = 2;
                            library:Create("ImageButton", {
                                Name = "satval";
                                Image = "http://www.roblox.com/asset/?id=4650897272";
                                BorderSizePixel = 0;
                                AutoButtonColor = false;
                                BackgroundColor3 = defaultColor;
                                Position = UDim2.new(0, 4, 0, 3);
                                Size = UDim2.new(0, 110, 0, 102);
                                ZIndex = 2;
                                library:Create("TextButton", {
                                    Name = "picker";
                                    BackgroundColor3 = Color3.fromRGB(53, 53, 53);
                                    BackgroundTransparency = 0.500;
                                    BorderSizePixel = 0;
                                    Position = UDim2.new(0.5, 0, 0.5, 0);
                                    Size = UDim2.new(0, 5, 0, 5);
                                    ZIndex = 2;
                                    Text = "";
                                });
                            });
                            library:Create("TextButton", {
                                Name = "rainbow";
                                ZIndex = 2;
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                                BorderColor3 = Color3.fromRGB(255, 255, 255);
                                ClipsDescendants = true;
                                Position = UDim2.new(0, 5, 1, -25);
                                Size = UDim2.new(0, 133, 0, 20);
                                AutoButtonColor = false;
                                Font = "SourceSans";
                                Text = "";
                                TextColor3 = Color3.fromRGB(255, 255, 255);
                                TextSize = 14.000;
                                library:Create("UIGradient", {
                                    Color = ui_Settings.gradientColorSection;
                                    Rotation = -90;
                                });
                                library:Create("TextLabel", {
                                    Name = "label";
                                    Parent = button;
                                    BackgroundTransparency = 1.000;
                                    Size = UDim2.new(1, 0, 1, 0);
                                    Font = "SourceSans";
                                    Text = "Rainbow: OFF";
                                    TextColor3 = Color3.fromRGB(255, 255, 255);
                                    TextSize = 14.000;
                                    ZIndex = 2;
                                });
                            });
                            library:Create("ImageButton", {
                                Name = "hue";
                                AutoButtonColor = false;
                                ZIndex = 2;
                                Position = UDim2.new(0, 118, 0, 3);
                                Size = UDim2.new(0, 18, 0, 102);
                                Image = "http://www.roblox.com/asset/?id=4650897105";
                                library:Create("TextButton", {
                                    Name = "selector";
                                    BackgroundColor3 = Color3.fromRGB(53, 53, 53);
                                    BorderSizePixel = 0;
                                    Size = UDim2.new(1, 0, 0, 5);
                                    Text = "";
                                    ZIndex = 2;
                                });
                            });
                        });
                        library:Create("Frame", {
                            Name = "color";
                            BackgroundColor3 = defaultColor;
                            BorderSizePixel = 0;
                            Position = UDim2.new(0, 1, 0, 1);
                            Size = UDim2.new(0, 14, 0, 14);
                        });
                    });
                });


                local colorData = {
                    H = 1;
                    S = 1;
                    V = 1;
                };

                local Connection1;
                local Connection2;

                local function getXY(frame)
                    local x, y = Mouse.X - frame.AbsolutePosition.X, Mouse.Y - frame.AbsolutePosition.Y;
                    local maxX, maxY = frame.AbsoluteSize.X,frame.AbsoluteSize.Y;
                    x = math.clamp(x, 0, maxX);
                    y = math.clamp(y, 0, maxY);
                    return x / maxX, y / maxY;
                end;

                local function Update()
                    local Color = Color3.fromHSV(colorData.H, colorData.S, colorData.V);
                    holder.colorpicker.color.BackgroundColor3 = Color;
                    holder.colorpicker.colorframe.satval.BackgroundColor3 = Color3.fromHSV(colorData.H, 1, 1);
                    callback(Color);
                end;

                holder.colorpicker.MouseButton1Click:Connect(function()
                    toggle = not toggle;
                    holder.colorpicker.colorframe.Visible = toggle;
                end);

                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        if(Connection1) then
                            Connection1:Disconnect();
                            Connection1 = nil;
                        end;
                        if(Connection2) then
                            Connection2:Disconnect();
                            Connection2 = nil;
                        end;
                        isFocused = false;
                    end;
                end);

                holder.colorpicker.colorframe.rainbow.MouseButton1Click:Connect(function()
                    rainbowToggle = not rainbowToggle;
                    holder.colorpicker.colorframe.rainbow.label.Text = rainbowToggle and "Rainbow: ON" or "Rainbow: OFF";

                    if(rainbowToggle) then
                        repeat
                            library:Tween(holder.colorpicker.colorframe.hue.selector, {time = 0.1, Position = UDim2.new(0, 0, library.rainbowI, 0)});
                            holder.colorpicker.colorframe.satval.BackgroundColor3 = Color3.fromHSV(1 - library.rainbowI, 1, 1);
                            holder.colorpicker.color.BackgroundColor3 = library.rainbowVal;
                            callback(library.rainbowVal);
                            RunService.Heartbeat:Wait();
                        until not rainbowToggle;
                    end;
                end);

                holder.colorpicker.colorframe.satval.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        if(Connection1) then
                            Connection1:Disconnect();
                        end;
                        Connection1 = RunService.Heartbeat:Connect(function()
                            local X, Y = getXY(holder.colorpicker.colorframe.satval);

                            holder.colorpicker.colorframe.satval.picker.Position = UDim2.new(X, 0, Y, 0);
                            colorData.S = X;
                            colorData.V = 1 - Y;
                            Update();
                        end);
                    end;
                end);

                holder.colorpicker.colorframe.hue.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        if(Connection2) then
                            Connection2:Disconnect();
                        end;

                        Connection2 = RunService.Heartbeat:Connect(function()
                            local X, Y = getXY(holder.colorpicker.colorframe.hue);

                            colorData.H = 1 - Y;
                            holder.colorpicker.colorframe.hue.selector.Position = UDim2.new(0, 0, Y, 0);
                            Update();
                        end);
                    end;
                end);
            end;

            return section;
        end;
    end;

    return library;
end;

return initLibrary();
