-- player.lua
-- Example Player class using ClassManager
-- Demonstrates class creation, inheritance, and Love2D integration

local classManager = require("lib.classManager")

-- Create a base Entity class
local Entity = classManager.createLove2DClass("Entity")

function Entity:init(x, y)
    self.x = x or 0
    self.y = y or 0
    self.width = 32
    self.height = 32
    self.speed = 200
    self.alive = true
end

function Entity:update(dt)
    -- Base update logic
end

function Entity:draw()
    if self.alive then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
end

function Entity:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Entity:getBounds()
    return self.x, self.y, self.width, self.height
end

function Entity:checkCollision(other)
    local x1, y1, w1, h1 = self:getBounds()
    local x2, y2, w2, h2 = other:getBounds()
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- Create Player class inheriting from Entity
local Player = classManager.createLove2DClass("Player", Entity)

function Player:init(x, y)
    -- Call parent constructor
    Entity.init(self, x, y)

    -- Player-specific properties
    self.health = 100
    self.maxHealth = 100
    self.mana = 50
    self.maxMana = 50
    self.level = 1
    self.experience = 0
    self.inventory = {}
    self.color = {0, 1, 0}  -- Green color
    self.weapon = nil
end

function Player:update(dt)
    -- Call parent update
    Entity.update(self, dt)

    -- Player movement
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

    self:move(dx, dy)

    -- Keep player within screen bounds
    self.x = math.max(0, math.min(self.x, love.graphics.getWidth() - self.width))
    self.y = math.max(0, math.min(self.y, love.graphics.getHeight() - self.height))

    -- Regenerate mana slowly
    if self.mana < self.maxMana then
        self.mana = math.min(self.maxMana, self.mana + 10 * dt)
    end
end

function Player:draw()
    -- Draw player
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw health bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y - 15, self.width, 5)
    love.graphics.setColor(1, 0, 0)
    local healthRatio = self.health / self.maxHealth
    love.graphics.rectangle("fill", self.x, self.y - 15, self.width * healthRatio, 5)

    -- Draw mana bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y - 25, self.width, 5)
    love.graphics.setColor(0, 0, 1)
    local manaRatio = self.mana / self.maxMana
    love.graphics.rectangle("fill", self.x, self.y - 25, self.width * manaRatio, 5)

    -- Draw level
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Lv." .. self.level, self.x, self.y - 40)

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

function Player:keypressed(key)
    if key == "space" then
        self:attack()
    elseif key == "e" then
        self:useItem()
    elseif key == "i" then
        print("Inventory:", table.concat(self.inventory, ", "))
    end
end

function Player:takeDamage(amount)
    self.health = math.max(0, self.health - amount)
    if self.health <= 0 then
        self.alive = false
        print("Player died!")
    end
end

function Player:heal(amount)
    self.health = math.min(self.maxHealth, self.health + amount)
end

function Player:gainExperience(amount)
    self.experience = self.experience + amount
    -- Simple leveling system
    local expNeeded = self.level * 100
    if self.experience >= expNeeded then
        self.experience = self.experience - expNeeded
        self:levelUp()
    end
end

function Player:levelUp()
    self.level = self.level + 1
    self.maxHealth = self.maxHealth + 20
    self.health = self.maxHealth  -- Full heal on level up
    self.maxMana = self.maxMana + 10
    self.mana = self.maxMana
    print("Leveled up to " .. self.level .. "!")
end

function Player:attack()
    if self.mana >= 10 then
        self.mana = self.mana - 10
        print("Player attacks!")
        -- In a real game, this would create projectiles or trigger combat
    else
        print("Not enough mana!")
    end
end

function Player:addItem(item)
    table.insert(self.inventory, item)
    print("Added " .. item .. " to inventory")
end

function Player:useItem()
    if #self.inventory > 0 then
        local item = table.remove(self.inventory, 1)
        print("Used " .. item)
        -- Apply item effects here
    else
        print("Inventory is empty")
    end
end

function Player:getStats()
    return {
        health = self.health,
        maxHealth = self.maxHealth,
        mana = self.mana,
        maxMana = self.maxMana,
        level = self.level,
        experience = self.experience,
        inventorySize = #self.inventory
    }
end

-- Create Enemy class also inheriting from Entity
local Enemy = classManager.createLove2DClass("Enemy", Entity)

function Enemy:init(x, y, enemyType)
    Entity.init(self, x, y)
    self.type = enemyType or "goblin"
    self.color = {1, 0, 0}  -- Red color
    self.speed = 100
    self.health = 50
    self.target = nil
end

function Enemy:update(dt)
    Entity.update(self, dt)

    -- Simple AI: move towards target if exists
    if self.target then
        local dx = self.target.x - self.x
        local dy = self.target.y - self.y
        local distance = math.sqrt(dx*dx + dy*dy)

        if distance > 0 then
            dx = dx / distance
            dy = dy / distance
            self:move(dx * self.speed * dt, dy * self.speed * dt)
        end
    end
end

function Enemy:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw health bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y - 10, self.width, 3)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y - 10, self.width * (self.health / 50), 3)

    love.graphics.setColor(1, 1, 1)
end

function Enemy:setTarget(target)
    self.target = target
end

function Enemy:takeDamage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.alive = false
    end
end

-- Export the classes
return {
    Player = Player,
    Enemy = Enemy,
    Entity = Entity
}