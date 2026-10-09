--========================================================--
--   AD v4.4 — AIM + TRIGGER + NOCLIP + ESP + LANG(EN/RU)  --
--   Client-side only. Не даёт серверного преимущества.    --
--========================================================--

if _G.__AD_CLEANUP then pcall(_G.__AD_CLEANUP) _G.__AD_CLEANUP = nil end

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local VIM          = game:GetService("VirtualInputManager")

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

--// =========================================================
--// LOCALIZATION
--// =========================================================
local Locale = {
    EN = {
        -- Header
        title_main         = "Main",
        title_aim          = "AIM",
        title_trigger      = "Trigger Bot",
        title_esp          = "ESP MAX",
        title_misc         = "Misc",
        title_settings     = "Settings",

        -- Main buttons
        btn_aim            = "AIM",
        btn_trigger        = "Trigger Bot",
        btn_esp            = "ESP MAX",
        btn_misc           = "Misc",
        btn_settings       = "Settings",
        btn_lang           = "Language",

        -- Sections
        sec_main           = "MAIN",
        sec_settings       = "SETTINGS",

        -- AIM page
        aim_info           = "Camera Lock: rotates camera (and optionally body). Damage depends on the game.",
        sec_aim_main       = "MAIN",
        aim_enable         = "Enable AIM",
        aim_hold           = "Hold-to-aim",
        aim_head           = "Target Head",
        aim_sticky         = "Sticky Target",
        aim_teamcheck      = "TeamCheck",
        aim_wallcheck      = "WallCheck",
        aim_rotate_char    = "Rotate Character",
        sec_aim_params     = "DISTANCE & PARAMS",
        aim_range          = "Range (studs)",
        aim_fov            = "FOV (pixels)",
        aim_cam_smooth     = "Cam Smooth",
        aim_body_smooth    = "Body Smooth",
        aim_prediction     = "Prediction",

        -- Trigger page
        trig_info          = "Auto-fires when a valid target is under the crosshair. Client-side only.",
        sec_trig_main      = "MAIN",
        trig_enable        = "Enable Trigger",
        trig_require_aim   = "Require AIM active",
        trig_only_tool     = "Only with Tool equipped",
        trig_auto_reload   = "Skip when reloading",
        sec_trig_params    = "PARAMETERS",
        trig_fov           = "Trigger FOV (px)",
        trig_delay         = "Delay (sec)",
        trig_hold          = "Hold time (sec)",
        trig_miss          = "Miss chance (0..1)",

        -- ESP page
        sec_esp_show       = "DISPLAY",
        esp_enable         = "Enable ESP",
        esp_box            = "Box",
        esp_highlight      = "Highlight",
        esp_name           = "Name",
        esp_health         = "HP bar",
        esp_distance       = "Distance",
        esp_tracer         = "Tracer",
        esp_skeleton       = "Skeleton",
        esp_teamcheck      = "TeamCheck",
        sec_esp_params     = "PARAMETERS",
        esp_max_dist       = "Max ESP dist",

        -- Misc page
        sec_speed          = "SPEED",
        misc_speed         = "Speed",
        misc_walkspeed     = "WalkSpeed",
        sec_jump           = "JUMP",
        misc_autojump      = "AutoJump",
        misc_jumpboost     = "JumpPower Boost",
        misc_jumppower     = "JumpPower",
        sec_noclip         = "NOCLIP",
        misc_noclip        = "NoClip (through walls)",
        misc_noclip_info   = "NoClip: body passes through walls and floor. Doesn't work with server-side validation.",
        misc_noclip_warn   = "Tip: don't enable NoClip together with AutoJump — you may fall out of the world.",
        misc_speed_warn    = "WalkSpeed > 22 and JumpPower > 50 is usually detected by anti-cheat.",

        -- Settings page
        set_lang_label     = "Language",
        set_lang_en        = "English",
        set_lang_ru        = "Russian",
        set_theme_label    = "Theme",
        set_info           = "Changes apply instantly. Settings are kept when switching language.",
    },
    RU = {
        title_main         = "Главное",
        title_aim          = "АИМ",
        title_trigger      = "Триггер",
        title_esp          = "ESP MAX",
        title_misc         = "Разное",
        title_settings     = "Настройки",

        btn_aim            = "АИМ",
        btn_trigger        = "Триггер",
        btn_esp            = "ESP MAX",
        btn_misc           = "Разное",
        btn_settings       = "Настройки",
        btn_lang           = "Язык",

        sec_main           = "ГЛАВНОЕ",
        sec_settings       = "НАСТРОЙКИ",

        aim_info           = "Camera Lock: поворачивает камеру и (опц.) тело. Урон зависит от игры.",
        sec_aim_main       = "ОСНОВНОЕ",
        aim_enable         = "Включить АИМ",
        aim_hold           = "Hold-to-aim",
        aim_head           = "В голову",
        aim_sticky         = "Sticky",
        aim_teamcheck      = "TeamCheck",
        aim_wallcheck      = "WallCheck",
        aim_rotate_char    = "Rotate Character",
        sec_aim_params     = "ДИСТАНЦИЯ И ПАРАМЕТРЫ",
        aim_range          = "Range (studs)",
        aim_fov            = "FOV (пикс)",
        aim_cam_smooth     = "Cam Smooth",
        aim_body_smooth    = "Body Smooth",
        aim_prediction     = "Prediction",

        trig_info          = "Авто-выстрел, когда валидная цель под прицелом. Только клиентская сторона.",
        sec_trig_main      = "ОСНОВНОЕ",
        trig_enable        = "Включить триггер",
        trig_require_aim   = "Требовать АИМ",
        trig_only_tool     = "Только с Tool в руках",
        trig_auto_reload   = "Пауза при перезарядке",
        sec_trig_params    = "ПАРАМЕТРЫ",
        trig_fov           = "Trigger FOV (пикс)",
        trig_delay         = "Задержка (сек)",
        trig_hold          = "Удержание (сек)",
        trig_miss          = "Шанс промаха (0..1)",

        sec_esp_show       = "ОТОБРАЖЕНИЕ",
        esp_enable         = "Включить ESP",
        esp_box            = "Бокс",
        esp_highlight      = "Highlight",
        esp_name           = "Имя",
        esp_health         = "HP",
        esp_distance       = "Дистанция",
        esp_tracer         = "Tracer",
        esp_skeleton       = "Skeleton",
        esp_teamcheck      = "TeamCheck",
        sec_esp_params     = "ПАРАМЕТРЫ",
        esp_max_dist       = "Max ESP dist",

        sec_speed          = "СКОРОСТЬ",
        misc_speed         = "Скорость",
        misc_walkspeed     = "WalkSpeed",
        sec_jump           = "ПРЫЖОК",
        misc_autojump      = "AutoJump",
        misc_jumpboost     = "JumpPower Boost",
        misc_jumppower     = "JumpPower",
        sec_noclip         = "NOCLIP",
        misc_noclip        = "NoClip (сквозь стены)",
        misc_noclip_info   = "NoClip: тело проходит сквозь стены и пол. В играх с серверной валидацией не работает.",
        misc_noclip_warn   = "Совет: не включай NoClip и AutoJump одновременно — можешь улететь в бездну.",
        misc_speed_warn    = "WalkSpeed > 22 и JumpPower > 50 обычно ловится античитом.",

        set_lang_label     = "Язык",
        set_lang_en        = "Английский",
        set_lang_ru        = "Русский",
        set_theme_label    = "Тема",
        set_info           = "Изменения применяются сразу. Настройки сохраняются при смене языка.",
    },
}

local CurrentLang = "EN"   -- стандарт — английский
local function L(key)
    local pack = Locale[CurrentLang] or Locale.EN
    return pack[key] or Locale.EN[key] or key
end

--// ---------------- THEME ----------------
local T = {
    Accent  = Color3.fromRGB(135, 80, 255),
    Accent2 = Color3.fromRGB(180, 130, 255),
    Bg      = Color3.fromRGB(14, 14, 20),
    Sec     = Color3.fromRGB(23, 23, 31),
    Text    = Color3.fromRGB(230, 230, 235),
    Good    = Color3.fromRGB(60, 220, 100),
    Danger  = Color3.fromRGB(255, 80, 80),
}

--// ---------------- SETTINGS ----------------
local S = {
    -- AIM
    Aim              = false,
    AimRange         = 100,
    AimFOV           = 90,
    AimSmooth        = 0.35,
    CharSmooth       = 0.25,
    AimHead          = true,
    RotateCharacter  = false,
    TeamCheck        = true,
    WallCheck        = true,
    StickyTarget     = true,
    Prediction       = 0.12,
    HoldToAim        = false,

    -- TRIGGER BOT
    Trigger          = false,
    TriggerFOV       = 8,
    TriggerDelay     = 0.05,
    TriggerHold      = 0.05,
    TriggerMissChance= 0.0,
    TriggerOnlyOnTool= true,
    TriggerRequireAim= false,
    TriggerAutoReload= true,

    -- MOVEMENT
    AutoJump         = false,
    JumpPowerBoost   = false,
    JumpPower        = 60,
    Speed            = false,
    SpeedValue       = 22,
    NoClip           = false,

    -- ESP
    ESP              = false,
    Box              = true,
    Highlight        = true,
    Name             = true,
    Health           = true,
    Distance         = true,
    Tracer           = true,
    Skeleton         = false,
    MaxDistance      = 400,
}

--// ---------------- GUI PARENT ----------------
local function guiParent()
    if gethui then local ok,h = pcall(gethui) if ok and h then return h end end
    if CoreGui then return CoreGui end
    return PlayerGui
end
local PARENT = guiParent()
local old = PARENT:FindFirstChild("AD_GUI_v44")
if old then old:Destroy() end

--// ---------------- BUILDERS ----------------
local function Create(class, props)
    local o = Instance.new(class)
    local p = props.Parent
    for k, v in pairs(props) do if k ~= "Parent" then o[k] = v end end
    o.Parent = p
    return o
end
local function Corner(p, r) return Create("UICorner", { CornerRadius = r or UDim.new(0, 8), Parent = p }) end
local function Stroke(p, c, th, tr) return Create("UIStroke", { Color = c or T.Accent, Thickness = th or 1, Transparency = tr or 0, Parent = p }) end
local function Tween(o, i, pr) TweenService:Create(o, i, pr):Play() end

--// ---------------- GUI ----------------
local GUI = Create("ScreenGui", {
    Name = "AD_GUI_v44", ResetOnSpawn = false, IgnoreGuiInset = true,
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
    Size = UDim2.fromOffset(320, 320), Position = UDim2.new(0.5, -160, 0.5, -160),
    BackgroundColor3 = T.Bg, Visible = false, ClipsDescendants = true, Parent = GUI
})
Corner(Main, UDim.new(0, 12))
local MainStroke = Stroke(Main, T.Accent, 1.5, 0.3)

local Header = Create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.Sec, Parent = Main })
Corner(Header, UDim.new(0, 12))

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -80, 1, 0), Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1, Text = "AD v4.4", TextColor3 = T.Accent, TextSize = 16,
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

--// Кнопка выбора языка (сегментированная)
local function LanguageSelector()
    local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = T.Sec, Parent = Content })
    Corner(row, UDim.new(0, 6))

    local left = Create("TextButton", {
        Size = UDim2.new(0.5, -3, 1, -4), Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = (CurrentLang == "EN") and T.Accent or Color3.fromRGB(35, 38, 46),
        Text = L("set_lang_en"), TextColor3 = Color3.fromRGB(240, 240, 250),
        TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = row
    })
    Corner(left, UDim.new(0, 5))

    local right = Create("TextButton", {
        Size = UDim2.new(0.5, -3, 1, -4), Position = UDim2.new(0.5, 1, 0, 2),
        BackgroundColor3 = (CurrentLang == "RU") and T.Accent or Color3.fromRGB(35, 38, 46),
        Text = L("set_lang_ru"), TextColor3 = Color3.fromRGB(240, 240, 250),
        TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = row
    })
    Corner(right, UDim.new(0, 5))

    left.MouseButton1Click:Connect(function()
        if CurrentLang ~= "EN" then
            CurrentLang = "EN"
            SettingsPage()
        end
    end)
    right.MouseButton1Click:Connect(function()
        if CurrentLang ~= "RU" then
            CurrentLang = "RU"
            SettingsPage()
        end
    end)
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

--// ---------------- TRIGGER FOV INDICATOR (маленький круг) ----------------
local TriggerFOV = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, Visible = false,
    ZIndex = 101, Active = false, Parent = GUI
})
Corner(TriggerFOV, UDim.new(1, 0))
local TriggerFOVStroke = Stroke(TriggerFOV, Color3.fromRGB(255, 100, 100), 1, 0.3)
local function UpdateTriggerFOV()
    local s = S.TriggerFOV * 2
    TriggerFOV.Size = UDim2.fromOffset(s, s)
end

--// ---------------- TRACER ----------------
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
Create("UIGradient", {
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
local function getHumanoid(char) return char and char:FindFirstChildOfClass("Humanoid") end
local function getHead(char) return char and char:FindFirstChild("Head") end

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

--// ---------------- AIM ----------------
local LockedTarget = nil
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
    local t = dist / math.max(400, 1)
    return part.Position + vel * (S.Prediction * t)
end

local function targetScore(part, fovLimit)
    if not Camera then return math.huge end
    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen or pos.Z <= 0 then return math.huge end
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local pixelDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
    if pixelDist > fovLimit then return math.huge end
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
                    if d3 <= S.AimRange then
                        if isVisible(char, part) then
                            local sc = targetScore(part, S.AimFOV)
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

--// ---------------- TRIGGER BOT ----------------
-- Определяем цель для триггера по узкому FOV.
local function findTriggerTarget()
    if not Camera then return nil end
    local best, bestScore = nil, math.huge
    local camPos = Camera.CFrame.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if isEnemy(plr) then
            local char = getCharacter(plr)
            if char and isAlive(char) then
                local part = getAimPart(char)
                if part then
                    if (part.Position - camPos).Magnitude <= S.AimRange then
                        if isVisible(char, part) then
                            local sc = targetScore(part, S.TriggerFOV)
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

-- Проверяем, есть ли в руках Tool и он готов к выстрелу (не на перезарядке).
local function isToolReady()
    local char = LP.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return not S.TriggerOnlyOnTool end

    if S.TriggerAutoReload then
        -- Проверяем популярные имена значений у оружия
        for _, name in ipairs({ "Reloading", "IsReloading", "Reload", "Reloaded" }) do
            local v = tool:FindFirstChild(name)
            if v and v:IsA("BoolValue") and v.Value then return false end
        end
        -- Ammo (если есть)
        local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("AmmoValue")
        if ammo and (ammo:IsA("IntValue") or ammo:IsA("NumberValue")) and ammo.Value <= 0 then
            return false
        end
    end
    return true
end

-- Отправка нажатия ЛКМ — сначала пробуем mouse1press (Delta),
-- если нет — VirtualInputManager (fallback).
local firedRecently = false
local function fireMouseDown()
    if firedRecently then return end
    firedRecently = true
    task.delay(0.02, function() firedRecently = false end)

    if mouse1press then
        pcall(function() mouse1press() end)
        return
    end
    pcall(function()
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    end)
end

local function fireMouseUp()
    if mouse1release then
        pcall(function() mouse1release() end)
        return
    end
    pcall(function()
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
end

-- Асинхронная очередь выстрела
local triggerBusy = false
local function triggerFire()
    if triggerBusy then return end
    triggerBusy = true
    task.spawn(function()
        -- задержка
        if S.TriggerDelay > 0 then task.wait(S.TriggerDelay) end

        -- шанс промаха
        if S.TriggerMissChance > 0 and math.random() < S.TriggerMissChance then
            triggerBusy = false
            return
        end

        -- ещё раз проверим, что цель всё ещё валидна
        local t = findTriggerTarget()
        if not t then triggerBusy = false return end

        fireMouseDown()
        task.wait(math.max(S.TriggerHold, 0.01))
        fireMouseUp()

        task.wait(0.01)
        triggerBusy = false
    end)
end

--// ---------------- ESP ----------------
local espFolder = Create("Folder", { Name = "AD_ESP_v44", Parent = PARENT })
local ESPData = {}

local BOX_COLOR  = Color3.fromRGB(255, 90, 90)
local NAME_COLOR = Color3.fromRGB(255, 240, 240)
local HL_COLOR   = Color3.fromRGB(255, 60, 60)
local SKEL_COLOR = Color3.fromRGB(255, 255, 255)

local function removeESP(plr)
    local d = ESPData[plr]
    if not d then return end
    for _, obj in pairs(d) do
        if typeof(obj) == "Instance" then pcall(function() obj:Destroy() end) end
    end
    ESPData[plr] = nil
end

local function makeLine(name)
    local ln = Create("Frame", {
        Name = name, BackgroundColor3 = SKEL_COLOR, BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0), Visible = false, ZIndex = 5, Parent = GUI
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ln })
    ln.Size = UDim2.fromOffset(2, 0)
    return ln
end

local function createESP(plr)
    if plr == LP or ESPData[plr] then return end
    local data = {}

    local box = Create("BoxHandleAdornment", {
        Name = "ESP_Box", Size = Vector3.new(2, 3, 1), AlwaysOnTop = true,
        ZIndex = 6, Transparency = 0.55, Color3 = BOX_COLOR, Visible = false, Parent = espFolder
    })
    data.Box = box

    local hl = Create("Highlight", {
        Name = "ESP_HL", FillColor = HL_COLOR, FillTransparency = 0.7,
        OutlineColor = Color3.fromRGB(255, 255, 255), OutlineTransparency = 0.4,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Enabled = false, Parent = espFolder
    })
    data.Highlight = hl

    local bb = Create("BillboardGui", {
        Name = "ESP_Info", Size = UDim2.fromOffset(140, 34),
        StudsOffsetWorldSpace = Vector3.new(0, 3.4, 0),
        AlwaysOnTop = true, Enabled = false, MaxDistance = S.MaxDistance, Parent = espFolder
    })
    data.Info = bb

    local name = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
        TextColor3 = NAME_COLOR, TextStrokeTransparency = 0.4,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0), Font = Enum.Font.GothamBold,
        TextSize = 13, Text = plr.Name, Parent = bb
    })
    data.Name = name

    local dist = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 12), Position = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 240, 210),
        TextStrokeTransparency = 0.4, TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        Font = Enum.Font.Gotham, TextSize = 11, Parent = bb
    })
    data.Dist = dist

    local hpBack = Create("Frame", {
        Size = UDim2.new(0.9, 0, 0, 3), Position = UDim2.new(0.05, 0, 1, -6),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50), BorderSizePixel = 0, Parent = bb
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hpBack })
    local hpFill = Create("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(60, 255, 100),
        BorderSizePixel = 0, Parent = hpBack
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hpFill })
    data.HPBack = hpBack
    data.HPFill = hpFill

    local skel = {}
    for _, n in ipairs({ "Head", "Torso", "LA", "RA", "LL", "RL" }) do
        skel[n] = makeLine("SKEL_" .. n)
    end
    data.Skel = skel

    ESPData[plr] = data
end

local function drawSkeleton(d, char)
    local function lineTo(ln, a, b)
        if not a or not b then ln.Visible = false return end
        local pa, onA = Camera:WorldToViewportPoint(a.Position)
        local pb, onB = Camera:WorldToViewportPoint(b.Position)
        if not onA or not onB or pa.Z <= 0 or pb.Z <= 0 then ln.Visible = false return end
        local va, vb = Vector2.new(pa.X, pa.Y), Vector2.new(pb.X, pb.Y)
        local len = (vb - va).Magnitude
        local mid = (va + vb) / 2
        local ang = math.deg(math.atan2(vb.Y - va.Y, vb.X - va.X)) - 90
        ln.Size = UDim2.fromOffset(2, len)
        ln.Position = UDim2.fromOffset(mid.X, mid.Y)
        ln.Rotation = ang
        ln.Visible = true
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
    local originX, originY = vp.X / 2, vp.Y - 60
    local dx, dy = pos.X - originX, pos.Y - originY
    local len = math.sqrt(dx * dx + dy * dy)
    local ang = math.deg(math.atan2(dy, dx)) - 90
    TracerFrame.Size = UDim2.fromOffset(2, len)
    TracerFrame.Position = UDim2.fromOffset(originX, originY)
    TracerFrame.Rotation = ang
    TracerFrame.Visible = true
    TracerFrame.BackgroundColor3 = T.Accent
end

--// ---------------- HOLD-TO-AIM ----------------
bind(UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if S.HoldToAim and (input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1) then
        HoldActive = true
    end
end))
bind(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        HoldActive = false
    end
end))

--// ---------------- MAIN RENDER LOOP ----------------
local accum = 0
local UPDATE_STEP = 1/25
local tracerTarget = nil

bind(RunService.RenderStepped:Connect(function(dt)
    -- AIM
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
            local tchar = getCharacter(LockedTarget)
            local tpart = tchar and getAimPart(tchar)
            if tpart then
                local aimPos = predictPosition(tpart)

                local desiredCam = CFrame.lookAt(Camera.CFrame.Position, aimPos)
                local camSmooth = math.clamp(S.AimSmooth * (dt * 60), 0.01, 1)
                Camera.CFrame = Camera.CFrame:Lerp(desiredCam, camSmooth)

                if S.RotateCharacter then
                    local myChar = LP.Character
                    local myHrp  = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        local myPos = myHrp.Position
                        local lookTarget = Vector3.new(aimPos.X, myPos.Y, aimPos.Z)
                        local desiredBody = CFrame.lookAt(myPos, lookTarget)
                        local bodySmooth = math.clamp(S.CharSmooth * (dt * 60), 0.01, 1)
                        local cur = myHrp.CFrame
                        local newRot = cur.Rotation:Lerp(desiredBody.Rotation, bodySmooth)
                        myHrp.CFrame = CFrame.new(cur.Position) * newRot
                    end
                end
            end
        end
    else
        LockedTarget = nil
    end

    -- TRIGGER BOT (проверяем каждый кадр)
    if S.Trigger then
        local aimOK = (not S.TriggerRequireAim) or S.Aim
        if aimOK and isToolReady() then
            local t = findTriggerTarget()
            if t then
                triggerFire()
            end
        end
    end

    -- ESP throttled
    accum = accum + dt
    if accum >= UPDATE_STEP then
        accum = 0
        tracerTarget = nil
        if S.ESP then
            local camPos = Camera and Camera.CFrame.Position or Vector3.zero
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
                    local hum  = getHumanoid(char)
                    local head = getHead(char)

                    if root then
                        local distance = (root.Position - camPos).Magnitude

                        if distance > S.MaxDistance then
                            d.Info.Enabled = false
                            d.Highlight.Enabled = false
                            d.Box.Visible = false
                            hideSkeleton(d)
                        else
                            d.Highlight.Enabled = S.Highlight
                            if S.Highlight then
                                d.Highlight.Adornee = char
                                local t = math.clamp(distance / S.MaxDistance, 0, 1)
                                d.Highlight.FillColor = Color3.new(1, 1 - t, 0.2)
                            end

                            d.Box.Visible = S.Box
                            if S.Box then
                                d.Box.Adornee = root
                                d.Box.Size = Vector3.new(2, 3, 1)
                                d.Box.Color3 = BOX_COLOR
                            else
                                d.Box.Adornee = nil
                            end

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
                                d.HPFill.BackgroundColor3 = ratio > 0.5 and Color3.fromRGB(60, 255, 100)
                                    or ratio > 0.25 and Color3.fromRGB(255, 200, 60)
                                    or Color3.fromRGB(255, 60, 60)
                            else
                                d.HPBack.Visible = false
                            end

                            if S.Skeleton then
                                drawSkeleton(d, char)
                            else
                                hideSkeleton(d)
                            end

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
    end

    if S.Tracer and S.ESP and tracerTarget then
        updateTracer(tracerTarget)
    else
        TracerFrame.Visible = false
    end
end))

--// ---------------- HEARTBEAT (Speed / Jump / NoClip) ----------------
bind(RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if S.Speed then hum.WalkSpeed = S.SpeedValue end
    if S.JumpPowerBoost then hum.UseJumpPower = true hum.JumpPower = S.JumpPower end
    if S.AutoJump and hum.FloorMaterial ~= Enum.Material.Air then hum.Jump = true end

    if S.NoClip then
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") and d.CanCollide then
                pcall(function() d.CanCollide = false end)
            end
        end
    end
end))

--// ---------------- PAGES ----------------
local function MainPage()
    Clear()
    Title.Text = "AD v4.4"
    Back.Visible = false
    Section(L("sec_main"))
    Button(L("btn_aim"),       function() AimPage() end)
    Button(L("btn_trigger"),   function() TriggerPage() end)
    Button(L("btn_esp"),       function() ESPPage() end)
    Button(L("btn_misc"),      function() MiscPage() end)
    Button(L("btn_settings"),  function() SettingsPage() end)
end

function AimPage()
    Clear()
    Title.Text = L("title_aim")
    Back.Visible = true
    Info(L("aim_info"))
    Section(L("sec_aim_main"))
    Toggle(L("aim_enable"),     S.Aim,             function(v) S.Aim = v FOV.Visible = v if not v then LockedTarget = nil end end)
    Toggle(L("aim_hold"),       S.HoldToAim,       function(v) S.HoldToAim = v end)
    Toggle(L("aim_head"),       S.AimHead,         function(v) S.AimHead = v end)
    Toggle(L("aim_sticky"),     S.StickyTarget,    function(v) S.StickyTarget = v end)
    Toggle(L("aim_teamcheck"),  S.TeamCheck,       function(v) S.TeamCheck = v end)
    Toggle(L("aim_wallcheck"),  S.WallCheck,       function(v) S.WallCheck = v end)
    Toggle(L("aim_rotate_char"),S.RotateCharacter, function(v) S.RotateCharacter = v end)

    Section(L("sec_aim_params"))
    Number(L("aim_range"),       S.AimRange,  10, 500,  function(v) S.AimRange = v end)
    Number(L("aim_fov"),         S.AimFOV,    20, 600,  function(v) S.AimFOV = v UpdateFOV() end)
    Number(L("aim_cam_smooth"),  S.AimSmooth, 0.05, 1,  function(v) S.AimSmooth = v end)
    Number(L("aim_body_smooth"), S.CharSmooth,0.05, 1,  function(v) S.CharSmooth = v end)
    Number(L("aim_prediction"),  S.Prediction,0, 0.5,   function(v) S.Prediction = v end)
end

function TriggerPage()
    Clear()
    Title.Text = L("title_trigger")
    Back.Visible = true
    Info(L("trig_info"))
    Section(L("sec_trig_main"))
    Toggle(L("trig_enable"),      S.Trigger,           function(v)
        S.Trigger = v
        TriggerFOV.Visible = v
    end)
    Toggle(L("trig_require_aim"), S.TriggerRequireAim, function(v) S.TriggerRequireAim = v end)
    Toggle(L("trig_only_tool"),   S.TriggerOnlyOnTool, function(v) S.TriggerOnlyOnTool = v end)
    Toggle(L("trig_auto_reload"), S.TriggerAutoReload, function(v) S.TriggerAutoReload = v end)

    Section(L("sec_trig_params"))
    Number(L("trig_fov"),   S.TriggerFOV,        2, 100,   function(v) S.TriggerFOV = v UpdateTriggerFOV() end)
    Number(L("trig_delay"), S.TriggerDelay,      0, 1,     function(v) S.TriggerDelay = v end)
    Number(L("trig_hold"),  S.TriggerHold,       0.01, 0.5,function(v) S.TriggerHold = v end)
    Number(L("trig_miss"),  S.TriggerMissChance, 0, 1,     function(v) S.TriggerMissChance = v end)
end

function ESPPage()
    Clear()
    Title.Text = L("title_esp")
    Back.Visible = true
    Section(L("sec_esp_show"))
    Toggle(L("esp_enable"),    S.ESP,        function(v) S.ESP = v end)
    Toggle(L("esp_box"),       S.Box,        function(v) S.Box = v end)
    Toggle(L("esp_highlight"), S.Highlight,  function(v) S.Highlight = v end)
    Toggle(L("esp_name"),      S.Name,       function(v) S.Name = v end)
    Toggle(L("esp_health"),    S.Health,     function(v) S.Health = v end)
    Toggle(L("esp_distance"),  S.Distance,   function(v) S.Distance = v end)
    Toggle(L("esp_tracer"),    S.Tracer,     function(v) S.Tracer = v end)
    Toggle(L("esp_skeleton"),  S.Skeleton,   function(v) S.Skeleton = v end)
    Toggle(L("esp_teamcheck"), S.TeamCheck,  function(v) S.TeamCheck = v end)
    Section(L("sec_esp_params"))
    Number(L("esp_max_dist"),  S.MaxDistance,50, 1000, function(v)
        S.MaxDistance = v
        for _, d in pairs(ESPData) do d.Info.MaxDistance = v end
    end)
end

function MiscPage()
    Clear()
    Title.Text = L("title_misc")
    Back.Visible = true
    Section(L("sec_speed"))
    Toggle(L("misc_speed"),     S.Speed,     function(v) S.Speed = v end)
    Number(L("misc_walkspeed"), S.SpeedValue,16, 120, function(v) S.SpeedValue = v end)
    Section(L("sec_jump"))
    Toggle(L("misc_autojump"),  S.AutoJump,  function(v) S.AutoJump = v end)
    Toggle(L("misc_jumpboost"), S.JumpPowerBoost, function(v) S.JumpPowerBoost = v end)
    Number(L("misc_jumppower"), S.JumpPower, 50, 300, function(v) S.JumpPower = v end)
    Section(L("sec_noclip"))
    Toggle(L("misc_noclip"), S.NoClip, function(v)
        S.NoClip = v
        if not v then
            local char = LP.Character
            if char then
                for _, d in ipairs(char:GetDescendants()) do
                    if d:IsA("BasePart") then
                        pcall(function() d.CanCollide = true end)
                    end
                end
            end
        end
    end)
    Info(L("misc_noclip_info"))
    Info(L("misc_noclip_warn"))
    Info(L("misc_speed_warn"))
end

function SettingsPage()
    Clear()
    Title.Text = L("title_settings")
    Back.Visible = true

    Section(L("set_lang_label"))
    LanguageSelector()

    Section(L("sec_settings"))
    Info(L("set_info"))
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
        Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(320, 320) })
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
    local char = LP.Character
    if char then
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then
                pcall(function() d.CanCollide = true end)
            end
        end
    end
    disconnectAll()
    pcall(function() GUI:Destroy() end)
    pcall(function() espFolder:Destroy() end)
end

UpdateFOV()
UpdateTriggerFOV()
MainPage()
print("[AD v4.4] loaded — lang: " .. CurrentLang)
