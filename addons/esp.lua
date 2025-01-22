local EspLib = {}
EspLib.__index = EspLib

-- | SETTINGS

EspLib.settings = {
    box = true,               -- Enable box
    name = true,              -- Enable name display
    distance = true,          -- Enable distance display
    health = true,            -- Enable health bar
    tracers = true,           -- Enable tracers to the player
    outlines = true,          -- Enable outlines for all ESP elements
}

-- | SERVICES

local Players = game.Players
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- | UTILITY FUNCTIONS

-- Function to check if a position is on screen
local function isOnScreen(position)
    local viewportPosition, onScreen = Camera:WorldToViewportPoint(position)
    return onScreen
end

-- Function to create and return a drawing for text
local function createText(label)
    local text = Drawing.new("Text")
    text.Text = label
    text.Font = Drawing.Fonts.Plex
    text.Size = 15
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0)
    return text
end

-- Function to create and return a drawing for health bar
local function createHealthBar(position, health)
    local healthBar = Drawing.new("Rectangle")
    healthBar.Position = position
    healthBar.Size = Vector2.new(10, 50)
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Outline = EspLib.settings.outlines
    healthBar.OutlineColor = Color3.fromRGB(0, 0, 0)
    healthBar.Filled = true
    healthBar.Size = Vector2.new(10, health)
    return healthBar
end

-- | ESP HANDLER

function EspLib:createEsp(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = char:WaitForChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")

    local espElements = {}

    -- Name
    if EspLib.settings.name then
        local nameText = createText(player.Name)
        table.insert(espElements, nameText)
    end

    -- Distance
    if EspLib.settings.distance then
        local distanceText = createText(math.floor((rootPart.Position - Camera.CFrame.Position).Magnitude) .. " studs")
        distanceText.Position = Vector2.new(0, 20)
        table.insert(espElements, distanceText)
    end

    -- Health Bar
    if EspLib.settings.health then
        local healthBar = createHealthBar(Vector2.new(0, 40), math.clamp(char:FindFirstChildOfClass("Humanoid").Health / 100 * 50, 0, 50))
        table.insert(espElements, healthBar)
    end

    -- Tracer
    if EspLib.settings.tracers then
        local tracer = Drawing.new("Line")
        tracer.From = Camera:WorldToViewportPoint(Camera.CFrame.Position)
        tracer.To = Camera:WorldToViewportPoint(rootPart.Position)
        tracer.Color = Color3.fromRGB(255, 255, 255)
        tracer.Thickness = 1
        table.insert(espElements, tracer)
    end

    -- Box
    if EspLib.settings.box then
        local boxOutline = Drawing.new("Rectangle")
        boxOutline.Color = Color3.fromRGB(255, 255, 255)
        boxOutline.Outline = true
        boxOutline.OutlineColor = Color3.fromRGB(0, 0, 0)
        boxOutline.Filled = false
        table.insert(espElements, boxOutline)
    end

    -- Update ESP elements every frame
    RunService.RenderStepped:Connect(function()
        local onScreen = isOnScreen(rootPart.Position)
        if onScreen then
            for _, element in ipairs(espElements) do
                if element and element.Remove then
                    element.Visible = true
                end
            end
        else
            for _, element in ipairs(espElements) do
                if element and element.Remove then
                    element.Visible = false
                end
            end
        end
    end)
end

-- Return the module
return EspLib
