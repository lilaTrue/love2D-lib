-- main.lua
-- ClassManager Example
-- Demonstrates class creation, inheritance, and object management
--
-- To run this example:
-- 1. Copy lib/ folder to example/class/lib/
-- 2. Or run Love2D from the project root directory

local classes = require("player")

-- Game state
local player = nil
local enemies = {}
local gameTime = 0
local spawnTimer = 0
local score = 0

function love.load()
    -- Create player
    player = classes.Player:new(400, 300)

    -- Add some items to player
    player:addItem("Health Potion")
    player:addItem("Mana Crystal")
    player:addItem("Sword")

    print("Player created with stats:")
    for k, v in pairs(player:getStats()) do
        print("  " .. k .. ": " .. tostring(v))
    end
end

function love.update(dt)
    gameTime = gameTime + dt

    -- Update player
    if player then
        player:update(dt)
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy:update(dt)

        -- Check collision with player
        if player and enemy:checkCollision(player) then
            player:takeDamage(10)
            enemy:takeDamage(50)  -- One hit kill for simplicity
            score = score + 10
            player:gainExperience(25)
        end

        -- Remove dead enemies
        if not enemy.alive then
            table.remove(enemies, i)
        end
    end

    -- Spawn enemies
    spawnTimer = spawnTimer + dt
    if spawnTimer > 3 then
        spawnTimer = 0
        local enemy = classes.Enemy:new(
            love.math.random(0, love.graphics.getWidth()),
            love.math.random(0, love.graphics.getHeight())
        )
        enemy:setTarget(player)
        table.insert(enemies, enemy)
    end

    -- Check if player is dead
    if player and not player.alive then
        print("Game Over! Final Score: " .. score)
        love.event.quit()
    end
end

function love.draw()
    -- Clear screen
    love.graphics.clear(0.1, 0.1, 0.1)

    -- Draw player
    if player then
        player:draw()
    end

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end

    -- Draw UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Time: " .. string.format("%.1f", gameTime), 10, 30)
    love.graphics.print("Enemies: " .. #enemies, 10, 50)

    if player then
        local stats = player:getStats()
        love.graphics.print("Level: " .. stats.level, 10, 70)
        love.graphics.print("Health: " .. stats.health .. "/" .. stats.maxHealth, 10, 90)
        love.graphics.print("Mana: " .. string.format("%.1f", stats.mana) .. "/" .. stats.maxMana, 10, 110)
        love.graphics.print("Inventory: " .. stats.inventorySize .. " items", 10, 130)
    end

    love.graphics.print("Controls:", 10, love.graphics.getHeight() - 100)
    love.graphics.print("  WASD/Arrows: Move", 10, love.graphics.getHeight() - 80)
    love.graphics.print("  Space: Attack", 10, love.graphics.getHeight() - 60)
    love.graphics.print("  E: Use Item", 10, love.graphics.getHeight() - 40)
    love.graphics.print("  I: Show Inventory", 10, love.graphics.getHeight() - 20)
end

function love.keypressed(key)
    if player then
        player:keypressed(key)
    end

    if key == "escape" then
        love.event.quit()
    elseif key == "r" then
        -- Restart game
        love.load()
        enemies = {}
        gameTime = 0
        spawnTimer = 0
        score = 0
    elseif key == "f1" then
        -- Debug: Add experience
        if player then
            player:gainExperience(50)
        end
    elseif key == "f2" then
        -- Debug: Heal player
        if player then
            player:heal(50)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and player then  -- Left click
        -- Move player to clicked position (simple teleport for demo)
        player.x = x - player.width / 2
        player.y = y - player.height / 2
    end
end