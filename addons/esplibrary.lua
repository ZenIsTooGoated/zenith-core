local espLib = {}
espLib.settings = {
    box = true,
    name = true,
    distance = true,
    health = true,
    tracers = true,
    outlines = true,
    font = Drawing.Fonts.Plex
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

    espObjects.healthBar = createDrawing("Square", {
        Thickness = 0,
        Filled = true,
        Color = Color3.new(0, 1, 0),
        Visible = false,
    })

    espObjects.healthBarOutline = createDrawing("Square", {
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

    -- Local On-Screen Check
    local function isOnScreen(position)
        local _, onScreen = workspace.CurrentCamera:WorldToViewportPoint(position)
        return onScreen
    end

    function espObjects:updateEsp()
        if not target or not target:IsDescendantOf(workspace) then
            self:removeEsp()
            return
        end

        local rootPart = target:FindFirstChild("HumanoidRootPart")
        local humanoid = target:FindFirstChildWhichIsA("Humanoid")
        if rootPart and humanoid and humanoid.Health > 0 then
            local screenPos, onScreen = worldToViewportPoint(rootPart.Position)

            if onScreen then
                -- Update Name
                if espLib.settings.name then
                    self.name.Text = target.Name
                    self.name.Position = screenPos - Vector2.new(self.name.TextBounds.X / 2, 50)
                    self.name.Visible = true
                else
                    self.name.Visible = false
                end

                -- Update Box and Outline
                if espLib.settings.box then
                    local boxSize = Vector2.new(50, 100)
                    local boxPos = screenPos - boxSize / 2

                    self.box.Size = boxSize
                    self.box.Position = boxPos
                    self.box.Visible = true

                    if espLib.settings.outlines then
                        self.boxOutline.Size = boxSize
                        self.boxOutline.Position = boxPos
                        self.boxOutline.Visible = true
                    else
                        self.boxOutline.Visible = false
                    end
                else
                    self.box.Visible = false
                    self.boxOutline.Visible = false
                end

                -- Update Health Bar and Outline
                if espLib.settings.health then
                    local healthRatio = humanoid.Health / humanoid.MaxHealth
                    local barHeight = 100 * healthRatio
                    local barSize = Vector2.new(4, barHeight)
                    local barPos = self.box.Position - Vector2.new(6, 0)

                    self.healthBar.Size = barSize
                    self.healthBar.Position = Vector2.new(barPos.X, barPos.Y + (100 - barHeight))
                    self.healthBar.Color = Color3.fromRGB(255 * (1 - healthRatio), 255 * healthRatio, 0)
                    self.healthBar.Visible = true

                    if espLib.settings.outlines then
                        self.healthBarOutline.Size = Vector2.new(4, 100)
                        self.healthBarOutline.Position = barPos
                        self.healthBarOutline.Visible = true
                    else
                        self.healthBarOutline.Visible = false
                    end
                else
                    self.healthBar.Visible = false
                    self.healthBarOutline.Visible = false
                end

                -- Update Distance
                if espLib.settings.distance then
                    local distance = (workspace.CurrentCamera.CFrame.Position - rootPart.Position).Magnitude
                    self.distance.Text = string.format("%.0f studs", distance)
                    self.distance.Position = screenPos + Vector2.new(-self.distance.TextBounds.X / 2, 60)
                    self.distance.Visible = true
                else
                    self.distance.Visible = false
                end

                -- Update Tracer
                if espLib.settings.tracers then
                    self.tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                    self.tracer.To = screenPos
                    self.tracer.Visible = true
                else
                    self.tracer.Visible = false
                end
            else
                -- Hide all ESP elements if off-screen
                for _, object in pairs(self) do
                    if typeof(object) == "Instance" then
                        object.Visible = false
                    end
                end
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
