--========================================================--
--   AD v5.3 — Animations + 3 Themes                       --
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

--// ---------------- LOCALIZATION ----------------
local Locale = {
    EN = {
        title_main="Main", title_aim="AIM", title_esp="ESP",
        title_visuals="Visuals", title_fly="Fly", title_misc="Misc",
        title_settings="Settings",
        btn_aim="AIM", btn_esp="ESP", btn_visuals="Visuals",
        btn_fly="Fly", btn_misc="Misc", btn_settings="Settings",
        sec_main="MAIN", sec_settings="SETTINGS",
        aim_info="Camera Lock: rotates camera in target. Damage depends on the game.",
        sec_aim_main="MAIN",
        aim_enable="Enable AIM", aim_hold="Hold-to-aim", aim_head="Target Head",
        aim_sticky="Sticky Target", aim_teamcheck="TeamCheck", aim_wallcheck="WallCheck",
        aim_rotate_char="Rotate Character", aim_flick="Flick-release",
        aim_flick_info="Flick camera 2 times fast → releases target",
        sec_aim_params="DISTANCE & PARAMS",
        aim_range="Range (studs)", aim_fov="FOV (pixels)",
        aim_speed="Aim Speed", aim_body_smooth="Body Smooth", aim_prediction="Prediction",
        sec_esp_show="DISPLAY",
        esp_enable="Enable ESP", esp_box="Box", esp_highlight="Highlight",
        esp_name="Name", esp_health="HP bar", esp_distance="Distance",
        esp_tracer="Tracer", esp_teamcheck="TeamCheck",
        sec_esp_params="PARAMETERS", esp_max_dist="Max ESP dist",
        sec_visuals="VISUALS",
        visual_fps="Show FPS", visual_ping="Show Ping", visual_watermark="Watermark",
        sec_fly="FLY SETTINGS",
        fly_enable="Enable Fly", fly_speed="Fly Speed",
        sec_speed="SPEED",
        misc_speed_boost="Speed Boost", misc_speed_value="Speed value",
        sec_jump="JUMP",
        misc_jump_boost="Jump Boost", misc_jump_value="Jump value",
        sec_noclip="NOCLIP",
        misc_noclip="NoClip",
        misc_noclip_info="NoClip: body passes through walls. Off = collide restored.",
        misc_warn="Boost is detected by anti-cheat in most games.",
        set_lang_label="Language", set_lang_en="English", set_lang_ru="Russian",
        set_theme_label="Theme", set_info="Changes apply instantly.",
    },
    RU = {
        title_main="Главное", title_aim="АИМ", title_esp="ESP",
        title_visuals="Визуалы", title_fly="Полёт", title_misc="Разное",
        title_settings="Настройки",
        btn_aim="АИМ", btn_esp="ESP", btn_visuals="Визуалы",
        btn_fly="Полёт", btn_misc="Разное", btn_settings="Настройки",
        sec_main="ГЛАВНОЕ", sec_settings="НАСТРОЙКИ",
        aim_info="Camera Lock: поворачивает камеру в цель. Урон зависит от игры.",
        sec_aim_main="ОСНОВНОЕ",
        aim_enable="Включить АИМ", aim_hold="Hold-to-aim", aim_head="В голову",
        aim_sticky="Sticky", aim_teamcheck="TeamCheck", aim_wallcheck="WallCheck",
        aim_rotate_char="Поворот тела", aim_flick="Flick-release",
        aim_flick_info="2 рывка камерой → сброс цели",
        sec_aim_params="ДИСТАНЦИЯ И ПАРАМЕТРЫ",
        aim_range="Range (studs)", aim_fov="FOV (пикс)",
        aim_speed="Скорость прицела", aim_body_smooth="Body Smooth", aim_prediction="Prediction",
        sec_esp_show="ОТОБРАЖЕНИЕ",
        esp_enable="Включить ESP", esp_box="Бокс", esp_highlight="Highlight",
        esp_name="Имя", esp_health="HP", esp_distance="Дистанция",
        esp_tracer="Tracer", esp_teamcheck="TeamCheck",
        sec_esp_params="ПАРАМЕТРЫ", esp_max_dist="Max ESP dist",
        sec_visuals="ВИЗУАЛЫ",
        visual_fps="Показывать FPS", visual_ping="Показывать Ping", visual_watermark="Водяной знак",
        sec_fly="НАСТРОЙКИ ПОЛЁТА",
        fly_enable="Включить полёт", fly_speed="Скорость полёта",
        sec_speed="СКОРОСТЬ",
        misc_speed_boost="Буст скорости", misc_speed_value="Значение скорости",
        sec_jump="ПРЫЖОК",
        misc_jump_boost="Буст прыжка", misc_jump_value="Значение прыжка",
        sec_noclip="NOCLIP",
        misc_noclip="NoClip",
        misc_noclip_info="NoClip: тело проходит сквозь стены. Off = коллизии вернутся.",
        misc_warn="Буст ловится античитом в большинстве игр.",
        set_lang_label="Язык", set_lang_en="Английский", set_lang_ru="Русский",
        set_theme_label="Тема", set_info="Изменения применяются сразу.",
    },
}
local CurrentLang = "EN"
local function L(key)
    local pack = Locale[CurrentLang] or Locale.EN
    return pack[key] or Locale.EN[key] or key
end

--// ---------------- THEMES ----------------
local Themes = {
    Purple = {
        Accent=Color3.fromRGB(135,80,255), Accent2=Color3.fromRGB(180,130,255),
        Bg=Color3.fromRGB(14,14,20), Sec=Color3.fromRGB(23,23,31),
        Text=Color3.fromRGB(230,230,235),
    },
    Ocean = {
        Accent=Color3.fromRGB(0,170,255), Accent2=Color3.fromRGB(90,200,255),
        Bg=Color3.fromRGB(10,16,24), Sec=Color3.fromRGB(18,26,36),
        Text=Color3.fromRGB(225,240,250),
    },
    Crimson = {
        Accent=Color3.fromRGB(255,60,90), Accent2=Color3.fromRGB(255,120,140),
        Bg=Color3.fromRGB(22,12,16), Sec=Color3.fromRGB(32,18,22),
        Text=Color3.fromRGB(250,225,230),
    },
}
local CurrentTheme = "Purple"
local T = Themes[CurrentTheme]

local function applyTheme()
    T = Themes[CurrentTheme]
    if not GUI then return end
    -- Применяем ко всем элементам
    for _, obj in ipairs(GUI:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("TextLabel") or obj:IsA("Frame") then
            if obj.Name == "AccentBg" or obj:GetAttribute("AccentBg") then
                obj.BackgroundColor3 = T.Accent
            end
            if obj.Name == "BgElement" or obj:GetAttribute("BgElement") then
                obj.BackgroundColor3 = T.Sec
            end
            if obj.Name == "AccentText" or obj:GetAttribute("AccentText") then
                obj.TextColor3 = T.Accent
            end
            if obj.Name == "TextElement" or obj:GetAttribute("TextElement") then
                obj.TextColor3 = T.Text
            end
        end
    end
    -- Точки/кружки
    if FOVDot then FOVDot.BackgroundColor3 = T.Accent end
    if ADStroke then ADStroke.Color = T.Accent end
    if MainStroke then MainStroke.Color = T.Accent end
    if Title then Title.TextColor3 = T.Accent end
    if AD then AD.TextColor3 = T.Accent end
    if TracerFrame then TracerFrame.BackgroundColor3 = T.Accent end
end

--// ---------------- SETTINGS ----------------
local S = {
    Aim=false, AimRange=100, AimFOV=90, AimSmooth=0.35, CharSmooth=0.25,
    AimHead=true, ForceHead=true, RotateCharacter=false,
    TeamCheck=true, WallCheck=true, StickyTarget=true, Prediction=0.12,
    HoldToAim=false, FlickRelease=true,

    ShowFPS=false, ShowPing=false, ShowWatermark=false,

    FlyEnabled=false, FlySpeed=60,

    NoClip=false,
    SpeedBoost=false, SpeedValue=45,
    JumpBoost=false, JumpValue=100,

    ESP=false, Box=true, Highlight=true, Name=true, Health=true,
    Distance=true, Tracer=true, MaxDistance=400,
}

--// ---------------- GUI PARENT ----------------
local function guiParent()
    if gethui then local ok,h = pcall(gethui) if ok and h then return h end end
    if CoreGui then return CoreGui end
    return PlayerGui
end
local PARENT = guiParent()
local old = PARENT:FindFirstChild("AD_GUI_v53")
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
local function Tween(o, i, pr) return TweenService:Create(o, i, pr) end
local function Play(o, i, pr) TweenService:Create(o, i, pr):Play() end

-- Ripple эффект при тапе
local function addRipple(parent, color)
    local btn = parent:FindFirstChildOfClass("TextButton")
    if not btn then return end
    btn.MouseButton1Down:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = color or T.Accent
        ripple.BackgroundTransparency = 0.7
        ripple.Size = UDim2.fromOffset(0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.ZIndex = 5
        ripple.Parent = parent
        Instance.new("UICorner", { CornerRadius = UDim.new(1,0), Parent = ripple })
        local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
        local tw = Tween(ripple, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(maxSize, maxSize),
            BackgroundTransparency = 1,
        })
        tw:Play()
        tw.Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
end

-- Hover-эффект
local function addHover(parent, hoverColor, normalColor)
    local btn = parent:FindFirstChildOfClass("TextButton")
    if not btn then return end
    btn.MouseEnter:Connect(function()
        Play(parent, TweenInfo.new(0.15), { BackgroundColor3 = hoverColor })
    end)
    btn.MouseLeave:Connect(function()
        Play(parent, TweenInfo.new(0.15), { BackgroundColor3 = normalColor })
    end)
end

--// ---------------- GUI ----------------
local GUI = Create("ScreenGui", {
    Name="AD_GUI_v53", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=PARENT
})
bind(GUI.Destroying:Connect(disconnectAll))

local AD = Create("TextButton", {
    Size=UDim2.fromOffset(52,52), Position=UDim2.new(0,15,0.5,-26),
    BackgroundColor3=T.Bg, Text="AD", TextColor3=T.Accent, TextSize=17,
    Font=Enum.Font.GothamBold, AutoButtonColor=false, Parent=GUI
})
Corner(AD, UDim.new(1,0))
local ADStroke = Stroke(AD, T.Accent, 2)

local Main = Create("Frame", {
    Size=UDim2.fromOffset(320,370), Position=UDim2.new(0.5,-160,0.5,-185),
    BackgroundColor3=T.Bg, Visible=false, ClipsDescendants=true, Parent=GUI
})
Corner(Main, UDim.new(0,12))
local MainStroke = Stroke(Main, T.Accent, 1.5, 0.3)

local Header = Create("Frame", { Size=UDim2.new(1,0,0,40), BackgroundColor3=T.Sec, Parent=Main })
Corner(Header, UDim.new(0,12))

local Title = Create("TextLabel", {
    Size=UDim2.new(1,-80,1,0), Position=UDim2.fromOffset(12,0),
    BackgroundTransparency=1, Text="AD v5.3", TextColor3=T.Accent, TextSize=16,
    Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=Header
})

local Back = Create("TextButton", {
    Size=UDim2.fromOffset(30,26), Position=UDim2.new(1,-68,0,7),
    BackgroundColor3=T.Bg, Text="‹", TextColor3=T.Text, TextSize=20,
    Font=Enum.Font.GothamBold, Visible=false, AutoButtonColor=false, Parent=Header
})
Corner(Back, UDim.new(0,6))

local Close = Create("TextButton", {
    Size=UDim2.fromOffset(30,26), Position=UDim2.new(1,-36,0,7),
    BackgroundColor3=T.Bg, Text="×", TextColor3=T.Text, TextSize=18,
    Font=Enum.Font.Gotham, AutoButtonColor=false, Parent=Header
})
Corner(Close, UDim.new(0,6))

local Content = Create("ScrollingFrame", {
    Size=UDim2.new(1,-10,1,-50), Position=UDim2.fromOffset(5,45),
    BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2,
    ScrollBarImageColor3=T.Accent, ScrollingDirection=Enum.ScrollingDirection.Y,
    AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(),
    ElasticBehavior=Enum.ElasticBehavior.Always, Parent=Main
})
Create("UIPadding", { PaddingLeft=UDim.new(0,3), PaddingRight=UDim.new(0,3), PaddingBottom=UDim.new(0,10), Parent=Content })
Create("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder, Parent=Content })

--// ---------------- COMPONENTS ----------------
local function Clear()
    for _, v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
    end
end

local function fadeIn(el, delay)
    el.BackgroundTransparency = 1
    task.delay(delay or 0, function()
        Play(el, TweenInfo.new(0.25), { BackgroundTransparency = 0.15 })
    end)
end

local function Section(txt)
    return Create("TextLabel", {
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, Text=txt,
        TextColor3=T.Accent2, TextSize=12, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=Content
    })
end

local function Info(txt)
    return Create("TextLabel", {
        Size=UDim2.new(1,0,0,30), BackgroundColor3=T.Sec,
        Text=txt, TextWrapped=true, TextColor3=T.Accent2,
        TextSize=10, Font=Enum.Font.Gotham, Parent=Content
    })
end

local function Button(txt, cb)
    local b = Create("TextButton", { Size=UDim2.new(1,0,0,32), BackgroundColor3=T.Sec, Text="", AutoButtonColor=false, Parent=Content })
    Corner(b, UDim.new(0,6))
    local label = Create("TextLabel", { Size=UDim2.new(1,-30,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=txt, TextColor3=T.Text, TextSize=13, Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left, Parent=b })
    Create("TextLabel", { Size=UDim2.fromOffset(20,32), Position=UDim2.new(1,-25,0,0), BackgroundTransparency=1, Text="›", TextColor3=T.Accent, TextSize=16, Font=Enum.Font.GothamBold, Parent=b })

    b.MouseEnter:Connect(function() Play(b, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(T.Sec.R*255+20, T.Sec.G*255+20, T.Sec.B*255+20) }) end)
    b.MouseLeave:Connect(function() Play(b, TweenInfo.new(0.15), { BackgroundColor3 = T.Sec }) end)
    b.MouseButton1Click:Connect(function()
        Play(b, TweenInfo.new(0.1), { BackgroundColor3 = T.Accent })
        task.delay(0.1, function() Play(b, TweenInfo.new(0.15), { BackgroundColor3 = T.Sec }) end)
        cb()
    end)
    addRipple(b, T.Accent)
    return b
end

local function Toggle(txt, initial, cb)
    local state = { v = initial }
    local b = Create("TextButton", { Size=UDim2.new(1,0,0,28), BackgroundColor3=T.Sec, Text="", AutoButtonColor=false, Parent=Content })
    Corner(b, UDim.new(0,6))
    Create("TextLabel", { Size=UDim2.new(1,-50,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=txt, TextColor3=T.Text, TextSize=12, Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left, Parent=b })
    local sw = Create("Frame", { Size=UDim2.fromOffset(32,16), Position=UDim2.new(1,-40,0.5,-8), BackgroundColor3=Color3.fromRGB(50,50,60), Parent=b })
    Corner(sw, UDim.new(1,0))
    local dot = Create("Frame", { Size=UDim2.fromOffset(12,12), Position=UDim2.fromOffset(2,2), BackgroundColor3=Color3.fromRGB(200,200,210), Parent=sw })
    Corner(dot, UDim.new(1,0))

    local function apply(instant)
        local col = state.v and T.Accent or Color3.fromRGB(50,50,60)
        local pos = state.v and UDim2.fromOffset(18,2) or UDim2.fromOffset(2,2)
        if instant then sw.BackgroundColor3=col dot.Position=pos
        else
            Play(sw, TweenInfo.new(0.15), {BackgroundColor3=col})
            Play(dot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position=pos})
        end
    end
    apply(true)
    b.MouseButton1Click:Connect(function()
        state.v = not state.v
        apply(false)
        if cb then local ok, err = pcall(cb, state.v) if not ok then warn(err) end end
    end)
    b.MouseEnter:Connect(function() Play(b, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(T.Sec.R*255+15, T.Sec.G*255+15, T.Sec.B*255+15) }) end)
    b.MouseLeave:Connect(function() Play(b, TweenInfo.new(0.15), { BackgroundColor3 = T.Sec }) end)
    return b, state
end

local function Number(txt, initial, min, max, cb)
    local f = Create("Frame", { Size=UDim2.new(1,0,0,28), BackgroundColor3=T.Sec, Parent=Content })
    Corner(f, UDim.new(0,6))
    Create("TextLabel", { Size=UDim2.new(1,-70,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=txt, TextColor3=T.Text, TextSize=12, Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left, Parent=f })
    local box = Create("TextBox", { Size=UDim2.fromOffset(55,20), Position=UDim2.new(1,-62,0.5,-10), BackgroundColor3=T.Bg, Text=tostring(initial), TextColor3=T.Accent, TextSize=11, Font=Enum.Font.GothamBold, ClearTextOnFocus=false, Parent=f })
    Corner(box, UDim.new(0,4))
    box.Focused:Connect(function() Play(box, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(T.Bg.R*255+10, T.Bg.G*255+10, T.Bg.B*255+10) }) end)
    box.FocusLost:Connect(function()
        Play(box, TweenInfo.new(0.15), { BackgroundColor3 = T.Bg })
        local n = tonumber(box.Text)
        if not n then box.Text = tostring(initial) return end
        n = math.clamp(n, min, max)
        box.Text = tostring(n)
        if cb then local ok, err = pcall(cb, n) if not ok then warn(err) end end
    end)
    return f
end

local function Slider(txt, initial, min, max, cb)
    local frame = Create("Frame", { Size=UDim2.new(1,0,0,44), BackgroundColor3=T.Sec, Parent=Content })
    Corner(frame, UDim.new(0,6))
    Create("TextLabel", { Size=UDim2.new(0.6,-10,0,20), Position=UDim2.fromOffset(10,2), BackgroundTransparency=1, Text=txt, TextColor3=T.Text, TextSize=12, Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left, Parent=frame })
    local valueLabel = Create("TextLabel", { Size=UDim2.new(0.4,-10,0,20), Position=UDim2.new(0.6,0,0,2), BackgroundTransparency=1, Text=string.format("%d/%d", math.floor(initial), max), TextColor3=T.Accent, TextSize=12, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Right, Parent=frame })
    local track = Create("Frame", { Size=UDim2.new(1,-20,0,8), Position=UDim2.new(0,10,0,28), BackgroundColor3=Color3.fromRGB(40,44,54), BorderSizePixel=0, Parent=frame })
    Corner(track, UDim.new(1,0))
    local fill = Create("Frame", { Size=UDim2.new(0,0,1,0), BackgroundColor3=T.Accent, BorderSizePixel=0, Parent=track })
    Corner(fill, UDim.new(1,0))
    local knob = Create("Frame", { Size=UDim2.fromOffset(16,16), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(0,0,0.5,0), BackgroundColor3=Color3.fromRGB(240,244,255), BorderSizePixel=0, ZIndex=2, Parent=track })
    Corner(knob, UDim.new(1,0))
    Create("UIStroke", { Color=T.Accent, Thickness=2, Parent=knob })
    local hitbox = Create("TextButton", { Size=UDim2.new(1,0,0,32), Position=UDim2.new(0,0,0,-12), BackgroundTransparency=1, Text="", AutoButtonColor=false, Parent=track })
    local value = math.clamp(initial, min, max)
    local dragging = false
    local function updateVisual(animate)
        local ratio = (value - min) / math.max(max - min, 1)
        local tgtFill = UDim2.new(ratio,0,1,0)
        local tgtKnob = UDim2.new(ratio,0,0.5,0)
        if animate then
            Play(fill, TweenInfo.new(0.12), { Size = tgtFill })
            Play(knob, TweenInfo.new(0.12), { Position = tgtKnob })
        else
            fill.Size = tgtFill
            knob.Position = tgtKnob
        end
        valueLabel.Text = string.format("%d/%d", math.floor(value), max)
    end
    local function setFromX(x)
        local trackAbs = track.AbsolutePosition
        local trackSize = track.AbsoluteSize.X
        if trackSize <= 0 then return end
        local rel = math.clamp((x - trackAbs.X) / trackSize, 0, 1)
        value = min + rel * (max - min)
        updateVisual(false)
        if cb then local ok, err = pcall(cb, value) if not ok then warn(err) end end
    end
    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Play(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(22,22) })
            setFromX(input.Position.X)
        end
    end)
    bind(UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            setFromX(input.Position.X)
        end
    end))
    bind(UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                Play(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(16,16) })
            end
        end
    end))
    updateVisual(true)
    return frame
end

local function LanguageSelector()
    local row = Create("Frame", { Size=UDim2.new(1,0,0,32), BackgroundColor3=T.Sec, Parent=Content })
    Corner(row, UDim.new(0,6))
    local left = Create("TextButton", { Size=UDim2.new(0.5,-3,1,-4), Position=UDim2.fromOffset(2,2), BackgroundColor3=(CurrentLang=="EN") and T.Accent or Color3.fromRGB(35,38,46), Text=L("set_lang_en"), TextColor3=Color3.fromRGB(240,240,250), TextSize=12, Font=Enum.Font.GothamBold, AutoButtonColor=false, Parent=row })
    Corner(left, UDim.new(0,5))
    local right = Create("TextButton", { Size=UDim2.new(0.5,-3,1,-4), Position=UDim2.new(0.5,1,0,2), BackgroundColor3=(CurrentLang=="RU") and T.Accent or Color3.fromRGB(35,38,46), Text=L("set_lang_ru"), TextColor3=Color3.fromRGB(240,240,250), TextSize=12, Font=Enum.Font.GothamBold, AutoButtonColor=false, Parent=row })
    Corner(right, UDim.new(0,5))
    left.MouseButton1Click:Connect(function() if CurrentLang ~= "EN" then CurrentLang = "EN" SettingsPage() end end)
    right.MouseButton1Click:Connect(function() if CurrentLang ~= "RU" then CurrentLang = "RU" SettingsPage() end end)
end

local function ThemeSelector()
    local row = Create("Frame", { Size=UDim2.new(1,0,0,44), BackgroundColor3=T.Sec, Parent=Content })
    Corner(row, UDim.new(0,6))
    Create("TextLabel", { Size=UDim2.new(1,-10,0,16), Position=UDim2.fromOffset(10,4), BackgroundTransparency=1, Text=L("set_theme_label"), TextColor3=T.Text, TextSize=11, Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left, Parent=row })

    local colorRow = Create("Frame", { Size=UDim2.new(1,-20,0,22), Position=UDim2.fromOffset(10,20), BackgroundTransparency=1, Parent=row })
    Create("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder, Parent=colorRow })

    local names = {"Purple", "Ocean", "Crimson"}
    for i, name in ipairs(names) do
        local c = Themes[name]
        local swatch = Create("TextButton", {
            Size = UDim2.fromOffset(24,22), BackgroundColor3 = c.Accent,
            Text = "", AutoButtonColor = false, LayoutOrder = i,
            Parent = colorRow
        })
        Corner(swatch, UDim.new(0,6))
        if CurrentTheme == name then
            Stroke(swatch, Color3.fromRGB(255,255,255), 2)
        end
        swatch.MouseButton1Click:Connect(function()
            if CurrentTheme ~= name then
                CurrentTheme = name
                applyTheme()
                SettingsPage()
            end
        end)
    end
end

--// ---------------- FOV ----------------
local FOV = Create("Frame", { AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(180,180), BackgroundTransparency=1, Visible=false, ZIndex=100, Active=false, Parent=GUI })
Corner(FOV, UDim.new(1,0))
Stroke(FOV, T.Accent, 1.5, 0.15)
local FOVDot = Create("Frame", { AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(3,3), BackgroundColor3=T.Accent, Parent=FOV })
Corner(FOVDot, UDim.new(1,0))
local function UpdateFOV() FOV.Size = UDim2.fromOffset(S.AimFOV*2, S.AimFOV*2) end

--// ---------------- TRACER ----------------
local TracerFrame = Create("Frame", { AnchorPoint=Vector2.new(0.5,1), Position=UDim2.new(0.5,0,1,-60), Size=UDim2.fromOffset(2,0), BackgroundColor3=T.Accent, BorderSizePixel=0, Visible=false, ZIndex=90, Parent=GUI })

--// ---------------- CHARACTER CACHE ----------------
local CharCache = {}
local function setCharacter(player, char)
    CharCache[player] = char
    if not char then return end
    bind(char.AncestryChanged:Connect(function(_, parent) if not parent then CharCache[player] = nil end end))
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
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end
local function getHumanoid(char) return char and char:FindFirstChildOfClass("Humanoid") end
local function getHead(char) return char and char:FindFirstChild("Head") end

--// ---------------- TARGET CHECKS ----------------
local function isTargetable(plr)
    if not plr or plr == LP then return false end
    if not plr.Parent then return false end
    local char = CharCache[plr]
    if not char or not char.Parent or not char:IsDescendantOf(workspace) then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    return true
end

local function isEnemy(plr)
    if not plr or plr == LP then return false end
    if S.TeamCheck and LP.Team and plr.Team and LP.Team == plr.Team then return false end
    return true
end

local function isVisible(char, part)
    if not S.WallCheck then return true end
    if not char or not Camera or not part then return false end
    local filter = { Camera }
    if LP.Character then table.insert(filter, LP.Character) end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = filter
    local hit = workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, params)
    if not hit then return true end
    return hit.Instance:IsDescendantOf(char)
end

--// ---------------- AIM ----------------
local LockedTarget, HoldActive, LastTargetSwitch = nil, false, 0
local TARGET_SWITCH_CD = 0.15
local UNLOCK_COOLDOWN = 1.0
local FLICK_ANGLE_THRESHOLD = math.rad(25)
local FLICK_WINDOW = 1.0
local FLICKS_TO_UNLOCK = 2
local lastCamDir, flickCount, lastFlickTime, unlockUntil = nil, 0, 0, 0

local function getAimPart(char)
    if not char then return nil end
    if S.ForceHead or S.AimHead then return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function predictPosition(part)
    if not part or S.Prediction <= 0 then return part and part.Position or nil end
    local vel = part.AssemblyLinearVelocity or part.Velocity or Vector3.zero
    local dist = (part.Position - Camera.CFrame.Position).Magnitude
    local t = dist / 400
    return part.Position + vel * (S.Prediction * t)
end

local function pixelScore(part, fovLimit)
    if not Camera then return math.huge end
    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen or pos.Z <= 0 then return math.huge end
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X/2, vp.Y/2)
    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
    if d > fovLimit then return math.huge end
    return d
end

local function findTarget()
    if not Camera then return nil end
    local best, bestScore = nil, math.huge
    local camPos = Camera.CFrame.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if isEnemy(plr) and isTargetable(plr) then
            local char = getCharacter(plr)
            local part = char and getAimPart(char)
            if part and (part.Position - camPos).Magnitude <= S.AimRange and isVisible(char, part) then
                local sc = pixelScore(part, S.AimFOV)
                if sc < bestScore then bestScore = sc best = plr end
            end
        end
    end
    return best
end

local function validateTarget(plr)
    if not plr or not isTargetable(plr) or not isEnemy(plr) then return false end
    local char = getCharacter(plr)
    local part = char and getAimPart(char)
    if not part then return false end
    if (part.Position - Camera.CFrame.Position).Magnitude > S.AimRange then return false end
    if not isVisible(char, part) then return false end
    return true
end

local function updateFlick()
    if not S.FlickRelease or not Camera then return end
    local dir = Camera.CFrame.LookVector
    if lastCamDir then
        local delta = math.acos(math.clamp(lastCamDir:Dot(dir), -1, 1))
        if delta > FLICK_ANGLE_THRESHOLD then
            local now = tick()
            if now - lastFlickTime > FLICK_WINDOW then flickCount = 0 end
            flickCount = flickCount + 1
            lastFlickTime = now
            if flickCount >= FLICKS_TO_UNLOCK then
                LockedTarget = nil
                unlockUntil = now + UNLOCK_COOLDOWN
                flickCount = 0
            end
        end
    end
    lastCamDir = dir
    if tick() - lastFlickTime > FLICK_WINDOW then flickCount = 0 end
end

local function aimApply(dt)
    local aimActive = S.Aim and (not S.HoldToAim or HoldActive)
    if not (aimActive and Camera) then LockedTarget = nil lastCamDir = nil return end
    if LockedTarget and not validateTarget(LockedTarget) then LockedTarget = nil end
    updateFlick()
    if tick() < unlockUntil then return end

    local now = tick()
    if not LockedTarget or (now - LastTargetSwitch) > TARGET_SWITCH_CD then
        local nt = findTarget()
        if nt and nt ~= LockedTarget then LockedTarget = nt LastTargetSwitch = now end
    end

    if LockedTarget then
        local char = getCharacter(LockedTarget)
        local part = char and getAimPart(char)
        if not isTargetable(LockedTarget) or not part then LockedTarget = nil return end
        local aimPos = predictPosition(part)
        local desiredCam = CFrame.lookAt(Camera.CFrame.Position, aimPos)
        if S.AimSmooth >= 0.99 then
            Camera.CFrame = desiredCam
        else
            local smooth = math.clamp(S.AimSmooth * (dt * 60), 0.01, 1)
            Camera.CFrame = Camera.CFrame:Lerp(desiredCam, smooth)
        end
        if S.RotateCharacter then
            local myChar = LP.Character
            local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if hrp then
                local myPos = hrp.Position
                local look = Vector3.new(aimPos.X, myPos.Y, aimPos.Z)
                local desiredBody = CFrame.lookAt(myPos, look)
                local bodySmooth = math.clamp(S.CharSmooth * (dt * 60), 0.01, 1)
                local cur = hrp.CFrame
                local newRot = cur.Rotation:Lerp(desiredBody.Rotation, bodySmooth)
                hrp.CFrame = CFrame.new(cur.Position) * newRot
            end
        end
    end
end

--// ---------------- ESP ----------------
local espFolder = Create("Folder", { Name="AD_ESP_v53", Parent=PARENT })
local ESPData = {}
local BOX_COLOR = Color3.fromRGB(255,90,90)
local NAME_COLOR = Color3.fromRGB(255,240,240)
local HL_COLOR = Color3.fromRGB(255,60,60)

local function removeESP(plr)
    local d = ESPData[plr]
    if not d then return end
    for _, obj in pairs(d) do if typeof(obj)=="Instance" then pcall(function() obj:Destroy() end) end end
    ESPData[plr] = nil
end

local function createESP(plr)
    if plr == LP or ESPData[plr] then return end
    local data = {}
    data.Box = Create("BoxHandleAdornment", { Name="ESP_Box", Size=Vector3.new(2,3,1), AlwaysOnTop=true, ZIndex=6, Transparency=0.55, Color3=BOX_COLOR, Visible=false, Parent=espFolder })
    data.Highlight = Create("Highlight", { Name="ESP_HL", FillColor=HL_COLOR, FillTransparency=0.7, OutlineColor=Color3.fromRGB(255,255,255), OutlineTransparency=0.4, DepthMode=Enum.HighlightDepthMode.AlwaysOnTop, Enabled=false, Parent=espFolder })
    local bb = Create("BillboardGui", { Name="ESP_Info", Size=UDim2.fromOffset(140,34), StudsOffsetWorldSpace=Vector3.new(0,3.4,0), AlwaysOnTop=true, Enabled=false, MaxDistance=S.MaxDistance, Parent=espFolder })
    data.Info = bb
    data.Name = Create("TextLabel", { Size=UDim2.new(1,0,0,16), BackgroundTransparency=1, TextColor3=NAME_COLOR, TextStrokeTransparency=0.4, TextStrokeColor3=Color3.fromRGB(0,0,0), Font=Enum.Font.GothamBold, TextSize=13, Text=plr.Name, Parent=bb })
    data.Dist = Create("TextLabel", { Size=UDim2.new(1,0,0,12), Position=UDim2.fromOffset(0,16), BackgroundTransparency=1, TextColor3=Color3.fromRGB(200,240,210), TextStrokeTransparency=0.4, TextStrokeColor3=Color3.fromRGB(0,0,0), Font=Enum.Font.Gotham, TextSize=11, Parent=bb })
    local hpBack = Create("Frame", { Size=UDim2.new(0.9,0,0,3), Position=UDim2.new(0.05,0,1,-6), BackgroundColor3=Color3.fromRGB(40,40,50), BorderSizePixel=0, Parent=bb })
    Corner(hpBack, UDim.new(1,0))
    data.HPBack = hpBack
    data.HPFill = Create("Frame", { Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.fromRGB(60,255,100), BorderSizePixel=0, Parent=hpBack })
    Corner(data.HPFill, UDim.new(1,0))
    ESPData[plr] = data
end

local function updateTracer(target)
    if not S.Tracer or not S.ESP or not target then TracerFrame.Visible = false return end
    local char = getCharacter(target)
    local part = char and getAimPart(char)
    if not part then TracerFrame.Visible = false return end
    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen or pos.Z <= 0 then TracerFrame.Visible = false return end
    local vp = Camera.ViewportSize
    local ox, oy = vp.X/2, vp.Y-60
    local dx, dy = pos.X-ox, pos.Y-oy
    local len = math.sqrt(dx*dx+dy*dy)
    local ang = math.deg(math.atan2(dy,dx))-90
    TracerFrame.Size = UDim2.fromOffset(2,len)
    TracerFrame.Position = UDim2.fromOffset(ox,oy)
    TracerFrame.Rotation = ang
    TracerFrame.Visible = true
    TracerFrame.BackgroundColor3 = T.Accent
end

--// ---------------- VISUALS ----------------
local fpsLabel = Create("TextLabel", { Size=UDim2.fromOffset(120,20), Position=UDim2.new(0,10,0,10), BackgroundTransparency=1, Text="FPS: --", TextColor3=Color3.fromRGB(0,255,0), TextSize=14, Font=Enum.Font.Code, TextXAlignment=Enum.TextXAlignment.Left, Visible=false, Parent=GUI })
local pingLabel = Create("TextLabel", { Size=UDim2.fromOffset(120,20), Position=UDim2.new(0,10,0,30), BackgroundTransparency=1, Text="Ping: -- ms", TextColor3=Color3.fromRGB(255,255,0), TextSize=14, Font=Enum.Font.Code, TextXAlignment=Enum.TextXAlignment.Left, Visible=false, Parent=GUI })
local watermarkLabel = Create("TextLabel", { Size=UDim2.fromOffset(200,20), Position=UDim2.new(1,-210,0,10), BackgroundTransparency=1, Text="AD v5.3 | Delta", TextColor3=Color3.fromRGB(200,200,255), TextSize=14, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Right, Visible=false, Parent=GUI })

task.spawn(function()
    while GUI and GUI.Parent do
        local frames = 0
        local startTime = tick()
        while tick() - startTime < 1 do
            RunService.RenderStepped:Wait()
            frames = frames + 1
        end
        if S.ShowFPS then fpsLabel.Text = "FPS: " .. frames end
    end
end)

task.spawn(function()
    while GUI and GUI.Parent do
        local ok, ping = pcall(function() return LP:GetNetworkPing() end)
        if ok and S.ShowPing then pingLabel.Text = string.format("Ping: %d ms", math.floor(ping * 1000)) end
        task.wait(1)
    end
end)

--// ---------------- FLY ----------------
local flyBV, flyBG = nil, nil
local flyLastVel = Vector3.zero

local function stopFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    flyLastVel = Vector3.zero
end

local function startFly()
    stopFly()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.P = 5000
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBG.P = 12000
    flyBG.D = 200
    flyBG.Parent = hrp
end

bind(RunService.Heartbeat:Connect(function(dt)
    if S.FlyEnabled then
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and flyBV and flyBG then
            local camCF = Camera.CFrame
            local move = hum.MoveDirection
            local forward = camCF.LookVector
            local right = camCF.RightVector
            local desiredDir = (forward * (-move.Z) + right * move.X)
            local targetVel = Vector3.zero
            if desiredDir.Magnitude > 0.05 then
                targetVel = desiredDir.Unit * S.FlySpeed
            end
            flyLastVel = flyLastVel:Lerp(targetVel, math.clamp(dt * 10, 0, 1))
            flyBV.Velocity = flyLastVel
            flyBG.CFrame = camCF
        end
    else
        if flyBV or flyBG then stopFly() end
    end
end))

--// ---------------- HOLD-TO-AIM ----------------
bind(UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if S.HoldToAim and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then HoldActive = true end
end))
bind(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then HoldActive = false end
end))

--// ---------------- MAIN LOOP ----------------
local accum = 0
local UPDATE_STEP = 1/25
local tracerTarget = nil

bind(RunService.RenderStepped:Connect(function(dt)
    aimApply(dt)

    accum = accum + dt
    if accum >= UPDATE_STEP then
        accum = 0
        tracerTarget = nil
        if S.ESP then
            local camPos = Camera and Camera.CFrame.Position or Vector3.zero
            local bestTracerDist = math.huge
            for plr, d in pairs(ESPData) do
                if not isEnemy(plr) or not isTargetable(plr) then
                    d.Info.Enabled=false d.Highlight.Enabled=false d.Box.Visible=false
                else
                    local char = getCharacter(plr)
                    local root = char and getRoot(char)
                    local hum = char and getHumanoid(char)
                    local head = char and getHead(char)
                    if root then
                        local distance = (root.Position - camPos).Magnitude
                        if distance > S.MaxDistance then
                            d.Info.Enabled=false d.Highlight.Enabled=false d.Box.Visible=false
                        else
                            d.Highlight.Enabled = S.Highlight
                            if S.Highlight then d.Highlight.Adornee = char local t = math.clamp(distance/S.MaxDistance,0,1) d.Highlight.FillColor = Color3.new(1,1-t,0.2) end
                            d.Box.Visible = S.Box
                            if S.Box then d.Box.Adornee = root d.Box.Size = Vector3.new(2,3,1) d.Box.Color3 = BOX_COLOR else d.Box.Adornee = nil end
                            d.Info.Enabled = true
                            d.Info.Adornee = head or root
                            d.Info.MaxDistance = S.MaxDistance
                            d.Name.Visible = S.Name
                            d.Name.Text = plr.Name
                            d.Dist.Visible = S.Distance
                            d.Dist.Text = string.format("%d m", math.floor(distance))
                            if S.Health and hum then
                                d.HPBack.Visible = true
                                local ratio = math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
                                d.HPFill.Size = UDim2.fromScale(ratio,1)
                                d.HPFill.BackgroundColor3 = ratio>0.5 and Color3.fromRGB(60,255,100) or ratio>0.25 and Color3.fromRGB(255,200,60) or Color3.fromRGB(255,60,60)
                            else d.HPBack.Visible = false end
                            if S.Tracer and distance < bestTracerDist then bestTracerDist = distance tracerTarget = plr end
                        end
                    end
                end
            end
        else
            for _, d in pairs(ESPData) do d.Info.Enabled=false d.Highlight.Enabled=false d.Box.Visible=false end
        end
    end

    if S.Tracer and S.ESP and tracerTarget then updateTracer(tracerTarget) else TracerFrame.Visible = false end
end))

--// ---------------- HEARTBEAT ----------------
bind(RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.WalkSpeed = S.SpeedBoost and S.SpeedValue or 16
    hum.UseJumpPower = true
    hum.JumpPower = S.JumpBoost and S.JumpValue or 50

    if S.NoClip then
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
        end
    end
end))

--// ---------------- PAGE TRANSITION ----------------
local function animatePageIn()
    Content.CanvasPosition = Vector2.new(0, 0)
    for _, el in ipairs(Content:GetChildren()) do
        if el:IsA("GuiObject") then
            local oldPos = el.Position
            local oldTrans = el.BackgroundTransparency
            el.Position = UDim2.new(oldPos.X.Scale, oldPos.X.Offset + 20, oldPos.Y.Scale, oldPos.Y.Offset)
            if el.BackgroundTransparency < 1 then el.BackgroundTransparency = 1 end
            Play(el, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = oldPos,
                BackgroundTransparency = oldTrans,
            })
        end
    end
end

--// ---------------- PAGES ----------------
local function MainPage()
    Clear()
    Title.Text = "AD v5.3"
    Back.Visible = false
    Section(L("sec_main"))
    Button(L("btn_aim"),      function() AimPage() end)
    Button(L("btn_esp"),      function() ESPPage() end)
    Button(L("btn_visuals"),  function() VisualsPage() end)
    Button(L("btn_fly"),      function() FlyPage() end)
    Button(L("btn_misc"),     function() MiscPage() end)
    Button(L("btn_settings"), function() SettingsPage() end)
    animatePageIn()
end

function AimPage()
    Clear(); Title.Text = L("title_aim"); Back.Visible = true
    Info(L("aim_info")); Section(L("sec_aim_main"))
    Toggle(L("aim_enable"), S.Aim, function(v) S.Aim=v FOV.Visible=v if not v then LockedTarget=nil end end)
    Toggle(L("aim_hold"), S.HoldToAim, function(v) S.HoldToAim=v end)
    Toggle(L("aim_head"), S.AimHead, function(v) S.AimHead=v end)
    Toggle(L("aim_sticky"), S.StickyTarget, function(v) S.StickyTarget=v end)
    Toggle(L("aim_teamcheck"), S.TeamCheck, function(v) S.TeamCheck=v end)
    Toggle(L("aim_wallcheck"), S.WallCheck, function(v) S.WallCheck=v end)
    Toggle(L("aim_rotate_char"), S.RotateCharacter, function(v) S.RotateCharacter=v end)
    Toggle(L("aim_flick"), S.FlickRelease, function(v) S.FlickRelease=v end)
    Info(L("aim_flick_info"))
    Section(L("sec_aim_params"))
    Number(L("aim_range"), S.AimRange, 10, 500, function(v) S.AimRange=v end)
    Number(L("aim_fov"), S.AimFOV, 20, 600, function(v) S.AimFOV=v UpdateFOV() end)
    Slider(L("aim_speed"), math.floor(S.AimSmooth*100), 0, 100, function(v) S.AimSmooth=math.clamp(v/100,0.01,1) end)
    Number(L("aim_body_smooth"), S.CharSmooth, 0.05, 1, function(v) S.CharSmooth=v end)
    Number(L("aim_prediction"), S.Prediction, 0, 0.5, function(v) S.Prediction=v end)
    animatePageIn()
end

function ESPPage()
    Clear(); Title.Text = L("title_esp"); Back.Visible = true
    Section(L("sec_esp_show"))
    Toggle(L("esp_enable"), S.ESP, function(v) S.ESP=v end)
    Toggle(L("esp_box"), S.Box, function(v) S.Box=v end)
    Toggle(L("esp_highlight"), S.Highlight, function(v) S.Highlight=v end)
    Toggle(L("esp_name"), S.Name, function(v) S.Name=v end)
    Toggle(L("esp_health"), S.Health, function(v) S.Health=v end)
    Toggle(L("esp_distance"), S.Distance, function(v) S.Distance=v end)
    Toggle(L("esp_tracer"), S.Tracer, function(v) S.Tracer=v end)
    Toggle(L("esp_teamcheck"), S.TeamCheck, function(v) S.TeamCheck=v end)
    Section(L("sec_esp_params"))
    Number(L("esp_max_dist"), S.MaxDistance, 50, 1000, function(v) S.MaxDistance=v for _,d in pairs(ESPData) do d.Info.MaxDistance=v end end)
    animatePageIn()
end

function VisualsPage()
    Clear(); Title.Text = L("title_visuals"); Back.Visible = true
    Section(L("sec_visuals"))
    Toggle(L("visual_fps"), S.ShowFPS, function(v) S.ShowFPS=v fpsLabel.Visible=v end)
    Toggle(L("visual_ping"), S.ShowPing, function(v) S.ShowPing=v pingLabel.Visible=v end)
    Toggle(L("visual_watermark"), S.ShowWatermark, function(v) S.ShowWatermark=v watermarkLabel.Visible=v end)
    animatePageIn()
end

function FlyPage()
    Clear(); Title.Text = L("title_fly"); Back.Visible = true
    Section(L("sec_fly"))
    Toggle(L("fly_enable"), S.FlyEnabled, function(v) S.FlyEnabled=v if v then startFly() else stopFly() end end)
    Slider(L("fly_speed"), S.FlySpeed, 10, 300, function(v) S.FlySpeed=v end)
    Info("Fly follows your camera. Tilt camera up/down and press forward to climb/dive.")
    animatePageIn()
end

function MiscPage()
    Clear(); Title.Text = L("title_misc"); Back.Visible = true
    Section(L("sec_speed"))
    Toggle(L("misc_speed_boost"), S.SpeedBoost, function(v) S.SpeedBoost=v end)
    Number(L("misc_speed_value"), S.SpeedValue, 16, 200, function(v) S.SpeedValue=v end)
    Section(L("sec_jump"))
    Toggle(L("misc_jump_boost"), S.JumpBoost, function(v) S.JumpBoost=v end)
    Number(L("misc_jump_value"), S.JumpValue, 50, 500, function(v) S.JumpValue=v end)
    Section(L("sec_noclip"))
    Toggle(L("misc_noclip"), S.NoClip, function(v)
        S.NoClip = v
        if not v then
            local char = LP.Character
            if char then for _,d in ipairs(char:GetDescendants()) do if d:IsA("BasePart") then pcall(function() d.CanCollide=true end) end end end
        end
    end)
    Info(L("misc_noclip_info"))
    Info(L("misc_warn"))
    animatePageIn()
end

function SettingsPage()
    Clear(); Title.Text = L("title_settings"); Back.Visible = true
    Section(L("set_lang_label"))
    LanguageSelector()
    Section(L("set_theme_label"))
    ThemeSelector()
    Section(L("sec_settings"))
    Info(L("set_info"))
    animatePageIn()
end

--// ---------------- DRAG ----------------
local function MakeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = target.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
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

--// ---------------- BUTTONS ----------------
Back.MouseButton1Click:Connect(MainPage)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)
AD.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main.Size = UDim2.fromOffset(0,0)
        Play(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(320,370)})
        MainPage()
    else
        Play(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(0,0)})
    end
end)

--// ---------------- INIT ----------------
for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP then createESP(plr) end end
bind(Players.PlayerAdded:Connect(function(plr) if plr ~= LP then task.wait(0.5) createESP(plr) end end))
bind(Players.PlayerRemoving:Connect(removeESP))

--// ---------------- CLEANUP ----------------
_G.__AD_CLEANUP = function()
    local char = LP.Character
    if char then
        for _,d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then pcall(function() d.CanCollide=true end) end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.WalkSpeed = 16 hum.JumpPower = 50 end) end
    end
    disconnectAll()
    stopFly()
    pcall(function() GUI:Destroy() end)
    pcall(function() espFolder:Destroy() end)
end

UpdateFOV()
MainPage()
print("[AD v5.3] loaded — animations + 3 themes")
