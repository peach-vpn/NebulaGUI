--========================================================--
--                    AD SCRIPT                          --
--      MAIN MENU / AIMBOT / ESP / MOVEMENT / SPIN      --
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--========================================================--
-- SETTINGS
--========================================================--

local S = {
    Aim = false,
    AimFOV = 180,
    AimSmooth = 1,
    AimHead = true,
    TeamCheck = true,
    WallCheck = true,

    ESP = false,
    Box = true,
    Name = true,
    Health = true,
    Distance = true,
    Tracer = false,

    Speed = false,
    SpeedValue = 28,
    AutoJump = false,
    AutoWalk = false,

    Spin = false,
    SpinSpeed = 8
}

--========================================================--
-- REMOVE OLD GUI
--========================================================--

local Old = PlayerGui:FindFirstChild("AD_GUI")

if Old then
    Old:Destroy()
end

--========================================================--
-- SCREEN GUI
--========================================================--

local GUI = Instance.new("ScreenGui")
GUI.Name = "AD_GUI"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.Parent = PlayerGui

--========================================================--
-- AD BUTTON
--========================================================--

local AD = Instance.new("TextButton")
AD.Size = UDim2.fromOffset(58,58)
AD.Position = UDim2.new(0,18,0.5,-29)
AD.BackgroundColor3 = Color3.fromRGB(20,20,28)
AD.Text = "AD"
AD.TextColor3 = Color3.new(1,1,1)
AD.TextSize = 18
AD.Font = Enum.Font.GothamBold
AD.AutoButtonColor = false
AD.Parent = GUI

local ADC = Instance.new("UICorner")
ADC.CornerRadius = UDim.new(1,0)
ADC.Parent = AD

local ADS = Instance.new("UIStroke")
ADS.Color = Color3.fromRGB(135,80,255)
ADS.Thickness = 2
ADS.Parent = AD

--========================================================--
-- MAIN
--========================================================--

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(390,430)
Main.Position = UDim2.new(0.5,-195,0.5,-215)
Main.BackgroundColor3 = Color3.fromRGB(14,14,20)
Main.Visible = false
Main.Parent = GUI

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0,15)
MC.Parent = Main

local MS = Instance.new("UIStroke")
MS.Color = Color3.fromRGB(55,55,70)
MS.Parent = Main

--========================================================--
-- HEADER
--========================================================--

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,55)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.fromOffset(17,0)
Title.BackgroundTransparency = 1
Title.Text = "AD"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Back = Instance.new("TextButton")
Back.Size = UDim2.fromOffset(42,36)
Back.Position = UDim2.new(1,-95,0,9)
Back.BackgroundColor3 = Color3.fromRGB(28,28,37)
Back.Text = "‹"
Back.TextColor3 = Color3.fromRGB(220,220,230)
Back.TextSize = 25
Back.Font = Enum.Font.GothamBold
Back.Visible = false
Back.AutoButtonColor = false
Back.Parent = Header

local BC = Instance.new("UICorner")
BC.CornerRadius = UDim.new(0,9)
BC.Parent = Back

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38,36)
Close.Position = UDim2.new(1,-47,0,9)
Close.BackgroundColor3 = Color3.fromRGB(28,28,37)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(230,230,235)
Close.TextSize = 23
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

local CC = Instance.new("UICorner")
CC.CornerRadius = UDim.new(0,9)
CC.Parent = Close

--========================================================--
-- CONTENT
--========================================================--

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1,-20,1,-65)
Content.Position = UDim2.fromOffset(10,60)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.CanvasSize = UDim2.new()
Content.Parent = Main

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0,5)
Padding.PaddingRight = UDim.new(0,5)
Padding.PaddingBottom = UDim.new(0,12)
Padding.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

--========================================================--
-- CLEAR
--========================================================--

local function Clear()
    for _,v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout")
        and not v:IsA("UIPadding") then
            v:Destroy()
        end
    end
end

--========================================================--
-- SECTION
--========================================================--

local function Section(text)

    local L = Instance.new("TextLabel")

    L.Size = UDim2.new(1,0,0,28)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(155,105,255)
    L.TextSize = 15
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Content

end

--========================================================--
-- BUTTON
--========================================================--

local function Button(text, callback)

    local B = Instance.new("TextButton")

    B.Size = UDim2.new(1,0,0,55)
    B.BackgroundColor3 = Color3.fromRGB(23,23,31)
    B.Text = ""
    B.AutoButtonColor = false
    B.Parent = Content

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,11)
    C.Parent = B

    local L = Instance.new("TextLabel")

    L.Size = UDim2.new(1,-50,1,0)
    L.Position = UDim2.fromOffset(16,0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(230,230,235)
    L.TextSize = 15
    L.Font = Enum.Font.GothamMedium
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = B

    local Arrow = Instance.new("TextLabel")

    Arrow.Size = UDim2.fromOffset(30,55)
    Arrow.Position = UDim2.new(1,-40,0,0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "›"
    Arrow.TextColor3 = Color3.fromRGB(130,130,145)
    Arrow.TextSize = 22
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = B

    B.MouseButton1Click:Connect(callback)

end

--========================================================--
-- TOGGLE
--========================================================--

local function Toggle(text, value, callback)

    local B = Instance.new("TextButton")

    B.Size = UDim2.new(1,0,0,43)
    B.BackgroundColor3 = Color3.fromRGB(23,23,31)
    B.Text = ""
    B.AutoButtonColor = false
    B.Parent = Content

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,10)
    C.Parent = B

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-70,1,0)
    L.Position = UDim2.fromOffset(13,0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(225,225,230)
    L.TextSize = 14
    L.Font = Enum.Font.GothamMedium
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = B

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.fromOffset(40,22)
    Switch.Position = UDim2.new(1,-53,0.5,-11)
    Switch.BackgroundColor3 = Color3.fromRGB(55,55,65)
    Switch.Parent = B

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(1,0)
    SC.Parent = Switch

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(18,18)
    Dot.Position = UDim2.fromOffset(2,2)
    Dot.BackgroundColor3 = Color3.fromRGB(235,235,240)
    Dot.Parent = Switch

    local DC = Instance.new("UICorner")
    DC.CornerRadius = UDim.new(1,0)
    DC.Parent = Dot

    local function Update()

        if value then
            Switch.BackgroundColor3 =
                Color3.fromRGB(120,70,255)
            Dot.Position =
                UDim2.fromOffset(20,2)
        else
            Switch.BackgroundColor3 =
                Color3.fromRGB(55,55,65)
            Dot.Position =
                UDim2.fromOffset(2,2)
        end

    end

    B.MouseButton1Click:Connect(function()

        value = not value
        Update()

        if callback then
            callback(value)
        end

    end)

    Update()

end

--========================================================--
-- NUMBER
--========================================================--

local function Number(text,value,min,max,callback)

    local F = Instance.new("Frame")

    F.Size = UDim2.new(1,0,0,43)
    F.BackgroundColor3 = Color3.fromRGB(23,23,31)
    F.Parent = Content

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,10)
    C.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-120,1,0)
    L.Position = UDim2.fromOffset(13,0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(225,225,230)
    L.TextSize = 14
    L.Font = Enum.Font.GothamMedium
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.fromOffset(88,29)
    Box.Position = UDim2.new(1,-98,0.5,-14)
    Box.BackgroundColor3 = Color3.fromRGB(34,34,44)
    Box.Text = tostring(value)
    Box.TextColor3 = Color3.new(1,1,1)
    Box.TextSize = 13
    Box.Font = Enum.Font.GothamMedium
    Box.ClearTextOnFocus = false
    Box.Parent = F

    local BC2 = Instance.new("UICorner")
    BC2.CornerRadius = UDim.new(0,8)
    BC2.Parent = Box

    Box.FocusLost:Connect(function()

        local n = tonumber(Box.Text)

        if not n then
            Box.Text = tostring(value)
            return
        end

        n = math.clamp(n,min,max)
        value = n
        Box.Text = tostring(n)

        if callback then
            callback(n)
        end

    end)

end

--========================================================--
-- FOV
--========================================================--

local FOV = Instance.new("Frame")

FOV.AnchorPoint = Vector2.new(0.5,0.5)
FOV.Position = UDim2.fromScale(0.5,0.5)
FOV.Size = UDim2.fromOffset(360,360)
FOV.BackgroundTransparency = 1
FOV.Visible = false
FOV.ZIndex = 100
FOV.Parent = GUI

local FC = Instance.new("UICorner")
FC.CornerRadius = UDim.new(1,0)
FC.Parent = FOV

local FS = Instance.new("UIStroke")
FS.Color = Color3.fromRGB(150,95,255)
FS.Thickness = 2
FS.Transparency = 0.15
FS.Parent = FOV

local function UpdateFOV()
    FOV.Size = UDim2.fromOffset(
        S.AimFOV * 2,
        S.AimFOV * 2
    )
end

--========================================================--
-- AIM TARGET
--========================================================--

local LockedTarget = nil

local function Alive(Player)

    if not Player then
        return false
    end

    local Character = Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    local Head =
        Character:FindFirstChild("Head")

    if not Humanoid or not Root or not Head then
        return false
    end

    if Humanoid.Health <= 0 then
        return false
    end

    return true
end

local function Enemy(Player)

    if not Alive(Player) then
        return false
    end

    if Player == LP then
        return false
    end

    if S.TeamCheck then

        if LP.Team ~= nil
        and Player.Team ~= nil
        and LP.Team == Player.Team then

            return false

        end

    end

    return true
end

local function Visible(Player)

    if not S.WallCheck then
        return true
    end

    local Character = Player.Character

    local Head = Character
        and Character:FindFirstChild("Head")

    if not Head then
        return false
    end

    local Camera =
        workspace.CurrentCamera

    local Origin =
        Camera.CFrame.Position

    local Direction =
        Head.Position-Origin

    local Params = RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    Params.FilterDescendantsInstances = {
        LP.Character,
        Camera
    }

    local Hit =
        workspace:Raycast(
            Origin,
            Direction,
            Params
        )

    if not Hit then
        return true
    end

    return Hit.Instance:IsDescendantOf(Character)
end

local function FindTarget()

    local Camera =
        workspace.CurrentCamera

    local View =
        Camera.ViewportSize

    local Center =
        Vector2.new(
            View.X/2,
            View.Y/2
        )

    local Best = nil
    local BestDistance = S.AimFOV

    for _,Player in ipairs(
        Players:GetPlayers()
    ) do

        if Enemy(Player) and Visible(Player) then

            local Head =
                Player.Character:FindFirstChild("Head")

            local Position,OnScreen =
                Camera:WorldToViewportPoint(
                    Head.Position
                )

            if OnScreen and Position.Z > 0 then

                local Point =
                    Vector2.new(
                        Position.X,
                        Position.Y
                    )

                local Distance =
                    (Point-Center).Magnitude

                if Distance < BestDistance then

                    BestDistance = Distance
                    Best = Player

                end

            end

        end

    end

    return Best
end

--========================================================--
-- AIM LOOP
--========================================================--

RunService.RenderStepped:Connect(function()

    if not S.Aim then

        LockedTarget = nil
        return

    end

    -- Не сбрасываем цель каждый кадр.
    if not Enemy(LockedTarget) then
        LockedTarget = FindTarget()
    end

    if not LockedTarget then
        return
    end

    if not Visible(LockedTarget) then
        LockedTarget = nil
        return
    end

    local Character =
        LockedTarget.Character

    local Head =
        Character
        and Character:FindFirstChild("Head")

    if not Head then
        LockedTarget = nil
        return
    end

    local Camera =
        workspace.CurrentCamera

    local Desired =
        CFrame.lookAt(
            Camera.CFrame.Position,
            Head.Position
        )

    Camera.CFrame =
        Camera.CFrame:Lerp(
            Desired,
            math.clamp(
                S.AimSmooth,
                0.01,
                1
            )
        )

end)

--========================================================--
-- ESP SYSTEM
--========================================================--

local ESP = {}

local function RemoveESP(Player)

    local Data = ESP[Player]

    if not Data then
        return
    end

    for _,Object in pairs(Data) do

        if typeof(Object) == "Instance" then

            pcall(function()
                Object:Destroy()
            end)

        end

    end

    ESP[Player] = nil

end

local function CreateESP(Player)

    if Player == LP then
        return
    end

    RemoveESP(Player)

    local Box =
        Instance.new("BoxHandleAdornment")

    Box.Size =
        Vector3.new(4,6,2)

    Box.Color3 =
        Color3.fromRGB(145,85,255)

    Box.Transparency = 0.55
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Visible = false

    local Billboard =
        Instance.new("BillboardGui")

    Billboard.Size =
        UDim2.fromOffset(180,65)

    Billboard.StudsOffset =
        Vector3.new(0,4,0)

    Billboard.AlwaysOnTop = true
    Billboard.Enabled = false

    local Text =
        Instance.new("TextLabel")

    Text.Size =
        UDim2.fromScale(1,1)

    Text.BackgroundTransparency = 1
    Text.TextColor3 = Color3.new(1,1,1)
    Text.TextStrokeTransparency = 0
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 13
    Text.TextWrapped = true
    Text.Parent = Billboard

    ESP[Player] = {
        Box = Box,
        Billboard = Billboard,
        Text = Text
    }

end

local function UpdateESP(Player)

    local Data = ESP[Player]

    if not Data then
        return
    end

    local Character =
        Player.Character

    if not Character then
        Data.Box.Visible = false
        Data.Billboard.Enabled = false
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Root or not Humanoid
    or Humanoid.Health <= 0 then

        Data.Box.Visible = false
        Data.Billboard.Enabled = false
        return

    end

    if S.TeamCheck
    and LP.Team ~= nil
    and Player.Team ~= nil
    and LP.Team == Player.Team then

        Data.Box.Visible = false
        Data.Billboard.Enabled = false
        return

    end

    Data.Box.Adornee = Root

    Data.Box.Visible =
        S.ESP and S.Box

    local Camera =
        workspace.CurrentCamera

    local Distance =
        math.floor(
            (
                Root.Position
                -
                Camera.CFrame.Position
            ).Magnitude
        )

    local Text = ""

    if S.Name then
        Text = Player.Name
    end

    if S.Health then

        if Text ~= "" then
            Text = Text .. "\n"
        end

        Text =
            Text
            .. "HP: "
            .. math.floor(Humanoid.Health)
            .. "/"
            .. math.floor(Humanoid.MaxHealth)

    end

    if S.Distance then

        if Text ~= "" then
            Text = Text .. "\n"
        end

        Text =
            Text
            .. Distance
            .. " studs"

    end

    Data.Text.Text = Text
    Data.Billboard.Adornee = Root

    Data.Billboard.Enabled =
        S.ESP
        and (
            S.Name
            or S.Health
            or S.Distance
        )

end

for _,Player in ipairs(
    Players:GetPlayers()
) do
    CreateESP(Player)
end

Players.PlayerAdded:Connect(function(Player)

    CreateESP(Player)

    Player.CharacterAdded:Connect(function()

        task.wait(0.5)
        CreateESP(Player)

    end)

end)

Players.PlayerRemoving:Connect(function(Player)

    RemoveESP(Player)

end)

RunService.RenderStepped:Connect(function()

    for Player in pairs(ESP) do
        UpdateESP(Player)
    end

end)

--========================================================--
-- MOVEMENT
--========================================================--

RunService.Heartbeat:Connect(function()

    local Character = LP.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Humanoid then
        return
    end

    if S.Speed then
        Humanoid.WalkSpeed =
            S.SpeedValue
    end

    if S.AutoJump
    and Humanoid.FloorMaterial
        ~= Enum.Material.Air then

        Humanoid.Jump = true

    end

end)

RunService.RenderStepped:Connect(function()

    if not S.AutoWalk then
        return
    end

    local Character = LP.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if Humanoid then
        Humanoid:Move(
            Vector3.new(0,0,-1),
            true
        )
    end

end)

--========================================================--
-- SPIN
--========================================================--

RunService.Heartbeat:Connect(function(dt)

    if not S.Spin then
        return
    end

    local Character = LP.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if Root then

        Root.CFrame =
            Root.CFrame
            *
            CFrame.Angles(
                0,
                math.rad(
                    S.SpinSpeed * 60
                ) * dt,
                0
            )

    end

end)

--========================================================--
-- MAIN PAGE
--========================================================--

local function MainPage()

    Clear()

    Title.Text = "AD"
    Back.Visible = false

    Section("РАЗДЕЛЫ")

    Button("Аимбот",function()
        AimPage()
    end)

    Button("ESP",function()
        ESPPage()
    end)

    Button("Движение",function()
        MovementPage()
    end)

    Button("Крутилка",function()
        SpinPage()
    end)

end

--========================================================--
-- AIM PAGE
--========================================================--

function AimPage()

    Clear()

    Title.Text = "Аимбот"
    Back.Visible = true

    Section("НАСТРОЙКИ АИМА")

    Toggle(
        "Включить аимбот",
        S.Aim,
        function(v)

            S.Aim = v
            FOV.Visible = v

            if not v then
                LockedTarget = nil
            end

        end
    )

    Toggle(
        "Наведение в голову",
        S.AimHead,
        function(v)
            S.AimHead = v
        end
    )

    Toggle(
        "Проверка команды",
        S.TeamCheck,
        function(v)
            S.TeamCheck = v
        end
    )

    Toggle(
        "Проверка стен",
        S.WallCheck,
        function(v)
            S.WallCheck = v
        end
    )

    Number(
        "Размер FOV",
        S.AimFOV,
        30,
        600,
        function(v)

            S.AimFOV = v
            UpdateFOV()

        end
    )

    Number(
        "Скорость наведения",
        S.AimSmooth,
        0.01,
        1,
        function(v)

            S.AimSmooth = v

        end
    )

    Section("ТЕКУЩАЯ ЦЕЛЬ")

    local TargetLabel =
        Instance.new("TextLabel")

    TargetLabel.Size =
        UDim2.new(1,0,0,50)

    TargetLabel.BackgroundColor3 =
        Color3.fromRGB(23,23,31)

    TargetLabel.Text =
        "Цель: нет"

    TargetLabel.TextColor3 =
        Color3.fromRGB(220,220,230)

    TargetLabel.TextSize = 14
    TargetLabel.Font =
        Enum.Font.GothamMedium

    TargetLabel.Parent = Content

    local C =
        Instance.new("UICorner")

    C.CornerRadius =
        UDim.new(0,10)

    C.Parent = TargetLabel

    -- Обновляем отображение цели.
    task.spawn(function()

        while Main.Visible
        and Title.Text == "Аимбот" do

            if Alive(LockedTarget) then

                local H =
                    LockedTarget.Character
                    :FindFirstChildOfClass(
                        "Humanoid"
                    )

                TargetLabel.Text =
                    "Цель: "
                    .. LockedTarget.Name
                    .. "\nHP: "
                    .. math.floor(H.Health)

            else

                TargetLabel.Text =
                    "Цель: нет"

            end

            task.wait(0.15)

        end

    end)

end

--========================================================--
-- ESP PAGE
--========================================================--

function ESPPage()

    Clear()

    Title.Text = "ESP"
    Back.Visible = true

    Section("ОСНОВНОЙ ESP")

    Toggle(
        "Включить ESP",
        S.ESP,
        function(v)
            S.ESP = v
        end
    )

    Toggle(
        "3D Box",
        S.Box,
        function(v)
            S.Box = v
        end
    )

    Toggle(
        "Имя игрока",
        S.Name,
        function(v)
            S.Name = v
        end
    )

    Toggle(
        "HP",
        S.Health,
        function(v)
            S.Health = v
        end
    )

    Toggle(
        "Дистанция",
        S.Distance,
        function(v)
            S.Distance = v
        end
    )

    Toggle(
        "Проверка команды",
        S.TeamCheck,
        function(v)
            S.TeamCheck = v
        end
    )

end

--========================================================--
-- MOVEMENT PAGE
--========================================================--

function MovementPage()

    Clear()

    Title.Text = "Движение"
    Back.Visible = true

    Section("ДВИЖЕНИЕ")

    Toggle(
        "Быстрая ходьба",
        S.Speed,
        function(v)
            S.Speed = v
        end
    )

    Number(
        "Скорость",
        S.SpeedValue,
        16,
        150,
        function(v)
            S.SpeedValue = v
        end
    )

    Toggle(
        "Авто-прыжок",
        S.AutoJump,
        function(v)
            S.AutoJump = v
        end
    )

    Toggle(
        "Авто-ходьба",
        S.AutoWalk,
        function(v)
            S.AutoWalk = v
        end
    )

end

--========================================================--
-- SPIN PAGE
--========================================================--

function SpinPage()

    Clear()

    Title.Text = "Крутилка"
    Back.Visible = true

    Section("КРУТИЛКА")

    Toggle(
        "Включить крутилку",
        S.Spin,
        function(v)
            S.Spin = v
        end
    )

    Number(
        "Скорость",
        S.SpinSpeed,
        1,
        40,
        function(v)
            S.SpinSpeed = v
        end
    )

end

--========================================================--
-- BACK
--========================================================--

Back.MouseButton1Click:Connect(
    MainPage
)

--========================================================--
-- CLOSE
--========================================================--

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

AD.MouseButton1Click:Connect(function()

    Main.Visible = not Main.Visible

    if Main.Visible then
        MainPage()
    end

end)

--========================================================--
-- DRAG WINDOW
--========================================================--

local Drag = false
local DragStart
local StartPos

Header.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch then

        Drag = true
        DragStart = Input.Position
        StartPos = Main.Position

        Input.Changed:Connect(function()

            if Input.UserInputState ==
                Enum.UserInputState.End then

                Drag = false

            end

        end)

    end

end)

UIS.InputChanged:Connect(function(Input)

    if not Drag then
        return
    end

    if Input.UserInputType ~=
        Enum.UserInputType.MouseMovement
        and Input.UserInputType ~=
        Enum.UserInputType.Touch then

        return

    end

    local Delta =
        Input.Position - DragStart

    Main.Position =
        UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )

end)

--========================================================--
-- DRAG AD BUTTON
--========================================================--

local ButtonDrag = false
local ButtonStart
local ButtonPos

AD.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch then

        ButtonDrag = true
        ButtonStart = Input.Position
        ButtonPos = AD.Position

        Input.Changed:Connect(function()

            if Input.UserInputState ==
                Enum.UserInputState.End then

                ButtonDrag = false

            end

        end)

    end

end)

UIS.InputChanged:Connect(function(Input)

    if not ButtonDrag then
        return
    end

    if Input.UserInputType ~=
        Enum.UserInputType.MouseMovement
        and Input.UserInputType ~=
        Enum.UserInputType.Touch then

        return

    end

    local Delta =
        Input.Position - ButtonStart

    AD.Position =
        UDim2.new(
            ButtonPos.X.Scale,
            ButtonPos.X.Offset + Delta.X,
            ButtonPos.Y.Scale,
            ButtonPos.Y.Offset + Delta.Y
        )

end)

--========================================================--
-- START
--========================================================--

MainPage()

print("AD GUI loaded")
