-- main.lua
-- SceneManager Example
-- Demonstrates comprehensive scene management with menu, game, pause, settings, and game over scenes
--
-- To run this example:
-- 1. Copy lib/ folder to example/scene/lib/
-- 2. Or run Love2D from the project root directory

local SceneManager = require("lib.SceneManager")

-- Load scene definitions
local scenes = require("scene")

-- Set initial scene
SceneManager:setScene("menu")

-- Love2D Callbacks
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