-- | ESP Library
-- Repeat wait until the game loads
repeat task.wait() until game:IsLoaded()

-- | SERVICES
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- | ESP Library Table
local ESP = {}
ESP.Objects = {}
ESP.Settings = {
    NameDisplay = true,
    DistanceDisplay = true,
    HealthBar = true,
    BoxDisplay = true,
    Outline = true
}

-- | Helper Functions
local function getDistance(part)
    local character = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        return (rootPart.Position - part.Position).Magnitude
    end
    return math.huge
end

local function createDrawing(type, properties)
    local drawing = Drawing.new(type)
    for key, value in pairs(properties) do
        drawing[key] = value
    end
    return drawing
end

-- | Add Object to ESP
function ESP:AddObject(object)
    print("[ESP]: Adding object", object.Name)
    local part
    if object:IsA("Model") then
        part = object.PrimaryPart
        if not part then
            warn("[ESP]: Model has no PrimaryPart", object.Name)
            return
        end
    elseif object:IsA("BasePart") then
        part = object
    else
        warn("[ESP]: Unsupported object type", object.Name)
        return
    end

    local espObject = {
        Object = object,
        Part = part,
        Box = ESP.Settings.BoxDisplay and createDrawing("Square", {
            Thickness = 1,
            Color = Color3.fromRGB(255, 255, 255),
            Filled = false,
            Visible = true
        }) or nil,
        BoxOutline = ESP.Settings.Outline and createDrawing("Square", {
            Thickness = 3,
            Color = Color3.fromRGB(0, 0, 0),
            Filled = false,
            Visible = true
        }) or nil,
        Name = ESP.Settings.NameDisplay and createDrawing("Text", {
            Size = 16,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = true
        }) or nil,
        Distance = ESP.Settings.DistanceDisplay and createDrawing("Text", {
            Size = 16,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = true
        }) or nil,
        HealthBar = ESP.Settings.HealthBar and createDrawing("Line", {
            Thickness = 4,
            Color = Color3.fromRGB(0, 255, 0),
            Visible = true
        }) or nil,
        HealthBarOutline = ESP.Settings.Outline and createDrawing("Line", {
            Thickness = 6,
            Color = Color3.fromRGB(0, 0, 0),
            Visible = true
        }) or nil
    }

    print("[ESP]: Object added successfully", object.Name)
    table.insert(self.Objects, espObject)
end

-- | Remove Object from ESP
function ESP:RemoveObject(object)
    print("[ESP]: Removing object", object.Name)
    for i, espObject in ipairs(self.Objects) do
        if espObject.Object == object then
            for _, drawing in pairs(espObject) do
                if typeof(drawing) == "table" and drawing.Remove then
                    drawing:Remove()
                end
            end
            table.remove(self.Objects, i)
            print("[ESP]: Object removed successfully", object.Name)
            break
        end
    end
end

-- | Update ESP Objects
runService.RenderStepped:Connect(function()
    for _, espObject in ipairs(ESP.Objects) do
        local part = espObject.Part
        if part and part:IsDescendantOf(workspace) then
            local screenPosition, onScreen = camera:WorldToViewportPoint(part.Position)
            local distance = getDistance(part)

            if espObject.Box then
                local size = (camera:WorldToViewportPoint(part.Position + Vector3.new(1, 3, 0)) - camera:WorldToViewportPoint(part.Position - Vector3.new(1, 3, 0))).Magnitude
                local boxPosition = Vector2.new(screenPosition.X - size / 2, screenPosition.Y - size)
                local boxSize = Vector2.new(size, size * 2)

                if espObject.BoxOutline then
                    espObject.BoxOutline.Visible = onScreen
                    espObject.BoxOutline.Position = boxPosition
                    espObject.BoxOutline.Size = boxSize
                end

                espObject.Box.Visible = onScreen
                espObject.Box.Position = boxPosition
                espObject.Box.Size = boxSize
            end

            if espObject.Name then
                espObject.Name.Visible = onScreen
                if onScreen then
                    espObject.Name.Text = part.Parent.Name
                    espObject.Name.Position = Vector2.new(screenPosition.X, screenPosition.Y - size)
                end
            end

            if espObject.Distance then
                espObject.Distance.Visible = onScreen
                if onScreen then
                    espObject.Distance.Text = string.format("%.1f studs", distance)
                    espObject.Distance.Position = Vector2.new(screenPosition.X, screenPosition.Y + size * 1.2)
                end
            end

            if espObject.HealthBar and part.Parent:FindFirstChildOfClass("Humanoid") then
                local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
                local health = humanoid.Health / humanoid.MaxHealth
                local barStart = Vector2.new(screenPosition.X - size / 2 - 10, screenPosition.Y - size)
                local barEnd = Vector2.new(screenPosition.X - size / 2 - 10, screenPosition.Y - size + (size * 2 * health))

                if espObject.HealthBarOutline then
                    espObject.HealthBarOutline.Visible = onScreen
                    espObject.HealthBarOutline.From = Vector2.new(barStart.X - 1, screenPosition.Y - size - 1)
                    espObject.HealthBarOutline.To = Vector2.new(barStart.X - 1, screenPosition.Y + size * 2 + 1)
                end

                espObject.HealthBar.Visible = onScreen
                espObject.HealthBar.From = barStart
                espObject.HealthBar.To = barEnd
            end
        else
            print("[ESP]: Object no longer valid or out of workspace", espObject.Object.Name)
            ESP:RemoveObject(espObject.Object)
        end
    end
end)

return ESP
