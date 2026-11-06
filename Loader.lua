local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local Config = {
    Aimbot = false, ESP = false, Speed = false, AutoClicker = false, JumpEnabled = false, AutoBounty = false, WaterWalk = true, Tracer = true,
    WalkSpeed = 45, JumpPower = 80, FOV = 500, Target = nil, BountyTarget = nil
}

-- Limpiar interfaz anterior de forma segura
pcall(function()
    if PlayerGui:FindFirstChild("GreaferProPvP") then
        PlayerGui.GreaferProPvP:Destroy()
    end
end)

local function Create(class, parent, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    inst.Parent = parent
    return inst
end

-- ScreenGui Principal
local Screen = Create("ScreenGui", PlayerGui, {Name = "GreaferProPvP", ResetOnSpawn = false})

-- Línea Roja (Tracer) dibujada dinámicamente en pantalla
local TracerLine = Create("Frame", Screen, {
    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 5
})
Create("UIStroke", TracerLine, {Color = Color3.fromRGB(255, 0, 0), Thickness = 1.5})

-- Botón Flotante Estilo Menú
local Toggle = Create("TextButton", Screen, {
    Position = UDim2.new(0.03, 0, 0.15, 0), Size = UDim2.new(0, 130, 0, 35),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25), TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold, TextSize = 11, Text = "👑 Greafer [OFF]", Draggable = true
})
Create("UICorner", Toggle, {CornerRadius = UDim.new(0, 6)})
Create("UIStroke", Toggle, {Color = Color3.fromRGB(200, 30, 30), Thickness = 1.5})

-- Ventana Principal
local Main = Create("Frame", Screen, {
    Position = UDim2.new(0.15, 0, 0.2, 0), Size = UDim2.new(0, 440, 0, 310),
    BackgroundColor3 = Color3.fromRGB(18, 18, 22), Visible = false
})
Create("UICorner", Main, {CornerRadius = UDim.new(0, 8)})
Create("UIStroke", Main, {Color = Color3.fromRGB(200, 30, 30), Thickness = 1.2})

-- Barra Superior (Sistema de arrastre táctil para móvil)
local TopBar = Create("Frame", Main, {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(25, 25, 32)})
Create("UICorner", TopBar, {CornerRadius = UDim.new(0, 8)})

Create("TextLabel", TopBar, {
    Position = UDim2.new(0.02, 0, 0, 0), Size = UDim2.new(0.7, 0, 1, 0), BackgroundTransparency = 1,
    Text = "👑 Greafer Pro | PVP (Blox Fruits)", TextColor3 = Color3.fromRGB(255, 215, 0),
    Font = Enum.Font.GothamBold, TextSize = 11
})

-- Botón de Cierre (X)
local CloseBtn = Create("TextButton", TopBar, {
    Position = UDim2.new(0.9, 0, 0.1, 0), Size = UDim2.new(0, 35, 0, 24),
    BackgroundColor3 = Color3.fromRGB(180, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold, TextSize = 12, Text = "X"
})
Create("UICorner", CloseBtn, {CornerRadius = UDim.new(0, 5)})
CloseBtn.MouseButton1Click:Connect(function()
    Screen:Destroy()
end)

-- [SISTEMA DE ARRASTRE TÁCTIL] --
local dragging, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Sidebar Izquierdo
local Sidebar = Create("Frame", Main, {
    Position = UDim2.new(0, 0, 0, 35), Size = UDim2.new(0, 120, 0, 270),
    BackgroundTransparency = 1
})

-- Contenedor Derecho (Combate)
local CombatContainer = Create("ScrollingFrame", Main, {
    Position = UDim2.new(0.28, 0, 0, 38), Size = UDim2.new(0, 310, 0, 265),
    BackgroundTransparency = 1, CanvasSize = UDim2.new(0, 0, 2.7, 0), ScrollBarThickness = 4, Visible = true
})

-- Contenedor Derecho (ESP)
local ESPContainerFrame = Create("ScrollingFrame", Main, {
    Position = UDim2.new(0.28, 0, 0, 38), Size = UDim2.new(0, 310, 0, 265),
    BackgroundTransparency = 1, CanvasSize = UDim2.new(0, 0, 1.2, 0), ScrollBarThickness = 4, Visible = false
})

-- Contenedor Derecho (General - Créditos)
local GeneralContainer = Create("Frame", Main, {
    Position = UDim2.new(0.28, 0, 0, 38), Size = UDim2.new(0, 310, 0, 265),
    BackgroundTransparency = 1, Visible = false
})

-- Título en General: "Hecho por Greafer y Rey"
local CreditsBox = Create("Frame", GeneralContainer, {
    Position = UDim2.new(0.05, 0, 0.1, 0), Size = UDim2.new(0, 290, 0, 70),
    BackgroundColor3 = Color3.fromRGB(28, 28, 35)
})
Create("UICorner", CreditsBox, {CornerRadius = UDim.new(0, 8)})
Create("UIStroke", CreditsBox, {Color = Color3.fromRGB(255, 215, 0), Thickness = 1.5})

Create("TextLabel", CreditsBox, {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    Text = "👑 Hecho por Greafer y Rey 👑\n[ Blox Fruits Mobile PvP ]",
    TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 12, TextWrapped = true
})

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Toggle.Text = Main.Visible and "👑 Greafer [ON]" or "👑 Greafer [OFF]"
    Toggle.UIStroke.Color = Main.Visible and Color3.fromRGB(30, 200, 50) or Color3.fromRGB(200, 30, 30)
end)

local function AddToggleOption(parent, name, defaultState, callback)
    local btn = Create("TextButton", parent, {
        Size = UDim2.new(0, 295, 0, 35), 
        BackgroundColor3 = defaultState and Color3.fromRGB(140, 30, 30) or Color3.fromRGB(28, 28, 35),
        TextColor3 = defaultState and Color3.new(1,1,1) or Color3.fromRGB(180, 180, 180),
        Font = Enum.Font.GothamBold, TextSize = 11, Text = name .. (defaultState and ": ON" or ": OFF")
    })
    Create("UICorner", btn, {CornerRadius = UDim.new(0, 6)})
    
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.TextColor3 = state and Color3.new(1,1,1) or Color3.fromRGB(180, 180, 180)
        btn.BackgroundColor3 = state and Color3.fromRGB(140, 30, 30) or Color3.fromRGB(28, 28, 35)
        callback(state)
    end)
end

Create("UIListLayout", CombatContainer, {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
Create("UIListLayout", ESPContainerFrame, {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})

-- Opciones en Combat
AddToggleOption(CombatContainer, "Aimbot (Camera Lock)", false, function(state)
    Config.Aimbot = state
    if not state then Config.Target = nil end
end)

AddToggleOption(CombatContainer, "Target Tracer (Línea Roja)", true, function(state)
    Config.Tracer = state
    if not state then TracerLine.Visible = false end
end)

AddToggleOption(CombatContainer, "Auto Farm Bounty", false, function(state)
    Config.AutoBounty = state
    if not state then Config.BountyTarget = nil end
end)

AddToggleOption(CombatContainer, "Water Walk (Caminar Agua)", true, function(state)
    Config.WaterWalk = state
end)

AddToggleOption(CombatContainer, "PvP Speed Boost", false, function(state)
    Config.Speed = state
end)

AddToggleOption(CombatContainer, "Auto Clicker (Daño Real)", false, function(state)
    Config.AutoClicker = state
end)

AddToggleOption(CombatContainer, "Jump Boost (Salto Alto)", false, function(state)
    Config.JumpEnabled = state
end)

local JumpControl = Create("TextButton", CombatContainer, {
    Size = UDim2.new(0, 295, 0, 35), BackgroundColor3 = Color3.fromRGB(35, 35, 45),
    TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 11,
    Text = "Jump Power: 80 (Click para sumar +15)"
})
Create("UICorner", JumpControl, {CornerRadius = UDim.new(0, 6)})
JumpControl.MouseButton1Click:Connect(function()
    Config.JumpPower = Config.JumpPower >= 150 and 50 or Config.JumpPower + 15
    JumpControl.Text = "Jump Power: " .. Config.JumpPower .. " (Click para sumar +15)"
end)

local SpeedControl = Create("TextButton", CombatContainer, {
    Size = UDim2.new(0, 295, 0, 35), BackgroundColor3 = Color3.fromRGB(35, 35, 45),
    TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 11,
    Text = "Speed Value: 45 (Click para sumar +5)"
})
Create("UICorner", SpeedControl, {CornerRadius = UDim.new(0, 6)})
SpeedControl.MouseButton1Click:Connect(function()
    Config.WalkSpeed = Config.WalkSpeed >= 90 and 16 or Config.WalkSpeed + 5
    SpeedControl.Text = "Speed Value: " .. Config.WalkSpeed .. " (Click para sumar +5)"
end)

local StatusText = Create("TextLabel", CombatContainer, {
    Size = UDim2.new(0, 295, 0, 40), BackgroundColor3 = Color3.fromRGB(22, 22, 28),
    TextColor3 = Color3.fromRGB(150, 150, 150), Font = Enum.Font.Gotham, TextSize = 10,
    Text = "Target: None", TextWrapped = true
})
Create("UICorner", StatusText, {CornerRadius = UDim.new(0, 6)})

-- Opciones en ESP Settings
AddToggleOption(ESPContainerFrame, "Player ESP", false, function(state)
    Config.ESP = state
end)

-- Sistema de Pestañas del Sidebar
local function AddTab(name, posY, targetContainer)
    local tab = Create("TextButton", Sidebar, {
        Position = UDim2.new(0.05, 0, 0, posY), Size = UDim2.new(0, 110, 0, 30),
        BackgroundColor3 = Color3.fromRGB(25, 25, 32), TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.GothamBold, TextSize = 10, Text = name
    })
    Create("UICorner", tab, {CornerRadius = UDim.new(0, 5)})
    
    tab.MouseButton1Click:Connect(function()
        CombatContainer.Visible = false
        ESPContainerFrame.Visible = false
        GeneralContainer.Visible = false
        targetContainer.Visible = true
    end)
end

AddTab("⚔️ Combat", 5, CombatContainer)
AddTab("👁️ ESP", 40, ESPContainerFrame)
AddTab("⚙️ General", 75, GeneralContainer)

local ESPs = {}

-- Auto Clicker optimizado
task.spawn(function()
    while true do
        if Config.AutoClicker then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end)
        end
        task.wait(0.12)
    end
end)

-- Bucle Principal Optimizado
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if hum then
        if Config.Speed then hum.WalkSpeed = Config.WalkSpeed end
        if Config.JumpEnabled then
            hum.JumpPower = Config.JumpPower
        else
            hum.JumpPower = 50
        end
    end

    -- Water Walk optimizado
    if Config.WaterWalk and root then
        pcall(function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("water") or v.Material == Enum.Material.Water) then
                    local pos = v.Position
                    if math.abs(root.Position.X - pos.X) < v.Size.X / 2 and math.abs(root.Position.Z - pos.Z) < v.Size.Z / 2 then
                        if root.Position.Y < pos.Y + v.Size.Y / 2 then
                            root.CFrame = CFrame.new(root.Position.X, pos.Y + v.Size.Y / 2 + 3, root.Position.Z)
                            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                        end
                    end
                end
            end
        end)
    end

    -- Auto Farm Bounty optimizado
    if Config.AutoBounty and root then
        pcall(function()
            local targetValid = false
            if Config.BountyTarget and Config.BountyTarget.Parent then
                local tHum = Config.BountyTarget.Parent:FindFirstChildOfClass("Humanoid")
                if tHum and tHum.Health > 0 then
                    targetValid = true
                end
            end

            if not targetValid then
                Config.BountyTarget = nil
                local closestPlayer, shortestDist = nil, math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local pHum = p.Character:FindFirstChildOfClass("Humanoid")
                        if pHum and pHum.Health > 0 then
                            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestPlayer = p.Character.HumanoidRootPart
                            end
                        end
                    end
                end
                Config.BountyTarget = closestPlayer
            end

            if Config.BountyTarget then
                root.CFrame = CFrame.new(Config.BountyTarget.Position + Vector3.new(0, 3, 3), Config.BountyTarget.Position)
            end
        end)
    end

    -- Aimbot Lock intacto
    if Config.Aimbot then
        pcall(function()
            local targetValid = false
            if Config.Target and Config.Target.Parent then
                local targetHum = Config.Target.Parent:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    targetValid = true
                end
            end

            if not targetValid then
                Config.Target = nil
                local closest, dist = nil, Config.FOV
                local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local h = p.Character:FindFirstChildOfClass("Humanoid")
                        local part = p.Character.HumanoidRootPart
                        if h and h.Health > 0 then
                            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                                if d < dist then dist, closest = d, part end
                            end
                        end
                    end
                end
                Config.Target = closest
            end
            
            if Config.Target then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Config.Target.Position), math.clamp(15 * dt, 0, 1))
            end
        end)
    end

    -- Línea Roja (Target Tracer) apuntando exactamente al pecho (HumanoidRootPart)
    if Config.Tracer and Config.Target and Config.Target.Parent then
        pcall(function()
            local targetPos, onScreen = Camera:WorldToViewportPoint(Config.Target.Position)
            if onScreen then
                local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local endPos = Vector2.new(targetPos.X, targetPos.Y)
                
                local distance = (endPos - startPos).Magnitude
                TracerLine.Size = UDim2.new(0, distance, 0, 2)
                TracerLine.Position = UDim2.new(0, (startPos.X + endPos.X) / 2 - distance / 2, 0, (startPos.Y + endPos.Y) / 2 - 1)
                TracerLine.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X))
                TracerLine.Visible = true
            else
                TracerLine.Visible = false
            end
        end)
    else
        TracerLine.Visible = false
    end

    -- ESP optimizado
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            pcall(function()
                local pChar = p.Character
                local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
                local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
                
                if Config.ESP and pRoot and pHum and pHum.Health > 0 and root then
                    if not ESPs[p] then
                        local bg = Create("BillboardGui", PlayerGui, {Name = "GreaferESP", AlwaysOnTop = true, Size = UDim2.new(0,100,0,30), StudsOffset = Vector3.new(0,2.5,0)})
                        ESPs[p] = Create("TextLabel", bg, {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 75, 75), Font = Enum.Font.GothamBold, TextSize = 10})
                    end
                    ESPs[p].Parent.Adornee = pRoot
                    local dist = math.floor((root.Position - pRoot.Position).Magnitude)
                    ESPs[p].Text = p.Name .. " [" .. math.floor(pHum.Health) .. "HP] " .. dist .. "m"
                elseif ESPs[p] then
                    ESPs[p].Parent:Destroy()
                    ESPs[p] = nil
                end
            end)
        end
    end
    
    local tName = (Config.Target and Config.Target.Parent) and Config.Target.Parent.Name or "None"
    StatusText.Text = "Target Lock: " .. tName .. "\nSpeed: " .. Config.WalkSpeed .. " | Jump: " .. Config.JumpPower
end)
