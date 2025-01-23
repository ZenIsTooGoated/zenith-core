local ESP = {}
ESP.__index = ESP

-- Default settings
ESP.settings = {
    box = {
        enabled = true,
        outline = true,
        color = Color3.fromRGB(255, 255, 255),
        thickness = 1
    },
    tracer = {
        enabled = true,
        color = Color3.fromRGB(255, 255, 255),
        thickness = 1
    },
    name = {
        enabled = true,
        color = Color3.fromRGB(255, 255, 255),
        size = 13
    },
    distance = {
        enabled = true,
        color = Color3.fromRGB(255, 255, 255),
        size = 13
    }
}

-- Constructor for new ESP objects
function ESP.new(object)
    local self = setmetatable({}, ESP)
    self.object = object
    self.enabled = true
    self.box = {
        outline = Drawing.new("Quad"),
        fill = Drawing.new("Quad"),
    }
    self.tracer = Drawing.new("Line")
    self.name = Drawing.new("Text")
    self.distance = Drawing.new("Text")

    -- Initial drawing configurations
    for _, part in pairs(self.box) do
        part.Visible = false
    end
    self.tracer.Visible = false
    self.name.Visible = false
    self.distance.Visible = false

    return self
end

-- Update ESP elements
function ESP:Update()
    if not self.enabled or not self.object then
        self:Clear()
        return
    end

    local rootPart = self.object:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local Camera = workspace.CurrentCamera
        local points = {}
        local visible = false

        for _, part in ipairs(self.object:GetChildren()) do
            if part:IsA("BasePart") then
                local pos, vis = Camera:WorldToViewportPoint(part.Position)
                if vis then
                    table.insert(points, {Position = pos, Visible = vis})
                    visible = true
                end
            end
        end

        -- Calculate the bounding box
        if visible then
            local TopY, DownY = math.huge, -math.huge
            local LeftX, RightX = math.huge, -math.huge

            for _, point in ipairs(points) do
                if point.Visible then
                    local pos = point.Position
                    if pos.Y < TopY then TopY = pos.Y end
                    if pos.Y > DownY then DownY = pos.Y end
                    if pos.X < LeftX then LeftX = pos.X end
                    if pos.X > RightX then RightX = pos.X end
                end
            end

            -- Update box
            if ESP.settings.box.enabled then
                self.box.outline.Visible = ESP.settings.box.outline
                self.box.outline.PointA = Vector2.new(RightX, TopY)
                self.box.outline.PointB = Vector2.new(LeftX, TopY)
                self.box.outline.PointC = Vector2.new(LeftX, DownY)
                self.box.outline.PointD = Vector2.new(RightX, DownY)
                self.box.outline.Color = ESP.settings.box.color
                self.box.outline.Thickness = ESP.settings.box.thickness

                self.box.fill.Visible = true
                self.box.fill.PointA = Vector2.new(RightX, TopY)
                self.box.fill.PointB = Vector2.new(LeftX, TopY)
                self.box.fill.PointC = Vector2.new(LeftX, DownY)
                self.box.fill.PointD = Vector2.new(RightX, DownY)
                self.box.fill.Color = ESP.settings.box.color
                self.box.fill.Transparency = 0.5
            else
                self.box.outline.Visible = false
                self.box.fill.Visible = false
            end

            -- Update tracer
            if ESP.settings.tracer.enabled then
                self.tracer.Visible = true
                self.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                self.tracer.To = Vector2.new((LeftX + RightX) / 2, DownY)
                self.tracer.Color = ESP.settings.tracer.color
                self.tracer.Thickness = ESP.settings.tracer.thickness
            else
                self.tracer.Visible = false
            end

            -- Update name
            if ESP.settings.name.enabled then
                self.name.Visible = true
                self.name.Text = self.object.Name
                self.name.Position = Vector2.new((LeftX + RightX) / 2, TopY - 20)
                self.name.Color = ESP.settings.name.color
                self.name.Size = ESP.settings.name.size
                self.name.Center = true
            else
                self.name.Visible = false
            end

            -- Update distance
            if ESP.settings.distance.enabled then
                local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
                self.distance.Visible = true
                self.distance.Text = string.format("%.0f studs", distance)
                self.distance.Position = Vector2.new((LeftX + RightX) / 2, DownY + 5)
                self.distance.Color = ESP.settings.distance.color
                self.distance.Size = ESP.settings.distance.size
                self.distance.Center = true
            else
                self.distance.Visible = false
            end
        else
            self:Clear()
        end
    else
        self:Clear()
    end
end

-- Clear ESP elements
function ESP:Clear()
    for _, part in pairs(self.box) do
        part.Visible = false
    end
    self.tracer.Visible = false
    self.name.Visible = false
    self.distance.Visible = false
end

-- Destroy ESP instance
function ESP:Destroy()
    for _, part in pairs(self.box) do
        part:Remove()
    end
    self.tracer:Remove()
    self.name:Remove()
    self.distance:Remove()
end

-- Library to manage ESP objects
local ESPLibrary = {}
ESPLibrary.objects = {}

-- Add object to ESP
function ESPLibrary:Add(object)
    local esp = ESP.new(object)
    table.insert(self.objects, esp)
    return esp
end

-- Remove object from ESP
function ESPLibrary:Remove(object)
    for i, esp in ipairs(self.objects) do
        if esp.object == object then
            esp:Destroy()
            table.remove(self.objects, i)
            break
        end
    end
end

-- Update all ESP objects
function ESPLibrary:Update()
    for _, esp in ipairs(self.objects) do
        esp:Update()
    end
end

-- Main update loop
game:GetService("RunService").RenderStepped:Connect(function()
    ESPLibrary:Update()
end)

return ESPLibrary
