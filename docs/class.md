# ClassManager Documentation

The ClassManager is a comprehensive object-oriented programming (OOP) system for Lua, designed to facilitate class creation, inheritance, and instantiation. It provides a clean and intuitive API for building class hierarchies while maintaining compatibility with Love2D game development.

## Overview

The ClassManager allows you to:
- Create classes with inheritance support
- Instantiate objects from classes
- Use mixins for code reuse
- Create Love2D-specific classes with built-in callback support
- Manage class registration and lookup

## Basic Usage

### Requiring the ClassManager

```lua
local classManager = require("lib.classManager")
```

## Class Creation

### createClass(name, base)

Creates a new class with optional inheritance.

**Parameters:**
- `name` (string): The unique name for the class
- `base` (table, optional): The base class to inherit from

**Returns:** The newly created class table

**Example:**
```lua
-- Create a base class
local Animal = classManager.createClass("Animal")

function Animal:init(name)
    self.name = name
end

function Animal:speak()
    print(self.name .. " makes a sound")
end

-- Create a derived class
local Dog = classManager.createClass("Dog", Animal)

function Dog:init(name, breed)
    Animal.init(self, name)  -- Call parent constructor
    self.breed = breed
end

function Dog:speak()
    print(self.name .. " barks")
end
```

### createLove2DClass(name, base)

Creates a class specifically designed for Love2D with all Love2D callbacks pre-defined.

**Parameters:**
- `name` (string): The unique name for the class
- `base` (table, optional): The base class to inherit from

**Returns:** The newly created Love2D-compatible class

**Pre-defined Callbacks:**
- `load()` - Called when the object is loaded
- `update(dt)` - Called every frame with delta time
- `draw()` - Called to render the object
- `keypressed(key, scancode, isrepeat)` - Keyboard input
- `keyreleased(key, scancode)` - Keyboard release
- `mousepressed(x, y, button, istouch, presses)` - Mouse input
- `mousereleased(x, y, button, istouch, presses)` - Mouse release
- `mousemoved(x, y, dx, dy, istouch)` - Mouse movement
- `wheelmoved(x, y)` - Mouse wheel
- `textinput(text)` - Text input
- `textedited(text, start, length)` - Text editing
- `focus(f)` - Window focus change
- `quit()` - Application quit
- `visible(v)` - Window visibility change
- `resize(w, h)` - Window resize
- `filedropped(file)` - File dropped onto window
- `directorydropped(path)` - Directory dropped onto window
- `lowmemory()` - Low memory warning
- `threaderror(thread, errorstr)` - Thread error
- `displayrotated(index, orientation)` - Display rotation
- `touchpressed(id, x, y, dx, dy, pressure)` - Touch input
- `touchreleased(id, x, y, dx, dy, pressure)` - Touch release
- `touchmoved(id, x, y, dx, dy, pressure)` - Touch movement
- `joystickpressed(joystick, button)` - Joystick input
- `joystickreleased(joystick, button)` - Joystick release
- `joystickaxis(joystick, axis, value)` - Joystick axis
- `joystickhat(joystick, hat, direction)` - Joystick hat
- `joystickadded(joystick)` - Joystick connected
- `joystickremoved(joystick)` - Joystick disconnected
- `gamepadpressed(joystick, button)` - Gamepad input
- `gamepadreleased(joystick, button)` - Gamepad release
- `gamepadaxis(joystick, axis, value)` - Gamepad axis

**Example:**
```lua
local Player = classManager.createLove2DClass("Player")

function Player:init(x, y)
    self.x = x
    self.y = y
    self.speed = 100
end

function Player:update(dt)
    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end
end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, 32, 32)
end
```

## Object Instantiation

### class:new(...)

Creates a new instance of the class.

**Parameters:** Variable arguments passed to the `init` method

**Returns:** A new instance of the class

**Example:**
```lua
local myDog = Dog:new("Buddy", "Golden Retriever")
myDog:speak()  -- Output: Buddy barks
```

## Class Management

### getClass(name)

Retrieves a registered class by name.

**Parameters:**
- `name` (string): The name of the class to retrieve

**Returns:** The class table or nil if not found

**Example:**
```lua
local AnimalClass = classManager.getClass("Animal")
local animal = AnimalClass:new("Generic Animal")
```

### classExists(name)

Checks if a class with the given name exists.

**Parameters:**
- `name` (string): The name of the class to check

**Returns:** boolean - true if the class exists, false otherwise

**Example:**
```lua
if classManager.classExists("Player") then
    print("Player class is available")
end
```

### removeClass(name)

Removes a registered class.

**Parameters:**
- `name` (string): The name of the class to remove

**Returns:** boolean - true if removed, false if not found

**Example:**
```lua
classManager.removeClass("TemporaryClass")
```

### listClasses()

Returns a list of all registered class names.

**Returns:** A table containing all class names

**Example:**
```lua
local classes = classManager.listClasses()
for _, name in ipairs(classes) do
    print("Registered class: " .. name)
end
```

## Inheritance and Polymorphism

### isInstanceOf(className)

Checks if the class is an instance of or inherits from the specified class.

**Parameters:**
- `className` (string): The name of the class to check against

**Returns:** boolean

**Example:**
```lua
local dog = Dog:new("Rex", "German Shepherd")
print(dog:isInstanceOf("Animal"))  -- true
print(dog:isInstanceOf("Dog"))     -- true
print(dog:isInstanceOf("Cat"))     -- false
```

### getClassName()

Returns the name of the class.

**Returns:** string - The class name

**Example:**
```lua
print(Dog:getClassName())  -- "Dog"
```

## Advanced Features

### simpleClass(base)

Creates a simple class without registration in the ClassManager.

**Parameters:**
- `base` (table, optional): The base class to inherit from

**Returns:** A class table

**Example:**
```lua
local SimpleClass = classManager.simpleClass()

function SimpleClass:init(value)
    self.value = value
end

local instance = SimpleClass:new(42)
```

### mixin(target, source)

Mixes properties from a source table into a target class.

**Parameters:**
- `target` (table): The class to receive the mixin
- `source` (table): The table containing properties to mix in

**Example:**
```lua
local Jumpable = {
    jumpHeight = 10,
    jump = function(self)
        print("Jumping " .. self.jumpHeight .. " units!")
    end
}

classManager.mixin(Player, Jumpable)
local player = Player:new(100, 100)
player:jump()  -- Output: Jumping 10 units!
```

## Love2D Integration

Classes created with `createLove2DClass` automatically include all Love2D callback methods. You can override these methods in your class definition to add custom behavior.

The `setupLove2D` method is called automatically during instantiation and can be used to perform Love2D-specific setup.

**Example:**
```lua
local GameObject = classManager.createLove2DClass("GameObject")

function GameObject:setupLove2D()
    -- Custom Love2D setup
    self.image = love.graphics.newImage("sprite.png")
end

function GameObject:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
```

## Best Practices

1. **Use meaningful class names:** Choose descriptive names that reflect the purpose of the class.

2. **Call parent constructors:** When overriding `init`, always call the parent's `init` method if it exists.

3. **Use inheritance judiciously:** Only inherit when there's a clear "is-a" relationship.

4. **Override callbacks appropriately:** For Love2D classes, override only the callbacks you need.

5. **Use mixins for composition:** When inheritance doesn't fit, use mixins to add functionality.

6. **Document your classes:** Add comments to explain the purpose and usage of your classes.

## Error Handling

The ClassManager includes basic error checking:
- Attempting to create a class with an existing name will throw an error
- Accessing non-existent classes returns nil

Always check for class existence before using `getClass`.

## Performance Considerations

- Class creation is lightweight and can be done at startup
- Instance creation is efficient due to Lua's table-based objects
- Inheritance uses Lua's metatable system for optimal performance
- Registered classes use a simple table lookup for fast access

## Complete Example

```lua
local classManager = require("lib.classManager")

-- Base Entity class
local Entity = classManager.createLove2DClass("Entity")

function Entity:init(x, y)
    self.x = x or 0
    self.y = y or 0
    self.alive = true
end

function Entity:update(dt)
    -- Base update logic
end

function Entity:draw()
    if self.alive then
        love.graphics.circle("fill", self.x, self.y, 10)
    end
end

-- Player class inheriting from Entity
local Player = classManager.createLove2DClass("Player", Entity)

function Player:init(x, y)
    Entity.init(self, x, y)
    self.speed = 200
    self.health = 100
end

function Player:update(dt)
    Entity.update(self, dt)

    -- Movement
    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    elseif love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    end

    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    elseif love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    end
end

function Player:draw()
    love.graphics.setColor(0, 1, 0)  -- Green for player
    Entity.draw(self)
    love.graphics.setColor(1, 1, 1)  -- Reset color
end

-- Usage
local player = Player:new(400, 300)

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
end
```

This documentation covers all aspects of the ClassManager, providing a solid foundation for object-oriented programming in Lua with Love2D integration.