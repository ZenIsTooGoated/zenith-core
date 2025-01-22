local espLib = {}
espLib.settings = {
    box = true,
    name = true,
    distance = true,
    tracers = true,
    outlines = true,
    font = Drawing.Fonts.Plex,
    debug = false
}

-- | Utility Functions
local function createDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, value in pairs(properties) do
        drawing[prop] = value
    end
    return drawing
end

local function worldToViewportPoint(position)
    local camera = workspace.CurrentCamera
    local viewportPoint, onScreen = camera:WorldToViewportPoint(position)
    return Vector2.new(viewportPoint.X, viewportPoint.Y), onScreen
end

-- | Debug Log
local function debugLog(message)
    if espLib.settings.debug then
        print(message)
    end
end

-- | ESP Creation Function
function espLib.createEsp(target)
    local espObjects = {}

    -- Main ESP Elements
    espObjects.name = createDrawing("Text", {
        Color = Color3.new(1, 1, 1),
        Size = 18,
        Font = espLib.settings.font,
        Outline = espLib.settings.outlines,
        Visible = false,
    })

    espObjects.box = createDrawing("Square", {
        Thickness = 1,
        Color = Color3.new(1, 1, 1),
        Filled = false,
        Visible = false,
    })

    espObjects.boxOutline = createDrawing("Square", {
        Thickness = 2,
        Color = Color3.new(0, 0, 0),
        Filled = false,
        Visible = false,
    })

    espObjects.distance = createDrawing("Text", {
        Color = Color3.new(1, 1, 1),
        Size = 18,
        Font = espLib.settings.font,
        Outline = espLib.settings.outlines,
        Visible = false,
    })

    espObjects.tracer = createDrawing("Line", {
        Thickness = 1,
        Color = Color3.new(1, 1, 1),
        Visible = false,
    })

    -- Individual On-Screen Checks
    local function isOnScreen(position)
        local _, onScreen = workspace.CurrentCamera:WorldToViewportPoint(position)
        return onScreen
    end

    function espObjects:updateEsp()
        if not target or not target:IsDescendantOf(workspace) then
            debugLog("Target no longer exists or is not in workspace.")
            self:removeEsp()
            return
        end

        -- Check if the target is a Model or a BasePart
        local part
        if target:IsA("BasePart") then
            part = target
        elseif target:IsA("Model") then
            part = target:FindFirstChildOfClass("BasePart")
        end

        if part then
            local screenPos, onScreen = worldToViewportPoint(part.Position)

            -- Debug: Check if part is on screen
            debugLog("Part Position: " .. tostring(part.Position) .. ", ScreenPos: " .. tostring(screenPos) .. ", OnScreen: " .. tostring(onScreen))

            -- Update Name
            if espLib.settings.name then
                local nameOnScreen = isOnScreen(part.Position + Vector3.new(0, 5, 0))
                self.name.Text = target.Name
                self.name.Position = screenPos - Vector2.new(self.name.TextBounds.X / 2, 50)
                self.name.Visible = nameOnScreen
            else
                self.name.Visible = false
            end

            -- Update Box and Outline
            if espLib.settings.box then
                local boxSize = Vector2.new(50, 100) -- Adjust box size as needed
                local boxPos = screenPos - boxSize / 2
                local boxOnScreen = isOnScreen(part.Position)

                -- Box visible first, then outline
                self.box.Size = boxSize
                self.box.Position = boxPos
                self.box.Visible = boxOnScreen

                if espLib.settings.outlines then
                    self.boxOutline.Size = boxSize
                    self.boxOutline.Position = boxPos
                    self.boxOutline.Visible = boxOnScreen
                else
                    self.boxOutline.Visible = false
                end
            else
                self.box.Visible = false
                self.boxOutline.Visible = false
            end

            -- Update Distance
            if espLib.settings.distance then
                local distance = (workspace.CurrentCamera.CFrame.Position - part.Position).Magnitude
                local distanceOnScreen = isOnScreen(part.Position)
                self.distance.Text = string.format("%.0f studs", distance)
                self.distance.Position = screenPos + Vector2.new(-self.distance.TextBounds.X / 2, 60)
                self.distance.Visible = distanceOnScreen
            else
                self.distance.Visible = false
            end

            -- Update Tracer
            if espLib.settings.tracers then
                local tracerOnScreen = isOnScreen(part.Position)
                self.tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                self.tracer.To = screenPos
                self.tracer.Visible = tracerOnScreen
            else
                self.tracer.Visible = false
            end
        else
            self:removeEsp()
        end
    end

    function espObjects:removeEsp()
        for _, object in pairs(self) do
            if typeof(object) == "Instance" then
                object:Remove()
            end
        end
    end

    return espObjects
end


return espLib



