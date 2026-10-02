--==================================================
-- AD MINI GUI
-- Roblox Studio / LocalScript
-- Лёгкий 2D интерфейс для телефона
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- НАСТРОЙКИ
--==================================================

local CONFIG = {
    Name = "ADMiniGUI",

    Accent = Color3.fromRGB(145, 92, 255),

    Background = Color3.fromRGB(14, 14, 20),
    Button = Color3.fromRGB(24, 24, 33),

    Text = Color3.fromRGB(245, 245, 250),
    Muted = Color3.fromRGB(145, 145, 160),

    Animation = 0.18,
}

--==================================================
-- УДАЛЕНИЕ СТАРОЙ ВЕРСИИ
--==================================================

local old = playerGui:FindFirstChild(CONFIG.Name)

if old then
    old:Destroy()
end

--==================================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
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

local function makeText(
    parent,
    value,
    size,
    color,
    font
)

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
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")

gui.Name = CONFIG.Name

gui.ResetOnSpawn = false

gui.IgnoreGuiInset = true

gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--==================================================
-- КРУГЛАЯ КНОПКА AD
--==================================================

local icon = Instance.new("TextButton")

icon.Name = "ADButton"

icon.Size = UDim2.fromOffset(54, 54)

icon.Position = UDim2.new(
    0,
    16,
    0.5,
    -27
)

icon.BackgroundColor3 = CONFIG.Background

icon.Text = "AD"

icon.TextSize = 17

icon.TextColor3 = CONFIG.Text

icon.Font = Enum.Font.GothamBold

icon.AutoButtonColor = false

icon.Parent = gui

-- Полный круг

local iconCorner = Instance.new("UICorner")

iconCorner.CornerRadius = UDim.new(1, 0)

iconCorner.Parent = icon

-- Обводка

local iconStroke = Instance.new("UIStroke")

iconStroke.Color = CONFIG.Accent

iconStroke.Thickness = 1.5

iconStroke.Transparency = 0.1

iconStroke.Parent = icon

--==================================================
-- ГЛАВНОЕ МЕНЮ
--==================================================

local menu = Instance.new("Frame")

menu.Name = "Menu"

menu.AnchorPoint = Vector2.new(0, 0.5)

menu.Position = UDim2.new(
    0,
    82,
    0.5,
    0
)

menu.Size = UDim2.fromOffset(
    235,
    0
)

menu.BackgroundColor3 = CONFIG.Background

menu.Visible = false

menu.ClipsDescendants = true

menu.Parent = gui

corner(menu, 18)

local menuStroke = Instance.new("UIStroke")

menuStroke.Color = Color3.fromRGB(
    55,
    55,
    70
)

menuStroke.Thickness = 1

menuStroke.Transparency = 0.25

menuStroke.Parent = menu

--==================================================
-- ЗАГОЛОВОК
--==================================================

local header = Instance.new("Frame")

header.Size = UDim2.new(
    1,
    0,
    0,
    60
)

header.BackgroundTransparency = 1

header.Parent = menu

-- Заголовок

local title = makeText(
    header,
    "AD МЕНЮ",
    17,
    CONFIG.Text,
    Enum.Font.GothamBold
)

title.Position = UDim2.new(
    0,
    17,
    0,
    10
)

title.Size = UDim2.new(
    1,
    -60,
    0,
    23
)

-- Подзаголовок

local subtitle = makeText(
    header,
    "Мобильная панель",
    10,
    CONFIG.Muted
)

subtitle.Position = UDim2.new(
    0,
    17,
    0,
    33
)

subtitle.Size = UDim2.new(
    1,
    -60,
    0,
    17
)

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
    -44,
    0,
    12
)

close.BackgroundColor3 = CONFIG.Button

close.Text = "×"

close.TextSize = 21

close.TextColor3 = CONFIG.Muted

close.Font = Enum.Font.Gotham

close.AutoButtonColor = false

close.Parent = header

corner(close, 11)

--==================================================
-- КОНТЕЙНЕР КНОПОК
--==================================================

local container = Instance.new("Frame")

container.Position = UDim2.new(
    0,
    10,
    0,
    64
)

container.Size = UDim2.new(
    1,
    -20,
    1,
    -74
)

container.BackgroundTransparency = 1

container.Parent = menu

local layout = Instance.new("UIListLayout")

layout.Padding = UDim.new(
    0,
    8
)

layout.SortOrder = Enum.SortOrder.LayoutOrder

layout.Parent = container

--==================================================
-- СОЗДАНИЕ КНОПКИ
--==================================================

local function createButton(
    name,
    iconText,
    callback
)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(
        1,
        0,
        0,
        46
    )

    button.BackgroundColor3 = CONFIG.Button

    button.Text = ""

    button.AutoButtonColor = false

    button.Parent = container

    corner(button, 13)

    -- Иконка

    local iconLabel = makeText(
        button,
        iconText,
        17,
        CONFIG.Accent,
        Enum.Font.GothamBold
    )

    iconLabel.Position = UDim2.new(
        0,
        13,
        0,
        0
    )

    iconLabel.Size = UDim2.fromOffset(
        28,
        46
    )

    iconLabel.TextXAlignment =
        Enum.TextXAlignment.Center

    iconLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    -- Название

    local nameLabel = makeText(
        button,
        name,
        12,
        CONFIG.Text,
        Enum.Font.GothamMedium
    )

    nameLabel.Position = UDim2.new(
        0,
        49,
        0,
        0
    )

    nameLabel.Size = UDim2.new(
        1,
        -60,
        0,
        46
    )

    nameLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    -- Нажатие

    button.Activated:Connect(function()

        tween(
            button,
            {
                BackgroundColor3 =
                    CONFIG.Accent
            },
            0.08
        ):Play()

        task.wait(0.08)

        tween(
            button,
            {
                BackgroundColor3 =
                    CONFIG.Button
            },
            0.12
        ):Play()

        if callback then
            callback()
        end

    end)

    return button

end

--==================================================
-- ПУНКТЫ МЕНЮ
--==================================================

createButton(
    "Главная",
    "⌂",
    function()

        print("Открыта главная")

    end
)

createButton(
    "Функции",
    "◆",
    function()

        print("Открыты функции")

    end
)

createButton(
    "Настройки",
    "⚙",
    function()

        print("Открыты настройки")

    end
)

createButton(
    "Информация",
    "?",
    function()

        print("AD — мобильное меню")

    end
)

--==================================================
-- СТАТУС
--==================================================

local status = Instance.new("Frame")

status.Size = UDim2.new(
    1,
    0,
    0,
    34
)

status.BackgroundTransparency = 1

status.Parent = container

local statusText = makeText(
    status,
    "●  Готово",
    9,
    Color3.fromRGB(
        100,
        220,
        150
    ),
    Enum.Font.GothamBold
)

statusText.Position = UDim2.new(
    0,
    5,
    0,
    0
)

statusText.Size = UDim2.new(
    1,
    -10,
    1,
    0
)

statusText.TextYAlignment =
    Enum.TextYAlignment.Center

--==================================================
-- ОТКРЫТИЕ / ЗАКРЫТИЕ
--==================================================

local opened = false

local function openMenu()

    if opened then
        return
    end

    opened = true

    menu.Visible = true

    menu.Size = UDim2.fromOffset(
        235,
        0
    )

    tween(
        menu,
        {
            Size = UDim2.fromOffset(
                235,
                300
            )
        },
        0.24
    ):Play()

end

local function closeMenu()

    if not opened then
        return
    end

    opened = false

    tween(
        menu,
        {
            Size = UDim2.fromOffset(
                235,
                0
            )
        },
        0.18
    ):Play()

    task.delay(
        0.18,
        function()

            if not opened then
                menu.Visible = false
            end

        end
    )

end

--==================================================
-- СОБЫТИЯ
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
-- АНИМАЦИЯ AD
--==================================================

icon.MouseButton1Down:Connect(function()

    tween(
        icon,
        {
            Size = UDim2.fromOffset(
                49,
                49
            )
        },
        0.08
    ):Play()

end)

icon.MouseButton1Up:Connect(function()

    tween(
        icon,
        {
            Size = UDim2.fromOffset(
                54,
                54
            )
        },
        0.1
    ):Play()

end)

--==================================================
-- ГОТОВО
--==================================================

print("[AD] Интерфейс успешно загружен")
