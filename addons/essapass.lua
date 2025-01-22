local EspLib = {}
EspLib.__index = EspLib

-- | SETTINGS

EspLib.settings = {
    box = true,               -- Enable box
    name = true,              -- Enable name display
    distance = true,          -- Enable distance display
    tracers = true,           -- Enable tracers to the player
    outlines = true,          -- Enable outlines for all ESP elements
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

-- Function to create and return a drawing for box (both filled and outline)
local function createBox(position, size)
    -- Filled box
    local boxFilled = Drawing.new("Square")
    boxFilled.Position = position
    boxFilled.Size = size
    boxFilled.Color = Color3.fromRGB(0, 255, 0)  -- You can change this to any color you want
    boxFilled.Filled = true
    boxFilled.Outline = false  -- No outline for the filled box

    -- Outline box
    local boxOutline = Drawing.new("Square")
    boxOutline.Position = position
    boxOutline.Size = size
    boxOutline.Color = Color3.fromRGB(255, 255, 255)  -- White outline color
    boxOutline.Filled = false
    boxOutline.OutlineColor = Color3.fromRGB(0, 0, 0)  -- Black outline color

    return boxOutline, boxFilled
end

-- Function to create and return a drawing for tracer
local function createTracer(fromPos, toPos)
    local tracer = Drawing.new("Line")
    tracer.From = fromPos
    tracer.To = toPos
    tracer.Color = Color3.fromRGB(255, 255, 255)
    tracer.Thickness = 1
    return tracer
end

-- | ESP HANDLER

function EspLib:createEsp(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = char:WaitForChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local espElements = {}

    -- Position the ESP elements
    local function getScreenPosition(worldPosition)
        local viewportPosition, onScreen = Camera:WorldToViewportPoint(worldPosition)
        if onScreen then
            return Vector2.new(viewportPosition.X, viewportPosition.Y)
        end
        return nil  -- If it's not on screen, return nil
    end

    if EspLib.settings.name then
        local nameText = createText(player.Name)
        local screenPos = getScreenPosition(rootPart.Position)
        if screenPos then
            nameText.Position = screenPos + Vector2.new(0, -40)  -- Adjust Y position for spacing
            table.insert(espElements, nameText)
        end
    end

    if EspLib.settings.distance then
        local distanceText = createText(math.floor((rootPart.Position - Camera.CFrame.Position).Magnitude) .. " studs")
        local screenPos = getScreenPosition(rootPart.Position)
        if screenPos then
            distanceText.Position = screenPos + Vector2.new(0, -20)  -- Adjust Y position for spacing
            table.insert(espElements, distanceText)
        end
    end

    -- Tracer
    if EspLib.settings.tracers then
        local tracer = createTracer(Camera:WorldToViewportPoint(Camera.CFrame.Position), Camera:WorldToViewportPoint(rootPart.Position))
        table.insert(espElements, tracer)
    end

    -- Box (both filled and outline)
    if EspLib.settings.box then
        local screenPos = getScreenPosition(rootPart.Position)
        if screenPos then
            local boxOutline, boxFilled = createBox(screenPos + Vector2.new(-25, -50), Vector2.new(50, 100))  -- Example size and position
            table.insert(espElements, boxOutline)
            table.insert(espElements, boxFilled)
        end
    end

    -- Debugging option: Print details
    if EspLib.settings.debug then
        print("ESP Created for " .. player.Name)
        print("Position: " .. tostring(rootPart.Position))
        print("Number of ESP elements: " .. #espElements)
    end

    -- Update ESP elements every frame
    RunService.RenderStepped:Connect(function()
        if EspLib.settings.debug then
            print("Updating ESP elements for " .. player.Name)
        end

        for _, element in ipairs(espElements) do
            if element then
                element.Visible = true
            end
        end
    end)
end


-- Return the module
return EspLib
