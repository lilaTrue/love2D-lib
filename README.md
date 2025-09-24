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

## Documentation

Comprehensive documentation is available in the `docs/` directory:

- [`docs/class.md`](docs/class.md) - Complete ClassManager documentation
- [`docs/scene.md`](docs/scene.md) - Complete SceneManager documentation

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
4. **Check the examples** in `main.lua` and `player.lua` for practical usage

## Project Structure

```
love lib/
├── main.lua              # Example usage and Love2D entry point
├── player.lua            # Player class example
├── lib/
│   ├── SceneManager.lua  # Scene management system
│   └── classManager.lua  # OOP class system
└── docs/
    ├── class.md          # ClassManager documentation
    └── scene.md          # SceneManager documentation
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

## Roadmap

### Planned Libraries

- **InputManager**: Unified input handling system
- **UIManager**: UI component system with layouts and theming
- **EntityManager**: Entity-component system for complex games
- **ResourceManager**: Asset loading and caching system
- **AudioManager**: Advanced audio management with spatial audio
- **PhysicsManager**: Physics utilities and collision detection
- **AnimationManager**: Sprite animation and tweening system
- **SaveManager**: Data persistence and serialization
- **NetworkManager**: Multiplayer networking utilities

### Future Enhancements

- **Performance optimizations** for large-scale games
- **Additional Love2D platform support** (mobile, consoles)
- **Integration with popular Love2D libraries**
- **Visual editor tools** for scene and UI design
- **Unit testing framework** for library validation
- **Benchmarking tools** for performance analysis

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
- **Examples**: Look at `main.lua` and `player.lua` for implementation examples
- **Love2D Wiki**: Official Love2D documentation for framework-specific questions

## Acknowledgments

- Built for the [Love2D](https://love2d.org/) framework
- Inspired by common game development patterns
- Designed to complement Love2D's philosophy of simplicity and flexibility

---

**Note**: This is an active development project. Libraries may be updated with new features, bug fixes, and improvements. Check the documentation for the latest information on each library's capabilities.