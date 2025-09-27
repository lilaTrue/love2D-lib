-- TimerManager.lua
-- FPS management system for Love2D
-- Provides functions to get and set target FPS

local TimerManager = {}

-- Private variables
local targetFPS = 60
local frameTime = 1 / targetFPS
local accumulator = 0
local lastTime = love.timer.getTime()

-- Set the target FPS
function TimerManager.setFPS(fps)
    if fps <= 0 then
        error("FPS must be greater than 0")
    end
    targetFPS = fps
    frameTime = 1 / targetFPS
end

-- Get the current target FPS
function TimerManager.getFPS()
    return targetFPS
end

-- Update function to be called in love.update
-- This manages the frame timing to maintain the target FPS
function TimerManager.update()
    local currentTime = love.timer.getTime()
    local deltaTime = currentTime - lastTime
    lastTime = currentTime

    accumulator = accumulator + deltaTime

    if accumulator >= frameTime then
        -- Frame is ready, reset accumulator
        accumulator = accumulator - frameTime
    else
        -- Sleep to maintain frame rate
        local sleepTime = frameTime - accumulator
        if sleepTime > 0 then
            love.timer.sleep(sleepTime)
        end
        accumulator = 0
    end
end

-- Get the actual FPS (frames per second) based on delta time
function TimerManager.getActualFPS()
    local dt = love.timer.getDelta()
    if dt > 0 then
        return math.floor(1 / dt)
    end
    return 0
end

-- Get the frame time in seconds
function TimerManager.getFrameTime()
    return frameTime
end

return TimerManager
