--==================================================
-- NEBULA MINI GUI
-- Roblox Studio / LocalScript
-- Mobile-first / Lightweight 2D
--
-- Для собственной Roblox-игры
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    Name = "NebulaMini",

    Accent = Color3.fromRGB(145, 92, 255),
    Background = Color3.fromRGB(14, 14, 20),
    Button = Color3.fromRGB(24, 24, 33),

    Text = Color3.fromRGB(245, 245, 250),
    Muted = Color3.fromRGB(145, 145, 160),

    Animation = 0.18,
}

--==================================================
-- REMOVE OLD VERSION
--==================================================

local old = playerGui:FindFirstChild(CONFIG.Name)

if old then
    old:Destroy()
end

--==================================================
-- HELPERS
--==================================================

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
    return c
end

local function tween(object, properties, duration)
    return TweenService:Create(
        object,
        TweenInfo.new(
            duration or CONFIG.Animation,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )
end

local function text(parent, value, size, color, font)
    local label = Instance.new("TextLabel")

    label.BackgroundTransparency = 1
    label.Text = value
    label.TextSize = size
    label.TextColor3 = color or CONFIG.Text
    label.Font = font or Enum.Font.Gotham

    label.Parent = parent

    return label
end

--==================================================
-- SCREEN GUI
--==================================================

local gui = Instance.new("ScreenGui")

gui.Name = CONFIG.Name
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--==================================================
-- FLOATING ICON
--==================================================

local icon = Instance.new("TextButton")

icon.Name = "OpenButton"

icon.Size = UDim2.fromOffset(52, 52)
icon.Position = UDim2.new(0, 16, 0.5, -26)

icon.BackgroundColor3 = CONFIG.Background

icon.Text = "N"
icon.TextSize = 22
icon.TextColor3 = CONFIG.Text
icon.Font = Enum.Font.GothamBold

icon.AutoButtonColor = false

icon.Parent = gui

corner(icon, 16)

local iconStroke = Instance.new("UIStroke")

iconStroke.Color = CONFIG.Accent
iconStroke.Thickness = 1.5
iconStroke.Transparency = 0.2

iconStroke.Parent = icon

--==================================================
-- MAIN MENU
--==================================================

local menu = Instance.new("Frame")

menu.Name = "Menu"

menu.AnchorPoint = Vector2.new(0, 0.5)

menu.Position = UDim2.new(0, 78, 0.5, 0)

menu.Size = UDim2.fromOffset(245, 0)

menu.BackgroundColor3 = CONFIG.Background

menu.Visible = false

menu.ClipsDescendants = true

menu.Parent = gui

corner(menu, 18)

local menuStroke = Instance.new("UIStroke")

menuStroke.Color = Color3.fromRGB(55, 55, 70)
menuStroke.Thickness = 1

menuStroke.Transparency = 0.25

menuStroke.Parent = menu

--==================================================
-- HEADER
--==================================================

local header = Instance.new("Frame")

header.Size = UDim2.new(1, 0, 0, 58)

header.BackgroundTransparency = 1

header.Parent = menu

local title = text(
    header,
    "NEBULA",
    17,
    CONFIG.Text,
    Enum.Font.GothamBold
)

title.Position = UDim2.new(0, 17, 0, 10)
title.Size = UDim2.new(1, -55, 0, 22)

local subtitle = text(
    header,
    "Mobile Menu",
    10,
    CONFIG.Muted
)

subtitle.Position = UDim2.new(0, 17, 0, 31)
subtitle.Size = UDim2.new(1, -55, 0, 17)

local close = Instance.new("TextButton")

close.Size = UDim2.fromOffset(34, 34)

close.Position = UDim2.new(1, -44, 0, 12)

close.BackgroundColor3 = CONFIG.Button

close.Text = "×"
close.TextSize = 21
close.TextColor3 = CONFIG.Muted
close.Font = Enum.Font.Gotham

close.AutoButtonColor = false

close.Parent = header

corner(close, 11)

--==================================================
-- BUTTON CONTAINER
--==================================================

local container = Instance.new("Frame")

container.Position = UDim2.new(0, 10, 0, 62)

container.Size = UDim2.new(1, -20, 1, -72)

container.BackgroundTransparency = 1

container.Parent = menu

local layout = Instance.new("UIListLayout")

layout.Padding = UDim.new(0, 8)

layout.SortOrder = Enum.SortOrder.LayoutOrder

layout.Parent = container

--==================================================
-- MENU BUTTON
--==================================================

local function createButton(name, iconText, callback)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, 0, 0, 46)

    button.BackgroundColor3 = CONFIG.Button

    button.Text = ""

    button.AutoButtonColor = false

    button.Parent = container

    corner(button, 13)

    local iconLabel = text(
        button,
        iconText,
        17,
        CONFIG.Accent,
        Enum.Font.GothamBold
    )

    iconLabel.Position = UDim2.new(0, 13, 0, 0)
    iconLabel.Size = UDim2.fromOffset(28, 46)

    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.TextYAlignment = Enum.TextYAlignment.Center

    local nameLabel = text(
        button,
        name,
        12,
        CONFIG.Text,
        Enum.Font.GothamMedium
    )

    nameLabel.Position = UDim2.new(0, 49, 0, 0)
    nameLabel.Size = UDim2.new(1, -60, 0, 46)

    nameLabel.TextYAlignment = Enum.TextYAlignment.Center

    button.Activated:Connect(function()

        tween(button, {
            BackgroundColor3 = CONFIG.Accent
        }, 0.08):Play()

        task.wait(0.08)

        tween(button, {
            BackgroundColor3 = CONFIG.Button
        }, 0.12):Play()

        if callback then
            callback()
        end

    end)

    return button
end

--==================================================
-- BUTTONS
--==================================================

createButton("Home", "⌂", function()
    print("Home")
end)

createButton("Features", "◆", function()
    print("Features")
end)

createButton("Settings", "⚙", function()
    print("Settings")
end)

createButton("About", "?", function()
    print("Nebula Mini GUI")
end)

--==================================================
-- STATUS
--==================================================

local status = Instance.new("Frame")

status.Size = UDim2.new(1, 0, 0, 34)

status.BackgroundTransparency = 1

status.Parent = container

local statusText = text(
    status,
    "●  READY",
    9,
    Color3.fromRGB(100, 220, 150),
    Enum.Font.GothamBold
)

statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.Size = UDim2.new(1, -10, 1, 0)

statusText.TextYAlignment = Enum.TextYAlignment.Center

--==================================================
-- OPEN
--==================================================

local opened = false

local function openMenu()

    if opened then
        return
    end

    opened = true

    menu.Visible = true
    menu.Size = UDim2.fromOffset(245, 0)

    tween(menu, {
        Size = UDim2.fromOffset(245, 300)
    }, 0.25):Play()

end

--==================================================
-- CLOSE
--==================================================

local function closeMenu()

    if not opened then
        return
    end

    opened = false

    local animation = tween(menu, {
        Size = UDim2.fromOffset(245, 0)
    }, 0.2)

    animation:Play()

    task.delay(0.2, function()

        if not opened then
            menu.Visible = false
        end

    end)

end

--==================================================
-- EVENTS
--==================================================

icon.Activated:Connect(function()

    if opened then
        closeMenu()
    else
        openMenu()
    end

end)

close.Activated:Connect(function()
    closeMenu()
end)

--==================================================
-- ICON PRESS ANIMATION
--==================================================

icon.MouseButton1Down:Connect(function()

    tween(icon, {
        Size = UDim2.fromOffset(47, 47)
    }, 0.08):Play()

end)

icon.MouseButton1Up:Connect(function()

    tween(icon, {
        Size = UDim2.fromOffset(52, 52)
    }, 0.1):Play()

end)

--==================================================
-- DONE
--==================================================

print("[NebulaMini] GUI loaded successfully.")
