--========================================================--
--                 UNIVERSAL AD SCRIPT v3.1               --
--   Fixes: aim honesty, autowalk, char cache, input leak --
--   Client-side only. Не даёт серверного преимущества.   --
--========================================================--

--// Cleanup прошлого запуска
if _G.__AD_CLEANUP then pcall(_G.__AD_CLEANUP) _G.__AD_CLEANUP = nil end

local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")
local TweenService  = game:GetService("TweenService")
local CoreGui       = game:GetService("CoreGui")

local LP = Players.LocalPlayer
if not LP then return end
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local conns = {}
local function bind(conn) table.insert(conns, conn) return conn end
local function disconnectAll()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
end

bind(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end))

--// ---------------- THEMES ----------------
local Themes = {
    Purple = {Accent=Color3.fromRGB(135,80,255),  Accent2=Color3.fromRGB(155,105,255), Bg=Color3.fromRGB(14,14,20),  Sec=Color3.fromRGB(23,23,31), Text=Color3.fromRGB(230,230,235)},
    Red    = {Accent=Color3.fromRGB(255,60,60),   Accent2=Color3.fromRGB(255,100,100), Bg=Color3.fromRGB(20,14,14),  Sec=Color3.fromRGB(31,23,23), Text=Color3.fromRGB(235,230,230)},
    Blue   = {Accent=Color3.fromRGB(60,130,255),  Accent2=Color3.fromRGB(100,160,255), Bg=Color3.fromRGB(14,17,20),  Sec=Color3.fromRGB(23,28,31), Text=Color3.fromRGB(230,235,240)},
    Green  = {Accent=Color3.fromRGB(60,255,130),  Accent2=Color3.fromRGB(100,255,160), Bg=Color3.fromRGB(14,20,16),  Sec=Color3.fromRGB(23,31,26), Text=Color3.fromRGB(230,240,235)},
}
local CurrentTheme = "Purple"
local T = Themes[CurrentTheme]

--// ---------------- SETTINGS ----------------
local S = {
    -- Camera lock (честно: это не "aimbot")
    Aim = false, AimFOV = 120, AimSmooth = 0.35, AimHead = true,
    TeamCheck = true, WallCheck = true, StickyTarget = true,

    ESP = false, Box = true, Name = true, Health = true, Distance = true,

    Speed = false, SpeedValue = 28,
    AutoJump = false, AutoWalk = false,

    Spin = false, SpinSpeed = 8,
}

--// ---------------- GUI PARENT ----------------
local function guiParent()
    if gethui then local ok,h = pcall(gethui) if ok and h then return h end end
    if CoreGui then return CoreGui end
    return PlayerGui
end
local PARENT = guiParent()

local old = PARENT:FindFirstChild("AD_GUI")
if old then old:Destroy() end

--// ---------------- BUILDERS ----------------
local function Create(class, props)
    local o = Instance.new(class)
    local parent = props.Parent
    for k,v in pairs(props) do
        if k ~= "Parent" then o[k] = v end
    end
    o.Parent = parent
    return o
end
local function Corner(p, r) return Create("UICorner",{CornerRadius=r or UDim.new(0,8),Parent=p}) end
local function Stroke(p, c, th, tr)
    return Create("UIStroke",{Color=c or T.Accent, Thickness=th or 1, Transparency=tr or 0, Parent=p})
end
local function Tween(o, info, props) TweenService:Create(o, info, props):Play() end

--// ---------------- GUI ----------------
local GUI = Create("ScreenGui",{
    Name="AD_GUI", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=PARENT
})
bind(GUI.Destroying:Connect(disconnectAll))

-- Floating button
local AD = Create("TextButton",{
    Size=UDim2.fromOffset(50,50), Position=UDim2.new(0,15,0.5,-25),
    BackgroundColor3=T.Bg, Text="AD", TextColor3=T.Accent, TextSize=16,
    Font=Enum.Font.GothamBold, AutoButtonColor=false, Parent=GUI
})
Corner(AD, UDim.new(1,0))
local ADStroke = Stroke(AD, T.Accent, 2)

-- Main window
local Main = Create("Frame",{
    Size=UDim2.fromOffset(320,290), Position=UDim2.new(0.5,-160,0.5,-145),
    BackgroundColor3=T.Bg, Visible=false, ClipsDescendants=true, Parent=GUI
})
Corner(Main, UDim.new(0,12))
local MainStroke = Stroke(Main, T.Accent, 1.5, 0.3)

-- Header
local Header = Create("Frame",{
    Size=UDim2.new(1,0,0,40), BackgroundColor3=T.Sec, Parent=Main
})
Corner(Header, UDim.new(0,12))

local Title = Create("TextLabel",{
    Size=UDim2.new(1,-80,1,0), Position=UDim2.fromOffset(12,0),
    BackgroundTransparency=1, Text="AD", TextColor3=T.Accent, TextSize=16,
    Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=Header
})

local Back = Create("TextButton",{
    Size=UDim2.fromOffset(30,26), Position=UDim2.new(1,-68,0,7),
    BackgroundColor3=T.Bg, Text="‹", TextColor3=T.Text, TextSize=20,
    Font=Enum.Font.GothamBold, Visible=false, AutoButtonColor=false, Parent=Header
})
Corner(Back, UDim.new(0,6))

local Close = Create("TextButton",{
    Size=UDim2.fromOffset(30,26), Position=UDim2.new(1,-36,0,7),
    BackgroundColor3=T.Bg, Text="×", TextColor3=T.Text, TextSize=18,
    Font=Enum.Font.Gotham, AutoButtonColor=false, Parent=Header
})
Corner(Close, UDim.new(0,6))

-- Content
local Content = Create("ScrollingFrame",{
    Size=UDim2.new(1,-10,1,-50), Position=UDim2.fromOffset(5,45),
    BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2,
    ScrollBarImageColor3=T.Accent, ScrollingDirection=Enum.ScrollingDirection.Y,
    AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(),
    ElasticBehavior=Enum.ElasticBehavior.Always, Parent=Main
})
Create("UIPadding",{PaddingLeft=UDim.new(0,3),PaddingRight=UDim.new(0,3),PaddingBottom=UDim.new(0,10),Parent=Content})
Create("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder,Parent=Content})

--// ---------------- COMPONENTS ----------------
local function Clear()
    for _,v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
    end
end

local function Section(text)
    return Create("TextLabel",{
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, Text=text,
        TextColor3=T.Accent2, TextSize=12, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=Content
    })
end

local function Button(text, cb)
    local b = Create("TextButton",{
        Size=UDim2.new(1,0,0,32), BackgroundColor3=T.Sec, Text="",
        AutoButtonColor=false, Parent=Content
    })
    Corner(b, UDim.new(0,6))
    Create("TextLabel",{Size=UDim2.new(1,-30,1,0),Position=UDim2.fromOffset(10,0),
        BackgroundTransparency=1,Text=text,TextColor3=T.Text,TextSize=13,
        Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left,Parent=b})
    Create("TextLabel",{Size=UDim2.fromOffset(20,32),Position=UDim2.new(1,-25,0,0),
        BackgroundTransparency=1,Text="›",TextColor3=T.Accent,TextSize=16,
        Font=Enum.Font.GothamBold,Parent=b})
    b.MouseButton1Click:Connect(cb)
    return b
end

local function Toggle(text, initial, cb)
    local state = {v = initial}
    local b = Create("TextButton",{
        Size=UDim2.new(1,0,0,28), BackgroundColor3=T.Sec, Text="",
        AutoButtonColor=false, Parent=Content
    })
    Corner(b, UDim.new(0,6))
    Create("TextLabel",{Size=UDim2.new(1,-50,1,0),Position=UDim2.fromOffset(10,0),
        BackgroundTransparency=1,Text=text,TextColor3=T.Text,TextSize=12,
        Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left,Parent=b})

    local sw = Create("Frame",{Size=UDim2.fromOffset(32,16),Position=UDim2.new(1,-40,0.5,-8),
        BackgroundColor3=Color3.fromRGB(50,50,60),Parent=b})
    Corner(sw, UDim.new(1,0))
    local dot = Create("Frame",{Size=UDim2.fromOffset(12,12),Position=UDim2.fromOffset(2,2),
        BackgroundColor3=Color3.fromRGB(200,200,210),Parent=sw})
    Corner(dot, UDim.new(1,0))

    local function apply(instant)
        local col = state.v and T.Accent or Color3.fromRGB(50,50,60)
        local pos = state.v and UDim2.fromOffset(18,2) or UDim2.fromOffset(2,2)
        if instant then sw.BackgroundColor3 = col; dot.Position = pos
        else
            Tween(sw, TweenInfo.new(0.15), {BackgroundColor3=col})
            Tween(dot, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Position=pos})
        end
    end
    apply(true)
    b.MouseButton1Click:Connect(function()
        state.v = not state.v
        apply(false)
        if cb then local ok,err = pcall(cb, state.v) if not ok then warn(err) end end
    end)
    return b, state
end

local function Number(text, initial, min, max, cb)
    local f = Create("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=T.Sec,Parent=Content})
    Corner(f, UDim.new(0,6))
    Create("TextLabel",{Size=UDim2.new(1,-70,1,0),Position=UDim2.fromOffset(10,0),
        BackgroundTransparency=1,Text=text,TextColor3=T.Text,TextSize=12,
        Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local box = Create("TextBox",{Size=UDim2.fromOffset(55,20),Position=UDim2.new(1,-62,0.5,-10),
        BackgroundColor3=T.Bg,Text=tostring(initial),TextColor3=T.Accent,TextSize=11,
        Font=Enum.Font.GothamBold,ClearTextOnFocus=false,Parent=f})
    Corner(box, UDim.new(0,4))
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if not n then box.Text = tostring(initial) return end
        n = math.clamp(n, min, max)
        box.Text = tostring(n)
        if cb then local ok,err = pcall(cb, n) if not ok then warn(err) end end
    end)
    return f
end

--// ---------------- FOV CIRCLE ----------------
local FOV = Create("Frame",{
    AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
    Size=UDim2.fromOffset(240,240), BackgroundTransparency=1, Visible=false,
    ZIndex=100, Active=false, Parent=GUI
})
Corner(FOV, UDim.new(1,0))
local FOVStroke = Stroke(FOV, T.Accent, 1.5, 0.2)
local FOVDot = Create("Frame",{
    AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
    Size=UDim2.fromOffset(3,3), BackgroundColor3=T.Accent, Parent=FOV
})
Corner(FOVDot, UDim.new(1,0))
local function UpdateFOV() FOV.Size = UDim2.fromOffset(S.AimFOV*2, S.AimFOV*2) end

--// ---------------- CHARACTER CACHE (event-based) ----------------
local CharCache = {}   -- [player] = character or nil

local function isAlive(char)
    if not char or not char.Parent or not char:IsDescendantOf(workspace) then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

local function setCharacter(player, char)
    CharCache[player] = char
    if not char then return end
    bind(char.AncestryChanged:Connect(function(_, parent)
        if not parent then CharCache[player] = nil end
    end))
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP then
        setCharacter(plr, plr.Character)
        bind(plr.CharacterAdded:Connect(function(c)
            task.wait(0.2)
            setCharacter(plr, c)
        end))
        bind(plr.CharacterRemoving:Connect(function()
            CharCache[plr] = nil
        end))
    end
end

bind(Players.PlayerAdded:Connect(function(plr)
    if plr == LP then return end
    setCharacter(plr, plr.Character)
    bind(plr.CharacterAdded:Connect(function(c)
        task.wait(0.2)
        setCharacter(plr, c)
    end))
    bind(plr.CharacterRemoving:Connect(function() CharCache[plr] = nil end))
end))

bind(Players.PlayerRemoving:Connect(function(plr)
    CharCache[plr] = nil
end))

local function getCharacter(player) return CharCache[player] end
local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Head")
end

--// ---------------- ESP ----------------
local ESPData = {}
local espFolder = Create("Folder",{Name="AD_ESP", Parent=PARENT})
bind(espFolder.Destroying:Connect(function() end))

local function removeESP(player)
    local d = ESPData[player]
    if not d then return end
    for _, obj in pairs(d) do
        if typeof(obj) == "Instance" then pcall(function() obj:Destroy() end) end
    end
    ESPData[player] = nil
end

local function createESP(player)
    if player == LP or ESPData[player] then return end

    local bb = Create("BillboardGui",{
        Size=UDim2.fromOffset(120,50), StudsOffset=Vector3.new(0,2.6,0),
        AlwaysOnTop=true, Enabled=false, MaxDistance=500, Parent=espFolder
    })

    local box = Create("Frame",{
        Size=UDim2.fromScale(1,1), BackgroundTransparency=0.85,
        BackgroundColor3=T.Accent, BorderSizePixel=0, Parent=bb
    })
    Corner(box, UDim.new(0,3))
    local stroke = Stroke(box, T.Accent, 1.5, 0.2)

    local name = Create("TextLabel",{
        Size=UDim2.new(1,0,0,14), BackgroundTransparency=1,
        TextColor3=Color3.new(1,1,1), TextStrokeTransparency=0.5,
        Font=Enum.Font.GothamBold, TextSize=11, Parent=bb
    })

    local hpBack = Create("Frame",{
        Size=UDim2.new(0.8,0,0,3), Position=UDim2.new(0.1,0,1,-8),
        BackgroundColor3=Color3.fromRGB(40,40,50), BorderSizePixel=0, Parent=bb
    })
    Corner(hpBack, UDim.new(1,0))
    local hpFill = Create("Frame",{
        Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.fromRGB(60,255,100),
        BorderSizePixel=0, Parent=hpBack
    })
    Corner(hpFill, UDim.new(1,0))

    local dist = Create("TextLabel",{
        Size=UDim2.new(1,0,0,12), Position=UDim2.new(0,0,1,-6),
        BackgroundTransparency=1, TextColor3=T.Accent2, TextStrokeTransparency=0.5,
        Font=Enum.Font.Gotham, TextSize=10, Parent=bb
    })

    ESPData[player] = {Billboard=bb, Box=box, Stroke=stroke, Name=name,
                       HPBack=hpBack, HPFill=hpFill, Dist=dist}
end

--// ---------------- AIM (Camera Lock, НЕ aimbot) ----------------
local LockedTarget = nil

local function isEnemy(player)
    if not player or player == LP then return false end
    if S.TeamCheck and LP.Team and player.Team and LP.Team == player.Team then return false end
    return true
end

local function isVisible(char, part)
    if not S.WallCheck then return true end
    if not part or not Camera then return false end
    local origin = Camera.CFrame.Position
    local dir = part.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {Camera}
    if LP.Character then table.insert(filter, LP.Character) end
    params.FilterDescendantsInstances = filter
    local hit = workspace:Raycast(origin, dir, params)
    if not hit then return true end
    return hit.Instance:IsDescendantOf(char)
end

local function getAimPart(char)
    if not char then return nil end
    if S.AimHead then
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function findTarget()
    if not Camera then return nil end
    local view = Camera.ViewportSize
    local center = Vector2.new(view.X/2, view.Y/2)
    local best, bestScore = nil, S.AimFOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if isEnemy(plr) then
            local char = getCharacter(plr)
            if char and isAlive(char) then
                local part = getAimPart(char)
                if part and isVisible(char, part) then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen and pos.Z > 0 then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < bestScore then bestScore = d; best = plr end
                    end
                end
            end
        end
    end
    return best
end

--// ---------------- UNIFIED RENDER (30 Hz for ESP) ----------------
local accum = 0
local UPDATE_STEP = 1/30

bind(RunService.RenderStepped:Connect(function(dt)
    -- Aim: каждый кадр (иначе дёргается)
    if S.Aim and Camera then
        if S.StickyTarget and LockedTarget then
            local c = getCharacter(LockedTarget)
            local p = c and getAimPart(c)
            if not p or not isAlive(c) or not isVisible(c, p) then LockedTarget = nil end
        end
        if not LockedTarget then LockedTarget = findTarget() end
        if LockedTarget then
            local c = getCharacter(LockedTarget)
            local p = c and getAimPart(c)
            if p then
                local desired = CFrame.lookAt(Camera.CFrame.Position, p.Position)
                local smooth = math.clamp(S.AimSmooth * (dt * 60), 0.01, 1)
                Camera.CFrame = Camera.CFrame:Lerp(desired, smooth)
            end
        end
    else
        LockedTarget = nil
    end

    -- ESP throttled
    accum = accum + dt
    if accum >= UPDATE_STEP then
        accum = 0
        if S.ESP then
            local camPos = Camera and Camera.CFrame.Position or Vector3.zero
            for plr, d in pairs(ESPData) do
                local char = getCharacter(plr)
                if not char or not isAlive(char) or not isEnemy(plr) then
                    d.Billboard.Enabled = false
                else
                    local root = getRoot(char)
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if root then
                        d.Billboard.Adornee = root
                        d.Billboard.Enabled = true

                        local distance = (root.Position - camPos).Magnitude
                        if distance > 500 then
                            d.Billboard.Enabled = false
                        else
                            d.Name.Text = S.Name and plr.Name or ""
                            d.Name.Visible = S.Name

                            if S.Health and hum then
                                local ratio = hum.Health / math.max(hum.MaxHealth, 1)
                                d.HPFill.Size = UDim2.fromScale(math.clamp(ratio,0,1),1)
                                d.HPFill.BackgroundColor3 = ratio > 0.5
                                    and Color3.fromRGB(60,255,100)
                                    or ratio > 0.25
                                    and Color3.fromRGB(255,200,60)
                                    or Color3.fromRGB(255,60,60)
                                d.HPBack.Visible = true
                            else
                                d.HPBack.Visible = false
                            end

                            d.Dist.Text = S.Distance and (math.floor(distance).."m") or ""
                            d.Dist.Visible = S.Distance
                            d.Box.Visible = S.Box

                            local scale = math.clamp(1 - distance/700, 0.55, 1)
                            d.Billboard.Size = UDim2.fromOffset(120*scale, 50*scale)
                        end
                    end
                end
            end
        else
            for _, d in pairs(ESPData) do d.Billboard.Enabled = false end
        end
    end
end))

--// ---------------- HEARTBEAT (movement / spin) ----------------
bind(RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum then
        if S.Speed then hum.WalkSpeed = S.SpeedValue end
        if S.AutoJump and hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end
    end

    -- AutoWalk: движение в МИРОВЫХ координатах вперёд камеры,
    -- спроецированное на плоскость персонажа
    if S.AutoWalk and hum and root and Camera then
        local look = Camera.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0.01 then
            hum:Move(flat.Unit, false)
        end
    end

    -- Spin: только для игр без серверного контроля CFrame.
    -- Во многих играх сервер откатит это движение.
    if S.Spin and root then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(S.SpinSpeed*60)*dt, 0)
    end
end))

--// ---------------- PAGES ----------------
local function MainPage()
    Clear()
    Title.Text = "AD"; Back.Visible = false
    Section("ФУНКЦИИ")
    Button("Camera Lock", function() AimPage() end)
    Button("ESP",          function() ESPPage() end)
    Button("Движение",     function() MovementPage() end)
    Button("Крутилка",     function() SpinPage() end)
    Button("Тема: "..CurrentTheme, function()
        local order = {"Purple","Red","Blue","Green"}
        local i = table.find(order, CurrentTheme) or 1
        CurrentTheme = order[(i % #order) + 1]
        T = Themes[CurrentTheme]
        ADStroke.Color = T.Accent
        MainStroke.Color = T.Accent
        FOVStroke.Color = T.Accent
        FOVDot.BackgroundColor3 = T.Accent
        Title.TextColor3 = T.Accent
        AD.TextColor3 = T.Accent
        MainPage()
    end)
end

function AimPage()
    Clear(); Title.Text = "Camera Lock"; Back.Visible = true
    Section("ВНИМАНИЕ")
    Create("TextLabel",{
        Size=UDim2.new(1,0,0,44), BackgroundColor3=T.Sec,
        Text="Это поворот камеры. Урон не гарантируется, если игра использует серверный хитскан.",
        TextWrapped=true, TextColor3=T.Accent2, TextSize=10,
        Font=Enum.Font.Gotham, Parent=Content
    })
    Section("НАСТРОЙКИ")
    Toggle("Включить", S.Aim, function(v) S.Aim=v; FOV.Visible=v; if not v then LockedTarget=nil end end)
    Toggle("В голову", S.AimHead, function(v) S.AimHead=v end)
    Toggle("Sticky", S.StickyTarget, function(v) S.StickyTarget=v end)
    Toggle("TeamCheck", S.TeamCheck, function(v) S.TeamCheck=v end)
    Toggle("WallCheck", S.WallCheck, function(v) S.WallCheck=v end)
    Section("ПАРАМЕТРЫ")
    Number("FOV", S.AimFOV, 10, 800, function(v) S.AimFOV=v; UpdateFOV() end)
    Number("Плавность", S.AimSmooth, 0.01, 1, function(v) S.AimSmooth=v end)
end

function ESPPage()
    Clear(); Title.Text = "ESP"; Back.Visible = true
    Section("ОТОБРАЖЕНИЕ")
    Toggle("Включить ESP", S.ESP, function(v) S.ESP=v end)
    Toggle("Бокс", S.Box, function(v) S.Box=v end)
    Toggle("Имя", S.Name, function(v) S.Name=v end)
    Toggle("HP", S.Health, function(v) S.Health=v end)
    Toggle("Дистанция", S.Distance, function(v) S.Distance=v end)
    Toggle("TeamCheck", S.TeamCheck, function(v) S.TeamCheck=v end)
end

function MovementPage()
    Clear(); Title.Text = "Движение"; Back.Visible = true
    Toggle("Скорость", S.Speed, function(v) S.Speed=v end)
    Number("Значение", S.SpeedValue, 16, 500, function(v) S.SpeedValue=v end)
    Toggle("Авто-прыжок", S.AutoJump, function(v) S.AutoJump=v end)
    Toggle("Авто-ходьба", S.AutoWalk, function(v) S.AutoWalk=v end)
    Create("TextLabel",{
        Size=UDim2.new(1,0,0,32), BackgroundColor3=T.Sec,
        Text="Скорость выше ~40 studs античит обычно видит. Используй осторожно.",
        TextWrapped=true, TextColor3=T.Accent2, TextSize=10,
        Font=Enum.Font.Gotham, Parent=Content
    })
end

function SpinPage()
    Clear(); Title.Text = "Крутилка"; Back.Visible = true
    Toggle("Включить", S.Spin, function(v) S.Spin=v end)
    Number("Скорость", S.SpinSpeed, 1, 50, function(v) S.SpinSpeed=v end)
    Create("TextLabel",{
        Size=UDim2.new(1,0,0,32), BackgroundColor3=T.Sec,
        Text="Работает только там, где сервер не откатывает CFrame персонажа.",
        TextWrapped=true, TextColor3=T.Accent2, TextSize=10,
        Font=Enum.Font.Gotham, Parent=Content
    })
end

--// ---------------- DRAG (без утечек) ----------------
local function MakeDraggable(handle, target)
    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- ОДНО глобальное соединение, реагирует только если dragging == true
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

MakeDraggable(Header, Main)
MakeDraggable(AD, AD)

--// ---------------- BUTTONS ----------------
Back.MouseButton1Click:Connect(MainPage)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)
AD.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main.Size = UDim2.fromOffset(0, 0)
        Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(320, 290)})
        MainPage()
    end
end)

--// ---------------- INIT ESP для уже подключённых ----------------
local function attachESPForAll()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then createESP(plr) end
    end
end
attachESPForAll()

--// Создаём ESP при заходе нового игрока
bind(Players.PlayerAdded:Connect(function(plr)
    if plr ~= LP then createESP(plr) end
end))
bind(Players.PlayerRemoving:Connect(removeESP))

--// ---------------- CLEANUP EXPOSED ----------------
_G.__AD_CLEANUP = function()
    disconnectAll()
    pcall(function() GUI:Destroy() end)
    pcall(function() espFolder:Destroy() end)
    FOV = nil
end

UpdateFOV()
MainPage()
print("[AD v3.1] loaded")
