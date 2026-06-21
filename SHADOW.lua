

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrookhavenMegaUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 410, 0, 480)
mainFrame.Position = UDim2.new(0.5, -205, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 255, 200)
stroke.Thickness = 2.5

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "⚡ BROOKHAVEN MEGA CHETADO ⚡"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = mainFrame

-- Controles
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 38, 0, 38)
minimizeBtn.Position = UDim2.new(1, -88, 0, 8)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
minimizeBtn.Text = "−"
minimizeBtn.TextScaled = true
minimizeBtn.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 38, 0, 38)
closeBtn.Position = UDim2.new(1, -45, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextScaled = true
closeBtn.Parent = mainFrame

local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 65, 0, 65)
miniButton.Position = UDim2.new(0, 20, 1, -90)
miniButton.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
miniButton.Text = "⚡"
miniButton.TextScaled = true
miniButton.Visible = false
miniButton.Parent = screenGui

for _, b in pairs({minimizeBtn, closeBtn, miniButton}) do
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
end

-- Tabs
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 45)
tabFrame.Position = UDim2.new(0, 10, 0, 60)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {}
local function createTab(emoji, name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 1, 0)
    btn.Position = UDim2.new(0, (#tabs * 78), 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = emoji
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -135)
    content.Position = UDim2.new(0, 10, 0, 115)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 5
    content.Visible = false
    content.Parent = mainFrame

    Instance.new("UIListLayout", content).Padding = UDim.new(0, 8)

    table.insert(tabs, {button = btn, content = content})
    btn.MouseButton1Click:Connect(function()
        for _, t in tabs do 
            t.content.Visible = false 
            t.button.BackgroundColor3 = Color3.fromRGB(30,30,35)
        end
        content.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    end)
    return content
end

local home      = createTab("🏠", "Home")
local movement  = createTab("🏃", "Movement")
local teleports = createTab("📍", "Teleports")
local visuals   = createTab("👁️", "Visuals")
local playerTab = createTab("👤", "Player")
local troll     = createTab("😈", "Troll")
local chatTab   = createTab("💬", "Chat")
local misc      = createTab("🔧", "Misc")

-- Variables
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local noclipping = false

local function toggleFly(state)
    flying = state
    if flying then
        spawn(function()
            while flying and root do
                local cam = workspace.CurrentCamera
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
                root.Velocity = move.Magnitude > 0 and move.Unit * 75 or Vector3.new()
                RunService.RenderStepped:Wait()
            end
        end)
    end
end

local function toggleNoclip(state)
    noclipping = state
    spawn(function()
        while noclipping do
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            RunService.Stepped:Wait()
        end
    end)
end

-- Toggle Function
local function createToggle(parent, text, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 48)
    f.BackgroundColor3 = Color3.fromRGB(30,30,35)
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "  " .. text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextScaled = true
    label.Parent = f

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 52, 0, 28)
    switch.Position = UDim2.new(1, -62, 0.5, -14)
    switch.BackgroundColor3 = default and Color3.fromRGB(0,255,120) or Color3.fromRGB(70,70,75)
    switch.Text = ""
    switch.Parent = f
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1,0)

    local enabled = default
    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(switch, TweenInfo.new(0.25), {BackgroundColor3 = enabled and Color3.fromRGB(0,255,120) or Color3.fromRGB(70,70,75)}):Play()
        callback(enabled)
    end)
end

-- ==================== TELEPORTS MEJORADOS ====================
local teleportList = {
    ["Spawn"] = Vector3.new(-25, 10, 95),
    ["Police Station"] = Vector3.new(125, 22, -195),
    ["School"] = Vector3.new(-335, 38, 435),
    ["Hospital"] = Vector3.new(495, 22, 295),
    ["Beach"] = Vector3.new(870, 6, -670),
    ["Mall"] = Vector3.new(-565, 28, -795),
    ["Park"] = Vector3.new(210, 12, 615),
    ["Cafe"] = Vector3.new(-180, 20, -420),
    ["House 1"] = Vector3.new(450, 25, 150),
    ["House 2"] = Vector3.new(-650, 25, 300),
    ["House 3"] = Vector3.new(300, 25, -500),
    ["Rooftop"] = Vector3.new(50, 80, 100),
}

for name, pos in pairs(teleportList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 46)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    btn.Text = "📍 " .. name
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = teleports
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        if root then 
            root.CFrame = CFrame.new(pos + Vector3.new(0, 8, 0)) 
            print("Teleported to: " .. name)
        end
    end)
end

-- ==================== TROLL MEJORADO ====================
createToggle(troll, "Spam Chat (Local)", false, function(v)
    print("Spam Chat:", v)
    -- Puedes expandir esto con un loop si quieres
end)

createToggle(troll, "Force Sit (Local)", false, function(v)
    if humanoid then humanoid.Sit = v end
end)

local spamConnection
createToggle(troll, "Server Chat Spam", false, function(v)
    if v then
        spawn(function()
            while v and wait(1.2) do
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Brookhaven es divertido 😈", "All")
            end
        end)
    end
end)

createToggle(troll, "Make Everyone Jump", false, function(v)
    print("Everyone Jump Troll:", v)
end)

local btnKickLocal = Instance.new("TextButton")
btnKickLocal.Size = UDim2.new(1, -20, 0, 46)
btnKickLocal.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
btnKickLocal.Text = "💥 Kick Local Player"
btnKickLocal.TextScaled = true
btnKickLocal.Font = Enum.Font.GothamBold
btnKickLocal.Parent = troll
Instance.new("UICorner", btnKickLocal).CornerRadius = UDim.new(0, 10)

btnKickLocal.MouseButton1Click:Connect(function()
    player:Kick("Troll activado 😈")
end)

-- Resto de pestañas (Home, Movement, etc.)
createToggle(home, "Fly", false, toggleFly)
createToggle(home, "Noclip", false, toggleNoclip)

createToggle(movement, "Speed Hack", false, function(v) 
    if humanoid then humanoid.WalkSpeed = v and 70 or 16 end 
end)
createToggle(movement, "High Jump", false, function(v) 
    if humanoid then humanoid.JumpPower = v and 150 or 50 end 
end)

createToggle(playerTab, "Invisible", false, function(v)
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name \~= "HumanoidRootPart" then
                part.Transparency = v and 1 or 0.3
            end
        end
    end
end)

createToggle(visuals, "Full Bright", false, function(v)
    Lighting.Brightness = v and 3 or 1
    Lighting.ClockTime = v and 14 or 12
end)

-- Chat Reader (mantenido)
local chatLog = Instance.new("ScrollingFrame")
chatLog.Size = UDim2.new(1,-20,1,-10)
chatLog.BackgroundTransparency = 1
chatLog.Parent = chatTab
Instance.new("UIListLayout", chatLog).Padding = UDim.new(0,5)

local function addChat(sender, msg)
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1,0,0,52)
    entry.BackgroundColor3 = Color3.fromRGB(28,28,33)
    entry.Parent = chatLog
    Instance.new("UICorner", entry).CornerRadius = UDim.new(0,8)

    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1,0,0.4,0)
    s.BackgroundTransparency = 1
    s.Text = "   " .. sender
    s.TextColor3 = Color3.fromRGB(0,255,200)
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Font = Enum.Font.GothamBold
    s.TextScaled = true
    s.Parent = entry

    local m = Instance.new("TextLabel")
    m.Size = UDim2.new(1,0,0.6,0)
    m.Position = UDim2.new(0,0,0.4,0)
    m.BackgroundTransparency = 1
    m.Text = "   " .. msg
    m.TextColor3 = Color3.fromRGB(230,230,230)
    m.TextWrapped = true
    m.TextScaled = true
    m.Parent = entry

    chatLog.CanvasPosition = Vector2.new(0, chatLog.AbsoluteCanvasSize.Y)
end

TextChatService.TextChannels.RBXGeneral.MessageReceived:Connect(function(msg)
    local name = msg.TextSource and msg.TextSource.Name or "Sistema"
    addChat(name, msg.Text)
end)

-- Minimizar, Cerrar y Arrastrar
minimizeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false; miniButton.Visible = true end)
miniButton.MouseButton1Click:Connect(function() mainFrame.Visible = true; miniButton.Visible = false end)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Arrastrar
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

tabs[1].content.Visible = true
tabs[1].button.BackgroundColor3 = Color3.fromRGB(0,255,200)

print("🚀 Brookhaven Mega UI v5 cargada - Troll y Teleports mejorados!")
