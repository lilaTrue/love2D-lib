# Love2D Library Collection

[![CI Status](https://github.com/lilaTrue/love2D-librairy/workflows/CI%20-%20Tests%20%26%20Linting/badge.svg)](https://github.com/lilaTrue/love2D-librairy/actions)
[![Release](https://github.com/lilaTrue/love2D-librairy/workflows/CD%20-%20Release%20%26%20Publish/badge.svg)](https://github.com/lilaTrue/love2D-librairy/releases)
[![Documentation](https://github.com/lilaTrue/love2D-librairy/workflows/Documentation%20Update/badge.svg)](https://lilaTrue.github.io/love2D-librairy/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Love2D](https://img.shields.io/badge/L%C3%96VE-11.0+-EA316E.svg)](https://love2d.org/)

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
- **NEW: Parameter passing** between scenes
- **NEW: Data communication** system (sendData/receiveData)
- **NEW: Enhanced lifecycle** with pause/resume callbacks
- Scene stacking (push/pop functionality)
- Smooth transitions between scenes
- Automatic Love2D event forwarding
- Scene lifecycle management (load/unload)

**Use Cases:**
- Main menu ↔ Game level switching with data transfer
- Pause menu overlays with state preservation
- Level transitions with score/inventory passing
- Dialog systems with return values
- Multi-scene workflows (shops, inventory, quests)

### ClassManager (`lib/classManager.lua`)

An object-oriented programming system for Lua with Love2D integration.

**Features:**
- Class creation with inheritance
- Love2D-specific class templates
- Mixin support for composition
- **NEW: Property system** with getters/setters
- **NEW: Serialization/Deserialization** for save systems
- **NEW: Deep cloning** for instance duplication
- Automatic constructor chaining
- Class registration and management

**Use Cases:**
- Game entities (players, enemies, items)
- UI components
- Game systems (physics, AI, rendering)
- Data structures with behavior
- Save/load game state
- Network serialization

### CollisionManager (`lib/CollisionManager.lua`)

A comprehensive collision detection system with Unity-style collision state tracking and spatial optimization.

**Features:**
- Rectangle and circle collider types
- **NEW: Spatial grid partitioning** for O(n) performance
- **NEW: Layer-based collision filtering** (Unity-style)
- **NEW: Tag system** for collider categorization
- **NEW: Active state management** for dynamic enable/disable
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
- Large-scale collision optimization (100+ colliders)

### TimerManager (`lib/TimerManager.lua`)

A FPS management system for controlling and monitoring frame rates in Love2D applications.

**Features:**
- Target FPS setting and enforcement
- **NEW: VSync support** for hardware synchronization
- **NEW: Unlimited FPS mode** for benchmarking
- **NEW: FPS history tracking** and average calculation
- Real-time FPS monitoring with improved precision
- Frame time calculation
- Automatic frame rate limiting
- **NEW: Target FPS validation** with tolerance checking
- Integration with Love2D's update loop

**Use Cases:**
- Maintaining consistent game speed across different hardware
- Power management and battery life optimization
- Performance testing and benchmarking
- Synchronizing animations and effects
- Professional FPS monitoring and debugging

## Documentation

Comprehensive documentation is available in the `docs/` directory:

- [`docs/class.md`](docs/class.md) - Complete ClassManager documentation
- [`docs/scene.md`](docs/scene.md) - Complete SceneManager documentation
- [`docs/collision.md`](docs/collision.md) - Complete CollisionManager documentation
- [`docs/timer.md`](docs/timer.md) - Complete TimerManager documentation

Each documentation file includes:
- Detailed API reference
- Usage examples
- Best practices
- Performance considerations
- Advanced techniques

## Getting Started

### Installation

1. **Clone or download** the library files to your Love2D project
2. **Require the libraries** in your code:
   ```lua
   local SceneManager = require("lib.SceneManager")
   local classManager = require("lib.classManager")
   local CollisionManager = require("lib.CollisionManager")
   local TimerManager = require("lib.TimerManager")
   ```
3. **Follow the documentation** for implementation details
4. **Check the examples** in the `example/` folder

### What's New (Latest Update)

🚀 **Major Performance Improvements**
- **CollisionManager**: Spatial grid optimization reduces collision checks from O(n²) to O(n)
- **TimerManager**: Enhanced FPS algorithm with VSync support and better precision

✨ **New Features**
- **Scene Data Passing**: Transfer data between scenes seamlessly
- **Collision Layers**: Unity-style layer masks for selective collision
- **Serialization**: Save and load class instances easily
- **Property System**: Define getters/setters for class properties

📚 **See [CHANGELOG.md](CHANGELOG.md) for complete details and migration guide**
    - `example/scene/` - Complete scene management demo with multiple scenes
    - `example/class/` - Advanced class system demo with inheritance and game objects
    - `example/collider/` - Interactive collision detection demo with Unity-style states

   Each example folder contains its own `lib/` copy and can be run independently with Love2D.

## Project Structure

```
love lib/
├── README.md            # Project documentation
├── main.lua             # TimerManager demonstration
├── lib/
│   ├── SceneManager.lua     # Scene management system
│   ├── classManager.lua     # OOP class system
│   ├── CollisionManager.lua # Collision detection system
│   └── TimerManager.lua     # FPS management system
├── docs/
│   ├── class.md             # ClassManager documentation
│   ├── scene.md             # SceneManager documentation
│   ├── collision.md         # CollisionManager documentation
│   └── timer.md             # TimerManager documentation
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

This project is released under the [MIT License](LICENSE). Feel free to use, modify, and distribute the code for both personal and commercial projects.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes, new features, and migration guides.

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
