--[=[
    Euphoria
    A compact Roblox UI library with responsive scaling, draggable windows,
    tabs, modules, sliders, textboxes, checkboxes, dropdowns, dividers, and
    queued notifications.

    Public entry point:
        local Euphoria = loadstring(game:HttpGet(URL))()
        local library = Euphoria:init("My interface")
        local tab = library:create_tab("Dashboard")

    Original attribution: Euphoria by riq and enrithy.
]=]

export type Library = { __current_tab: Tab?, __tabs: { Tab }, __all_elements: { { name: string, frame: Frame } }, __window: { main: Frame, euphoria: ScreenGui }, __resize_start: Vector2?, __size_start: UDim2?, __resizing: boolean, __ui_scale: number, __device: string?, __drag_input: InputObject?, __drag_start: Vector2?, __start_pos: UDim2?, __dragging: boolean?, __minimized: boolean, get_device: (self: Library) -> (), notify: (self: Library, index: { title: string, content: string, duration: number?, notify_type: string }) -> (), get_screen_scale: (self: Library) -> (), mobile_ui_scale: (self: Library) -> (), mobile_controls: (self: Library) -> (), init: (self: Library, title: string?) -> Library, create_tab: (self: Library, name: string, icon: string?) -> Tab }
export type Tab = { __library: Library, button: TextButton, container: ScrollingFrame, label: TextLabel, highlight: Frame, outline: UIStroke, highlight_effect: Frame, icon: ImageLabel?, create_button: (self: Tab, index: { title: string, callback: () -> () }) -> (), create_divider: (self: Tab, text: string?) -> (), create_slider: (self: Tab, index: { title: string, minimum: number?, maximum: number?, default: number?, rounding: number?, callback: (value: number) -> () }) -> { Set: (self: any, value: number) -> () }, create_textbox: (self: Tab, index: { title: string, placeholder: string?, callback: (text: string) -> () }) -> { Set: (self: any, text: string) -> () }, create_module: (self: Tab, index: { title: string, default: boolean?, callback: (state: boolean) -> () }) -> Module, create_checkbox: (self: Tab, index: { title: string, default: boolean?, callback: (state: boolean) -> () }) -> (), create_dropdown: (self: Tab, index: { title: string, options: { string }, default: string | { string }?, multi_selection: boolean?, callback: (value: string | { string }) -> () }) -> { Set: (self: any, value: string | { string }) -> () } }
export type Module = { __elements: { Instance }, __library: Library, create_checkbox: (self: Module, index: { title: string, default: boolean?, callback: (state: boolean) -> () }) -> (), create_divider: (self: Module, text: string?) -> (), create_textbox: (self: Module, index: { title: string, placeholder: string?, callback: (text: string) -> () }) -> { Set: (self: any, text: string) -> () }, create_slider: (self: Module, index: { title: string, minimum: number?, maximum: number?, default: number?, rounding: number?, callback: (value: number) -> () }) -> { Set: (self: any, value: number) -> () }, create_button: (self: Module, index: { title: string, callback: () -> () }) -> (), create_dropdown: (self: Module, index: { title: string, options: { string }, default: string | { string }?, multi_selection: boolean?, callback: (value: string | { string }) -> () }) -> { Set: (self: any, value: string | { string }) -> () } }

local Service = setmetatable({} :: any, {
    __index = function(self: any, name: string): Instance
		rawset(self, name, (cloneref or (function(...) return ... end))(game:GetService(name)))

        return rawget(self, name)
    end
})

local UserInputService = Service.UserInputService
local CoreGui = Service.CoreGui

local Camera = workspace.CurrentCamera

local Library : Library = {
	__current_tab = nil,
	__tabs = {},

	__all_elements = {},
	__window = {},

	__resize_start = nil,
	__size_start = nil,
	__resizing = false,

	__ui_scale = 1,
	__device = nil,

	__drag_input = nil,
	__drag_start = nil,
	__start_pos = nil,
	__dragging = nil,

	__minimized = false
}
Library.__index = Library

local function __create_tween(__object : Instance, __properties : { [any]: any }, __duration : number?) : Tween
	local __tween = Service.TweenService:Create(__object, TweenInfo.new(__duration or 0.3, Enum.EasingStyle.Quint), __properties)
	__tween:Play()

	return __tween
end

local function __create_round(__parent : Instance, __radius : number?) : UICorner
	local __corner : UICorner = Instance.new('UICorner')

	__corner.CornerRadius = UDim.new(0, __radius or 8)
	__corner.Parent = __parent

	return __corner
end

local function __create_outline(__parent : Instance) : UIStroke
	local __outline : UIStroke = Instance.new('UIStroke')

	__outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	__outline.Color = Color3.fromRGB(35, 35, 35)
	__outline.Parent = __parent
	__outline.Thickness = 1

	return __outline
end

function Library:get_device() : ()
	local __device : string = 'unknown'

	if not UserInputService.TouchEnabled then
		__device = 'pc'
	else
		__device = 'mobile'
	end

	self.__device = __device
end

local __NotificationQueue : { { title: string, content: string, duration: number?, type: string } } = {}
local __Notifications : { Frame } = {}

local __NotifyIcons : { [string]: string } = {
	normal = 'rbxassetid://10734888000',
	error = 'rbxassetid://10747384394',
	warn = 'rbxassetid://10709753149'
}

local function __update_notification_positions() : ()
	for __i, __notify in ipairs(__Notifications) do
		local __target_y : number = -20

		for __j = #__Notifications, __i + 1, -1 do
			if not __Notifications[__j] or not __Notifications[__j].AbsoluteSize then
				continue
			end

			__target_y = __target_y - __Notifications[__j].AbsoluteSize.Y - 10
		end

		if not __notify or not __notify.Parent then
			continue
		end

		__create_tween(__notify, {Position = UDim2.new(1, -20, 1, __target_y)}, 0.3)
	end
end

local function __notification_init() : ()
	if #__NotificationQueue == 0 then
		return
	end

	local __notification = table.remove(__NotificationQueue, 1)

	local __euphoria_gui = CoreGui:FindFirstChild('Euphoria')

	if not __euphoria_gui then
		return
	end

	local __notify_width : number = 300
	local __notify_height : number = 70

	if Library.__device == 'mobile' or Library.__device == 'unknown' then
		__notify_width = 250
		__notify_height = 60
	end

	local __notify_frame : Frame = Instance.new('Frame')
	__notify_frame.Size = UDim2.new(0, 0, 0, 0)
	__notify_frame.Position = UDim2.new(1, -20, 1, -20)
	__notify_frame.AnchorPoint = Vector2.new(0.5, 0.5)
	__notify_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	__notify_frame.BackgroundTransparency = 0
	__notify_frame.BorderSizePixel = 0
	__notify_frame.ZIndex = 100
	__notify_frame.ClipsDescendants = true
	__notify_frame.Parent = __euphoria_gui

	__create_round(__notify_frame, 4)

	local __icon_container : Frame = Instance.new('Frame')
	__icon_container.Size = UDim2.new(0, 50, 1, 0)
	__icon_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	__icon_container.BackgroundTransparency = 0
	__icon_container.BorderSizePixel = 0
	__icon_container.ZIndex = 101
	__icon_container.Parent = __notify_frame
	__create_round(__icon_container, 8)

	local __icon : ImageLabel = Instance.new('ImageLabel')
	__icon.Size = UDim2.new(0, 24, 0, 24)
	__icon.Position = UDim2.new(0.5, -12, 0.5, -12)
	__icon.BackgroundTransparency = 1
	__icon.Image = __NotifyIcons[__notification.notify_type] or __NotifyIcons['normal']
	__icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
	__icon.ZIndex = 102
	__icon.Parent = __icon_container

	local __divider : Frame = Instance.new('Frame')
	__divider.Size = UDim2.new(0, 1, 0.8, 0)
	__divider.Position = UDim2.new(0, 50, 0.1, 0)
	__divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	__divider.BorderSizePixel = 0
	__divider.ZIndex = 101
	__divider.Parent = __notify_frame

	local __content_container : Frame = Instance.new('Frame')
	__content_container.Size = UDim2.new(1, -60, 1, -8)
	__content_container.Position = UDim2.new(0, 55, 0, 4)
	__content_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	__content_container.BackgroundTransparency = 0
	__content_container.BorderSizePixel = 0
	__content_container.ZIndex = 101
	__content_container.Parent = __notify_frame

	local __title_label : TextLabel = Instance.new('TextLabel')
	__title_label.Size = UDim2.new(1, -10, 0, 18)
	__title_label.Position = UDim2.new(0, 5, 0, 5)
	__title_label.BackgroundTransparency = 1
	__title_label.Text = __notification.title
	__title_label.TextColor3 = Color3.fromRGB(220, 220, 220)
	__title_label.TextSize = 14
	__title_label.Font = Enum.Font.Gotham
	__title_label.TextXAlignment = Enum.TextXAlignment.Left
	__title_label.TextYAlignment = Enum.TextYAlignment.Top
	__title_label.ZIndex = 102
	__title_label.Parent = __content_container

	local __content_label : TextLabel = Instance.new('TextLabel')
	__content_label.Size = UDim2.new(1, -10, 1, -25)
	__content_label.Position = UDim2.new(0, 5, 0, 23)
	__content_label.BackgroundTransparency = 1
	__content_label.Text = __notification.content
	__content_label.TextColor3 = Color3.fromRGB(180, 180, 180)
	__content_label.TextSize = 14
	__content_label.Font = Enum.Font.Gotham
	__content_label.TextXAlignment = Enum.TextXAlignment.Left
	__content_label.TextYAlignment = Enum.TextYAlignment.Top
	__content_label.TextWrapped = true
	__content_label.ZIndex = 102
	__content_label.Parent = __content_container

	local __progress_bar : Frame = Instance.new('Frame')
	__progress_bar.Size = UDim2.new(0, 0, 0, 3)
	__progress_bar.Position = UDim2.new(0, 0, 1, -3)
	__progress_bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	__progress_bar.BorderSizePixel = 0
	__progress_bar.ZIndex = 103
	__progress_bar.Parent = __notify_frame

	table.insert(__Notifications, __notify_frame)

	local __y_position : number = -20

	for __j = #__Notifications - 1, 1, -1 do
		if not __Notifications[__j] or not __Notifications[__j].AbsoluteSize then
			continue
		end

		__y_position = __y_position - __Notifications[__j].AbsoluteSize.Y - 10
	end

	__notify_frame.Position = UDim2.new(1, -20 - (300 / 2), 1, __y_position - (70 / 2))
	__notify_frame.AnchorPoint = Vector2.new(0.5, 0.5)

	__create_tween(__notify_frame, {Size = UDim2.new(0, __notify_width, 0, __notify_height)}, 0.25).Completed:Connect(function()
		__notify_frame.AnchorPoint = Vector2.new(1, 1)
		__notify_frame.Position = UDim2.new(1, -20, 1, __y_position)

		__update_notification_positions()

		__create_tween(__progress_bar, {Size = UDim2.new(1, 0, 0, 3)}, __notification.duration)

		task.wait(__notification.duration)

		__notify_frame.AnchorPoint = Vector2.new(0.5, 0.5)
		__notify_frame.Position = UDim2.new(0, __notify_frame.AbsolutePosition.X + (__notify_frame.AbsoluteSize.X / 2), 0, __notify_frame.AbsolutePosition.Y + (__notify_frame.AbsoluteSize.Y / 2))

		__create_tween(__notify_frame, {BackgroundTransparency = 1}, 0.25)
		__create_tween(__icon_container, {BackgroundTransparency = 1}, 0.25)
		__create_tween(__content_container, {BackgroundTransparency = 1}, 0.25)
		__create_tween(__icon, {ImageTransparency = 1}, 0.25)
		__create_tween(__divider, {BackgroundTransparency = 1}, 0.25)
		__create_tween(__title_label, {TextTransparency = 1}, 0.25)
		__create_tween(__content_label, {TextTransparency = 1}, 0.25)
		__create_tween(__progress_bar, {BackgroundTransparency = 1}, 0.25)

		for _, __child in pairs(__notify_frame:GetChildren()) do
			if not __child:IsA('UIStroke') then
				continue
			end

			__create_tween(__child, {Transparency = 1}, 0.25)
		end

		__create_tween(__notify_frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3).Completed:Connect(function()
			__notify_frame:Destroy()

			for __i, __notif in ipairs(__Notifications) do
				if __notif ~= __notify_frame then
					continue
				end

				table.remove(__Notifications, __i)

				break
			end

			__update_notification_positions()

			if #__NotificationQueue <= 0 then
				return
			end

			task.spawn(__notification_init)
		end)
	end)
end

function Library:notify(__index : { title: string, content: string, duration: number?, notify_type: string }) : ()
	local __auto_selection : string = __index.notify_type or 'normal'

	if not __NotifyIcons[__auto_selection] then
		__auto_selection = 'normal'
	end
	
	table.insert(__NotificationQueue, {
		title = __index.title,
		content = __index.content,
		duration = __index.duration or 3,
		notify_type = __auto_selection
	})

	if #__Notifications >= 5 then
		return
	end

	task.spawn(__notification_init)
end

function Library:get_screen_scale() : ()
	local __viewport_size_x : number = Camera.ViewportSize.X

	self.__ui_scale = __viewport_size_x / 1400
end

function Library:mobile_ui_scale() : ()
	if self.__device ~= 'mobile' and self.__device ~= 'unknown' then
		return
	end

	for _, __object in pairs(self.__window.main:GetDescendants()) do
		if __object:IsA('TextLabel') or __object:IsA('TextButton') or __object:IsA('TextBox') then
			if not __object.TextSize then
				continue
			end

			__object.TextSize = math.max(12, math.floor(__object.TextSize * 1.05))
		elseif __object:IsA('ImageLabel') or __object:IsA('ImageButton') then
			if not (__object.Size.X.Offset > 0 and __object.Size.X.Offset < 30) then
				continue
			end

			__object.Size = UDim2.new(0, math.floor(__object.Size.X.Offset * 0.9), 0, math.floor(__object.Size.Y.Offset * 0.9))
		end
	end
end

function Library:mobile_controls() : ()
	if self.__device ~= 'mobile' then
		return
	end

	for _, __obj in pairs(self.__window.main:GetDescendants()) do
		if not ((__obj:IsA('TextButton') or __obj:IsA('ImageButton')) and __obj.Size.Y.Offset < 40) then
			continue
		end

		local __hitbox : Frame = Instance.new('Frame')
		__hitbox.Name = 'TouchHitbox'
		__hitbox.Size = UDim2.new(1, 10, 1, 10)
		__hitbox.Position = UDim2.new(0.5, 0, 0.5, 0)
		__hitbox.AnchorPoint = Vector2.new(0.5, 0.5)
		__hitbox.BackgroundTransparency = 1
		__hitbox.ZIndex = __obj.ZIndex
		__hitbox.Parent = __obj

		if not __obj:IsA('TextButton') then
			continue
		end

		__hitbox.InputBegan:Connect(function(__input)
			if __input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			__obj.MouseButton1Click:Fire()
		end)
	end
end

function Library:init(__title : string?) : Library
	local __euphoria : ScreenGui = Instance.new('ScreenGui')

	__euphoria.Name = 'Euphoria'
	__euphoria.ResetOnSpawn = false
	__euphoria.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	__euphoria.Parent = CoreGui

	self:get_device()
	self.__window = {}

	local __main : Frame = Instance.new('Frame')
	__main.Name = 'Main'
	__main.Size = UDim2.new(0, 0, 0, 0)
	__main.Position = UDim2.new(0.5, 0, 0.5, 0)
	__main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	__main.BackgroundTransparency = 0.1
	__main.BorderSizePixel = 0
	__main.ClipsDescendants = true
	__main.Parent = __euphoria
	__create_round(__main, 50)

	self.__window.main = __main
	self.__window.euphoria = __euphoria

	local __UIScale : UIScale = Instance.new('UIScale')
	__UIScale.Parent = __main

	if self.__device == 'mobile' or self.__device == 'unknown' then
		self:get_screen_scale()

		__UIScale.Scale = math.min(self.__ui_scale * 1.2, 1)

		Camera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
			self:get_screen_scale()

			__UIScale.Scale = math.min(self.__ui_scale * 1.2, 1)
		end)
	end

	local __blur_frame : Frame = Instance.new('Frame')
	__blur_frame.Size = UDim2.new(1, 0, 1, 0)
	__blur_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	__blur_frame.BackgroundTransparency = 0
	__blur_frame.BorderSizePixel = 0
	__blur_frame.ZIndex = 0
	__blur_frame.Parent = __main
	__create_round(__blur_frame, 12)
	__create_outline(__blur_frame)

	local __header : Frame = Instance.new('Frame')
	__header.Name = 'Header'
	__header.Size = UDim2.new(1, 0, 0, 50)
	__header.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	__header.BackgroundTransparency = 1
	__header.BorderSizePixel = 0
	__header.ZIndex = 2
	__header.Parent = __main
	__create_round(__header, 6)

	local __header_outline_bottom : Frame = Instance.new('Frame')
	__header_outline_bottom.Size = UDim2.new(1, 0, 0, 1)
	__header_outline_bottom.Position = UDim2.new(0, 0, 1, -1)
	__header_outline_bottom.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	__header_outline_bottom.BorderSizePixel = 0
	__header_outline_bottom.ZIndex = 3
	__header_outline_bottom.Parent = __header

	local __title_label : TextLabel = Instance.new('TextLabel')
	__title_label.Size = UDim2.new(0, 150, 1, 0)
	__title_label.Position = UDim2.new(0, 20, 0, 0)
	__title_label.BackgroundTransparency = 1
	__title_label.Text = 'laced.max'
	__title_label.TextColor3 = Color3.fromRGB(255, 255, 255)
	__title_label.TextSize = 16
	__title_label.Font = Enum.Font.Gotham
	__title_label.TextXAlignment = Enum.TextXAlignment.Left
	__title_label.ZIndex = 3
	__title_label.Parent = __header

	local __search_container : Frame = Instance.new('Frame')
	__search_container.Size = UDim2.new(0, 180, 0, 32)
	__search_container.Position = UDim2.new(1, -190, 0.5, -16)
	__search_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	__search_container.BackgroundTransparency = 0.4
	__search_container.BorderSizePixel = 0
	__search_container.ZIndex = 3
	__search_container.Parent = __header
	__create_round(__search_container, 6)
	__create_outline(__search_container)

	local __search_icon_container : Frame = Instance.new('Frame')
	__search_icon_container.Size = UDim2.new(0, 30, 1, 0)
	__search_icon_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	__search_icon_container.BackgroundTransparency = 0.6
	__search_icon_container.BorderSizePixel = 0
	__search_icon_container.ZIndex = 3
	__search_icon_container.Parent = __search_container
	__create_round(__search_icon_container, 6)

	local __search_divider : Frame = Instance.new('Frame')
	__search_divider.Size = UDim2.new(0, 1, 0.6, 0)
	__search_divider.Position = UDim2.new(0, 30, 0.2, 0)
	__search_divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	__search_divider.BorderSizePixel = 0
	__search_divider.ZIndex = 4
	__search_divider.Parent = __search_container

	local __search_icon : ImageLabel = Instance.new('ImageLabel')
	__search_icon.Size = UDim2.new(0, 16, 0, 16)
	__search_icon.Position = UDim2.new(0.5, -8, 0.5, -8)
	__search_icon.BackgroundTransparency = 1
	__search_icon.Image = 'rbxassetid://10734943674'
	__search_icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
	__search_icon.ZIndex = 4
	__search_icon.Parent = __search_icon_container

	local __search_box : TextBox = Instance.new('TextBox')
	__search_box.Size = UDim2.new(1, -40, 1, 0)
	__search_box.Position = UDim2.new(0, 35, 0, 0)
	__search_box.BackgroundTransparency = 1
	__search_box.Text = ''
	__search_box.PlaceholderText = 'Search'
	__search_box.TextColor3 = Color3.fromRGB(255, 255, 255)
	__search_box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
	__search_box.TextSize = 13
	__search_box.Font = Enum.Font.Gotham
	__search_box.TextXAlignment = Enum.TextXAlignment.Left
	__search_box.ClearTextOnFocus = false
	__search_box.ZIndex = 4
	__search_box.Parent = __search_container

	__search_box:GetPropertyChangedSignal('Text'):Connect(function()
		local __search_text : string = __search_box.Text:lower()

		for _, __element in pairs(self.__all_elements) do
			local __is_divider : boolean = __element.frame.Name == 'Divider' or __element.frame.Name == 'DividerItem'

			if __search_text == '' then
				__element.frame.Visible = true

				if not __is_divider then
					__element.frame.BackgroundTransparency = 0.3

					__create_tween(__element.frame, {BackgroundTransparency = 0.3}, 0.2)
				end
			else
				if __is_divider then
					__element.frame.Visible = false
				else
					local __element_text : string = __element.name:lower()

					if __element_text:find(__search_text) == nil then
						__create_tween(__element.frame, {BackgroundTransparency = 1}, 0.2)

						task.delay(0.2, function()
							if __search_box.Text:lower():find(__element_text) == nil then
								__element.frame.Visible = false
							end
						end)
					else
						__element.frame.Visible = true

						__create_tween(__element.frame, {BackgroundTransparency = 0.3}, 0.2)
					end
				end
			end
		end
	end)

	local __resize_button : ImageButton = Instance.new('ImageButton')
	__resize_button.Size = UDim2.new(0, 20, 0, 20)
	__resize_button.Position = UDim2.new(1, -25, 1, -25)
	__resize_button.BackgroundTransparency = 1
	__resize_button.Image = 'rbxassetid://10734961133'
	__resize_button.ImageColor3 = Color3.fromRGB(120, 120, 120)
	__resize_button.ZIndex = 10
	__resize_button.Parent = __main

	self.__resizing = false

	if self.__device == 'mobile' or self.__device == 'unknown' then
		local __resize_hitbox : Frame = Instance.new('Frame')

		__resize_hitbox.Size = UDim2.new(0, 50, 0, 50)
		__resize_hitbox.Position = UDim2.new(1, -50, 1, -50)
		__resize_hitbox.BackgroundTransparency = 1
		__resize_hitbox.ZIndex = 9
		__resize_hitbox.Parent = __main

		__resize_hitbox.InputBegan:Connect(function(__input)
			if __input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			self.__resizing = true

			self.__resize_start = Vector2.new(__input.Position.X, __input.Position.Y)
			self.__size_start = __main.Size
		end)

		__resize_hitbox.InputChanged:Connect(function(__input)
			if not self.__resizing or __input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			local __current_pos : Vector2 = Vector2.new(__input.Position.X, __input.Position.Y)
			local __delta : Vector2 = __current_pos - self.__resize_start

			local __new_width : number = math.max(300, self.__size_start.X.Offset + __delta.X)
			local __new_height : number = math.max(250, self.__size_start.Y.Offset + __delta.Y)

			__main.Size = UDim2.new(0, __new_width, 0, __new_height)
		end)

		__resize_hitbox.InputEnded:Connect(function(__input)
			if __input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			self.__resizing = false
		end)
	end

	__resize_button.MouseButton1Down:Connect(function()
		if self.__device ~= 'pc' then
			return
		end

		self.__resizing = true

		self.__resize_start = UserInputService:GetMouseLocation()
		self.__size_start = __main.Size
	end)

	__resize_button.InputBegan:Connect(function(__input)
		if __input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		self.__resizing = true

		self.__resize_start = Vector2.new(__input.Position.X, __input.Position.Y)
		self.__size_start = __main.Size
	end)

	__resize_button.InputChanged:Connect(function(__input)
		if not self.__resizing or __input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local __current_pos : Vector2 = Vector2.new(__input.Position.X, __input.Position.Y)
		local __delta : Vector2 = __current_pos - self.__resize_start

		local __new_width : number = math.max(300, self.__size_start.X.Offset + __delta.X)
		local __new_height : number = math.max(250, self.__size_start.Y.Offset + __delta.Y)

		__main.Size = UDim2.new(0, __new_width, 0, __new_height)
	end)

	__resize_button.InputEnded:Connect(function(__input)
		if __input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		self.__resizing = false
	end)

	UserInputService.InputEnded:Connect(function(__input)
		if __input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		self.__resizing = false
	end)

	UserInputService.InputChanged:Connect(function(__input)
		if not self.__resizing or __input.UserInputType ~= Enum.UserInputType.MouseMovement or self.__device ~= 'pc' then
			return
		end

		local __delta : Vector2 = UserInputService:GetMouseLocation() - self.__resize_start

		__create_tween(__main, {Size = UDim2.new(0, math.max(400, self.__size_start.X.Offset + __delta.X), 0, math.max(300, self.__size_start.Y.Offset + __delta.Y))}, 0.5)
	end)

	task.spawn(function()
		task.wait(0.05)

		local __target_width : number = 700
		local __target_height : number = 450

		if self.__device == 'mobile' or self.__device == 'unknown' then
			self:get_screen_scale()

			__target_width = math.floor(Camera.ViewportSize.X * 0.85)
			__target_height = math.floor(Camera.ViewportSize.Y * 0.75)
		end

		local __grow_tween = __create_tween(__main, {
			Size = UDim2.new(0, __target_width, 0, __target_height),
			Position = UDim2.new(0.5, -__target_width/2, 0.5, -__target_height/2)
		}, 0.25)

		__grow_tween.Completed:Connect(function()
			__main.ClipsDescendants = false

			if self.__device == 'mobile' or self.__device == 'unknown' then
				self:mobile_ui_scale()
				self:mobile_controls()
			end
		end)
	end)

	local __original_size : UDim2 = __main.Size
	local __original_position : UDim2 = __main.Position

	local __is_animating : boolean = false
	local __current_tweens : { Tween } = {}

	local __saved_scroll_positions : { [ScrollingFrame]: Vector2 } = {}

	UserInputService.InputBegan:Connect(function(__input, __process)
		if __process then
			return
		end

		if __input.KeyCode ~= Enum.KeyCode.Insert then
			return
		end

		if __is_animating then
			for _, __tween in pairs(__current_tweens) do
				if __tween then
					__tween:Cancel()
				end
			end

			__current_tweens = {}
			__is_animating = false
		end

		if not self.__minimized then
			__is_animating = true

			self.__minimized = true

			__original_size = __main.Size
			__original_position = __main.Position

			if self.__current_tab and self.__current_tab.container then
				__saved_scroll_positions[self.__current_tab.container] = self.__current_tab.container.CanvasPosition
			end

			__main.ClipsDescendants = true

			local __expand_tween = __create_tween(__main, {
				Size = UDim2.new(__original_size.X.Scale, __original_size.X.Offset + 30, __original_size.Y.Scale, __original_size.Y.Offset + 30),
				Position = UDim2.new(__original_position.X.Scale, __original_position.X.Offset - (30 / 2), __original_position.Y.Scale, __original_position.Y.Offset - (30 / 2))
			}, 0.35)

			table.insert(__current_tweens, __expand_tween)

			__expand_tween.Completed:Connect(function()
				if not self.__minimized then
					__is_animating = false
					__main.ClipsDescendants = false

					return
				end

				local __shrink_tween = __create_tween(__main, {
					Size = UDim2.new(0, 0, 0, 0),
					Position = UDim2.new(__original_position.X.Scale, __original_position.X.Offset + (__original_size.X.Offset / 2), __original_position.Y.Scale, __original_position.Y.Offset + (__original_size.Y.Offset / 2)),
					BackgroundTransparency = 1
				}, 0.3)

				table.insert(__current_tweens, __shrink_tween)

				__shrink_tween.Completed:Connect(function()
					if self.__minimized then
						__main.Visible = false
					else
						__main.ClipsDescendants = false
					end

					__is_animating = false
					__current_tweens = {}
				end)
			end)
		else
			__is_animating = true

			self.__minimized = false

			__main.Size = UDim2.new(0, 0, 0, 0)
			__main.Position = UDim2.new(__original_position.X.Scale, __original_position.X.Offset + (__original_size.X.Offset / 2), __original_position.Y.Scale, __original_position.Y.Offset + (__original_size.Y.Offset / 2))
			__main.Visible = true
			__main.BackgroundTransparency = 0.1
			__main.ClipsDescendants = true

			local __grow_tween = __create_tween(__main, {
				Size = __original_size,
				Position = __original_position
			}, 0.25)

			table.insert(__current_tweens, __grow_tween)

			__grow_tween.Completed:Connect(function()
				__main.ClipsDescendants = false

				if self.__current_tab and self.__current_tab.container then
					local __container = self.__current_tab.container

					__container.ScrollBarImageTransparency = 0
					__container.Active = true
					__container.ScrollingEnabled = true

					if __saved_scroll_positions[__container] then
						__container.CanvasPosition = __saved_scroll_positions[__container]
					end
				end

				__is_animating = false
				__current_tweens = {}
			end)
		end
	end)

	local __tab_container : Frame = Instance.new('Frame')
	__tab_container.Name = 'TabContainer'
	__tab_container.Size = UDim2.new(0, 140, 1, -51)
	__tab_container.Position = UDim2.new(0, 6.7, 0, 51)
	__tab_container.BackgroundTransparency = 1
	__tab_container.BorderSizePixel = 0
	__tab_container.ZIndex = 2
	__tab_container.Parent = __main

	local __tab_separator : Frame = Instance.new('Frame')
	__tab_separator.Size = UDim2.new(0, 1, 1, -49)
	__tab_separator.Position = UDim2.new(0, 150, 0, 49)
	__tab_separator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	__tab_separator.BorderSizePixel = 0
	__tab_separator.ZIndex = 2
	__tab_separator.Parent = __main

	local __tab_layout : UIListLayout = Instance.new('UIListLayout')
	__tab_layout.Padding = UDim.new(0, 5)
	__tab_layout.SortOrder = Enum.SortOrder.LayoutOrder
	__tab_layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	__tab_layout.Parent = __tab_container

	local __tab_padding : UIPadding = Instance.new('UIPadding')
	__tab_padding.PaddingTop = UDim.new(0, 8)
	__tab_padding.Parent = __tab_container

	__header.InputBegan:Connect(function(__input)
		if __input.UserInputType ~= Enum.UserInputType.MouseButton1 and __input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		self.__dragging = true

		self.__drag_start = __input.Position
		self.__start_pos = __main.Position

		__input.Changed:Connect(function()
			if __input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			self.__dragging = false
		end)
	end)

	__header.InputChanged:Connect(function(__input)
		if __input.UserInputType ~= Enum.UserInputType.MouseMovement and __input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		self.__drag_input = __input
	end)

	UserInputService.InputChanged:Connect(function(__input)
		if __input ~= self.__drag_input or not self.__dragging then
			return
		end

		local __delta : Vector2 = __input.Position - self.__drag_start

		__create_tween(__main, {
			Position = UDim2.new(self.__start_pos.X.Scale, self.__start_pos.X.Offset + __delta.X, self.__start_pos.Y.Scale, self.__start_pos.Y.Offset + __delta.Y)
		}, 0.5)
	end)

	function Library:create_tab(__name : string, __icon : string?) : Tab
		local __tab : Tab = {}
		__tab.__library = self

		local __tab_button : TextButton = Instance.new('TextButton')
		__tab_button.Size = UDim2.new(1, -10, 0, 35)
		__tab_button.Position = UDim2.new(0, 5, 0, 0)
		__tab_button.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
		__tab_button.BackgroundTransparency = 1
		__tab_button.BorderSizePixel = 0
		__tab_button.Text = ''
		__tab_button.AutoButtonColor = false
		__tab_button.ClipsDescendants = true
		__tab_button.ZIndex = 3
		__tab_button.Parent = __tab_container
		__create_round(__tab_button, 6)

		local __tab_outline : UIStroke = __create_outline(__tab_button)
		__tab_outline.Transparency = 1

		local __tab_highlight : Frame = Instance.new('Frame')
		__tab_highlight.Size = UDim2.new(0, 2, 0.6, 0)
		__tab_highlight.Position = UDim2.new(0, 3, 0.2, 0)
		__tab_highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		__tab_highlight.BackgroundTransparency = 1
		__tab_highlight.BorderSizePixel = 0
		__tab_highlight.ZIndex = 4
		__tab_highlight.Parent = __tab_button
		__create_round(__tab_highlight, 1)

		local __tab_highlight_effect : Frame = Instance.new('Frame')
		__tab_highlight_effect.Size = UDim2.new(1, 0, 1, 0)
		__tab_highlight_effect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		__tab_highlight_effect.BackgroundTransparency = 1
		__tab_highlight_effect.BorderSizePixel = 0
		__tab_highlight_effect.ZIndex = 3
		__tab_highlight_effect.Parent = __tab_button

		local __tab_icon : ImageLabel?
		local __label_x_offset : number = 10

		if __icon then
			__tab_icon = Instance.new('ImageLabel')
			__tab_icon.Size = UDim2.new(0, 16, 0, 16)
			__tab_icon.Position = UDim2.new(0, 10, 0.5, -8)
			__tab_icon.BackgroundTransparency = 1
			__tab_icon.Image = __icon
			__tab_icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
			__tab_icon.ZIndex = 4
			__tab_icon.Parent = __tab_button
			__label_x_offset = 32
		end

		local __tab_label : TextLabel = Instance.new('TextLabel')
		__tab_label.Size = UDim2.new(1, -__label_x_offset - 10, 1, 0)
		__tab_label.Position = UDim2.new(0, __label_x_offset, 0, 0)
		__tab_label.BackgroundTransparency = 1
		__tab_label.Text = __name
		__tab_label.TextColor3 = Color3.fromRGB(120, 120, 120)
		__tab_label.TextSize = 14
		__tab_label.Font = Enum.Font.GothamMedium
		__tab_label.TextXAlignment = Enum.TextXAlignment.Left
		__tab_label.ZIndex = 4
		__tab_label.Parent = __tab_button

		local __container : ScrollingFrame = Instance.new('ScrollingFrame')
		__container.Name = __name .. 'Container'
		__container.Size = UDim2.new(1, -170, 1, -61)
		__container.Position = UDim2.new(0, 160, 0, 51)
		__container.BackgroundTransparency = 1
		__container.BorderSizePixel = 0
		__container.ScrollBarThickness = 4
		__container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
		__container.CanvasSize = UDim2.new(0, 0, 0, 0)
		__container.Visible = false
		__container.ZIndex = 2
		__container.Parent = __main

		local __layout : UIListLayout = Instance.new('UIListLayout')
		__layout.Padding = UDim.new(0, 6)
		__layout.SortOrder = Enum.SortOrder.LayoutOrder
		__layout.Parent = __container

		local __container_padding : UIPadding = Instance.new('UIPadding')
		__container_padding.PaddingTop = UDim.new(0, 10)
		__container_padding.PaddingLeft = UDim.new(0, 1)
		__container_padding.PaddingRight = UDim.new(0, 15)
		__container_padding.PaddingBottom = UDim.new(0, 20)
		__container_padding.Parent = __container

		__layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			local __padding_bottom : number = __container_padding.PaddingBottom.Offset or 0

			__container.CanvasSize = UDim2.new(0, 0, 0, __layout.AbsoluteContentSize.Y + __container_padding.PaddingTop.Offset + __padding_bottom + 10)
		end)

		local function __activate_tab()
			for _, __t in pairs(self.__tabs) do
				__t.container.Visible = false

				__t.button.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__t.label.TextColor3 = Color3.fromRGB(120, 120, 120)
				__t.highlight.BackgroundTransparency = 1
				__t.outline.Transparency = 1
				__t.highlight_effect.BackgroundTransparency = 1

				if __t.icon then
					__t.icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
				end
			end

			__container.Visible = true

			local __layout_order : number = 0

			for _, __child in ipairs(__container:GetChildren()) do
				if not __child:IsA('Frame') then
					continue
				end

				__child.LayoutOrder = __layout_order
				__layout_order += 1

				local __original_pos : UDim2 = __child.Position
				__child.Position = UDim2.new(0, 0, 0, -20)

				local __target_transparency : number = 1

				if __child.Name == 'Divider' then
					__target_transparency = 1
				elseif __child.Name:find('Module') then
					__target_transparency = 0.3
					__child.BackgroundTransparency = 1
				elseif __child.Name:find('Button') or __child.Name:find('Checkbox') or __child.Name:find('Dropdown') then
					__target_transparency = 0.3
					__child.BackgroundTransparency = 1
				else
					__child.BackgroundTransparency = 1
				end

				local __outline_child = __child:FindFirstChild('UIStroke')

				if __outline_child then
					__outline_child.Transparency = 1
				end

				task.delay(__child.LayoutOrder * 0.03, function()
					__create_tween(__child, {
						Position = __original_pos,
						BackgroundTransparency = __target_transparency
					}, 0.25)

					if __outline_child then
						__create_tween(__outline_child, {Transparency = 0}, 0.25)
					end
				end)
			end

			__tab_button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			__tab_label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__tab_outline.Transparency = 0
			__tab_highlight.Position = UDim2.new(0, -10, 0.2, 0)
			__tab_highlight.BackgroundTransparency = 0.1

			__create_tween(__tab_highlight, {Position = UDim2.new(0, 3, 0.2, 0)}, 0.5)

			if __tab_icon then
				__tab_icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			end

			self.__current_tab = __tab
		end

		__tab_button.MouseButton1Click:Connect(__activate_tab)

		__tab.button = __tab_button
		__tab.container = __container
		__tab.label = __tab_label
		__tab.highlight = __tab_highlight
		__tab.outline = __tab_outline
		__tab.highlight_effect = __tab_highlight_effect
		__tab.icon = __tab_icon

		table.insert(self.__tabs, __tab)

		if #self.__tabs == 1 then
			__activate_tab()
		end

		function __tab:create_button(__index : { title: string, callback: () -> () })
			local __button_frame : Frame = Instance.new('Frame')
			__button_frame.Name = 'Button'
			__button_frame.Size = UDim2.new(1, 2, 0, 40)
			__button_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__button_frame.BackgroundTransparency = 0.3
			__button_frame.BorderSizePixel = 0
			__button_frame.ZIndex = 3
			__button_frame.Parent = __container
			__create_round(__button_frame, 8)
			__create_outline(__button_frame)

			local __icon : ImageLabel = Instance.new('ImageLabel')
			__icon.Size = UDim2.new(0, 18, 0, 18)
			__icon.Position = UDim2.new(1, -35, 0.5, -9)
			__icon.BackgroundTransparency = 1
			__icon.Image = 'rbxassetid://10709791437'
			__icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			__icon.ZIndex = 4
			__icon.Parent = __button_frame

			local __label : TextLabel = Instance.new('TextLabel')
			__label.Size = UDim2.new(1, -60, 1, 0)
			__label.Position = UDim2.new(0, 15, 0, 0)
			__label.BackgroundTransparency = 1
			__label.Text = __index.title
			__label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__label.TextSize = 15
			__label.Font = Enum.Font.Gotham
			__label.TextXAlignment = Enum.TextXAlignment.Left
			__label.ZIndex = 4
			__label.Parent = __button_frame

			local __button : TextButton = Instance.new('TextButton')
			__button.Size = UDim2.new(1, 0, 1, 0)
			__button.BackgroundTransparency = 1
			__button.Text = ''
			__button.ZIndex = 5
			__button.Parent = __button_frame

			__button.MouseButton1Click:Connect(function()
				__create_tween(__button_frame, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}, 0.1)

				task.delay(0.12, function()
					__create_tween(__button_frame, {BackgroundColor3 = Color3.fromRGB(8, 8, 8)}, 0.2)
				end)

				if __index.callback then
					__index.callback()
				end
			end)

			table.insert(self.__library.__all_elements, {name = __index.title, frame = __button_frame})
		end

		function __tab:create_divider(__text : string?)
			local __divider_frame : Frame = Instance.new('Frame')
			__divider_frame.Name = 'Divider'
			__divider_frame.Size = UDim2.new(1, 9, 0, 23)
			__divider_frame.BackgroundTransparency = 1
			__divider_frame.BorderSizePixel = 0
			__divider_frame.ZIndex = 3
			__divider_frame.Parent = __container
			__divider_frame.LayoutOrder = 0

			local __divider_label : TextLabel = Instance.new('TextLabel')
			__divider_label.Size = UDim2.new(1, -20, 1, 0)
			__divider_label.Position = UDim2.new(0, 5, 0, 0)
			__divider_label.BackgroundTransparency = 1
			__divider_label.Text = __text or ''
			__divider_label.TextColor3 = Color3.fromRGB(60, 60, 60)
			__divider_label.TextSize = 14
			__divider_label.Font = Enum.Font.GothamBold
			__divider_label.TextXAlignment = Enum.TextXAlignment.Left
			__divider_label.ZIndex = 4
			__divider_label.Parent = __divider_frame

			table.insert(self.__library.__all_elements, {name = __text or '', frame = __divider_frame})
		end

		function __tab:create_slider(__index : { title: string, minimum: number?, maximum: number?, default: number?, rounding: number?, callback: (value: number) -> () }) : { Set: (self: any, value: number) -> () }
			local __min : number = __index.minimum or 0
			local __max : number = __index.maximum or 100

			local __default : number = __index.default or __min
			local __rounding : number = __index.rounding or 0

			local __callback : (value: number) -> () = __index.callback or (function() end)

			local __value : number = __default
			local __dragging : boolean = false

			local __slider_frame : Frame = Instance.new('Frame')
			__slider_frame.Name = 'Slider'
			__slider_frame.Size = UDim2.new(1, 3, 0, 50)
			__slider_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__slider_frame.BackgroundTransparency = 0.3
			__slider_frame.BorderSizePixel = 0
			__slider_frame.ZIndex = 3
			__slider_frame.Parent = __container
			__create_round(__slider_frame, 8)
			__create_outline(__slider_frame)

			local __label : TextLabel = Instance.new('TextLabel')
			__label.Size = UDim2.new(0.6, 0, 0, 20)
			__label.Position = UDim2.new(0, 15, 0, 8)
			__label.BackgroundTransparency = 1
			__label.Text = __index.title
			__label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__label.TextSize = 16
			__label.Font = Enum.Font.Gotham
			__label.TextXAlignment = Enum.TextXAlignment.Left
			__label.ZIndex = 4
			__label.Parent = __slider_frame

			local __value_label : TextLabel = Instance.new('TextLabel')
			__value_label.Size = UDim2.new(0.3, 0, 0, 20)
			__value_label.Position = UDim2.new(0.7, -15, 0, 8)
			__value_label.BackgroundTransparency = 1
			__value_label.Text = tostring(__value)
			__value_label.TextColor3 = Color3.fromRGB(120, 120, 120)
			__value_label.TextSize = 13
			__value_label.Font = Enum.Font.GothamMedium
			__value_label.TextXAlignment = Enum.TextXAlignment.Right
			__value_label.ZIndex = 4
			__value_label.Parent = __slider_frame

			local __slider_track_bg : Frame = Instance.new('Frame')
			__slider_track_bg.Size = UDim2.new(1, -30, 0, 4)
			__slider_track_bg.Position = UDim2.new(0, 15, 1, -18)
			__slider_track_bg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			__slider_track_bg.BorderSizePixel = 0
			__slider_track_bg.ZIndex = 4
			__slider_track_bg.Parent = __slider_frame
			__create_round(__slider_track_bg, 2)

			local __slider_hitbox : Frame = Instance.new('Frame')
			__slider_hitbox.Size = UDim2.new(1, 0, 0, 20)
			__slider_hitbox.Position = UDim2.new(0, 0, 0.5, -10)
			__slider_hitbox.BackgroundTransparency = 1
			__slider_hitbox.ZIndex = 7
			__slider_hitbox.Parent = __slider_track_bg

			local __slider_track : Frame = Instance.new('Frame')
			__slider_track.Size = UDim2.new(0, 0, 1, 0)
			__slider_track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			__slider_track.BorderSizePixel = 0
			__slider_track.ZIndex = 5
			__slider_track.Parent = __slider_track_bg
			__create_round(__slider_track, 2)

			local __slider_ball : Frame = Instance.new('Frame')
			__slider_ball.Size = UDim2.new(0, 10, 0, 10)
			__slider_ball.Position = UDim2.new(1, -5, 0.5, -5)
			__slider_ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			__slider_ball.BorderSizePixel = 0
			__slider_ball.ZIndex = 6
			__slider_ball.Parent = __slider_track
			__create_round(__slider_ball, 5)
			__create_outline(__slider_ball)

			local function __update_slider(__input : InputObject)
				local __position : number = math.clamp((__input.Position.X - __slider_track_bg.AbsolutePosition.X) / __slider_track_bg.AbsoluteSize.X, 0, 1)

				__value = math.floor(__min + (__max - __min) * __position)

				if __rounding > 0 then
					__value = math.floor(__value / __rounding) * __rounding
				end

				__value = math.clamp(__value, __min, __max)
				__value_label.Text = tostring(__value)

				__create_tween(__slider_track, {Size = UDim2.new(__position, 0, 1, 0)}, 0.1)

				__callback(__value)
			end

			local function __set_value(__new_value : number)
				__value = math.clamp(__new_value, __min, __max)

				if __rounding > 0 then
					__value = math.floor(__value / __rounding) * __rounding
				end

				__value_label.Text = tostring(__value)
				__slider_track.Size = UDim2.new((__value - __min) / (__max - __min), 0, 1, 0)

				__callback(__value)
			end

			__set_value(__default)

			__slider_hitbox.InputBegan:Connect(function(__input)
				if __input.UserInputType ~= Enum.UserInputType.MouseButton1 and __input.UserInputType ~= Enum.UserInputType.Touch then
					return
				end

				__dragging = true

				__create_tween(__slider_ball, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)}, 0.2)
				__update_slider(__input)
			end)

			__slider_hitbox.InputEnded:Connect(function(__input)
				if __input.UserInputType ~= Enum.UserInputType.MouseButton1 and __input.UserInputType ~= Enum.UserInputType.Touch then
					return
				end

				__dragging = false

				__create_tween(__slider_ball, {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -5, 0.5, -5)}, 0.2)
			end)

			UserInputService.InputChanged:Connect(function(__input)
				if not __dragging or (__input.UserInputType ~= Enum.UserInputType.MouseMovement and __input.UserInputType ~= Enum.UserInputType.Touch) then
					return
				end

				__update_slider(__input)
			end)

			table.insert(self.__library.__all_elements, {name = __index.title, frame = __slider_frame})

			return {
				Set = function(__self, __new_value : number)
					__set_value(__new_value)
				end
			}
		end

		function __tab:create_textbox(__index : { title: string, placeholder: string?, callback: (text: string) -> () }) : { Set: (self: any, text: string) -> () }
			local __callback : (text: string) -> () = __index.callback or (function() end)

			local __textbox_frame : Frame = Instance.new('Frame')
			__textbox_frame.Name = 'Textbox'
			__textbox_frame.Size = UDim2.new(1, 2, 0, 40)
			__textbox_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__textbox_frame.BackgroundTransparency = 0.3
			__textbox_frame.BorderSizePixel = 0
			__textbox_frame.ZIndex = 3
			__textbox_frame.Parent = __container
			__create_round(__textbox_frame, 8)
			__create_outline(__textbox_frame)

			local __label : TextLabel = Instance.new('TextLabel')
			__label.Size = UDim2.new(0, 100, 1, 0)
			__label.Position = UDim2.new(0, 15, 0, 0)
			__label.BackgroundTransparency = 1
			__label.Text = __index.title
			__label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__label.TextSize = 16
			__label.Font = Enum.Font.Gotham
			__label.TextXAlignment = Enum.TextXAlignment.Left
			__label.ZIndex = 4
			__label.Parent = __textbox_frame

			local __input_container : Frame = Instance.new('Frame')
			__input_container.Size = UDim2.new(0, 200, 0, 28)
			__input_container.Position = UDim2.new(1, -210, 0.5, -14)
			__input_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__input_container.BackgroundTransparency = 0.4
			__input_container.BorderSizePixel = 0
			__input_container.ZIndex = 4
			__input_container.Parent = __textbox_frame
			__create_round(__input_container, 6)
			__create_outline(__input_container)

			local __icon_container : Frame = Instance.new('Frame')
			__icon_container.Size = UDim2.new(0, 28, 1, 0)
			__icon_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__icon_container.BackgroundTransparency = 0.6
			__icon_container.BorderSizePixel = 0
			__icon_container.ZIndex = 4
			__icon_container.Parent = __input_container
			__create_round(__icon_container, 6)

			local __input_divider : Frame = Instance.new('Frame')
			__input_divider.Size = UDim2.new(0, 1, 0.6, 0)
			__input_divider.Position = UDim2.new(0, 28, 0.2, 0)
			__input_divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			__input_divider.BorderSizePixel = 0
			__input_divider.ZIndex = 5
			__input_divider.Parent = __input_container

			local __textbox_icon : ImageLabel = Instance.new('ImageLabel')
			__textbox_icon.Size = UDim2.new(0, 16, 0, 16)
			__textbox_icon.Position = UDim2.new(0.5, -8, 0.5, -8)
			__textbox_icon.BackgroundTransparency = 1
			__textbox_icon.Image = 'rbxassetid://10723433811'
			__textbox_icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
			__textbox_icon.ZIndex = 5
			__textbox_icon.Parent = __icon_container

			local __textbox : TextBox = Instance.new('TextBox')
			__textbox.Size = UDim2.new(1, -35, 1, 0)
			__textbox.Position = UDim2.new(0, 32, 0, 0)
			__textbox.BackgroundTransparency = 1
			__textbox.Text = ''
			__textbox.PlaceholderText = __index.placeholder or ''
			__textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
			__textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
			__textbox.TextSize = 13
			__textbox.Font = Enum.Font.Gotham
			__textbox.TextXAlignment = Enum.TextXAlignment.Left
			__textbox.ClearTextOnFocus = false
			__textbox.ZIndex = 5
			__textbox.Parent = __input_container

			__textbox.FocusLost:Connect(function(__enter_pressed)
				if not __enter_pressed then
					return
				end

				__callback(__textbox.Text)
			end)

			table.insert(self.__library.__all_elements, {name = __index.title, frame = __textbox_frame})

			return {
				Set = function(__self, __new_text : string)
					__textbox.Text = __new_text
				end
			}
		end

		function __tab:create_module(__index : { title: string, default: boolean?, callback: (state: boolean) -> () }) : Module
			local __module : Module = {}

			__module.__elements = {}
			__module.__library = self.__library

			local __default : boolean = __index.default or false
			local __callback : (state: boolean) -> () = __index.callback or (function() end)
			local __toggled : boolean = __default
			local __current_keybind : Enum.KeyCode? = nil
			local __waiting_for_key : boolean = false

			local __module_frame : Frame = Instance.new('Frame')
			__module_frame.Name = 'Module'
			__module_frame.Size = UDim2.new(1, 2, 0, 40)
			__module_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__module_frame.BackgroundTransparency = 0.3
			__module_frame.BorderSizePixel = 0
			__module_frame.ClipsDescendants = false
			__module_frame.ZIndex = 3
			__module_frame.Parent = __container
			__create_round(__module_frame, 8)
			__create_outline(__module_frame)

			local __label : TextLabel = Instance.new('TextLabel')
			__label.Size = UDim2.new(1, -110, 0, 40)
			__label.Position = UDim2.new(0, 15, 0, 0)
			__label.BackgroundTransparency = 1
			__label.Text = __index.title
			__label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__label.TextSize = 15
			__label.Font = Enum.Font.Gotham
			__label.TextXAlignment = Enum.TextXAlignment.Left
			__label.ZIndex = 4
			__label.Parent = __module_frame

			local __keybind_btn : TextButton = Instance.new('TextButton')
			__keybind_btn.Size = UDim2.new(0, 30, 0, 24)
			__keybind_btn.Position = UDim2.new(1, -90, 0, 8)
			__keybind_btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			__keybind_btn.BorderSizePixel = 0
			__keybind_btn.Text = ''
			__keybind_btn.ZIndex = 5
			__keybind_btn.Parent = __module_frame
			__create_round(__keybind_btn, 6)
			__create_outline(__keybind_btn)

			local __keybind_icon : ImageLabel = Instance.new('ImageLabel')
			__keybind_icon.Size = UDim2.new(0, 16, 0, 16)
			__keybind_icon.Position = UDim2.new(0.5, -8, 0.5, -8)
			__keybind_icon.BackgroundTransparency = 1
			__keybind_icon.Image = 'rbxassetid://10709818996'
			__keybind_icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
			__keybind_icon.ZIndex = 6
			__keybind_icon.Parent = __keybind_btn

			local __keybind_label : TextLabel = Instance.new('TextLabel')
			__keybind_label.Size = UDim2.new(1, 0, 1, 0)
			__keybind_label.BackgroundTransparency = 1
			__keybind_label.Text = ''
			__keybind_label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__keybind_label.TextSize = 10
			__keybind_label.Font = Enum.Font.GothamBold
			__keybind_label.ZIndex = 7
			__keybind_label.Parent = __keybind_btn

			local __toggle_frame : Frame = Instance.new('Frame')
			__toggle_frame.Size = UDim2.new(0, 45, 0, 24)
			__toggle_frame.Position = UDim2.new(1, -55, 0, 8)
			__toggle_frame.BackgroundColor3 = __toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 25)
			__toggle_frame.BorderSizePixel = 0
			__toggle_frame.ZIndex = 4
			__toggle_frame.Parent = __module_frame
			__create_round(__toggle_frame, 12)
			__create_outline(__toggle_frame)

			local __toggle_circle : Frame = Instance.new('Frame')
			__toggle_circle.Size = UDim2.new(0, 18, 0, 18)
			__toggle_circle.Position = __toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
			__toggle_circle.BackgroundColor3 = __toggled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
			__toggle_circle.BorderSizePixel = 0
			__toggle_circle.ZIndex = 5
			__toggle_circle.Parent = __toggle_frame
			__create_round(__toggle_circle, 9)

			local __button : TextButton = Instance.new('TextButton')
			__button.Size = UDim2.new(1, -100, 0, 40)
			__button.BackgroundTransparency = 1
			__button.Text = ''
			__button.ZIndex = 5
			__button.Parent = __module_frame

			local __toggle_button : TextButton = Instance.new('TextButton')
			__toggle_button.Size = UDim2.new(0, 45, 0, 24)
			__toggle_button.Position = UDim2.new(1, -55, 0, 8)
			__toggle_button.BackgroundTransparency = 1
			__toggle_button.Text = ''
			__toggle_button.ZIndex = 6
			__toggle_button.Parent = __module_frame

			local __module_separator : Frame = Instance.new('Frame')
			__module_separator.Size = UDim2.new(1, -20, 0, 1)
			__module_separator.Position = UDim2.new(0, 10, 0, 40)
			__module_separator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			__module_separator.BorderSizePixel = 0
			__module_separator.ZIndex = 4
			__module_separator.Visible = false
			__module_separator.Parent = __module_frame

			local __module_container : Frame = Instance.new('Frame')
			__module_container.Size = UDim2.new(1, 0, 0, 0)
			__module_container.Position = UDim2.new(0, 0, 0, 45)
			__module_container.BackgroundTransparency = 1
			__module_container.Visible = false
			__module_container.ZIndex = 4
			__module_container.Parent = __module_frame

			local __module_padding : UIPadding = Instance.new('UIPadding')
			__module_padding.PaddingLeft = UDim.new(0, 10)
			__module_padding.PaddingRight = UDim.new(0, 10)
			__module_padding.PaddingTop = UDim.new(0, 1)
			__module_padding.Parent = __module_container

			local __module_layout : UIListLayout = Instance.new('UIListLayout')
			__module_layout.Padding = UDim.new(0, 5)
			__module_layout.SortOrder = Enum.SortOrder.LayoutOrder
			__module_layout.Parent = __module_container

			local function __update_module_height()
				local __total_height : number = 40

				for _, __elem in pairs(__module.__elements) do
					__total_height += __elem.Size.Y.Offset + 5
				end

				__create_tween(__module_frame, {Size = UDim2.new(1, 2, 0, __total_height + 10)}, 0.3)
			end

			local function __toggle_module(__state : boolean)
				if __toggled == __state then
					return
				end

				__toggled = __state

				__create_tween(__toggle_frame, {BackgroundColor3 = __toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 25)}, 0.3)
				__create_tween(__toggle_circle, {
					Position = __toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
					BackgroundColor3 = __toggled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
				}, 0.3)

				if __toggled and #__module.__elements > 0 then
					__module_separator.Visible = true
					__module_container.Visible = true

					__update_module_height()
				elseif not __toggled then
					__create_tween(__module_frame, {Size = UDim2.new(1, 2, 0, 40)}, 0.3)

					__module_separator.Visible = false
					__module_container.Visible = false
				end

				__callback(__toggled)
			end

			__keybind_btn.MouseButton1Click:Connect(function()
				if __waiting_for_key then
					__waiting_for_key = false
					__keybind_label.Text = __current_keybind and __current_keybind.Name or ''

					__create_tween(__keybind_icon, {ImageTransparency = __current_keybind and 1 or 0}, 0.2)

					return
				end

				__waiting_for_key = true
				__keybind_label.Text = '...'

				__create_tween(__keybind_icon, {ImageTransparency = 1}, 0.2)

				local __connection
				__connection = UserInputService.InputBegan:Connect(function(__input, __process)
					if __process then
						return
					end

					if __input.UserInputType ~= Enum.UserInputType.Keyboard then
						return
					end

					__waiting_for_key = false
					__current_keybind = __input.KeyCode
					__keybind_label.Text = __input.KeyCode.Name
					__keybind_icon.ImageTransparency = 1

					__connection:Disconnect()
				end)
			end)

			UserInputService.InputBegan:Connect(function(__input, __process)
				if __process or __waiting_for_key then
					return
				end

				if __current_keybind and __input.KeyCode == __current_keybind then
					__toggle_module(not __toggled)
				end
			end)

			__button.MouseButton1Click:Connect(function()
				__toggle_module(not __toggled)
			end)

			__toggle_button.MouseButton1Click:Connect(function()
				__toggle_module(not __toggled)
			end)

			function __module:create_checkbox(__index : { title: string, default: boolean?, callback: (state: boolean) -> () })
				local __item_default : boolean = __index.default or false
				local __item_callback : (state: boolean) -> () = __index.callback or (function() end)

				local __item_toggled : boolean = __item_default

				local __item_frame : Frame = Instance.new('Frame')
				__item_frame.Size = UDim2.new(1, 0, 0, 35)
				__item_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__item_frame.BackgroundTransparency = 0.2
				__item_frame.BorderSizePixel = 0
				__item_frame.ZIndex = 4
				__item_frame.Parent = __module_container
				__create_round(__item_frame, 6)
				__create_outline(__item_frame)

				local __item_label : TextLabel = Instance.new('TextLabel')
				__item_label.Size = UDim2.new(1, -60, 1, 0)
				__item_label.Position = UDim2.new(0, 15, 0, 0)
				__item_label.BackgroundTransparency = 1
				__item_label.Text = __index.title
				__item_label.TextColor3 = Color3.fromRGB(120, 120, 120)
				__item_label.TextSize = 13
				__item_label.Font = Enum.Font.Gotham
				__item_label.TextXAlignment = Enum.TextXAlignment.Left
				__item_label.ZIndex = 5
				__item_label.Parent = __item_frame

				local __item_check_frame : Frame = Instance.new('Frame')
				__item_check_frame.Size = UDim2.new(0, 20, 0, 20)
				__item_check_frame.Position = UDim2.new(1, -35, 0.5, -10)
				__item_check_frame.BackgroundColor3 = __item_toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 25)
				__item_check_frame.BorderSizePixel = 0
				__item_check_frame.ZIndex = 5
				__item_check_frame.Parent = __item_frame
				__create_round(__item_check_frame, 5)
				__create_outline(__item_check_frame)

				local __item_check_icon : ImageLabel = Instance.new('ImageLabel')
				__item_check_icon.Size = UDim2.new(0, 14, 0, 14)
				__item_check_icon.Position = UDim2.new(0.5, -7, 0.5, -7)
				__item_check_icon.BackgroundTransparency = 1
				__item_check_icon.Image = 'rbxassetid://10709790644'
				__item_check_icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
				__item_check_icon.ImageTransparency = __item_toggled and 0.2 or 1
				__item_check_icon.ZIndex = 6
				__item_check_icon.Parent = __item_check_frame

				local __item_button : TextButton = Instance.new('TextButton')
				__item_button.Size = UDim2.new(1, 0, 1, 0)
				__item_button.BackgroundTransparency = 1
				__item_button.Text = ''
				__item_button.ZIndex = 6
				__item_button.Parent = __item_frame

				__item_button.MouseButton1Click:Connect(function()
					__item_toggled = not __item_toggled

					__create_tween(__item_check_frame, {BackgroundColor3 = __item_toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 25)}, 0.3)
					__create_tween(__item_check_icon, {ImageTransparency = __item_toggled and 0.2 or 1}, 0.3)

					__item_callback(__item_toggled)
				end)

				table.insert(__module.__elements, __item_frame)

				if __toggled then
					__update_module_height()
				end
			end

			function __module:create_divider(__text : string?)
				local __item_frame : Frame = Instance.new('Frame')
				__item_frame.Name = 'DividerItem'
				__item_frame.Size = UDim2.new(1, 9, 0, 22)
				__item_frame.BackgroundTransparency = 1
				__item_frame.BorderSizePixel = 0
				__item_frame.ZIndex = 4
				__item_frame.Parent = __module_container

				local __divider_label : TextLabel = Instance.new('TextLabel')
				__divider_label.Size = UDim2.new(1, -20, 1, 0)
				__divider_label.Position = UDim2.new(0, 5, 0, 0)
				__divider_label.BackgroundTransparency = 1
				__divider_label.Text = __text or ''
				__divider_label.TextColor3 = Color3.fromRGB(50, 50, 50)
				__divider_label.TextSize = 13
				__divider_label.Font = Enum.Font.GothamBold
				__divider_label.TextXAlignment = Enum.TextXAlignment.Left
				__divider_label.ZIndex = 5
				__divider_label.Parent = __item_frame

				table.insert(__module.__elements, __item_frame)

				if __toggled then
					__update_module_height()
				end
			end

			function __module:create_textbox(__index : { title: string, placeholder: string?, callback: (text: string) -> () }) : { Set: (self: any, text: string) -> () }
				local __item_callback : (text: string) -> () = __index.callback or (function() end)

				local __item_frame : Frame = Instance.new('Frame')
				__item_frame.Name = 'TextboxItem'
				__item_frame.Size = UDim2.new(1, 0, 0, 40)
				__item_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__item_frame.BackgroundTransparency = 0.2
				__item_frame.BorderSizePixel = 0
				__item_frame.ZIndex = 4
				__item_frame.Parent = __module_container
				__create_round(__item_frame, 6)
				__create_outline(__item_frame)

				local __label : TextLabel = Instance.new('TextLabel')
				__label.Size = UDim2.new(0, 100, 1, 0)
				__label.Position = UDim2.new(0, 15, 0, 0)
				__label.BackgroundTransparency = 1
				__label.Text = __index.title
				__label.TextColor3 = Color3.fromRGB(120, 120, 120)
				__label.TextSize = 14
				__label.Font = Enum.Font.Gotham
				__label.TextXAlignment = Enum.TextXAlignment.Left
				__label.ZIndex = 5
				__label.Parent = __item_frame

				local __input_container : Frame = Instance.new('Frame')
				__input_container.Size = UDim2.new(0, 200, 0, 28)
				__input_container.Position = UDim2.new(1, -210, 0.5, -14)
				__input_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__input_container.BackgroundTransparency = 0.4
				__input_container.BorderSizePixel = 0
				__input_container.ZIndex = 4
				__input_container.Parent = __item_frame
				__create_round(__input_container, 6)
				__create_outline(__input_container)

				local __icon_container : Frame = Instance.new('Frame')
				__icon_container.Size = UDim2.new(0, 28, 1, 0)
				__icon_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__icon_container.BackgroundTransparency = 0.6
				__icon_container.BorderSizePixel = 0
				__icon_container.ZIndex = 4
				__icon_container.Parent = __input_container
				__create_round(__icon_container, 6)

				local __input_divider : Frame = Instance.new('Frame')
				__input_divider.Size = UDim2.new(0, 1, 0.6, 0)
				__input_divider.Position = UDim2.new(0, 28, 0.2, 0)
				__input_divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				__input_divider.BorderSizePixel = 0
				__input_divider.ZIndex = 5
				__input_divider.Parent = __input_container

				local __textbox_icon : ImageLabel = Instance.new('ImageLabel')
				__textbox_icon.Size = UDim2.new(0, 16, 0, 16)
				__textbox_icon.Position = UDim2.new(0.5, -8, 0.5, -8)
				__textbox_icon.BackgroundTransparency = 1
				__textbox_icon.Image = 'rbxassetid://10723433811'
				__textbox_icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
				__textbox_icon.ZIndex = 5
				__textbox_icon.Parent = __icon_container

				local __textbox : TextBox = Instance.new('TextBox')
				__textbox.Size = UDim2.new(1, -35, 1, 0)
				__textbox.Position = UDim2.new(0, 32, 0, 0)
				__textbox.BackgroundTransparency = 1
				__textbox.Text = ''
				__textbox.PlaceholderText = __index.placeholder or ''
				__textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
				__textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
				__textbox.TextSize = 13
				__textbox.Font = Enum.Font.Gotham
				__textbox.TextXAlignment = Enum.TextXAlignment.Left
				__textbox.ClearTextOnFocus = false
				__textbox.ZIndex = 5
				__textbox.Parent = __input_container

				__textbox.FocusLost:Connect(function(__enter_pressed)
					if not __enter_pressed then
						return
					end

					__item_callback(__textbox.Text)
				end)

				table.insert(__module.__elements, __item_frame)

				if __toggled then
					__update_module_height()
				end

				return {
					Set = function(__self, __new_text : string)
						__textbox.Text = __new_text
					end
				}
			end

			function __module:create_slider(__index : { title: string, minimum: number?, maximum: number?, default: number?, rounding: number?, callback: (value: number) -> () }) : { Set: (self: any, value: number) -> () }
				local __min : number = __index.minimum or 0
				local __max : number = __index.maximum or 100

				local __default : number = __index.default or __min
				local __rounding : number = __index.rounding or 0

				local __item_callback : (value: number) -> () = __index.callback or (function() end)

				local __value : number = __default
				local __dragging : boolean = false

				local __item_frame : Frame = Instance.new('Frame')
				__item_frame.Name = 'SliderItem'
				__item_frame.Size = UDim2.new(1, 0, 0, 50)
				__item_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__item_frame.BackgroundTransparency = 0.2
				__item_frame.BorderSizePixel = 0
				__item_frame.ZIndex = 4
				__item_frame.Parent = __module_container
				__create_round(__item_frame, 8)
				__create_outline(__item_frame)

				local __label : TextLabel = Instance.new('TextLabel')
				__label.Size = UDim2.new(0.6, 0, 0, 20)
				__label.Position = UDim2.new(0, 15, 0, 8)
				__label.BackgroundTransparency = 1
				__label.Text = __index.title
				__label.TextColor3 = Color3.fromRGB(120, 120, 120)
				__label.TextSize = 14
				__label.Font = Enum.Font.Gotham
				__label.TextXAlignment = Enum.TextXAlignment.Left
				__label.ZIndex = 5
				__label.Parent = __item_frame

				local __value_label : TextLabel = Instance.new('TextLabel')
				__value_label.Size = UDim2.new(0.3, 0, 0, 20)
				__value_label.Position = UDim2.new(0.7, -15, 0, 8)
				__value_label.BackgroundTransparency = 1
				__value_label.Text = tostring(__value)
				__value_label.TextColor3 = Color3.fromRGB(120, 120, 120)
				__value_label.TextSize = 11
				__value_label.Font = Enum.Font.GothamMedium
				__value_label.TextXAlignment = Enum.TextXAlignment.Right
				__value_label.ZIndex = 5
				__value_label.Parent = __item_frame

				local __slider_track_bg : Frame = Instance.new('Frame')
				__slider_track_bg.Size = UDim2.new(1, -30, 0, 4)
				__slider_track_bg.Position = UDim2.new(0, 15, 1, -18)
				__slider_track_bg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				__slider_track_bg.BorderSizePixel = 0
				__slider_track_bg.ZIndex = 4
				__slider_track_bg.Parent = __item_frame
				__create_round(__slider_track_bg, 2)

				local __slider_hitbox : Frame = Instance.new('Frame')
				__slider_hitbox.Size = UDim2.new(1, 0, 0, 20)
				__slider_hitbox.Position = UDim2.new(0, 0, 0.5, -10)
				__slider_hitbox.BackgroundTransparency = 1
				__slider_hitbox.ZIndex = 7
				__slider_hitbox.Parent = __slider_track_bg

				local __slider_track : Frame = Instance.new('Frame')
				__slider_track.Size = UDim2.new(0, 0, 1, 0)
				__slider_track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				__slider_track.BorderSizePixel = 0
				__slider_track.ZIndex = 5
				__slider_track.Parent = __slider_track_bg
				__create_round(__slider_track, 2)

				local __slider_ball : Frame = Instance.new('Frame')
				__slider_ball.Size = UDim2.new(0, 10, 0, 10)
				__slider_ball.Position = UDim2.new(1, -5, 0.5, -5)
				__slider_ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				__slider_ball.BorderSizePixel = 0
				__slider_ball.ZIndex = 6
				__slider_ball.Parent = __slider_track
				__create_round(__slider_ball, 5)
				__create_outline(__slider_ball)

				local function __update_slider(__input : InputObject)
					local __position : number = math.clamp((__input.Position.X - __slider_track_bg.AbsolutePosition.X) / __slider_track_bg.AbsoluteSize.X, 0, 1)

					__value = math.floor(__min + (__max - __min) * __position)

					if __rounding > 0 then
						__value = math.floor(__value / __rounding) * __rounding
					end

					__value = math.clamp(__value, __min, __max)
					__value_label.Text = tostring(__value)

					__create_tween(__slider_track, {Size = UDim2.new(__position, 0, 1, 0)}, 0.1)

					__item_callback(__value)
				end

				local function __set_value(__new_value : number)
					__value = math.clamp(__new_value, __min, __max)

					if __rounding > 0 then
						__value = math.floor(__value / __rounding) * __rounding
					end

					__value_label.Text = tostring(__value)
					__slider_track.Size = UDim2.new((__value - __min) / (__max - __min), 0, 1, 0)

					__item_callback(__value)
				end

				__set_value(__default)

				__slider_hitbox.InputBegan:Connect(function(__input)
					if __input.UserInputType ~= Enum.UserInputType.MouseButton1 and __input.UserInputType ~= Enum.UserInputType.Touch then
						return
					end

					__dragging = true

					__create_tween(__slider_ball, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)}, 0.2)
					__update_slider(__input)
				end)

				__slider_hitbox.InputEnded:Connect(function(__input)
					if __input.UserInputType ~= Enum.UserInputType.MouseButton1 and __input.UserInputType ~= Enum.UserInputType.Touch then
						return
					end

					__dragging = false

					__create_tween(__slider_ball, {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -5, 0.5, -5)}, 0.2)
				end)

				UserInputService.InputChanged:Connect(function(__input)
					if not __dragging or (__input.UserInputType ~= Enum.UserInputType.MouseMovement and __input.UserInputType ~= Enum.UserInputType.Touch) then
						return
					end

					__update_slider(__input)
				end)

				table.insert(__module.__elements, __item_frame)

				if __toggled then
					__update_module_height()
				end

				return {
					Set = function(__self, __new_value : number)
						__set_value(__new_value)
					end
				}
			end

			function __module:create_button(__index : { title: string, callback: () -> () })
				local __item_callback : () -> () = __index.callback or (function() end)

				local __item_frame : Frame = Instance.new('Frame')
				__item_frame.Name = 'ButtonItem'
				__item_frame.Size = UDim2.new(1, 0, 0, 35)
				__item_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__item_frame.BackgroundTransparency = 0.2
				__item_frame.BorderSizePixel = 0
				__item_frame.ZIndex = 4
				__item_frame.Parent = __module_container
				__create_round(__item_frame, 6)
				__create_outline(__item_frame)

				local __icon : ImageLabel = Instance.new('ImageLabel')
				__icon.Size = UDim2.new(0, 18, 0, 18)
				__icon.Position = UDim2.new(1, -35, 0.5, -9)
				__icon.BackgroundTransparency = 1
				__icon.Image = 'rbxassetid://10709791437'
				__icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
				__icon.ZIndex = 5
				__icon.Parent = __item_frame

				local __label : TextLabel = Instance.new('TextLabel')
				__label.Size = UDim2.new(1, -60, 1, 0)
				__label.Position = UDim2.new(0, 15, 0, 0)
				__label.BackgroundTransparency = 1
				__label.Text = __index.title
				__label.TextColor3 = Color3.fromRGB(120, 120, 120)
				__label.TextSize = 13
				__label.Font = Enum.Font.Gotham
				__label.TextXAlignment = Enum.TextXAlignment.Left
				__label.ZIndex = 5
				__label.Parent = __item_frame

				local __button : TextButton = Instance.new('TextButton')
				__button.Size = UDim2.new(1, 0, 1, 0)
				__button.BackgroundTransparency = 1
				__button.Text = ''
				__button.ZIndex = 6
				__button.Parent = __item_frame

				__button.MouseButton1Click:Connect(function()
					__create_tween(__item_frame, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}, 0.1)

					task.delay(0.12, function()
						__create_tween(__item_frame, {BackgroundColor3 = Color3.fromRGB(8, 8, 8)}, 0.2)
					end)

					__item_callback()
				end)

				table.insert(__module.__elements, __item_frame)

				if __toggled then
					__update_module_height()
				end
			end

			function __module:create_dropdown(__index : { title: string, options: { string }, default: string | { string }?, multi_selection: boolean?, callback: (value: string | { string }) -> () }) : { Set: (self: any, value: string | { string }) -> () }
				local __options_list : { string } = __index.options or {}

				local __default_value : string | { string } = __index.default or '--'
				local __multi_selection : boolean = __index.multi_selection or false

				local __item_callback : (value: string | { string }) -> () = __index.callback or (function() end)

				local __selected : string | { string } = {}

				if not __multi_selection then
					__selected = (__default_value ~= '--' and __default_value :: string) or __options_list[1]
				else
					__selected = (type(__default_value) == 'table' and __default_value :: { string }) or {}
				end

				local __opened : boolean = false
				local __is_animating : boolean = false

				local __item_frame : Frame = Instance.new('Frame')
				__item_frame.Name = 'DropdownItem'
				__item_frame.Size = UDim2.new(1, 0, 0, 35)
				__item_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__item_frame.BackgroundTransparency = 0.2
				__item_frame.BorderSizePixel = 0
				__item_frame.ClipsDescendants = false
				__item_frame.ZIndex = 4
				__item_frame.Parent = __module_container
				__create_round(__item_frame, 6)
				__create_outline(__item_frame)

				local __item_label : TextLabel = Instance.new('TextLabel')
				__item_label.Size = UDim2.new(0.5, 0, 1, 0)
				__item_label.Position = UDim2.new(0, 15, 0, 0)
				__item_label.BackgroundTransparency = 1
				__item_label.Text = __index.title
				__item_label.TextColor3 = Color3.fromRGB(120, 120, 120)
				__item_label.TextSize = 13
				__item_label.Font = Enum.Font.Gotham
				__item_label.TextXAlignment = Enum.TextXAlignment.Left
				__item_label.ZIndex = 5
				__item_label.Parent = __item_frame

				local __dropdown_container : Frame = Instance.new('Frame')
				__dropdown_container.Size = UDim2.new(0, 135, 0, 24)
				__dropdown_container.Position = UDim2.new(1, -145, 0.5, -12)
				__dropdown_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__dropdown_container.BackgroundTransparency = 0
				__dropdown_container.BorderSizePixel = 0
				__dropdown_container.ClipsDescendants = true
				__dropdown_container.ZIndex = 15
				__dropdown_container.Parent = __item_frame
				__create_round(__dropdown_container, 6)
				__create_outline(__dropdown_container)

				local function __get_display_text() : string
					if __multi_selection then
						if #(__selected :: { string }) == 0 then
							return '--'
						end

						return table.concat(__selected :: { string }, ', ')
					else
						return __selected :: string
					end
				end

				local __icon_container : Frame = Instance.new('Frame')
				__icon_container.Size = UDim2.new(0, 24, 0, 24)
				__icon_container.Position = UDim2.new(1, -24, 0, 0)
				__icon_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__icon_container.BackgroundTransparency = 0.6
				__icon_container.BorderSizePixel = 0
				__icon_container.ZIndex = 16
				__icon_container.Parent = __dropdown_container
				__create_round(__icon_container, 6)

				local __arrow : ImageLabel = Instance.new('ImageLabel')
				__arrow.Size = UDim2.new(0, 12, 0, 12)
				__arrow.Position = UDim2.new(0.5, -6, 0.5, -6)
				__arrow.BackgroundTransparency = 1
				__arrow.Image = 'rbxassetid://10709790948'
				__arrow.ImageColor3 = Color3.fromRGB(120, 120, 120)
				__arrow.Rotation = 0
				__arrow.ZIndex = 17
				__arrow.Parent = __icon_container

				local __input_divider : Frame = Instance.new('Frame')
				__input_divider.Size = UDim2.new(0, 1, 0, 14)
				__input_divider.Position = UDim2.new(1, -25, 0, 5)
				__input_divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				__input_divider.BorderSizePixel = 0
				__input_divider.ZIndex = 17
				__input_divider.Parent = __dropdown_container

				local __selected_label : TextLabel = Instance.new('TextLabel')
				__selected_label.Size = UDim2.new(1, -30, 0, 24)
				__selected_label.Position = UDim2.new(0, 8, 0, 0)
				__selected_label.BackgroundTransparency = 1
				__selected_label.Text = __get_display_text()
				__selected_label.TextColor3 = Color3.fromRGB(255, 255, 255)
				__selected_label.TextSize = 11
				__selected_label.Font = Enum.Font.Gotham
				__selected_label.TextXAlignment = Enum.TextXAlignment.Left
				__selected_label.TextTruncate = Enum.TextTruncate.None
				__selected_label.ClipsDescendants = true
				__selected_label.ZIndex = 16
				__selected_label.Parent = __dropdown_container

				local __fade_gradient : UIGradient = Instance.new('UIGradient')
				__fade_gradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
				}
				__fade_gradient.Transparency = NumberSequence.new{
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(0.75, 0.4),
					NumberSequenceKeypoint.new(0.85, 0.7),
					NumberSequenceKeypoint.new(0.95, 0.9),
					NumberSequenceKeypoint.new(1, 1)
				}
				__fade_gradient.Parent = __selected_label

				local __dropdown_search_container : Frame = Instance.new('Frame')
				__dropdown_search_container.Size = UDim2.new(1, -10, 0, 26)
				__dropdown_search_container.Position = UDim2.new(0, 5, 0, 26)
				__dropdown_search_container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				__dropdown_search_container.BorderSizePixel = 0
				__dropdown_search_container.Visible = false
				__dropdown_search_container.ZIndex = 17
				__dropdown_search_container.Parent = __dropdown_container
				__create_round(__dropdown_search_container, 5)

				local __dropdown_search_icon_container : Frame = Instance.new('Frame')
				__dropdown_search_icon_container.Size = UDim2.new(0, 26, 1, 0)
				__dropdown_search_icon_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
				__dropdown_search_icon_container.BackgroundTransparency = 0.5
				__dropdown_search_icon_container.BorderSizePixel = 0
				__dropdown_search_icon_container.ZIndex = 17
				__dropdown_search_icon_container.Parent = __dropdown_search_container
				__create_round(__dropdown_search_icon_container, 5)

				local __dropdown_search_divider : Frame = Instance.new('Frame')
				__dropdown_search_divider.Size = UDim2.new(0, 1, 0.6, 0)
				__dropdown_search_divider.Position = UDim2.new(0, 26, 0.2, 0)
				__dropdown_search_divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				__dropdown_search_divider.BorderSizePixel = 0
				__dropdown_search_divider.ZIndex = 18
				__dropdown_search_divider.Parent = __dropdown_search_container

				local __dropdown_search_icon : ImageLabel = Instance.new('ImageLabel')
				__dropdown_search_icon.Size = UDim2.new(0, 12, 0, 12)
				__dropdown_search_icon.Position = UDim2.new(0.5, -6, 0.5, -6)
				__dropdown_search_icon.BackgroundTransparency = 1
				__dropdown_search_icon.Image = 'rbxassetid://10734943674'
				__dropdown_search_icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
				__dropdown_search_icon.ZIndex = 18
				__dropdown_search_icon.Parent = __dropdown_search_icon_container

				local __dropdown_search : TextBox = Instance.new('TextBox')
				__dropdown_search.Size = UDim2.new(1, -30, 1, 0)
				__dropdown_search.Position = UDim2.new(0, 29, 0, 0)
				__dropdown_search.BackgroundTransparency = 1
				__dropdown_search.Text = ''
				__dropdown_search.PlaceholderText = 'Search'
				__dropdown_search.TextColor3 = Color3.fromRGB(255, 255, 255)
				__dropdown_search.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
				__dropdown_search.TextSize = 10
				__dropdown_search.Font = Enum.Font.Gotham
				__dropdown_search.TextXAlignment = Enum.TextXAlignment.Left
				__dropdown_search.ClearTextOnFocus = false
				__dropdown_search.ZIndex = 18
				__dropdown_search.Parent = __dropdown_search_container

				local __options_container : ScrollingFrame = Instance.new('ScrollingFrame')
				__options_container.Size = UDim2.new(1, 0, 0, 0)
				__options_container.Position = UDim2.new(0, 0, 0, 54)
				__options_container.BackgroundTransparency = 1
				__options_container.BorderSizePixel = 0
				__options_container.ScrollBarThickness = 2
				__options_container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
				__options_container.CanvasSize = UDim2.new(0, 0, 0, 0)
				__options_container.ZIndex = 17
				__options_container.Parent = __dropdown_container

				local __options_padding : UIPadding = Instance.new('UIPadding')
				__options_padding.PaddingLeft = UDim.new(0, 5)
				__options_padding.PaddingRight = UDim.new(0, 5)
				__options_padding.Parent = __options_container

				local __options_layout : UIListLayout = Instance.new('UIListLayout')
				__options_layout.SortOrder = Enum.SortOrder.LayoutOrder
				__options_layout.Padding = UDim.new(0, 2)
				__options_layout.Parent = __options_container

				__options_layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
					__options_container.CanvasSize = UDim2.new(0, 0, 0, __options_layout.AbsoluteContentSize.Y)
				end)

				local function __close_dropdown(__instant : boolean)
					if not __opened then
						return
					end

					__opened = false
					__is_animating = false

					__dropdown_search_container.Visible = false
					__options_container.Size = UDim2.new(1, 0, 0, 0)
					__dropdown_search.Text = ''

					if __instant then
						__dropdown_container.Size = UDim2.new(0, 135, 0, 24)
						__arrow.Rotation = 0
						__item_frame.ZIndex = 4
						__dropdown_container.ZIndex = 15
						__dropdown_container.ClipsDescendants = true
						__item_label.ZIndex = 5
						__selected_label.ZIndex = 16
						__icon_container.ZIndex = 16
						__arrow.ZIndex = 17
						__input_divider.ZIndex = 17
						__dropdown_container.Parent = __item_frame
						__dropdown_container.Position = UDim2.new(1, -145, 0.5, -12)
					else
						__is_animating = true

						__create_tween(__dropdown_container, {Size = UDim2.new(0, 135, 0, 24)}, 0.3)
						__create_tween(__arrow, {Rotation = 0}, 0.3)

						task.wait(0.3)

						__item_frame.ZIndex = 4
						__dropdown_container.ZIndex = 15
						__dropdown_container.ClipsDescendants = true
						__item_label.ZIndex = 5
						__selected_label.ZIndex = 16
						__icon_container.ZIndex = 16
						__arrow.ZIndex = 17
						__input_divider.ZIndex = 17
						__dropdown_container.Parent = __item_frame
						__dropdown_container.Position = UDim2.new(1, -145, 0.5, -12)

						__is_animating = false
					end
				end

				__container:GetPropertyChangedSignal('Visible'):Connect(function()
					if not __container.Visible and __opened then
						__close_dropdown(true)
					end
				end)

				__container:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
					if __opened then
						__close_dropdown(true)
					end
				end)

				__module_container:GetPropertyChangedSignal('Visible'):Connect(function()
					if not __module_container.Visible and __opened then
						__close_dropdown(true)
					end
				end)

				local function __create_option(__option : string)
					local __is_selected : boolean = false

					if __multi_selection then
						__is_selected = table.find(__selected :: { string }, __option) ~= nil
					else
						__is_selected = __selected == __option
					end

					local __option_button : TextButton = Instance.new('TextButton')
					__option_button.Size = UDim2.new(1, 0, 0, 35)
					__option_button.BackgroundColor3 = __is_selected and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(8, 8, 8)
					__option_button.BackgroundTransparency = 0.2
					__option_button.BorderSizePixel = 0
					__option_button.Text = ''
					__option_button.AutoButtonColor = false
					__option_button.ZIndex = 18
					__option_button.Parent = __options_container
					__create_round(__option_button, 5)

					local __option_highlight : Frame = Instance.new('Frame')
					__option_highlight.Size = UDim2.new(0, 2, 0.6, 0)
					__option_highlight.Position = UDim2.new(0, 1, 0.2, 0)
					__option_highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					__option_highlight.BackgroundTransparency = __is_selected and 0.1 or 1
					__option_highlight.BorderSizePixel = 0
					__option_highlight.ZIndex = 19
					__option_highlight.Parent = __option_button
					__create_round(__option_highlight, 1)

					local __option_label : TextLabel = Instance.new('TextLabel')
					__option_label.Size = UDim2.new(1, -10, 1, 0)
					__option_label.Position = UDim2.new(0, 8, 0, 0)
					__option_label.BackgroundTransparency = 1
					__option_label.Text = __option
					__option_label.TextColor3 = __is_selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
					__option_label.TextSize = 13
					__option_label.Font = Enum.Font.GothamMedium
					__option_label.TextXAlignment = Enum.TextXAlignment.Left
					__option_label.ZIndex = 19
					__option_label.Parent = __option_button

					local __option_highlight_effect : Frame = Instance.new('Frame')
					__option_highlight_effect.Size = UDim2.new(1, 0, 1, 0)
					__option_highlight_effect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					__option_highlight_effect.BackgroundTransparency = 1
					__option_highlight_effect.BorderSizePixel = 0
					__option_highlight_effect.ZIndex = 17
					__option_highlight_effect.Parent = __option_button
					__create_round(__option_highlight_effect, 5)

					__option_button.MouseButton1Click:Connect(function()
						__option_highlight_effect.BackgroundTransparency = 1

						__create_tween(__option_highlight_effect, {BackgroundTransparency = 0.92}, 0.3)

						task.delay(0.3, function()
							__create_tween(__option_highlight_effect, {BackgroundTransparency = 1}, 0.3)
						end)

						if __multi_selection then
							local __idx = table.find(__selected :: { string }, __option)

							if __idx then
								table.remove(__selected :: { string }, __idx)

								__is_selected = false

								__create_tween(__option_button, {BackgroundColor3 = Color3.fromRGB(8, 8, 8), BackgroundTransparency = 0.2}, 0.2)
								__create_tween(__option_label, {TextColor3 = Color3.fromRGB(120, 120, 120)}, 0.2)
								__create_tween(__option_highlight, {BackgroundTransparency = 1}, 0.3)
							else
								table.insert(__selected :: { string }, __option)

								__is_selected = true

								__create_tween(__option_button, {BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.2}, 0.2)
								__create_tween(__option_label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
								__create_tween(__option_highlight, {BackgroundTransparency = 0.1}, 0.3)
							end

							__selected_label.Text = __get_display_text()

							__item_callback(__selected)
						else
							for _, __child in pairs(__options_container:GetChildren()) do
								if not __child:IsA('TextButton') then
									continue
								end

								local __child_highlight = __child:FindFirstChildOfClass('Frame')
								local __child_label = __child:FindFirstChildOfClass('TextLabel')

								if __child ~= __option_button then
									__create_tween(__child, {BackgroundColor3 = Color3.fromRGB(8, 8, 8), BackgroundTransparency = 0.2}, 0.2)

									if __child_label then
										__create_tween(__child_label, {TextColor3 = Color3.fromRGB(120, 120, 120)}, 0.2)
									end

									if __child_highlight then
										__create_tween(__child_highlight, {BackgroundTransparency = 1}, 0.3)
									end
								end
							end

							__selected = __option
							__is_selected = true
							__selected_label.Text = __option

							__create_tween(__option_button, {BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.2}, 0.2)
							__create_tween(__option_label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
							__create_tween(__option_highlight, {BackgroundTransparency = 0.1}, 0.3)

							__item_callback(__option)
						end
					end)

					return __option_button
				end

				for _, __option in ipairs(__options_list) do
					__create_option(__option)
				end

				__dropdown_search:GetPropertyChangedSignal('Text'):Connect(function()
					local __search_text : string = __dropdown_search.Text:lower()

					for _, __child in pairs(__options_container:GetChildren()) do
						if not __child:IsA('TextButton') then
							continue
						end

						local __label_child = __child:FindFirstChildOfClass('TextLabel')

						if __label_child then
							if __search_text == '' then
								__child.Visible = true
							else
								__child.Visible = __label_child.Text:lower():find(__search_text) ~= nil
							end
						end
					end
				end)

				local __dropdown_button : TextButton = Instance.new('TextButton')
				__dropdown_button.Size = UDim2.new(1, 0, 1, 0)
				__dropdown_button.BackgroundTransparency = 1
				__dropdown_button.Text = ''
				__dropdown_button.ZIndex = 16
				__dropdown_button.Parent = __dropdown_container

				__dropdown_button.MouseButton1Click:Connect(function()
					if __is_animating then
						return
					end

					if __opened then
						__close_dropdown(false)

						return
					end

					__is_animating = true
					__opened = true

					local __absolute_position = __dropdown_container.AbsolutePosition
					local __main_absolute_position = __main.AbsolutePosition

					__dropdown_container.Parent = __main
					__dropdown_container.Position = UDim2.new(0, __absolute_position.X - __main_absolute_position.X, 0, __absolute_position.Y - __main_absolute_position.Y)
					__dropdown_container.Size = UDim2.new(0, 135, 0, 24)

					__item_frame.ZIndex = 20
					__dropdown_container.ZIndex = 21
					__dropdown_container.ClipsDescendants = false
					__item_label.ZIndex = 22
					__selected_label.ZIndex = 23
					__icon_container.ZIndex = 23
					__arrow.ZIndex = 24
					__input_divider.ZIndex = 24

					local __actual_height : number = math.min(__options_layout.AbsoluteContentSize.Y, math.min(#__options_list * 37, 148))

					__dropdown_search_container.Visible = true
					__options_container.Size = UDim2.new(1, 0, 0, __actual_height)

					for __i, __child in pairs(__options_container:GetChildren()) do
						if not __child:IsA('TextButton') then
							continue
						end

						__child.BackgroundTransparency = 1

						local __label_child = __child:FindFirstChildOfClass('TextLabel')

						if __label_child then
							__label_child.TextTransparency = 1
						end

						task.delay(0.1 + (__i * 0.001), function()
							__create_tween(__child, {BackgroundTransparency = 0.2}, 0.2)

							if __label_child then
								__create_tween(__label_child, {TextTransparency = 0}, 0.2)
							end
						end)
					end

					__create_tween(__dropdown_container, {Size = UDim2.new(0, 135, 0, 54 + __actual_height + 6)}, 0.3)
					__create_tween(__arrow, {Rotation = 180}, 0.3)

					task.wait(0.3)

					__is_animating = false
				end)

				table.insert(__module.__elements, __item_frame)

				if __toggled then
					__update_module_height()
				end

				task.spawn(function()
					while __item_frame and __item_frame.Parent do
						task.wait()

						if __module.__library.__minimized and __opened then
							__close_dropdown(true)
						end
					end
				end)

				return {
					Set = function(__self, __option : string | { string })
						if __multi_selection then
							__selected = (type(__option) == 'table' and __option :: { string }) or {}
						else
							__selected = __option :: string
						end

						__selected_label.Text = __get_display_text()
						__item_callback(__selected)
					end
				}
			end

			table.insert(self.__library.__all_elements, {name = __index.title, frame = __module_frame})

			return __module
		end

		function __tab:create_checkbox(__index : { title: string, default: boolean?, callback: (state: boolean) -> () })
			local __default : boolean = __index.default or false

			local __callback : (state: boolean) -> () = __index.callback or (function() end)
			local __toggled : boolean = __default

			local __checkbox_frame : Frame = Instance.new('Frame')
			__checkbox_frame.Name = 'Checkbox'
			__checkbox_frame.Size = UDim2.new(1, 2, 0, 40)
			__checkbox_frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__checkbox_frame.BackgroundTransparency = 0.3
			__checkbox_frame.BorderSizePixel = 0
			__checkbox_frame.ZIndex = 3
			__checkbox_frame.Parent = __container
			__create_round(__checkbox_frame, 8)
			__create_outline(__checkbox_frame)

			local __label : TextLabel = Instance.new('TextLabel')
			__label.Size = UDim2.new(1, -60, 1, 0)
			__label.Position = UDim2.new(0, 15, 0, 0)
			__label.BackgroundTransparency = 1
			__label.Text = __index.title
			__label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__label.TextSize = 15
			__label.Font = Enum.Font.Gotham
			__label.TextXAlignment = Enum.TextXAlignment.Left
			__label.ZIndex = 4
			__label.Parent = __checkbox_frame

			local __check_frame : Frame = Instance.new('Frame')
			__check_frame.Size = UDim2.new(0, 24, 0, 24)
			__check_frame.Position = UDim2.new(1, -40, 0.5, -12)
			__check_frame.BackgroundColor3 = __toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 25)
			__check_frame.BorderSizePixel = 0
			__check_frame.ZIndex = 4
			__check_frame.Parent = __checkbox_frame
			__create_round(__check_frame, 6)
			__create_outline(__check_frame)

			local __check_icon : ImageLabel = Instance.new('ImageLabel')
			__check_icon.Size = UDim2.new(0, 16, 0, 16)
			__check_icon.Position = UDim2.new(0.5, -8, 0.5, -8)
			__check_icon.BackgroundTransparency = 1
			__check_icon.Image = 'rbxassetid://10709790644'
			__check_icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
			__check_icon.ImageTransparency = __toggled and 0.2 or 1
			__check_icon.ZIndex = 5
			__check_icon.Parent = __check_frame

			local __button : TextButton = Instance.new('TextButton')
			__button.Size = UDim2.new(1, 0, 1, 0)
			__button.BackgroundTransparency = 1
			__button.Text = ''
			__button.ZIndex = 5
			__button.Parent = __checkbox_frame

			__button.MouseButton1Click:Connect(function()
				__toggled = not __toggled

				__create_tween(__check_frame, {BackgroundColor3 = __toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 25)}, 0.3)
				__create_tween(__check_icon, {ImageTransparency = __toggled and 0.2 or 1}, 0.3)

				__callback(__toggled)
			end)

			table.insert(self.__library.__all_elements, {name = __index.title, frame = __checkbox_frame})
		end

		function __tab:create_dropdown(__index : { title: string, options: { string }, default: string | { string }?, multi_selection: boolean?, callback: (value: string | { string }) -> () }) : { Set: (self: any, value: string | { string }) -> () }
			local __options_list : { string } = __index.options or {}

			local __default_value : string | { string } = __index.default or '--'
			local __multi_selection : boolean = __index.multi_selection or false

			local __callback : (value: string | { string }) -> () = __index.callback or (function() end)

			local __selected : string | { string } = {}

			if not __multi_selection then
				__selected = (__default_value ~= '--' and __default_value :: string) or __options_list[1]
			else
				__selected = (type(__default_value) == 'table' and __default_value :: { string }) or {}
			end

			local __opened : boolean = false
			local __is_animating : boolean = false

			local __dropdown : Frame = Instance.new('Frame')
			__dropdown.Name = 'Dropdown'
			__dropdown.Size = UDim2.new(1, 2, 0, 40)
			__dropdown.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__dropdown.BackgroundTransparency = 0.3
			__dropdown.BorderSizePixel = 0
			__dropdown.ZIndex = 10
			__dropdown.ClipsDescendants = false
			__dropdown.Parent = __container
			__create_round(__dropdown, 8)
			__create_outline(__dropdown)

			local __label : TextLabel = Instance.new('TextLabel')
			__label.Size = UDim2.new(0, 150, 0, 40)
			__label.Position = UDim2.new(0, 15, 0, 0)
			__label.BackgroundTransparency = 1
			__label.Text = __index.title
			__label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__label.TextSize = 15
			__label.Font = Enum.Font.Gotham
			__label.TextXAlignment = Enum.TextXAlignment.Left
			__label.ZIndex = 11
			__label.Parent = __dropdown

			local __dropdown_container : Frame = Instance.new('Frame')
			__dropdown_container.Size = UDim2.new(0, 145, 0, 28)
			__dropdown_container.Position = UDim2.new(1, -155, 0.5, -14)
			__dropdown_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__dropdown_container.BackgroundTransparency = 0
			__dropdown_container.BorderSizePixel = 0
			__dropdown_container.ClipsDescendants = true
			__dropdown_container.ZIndex = 15
			__dropdown_container.Parent = __dropdown
			__create_round(__dropdown_container, 6)
			__create_outline(__dropdown_container)

			local function __get_display_text() : string
				if __multi_selection then
					if #(__selected :: { string }) == 0 then
						return '--'
					end

					return table.concat(__selected :: { string }, ', ')
				else
					return __selected :: string
				end
			end

			local __icon_container : Frame = Instance.new('Frame')
			__icon_container.Size = UDim2.new(0, 28, 0, 28)
			__icon_container.Position = UDim2.new(1, -28, 0, 0)
			__icon_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__icon_container.BackgroundTransparency = 0.6
			__icon_container.BorderSizePixel = 0
			__icon_container.ZIndex = 16
			__icon_container.Parent = __dropdown_container
			__create_round(__icon_container, 6)

			local __arrow : ImageLabel = Instance.new('ImageLabel')
			__arrow.Size = UDim2.new(0, 12, 0, 12)
			__arrow.Position = UDim2.new(0.5, -6, 0.5, -6)
			__arrow.BackgroundTransparency = 1
			__arrow.Image = 'rbxassetid://10709790948'
			__arrow.ImageColor3 = Color3.fromRGB(120, 120, 120)
			__arrow.Rotation = 0
			__arrow.ZIndex = 17
			__arrow.Parent = __icon_container

			local __input_divider : Frame = Instance.new('Frame')
			__input_divider.Size = UDim2.new(0, 1, 0, 17)
			__input_divider.Position = UDim2.new(1, -29, 0, 6)
			__input_divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			__input_divider.BorderSizePixel = 0
			__input_divider.ZIndex = 17
			__input_divider.Parent = __dropdown_container

			local __selected_label : TextLabel = Instance.new('TextLabel')
			__selected_label.Size = UDim2.new(1, -35, 0, 28)
			__selected_label.Position = UDim2.new(0, 8, 0, 0)
			__selected_label.BackgroundTransparency = 1
			__selected_label.Text = __get_display_text()
			__selected_label.TextColor3 = Color3.fromRGB(255, 255, 255)
			__selected_label.TextSize = 12
			__selected_label.Font = Enum.Font.Gotham
			__selected_label.TextXAlignment = Enum.TextXAlignment.Left
			__selected_label.TextTruncate = Enum.TextTruncate.None
			__selected_label.ClipsDescendants = true
			__selected_label.ZIndex = 16
			__selected_label.Parent = __dropdown_container

			local __fade_gradient : UIGradient = Instance.new('UIGradient')
			__fade_gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			}
			__fade_gradient.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(0.75, 0.4),
				NumberSequenceKeypoint.new(0.85, 0.7),
				NumberSequenceKeypoint.new(0.95, 0.9),
				NumberSequenceKeypoint.new(1, 1)
			}
			__fade_gradient.Parent = __selected_label

			local __dropdown_search_container : Frame = Instance.new('Frame')
			__dropdown_search_container.Size = UDim2.new(1, -10, 0, 26)
			__dropdown_search_container.Position = UDim2.new(0, 5, 0, 30)
			__dropdown_search_container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			__dropdown_search_container.BorderSizePixel = 0
			__dropdown_search_container.Visible = false
			__dropdown_search_container.ZIndex = 17
			__dropdown_search_container.Parent = __dropdown_container
			__create_round(__dropdown_search_container, 5)

			local __dropdown_search_icon_container : Frame = Instance.new('Frame')
			__dropdown_search_icon_container.Size = UDim2.new(0, 26, 1, 0)
			__dropdown_search_icon_container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			__dropdown_search_icon_container.BackgroundTransparency = 0.5
			__dropdown_search_icon_container.BorderSizePixel = 0
			__dropdown_search_icon_container.ZIndex = 17
			__dropdown_search_icon_container.Parent = __dropdown_search_container
			__create_round(__dropdown_search_icon_container, 5)

			local __dropdown_search_divider : Frame = Instance.new('Frame')
			__dropdown_search_divider.Size = UDim2.new(0, 1, 0.6, 0)
			__dropdown_search_divider.Position = UDim2.new(0, 26, 0.2, 0)
			__dropdown_search_divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			__dropdown_search_divider.BorderSizePixel = 0
			__dropdown_search_divider.ZIndex = 18
			__dropdown_search_divider.Parent = __dropdown_search_container

			local __dropdown_search_icon : ImageLabel = Instance.new('ImageLabel')
			__dropdown_search_icon.Size = UDim2.new(0, 12, 0, 12)
			__dropdown_search_icon.Position = UDim2.new(0.5, -6, 0.5, -6)
			__dropdown_search_icon.BackgroundTransparency = 1
			__dropdown_search_icon.Image = 'rbxassetid://10734943674'
			__dropdown_search_icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
			__dropdown_search_icon.ZIndex = 18
			__dropdown_search_icon.Parent = __dropdown_search_icon_container

			local __dropdown_search : TextBox = Instance.new('TextBox')
			__dropdown_search.Size = UDim2.new(1, -30, 1, 0)
			__dropdown_search.Position = UDim2.new(0, 29, 0, 0)
			__dropdown_search.BackgroundTransparency = 1
			__dropdown_search.Text = ''
			__dropdown_search.PlaceholderText = 'Search'
			__dropdown_search.TextColor3 = Color3.fromRGB(255, 255, 255)
			__dropdown_search.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
			__dropdown_search.TextSize = 10
			__dropdown_search.Font = Enum.Font.Gotham
			__dropdown_search.TextXAlignment = Enum.TextXAlignment.Left
			__dropdown_search.ClearTextOnFocus = false
			__dropdown_search.ZIndex = 18
			__dropdown_search.Parent = __dropdown_search_container

			local __options_container : ScrollingFrame = Instance.new('ScrollingFrame')
			__options_container.Size = UDim2.new(1, 0, 0, 0)
			__options_container.Position = UDim2.new(0, 0, 0, 58)
			__options_container.BackgroundTransparency = 1
			__options_container.BorderSizePixel = 0
			__options_container.ScrollBarThickness = 2
			__options_container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
			__options_container.CanvasSize = UDim2.new(0, 0, 0, 0)
			__options_container.ZIndex = 17
			__options_container.Parent = __dropdown_container

			local __options_padding : UIPadding = Instance.new('UIPadding')
			__options_padding.PaddingLeft = UDim.new(0, 5)
			__options_padding.PaddingRight = UDim.new(0, 5)
			__options_padding.Parent = __options_container

			local __options_layout : UIListLayout = Instance.new('UIListLayout')
			__options_layout.SortOrder = Enum.SortOrder.LayoutOrder
			__options_layout.Padding = UDim.new(0, 2)
			__options_layout.Parent = __options_container

			__options_layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				__options_container.CanvasSize = UDim2.new(0, 0, 0, __options_layout.AbsoluteContentSize.Y)
			end)

			local function __close_dropdown(__instant : boolean)
				if not __opened then
					return
				end

				__opened = false
				__is_animating = false

				__dropdown_search_container.Visible = false
				__options_container.Size = UDim2.new(1, 0, 0, 0)
				__dropdown_search.Text = ''

				if __instant then
					__dropdown_container.Size = UDim2.new(0, 145, 0, 28)
					__arrow.Rotation = 0
					__dropdown.ZIndex = 10
					__dropdown_container.ZIndex = 15
					__dropdown_container.ClipsDescendants = true
					__label.ZIndex = 11
					__selected_label.ZIndex = 16
					__icon_container.ZIndex = 16
					__arrow.ZIndex = 17
					__input_divider.ZIndex = 17
					__dropdown_container.Parent = __dropdown
					__dropdown_container.Position = UDim2.new(1, -155, 0.5, -14)
				else
					__is_animating = true

					__create_tween(__dropdown_container, {Size = UDim2.new(0, 145, 0, 28)}, 0.3)
					__create_tween(__arrow, {Rotation = 0}, 0.3)

					task.wait(0.3)

					__dropdown.ZIndex = 10
					__dropdown_container.ZIndex = 15
					__dropdown_container.ClipsDescendants = true
					__label.ZIndex = 11
					__selected_label.ZIndex = 16
					__icon_container.ZIndex = 16
					__arrow.ZIndex = 17
					__input_divider.ZIndex = 17
					__dropdown_container.Parent = __dropdown
					__dropdown_container.Position = UDim2.new(1, -155, 0.5, -14)

					__is_animating = false
				end
			end

			__container:GetPropertyChangedSignal('Visible'):Connect(function()
				if not __container.Visible and __opened then
					__close_dropdown(true)
				end
			end)

			__container:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
				if __opened then
					__close_dropdown(true)
				end
			end)

			local function __create_option(__option : string)
				local __is_selected : boolean = false

				if __multi_selection then
					__is_selected = table.find(__selected :: { string }, __option) ~= nil
				else
					__is_selected = __selected == __option
				end

				local __option_button : TextButton = Instance.new('TextButton')
				__option_button.Size = UDim2.new(1, 0, 0, 35)
				__option_button.BackgroundColor3 = __is_selected and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(8, 8, 8)
				__option_button.BackgroundTransparency = 0.2
				__option_button.BorderSizePixel = 0
				__option_button.Text = ''
				__option_button.AutoButtonColor = false
				__option_button.ZIndex = 18
				__option_button.Parent = __options_container
				__create_round(__option_button, 5)

				local __option_highlight : Frame = Instance.new('Frame')
				__option_highlight.Size = UDim2.new(0, 2, 0.6, 0)
				__option_highlight.Position = UDim2.new(0, 1, 0.2, 0)
				__option_highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				__option_highlight.BackgroundTransparency = __is_selected and 0.1 or 1
				__option_highlight.BorderSizePixel = 0
				__option_highlight.ZIndex = 19
				__option_highlight.Parent = __option_button
				__create_round(__option_highlight, 1)

				local __option_label : TextLabel = Instance.new('TextLabel')
				__option_label.Size = UDim2.new(1, -10, 1, 0)
				__option_label.Position = UDim2.new(0, 8, 0, 0)
				__option_label.BackgroundTransparency = 1
				__option_label.Text = __option
				__option_label.TextColor3 = __is_selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
				__option_label.TextSize = 13
				__option_label.Font = Enum.Font.GothamMedium
				__option_label.TextXAlignment = Enum.TextXAlignment.Left
				__option_label.ZIndex = 19
				__option_label.Parent = __option_button

				local __option_highlight_effect : Frame = Instance.new('Frame')
				__option_highlight_effect.Size = UDim2.new(1, 0, 1, 0)
				__option_highlight_effect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				__option_highlight_effect.BackgroundTransparency = 1
				__option_highlight_effect.BorderSizePixel = 0
				__option_highlight_effect.ZIndex = 17
				__option_highlight_effect.Parent = __option_button
				__create_round(__option_highlight_effect, 5)

				__option_button.MouseButton1Click:Connect(function()
					__option_highlight_effect.BackgroundTransparency = 1

					__create_tween(__option_highlight_effect, {BackgroundTransparency = 0.92}, 0.3)

					task.delay(0.3, function()
						__create_tween(__option_highlight_effect, {BackgroundTransparency = 1}, 0.3)
					end)

					if __multi_selection then
						local __idx = table.find(__selected :: { string }, __option)

						if __idx then
							table.remove(__selected :: { string }, __idx)

							__is_selected = false

							__create_tween(__option_button, {BackgroundColor3 = Color3.fromRGB(8, 8, 8), BackgroundTransparency = 0.2}, 0.2)
							__create_tween(__option_label, {TextColor3 = Color3.fromRGB(120, 120, 120)}, 0.2)
							__create_tween(__option_highlight, {BackgroundTransparency = 1}, 0.3)
						else
							table.insert(__selected :: { string }, __option)

							__is_selected = true

							__create_tween(__option_button, {BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.2}, 0.2)
							__create_tween(__option_label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
							__create_tween(__option_highlight, {BackgroundTransparency = 0.1}, 0.3)
						end

						__selected_label.Text = __get_display_text()

						__callback(__selected)
					else
						for _, __child in pairs(__options_container:GetChildren()) do
							if not __child:IsA('TextButton') then
								continue
							end

							local __child_highlight = __child:FindFirstChildOfClass('Frame')
							local __child_label = __child:FindFirstChildOfClass('TextLabel')

							if __child ~= __option_button then
								__create_tween(__child, {BackgroundColor3 = Color3.fromRGB(8, 8, 8), BackgroundTransparency = 0.2}, 0.2)

								if __child_label then
									__create_tween(__child_label, {TextColor3 = Color3.fromRGB(120, 120, 120)}, 0.2)
								end

								if __child_highlight then
									__create_tween(__child_highlight, {BackgroundTransparency = 1}, 0.3)
								end
							end
						end

						__selected = __option
						__is_selected = true
						__selected_label.Text = __option

						__create_tween(__option_button, {BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.2}, 0.2)
						__create_tween(__option_label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
						__create_tween(__option_highlight, {BackgroundTransparency = 0.1}, 0.3)

						__callback(__option)
					end
				end)

				return __option_button
			end

			for _, __option in ipairs(__options_list) do
				__create_option(__option)
			end

			__dropdown_search:GetPropertyChangedSignal('Text'):Connect(function()
				local __search_text : string = __dropdown_search.Text:lower()

				for _, __child in pairs(__options_container:GetChildren()) do
					if not __child:IsA('TextButton') then
						continue
					end

					local __label_child = __child:FindFirstChildOfClass('TextLabel')

					if __label_child then
						if __search_text == '' then
							__child.Visible = true
						else
							__child.Visible = __label_child.Text:lower():find(__search_text) ~= nil
						end
					end
				end
			end)

			local __dropdown_button : TextButton = Instance.new('TextButton')
			__dropdown_button.Size = UDim2.new(1, 0, 1, 0)
			__dropdown_button.BackgroundTransparency = 1
			__dropdown_button.Text = ''
			__dropdown_button.ZIndex = 16
			__dropdown_button.Parent = __dropdown_container

			__dropdown_button.MouseButton1Click:Connect(function()
				if __is_animating then
					return
				end

				if __opened then
					__close_dropdown(false)

					return
				end

				__is_animating = true
				__opened = true

				local __absolute_position = __dropdown_container.AbsolutePosition
				local __main_absolute_position = __main.AbsolutePosition

				__dropdown_container.Parent = __main
				__dropdown_container.Position = UDim2.new(0, __absolute_position.X - __main_absolute_position.X, 0, __absolute_position.Y - __main_absolute_position.Y)
				__dropdown_container.Size = UDim2.new(0, 145, 0, 28)

				__dropdown.ZIndex = 20
				__dropdown_container.ZIndex = 21
				__dropdown_container.ClipsDescendants = false
				__label.ZIndex = 22
				__selected_label.ZIndex = 23
				__icon_container.ZIndex = 23
				__arrow.ZIndex = 24
				__input_divider.ZIndex = 24

				local __actual_height : number = math.min(__options_layout.AbsoluteContentSize.Y, math.min(#__options_list * 37, 148))

				__dropdown_search_container.Visible = true
				__options_container.Size = UDim2.new(1, 0, 0, __actual_height)

				for __i, __child in pairs(__options_container:GetChildren()) do
					if not __child:IsA('TextButton') then
						continue
					end

					__child.BackgroundTransparency = 1

					local __label_child = __child:FindFirstChildOfClass('TextLabel')

					if __label_child then
						__label_child.TextTransparency = 1
					end

					task.delay(0.1 + (__i * 0.001), function()
						__create_tween(__child, {BackgroundTransparency = 0.2}, 0.2)

						if __label_child then
							__create_tween(__label_child, {TextTransparency = 0}, 0.2)
						end
					end)
				end

				__create_tween(__dropdown_container, {Size = UDim2.new(0, 145, 0, 58 + __actual_height + 6)}, 0.3)
				__create_tween(__arrow, {Rotation = 180}, 0.3)

				task.wait(0.3)

				__is_animating = false
			end)

			table.insert(self.__library.__all_elements, {name = __index.title, frame = __dropdown})

			task.spawn(function()
				while __dropdown and __dropdown.Parent do
					task.wait()

					if self.__library.__minimized and __opened then
						__close_dropdown(true)
					end
				end
			end)

			return {
				Set = function(__self, __option : string | { string })
					if __multi_selection then
						__selected = (type(__option) == 'table' and __option :: { string }) or {}
					else
						__selected = __option :: string
					end

					__selected_label.Text = __get_display_text()
					__callback(__selected)
				end
			}
		end

		return __tab
	end

	return self
end

return Library
