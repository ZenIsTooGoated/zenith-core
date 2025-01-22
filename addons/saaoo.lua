local espLibrary = {}
espLibrary.settings = {}

-- Add some basic settings for visibility, color, etc.
espLibrary.settings.box = {
    enabled = true,
    color = Color3.fromRGB(255, 255, 255),
    outline = true,
    outlineColor = Color3.fromRGB(0, 0, 0)
}

espLibrary.settings.tracer = {
    enabled = true,
    color = Color3.fromRGB(255, 255, 255)
}

espLibrary.settings.healthbar = {
    enabled = true,
    color = Color3.fromRGB(0, 255, 0)
}

espLibrary.settings.text = {
    enabled = true,
    color = Color3.fromRGB(255, 255, 255)
}

espLibrary.settings.distance = {
    enabled = true,
    color = Color3.fromRGB(255, 255, 255)
}

-- Function to get the distance between the local player and a target
local function getDistanceToTarget(target)
    local player = game.Players.LocalPlayer
    local targetPosition = target.HumanoidRootPart.Position
    local playerPosition = player.Character.HumanoidRootPart.Position
    return (targetPosition - playerPosition).Magnitude
end

-- Get the Camera object
local camera = workspace.CurrentCamera

function espLibrary:createEsp(target)
    -- Ensure the target has a HumanoidRootPart
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    -- Create drawing elements
    local box = Drawing.new("Square")
    local outline = Drawing.new("Square")
    local tracer = Drawing.new("Line")
    local healthbar = Drawing.new("Line")
    local usernameText = Drawing.new("Text")
    local distanceText = Drawing.new("Text")
    
    -- Box settings
    box.Visible = false
    box.Transparency = 1
    box.Thickness = 2
    box.Filled = false
    box.Color = espLibrary.settings.box.color

    -- Outline settings
    outline.Visible = false
    outline.Transparency = 1
    outline.Thickness = 3
    outline.Filled = false
    outline.Color = espLibrary.settings.box.outlineColor

    -- Tracer settings
    tracer.Visible = false
    tracer.Transparency = 1
    tracer.Thickness = 2
    tracer.From = Vector2.new(0, 0)
    tracer.To = Vector2.new(0, 0)
    tracer.Color = espLibrary.settings.tracer.color

    -- Healthbar settings
    healthbar.Visible = false
    healthbar.Transparency = 1
    healthbar.Thickness = 4
    healthbar.From = Vector2.new(0, 0)
    healthbar.To = Vector2.new(0, 0)
    healthbar.Color = espLibrary.settings.healthbar.color

    -- Username settings
    usernameText.Visible = false
    usernameText.Transparency = 1
    usernameText.Size = 14
    usernameText.Color = espLibrary.settings.text.color
    usernameText.Center = true
    usernameText.Outline = true
    usernameText.OutlineColor = Color3.fromRGB(0, 0, 0)

    -- Distance settings
    distanceText.Visible = false
    distanceText.Transparency = 1
    distanceText.Size = 14
    distanceText.Color = espLibrary.settings.distance.color
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.OutlineColor = Color3.fromRGB(0, 0, 0)

    -- Update function to continuously update ESP
    game:GetService("RunService").RenderStepped:Connect(function()
        -- Dimensions array includes all the major body parts (head, arms, legs, torso, etc.)
        local dimensions = { 
            target.HumanoidRootPart, target.Head, target["Left Arm"], target["Right Arm"], 
            target["Left Leg"], target["Right Leg"], target["UpperTorso"], target["LowerTorso"] 
        }
        
        -- Variables to track min/max screen coordinates
        local yMinimal, yMaximal = camera.ViewportSize.Y, 0
        local xMinimal, xMaximal = camera.ViewportSize.X, 0

        -- Loop through each part and calculate the min/max screen position
        for _, part in pairs(dimensions) do
            if part and part:FindFirstChild("HumanoidRootPart") then
                local screenPos = camera:WorldToViewportPoint(part.Position)
                local x, y = screenPos.X, screenPos.Y
                if x < xMinimal then 
                    xMinimal = x
                end
                if x > xMaximal then 
                    xMaximal = x
                end
                if y < yMinimal then 
                    yMinimal = y
                end
                if y > yMaximal then
                    yMaximal = y
                end
            end
        end

        -- Calculate the box size based on min/max values
        local boxSize = Vector2.new(xMaximal - xMinimal, yMaximal - yMinimal)
        local boxPosition = Vector2.new(xMinimal, yMinimal)

        -- If the target is off-screen, hide the ESP elements
        if xMinimal == camera.ViewportSize.X or xMaximal == 0 or yMinimal == camera.ViewportSize.Y or yMaximal == 0 then
            box.Visible = false
            outline.Visible = false
            tracer.Visible = false
            healthbar.Visible = false
            usernameText.Visible = false
            distanceText.Visible = false
            return
        end

        -- Box visibility and size update
        if espLibrary.settings.box.enabled then
            if espLibrary.settings.box.outline then
                outline.Visible = true
                outline.Size = boxSize
                outline.Position = boxPosition
                outline.Color = espLibrary.settings.box.outlineColor
            else
                outline.Visible = false
            end

            box.Visible = true
            box.Size = boxSize
            box.Position = boxPosition
        else
            box.Visible = false
            outline.Visible = false
        end

        -- Tracer
        if espLibrary.settings.tracer.enabled then
            tracer.Visible = true
            tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
            tracer.To = boxPosition + boxSize / 2
            tracer.Color = espLibrary.settings.tracer.color
        else
            tracer.Visible = false
        end

        -- Username text
        if espLibrary.settings.text.enabled then
            usernameText.Visible = true
            usernameText.Position = boxPosition - Vector2.new(0, 20)
            usernameText.Text = target.Name
            usernameText.Color = espLibrary.settings.text.color
        else
            usernameText.Visible = false
        end

        -- Distance text
        if espLibrary.settings.distance.enabled then
            local distance = math.floor(getDistanceToTarget(target))
            distanceText.Visible = true
            distanceText.Position = boxPosition + boxSize + Vector2.new(0, 10)
            distanceText.Text = tostring(distance) .. "m"
            distanceText.Color = espLibrary.settings.distance.color
        else
            distanceText.Visible = false
        end
    end)
end

return espLibrary
