-- SceneManager.lua
-- Ultra-complete Scene Manager for Love2D
-- Manages multiple scenes with support for scene switching, stacking, transitions, and event handling

local SceneManager = {}

-- Private variables
SceneManager.scenes = {}          -- Table to hold all registered scenes
SceneManager.currentScene = nil   -- Currently active scene
SceneManager.sceneStack = {}      -- Stack for scene management (push/pop)
SceneManager.transition = nil     -- Current transition state
SceneManager.transitionTime = 0   -- Time elapsed in transition
SceneManager.transitionDuration = 0.5  -- Default transition duration in seconds

-- Scene base class for convenience
SceneManager.Scene = {
    name = "",
    load = function(self) end,
    unload = function(self) end,
    update = function(self, dt) end,
    draw = function(self) end,
    keypressed = function(self, key, scancode, isrepeat) end,
    keyreleased = function(self, key, scancode) end,
    mousepressed = function(self, x, y, button, istouch, presses) end,
    mousereleased = function(self, x, y, button, istouch, presses) end,
    mousemoved = function(self, x, y, dx, dy, istouch) end,
    wheelmoved = function(self, x, y) end,
    textinput = function(self, text) end,
    textedited = function(self, text, start, length) end,
    focus = function(self, f) end,
    quit = function(self) end,
    visible = function(self, v) end,
    resize = function(self, w, h) end,
    filedropped = function(self, file) end,
    directorydropped = function(self, path) end,
    lowmemory = function(self) end,
    threaderror = function(self, thread, errorstr) end,
    displayrotated = function(self, index, orientation) end,
    touchpressed = function(self, id, x, y, dx, dy, pressure) end,
    touchreleased = function(self, id, x, y, dx, dy, pressure) end,
    touchmoved = function(self, id, x, y, dx, dy, pressure) end,
    joystickpressed = function(self, joystick, button) end,
    joystickreleased = function(self, joystick, button) end,
    joystickaxis = function(self, joystick, axis, value) end,
    joystickhat = function(self, joystick, hat, direction) end,
    joystickadded = function(self, joystick) end,
    joystickremoved = function(self, joystick) end,
    gamepadpressed = function(self, joystick, button) end,
    gamepadreleased = function(self, joystick, button) end,
    gamepadaxis = function(self, joystick, axis, value) end
}

-- Create a new scene instance
function SceneManager:createScene(name)
    local scene = setmetatable({}, {__index = self.Scene})
    scene.name = name
    return scene
end

-- Register a scene
function SceneManager:addScene(name, scene)
    self.scenes[name] = scene
end

-- Remove a scene
function SceneManager:removeScene(name)
    if self.scenes[name] then
        if self.currentScene == self.scenes[name] then
            self:setScene(nil)
        end
        self.scenes[name] = nil
    end
end

-- Set the current scene
function SceneManager:setScene(name)
    if self.transition then return end  -- Don't switch during transition

    if self.currentScene and self.currentScene.unload then
        self.currentScene:unload()
    end

    self.currentScene = name and self.scenes[name] or nil

    if self.currentScene and self.currentScene.load then
        self.currentScene:load()
    end
end

-- Push a scene onto the stack (pause current, switch to new)
function SceneManager:pushScene(name)
    if self.transition then return end

    if self.currentScene then
        table.insert(self.sceneStack, self.currentScene)
    end
    self:setScene(name)
end

-- Pop the top scene from the stack (resume previous)
function SceneManager:popScene()
    if self.transition then return end

    if #self.sceneStack > 0 then
        self:setScene(table.remove(self.sceneStack).name)
    else
        self:setScene(nil)
    end
end

-- Get the current scene
function SceneManager:getCurrentScene()
    return self.currentScene
end

-- Check if a scene exists
function SceneManager:hasScene(name)
    return self.scenes[name] ~= nil
end

-- Transition functions
function SceneManager:startTransition(transitionType, duration)
    if not self.currentScene then return end

    self.transition = {
        type = transitionType or "fade",
        duration = duration or self.transitionDuration,
        startScene = self.currentScene
    }
    self.transitionTime = 0
end

function SceneManager:updateTransition(dt)
    if not self.transition then return end

    self.transitionTime = self.transitionTime + dt
    if self.transitionTime >= self.transition.duration then
        self.transition = nil
        self.transitionTime = 0
    end
end

function SceneManager:drawTransition()
    if not self.transition then return end

    local progress = self.transitionTime / self.transition.duration

    if self.transition.type == "fade" then
        love.graphics.setColor(0, 0, 0, progress)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    elseif self.transition.type == "slide_left" then
        local width = love.graphics.getWidth()
        local offset = width * (1 - progress)
        love.graphics.translate(-offset, 0)
        if self.currentScene and self.currentScene.draw then
            self.currentScene:draw()
        end
        love.graphics.translate(offset, 0)
    -- Add more transition types as needed
    end
end

-- Main update function
function SceneManager:update(dt)
    self:updateTransition(dt)
    if self.currentScene and self.currentScene.update then
        self.currentScene:update(dt)
    end
end

-- Main draw function
function SceneManager:draw()
    if self.currentScene and self.currentScene.draw then
        self.currentScene:draw()
    end
    self:drawTransition()
end

-- Event handling functions (forward to current scene)
function SceneManager:keypressed(key, scancode, isrepeat)
    if self.currentScene and self.currentScene.keypressed then
        self.currentScene:keypressed(key, scancode, isrepeat)
    end
end

function SceneManager:keyreleased(key, scancode)
    if self.currentScene and self.currentScene.keyreleased then
        self.currentScene:keyreleased(key, scancode)
    end
end

function SceneManager:mousepressed(x, y, button, istouch, presses)
    if self.currentScene and self.currentScene.mousepressed then
        self.currentScene:mousepressed(x, y, button, istouch, presses)
    end
end

function SceneManager:mousereleased(x, y, button, istouch, presses)
    if self.currentScene and self.currentScene.mousereleased then
        self.currentScene:mousereleased(x, y, button, istouch, presses)
    end
end

function SceneManager:mousemoved(x, y, dx, dy, istouch)
    if self.currentScene and self.currentScene.mousemoved then
        self.currentScene:mousemoved(x, y, dx, dy, istouch)
    end
end

function SceneManager:wheelmoved(x, y)
    if self.currentScene and self.currentScene.wheelmoved then
        self.currentScene:wheelmoved(x, y)
    end
end

function SceneManager:textinput(text)
    if self.currentScene and self.currentScene.textinput then
        self.currentScene:textinput(text)
    end
end

function SceneManager:textedited(text, start, length)
    if self.currentScene and self.currentScene.textedited then
        self.currentScene:textedited(text, start, length)
    end
end

function SceneManager:focus(f)
    if self.currentScene and self.currentScene.focus then
        self.currentScene:focus(f)
    end
end

function SceneManager:quit()
    if self.currentScene and self.currentScene.quit then
        self.currentScene:quit()
    end
end

function SceneManager:visible(v)
    if self.currentScene and self.currentScene.visible then
        self.currentScene:visible(v)
    end
end

function SceneManager:resize(w, h)
    if self.currentScene and self.currentScene.resize then
        self.currentScene:resize(w, h)
    end
end

function SceneManager:filedropped(file)
    if self.currentScene and self.currentScene.filedropped then
        self.currentScene:filedropped(file)
    end
end

function SceneManager:directorydropped(path)
    if self.currentScene and self.currentScene.directorydropped then
        self.currentScene:directorydropped(path)
    end
end

function SceneManager:lowmemory()
    if self.currentScene and self.currentScene.lowmemory then
        self.currentScene:lowmemory()
    end
end

function SceneManager:threaderror(thread, errorstr)
    if self.currentScene and self.currentScene.threaderror then
        self.currentScene:threaderror(thread, errorstr)
    end
end

function SceneManager:displayrotated(index, orientation)
    if self.currentScene and self.currentScene.displayrotated then
        self.currentScene:displayrotated(index, orientation)
    end
end

function SceneManager:touchpressed(id, x, y, dx, dy, pressure)
    if self.currentScene and self.currentScene.touchpressed then
        self.currentScene:touchpressed(id, x, y, dx, dy, pressure)
    end
end

function SceneManager:touchreleased(id, x, y, dx, dy, pressure)
    if self.currentScene and self.currentScene.touchreleased then
        self.currentScene:touchreleased(id, x, y, dx, dy, pressure)
    end
end

function SceneManager:touchmoved(id, x, y, dx, dy, pressure)
    if self.currentScene and self.currentScene.touchmoved then
        self.currentScene:touchmoved(id, x, y, dx, dy, pressure)
    end
end

function SceneManager:joystickpressed(joystick, button)
    if self.currentScene and self.currentScene.joystickpressed then
        self.currentScene:joystickpressed(joystick, button)
    end
end

function SceneManager:joystickreleased(joystick, button)
    if self.currentScene and self.currentScene.joystickreleased then
        self.currentScene:joystickreleased(joystick, button)
    end
end

function SceneManager:joystickaxis(joystick, axis, value)
    if self.currentScene and self.currentScene.joystickaxis then
        self.currentScene:joystickaxis(joystick, axis, value)
    end
end

function SceneManager:joystickhat(joystick, hat, direction)
    if self.currentScene and self.currentScene.joystickhat then
        self.currentScene:joystickhat(joystick, hat, direction)
    end
end

function SceneManager:joystickadded(joystick)
    if self.currentScene and self.currentScene.joystickadded then
        self.currentScene:joystickadded(joystick)
    end
end

function SceneManager:joystickremoved(joystick)
    if self.currentScene and self.currentScene.joystickremoved then
        self.currentScene:joystickremoved(joystick)
    end
end

function SceneManager:gamepadpressed(joystick, button)
    if self.currentScene and self.currentScene.gamepadpressed then
        self.currentScene:gamepadpressed(joystick, button)
    end
end

function SceneManager:gamepadreleased(joystick, button)
    if self.currentScene and self.currentScene.gamepadreleased then
        self.currentScene:gamepadreleased(joystick, button)
    end
end

function SceneManager:gamepadaxis(joystick, axis, value)
    if self.currentScene and self.currentScene.gamepadaxis then
        self.currentScene:gamepadaxis(joystick, axis, value)
    end
end

return SceneManager