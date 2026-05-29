-- Универсальный телепорт через портал
-- Сначала Teleport1, потом выбранная арена
local plr = game.Players.LocalPlayer

-- ===== GUI =====
local gui = Instance.new("ScreenGui", plr.PlayerGui)
local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 200, 0, 0)
f.Position = UDim2.new(0.5, -100, 0, 50)
f.BackgroundColor3 = Color3.fromRGB(25,25,25)
f.Active = true
f.Draggable = true

local title = Instance.new("TextLabel", f)
title.Size = UDim2.new(1,0,0,25)
title.Text = "ТЕЛЕПОРТ"
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 13

-- Список локаций
local locations = {
    {name = "Moai", path = workspace.Arena:FindFirstChild("island4")},
    {name = "Default", path = workspace.Arena:FindFirstChild("island1")},
    {name = "Slap", path = workspace.Arena:FindFirstChild("island2")},
    {name = "Barzil", path = workspace.Arena:FindFirstChild("island3")},
}

local yOffset = 30
local btnCount = 0

for _, loc in pairs(locations) do
    if loc.path then
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(0.8, 0, 0, 28)
        btn.Position = UDim2.new(0.1, 0, 0, yOffset)
        btn.Text = loc.name
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 12
        
        btn.MouseButton1Click:Connect(function()
            teleportTo(loc.path)
        end)
        
        yOffset += 32
        btnCount += 1
    end
end

-- Добавляем поле для своего пути
local customLabel = Instance.new("TextLabel", f)
customLabel.Size = UDim2.new(1,0,0,18)
customLabel.Position = UDim2.new(0,0,0,yOffset)
customLabel.Text = "Свой путь:"
customLabel.TextColor3 = Color3.fromRGB(180,180,180)
customLabel.BackgroundTransparency = 1
customLabel.Font = Enum.Font.SourceSans
customLabel.TextSize = 11
yOffset += 20

local customBox = Instance.new("TextBox", f)
customBox.Size = UDim2.new(0.8,0,0,25)
customBox.Position = UDim2.new(0.1,0,0,yOffset)
customBox.PlaceholderText = "Workspace.Arena.island4"
customBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
customBox.TextColor3 = Color3.fromRGB(255,255,255)
customBox.Font = Enum.Font.SourceSans
customBox.TextSize = 11
yOffset += 30

local customBtn = Instance.new("TextButton", f)
customBtn.Size = UDim2.new(0.8,0,0,28)
customBtn.Position = UDim2.new(0.1,0,0,yOffset)
customBtn.Text = "ТП по пути"
customBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
customBtn.TextColor3 = Color3.fromRGB(255,255,255)
customBtn.Font = Enum.Font.SourceSans
customBtn.TextSize = 12
customBtn.MouseButton1Click:Connect(function()
    local path = customBox.Text
    local success, obj = pcall(function()
        return loadstring("return " .. path)()
    end)
    if success and obj then
        teleportTo(obj)
    else
        print("Неверный путь")
    end
end)
yOffset += 32

-- Статус
local statusLabel = Instance.new("TextLabel", f)
statusLabel.Size = UDim2.new(1,0,0,15)
statusLabel.Position = UDim2.new(0,0,0,yOffset)
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(150,150,150)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 10
yOffset += 18

-- Обновляем размер фрейма
f.Size = UDim2.new(0, 200, 0, yOffset + 5)

-- ===== ФУНКЦИЯ ТЕЛЕПОРТА =====
function teleportTo(target)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Шаг 1: Телепорт к порталу
    statusLabel.Text = "Иду к порталу..."
    local portal = workspace.Lobby:FindFirstChild("Teleport1")
    if portal then
        hrp.CFrame = portal.CFrame * CFrame.new(0, 0, -5)
        task.wait(0.8)
        hrp.CFrame = portal.CFrame * CFrame.new(0, 0, 0)
        task.wait(1.2)
    end
    
    -- Шаг 2: Телепорт на выбранное место
    statusLabel.Text = "Телепорт..."
    hrp.CFrame = target.CFrame * CFrame.new(0, 5, 0)
    task.wait(0.3)
    statusLabel.Text = "Готово!"
    task.wait(1.5)
    statusLabel.Text = ""
end

print("Телепорт загружен. Выбери локацию в GUI.")