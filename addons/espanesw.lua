local EspLib = {}
EspLib.__index = EspLib

-- | SETTINGS

EspLib.settings = {
    box = true,               -- Enable box
    name = true,              -- Enable name display
    distance = true,          -- Enable distance display
    tracers = true,           -- Enable tracers to the player
    outlines = true,          -- Enable outlines for all ESP elements
}

-- | SERVICES

local Players = game.Players
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- | UTILITY FUNCTIONS

-- World to screen conversion function
local function worldToScreen(world)
    local screenPosition, inBounds = Camera:WorldToViewportPoint(world)
    return Vector2.new(screenPosition.X, screenPosition.Y), inBounds, screenPosition.Z
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

-- | VARIABLES (from your original source)
local min2 = Vector2.zero.Min
local max2 = Vector2.zero.Max
local min3 = Vector3.zero.Min
local max3 = Vector3.zero.Max
local vertices = {
    Vector3.new(-1, -1, -1),
    Vector3.new(-1, 1, -1),
    Vector3.new(-1, 1, 1),
    Vector3.new(-1, -1, 1),
    Vector3.new(1, -1, -1),
    Vector3.new(1, 1, -1),
    Vector3.new(1, 1, 1),
    Vector3.new(1, -1, 1)
}

-- Function to calculate the corners of a box from CFrame and Size
local function calculateCorners(cframe, size)
    local corners = {}
    for i = 1, #vertices do
        corners[i] = worldToScreen((cframe + size * 0.5 * vertices[i]).Position)
    end

    local min = min2(viewportSize, unpack(corners))
    local max = max2(Vector2.zero, unpack(corners))
    return {
        corners = corners,
        topLeft = Vector2.new(floor(min.X), floor(min.Y)),
        topRight = Vector2.new(floor(max.X), floor(min.Y)),
        bottomLeft = Vector2.new(floor(min.X), floor(max.Y)),
        bottomRight = Vector2.new(floor(max.X), floor(max.Y))
    }
end

-- Function to get bounding box size for the entire character
local function getBoundingBox(parts)
    local min, max
    for i = 1, #parts do
        local part = parts[i]
        if part:IsA("BasePart") then
            local cframe, size = part.CFrame, part.Size
            min = min3(min or cframe.Position, (cframe - size * 0.5).Position)
            max = max3(max or cframe.Position, (cframe + size * 0.5).Position)
        end
    end

    local center = (min + max) * 0.5
    local front = Vector3.new(center.X, center.Y, max.Z)
    return CFrame.new(center, front), max - min
end

-- | ESP HANDLER

function EspLib:createEsp(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = char:WaitForChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local espElements = {}

    -- Add name text
    if EspLib.settings.name then
        local nameText = createText(player.Name)
        nameText.Position = Vector2.new(0, -20)
        table.insert(espElements, nameText)
    end

    -- Add distance text
    if EspLib.settings.distance then
        local distanceText = createText(math.floor((rootPart.Position - Camera.CFrame.Position).Magnitude) .. " studs")
        distanceText.Position = Vector2.new(0, 20)
        table.insert(espElements, distanceText)
    end

    -- Add tracers
    if EspLib.settings.tracers then
        local tracer = Drawing.new("Line")
        tracer.From = Camera:WorldToViewportPoint(Camera.CFrame.Position)
        tracer.To = Camera:WorldToViewportPoint(rootPart.Position)
        tracer.Color = Color3.fromRGB(255, 255, 255)
        tracer.Thickness = 1
        table.insert(espElements, tracer)
    end

    -- Add box
    if EspLib.settings.box then
        local box = Drawing.new("Square")
        box.Color = Color3.fromRGB(255, 255, 255)
        box.Outline = true
        box.OutlineColor = Color3.fromRGB(0, 0, 0)
        box.Filled = false
        table.insert(espElements, box)
    end

    -- Update ESP elements every frame
    RunService.RenderStepped:Connect(function()
        local onScreen = isOnScreen(rootPart.Position)
        local corners, size = calculateCorners(rootPart.CFrame, rootPart.Size)
        
        -- Update the position and size of the box
        if EspLib.settings.box then
            local box = espElements[4]  -- The box drawing element
            box.Position = corners.topLeft
            box.Size = corners.bottomRight - corners.topLeft
        end

        -- Show or hide ESP elements based on on-screen status
        if onScreen then
            for _, element in ipairs(espElements) do
                if element then
                    element.Visible = true
                end
            end
        else
            for _, element in ipairs(espElements) do
                if element then
                    element.Visible = false
                end
            end
        end
    end)
end

-- | CLEANUP HANDLER

-- Listen for when the player is removed and clean up ESP elements
game.Players.PlayerRemoving:Connect(function(player)
    if EspLib[player] then
        -- Destroy all the drawings associated with the player
        for _, element in ipairs(EspLib[player]) do
            if element and element.Remove then
                element:Remove()
            end
        end
        EspLib[player] = nil
    end
end)

-- Return the module
return EspLib
