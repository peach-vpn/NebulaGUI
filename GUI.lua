--========================================================--
--                 UNIVERSAL AD SCRIPT v3.0               --
--     WORKS IN ANY GAME / SMOOTH ANIMS / THEMES          --
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)

--========================================================--
-- SETTINGS & THEMES
--========================================================--

local Themes = {
    Purple = {
        Accent = Color3.fromRGB(135, 80, 255),
        Accent2 = Color3.fromRGB(155, 105, 255),
        Background = Color3.fromRGB(14, 14, 20),
        Secondary = Color3.fromRGB(23, 23, 31),
        Text = Color3.fromRGB(230, 230, 235)
    },
    Red = {
        Accent = Color3.fromRGB(255, 60, 60),
        Accent2 = Color3.fromRGB(255, 100, 100),
        Background = Color3.fromRGB(20, 14, 14),
        Secondary = Color3.fromRGB(31, 23, 23),
        Text = Color3.fromRGB(235, 230, 230)
    },
    Blue = {
        Accent = Color3.fromRGB(60, 130, 255),
        Accent2 = Color3.fromRGB(100, 160, 255),
        Background = Color3.fromRGB(14, 17, 20),
        Secondary = Color3.fromRGB(23, 28, 31),
        Text = Color3.fromRGB(230, 235, 240)
    },
    Green = {
        Accent = Color3.fromRGB(60, 255, 130),
        Accent2 = Color3.fromRGB(100, 255, 160),
        Background = Color3.fromRGB(14, 20, 16),
        Secondary = Color3.fromRGB(23, 31, 26),
        Text = Color3.fromRGB(230, 240, 235)
    }
}

local CurrentTheme = "Purple"
local T = Themes[CurrentTheme]

local S = {
    Aim = false,
    AimFOV = 120,
    AimSmooth = 0.35,
    AimHead = true,
    TeamCheck = true,
    WallCheck = true,
    VisibleCheck = true,
    StickyTarget = true,
    Prediction = 0.1,
    
    ESP = false,
    Box = true,
    Name = true,
    Health = true,
    Distance = true,
    OffScreen = true,
    
    Speed = false,
    SpeedValue = 28,
    AutoJump = false,
    AutoWalk = false,
    
    Spin = false,
    SpinSpeed = 8
}

--========================================================--
-- CLEANUP
--========================================================--

local Old = PlayerGui:FindFirstChild("AD_GUI")
if Old then Old:Destroy() end

--========================================================--
-- HELPERS
--========================================================--

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = radius or UDim.new(0, 8), Parent = parent})
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or T.Accent,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

--========================================================--
-- GUI SETUP
--========================================================--

local GUI = Create("ScreenGui", {
    Name = "AD_GUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PlayerGui
})

-- AD Button
local AD = Create("TextButton", {
    Size = UDim2.fromOffset(50, 50),
    Position = UDim2.new(0, 15, 0.5, -25),
    BackgroundColor3 = T.Background,
    Text = "AD",
    TextColor3 = T.Accent,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Parent = GUI
})
AddCorner(AD, UDim.new(1, 0))
local ADStroke = AddStroke(AD, T.Accent, 2)

-- Main Window (компактнее)
local Main = Create("Frame", {
    Size = UDim2.fromOffset(320, 280),
    Position = UDim2.new(0.5, -160, 0.5, -140),
    BackgroundColor3 = T.Background,
    Visible = false,
    ClipsDescendants = true,
    Parent = GUI
})
AddCorner(Main, UDim.new(0, 12))
local MainStroke = AddStroke(Main, T.Accent, 1.5, 0.3)

-- Header
local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = T.Secondary,
    Parent = Main
})
AddCorner(Header, UDim.new(0, 12))

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "AD",
    TextColor3 = T.Accent,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header
})

local Back = Create("TextButton", {
    Size = UDim2.fromOffset(30, 26),
    Position = UDim2.new(1, -68, 0, 7),
    BackgroundColor3 = T.Background,
    Text = "‹",
    TextColor3 = T.Text,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    Visible = false,
    AutoButtonColor = false,
    Parent = Header
})
AddCorner(Back, UDim.new(0, 6))

local Close = Create("TextButton", {
    Size = UDim2.fromOffset(30, 26),
    Position = UDim2.new(1, -36, 0, 7),
    BackgroundColor3 = T.Background,
    Text = "×",
    TextColor3 = T.Text,
    TextSize = 18,
    Font = Enum.Font.Gotham,
    AutoButtonColor = false,
    Parent = Header
})
AddCorner(Close, UDim.new(0, 6))

-- Content с плавным скроллом
local Content = Create("ScrollingFrame", {
    Size = UDim2.new(1, -10, 1, -50),
    Position = UDim2.fromOffset(5, 45),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = T.Accent,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(),
    ElasticBehavior = Enum.ElasticBehavior.Always,
    Parent = Main
})

Create("UIPadding", {
    PaddingLeft = UDim.new(0, 3),
    PaddingRight = UDim.new(0, 3),
    PaddingBottom = UDim.new(0, 10),
    Parent = Content
})

Create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Content
})

--========================================================--
-- UI COMPONENTS (компактные)
--========================================================--

local function Clear()
    for _, v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
    end
end

local function Section(text)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = T.Accent2,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Content
    })
end

local function Button(text, callback)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = T.Secondary,
        Text = "",
        AutoButtonColor = false,
        Parent = Content
    })
    AddCorner(btn, UDim.new(0, 6))
    
    Create("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = T.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn
    })
    
    Create("TextLabel", {
        Size = UDim2.fromOffset(20, 32),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "›",
        TextColor3 = T.Accent,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = btn
    })
    
    btn.MouseEnter:Connect(function()
        Tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(
            math.floor(T.Secondary.R * 255 + 20),
            math.floor(T.Secondary.G * 255 + 20),
            math.floor(T.Secondary.B * 255 + 20)
        )})
    end)
    
    btn.MouseLeave:Connect(function()
        Tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = T.Secondary})
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function Toggle(text, value, callback)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = T.Secondary,
        Text = "",
        AutoButtonColor = false,
        Parent = Content
    })
    AddCorner(btn, UDim.new(0, 6))
    
    Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = T.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn
    })
    
    local switch = Create("Frame", {
        Size = UDim2.fromOffset(32, 16),
        Position = UDim2.new(1, -40, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        Parent = btn
    })
    AddCorner(switch, UDim.new(1, 0))
    
    local dot = Create("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = Color3.fromRGB(200, 200, 210),
        Parent = switch
    })
    AddCorner(dot, UDim.new(1, 0))
    
    local function Update(instant)
        local targetColor = value and T.Accent or Color3.fromRGB(50, 50, 60)
        local targetPos = value and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2)
        
        if instant then
            switch.BackgroundColor3 = targetColor
            dot.Position = targetPos
        else
            Tween(switch, TweenInfo.new(0.15), {BackgroundColor3 = targetColor})
            Tween(dot, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Position = targetPos})
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
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = T.Secondary,
        Parent = Content
    })
    AddCorner(frame, UDim.new(0, 6))
    
    Create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = T.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    local box = Create("TextBox", {
        Size = UDim2.fromOffset(55, 20),
        Position = UDim2.new(1, -62, 0.5, -10),
        BackgroundColor3 = T.Background,
        Text = tostring(value),
        TextColor3 = T.Accent,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        ClearTextOnFocus = false,
        Parent = frame
    })
    AddCorner(box, UDim.new(0, 4))
    
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if not n then box.Text = tostring(value) return end
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
    Size = UDim2.fromOffset(240, 240),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 100,
    Active = false,
    Parent = GUI
})
AddCorner(FOV, UDim.new(1, 0))
local FOVStroke = AddStroke(FOV, T.Accent, 1.5, 0.2)

local FOVDot = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(3, 3),
    BackgroundColor3 = T.Accent,
    Parent = FOV
})
AddCorner(FOVDot, UDim.new(1, 0))

local function UpdateFOV()
    local size = S.AimFOV * 2
    FOV.Size = UDim2.fromOffset(size, size)
end

--========================================================--
-- UNIVERSAL ESP (работает в любой игре)
--========================================================--

local ESP = {}
local CharacterCache = {}

local function GetCharacter(player)
    -- Кэш для производительности
    if CharacterCache[player] then
        local char = CharacterCache[player]
        if char and char.Parent then
            return char
        end
    end
    
    -- Стандартный путь
    local char = player.Character
    if char then
        CharacterCache[player] = char
        return char
    end
    
    -- Поиск в workspace (для игр с кастомными персонажами)
    local name = player.Name
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == name and (obj:FindFirstChild("Humanoid") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")) then
            CharacterCache[player] = obj
            return obj
        end
    end
    
    return nil
end

local function GetHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid") or char:FindFirstChild("Humanoid")
end

local function GetRootPart(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
end

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
    
    -- Основной Billboard
    local billboard = Create("BillboardGui", {
        Size = UDim2.fromOffset(120, 50),
        StudsOffset = Vector3.new(0, 2.5, 0),
        AlwaysOnTop = true,
        Enabled = false,
        MaxDistance = 800
    })
    
    -- Box (Frame)
    local box = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0.85,
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        Parent = billboard
    })
    AddCorner(box, UDim.new(0, 3))
    
    local stroke = Create("UIStroke", {
        Color = T.Accent,
        Thickness = 1.5,
        Transparency = 0.2,
        Parent = box
    })
    
    -- Имя
    local name = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        TextStrokeTransparency = 0.5,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = billboard
    })
    
    -- HP бар
    local hpBack = Create("Frame", {
        Size = UDim2.new(0.8, 0, 0, 3),
        Position = UDim2.new(0.1, 0, 1, -8),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Parent = billboard
    })
    AddCorner(hpBack, UDim.new(1, 0))
    
    local hpFill = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(60, 255, 100),
        BorderSizePixel = 0,
        Parent = hpBack
    })
    AddCorner(hpFill, UDim.new(1, 0))
    
    -- Дистанция
    local dist = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -6),
        BackgroundTransparency = 1,
        TextColor3 = T.Accent2,
        TextStrokeTransparency = 0.5,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        Parent = billboard
    })
    
    ESP[player] = {
        Billboard = billboard,
        Box = box,
        Name = name,
        HPBack = hpBack,
        HPFill = hpFill,
        Dist = dist
    }
end

local function UpdateESP(player)
    local data = ESP[player]
    if not data then return end
    
    local char = GetCharacter(player)
    if not char then
        data.Billboard.Enabled = false
        return
    end
    
    local humanoid = GetHumanoid(char)
    local root = GetRootPart(char)
    
    if not root or (humanoid and humanoid.Health <= 0) then
        data.Billboard.Enabled = false
        return
    end
    
    -- Team check
    if S.TeamCheck and LP.Team and player.Team and LP.Team == player.Team then
        data.Billboard.Enabled = false
        return
    end
    
    local cameraPos = Camera.CFrame.Position
    local distance = (root.Position - cameraPos).Magnitude
    
    -- Обновляем позицию
    data.Billboard.Adornee = root
    data.Billboard.Enabled = S.ESP
    
    if not S.ESP then return end
    
    -- Имя
    data.Name.Text = S.Name and player.Name or ""
    data.Name.Visible = S.Name
    
    -- HP
    if S.Health and humanoid then
        local hp = humanoid.Health / humanoid.MaxHealth
        data.HPFill.Size = UDim2.fromScale(math.clamp(hp, 0, 1), 1)
        data.HPFill.BackgroundColor3 = hp > 0.5 and Color3.fromRGB(60, 255, 100) or (hp > 0.25 and Color3.fromRGB(255, 200, 60) or Color3.fromRGB(255, 60, 60))
        data.HPBack.Visible = true
    else
        data.HPBack.Visible = false
    end
    
    -- Дистанция
    data.Dist.Text = S.Distance and math.floor(distance) .. "m" or ""
    data.Dist.Visible = S.Distance
    
    -- Box
    data.Box.Visible = S.Box
    
    -- Размер по дистанции
    local scale = math.clamp(1 - (distance / 500), 0.5, 1)
    data.Billboard.Size = UDim2.fromOffset(120 * scale, 50 * scale)
end

-- ESP Player handlers
local function SetupPlayer(player)
    if player == LP then return end
    CreateESP(player)
end

for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function() SetupPlayer(player) end)
end

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    CharacterCache[player] = nil
end)

--========================================================--
-- IMPROVED AIM (Sticky + Prediction + Priority)
--========================================================--

local LockedTarget = nil
local LastTargetPosition = nil

local function IsEnemy(player)
    if not player or player == LP then return false end
    
    if S.TeamCheck and LP.Team and player.Team and LP.Team == player.Team then
        return false
    end
    
    return true
end

local function IsVisible(player, part)
    if not S.WallCheck then return true end
    
    local char = GetCharacter(player)
    if not char then return false end
    
    local targetPart = part or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not targetPart then return false end
    
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character, Camera}
    
    local hit = workspace:Raycast(origin, direction, params)
    if not hit then return true end
    
    return hit.Instance:IsDescendantOf(char)
end

local function GetAimPart(character)
    if not character then return nil end
    
    if S.AimHead then
        return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    else
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Head")
    end
end

local function GetPredictedPosition(player, part)
    if not part then return nil end
    
    local velocity = part.Velocity
    local distance = (part.Position - Camera.CFrame.Position).Magnitude
    local timeToTarget = distance / 1000 -- приблизительное время
    
    return part.Position + (velocity * S.Prediction * timeToTarget)
end

local function FindTarget()
    local view = Camera.ViewportSize
    local center = Vector2.new(view.X / 2, view.Y / 2)
    local best = nil
    local bestScore = S.AimFOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if IsEnemy(player) then
            local char = GetCharacter(player)
            local part = char and GetAimPart(char)
            
            if part and IsVisible(player, part) then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                
                if onScreen and pos.Z > 0 then
                    local point = Vector2.new(pos.X, pos.Y)
                    local dist = (point - center).Magnitude
                    
                    -- Приоритет: ближе к центру + ближе к нам
                    local distanceToPlayer = (part.Position - Camera.CFrame.Position).Magnitude
                    local score = dist + (distanceToPlayer * 0.1) -- небольшой бонус за близость
                    
                    if score < bestScore then
                        bestScore = score
                        best = player
                    end
                end
            end
        end
    end
    
    return best
end

--========================================================--
-- UNIFIED RENDER LOOP
--========================================================--

RunService.RenderStepped:Connect(function(dt)
    -- ESP Updates
    for player in pairs(ESP) do
        pcall(UpdateESP, player)
    end
    
    -- Aim Logic
    if S.Aim then
        -- Sticky target или новый поиск
        if S.StickyTarget and LockedTarget then
            local char = GetCharacter(LockedTarget)
            local part = char and GetAimPart(char)
            
            if not part or not IsVisible(LockedTarget, part) then
                LockedTarget = nil
            end
        end
        
        if not LockedTarget then
            LockedTarget = FindTarget()
        end
        
        if LockedTarget then
            local char = GetCharacter(LockedTarget)
            local part = char and GetAimPart(char)
            
            if part then
                local targetPos = GetPredictedPosition(LockedTarget, part) or part.Position
                local desired = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                
                -- Плавное наведение с учётом FPS
                local smooth = math.clamp(S.AimSmooth * (dt * 60), 0.01, 1)
                Camera.CFrame = Camera.CFrame:Lerp(desired, smooth)
            end
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
-- HEARTBEAT (Movement + Spin)
--========================================================--

RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if humanoid then
        if S.Speed then
            humanoid.WalkSpeed = S.SpeedValue
        end
        
        if S.AutoJump and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.Jump = true
        end
    end
    
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
    
    Section("ФУНКЦИИ")
    
    Button("Аимбот", function() AimPage() end)
    Button("ESP", function() ESPPage() end)
    Button("Движение", function() MovementPage() end)
    Button("Крутилка", function() SpinPage() end)
    Button("Тема: " .. CurrentTheme, function() 
        -- Смена темы
        local themes = {"Purple", "Red", "Blue", "Green"}
        local idx = table.find(themes, CurrentTheme) or 1
        CurrentTheme = themes[(idx % #themes) + 1]
        T = Themes[CurrentTheme]
        
        -- Обновляем цвета
        ADStroke.Color = T.Accent
        MainStroke.Color = T.Accent
        FOVStroke.Color = T.Accent
        FOVDot.BackgroundColor3 = T.Accent
        Title.TextColor3 = T.Accent
        AD.TextColor3 = T.Accent
        
        MainPage() -- Перерисовываем
    end)
end

function AimPage()
    Clear()
    CurrentPage = "Aim"
    Title.Text = "Аимбот"
    Back.Visible = true
    
    Section("НАСТРОЙКИ")
    
    Toggle("Включить", S.Aim, function(v)
        S.Aim = v
        FOV.Visible = v
        if not v then LockedTarget = nil end
    end)
    
    Toggle("В голову", S.AimHead, function(v) S.AimHead = v end)
    Toggle("Sticky Target", S.StickyTarget, function(v) S.StickyTarget = v end)
    Toggle("Проверка команды", S.TeamCheck, function(v) S.TeamCheck = v end)
    Toggle("Проверка стен", S.WallCheck, function(v) S.WallCheck = v end)
    
    Section("ПАРАМЕТРЫ")
    
    Number("FOV", S.AimFOV, 10, 800, function(v)
        S.AimFOV = v
        UpdateFOV()
    end)
    
    Number("Плавность", S.AimSmooth, 0.01, 1, function(v) S.AimSmooth = v end)
    Number("Предикшн", S.Prediction, 0, 2, function(v) S.Prediction = v end)
end

function ESPPage()
    Clear()
    CurrentPage = "ESP"
    Title.Text = "ESP"
    Back.Visible = true
    
    Section("ОТОБРАЖЕНИЕ")
    
    Toggle("Включить ESP", S.ESP, function(v) S.ESP = v end)
    Toggle("Бокс", S.Box, function(v) S.Box = v end)
    Toggle("Имя", S.Name, function(v) S.Name = v end)
    Toggle("HP бар", S.Health, function(v) S.Health = v end)
    Toggle("Дистанция", S.Distance, function(v) S.Distance = v end)
    Toggle("Проверка команды", S.TeamCheck, function(v) S.TeamCheck = v end)
end

function MovementPage()
    Clear()
    CurrentPage = "Movement"
    Title.Text = "Движение"
    Back.Visible = true
    
    Section("НАСТРОЙКИ")
    
    Toggle("Скорость", S.Speed, function(v) S.Speed = v end)
    Number("Значение", S.SpeedValue, 16, 500, function(v) S.SpeedValue = v end)
    Toggle("Авто-прыжок", S.AutoJump, function(v) S.AutoJump = v end)
    Toggle("Авто-ходьба", S.AutoWalk, function(v) S.AutoWalk = v end)
end

function SpinPage()
    Clear()
    CurrentPage = "Spin"
    Title.Text = "Крутилка"
    Back.Visible = true
    
    Section("НАСТРОЙКИ")
    
    Toggle("Включить", S.Spin, function(v) S.Spin = v end)
    Number("Скорость", S.SpinSpeed, 1, 50, function(v) S.SpinSpeed = v end)
end

--========================================================--
-- DRAG & INPUT
--========================================================--

local function MakeDraggable(handle, target)
    local dragging = false
    local dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(Header, Main)
MakeDraggable(AD, AD)

--========================================================--
-- CONNECTIONS
--========================================================--

Back.MouseButton1Click:Connect(MainPage)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

AD.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        -- Анимация появления
        Main.Size = UDim2.fromOffset(0, 0)
        Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(320, 280)})
        MainPage()
    end
end)

--========================================================--
-- INIT
--========================================================--

UpdateFOV()
MainPage()
print("AD Universal v3.0 loaded")
