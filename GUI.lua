--==================================================
-- AD MINI GUI
-- Roblox Studio / LocalScript
-- Лёгкий мобильный 2D интерфейс
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- НАСТРОЙКИ
--==================================================

local GUI_NAME = "ADMiniGUI"

local PURPLE = Color3.fromRGB(145, 92, 255)
local DARK = Color3.fromRGB(15, 15, 22)
local BUTTON = Color3.fromRGB(27, 27, 37)
local TEXT = Color3.fromRGB(245, 245, 250)
local MUTED = Color3.fromRGB(150, 150, 165)

--==================================================
-- УДАЛЯЕМ СТАРУЮ ВЕРСИЮ
--==================================================

local oldGui = playerGui:FindFirstChild(GUI_NAME)

if oldGui then
    oldGui:Destroy()
end

--==================================================
-- ОСНОВНОЙ SCREEN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

--==================================================
-- КРУГЛАЯ КНОПКА AD
--==================================================

local adButton = Instance.new("TextButton")

adButton.Name = "ADButton"

adButton.AnchorPoint = Vector2.new(0, 0.5)

adButton.Position = UDim2.new(
    0,
    15,
    0.5,
    0
)

adButton.Size = UDim2.fromOffset(58, 58)

adButton.BackgroundColor3 = DARK
adButton.BackgroundTransparency = 0

adButton.BorderSizePixel = 0

adButton.Text = "AD"
adButton.TextColor3 = TEXT
adButton.TextSize = 18
adButton.Font = Enum.Font.GothamBold

adButton.AutoButtonColor = false

adButton.ZIndex = 100

adButton.Parent = gui

--==================================================
-- ДЕЛАЕМ ИКОНКУ КРУГОЙ
--==================================================

local adCorner = Instance.new("UICorner")

adCorner.CornerRadius = UDim.new(1, 0)

adCorner.Parent = adButton

--==================================================
-- ОБВОДКА
--==================================================

local adStroke = Instance.new("UIStroke")

adStroke.Color = PURPLE
adStroke.Thickness = 2
adStroke.Transparency = 0

adStroke.Parent = adButton

--==================================================
-- ВНУТРЕННИЙ КРУГ
--==================================================

local inner = Instance.new("Frame")

inner.Name = "Inner"

inner.AnchorPoint = Vector2.new(0.5, 0.5)

inner.Position = UDim2.fromScale(0.5, 0.5)

inner.Size = UDim2.fromOffset(48, 48)

inner.BackgroundColor3 = Color3.fromRGB(20, 18, 30)

inner.BorderSizePixel = 0

inner.ZIndex = 101

inner.Parent = adButton

local innerCorner = Instance.new("UICorner")

innerCorner.CornerRadius = UDim.new(1, 0)

innerCorner.Parent = inner

--==================================================
-- ТЕКСТ AD
--==================================================

local adText = Instance.new("TextLabel")

adText.Name = "ADText"

adText.BackgroundTransparency = 1

adText.Size = UDim2.fromScale(1, 1)

adText.Text = "AD"

adText.TextColor3 = TEXT

adText.TextSize = 17

adText.Font = Enum.Font.GothamBold

adText.TextXAlignment = Enum.TextXAlignment.Center
adText.TextYAlignment = Enum.TextYAlignment.Center

adText.ZIndex = 102

adText.Parent = inner

--==================================================
-- ГЛАВНОЕ МЕНЮ
--==================================================

local menu = Instance.new("Frame")

menu.Name = "Menu"

menu.AnchorPoint = Vector2.new(0, 0.5)

menu.Position = UDim2.new(
    0,
    85,
    0.5,
    0
)

menu.Size = UDim2.fromOffset(
    245,
    315
)

menu.BackgroundColor3 = DARK

menu.BorderSizePixel = 0

menu.Visible = false

menu.ZIndex = 200

menu.Parent = gui

local menuCorner = Instance.new("UICorner")

menuCorner.CornerRadius = UDim.new(0, 18)

menuCorner.Parent = menu

local menuStroke = Instance.new("UIStroke")

menuStroke.Color = Color3.fromRGB(60, 60, 75)

menuStroke.Thickness = 1

menuStroke.Parent = menu

--==================================================
-- ЗАГОЛОВОК
--==================================================

local title = Instance.new("TextLabel")

title.BackgroundTransparency = 1

title.Position = UDim2.new(
    0,
    17,
    0,
    12
)

title.Size = UDim2.new(
    1,
    -65,
    0,
    25
)

title.Text = "AD МЕНЮ"

title.TextColor3 = TEXT
title.TextSize = 17
title.Font = Enum.Font.GothamBold

title.TextXAlignment = Enum.TextXAlignment.Left

title.ZIndex = 201

title.Parent = menu

--==================================================
-- ПОДЗАГОЛОВОК
--==================================================

local subtitle = Instance.new("TextLabel")

subtitle.BackgroundTransparency = 1

subtitle.Position = UDim2.new(
    0,
    18,
    0,
    36
)

subtitle.Size = UDim2.new(
    1,
    -70,
    0,
    18
)

subtitle.Text = "Мобильная панель"

subtitle.TextColor3 = MUTED
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham

subtitle.TextXAlignment = Enum.TextXAlignment.Left

subtitle.ZIndex = 201

subtitle.Parent = menu

--==================================================
-- КНОПКА ЗАКРЫТИЯ
--==================================================

local close = Instance.new("TextButton")

close.Size = UDim2.fromOffset(
    34,
    34
)

close.Position = UDim2.new(
    1,
    -46,
    0,
    12
)

close.BackgroundColor3 = BUTTON

close.BorderSizePixel = 0

close.Text = "×"

close.TextColor3 = MUTED
close.TextSize = 22
close.Font = Enum.Font.Gotham

close.AutoButtonColor = false

close.ZIndex = 202

close.Parent = menu

local closeCorner = Instance.new("UICorner")

closeCorner.CornerRadius = UDim.new(0, 10)

closeCorner.Parent = close

--==================================================
-- КОНТЕЙНЕР
--==================================================

local container = Instance.new("Frame")

container.BackgroundTransparency = 1

container.Position = UDim2.new(
    0,
    10,
    0,
    70
)

container.Size = UDim2.new(
    1,
    -20,
    1,
    -80
)

container.ZIndex = 201

container.Parent = menu

local layout = Instance.new("UIListLayout")

layout.Padding = UDim.new(
    0,
    8
)

layout.SortOrder = Enum.SortOrder.LayoutOrder

layout.Parent = container

--==================================================
-- СОЗДАНИЕ КНОПОК
--==================================================

local function createButton(text, symbol)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(
        1,
        0,
        0,
        45
    )

    button.BackgroundColor3 = BUTTON

    button.BorderSizePixel = 0

    button.Text = ""

    button.AutoButtonColor = false

    button.ZIndex = 202

    button.Parent = container

    local corner = Instance.new("UICorner")

    corner.CornerRadius = UDim.new(
        0,
        12
    )

    corner.Parent = button

    -- Символ

    local icon = Instance.new("TextLabel")

    icon.BackgroundTransparency = 1

    icon.Position = UDim2.new(
        0,
        10,
        0,
        0
    )

    icon.Size = UDim2.fromOffset(
        32,
        45
    )

    icon.Text = symbol

    icon.TextColor3 = PURPLE

    icon.TextSize = 17

    icon.Font = Enum.Font.GothamBold

    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center

    icon.ZIndex = 203

    icon.Parent = button

    -- Текст

    local label = Instance.new("TextLabel")

    label.BackgroundTransparency = 1

    label.Position = UDim2.new(
        0,
        50,
        0,
        0
    )

    label.Size = UDim2.new(
        1,
        -60,
        1,
        0
    )

    label.Text = text

    label.TextColor3 = TEXT

    label.TextSize = 12

    label.Font = Enum.Font.GothamMedium

    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center

    label.ZIndex = 203

    label.Parent = button

    button.Activated:Connect(function()

        local oldColor = button.BackgroundColor3

        TweenService:Create(
            button,
            TweenInfo.new(0.08),
            {
                BackgroundColor3 = PURPLE
            }
        ):Play()

        task.delay(0.08, function()

            TweenService:Create(
                button,
                TweenInfo.new(0.12),
                {
                    BackgroundColor3 = oldColor
                }
            ):Play()

        end)

    end)

    return button
end

--==================================================
-- ПУНКТЫ
--==================================================

createButton(
    "Главная",
    "⌂"
)

createButton(
    "Функции",
    "◆"
)

createButton(
    "Настройки",
    "⚙"
)

createButton(
    "Информация",
    "?"
)

--==================================================
-- СТАТУС
--==================================================

local status = Instance.new("TextLabel")

status.BackgroundTransparency = 1

status.Size = UDim2.new(
    1,
    0,
    0,
    25
)

status.Text = "●  Готово"

status.TextColor3 = Color3.fromRGB(
    100,
    220,
    150
)

status.TextSize = 9

status.Font = Enum.Font.GothamBold

status.TextXAlignment = Enum.TextXAlignment.Left

status.ZIndex = 203

status.Parent = container

--==================================================
-- ОТКРЫТИЕ МЕНЮ
--==================================================

local opened = false

local function openMenu()

    if opened then
        return
    end

    opened = true

    menu.Visible = true

    menu.Size = UDim2.fromOffset(
        245,
        0
    )

    TweenService:Create(
        menu,
        TweenInfo.new(
            0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.fromOffset(
                245,
                315
            )
        }
    ):Play()

end

--==================================================
-- ЗАКРЫТИЕ
--==================================================

local function closeMenu()

    if not opened then
        return
    end

    opened = false

    local animation = TweenService:Create(
        menu,
        TweenInfo.new(
            0.16,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.In
        ),
        {
            Size = UDim2.fromOffset(
                245,
                0
            )
        }
    )

    animation:Play()

    animation.Completed:Once(function()

        if not opened then
            menu.Visible = false
        end

    end)

end

--==================================================
-- НАЖАТИЕ AD
--==================================================

adButton.Activated:Connect(function()

    if opened then
        closeMenu()
    else
        openMenu()
    end

end)

--==================================================
-- ЗАКРЫТИЕ
--==================================================

close.Activated:Connect(function()

    closeMenu()

end)

--==================================================
-- АНИМАЦИЯ КНОПКИ AD
--==================================================

adButton.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then

        TweenService:Create(
            adButton,
            TweenInfo.new(0.08),
            {
                Size = UDim2.fromOffset(
                    52,
                    52
                )
            }
        ):Play()

    end

end)

adButton.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then

        TweenService:Create(
            adButton,
            TweenInfo.new(0.1),
            {
                Size = UDim2.fromOffset(
                    58,
                    58
                )
            }
        ):Play()

    end

end)

--==================================================
-- ГОТОВО
--==================================================

print("[AD] Интерфейс загружен")

Важно: именно этот файл должен запускаться как LocalScript. Если ты просто вставляешь "GUI.lua" в обычный "Script" в "ServerScriptService", кнопка у игрока не появится.

Если через GitHub ты хочешь именно автоматически подтягивать этот GUI в своей игре, скажи — покажу безопасный вариант для Roblox Studio без Delta/эксплойтов.
