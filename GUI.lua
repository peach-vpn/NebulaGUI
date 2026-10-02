--========================================================--
--                     AD SCRIPT                         --
--       AIMBOT / ESP / MOVEMENT / SPINBOT              --
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

local Settings = {
    -- AIM
    Aim = false,
    AimFOV = 180,
    AimSmooth = 0.18,
    TeamCheck = true,
    WallCheck = true,

    -- ESP
    ESP = false,
    Box = true,
    Name = true,
    Health = true,
    Distance = true,
    Tracer = false,

    -- MOVEMENT
    Speed = false,
    SpeedValue = 28,
    AutoJump = false,
    AutoWalk = false,

    -- SPIN
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
-- MAIN GUI
--========================================================--

local GUI = Instance.new("ScreenGui")
GUI.Name = "AD_GUI"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.Parent = PlayerGui

--========================================================--
-- AD BUTTON
--========================================================--

local ADButton = Instance.new("TextButton")
ADButton.Name = "ADButton"
ADButton.Size = UDim2.fromOffset(58,58)
ADButton.Position = UDim2.new(0,18,0.5,-29)
ADButton.BackgroundColor3 = Color3.fromRGB(20,20,27)
ADButton.Text = "AD"
ADButton.TextColor3 = Color3.new(1,1,1)
ADButton.TextSize = 18
ADButton.Font = Enum.Font.GothamBold
ADButton.AutoButtonColor = false
ADButton.Parent = GUI

local ADCorner = Instance.new("UICorner")
ADCorner.CornerRadius = UDim.new(1,0)
ADCorner.Parent = ADButton

local ADStroke = Instance.new("UIStroke")
ADStroke.Color = Color3.fromRGB(130,80,255)
ADStroke.Thickness = 2
ADStroke.Parent = ADButton

--========================================================--
-- MAIN WINDOW
--========================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(400,500)
Main.Position = UDim2.new(0.5,-200,0.5,-250)
Main.BackgroundColor3 = Color3.fromRGB(14,14,20)
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = GUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55,55,70)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--========================================================--
-- HEADER
--========================================================--

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,55)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-70,1,0)
Title.Position = UDim2.fromOffset(17,0)
Title.BackgroundTransparency = 1
Title.Text = "AD  •  Панель"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38,38)
Close.Position = UDim2.new(1,-48,0,8)
Close.BackgroundColor3 = Color3.fromRGB(30,30,39)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(230,230,235)
Close.TextSize = 25
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,10)
CloseCorner.Parent = Close

--========================================================--
-- SCROLL
--========================================================--

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-20,1,-65)
Scroll.Position = UDim2.fromOffset(10,60)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new()
Scroll.Parent = Main

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0,5)
Padding.PaddingRight = UDim.new(0,5)
Padding.PaddingBottom = UDim.new(0,15)
Padding.Parent = Scroll

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

--========================================================--
-- SECTION
--========================================================--

local function Section(text)

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1,0,0,30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(155,110,255)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left

    Label.Parent = Scroll

    return Label
end

--========================================================--
-- TOGGLE
--========================================================--

local function Toggle(text, default, callback)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1,0,0,43)
    Button.BackgroundColor3 = Color3.fromRGB(23,23,31)
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,10)
    Corner.Parent = Button

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1,-70,1,0)
    Label.Position = UDim2.fromOffset(13,0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(225,225,230)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Switch = Instance.new("Frame")

    Switch.Size = UDim2.fromOffset(40,22)
    Switch.Position = UDim2.new(1,-53,0.5,-11)
    Switch.BackgroundColor3 = Color3.fromRGB(55,55,65)
    Switch.Parent = Button

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1,0)
    SwitchCorner.Parent = Switch

    local Dot = Instance.new("Frame")

    Dot.Size = UDim2.fromOffset(18,18)
    Dot.Position = UDim2.fromOffset(2,2)
    Dot.BackgroundColor3 = Color3.fromRGB(235,235,240)
    Dot.Parent = Switch

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1,0)
    DotCorner.Parent = Dot

    local Value = default

    local function Update()

        if Value then

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

--========================================================--
-- NUMBER BOX
--========================================================--

local function NumberBox(text,value,min,max,callback)

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1,0,0,43)
    Frame.BackgroundColor3 = Color3.fromRGB(23,23,31)
    Frame.Parent = Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,10)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1,-120,1,0)
    Label.Position = UDim2.fromOffset(13,0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(225,225,230)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Box = Instance.new("TextBox")

    Box.Size = UDim2.fromOffset(88,29)
    Box.Position = UDim2.new(1,-98,0.5,-14)
    Box.BackgroundColor3 = Color3.fromRGB(34,34,44)
    Box.Text = tostring(value)
    Box.TextColor3 = Color3.new(1,1,1)
    Box.TextSize = 13
    Box.Font = Enum.Font.GothamMedium
    Box.ClearTextOnFocus = false
    Box.Parent = Frame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0,8)
    BoxCorner.Parent = Box

    Box.FocusLost:Connect(function()

        local Number = tonumber(Box.Text)

        if not Number then
            Box.Text = tostring(value)
            return
        end

        Number = math.clamp(Number,min,max)

        value = Number

        Box.Text = tostring(Number)

        if callback then
            callback(Number)
        end

    end)

    return Frame
end

--========================================================--
-- FOV CIRCLE
--========================================================--

local FOV = Instance.new("Frame")

FOV.AnchorPoint = Vector2.new(0.5,0.5)
FOV.Position = UDim2.fromScale(0.5,0.5)
FOV.Size = UDim2.fromOffset(
    Settings.AimFOV*2,
    Settings.AimFOV*2
)

FOV.BackgroundTransparency = 1
FOV.Visible = false
FOV.ZIndex = 50
FOV.Parent = GUI

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1,0)
FOVCorner.Parent = FOV

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(150,100,255)
FOVStroke.Thickness = 2
FOVStroke.Parent = FOV

local function UpdateFOV()

    FOV.Size = UDim2.fromOffset(
        Settings.AimFOV*2,
        Settings.AimFOV*2
    )

end

--========================================================--
-- AIMBOT
--========================================================--

local function GetCharacter(Player)

    if not Player.Character then
        return nil
    end

    local Character = Player.Character

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not Root then
        return nil
    end

    if Humanoid.Health <= 0 then
        return nil
    end

    return Character
end

local function IsEnemy(Player)

    if Player == LP then
        return false
    end

    if Settings.TeamCheck then

        if LP.Team ~= nil and Player.Team ~= nil then

            if LP.Team == Player.Team then
                return false
            end

        end

    end

    return true
end

local function IsVisible(Part,Character)

    if not Settings.WallCheck then
        return true
    end

    local Camera =
        workspace.CurrentCamera

    local Origin =
        Camera.CFrame.Position

    local Direction =
        Part.Position-Origin

    local Params =
        RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    Params.FilterDescendantsInstances = {
        LP.Character,
        Camera
    }

    local Result =
        workspace:Raycast(
            Origin,
            Direction,
            Params
        )

    if not Result then
        return true
    end

    return Result.Instance:IsDescendantOf(Character)
end

local function GetTarget()

    local Camera =
        workspace.CurrentCamera

    local Viewport =
        Camera.ViewportSize

    local Center =
        Vector2.new(
            Viewport.X/2,
            Viewport.Y/2
        )

    local BestPart = nil
    local BestDistance = Settings.AimFOV

    for _,Player in ipairs(Players:GetPlayers()) do

        if IsEnemy(Player) then

            local Character =
                GetCharacter(Player)

            if Character then

                local Part =
                    Character:FindFirstChild("Head")

                if Part then

                    local Position,Visible =
                        Camera:WorldToViewportPoint(
                            Part.Position
                        )

                    if Visible and Position.Z > 0 then

                        local Point =
                            Vector2.new(
                                Position.X,
                                Position.Y
                            )

                        local Distance =
                            (Point-Center).Magnitude

                        if Distance < BestDistance then

                            if IsVisible(
                                Part,
                                Character
                            ) then

                                BestDistance =
                                    Distance

                                BestPart =
                                    Part

                            end

                        end

                    end

                end

            end

        end

    end

    return BestPart
end

RunService.RenderStepped:Connect(function()

    if not Settings.Aim then
        return
    end

    local Target =
        GetTarget()

    if not Target then
        return
    end

    local Camera =
        workspace.CurrentCamera

    local AimCFrame =
        CFrame.lookAt(
            Camera.CFrame.Position,
            Target.Position
        )

    Camera.CFrame =
        Camera.CFrame:Lerp(
            AimCFrame,
            math.clamp(
                Settings.AimSmooth,
                0.01,
                1
            )
        )

end)

--========================================================--
-- ESP
--========================================================--

local ESPObjects = {}

local function RemoveESP(Player)

    if ESPObjects[Player] then

        for _,Object in pairs(
            ESPObjects[Player]
        ) do

            if typeof(Object) == "Instance" then

                pcall(function()
                    Object:Destroy()
                end)

            end

        end

        ESPObjects[Player] = nil

    end
end

local function CreateESP(Player)

    if Player == LP then
        return
    end

    RemoveESP(Player)

    local Box = Instance.new("BoxHandleAdornment")

    Box.Name = "AD_Box"
    Box.Size = Vector3.new(4,6,2)
    Box.Color3 = Color3.fromRGB(150,80,255)
    Box.Transparency = 0.65
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Visible = false

    local Billboard =
        Instance.new("BillboardGui")

    Billboard.Name = "AD_Info"
    Billboard.Size =
        UDim2.fromOffset(180,70)

    Billboard.StudsOffset =
        Vector3.new(0,4,0)

    Billboard.AlwaysOnTop = true
    Billboard.Enabled = false

    local Info =
        Instance.new("TextLabel")

    Info.Size =
        UDim2.fromScale(1,1)

    Info.BackgroundTransparency = 1

    Info.TextColor3 =
        Color3.new(1,1,1)

    Info.TextStrokeTransparency = 0

    Info.Font =
        Enum.Font.GothamBold

    Info.TextSize = 13

    Info.TextWrapped = true

    Info.Parent = Billboard

    local Tracer =
        Instance.new("Frame")

    Tracer.Name = "Tracer"
    Tracer.AnchorPoint =
        Vector2.new(0.5,1)

    Tracer.Size =
        UDim2.fromOffset(2,100)

    Tracer.BackgroundColor3 =
        Color3.fromRGB(150,80,255)

    Tracer.BorderSizePixel = 0
    Tracer.Visible = false
    Tracer.ZIndex = 20
    Tracer.Parent = GUI

    ESPObjects[Player] = {
        Box = Box,
        Billboard = Billboard,
        Info = Info,
        Tracer = Tracer
    }

end

local function UpdateESP(Player)

    if Player == LP then
        return
    end

    local Character =
        Player.Character

    local Data =
        ESPObjects[Player]

    if not Character or not Data then
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

    if not Root or not Humanoid then

        Data.Box.Visible = false
        Data.Billboard.Enabled = false
        Data.Tracer.Visible = false

        return
    end

    if Humanoid.Health <= 0 then

        Data.Box.Visible = false
        Data.Billboard.Enabled = false
        Data.Tracer.Visible = false

        return
    end

    if Settings.TeamCheck
        and LP.Team ~= nil
        and Player.Team ~= nil
        and LP.Team == Player.Team then

        Data.Box.Visible = false
        Data.Billboard.Enabled = false
        Data.Tracer.Visible = false

        return
    end

    -- BOX

    Data.Box.Adornee = Root

    Data.Box.Visible =
        Settings.ESP
        and Settings.Box

    -- INFO

    local Distance =
        math.floor(
            (
                Root.Position
                -
                workspace.CurrentCamera
                    .CFrame.Position
            ).Magnitude
        )

    local Text = ""

    if Settings.Name then
        Text = Text .. Player.Name
    end

    if Settings.Health then

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

    if Settings.Distance then

        if Text ~= "" then
            Text = Text .. "\n"
        end

        Text =
            Text
            .. Distance
            .. " studs"

    end

    Data.Info.Text = Text

    Data.Billboard.Adornee =
        Root

    Data.Billboard.Enabled =
        Settings.ESP
        and (
            Settings.Name
            or Settings.Health
            or Settings.Distance
        )

    -- TRACER

    local Camera =
        workspace.CurrentCamera

    local Position,Visible =
        Camera:WorldToViewportPoint(
            Root.Position
        )

    if Settings.ESP
        and Settings.Tracer
        and Visible then

        local Screen =
            Camera.ViewportSize

        local Start =
            Vector2.new(
                Screen.X/2,
                Screen.Y
            )

        local End =
            Vector2.new(
                Position.X,
                Position.Y
            )

        local Difference =
            End-Start

        Data.Tracer.Position =
            UDim2.fromOffset(
                Start.X,
                Start.Y
            )

        Data.Tracer.Size =
            UDim2.fromOffset(
                2,
                Difference.Magnitude
            )

        Data.Tracer.Rotation =
            math.deg(
                math.atan2(
                    Difference.Y,
                    Difference.X
                )
            ) + 90

        Data.Tracer.Visible = true

    else

        Data.Tracer.Visible = false

    end

end

--========================================================--
-- ESP PLAYER EVENTS
--========================================================--

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

    if not Settings.ESP then

        for _,Data in pairs(ESPObjects) do

            Data.Box.Visible = false
            Data.Billboard.Enabled = false
            Data.Tracer.Visible = false

        end

        return
    end

    for Player in pairs(ESPObjects) do

        UpdateESP(Player)

    end

end)

--========================================================--
-- MOVEMENT
--========================================================--

RunService.Heartbeat:Connect(function()

    local Character =
        LP.Character

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

    if Settings.Speed then

        Humanoid.WalkSpeed =
            Settings.SpeedValue

    elseif Humanoid.WalkSpeed > 16 then

        Humanoid.WalkSpeed = 16

    end

end)

--========================================================--
-- AUTO JUMP
--========================================================--

RunService.Heartbeat:Connect(function()

    if not Settings.AutoJump then
        return
    end

    local Character =
        LP.Character

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

    if Humanoid.FloorMaterial
        ~= Enum.Material.Air then

        Humanoid.Jump = true

    end

end)

--========================================================--
-- AUTO WALK
--========================================================--

RunService.RenderStepped:Connect(function()

    if not Settings.AutoWalk then
        return
    end

    local Character =
        LP.Character

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

    Humanoid:Move(
        Vector3.new(0,0,-1),
        true
    )

end)

--========================================================--
-- SPINBOT
--========================================================--

RunService.Heartbeat:Connect(function(dt)

    if not Settings.Spin then
        return
    end

    local Character =
        LP.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Root then
        return
    end

    Root.CFrame =
        Root.CFrame
        *
        CFrame.Angles(
            0,
            math.rad(
                Settings.SpinSpeed*60
            )*dt,
            0
        )

end)

--========================================================--
-- GUI CONTROLS
--========================================================--

Section("АИМБОТ")

Toggle("Аимбот",false,function(Value)

    Settings.Aim = Value
    FOV.Visible = Value

end)

Toggle("Проверка команды",true,function(Value)

    Settings.TeamCheck = Value

end)

Toggle("Проверка стен",true,function(Value)

    Settings.WallCheck = Value

end)

NumberBox(
    "Размер FOV",
    180,
    40,
    500,
    function(Value)

        Settings.AimFOV = Value
        UpdateFOV()

    end
)

NumberBox(
    "Плавность",
    0.18,
    0.01,
    1,
    function(Value)

        Settings.AimSmooth = Value

    end
)

--========================================================--
-- ESP CONTROLS
--========================================================--

Section("ESP")

Toggle("ESP",false,function(Value)

    Settings.ESP = Value

end)

Toggle("3D Box",true,function(Value)

    Settings.Box = Value

end)

Toggle("Имя игрока",true,function(Value)

    Settings.Name = Value

end)

Toggle("Полоса HP",true,function(Value)

    Settings.Health = Value

end)

Toggle("Дистанция",true,function(Value)

    Settings.Distance = Value

end)

Toggle("Линия до игрока",false,function(Value)

    Settings.Tracer = Value

end)

Toggle("Проверка команды",true,function(Value)

    Settings.TeamCheck = Value

end)

--========================================================--
-- MOVEMENT CONTROLS
--========================================================--

Section("ДВИЖЕНИЕ")

Toggle("Быстрая ходьба",false,function(Value)

    Settings.Speed = Value

end)

NumberBox(
    "Скорость",
    28,
    16,
    150,
    function(Value)

        Settings.SpeedValue = Value

    end
)

Toggle("Авто-прыжок",false,function(Value)

    Settings.AutoJump = Value

end)

Toggle("Авто-ходьба",false,function(Value)

    Settings.AutoWalk = Value

end)

--========================================================--
-- SPIN CONTROLS
--========================================================--

Section("КРУТИЛКА")

Toggle("Крутилка",false,function(Value)

    Settings.Spin = Value

end)

NumberBox(
    "Скорость крутилки",
    8,
    1,
    30,
    function(Value)

        Settings.SpinSpeed = Value

    end
)

--========================================================--
-- OPEN / CLOSE
--========================================================--

local function OpenMenu()

    Main.Visible = true

    Main.Size =
        UDim2.fromOffset(360,450)

    TweenService:Create(
        Main,
        TweenInfo.new(
            0.18,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Size =
                UDim2.fromOffset(
                    400,
                    500
                )
        }
    ):Play()

end

local function CloseMenu()

    Main.Visible = false

end

ADButton.MouseButton1Click:Connect(function()

    if Main.Visible then
        CloseMenu()
    else
        OpenMenu()
    end

end)

Close.MouseButton1Click:Connect(
    CloseMenu
)

--========================================================--
-- DRAG MAIN
--========================================================--

local Dragging = false
local DragStart
local StartPos

Header.InputBegan:Connect(function(Input)

    if Input.UserInputType
        == Enum.UserInputType.MouseButton1
        or Input.UserInputType
        == Enum.UserInputType.Touch then

        Dragging = true

        DragStart =
            Input.Position

        StartPos =
            Main.Position

        Input.Changed:Connect(function()

            if Input.UserInputState
                == Enum.UserInputState.End then

                Dragging = false

            end

        end)

    end

end)

UIS.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType
        ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType
        ~= Enum.UserInputType.Touch then

        return

    end

    local Delta =
        Input.Position
        -
        DragStart

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

local ButtonDragging = false
local ButtonStart
local ButtonPos

ADButton.InputBegan:Connect(function(Input)

    if Input.UserInputType
        == Enum.UserInputType.MouseButton1
        or Input.UserInputType
        == Enum.UserInputType.Touch then

        ButtonDragging = true

        ButtonStart =
            Input.Position

        ButtonPos =
            ADButton.Position

        Input.Changed:Connect(function()

            if Input.UserInputState
                == Enum.UserInputState.End then

                ButtonDragging = false

            end

        end)

    end

end)

UIS.InputChanged:Connect(function(Input)

    if not ButtonDragging then
        return
    end

    if Input.UserInputType
        ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType
        ~= Enum.UserInputType.Touch then

        return

    end

    local Delta =
        Input.Position
        -
        ButtonStart

    ADButton.Position =
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

print("AD loaded")
