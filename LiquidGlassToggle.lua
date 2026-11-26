local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local existingGui = playerGui:FindFirstChild("WindUI_Window")
if existingGui then existingGui:Destroy() end

local GlassSpritesheet = {
	Id         = "rbxassetid://77297718671545",
	MirroredId = "rbxassetid://92258969882244",
	Size       = Vector2.new(102, 128),
	Total      = 80,
	Cols       = 10,
}

local function GetGlassFrame(T)
	T = math.clamp(T, 0, 1)
	local S = GlassSpritesheet
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
	if Mirrored then
		Frame = (S.Total - 1) - Frame
	end

	local Id = Mirrored and S.MirroredId or S.Id
	return Id, S.Size, Vector2.new((Frame % S.Cols) * S.Size.X, math.floor(Frame / S.Cols) * S.Size.Y)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WindUI_Window"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = playerGui

local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Size = UDim2.new(0, 440, 0, 310)
Window.Position = UDim2.new(0.5, -220, 0.5, -155)
Window.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Window.BorderSizePixel = 0
Window.Parent = ScreenGui
Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)

local WindowStroke = Instance.new("UIStroke", Window)
WindowStroke.Color = Color3.fromRGB(48, 48, 58)
WindowStroke.Transparency = 0.5
WindowStroke.Thickness = 1

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Window

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Wind UI"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TitleBar

local SubtitleBadge = Instance.new("TextLabel")
SubtitleBadge.Text = "v1.4.0"
SubtitleBadge.Font = Enum.Font.GothamMedium
SubtitleBadge.TextSize = 11
SubtitleBadge.TextColor3 = Color3.fromRGB(150, 150, 160)
SubtitleBadge.Size = UDim2.new(0, 46, 0, 20)
SubtitleBadge.Position = UDim2.new(0, 80, 0.5, -10)
SubtitleBadge.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
SubtitleBadge.BorderSizePixel = 0
SubtitleBadge.Parent = TitleBar
Instance.new("UICorner", SubtitleBadge).CornerRadius = UDim.new(0, 6)

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
HeaderLine.BackgroundTransparency = 0.6
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = TitleBar

local draggingWindow = false
local dragStartPos = Vector2.zero
local startWindowPos = UDim2.new()

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingWindow = true
		dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
		startWindowPos = Window.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingWindow and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
		Window.Position = UDim2.new(
			startWindowPos.X.Scale,
			startWindowPos.X.Offset + delta.X,
			startWindowPos.Y.Scale,
			startWindowPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingWindow = false
	end
end)

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -32, 1, -62)
Content.Position = UDim2.new(0, 16, 0, 54)
Content.BackgroundTransparency = 1
Content.Parent = Window

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.Parent = Content

local function CreateWindToggle(parent, title, desc, defaultValue, callback)
	local Row = Instance.new("Frame")
	Row.Name = "ToggleRow"
	Row.Size = UDim2.new(1, 0, 0, 56)
	Row.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	Row.BorderSizePixel = 0
	Row.Parent = parent
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)

	local RowStroke = Instance.new("UIStroke", Row)
	RowStroke.Color = Color3.fromRGB(48, 48, 58)
	RowStroke.Transparency = 0.75
	RowStroke.Thickness = 1

	local TextContainer = Instance.new("Frame")
	TextContainer.Size = UDim2.new(1, -90, 1, 0)
	TextContainer.Position = UDim2.new(0, 14, 0, 0)
	TextContainer.BackgroundTransparency = 1
	TextContainer.Parent = Row

	local LabelTitle = Instance.new("TextLabel")
	LabelTitle.Text = title
	LabelTitle.Font = Enum.Font.GothamMedium
	LabelTitle.TextSize = 14
	LabelTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
	LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
	LabelTitle.Size = UDim2.new(1, 0, 0, 18)
	LabelTitle.Position = UDim2.new(0, 0, 0, 10)
	LabelTitle.BackgroundTransparency = 1
	LabelTitle.Parent = TextContainer

	local LabelDesc = Instance.new("TextLabel")
	LabelDesc.Text = desc
	LabelDesc.Font = Enum.Font.Gotham
	LabelDesc.TextSize = 11
	LabelDesc.TextColor3 = Color3.fromRGB(150, 150, 160)
	LabelDesc.TextXAlignment = Enum.TextXAlignment.Left
	LabelDesc.Size = UDim2.new(1, 0, 0, 14)
	LabelDesc.Position = UDim2.new(0, 0, 0, 28)
	LabelDesc.BackgroundTransparency = 1
	LabelDesc.Parent = TextContainer

	local TRACK_W = 64
	local TRACK_H = 32
	local KNOB_W  = 42
	local KNOB_H  = 26
	local PAD     = 3

	local Track = Instance.new("Frame")
	Track.Name = "Track"
	Track.Size = UDim2.new(0, TRACK_W, 0, TRACK_H)
	Track.AnchorPoint = Vector2.new(1, 0.5)
	Track.Position = UDim2.new(1, -14, 0.5, 0)
	Track.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
	Track.BorderSizePixel = 0
	Track.ClipsDescendants = false
	Track.Parent = Row
	Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

	local TrackStroke = Instance.new("UIStroke", Track)
	TrackStroke.Color = Color3.fromRGB(255, 255, 255)
	TrackStroke.Transparency = 0.92
	TrackStroke.Thickness = 1

	local KnobContainer = Instance.new("Frame")
	KnobContainer.Name = "KnobContainer"
	KnobContainer.Size = UDim2.new(0, KNOB_W, 0, KNOB_H)
	KnobContainer.Position = UDim2.new(0, PAD, 0.5, 0)
	KnobContainer.AnchorPoint = Vector2.new(0, 0.5)
	KnobContainer.BackgroundTransparency = 1
	KnobContainer.BorderSizePixel = 0
	KnobContainer.Parent = Track

	local KnobScaler = Instance.new("Frame")
	KnobScaler.Name = "KnobScaler"
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
	GlassSprite.Name = "GlassSprite"
	GlassSprite.Size = UDim2.new(1, 0, 1, 0)
	GlassSprite.BackgroundTransparency = 1
	GlassSprite.ImageTransparency = 0.85
	GlassSprite.ImageColor3 = Color3.fromRGB(225, 60, 75)
	GlassSprite.Parent = KnobScaler
	Instance.new("UICorner", GlassSprite).CornerRadius = UDim.new(1, 0)

	local KnobOverlay = Instance.new("Frame")
	KnobOverlay.Name = "BarOverlay"
	KnobOverlay.Size = UDim2.new(1, 0, 1, 0)
	KnobOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	KnobOverlay.BackgroundTransparency = 0
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

	local isToggled = defaultValue or false
	local isDragging = false
	local hasDragged = false
	local startX = 0
	local startKnobX = PAD
	local maxTravelX = TRACK_W - KNOB_W - PAD

	local function UpdateGlass(percent)
		local id, rectSize, rectOffset = GetGlassFrame(percent)
		GlassSprite.Image = id
		GlassSprite.ImageRectSize = rectSize
		GlassSprite.ImageRectOffset = rectOffset
	end

	local function SetState(newState, animate)
		isToggled = newState
		local targetX = isToggled and maxTravelX or PAD
		local targetColor = isToggled and Color3.fromRGB(0, 200, 115) or Color3.fromRGB(38, 38, 48)

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

		GlassSprite.ImageColor3 = isToggled and Color3.fromRGB(0, 200, 115) or Color3.fromRGB(225, 60, 75)
		TweenService:Create(GlassSprite, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			ImageTransparency = isToggled and 0 or 0.85
		}):Play()

		UpdateGlass(isToggled and 1 or 0)

		if callback then
			task.spawn(callback, isToggled)
		end
	end

	SetState(isToggled, false)

	local dragConn, endConn

	Hitbox.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		isDragging = true
		hasDragged = false
		startX = input.Position.X
		startKnobX = KnobContainer.Position.X.Offset

		GlassSprite.ImageColor3 = isToggled and Color3.fromRGB(0, 200, 115) or Color3.fromRGB(225, 60, 75)

		TweenService:Create(KnobUIScale, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Scale = 1.28
		}):Play()
		TweenService:Create(KnobOverlay, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.86
		}):Play()
		TweenService:Create(KnobStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Transparency = 1
		}):Play()
		TweenService:Create(GlassSprite, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			ImageTransparency = 0
		}):Play()

		if dragConn then dragConn:Disconnect() end
		dragConn = UserInputService.InputChanged:Connect(function(moveInput)
			if not isDragging then return end
			if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement and moveInput.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			local delta = moveInput.Position.X - startX
			if not hasDragged and math.abs(delta) > 4 then
				hasDragged = true
			end

			local newX = math.clamp(startKnobX + delta, PAD - 4, maxTravelX + 4)
			local percent = math.clamp((newX - PAD) / (maxTravelX - PAD), 0, 1)

			UpdateGlass(percent)

			TweenService:Create(KnobContainer, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, newX, 0.5, 0)
			}):Play()
		end)

		if endConn then endConn:Disconnect() end
		endConn = UserInputService.InputEnded:Connect(function(endInput)
			if not isDragging then return end
			if endInput.UserInputType ~= Enum.UserInputType.MouseButton1 and endInput.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			isDragging = false
			if dragConn then dragConn:Disconnect(); dragConn = nil end
			if endConn then endConn:Disconnect(); endConn = nil end

			if not hasDragged then
				SetState(not isToggled, true)
			else
				local currentKnobX = KnobContainer.Position.X.Offset
				local center = currentKnobX + KNOB_W / 2
				SetState(center > TRACK_W / 2, true)
			end

			TweenService:Create(KnobUIScale, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()
			TweenService:Create(KnobOverlay, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0
			}):Play()
			TweenService:Create(KnobStroke, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Transparency = 0.65
			}):Play()
		end)
	end)

	Row.MouseEnter:Connect(function()
		TweenService:Create(Row, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(32, 32, 40) }):Play()
	end)
	Row.MouseLeave:Connect(function()
		TweenService:Create(Row, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(26, 26, 32) }):Play()
	end)

	return Row
end

local function CreateGlowTrailButton(parent, text, subtext, callback)
	local ButtonFrame = Instance.new("Frame")
	ButtonFrame.Name = "TrailButton"
	ButtonFrame.Size = UDim2.new(1, 0, 0, 56)
	ButtonFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	ButtonFrame.BorderSizePixel = 0
	ButtonFrame.ClipsDescendants = true
	ButtonFrame.Parent = parent
	Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 10)

	local Stroke = Instance.new("UIStroke", ButtonFrame)
	Stroke.Color = Color3.fromRGB(48, 48, 58)
	Stroke.Transparency = 0.75
	Stroke.Thickness = 1

	local TrailContainer = Instance.new("Frame")
	TrailContainer.Name = "TrailContainer"
	TrailContainer.Size = UDim2.new(1, 0, 1, 0)
	TrailContainer.BackgroundTransparency = 1
	TrailContainer.ZIndex = 2
	TrailContainer.Parent = ButtonFrame

	local MainGlow = Instance.new("ImageLabel")
	MainGlow.Name = "MainGlow"
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
	TextContainer.Position = UDim2.new(0, 14, 0, 0)
	TextContainer.BackgroundTransparency = 1
	TextContainer.ZIndex = 5
	TextContainer.Parent = ButtonFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = text
	TitleLabel.Font = Enum.Font.GothamMedium
	TitleLabel.TextSize = 14
	TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
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
		SubLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
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
	Arrow.ImageColor3 = Color3.fromRGB(160, 160, 175)
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
		droplet.ImageColor3 = Color3.fromRGB(255, 255, 255)
		droplet.ImageTransparency = 0.5
		droplet.ZIndex = 2
		droplet.Parent = TrailContainer

		local fadeTween = TweenService:Create(droplet, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 10, 0, 10),
			ImageTransparency = 1
		})
		fadeTween:Play()
		fadeTween.Completed:Connect(function()
			droplet:Destroy()
		end)
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
				BackgroundColor3 = Color3.fromRGB(32, 32, 40)
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

				if isInside and callback then
					task.spawn(callback)
				end

				TweenService:Create(MainGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
					ImageTransparency = 1,
					Size = UDim2.new(0, 40, 0, 40)
				}):Play()
				TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundColor3 = Color3.fromRGB(26, 26, 32)
				}):Play()
			end
		end
	end)

	ButtonFrame.MouseEnter:Connect(function()
		TweenService:Create(ButtonFrame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 30, 38) }):Play()
	end)
	ButtonFrame.MouseLeave:Connect(function()
		if not isPressed then
			TweenService:Create(ButtonFrame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(26, 26, 32) }):Play()
		end
	end)

	return ButtonFrame
end

CreateWindToggle(
	Content,
	"Liquid Glass Toggle",
	"Spritesheet fluid effect with drag pop",
	false,
	function(val)
		print("Toggle 1:", val)
	end
)

CreateGlowTrailButton(
	Content,
	"Execute Script",
	"Drag or move your finger to emit white light trail",
	function()
		print("Execute Script pressed!")
	end
)

CreateGlowTrailButton(
	Content,
	"Rejoin Server",
	"Interactive trail button component",
	function()
		print("Rejoin Server pressed!")
	end
)
