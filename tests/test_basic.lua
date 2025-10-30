-- tests/test_basic.lua
-- Basic tests for Love2D Library Collection
-- Run with: busted tests/

-- Mock love global for testing
_G.love = {
    timer = {
        getTime = function() return 0 end,
        getDelta = function() return 0.016 end,
        sleep = function() end
    },
    graphics = {
        setColor = function() end,
        rectangle = function() end,
        circle = function() end,
        print = function() end
    },
    window = {
        setVSync = function() end
    }
}

describe("ClassManager", function()
    local classManager
    
    before_each(function()
        classManager = require("lib.classManager")
    end)
    
    it("should create a class", function()
        local TestClass = classManager.createClass("TestClass")
        assert.is_not_nil(TestClass)
        assert.equals("TestClass", TestClass.__name)
    end)
    
    it("should create instances", function()
        local TestClass = classManager.createClass("TestInstance")
        function TestClass:init(value)
            self.value = value
        end
        
        local instance = TestClass:new(42)
        assert.is_not_nil(instance)
        assert.equals(42, instance.value)
    end)
    
    it("should serialize and deserialize", function()
        local TestClass = classManager.createClass("SerializeTest")
        function TestClass:init(name)
            self.name = name
        end
        
        local instance = TestClass:new("test")
        local serialized = classManager.serialize(instance)
        
        assert.is_not_nil(serialized)
        assert.equals("SerializeTest", serialized.__className)
        assert.equals("test", serialized.name)
        
        local deserialized = classManager.deserialize(serialized)
        assert.equals("test", deserialized.name)
    end)
end)

describe("CollisionManager", function()
    local CollisionManager
    
    before_each(function()
        CollisionManager = require("lib.CollisionManager")
    end)
    
    it("should create rect colliders", function()
        local collider = CollisionManager.RectCollider:new(10, 20, 30, 40)
        assert.is_not_nil(collider)
        assert.equals(10, collider.x)
        assert.equals(20, collider.y)
        assert.equals(30, collider.w)
        assert.equals(40, collider.h)
    end)
    
    it("should create circle colliders", function()
        local collider = CollisionManager.CircleCollider:new(10, 20, 15)
        assert.is_not_nil(collider)
        assert.equals(10, collider.x)
        assert.equals(20, collider.y)
        assert.equals(15, collider.r)
    end)
    
    it("should detect rect-rect collision", function()
        local rect1 = CollisionManager.RectCollider:new(0, 0, 50, 50)
        local rect2 = CollisionManager.RectCollider:new(25, 25, 50, 50)
        local rect3 = CollisionManager.RectCollider:new(100, 100, 50, 50)
        
        assert.is_true(CollisionManager.checkCollision(rect1, rect2))
        assert.is_false(CollisionManager.checkCollision(rect1, rect3))
    end)
    
    it("should support layers", function()
        CollisionManager.addLayer("test1", 1)
        CollisionManager.addLayer("test2", 2)
        
        assert.equals(1, CollisionManager.layers.test1)
        assert.equals(2, CollisionManager.layers.test2)
    end)
end)

describe("SceneManager", function()
    local SceneManager
    
    before_each(function()
        SceneManager = require("lib.SceneManager")
    end)
    
    it("should create scenes", function()
        local scene = SceneManager:createScene("testScene")
        assert.is_not_nil(scene)
        assert.equals("testScene", scene.name)
    end)
    
    it("should add and get scenes", function()
        local scene = SceneManager:createScene("testAdd")
        SceneManager:addScene("testAdd", scene)
        
        assert.is_true(SceneManager:hasScene("testAdd"))
    end)
    
    it("should set current scene", function()
        local scene = SceneManager:createScene("testSet")
        SceneManager:addScene("testSet", scene)
        SceneManager:setScene("testSet")
        
        assert.equals(scene, SceneManager:getCurrentScene())
    end)
end)

describe("TimerManager", function()
    local TimerManager
    
    before_each(function()
        TimerManager = require("lib.TimerManager")
    end)
    
    it("should set and get FPS", function()
        TimerManager.setFPS(60)
        assert.equals(60, TimerManager.getFPS())
        
        TimerManager.setFPS(30)
        assert.equals(30, TimerManager.getFPS())
    end)
    
    it("should get frame time", function()
        TimerManager.setFPS(60)
        local frameTime = TimerManager.getFrameTime()
        assert.is_near(1/60, frameTime, 0.001)
    end)
    
    it("should handle unlimited FPS", function()
        TimerManager.setUnlimitedFPS()
        -- Should not error
        assert.is_not_nil(TimerManager)
    end)
end)
