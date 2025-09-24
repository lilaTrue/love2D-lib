-- CollisionManager.lua
-- Ultra-complete Collision Manager for Love2D
-- Provides Rect and Circle colliders with collision detection

local CollisionManager = {}

-- RectCollider class
CollisionManager.RectCollider = {
    type = "rect",
    x = 0,
    y = 0,
    w = 0,
    h = 0
}

function CollisionManager.RectCollider:new(x, y, w, h)
    local collider = setmetatable({}, {__index = self})
    collider.x = x or 0
    collider.y = y or 0
    collider.w = w or 0
    collider.h = h or 0
    return collider
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
    r = 0
}

function CollisionManager.CircleCollider:new(x, y, r)
    local collider = setmetatable({}, {__index = self})
    collider.x = x or 0
    collider.y = y or 0
    collider.r = r or 0
    return collider
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

return CollisionManager