local EspLib = {}
EspLib.__index = EspLib

-- | SETTINGS

EspLib.settings = {
    box = true,               -- Enable box
    name = true,              -- Enable name display
    distance = true,          -- Enable distance display
    tracers = true,           -- Enable tracers to the player
    outlines = false,         -- Disable outlines
    debug = false,            -- Enable debugging (prints ESP status)
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

-- Function to calculate corners of the bounding box around a character
local function calculateCorners(cframe, size)
    local VERTICES = {
        Vector3.new(-0.5, -0.5, -0.5),
        Vector3.new(0.5, -0.5, -0.5),
        Vector3.new(-0.5, -0.5, 0.5),
        Vector3.new(0.5, -0.5, 0.5),
        Vector3.new(-0.5, 0.5, -0.5),
        Vector3.new(0.5, 0.5, -0.5),
        Vector3.new(-0.5, 0.5, 0.5),
        Vector3.new(0.5, 0.5, 0.5)
    }
    local corners = {}
    for i = 1, #VERTICES do
        corners[i] = Camera:WorldToViewportPoint(cframe:PointToWorldSpace(VERTICES[i] * size))
    end

    local min = Vector2.new(math.huge, math.huge)
    local max = Vector2.new(-math.huge, -math.huge)

    for _, corner in ipairs(corners) do
        min = Vector2.new(math.min(min.X, corner.X), math.min(min.Y, corner.Y))
        max = Vector2.new(math.max(max.X, corner.X), math.max(max.Y, corner.Y))
    end

    return {topLeft = min, bottomRight = max}
end

-- Function to create and return a drawing for box (only box, no outline)
local function createBox(position, size)
    -- Regular box (filled)
    local box = Drawing.new("Square")
    box.Position = position
    box.Size = size
    box.Color = Color3.fromRGB(0, 255, 0)  -- You can change this color
    box.Filled = false  -- No fill
    box.Outline = false

    return box
end

-- | ESP HANDLER

function EspLib:createEsp(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = char:WaitForChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")

    local espElements = {}

    if EspLib.settings.name then
        local nameText = createText(player.Name)
        table.insert(espElements, nameText)
    end

    if EspLib.settings.distance then
        local distanceText = createText(math.floor((rootPart.Position - Camera.CFrame.Position).Magnitude) .. " studs")
        distanceText.Position = Vector2.new(0, 20)
        table.insert(espElements, distanceText)
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
        local box = Drawing.new("Square")
        box.Color = Color3.fromRGB(255, 255, 255)
        box.Filled = false
        box.Outline = false
        table.insert(espElements, box)
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

            -- Update box size and position
            if EspLib.settings.box then
                local boundingBox = calculateCorners(rootPart.CFrame, char.HumanoidRootPart.Size)
                local box = espElements[4]  -- Box is the 4th element
                box.Position = boundingBox.topLeft
                box.Size = boundingBox.bottomRight - boundingBox.topLeft
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
