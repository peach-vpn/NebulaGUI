--============================================================--
--        ★ AURA MM2 — FIXED (menu opens everywhere) ★        --
--============================================================--

if _G.AURA_CLEANUP then pcall(_G.AURA_CLEANUP) end

local Players    = game:GetService("Players")
local UIS        = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Tween      = game:GetService("TweenService")
local Stats      = game:GetService("Stats")
local CoreGui    = game:GetService("CoreGui")

local LP      = Players.LocalPlayer
local PG      = LP:WaitForChild("PlayerGui")
local Camera  = workspace.CurrentCamera

-- ============ ГЛАВНЫЙ ФИКС: родитель через gethui ============
local function GetGuiParent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    return CoreGui or PG
end

local Connections = {}
local function C(conn) table.insert(Connections, conn) return conn end

C(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end))

-- CONFIG
local CFG = {
    ESP = true,
    ESProles = { Murderer = true, Sheriff = true, Hero = true, Innocent = false },
    ESPName = true, ESPDist = true, ESPChams = true, ESPGun = true,
    ESPMaxDist = 1000,

    AimEnabled = false,
    AimTarget = "Murderer",
    AimPart = "Head",
    AimFOV = 200,
    AimRange = 400,
    AimSmooth = 0.35,
    AimSticky = true,
    AimWallCheck = true,
    AimVisibleFOV = false,

    KillAura = false,
    AuraRange = 12,
    AutoThrow = false,
    ThrowRange = 80,

    AutoGun = false,

    Speed = false, SpeedVal = 60,
    Jump = false, JumpVal = 100,
    Fly = false, FlySpeed = 60,
    Noclip = false,
    InfJump = false,

    AutoCoin = false,

    Spectate = false,
    AntiFling = false,
    FPS = false, Ping = false,
}

-- SKINS
local SKINS = {
    { Name = "Icewing",      Mesh = "rbxassetid://4337254908", Tex = "rbxassetid://4337255336" },
    { Name = "BattleAxe",    Mesh = "rbxassetid://4337254133", Tex = "rbxassetid://4337254520" },
    { Name = "Ghost Knife",  Mesh = "rbxassetid://221360285",  Tex = "rbxassetid://221360322" },
    { Name = "Samurai",      Mesh = "rbxassetid://424649574",  Tex = "rbxassetid://424649618" },
    { Name = "Fang",         Mesh = "rbxassetid://583707893",  Tex = "rbxassetid://584117262" },
}
local SavedSkin = { Mesh = nil, Tex = nil }

-- THEME
local THEMES = {
    Void    = { a = Color3.fromRGB(153, 91, 255),  a2 = Color3.fromRGB(196, 151, 255), bg = Color3.fromRGB(10, 10, 16), panel = Color3.fromRGB(17, 17, 26), card = Color3.fromRGB(24, 24, 36), txt = Color3.fromRGB(245,245,255), sub = Color3.fromRGB(130,128,150), line = Color3.fromRGB(45,42,60) },
    Blood   = { a = Color3.fromRGB(255, 65, 85),   a2 = Color3.fromRGB(255, 130, 145), bg = Color3.fromRGB(16, 10, 12), panel = Color3.fromRGB(26, 17, 19), card = Color3.fromRGB(36, 24, 26), txt = Color3.fromRGB(255,245,245), sub = Color3.fromRGB(150,128,130), line = Color3.fromRGB(60,45,48) },
    Ice     = { a = Color3.fromRGB(70, 170, 255),  a2 = Color3.fromRGB(140, 205, 255), bg = Color3.fromRGB(9, 13, 18),  panel = Color3.fromRGB(15, 22, 30), card = Color3.fromRGB(21, 31, 42), txt = Color3.fromRGB(240,248,255), sub = Color3.fromRGB(128,140,155), line = Color3.fromRGB(40,52,65) },
    Toxic   = { a = Color3.fromRGB(80, 255, 140),  a2 = Color3.fromRGB(150, 255, 185), bg = Color3.fromRGB(8, 14, 11),  panel = Color3.fromRGB(14, 24, 18), card = Color3.fromRGB(19, 34, 25), txt = Color3.fromRGB(240,255,245), sub = Color3.fromRGB(125,145,130), line = Color3.fromRGB(38,58,45) },
}

local ThemeName = "Void"
local T = THEMES[ThemeName]
local Themed = {}
local function theme(obj, prop, key) table.insert(Themed, {obj, prop, key}) end
local function ApplyTheme()
    T = THEMES[ThemeName]
    for _, v in ipairs(Themed) do
        if v[1] and v[1].Parent then v[1][v[2]] = T[v[3]] end
    end
end

-- HELPERS
local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then o[k] = v end end
    o.Parent = parent
    return o
end
local function corner(o, r) return new("UICorner", {CornerRadius = UDim.new(0, r or 6)}, o) end
local function stroke(o, col, th) return new("UIStroke", {Color = col or T.line, Thickness = th or 1, Transparency = 0.25}, o) end
local function tw(o, p, d, style)
    Tween:Create(o, TweenInfo.new(d or 0.22, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p):Play()
end

-- ============ GUI ROOT (ФИКС) ============
local PARENT = GetGuiParent()

local Old = PARENT:FindFirstChild("AURA_MM2")
if Old then Old:Destroy() end

local Screen = new("ScreenGui", {
    Name = "AURA_MM2", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 2147483647,   -- максимум
    Enabled = true,
}, PARENT)

print("[AURA] GUI создан в:", PARENT.Name or PARENT.ClassName)

-- FLOATING ICON
local Icon = new("TextButton", {
    Size = UDim2.fromOffset(56, 56),
    Position = UDim2.new(0, 16, 0.5, -28),
    BackgroundColor3 = T.bg,
    Text = "A", TextColor3 = T.a, TextSize = 22,
    Font = Enum.Font.GothamBlack, AutoButtonColor = false,
    ZIndex = 60,
    Active = true,
}, Screen)
corner(Icon, 16)
local IconStroke = stroke(Icon, T.a, 2)
theme(Icon, "BackgroundColor3", "bg")
theme(IconStroke, "Color", "a")

-- pulse
task.spawn(function()
    while Icon.Parent do
        tw(IconStroke, {Transparency = 0.4}, 1)
        task.wait(1)
        tw(IconStroke, {Transparency = 0}, 1)
        task.wait(1)
    end
end)

-- MAIN WINDOW
local Win = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(460, 300),
    BackgroundColor3 = T.bg, Visible = false,
    ClipsDescendants = true, ZIndex = 10,
}, Screen)
corner(Win, 14)
local WinStroke = stroke(Win, T.a, 1.5)
theme(Win, "BackgroundColor3", "bg")
theme(WinStroke, "Color", "a")

local UIScale = new("UIScale", {Scale = 1}, Win)

-- TOP BAR
local TopBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = T.panel,
    BorderSizePixel = 0, ZIndex = 11,
}, Win)
corner(TopBar, 14)
theme(TopBar, "BackgroundColor3", "panel")

local Title = new("TextLabel", {
    Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -60, 1, 0),
    BackgroundTransparency = 1, Text = "AURA",
    TextColor3 = T.txt, TextSize = 15, Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
}, TopBar)
theme(Title, "TextColor3", "txt")

local VerLbl = new("TextLabel", {
    Position = UDim2.new(1, -92, 0, 8), Size = UDim2.fromOffset(44, 26),
    BackgroundColor3 = T.a, Text = "MM2", TextColor3 = T.bg,
    TextSize = 9, Font = Enum.Font.GothamBlack, ZIndex = 12,
}, TopBar)
corner(VerLbl, 5)
theme(VerLbl, "BackgroundColor3", "a")
theme(VerLbl, "TextColor3", "bg")

local CloseBtn = new("TextButton", {
    Position = UDim2.new(1, -40, 0, 9), Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = T.card, Text = "×", TextColor3 = T.txt,
    TextSize = 18, Font = Enum.Font.GothamBold,
    AutoButtonColor = false, ZIndex = 12,
}, TopBar)
corner(CloseBtn, 6)
theme(CloseBtn, "BackgroundColor3", "card")
theme(CloseBtn, "TextColor3", "txt")

-- NAV (bottom tabs)
local Nav = new("Frame", {
    Position = UDim2.new(0, 0, 1, -44), Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = T.panel, BorderSizePixel = 0, ZIndex = 11,
}, Win)
corner(Nav, 14)
theme(Nav, "BackgroundColor3", "panel")

local NavPad = new("Frame", {
    Size = UDim2.new(1, -12, 1, -8), Position = UDim2.fromOffset(6, 4),
    BackgroundTransparency = 1, ZIndex = 12,
}, Nav)

new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder,
}, NavPad)

-- CONTENT
local Content = new("Frame", {
    Position = UDim2.new(0, 0, 0, 42), Size = UDim2.new(1, 0, 1, -86),
    BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 11,
}, Win)

local Pages = {}
local NavBtns = {}

local NAV_ITEMS = {
    {Name = "Visual", Icon = "◉"},
    {Name = "Combat", Icon = "⌖"},
    {Name = "Player", Icon = "▲"},
    {Name = "Farm",   Icon = "◆"},
    {Name = "Skins",  Icon = "✦"},
    {Name = "Misc",   Icon = "☰"},
}

local function CreatePage(name)
    local pg = new("ScrollingFrame", {
        Name = name, Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = T.a,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(), Visible = false, ZIndex = 12,
    }, Content)
    new("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 8)}, pg)
    new("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, pg)
    theme(pg, "ScrollBarImageColor3", "a")
    Pages[name] = pg
    return pg
end

local function SelectPage(name)
    for n, pg in pairs(Pages) do
        pg.Visible = (n == name)
    end
    for n, btn in pairs(NavBtns) do
        local sel = (n == name)
        tw(btn.Btn, {BackgroundColor3 = sel and T.a or T.card}, 0.15)
        btn.Icon.TextColor3 = sel and T.bg or T.sub
        btn.Lbl.TextColor3 = sel and T.bg or T.sub
    end
end

local function CreateNav(name, iconChar, order)
    local b = new("TextButton", {
        Size = UDim2.new(1/#NAV_ITEMS, -3, 1, 0),
        BackgroundColor3 = T.card, Text = "", AutoButtonColor = false,
        LayoutOrder = order, ZIndex = 13, Active = true,
    }, NavPad)
    corner(b, 8)
    local ic = new("TextLabel", {Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 4), BackgroundTransparency = 1, Text = iconChar, TextColor3 = T.sub, TextSize = 13, Font = Enum.Font.GothamBold, ZIndex = 14}, b)
    local lb = new("TextLabel", {Size = UDim2.new(1, 0, 0, 11), Position = UDim2.new(0, 0, 1, -15), BackgroundTransparency = 1, Text = name, TextColor3 = T.sub, TextSize = 7, Font = Enum.Font.GothamBold, ZIndex = 14}, b)
    theme(b, "BackgroundColor3", "card")
    NavBtns[name] = {Btn = b, Icon = ic, Lbl = lb}
    b.Activated:Connect(function() SelectPage(name) end)
    b.MouseButton1Click:Connect(function() SelectPage(name) end)
end

for i, item in ipairs(NAV_ITEMS) do
    CreateNav(item.Name, item.Icon, i)
    CreatePage(item.Name)
end

-- COMPONENTS
local function Header(parent, txt)
    local h = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
        Text = txt:upper(), TextColor3 = T.a, TextSize = 9,
        Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = -100, ZIndex = 13,
    }, parent)
    theme(h, "TextColor3", "a")
    return h
end

local function Card(parent, height)
    local f = new("Frame", {
        Size = UDim2.new(1, 0, 0, height or 34),
        BackgroundColor3 = T.card, BorderSizePixel = 0, ZIndex = 13,
    }, parent)
    corner(f, 7)
    stroke(f)
    theme(f, "BackgroundColor3", "card")
    return f
end

local function Toggle(parent, title, get, set)
    local f = Card(parent, 32)

    new("TextLabel", {
        Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -52, 1, 0),
        BackgroundTransparency = 1, Text = title, TextColor3 = T.txt,
        TextSize = 11, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 14,
    }, f)

    local btn = new("TextButton", {
        Position = UDim2.new(1, -42, 0.5, -8), Size = UDim2.fromOffset(32, 16),
        BackgroundColor3 = get() and T.a or T.line, Text = "",
        AutoButtonColor = false, ZIndex = 14, Active = true,
    }, f)
    corner(btn, 8)
    local knob = new("Frame", {
        Position = UDim2.new(0, get() and 17 or 2, 0.5, -6),
        Size = UDim2.fromOffset(12, 12), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 15,
    }, btn)
    corner(knob, 6)

    btn.Activated:Connect(function()
        set(not get())
        local on = get()
        tw(btn, {BackgroundColor3 = on and T.a or T.line}, 0.15)
        tw(knob, {Position = UDim2.new(0, on and 17 or 2, 0.5, -6)}, 0.2, Enum.EasingStyle.Back)
    end)
    return f
end

local function Slider(parent, title, min, max, get, set)
    local f = Card(parent, 44)

    new("TextLabel", {
        Position = UDim2.fromOffset(10, 4), Size = UDim2.new(0.5, -10, 0, 14),
        BackgroundTransparency = 1, Text = title, TextColor3 = T.txt,
        TextSize = 10, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 14,
    }, f)

    local valLbl = new("TextLabel", {
        Position = UDim2.new(0.5, 0, 0, 4), Size = UDim2.new(0.5, -10, 0, 14),
        BackgroundTransparency = 1, Text = tostring(get()), TextColor3 = T.a,
        TextSize = 10, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 14,
    }, f)
    theme(valLbl, "TextColor3", "a")

    local track = new("Frame", {
        Position = UDim2.fromOffset(10, 26), Size = UDim2.new(1, -20, 0, 4),
        BackgroundColor3 = T.line, BorderSizePixel = 0, ZIndex = 14,
    }, f)
    corner(track, 2)

    local fill = new("Frame", {
        Size = UDim2.new((get()-min)/(max-min), 0, 1, 0),
        BackgroundColor3 = T.a, BorderSizePixel = 0, ZIndex = 15,
    }, track)
    corner(fill, 2)
    theme(fill, "BackgroundColor3", "a")

    local knob = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((get()-min)/(max-min), 0, 0.5, 0),
        Size = UDim2.fromOffset(10, 10), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 16,
    }, track)
    corner(knob, 5)
    stroke(knob, T.a, 2)

    local dragging = false
    local function setX(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + rel * (max - min) + 0.5)
        set(v)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        valLbl.Text = tostring(v)
    end

    local hit = new("TextButton", {
        Size = UDim2.new(1, 24, 1, 18), Position = UDim2.fromOffset(-12, -9),
        BackgroundTransparency = 1, Text = "", ZIndex = 17, Active = true,
    }, track)

    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            tw(knob, {Size = UDim2.fromOffset(14, 14)}, 0.1)
            setX(i.Position.X)
        end
    end)
    C(UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            setX(i.Position.X)
        end
    end))
    C(UIS.InputEnded:Connect(function(i)
        if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and dragging then
            dragging = false
            tw(knob, {Size = UDim2.fromOffset(10, 10)}, 0.1)
        end
    end))
    return f
end

local function ActionBtn(parent, title, desc, cb)
    local h = desc and 42 or 30
    local f = Card(parent, h)

    new("TextLabel", {
        Position = UDim2.fromOffset(10, desc and 5 or 0),
        Size = UDim2.new(1, -30, 0, desc and 14 or 30),
        BackgroundTransparency = 1, Text = title, TextColor3 = T.txt,
        TextSize = 11, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = desc and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center, ZIndex = 14,
    }, f)

    if desc then
        new("TextLabel", {
            Position = UDim2.fromOffset(10, 20), Size = UDim2.new(1, -30, 0, 18),
            BackgroundTransparency = 1, Text = desc, TextColor3 = T.sub,
            TextSize = 8, Font = Enum.Font.Gotham, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 14,
        }, f)
    end

    new("TextLabel", {
        Position = UDim2.new(1, -20, 0.5, -6), Size = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1, Text = "›", TextColor3 = T.a,
        TextSize = 13, Font = Enum.Font.GothamBold, ZIndex = 14,
    }, f)

    local btn = new("TextButton", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", ZIndex = 15, Active = true}, f)
    btn.Activated:Connect(function()
        tw(f, {BackgroundColor3 = T.a}, 0.06)
        task.delay(0.08, function() tw(f, {BackgroundColor3 = T.card}, 0.18) end)
        pcall(cb)
    end)
    return f
end

local function Note(parent, txt)
    local f = new("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = 99, ZIndex = 13}, parent)
    new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = txt,
        TextColor3 = T.sub, TextSize = 8, Font = Enum.Font.Gotham,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 14,
    }, f)
end

local function Picker(parent, title, options, get, set)
    local f = Card(parent, 30)
    new("TextLabel", {
        Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -90, 1, 0),
        BackgroundTransparency = 1, Text = title, TextColor3 = T.txt,
        TextSize = 11, Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 14,
    }, f)
    local val = new("TextButton", {
        Position = UDim2.new(1, -76, 0.5, -9), Size = UDim2.fromOffset(66, 18),
        BackgroundColor3 = T.a, Text = tostring(get()), TextColor3 = T.bg,
        TextSize = 9, Font = Enum.Font.GothamBlack, AutoButtonColor = false, ZIndex = 14, Active = true,
    }, f)
    corner(val, 5)
    theme(val, "BackgroundColor3", "a")
    theme(val, "TextColor3", "bg")
    val.Activated:Connect(function()
        local cur = get()
        local idx = table.find(options, cur) or 1
        local nxt = options[(idx % #options) + 1]
        set(nxt)
        val.Text = tostring(nxt)
    end)
    return f
end

-- BUILD PAGES
local VisualPage = Pages.Visual
Header(VisualPage, "ESP")
Toggle(VisualPage, "Enable ESP", function() return CFG.ESP end, function(v) CFG.ESP = v end)
Toggle(VisualPage, "Chams", function() return CFG.ESPChams end, function(v) CFG.ESPChams = v end)
Toggle(VisualPage, "Show Names", function() return CFG.ESPName end, function(v) CFG.ESPName = v end)
Toggle(VisualPage, "Show Distance", function() return CFG.ESPDist end, function(v) CFG.ESPDist = v end)
Toggle(VisualPage, "Gun ESP", function() return CFG.ESPGun end, function(v) CFG.ESPGun = v end)
Header(VisualPage, "Roles")
Toggle(VisualPage, "Murderer (red)", function() return CFG.ESProles.Murderer end, function(v) CFG.ESProles.Murderer = v end)
Toggle(VisualPage, "Sheriff (blue)", function() return CFG.ESProles.Sheriff end, function(v) CFG.ESProles.Sheriff = v end)
Toggle(VisualPage, "Hero (cyan)", function() return CFG.ESProles.Hero end, function(v) CFG.ESProles.Hero = v end)
Toggle(VisualPage, "Innocent (green)", function() return CFG.ESProles.Innocent end, function(v) CFG.ESProles.Innocent = v end)
Header(VisualPage, "Options")
Slider(VisualPage, "Max Distance", 100, 3000, function() return CFG.ESPMaxDist end, function(v) CFG.ESPMaxDist = v end)

local CombatPage = Pages.Combat
Header(CombatPage, "Aimbot")
Toggle(CombatPage, "Enable Aimbot", function() return CFG.AimEnabled end, function(v) CFG.AimEnabled = v end)
Toggle(CombatPage, "Sticky Target", function() return CFG.AimSticky end, function(v) CFG.AimSticky = v end)
Toggle(CombatPage, "Wall Check", function() return CFG.AimWallCheck end, function(v) CFG.AimWallCheck = v end)
Toggle(CombatPage, "Show FOV Circle", function() return CFG.AimVisibleFOV end, function(v) CFG.AimVisibleFOV = v if FOVFrame then FOVFrame.Visible = v end end)
Picker(CombatPage, "Target", {"Murderer", "Sheriff", "All"}, function() return CFG.AimTarget end, function(v) CFG.AimTarget = v end)
Picker(CombatPage, "Aim Part", {"Head", "Torso"}, function() return CFG.AimPart end, function(v) CFG.AimPart = v end)
Header(CombatPage, "Aimbot Settings")
Slider(CombatPage, "FOV Radius", 30, 600, function() return CFG.AimFOV end, function(v) CFG.AimFOV = v if FOVFrame then FOVFrame.Size = UDim2.fromOffset(v*2, v*2) end end)
Slider(CombatPage, "Max Range", 50, 1000, function() return CFG.AimRange end, function(v) CFG.AimRange = v end)
Slider(CombatPage, "Smoothness %", 1, 100, function() return math.floor(CFG.AimSmooth*100) end, function(v) CFG.AimSmooth = v/100 end)
Header(CombatPage, "Knife")
Toggle(CombatPage, "Kill Aura", function() return CFG.KillAura end, function(v) CFG.KillAura = v end)
Slider(CombatPage, "Aura Range", 5, 40, function() return CFG.AuraRange end, function(v) CFG.AuraRange = v end)
Toggle(CombatPage, "Auto Throw", function() return CFG.AutoThrow end, function(v) CFG.AutoThrow = v end)
Slider(CombatPage, "Throw Range", 20, 200, function() return CFG.ThrowRange end, function(v) CFG.ThrowRange = v end)
ActionBtn(CombatPage, "Grab Gun", "Teleport to dropped gun & back", function() AutoGunOnce() end)
Toggle(CombatPage, "Auto Grab Gun", function() return CFG.AutoGun end, function(v) CFG.AutoGun = v end)

local PlayerPage = Pages.Player
Header(PlayerPage, "Movement")
Toggle(PlayerPage, "Speed", function() return CFG.Speed end, function(v) CFG.Speed = v end)
Slider(PlayerPage, "Speed Value", 16, 300, function() return CFG.SpeedVal end, function(v) CFG.SpeedVal = v end)
Toggle(PlayerPage, "Jump Power", function() return CFG.Jump end, function(v) CFG.Jump = v end)
Slider(PlayerPage, "Jump Value", 50, 500, function() return CFG.JumpVal end, function(v) CFG.JumpVal = v end)
Toggle(PlayerPage, "Fly", function() return CFG.Fly end, function(v) CFG.Fly = v if v then StartFly() else StopFly() end end)
Slider(PlayerPage, "Fly Speed", 10, 300, function() return CFG.FlySpeed end, function(v) CFG.FlySpeed = v end)
Toggle(PlayerPage, "Noclip", function() return CFG.Noclip end, function(v) CFG.Noclip = v end)
Toggle(PlayerPage, "Infinite Jump", function() return CFG.InfJump end, function(v) CFG.InfJump = v end)

local FarmPage = Pages.Farm
Header(FarmPage, "Auto Farm")
Toggle(FarmPage, "Auto Coin", function() return CFG.AutoCoin end, function(v) CFG.AutoCoin = v end)
Note(FarmPage, "Teleports to nearest coin. Use carefully.")

local SkinsPage = Pages.Skins
Header(SkinsPage, "Knife Skins (local)")
ActionBtn(SkinsPage, "Reset to Default", "Restore original knife", function() ApplySkin(nil) end)
for i, skin in ipairs(SKINS) do
    ActionBtn(SkinsPage, skin.Name, "Apply " .. skin.Name, function() ApplySkin(skin) end)
end
Note(SkinsPage, "Client-side only. Others see your real knife.")

local MiscPage = Pages.Misc
Header(MiscPage, "Camera & Protection")
Toggle(MiscPage, "Spectate Murderer", function() return CFG.Spectate end, function(v) CFG.Spectate = v end)
Toggle(MiscPage, "Anti Fling", function() return CFG.AntiFling end, function(v) CFG.AntiFling = v end)
Header(MiscPage, "Overlays")
Toggle(MiscPage, "FPS Counter", function() return CFG.FPS end, function(v) CFG.FPS = v; FpsLbl.Visible = v end)
Toggle(MiscPage, "Ping Counter", function() return CFG.Ping end, function(v) CFG.Ping = v; PingLbl.Visible = v end)
Header(MiscPage, "Theme")
Picker(MiscPage, "Color Theme", {"Void", "Blood", "Ice", "Toxic"}, function() return ThemeName end, function(v) ThemeName = v; ApplyTheme() end)

-- FOV CIRCLE
local FOVFrame = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(CFG.AimFOV*2, CFG.AimFOV*2),
    BackgroundTransparency = 1, Visible = false, ZIndex = 5,
}, Screen)
corner(FOVFrame, 999)
local FOVStroke = stroke(FOVFrame, T.a, 1.5)
theme(FOVStroke, "Color", "a")

-- OVERLAYS
local FpsLbl = new("TextLabel", {Size = UDim2.fromOffset(80, 16), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = "60 FPS", TextColor3 = Color3.fromRGB(90,255,140), TextSize = 12, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, ZIndex = 50}, Screen)
local PingLbl = new("TextLabel", {Size = UDim2.fromOffset(80, 16), Position = UDim2.new(0, 10, 0, 26), BackgroundTransparency = 1, Text = "0 ms", TextColor3 = Color3.fromRGB(255,220,90), TextSize = 12, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, ZIndex = 50}, Screen)

task.spawn(function()
    while Screen.Parent do
        local f = 0
        local s = os.clock()
        while os.clock() - s < 1 do RunService.RenderStepped:Wait() f += 1 end
        if CFG.FPS then FpsLbl.Text = f .. " FPS" end
    end
end)
task.spawn(function()
    while Screen.Parent do
        if CFG.Ping then
            local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ok then PingLbl.Text = math.floor(v) .. " ms" end
        end
        task.wait(0.5)
    end
end)

-- ROLES
local RoleCache = {}
local function GetRole(plr)
    if RoleCache[plr.Name] then return RoleCache[plr.Name] end
    local char = plr.Character
    if not char then return "Innocent" end

    local attr = plr:GetAttribute("Role") or char:GetAttribute("Role")
    if attr then RoleCache[plr.Name] = tostring(attr) return tostring(attr) end

    local function checkTool(t)
        if not t then return nil end
        local n = string.lower(t.Name)
        if string.find(n, "knife") or string.find(n, "dagger") or string.find(n, "blade") then return "Murderer" end
        if string.find(n, "gun") or string.find(n, "pistol") or string.find(n, "revolver") then return "Sheriff" end
        return nil
    end

    local r = checkTool(char:FindFirstChildOfClass("Tool"))
    if r then RoleCache[plr.Name] = r return r end

    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            r = checkTool(t)
            if r then RoleCache[plr.Name] = r return r end
        end
    end
    return "Innocent"
end

C(LP.CharacterAdded:Connect(function()
    task.wait(2)
    RoleCache = {}
end))

local ROLE_COLORS = {
    Murderer = Color3.fromRGB(255, 60, 70),
    Sheriff  = Color3.fromRGB(70, 140, 255),
    Hero     = Color3.fromRGB(80, 215, 255),
    Innocent = Color3.fromRGB(80, 230, 120),
}

local function IsGun(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name)
    return string.find(n, "gun") or string.find(n, "pistol") or string.find(n, "revolver")
end

-- ESP
local EspFolder = new("Folder", {Name = "ESP"}, Screen)
local EspData = {}

local function RemoveESP(plr)
    local d = EspData[plr]
    if not d then return end
    for _, o in pairs(d) do
        if typeof(o) == "Instance" then pcall(function() o:Destroy() end) end
    end
    EspData[plr] = nil
end

local function CreateESP(plr)
    if plr == LP or EspData[plr] then return end
    local d = {}
    d.Chams = new("Highlight", {FillTransparency = 0.75, OutlineTransparency = 0.3, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Enabled = false, Parent = EspFolder})
    d.Billboard = new("BillboardGui", {Size = UDim2.fromOffset(110, 32), StudsOffset = Vector3.new(0, 2.9, 0), AlwaysOnTop = true, Enabled = false, MaxDistance = CFG.ESPMaxDist, Parent = EspFolder})
    d.Name = new("TextLabel", {Size = UDim2.new(1,0,0,13), BackgroundTransparency = 1, TextStrokeTransparency = 0.3, Font = Enum.Font.GothamBold, TextSize = 11, Text = plr.Name, Parent = d.Billboard})
    d.Dist = new("TextLabel", {Size = UDim2.new(1,0,0,11), Position = UDim2.fromOffset(0,13), BackgroundTransparency = 1, TextStrokeTransparency = 0.3, Font = Enum.Font.Gotham, TextSize = 9, Text = "", TextColor3 = Color3.fromRGB(190,255,190), Parent = d.Billboard})
    EspData[plr] = d
end

local GunFolder = new("Folder", {Name = "Guns"}, Screen)
local GunEsp = {}
local function CreateGunESP(tool)
    if GunEsp[tool] then return end
    new("Highlight", {FillColor = Color3.fromRGB(255, 220, 60), FillTransparency = 0.5, OutlineTransparency = 0.3, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Adornee = tool, Parent = GunFolder})
    local bb = new("BillboardGui", {Size = UDim2.fromOffset(70, 14), StudsOffset = Vector3.new(0, 1.4, 0), AlwaysOnTop = true, Adornee = tool, Parent = GunFolder})
    new("TextLabel", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "GUN", TextColor3 = Color3.fromRGB(255,220,60), TextStrokeTransparency = 0.2, Font = Enum.Font.GothamBlack, TextSize = 10, Parent = bb})
    GunEsp[tool] = true
end
local function RemoveGunESP(tool)
    for _, o in ipairs(GunFolder:GetChildren()) do
        if o.Adornee == tool then o:Destroy() end
    end
    GunEsp[tool] = nil
end

task.spawn(function()
    while Screen.Parent do
        task.wait(0.4)
        if CFG.ESPGun then
            for _, o in ipairs(workspace:GetDescendants()) do
                if o:IsA("Tool") and IsGun(o) and not GunEsp[o] then CreateGunESP(o) end
            end
            for tool in pairs(GunEsp) do
                if not tool.Parent then RemoveGunESP(tool) end
            end
        else
            for tool in pairs(GunEsp) do RemoveGunESP(tool) end
        end
    end
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP then CreateESP(plr) end
end
C(Players.PlayerAdded:Connect(function(plr) task.wait(0.3) CreateESP(plr) end))
C(Players.PlayerRemoving:Connect(function(plr) RemoveESP(plr) RoleCache[plr.Name] = nil end))

-- AIM
local LockedTarget = nil
local function ValidTarget(plr)
    if not plr or plr == LP then return false end
    local role = GetRole(plr)
    if CFG.AimTarget == "Murderer" and role ~= "Murderer" then return false end
    if CFG.AimTarget == "Sheriff" and role ~= "Sheriff" and role ~= "Hero" then return false end
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function AimPartOf(char)
    if CFG.AimPart == "Head" then
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    end
end

local function WallVisible(plr, part)
    if not CFG.AimWallCheck then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character, Camera}
    local hit = workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, params)
    return not hit or hit.Instance:IsDescendantOf(plr.Character)
end

local function FindTarget()
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X/2, vp.Y/2)
    local best, bestScore = nil, CFG.AimFOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if ValidTarget(plr) then
            local char = plr.Character
            local part = char and AimPartOf(char)
            if part then
                local dist = (part.Position - Camera.CFrame.Position).Magnitude
                if dist <= CFG.AimRange then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen and pos.Z > 0 then
                        local pd = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if pd < bestScore and WallVisible(plr, part) then
                            best = plr
                            bestScore = pd
                        end
                    end
                end
            end
        end
    end
    return best
end

-- FLY
local FlyBV, FlyBG = nil, nil
local FlyVel = Vector3.zero
function StartFly()
    StopFly()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    FlyBV = Instance.new("BodyVelocity")
    FlyBV.MaxForce = Vector3.new(9e4, 9e4, 9e4)
    FlyBV.Parent = hrp
    FlyBG = Instance.new("BodyGyro")
    FlyBG.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
    FlyBG.P = 9000
    FlyBG.Parent = hrp
end
function StopFly()
    if FlyBV then FlyBV:Destroy() FlyBV = nil end
    if FlyBG then FlyBG:Destroy() FlyBG = nil end
    FlyVel = Vector3.zero
end

-- AUTO GUN
local GunBusy = false
function AutoGunOnce()
    if GunBusy then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bestHandle, bestD = nil, math.huge
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Tool") and IsGun(o) then
            local h = o:FindFirstChild("Handle")
            if h then
                local d = (h.Position - hrp.Position).Magnitude
                if d < bestD then bestD = d bestHandle = h end
            end
        end
    end
    if not bestHandle then return end
    GunBusy = true
    task.spawn(function()
        local saved = hrp.CFrame
        pcall(function() hrp.CFrame = bestHandle.CFrame + Vector3.new(0, 2, 0) end)
        for _ = 1, 20 do
            task.wait(0.1)
            if LP.Character and LP.Character:FindFirstChildOfClass("Tool") then break end
        end
        task.wait(0.2)
        pcall(function() hrp.CFrame = saved end)
        GunBusy = false
    end)
end

-- SKINS
function ApplySkin(skin)
    local char = LP.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    local handle = tool and tool:FindFirstChild("Handle")
    if not handle then return end
    local mesh = handle:FindFirstChildOfClass("SpecialMesh")
    if mesh and not SavedSkin.Mesh then
        SavedSkin.Mesh = mesh.MeshId
        SavedSkin.Tex = mesh.TextureId
    end
    if not mesh then
        mesh = Instance.new("SpecialMesh")
        mesh.Parent = handle
    end
    if not skin then
        if SavedSkin.Mesh then mesh.MeshId = SavedSkin.Mesh end
        if SavedSkin.Tex then mesh.TextureId = SavedSkin.Tex end
        return
    end
    mesh.MeshId = skin.Mesh
    mesh.TextureId = skin.Tex
end

-- MAIN LOOP
C(RunService.RenderStepped:Connect(function(dt)
    if CFG.AimEnabled then
        if not (CFG.AimSticky and LockedTarget and ValidTarget(LockedTarget)) then
            LockedTarget = FindTarget()
        end
        if LockedTarget then
            local char = LockedTarget.Character
            local part = char and AimPartOf(char)
            if part and WallVisible(LockedTarget, part) then
                local desired = CFrame.lookAt(Camera.CFrame.Position, part.Position)
                local smooth = math.clamp(CFG.AimSmooth * dt * 60, 0.02, 1)
                if smooth >= 0.99 then
                    Camera.CFrame = desired
                else
                    Camera.CFrame = Camera.CFrame:Lerp(desired, smooth)
                end
            else
                LockedTarget = nil
            end
        end
    else
        LockedTarget = nil
    end

    if CFG.ESP then
        for plr, d in pairs(EspData) do
            local role = GetRole(plr)
            local char = plr.Character
            local show = CFG.ESProles[role] == true
            if show and char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                if hum and hum.Health > 0 and root then
                    local dist = (root.Position - Camera.CFrame.Position).Magnitude
                    if dist <= CFG.ESPMaxDist then
                        local color = ROLE_COLORS[role] or ROLE_COLORS.Innocent
                        d.Billboard.Enabled = true
                        d.Billboard.Adornee = head or root
                        d.Billboard.MaxDistance = CFG.ESPMaxDist
                        d.Name.Visible = CFG.ESPName
                        d.Name.Text = plr.Name
                        d.Name.TextColor3 = color
                        d.Dist.Visible = CFG.ESPDist
                        if CFG.ESPDist then
                            d.Dist.Text = string.format("%s · %dm", role:upper(), math.floor(dist))
                        end
                        d.Chams.Enabled = CFG.ESPChams
                        d.Chams.Adornee = char
                        d.Chams.FillColor = color
                    else
                        d.Billboard.Enabled = false
                        d.Chams.Enabled = false
                    end
                else
                    d.Billboard.Enabled = false
                    d.Chams.Enabled = false
                end
            else
                d.Billboard.Enabled = false
                d.Chams.Enabled = false
            end
        end
    else
        for _, d in pairs(EspData) do
            d.Billboard.Enabled = false
            d.Chams.Enabled = false
        end
    end
end))

C(RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local tool = char and char:FindFirstChildOfClass("Tool")
    local isKnife = tool and (string.find(string.lower(tool.Name), "knife") or string.find(string.lower(tool.Name), "dagger"))

    if CFG.Fly and hrp and hum and FlyBV and FlyBG then
        local move = hum.MoveDirection
        local look = Camera.CFrame.LookVector
        local target = Vector3.zero
        if move.Magnitude > 0.05 then
            target = move.Unit * CFG.FlySpeed
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if flatLook.Magnitude > 0.05 then
                local fd = move:Dot(flatLook.Unit)
                if fd > 0.1 then
                    target = target + Vector3.new(0, look.Y * CFG.FlySpeed * fd, 0)
                end
            end
        end
        FlyVel = FlyVel:Lerp(target, math.clamp(dt * 10, 0, 1))
        FlyBV.Velocity = FlyVel
        FlyBG.CFrame = Camera.CFrame
    end

    if CFG.KillAura and isKnife and hrp then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local tc = plr.Character
                local th = tc and tc:FindFirstChildOfClass("Humanoid")
                local tr = tc and tc:FindFirstChild("HumanoidRootPart")
                if th and th.Health > 0 and tr and (tr.Position - hrp.Position).Magnitude <= CFG.AuraRange then
                    pcall(function()
                        hrp.CFrame = tr.CFrame
                        tool:Activate()
                    end)
                end
            end
        end
    end

    if CFG.AutoThrow and isKnife and hrp then
        local now = tick()
        if not _G.AuraThrowCD or now - _G.AuraThrowCD > 0.6 then
            local best, bestD = nil, CFG.ThrowRange
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and GetRole(plr) ~= "Sheriff" then
                    local tr = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if tr then
                        local d = (tr.Position - hrp.Position).Magnitude
                        if d < bestD then bestD = d best = tr end
                    end
                end
            end
            if best then
                pcall(function()
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, best.Position)
                    tool:Activate()
                end)
                _G.AuraThrowCD = now
            end
        end
    end

    if CFG.Spectate and Camera then
        local found = false
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and GetRole(plr) == "Murderer" then
                local th = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if th then Camera.CameraSubject = th found = true end
                break
            end
        end
        if not found and hum and Camera.CameraSubject ~= hum then
            Camera.CameraSubject = hum
        end
    end

    if CFG.InfJump and hum and UIS:IsKeyDown(Enum.KeyCode.Space) then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

C(RunService.Stepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.UseJumpPower = true
    hum.WalkSpeed = CFG.Speed and CFG.SpeedVal or 16
    hum.JumpPower = CFG.Jump and CFG.JumpVal or 50
    if CFG.Noclip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                pcall(function() p.CanCollide = false end)
            end
        end
    end
end))

-- Anti Fling
task.spawn(function()
    local bv = nil
    while Screen.Parent do
        if CFG.AntiFling and not bv then
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(9e4, 0, 9e4)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
            end
        elseif not CFG.AntiFling and bv then
            bv:Destroy()
            bv = nil
        end
        task.wait(1)
    end
    if bv then bv:Destroy() end
end)

-- Auto Coin
task.spawn(function()
    while Screen.Parent do
        task.wait(0.4)
        if CFG.AutoCoin then
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local best, bestD = nil, math.huge
                for _, o in ipairs(workspace:GetDescendants()) do
                    if o:IsA("BasePart") and string.find(string.lower(o.Name), "coin") and o.Transparency < 1 then
                        local d = (o.Position - hrp.Position).Magnitude
                        if d < bestD and d < 300 then bestD = d best = o end
                    end
                end
                if best then
                    pcall(function() hrp.CFrame = CFrame.new(best.Position + Vector3.new(0, 3, 0)) end)
                end
            end
        end
    end
end)

-- DRAG
local function Draggable(handle, target)
    local drag, start, pos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true start = i.Position pos = target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    C(UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            target.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end))
end

Draggable(TopBar, Win)
Draggable(Icon, Icon)

-- OPEN/CLOSE
local Opened, Busy = false, false
local function SetOpen(state)
    if Busy or Opened == state then return end
    Busy = true
    Opened = state
    if state then
        Win.Visible = true
        UIScale.Scale = 0.85
        tw(UIScale, {Scale = 1}, 0.3, Enum.EasingStyle.Back)
        task.delay(0.3, function() Busy = false end)
    else
        tw(UIScale, {Scale = UIScale.Scale * 0.85}, 0.15)
        task.delay(0.15, function()
            Win.Visible = false
            Busy = false
        end)
    end
end

Icon.MouseButton1Click:Connect(function() SetOpen(not Opened) end)
CloseBtn.MouseButton1Click:Connect(function() SetOpen(false) end)
C(UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then SetOpen(not Opened) end
end))

-- Responsive
local function Fit()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local portrait = vp.X < vp.Y
    local w = portrait and 360 or 460
    local h = portrait and 420 or 300
    Win.Size = UDim2.fromOffset(w, h)
    UIScale.Scale = math.clamp(math.min((vp.X - 20) / w, (vp.Y - 20) / h), 0.5, 1)
end
Fit()
if workspace.CurrentCamera then
    C(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(Fit))
end

SelectPage("Visual")

-- CLEANUP
_G.AURA_CLEANUP = function()
    local char = LP.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.WalkSpeed = 16 hum.JumpPower = 50 end) end
    end
    StopFly()
    for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
    pcall(function() Screen:Destroy() end)
end

print("★ AURA MM2 FIXED — RightShift or tap icon to open")
