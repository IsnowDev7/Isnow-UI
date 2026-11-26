local cloneRef = cloneref or function(obj) return obj end

local Players = cloneRef(game:GetService("Players"))
local UserInputService = cloneRef(game:GetService("UserInputService"))
local TweenService = cloneRef(game:GetService("TweenService"))
local CoreGui = cloneRef(game:GetService("CoreGui"))

local LocalPlayer = Players.LocalPlayer

local function ResolveParent()
	local parent = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
	pcall(function()
		if gethui then
			parent = gethui()
		elseif CoreGui then
			parent = CoreGui
		end
	end)
	return parent
end

local FootagesusIcons = nil
pcall(function()
	FootagesusIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/46d30c19ba7bc601d6ec794a48dc3a89568b1eec/lucide/dist/Icons.lua"))()
end)

local Lucide = {
	["house"] = "rbxassetid://98755624629571",
	["home"] = "rbxassetid://98755624629571",
	["user"] = "rbxassetid://81589895647169",
	["player"] = "rbxassetid://81589895647169",
	["scroll"] = "rbxassetid://74072101474951",
	["scripts"] = "rbxassetid://74072101474951",
	["settings"] = "rbxassetid://80758916183665",
	["gear"] = "rbxassetid://80758916183665",
	["search"] = "rbxassetid://121018724060431",
	["shield"] = "rbxassetid://110987169760162",
	["terminal"] = "rbxassetid://83969264476798",
	["bell"] = "rbxassetid://97904885874823",
	["sliders"] = "rbxassetid://85538382643347",
}

function Lucide.Get(name)
	name = string.lower(tostring(name or ""))
	if FootagesusIcons and FootagesusIcons[name] then
		return FootagesusIcons[name]
	end
	if Lucide[name] then
		return Lucide[name]
	end
	if name:match("^rbxassetid://") then
		return name
	end
	return "rbxassetid://98755624629571"
end

local Library = {
	Spritesheet = {
		Id = "rbxassetid://77297718671545",
		MirroredId = "rbxassetid://92258969882244",
		Size = Vector2.new(102, 128),
		Total = 80,
		Cols = 10,
	},
	Lucide = Lucide
}

function Library:GetGlassFrame(T)
	T = math.clamp(T, 0, 1)
	local S = self.Spritesheet
	local Frame
	if T <= 0.4 then
		Frame = math.floor((T / 0.4) * (S.Total - 1))
	elseif T < 0.6 then
		Frame = S.Total - 1
	else
		Frame = math.floor(((T - 0.6) / 0.4) * (S.Total - 1))
	end
	Frame = math.clamp(Frame, 0, S.Total - 1)
	local Mirrored = T >= 0.6
	if Mirrored then Frame = (S.Total - 1) - Frame end
	local Id = Mirrored and S.MirroredId or S.Id
	return Id, S.Size, Vector2.new((Frame % S.Cols) * S.Size.X, math.floor(Frame / S.Cols) * S.Size.Y)
end

function Library:CreateWindow(cfg)
	cfg = cfg or {}
	local Title = cfg.Title or "Foundation"

	local ParentTarget = ResolveParent()
	local existing = ParentTarget:FindFirstChild("Isnow_DockUI")
	if existing then existing:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Isnow_DockUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 999
	ScreenGui.Parent = ParentTarget

	local ContentWindow = Instance.new("Frame")
	ContentWindow.Name = "ContentWindow"
	ContentWindow.Size = UDim2.new(0, 480, 0, 270)
	ContentWindow.Position = UDim2.new(0.5, -240, 0.5, -165)
	ContentWindow.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	ContentWindow.BorderSizePixel = 0
	ContentWindow.Parent = ScreenGui
	Instance.new("UICorner", ContentWindow).CornerRadius = UDim.new(0, 14)

	local WindowShadow = Instance.new("ImageLabel")
	WindowShadow.Name = "WindowShadow"
	WindowShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	WindowShadow.Size = UDim2.new(1, 46, 1, 46)
	WindowShadow.BackgroundTransparency = 1
	WindowShadow.Image = "rbxassetid://84140972988015"
	WindowShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	WindowShadow.ImageTransparency = 0.2
	WindowShadow.ScaleType = Enum.ScaleType.Slice
	WindowShadow.SliceCenter = Rect.new(23, 23, 277, 277)
	WindowShadow.ZIndex = 0
	WindowShadow.Parent = ContentWindow

	local WindowStroke = Instance.new("UIStroke", ContentWindow)
	WindowStroke.Color = Color3.fromRGB(255, 255, 255)
	WindowStroke.Transparency = 0.92
	WindowStroke.Thickness = 1

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 42)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = ContentWindow

	local HeaderTitle = Instance.new("TextLabel")
	HeaderTitle.Name = "HeaderTitle"
	HeaderTitle.Text = Title
	HeaderTitle.Font = Enum.Font.GothamBold
	HeaderTitle.TextSize = 14
	HeaderTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
	HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
	HeaderTitle.Size = UDim2.new(1, -30, 1, 0)
	HeaderTitle.Position = UDim2.new(0, 16, 0, 0)
	HeaderTitle.BackgroundTransparency = 1
	HeaderTitle.Parent = TopBar

	local PageHolder = Instance.new("Frame")
	PageHolder.Name = "PageHolder"
	PageHolder.Size = UDim2.new(1, -28, 1, -54)
	PageHolder.Position = UDim2.new(0, 14, 0, 44)
	PageHolder.BackgroundTransparency = 1
	PageHolder.Parent = ContentWindow

	local DockBar = Instance.new("Frame")
	DockBar.Name = "LandscapeDockBar"
	DockBar.Size = UDim2.new(0, 360, 0, 50)
	DockBar.Position = UDim2.new(0.5, -180, 1, -74)
	DockBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	DockBar.BorderSizePixel = 0
	DockBar.Parent = ScreenGui
	Instance.new("UICorner", DockBar).CornerRadius = UDim.new(1, 0)

	local DockShadow = Instance.new("ImageLabel")
	DockShadow.Name = "DockShadow"
	DockShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DockShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DockShadow.Size = UDim2.new(1, 46, 1, 46)
	DockShadow.BackgroundTransparency = 1
	DockShadow.Image = "rbxassetid://84140972988015"
	DockShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DockShadow.ImageTransparency = 0.2
	DockShadow.ScaleType = Enum.ScaleType.Slice
	DockShadow.SliceCenter = Rect.new(23, 23, 277, 277)
	DockShadow.ZIndex = 0
	DockShadow.Parent = DockBar

	local DockGradient = Instance.new("UIGradient", DockBar)
	DockGradient.Rotation = 90
	DockGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 34)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 19))
	})

	local DockStroke = Instance.new("UIStroke", DockBar)
	DockStroke.Color = Color3.fromRGB(255, 255, 255)
	DockStroke.Transparency = 0.90
	DockStroke.Thickness = 1

	local ClockLabel = Instance.new("TextLabel")
	ClockLabel.Name = "Clock"
	ClockLabel.Size = UDim2.new(0, 52, 1, 0)
	ClockLabel.Position = UDim2.new(0, 14, 0, 0)
	ClockLabel.Font = Enum.Font.GothamBold
	ClockLabel.TextSize = 13
	ClockLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
	ClockLabel.TextXAlignment = Enum.TextXAlignment.Center
	ClockLabel.BackgroundTransparency = 1
	ClockLabel.Parent = DockBar

	task.spawn(function()
		while true do
			ClockLabel.Text = os.date("%H:%M")
			task.wait(1)
		end
	end)

	local TabsContainer = Instance.new("Frame")
	TabsContainer.Name = "TabsContainer"
	TabsContainer.Size = UDim2.new(1, -126, 1, 0)
	TabsContainer.Position = UDim2.new(0, 70, 0, 0)
	TabsContainer.BackgroundTransparency = 1
	TabsContainer.Parent = DockBar

	local TabsLayout = Instance.new("UIListLayout")
	TabsLayout.FillDirection = Enum.FillDirection.Horizontal
	TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TabsLayout.Padding = UDim.new(0, 8)
	TabsLayout.Parent = TabsContainer

	local AvatarWrapper = Instance.new("Frame")
	AvatarWrapper.Name = "AvatarWrapper"
	AvatarWrapper.Size = UDim2.new(0, 34, 0, 34)
	AvatarWrapper.Position = UDim2.new(1, -44, 0.5, -17)
	AvatarWrapper.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	AvatarWrapper.BorderSizePixel = 0
	AvatarWrapper.Parent = DockBar
	Instance.new("UICorner", AvatarWrapper).CornerRadius = UDim.new(1, 0)

	local AvatarStroke = Instance.new("UIStroke", AvatarWrapper)
	AvatarStroke.Color = Color3.fromRGB(255, 255, 255)
	AvatarStroke.Transparency = 0.88
	AvatarStroke.Thickness = 1

	local AvatarImg = Instance.new("ImageLabel")
	AvatarImg.Size = UDim2.new(1, 0, 1, 0)
	AvatarImg.BackgroundTransparency = 1
	AvatarImg.Parent = AvatarWrapper
	Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

	if LocalPlayer then
		pcall(function()
			AvatarImg.Image = Players:GetUserThumbnailAsync(
				LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size48x48
			)
		end)
	end

	local isDragging = false
	local dragStart = Vector2.zero
	local startPos = UDim2.new()

	local function InitDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			startPos = ContentWindow.Position
		end
	end

	TopBar.InputBegan:Connect(InitDrag)

	UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
			ContentWindow.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)

	local WindowObj = {
		Tabs = {},
		CurrentTab = nil,
		ScreenGui = ScreenGui,
		ContentWindow = ContentWindow,
		DockBar = DockBar,
	}

	function WindowObj:CreateTab(name, iconName)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name .. "_Page"
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.BorderSizePixel = 0
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Color3.fromRGB(44, 44, 56)
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Visible = false
		Page.Parent = PageHolder

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.Parent = Page

		local TabPill = Instance.new("Frame")
		TabPill.Name = name .. "_TabPill"
		TabPill.Size = UDim2.new(0, 38, 0, 36)
		TabPill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabPill.BorderSizePixel = 0
		TabPill.Parent = TabsContainer
		Instance.new("UICorner", TabPill).CornerRadius = UDim.new(1, 0)

		local TabShadow = Instance.new("ImageLabel")
		TabShadow.Name = "TabShadow"
		TabShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		TabShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabShadow.Size = UDim2.new(1, 24, 1, 24)
		TabShadow.BackgroundTransparency = 1
		TabShadow.Image = "rbxassetid://84140972988015"
		TabShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		TabShadow.ImageTransparency = 0.3
		TabShadow.ScaleType = Enum.ScaleType.Slice
		TabShadow.SliceCenter = Rect.new(23, 23, 277, 277)
		TabShadow.ZIndex = 0
		TabShadow.Parent = TabPill

		local TabGradient = Instance.new("UIGradient", TabPill)
		TabGradient.Rotation = 90
		TabGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 44, 54)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 30))
		})

		local TabStroke = Instance.new("UIStroke", TabPill)
		TabStroke.Color = Color3.fromRGB(255, 255, 255)
		TabStroke.Transparency = 0.90
		TabStroke.Thickness = 1
		TabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		local TabIcon = Instance.new("ImageLabel")
		TabIcon.Size = UDim2.new(0, 18, 0, 18)
		TabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		TabIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabIcon.BackgroundTransparency = 1
		TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 160)
		TabIcon.Image = Lucide.Get(iconName or name)
		TabIcon.ZIndex = 2
		TabIcon.Parent = TabPill

		local TabHitbox = Instance.new("TextButton")
		TabHitbox.Size = UDim2.new(1, 0, 1, 0)
		TabHitbox.BackgroundTransparency = 1
		TabHitbox.Text = ""
		TabHitbox.ZIndex = 5
		TabHitbox.Parent = TabPill

		local TabInstance = {
			Pill = TabPill,
			Gradient = TabGradient,
			Stroke = TabStroke,
			Icon = TabIcon,
			Shadow = TabShadow,
			Page = Page,
		}

		local function SelectTab()
			if WindowObj.CurrentTab == TabInstance then return end

			if WindowObj.CurrentTab then
				WindowObj.CurrentTab.Page.Visible = false
				WindowObj.CurrentTab.Gradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 44, 54)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 30))
				})
				TweenService:Create(WindowObj.CurrentTab.Stroke, TweenInfo.new(0.2), { Transparency = 0.90 }):Play()
				TweenService:Create(WindowObj.CurrentTab.Icon, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(150, 150, 160) }):Play()
				TweenService:Create(WindowObj.CurrentTab.Pill, TweenInfo.new(0.2), { Size = UDim2.new(0, 38, 0, 36) }):Play()
				TweenService:Create(WindowObj.CurrentTab.Shadow, TweenInfo.new(0.2), { ImageTransparency = 0.3 }):Play()
			end

			WindowObj.CurrentTab = TabInstance
			HeaderTitle.Text = Title .. "  /  " .. name
			Page.Visible = true

			TabGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 78)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 34, 42))
			})
			TweenService:Create(TabStroke, TweenInfo.new(0.2), { Transparency = 0.65 }):Play()
			TweenService:Create(TabIcon, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
			TweenService:Create(TabPill, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 40, 0, 38) }):Play()
			TweenService:Create(TabShadow, TweenInfo.new(0.2), { ImageTransparency = 0.15 }):Play()
		end

		TabHitbox.MouseButton1Click:Connect(SelectTab)

		if #WindowObj.Tabs == 0 then
			SelectTab()
		end

		table.insert(WindowObj.Tabs, TabInstance)

		local TabMethods = {}

		function TabMethods:AddToggle(opt)
			opt = opt or {}
			local title = opt.Title or "Toggle"
			local desc = opt.Description or ""
			local default = opt.Default or false
			local callback = opt.Callback

			local Row = Instance.new("Frame")
			Row.Size = UDim2.new(1, 0, 0, 52)
			Row.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			Row.BorderSizePixel = 0
			Row.Parent = Page
			Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)

			local RowStroke = Instance.new("UIStroke", Row)
			RowStroke.Color = Color3.fromRGB(255, 255, 255)
			RowStroke.Transparency = 0.94
			RowStroke.Thickness = 1

			local LabelTitle = Instance.new("TextLabel")
			LabelTitle.Text = title
			LabelTitle.Font = Enum.Font.GothamMedium
			LabelTitle.TextSize = 13
			LabelTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
			LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
			LabelTitle.Size = UDim2.new(1, -90, 0, 18)
			LabelTitle.Position = UDim2.new(0, 12, 0, 8)
			LabelTitle.BackgroundTransparency = 1
			LabelTitle.Parent = Row

			local LabelDesc = Instance.new("TextLabel")
			LabelDesc.Text = desc
			LabelDesc.Font = Enum.Font.Gotham
			LabelDesc.TextSize = 11
			LabelDesc.TextColor3 = Color3.fromRGB(140, 140, 150)
			LabelDesc.TextXAlignment = Enum.TextXAlignment.Left
			LabelDesc.Size = UDim2.new(1, -90, 0, 14)
			LabelDesc.Position = UDim2.new(0, 12, 0, 26)
			LabelDesc.BackgroundTransparency = 1
			LabelDesc.Parent = Row

			local TRACK_W = 64
			local TRACK_H = 32
			local KNOB_W  = 42
			local KNOB_H  = 26
			local PAD     = 3

			local Track = Instance.new("Frame")
			Track.Size = UDim2.new(0, TRACK_W, 0, TRACK_H)
			Track.AnchorPoint = Vector2.new(1, 0.5)
			Track.Position = UDim2.new(1, -12, 0.5, 0)
			Track.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
			Track.BorderSizePixel = 0
			Track.ClipsDescendants = false
			Track.Parent = Row
			Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

			local TrackStroke = Instance.new("UIStroke", Track)
			TrackStroke.Color = Color3.fromRGB(255, 255, 255)
			TrackStroke.Transparency = 0.92
			TrackStroke.Thickness = 1

			local KnobContainer = Instance.new("Frame")
			KnobContainer.Size = UDim2.new(0, KNOB_W, 0, KNOB_H)
			KnobContainer.Position = UDim2.new(0, PAD, 0.5, 0)
			KnobContainer.AnchorPoint = Vector2.new(0, 0.5)
			KnobContainer.BackgroundTransparency = 1
			KnobContainer.BorderSizePixel = 0
			KnobContainer.Parent = Track

			local KnobScaler = Instance.new("Frame")
			KnobScaler.Size = UDim2.new(1, 0, 1, 0)
			KnobScaler.AnchorPoint = Vector2.new(0.5, 0.5)
			KnobScaler.Position = UDim2.new(0.5, 0, 0.5, 0)
			KnobScaler.BackgroundTransparency = 1
			KnobScaler.Parent = KnobContainer

			local KnobUIScale = Instance.new("UIScale", KnobScaler)
			KnobUIScale.Scale = 1

			local GlassBg = Instance.new("Frame")
			GlassBg.Size = UDim2.new(1, 0, 1, 0)
			GlassBg.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			GlassBg.BackgroundTransparency = 0.2
			GlassBg.BorderSizePixel = 0
			GlassBg.Parent = KnobScaler
			Instance.new("UICorner", GlassBg).CornerRadius = UDim.new(1, 0)

			local GlassSprite = Instance.new("ImageLabel")
			GlassSprite.Size = UDim2.new(1, 0, 1, 0)
			GlassSprite.BackgroundTransparency = 1
			GlassSprite.ImageTransparency = 0.85
			GlassSprite.ImageColor3 = Color3.fromRGB(230, 60, 75)
			GlassSprite.Parent = KnobScaler
			Instance.new("UICorner", GlassSprite).CornerRadius = UDim.new(1, 0)

			local KnobOverlay = Instance.new("Frame")
			KnobOverlay.Size = UDim2.new(1, 0, 1, 0)
			KnobOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			KnobOverlay.BorderSizePixel = 0
			KnobOverlay.ZIndex = 5
			KnobOverlay.Parent = KnobScaler
			Instance.new("UICorner", KnobOverlay).CornerRadius = UDim.new(1, 0)

			local KnobStroke = Instance.new("UIStroke", KnobOverlay)
			KnobStroke.Color = Color3.fromRGB(0, 0, 0)
			KnobStroke.Thickness = 1
			KnobStroke.Transparency = 0.65

			local Hitbox = Instance.new("TextButton")
			Hitbox.Size = UDim2.new(1, 16, 1, 16)
			Hitbox.Position = UDim2.new(0.5, 0, 0.5, 0)
			Hitbox.AnchorPoint = Vector2.new(0.5, 0.5)
			Hitbox.BackgroundTransparency = 1
			Hitbox.Text = ""
			Hitbox.Parent = Track

			local isToggled = default
			local isDraggingKnob = false
			local hasDraggedKnob = false
			local startX = 0
			local startKnobX = PAD
			local maxTravelX = TRACK_W - KNOB_W - PAD

			local function UpdateGlass(percent)
				local id, rectSize, rectOffset = Library:GetGlassFrame(percent)
				GlassSprite.Image = id
				GlassSprite.ImageRectSize = rectSize
				GlassSprite.ImageRectOffset = rectOffset
			end

			local function SetState(newState, animate)
				isToggled = newState
				local targetX = isToggled and maxTravelX or PAD
				local targetColor = isToggled and Color3.fromRGB(0, 205, 115) or Color3.fromRGB(34, 34, 44)

				if animate then
					TweenService:Create(KnobContainer, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, targetX, 0.5, 0)
					}):Play()
					TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
						BackgroundColor3 = targetColor
					}):Play()
				else
					KnobContainer.Position = UDim2.new(0, targetX, 0.5, 0)
					Track.BackgroundColor3 = targetColor
				end

				GlassSprite.ImageColor3 = isToggled and Color3.fromRGB(0, 205, 115) or Color3.fromRGB(230, 60, 75)
				TweenService:Create(GlassSprite, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					ImageTransparency = isToggled and 0 or 0.85
				}):Play()

				UpdateGlass(isToggled and 1 or 0)
				if callback then task.spawn(callback, isToggled) end
			end

			SetState(isToggled, false)

			local tDragConn, tEndConn

			Hitbox.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

				isDraggingKnob = true
				hasDraggedKnob = false
				startX = input.Position.X
				startKnobX = KnobContainer.Position.X.Offset

				GlassSprite.ImageColor3 = isToggled and Color3.fromRGB(0, 205, 115) or Color3.fromRGB(230, 60, 75)

				TweenService:Create(KnobUIScale, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = 1.28 }):Play()
				TweenService:Create(KnobOverlay, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundTransparency = 0.86 }):Play()
				TweenService:Create(KnobStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 1 }):Play()
				TweenService:Create(GlassSprite, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()

				if tDragConn then tDragConn:Disconnect() end
				tDragConn = UserInputService.InputChanged:Connect(function(moveInput)
					if not isDraggingKnob then return end
					if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement and moveInput.UserInputType ~= Enum.UserInputType.Touch then return end

					local delta = moveInput.Position.X - startX
					if not hasDraggedKnob and math.abs(delta) > 4 then hasDraggedKnob = true end

					local newX = math.clamp(startKnobX + delta, PAD - 4, maxTravelX + 4)
					local percent = math.clamp((newX - PAD) / (maxTravelX - PAD), 0, 1)

					UpdateGlass(percent)
					TweenService:Create(KnobContainer, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, newX, 0.5, 0)
					}):Play()
				end)

				if tEndConn then tEndConn:Disconnect() end
				tEndConn = UserInputService.InputEnded:Connect(function(endInput)
					if not isDraggingKnob then return end
					if endInput.UserInputType ~= Enum.UserInputType.MouseButton1 and endInput.UserInputType ~= Enum.UserInputType.Touch then return end

					isDraggingKnob = false
					if tDragConn then tDragConn:Disconnect(); tDragConn = nil end
					if tEndConn then tEndConn:Disconnect(); tEndConn = nil end

					if not hasDraggedKnob then
						SetState(not isToggled, true)
					else
						local currentKnobX = KnobContainer.Position.X.Offset
						local center = currentKnobX + KNOB_W / 2
						SetState(center > TRACK_W / 2, true)
					end

					TweenService:Create(KnobUIScale, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = 1 }):Play()
					TweenService:Create(KnobOverlay, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
					TweenService:Create(KnobStroke, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 0.65 }):Play()
				end)
			end)

			return {
				Set = function(_, val) SetState(val, true) end,
				Value = function() return isToggled end
			}
		end

		function TabMethods:AddButton(opt)
			opt = opt or {}
			local text = opt.Title or "Button"
			local subtext = opt.Description or ""
			local callback = opt.Callback

			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Size = UDim2.new(1, 0, 0, 52)
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			ButtonFrame.BorderSizePixel = 0
			ButtonFrame.ClipsDescendants = true
			ButtonFrame.Parent = Page
			Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 10)

			local Stroke = Instance.new("UIStroke", ButtonFrame)
			Stroke.Color = Color3.fromRGB(255, 255, 255)
			Stroke.Transparency = 0.94
			Stroke.Thickness = 1

			local TrailContainer = Instance.new("Frame")
			TrailContainer.Name = "TrailContainer"
			TrailContainer.Size = UDim2.new(1, 0, 1, 0)
			TrailContainer.BackgroundTransparency = 1
			TrailContainer.ZIndex = 2
			TrailContainer.Parent = ButtonFrame

			local MainGlow = Instance.new("ImageLabel")
			MainGlow.Size = UDim2.new(0, 80, 0, 80)
			MainGlow.AnchorPoint = Vector2.new(0.5, 0.5)
			MainGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
			MainGlow.BackgroundTransparency = 1
			MainGlow.Image = "rbxassetid://5028857472"
			MainGlow.ImageColor3 = Color3.fromRGB(255, 255, 255)
			MainGlow.ImageTransparency = 1
			MainGlow.ZIndex = 3
			MainGlow.Parent = TrailContainer

			local TextContainer = Instance.new("Frame")
			TextContainer.Size = UDim2.new(1, -60, 1, 0)
			TextContainer.Position = UDim2.new(0, 12, 0, 0)
			TextContainer.BackgroundTransparency = 1
			TextContainer.ZIndex = 5
			TextContainer.Parent = ButtonFrame

			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.Text = text
			TitleLabel.Font = Enum.Font.GothamMedium
			TitleLabel.TextSize = 13
			TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.Size = UDim2.new(1, 0, 0, 18)
			TitleLabel.Position = UDim2.new(0, 0, 0, (subtext and subtext ~= "") and 8 or 17)
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.ZIndex = 5
			TitleLabel.Parent = TextContainer

			if subtext and subtext ~= "" then
				local SubLabel = Instance.new("TextLabel")
				SubLabel.Text = subtext
				SubLabel.Font = Enum.Font.Gotham
				SubLabel.TextSize = 11
				SubLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
				SubLabel.TextXAlignment = Enum.TextXAlignment.Left
				SubLabel.Size = UDim2.new(1, 0, 0, 14)
				SubLabel.Position = UDim2.new(0, 0, 0, 26)
				SubLabel.BackgroundTransparency = 1
				SubLabel.ZIndex = 5
				SubLabel.Parent = TextContainer
			end

			local Hitbox = Instance.new("TextButton")
			Hitbox.Size = UDim2.new(1, 0, 1, 0)
			Hitbox.BackgroundTransparency = 1
			Hitbox.Text = ""
			Hitbox.ZIndex = 10
			Hitbox.Parent = ButtonFrame

			local isPressed = false
			local lastSpawnTime = 0
			local lastPos = Vector2.zero

			local function SpawnTrailDroplet(posX, posY)
				local droplet = Instance.new("ImageLabel")
				droplet.Size = UDim2.new(0, 60, 0, 60)
				droplet.AnchorPoint = Vector2.new(0.5, 0.5)
				droplet.Position = UDim2.new(0, posX, 0, posY)
				droplet.BackgroundTransparency = 1
				droplet.Image = "rbxassetid://5028857472"
				droplet.ImageColor3 = Color3.fromRGB(255, 255, 255)
				droplet.ImageTransparency = 0.5
				droplet.ZIndex = 2
				droplet.Parent = TrailContainer

				local fadeTween = TweenService:Create(droplet, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 10, 0, 10),
					ImageTransparency = 1
				})
				fadeTween:Play()
				fadeTween.Completed:Connect(function() droplet:Destroy() end)
			end

			local function UpdateFingerPosition(screenX, screenY)
				local absPos = ButtonFrame.AbsolutePosition
				local absSize = ButtonFrame.AbsoluteSize
				local localX = math.clamp(screenX - absPos.X, 0, absSize.X)
				local localY = math.clamp(screenY - absPos.Y, 0, absSize.Y)

				MainGlow.Position = UDim2.new(0, localX, 0, localY)

				local currentPos = Vector2.new(localX, localY)
				local dist = (currentPos - lastPos).Magnitude
				local now = tick()

				if dist > 4 and (now - lastSpawnTime) > 0.02 then
					lastSpawnTime = now
					lastPos = currentPos
					SpawnTrailDroplet(localX, localY)
				end
			end

			Hitbox.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					isPressed = true
					local absPos = ButtonFrame.AbsolutePosition
					lastPos = Vector2.new(input.Position.X - absPos.X, input.Position.Y - absPos.Y)

					UpdateFingerPosition(input.Position.X, input.Position.Y)

					TweenService:Create(MainGlow, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
						ImageTransparency = 0.35,
						Size = UDim2.new(0, 90, 0, 90)
					}):Play()
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if isPressed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					UpdateFingerPosition(input.Position.X, input.Position.Y)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if isPressed then
						isPressed = false

						local mousePos = UserInputService:GetMouseLocation()
						local absPos = ButtonFrame.AbsolutePosition
						local absSize = ButtonFrame.AbsoluteSize

						local isInside = (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X)
							and (mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y)

						if isInside and callback then task.spawn(callback) end

						TweenService:Create(MainGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
							ImageTransparency = 1,
							Size = UDim2.new(0, 40, 0, 40)
						}):Play()
					end
				end
			end)
		end

		return TabMethods
	end

	return WindowObj
end

return Library
