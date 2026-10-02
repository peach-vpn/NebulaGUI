--//======================================================
--// AD GUI
--// Aimbot / Spinbot / BunnyHop / WalkSpeed / AutoWalk
--//======================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--======================================================
--// УДАЛЕНИЕ СТАРОЙ ВЕРСИИ
--//======================================================

local OldGui = PlayerGui:FindFirstChild("AD_GUI")
if OldGui then
    OldGui:Destroy()
end

--======================================================
--// НАСТРОЙКИ
--//======================================================

local Settings = {
    Aimbot = false,
    FOV = 180,
    Smoothness = 0.18,
    TeamCheck = true,
    WallCheck = true,

    Spinbot = false,
    SpinSpeed = 8,

    AutoJump = false,

    WalkSpeed = false,
    WalkSpeedValue = 28,

    AutoWalk = false
}

--======================================================
--// GUI
--//======================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AD_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

--======================================================
--// КНОПКА AD
--//======================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "AD"
OpenButton.Size = UDim2.fromOffset(58, 58)
OpenButton.Position = UDim2.new(0, 18, 0.5, -29)
OpenButton.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
OpenButton.Text = "AD"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 18
OpenButton.Font = Enum.Font.GothamBold
OpenButton.AutoButtonColor = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(125, 75, 255)
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

--======================================================
--// ГЛАВНОЕ ОКНО
--======================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(390, 430)
Main.Position = UDim2.new(0.5, -195, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 21)
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 50, 65)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--======================================================
--// HEADER
--======================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -75, 1, 0)
Title.Position = UDim2.fromOffset(16, 0)
Title.BackgroundTransparency = 1
Title.Text = "AD  •  Панель"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38, 38)
Close.Position = UDim2.new(1, -48, 0, 7)
Close.BackgroundColor3 = Color3.fromRGB(30, 30, 39)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(230, 230, 235)
Close.TextSize = 25
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = Close

--======================================================
--// SCROLL
--======================================================

local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "Content"
Scroll.Size = UDim2.new(1, -20, 1, -62)
Scroll.Position = UDim2.fromOffset(10, 55)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageTransparency = 0.4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 4)
Padding.PaddingRight = UDim.new(0, 4)
Padding.PaddingBottom = UDim.new(0, 12)
Padding.Parent = Scroll

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

--======================================================
--// СЕКЦИЯ
--======================================================

local function Section(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 28)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(160, 130, 255)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Scroll

    return Label
end

--======================================================
--// TOGGLE
--======================================================

local function Toggle(text, default, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 44)
    Button.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.fromOffset(13, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.fromOffset(40, 22)
    Switch.Position = UDim2.new(1, -53, 0.5, -11)
    Switch.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    Switch.Parent = Button

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(18, 18)
    Dot.Position = UDim2.fromOffset(2, 2)
    Dot.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
    Dot.Parent = Switch

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local Value = default

    local function Update()
        if Value then
            TweenService:Create(
                Switch,
                TweenInfo.new(0.12),
                {BackgroundColor3 = Color3.fromRGB(120, 70, 255)}
            ):Play()

            TweenService:Create(
                Dot,
                TweenInfo.new(0.12),
                {Position = UDim2.fromOffset(20, 2)}
            ):Play()
        else
            TweenService:Create(
                Switch,
                TweenInfo.new(0.12),
                {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}
            ):Play()

            TweenService:Create(
                Dot,
                TweenInfo.new(0.12),
                {Position = UDim2.fromOffset(2, 2)}
            ):Play()
        end
    end

    Button.MouseButton1Click:Connect(function()
        Value = not Value
        Update()

        if callback then
            callback(Value)
        end
    end)

    Update()

    return Button
end

--======================================================
--// ЧИСЛОВОЕ ПОЛЕ
--======================================================

local function NumberBox(text, value, minValue, maxValue, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 44)
    Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    Frame.Parent = Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -115, 1, 0)
    Label.Position = UDim2.fromOffset(13, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.fromOffset(88, 30)
    Box.Position = UDim2.new(1, -98, 0.5, -15)
    Box.BackgroundColor3 = Color3.fromRGB(33, 33, 43)
    Box.Text = tostring(value)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 13
    Box.Font = Enum.Font.GothamMedium
    Box.ClearTextOnFocus = false
    Box.Parent = Frame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = Box

    Box.FocusLost:Connect(function()
        local num = tonumber(Box.Text)

        if not num then
            Box.Text = tostring(value)
            return
        end

        num = math.clamp(num, minValue, maxValue)
        value = num
        Box.Text = tostring(num)

        if callback then
            callback(num)
        end
    end)

    return Frame
end

--======================================================
--// AIMBOT FOV CIRCLE
--// НАТИВНЫЙ GUI — БЕЗ Drawing API
--======================================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(Settings.FOV * 2, Settings.FOV * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.ZIndex = 100
FOVCircle.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(150, 100, 255)
FOVStroke.Thickness = 2
FOVStroke.Transparency = 0.2
FOVStroke.Parent = FOVCircle

local function UpdateFOV()
    FOVCircle.Size = UDim2.fromOffset(Settings.FOV * 2, Settings.FOV * 2)
end

--======================================================
--// AIMBOT
--======================================================

local function GetCharacter(player)
    if not player.Character then
        return nil
    end

    local Character = player.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not Root then
        return nil
    end

    if Humanoid.Health <= 0 then
        return nil
    end

    return Character
end

local function IsEnemy(player)
    if player == LocalPlayer then
        return false
    end

    if Settings.TeamCheck and LocalPlayer.Team ~= nil and player.Team ~= nil then
        if LocalPlayer.Team == player.Team then
            return false
        end
    end

    return true
end

local function VisibleTarget(part, character)
    if not Settings.WallCheck then
        return true
    end

    local Origin = Camera.CFrame.Position
    local Direction = part.Position - Origin

    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.FilterDescendantsInstances = {
        LocalPlayer.Character,
        Camera
    }

    local Result = workspace:Raycast(
        Origin,
        Direction,
        Params
    )

    if not Result then
        return true
    end

    return Result.Instance:IsDescendantOf(character)
end

local function GetTarget()
    local BestPlayer = nil
    local BestPart = nil
    local BestDistance = Settings.FOV

    local Viewport = Camera.ViewportSize
    local Center = Vector2.new(
        Viewport.X / 2,
        Viewport.Y / 2
    )

    for _, player in ipairs(Players:GetPlayers()) do
        if IsEnemy(player) then
            local Character = GetCharacter(player)

            if Character then
                local Part =
                    Character:FindFirstChild("Head")
                    or Character:FindFirstChild("UpperTorso")
                    or Character:FindFirstChild("HumanoidRootPart")

                if Part then
                    local ScreenPos, OnScreen =
                        Camera:WorldToViewportPoint(Part.Position)

                    if OnScreen and ScreenPos.Z > 0 then
                        local Point = Vector2.new(
                            ScreenPos.X,
                            ScreenPos.Y
                        )

                        local Distance =
                            (Point - Center).Magnitude

                        if Distance < BestDistance then
                            if VisibleTarget(Part, Character) then
                                BestDistance = Distance
                                BestPlayer = player
                                BestPart = Part
                            end
                        end
                    end
                end
            end
        end
    end

    return BestPlayer, BestPart
end

--======================================================
--// СИЛЫ AIM
--======================================================

RunService.RenderStepped:Connect(function()
    if not Settings.Aimbot then
        return
    end

    local _, TargetPart = GetTarget()

    if not TargetPart then
        return
    end

    local CurrentCamera = workspace.CurrentCamera

    local Desired =
        CFrame.lookAt(
            CurrentCamera.CFrame.Position,
            TargetPart.Position
        )

    CurrentCamera.CFrame =
        CurrentCamera.CFrame:Lerp(
            Desired,
            math.clamp(Settings.Smoothness, 0.01, 1)
        )
end)

--======================================================
--// SPINBOT
--// Поворот персонажа вокруг вертикальной оси
--======================================================

RunService.Heartbeat:Connect(function(dt)
    if not Settings.Spinbot then
        return
    end

    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Root or not Humanoid or Humanoid.Health <= 0 then
        return
    end

    Root.CFrame =
        Root.CFrame *
        CFrame.Angles(
            0,
            math.rad(Settings.SpinSpeed * 60) * dt,
            0
        )
end)

--======================================================
--// AUTOJUMP
--======================================================

RunService.Heartbeat:Connect(function()
    if not Settings.AutoJump then
        return
    end

    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then
        return
    end

    if Humanoid.FloorMaterial ~= Enum.Material.Air then
        Humanoid.Jump = true
    end
end)

--======================================================
--// WALKSPEED
--======================================================

RunService.Heartbeat:Connect(function()
    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        return
    end

    if Settings.WalkSpeed then
        Humanoid.WalkSpeed = Settings.WalkSpeedValue
    else
        if Humanoid.WalkSpeed > 16 then
            Humanoid.WalkSpeed = 16
        end
    end
end)

--======================================================
--// AUTOWALK
--======================================================

RunService.RenderStepped:Connect(function()
    if not Settings.AutoWalk then
        return
    end

    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then
        return
    end

    Humanoid:Move(
        Vector3.new(0, 0, -1),
        true
    )
end)

--======================================================
--// МЕНЮ — AIM
--======================================================

Section("АИМБОТ")

Toggle("Аимбот", false, function(state)
    Settings.Aimbot = state
    FOVCircle.Visible = state
end)

Toggle("Проверка команды", true, function(state)
    Settings.TeamCheck = state
end)

Toggle("Проверка через стены", true, function(state)
    Settings.WallCheck = state
end)

NumberBox("Размер FOV", 180, 40, 500, function(value)
    Settings.FOV = value
    UpdateFOV()
end)

NumberBox("Плавность аима", 0.18, 0.01, 1, function(value)
    Settings.Smoothness = value
end)

--======================================================
--// SPINBOT
--======================================================

Section("КРУТИЛКА")

Toggle("Крутилка", false, function(state)
    Settings.Spinbot = state
end)

NumberBox("Скорость крутилки", 8, 1, 30, function(value)
    Settings.SpinSpeed = value
end)

--======================================================
--// ДВИЖЕНИЕ
--======================================================

Section("ДВИЖЕНИЕ")

Toggle("Авто-прыжок", false, function(state)
    Settings.AutoJump = state
end)

Toggle("Быстрая ходьба", false, function(state)
    Settings.WalkSpeed = state
end)

NumberBox("Скорость ходьбы", 28, 16, 150, function(value)
    Settings.WalkSpeedValue = value
end)

Toggle("Авто-ходьба", false, function(state)
    Settings.AutoWalk = state
end)

--======================================================
--// ОТКРЫТИЕ
--======================================================

local function OpenMenu()
    Main.Visible = true
    Main.Size = UDim2.fromOffset(350, 390)

    TweenService:Create(
        Main,
        TweenInfo.new(
            0.18,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.fromOffset(390, 430)
        }
    ):Play()
end

local function CloseMenu()
    Main.Visible = false
end

OpenButton.MouseButton1Click:Connect(function()
    if Main.Visible then
        CloseMenu()
    else
        OpenMenu()
    end
end)

Close.MouseButton1Click:Connect(CloseMenu)

--======================================================
--// ПЕРЕТАСКИВАНИЕ ОКНА
--======================================================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(Input)
    if not Dragging then
        return
    end

    if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Delta = Input.Position - DragStart

    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)

--======================================================
--// ПЕРЕТАСКИВАНИЕ AD
--======================================================

local ButtonDragging = false
local ButtonStart
local ButtonPosition

OpenButton.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        ButtonDragging = true
        ButtonStart = Input.Position
        ButtonPosition = OpenButton.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                ButtonDragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(Input)
    if not ButtonDragging then
        return
    end

    if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Delta = Input.Position - ButtonStart

    OpenButton.Position = UDim2.new(
        ButtonPosition.X.Scale,
        ButtonPosition.X.Offset + Delta.X,
        ButtonPosition.Y.Scale,
        ButtonPosition.Y.Offset + Delta.Y
    )
end)

--======================================================
--// RESPAWN FIX
--======================================================

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)

    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        return
    end

    if Settings.WalkSpeed then
        Humanoid.WalkSpeed = Settings.WalkSpeedValue
    end
end)

print("AD GUI загружен")
