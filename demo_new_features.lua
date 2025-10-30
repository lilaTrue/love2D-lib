-- demo_new_features.lua
-- Quick demonstration of new features added to Love2D Library Collection
-- This file showcases the latest improvements across all libraries

local classManager = require("lib.classManager")
local CollisionManager = require("lib.CollisionManager")
local SceneManager = require("lib.SceneManager")
local TimerManager = require("lib.TimerManager")

-- ============================================================================
-- DEMO 1: ClassManager - Serialization & Properties
-- ============================================================================

print("\n=== ClassManager Demo ===")

-- Create a Player class
local Player = classManager.createClass("Player")

function Player:init(name, health)
    self._name = name
    self._health = health
    self.inventory = {"Sword", "Shield"}
end

-- Define a property with validation
classManager.defineProperty(Player, "health",
    function(self, value) return value end, -- getter
    function(self, value) 
        return math.max(0, math.min(100, value)) -- clamp 0-100
    end -- setter
)

-- Create and test player
local player = Player:new("Hero", 100)
print("Player created:", player._name)

-- Serialize player data (for save system)
local savedData = classManager.serialize(player)
print("Serialized data:", savedData.__className)

-- Clone player
local playerClone = classManager.clone(player, true)
playerClone._name = "Clone"
print("Cloned player:", playerClone._name, "Original:", player._name)


-- ============================================================================
-- DEMO 2: CollisionManager - Layers & Spatial Grid
-- ============================================================================

print("\n=== CollisionManager Demo ===")

-- Setup collision layers
CollisionManager.addLayer("player", 1)
CollisionManager.addLayer("enemy", 2)
CollisionManager.addLayer("projectile", 3)

-- Set layer masks (what can collide with what)
CollisionManager.setLayerMask("player", {"enemy", "projectile"})
CollisionManager.setLayerMask("enemy", {"player", "projectile"})
CollisionManager.setLayerMask("projectile", {"player", "enemy"})

print("Layers configured: player, enemy, projectile")

-- Create colliders with layers and tags
local playerCollider = CollisionManager.RectCollider:new(100, 100, 50, 50, 1)
playerCollider:setTag("player")

local enemyCollider = CollisionManager.CircleCollider:new(200, 200, 30, 2)
enemyCollider:setTag("enemy")

local wallCollider = CollisionManager.RectCollider:new(300, 100, 50, 100)
wallCollider:setLayer(nil) -- No layer = collides with all

print("Created colliders with layers and tags")

-- Enable spatial grid for optimization
CollisionManager.enableGrid(true)
CollisionManager.setCellSize(100)

local allColliders = {playerCollider, enemyCollider, wallCollider}
CollisionManager.updateGrid(allColliders)

print("Spatial grid enabled (cell size: 100)")

-- Check if layers can collide
local canCollide = CollisionManager.canLayersCollide(1, 2)
print("Can player collide with enemy?", canCollide)


-- ============================================================================
-- DEMO 3: SceneManager - Data Passing & Communication
-- ============================================================================

print("\n=== SceneManager Demo ===")

-- Create a game scene that receives data
local GameScene = SceneManager:createScene("game")

function GameScene:load(levelData)
    if levelData then
        self.level = levelData.level or 1
        self.difficulty = levelData.difficulty or "normal"
        print("Game scene loaded with level:", self.level, "difficulty:", self.difficulty)
    end
end

function GameScene:pause()
    print("Game paused - scene pushed to stack")
end

function GameScene:resume(returnData)
    print("Game resumed - scene popped from stack")
    if returnData then
        print("Received data from previous scene:", returnData.action)
    end
end

function GameScene:sendData()
    return {score = 1000, lives = 3}
end

-- Create a pause menu scene
local PauseScene = SceneManager:createScene("pause")

function PauseScene:load()
    print("Pause menu loaded")
end

function PauseScene:unload()
    print("Pause menu unloaded")
end

-- Register scenes
SceneManager:addScene("game", GameScene)
SceneManager:addScene("pause", PauseScene)

-- Load game with data
print("\nLoading game scene with parameters...")
SceneManager:setScene("game", {level = 5, difficulty = "hard"})

-- Simulate pushing pause menu
print("\nPushing pause menu...")
SceneManager:pushScene("pause")

-- Get data from current scene (game is on stack)
print("\nPopping pause menu...")
SceneManager:popScene({action = "continue"})


-- ============================================================================
-- DEMO 4: TimerManager - VSync & FPS History
-- ============================================================================

print("\n=== TimerManager Demo ===")

-- Set target FPS
TimerManager.setFPS(60)
print("Target FPS set to:", TimerManager.getFPS())

-- Enable VSync (optional)
-- TimerManager.setVSync(true)
-- print("VSync enabled:", TimerManager.isVSyncEnabled())

-- Simulate FPS history
TimerManager.updateFPSHistory()
print("FPS history updated")

-- Check if at target FPS (with 5 FPS tolerance)
local atTarget = TimerManager.isAtTargetFPS(5)
print("Running at target FPS:", atTarget)

print("Delta time:", string.format("%.4f", TimerManager.getDeltaTime()))


-- ============================================================================
-- SUMMARY
-- ============================================================================

print("\n" .. string.rep("=", 60))
print("DEMO COMPLETE - New Features Summary:")
print(string.rep("=", 60))
print("✅ ClassManager: Serialization, Properties, Cloning")
print("✅ CollisionManager: Layers, Tags, Spatial Grid")
print("✅ SceneManager: Data Passing, Pause/Resume, Communication")
print("✅ TimerManager: VSync, FPS History, Enhanced Monitoring")
print(string.rep("=", 60))
print("\nRun this file with: love .")
print("Check CHANGELOG.md for complete migration guide")
print(string.rep("=", 60) .. "\n")
