-- main.lua
-- Test implementation of SceneManager

local SceneManager = require("lib.SceneManager")

-- Create menu scene
local menuScene = SceneManager:createScene("menu")

menuScene.load = function(self)
    print("Menu scene loaded")
end

menuScene.unload = function(self)
    print("Menu scene unloaded")
end

menuScene.update = function(self, dt)
    -- Menu update logic here
end

menuScene.draw = function(self)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Menu Scene", 10, 10)
    love.graphics.print("Press SPACE to start game", 10, 30)
    love.graphics.print("Press P to push game scene", 10, 50)
    love.graphics.print("Press T to test transition", 10, 70)
end

menuScene.keypressed = function(self, key)
    if key == "space" then
        SceneManager:setScene("game")
    elseif key == "p" then
        SceneManager:pushScene("game")
    elseif key == "t" then
        SceneManager:startTransition("fade", 1.0)
        SceneManager:setScene("game")
    end
end

-- Create game scene
local gameScene = SceneManager:createScene("game")

gameScene.load = function(self)
    print("Game scene loaded")
end

gameScene.unload = function(self)
    print("Game scene unloaded")
end

gameScene.update = function(self, dt)
    -- Game update logic here
end

gameScene.draw = function(self)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Game Scene", 10, 10)
    love.graphics.print("Press ESC to go back to menu", 10, 30)
    love.graphics.print("Press BACKSPACE to pop scene", 10, 50)
end

gameScene.keypressed = function(self, key)
    if key == "escape" then
        SceneManager:setScene("menu")
    elseif key == "backspace" then
        SceneManager:popScene()
    end
end

-- Add scenes to manager
SceneManager:addScene("menu", menuScene)
SceneManager:addScene("game", gameScene)

-- Set initial scene
SceneManager:setScene("menu")

-- Love2D callbacks
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