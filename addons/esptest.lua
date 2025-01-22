local esplibrary = {}
esplibrary.settings = {}

-- Default settings for ESP components
esplibrary.settings.box = {
    enabled = true,
    outline = true,
    color = Color3.fromRGB(255, 255, 255),
    outlineColor = Color3.fromRGB(0, 0, 0)
}

esplibrary.settings.tracer = {
    enabled = true,
    color = Color3.fromRGB(255, 255, 255)
}

esplibrary.settings.healthbar = {
    enabled = false,
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

-- Utility function to get the distance between the local player and a target
local function getDistanceToTarget(target)
    local player = game.Players.LocalPlayer
    local targetPosition = target.HumanoidRootPart.Position
    local playerPosition = player.Character.HumanoidRootPart.Position
    return (targetPosition - playerPosition).Magnitude
end

-- Method to create ESP for a target
function esplibrary:createESP(target)
    -- Ensure the target has a HumanoidRootPart (if it's a model or player)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end

    -- Create drawing elements
    local box = Drawing.new("Square")
    local outline = Drawing.new("Square")  -- This will be our outline
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

    -- Outline settings (we'll make it slightly larger than the box)
    outline.Visible = false
    outline.Transparency = 1
    outline.Thickness = 2
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
        -- Get 2D screen position of the target
        local screenPosition, onScreen = workspace.CurrentCamera:WorldToScreenPoint(target.HumanoidRootPart.Position)
        if not onScreen then
            -- If the target is off-screen, do not draw
            box.Visible = false
            outline.Visible = false
            tracer.Visible = false
            healthbar.Visible = false
            usernameText.Visible = false
            distanceText.Visible = false
            return
        end

        -- Calculate the bounding box size based on the part's size
        local size = target.HumanoidRootPart.Size  -- Get the size of the part (HumanoidRootPart in this case)
        local screenPosition, _ = workspace.CurrentCamera:WorldToScreenPoint(target.HumanoidRootPart.Position)
        local position = Vector2.new(screenPosition.X - size.X / 2, screenPosition.Y - size.Y / 2)

        -- Box
        if esplibrary.settings.box.enabled then
            box.Visible = true
            box.Size = Vector2.new(size.X, size.Y)  -- Adjust box size to part's size
            box.Position = position
            box.Color = esplibrary.settings.box.color

            -- Outline (placed just below the box)
            if esplibrary.settings.box.outline then
                outline.Visible = true
                outline.Size = Vector2.new(size.X + 2, size.Y + 2)  -- Make the outline 2 pixels bigger
                outline.Position = position - Vector2.new(2, 2)  -- Shift the outline to create the effect
                outline.Color = esplibrary.settings.box.outlineColor
            else
                outline.Visible = false
            end
        else
            box.Visible = false
            outline.Visible = false
        end

        -- Tracer
        if esplibrary.settings.tracer.enabled then
            tracer.Visible = true
            tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)  -- Player's screen center
            tracer.To = Vector2.new(screenPosition.X, screenPosition.Y)
            tracer.Color = esplibrary.settings.tracer.color
        else
            tracer.Visible = false
        end

        -- Healthbar
        if esplibrary.settings.healthbar.enabled then
            local healthHeight = 50  -- Example size, this can be adjusted to be based on health
            local healthPosition = Vector2.new(screenPosition.X + size.X / 2 + 10, screenPosition.Y)

            healthbar.Visible = true
            healthbar.From = healthPosition
            healthbar.To = healthPosition + Vector2.new(0, -healthHeight)
            healthbar.Color = esplibrary.settings.healthbar.color
        else
            healthbar.Visible = false
        end

        -- Username text
        if esplibrary.settings.text.enabled then
            usernameText.Visible = true
            usernameText.Position = Vector2.new(screenPosition.X, screenPosition.Y - size.Y / 2 - 10)
            usernameText.Text = target.Name
            usernameText.Color = esplibrary.settings.text.color
        else
            usernameText.Visible = false
        end

        -- Distance text
        if esplibrary.settings.distance.enabled then
            local distance = math.floor(getDistanceToTarget(target))
            distanceText.Visible = true
            distanceText.Position = Vector2.new(screenPosition.X, screenPosition.Y + size.Y / 2 + 10)
            distanceText.Text = tostring(distance) .. "m"
            distanceText.Color = esplibrary.settings.distance.color
        else
            distanceText.Visible = false
        end
    end)
end
