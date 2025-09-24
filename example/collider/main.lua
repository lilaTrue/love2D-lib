-- main.lua
-- Ultra-complete collision example for Love2D
-- Demonstrates Rect and Circle colliders with collision detection

local CollisionManager = require("../lib/CollisionManager")

local rectCollider
local circleCollider
local colliding = false
local previousColliding = false
local collisionEnter = false
local collisionStay = false
local collisionExit = false

function love.load()
    -- Create colliders
    rectCollider = CollisionManager.RectCollider:new(100, 100, 50, 50)
    circleCollider = CollisionManager.CircleCollider:new(200, 150, 30)
end

function love.update(dt)
    -- Move rect with WASD
    local speed = 200 * dt
    if love.keyboard.isDown("w") then
        rectCollider.y = rectCollider.y - speed
    end
    if love.keyboard.isDown("s") then
        rectCollider.y = rectCollider.y + speed
    end
    if love.keyboard.isDown("a") then
        rectCollider.x = rectCollider.x - speed
    end
    if love.keyboard.isDown("d") then
        rectCollider.x = rectCollider.x + speed
    end

    -- Move circle with arrow keys
    if love.keyboard.isDown("up") then
        circleCollider.y = circleCollider.y - speed
    end
    if love.keyboard.isDown("down") then
        circleCollider.y = circleCollider.y + speed
    end
    if love.keyboard.isDown("left") then
        circleCollider.x = circleCollider.x - speed
    end
    if love.keyboard.isDown("right") then
        circleCollider.x = circleCollider.x + speed
    end

    -- Check collision
    previousColliding = colliding
    colliding = CollisionManager.checkCollision(rectCollider, circleCollider)
    collisionEnter = CollisionManager.checkCollisionEnter(rectCollider, circleCollider, previousColliding)
    collisionStay = CollisionManager.checkCollisionStay(rectCollider, circleCollider, previousColliding)
    collisionExit = CollisionManager.checkCollisionExit(rectCollider, circleCollider, previousColliding)
end

function love.draw()
    -- Draw colliders with color based on collision
    local color = colliding and {0, 1, 0} or {1, 0, 0}  -- Green if colliding, red if not

    rectCollider:draw(color)
    circleCollider:draw(color)

    -- Draw instructions
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Use WASD to move rectangle, Arrow keys to move circle", 10, 10)
    love.graphics.print("Collision: " .. (colliding and "Yes" or "No"), 10, 30)
    love.graphics.print("Enter: " .. (collisionEnter and "Yes" or "No") ..
                       ", Stay: " .. (collisionStay and "Yes" or "No") ..
                       ", Exit: " .. (collisionExit and "Yes" or "No"), 10, 50)

    -- Draw collider info
    love.graphics.print(string.format("Rect: x=%.1f, y=%.1f, w=%.1f, h=%.1f", rectCollider.x, rectCollider.y, rectCollider.w, rectCollider.h), 10, 70)
    love.graphics.print(string.format("Circle: x=%.1f, y=%.1f, r=%.1f", circleCollider.x, circleCollider.y, circleCollider.r), 10, 90)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end