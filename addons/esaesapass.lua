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

-- Function to create and return a drawing for box (outline and size based on character)
local function createBox(position, size)
    -- Outline box (larger than the filled box)
    local boxOutline = Drawing.new("Square")
    boxOutline.Position = position
    boxOutline.Size = size + Vector2.new(10, 10)  -- Making the outline slightly bigger
    boxOutline.Color = Color3.fromRGB(255, 255, 255)  -- White outline color
    boxOutline.Filled = false
    boxOutline.OutlineColor = Color3.fromRGB(0, 0, 0)  -- Black outline color
    
    -- Regular box (filled)
    local box = Drawing.new("Square")
    box.Position = position
    box.Size = size
    box.Color = Color3.fromRGB(0, 255, 0)  -- You can change this color
    box.Filled = false  -- No fill
    box.Outline = false

    return boxOutline, box
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

    -- Creating ESP elements for the player
    local nameText, distanceText, tracer, boxOutline, box

    if EspLib.settings.name then
        nameText = createText(player.Name)
        table.insert(espElements, nameText)
    end

    if EspLib.settings.distance then
        distanceText = createText(math.floor((rootPart.Position - Camera.CFrame.Position).Magnitude) .. " studs")
        table.insert(espElements, distanceText)
    end

    -- Tracer
    if EspLib.settings.tracers then
        tracer = createTracer(Camera:WorldToViewportPoint(Camera.CFrame.Position), Camera:WorldToViewportPoint(rootPart.Position))
        table.insert(espElements, tracer)
    end

    -- Box (both outline and regular box)
    if EspLib.settings.box then
        boxOutline, box = createBox(Vector2.new(0, 0), Vector2.new(50, 100))  -- Example size
        table.insert(espElements, boxOutline)
        table.insert(espElements, box)
    end

    -- Debugging option: Print details
    if EspLib.settings.debug then
        print("ESP Created for " .. player.Name)
        print("Position: " .. tostring(rootPart.Position))
        print("Number of ESP elements: " .. #espElements)
    end

    -- Update ESP elements every frame
    local espConnection
    espConnection = RunService.RenderStepped:Connect(function()
        -- Make sure the character still exists
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            -- Clean up ESP elements if character is destroyed
            for _, element in ipairs(espElements) do
                if element and element.Remove then
                    element:Remove()
                end
            end
            espConnection:Disconnect()
            return
        end
        
        local screenPos = getScreenPosition(rootPart.Position)
        
        if EspLib.settings.debug then
            print("Updating ESP elements for " .. player.Name)
        end

        if screenPos then
            -- Update position for each element
            if EspLib.settings.name then
                nameText.Position = screenPos + Vector2.new(0, -40)  -- Adjust Y position for spacing
            end

            if EspLib.settings.distance then
                distanceText.Position = screenPos + Vector2.new(0, 20)  -- Adjust Y position for spacing
            end

            -- Update tracer
            if EspLib.settings.tracers then
                tracer.From = Camera:WorldToViewportPoint(Camera.CFrame.Position)
                tracer.To = Camera:WorldToViewportPoint(rootPart.Position)
            end

            -- Update box (both outline and regular box)
            if EspLib.settings.box then
                boxOutline.Position = screenPos + Vector2.new(-25, -50)  -- Adjust position around the player
                box.Position = screenPos + Vector2.new(-25, -50)  -- Same position as outline, but filled
            end

            -- Make sure the ESP elements are visible
            for _, element in ipairs(espElements) do
                element.Visible = true
            end
        else
            -- Hide all ESP elements if the player is off-screen
            for _, element in ipairs(espElements) do
                element.Visible = false
            end
        end
    end)

    -- Handle player character cleanup (when character is removed or player leaves)
    player.CharacterRemoving:Connect(function()
        for _, element in ipairs(espElements) do
            if element and element.Remove then
                element:Remove()
            end
        end
        espConnection:Disconnect()
    end)

    -- Handle player removal (in case player leaves the game)
    player.Removing:Connect(function()
        for _, element in ipairs(espElements) do
            if element and element.Remove then
                element:Remove()
            end
        end
    end)
end

-- Return the module
return EspLib
