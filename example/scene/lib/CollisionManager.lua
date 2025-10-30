-- CollisionManager.lua
-- Ultra-complete Collision Manager for Love2D
-- Provides Rect and Circle colliders with collision detection, spatial partitioning, and layers

local CollisionManager = {}

-- Collision layers system
CollisionManager.layers = {}
CollisionManager.layerMasks = {}

-- Spatial grid for optimization
CollisionManager.spatialGrid = {
    cellSize = 100,
    cells = {},
    enabled = true
}

-- Register a collision layer
function CollisionManager.addLayer(layerName, layerId)
    CollisionManager.layers[layerName] = layerId or #CollisionManager.layers + 1
end

-- Set which layers a layer can collide with
function CollisionManager.setLayerMask(layerName, maskLayers)
    local layerId = CollisionManager.layers[layerName]
    if not layerId then return end
    
    CollisionManager.layerMasks[layerId] = {}
    for _, maskLayer in ipairs(maskLayers) do
        local maskId = CollisionManager.layers[maskLayer]
        if maskId then
            CollisionManager.layerMasks[layerId][maskId] = true
        end
    end
end

-- Check if two layers can collide
function CollisionManager.canLayersCollide(layer1, layer2)
    if not layer1 or not layer2 then return true end
    if not CollisionManager.layerMasks[layer1] then return true end
    return CollisionManager.layerMasks[layer1][layer2] == true
end

-- Spatial grid functions
function CollisionManager.setCellSize(size)
    CollisionManager.spatialGrid.cellSize = size
    CollisionManager.clearGrid()
end

function CollisionManager.clearGrid()
    CollisionManager.spatialGrid.cells = {}
end

function CollisionManager.enableGrid(enabled)
    CollisionManager.spatialGrid.enabled = enabled
end

local function getCellKey(x, y)
    local cellSize = CollisionManager.spatialGrid.cellSize
    local cx = math.floor(x / cellSize)
    local cy = math.floor(y / cellSize)
    return cx .. "," .. cy
end

local function addToGrid(collider)
    if not CollisionManager.spatialGrid.enabled then return end
    
    local x1, y1, x2, y2 = collider:getBounds()
    local cellSize = CollisionManager.spatialGrid.cellSize
    
    local minCellX = math.floor(x1 / cellSize)
    local minCellY = math.floor(y1 / cellSize)
    local maxCellX = math.floor(x2 / cellSize)
    local maxCellY = math.floor(y2 / cellSize)
    
    for cx = minCellX, maxCellX do
        for cy = minCellY, maxCellY do
            local key = cx .. "," .. cy
            if not CollisionManager.spatialGrid.cells[key] then
                CollisionManager.spatialGrid.cells[key] = {}
            end
            table.insert(CollisionManager.spatialGrid.cells[key], collider)
        end
    end
end

local function getCollidersInArea(x1, y1, x2, y2)
    if not CollisionManager.spatialGrid.enabled then return {} end
    
    local cellSize = CollisionManager.spatialGrid.cellSize
    local minCellX = math.floor(x1 / cellSize)
    local minCellY = math.floor(y1 / cellSize)
    local maxCellX = math.floor(x2 / cellSize)
    local maxCellY = math.floor(y2 / cellSize)
    
    local colliders = {}
    local seen = {}
    
    for cx = minCellX, maxCellX do
        for cy = minCellY, maxCellY do
            local key = cx .. "," .. cy
            local cell = CollisionManager.spatialGrid.cells[key]
            if cell then
                for _, collider in ipairs(cell) do
                    if not seen[collider] then
                        seen[collider] = true
                        table.insert(colliders, collider)
                    end
                end
            end
        end
    end
    
    return colliders
end

-- RectCollider class
CollisionManager.RectCollider = {
    type = "rect",
    x = 0,
    y = 0,
    w = 0,
    h = 0,
    layer = nil,
    tag = nil,
    active = true
}

function CollisionManager.RectCollider:new(x, y, w, h, layer)
    local collider = setmetatable({}, {__index = self})
    collider.x = x or 0
    collider.y = y or 0
    collider.w = w or 0
    collider.h = h or 0
    collider.layer = layer
    collider.tag = nil
    collider.active = true
    return collider
end

function CollisionManager.RectCollider:setLayer(layer)
    self.layer = layer
end

function CollisionManager.RectCollider:setTag(tag)
    self.tag = tag
end

function CollisionManager.RectCollider:setActive(active)
    self.active = active
end

function CollisionManager.RectCollider:getBounds()
    return self.x, self.y, self.x + self.w, self.y + self.h
end

function CollisionManager.RectCollider:draw(color)
    color = color or {1, 1, 1}
    love.graphics.setColor(color)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
end

function CollisionManager.RectCollider:containsPoint(px, py)
    return px >= self.x and px <= self.x + self.w and py >= self.y and py <= self.y + self.h
end

-- CircleCollider class
CollisionManager.CircleCollider = {
    type = "circle",
    x = 0,
    y = 0,
    r = 0,
    layer = nil,
    tag = nil,
    active = true
}

function CollisionManager.CircleCollider:new(x, y, r, layer)
    local collider = setmetatable({}, {__index = self})
    collider.x = x or 0
    collider.y = y or 0
    collider.r = r or 0
    collider.layer = layer
    collider.tag = nil
    collider.active = true
    return collider
end

function CollisionManager.CircleCollider:setLayer(layer)
    self.layer = layer
end

function CollisionManager.CircleCollider:setTag(tag)
    self.tag = tag
end

function CollisionManager.CircleCollider:setActive(active)
    self.active = active
end

function CollisionManager.CircleCollider:getBounds()
    return self.x - self.r, self.y - self.r, self.x + self.r, self.y + self.r
end

function CollisionManager.CircleCollider:draw(color)
    color = color or {1, 1, 1}
    love.graphics.setColor(color)
    love.graphics.circle("line", self.x, self.y, self.r)
    love.graphics.setColor(1, 1, 1)
end

function CollisionManager.CircleCollider:containsPoint(px, py)
    local dx = px - self.x
    local dy = py - self.y
    return dx * dx + dy * dy <= self.r * self.r
end

-- Collision detection functions
function CollisionManager.checkRectRect(r1, r2)
    return r1.x < r2.x + r2.w and r2.x < r1.x + r1.w and r1.y < r2.y + r2.h and r2.y < r1.y + r1.h
end

function CollisionManager.checkCircleCircle(c1, c2)
    local dx = c1.x - c2.x
    local dy = c1.y - c2.y
    local distSq = dx * dx + dy * dy
    local radiiSum = c1.r + c2.r
    return distSq <= radiiSum * radiiSum
end

function CollisionManager.checkRectCircle(r, c)
    -- Find the closest point on the rect to the circle center
    local closestX = math.max(r.x, math.min(c.x, r.x + r.w))
    local closestY = math.max(r.y, math.min(c.y, r.y + r.h))
    -- Calculate distance
    local dx = c.x - closestX
    local dy = c.y - closestY
    return dx * dx + dy * dy <= c.r * c.r
end

function CollisionManager.checkCollision(collider1, collider2)
    -- Check if colliders are active
    if not collider1.active or not collider2.active then
        return false
    end
    
    -- Check layer collision masks
    if not CollisionManager.canLayersCollide(collider1.layer, collider2.layer) then
        return false
    end
    
    if collider1.type == "rect" and collider2.type == "rect" then
        return CollisionManager.checkRectRect(collider1, collider2)
    elseif collider1.type == "circle" and collider2.type == "circle" then
        return CollisionManager.checkCircleCircle(collider1, collider2)
    elseif (collider1.type == "rect" and collider2.type == "circle") or
           (collider1.type == "circle" and collider2.type == "rect") then
        local rect, circle = collider1, collider2
        if collider1.type == "circle" then rect, circle = collider2, collider1 end
        return CollisionManager.checkRectCircle(rect, circle)
    end
    return false
end

-- Check collisions using spatial grid optimization
function CollisionManager.checkCollisionsOptimized(collider, colliders)
    local results = {}
    
    if CollisionManager.spatialGrid.enabled then
        local x1, y1, x2, y2 = collider:getBounds()
        local nearbyColliders = getCollidersInArea(x1, y1, x2, y2)
        
        for _, other in ipairs(nearbyColliders) do
            if other ~= collider and CollisionManager.checkCollision(collider, other) then
                table.insert(results, other)
            end
        end
    else
        -- Fallback to brute force
        for _, other in ipairs(colliders) do
            if other ~= collider and CollisionManager.checkCollision(collider, other) then
                table.insert(results, other)
            end
        end
    end
    
    return results
end

-- Update spatial grid with all colliders
function CollisionManager.updateGrid(colliders)
    CollisionManager.clearGrid()
    for _, collider in ipairs(colliders) do
        if collider.active then
            addToGrid(collider)
        end
    end
end

-- Find colliders by tag
function CollisionManager.findByTag(colliders, tag)
    local results = {}
    for _, collider in ipairs(colliders) do
        if collider.tag == tag then
            table.insert(results, collider)
        end
    end
    return results
end

-- Find colliders by layer
function CollisionManager.findByLayer(colliders, layer)
    local results = {}
    for _, collider in ipairs(colliders) do
        if collider.layer == layer then
            table.insert(results, collider)
        end
    end
    return results
end

-- Collision state functions (like Unity)
function CollisionManager.checkCollisionEnter(collider1, collider2, wasColliding)
    local isColliding = CollisionManager.checkCollision(collider1, collider2)
    return isColliding and not wasColliding
end

function CollisionManager.checkCollisionStay(collider1, collider2, wasColliding)
    local isColliding = CollisionManager.checkCollision(collider1, collider2)
    return isColliding and wasColliding
end

function CollisionManager.checkCollisionExit(collider1, collider2, wasColliding)
    local isColliding = CollisionManager.checkCollision(collider1, collider2)
    return not isColliding and wasColliding
end

return CollisionManager