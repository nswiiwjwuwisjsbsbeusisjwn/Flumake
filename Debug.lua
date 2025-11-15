local a = {}
a.TweenService = game:GetService("TweenService")
a.Player = game.Players.LocalPlayer
a.CoreGui = game:GetService("CoreGui")
a.RunService = game:GetService("RunService")
a.Colors = {
    Primary = Color3.fromRGB(255, 215, 0)
}

if a.CoreGui:FindFirstChild('CrystalDebugGui') then
    a.CoreGui:FindFirstChild('CrystalDebugGui'):Destroy()
end

a.TweenObject = function(b)
    local c = TweenInfo.new(b["Time"] or 0.3, Enum.EasingStyle.Quint)
    local d = a.TweenService:Create(b["Object"], c, {[b["OldValue"]] = b["NewValue"]})
    d:Play()
    return d
end

a.Paragraph = function(b)
    local c = Instance.new("Frame")
    local d = Instance.new("ImageLabel")
    local e = Instance.new("TextLabel")
    local f = Instance.new("TextLabel")
    
    c.Name = b["Title"] or "Paragraph"
    c.Parent = b["Parent"]
    c.BackgroundTransparency = 1
    c.Position = b["Position"] or UDim2.new(0, 0, 0, 0)
    c.Size = b["Size"] or UDim2.new(1, 0, 0, 35)
    c.AutomaticSize = Enum.AutomaticSize.Y
    
    if b["IconLabel"] and b["IconLabel"] ~= "" then
        d.Name = "Icon"
        d.Parent = c
        d.BackgroundTransparency = 1
        d.Position = UDim2.new(0, 5, 0.5, -(tonumber(b["SizeIcon"]) or 15) / 2)
        d.Size = UDim2.new(0, tonumber(b["SizeIcon"]) or 15, 0, tonumber(b["SizeIcon"]) or 15)
        d.Image = b["IconLabel"]
        d.ScaleType = Enum.ScaleType.Fit
    end
    
    local g = (b["IconLabel"] and b["IconLabel"] ~= "") and (tonumber(b["SizeIcon"]) or 15) + 15 or 5
    
    e.Name = "Title"
    e.Parent = c
    e.BackgroundTransparency = 1
    e.Position = UDim2.new(0, g, 0, 0)
    e.Size = UDim2.new(0, 80, 1, 0)
    e.Font = b["TitleFont"] or Enum.Font.GothamBold
    e.Text = b["Content"] or ""
    e.TextColor3 = b["TitleColor"] or Color3.fromRGB(200, 200, 200)
    e.TextSize = b["TitleSize"] or 16
    e.TextXAlignment = Enum.TextXAlignment.Left
    e.TextYAlignment = Enum.TextYAlignment.Center
    e.TextWrapped = true
    e.TextScaled = false
    
    f.Name = "Value"
    f.Parent = c
    f.BackgroundTransparency = 1
    f.Position = UDim2.new(0, g + 80, 0, 0)
    f.Size = UDim2.new(1, -(g + 85), 1, 0)
    f.Font = b["ValueFont"] or Enum.Font.Arcade
    f.Text = b["Value"] or "0"
    f.TextColor3 = b["ValueColor"] or Color3.fromRGB(100, 220, 255)
    f.TextSize = b["ValueSize"] or 20
    f.TextXAlignment = Enum.TextXAlignment.Right
    f.TextYAlignment = Enum.TextYAlignment.Top
    f.TextWrapped = true
    f.TextScaled = false
    f.AutomaticSize = Enum.AutomaticSize.Y
    
    local h = Instance.new("UISizeConstraint")
    h.Parent = f
    h.MinSize = Vector2.new(0, 35)
    
    f:GetPropertyChangedSignal("TextBounds"):Connect(function()
        local i = f.TextBounds.Y
        if i > 35 then
            c.Size = UDim2.new(1, 0, 0, i + 10)
        end
    end)
    
    return {["Frame"] = c, ["Icon"] = d, ["Title"] = e, ["Value"] = f}
end

a.Divider = function(b)
    local c = Instance.new("Frame")
    local d = Instance.new("Frame")
    local e = Instance.new("UICorner")
    local f = Instance.new("Frame")
    local g = Instance.new("UICorner")
    local h = Instance.new("TextLabel")
    
    c.Name = b["Title"] or "Divider"
    c.Parent = b["Parent"]
    c.BackgroundTransparency = 1
    c.Position = b["Position"] or UDim2.new(0, 0, 0, 0)
    c.Size = b["Size"] or UDim2.new(1, 0, 0, 30)
    
    d.Name = "LineLeft"
    d.Parent = c
    d.BackgroundColor3 = b["LineColor"] or Color3.fromRGB(255, 215, 0)
    d.BackgroundTransparency = b["LineTransparency"] or 0.5
    d.BorderSizePixel = 0
    d.Position = UDim2.new(0, 5, 0.5, -1)
    d.Size = UDim2.new(0, 0, 0, 2)
    
    e.CornerRadius = UDim.new(1, 0)
    e.Parent = d
    
    h.Name = "Label"
    h.Parent = c
    h.BackgroundTransparency = 1
    h.Position = UDim2.new(0, 10, 0, 0)
    h.Size = UDim2.new(1, -20, 1, 0)
    h.Font = b["Font"] or Enum.Font.GothamBold
    h.Text = b["Text"] or "Section"
    h.TextColor3 = b["TextColor"] or Color3.fromRGB(255, 215, 0)
    h.TextSize = b["TextSize"] or 14
    h.TextXAlignment = Enum.TextXAlignment.Center
    h.TextYAlignment = Enum.TextYAlignment.Center
    h.TextTransparency = b["TextTransparency"] or 0.3
    
    task.wait()
    
    local i = h.TextBounds.X
    d.Size = UDim2.new(0.5, -(i/2) - 15, 0, 2)
    
    f.Name = "LineRight"
    f.Parent = c
    f.BackgroundColor3 = b["LineColor"] or Color3.fromRGB(255, 215, 0)
    f.BackgroundTransparency = b["LineTransparency"] or 0.5
    f.BorderSizePixel = 0
    f.Position = UDim2.new(0.5, (i/2) + 10, 0.5, -1)
    f.Size = UDim2.new(0.5, -(i/2) - 15, 0, 2)
    
    g.CornerRadius = UDim.new(1, 0)
    g.Parent = f
    
    return {["Frame"] = c, ["LineLeft"] = d, ["LineRight"] = f, ["Label"] = h}
end

a.CreateDebugGui = function()
    local b = {}
    
    b.ScreenGui = Instance.new("ScreenGui")
    b.DropShadowHolder = Instance.new("Frame")
    b.DropShadow = Instance.new("ImageLabel")
    b.MainFrame = Instance.new("Frame")
    b.UICorner = Instance.new("UICorner")
    b.UIStroke = Instance.new("UIStroke")
    b.UIGradient = Instance.new("UIGradient")
    b.TopBar = Instance.new("Frame")
    b.TopTitle = Instance.new("TextLabel")
    b.TopDescription = Instance.new("TextLabel")
    b.Divider = Instance.new("Frame")
    b.DividerCorner = Instance.new("UICorner")
    b.ScrollFrame = Instance.new("ScrollingFrame")
    b.UIListLayout = Instance.new("UIListLayout")
    b.ResizeHandle = Instance.new("Frame")

    b.ScreenGui.Name = "CrystalDebugGui"
    b.ScreenGui.Parent = a.CoreGui
    b.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    b.ScreenGui.ResetOnSpawn = false

    b.DropShadowHolder.Name = "DropShadowHolder"
    b.DropShadowHolder.Parent = b.ScreenGui
    b.DropShadowHolder.BackgroundTransparency = 1
    b.DropShadowHolder.BorderSizePixel = 0
    b.DropShadowHolder.Position = UDim2.new(0, 20, 0, 100)
    b.DropShadowHolder.Size = UDim2.new(0, 280, 0, 220)

    b.DropShadow.Name = "DropShadow"
    b.DropShadow.Parent = b.DropShadowHolder
    b.DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    b.DropShadow.BackgroundTransparency = 1
    b.DropShadow.BorderSizePixel = 0
    b.DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    b.DropShadow.Size = UDim2.new(1, 47, 1, 47)
    b.DropShadow.ZIndex = 0
    b.DropShadow.Image = "rbxassetid://6015897843"
    b.DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    b.DropShadow.ImageTransparency = 0.5
    b.DropShadow.ScaleType = Enum.ScaleType.Slice
    b.DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    b.MainFrame.Name = "MainFrame"
    b.MainFrame.Parent = b.DropShadowHolder
    b.MainFrame.AnchorPoint = Vector2.new(0, 0)
    b.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
    b.MainFrame.BackgroundTransparency = 0.1
    b.MainFrame.BorderSizePixel = 0
    b.MainFrame.Position = UDim2.new(0, 0, 0, 0)
    b.MainFrame.Size = UDim2.new(1, 0, 1, 0)

    b.UICorner.CornerRadius = UDim.new(0, 12)
    b.UICorner.Parent = b.MainFrame

    b.UIStroke.Parent = b.MainFrame
    b.UIStroke.Color = Color3.fromRGB(255, 215, 0)
    b.UIStroke.Thickness = 2
    b.UIStroke.Transparency = 0.3

    b.UIGradient.Parent = b.MainFrame
    b.UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 0))
    }
    b.UIGradient.Rotation = 135

    b.TopBar.Name = "TopBar"
    b.TopBar.Parent = b.MainFrame
    b.TopBar.BackgroundTransparency = 1
    b.TopBar.Position = UDim2.new(0, 0, 0, 0)
    b.TopBar.Size = UDim2.new(1, 0, 0, 50)
    b.TopBar.ZIndex = 2

    b.TopTitle.Name = "TopTitle"
    b.TopTitle.Parent = b.TopBar
    b.TopTitle.BackgroundTransparency = 1
    b.TopTitle.Position = UDim2.new(0, 20, 0, 0)
    b.TopTitle.Size = UDim2.new(0, 200, 1, 0)
    b.TopTitle.Font = Enum.Font.Arcade
    b.TopTitle.Text = "Debug"
    b.TopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TopTitle.TextSize = 18
    b.TopTitle.TextXAlignment = Enum.TextXAlignment.Left
    b.TopTitle.TextYAlignment = Enum.TextYAlignment.Center

    task.wait()
    
    b.TopDescription.Name = "TopDescription"
    b.TopDescription.Parent = b.TopBar
    b.TopDescription.BackgroundTransparency = 1
    b.TopDescription.Position = UDim2.new(0, b.TopTitle.TextBounds.X + 26, 0, 0)
    b.TopDescription.Size = UDim2.new(0, 100, 1, 0)
    b.TopDescription.Font = Enum.Font.GothamBold
    b.TopDescription.Text = "Gold Hub"
    b.TopDescription.TextColor3 = a.Colors.Primary
    b.TopDescription.TextSize = 13
    b.TopDescription.TextTransparency = 0.2
    b.TopDescription.TextXAlignment = Enum.TextXAlignment.Left
    b.TopDescription.TextYAlignment = Enum.TextYAlignment.Center

    b.Divider.Name = "Divider"
    b.Divider.Parent = b.MainFrame
    b.Divider.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    b.Divider.BackgroundTransparency = 0.5
    b.Divider.BorderSizePixel = 0
    b.Divider.Position = UDim2.new(0, 20, 0, 48)
    b.Divider.Size = UDim2.new(1, -40, 0, 2)
    b.Divider.ZIndex = 2

    b.DividerCorner.CornerRadius = UDim.new(1, 0)
    b.DividerCorner.Parent = b.Divider

    b.ScrollFrame.Name = "ScrollFrame"
    b.ScrollFrame.Parent = b.MainFrame
    b.ScrollFrame.Active = true
    b.ScrollFrame.BackgroundTransparency = 1
    b.ScrollFrame.BorderSizePixel = 0
    b.ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
    b.ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
    b.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    b.ScrollFrame.ScrollBarThickness = 4
    b.ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
    b.ScrollFrame.ScrollBarImageTransparency = 0.3
    b.ScrollFrame.ClipsDescendants = true

    b.UIListLayout.Parent = b.ScrollFrame
    b.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    b.UIListLayout.Padding = UDim.new(0, 5)

    b.ResizeHandle.Name = "ResizeHandle"
    b.ResizeHandle.Parent = b.MainFrame
    b.ResizeHandle.AnchorPoint = Vector2.new(1, 1)
    b.ResizeHandle.BackgroundTransparency = 1
    b.ResizeHandle.Position = UDim2.new(1, 0, 1, 0)
    b.ResizeHandle.Size = UDim2.new(0, 30, 0, 30)
    b.ResizeHandle.ZIndex = 3

    b.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        b.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, b.UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    local c = false
    local d, e, f

    b.TopBar.InputBegan:Connect(function(g)
        if g.UserInputType == Enum.UserInputType.MouseButton1 or g.UserInputType == Enum.UserInputType.Touch then
            c = true
            e = g.Position
            f = b.DropShadowHolder.Position
            
            g.Changed:Connect(function()
                if g.UserInputState == Enum.UserInputState.End then
                    c = false
                end
            end)
        end
    end)

    b.TopBar.InputChanged:Connect(function(g)
        if g.UserInputType == Enum.UserInputType.MouseMovement or g.UserInputType == Enum.UserInputType.Touch then
            d = g
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(g)
        if g == d and c then
            local h = g.Position - e
            b.DropShadowHolder.Position = UDim2.new(
                f.X.Scale,
                f.X.Offset + h.X,
                f.Y.Scale,
                f.Y.Offset + h.Y
            )
        end
    end)

    local i = false
    local j, k

    b.ResizeHandle.InputBegan:Connect(function(l)
        if l.UserInputType == Enum.UserInputType.MouseButton1 or l.UserInputType == Enum.UserInputType.Touch then
            i = true
            j = l.Position
            k = b.DropShadowHolder.Size
            
            l.Changed:Connect(function()
                if l.UserInputState == Enum.UserInputState.End then
                    i = false
                end
            end)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(l)
        if i and (l.UserInputType == Enum.UserInputType.MouseMovement or l.UserInputType == Enum.UserInputType.Touch) then
            local m = l.Position - j
            local n = math.max(200, k.X.Offset + m.X)
            local o = math.max(150, k.Y.Offset + m.Y)
            b.DropShadowHolder.Size = UDim2.new(0, n, 0, o)
        end
    end)

    a.TweenObject({
        ["Object"] = b.MainFrame,
        ["Time"] = 0.5,
        ["OldValue"] = "BackgroundTransparency",
        ["NewValue"] = 0.1
    })

    return b.ScreenGui, b.ScrollFrame
end

local p = {}
p.Gui, p.Container = a.CreateDebugGui()
p.Paragraph = a.Paragraph
p.Divider = a.Divider

return p
