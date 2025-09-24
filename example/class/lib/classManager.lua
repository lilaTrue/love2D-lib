-- classManager.lua
-- Class management system for Lua with Love2D support
-- Provides OOP functionality with inheritance, instantiation, and Love2D callback forwarding

local classManager = {}

-- Private registry for classes
classManager.classes = {}

-- Create a new class
function classManager.createClass(name, base)
    if classManager.classes[name] then
        error("Class '" .. name .. "' already exists")
    end

    local class = {}
    class.__name = name
    class.__base = base

    -- Set metatable for inheritance
    if base then
        setmetatable(class, {__index = base})
    end

    -- Default new function
    function class:new(...)
        local instance = setmetatable({}, {__index = self})

        -- Call constructor if it exists
        if instance.init then
            instance:init(...)
        end

        -- Set up Love2D callback forwarding if supported
        if instance.setupLove2D then
            instance:setupLove2D()
        end

        return instance
    end

    -- Check if instance is of a certain class
    function class:isInstanceOf(className)
        local current = self
        while current do
            if current.__name == className then
                return true
            end
            current = current.__base
        end
        return false
    end

    -- Get class name
    function class:getClassName()
        return self.__name
    end

    -- Register the class
    classManager.classes[name] = class

    return class
end

-- Get a class by name
function classManager.getClass(name)
    return classManager.classes[name]
end

-- Check if a class exists
function classManager.classExists(name)
    return classManager.classes[name] ~= nil
end

-- Remove a class
function classManager.removeClass(name)
    if classManager.classes[name] then
        classManager.classes[name] = nil
        return true
    end
    return false
end

-- List all classes
function classManager.listClasses()
    local list = {}
    for name, _ in pairs(classManager.classes) do
        table.insert(list, name)
    end
    return list
end

-- Love2D integration helper
-- Creates a class that can be used as a Love2D scene or object
function classManager.createLove2DClass(name, base)
    local class = classManager.createClass(name, base)

    -- Default Love2D callbacks (can be overridden)
    class.load = function(self) end
    class.update = function(self, dt) end
    class.draw = function(self) end
    class.keypressed = function(self, key, scancode, isrepeat) end
    class.keyreleased = function(self, key, scancode) end
    class.mousepressed = function(self, x, y, button, istouch, presses) end
    class.mousereleased = function(self, x, y, button, istouch, presses) end
    class.mousemoved = function(self, x, y, dx, dy, istouch) end
    class.wheelmoved = function(self, x, y) end
    class.textinput = function(self, text) end
    class.textedited = function(self, text, start, length) end
    class.focus = function(self, f) end
    class.quit = function(self) end
    class.visible = function(self, v) end
    class.resize = function(self, w, h) end
    class.filedropped = function(self, file) end
    class.directorydropped = function(self, path) end
    class.lowmemory = function(self) end
    class.threaderror = function(self, thread, errorstr) end
    class.displayrotated = function(self, index, orientation) end
    class.touchpressed = function(self, id, x, y, dx, dy, pressure) end
    class.touchreleased = function(self, id, x, y, dx, dy, pressure) end
    class.touchmoved = function(self, id, x, y, dx, dy, pressure) end
    class.joystickpressed = function(self, joystick, button) end
    class.joystickreleased = function(self, joystick, button) end
    class.joystickaxis = function(self, joystick, axis, value) end
    class.joystickhat = function(self, joystick, hat, direction) end
    class.joystickadded = function(self, joystick) end
    class.joystickremoved = function(self, joystick) end
    class.gamepadpressed = function(self, joystick, button) end
    class.gamepadreleased = function(self, joystick, button) end
    class.gamepadaxis = function(self, joystick, axis, value) end

    -- Setup function to integrate with Love2D
    class.setupLove2D = function(self)
        -- This can be used to register the object with Love2D if needed
        -- For example, if this class represents a drawable object
    end

    return class
end

-- Utility function to create a simple class without registration
function classManager.simpleClass(base)
    local class = {}
    if base then
        setmetatable(class, {__index = base})
    end
    class.__index = class

    function class:new(...)
        local instance = setmetatable({}, self)
        if instance.init then
            instance:init(...)
        end
        return instance
    end

    return class
end

-- Mixin support
function classManager.mixin(target, source)
    for key, value in pairs(source) do
        if key ~= "__index" and key ~= "__name" and key ~= "__base" then
            target[key] = value
        end
    end
end

return classManager