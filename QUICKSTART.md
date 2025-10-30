# Quick Start Guide

Get started with Love2D Library Collection in 5 minutes!

## Installation

1. **Download the library**:
   ```bash
   git clone https://github.com/lilaTrue/love2D-librairy.git
   ```

2. **Copy to your project**:
   ```
   your-game/
   ├── main.lua
   └── lib/
       ├── classManager.lua
       ├── SceneManager.lua
       ├── CollisionManager.lua
       └── TimerManager.lua
   ```

3. **Require in your code**:
   ```lua
   local classManager = require("lib.classManager")
   local SceneManager = require("lib.SceneManager")
   local CollisionManager = require("lib.CollisionManager")
   local TimerManager = require("lib.TimerManager")
   ```

---

## 🎯 Quick Examples

### 1. Scene Management (30 seconds)

```lua
-- main.lua
local SceneManager = require("lib.SceneManager")

-- Create menu scene
local menuScene = SceneManager:createScene("menu")
function menuScene:draw()
    love.graphics.print("Press SPACE to start", 100, 100)
end
function menuScene:keypressed(key)
    if key == "space" then
        SceneManager:setScene("game", {level = 1})
    end
end

-- Create game scene
local gameScene = SceneManager:createScene("game")
function gameScene:load(data)
    self.level = data.level
end
function gameScene:draw()
    love.graphics.print("Level: " .. self.level, 100, 100)
end

-- Register and start
SceneManager:addScene("menu", menuScene)
SceneManager:addScene("game", gameScene)
SceneManager:setScene("menu")

-- Love2D callbacks
function love.update(dt) SceneManager:update(dt) end
function love.draw() SceneManager:draw() end
function love.keypressed(k, s, r) SceneManager:keypressed(k, s, r) end
```

**Run with**: `love .`

---

### 2. Collision Detection (1 minute)

```lua
-- main.lua
local CollisionManager = require("lib.CollisionManager")

-- Create colliders
local player = CollisionManager.RectCollider:new(100, 100, 50, 50)
local enemy = CollisionManager.CircleCollider:new(200, 200, 30)

function love.update(dt)
    -- Move player with arrow keys
    if love.keyboard.isDown("right") then player.x = player.x + 200 * dt end
    if love.keyboard.isDown("left") then player.x = player.x - 200 * dt end
    if love.keyboard.isDown("down") then player.y = player.y + 200 * dt end
    if love.keyboard.isDown("up") then player.y = player.y - 200 * dt end
    
    -- Check collision
    if CollisionManager.checkCollision(player, enemy) then
        print("HIT!")
    end
end

function love.draw()
    player:draw({0, 1, 0})  -- Green
    enemy:draw({1, 0, 0})   -- Red
end
```

---

### 3. FPS Control (30 seconds)

```lua
-- main.lua
local TimerManager = require("lib.TimerManager")

function love.load()
    TimerManager.setFPS(60)  -- Lock to 60 FPS
end

function love.update(dt)
    TimerManager.update()  -- Maintain target FPS
    TimerManager.updateFPSHistory()  -- Track FPS
end

function love.draw()
    love.graphics.print("FPS: " .. math.floor(TimerManager.getAverageFPS()), 10, 10)
end
```

---

### 4. Class System (2 minutes)

```lua
-- main.lua
local classManager = require("lib.classManager")

-- Create Player class
local Player = classManager.createClass("Player")

function Player:init(name, x, y)
    self.name = name
    self.x = x
    self.y = y
    self.health = 100
end

function Player:update(dt)
    if love.keyboard.isDown("d") then self.x = self.x + 200 * dt end
    if love.keyboard.isDown("a") then self.x = self.x - 200 * dt end
end

function Player:draw()
    love.graphics.circle("fill", self.x, self.y, 20)
    love.graphics.print(self.name, self.x - 20, self.y - 40)
end

-- Create instance
local player = Player:new("Hero", 400, 300)

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
end
```

---

## 🚀 Advanced Features

### Optimized Collision (Many Objects)

```lua
local CollisionManager = require("lib.CollisionManager")

-- Setup layers
CollisionManager.addLayer("player", 1)
CollisionManager.addLayer("enemy", 2)
CollisionManager.setLayerMask("player", {"enemy"})

-- Enable spatial optimization
CollisionManager.enableGrid(true)
CollisionManager.setCellSize(100)

-- Create colliders with layers
local player = CollisionManager.RectCollider:new(x, y, w, h, 1)
local enemies = {}
for i = 1, 100 do
    local enemy = CollisionManager.CircleCollider:new(
        math.random(800), 
        math.random(600), 
        20, 
        2  -- enemy layer
    )
    table.insert(enemies, enemy)
end

function love.update(dt)
    -- Update spatial grid
    local allColliders = {player}
    for _, e in ipairs(enemies) do
        table.insert(allColliders, e)
    end
    CollisionManager.updateGrid(allColliders)
    
    -- Fast collision check
    local hits = CollisionManager.checkCollisionsOptimized(player, allColliders)
    for _, hit in ipairs(hits) do
        -- Handle collision
    end
end
```

### Save/Load System

```lua
local classManager = require("lib.classManager")

-- Define saveable class
local GameState = classManager.createClass("GameState")
function GameState:init()
    self.level = 1
    self.score = 0
    self.inventory = {}
end

-- Save game
function saveGame(state)
    local data = classManager.serialize(state)
    local str = "return " .. tableToString(data)  -- Use your serializer
    love.filesystem.write("save.lua", str)
end

-- Load game
function loadGame()
    local str = love.filesystem.read("save.lua")
    local data = loadstring(str)()
    return classManager.deserialize(data)
end

-- Usage
local state = GameState:new()
state.level = 5
state.score = 1000
saveGame(state)

-- Later...
local loadedState = loadGame()
print(loadedState.level)  -- 5
print(loadedState.score)  -- 1000
```

---

## 📚 Next Steps

1. **Read Documentation**: Check `/docs` for complete API reference
2. **Run Examples**: Explore `/example` for full demos
3. **Read IMPROVEMENTS.md**: Learn about performance optimization
4. **Check CHANGELOG.md**: See all features and migration guide

---

## 🎮 Complete Game Template

```lua
-- main.lua
local classManager = require("lib.classManager")
local SceneManager = require("lib.SceneManager")
local CollisionManager = require("lib.CollisionManager")
local TimerManager = require("lib.TimerManager")

-- Player class
local Player = classManager.createClass("Player")
function Player:init(x, y)
    self.x, self.y = x, y
    self.collider = CollisionManager.RectCollider:new(x, y, 32, 32, 1)
end
function Player:update(dt)
    if love.keyboard.isDown("d") then self.x = self.x + 200 * dt end
    if love.keyboard.isDown("a") then self.x = self.x - 200 * dt end
    self.collider.x = self.x
    self.collider.y = self.y
end
function Player:draw()
    self.collider:draw({0, 1, 0})
end

-- Game scene
local gameScene = SceneManager:createScene("game")
function gameScene:load(data)
    self.player = Player:new(400, 300)
    self.level = data and data.level or 1
end
function gameScene:update(dt)
    self.player:update(dt)
end
function gameScene:draw()
    self.player:draw()
    love.graphics.print("Level: " .. self.level, 10, 10)
    love.graphics.print("FPS: " .. math.floor(TimerManager.getAverageFPS()), 10, 30)
end

-- Initialize
SceneManager:addScene("game", gameScene)
SceneManager:setScene("game", {level = 1})
TimerManager.setFPS(60)

-- Love2D callbacks
function love.update(dt)
    TimerManager.update()
    TimerManager.updateFPSHistory()
    SceneManager:update(dt)
end

function love.draw()
    SceneManager:draw()
end

function love.keypressed(k, s, r)
    SceneManager:keypressed(k, s, r)
end
```

**That's it!** You now have a working game with:
- ✅ Scene management
- ✅ Player movement
- ✅ Collision detection
- ✅ FPS control
- ✅ Class system

---

## 💡 Tips

1. **Start simple**: Use one library at a time
2. **Read examples**: Copy-paste and modify
3. **Check docs**: API reference has all details
4. **Ask questions**: Create GitHub issues

---

## 🔗 Resources

- [Full Documentation](docs/)
- [Examples](example/)
- [CHANGELOG](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)

Happy coding! 🎮✨
