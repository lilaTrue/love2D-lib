# SceneManager Documentation

The SceneManager is a comprehensive scene management system designed specifically for Love2D applications. It provides a robust framework for handling multiple game scenes (such as menus, levels, pause screens, etc.), with support for scene switching, stacking, transitions, and full event forwarding.

## Overview

The SceneManager enables you to:
- Register and manage multiple scenes
- Switch between scenes seamlessly
- Implement scene stacking (push/pop functionality)
- Add smooth transitions between scenes
- Automatically forward Love2D events to the active scene
- Handle scene lifecycle (load/unload)

## Basic Usage

### Requiring the SceneManager

```lua
local SceneManager = require("lib.SceneManager")
```

## Scene Creation

Scenes are typically created as tables with methods that correspond to Love2D callbacks. You can create scenes manually or use the built-in Scene base class.

### Using the Built-in Scene Class

```lua
local menuScene = SceneManager:createScene("menu")

function menuScene:load()
    print("Menu loaded")
end

function menuScene:unload()
    print("Menu unloaded")
end

function menuScene:update(dt)
    -- Menu update logic
end

function menuScene:draw()
    love.graphics.print("Main Menu", 10, 10)
    love.graphics.print("Press ENTER to start", 10, 30)
end

function menuScene:keypressed(key)
    if key == "return" then
        SceneManager:setScene("game")
    end
end
```

### Manual Scene Creation

```lua
local gameScene = {
    name = "game",
    load = function(self)
        self.player = {x = 100, y = 100}
    end,
    update = function(self, dt)
        -- Game logic
    end,
    draw = function(self)
        love.graphics.rectangle("fill", self.player.x, self.player.y, 32, 32)
    end,
    keypressed = function(self, key)
        if key == "escape" then
            SceneManager:setScene("menu")
        end
    end
}
```

## Scene Registration

### addScene(name, scene)

Registers a scene with the SceneManager.

**Parameters:**
- `name` (string): A unique identifier for the scene
- `scene` (table): The scene object with callback methods

**Example:**
```lua
SceneManager:addScene("menu", menuScene)
SceneManager:addScene("game", gameScene)
SceneManager:addScene("pause", pauseScene)
```

## Scene Switching

### setScene(name)

Switches to the specified scene, unloading the current scene and loading the new one.

**Parameters:**
- `name` (string or nil): The name of the scene to switch to, or nil to clear the current scene

**Example:**
```lua
-- Switch to game scene
SceneManager:setScene("game")

-- Clear current scene
SceneManager:setScene(nil)
```

### Automatic Lifecycle Management

When switching scenes, the SceneManager automatically calls:
- `currentScene:unload()` on the old scene (if it exists)
- `newScene:load()` on the new scene (if it exists)

## Scene Stacking

### pushScene(name)

Pushes the current scene onto a stack and switches to a new scene. Useful for overlays like pause menus.

**Parameters:**
- `name` (string): The name of the scene to push

**Example:**
```lua
-- From game scene, push pause menu
SceneManager:pushScene("pause")
```

### popScene()

Pops the top scene from the stack and switches back to the previous scene.

**Example:**
```lua
-- Return from pause menu to game
SceneManager:popScene()
```

## Transitions

### startTransition(transitionType, duration)

Starts a transition effect when switching scenes.

**Parameters:**
- `transitionType` (string): The type of transition ("fade", "slide_left", etc.)
- `duration` (number, optional): Transition duration in seconds (default: 0.5)

**Available Transition Types:**
- `"fade"`: Fades to black and back
- `"slide_left"`: Slides the scene from right to left

**Example:**
```lua
SceneManager:startTransition("fade", 1.0)
SceneManager:setScene("game")
```

### Custom Transitions

You can extend the transition system by modifying the `updateTransition` and `drawTransition` methods.

## Scene Information

### getCurrentScene()

Returns the currently active scene object.

**Returns:** The current scene table or nil

**Example:**
```lua
local current = SceneManager:getCurrentScene()
if current then
    print("Current scene: " .. current.name)
end
```

### hasScene(name)

Checks if a scene with the given name is registered.

**Parameters:**
- `name` (string): The scene name to check

**Returns:** boolean

**Example:**
```lua
if SceneManager:hasScene("level1") then
    SceneManager:setScene("level1")
end
```

### removeScene(name)

Removes a registered scene.

**Parameters:**
- `name` (string): The name of the scene to remove

**Note:** If the scene being removed is currently active, it will be unloaded.

**Example:**
```lua
SceneManager:removeScene("temporaryScene")
```

## Love2D Integration

The SceneManager automatically forwards all Love2D callbacks to the current scene. You must call the corresponding SceneManager methods in your main.lua file.

### Required Setup in main.lua

```lua
function love.update(dt)
    SceneManager:update(dt)
end

function love.draw()
    SceneManager:draw()
end

function love.keypressed(key, scancode, isrepeat)
    SceneManager:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    SceneManager:keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    SceneManager:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    SceneManager:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    SceneManager:mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
    SceneManager:wheelmoved(x, y)
end

function love.textinput(text)
    SceneManager:textinput(text)
end

function love.textedited(text, start, length)
    SceneManager:textedited(text, start, length)
end

function love.focus(f)
    SceneManager:focus(f)
end

function love.quit()
    SceneManager:quit()
end

function love.visible(v)
    SceneManager:visible(v)
end

function love.resize(w, h)
    SceneManager:resize(w, h)
end

function love.filedropped(file)
    SceneManager:filedropped(file)
end

function love.directorydropped(path)
    SceneManager:directorydropped(path)
end

function love.lowmemory()
    SceneManager:lowmemory()
end

function love.threaderror(thread, errorstr)
    SceneManager:threaderror(thread, errorstr)
end

function love.displayrotated(index, orientation)
    SceneManager:displayrotated(index, orientation)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    SceneManager:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    SceneManager:touchreleased(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    SceneManager:touchmoved(id, x, y, dx, dy, pressure)
end

function love.joystickpressed(joystick, button)
    SceneManager:joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
    SceneManager:joystickreleased(joystick, button)
end

function love.joystickaxis(joystick, axis, value)
    SceneManager:joystickaxis(joystick, axis, value)
end

function love.joystickhat(joystick, hat, direction)
    SceneManager:joystickhat(joystick, hat, direction)
end

function love.joystickadded(joystick)
    SceneManager:joystickadded(joystick)
end

function love.joystickremoved(joystick)
    SceneManager:joystickremoved(joystick)
end

function love.gamepadpressed(joystick, button)
    SceneManager:gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
    SceneManager:gamepadreleased(joystick, button)
end

function love.gamepadaxis(joystick, axis, value)
    SceneManager:gamepadaxis(joystick, axis, value)
end
```

## Scene Callback Methods

Scenes can implement any of the following callback methods. They will be called automatically by the SceneManager when the corresponding Love2D event occurs.

### Lifecycle Callbacks
- `load()`: Called when the scene becomes active
- `unload()`: Called when the scene is deactivated

### Update and Render Callbacks
- `update(dt)`: Called every frame with delta time
- `draw()`: Called to render the scene

### Input Callbacks
- `keypressed(key, scancode, isrepeat)`
- `keyreleased(key, scancode)`
- `mousepressed(x, y, button, istouch, presses)`
- `mousereleased(x, y, button, istouch, presses)`
- `mousemoved(x, y, dx, dy, istouch)`
- `wheelmoved(x, y)`
- `textinput(text)`
- `textedited(text, start, length)`

### System Callbacks
- `focus(f)`
- `quit()`
- `visible(v)`
- `resize(w, h)`
- `filedropped(file)`
- `directorydropped(path)`
- `lowmemory()`
- `threaderror(thread, errorstr)`
- `displayrotated(index, orientation)`

### Touch and Mobile Callbacks
- `touchpressed(id, x, y, dx, dy, pressure)`
- `touchreleased(id, x, y, dx, dy, pressure)`
- `touchmoved(id, x, y, dx, dy, pressure)`

### Joystick and Gamepad Callbacks
- `joystickpressed(joystick, button)`
- `joystickreleased(joystick, button)`
- `joystickaxis(joystick, axis, value)`
- `joystickhat(joystick, hat, direction)`
- `joystickadded(joystick)`
- `joystickremoved(joystick)`
- `gamepadpressed(joystick, button)`
- `gamepadreleased(joystick, button)`
- `gamepadaxis(joystick, axis, value)`

## Advanced Usage

### Scene Communication

Scenes can communicate with each other through the SceneManager or by storing references.

```lua
-- In one scene
SceneManager.sharedData = { score = 0 }

-- In another scene
local score = SceneManager.sharedData.score
```

### Dynamic Scene Creation

```lua
local levelNumber = 1
local levelScene = SceneManager:createScene("level" .. levelNumber)

function levelScene:load()
    self.enemies = {}
    -- Load level data
end

SceneManager:addScene("level" .. levelNumber, levelScene)
SceneManager:setScene("level" .. levelNumber)
```

### Transition Customization

To add custom transitions, modify the SceneManager's transition methods:

```lua
function SceneManager:startTransition(transitionType, duration)
    -- Existing code...
    if transitionType == "custom" then
        self.transition = {type = "custom", duration = duration or 1.0}
    end
end

function SceneManager:drawTransition()
    if not self.transition then return end

    if self.transition.type == "custom" then
        local progress = self.transitionTime / self.transition.duration
        love.graphics.setColor(1, 0, 1, progress)  -- Magenta fade
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    else
        -- Default transitions
    end
end
```

## Best Practices

1. **Organize scenes logically:** Group related functionality into scenes (menu, gameplay, settings, etc.)

2. **Use meaningful scene names:** Choose descriptive names that reflect the scene's purpose

3. **Handle cleanup:** Use the `unload` method to clean up resources when scenes change

4. **Implement only needed callbacks:** Don't define empty callback methods for unused events

5. **Use scene stacking for overlays:** Push scenes for pause menus, dialogs, etc.

6. **Test transitions:** Ensure transitions work smoothly and don't interfere with gameplay

7. **Document scene interfaces:** Comment what each scene expects and provides

## Performance Considerations

- Scene switching is lightweight and can be done frequently
- Only the active scene receives updates and draws
- Transitions add minimal overhead when not active
- Event forwarding is efficient due to direct method calls

## Complete Example

```lua
local SceneManager = require("lib.SceneManager")

-- Menu Scene
local menuScene = SceneManager:createScene("menu")

function menuScene:draw()
    love.graphics.print("GAME TITLE", 350, 200)
    love.graphics.print("Press ENTER to Play", 330, 250)
    love.graphics.print("Press ESC to Quit", 340, 280)
end

function menuScene:keypressed(key)
    if key == "return" then
        SceneManager:startTransition("fade", 0.5)
        SceneManager:setScene("game")
    elseif key == "escape" then
        love.event.quit()
    end
end

-- Game Scene
local gameScene = SceneManager:createScene("game")

function gameScene:load()
    self.player = {x = 400, y = 300, speed = 200}
    self.score = 0
end

function gameScene:update(dt)
    if love.keyboard.isDown("left") then
        self.player.x = self.player.x - self.player.speed * dt
    elseif love.keyboard.isDown("right") then
        self.player.x = self.player.x + self.player.speed * dt
    end

    if love.keyboard.isDown("up") then
        self.player.y = self.player.y - self.player.speed * dt
    elseif love.keyboard.isDown("down") then
        self.player.y = self.player.y + self.player.speed * dt
    end
end

function gameScene:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.player.x - 16, self.player.y - 16, 32, 32)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. self.score, 10, 10)
    love.graphics.print("Press ESC for Menu", 10, 30)
end

function gameScene:keypressed(key)
    if key == "escape" then
        SceneManager:setScene("menu")
    elseif key == "p" then
        SceneManager:pushScene("pause")
    end
end

-- Pause Scene
local pauseScene = SceneManager:createScene("pause")

function pauseScene:draw()
    love.graphics.print("PAUSED", 380, 250)
    love.graphics.print("Press P to Resume", 340, 280)
end

function pauseScene:keypressed(key)
    if key == "p" then
        SceneManager:popScene()
    end
end

-- Register scenes
SceneManager:addScene("menu", menuScene)
SceneManager:addScene("game", gameScene)
SceneManager:addScene("pause", pauseScene)

-- Set initial scene
SceneManager:setScene("menu")

-- Love2D callbacks (as shown in Love2D Integration section)
```

This documentation provides comprehensive coverage of the SceneManager's capabilities, enabling you to create complex, well-structured Love2D applications with multiple scenes.