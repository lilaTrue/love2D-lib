-- player.lua
-- Example Player class using classManager
-- Demonstrates simple class creation with Love2D integration

local classManager = require("lib.classManager")

-- Create Player class directly
local Player = classManager.createLove2DClass("Player")

function Player:init(x, y)
    self.x = x or 0
    self.y = y or 0
    self.speed = 100
    self.width = 32
    self.height = 32
    self.health = 100
    self.maxHealth = 100
    self.color = {1, 0, 0}  -- Red color
end

function Player:update(dt)
    -- Player movement logic
    local dx, dy = 0, 0

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        dx = dx - self.speed * dt
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        dx = dx + self.speed * dt
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        dy = dy - self.speed * dt
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        dy = dy + self.speed * dt
    end

    self.x = self.x + dx
    self.y = self.y + dy

    -- Keep player within screen bounds
    self.x = math.max(0, math.min(self.x, love.graphics.getWidth() - self.width))
    self.y = math.max(0, math.min(self.y, love.graphics.getHeight() - self.height))
end

function Player:draw()
    -- Set player color
    love.graphics.setColor(self.color)

    -- Draw player
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw health bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y - 10, self.width, 5)
    love.graphics.setColor(0, 1, 0)
    local healthRatio = self.health / self.maxHealth
    love.graphics.rectangle("fill", self.x, self.y - 10, self.width * healthRatio, 5)

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

function Player:keypressed(key)
    if key == "space" then
        -- Example action
        self:takeDamage(10)
    elseif key == "h" then
        self:heal(20)
    end
end

function Player:takeDamage(amount)
    self.health = math.max(0, self.health - amount)
    if self.health <= 0 then
        print("Player died!")
    end
end

function Player:heal(amount)
    self.health = math.min(self.maxHealth, self.health + amount)
end

function Player:getPosition()
    return self.x, self.y
end

function Player:setPosition(x, y)
    self.x = x
    self.y = y
end

-- Export the Player class
return Player