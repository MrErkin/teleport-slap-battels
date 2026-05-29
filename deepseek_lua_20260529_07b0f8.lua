-- Универсальный телепорт через портал Slap Battles v2
-- GitHub: MrErkin/teleport-slap-battels
local plr = game.Players.LocalPlayer

-- Функция создания GUI (вызывается при старте и после смерти)
local function createGUI()
    -- Удаляем старый GUI если есть
    if plr.PlayerGui:FindFirstChild("TeleportGUI") then
        plr.PlayerGui.TeleportGUI:Destroy()
    end

    local gui = Instance.new("ScreenGui", plr.PlayerGui)
    gui.Name = "TeleportGUI"
    local f = Instance.new("Frame", gui)
    f.Size = UDim2.new(0, 200, 0, 300)
    f.Position = UDim2.new(0.5, -100, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(25,25,25)
    f.Active = true
    f.Draggable = true

    local title = Instance.new("TextLabel", f)
    title.Size = UDim2.new(1,0,0,25)
    title.Text = "🌴 TELEPORT 🌴"
    title.BackgroundColor3 = Color3.fromRGB(35,35,35)
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 13

    -- Острова
    local islands = {
        {name = "🏝️ Default", path = "workspace.Arena.island1"},
        {name = "👋 Slap", path = "workspace.Arena.island2"},
        {name = "🇧🇷 Barzil", path = "workspace.Arena.island3"},
        {name = "🗿 Moai", path = "workspace.Arena.island4"},
        {name = "🚂 Train", path = "workspace.Arena.island5"},
        {name = "💀 Куб смерти", path = "workspace.Arena.island3"},
        {name = "🍏 Slapple Island", path = "workspace.Arena.island4.Grass"},
    }

    local y = 30
    for _, isl in pairs(islands) do
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(0.85,0,0,28)
        btn.Position = UDim2.new(0.075,0,0,y)
        btn.Text = isl.name
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 12
        btn.MouseButton1Click:Connect(function()
            teleportTo(isl.path)
        end)
        y += 32
    end

    -- Статус
    local status = Instance.new("TextLabel", f)
    status.Size = UDim2.new(1,0,0,15)
    status.Position = UDim2.new(0,0,0,y)
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(150,150,150)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.SourceSans
    status.TextSize = 10
    status.Name = "StatusLabel"

    f.Size = UDim2.new(0,200,0,y+20)
end

-- ===== ТЕЛЕПОРТ =====
function teleportTo(path)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local target = loadstring("return " .. path)()
    if not target then 
        updateStatus("Ошибка пути")
        return 
    end
    
    -- К порталу
    updateStatus("🌀 Иду к порталу...")
    local portal = workspace.Lobby:FindFirstChild("Teleport1")
    if portal then
        hrp.CFrame = portal.CFrame * CFrame.new(0,0,-8)
        task.wait(1)
        hrp.CFrame = portal.CFrame
        task.wait(3) -- Увеличенная задержка до 4 секунд в сумме
    end
    
    -- На остров
    updateStatus("🚀 Телепорт...")
    hrp.CFrame = target.CFrame * CFrame.new(0,15,0)
    task.wait(0.5)
    updateStatus("✅ Готово!")
    task.wait(1.5)
    updateStatus("")
end

function updateStatus(msg)
    local gui = plr.PlayerGui:FindFirstChild("TeleportGUI")
    if gui then
        local status = gui.Frame:FindFirstChild("StatusLabel")
        if status then
            status.Text = msg
        end
    end
end

-- ===== ЗАПУСК И ВОССТАНОВЛЕНИЕ ПОСЛЕ СМЕРТИ =====
createGUI()

plr.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    createGUI()
end)

print("🌴 Teleport v2 загружен!")
