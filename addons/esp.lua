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

    -- | Update ESP for Target
    function espObjects:updateEsp()
        if not target or not target:IsDescendantOf(workspace) then
            self:removeEsp()
            return
        end

        local rootPart = target:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local screenPos, onScreen = worldToViewportPoint(rootPart.Position)

            -- Update Name
            if espLib.settings.name then
                self.name.Text = target.Name
                self.name.Position = screenPos - Vector2.new(self.name.TextBounds.X / 2, 20)
                self.name.Visible = onScreen
            end

            -- Update Box and Outline
            if espLib.settings.box then
                local boxSize = Vector2.new(50, 100)
                local boxPos = screenPos - boxSize / 2
                self.box.Size = boxSize
                self.box.Position = boxPos
                self.box.Visible = onScreen

                self.boxOutline.Size = boxSize
                self.boxOutline.Position = boxPos
                self.boxOutline.Visible = onScreen
            end

            -- Update Distance
            if espLib.settings.distance then
                local distance = (workspace.CurrentCamera.CFrame.Position - rootPart.Position).Magnitude
                self.distance.Text = string.format("%.0f studs", distance)
                self.distance.Position = screenPos + Vector2.new(-self.distance.TextBounds.X / 2, 120)
                self.distance.Visible = onScreen
            end

            -- Update Tracers
            if espLib.settings.tracers then
                local tracerFrom = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                local tracerTo = screenPos
                self.tracer.From = tracerFrom
                self.tracer.To = tracerTo
                self.tracer.Visible = onScreen
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

-- Return the ESP library for usage
return espLib
