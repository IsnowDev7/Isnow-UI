local cloneRef = cloneref or function(obj) return obj end

local Players = cloneRef(game:GetService("Players"))
local UserInputService = cloneRef(game:GetService("UserInputService"))
local TweenService = cloneRef(game:GetService("TweenService"))
local RunService = cloneRef(game:GetService("RunService"))
local CoreGui = cloneRef(game:GetService("CoreGui"))

local LocalPlayer = Players.LocalPlayer

local Library = {
	Spritesheet = {
		Id = "rbxassetid://77297718671545",
		MirroredId = "rbxassetid://92258969882244",
		Size = Vector2.new(102, 128),
		Total = 80,
		Cols = 10,
	},
	Theme = {
		WindowBg = Color3.fromRGB(16, 16, 20),
		SidebarBg = Color3.fromRGB(20, 20, 26),
		CardBg = Color3.fromRGB(24, 24, 30),
		CardHover = Color3.fromRGB(30, 30, 38),
		Border = Color3.fromRGB(44, 44, 56),
		TextMain = Color3.fromRGB(245, 245, 250),
		TextSub = Color3.fromRGB(145, 145, 160),
		AccentGreen = Color3.fromRGB(0, 205, 115),
		AccentRed = Color3.fromRGB(230, 60, 75),
		ToggleOff = Color3.fromRGB(34, 34, 44),
		White = Color3.fromRGB(255, 255, 255),
	}
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
	local Title = cfg.Title or "Foundation UI"
	local SubTitle = cfg.SubTitle or "v1.0.0"
	local Size = cfg.Size or UDim2.new(0, 580, 0, 360)

	local TargetParent = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
	pcall(function()
		if gethui then
			TargetParent = gethui()
		elseif CoreGui then
			TargetParent = CoreGui
		end
	end)

	local existing = TargetParent:FindFirstChild("Isnow_FoundationUI")
	if existing then existing:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Isnow_FoundationUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 999
	ScreenGui.Parent = TargetParent

	local Window = Instance.new("Frame")
	Window.Name = "MainWindow"
	Window.Size = Size
	Window.Position = UDim2.new(0.5, -Size.X.Offset / 2, 0.5, -Size.Y.Offset / 2)
	Window.BackgroundColor3 = self.Theme.WindowBg
	Window.BorderSizePixel = 0
	Window.ClipsDescendants = false
	Window.Parent = ScreenGui
	Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)

	local WindowStroke = Instance.new("UIStroke", Window)
	WindowStroke.Color = self.Theme.Border
	WindowStroke.Transparency = 0.5
	WindowStroke.Thickness = 1

	local BottomBar = Instance.new("Frame")
	BottomBar.Name = "BottomBar"
	BottomBar.Size = UDim2.new(1, 0, 0, 28)
	BottomBar.Position = UDim2.new(0, 0, 1, 6)
	BottomBar.BackgroundColor3 = self.Theme.SidebarBg
	BottomBar.BorderSizePixel = 0
	BottomBar.Parent = Window
	Instance.new("UICorner", BottomBar).CornerRadius = UDim.new(0, 8)

	local BottomStroke = Instance.new("UIStroke", BottomBar)
	BottomStroke.Color = self.Theme.Border
	BottomStroke.Transparency = 0.6
	BottomStroke.Thickness = 1

	local UserBadge = Instance.new("TextLabel")
	UserBadge.Text = "👤 " .. (LocalPlayer and LocalPlayer.DisplayName or "User")
	UserBadge.Font = Enum.Font.GothamMedium
	UserBadge.TextSize = 11
	UserBadge.TextColor3 = self.Theme.TextSub
	UserBadge.TextXAlignment = Enum.TextXAlignment.Left
	UserBadge.Size = UDim2.new(0.5, -14, 1, 0)
	UserBadge.Position = UDim2.new(0, 12, 0, 0)
	UserBadge.BackgroundTransparency = 1
	UserBadge.Parent = BottomBar

	local PerformanceLabel = Instance.new("TextLabel")
	PerformanceLabel.Text = "FPS: 60 | " .. SubTitle
	PerformanceLabel.Font = Enum.Font.Gotham
	PerformanceLabel.TextSize = 11
	PerformanceLabel.TextColor3 = self.Theme.TextSub
	PerformanceLabel.TextXAlignment = Enum.TextXAlignment.Right
	PerformanceLabel.Size = UDim2.new(0.5, -14, 1, 0)
	PerformanceLabel.Position = UDim2.new(0.5, 0, 0, 0)
	PerformanceLabel.BackgroundTransparency = 1
	PerformanceLabel.Parent = BottomBar

	local frameCount = 0
	local lastFpsTime = tick()
	local fpsConn = RunService.RenderStepped:Connect(function()
		frameCount = frameCount + 1
		local now = tick()
		if now - lastFpsTime >= 1 then
			local fps = math.floor(frameCount / (now - lastFpsTime))
			PerformanceLabel.Text = string.format("FPS: %d | %s", fps, SubTitle)
			frameCount = 0
			lastFpsTime = now
		end
	end)

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 160, 1, 0)
	Sidebar.BackgroundColor3 = self.Theme.SidebarBg
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Window
	Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

	local SidebarDivider = Instance.new("Frame")
	SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
	SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
	SidebarDivider.BackgroundColor3 = self.Theme.Border
	SidebarDivider.BackgroundTransparency = 0.6
	SidebarDivider.BorderSizePixel = 0
	SidebarDivider.Parent = Sidebar

	local BrandHeader = Instance.new("Frame")
	BrandHeader.Size = UDim2.new(1, 0, 0, 52)
	BrandHeader.BackgroundTransparency = 1
	BrandHeader.Parent = Sidebar

	local LogoIcon = Instance.new("ImageLabel")
	LogoIcon.Size = UDim2.new(0, 22, 0, 22)
	LogoIcon.Position = UDim2.new(0, 16, 0.5, -11)
	LogoIcon.BackgroundTransparency = 1
	LogoIcon.Image = "rbxassetid://6031075931"
	LogoIcon.ImageColor3 = self.Theme.AccentGreen
	LogoIcon.Parent = BrandHeader

	local BrandTitle = Instance.new("TextLabel")
	BrandTitle.Text = Title
	BrandTitle.Font = Enum.Font.GothamBold
	BrandTitle.TextSize = 14
	BrandTitle.TextColor3 = self.Theme.TextMain
	BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
	BrandTitle.Size = UDim2.new(1, -50, 1, 0)
	BrandTitle.Position = UDim2.new(0, 46, 0, 0)
	BrandTitle.BackgroundTransparency = 1
	BrandTitle.Parent = BrandHeader

	local TabList = Instance.new("ScrollingFrame")
	TabList.Name = "TabList"
	TabList.Size = UDim2.new(1, -16, 1, -64)
	TabList.Position = UDim2.new(0, 8, 0, 56)
	TabList.BackgroundTransparency = 1
	TabList.BorderSizePixel = 0
	TabList.ScrollBarThickness = 0
	TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabList.Parent = Sidebar

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 6)
	TabLayout.Parent = TabList

	local PagesContainer = Instance.new("Frame")
	PagesContainer.Name = "PagesContainer"
	PagesContainer.Size = UDim2.new(1, -160, 1, 0)
	PagesContainer.Position = UDim2.new(0, 160, 0, 0)
	PagesContainer.BackgroundTransparency = 1
	PagesContainer.Parent = Window

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 48)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = PagesContainer

	local PageTitle = Instance.new("TextLabel")
	PageTitle.Name = "CurrentPageTitle"
	PageTitle.Text = ""
	PageTitle.Font = Enum.Font.GothamBold
	PageTitle.TextSize = 16
	PageTitle.TextColor3 = self.Theme.TextMain
	PageTitle.TextXAlignment = Enum.TextXAlignment.Left
	PageTitle.Size = UDim2.new(1, -30, 1, 0)
	PageTitle.Position = UDim2.new(0, 20, 0, 0)
	PageTitle.BackgroundTransparency = 1
	PageTitle.Parent = TopBar

	local isDragging = false
	local dragStart = Vector2.zero
	local startPos = UDim2.new()

	local function InitDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			startPos = Window.Position
		end
	end

	TopBar.InputBegan:Connect(InitDrag)
	BrandHeader.InputBegan:Connect(InitDrag)

	local dragConn = UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
			Window.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	local endConn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)

	local WindowObj = {
		ScreenGui = ScreenGui,
		Window = Window,
		Tabs = {},
		CurrentTab = nil,
	}

	function WindowObj:Destroy()
		if fpsConn then fpsConn:Disconnect() end
		if dragConn then dragConn:Disconnect() end
		if endConn then endConn:Disconnect() end
		ScreenGui:Destroy()
	end

	function WindowObj:CreateTab(name, iconId)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name .. "_Page"
		Page.Size = UDim2.new(1, -36, 1, -56)
		Page.Position = UDim2.new(0, 18, 0, 48)
		Page.BackgroundTransparency = 1
		Page.BorderSizePixel = 0
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Library.Theme.Border
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Visible = false
		Page.Parent = PagesContainer

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 10)
		PageLayout.Parent = Page

		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = name .. "_Btn"
		TabBtn.Size = UDim2.new(1, 0, 0, 38)
		TabBtn.BackgroundColor3 = Library.Theme.SidebarBg
		TabBtn.BackgroundTransparency = 1
		TabBtn.BorderSizePixel = 0
		TabBtn.Text = ""
		TabBtn.AutoButtonColor = false
		TabBtn.Parent = TabList
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

		local Indicator = Instance.new("Frame")
		Indicator.Size = UDim2.new(0, 3, 0, 18)
		Indicator.Position = UDim2.new(0, 0, 0.5, -9)
		Indicator.BackgroundColor3 = Library.Theme.AccentGreen
		Indicator.BorderSizePixel = 0
		Indicator.BackgroundTransparency = 1
		Indicator.Parent = TabBtn
		Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

		local Icon = Instance.new("ImageLabel")
		Icon.Size = UDim2.new(0, 16, 0, 16)
		Icon.Position = UDim2.new(0, 12, 0.5, -8)
		Icon.BackgroundTransparency = 1
		Icon.Image = iconId or "rbxassetid://6031075931"
		Icon.ImageColor3 = Library.Theme.TextSub
		Icon.Parent = TabBtn

		local TabTitle = Instance.new("TextLabel")
		TabTitle.Text = name
		TabTitle.Font = Enum.Font.GothamMedium
		TabTitle.TextSize = 13
		TabTitle.TextColor3 = Library.Theme.TextSub
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left
		TabTitle.Size = UDim2.new(1, -38, 1, 0)
		TabTitle.Position = UDim2.new(0, 36, 0, 0)
		TabTitle.BackgroundTransparency = 1
		TabTitle.Parent = TabBtn

		local TabInstance = {
			Button = TabBtn,
			Page = Page,
			Indicator = Indicator,
			Icon = Icon,
			Title = TabTitle,
		}

		local function SelectTab()
			if WindowObj.CurrentTab == TabInstance then return end

			if WindowObj.CurrentTab then
				WindowObj.CurrentTab.Page.Visible = false
				TweenService:Create(WindowObj.CurrentTab.Button, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
				TweenService:Create(WindowObj.CurrentTab.Indicator, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
				TweenService:Create(WindowObj.CurrentTab.Icon, TweenInfo.new(0.2), { ImageColor3 = Library.Theme.TextSub }):Play()
				TweenService:Create(WindowObj.CurrentTab.Title, TweenInfo.new(0.2), { TextColor3 = Library.Theme.TextSub }):Play()
			end

			WindowObj.CurrentTab = TabInstance
			PageTitle.Text = name
			Page.Visible = true

			TweenService:Create(TabBtn, TweenInfo.new(0.2), { BackgroundColor3 = Library.Theme.CardBg, BackgroundTransparency = 0 }):Play()
			TweenService:Create(Indicator, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(Icon, TweenInfo.new(0.2), { ImageColor3 = Library.Theme.TextMain }):Play()
			TweenService:Create(TabTitle, TweenInfo.new(0.2), { TextColor3 = Library.Theme.TextMain }):Play()
		end

		TabBtn.MouseButton1Click:Connect(SelectTab)

		TabBtn.MouseEnter:Connect(function()
			if WindowObj.CurrentTab ~= TabInstance then
				TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundColor3 = Library.Theme.CardBg, BackgroundTransparency = 0.5 }):Play()
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if WindowObj.CurrentTab ~= TabInstance then
				TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
			end
		end)

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
			Row.Size = UDim2.new(1, 0, 0, 56)
			Row.BackgroundColor3 = Library.Theme.CardBg
			Row.BorderSizePixel = 0
			Row.Parent = Page
			Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)

			local RowStroke = Instance.new("UIStroke", Row)
			RowStroke.Color = Library.Theme.Border
			RowStroke.Transparency = 0.75
			RowStroke.Thickness = 1

			local LabelTitle = Instance.new("TextLabel")
			LabelTitle.Text = title
			LabelTitle.Font = Enum.Font.GothamMedium
			LabelTitle.TextSize = 13
			LabelTitle.TextColor3 = Library.Theme.TextMain
			LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
			LabelTitle.Size = UDim2.new(1, -90, 0, 18)
			LabelTitle.Position = UDim2.new(0, 14, 0, 10)
			LabelTitle.BackgroundTransparency = 1
			LabelTitle.Parent = Row

			local LabelDesc = Instance.new("TextLabel")
			LabelDesc.Text = desc
			LabelDesc.Font = Enum.Font.Gotham
			LabelDesc.TextSize = 11
			LabelDesc.TextColor3 = Library.Theme.TextSub
			LabelDesc.TextXAlignment = Enum.TextXAlignment.Left
			LabelDesc.Size = UDim2.new(1, -90, 0, 14)
			LabelDesc.Position = UDim2.new(0, 14, 0, 28)
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
			Track.Position = UDim2.new(1, -14, 0.5, 0)
			Track.BackgroundColor3 = Library.Theme.ToggleOff
			Track.BorderSizePixel = 0
			Track.ClipsDescendants = false
			Track.Parent = Row
			Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

			local TrackStroke = Instance.new("UIStroke", Track)
			TrackStroke.Color = Library.Theme.White
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
			GlassBg.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
			GlassBg.BackgroundTransparency = 0.2
			GlassBg.BorderSizePixel = 0
			GlassBg.Parent = KnobScaler
			Instance.new("UICorner", GlassBg).CornerRadius = UDim.new(1, 0)

			local GlassSprite = Instance.new("ImageLabel")
			GlassSprite.Size = UDim2.new(1, 0, 1, 0)
			GlassSprite.BackgroundTransparency = 1
			GlassSprite.ImageTransparency = 0.85
			GlassSprite.ImageColor3 = Library.Theme.AccentRed
			GlassSprite.Parent = KnobScaler
			Instance.new("UICorner", GlassSprite).CornerRadius = UDim.new(1, 0)

			local KnobOverlay = Instance.new("Frame")
			KnobOverlay.Size = UDim2.new(1, 0, 1, 0)
			KnobOverlay.BackgroundColor3 = Library.Theme.White
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
				local targetColor = isToggled and Library.Theme.AccentGreen or Library.Theme.ToggleOff

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

				GlassSprite.ImageColor3 = isToggled and Library.Theme.AccentGreen or Library.Theme.AccentRed
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

				GlassSprite.ImageColor3 = isToggled and Library.Theme.AccentGreen or Library.Theme.AccentRed

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

			Row.MouseEnter:Connect(function()
				TweenService:Create(Row, TweenInfo.new(0.2), { BackgroundColor3 = Library.Theme.CardHover }):Play()
			end)
			Row.MouseLeave:Connect(function()
				TweenService:Create(Row, TweenInfo.new(0.2), { BackgroundColor3 = Library.Theme.CardBg }):Play()
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
			ButtonFrame.Size = UDim2.new(1, 0, 0, 56)
			ButtonFrame.BackgroundColor3 = Library.Theme.CardBg
			ButtonFrame.BorderSizePixel = 0
			ButtonFrame.ClipsDescendants = true
			ButtonFrame.Parent = Page
			Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 10)

			local Stroke = Instance.new("UIStroke", ButtonFrame)
			Stroke.Color = Library.Theme.Border
			Stroke.Transparency = 0.75
			Stroke.Thickness = 1

			local TrailContainer = Instance.new("Frame")
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
			MainGlow.ImageColor3 = Library.Theme.White
			MainGlow.ImageTransparency = 1
			MainGlow.ZIndex = 3
			MainGlow.Parent = TrailContainer

			local TextContainer = Instance.new("Frame")
			TextContainer.Size = UDim2.new(1, -60, 1, 0)
			TextContainer.Position = UDim2.new(0, 14, 0, 0)
			TextContainer.BackgroundTransparency = 1
			TextContainer.ZIndex = 5
			TextContainer.Parent = ButtonFrame

			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.Text = text
			TitleLabel.Font = Enum.Font.GothamMedium
			TitleLabel.TextSize = 13
			TitleLabel.TextColor3 = Library.Theme.TextMain
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.Size = UDim2.new(1, 0, 0, 18)
			TitleLabel.Position = UDim2.new(0, 0, 0, (subtext and subtext ~= "") and 10 or 19)
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.ZIndex = 5
			TitleLabel.Parent = TextContainer

			if subtext and subtext ~= "" then
				local SubLabel = Instance.new("TextLabel")
				SubLabel.Text = subtext
				SubLabel.Font = Enum.Font.Gotham
				SubLabel.TextSize = 11
				SubLabel.TextColor3 = Library.Theme.TextSub
				SubLabel.TextXAlignment = Enum.TextXAlignment.Left
				SubLabel.Size = UDim2.new(1, 0, 0, 14)
				SubLabel.Position = UDim2.new(0, 0, 0, 28)
				SubLabel.BackgroundTransparency = 1
				SubLabel.ZIndex = 5
				SubLabel.Parent = TextContainer
			end

			local Arrow = Instance.new("ImageLabel")
			Arrow.Size = UDim2.new(0, 16, 0, 16)
			Arrow.AnchorPoint = Vector2.new(1, 0.5)
			Arrow.Position = UDim2.new(1, -16, 0.5, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Image = "rbxassetid://6031091004"
			Arrow.ImageColor3 = Library.Theme.TextSub
			Arrow.ZIndex = 5
			Arrow.Parent = ButtonFrame

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
				droplet.ImageColor3 = Library.Theme.White
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
					TweenService:Create(ButtonFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
						BackgroundColor3 = Library.Theme.CardHover
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
						TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
							BackgroundColor3 = Library.Theme.CardBg
						}):Play()
					end
				end
			end)

			ButtonFrame.MouseEnter:Connect(function()
				TweenService:Create(ButtonFrame, TweenInfo.new(0.2), { BackgroundColor3 = Library.Theme.CardHover }):Play()
			end)
			ButtonFrame.MouseLeave:Connect(function()
				if not isPressed then
					TweenService:Create(ButtonFrame, TweenInfo.new(0.2), { BackgroundColor3 = Library.Theme.CardBg }):Play()
				end
			end)
		end

		return TabMethods
	end

	return WindowObj
end

return Library
