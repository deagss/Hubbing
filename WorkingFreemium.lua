local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextBoxService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local selectedSkillNoCD = nil
local isSkillNoCDActive = false
local isAutoWinActive = true
local playerName = player.Name
local HttpService = game:GetService("HttpService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local skillData = {
    {name = "Earthshaker", id = "132004", image = "rbxassetid://135296483678943"},
    {name = "Duel Flame Slash", id = "133031", image = "rbxassetid://138370561873282"},
    {name = "Shadow Spider", id = "133030", image = "rbxassetid://136869074528315"},
    {name = "Deadly hook", id = "132003", image = "rbxassetid://91143148401167"},
    {name = "Mad shoot", id = "132002", image = "rbxassetid://106907024318493"},
    {name = "Heal potion", id = "133911", image = "rbxassetid://100993928459228"},
    {name = "Energy Orb", id = "133910", image = "rbxassetid://130627266191854"},
    {name = "Mine Field", id = "133909", image = "rbxassetid://18871947236"},
    {name = "Hammer", id = "133908", image = "rbxassetid://18731235558"},
    {name = "Invincible", id = "133907", image = "rbxassetid://104700109179140"},
    {name = "Outburst", id = "133906", image = "rbxassetid://132447249728475"},
    {name = "Speed up", id = "133905", image = "rbxassetid://119002398060133"},
    {name = "Spring Jump", id = "133904", image = "rbxassetid://82395827755868"},
    {name = "Refresh", id = "133903", image = "rbxassetid://130879784141082"},
    {name = "Cupids Arrow", id = "133902", image = "rbxassetid://90984061655311"},
    {name = "Fireball Staff", id = "133901", image = "rbxassetid://131121342299291"},
    {name = "Firework Gattling", id = "133029", image = "rbxassetid://99329824210258"},
    {name = "Firework Cannon", id = "133028", image = "rbxassetid://118842050488910"},
    {name = "Piercing barrage", id = "133027", image = "rbxassetid://78525760914548"},
    {name = "Whirling flash", id = "133026", image = "rbxassetid://102383823820621"},
    {name = "Lava Bomb", id = "133025", image = "rbxassetid://130740721413102"},
    {name = "Time Bomb", id = "133024", image = "rbxassetid://96554631799998"},
    {name = "Whirlwind", id = "133023", image = "rbxassetid://98522558161210"},
    {name = "Deadly Domain", id = "133022", image = "rbxassetid://109652616898553"},
    {name = "Red ball lightning", id = "133021", image = "rbxassetid://85107553002232"},
    {name = "Caria", id = "133020", image = "rbxassetid://75821663782402"},
    {name = "Poison", id = "133019", image = "rbxassetid://101926105230426"},
    {name = "Tracking bomb", id = "133018", image = "rbxassetid://100029360209161"},
    {name = "Thunder staff", id = "133017", image = "rbxassetid://133380239985949"},
    {name = "Holy bomb", id = "133016", image = "rbxassetid://124039121977636"},
    {name = "Skibidi", id = "133015", image = "rbxassetid://105342406539284"},
    {name = "Snowball", id = "133014", image = "rbxassetid://76302987638535"},
    {name = "Toilet Javelin", id = "133013", image = "rbxassetid://18731235342"},
    {name = "Fart", id = "133012", image = "rbxassetid://100508117101948"},
    {name = "Block bomb", id = "133011", image = "rbxassetid://137929423116091"},
    {name = "Bind Arrow", id = "133010", image = "rbxassetid://91644211005361"},
    {name = "Burning Metor", id = "133009", image = "rbxassetid://108934572930738"},
    {name = "Undead orb", id = "133008", image = "rbxassetid://140226193237053"},
    {name = "Boom arrow", id = "133007", image = "rbxassetid://96402506344024"},
    {name = "Eagle Slingshot", id = "133006", image = "rbxassetid://121816962798040"},
    {name = "Ice Sword", id = "133005", image = "rbxassetid://132165228404877"},
    {name = "War Boomerang", id = "133004", image = "rbxassetid://112682039616894"},
    {name = "Tengu Flintlock", id = "133003", image = "rbxassetid://118970675365031"},
    {name = "Joker cards", id = "133002", image = "rbxassetid://83835139223489"},
    {name = "Spiked Ball", id = "133001", image = "rbxassetid://123228451602564"},
    {name = "Refresh slash", id = "132905", image = "rbxassetid://129561354802345"},
    {name = "Phantom Spin", id = "132904", image = "rbxassetid://89191677113257"},
    {name = "Daibutsu", id = "132903", image = "rbxassetid://18871947760"},
    {name = "Energy Cannon", id = "132902", image = "rbxassetid://74223636063998"},
    {name = "Undying Flame", id = "132901", image = "rbxassetid://136653759794314"},
    {name = "Demons Grasp", id = "132008", image = "rbxassetid://78301993875790"},
    {name = "Golden Cudgel", id = "132007", image = "rbxassetid://129362230081631"},
    {name = "Watermelon", id = "132006", image = "rbxassetid://122558835270584"},
    {name = "Dash Blast", id = "132005", image = "rbxassetid://90612232721409"},
    {name = "Eye Of God", id = "132001", image = "rbxassetid://105125083917276"}
}

local selectedSkills = {}

if isMobile then
    game:GetService("Players").LocalPlayer.PlayerGui.Lobby.Enabled = true
    game:GetService("Players").LocalPlayer.PlayerGui.Lobby.UI_Skill.Visible = true
    game:GetService("Players").LocalPlayer.PlayerGui.MobileScr.ControlFrame.USE.Visible = false
    game:GetService("Players").LocalPlayer.PlayerGui.MobileScr.ControlFrame.USE2.Visible = false
    
    game:GetService("Players").LocalPlayer.PlayerGui.Lobby.UI_Skill.List.Skill3.Size = UDim2.new(1.5, 0, 1.5, 0)
    game:GetService("Players").LocalPlayer.PlayerGui.Lobby.UI_Skill.List.Skill2.Size = UDim2.new(1.5, 0, 1.5, 0)
    
end

game:GetService("Players").LocalPlayer.PlayerGui.Lobby.Enabled = true
game:GetService("Players").LocalPlayer.PlayerGui.Lobby.UI_Skill.Visible = true

local function findPlayerInGroup(groupName)
    local group = workspace:FindFirstChild("Scene") and workspace.Scene:FindFirstChild("Function") and workspace.Scene.Function:FindFirstChild("DuelEnter")
    if group then
        local duelGroup = group:FindFirstChild(groupName)
        if duelGroup then
            local transPos1 = duelGroup:FindFirstChild("TransPos1")
            local transPos2 = duelGroup:FindFirstChild("TransPos2")
            
            -- Функция для поиска игрока по Name или DisplayName
            local function findPlayerName(surfaceGui)
                if surfaceGui and surfaceGui:FindFirstChild("Users") then
                    for _, child in ipairs(surfaceGui.Users:GetChildren()) do
                        if child:IsA("TextLabel") then
                            if child.Text == playerName or child.Text == player.DisplayName then
                                return true
                            end
                        end
                    end
                end
                return false
            end
            
            -- Проверяем TransPos1
            if transPos1 and transPos1:FindFirstChild("SurfaceGui") then
                if findPlayerName(transPos1.SurfaceGui) then
                    print("Найден игрок " .. playerName .. " в группе " .. groupName .. " на позиции TransPos1.")
                    return transPos1, transPos2
                end
            end
            
            -- Проверяем TransPos2
            if transPos2 and transPos2:FindFirstChild("SurfaceGui") then
                if findPlayerName(transPos2.SurfaceGui) then
                    print("Найден игрок " .. playerName .. " в группе " .. groupName .. " на позиции TransPos2.")
                    return transPos2, transPos1
                end
            end
        end
    end
    return nil, nil
end

-- Функция для телепортации за спину врага
local function teleportBehindEnemy(enemyPlayer)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        print("Ошибка: У вашего персонажа нет HumanoidRootPart.")
        return
    end
    
    if not enemyPlayer.Character or not enemyPlayer.Character:FindFirstChild("HumanoidRootPart") then
        print("Ошибка: У противника " .. enemyPlayer.Name .. " нет персонажа или HumanoidRootPart.")
        return
    end
    
    local enemyRootPart = enemyPlayer.Character.HumanoidRootPart
    local offset = CFrame.new(0, 0, 5) -- Смещение за спину противника (4 studs)
    local newPosition = (enemyRootPart.CFrame * offset).Position
    
    player.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition, newPosition + enemyRootPart.CFrame.LookVector)
    print("Телепортировался за спину противника!")
end

-- Функция для полета за спину противника с обновлением позиции
local function flyBehindEnemy(enemyPlayer)
    while isAutoWinActive do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            break
        end
        
        if not enemyPlayer.Character or not enemyPlayer.Character:FindFirstChild("HumanoidRootPart") then
            print("Ошибка: У противника " .. enemyPlayer.Name .. " нет персонажа или HumanoidRootPart.")
            break
        end
        
        local enemyRootPart = enemyPlayer.Character.HumanoidRootPart
        local offset = CFrame.new(0, 0, 5) -- Смещение за спину противника (5 studs)
        local newPosition = (enemyRootPart.CFrame * offset).Position
        
        player.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition, newPosition + enemyRootPart.CFrame.LookVector)
        
        task.wait(0.001) -- Ждем 0.1 секунды перед следующим обновлением
    end
end

-- Функция для поиска имени врага
local function findEnemyName(surfaceGui)
    if surfaceGui and surfaceGui:FindFirstChild("Users") then
        for _, child in ipairs(surfaceGui.Users:GetChildren()) do
            if child:IsA("TextLabel") then
                local enemyPlayer = nil
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Name == child.Text or player.DisplayName == child.Text then
                        enemyPlayer = player
                        break
                    end
                end
                if enemyPlayer and enemyPlayer.Name ~= playerName then
                    return enemyPlayer.Name
                end
            end
        end
    end
    return nil
end

-- Основная функция Auto Win
local function autoWinFunction()
    while isAutoWinActive do
        local groups = {"1V1Group1", "1V1Group2", "1V1Group3", "1V1Group4", "1V1Group5", "1V1Group6", "2V2Group1"}
        
        for _, groupName in ipairs(groups) do
            if not isAutoWinActive then
                break
            end

            local myPosition, enemyPosition = findPlayerInGroup(groupName)
            if myPosition and enemyPosition then
                local enemyName1 = nil
                local enemyName2 = nil
                
                -- Если ваш Name найден в TransPos1, ищем противников в TransPos2
                if myPosition:FindFirstChild("SurfaceGui") then
                    enemyName1 = findEnemyName(enemyPosition.SurfaceGui)
                -- Если ваш Name найден в TransPos2, ищем противников в TransPos1
                elseif enemyPosition:FindFirstChild("SurfaceGui") then
                    enemyName1 = findEnemyName(myPosition.SurfaceGui)
                end

                -- Если группа 2V2, ищем второго врага
                if groupName == "2V2Group1" then
                    if myPosition:FindFirstChild("SurfaceGui") then
                        enemyName2 = findEnemyName(enemyPosition.SurfaceGui)
                    elseif enemyPosition:FindFirstChild("SurfaceGui") then
                        enemyName2 = findEnemyName(myPosition.SurfaceGui)
                    end
                end

                -- Обрабатываем первого врага
                if enemyName1 and enemyName1 ~= playerName then
                    local enemyPlayer1 = Players:FindFirstChild(enemyName1)
                    if enemyPlayer1 then
                        print("Найден противник 1: " .. enemyPlayer1.Name)
                        
                        -- Телепортируемся за спину первого врага
                        teleportBehindEnemy(enemyPlayer1)
                        
                        -- Начинаем обновлять позицию каждые 0.1 секунды
                        flyBehindEnemy(enemyPlayer1)
                        
                        -- Если первый враг умер, переключаемся на второго
                        if not enemyPlayer1.Character or not enemyPlayer1.Character:FindFirstChild("Humanoid") or enemyPlayer1.Character.Humanoid.Health <= 0 then
                            if enemyName2 and enemyName2 ~= playerName then
                                local enemyPlayer2 = Players:FindFirstChild(enemyName2)
                                if enemyPlayer2 then
                                    print("Первый враг умер. Переключаемся на второго врага: " .. enemyPlayer2.Name)
                                    
                                    -- Телепортируемся за спину второго врага
                                    teleportBehindEnemy(enemyPlayer2)
                                    
                                    -- Начинаем обновлять позицию каждые 0.1 секунды
                                    flyBehindEnemy(enemyPlayer2)
                                end
                            end
                        end
                    end
                end
            end
        end
        
        task.wait(0.001) -- Задержка для предотвращения лагов
    end
end
-- Replace the setupAntiLava function with this simpler version:
local function setupAntiLava()
    local lavaLand = workspace.Map.MatchDuel.LavaLand
    if not lavaLand then return end

    -- Remove existing platform
    local existingPlatform = workspace:FindFirstChild("InvisiblePlatform")
    if existingPlatform then
        existingPlatform:Destroy()
    end

    -- Create new platform
    local platform = Instance.new("Part")
    platform.Name = "InvisiblePlatform"
    platform.Size = lavaLand.Size
    platform.Position = lavaLand.Position + Vector3.new(0, 6, 0)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = true
    platform.Locked = true
    platform.Parent = workspace

    -- Set final position
    platform.Position = Vector3.new(
        lavaLand.Position.X,
        lavaLand.Position.Y + 2,
        lavaLand.Position.Z
    )

    return platform
end

-- Settings
local settings = {
    isSkillFunctionActive = false,
    isAutoSkillActive = false,
    areVIPSettingsActive = false,
    deviceStateIndex = 0,
    isWindowOpen = true,
    windowPosition = UDim2.new(0.05, 0, 0.2, 0),
    isAutoAttackEnabled = false,
    showAttackRange = false,
    attackRange = 10,
    isAntiLavaEnabled = false,
    isAutoWinActive = false,
    flySpeed = 150,
    otherPlayersFlySpeed = 150
}

local lastGuiState = {
    isSkillFunctionActive = false,
    isAutoSkillActive = false,
    areVIPSettingsActive = false,
    deviceStateIndex = 0,
    isAutoAttackEnabled = false,
    showAttackRange = false,
    selectedSkills = {},
    isGuiOpen = true,
    isAntiLavaEnabled = false
}

-- UI Theme
local theme = {
    background = Color3.fromRGB(25, 25, 25),
    foreground = Color3.fromRGB(35, 35, 35),
    accent = Color3.fromRGB(45, 45, 45),
    selected = Color3.fromRGB(55, 55, 55),
    text = Color3.fromRGB(255, 255, 255),
    checkbox = Color3.fromRGB(0, 255, 128),
    checkboxBorder = Color3.fromRGB(60, 60, 60)
}

local function updateGuiState()
    lastGuiState.isSkillFunctionActive = settings.isSkillFunctionActive
    lastGuiState.isAutoSkillActive = settings.isAutoSkillActive
    lastGuiState.areVIPSettingsActive = settings.areVIPSettingsActive
    lastGuiState.deviceStateIndex = settings.deviceStateIndex
    lastGuiState.isAutoAttackEnabled = settings.isAutoAttackEnabled
    lastGuiState.showAttackRange = settings.showAttackRange
    lastGuiState.selectedSkills = table.clone(selectedSkills)
    lastGuiState.isGuiOpen = settings.isWindowOpen
    lastGuiState.isAntiLavaEnabled = settings.isAntiLavaEnabled
    lastGuiState.isAutoWinActive = settings.isAutoWinActive
    lastGuiState.selectedSkillNoCD = selectedSkillNoCD
    lastGuiState.isSkillNoCDActive = isSkillNoCDActive
end

local function applyGuiState(gui)
    if not gui or not gui:FindFirstChild("MainFrame") then return end
    
    local mainFrame = gui.MainFrame
    local function updateButton(name, value, onText, offText)
        local button = mainFrame:FindFirstChild(name, true)
        if button then
            button.Text = value and (onText or "ON") or (offText or "OFF")
        end
    end
    -- Обновляем остальные кнопки
    updateButton("SkillToggle", lastGuiState.isSkillFunctionActive, "Skills: ON", "Skills: OFF")
    updateButton("AutoSkill", lastGuiState.isAutoSkillActive, "Auto Skill: ON", "Auto Skill: OFF")
    updateButton("VIPSettings", lastGuiState.areVIPSettingsActive, "VIP: ON", "VIP: OFF")
    updateButton("AutoAttack", lastGuiState.isAutoAttackEnabled, "Auto Attack: ON", "Auto Attack: OFF")
    updateButton("RangeToggle", lastGuiState.showAttackRange, "Range: ON", "Range: OFF")
    updateButton("AntiLava", lastGuiState.isAntiLavaEnabled, "Anti-Lava: ON", "Anti-Lava: OFF")
    updateButton("AutoWin", lastGuiState.isAutoWinActive, "Auto Win: ON", "Auto Win: OFF")
    
    -- Обновляем состояние устройства
    local deviceButton = mainFrame:FindFirstChild("Device", true)
    if deviceButton then
        deviceButton.Text = "Device: " .. tostring(lastGuiState.deviceStateIndex)
    end
    
    -- Восстанавливаем видимость
    mainFrame.Visible = lastGuiState.isGuiOpen
    local minimizedIcon = gui:FindFirstChild("MinimizedIcon")
    if minimizedIcon then
        minimizedIcon.Visible = not lastGuiState.isGuiOpen
    end
end

settings.isSkillFunctionActive = lastGuiState.isSkillFunctionActive
settings.isAutoSkillActive = lastGuiState.isAutoSkillActive
settings.areVIPSettingsActive = lastGuiState.areVIPSettingsActive
settings.deviceStateIndex = lastGuiState.deviceStateIndex
settings.isAutoAttackEnabled = lastGuiState.isAutoAttackEnabled
settings.showAttackRange = lastGuiState.showAttackRange
settings.isAntiLavaEnabled = lastGuiState.isAntiLavaEnabled

-- Add this after the theme table and before createModernButton
local function playEnhancedAnimations(mainFrame, loadingFrame, loadingLogo, spinner, contentFrame, skipAnimation)
    if skipAnimation then
        -- Skip animation and just show content
        if loadingFrame then loadingFrame:Destroy() end
        contentFrame.Visible = true
        mainFrame.Position = settings.windowPosition
        mainFrame.BackgroundTransparency = 0.1
        mainFrame.Visible = settings.isWindowOpen
        return
    end

    -- Hide main content initially
    contentFrame.Visible = false
    mainFrame.Visible = settings.isWindowOpen
    
    -- Initial states
    mainFrame.Position = UDim2.new(settings.windowPosition.X.Scale, settings.windowPosition.X.Offset, -1, 0)
    mainFrame.BackgroundTransparency = 1
    loadingFrame.BackgroundTransparency = 1
    loadingLogo.TextTransparency = 1
    spinner.ImageTransparency = 1
    
    -- Drop animation
    local dropTween = TweenService:Create(mainFrame, TweenInfo.new(
        1.5,
        Enum.EasingStyle.Bounce,
        Enum.EasingDirection.Out
    ), {
        Position = settings.windowPosition
    })
    
    -- Background fade
    local backgroundFade = TweenService:Create(mainFrame, TweenInfo.new(
        1,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0.1
    })
    
    -- Loading screen elements fade in
    local loadingFade = TweenService:Create(loadingFrame, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0
    })
    
    local logoFade = TweenService:Create(loadingLogo, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    local spinnerFade = TweenService:Create(spinner, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        ImageTransparency = 0
    })
    
    -- Play animations in sequence
    dropTween:Play()
    backgroundFade:Play()
    loadingFade:Play()
    logoFade:Play()
    spinnerFade:Play()
    
    -- Show content after delay
    task.delay(2, function()
        contentFrame.Visible = true
        
        -- Fade out loading screen
        TweenService:Create(loadingFrame, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(spinner, TweenInfo.new(0.5), {
            ImageTransparency = 1
        }):Play()
        
        TweenService:Create(loadingLogo, TweenInfo.new(0.5), {
            TextTransparency = 1
        }):Play()
        
        -- Destroy loading frame after fade out
        task.delay(0.5, function()
            loadingFrame:Destroy()
        end)
    end)
    
    return dropTween
end

-- UI Creation Helper Functions
local function createModernButton(name, text, size, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = isMobile and size + UDim2.new(0, 0, 0, 20) or size -- Увеличиваем размер на телефоне
    button.Position = position
    button.BackgroundColor3 = theme.accent
    button.BackgroundTransparency = 0.1
    button.Text = text
    button.TextColor3 = theme.text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = isMobile and 18 or 14 -- Увеличиваем размер текста на телефоне
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    end)
    
    return button
end

-- Функция для создания чекбокса
local function createCheckbox()
    local checkbox = Instance.new("Frame")
    checkbox.Size = UDim2.new(0, 20, 0, 20)
    checkbox.BackgroundColor3 = theme.checkboxBorder
    checkbox.BackgroundTransparency = 0.1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = checkbox
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.8, 0, 0.8, 0)
    fill.Position = UDim2.new(0.1, 0, 0.1, 0)
    fill.BackgroundColor3 = theme.checkbox
    fill.BackgroundTransparency = 1
    fill.Parent = checkbox
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    return checkbox, fill
end

-- Функция для создания элементов списка навыков
local function createSkillEntry(skillInfo, parent)
    local entry = Instance.new("Frame")
    entry.Name = skillInfo.name
    entry.Size = isMobile and UDim2.new(0.95, 0, 0, 70) or UDim2.new(0.95, 0, 0, 50)
    entry.BackgroundColor3 = theme.foreground
    entry.BackgroundTransparency = 0.5
    entry.Parent = parent
    
    local checkbox, fill = createCheckbox()
    checkbox.Position = UDim2.new(0.02, 0, 0.5, -10)
    checkbox.Parent = entry

    -- Обработка нажатия на чекбокс
    checkbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local isSelected = fill.BackgroundTransparency == 1
            TweenService:Create(fill, TweenInfo.new(0.3), {
                BackgroundTransparency = isSelected and 0 or 1
            }):Play()
            
            if isSelected then
                table.insert(selectedSkills, skillInfo.id)
            else
                for i, id in ipairs(selectedSkills) do
                    if id == skillInfo.id then
                        table.remove(selectedSkills, i)
                        break
                    end
                end
            end
        end
    end)

    local icon = Instance.new("ImageLabel")
    icon.Size = isMobile and UDim2.new(0, 50, 0, 50) or UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0.12, 0, 0.5, -25)
    icon.BackgroundTransparency = 1
    icon.Image = skillInfo.image
    icon.Parent = entry

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
    nameLabel.Position = UDim2.new(0.25, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = skillInfo.name
    nameLabel.TextColor3 = theme.text
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = isMobile and 16 or 14
    nameLabel.Parent = entry

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = entry

    return entry
end

-- Smooth resize functionality
local function enableResizing(mainFrame)
    local resizeButton = Instance.new("TextButton")
    resizeButton.Size = UDim2.new(0, 15, 0, 15)
    resizeButton.Position = UDim2.new(1, -15, 1, -15)
    resizeButton.Text = ""
    resizeButton.BackgroundColor3 = theme.accent
    resizeButton.Parent = mainFrame
    
    local resizeButtonCorner = Instance.new("UICorner")
    resizeButtonCorner.CornerRadius = UDim.new(0, 4)
    resizeButtonCorner.Parent = resizeButton
    
    local isResizing = false
    local startPos = nil
    local startSize = nil
    local sensitivity = 0.3

    resizeButton.MouseButton1Down:Connect(function()
        isResizing = true
        startPos = UserInputService:GetMouseLocation()
        startSize = mainFrame.Size
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isResizing then
            local delta = (UserInputService:GetMouseLocation() - startPos) * sensitivity
            local newSize = UDim2.new(
                startSize.X.Scale + (delta.X / workspace.CurrentCamera.ViewportSize.X),
                0,
                startSize.Y.Scale + (delta.Y / workspace.CurrentCamera.ViewportSize.Y),
                0
            )
            
            newSize = UDim2.new(
                math.clamp(newSize.X.Scale, 0.2, 0.4),
                0,
                math.clamp(newSize.Y.Scale, 0.3, 0.6),
                0
            )
            
            mainFrame.Size = newSize
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = false
        end
    end)
end

local function enableDragging(frame, dragButton)
    local dragToggle = false
    local dragStart = nil
    local startPos = nil

    dragButton.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not dragToggle then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    dragButton.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and dragToggle then
            dragToggle = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragToggle then
                local delta = input.Position - dragStart
                local newPosition = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
                frame.Position = newPosition
            end
        end
    end)
end

-- Auto attack functionality
local function setupAutoAttack()
    -- Clean up existing range indicator if it exists
    if workspace:FindFirstChild("AttackRange") then
        workspace.AttackRange:Destroy()
    end
    
    local range = Instance.new("Part")
    range.Name = "AttackRange"
    range.Shape = Enum.PartType.Cylinder
    range.Size = Vector3.new(0.5, settings.attackRange * 2, settings.attackRange * 2)
    range.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
    range.Transparency = 1
    range.BrickColor = BrickColor.new("Really red")
    range.Anchored = true
    range.CanCollide = false
    range.Parent = workspace
    
    local lastAttackTime = 0
    local attackCooldown = 0.1 -- Adjust this value to control attack speed
    
    local rangeUpdateConnection = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Update range position
            range.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0) * CFrame.Angles(0, 0, math.rad(90))
            range.Transparency = settings.showAttackRange and 0.8 or 1
            
            -- Auto attack logic
            if settings.isAutoAttackEnabled and tick() - lastAttackTime >= attackCooldown then
                local myPosition = character.HumanoidRootPart.Position
                local closestPlayer = nil
                local closestDistance = settings.attackRange
                
                -- Find closest player in range
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character then
                        local otherCharacter = otherPlayer.Character
                        if otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart") 
                            and otherCharacter:FindFirstChild("Humanoid") 
                            and otherCharacter.Humanoid.Health > 0 then
                            
                            local distance = (myPosition - otherCharacter.HumanoidRootPart.Position).Magnitude
                            if distance <= closestDistance then
                                closestPlayer = otherCharacter
                                closestDistance = distance
                            end
                        end
                    end
                end
                
                -- If found player in range, face them and attack
                if closestPlayer then
                    -- Face the player
                    local lookAt = CFrame.lookAt(
                        character.HumanoidRootPart.Position,
                        closestPlayer.HumanoidRootPart.Position
                    )
                    character.HumanoidRootPart.CFrame = CFrame.new(
                        character.HumanoidRootPart.Position,
                        Vector3.new(lookAt.LookVector.X, 0, lookAt.LookVector.Z) + character.HumanoidRootPart.Position
                    )
                    
                    -- Attack
                    workspace.Player[player.Name].Communicate:FireServer({
                        Key = Enum.UserInputType.MouseButton1,
                        State = Enum.UserInputState.Begin
                    })
                    
                    lastAttackTime = tick()
                end
            end
        end
    end)
    
    -- Cleanup function
    local function cleanup()
        if range then range:Destroy() end
        if rangeUpdateConnection then rangeUpdateConnection:Disconnect() end
    end
    
    return range, rangeUpdateConnection, cleanup
end

-- RGB Color cycling for PASHUB logo
local function updateTitleColor(titleLabel)
    local t = tick() % 5
    local hue = t / 5
    local color = Color3.fromHSV(hue, 0.7, 1)
    titleLabel.TextColor3 = color
end

local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernStyleGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = isMobile and UDim2.new(0.4, 0, 0.6, 0) or UDim2.new(0.25, 0, 0.4, 0)
    mainFrame.Position = settings.windowPosition
    mainFrame.BackgroundColor3 = theme.background
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.Visible = true

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = mainFrame

    -- Add after mainFrame creation and before contentFrame:
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = theme.background
    loadingFrame.BackgroundTransparency = 1
    loadingFrame.Parent = mainFrame
    loadingFrame.ZIndex = 10

    local loadingLogo = Instance.new("TextLabel")
    loadingLogo.Size = UDim2.new(0, 200, 0, 40)
    loadingLogo.Position = UDim2.new(0.5, -100, 0.3, -20)
    loadingLogo.BackgroundTransparency = 1
    loadingLogo.Text = "PASHUB"
    loadingLogo.TextColor3 = theme.text
    loadingLogo.TextTransparency = 1
    loadingLogo.TextSize = 32
    loadingLogo.Font = Enum.Font.GothamBold
    loadingLogo.Parent = loadingFrame
    loadingLogo.ZIndex = 11

    local spinner = Instance.new("ImageLabel")
    spinner.Size = UDim2.new(0, 80, 0, 80)
    spinner.Position = UDim2.new(0.5, -40, 0.5, -40)
    spinner.BackgroundTransparency = 1
    spinner.Image = "rbxassetid://4518874754"
    spinner.ImageTransparency = 1
    spinner.Parent = loadingFrame
    spinner.ZIndex = 11

    -- Create content container
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.Position = UDim2.new(0, 0, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    contentFrame.Visible = true

    playEnhancedAnimations(mainFrame, loadingFrame, loadingLogo, spinner, contentFrame)

    -- Title bar
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
    titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "PASHUB"
    titleLabel.TextColor3 = theme.text
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = contentFrame

    -- Create Tabs
    local skillsCategoryButton = createModernButton("SkillsCategory", "Skills", 
        UDim2.new(0.45, 0, 0.08, 0), UDim2.new(0.025, 0, 0.12, 0), contentFrame)

    local miscCategoryButton = createModernButton("MiscCategory", "Misc", 
        UDim2.new(0.45, 0, 0.08, 0), UDim2.new(0.525, 0, 0.12, 0), contentFrame)

    -- Content frames
    local skillsFrame = Instance.new("Frame")
    local miscFrame = Instance.new("Frame")

    skillsFrame.Size = UDim2.new(0.95, 0, 0.75, 0)
    skillsFrame.Position = UDim2.new(0.025, 0, 0.22, 0)
    skillsFrame.BackgroundColor3 = theme.foreground
    skillsFrame.BackgroundTransparency = 0.8
    skillsFrame.Parent = contentFrame
    skillsFrame.Visible = true

    miscFrame.Size = UDim2.new(0.95, 0, 0.75, 0)
    miscFrame.Position = UDim2.new(0.025, 0, 0.22, 0)
    miscFrame.BackgroundColor3 = theme.foreground
    miscFrame.BackgroundTransparency = 0.8
    miscFrame.Parent = contentFrame
    miscFrame.Visible = false

    -- Skills Content
    local skillToggleButton = createModernButton("SkillToggle", 
        settings.isSkillFunctionActive and "Skills: ON" or "Skills: OFF",
        UDim2.new(0.9, 0, 0.15, 0), UDim2.new(0.05, 0, 0.05, 0), skillsFrame)

    local autoSkillButton = createModernButton("AutoSkill",
        settings.isAutoSkillActive and "Auto Skill: ON" or "Auto Skill: OFF",
        UDim2.new(0.9, 0, 0.15, 0), UDim2.new(0.05, 0, 0.25, 0), skillsFrame)

    -- Skill list
    local skillsList = Instance.new("ScrollingFrame")
    skillsList.Size = UDim2.new(0.9, 0, 0.35, 0)
    skillsList.Position = UDim2.new(0.05, 0, 0.58, 0)
    skillsList.BackgroundTransparency = 1
    skillsList.ScrollBarThickness = 4
    skillsList.Parent = skillsFrame
    skillsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    skillsList.ScrollingDirection = Enum.ScrollingDirection.Y
    skillsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    skillsList.ScrollBarImageColor3 = theme.accent

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = skillsList
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Search bar
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(0.9, 0, 0.08, 0)
    searchBox.Position = UDim2.new(0.05, 0, 0.48, 0)
    searchBox.BackgroundColor3 = theme.accent
    searchBox.BackgroundTransparency = 0.1
    searchBox.TextColor3 = theme.text
    searchBox.PlaceholderText = "Search abilities..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    searchBox.Text = ""
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 14
    searchBox.Parent = skillsFrame
    searchBox.ClipsDescendants = true

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 4)
    searchCorner.Parent = searchBox

    -- Create skill entries
    local skillEntries = {}
    for _, skillInfo in ipairs(skillData) do
        local entry = createSkillEntry(skillInfo, skillsList)
        table.insert(skillEntries, {
            entry = entry,
            name = skillInfo.name:lower()
        })
    end

    -- Misc Content
    local miscScrollFrame = Instance.new("ScrollingFrame")
    miscScrollFrame.Size = UDim2.new(0.95, 0, 0.85, 0)  -- Make it take most of the misc frame
    miscScrollFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
    miscScrollFrame.BackgroundTransparency = 1
    miscScrollFrame.ScrollBarThickness = 4
    miscScrollFrame.ScrollBarImageColor3 = theme.accent
    miscScrollFrame.Parent = miscFrame
    miscScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    miscScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    miscScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- Add UIListLayout for automatic button positioning
    local miscListLayout = Instance.new("UIListLayout")
    miscListLayout.Parent = miscScrollFrame
    miscListLayout.Padding = UDim.new(0, 10)  -- Space between buttons
    miscListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    miscListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

    if isMobile then
        miscScrollFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                local startPos = input.Position
                local startScrollPosition = miscScrollFrame.CanvasPosition

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.Change then
                        local delta = input.Position - startPos
                        miscScrollFrame.CanvasPosition = Vector2.new(
                            startScrollPosition.X,
                            startScrollPosition.Y - delta.Y
                        )
                    end
                end)
            end
        end)
    end

    local vipSettingsButton = createModernButton("VIPSettings",
        settings.areVIPSettingsActive and "VIP: ON" or "VIP: OFF",
        UDim2.new(0.9, 0, 0, 40),  -- Fixed height for buttons
        UDim2.new(0, 0, 0, 0),  -- Position will be handled by UIListLayout
        miscScrollFrame)

    local deviceButton = createModernButton("Device",
        "Device: " .. tostring(settings.deviceStateIndex),
        UDim2.new(0.9, 0, 0, 40),
        UDim2.new(0, 0, 0, 0),
        miscScrollFrame)

    local antiLavaButton = createModernButton("AntiLava",
        settings.isAntiLavaEnabled and "Anti-Lava: ON" or "Anti-Lava: OFF",
        UDim2.new(0.9, 0, 0, 40),
        UDim2.new(0, 0, 0, 0),
        miscScrollFrame)

    local autoWinButton = createModernButton("AutoWin",
        settings.isAutoWinActive and "Auto Win: ON" or "Auto Win: OFF",
        UDim2.new(0.9, 0, 0, 40),
        UDim2.new(0, 0, 0, 0),
        miscScrollFrame)

    autoWinButton.MouseButton1Click:Connect(function()
        settings.isAutoWinActive = not settings.isAutoWinActive
        isAutoWinActive = settings.isAutoWinActive  -- Синхронизация переменных
        autoWinButton.Text = settings.isAutoWinActive and "Auto Win: ON" or "Auto Win: OFF"
        updateGuiState()
        
        if settings.isAutoWinActive then
            spawn(function()
                while isAutoWinActive do
                    autoWinFunction()
                    task.wait(0.1)  -- Добавляем задержку для предотвращения лагов
                end
            end)
        else
            isAutoWinActive = false
        end
    end)
    
    antiLavaButton.MouseButton1Click:Connect(function()
        settings.isAntiLavaEnabled = not settings.isAntiLavaEnabled
        antiLavaButton.Text = settings.isAntiLavaEnabled and "Anti-Lava: ON" or "Anti-Lava: OFF"
        updateGuiState()
        
        if settings.isAntiLavaEnabled then
            setupAntiLava()
        else
            local platform = workspace:FindFirstChild("InvisiblePlatform")
            if platform then
                platform:Destroy()
            end
        end
    end)

    -- Добавляем кнопку "Skill no CD" с выпадающим списком
    local skillNoCDButton = Instance.new("TextButton")
    skillNoCDButton.Name = "SkillNoCDButton"
    skillNoCDButton.Size = UDim2.new(0.9, 0, 0, 40)
    skillNoCDButton.Position = UDim2.new(0.05, 0, 0, 0)
    skillNoCDButton.BackgroundColor3 = theme.accent
    skillNoCDButton.BackgroundTransparency = 0.1
    skillNoCDButton.Text = "Skill no CD (None)"
    skillNoCDButton.TextColor3 = theme.text
    skillNoCDButton.Font = Enum.Font.GothamMedium
    skillNoCDButton.TextSize = 14
    skillNoCDButton.TextXAlignment = Enum.TextXAlignment.Left
    skillNoCDButton.Parent = miscScrollFrame

    local arrow = Instance.new("TextButton")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0.1, 0, 1, 0)
    arrow.Position = UDim2.new(0.9, 0, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = theme.text
    arrow.Font = Enum.Font.GothamMedium
    arrow.TextSize = 14
    arrow.Parent = skillNoCDButton

    local skillsListNoCD = Instance.new("ScrollingFrame")
    skillsListNoCD.Name = "SkillsListNoCD"
    skillsListNoCD.Size = UDim2.new(0.9, 0, 0.4, 0)
    skillsListNoCD.Position = UDim2.new(0.05, 0, 0.05, 40)
    skillsListNoCD.BackgroundColor3 = theme.foreground
    skillsListNoCD.BackgroundTransparency = 0.8
    skillsListNoCD.ScrollBarThickness = 4
    skillsListNoCD.Visible = false
    skillsListNoCD.Parent = miscScrollFrame
    skillsListNoCD.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local UIListLayoutNoCD = Instance.new("UIListLayout")
    UIListLayoutNoCD.Parent = skillsListNoCD
    UIListLayoutNoCD.Padding = UDim.new(0, 5)

    -- Заполнение списка скиллами
    for _, skillInfo in ipairs(skillData) do
        local skillEntry = Instance.new("TextButton")
    	skillEntry.Name = skillInfo.name
    	skillEntry.Size = UDim2.new(1, 0, 0, 30)  -- Фиксированная высота каждого элемента
    	skillEntry.BackgroundColor3 = theme.accent
    	skillEntry.BackgroundTransparency = 0.1
    	skillEntry.Text = skillInfo.name
    	skillEntry.TextColor3 = theme.text
    	skillEntry.Font = Enum.Font.GothamMedium
    	skillEntry.TextSize = 14
    	skillEntry.Parent = skillsListNoCD
	
	local icon = Instance.new("ImageLabel")
    	icon.Size = UDim2.new(0, 20, 0, 20)  -- Размер картинки
    	icon.Position = UDim2.new(1, -25, 0.5, -10)  -- Позиция справа с небольшим отступом
    	icon.AnchorPoint = Vector2.new(1, 0.5)  -- Якорь справа по центру
    	icon.BackgroundTransparency = 1
    	icon.Image = skillInfo.image
    	icon.Parent = skillEntry

        skillEntry.TextXAlignment = Enum.TextXAlignment.Left
        skillEntry.Text = skillInfo.name

        skillEntry.MouseButton1Click:Connect(function()
            selectedSkillNoCD = skillInfo.id
            skillNoCDButton.Text = "Skill no CD (" .. skillInfo.name .. ")"
            skillsListNoCD.Visible = false
        end)
    end

    -- Обработка нажатия на стрелочку
    arrow.MouseButton1Click:Connect(function()
    	skillsListNoCD.Visible = not skillsListNoCD.Visible
    	if skillsListNoCD.Visible then
            skillsListNoCD.CanvasPosition = Vector2.new(0, 0)  -- Сбросить позицию прокрутки
        end
    end)

    -- Обработка активности кнопки
    skillNoCDButton.MouseButton1Click:Connect(function()
    	isSkillNoCDActive = not isSkillNoCDActive
    	skillNoCDButton.Text = isSkillNoCDActive and "Skill no CD (Active)" or "Skill no CD (Inactive)"
	updateGuiState()
    end)

    local function fireServerWithSkill(skillID)
        if workspace:FindFirstChild("Event") and workspace.Event:FindFirstChild("SkillModule_RemoteFunction") then
            workspace.Event.SkillModule_RemoteFunction:InvokeServer({
                TYPE = "EquipSkill",
                Data = {
                    SkillID = skillID
                }
            })
        else
            warn("SkillModule_RemoteFunction not found!")
        end
    end

-- Основная функция проверки кулдауна и выполнения действий
    spawn(function()
        while true do
            if isSkillNoCDActive and selectedSkillNoCD and selectedSkillNoCD ~= "" then
                if isMobile then
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui and playerGui:FindFirstChild("MobileScr") then
                        local mobileScr = playerGui.MobileScr
                        if mobileScr and mobileScr:FindFirstChild("ControlFrame") then
                            local controlFrame = mobileScr.ControlFrame
                            if controlFrame and controlFrame:FindFirstChild("USE2") then
                                local use2 = controlFrame.USE2
                                if use2 and use2:FindFirstChild("CD") then
                                    local cdFrame = use2.CD
                                    if cdFrame.Size ~= UDim2.new(0.97, 0, 0, 0) then
                                    -- Запускаем две функции одновременно
                                        spawn(function() fireServerWithSkill("132002") end)
                                        spawn(function() fireServerWithSkill(selectedSkillNoCD) end)
                                    end
                                end
                            end
                        end
                    end
                else
                -- Для ПК: проверяем кулдаун перед выполнением
                    local playerGui = player:FindFirstChild("PlayerGui")
                    if playerGui and playerGui:FindFirstChild("Lobby") then
                        local lobby = playerGui.Lobby
                        if lobby and lobby:FindFirstChild("UI_Skill") then
                            local uiSkill = lobby.UI_Skill
                            if uiSkill and uiSkill:FindFirstChild("List") then
                                local list = uiSkill.List
                                if list and list:FindFirstChild("Skill3") then
                                    local skill3 = list.Skill3
                                    if skill3 and skill3:FindFirstChild("CDFrame") then
                                        local cdFrame = skill3.CDFrame
                                        if cdFrame.Size ~= UDim2.new(1, 0, 0, 0) then
                                        -- Запускаем две функции одновременно
                                            spawn(function() fireServerWithSkill("132002") end)
                                            spawn(function() fireServerWithSkill(selectedSkillNoCD) end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            wait(0.1)  -- Уменьшаем задержку для более частой проверки
        end
    end)

    local autoAttackButton = createModernButton("AutoAttack",
        settings.isAutoAttackEnabled and "Auto Attack: ON" or "Auto Attack: OFF",
        UDim2.new(0.9, 0, 0, 40),
        UDim2.new(0, 0, 0, 0),
        miscScrollFrame)

    local rangeToggleButton = createModernButton("RangeToggle",
        settings.showAttackRange and "Range: ON" or "Range: OFF",
        UDim2.new(0.9, 0, 0, 40),
        UDim2.new(0, 0, 0, 0),
        miscScrollFrame)

    -- Setup auto-attack
    local range, rangeUpdateConnection, cleanup = setupAutoAttack()

    -- Close button
    local closeButton = createModernButton("Close", "×", 
        UDim2.new(0.08, 0, 0.08, 0), UDim2.new(0.9, 0, 0.02, 0), contentFrame)

    -- Minimized icon
    local minimizedIcon = createModernButton("MinimizedIcon", "⚙️", 
        UDim2.new(0.04, 0, 0.06, 0), UDim2.new(0.01, 0, 0.9, 0), screenGui)
    minimizedIcon.Visible = not settings.isWindowOpen

    -- Enable resizing
    enableResizing(mainFrame)

    -- Start RGB cycling for title
    local titleColorConnection = RunService.Heartbeat:Connect(function()
        updateTitleColor(titleLabel)
    end)

    -- Tab switching
    skillsCategoryButton.MouseButton1Click:Connect(function()
        skillsFrame.Visible = true
        miscFrame.Visible = false
        skillsCategoryButton.BackgroundColor3 = theme.selected
        miscCategoryButton.BackgroundColor3 = theme.accent
    end)

    miscCategoryButton.MouseButton1Click:Connect(function()
        skillsFrame.Visible = false
        miscFrame.Visible = true
        miscCategoryButton.BackgroundColor3 = theme.selected
        skillsCategoryButton.BackgroundColor3 = theme.accent
    end)

    -- Search functionality
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBox.Text:lower()
        for _, entryData in ipairs(skillEntries) do
            if searchText == "" then
                entryData.entry.Visible = true
            else
                entryData.entry.Visible = string.find(entryData.name, searchText) ~= nil
            end
        end
    end)

    -- Button functionality
    skillToggleButton.MouseButton1Click:Connect(function()
        settings.isSkillFunctionActive = not settings.isSkillFunctionActive
        skillToggleButton.Text = settings.isSkillFunctionActive and "Skills: ON" or "Skills: OFF"
        updateGuiState()

        if settings.isSkillFunctionActive and isMobile then
            spawn(function()
                while settings.isSkillFunctionActive do
                    if #selectedSkills > 0 then
                        local randomSkillID = selectedSkills[math.random(1, #selectedSkills)]
                        workspace.Event.SkillModule_RemoteFunction:InvokeServer({
                            TYPE = "EquipSkill",
                            Data = { SkillID = randomSkillID }
                        })
                    end
                    task.wait(0.01)
                end
            end)
        end
    end)

    autoSkillButton.MouseButton1Click:Connect(function()
        settings.isAutoSkillActive = not settings.isAutoSkillActive
        autoSkillButton.Text = settings.isAutoSkillActive and "Auto Skill: ON" or "Auto Skill: OFF"
        updateGuiState()

        if settings.isAutoSkillActive then
            spawn(function()
                while settings.isAutoSkillActive do
                    if #selectedSkills > -1 then
                        workspace.Player[playerName].Communicate:FireServer({
                            Key = Enum.KeyCode.Three,
                            State = Enum.UserInputState.Begin
                        })
                    end
                    wait(0.01)
                end
            end)
        end
    end)

    -- Device cycling
    deviceButton.MouseButton1Click:Connect(function()
        settings.deviceStateIndex = (settings.deviceStateIndex + 1) % 3
        local devices = {
            {text = "Keyboard", data = {IsKeyboard = true, IsTouch = false, IsGamepad = false}},
            {text = "Touch", data = {IsKeyboard = false, IsTouch = true, IsGamepad = false}},
            {text = "Gamepad", data = {IsKeyboard = false, IsTouch = false, IsGamepad = true}}
        }
        
        local current = devices[settings.deviceStateIndex + 1]
        deviceButton.Text = "Device: " .. current.text
        updateGuiState()

        workspace.Event.PlayerAttribute_RemoteEvent:FireServer({
            TYPE = "SendDevice",
            Data = current.data
        })
    end)

    -- Auto attack controls
    autoAttackButton.MouseButton1Click:Connect(function()
        settings.isAutoAttackEnabled = not settings.isAutoAttackEnabled
        autoAttackButton.Text = settings.isAutoAttackEnabled and "Auto Attack: ON" or "Auto Attack: OFF"
        updateGuiState()
    end)

    rangeToggleButton.MouseButton1Click:Connect(function()
        settings.showAttackRange = not settings.showAttackRange
        rangeToggleButton.Text = settings.showAttackRange and "Range: ON" or "Range: OFF"
        updateGuiState()
    end)

    -- VIP Settings
    vipSettingsButton.MouseButton1Click:Connect(function()
        settings.areVIPSettingsActive = not settings.areVIPSettingsActive
        vipSettingsButton.Text = settings.areVIPSettingsActive and "VIP: ON" or "VIP: OFF"
        updateGuiState()

        local settingsToApply = {
            {Str = "IsHideScores", Value = settings.areVIPSettingsActive},
            {Str = "HideVIPTag", Value = settings.areVIPSettingsActive},
            {Str = "HideTotalKills", Value = settings.areVIPSettingsActive}
        }
        
        for _, setting in pairs(settingsToApply) do
            workspace.Event.PlayerSetting_RemoteEvent:FireServer({
                TYPE = "ChangeMySetting",
                Data = setting
            })
        end
    end)

    -- Window dragging
    local dragToggle, dragStart, startPos = nil, nil, nil

    titleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    titleLabel.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = false
            settings.windowPosition = mainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
            local delta = input.Position - dragStart
            local position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            mainFrame.Position = position
        end
    end)

    -- Window controls
    closeButton.MouseButton1Click:Connect(function()
        settings.isWindowOpen = false
        updateGuiState()
        if mainFrame and minimizedIcon then
            mainFrame.Visible = false
            minimizedIcon.Visible = true
        end
    end)

    minimizedIcon.MouseButton1Click:Connect(function()
        settings.isWindowOpen = true
        updateGuiState()
        if mainFrame and minimizedIcon then
            mainFrame.Visible = true
            minimizedIcon.Visible = false
        end
    end)

    local function enhancedCleanup()
        if cleanup then cleanup() end
        if titleColorConnection then titleColorConnection:Disconnect() end
        local platform = workspace:FindFirstChild("InvisiblePlatform")
        if platform then
            platform:Destroy()
        end
        screenGui:Destroy()
    end

    return screenGui, enhancedCleanup
end
-- Initialize GUI with proper visibility settings
local function initializeGUI()
    local gui, cleanup = createGUI()
    
    -- Set initial state
    settings.isWindowOpen = true  -- Make sure this is set initially
    if gui and gui:FindFirstChild("MainFrame") then
        gui.MainFrame.Visible = true  -- Start visible
        if gui:FindFirstChild("MinimizedIcon") then
            gui.MinimizedIcon.Visible = false  -- Hide icon initially
        end
        updateGuiState()  -- Make sure to update state after setting visibility
    end
    
    return gui, cleanup
end

-- Create initial GUI
local gui, cleanup = initializeGUI()

-- Keep track of GUI state
local isGuiOpen = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            settings.isWindowOpen = not settings.isWindowOpen
            updateGuiState()
            if gui then
                local mainFrame = gui:FindFirstChild("MainFrame")
                local minimizedIcon = gui:FindFirstChild("MinimizedIcon")
                if mainFrame and minimizedIcon then
                    mainFrame.Visible = settings.isWindowOpen
                    minimizedIcon.Visible = not settings.isWindowOpen
                else
                    restoreGUI()
                end
            else
                restoreGUI()
            end
        elseif settings.isSkillFunctionActive and input.KeyCode == Enum.KeyCode.Three and #selectedSkills > 0 then
            local randomSkillID = selectedSkills[math.random(1, #selectedSkills)]
            workspace.Event.SkillModule_RemoteFunction:InvokeServer({
                TYPE = "EquipSkill",
                Data = { SkillID = randomSkillID }
            })
        end
    end
end)

-- Function to restore GUI
local function restoreGUI()
    if gui and gui:FindFirstChild("MainFrame") then
        local mainFrame = gui:FindFirstChild("MainFrame")
        local minimizedIcon = gui:FindFirstChild("MinimizedIcon")
        
        if mainFrame and minimizedIcon then
            mainFrame.Visible = settings.isWindowOpen
            minimizedIcon.Visible = not settings.isWindowOpen
            if settings.isAntiLavaEnabled then
                setupAntiLava()
            else
                local platform = workspace:FindFirstChild("InvisiblePlatform")
                if platform then
                    platform:Destroy()
                end
            end
        end
        
        applyGuiState(gui)
    else
        if gui then gui:Destroy() end
        if cleanup then cleanup() end
        gui, cleanup = createGUI()
    end
end

-- Check GUI periodically
spawn(function()
    while wait(1) do
        if not gui or not gui.Parent then
            gui, cleanup = initializeGUI()
        end
        restoreGUI()
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    -- Cleanup existing platform
    local existingPlatform = workspace:FindFirstChild("InvisiblePlatform")
    if existingPlatform then
        existingPlatform:Destroy()
    end
    
    -- Restore GUI
    restoreGUI()
    
    -- Restore Anti-Lava if enabled
    if settings.isAntiLavaEnabled then
        setupAntiLava()
    end
end)

-- Add these variables at the top of this section
local lastUpdate = 0
local updateCooldown = 1 -- 1 second cooldown

local function handleWorkspaceChange()
    local currentTime = tick()
    if currentTime - lastUpdate < updateCooldown then return end
    lastUpdate = currentTime
    
    task.wait(0.1)
    if settings.isAntiLavaEnabled then
        setupAntiLava()
    end
end

workspace.DescendantRemoving:Connect(handleWorkspaceChange)
workspace.DescendantAdded:Connect(handleWorkspaceChange)

-- Update GUI state when toggled

-- Cleanup only when player leaves
game.Players.LocalPlayer.Destroying:Connect(function()
    if cleanup then
        cleanup()
    end
    if gui then
        gui:Destroy()
    end
end)
