-- TimerManager.lua
-- FPS management system for Love2D
-- Provides functions to get and set target FPS

local TimerManager = {}

-- Private variables
local targetFPS = 60
local frameTime = 1 / targetFPS
local lastTime = love.timer.getTime()
local fpsHistory = {}
local historySize = 30
local vsyncEnabled = false
local unlimitedFPS = false

-- Set the target FPS
function TimerManager.setFPS(fps)
    if fps <= 0 then
        error("FPS must be greater than 0")
    end
    targetFPS = fps
    frameTime = 1 / targetFPS
    unlimitedFPS = false
end

-- Set unlimited FPS (no frame limiting)
function TimerManager.setUnlimitedFPS()
    unlimitedFPS = true
end

-- Enable/disable VSync
function TimerManager.setVSync(enabled)
    vsyncEnabled = enabled
    love.window.setVSync(enabled and 1 or 0)
end

-- Get VSync status
function TimerManager.isVSyncEnabled()
    return vsyncEnabled
end

-- Get the current target FPS
function TimerManager.getFPS()
    return targetFPS
end

-- Update function to be called in love.update
-- This manages the frame timing to maintain the target FPS
function TimerManager.update()
    if unlimitedFPS or vsyncEnabled then
        return -- No frame limiting needed
    end

    local currentTime = love.timer.getTime()
    local elapsedTime = currentTime - lastTime
    
    -- If we're running too fast, sleep for the remaining time
    if elapsedTime < frameTime then
        local sleepTime = frameTime - elapsedTime
        love.timer.sleep(sleepTime)
    end
    
    lastTime = love.timer.getTime()
end

-- Get the actual FPS (frames per second) based on delta time
function TimerManager.getActualFPS()
    local dt = love.timer.getDelta()
    if dt > 0 then
        return 1 / dt
    end
    return 0
end

-- Get the average FPS over the last N frames
function TimerManager.getAverageFPS()
    if #fpsHistory == 0 then
        return TimerManager.getActualFPS()
    end
    
    local sum = 0
    for _, fps in ipairs(fpsHistory) do
        sum = sum + fps
    end
    return sum / #fpsHistory
end

-- Update FPS history (call this in love.update)
function TimerManager.updateFPSHistory()
    local currentFPS = TimerManager.getActualFPS()
    table.insert(fpsHistory, currentFPS)
    
    if #fpsHistory > historySize then
        table.remove(fpsHistory, 1)
    end
end

-- Get the frame time in seconds
function TimerManager.getFrameTime()
    return frameTime
end

-- Get the actual delta time
function TimerManager.getDeltaTime()
    return love.timer.getDelta()
end

-- Check if running at target FPS (within tolerance)
function TimerManager.isAtTargetFPS(tolerance)
    tolerance = tolerance or 5 -- Default 5 FPS tolerance
    local currentFPS = TimerManager.getAverageFPS()
    return math.abs(currentFPS - targetFPS) <= tolerance
end

return TimerManager
