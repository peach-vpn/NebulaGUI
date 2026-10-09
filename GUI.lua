--========================================================--
--              AD v4.0 — MAX AIM + MAX ESP               --
--       Client-side only. Camera-lock, NOT real aimbot.  --
--                   100 studs aim range                  --
--========================================================--

if _G.__AD_CLEANUP then pcall(_G.__AD_CLEANUP) _G.__AD_CLEANUP = nil end

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")

local LP = Players.LocalPlayer
if not LP then return end
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera    = workspace.CurrentCamera

local conns = {}
local function bind(c) table.insert(conns, c) return c end
local function disconnectAll()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
end

bind(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end))

--// ---------------- THEME ----------------
local T = {
    Accent   = Color3.fromRGB(135, 80, 255),
    Accent2  = Color3.fromRGB(180, 130, 255),
    Bg       = Color3.fromRGB(14, 14, 20),
    Sec      = Color3.fromRGB(23, 23, 31),
    Text     = Color3.fromRGB(230, 230, 235),
}

--// ---------------- SETTINGS ----------------
local S = {
    -- AIM
    Aim          = false,
    AimRange     = 100,       -- жёсткий лимит 100 studs
    AimFOV       = 90,
    AimSmooth    = 0.35,
    AimHead      = true,
    TeamCheck    = true,
    WallCheck    = true,
    StickyTarget = true,
    Prediction   = 0.12,      -- множитель предикции
    HoldToAim    = false,     -- тап = кратковременный лок

    -- ESP
    ESP          = false,
    Box          = true,
    Highlight    = true,
    Name         = true,
    Health       = true,
    Distance     = true,
    Tracer       = true,
    Skeleton     = false,
    MaxDistance  = 400,

    -- Misc
    Speed        = false,
    SpeedValue   = 22,
}

--// ---------------- GUI PARENT ----------------
local function guiParent()
    if gethui then local ok,h = pcall(gethui) if ok and h then return h end end
    if CoreGui then return CoreGui end
    return PlayerGui
end
local PARENT = guiParent()
local old = PARENT:FindFirstChild("AD_GUI_v4")
if old then old:Destroy() end

--// ---------------- BUILDERS ----------------
local function Create(class, props)
    local o = Instance.new(class)
    local p = props.Parent
    for k, v in pairs(props) do if k ~= "Parent" then o[k] = v end end
    o.Parent = p
    return o
end
local function Corner(p, r) return Create("UICorner", {CornerRadius = r or UDim.new(0, 8), Parent = p}) end
local function Stroke(p, c, th, tr) return Create("UIStroke", {Color = c or T.Accent, Thickness = th or 1, Transparency = tr or 0, Parent = p}) end
local function Tween(o, i, pr) TweenService:Create(o, i, pr):Play() end

--// ---------------- GUI ----------------
local GUI = Create("ScreenGui", {
    Name = "AD_GUI_v4", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PARENT
})
bind(GUI.Destroying:Connect(disconnectAll))

local AD = Create("TextButton", {
    Size = UDim2.fromOffset(52, 52), Position = UDim2.new(0, 15, 0.5, -26),
    BackgroundColor3 = T.Bg, Text = "AD", TextColor3 = T.Accent, TextSize = 17,
    Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = GUI
})
Corner(AD, UDim.new(1, 0))
local ADStroke = Stroke(AD, T.Accent, 2)

local Main = Create("Frame", {
    Size = UDim2.fromOffset(320, 300), Position = UDim2.new(0.5, -160, 0.5, -150),
    BackgroundColor3 = T.Bg, Visible = false, ClipsDescendants = true, Parent = GUI
})
Corner(Main, UDim.new(0, 12))
local MainStroke = Stroke(Main, T.Accent, 1.5, 0.3)

local Header = Create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.Sec, Parent = Main })
Corner(Header, UDim.new(0, 12))

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -80, 1, 0), Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1, Text = "AD", TextColor3 = T.Accent, TextSize = 16,
    Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = Header
})

local Back = Create("TextButton", {
    Size = UDim2.fromOffset(30, 26), Position = UDim2.new(1, -68, 0, 7),
    BackgroundColor3 = T.Bg, Text = "‹", TextColor3 = T.Text, TextSize = 20,
    Font = Enum.Font.GothamBold, Visible = false, AutoButtonColor = false, Parent = Header
})
Corner(Back, UDim.new(0, 6))

local Close = Create("TextButton", {
    Size = UDim2.fromOffset(30, 26), Position = UDim2.new(1, -36, 0, 7),
    BackgroundColor3 = T.Bg, Text = "×", TextColor3 = T.Text, TextSize = 18,
    Font = Enum.Font.Gotham, AutoButtonColor = false, Parent = Header
})
Corner(Close, UDim.new(0, 6))

local Content = Create("ScrollingFrame", {
    Size = UDim2.new(1, -10, 1, -50), Position = UDim2.fromOffset(5, 45),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
    ScrollBarImageColor3 = T.Accent, ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
    ElasticBehavior = Enum.ElasticBehavior.Always, Parent = Main
})
Create("UIPadding", { PaddingLeft = UDim.new(0,3), PaddingRight = UDim.new(0,3), PaddingBottom = UDim.new(0,10), Parent = Content })
Create("UIListLayout", { Padding = UDim.new(0,5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Content })

--// ---------------- COMPONENTS ----------------
local function Clear()
    for _, v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
    end
end

local function Section(txt)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = txt,
        TextColor3 = T.Accent2, TextSize = 12, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = Content
    })
end

local function Info(txt)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.Sec,
        Text = txt, TextWrapped = true, TextColor3 = T.Accent2,
        TextSize = 10, Font = Enum.Font.Gotham, Parent = Content
    })
end

local function Button(txt, cb)
    local b = Create("TextButton", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = T.Sec, Text = "", AutoButtonColor = false, Parent = Content })
    Corner(b, UDim.new(0, 6))
    Create("TextLabel", { Size = UDim2.new(1, -30, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = txt, TextColor3 = T.Text, TextSize = 13, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = b })
    Create("TextLabel", { Size = UDim2.fromOffset(20, 32), Position = UDim2.new(1, -25, 0, 0), BackgroundTransparency = 1, Text = "›", TextColor3 = T.Accent, TextSize = 16, Font = Enum.Font.GothamBold, Parent = b })
    b.MouseButton1Click:Connect(cb)
    return b
end

local function Toggle(txt, initial, cb)
    local state = { v = initial }
    local b = Create("TextButton", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.Sec, Text = "", AutoButtonColor = false, Parent = Content })
    Corner(b, UDim.new(0, 6))
    Create("TextLabel", { Size = UDim2.new(1, -50, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = txt, TextColor3 = T.Text, TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = b })
    local sw = Create("Frame", { Size = UDim2.fromOffset(32, 16), Position = UDim2.new(1, -40, 0.5, -8), BackgroundColor3 = Color3.fromRGB(50, 50, 60), Parent = b })
    Corner(sw, UDim.new(1, 0))
    local dot = Create("Frame", { Size = UDim2.fromOffset(12, 12), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.fromRGB(200, 200, 210), Parent = sw })
    Corner(dot, UDim.new(1, 0))
    local function apply(instant)
        local col = state.v and T.Accent or Color3.fromRGB(50, 50, 60)
        local pos = state.v and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2)
        if instant then sw.BackgroundColor3 = col dot.Position = pos
        else Tween(sw, TweenInfo.new(0.15), { BackgroundColor3 = col }) Tween(dot, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Position = pos }) end
    end
    apply(true)
    b.MouseButton1Click:Connect(function()
        state.v = not state.v
        apply(false)
        if cb then local ok, err = pcall(cb, state.v) if not ok then warn(err) end end
    end)
    return b, state
end

local function Number(txt, initial, min, max, cb)
    local f = Create("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.Sec, Parent = Content })
    Corner(f, UDim.new(0, 6))
    Create("TextLabel", { Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = txt, TextColor3 = T.Text, TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = f })
    local box = Create("TextBox", { Size = UDim2.fromOffset(55, 20), Position = UDim2.new(1, -62, 0.5, -10), BackgroundColor3 = T.Bg, Text = tostring(initial), TextColor3 = T.Accent, TextSize = 11, Font = Enum.Font.GothamBold, ClearTextOnFocus = false, Parent = f })
    Corner(box, UDim.new(0, 4))
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if not n then box.Text = tostring(initial) return end
        n = math.clamp(n, min, max)
        box.Text = tostring(n)
        if cb then local ok, err = pcall(cb, n) if not ok then warn(err) end end
    end)
    return f
end

--// ---------------- FOV CIRCLE ----------------
local FOV = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(180, 180), BackgroundTransparency = 1, Visible = false,
    ZIndex = 100, Active = false, Parent = GUI
})
Corner(FOV, UDim.new(1, 0))
local FOVStroke = Stroke(FOV, T.Accent, 1.5, 0.15)
local FOVDot = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(3, 3), BackgroundColor3 = T.Accent, Parent = FOV })
Corner(FOVDot, UDim.new(1, 0))
local function UpdateFOV() FOV.Size = UDim2.fromOffset(S.AimFOV * 2, S.AimFOV * 2) end

--// ---------------- TRACER (нижняя центральная точка) ----------------
local TracerFrame = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -60),
    Size = UDim2.fromOffset(2, 0),
    BackgroundColor3 = T.Accent,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 90,
    Parent = GUI
})
local TracerGrad = Create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    }),
    Rotation = 90,
    Parent = TracerFrame
})

--// ---------------- CHARACTER CACHE ----------------
local CharCache = {}

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

local function watchPlayer(plr)
    if plr == LP then return end
    setCharacter(plr, plr.Character)
    bind(plr.CharacterAdded:Connect(function(c) task.wait(0.2) setCharacter(plr, c) end))
    bind(plr.CharacterRemoving:Connect(function() CharCache[plr] = nil end))
end

for _, plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end
bind(Players.PlayerAdded:Connect(watchPlayer))
bind(Players.PlayerRemoving:Connect(function(plr) CharCache[plr] = nil end))

local function getCharacter(player) return CharCache[player] end
local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Head")
end
local function getHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end
local function getHead(char)
    if not char then return nil end
    return char:FindFirstChild("Head")
end

--// ---------------- TEAM / VISIBILITY ----------------
local function isEnemy(plr)
    if not plr or plr == LP then return false end
    if S.TeamCheck and LP.Team and plr.Team and LP.Team == plr.Team then return false end
    return true
end

local function isVisible(char, part)
    if not S.WallCheck then return true end
    if not part or not Camera then return false end
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

--// ---------------- AIM (Camera Lock, 100 studs hard limit) ----------------
local LockedTarget = nil
local LockedAt = 0
local HoldActive = false
local LastTargetSwitch = 0
local TARGET_SWITCH_CD = 0.15

local function getAimPart(char)
    if not char then return nil end
    if S.AimHead then
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function predictPosition(part)
    if not part or S.Prediction <= 0 then return part and part.Position or nil end
    local vel = part.AssemblyLinearVelocity or part.Velocity or Vector3.zero
    local dist = (part.Position - Camera.CFrame.Position).Magnitude
    local t = dist / math.max(400, 1) -- ~ проекция времени
    return part.Position + vel * (S.Prediction * t)
end

local function targetScore(player, part)
    if not Camera then return math.huge end
    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen or pos.Z <= 0 then return math.huge end
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local pixelDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
    if pixelDist > S.AimFOV then return math.huge end
    return pixelDist
end

local function findTarget()
    if not Camera then return nil end
    local best, bestScore = nil, math.huge
    local camPos = Camera.CFrame.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if isEnemy(plr) then
            local char = getCharacter(plr)
            if char and isAlive(char) then
                local part = getAimPart(char)
                if part then
                    local d3 = (part.Position - camPos).Magnitude
                    if d3 <= S.AimRange then -- ЖЁСТКИЙ ЛИМИТ 100 studs
                        if isVisible(char, part) then
                            local sc = targetScore(plr, part)
                            if sc < bestScore then
                                bestScore = sc
                                best = plr
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function validateTarget(plr)
    if not plr then return false end
    local char = getCharacter(plr)
    if not char or not isAlive(char) or not isEnemy(plr) then return false end
    local part = getAimPart(char)
    if not part then return false end
    if (part.Position - Camera.CFrame.Position).Magnitude > S.AimRange then return false end
    if not isVisible(char, part) then return false end
    return true
end

--// ---------------- ESP ----------------
local espFolder = Create("Folder", { Name = "AD_ESP_v4", Parent = PARENT })
local ESPData = {}

local BOX_COLOR = Color3.fromRGB(255, 90, 90)
local NAME_COLOR = Color3.fromRGB(255, 240, 240)
local HL_COLOR = Color3.fromRGB(255, 60, 60)
local SKEL_COLOR = Color3.fromRGB(255, 255, 255)

local function removeESP(plr)
    local d = ESPData[plr]
    if not d then return end
    for _, obj in pairs(d) do
        if typeof(obj) == "Instance" then pcall(function() obj:Destroy() end) end
    end
    ESPData[plr] = nil
end

local function makeLine(name, thickness)
    local ln = Create("Frame", {
        Name = name,
        BackgroundColor3 = SKEL_COLOR,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Visible = false,
        ZIndex = 5,
        Parent = GUI
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ln })
    ln.Size = UDim2.fromOffset(thickness or 2, 0)
    return ln
end

local function createESP(plr)
    if plr == LP or ESPData[plr] then return end

    local data = {}

    -- Box (BoxHandleAdornment)
    local box = Create("BoxHandleAdornment", {
        Name = "ESP_Box",
        Size = Vector3.new(2, 3, 1),
        AlwaysOnTop = true,
        ZIndex = 6,
        Transparency = 0.55,
        Color3 = BOX_COLOR,
        Visible = false,
        Parent = espFolder
    })
    data.Box = box

    -- Highlight
    local hl = Create("Highlight", {
        Name = "ESP_HL",
        FillColor = HL_COLOR,
        FillTransparency = 0.7,
        OutlineColor = Color3.fromRGB(255, 255, 255),
        OutlineTransparency = 0.4,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        Enabled = false,
        Parent = espFolder
    })
    data.Highlight = hl

    -- Name + Distance billboard
    local bb = Create("BillboardGui", {
        Name = "ESP_Info",
        Size = UDim2.fromOffset(140, 34),
        StudsOffsetWorldSpace = Vector3.new(0, 3.4, 0),
        AlwaysOnTop = true,
        Enabled = false,
        MaxDistance = S.MaxDistance,
        Parent = espFolder
    })
    data.Info = bb

    local name = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        TextColor3 = NAME_COLOR,
        TextStrokeTransparency = 0.4,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        Text = plr.Name,
        Parent = bb
    })
    data.Name = name

    local dist = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(200, 240, 210),
        TextStrokeTransparency = 0.4,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        Font = Enum.Font.Gotham,
        TextSize = 11,
        Parent = bb
    })
    data.Dist = dist

    -- HP bar (под именем)
    local hpBack = Create("Frame", {
        Size = UDim2.new(0.9, 0, 0, 3),
        Position = UDim2.new(0.05, 0, 1, -6),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Parent = bb
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hpBack })
    local hpFill = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(60, 255, 100),
        BorderSizePixel = 0,
        Parent = hpBack
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hpFill })
    data.HPBack = hpBack
    data.HPFill = hpFill

    -- Skeleton bones
    local skel = {}
    for _, n in ipairs({ "Head", "Torso", "LA", "RA", "LL", "RL" }) do
        skel[n] = makeLine("SKEL_" .. n, 2)
    end
    data.Skel = skel

    ESPData[plr] = data
end

--// ---------------- SKELETON DRAW ----------------
local function drawSkeleton(d, char)
    local function lineTo(ln, a, b)
        if not a or not b then ln.Visible = false return end
        local pa, onA = Camera:WorldToViewportPoint(a.Position)
        local pb, onB = Camera:WorldToViewportPoint(b.Position)
        if not onA or not onB or pa.Z <= 0 or pb.Z <= 0 then ln.Visible = false return end
        local va = Vector2.new(pa.X, pa.Y)
        local vb = Vector2.new(pb.X, pb.Y)
        local len = (vb - va).Magnitude
        local mid = (va + vb) / 2
        local ang = math.deg(math.atan2(vb.Y - va.Y, vb.X - va.X)) - 90
        ln.Size = UDim2.fromOffset(2, len)
        ln.Position = UDim2.fromOffset(mid.X, mid.Y)
        ln.Rotation = ang
        ln.Visible = true
        ln.BackgroundColor3 = SKEL_COLOR
    end

    local head = char:FindFirstChild("Head")
    local hrp  = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    local la   = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
    local ra   = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
    local ll   = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
    local rl   = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")

    lineTo(d.Skel.Head, head, hrp)
    lineTo(d.Skel.Torso, hrp, hrp)
    lineTo(d.Skel.LA, hrp, la)
    lineTo(d.Skel.RA, hrp, ra)
    lineTo(d.Skel.LL, hrp, ll)
    lineTo(d.Skel.RL, hrp, rl)
end

local function hideSkeleton(d)
    for _, ln in pairs(d.Skel) do ln.Visible = false end
end

--// ---------------- TRACER DRAW (одна цель — ближайший) ----------------
local function updateTracer(target)
    if not S.Tracer or not S.ESP or not target then
        TracerFrame.Visible = false
        return
    end
    local char = getCharacter(target)
    local part = char and getAimPart(char)
    if not part then TracerFrame.Visible = false return end
    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen or pos.Z <= 0 then TracerFrame.Visible = false return end
    local vp = Camera.ViewportSize
    local originX = vp.X / 2
    local originY = vp.Y - 60
    local dx = pos.X - originX
    local dy = pos.Y - originY
    local len = math.sqrt(dx * dx + dy * dy)
    local ang = math.deg(math.atan2(dy, dx)) - 90
    TracerFrame.Size = UDim2.fromOffset(2, len)
    TracerFrame.Position = UDim2.fromOffset(originX, originY)
    TracerFrame.Rotation = ang
    TracerFrame.Visible = true
    TracerFrame.BackgroundColor3 = T.Accent
    TracerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
end

--// ---------------- MAIN RENDER LOOP ----------------
local accum = 0
local UPDATE_STEP = 1/25
local tracerTarget = nil

--// Hold-to-aim (тап по экрану без нажатия на UI)
bind(UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if S.HoldToAim and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        HoldActive = true
    end
end))
bind(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        HoldActive = false
    end
end))

bind(RunService.RenderStepped:Connect(function(dt)
    -- AIM — каждый кадр
    local aimActive = S.Aim and (not S.HoldToAim or HoldActive)
    if aimActive and Camera then
        if S.StickyTarget and LockedTarget then
            if not validateTarget(LockedTarget) then LockedTarget = nil end
        end
        local now = tick()
        if not LockedTarget or (now - LastTargetSwitch) > TARGET_SWITCH_CD then
            local nt = findTarget()
            if nt and nt ~= LockedTarget then
                LockedTarget = nt
                LastTargetSwitch = now
            end
        end
        if LockedTarget then
            local char = getCharacter(LockedTarget)
            local part = char and getAimPart(char)
            if part then
                local aimPos = predictPosition(part)
                local desired = CFrame.lookAt(Camera.CFrame.Position, aimPos)
                local smooth = math.clamp(S.AimSmooth * (dt * 60), 0.01, 1)
                Camera.CFrame = Camera.CFrame:Lerp(desired, smooth)
            end
        end
    else
        LockedTarget = nil
    end

    -- ESP — throttled
    accum = accum + dt
    if accum >= UPDATE_STEP then
        accum = 0
        tracerTarget = nil
        if S.ESP then
            local camPos = Camera and Camera.CFrame.Position or Vector3.zero
            local vp = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
            local bestTracerDist = math.huge

            for plr, d in pairs(ESPData) do
                local char = getCharacter(plr)
                if not char or not isAlive(char) or not isEnemy(plr) then
                    d.Info.Enabled = false
                    d.Highlight.Enabled = false
                    d.Box.Visible = false
                    hideSkeleton(d)
                else
                    local root = getRoot(char)
                    local hum = getHumanoid(char)
                    local head = getHead(char)

                    if root then
                        local distance = (root.Position - camPos).Magnitude

                        if distance > S.MaxDistance then
                            d.Info.Enabled = false
                            d.Highlight.Enabled = false
                            d.Box.Visible = false
                            hideSkeleton(d)
                        else
                            -- Highlight
                            d.Highlight.Enabled = S.Highlight
                            if S.Highlight then
                                d.Highlight.Adornee = char
                                -- Динамический цвет: от зелёного (близко) к красному (далеко)
                                local t = math.clamp(distance / S.MaxDistance, 0, 1)
                                local r = 1
                                local g = 1 - t
                                d.Highlight.FillColor = Color3.new(r, g, 0.2)
                            end

                            -- Box
                            d.Box.Visible = S.Box
                            if S.Box then
                                d.Box.Adornee = root
                                d.Box.Size = Vector3.new(2, 3, 1)
                                d.Box.Color3 = BOX_COLOR
                            else
                                d.Box.Adornee = nil
                            end

                            -- Info (name + dist + hp)
                            d.Info.Enabled = true
                            d.Info.Adornee = head or root
                            d.Info.MaxDistance = S.MaxDistance

                            d.Name.Visible = S.Name
                            d.Name.Text = plr.Name
                            d.Name.TextColor3 = NAME_COLOR

                            d.Dist.Visible = S.Distance
                            d.Dist.Text = string.format("%d m", math.floor(distance))

                            if S.Health and hum then
                                d.HPBack.Visible = true
                                local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                                d.HPFill.Size = UDim2.fromScale(ratio, 1)
                                local col = ratio > 0.5 and Color3.fromRGB(60, 255, 100)
                                    or ratio > 0.25 and Color3.fromRGB(255, 200, 60)
                                    or Color3.fromRGB(255, 60, 60)
                                d.HPFill.BackgroundColor3 = col
                            else
                                d.HPBack.Visible = false
                            end

                            -- Skeleton
                            if S.Skeleton then
                                drawSkeleton(d, char)
                            else
                                hideSkeleton(d)
                            end

                            -- Выбор цели для трейсера: самый близкий
                            if S.Tracer and distance < bestTracerDist then
                                bestTracerDist = distance
                                tracerTarget = plr
                            end
                        end
                    end
                end
            end
        else
            for _, d in pairs(ESPData) do
                d.Info.Enabled = false
                d.Highlight.Enabled = false
                d.Box.Visible = false
                hideSkeleton(d)
            end
        end

        -- Tracer рисуем каждый throttle-тик, но линия обновляется в RenderStepped.
        -- Реальная отрисовка — ниже, в RenderStepped (каждый кадр).
    end

    -- Tracer рисуем каждый кадр для плавности
    if S.Tracer and S.ESP and tracerTarget then
        updateTracer(tracerTarget)
    else
        TracerFrame.Visible = false
    end
end))

--// ---------------- SPEED (Heartbeat) ----------------
bind(RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and S.Speed then
        hum.WalkSpeed = S.SpeedValue
    end
end))

--// ---------------- PAGES ----------------
local function MainPage()
    Clear()
    Title.Text = "AD v4"
    Back.Visible = false
    Section("ГЛАВНОЕ")
    Button("AIM (100 studs)", function() AimPage() end)
    Button("ESP MAX", function() ESPPage() end)
    Button("Misc", function() MiscPage() end)
end

function AimPage()
    Clear()
    Title.Text = "AIM · 100m"
    Back.Visible = true
    Info("Camera Lock: поворот камеры в цель. Урон зависит от серверной логики игры.")
    Section("ОСНОВНОЕ")
    Toggle("Включить AIM", S.Aim, function(v) S.Aim = v FOV.Visible = v if not v then LockedTarget = nil end end)
    Toggle("Hold-to-aim", S.HoldToAim, function(v) S.HoldToAim = v end)
    Toggle("В голову", S.AimHead, function(v) S.AimHead = v end)
    Toggle("Sticky", S.StickyTarget, function(v) S.StickyTarget = v end)
    Toggle("TeamCheck", S.TeamCheck, function(v) S.TeamCheck = v end)
    Toggle("WallCheck", S.WallCheck, function(v) S.WallCheck = v end)
    Section("ПАРАМЕТРЫ")
    Number("FOV (пикс)", S.AimFOV, 20, 600, function(v) S.AimFOV = v UpdateFOV() end)
    Number("Плавность", S.AimSmooth, 0.05, 1, function(v) S.AimSmooth = v end)
    Number("Prediction", S.Prediction, 0, 0.5, function(v) S.Prediction = v end)
    Section("ДИСТАНЦИЯ")
    Info("Макс. дистанция AIM: 100 studs (жёстко). Дальше цель игнорируется.")
end

function ESPPage()
    Clear()
    Title.Text = "ESP MAX"
    Back.Visible = true
    Section("ОТОБРАЖЕНИЕ")
    Toggle("Включить ESP", S.ESP, function(v) S.ESP = v end)
    Toggle("Box", S.Box, function(v) S.Box = v end)
    Toggle("Highlight", S.Highlight, function(v) S.Highlight = v end)
    Toggle("Имя", S.Name, function(v) S.Name = v end)
    Toggle("HP bar", S.Health, function(v) S.Health = v end)
    Toggle("Дистанция", S.Distance, function(v) S.Distance = v end)
    Toggle("Tracer", S.Tracer, function(v) S.Tracer = v end)
    Toggle("Skeleton", S.Skeleton, function(v) S.Skeleton = v end)
    Toggle("TeamCheck", S.TeamCheck, function(v) S.TeamCheck = v end)
    Section("ПАРАМЕТРЫ")
    Number("Max ESP dist", S.MaxDistance, 50, 1000, function(v)
        S.MaxDistance = v
        for _, d in pairs(ESPData) do d.Info.MaxDistance = v end
    end)
end

function MiscPage()
    Clear()
    Title.Text = "Misc"
    Back.Visible = true
    Section("ДВИЖЕНИЕ")
    Toggle("Скорость", S.Speed, function(v) S.Speed = v end)
    Number("Значение", S.SpeedValue, 16, 120, function(v) S.SpeedValue = v end)
    Info("WalkSpeed > ~22 может ловиться античитом.")
end

--// ---------------- DRAG ----------------
local function MakeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

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
        Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(320, 300) })
        MainPage()
    end
end)

--// ---------------- INIT ----------------
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP then createESP(plr) end
end
bind(Players.PlayerAdded:Connect(function(plr)
    if plr ~= LP then
        task.wait(0.5)
        createESP(plr)
    end
end))
bind(Players.PlayerRemoving:Connect(removeESP))

--// ---------------- CLEANUP ----------------
_G.__AD_CLEANUP = function()
    disconnectAll()
    pcall(function() GUI:Destroy() end)
    pcall(function() espFolder:Destroy() end)
end

UpdateFOV()
MainPage()
print("[AD v4.0] loaded — aim range 100 studs")
