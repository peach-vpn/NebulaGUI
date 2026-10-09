--========================================================--
--                    AD SCRIPT v2.0                    --
--      OPTIMIZED / FIXED / SMOOTH ANIMATIONS           --
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Camera update handler
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)

--========================================================--
-- SETTINGS
--========================================================--

local S = {
    Aim = false,
    AimFOV = 180,
    AimSmooth = 0.5,
    AimHead = true,
    TeamCheck = true,
    WallCheck = true,
    
    ESP = false,
    Box = true,
    Name = true,
    Health = true,
    Distance = true,
    
    Speed = false,
    SpeedValue = 28,
    AutoJump = false,
    AutoWalk = false,
    
    Spin = false,
    SpinSpeed = 8
}

--========================================================--
-- CLEANUP OLD GUI
--========================================================--

local Old = PlayerGui:FindFirstChild("AD_GUI")
if Old then Old:Destroy() end

--========================================================--
-- GUI CREATION HELPERS
--========================================================--

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    obj.Parent = props.Parent
    return obj
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = radius or UDim.new(0, 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(55, 55, 70),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

--========================================================--
-- MAIN GUI
--========================================================--

local GUI = Create("ScreenGui", {
    Name = "AD_GUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PlayerGui
})

-- AD Toggle Button
local AD = Create("TextButton", {
    Size = UDim2.fromOffset(58, 58),
    Position = UDim2.new(0, 18, 0.5, -29),
    BackgroundColor3 = Color3.fromRGB(20, 20, 28),
    Text = "AD",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Parent = GUI
})
AddCorner(AD, UDim.new(1, 0))
AddStroke(AD, Color3.fromRGB(135, 80, 255), 2)

-- Main Window
local Main = Create("Frame", {
    Size = UDim2.fromOffset(390, 430),
    Position = UDim2.new(0.5, -195, 0.5, -215),
    BackgroundColor3 = Color3.fromRGB(14, 14, 20),
    Visible = false,
    Parent = GUI
})
AddCorner(Main, UDim.new(0, 15))
AddStroke(Main, Color3.fromRGB(55, 55, 70), 1)

-- Header
local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundTransparency = 1,
    Parent = Main
})

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.fromOffset(17, 0),
    BackgroundTransparency = 1,
    Text = "AD",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header
})

local Back = Create("TextButton", {
    Size = UDim2.fromOffset(42, 36),
    Position = UDim2.new(1, -95, 0, 9),
    BackgroundColor3 = Color3.fromRGB(28, 28, 37),
    Text = "‹",
    TextColor3 = Color3.fromRGB(220, 220, 230),
    TextSize = 25,
    Font = Enum.Font.GothamBold,
    Visible = false,
    AutoButtonColor = false,
    Parent = Header
})
AddCorner(Back, UDim.new(0, 9))

local Close = Create("TextButton", {
    Size = UDim2.fromOffset(38, 36),
    Position = UDim2.new(1, -47, 0, 9),
    BackgroundColor3 = Color3.fromRGB(28, 28, 37),
    Text = "×",
    TextColor3 = Color3.fromRGB(230, 230, 235),
    TextSize = 23,
    Font = Enum.Font.Gotham,
    AutoButtonColor = false,
    Parent = Header
})
AddCorner(Close, UDim.new(0, 9))

-- Content
local Content = Create("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -65),
    Position = UDim2.fromOffset(10, 60),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(135, 80, 255),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(),
    Parent = Main
})

Create("UIPadding", {
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 12),
    Parent = Content
})

Create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Content
})

--========================================================--
-- UI COMPONENTS
--========================================================--

local function Clear()
    for _, v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
            v:Destroy()
        end
    end
end

local function Section(text)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(155, 105, 255),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Content
    })
end

local function Button(text, callback)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = Color3.fromRGB(23, 23, 31),
        Text = "",
        AutoButtonColor = false,
        Parent = Content
    })
    AddCorner(btn, UDim.new(0, 11))
    
    Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.fromOffset(16, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(230, 230, 235),
        TextSize = 15,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn
    })
    
    Create("TextLabel", {
        Size = UDim2.fromOffset(30, 55),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        Text = "›",
        TextColor3 = Color3.fromRGB(130, 130, 145),
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        Parent = btn
    })
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function Toggle(text, value, callback)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 43),
        BackgroundColor3 = Color3.fromRGB(23, 23, 31),
        Text = "",
        AutoButtonColor = false,
        Parent = Content
    })
    AddCorner(btn, UDim.new(0, 10))
    
    Create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.fromOffset(13, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(225, 225, 230),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn
    })
    
    local switch = Create("Frame", {
        Size = UDim2.fromOffset(40, 22),
        Position = UDim2.new(1, -53, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(55, 55, 65),
        Parent = btn
    })
    AddCorner(switch, UDim.new(1, 0))
    
    local dot = Create("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = Color3.fromRGB(235, 235, 240),
        Parent = switch
    })
    AddCorner(dot, UDim.new(1, 0))
    
    local function Update(instant)
        local targetColor = value and Color3.fromRGB(120, 70, 255) or Color3.fromRGB(55, 55, 65)
        local targetPos = value and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
        
        if instant then
            switch.BackgroundColor3 = targetColor
            dot.Position = targetPos
        else
            TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        value = not value
        Update(false)
        if callback then callback(value) end
    end)
    
    Update(true)
    return btn
end

local function Number(text, value, min, max, callback)
    local frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 43),
        BackgroundColor3 = Color3.fromRGB(23, 23, 31),
        Parent = Content
    })
    AddCorner(frame, UDim.new(0, 10))
    
    Create("TextLabel", {
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.fromOffset(13, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(225, 225, 230),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    local box = Create("TextBox", {
        Size = UDim2.fromOffset(88, 29),
        Position = UDim2.new(1, -98, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(34, 34, 44),
        Text = tostring(value),
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        ClearTextOnFocus = false,
        Parent = frame
    })
    AddCorner(box, UDim.new(0, 8))
    
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if not n then
            box.Text = tostring(value)
            return
        end
        n = math.clamp(n, min, max)
        value = n
        box.Text = tostring(n)
        if callback then callback(n) end
    end)
    
    return frame
end

--========================================================--
-- FOV CIRCLE
--========================================================--

local FOV = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(360, 360),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 100,
    Active = false, -- Don't block mouse
    Parent = GUI
})
AddCorner(FOV, UDim.new(1, 0))

local FOVStroke = AddStroke(FOV, Color3.fromRGB(150, 95, 255), 2, 0.15)

-- Center dot
local FOVDot = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(4, 4),
    BackgroundColor3 = Color3.fromRGB(150, 95, 255),
    Parent = FOV
})
AddCorner(FOVDot, UDim.new(1, 0))

local function UpdateFOV()
    local size = S.AimFOV * 2
    FOV.Size = UDim2.fromOffset(size, size)
end

--========================================================--
-- AIM SYSTEM
--========================================================--

local LockedTarget = nil

local function Alive(player)
    if not player then return false end
    local char = player.Character
    if not char then return false end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not root then return false end
    if humanoid.Health <= 0 then return false end
    return true
end

local function IsEnemy(player)
    if not Alive(player) then return false end
    if player == LP then return false end
    
    if S.TeamCheck then
        if LP.Team and player.Team and LP.Team == player.Team then
            return false
        end
    end
    return true
end

local function IsVisible(player)
    if not S.WallCheck then return true end
    
    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return false end
    
    local origin = Camera.CFrame.Position
    local direction = head.Position - origin
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character, Camera}
    
    local hit = workspace:Raycast(origin, direction, params)
    if not hit then return true end
    
    return hit.Instance:IsDescendantOf(char)
end

local function GetTargetPart(character)
    if S.AimHead then
        return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    else
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
    end
end

local function FindTarget()
    local view = Camera.ViewportSize
    local center = Vector2.new(view.X / 2, view.Y / 2)
    local best = nil
    local bestDist = S.AimFOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if IsEnemy(player) and IsVisible(player) then
            local char = player.Character
            local part = char and GetTargetPart(char)
            
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen and pos.Z > 0 then
                    local point = Vector2.new(pos.X, pos.Y)
                    local dist = (point - center).Magnitude
                    
                    if dist < bestDist then
                        bestDist = dist
                        best = player
                    end
                end
            end
        end
    end
    return best
end

--========================================================--
-- ESP SYSTEM
--========================================================--

local ESP = {}
local CharacterConnections = {}

local function RemoveESP(player)
    local data = ESP[player]
    if not data then return end
    
    for _, obj in pairs(data) do
        if typeof(obj) == "Instance" then
            pcall(function() obj:Destroy() end)
        end
    end
    ESP[player] = nil
end

local function CreateESP(player)
    if player == LP then return end
    RemoveESP(player)
    
    local box = Create("BoxHandleAdornment", {
        Size = Vector3.new(4, 6, 2),
        Color3 = Color3.fromRGB(145, 85, 255),
        Transparency = 0.55,
        AlwaysOnTop = true,
        ZIndex = 5,
        Visible = false
    })
    
    local billboard = Create("BillboardGui", {
        Size = UDim2.fromOffset(180, 65),
        StudsOffset = Vector3.new(0, 4, 0),
        AlwaysOnTop = true,
        Enabled = false
    })
    
    local text = Create("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        TextStrokeTransparency = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextWrapped = true,
        Parent = billboard
    })
    
    ESP[player] = {
        Box = box,
        Billboard = billboard,
        Text = text
    }
end

local function UpdateESP(player)
    local data = ESP[player]
    if not data then return end
    
    local char = player.Character
    if not char then
        data.Box.Visible = false
        data.Billboard.Enabled = false
        return
    end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid or humanoid.Health <= 0 then
        data.Box.Visible = false
        data.Billboard.Enabled = false
        return
    end
    
    -- Team check
    if S.TeamCheck and LP.Team and player.Team and LP.Team == player.Team then
        data.Box.Visible = false
        data.Billboard.Enabled = false
        return
    end
    
    -- Update box
    data.Box.Adornee = root
    data.Box.Visible = S.ESP and S.Box
    
    -- Update text
    local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
    local text = ""
    
    if S.Name then text = player.Name end
    if S.Health then
        if text ~= "" then text = text .. "\n" end
        text = text .. "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    end
    if S.Distance then
        if text ~= "" then text = text .. "\n" end
        text = text .. dist .. " studs"
    end
    
    data.Text.Text = text
    data.Billboard.Adornee = root
    data.Billboard.Enabled = S.ESP and (S.Name or S.Health or S.Distance)
end

-- ESP Player handlers
local function SetupPlayer(player)
    if player == LP then return end
    CreateESP(player)
    
    if CharacterConnections[player] then
        CharacterConnections[player]:Disconnect()
    end
    
    CharacterConnections[player] = player.CharacterAdded:Connect(function()
        task.wait(0.5)
        CreateESP(player)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        SetupPlayer(player)
    end)
end

Players.PlayerAdded:Connect(SetupPlayer)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    if CharacterConnections[player] then
        CharacterConnections[player]:Disconnect()
        CharacterConnections[player] = nil
    end
end)

--========================================================--
-- UNIFIED RENDER LOOP
--========================================================--

RunService.RenderStepped:Connect(function()
    -- ESP Updates
    for player in pairs(ESP) do
        local success, err = pcall(UpdateESP, player)
        if not success then
            -- Silently fail to avoid spam
        end
    end
    
    -- Aim Logic
    if S.Aim then
        if not IsEnemy(LockedTarget) then
            LockedTarget = FindTarget()
        end
        
        if LockedTarget and IsVisible(LockedTarget) then
            local char = LockedTarget.Character
            local targetPart = char and GetTargetPart(char)
            
            if targetPart then
                local desired = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(desired, math.clamp(S.AimSmooth, 0.01, 1))
            else
                LockedTarget = nil
            end
        else
            LockedTarget = nil
        end
    else
        LockedTarget = nil
    end
    
    -- AutoWalk
    if S.AutoWalk then
        local char = LP.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:Move(Vector3.new(0, 0, -1), true)
        end
    end
end)

--========================================================--
-- HEARTBEAT LOOP (Movement + Spin)
--========================================================--

RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    -- Speed & Jump
    if humanoid then
        if S.Speed then
            humanoid.WalkSpeed = S.SpeedValue
        end
        
        if S.AutoJump and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.Jump = true
        end
    end
    
    -- Spin
    if S.Spin and root then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(S.SpinSpeed * 60) * dt, 0)
    end
end)

--========================================================--
-- PAGES
--========================================================--

local CurrentPage = "Main"

local function MainPage()
    Clear()
    CurrentPage = "Main"
    Title.Text = "AD"
    Back.Visible = false
    
    Section("РАЗДЕЛЫ")
    
    Button("Аимбот", function() AimPage() end)
    Button("ESP", function() ESPPage() end)
    Button("Движение", function() MovementPage() end)
    Button("Крутилка", function() SpinPage() end)
end

function AimPage()
    Clear()
    CurrentPage = "Aim"
    Title.Text = "Аимбот"
    Back.Visible = true
    
    Section("НАСТРОЙКИ АИМА")
    
    Toggle("Включить аимбот", S.Aim, function(v)
        S.Aim = v
        FOV.Visible = v
        if not v then LockedTarget = nil end
    end)
    
    Toggle("Наведение в голову", S.AimHead, function(v)
        S.AimHead = v
    end)
    
    Toggle("Проверка команды", S.TeamCheck, function(v)
        S.TeamCheck = v
    end)
    
    Toggle("Проверка стен", S.WallCheck, function(v)
        S.WallCheck = v
    end)
    
    Number("Размер FOV", S.AimFOV, 30, 600, function(v)
        S.AimFOV = v
        UpdateFOV()
    end)
    
    Number("Скорость наведения", S.AimSmooth, 0.01, 1, function(v)
        S.AimSmooth = v
    end)
    
    Section("ТЕКУЩАЯ ЦЕЛЬ")
    
    local targetLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(23, 23, 31),
        Text = "Цель: нет",
        TextColor3 = Color3.fromRGB(220, 220, 230),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        Parent = Content
    })
    AddCorner(targetLabel, UDim.new(0, 10))
    
    -- Target updater
    task.spawn(function()
        while Main.Visible and CurrentPage == "Aim" do
            if Alive(LockedTarget) then
                local h = LockedTarget.Character:FindFirstChildOfClass("Humanoid")
                if h then
                    targetLabel.Text = "Цель: " .. LockedTarget.Name .. "\nHP: " .. math.floor(h.Health)
                end
            else
                targetLabel.Text = "Цель: нет"
            end
            task.wait(0.15)
        end
    end)
end

function ESPPage()
    Clear()
    CurrentPage = "ESP"
    Title.Text = "ESP"
    Back.Visible = true
    
    Section("ОСНОВНОЙ ESP")
    
    Toggle("Включить ESP", S.ESP, function(v) S.ESP = v end)
    Toggle("3D Box", S.Box, function(v) S.Box = v end)
    Toggle("Имя игрока", S.Name, function(v) S.Name = v end)
    Toggle("HP", S.Health, function(v) S.Health = v end)
    Toggle("Дистанция", S.Distance, function(v) S.Distance = v end)
    Toggle("Проверка команды", S.TeamCheck, function(v) S.TeamCheck = v end)
end

function MovementPage()
    Clear()
    CurrentPage = "Movement"
    Title.Text = "Движение"
    Back.Visible = true
    
    Section("ДВИЖЕНИЕ")
    
    Toggle("Быстрая ходьба", S.Speed, function(v) S.Speed = v end)
    Number("Скорость", S.SpeedValue, 16, 150, function(v) S.SpeedValue = v end)
    Toggle("Авто-прыжок", S.AutoJump, function(v) S.AutoJump = v end)
    Toggle("Авто-ходьба", S.AutoWalk, function(v) S.AutoWalk = v end)
end

function SpinPage()
    Clear()
    CurrentPage = "Spin"
    Title.Text = "Крутилка"
    Back.Visible = true
    
    Section("КРУТИЛКА")
    
    Toggle("Включить крутилку", S.Spin, function(v) S.Spin = v end)
    Number("Скорость", S.SpinSpeed, 1, 40, function(v) S.SpinSpeed = v end)
end

--========================================================--
-- DRAG FUNCTIONALITY
--========================================================--

local function MakeDraggable(dragHandle, dragTarget)
    local dragging = false
    local dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = dragTarget.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            dragTarget.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

MakeDraggable(Header, Main)
MakeDraggable(AD, AD)

--========================================================--
-- BUTTON CONNECTIONS
--========================================================--

Back.MouseButton1Click:Connect(MainPage)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

AD.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        MainPage()
    end
end)

--========================================================--
-- INIT
--========================================================--

UpdateFOV()
MainPage()
print("AD GUI v2.0 loaded")
