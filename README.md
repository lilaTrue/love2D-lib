# Love2D Library Collection

A comprehensive collection of Lua libraries designed to streamline and enhance Love2D game development. This project aims to provide high-quality, reusable components that address common game development challenges, making it easier to create complex and feature-rich games.

## Project Overview

This is an ongoing, long-term project focused on developing complete, production-ready libraries for the Love2D framework. The goal is to create a robust ecosystem of tools that handle the repetitive and complex aspects of game development, allowing developers to focus on creating unique gameplay experiences.

### Philosophy

- **Modularity**: Each library is self-contained and can be used independently
- **Extensibility**: Libraries are designed to be easily extended and customized
- **Performance**: Optimized for Love2D's Lua environment
- **Documentation**: Comprehensive documentation for all features
- **Love2D Integration**: Seamless integration with Love2D's callback system

## Current Libraries

### SceneManager (`lib/SceneManager.lua`)

A powerful scene management system that handles multiple game states, transitions, and event forwarding.

**Features:**
- Scene registration and switching
- Scene stacking (push/pop functionality)
- Smooth transitions between scenes
- Automatic Love2D event forwarding
- Scene lifecycle management (load/unload)

**Use Cases:**
- Main menu ↔ Game level switching
- Pause menu overlays
- Level transitions
- Dialog systems

### ClassManager (`lib/classManager.lua`)

An object-oriented programming system for Lua with Love2D integration.

**Features:**
- Class creation with inheritance
- Love2D-specific class templates
- Mixin support for composition
- Automatic constructor chaining
- Class registration and management

**Use Cases:**
- Game entities (players, enemies, items)
- UI components
- Game systems (physics, AI, rendering)
- Data structures with behavior

### CollisionManager (`lib/CollisionManager.lua`)

A comprehensive collision detection system with Unity-style collision state tracking.

**Features:**
- Rectangle and circle collider types
- Efficient collision detection algorithms
- Unity-style collision states (enter, stay, exit)
- Point containment checking
- Debug visualization
- Support for mixed collider types

**Use Cases:**
- Player-enemy collision detection
- Platformer collision systems
- UI element interaction detection
- Physics-based game mechanics
- Real-time collision response

## Documentation

Comprehensive documentation is available in the `docs/` directory:

- [`docs/class.md`](docs/class.md) - Complete ClassManager documentation
- [`docs/scene.md`](docs/scene.md) - Complete SceneManager documentation
- [`docs/collision.md`](docs/collision.md) - Complete CollisionManager documentation

Each documentation file includes:
- Detailed API reference
- Usage examples
- Best practices
- Performance considerations
- Advanced techniques

## Getting Started

1. **Clone or download** the library files to your Love2D project
2. **Require the libraries** in your code:
   ```lua
   local SceneManager = require("lib.SceneManager")
   local classManager = require("lib.classManager")
   ```
3. **Follow the documentation** for implementation details
4. **Check the examples** in the `example/` folder:
    - `example/scene/` - Complete scene management demo with multiple scenes
    - `example/class/` - Advanced class system demo with inheritance and game objects
    - `example/collider/` - Interactive collision detection demo with Unity-style states

   Each example folder contains its own `lib/` copy and can be run independently with Love2D.

## Project Structure

```
love lib/
├── README.md            # Project documentation
├── lib/
│   ├── SceneManager.lua     # Scene management system
│   ├── classManager.lua     # OOP class system
│   └── CollisionManager.lua # Collision detection system
├── docs/
│   ├── class.md             # ClassManager documentation
│   ├── scene.md             # SceneManager documentation
│   └── collision.md         # CollisionManager documentation
└── example/
    ├── scene/
    │   ├── lib/         # Copy of libraries for standalone execution
    │   ├── main.lua     # Complete scene management demo
    │   └── scene.lua    # Scene definitions
    ├── class/
    │   ├── lib/         # Copy of libraries for standalone execution
    │   ├── main.lua     # Complete class system demo
    │   └── player.lua   # Advanced class examples
    └── collider/
        ├── lib/         # Copy of libraries for standalone execution
        └── main.lua     # Interactive collision detection demo
```

## Examples

### Basic Scene Management

```lua
local SceneManager = require("lib.SceneManager")

-- Create scenes
local menuScene = SceneManager:createScene("menu")
function menuScene:draw()
    love.graphics.print("Press SPACE to play", 10, 10)
end

local gameScene = SceneManager:createScene("game")
function gameScene:update(dt)
    -- Game logic here
end

-- Register and set scenes
SceneManager:addScene("menu", menuScene)
SceneManager:addScene("game", gameScene)
SceneManager:setScene("menu")
```

### Class-Based Game Objects

```lua
local classManager = require("lib.classManager")

local Player = classManager.createLove2DClass("Player")

function Player:init(x, y)
    self.x, self.y = x, y
    self.speed = 200
end

function Player:update(dt)
    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end
end

local player = Player:new(100, 100)
```

### Basic Collision Detection

```lua
local CollisionManager = require("lib.CollisionManager")

local playerRect = CollisionManager.RectCollider:new(100, 100, 32, 32)
local enemyCircle = CollisionManager.CircleCollider:new(200, 150, 20)

function love.update(dt)
    -- Move player
    if love.keyboard.isDown("d") then
        playerRect.x = playerRect.x + 200 * dt
    end

    -- Check collision
    if CollisionManager.checkCollision(playerRect, enemyCircle) then
        print("Collision detected!")
    end
end

function love.draw()
    playerRect:draw({0, 1, 0})  -- Green rectangle
    enemyCircle:draw({1, 0, 0}) -- Red circle
end
```

## Contributing

This is a personal project, but suggestions and feedback are welcome. If you have ideas for new libraries or improvements to existing ones, please create an issue or submit a pull request.

### Development Guidelines

- Follow Lua best practices
- Include comprehensive documentation
- Provide usage examples
- Ensure Love2D compatibility
- Test across different platforms when possible

## Requirements

- **Love2D**: Version 11.0 or later
- **Lua**: 5.1+ (included with Love2D)

## License

This project is released under the MIT License. Feel free to use, modify, and distribute the code for both personal and commercial projects.

## Support

- **Documentation**: Check the `docs/` folder for detailed guides
- **Examples**: Check the `example/` folder for complete working demos:
  - `example/scene/` - Scene management demo
  - `example/class/` - Class system demo
  - `example/collider/` - Collision detection demo
- **Love2D Wiki**: Official Love2D documentation for framework-specific questions

## Acknowledgments

- Built for the [Love2D](https://love2d.org/) framework
- Inspired by common game development patterns
- Designed to complement Love2D's philosophy of simplicity and flexibility

---

**Note**: This is an active development project. Libraries may be updated with new features, bug fixes, and improvements. Check the documentation for the latest information on each library's capabilities.