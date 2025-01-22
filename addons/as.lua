local esplibrary = {}
esplibrary.settings = {}

-- Add some basic settings for visibility, color, etc.
esplibrary.settings.box = {
    enabled = true,
    color = Color3.fromRGB(255, 255, 255),
    outline = true,
    outlineColor = Color3.fromRGB(0, 0, 0)
}

esplibrary.settings.tracer = {
    enabled = true,
    color = Color3.fromRGB(255, 255, 255)
}

esplibrary.settings.healthbar = {
    enabled = true,
    color = Color3.fromRGB(0, 255, 0)
}

esplibrary.settings.text = {
    enabled = true,
    color = Color3.fromRGB(255, 255, 255)
}

esplibrary.settings.distance = {
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
local Camera = workspace.CurrentCamera

function esplibrary:createESP(target)
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
    box.Color = esplibrary.settings.box.color

    -- Outline settings
    outline.Visible = false
    outline.Transparency = 1
    outline.Thickness = 3
    outline.Filled = false
    outline.Color = esplibrary.settings.box.outlineColor

    -- Tracer settings
    tracer.Visible = false
    tracer.Transparency = 1
    tracer.Thickness = 2
    tracer.From = Vector2.new(0, 0)
    tracer.To = Vector2.new(0, 0)
    tracer.Color = esplibrary.settings.tracer.color

    -- Healthbar settings
    healthbar.Visible = false
    healthbar.Transparency = 1
    healthbar.Thickness = 4
    healthbar.From = Vector2.new(0, 0)
    healthbar.To = Vector2.new(0, 0)
    healthbar.Color = esplibrary.settings.healthbar.color

    -- Username settings
    usernameText.Visible = false
    usernameText.Transparency = 1
    usernameText.Size = 14
    usernameText.Color = esplibrary.settings.text.color
    usernameText.Center = true
    usernameText.Outline = true
    usernameText.OutlineColor = Color3.fromRGB(0, 0, 0)

    -- Distance settings
    distanceText.Visible = false
    distanceText.Transparency = 1
    distanceText.Size = 14
    distanceText.Color = esplibrary.settings.distance.color
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.OutlineColor = Color3.fromRGB(0, 0, 0)

    -- Update function to continuously update ESP
    game:GetService("RunService").RenderStepped:Connect(function()
      
        
        
        local Dimensions = { target.HumanoidRootPart, target.Head, target["Left Arm"], target["Right Arm"], target["Left Leg"], target["Right Leg"] } -- Parts we are using to calculate the bounds
        
        local Y_Minimal, Y_Maximal = Camera.ViewportSize.Y, 0
        local X_Minimal, X_Maximal = Camera.ViewportSize.X, 0

        -- Loop through each part and calculate the min/max screen position
        for _, part in pairs(Dimensions) do
            local screenPos = Camera:WorldToViewportPoint(part.Position)
            local X, Y = screenPos.X, screenPos.Y
            if X < X_Minimal then 
                X_Minimal = X
            end
            if X > X_Maximal then 
                X_Maximal = X
            end
            if Y < Y_Minimal then 
                Y_Minimal = Y
            end
            if Y > Y_Maximal then
                Y_Maximal = Y
            end
        end

        -- Calculate the box size based on min/max values
        local boxSize = Vector2.new(X_Maximal - X_Minimal, Y_Maximal - Y_Minimal)
        local boxPosition = Vector2.new(X_Minimal, Y_Minimal)

        -- If the target is off-screen, hide the ESP elements
        if X_Minimal == Camera.ViewportSize.X or X_Maximal == 0 or Y_Minimal == Camera.ViewportSize.Y or Y_Maximal == 0 then
            box.Visible = false
            outline.Visible = false
            tracer.Visible = false
            healthbar.Visible = false
            usernameText.Visible = false
            distanceText.Visible = false
            return
        end

        -- Box visibility and size update
        if esplibrary.settings.box.enabled then
           

            if esplibrary.settings.box.outline then
                outline.Visible = true
                outline.Size = boxSize
                outline.Position = boxPosition
                outline.Color = esplibrary.settings.box.outlineColor
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
        if esplibrary.settings.tracer.enabled then
            tracer.Visible = true
            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            tracer.To = boxPosition + boxSize / 2
            tracer.Color = esplibrary.settings.tracer.color
        else
            tracer.Visible = false
        end

        -- Username text
        if esplibrary.settings.text.enabled then
            usernameText.Visible = true
            usernameText.Position = boxPosition - Vector2.new(0, 20)
            usernameText.Text = target.Name
            usernameText.Color = esplibrary.settings.text.color
        else
            usernameText.Visible = false
        end

        -- Distance text
        if esplibrary.settings.distance.enabled then
            local distance = math.floor(getDistanceToTarget(target))
            distanceText.Visible = true
            distanceText.Position = boxPosition + boxSize + Vector2.new(0, 10)
            distanceText.Text = tostring(distance) .. "m"
            distanceText.Color = esplibrary.settings.distance.color
        else
            distanceText.Visible = false
        end
    end)
end

return esplibrary
