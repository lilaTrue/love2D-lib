# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

#### TimerManager
- **VSync support**: Added `setVSync()` and `isVSyncEnabled()` methods for vertical synchronization control
- **Unlimited FPS mode**: Added `setUnlimitedFPS()` for removing frame rate limitations
- **FPS history tracking**: Added `updateFPSHistory()` and `getAverageFPS()` for monitoring average FPS over time
- **Enhanced monitoring**: Added `getDeltaTime()` and `isAtTargetFPS()` methods for better performance analysis
- **Improved algorithm**: Refactored FPS limiting for better precision and reduced jitter

#### CollisionManager
- **Spatial grid system**: Added spatial partitioning for O(n²) → O(n) collision optimization
  - `setCellSize()`: Configure grid cell size
  - `enableGrid()`: Toggle spatial optimization
  - `updateGrid()`: Rebuild spatial grid with colliders
  - `checkCollisionsOptimized()`: Optimized collision detection using spatial grid
- **Layer system**: Unity-style collision layers and masks
  - `addLayer()`: Register collision layers
  - `setLayerMask()`: Define which layers can collide with each other
  - `canLayersCollide()`: Check layer collision compatibility
- **Tagging system**: Added tag support for colliders
  - `setTag()`: Assign tags to colliders
  - `findByTag()`: Find colliders by tag
  - `findByLayer()`: Find colliders by layer
- **Active state**: Added `setActive()` method to enable/disable colliders dynamically
- **Enhanced colliders**: RectCollider and CircleCollider now support layers and tags

#### SceneManager
- **Parameter passing**: Scenes can now receive parameters when loaded
  - `setScene(name, ...)`: Pass arguments to scene's load function
  - `pushScene(name, ...)`: Pass arguments when pushing scenes
  - `popScene(...)`: Pass arguments when resuming scenes
- **Data communication**: Added methods for inter-scene communication
  - `sendData(data)`: Send data to current scene
  - `getData()`: Retrieve data from current scene
- **Scene lifecycle**: Enhanced scene lifecycle with pause/resume
  - `pause()`: Called when scene is pushed to stack
  - `resume(...)`: Called when scene is popped from stack
  - `receiveData(data)`: Callback for receiving data
  - `sendData()`: Callback for sending data

#### ClassManager
- **Property system**: Added getter/setter support
  - `defineProperty()`: Define properties with custom getters and setters
- **Serialization**: Added save/load functionality
  - `serialize()`: Convert instances to plain Lua tables
  - `deserialize()`: Reconstruct instances from serialized data
  - Supports nested class instances
  - Configurable key exclusion
- **Cloning**: Added instance cloning
  - `clone()`: Create deep or shallow copies of instances
  - Handles nested class instances correctly

### Changed

#### TimerManager
- Refactored internal timing algorithm for better accuracy
- Improved sleep mechanism to reduce CPU usage while maintaining target FPS
- `getActualFPS()` now returns float instead of floor integer for better precision

#### CollisionManager
- `checkCollision()` now respects layer masks and active states
- Collider constructors now accept optional `layer` parameter
- Improved performance for large numbers of colliders when spatial grid is enabled

#### SceneManager
- Scene `load()` method now receives variadic parameters
- Enhanced scene stack management with proper pause/resume lifecycle
- Better memory management for scene transitions

### Fixed
- TimerManager: Fixed accumulator-based timing causing frame skips
- CollisionManager: Improved rect-circle collision detection edge cases
- SceneManager: Fixed scene stack corruption when popping empty stack

## [1.0.0] - 2024-10-30

### Added
- Initial release with four core libraries:
  - ClassManager: OOP system with inheritance
  - SceneManager: Scene state management with transitions
  - CollisionManager: Rect and Circle collision detection
  - TimerManager: FPS control and monitoring
- Comprehensive documentation in `/docs`
- Working examples for each library in `/example`

---

## Migration Guide

### TimerManager

**Before:**
```lua
TimerManager.update()
local fps = TimerManager.getActualFPS() -- Returns integer
```

**After:**
```lua
-- Optional: Enable VSync for smoother rendering
TimerManager.setVSync(true)

-- Optional: Track FPS history
TimerManager.updateFPSHistory()
local avgFPS = TimerManager.getAverageFPS()

TimerManager.update()
local fps = TimerManager.getActualFPS() -- Returns float
```

### CollisionManager

**Before:**
```lua
local collider = CollisionManager.RectCollider:new(x, y, w, h)
if CollisionManager.checkCollision(collider1, collider2) then
    -- Handle collision
end
```

**After:**
```lua
-- Setup layers
CollisionManager.addLayer("player", 1)
CollisionManager.addLayer("enemy", 2)
CollisionManager.setLayerMask("player", {"enemy"})

-- Create collider with layer
local collider = CollisionManager.RectCollider:new(x, y, w, h, 1)
collider:setTag("player")

-- Update spatial grid for optimization
CollisionManager.updateGrid(allColliders)

-- Optimized collision check
local collisions = CollisionManager.checkCollisionsOptimized(collider, allColliders)
```

### SceneManager

**Before:**
```lua
SceneManager:setScene("game")
```

**After:**
```lua
-- Pass data to scene
SceneManager:setScene("game", {level = 1, difficulty = "hard"})

-- In scene definition:
function GameScene:load(data)
    self.level = data.level
    self.difficulty = data.difficulty
end
```

### ClassManager

**Before:**
```lua
local Player = classManager.createClass("Player")
function Player:init(name)
    self.name = name
end
```

**After:**
```lua
local Player = classManager.createClass("Player")
function Player:init(name)
    self.name = name
end

-- Define property with validation
classManager.defineProperty(Player, "health",
    function(self, value) return value end, -- getter
    function(self, value) return math.max(0, value) end -- setter
)

-- Serialization
local playerData = classManager.serialize(player)
local restoredPlayer = classManager.deserialize(playerData)

-- Cloning
local playerClone = classManager.clone(player, true)
```
