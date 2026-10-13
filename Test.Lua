--========================================================--
--           AD BloxStrike v1.0 — AIM + ESP               --
--========================================================--

if _G.__BS_CLEANUP then pcall(_G.__BS_CLEANUP) _G.__BS_CLEANUP = nil end

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")

local LP = Players.LocalPlayer
if not LP then return end
local PG = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local conns = {}
local function bind(c) table.insert(conns, c) return c end
local function disconnectAll()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
end

bind(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end))

--========================================================--
-- SETTINGS
--========================================================--
local S = {
    -- AIM
    AimEnabled = false,
    AimPart = "Head",           -- "Head" | "Body"
    AimFOV = 120,
    AimRange = 400,
    AimSmooth = 0.35,
    AimWallCheck = true,
    AimTeamCheck = true,
    AimPrediction = true,

    -- ESP
    ESPEnabled = true,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPMaxDist = 500,
}

--========================================================--
-- COLORS
--========================================================--
local C = {
    bg      = Color3.fromRGB(12, 12, 18),
    bg2     = Color3.fromRGB(18, 18, 26),
    panel   = Color3.fromRGB(22, 22, 32),
    card    = Color3.fromRGB(28, 27, 40),
    accent  = Color3.fromRGB(153, 91, 255),
    accent2 = Color3.fromRGB(190, 140, 255),
    text    = Color3.fromRGB(245, 245, 255),
    muted   = Color3.fromRGB(145, 143, 163),
    border  = Color3.fromRGB(45, 42, 62),
    green   = Color3.fromRGB(94, 225, 151),
    red     = Color3.fromRGB(255, 90, 90),
    blue    = Color3.fromRGB(90, 150, 255),
    orange  = Color3.fromRGB(255, 165, 60),
}

--========================================================--
-- HELPERS
--========================================================--
local function Create(class, props)
    local o = Instance.new(class)
    local p = props.Parent
    for k, v in pairs(props) do if k ~= "Parent" then o[k] = v end end
    o.Parent = p
    return o
end
local function Corner(p, r) return Create("UICorner", { CornerRadius = r or UDim.new(0, 7), Parent = p }) end
local function Stroke(p, c, th, tr) return Create("UIStroke", { Color = c or C.border, Thickness = th or 1, Transparency = tr or 0.3, Parent = p }) end
local function Play(o, i, pr) TweenService:Create(o, i, pr):Play() end

--========================================================--
-- GUI ROOT
--========================================================--
local function guiParent()
    if gethui then local ok,h = pcall(gethui) if ok and h then return h end end
    if CoreGui then return CoreGui end
    return PG
end
local PARENT = guiParent()
local old = PARENT:FindFirstChild("AD_BS_v1")
if old then old:Destroy() end

local GUI = Create("ScreenGui", {
    Name = "AD_BS_v1", ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 2147483647, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PARENT
})
bind(GUI.Destroying:Connect(disconnectAll))

-- ICON
local Icon = Create("TextButton", {
    Size = UDim2.fromOffset(50, 50),
    Position = UDim2.new(0, 14, 0.5, -25),
    BackgroundColor3 = C.bg,
    Text = "AD", TextColor3 = C.accent2, TextSize = 15,
    Font = Enum.Font.GothamBlack, AutoButtonColor = false,
    ZIndex = 100, Parent = GUI
})
Corner(Icon, UDim.new(1, 0))
Stroke(Icon, C.accent, 2, 0.2)

-- WINDOW
local Win = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromOffset(400, 320),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = C.bg, Visible = false,
    ClipsDescendants = true, ZIndex = 10, Parent = GUI
})
Corner(Win, UDim.new(0, 12))
Stroke(Win, C.accent, 1.5, 0.2)
local WinScale = Create("UIScale", { Scale = 1, Parent = Win })

-- HEADER
local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = C.panel, BorderSizePixel = 0,
    ZIndex = 11, Parent = Win
})
Corner(Header, UDim.new(0, 12))
Create("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = C.accent, BorderSizePixel = 0, ZIndex = 12, Parent = Header })

Create("TextLabel", {
    Size = UDim2.new(1, -70, 0, 15), Position = UDim2.fromOffset(10, 5),
    BackgroundTransparency = 1, Text = "AD · BloxStrike",
    TextColor3 = C.text, TextSize = 13, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 13, Parent = Header
})
Create("TextLabel", {
    Size = UDim2.new(1, -70, 0, 11), Position = UDim2.fromOffset(10, 21),
    BackgroundTransparency = 1, Text = "v1.0 · AIM + ESP",
    TextColor3 = C.muted, TextSize = 9, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 13, Parent = Header
})

local CloseBtn = Create("TextButton", {
    Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -30, 0, 7),
    BackgroundColor3 = C.card, Text = "X", TextColor3 = C.text,
    TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false,
    ZIndex = 14, Parent = Header
})
Corner(CloseBtn, UDim.new(0, 6))
Stroke(CloseBtn, C.border, 1, 0.3)

-- CONTENT
local Content = Create("ScrollingFrame", {
    Size = UDim2.new(1, -12, 1, -46),
    Position = UDim2.fromOffset(6, 40),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 2, ScrollBarImageColor3 = C.accent,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(), ElasticBehavior = Enum.ElasticBehavior.Always,
    ZIndex = 11, Parent = Win
})
Create("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = Content })
Create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Content })

--========================================================--
-- COMPONENTS
--========================================================--
local function Section(txt)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
        Text = txt, TextColor3 = C.accent2, TextSize = 10,
        Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Content
    })
end

local function Toggle(txt, initial, cb)
    local state = { v = initial }
    local b = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = C.card, Text = "", AutoButtonColor = false,
        Parent = Content
    })
    Corner(b, UDim.new(0, 7))
    Stroke(b, C.border, 1, 0.3)

    Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0), Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1, Text = txt, TextColor3 = C.text,
        TextSize = 11, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = b
    })

    local sw = Create("Frame", {
        Size = UDim2.fromOffset(34, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = state.v and C.accent or Color3.fromRGB(45, 45, 60),
        BorderSizePixel = 0, Parent = b
    })
    Corner(sw, UDim.new(1, 0))

    local dot = Create("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = state.v and UDim2.fromOffset(20, 3) or UDim2.fromOffset(3, 3),
        BackgroundColor3 = Color3.fromRGB(240, 240, 250),
        BorderSizePixel = 0, ZIndex = 2, Parent = sw
    })
    Corner(dot, UDim.new(1, 0))

    local function apply(instant)
        local col = state.v and C.accent or Color3.fromRGB(45, 45, 60)
        local pos = state.v and UDim2.fromOffset(20, 3) or UDim2.fromOffset(3, 3)
        if instant then
            sw.BackgroundColor3 = col; dot.Position = pos
        else
            Play(sw, TweenInfo.new(0.18), { BackgroundColor3 = col })
            Play(dot, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = pos })
        end
    end
    apply(true)

    b.MouseButton1Click:Connect(function()
        state.v = not state.v
        apply(false)
        if cb then pcall(cb, state.v) end
    end)
    return b
end

local function Slider(txt, initial, min, max, cb)
    local frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
        Parent = Content
    })
    Corner(frame, UDim.new(0, 7))
    Stroke(frame, C.border, 1, 0.3)

    Create("TextLabel", {
        Size = UDim2.new(0.65, -10, 0, 16), Position = UDim2.fromOffset(10, 4),
        BackgroundTransparency = 1, Text = txt, TextColor3 = C.text,
        TextSize = 11, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = frame
    })

    local valLbl = Create("TextLabel", {
        Size = UDim2.new(0.35, -10, 0, 16), Position = UDim2.new(0.65, 0, 0, 4),
        BackgroundTransparency = 1, Text = tostring(math.floor(initial)),
        TextColor3 = C.accent2, TextSize = 10, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = frame
    })

    local track = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 6), Position = UDim2.fromOffset(10, 28),
        BackgroundColor3 = Color3.fromRGB(40, 40, 55), BorderSizePixel = 0,
        Parent = frame
    })
    Corner(track, UDim.new(1, 0))

    local fill = Create("Frame", {
        Size = UDim2.new((initial - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = C.accent, BorderSizePixel = 0, Parent = track
    })
    Corner(fill, UDim.new(1, 0))

    local knob = Create("Frame", {
        Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((initial - min) / (max - min), 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(240, 244, 255),
        BorderSizePixel = 0, ZIndex = 2, Parent = track
    })
    Corner(knob, UDim.new(1, 0))
    Stroke(knob, C.accent, 2, 0)

    local hitbox = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, -12),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = track
    })

    local value = initial
    local dragging = false

    local function setFromX(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = math.floor(min + rel * (max - min) + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        valLbl.Text = tostring(value)
        if cb then pcall(cb, value) end
    end

    hitbox.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Play(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(18, 18) })
            setFromX(i.Position.X)
        end
    end)
    bind(UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            setFromX(i.Position.X)
        end
    end))
    bind(UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                Play(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(14, 14) })
            end
        end
    end))
    return frame
end

local function Picker(txt, options, initial, cb)
    local idx = table.find(options, initial) or 1
    local frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
        Parent = Content
    })
    Corner(frame, UDim.new(0, 7))
    Stroke(frame, C.border, 1, 0.3)

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0), Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1, Text = txt, TextColor3 = C.text,
        TextSize = 11, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = frame
    })

    local btn = Create("TextButton", {
        Size = UDim2.fromOffset(60, 18), Position = UDim2.new(1, -70, 0.5, -9),
        BackgroundColor3 = C.accent, Text = options[idx],
        TextColor3 = C.bg, TextSize = 9, Font = Enum.Font.GothamBold,
        AutoButtonColor = false, Parent = frame
    })
    Corner(btn, UDim.new(0, 5))

    btn.MouseButton1Click:Connect(function()
        idx = (idx % #options) + 1
        btn.Text = options[idx]
        if cb then pcall(cb, options[idx]) end
    end)
    return frame
end

--========================================================--
-- TEAM / ROLE
--========================================================--
local function getTeamColor(player)
    -- 1) Через player.Team
    local team = player.Team
    if team and team.TeamColor then
        local bc = team.TeamColor
        if bc == BrickColor.new("Deep blue") or bc == BrickColor.new("Bright blue") then
            return C.blue
        elseif bc == BrickColor.new("Bright orange") or bc == BrickColor.new("Neon orange") then
            return C.orange
        end
    end

    -- 2) Через иерархию workspace [citation:4]
    local char = player.Character
    if char and char.Parent then
        local pName = char.Parent.Name:lower()
        if pName:find("counter") or pName:find("police") or pName:find("blue") or pName == "ct" then
            return C.blue
        elseif pName:find("terror") or pName:find("attack") or pName == "t" then
            return C.orange
        end
    end

    -- 3) Fallback: свои — синие, враги — оранжевые
    if player.Team and LP.Team and player.Team == LP.Team then
        return C.blue
    end
    return C.orange
end

local function isTeammate(player)
    if not player or player == LP then return true end
    if LP.Team and player.Team and LP.Team == player.Team then return true end
    return false
end

local function isAlive(char)
    if not char or not char.Parent or not char:IsDescendantOf(workspace) then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

--========================================================--
-- ESP
--========================================================--
local espFolder = Create("Folder", { Name = "AD_BS_ESP", Parent = PARENT })
local ESPData = {}

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
    local d = {}

    -- Box (BoxHandleAdornment) [citation:5]
    d.Box = Create("BoxHandleAdornment", {
        Name = "ESP_Box",
        Size = Vector3.new(2, 3, 1),
        AlwaysOnTop = true,
        ZIndex = 6,
        Transparency = 0.7,
        Visible = false,
        Parent = espFolder
    })

    -- Billboard (Name + HP)
    local bb = Create("BillboardGui", {
        Name = "ESP_Info",
        Size = UDim2.fromOffset(140, 32),
        StudsOffsetWorldSpace = Vector3.new(0, 3, 0),
        AlwaysOnTop = true,
        Enabled = false,
        MaxDistance = S.ESPMaxDist,
        Parent = espFolder
    })
    d.Info = bb

    d.NameLbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        TextStrokeTransparency = 0.4,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = bb
    })

    d.HPLbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.fromOffset(0, 14),
        BackgroundTransparency = 1,
        TextColor3 = C.green,
        TextStrokeTransparency = 0.4,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        Parent = bb
    })

    ESPData[player] = d
end

--========================================================--
-- AIM
--========================================================--
local LockedTarget = nil

local function getAimPart(char)
    if not char then return nil end
    if S.AimPart == "Head" then
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function isVisible(char, part)
    if not S.AimWallCheck then return true end
    local origin = Camera.CFrame.Position
    local dir = part.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = { Camera }
    if LP.Character then table.insert(filter, LP.Character) end
    params.FilterDescendantsInstances = filter
    local hit = workspace:Raycast(origin, dir, params)
    if not hit then return true end
    return hit.Instance:IsDescendantOf(char)
end

local function findTarget()
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local camPos = Camera.CFrame.Position
    local best, bestScore = nil, S.AimFOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and not (S.AimTeamCheck and isTeammate(player)) then
            local char = player.Character
            if char and isAlive(char) then
                local part = getAimPart(char)
                if part then
                    local dist = (part.Position - camPos).Magnitude
                    if dist <= S.AimRange then
                        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen and pos.Z > 0 then
                            local pd = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if pd < bestScore and isVisible(char, part) then
                                best = player
                                bestScore = pd
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

--========================================================--
-- MAIN LOOP
--========================================================--
local accum = 0
local STEP = 1/25

bind(RunService.RenderStepped:Connect(function(dt)
    -- AIM (только при зажатии правой кнопки мыши) [citation:3]
    if S.AimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = findTarget()
        if target then
            local char = target.Character
            local part = getAimPart(char)
            if part then
                -- Prediction: учитываем движение цели [citation:3]
                local aimPos = part.Position
                if S.AimPrediction then
                    local dist = (part.Position - Camera.CFrame.Position).Magnitude
                    local factor = math.clamp(0.05 + (dist / 2000), 0.02, 0.12)
                    aimPos = part.Position + (part.AssemblyLinearVelocity * factor)
                end

                local desired = CFrame.lookAt(Camera.CFrame.Position, aimPos)
                local smooth = math.clamp(S.AimSmooth * (dt * 60), 0.02, 1)
                Camera.CFrame = Camera.CFrame:Lerp(desired, smooth)
            end
        end
    end

    -- ESP (throttled)
    accum = accum + dt
    if accum >= STEP then
        accum = 0

        for player, d in pairs(ESPData) do
            local char = player.Character
            local show = S.ESPEnabled and char and isAlive(char)

            if show then
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")

                if root then
                    local dist = (root.Position - Camera.CFrame.Position).Magnitude
                    if dist > S.ESPMaxDist then
                        d.Box.Visible = false
                        d.Info.Enabled = false
                    else
                        local teamColor = getTeamColor(player)

                        -- Box
                        d.Box.Visible = S.ESPBox
                        if S.ESPBox then
                            d.Box.Adornee = root
                            d.Box.Size = Vector3.new(2, 3, 1)
                            d.Box.Color3 = teamColor
                        else
                            d.Box.Adornee = nil
                        end

                        -- Info
                        d.Info.Enabled = true
                        d.Info.Adornee = head or root
                        d.Info.MaxDistance = S.ESPMaxDist

                        d.NameLbl.Visible = S.ESPName
                        d.NameLbl.Text = player.Name
                        d.NameLbl.TextColor3 = teamColor

                        if S.ESPHealth and hum then
                            d.HPLbl.Visible = true
                            d.HPLbl.Text = string.format("HP: %d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth))
                        else
                            d.HPLbl.Visible = false
                        end

                        if S.ESPDistance then
                            d.HPLbl.Text = d.HPLbl.Text .. "  " .. math.floor(dist) .. "m"
                        end
                    end
                end
            else
                d.Box.Visible = false
                d.Info.Enabled = false
            end
        end
    end
end))

--========================================================--
-- PAGES
--========================================================--
local function Clear()
    for _, v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
    end
end

local function AimPage()
    Clear()
    Section("AIMBOT")
    Toggle("Включить AIM", S.AimEnabled, function(v) S.AimEnabled = v end)
    Picker("Часть тела", { "Head", "Body" }, S.AimPart, function(v) S.AimPart = v end)
    Toggle("WallCheck", S.AimWallCheck, function(v) S.AimWallCheck = v end)
    Toggle("TeamCheck", S.AimTeamCheck, function(v) S.AimTeamCheck = v end)
    Toggle("Prediction", S.AimPrediction, function(v) S.AimPrediction = v end)
    Section("ПАРАМЕТРЫ")
    Slider("FOV (пиксели)", S.AimFOV, 20, 500, function(v) S.AimFOV = v end)
    Slider("Дальность (studs)", S.AimRange, 50, 800, function(v) S.AimRange = v end)
    Slider("Плавность x100", math.floor(S.AimSmooth * 100), 1, 100, function(v) S.AimSmooth = v / 100 end)
end

local function ESPPage()
    Clear()
    Section("ESP")
    Toggle("Включить ESP", S.ESPEnabled, function(v) S.ESPEnabled = v end)
    Toggle("Box (рамка)", S.ESPBox, function(v) S.ESPBox = v end)
    Toggle("Имя", S.ESPName, function(v) S.ESPName = v end)
    Toggle("HP", S.ESPHealth, function(v) S.ESPHealth = v end)
    Toggle("Дистанция", S.ESPDistance, function(v) S.ESPDistance = v end)
    Section("ПАРАМЕТРЫ")
    Slider("Макс. дистанция", S.ESPMaxDist, 50, 1000, function(v) S.ESPMaxDist = v end)
end

--========================================================--
-- NAV
--========================================================--
local NavBar = Create("Frame", {
    Size = UDim2.new(1, -12, 0, 26),
    Position = UDim2.new(0, 6, 1, -32),
    BackgroundColor3 = C.panel, BorderSizePixel = 0,
    ZIndex = 12, Parent = Win
})
Corner(NavBar, UDim.new(0, 7))
Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = NavBar })

local currentPage = nil
local buttons = {}

local function createNavBtn(name, pageFn)
    local b = Create("TextButton", {
        Size = UDim2.new(0.5, -3, 1, 0),
        BackgroundColor3 = C.card, Text = name,
        TextColor3 = C.muted, TextSize = 10, Font = Enum.Font.GothamBold,
        AutoButtonColor = false, Parent = NavBar
    })
    Corner(b, UDim.new(0, 6))
    buttons[name] = b

    b.MouseButton1Click:Connect(function()
        for n, btn in pairs(buttons) do
            btn.BackgroundColor3 = (n == name) and C.accent or C.card
            btn.TextColor3 = (n == name) and C.bg or C.muted
        end
        pageFn()
    end)
end

createNavBtn("AIM", AimPage)
createNavBtn("ESP", ESPPage)

--========================================================--
-- OPEN / CLOSE
--========================================================--
local opened = false
local function SetOpen(state)
    opened = state
    if opened then
        Win.Visible = true
        WinScale.Scale = 0.9
        Play(WinScale, TweenInfo.new(0.22, Enum.EasingStyle.Back), { Scale = 1 })
    else
        Play(WinScale, TweenInfo.new(0.15), { Scale = 0.9 })
        task.delay(0.15, function() Win.Visible = false end)
    end
end

Icon.MouseButton1Click:Connect(function() SetOpen(not opened) end)
CloseBtn.MouseButton1Click:Connect(function() SetOpen(false) end)

--========================================================--
-- INIT
--========================================================--
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LP then createESP(player) end
end
bind(Players.PlayerAdded:Connect(function(player) task.wait(0.5) createESP(player) end))
bind(Players.PlayerRemoving:Connect(removeESP))

AimPage()
buttons["AIM"].BackgroundColor3 = C.accent
buttons["AIM"].TextColor3 = C.bg

--========================================================--
-- CLEANUP
--========================================================--
_G.__BS_CLEANUP = function()
    disconnectAll()
    pcall(function() GUI:Destroy() end)
    pcall(function() espFolder:Destroy() end)
end

print("[AD BloxStrike v1.0] загружен")
