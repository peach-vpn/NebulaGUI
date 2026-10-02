--// AD GUI
--// Лёгкий интерфейс для Roblox Delta Executor
--// Без внешних библиотек и картинок

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Удаляем старую версию
local old = PlayerGui:FindFirstChild("AD_GUI")
if old then
    old:Destroy()
end

--==================================================
-- ОСНОВА
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AD_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

--==================================================
-- КРУГЛАЯ КНОПКА AD
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "AD_Button"
OpenButton.Size = UDim2.fromOffset(58, 58)
OpenButton.Position = UDim2.new(0, 18, 0.5, -29)
OpenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
OpenButton.Text = "AD"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 18
OpenButton.Font = Enum.Font.GothamBold
OpenButton.AutoButtonColor = false
OpenButton.Parent = ScreenGui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = OpenButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(120, 70, 255)
ButtonStroke.Thickness = 2
ButtonStroke.Parent = OpenButton

--==================================================
-- ГЛАВНОЕ ОКНО
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(390, 285)
Main.Position = UDim2.new(0.5, -195, 0.5, -142)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Main.Visible = false
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55, 55, 70)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--==================================================
-- ЗАГОЛОВОК
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.fromOffset(18, 0)
Title.BackgroundTransparency = 1
Title.Text = "AD  •  Панель"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38, 38)
Close.Position = UDim2.new(1, -48, 0, 8)
Close.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(220, 220, 220)
Close.TextSize = 25
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = Close

--==================================================
-- БОКОВОЕ МЕНЮ
--==================================================

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.fromOffset(105, 210)
Tabs.Position = UDim2.fromOffset(12, 60)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 7)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = Tabs

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -130, 1, -70)
Content.Position = UDim2.fromOffset(120, 60)
Content.BackgroundTransparency = 1
Content.Parent = Main

--==================================================
-- ФУНКЦИИ
--==================================================

local function MakeTab(text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(190, 190, 200)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = Tabs

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Button

    return Button
end

local function ClearContent()
    for _, v in ipairs(Content:GetChildren()) do
        v:Destroy()
    end
end

local function MakeLabel(text, y)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.Position = UDim2.fromOffset(0, y)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 235)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content

    return Label
end

local function MakeToggle(text, y, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 43)
    Button.Position = UDim2.fromOffset(0, y)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -65, 1, 0)
    Label.Position = UDim2.fromOffset(13, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.fromOffset(38, 21)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    Switch.Parent = Button

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(17, 17)
    Dot.Position = UDim2.fromOffset(2, 2)
    Dot.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
    Dot.Parent = Switch

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local Enabled = false

    Button.MouseButton1Click:Connect(function()
        Enabled = not Enabled

        if Enabled then
            TweenService:Create(
                Switch,
                TweenInfo.new(0.15),
                {BackgroundColor3 = Color3.fromRGB(120, 70, 255)}
            ):Play()

            TweenService:Create(
                Dot,
                TweenInfo.new(0.15),
                {Position = UDim2.fromOffset(19, 2)}
            ):Play()
        else
            TweenService:Create(
                Switch,
                TweenInfo.new(0.15),
                {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}
            ):Play()

            TweenService:Create(
                Dot,
                TweenInfo.new(0.15),
                {Position = UDim2.fromOffset(2, 2)}
            ):Play()
        end

        if callback then
            callback(Enabled)
        end
    end)

    return Button
end

--==================================================
-- ВКЛАДКА: ГЛАВНАЯ
--==================================================

local function HomePage()
    ClearContent()

    MakeLabel("Добро пожаловать", 0)
    MakeLabel("Выбери нужную функцию ниже.", 32)

    MakeToggle("Пример функции", 75, function(state)
        print("Пример функции:", state)
    end)

    MakeToggle("Уведомления", 125, function(state)
        print("Уведомления:", state)
    end)
end

--==================================================
-- ВКЛАДКА: ИГРОК
--==================================================

local function PlayerPage()
    ClearContent()

    MakeLabel("Настройки игрока", 0)

    MakeToggle("Быстрое перемещение", 45, function(state)
        print("Быстрое перемещение:", state)
    end)

    MakeToggle("Прыжок", 95, function(state)
        print("Прыжок:", state)
    end)

    MakeToggle("Авто-режим", 145, function(state)
        print("Авто-режим:", state)
    end)
end

--==================================================
-- ВКЛАДКА: НАСТРОЙКИ
--==================================================

local function SettingsPage()
    ClearContent()

    MakeLabel("Настройки", 0)

    MakeToggle("Анимации", 45, function(state)
        print("Анимации:", state)
    end)

    MakeToggle("Компактный режим", 95, function(state)
        print("Компактный режим:", state)
    end)
end

--==================================================
-- ВКЛАДКИ
--==================================================

local HomeTab = MakeTab("Главная")
local PlayerTab = MakeTab("Игрок")
local SettingsTab = MakeTab("Настройки")

local function SelectTab(selected)
    for _, v in ipairs(Tabs:GetChildren()) do
        if v:IsA("TextButton") then
            v.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
            v.TextColor3 = Color3.fromRGB(190, 190, 200)
        end
    end

    selected.BackgroundColor3 = Color3.fromRGB(55, 40, 90)
    selected.TextColor3 = Color3.fromRGB(255, 255, 255)
end

HomeTab.MouseButton1Click:Connect(function()
    SelectTab(HomeTab)
    HomePage()
end)

PlayerTab.MouseButton1Click:Connect(function()
    SelectTab(PlayerTab)
    PlayerPage()
end)

SettingsTab.MouseButton1Click:Connect(function()
    SelectTab(SettingsTab)
    SettingsPage()
end)

--==================================================
-- ОТКРЫТИЕ / ЗАКРЫТИЕ
--==================================================

local function ShowMenu()
    Main.Visible = true
    Main.Size = UDim2.fromOffset(350, 250)

    TweenService:Create(
        Main,
        TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(390, 285)}
    ):Play()
end

local function HideMenu()
    Main.Visible = false
end

OpenButton.MouseButton1Click:Connect(function()
    if Main.Visible then
        HideMenu()
    else
        ShowMenu()
    end
end)

Close.MouseButton1Click:Connect(HideMenu)

--==================================================
-- ПЕРЕТАСКИВАНИЕ ОКНА
--==================================================

local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- ПЕРЕТАСКИВАНИЕ КНОПКИ AD
--==================================================

local buttonDragging = false
local buttonStart
local buttonPos

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        buttonDragging = true
        buttonStart = input.Position
        buttonPos = OpenButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                buttonDragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if buttonDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - buttonStart

        OpenButton.Position = UDim2.new(
            buttonPos.X.Scale,
            buttonPos.X.Offset + delta.X,
            buttonPos.Y.Scale,
            buttonPos.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- ЗАПУСК
--==================================================

HomePage()
SelectTab(HomeTab)

print("AD GUI загружен")
