local maker = loadstring(game:HttpGet("https://github.com/slf0Dev/my-ui-library-making-utility/raw/main/InstanceMaker.lua"))();
local make = maker.Instance

local x = 750
local y = 520

local SupportedProperties = {
    "TextTransparency"  , "ImageTransparency" , "BackgroundTransparency"
}

local allproperties = {}
local TabsProperties = {}

local function SaveProperties(where,to)
    for _,v in next,where:GetDescendants() do
        if v.ClassName == "TextLabel" or v.ClassName == "TextBox" or v.ClassName == "TextButton" then
            to[v] = {
                TextTransparency = v.TextTransparency;
                BackgroundTransparency = v.BackgroundTransparency;
            }
        elseif v.ClassName == "ImageLabel" or v.ClassName == "ImageButton" then
            to[v] = {
                BackgroundTransparency = v.BackgroundTransparency;
                ImageTransparency = v.ImageTransparency;
            }
        elseif v.ClassName == "Frame" then
            to[v] = {
                BackgroundTransparency = v.BackgroundTransparency;
            }
        elseif v.ClassName == "ScrollingFrame" then
            to[v] = {
                BackgroundTransparency = v.BackgroundTransparency;
                ScrollBarImageTransparency = v.ScrollBarImageTransparency;
            }
        elseif v.ClassName == "UIStroke" then
            to[v] = {
                Transparency = v.Transparency;
            }
        end
    end
end



for i,v in next,game.CoreGui:GetChildren() do
    if v.Name == "Ocerlib" then
        v:Destroy()
    end
end

--[[
    light theme

        MainColor = Color3.fromRGB(200,200,235);
        BrighterMainColor = Color3.fromRGB(215,215,245);
        IconsColor = Color3.fromRGB(100,100,120);
        Accent = Color3.fromRGB(0,100,255);
        DarkText = Color3.fromRGB(75,75,75);
        BrightText = Color3.fromRGB(50,50,50);
        Font = "Gotham";
        SoundVolume = 0.5


    dark theme

        MainColor = Color3.fromRGB(35,35,40);
        BrighterMainColor = Color3.fromRGB(40,40,45);
        IconsColor = Color3.fromRGB(100,100,120);
        Accent = Color3.fromRGB(0,100,255);
        DarkText = Color3.fromRGB(170,170,170);
        BrightText = Color3.fromRGB(145,145,145);
        Font = "Gotham";
        SoundVolume = 0.5

    
    dark green theme

        MainColor = Color3.fromRGB(30,35,30);
        BrighterMainColor = Color3.fromRGB(35,40,35);
        IconsColor = Color3.fromRGB(100,100,120);
        Accent = Color3.fromRGB(0,255,100);
        DarkText = Color3.fromRGB(170,170,170);
        BrightText = Color3.fromRGB(145,145,145);
        Font = "Gotham";
        SoundVolume = 0.5


    dark red theme

        MainColor = Color3.fromRGB(35,30,30);
        BrighterMainColor = Color3.fromRGB(40,35,35);
        IconsColor = Color3.fromRGB(100,100,120);
        Accent = Color3.fromRGB(255,0,100);
        DarkText = Color3.fromRGB(170,170,170);
        BrightText = Color3.fromRGB(145,145,145);
        Font = "Gotham";
        SoundVolume = 0.5
]]

local defaulttheme = {
    MainColor = Color3.fromRGB(35,35,40);
    BrighterMainColor = Color3.fromRGB(40,40,45);
    IconsColor = Color3.fromRGB(100,100,120);
    Accent = Color3.fromRGB(0,100,255);
    DarkText = Color3.fromRGB(170,170,170);
    BrightText = Color3.fromRGB(145,145,145);
    Font = "Gotham";
    SoundVolume = 0.5;
    HideKey = "LeftAlt"
}

local Library = {
    ["theme"] = getgenv().LibTheme or defaulttheme
}

local screeng = make("ScreenGui",{
    Parent = game.CoreGui;
    Name = "Ocerlib";
    Enabled = false;
    IgnoreGuiInset = true
})





local pagescount = 0

local TweenService = game:GetService("TweenService")

local function Tween(instance, time, properties)
    TweenService:Create(instance, TweenInfo.new(time), properties):Play()
end

function Library.Main(text : string)
    local inmain = {}

    local Main = make("Frame",{
        Parent = screeng;
        Name = "Main";
        AnchorPoint = Vector2.new(0.5,0.5);
        Position = UDim2.new(0.5,0,0.55,0);
        Size = UDim2.new(0,x - 30,0,y - 30);
        BorderSizePixel = 0;
        BackgroundTransparency = 0;
        BackgroundColor3 = Library["theme"]["MainColor"];
        CornerRadius = UDim.new(0,5);
        ClipsDescendants = true;
        Active = true;
        Draggable = true
    })

    local LogoIcon = make("ImageLabel",{
        Parent = Main;
        Name = "LogoIcon";
        AnchorPoint = Vector2.new(0,0);
        Size = UDim2.new(0,55,0,55);
        Position = UDim2.new(1,-55,0,0);
        BorderSizePixel = 0;
        BackgroundTransparency = 1;
        Image = "rbxassetid://10587654910";
        ImageTransparency = 0;
        ImageColor3 = Color3.fromRGB(255,255,255);
        ScaleType = Enum.ScaleType["Crop"];
        ZIndex = 3;
    })

    local MainStroke = make("UIStroke",{
        Parent = Main;
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        Color = Library["theme"]["Accent"];
        Enabled = true;
        Thickness = 1;
    })

    function inmain.Loader()
        local HideWindow = make("Frame",{
            Parent = Main;
            Name = "HideWindow";
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = UDim2.new(0.5,0,0.5,0);
            Size = UDim2.new(1,0,1,0);
            BorderSizePixel = 0;
            BackgroundTransparency = 0;
            BackgroundColor3 = Library["theme"]["MainColor"];
            CornerRadius = UDim.new(0,5);
            ClipsDescendants = true;
            ZIndex = 6
        })

        local LogoIcon2 = make("ImageLabel",{
            Parent = Main;
            Name = "LogoIcon2";
            AnchorPoint = Vector2.new(0.5,0.5);
            Size = UDim2.new(0,65,0,65);
            Position = UDim2.new(0.5,0,0.5,0);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Image = "rbxassetid://10562470318";
            ImageTransparency = 1;
            ImageColor3 = Color3.fromRGB(255,255,255);
            ScaleType = Enum.ScaleType["Crop"];
            ZIndex = 6;
        })

        for i = 1,4 do
            local cubeXPosition = (i == 1 and 0 or i == 2 and 35 or i == 3 and 0 or i == 4 and -35)
            local cubeYPosition = (i == 1 and 35 or i == 2 and 0 or i == 3 and -35 or i == 4 and 0)
            local cubeRotation = 45
        
            
            local totweenposX = (i == 1 and 0 or i == 2 and 70 or i == 3 and 0 or i == 4 and -70)
            local totweenposY = (i == 1 and 70 or i == 2 and 0 or i == 3 and -70 or i == 4 and 0)
        
            local cube = make("Frame",{
                Parent = Main;
                Name = "Cube " .. i;
                AnchorPoint = Vector2.new(0.5,0.5);
                Position = UDim2.new(0.5,totweenposX,0.5,totweenposY);
                Size = UDim2.new(0,50,0,50);
                BackgroundColor3 = Library["theme"]["Accent"];
                BorderSizePixel = 0;
                BackgroundTransparency = 1;
                Rotation = cubeRotation;
                ZIndex =7
            })
        
            cube:TweenPosition(UDim2.new(0.5,cubeXPosition,0.5,cubeYPosition),"Out","Quart",0.5)
            game:GetService("TweenService"):Create(cube,TweenInfo.new(0),{BackgroundTransparency = 0}):Play()
            game:GetService("TweenService"):Create(LogoIcon2,TweenInfo.new(0),{ImageTransparency = 0}):Play()
        
            local AnimationEnd = false
        
            spawn(function()
                while wait(1.6) do
                    spawn(function()
                        game:GetService("TweenService"):Create(cube,TweenInfo.new(0.7,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundColor3 = Library["theme"]["BrighterMainColor"]}):Play()
                        game:GetService("TweenService"):Create(cube,TweenInfo.new(1),{Rotation = cube.Rotation + 90}):Play()
                        cube:TweenPosition(UDim2.new(0.5,totweenposX,0.5,totweenposY),"Out","Quart",0.5)
                        wait(0.7)
                        if not AnimationEnd then
                            game:GetService("TweenService"):Create(cube,TweenInfo.new(0.7,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundColor3 = Library["theme"]["Accent"]}):Play()
                            cube:TweenPosition(UDim2.new(0.5,cubeXPosition,0.5,cubeYPosition),"In","Quart",0.5)
                        end
                    end)
                    spawn(function()
                        wait(4.2)
                        AnimationEnd = true
                    end)
                    if AnimationEnd then
                        cube:TweenPosition(UDim2.new(0.5,totweenposX,0.5,totweenposY),"Out","Quart",0.5)
                        game:GetService("TweenService"):Create(cube,TweenInfo.new(0.5),{BackgroundTransparency = 1}):Play()
                        game:GetService("TweenService"):Create(HideWindow,TweenInfo.new(0.5),{BackgroundTransparency = 1}):Play()
                        game:GetService("TweenService"):Create(LogoIcon2,TweenInfo.new(0),{ImageTransparency = 1}):Play()
                        break
                    end
                end
            end)
        end
    end

    local OnEffect = Instance.new("Sound")
    OnEffect.Name = "OnEffect"
    OnEffect.Parent = Main
    OnEffect.Volume = Library["theme"]["SoundVolume"]
    OnEffect.SoundId = "http://www.roblox.com/asset/?id=8745692251" 
    OnEffect:Play() 


    local Pages = make("Frame",{
        Parent = Main;
        Name = "Pages";
        Position = UDim2.new(0,15,0,65);
        Size = UDim2.new(0.48,0,1,-75);
        BorderSizePixel = 0;
        BackgroundColor3 = Color3.fromRGB(195, 195, 250);
        CornerRadius = UDim.new(0,5);
        BackgroundTransparency = 1;
        ClipsDescendants = true;
        Visible = true
    })


    local PagesLayout = make("UIPageLayout",{
        Parent = Pages;
        Name = "UIPage";
        Padding = UDim.new(0,5);
        FillDirection = Enum.FillDirection.Vertical;
        HorizontalAlignment = Enum.HorizontalAlignment.Left;
        VerticalAlignment = Enum.VerticalAlignment.Top;
        SortOrder = Enum.SortOrder.LayoutOrder;
        EasingDirection = Enum.EasingDirection.Out;
        EasingStyle = Enum.EasingStyle.Quint;
        TweenTime = 0.3;
        ScrollWheelInputEnabled = false;
    })

    local PagesButtonsCornerVisual = make("Frame",{
        Parent = Main;
        Name = "corner";
        Position = UDim2.new(0,15,0,15);
        Size = UDim2.new(0.4,0,0,35);
        BorderSizePixel = 0;
        BackgroundColor3 = Color3.fromRGB(195,195,250);
        BackgroundTransparency = 1;
        CornerRadius = UDim.new(0,5);
    })

    local PagesButtons = make("ScrollingFrame",{
        Parent = PagesButtonsCornerVisual;
        Name = "pagesbuttons";
        Position = UDim2.new(0,0,0,0);
        Size = UDim2.new(1,0,0,35);
        BorderSizePixel = 0;
        BackgroundColor3 = Color3.fromRGB(195,195,250);
        BackgroundTransparency = 1;
        ScrollBarImageTransparency = 1;
        ScrollBarThickness = 0;
        CanvasSize = UDim2.new(0,0,0,0);
        AutomaticCanvasSize = Enum.AutomaticSize.X;
    })

    local RightFade = make("ImageLabel",{
        Parent = PagesButtonsCornerVisual;
        Name = "PageIcon";
        AnchorPoint = Vector2.new(0,0.5);
        Size = UDim2.new(0,22,0,25);
        Position = UDim2.new(1,-22,0.5,0);
        BorderSizePixel = 0;
        BackgroundTransparency = 1;
        Image = "rbxassetid://10527389431";
        ImageRectOffset = rectOffset or Vector2.new(0,0);
        ImageRectSize = rectSize or Vector2.new(0,0);
        ImageTransparency = 0;
        ImageColor3 = Library["theme"]["MainColor"];
        ScaleType = Enum.ScaleType["Fit"];
    })

    local RightFade = make("ImageLabel",{
        Parent = PagesButtonsCornerVisual;
        Name = "PageIcon";
        AnchorPoint = Vector2.new(0,0.5);
        Size = UDim2.new(0,22,0,25);
        Position = UDim2.new(0,0,0.5,0);
        BorderSizePixel = 0;
        BackgroundTransparency = 1;
        Image = "rbxassetid://10527391886";
        ImageRectOffset = rectOffset or Vector2.new(0,0);
        ImageRectSize = rectSize or Vector2.new(0,0);
        ImageTransparency = 0;
        ImageColor3 = Library["theme"]["MainColor"];
        ScaleType = Enum.ScaleType["Fit"];
    })


    local PagesButtonsList = make("UIListLayout",{
        Parent = PagesButtons;
        Name = "UIList";
        Padding = UDim.new(0,13);
        FillDirection = Enum.FillDirection.Horizontal;
        HorizontalAlignment = Enum.HorizontalAlignment.Left;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local opened = true

    game:GetService("UserInputService").InputBegan:Connect(function(key,istyping)
        if key.KeyCode.Name == Enum.KeyCode[Library["theme"]["HideKey"]].Name and not istyping then
            if opened then
                Main:TweenSize(UDim2.new(0,x / 1.1,0,y / 1.1),"Out","Quart",0.6,true)
                for c,x in next,allproperties do
                    for b,n in next,allproperties[c] do
                        if tostring(b) == "TextTransparency" then
                            Tween(c,0.2,{[b] = 1})
                        else
                            Tween(c,0.5,{[b] = 1})
                        end
                    end
                end
            else
                OnEffect:Play() 
                Main:TweenSize(UDim2.new(0,x,0,y),"Out","Quart",0.6,true)
                for c,x in next,allproperties do
                    for b,n in next,allproperties[c] do
                        Main.Visible = true
                        if tostring(b) == "TextTransparency" then
                            Tween(c,0.8,{[b] = n})
                        else
                            Tween(c,0.5,{[b] = n})
                        end
                    end
                end
            end
            opened = not opened
        end
    end)
    local pagebuttonstable = {}
    function inmain.Page(text : string,iconid : string, rectOffset, rectSize,scaletype)
        local inpage = {}
        pagescount += 1
        local posincanvas = pagescount

        local PageButton = make("TextButton",{
            Parent = PagesButtons;
            Name = text;
            Size = UDim2.new(0,0,0,27);
            BorderSizePixel = 0;
            BackgroundColor3 = Color3.fromRGB(195, 195, 250);
            BackgroundTransparency = 1;
            Text = "      " .. text .. " ";
            TextColor3 = Library["theme"]["BrightText"];
            Font = Enum.Font[Library["theme"]["Font"]];
            TextXAlignment = Enum.TextXAlignment.Center;
            TextYAlignment = Enum.TextYAlignment.Center;
            AutomaticSize = Enum.AutomaticSize.X;
            TextSize = 16;
            AutoButtonColor = false;
        })

        local PageIcon = make("ImageLabel",{
            Parent = PageButton;
            Name = "PageIcon";
            AnchorPoint = Vector2.new(0,0.5);
            Size = UDim2.new(0,22,0,22);
            Position = UDim2.new(0,0,0.5,0);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Image = "rbxassetid://" .. iconid or "";
            ImageRectOffset = rectOffset or Vector2.new(0,0);
            ImageRectSize = rectSize or Vector2.new(0,0);
            ImageTransparency = 0;
            ImageColor3 = Library["theme"]["IconsColor"];
            ScaleType = Enum.ScaleType[scaleType or "Fit"];
        })

        local BottomLine = make("Frame",{
            Parent = PageButton;
            Name = "Line";
            AnchorPoint = Vector2.new(0,0);
            Position = UDim2.new(0,0,1,0);
            Size = UDim2.new(0,0,0,1.5);
            BorderSizePixel = 0;
            BackgroundColor3 = Library["theme"]["Accent"];
            BackgroundTransparency = 1;
            ZIndex = 2;
        })

        local Page = make("ScrollingFrame",{
            Parent = Pages;
            Name = text;
            Size = UDim2.new(1,0,1,0);
            BorderSizePixel = 0;
            BackgroundColor3 = Color3.fromRGB(195, 195, 250);
            CornerRadius = UDim.new(0,5);
            BackgroundTransparency = 1;
            ScrollBarImageTransparency = 1;
            ScrollBarThickness = 0;
            CanvasSize = UDim2.new(0,0,0,0);
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
        })

        local SectionsList = make("UIListLayout",{
            Parent = Page;
            Name = "UIList";
            Padding = UDim.new(0,15);
            FillDirection = Enum.FillDirection.Vertical;
            HorizontalAlignment = Enum.HorizontalAlignment.Left;
            VerticalAlignment = Enum.VerticalAlignment.Top;
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local isfirst

        if pagescount == 1 then isfirst = true else isfirst = false end

        spawn(function()
            wait(1) do
                Tween(BottomLine,1,{BackgroundTransparency = (isfirst and 0 or 1);})
                Tween(PageIcon,1,{ImageColor3 = (isfirst and Library["theme"]["Accent"] or Library["theme"]["IconsColor"]);})
                BottomLine:TweenSize(UDim2.new((isfirst and 1 or 0),0,0,1.5),"Out","Quint",1,true)
                if isfirst then Tween(PageButton,1,{TextColor3 = Library["theme"]["Accent"]}) end
            end
        end)
        pagebuttonstable[PageButton] = BottomLine

        PageButton.MouseButton1Click:Connect(function()
            PagesLayout:JumpTo(Page)
            for i,v in next,pagebuttonstable do
                if tostring(i) ~= PageButton.Name then
                    Tween(v,0.3,{BackgroundTransparency = 1})
                    Tween(i,0.3,{TextColor3 = Library["theme"]["BrightText"]})
                    Tween(i.PageIcon,0.3,{ImageColor3 = Library["theme"]["IconsColor"];})
                    v:TweenSize(UDim2.new(0,0,0,1.5),"Out","Quint",0.3,true)
                else
                    Tween(v,0.3,{BackgroundTransparency = 0})
                    Tween(i,0.3,{TextColor3 = Library["theme"]["Accent"]})
                    v:TweenSize(UDim2.new(1,0,0,1.5),"Out","Quint",0.3,true)
                    Tween(i.PageIcon,0.3,{ImageColor3 = Library["theme"]["Accent"];})
                end
            end
        end)
        function inpage.Section(text : string)
            local insection = {}
            local Section = make("Frame",{
                Parent = Page;
                Name = text;
                Size = UDim2.new(0.96,0,0,0);
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(0,0,0);
                BackgroundTransparency = 1;
                AutomaticSize = Enum.AutomaticSize.Y
            })


            local SectionTitle = make("TextLabel",{
                Parent = Section;
                Name = 'TitleSection';
                Size = UDim2.new(1,0,0,16);
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                BackgroundTransparency = 1;
                Text = text; 
                TextColor3 = Library["theme"]["BrightText"];
                Font = Enum.Font[Library["theme"]["Font"]];
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Top;
                TextSize = 16;
                ZIndex = 2;
                LayoutOrder = -9999;
            })

            local ComponentsList = make("UIListLayout",{
                Parent = Section;
                Name = "UIList";
                Padding = UDim.new(0,10);
                FillDirection = Enum.FillDirection.Vertical;
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                VerticalAlignment = Enum.VerticalAlignment.Top;
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            function insection.Component(component : string, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                if component == "Card" then
                    local TitleLabel = make("TextLabel",{
                        Parent = Section;
                        Name = text;
                        Size = UDim2.new(0.96,0,0,45);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                        BackgroundTransparency = 1;
                        Text = " " .. arg1; 
                        TextColor3 = Library["theme"]["DarkText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Top;
                        TextSize = 18;
                        ZIndex = 2;
                    })
                    local SecondLabel = make("TextLabel",{
                        Parent = TitleLabel;
                        Name = text;
                        Position = UDim2.new(0,12,0,18);
                        Size = UDim2.new(1,-14,0,5);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Color3.fromRGB(195, 195, 250);
                        BackgroundTransparency = 1;
                        Text = "" .. arg2;
                        TextWrapped = true;
                        TextColor3 = Library["theme"]["BrightText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Left;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 15;
                        ZIndex = 2;
                    })

                    local BackgroundFlow = make("Frame",{
                        Parent = TitleLabel;
                        Name = "flow";
                        AnchorPoint = Vector2.new(0.5,0.5);
                        Position = UDim2.new(0.5,0,0.5,0);
                        Size = UDim2.new(1,0,1,5);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 0;
                        ZIndex = 1;
                    })

                end

                if component == "Toggle" then
                    local Toggle = make("TextButton",{
                        Parent = Section;
                        Name = text;
                        Size = UDim2.new(0.96,0,0,40);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                        BackgroundTransparency = 1;
                        Text = "   " .. arg1;
                        TextColor3 = Library["theme"]["DarkText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        TextSize = 15;
                        ZIndex = 2;
                    })
                    

                    local BackgroundFlow = make("Frame",{
                        Parent = Toggle;
                        Name = "flow";
                        AnchorPoint = Vector2.new(0.5,0.5);
                        Position = UDim2.new(0.5,0,0.5,0);
                        Size = UDim2.new(1,0,1,0);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 0;
                        ZIndex = 1;
                    })

                    local Checker = make("Frame",{
                        Parent = Toggle;
                        Name = "checker";
                        AnchorPoint = Vector2.new(0,0.5);
                        Size = UDim2.new(0,30,0,5);
                        Position = UDim2.new(1,-45,0.5,0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Library["theme"]["MainColor"];
                        BackgroundTransparency = 0;
                        CornerRadius = UDim.new(100,100);
                        ZIndex = 2;
                    })

                    local Circle = make("Frame",{
                        Parent = Checker;
                        Name = "circle";
                        AnchorPoint = Vector2.new(0,0.5);
                        Size = UDim2.new(0,10,0,10);
                        Position = UDim2.new(0,0,0.5,0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Library["theme"]["MainColor"];
                        BackgroundTransparency = 0;
                        CornerRadius = UDim.new(100,100);
                        ZIndex = 2;
                    })

                    local CircleStroke = make("UIStroke",{
                        Parent = Circle;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Color = Color3.fromRGB(0,150,255);
                        Enabled = true;
                        Thickness = 3;
                    })


                    local toggled = make("BoolValue",{
                        Parent = Toggle;
                        Name = "flag";
                        Value = arg3
                    })

                    local function onswap()
                        if not toggled.Value then
                            Circle:TweenPosition(UDim2.new(0,0,0.5,0),"Out","Quint",0.5,true)
                            Tween(CircleStroke,0.5,{Color = Library["theme"]["MainColor"]})
                            Tween(Checker,0.5,{BackgroundColor3 = Library["theme"]["MainColor"]})
                            Tween(Circle,0.5,{BackgroundColor3 = Library["theme"]["BrighterMainColor"]})
                        else
                            Circle:TweenPosition(UDim2.new(1,-10,0.5,0),"Out","Quint",0.5,true)
                            Tween(CircleStroke,0.5,{Color = Library["theme"]["Accent"]})
                            Tween(Checker,0.5,{BackgroundColor3 = Library["theme"]["Accent"]})
                            Tween(Circle,0.5,{BackgroundColor3 = Library["theme"]["MainColor"]})
                        end
                    end

                    Toggle.MouseButton1Click:Connect(function()
                        toggled.Value = not toggled.Value
                        onswap()
                        arg2(toggled.Value)
                    end)

                    

                    if toggled.Value == true then
                        onswap()
                        arg2(toggled.Value)
                    else
                        onswap()
                    end
                end
                if component == "Button" then
                    local Button = make("TextButton",{
                        Parent = Section;
                        Name = text;
                        Size = UDim2.new(0.96,0,0,40);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 0;
                        Text = arg1;
                        TextColor3 = Library["theme"]["BrightText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Center;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        TextSize = 15;
                        ZIndex = 2;
                        AutoButtonColor = false;
                        ClipsDescendants = true;
                    })

                    local ButtonLine = make("Frame",{
                        Parent = Button;
                        Name = "Line";
                        AnchorPoint = Vector2.new(0,0);
                        Position = UDim2.new(1,-30,0,0);
                        Size = UDim2.new(0,2,0,0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Library["theme"]["Accent"];
                        BackgroundTransparency = 1;
                        ZIndex = 2;
                    })

                    local mouseEnter = false

                    Button.MouseButton1Click:Connect(function()
                        spawn(function()
                            arg2()
                        end)
                            for i = 1,2 do
                                spawn(function()
                                    local Line = ButtonLine:Clone()
                                    Line.Parent = Button
                                    Line.Position = (i == 1 and UDim2.new(1,-5,0,0) or i == 2 and UDim2.new(0,5,0,0))
                                    Tween(Line,0.3,{BackgroundTransparency = 0})
                                    Line:TweenSize(UDim2.new(0,2,1,0),"Out","Quint",1,true)
                                wait(0.3)
                                    Tween(Line,0.5,{BackgroundTransparency = 1})
                                    Line:TweenSizeAndPosition(UDim2.new(0,2,0,0),(i == 1 and UDim2.new(1,-5,1,0) or UDim2.new(0,5,1,0)),"Out","Quint",1,true)
                                wait(0.5)
                                    Line:Destroy()
                                end)
                            end
                        wait(0.5)
                        if mouseEnter then
                            Tween(Button,0.3,{TextColor3 = Library["theme"]["DarkText"]})
                        else
                            Tween(Button,0.3,{TextColor3 = Library["theme"]["BrightText"]})
                        end
                    end)

                    Button.MouseButton1Down:Connect(function()
                        Tween(Button,0.1,{TextColor3 = Library["theme"]["Accent"]})
                    end)
                    
                    Button.MouseEnter:Connect(function()
                        mouseEnter = true
                        Tween(Button,0.3,{TextColor3 = Library["theme"]["DarkText"]})
                    end)

                    Button.MouseLeave:Connect(function()
                        mouseEnter = false
                        Tween(Button,0.3,{TextColor3 = Library["theme"]["BrightText"]})
                    end)
                end
                if component == "Dropdown" then
                    local selectables = {}
                    local selected
                    local Dropdown = make("TextButton",{
                        Parent = Section;
                        Name = arg1;
                        Size = UDim2.new(0.96,0,0,40);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 0;
                        Text = "";
                        TextColor3 = Library["theme"]["BrightText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        TextSize = 18;
                        ZIndex = 2;
                        AutoButtonColor = false;
                    })

                    local DropdownLabel = make("TextLabel",{
                        Parent = Dropdown;
                        Name = "dropdownlabel";
                        Size = UDim2.new(1,0,0,40);
                        Position = UDim2.new(0,0,0,0);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 1;
                        Text = "   " .. arg1;
                        TextColor3 = Library["theme"]["DarkText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        TextSize = 15;
                        ZIndex = 2;
                    })

                    local ArrowIcon = make("ImageLabel",{
                        Parent = Dropdown;
                        Name = "ArrowIcon";
                        AnchorPoint = Vector2.new(0,0);
                        Size = UDim2.new(0,25,0,25);
                        Position = UDim2.new(1,-30,0,7);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Image = "rbxassetid://3926305904";
                        ImageRectOffset = Vector2.new(44, 404);
                        ImageRectSize = Vector2.new(36, 36);
                        Rotation = 90;
                        ImageTransparency = 0;
                        ImageColor3 = Library["theme"]["IconsColor"];
                        ScaleType = Enum.ScaleType["Fit"];
                        ZIndex = 3;
                    })

                    local SelectablesFrameVisual = make("Frame",{
                        Parent = Dropdown;
                        Name = "Selectables";
                        AnchorPoint = Vector2.new(0,0);
                        Position = UDim2.new(0,0,0,35);
                        Size = UDim2.new(1,0,0,0);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 0;
                        ZIndex = 3;
                        ClipsDescendants = true
                    })

                    local SelectablesFrame = make("ScrollingFrame",{
                        Parent = SelectablesFrameVisual;
                        Name = "Selectables";
                        Position = UDim2.new(0,0,0,0);
                        Size = UDim2.new(1,0,1,-5);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 1;
                        ZIndex = 3;
                        ScrollBarImageTransparency = 0.5;
                        ScrollBarImageColor3 = Library["theme"]["Accent"];
                        ScrollBarThickness = 4;
                        CanvasSize = UDim2.new(0,0,0,0);
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    })

                    local SelectablesList = make("UIListLayout",{
                        Parent = SelectablesFrame;
                        Name = "UIList";
                        Padding = UDim.new(0,5);
                        FillDirection = Enum.FillDirection.Vertical;
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        VerticalAlignment = Enum.VerticalAlignment.Top;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    local isopened = false
                    Dropdown.MouseButton1Click:Connect(function()
                        if isopened then
                            Tween(ArrowIcon,0.5,{Rotation = 90})
                            SelectablesFrameVisual:TweenSize(UDim2.new(1,0,0,0),"Out","Quart",0.5,true)
                            Dropdown:TweenSize(UDim2.new(0.96,0,0,40),"Out","Quart",0.5,true)
                        else
                            Tween(ArrowIcon,0.5,{Rotation = 180})
                            SelectablesFrameVisual:TweenSize(UDim2.new(1,0,0,100),"Out","Quart",0.5,true)
                            Dropdown:TweenSize(UDim2.new(0.96,0,0,140),"Out","Quart",0.5,true)
                        end
                        isopened = not isopened
                    end)

                    local function addchoice(atext : string, val)
                        local DropdownChoice = make("TextButton",{
                            Parent = SelectablesFrame;
                            Name = atext;
                            Size = UDim2.new(0.96,0,0,25);
                            BorderSizePixel = 0;
                            CornerRadius = UDim.new(0,5);
                            BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                            BackgroundTransparency = 0;
                            Text = "     " .. atext;  
                            TextColor3 = Library["theme"]["DarkText"];
                            Font = Enum.Font[Library["theme"]["Font"]];
                            TextXAlignment = Enum.TextXAlignment.Left;
                            TextYAlignment = Enum.TextYAlignment.Center;
                            TextSize = 14;
                            ZIndex = 5;
                            AutoButtonColor = false;
                            ClipsDescendants = true;
                        })

                        local IsSelected = make("Frame",{
                            Parent = DropdownChoice;
                            Name = "Dot";
                            AnchorPoint = Vector2.new(0,0.5);
                            Position = UDim2.new(0,5,0.5,0);
                            Size = UDim2.new(0,10,0,10);
                            BorderSizePixel = 0;
                            CornerRadius = UDim.new(0,5000);
                            BackgroundColor3 = Library["theme"]["MainColor"];
                            BackgroundTransparency = 0;
                            ZIndex = 5;
                        })

                        selectables[DropdownChoice] = val == true or false
                        if selectables[DropdownChoice] then
                            IsSelected.BackgroundColor3 = Library["theme"]["Accent"];
                        end
    
                        local mouseEnter = false
    
                        DropdownChoice.MouseButton1Click:Connect(function()
                            spawn(function()
                                if arg3 == true then
                                    selectables[DropdownChoice] = not selectables[DropdownChoice]
                                    arg4(atext,selectables[DropdownChoice])
                                    if selectables[DropdownChoice] then
                                        Tween(DropdownChoice,0.3,{TextColor3 = Library["theme"]["Accent"]})
                                        Tween(IsSelected,0.3,{BackgroundColor3 = Library["theme"]["Accent"]})
                                    else
                                        Tween(DropdownChoice,0.3,{TextColor3 = Library["theme"]["DarkText"]})
                                        Tween(IsSelected,0.3,{BackgroundColor3 = Library["theme"]["MainColor"]})
                                    end
                                else
                                    for i,v in next,selectables do
                                        if i ~= atext then
                                            selectables[i] = false
                                            Tween(i,0.3,{TextColor3 = Library["theme"]["DarkText"]})
                                            Tween(i.Dot,0.3,{BackgroundColor3 = Library["theme"]["MainColor"]})
                                        end
                                    end
                                    selectables[DropdownChoice] = true
                                    arg4(atext,val)
                                    Tween(DropdownChoice,0.3,{TextColor3 = Library["theme"]["Accent"]})
                                    Tween(IsSelected,0.3,{BackgroundColor3 = Library["theme"]["Accent"]})
                                end
                            end)
                        end)
    
                        
                        DropdownChoice.MouseEnter:Connect(function()
                            Tween(DropdownChoice,0.3,{TextColor3 = Library["theme"]["Accent"]})
                        end)
    
                        DropdownChoice.MouseLeave:Connect(function()
                            if not selectables[DropdownChoice] then
                                Tween(DropdownChoice,0.3,{TextColor3 = Library["theme"]["BrightText"]})
                            end
                        end)
                    end

                    for i,v in next,arg2 do
                        if v ~= nil then
                            addchoice(i,v)
                        elseif v == true or v == false then
                            addchoice(i,v)
                        else
                            addchoice(v)
                        end
                    end
                end
                if component == "Slider" then
                    local Slider = make("TextLabel",{
                        Parent = Section;
                        Name = arg1;
                        Size = UDim2.new(0.96,0,0,40);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 0;
                        Text = "   " .. arg1;
                        TextColor3 = Library["theme"]["BrightText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Top;
                        TextSize = 15;
                        ZIndex = 2;
                    })

                    local SliderValue = make("TextLabel",{
                        Parent = Slider;
                        Name = arg1;
                        Size = UDim2.new(1,0,0,15);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 1;
                        Text = arg6 .. " ";
                        TextColor3 = Library["theme"]["BrightText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Right;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        TextSize = 15;
                        ZIndex = 2;
                    })

                    local SliderCore = make("Frame",{
                        Parent = Slider;
                        Name = "SliderCore";
                        AnchorPoint = Vector2.new(0.5,0.5);
                        Position = UDim2.new(0.5,0,0.5,10);
                        Size = UDim2.new(1,-20,0,5);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,500);
                        BackgroundColor3 = Library["theme"]["MainColor"];
                        BackgroundTransparency = 0;
                        ZIndex = 2;
                    })

                    local SliderProgress = make("Frame",{
                        Parent = SliderCore;
                        Name = "SliderProgress";
                        Position = UDim2.new(0,0,0,0);
                        Size = UDim2.new(0.5,0,1,0);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,500);
                        BackgroundColor3 = Library["theme"]["Accent"];
                        BackgroundTransparency = 0;
                        ZIndex = 2;
                    })

                    local SliderCircle = make("Frame",{
                        Parent = SliderProgress;
                        Name = "circle";
                        AnchorPoint = Vector2.new(0,0.5);
                        Size = UDim2.new(0,8,0,8);
                        Position = UDim2.new(1,0,0.5,0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Library["theme"]["MainColor"];
                        BackgroundTransparency = 0;
                        CornerRadius = UDim.new(100,100);
                        ZIndex = 2;
                    })

                    local CircleStroke = make("UIStroke",{
                        Parent = SliderCircle;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Color = Library["theme"]["Accent"];
                        Enabled = true;
                        Thickness = 3;
                    })

                    local Mouse = game.Players.LocalPlayer:GetMouse()

                    local function UpdateSlider(val)
                        local percent = (Mouse.X - SliderProgress.AbsolutePosition.X) / SliderProgress.AbsoluteSize.X

                        if val then
                            percent = (val - arg2) / (arg3 - arg2)
                        end

                        percent = math.clamp(percent, 0, 1)

                        SliderProgress:TweenSize(UDim2.new(percent, 0, 1, 0),"Out","Sine",0.3,true)
                    end

                    UpdateSlider(arg6)

                    Tween(CircleStroke,0.3,{Color = Library["theme"]["MainColor"]})
                    Tween(SliderProgress,0.3,{BackgroundColor3 = Library["theme"]["MainColor"]})
                    Tween(SliderCircle,0.3,{BackgroundColor3 = Library["theme"]["BrighterMainColor"]})

                    local IsSliding,Dragging = false
                    local RealValue = arg6
                    local value
                    local function move(Pressed)
                        IsSliding = true;
                        local pos = UDim2.new(math.clamp((Pressed.Position.X - SliderCore.AbsolutePosition.X) / SliderCore.AbsoluteSize.X, 0, 1), 0, 1, 0)
                        local size = UDim2.new(math.clamp((Pressed.Position.X - SliderCore.AbsolutePosition.X) / SliderCore.AbsoluteSize.X, 0, 1), 0, 1, 0)
                        SliderProgress:TweenSize(size, "Out", "Quart", 0.2,true);
                        RealValue = (((pos.X.Scale * arg3) / arg3) * (arg3 - arg2) + arg2)
                        value = (arg4 and string.format("%.1f", tostring(RealValue))) or (math.floor(RealValue))
                        SliderValue.Text = tostring(value) .. " "
                        arg5(value)
                    end

                    -- this slider script i just skidded 2 years ago, im still using it


                    Slider.InputBegan:Connect(function(Pressed)
                        if Pressed.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = true
                            IsSliding = false
                            move(Pressed)
                        end
                    end)

                    Slider.InputEnded:Connect(function(Pressed)
                        if Pressed.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                            IsSliding = false
                            move(Pressed)
                        end
                    end)

                    game:GetService("UserInputService").InputChanged:Connect(function(Pressed)
                        if Dragging and Pressed.UserInputType == Enum.UserInputType.MouseMovement then
                            move(Pressed)
                        end
                    end)

                    Slider.MouseEnter:Connect(function()
                        Tween(CircleStroke,0.3,{Color = Library["theme"]["Accent"]})
                        Tween(SliderProgress,0.3,{BackgroundColor3 = Library["theme"]["Accent"]})
                        Tween(SliderCircle,0.3,{BackgroundColor3 = Library["theme"]["MainColor"]})
                    end)

                    Slider.MouseLeave:Connect(function()
                        repeat wait() until not Dragging
                        Tween(CircleStroke,0.3,{Color = Library["theme"]["MainColor"]})
                        Tween(SliderProgress,0.3,{BackgroundColor3 = Library["theme"]["MainColor"]})
                        Tween(SliderCircle,0.3,{BackgroundColor3 = Library["theme"]["BrighterMainColor"]})
                    end)
                end
                if component == "TimePicker" then
                    local hour,minute = 00,00
                    
                    local TimePickerButton = make("TextLabel",{
                        Parent = Section;
                        Name = arg1;
                        Size = UDim2.new(0.96,0,0,40);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                        BackgroundTransparency = 0;
                        Text = " " .. arg1;
                        TextColor3 = Library["theme"]["BrightText"];
                        Font = Enum.Font[Library["theme"]["Font"]];
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        TextSize = 15;
                        ZIndex = 2;
                        ClipsDescendants = true;
                    })

                    local ButtonLine = make("Frame",{
                        Parent = Button;
                        Name = "Line";
                        AnchorPoint = Vector2.new(0,0);
                        Position = UDim2.new(1,-30,0,0);
                        Size = UDim2.new(0,2,0,0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Library["theme"]["Accent"];
                        BackgroundTransparency = 1;
                        ZIndex = 2;
                    })

                    local HoursBox = make("Frame",{
                        Parent = TimePickerButton;
                        Name = "Hours";
                        AnchorPoint = Vector2.new(0,0.5);
                        Position = UDim2.new(0.75,0,0.5,0);
                        Size = UDim2.new(0,30,0,35);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["MainColor"];
                        BackgroundTransparency = 1;
                        ClipsDescendants = true;
                        ZIndex = 3 
                    })

                    local HoursLayout = make("UIPageLayout",{
                        Parent = HoursBox;
                        Name = "UIPage";
                        Padding = UDim.new(0,0);
                        FillDirection = Enum.FillDirection.Vertical;
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        VerticalAlignment = Enum.VerticalAlignment.Top;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        EasingDirection = Enum.EasingDirection.Out;
                        EasingStyle = Enum.EasingStyle.Quint;
                        TweenTime = 0.3;
                        ScrollWheelInputEnabled = true;
                        Circular = true;
                    })

                    local MinutesBox = make("Frame",{
                        Parent = TimePickerButton;
                        Name = "Minutes";
                        AnchorPoint = Vector2.new(0,0.5);
                        Position = UDim2.new(0.85,5,0.5,0);
                        Size = UDim2.new(0,30,0,35);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5);
                        BackgroundColor3 = Library["theme"]["MainColor"];
                        BackgroundTransparency = 1;
                        ClipsDescendants = true;
                        ZIndex = 3 
                    })

                    local dd = make("Frame",{
                        Parent = TimePickerButton;
                        Name = "dd";
                        AnchorPoint = Vector2.new(0,0.5);
                        Position = UDim2.new(0.85,3,0.5,-5);
                        Size = UDim2.new(0,5,0,5);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5000);
                        BackgroundColor3 = Library["theme"]["MainColor"];
                        BackgroundTransparency = 0;
                        ClipsDescendants = true;
                        ZIndex = 3
                    })

                    local dd2 = make("Frame",{
                        Parent = TimePickerButton;
                        Name = "dd2";
                        AnchorPoint = Vector2.new(0,0.5);
                        Position = UDim2.new(0.85,3,0.5,5);
                        Size = UDim2.new(0,5,0,5);
                        BorderSizePixel = 0;
                        CornerRadius = UDim.new(0,5000);
                        BackgroundColor3 = Library["theme"]["MainColor"];
                        BackgroundTransparency = 0;
                        ClipsDescendants = true;
                        ZIndex = 3
                    })
                    

                    local MinutesLayout = make("UIPageLayout",{
                        Parent = MinutesBox;
                        Name = "UIPage";
                        Padding = UDim.new(0,5);
                        FillDirection = Enum.FillDirection.Vertical;
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        VerticalAlignment = Enum.VerticalAlignment.Top;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        EasingDirection = Enum.EasingDirection.Out;
                        EasingStyle = Enum.EasingStyle.Quint;
                        TweenTime = 0.3;
                        ScrollWheelInputEnabled = true;
                        Circular = true;
                    })  

                    

                    local minutes = {}
                    local hours = {}

                    for minute = 0,59 do
                            local MinuteLabel = make("TextLabel",{
                                Parent = MinutesBox;
                                Name = 'minute' .. minute;
                                Size = UDim2.new(1,0,1,0);
                                BorderSizePixel = 0;
                                BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                                BackgroundTransparency = 1;
                                Text = (minute < 10 and "0" .. minute or minute); 
                                TextColor3 = Library["theme"]["BrightText"];
                                Font = Enum.Font["SourceSans"];
                                TextTransparency = 0;
                                TextSize = 25;
                                ZIndex = 3 
                            })
                            table.insert(minutes,MinuteLabel)
                    end

                    for hour = 0,23 do
                        local HourLabel = make("TextLabel",{
                            Parent = HoursBox;
                            Name = 'hour' .. hour;
                            Size = UDim2.new(1,0,1,0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                            BackgroundTransparency = 1;
                            Text = (hour < 10 and "0" .. hour or hour); 
                            TextColor3 = Library["theme"]["BrightText"];
                            Font = Enum.Font["SourceSans"];
                            TextTransparency = 0;
                            TextSize = 25;
                            ZIndex = 3 
                        })
                        table.insert(hours,HourLabel)
                    end
                end
            end
            return insection;
        end
        return inpage;
    end
    function inmain.Logs(title : string)
        local inlogs = {}

        local Logs = make("ScrollingFrame",{
            Parent = Main;
            Name = "Logs";
            Position = UDim2.new(0.52,0,0,55);
            Size = UDim2.new(0.46,0,1,-75);
            BorderSizePixel = 0;
            BackgroundColor3 = Color3.fromRGB(0,0,0);
            BackgroundTransparency = 1;
            ScrollBarImageTransparency = 1;
            ScrollBarThickness = 0;
            CanvasSize = UDim2.new(0,0,0,0);
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
        })


        local LogsTitle = make("TextLabel",{
            Parent = Main;
            Name = 'TitleLogs';
            Position = UDim2.new(0.52,0,0,20);
            Size = UDim2.new(0.46,0,0,16);
            BorderSizePixel = 0;
            BackgroundColor3 = Color3.fromRGB(100, 100, 100);
            BackgroundTransparency = 1;
            Text = title; 
            TextColor3 = Library["theme"]["BrightText"];
            Font = Enum.Font[Library["theme"]["Font"]];
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Top;
            TextSize = 18;
            ZIndex = 2;
        })

        make("Frame",{
            Parent = Logs;
            Size = UDim2.new(0,0,0,0);
            BorderSizePixel = 0;
            BackgroundColor3 = Color3.fromRGB(100, 100, 100);
            BackgroundTransparency = 1;
            LayoutOrder = 9999;
        })
        make("Frame",{
            Parent = Logs;
            Size = UDim2.new(0,0,0,0);
            BorderSizePixel = 0;
            BackgroundColor3 = Color3.fromRGB(100, 100, 100);
            BackgroundTransparency = 1;
            LayoutOrder = -9999;
        })

        local LogsList = make("UIListLayout",{
            Parent = Logs;
            Name = "UIList";
            Padding = UDim.new(0,10);
            FillDirection = Enum.FillDirection.Vertical;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            VerticalAlignment = Enum.VerticalAlignment.Top;
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        function inlogs.LogWithButtons(arg1,arg2,arg3)
            local inlog = {}
            local TitleLabel = make("TextLabel",{
                Parent = Logs;
                Name = arg1;
                Size = UDim2.new(1,0,0,70);
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                BackgroundTransparency = 1;
                Text = " " .. arg1; 
                TextColor3 = Library["theme"]["DarkText"];
                Font = Enum.Font[Library["theme"]["Font"]];
                TextTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Top;
                TextSize = 16;
                ZIndex = 2;
            })

            local Buttons = make("Frame",{
                Parent = TitleLabel;
                Name = "Buttons";
                Size = UDim2.new(0.96,0,0,25);
                Position = UDim2.new(0,5,1,-27),
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                BackgroundTransparency = 1;
                ZIndex = 2;
            })

            local TaskButtonsList = make("UIListLayout",{
                Parent = Buttons;
                Name = "UIList";
                Padding = UDim.new(0,5);
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            local SecondLabel = make("TextLabel",{
                Parent = TitleLabel;
                Name = "SecondLabel";
                Position = UDim2.new(0,8,0,18);
                Size = UDim2.new(1,-24,0,0);
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(195, 195, 250);
                BackgroundTransparency = 1;
                Text = arg2;
                TextWrapped = true;
                TextColor3 = Library["theme"]["BrightText"];
                TextTransparency = 1;
                Font = Enum.Font[Library["theme"]["Font"]];
                TextXAlignment = Enum.TextXAlignment.Left;
                AutomaticSize = Enum.AutomaticSize.Y;
                TextSize = 12;
                ZIndex = 2;
            })

            local BackgroundFlow = make("Frame",{
                Parent = TitleLabel;
                Name = "loggflow";
                AnchorPoint = Vector2.new(0.5,0.5);
                Position = UDim2.new(0.5,0,0.5,0);
                Size = UDim2.new(1,0,1,5);
                BorderSizePixel = 0;
                CornerRadius = UDim.new(0,5);
                BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                BackgroundTransparency = 0;
                ZIndex = 1;
            })
            
            Tween(BackgroundFlow,0.5,{BackgroundTransparency = 0})
            Tween(SecondLabel,0,{TextTransparency = 0})
            Tween(TitleLabel,0,{TextTransparency = 0})

            function inlog.Button(text : string, func)
                local Button = make("TextButton",{
                    Parent = Buttons;
                    Name = text;
                    Size = UDim2.new(0,0,0,25);
                    BorderSizePixel = 0;
                    CornerRadius = UDim.new(0,5);
                    BackgroundColor3 = Library["theme"]["MainColor"];
                    BackgroundTransparency = 0;
                    Text = "  " .. text .. "  ";
                    TextColor3 = Library["theme"]["BrightText"];
                    Font = Enum.Font[Library["theme"]["Font"]];
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    TextSize = 14;
                    ZIndex = 2;
                    AutomaticSize = Enum.AutomaticSize.X;
                    AutoButtonColor = false;
                    ClipsDescendants = true;
                })

                local ButtonStroke = make("UIStroke",{
                    Parent = Button;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Library["theme"]["Accent"];
                    Enabled = true;
                    Thickness = 1;
                })

                local mouseEnter = false

                Button.MouseButton1Click:Connect(function()
                    spawn(function()
                        func()
                    end)
                    wait(0.3)
                    Tween(Button,0.3,{BackgroundColor3 = Library["theme"]["MainColor"]})
                    if mouseEnter then
                        Tween(Button,0.3,{TextColor3 = Library["theme"]["DarkText"]})
                    else
                        Tween(Button,0.3,{TextColor3 = Library["theme"]["BrightText"]})
                    end
                end)

                Button.MouseButton1Down:Connect(function()
                    Tween(Button,0.1,{TextColor3 = Library["theme"]["DarkText"]})
                    Tween(Button,0.3,{BackgroundColor3 = Library["theme"]["Accent"]})
                end)
                
                Button.MouseEnter:Connect(function()
                    mouseEnter = true
                    Tween(Button,0.3,{TextColor3 = Library["theme"]["DarkText"]})
                end)

                Button.MouseLeave:Connect(function()
                    mouseEnter = false
                    Tween(Button,0.3,{TextColor3 = Library["theme"]["BrightText"]})
                end)

            end

            function inlog.ChangeText(tochange : string)
                TitleLabel.Text = tochange
            end

            function inlog.SelfDestroy()
                TitleLabel:Destroy()
            end

            return inlog;
        end

        function inlogs.Log(arg1,arg2,arg3,arg4,arg5,arg6)
            local TitleLabel = make("TextLabel",{
                Parent = Logs;
                Name = arg1;
                Size = UDim2.new(1,0,0,45);
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                BackgroundTransparency = 1;
                Text = " " .. arg1; 
                TextColor3 = Library["theme"]["DarkText"];
                Font = Enum.Font[Library["theme"]["Font"]];
                TextTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Top;
                TextSize = 16;
                ZIndex = 2;
            })
            local SecondLabel = make("TextLabel",{
                Parent = TitleLabel;
                Name = "SecondLabel";
                Position = UDim2.new(0,8,0,18);
                Size = UDim2.new(1,-24,0,0);
                BorderSizePixel = 0;
                BackgroundColor3 = Color3.fromRGB(195, 195, 250);
                BackgroundTransparency = 1;
                Text = arg2;
                TextWrapped = true;
                TextColor3 = Library["theme"]["BrightText"];
                TextTransparency = 1;
                Font = Enum.Font[Library["theme"]["Font"]];
                TextXAlignment = Enum.TextXAlignment.Left;
                AutomaticSize = Enum.AutomaticSize.Y;
                TextSize = 12;
                ZIndex = 2;
            })

            local BackgroundFlow = make("Frame",{
                Parent = TitleLabel;
                Name = "loggflow";
                AnchorPoint = Vector2.new(0.5,0.5);
                Position = UDim2.new(0.5,0,0.5,0);
                Size = UDim2.new(1,0,1,5);
                BorderSizePixel = 0;
                CornerRadius = UDim.new(0,5);
                BackgroundColor3 = Library["theme"]["BrighterMainColor"];
                BackgroundTransparency = 0;
                ZIndex = 1;
            })

            Tween(BackgroundFlow,0.5,{BackgroundTransparency = 0})
            Tween(SecondLabel,0.5,{TextTransparency = 0})
            Tween(TitleLabel,0.5,{TextTransparency = 0})
            return TitleLabel;
        end
        return inlogs;
    end
    spawn(function()
        wait()
        SaveProperties(game.CoreGui.Ocerlib,allproperties)
        Main.Visible = false
        for c,x in next,allproperties do
            for b,n in next,allproperties[c] do
                c[b] = 1
            end
        end
        wait(0.1)
        screeng.Enabled = true
        Main.Visible = true
        Main:TweenSize(UDim2.new(0,x,0,y),"Out","Quart",1,true)
        for c,x in next,allproperties do
            for b,n in next,allproperties[c] do
                Tween(c,1,{[b] = n})
            end
        end
        Main.Changed:Connect(function(property)
            if tostring(property) == "BackgroundTransparency" and Main.BackgroundTransparency == 1 then
                Main.Visible = false
            end
        end)
        spawn(function()
            while task.wait(0.05) do
                if Main.BackgroundTransparency == 0 then
                    allproperties = {}
                    SaveProperties(game.CoreGui:FindFirstChild("Ocerlib"),allproperties)
                    if not game.CoreGui:FindFirstChild("Ocerlib") then
                        break;
                    end
                end
            end
        end)
    end)
    return inmain;
end
function Library.ChangeTheme()
    for i,v in next,screeng:GetDescendants() do
        for ind,color in next,Library["theme"] do
            print(ind)
            if v.BackgroundColor3 and Library["theme"][ind] == v.BackgroundColor3 then
                print(color)
            end
        end
    end
end
return Library;
