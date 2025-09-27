# TimerManager Documentation

The TimerManager is a FPS (Frames Per Second) management system for Love2D applications. It provides precise control over the game's frame rate, allowing developers to set target FPS values and monitor actual performance. This is essential for maintaining consistent gameplay across different hardware configurations and optimizing battery life on mobile devices.

## Overview

The TimerManager allows you to:
- Set a target FPS for your game
- Monitor the actual FPS in real-time
- Automatically limit frame rate to prevent excessive CPU usage
- Calculate frame timing for smooth animations
- Integrate seamlessly with Love2D's update loop

## Basic Usage

### Requiring the TimerManager

```lua
local TimerManager = require("lib.TimerManager")
```

## FPS Control

### setFPS(fps)

Sets the target frames per second for the application.

**Parameters:**
- `fps` (number): The desired frame rate (must be greater than 0)

**Example:**
```lua
-- Set target FPS to 60
TimerManager.setFPS(60)

-- Set to 30 FPS for slower devices
TimerManager.setFPS(30)
```

### getFPS()

Returns the currently set target FPS.

**Returns:** number - The target FPS value

**Example:**
```lua
local targetFPS = TimerManager.getFPS()
print("Target FPS: " .. targetFPS)
```

## FPS Monitoring

### getActualFPS()

Returns the actual FPS based on the time between frames.

**Returns:** number - The current FPS (rounded to nearest integer)

**Example:**
```lua
local actualFPS = TimerManager.getActualFPS()
print("Current FPS: " .. actualFPS)
```

### getFrameTime()

Returns the target frame time in seconds.

**Returns:** number - Frame time (1 / targetFPS)

**Example:**
```lua
local frameTime = TimerManager.getFrameTime()
print("Frame time: " .. string.format("%.4f", frameTime) .. " seconds")
```

## Integration with Love2D

### update()

Must be called in `love.update()` to maintain the target frame rate.

**Example:**
```lua
function love.update(dt)
    -- Your game logic here

    -- Maintain target FPS
    TimerManager.update()
end
```

## Usage Patterns

### Basic FPS Limiting

```lua
local TimerManager = require("lib.TimerManager")

function love.load()
    TimerManager.setFPS(60)  -- Limit to 60 FPS
end

function love.update(dt)
    -- Game logic
    TimerManager.update()
end

function love.draw()
    love.graphics.print("FPS: " .. TimerManager.getActualFPS(), 10, 10)
end
```

### Dynamic FPS Adjustment

```lua
local TimerManager = require("lib.TimerManager")

function love.load()
    TimerManager.setFPS(60)
end

function love.update(dt)
    -- Adjust FPS based on performance
    local actualFPS = TimerManager.getActualFPS()
    if actualFPS < 30 then
        -- Reduce FPS on slow devices
        TimerManager.setFPS(30)
    elseif actualFPS > 70 then
        -- Increase FPS on fast devices
        TimerManager.setFPS(120)
    end

    TimerManager.update()
end

function love.draw()
    love.graphics.print("Target FPS: " .. TimerManager.getFPS(), 10, 10)
    love.graphics.print("Actual FPS: " .. TimerManager.getActualFPS(), 10, 30)
end
```

### Performance Monitoring

```lua
local TimerManager = require("lib.TimerManager")
local fpsHistory = {}
local maxHistory = 60

function love.load()
    TimerManager.setFPS(60)
end

function love.update(dt)
    TimerManager.update()

    -- Track FPS history
    table.insert(fpsHistory, TimerManager.getActualFPS())
    if #fpsHistory > maxHistory then
        table.remove(fpsHistory, 1)
    end
end

function love.draw()
    -- Display current FPS
    love.graphics.print("FPS: " .. TimerManager.getActualFPS(), 10, 10)

    -- Display FPS graph
    for i, fps in ipairs(fpsHistory) do
        local height = fps * 2  -- Scale for visibility
        love.graphics.rectangle("fill", 10 + i * 5, 600 - height, 4, height)
    end
end
```

### Battery-Saving Mode

```lua
local TimerManager = require("lib.TimerManager")
local batterySaving = false

function love.load()
    TimerManager.setFPS(60)
end

function love.keypressed(key)
    if key == "b" then
        batterySaving = not batterySaving
        if batterySaving then
            TimerManager.setFPS(30)  -- Reduce FPS to save battery
        else
            TimerManager.setFPS(60)  -- Normal FPS
        end
    end
end

function love.update(dt)
    TimerManager.update()
end

function love.draw()
    local mode = batterySaving and "Battery Saving (30 FPS)" or "Normal (60 FPS)"
    love.graphics.print("Mode: " .. mode, 10, 10)
    love.graphics.print("FPS: " .. TimerManager.getActualFPS(), 10, 30)
end
```

## Advanced Usage

### Custom Frame Rate Manager

```lua
local TimerManager = require("lib.TimerManager")

local FrameRateManager = {}

function FrameRateManager:new()
    local manager = setmetatable({}, {__index = self})
    manager.targetFPS = 60
    manager.minFPS = 30
    manager.maxFPS = 120
    manager.adaptive = true
    return manager
end

function FrameRateManager:setTargetFPS(fps)
    self.targetFPS = math.max(self.minFPS, math.min(self.maxFPS, fps))
    TimerManager.setFPS(self.targetFPS)
end

function FrameRateManager:update()
    if self.adaptive then
        local actualFPS = TimerManager.getActualFPS()
        if actualFPS < self.targetFPS * 0.8 then
            -- Performance is poor, reduce target
            self:setTargetFPS(self.targetFPS - 5)
        elseif actualFPS > self.targetFPS * 1.2 then
            -- Performance is good, increase target
            self:setTargetFPS(self.targetFPS + 5)
        end
    end
    TimerManager.update()
end

-- Usage
local fpsManager = FrameRateManager:new()

function love.load()
    fpsManager:setTargetFPS(60)
end

function love.update(dt)
    fpsManager:update()
end
```

## Best Practices

1. **Set FPS early:** Call `setFPS()` in `love.load()` to establish the target frame rate immediately.

2. **Monitor performance:** Use `getActualFPS()` to track if your game meets the target frame rate.

3. **Consider device capabilities:** Different devices have different performance characteristics. Consider adaptive FPS for better compatibility.

4. **Battery considerations:** Lower FPS can significantly extend battery life on mobile devices.

5. **VSync interaction:** Be aware that VSync may interact with FPS limiting. Disable VSync for precise control.

6. **Testing:** Test your game at various FPS settings to ensure smooth gameplay across different scenarios.

7. **User preferences:** Consider allowing users to adjust FPS settings in game options.

## Performance Considerations

- FPS limiting adds minimal CPU overhead
- `getActualFPS()` uses Love2D's delta time for accurate measurements
- Frame rate limiting prevents excessive CPU usage
- Lower FPS can improve performance on slower devices

## Error Handling

The TimerManager includes basic validation:
- `setFPS()` throws an error if FPS is 0 or negative
- Other functions are robust and handle edge cases gracefully

## Complete Example

```lua
local TimerManager = require("lib.TimerManager")

-- Game configuration
local gameConfig = {
    targetFPS = 60,
    showFPS = true,
    adaptiveFPS = false
}

function love.load()
    -- Set window properties
    love.window.setTitle("TimerManager Demo")
    love.window.setMode(800, 600)

    -- Initialize FPS management
    TimerManager.setFPS(gameConfig.targetFPS)

    -- Game objects
    player = {
        x = 400,
        y = 300,
        speed = 200,
        size = 32
    }
end

function love.update(dt)
    -- Player movement
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    end

    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed * dt
    elseif love.keyboard.isDown("down") then
        player.y = player.y + player.speed * dt
    end

    -- Keep player in bounds
    player.x = math.max(0, math.min(800 - player.size, player.x))
    player.y = math.max(0, math.min(600 - player.size, player.y))

    -- Adaptive FPS (optional)
    if gameConfig.adaptiveFPS then
        local actualFPS = TimerManager.getActualFPS()
        if actualFPS < 45 then
            TimerManager.setFPS(math.max(30, TimerManager.getFPS() - 5))
        elseif actualFPS > 70 then
            TimerManager.setFPS(math.min(120, TimerManager.getFPS() + 5))
        end
    end

    -- Maintain target FPS
    TimerManager.update()
end

function love.draw()
    -- Clear screen
    love.graphics.clear(0.1, 0.1, 0.1)

    -- Draw player
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
    love.graphics.setColor(1, 1, 1)

    -- Draw UI
    if gameConfig.showFPS then
        love.graphics.print("Target FPS: " .. TimerManager.getFPS(), 10, 10)
        love.graphics.print("Actual FPS: " .. TimerManager.getActualFPS(), 10, 30)
        love.graphics.print("Frame Time: " .. string.format("%.4f", TimerManager.getFrameTime()) .. "s", 10, 50)
    end

    love.graphics.print("Use arrow keys to move", 10, 570)
    love.graphics.print("Press F to toggle FPS display", 10, 590)
end

function love.keypressed(key)
    if key == "f" then
        gameConfig.showFPS = not gameConfig.showFPS
    elseif key == "1" then
        TimerManager.setFPS(30)
    elseif key == "2" then
        TimerManager.setFPS(60)
    elseif key == "3" then
        TimerManager.setFPS(120)
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.quit()
    print("TimerManager demo completed")
    print("Final FPS: " .. TimerManager.getActualFPS())
end
```

This documentation covers all aspects of the TimerManager, providing developers with the tools needed to effectively manage frame rates in their Love2D applications.
