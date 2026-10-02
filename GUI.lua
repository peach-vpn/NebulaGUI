--[[
    NebulaGUI
    Roblox Studio
    Mobile-first GUI

    Использование:
    1. Создай LocalScript в:
       StarterPlayer > StarterPlayerScripts

    2. Вставь содержимое этого файла.

    ВАЖНО:
    Этот GUI предназначен для интерфейса собственной Roblox-игры.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    Title = "NEBULA",
    Subtitle = "Mobile Interface",

    MainColor = Color3.fromRGB(139, 92, 246),
    SecondaryColor = Color3.fromRGB(80, 140, 255),

    Background = Color3.fromRGB(8, 9, 15),
    Panel = Color3.fromRGB(15, 17, 27),
    Panel2 = Color3.fromRGB(20, 22, 34),

    Text = Color3.fromRGB(245, 245, 250),
    MutedText = Color3.fromRGB(145, 148, 165),

    AnimationTime = 0.25,
}

--==================================================
-- CLEAN OLD GUI
--==================================================

local oldGui = playerGui:FindFirstChild("NebulaGUI")

if oldGui then
    oldGui:Destroy()
end

--==================================================
-- HELPERS
--==================================================

local function tween(object, properties, duration)
    local info = TweenInfo.new(
        duration or CONFIG.AnimationTime,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

    return TweenService:Create(object, info, properties)
end

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
    return c
end

local function outline(object, color, transparency, thickness)
    local s = Instance.new("UIStroke")

    s.Color = color
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1

    s.Parent = object

    return s
end

local function gradient(object, color1, color2, rotation)
    local g = Instance.new("UIGradient")

    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })

    g.Rotation = rotation or 0
    g.Parent = object

    return g
end

local function label(parent, text, size, color, font)
    local object = Instance.new("TextLabel")

    object.BackgroundTransparency = 1
    object.Text = text
    object.TextSize = size or 14
    object.TextColor3 = color or CONFIG.Text
    object.Font = font or Enum.Font.Gotham

    object.TextXAlignment = Enum.TextXAlignment.Left
    object.Parent = parent

    return object
end

--==================================================
-- SCREEN GUI
--==================================================

local gui = Instance.new("ScreenGui")

gui.Name = "NebulaGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--==================================================
-- MAIN WINDOW
--==================================================

local main = Instance.new("Frame")

main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)

main.Size = UDim2.new(0.88, 0, 0.78, 0)

main.BackgroundColor3 = CONFIG.Background
main.BorderSizePixel = 0
main.ClipsDescendants = true

main.Parent = gui

corner(main, 22)

outline(
    main,
    Color3.fromRGB(100, 80, 160),
    0.35,
    1.5
)

local constraint = Instance.new("UISizeConstraint")

constraint.MinSize = Vector2.new(310, 330)
constraint.MaxSize = Vector2.new(650, 680)

constraint.Parent = main

--==================================================
-- TOP GLOW
--==================================================

local glow = Instance.new("Frame")

glow.Size = UDim2.new(1, 250, 0, 220)
glow.Position = UDim2.new(0.5, -125, 0, -175)

glow.BackgroundColor3 = CONFIG.MainColor
glow.BackgroundTransparency = 0.92

glow.Parent = main

corner(glow, 100)

--==================================================
-- HEADER
--==================================================

local header = Instance.new("Frame")

header.Size = UDim2.new(1, 0, 0, 74)
header.BackgroundTransparency = 1

header.Parent = main

-- logo

local logo = Instance.new("Frame")

logo.Size = UDim2.fromOffset(46, 46)
logo.Position = UDim2.new(0, 17, 0.5, -23)

logo.BackgroundColor3 = CONFIG.MainColor

logo.Parent = header

corner(logo, 14)

gradient(
    logo,
    CONFIG.MainColor,
    CONFIG.SecondaryColor,
    45
)

local logoText = label(
    logo,
    "✦",
    23,
    CONFIG.Text,
    Enum.Font.GothamBold
)

logoText.Size = UDim2.fromScale(1, 1)
logoText.TextXAlignment = Enum.TextXAlignment.Center
logoText.TextYAlignment = Enum.TextYAlignment.Center

-- title

local title = label(
    header,
    CONFIG.Title,
    18,
    CONFIG.Text,
    Enum.Font.GothamBold
)

title.Position = UDim2.new(0, 76, 0, 15)
title.Size = UDim2.new(0, 180, 0, 23)

local subtitle = label(
    header,
    CONFIG.Subtitle,
    11,
    CONFIG.MutedText
)

subtitle.Position = UDim2.new(0, 76, 0, 39)
subtitle.Size = UDim2.new(0, 180, 0, 18)

-- close

local close = Instance.new("TextButton")

close.Size = UDim2.fromOffset(42, 42)
close.Position = UDim2.new(1, -57, 0.5, -21)

close.BackgroundColor3 = CONFIG.Panel2
close.Text = "×"
close.TextSize = 25
close.TextColor3 = CONFIG.MutedText
close.Font = Enum.Font.Gotham

close.AutoButtonColor = false

close.Parent = header

corner(close, 13)

--==================================================
-- CONTENT
--==================================================

local content = Instance.new("Frame")

content.Position = UDim2.new(0, 12, 0, 74)
content.Size = UDim2.new(1, -24, 1, -86)

content.BackgroundTransparency = 1

content.Parent = main

--==================================================
-- SIDEBAR
--==================================================

local sidebar = Instance.new("Frame")

sidebar.Size = UDim2.new(0, 64, 1, 0)

sidebar.BackgroundColor3 = CONFIG.Panel

sidebar.Parent = content

corner(sidebar, 17)

outline(
    sidebar,
    Color3.fromRGB(60, 62, 80),
    0.55,
    1
)

local sideLayout = Instance.new("UIListLayout")

sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.VerticalAlignment = Enum.VerticalAlignment.Center

sideLayout.Padding = UDim.new(0, 10)

sideLayout.Parent = sidebar

--==================================================
-- PAGES
--==================================================

local pages = Instance.new("Frame")

pages.Position = UDim2.new(0, 76, 0, 0)
pages.Size = UDim2.new(1, -76, 1, 0)

pages.BackgroundTransparency = 1

pages.Parent = content

local pageList = {}

local function createPage(name)

    local page = Instance.new("ScrollingFrame")

    page.Name = name

    page.Size = UDim2.fromScale(1, 1)

    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0

    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = CONFIG.MainColor

    page.CanvasSize = UDim2.new(0, 0, 0, 0)

    page.Visible = false

    page.Parent = pages

    local padding = Instance.new("UIPadding")

    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 3)
    padding.PaddingRight = UDim.new(0, 3)

    padding.Parent = page

    local layout = Instance.new("UIListLayout")

    layout.Padding = UDim.new(0, 12)

    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

        page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            layout.AbsoluteContentSize.Y + 25
        )

    end)

    pageList[name] = page

    return page
end

--==================================================
-- HOME
--==================================================

local home = createPage("Home")

local homeTitle = label(
    home,
    "Welcome back",
    22,
    CONFIG.Text,
    Enum.Font.GothamBold
)

homeTitle.Size = UDim2.new(1, 0, 0, 30)

local homeSub = label(
    home,
    player.DisplayName .. " • Mobile",
    11,
    CONFIG.MutedText
)

homeSub.Size = UDim2.new(1, 0, 0, 20)

-- welcome card

local welcome = Instance.new("Frame")

welcome.Size = UDim2.new(1, 0, 0, 110)

welcome.BackgroundColor3 = CONFIG.Panel

welcome.Parent = home

corner(welcome, 18)

outline(
    welcome,
    Color3.fromRGB(65, 60, 90),
    0.55,
    1
)

gradient(
    welcome,
    Color3.fromRGB(24, 20, 40),
    Color3.fromRGB(14, 22, 40),
    20
)

local welcomeText = label(
    welcome,
    "NEBULA",
    20,
    CONFIG.Text,
    Enum.Font.GothamBold
)

welcomeText.Position = UDim2.new(0, 18, 0, 17)
welcomeText.Size = UDim2.new(1, -36, 0, 25)

local welcomeDescription = label(
    welcome,
    "Your mobile control center",
    11,
    CONFIG.MutedText
)

welcomeDescription.Position = UDim2.new(0, 18, 0, 45)
welcomeDescription.Size = UDim2.new(1, -36, 0, 20)

local status = label(
    welcome,
    "●  ONLINE",
    10,
    Color3.fromRGB(100, 220, 155),
    Enum.Font.GothamBold
)

status.Position = UDim2.new(0, 18, 0, 76)
status.Size = UDim2.new(1, -36, 0, 18)

--==================================================
-- HUB
--==================================================

local hub = createPage("Hub")

local hubTitle = label(
    hub,
    "Script Hub",
    22,
    CONFIG.Text,
    Enum.Font.GothamBold
)

hubTitle.Size = UDim2.new(1, 0, 0, 30)

local hubDescription = label(
    hub,
    "Modules for your own Roblox experience",
    11,
    CONFIG.MutedText
)

hubDescription.Size = UDim2.new(1, 0, 0, 20)

local function createModule(name, description)

    local card = Instance.new("Frame")

    card.Size = UDim2.new(1, 0, 0, 82)

    card.BackgroundColor3 = CONFIG.Panel

    card.Parent = hub

    corner(card, 17)

    outline(
        card,
        Color3.fromRGB(55, 57, 75),
        0.55,
        1
    )

    local icon = Instance.new("Frame")

    icon.Size = UDim2.fromOffset(46, 46)
    icon.Position = UDim2.new(0, 14, 0.5, -23)

    icon.BackgroundColor3 = Color3.fromRGB(30, 25, 50)

    icon.Parent = card

    corner(icon, 14)

    local iconText = label(
        icon,
        "✦",
        20,
        CONFIG.MainColor,
        Enum.Font.GothamBold
    )

    iconText.Size = UDim2.fromScale(1, 1)

    iconText.TextXAlignment = Enum.TextXAlignment.Center
    iconText.TextYAlignment = Enum.TextYAlignment.Center

    local nameLabel = label(
        card,
        name,
        14,
        CONFIG.Text,
        Enum.Font.GothamBold
    )

    nameLabel.Position = UDim2.new(0, 73, 0, 14)
    nameLabel.Size = UDim2.new(1, -150, 0, 20)

    local descriptionLabel = label(
        card,
        description,
        10,
        CONFIG.MutedText
    )

    descriptionLabel.Position = UDim2.new(0, 73, 0, 38)
    descriptionLabel.Size = UDim2.new(1, -150, 0, 30)

    descriptionLabel.TextWrapped = true

    local button = Instance.new("TextButton")

    button.Size = UDim2.fromOffset(58, 34)
    button.Position = UDim2.new(1, -72, 0.5, -17)

    button.BackgroundColor3 = CONFIG.MainColor

    button.Text = "OPEN"
    button.TextSize = 9
    button.TextColor3 = CONFIG.Text
    button.Font = Enum.Font.GothamBold

    button.AutoButtonColor = false

    button.Parent = card

    corner(button, 11)

    button.Activated:Connect(function()

        local original = button.Size

        tween(button, {
            Size = UDim2.fromOffset(52, 30)
        }, 0.08):Play()

        task.wait(0.08)

        tween(button, {
            Size = original
        }, 0.12):Play()

    end)

    return card
end

createModule(
    "Example Module",
    "Example interface module for your game."
)

createModule(
    "Player Tools",
    "Interface for your own player systems."
)

createModule(
    "World Tools",
    "Controls for your own game world."
)

--==================================================
-- SETTINGS
--==================================================

local settings = createPage("Settings")

local settingsTitle = label(
    settings,
    "Settings",
    22,
    CONFIG.Text,
    Enum.Font.GothamBold
)

settingsTitle.Size = UDim2.new(1, 0, 0, 30)

local settingsDescription = label(
    settings,
    "Customize your interface",
    11,
    CONFIG.MutedText
)

settingsDescription.Size = UDim2.new(1, 0, 0, 20)

local function createToggle(name, description, default)

    local item = Instance.new("Frame")

    item.Size = UDim2.new(1, 0, 0, 76)

    item.BackgroundColor3 = CONFIG.Panel

    item.Parent = settings

    corner(item, 16)

    outline(
        item,
        Color3.fromRGB(55, 57, 75),
        0.55,
        1
    )

    local titleLabel = label(
        item,
        name,
        13,
        CONFIG.Text,
        Enum.Font.GothamBold
    )

    titleLabel.Position = UDim2.new(0, 16, 0, 13)
    titleLabel.Size = UDim2.new(1, -90, 0, 20)

    local descriptionLabel = label(
        item,
        description,
        10,
        CONFIG.MutedText
    )

    descriptionLabel.Position = UDim2.new(0, 16, 0, 38)
    descriptionLabel.Size = UDim2.new(1, -100, 0, 20)

    local toggle = Instance.new("TextButton")

    toggle.Size = UDim2.fromOffset(48, 28)

    toggle.Position = UDim2.new(1, -64, 0.5, -14)

    toggle.BackgroundColor3 = Color3.fromRGB(65, 68, 82)

    toggle.Text = ""

    toggle.AutoButtonColor = false

    toggle.Parent = item

    corner(toggle, 20)

    local knob = Instance.new("Frame")

    knob.Size = UDim2.fromOffset(22, 22)

    knob.Position = UDim2.new(0, 3, 0.5, -11)

    knob.BackgroundColor3 = CONFIG.Text

    knob.Parent = toggle

    corner(knob, 20)

    local enabled = default == true

    local function refresh()

        if enabled then

            tween(toggle, {
                BackgroundColor3 = CONFIG.MainColor
            }):Play()

            tween(knob, {
                Position = UDim2.new(1, -25, 0.5, -11)
            }):Play()

        else

            tween(toggle, {
                BackgroundColor3 = Color3.fromRGB(65, 68, 82)
            }):Play()

            tween(knob, {
                Position = UDim2.new(0, 3, 0.5, -11)
            }):Play()

        end

    end

    toggle.Activated:Connect(function()

        enabled = not enabled

        refresh()

    end)

    refresh()

    return item
end

createToggle(
    "Animations",
    "Use smooth interface animations.",
    true
)

createToggle(
    "Glow",
    "Enable visual neon effects.",
    true
)

createToggle(
    "Compact Mode",
    "Use smaller interface spacing.",
    false
)

--==================================================
-- SIDEBAR
--==================================================

local currentPage = "Home"

local function selectPage(name, button)

    currentPage = name

    for pageName, page in pairs(pageList) do
        page.Visible = pageName == name
    end

    for _, child in ipairs(sidebar:GetChildren()) do

        if child:IsA("TextButton") then

            tween(child, {
                BackgroundTransparency = 1,
                TextColor3 = CONFIG.MutedText
            }, 0.15):Play()

        end

    end

    tween(button, {
        BackgroundTransparency = 0,
        TextColor3 = CONFIG.Text
    }, 0.15):Play()

end

local function createNavigation(icon, pageName)

    local button = Instance.new("TextButton")

    button.Size = UDim2.fromOffset(46, 46)

    button.BackgroundColor3 = CONFIG.MainColor
    button.BackgroundTransparency = 1

    button.Text = icon
    button.TextSize = 21
    button.TextColor3 = CONFIG.MutedText

    button.Font = Enum.Font.GothamBold

    button.AutoButtonColor = false

    button.Parent = sidebar

    corner(button, 14)

    button.Activated:Connect(function()

        selectPage(pageName, button)

    end)

    return button
end

local homeButton = createNavigation("⌂", "Home")
local hubButton = createNavigation("⚡", "Hub")
local settingsButton = createNavigation("⚙", "Settings")

selectPage("Home", homeButton)

--==================================================
-- MINIMIZE BUTTON
--==================================================

local openButton = Instance.new("TextButton")

openButton.Size = UDim2.fromOffset(58, 58)

openButton.Position = UDim2.new(0, 18, 0.5, -29)

openButton.BackgroundColor3 = CONFIG.Panel

openButton.Text = "✦"
openButton.TextSize = 27
openButton.TextColor3 = CONFIG.Text

openButton.Font = Enum.Font.GothamBold

openButton.Visible = false

openButton.Parent = gui

corner(openButton, 18)

outline(
    openButton,
    CONFIG.MainColor,
    0.35,
    1.5
)

gradient(
    openButton,
    Color3.fromRGB(25, 20, 45),
    Color3.fromRGB(12, 18, 35),
    45
)

--==================================================
-- SHOW / HIDE
--==================================================

local function hideGUI()

    tween(main, {
        Size = UDim2.fromOffset(0, 0)
    }, 0.25):Play()

    task.delay(0.25, function()

        main.Visible = false

        openButton.Visible = true
        openButton.Size = UDim2.fromOffset(0, 0)

        tween(openButton, {
            Size = UDim2.fromOffset(58, 58)
        }, 0.25):Play()

    end)

end

local function showGUI()

    openButton.Visible = false

    main.Visible = true

    main.Size = UDim2.fromOffset(0, 0)

    tween(main, {
        Size = UDim2.new(0.88, 0, 0.78, 0)
    }, 0.3):Play()

end

close.Activated:Connect(hideGUI)
openButton.Activated:Connect(showGUI)

--==================================================
-- MOBILE DRAG
--==================================================

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true

        dragStart = input.Position
        startPosition = main.Position

    end

end)

header.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = false

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - dragStart

    main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,

        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )

end)

--==================================================
-- START ANIMATION
--==================================================

main.Size = UDim2.fromOffset(0, 0)

task.wait(0.15)

tween(main, {
    Size = UDim2.new(0.88, 0, 0.78, 0)
}, 0.45):Play()
