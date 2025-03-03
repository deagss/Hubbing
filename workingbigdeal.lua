-- Settings and Variables
local WallbangChance = 50
local InstantBulletChance = 50
local EnabledHack = false
local minESPsize = 2
local lazerWidth = 0.05
local ESPCache = {}
local DraggingUI = false
local LastMousePos = Vector2.new(0, 0)
local HitChance = 100 -- Default 100% hit chance

-- Services
local Players = game:GetService('Players')
local Workspace = game:GetService('Workspace')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local CoreGui = game:GetService("StarterGui")
local TweenService = game:GetService('TweenService')

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Utility Functions
local function CreateESP(basepart, color)
    local newEspGui = Instance.new("BillboardGui", LocalPlayer.PlayerGui)
    newEspGui.Adornee = basepart
    newEspGui.AlwaysOnTop = true
    local espSize = basepart.Size.X > basepart.Size.Z and basepart.Size.X or basepart.Size.Z
    newEspGui.Size = UDim2.new(espSize, minESPsize, espSize, minESPsize)
    local espFrame = Instance.new("Frame", newEspGui)
    espFrame.Size = UDim2.new(1, 0, 1, 0)
    espFrame.BackgroundTransparency = 1
    local newStroke = Instance.new("UIStroke", espFrame)
    newStroke.Color = color or basepart.Color
    newStroke.Thickness = 1
    table.insert(ESPCache, newEspGui)
end

local function lookAtBoard(board)
    local connection
    local goin = true
    
    task.delay(5, function()
        goin = false
        if connection then
            connection:Disconnect()
        end
    end)
    
    connection = RunService.RenderStepped:Connect(function()
        if goin then
            Camera.CFrame = CFrame.new(board.CFrame.Position + board.CFrame.LookVector * 10, board.CFrame.Position)
        end
    end)
end

local function toggleHearAllPlayers()
    if LocalPlayer:FindFirstChild("HearAllPlayers") then
        LocalPlayer:FindFirstChild("HearAllPlayers"):Destroy()
        return
    end
    local output = Instance.new("AudioDeviceOutput", LocalPlayer)
    output.Name = "HearAllPlayers"
    output.Player = LocalPlayer

    for _, p in Players:GetPlayers() do
        if p == LocalPlayer then continue end
        local mic = p:FindFirstChildOfClass("AudioDeviceInput")
        if mic then
            local newWire = Instance.new("Wire", output)
            newWire.SourceInstance = mic
            newWire.TargetInstance = output
        end
    end
end

local function addLaser(part)
    if not part or not part:IsA("BasePart") then return end
    
    local laserPart = Instance.new("Part")
    laserPart.Parent = workspace
    laserPart.Anchored = true
    laserPart.CanCollide = false
    laserPart.CastShadow = false
    laserPart.Material = Enum.Material.Neon
    laserPart.Color = Color3.fromRGB(255, 0, 0)
    laserPart.Size = Vector3.new(lazerWidth, lazerWidth, 1)

    local function updateLaser()
        if not part or not part.Parent then
            laserPart:Destroy()
            return
        end

        local startPos = part.Position + (part.CFrame.UpVector / 3.5)
        local direction = part.CFrame.LookVector * 5000
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {part.Parent, workspace:WaitForChild(LocalPlayer.Name), laserPart}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.IgnoreWater = true

        local raycastResult = workspace:Raycast(startPos, direction, raycastParams)

        if raycastResult then
            local hitPoint = raycastResult.Position
            local laserLength = (hitPoint - startPos).Magnitude
            laserPart.Size = Vector3.new(lazerWidth, lazerWidth, laserLength)
            laserPart.CFrame = CFrame.new(startPos, hitPoint) * CFrame.new(0, 0, -laserLength / 2)
        else
            local maxEnd = startPos + direction
            local laserLength = (maxEnd - startPos).Magnitude
            laserPart.Size = Vector3.new(lazerWidth, lazerWidth, laserLength)
            laserPart.CFrame = CFrame.new(startPos, maxEnd) * CFrame.new(0, 0, -laserLength / 2)
        end
    end

    RunService.Heartbeat:Connect(updateLaser)
end


-- Place this right after your Services and Variables section, before the UI code:

function GetClosestToMouse()
    local MouseLocation = UserInputService:GetMouseLocation();
    local ClosestPlayer = nil;
    local ClosestCharacter = nil;
    local ClosestDistance = math.huge;

    for _, Player in next, Players:GetPlayers() do
        if (Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild('HumanoidRootPart')) then
            local Character = Player.Character;
            local RootPart = Character.HumanoidRootPart;
        
            local ScreenPosition, OnScreen = Camera:WorldToScreenPoint(RootPart.Position);
            if (OnScreen) then
                local Distance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - MouseLocation).Magnitude;
                if (Distance < ClosestDistance) then
                    ClosestDistance = Distance;
                    ClosestPlayer = Player;
                    ClosestCharacter = Character;
                end;
            end;
        end;
    end;

    return ClosestPlayer, ClosestCharacter;
end;

-- Initialize the aimbot hook
local Bullet = require(ReplicatedStorage.Components.BulletFactory);
local OldFire; OldFire = hookfunction(Bullet.Fire, function(BulletId, Origin, BulletPos, ...)
    if EnabledHack then
        if math.random(1, 100) <= HitChance then -- Only attempt to hit if within hit chance
            local Player, Character = GetClosestToMouse();
            if (Player and Character and Character:FindFirstChild('Head')) then
                BulletPos = (Character.Head.Position - Origin).Unit * 10000;
            end
        end
    end
    return OldFire(BulletId, Origin, BulletPos, ...);
end);

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UnifiedHackGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Active = true
MainFrame.AutomaticSize = Enum.AutomaticSize.None

-- Create resizing functionality
local function makeResizable(frame)
    local resizerSize = 10
    local resizer = Instance.new("TextButton")
    resizer.Name = "Resizer"
    resizer.Parent = frame
    resizer.BackgroundTransparency = 1
    resizer.Position = UDim2.new(1, -resizerSize, 1, -resizerSize)
    resizer.Size = UDim2.new(0, resizerSize, 0, resizerSize)
    resizer.Text = ""
    
    local dragging = false
    local startPos
    local startSize
    
    resizer.MouseButton1Down:Connect(function()
        dragging = true
        startPos = UserInputService:GetMouseLocation()
        startSize = frame.Size
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = UserInputService:GetMouseLocation() - startPos
            local newSize = UDim2.new(
                startSize.X.Scale,
                math.clamp(startSize.X.Offset + delta.X, 400, 800),
                startSize.Y.Scale,
                math.clamp(startSize.Y.Offset + delta.Y, 300, 600)
            )
            frame.Size = newSize
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create smooth dragging functionality
local function makeDraggable(frame)
    local UserInputService = game:GetService("UserInputService")
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            DraggingUI = true
            LastMousePos = UserInputService:GetMouseLocation()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if DraggingUI and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local delta = mousePos - LastMousePos
            frame.Position = UDim2.new(
                frame.Position.X.Scale,
                frame.Position.X.Offset + delta.X,
                frame.Position.Y.Scale,
                frame.Position.Y.Offset + delta.Y
            )
            LastMousePos = mousePos
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            DraggingUI = false
        end
    end)
end

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Create RGB Title
local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Parent = MainFrame
TitleFrame.BackgroundTransparency = 1
TitleFrame.Position = UDim2.new(0, 0, 0, 5)
TitleFrame.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "PasHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Create Glow effect
local TitleGlow = Instance.new("TextLabel")
TitleGlow.Name = "TitleGlow"
TitleGlow.Parent = Title
TitleGlow.BackgroundTransparency = 1
TitleGlow.Position = UDim2.new(0, 0, 0, 0)
TitleGlow.Size = UDim2.new(1, 0, 1, 0)
TitleGlow.Font = Enum.Font.GothamBold
TitleGlow.Text = "PasHub"
TitleGlow.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleGlow.TextSize = 24
TitleGlow.TextXAlignment = Enum.TextXAlignment.Left
TitleGlow.TextTransparency = 0.5

-- Add a subtle glow effect
local UIGradient = Instance.new("UIGradient")
UIGradient.Parent = TitleGlow
UIGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0.5),
    NumberSequenceKeypoint.new(1, 0)
})

-- RGB Animation
local function updateRGB()
    local tick = tick()
    local hue = tick % 5 / 5
    local color = Color3.fromHSV(hue, 1, 1)
    Title.TextColor3 = color
    TitleGlow.TextColor3 = color
end

RunService.RenderStepped:Connect(updateRGB)

-- Create sections container
local SectionsFrame = Instance.new("Frame")
SectionsFrame.Name = "Sections"
SectionsFrame.Parent = MainFrame
SectionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SectionsFrame.Position = UDim2.new(0, 10, 0, 40)
SectionsFrame.Size = UDim2.new(1, -20, 1, -50)

local UICornerSections = Instance.new("UICorner")
UICornerSections.CornerRadius = UDim.new(0, 8)
UICornerSections.Parent = SectionsFrame

-- Create section function
local function createSection(name, position)
    local section = Instance.new("Frame")
    section.Name = name
    section.Parent = SectionsFrame
    section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    section.Position = position
    section.Size = UDim2.new(0.3, -10, 1, -20)
    section.ClipsDescendants = true
    
    local UICornerSection = Instance.new("UICorner")
    UICornerSection.CornerRadius = UDim.new(0, 8)
    UICornerSection.Parent = section
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "Title"
    sectionTitle.Parent = section
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Position = UDim2.new(0, 10, 0, 5)
    sectionTitle.Size = UDim2.new(1, -20, 0, 30)
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Text = name
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.TextSize = 14
    
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content"
    contentFrame.Parent = section
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 5, 0, 40)
    contentFrame.Size = UDim2.new(1, -10, 1, -50)
    contentFrame.ScrollBarThickness = 2
    contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = contentFrame
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    return contentFrame
end

-- Create toggle button function
local function createToggle(parent, name, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = name
    toggle.Parent = parent
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.Size = UDim2.new(1, -10, 0, 30)
    
    local UICornerToggle = Instance.new("UICorner")
    UICornerToggle.CornerRadius = UDim.new(0, 6)
    UICornerToggle.Parent = toggle
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Button"
    toggleButton.Parent = toggle
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 59, 59)
    toggleButton.Position = UDim2.new(1, -35, 0.5, -10)
    toggleButton.Size = UDim2.new(0, 25, 0, 20)
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    
    local UICornerButton = Instance.new("UICorner")
    UICornerButton.CornerRadius = UDim.new(0, 4)
    UICornerButton.Parent = toggleButton
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "Text"
    toggleText.Parent = toggle
    toggleText.BackgroundTransparency = 1
    toggleText.Position = UDim2.new(0, 10, 0, 0)
    toggleText.Size = UDim2.new(1, -50, 1, 0)
    toggleText.Font = Enum.Font.Gotham
    toggleText.Text = name
    toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleText.TextSize = 12
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    
    local enabled = false
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(59, 255, 59) or Color3.fromRGB(255, 59, 59)
        if callback then callback(enabled) end
    end)
    
    return toggle
end

-- Create sections
local visualsSection = createSection("Visuals", UDim2.new(0, 10, 0, 10))
local aimingSection = createSection("Aiming", UDim2.new(0.33, 5, 0, 10))
local miscSection = createSection("Misc", UDim2.new(0.66, 0, 0, 10))

-- Add features to sections
-- Visuals Section
createToggle(visualsSection, "Cash ESP", function(enabled)
    if enabled then
        for _, d in workspace:GetDescendants() do
            if string.lower(d.Name) == "cash" and d:IsA("Model") then
                local part = d:FindFirstChild("Root")
                if part and part:IsA("BasePart") then
                    CreateESP(part, Color3.new(0, 1, 0))
                end
            end
        end
    else
        for _, esp in pairs(ESPCache) do
            esp:Destroy()
        end
        ESPCache = {}
    end
end)

createToggle(visualsSection, "Fake Cash ESP", function(enabled)
    if enabled then
        for _, d in workspace:GetDescendants() do
            if string.lower(d.Name) == "fakecash" and d:IsA("Model") then
                local part = d:FindFirstChild("Root")
                if part and part:IsA("BasePart") then
                    CreateESP(part, Color3.new(1, 0.666667, 0))
                end
            end
        end
    else
        for _, esp in pairs(ESPCache) do
            esp:Destroy()
        end
        ESPCache = {}
    end
end)

createToggle(visualsSection, "Disk ESP", function(enabled)
    if enabled then
        for _, d in workspace:GetDescendants() do
            if string.lower(d.Name) == "disk" and d:IsA("Model") then
                local part = d:FindFirstChild("Color")
                if part and part:IsA("BasePart") then
                    CreateESP(part, Color3.new(0, 0, 0))
                end
            end
        end
    else
        for _, esp in pairs(ESPCache) do
            esp:Destroy()
        end
        ESPCache = {}
    end
end)

createToggle(visualsSection, "Grenade ESP", function(enabled)
    if enabled then
        for _, d in workspace:GetDescendants() do
            if string.lower(d.Name) == "grenade" and d:IsA("Model") then
                local part = d:FindFirstChild("Root")
                if part and part:IsA("BasePart") then
                    CreateESP(part, Color3.new(1, 0, 0))
                end
            end
        end
    else
        for _, esp in pairs(ESPCache) do
            esp:Destroy()
        end
        ESPCache = {}
    end
end)

createToggle(visualsSection, "Seltzer Bottle ESP", function(enabled)
    if enabled then
        for _, d in workspace:GetDescendants() do
            if string.lower(d.Name) == "bottle" and d:IsA("Model") then
                local part = d:FindFirstChild("Fluid")
                if part and part:IsA("BasePart") then
                    CreateESP(part, Color3.new(0.666667, 0, 0.498039))
                end
            end
        end
    else
        for _, esp in pairs(ESPCache) do
            esp:Destroy()
        end
        ESPCache = {}
    end
end)

createToggle(visualsSection, "Player ESP", function(enabled)
    if enabled then
        for _, p in Players:GetPlayers() do
            local playerChar = workspace:FindFirstChild(p.Name)
            if playerChar then
                if playerChar:FindFirstChild("Head") then
                    CreateESP(playerChar:FindFirstChild("Head"), Color3.new(1, 1, 1))
                end
                if playerChar:FindFirstChild("Torso") then
                    CreateESP(playerChar:FindFirstChild("Torso"), Color3.new(1, 1, 1))
                end
            end
        end
    else
        for _, esp in pairs(ESPCache) do
            esp:Destroy()
        end
        ESPCache = {}
    end
end)

-- Aiming Section
createToggle(aimingSection, "Aimbot", function(enabled)
    EnabledHack = enabled
end)

createToggle(aimingSection, "Wallbang", function(enabled)
    if enabled then
        local Player, Character = GetClosestToMouse();
        if (Player and Character and Character:FindFirstChild('Head')) then
            Origin = (Character.Head.CFrame * CFrame.new(0,0,1)).p;
        end
    end
end)

createToggle(aimingSection, "All Lazers", function(enabled)
    if enabled then
        for _, g in workspace:GetChildren() do
            if (g.Name == "Snub" or g.Name == "Pistol" or g.Name == "DB" or 
                g.Name == "AK47" or g.Name == "ToolboxMAC10" or g.Name == "MP5" or 
                g.Name == "Sniper" or g.Name == "AceCarbine" or g.Name == "MAGNUM") 
                and g:FindFirstChild("Root") then
                addLaser(g:FindFirstChild("Root"))
            end
        end
    end
end)

-- Create slider function
local function createSlider(parent, name, defaultValue, minValue, maxValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name.."Slider"
    sliderFrame.Parent = parent
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.Size = UDim2.new(1, -10, 0, 45)
    
    local UICornerSlider = Instance.new("UICorner")
    UICornerSlider.CornerRadius = UDim.new(0, 6)
    UICornerSlider.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Parent = sliderFrame
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Position = UDim2.new(0, 10, 0, 0)
    sliderLabel.Size = UDim2.new(1, -20, 0, 20)
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Text = name..": "..defaultValue
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 12
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBG = Instance.new("Frame")
    sliderBG.Name = "Background"
    sliderBG.Parent = sliderFrame
    sliderBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderBG.Position = UDim2.new(0, 10, 0, 25)
    sliderBG.Size = UDim2.new(1, -20, 0, 6)
    
    local UICornerBG = Instance.new("UICorner")
    UICornerBG.CornerRadius = UDim.new(1, 0)
    UICornerBG.Parent = sliderBG
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.Parent = sliderBG
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Position = UDim2.new((defaultValue - minValue)/(maxValue - minValue), -6, 0.5, -6)
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    
    local UICornerButton = Instance.new("UICorner")
    UICornerButton.CornerRadius = UDim.new(1, 0)
    UICornerButton.Parent = sliderButton
    
    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBG.AbsolutePosition
            local sliderSize = sliderBG.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = math.floor(minValue + (maxValue - minValue) * relativeX)
            
            sliderButton.Position = UDim2.new(relativeX, -6, 0.5, -6)
            sliderLabel.Text = name..": "..value
            
            if callback then callback(value) end
        end
    end)
    
    return sliderFrame
end

createSlider(aimingSection, "Hit Chance", HitChance, 0, 100, function(value)
    HitChance = value
    print("Hit Chance set to: " .. value) -- Debug line
end)


-- Misc Section
createToggle(miscSection, "Chat Monitor", function(enabled)
    local chatEvent = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ToClient"):WaitForChild("Chat")
    if chatEvent then
        chatEvent.OnClientEvent:Connect(function(plr, part, message)
            if enabled then
                print(plr.Name .. " sent: ".. message)
                CoreGui:SetCore("SendNotification", {
                    Title = plr.Name;
                    Text = message;
                    Duration = 3;
                })
            end
        end)
    end
end)

createToggle(miscSection, "Hear All Players", function(enabled)
    toggleHearAllPlayers()
end)

-- Apply dragging and resizing
makeDraggable(MainFrame)
makeResizable(MainFrame)

-- Add keybind to toggle UI visibility
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initialize the UI
MainFrame.Visible = true
