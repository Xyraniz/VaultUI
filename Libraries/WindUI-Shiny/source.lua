local WindUIModules = { cache = {} }
do
    do
        local function buildModule()
            local b = (cloneref or clonereference or function(b)
                return b
            end)

            local d = b(game:GetService('ReplicatedStorage'):WaitForChild('GetIcons', 99999):InvokeServer())

            local function parseIconString(e)
                if type(e) == 'string' then
                    local f = e:find(':')
                    if f then
                        local g = e:sub(1, f - 1)
                        local h = e:sub(f + 1)
                        return g, h
                    end
                end
                return nil, e
            end

            function d.AddIcons(e, f)
                if type(e) ~= 'string' or type(f) ~= 'table' then
                    error('AddIcons: packName must be string, iconsData must be table')
                    return
                end

                if not d.Icons[e] then
                    d.Icons[e] = {
                        Icons = {},
                        Spritesheets = {},
                    }
                end

                for g, h in pairs(f) do
                    if type(h) == 'number' or (type(h) == 'string' and h:match('^rbxassetid://')) then
                        local i = h
                        if type(h) == 'number' then
                            i = 'rbxassetid://' .. tostring(h)
                        end

                        d.Icons[e].Icons[g] = {
                            Image = i,
                            ImageRectSize = Vector2.new(0, 0),
                            ImageRectPosition = Vector2.new(0, 0),
                            Parts = nil,
                        }
                        d.Icons[e].Spritesheets[i] = i
                    elseif type(h) == 'table' then
                        if h.Image and h.ImageRectSize and h.ImageRectPosition then
                            local i = h.Image
                            if type(i) == 'number' then
                                i = 'rbxassetid://' .. tostring(i)
                            end

                            d.Icons[e].Icons[g] = {
                                Image = i,
                                ImageRectSize = h.ImageRectSize,
                                ImageRectPosition = h.ImageRectPosition,
                                Parts = h.Parts,
                            }

                            if not d.Icons[e].Spritesheets[i] then
                                d.Icons[e].Spritesheets[i] = i
                            end
                        else
                            warn("AddIcons: Invalid spritesheet data format for icon '" .. g .. "'")
                        end
                    else
                        warn("AddIcons: Unsupported data type for icon '" .. g .. "': " .. type(h))
                    end
                end
            end

            function d.SetIconsType(e)
                d.IconsType = e
            end

            local e
            function d.Init(f, g)
                d.New = f
                d.IconThemeTag = g

                e = f
                return d
            end

            function d.Icon(f, g, h)
                h = h ~= false
                local i, j = parseIconString(f)

                local l = i or g or d.IconsType
                local m = j

                local p = d.Icons[l]

                if p and p.Icons and p.Icons[m] then
                    return {
                        p.Spritesheets[tostring(p.Icons[m].Image)],
                        p.Icons[m],
                    }
                elseif p and p[m] and string.find(p[m], 'rbxassetid://') then
                    return h and {
                        p[m],
                        { ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) },
                    } or p[m]
                end
                return nil
            end

            function d.GetIcon(f, g)
                return d.Icon(f, g, false)
            end

            function d.Icon2(f, g, h)
                return d.Icon(f, g, true)
            end

            function d.Image(f)
                local g = {
                    Icon = f.Icon or nil,
                    Type = f.Type,
                    Colors = f.Colors or { (d.IconThemeTag or Color3.new(1, 1, 1)), Color3.new(1, 1, 1) },
                    Transparency = f.Transparency or { 0, 0 },
                    Size = f.Size or UDim2.new(0, 24, 0, 24),

                    IconFrame = nil,
                }

                local h = {}
                local i = {}

                for j, l in next, g.Colors do
                    h[j] = {
                        ThemeTag = typeof(l) == 'string' and l,
                        Color = typeof(l) == 'Color3' and l,
                    }
                end

                for j, l in next, g.Transparency do
                    i[j] = {
                        ThemeTag = typeof(l) == 'string' and l,
                        Value = typeof(l) == 'number' and l,
                    }
                end

                local j = d.Icon2(g.Icon, g.Type)
                local l = typeof(j) == 'string' and string.find(j, 'rbxassetid://')

                if d.New then
                    local m = e or d.New

                    local p = m('ImageLabel', {
                        Size = g.Size,
                        BackgroundTransparency = 1,
                        ImageColor3 = h[1].Color or nil,
                        ImageTransparency = i[1].Value or nil,
                        ThemeTag = h[1].ThemeTag and {
                            ImageColor3 = h[1].ThemeTag,
                            ImageTransparency = i[1].ThemeTag,
                        },
                        Image = l and j or j[1],
                        ImageRectSize = l and nil or j[2].ImageRectSize,
                        ImageRectOffset = l and nil or j[2].ImageRectPosition,
                    })

                    if not l and j[2].Parts then
                        for r, u in next, j[2].Parts do
                            local v = d.Icon(u, g.Type)

                            m('ImageLabel', {
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                ImageColor3 = h[1 + r].Color or nil,
                                ImageTransparency = i[1 + r].Value or nil,
                                ThemeTag = h[1 + r].ThemeTag
                                    and {
                                        ImageColor3 = h[1 + r].ThemeTag,
                                        ImageTransparency = i[1 + r].ThemeTag,
                                    },
                                Image = v[1],
                                ImageRectSize = v[2].ImageRectSize,
                                ImageRectOffset = v[2].ImageRectPosition,
                                Parent = p,
                            })
                        end
                    end

                    g.IconFrame = p
                else
                    local m = Instance.new('ImageLabel')
                    m.Size = g.Size
                    m.BackgroundTransparency = 1
                    m.ImageColor3 = h[1].Color
                    m.ImageTransparency = i[1].Value or nil
                    m.Image = l and j or j[1]
                    m.ImageRectSize = l and nil or j[2].ImageRectSize
                    m.ImageRectOffset = l and nil or j[2].ImageRectPosition

                    if not l and j[2].Parts then
                        for p, r in next, j[2].Parts do
                            local u = d.Icon(r, g.Type)

                            local v = Instance.New('ImageLabel')
                            v.Size = UDim2.new(1, 0, 1, 0)
                            v.BackgroundTransparency = 1
                            v.ImageColor3 = h[1 + p].Color
                            v.ImageTransparency = i[1 + p].Value or nil
                            v.Image = u[1]
                            v.ImageRectSize = u[2].ImageRectSize
                            v.ImageRectOffset = u[2].ImageRectPosition
                            v.Parent = m
                        end
                    end

                    g.IconFrame = m
                end

                return g
            end

            return d
        end
        function WindUIModules.IconModule(): typeof(buildModule())
            local cacheEntry = WindUIModules.cache.IconModule
            if not cacheEntry then
                cacheEntry = { value = buildModule() }
                WindUIModules.cache.IconModule = cacheEntry
            end
            return cacheEntry.value
        end
    end
    do
        local function buildModule()
            return {

                Primary = 'Icon',

                White = Color3.new(1, 1, 1),
                Black = Color3.new(0, 0, 0),

                Dialog = 'Accent',

                Background = 'Accent',
                BackgroundTransparency = 0,
                Hover = 'Text',

                PanelBackground = 'White',
                PanelBackgroundTransparency = 0.95,

                WindowBackground = 'Background',

                WindowShadow = 'Black',

                WindowTopbarTitle = 'Text',
                WindowTopbarAuthor = 'Text',
                WindowTopbarIcon = 'Icon',
                WindowTopbarButtonIcon = 'Icon',

                WindowSearchBarBackground = 'Background',

                TabBackground = 'Hover',
                TabBackgroundHover = 'Hover',
                TabBackgroundHoverTransparency = 0.97,
                TabBackgroundActive = 'Hover',
                TabBackgroundActiveTransparency = 0.93,
                TabText = 'Text',
                TabTextTransparency = 0.3,
                TabTextTransparencyActive = 0,
                TabTitle = 'Text',
                TabIcon = 'Icon',
                TabIconTransparency = 0.4,
                TabIconTransparencyActive = 0.1,
                TabBorderTransparency = 1,
                TabBorderTransparencyActive = 0.75,
                TabBorder = 'White',

                ElementBackground = 'Text',
                ElementTitle = 'Text',
                ElementDesc = 'Text',
                ElementIcon = 'Icon',

                PopupBackground = 'Background',
                PopupBackgroundTransparency = 'BackgroundTransparency',
                PopupTitle = 'Text',
                PopupContent = 'Text',
                PopupIcon = 'Icon',

                DialogBackground = 'Background',
                DialogBackgroundTransparency = 'BackgroundTransparency',
                DialogTitle = 'Text',
                DialogContent = 'Text',
                DialogIcon = 'Icon',

                Toggle = 'Button',
                ToggleBar = 'White',

                Checkbox = 'Primary',
                CheckboxIcon = 'White',
                CheckboxBorder = 'White',
                CheckboxBorderTransparency = 0.75,

                SliderIcon = 'Icon',

                Slider = 'Primary',
                SliderThumb = 'White',
                SliderIconFrom = 'SliderIcon',
                SliderIconTo = 'SliderIcon',

                Tooltip = Color3.fromHex('4C4C4C'),
                TooltipText = 'White',
                TooltipSecondary = 'Primary',
                TooltipSecondaryText = 'White',

                SectionExpandIcon = 'White',
                SectionExpandIconTransparency = 0.4,
                SectionTitle = 'Text',
                SectionDesc = 'Text',
                SectionIcon = 'Icon',
                SectionIconBackground = 'White',
                SectionIconBackgroundTransparency = 0.92,
                SectionCounterBackground = 'White',
                SectionCounterBackgroundTransparency = 0.88,
                SectionCounterText = 'Text',
                SectionContentDivider = 'White',
                SectionContentDividerTransparency = 0.86,
                SectionBox = 'White',
                SectionBoxTransparency = 0.95,
                SectionBoxBorder = 'White',
                SectionBoxBorderTransparency = 0.75,
                SectionBoxBackground = 'White',
                SectionBoxBackgroundTransparency = 0.95,

                SearchBarBorder = 'White',
                SearchBarBorderTransparency = 0.75,

                Notification = 'Background',
                NotificationTitle = 'Text',
                NotificationTitleTransparency = 0,
                NotificationContent = 'Text',
                NotificationContentTransparency = 0.4,
                NotificationDuration = 'White',
                NotificationDurationTransparency = 0.95,
                NotificationBorder = 'White',
                NotificationBorderTransparency = 0.75,

                DropdownTabBorder = 'White',

                LabelBackground = 'White',
                LabelBackgroundTransparency = 0.95,
            }
        end
        function WindUIModules.Creator(): typeof(buildModule())
            local cacheEntry = WindUIModules.cache.Creator
            if not cacheEntry then
                cacheEntry = { value = buildModule() }
                WindUIModules.cache.Creator = cacheEntry
            end
            return cacheEntry.value
        end
    end
    do
        local function buildModule()
            local b = (cloneref or clonereference or function(b)
                return b
            end)

            local d = b(game:GetService('RunService'))
            local e = b(game:GetService('UserInputService'))
            local f = b(game:GetService('TweenService'))
            local g = b(game:GetService('LocalizationService'))
            local h = b(game:GetService('HttpService'))
            local i = 
d.Heartbeat

            local j = 'https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua'

            local l
            if d:IsStudio() or not writefile then
                l = WindUIModules.IconModule()
            else
                l = loadstring(game.HttpGetAsync and game:HttpGetAsync(j) or h:GetAsync(j))()
            end

            l.SetIconsType('lucide')

            local m

            local p = {
                Font = 'rbxassetid://12187365364',
                Localization = nil,
                CanDraggable = true,
                Theme = nil,
                Themes = nil,
                Icons = l,
                Signals = {},
                Objects = {},
                LocalizationObjects = {},
                FontObjects = {},
                Language = string.match(g.SystemLocaleId, '^[a-z]+'),
                Request = http_request or (syn and syn.request) or request,
                DefaultProperties = {
                    ScreenGui = {
                        ResetOnSpawn = false,
                        ZIndexBehavior = 'Sibling',
                    },
                    CanvasGroup = {
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                    },
                    Frame = {
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                    },
                    TextLabel = {
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BorderSizePixel = 0,
                        Text = '',
                        RichText = true,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 14,
                    },
                    TextButton = {
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BorderSizePixel = 0,
                        Text = '',
                        AutoButtonColor = false,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 14,
                    },
                    TextBox = {
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BorderColor3 = Color3.new(0, 0, 0),
                        ClearTextOnFocus = false,
                        Text = '',
                        TextColor3 = Color3.new(0, 0, 0),
                        TextSize = 14,
                    },
                    ImageLabel = {
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BorderSizePixel = 0,
                    },
                    ImageButton = {
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                    },
                    UIListLayout = {
                        SortOrder = 'LayoutOrder',
                    },
                    ScrollingFrame = {
                        ScrollBarImageTransparency = 1,
                        BorderSizePixel = 0,
                    },
                    VideoFrame = {
                        BorderSizePixel = 0,
                    },
                },
                Colors = {
                    Red = '#e53935',
                    Orange = '#f57c00',
                    Green = '#43a047',
                    Blue = '#039be5',
                    White = '#ffffff',
                    Grey = '#484848',
                },
                ThemeFallbacks = WindUIModules.Creator(),
                Shapes = {
                    Square = 'rbxassetid://82909646051652',
                    ['Square-Outline'] = 'rbxassetid://72946211851948',
                    Squircle = 
'rbxassetid://80999662900595',
                    SquircleOutline = 'rbxassetid://117788349049947',
                    ['Squircle-Outline'] = 'rbxassetid://117817408534198',
                    SquircleOutline2 = 
'rbxassetid://117817408534198',

                    ['Shadow-sm'] = 'rbxassetid://84825982946844',

                    ['Squircle-TL-TR'] = 'rbxassetid://73569156276236',
                    ['Squircle-BL-BR'] = 'rbxassetid://93853842912264',
                    ['Squircle-TL-TR-Outline'] = 'rbxassetid://136702870075563',
                    ['Squircle-BL-BR-Outline'] = 'rbxassetid://75035847706564',

                    ['Glass-0.7'] = 'rbxassetid://79047752995006',
                    ['Glass-1'] = 'rbxassetid://97324581055162',
                    ['Glass-1.4'] = 'rbxassetid://95071123641270',
                },
            }

            function p.Init(r)
                m = r
            end

            function p.AddSignal(r, u)
                if not r or typeof(r.Connect) ~= 'function' then
                    return nil
                end

                local v = r:Connect(u)
                table.insert(p.Signals, v)
                return v
            end

            function p.DisconnectAll()
                for r = #p.Signals, 1, -1 do
                    local u = p.Signals[r]
                    p.Signals[r] = nil

                    if u and u.Connected then
                        u:Disconnect()
                    elseif u and u.Disconnect then
                        u:Disconnect()
                    end
                end
            end

            function p.SafeCallback(r, ...)
                if not r then
                    return
                end

                local u, v = pcall(r, ...)
                if not u then
                    if m and m.Window and m.Window.Debug then
                        local x, z = v:find(':%d+: ')

                        warn('[ WindUI: DEBUG Mode ] ' .. v)

                        return m:Notify({
                            Title = 'DEBUG Mode: Error',
                            Content = not z and v or v:sub(z + 1),
                            Duration = 8,
                        })
                    end
                end
            end

            function p.Gradient(r, u)
                if m and m.Gradient then
                    return m:Gradient(r, u)
                end

                local v = {}
                local x = {}

                for z, A in next, r do
                    local B = tonumber(z)
                    if B then
                        B = math.clamp(B / 100, 0, 1)
                        table.insert(v, ColorSequenceKeypoint.new(B, A.Color))
                        table.insert(x, NumberSequenceKeypoint.new(B, A.Transparency or 0))
                    end
                end

                table.sort(v, function(z, A)
                    return z.Time < A.Time
                end)
                table.sort(x, function(z, A)
                    return z.Time < A.Time
                end)

                if #v < 2 then
                    error('ColorSequence requires at least 2 keypoints')
                end

                local z = {
                    Color = ColorSequence.new(v),
                    Transparency = NumberSequence.new(x),
                }

                if u then
                    for A, B in pairs(u) do
                        z[A] = B
                    end
                end

                return z
            end

            function p.SetTheme(r)
                p.Theme = r
                p.UpdateTheme(nil, false)
            end

            function p.AddFontObject(r)
                table.insert(p.FontObjects, r)
                r.FontFace = Font.new(p.Font, r.FontFace.Weight, r.FontFace.Style)
            end

            function p.UpdateFont(r)
                p.Font = r
                for u, v in next, p.FontObjects do
                    v.FontFace = Font.new(r, v.FontFace.Weight, v.FontFace.Style)
                end
            end

            function p.GetThemeProperty(r, u)
                local function getValue(v, x)
                    local z = x[v]

                    if z == nil then
                        return nil
                    end

                    if typeof(z) == 'string' and string.sub(z, 1, 1) == '#' then
                        return Color3.fromHex(z)
                    end

                    if typeof(z) == 'Color3' then
                        return z
                    end

                    if typeof(z) == 'number' then
                        return z
                    end

                    if typeof(z) == 'table' and z.Color and z.Transparency then
                        return z
                    end

                    if typeof(z) == 'function' then
                        return z()
                    end

                    return z
                end

                local v = getValue(r, u)
                if v ~= nil then
                    if typeof(v) == 'string' and string.sub(v, 1, 1) ~= '#' then
                        local x = p.GetThemeProperty(v, u)
                        if x ~= nil then
                            return x
                        end
                    else
                        return v
                    end
                end

                local x = p.ThemeFallbacks[r]
                if x ~= nil then
                    if typeof(x) == 'string' and string.sub(x, 1, 1) ~= '#' then
                        return p.GetThemeProperty(x, u)
                    else
                        return getValue(r, { [r] = x })
                    end
                end

                v = getValue(r, p.Themes.Dark)
                if v ~= nil then
                    if typeof(v) == 'string' and string.sub(v, 1, 1) ~= '#' then
                        local z = p.GetThemeProperty(v, p.Themes.Dark)
                        if z ~= nil then
                            return z
                        end
                    else
                        return v
                    end
                end

                if x ~= nil then
                    if typeof(x) == 'string' and string.sub(x, 1, 1) ~= '#' then
                        return p.GetThemeProperty(x, p.Themes.Dark)
                    else
                        return getValue(r, { [r] = x })
                    end
                end

                return nil
            end

            function p.AddThemeObject(r, u)
                if p.Objects[r] then
                    for v, x in pairs(u) do
                        p.Objects[r].Properties[v] = x
                    end
                else
                    p.Objects[r] = { Object = r, Properties = u }
                end

                p.UpdateTheme(r, false)
                return r
            end

            function p.AddLangObject(r)
                local u = p.LocalizationObjects[r]
                if not u then
                    return
                end

                local v = u.Object

                p.SetLangForObject(r)

                return v
            end

            function p.UpdateTheme(r, u, v, x, z, A)
                local function ApplyTheme(B)
                    for C, F in pairs(B.Properties or {}) do
                        local G = p.GetThemeProperty(F, p.Theme)
                        if G ~= nil then
                            if typeof(G) == 'Color3' then
                                local H = B.Object:FindFirstChild('LibraryGradient')
                                if H then
                                    H:Destroy()
                                end

                                if v then
                                    p.Tween(
                                        B.Object,
                                        x or 0.2,
                                        { [C] = G },
                                        z or Enum.EasingStyle.Quint,
                                        A or Enum.EasingDirection.Out
                                    ):Play()
                                elseif u then
                                    p.Tween(B.Object, 0.08, { [C] = G }):Play()
                                else
                                    B.Object[C] = G
                                end
                            elseif typeof(G) == 'table' and G.Color and G.Transparency then
                                B.Object[C] = Color3.new(1, 1, 1)

                                local H = B.Object:FindFirstChild('LibraryGradient')
                                if not H then
                                    H = Instance.new('UIGradient')
                                    H.Name = 'LibraryGradient'
                                    H.Parent = B.Object
                                end

                                H.Color = G.Color
                                H.Transparency = G.Transparency

                                for J, L in pairs(G) do
                                    if J ~= 'Color' and J ~= 'Transparency' and H[J] ~= nil then
                                        H[J] = L
                                    end
                                end
                            elseif typeof(G) == 'number' then
                                if v then
                                    p.Tween(
                                        B.Object,
                                        x or 0.2,
                                        { [C] = G },
                                        z or Enum.EasingStyle.Quint,
                                        A or Enum.EasingDirection.Out
                                    ):Play()
                                elseif u then
                                    p.Tween(B.Object, 0.08, { [C] = G }):Play()
                                else
                                    B.Object[C] = G
                                end
                            end
                        else
                            local H = B.Object:FindFirstChild('LibraryGradient')
                            if H then
                                H:Destroy()
                            end
                        end
                    end
                end

                if r then
                    local B = p.Objects[r]
                    if B then
                        ApplyTheme(B)
                    end
                else
                    for B, C in pairs(p.Objects) do
                        ApplyTheme(C)
                    end
                end
            end

            function p.SetThemeTag(r, u, v, x, z)
                p.AddThemeObject(r, u)
                p.UpdateTheme(r, false, true, v, x, z)
            end

            function p.SetLangForObject(r)
                if p.Localization and p.Localization.Enabled then
                    local u = p.LocalizationObjects[r]
                    if not u then
                        return
                    end

                    local v = u.Object
                    local x = u.TranslationId

                    local z = p.Localization.Translations[p.Language]
                    if z and z[x] then
                        v.Text = z[x]
                    else
                        local A = p.Localization and p.Localization.Translations and p.Localization.Translations.en
                            or nil
                        if A and A[x] then
                            v.Text = A[x]
                        else
                            v.Text = '[' .. x .. ']'
                        end
                    end
                end
            end

            function p.ChangeTranslationKey(r, u, v)
                if p.Localization and p.Localization.Enabled then
                    local x = string.match(v, '^' .. p.Localization.Prefix .. '(.+)')
                    if x then
                        for z, A in ipairs(p.LocalizationObjects) do
                            if A.Object == u then
                                A.TranslationId = x
                                p.SetLangForObject(z)
                                return
                            end
                        end

                        table.insert(p.LocalizationObjects, {
                            TranslationId = x,
                            Object = u,
                        })
                        p.SetLangForObject(#p.LocalizationObjects)
                    end
                end
            end

            function p.UpdateLang(r)
                if r then
                    p.Language = r
                end

                for u = 1, #p.LocalizationObjects do
                    local v = p.LocalizationObjects[u]
                    if v.Object and v.Object.Parent ~= nil then
                        p.SetLangForObject(u)
                    else
                        p.LocalizationObjects[u] = nil
                    end
                end
            end

            function p.SetLanguage(r)
                p.Language = r
                p.UpdateLang()
            end

            function p.Icon(r, u)
                return l.Icon2(r, nil, u ~= false)
            end

            function p.AddIcons(r, u)
                return l.AddIcons(r, u)
            end

            function p.New(r, u, v)
                local x = Instance.new(r)

                for z, A in next, p.DefaultProperties[r] or {} do
                    x[z] = A
                end

                for z, A in next, u or {} do
                    if z ~= 'ThemeTag' then
                        x[z] = A
                    end
                    if p.Localization and p.Localization.Enabled and z == 'Text' then
                        local B = string.match(A, '^' .. p.Localization.Prefix .. '(.+)')
                        if B then
                            local C = #p.LocalizationObjects + 1
                            p.LocalizationObjects[C] = { TranslationId = B, Object = x }

                            p.SetLangForObject(C)
                        end
                    end
                end

                for z, A in next, v or {} do
                    A.Parent = x
                end

                if u and u.ThemeTag then
                    p.AddThemeObject(x, u.ThemeTag)
                end
                if u and u.FontFace then
                    p.AddFontObject(x)
                end
                return x
            end

            function p.Tween(r, u, v, ...)
                return f:Create(r, TweenInfo.new(u, ...), v)
            end

            function p.NewRoundFrame(r, u, v, x, z, A)
                local function getImageForType(B)
                    return p.Shapes[B]
                end

                local function getSliceCenterForType(B)
                    return not table.find({ 'Shadow-sm', 'Glass-0.7', 'Glass-1', 'Glass-1.4' }, B)
                            and Rect.new(256, 256, 256, 256
)
                        or Rect.new(512, 512, 512, 512)
                end

                local B = p.New(z and 'ImageButton' or 'ImageLabel', {
                    Image = getImageForType(u),
                    ScaleType = 'Slice',
                    SliceCenter = getSliceCenterForType(u),
                    SliceScale = 1,
                    BackgroundTransparency = 1,
                    ThemeTag = v.ThemeTag and v.ThemeTag,
                }, x)

                for C, F in pairs(v or {}) do
                    if C ~= 'ThemeTag' then
                        B[C] = F
                    end
                end

                local function UpdateSliceScale(C)
                    local F = not table.find({ 'Shadow-sm', 'Glass-0.7', 'Glass-1', 'Glass-1.4' }, u) and (C / 256)
                        or (C / 512)
                    B.SliceScale = math.max(F, 0.0001)
                end

                local C = {}

                function C.SetRadius(F, G)
                    UpdateSliceScale(G)
                end

                function C.SetType(F, G)
                    u = G
                    B.Image = getImageForType(G)
                    B.SliceCenter = getSliceCenterForType(G)
                    UpdateSliceScale(r)
                end

                function C.UpdateShape(F, G, H)
                    if H then
                        u = H
                        B.Image = getImageForType(H)
                        B.SliceCenter = getSliceCenterForType(H)
                    end
                    if G then
                        r = G
                    end
                    UpdateSliceScale(r)
                end

                function C.GetRadius(F)
                    return r
                end

                function C.GetType(F)
                    return u
                end

                UpdateSliceScale(r)

                return B, A and C or nil
            end

            local r = p.New
            local u = p.Tween

            function p.SetDraggable(v)
                p.CanDraggable = v
            end

            function p.Drag(v, x, z)
                local A
                local B, C, F
                local G = {
                    CanDraggable = true,
                }

                if not x or typeof(x) ~= 'table' then
                    x = { v }
                end

                local function update(H)
                    if not B or not G.CanDraggable then
                        return
                    end
                    if not F or not C then
                        return
                    end

                    local J = H.Position - C
                    p.Tween(v, 0.02, { Position = UDim2.new(F.X.Scale, F.X.Offset + J.X, F.Y.Scale, F.Y.Offset + J.Y) })
                        :Play()
                end

                for H, J in pairs(x) do
                    p.AddSignal(J.InputBegan, function(L)
                        if
                            (
                                L.UserInputType == Enum.UserInputType.MouseButton1
                                or L.UserInputType == Enum.UserInputType.Touch
                            ) and G.CanDraggable
                        then
                            if A == nil then
                                A = J
                                B = true
                                C = L.Position
                                F = v.Position or UDim2.new(0.5, 0, 0.5, 0)

                                if z and typeof(z) == 'function' then
                                    z(true, A)
                                end

                                p.AddSignal(L.Changed, function()
                                    if L.UserInputState == Enum.UserInputState.End then
                                        B = false
                                        A = nil

                                        if z and typeof(z) == 'function' then
                                            z(false, nil)
                                        end
                                    end
                                end)
                            end
                        end
                    end)

                    p.AddSignal(J.InputChanged, function(L)
                        if B and A == J then
                            if
                                L.UserInputType == Enum.UserInputType.MouseMovement
                                or L.UserInputType == Enum.UserInputType.Touch
                            then
                                update(L)
                            end
                        end
                    end)
                end

                p.AddSignal(e.InputChanged, function(H)
                    if B and A ~= nil then
                        if
                            H.UserInputType == Enum.UserInputType.MouseMovement
                            or H.UserInputType == Enum.UserInputType.Touch
                        then
                            update(H)
                        end
                    end
                end)

                function G.Set(H, J)
                    G.CanDraggable = J
                end

                return G
            end

            l.Init(r, 'Icon')

            function p.SanitizeFilename(v)
                local x = v:match('([^/]+)$') or v

                x = x:gsub('%.[^%.]+$', '')

                x = x:gsub('[^%w%-_]', '_')

                if #x > 50 then
                    x = x:sub(1, 50)
                end

                return x
            end

            function p.Image(v, x, z, A, B, C, F, G)
                A = A or 'Temp'
                x = p.SanitizeFilename(x)

                local H = r('Frame', {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                }, {
                    r('ImageLabel', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        ScaleType = 'Crop',
                        ThemeTag = (p.Icon(v) or F) and {
                            ImageColor3 = C and (G or 'Icon') or nil,
                        } or nil,
                    }, {
                        r('UICorner', {
                            CornerRadius = UDim.new(0, z),
                        }),
                    }),
                })
                if p.Icon(v) then
                    H.ImageLabel:Destroy()

                    local J = l.Image({
                        Icon = v,
                        Size = UDim2.new(1, 0, 1, 0),
                        Colors = {
                            (C and (G or 'Icon') or false),
                            'Button',
                        },
                    }).IconFrame
                    J.Parent = H
                elseif string.find(v, 'http') then
                    local J = 'WindUI_SY/' .. A .. '/assets/.' .. B .. '-' .. x .. '.png'
                    local L, M = pcall(function()
                        task.spawn(function()
                            local L = p.Request and p.Request({
                                Url = v,
                                Method = 'GET',
                            }).Body or {}

                            if not d:IsStudio() and writefile then
                                writefile(J, L)
                            end

                            local M, N = pcall(getcustomasset, J)
                            if M then
                                H.ImageLabel.Image = N
                            else
                                warn(
                                    string.format(
                                        "[ WindUI.Creator ] Failed to load custom asset '%s': %s",
                                        J,
                                        tostring(N)
                                    )
                                )
                                H:Destroy()

                                return
                            end
                        end)
                    end)
                    if not L then
                        local N = (identifyexecutor and identifyexecutor()) or 'Studio'
                        warn("[ WindUI.Creator ]  '" .. N .. "' doesnt support the URL Images. Error: " .. tostring(M))

                        H:Destroy()
                    end
                elseif v == '' then
                    H.Visible = false
                else
                    H.ImageLabel.Image = v
                end

                return H
            end

            function p.Color3ToHSB(v)
                local x, z, A = v.R, v.G, v.B
                local B = math.max(x, z, A)
                local C = math.min(x, z, A)
                local F = B - C

                local G = 0
                if F ~= 0 then
                    if B == x then
                        G = (z - A) / F % 6
                    elseif B == z then
                        G = (A - x) / F + 2
                    else
                        G = (x - z) / F + 4
                    end
                    G = G * 60
                else
                    G = 0
                end

                local H = (B == 0) and 0 or (F / B)
                local J = B

                return {
                    h = math.floor(G + 0.5),
                    s = H,
                    b = J,
                }
            end

            function p.GetPerceivedBrightness(v)
                local x = v.R
                local z = v.G
                local A = v.B
                return 0.299 * x + 0.587 * z + 0.114 * A
            end

            function p.GetTextColorForHSB(v, x)
                local z = p.Color3ToHSB(v)
                local A, B, C = z.h, z.s, z.b
                if p.GetPerceivedBrightness(v) > (x or 0.5) then
                    return Color3.fromHSV(A / 360, 0, 0.05)
                else
                    return Color3.fromHSV(A / 360, 0, 0.98)
                end
            end

            function p.GetAverageColor(v)
                local x, z, A = 0, 0, 0
                local B = v.Color.Keypoints
                for C, F in ipairs(B) do
                    x = x + F.Value.R
                    z = z + F.Value.G
                    A = A + F.Value.B
                end
                local C = #B
                return Color3.new(x / C, z / C, A / C)
            end

            function p.GenerateUniqueID(v)
                return h:GenerateGUID(false)
            end

            return p
        end
        function WindUIModules.LocalizationModule(): typeof(buildModule())
            local cacheEntry = WindUIModules.cache.LocalizationModule
            if not cacheEntry then
                cacheEntry = { value = buildModule() }
                WindUIModules.cache.LocalizationModule = cacheEntry
            end
            return cacheEntry.value
        end
    end
    do
        local function buildModule()
            local b = {}

            function b.New(d, e, f)
                local g = {
                    Enabled = e.Enabled or false,
                    Translations = e.Translations or {},
                    Prefix = e.Prefix or 'loc:',
                    DefaultLanguage = e.DefaultLanguage or 'en',
                }

                f.Localization = g

                return g
            end

            return b
        end
        function WindUIModules.ButtonModule(): typeof(buildModule())
            local cacheEntry = WindUIModules.cache.ButtonModule
            if not cacheEntry then
                cacheEntry = { value = buildModule() }
                WindUIModules.cache.ButtonModule = cacheEntry
            end
            return cacheEntry.value
        end
    end
    do
        local function buildModule()
            local b = {}

            local d = WindUIModules.LocalizationModule()
            local e = d.New
            local f = d.Tween

            function b.New(g, h, j, l, m, p, r, u)
                l = l or 'Primary'
                local v = u or (not r and 10 or 99)
                local x
                if h and h ~= '' then
                    x = e('ImageLabel', {
                        Image = d.Icon(h)[1],
                        ImageRectSize = d.Icon(h)[2].ImageRectSize,
                        ImageRectOffset = d.Icon(h)[2].ImageRectPosition,
                        Size = UDim2.new(0, 21, 0, 21),
                        BackgroundTransparency = 1,
                        ImageColor3 = l == 'White' and Color3.new(0, 0, 0) or nil,
                        ImageTransparency = l == 'White' and 0.4 or 0,
                        ThemeTag = {
                            ImageColor3 = l ~= 'White' and 'Icon' or nil,
                        },
                    })
                end

                local z = e('TextButton', {
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = 'X',
                    Parent = m,
                    BackgroundTransparency = 1,
                }, {
                    d.NewRoundFrame(v, 'Squircle', {
                        ThemeTag = {
                            ImageColor3 = l ~= 'White' and 'Button' or nil,
                        },
                        ImageColor3 = l == 'White' and Color3.new(1, 1, 1) or nil,
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Squircle',
                        ImageTransparency = l == 'Primary' and 0 or l == 'White' and 0 or 1,
                    }),

                    d.NewRoundFrame(v, 'Squircle', {

                        ImageColor3 = Color3.new(1, 1, 1),
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Special',
                        ImageTransparency = l == 'Secondary' and 0.95 or 1,
                    }),

                    d.NewRoundFrame(v, 'Shadow-sm', {

                        ImageColor3 = Color3.new(0, 0, 0),
                        Size = UDim2.new(1, 3, 1, 3),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Name = 'Shadow',

                        ImageTransparency = 1,
                        Visible = not r,
                    }),

                    d.NewRoundFrame(v, not r and 'Glass-1' or 'Glass-0.7', {
                        ThemeTag = {
                            ImageColor3 = 'White',
                        },
                        Size = UDim2.new(1, 0, 1, 0),

                        ImageTransparency = 0.6,
                        Name = 'Outline',
                    }, {}),

                    d.NewRoundFrame(v, 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Frame',
                        ThemeTag = {
                            ImageColor3 = l ~= 'White' and 'Text' or nil,
                        },
                        ImageColor3 = l == 'White' and Color3.new(0, 0, 0) or nil,
                        ImageTransparency = 1,
                    }, {
                        e('UIPadding', {
                            PaddingLeft = UDim.new(0, 16),
                            PaddingRight = UDim.new(0, 16),
                        }),
                        e('UIListLayout', {
                            FillDirection = 'Horizontal',
                            Padding = UDim.new(0, 8),
                            VerticalAlignment = 'Center',
                            HorizontalAlignment = 'Center',
                        }),
                        x,
                        e('TextLabel', {
                            BackgroundTransparency = 1,
                            FontFace = Font.new(d.Font, Enum.FontWeight.SemiBold),
                            Text = g or 'Button',
                            ThemeTag = {
                                TextColor3 = (l ~= 'Primary' and l ~= 'White') and 'Text',
                            },
                            TextColor3 = l == 'Primary' and Color3.new(1, 1, 1)
                                or l == 'White' and Color3.new(0, 0, 0)
                                or nil,
                            AutomaticSize = 'XY',
                            TextSize = 18,
                        }),
                    }),
                })

                d.AddSignal(z.MouseEnter, function()
                    f(z.Frame, 0.047, { ImageTransparency = 0.95 }):Play()
                end)
                d.AddSignal(z.MouseLeave, function()
                    f(z.Frame, 0.047, { ImageTransparency = 1 }):Play()
                end)
                d.AddSignal(z.MouseButton1Up, function()
                    if p then
                        p:Close()()
                    end
                    if j then
                        d.SafeCallback(j)
                    end
                end)

                return z
            end

            return b
        end
        function WindUIModules.NotificationModule(): typeof(buildModule())
            local cacheEntry = WindUIModules.cache.NotificationModule
            if not cacheEntry then
                cacheEntry = { value = buildModule() }
                WindUIModules.cache.NotificationModule = cacheEntry
            end
            return cacheEntry.value
        end
    end
    do
        local function buildModule()
            local b = WindUIModules.LocalizationModule()
            local d = b.New
            local e = b.Tween
            local f = WindUIModules.NotificationModule().New

            local g = {
                Size = UDim2.new(0, 300, 1, -156),
                SizeLower = UDim2.new(0, 300, 1, -56),
                UICorner = 18,
                UIPadding = 14,

                Holder = nil,
                NotificationIndex = 0,
                Notifications = {},
            }

            local function NormalizeButtonLayout(h)
                if typeof(h) ~= 'string' then
                    return 'Auto'
                end

                local j = string.lower(h)
                if j == 'horizontal' then
                    return 'Horizontal'
                end
                if j == 'vertical' then
                    return 'Vertical'
                end

                return 'Auto'
            end

            local function ResolveHorizontalAlignment(h)
                if typeof(h) ~= 'string' then
                    return Enum.HorizontalAlignment.Right
                end

                local j = string.lower(h)
                if j == 'left' then
                    return Enum.HorizontalAlignment.Left
                end
                if j == 'center' then
                    return Enum.HorizontalAlignment.Center
                end

                return Enum.HorizontalAlignment.Right
            end

            function g.Init(h)
                local j = {
                    Lower = false,
                }

                function j.SetLower(l)
                    j.Lower = l
                    j.Frame.Size = l and g.SizeLower or g.Size
                end

                j.Frame = d('Frame', {
                    Position = UDim2.new(1, -29, 0, 56),
                    AnchorPoint = Vector2.new(1, 0),
                    Size = g.Size,
                    Parent = h,
                    BackgroundTransparency = 1,
                }, {
                    d('UIListLayout', {
                        HorizontalAlignment = 'Center',
                        SortOrder = 'LayoutOrder',
                        VerticalAlignment = 'Bottom',
                        Padding = UDim.new(0, 8),
                    }),
                    d('UIPadding', {
                        PaddingBottom = UDim.new(0, 29),
                    }),
                })
                return j
            end

            function g.New(h)
                h = typeof(h) == 'table' and h or {}

                local j = {
                    Title = h.Title or 'Notification',
                    Content = h.Content or nil,
                    Icon = h.Icon or nil,
                    IconThemed = h.IconThemed,
                    Background = h.Background,
                    BackgroundImageTransparency = h.BackgroundImageTransparency,
                    Duration = h.Duration == nil and 5 or h.Duration,
                    Buttons = h.Buttons or {},
                    CanClose = h.CanClose ~= false,
                    ButtonLayout = NormalizeButtonLayout(h.ButtonLayout or h.ButtonsLayout),
                    ButtonAlignment = ResolveHorizontalAlignment(h.ButtonAlignment or h.ButtonsAlignment),
                    ButtonHeight = typeof(h.ButtonHeight) == 'number' and math.max(28, h.ButtonHeight) or 40,
                    ButtonPadding = typeof(h.ButtonPadding) == 'number' and math.max(0, h.ButtonPadding) or 6,
                    ButtonDebounce = h.ButtonDebounce ~= false,
                    ButtonCooldown = typeof(h.ButtonCooldown) == 'number' and math.max(0, h.ButtonCooldown) or 0.12,
                    UIElements = {},
                    Closed = false,
                }

                g.NotificationIndex = g.NotificationIndex + 1
                j.Index = g.NotificationIndex
                g.Notifications[j.Index] = j

                local l

                if j.Icon then
                    l = b.Image(j.Icon, j.Title .. ':' .. j.Icon, 0, h.Window, 'Notification', j.IconThemed)
                    l.Size = UDim2.new(0, 26, 0, 26)
                    l.Position = UDim2.new(0, g.UIPadding, 0, g.UIPadding)
                end

                local m
                if j.CanClose then
                    m = d('ImageButton', {
                        Image = b.Icon('x')[1],
                        ImageRectSize = b.Icon('x')[2].ImageRectSize,
                        ImageRectOffset = b.Icon('x')[2].ImageRectPosition,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(1, -g.UIPadding, 0, g.UIPadding),
                        AnchorPoint = Vector2.new(1, 0),
                        ThemeTag = {
                            ImageColor3 = 'Text',
                        },
                        ImageTransparency = 0.4,
                    }, {
                        d('TextButton', {
                            Size = UDim2.new(1, 8, 1, 8),
                            BackgroundTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Text = '',
                        }),
                    })
                end

                local p = b.NewRoundFrame(g.UICorner, 'Squircle', {
                    Size = UDim2.new(0, 0, 1, 0),
                    ThemeTag = {
                        ImageTransparency = 'NotificationDurationTransparency',
                        ImageColor3 = 'NotificationDuration',
                    },
                })

                local r = d('Frame', {
                    Size = UDim2.new(1, j.Icon and -28 - g.UIPadding or 0, 1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = 'Y',
                }, {
                    d('UIPadding', {
                        PaddingTop = UDim.new(0, g.UIPadding),
                        PaddingLeft = UDim.new(0, g.UIPadding),
                        PaddingRight = UDim.new(0, g.UIPadding),
                        PaddingBottom = UDim.new(0, g.UIPadding),
                    }),
                    d('TextLabel', {
                        AutomaticSize = 'Y',
                        Size = UDim2.new(1, -30 - g.UIPadding, 0, 0),
                        TextWrapped = true,
                        TextXAlignment = 'Left',
                        RichText = true,
                        BackgroundTransparency = 1,
                        TextSize = 18,
                        LayoutOrder = 1,
                        ThemeTag = {
                            TextColor3 = 'NotificationTitle',
                            TextTransparency = 'NotificationTitleTransparency',
                        },
                        Text = j.Title,
                        FontFace = Font.new(b.Font, Enum.FontWeight.SemiBold),
                    }),
                    d('UIListLayout', {
                        Padding = UDim.new(0, g.UIPadding / 3),
                        SortOrder = 'LayoutOrder',
                    }),
                })

                if j.Content then
                    d('TextLabel', {
                        AutomaticSize = 'Y',
                        Size = UDim2.new(1, 0, 0, 0),
                        TextWrapped = true,
                        TextXAlignment = 'Left',
                        RichText = true,
                        BackgroundTransparency = 1,

                        TextSize = 15,
                        LayoutOrder = 2,
                        ThemeTag = {
                            TextColor3 = 'NotificationContent',
                            TextTransparency = 'NotificationContentTransparency',
                        },
                        Text = j.Content,
                        FontFace = Font.new(b.Font, Enum.FontWeight.Medium),
                        Parent = r,
                    })
                end

                local u
                local v
                local x = {}
                if j.Buttons and #j.Buttons > 0 then
                    local z = {}
                    local A = 0
                    local B = d('UIListLayout', {
                        Padding = UDim.new(0, j.ButtonPadding),
                        FillDirection = 'Horizontal',
                        HorizontalAlignment = j.ButtonAlignment,
                        VerticalAlignment = 'Center',
                    })

                    u = d('Frame', {
                        Size = UDim2.new(1, 0, 0, j.ButtonHeight),
                        BackgroundTransparency = 1,
                        AutomaticSize = 'None',
                        LayoutOrder = 3,
                        Parent = r,
                    }, {
                        B,
                    })

                    local function CloseFromButton(C)
                        if typeof(C) == 'number' and C > 0 then
                            task.delay(C, function()
                                if not j.Closed then
                                    j:Close()
                                end
                            end)
                        else
                            j:Close()
                        end
                    end

                    local function ApplyHorizontalLayout()
                        B.FillDirection = Enum.FillDirection.Horizontal
                        B.HorizontalAlignment = j.ButtonAlignment
                        B.VerticalAlignment = Enum.VerticalAlignment.Center
                        u.Size = UDim2.new(1, 0, 0, j.ButtonHeight)
                        u.AutomaticSize = Enum.AutomaticSize.None

                        for C, F in ipairs(z) do
                            local G = F.ButtonFrame
                            if F.Width then
                                G.Size = UDim2.new(0, F.Width, 1, 0)
                                G.AutomaticSize = Enum.AutomaticSize.None
                            else
                                G.Size = UDim2.new(0, 0, 1, 0)
                                G.AutomaticSize = Enum.AutomaticSize.X
                            end
                        end
                    end

                    local function ApplyVerticalLayout()
                        B.FillDirection = Enum.FillDirection.Vertical
                        B.HorizontalAlignment = j.ButtonAlignment
                        B.VerticalAlignment = Enum.VerticalAlignment.Top
                        u.AutomaticSize = Enum.AutomaticSize.Y

                        for C, F in ipairs(z) do
                            local G = F.ButtonFrame
                            G.Size = UDim2.new(1, 0, 0, F.Height)
                            G.AutomaticSize = Enum.AutomaticSize.None
                        end
                    end

                    for C, F in next, j.Buttons do
                        if typeof(F) ~= 'table' then
                            F = {
                                Title = tostring(F),
                            }
                        end

                        local G = {
                            Index = C,
                            Callback = F.Callback,
                            CloseOnClick = F.CloseOnClick ~= false,
                            CloseDelay = typeof(F.CloseDelay) == 'number' and math.max(0, F.CloseDelay) or 0,
                            CloseBeforeCallback = F.CloseBeforeCallback == true,
                            Debounce = F.Debounce == nil and j.ButtonDebounce or F.Debounce == true,
                            Cooldown = typeof(F.Cooldown) == 'number' and math.max(0, F.Cooldown) or j.ButtonCooldown,
                            Disabled = F.Disabled == true,
                            Busy = false,
                            Width = typeof(F.Width) == 'number' and math.max(0, F.Width) or nil,
                            Height = typeof(F.Height) == 'number' and math.max(28, F.Height) or j.ButtonHeight,
                            Visible = F.Visible ~= false,
                            RunAsync = (F.RunAsync == nil and F.Async == nil)
                                or (F.RunAsync ~= false and F.Async ~= false),
                        }

                        local H

                        local function UpdateState()
                            local J = not j.Closed and G.Visible and not G.Disabled and not G.Busy
                            local L = G.ButtonFrame:FindFirstChild('Frame')
                            local M = G.ButtonFrame:FindFirstChild('TextLabel', true)

                            G.ButtonFrame.Active = J
                            G.ButtonFrame.Selectable = J
                            G.ButtonFrame.Visible = G.Visible

                            if L and L:IsA('ImageLabel') then
                                L.ImageTransparency = J and 1 or 0.92
                            end

                            if M and M:IsA('TextLabel') then
                                M.TextTransparency = J and 0 or 0.35
                            end
                        end

                        local function RunButton()
                            if j.Closed or G.Disabled or G.Busy or not G.Visible then
                                return
                            end

                            if G.Debounce then
                                G.Busy = true
                                UpdateState()
                            end

                            local function finish()
                                if not G.Debounce then
                                    return
                                end

                                task.delay(G.Cooldown, function()
                                    G.Busy = false
                                    if G.ButtonFrame.Parent ~= nil then
                                        UpdateState()
                                    end
                                end)
                            end

                            local function callbackFlow()
                                if G.CloseOnClick and G.CloseBeforeCallback then
                                    CloseFromButton(G.CloseDelay)
                                end

                                b.SafeCallback(G.Callback, j, H, G.Index)

                                if G.CloseOnClick and not G.CloseBeforeCallback then
                                    CloseFromButton(G.CloseDelay)
                                end

                                finish()
                            end

                            if G.RunAsync then
                                task.spawn(callbackFlow)
                            else
                                callbackFlow()
                            end
                        end

                        local J = f(F.Title or F.Text, F.Icon, RunButton, F.Variant, u)
                        J.Visible = G.Visible
                        J.LayoutOrder = typeof(F.LayoutOrder) == 'number' and F.LayoutOrder or C

                        G.ButtonFrame = J

                        H = {
                            Index = G.Index,
                            ButtonFrame = J,
                            Click = function()
                                RunButton()
                            end,
                            SetDisabled = function(L, M)
                                G.Disabled = M == true
                                UpdateState()
                            end,
                            SetVisible = function(L, M)
                                G.Visible = M ~= false
                                UpdateState()
                                if v then
                                    v()
                                end
                            end,
                            SetTitle = function(L, M)
                                local N = J:FindFirstChild('TextLabel', true)
                                if N and N:IsA('TextLabel') then
                                    N.Text = tostring(M or 'Button')
                                    if v then
                                        v()
                                    end
                                end
                            end,
                        }

                        UpdateState()
                        table.insert(x, H)
                        table.insert(z, G)

                        b.AddSignal(J:GetPropertyChangedSignal('AbsoluteSize'), function()
                            if v then
                                v()
                            end
                        end)
                    end

                    v = function()
                        if j.Closed or u.Parent == nil then
                            return
                        end

                        A = A + 1
                        local C = A

                        if j.ButtonLayout == 'Vertical' then
                            ApplyVerticalLayout()
                            return
                        end

                        ApplyHorizontalLayout()
                        if j.ButtonLayout == 'Horizontal' then
                            return
                        end

                        task.defer(function()
                            if C ~= A then
                                return
                            end
                            if j.Closed or u.Parent == nil then
                                return
                            end

                            local F = B.AbsoluteContentSize.X
                            local G = u.AbsoluteSize.X
                            if F > G then
                                ApplyVerticalLayout()
                            end
                        end)
                    end
                end

                local z = b.NewRoundFrame(g.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(2, 0, 1, 0),
                    AnchorPoint = Vector2.new(0, 1),
                    AutomaticSize = 'Y',
                    ImageTransparency = 0.05,
                    ThemeTag = {
                        ImageColor3 = 'Notification',
                    },
                }, {
                    b.NewRoundFrame(g.UICorner, 'Glass-1', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = {
                            ImageColor3 = 'NotificationBorder',
                            ImageTransparency = 'NotificationBorderTransparency',
                        },
                    }),
                    d('Frame', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Name = 'DurationFrame',
                    }, {
                        d('Frame', {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            ClipsDescendants = true,
                        }, {
                            p,
                        }),
                    }),
                    d('ImageLabel', {
                        Name = 'Background',
                        Image = j.Background,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        ScaleType = 'Crop',
                        ImageTransparency = j.BackgroundImageTransparency,
                    }, {
                        d('UICorner', {
                            CornerRadius = UDim.new(0, g.UICorner),
                        }),
                    }),

                    r,
                    l,
                    m,
                })

                local A = d('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    Parent = h.Holder,
                }, {
                    z,
                })

                j.UIElements.Main = z
                j.UIElements.MainContainer = A
                j.UIElements.TextContainer = r
                j.UIElements.ButtonsContainer = u
                j.UIElements.Buttons = x
                j.UIElements.CloseButton = m
                j.UIElements.Duration = p
                j.UIElements.Icon = l

                if v and u then
                    b.AddSignal(u:GetPropertyChangedSignal('AbsoluteSize'), v)
                    b.AddSignal(r:GetPropertyChangedSignal('AbsoluteSize'), v)
                    local B = u:FindFirstChildOfClass('UIListLayout')
                    if B then
                        b.AddSignal(B:GetPropertyChangedSignal('AbsoluteContentSize'), v)
                    end
                    task.defer(v)
                end

                function j.Close(B)
                    if not j.Closed then
                        j.Closed = true
                        g.Notifications[j.Index] = nil

                        for C, F in ipairs(x) do
                            if F.SetDisabled then
                                F:SetDisabled(true)
                            end
                        end

                        e(A, 0.45, { Size = UDim2.new(1, 0, 0, -8) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        e(
                            z,
                            0.55,
                            { Position = UDim2.new(2, 0, 1, 0) },
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ):Play()
                        task.wait(0.45)
                        if A.Parent ~= nil then
                            A:Destroy()
                        end
                    end
                end

                task.spawn(function()
                    task.wait()
                    if j.Closed or A.Parent == nil then
                        return
                    end
                    e(
                        A,
                        0.45,
                        { Size = UDim2.new(1, 0, 0, z.AbsoluteSize.Y) },
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ):Play()
                    e(z, 0.45, { Position = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    if j.Duration and not j.Closed then
                        p.Size = UDim2.new(0, z.DurationFrame.AbsoluteSize.X, 1, 0)
                        e(
                            z.DurationFrame.Frame,
                            j.Duration,
                            { Size = UDim2.new(0, 0, 1, 0) },
                            Enum.EasingStyle.Linear,
                            Enum.EasingDirection.InOut
                        ):Play()
                        task.wait(j.Duration)
                        if not j.Closed then
                            j:Close()
                        end
                    end
                end)

                if m then
                    b.AddSignal(m.MouseButton1Click, function()
                        j:Close()
                    end)
                    if m:FindFirstChild('TextButton') then
                        b.AddSignal(m.TextButton.MouseButton1Click, function()
                            j:Close()
                        end)
                    end
                end

                return j
            end

            return g
        end
        function WindUIModules.Sha256Module(): typeof(buildModule())
            local cacheEntry = WindUIModules.cache.Sha256Module
            if not cacheEntry then
                cacheEntry = { value = buildModule() }
                WindUIModules.cache.Sha256Module = cacheEntry
            end
            return cacheEntry.value
        end
    end
    do
        local function buildModule()
            local b = 4294967296
            local d = b - 1
            local function c(e, f)
                local g, h = 0, 1
                while e ~= 0 or f ~= 0 do
                    local j, l = e % 2, f % 2
                    local m = (j + l) % 2
                    g = g + m * h
                    e = math.floor(e / 2)
                    f = math.floor(f / 2)
                    h = h * 2
                end
                return g % b
            end
            local function k(e, f, g, ...)
                local h
                if f then
                    e = e % b
                    f = f % b
                    h = c(e, f)
                    if g then
                        h = k(h, g, ...)
                    end
                    return h
                elseif e then
                    return e % b
                else
                    return 0
                end
            end
            local function n(e, f, g, ...)
                local h
                if f then
                    e = e % b
                    f = f % b
                    h = (e + f - c(e, f)) / 2
                    if g then
                        h = n(h, g, ...)
                    end
                    return h
                elseif e then
                    return e % b
                else
                    return d
                end
            end
            local function o(e)
                return d - e
            end
            local function q(e, f)
                if f < 0 then
                    return lshift(e, -f)
                end
                return math.floor(e % 4294967296 / 2 ^ f)
            end
            local function s(e, f)
                if f > 31 or f < -31 then
                    return 0
                end
                return q(e % b, f)
            end
            local function lshift(e, f)
                if f < 0 then
                    return s(e, -f)
                end
                return e * 2 ^ f % 4294967296
            end
            local function t(e, f)
                e = e % b
                f = f % 32
                local g = n(e, 2 ^ f - 1)
                return s(e, f) + lshift(g, 32 - f)
            end
            local e = {
                0x428a2f98,
                0x71374491,
                0xb5c0fbcf,
                0xe9b5dba5,
                0x3956c25b,
                0x59f111f1,
                0x923f82a4,
                0xab1c5ed5,
                0xd807aa98,
                0x12835b01,
                0x243185be,
                0x550c7dc3,
                0x72be5d74,
                0x80deb1fe,
                0x9bdc06a7,
                0xc19bf174,
                0xe49b69c1,
                0xefbe4786,
                0x0fc19dc6,
                0x240ca1cc,
                0x2de92c6f,
                0x4a7484aa,
                0x5cb0a9dc,
                0x76f988da,
                0x983e5152,
                0xa831c66d,
                0xb00327c8,
                0xbf597fc7,
                0xc6e00bf3,
                0xd5a79147,
                0x06ca6351,
                0x14292967,
                0x27b70a85,
                0x2e1b2138,
                0x4d2c6dfc,
                0x53380d13,
                0x650a7354,
                0x766a0abb,
                0x81c2c92e,
                0x92722c85,
                0xa2bfe8a1,
                0xa81a664b,
                0xc24b8b70,
                0xc76c51a3,
                0xd192e819,
                0xd6990624,
                0xf40e3585,
                0x106aa070,
                0x19a4c116,
                0x1e376c08,
                0x2748774c,
                0x34b0bcb5,
                0x391c0cb3,
                0x4ed8aa4a,
                0x5b9cca4f,
                0x682e6ff3,
                0x748f82ee,
                0x78a5636f,
                0x84c87814,
                0x8cc70208,
                0x90befffa,
                0xa4506ceb,
                0xbef9a3f7,
                0xc67178f2,
            }
            local function w(f)
                return string.gsub(f, '.', function(g)
                    return string.format('%02x', string.byte(g))
                end)
            end
            local function y(f, g)
                local h = ''
                for j = 1, g do
                    local l = f % 256
                    h = string.char(l) .. h
                    f = (f - l) / 256
                end
                return h
            end
            local function D(f, g)
                local h = 0
                for j = g, g + 3 do
                    h = h * 256 + string.byte(f, j)
                end
                return h
            end
            local function E(f, g)
                local h = 64 - (g + 9) % 64
                g = y(8 * g, 8)
                f = f .. '\128' .. string.rep('\0', h) .. g
                assert(#f % 64 == 0)
                return f
            end
            local function I(f)
                f[1] = 0x6a09e667
                f[2] = 0xbb67ae85
                f[3] = 0x3c6ef372
                f[4] = 0xa54ff53a
                f[5] = 0x510e527f
                f[6] = 0x9b05688c
                f[7] = 0x1f83d9ab
                f[8] = 0x5be0cd19
                return f
            end
            local function K(f, g, h)
                local j = {}
                for l = 1, 16 do
                    j[l] = D(f, g + (l - 1) * 4)
                end
                for l = 17, 64 do
                    local m = j[l - 15]
                    local p = k(t(m, 7), t(m, 18), s(m, 3))
                    m = j[l - 2]
                    j[l] = (j[l - 16] + p + j[l - 7] + k(t(m, 17), t(m, 19), s(m, 10))) % b
                end
                local l, m, p, r, u, v, x, z = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]
                for A = 1, 64 do
                    local B = k(t(l, 2), t(l, 13), t(l, 22))
                    local C = k(n(l, m), n(l, p), n(m, p))
                    local F = (B + C) % b
                    local G = k(t(u, 6), t(u, 11), t(u, 25))
                    local H = k(n(u, v), n(o(u), x))
                    local J = (z + G + H + e[A] + j[A]) % b
                    z = x
                    x = v
                    v = u
                    u = (r + J) % b
                    r = p
                    p = m
                    m = l
                    l = (J + F) % b
                end
                h[1] = (h[1] + l) % b
                h[2] = (h[2] + m) % b
                h[3] = (h[3] + p) % b
                h[4] = (h[4] + r) % b
                h[5] = (h[5] + u) % b
                h[6] = (h[6] + v) % b
                h[7] = (h[7] + x) % b
                h[8] = (h[8] + z) % b
            end
            local function Z(f)
                f = E(f, #f)
                local g = I({})
                for h = 1, #f, 64 do
                    K(f, h, g)
                end
                return w(
                    y(g[1], 4)
                        .. y(g[2], 4)
                        .. y(g[3], 4)
                        .. y(g[4], 4)
                        .. y(g[5], 4)
                        .. y(g[6], 4)
                        .. y(g[7], 4)
                        .. y(g[8], 4)
                )
            end
            local f
            local g =
                { ['\\'] = '\\', ['"'] = '"', ['\b'] = 'b', ['\f'] = 'f', ['\n'] = 'n', ['\r'] = 'r', ['\t'] = 't' }
            local h = { ['/'] = '/' }
            for j, l in pairs(g) do
                h[l] = j
            end
            local j = function(j)
                return '\\' .. (g[j] or string.format('u%04x', j:byte()))
            end
            local l = function(l)
                return 'null'
            end
            local m = function(m, p)
                local r = {}
                p = p or {}
                if p[m] then
                    error('circular reference')
                end
                p[m] = true
                if rawget(m, 1) ~= nil or next(m) == nil then
                    local u = 0
                    for v in pairs(m) do
                        if type(v) ~= 'number' then
                            error('invalid table: mixed or invalid key types')
                        end
                        u = u + 1
                    end
                    if u ~= #m then
                        error('invalid table: sparse array')
                    end
                    for v, x in ipairs(m) do
                        table.insert(r, f(x, p))
                    end
                    p[m] = nil
                    return '[' .. table.concat(r, ',') .. ']'
                else
                    for u, v in pairs(m) do
                        if type(u) ~= 'string' then
                            error('invalid table: mixed or invalid key types')
                        end
                        table.insert(r, f(u, p) .. ':' .. f(v, p))
                    end
                    p[m] = nil
                    return '{' .. table.concat(r, ',') .. '}'
                end
            end
            local p = function(p)
                return '"' .. p:gsub('[%z\1-\31\\"]', j) .. '"'
            end
            local r = function(r)
                if r ~= r or r <= -math.huge or r >= math.huge then
                    error("unexpected number value '" .. tostring(r) .. "'")
                end
                return string.format('%.14g', r)
            end
            local u = { ['nil'] = l, table = m, string = p, number = r, boolean = tostring }
            f = function(v, x)
                local z = type(v)
                local A = u[z]
                if A then
                    return A(v, x)
                end
                error("unexpected type '" .. z .. "'")
            end
            local v = function(v)
                return f(v)
            end
            local x
            local z = function(...)
                local z = {}
                for A = 1, select('#', ...) do
                    z[select(A, ...)] = true
                end
                return z
            end
            local A = z(' ', '\t', '\r', '\n')
            local B = z(' ', '\t', '\r', '\n', ']', '}', ',')
            local C = z('\\', '/', '"', 'b', 'f', 'n', 'r', 't', 'u')
            local F = z('true', 'false', 'null')
            local G = { ['true'] = true, ['false'] = false, null = nil }
            local H = function(H, J, L, M)
                for N = J, #H do
                    if L[H:sub(N, N)] ~= M then
                        return N
                    end
                end
                return #H + 1
            end
            local J = function(J, L, M)
                local N = 1
                local O = 1
                for P = 1, L - 1 do
                    O = O + 1
                    if J:sub(P, P) == '\n' then
                        N = N + 1
                        O = 1
                    end
                end
                error(string.format('%s at line %d col %d', M, N, O))
            end
            local L = function(L)
                local M = math.floor
                if L <= 0x7f then
                    return string.char(L)
                elseif L <= 0x7ff then
                    return string.char(M(L / 64) + 192, L % 64 + 128)
                elseif L <= 0xffff then
                    return string.char(M(L / 4096) + 224, M(L % 4096 / 64) + 128, L % 64 + 128)
                elseif L <= 0x10ffff then
                    return string.char(
                        M(L / 262144) + 240,
                        M(L % 262144 / 4096) + 128,
                        M(L % 4096 / 64) + 128,
                        L % 64 + 128
                    )
                end
                error(string.format("invalid unicode codepoint '%x'", L))
            end
            local M = function(M)
                local N = tonumber(M:sub(1, 4), 16)
                local O = tonumber(M:sub(7, 10), 16)
                if O then
                    return L((N - 0xd800) * 0x400 + O - 0xdc00 + 0x10000)
                else
                    return L(N)
                end
            end
            local N = function(N, O)
                local P = ''
                local Q = O + 1
                local R = Q
                while Q <= #N do
                    local S = N:byte(Q)
                    if S < 32 then
                        J(N, Q, 'control character in string')
                    elseif S == 92 then
                        P = P .. N:sub(R, Q - 1)
                        Q = Q + 1
                        local T = N:sub(Q, Q)
                        if T == 'u' then
                            local U = N:match('^[dD][89aAbB]%x%x\\u%x%x%x%x', Q + 1)
                                or N:match('^%x%x%x%x', Q + 1)
                                or J(N, Q - 1, 'invalid unicode escape in string')
                            P = P .. M(U)
                            Q = Q + #U
                        else
                            if not C[T] then
                                J(N, Q - 1, "invalid escape char '" .. T .. "' in string")
                            end
                            P = P .. h[T]
                        end
                        R = Q + 1
                    elseif S == 34 then
                        P = P .. N:sub(R, Q - 1)
                        return P, Q + 1
                    end
                    Q = Q + 1
                end
                J(N, O, 'expected closing quote for string')
            end
            local O = function(O, P)
                local Q = H(O, P, B)
                local R = O:sub(P, Q - 1)
                local S = tonumber(R)
                if not S then
                    J(O, P, "invalid number '" .. R .. "'")
                end
                return S, Q
            end
            local P = function(P, Q)
                local R = H(P, Q, B)
                local S = P:sub(Q, R - 1)
                if not F[S] then
                    J(P, Q, "invalid literal '" .. S .. "'")
                end
                return G[S], R
            end
            local Q = function(Q, R)
                local S = {}
                local T = 1
                R = R + 1
                while 1 do
                    local U
                    R = H(Q, R, A, true)
                    if Q:sub(R, R) == ']' then
                        R = R + 1
                        break
                    end
                    U, R = x(Q, R)
                    S[T] = U
                    T = T + 1
                    R = H(Q, R, A, true)
                    local V = Q:sub(R, R)
                    R = R + 1
                    if V == ']' then
                        break
                    end
                    if V ~= ',' then
                        J(Q, R, "expected ']' or ','")
                    end
                end
                return S, R
            end
            local R = function(R, S)
                local T = {}
                S = S + 1
                while 1 do
                    local U, V
                    S = H(R, S, A, true)
                    if R:sub(S, S) == '}' then
                        S = S + 1
                        break
                    end
                    if R:sub(S, S) ~= '"' then
                        J(R, S, 'expected string for key')
                    end
                    U, S = x(R, S)
                    S = H(R, S, A, true)
                    if R:sub(S, S) ~= ':' then
                        J(R, S, "expected ':' after key")
                    end
                    S = H(R, S + 1, A, true)
                    V, S = x(R, S)
                    T[U] = V
                    S = H(R, S, A, true)
                    local W = R:sub(S, S)
                    S = S + 1
                    if W == '}' then
                        break
                    end
                    if W ~= ',' then
                        J(R, S, "expected '}' or ','")
                    end
                end
                return T, S
            end
            local S = {
                ['"'] = N,
                ['0'] = O,
                ['1'] = O,
                ['2'] = O,
                ['3'] = O,
                ['4'] = O,
                ['5'] = O,
                ['6'] = O,
                ['7'] = O,
                ['8'] = O,
                ['9'] = O,
                ['-'] = O,
                t = P,
                f = P,
                n = P,
                ['['] = Q,
                ['{'] = R,
            }
            x = function(T, U)
                local V = T:sub(U, U)
                local W = S[V]
                if W then
                    return W(T, U)
                end
                J(T, U, "unexpected character '" .. V .. "'")
            end
            local T = function(T)
                if type(T) ~= 'string' then
                    error('expected argument of type string, got ' .. type(T))
                end
                local U, V = x(T, H(T, 1, A, true))
                V = H(T, V, A, true)
                if V <= #T then
                    J(T, V, 'trailing garbage')
                end
                return U
            end
            local U, V, W = v, T, Z

            local X = {}

            local Y = (cloneref or clonereference or function(Y)
                return Y
            end)

            function X.New(_, aa)
                local ab = _
                local ac = aa
                local ad = true

                local ae = function(ae) end

                repeat
                    task.wait(1)
                until game:IsLoaded()

                local af = false
                local ag, ah, ai, aj, ak, al, am, an, ao =
                    setclipboard or toclipboard,
                    request or http_request or syn_request,
                    string.char,
                    tostring,
                    string.sub,
                    os.time,
                    math.random,
                    math.floor,
                    gethwid or function()
                        return Y(game:GetService('Players')).LocalPlayer.UserId
                    end
                local ap, aq = '', 0

                local ar = 'https://api.platoboost.app'
                local as = ah({
                    Url = ar .. '/public/connectivity',
                    Method = 'GET',
                })
                if as.StatusCode ~= 200 and as.StatusCode ~= 429 then
                    ar = 'https://api.platoboost.net'
                end

                function cacheLink()
                    if aq + 600 < al() then
                        local at = ah({
                            Url = ar .. '/public/start',
                            Method = 'POST',
                            Body = U({
                                service = ab,
                                identifier = W(ao()),
                            }),
                            Headers = {
                                ['Content-Type'] = 'application/json',
                                ['User-Agent'] = 'Roblox/Exploit',
                            },
                        })

                        if at.StatusCode == 200 then
                            local au = V(at.Body)

                            if au.success == true then
                                ap = au.data.url
                                aq = al()
                                return true, ap
                            else
                                ae(au.message)
                                return false, au.message
                            end
                        elseif at.StatusCode == 429 then
                            local au = 'you are being rate limited, please wait 20 seconds and try again.'
                            ae(au)
                            return false, au
                        end

                        local au = 'Failed to cache link.'
                        ae(au)
                        return false, au
                    else
                        return true, ap
                    end
                end

                cacheLink()

                local at = function()
                    local at = ''
                    for au = 1, 16 do
                        at = at .. ai(an(am() * 26) + 97)
                    end
                    return at
                end

                for au = 1, 5 do
                    local av = at()
                    task.wait(0.2)
                    if at() == av then
                        local aw = 'platoboost nonce error.'
                        ae(aw)
                        error(aw)
                    end
                end

                local au = function()
                    local au, av = cacheLink()

                    if au then
                        ag(av)
                    end
                end

                local av = function(av)
                    local aw = at()
                    local ax = ar .. '/public/redeem/' .. aj(ab)

                    local ay = {
                        identifier = W(ao()),
                        key = av,
                    }

                    if ad then
                        ay.nonce = aw
                    end

                    local az = ah({
                        Url = ax,
                        Method = 'POST',
                        Body = U(ay),
                        Headers = {
                            ['Content-Type'] = 'application/json',
                        },
                    })

                    if az.StatusCode == 200 then
                        local aA = V(az.Body)

                        if aA.success == true then
                            if aA.data.valid == true then
                                if ad then
                                    if aA.data.hash == W('true' .. '-' .. aw .. '-' .. ac) then
                                        return true
                                    else
                                        ae('failed to verify integrity.')
                                        return false
                                    end
                                else
                                    return true
                                end
                            else
                                ae('key is invalid.')
                                return false
                            end
                        else
                            if ak(aA.message, 1, 27) == 'unique constraint violation' then
                                ae('you already have an active key, please wait for it to expire before redeeming it.')
                                return false
                            else
                                ae(aA.message)
                                return false
                            end
                        end
                    elseif az.StatusCode == 429 then
                        ae('you are being rate limited, please wait 20 seconds and try again.')
                        return false
                    else
                        ae('server returned an invalid status code, please try again later.')
                        return false
                    end
                end

                local aw = function(aw)
                    if af == true then
                        return false, 'A request is already being sent, please slow down.'
                    else
                        af = true
                    end

                    local ax = at()
                    local ay = ar .. '/public/whitelist/' .. aj(ab) .. '?identifier=' .. W(ao()) .. '&key=' .. aw

                    if ad then
                        ay = ay .. '&nonce=' .. ax
                    end

                    local az = ah({
                        Url = ay,
                        Method = 'GET',
                    })

                    af = false

                    if az.StatusCode == 200 then
                        local aA = V(az.Body)

                        if aA.success == true then
                            if aA.data.valid == true then
                                if ad then
                                    if aA.data.hash == W('true' .. '-' .. ax .. '-' .. ac) then
                                        return true, ''
                                    else
                                        return false, 'failed to verify integrity.'
                                    end
                                else
                                    return true
                                end
                            else
                                if ak(aw, 1, 4) == 'KEY_' then
                                    return true, av(aw)
                                else
                                    return false, 'Key is invalid.'
                                end
                            end
                        else
                            return false, aA.message
                        end
                    elseif az.StatusCode == 429 then
                        return false, 'You are being rate limited, please wait 20 seconds and try again.'
                    else
                        return false, 'Server returned an invalid status code, please try again later.'
                    end
                end

                local ax = function(ax)
                    local ay = at()
                    local az = ar .. '/public/flag/' .. aj(ab) .. '?name=' .. ax

                    if ad then
                        az = az .. '&nonce=' .. ay
                    end

                    local aA = ah({
                        Url = az,
                        Method = 'GET',
                    })

                    if aA.StatusCode == 200 then
                        local aB = V(aA.Body)

                        if aB.success == true then
                            if ad then
                                if aB.data.hash == W(aj(aB.data.value) .. '-' .. ay .. '-' .. ac) then
                                    return aB.data.value
                                else
                                    ae('failed to verify integrity.')
                                    return nil
                                end
                            else
                                return aB.data.value
                            end
                        else
                            ae(aB.message)
                            return nil
                        end
                    else
                        return nil
                    end
                end

                return {
                    Verify = aw,
                    GetFlag = ax,
                    Copy = au,
                }
            end

            return X
        end
        function WindUIModules.PlatoboostService(): typeof(buildModule())
            local aa = WindUIModules.cache.PlatoboostService
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.PlatoboostService = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ab = aa(game:GetService('HttpService'))
            local ac = {}

            function ac.New(ad)
                local ae = gethwid or function()
                    return aa(game:GetService('Players')).LocalPlayer.UserId
                end
                local af, ag = request or http_request or syn_request, setclipboard or toclipboard

                function ValidateKey(ah)
                    local ai = 'https://pandadevelopment.net/v2_validation?key='
                        .. tostring(ah)
                        .. '&service='
                        .. tostring(ad)
                        .. '&hwid='
                        .. tostring(ae())

                    local aj, ak = pcall(function()
                        return af({
                            Url = ai,
                            Method = 'GET',
                            Headers = { ['User-Agent'] = 'Roblox/Exploit' },
                        })
                    end)

                    if aj and ak then
                        if ak.Success then
                            local al, am = pcall(function()
                                return ab:JSONDecode(ak.Body)
                            end)

                            if al and am then
                                if am.V2_Authentication and am.V2_Authentication == 'success' then
                                    return true, 'Authenticated'
                                else
                                    local an = am.Key_Information.Notes or 'Unknown reason'

                                    return false, 'Authentication failed: ' .. an
                                end
                            else
                                return false, 'JSON decode error'
                            end
                        else
                            warn(
                                '[Pelinda Ov2.5] HTTP request was not successful. Code: '
                                    .. tostring(ak.StatusCode)
                                    .. ' Message: '
                                    .. ak.StatusMessage
                            )
                            return false, 'HTTP request failed: ' .. ak.StatusMessage
                        end
                    else
                        return false, 'Request pcall error'
                    end
                end

                function GetKeyLink()
                    return 'https://pandadevelopment.net/getkey?service=' .. tostring(ad) .. '&hwid=' .. tostring(ae())
                end

                function CopyLink()
                    return ag(GetKeyLink())
                end

                return {
                    Verify = ValidateKey,
                    Copy = CopyLink,
                }
            end

            return ac
        end
        function WindUIModules.PandaDevelopmentService(): typeof(buildModule())
            local aa = WindUIModules.cache.PandaDevelopmentService
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.PandaDevelopmentService = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            function aa.New(ab, ac)
                local ad = 'https://sdkapi-public.luarmor.net/library.lua'

                local ae = loadstring(game.HttpGetAsync and game:HttpGetAsync(ad) or HttpService:GetAsync(ad))()
                local af = setclipboard or toclipboard

                ae.script_id = ab

                function ValidateKey(ag)
                    local ah = ae.check_key(ag)

                    if ah.code == 'KEY_VALID' then
                        return true, 'Whitelisted!'
                    elseif ah.code == 'KEY_HWID_LOCKED' then
                        return false, 'Key linked to a different HWID. Please reset it using our bot'
                    elseif ah.code == 'KEY_INCORRECT' then
                        return false, 'Key is wrong or deleted!'
                    else
                        return false, 'Key check failed:' .. ah.message .. ' Code: ' .. ah.code
                    end
                end

                function CopyLink()
                    af(tostring(ac))
                end

                return {
                    Verify = ValidateKey,
                    Copy = CopyLink,
                }
            end

            return aa
        end
        function WindUIModules.LuarmorService(): typeof(buildModule())
            local aa = WindUIModules.cache.LuarmorService
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.LuarmorService = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            function aa.New(ab, ac, ad)
                JunkieProtected.API_KEY = ac
                JunkieProtected.PROVIDER = ad
                JunkieProtected.SERVICE_ID = ab

                local function ValidateKey(ae)
                    if not ae or ae == '' then
                        print('No key provided!')

                        return false, 'No key provided. Please get a key.'
                    end

                    local af = JunkieProtected.IsKeylessMode()
                    if af and af.keyless_mode then
                        print('Keyless mode enabled. Starting script...')
                        return true, 'Keyless mode enabled. Starting script...'
                    end

                    local ag = JunkieProtected.ValidateKey({ Key = ae })
                    if ag == 'valid' then
                        print('Key is valid! Starting script...')
                        load()
                        if _G.JD_IsPremium then
                            print('Premium user detected!')
                        else
                            print('Standard user')
                        end

                        return true, 'Key is valid!'
                    else
                        local ah = JunkieProtected.GetKeyLink()
                        print('Invalid key!')

                        return false, 'Invalid key. Get one from:' .. ah
                    end
                end

                local function copyLink()
                    local ae = JunkieProtected.GetKeyLink()

                    if setclipboard then
                        setclipboard(ae)
                    end
                end
                return {
                    Verify = ValidateKey,
                    Copy = copyLink,
                }
            end

            return aa
        end
        function WindUIModules.JunkieDevelopmentService(): typeof(buildModule())
            local aa = WindUIModules.cache.JunkieDevelopmentService
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.JunkieDevelopmentService = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            return {
                platoboost = {
                    Name = 'Platoboost',
                    Icon = 'rbxassetid://75920162824531',
                    Args = { 'ServiceId', 'Secret' },

                    New = WindUIModules.PlatoboostService().New,
                },
                pandadevelopment = {
                    Name = 'Panda Development',
                    Icon = 'panda',
                    Args = { 'ServiceId' },

                    New = WindUIModules.PandaDevelopmentService().New,
                },
                luarmor = {
                    Name = 'Luarmor',
                    Icon = 'rbxassetid://130918283130165',
                    Args = { 'ScriptId', 'Discord' },

                    New = WindUIModules.LuarmorService().New,
                },
                junkiedevelopment = {
                    Name = 'Junkie Development',
                    Icon = 'rbxassetid://106310347705078',
                    Args = { 'ServiceId', 'ApiKey', 'Provider' },

                    New = WindUIModules.JunkieDevelopmentService().New,
                },
            }
        end
        function WindUIModules.KeySystemServices(): typeof(buildModule())
            local aa = WindUIModules.cache.KeySystemServices
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.KeySystemServices = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            function aa.New(ae, af, ag, ah, ai, aj, ak, al)
                ah = ah or 'Input'
                local am = ak or 10
                local an
                if af and af ~= '' then
                    an = ac('ImageLabel', {
                        Image = ab.Icon(af)[1],
                        ImageRectSize = ab.Icon(af)[2].ImageRectSize,
                        ImageRectOffset = ab.Icon(af)[2].ImageRectPosition,
                        Size = UDim2.new(0, 21, 0, 21),
                        BackgroundTransparency = 1,
                        ThemeTag = {
                            ImageColor3 = 'Icon',
                        },
                    })
                end

                local ao = ah ~= 'Input'

                local ap = ac('TextBox', {
                    BackgroundTransparency = 1,
                    TextSize = 17,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Regular),
                    Size = UDim2.new(1, an and -29 or 0, 1, 0),
                    PlaceholderText = ae,
                    ClearTextOnFocus = al or false,
                    ClipsDescendants = true,
                    TextWrapped = ao,
                    MultiLine = ao,
                    TextXAlignment = 'Left',
                    TextYAlignment = ah == 'Input' and 'Center' or 'Top',

                    ThemeTag = {
                        PlaceholderColor3 = 'PlaceholderText',
                        TextColor3 = 'Text',
                    },
                })

                local aq = ac('Frame', {
                    Size = UDim2.new(1, 0, 0, 42),
                    Parent = ag,
                    BackgroundTransparency = 1,
                }, {
                    ac('Frame', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                    }, {
                        ab.NewRoundFrame(am, 'Squircle', {
                            ThemeTag = {
                                ImageColor3 = 'Accent',
                            },
                            Size = UDim2.new(1, 0, 1, 0),
                            ImageTransparency = 0.97,
                        }),
                        ab.NewRoundFrame(am, 'Glass-1', {
                            ThemeTag = {
                                ImageColor3 = 'Outline',
                            },
                            Size = UDim2.new(1, 0, 1, 0),
                            ImageTransparency = 0.75,
                        }, {}),
                        ab.NewRoundFrame(am, 'Squircle', {
                            Size = UDim2.new(1, 0, 1, 0),
                            Name = 'Frame',
                            ImageColor3 = Color3.new(1, 1, 1),
                            ImageTransparency = 0.95,
                        }, {
                            ac('UIPadding', {
                                PaddingTop = UDim.new(0, ah == 'Input' and 0 or 12),
                                PaddingLeft = UDim.new(0, 12),
                                PaddingRight = UDim.new(0, 12),
                                PaddingBottom = UDim.new(0, ah == 'Input' and 0 or 12),
                            }),
                            ac('UIListLayout', {
                                FillDirection = 'Horizontal',
                                Padding = UDim.new(0, 8),
                                VerticalAlignment = ah == 'Input' and 'Center' or 'Top',
                                HorizontalAlignment = 'Left',
                            }),
                            an,
                            ap,
                        }),
                    }),
                })

                if aj then
                    ab.AddSignal(ap:GetPropertyChangedSignal('Text'), function()
                        if ai then
                            ab.SafeCallback(ai, ap.Text)
                        end
                    end)
                else
                    ab.AddSignal(ap.FocusLost, function()
                        if ai then
                            ab.SafeCallback(ai, ap.Text)
                        end
                    end)
                end

                return aq
            end

            return aa
        end
        function WindUIModules.PopupModule(): typeof(buildModule())
            local aa = WindUIModules.cache.PopupModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.PopupModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ab = aa.New
            local ac = aa.Tween

            local ad

            local ae = {
                Holder = nil,

                Parent = nil,
            }

            function ae.Init(af, ag)
                ad = af
                ae.Parent = ag
                return ae
            end

            function ae.Create(af, ag)
                local ah = {
                    UICorner = 28,
                    UIPadding = 12,
                    UIElements = {},
                }

                if af then
                    ah.UIPadding = 0
                end
                if af then
                    ah.UICorner = 26
                end

                ag = ag or 'Dialog'

                if not af then
                    ah.UIElements.FullScreen = ab('Frame', {
                        ZIndex = 999,
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromHex('#000000'),
                        Size = UDim2.new(1, 0, 1, 0),
                        Active = false,
                        Visible = false,
                        Parent = ae.Parent or (ad and ad.UIElements and ad.UIElements.Main and ad.UIElements.Main.Main),
                    }, {
                        ab('UICorner', {
                            CornerRadius = UDim.new(0, ad.UICorner),
                        }),
                    })
                end

                ah.UIElements.Main = ab('Frame', {
                    Size = UDim2.new(0, 280, 0, 0),
                    ThemeTag = {
                        BackgroundColor3 = ag .. 'Background',
                    },
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                    Visible = false,
                    ZIndex = 99999,
                }, {
                    ab('UIPadding', {
                        PaddingTop = UDim.new(0, ah.UIPadding),
                        PaddingLeft = UDim.new(0, ah.UIPadding),
                        PaddingRight = UDim.new(0, ah.UIPadding),
                        PaddingBottom = UDim.new(0, ah.UIPadding),
                    }),
                })

                ah.UIElements.MainContainer = aa.NewRoundFrame(ah.UICorner, 'Squircle', {
                    Visible = false,

                    ImageTransparency = af and 0.15 or 0,
                    Parent = af and ae.Parent or ah.UIElements.FullScreen,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = 'XY',
                    ThemeTag = {
                        ImageColor3 = ag .. 'Background',
                        ImageTransparency = ag .. 'BackgroundTransparency',
                    },
                    ZIndex = 9999,
                }, {

                    ah.UIElements.Main,
                })

                function ah.Open(ai)
                    if not af then
                        ah.UIElements.FullScreen.Visible = true
                        ah.UIElements.FullScreen.Active = true
                    end

                    task.spawn(function()
                        ah.UIElements.MainContainer.Visible = true

                        if not af then
                            ac(ah.UIElements.FullScreen, 0.1, { BackgroundTransparency = 0.3 }):Play()
                        end
                        ac(ah.UIElements.MainContainer, 0.1, { ImageTransparency = 0 }):Play()

                        task.spawn(function()
                            task.wait(0.05)
                            ah.UIElements.Main.Visible = true
                        end)
                    end)
                end
                function ah.Close(ai)
                    if not af then
                        ac(ah.UIElements.FullScreen, 0.1, { BackgroundTransparency = 1 }):Play()
                        ah.UIElements.FullScreen.Active = false
                        task.spawn(function()
                            task.wait(0.1)
                            ah.UIElements.FullScreen.Visible = false
                        end)
                    end
                    ah.UIElements.Main.Visible = false

                    ac(ah.UIElements.MainContainer, 0.1, { ImageTransparency = 1 }):Play()

                    task.spawn(function()
                        task.wait(0.1)
                        if not af then
                            ah.UIElements.FullScreen:Destroy()
                        else
                            ah.UIElements.MainContainer:Destroy()
                        end
                    end)

                    return function() end
                end

                return ah
            end

            return ae
        end
        function WindUIModules.DialogModule(): typeof(buildModule())
            local aa = WindUIModules.cache.DialogModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.DialogModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            local ae = WindUIModules.NotificationModule().New
            local af = WindUIModules.PopupModule().New
            local ag = setclipboard or toclipboard

            function aa.new(ah, ai, aj, ak)
                local al = WindUIModules.DialogModule().Init(nil, ah.WindUI.ScreenGui.KeySystem)
                local am = al.Create(true)

                local an = {}

                local ao

                local ap = (ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Width) or 200

                local aq = 430
                if ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Image then
                    aq = 430 + (ap / 2)
                end

                am.UIElements.Main.AutomaticSize = 'Y'
                am.UIElements.Main.Size = UDim2.new(0, aq, 0, 0)

                local ar

                if ah.Icon then
                    ar = ab.Image(ah.Icon, ah.Title .. ':' .. ah.Icon, 0, 'Temp', 'KeySystem', ah.IconThemed)
                    ar.Size = UDim2.new(0, 24, 0, 24)
                    ar.LayoutOrder = -1
                end

                local as = ac('TextLabel', {
                    AutomaticSize = 'XY',
                    BackgroundTransparency = 1,
                    Text = ah.KeySystem.Title or ah.Title,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.SemiBold),
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    TextSize = 20,
                })

                local at = ac('TextLabel', {
                    AutomaticSize = 'XY',
                    BackgroundTransparency = 1,
                    Text = 'Key System',
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    TextTransparency = 1,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    TextSize = 16,
                })

                local au = ac('Frame', {
                    BackgroundTransparency = 1,
                    AutomaticSize = 'XY',
                }, {
                    ac('UIListLayout', {
                        Padding = UDim.new(0, 14),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                    }),
                    ar,
                    as,
                })

                local av = ac('Frame', {
                    AutomaticSize = 'Y',
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                }, {

                    au,
                    at,
                })

                local aw = af('Enter Key', 'key', nil, 'Input', function(aw)
                    ao = aw
                end)

                local ax
                if ah.KeySystem.Note and ah.KeySystem.Note ~= '' then
                    ax = ac('TextLabel', {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                        TextXAlignment = 'Left',
                        Text = ah.KeySystem.Note,
                        TextSize = 18,
                        TextTransparency = 0.4,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        BackgroundTransparency = 1,
                        RichText = true,
                        TextWrapped = true,
                    })
                end

                local ay = ac('Frame', {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundTransparency = 1,
                }, {
                    ac('Frame', {
                        BackgroundTransparency = 1,
                        AutomaticSize = 'X',
                        Size = UDim2.new(0, 0, 1, 0),
                    }, {
                        ac('UIListLayout', {
                            Padding = UDim.new(0, 9),
                            FillDirection = 'Horizontal',
                        }),
                    }),
                })

                local az
                if ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Image then
                    local aA
                    if ah.KeySystem.Thumbnail.Title then
                        aA = ac('TextLabel', {
                            Text = ah.KeySystem.Thumbnail.Title,
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                            TextSize = 18,
                            FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                            BackgroundTransparency = 1,
                            AutomaticSize = 'XY',
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                        })
                    end
                    az = ac('ImageLabel', {
                        Image = ah.KeySystem.Thumbnail.Image,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, ap, 1, -12),
                        Position = UDim2.new(0, 6, 0, 6),
                        Parent = am.UIElements.Main,
                        ScaleType = 'Crop',
                    }, {
                        aA,
                        ac('UICorner', {
                            CornerRadius = UDim.new(0, 20),
                        }),
                    })
                end

                ac('Frame', {

                    Size = UDim2.new(1, az and -ap or 0, 1, 0),
                    Position = UDim2.new(0, az and ap or 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = am.UIElements.Main,
                }, {
                    ac('Frame', {

                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                    }, {
                        ac('UIListLayout', {
                            Padding = UDim.new(0, 18),
                            FillDirection = 'Vertical',
                        }),
                        av,
                        ax,
                        aw,
                        ay,
                        ac('UIPadding', {
                            PaddingTop = UDim.new(0, 16),
                            PaddingLeft = UDim.new(0, 16),
                            PaddingRight = UDim.new(0, 16),
                            PaddingBottom = UDim.new(0, 16),
                        }),
                    }),
                })

                local aA = ae('Exit', 'log-out', function()
                    am:Close()()
                end, 'Tertiary', ay.Frame)

                if az then
                    aA.Parent = az
                    aA.Size = UDim2.new(0, 0, 0, 42)
                    aA.Position = UDim2.new(0, 10, 1, -10)
                    aA.AnchorPoint = Vector2.new(0, 1)
                end

                if ah.KeySystem.URL then
                    ae('Get key', 'key', function()
                        if ag then
                            ag(ah.KeySystem.URL)
                        else
                            ah.WindUI:Notify({
                                Title = 'Key System. Error',
                                Content = 'Clipboard API is not available in this executor.',
                                Icon = 'triangle-alert',
                            })
                        end
                    end, 'Secondary', ay.Frame)
                end

                if ah.KeySystem.API then
                    local aB = 240
                    local b = false
                    local d = ae('Get key', 'key', nil, 'Secondary', ay.Frame)

                    local f = ab.NewRoundFrame(99, 'Squircle', {
                        Size = UDim2.new(0, 1, 1, 0),
                        ThemeTag = {
                            ImageColor3 = 'Text',
                        },
                        ImageTransparency = 0.9,
                    })

                    ac('Frame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 1, 0),
                        AutomaticSize = 'X',
                        Parent = d.Frame,
                    }, {
                        f,
                        ac('UIPadding', {
                            PaddingLeft = UDim.new(0, 5),
                            PaddingRight = UDim.new(0, 5),
                        }),
                    })

                    local g = ab.Image('chevron-down', 'chevron-down', 0, 'Temp', 'KeySystem', true)

                    g.Size = UDim2.new(1, 0, 1, 0)

                    ac('Frame', {
                        Size = UDim2.new(0, 21, 0, 21),
                        Parent = d.Frame,
                        BackgroundTransparency = 1,
                    }, {
                        g,
                    })

                    local h = ab.NewRoundFrame(15, 'Squircle', {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        ThemeTag = {
                            ImageColor3 = 'Background',
                        },
                    }, {
                        ac('UIPadding', {
                            PaddingTop = UDim.new(0, 5),
                            PaddingLeft = UDim.new(0, 5),
                            PaddingRight = UDim.new(0, 5),
                            PaddingBottom = UDim.new(0, 5),
                        }),
                        ac('UIListLayout', {
                            FillDirection = 'Vertical',
                            Padding = UDim.new(0, 5),
                        }),
                    })

                    local j = ac('Frame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, aB, 0, 0),
                        ClipsDescendants = true,
                        AnchorPoint = Vector2.new(1, 0),
                        Parent = d,
                        Position = UDim2.new(1, 0, 1, 15),
                    }, {
                        h,
                    })

                    ac('TextLabel', {
                        Text = 'Select Service',
                        BackgroundTransparency = 1,
                        FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                        ThemeTag = { TextColor3 = 'Text' },
                        TextTransparency = 0.2,
                        TextSize = 16,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        TextWrapped = true,
                        TextXAlignment = 'Left',
                        Parent = h,
                    }, {
                        ac('UIPadding', {
                            PaddingTop = UDim.new(0, 10),
                            PaddingLeft = UDim.new(0, 10),
                            PaddingRight = UDim.new(0, 10),
                            PaddingBottom = UDim.new(0, 10),
                        }),
                    })

                    for l, m in next, ah.KeySystem.API do
                        local p = ah.WindUI.Services[m.Type]
                        if p then
                            local r = {}
                            for u, v in next, p.Args do
                                table.insert(r, m[v])
                            end

                            local u = p.New(table.unpack(r))
                            u.Type = m.Type
                            table.insert(an, u)

                            local v = m.Icon or p.Icon or 'user'
                            local x = ab.Image(v, v, 0, 'Temp', 'KeySystem', true)
                            x.Size = UDim2.new(0, 24, 0, 24)

                            local z = ab.NewRoundFrame(10, 'Squircle', {
                                Size = UDim2.new(1, 0, 0, 0),
                                ThemeTag = { ImageColor3 = 'Text' },
                                ImageTransparency = 1,
                                Parent = h,
                                AutomaticSize = 'Y',
                            }, {
                                ac('UIListLayout', {
                                    FillDirection = 'Horizontal',
                                    Padding = UDim.new(0, 10),
                                    VerticalAlignment = 'Center',
                                }),
                                x,
                                ac('UIPadding', {
                                    PaddingTop = UDim.new(0, 10),
                                    PaddingLeft = UDim.new(0, 10),
                                    PaddingRight = UDim.new(0, 10),
                                    PaddingBottom = UDim.new(0, 10),
                                }),
                                ac('Frame', {
                                    BackgroundTransparency = 1,
                                    Size = UDim2.new(1, -34, 0, 0),
                                    AutomaticSize = 'Y',
                                }, {
                                    ac('UIListLayout', {
                                        FillDirection = 'Vertical',
                                        Padding = UDim.new(0, 5),
                                        HorizontalAlignment = 'Center',
                                    }),
                                    ac('TextLabel', {
                                        Text = m.Title or p.Name,
                                        BackgroundTransparency = 1,
                                        FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                                        ThemeTag = { TextColor3 = 'Text' },
                                        TextTransparency = 0.05,
                                        TextSize = 18,
                                        Size = UDim2.new(1, 0, 0, 0),
                                        AutomaticSize = 'Y',
                                        TextWrapped = true,
                                        TextXAlignment = 'Left',
                                    }),
                                    ac('TextLabel', {
                                        Text = m.Desc or '',
                                        BackgroundTransparency = 1,
                                        FontFace = Font.new(ab.Font, Enum.FontWeight.Regular),
                                        ThemeTag = { TextColor3 = 'Text' },
                                        TextTransparency = 0.2,
                                        TextSize = 16,
                                        Size = UDim2.new(1, 0, 0, 0),
                                        AutomaticSize = 'Y',
                                        TextWrapped = true,
                                        Visible = m.Desc and true or false,
                                        TextXAlignment = 'Left',
                                    }),
                                }),
                            }, true)

                            ab.AddSignal(z.MouseEnter, function()
                                ad(z, 0.08, { ImageTransparency = 0.95 }):Play()
                            end)
                            ab.AddSignal(z.InputEnded, function()
                                ad(z, 0.08, { ImageTransparency = 1 }):Play()
                            end)
                            ab.AddSignal(z.MouseButton1Click, function()
                                u.Copy()
                                ah.WindUI:Notify({
                                    Title = 'Key System',
                                    Content = 'Key link copied to clipboard.',
                                    Image = 'key',
                                })
                            end)
                        end
                    end

                    ab.AddSignal(d.MouseButton1Click, function()
                        if not b then
                            ad(
                                j,
                                0.3,
                                { Size = UDim2.new(0, aB, 0, h.AbsoluteSize.Y + 1) },
                                Enum.EasingStyle.Quint,
                                Enum.EasingDirection.Out
                            ):Play()
                            ad(g, 0.3, { Rotation = 180 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        else
                            ad(
                                j,
                                0.25,
                                { Size = UDim2.new(0, aB, 0, 0) },
                                Enum.EasingStyle.Quint,
                                Enum.EasingDirection.Out
                            ):Play()
                            ad(g, 0.25, { Rotation = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end
                        b = not b
                    end)
                end

                local function handleSuccess(aB)
                    am:Close()()
                    writefile((ah.Folder or 'Temp') .. '/' .. ai .. '.key', tostring(aB))
                    task.wait(0.4)
                    aj(true)
                end

                local aB = ae('Submit', 'arrow-right', function()
                    local aB = tostring(ao or 'empty')

                    if ah.KeySystem.KeyValidator then
                        local b = ah.KeySystem.KeyValidator(aB)

                        if b then
                            if ah.KeySystem.SaveKey then
                                handleSuccess(aB)
                            else
                                am:Close()()
                                task.wait(0.4)
                                aj(true)
                            end
                        else
                            ah.WindUI:Notify({
                                Title = 'Key System. Error',
                                Content = 'Invalid key.',
                                Icon = 'triangle-alert',
                            })
                        end
                    elseif not ah.KeySystem.API then
                        local b = type(ah.KeySystem.Key) == 'table' and table.find(ah.KeySystem.Key, aB)
                            or ah.KeySystem.Key == aB

                        if b then
                            if ah.KeySystem.SaveKey then
                                handleSuccess(aB)
                            else
                                am:Close()()
                                task.wait(0.4)
                                aj(true)
                            end
                        end
                    else
                        local b, d
                        for f, g in next, an do
                            local h, j = g.Verify(aB)
                            if h then
                                b, d = true, j
                                break
                            end
                            d = j
                        end

                        if b then
                            handleSuccess(aB)
                        else
                            ah.WindUI:Notify({
                                Title = 'Key System. Error',
                                Content = d,
                                Icon = 'triangle-alert',
                            })
                        end
                    end
                end, 'Primary', ay)

                aB.AnchorPoint = Vector2.new(1, 0.5)
                aB.Position = UDim2.new(1, 0, 0.5, 0)

                am:Open()
            end

            return aa
        end
        function WindUIModules.KeySystemModule(): typeof(buildModule())
            local aa = WindUIModules.cache.KeySystemModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.KeySystemModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local function map(ab, ac, ad, ae, af)
                return (ab - ac) * (af - ae) / (ad - ac) + ae
            end

            local function viewportPointToWorld(ab, ac)
                local ad = aa(game:GetService('Workspace')).CurrentCamera:ScreenPointToRay(ab.X, ab.Y)
                return ad.Origin + ad.Direction * ac
            end

            local function getOffset()
                local ab = aa(game:GetService('Workspace')).CurrentCamera.ViewportSize.Y
                return map(ab, 0, 2560, 8, 56)
            end

            return { viewportPointToWorld, getOffset }
        end
        function WindUIModules.ViewportUtilities(): typeof(buildModule())
            local aa = WindUIModules.cache.ViewportUtilities
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ViewportUtilities = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New

            local ad, ae = unpack(WindUIModules.ViewportUtilities())
            local af = Instance.new('Folder', aa(game:GetService('Workspace')).CurrentCamera)

            local function createAcrylic()
                local ag = ac('Part', {
                    Name = 'Body',
                    Color = Color3.new(0, 0, 0),
                    Material = Enum.Material.Glass,
                    Size = Vector3.new(1, 1, 0),
                    Anchored = true,
                    CanCollide = false,
                    Locked = true,
                    CastShadow = false,
                    Transparency = 0.98,
                }, {
                    ac('SpecialMesh', {
                        MeshType = Enum.MeshType.Brick,
                        Offset = Vector3.new(0, 0, -1E-6),
                    }),
                })

                return ag
            end

            local function createAcrylicBlur(ag)
                local ah = {}

                ag = ag or 0.001
                local ai = {
                    topLeft = Vector2.new(),
                    topRight = Vector2.new(),
                    bottomRight = Vector2.new(),
                }
                local aj = createAcrylic()
                aj.Parent = af

                local function updatePositions(ak, al)
                    ai.topLeft = al
                    ai.topRight = al + Vector2.new(ak.X, 0)
                    ai.bottomRight = al + ak
                end

                local function render()
                    local ak = aa(game:GetService('Workspace')).CurrentCamera
                    if ak then
                        ak = ak.CFrame
                    end
                    local al = ak
                    if not al then
                        al = CFrame.new()
                    end

                    local am = al
                    local an = ai.topLeft
                    local ao = ai.topRight
                    local ap = ai.bottomRight

                    local aq = ad(an, ag)
                    local ar = ad(ao, ag)
                    local as = ad(ap, ag)

                    local at = (ar - aq).Magnitude
                    local au = (ar - as).Magnitude

                    aj.CFrame = CFrame.fromMatrix((aq + as) / 2, am.XVector, am.YVector, am.ZVector)
                    aj.Mesh.Scale = Vector3.new(at, au, 0)
                end

                local function onChange(ak)
                    local al = ae()
                    local am = ak.AbsoluteSize - Vector2.new(al, al)
                    local an = ak.AbsolutePosition + Vector2.new(al / 2, al / 2)

                    updatePositions(am, an)
                    task.spawn(render)
                end

                local function renderOnChange()
                    local ak = aa(game:GetService('Workspace')).CurrentCamera
                    if not ak then
                        return
                    end

                    table.insert(ah, ak:GetPropertyChangedSignal('CFrame'):Connect(render))
                    table.insert(ah, ak:GetPropertyChangedSignal('ViewportSize'):Connect(render))
                    table.insert(ah, ak:GetPropertyChangedSignal('FieldOfView'):Connect(render))
                    task.spawn(render)
                end

                aj.Destroying:Connect(function()
                    for ak, al in ah do
                        pcall(function()
                            al:Disconnect()
                        end)
                    end
                end)

                renderOnChange()

                return onChange, aj
            end

            return function(ag)
                local ah = {}
                local ai, aj = createAcrylicBlur(ag)

                local ak = ac('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                })

                ab.AddSignal(ak:GetPropertyChangedSignal('AbsolutePosition'), function()
                    ai(ak)
                end)

                ab.AddSignal(ak:GetPropertyChangedSignal('AbsoluteSize'), function()
                    ai(ak)
                end)

                ah.AddParent = function(al)
                    ab.AddSignal(al:GetPropertyChangedSignal('Visible'), function()
                        ah.SetVisibility(al.Visible)
                    end)
                end

                ah.SetVisibility = function(al)
                    aj.Transparency = al and 0.98 or 1
                end

                ah.Frame = ak
                ah.Model = aj

                return ah
            end
        end
        function WindUIModules.AcrylicBlurModule(): typeof(buildModule())
            local aa = WindUIModules.cache.AcrylicBlurModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.AcrylicBlurModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ab = WindUIModules.AcrylicBlurModule()

            local ac = aa.New

            return function(ad)
                local ae = {}

                ae.Frame = ac('Frame', {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                }, {

                    ac('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),

                    ac('Frame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                        Name = 'Background',
                        ThemeTag = {
                            BackgroundColor3 = 'AcrylicMain',
                        },
                    }, {
                        ac('UICorner', {
                            CornerRadius = UDim.new(0, 8),
                        }),
                    }),

                    ac('Frame', {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                    }, {}),

                    ac('ImageLabel', {
                        Image = 'rbxassetid://9968344105',
                        ImageTransparency = 0.98,
                        ScaleType = Enum.ScaleType.Tile,
                        TileSize = UDim2.new(0, 128, 0, 128),
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                    }, {
                        ac('UICorner', {
                            CornerRadius = UDim.new(0, 8),
                        }),
                    }),

                    ac('ImageLabel', {
                        Image = 'rbxassetid://9968344227',
                        ImageTransparency = 0.9,
                        ScaleType = Enum.ScaleType.Tile,
                        TileSize = UDim2.new(0, 128, 0, 128),
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        ThemeTag = {
                            ImageTransparency = 'AcrylicNoise',
                        },
                    }, {
                        ac('UICorner', {
                            CornerRadius = UDim.new(0, 8),
                        }),
                    }),

                    ac('Frame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                        ZIndex = 2,
                    }, {}),
                })

                local af

                task.wait()
                if ad.UseAcrylic then
                    af = ab()

                    af.Frame.Parent = ae.Frame
                    ae.Model = af.Model
                    ae.AddParent = af.AddParent
                    ae.SetVisibility = af.SetVisibility
                end

                return ae, af
            end
        end
        function WindUIModules.AcrylicPaintModule(): typeof(buildModule())
            local aa = WindUIModules.cache.AcrylicPaintModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.AcrylicPaintModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ab = {
                AcrylicBlur = WindUIModules.AcrylicBlurModule(),

                AcrylicPaint = WindUIModules.AcrylicPaintModule(),
            }

            function ab.init()
                local ac = Instance.new('DepthOfFieldEffect')
                ac.FarIntensity = 0
                ac.InFocusRadius = 0.1
                ac.NearIntensity = 1

                local ad = {}

                function ab.Enable()
                    for ae, af in pairs(ad) do
                        af.Enabled = false
                    end
                    ac.Parent = aa(game:GetService('Lighting'))
                end

                function ab.Disable()
                    for ae, af in pairs(ad) do
                        af.Enabled = af.enabled
                    end
                    ac.Parent = nil
                end

                local function registerDefaults()
                    local function register(ae)
                        if ae:IsA('DepthOfFieldEffect') then
                            ad[ae] = { enabled = ae.Enabled }
                        end
                    end

                    for ae, af in pairs(aa(game:GetService('Lighting')):GetChildren()) do
                        register(af)
                    end

                    if aa(game:GetService('Workspace')).CurrentCamera then
                        for ae, af in pairs(aa(game:GetService('Workspace')).CurrentCamera:GetChildren()) do
                            register(af)
                        end
                    end
                end

                registerDefaults()
                ab.Enable()
            end

            return ab
        end
        function WindUIModules.AcrylicModule(): typeof(buildModule())
            local aa = WindUIModules.cache.AcrylicModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.AcrylicModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            function aa.new(ae)
                local af = {
                    Title = ae.Title or 'Dialog',
                    Content = ae.Content,
                    Icon = ae.Icon,
                    IconThemed = ae.IconThemed,
                    Thumbnail = ae.Thumbnail,
                    Buttons = ae.Buttons,

                    IconSize = 22,
                }

                local ag = WindUIModules.DialogModule().Init(nil, ae.WindUI.ScreenGui.Popups)
                local ah = ag.Create(true, 'Popup')

                local ai = 200

                local aj = 430
                if af.Thumbnail and af.Thumbnail.Image then
                    aj = 430 + (ai / 2)
                end

                ah.UIElements.Main.AutomaticSize = 'Y'
                ah.UIElements.Main.Size = UDim2.new(0, aj, 0, 0)

                local ak

                if af.Icon then
                    ak = ab.Image(
                        af.Icon,
                        af.Title .. ':' .. af.Icon,
                        0,
                        ae.WindUI.Window,
                        'Popup',
                        true,
                        ae.IconThemed,
                        'PopupIcon'
                    )
                    ak.Size = UDim2.new(0, af.IconSize, 0, af.IconSize)
                    ak.LayoutOrder = -1
                end

                local al = ac('TextLabel', {
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                    Text = af.Title,
                    TextXAlignment = 'Left',
                    FontFace = Font.new(ab.Font, Enum.FontWeight.SemiBold),
                    ThemeTag = {
                        TextColor3 = 'PopupTitle',
                    },
                    TextSize = 20,
                    TextWrapped = true,
                    Size = UDim2.new(1, ak and -af.IconSize - 14 or 0, 0, 0),
                })

                local am = ac('Frame', {
                    BackgroundTransparency = 1,
                    AutomaticSize = 'XY',
                }, {
                    ac('UIListLayout', {
                        Padding = UDim.new(0, 14),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                    }),
                    ak,
                    al,
                })

                local an = ac('Frame', {
                    AutomaticSize = 'Y',
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                }, {

                    am,
                })

                local ao
                if af.Content and af.Content ~= '' then
                    ao = ac('TextLabel', {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                        TextXAlignment = 'Left',
                        Text = af.Content,
                        TextSize = 18,
                        TextTransparency = 0.2,
                        ThemeTag = {
                            TextColor3 = 'PopupContent',
                        },
                        BackgroundTransparency = 1,
                        RichText = true,
                        TextWrapped = true,
                    })
                end

                local ap = ac('Frame', {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundTransparency = 1,
                }, {
                    ac('UIListLayout', {
                        Padding = UDim.new(0, 9),
                        FillDirection = 'Horizontal',
                        HorizontalAlignment = 'Right',
                    }),
                })

                local aq
                if af.Thumbnail and af.Thumbnail.Image then
                    local ar
                    if af.Thumbnail.Title then
                        ar = ac('TextLabel', {
                            Text = af.Thumbnail.Title,
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                            TextSize = 18,
                            FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                            BackgroundTransparency = 1,
                            AutomaticSize = 'XY',
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                        })
                    end
                    aq = ac('ImageLabel', {
                        Image = af.Thumbnail.Image,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, ai, 1, 0),
                        Parent = ah.UIElements.Main,
                        ScaleType = 'Crop',
                    }, {
                        ar,
                        ac('UICorner', {
                            CornerRadius = UDim.new(0, 0),
                        }),
                    })
                end

                ac('Frame', {

                    Size = UDim2.new(1, aq and -ai or 0, 1, 0),
                    Position = UDim2.new(0, aq and ai or 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = ah.UIElements.Main,
                }, {
                    ac('Frame', {

                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                    }, {
                        ac('UIListLayout', {
                            Padding = UDim.new(0, 18),
                            FillDirection = 'Vertical',
                        }),
                        an,
                        ao,
                        ap,
                        ac('UIPadding', {
                            PaddingTop = UDim.new(0, 16),
                            PaddingLeft = UDim.new(0, 16),
                            PaddingRight = UDim.new(0, 16),
                            PaddingBottom = UDim.new(0, 16),
                        }),
                    }),
                })

                local ar = WindUIModules.NotificationModule().New

                for as, at in next, af.Buttons do
                    ar(at.Title, at.Icon, at.Callback, at.Variant, ap, ah)
                end

                ah:Open()

                return af
            end

            return aa
        end
        function WindUIModules.DefaultThemes(): typeof(buildModule())
            local aa = WindUIModules.cache.DefaultThemes
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.DefaultThemes = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            return function(aa)
                return {
                    Dark = {
                        Name = 'Dark',

                        Accent = Color3.fromHex('#18181b'),
                        Dialog = Color3.fromHex('#161616'),
                        Outline = Color3.fromHex('#FFFFFF'),
                        Text = Color3.fromHex('#FFFFFF'),
                        Placeholder = Color3.fromHex('#7a7a7a'),
                        Background = Color3.fromHex('#101010'),
                        Button = Color3.fromHex('#52525b'),
                        Icon = Color3.fromHex('#a1a1aa'),
                        Toggle = Color3.fromHex('#33C759'),
                        Slider = Color3.fromHex('#0091FF'),
                        Checkbox = Color3.fromHex('#0091FF'),

                        PanelBackground = Color3.fromHex('#FFFFFF'),
                        PanelBackgroundTransparency = 0.95,

                        SliderIcon = Color3.fromHex('#908F95'),
                        Primary = Color3.fromHex('#0091FF'),
                    },

                    Light = {
                        Name = 'Light',

                        Accent = Color3.fromHex('#FFFFFF'),
                        Dialog = Color3.fromHex('#f4f4f5'),
                        Outline = Color3.fromHex('#09090b'),
                        Text = Color3.fromHex('#000000'),
                        Placeholder = Color3.fromHex('#555555'),
                        Background = Color3.fromHex('#e9e9e9'),
                        Button = Color3.fromHex('#18181b'),
                        Icon = Color3.fromHex('#52525b'),
                        Toggle = Color3.fromHex('#33C759'),
                        Slider = Color3.fromHex('#0091FF'),
                        Checkbox = Color3.fromHex('#0091FF'),

                        TabBackground = Color3.fromHex('#ffffff'),
                        TabBackgroundHover = Color3.fromHex('#ffffff'),
                        TabBackgroundHoverTransparency = 0.5,
                        TabBackgroundActive = Color3.fromHex('#ffffff'),
                        TabBackgroundActiveTransparency = 0,

                        PanelBackground = Color3.fromHex('#FFFFFF'),
                        PanelBackgroundTransparency = 0,

                        LabelBackground = Color3.fromHex('#ffffff'),
                        LabelBackgroundTransparency = 0,
                    },

                    Rose = {
                        Name = 'Rose',

                        Accent = Color3.fromHex('#be185d'),
                        Dialog = Color3.fromHex('#4c0519'),
                        Outline = Color3.fromHex('#fecdd3'),
                        Text = Color3.fromHex('#fdf2f8'),
                        Placeholder = Color3.fromHex('#d67aa6'),
                        Background = Color3.fromHex('#1f0308'),
                        Button = Color3.fromHex('#e95f74'),
                        Icon = Color3.fromHex('#fb7185'),
                    },

                    Plant = {
                        Name = 'Plant',

                        Accent = Color3.fromHex('#166534'),
                        Dialog = Color3.fromHex('#052e16'),
                        Outline = Color3.fromHex('#bbf7d0'),
                        Text = Color3.fromHex('#f0fdf4'),
                        Placeholder = Color3.fromHex('#4fbf7a'),
                        Background = Color3.fromHex('#0a1b0f'),
                        Button = Color3.fromHex('#16a34a'),
                        Icon = Color3.fromHex('#4ade80'),
                    },

                    Red = {
                        Name = 'Red',

                        Accent = Color3.fromHex('#991b1b'),
                        Dialog = Color3.fromHex('#450a0a'),
                        Outline = Color3.fromHex('#fecaca'),
                        Text = Color3.fromHex('#fef2f2'),
                        Placeholder = Color3.fromHex('#d95353'),
                        Background = Color3.fromHex('#1c0606'),
                        Button = Color3.fromHex('#dc2626'),
                        Icon = Color3.fromHex('#ef4444'),
                    },

                    Indigo = {
                        Name = 'Indigo',

                        Accent = Color3.fromHex('#3730a3'),
                        Dialog = Color3.fromHex('#1e1b4b'),
                        Outline = Color3.fromHex('#c7d2fe'),
                        Text = Color3.fromHex('#f1f5f9'),
                        Placeholder = Color3.fromHex('#7078d9'),
                        Background = Color3.fromHex('#0f0a2e'),
                        Button = Color3.fromHex('#4f46e5'),
                        Icon = Color3.fromHex('#6366f1'),
                    },

                    Sky = {
                        Name = 'Sky',

                        Accent = Color3.fromHex('#00d4ff'),
                        Dialog = Color3.fromHex('#0a4d66'),
                        Outline = Color3.fromHex('#4dd9ff'),
                        Text = Color3.fromHex('#e6f7ff'),
                        Placeholder = Color3.fromHex('#66b3cc'),
                        Background = Color3.fromHex('#051a26'),
                        Button = Color3.fromHex('#00a8cc'),
                        Icon = Color3.fromHex('#2db8d9'),

                        Toggle = Color3.fromHex('#00d9d9'),
                        Slider = Color3.fromHex('#00d4ff'),
                        Checkbox = Color3.fromHex('#00d4ff'),

                        PanelBackground = Color3.fromHex('#0d3a47'),
                        PanelBackgroundTransparency = 0.8,
                    },

                    Violet = {
                        Name = 'Violet',

                        Accent = Color3.fromHex('#6d28d9'),
                        Dialog = Color3.fromHex('#3c1361'),
                        Outline = Color3.fromHex('#ddd6fe'),
                        Text = Color3.fromHex('#faf5ff'),
                        Placeholder = Color3.fromHex('#8f7ee0'),
                        Background = Color3.fromHex('#1e0a3e'),
                        Button = Color3.fromHex('#7c3aed'),
                        Icon = Color3.fromHex('#8b5cf6'),
                    },

                    Amber = {
                        Name = 'Amber',

                        Accent = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#b45309'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#d97706'), Transparency = 0 },
                        }, { Rotation = 45 }),

                        Dialog = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#451a03'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#6b2e05'), Transparency = 0 },
                        }, { Rotation = 90 }),

                        Outline = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#fde68a'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#fcd34d'), Transparency = 0 },
                        }, { Rotation = 45 }),

                        Text = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#fffbeb'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#fff7ed'), Transparency = 0 },
                        }, { Rotation = 45 }),

                        Placeholder = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#d1a326'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#fbbf24'), Transparency = 0 },
                        }, { Rotation = 45 }),

                        Background = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#1c1003'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#3f210d'), Transparency = 0 },
                        }, { Rotation = 90 }),

                        Button = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#d97706'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#f59e0b'), Transparency = 0 },
                        }, { Rotation = 45 }),

                        Icon = Color3.fromHex('#f59e0b'),

                        Toggle = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#d97706'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#f59e0b'), Transparency = 0 },
                        }, { Rotation = 45 }),

                        Slider = Color3.fromHex('#d97706'),

                        Checkbox = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#d97706'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#fbbf24'), Transparency = 0 },
                        }, { Rotation = 45 }),

                        PanelBackground = Color3.fromHex('#FFFFFF'),
                        PanelBackgroundTransparency = 0.95,
                    },

                    Emerald = {
                        Name = 'Emerald',

                        Accent = Color3.fromHex('#047857'),
                        Dialog = Color3.fromHex('#022c22'),
                        Outline = Color3.fromHex('#a7f3d0'),
                        Text = Color3.fromHex('#ecfdf5'),
                        Placeholder = Color3.fromHex('#3fbf8f'),
                        Background = Color3.fromHex('#011411'),
                        Button = Color3.fromHex('#059669'),
                        Icon = Color3.fromHex('#10b981'),
                    },

                    Midnight = {
                        Name = 'Midnight',

                        Accent = Color3.fromHex('#1e3a8a'),
                        Dialog = Color3.fromHex('#0c1e42'),
                        Outline = Color3.fromHex('#bfdbfe'),
                        Text = Color3.fromHex('#dbeafe'),
                        Placeholder = Color3.fromHex('#2f74d1'),
                        Background = Color3.fromHex('#0a0f1e'),
                        Button = Color3.fromHex('#2563eb'),
                        Primary = Color3.fromHex('#2563eb'),
                        Icon = Color3.fromHex('#5591f4'),
                    },

                    Crimson = {
                        Name = 'Crimson',

                        Accent = Color3.fromHex('#b91c1c'),
                        Dialog = Color3.fromHex('#450a0a'),
                        Outline = Color3.fromHex('#fca5a5'),
                        Text = Color3.fromHex('#fef2f2'),
                        Placeholder = Color3.fromHex('#6f757b'),
                        Background = Color3.fromHex('#0c0404'),
                        Button = Color3.fromHex('#991b1b'),
                        Icon = Color3.fromHex('#dc2626'),
                    },

                    MonokaiPro = {
                        Name = 'Monokai Pro',

                        Accent = Color3.fromHex('#fc9867'),
                        Dialog = Color3.fromHex('#1e1e1e'),
                        Outline = Color3.fromHex('#78dce8'),
                        Text = Color3.fromHex('#fcfcfa'),
                        Placeholder = Color3.fromHex('#6f6f6f'),
                        Background = Color3.fromHex('#191622'),
                        Button = Color3.fromHex('#ab9df2'),
                        Icon = Color3.fromHex('#a9dc76'),

                        Metadata = {
                            PullRequest = 23,
                        },
                    },

                    CottonCandy = {
                        Name = 'Cotton Candy',

                        Accent = Color3.fromHex('#ec4899'),
                        Dialog = Color3.fromHex('#2d1b3d'),
                        Outline = Color3.fromHex('#f9a8d4'),
                        Text = Color3.fromHex('#fdf2f8'),
                        Placeholder = Color3.fromHex('#8a5fd3'),
                        Background = Color3.fromHex('#1a0b2e'),
                        Button = Color3.fromHex('#d946ef'),
                        Slider = Color3.fromHex('#d946ef'),
                        Icon = Color3.fromHex('#06b6d4'),
                    },

                    Mellowsi = {
                        Name = 'Mellowsi',

                        Accent = Color3.fromHex('#342A1E'),
                        Dialog = Color3.fromHex('#291C13'),
                        Outline = Color3.fromHex('#6B5A45'),
                        Text = Color3.fromHex('#F5EBDD'),
                        Placeholder = Color3.fromHex('#9C8A73'),
                        Background = Color3.fromHex('#1C1002'),
                        Button = Color3.fromHex('#342A1E'),
                        Icon = Color3.fromHex('#C9B79C'),

                        Toggle = Color3.fromHex('#a9873f'),
                        Slider = Color3.fromHex('#C9A24D'),
                        Checkbox = Color3.fromHex('#C9A24D'),

                        Metadata = {
                            PullRequest = 52,
                        },
                    },

                    Rainbow = {
                        Name = 'Rainbow',

                        Accent = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#00ff41'), Transparency = 0 },
                            ['33'] = { Color = Color3.fromHex('#00ffff'), Transparency = 0 },
                            ['66'] = { Color = Color3.fromHex('#0080ff'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#8000ff'), Transparency = 0 },
                        }, { Rotation = 45 }),

                        Dialog = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#ff0080'), Transparency = 0 },
                            ['25'] = { Color = Color3.fromHex('#8000ff'), Transparency = 0 },
                            ['50'] = { Color = Color3.fromHex('#0080ff'), Transparency = 0 },
                            ['75'] = { Color = Color3.fromHex('#00ff80'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#ff8000'), Transparency = 0 },
                        }, { Rotation = 135 }),

                        Outline = Color3.fromHex('#ffffff'),
                        Text = Color3.fromHex('#ffffff'),
                        Placeholder = Color3.fromHex('#00ff80'),

                        Background = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#ff0040'), Transparency = 0 },
                            ['20'] = { Color = Color3.fromHex('#ff4000'), Transparency = 0 },
                            ['40'] = { Color = Color3.fromHex('#ffff00'), Transparency = 0 },
                            ['60'] = { Color = Color3.fromHex('#00ff40'), Transparency = 0 },
                            ['80'] = { Color = Color3.fromHex('#0040ff'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#4000ff'), Transparency = 0 },
                        }, { Rotation = 90 }),

                        Button = aa:Gradient({
                            ['0'] = { Color = Color3.fromHex('#ff0080'), Transparency = 0 },
                            ['25'] = { Color = Color3.fromHex('#ff8000'), Transparency = 0 },
                            ['50'] = { Color = Color3.fromHex('#ffff00'), Transparency = 0 },
                            ['75'] = { Color = Color3.fromHex('#80ff00'), Transparency = 0 },
                            ['100'] = { Color = Color3.fromHex('#00ffff'), Transparency = 0 },
                        }, { Rotation = 60 }),

                        Icon = Color3.fromHex('#ffffff'),
                    },
                }
            end
        end
        function WindUIModules.LabelModule(): typeof(buildModule())
            local aa = WindUIModules.cache.LabelModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.LabelModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            function aa.New(ae, af, ag, ah, ai)
                local aj = ai or 10
                local ak
                if af and af ~= '' then
                    ak = ac('ImageLabel', {
                        Image = ab.Icon(af)[1],
                        ImageRectSize = ab.Icon(af)[2].ImageRectSize,
                        ImageRectOffset = ab.Icon(af)[2].ImageRectPosition,
                        Size = UDim2.new(0, 21, 0, 21),
                        BackgroundTransparency = 1,
                        ThemeTag = {
                            ImageColor3 = 'Icon',
                        },
                    })
                end

                local al = ac('TextLabel', {
                    BackgroundTransparency = 1,
                    TextSize = 17,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Regular),
                    Size = UDim2.new(1, ak and -29 or 0, 1, 0),
                    TextXAlignment = 'Left',
                    ThemeTag = {
                        TextColor3 = ah and 'Placeholder' or 'Text',
                    },
                    Text = ae,
                })

                local am = ac('TextButton', {
                    Size = UDim2.new(1, 0, 0, 42),
                    Parent = ag,
                    BackgroundTransparency = 1,
                    Text = '',
                }, {
                    ac('Frame', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                    }, {
                        ab.NewRoundFrame(aj, 'Squircle', {
                            ThemeTag = {
                                ImageColor3 = 'Accent',
                            },
                            Size = UDim2.new(1, 0, 1, 0),
                            ImageTransparency = 0.97,
                        }),
                        ab.NewRoundFrame(aj, 'Glass-1.4', {
                            ThemeTag = {
                                ImageColor3 = 'Outline',
                            },
                            Size = UDim2.new(1, 0, 1, 0),
                            ImageTransparency = 0.75,
                        }, {}),
                        ab.NewRoundFrame(aj, 'Squircle', {
                            Size = UDim2.new(1, 0, 1, 0),
                            Name = 'Frame',
                            ThemeTag = {
                                ImageColor3 = 'LabelBackground',
                                ImageTransparency = 'LabelBackgroundTransparency',
                            },
                        }, {
                            ac('UIPadding', {
                                PaddingLeft = UDim.new(0, 12),
                                PaddingRight = UDim.new(0, 12),
                            }),
                            ac('UIListLayout', {
                                FillDirection = 'Horizontal',
                                Padding = UDim.new(0, 8),
                                VerticalAlignment = 'Center',
                                HorizontalAlignment = 'Left',
                            }),
                            ak,
                            al,
                        }),
                    }),
                })

                return am
            end

            return aa
        end
        function WindUIModules.PanelModule(): typeof(buildModule())
            local aa = WindUIModules.cache.PanelModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.PanelModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = (cloneref or clonereference or function(ab)
                return ab
            end)

            local ac = ab(game:GetService('UserInputService'))

            local ad = WindUIModules.LocalizationModule()
            local ae = ad.New
            local af = ad.Tween

            function aa.New(ag, ah, ai, aj)
                local ak = ae('Frame', {
                    Size = UDim2.new(0, aj, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    Parent = ah,
                    ZIndex = 999,
                    Active = true,
                })

                local al = ad.NewRoundFrame(aj / 2, 'Squircle', {
                    Size = UDim2.new(1, 0, 0, 0),
                    ImageTransparency = 0.85,
                    ThemeTag = { ImageColor3 = 'Text' },
                    Parent = ak,
                })

                local am = ae('Frame', {
                    Size = UDim2.new(1, 12, 1, 12),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Active = true,
                    ZIndex = 999,
                    Parent = al,
                })

                local an = false
                local ao = 0

                local function updateSliderSize()
                    local ap = ag
                    local aq = ap.AbsoluteCanvasSize.Y
                    local ar = ap.AbsoluteWindowSize.Y

                    if aq <= ar then
                        al.Visible = false
                        return
                    end

                    local as = math.clamp(ar / aq, 0.1, 1)
                    al.Size = UDim2.new(1, 0, as, 0)
                    al.Visible = true
                end

                local function updateScrollingFramePosition()
                    local ap = al.Position.Y.Scale
                    local aq = ag.AbsoluteCanvasSize.Y
                    local ar = ag.AbsoluteWindowSize.Y
                    local as = math.max(aq - ar, 0)

                    if as <= 0 then
                        return
                    end

                    local at = math.max(1 - al.Size.Y.Scale, 0)
                    if at <= 0 then
                        return
                    end

                    local au = ap / at

                    ag.CanvasPosition = Vector2.new(ag.CanvasPosition.X, au * as)
                end

                local function updateThumbPosition()
                    if an then
                        return
                    end

                    local ap = ag.CanvasPosition.Y
                    local aq = ag.AbsoluteCanvasSize.Y
                    local ar = ag.AbsoluteWindowSize.Y
                    local as = math.max(aq - ar, 0)

                    if as <= 0 then
                        al.Position = UDim2.new(0, 0, 0, 0)
                        return
                    end

                    local at = ap / as
                    local au = math.max(1 - al.Size.Y.Scale, 0)
                    local av = math.clamp(at * au, 0, au)

                    al.Position = UDim2.new(0, 0, av, 0)
                end

                ad.AddSignal(ak.InputBegan, function(ap)
                    if
                        ap.UserInputType == Enum.UserInputType.MouseButton1
                        or ap.UserInputType == Enum.UserInputType.Touch
                    then
                        local aq = al.AbsolutePosition.Y
                        local ar = aq + al.AbsoluteSize.Y

                        if not (ap.Position.Y >= aq and ap.Position.Y <= ar) then
                            local as = ak.AbsolutePosition.Y
                            local at = ak.AbsoluteSize.Y
                            local au = al.AbsoluteSize.Y

                            local av = ap.Position.Y - as - au / 2
                            local aw = at - au

                            local ax = math.clamp(av / aw, 0, 1 - al.Size.Y.Scale)

                            al.Position = UDim2.new(0, 0, ax, 0)
                            updateScrollingFramePosition()
                        end
                    end
                end)

                ad.AddSignal(am.InputBegan, function(ap)
                    if
                        ap.UserInputType == Enum.UserInputType.MouseButton1
                        or ap.UserInputType == Enum.UserInputType.Touch
                    then
                        an = true
                        ao = ap.Position.Y - al.AbsolutePosition.Y

                        local aq
                        local ar

                        aq = ac.InputChanged:Connect(function(as)
                            if
                                as.UserInputType == Enum.UserInputType.MouseMovement
                                or as.UserInputType == Enum.UserInputType.Touch
                            then
                                local at = ak.AbsolutePosition.Y
                                local au = ak.AbsoluteSize.Y
                                local av = al.AbsoluteSize.Y

                                local aw = as.Position.Y - at - ao
                                local ax = au - av

                                local ay = math.clamp(aw / ax, 0, 1 - al.Size.Y.Scale)

                                al.Position = UDim2.new(0, 0, ay, 0)
                                updateScrollingFramePosition()
                            end
                        end)

                        ar = ac.InputEnded:Connect(function(as)
                            if
                                as.UserInputType == Enum.UserInputType.MouseButton1
                                or as.UserInputType == Enum.UserInputType.Touch
                            then
                                an = false
                                if aq then
                                    aq:Disconnect()
                                end
                                if ar then
                                    ar:Disconnect()
                                end
                            end
                        end)
                    end
                end)

                ad.AddSignal(ag:GetPropertyChangedSignal('AbsoluteWindowSize'), function()
                    updateSliderSize()
                    updateThumbPosition()
                end)

                ad.AddSignal(ag:GetPropertyChangedSignal('AbsoluteCanvasSize'), function()
                    updateSliderSize()
                    updateThumbPosition()
                end)

                ad.AddSignal(ag:GetPropertyChangedSignal('CanvasPosition'), function()
                    if not an then
                        updateThumbPosition()
                    end
                end)

                updateSliderSize()
                updateThumbPosition()

                return ak
            end

            return aa
        end
        function WindUIModules.SpaceModule(): typeof(buildModule())
            local aa = WindUIModules.cache.SpaceModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.SpaceModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ab = aa.New

            local ac = {}

            function ac.New(ad, ae)
                local af = ab('Frame', {
                    Parent = ae.Parent,
                    Size = ae.ParentType ~= 'Group' and UDim2.new(1, -7, 0, 7 * (ae.Columns or 1))
                        or UDim2.new(0, 7 * (ae.Columns or 1), 0, 0),
                    BackgroundTransparency = 1,
                })

                return 'Space', { __type = 'Space', ElementFrame = af }
            end

            return ac
        end
        function WindUIModules.DividerModule(): typeof(buildModule())
            local aa = WindUIModules.cache.DividerModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.DividerModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ab = aa.New

            local ac = {}

            local function resolveColor(ad)
                if typeof(ad) == 'Color3' then
                    return ad
                end

                if typeof(ad) ~= 'string' then
                    return nil
                end

                if string.sub(ad, 1, 1) == '#' then
                    return Color3.fromHex(ad)
                end

                if aa.Colors[ad] then
                    return Color3.fromHex(aa.Colors[ad])
                end

                local ae = aa.GetThemeProperty(ad, aa.Theme)
                if typeof(ae) == 'Color3' then
                    return ae
                end

                return nil
            end

            function ac.New(ad, ae)
                local af = resolveColor(ae.Color)
                local ag = ae.ParentType == 'Group'

                local ah = {
                    __type = 'Divider',
                    Thickness = typeof(ae.Thickness) == 'number' and math.max(math.floor(ae.Thickness), 1) or 1,
                    Padding = typeof(ae.Padding) == 'number' and math.max(math.floor(ae.Padding), 0) or 6,
                    Transparency = typeof(ae.Transparency) == 'number' and math.clamp(ae.Transparency, 0, 1) or nil,
                    Color = af,
                }

                local ai = ab('Frame', {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, -(ah.Padding * 2), 0, ah.Thickness),
                    ThemeTag = {
                        BackgroundColor3 = not ah.Color and 'SectionContentDivider' or nil,
                        BackgroundTransparency = not ah.Transparency and 'SectionContentDividerTransparency' or nil,
                    },
                    BackgroundColor3 = ah.Color,
                    BackgroundTransparency = ah.Transparency,
                })

                local aj = ab('Frame', {
                    Parent = ae.Parent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, ah.Thickness + (ah.Padding * 2)),
                }, {
                    ai,
                })

                local function updateLayout()
                    if ag then
                        aj.Size = UDim2.new(0, ah.Thickness + (ah.Padding * 2), 1, 0)
                        ai.Size = UDim2.new(0, ah.Thickness, 1, -(ah.Padding * 2))
                        return
                    end

                    aj.Size = UDim2.new(1, 0, 0, ah.Thickness + (ah.Padding * 2))
                    ai.Size = UDim2.new(1, -(ah.Padding * 2), 0, ah.Thickness)
                end

                updateLayout()

                local function setThemeBinding(ak, al)
                    local am = aa.Objects[ai]
                    if not am then
                        aa.AddThemeObject(ai, {})
                        am = aa.Objects[ai]
                    end

                    if am and am.Properties then
                        am.Properties[ak] = al
                        aa.UpdateTheme(ai, false)
                    end
                end

                local function clearThemeBinding(ak)
                    local al = aa.Objects[ai]
                    if al and al.Properties then
                        al.Properties[ak] = nil
                    end
                end

                ah.ElementFrame = aj

                function ah.SetVisible(ak, al)
                    aj.Visible = al ~= false
                    return ak
                end

                function ah.SetThickness(ak, al)
                    local am = typeof(al) == 'number' and math.max(math.floor(al), 1) or 1
                    ak.Thickness = am
                    updateLayout()
                    return ak
                end

                function ah.SetPadding(ak, al)
                    local am = typeof(al) == 'number' and math.max(math.floor(al), 0) or 0
                    ak.Padding = am
                    updateLayout()
                    return ak
                end

                function ah.SetTransparency(ak, al)
                    if al ~= nil then
                        if typeof(al) ~= 'number' then
                            return ak
                        end

                        ak.Transparency = math.clamp(al, 0, 1)
                        clearThemeBinding('BackgroundTransparency')
                        ai.BackgroundTransparency = ak.Transparency
                        return ak
                    end

                    ak.Transparency = nil
                    setThemeBinding('BackgroundTransparency', 'SectionContentDividerTransparency')
                    return ak
                end

                function ah.SetColor(ak, al)
                    if al ~= nil then
                        local am = resolveColor(al)
                        if not am then
                            return ak
                        end

                        ak.Color = am
                        clearThemeBinding('BackgroundColor3')
                        ai.BackgroundColor3 = am
                        return ak
                    end

                    ak.Color = nil
                    setThemeBinding('BackgroundColor3', 'SectionContentDivider')
                    return ak
                end

                function ah.Destroy(ak)
                    aj:Destroy()
                end

                return ah.__type, ah
            end

            return ac
        end
        function WindUIModules.TagModule(): typeof(buildModule())
            local aa = WindUIModules.cache.TagModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.TagModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            function aa.New(ae, af, ag)
                local ah = {
                    Title = af.Title or 'Tag',
                    Icon = af.Icon,
                    Color = af.Color or Color3.fromHex('#315dff'),
                    Radius = af.Radius or 999,
                    Border = af.Border or false,

                    TagFrame = nil,
                    Height = 26,
                    Padding = 10,
                    TextSize = 14,
                    IconSize = 16,
                }

                local ai
                if ah.Icon then
                    ai = ab.Image(ah.Icon, ah.Icon, 0, af.Window, 'Tag', false)

                    ai.Size = UDim2.new(0, ah.IconSize, 0, ah.IconSize)
                    ai.ImageLabel.ImageColor3 = typeof(ah.Color) == 'Color3' and ab.GetTextColorForHSB(ah.Color) or nil
                end

                local aj = ac('TextLabel', {
                    BackgroundTransparency = 1,
                    AutomaticSize = 'XY',
                    TextSize = ah.TextSize,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.SemiBold),
                    Text = ah.Title,
                    TextColor3 = typeof(ah.Color) == 'Color3' and ab.GetTextColorForHSB(ah.Color) or nil,
                })

                local ak

                if typeof(ah.Color) == 'table' then
                    ak = ac('UIGradient')
                    for al, am in next, ah.Color do
                        ak[al] = am
                    end

                    aj.TextColor3 = ab.GetTextColorForHSB(ab.GetAverageColor(ak))
                    if ai then
                        ai.ImageLabel.ImageColor3 = ab.GetTextColorForHSB(ab.GetAverageColor(ak))
                    end
                end

                local al = ab.NewRoundFrame(ah.Radius, 'Squircle', {
                    AutomaticSize = 'X',
                    Size = UDim2.new(0, 0, 0, ah.Height),
                    Parent = ag,
                    ImageColor3 = typeof(ah.Color) == 'Color3' and ah.Color or Color3.new(1, 1, 1),
                }, {
                    ak,
                    ab.NewRoundFrame(ah.Radius, 'Glass-1', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = {
                            ImageColor3 = 'White',
                        },
                        ImageTransparency = 0.75,
                    }),
                    ac('Frame', {
                        Size = UDim2.new(0, 0, 1, 0),
                        AutomaticSize = 'X',
                        Name = 'Content',
                        BackgroundTransparency = 1,
                    }, {
                        ai,
                        aj,
                        ac('UIPadding', {
                            PaddingLeft = UDim.new(0, ah.Padding),
                            PaddingRight = UDim.new(0, ah.Padding),
                        }),
                        ac('UIListLayout', {
                            FillDirection = 'Horizontal',
                            VerticalAlignment = 'Center',
                            Padding = UDim.new(0, ah.Padding / 1.5),
                        }),
                    }),
                })

                function ah.SetTitle(am, an)
                    ah.Title = an
                    aj.Text = an

                    return ah
                end

                function ah.SetColor(am, an)
                    ah.Color = an
                    if typeof(an) == 'table' then
                        local ao = ab.GetAverageColor(an)
                        ad(aj, 0.06, { TextColor3 = ab.GetTextColorForHSB(ao) }):Play()
                        local ap = al:FindFirstChildOfClass('UIGradient') or ac('UIGradient', { Parent = al })
                        for aq, ar in next, an do
                            ap[aq] = ar
                        end
                        ad(al, 0.06, { ImageColor3 = Color3.new(1, 1, 1) }):Play()
                    else
                        if ak then
                            ak:Destroy()
                        end
                        ad(aj, 0.06, { TextColor3 = ab.GetTextColorForHSB(an) }):Play()
                        if ai then
                            ad(ai.ImageLabel, 0.06, { ImageColor3 = ab.GetTextColorForHSB(an) }):Play()
                        end
                        ad(al, 0.06, { ImageColor3 = an }):Play()
                    end

                    return ah
                end

                function ah.SetIcon(am, an)
                    ah.Icon = an

                    if an then
                        ai = ab.Image(an, an, 0, af.Window, 'Tag', false)

                        ai.Size = UDim2.new(0, ah.IconSize, 0, ah.IconSize)
                        ai.Parent = al

                        if typeof(ah.Color) == 'Color3' then
                            ai.ImageLabel.ImageColor3 = ab.GetTextColorForHSB(ah.Color)
                        elseif typeof(ah.Color) == 'table' then
                            ai.ImageLabel.ImageColor3 = ab.GetTextColorForHSB(ab.GetAverageColor(ak))
                        end
                    else
                        if ai then
                            ai:Destroy()
                            ai = nil
                        end
                    end
                    return ah
                end

                function ah.Destroy(am)
                    al:Destroy()
                    return ah
                end

                return ah
            end

            return aa
        end
        function WindUIModules.WatermarkModule(): typeof(buildModule())
            local aa = WindUIModules.cache.WatermarkModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.WatermarkModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            local function normalizePosition(ae)
                local af = tostring(ae or 'bottom-right'):lower()
                af = af:gsub('_', '-'):gsub('%s+', '-')
                af = af:gsub('[^%w%-]', '')

                local ag = {
                    tl = 'top-left',
                    topleft = 'top-left',
                    tr = 'top-right',
                    topright = 'top-right',
                    bl = 'bottom-left',
                    bottomleft = 'bottom-left',
                    br = 'bottom-right',
                    bottomright = 'bottom-right',
                    c = 'center',
                    middle = 'center',
                    top = 'top-center',
                    bottom = 'bottom-center',
                    left = 'center-left',
                    right = 'center-right',
                }

                return ag[af] or af
            end

            local function getPresetPosition(ae, af, ag)
                local ah = {
                    ['top-left'] = { Anchor = Vector2.new(0, 0), Position = UDim2.new(0, af, 0, af) },
                    ['top-center'] = { Anchor = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, af) },
                    ['top-right'] = { Anchor = Vector2.new(1, 0), Position = UDim2.new(1, -af, 0, af) },
                    ['center-left'] = { Anchor = Vector2.new(0, 0.5), Position = UDim2.new(0, af, 0.5, 0) },
                    center = { Anchor = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0) },
                    ['center-right'] = { Anchor = Vector2.new(1, 0.5), Position = UDim2.new(1, -af, 0.5, 0) },
                    ['bottom-left'] = { Anchor = Vector2.new(0, 1), Position = UDim2.new(0, af, 1, -af) },
                    ['bottom-center'] = { Anchor = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -af) },
                    ['bottom-right'] = { Anchor = Vector2.new(1, 1), Position = UDim2.new(1, -af, 1, -af) },
                }

                local ai = normalizePosition(ae)
                local aj = ah[ai] or ah['bottom-right']

                return aj.Anchor,
                    UDim2.new(
                        aj.Position.X.Scale,
                        aj.Position.X.Offset + ag.X,
                        aj.Position.Y.Scale,
                        aj.Position.Y.Offset + ag.Y
                    )
            end

            function aa.New(ae, af, ag)
                af = af or {}

                local ah = {
                    Enabled = af.Enabled ~= false,
                    Text = af.Text or 'Watermark',
                    Opacity = math.clamp(tonumber(af.Opacity) or 0.45, 0, 1),
                    Position = af.Position or 'bottom-right',
                    Size = math.max(math.floor(tonumber(af.Size) or 14), 8),
                    Padding = math.max(math.floor(tonumber(af.Padding) or 12), 0),
                    Offset = typeof(af.Offset) == 'Vector2' and af.Offset or Vector2.new(0, 0),
                    Color = af.Color,
                }

                local ai = ac('Frame', {
                    Name = 'Watermark',
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = ag,
                    Active = false,
                    ZIndex = 99999,
                    Visible = ah.Enabled,
                })

                local aj = ac('TextLabel', {
                    Name = 'Label',
                    AutomaticSize = 'XY',
                    BackgroundTransparency = 1,
                    Text = tostring(ah.Text),
                    TextSize = ah.Size,
                    TextTransparency = 1 - ah.Opacity,
                    TextXAlignment = 'Left',
                    TextYAlignment = 'Center',
                    FontFace = Font.new(ab.Font, Enum.FontWeight.SemiBold),
                    ThemeTag = not ah.Color and {
                        TextColor3 = 'Text',
                    } or nil,
                    TextColor3 = ah.Color,
                    RichText = af.RichText == true,
                    Parent = ai,
                    ZIndex = 99999,
                })

                local function updatePosition(ak)
                    if typeof(ak) == 'UDim2' then
                        ah.Position = ak
                        aj.AnchorPoint = typeof(af.AnchorPoint) == 'Vector2' and af.AnchorPoint or Vector2.new(0.5, 0.5)
                        aj.Position = ak
                        return
                    end

                    ah.Position = ak or 'bottom-right'
                    local al, am = getPresetPosition(ah.Position, ah.Padding, ah.Offset)
                    aj.AnchorPoint = al
                    aj.Position = am
                end

                updatePosition(ah.Position)

                function ah.SetEnabled(ak, al)
                    ah.Enabled = al ~= false
                    ai.Visible = ah.Enabled
                    return ah
                end

                function ah.SetText(ak, al)
                    ah.Text = tostring(al or '')
                    aj.Text = ah.Text
                    return ah
                end

                function ah.SetOpacity(ak, al)
                    ah.Opacity = math.clamp(tonumber(al) or ah.Opacity, 0, 1)
                    ad(aj, 0.1, { TextTransparency = 1 - ah.Opacity }):Play()
                    return ah
                end

                function ah.SetPosition(ak, al)
                    updatePosition(al)
                    return ah
                end

                function ah.SetOffset(ak, al)
                    ah.Offset = typeof(al) == 'Vector2' and al or ah.Offset
                    updatePosition(ah.Position)
                    return ah
                end

                function ah.SetPadding(ak, al)
                    ah.Padding = math.max(math.floor(tonumber(al) or ah.Padding), 0)
                    updatePosition(ah.Position)
                    return ah
                end

                function ah.SetSize(ak, al)
                    ah.Size = math.max(math.floor(tonumber(al) or ah.Size), 8)
                    aj.TextSize = ah.Size
                    return ah
                end

                function ah.Destroy(ak)
                    ai:Destroy()
                end

                ah.Container = ai
                ah.Label = aj

                return ah
            end

            return aa
        end
        function WindUIModules.ConfigManagerModule(): typeof(buildModule())
            local aa = WindUIModules.cache.ConfigManagerModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ConfigManagerModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {
                ConfigName = 'default_config',
                Path = nil,
                Data = {},
                Elements = {},
                Loading = false,
                PendingSave = false,
                Window = nil,
            }

            local ab = (cloneref or clonereference or function(value)
                return value
            end)
            local ac = ab(game:GetService('HttpService'))

            local function sanitizeSegment(value, fallback)
                local result = tostring(value or fallback or 'default_config')
                result = result:gsub('[^%w%._%-]', '_')
                return result ~= '' and result or (fallback or 'default_config')
            end

            local function ensureFolder(path)
                if type(makefolder) ~= 'function' then
                    return false
                end
                if type(isfolder) == 'function' and isfolder(path) then
                    return true
                end
                local ok = pcall(makefolder, path)
                return ok or (type(isfolder) == 'function' and isfolder(path))
            end

            local function readData()
                if type(isfile) ~= 'function' or type(readfile) ~= 'function' or not isfile(aa.Path) then
                    return {}
                end
                local ok, raw = pcall(readfile, aa.Path)
                if not ok or type(raw) ~= 'string' or raw == '' then
                    return {}
                end
                local decodedOk, decoded = pcall(ac.JSONDecode, ac, raw)
                return decodedOk and type(decoded) == 'table' and decoded or {}
            end

            local function writeData()
                if type(writefile) ~= 'function' then
                    return false
                end
                ensureFolder('WindUI_SY')
                ensureFolder('WindUI_SY/Settings')
                local ok, encoded = pcall(ac.JSONEncode, ac, aa.Data)
                if not ok then
                    return false
                end
                local wrote, err = pcall(writefile, aa.Path, encoded)
                return wrote and err ~= false
            end

            local function colorToHex(color)
                if typeof(color) ~= 'Color3' then
                    return nil
                end
                if type(color.ToHex) == 'function' then
                    local ok, value = pcall(function()
                        return color:ToHex()
                    end)
                    if ok and value then
                        return value
                    end
                end
                return string.format(
                    '%02x%02x%02x',
                    math.floor(color.R * 255 + 0.5),
                    math.floor(color.G * 255 + 0.5),
                    math.floor(color.B * 255 + 0.5)
                )
            end

            local function colorFromValue(value)
                if typeof(value) == 'Color3' then
                    return value
                end
                if type(value) == 'string' then
                    local ok, color = pcall(Color3.fromHex, value)
                    if ok then
                        return color
                    end
                end
                if type(value) == 'table' and tonumber(value.r) and tonumber(value.g) and tonumber(value.b) then
                    return Color3.new(tonumber(value.r), tonumber(value.g), tonumber(value.b))
                end
                return nil
            end

            local function copySerializable(value, depth)
                depth = depth or 0
                if depth > 8 then
                    return nil
                end
                if typeof(value) == 'Color3' then
                    return {__color = colorToHex(value)}
                end
                if typeof(value) == 'EnumItem' then
                    return value.Name
                end
                if type(value) ~= 'table' then
                    return value
                end
                local result = {}
                for key, item in pairs(value) do
                    if type(key) == 'string' or type(key) == 'number' then
                        local copied = copySerializable(item, depth + 1)
                        if copied ~= nil then
                            result[key] = copied
                        end
                    end
                end
                return result
            end

            local function optionTitle(value)
                if type(value) == 'table' then
                    return value.Title or value.Value or value.Name
                end
                return value
            end

            local function getCurrentValue(element)
                if not element then
                    return nil
                end
                if element.__type == 'Colorpicker' then
                    return element.Default
                end
                if type(element.GetSelected) == 'function' then
                    local ok, value = pcall(element.GetSelected, element)
                    if ok then
                        return value
                    end
                end
                if type(element.GetValue) == 'function' then
                    local ok, value = pcall(element.GetValue, element)
                    if ok then
                        return value
                    end
                end
                if element.__type == 'Slider' and type(element.Value) == 'table' then
                    return element.Value.Default
                end
                if element.Value ~= nil then
                    return element.Value
                end
                if type(element.Get) == 'function' then
                    local ok, value = pcall(element.Get, element)
                    if ok then
                        return value
                    end
                end
                return nil
            end

            local function serializeValue(element)
                if not element or type(element) ~= 'table' then
                    return nil
                end

                local elementType = element.__type
                if elementType == 'Toggle' then
                    return type(element.Value) == 'boolean' and element.Value or nil
                elseif elementType == 'ToggleKeybind' then
                    return {
                        value = type(element.Value) == 'boolean' and element.Value or false,
                        keybind = element.Keybind,
                    }
                elseif elementType == 'Slider' then
                    local value = type(element.Value) == 'table' and element.Value.Default or element.Value
                    return tonumber(value)
                elseif elementType == 'Stepper' or elementType == 'Progress' then
                    return tonumber(element.Value)
                elseif elementType == 'Keybind' then
                    return tostring(element.Value or 'F')
                elseif elementType == 'Input' then
                    return tostring(element.Value or '')
                elseif elementType == 'Dropdown' then
                    local value = getCurrentValue(element)
                    if element.Multi then
                        local result = {}
                        if type(value) == 'table' then
                            for _, item in ipairs(value) do
                                local title = optionTitle(item)
                                if title ~= nil then
                                    result[#result + 1] = copySerializable(title)
                                end
                            end
                        end
                        return result
                    end
                    return copySerializable(optionTitle(value))
                elseif elementType == 'Segmented' then
                    local value = getCurrentValue(element)
                    if element.Multi then
                        local result = {}
                        if type(value) == 'table' then
                            for _, item in ipairs(value) do
                                result[#result + 1] = copySerializable(item)
                            end
                        end
                        return result
                    end
                    return copySerializable(value)
                elseif elementType == 'Colorpicker' then
                    local color = element.Default or element.Value
                    local hex = colorToHex(color)
                    if not hex then
                        return nil
                    end
                    return {
                        color = hex,
                        transparency = tonumber(element.Transparency),
                    }
                elseif elementType == 'Stats' then
                    if type(element.GetItems) == 'function' then
                        local ok, items = pcall(element.GetItems, element)
                        if ok then
                            return copySerializable(items)
                        end
                    end
                    return copySerializable(element.Items)
                end

                return nil
            end

            local function applyValue(element, data)
                if not element or type(data) == 'nil' then
                    return false
                end

                local elementType = element.__type
                if elementType == 'Toggle' then
                    if type(data) == 'boolean' and type(element.Set) == 'function' then
                        element:Set(data)
                        return true
                    end
                elseif elementType == 'ToggleKeybind' then
                    if type(data) == 'table' then
                        if type(data.value) == 'boolean' and type(element.Set) == 'function' then
                            element:Set(data.value)
                        end
                        if data.keybind and type(element.SetKeybind) == 'function' then
                            element:SetKeybind(data.keybind)
                        end
                        return true
                    elseif type(data) == 'boolean' and type(element.Set) == 'function' then
                        element:Set(data)
                        return true
                    end
                elseif elementType == 'Dropdown' then
                    if type(element.Select) == 'function' then
                        element:Select(data, true)
                        return true
                    end
                elseif elementType == 'Segmented' then
                    if type(element.Set) == 'function' then
                        element:Set(data, true)
                        return true
                    end
                elseif elementType == 'Colorpicker' then
                    local color = type(data) == 'table' and colorFromValue(data.color or data.value) or colorFromValue(data)
                    if color and type(element.Set) == 'function' then
                        element:Set(color, type(data) == 'table' and tonumber(data.transparency) or nil)
                        return true
                    end
                elseif elementType == 'Stats' then
                    if type(element.Set) == 'function' and type(data) == 'table' then
                        element:Set(data)
                        return true
                    end
                elseif elementType == 'Slider'
                    or elementType == 'Stepper'
                    or elementType == 'Progress'
                    or elementType == 'Keybind'
                    or elementType == 'Input'
                then
                    if type(element.Set) == 'function' then
                        element:Set(data)
                        return true
                    end
                end

                return false
            end

            function aa.Init(_, window)
                aa.Window = window
                aa.ConfigName = sanitizeSegment(window and window.ConfigName, 'default_config')
                aa.Path = 'WindUI_SY/Settings/' .. aa.ConfigName .. '.json'
                aa.Elements = {}
                aa.Loading = false
                aa.PendingSave = false
                ensureFolder('WindUI_SY')
                ensureFolder('WindUI_SY/Settings')
                aa.Data = readData()
                return aa
            end

            function aa.Get(_, key)
                return aa.Data[key]
            end

            function aa.Set(_, key, value)
                if type(key) ~= 'string' then
                    return value
                end
                aa.Data[key] = value
                aa:ScheduleSave()
                return value
            end

            function aa.Capture(_, flag, element)
                if aa.Loading then
                    return
                end
                local value = serializeValue(element)
                if value ~= nil then
                    aa.Data[flag] = value
                    aa:ScheduleSave()
                end
            end

            function aa.Save(_)
                aa.PendingSave = false
                return writeData()
            end

            function aa.ScheduleSave(_)
                if aa.PendingSave or aa.Loading then
                    return aa
                end
                aa.PendingSave = true
                task.defer(function()
                    if aa.PendingSave and not aa.Loading then
                        aa:Save()
                    end
                end)
                return aa
            end

            function aa.Register(_, flag, element)
                if type(flag) ~= 'string' or not element then
                    return element
                end

                aa.Elements[flag] = element
                local elementType = element.__type
                local supported = {
                    Toggle = true,
                    ToggleKeybind = true,
                    Slider = true,
                    Stepper = true,
                    Keybind = true,
                    Input = true,
                    Dropdown = true,
                    Segmented = true,
                    Colorpicker = true,
                    Progress = true,
                    Stats = true,
                }

                if supported[elementType] then
                    if type(element.Set) == 'function' and not element.__WindUISynergySetWrapped then
                        local originalSet = element.Set
                        element.__WindUISynergySetWrapped = true
                        element.Set = function(self, value, ...)
                            local result = {pcall(originalSet, self, value, ...)}
                            if not result[1] then
                                error(result[2], 0)
                            end
                            if not aa.Loading then
                                aa:Capture(flag, self)
                            end
                            table.remove(result, 1)
                            return table.unpack(result)
                        end
                    end

                    if type(element.Callback) == 'function' and not element.__WindUISynergyCallbackWrapped then
                        local originalCallback = element.Callback
                        element.__WindUISynergyCallbackWrapped = true
                        element.Callback = function(...)
                            local result = {pcall(originalCallback, ...)}
                            if not result[1] then
                                warn('[ WindUI ] Callback error: ' .. tostring(result[2]))
                            end
                            if not aa.Loading then
                                aa:Capture(flag, element)
                            end
                            table.remove(result, 1)
                            return table.unpack(result)
                        end
                    end

                    local extraMethods = {
                        'Select',
                        'Deselect',
                        'Toggle',
                        'Refresh',
                        'SetOptions',
                        'SetKeybind',
                        'SetPlaceholder',
                        'SetColor',
                        'SetRange',
                        'SetStep',
                        'SetPrecision',
                        'SetPrefix',
                        'SetSuffix',
                        'SetFormat',
                        'Update',
                        'Add',
                        'Remove',
                        'Clear',
                    }
                    for _, methodName in ipairs(extraMethods) do
                        local method = element[methodName]
                        local marker = '__WindUISynergy' .. methodName .. 'Wrapped'
                        if type(method) == 'function' and not element[marker] then
                            local originalMethod = method
                            element[marker] = true
                            element[methodName] = function(self, ...)
                                local result = {pcall(originalMethod, self, ...)}
                                if not result[1] then
                                    error(result[2], 0)
                                end
                                if not aa.Loading then
                                    aa:Capture(flag, self)
                                end
                                table.remove(result, 1)
                                return table.unpack(result)
                            end
                        end
                    end
                end

                if aa.Data[flag] ~= nil and supported[elementType] then
                    aa.Loading = true
                    applyValue(element, aa.Data[flag])
                    aa.Loading = false
                end
                return element
            end

            function aa.Unregister(_, flag)
                aa.Elements[flag] = nil
            end

            function aa.Load(_)
                aa.Data = readData()
                aa.Loading = true
                for flag, element in pairs(aa.Elements) do
                    if aa.Data[flag] ~= nil then
                        applyValue(element, aa.Data[flag])
                    end
                end
                aa.Loading = false
                aa.PendingSave = false
                return aa.Data
            end

            function aa.GetAll(_)
                return aa.Data
            end

            return aa
        end
        function WindUIModules.OpenButtonModule(): typeof(buildModule())
            local aa = WindUIModules.cache.OpenButtonModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.OpenButtonModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            local ae = (cloneref or clonereference or function(ae)
                return ae
            end)

            ae(game:GetService('UserInputService'))

            function aa.New(af)
                local ag = {
                    Button = nil,
                }

                local ah

                local ai = ac('TextLabel', {
                    Text = af.Title,
                    TextSize = 17,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                    BackgroundTransparency = 1,
                    AutomaticSize = 'XY',
                })

                local aj = ac('Frame', {
                    Size = UDim2.new(0, 36, 0, 36),
                    BackgroundTransparency = 1,
                    Name = 'Drag',
                }, {
                    ac('ImageLabel', {
                        Image = ab.Icon('move')[1],
                        ImageRectOffset = ab.Icon('move')[2].ImageRectPosition,
                        ImageRectSize = ab.Icon('move')[2].ImageRectSize,
                        Size = UDim2.new(0, 18, 0, 18),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ThemeTag = {
                            ImageColor3 = 'Icon',
                        },
                        ImageTransparency = 0.3,
                    }),
                })
                local ak = ac('Frame', {
                    Size = UDim2.new(0, 1, 1, 0),
                    Position = UDim2.new(0, 36, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 0.9,
                })

                local al = ac('Frame', {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0, 28),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = af.Parent,
                    BackgroundTransparency = 1,
                    Active = true,
                    Visible = false,
                })

                local am = ac('UIScale', {
                    Scale = 1,
                })

                local an = ac('Frame', {
                    Size = UDim2.new(0, 0, 0, 44),
                    AutomaticSize = 'X',
                    Parent = al,
                    Active = false,
                    BackgroundTransparency = 0.25,
                    ZIndex = 99,
                    BackgroundColor3 = Color3.new(0, 0, 0),
                }, {
                    am,
                    ac('UICorner', {
                        CornerRadius = UDim.new(1, 0),
                    }),
                    ac('UIStroke', {
                        Thickness = 1,
                        ApplyStrokeMode = 'Border',
                        Color = Color3.new(1, 1, 1),
                        Transparency = 0,
                    }, {
                        ac('UIGradient', {
                            Color = ColorSequence.new(Color3.fromHex('40c9ff'), Color3.fromHex('e81cff')),
                        }),
                    }),
                    aj,
                    ak,

                    ac('UIListLayout', {
                        Padding = UDim.new(0, 4),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                    }),

                    ac('TextButton', {
                        AutomaticSize = 'XY',
                        Active = true,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 0, 36),

                        BackgroundColor3 = Color3.new(1, 1, 1),
                    }, {
                        ac('UICorner', {
                            CornerRadius = UDim.new(1, -4),
                        }),
                        ah,
                        ac('UIListLayout', {
                            Padding = UDim.new(0, af.UIPadding),
                            FillDirection = 'Horizontal',
                            VerticalAlignment = 'Center',
                        }),
                        ai,
                        ac('UIPadding', {
                            PaddingLeft = UDim.new(0, 11),
                            PaddingRight = UDim.new(0, 11),
                        }),
                    }),
                    ac('UIPadding', {
                        PaddingLeft = UDim.new(0, 4),
                        PaddingRight = UDim.new(0, 4),
                    }),
                })

                ag.Button = an

                function ag.SetIcon(ao, ap)
                    if ah then
                        ah:Destroy()
                    end
                    if ap then
                        ah = ab.Image(ap, af.Title, 0, af.Folder, 'OpenButton', true, af.IconThemed)
                        ah.Size = UDim2.new(0, 22, 0, 22)
                        ah.LayoutOrder = -1
                        ah.Parent = ag.Button.TextButton
                    end
                end

                if af.Icon then
                    ag:SetIcon(af.Icon)
                end

                ab.AddSignal(an:GetPropertyChangedSignal('AbsoluteSize'), function()
                    al.Size = UDim2.new(0, an.AbsoluteSize.X, 0, an.AbsoluteSize.Y)
                end)

                ab.AddSignal(an.TextButton.MouseEnter, function()
                    ad(an.TextButton, 0.1, { BackgroundTransparency = 0.93 }):Play()
                end)
                ab.AddSignal(an.TextButton.MouseLeave, function()
                    ad(an.TextButton, 0.1, { BackgroundTransparency = 1 }):Play()
                end)

                local ao = ab.Drag(al)

                function ag.Visible(ap, aq)
                    al.Visible = aq
                end

                function ag.SetScale(ap, aq)
                    am.Scale = aq
                end

                function ag.Edit(ap, aq)
                    local ar = {
                        Title = aq.Title,
                        Icon = aq.Icon,
                        Enabled = aq.Enabled,
                        Position = aq.Position,
                        OnlyIcon = aq.OnlyIcon or false,
                        Draggable = aq.Draggable or nil,
                        OnlyMobile = aq.OnlyMobile,
                        CornerRadius = aq.CornerRadius or UDim.new(1, 0),
                        StrokeThickness = aq.StrokeThickness or 2,
                        Scale = aq.Scale or 1,
                        Color = aq.Color or ColorSequence.new(Color3.fromHex('40c9ff'), Color3.fromHex('e81cff')),
                    }

                    if ar.Enabled == false then
                        af.IsOpenButtonEnabled = false
                    end

                    if ar.OnlyMobile ~= false then
                        ar.OnlyMobile = true
                    else
                        af.IsPC = false
                    end

                    if ar.Draggable == false and aj and ak then
                        aj.Visible = ar.Draggable
                        ak.Visible = ar.Draggable

                        if ao then
                            ao:Set(false)
                        end
                    end

                    if ar.Position and al then
                        al.Position = ar.Position
                    end

                    if ar.OnlyIcon == true and ai then
                        ai.Visible = false
                        an.TextButton.UIPadding.PaddingLeft = UDim.new(0, 7)
                        an.TextButton.UIPadding.PaddingRight = UDim.new(0, 7)
                    elseif ar.OnlyIcon == false then
                        ai.Visible = true
                        an.TextButton.UIPadding.PaddingLeft = UDim.new(0, 11)
                        an.TextButton.UIPadding.PaddingRight = UDim.new(0, 11)
                    end

                    if ai then
                        if ar.Title then
                            ai.Text = ar.Title
                            ab:ChangeTranslationKey(ai, ar.Title)
                        elseif ar.Title == nil then
                        end
                    end

                    if ar.Icon then
                        ag:SetIcon(ar.Icon)
                    end

                    an.UIStroke.UIGradient.Color = ar.Color
                    local as = an:FindFirstChild('Glow')
                    if as and as:FindFirstChild('UIGradient') then
                        as.UIGradient.Color = ar.Color
                    end

                    an.UICorner.CornerRadius = ar.CornerRadius
                    an.TextButton.UICorner.CornerRadius = UDim.new(ar.CornerRadius.Scale, ar.CornerRadius.Offset - 4)
                    an.UIStroke.Thickness = ar.StrokeThickness

                    ag:SetScale(ar.Scale)
                end

                return ag
            end

            return aa
        end
        function WindUIModules.TooltipModule(): typeof(buildModule())
            local aa = WindUIModules.cache.TooltipModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.TooltipModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            function aa.New(ae, af, ag, ah, ai, aj)
                local ak = {
                    Container = nil,
                    TooltipSize = 16,

                    TooltipArrowSizeX = ai == 'Small' and 16 or 24,
                    TooltipArrowSizeY = ai == 'Small' and 6 or 9,

                    PaddingX = ai == 'Small' and 12 or 14,
                    PaddingY = ai == 'Small' and 7 or 9,

                    Radius = 999,

                    TitleFrame = nil,
                }

                ah = ah or ''
                aj = aj ~= false

                local al = ac('TextLabel', {
                    AutomaticSize = 'XY',
                    TextWrapped = aj,
                    BackgroundTransparency = 1,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                    Text = ae,
                    TextSize = ai == 'Small' and 15 or 17,
                    TextTransparency = 1,
                    ThemeTag = {
                        TextColor3 = 'Tooltip' .. ah .. 'Text',
                    },
                })

                ak.TitleFrame = al

                local am = ac('UIScale', {
                    Scale = 0.9,
                })

                local an = ac('Frame', {
                    AnchorPoint = Vector2.new(0.5, 0),
                    AutomaticSize = 'XY',
                    BackgroundTransparency = 1,
                    Parent = af,

                    Visible = false,
                }, {
                    ac('UISizeConstraint', {
                        MaxSize = Vector2.new(400, math.huge),
                    }),
                    ac('Frame', {
                        AutomaticSize = 'XY',
                        BackgroundTransparency = 1,
                        LayoutOrder = 99,
                        Visible = ag,
                        Name = 'Arrow',
                    }, {
                        ac('ImageLabel', {
                            Size = UDim2.new(0, ak.TooltipArrowSizeX, 0, ak.TooltipArrowSizeY),
                            BackgroundTransparency = 1,

                            Image = 'rbxassetid://105854070513330',
                            ThemeTag = {
                                ImageColor3 = 'Tooltip' .. ah,
                            },
                        }, {}),
                    }),
                    ab.NewRoundFrame(ak.Radius, 'Squircle', {
                        AutomaticSize = 'XY',
                        ThemeTag = {
                            ImageColor3 = 'Tooltip' .. ah,
                        },
                        ImageTransparency = 1,
                        Name = 'Background',
                    }, {

                        ac('Frame', {

                            AutomaticSize = 'XY',
                            BackgroundTransparency = 1,
                        }, {
                            ac('UICorner', {
                                CornerRadius = UDim.new(0, 16),
                            }),
                            ac('UIListLayout', {
                                Padding = UDim.new(0, 12),
                                FillDirection = 'Horizontal',
                                VerticalAlignment = 'Center',
                            }),

                            al,
                            ac('UIPadding', {
                                PaddingTop = UDim.new(0, ak.PaddingY),
                                PaddingLeft = UDim.new(0, ak.PaddingX),
                                PaddingRight = UDim.new(0, ak.PaddingX),
                                PaddingBottom = UDim.new(0, ak.PaddingY),
                            }),
                        }),
                    }),
                    am,
                    ac('UIListLayout', {
                        Padding = UDim.new(0, 0),
                        FillDirection = 'Vertical',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                    }),
                })
                ak.Container = an

                function ak.Open(ao)
                    an.Visible = true

                    ad(an.Background, 0.2, { ImageTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    ad(
                        an.Arrow.ImageLabel,
                        0.2,
                        { ImageTransparency = 0 },
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ):Play()
                    ad(al, 0.2, { TextTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    ad(am, 0.22, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end

                function ak.Close(ao, ap)
                    ad(an.Background, 0.3, { ImageTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    ad(
                        an.Arrow.ImageLabel,
                        0.2,
                        { ImageTransparency = 1 },
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ):Play()
                    ad(al, 0.3, { TextTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    ad(am, 0.35, { Scale = 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()

                    ap = ap ~= false
                    if ap then
                        task.wait(0.35)

                        an.Visible = false
                        an:Destroy()
                    end
                end

                return ak
            end

            return aa
        end
        function WindUIModules.ColorPickerUtilities(): typeof(buildModule())
            local aa = WindUIModules.cache.ColorPickerUtilities
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ColorPickerUtilities = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ab = aa.New
            local ac = aa.NewRoundFrame
            local ad = aa.Tween

            local ae = (cloneref or clonereference or function(ae)
                return ae
            end)

            ae(game:GetService('UserInputService'))

            local function Color3ToHSB(af)
                local ag, ah, ai = af.R, af.G, af.B
                local aj = math.max(ag, ah, ai)
                local ak = math.min(ag, ah, ai)
                local al = aj - ak

                local am = 0
                if al ~= 0 then
                    if aj == ag then
                        am = (ah - ai) / al % 6
                    elseif aj == ah then
                        am = (ai - ag) / al + 2
                    else
                        am = (ag - ah) / al + 4
                    end
                    am = am * 60
                else
                    am = 0
                end

                local an = (aj == 0) and 0 or (al / aj)
                local ao = aj

                return {
                    h = math.floor(am + 0.5),
                    s = an,
                    b = ao,
                }
            end

            local function GetPerceivedBrightness(af)
                local ag = af.R
                local ah = af.G
                local ai = af.B
                return 0.299 * ag + 0.587 * ah + 0.114 * ai
            end

            local function GetTextColorForHSB(af)
                local ag = Color3ToHSB(af)
                local ah, ai, aj = ag.h, ag.s, ag.b
                if GetPerceivedBrightness(af) > 0.5 then
                    return Color3.fromHSV(ah / 360, 0, 0.05)
                else
                    return Color3.fromHSV(ah / 360, 0, 0.98)
                end
            end

            local function ResolveRoundedCorner(af, ag)
                return math.max((tonumber(af) or 0) - (tonumber(ag) or 0), 0)
            end

            local function ResolveShapeFrame(af)
                if typeof(af) ~= 'table' then
                    return nil
                end

                if typeof(af.__ShapeFrame) == 'table' and type(af.__ShapeFrame.UpdateShape) == 'function' then
                    return af.__ShapeFrame
                end

                for ag, ah in next, af do
                    if
                        typeof(ah) == 'table'
                        and ag ~= 'ElementFrame'
                        and ag:match('Frame$')
                        and type(ah.UpdateShape) == 'function'
                    then
                        return ah
                    end
                end

                return nil
            end

            local function getElementPosition(af, ag, ah)
                if type(ag) ~= 'number' or ag ~= math.floor(ag) then
                    return nil, 1
                end

                local ai = #af

                if ai == 0 or ag < 1 or ag > ai then
                    return nil, 2
                end

                local function isDelimiter(aj)
                    if aj == nil or typeof(aj) ~= 'table' then
                        return true
                    end

                    if typeof(ah) == 'string' and typeof(aj.ParentType) == 'string' and aj.ParentType ~= ah then
                        return true
                    end

                    local ak = aj.__type
                    if ak == 'Space' or ak == 'Divider' or ak == 'Section' or ak == 'MultiSection' or ak == 'Code' then
                        return true
                    end

                    return ResolveShapeFrame(aj) == nil
                end

                if isDelimiter(af[ag]) then
                    return nil, 3
                end

                local function calculate(aj, ak)
                    if ak <= 1 then
                        return 'Squircle'
                    end
                    if aj == 1 then
                        return 'Squircle-TL-TR'
                    end
                    if aj == ak then
                        return 'Squircle-BL-BR'
                    end
                    return 'Square'
                end

                local aj = 1
                local ak = 0

                for al = 1, ai do
                    local am = af[al]
                    if isDelimiter(am) then
                        if ag >= aj and ag <= al - 1 then
                            local an = ag - aj + 1
                            return calculate(an, ak)
                        end
                        aj = al + 1
                        ak = 0
                    else
                        ak = ak + 1
                    end
                end

                if ag >= aj and ag <= ai then
                    local al = ag - aj + 1
                    return calculate(al, ak)
                end

                return nil, 4
            end

            return function(af)
                local ag = {
                    Title = af.Title,
                    Desc = af.Desc or nil,
                    Hover = af.Hover,
                    Thumbnail = af.Thumbnail,
                    ThumbnailSize = af.ThumbnailSize or 80,
                    Image = af.Image,
                    IconThemed = af.IconThemed or false,
                    ImageSize = af.ImageSize or 30,
                    Color = af.Color,
                    Scalable = af.Scalable,
                    Parent = af.Parent,
                    Justify = af.Justify or 'Between',
                    UIPadding = af.Window.ElementConfig.UIPadding,
                    UICorner = af.Window.ElementConfig.UICorner,
                    Size = af.Size or 'Default',
                    UIElements = {},

                    Index = af.Index,
                }

                local ah = ag.Size == 'Small' and -4 or ag.Size == 'Large' and 4 or 0
                local ai = ag.Size == 'Small' and -4 or ag.Size == 'Large' and 4 or 0

                local aj = ag.ImageSize
                local ak = ag.ThumbnailSize
                local al = true

                local am = 0

                local an
                local ao
                if ag.Thumbnail then
                    an = aa.Image(
                        ag.Thumbnail,
                        ag.Title,
                        ResolveRoundedCorner(ag.UICorner, af.Window.ModernLayout and 11 or 4),
                        af.Window.Folder,
                        'Thumbnail',
                        false,
                        ag.IconThemed
                    )
                    an.Size = UDim2.new(1, 0, 0, ak)
                end
                if ag.Image then
                    ao = aa.Image(
                        ag.Image,
                        ag.Title,
                        ResolveRoundedCorner(ag.UICorner, af.Window.ModernLayout and 11 or 4),
                        af.Window.Folder,
                        'Image',
                        ag.IconThemed,
                        not ag.Color and true or false,
                        'ElementIcon'
                    )
                    if typeof(ag.Color) == 'string' then
                        ao.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
                    elseif typeof(ag.Color) == 'Color3' then
                        ao.ImageLabel.ImageColor3 = GetTextColorForHSB(ag.Color)
                    end

                    ao.Size = UDim2.new(0, aj, 0, aj)

                    am = aj
                end

                local function CreateText(ap, aq)
                    local ar = typeof(ag.Color) == 'string' and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
                        or typeof(ag.Color) == 'Color3' and GetTextColorForHSB(ag.Color)

                    return ab('TextLabel', {
                        BackgroundTransparency = 1,
                        Text = ap or '',
                        TextSize = aq == 'Desc' and 15 or 17,
                        TextXAlignment = 'Left',
                        ThemeTag = {
                            TextColor3 = not ag.Color and ('Element' .. aq) or nil,
                        },
                        TextColor3 = ag.Color and ar or nil,
                        TextTransparency = aq == 'Desc' and 0.3 or 0,
                        TextWrapped = true,
                        Size = UDim2.new(ag.Justify == 'Between' and 1 or 0, 0, 0, 0),
                        AutomaticSize = ag.Justify == 'Between' and 'Y' or 'XY',
                        FontFace = Font.new(
                            aa.Font,
                            aq == 'Desc' and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold
                        ),
                    })
                end

                local ap = CreateText(ag.Title, 'Title')
                local aq = CreateText(ag.Desc, 'Desc')
                if not ag.Title or ag.Title == '' then
                    aq.Visible = false
                end
                if not ag.Desc or ag.Desc == '' then
                    aq.Visible = false
                end

                ag.UIElements.Title = ap
                ag.UIElements.Desc = aq

                ag.UIElements.Container = ab('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                }, {
                    ab('UIListLayout', {
                        Padding = UDim.new(0, ag.UIPadding),
                        FillDirection = 'Vertical',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = ag.Justify == 'Between' and 'Left' or 'Center',
                    }),
                    an,
                    ab('Frame', {
                        Size = UDim2.new(
                            ag.Justify == 'Between' and 1 or 0,
                            ag.Justify == 'Between' and -af.TextOffset or 0,
                            0,
                            0
                        ),
                        AutomaticSize = ag.Justify == 'Between' and 'Y' or 'XY',
                        BackgroundTransparency = 1,
                        Name = 'TitleFrame',
                    }, {
                        ab('UIListLayout', {
                            Padding = UDim.new(0, ag.UIPadding),
                            FillDirection = 'Horizontal',
                            VerticalAlignment = af.Window.ModernLayout and (ag.Justify == 'Between' and 'Top' or 'Center')
                                or 'Center',
                            HorizontalAlignment = ag.Justify ~= 'Between' and ag.Justify or 'Center',
                        }),
                        ao,
                        ab('Frame', {
                            BackgroundTransparency = 1,
                            AutomaticSize = ag.Justify == 'Between' and 'Y' or 'XY',
                            Size = UDim2.new(
                                ag.Justify == 'Between' and 1 or 0,
                                ag.Justify == 'Between' and (ao and -am - ag.UIPadding or -am) or 0,
                                1,
                                0
                            ),
                            Name = 'TitleFrame',
                        }, {
                            ab('UIPadding', {
                                PaddingTop = UDim.new(0, (af.Window.ModernLayout and ag.UIPadding / 2 or 0) + ai),
                                PaddingLeft = UDim.new(0, (af.Window.ModernLayout and ag.UIPadding / 2 or 0) + ah),
                                PaddingRight = UDim.new(0, (af.Window.ModernLayout and ag.UIPadding / 2 or 0) + ah),
                                PaddingBottom = UDim.new(0, (af.Window.ModernLayout and ag.UIPadding / 2 or 0) + ai),
                            }),
                            ab('UIListLayout', {
                                Padding = UDim.new(0, 6),
                                FillDirection = 'Vertical',
                                VerticalAlignment = 'Center',
                                HorizontalAlignment = 'Left',
                            }),
                            ap,
                            aq,
                        }),
                    }),
                })

                local ar = aa.Image('lock', 'lock', 0, af.Window.Folder, 'Lock', false)
                ar.Size = UDim2.new(0, 20, 0, 20)
                ar.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
                ar.ImageLabel.ImageTransparency = 0.4

                local as = ab('TextLabel', {
                    Text = 'Locked',
                    TextSize = 18,
                    FontFace = Font.new(aa.Font, Enum.FontWeight.Medium),
                    AutomaticSize = 'XY',
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextTransparency = 0.05,
                })

                local at = ab('Frame', {
                    Size = UDim2.new(1, ag.UIPadding * 2, 1, ag.UIPadding * 2),
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 9999999,
                })

                local au, av = ac(ag.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 0.25,
                    ImageColor3 = Color3.new(0, 0, 0),
                    Visible = false,
                    Active = false,
                    Parent = at,
                }, {
                    ab('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                        Padding = UDim.new(0, 8),
                    }),
                    ar,
                    as,
                }, nil, true)

                local aw, ax = ac(ag.UICorner, 'Squircle-Outline', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 1,
                    Active = false,
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    Parent = at,
                }, {
                    ab('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                        Padding = UDim.new(0, 8),
                    }),
                }, nil, true)

                local ay, az = ac(ag.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 1,
                    Active = false,
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    Parent = at,
                }, {
                    ab('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                        Padding = UDim.new(0, 8),
                    }),
                }, nil, true)

                local aA, aB = ac(ag.UICorner, 'Squircle-Outline', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 1,
                    Active = false,
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    Parent = at,
                }, {
                    ab('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                        Padding = UDim.new(0, 8),
                    }),
                    ab('UIGradient', {
                        Name = 'HoverGradient',
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
                        }),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1),
                            NumberSequenceKeypoint.new(0.25, 0.9),
                            NumberSequenceKeypoint.new(0.5, 0.3),
                            NumberSequenceKeypoint.new(0.75, 0.9),
                            NumberSequenceKeypoint.new(1, 1),
                        }),
                    }),
                }, nil, true)

                local b, d = ac(ag.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 1,
                    Active = false,
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    Parent = at,
                }, {
                    ab('UIGradient', {
                        Name = 'HoverGradient',
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
                        }),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1),
                            NumberSequenceKeypoint.new(0.25, 0.9),
                            NumberSequenceKeypoint.new(0.5, 0.3),
                            NumberSequenceKeypoint.new(0.75, 0.9),
                            NumberSequenceKeypoint.new(1, 1),
                        }),
                    }),
                    ab('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                        Padding = UDim.new(0, 8),
                    }),
                }, nil, true)

                local f, g = ac(ag.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    ImageTransparency = ag.Color and 0.05 or 0.93,

                    Parent = af.Parent,
                    ThemeTag = {
                        ImageColor3 = not ag.Color and 'ElementBackground' or nil,
                    },
                    ImageColor3 = ag.Color
                            and (typeof(ag.Color) == 'string' and Color3.fromHex(aa.Colors[ag.Color]) or typeof(
                                ag.Color
                            ) == 'Color3' and ag.Color)
                        or nil,
                }, {
                    ag.UIElements.Container,
                    at,
                    ab('UIPadding', {
                        PaddingTop = UDim.new(0, ag.UIPadding),
                        PaddingLeft = UDim.new(0, ag.UIPadding),
                        PaddingRight = UDim.new(0, ag.UIPadding),
                        PaddingBottom = UDim.new(0, ag.UIPadding),
                    }),
                }, true, true)

                ag.UIElements.Main = f
                ag.UIElements.Locked = au

                local h

                if ag.Hover then
                    aa.AddSignal(f.MouseEnter, function()
                        if al then
                            ad(f, 0.12, { ImageTransparency = ag.Color and 0.15 or 0.9 }):Play()
                            ad(b, 0.12, { ImageTransparency = 0.9 }):Play()
                            ad(aA, 0.12, { ImageTransparency = 0.8 }):Play()

                            if h then
                                h:Disconnect()
                                h = nil
                            end

                            h = aa.AddSignal(f.MouseMoved, function(j, l)
                                b.HoverGradient.Offset =
                                    Vector2.new(((j - f.AbsolutePosition.X) / f.AbsoluteSize.X) - 0.5, 0)
                                aA.HoverGradient.Offset =
                                    Vector2.new(((j - f.AbsolutePosition.X) / f.AbsoluteSize.X) - 0.5, 0)
                            end)
                        end
                    end)
                    aa.AddSignal(f.InputEnded, function()
                        if h then
                            h:Disconnect()
                            h = nil
                        end

                        if al then
                            ad(f, 0.12, { ImageTransparency = ag.Color and 0.05 or 0.93 }):Play()
                            ad(b, 0.12, { ImageTransparency = 1 }):Play()
                            ad(aA, 0.12, { ImageTransparency = 1 }):Play()
                        end
                    end)
                end

                function ag.SetTitle(j, l)
                    ag.Title = l
                    ap.Text = l
                end

                function ag.SetDesc(j, l)
                    ag.Desc = l
                    aq.Text = l or ''
                    if not l then
                        aq.Visible = false
                    elseif not aq.Visible then
                        aq.Visible = true
                    end
                end

                function ag.Colorize(j, l, m)
                    if ag.Color then
                        l[m] = typeof(ag.Color) == 'string' and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
                            or typeof(ag.Color) == 'Color3' and GetTextColorForHSB(ag.Color)
                            or nil
                    end
                end

                if af.ElementTable then
                    aa.AddSignal(ap:GetPropertyChangedSignal('Text'), function()
                        if ag.Title ~= ap.Text then
                            ag:SetTitle(ap.Text)
                            af.ElementTable.Title = ap.Text
                        end
                    end)
                    aa.AddSignal(aq:GetPropertyChangedSignal('Text'), function()
                        if ag.Desc ~= aq.Text then
                            ag:SetDesc(aq.Text)
                            af.ElementTable.Desc = aq.Text
                        end
                    end)
                end

                function ag.SetThumbnail(j, l, m)
                    ag.Thumbnail = l
                    if m then
                        ag.ThumbnailSize = m
                        ak = m
                    end

                    if an then
                        if l then
                            an:Destroy()
                            an = aa.Image(
                                l,
                                ag.Title,
                                ResolveRoundedCorner(ag.UICorner, 3),
                                af.Window.Folder,
                                'Thumbnail',
                                false,
                                ag.IconThemed
                            )
                            an.Size = UDim2.new(1, 0, 0, ak)
                            an.Parent = ag.UIElements.Container
                            local p = ag.UIElements.Container:FindFirstChild('UIListLayout')
                            if p then
                                an.LayoutOrder = -1
                            end
                        else
                            an.Visible = false
                        end
                    else
                        if l then
                            an = aa.Image(
                                l,
                                ag.Title,
                                ResolveRoundedCorner(ag.UICorner, 3),
                                af.Window.Folder,
                                'Thumbnail',
                                false,
                                ag.IconThemed
                            )
                            an.Size = UDim2.new(1, 0, 0, ak)
                            an.Parent = ag.UIElements.Container
                            local p = ag.UIElements.Container:FindFirstChild('UIListLayout')
                            if p then
                                an.LayoutOrder = -1
                            end
                        end
                    end
                end

                function ag.SetImage(j, l, m)
                    ag.Image = l
                    if m then
                        ag.ImageSize = m
                        aj = m
                    end

                    if ao then
                        ao:Destroy()
                        ao = nil
                    end

                    if l then
                        ao = aa.Image(
                            l,
                            ag.Title,
                            ResolveRoundedCorner(ag.UICorner, 3),
                            af.Window.Folder,
                            'Image',
                            ag.IconThemed,
                            not ag.Color and true or false,
                            'ElementIcon'
                        )

                        if typeof(ag.Color) == 'string' then
                            ao.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
                        elseif typeof(ag.Color) == 'Color3' then
                            ao.ImageLabel.ImageColor3 = GetTextColorForHSB(ag.Color)
                        end

                        ao.Size = UDim2.new(0, aj, 0, aj)
                        ao.Parent = ag.UIElements.Container.TitleFrame
                        am = aj
                    else
                        am = 0
                    end

                    local p = ao and (-am - ag.UIPadding) or 0
                    ag.UIElements.Container.TitleFrame.TitleFrame.Size = UDim2.new(1, p, 1, 0)
                end

                function ag.Destroy(j)
                    if h then
                        h:Disconnect()
                        h = nil
                    end

                    f:Destroy()
                end

                function ag.Lock(j, l)
                    al = false
                    au.Active = true
                    au.Visible = true
                    as.Text = l or 'Locked'
                end

                function ag.Unlock(j)
                    al = true
                    au.Active = false
                    au.Visible = false
                end

                function ag.Highlight(j)
                    local l = ab('UIGradient', {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
                        }),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1),
                            NumberSequenceKeypoint.new(0.1, 0.9),
                            NumberSequenceKeypoint.new(0.5, 0.3),
                            NumberSequenceKeypoint.new(0.9, 0.9),
                            NumberSequenceKeypoint.new(1, 1),
                        }),
                        Rotation = 0,
                        Offset = Vector2.new(-1, 0),
                        Parent = aw,
                    })

                    local m = ab('UIGradient', {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
                        }),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1),
                            NumberSequenceKeypoint.new(0.15, 0.8),
                            NumberSequenceKeypoint.new(0.5, 0.1),
                            NumberSequenceKeypoint.new(0.85, 0.8),
                            NumberSequenceKeypoint.new(1, 1),
                        }),
                        Rotation = 0,
                        Offset = Vector2.new(-1, 0),
                        Parent = ay,
                    })

                    aw.ImageTransparency = 0.65
                    ay.ImageTransparency = 0.88

                    ad(l, 0.75, {
                        Offset = Vector2.new(1, 0),
                    }):Play()

                    ad(m, 0.75, {
                        Offset = Vector2.new(1, 0),
                    }):Play()

                    task.spawn(function()
                        task.wait(0.75)
                        aw.ImageTransparency = 1
                        ay.ImageTransparency = 1
                        l:Destroy()
                        m:Destroy()
                    end)
                end

                function ag.UpdateShape(j)
                    if af.Window.ModernLayout then
                        local l
                        if af.ParentConfig.ParentType == 'Group' then
                            l = 'Squircle'
                        elseif af.Window.ModernLayoutMergeElements == false then
                            l = 'Squircle'
                        else
                            l = getElementPosition(j.Elements, ag.Index, j.__type)
                        end

                        if l and f and aa.Shapes[l] and aa.Shapes[l .. '-Outline'] then
                            g:SetType(l)
                            av:SetType(l)
                            az:SetType(l)
                            ax:SetType(l .. '-Outline')
                            d:SetType(l)
                            aB:SetType(l .. '-Outline')
                        end
                    end
                end

                return ag
            end
        end
        function WindUIModules.ElementFrameModule(): typeof(buildModule())
            local aa = WindUIModules.cache.ElementFrameModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ElementFrameModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ab = aa.New

            local ac = {}

            local ad = WindUIModules.NotificationModule().New

            function ac.New(ae, af)
                af.Hover = false
                af.TextOffset = 0
                af.ParentConfig = af
                af.IsButtons = af.Buttons and #af.Buttons > 0 and true or false

                local ag = {
                    __type = 'Paragraph',
                    Title = af.Title or 'Paragraph',
                    Desc = af.Desc or nil,

                    Locked = af.Locked or false,
                }
                local ah = WindUIModules.ElementFrameModule()(af)

                ag.ParagraphFrame = ah
                if af.Buttons and #af.Buttons > 0 then
                    local ai = ab('Frame', {
                        Size = UDim2.new(1, 0, 0, 38),
                        BackgroundTransparency = 1,
                        AutomaticSize = 'Y',
                        Parent = ah.UIElements.Container,
                    }, {
                        ab('UIListLayout', {
                            Padding = UDim.new(0, 10),
                            FillDirection = 'Vertical',
                        }),
                    })

                    for aj, ak in next, af.Buttons do
                        local al = ad(ak.Title, ak.Icon, ak.Callback, 'White', ai, nil, nil, 10)
                        al.Size = UDim2.new(1, 0, 0, 38)
                    end
                end

                return ag.__type, ag
            end

            return ac
        end
        function WindUIModules.ParagraphElement(): typeof(buildModule())
            local aa = WindUIModules.cache.ParagraphElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ParagraphElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ab = aa.New

            local ac = {}

            function ac.New(ad, ae)
                local af = {
                    __type = 'Button',
                    Title = ae.Title or 'Button',
                    Desc = ae.Desc or nil,
                    Icon = ae.Icon or 'mouse-pointer-click',
                    IconThemed = ae.IconThemed or false,
                    Color = ae.Color,
                    Justify = ae.Justify or 'Between',
                    IconAlign = ae.IconAlign or 'Right',
                    Locked = ae.Locked or false,
                    LockedTitle = ae.LockedTitle,
                    Callback = ae.Callback or function() end,
                    UIElements = {},
                }

                local ag = true

                af.ButtonFrame = WindUIModules.ElementFrameModule()({
                    Title = af.Title,
                    Desc = af.Desc,
                    Parent = ae.Parent,

                    Window = ae.Window,
                    Color = af.Color,
                    Justify = af.Justify,
                    TextOffset = 20,
                    Hover = true,
                    Scalable = true,
                    Tab = ae.Tab,
                    Index = ae.Index,
                    ElementTable = af,
                    ParentConfig = ae,
                    Size = ae.Size,
                })

                af.UIElements.ButtonIcon = aa.Image(
                    af.Icon,
                    af.Icon,
                    0,
                    ae.Window.Folder,
                    'Button',
                    not af.Color and true or nil,
                    af.IconThemed
                )

                af.UIElements.ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
                af.UIElements.ButtonIcon.Parent = af.Justify == 'Between' and af.ButtonFrame.UIElements.Main
                    or af.ButtonFrame.UIElements.Container.TitleFrame
                af.UIElements.ButtonIcon.LayoutOrder = af.IconAlign == 'Left' and -99999 or 99999
                af.UIElements.ButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
                af.UIElements.ButtonIcon.Position = UDim2.new(1, 0, 0.5, 0)

                af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel, 'ImageColor3')

                function af.Lock(ah)
                    af.Locked = true
                    ag = false
                    return af.ButtonFrame:Lock(af.LockedTitle)
                end
                function af.Unlock(ah)
                    af.Locked = false
                    ag = true
                    return af.ButtonFrame:Unlock()
                end

                if af.Locked then
                    af:Lock()
                end

                aa.AddSignal(af.ButtonFrame.UIElements.Main.MouseButton1Click, function()
                    if ag then
                        task.spawn(function()
                            aa.SafeCallback(af.Callback)
                        end)
                    end
                end)
                return af.__type, af
            end

            return ac
        end
        function WindUIModules.ButtonElement(): typeof(buildModule())
            local aa = WindUIModules.cache.ButtonElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ButtonElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ab = aa(game:GetService('UserInputService'))

            local ac = WindUIModules.LocalizationModule()
            local ad = ac.New

            local ae = WindUIModules.PanelModule().New

            local af = {}

            function af.New(ag, ah)
                local function NormalizeKeyCode(ai)
                    if typeof(ai) == 'EnumItem' then
                        return ai.Name
                    elseif type(ai) == 'string' then
                        return ai
                    else
                        return 'F'
                    end
                end

                local ai = {
                    __type = 'ButtonKeybind',
                    Title = ah.Title or 'Button Keybind',
                    Desc = ah.Desc or nil,
                    Icon = ah.Icon or 'mouse-pointer-click',
                    IconThemed = ah.IconThemed or false,
                    Color = ah.Color,
                    Justify = ah.Justify or 'Between',
                    IconAlign = ah.IconAlign or 'Right',
                    Locked = ah.Locked or false,
                    LockedTitle = ah.LockedTitle,
                    Callback = ah.Callback or function() end,
                    Value = NormalizeKeyCode(ah.Value) or 'F',
                    CanChange = ah.CanChange ~= false,
                    Picking = false,
                    UIElements = {},
                }

                local aj = true
                local ak = false

                ai.ButtonKeybindFrame = WindUIModules.ElementFrameModule()({
                    Title = ai.Title,
                    Desc = ai.Desc,
                    Parent = ah.Parent,
                    Window = ah.Window,
                    Color = ai.Color,
                    Justify = ai.Justify,
                    TextOffset = 85,
                    Hover = true,
                    Scalable = true,
                    Tab = ah.Tab,
                    Index = ah.Index,
                    ElementTable = ai,
                    ParentConfig = ah,
                    Size = ah.Size,
                })

                ai.UIElements.ButtonIcon = ac.Image(
                    ai.Icon,
                    ai.Icon,
                    0,
                    ah.Window.Folder,
                    'Button',
                    not ai.Color and true or nil,
                    ai.IconThemed
                )

                ai.UIElements.ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
                ai.UIElements.ButtonIcon.Parent = ai.Justify == 'Between' and ai.ButtonKeybindFrame.UIElements.Main
                    or ai.ButtonKeybindFrame.UIElements.Container.TitleFrame
                ai.UIElements.ButtonIcon.LayoutOrder = ai.IconAlign == 'Left' and -99999 or 99999
                ai.UIElements.ButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
                ai.UIElements.ButtonIcon.Position = UDim2.new(1, 0, 0.5, 0)

                ai.ButtonKeybindFrame:Colorize(ai.UIElements.ButtonIcon.ImageLabel, 'ImageColor3')

                ai.UIElements.Keybind = ae(ai.Value, nil, ai.ButtonKeybindFrame.UIElements.Main, nil, 10)
                ai.UIElements.Keybind.AnchorPoint = Vector2.new(1, 0.5)
                ai.UIElements.Keybind.Position = UDim2.new(1, 0, 0.5, 0)

                ad('UIScale', {
                    Parent = ai.UIElements.Keybind,
                    Scale = 0.85,
                })

                local function UpdateAccessoriesLayout()
                    local al = 24 + ai.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X
                    local am = al

                    ai.UIElements.Keybind.Size = UDim2.new(0, al, 0, 42)

                    if ai.IconAlign ~= 'Left' and ai.UIElements.ButtonIcon then
                        ai.UIElements.ButtonIcon.Position = UDim2.new(1, -(al + 8), 0.5, 0)
                        am = am + 20 + 8
                    end

                    local an = ai.ButtonKeybindFrame
                        and ai.ButtonKeybindFrame.UIElements
                        and ai.ButtonKeybindFrame.UIElements.Container
                        and ai.ButtonKeybindFrame.UIElements.Container.TitleFrame

                    if an and ai.Justify == 'Between' then
                        an.Size = UDim2.new(1, -am, 0, 0)
                    end
                end

                ac.AddSignal(
                    ai.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal('TextBounds'),
                    function()
                        UpdateAccessoriesLayout()
                    end
                )

                UpdateAccessoriesLayout()

                local function StartPicking()
                    if not aj or not ai.CanChange then
                        return
                    end

                    ai.Picking = true
                    ai.UIElements.Keybind.Frame.Frame.TextLabel.Text = '...'

                    task.wait(0.2)

                    local al
                    al = ab.InputBegan:Connect(function(am)
                        local an

                        if am.UserInputType == Enum.UserInputType.Keyboard then
                            an = am.KeyCode.Name
                        elseif am.UserInputType == Enum.UserInputType.MouseButton1 then
                            an = 'MouseLeft'
                        elseif am.UserInputType == Enum.UserInputType.MouseButton2 then
                            an = 'MouseRight'
                        end

                        if not an then
                            return
                        end

                        local ao
                        ao = ab.InputEnded:Connect(function(ap)
                            if
                                ap.KeyCode.Name == an
                                or (an == 'MouseLeft' and ap.UserInputType == Enum.UserInputType.MouseButton1)
                                or (an == 'MouseRight' and ap.UserInputType == Enum.UserInputType.MouseButton2)
                            then
                                ai.Picking = false
                                ai.UIElements.Keybind.Frame.Frame.TextLabel.Text = an
                                ai.Value = an

                                al:Disconnect()
                                ao:Disconnect()
                            end
                        end)
                    end)
                end

                function ai.Lock(al)
                    ai.Locked = true
                    aj = false
                    return ai.ButtonKeybindFrame:Lock(ai.LockedTitle)
                end

                function ai.Unlock(al)
                    ai.Locked = false
                    aj = true
                    return ai.ButtonKeybindFrame:Unlock()
                end

                function ai.Set(al, am)
                    local an = NormalizeKeyCode(am)
                    ai.Value = an
                    ai.UIElements.Keybind.Frame.Frame.TextLabel.Text = an
                end

                if ai.Locked then
                    ai:Lock()
                end

                ac.AddSignal(ai.UIElements.Keybind.MouseButton1Click, function()
                    if not aj or not ai.CanChange then
                        return
                    end

                    ak = true
                    task.defer(function()
                        ak = false
                    end)

                    StartPicking()
                end)

                ac.AddSignal(ai.ButtonKeybindFrame.UIElements.Main.MouseButton1Click, function()
                    if ak then
                        ak = false
                        return
                    end

                    if aj then
                        task.spawn(function()
                            ac.SafeCallback(ai.Callback)
                        end)
                    end
                end)

                ac.AddSignal(ab.InputBegan, function(al, am)
                    if am or ab:GetFocusedTextBox() then
                        return
                    end

                    if ai.Picking or not aj then
                        return
                    end

                    if al.UserInputType == Enum.UserInputType.Keyboard then
                        if al.KeyCode.Name == ai.Value then
                            ac.SafeCallback(ai.Callback, al.KeyCode.Name)
                        end
                    elseif al.UserInputType == Enum.UserInputType.MouseButton1 and ai.Value == 'MouseLeft' then
                        ac.SafeCallback(ai.Callback, 'MouseLeft')
                    elseif al.UserInputType == Enum.UserInputType.MouseButton2 and ai.Value == 'MouseRight' then
                        ac.SafeCallback(ai.Callback, 'MouseRight')
                    end
                end)

                return ai.__type, ai
            end

            return af
        end
        function WindUIModules.ButtonKeybindElement(): typeof(buildModule())
            local aa = WindUIModules.cache.ButtonKeybindElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ButtonKeybindElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            local ae = game:GetService('UserInputService')

            function aa.New(af, ag, ah, ai, aj, ak)
                local al = {}

                local am = 12
                local an
                if ag and ag ~= '' then
                    an = ac('ImageLabel', {
                        Size = UDim2.new(0, 13, 0, 13),
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Image = ab.Icon(ag)[1],
                        ImageRectOffset = ab.Icon(ag)[2].ImageRectPosition,
                        ImageRectSize = ab.Icon(ag)[2].ImageRectSize,
                        ImageTransparency = 1,
                        ImageColor3 = Color3.new(0, 0, 0),
                    })
                end

                local ao = ac('Frame', {
                    Size = UDim2.new(0, 2, 0, 26),
                    BackgroundTransparency = 1,
                    Parent = ai,
                })

                local ap = ab.NewRoundFrame(am, 'Squircle', {
                    ImageTransparency = 0.85,
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    Parent = ao,
                    Size = UDim2.new(0, 40.8, 0, 24),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                }, {
                    ab.NewRoundFrame(am, 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Layer',
                        ThemeTag = {
                            ImageColor3 = 'Toggle',
                        },
                        ImageTransparency = 1,
                    }),
                    ab.NewRoundFrame(am, 'SquircleOutline', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Stroke',
                        ImageColor3 = Color3.new(1, 1, 1),
                        ImageTransparency = 1,
                    }, {
                        ac('UIGradient', {
                            Rotation = 90,
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0),
                                NumberSequenceKeypoint.new(1, 1),
                            }),
                        }),
                    }),

                    ab.NewRoundFrame(am, 'Squircle', {
                        Size = UDim2.new(0, 20, 0, 20),
                        Position = UDim2.new(0, 2, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        ImageTransparency = 1,
                        Name = 'Frame',
                    }, {
                        ab.NewRoundFrame(am, 'Squircle', {
                            Size = UDim2.new(1, 0, 1, 0),
                            ImageTransparency = 0,
                            ThemeTag = {
                                ImageColor3 = 'ToggleBar',
                            },
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Name = 'Bar',
                        }, {
                            ab.NewRoundFrame(am, 'Glass-1', {
                                Size = UDim2.new(1, 0, 1, 0),
                                ImageColor3 = Color3.new(1, 1, 1),
                                Name = 'Highlight',
                                ImageTransparency = 0.4,
                            }, {}),
                            an,
                            ac('UIScale', {
                                Scale = 1,
                            }),
                        }),
                    }),
                })

                local aq
                local ar

                local as = 20
                local at = ap.Size.X.Offset

                function al.Set(au, av, aw, ax)
                    if not ax then
                        if av then
                            ad(ap.Frame, 0.15, {
                                Position = UDim2.new(0, at - as - 2, 0.5, 0),
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        else
                            ad(ap.Frame, 0.15, {
                                Position = UDim2.new(0, 2, 0.5, 0),
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end
                    else
                        if av then
                            ap.Frame.Position = UDim2.new(0, at - as - 2, 0.5, 0)
                        else
                            ap.Frame.Position = UDim2.new(0, 2, 0.5, 0)
                        end
                    end

                    if av then
                        ad(ap.Layer, 0.1, {
                            ImageTransparency = 0,
                        }):Play()

                        if an then
                            ad(an, 0.1, {
                                ImageTransparency = 0,
                            }):Play()
                        end
                    else
                        ad(ap.Layer, 0.1, {
                            ImageTransparency = 1,
                        }):Play()

                        if an then
                            ad(an, 0.1, {
                                ImageTransparency = 1,
                            }):Play()
                        end
                    end

                    aw = aw ~= false

                    task.spawn(function()
                        if aj and aw then
                            ab.SafeCallback(aj, av)
                        end
                    end)
                end

                function al.Animate(au, av, aw)
                    if not ak.Window.IsToggleDragging then
                        ak.Window.IsToggleDragging = true

                        local ax = av.Position.X
                        local ay = av.Position.Y
                        local az = ap.Frame.Position.X.Offset
                        local aA = false

                        ad(
                            ap.Frame.Bar.UIScale,
                            0.28,
                            { Scale = 1.5 },
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ):Play()
                        ad(
                            ap.Frame.Bar,
                            0.28,
                            { ImageTransparency = 0.85 },
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ):Play()

                        if aq then
                            aq:Disconnect()
                        end

                        aq = ae.InputChanged:Connect(function(aB)
                            if
                                ak.Window.IsToggleDragging
                                and (
                                    aB.UserInputType == Enum.UserInputType.MouseMovement
                                    or aB.UserInputType == Enum.UserInputType.Touch
                                )
                            then
                                if aA then
                                    return
                                end

                                local b = math.abs(aB.Position.X - ax)
                                local d = math.abs(aB.Position.Y - ay)

                                if d > b and d > 10 then
                                    aA = true
                                    ak.Window.IsToggleDragging = false

                                    if aq then
                                        aq:Disconnect()
                                        aq = nil
                                    end
                                    if ar then
                                        ar:Disconnect()
                                        ar = nil
                                    end

                                    ad(ap.Frame, 0.15, {
                                        Position = UDim2.new(0, az, 0.5, 0),
                                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                                    ad(
                                        ap.Frame.Bar.UIScale,
                                        0.23,
                                        { Scale = 1 },
                                        Enum.EasingStyle.Quint,
                                        Enum.EasingDirection.Out
                                    ):Play()
                                    ad(
                                        ap.Frame.Bar,
                                        0.23,
                                        { ImageTransparency = 0 },
                                        Enum.EasingStyle.Quint,
                                        Enum.EasingDirection.Out
                                    ):Play()
                                    return
                                end

                                local f = aB.Position.X - ax
                                local g = math.max(2, math.min(az + f, at - as - 2))
                                local h = 
(ap.Frame.Position.X.Offset - 2) / (at - as - 4)

                                ad(ap.Frame, 0.05, {
                                    Position = UDim2.new(0, g, 0.5, 0),
                                }, Enum.EasingStyle.Linear, Enum.EasingDirection.Out):Play()
                            end
                        end)

                        if ar then
                            ar:Disconnect()
                        end

                        ar = ae.InputEnded:Connect(function(aB)
                            if
                                ak.Window.IsToggleDragging
                                and (
                                    aB.UserInputType == Enum.UserInputType.MouseButton1
                                    or aB.UserInputType == Enum.UserInputType.Touch
                                )
                            then
                                ak.Window.IsToggleDragging = false

                                if aq then
                                    aq:Disconnect()
                                    aq = nil
                                end

                                if ar then
                                    ar:Disconnect()
                                    ar = nil
                                end

                                if aA then
                                    return
                                end

                                local b = ap.Frame.Position.X.Offset
                                local d = math.abs(aB.Position.X - ax)

                                if d < 10 then
                                    local f = not aw.Value
                                    aw:Set(f, true, false)
                                else
                                    local f = b + as / 2
                                    local g = at / 2
                                    local h = f > g
                                    aw:Set(h, true, false)
                                end

                                ad(
                                    ap.Frame.Bar.UIScale,
                                    0.23,
                                    { Scale = 1 },
                                    Enum.EasingStyle.Quint,
                                    Enum.EasingDirection.Out
                                ):Play()
                                ad(
                                    ap.Frame.Bar,
                                    0.23,
                                    { ImageTransparency = 0 },
                                    Enum.EasingStyle.Quint,
                                    Enum.EasingDirection.Out
                                ):Play()
                            end
                        end)
                    end
                end

                return ao, al
            end

            return aa
        end
        function WindUIModules.ToggleUtilities(): typeof(buildModule())
            local aa = WindUIModules.cache.ToggleUtilities
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ToggleUtilities = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = WindUIModules.LocalizationModule()
            local ac = ab.New
            local ad = ab.Tween

            function aa.New(ae, af, ag, ah, ai, aj)
                local ak = {}

                af = af or 'sfsymbols:checkmark'

                local al = 9

                local am =
                    ab.Image(af, af, 0, (aj and aj.Window.Folder or 'Temp'), 'Checkbox', true, false, 'CheckboxIcon')
                am.Size = UDim2.new(1, -26 + ag, 1, -26 + ag)
                am.AnchorPoint = Vector2.new(0.5, 0.5)
                am.Position = UDim2.new(0.5, 0, 0.5, 0)

                local an = ab.NewRoundFrame(al, 'Squircle', {
                    ImageTransparency = 0.85,
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    Parent = ah,
                    Size = UDim2.new(0, 26, 0, 26),
                }, {
                    ab.NewRoundFrame(al, 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Layer',
                        ThemeTag = {
                            ImageColor3 = 'Checkbox',
                        },
                        ImageTransparency = 1,
                    }),
                    ab.NewRoundFrame(al, 'Glass-1.4', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Stroke',
                        ThemeTag = {
                            ImageColor3 = 'CheckboxBorder',
                            ImageTransparency = 'CheckboxBorderTransparency',
                        },
                    }, {}),

                    am,
                })

                function ak.Set(ao, ap)
                    if ap then
                        ad(an.Layer, 0.06, {
                            ImageTransparency = 0,
                        }):Play()

                        ad(am.ImageLabel, 0.06, {
                            ImageTransparency = 0,
                        }):Play()
                    else
                        ad(an.Layer, 0.05, {
                            ImageTransparency = 1,
                        }):Play()

                        ad(am.ImageLabel, 0.06, {
                            ImageTransparency = 1,
                        }):Play()
                    end

                    task.spawn(function()
                        if ai then
                            ab.SafeCallback(ai, ap)
                        end
                    end)
                end

                return an, ak
            end

            return aa
        end
        function WindUIModules.ToggleElementHelper(): typeof(buildModule())
            local aa = WindUIModules.cache.ToggleElementHelper
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ToggleElementHelper = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()

            local ab = WindUIModules.ToggleUtilities().New
            local ac = WindUIModules.ToggleElementHelper().New

            local ad = {}

            function ad.New(ae, af)
                local ag = {
                    __type = 'Toggle',
                    Title = af.Title or 'Toggle',
                    Desc = af.Desc or nil,
                    Locked = af.Locked or false,
                    LockedTitle = af.LockedTitle,
                    Value = af.Value,
                    Icon = af.Icon or nil,
                    IconSize = af.IconSize or 23,
                    Type = af.Type or 'Toggle',
                    Callback = af.Callback or function() end,
                    UIElements = {},
                }
                ag.ToggleFrame = WindUIModules.ElementFrameModule()({
                    Title = ag.Title,
                    Desc = ag.Desc,

                    Window = af.Window,
                    Parent = af.Parent,
                    TextOffset = 52,
                    Hover = false,
                    Tab = af.Tab,
                    Index = af.Index,
                    ElementTable = ag,
                    ParentConfig = af,
                })

                local ah = true

                if ag.Value == nil then
                    ag.Value = false
                end

                function ag.Lock(ai)
                    ag.Locked = true
                    ah = false
                    return ag.ToggleFrame:Lock(ag.LockedTitle)
                end
                function ag.Unlock(ai)
                    ag.Locked = false
                    ah = true
                    return ag.ToggleFrame:Unlock()
                end

                if ag.Locked then
                    ag:Lock()
                end

                local ai = ag.Value

                local aj, ak
                if ag.Type == 'Toggle' then
                    aj, ak = ab(ai, ag.Icon, ag.IconSize, ag.ToggleFrame.UIElements.Main, ag.Callback, af)
                elseif ag.Type == 'Checkbox' then
                    aj, ak = ac(ai, ag.Icon, ag.IconSize, ag.ToggleFrame.UIElements.Main, ag.Callback, af)
                else
                    error('Unknown Toggle Type: ' .. tostring(ag.Type))
                end

                aj.AnchorPoint = Vector2.new(1, 0.5)
                aj.Position = UDim2.new(1, 0, 0.5, 0)

                function ag.Set(al, am, an, ao)
                    if ah then
                        ak:Set(am, an, ao or false)
                        ai = am
                        ag.Value = am
                    end
                end

                ag:Set(ai, false, false)

                aa.AddSignal(ag.ToggleFrame.UIElements.Main.MouseButton1Click, function()
                    ag:Set(not ag.Value, nil, false)
                end)

                return ag.__type, ag
            end

            return ad
        end
        function WindUIModules.ToggleElement(): typeof(buildModule())
            local aa = WindUIModules.cache.ToggleElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ToggleElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ab = aa(game:GetService('UserInputService'))

            local ac = WindUIModules.LocalizationModule()
            local ad = ac.New

            local ae = WindUIModules.ToggleUtilities().New
            local af = WindUIModules.ToggleElementHelper().New
            local ag = WindUIModules.PanelModule().New

            local ah = {}

            function ah.New(ai, aj)
                local function NormalizeKeyCode(ak)
                    if typeof(ak) == 'EnumItem' then
                        return ak.Name
                    elseif type(ak) == 'string' then
                        return ak
                    else
                        return 'F'
                    end
                end

                local ak = {
                    __type = 'ToggleKeybind',
                    Title = aj.Title or 'Toggle Keybind',
                    Desc = aj.Desc or nil,
                    Locked = aj.Locked or false,
                    LockedTitle = aj.LockedTitle,
                    Value = aj.Value,
                    Icon = aj.Icon or nil,
                    IconSize = aj.IconSize or 23,
                    Type = aj.Type or 'Toggle',
                    Callback = aj.Callback or function() end,
                    Keybind = NormalizeKeyCode(aj.Keybind or aj.Bind or aj.Key) or 'F',
                    CanChange = aj.CanChange ~= false,
                    Picking = false,
                    UIElements = {},
                }

                local al = true
                local am = false

                if ak.Value == nil then
                    ak.Value = false
                end

                local an = 40.8

                ak.ToggleKeybindFrame = WindUIModules.ElementFrameModule()({
                    Title = ak.Title,
                    Desc = ak.Desc,
                    Window = aj.Window,
                    Parent = aj.Parent,
                    TextOffset = an + 85 + 8,
                    Hover = false,
                    Tab = aj.Tab,
                    Index = aj.Index,
                    ElementTable = ak,
                    ParentConfig = aj,
                })

                local ao = ak.Value

                local ap, aq
                if ak.Type == 'Toggle' then
                    ap, aq = ae(ao, ak.Icon, ak.IconSize, ak.ToggleKeybindFrame.UIElements.Main, ak.Callback, aj)
                elseif ak.Type == 'Checkbox' then
                    ap, aq = af(ao, ak.Icon, ak.IconSize, ak.ToggleKeybindFrame.UIElements.Main, ak.Callback, aj)
                else
                    error('Unknown Toggle Type: ' .. tostring(ak.Type))
                end

                ap.AnchorPoint = Vector2.new(1, 0.5)
                ap.Position = UDim2.new(1, 0, 0.5, 0)

                ak.UIElements.Keybind = ag(ak.Keybind, nil, ak.ToggleKeybindFrame.UIElements.Main, nil, 10)
                ak.UIElements.Keybind.Size =
                    UDim2.new(0, 24 + ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
                ak.UIElements.Keybind.AnchorPoint = Vector2.new(1, 0.5)
                ak.UIElements.Keybind.Position = UDim2.new(1, -an - 8, 0.5, 0)

                ad('UIScale', {
                    Parent = ak.UIElements.Keybind,
                    Scale = 0.85,
                })

                ac.AddSignal(
                    ak.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal('TextBounds'),
                    function()
                        ak.UIElements.Keybind.Size =
                            UDim2.new(0, 24 + ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
                    end
                )

                local function StartPicking()
                    if not al or not ak.CanChange then
                        return
                    end

                    ak.Picking = true
                    ak.UIElements.Keybind.Frame.Frame.TextLabel.Text = '...'

                    task.wait(0.2)

                    local ar
                    ar = ab.InputBegan:Connect(function(as)
                        local at

                        if as.UserInputType == Enum.UserInputType.Keyboard then
                            at = as.KeyCode.Name
                        elseif as.UserInputType == Enum.UserInputType.MouseButton1 then
                            at = 'MouseLeft'
                        elseif as.UserInputType == Enum.UserInputType.MouseButton2 then
                            at = 'MouseRight'
                        end

                        if not at then
                            return
                        end

                        local au
                        au = ab.InputEnded:Connect(function(av)
                            if
                                av.KeyCode.Name == at
                                or (at == 'MouseLeft' and av.UserInputType == Enum.UserInputType.MouseButton1)
                                or (at == 'MouseRight' and av.UserInputType == Enum.UserInputType.MouseButton2)
                            then
                                ak.Picking = false
                                ak.UIElements.Keybind.Frame.Frame.TextLabel.Text = at
                                ak:SetKeybind(at)

                                ar:Disconnect()
                                au:Disconnect()
                            end
                        end)
                    end)
                end

                function ak.Lock(ar)
                    ak.Locked = true
                    al = false
                    return ak.ToggleKeybindFrame:Lock(ak.LockedTitle)
                end

                function ak.Unlock(ar)
                    ak.Locked = false
                    al = true
                    return ak.ToggleKeybindFrame:Unlock()
                end

                function ak.Set(ar, as, at, au)
                    if al then
                        aq:Set(as, at, au or false)
                        ao = as
                        ak.Value = as
                    end
                end

                function ak.SetKeybind(ar, as)
                    local at = NormalizeKeyCode(as)
                    ak.Keybind = at
                    ak.UIElements.Keybind.Frame.Frame.TextLabel.Text = at
                end

                ak:Set(ao, false, false)

                if ak.Locked then
                    ak:Lock()
                end

                ac.AddSignal(ak.UIElements.Keybind.MouseButton1Click, function()
                    if not al or not ak.CanChange then
                        return
                    end

                    am = true
                    task.defer(function()
                        am = false
                    end)

                    StartPicking()
                end)

                ac.AddSignal(ak.ToggleKeybindFrame.UIElements.Main.MouseButton1Click, function()
                    if am then
                        am = false
                        return
                    end

                    ak:Set(not ak.Value, nil, false)
                end)

                ac.AddSignal(ab.InputBegan, function(ar, as)
                    if as or ab:GetFocusedTextBox() then
                        return
                    end

                    if ak.Picking or not al then
                        return
                    end

                    if ar.UserInputType == Enum.UserInputType.Keyboard then
                        if ar.KeyCode.Name == ak.Keybind then
                            ak:Set(not ak.Value, true, false)
                        end
                    elseif
                        (ar.UserInputType == Enum.UserInputType.MouseButton1 and ak.Keybind == 'MouseLeft')
                        or (ar.UserInputType == Enum.UserInputType.MouseButton2 and ak.Keybind == 'MouseRight')
                    then
                        ak:Set(not ak.Value, true, false)
                    end
                end)

                return ak.__type, ak
            end

            return ah
        end
        function WindUIModules.ToggleKeybindElement(): typeof(buildModule())
            local aa = WindUIModules.cache.ToggleKeybindElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ToggleKeybindElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ab = aa(game:GetService('UserInputService'))
            local ac = aa(game:GetService('RunService'))

            local ad = WindUIModules.LocalizationModule()
            local ae = ad.New
            local af = ad.Tween

            local ag = {}

            local ah = false

            function ag.New(ai, aj)
                local ak = {
                    __type = 'Slider',
                    Title = aj.Title or nil,
                    Desc = aj.Desc or nil,
                    Locked = aj.Locked or nil,
                    LockedTitle = aj.LockedTitle,
                    Value = aj.Value or {},
                    Icons = aj.Icons or nil,
                    IsTooltip = aj.IsTooltip or false,
                    IsTextbox = aj.IsTextbox,
                    Step = aj.Step or 1,
                    Callback = aj.Callback or function() end,
                    UIElements = {},
                    IsFocusing = false,

                    Width = aj.Width or 130,
                    TextBoxWidth = 30,
                    ThumbSize = 13,
                    IconSize = 26,
                }
                if type(ak.Step) ~= 'number' or ak.Step == 0 then
                    ak.Step = 1
                end

                if type(ak.Icons) == 'table' and next(ak.Icons) == nil then
                    ak.Icons = {
                        From = 'sfsymbols:sunMinFill',
                        To = 'sfsymbols:sunMaxFill',
                    }
                end
                if ak.IsTextbox == nil and ak.Title == nil then
                    ak.IsTextbox = false
                else
                    ak.IsTextbox = ak.IsTextbox ~= false
                end

                local al
                local am
                local an
                local ao = ak.Value.Default or ak.Value.Min or 0

                local function GetMinMax()
                    local ap = ak.Value.Min or 0
                    local aq = ak.Value.Max or 100

                    if aq <= ap then
                        aq = ap + math.abs(ak.Step)
                    end

                    return ap, aq
                end

                local function GetDelta(ap)
                    local aq, ar = GetMinMax()
                    return math.clamp((ap - aq) / (ar - aq), 0, 1)
                end

                local ap = ao
                local aq = GetDelta(ao)

                local ar = true
                local as = ak.Step % 1 ~= 0

                local function FormatValue(at)
                    if as then
                        return tonumber(string.format('%.2f', at))
                    end
                    return math.floor(at + 0.5)
                end

                local function CalculateValue(at)
                    if as then
                        return math.floor(at / ak.Step + 0.5) * ak.Step
                    else
                        return math.floor(at / ak.Step + 0.5) * ak.Step
                    end
                end

                local at, au
                local av = 32
                if ak.Icons then
                    if ak.Icons.From then
                        at = ad.Image(
                            ak.Icons.From,
                            ak.Icons.From,
                            0,
                            aj.Window.Folder,
                            'SliderIconFrom',
                            true,
                            true,
                            'SliderIconFrom'
                        )
                        at.Size = UDim2.new(0, ak.IconSize, 0, ak.IconSize)
                        av = av + ak.IconSize - 2
                    end
                    if ak.Icons.To then
                        au = ad.Image(
                            ak.Icons.To,
                            ak.Icons.To,
                            0,
                            aj.Window.Folder,
                            'SliderIconTo',
                            true,
                            true,
                            'SliderIconTo'
                        )
                        au.Size = UDim2.new(0, ak.IconSize, 0, ak.IconSize)
                        av = av + ak.IconSize - 2
                    end
                end
                ak.SliderFrame = WindUIModules.ElementFrameModule()({
                    Title = ak.Title,
                    Desc = ak.Desc,
                    Parent = aj.Parent,
                    TextOffset = ak.Width,
                    Hover = false,
                    Tab = aj.Tab,
                    Index = aj.Index,
                    Window = aj.Window,
                    ElementTable = ak,
                    ParentConfig = aj,
                })

                ak.UIElements.SliderIcon = ad.NewRoundFrame(99, 'Squircle', {
                    ImageTransparency = 0.95,
                    Size = UDim2.new(1, not ak.IsTextbox and -av or (-ak.TextBoxWidth - 8), 0, 4),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Name = 'Frame',
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                }, {
                    ad.NewRoundFrame(99, 'Squircle', {
                        Name = 'Frame',
                        Size = UDim2.new(aq, 0, 1, 0),
                        ImageTransparency = 0.1,
                        ThemeTag = {
                            ImageColor3 = 'Slider',
                        },
                    }, {
                        ad.NewRoundFrame(99, 'Squircle', {
                            Size = UDim2.new(0, (ak.ThumbSize + 2), 0, (ak.ThumbSize + 2)),
                            Position = UDim2.new(1, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            ThemeTag = {
                                ImageColor3 = 'SliderThumb',
                            },
                            Name = 'Thumb',
                        }, {
                            ad.NewRoundFrame(99, 'Glass-1', {
                                Size = UDim2.new(1, 0, 1, 0),
                                ImageColor3 = Color3.new(1, 1, 1),
                                Name = 'Highlight',
                                ImageTransparency = 0.6,
                            }, {}),
                        }),
                    }),
                })

                ak.UIElements.SliderContainer = ae('Frame', {
                    Size = UDim2.new(ak.Title == nil and 1 or 0, ak.Title == nil and 0 or ak.Width, 0, 0),
                    AutomaticSize = 'Y',
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Parent = ak.SliderFrame.UIElements.Main,
                }, {
                    ae('UIListLayout', {
                        Padding = UDim.new(0, ak.Title ~= nil and 8 or 12),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = ak.Icons
                                and (ak.Icons.From and (ak.Icons.To and 'Center' or 'Left') or ak.Icons.To and 'Right')
                            or 'Center',
                    }),
                    at,
                    ak.UIElements.SliderIcon,
                    au,
                    ae('TextBox', {
                        Size = UDim2.new(0, ak.TextBoxWidth, 0, 0),
                        TextXAlignment = 'Left',
                        Text = FormatValue(ao),
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        TextTransparency = 0.4,
                        AutomaticSize = 'Y',
                        TextSize = 15,
                        FontFace = Font.new(ad.Font, Enum.FontWeight.Medium),
                        BackgroundTransparency = 1,
                        LayoutOrder = -1,
                        Visible = ak.IsTextbox,
                    }),
                })

                local aw
                if ak.IsTooltip then
                    aw = WindUIModules.ColorPickerUtilities().New(ao, ak.UIElements.SliderIcon.Frame.Thumb, true, 'Secondary', 'Small', false)
                    aw.Container.AnchorPoint = Vector2.new(0.5, 1)
                    aw.Container.Position = UDim2.new(0.5, 0, 0, -8)
                end

                function ak.Lock(ax)
                    ak.Locked = true
                    ar = false
                    return ak.SliderFrame:Lock(ak.LockedTitle)
                end
                function ak.Unlock(ax)
                    ak.Locked = false
                    ar = true
                    return ak.SliderFrame:Unlock()
                end

                if ak.Locked then
                    ak:Lock()
                end

                local ax = aj.Tab.UIElements.ContainerFrame

                function ak.Set(ay, az, aA)
                    if az == nil then
                        return
                    end
                    if ar then
                        if
                            not ak.IsFocusing
                            and not ah
                            and (
                                not aA
                                or (
                                    aA.UserInputType == Enum.UserInputType.MouseButton1
                                    or aA.UserInputType == Enum.UserInputType.Touch
                                )
                            )
                        then
                            if aA then
                                al = (aA.UserInputType == Enum.UserInputType.Touch)
                                ax.ScrollingEnabled = false
                                ah = true

                                local aB = al and aA.Position.X or ab:GetMouseLocation().X
                                local b = math.clamp(
                                    (aB - ak.UIElements.SliderIcon.AbsolutePosition.X)
                                        / ak.UIElements.SliderIcon.AbsoluteSize.X,
                                    0,
                                    1
                                )
                                local d, f = GetMinMax()
                                az = CalculateValue(d + b * (f - d))
                                az = math.clamp(az, d, f)

                                if az ~= ap then
                                    af(ak.UIElements.SliderIcon.Frame, 0.05, { Size = UDim2.new(b, 0, 1, 0) }):Play()
                                    ak.UIElements.SliderContainer.TextBox.Text = FormatValue(az)
                                    if aw then
                                        aw.TitleFrame.Text = FormatValue(az)
                                    end
                                    ak.Value.Default = FormatValue(az)
                                    ap = az
                                    local fv = FormatValue(az)
                                    if fv ~= nil then
                                        ad.SafeCallback(ak.Callback, fv)
                                    end
                                end

                                am = ac.RenderStepped:Connect(function()
                                    local g = al and aA.Position.X or ab:GetMouseLocation().X
                                    local h = math.clamp(
                                        (g - ak.UIElements.SliderIcon.AbsolutePosition.X)
                                            / ak.UIElements.SliderIcon.AbsoluteSize.X,
                                        0,
                                        1
                                    )
                                    local j, l = GetMinMax()
                                    az = CalculateValue(j + h * (l - j))
                                    az = math.clamp(az, j, l)

                                    if az ~= ap then
                                        af(ak.UIElements.SliderIcon.Frame, 0.05, { Size = UDim2.new(h, 0, 1, 0) }):Play()
                                        ak.UIElements.SliderContainer.TextBox.Text = FormatValue(az)
                                        if aw then
                                            aw.TitleFrame.Text = FormatValue(az)
                                        end
                                        ak.Value.Default = FormatValue(az)
                                        ap = az
                                        local fv = FormatValue(az)
                                        if fv ~= nil then
                                            ad.SafeCallback(ak.Callback, fv)
                                        end
                                    end
                                end)

                                an = ab.InputEnded:Connect(function(g)
                                    local h = (
                                        aA.UserInputType == Enum.UserInputType.MouseButton1
                                        and g.UserInputType == Enum.UserInputType.MouseButton1
                                    )
                                        or (
                                            aA.UserInputType == Enum.UserInputType.Touch
                                            and g.UserInputType == Enum.UserInputType.Touch
                                        )

                                    if h then
                                        am:Disconnect()
                                        an:Disconnect()
                                        ah = false
                                        ax.ScrollingEnabled = true

                                        if aw then
                                            aw:Close(false)
                                        end
                                    end
                                end)
                            else
                                local aB, b = GetMinMax()
                                az = math.clamp(az, aB, b)

                                local d = GetDelta(az)
                                az = CalculateValue(aB + d * (b - aB))
                                az = math.clamp(az, aB, b)

                                if az ~= ap then
                                    af(ak.UIElements.SliderIcon.Frame, 0.05, { Size = UDim2.new(d, 0, 1, 0) }):Play()
                                    ak.UIElements.SliderContainer.TextBox.Text = FormatValue(az)
                                    if aw then
                                        aw.TitleFrame.Text = FormatValue(az)
                                    end
                                    ak.Value.Default = FormatValue(az)
                                    ap = az
                                    local fv = FormatValue(az)
                                    if fv ~= nil then
                                        ad.SafeCallback(ak.Callback, fv)
                                    end
                                end
                            end
                        end
                    end
                end

                function ak.SetMax(ay, az)
                    ak.Value.Max = az

                    local aA = tonumber(ak.Value.Default) or ap
                    if aA > az then
                        ak:Set(az)
                    else
                        local aB = GetDelta(aA)
                        af(ak.UIElements.SliderIcon.Frame, 0.1, { Size = UDim2.new(aB, 0, 1, 0) }):Play()
                    end
                end

                function ak.SetMin(ay, az)
                    ak.Value.Min = az

                    local aA = tonumber(ak.Value.Default) or ap
                    if aA < az then
                        ak:Set(az)
                    else
                        local aB = GetDelta(aA)
                        af(ak.UIElements.SliderIcon.Frame, 0.1, { Size = UDim2.new(aB, 0, 1, 0) }):Play()
                    end
                end

                ad.AddSignal(ak.UIElements.SliderContainer.TextBox.FocusLost, function(ay)
                    if ay then
                        local az = tonumber(ak.UIElements.SliderContainer.TextBox.Text)
                        if az then
                            ak:Set(az)
                        else
                            ak.UIElements.SliderContainer.TextBox.Text = FormatValue(ap)
                            if aw then
                                aw.TitleFrame.Text = FormatValue(ap)
                            end
                        end
                    end
                end)

                ad.AddSignal(ak.UIElements.SliderContainer.InputBegan, function(ay)
                    if ak.Locked or ah then
                        return
                    end

                    ak:Set(ao, ay)

                    if
                        ay.UserInputType == Enum.UserInputType.MouseButton1
                        or ay.UserInputType == Enum.UserInputType.Touch
                    then
                        if aw then
                            aw:Open()
                        end
                    end
                end)

                return ak.__type, ak
            end

            return ag
        end
        function WindUIModules.SliderElement(): typeof(buildModule())
            local aa = WindUIModules.cache.SliderElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.SliderElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ab = aa(game:GetService('UserInputService'))
            local ac = aa(game:GetService('RunService'))

            local ad = WindUIModules.LocalizationModule()
            local ae = ad.New
            local af = ad.Tween

            local ag = {}

            local function ResolveRange(ah)
                local ai = 0
                local aj = 100
                local ak = 0

                if typeof(ah) == 'table' then
                    ai = tonumber(ah.Min) or ai
                    aj = tonumber(ah.Max) or aj
                    ak = tonumber(ah.Default) or ak
                elseif typeof(ah) == 'number' then
                    ak = ah
                end

                if aj <= ai then
                    aj = ai + 1
                end

                ak = math.clamp(ak, ai, aj)
                return ai, aj, ak
            end

            local function ClampPrecision(ah)
                local ai = tonumber(ah)
                if not ai then
                    return 0
                end

                return math.clamp(math.floor(ai), 0, 5)
            end

            local function RoundWithPrecision(ah, ai)
                if ai <= 0 then
                    return math.floor(ah + 0.5)
                end

                local aj = 10 ^ ai
                return math.floor((ah * aj) + 0.5) / aj
            end

            local function IsPressInput(ah)
                return ah.UserInputType == Enum.UserInputType.MouseButton1
                    or ah.UserInputType == Enum.UserInputType.Touch
            end

            function ag.New(ah, ai)
                local aj, ak, al = ResolveRange(ai.Value)
                local am = math.abs(tonumber(ai.Step) or 1)
                if am == 0 then
                    am = 1
                end

                local an = ClampPrecision(ai.Precision)
                if ai.Precision == nil and am % 1 ~= 0 then
                    an = 2
                end

                local ao = {
                    __type = 'Stepper',
                    Title = ai.Title or 'Stepper',
                    Desc = ai.Desc,
                    Locked = ai.Locked or false,
                    LockedTitle = ai.LockedTitle,
                    Min = aj,
                    Max = ak,
                    Step = am,
                    Value = al,
                    Precision = an,
                    Prefix = tostring(ai.Prefix or ''),
                    Suffix = tostring(ai.Suffix or ''),
                    Format = ai.Format,
                    HoldDelay = tonumber(ai.HoldDelay) or 0.28,
                    HoldRate = tonumber(ai.HoldRate) or 0.07,
                    Callback = ai.Callback or function() end,
                    UIElements = {},
                }

                local ap = true
                local aq = 0
                local ar

                local as = typeof(ai.Width) == 'number' and math.max(math.floor(ai.Width), 168) or 182
                local at = typeof(ai.ButtonSize) == 'number' and math.max(math.floor(ai.ButtonSize), 28) or 34
                local au = math.max(ai.Window.ElementConfig.UICorner - 4, 8)

                ao.StepperFrame = WindUIModules.ElementFrameModule()({
                    Title = ao.Title,
                    Desc = ao.Desc,
                    Parent = ai.Parent,
                    TextOffset = as,
                    Hover = false,
                    Tab = ai.Tab,
                    Index = ai.Index,
                    Window = ai.Window,
                    ElementTable = ao,
                    ParentConfig = ai,
                })

                local av = ae('Frame', {
                    Name = 'Controls',
                    Size = UDim2.new(0, as, 0, at),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Parent = ao.StepperFrame.UIElements.Main,
                }, {
                    ae('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                        Padding = UDim.new(0, 6),
                    }),
                })

                local function CreateActionButton(aw)
                    local ax = ad.NewRoundFrame(au, 'Squircle', {
                        Size = UDim2.new(0, at, 0, at),
                        ImageTransparency = 0.93,
                        ThemeTag = {
                            ImageColor3 = 'Text',
                        },
                        Parent = av,
                        Active = true,
                    }, nil, true)

                    local ay = ad.Image(aw, ao.Title .. ':' .. aw, 0, ai.Window.Folder, 'Stepper', true, true, 'Icon')
                    ay.Size = UDim2.new(0, 16, 0, 16)
                    ay.AnchorPoint = Vector2.new(0.5, 0.5)
                    ay.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ay.Parent = ax

                    return ax
                end

                local aw = CreateActionButton('minus')
                local ax = CreateActionButton('plus')

                local ay = ad.NewRoundFrame(au, 'Squircle', {
                    Name = 'ValueFrame',
                    Size = UDim2.new(1, -((at * 2) + 12), 1, 0),
                    ImageTransparency = 0.95,
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    Parent = av,
                }, {
                    ae('TextLabel', {
                        Name = 'ValueLabel',
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        TextXAlignment = 'Center',
                        TextYAlignment = 'Center',
                        FontFace = Font.new(ad.Font, Enum.FontWeight.Medium),
                        TextSize = 15,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                    }),
                })

                local az = ay:FindFirstChild('ValueLabel')

                ao.UIElements.Controls = av
                ao.UIElements.ValueFrame = ay
                ao.UIElements.ValueLabel = az
                ao.UIElements.IncrementButton = ax
                ao.UIElements.DecrementButton = aw

                local function SnapValue(aA)
                    local aB = ao.Max - ao.Min
                    if aB <= 0 then
                        return ao.Min
                    end

                    local b = ao.Min + (math.floor(((aA - ao.Min) / ao.Step) + 0.5) * ao.Step)
                    b = math.clamp(b, ao.Min, ao.Max)
                    return RoundWithPrecision(b, ao.Precision)
                end

                local function BuildValueText()
                    if typeof(ao.Format) == 'function' then
                        local aA, aB = pcall(ao.Format, ao.Value, ao.Min, ao.Max, ao)
                        if aA and aB ~= nil then
                            return tostring(aB)
                        end
                    end

                    local aA
                    if ao.Precision <= 0 then
                        aA = tostring(math.floor(ao.Value + 0.5))
                    else
                        aA = string.format('%.' .. tostring(ao.Precision) .. 'f', ao.Value)
                    end

                    return ao.Prefix .. aA .. ao.Suffix
                end

                local function UpdateValueLabel()
                    if az then
                        az.Text = BuildValueText()
                    end
                end

                local function FireCallback()
                    if ap then
                        ad.SafeCallback(ao.Callback, ao.Value, ao)
                    end
                end

                local function StopHold()
                    aq = 0
                    if ar then
                        ar:Disconnect()
                        ar = nil
                    end
                end

                local function StartHold(aA)
                    StopHold()
                    aq = aA

                    local aB = 0
                    local b = false

                    ar = ad.AddSignal(ac.Heartbeat, function(d)
                        if aq ~= aA then
                            StopHold()
                            return
                        end

                        aB = aB + d

                        if not b then
                            if aB >= ao.HoldDelay then
                                b = true
                                aB = 0
                            end
                            return
                        end

                        if aB >= ao.HoldRate then
                            aB = aB - ao.HoldRate
                            ao:Add(ao.Step * aA, true)
                        end
                    end)
                end

                local function SetButtonState(aA, aB)
                    if ao.Locked then
                        aA.Active = false
                        aA.ImageTransparency = 0.97
                        return
                    end

                    aA.Active = true
                    local b = aB and 0.88 or 0.93
                    af(aA, 0.1, {
                        ImageTransparency = b,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end

                function ao.GetValue(aA)
                    return ao.Value
                end

                function ao.Set(aA, aB, b)
                    local d = tonumber(aB)
                    if not d then
                        return ao
                    end

                    local f = SnapValue(d)
                    local g = f ~= ao.Value

                    ao.Value = f
                    UpdateValueLabel()

                    if g and b ~= false then
                        FireCallback()
                    end

                    return ao
                end

                function ao.Add(aA, aB, b)
                    local d = tonumber(aB) or 0
                    return ao:Set(ao.Value + d, b)
                end
                ao.Increment = ao.Add

                function ao.Decrement(aA, aB, b)
                    local d = tonumber(aB) or ao.Step
                    return ao:Set(ao.Value - d, b)
                end

                function ao.SetRange(aA, aB, b, d)
                    local f = tonumber(aB)
                    local g = tonumber(b)
                    if not f or not g then
                        return ao
                    end

                    if g <= f then
                        g = f + ao.Step
                    end

                    local h = ao.Max - ao.Min
                    local j = h > 0 and ((ao.Value - ao.Min) / h) or 0

                    ao.Min = f
                    ao.Max = g

                    if d == true then
                        local l = f + ((g - f) * j)
                        ao:Set(l, false)
                    else
                        ao:Set(ao.Value, false)
                    end

                    return ao
                end

                function ao.SetStep(aA, aB)
                    local b = math.abs(tonumber(aB) or 0)
                    if b == 0 then
                        return ao
                    end

                    ao.Step = b
                    ao:Set(ao.Value, false)
                    return ao
                end

                function ao.SetPrecision(aA, aB)
                    ao.Precision = ClampPrecision(aB)
                    ao:Set(ao.Value, false)
                    return ao
                end

                function ao.SetPrefix(aA, aB)
                    ao.Prefix = tostring(aB or '')
                    UpdateValueLabel()
                    return ao
                end

                function ao.SetSuffix(aA, aB)
                    ao.Suffix = tostring(aB or '')
                    UpdateValueLabel()
                    return ao
                end

                function ao.SetFormat(aA, aB)
                    ao.Format = aB
                    UpdateValueLabel()
                    return ao
                end

                function ao.Lock(aA)
                    ao.Locked = true
                    ap = false
                    StopHold()

                    SetButtonState(aw, false)
                    SetButtonState(ax, false)

                    return ao.StepperFrame:Lock(ao.LockedTitle)
                end

                function ao.Unlock(aA)
                    ao.Locked = false
                    ap = true

                    SetButtonState(aw, false)
                    SetButtonState(ax, false)

                    return ao.StepperFrame:Unlock()
                end

                function ao.Destroy(aA)
                    StopHold()
                    if ao.StepperFrame and ao.StepperFrame.Destroy then
                        ao.StepperFrame:Destroy()
                        ao.StepperFrame = nil
                    end
                end

                ad.AddSignal(aw.MouseButton1Click, function()
                    if not ao.Locked then
                        ao:Decrement(ao.Step, true)
                    end
                end)

                ad.AddSignal(ax.MouseButton1Click, function()
                    if not ao.Locked then
                        ao:Add(ao.Step, true)
                    end
                end)

                ad.AddSignal(aw.InputBegan, function(aA)
                    if ao.Locked or not IsPressInput(aA) then
                        return
                    end
                    StartHold(-1)
                end)

                ad.AddSignal(ax.InputBegan, function(aA)
                    if ao.Locked or not IsPressInput(aA) then
                        return
                    end
                    StartHold(1)
                end)

                ad.AddSignal(ab.InputEnded, function(aA)
                    if IsPressInput(aA) then
                        StopHold()
                    end
                end)

                ad.AddSignal(aw.MouseEnter, function()
                    SetButtonState(aw, true)
                end)
                ad.AddSignal(aw.MouseLeave, function()
                    SetButtonState(aw, false)
                end)

                ad.AddSignal(ax.MouseEnter, function()
                    SetButtonState(ax, true)
                end)
                ad.AddSignal(ax.MouseLeave, function()
                    SetButtonState(ax, false)
                end)

                ao:Set(ao.Value, false)

                if ao.Locked then
                    ao:Lock()
                else
                    ao:Unlock()
                end

                return ao.__type, ao
            end

            return ag
        end
        function WindUIModules.StepperElement(): typeof(buildModule())
            local aa = WindUIModules.cache.StepperElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.StepperElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ab = aa(game:GetService('UserInputService'))

            local ac = WindUIModules.LocalizationModule()
            local ad = ac.New
            local ae = ac.Tween

            local af = {
                UICorner = 6,
                UIPadding = 8,
            }

            local ag = WindUIModules.PanelModule().New

            function af.New(ah, ai)
                local function NormalizeKeyCode(aj)
                    if typeof(aj) == 'EnumItem' then
                        return aj.Name
                    elseif type(aj) == 'string' then
                        return aj
                    else
                        return 'F'
                    end
                end

                local aj = {
                    __type = 'Keybind',
                    Title = ai.Title or 'Keybind',
                    Desc = ai.Desc or nil,
                    Locked = ai.Locked or false,
                    LockedTitle = ai.LockedTitle,
                    Value = NormalizeKeyCode(ai.Value) or 'F',
                    Callback = ai.Callback or function() end,
                    CanChange = ai.CanChange or true,
                    Picking = false,
                    UIElements = {},
                }

                local ak = true

                aj.KeybindFrame = WindUIModules.ElementFrameModule()({
                    Title = aj.Title,
                    Desc = aj.Desc,
                    Parent = ai.Parent,
                    TextOffset = 85,
                    Hover = aj.CanChange,
                    Tab = ai.Tab,
                    Index = ai.Index,
                    Window = ai.Window,
                    ElementTable = aj,
                    ParentConfig = ai,
                })

                aj.UIElements.Keybind = ag(aj.Value, nil, aj.KeybindFrame.UIElements.Main, nil, 10)

                aj.UIElements.Keybind.Size =
                    UDim2.new(0, 24 + aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
                aj.UIElements.Keybind.AnchorPoint = Vector2.new(1, 0.5)
                aj.UIElements.Keybind.Position = UDim2.new(1, 0, 0.5, 0)

                ad('UIScale', {
                    Parent = aj.UIElements.Keybind,
                    Scale = 0.85,
                })

                ac.AddSignal(
                    aj.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal('TextBounds'),
                    function()
                        aj.UIElements.Keybind.Size =
                            UDim2.new(0, 24 + aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
                    end
                )

                function aj.Lock(al)
                    aj.Locked = true
                    ak = false
                    return aj.KeybindFrame:Lock(aj.LockedTitle)
                end
                function aj.Unlock(al)
                    aj.Locked = false
                    ak = true
                    return aj.KeybindFrame:Unlock()
                end

                function aj.Set(al, am)
                    local an = NormalizeKeyCode(am)
                    aj.Value = an
                    aj.UIElements.Keybind.Frame.Frame.TextLabel.Text = an
                end

                if aj.Locked then
                    aj:Lock()
                end

                ac.AddSignal(aj.KeybindFrame.UIElements.Main.MouseButton1Click, function()
                    if ak then
                        if aj.CanChange then
                            aj.Picking = true
                            aj.UIElements.Keybind.Frame.Frame.TextLabel.Text = '...'

                            task.wait(0.2)

                            local al
                            al = ab.InputBegan:Connect(function(am)
                                local an

                                if am.UserInputType == Enum.UserInputType.Keyboard then
                                    an = am.KeyCode.Name
                                elseif am.UserInputType == Enum.UserInputType.MouseButton1 then
                                    an = 'MouseLeft'
                                elseif am.UserInputType == Enum.UserInputType.MouseButton2 then
                                    an = 'MouseRight'
                                end

                                local ao
                                ao = ab.InputEnded:Connect(function(ap)
                                    if
                                        ap.KeyCode.Name == an
                                        or an == 'MouseLeft' and ap.UserInputType == Enum.UserInputType.MouseButton1
                                        or an == 'MouseRight' and ap.UserInputType == Enum.UserInputType.MouseButton2
                                    then
                                        aj.Picking = false

                                        aj.UIElements.Keybind.Frame.Frame.TextLabel.Text = an
                                        aj:Set(an)

                                        al:Disconnect()
                                        ao:Disconnect()
                                    end
                                end)
                            end)
                        end
                    end
                end)

                ac.AddSignal(ab.InputBegan, function(al, am)
                    if ab:GetFocusedTextBox() then
                        return
                    end

                    if not ak then
                        return
                    end

                    if al.UserInputType == Enum.UserInputType.Keyboard then
                        if al.KeyCode.Name == aj.Value then
                            ac.SafeCallback(aj.Callback, al.KeyCode.Name)
                        end
                    elseif al.UserInputType == Enum.UserInputType.MouseButton1 and aj.Value == 'MouseLeft' then
                        ac.SafeCallback(aj.Callback, 'MouseLeft')
                    elseif al.UserInputType == Enum.UserInputType.MouseButton2 and aj.Value == 'MouseRight' then
                        ac.SafeCallback(aj.Callback, 'MouseRight')
                    end
                end)

                return aj.__type, aj
            end

            return af
        end
        function WindUIModules.KeybindElement(): typeof(buildModule())
            local aa = WindUIModules.cache.KeybindElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.KeybindElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ab = aa.New
            local ac = aa.Tween

            local ad = {
                UICorner = 8,
                UIPadding = 8,
            }
            local ae = WindUIModules.NotificationModule()
.New
            local af = WindUIModules.PopupModule().New

            function ad.New(ag, ah)
                local ai = {
                    __type = 'Input',
                    Title = ah.Title or 'Input',
                    Desc = ah.Desc or nil,
                    Type = ah.Type or 'Input',
                    Locked = ah.Locked or false,
                    LockedTitle = ah.LockedTitle,
                    InputIcon = ah.InputIcon or false,
                    Placeholder = ah.Placeholder or 'Enter Text...',
                    Value = ah.Value or '',
                    Callback = ah.Callback or function() end,
                    ClearTextOnFocus = ah.ClearTextOnFocus or false,
                    UIElements = {},

                    Width = 150,
                }

                local aj = true

                ai.InputFrame = WindUIModules.ElementFrameModule()({
                    Title = ai.Title,
                    Desc = ai.Desc,
                    Parent = ah.Parent,
                    TextOffset = ai.Width,
                    Hover = false,
                    Tab = ah.Tab,
                    Index = ah.Index,
                    Window = ah.Window,
                    ElementTable = ai,
                    ParentConfig = ah,
                })

                local ak = af(
                    ai.Placeholder,
                    ai.InputIcon,
                    ai.Type == 'Textarea' and ai.InputFrame.UIElements.Container or ai.InputFrame.UIElements.Main,
                    ai.Type,
                    function(ak)
                        ai:Set(ak, true)
                    end,
                    nil,
                    10,
                    ai.ClearTextOnFocus
                )

                if ai.Type == 'Input' then
                    ak.Size = UDim2.new(0, ai.Width, 0, 36)
                    ak.Position = UDim2.new(1, 0, 0.5, 0)
                    ak.AnchorPoint = Vector2.new(1, 0.5)
                else
                    ak.Size = UDim2.new(1, 0, 0, 148)
                end

                ab('UIScale', {
                    Parent = ak,
                    Scale = 1,
                })

                function ai.Lock(al)
                    ai.Locked = true
                    aj = false
                    return ai.InputFrame:Lock(ai.LockedTitle)
                end
                function ai.Unlock(al)
                    ai.Locked = false
                    aj = true
                    return ai.InputFrame:Unlock()
                end

                function ai.Set(al, am, an)
                    if aj then
                        ai.Value = am
                        aa.SafeCallback(ai.Callback, am)

                        if not an then
                            ak.Frame.Frame.TextBox.Text = am
                        end
                    end
                end

                function ai.SetPlaceholder(al, am)
                    ak.Frame.Frame.TextBox.PlaceholderText = am
                    ai.Placeholder = am
                end

                ai:Set(ai.Value)

                if ai.Locked then
                    ai:Lock()
                end

                return ai.__type, ai
            end

            return ad
        end
        function WindUIModules.InputElement(): typeof(buildModule())
            local aa = WindUIModules.cache.InputElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.InputElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ab = (cloneref or clonereference or function(ab)
                return ab
            end)

            local ad = ab(game:GetService('UserInputService'))
            local ae = ab(game:GetService('Players')).LocalPlayer:GetMouse()
            local af = ab(game:GetService('Workspace')).CurrentCamera

            local ag = workspace.CurrentCamera

            local ah = WindUIModules.PopupModule().New

            local ai = WindUIModules.LocalizationModule()
            local aj = ai.New
            local ak = ai.Tween

            function aa.New(al, am, an, ao, ap)
                local aq = {}

                if not am.Callback then
                    ap = 'Menu'
                end

                am.UIElements.UIListLayout = aj('UIListLayout', {
                    Padding = UDim.new(0, an.MenuPadding / 1.5),
                    FillDirection = 'Vertical',
                    HorizontalAlignment = 'Center',
                })

                am.UIElements.Menu = ai.NewRoundFrame(an.MenuCorner, 'Squircle', {
                    ThemeTag = {
                        ImageColor3 = 'Background',
                    },
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                }, {
                    aj('UIPadding', {
                        PaddingTop = UDim.new(0, an.MenuPadding),
                        PaddingLeft = UDim.new(0, an.MenuPadding),
                        PaddingRight = UDim.new(0, an.MenuPadding),
                        PaddingBottom = UDim.new(0, an.MenuPadding),
                    }),
                    aj('UIListLayout', {
                        FillDirection = 'Vertical',
                        Padding = UDim.new(0, an.MenuPadding),
                    }),
                    aj('Frame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, am.SearchBarEnabled and -an.MenuPadding - an.SearchBarHeight),

                        ClipsDescendants = true,
                        LayoutOrder = 999,
                    }, {
                        aj('UICorner', {
                            CornerRadius = UDim.new(0, an.MenuCorner - an.MenuPadding),
                        }),
                        aj('ScrollingFrame', {
                            Size = UDim2.new(1, 0, 1, 0),
                            ScrollBarThickness = 0,
                            ScrollingDirection = 'Y',
                            AutomaticCanvasSize = 'Y',
                            CanvasSize = UDim2.new(0, 0, 0, 0),
                            BackgroundTransparency = 1,
                            ScrollBarImageTransparency = 1,
                        }, {
                            am.UIElements.UIListLayout,
                        }),
                    }),
                })

                am.UIElements.MenuCanvas = aj('Frame', {
                    Size = UDim2.new(0, am.MenuWidth, 0, 300),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(-10, 0, -10, 0),
                    Visible = false,
                    Active = false,

                    Parent = al.WindUI.DropdownGui,
                    AnchorPoint = Vector2.new(1, 0),
                }, {
                    am.UIElements.Menu,
                    aj('UISizeConstraint', {
                        MinSize = Vector2.new(170, 0),
                        MaxSize = Vector2.new(300, 400),
                    }),
                })

                local function RecalculateCanvasSize()
                    am.UIElements.Menu.Frame.ScrollingFrame.CanvasSize =
                        UDim2.fromOffset(0, am.UIElements.UIListLayout.AbsoluteContentSize.Y)
                end

                local function RecalculateListSize()
                    local ar = ag.ViewportSize.Y * 0.6

                    local as = am.UIElements.UIListLayout.AbsoluteContentSize.Y
                    local at = am.SearchBarEnabled and (an.SearchBarHeight + (an.MenuPadding * 3))
                        or (an.MenuPadding * 2)
                    local au = as + at

                    if au > ar then
                        am.UIElements.MenuCanvas.Size = UDim2.fromOffset(am.UIElements.MenuCanvas.AbsoluteSize.X, ar)
                    else
                        am.UIElements.MenuCanvas.Size = UDim2.fromOffset(am.UIElements.MenuCanvas.AbsoluteSize.X, au)
                    end
                end

                function UpdatePosition()
                    local ar = am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
                    local as = am.UIElements.MenuCanvas

                    local at = af.ViewportSize.Y - (ar.AbsolutePosition.Y + ar.AbsoluteSize.Y) - an.MenuPadding - 54
                    local au = as.AbsoluteSize.Y + an.MenuPadding

                    local av = -54
                    if at < au then
                        av = au - at - 54
                    end

                    as.Position = UDim2.new(
                        0,
                        ar.AbsolutePosition.X + ar.AbsoluteSize.X,
                        0,
                        ar.AbsolutePosition.Y + ar.AbsoluteSize.Y - av + (an.MenuPadding * 2)
                    )
                end

                local ar

                function aq.Display(as)
                    local at = am.Values
                    local au = ''

                    if am.Multi then
                        local av = {}
                        if typeof(am.Value) == 'table' then
                            for aw, ax in ipairs(am.Value) do
                                local ay = typeof(ax) == 'table' and ax.Title or ax
                                av[ay] = true
                            end
                        end

                        for aw, ax in ipairs(at) do
                            local ay = typeof(ax) == 'table' and ax.Title or ax
                            if av[ay] then
                                au = au .. ay .. ', '
                            end
                        end

                        if #au > 0 then
                            au = au:sub(1, #au - 2)
                        end
                    else
                        au = typeof(am.Value) == 'table' and am.Value.Title or am.Value or ''
                    end

                    if am.UIElements.Dropdown then
                        am.UIElements.Dropdown.Frame.Frame.TextLabel.Text = (au == '' and '--' or au)
                    end
                end

                local function Callback(as)
                    aq:Display()
                    if am.Callback then
                        task.spawn(function()
                            ai.SafeCallback(am.Callback, am.Value)
                        end)
                    else
                        task.spawn(function()
                            ai.SafeCallback(as)
                        end)
                    end
                end

                function aq.LockValues(as, at)
                    if not at then
                        return
                    end

                    for au, av in next, am.Tabs do
                        if av and av.UIElements and av.UIElements.TabItem then
                            local aw = av.Name
                            local ax = false

                            for ay, az in next, at do
                                if aw == az then
                                    ax = true
                                    break
                                end
                            end

                            if ax then
                                ak(av.UIElements.TabItem, 0.1, { ImageTransparency = 1 }):Play()
                                ak(av.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 1 }):Play()
                                ak(av.UIElements.TabItem.Frame.Title.TextLabel, 0.1, { TextTransparency = 0.6 }):Play()
                                if av.UIElements.TabIcon then
                                    ak(av.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0.6 }):Play()
                                end

                                av.UIElements.TabItem.Active = false
                                av.Locked = true
                            else
                                if av.Selected then
                                    ak(av.UIElements.TabItem, 0.1, { ImageTransparency = 0.95 }):Play()
                                    ak(av.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 0.75 }):Play()
                                    ak(av.UIElements.TabItem.Frame.Title.TextLabel, 0.1, { TextTransparency = 0 }):Play()
                                    if av.UIElements.TabIcon then
                                        ak(av.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0 }):Play()
                                    end
                                else
                                    ak(av.UIElements.TabItem, 0.1, { ImageTransparency = 1 }):Play()
                                    ak(av.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 1 }):Play()
                                    ak(
                                        av.UIElements.TabItem.Frame.Title.TextLabel,
                                        0.1,
                                        { TextTransparency = ap == 'Dropdown' and 0.4 or 0.05 }
                                    ):Play()
                                    if av.UIElements.TabIcon then
                                        ak(
                                            av.UIElements.TabIcon.ImageLabel,
                                            0.1,
                                            { ImageTransparency = ap == 'Dropdown' and 0.2 or 0 }
                                        ):Play()
                                    end
                                end

                                av.UIElements.TabItem.Active = true
                                av.Locked = false
                            end
                        end
                    end
                end

                function aq.Refresh(as, at, au)
                    at = typeof(at) == 'table' and at or {}

                    for av, aw in next, am.UIElements.Menu.Frame.ScrollingFrame:GetChildren() do
                        if not aw:IsA('UIListLayout') then
                            aw:Destroy()
                        end
                    end

                    am.Tabs = {}

                    if am.SearchBarEnabled then
                        if not ar then
                            ar = ah('Search...', 'search', am.UIElements.Menu, nil, function(av)
                                for aw, ax in next, am.Tabs do
                                    if string.find(string.lower(ax.Name), string.lower(av), 1, true) then
                                        ax.UIElements.TabItem.Visible = true
                                    else
                                        ax.UIElements.TabItem.Visible = false
                                    end
                                    RecalculateListSize()
                                    RecalculateCanvasSize()
                                end
                            end, true)
                            ar.Size = UDim2.new(1, 0, 0, an.SearchBarHeight)
                            ar.Position = UDim2.new(0, 0, 0, 0)
                            ar.Name = 'SearchBar'
                        end
                    end

                    for av, aw in next, at do
                        local ax = typeof(aw) == 'table' and aw.Title or aw
                        if ax ~= nil then
                            local ay = {
                                Name = ax,
                                Desc = typeof(aw) == 'table' and aw.Desc or nil,
                                Icon = typeof(aw) == 'table' and aw.Icon or nil,
                                IconSize = typeof(aw) == 'table' and aw.IconSize or nil,
                                Image = typeof(aw) == 'table' and aw.Image or nil,
                                ImageSize = typeof(aw) == 'table' and aw.ImageSize or nil,
                                Original = aw,
                                Selected = false,
                                Locked = typeof(aw) == 'table' and aw.Locked or false,
                                UIElements = {},
                            }
                            local az
                            local aA = an.TabIcon
                            if ay.Icon then
                                az = ai.Image(ay.Icon, ay.Icon, 0, al.Window.Folder, 'Dropdown', true)
                                aA = ay.IconSize or an.TabIcon
                                az.Size = UDim2.new(0, aA, 0, aA)
                                az.ImageLabel.ImageTransparency = ap == 'Dropdown' and 0.2 or 0
                                ay.UIElements.TabIcon = az
                            elseif ay.Image then
                                aA = ay.ImageSize or an.TabIcon
                                az = aj('Frame', {
                                    Size = UDim2.new(0, aA, 0, aA),
                                    BackgroundTransparency = 1,
                                }, {
                                    aj('ImageLabel', {
                                        Size = UDim2.new(1, 0, 1, 0),
                                        Name = 'ImageLabel',
                                        Image = ay.Image,
                                        ScaleType = 'Crop',
                                        BackgroundTransparency = 1,
                                        ImageTransparency = ap == 'Dropdown' and 0.2 or 0,
                                    }, {
                                        aj('UICorner', {
                                            CornerRadius = UDim.new(1, 0),
                                        }),
                                    }),
                                })
                                ay.UIElements.TabIcon = az
                            end
                            ay.UIElements.TabItem = ai.NewRoundFrame(an.MenuCorner - an.MenuPadding, 'Squircle', {
                                Size = UDim2.new(1, 0, 0, 36),
                                AutomaticSize = ay.Desc and 'Y',
                                ImageTransparency = 1,
                                Parent = am.UIElements.Menu.Frame.ScrollingFrame,
                                ImageColor3 = Color3.new(1, 1, 1),
                                Active = not ay.Locked,
                            }, {
                                ai.NewRoundFrame(an.MenuCorner - an.MenuPadding, 'Glass-1.4', {
                                    Size = UDim2.new(1, 0, 1, 0),
                                    ThemeTag = {
                                        ImageColor3 = 'DropdownTabBorder',
                                    },
                                    ImageTransparency = 1,
                                    Name = 'Highlight',
                                }, {}),
                                aj('Frame', {
                                    Size = UDim2.new(1, 0, 1, 0),
                                    BackgroundTransparency = 1,
                                }, {
                                    aj('UIListLayout', {
                                        Padding = UDim.new(0, an.TabPadding),
                                        FillDirection = 'Horizontal',
                                        VerticalAlignment = 'Center',
                                    }),
                                    aj('UIPadding', {
                                        PaddingTop = UDim.new(0, an.TabPadding),
                                        PaddingLeft = UDim.new(0, an.TabPadding),
                                        PaddingRight = UDim.new(0, an.TabPadding),
                                        PaddingBottom = UDim.new(0, an.TabPadding),
                                    }),
                                    aj('UICorner', {
                                        CornerRadius = UDim.new(0, an.MenuCorner - an.MenuPadding),
                                    }),
                                    az,
                                    aj('Frame', {
                                        Size = UDim2.new(1, az and -an.TabPadding - aA or 0, 0, 0),
                                        BackgroundTransparency = 1,
                                        AutomaticSize = 'Y',
                                        Name = 'Title',
                                    }, {
                                        aj('TextLabel', {
                                            Text = ay.Name,
                                            TextXAlignment = 'Left',
                                            FontFace = Font.new(ai.Font, Enum.FontWeight.Medium),
                                            ThemeTag = {
                                                TextColor3 = 'Text',
                                                BackgroundColor3 = 'Text',
                                            },
                                            TextSize = 15,
                                            BackgroundTransparency = 1,
                                            TextTransparency = ap == 'Dropdown' and 0.4 or 0.05,
                                            LayoutOrder = 999,
                                            AutomaticSize = 'Y',
                                            Size = UDim2.new(1, 0, 0, 0),
                                        }),
                                        aj('TextLabel', {
                                            Text = ay.Desc or '',
                                            TextXAlignment = 'Left',
                                            FontFace = Font.new(ai.Font, Enum.FontWeight.Regular),
                                            ThemeTag = {
                                                TextColor3 = 'Text',
                                                BackgroundColor3 = 'Text',
                                            },
                                            TextSize = 15,
                                            BackgroundTransparency = 1,
                                            TextTransparency = ap == 'Dropdown' and 0.6 or 0.35,
                                            LayoutOrder = 999,
                                            AutomaticSize = 'Y',
                                            TextWrapped = true,
                                            Size = UDim2.new(1, 0, 0, 0),
                                            Visible = ay.Desc and true or false,
                                            Name = 'Desc',
                                        }),
                                        aj('UIListLayout', {
                                            Padding = UDim.new(0, an.TabPadding / 3),
                                            FillDirection = 'Vertical',
                                        }),
                                    }),
                                }),
                            }, true)

                            if ay.Locked then
                                ay.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0.6
                                if ay.UIElements.TabIcon then
                                    ay.UIElements.TabIcon.ImageLabel.ImageTransparency = 0.6
                                end
                            end

                            if am.Multi and typeof(am.Value) == 'string' then
                                for aB, b in next, am.Values do
                                    if typeof(b) == 'table' then
                                        if b.Title == am.Value then
                                            am.Value = { b }
                                        end
                                    else
                                        if b == am.Value then
                                            am.Value = { am.Value }
                                        end
                                    end
                                end
                            end

                            if am.Multi then
                                local aB = false
                                if typeof(am.Value) == 'table' then
                                    for b, d in ipairs(am.Value) do
                                        local f = typeof(d) == 'table' and d.Title or d
                                        if f == ay.Name then
                                            aB = true
                                            break
                                        end
                                    end
                                end
                                ay.Selected = aB
                            else
                                local aB = typeof(am.Value) == 'table' and am.Value.Title or am.Value
                                ay.Selected = aB == ay.Name
                            end

                            if ay.Selected and not ay.Locked then
                                ay.UIElements.TabItem.ImageTransparency = 0.95
                                ay.UIElements.TabItem.Highlight.ImageTransparency = 0.75
                                ay.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0
                                if ay.UIElements.TabIcon then
                                    ay.UIElements.TabIcon.ImageLabel.ImageTransparency = 0
                                end
                            end

                            am.Tabs[av] = ay

                            aq:Display()

                            if ap == 'Dropdown' then
                                ai.AddSignal(ay.UIElements.TabItem.MouseButton1Click, function()
                                    if ay.Locked then
                                        return
                                    end

                                    if am.Multi then
                                        if not ay.Selected then
                                            ay.Selected = true
                                            ak(ay.UIElements.TabItem, 0.1, { ImageTransparency = 0.95 }):Play()
                                            ak(ay.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 0.75 }):Play()
                                            ak(
                                                ay.UIElements.TabItem.Frame.Title.TextLabel,
                                                0.1,
                                                { TextTransparency = 0 }
                                            ):Play()
                                            if ay.UIElements.TabIcon then
                                                ak(ay.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0 }):Play()
                                            end
                                            table.insert(am.Value, ay.Original)
                                        else
                                            if not am.AllowNone and #am.Value == 1 then
                                                return
                                            end
                                            ay.Selected = false
                                            ak(ay.UIElements.TabItem, 0.1, { ImageTransparency = 1 }):Play()
                                            ak(ay.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 1 }):Play()
                                            ak(
                                                ay.UIElements.TabItem.Frame.Title.TextLabel,
                                                0.1,
                                                { TextTransparency = 0.4 }
                                            ):Play()
                                            if ay.UIElements.TabIcon then
                                                ak(ay.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0.2 }):Play()
                                            end

                                            for aB, b in next, am.Value do
                                                if typeof(b) == 'table' and (b.Title == ay.Name) or (b == ay.Name) then
                                                    table.remove(am.Value, aB)
                                                    break
                                                end
                                            end
                                        end
                                    else
                                        for aB, b in next, am.Tabs do
                                            ak(b.UIElements.TabItem, 0.1, { ImageTransparency = 1 }):Play()
                                            ak(b.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 1 }):Play()
                                            ak(
                                                b.UIElements.TabItem.Frame.Title.TextLabel,
                                                0.1,
                                                { TextTransparency = 0.4 }
                                            ):Play()
                                            if b.UIElements.TabIcon then
                                                ak(b.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0.2 }):Play()
                                            end
                                            b.Selected = false
                                        end
                                        ay.Selected = true
                                        ak(ay.UIElements.TabItem, 0.1, { ImageTransparency = 0.95 }):Play()
                                        ak(ay.UIElements.TabItem.Highlight, 0.1, { ImageTransparency = 0.75 }):Play()
                                        ak(ay.UIElements.TabItem.Frame.Title.TextLabel, 0.1, { TextTransparency = 0 }):Play()
                                        if ay.UIElements.TabIcon then
                                            ak(ay.UIElements.TabIcon.ImageLabel, 0.1, { ImageTransparency = 0 }):Play()
                                        end
                                        am.Value = ay.Original
                                    end
                                    Callback()
                                end)
                            elseif ap == 'Menu' then
                                if not ay.Locked then
                                    ai.AddSignal(ay.UIElements.TabItem.MouseEnter, function()
                                        ak(ay.UIElements.TabItem, 0.08, { ImageTransparency = 0.95 }):Play()
                                    end)
                                    ai.AddSignal(ay.UIElements.TabItem.InputEnded, function()
                                        ak(ay.UIElements.TabItem, 0.08, { ImageTransparency = 1 }):Play()
                                    end)
                                end
                                ai.AddSignal(ay.UIElements.TabItem.MouseButton1Click, function()
                                    if ay.Locked then
                                        return
                                    end
                                    Callback(aw.Callback or function() end)
                                end)
                            end

                            RecalculateCanvasSize()
                            RecalculateListSize()
                        end
                    end

                    local av = am.MenuWidth or 0
                    if av == 0 then
                        for aw, ax in next, am.Tabs do
                            if ax.UIElements.TabItem.Frame.UIListLayout then
                                av = math.max(av, ax.UIElements.TabItem.Frame.UIListLayout.AbsoluteContentSize.X)
                            end
                        end
                    end

                    am.UIElements.MenuCanvas.Size = UDim2.new(
                        0,
                        av + 6 + 6 + 5 + 5 + 18 + 6 + 6,
                        am.UIElements.MenuCanvas.Size.Y.Scale,
                        am.UIElements.MenuCanvas.Size.Y.Offset
                    )
                    if au then
                        aq:Display()
                    else
                        Callback()
                    end

                    am.Values = at
                end

                aq:Refresh(am.Values)

                function aq.Select(as, at, au)
                    if at then
                        am.Value = at
                    else
                        if am.Multi then
                            am.Value = {}
                        else
                            am.Value = nil
                        end
                    end
                    aq:Refresh(am.Values, au == true)
                end

                RecalculateListSize()
                RecalculateCanvasSize()

                function aq.Open(as)
                    if not ao or am.Opened then
                        return
                    end

                    am.Opened = true

                    if am.SpecialType and am.SpecialType ~= 'None' and am.RefreshSpecialValues then
                        am:RefreshSpecialValues(true)
                    end

                    am.UIElements.Menu.Visible = true
                    am.UIElements.MenuCanvas.Visible = true
                    am.UIElements.MenuCanvas.Active = true
                    am.UIElements.Menu.Size = UDim2.new(1, 0, 0, 0)
                    ak(am.UIElements.Menu, 0.1, {
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.05,
                    }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()

                    UpdatePosition()
                end

                function aq.Close(as)
                    if not am.Opened and not am.UIElements.MenuCanvas.Visible then
                        return
                    end

                    am.Opened = false

                    ak(am.UIElements.Menu, 0.25, {
                        Size = UDim2.new(1, 0, 0, 0),
                        ImageTransparency = 1,
                    }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()

                    task.spawn(function()
                        task.wait(0.1)
                        am.UIElements.Menu.Visible = false
                    end)

                    task.spawn(function()
                        task.wait(0.25)
                        am.UIElements.MenuCanvas.Visible = false
                        am.UIElements.MenuCanvas.Active = false
                    end)
                end

                ai.AddSignal(
                    (
                        am.UIElements.Dropdown and am.UIElements.Dropdown.MouseButton1Click
                        or am.DropdownFrame.UIElements.Main.MouseButton1Click
                    ),
                    function()
                        if am.Opened then
                            aq:Close()
                        else
                            aq:Open()
                        end
                    end
                )

                ai.AddSignal(ad.InputBegan, function(as)
                    if
                        as.UserInputType == Enum.UserInputType.MouseButton1
                        or as.UserInputType == Enum.UserInputType.Touch
                    then
                        local at = am.UIElements.MenuCanvas
                        local au, av = at.AbsolutePosition, at.AbsoluteSize

                        local aw = am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
                        local ax = aw.AbsolutePosition
                        local ay = aw.AbsoluteSize

                        local az = ae.X >= ax.X and ae.X <= ax.X + ay.X and ae.Y >= ax.Y and ae.Y <= ax.Y + ay.Y

                        local aA = ae.X >= au.X and ae.X <= au.X + av.X and ae.Y >= au.Y and ae.Y <= au.Y + av.Y

                        if al.Window.CanDropdown and am.Opened and not az and not aA then
                            aq:Close()
                        end
                    end
                end)

                ai.AddSignal(
                    am.UIElements.Dropdown and am.UIElements.Dropdown:GetPropertyChangedSignal('AbsolutePosition')
                        or am.DropdownFrame.UIElements.Main:GetPropertyChangedSignal('AbsolutePosition'),
                    UpdatePosition
                )

                return aq
            end

            return aa
        end
        function WindUIModules.DropdownUtilities(): typeof(buildModule())
            local aa = WindUIModules.cache.DropdownUtilities
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.DropdownUtilities = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            aa(game:GetService('UserInputService'))
            aa(game:GetService('Players')).LocalPlayer:GetMouse()
            local ab = aa(game:GetService('Workspace')).CurrentCamera
            local ad = aa(game:GetService('Players'))
            local ae = aa(game:GetService('Teams'))

            local af = WindUIModules.LocalizationModule()
            local ag = af.New
            local ah = af.Tween

            local ai = WindUIModules.PanelModule().New
            local aj = WindUIModules.PopupModule().New
            local ak = WindUIModules.DropdownUtilities().New
            local al = 
workspace.CurrentCamera

            local function NormalizeSpecialType(am)
                if typeof(am) == 'string' then
                    local an = string.lower(am)

                    if an == 'player' then
                        return 'Player'
                    end
                    if an == 'team' then
                        return 'Team'
                    end
                end

                return 'None'
            end

            local am = {
                UICorner = 10,
                UIPadding = 12,
                MenuCorner = 15,
                MenuPadding = 5,
                TabPadding = 10,
                SearchBarHeight = 39,
                TabIcon = 18,
            }

            function am.New(an, ao)
                local ap = {
                    __type = 'Dropdown',
                    Title = ao.Title or 'Dropdown',
                    Desc = ao.Desc or nil,
                    Locked = ao.Locked or false,
                    LockedTitle = ao.LockedTitle,
                    Values = ao.Values or {},
                    ManualValues = ao.Values or {},
                    SpecialType = NormalizeSpecialType(ao.SpecialType),
                    ExcludeLocalPlayer = ao.ExcludeLocalPlayer == true,
                    AutoRefreshSpecialValues = ao.AutoRefreshSpecialValues ~= false,
                    MenuWidth = ao.MenuWidth,
                    Value = ao.Value,
                    AllowNone = ao.AllowNone,
                    SearchBarEnabled = ao.SearchBarEnabled or false,
                    Multi = ao.Multi,
                    Callback = ao.Callback or nil,

                    UIElements = {},

                    Opened = false,
                    Tabs = {},
                    Destroyed = false,

                    Width = 150,
                }

                local function GetItemTitle(aq)
                    if typeof(aq) == 'table' then
                        return aq.Title or aq.Value or aq.Name
                    end

                    return aq
                end

                local aq = {}

                local function BuildPlayerValues()
                    local ar = {}
                    local as = ad.LocalPlayer

                    for at, au in next, ad:GetPlayers() do
                        if not (ap.ExcludeLocalPlayer and au == as) then
                            local av = aq[au.UserId]
                            if av == nil then
                                local aw, ax = pcall(function()
                                    return ad:GetUserThumbnailAsync(
                                        au.UserId,
                                        Enum.ThumbnailType.HeadShot,
                                        Enum.ThumbnailSize.Size48x48
                                    )
                                end)

                                av = aw and ax or ''
                                aq[au.UserId] = av
                            end

                            table.insert(ar, {
                                Title = au.Name,
                                Value = au.Name,
                                Desc = au.DisplayName ~= au.Name and ('Display: ' .. au.DisplayName) or nil,
                                UserId = au.UserId,
                                Image = av,
                                ImageSize = 18,
                            })
                        end
                    end

                    table.sort(ar, function(at, au)
                        return string.lower(at.Title) < string.lower(au.Title)
                    end)

                    return ar
                end

                local function BuildTeamValues()
                    local ar = {}

                    for as, at in next, ae:GetTeams() do
                        table.insert(ar, {
                            Title = at.Name,
                            Value = at.Name,
                        })
                    end

                    table.sort(ar, function(as, at)
                        return string.lower(as.Title) < string.lower(at.Title)
                    end)

                    return ar
                end

                local function BuildSpecialValues()
                    if ap.SpecialType == 'Player' then
                        return BuildPlayerValues()
                    elseif ap.SpecialType == 'Team' then
                        return BuildTeamValues()
                    end

                    return ap.ManualValues
                end

                local ar = false
                local function QueueSpecialRefresh()
                    if ap.SpecialType == 'None' or not ap.AutoRefreshSpecialValues or ap.Destroyed then
                        return
                    end

                    if ar then
                        return
                    end
                    ar = true

                    task.defer(function()
                        ar = false
                        if ap.Destroyed then
                            return
                        end

                        if ap.RefreshSpecialValues then
                            ap:RefreshSpecialValues(true)
                        end
                    end)
                end

                local function ReconcileSelection(as)
                    if ap.Multi then
                        local at = {}
                        local au = {}

                        if typeof(ap.Value) == 'table' then
                            for av, aw in ipairs(ap.Value) do
                                local ax = GetItemTitle(aw)
                                if ax ~= nil then
                                    at[ax] = true
                                end
                            end
                        end

                        for av, aw in next, as do
                            local ax = GetItemTitle(aw)
                            if ax ~= nil and at[ax] then
                                table.insert(au, aw)
                            end
                        end

                        ap.Value = au
                        return
                    end

                    local at = GetItemTitle(ap.Value)
                    if at == nil then
                        ap.Value = nil
                        return
                    end

                    local au
                    for av, aw in next, as do
                        if GetItemTitle(aw) == at then
                            au = aw
                            break
                        end
                    end

                    ap.Value = au
                end

                if ap.Multi and not ap.Value then
                    ap.Value = {}
                end
                if ap.Values and typeof(ap.Value) == 'number' then
                    ap.Value = ap.Values[ap.Value]
                end

                if ap.SpecialType ~= 'None' then
                    ap.Values = BuildSpecialValues()
                    ReconcileSelection(ap.Values)
                end

                local as = true

                ap.DropdownFrame = WindUIModules.ElementFrameModule()({
                    Title = ap.Title,
                    Desc = ap.Desc,
                    Parent = ao.Parent,
                    TextOffset = ap.Callback and ap.Width or 20,
                    Hover = not ap.Callback and true or false,
                    Tab = ao.Tab,
                    Index = ao.Index,
                    Window = ao.Window,
                    ElementTable = ap,
                    ParentConfig = ao,
                })

                if ap.Callback then
                    ap.UIElements.Dropdown = ai('', nil, ap.DropdownFrame.UIElements.Main, nil, 10)

                    ap.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate = 'AtEnd'
                    ap.UIElements.Dropdown.Frame.Frame.TextLabel.Size =
                        UDim2.new(1, ap.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset - 18 - 12 - 12, 0, 0)

                    ap.UIElements.Dropdown.Size = UDim2.new(0, ap.Width, 0, 36)
                    ap.UIElements.Dropdown.Position = UDim2.new(1, 0, 0.5, 0)
                    ap.UIElements.Dropdown.AnchorPoint = Vector2.new(1, 0.5)
                end

                ap.DropdownMenu = ak(ao, ap, am, as, 'Dropdown')

                ap.Display = ap.DropdownMenu.Display
                local at = ap.DropdownMenu.Refresh
                ap.Select = ap.DropdownMenu.Select
                ap.Open = ap.DropdownMenu.Open
                ap.Close = ap.DropdownMenu.Close

                function ap.RefreshSpecialValues(au, av)
                    if ap.SpecialType == 'None' then
                        ap.Values = ap.ManualValues
                        return at(ap.DropdownMenu, ap.Values, av == true)
                    end

                    local aw = BuildSpecialValues()
                    ReconcileSelection(aw)
                    ap.Values = aw

                    return at(ap.DropdownMenu, aw, av == true)
                end

                function ap.SetSpecialType(au, av)
                    ap.SpecialType = NormalizeSpecialType(av)
                    return ap:RefreshSpecialValues()
                end

                function ap.SetExcludeLocalPlayer(au, av)
                    ap.ExcludeLocalPlayer = av == true

                    if ap.SpecialType == 'Player' then
                        return ap:RefreshSpecialValues()
                    end
                end

                function ap.Refresh(au, av, aw)
                    if av ~= nil then
                        if ap.SpecialType == 'None' then
                            ap.ManualValues = av
                            ap.Values = av
                            return at(ap.DropdownMenu, av, aw == true)
                        end

                        return ap:RefreshSpecialValues(aw == true)
                    end

                    if ap.SpecialType == 'None' then
                        return at(ap.DropdownMenu, ap.ManualValues, aw == true)
                    end

                    return ap:RefreshSpecialValues(aw == true)
                end

                function ap.SetAutoRefreshSpecialValues(au, av)
                    ap.AutoRefreshSpecialValues = av ~= false

                    if ap.AutoRefreshSpecialValues and ap.SpecialType ~= 'None' then
                        return ap:RefreshSpecialValues(true)
                    end
                end

                function ap.GetSelected(au)
                    return ap.Value
                end

                ag('ImageLabel', {
                    Image = af.Icon('chevrons-up-down')[1],
                    ImageRectOffset = af.Icon('chevrons-up-down')[2].ImageRectPosition,
                    ImageRectSize = af.Icon('chevrons-up-down')[2].ImageRectSize,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(1, ap.UIElements.Dropdown and -12 or 0, 0.5, 0),
                    ThemeTag = {
                        ImageColor3 = 'Icon',
                    },
                    AnchorPoint = Vector2.new(1, 0.5),
                    Parent = ap.UIElements.Dropdown and ap.UIElements.Dropdown.Frame
                        or ap.DropdownFrame.UIElements.Main,
                })

                function ap.Lock(au)
                    ap.Locked = true
                    as = false
                    return ap.DropdownFrame:Lock(ap.LockedTitle)
                end
                function ap.Unlock(au)
                    ap.Locked = false
                    as = true
                    return ap.DropdownFrame:Unlock()
                end

                af.AddSignal(ad.PlayerAdded, function()
                    if ap.SpecialType == 'Player' then
                        QueueSpecialRefresh()
                    end
                end)

                af.AddSignal(ad.PlayerRemoving, function()
                    if ap.SpecialType == 'Player' then
                        QueueSpecialRefresh()
                    end
                end)

                af.AddSignal(ae.ChildAdded, function(au)
                    if ap.SpecialType == 'Team' and au:IsA('Team') then
                        QueueSpecialRefresh()
                    end
                end)

                af.AddSignal(ae.ChildRemoved, function(au)
                    if ap.SpecialType == 'Team' and au:IsA('Team') then
                        QueueSpecialRefresh()
                    end
                end)

                function ap.Destroy(au)
                    ap.Destroyed = true
                    if ap.Opened and ap.Close then
                        ap:Close()
                    end

                    if ap.UIElements.MenuCanvas then
                        ap.UIElements.MenuCanvas:Destroy()
                        ap.UIElements.MenuCanvas = nil
                        ap.UIElements.Menu = nil
                    end

                    if ap.DropdownFrame and ap.DropdownFrame.Destroy then
                        ap.DropdownFrame:Destroy()
                        ap.DropdownFrame = nil
                    end
                end

                if ap.Locked then
                    ap:Lock()
                end

                return ap.__type, ap
            end

            return am
        end
        function WindUIModules.DropdownElement(): typeof(buildModule())
            local aa = WindUIModules.cache.DropdownElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.DropdownElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New
            local ae = aa.Tween

            local af = {}

            local function NormalizeOption(ag, ai)
                if typeof(ag) == 'table' then
                    local ak = ag.Title or ag.Text or ag.Name or ag.Value or ('Option ' .. tostring(ai))
                    local al = ag.Value
                    if al == nil then
                        al = ak
                    end

                    return {
                        Title = tostring(ak),
                        Value = al,
                        Icon = ag.Icon,
                        Disabled = ag.Disabled == true,
                    }
                end

                local ak = tostring(ag)
                return {
                    Title = ak,
                    Value = ag,
                    Icon = nil,
                    Disabled = false,
                }
            end

            local function NormalizeOptions(ag)
                local ai = {}
                if typeof(ag) ~= 'table' then
                    return ai
                end

                if #ag > 0 then
                    for ak, al in ipairs(ag) do
                        table.insert(ai, NormalizeOption(al, ak))
                    end
                else
                    for ak, al in next, ag do
                        if typeof(al) == 'table' then
                            local am = NormalizeOption(al, ak)
                            if am.Value == nil then
                                am.Value = ak
                            end
                            if am.Title == '' then
                                am.Title = tostring(ak)
                            end
                            table.insert(ai, am)
                        else
                            table.insert(
                                ai,
                                NormalizeOption({
                                    Title = ak,
                                    Value = al,
                                }, ak)
                            )
                        end
                    end

                    table.sort(ai, function(ak, al)
                        return string.lower(ak.Title) < string.lower(al.Title)
                    end)
                end

                return ai
            end

            local function CloneArray(ag)
                local ai = {}
                if typeof(ag) ~= 'table' then
                    return ai
                end

                for ak, al in ipairs(ag) do
                    ai[ak] = al
                end
                return ai
            end

            local function ClearTable(ag)
                for ai in next, ag do
                    ag[ai] = nil
                end
            end

            local function GetValueKey(ag)
                return tostring(ag)
            end

            local function FindImageObject(ag)
                if not ag then
                    return nil
                end

                if ag:IsA('ImageLabel') or ag:IsA('ImageButton') then
                    return ag
                end

                local ai = ag:FindFirstChild('ImageLabel')
                if ai and (ai:IsA('ImageLabel') or ai:IsA('ImageButton')) then
                    return ai
                end

                local ak = ag:FindFirstChildWhichIsA('ImageLabel')
                if ak then
                    return ak
                end

                return ag:FindFirstChildWhichIsA('ImageButton')
            end

            function af.New(ag, ai)
                local ak = {
                    __type = 'Segmented',
                    Title = ai.Title or 'Segmented',
                    Desc = ai.Desc,
                    Locked = ai.Locked or false,
                    LockedTitle = ai.LockedTitle,
                    Options = NormalizeOptions(ai.Options or ai.Values or {}),
                    Multi = ai.Multi == true,
                    AllowNone = ai.AllowNone == true,
                    MinSelections = math.max(tonumber(ai.MinSelections) or 0, 0),
                    MaxSelections = tonumber(ai.MaxSelections),
                    Value = ai.Value,
                    Callback = ai.Callback or function() end,
                    UIElements = {},
                }

                if ak.MaxSelections and ak.MaxSelections < ak.MinSelections then
                    ak.MaxSelections = ak.MinSelections
                end

                local al = true
                local am = {}
                local an = {}

                local ao = typeof(ai.SegmentHeight) == 'number' and math.max(math.floor(ai.SegmentHeight), 28) or 32
                local ap = typeof(ai.SegmentPaddingX) == 'number' and math.max(math.floor(ai.SegmentPaddingX), 8) or 12
                local aq = typeof(ai.SegmentGap) == 'number' and math.max(math.floor(ai.SegmentGap), 4) or 6
                local ar = math.max(ai.Window.ElementConfig.UICorner - 5, 8)

                ak.SegmentedFrame = WindUIModules.ElementFrameModule()({
                    Title = ak.Title,
                    Desc = ak.Desc,
                    Parent = ai.Parent,
                    TextOffset = 20,
                    Hover = false,
                    Tab = ai.Tab,
                    Index = ai.Index,
                    Window = ai.Window,
                    ElementTable = ak,
                    ParentConfig = ai,
                })

                local as = ad('Frame', {
                    Name = 'Segments',
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                    Parent = ak.SegmentedFrame.UIElements.Container,
                }, {
                    ad('UIListLayout', {
                        FillDirection = 'Horizontal',
                        HorizontalAlignment = 'Left',
                        VerticalAlignment = 'Center',
                        Padding = UDim.new(0, aq),
                        Wraps = true,
                    }),
                })

                ak.UIElements.Segments = as

                local function CountSelections()
                    local at = 0
                    for au in next, am do
                        at = at + 1
                    end
                    return at
                end

                local function BuildValueFromLookup()
                    if ak.Multi then
                        local at = {}
                        for au, av in ipairs(ak.Options) do
                            local aw = GetValueKey(av.Value)
                            if am[aw] then
                                table.insert(at, av.Value)
                            end
                        end
                        ak.Value = at
                        return
                    end

                    ak.Value = nil
                    for at, au in ipairs(ak.Options) do
                        local av = GetValueKey(au.Value)
                        if am[av] then
                            ak.Value = au.Value
                            return
                        end
                    end
                end

                local function FilterLookupToValidOptions()
                    local at = {}
                    for au, av in ipairs(ak.Options) do
                        at[GetValueKey(av.Value)] = true
                    end

                    for au in next, am do
                        if not at[au] then
                            am[au] = nil
                        end
                    end
                end

                local function EnforceSelectionLimits()
                    if ak.Multi then
                        if ak.MaxSelections then
                            local at = 0
                            for au, av in ipairs(ak.Options) do
                                local aw = GetValueKey(av.Value)
                                if am[aw] then
                                    at = at + 1
                                    if at > ak.MaxSelections then
                                        am[aw] = nil
                                    end
                                end
                            end
                        end

                        if ak.MinSelections > 0 then
                            local at = CountSelections()
                            if at < ak.MinSelections then
                                for au, av in ipairs(ak.Options) do
                                    local aw = GetValueKey(av.Value)
                                    if not av.Disabled and not am[aw] then
                                        am[aw] = true
                                        at = at + 1
                                        if at >= ak.MinSelections then
                                            break
                                        end
                                    end
                                end
                            end
                        end

                        return
                    end

                    local at
                    for au, av in ipairs(ak.Options) do
                        local aw = GetValueKey(av.Value)
                        if am[aw] then
                            if not at then
                                at = aw
                            else
                                am[aw] = nil
                            end
                        end
                    end

                    if not at and not ak.AllowNone and ak.Options[1] then
                        am[GetValueKey(ak.Options[1].Value)] = true
                    end
                end

                local function SyncLookupFromValue(at)
                    ClearTable(am)

                    if ak.Multi then
                        if typeof(at) == 'table' then
                            for au, av in ipairs(at) do
                                am[GetValueKey(av)] = true
                            end
                        end
                    elseif at ~= nil then
                        am[GetValueKey(at)] = true
                    end

                    FilterLookupToValidOptions()
                    EnforceSelectionLimits()
                    BuildValueFromLookup()
                end

                local function FireCallback()
                    if al then
                        local at = ak.Multi and CloneArray(ak.Value) or ak.Value
                        aa.SafeCallback(ak.Callback, at, ak)
                    end
                end

                local function IsEntrySelected(at)
                    local au = GetValueKey(at.Option.Value)
                    return am[au] == true
                end

                local function ApplyButtonState(at, au)
                    local av = IsEntrySelected(at)
                    local aw = ak.Locked or at.Option.Disabled
                    local ax = at.Icon and FindImageObject(at.Icon) or nil

                    aa.SetThemeTag(at.Button, {
                        ImageColor3 = av and 'Accent' or 'Text',
                    })
                    if ax then
                        aa.SetThemeTag(ax, {
                            ImageColor3 = av and 'Text' or 'Icon',
                        })
                    end

                    local ay = av and 0.08 or 0.94
                    local az = av and 0 or 0.35
                    local aA = av and 0.05 or 0.35

                    if aw then
                        ay = av and 0.2 or 0.97
                        az = av and 0.2 or 0.55
                        aA = av and 0.2 or 0.55
                    end

                    at.Button.Active = not aw

                    if au then
                        at.Button.ImageTransparency = ay
                        at.Label.TextTransparency = az

                        if ax then
                            ax.ImageTransparency = aA
                        end
                        return
                    end

                    ae(at.Button, 0.12, {
                        ImageTransparency = ay,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                    ae(at.Label, 0.12, {
                        TextTransparency = az,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                    if ax then
                        ae(ax, 0.12, {
                            ImageTransparency = aA,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end

                local function UpdateAllButtonStates(at)
                    for au, av in ipairs(an) do
                        ApplyButtonState(av, at)
                    end
                end

                local function ResolveOptionByReference(at)
                    if typeof(at) == 'number' and ak.Options[at] then
                        return ak.Options[at]
                    end

                    local au = GetValueKey(at)
                    for av, aw in ipairs(ak.Options) do
                        if GetValueKey(aw.Value) == au or aw.Title == tostring(at) then
                            return aw
                        end
                    end

                    return nil
                end

                local function ClearButtons()
                    for at, au in ipairs(an) do
                        if au.Button then
                            au.Button:Destroy()
                        end
                    end
                    ClearTable(an)
                end

                local function SelectOption(at, au)
                    if not at then
                        return ak
                    end

                    if at.Disabled or ak.Locked then
                        return ak
                    end

                    local av = GetValueKey(at.Value)
                    local aw = false

                    if ak.Multi then
                        if am[av] then
                            if CountSelections() > ak.MinSelections then
                                am[av] = nil
                                aw = true
                            end
                        else
                            if not ak.MaxSelections or CountSelections() < ak.MaxSelections then
                                am[av] = true
                                aw = true
                            end
                        end
                    else
                        if am[av] then
                            if ak.AllowNone then
                                am[av] = nil
                                aw = true
                            end
                        else
                            ClearTable(am)
                            am[av] = true
                            aw = true
                        end
                    end

                    EnforceSelectionLimits()
                    BuildValueFromLookup()
                    UpdateAllButtonStates(false)

                    if aw and au ~= true then
                        FireCallback()
                    end

                    return ak
                end

                local function BuildButtons()
                    for at, au in ipairs(ak.Options) do
                        local av = aa.NewRoundFrame(ar, 'Squircle', {
                            Name = 'Option_' .. tostring(at),
                            Size = UDim2.new(0, 0, 0, ao),
                            AutomaticSize = 'X',
                            ImageTransparency = 0.94,
                            ThemeTag = {
                                ImageColor3 = 'Text',
                            },
                            Parent = as,
                            Active = true,
                        }, {
                            ad('UIListLayout', {
                                FillDirection = 'Horizontal',
                                VerticalAlignment = 'Center',
                                HorizontalAlignment = 'Center',
                                Padding = UDim.new(0, 6),
                            }),
                            ad('UIPadding', {
                                PaddingLeft = UDim.new(0, ap),
                                PaddingRight = UDim.new(0, ap),
                            }),
                        }, true)

                        local aw
                        if au.Icon then
                            aw = aa.Image(
                                au.Icon,
                                ak.Title .. ':' .. au.Title,
                                0,
                                ai.Window.Folder,
                                'Segmented',
                                true,
                                true,
                                'Icon'
                            )
                            aw.Size = UDim2.new(0, 14, 0, 14)
                            aw.Parent = av
                        end

                        local ax = ad('TextLabel', {
                            BackgroundTransparency = 1,
                            AutomaticSize = 'XY',
                            Text = au.Title,
                            TextSize = 14,
                            FontFace = Font.new(aa.Font, Enum.FontWeight.Medium),
                            TextXAlignment = 'Center',
                            TextYAlignment = 'Center',
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                        })
                        ax.Parent = av

                        local ay = {
                            Option = au,
                            Button = av,
                            Label = ax,
                            Icon = aw,
                        }

                        table.insert(an, ay)

                        aa.AddSignal(av.MouseButton1Click, function()
                            SelectOption(au, false)
                        end)

                        aa.AddSignal(av.MouseEnter, function()
                            if ak.Locked or au.Disabled or IsEntrySelected(ay) then
                                return
                            end

                            ae(av, 0.1, {
                                ImageTransparency = 0.88,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end)

                        aa.AddSignal(av.MouseLeave, function()
                            ApplyButtonState(ay, false)
                        end)
                    end
                end

                function ak.Get(at)
                    return ak.Multi and CloneArray(ak.Value) or ak.Value
                end

                function ak.Set(at, au, av)
                    SyncLookupFromValue(au)
                    UpdateAllButtonStates(false)

                    if av ~= true then
                        FireCallback()
                    end

                    return ak
                end

                function ak.Select(at, au, av)
                    local aw = ResolveOptionByReference(au)
                    return SelectOption(aw, av)
                end

                function ak.Deselect(at, au, av)
                    if ak.Locked then
                        return ak
                    end

                    local aw = ResolveOptionByReference(au)
                    if not aw then
                        return ak
                    end

                    local ax = GetValueKey(aw.Value)
                    if not am[ax] then
                        return ak
                    end

                    if ak.Multi then
                        if CountSelections() <= ak.MinSelections then
                            return ak
                        end
                        am[ax] = nil
                    else
                        if not ak.AllowNone then
                            return ak
                        end
                        am[ax] = nil
                    end

                    BuildValueFromLookup()
                    UpdateAllButtonStates(false)

                    if av ~= true then
                        FireCallback()
                    end

                    return ak
                end

                function ak.Toggle(at, au, av)
                    local aw = ResolveOptionByReference(au)
                    if not aw then
                        return ak
                    end

                    local ax = GetValueKey(aw.Value)
                    if am[ax] then
                        return ak:Deselect(au, av)
                    end

                    return ak:Select(au, av)
                end

                function ak.SetOptions(at, au, av)
                    local aw
                    if av ~= false then
                        aw = ak.Multi and CloneArray(ak.Value) or ak.Value
                    end

                    ak.Options = NormalizeOptions(au or {})
                    ClearButtons()
                    BuildButtons()

                    if aw ~= nil then
                        ak:Set(aw, true)
                    else
                        ak:Set(ak.Multi and {} or nil, true)
                    end

                    return ak
                end

                function ak.GetOptions(at)
                    local au = {}
                    for av, aw in ipairs(ak.Options) do
                        au[#au + 1] = table.clone(aw)
                    end
                    return au
                end

                function ak.Lock(at)
                    ak.Locked = true
                    al = false
                    UpdateAllButtonStates(true)
                    return ak.SegmentedFrame:Lock(ak.LockedTitle)
                end

                function ak.Unlock(at)
                    ak.Locked = false
                    al = true
                    UpdateAllButtonStates(true)
                    return ak.SegmentedFrame:Unlock()
                end

                function ak.Destroy(at)
                    ClearButtons()
                    if ak.SegmentedFrame and ak.SegmentedFrame.Destroy then
                        ak.SegmentedFrame:Destroy()
                        ak.SegmentedFrame = nil
                    end
                end

                BuildButtons()

                if ak.Multi then
                    if typeof(ak.Value) ~= 'table' then
                        ak.Value = {}
                    end
                    ak:Set(ak.Value, true)
                else
                    if ak.Value == nil and not ak.AllowNone and ak.Options[1] then
                        ak.Value = ak.Options[1].Value
                    end
                    ak:Set(ak.Value, true)
                end

                if ak.Locked then
                    ak:Lock()
                else
                    ak:Unlock()
                end

                return ak.__type, ak
            end

            return af
        end
        function WindUIModules.SegmentedElement(): typeof(buildModule())
            local aa = WindUIModules.cache.SegmentedElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.SegmentedElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}
            local ad = {
                lua = {
                    'and',
                    'break',
                    'or',
                    'else',
                    'elseif',
                    'if',
                    'then',
                    'until',
                    'repeat',
                    'while',
                    'do',
                    'for',
                    'in',
                    'end',
                    'local',
                    'return',
                    'function',
                    'export',
                },
                rbx = {
                    'game',
                    'workspace',
                    'script',
                    'math',
                    'string',
                    'table',
                    'task',
                    'wait',
                    'select',
                    'next',
                    'Enum',
                    'tick',
                    'assert',
                    'shared',
                    'loadstring',
                    'tonumber',
                    'tostring',
                    'type',
                    'typeof',
                    'unpack',
                    'Instance',
                    'CFrame',
                    'Vector3',
                    'Vector2',
                    'Color3',
                    'UDim',
                    'UDim2',
                    'Ray',
                    'BrickColor',
                    'OverlapParams',
                    'RaycastParams',
                    'Axes',
                    'Random',
                    'Region3',
                    'Rect',
                    'TweenInfo',
                    'collectgarbage',
                    'not',
                    'utf8',
                    'pcall',
                    'xpcall',
                    '_G',
                    'setmetatable',
                    'getmetatable',
                    'os',
                    'pairs',
                    'ipairs',
                },
                operators = {
                    '#',
                    '+',
                    '-',
                    '*',
                    '%',
                    '/',
                    '^',
                    '=',
                    '~',
                    '=',
                    '<',
                    '>',
                },
            }

            local ae = {
                numbers = Color3.fromHex('#FAB387'),
                boolean = Color3.fromHex('#FAB387'),
                operator = Color3.fromHex('#94E2D5'),
                lua = Color3.fromHex('#CBA6F7'),
                rbx = Color3.fromHex('#F38BA8'),
                str = Color3.fromHex('#A6E3A1'),
                comment = Color3.fromHex('#9399B2'),
                null = Color3.fromHex('#F38BA8'),
                call = Color3.fromHex('#89B4FA'),
                self_call = Color3.fromHex('#89B4FA'),
                local_property = Color3.fromHex('#CBA6F7'),
            }

            local function createKeywordSet(af)
                local ag = {}
                for ai, ak in ipairs(af) do
                    ag[ak] = true
                end
                return ag
            end

            local af = createKeywordSet(ad.lua)
            local ag = createKeywordSet(ad.rbx)
            local ai = createKeywordSet(ad.operators)

            local function getHighlight(ak, al)
                local am = ak[al]

                if ae[am .. '_color'] then
                    return ae[am .. '_color']
                end

                if tonumber(am) then
                    return ae.numbers
                elseif am == 'nil' then
                    return ae.null
                elseif am:sub(1, 2) == '--' then
                    return ae.comment
                elseif ai[am] then
                    return ae.operator
                elseif af[am] then
                    return ae.lua
                elseif ag[am] then
                    return ae.rbx
                elseif am:sub(1, 1) == '"' or am:sub(1, 1) == "'" then
                    return ae.str
                elseif am == 'true' or am == 'false' then
                    return ae.boolean
                end

                if ak[al + 1] == '(' then
                    if ak[al - 1] == ':' then
                        return ae.self_call
                    end

                    return ae.call
                end

                if ak[al - 1] == '.' then
                    if ak[al - 2] == 'Enum' then
                        return ae.rbx
                    end

                    return ae.local_property
                end
            end

            function aa.run(ak)
                local al = {}
                local am = ''

                local an = false
                local ao = false
                local ap = false

                for aq = 1, #ak do
                    local ar = ak:sub(aq, aq)

                    if ao then
                        if ar == '\n' and not ap then
                            table.insert(al, am)
                            table.insert(al, ar)
                            am = ''

                            ao = false
                        elseif ak:sub(aq - 1, aq) == ']]' and ap then
                            am = am .. ']'

                            table.insert(al, am)
                            am = ''

                            ao = false
                            ap = false
                        else
                            am = am .. ar
                        end
                    elseif an then
                        if ar == an and ak:sub(aq - 1, aq - 1) ~= '\\' or ar == '\n' then
                            am = am .. ar
                            an = false
                        else
                            am = am .. ar
                        end
                    else
                        if ak:sub(aq, aq + 1) == '--' then
                            table.insert(al, am)
                            am = '-'
                            ao = true
                            ap = ak:sub(aq + 2, aq + 3) == '[['
                        elseif ar == '"' or ar == "'" then
                            table.insert(al, am)
                            am = ar
                            an = ar
                        elseif ai[ar] then
                            table.insert(al, am)
                            table.insert(al, ar)
                            am = ''
                        elseif ar:match('[%w_]') then
                            am = am .. ar
                        else
                            table.insert(al, am)
                            table.insert(al, ar)
                            am = ''
                        end
                    end
                end

                table.insert(al, am)

                local aq = {}

                for ar, as in ipairs(al) do
                    local at = getHighlight(al, ar)

                    if at then
                        local au = string.format(
                            '<font color = "#%s">%s</font>',
                            at:ToHex(),
                            as:gsub('<', '&lt;'):gsub('>', '&gt;')
                        )

                        table.insert(aq, au)
                    else
                        table.insert(aq, as)
                    end
                end

                return table.concat(aq)
            end

            return aa
        end
        function WindUIModules.ProgressUtilities(): typeof(buildModule())
            local aa = WindUIModules.cache.ProgressUtilities
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ProgressUtilities = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ad = WindUIModules.LocalizationModule()
            local ae = ad.New
            local af = ad.Tween

            local ag = WindUIModules.ProgressUtilities()

            function aa.New(ai, ak, al, am, an)
                local ao = {
                    Radius = 12,
                    Padding = 10,
                }

                local ap = ae('TextLabel', {
                    Text = '',
                    TextColor3 = Color3.fromHex('#CDD6F4'),
                    TextTransparency = 0,
                    TextSize = 14,
                    TextWrapped = false,
                    LineHeight = 1.15,
                    RichText = true,
                    TextXAlignment = 'Left',
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = 'XY',
                }, {
                    ae('UIPadding', {
                        PaddingTop = UDim.new(0, ao.Padding + 3),
                        PaddingLeft = UDim.new(0, ao.Padding + 3),
                        PaddingRight = UDim.new(0, ao.Padding + 3),
                        PaddingBottom = UDim.new(0, ao.Padding + 3),
                    }),
                })
                ap.Font = 'Code'

                local aq = ae('ScrollingFrame', {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticCanvasSize = 'X',
                    ScrollingDirection = 'X',
                    ElasticBehavior = 'Never',
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 0,
                }, {
                    ap,
                })

                local ar = ae('TextButton', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 30, 0, 30),
                    Position = UDim2.new(1, -ao.Padding / 2, 0, ao.Padding / 2),
                    AnchorPoint = Vector2.new(1, 0),
                    Visible = am and true or false,
                }, {
                    ad.NewRoundFrame(ao.Radius - 4, 'Squircle', {

                        ImageColor3 = Color3.fromHex('#ffffff'),
                        ImageTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Name = 'Button',
                    }, {
                        ae('UIScale', {
                            Scale = 1,
                        }),
                        ae('ImageLabel', {
                            Image = ad.Icon('copy')[1],
                            ImageRectSize = ad.Icon('copy')[2].ImageRectSize,
                            ImageRectOffset = ad.Icon('copy')[2].ImageRectPosition,
                            BackgroundTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(0, 12, 0, 12),

                            ImageColor3 = Color3.fromHex('#ffffff'),
                            ImageTransparency = 0.1,
                        }),
                    }),
                })

                ad.AddSignal(ar.MouseEnter, function()
                    af(ar.Button, 0.05, { ImageTransparency = 0.95 }):Play()
                    af(ar.Button.UIScale, 0.05, { Scale = 0.9 }):Play()
                end)
                ad.AddSignal(ar.InputEnded, function()
                    af(ar.Button, 0.08, { ImageTransparency = 1 }):Play()
                    af(ar.Button.UIScale, 0.08, { Scale = 1 }):Play()
                end)

                local as = ad.NewRoundFrame(ao.Radius, 'Squircle', {

                    ImageColor3 = Color3.fromHex('#212121'),
                    ImageTransparency = 0.035,
                    Size = UDim2.new(1, 0, 0, 20 + (ao.Padding * 2)),
                    AutomaticSize = 'Y',
                    Parent = al,
                }, {
                    ad.NewRoundFrame(ao.Radius, 'SquircleOutline', {
                        Size = UDim2.new(1, 0, 1, 0),

                        ImageColor3 = Color3.fromHex('#ffffff'),
                        ImageTransparency = 0.955,
                    }),
                    ae('Frame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                    }, {
                        ad.NewRoundFrame(ao.Radius, 'Squircle-TL-TR', {

                            ImageColor3 = Color3.fromHex('#ffffff'),
                            ImageTransparency = 0.96,
                            Size = UDim2.new(1, 0, 0, 20 + (ao.Padding * 2)),
                            Visible = ak and true or false,
                        }, {
                            ae('ImageLabel', {
                                Size = UDim2.new(0, 18, 0, 18),
                                BackgroundTransparency = 1,
                                Image = 'rbxassetid://132464694294269',

                                ImageColor3 = Color3.fromHex('#ffffff'),
                                ImageTransparency = 0.2,
                            }),
                            ae('TextLabel', {
                                Text = ak,

                                TextColor3 = Color3.fromHex('#ffffff'),
                                TextTransparency = 0.2,
                                TextSize = 16,
                                AutomaticSize = 'Y',
                                FontFace = Font.new(ad.Font, Enum.FontWeight.Medium),
                                TextXAlignment = 'Left',
                                BackgroundTransparency = 1,
                                TextTruncate = 'AtEnd',
                                Size = UDim2.new(1, ar and -20 - (ao.Padding * 2), 0, 0),
                            }),
                            ae('UIPadding', {

                                PaddingLeft = UDim.new(0, ao.Padding + 3),
                                PaddingRight = UDim.new(0, ao.Padding + 3),
                            }),
                            ae('UIListLayout', {
                                Padding = UDim.new(0, ao.Padding),
                                FillDirection = 'Horizontal',
                                VerticalAlignment = 'Center',
                            }),
                        }),
                        aq,
                        ae('UIListLayout', {
                            Padding = UDim.new(0, 0),
                            FillDirection = 'Vertical',
                        }),
                    }),
                    ar,
                })

                ao.CodeFrame = as

                ad.AddSignal(ap:GetPropertyChangedSignal('TextBounds'), function()
                    aq.Size = UDim2.new(1, 0, 0, (ap.TextBounds.Y / (an or 1)) + ((ao.Padding + 3) * 2))
                end)

                function ao.Set(at)
                    ap.Text = ag.run(at)
                end

                function ao.Destroy()
                    as:Destroy()
                    ao = nil
                end

                ao.Set(ai)

                ad.AddSignal(ar.MouseButton1Click, function()
                    if am then
                        am()
                        local at = ad.Icon('check')
                        ar.Button.ImageLabel.Image = at[1]
                        ar.Button.ImageLabel.ImageRectSize = at[2].ImageRectSize
                        ar.Button.ImageLabel.ImageRectOffset = at[2].ImageRectPosition

                        task.wait(1)
                        local au = ad.Icon('copy')
                        ar.Button.ImageLabel.Image = au[1]
                        ar.Button.ImageLabel.ImageRectSize = au[2].ImageRectSize
                        ar.Button.ImageLabel.ImageRectOffset = au[2].ImageRectPosition
                    end
                end)
                return ao
            end

            return aa
        end
        function WindUIModules.CodeUtilities(): typeof(buildModule())
            local aa = WindUIModules.cache.CodeUtilities
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.CodeUtilities = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New

            local ae = WindUIModules.CodeUtilities()

            local af = {}

            function af.New(ag, ai)
                local ak = {
                    __type = 'Code',
                    Title = ai.Title,
                    Code = ai.Code,
                    OnCopy = ai.OnCopy,
                }

                local al = not ak.Locked

                local am = ae.New(ak.Code, ak.Title, ai.Parent, function()
                    if al then
                        local am = ak.Title or 'code'
                        local an, ao = pcall(function()
                            local an = toclipboard or setclipboard
                            if not an then
                                error('Clipboard API is not available.')
                            end

                            an(ak.Code)

                            if ak.OnCopy then
                                ak.OnCopy()
                            end
                        end)
                        if not an then
                            ai.WindUI:Notify({
                                Title = 'Error',
                                Content = 'The ' .. am .. ' is not copied. Error: ' .. ao,
                                Icon = 'x',
                                Duration = 5,
                            })
                        end
                    end
                end, ai.WindUI.UIScale, ak)

                function ak.SetCode(an, ao)
                    am.Set(ao)
                    ak.Code = ao
                end

                function ak.Set(an, ao)
                    return ak.SetCode(ao)
                end

                function ak.Destroy(an)
                    am.Destroy()
                    ak = nil
                end

                ak.ElementFrame = am.CodeFrame

                return ak.__type, ak
            end

            return af
        end
        function WindUIModules.CodeElement(): typeof(buildModule())
            local aa = WindUIModules.cache.CodeElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.CodeElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New
            local ae = aa.Tween

            local af = (cloneref or clonereference or function(af)
                return af
            end)

            local ag = af(game:GetService('UserInputService'))
            af(game:GetService('TouchInputService'))
            local ai = af(game:GetService('RunService'))
            local ak = af(game:GetService('Players'))

            local al = ai.RenderStepped
            local am = ak.LocalPlayer
            local an = am:GetMouse()

            local ao = WindUIModules.NotificationModule().New
            local ap = WindUIModules.PopupModule().New

            local aq = {
                UICorner = 9,
            }

            function aq.Colorpicker(ar, as, at, au)
                local av = {
                    __type = 'Colorpicker',
                    Title = as.Title,
                    Desc = as.Desc,
                    Default = as.Value or as.Default,
                    Callback = as.Callback,
                    Transparency = as.Transparency,
                    UIElements = as.UIElements,

                    TextPadding = 10,
                }

                function av.SetHSVFromRGB(aw, ax)
                    local ay, az, aA = Color3.toHSV(ax)
                    av.Hue = ay
                    av.Sat = az
                    av.Vib = aA
                end

                av:SetHSVFromRGB(av.Default)

                local aw = WindUIModules.DialogModule().Init(at)
                local ax = aw.Create()

                av.ColorpickerFrame = ax

                ax.UIElements.Main.Size = UDim2.new(1, 0, 0, 0)

                local ay, az, aA = av.Hue, av.Sat, av.Vib

                av.UIElements.Title = ad('TextLabel', {
                    Text = av.Title,
                    TextSize = 20,
                    FontFace = Font.new(aa.Font, Enum.FontWeight.SemiBold),
                    TextXAlignment = 'Left',
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    BackgroundTransparency = 1,
                    Parent = ax.UIElements.Main,
                }, {
                    ad('UIPadding', {
                        PaddingTop = UDim.new(0, av.TextPadding / 2),
                        PaddingLeft = UDim.new(0, av.TextPadding / 2),
                        PaddingRight = UDim.new(0, av.TextPadding / 2),
                        PaddingBottom = UDim.new(0, av.TextPadding / 2),
                    }),
                })

                local aB = ad('Frame', {
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Parent = HueDragHolder,
                    BackgroundColor3 = av.Default,
                }, {
                    ad('UIStroke', {
                        Thickness = 2,
                        Transparency = 0.1,
                        ThemeTag = {
                            Color = 'Text',
                        },
                    }),
                    ad('UICorner', {
                        CornerRadius = UDim.new(1, 0),
                    }),
                })

                av.UIElements.SatVibMap = ad('ImageLabel', {
                    Size = UDim2.fromOffset(160, 158),
                    Position = UDim2.fromOffset(0, 40 + av.TextPadding),
                    Image = 'rbxassetid://4155801252',
                    BackgroundColor3 = Color3.fromHSV(ay, 1, 1),
                    BackgroundTransparency = 0,
                    Parent = ax.UIElements.Main,
                }, {
                    ad('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                    aa.NewRoundFrame(8, 'SquircleOutline', {
                        ThemeTag = {
                            ImageColor3 = 'Outline',
                        },
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.85,
                        ZIndex = 99999,
                    }, {
                        ad('UIGradient', {
                            Rotation = 45,
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
                            }),
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0.0, 0.1),
                                NumberSequenceKeypoint.new(0.5, 1),
                                NumberSequenceKeypoint.new(1.0, 0.1),
                            }),
                        }),
                    }),

                    aB,
                })

                av.UIElements.Inputs = ad('Frame', {
                    AutomaticSize = 'XY',
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.fromOffset(av.Transparency and 240 or 210, 40 + av.TextPadding),
                    BackgroundTransparency = 1,
                    Parent = ax.UIElements.Main,
                }, {
                    ad('UIListLayout', {
                        Padding = UDim.new(0, 4),
                        FillDirection = 'Vertical',
                    }),
                })

                local b = ad('Frame', {
                    BackgroundColor3 = av.Default,
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = av.Transparency,
                }, {
                    ad('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                })

                ad('ImageLabel', {
                    Image = 'http://www.roblox.com/asset/?id=14204231522',
                    ImageTransparency = 0.45,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.fromOffset(40, 40),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(85, 208 + av.TextPadding),
                    Size = UDim2.fromOffset(75, 24),
                    Parent = ax.UIElements.Main,
                }, {
                    ad('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                    aa.NewRoundFrame(8, 'SquircleOutline', {
                        ThemeTag = {
                            ImageColor3 = 'Outline',
                        },
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.85,
                        ZIndex = 99999,
                    }, {
                        ad('UIGradient', {
                            Rotation = 60,
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
                            }),
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0.0, 0.1),
                                NumberSequenceKeypoint.new(0.5, 1),
                                NumberSequenceKeypoint.new(1.0, 0.1),
                            }),
                        }),
                    }),

                    b,
                })

                local d = ad('Frame', {
                    BackgroundColor3 = av.Default,
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 0,
                    ZIndex = 9,
                }, {
                    ad('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                })

                ad('ImageLabel', {
                    Image = 'http://www.roblox.com/asset/?id=14204231522',
                    ImageTransparency = 0.45,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.fromOffset(40, 40),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 208 + av.TextPadding),
                    Size = UDim2.fromOffset(75, 24),
                    Parent = ax.UIElements.Main,
                }, {
                    ad('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),

                    aa.NewRoundFrame(8, 'SquircleOutline', {
                        ThemeTag = {
                            ImageColor3 = 'Outline',
                        },
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.85,
                        ZIndex = 99999,
                    }, {
                        ad('UIGradient', {
                            Rotation = 60,
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
                            }),
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0.0, 0.1),
                                NumberSequenceKeypoint.new(0.5, 1),
                                NumberSequenceKeypoint.new(1.0, 0.1),
                            }),
                        }),
                    }),
                    d,
                })

                local f = {}

                for g = 0, 1, 0.1 do
                    table.insert(f, ColorSequenceKeypoint.new(g, Color3.fromHSV(g, 1, 1)))
                end

                local g = ad('UIGradient', {
                    Color = ColorSequence.new(f),
                    Rotation = 90,
                })

                local h = ad('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                })

                local j = ad('Frame', {
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Parent = h,

                    BackgroundColor3 = av.Default,
                }, {
                    ad('UIStroke', {
                        Thickness = 2,
                        Transparency = 0.1,
                        ThemeTag = {
                            Color = 'Text',
                        },
                    }),
                    ad('UICorner', {
                        CornerRadius = UDim.new(1, 0),
                    }),
                })

                local l = ad('Frame', {
                    Size = UDim2.fromOffset(6, 192),
                    Position = UDim2.fromOffset(180, 40 + av.TextPadding),
                    Parent = ax.UIElements.Main,
                }, {
                    ad('UICorner', {
                        CornerRadius = UDim.new(1, 0),
                    }),
                    g,
                    h,
                })

                function CreateNewInput(m, p)
                    local r = ap(m, nil, av.UIElements.Inputs)

                    ad('TextLabel', {
                        BackgroundTransparency = 1,
                        TextTransparency = 0.4,
                        TextSize = 17,
                        FontFace = Font.new(aa.Font, Enum.FontWeight.Regular),
                        AutomaticSize = 'XY',
                        ThemeTag = {
                            TextColor3 = 'Placeholder',
                        },
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -12, 0.5, 0),
                        Parent = r.Frame,
                        Text = m,
                    })

                    ad('UIScale', {
                        Parent = r,
                        Scale = 0.85,
                    })

                    r.Frame.Frame.TextBox.Text = p
                    r.Size = UDim2.new(0, 150, 0, 42)

                    return r
                end

                local function ToRGB(m)
                    return {
                        R = math.floor(m.R * 255),
                        G = math.floor(m.G * 255),
                        B = math.floor(m.B * 255),
                    }
                end

                local m = CreateNewInput('Hex', '#' .. av.Default:ToHex())

                local p = CreateNewInput('Red', ToRGB(av.Default).R)
                local r = CreateNewInput('Green', ToRGB(av.Default).G)
                local u = CreateNewInput('Blue', ToRGB(av.Default).B)
                local v
                if av.Transparency then
                    v = CreateNewInput('Alpha', ((1 - av.Transparency) * 100) .. '%')
                end

                local x = ad('Frame', {
                    Size = UDim2.new(1, 0, 0, 40),
                    AutomaticSize = 'Y',
                    Position = UDim2.new(0, 0, 0, 254 + av.TextPadding),
                    BackgroundTransparency = 1,
                    Parent = ax.UIElements.Main,
                    LayoutOrder = 4,
                }, {
                    ad('UIListLayout', {
                        Padding = UDim.new(0, 6),
                        FillDirection = 'Horizontal',
                        HorizontalAlignment = 'Right',
                    }),
                })

                local z = {
                    {
                        Title = 'Cancel',
                        Variant = 'Secondary',
                        Callback = function() end,
                    },
                    {
                        Title = 'Apply',
                        Icon = 'chevron-right',
                        Variant = 'Primary',
                        Callback = function()
                            au(Color3.fromHSV(av.Hue, av.Sat, av.Vib), av.Transparency)
                        end,
                    },
                }

                for A, B in next, z do
                    local C = ao(B.Title, B.Icon, B.Callback, B.Variant, x, ax, false)
                    C.Size = UDim2.new(0.5, -3, 0, 40)
                    C.AutomaticSize = 'None'
                end

                local A, B, C
                if av.Transparency then
                    local F = ad('Frame', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Position = UDim2.fromOffset(0, 0),
                        BackgroundTransparency = 1,
                    })

                    B = ad('ImageLabel', {
                        Size = UDim2.new(0, 14, 0, 14),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0, 0),
                        ThemeTag = {
                            BackgroundColor3 = 'Text',
                        },
                        Parent = F,
                    }, {
                        ad('UIStroke', {
                            Thickness = 2,
                            Transparency = 0.1,
                            ThemeTag = {
                                Color = 'Text',
                            },
                        }),
                        ad('UICorner', {
                            CornerRadius = UDim.new(1, 0),
                        }),
                    })

                    C = ad('Frame', {
                        Size = UDim2.fromScale(1, 1),
                    }, {
                        ad('UIGradient', {
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0),
                                NumberSequenceKeypoint.new(1, 1),
                            }),
                            Rotation = 270,
                        }),
                        ad('UICorner', {
                            CornerRadius = UDim.new(0, 6),
                        }),
                    })

                    A = ad('Frame', {
                        Size = UDim2.fromOffset(6, 192),
                        Position = UDim2.fromOffset(210, 40 + av.TextPadding),
                        Parent = ax.UIElements.Main,
                        BackgroundTransparency = 1,
                    }, {
                        ad('UICorner', {
                            CornerRadius = UDim.new(1, 0),
                        }),
                        ad('ImageLabel', {
                            Image = 'rbxassetid://14204231522',
                            ImageTransparency = 0.45,
                            ScaleType = Enum.ScaleType.Tile,
                            TileSize = UDim2.fromOffset(40, 40),
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(1, 1),
                        }, {
                            ad('UICorner', {
                                CornerRadius = UDim.new(1, 0),
                            }),
                        }),
                        C,
                        F,
                    })
                end

                function av.Round(F, G, H)
                    if H == 0 then
                        return math.floor(G)
                    end
                    G = tostring(G)
                    return G:find('%.') and tonumber(G:sub(1, G:find('%.') + H)) or G
                end

                function av.Update(F, G, H)
                    if G then
                        ay, az, aA = Color3.toHSV(G)
                    else
                        ay, az, aA = av.Hue, av.Sat, av.Vib
                    end

                    av.UIElements.SatVibMap.BackgroundColor3 = Color3.fromHSV(ay, 1, 1)
                    aB.Position = UDim2.new(az, 0, 1 - aA, 0)
                    aB.BackgroundColor3 = Color3.fromHSV(ay, az, aA)
                    d.BackgroundColor3 = Color3.fromHSV(ay, az, aA)
                    j.BackgroundColor3 = Color3.fromHSV(ay, 1, 1)
                    j.Position = UDim2.new(0.5, 0, ay, 0)

                    m.Frame.Frame.TextBox.Text = '#' .. Color3.fromHSV(ay, az, aA):ToHex()
                    p.Frame.Frame.TextBox.Text = ToRGB(Color3.fromHSV(ay, az, aA)).R
                    r.Frame.Frame.TextBox.Text = ToRGB(Color3.fromHSV(ay, az, aA)).G
                    u.Frame.Frame.TextBox.Text = ToRGB(Color3.fromHSV(ay, az, aA)).B

                    local J = av.Transparency
                    if typeof(J) ~= 'number' then
                        J = H
                    end

                    if typeof(J) == 'number' then
                        d.BackgroundTransparency = J
                        C.BackgroundColor3 = Color3.fromHSV(ay, az, aA)
                        B.BackgroundColor3 = Color3.fromHSV(ay, az, aA)
                        B.BackgroundTransparency = J
                        B.Position = UDim2.new(0.5, 0, 1 - J, 0)
                        v.Frame.Frame.TextBox.Text = av:Round((1 - J) * 100, 0) .. '%'
                    end
                end

                av:Update(av.Default, av.Transparency)

                local function GetRGB()
                    local F = Color3.fromHSV(av.Hue, av.Sat, av.Vib)
                    return { R = math.floor(F.r * 255), G = math.floor(F.g * 255), B = math.floor(F.b * 255) }
                end

                local function clamp(F, G, H)
                    return math.clamp(tonumber(F) or 0, G, H)
                end

                aa.AddSignal(m.Frame.Frame.TextBox.FocusLost, function(F)
                    if F then
                        local G = m.Frame.Frame.TextBox.Text:gsub('#', '')
                        local H, J = pcall(Color3.fromHex, G)
                        if H and typeof(J) == 'Color3' then
                            av.Hue, av.Sat, av.Vib = Color3.toHSV(J)
                            av:Update()
                            av.Default = J
                        end
                    end
                end)

                local function updateColorFromInput(F, G)
                    aa.AddSignal(F.Frame.Frame.TextBox.FocusLost, function(H)
                        if H then
                            local J = F.Frame.Frame.TextBox
                            local L = GetRGB()
                            local M = clamp(J.Text, 0, 255)
                            J.Text = tostring(M)

                            L[G] = M
                            local N = Color3.fromRGB(L.R, L.G, L.B)
                            av.Hue, av.Sat, av.Vib = Color3.toHSV(N)
                            av:Update()
                        end
                    end)
                end

                updateColorFromInput(p, 'R')
                updateColorFromInput(r, 'G')
                updateColorFromInput(u, 'B')

                if av.Transparency then
                    aa.AddSignal(v.Frame.Frame.TextBox.FocusLost, function(F)
                        if F then
                            local G = v.Frame.Frame.TextBox
                            local H = clamp(G.Text, 0, 100)
                            G.Text = tostring(H)

                            av.Transparency = 1 - H * 0.01
                            av:Update(nil, av.Transparency)
                        end
                    end)
                end

                local F = av.UIElements.SatVibMap
                aa.AddSignal(F.InputBegan, function(G)
                    if
                        G.UserInputType == Enum.UserInputType.MouseButton1
                        or G.UserInputType == Enum.UserInputType.Touch
                    then
                        while ag:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            local H = F.AbsolutePosition.X
                            local J = H + F.AbsoluteSize.X
                            local L = math.clamp(an.X, H, J)

                            local M = F.AbsolutePosition.Y
                            local N = M + F.AbsoluteSize.Y
                            local O = math.clamp(an.Y, M, N)

                            av.Sat = (L - H) / (J - H)
                            av.Vib = 1 - ((O - M) / (N - M))
                            av:Update()

                            al:Wait()
                        end
                    end
                end)

                aa.AddSignal(l.InputBegan, function(G)
                    if
                        G.UserInputType == Enum.UserInputType.MouseButton1
                        or G.UserInputType == Enum.UserInputType.Touch
                    then
                        while ag:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            local H = l.AbsolutePosition.Y
                            local J = H + l.AbsoluteSize.Y
                            local L = math.clamp(an.Y, H, J)

                            av.Hue = ((L - H) / (J - H))
                            av:Update()

                            al:Wait()
                        end
                    end
                end)

                if av.Transparency then
                    aa.AddSignal(A.InputBegan, function(G)
                        if
                            G.UserInputType == Enum.UserInputType.MouseButton1
                            or G.UserInputType == Enum.UserInputType.Touch
                        then
                            while ag:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local H = A.AbsolutePosition.Y
                                local J = H + A.AbsoluteSize.Y
                                local L = math.clamp(an.Y, H, J)

                                av.Transparency = 1 - ((L - H) / (J - H))
                                av:Update()

                                al:Wait()
                            end
                        end
                    end)
                end

                return av
            end

            function aq.New(ar, as)
                local at = {
                    __type = 'Colorpicker',
                    Title = as.Title or 'Colorpicker',
                    Desc = as.Desc or nil,
                    Locked = as.Locked or false,
                    LockedTitle = as.LockedTitle,
                    Default = as.Default or Color3.new(1, 1, 1),
                    Callback = as.Callback or function() end,

                    UIScale = as.UIScale,
                    Transparency = as.Transparency,
                    UIElements = {},
                }

                local au = true

                at.ColorpickerFrame = WindUIModules.ElementFrameModule()({
                    Title = at.Title,
                    Desc = at.Desc,
                    Parent = as.Parent,
                    TextOffset = 40,
                    Hover = false,
                    Tab = as.Tab,
                    Index = as.Index,
                    Window = as.Window,
                    ElementTable = at,
                    ParentConfig = as,
                })

                at.UIElements.Colorpicker = aa.NewRoundFrame(aq.UICorner, 'Squircle', {
                    ImageTransparency = 0,
                    Active = true,
                    ImageColor3 = at.Default,
                    Parent = at.ColorpickerFrame.UIElements.Main,
                    Size = UDim2.new(0, 26, 0, 26),
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    ZIndex = 2,
                }, nil, true)

                function at.Lock(av)
                    at.Locked = true
                    au = false
                    return at.ColorpickerFrame:Lock(at.LockedTitle)
                end
                function at.Unlock(av)
                    at.Locked = false
                    au = true
                    return at.ColorpickerFrame:Unlock()
                end

                if at.Locked then
                    at:Lock()
                end

                function at.Update(av, aw, ax)
                    at.UIElements.Colorpicker.ImageTransparency = ax or 0
                    at.UIElements.Colorpicker.ImageColor3 = aw
                    at.Default = aw
                    if ax then
                        at.Transparency = ax
                    end
                end

                function at.Set(av, aw, ax)
                    return at:Update(aw, ax)
                end

                aa.AddSignal(at.UIElements.Colorpicker.MouseButton1Click, function()
                    if au then
                        aq:Colorpicker(at, as.Window, function(av, aw)
                            at:Update(av, aw)
                            at.Default = av
                            at.Transparency = aw
                            aa.SafeCallback(at.Callback, av, aw)
                        end).ColorpickerFrame
                            :Open()
                    end
                end)

                return at.__type, at
            end

            return aq
        end
        function WindUIModules.ColorpickerElement(): typeof(buildModule())
            local aa = WindUIModules.cache.ColorpickerElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ColorpickerElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New
            local ae = aa.Tween

            local af = {}

            local function ResolveRange(ag)
                local ai = 0
                local ak = 100
                local al = 0

                if typeof(ag) == 'table' then
                    ai = tonumber(ag.Min) or ai
                    ak = tonumber(ag.Max) or ak
                    al = tonumber(ag.Default) or al
                elseif typeof(ag) == 'number' then
                    al = ag
                end

                if ak <= ai then
                    ak = ai + 1
                end

                al = math.clamp(al, ai, ak)
                return ai, ak, al
            end

            local function ResolveColor(ag)
                if typeof(ag) == 'Color3' then
                    return ag
                end

                if typeof(ag) ~= 'string' then
                    return nil
                end

                if string.sub(ag, 1, 1) == '#' then
                    return Color3.fromHex(ag)
                end

                if aa.Colors[ag] then
                    return Color3.fromHex(aa.Colors[ag])
                end

                return nil
            end

            local function ClampPrecision(ag)
                local ai = tonumber(ag)
                if not ai then
                    return 0
                end
                return math.clamp(math.floor(ai), 0, 4)
            end

            function af.New(ag, ai)
                local ak, al, am = ResolveRange(ai.Value)
                local an = typeof(ai.ValueWidth) == 'number' and math.max(math.floor(ai.ValueWidth), 45) or 96

                local ao = {
                    __type = 'Progress',
                    Title = ai.Title or 'Progress',
                    Desc = ai.Desc,
                    Locked = ai.Locked or false,
                    LockedTitle = ai.LockedTitle,
                    Min = ak,
                    Max = al,
                    Value = am,
                    ShowValue = ai.ShowValue ~= false,
                    Precision = ClampPrecision(ai.Precision),
                    Prefix = tostring(ai.Prefix or ''),
                    Suffix = tostring(ai.Suffix or ''),
                    Format = ai.Format,
                    Color = ai.Color,
                    Callback = ai.Callback or function() end,
                    UIElements = {},
                }

                local ap = true

                ao.ProgressFrame = WindUIModules.ElementFrameModule()({
                    Title = ao.Title,
                    Desc = ao.Desc,
                    Parent = ai.Parent,
                    TextOffset = ao.ShowValue and (an + 16) or 20,
                    Hover = false,
                    Tab = ai.Tab,
                    Index = ai.Index,
                    Window = ai.Window,
                    ElementTable = ao,
                    ParentConfig = ai,
                })

                local aq = ad('TextLabel', {
                    Name = 'ValueLabel',
                    BackgroundTransparency = 1,
                    AutomaticSize = 'Y',
                    Size = UDim2.new(0, an, 0, 0),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    TextXAlignment = 'Right',
                    FontFace = Font.new(aa.Font, Enum.FontWeight.Medium),
                    TextSize = 15,
                    TextTransparency = 0.3,
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    Visible = ao.ShowValue,
                    Parent = ao.ProgressFrame.UIElements.Main,
                })

                local ar = typeof(ai.BarHeight) == 'number' and math.max(math.floor(ai.BarHeight), 4) or 8
                local as = math.max(ai.Window.ElementConfig.UICorner - 6, 4)

                local at = ad('Frame', {
                    Name = 'BarContainer',
                    Size = UDim2.new(1, 0, 0, ar),
                    BackgroundTransparency = 1,
                    Parent = ao.ProgressFrame.UIElements.Container,
                })

                local au = aa.NewRoundFrame(as, 'Squircle', {
                    Name = 'Track',
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 0.92,
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    Parent = at,
                })

                local av = aa.NewRoundFrame(as, 'Squircle', {
                    Name = 'Fill',
                    Size = UDim2.new(0, 0, 1, 0),
                    ImageTransparency = 0.08,
                    ThemeTag = {
                        ImageColor3 = 'Slider',
                    },
                    Parent = au,
                })

                aa.NewRoundFrame(as, 'Glass-1.4', {
                    Name = 'FillOverlay',
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 0.7,
                    ThemeTag = {
                        ImageColor3 = 'White',
                    },
                    Parent = av,
                })

                ao.UIElements.ValueLabel = aq
                ao.UIElements.BarContainer = at
                ao.UIElements.Track = au
                ao.UIElements.Fill = av

                local function SetThemeBinding(aw, ax)
                    local ay = aa.Objects[av]
                    if not ay then
                        aa.AddThemeObject(av, {})
                        ay = aa.Objects[av]
                    end

                    if ay and ay.Properties then
                        ay.Properties[aw] = ax
                        aa.UpdateTheme(av, false)
                    end
                end

                local function ClearThemeBinding(aw)
                    local ax = aa.Objects[av]
                    if ax and ax.Properties then
                        ax.Properties[aw] = nil
                    end
                end

                local function ApplyFillColor(aw)
                    local ax = ResolveColor(aw)
                    if ax then
                        ClearThemeBinding('ImageColor3')
                        av.ImageColor3 = ax
                        return
                    end

                    if typeof(aw) == 'string' and aw ~= '' then
                        SetThemeBinding('ImageColor3', aw)
                        return
                    end

                    SetThemeBinding('ImageColor3', 'Slider')
                end

                local function GetPercent()
                    local aw = ao.Max - ao.Min
                    if aw <= 0 then
                        return 0
                    end
                    return math.clamp((ao.Value - ao.Min) / aw, 0, 1)
                end

                local function FormatNumber(aw)
                    if ao.Precision <= 0 then
                        return tostring(math.floor(aw + 0.5))
                    end
                    return string.format('%.' .. tostring(ao.Precision) .. 'f', aw)
                end

                local function BuildValueText()
                    if typeof(ao.Format) == 'function' then
                        local aw, ax = pcall(ao.Format, ao.Value, ao.Min, ao.Max, GetPercent(), ao)
                        if aw and ax ~= nil then
                            return tostring(ax)
                        end
                    end

                    return ao.Prefix .. FormatNumber(ao.Value) .. ao.Suffix
                end

                local function UpdateVisual(aw)
                    local ax = GetPercent()
                    local ay = UDim2.new(ax, 0, 1, 0)

                    if aw then
                        ae(av, 0.18, {
                            Size = ay,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    else
                        av.Size = ay
                    end

                    aq.Visible = ao.ShowValue
                    if ao.ShowValue then
                        aq.Text = BuildValueText()
                    end
                end

                local function FireCallback()
                    if ap then
                        aa.SafeCallback(ao.Callback, ao.Value, GetPercent(), ao)
                    end
                end

                function ao.GetPercent(aw)
                    return GetPercent()
                end

                function ao.GetValue(aw)
                    return ao.Value
                end

                function ao.SetFormat(aw, ax)
                    ao.Format = ax
                    UpdateVisual(false)
                    return ao
                end

                function ao.SetPrefix(aw, ax)
                    ao.Prefix = tostring(ax or '')
                    UpdateVisual(false)
                    return ao
                end

                function ao.SetSuffix(aw, ax)
                    ao.Suffix = tostring(ax or '')
                    UpdateVisual(false)
                    return ao
                end

                function ao.SetShowValue(aw, ax)
                    ao.ShowValue = ax ~= false
                    UpdateVisual(false)
                    return ao
                end

                function ao.SetColor(aw, ax)
                    ao.Color = ax
                    ApplyFillColor(ax)
                    return ao
                end

                function ao.SetRange(aw, ax, ay, az)
                    local aA = tonumber(ax)
                    local aB = tonumber(ay)
                    if not aA or not aB then
                        return ao
                    end

                    if aB <= aA then
                        aB = aA + 1
                    end

                    local b = GetPercent()
                    ao.Min = aA
                    ao.Max = aB

                    if az == true then
                        ao.Value = aA + ((aB - aA) * b)
                    else
                        ao.Value = math.clamp(ao.Value, aA, aB)
                    end

                    UpdateVisual(false)
                    return ao
                end

                function ao.Set(aw, ax, ay, az)
                    local aA = tonumber(ax)
                    if not aA then
                        return ao
                    end

                    local aB = math.clamp(aA, ao.Min, ao.Max)
                    local b = aB ~= ao.Value

                    ao.Value = aB
                    UpdateVisual(az ~= false)

                    if b and ay ~= false then
                        FireCallback()
                    end

                    return ao
                end

                function ao.Add(aw, ax, ay, az)
                    local aA = tonumber(ax) or 0
                    return ao:Set(ao.Value + aA, ay, az)
                end
                ao.Increment = ao.Add

                function ao.Lock(aw)
                    ao.Locked = true
                    ap = false
                    return ao.ProgressFrame:Lock(ao.LockedTitle)
                end

                function ao.Unlock(aw)
                    ao.Locked = false
                    ap = true
                    return ao.ProgressFrame:Unlock()
                end

                if ao.Locked then
                    ao:Lock()
                end

                ApplyFillColor(ao.Color)
                ao:Set(ao.Value, false, false)

                return ao.__type, ao
            end

            return af
        end
        function WindUIModules.ProgressElement(): typeof(buildModule())
            local aa = WindUIModules.cache.ProgressElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ProgressElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New

            local ae = {}

            local function ResolveColor(af)
                if typeof(af) == 'Color3' then
                    return af
                end

                if typeof(af) ~= 'string' then
                    return nil
                end

                if string.sub(af, 1, 1) == '#' then
                    return Color3.fromHex(af)
                end

                if aa.Colors[af] then
                    return Color3.fromHex(aa.Colors[af])
                end

                local ag = aa.GetThemeProperty(af, aa.Theme)
                if typeof(ag) == 'Color3' then
                    return ag
                end

                return nil
            end

            local function NormalizeItems(af)
                local ag = {}
                if typeof(af) ~= 'table' then
                    return ag
                end

                if #af > 0 then
                    for ai, ak in ipairs(af) do
                        if typeof(ak) == 'table' then
                            local al = ak.Key or ak.Label or ak.Title or ak.Name
                            if al ~= nil then
                                table.insert(ag, {
                                    Key = tostring(al),
                                    Value = ak.Value,
                                    Color = ak.Color,
                                })
                            end
                        elseif ak ~= nil then
                            table.insert(ag, {
                                Key = tostring(ak),
                                Value = '',
                            })
                        end
                    end
                else
                    for ai, ak in next, af do
                        table.insert(ag, {
                            Key = tostring(ai),
                            Value = ak,
                        })
                    end

                    table.sort(ag, function(ai, ak)
                        return string.lower(ai.Key) < string.lower(ak.Key)
                    end)
                end

                return ag
            end

            function ae.New(af, ag)
                local ai = NormalizeItems(ag.Items or ag.Values or {})
                local ak = typeof(ag.RowHeight) == 'number' and math.max(math.floor(ag.RowHeight), 18) or 21
                local al = typeof(ag.ValueWidth) == 'number' and math.max(math.floor(ag.ValueWidth), 70) or 128

                local am = {
                    __type = 'Stats',
                    Title = ag.Title or 'Stats',
                    Desc = ag.Desc,
                    Locked = ag.Locked or false,
                    LockedTitle = ag.LockedTitle,
                    Items = ai,
                    RowHeight = ak,
                    ValueWidth = al,
                    ValueColor = ag.ValueColor,
                    Callback = ag.Callback or function() end,
                    UIElements = {},
                }

                local an = true
                local ao = {}

                am.StatsFrame = WindUIModules.ElementFrameModule()({
                    Title = am.Title,
                    Desc = am.Desc,
                    Parent = ag.Parent,
                    TextOffset = 20,
                    Hover = false,
                    Tab = ag.Tab,
                    Index = ag.Index,
                    Window = ag.Window,
                    ElementTable = am,
                    ParentConfig = ag,
                })

                local ap = ad('Frame', {
                    Name = 'RowsContainer',
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                    Parent = am.StatsFrame.UIElements.Container,
                }, {
                    ad('UIListLayout', {
                        FillDirection = 'Vertical',
                        Padding = UDim.new(0, 4),
                        VerticalAlignment = 'Top',
                    }),
                })

                am.UIElements.RowsContainer = ap

                local function FireCallback()
                    if an then
                        aa.SafeCallback(am.Callback, am.Items, am)
                    end
                end

                local function CreateRow(aq)
                    local ar = aq.Value == nil and '' or tostring(aq.Value)
                    local as = ResolveColor(aq.Color or am.ValueColor)

                    local at = ad('Frame', {
                        Name = aq.Key,
                        Size = UDim2.new(1, 0, 0, am.RowHeight),
                        BackgroundTransparency = 1,
                        Parent = ap,
                    }, {
                        ad('TextLabel', {
                            Name = 'Key',
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, -am.ValueWidth, 1, 0),
                            Text = aq.Key,
                            TextXAlignment = 'Left',
                            TextYAlignment = 'Center',
                            FontFace = Font.new(aa.Font, Enum.FontWeight.Medium),
                            TextSize = 15,
                            TextTransparency = 0.35,
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                        }),
                        ad('TextLabel', {
                            Name = 'Value',
                            BackgroundTransparency = 1,
                            Position = UDim2.new(1, 0, 0, 0),
                            AnchorPoint = Vector2.new(1, 0),
                            Size = UDim2.new(0, am.ValueWidth, 1, 0),
                            Text = ar,
                            TextXAlignment = 'Right',
                            TextYAlignment = 'Center',
                            FontFace = Font.new(aa.Font, Enum.FontWeight.SemiBold),
                            TextSize = 15,
                            ThemeTag = not as and {
                                TextColor3 = 'Text',
                            } or nil,
                            TextColor3 = as,
                        }),
                    })

                    return at
                end

                local function RenderRows()
                    for aq, ar in next, ao do
                        ar:Destroy()
                    end
                    ao = {}

                    for aq, ar in ipairs(am.Items) do
                        table.insert(ao, CreateRow(ar))
                    end
                end

                local function CloneItems()
                    local aq = {}
                    for ar, as in ipairs(am.Items) do
                        aq[#aq + 1] = table.clone(as)
                    end
                    return aq
                end

                function am.Set(aq, ar, as)
                    am.Items = NormalizeItems(ar)
                    RenderRows()

                    if as ~= true then
                        FireCallback()
                    end

                    return am
                end

                function am.Update(aq, ar, as, at)
                    local au = ar ~= nil and tostring(ar) or ''
                    if au == '' then
                        return am
                    end

                    local av = false
                    for aw, ax in ipairs(am.Items) do
                        if ax.Key == au then
                            ax.Value = as
                            av = true
                            break
                        end
                    end

                    if not av then
                        table.insert(am.Items, {
                            Key = au,
                            Value = as,
                        })
                    end

                    RenderRows()
                    if at ~= true then
                        FireCallback()
                    end

                    return am
                end

                function am.Remove(aq, ar, as)
                    local at = ar ~= nil and tostring(ar) or ''
                    if at == '' then
                        return am
                    end

                    for au = #am.Items, 1, -1 do
                        if am.Items[au].Key == at then
                            table.remove(am.Items, au)
                        end
                    end

                    RenderRows()
                    if as ~= true then
                        FireCallback()
                    end

                    return am
                end

                function am.Clear(aq, ar)
                    am.Items = {}
                    RenderRows()

                    if ar ~= true then
                        FireCallback()
                    end

                    return am
                end

                function am.Get(aq, ar)
                    local as = ar ~= nil and tostring(ar) or ''
                    if as == '' then
                        return nil
                    end

                    for at, au in ipairs(am.Items) do
                        if au.Key == as then
                            return au.Value
                        end
                    end

                    return nil
                end

                function am.GetItems(aq)
                    return CloneItems()
                end

                function am.SetValueColor(aq, ar)
                    am.ValueColor = ar
                    RenderRows()
                    return am
                end

                function am.Lock(aq)
                    am.Locked = true
                    an = false
                    return am.StatsFrame:Lock(am.LockedTitle)
                end

                function am.Unlock(aq)
                    am.Locked = false
                    an = true
                    return am.StatsFrame:Unlock()
                end

                function am.Destroy(aq)
                    if am.StatsFrame and am.StatsFrame.Destroy then
                        am.StatsFrame:Destroy()
                        am.StatsFrame = nil
                    end
                end

                if am.Locked then
                    am:Lock()
                end

                RenderRows()

                return am.__type, am
            end

            return ae
        end
        function WindUIModules.StatsElement(): typeof(buildModule())
            local aa = WindUIModules.cache.StatsElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.StatsElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New
            local ae = aa.Tween

            local af = {}

            local function IsPressInput(ag)
                return ag.UserInputType == Enum.UserInputType.MouseButton1
                    or ag.UserInputType == Enum.UserInputType.Touch
            end

            function af.New(ag, ai)
                local ak = {
                    __type = 'Section',
                    Title = ai.Title or 'Section',
                    Desc = ai.Desc,
                    Icon = ai.Icon,
                    TextXAlignment = ai.TextXAlignment or 'Left',
                    TextSize = ai.TextSize or 19,
                    DescTextSize = ai.DescTextSize or 16,
                    Box = ai.Box or false,
                    BoxBorder = ai.BoxBorder or false,
                    FontWeight = ai.FontWeight or Enum.FontWeight.SemiBold,
                    DescFontWeight = ai.DescFontWeight or Enum.FontWeight.Medium,
                    TextTransparency = ai.TextTransparency or 0.05,
                    DescTextTransparency = ai.DescTextTransparency or 0.4,
                    HoverFeedback = ai.Hover ~= false,
                    Opened = ai.Opened or false,
                    Locked = ai.Locked or false,
                    LockedTitle = ai.LockedTitle,
                    UIElements = {},

                    HeaderSize = ai.HeaderSize or 42,
                    IconSize = ai.IconSize or 20,
                    HeaderGap = ai.HeaderGap or 10,
                    HeaderPaddingX = ai.HeaderPaddingX
                        or (ai.Window.ElementConfig.UIPadding + (ai.Window.ModernLayout and 4 or 2)),
                    HeaderPaddingY = ai.HeaderPaddingY
                        or math.max(
                            math.floor((ai.Window.ElementConfig.UIPadding + (ai.Window.ModernLayout and 4 or 0)) * 0.65),
                            6
                        ),

                    Elements = {},

                    Expandable = false,
                }

                local al
                local am = false
                local an = false

                local function GetUIScale()
                    local ao = tonumber((ai.WindUI and ai.WindUI.UIScale) or ai.UIScale) or 1
                    if ao <= 0 then
                        return 1
                    end
                    return ao
                end

                local function ToLayoutOffset(ao)
                    return ao / GetUIScale()
                end

                local ao = ad('Frame', {
                    Size = UDim2.new(0, ak.IconSize + 10, 0, ak.IconSize + 10),
                    BackgroundTransparency = 1,
                    Visible = false,
                })

                local function createTitle(ap, aq)
                    return ad('TextLabel', {
                        BackgroundTransparency = 1,
                        TextXAlignment = ak.TextXAlignment,
                        AutomaticSize = 'Y',
                        TextSize = aq and ak.DescTextSize or ak.TextSize,
                        TextTransparency = aq and ak.DescTextTransparency or ak.TextTransparency,
                        ThemeTag = {
                            TextColor3 = aq and 'SectionDesc' or 'SectionTitle',
                        },
                        FontFace = Font.new(aa.Font, aq and ak.DescFontWeight or ak.FontWeight),
                        Text = ap,
                        Size = UDim2.new(1, 0, 0, 0),
                        TextWrapped = true,
                    })
                end

                local ap = ad('Frame', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                }, {
                    ad('UIListLayout', {
                        FillDirection = 'Vertical',
                        HorizontalAlignment = ak.TextXAlignment,
                        VerticalAlignment = 'Center',
                        Padding = UDim.new(0, 4),
                    }),
                })

                local aq = createTitle(ak.Title, false)
                aq.Parent = ap

                local ar
                if ak.Desc and ak.Desc ~= '' then
                    ar = createTitle(ak.Desc, true)
                    ar.Parent = ap
                end

                local as = ad('Frame', {
                    Size = UDim2.new(0, ak.IconSize, 0, ak.IconSize),
                    BackgroundTransparency = 1,
                    Visible = false,
                }, {
                    ad('ImageLabel', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Image = aa.Icon('chevron-down')[1],
                        ImageRectSize = aa.Icon('chevron-down')[2].ImageRectSize,
                        ImageRectOffset = aa.Icon('chevron-down')[2].ImageRectPosition,
                        ThemeTag = {
                            ImageTransparency = 'SectionExpandIconTransparency',
                            ImageColor3 = 'SectionExpandIcon',
                        },
                    }),
                })

                local at = ad('Frame', {
                    Size = UDim2.new(0, 0, 0, ak.IconSize),
                    AutomaticSize = 'X',
                    BackgroundTransparency = 1,
                }, {
                    ad('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Right',
                        Padding = UDim.new(0, 6),
                    }),
                    as,
                })

                local au = ad('Frame', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                }, {
                    ad('UIListLayout', {
                        Padding = UDim.new(0, ak.HeaderGap),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Left',
                    }),
                    ao,
                    ap,
                    at,
                })

                local av = aa.NewRoundFrame(ai.Window.ElementConfig.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = ai.Parent,
                    ClipsDescendants = true,
                    AutomaticSize = 'Y',
                    ThemeTag = ak.Box and {
                        ImageTransparency = 'SectionBoxBackgroundTransparency',
                        ImageColor3 = 'SectionBoxBackground',
                    } or nil,
                    ImageTransparency = not ak.Box and 1 or nil,
                }, {
                    aa.NewRoundFrame(
                        ai.Window.ElementConfig.UICorner,
                        ai.Window.ModernLayout and 'Glass-1' or 'SquircleOutline',
                        {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 1, 0),
                            ThemeTag = {
                                ImageTransparency = 'SectionBoxBorderTransparency',
                                ImageColor3 = 'SectionBoxBorder',
                            },
                            Visible = ak.Box and ak.BoxBorder,
                            Name = 'Outline',
                        }
                    ),
                    ad('TextButton', {
                        Name = 'Top',
                        Size = UDim2.new(1, 0, 0, ak.HeaderSize),
                        AutomaticSize = 'Y',
                        BackgroundTransparency = 1,
                        Active = false,
                        AutoButtonColor = false,
                        Text = '',
                        ClipsDescendants = true,
                    }, {
                        ad('UIPadding', {
                            PaddingTop = UDim.new(0, ak.HeaderPaddingY),
                            PaddingBottom = UDim.new(0, ak.HeaderPaddingY),
                            PaddingLeft = UDim.new(0, ak.HeaderPaddingX),
                            PaddingRight = UDim.new(0, ak.HeaderPaddingX),
                        }),
                        au,
                    }),
                    ad('Frame', {
                        Name = 'HeaderDivider',
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -(ak.Box and ai.Window.ElementConfig.UIPadding * 2 or 0), 0, 1),
                        Position = UDim2.new(0.5, 0, 0, ak.HeaderSize),
                        AnchorPoint = Vector2.new(0.5, 0),
                        Visible = false,
                        ThemeTag = {
                            BackgroundColor3 = 'SectionContentDivider',
                            BackgroundTransparency = 'SectionContentDividerTransparency',
                        },
                    }),
                    ad('Frame', {
                        Name = 'Content',
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        Visible = false,
                        Position = UDim2.new(0, 0, 0, ak.HeaderSize),
                    }, {
                        ad('UIPadding', {
                            PaddingTop = UDim.new(0, ak.Box and 8 or 4),
                            PaddingLeft = UDim.new(0, ak.Box and ai.Window.ElementConfig.UIPadding or 0),
                            PaddingRight = UDim.new(0, ak.Box and ai.Window.ElementConfig.UIPadding or 0),
                            PaddingBottom = UDim.new(0, ak.Box and ai.Window.ElementConfig.UIPadding or 2),
                        }),
                        ad('UIListLayout', {
                            FillDirection = 'Vertical',
                            Padding = UDim.new(0, ai.Tab.Gap),
                            VerticalAlignment = 'Top',
                        }),
                    }),
                })

                ak.ElementFrame = av
                ak.UIElements = {
                    Main = av,
                    Top = av.Top,
                    Content = av.Content,
                    Icon = ao,
                    Title = aq,
                    Desc = ar,
                    Chevron = as.ImageLabel,
                }

                local function UpdateTitleSize()
                    local aw = ao.Visible and (ToLayoutOffset(ao.AbsoluteSize.X) + ak.HeaderGap) or 0
                    local ax = at.AbsoluteSize.X > 0 and (ToLayoutOffset(at.AbsoluteSize.X) + ak.HeaderGap) or 0
                    ap.Size = UDim2.new(1, -(aw + ax), 0, 0)
                end

                local function UpdateContentLayout()
                    local aw = av.Top.AbsoluteSize.Y / GetUIScale()
                    av.Content.Position = UDim2.new(0, 0, 0, aw)
                    av.HeaderDivider.Position = UDim2.new(0.5, 0, 0, aw)
                end

                local function SetHoverState(aw)
                    if not ak.Box then
                        return
                    end

                    local ax = aa.GetThemeProperty('SectionBoxBackgroundTransparency', aa.Theme)
                    if typeof(ax) ~= 'number' then
                        ax = 0.95
                    end

                    local ay = math.max(ax - 0.04, 0)
                    local az = math.max(ax - 0.1, 0)

                    local aA = ax
                    if an then
                        aA = az
                    elseif am then
                        aA = ay
                    end

                    if aw then
                        av.ImageTransparency = aA
                    else
                        ae(av, 0.12, {
                            ImageTransparency = aA,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end

                local function SetChevronState(aw, ax)
                    local ay = aw and 180 or 0
                    local az = aw and 0.1 or 0.25

                    if ax then
                        as.ImageLabel.Rotation = ay
                        as.ImageLabel.ImageTransparency = az
                    else
                        ae(as.ImageLabel, 0.2, {
                            Rotation = ay,
                            ImageTransparency = az,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end

                local function SyncHeight(aw)
                    if not ak.Expandable then
                        return
                    end

                    UpdateContentLayout()

                    local ax = av.Top.AbsoluteSize.Y
                    local ay = ak.Opened and av.Content.AbsoluteSize.Y or 0
                    local az = (ax + ay) / GetUIScale()

                    local aA = UDim2.new(av.Size.X.Scale, av.Size.X.Offset, 0, az)

                    if aw then
                        av.Size = aA
                    else
                        ae(av, ak.Opened and 0.33 or 0.24, {
                            Size = aA,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end

                    av.HeaderDivider.Visible = ak.Opened and ak.Box and av.Content.AbsoluteSize.Y > 0
                end

                local function EnsureExpandable()
                    if ak.Expandable then
                        return
                    end

                    ak.Expandable = true
                    as.Visible = true
                    av.Top.Active = not ak.Locked
                    av.Content.Visible = true
                    av.AutomaticSize = 'None'

                    UpdateTitleSize()
                    UpdateContentLayout()

                    if ak.Opened then
                        SetChevronState(true, true)
                    else
                        SetChevronState(false, true)
                    end

                    SyncHeight(true)
                end

                function ak.SetIcon(aw, ax)
                    ak.Icon = ax or nil

                    if al then
                        al:Destroy()
                        al = nil
                    end

                    ao.Visible = false

                    if ax then
                        al = aa.Image(
                            ax,
                            ax .. ':' .. ak.Title,
                            0,
                            ai.Window.Folder,
                            ak.__type,
                            true,
                            true,
                            'SectionIcon'
                        )
                        al.Size = UDim2.new(0, ak.IconSize, 0, ak.IconSize)
                        al.Parent = ao
                        al.Position = UDim2.new(0.5, 0, 0.5, 0)
                        al.AnchorPoint = Vector2.new(0.5, 0.5)
                        ao.Visible = true
                    end

                    UpdateTitleSize()
                end

                function ak.SetTitle(aw, ax)
                    ak.Title = ax
                    aq.Text = ax
                end

                function ak.SetDesc(aw, ax)
                    ak.Desc = ax

                    if ax and ax ~= '' then
                        if not ar then
                            ar = createTitle(ax, true)
                            ar.Parent = ap
                            ak.UIElements.Desc = ar
                        end
                        ar.Text = ax
                        ar.Visible = true
                    elseif ar then
                        ar.Visible = false
                        ar.Text = ''
                    end

                    if ak.Expandable then
                        SyncHeight(true)
                    end
                end

                function ak.Lock(aw)
                    ak.Locked = true
                    am = false
                    an = false
                    SetHoverState(true)

                    if ak.Expandable then
                        av.Top.Active = false
                    end

                    for ax, ay in next, ak.Elements do
                        if ay and ay.Lock then
                            ay:Lock()
                        end
                    end

                    return ak
                end

                function ak.Unlock(aw)
                    ak.Locked = false

                    if ak.Expandable then
                        av.Top.Active = true
                    end

                    for ax, ay in next, ak.Elements do
                        if ay and ay.Unlock then
                            ay:Unlock()
                        end
                    end

                    return ak
                end

                function ak.Destroy(aw)
                    for ax = #ak.Elements, 1, -1 do
                        local ay = ak.Elements[ax]
                        if ay and ay.Destroy then
                            ay:Destroy()
                        end
                    end

                    av:Destroy()
                end

                function ak.Open(aw, ax)
                    if ak.Expandable then
                        ak.Opened = true
                        av.Content.Visible = true
                        SetChevronState(true, ax)
                        SyncHeight(ax)
                    end
                end

                function ak.Close(aw, ax)
                    if ak.Expandable then
                        ak.Opened = false
                        SetChevronState(false, ax)
                        SyncHeight(ax)
                    end
                end

                if ak.Icon then
                    ak:SetIcon(ak.Icon)
                end

                local aw = ai.ElementsModule

                aw.Load(ak, av.Content, aw.Elements, ai.Window, ai.WindUI, function(ax)
                    EnsureExpandable()

                    if ak.Locked and ax and ax.Lock then
                        ax:Lock()
                    end

                    if ak.Opened then
                        ak:Open(true)
                    else
                        ak:Close(true)
                    end
                end, aw, ai.UIScale, ai.Tab)

                aa.AddSignal(av.Top:GetPropertyChangedSignal('AbsoluteSize'), function()
                    UpdateTitleSize()
                    UpdateContentLayout()

                    if ak.Expandable then
                        SyncHeight(true)
                    end
                end)

                aa.AddSignal(at:GetPropertyChangedSignal('AbsoluteSize'), function()
                    UpdateTitleSize()
                end)

                aa.AddSignal(av.Content.UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'), function()
                    if ak.Expandable then
                        SyncHeight(true)
                    end
                end)

                aa.AddSignal(av.Top.MouseEnter, function()
                    if not ak.HoverFeedback or ak.Locked then
                        return
                    end

                    am = true
                    SetHoverState(false)
                end)

                aa.AddSignal(av.Top.MouseLeave, function()
                    am = false
                    an = false
                    SetHoverState(false)
                end)

                aa.AddSignal(av.Top.InputBegan, function(ax)
                    if not ak.HoverFeedback or ak.Locked or not IsPressInput(ax) then
                        return
                    end

                    an = true
                    SetHoverState(false)
                end)

                aa.AddSignal(av.Top.InputEnded, function(ax)
                    if not ak.HoverFeedback or ak.Locked or not IsPressInput(ax) then
                        return
                    end

                    an = false
                    SetHoverState(false)
                end)

                aa.AddSignal(av.Top.Activated, function()
                    if ak.Locked then
                        return
                    end

                    if ak.Expandable then
                        if ak.Opened then
                            ak:Close()
                        else
                            ak:Open()
                        end
                    end
                end)

                task.defer(function()
                    UpdateTitleSize()
                    UpdateContentLayout()

                    if not ak.Expandable then
                        av.Content.Visible = false
                        av.Top.Active = false
                        av.Top.Size = UDim2.new(1, 0, 0, ak.HeaderSize)
                        av.Top.AutomaticSize = 'Y'
                        av.AutomaticSize = 'Y'
                    end

                    SetHoverState(true)
                    SetChevronState(ak.Opened, true)

                    if ak.Expandable then
                        if ak.Opened then
                            ak:Open(true)
                        else
                            ak:Close(true)
                        end
                    end

                    if ak.Locked then
                        ak:Lock()
                    end
                end)

                return ak.__type, ak
            end

            return af
        end
        function WindUIModules.SectionElement(): typeof(buildModule())
            local aa = WindUIModules.cache.SectionElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.SectionElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New
            local ae = aa.Tween

            local af = (cloneref or clonereference or function(af)
                return af
            end)
            local ag = af(game:GetService('UserInputService'))

            local ai = {}

            local function IsPressInput(ak)
                return ak.UserInputType == Enum.UserInputType.MouseButton1
                    or ak.UserInputType == Enum.UserInputType.Touch
            end

            local function ResolveTransparency(ak, al)
                local am = aa.GetThemeProperty(ak, aa.Theme)
                if typeof(am) ~= 'number' then
                    return al
                end
                return am
            end

            function ai.New(ak, al)
                local am = {
                    __type = 'MultiSection',
                    Title = al.Title or 'Section',
                    Desc = al.Desc,
                    Icon = al.Icon,
                    TextXAlignment = al.TextXAlignment or 'Left',
                    TextSize = al.TextSize or 19,
                    DescTextSize = al.DescTextSize or 16,
                    Box = al.Box or false,
                    BoxBorder = al.BoxBorder or false,
                    FontWeight = al.FontWeight or Enum.FontWeight.SemiBold,
                    DescFontWeight = al.DescFontWeight or Enum.FontWeight.Medium,
                    TextTransparency = al.TextTransparency or 0.05,
                    DescTextTransparency = al.DescTextTransparency or 0.4,
                    HoverFeedback = al.Hover ~= false,
                    Opened = al.Opened or false,
                    Locked = al.Locked or false,
                    LockedTitle = al.LockedTitle,
                    UIElements = {},

                    HeaderSize = al.HeaderSize or 42,
                    IconSize = al.IconSize or 20,
                    HeaderGap = al.HeaderGap or 10,
                    HeaderPaddingX = al.HeaderPaddingX
                        or (al.Window.ElementConfig.UIPadding + (al.Window.ModernLayout and 4 or 2)),
                    HeaderPaddingY = al.HeaderPaddingY
                        or math.max(
                            math.floor((al.Window.ElementConfig.UIPadding + (al.Window.ModernLayout and 4 or 0)) * 0.65),
                            6
                        ),

                    TabGap = al.TabGap or 6,
                    TabPaddingX = al.TabPaddingX or 12,
                    TabPaddingY = al.TabPaddingY or 8,
                    TabTextSize = al.TabTextSize or 15,
                    TabDescTextSize = al.TabDescTextSize or 13,

                    Tabs = {},
                    Elements = {},

                    SelectedTab = nil,
                    SelectedTabIndex = nil,

                    Expandable = false,
                }

                local an
                local ao = false
                local ap = false
                local aq = false
                local ar = false
                local as = false

                local at = al.Tab and al.Tab.UIElements and al.Tab.UIElements.ContainerFrame

                local au = '__windui_multisection_scroll_lock_count'
                local av = '__windui_multisection_scroll_lock_restore'

                local function GetUIScale()
                    local aw = tonumber((al.WindUI and al.WindUI.UIScale) or al.UIScale) or 1
                    if aw <= 0 then
                        return 1
                    end
                    return aw
                end

                local function ToLayoutOffset(aw)
                    return aw / GetUIScale()
                end

                local aw = ad('Frame', {
                    Size = UDim2.new(0, am.IconSize + 10, 0, am.IconSize + 10),
                    BackgroundTransparency = 1,
                    Visible = false,
                })

                local function createTitle(ax, ay)
                    return ad('TextLabel', {
                        BackgroundTransparency = 1,
                        TextXAlignment = am.TextXAlignment,
                        AutomaticSize = 'Y',
                        TextSize = ay and am.DescTextSize or am.TextSize,
                        TextTransparency = ay and am.DescTextTransparency or am.TextTransparency,
                        ThemeTag = {
                            TextColor3 = ay and 'SectionDesc' or 'SectionTitle',
                        },
                        FontFace = Font.new(aa.Font, ay and am.DescFontWeight or am.FontWeight),
                        Text = ax,
                        Size = UDim2.new(1, 0, 0, 0),
                        TextWrapped = true,
                    })
                end

                local ax = ad('Frame', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                }, {
                    ad('UIListLayout', {
                        FillDirection = 'Vertical',
                        HorizontalAlignment = am.TextXAlignment,
                        VerticalAlignment = 'Center',
                        Padding = UDim.new(0, 4),
                    }),
                })

                local ay = createTitle(am.Title, false)
                ay.Parent = ax

                local az
                if am.Desc and am.Desc ~= '' then
                    az = createTitle(am.Desc, true)
                    az.Parent = ax
                end

                local aA = ad('Frame', {
                    Size = UDim2.new(0, am.IconSize, 0, am.IconSize),
                    BackgroundTransparency = 1,
                    Visible = false,
                }, {
                    ad('ImageLabel', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Image = aa.Icon('chevron-down')[1],
                        ImageRectSize = aa.Icon('chevron-down')[2].ImageRectSize,
                        ImageRectOffset = aa.Icon('chevron-down')[2].ImageRectPosition,
                        ThemeTag = {
                            ImageTransparency = 'SectionExpandIconTransparency',
                            ImageColor3 = 'SectionExpandIcon',
                        },
                    }),
                })

                local aB = ad('Frame', {
                    Size = UDim2.new(0, 0, 0, am.IconSize),
                    AutomaticSize = 'X',
                    BackgroundTransparency = 1,
                }, {
                    ad('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Right',
                        Padding = UDim.new(0, 6),
                    }),
                    aA,
                })

                local b = ad('Frame', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                }, {
                    ad('UIListLayout', {
                        Padding = UDim.new(0, am.HeaderGap),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Left',
                    }),
                    aw,
                    ax,
                    aB,
                })

                local d = aa.NewRoundFrame(al.Window.ElementConfig.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = al.Parent,
                    ClipsDescendants = true,
                    AutomaticSize = 'Y',
                    ThemeTag = am.Box and {
                        ImageTransparency = 'SectionBoxBackgroundTransparency',
                        ImageColor3 = 'SectionBoxBackground',
                    } or nil,
                    ImageTransparency = not am.Box and 1 or nil,
                }, {
                    aa.NewRoundFrame(
                        al.Window.ElementConfig.UICorner,
                        al.Window.ModernLayout and 'Glass-1' or 'SquircleOutline',
                        {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 1, 0),
                            ThemeTag = {
                                ImageTransparency = 'SectionBoxBorderTransparency',
                                ImageColor3 = 'SectionBoxBorder',
                            },
                            Visible = am.Box and am.BoxBorder,
                            Name = 'Outline',
                        }
                    ),
                    ad('TextButton', {
                        Name = 'Top',
                        Size = UDim2.new(1, 0, 0, am.HeaderSize),
                        AutomaticSize = 'Y',
                        BackgroundTransparency = 1,
                        Active = false,
                        AutoButtonColor = false,
                        Text = '',
                        ClipsDescendants = true,
                    }, {
                        ad('UIPadding', {
                            PaddingTop = UDim.new(0, am.HeaderPaddingY),
                            PaddingBottom = UDim.new(0, am.HeaderPaddingY),
                            PaddingLeft = UDim.new(0, am.HeaderPaddingX),
                            PaddingRight = UDim.new(0, am.HeaderPaddingX),
                        }),
                        b,
                    }),
                    ad('Frame', {
                        Name = 'HeaderDivider',
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -(am.Box and al.Window.ElementConfig.UIPadding * 2 or 0), 0, 1),
                        Position = UDim2.new(0.5, 0, 0, am.HeaderSize),
                        AnchorPoint = Vector2.new(0.5, 0),
                        Visible = false,
                        ThemeTag = {
                            BackgroundColor3 = 'SectionContentDivider',
                            BackgroundTransparency = 'SectionContentDividerTransparency',
                        },
                    }),
                    ad('Frame', {
                        Name = 'Content',
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        Visible = false,
                        Position = UDim2.new(0, 0, 0, am.HeaderSize),
                    }, {
                        ad('UIPadding', {
                            PaddingTop = UDim.new(0, am.Box and 8 or 4),
                            PaddingLeft = UDim.new(0, am.Box and al.Window.ElementConfig.UIPadding or 0),
                            PaddingRight = UDim.new(0, am.Box and al.Window.ElementConfig.UIPadding or 0),
                            PaddingBottom = UDim.new(0, am.Box and al.Window.ElementConfig.UIPadding or 2),
                        }),
                        ad('UIListLayout', {
                            FillDirection = 'Vertical',
                            Padding = UDim.new(0, am.TabGap),
                            VerticalAlignment = 'Top',
                        }),
                        ad('Frame', {
                            Name = 'Tabs',
                            Size = UDim2.new(1, 0, 0, 0),
                            BackgroundTransparency = 1,
                        }, {
                            ad('ScrollingFrame', {
                                Name = 'Scroll',
                                Size = UDim2.new(1, 0, 0, 0),
                                BackgroundTransparency = 1,
                                ScrollBarThickness = 0,
                                CanvasSize = UDim2.new(0, 0, 0, 0),
                                ScrollingDirection = 'X',
                                AutomaticCanvasSize = 'None',
                                ScrollingEnabled = true,
                                ElasticBehavior = 'Never',
                                ClipsDescendants = true,
                            }, {
                                ad('UIListLayout', {
                                    FillDirection = 'Horizontal',
                                    Padding = UDim.new(0, am.TabGap),
                                    VerticalAlignment = 'Center',
                                    HorizontalAlignment = 'Left',
                                }),
                            }),
                        }),
                        ad('Frame', {
                            Name = 'TabsContent',
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = 'Y',
                            BackgroundTransparency = 1,
                        }),
                    }),
                })

                am.ElementFrame = d
                am.UIElements = {
                    Main = d,
                    Top = d.Top,
                    Content = d.Content,
                    Tabs = d.Content.Tabs,
                    TabsScroll = d.Content.Tabs.Scroll,
                    TabsContent = d.Content.TabsContent,
                    Icon = aw,
                    Title = ay,
                    Desc = az,
                    Chevron = aA.ImageLabel,
                }

                local f = d.Content.Tabs.Scroll.UIListLayout

                local function UpdateTitleSize()
                    local g = aw.Visible and (ToLayoutOffset(aw.AbsoluteSize.X) + am.HeaderGap) or 0
                    local h = aB.AbsoluteSize.X > 0 and (ToLayoutOffset(aB.AbsoluteSize.X) + am.HeaderGap) or 0
                    ax.Size = UDim2.new(1, -(g + h), 0, 0)
                end

                local function SetWindowScrollLock(g)
                    if not at then
                        as = false
                        return
                    end

                    if g and not as then
                        as = true

                        local h = at:GetAttribute(au) or 0
                        if h <= 0 then
                            at:SetAttribute(av, at.ScrollingEnabled)
                        end

                        at:SetAttribute(au, h + 1)
                        at.ScrollingEnabled = false
                        return
                    end

                    if (not g) and as then
                        as = false

                        local h = at:GetAttribute(au) or 0
                        h = math.max(h - 1, 0)

                        if h > 0 then
                            at:SetAttribute(au, h)
                            return
                        end

                        local j = at:GetAttribute(av)
                        at:SetAttribute(au, nil)
                        at:SetAttribute(av, nil)
                        at.ScrollingEnabled = typeof(j) == 'boolean' and j or true
                    end
                end

                local function UpdateWindowScrollLock()
                    local g = aq and ar and am.Opened and not am.Locked
                    SetWindowScrollLock(g)
                end

                local function UpdateTabsAlignment()
                    local g = am.UIElements.Tabs
                    local h = am.UIElements.TabsScroll

                    local j = math.max(0, math.floor(ToLayoutOffset(h.AbsoluteSize.X) + 0.5))
                    local l = math.max(0, math.floor(ToLayoutOffset(f.AbsoluteContentSize.X) + 0.5))
                    local m = math.max(0, math.floor(ToLayoutOffset(f.AbsoluteContentSize.Y) + 0.5))
                    local p = math.max(am.TabTextSize + (am.TabPaddingY * 2), 20)
                    local r = (#am.Tabs > 0) and math.max(math.ceil(m), p) or 0

                    g.Size = UDim2.new(1, 0, 0, r)
                    h.Size = UDim2.new(1, 0, 0, r)
                    h.CanvasSize = UDim2.new(0, math.max(l, j), 0, r)

                    if j <= 0 or l <= 0 then
                        ar = false
                        f.HorizontalAlignment = Enum.HorizontalAlignment.Left
                        h.ScrollingEnabled = false
                        h.CanvasPosition = Vector2.new(0, 0)
                        UpdateWindowScrollLock()
                        return
                    end

                    ar = l > j

                    if l <= j then
                        f.HorizontalAlignment = Enum.HorizontalAlignment.Center
                        h.ScrollingEnabled = false
                        h.CanvasPosition = Vector2.new(0, 0)
                    else
                        f.HorizontalAlignment = Enum.HorizontalAlignment.Left
                        h.ScrollingEnabled = true

                        local u = math.max(h.AbsoluteCanvasSize.X - h.AbsoluteSize.X, 0)
                        local v = math.clamp(h.CanvasPosition.X, 0, u)

                        if v ~= h.CanvasPosition.X then
                            h.CanvasPosition = Vector2.new(v, 0)
                        end
                    end

                    UpdateWindowScrollLock()
                end

                local function UpdateContentLayout()
                    local g = d.Top.AbsoluteSize.Y / GetUIScale()
                    d.Content.Position = UDim2.new(0, 0, 0, g)
                    d.HeaderDivider.Position = UDim2.new(0.5, 0, 0, g)
                end

                local function SetHoverState(g)
                    if not am.Box then
                        return
                    end

                    local h = ResolveTransparency('SectionBoxBackgroundTransparency', 0.95)
                    local j = math.max(h - 0.04, 0)
                    local l = math.max(h - 0.1, 0)

                    local m = h
                    if ap then
                        m = l
                    elseif ao then
                        m = j
                    end

                    if g then
                        d.ImageTransparency = m
                    else
                        ae(d, 0.12, {
                            ImageTransparency = m,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end

                local function SetChevronState(g, h)
                    local j = g and 180 or 0
                    local l = g and 0.1 or 0.25

                    if h then
                        aA.ImageLabel.Rotation = j
                        aA.ImageLabel.ImageTransparency = l
                    else
                        ae(aA.ImageLabel, 0.2, {
                            Rotation = j,
                            ImageTransparency = l,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end

                local function SyncHeight(g)
                    if not am.Expandable then
                        return
                    end

                    UpdateTabsAlignment()
                    UpdateContentLayout()

                    local h = d.Top.AbsoluteSize.Y
                    local j = am.Opened and d.Content.AbsoluteSize.Y or 0
                    local l = (h + j) / GetUIScale()

                    local m = UDim2.new(d.Size.X.Scale, d.Size.X.Offset, 0, l)

                    if g then
                        d.Size = m
                    else
                        ae(d, am.Opened and 0.33 or 0.24, {
                            Size = m,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end

                    d.HeaderDivider.Visible = am.Opened and am.Box and d.Content.AbsoluteSize.Y > 0
                end

                local function EnsureExpandable()
                    if am.Expandable then
                        return
                    end

                    am.Expandable = true
                    aA.Visible = true
                    d.Top.Active = not am.Locked
                    d.Content.Visible = true
                    d.AutomaticSize = 'None'

                    UpdateTitleSize()
                    UpdateContentLayout()

                    if am.Opened then
                        SetChevronState(true, true)
                    else
                        SetChevronState(false, true)
                    end

                    SyncHeight(true)
                end

                local function ResolveTab(g)
                    if typeof(g) == 'table' then
                        return g
                    end

                    if typeof(g) == 'number' then
                        return am.Tabs[g]
                    end

                    if typeof(g) == 'string' then
                        for h, j in next, am.Tabs do
                            if j.Title == g then
                                return j
                            end
                        end
                    end

                    return nil
                end

                local function SetTabState(g, h, j)
                    if not g or not g.UIElements or not g.UIElements.Button then
                        return
                    end

                    local l
                    local m
                    local p
                    local r
                    local u

                    if h == 'Selected' then
                        l = ResolveTransparency('TabBackgroundActiveTransparency', 0.93)
                        m = ResolveTransparency('TabBorderTransparencyActive', 0.75)
                        p = 0.05
                        r = 0.35
                        u = 0
                    elseif h == 'Hover' then
                        l = ResolveTransparency('TabBackgroundHoverTransparency', 0.97)
                        m = ResolveTransparency('TabBorderTransparency', 1)
                        p = 0.25
                        r = 0.5
                        u = 0.2
                    else
                        l = 1
                        m = 1
                        p = 0.4
                        r = 0.6
                        u = 0.35
                    end

                    local v = g.UIElements.Button
                    local x = g.UIElements.Outline
                    local z = g.UIElements.Title
                    local A = g.UIElements.Desc
                    local B = g.UIElements.Icon and g.UIElements.Icon.ImageLabel

                    if j then
                        v.ImageTransparency = l
                        if x then
                            x.ImageTransparency = m
                        end
                        if z then
                            z.TextTransparency = p
                        end
                        if A then
                            A.TextTransparency = r
                        end
                        if B then
                            B.ImageTransparency = u
                        end
                    else
                        ae(v, 0.1, {
                            ImageTransparency = l,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                        if x then
                            ae(x, 0.1, {
                                ImageTransparency = m,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end

                        if z then
                            ae(z, 0.1, {
                                TextTransparency = p,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end

                        if A then
                            ae(A, 0.1, {
                                TextTransparency = r,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end

                        if B then
                            ae(B, 0.1, {
                                ImageTransparency = u,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end
                    end
                end

                local function SetTabElementsLocked(g)
                    for h, j in next, am.Tabs do
                        if j and j.Elements then
                            for l, m in next, j.Elements do
                                if g then
                                    if m and m.Lock then
                                        m:Lock()
                                    end
                                else
                                    if m and m.Unlock then
                                        m:Unlock()
                                    end
                                end
                            end
                        end
                    end
                end

                function am.SetIcon(g, h)
                    am.Icon = h or nil

                    if an then
                        an:Destroy()
                        an = nil
                    end

                    aw.Visible = false

                    if h then
                        an =
                            aa.Image(h, h .. ':' .. am.Title, 0, al.Window.Folder, am.__type, true, true, 'SectionIcon')
                        an.Size = UDim2.new(0, am.IconSize, 0, am.IconSize)
                        an.Parent = aw
                        an.Position = UDim2.new(0.5, 0, 0.5, 0)
                        an.AnchorPoint = Vector2.new(0.5, 0.5)
                        aw.Visible = true
                    end

                    UpdateTitleSize()
                end

                function am.SetTitle(g, h)
                    am.Title = h
                    ay.Text = h
                end

                function am.SetDesc(g, h)
                    am.Desc = h

                    if h and h ~= '' then
                        if not az then
                            az = createTitle(h, true)
                            az.Parent = ax
                            am.UIElements.Desc = az
                        end
                        az.Text = h
                        az.Visible = true
                    elseif az then
                        az.Visible = false
                        az.Text = ''
                    end

                    if am.Expandable then
                        SyncHeight(true)
                    end
                end

                function am.Lock(g)
                    am.Locked = true
                    ao = false
                    ap = false
                    aq = false
                    SetHoverState(true)

                    if am.Expandable then
                        d.Top.Active = false
                    end

                    SetTabElementsLocked(true)
                    SetWindowScrollLock(false)

                    return am
                end

                function am.Unlock(g)
                    am.Locked = false

                    if am.Expandable then
                        d.Top.Active = true
                    end

                    SetTabElementsLocked(false)
                    UpdateWindowScrollLock()

                    return am
                end

                function am.SelectTab(g, h, j)
                    local l = ResolveTab(h)
                    if not l then
                        return nil
                    end

                    if am.SelectedTab == l then
                        return l
                    end

                    if am.SelectedTab and am.SelectedTab.UIElements.Content then
                        am.SelectedTab.UIElements.Content.Parent = nil
                        SetTabState(am.SelectedTab, 'Default', j)
                    end

                    am.SelectedTab = l
                    am.SelectedTabIndex = l.Index

                    l.UIElements.Content.Parent = am.UIElements.TabsContent
                    SetTabState(l, 'Selected', j)

                    SyncHeight(j)
                    return l
                end

                function am.GetSelectedTab(g)
                    return am.SelectedTab
                end

                function am.GetTabs(g)
                    return am.Tabs
                end

                function am.Tab(g, h)
                    h = h or {}

                    EnsureExpandable()

                    local j = {
                        __type = 'MultiSectionTab',
                        Title = h.Title or ('Tab ' .. tostring(#am.Tabs + 1)),
                        Desc = h.Desc,
                        Icon = h.Icon,
                        IconThemed = h.IconThemed,
                        Parent = am,
                        Elements = {},
                        UIElements = {},
                        Index = #am.Tabs + 1,
                        Gap = al.Tab and al.Tab.Gap
                            or (
                                al.Window.ModernLayout and (al.Window.ModernLayoutMergeElements == false and 4 or 1) or 6
                            ),
                    }

                    local l
                    if j.Icon then
                        l = aa.Image(
                            j.Icon,
                            j.Icon .. ':' .. am.Title .. ':' .. j.Title,
                            0,
                            al.Window.Folder,
                            'Tab',
                            true,
                            j.IconThemed,
                            'TabIcon'
                        )
                        l.Size = UDim2.new(0, 16, 0, 16)
                    end

                    local m = j.Desc and j.Desc ~= ''
                    local p = m and 'Left' or 'Center'
                    local r = l and 24 or 0

                    local u = m
                            and ad('TextLabel', {
                                Name = 'Desc',
                                BackgroundTransparency = 1,
                                AutomaticSize = 'XY',
                                Text = j.Desc or '',
                                Visible = true,
                                TextXAlignment = 'Left',
                                TextYAlignment = 'Top',
                                ThemeTag = {
                                    TextColor3 = 'Text',
                                },
                                FontFace = Font.new(aa.Font, Enum.FontWeight.Regular),
                                TextSize = am.TabDescTextSize,
                                TextTransparency = 0.6,
                            }, {
                                ad('UIPadding', {
                                    PaddingLeft = UDim.new(0, r),
                                }),
                            })
                        or nil

                    local v = aa.NewRoundFrame(math.max(al.Window.ElementConfig.UICorner - 2, 6), 'Squircle', {
                        Size = UDim2.new(0, 0, 0, 0),
                        AutomaticSize = 'XY',
                        BackgroundTransparency = 1,
                        AutoButtonColor = false,
                        ThemeTag = {
                            ImageColor3 = 'TabBackground',
                        },
                        ImageTransparency = 1,
                        Parent = am.UIElements.TabsScroll,
                    }, {
                        aa.NewRoundFrame(
                            math.max(al.Window.ElementConfig.UICorner - 2, 6),
                            al.Window.ModernLayout and 'Glass-1.4' or 'SquircleOutline',
                            {
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                ThemeTag = {
                                    ImageColor3 = 'TabBorder',
                                },
                                ImageTransparency = 1,
                                Name = 'Outline',
                            }
                        ),
                        ad('Frame', {
                            Name = 'Frame',
                            Size = UDim2.new(0, 0, 0, 0),
                            AutomaticSize = 'XY',
                            BackgroundTransparency = 1,
                        }, {
                            ad('UIPadding', {
                                PaddingTop = UDim.new(0, am.TabPaddingY),
                                PaddingBottom = UDim.new(0, am.TabPaddingY),
                                PaddingLeft = UDim.new(0, am.TabPaddingX),
                                PaddingRight = UDim.new(0, am.TabPaddingX),
                            }),
                            ad('UIListLayout', {
                                FillDirection = 'Vertical',
                                Padding = UDim.new(0, m and 2 or 0),
                                HorizontalAlignment = p,
                                VerticalAlignment = 'Center',
                            }),
                            ad('Frame', {
                                Name = 'HeaderRow',
                                BackgroundTransparency = 1,
                                Size = UDim2.new(0, 0, 0, 0),
                                AutomaticSize = 'XY',
                            }, {
                                ad('UIListLayout', {
                                    FillDirection = 'Horizontal',
                                    Padding = UDim.new(0, 8),
                                    HorizontalAlignment = p,
                                    VerticalAlignment = 'Center',
                                }),
                                l,
                                ad('TextLabel', {
                                    Name = 'Title',
                                    BackgroundTransparency = 1,
                                    AutomaticSize = 'XY',
                                    Text = j.Title,
                                    TextXAlignment = m and 'Left' or 'Center',
                                    TextYAlignment = 'Center',
                                    ThemeTag = {
                                        TextColor3 = 'TabTitle',
                                    },
                                    FontFace = Font.new(aa.Font, Enum.FontWeight.Medium),
                                    TextSize = am.TabTextSize,
                                    TextTransparency = 0.4,
                                }),
                            }),
                            u,
                        }),
                    }, true)

                    local x = ad('Frame', {
                        Name = 'TabContent_' .. tostring(j.Index),
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        BackgroundTransparency = 1,
                    }, {
                        ad('UIListLayout', {
                            FillDirection = 'Vertical',
                            Padding = UDim.new(0, j.Gap),
                            VerticalAlignment = 'Top',
                        }),
                    })

                    j.UIElements = {
                        Button = v,
                        Outline = v.Outline,
                        Title = v.Frame.HeaderRow.Title,
                        Desc = u,
                        Icon = l,
                        Content = x,
                        ContainerFrame = (al.Tab and al.Tab.UIElements and al.Tab.UIElements.ContainerFrame)
                            or { ScrollingEnabled = true },
                    }

                    local z = al.ElementsModule

                    z.Load(j, x, z.Elements, al.Window, al.WindUI, function(A)
                        if am.Locked and A and A.Lock then
                            A:Lock()
                        end

                        if am.SelectedTab == j and am.Expandable then
                            SyncHeight(true)
                        end
                    end, z, al.UIScale, j)

                    aa.AddSignal(x.UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'), function()
                        if am.SelectedTab == j and am.Expandable then
                            SyncHeight(true)
                        end
                    end)

                    aa.AddSignal(v.MouseEnter, function()
                        if am.Locked then
                            return
                        end

                        if am.SelectedTab ~= j then
                            SetTabState(j, 'Hover', false)
                        end
                    end)

                    aa.AddSignal(v.InputEnded, function()
                        if am.Locked then
                            return
                        end

                        if am.SelectedTab ~= j then
                            SetTabState(j, 'Default', false)
                        end
                    end)

                    aa.AddSignal(v.MouseButton1Click, function()
                        if am.Locked then
                            return
                        end

                        am:SelectTab(j)
                    end)

                    function j.Select(A, B)
                        return am:SelectTab(j, B)
                    end

                    function j.Destroy(A)
                        for B = #j.Elements, 1, -1 do
                            local C = j.Elements[B]
                            if C and C.Destroy then
                                C:Destroy()
                            end
                        end

                        if j.UIElements.Content then
                            j.UIElements.Content:Destroy()
                        end

                        if j.UIElements.Button then
                            j.UIElements.Button:Destroy()
                        end

                        local B
                        for C, F in next, am.Tabs do
                            if F == j then
                                B = C
                                break
                            end
                        end

                        if B then
                            table.remove(am.Tabs, B)
                        end

                        for C, F in next, am.Tabs do
                            F.Index = C
                        end

                        UpdateTabsAlignment()

                        if am.SelectedTab == j then
                            am.SelectedTab = nil
                            am.SelectedTabIndex = nil

                            if am.Tabs[1] then
                                am:SelectTab(am.Tabs[1], true)
                            else
                                SyncHeight(true)
                            end
                        else
                            SyncHeight(true)
                        end
                    end

                    table.insert(am.Tabs, j)
                    UpdateTabsAlignment()

                    if h.Selected or h.Opened or not am.SelectedTab then
                        am:SelectTab(j, true)
                    else
                        SetTabState(j, 'Default', true)
                    end

                    SyncHeight(true)
                    return j
                end

                function am.Destroy(g)
                    aq = false
                    ar = false
                    SetWindowScrollLock(false)

                    for h = #am.Tabs, 1, -1 do
                        local j = am.Tabs[h]
                        if j and j.Destroy then
                            j:Destroy()
                        end
                    end

                    d:Destroy()
                end

                function am.Open(g, h)
                    if am.Expandable then
                        am.Opened = true
                        d.Content.Visible = true
                        SetChevronState(true, h)
                        SyncHeight(h)
                        UpdateWindowScrollLock()
                    end
                end

                function am.Close(g, h)
                    if am.Expandable then
                        am.Opened = false
                        SetChevronState(false, h)
                        SyncHeight(h)
                        UpdateWindowScrollLock()
                    end
                end

                if am.Icon then
                    am:SetIcon(am.Icon)
                end

                aa.AddSignal(d.Top:GetPropertyChangedSignal('AbsoluteSize'), function()
                    UpdateTitleSize()
                    UpdateContentLayout()

                    if am.Expandable then
                        SyncHeight(true)
                    end
                end)

                aa.AddSignal(aB:GetPropertyChangedSignal('AbsoluteSize'), function()
                    UpdateTitleSize()
                end)

                aa.AddSignal(d.Content.UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'), function()
                    if am.Expandable then
                        SyncHeight(true)
                    end
                end)

                aa.AddSignal(am.UIElements.TabsScroll:GetPropertyChangedSignal('AbsoluteSize'), function()
                    UpdateTabsAlignment()
                end)

                aa.AddSignal(f:GetPropertyChangedSignal('AbsoluteContentSize'), function()
                    UpdateTabsAlignment()
                end)

                aa.AddSignal(am.UIElements.TabsScroll.MouseEnter, function()
                    if am.Locked then
                        return
                    end

                    aq = true
                    UpdateWindowScrollLock()
                end)

                aa.AddSignal(am.UIElements.TabsScroll.MouseLeave, function()
                    aq = false
                    UpdateWindowScrollLock()
                end)

                aa.AddSignal(ag.InputChanged, function(g)
                    if am.Locked then
                        return
                    end

                    if not aq then
                        return
                    end

                    if g.UserInputType ~= Enum.UserInputType.MouseWheel then
                        return
                    end

                    local h = am.UIElements.TabsScroll
                    local j = math.max(h.AbsoluteCanvasSize.X - h.AbsoluteSize.X, 0)
                    if j <= 0 then
                        return
                    end

                    local l = -g.Position.Z * 34
                    local m = math.clamp(h.CanvasPosition.X + l, 0, j)
                    h.CanvasPosition = Vector2.new(m, 0)
                end)

                aa.AddSignal(d.Top.MouseEnter, function()
                    if not am.HoverFeedback or am.Locked then
                        return
                    end

                    ao = true
                    SetHoverState(false)
                end)

                aa.AddSignal(d.Top.MouseLeave, function()
                    ao = false
                    ap = false
                    SetHoverState(false)
                end)

                aa.AddSignal(d.Top.InputBegan, function(g)
                    if not am.HoverFeedback or am.Locked or not IsPressInput(g) then
                        return
                    end

                    ap = true
                    SetHoverState(false)
                end)

                aa.AddSignal(d.Top.InputEnded, function(g)
                    if not am.HoverFeedback or am.Locked or not IsPressInput(g) then
                        return
                    end

                    ap = false
                    SetHoverState(false)
                end)

                aa.AddSignal(d.Top.Activated, function()
                    if am.Locked then
                        return
                    end

                    if am.Expandable then
                        if am.Opened then
                            am:Close()
                        else
                            am:Open()
                        end
                    end
                end)

                task.defer(function()
                    UpdateTitleSize()
                    UpdateContentLayout()
                    UpdateTabsAlignment()

                    if not am.Expandable then
                        d.Content.Visible = false
                        d.Top.Active = false
                        d.Top.Size = UDim2.new(1, 0, 0, am.HeaderSize)
                        d.Top.AutomaticSize = 'Y'
                        d.AutomaticSize = 'Y'
                    end

                    SetHoverState(true)
                    SetChevronState(am.Opened, true)

                    if am.Expandable then
                        if am.Opened then
                            am:Open(true)
                        else
                            am:Close(true)
                        end
                    end

                    if am.Locked then
                        am:Lock()
                    end

                    UpdateWindowScrollLock()
                end)

                return am.__type, am
            end

            return ai
        end
        function WindUIModules.MultiSectionElement(): typeof(buildModule())
            local aa = WindUIModules.cache.MultiSectionElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.MultiSectionElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New

            local ae = {}

            local function ParseAspectRatio(af)
                if type(af) == 'string' then
                    local ag, ai = af:match('(%d+):(%d+)')
                    if ag and ai then
                        return tonumber(ag) / tonumber(ai)
                    end
                elseif type(af) == 'number' then
                    return af
                end
                return nil
            end

            function ae.New(af, ag)
                local ai = {
                    __type = 'Image',
                    Image = ag.Image or '',
                    AspectRatio = ag.AspectRatio or '16:9',
                    Radius = ag.Radius or ag.Window.ElementConfig.UICorner,
                }
                local ak = aa.Image(ai.Image, ai.Image, ai.Radius, ag.Window.Folder, 'Image', false)
                if ak and ak.Parent then
                    ak.Parent = ag.Parent
                    ak.Size = UDim2.new(1, 0, 0, 0)
                    ak.BackgroundTransparency = 1

                    local al = ParseAspectRatio(ai.AspectRatio)
                    local am

                    if al then
                        am = ad('UIAspectRatioConstraint', {
                            Parent = ak,
                            AspectRatio = al,
                            AspectType = 'ScaleWithParentSize',
                            DominantAxis = 'Width',
                        })
                    end

                    function ai.Destroy(an)
                        ak:Destroy()
                    end
                end

                return ai.__type, ai
            end

            return ae
        end
        function WindUIModules.ImageElement(): typeof(buildModule())
            local aa = WindUIModules.cache.ImageElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.ImageElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New

            local ae = {}

            function ae.New(af, ag)
                local ai = {
                    __type = 'Group',
                    Elements = {},
                }

                local ak = ad('Frame', {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = 'Y',
                    Parent = ag.Parent,
                }, {
                    ad('UIListLayout', {
                        FillDirection = 'Horizontal',
                        HorizontalAlignment = 'Center',

                        Padding = UDim.new(
                            0,
                            ag.Tab and ag.Tab.Gap
                                or (
                                    ag.Window.ModernLayout
                                        and (ag.Window.ModernLayoutMergeElements == false and 4 or 1)
                                    or 6
                                )
                        ),
                    }),
                })

                local al = ag.ElementsModule
                al.Load(ai, ak, al.Elements, ag.Window, ag.WindUI, function(am, an)
                    local ao = ag.Tab and ag.Tab.Gap
                        or (ag.Window.ModernLayout and (ag.Window.ModernLayoutMergeElements == false and 4 or 1) or 6)

                    local ap = {}
                    local aq = 0

                    for ar, as in next, an do
                        if as.__type == 'Space' then
                            aq = aq + (as.ElementFrame.Size.X.Offset or 6)
                        else
                            table.insert(ap, as)
                        end
                    end

                    local ar = #ap
                    if ar == 0 then
                        return
                    end

                    local as = 1 / ar

                    local at = ao * (ar - 1)

                    local au = -(at + aq)

                    local av = math.floor(au / ar)
                    local aw = au - (av * ar)

                    for ax, ay in next, ap do
                        local az = av
                        if ax <= math.abs(aw) then
                            az = az - 1
                        end

                        if ay.ElementFrame then
                            ay.ElementFrame.Size = UDim2.new(as, az, 1, 0)
                        end
                    end
                end, al, ag.UIScale, ag.Tab)

                return ai.__type, ai
            end

            return ae
        end
        function WindUIModules.GroupElement(): typeof(buildModule())
            local aa = WindUIModules.cache.GroupElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.GroupElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = WindUIModules.LocalizationModule()
            local ad = aa.New

            local ae = {}

            local function normalizeVideo(af)
                if type(af) ~= 'string' then
                    return ''
                end

                if af == '' then
                    return ''
                end

                if string.match(af, '^%d+$') then
                    return 'rbxassetid://' .. af
                end

                return af
            end

            local function normalizeHeight(af)
                if type(af) ~= 'number' then
                    return 200
                end

                return math.max(af, 24)
            end

            local function normalizeVolume(af, ag)
                if type(af) ~= 'number' then
                    return ag
                end

                return math.clamp(af, 0, 10)
            end

            function ae.New(af, ag)
                local ai = {
                    __type = 'Video',
                    Title = ag.Title or 'Video',
                    Desc = ag.Desc or nil,
                    Video = normalizeVideo(ag.Video or ''),
                    Height = normalizeHeight(ag.Height),
                    Looped = ag.Looped == true,
                    Playing = ag.Playing == true,
                    Volume = normalizeVolume(ag.Volume, 0.5),
                    Visible = ag.Visible ~= false,
                    Radius = ag.Radius or ag.Window.ElementConfig.UICorner,
                }

                local ak = typeof(ag.Padding) == 'number' and math.max(math.floor(ag.Padding), 0) or 5

                local al = ad('Frame', {
                    Parent = ag.Parent,
                    Size = UDim2.new(1, 0, 0, ai.Height),
                    BackgroundTransparency = 1,
                    Visible = ai.Visible,
                    Name = 'VideoElement',
                })

                local am = aa.NewRoundFrame(ai.Radius, 'Squircle', {
                    Parent = al,
                    Size = UDim2.new(1, -(ak * 2), 1, -(ak * 2)),
                    Position = UDim2.new(0, ak, 0, ak),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    ThemeTag = {
                        ImageColor3 = 'ElementBackground',
                    },
                    ImageTransparency = 0.93,
                })

                local an = ad('VideoFrame', {
                    Parent = am,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ClipsDescendants = true,
                    ZIndex = 2,
                    Video = ai.Video,
                    Looped = ai.Looped,
                    Playing = ai.Playing,
                    Volume = ai.Volume,
                }, {
                    ad('UICorner', {
                        CornerRadius = UDim.new(0, ai.Radius),
                    }),
                })

                local ao = aa.NewRoundFrame(ai.Radius, ag.Window.ModernLayout and 'Glass-1' or 'SquircleOutline', {
                    Name = 'Outline',
                    Parent = am,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    ZIndex = 3,
                    ThemeTag = {
                        ImageColor3 = 'SectionBoxBorder',
                        ImageTransparency = 'SectionBoxBorderTransparency',
                    },
                })

                ai.ElementFrame = al
                ai.UIElements = {
                    Holder = al,
                    Box = am,
                    VideoFrame = an,
                    Outline = ao,
                }

                function ai.Play(ap)
                    ai.Playing = true
                    an.Playing = true
                end

                function ai.Pause(ap)
                    ai.Playing = false
                    an.Playing = false
                end

                function ai.SetPlaying(ap, aq)
                    if aq == true then
                        ai:Play()
                        return
                    end

                    ai:Pause()
                end

                function ai.SetVideo(ap, aq)
                    ai.Video = normalizeVideo(aq or '')
                    an.Video = ai.Video
                end

                function ai.SetVolume(ap, aq)
                    ai.Volume = normalizeVolume(aq, ai.Volume)
                    an.Volume = ai.Volume
                end

                function ai.SetLooped(ap, aq)
                    ai.Looped = aq == true
                    an.Looped = ai.Looped
                end

                function ai.SetVisible(ap, aq)
                    ai.Visible = aq ~= false
                    al.Visible = ai.Visible
                end

                function ai.SetHeight(ap, aq)
                    ai.Height = normalizeHeight(aq)
                    al.Size = UDim2.new(1, 0, 0, ai.Height)
                end

                function ai.Destroy(ap)
                    al:Destroy()
                end

                return ai.__type, ai
            end

            return ae
        end
        function WindUIModules.VideoElement(): typeof(buildModule())
            local aa = WindUIModules.cache.VideoElement
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.VideoElement = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            return {
                Elements = {
                    Paragraph = WindUIModules.ParagraphElement(),
                    Button = WindUIModules.ButtonElement(),
                    ButtonKeybind = WindUIModules.ButtonKeybindElement(),
                    Toggle = WindUIModules.ToggleElement(),
                    ToggleKeybind = WindUIModules.ToggleKeybindElement(),
                    Slider = WindUIModules.SliderElement(),
                    Stepper = WindUIModules.StepperElement(),
                    Keybind = WindUIModules.KeybindElement(),
                    Input = WindUIModules.InputElement(),
                    Dropdown = WindUIModules.DropdownElement(),
                    Segmented = WindUIModules.SegmentedElement(),
                    Code = WindUIModules.CodeElement(),
                    Colorpicker = WindUIModules.ColorpickerElement(),
                    Progress = WindUIModules.ProgressElement(),
                    Stats = WindUIModules.StatsElement(),
                    Section = WindUIModules.SectionElement(),
                    MultiSection = WindUIModules.MultiSectionElement(),
                    Space = WindUIModules.DividerModule(),
                    Divider = WindUIModules.TagModule(),
                    Image = WindUIModules.ImageElement(),
                    Group = WindUIModules.GroupElement(),
                    Video = WindUIModules.VideoElement(),
                },
                Load = function(aa, ad, ae, af, ag, ai, ak, al, am)
                    local function ResolveShapeFrame(an)
                        if typeof(an) ~= 'table' then
                            return nil
                        end

                        if typeof(an.__ShapeFrame) == 'table' and type(an.__ShapeFrame.UpdateShape) == 'function' then
                            return an.__ShapeFrame
                        end

                        for ao, ap in next, an do
                            if
                                typeof(ap) == 'table'
                                and ao ~= 'ElementFrame'
                                and ao:match('Frame$')
                                and type(ap.UpdateShape) == 'function'
                            then
                                return ap
                            end
                        end

                        return nil
                    end

                    local function removeFromList(an, ao)
                        if not an then
                            return
                        end

                        for ap = #an, 1, -1 do
                            if an[ap] == ao then
                                table.remove(an, ap)
                                return
                            end
                        end
                    end

                    for an, ao in next, ae do
                        aa[an] = function(ap, aq)
                            aq = aq or {}
                            aq.Tab = am or aa
                            aq.ParentType = aa.__type
                            aq.ParentTable = aa
                            aq.Index = #aa.Elements + 1
                            aq.GlobalIndex = #af.AllElements + 1
                            aq.Parent = ad
                            aq.Window = af
                            aq.WindUI = ag
                            aq.UIScale = al
                            aq.ElementsModule = ak
                            local 
ar, as = ao:New(aq)
                            if typeof(as) == 'table' then
                                as.ParentType = aq.ParentType
                            end

                            if aq.Flag and typeof(aq.Flag) == 'string' then
                                af.FlagIndex = af.FlagIndex or {}
                                af.FlagIndex[aq.Flag] = as
                                if af.ConfigManager then
                                    af.ConfigManager:Register(aq.Flag, as)
                                end
                            end

                            local at = ResolveShapeFrame(as)
                            if typeof(as) == 'table' then
                                as.__ShapeFrame = at
                            end

                            local au = as.Destroy
                            local av = false

                            if at then
                                as.ElementFrame = at.UIElements.Main
                                function as.SetTitle(aw, ax)
                                    at:SetTitle(ax)
                                end
                                function as.SetDesc(aw, ax)
                                    at:SetDesc(ax)
                                end
                                function as.Highlight(aw)
                                    at:Highlight()
                                end
                            end

                            function as.Destroy(aw)
                                if av then
                                    return
                                end
                                av = true

                                if typeof(au) == 'function' then
                                    local ax, ay = pcall(function()
                                        au(as)
                                    end)
                                    if not ax then
                                        warn(
                                            "[ WindUI ] Failed to destroy element '"
                                                .. tostring(aq.Flag or as.__type or an)
                                                .. "': "
                                                .. tostring(ay)
                                        )
                                    end
                                elseif at and at.Destroy then
                                    at:Destroy()
                                end

                                removeFromList(af.AllElements, as)
                                removeFromList(aa.Elements, as)
                                if aq.Tab and aq.Tab ~= aa and aq.Tab.Elements then
                                    removeFromList(aq.Tab.Elements, as)
                                end

                                if aq.Flag and typeof(aq.Flag) == 'string' then
                                    if af.FlagIndex and af.FlagIndex[aq.Flag] == as then
                                        af.FlagIndex[aq.Flag] = nil
                                    end
                                    if af.ConfigManager then
                                        af.ConfigManager:Unregister(aq.Flag)
                                    end
                                end

                                if aa.UpdateAllElementShapes then
                                    aa:UpdateAllElementShapes(aa)
                                end
                                if aq.Tab and aq.Tab ~= aa and aq.Tab.UpdateAllElementShapes then
                                    aq.Tab:UpdateAllElementShapes(aq.Tab)
                                end
                            end

                            table.insert(af.AllElements, as)
                            table.insert(aa.Elements, as)
                            if aq.Tab and aq.Tab ~= aa and aq.Tab.Elements then
                                table.insert(aq.Tab.Elements, as)
                            end

                            if af.ModernLayout then
                                aa:UpdateAllElementShapes(aa)
                            end

                            if ai then
                                ai(as, aa.Elements)
                            end
                            return as
                        end
                    end
                    function aa.UpdateAllElementShapes(an, ao)
                        for ap, aq in next, ao.Elements do
                            local ar = ResolveShapeFrame(aq)

                            if ar then
                                aq.__ShapeFrame = ar

                                ar.Index = ap
                                if ar.UpdateShape then
                                    ar.UpdateShape(ao)
                                end
                            end
                        end
                    end
                end,
            }
        end
        function WindUIModules.TabModule(): typeof(buildModule())
            local aa = WindUIModules.cache.TabModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.TabModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            aa(game:GetService('UserInputService'))
            local ad = game.Players.LocalPlayer:GetMouse()

            local ae = WindUIModules.LocalizationModule()
            local af = ae.New

            local ag = WindUIModules.ColorPickerUtilities().New
            local ai = WindUIModules.SpaceModule().New

            local ak = {

                Tabs = {},
                Containers = {},
                SelectedTab = nil,
                TabCount = 0,
                ToolTipParent = nil,
                TabHighlight = nil,

                OnChangeFunc = function(ak) end,
            }

            function ak.Init(al, am, an, ao)
                Window = al
                WindUI = am
                ak.Tabs = {}
                ak.Containers = {}
                ak.SelectedTab = nil
                ak.TabCount = 0
                ak.ToolTipParent = an
                ak.TabHighlight = ao
                ak.OnChangeFunc = function() end
                return ak
            end

            function ak.New(al, am)
                local an = {
                    __type = 'Tab',
                    Title = al.Title or 'Tab',
                    Desc = al.Desc,
                    Icon = al.Icon,
                    IconColor = al.IconColor,
                    IconShape = al.IconShape,
                    IconThemed = al.IconThemed,
                    Locked = al.Locked,
                    ShowTabTitle = al.ShowTabTitle,
                    Border = al.Border,
                    Selected = false,
                    Index = nil,
                    LayoutOrder = al.LayoutOrder,
                    Parent = al.Parent,
                    UIElements = {},
                    Elements = {},
                    ContainerFrame = nil,
                    UICorner = Window.UICorner - (Window.UIPadding / 2),

                    Gap = Window.ModernLayout and (Window.ModernLayoutMergeElements == false and 4 or 1) or 6,

                    TabPaddingX = 4 + (Window.UIPadding / 2),
                    TabPaddingY = 3 + (Window.UIPadding / 2),
                    TitlePaddingY = 0,
                }

                if an.IconShape then
                    an.TabPaddingX = 2 + (Window.UIPadding / 4)
                    an.TabPaddingY = 2 + (Window.UIPadding / 4)
                    an.TitlePaddingY = 2 + (Window.UIPadding / 4)
                end

                ak.TabCount = ak.TabCount + 1

                local ao = ak.TabCount
                an.Index = ao

                an.UIElements.Main = ae.NewRoundFrame(an.UICorner, 'Squircle', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -7, 0, 0),
                    AutomaticSize = 'Y',
                    Parent = al.Parent,
                    LayoutOrder = an.LayoutOrder,
                    ThemeTag = {
                        ImageColor3 = 'TabBackground',
                    },
                    ImageTransparency = 1,
                }, {
                    ae.NewRoundFrame(an.UICorner, 'Glass-1.4', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = {
                            ImageColor3 = 'TabBorder',
                        },
                        ImageTransparency = 1,
                        Name = 'Outline',
                    }, {}),
                    ae.NewRoundFrame(an.UICorner, 'Squircle', {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        ThemeTag = {
                            ImageColor3 = 'Text',
                        },
                        ImageTransparency = 1,
                        Name = 'Frame',
                    }, {
                        af('UIListLayout', {
                            SortOrder = 'LayoutOrder',
                            Padding = UDim.new(0, 2 + (Window.UIPadding / 2)),
                            FillDirection = 'Horizontal',
                            VerticalAlignment = 'Center',
                        }),
                        af('TextLabel', {
                            Text = an.Title,
                            ThemeTag = {
                                TextColor3 = 'TabTitle',
                            },
                            TextTransparency = not an.Locked and 0.4 or 0.7,
                            TextSize = 15,
                            Size = UDim2.new(1, 0, 0, 0),
                            FontFace = Font.new(ae.Font, Enum.FontWeight.Medium),
                            TextWrapped = true,
                            RichText = true,
                            AutomaticSize = 'Y',
                            LayoutOrder = 2,
                            TextXAlignment = 'Left',
                            BackgroundTransparency = 1,
                        }, {
                            af('UIPadding', {
                                PaddingTop = UDim.new(0, an.TitlePaddingY),

                                PaddingBottom = UDim.new(0, an.TitlePaddingY),
                            }),
                        }),
                        af('UIPadding', {
                            PaddingTop = UDim.new(0, an.TabPaddingY),
                            PaddingLeft = UDim.new(0, an.TabPaddingX),
                            PaddingRight = UDim.new(0, an.TabPaddingX),
                            PaddingBottom = UDim.new(0, an.TabPaddingY),
                        }),
                    }),
                }, true)

                local ap = 0
                local aq
                local ar

                if an.Icon then
                    aq = ae.Image(
                        an.Icon,
                        an.Icon .. ':' .. an.Title,
                        0,
                        Window.Folder,
                        an.__type,
                        an.IconColor and false or true,
                        an.IconThemed,
                        'TabIcon'
                    )
                    aq.Size = UDim2.new(0, 16, 0, 16)
                    if an.IconColor then
                        aq.ImageLabel.ImageColor3 = an.IconColor
                    end
                    if not an.IconShape then
                        aq.Parent = an.UIElements.Main.Frame
                        an.UIElements.Icon = aq
                        aq.ImageLabel.ImageTransparency = not an.Locked and 0 or 0.7
                        ap = -18 - (Window.UIPadding / 2)
                        an.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, ap, 0, 0)
                    elseif an.IconColor then
                        ae.NewRoundFrame(
                            an.IconShape ~= 'Circle' and (an.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
                            'Squircle',
                            {
                                Size = UDim2.new(0, 26, 0, 26),
                                ImageColor3 = an.IconColor,
                                Parent = an.UIElements.Main.Frame,
                            },
                            {
                                aq,
                                ae.NewRoundFrame(
                                    an.IconShape ~= 'Circle' and (an.UICorner + 5 - (2 + (Window.UIPadding / 4)))
                                        or 9999,
                                    'Glass-1.4',
                                    {
                                        Size = UDim2.new(1, 0, 1, 0),
                                        ThemeTag = {
                                            ImageColor3 = 'White',
                                        },
                                        ImageTransparency = 0,
                                        Name = 'Outline',
                                    },
                                    {}
                                ),
                            }
                        )
                        aq.AnchorPoint = Vector2.new(0.5, 0.5)
                        aq.Position = UDim2.new(0.5, 0, 0.5, 0)
                        aq.ImageLabel.ImageTransparency = 0
                        aq.ImageLabel.ImageColor3 = ae.GetTextColorForHSB(an.IconColor, 0.68)
                        ap = -28 - (Window.UIPadding / 2)
                        an.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, ap, 0, 0)
                    end

                    ar = ae.Image(an.Icon, an.Icon .. ':' .. an.Title, 0, Window.Folder, an.__type, true, an.IconThemed)
                    ar.Size = UDim2.new(0, 16, 0, 16)
                    ar.ImageLabel.ImageTransparency = not an.Locked and 0 or 0.7
                    ap = -30
                end

                an.UIElements.ContainerFrame = af('ScrollingFrame', {
                    Size = UDim2.new(1, 0, 1, an.ShowTabTitle and -((Window.UIPadding * 2.4) + 12) or 0),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 0,
                    ElasticBehavior = 'Never',
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    AutomaticCanvasSize = 'Y',

                    ScrollingDirection = 'Y',
                }, {
                    af('UIPadding', {
                        PaddingTop = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
                        PaddingLeft = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
                        PaddingRight = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
                        PaddingBottom = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
                    }),
                    af('UIListLayout', {
                        SortOrder = 'LayoutOrder',
                        Padding = UDim.new(0, an.Gap),
                        HorizontalAlignment = 'Center',
                    }),
                })

                an.UIElements.ContainerFrameCanvas = af('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Visible = false,
                    Parent = Window.UIElements.MainBar,
                    ZIndex = 5,
                }, {
                    an.UIElements.ContainerFrame,
                    af('Frame', {
                        Size = UDim2.new(1, 0, 0, ((Window.UIPadding * 2.4) + 12)),
                        BackgroundTransparency = 1,
                        Visible = an.ShowTabTitle or false,
                        Name = 'TabTitle',
                    }, {
                        ar,
                        af('TextLabel', {
                            Text = an.Title,
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                            TextSize = 20,
                            TextTransparency = 0.1,
                            Size = UDim2.new(1, -ap, 1, 0),
                            FontFace = Font.new(ae.Font, Enum.FontWeight.SemiBold),
                            TextTruncate = 'AtEnd',
                            RichText = true,
                            LayoutOrder = 2,
                            TextXAlignment = 'Left',
                            BackgroundTransparency = 1,
                        }),
                        af('UIPadding', {
                            PaddingTop = UDim.new(0, 20),
                            PaddingLeft = UDim.new(0, 20),
                            PaddingRight = UDim.new(0, 20),
                            PaddingBottom = UDim.new(0, 20),
                        }),
                        af('UIListLayout', {
                            SortOrder = 'LayoutOrder',
                            Padding = UDim.new(0, 10),
                            FillDirection = 'Horizontal',
                            VerticalAlignment = 'Center',
                        }),
                    }),
                    af('Frame', {
                        Size = UDim2.new(1, 0, 0, 1),
                        BackgroundTransparency = 0.9,
                        ThemeTag = {
                            BackgroundColor3 = 'Text',
                        },
                        Position = UDim2.new(0, 0, 0, ((Window.UIPadding * 2.4) + 12)),
                        Visible = an.ShowTabTitle or false,
                    }),
                })

                ak.Containers[ao] = an.UIElements.ContainerFrameCanvas
                ak.Tabs[ao] = an

                an.ContainerFrame = an.UIElements.ContainerFrameCanvas

                ae.AddSignal(an.UIElements.Main.MouseButton1Click, function()
                    if not an.Locked then
                        ak:SelectTab(ao)
                    end
                end)

                if Window.ScrollBarEnabled then
                    ai(an.UIElements.ContainerFrame, an.UIElements.ContainerFrameCanvas, Window, 3)
                end

                local as
                local at
                local au
                local av = false

                if an.Desc then
                    ae.AddSignal(an.UIElements.Main.InputBegan, function()
                        av = true
                        at = task.spawn(function()
                            task.wait(0.35)
                            if av and not as then
                                as = ag(an.Desc, ak.ToolTipParent, true)
                                as.Container.AnchorPoint = Vector2.new(0.5, 0.5)

                                local function updatePosition()
                                    if as then
                                        as.Container.Position = UDim2.new(0, ad.X, 0, ad.Y - 4)
                                    end
                                end

                                updatePosition()
                                au = ad.Move:Connect(updatePosition)
                                as:Open()
                            end
                        end)
                    end)
                end

                ae.AddSignal(an.UIElements.Main.MouseEnter, function()
                    if not an.Locked then
                        ae.SetThemeTag(an.UIElements.Main.Frame, {
                            ImageTransparency = 'TabBackgroundHoverTransparency',
                            ImageColor3 = 'TabBackgroundHover',
                        }, 0.08)
                    end
                end)
                ae.AddSignal(an.UIElements.Main.InputEnded, function()
                    if an.Desc then
                        av = false
                        if at then
                            task.cancel(at)
                            at = nil
                        end
                        if au then
                            au:Disconnect()
                            au = nil
                        end
                        if as then
                            as:Close()
                            as = nil
                        end
                    end

                    if not an.Locked then
                        ae.SetThemeTag(an.UIElements.Main.Frame, {
                            ImageTransparency = 'TabBorderTransparency',
                        }, 0.08)
                    end
                end)

                function an.ScrollToTheElement(aw, ax)
                    an.UIElements.ContainerFrame.ScrollingEnabled = false

                    ae.Tween(an.UIElements.ContainerFrame, 0.45, {
                        CanvasPosition = Vector2.new(
                            0,
                            an.Elements[ax].ElementFrame.AbsolutePosition.Y
                                - an.UIElements.ContainerFrame.AbsolutePosition.Y
                                - an.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
                        ),
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                    task.spawn(function()
                        task.wait(0.48)

                        if an.Elements[ax].Highlight then
                            an.Elements[ax]:Highlight()
                        end
                        an.UIElements.ContainerFrame.ScrollingEnabled = true
                    end)

                    return an
                end

                local aw = WindUIModules.TabModule()

                aw.Load(an, an.UIElements.ContainerFrame, aw.Elements, Window, WindUI, nil, aw, am)

                function an.LockAll(ax)
                    for ay, az in next, Window.AllElements do
                        if az.Tab and az.Tab.Index and az.Tab.Index == an.Index and az.Lock then
                            az:Lock()
                        end
                    end
                end
                function an.UnlockAll(ax)
                    for ay, az in next, Window.AllElements do
                        if az.Tab and az.Tab.Index and az.Tab.Index == an.Index and az.Unlock then
                            az:Unlock()
                        end
                    end
                end
                function an.GetLocked(ax)
                    local ay = {}

                    for az, aA in next, Window.AllElements do
                        if aA.Tab and aA.Tab.Index and aA.Tab.Index == an.Index and aA.Locked == true then
                            table.insert(ay, aA)
                        end
                    end

                    return ay
                end
                function an.GetUnlocked(ax)
                    local ay = {}

                    for az, aA in next, Window.AllElements do
                        if aA.Tab and aA.Tab.Index and aA.Tab.Index == an.Index and aA.Locked == false then
                            table.insert(ay, aA)
                        end
                    end

                    return ay
                end

                function an.Select(ax)
                    return ak:SelectTab(an.Index)
                end

                task.spawn(function()
                    local ax = af('Frame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, -Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
                        Parent = an.UIElements.ContainerFrame,
                    }, {
                        af('UIListLayout', {
                            Padding = UDim.new(0, 8),
                            SortOrder = 'LayoutOrder',
                            VerticalAlignment = 'Center',
                            HorizontalAlignment = 'Center',
                            FillDirection = 'Vertical',
                        }),
                        af('ImageLabel', {
                            Size = UDim2.new(0, 48, 0, 48),
                            Image = ae.Icon('frown')[1],
                            ImageRectOffset = ae.Icon('frown')[2].ImageRectPosition,
                            ImageRectSize = ae.Icon('frown')[2].ImageRectSize,
                            ThemeTag = {
                                ImageColor3 = 'Icon',
                            },
                            BackgroundTransparency = 1,
                            ImageTransparency = 0.6,
                        }),
                        af('TextLabel', {
                            AutomaticSize = 'XY',
                            Text = 'This tab is empty',
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                            TextSize = 18,
                            TextTransparency = 0.5,
                            BackgroundTransparency = 1,
                            FontFace = Font.new(ae.Font, Enum.FontWeight.Medium),
                        }),
                    })

                    local ay
                    ay = ae.AddSignal(an.UIElements.ContainerFrame.ChildAdded, function()
                        ax.Visible = false
                        ay:Disconnect()
                    end)
                end)

                return an
            end

            function ak.OnChange(al, am)
                ak.OnChangeFunc = am
            end

            local function ResolveTabIndex(al)
                if typeof(al) == 'number' then
                    return ak.Tabs[al] and al or nil
                end

                if typeof(al) == 'string' then
                    for am, an in next, ak.Tabs do
                        if an and an.Title == al then
                            return am
                        end
                    end
                    return nil
                end

                if typeof(al) == 'table' then
                    if al.Index and ak.Tabs[al.Index] == al then
                        return al.Index
                    end

                    for am, an in next, ak.Tabs do
                        if an == al then
                            return am
                        end
                    end
                end

                return nil
            end

            function ak.SelectTab(al, am)
                local an = ResolveTabIndex(am)
                if not an then
                    return nil
                end

                local ao = ak.Tabs[an]
                if ao and not ao.Locked then
                    ak.SelectedTab = an

                    for ap, aq in next, ak.Tabs do
                        if not aq.Locked then
                            ae.SetThemeTag(aq.UIElements.Main, {
                                ImageTransparency = 'TabBorderTransparency',
                            }, 0.15)
                            if aq.Border then
                                ae.SetThemeTag(aq.UIElements.Main.Outline, {
                                    ImageTransparency = 'TabBorderTransparency',
                                }, 0.15)
                            end
                            ae.SetThemeTag(aq.UIElements.Main.Frame.TextLabel, {
                                TextTransparency = 'TabTextTransparency',
                            }, 0.15)
                            if aq.UIElements.Icon and not aq.IconColor then
                                ae.SetThemeTag(aq.UIElements.Icon.ImageLabel, {
                                    ImageTransparency = 'TabIconTransparency',
                                }, 0.15)
                            end
                            aq.Selected = false
                        end
                    end
                    ae.SetThemeTag(ak.Tabs[an].UIElements.Main, {
                        ImageTransparency = 'TabBackgroundActiveTransparency',
                    }, 0.15)
                    if ak.Tabs[an].Border then
                        ae.SetThemeTag(ak.Tabs[an].UIElements.Main.Outline, {
                            ImageTransparency = 'TabBorderTransparencyActive',
                        }, 0.15)
                    end
                    ae.SetThemeTag(ak.Tabs[an].UIElements.Main.Frame.TextLabel, {
                        TextTransparency = 'TabTextTransparencyActive',
                    }, 0.15)
                    if ak.Tabs[an].UIElements.Icon and not ak.Tabs[an].IconColor then
                        ae.SetThemeTag(ak.Tabs[an].UIElements.Icon.ImageLabel, {
                            ImageTransparency = 'TabIconTransparencyActive',
                        }, 0.15)
                    end
                    ak.Tabs[an].Selected = true

                    task.spawn(function()
                        for ap, aq in next, ak.Containers do
                            aq.AnchorPoint = Vector2.new(0, 0.05)
                            aq.Visible = false
                        end
                        ak.Containers[an].Visible = true
                        local ap = game:GetService('TweenService')

                        local aq = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                        local ar = ap:Create(ak.Containers[an], aq, {
                            AnchorPoint = Vector2.new(0, 0),
                        })
                        ar:Play()
                    end)

                    ak.OnChangeFunc(an)
                    return ao
                end

                return nil
            end

            return ak
        end
        function WindUIModules.SidebarModule(): typeof(buildModule())
            local aa = WindUIModules.cache.SidebarModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.SidebarModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = {}

            local ad = WindUIModules.LocalizationModule()
            local ae = ad.New
            local af = ad.Tween

            local ag = WindUIModules.PanelModule().New
            local ai = WindUIModules.NotificationModule().New
            local ak = WindUIModules.DividerModule()
            local al = WindUIModules.TagModule()
            local am = WindUIModules.TabModule()

            local an = WindUIModules.SidebarModule()

            function aa.New(ao, ap, aq, ar, as, at)
                local au = {
                    __type = 'SectionModule',
                    Title = ao.Title or 'Section',
                    Icon = ao.Icon,
                    IconThemed = ao.IconThemed,
                    Opened = ao.Opened or false,
                    Elements = {},

                    HeaderSize = 42,
                    IconSize = 18,

                    Expandable = false,
                }

                local av
                if au.Icon then
                    av = ad.Image(au.Icon, au.Icon, 0, aq, 'Section', true, au.IconThemed)

                    av.Size = UDim2.new(0, au.IconSize, 0, au.IconSize)
                    av.ImageLabel.ImageTransparency = 0.25
                end

                local aw = ae('Frame', {
                    Size = UDim2.new(0, au.IconSize, 0, au.IconSize),
                    BackgroundTransparency = 1,
                    Visible = false,
                }, {
                    ae('ImageLabel', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Image = ad.Icon('chevron-down')[1],
                        ImageRectSize = ad.Icon('chevron-down')[2].ImageRectSize,
                        ImageRectOffset = ad.Icon('chevron-down')[2].ImageRectPosition,
                        ThemeTag = {
                            ImageColor3 = 'Icon',
                        },
                        ImageTransparency = 0.7,
                    }),
                })

                local ax = ae('Frame', {
                    Size = UDim2.new(1, 0, 0, au.HeaderSize),
                    BackgroundTransparency = 1,
                    Parent = ap,
                    ClipsDescendants = true,
                    LayoutOrder = ao.LayoutOrder,
                }, {
                    ae('TextButton', {
                        Size = UDim2.new(1, 0, 0, au.HeaderSize),
                        BackgroundTransparency = 1,
                        Text = '',
                    }, {
                        av,
                        ae('TextLabel', {
                            Text = au.Title,
                            TextXAlignment = 'Left',
                            Size = UDim2.new(1, av and (-au.IconSize - 10) * 2 or (-au.IconSize - 10), 1, 0),
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                            FontFace = Font.new(ad.Font, Enum.FontWeight.SemiBold),
                            TextSize = 14,
                            BackgroundTransparency = 1,
                            TextTransparency = 0.7,

                            TextWrapped = true,
                        }),
                        ae('UIListLayout', {
                            FillDirection = 'Horizontal',
                            VerticalAlignment = 'Center',
                            Padding = UDim.new(0, 10),
                        }),
                        aw,
                        ae('UIPadding', {
                            PaddingLeft = UDim.new(0, 11),
                            PaddingRight = UDim.new(0, 11),
                        }),
                    }),
                    ae('Frame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        Name = 'Content',
                        Visible = true,
                        Position = UDim2.new(0, 0, 0, au.HeaderSize),
                    }, {
                        ae('UIListLayout', {
                            FillDirection = 'Vertical',
                            Padding = UDim.new(0, as.Gap),
                            VerticalAlignment = 'Bottom',
                        }),
                    }),
                })

                local function EnsureExpandable()
                    if not au.Expandable then
                        au.Expandable = true
                        aw.Visible = true

                        if au.Opened and au.Open then
                            task.defer(function()
                                au:Open()
                            end)
                        end
                    end
                end

                local function getUIScale()
                    local ay = as and as.GetUIScale and as:GetUIScale() or ar
                    ay = tonumber(ay) or 1
                    if ay <= 0 then
                        return 1
                    end
                    return ay
                end

                am.Load(au, ax.Content, am.Elements, as, at, function()
                    EnsureExpandable()
                end, am, ar)

                function au.Tab(ay, az)
                    EnsureExpandable()
                    az.Parent = ax.Content
                    return an.New(az, ar)
                end

                function au.Label(ay, az)
                    az = az or {}
                    EnsureExpandable()

                    local aA = az.Title or az.Text or 'Label'
                    local aB = ag(aA, az.Icon, ax.Content, az.Placeholder == true, az.Radius)

                    local b = typeof(az.Height) == 'number' and math.max(az.Height, 18) or 34
                    aB.Size = az.Size or UDim2.new(1, -7, 0, b)
                    aB.Visible = az.Visible ~= false

                    if typeof(az.LayoutOrder) == 'number' then
                        aB.LayoutOrder = az.LayoutOrder
                    end

                    return aB
                end

                function au.Button(ay, az)
                    az = az or {}
                    EnsureExpandable()

                    local aA = typeof(az.Height) == 'number' and math.max(az.Height, 20) or 34
                    local aB = ae('Frame', {
                        Name = 'SectionButton',
                        Parent = ax.Content,
                        BackgroundTransparency = 1,
                        Size = az.Size or UDim2.new(1, -7, 0, aA),
                        Visible = az.Visible ~= false,
                    })

                    if typeof(az.LayoutOrder) == 'number' then
                        aB.LayoutOrder = az.LayoutOrder
                    end

                    local b = {
                        __type = 'SectionButton',
                        Title = az.Title or az.Text or 'Button',
                        Callback = az.Callback,
                        ElementFrame = aB,
                        ButtonFrame = nil,
                    }

                    local d = ai(b.Title, az.Icon, function()
                        if b.Callback then
                            ad.SafeCallback(b.Callback, b)
                        end
                    end, az.Variant or 'Secondary', aB, nil, az.FullRounded, az.Radius)

                    d.AutomaticSize = 'None'
                    d.Size = UDim2.new(1, 0, 1, 0)
                    d.Position = UDim2.new(0.5, 0, 0.5, 0)
                    d.AnchorPoint = Vector2.new(0.5, 0.5)

                    b.ButtonFrame = d

                    function b.SetTitle(f, g)
                        f.Title = tostring(g or '')

                        local h = f.ButtonFrame:FindFirstChild('TextLabel', true)
                        if h then
                            h.Text = f.Title
                        end

                        return f
                    end

                    function b.SetCallback(f, g)
                        f.Callback = g
                        return f
                    end

                    function b.SetVisible(f, g)
                        f.ElementFrame.Visible = g ~= false
                        return f
                    end

                    function b.Destroy(f)
                        if f.ElementFrame then
                            f.ElementFrame:Destroy()
                            f.ElementFrame = nil
                            f.ButtonFrame = nil
                        end
                    end

                    return b
                end

                function au.Space(ay, az)
                    az = az or {}
                    EnsureExpandable()

                    local aA = table.clone(az)
                    aA.Parent = ax.Content
                    aA.ParentType = aA.ParentType or 'Section'
                    local 
aB, b = ak:New(aA)
                    return b.ElementFrame
                end

                function au.Divider(ay, az)
                    az = az or {}
                    EnsureExpandable()

                    local aA = table.clone(az)
                    aA.Parent = ax.Content
                    aA.ParentType = aA.ParentType or 'Section'
                    local 
aB, b = al:New(aA)
                    return b.ElementFrame
                end

                function au.Open(ay)
                    if au.Expandable then
                        au.Opened = true
                        af(ax, 0.33, {
                            Size = UDim2.new(1, 0, 0, au.HeaderSize + (ax.Content.AbsoluteSize.Y / getUIScale())),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                        af(aw.ImageLabel, 0.1, { Rotation = 180 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end
                function au.Close(ay)
                    if au.Expandable then
                        au.Opened = false
                        af(ax, 0.26, {
                            Size = UDim2.new(1, 0, 0, au.HeaderSize),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        af(aw.ImageLabel, 0.1, { Rotation = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end

                ad.AddSignal(ax.TextButton.MouseButton1Click, function()
                    if au.Expandable then
                        if au.Opened then
                            au:Close()
                        else
                            au:Open()
                        end
                    end
                end)

                ad.AddSignal(ax.Content.UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'), function()
                    if au.Opened then
                        au:Open()
                    end
                end)

                if au.Opened then
                    task.spawn(function()
                        task.wait()
                        au:Open()
                    end)
                end

                return au
            end

            return aa
        end
        function WindUIModules.DefaultElementIcons(): typeof(buildModule())
            local aa = WindUIModules.cache.DefaultElementIcons
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.DefaultElementIcons = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            return {
                Tab = 'table-of-contents',
                Paragraph = 'type',
                Button = 'square-mouse-pointer',
                ButtonKeybind = 'square-mouse-pointer',
                Toggle = 'toggle-right',
                ToggleKeybind = 'toggle-right',
                Slider = 'sliders-horizontal',
                Keybind = 'command',
                Input = 'text-cursor-input',
                Dropdown = 'chevrons-up-down',
                Code = 'terminal',
                Colorpicker = 'palette',
                Divider = 'minus',
                Video = 'video',
            }
        end
        function WindUIModules.SearchModule(): typeof(buildModule())
            local aa = WindUIModules.cache.SearchModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.SearchModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            aa(game:GetService('UserInputService'))

            local ad = {
                Margin = 8,
                Padding = 9,
            }

            local ae = WindUIModules.LocalizationModule()
            local af = ae.New
            local ag = ae.Tween

            function ad.new(ai, ak, al)
                local am = {
                    IconSize = 18,
                    Padding = 14,
                    Radius = 22,
                    Width = 400,
                    MaxHeight = 380,

                    Icons = WindUIModules.SearchModule(),
                }

                local an = af('TextBox', {
                    Text = '',
                    PlaceholderText = 'Search...',
                    ThemeTag = {
                        PlaceholderColor3 = 'Placeholder',
                        TextColor3 = 'Text',
                    },
                    Size = UDim2.new(1, -((am.IconSize * 2) + (am.Padding * 2)), 0, 0),
                    AutomaticSize = 'Y',
                    ClipsDescendants = true,
                    ClearTextOnFocus = false,
                    BackgroundTransparency = 1,
                    TextXAlignment = 'Left',
                    FontFace = Font.new(ae.Font, Enum.FontWeight.Regular),
                    TextSize = 18,
                })

                local ao = af('ImageLabel', {
                    Image = ae.Icon('x')[1],
                    ImageRectSize = ae.Icon('x')[2].ImageRectSize,
                    ImageRectOffset = ae.Icon('x')[2].ImageRectPosition,
                    BackgroundTransparency = 1,
                    ThemeTag = {
                        ImageColor3 = 'Icon',
                    },
                    ImageTransparency = 0.1,
                    Size = UDim2.new(0, am.IconSize, 0, am.IconSize),
                }, {
                    af('TextButton', {
                        Size = UDim2.new(1, 8, 1, 8),
                        BackgroundTransparency = 1,
                        Active = true,
                        ZIndex = 999999999,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Text = '',
                    }),
                })

                local ap = af('ScrollingFrame', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticCanvasSize = 'Y',
                    ScrollingDirection = 'Y',
                    ElasticBehavior = 'Never',
                    ScrollBarThickness = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Visible = false,
                }, {
                    af('UIListLayout', {
                        Padding = UDim.new(0, 0),
                        FillDirection = 'Vertical',
                    }),
                    af('UIPadding', {
                        PaddingTop = UDim.new(0, am.Padding),
                        PaddingLeft = UDim.new(0, am.Padding),
                        PaddingRight = UDim.new(0, am.Padding),
                        PaddingBottom = UDim.new(0, am.Padding),
                    }),
                })

                local aq = ae.NewRoundFrame(am.Radius, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ThemeTag = {
                        ImageColor3 = 'WindowSearchBarBackground',
                    },
                    ImageTransparency = 0,
                }, {
                    ae.NewRoundFrame(am.Radius, 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,

                        Visible = false,
                        ThemeTag = {
                            ImageColor3 = 'White',
                        },
                        ImageTransparency = 1,
                        Name = 'Frame',
                    }, {
                        af('Frame', {
                            Size = UDim2.new(1, 0, 0, 46),
                            BackgroundTransparency = 1,
                        }, {

                            af('Frame', {
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                            }, {
                                af('ImageLabel', {
                                    Image = ae.Icon('search')[1],
                                    ImageRectSize = ae.Icon('search')[2].ImageRectSize,
                                    ImageRectOffset = ae.Icon('search')[2].ImageRectPosition,
                                    BackgroundTransparency = 1,
                                    ThemeTag = {
                                        ImageColor3 = 'Icon',
                                    },
                                    ImageTransparency = 0.1,
                                    Size = UDim2.new(0, am.IconSize, 0, am.IconSize),
                                }),
                                an,
                                ao,
                                af('UIListLayout', {
                                    Padding = UDim.new(0, am.Padding),
                                    FillDirection = 'Horizontal',
                                    VerticalAlignment = 'Center',
                                }),
                                af('UIPadding', {
                                    PaddingLeft = UDim.new(0, am.Padding),
                                    PaddingRight = UDim.new(0, am.Padding),
                                }),
                            }),
                        }),
                        af('Frame', {
                            BackgroundTransparency = 1,
                            AutomaticSize = 'Y',
                            Size = UDim2.new(1, 0, 0, 0),
                            Name = 'Results',
                        }, {
                            af('Frame', {
                                Size = UDim2.new(1, 0, 0, 1),
                                ThemeTag = {
                                    BackgroundColor3 = 'Outline',
                                },
                                BackgroundTransparency = 0.9,
                                Visible = false,
                            }),
                            ap,
                            af('UISizeConstraint', {
                                MaxSize = Vector2.new(am.Width, am.MaxHeight),
                            }),
                        }),
                        af('UIListLayout', {
                            Padding = UDim.new(0, 0),
                            FillDirection = 'Vertical',
                        }),
                    }),
                })

                local ar = af('Frame', {
                    Size = UDim2.new(0, am.Width, 0, 0),
                    AutomaticSize = 'Y',
                    Parent = ak,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Visible = false,

                    ZIndex = 99999999,
                }, {
                    af('UIScale', {
                        Scale = 0.9,
                    }),
                    aq,
                    ae.NewRoundFrame(am.Radius, 'Glass-0.7', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,

                        ThemeTag = {
                            ImageColor3 = 'SearchBarBorder',
                            ImageTransparency = 'SearchBarBorderTransparency',
                        },
                        Name = 'Outline',
                    }),
                })

                local function CreateSearchTab(as, at, au, av, aw, ax)
                    local ay = af('TextButton', {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        BackgroundTransparency = 1,
                        Parent = av or nil,
                    }, {
                        ae.NewRoundFrame(am.Radius - 11, 'Squircle', {
                            Size = UDim2.new(1, 0, 0, 0),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),

                            ThemeTag = {
                                ImageColor3 = 'Text',
                            },
                            ImageTransparency = 1,
                            Name = 'Main',
                        }, {
                            ae.NewRoundFrame(am.Radius - 11, 'Glass-1', {
                                Size = UDim2.new(1, 0, 1, 0),
                                Position = UDim2.new(0.5, 0, 0.5, 0),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                ThemeTag = {
                                    ImageColor3 = 'White',
                                },
                                ImageTransparency = 1,
                                Name = 'Outline',
                            }, {

                                af('UIPadding', {
                                    PaddingTop = UDim.new(0, am.Padding - 2),
                                    PaddingLeft = UDim.new(0, am.Padding),
                                    PaddingRight = UDim.new(0, am.Padding),
                                    PaddingBottom = UDim.new(0, am.Padding - 2),
                                }),
                                af('ImageLabel', {
                                    Image = ae.Icon(au)[1],
                                    ImageRectSize = ae.Icon(au)[2].ImageRectSize,
                                    ImageRectOffset = ae.Icon(au)[2].ImageRectPosition,
                                    BackgroundTransparency = 1,
                                    ThemeTag = {
                                        ImageColor3 = 'Icon',
                                    },
                                    ImageTransparency = 0.1,
                                    Size = UDim2.new(0, am.IconSize, 0, am.IconSize),
                                }),
                                af('Frame', {
                                    Size = UDim2.new(1, -am.IconSize - am.Padding, 0, 0),
                                    BackgroundTransparency = 1,
                                }, {
                                    af('TextLabel', {
                                        Text = as,
                                        ThemeTag = {
                                            TextColor3 = 'Text',
                                        },
                                        TextSize = 17,
                                        BackgroundTransparency = 1,
                                        TextXAlignment = 'Left',
                                        FontFace = Font.new(ae.Font, Enum.FontWeight.Medium),
                                        Size = UDim2.new(1, 0, 0, 0),
                                        TextTruncate = 'AtEnd',
                                        AutomaticSize = 'Y',
                                        Name = 'Title',
                                    }),
                                    af('TextLabel', {
                                        Text = at or '',
                                        Visible = at and true or false,
                                        ThemeTag = {
                                            TextColor3 = 'Text',
                                        },
                                        TextSize = 15,
                                        TextTransparency = 0.3,
                                        BackgroundTransparency = 1,
                                        TextXAlignment = 'Left',
                                        FontFace = Font.new(ae.Font, Enum.FontWeight.Medium),
                                        Size = UDim2.new(1, 0, 0, 0),
                                        TextTruncate = 'AtEnd',
                                        AutomaticSize = 'Y',
                                        Name = 'Desc',
                                    }) or nil,
                                    af('UIListLayout', {
                                        Padding = UDim.new(0, 6),
                                        FillDirection = 'Vertical',
                                    }),
                                }),
                                af('UIListLayout', {
                                    Padding = UDim.new(0, am.Padding),
                                    FillDirection = 'Horizontal',
                                }),
                            }),
                        }, true),
                        af('Frame', {
                            Name = 'ParentContainer',
                            Size = UDim2.new(1, -am.Padding, 0, 0),
                            AutomaticSize = 'Y',
                            BackgroundTransparency = 1,
                            Visible = aw,
                        }, {
                            ae.NewRoundFrame(99, 'Squircle', {
                                Size = UDim2.new(0, 2, 1, 0),
                                BackgroundTransparency = 1,
                                ThemeTag = {
                                    ImageColor3 = 'Text',
                                },
                                ImageTransparency = 0.9,
                            }),
                            af('Frame', {
                                Size = UDim2.new(1, -am.Padding - 2, 0, 0),
                                Position = UDim2.new(0, am.Padding + 2, 0, 0),
                                BackgroundTransparency = 1,
                            }, {
                                af('UIListLayout', {
                                    Padding = UDim.new(0, 0),
                                    FillDirection = 'Vertical',
                                }),
                            }),
                        }),
                        af('UIListLayout', {
                            Padding = UDim.new(0, 0),
                            FillDirection = 'Vertical',
                            HorizontalAlignment = 'Right',
                        }),
                    })

                    ay.Main.Size = UDim2.new(
                        1,
                        0,
                        0,
                        ay.Main.Outline.Frame.Desc.Visible
                                and (((am.Padding - 2) * 2) + ay.Main.Outline.Frame.Title.TextBounds.Y + 6 + ay.Main.Outline.Frame.Desc.TextBounds.Y)
                            or (((am.Padding - 2) * 2) + ay.Main.Outline.Frame.Title.TextBounds.Y)
                    )

                    ae.AddSignal(ay.Main.MouseEnter, function()
                        ag(ay.Main, 0.04, { ImageTransparency = 0.95 }):Play()
                        ag(ay.Main.Outline, 0.04, { ImageTransparency = 0.75 }):Play()
                    end)
                    ae.AddSignal(ay.Main.InputEnded, function()
                        ag(ay.Main, 0.08, { ImageTransparency = 1 }):Play()
                        ag(ay.Main.Outline, 0.08, { ImageTransparency = 1 }):Play()
                    end)
                    ae.AddSignal(ay.Main.MouseButton1Click, function()
                        if ax then
                            ax()
                        end
                    end)

                    return ay
                end

                local function ContainsText(as, at)
                    if not at or at == '' then
                        return false
                    end

                    if not as or as == '' then
                        return false
                    end

                    local au = string.lower(as)
                    local av = string.lower(at)

                    return string.find(au, av, 1, true) ~= nil
                end

                local function Search(as)
                    if not as or as == '' then
                        return {}
                    end

                    local at = {}
                    for au, av in next, ai.Tabs do
                        local aw = ContainsText(av.Title or '', as)
                        local ax = {}

                        for ay, az in next, av.Elements do
                            if az.__type ~= 'Section' and az.__type ~= 'MultiSection' then
                                local aA = ContainsText(az.Title or '', as)
                                local aB = ContainsText(az.Desc or '', as)

                                if aA or aB then
                                    ax[ay] = {
                                        Title = az.Title,
                                        Desc = az.Desc,
                                        Original = az,
                                        __type = az.__type,
                                        Index = ay,
                                    }
                                end
                            end
                        end

                        if aw or next(ax) ~= nil then
                            at[au] = {
                                Tab = av,
                                Title = av.Title,
                                Icon = av.Icon,
                                Elements = ax,
                            }
                        end
                    end
                    return at
                end

                function am.Search(as, at)
                    at = at or ''

                    local au = Search(at)

                    ap.Visible = true
                    aq.Frame.Results.Frame.Visible = true
                    for av, aw in next, ap:GetChildren() do
                        if aw.ClassName ~= 'UIListLayout' and aw.ClassName ~= 'UIPadding' then
                            aw:Destroy()
                        end
                    end

                    if au and next(au) ~= nil then
                        for av, aw in next, au do
                            local ax = am.Icons.Tab
                            local ay = CreateSearchTab(aw.Title, nil, ax, ap, true, function()
                                am:Close()
                                ai:SelectTab(av)
                            end)
                            if aw.Elements and next(aw.Elements) ~= nil then
                                for az, aA in next, aw.Elements do
                                    local aB = am.Icons[aA.__type]
                                    CreateSearchTab(
                                        aA.Title,
                                        aA.Desc,
                                        aB,
                                        ay:FindFirstChild('ParentContainer') and ay.ParentContainer.Frame or nil,
                                        false,
                                        function()
                                            am:Close()
                                            ai:SelectTab(av)
                                            if aw.Tab.ScrollToTheElement then
                                                aw.Tab:ScrollToTheElement(aA.Index)
                                            end
                                        end
                                    )
                                end
                            end
                        end
                    elseif at ~= '' then
                        af('TextLabel', {
                            Size = UDim2.new(1, 0, 0, 70),
                            BackgroundTransparency = 1,
                            Text = 'No results found',
                            TextSize = 16,
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                            TextTransparency = 0.2,
                            BackgroundTransparency = 1,
                            FontFace = Font.new(ae.Font, Enum.FontWeight.Medium),
                            Parent = ap,
                            Name = 'NotFound',
                        })
                    else
                        ap.Visible = false
                        aq.Frame.Results.Frame.Visible = false
                    end
                end

                ae.AddSignal(an:GetPropertyChangedSignal('Text'), function()
                    am:Search(an.Text)
                end)

                ae.AddSignal(ap.UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'), function()
                    ag(
                        ap,
                        0.06,
                        {
                            Size = UDim2.new(
                                1,
                                0,
                                0,
                                math.clamp(ap.UIListLayout.AbsoluteContentSize.Y + (am.Padding * 2), 0, am.MaxHeight)
                            ),
                        },
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.InOut
                    ):Play()
                end)

                function am.Open(as)
                    task.spawn(function()
                        aq.Frame.Visible = true
                        ar.Visible = true
                        ag(ar.UIScale, 0.12, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end)
                end

                function am.Close(as, at)
                    task.spawn(function()
                        al()
                        aq.Frame.Visible = false
                        ag(ar.UIScale, 0.12, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                        task.wait(0.12)
                        ar.Visible = false
                        if at then
                            ar:Destroy()
                        end
                    end)
                end

                ae.AddSignal(ao.TextButton.MouseButton1Click, function()
                    am:Close(true)
                end)

                am:Open()

                return am
            end

            return ad
        end
        function WindUIModules.WindowModule(): typeof(buildModule())
            local aa = WindUIModules.cache.WindowModule
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.WindowModule = aa
            end
            return aa.c
        end
    end
    do
        local function buildModule()
            local aa = (cloneref or clonereference or function(aa)
                return aa
            end)

            local ad = aa(game:GetService('UserInputService'))
            local ae = aa(game:GetService('RunService'))
            local af = aa(game:GetService('Players'))

            local ag = WindUIModules.AcrylicModule()

            local ai = WindUIModules.LocalizationModule()
            local ak = ai.New
            local al = ai.Tween

            local function FindImageObject(am)
                if not am then
                    return nil
                end

                if am:IsA('ImageLabel') or am:IsA('ImageButton') then
                    return am
                end

                local an = am:FindFirstChild('ImageLabel')
                if an and (an:IsA('ImageLabel') or an:IsA('ImageButton')) then
                    return an
                end

                local ao = am:FindFirstChildWhichIsA('ImageLabel')
                if ao then
                    return ao
                end

                return am:FindFirstChildWhichIsA('ImageButton')
            end

            local function ResolveVideoTransparencyProperty(am)
                if not (am and am:IsA('VideoFrame')) then
                    return 'BackgroundTransparency'
                end

                local an = pcall(function()
                    local an = am.VideoTransparency
                end)

                return an and 'VideoTransparency' or 'BackgroundTransparency'
            end

            local function SetVideoTransparency(am, an)
                if not (am and am:IsA('VideoFrame')) then
                    return false
                end

                local ao = math.clamp(tonumber(an) or 0, 0, 1)
                local ap = ResolveVideoTransparencyProperty(am)
                local aq = pcall(function()
                    am[ap] = ao
                end)
                if aq then
                    return true
                end

                return pcall(function()
                    am.BackgroundTransparency = ao
                end)
            end

            local function TweenVideoTransparency(am, an, ao, ...)
                if not (am and am:IsA('VideoFrame')) then
                    return nil
                end

                local ap = math.clamp(tonumber(ao) or 0, 0, 1)
                local aq = ResolveVideoTransparencyProperty(am)

                local ar = {}
                ar[aq] = ap

                local as, at = pcall(al, am, an, ar, ...)

                if as then
                    return at
                end

                ar = {
                    BackgroundTransparency = ap,
                }

                as, at = pcall(al, am, an, ar, ...)

                return as and at or nil
            end

            local am = WindUIModules.PanelModule().New
            local an = WindUIModules.NotificationModule().New
            local ao = WindUIModules.SpaceModule().New
            local ap = WindUIModules.DividerModule()
            local aq = WindUIModules.TagModule()
            local ar = WindUIModules.WatermarkModule()
            local as = WindUIModules.ConfigManagerModule()

            local at = WindUIModules.OpenButtonModule()

            return function(au)
                local av = {
                    Title = au.Title or 'UI Library',
                    Author = au.Author,
                    Icon = au.Icon,
                    IconSize = au.IconSize or 22,
                    IconThemed = au.IconThemed,
                    IconRadius = au.IconRadius or 0,
                    Folder = au.Folder or au.ConfigFolder or 'Default',
                    ConfigName = au.ConfigName or 'default_config',
                    Resizable = au.Resizable ~= false,
                    Background = au.Background,
                    BackgroundVideo = au.BackgroundVideo,
                    BackgroundImageTransparency = au.BackgroundImageTransparency or 0,
                    ShadowTransparency = au.ShadowTransparency or 0.7,
                    User = au.User or {},
                    Footer = au.Footer or {},
                    Topbar = au.Topbar or { Height = 52, ButtonsType = 'Default' },

                    Size = au.Size,

                    MinSize = au.MinSize or Vector2.new(560, 350),
                    MaxSize = au.MaxSize or Vector2.new(850, 560),

                    TopBarButtonIconSize = au.TopBarButtonIconSize,

                    ToggleKey = au.ToggleKey,
                    ElementsRadius = au.ElementsRadius,
                    Radius = au.Radius or 16,
                    Transparent = au.Transparent or false,
                    HideSearchBar = au.HideSearchBar ~= false,
                    ScrollBarEnabled = au.ScrollBarEnabled or false,
                    SideBarWidth = au.SideBarWidth or 200,
                    Acrylic = au.Acrylic or false,
                    ModernLayout = au.ModernLayout or false,
                    ModernLayoutMergeElements = au.ModernLayoutMergeElements ~= false and au.ModernLayoutMerge ~= false,
                    IgnoreAlerts = au.IgnoreAlerts or false,
                    HidePanelBackground = au.HidePanelBackground or false,
                    AutoScale = au.AutoScale ~= false,
                    OpenButton = au.OpenButton,
                    BottomDragBarEnabled = not (au.BottomDragBarEnabled == false or au.BottomDragEnabled == false),
                    WatermarkConfig = au.Watermark,

                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    UICorner = nil,
                    UIPadding = 14,
                    UIElements = {},
                    CanDropdown = true,
                    Closed = false,
                    Parent = au.Parent,
                    Destroyed = false,
                    IsFullscreen = false,
                    CanResize = au.Resizable ~= false,
                    IsOpenButtonEnabled = true,

                    ConfigManager = nil,
                    AcrylicPaint = nil,
                    CurrentTab = nil,
                    TabModule = nil,
                    WatermarkObject = nil,

                    OnOpenCallback = nil,
                    OnCloseCallback = nil,
                    OnDestroyCallback = nil,

                    IsPC = false,

                    Gap = 5,

                    TopBarButtons = {},
                    AllElements = {},

                    ElementConfig = {},

                    FlagIndex = {},

                    Shortcuts = {},
                    ShortcutIndex = 0,

                    IsToggleDragging = false,
                }

                av.UICorner = av.Radius

                av.TopBarButtonIconSize = av.TopBarButtonIconSize or (av.Topbar.ButtonsType == 'Mac' and 11 or 16)

                av.ElementConfig = {
                    UIPadding = (av.ModernLayout and 10 or 13),
                    UICorner = av.ElementsRadius or (av.ModernLayout and 23 or 12),
                }

                local aw = av.Size or UDim2.new(0, 580, 0, 460)
                av.Size = UDim2.new(
                    aw.X.Scale,
                    math.clamp(aw.X.Offset, av.MinSize.X, av.MaxSize.X),
                    aw.Y.Scale,
                    math.clamp(aw.Y.Offset, av.MinSize.Y, av.MaxSize.Y)
                )

                if type(av.Topbar) ~= 'table' then
                    av.Topbar = {}
                end
                av.Topbar.Height = av.Topbar.Height or 52
                av.Topbar.ButtonsType = av.Topbar.ButtonsType or 'Default'

                if not ae:IsStudio() and av.Folder and writefile then
                    if not isfolder('WindUI_SY/' .. av.Folder) then
                        makefolder('WindUI_SY/' .. av.Folder)
                    end
                    if not isfolder('WindUI_SY/' .. av.Folder .. '/assets') then
                        makefolder('WindUI_SY/' .. av.Folder .. '/assets')
                    end
                    if not isfolder(av.Folder) then
                        makefolder(av.Folder)
                    end
                    if not isfolder(av.Folder .. '/assets') then
                        makefolder(av.Folder .. '/assets')
                    end
                end

                local ax = ak('UICorner', {
                    CornerRadius = UDim.new(0, av.UICorner),
                })

                av.ConfigManager = at:Init(av)

                if av.Acrylic then
                    local ay = ag.AcrylicPaint({ UseAcrylic = av.Acrylic })

                    av.AcrylicPaint = ay
                end

                local ay = ak('Frame', {
                    Size = UDim2.new(0, 32, 0, 32),
                    Position = UDim2.new(1, 0, 1, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    ZIndex = 99,
                    Active = true,
                }, {
                    ak('ImageLabel', {
                        Size = UDim2.new(0, 96, 0, 96),
                        BackgroundTransparency = 1,
                        Image = 'rbxassetid://120997033468887',
                        Position = UDim2.new(0.5, -16, 0.5, -16),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ImageTransparency = 1,
                    }),
                })
                local az = FindImageObject(ay)
                local aA = ai.NewRoundFrame(av.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 1,
                    ImageColor3 = Color3.new(0, 0, 0),
                    ZIndex = 98,
                    Active = false,
                }, {
                    ak('ImageLabel', {
                        Size = UDim2.new(0, 70, 0, 70),
                        Image = ai.Icon('expand')[1],
                        ImageRectOffset = ai.Icon('expand')[2].ImageRectPosition,
                        ImageRectSize = ai.Icon('expand')[2].ImageRectSize,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ImageTransparency = 1,
                    }),
                })

                local aB = ai.NewRoundFrame(av.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 1,
                    ImageColor3 = Color3.new(0, 0, 0),
                    ZIndex = 999,
                    Active = false,
                })

                av.UIElements.SideBar = ak('ScrollingFrame', {
                    Size = UDim2.new(
                        1,
                        av.ScrollBarEnabled and -3 - (av.UIPadding / 2) or 0,
                        1,
                        not av.HideSearchBar and -45 or 0
                    ),
                    Position = UDim2.new(0, 0, 1, 0),
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 0,
                    ElasticBehavior = 'Never',
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = 'Y',
                    ScrollingDirection = 'Y',
                    ClipsDescendants = true,
                    VerticalScrollBarPosition = 'Left',
                }, {
                    ak('Frame', {
                        BackgroundTransparency = 1,
                        AutomaticSize = 'Y',
                        Size = UDim2.new(1, 0, 0, 0),
                        Name = 'Frame',
                    }, {
                        ak('UIPadding', {

                            PaddingBottom = UDim.new(0, av.UIPadding / 2),
                        }),
                        ak('UIListLayout', {
                            SortOrder = 'LayoutOrder',
                            Padding = UDim.new(0, av.Gap),
                        }),
                    }),
                    ak('UIPadding', {

                        PaddingLeft = UDim.new(0, av.UIPadding / 2),
                        PaddingRight = UDim.new(0, av.UIPadding / 2),
                    }),
                })

                av.UIElements.SideBarContainer = ak('Frame', {
                    Size = UDim2.new(
                        0,
                        av.SideBarWidth,
                        1,
                        av.User.Enabled and -av.Topbar.Height - 42 - (av.UIPadding * 2) or -av.Topbar.Height
                    ),
                    Position = UDim2.new(0, 0, 0, av.Topbar.Height),
                    BackgroundTransparency = 1,
                    Visible = true,
                }, {
                    ak('Frame', {
                        Name = 'Content',
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, not av.HideSearchBar and -45 - av.UIPadding / 2 or 0),
                        Position = UDim2.new(0, 0, 1, 0),
                        AnchorPoint = Vector2.new(0, 1),
                    }),
                    av.UIElements.SideBar,
                })

                if av.ScrollBarEnabled then
                    ao(av.UIElements.SideBar, av.UIElements.SideBarContainer.Content, av, 3)
                end

                av.UIElements.MainBar = ak('Frame', {
                    Size = UDim2.new(1, -av.UIElements.SideBarContainer.AbsoluteSize.X, 1, -av.Topbar.Height),
                    Position = UDim2.new(1, 0, 1, 0),
                    AnchorPoint = Vector2.new(1, 1),
                    BackgroundTransparency = 1,
                }, {
                    ai.NewRoundFrame(av.UICorner - (av.UIPadding / 2), 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = {
                            ImageColor3 = 'PanelBackground',
                            ImageTransparency = 'PanelBackgroundTransparency',
                        },

                        ZIndex = 3,
                        Name = 'Background',
                        Visible = not av.HidePanelBackground,
                    }),
                    ak('UIPadding', {

                        PaddingLeft = UDim.new(0, av.UIPadding / 2),
                        PaddingRight = UDim.new(0, av.UIPadding / 2),
                        PaddingBottom = UDim.new(0, av.UIPadding / 2),
                    }),
                })

                local b = ak('ImageLabel', {
                    Image = 'rbxassetid://8992230677',
                    ThemeTag = {
                        ImageColor3 = 'WindowShadow',
                    },
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 120, 1, 116),
                    Position = UDim2.new(0, -60, 0, -58),
                    ScaleType = 'Slice',
                    SliceCenter = Rect.new(99, 99, 99, 99),
                    BackgroundTransparency = 1,
                    ZIndex = -999999999999999,
                    Name = 'Blur',
                })

                if ad.TouchEnabled and not ad.KeyboardEnabled then
                    av.IsPC = false
                elseif ad.KeyboardEnabled then
                    av.IsPC = true
                else
                    av.IsPC = nil
                end

                local d
                if av.User then
                    local function GetUserThumb()
                        local f = af:GetUserThumbnailAsync(
                            av.User.Anonymous and 1 or af.LocalPlayer.UserId,
                            Enum.ThumbnailType.HeadShot,
                            Enum.ThumbnailSize.Size420x420
                        )
                        return f
                    end

                    d = ak('TextButton', {
                        Size = UDim2.new(
                            0,
                            av.UIElements.SideBarContainer.AbsoluteSize.X - (av.UIPadding / 2),
                            0,
                            42 + av.UIPadding
                        ),
                        Position = UDim2.new(0, av.UIPadding / 2, 1, -(av.UIPadding / 2)),
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundTransparency = 1,
                        Visible = av.User.Enabled or false,
                    }, {
                        ai.NewRoundFrame(av.UICorner - (av.UIPadding / 2), 'SquircleOutline', {
                            Size = UDim2.new(1, 0, 1, 0),
                            ThemeTag = {
                                ImageColor3 = 'Text',
                            },
                            ImageTransparency = 1,
                            Name = 'Outline',
                        }, {
                            ak('UIGradient', {
                                Rotation = 78,
                                Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                                    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
                                }),
                                Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0.0, 0.1),
                                    NumberSequenceKeypoint.new(0.5, 1),
                                    NumberSequenceKeypoint.new(1.0, 0.1),
                                }),
                            }),
                        }),
                        ai.NewRoundFrame(av.UICorner - (av.UIPadding / 2), 'Squircle', {
                            Size = UDim2.new(1, 0, 1, 0),
                            ThemeTag = {
                                ImageColor3 = 'Text',
                            },
                            ImageTransparency = 1,
                            Name = 'UserIcon',
                        }, {
                            ak('ImageLabel', {
                                Image = GetUserThumb(),
                                BackgroundTransparency = 1,
                                Size = UDim2.new(0, 42, 0, 42),
                                ThemeTag = {
                                    BackgroundColor3 = 'Text',
                                },
                                BackgroundTransparency = 0.93,
                            }, {
                                ak('UICorner', {
                                    CornerRadius = UDim.new(1, 0),
                                }),
                            }),
                            ak('Frame', {
                                AutomaticSize = 'XY',
                                BackgroundTransparency = 1,
                            }, {
                                ak('TextLabel', {
                                    Text = av.User.Anonymous and 'Anonymous' or af.LocalPlayer.DisplayName,
                                    TextSize = 17,
                                    ThemeTag = {
                                        TextColor3 = 'Text',
                                    },
                                    FontFace = Font.new(ai.Font, Enum.FontWeight.SemiBold),
                                    AutomaticSize = 'Y',
                                    BackgroundTransparency = 1,
                                    Size = UDim2.new(1, -27, 0, 0),
                                    TextTruncate = 'AtEnd',
                                    TextXAlignment = 'Left',
                                    Name = 'DisplayName',
                                }),
                                ak('TextLabel', {
                                    Text = av.User.Anonymous and 'anonymous' or af.LocalPlayer.Name,
                                    TextSize = 15,
                                    TextTransparency = 0.6,
                                    ThemeTag = {
                                        TextColor3 = 'Text',
                                    },
                                    FontFace = Font.new(ai.Font, Enum.FontWeight.Medium),
                                    AutomaticSize = 'Y',
                                    BackgroundTransparency = 1,
                                    Size = UDim2.new(1, -27, 0, 0),
                                    TextTruncate = 'AtEnd',
                                    TextXAlignment = 'Left',
                                    Name = 'UserName',
                                }),
                                ak('UIListLayout', {
                                    Padding = UDim.new(0, 4),
                                    HorizontalAlignment = 'Left',
                                }),
                            }),
                            ak('UIListLayout', {
                                Padding = UDim.new(0, av.UIPadding),
                                FillDirection = 'Horizontal',
                                VerticalAlignment = 'Center',
                            }),
                            ak('UIPadding', {
                                PaddingLeft = UDim.new(0, av.UIPadding / 2),
                                PaddingRight = UDim.new(0, av.UIPadding / 2),
                            }),
                        }),
                    })

                    function av.User.Enable(f)
                        av.User.Enabled = true
                        al(
                            av.UIElements.SideBarContainer,
                            0.25,
                            { Size = UDim2.new(0, av.SideBarWidth, 1, -av.Topbar.Height - 42 - (av.UIPadding * 2)) },
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ):Play()
                        d.Visible = true
                    end
                    function av.User.Disable(f)
                        av.User.Enabled = false
                        al(
                            av.UIElements.SideBarContainer,
                            0.25,
                            { Size = UDim2.new(0, av.SideBarWidth, 1, -av.Topbar.Height) },
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ):Play()
                        d.Visible = false
                    end
                    function av.User.SetAnonymous(f, g)
                        if g ~= false then
                            g = true
                        end
                        av.User.Anonymous = g
                        local h = FindImageObject(d.UserIcon)
                        if h then
                            h.Image = GetUserThumb()
                        end
                        d.UserIcon.Frame.DisplayName.Text = g and 'Anonymous' or af.LocalPlayer.DisplayName
                        d.UserIcon.Frame.UserName.Text = g and 'anonymous' or af.LocalPlayer.Name
                    end

                    if av.User.Enabled then
                        av.User:Enable()
                    else
                        av.User:Disable()
                    end

                    if av.User.Callback then
                        ai.AddSignal(d.MouseButton1Click, function()
                            av.User.Callback()
                        end)
                        ai.AddSignal(d.MouseEnter, function()
                            al(d.UserIcon, 0.04, { ImageTransparency = 0.95 }):Play()
                            al(d.Outline, 0.04, { ImageTransparency = 0.85 }):Play()
                        end)
                        ai.AddSignal(d.InputEnded, function()
                            al(d.UserIcon, 0.04, { ImageTransparency = 1 }):Play()
                            al(d.Outline, 0.04, { ImageTransparency = 1 }):Play()
                        end)
                    end
                end

                local f
                local g
                local h

                local j = false
                local l
                local m = av.Folder or au.Title or 'Temp'

                local function EnsureAssetFolder()
                    if ae:IsStudio() or not writefile then
                        return
                    end

                    if not isfolder(m) then
                        makefolder(m)
                    end
                    if not isfolder(m .. '/assets') then
                        makefolder(m .. '/assets')
                    end
                end

                local function GetImageExtension(p)
                    local r = p:match('%.(%w+)$') or p:match('%.(%w+)%?')
                    if r then
                        r = r:lower()
                        if r == 'jpg' or r == 'jpeg' or r == 'png' or r == 'webp' then
                            return '.' .. r
                        end
                    end
                    return '.png'
                end

                local function NormalizeVideo(p)
                    if type(p) == 'number' then
                        p = tostring(p)
                    end

                    if type(p) ~= 'string' then
                        return nil
                    end

                    p = p:gsub('^video:', '')
                    if p == '' then
                        return nil
                    end

                    if string.match(p, '^%d+$') then
                        return 'rbxassetid://' .. p
                    end

                    return p
                end

                local function ResolveVideoSource(p)
                    local r = NormalizeVideo(p)
                    if not r then
                        return nil
                    end

                    if string.find(r, 'http') then
                        if not (writefile and isfile and getcustomasset) then
                            warn('[ WindUI.Window.Background ] Missing file functions for remote video, using raw URL')
                            return r
                        end

                        EnsureAssetFolder()
                        local u = m .. '/assets/.' .. ai.SanitizeFilename(r) .. '.webm'
                        if not isfile(u) then
                            local v, x = pcall(function()
                                local v = ai.Request({ Url = r, Method = 'GET', Headers = {
                                    ['User-Agent'] = 'Roblox/Exploit',
                                } })
                                writefile(u, v.Body)
                            end)
                            if not v then
                                warn('[ WindUI.Window.Background ] Failed to download video: ' .. tostring(x))
                                return nil
                            end
                        end

                        local v, x = pcall(function()
                            return getcustomasset(u)
                        end)
                        if not v then
                            warn('[ WindUI.Window.Background ] Failed to load custom asset: ' .. tostring(x))
                            return nil
                        end

                        warn('[ WindUI.Window.Background ] VideoFrame may not work with custom video')
                        return x
                    end

                    return r
                end

                local function ResolveImageSource(p)
                    if type(p) == 'number' then
                        p = tostring(p)
                    end

                    if type(p) ~= 'string' or p == '' then
                        return nil
                    end

                    if string.match(p, '^%d+$') then
                        p = 'rbxassetid://' .. p
                    end

                    if not string.match(p, '^https?://.+') then
                        return p
                    end

                    if not (writefile and isfile and getcustomasset) then
                        warn('[ WindUI.Window.Background ] Missing file functions for remote image, using raw URL')
                        return p
                    end

                    EnsureAssetFolder()
                    local r = m .. '/assets/.' .. ai.SanitizeFilename(p) .. GetImageExtension(p)
                    if not isfile(r) then
                        local u, v = pcall(function()
                            local u =
                                ai.Request({ Url = p, Method = 'GET', Headers = { ['User-Agent'] = 'Roblox/Exploit' } })
                            writefile(r, u.Body)
                        end)
                        if not u then
                            warn('[ Window.Background ] Failed to download image: ' .. tostring(v))
                            return nil
                        end
                    end

                    local u, v = pcall(function()
                        return getcustomasset(r)
                    end)
                    if not u then
                        warn('[ Window.Background ] Failed to load custom asset: ' .. tostring(v))
                        return nil
                    end

                    return v
                end

                local function CreateBackgroundVideo(p)
                    local r = ResolveVideoSource(p)
                    if not r then
                        return nil
                    end

                    local u = av.Closed and 1 or 0
                    local v = ak('VideoFrame', {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Video = r,
                        Looped = true,
                        Volume = 0,
                    }, {
                        ak('UICorner', {
                            CornerRadius = UDim.new(0, av.UICorner),
                        }),
                    })

                    SetVideoTransparency(v, u)
                    v:Play()
                    return v
                end

                local function CreateBackgroundImage(p, r)
                    local u = ResolveImageSource(p)
                    if not u then
                        return nil
                    end

                    return ak('ImageLabel', {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Image = u,
                        ImageTransparency = r,
                        ScaleType = 'Crop',
                    }, {
                        ak('UICorner', {
                            CornerRadius = UDim.new(0, av.UICorner),
                        }),
                    })
                end

                local function SetBackgroundMedia(p, r)
                    if l and l ~= p then
                        l:Destroy()
                    end

                    l = p
                    j = r == true

                    if
                        l
                        and av.UIElements
                        and av.UIElements.Main
                        and av.UIElements.Main:FindFirstChild('Background')
                    then
                        l.Parent = av.UIElements.Main.Background
                    end
                end

                local p = av.BackgroundVideo
                if not p and typeof(av.Background) == 'string' then
                    p = string.match(av.Background, '^video:(.+)')
                end

                if p then
                    local r = CreateBackgroundVideo(p)
                    if r then
                        av.BackgroundVideo = NormalizeVideo(p)
                        SetBackgroundMedia(r, true)
                    end
                elseif typeof(av.Background) == 'string' and av.Background ~= '' then
                    local r = string.match(av.Background, '^https?://.+') ~= nil
                    local u = CreateBackgroundImage(av.Background, r and 0 or 1)
                    if u then
                        SetBackgroundMedia(u, false)
                    end
                end

                local r = ai.NewRoundFrame(99, 'Squircle', {
                    ImageTransparency = 0.8,
                    ImageColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(0, 0, 0, 4),
                    Position = UDim2.new(0.5, 0, 1, 4),
                    AnchorPoint = Vector2.new(0.5, 0),
                    Visible = av.BottomDragBarEnabled,
                }, {
                    ak('TextButton', {
                        Size = UDim2.new(1, 12, 1, 12),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Active = av.BottomDragBarEnabled,
                        ZIndex = 99,
                        Name = 'Frame',
                    }),
                })

                function createAuthor(u)
                    return ak('TextLabel', {
                        Text = u,
                        FontFace = Font.new(ai.Font, Enum.FontWeight.Medium),
                        BackgroundTransparency = 1,
                        TextTransparency = 0.35,
                        AutomaticSize = 'XY',
                        Parent = av.UIElements.Main and av.UIElements.Main.Main.Topbar.Left.Title,
                        TextXAlignment = 'Left',
                        TextSize = 13,
                        LayoutOrder = 2,
                        ThemeTag = {
                            TextColor3 = 'WindowTopbarAuthor',
                        },
                        Name = 'Author',
                    })
                end

                local u
                local v

                if av.Author then
                    u = createAuthor(av.Author)
                end

                local x = ak('TextLabel', {
                    Text = av.Title,
                    FontFace = Font.new(ai.Font, Enum.FontWeight.SemiBold),
                    BackgroundTransparency = 1,
                    AutomaticSize = 'XY',
                    Name = 'Title',
                    TextXAlignment = 'Left',
                    TextSize = 16,
                    ThemeTag = {
                        TextColor3 = 'WindowTopbarTitle',
                    },
                })

                av.UIElements.Main = ak('Frame', {
                    Size = av.Size,
                    Position = av.Position,
                    BackgroundTransparency = 1,
                    Parent = au.Parent,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Active = true,
                }, {
                    au.WindUI.UIScaleObj,
                    av.AcrylicPaint and av.AcrylicPaint.Frame or nil,
                    b,
                    ai.NewRoundFrame(av.UICorner, 'Squircle', {
                        ImageTransparency = 1,
                        Size = UDim2.new(1, 0, 1, -240),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Name = 'Background',
                        ThemeTag = {
                            ImageColor3 = 'WindowBackground',
                        },
                    }, {
                        l,
                        r,
                        ay,
                    }),
                    h,
                    ax,
                    aA,
                    aB,
                    ak('Frame', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Name = 'Main',

                        Visible = false,
                        ZIndex = 97,
                    }, {
                        ak('UICorner', {
                            CornerRadius = UDim.new(0, av.UICorner),
                        }),
                        av.UIElements.SideBarContainer,
                        av.UIElements.MainBar,

                        d,

                        g,
                        ak('Frame', {
                            Size = UDim2.new(1, 0, 0, av.Topbar.Height),
                            BackgroundTransparency = 1,
                            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                            Name = 'Topbar',
                        }, {
                            f,

                            ak('Frame', {
                                AutomaticSize = 'X',
                                Size = UDim2.new(0, 0, 1, 0),
                                BackgroundTransparency = 1,
                                Name = 'Left',
                            }, {
                                ak('UIListLayout', {
                                    Padding = UDim.new(0, av.UIPadding + 4),
                                    SortOrder = 'LayoutOrder',
                                    FillDirection = 'Horizontal',
                                    VerticalAlignment = 'Center',
                                }),
                                ak('Frame', {
                                    AutomaticSize = 'XY',
                                    BackgroundTransparency = 1,
                                    Name = 'Title',
                                    Size = UDim2.new(0, 0, 1, 0),
                                    LayoutOrder = 2,
                                }, {
                                    ak('UIListLayout', {
                                        Padding = UDim.new(0, 0),
                                        SortOrder = 'LayoutOrder',
                                        FillDirection = 'Vertical',
                                        VerticalAlignment = 'Center',
                                    }),
                                    x,
                                    u,
                                }),
                                ak('UIPadding', {
                                    PaddingLeft = UDim.new(0, 4),
                                }),
                            }),
                            ak('ScrollingFrame', {
                                Name = 'Center',
                                BackgroundTransparency = 1,
                                AutomaticSize = 'Y',
                                ScrollBarThickness = 0,
                                ScrollingDirection = 'X',
                                AutomaticCanvasSize = 'X',
                                CanvasSize = UDim2.new(0, 0, 0, 0),
                                Size = UDim2.new(0, 0, 1, 0),
                                AnchorPoint = Vector2.new(0, 0.5),
                                Position = UDim2.new(0, 0, 0.5, 0),
                                Visible = false,
                            }, {
                                ak('UIListLayout', {
                                    FillDirection = 'Horizontal',
                                    VerticalAlignment = 'Center',
                                    HorizontalAlignment = 'Left',
                                    Padding = UDim.new(0, av.UIPadding / 2),
                                }),
                            }),
                            ak('Frame', {
                                AutomaticSize = 'XY',
                                BackgroundTransparency = 1,
                                Position = UDim2.new(av.Topbar.ButtonsType == 'Default' and 1 or 0, 0, 0.5, 0),
                                AnchorPoint = Vector2.new(av.Topbar.ButtonsType == 'Default' and 1 or 0, 0.5),
                                Name = 'Right',
                            }, {
                                ak('UIListLayout', {
                                    Padding = UDim.new(0, av.Topbar.ButtonsType == 'Default' and 9 or 0),
                                    FillDirection = 'Horizontal',
                                    SortOrder = 'LayoutOrder',
                                }),
                            }),
                            ak('UIPadding', {
                                PaddingTop = UDim.new(0, av.UIPadding),
                                PaddingLeft = UDim.new(
                                    0,
                                    av.Topbar.ButtonsType == 'Default' and av.UIPadding or av.UIPadding - 2
                                ),
                                PaddingRight = UDim.new(0, 8),
                                PaddingBottom = UDim.new(0, av.UIPadding),
                            }),
                        }),
                    }),
                })

                ai.AddSignal(av.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal('AbsoluteSize'), function()
                    local z = 0
                    local A = av.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X
                        / au.WindUI.UIScale

                    z = av.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X / au.WindUI.UIScale
                    if av.Topbar.ButtonsType ~= 'Default' then
                        z = z + A + av.UIPadding - 4
                    end

                    av.UIElements.Main.Main.Topbar.Center.Position =
                        UDim2.new(0, z + (av.UIPadding / au.WindUI.UIScale), 0.5, 0)
                    av.UIElements.Main.Main.Topbar.Center.Size =
                        UDim2.new(1, -z - A - ((av.UIPadding * 2) / au.WindUI.UIScale), 1, 0)
                end)

                if av.Topbar.ButtonsType ~= 'Default' then
                    ai.AddSignal(
                        av.UIElements.Main.Main.Topbar.Right:GetPropertyChangedSignal('AbsoluteSize'),
                        function()
                            av.UIElements.Main.Main.Topbar.Left.Position = UDim2.new(
                                0,
                                (av.UIElements.Main.Main.Topbar.Right.AbsoluteSize.X / au.WindUI.UIScale)
                                    + av.UIPadding
                                    - 4,
                                0,
                                0
                            )
                        end
                    )
                end

                function av.CreateTopbarButton(z, A, B, C, F, G, H, J)
                    local L = ai.Image(
                        B,
                        B,
                        0,
                        av.Folder,
                        'WindowTopbarIcon',
                        av.Topbar.ButtonsType == 'Default' and true or false,
                        G,
                        'WindowTopbarButtonIcon'
                    )
                    L.Size = av.Topbar.ButtonsType == 'Default'
                            and UDim2.new(0, J or av.TopBarButtonIconSize, 0, J or av.TopBarButtonIconSize)
                        or UDim2.new(0, 0, 0, 0)
                    L.AnchorPoint = Vector2.new(0.5, 0.5)
                    L.Position = UDim2.new(0.5, 0, 0.5, 0)
                    local M = FindImageObject(L)
                    if M then
                        M.ImageTransparency = av.Topbar.ButtonsType == 'Default' and 0 or 1
                    end
                    if av.Topbar.ButtonsType ~= 'Default' and M then
                        M.ImageColor3 = ai.GetTextColorForHSB(H)
                    end

                    local N = ai.NewRoundFrame(
                        av.Topbar.ButtonsType == 'Default' and av.UICorner - (av.UIPadding / 2) or 999,
                        'Squircle',
                        {
                            Size = av.Topbar.ButtonsType == 'Default'
                                    and UDim2.new(0, av.Topbar.Height - 16, 0, av.Topbar.Height - 16)
                                or UDim2.new(0, 14, 0, 14),
                            LayoutOrder = F or 999,
                            Parent = av.Topbar.ButtonsType == 'Default' and av.UIElements.Main.Main.Topbar.Right or nil,

                            ZIndex = 9999,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            ImageColor3 = av.Topbar.ButtonsType ~= 'Default' and (H or Color3.fromHex('#ff3030'))
                                or nil,
                            ThemeTag = av.Topbar.ButtonsType == 'Default' and {
                                ImageColor3 = 'Text',
                            } or nil,
                            ImageTransparency = av.Topbar.ButtonsType == 'Default' and 1 or 0,
                        },
                        {
                            ai.NewRoundFrame(
                                av.Topbar.ButtonsType == 'Default' and av.UICorner - (av.UIPadding / 2) or 999,
                                'SquircleOutline',
                                {
                                    Size = UDim2.new(1, 0, 1, 0),
                                    ThemeTag = {
                                        ImageColor3 = 'Black',
                                    },
                                    ImageTransparency = av.Topbar.ButtonsType == 'Default' and 1 or 0.8,
                                    Name = 'Outline',
                                },
                                {
                                    av.Topbar.ButtonsType == 'Default'
                                            and ak('UIGradient', {
                                                Rotation = 45,
                                                Color = ColorSequence.new({
                                                    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                                                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                                                    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
                                                }),
                                                Transparency = NumberSequence.new({
                                                    NumberSequenceKeypoint.new(0.0, 0.1),
                                                    NumberSequenceKeypoint.new(0.5, 1),
                                                    NumberSequenceKeypoint.new(1.0, 0.1),
                                                }),
                                            })
                                        or nil,
                                }
                            ),
                            L,
                        },
                        true
                    )

                    ak('Frame', {
                        Size = UDim2.new(0, 24, 0, 24),
                        BackgroundTransparency = 1,
                        Parent = av.Topbar.ButtonsType ~= 'Default' and av.UIElements.Main.Main.Topbar.Right or nil,
                        LayoutOrder = F or 999,
                    }, {
                        av.Topbar.ButtonsType ~= 'Default' and N or nil,
                    })

                    av.TopBarButtons[100 - F] = {
                        Name = A,
                        Object = N,
                    }

                    ai.AddSignal(N.MouseButton1Click, function()
                        C()
                    end)
                    ai.AddSignal(N.MouseEnter, function()
                        if av.Topbar.ButtonsType == 'Default' then
                            al(N, 0.15, { ImageTransparency = 0.93 }):Play()
                            al(N.Outline, 0.15, { ImageTransparency = 0.75 }):Play()
                        else
                            if M then
                                al(M, 0.1, { ImageTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                            end
                            al(
                                L,
                                0.1,
                                { Size = UDim2.new(0, J or av.TopBarButtonIconSize, 0, J or av.TopBarButtonIconSize) },
                                Enum.EasingStyle.Quint,
                                Enum.EasingDirection.Out
                            ):Play()
                        end
                    end)
                    ai.AddSignal(N.InputEnded, function()
                        if av.Topbar.ButtonsType == 'Default' then
                            al(N, 0.1, { ImageTransparency = 1 }):Play()
                            al(N.Outline, 0.1, { ImageTransparency = 1 }):Play()
                        else
                            if M then
                                al(M, 0.1, { ImageTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                            end
                            al(
                                L,
                                0.1,
                                { Size = UDim2.new(0, 0, 0, 0) },
                                Enum.EasingStyle.Quint,
                                Enum.EasingDirection.Out
                            ):Play()
                        end
                    end)

                    return N
                end

                local z = ai.Drag(av.UIElements.Main, { av.UIElements.Main.Main.Topbar, r.Frame }, function(z, A)
                    if not av.Closed then
                        if av.BottomDragBarEnabled then
                            if z and A == r.Frame then
                                al(r, 0.1, { ImageTransparency = 0.35 }):Play()
                            else
                                al(r, 0.2, { ImageTransparency = 0.8 }):Play()
                            end
                        end
                        av.Position = av.UIElements.Main.Position
                        av.Dragging = z
                    end
                end)

                if not j and av.Background and typeof(av.Background) == 'table' then
                    local A = ak('UIGradient')
                    for B, C in next, av.Background do
                        A[B] = C
                    end

                    av.UIElements.BackgroundGradient = ai.NewRoundFrame(av.UICorner, 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Parent = av.UIElements.Main.Background,
                        ImageTransparency = av.Transparent and au.WindUI.TransparencyValue or 0,
                    }, {
                        A,
                    })
                end

                av.OpenButtonMain = WindUIModules.TooltipModule().New(av)

                task.spawn(function()
                    if av.Icon then
                        local A = ak('Frame', {
                            Size = UDim2.new(0, 22, 0, 22),
                            BackgroundTransparency = 1,
                            Parent = av.UIElements.Main.Main.Topbar.Left,
                        })

                        v = ai.Image(
                            av.Icon,
                            av.Title,
                            av.IconRadius,
                            av.Folder,
                            'Window',
                            true,
                            av.IconThemed,
                            'WindowTopbarIcon'
                        )
                        v.Parent = A
                        v.Size = UDim2.new(0, av.IconSize, 0, av.IconSize)
                        v.Position = UDim2.new(0.5, 0, 0.5, 0)
                        v.AnchorPoint = Vector2.new(0.5, 0.5)

                        av.OpenButtonMain:SetIcon(av.Icon)
                    else
                        av.OpenButtonMain:SetIcon(av.Icon)
                    end
                end)

                function av.SetToggleKey(A, B)
                    av.ToggleKey = B
                end

                function av.SetTitle(A, B)
                    av.Title = B
                    x.Text = B
                end

                function av.SetAuthor(A, B)
                    av.Author = B
                    if not u then
                        u = createAuthor(av.Author)
                    end

                    u.Text = B
                end

                function av.SetSize(A, B)
                    if typeof(B) == 'UDim2' then
                        local C = UDim2.new(
                            B.X.Scale,
                            math.clamp(B.X.Offset, av.MinSize.X, av.MaxSize.X),
                            B.Y.Scale,
                            math.clamp(B.Y.Offset, av.MinSize.Y, av.MaxSize.Y)
                        )

                        av.Size = C

                        al(av.UIElements.Main, 0.08, { Size = C }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                    return av
                end

                function av.SetBackgroundVideo(A, B)
                    local C = NormalizeVideo(B)
                    if not C then
                        return false
                    end

                    local F = CreateBackgroundVideo(C)
                    if not F then
                        return false
                    end

                    av.BackgroundVideo = C
                    av.Background = 'video:' .. C

                    SetBackgroundMedia(F, true)
                    l.Visible = not av.Closed
                    SetVideoTransparency(l, av.Closed and 1 or 0)

                    return true
                end

                function av.SetBackgroundImage(A, B)
                    if type(B) == 'number' then
                        B = tostring(B)
                    end

                    if type(B) ~= 'string' or B == '' then
                        return false
                    end

                    local C = av.Closed and 1 or av.BackgroundImageTransparency
                    local F = CreateBackgroundImage(B, C)
                    if not F then
                        return false
                    end

                    av.Background = B
                    av.BackgroundVideo = nil

                    SetBackgroundMedia(F, false)
                    l.Visible = not av.Closed

                    return true
                end
                function av.SetBackgroundImageTransparency(A, B)
                    local C = tonumber(B)
                    if not C then
                        return false
                    end

                    local F = math.clamp(math.floor(C * 10 + 0.5) / 10, 0, 1)
                    if l and l:IsA('ImageLabel') then
                        l.ImageTransparency = F
                    end
                    av.BackgroundImageTransparency = F
                    return true
                end

                function av.SetBackgroundTransparency(A, B)
                    local C = tonumber(B)
                    if not C then
                        return false
                    end

                    local F = math.clamp(math.floor(C * 10 + 0.5) / 10, 0, 1)
                    au.WindUI.TransparencyValue = F
                    av:ToggleTransparency(F > 0)
                    return true
                end

                local A
                local B
                ai.Icon('minimize')
                ai.Icon('maximize')

                av:CreateTopbarButton(
                    'Fullscreen',
                    av.Topbar.ButtonsType == 'Mac' and 'rbxassetid://127426072704909' or 'maximize',
                    function()
                        av:ToggleFullscreen()
                    end,
                    (av.Topbar.ButtonsType == 'Default' and 998 or 999),
                    true,
                    Color3.fromHex('#60C762'),
                    av.Topbar.ButtonsType == 'Mac' and 9 or nil
                )

                function av.ToggleFullscreen(C)
                    local F = av.IsFullscreen

                    z:Set(F)

                    if not F then
                        A = av.UIElements.Main.Position
                        B = av.UIElements.Main.Size

                        av.CanResize = false
                    else
                        if av.Resizable then
                            av.CanResize = true
                        end
                    end

                    al(
                        av.UIElements.Main,
                        0.45,
                        { Size = F and B or UDim2.new(1, -20, 1, -72) },
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ):Play()

                    al(
                        av.UIElements.Main,
                        0.45,
                        { Position = F and A or UDim2.new(0.5, 0, 0.5, 26) },
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ):Play()

                    av.IsFullscreen = not F
                end

                av:CreateTopbarButton('Minimize', 'minus', function()
                    av:Close()
                end, (av.Topbar.ButtonsType == 'Default' and 997 or 998), nil, Color3.fromHex('#F4C948'))

                function av.OnOpen(C, F)
                    av.OnOpenCallback = F
                end
                function av.OnClose(C, F)
                    av.OnCloseCallback = F
                end
                function av.OnDestroy(C, F)
                    av.OnDestroyCallback = F
                end

                if av.Acrylic and av.AcrylicPaint and av.AcrylicPaint.AddParent then
                    av.AcrylicPaint.AddParent(av.UIElements.Main)
                end

                function av.SetIconSize(C, F)
                    local G
                    if typeof(F) == 'number' then
                        G = UDim2.new(0, F, 0, F)
                        av.IconSize = F
                    elseif typeof(F) == 'UDim2' then
                        G = F
                        av.IconSize = F.X.Offset
                    end

                    if v then
                        v.Size = G
                    end
                end

                function av.Open(C)
                    task.spawn(function()
                        if av.OnOpenCallback then
                            task.spawn(function()
                                ai.SafeCallback(av.OnOpenCallback)
                            end)
                        end

                        task.wait(0.06)
                        av.Closed = false

                        al(av.UIElements.Main.Background, 0.2, {
                            ImageTransparency = av.Transparent and au.WindUI.TransparencyValue or 0,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                        if av.UIElements.BackgroundGradient then
                            al(av.UIElements.BackgroundGradient, 0.2, {
                                ImageTransparency = 0,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end

                        al(av.UIElements.Main.Background, 0.4, {
                            Size = UDim2.new(1, 0, 1, 0),
                        }, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out):Play()

                        if l then
                            if l:IsA('VideoFrame') then
                                l.Visible = true
                                local F =
                                    TweenVideoTransparency(l, 0.2, 0, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                                if F then
                                    F:Play()
                                end
                            else
                                al(l, 0.2, {
                                    ImageTransparency = av.BackgroundImageTransparency,
                                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                            end
                        end

                        if av.OpenButtonMain and av.IsOpenButtonEnabled then
                            av.OpenButtonMain:Visible(false)
                        end

                        al(
                            b,
                            0.25,
                            { ImageTransparency = av.ShadowTransparency },
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ):Play()
                        if h then
                            al(h, 0.25, { Transparency = 0.8 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end

                        task.spawn(function()
                            task.wait(0.3)
                            if av.BottomDragBarEnabled then
                                r.Visible = true
                                al(
                                    r,
                                    0.45,
                                    { Size = UDim2.new(0, 200, 0, 4), ImageTransparency = 0.8 },
                                    Enum.EasingStyle.Exponential,
                                    Enum.EasingDirection.Out
                                ):Play()
                            end
                            z:Set(true)
                            task.wait(0.45)
                            if av.Resizable then
                                if az then
                                    al(
                                        az,
                                        0.45,
                                        { ImageTransparency = 0.8 },
                                        Enum.EasingStyle.Exponential,
                                        Enum.EasingDirection.Out
                                    ):Play()
                                end
                                av.CanResize = true
                            end
                        end)

                        av.CanDropdown = true

                        av.UIElements.Main.Visible = true
                        task.spawn(function()
                            task.wait(0.05)
                            av.UIElements.Main:WaitForChild('Main').Visible = true

                            au.WindUI:ToggleAcrylic(true)
                        end)
                    end)
                end
                function av.Close(C)
                    local F = {}

                    if av.OnCloseCallback then
                        task.spawn(function()
                            ai.SafeCallback(av.OnCloseCallback)
                        end)
                    end

                    au.WindUI:ToggleAcrylic(false)

                    av.UIElements.Main:WaitForChild('Main').Visible = false

                    av.CanDropdown = false
                    av.Closed = true

                    al(av.UIElements.Main.Background, 0.32, {
                        ImageTransparency = 1,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
                    if av.UIElements.BackgroundGradient then
                        al(av.UIElements.BackgroundGradient, 0.32, {
                            ImageTransparency = 1,
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
                    end

                    al(av.UIElements.Main.Background, 0.4, {
                        Size = UDim2.new(1, 0, 1, -240),
                    }, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut):Play()

                    if l then
                        if l:IsA('VideoFrame') then
                            local G = l
                            local H =
                                TweenVideoTransparency(G, 0.2, 1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                            if H then
                                H:Play()
                            end
                            task.delay(0.21, function()
                                if av.Closed and l == G then
                                    G.Visible = false
                                end
                            end)
                        else
                            al(l, 0.3, {
                                ImageTransparency = 1,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end
                    end
                    al(b, 0.25, { ImageTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    if h then
                        al(h, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end

                    if av.BottomDragBarEnabled then
                        al(
                            r,
                            0.3,
                            { Size = UDim2.new(0, 0, 0, 4), ImageTransparency = 1 },
                            Enum.EasingStyle.Exponential,
                            Enum.EasingDirection.InOut
                        ):Play()
                    end
                    if az then
                        al(az, 0.3, { ImageTransparency = 1 }, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out):Play()
                    end
                    z:Set(false)
                    av.CanResize = false

                    task.spawn(function()
                        task.wait(0.4)
                        av.UIElements.Main.Visible = false

                        if av.OpenButtonMain and not av.Destroyed and not av.IsPC and av.IsOpenButtonEnabled then
                            av.OpenButtonMain:Visible(true)
                        end
                    end)

                    function F.Destroy(G)
                        task.spawn(function()
                            if av.OnDestroyCallback then
                                task.spawn(function()
                                    ai.SafeCallback(av.OnDestroyCallback)
                                end)
                            end
                            if av.AcrylicPaint and av.AcrylicPaint.Model then
                                av.AcrylicPaint.Model:Destroy()
                            end
                            av.Destroyed = true
                            task.wait(0.4)
                            au.WindUI.ScreenGui:Destroy()
                            au.WindUI.NotificationGui:Destroy()
                            au.WindUI.DropdownGui:Destroy()
                            au.WindUI.TooltipGui:Destroy()

                            ai.DisconnectAll()

                            return
                        end)
                    end

                    return F
                end
                function av.Destroy(C)
                    return av:Close():Destroy()
                end
                function av.Toggle(C)
                    if av.Closed then
                        av:Open()
                    else
                        av:Close()
                    end
                end

                function av.ToggleTransparency(C, F)
                    av.Transparent = F
                    au.WindUI.Transparent = F

                    av.UIElements.Main.Background.ImageTransparency = F and au.WindUI.TransparencyValue or 0
                end

                function av.LockAll(C)
                    for F, G in next, av.AllElements do
                        if G.Lock then
                            G:Lock()
                        end
                    end
                end
                function av.UnlockAll(C)
                    for F, G in next, av.AllElements do
                        if G.Unlock then
                            G:Unlock()
                        end
                    end
                end
                function av.GetLocked(C)
                    local F = {}

                    for G, H in next, av.AllElements do
                        if H.Locked then
                            table.insert(F, H)
                        end
                    end

                    return F
                end
                function av.GetUnlocked(C)
                    local F = {}

                    for G, H in next, av.AllElements do
                        if H.Locked == false then
                            table.insert(F, H)
                        end
                    end

                    return F
                end

                function av.GetUIScale(C, F)
                    return au.WindUI.UIScale
                end

                function av.SetUIScale(C, F)
                    local G = tonumber(F)
                    if not G then
                        return av
                    end

                    G = math.clamp(G, 0.35, 2)
                    au.WindUI.UIScale = G
                    al(au.WindUI.UIScaleObj, 0.2, { Scale = G }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    return av
                end

                function av.SetToTheCenter(C)
                    al(
                        av.UIElements.Main,
                        0.45,
                        { Position = UDim2.new(0.5, 0, 0.5, 0) },
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ):Play()
                    return av
                end

                function av.SaveConfig(C)
                    return av.ConfigManager and av.ConfigManager:Save() or false
                end
                function av.LoadConfig(C)
                    return av.ConfigManager and av.ConfigManager:Load() or false
                end

                function av.GetFlagElement(C, F)
                    if typeof(F) ~= 'string' then
                        return nil
                    end
                    return av.FlagIndex[F]
                end

                function av.GetFlag(C, F)
                    local G = av:GetFlagElement(F)
                    if not G then
                        return nil
                    end

                    if G.__type == 'Slider' and G.Value then
                        return G.Value.Default
                    end

                    if G.Value ~= nil then
                        return G.Value
                    end

                    if G.Default ~= nil then
                        return G.Default
                    end

                    return nil
                end

                function av.SetFlag(C, F, G, ...)
                    local H = av:GetFlagElement(F)
                    if not H then
                        return false, 'Flag not found: ' .. tostring(F)
                    end

                    if H.Set then
                        H:Set(G, ...)
                        return true
                    end

                    if H.Select then
                        H:Select(G, ...)
                        return true
                    end

                    if H.Update then
                        H:Update(G, ...)
                        return true
                    end

                    return false, "Element with flag '" .. tostring(F) .. "' cannot be updated programmatically"
                end

                function av.ListFlags(C)
                    local F = {}
                    for G in next, av.FlagIndex do
                        table.insert(F, G)
                    end
                    table.sort(F)
                    return F
                end

                function av.HasFlag(C, F)
                    return av:GetFlagElement(F) ~= nil
                end

                function av.GetFlags(C)
                    local F = {}
                    for G, H in ipairs(av:ListFlags()) do
                        F[H] = av:GetFlag(H)
                    end
                    return F
                end

                function av.SetFlags(C, F, ...)
                    local G = {
                        Applied = {},
                        Failed = {},
                    }

                    if typeof(F) ~= 'table' then
                        return G, 'values must be a table'
                    end

                    for H, J in next, F do
                        local L, M = av:SetFlag(H, J, ...)
                        if L then
                            G.Applied[H] = true
                        else
                            G.Failed[H] = M or 'Unknown error'
                        end
                    end

                    return G
                end

                local function ResolveShortcutKeyCode(C)
                    if typeof(C) == 'EnumItem' and C.EnumType == Enum.KeyCode then
                        return C
                    end

                    if typeof(C) == 'string' and C ~= '' then
                        local F = C:gsub('%s+', '')
                        if Enum.KeyCode[F] then
                            return Enum.KeyCode[F]
                        end

                        local G = string.lower(F)
                        for H, J in ipairs(Enum.KeyCode:GetEnumItems()) do
                            if string.lower(J.Name) == G then
                                return J
                            end
                        end
                    end

                    return nil
                end

                local function IsModifierMatch(C, F, G)
                    if C == nil then
                        return true
                    end

                    local H = ad:IsKeyDown(F) or ad:IsKeyDown(G)
                    return H == (C == true)
                end

                local function ShortcutMatches(C, F)
                    if not C or C.KeyCode ~= F.KeyCode then
                        return false
                    end

                    if av.Closed and not C.EnabledWhenClosed then
                        return false
                    end

                    return IsModifierMatch(C.Ctrl, Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl)
                        and IsModifierMatch(C.Shift, Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift)
                        and IsModifierMatch(C.Alt, Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt)
                end

                function av.BindShortcut(C, F, G, H)
                    local J = ResolveShortcutKeyCode(F)
                    if not J then
                        return nil, 'Invalid KeyCode'
                    end

                    if typeof(G) ~= 'function' then
                        return nil, 'Callback must be a function'
                    end

                    H = H or {}

                    av.ShortcutIndex = av.ShortcutIndex + 1
                    local L = av.ShortcutIndex

                    av.Shortcuts[L] = {
                        Id = L,
                        KeyCode = J,
                        Callback = G,
                        Ctrl = H.Ctrl,
                        Shift = H.Shift,
                        Alt = H.Alt,
                        EnabledWhenClosed = H.EnabledWhenClosed == true,
                        Description = H.Description,
                    }

                    return L
                end

                function av.UnbindShortcut(C, F)
                    if av.Shortcuts[F] then
                        av.Shortcuts[F] = nil
                        return true
                    end

                    return false
                end

                function av.ClearShortcuts(C)
                    av.Shortcuts = {}
                    return true
                end

                function av.GetShortcuts(C)
                    local F = {}
                    for G, H in next, av.Shortcuts do
                        table.insert(F, {
                            Id = H.Id,
                            KeyCode = H.KeyCode,
                            Ctrl = H.Ctrl,
                            Shift = H.Shift,
                            Alt = H.Alt,
                            EnabledWhenClosed = H.EnabledWhenClosed,
                            Description = H.Description,
                        })
                    end

                    table.sort(F, function(G, H)
                        return G.Id < H.Id
                    end)

                    return F
                end

                do
                    local C = 40

                    local F = workspace.CurrentCamera
                    local G = av.UIElements.Main.AbsoluteSize

                    if F and not av.IsFullscreen and av.AutoScale and G.X > 0 and G.Y > 0 then
                        local H = F.ViewportSize
                        local J = H.X - (C * 2)
                        local L = H.Y - (C * 2)

                        local M = J / G.X
                        local N = L / G.Y

                        local O = math.min(M, N)

                        local P = 0.3
                        local Q = 1.0

                        local R = math.clamp(O, P, Q)

                        local S = av:GetUIScale() or 1
                        local T = 0.05

                        if math.abs(R - S) > T then
                            av:SetUIScale(R)
                        end
                    end
                end

                if av.OpenButtonMain and av.OpenButtonMain.Button then
                    ai.AddSignal(av.OpenButtonMain.Button.TextButton.MouseButton1Click, function()
                        av:Open()
                    end)
                end

                ai.AddSignal(ad.InputBegan, function(C, F)
                    if F then
                        return
                    end

                    if av.ToggleKey then
                        if C.KeyCode == av.ToggleKey then
                            av:Toggle()
                            return
                        end
                    end

                    for G, H in next, av.Shortcuts do
                        if ShortcutMatches(H, C) then
                            ai.SafeCallback(H.Callback, C, av, H)
                        end
                    end
                end)

                task.spawn(function()
                    av:Open()
                end)

                function av.EditOpenButton(C, F)
                    return av.OpenButtonMain:Edit(F)
                end

                if av.OpenButton and typeof(av.OpenButton) == 'table' then
                    av:EditOpenButton(av.OpenButton)
                end

                local C = WindUIModules.SidebarModule()
                local F = WindUIModules.DefaultElementIcons()
                local G = C.Init(av, au.WindUI, au.WindUI.TooltipGui)
                G:OnChange(function(H)
                    av.CurrentTab = H
                end)

                av.TabModule = G

                local function CreateSideBarLabel(H, J)
                    H = H or {}

                    local L = H.Title or H.Text or 'Label'
                    local M = am(L, H.Icon, J, H.Placeholder == true, H.Radius)

                    local N = typeof(H.Height) == 'number' and math.max(H.Height, 18) or 34
                    M.Size = H.Size or UDim2.new(1, -7, 0, N)
                    M.Visible = H.Visible ~= false

                    if typeof(H.LayoutOrder) == 'number' then
                        M.LayoutOrder = H.LayoutOrder
                    end

                    local O = {
                        __type = 'SideBarLabel',
                        Title = L,
                        ElementFrame = M,
                        LabelFrame = M,
                    }

                    function O.SetTitle(P, Q)
                        P.Title = tostring(Q or '')

                        local R = P.LabelFrame:FindFirstChild('TextLabel', true)
                        if R then
                            R.Text = P.Title
                        end

                        return P
                    end

                    function O.SetVisible(P, Q)
                        P.ElementFrame.Visible = Q ~= false
                        return P
                    end

                    function O.Destroy(P)
                        if P.ElementFrame then
                            P.ElementFrame:Destroy()
                            P.ElementFrame = nil
                            P.LabelFrame = nil
                        end
                    end

                    return O
                end

                local function CreateSideBarButton(H, J)
                    H = H or {}

                    local L = typeof(H.Height) == 'number' and math.max(H.Height, 20) or 34
                    local M = ak('Frame', {
                        Name = 'SideBarButton',
                        Parent = J,
                        BackgroundTransparency = 1,
                        Size = H.Size or UDim2.new(1, -7, 0, L),
                        Visible = H.Visible ~= false,
                    })

                    if typeof(H.LayoutOrder) == 'number' then
                        M.LayoutOrder = H.LayoutOrder
                    end

                    local N = {
                        __type = 'SideBarButton',
                        Title = H.Title or H.Text or 'Button',
                        Callback = H.Callback,
                        ElementFrame = M,
                        ButtonFrame = nil,
                    }

                    local O = an(N.Title, H.Icon, function()
                        if N.Callback then
                            ai.SafeCallback(N.Callback, N)
                        end
                    end, H.Variant or 'Secondary', M, nil, H.FullRounded, H.Radius)

                    O.AutomaticSize = 'None'
                    O.Size = UDim2.new(1, 0, 1, 0)
                    O.Position = UDim2.new(0.5, 0, 0.5, 0)
                    O.AnchorPoint = Vector2.new(0.5, 0.5)

                    N.ButtonFrame = O

                    function N.SetTitle(P, Q)
                        P.Title = tostring(Q or '')

                        local R = P.ButtonFrame:FindFirstChild('TextLabel', true)
                        if R then
                            R.Text = P.Title
                        end

                        return P
                    end

                    function N.SetCallback(P, Q)
                        P.Callback = Q
                        return P
                    end

                    function N.SetVisible(P, Q)
                        P.ElementFrame.Visible = Q ~= false
                        return P
                    end

                    function N.Destroy(P)
                        if P.ElementFrame then
                            P.ElementFrame:Destroy()
                            P.ElementFrame = nil
                            P.ButtonFrame = nil
                        end
                    end

                    return N
                end

                local function CreateSideBarSpace(H, J)
                    H = H or {}

                    local L = table.clone(H)
                    L.Parent = J
                    L.ParentType = L.ParentType or 'Window'
                    local 
M, N = ap:New(L)
                    return N
                end

                local function CreateSideBarDivider(H, J)
                    H = H or {}

                    local L = table.clone(H)
                    L.Parent = J
                    L.ParentType = L.ParentType or 'Window'
                    local 
M, N = aq:New(L)
                    return N
                end

                function av.Tab(H, J)
                    J = J or {}
                    J.Parent = av.UIElements.SideBar.Frame
                    return G.New(J, au.WindUI.UIScale)
                end

                function av.SelectTab(H, J)
                    return G:SelectTab(J)
                end

                function av.GetTabs(H)
                    local J = {}
                    for L = 1, #G.Tabs do
                        local M = G.Tabs[L]
                        table.insert(J, M)
                    end
                    return J
                end

                function av.Section(H, J)
                    return F.New(J, av.UIElements.SideBar.Frame, av.Folder, au.WindUI.UIScale, av, au.WindUI)
                end

                function av.SideBarLabel(H, J)
                    return CreateSideBarLabel(J, av.UIElements.SideBar.Frame)
                end
                av.SidebarLabel = av.SideBarLabel
                av.Label = av.SideBarLabel

                function av.SideBarButton(H, J)
                    return CreateSideBarButton(J, av.UIElements.SideBar.Frame)
                end
                av.SidebarButton = av.SideBarButton
                av.Button = av.SideBarButton

                function av.SideBarSpace(H, J)
                    local L = CreateSideBarSpace(J, av.UIElements.SideBar.Frame)
                    return L.ElementFrame
                end
                av.SidebarSpace = av.SideBarSpace
                av.Space = av.SideBarSpace

                function av.SideBarDivider(H, J)
                    local L = CreateSideBarDivider(J, av.UIElements.SideBar.Frame)
                    return L.ElementFrame
                end
                av.SidebarDivider = av.SideBarDivider
                av.Divider = av.SideBarDivider

                function av.IsResizable(H, J)
                    av.Resizable = J
                    av.CanResize = J
                end

                function av.SetPanelBackground(H, J, L)
                    if typeof(J) == 'boolean' then
                        local M = L == true and not J or J
                        av.HidePanelBackground = M
                        local N = not M

                        av.UIElements.MainBar.Background.Visible = N

                        if G then
                            local O = av.HidePanelBackground and 10 or 20
                            for P, Q in next, G.Containers do
                                Q.ScrollingFrame.UIPadding.PaddingTop = UDim.new(0, O)
                                Q.ScrollingFrame.UIPadding.PaddingLeft = UDim.new(0, O)
                                Q.ScrollingFrame.UIPadding.PaddingRight = UDim.new(0, O)
                                Q.ScrollingFrame.UIPadding.PaddingBottom = UDim.new(0, O)
                            end
                        end
                    end

                    return av
                end

                function av.SetPanelBackgroundVisible(H, J)
                    if typeof(J) == 'boolean' then
                        return av:SetPanelBackground(J, true)
                    end
                    return av
                end

                function av.SetPanelBackgroundHidden(H, J)
                    if typeof(J) == 'boolean' then
                        return av:SetPanelBackground(J, false)
                    end
                    return av
                end

                local H = WindUIModules.DialogModule().Init(av, nil)
                function av.Dialog(J, L)
                    local M = {
                        Title = L.Title or 'Dialog',
                        Width = L.Width or 320,
                        Content = L.Content,
                        Buttons = L.Buttons or {},

                        TextPadding = 14,
                    }
                    local N = H.Create(false)

                    N.UIElements.Main.Size = UDim2.new(0, M.Width, 0, 0)

                    local O = ak('Frame', {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        BackgroundTransparency = 1,
                        Parent = N.UIElements.Main,
                    }, {
                        ak('UIListLayout', {
                            FillDirection = 'Horizontal',
                            Padding = UDim.new(0, N.UIPadding),
                            VerticalAlignment = 'Center',
                        }),
                        ak('UIPadding', {
                            PaddingTop = UDim.new(0, M.TextPadding / 2),
                            PaddingLeft = UDim.new(0, M.TextPadding / 2),
                            PaddingRight = UDim.new(0, M.TextPadding / 2),
                        }),
                    })

                    local P
                    if L.Icon then
                        P = ai.Image(L.Icon, M.Title .. ':' .. L.Icon, 0, av, 'Dialog', true, L.IconThemed)
                        P.Size = UDim2.new(0, 22, 0, 22)
                        P.Parent = O
                    end

                    N.UIElements.UIListLayout = ak('UIListLayout', {
                        Padding = UDim.new(0, 12),
                        FillDirection = 'Vertical',
                        HorizontalAlignment = 'Left',
                        Parent = N.UIElements.Main,
                    })

                    ak('UISizeConstraint', {
                        MinSize = Vector2.new(180, 20),
                        MaxSize = Vector2.new(400, math.huge),
                        Parent = N.UIElements.Main,
                    })

                    N.UIElements.Title = ak('TextLabel', {
                        Text = M.Title,
                        TextSize = 20,
                        FontFace = Font.new(ai.Font, Enum.FontWeight.SemiBold),
                        TextXAlignment = 'Left',
                        TextWrapped = true,
                        RichText = true,
                        Size = UDim2.new(1, P and -26 - N.UIPadding or 0, 0, 0),
                        AutomaticSize = 'Y',
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        BackgroundTransparency = 1,
                        Parent = O,
                    })
                    if M.Content then
                        ak('TextLabel', {
                            Text = M.Content,
                            TextSize = 18,
                            TextTransparency = 0.4,
                            TextWrapped = true,
                            RichText = true,
                            FontFace = Font.new(ai.Font, Enum.FontWeight.Medium),
                            TextXAlignment = 'Left',
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = 'Y',
                            LayoutOrder = 2,
                            ThemeTag = {
                                TextColor3 = 'Text',
                            },
                            BackgroundTransparency = 1,
                            Parent = N.UIElements.Main,
                        }, {
                            ak('UIPadding', {
                                PaddingLeft = UDim.new(0, M.TextPadding / 2),
                                PaddingRight = UDim.new(0, M.TextPadding / 2),
                                PaddingBottom = UDim.new(0, M.TextPadding / 2),
                            }),
                        })
                    end

                    local Q = ak('UIListLayout', {
                        Padding = UDim.new(0, 6),
                        FillDirection = 'Horizontal',
                        HorizontalAlignment = 'Right',
                    })

                    local R = ak('Frame', {
                        Size = UDim2.new(1, 0, 0, 40),
                        AutomaticSize = 'None',
                        BackgroundTransparency = 1,
                        Parent = N.UIElements.Main,
                        LayoutOrder = 4,
                    }, {
                        Q,
                    })

                    local S = {}

                    for T, U in next, M.Buttons do
                        local V = an(U.Title, U.Icon, U.Callback, U.Variant, R, N, true)
                        table.insert(S, V)
                    end

                    local function CheckButtonsOverflow()
                        Q.FillDirection = Enum.FillDirection.Horizontal
                        Q.HorizontalAlignment = Enum.HorizontalAlignment.Right
                        Q.VerticalAlignment = Enum.VerticalAlignment.Center
                        R.AutomaticSize = Enum.AutomaticSize.None

                        for T, U in ipairs(S) do
                            U.Size = UDim2.new(0, 0, 1, 0)
                            U.AutomaticSize = Enum.AutomaticSize.X
                        end

                        wait()

                        local T = Q.AbsoluteContentSize.X / au.WindUI.UIScale
                        local U = R.AbsoluteSize.X / au.WindUI.UIScale

                        if T > U then
                            Q.FillDirection = Enum.FillDirection.Vertical
                            Q.HorizontalAlignment = Enum.HorizontalAlignment.Right
                            Q.VerticalAlignment = Enum.VerticalAlignment.Bottom
                            R.AutomaticSize = Enum.AutomaticSize.Y

                            for V, W in ipairs(S) do
                                W.Size = UDim2.new(1, 0, 0, 40)
                                W.AutomaticSize = Enum.AutomaticSize.None
                            end
                        else
                            local V = U - T
                            if V > 0 then
                                local W
                                local X = math.huge

                                for Y, _ in ipairs(S) do
                                    local aC = _.AbsoluteSize.X / au.WindUI.UIScale
                                    if aC < X then
                                        X = aC
                                        W = _
                                    end
                                end

                                if W then
                                    W.Size = UDim2.new(0, X + V, 1, 0)
                                    W.AutomaticSize = Enum.AutomaticSize.None
                                end
                            end
                        end
                    end

                    ai.AddSignal(N.UIElements.Main:GetPropertyChangedSignal('AbsoluteSize'), CheckButtonsOverflow)
                    CheckButtonsOverflow()

                    wait()
                    N:Open()

                    return N
                end

                local aC = false

                av:CreateTopbarButton('Close', 'x', function()
                    if not aC then
                        if not av.IgnoreAlerts then
                            aC = true
                            av:SetToTheCenter()
                            av:Dialog({

                                Title = 'Close Window',
                                Content = 'Do you want to close this window? You will not be able to open it again.',
                                Buttons = {
                                    {
                                        Title = 'Cancel',

                                        Callback = function()
                                            aC = false
                                        end,
                                        Variant = 'Secondary',
                                    },
                                    {
                                        Title = 'Close Window',

                                        Callback = function()
                                            aC = false
                                            av:Destroy()
                                        end,
                                        Variant = 'Primary',
                                    },
                                },
                            })
                        else
                            av:Destroy()
                        end
                    end
                end, (av.Topbar.ButtonsType == 'Default' and 999 or 997), nil, Color3.fromHex('#F4695F'))

                function av.Tag(J, L)
                    if av.UIElements.Main.Main.Topbar.Center.Visible == false then
                        av.UIElements.Main.Main.Topbar.Center.Visible = true
                    end
                    return ar:New(L, av.UIElements.Main.Main.Topbar.Center)
                end

                function av.Watermark(J, L)
                    if typeof(L) ~= 'table' then
                        L = {}
                    end

                    if av.WatermarkObject and av.WatermarkObject.Destroy then
                        av.WatermarkObject:Destroy()
                        av.WatermarkObject = nil
                    end

                    av.WatermarkObject = as:New(L, av.UIElements.Main.Background)

                    return av.WatermarkObject
                end

                function av.CreateWatermark(J, L)
                    return av:Watermark(L)
                end

                function av.SetBottomDragBarEnabled(J, L)
                    if L ~= false then
                        L = true
                    end

                    av.BottomDragBarEnabled = L
                    r.Frame.Active = L

                    if L then
                        r.Visible = true
                        r.ImageTransparency = 0.8
                        if not av.Closed then
                            al(
                                r,
                                0.2,
                                { Size = UDim2.new(0, 200, 0, 4), ImageTransparency = 0.8 },
                                Enum.EasingStyle.Exponential,
                                Enum.EasingDirection.Out
                            ):Play()
                        else
                            r.Size = UDim2.new(0, 0, 0, 4)
                        end
                    else
                        al(
                            r,
                            0.2,
                            { Size = UDim2.new(0, 0, 0, 4), ImageTransparency = 1 },
                            Enum.EasingStyle.Exponential,
                            Enum.EasingDirection.Out
                        ):Play()
                        task.delay(0.2, function()
                            if not av.BottomDragBarEnabled then
                                r.Visible = false
                            end
                        end)
                    end
                end

                if av.WatermarkConfig and av.WatermarkConfig ~= false then
                    av:Watermark(typeof(av.WatermarkConfig) == 'table' and av.WatermarkConfig or {})
                end

                local J = false
                local L = av.UIElements.Main.Size
                local M = Vector2.new(0, 0)

                local function startResizing(N)
                    if av.CanResize then
                        J = true
                        aA.Active = true
                        L = av.UIElements.Main.Size
                        M = N.Position

                        if az then
                            al(az, 0.1, { ImageTransparency = 0.35 }):Play()
                        end

                        ai.AddSignal(N.Changed, function()
                            if N.UserInputState == Enum.UserInputState.End then
                                J = false
                                aA.Active = false

                                if az then
                                    al(az, 0.17, { ImageTransparency = 0.8 }):Play()
                                end
                            end
                        end)
                    end
                end

                ai.AddSignal(ay.InputBegan, function(N)
                    if
                        N.UserInputType == Enum.UserInputType.MouseButton1
                        or N.UserInputType == Enum.UserInputType.Touch
                    then
                        if av.CanResize then
                            startResizing(N)
                        end
                    end
                end)

                ai.AddSignal(ad.InputChanged, function(N)
                    if
                        N.UserInputType == Enum.UserInputType.MouseMovement
                        or N.UserInputType == Enum.UserInputType.Touch
                    then
                        if J and av.CanResize then
                            local O = N.Position - M
                            local P = UDim2.new(0, L.X.Offset + O.X * 2, 0, L.Y.Offset + O.Y * 2)

                            P = UDim2.new(
                                P.X.Scale,
                                math.clamp(P.X.Offset, av.MinSize.X, av.MaxSize.X),
                                P.Y.Scale,
                                math.clamp(P.Y.Offset, av.MinSize.Y, av.MaxSize.Y)
                            )

                            al(av.UIElements.Main, 0, {
                                Size = P,
                            }):Play()

                            av.Size = P
                        end
                    end
                end)

                local N = 0
                local O = 0.4
                local P
                local Q = 0

                function onDoubleClick()
                    av:SetToTheCenter()
                end

                r.Frame.MouseButton1Up:Connect(function()
                    if not av.BottomDragBarEnabled then
                        return
                    end

                    local R = tick()
                    local S = av.Position

                    Q = Q + 1

                    if Q == 1 then
                        N = R
                        P = S

                        task.spawn(function()
                            task.wait(O)
                            if Q == 1 then
                                Q = 0
                                P = nil
                            end
                        end)
                    elseif Q == 2 then
                        if R - N <= O and S == P then
                            onDoubleClick()
                        end

                        Q = 0
                        P = nil
                        N = 0
                    else
                        Q = 1
                        N = R
                        P = S
                    end
                end)

                if not av.HideSearchBar then
                    local R = WindUIModules.WindowModule()
                    local S = false

                    local T = am('Search', 'search', av.UIElements.SideBarContainer, true)
                    T.Size = UDim2.new(1, -av.UIPadding / 2, 0, 39)
                    T.Position = UDim2.new(0, av.UIPadding / 2, 0, 0)

                    ai.AddSignal(T.MouseButton1Click, function()
                        if S then
                            return
                        end

                        R.new(av.TabModule, av.UIElements.Main, function()
                            S = false
                            if av.Resizable then
                                av.CanResize = true
                            end

                            al(aB, 0.1, { ImageTransparency = 1 }):Play()
                            aB.Active = false
                        end)
                        al(aB, 0.1, { ImageTransparency = 0.65 }):Play()
                        aB.Active = true

                        S = true
                        av.CanResize = false
                    end)
                end

                function av.DisableTopbarButtons(R, S)
                    for T, U in next, S do
                        for V, W in next, av.TopBarButtons do
                            if W.Name == U then
                                W.Object.Visible = false
                            end
                        end
                    end
                end

                return av
            end
        end
        function WindUIModules.WindUIApi(): typeof(buildModule())
            local aa = WindUIModules.cache.WindUIApi
            if not aa then
                aa = { c = buildModule() }
                WindUIModules.cache.WindUIApi = aa
            end
            return aa.c
        end
    end
end

local aa = game:GetService('RunService')
local ad = {
    Window = nil,
    Theme = nil,
    Creator = WindUIModules.LocalizationModule(),
    LocalizationModule = WindUIModules.ButtonModule(),
    NotificationModule = WindUIModules.Sha256Module(),
    Themes = nil,
    Transparent = false,

    TransparencyValue = 0.15,

    UIScale = 1,

    ConfigManager = nil,
    Version = '0.0.0',

    Services = WindUIModules.KeySystemServices(),

    OnThemeChangeFunction = nil,

    cloneref = nil,
    UIScaleObj = nil,
}

local ae = (cloneref or clonereference or function(ae)
    return ae
end)

ad.cloneref = ae

ae(game:GetService('HttpService'))
local af = ae(game:GetService('Players'))
local ag = ae(game:GetService('CoreGui'))
local ai = 
af.LocalPlayer or nil

local ak = WindUIModules.KeySystemModule()
local al = 
ad.Services

local am = ad.Creator

local an = am.New
local ao = am.Tween

local ap = WindUIModules.AcrylicModule()

local aq = protectgui or (syn and syn.protect_gui) or function() end

local ar = gethui and gethui() or (ag or game.Players.LocalPlayer:WaitForChild('PlayerGui'))

local as = an('UIScale', {
    Scale = ad.UIScale,
})

ad.UIScaleObj = as

ad.ScreenGui = an('ScreenGui', {
    Name = 'WindUI',
    Parent = ar,
    IgnoreGuiInset = true,
    ScreenInsets = 'None',
}, {

    an('Folder', {
        Name = 'Window',
    }),

    an('Folder', {
        Name = 'KeySystem',
    }),
    an('Folder', {
        Name = 'Popups',
    }),
    an('Folder', {
        Name = 'ToolTips',
    }),
})

ad.NotificationGui = an('ScreenGui', {
    Name = 'WindUI/Notifications',
    Parent = ar,
    IgnoreGuiInset = true,
})
ad.DropdownGui = an('ScreenGui', {
    Name = 'WindUI/Dropdowns',
    Parent = ar,
    IgnoreGuiInset = true,
})
ad.TooltipGui = an('ScreenGui', {
    Name = 'WindUI/Tooltips',
    Parent = ar,
    IgnoreGuiInset = true,
})
aq(ad.ScreenGui)
aq(ad.NotificationGui)
aq(ad.DropdownGui)
aq(ad.TooltipGui)

am.Init(ad)

function ad.SetParent(at, au)
    ad.ScreenGui.Parent = au
    ad.NotificationGui.Parent = au
    ad.DropdownGui.Parent = au
    ad.TooltipGui.Parent = au
end
ad.TransparencyValue = math.clamp(ad.TransparencyValue, 0, 1)

local at = ad.NotificationModule.Init(ad.NotificationGui)

function ad.Notify(au, av)
    av.Holder = at.Frame
    av.Window = ad.Window

    return ad.NotificationModule.New(av)
end

function ad.SetNotificationLower(au, av)
    at.SetLower(av)
end

function ad.SetFont(au, av)
    am.UpdateFont(av)
end

function ad.OnThemeChange(au, av)
    ad.OnThemeChangeFunction = av
end

function ad.AddTheme(au, av)
    ad.Themes[av.Name] = av
    return av
end

function ad.SetTheme(au, av)
    if ad.Themes[av] then
        ad.Theme = ad.Themes[av]
        am.SetTheme(ad.Themes[av])

        if ad.OnThemeChangeFunction then
            ad.OnThemeChangeFunction(av)
        end

        return ad.Themes[av]
    end
    return nil
end

function ad.GetThemes(au)
    return ad.Themes
end
function ad.GetCurrentTheme(au)
    return ad.Theme and ad.Theme.Name or nil
end
function ad.GetTransparency(au)
    return ad.Transparent or false
end
function ad.GetWindowSize(au)
    if ad.Window and ad.Window.UIElements and ad.Window.UIElements.Main then
        return ad.Window.UIElements.Main.Size
    end
    return nil
end
function ad.Localization(au, av)
    return ad.LocalizationModule:New(av, am)
end

function ad.SetLanguage(au, av)
    if am.Localization then
        return am.SetLanguage(av)
    end
    return false
end

function ad.ToggleAcrylic(au, av)
    if ad.Window and ad.Window.AcrylicPaint and ad.Window.AcrylicPaint.Model then
        ad.Window.Acrylic = av
        ad.Window.AcrylicPaint.Model.Transparency = av and 0.98 or 1
        if av then
            ap.Enable()
        else
            ap.Disable()
        end
    end
end

function ad.Gradient(au, av, aw)
    if typeof(av) ~= 'table' then
        av = {}
    end

    local ax = {}
    local ay = {}

    for az, aA in next, av do
        local aB = tonumber(az)
        if aB then
            aB = math.clamp(aB / 100, 0, 1)

            local aC = aA.Color
            if typeof(aC) == 'string' and string.sub(aC, 1, 1) == '#' then
                aC = Color3.fromHex(aC)
            end

            local b = aA.Transparency or 0

            table.insert(ax, ColorSequenceKeypoint.new(aB, aC))
            table.insert(ay, NumberSequenceKeypoint.new(aB, b))
        end
    end

    table.sort(ax, function(az, aA)
        return az.Time < aA.Time
    end)
    table.sort(ay, function(az, aA)
        return az.Time < aA.Time
    end)

    if #ax == 0 then
        table.insert(ax, ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)))
        table.insert(ax, ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)))
        table.insert(ay, NumberSequenceKeypoint.new(0, 0))
        table.insert(ay, NumberSequenceKeypoint.new(1, 0))
    elseif #ax < 2 then
        table.insert(ax, ColorSequenceKeypoint.new(1, ax[1].Value))
        table.insert(ay, NumberSequenceKeypoint.new(1, ay[1].Value))
    end

    local az = {
        Color = ColorSequence.new(ax),
        Transparency = NumberSequence.new(ay),
    }

    if aw then
        for aA, aB in pairs(aw) do
            az[aA] = aB
        end
    end

    return az
end

function ad.Popup(au, av)
    av.WindUI = ad
    return WindUIModules.DefaultThemes().new(av)
end

ad.Themes = WindUIModules.LabelModule()(ad)

am.Themes = ad.Themes

ad:SetTheme('Dark')
ad:SetLanguage(am.Language)

function ad.CreateWindow(au, av)
    av = av or {}

    local aw = WindUIModules.WindUIApi()

    if not aa:IsStudio() and writefile then
        if not isfolder('WindUI') then
            makefolder('WindUI')
        end
        if av.Folder then
            if not isfolder(av.Folder) then
                makefolder(av.Folder)
            end
        else
            if av.Title and not isfolder(av.Title) then
                makefolder(av.Title)
            end
        end
    end

    av.WindUI = ad
    av.Parent = ad.ScreenGui.Window

    if ad.Window then
        warn('You cannot create more than one window')
        return
    end

    local ax = true

    local ay = ad.Themes[av.Theme or 'Dark'] or ad.Theme or ad.Themes.Dark
    if ay then
        am.SetTheme(ay)
    end

    local az = gethwid or function()
        return af.LocalPlayer.UserId
    end

    local aA = az()

    if av.KeySystem then
        ax = false

        local function loadKeysystem()
            ak.new(av, aA, function(aB)
                ax = aB
            end)
        end

        local aB = (av.Folder or 'Temp') .. '/' .. aA .. '.key'

        if av.KeySystem.KeyValidator then
            if av.KeySystem.SaveKey and isfile(aB) then
                local aC = readfile(aB)
                local b = av.KeySystem.KeyValidator(aC)

                if b then
                    ax = true
                else
                    loadKeysystem()
                end
            else
                loadKeysystem()
            end
        elseif not av.KeySystem.API then
            if av.KeySystem.SaveKey and isfile(aB) then
                local aC = readfile(aB)
                local b = (type(av.KeySystem.Key) == 'table') and table.find(av.KeySystem.Key, aC)
                    or tostring(av.KeySystem.Key) == tostring(aC)

                if b then
                    ax = true
                else
                    loadKeysystem()
                end
            else
                loadKeysystem()
            end
        else
            if isfile(aB) then
                local aC = readfile(aB)
                local b = false

                for d, f in next, av.KeySystem.API do
                    local g = ad.Services[f.Type]
                    if g then
                        local h = {}
                        for j, l in next, g.Args do
                            table.insert(h, f[l])
                        end

                        local j = g.New(table.unpack(h))
                        local l = j.Verify(aC)
                        if l then
                            b = true
                            break
                        end
                    end
                end

                ax = b
                if not b then
                    loadKeysystem()
                end
            else
                loadKeysystem()
            end
        end

        repeat
            task.wait()
        until ax
    end

    local aB = aw(av)

    ad.Transparent = av.Transparent
    ad.Window = aB

    if av.Acrylic then
        ap.init()
    end

    return aB
end

return ad
