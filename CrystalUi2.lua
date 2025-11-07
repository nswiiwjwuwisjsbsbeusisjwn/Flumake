local player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

if CoreGui:FindFirstChild('Crystal hub') then
    CoreGui:FindFirstChild('Crystal hub'):Destroy()
end

local Crystal = {
    TweenService = TweenService,
    Player = game.Players.LocalPlayer,
    Workspace = workspace,
    CoreGui = CoreGui,
    UserInputService = game:GetService("UserInputService"),
    Mouse = game.Players.LocalPlayer:GetMouse(),
    ViewportSize = workspace.CurrentCamera.ViewportSize,
    Stepped = RunService.Stepped,
    OldMouseIcon = game.Players.LocalPlayer:GetMouse().Icon
}

Crystal.Colors = {
    Primary = Color3.fromRGB(100, 200, 255),
    Secondary = Color3.fromRGB(180, 100, 255),
    Background = Color3.fromRGB(10, 10, 20),
    BackgroundSecondary = Color3.fromRGB(15, 20, 35),
    BackgroundTertiary = Color3.fromRGB(20, 25, 40),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(80, 60, 120),
    Accent = Color3.fromRGB(200, 170, 255)
}

Crystal.Types = {
    Info = {
        Icon = "rbxassetid://11401835396",
        Color = Color3.fromRGB(100, 150, 255)
    },
    Success = {
        Icon = "rbxassetid://11401835396",
        Color = Color3.fromRGB(50, 200, 150)
    },
    Warning = {
        Icon = "rbxassetid://11401835396",
        Color = Color3.fromRGB(255, 180, 100)
    },
    Error = {
        Icon = "rbxassetid://11401835396",
        Color = Color3.fromRGB(255, 100, 100)
    }
}

Crystal.TweenObject = function(config)
    config.Object = config.Object or config[1]
    config.Time = config.Time or config[2]
    config.OldValue = config.OldValue or config[3]
    config.NewValue = config.NewValue or config[4]
    local Info = TweenInfo.new(config.Time, Enum.EasingStyle.Quint)
    local tween = Crystal.TweenService:Create(config.Object, Info, {[config.OldValue] = config.NewValue})
    tween:Play()
    return tween
end

Crystal.Click = function(Object, callback)
    Object.Activated:Connect(function()
        callback()
    end)
end

Crystal.Mouseto = function(Object, CallbackEnter, CallbackLeave)
    Object.MouseEnter:Connect(function()
        CallbackEnter()
    end)
    Object.MouseLeave:Connect(function()
        CallbackLeave()
    end)
end

Crystal.MakeDraggable = function(object, top)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local newPos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        object.Position = newPos
    end
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    Crystal.UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdatePos(input)
        end
    end)
end

Crystal.CustomSize = function(object)
    local Dragging = false
    local DragInput = nil
    local DragStart = nil
    local StartSize = nil
    local maxSizeX = object.Size.X.Offset
    local maxSizeY = object.Size.Y.Offset
    object.Size = UDim2.new(0, maxSizeX, 0, maxSizeY)
    local changesizeobject = Instance.new("Frame")
    changesizeobject.AnchorPoint = Vector2.new(1, 1)
    changesizeobject.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    changesizeobject.BackgroundTransparency = 0.999
    changesizeobject.BorderColor3 = Color3.fromRGB(0, 0, 0)
    changesizeobject.BorderSizePixel = 0
    changesizeobject.Position = UDim2.new(1, 20, 1, 20)
    changesizeobject.Size = UDim2.new(0, 40, 0, 40)
    changesizeobject.Name = "changesizeobject"
    changesizeobject.Parent = object
    Crystal.Mouseto(changesizeobject, function()
        Crystal.Mouse.Icon = "rbxassetid://97880490001888"
    end, function()
        Crystal.Mouse.Icon = Crystal.OldMouseIcon
    end)
    local function UpdateSize(input)
        local Delta = input.Position - DragStart
        local newWidth = StartSize.X.Offset + Delta.X
        local newHeight = StartSize.Y.Offset + Delta.Y
        newWidth = math.max(newWidth, maxSizeX)
        newHeight = math.max(newHeight, maxSizeY)
        object.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
    changesizeobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartSize = object.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    changesizeobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    Crystal.UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdateSize(input)
        end
    end)
end

Crystal.GetMidPos = function(mainFrame)
    return UDim2.new(0, (Crystal.ViewportSize.X/2 - mainFrame.Size.X.Offset/2), 0, (Crystal.ViewportSize.Y/2 - mainFrame.Size.Y.Offset/2))
end

Crystal.ShowLoading = function()
    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "CrystalLoading"
    LoadingGui.IgnoreGuiInset = true
    LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    LoadingGui.DisplayOrder = 999999
    LoadingGui.ResetOnSpawn = false
    LoadingGui.Parent = CoreGui

    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Crystal.Colors.Background
    Background.BackgroundTransparency = 0.2
    Background.BorderSizePixel = 0
    Background.ZIndex = 10
    Background.Parent = LoadingGui

    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 0
    BlurEffect.Parent = game.Lighting

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0, 400, 0, 400)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.BackgroundTransparency = 1
    Container.ZIndex = 20
    Container.Parent = LoadingGui

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 180, 0, 180)
    Circle.AnchorPoint = Vector2.new(0.5, 0.5)
    Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
    Circle.BackgroundColor3 = Crystal.Colors.BackgroundSecondary
    Circle.BackgroundTransparency = 0.1
    Circle.ZIndex = 21
    Circle.Parent = Container

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local CircleStroke = Instance.new("UIStroke")
    CircleStroke.Thickness = 12
    CircleStroke.Color = Crystal.Colors.Text
    CircleStroke.Transparency = 0
    CircleStroke.Parent = Circle

    local CircleGradient = Instance.new("UIGradient")
    CircleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Crystal.Colors.Primary),
        ColorSequenceKeypoint.new(0.5, Crystal.Colors.Secondary),
        ColorSequenceKeypoint.new(1, Crystal.Colors.Primary)
    })
    CircleGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.4, 0),
        NumberSequenceKeypoint.new(0.7, 0.6),
        NumberSequenceKeypoint.new(1, 1)
    })
    CircleGradient.Rotation = 0
    CircleGradient.Parent = CircleStroke

    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 100, 0, 100)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://126956292082716"
    Logo.ImageColor3 = Crystal.Colors.Text
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.ImageTransparency = 0
    Logo.ZIndex = 22
    Logo.Parent = Circle

    local ProgressBarBg = Instance.new("Frame")
    ProgressBarBg.Size = UDim2.new(0, 350, 0, 18)
    ProgressBarBg.Position = UDim2.new(0.5, 0, 0.82, 0)
    ProgressBarBg.AnchorPoint = Vector2.new(0.5, 0.5)
    ProgressBarBg.BackgroundColor3 = Crystal.Colors.BackgroundTertiary
    ProgressBarBg.BackgroundTransparency = 0.3
    ProgressBarBg.BorderSizePixel = 0
    ProgressBarBg.ZIndex = 21
    ProgressBarBg.Parent = Container

    local ProgressBarBgCorner = Instance.new("UICorner")
    ProgressBarBgCorner.CornerRadius = UDim.new(0.5, 0)
    ProgressBarBgCorner.Parent = ProgressBarBg

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, -4)
    ProgressBar.Position = UDim2.new(0, 2, 0.5, 0)
    ProgressBar.AnchorPoint = Vector2.new(0, 0.5)
    ProgressBar.BackgroundColor3 = Crystal.Colors.Primary
    ProgressBar.BorderSizePixel = 0
    ProgressBar.ZIndex = 22
    ProgressBar.Parent = ProgressBarBg

    local ProgressBarCorner = Instance.new("UICorner")
    ProgressBarCorner.CornerRadius = UDim.new(0.5, 0)
    ProgressBarCorner.Parent = ProgressBar

    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 15}):Play()

    local startTime = tick()
    local rotation = 0

    task.spawn(function()
        while tick() - startTime < 3 do
            local elapsed = tick() - startTime
            local progress = math.min(elapsed / 3, 1)
            
            rotation = (rotation + 4) % 360
            CircleGradient.Rotation = rotation
            
            local barWidth = (350 - 4) * progress
            TweenService:Create(ProgressBar, TweenInfo.new(0.1), {
                Size = UDim2.new(0, barWidth, 1, -4)
            }):Play()
            
            RunService.RenderStepped:Wait()
        end
        
        local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        
        TweenService:Create(Background, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(BlurEffect, fadeInfo, {Size = 0}):Play()
        TweenService:Create(Circle, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(CircleStroke, fadeInfo, {Transparency = 1}):Play()
        TweenService:Create(Logo, fadeInfo, {ImageTransparency = 1}):Play()
        TweenService:Create(ProgressBarBg, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(ProgressBar, fadeInfo, {BackgroundTransparency = 1}):Play()
        
        task.wait(0.5)
        BlurEffect:Destroy()
        LoadingGui:Destroy()
    end)

    return LoadingGui
end

Crystal.Notify = function(self, NotifyConfig)
    NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Crystal Hub"
    NotifyConfig.Title1 = NotifyConfig.Title1 or "By Shinichi"
    NotifyConfig.Content = NotifyConfig.Content or "..."
    NotifyConfig.Logo = NotifyConfig.Logo or "rbxassetid://129781592728096"
    NotifyConfig.Type = NotifyConfig.Type or "Info"
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5
    NotifyConfig.Buttons = NotifyConfig.Buttons or {}
    NotifyConfig.YesCallback = NotifyConfig.YesCallback or function() end
    NotifyConfig.NoCallback = NotifyConfig.NoCallback or function() end

    local NotifyFunc = {}

    spawn(function()
        if not Crystal.CoreGui:FindFirstChild("NotifyGui") then
            local NotifyGui = Instance.new("ScreenGui")
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotifyGui.Name = "NotifyGui"
            NotifyGui.Parent = Crystal.CoreGui
        end

        if not Crystal.CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
            local NotifyLayout = Instance.new("Frame")
            NotifyLayout.AnchorPoint = Vector2.new(1, 0)
            NotifyLayout.BackgroundTransparency = 1
            NotifyLayout.BorderSizePixel = 0
            NotifyLayout.Position = UDim2.new(1, -10, 0, 10)
            NotifyLayout.Size = UDim2.new(0, 280, 1, -20)
            NotifyLayout.Name = "NotifyLayout"
            NotifyLayout.Parent = Crystal.CoreGui.NotifyGui

            local Count = 0
            Crystal.CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
                Count = 0
                for _, v in pairs(Crystal.CoreGui.NotifyGui.NotifyLayout:GetChildren()) do
                    if v:IsA("Frame") then
                        Crystal.TweenObject({
                            v,
                            0.3,
                            "Position",
                            UDim2.new(0, 0, 0, (v.Size.Y.Offset + 6) * Count)
                        })
                        Count = Count + 1
                    end
                end
            end)

            Crystal.CoreGui.NotifyGui.NotifyLayout.ChildAdded:Connect(function(child)
                local Count2 = 1
                for _, v in pairs(Crystal.CoreGui.NotifyGui.NotifyLayout:GetChildren()) do
                    if v ~= child and v:IsA("Frame") then
                        Crystal.TweenObject({
                            v,
                            0.3,
                            "Position",
                            UDim2.new(0, 0, 0, (v.Size.Y.Offset + 6) * Count2)
                        })
                        Count2 = Count2 + 1
                    end
                end
            end)
        end

        local hasButtons = #NotifyConfig.Buttons > 0
        local notifyHeight = hasButtons and 90 or 70

        local NotifyFrame = Instance.new("Frame")
        local NotifyFrameReal = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local DropShadowHolder = Instance.new("Frame")
        local DropShadow = Instance.new("ImageLabel")
        local NotifyLogo = Instance.new("ImageLabel")
        local UICorner1 = Instance.new("UICorner")
        local TitleFrame = Instance.new("Frame")
        local NotifyTitle = Instance.new("TextLabel")
        local Title1Label = Instance.new("TextLabel")
        local NotifyContent = Instance.new("TextLabel")
        local AlertImage = Instance.new("ImageLabel")
        local ProgressBar = Instance.new("Frame")
        local ProgressFill = Instance.new("Frame")
        local UICorner2 = Instance.new("UICorner")
        local UICorner3 = Instance.new("UICorner")
        local UIGradient = Instance.new("UIGradient")
        local UIStroke = Instance.new("UIStroke")

        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Size = UDim2.new(1, 0, 0, notifyHeight)
        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.Parent = Crystal.CoreGui.NotifyGui.NotifyLayout
        NotifyFrame.Position = UDim2.new(0, 0, 0, 0)

        NotifyFrameReal.BackgroundColor3 = Crystal.Colors.BackgroundSecondary
        NotifyFrameReal.BackgroundTransparency = 0.05
        NotifyFrameReal.BorderSizePixel = 0
        NotifyFrameReal.Position = UDim2.new(0, 300, 0, 0)
        NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
        NotifyFrameReal.Name = "NotifyFrameReal"
        NotifyFrameReal.Parent = NotifyFrame

        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = NotifyFrameReal

        UIGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Crystal.Colors.Secondary),
            ColorSequenceKeypoint.new(1, Crystal.Colors.Primary)
        }
        UIGradient.Rotation = 45
        UIGradient.Parent = NotifyFrameReal

        UIStroke.Parent = NotifyFrameReal
        UIStroke.Color = Crystal.Colors.Border
        UIStroke.Thickness = 1.5
        UIStroke.Transparency = 0.3

        DropShadowHolder.BackgroundTransparency = 1
        DropShadowHolder.BorderSizePixel = 0
        DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
        DropShadowHolder.ZIndex = 0
        DropShadowHolder.Name = "DropShadowHolder"
        DropShadowHolder.Parent = NotifyFrameReal

        DropShadow.Image = "rbxassetid://6015897843"
        DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        DropShadow.ImageTransparency = 0.4
        DropShadow.ScaleType = Enum.ScaleType.Slice
        DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadow.BackgroundTransparency = 1
        DropShadow.BorderSizePixel = 0
        DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadow.Size = UDim2.new(1, 35, 1, 35)
        DropShadow.ZIndex = 0
        DropShadow.Name = "DropShadow"
        DropShadow.Parent = DropShadowHolder

        NotifyLogo.Image = NotifyConfig.Logo
        NotifyLogo.BackgroundColor3 = Crystal.Colors.BackgroundTertiary
        NotifyLogo.BackgroundTransparency = 0.7
        NotifyLogo.BorderSizePixel = 0
        NotifyLogo.AnchorPoint = Vector2.new(0, 0.5)
        NotifyLogo.Position = UDim2.new(0, 8, 0, 26)
        NotifyLogo.Size = UDim2.new(0, 44, 0, 44)
        NotifyLogo.Name = "NotifyLogo"
        NotifyLogo.Parent = NotifyFrameReal

        UICorner1.CornerRadius = UDim.new(0, 8)
        UICorner1.Parent = NotifyLogo

        TitleFrame.BackgroundTransparency = 1
        TitleFrame.BorderSizePixel = 0
        TitleFrame.Position = UDim2.new(0, 60, 0, 8)
        TitleFrame.Size = UDim2.new(1, -110, 0, 14)
        TitleFrame.Parent = NotifyFrameReal

        NotifyTitle.Font = Enum.Font.GothamBold
        NotifyTitle.Text = NotifyConfig.Title
        NotifyTitle.TextColor3 = Crystal.Colors.Text
        NotifyTitle.TextSize = 13
        NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifyTitle.TextYAlignment = Enum.TextYAlignment.Center
        NotifyTitle.BackgroundTransparency = 1
        NotifyTitle.BorderSizePixel = 0
        NotifyTitle.Position = UDim2.new(0, 0, 0, 0)
        NotifyTitle.Size = UDim2.new(1, 0, 1, 0)
        NotifyTitle.Name = "NotifyTitle"
        NotifyTitle.Parent = TitleFrame
        NotifyTitle.TextTruncate = Enum.TextTruncate.AtEnd

        if NotifyConfig.Title1 then
            Title1Label.Font = Enum.Font.GothamBold
            Title1Label.Text = NotifyConfig.Title1
            Title1Label.TextColor3 = Crystal.Colors.Primary
            Title1Label.TextSize = 10
            Title1Label.TextXAlignment = Enum.TextXAlignment.Left
            Title1Label.TextYAlignment = Enum.TextYAlignment.Center
            Title1Label.BackgroundTransparency = 1
            Title1Label.BorderSizePixel = 0
            Title1Label.Position = UDim2.new(0, NotifyTitle.TextBounds.X + 6, 0, 0)
            Title1Label.Size = UDim2.new(0, 60, 1, 0)
            Title1Label.Parent = TitleFrame
        end

        NotifyContent.Font = Enum.Font.Gotham
        NotifyContent.Text = NotifyConfig.Content
        NotifyContent.TextColor3 = Crystal.Colors.TextSecondary
        NotifyContent.TextSize = 11
        NotifyContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifyContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifyContent.BackgroundTransparency = 1
        NotifyContent.BorderSizePixel = 0
        NotifyContent.Position = UDim2.new(0, 60, 0, 26)
        NotifyContent.Size = UDim2.new(1, -110, 0, hasButtons and 30 or 36)
        NotifyContent.Name = "NotifyContent"
        NotifyContent.Parent = NotifyFrameReal
        NotifyContent.TextWrapped = true

        local typeData = Crystal.Types[NotifyConfig.Type]
        if typeData then
            AlertImage.Image = typeData.Icon
            AlertImage.ImageColor3 = typeData.Color
        else
            AlertImage.Image = NotifyConfig.Type
            AlertImage.ImageColor3 = Crystal.Colors.Text
        end

        AlertImage.AnchorPoint = Vector2.new(1, 0)
        AlertImage.BackgroundTransparency = 1
        AlertImage.BorderSizePixel = 0
        AlertImage.Position = UDim2.new(1, -8, 0, 8)
        AlertImage.Size = UDim2.new(0, 28, 0, 28)
        AlertImage.Parent = NotifyFrameReal

        if hasButtons then
            local ButtonContainer = Instance.new("Frame")
            ButtonContainer.BackgroundTransparency = 1
            ButtonContainer.BorderSizePixel = 0
            ButtonContainer.Position = UDim2.new(0, 60, 1, -36)
            ButtonContainer.Size = UDim2.new(1, -70, 0, 30)
            ButtonContainer.Parent = NotifyFrameReal

            local YesButton = Instance.new("Frame")
            YesButton.BackgroundColor3 = Crystal.Colors.Primary
            YesButton.BackgroundTransparency = 0.1
            YesButton.BorderSizePixel = 0
            YesButton.Position = UDim2.new(0, 0, 0, 0)
            YesButton.Size = UDim2.new(0.48, 0, 1, 0)
            YesButton.Parent = ButtonContainer

            local YesCorner = Instance.new("UICorner")
            YesCorner.CornerRadius = UDim.new(0, 8)
            YesCorner.Parent = YesButton

            local YesStroke = Instance.new("UIStroke")
            YesStroke.Color = Crystal.Colors.Primary
            YesStroke.Thickness = 1.5
            YesStroke.Transparency = 0.5
            YesStroke.Parent = YesButton

            local YesGradient = Instance.new("UIGradient")
            YesGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 220, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 255))
            })
            YesGradient.Rotation = 90
            YesGradient.Parent = YesButton

            local YesIcon = Instance.new("ImageLabel")
            YesIcon.BackgroundTransparency = 1
            YesIcon.Position = UDim2.new(0, 8, 0.5, -8)
            YesIcon.Size = UDim2.new(0, 16, 0, 16)
            YesIcon.Image = "rbxassetid://11401835396"
            YesIcon.ImageColor3 = Crystal.Colors.Text
            YesIcon.Parent = YesButton

            local YesBtn = Instance.new("TextButton")
            YesBtn.BackgroundTransparency = 1
            YesBtn.Size = UDim2.new(1, 0, 1, 0)
            YesBtn.Font = Enum.Font.GothamBold
            YesBtn.Text = "Yes"
            YesBtn.TextColor3 = Crystal.Colors.Text
            YesBtn.TextSize = 12
            YesBtn.Parent = YesButton

            local NoButton = Instance.new("Frame")
            NoButton.BackgroundColor3 = Crystal.Colors.BackgroundTertiary
            NoButton.BackgroundTransparency = 0.2
            NoButton.BorderSizePixel = 0
            NoButton.Position = UDim2.new(0.52, 0, 0, 0)
            NoButton.Size = UDim2.new(0.48, 0, 1, 0)
            NoButton.Parent = ButtonContainer

            local NoCorner = Instance.new("UICorner")
            NoCorner.CornerRadius = UDim.new(0, 8)
            NoCorner.Parent = NoButton

            local NoStroke = Instance.new("UIStroke")
            NoStroke.Color = Color3.fromRGB(180, 180, 180)
            NoStroke.Thickness = 1.5
            NoStroke.Transparency = 0.7
            NoStroke.Parent = NoButton

            local NoIcon = Instance.new("ImageLabel")
            NoIcon.BackgroundTransparency = 1
            NoIcon.Position = UDim2.new(0, 8, 0.5, -8)
            NoIcon.Size = UDim2.new(0, 16, 0, 16)
            NoIcon.Image = "rbxassetid://18556800637"
            NoIcon.ImageColor3 = Crystal.Colors.TextSecondary
            NoIcon.Parent = NoButton

            local NoBtn = Instance.new("TextButton")
            NoBtn.BackgroundTransparency = 1
            NoBtn.Size = UDim2.new(1, 0, 1, 0)
            NoBtn.Font = Enum.Font.GothamBold
            NoBtn.Text = "No"
            NoBtn.TextColor3 = Crystal.Colors.TextSecondary
            NoBtn.TextSize = 12
            NoBtn.Parent = NoButton

            Crystal.Mouseto(YesButton, function()
                Crystal.TweenObject({YesButton, 0.2, "BackgroundTransparency", 0})
                Crystal.TweenObject({YesStroke, 0.2, "Transparency", 0.2})
                Crystal.TweenObject({YesIcon, 0.2, "ImageColor3", Color3.fromRGB(255, 255, 255)})
            end, function()
                Crystal.TweenObject({YesButton, 0.2, "BackgroundTransparency", 0.1})
                Crystal.TweenObject({YesStroke, 0.2, "Transparency", 0.5})
                Crystal.TweenObject({YesIcon, 0.2, "ImageColor3", Crystal.Colors.Text})
            end)

            Crystal.Mouseto(NoButton, function()
                Crystal.TweenObject({NoButton, 0.2, "BackgroundTransparency", 0.1})
                Crystal.TweenObject({NoStroke, 0.2, "Transparency", 0.5})
                Crystal.TweenObject({NoIcon, 0.2, "ImageColor3", Color3.fromRGB(255, 255, 255)})
                Crystal.TweenObject({NoBtn, 0.2, "TextColor3", Color3.fromRGB(255, 255, 255)})
            end, function()
                Crystal.TweenObject({NoButton, 0.2, "BackgroundTransparency", 0.2})
                Crystal.TweenObject({NoStroke, 0.2, "Transparency", 0.7})
                Crystal.TweenObject({NoIcon, 0.2, "ImageColor3", Crystal.Colors.TextSecondary})
                Crystal.TweenObject({NoBtn, 0.2, "TextColor3", Crystal.Colors.TextSecondary})
            end)

            YesBtn.Activated:Connect(function()
                Crystal.TweenObject({YesButton, 0.1, "Size", UDim2.new(0.46, 0, 0.9, 0)})
                task.wait(0.1)
                Crystal.TweenObject({YesButton, 0.1, "Size", UDim2.new(0.48, 0, 1, 0)})
                pcall(NotifyConfig.YesCallback)
                NotifyFunc:Close()
            end)

            NoBtn.Activated:Connect(function()
                Crystal.TweenObject({NoButton, 0.1, "Size", UDim2.new(0.46, 0, 0.9, 0)})
                task.wait(0.1)
                Crystal.TweenObject({NoButton, 0.1, "Size", UDim2.new(0.48, 0, 1, 0)})
                pcall(NotifyConfig.NoCallback)
                NotifyFunc:Close()
            end)
        end

        ProgressBar.BackgroundColor3 = Crystal.Colors.BackgroundTertiary
        ProgressBar.BorderSizePixel = 0
        ProgressBar.Position = UDim2.new(0, 8, 1, -6)
        ProgressBar.Size = UDim2.new(1, -16, 0, 3)
        ProgressBar.Parent = NotifyFrameReal

        UICorner2.CornerRadius = UDim.new(1, 0)
        UICorner2.Parent = ProgressBar

        ProgressFill.BackgroundColor3 = typeData and typeData.Color or Crystal.Colors.Primary
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Size = UDim2.new(1, 0, 1, 0)
        ProgressFill.Parent = ProgressBar

        UICorner3.CornerRadius = UDim.new(1, 0)
        UICorner3.Parent = ProgressFill

        local closed = false
        local fadeStarted = false

        local function FadeOut()
            if fadeStarted then return end
            fadeStarted = true

            Crystal.TweenObject({NotifyFrameReal, 0.4, "BackgroundTransparency", 1})
            Crystal.TweenObject({NotifyLogo, 0.4, "ImageTransparency", 1})
            Crystal.TweenObject({NotifyLogo, 0.4, "BackgroundTransparency", 1})
            Crystal.TweenObject({NotifyTitle, 0.4, "TextTransparency", 1})
            if NotifyConfig.Title1 then
                Crystal.TweenObject({Title1Label, 0.4, "TextTransparency", 1})
            end
            Crystal.TweenObject({NotifyContent, 0.4, "TextTransparency", 1})
            Crystal.TweenObject({AlertImage, 0.4, "ImageTransparency", 1})
            Crystal.TweenObject({ProgressBar, 0.4, "BackgroundTransparency", 1})
            Crystal.TweenObject({ProgressFill, 0.4, "BackgroundTransparency", 1})
            Crystal.TweenObject({DropShadow, 0.4, "ImageTransparency", 1})
        end

        function NotifyFunc:Close()
            if closed then return end
            closed = true
            FadeOut()
            Crystal.TweenObject({NotifyFrameReal, NotifyConfig.Time * 0.6, "Position", UDim2.new(0, 300, 0, 0)})
            task.wait(NotifyConfig.Time * 0.6)
            NotifyFrame:Destroy()
        end

        Crystal.TweenObject({NotifyFrameReal, NotifyConfig.Time, "Position", UDim2.new(0, 0, 0, 0)})
        
        if not hasButtons then
            Crystal.TweenObject({ProgressFill, NotifyConfig.Delay, "Size", UDim2.new(0, 0, 1, 0)})
            
            task.spawn(function()
                task.wait(NotifyConfig.Delay - 0.4)
                FadeOut()
                task.wait(0.4)
                NotifyFunc:Close()
            end)
        end
    end)

    return NotifyFunc
end

Crystal.Window = function(self, WindowConfig)
    Crystal.ShowLoading()
    
    task.wait(3)
    
    WindowConfig = WindowConfig or {}
    WindowConfig.Title = WindowConfig.Title or "Crystal Hub"
    WindowConfig.Description = WindowConfig.Description or ""
    WindowConfig.Size = WindowConfig.Size or UDim2.new(0, 500, 0, 360)
    WindowConfig.KeyCode = WindowConfig.KeyCode or Enum.KeyCode.RightControl

    local CrystalHub = {}
    CrystalHub.Window = Instance.new("ScreenGui")
    CrystalHub.MainFrame = Instance.new("Frame")
    CrystalHub.DropShadowHolder = Instance.new("Frame")
    CrystalHub.DropShadow = Instance.new("ImageLabel")
    CrystalHub.TopBar = Instance.new("Frame")
    CrystalHub.TopTitle = Instance.new("TextLabel")
    CrystalHub.TopDescription = Instance.new("TextLabel")
    CrystalHub.CloseButton = Instance.new("TextButton")
    CrystalHub.CloseImage = Instance.new("ImageLabel")
    CrystalHub.MaxButton = Instance.new("TextButton")
    CrystalHub.MaxImage = Instance.new("ImageLabel")
    CrystalHub.HideButton = Instance.new("TextButton")
    CrystalHub.HideImage = Instance.new("ImageLabel")
    CrystalHub.LayersTab = Instance.new("Frame")
    CrystalHub.ScrollTab = Instance.new("ScrollingFrame")
    CrystalHub.TabListLayout = Instance.new("UIListLayout")
    CrystalHub.MainCorner = Instance.new("UICorner")
    CrystalHub.MainStroke = Instance.new("UIStroke")
    CrystalHub.Layers = Instance.new("Frame")
    CrystalHub.LayersFolder = Instance.new("Folder")

    CrystalHub.Window.Name = "CrystalHub"
    CrystalHub.Window.Parent = Crystal.CoreGui
    CrystalHub.Window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    CrystalHub.MainFrame.Name = "MainFrame"
    CrystalHub.MainFrame.Parent = CrystalHub.Window
    CrystalHub.MainFrame.BackgroundColor3 = Crystal.Colors.Background
    CrystalHub.MainFrame.BackgroundTransparency = 0.05
    CrystalHub.MainFrame.BorderSizePixel = 0
    CrystalHub.MainFrame.Size = WindowConfig.Size
    CrystalHub.MainFrame.Position = Crystal.GetMidPos(CrystalHub.MainFrame)

    CrystalHub.MainCorner.CornerRadius = UDim.new(0, 16)
    CrystalHub.MainCorner.Parent = CrystalHub.MainFrame

    CrystalHub.MainStroke.Parent = CrystalHub.MainFrame
    CrystalHub.MainStroke.Color = Crystal.Colors.Accent
    CrystalHub.MainStroke.Thickness = 2
    CrystalHub.MainStroke.Transparency = 0.5

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Crystal.Colors.BackgroundSecondary),
        ColorSequenceKeypoint.new(1, Crystal.Colors.Background)
    })
    MainGradient.Rotation = 135
    MainGradient.Parent = CrystalHub.MainFrame

    CrystalHub.DropShadowHolder.Name = "DropShadowHolder"
    CrystalHub.DropShadowHolder.Parent = CrystalHub.MainFrame
    CrystalHub.DropShadowHolder.BackgroundTransparency = 1
    CrystalHub.DropShadowHolder.BorderSizePixel = 0
    CrystalHub.DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
    CrystalHub.DropShadowHolder.ZIndex = 0

    CrystalHub.DropShadow.Name = "DropShadow"
    CrystalHub.DropShadow.Parent = CrystalHub.DropShadowHolder
    CrystalHub.DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    CrystalHub.DropShadow.BackgroundTransparency = 1
    CrystalHub.DropShadow.BorderSizePixel = 0
    CrystalHub.DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    CrystalHub.DropShadow.Size = UDim2.new(1, 50, 1, 50)
    CrystalHub.DropShadow.ZIndex = 0
    CrystalHub.DropShadow.Image = "rbxassetid://6015897843"
    CrystalHub.DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    CrystalHub.DropShadow.ImageTransparency = 0.2
    CrystalHub.DropShadow.ScaleType = Enum.ScaleType.Slice
    CrystalHub.DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    CrystalHub.TopBar.Name = "TopBar"
    CrystalHub.TopBar.Parent = CrystalHub.MainFrame
    CrystalHub.TopBar.BackgroundTransparency = 1
    CrystalHub.TopBar.BorderSizePixel = 0
    CrystalHub.TopBar.Size = UDim2.new(1, 0, 0, 50)
    CrystalHub.TopBar.ZIndex = 2

    CrystalHub.TopTitle.Name = "TopTitle"
    CrystalHub.TopTitle.Parent = CrystalHub.TopBar
    CrystalHub.TopTitle.BackgroundTransparency = 1
    CrystalHub.TopTitle.Position = UDim2.new(0, 20, 0, 14)
    CrystalHub.TopTitle.Size = UDim2.new(0, 200, 0, 20)
    CrystalHub.TopTitle.Font = Enum.Font.GothamBold
    CrystalHub.TopTitle.Text = WindowConfig.Title
    CrystalHub.TopTitle.TextColor3 = Crystal.Colors.Text
    CrystalHub.TopTitle.TextSize = 16
    CrystalHub.TopTitle.TextXAlignment = Enum.TextXAlignment.Left

    CrystalHub.TopDescription.Name = "TopDescription"
    CrystalHub.TopDescription.Parent = CrystalHub.TopBar
    CrystalHub.TopDescription.BackgroundTransparency = 1
    CrystalHub.TopDescription.Position = UDim2.new(0, CrystalHub.TopTitle.TextBounds.X + 26, 0, 14)
    CrystalHub.TopDescription.Size = UDim2.new(0, 100, 0, 20)
    CrystalHub.TopDescription.Font = Enum.Font.GothamBold
    CrystalHub.TopDescription.Text = WindowConfig.Description
    CrystalHub.TopDescription.TextColor3 = Crystal.Colors.Primary
    CrystalHub.TopDescription.TextSize = 13
    CrystalHub.TopDescription.TextTransparency = 0.2
    CrystalHub.TopDescription.TextXAlignment = Enum.TextXAlignment.Left

    CrystalHub.CloseButton.Name = "CloseButton"
    CrystalHub.CloseButton.Parent = CrystalHub.TopBar
    CrystalHub.CloseButton.AnchorPoint = Vector2.new(1, 0)
    CrystalHub.CloseButton.BackgroundTransparency = 1
    CrystalHub.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CrystalHub.CloseButton.Position = UDim2.new(1, -10, 0, 10)
    CrystalHub.CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CrystalHub.CloseButton.Font = Enum.Font.GothamBold
    CrystalHub.CloseButton.AutoButtonColor = false
    CrystalHub.CloseButton.Text = ""

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CrystalHub.CloseButton

    Crystal.Mouseto(CrystalHub.CloseButton, function()
        Crystal.TweenObject({CrystalHub.CloseButton, 0.2, "BackgroundTransparency", 0.9})
        Crystal.TweenObject({CrystalHub.CloseImage, 0.2, "ImageColor3", Color3.fromRGB(255, 100, 100)})
    end, function()
        Crystal.TweenObject({CrystalHub.CloseButton, 0.2, "BackgroundTransparency", 1})
        Crystal.TweenObject({CrystalHub.CloseImage, 0.2, "ImageColor3", Crystal.Colors.TextSecondary})
    end)

    Crystal.Click(CrystalHub.CloseButton, function()
        CrystalHub.MainFrame.Visible = false
    end)

    CrystalHub.CloseImage.Name = "CloseImage"
    CrystalHub.CloseImage.Parent = CrystalHub.CloseButton
    CrystalHub.CloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
    CrystalHub.CloseImage.BackgroundTransparency = 1
    CrystalHub.CloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    CrystalHub.CloseImage.Size = UDim2.new(0, 18, 0, 18)
    CrystalHub.CloseImage.Image = "rbxassetid://18556800637"
    CrystalHub.CloseImage.ImageColor3 = Crystal.Colors.TextSecondary

    CrystalHub.MaxButton.Name = "MaxButton"
    CrystalHub.MaxButton.Parent = CrystalHub.TopBar
    CrystalHub.MaxButton.AutoButtonColor = false
    CrystalHub.MaxButton.AnchorPoint = Vector2.new(1, 0)
    CrystalHub.MaxButton.BackgroundTransparency = 1
    CrystalHub.MaxButton.Position = UDim2.new(1, -55, 0, 10)
    CrystalHub.MaxButton.Size = UDim2.new(0, 40, 0, 40)
    CrystalHub.MaxButton.Font = Enum.Font.GothamBold
    CrystalHub.MaxButton.Text = ""

    local MaxCorner = Instance.new("UICorner")
    MaxCorner.CornerRadius = UDim.new(0, 10)
    MaxCorner.Parent = CrystalHub.MaxButton

    local OldPos, OldSize
    Crystal.Click(CrystalHub.MaxButton, function()
        if CrystalHub.MainFrame.Size.Y.Scale < 1 then
            OldPos = CrystalHub.MainFrame.Position
            OldSize = CrystalHub.MainFrame.Size
            Crystal.TweenObject({CrystalHub.MainFrame, 0.5, "Size", UDim2.new(1, 0, 1, 0)})
            Crystal.TweenObject({CrystalHub.MainFrame, 0.5, "Position", UDim2.new(0, 0, 0, 0)})
        else
            Crystal.TweenObject({CrystalHub.MainFrame, 0.5, "Size", OldSize})
            Crystal.TweenObject({CrystalHub.MainFrame, 0.5, "Position", OldPos})
        end
    end)

    Crystal.Mouseto(CrystalHub.MaxButton, function()
        CrystalHub.MaxButton.BackgroundTransparency = 0.9
        Crystal.TweenObject({CrystalHub.MaxImage, 0.2, "ImageColor3", Crystal.Colors.Text})
    end, function()
        CrystalHub.MaxButton.BackgroundTransparency = 1
        Crystal.TweenObject({CrystalHub.MaxImage, 0.2, "ImageColor3", Crystal.Colors.TextSecondary})
    end)

    CrystalHub.MaxImage.Name = "MaxImage"
    CrystalHub.MaxImage.Parent = CrystalHub.MaxButton
    CrystalHub.MaxImage.AnchorPoint = Vector2.new(0.5, 0.5)
    CrystalHub.MaxImage.BackgroundTransparency = 1
    CrystalHub.MaxImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    CrystalHub.MaxImage.Size = UDim2.new(0, 18, 0, 18)
    CrystalHub.MaxImage.Image = "rbxassetid://9886659406"
    CrystalHub.MaxImage.ImageColor3 = Crystal.Colors.TextSecondary

    CrystalHub.HideButton.Name = "HideButton"
    CrystalHub.HideButton.Parent = CrystalHub.TopBar
    CrystalHub.HideButton.AutoButtonColor = false
    CrystalHub.HideButton.AnchorPoint = Vector2.new(1, 0)
    CrystalHub.HideButton.BackgroundTransparency = 1
    CrystalHub.HideButton.Position = UDim2.new(1, -100, 0, 10)
    CrystalHub.HideButton.Size = UDim2.new(0, 40, 0, 40)
    CrystalHub.HideButton.Font = Enum.Font.GothamBold
    CrystalHub.HideButton.Text = ""

    local HideCorner = Instance.new("UICorner")
    HideCorner.CornerRadius = UDim.new(0, 10)
    HideCorner.Parent = CrystalHub.HideButton

    Crystal.Mouseto(CrystalHub.HideButton, function()
        CrystalHub.HideButton.BackgroundTransparency = 0.9
        Crystal.TweenObject({CrystalHub.HideImage, 0.2, "ImageColor3", Crystal.Colors.Text})
    end, function()
        CrystalHub.HideButton.BackgroundTransparency = 1
        Crystal.TweenObject({CrystalHub.HideImage, 0.2, "ImageColor3", Crystal.Colors.TextSecondary})
    end)

    Crystal.Click(CrystalHub.HideButton, function()
        CrystalHub.MainFrame.Visible = false
    end)

    CrystalHub.HideImage.Name = "HideImage"
    CrystalHub.HideImage.Parent = CrystalHub.HideButton
    CrystalHub.HideImage.AnchorPoint = Vector2.new(0.5, 0.5)
    CrystalHub.HideImage.BackgroundTransparency = 1
    CrystalHub.HideImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    CrystalHub.HideImage.Size = UDim2.new(0, 18, 0, 18)
    CrystalHub.HideImage.Image = "rbxassetid://18556824827"
    CrystalHub.HideImage.ImageColor3 = Crystal.Colors.TextSecondary

    CrystalHub.LayersTab.Name = "LayersTab"
    CrystalHub.LayersTab.Parent = CrystalHub.MainFrame
    CrystalHub.LayersTab.BackgroundTransparency = 1
    CrystalHub.LayersTab.BorderSizePixel = 0
    CrystalHub.LayersTab.Position = UDim2.new(0, 15, 0, 60)
    CrystalHub.LayersTab.Size = UDim2.new(0, 160, 1, -75)

    CrystalHub.ScrollTab.Name = "ScrollTab"
    CrystalHub.ScrollTab.Parent = CrystalHub.LayersTab
    CrystalHub.ScrollTab.Active = true
    CrystalHub.ScrollTab.BackgroundTransparency = 1
    CrystalHub.ScrollTab.BorderSizePixel = 0
    CrystalHub.ScrollTab.Size = UDim2.new(1, 0, 1, 0)
    CrystalHub.ScrollTab.ZIndex = 0
    CrystalHub.ScrollTab.ScrollBarImageColor3 = Crystal.Colors.Accent
    CrystalHub.ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    CrystalHub.ScrollTab.ScrollBarImageTransparency = 0.6
    CrystalHub.ScrollTab.ScrollBarThickness = 4

    Crystal.Stepped:Connect(function()
        CrystalHub.ScrollTab.CanvasSize = UDim2.new(0, 0, 0, CrystalHub.TabListLayout.AbsoluteContentSize.Y + 10)
    end)

    CrystalHub.TabListLayout.Parent = CrystalHub.ScrollTab
    CrystalHub.TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CrystalHub.TabListLayout.Padding = UDim.new(0, 4)

    CrystalHub.Layers.Name = "Layers"
    CrystalHub.Layers.Parent = CrystalHub.MainFrame
    CrystalHub.Layers.BackgroundTransparency = 1
    CrystalHub.Layers.BorderSizePixel = 0
    CrystalHub.Layers.Position = UDim2.new(0, 185, 0, 60)
    CrystalHub.Layers.Size = UDim2.new(1, -200, 1, -75)
    CrystalHub.Layers.ZIndex = 3

    CrystalHub.LayersFolder.Name = "LayersFolder"
    CrystalHub.LayersFolder.Parent = CrystalHub.Layers

    local LayersPageLayout = Instance.new("UIPageLayout")
    LayersPageLayout.Name = "LayersPageLayout"
    LayersPageLayout.Parent = CrystalHub.LayersFolder
    LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
    LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad
    LayersPageLayout.GamepadInputEnabled = false
    LayersPageLayout.ScrollWheelInputEnabled = false
    LayersPageLayout.TouchInputEnabled = false
    LayersPageLayout.TweenTime = 0.4

    Crystal.MakeDraggable(CrystalHub.MainFrame, CrystalHub.TopBar)
    Crystal.CustomSize(CrystalHub.MainFrame)

    Crystal.UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == WindowConfig.KeyCode then
            CrystalHub.MainFrame.Visible = not CrystalHub.MainFrame.Visible
        end
    end)

    local TabSystem = {}
    local TabCount = 0

    function TabSystem:AddTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Title = TabConfig.Title or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""

        local Tab = Instance.new("Frame")
        local TabCorner = Instance.new("UICorner")
        local TabImage = Instance.new("ImageLabel")
        local TabButton = Instance.new("TextButton")
        local TabName = Instance.new("TextLabel")
        local ScrollLayers = Instance.new("ScrollingFrame")
        local ScrollLayersLayout = Instance.new("UIListLayout")

        Tab.Name = "Tab"
        Tab.Parent = CrystalHub.ScrollTab
        Tab.BackgroundColor3 = Crystal.Colors.BackgroundSecondary
        Tab.BackgroundTransparency = 1
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(1, 0, 0, 44)

        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = Tab

        TabImage.Name = "TabImage"
        TabImage.Parent = Tab
        TabImage.AnchorPoint = Vector2.new(0, 0.5)
        TabImage.BackgroundTransparency = 1
        TabImage.Position = UDim2.new(0, 12, 0.5, 0)
        TabImage.Size = UDim2.new(0, 20, 0, 20)
        TabImage.Image = TabConfig.Icon
        TabImage.ImageTransparency = 0.5
        TabImage.ImageColor3 = Crystal.Colors.TextSecondary

        TabButton.Name = "TabButton"
        TabButton.Parent = Tab
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Text = ""
        TabButton.Font = Enum.Font.GothamBold

        TabName.Name = "TabName"
        TabName.Parent = Tab
        TabName.AnchorPoint = Vector2.new(0, 0.5)
        TabName.BackgroundTransparency = 1
        TabName.Position = UDim2.new(0, 40, 0.5, 0)
        TabName.Size = UDim2.new(1, -48, 0, 16)
        TabName.Font = Enum.Font.GothamBold
        TabName.Text = TabConfig.Title
        TabName.TextColor3 = Crystal.Colors.TextSecondary
        TabName.TextSize = 13
        TabName.TextTransparency = 0.5
        TabName.TextXAlignment = Enum.TextXAlignment.Left

        ScrollLayers.Name = "ScrollLayers"
        ScrollLayers.Parent = CrystalHub.LayersFolder
        ScrollLayers.Active = true
        ScrollLayers.BackgroundTransparency = 1
        ScrollLayers.BorderSizePixel = 0
        ScrollLayers.Size = UDim2.new(1, 0, 1, 0)
        ScrollLayers.ScrollBarImageColor3 = Crystal.Colors.Accent
        ScrollLayers.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollLayers.ScrollBarImageTransparency = 0.6
        ScrollLayers.ScrollBarThickness = 4
        ScrollLayers.LayoutOrder = TabCount

        Crystal.Stepped:Connect(function()
            ScrollLayers.CanvasSize = UDim2.new(0, 0, 0, ScrollLayersLayout.AbsoluteContentSize.Y + 15)
        end)

        ScrollLayersLayout.Parent = ScrollLayers
        ScrollLayersLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollLayersLayout.Padding = UDim.new(0, 8)

        if TabCount == 0 then
            local IndicatorFrame = Instance.new("Frame")
            local IndicatorCorner = Instance.new("UICorner")

            IndicatorFrame.Name = "IndicatorFrame"
            IndicatorFrame.Parent = Tab
            IndicatorFrame.BackgroundColor3 = Crystal.Colors.Primary
            IndicatorFrame.BorderSizePixel = 0
            IndicatorFrame.Position = UDim2.new(0, 0, 0, 12)
            IndicatorFrame.Size = UDim2.new(0, 4, 0, 20)

            IndicatorCorner.CornerRadius = UDim.new(0, 2)
            IndicatorCorner.Parent = IndicatorFrame

            LayersPageLayout:JumpToIndex(0)
            TabImage.ImageTransparency = 0
            Tab.BackgroundTransparency = 0.9
            TabName.TextTransparency = 0
        end

        Crystal.Mouseto(Tab, function()
            if Tab.BackgroundTransparency >= 0.99 then
                Crystal.TweenObject({Tab, 0.2, "BackgroundTransparency", 0.95})
            end
        end, function()
            if Tab.BackgroundTransparency >= 0.9 then
                Crystal.TweenObject({Tab, 0.2, "BackgroundTransparency", 1})
            end
        end)

        TabButton.Activated:Connect(function()
            local CurrentIndicator
            for _, v in next, Tab.Parent:GetChildren() do
                for _, frame in next, v:GetChildren() do
                    if frame.Name == "IndicatorFrame" then
                        CurrentIndicator = frame
                        break
                    end
                end
            end

            if CurrentIndicator and LayersPageLayout.CurrentPage ~= ScrollLayers then
                for _, v in next, Tab.Parent:GetChildren() do
                    if v.ClassName ~= "UIListLayout" then
                        Crystal.TweenObject({v, 0.3, "BackgroundTransparency", 1})
                        Crystal.TweenObject({v.TabImage, 0.3, "ImageTransparency", 0.5})
                        Crystal.TweenObject({v.TabName, 0.3, "TextTransparency", 0.5})
                    end
                end
                
                Crystal.TweenObject({Tab, 0.3, "BackgroundTransparency", 0.9})
                Crystal.TweenObject({TabImage, 0.3, "ImageTransparency", 0})
                Crystal.TweenObject({TabName, 0.3, "TextTransparency", 0})
                Crystal.TweenObject({CurrentIndicator, 0.3, "Position", UDim2.new(0, 0, 0, 12 + (48 * ScrollLayers.LayoutOrder))})
                
                LayersPageLayout:JumpToIndex(ScrollLayers.LayoutOrder)
            end
        end)

        TabCount = TabCount + 1
        return {ScrollLayers = ScrollLayers}
    end

    return TabSystem
end

return Crystal