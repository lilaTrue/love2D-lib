-- main.lua
-- Test program for TimerManager
-- Demonstrates FPS control and monitoring

local TimerManager = require("lib.TimerManager")

local fpsDisplay = 0
local targetFPS = 60

function love.load()
    -- Set target FPS to 60
    TimerManager.setFPS(targetFPS)

    -- Set up window
    love.window.setTitle("TimerManager Test")
    love.window.setMode(800, 620)
end

function love.update(dt)
    -- Update TimerManager to maintain target FPS
    TimerManager.update()

    -- Update FPS display (smooth it a bit)
    local actualFPS = TimerManager.getActualFPS()
    fpsDisplay = fpsDisplay * 0.9 + actualFPS * 0.1
end

function love.draw()
    -- Clear screen
    love.graphics.clear(0.1, 0.1, 0.1)

    -- Draw FPS information
    --love.graphics.setColor(1, 1, 1)
    love.graphics.print("TimerManager FPS Test", 10, 10)
    love.graphics.print("Target FPS: " .. TimerManager.getFPS(), 10, 30)
    love.graphics.print("Actual FPS: " .. string.format("%.1f", fpsDisplay), 10, 50)
    love.graphics.print("Frame Time: " .. string.format("%.4f", TimerManager.getFrameTime()) .. "s", 10, 70)

    -- Draw instructions
    love.graphics.print("Press 1-9 to change target FPS", 10, 570)
    love.graphics.print("Press 0 for unlimited FPS", 10, 590)
end

function love.keypressed(key)
    if key >= "1" and key <= "9" then
        local newFPS = tonumber(key) * 10  -- 10, 20, 30, ..., 90
        TimerManager.setFPS(newFPS)
        targetFPS = newFPS
    elseif key == "0" then
        -- Set to very high FPS (effectively unlimited)
        TimerManager.setFPS(1000)
        targetFPS = 1000
    end
end

function love.quit()
    print("TimerManager test completed")
end
