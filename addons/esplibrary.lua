local espLib = {}
espLib.settings = {
    box = true,
    name = true,
    distance = true,
    health = true,
    tracers = true,
    outlines = true,
    font = Drawing.Fonts.Plex,
    playerEsp = true -- New setting to enable automatic player ESP
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

    -- Individual On-Screen Checks
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

            -- Update Name
            if espLib.settings.name then
                local nameOnScreen = isOnScreen(rootPart.Position + Vector3.new(0, 5, 0))
                self.name.Text = target.Name
                self.name.Position = screenPos - Vector2.new(self.name.TextBounds.X / 2, 50)
                self.name.Visible = nameOnScreen
            else
                self.name.Visible = false
            end

            -- Update Box and Outline (Fix outline being above box)
            if espLib.settings.box then
                local boxSize = Vector2.new(50, 100)
                local boxPos = screenPos - boxSize / 2
                local boxOnScreen = isOnScreen(rootPart.Position)

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

            -- Update Health Bar and Outline
            if espLib.settings.health then
                local healthRatio = humanoid.Health / humanoid.MaxHealth
                local barHeight = 100 * healthRatio
                local barSize = Vector2.new(4, barHeight)
                local barPos = self.box.Position - Vector2.new(6, 0)
                local barOnScreen = isOnScreen(rootPart.Position)

                self.healthBar.Size = barSize
                self.healthBar.Position = Vector2.new(barPos.X, barPos.Y + (100 - barHeight))
                self.healthBar.Color = Color3.fromRGB(255 * (1 - healthRatio), 255 * healthRatio, 0)
                self.healthBar.Visible = barOnScreen

                if espLib.settings.outlines then
                    self.healthBarOutline.Size = Vector2.new(4, 100)
                    self.healthBarOutline.Position = barPos
                    self.healthBarOutline.Visible = barOnScreen
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
                local distanceOnScreen = isOnScreen(rootPart.Position)
                self.distance.Text = string.format("%.0f studs", distance)
                self.distance.Position = screenPos + Vector2.new(-self.distance.TextBounds.X / 2, 60)
                self.distance.Visible = distanceOnScreen
            else
                self.distance.Visible = false
            end

            -- Update Tracer
            if espLib.settings.tracers then
                local tracerOnScreen = isOnScreen(rootPart.Position)
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

function espLib.createPlayerEsp(player)
    local espObjects
    player.CharacterAdded:Connect(function(character)
        local rootPart = character:WaitForChild("HumanoidRootPart")
        espObjects = espLib.createEsp(rootPart)
        
        local function playerLeaving()
            if espObjects then
                espObjects:removeEsp()
            end
        end

        
        player.CharacterRemoving:Connect(playerLeaving)
    end)
end

-- | Create ESP for all players if enabled
if espLib.settings.playerEsp then
    game.Players.PlayerAdded:Connect(function(player)
        espLib.createPlayerEsp(player)
    end)
end

return espLib
