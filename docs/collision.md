# CollisionManager Documentation

The CollisionManager is a comprehensive collision detection system for Love2D, providing efficient and flexible collision handling between various geometric shapes. It supports rectangle and circle colliders with both basic collision detection and Unity-style collision state tracking.

## Overview

The CollisionManager allows you to:
- Create rectangle and circle colliders
- Perform collision detection between different collider types
- Track collision states (enter, stay, exit) like Unity
- Visualize colliders for debugging
- Check point containment within colliders
- Build complex collision systems for games

## Basic Usage

### Requiring the CollisionManager

```lua
local CollisionManager = require("lib.CollisionManager")
```

## Collider Creation

### RectCollider

Represents an axis-aligned bounding box (AABB) collider.

#### RectCollider:new(x, y, w, h)

Creates a new rectangle collider.

**Parameters:**
- `x` (number): X-coordinate of the top-left corner
- `y` (number): Y-coordinate of the top-left corner
- `w` (number): Width of the rectangle
- `h` (number): Height of the rectangle

**Returns:** A new RectCollider instance

**Example:**
```lua
local rect = CollisionManager.RectCollider:new(100, 100, 50, 50)
```

#### RectCollider:getBounds()

Returns the bounding box coordinates.

**Returns:** left, top, right, bottom (numbers)

**Example:**
```lua
local left, top, right, bottom = rect:getBounds()
```

#### RectCollider:draw(color)

Draws the rectangle collider for debugging.

**Parameters:**
- `color` (table, optional): RGBA color table {r, g, b, a}, defaults to white

**Example:**
```lua
rect:draw({1, 0, 0})  -- Red outline
```

#### RectCollider:containsPoint(px, py)

Checks if a point is inside the rectangle.

**Parameters:**
- `px` (number): X-coordinate of the point
- `py` (number): Y-coordinate of the point

**Returns:** boolean - true if the point is inside

**Example:**
```lua
if rect:containsPoint(love.mouse.getX(), love.mouse.getY()) then
    print("Mouse is over rectangle")
end
```

### CircleCollider

Represents a circular collider.

#### CircleCollider:new(x, y, r)

Creates a new circle collider.

**Parameters:**
- `x` (number): X-coordinate of the circle center
- `y` (number): Y-coordinate of the circle center
- `r` (number): Radius of the circle

**Returns:** A new CircleCollider instance

**Example:**
```lua
local circle = CollisionManager.CircleCollider:new(200, 150, 30)
```

#### CircleCollider:getBounds()

Returns the bounding box coordinates.

**Returns:** left, top, right, bottom (numbers)

**Example:**
```lua
local left, top, right, bottom = circle:getBounds()
```

#### CircleCollider:draw(color)

Draws the circle collider for debugging.

**Parameters:**
- `color` (table, optional): RGBA color table {r, g, b, a}, defaults to white

**Example:**
```lua
circle:draw({0, 1, 0})  -- Green outline
```

#### CircleCollider:containsPoint(px, py)

Checks if a point is inside the circle.

**Parameters:**
- `px` (number): X-coordinate of the point
- `py` (number): Y-coordinate of the point

**Returns:** boolean - true if the point is inside

**Example:**
```lua
if circle:containsPoint(love.mouse.getX(), love.mouse.getY()) then
    print("Mouse is over circle")
end
```

## Collision Detection

### checkCollision(collider1, collider2)

Performs collision detection between two colliders.

**Parameters:**
- `collider1` (RectCollider|CircleCollider): First collider
- `collider2` (RectCollider|CircleCollider): Second collider

**Returns:** boolean - true if the colliders are colliding

**Supported Combinations:**
- Rectangle vs Rectangle
- Circle vs Circle
- Rectangle vs Circle

**Example:**
```lua
if CollisionManager.checkCollision(playerRect, enemyCircle) then
    print("Collision detected!")
end
```

### checkCollisionEnter(collider1, collider2, wasColliding)

Checks if collision just started (like Unity's OnCollisionEnter).

**Parameters:**
- `collider1` (RectCollider|CircleCollider): First collider
- `collider2` (RectCollider|CircleCollider): Second collider
- `wasColliding` (boolean): Whether they were colliding in the previous frame

**Returns:** boolean - true if collision just started

**Example:**
```lua
local isColliding = CollisionManager.checkCollision(collider1, collider2)
local entered = CollisionManager.checkCollisionEnter(collider1, collider2, previousColliding)
previousColliding = isColliding

if entered then
    print("Collision entered!")
end
```

### checkCollisionStay(collider1, collider2, wasColliding)

Checks if collision is continuing (like Unity's OnCollisionStay).

**Parameters:**
- `collider1` (RectCollider|CircleCollider): First collider
- `collider2` (RectCollider|CircleCollider): Second collider
- `wasColliding` (boolean): Whether they were colliding in the previous frame

**Returns:** boolean - true if collision is ongoing

**Example:**
```lua
local stayed = CollisionManager.checkCollisionStay(collider1, collider2, previousColliding)
if stayed then
    -- Handle continuous collision
end
```

### checkCollisionExit(collider1, collider2, wasColliding)

Checks if collision just ended (like Unity's OnCollisionExit).

**Parameters:**
- `collider1` (RectCollider|CircleCollider): First collider
- `collider2` (RectCollider|CircleCollider): Second collider
- `wasColliding` (boolean): Whether they were colliding in the previous frame

**Returns:** boolean - true if collision just ended

**Example:**
```lua
local exited = CollisionManager.checkCollisionExit(collider1, collider2, previousColliding)
if exited then
    print("Collision exited!")
end
```

## Advanced Collision Detection

### checkRectRect(r1, r2)

Direct rectangle-rectangle collision detection.

**Parameters:**
- `r1` (RectCollider): First rectangle
- `r2` (RectCollider): Second rectangle

**Returns:** boolean

### checkCircleCircle(c1, c2)

Direct circle-circle collision detection.

**Parameters:**
- `c1` (CircleCollider): First circle
- `c2` (CircleCollider): Second circle

**Returns:** boolean

### checkRectCircle(r, c)

Direct rectangle-circle collision detection.

**Parameters:**
- `r` (RectCollider): The rectangle
- `c` (CircleCollider): The circle

**Returns:** boolean

**Algorithm:** Uses the closest point on rectangle to circle center method for accurate detection.

## Usage Patterns

### Basic Collision Detection

```lua
local playerRect = CollisionManager.RectCollider:new(100, 100, 32, 32)
local enemyCircle = CollisionManager.CircleCollider:new(150, 120, 20)

function love.update(dt)
    -- Move player
    if love.keyboard.isDown("d") then
        playerRect.x = playerRect.x + 200 * dt
    end

    -- Check collision
    if CollisionManager.checkCollision(playerRect, enemyCircle) then
        print("Player hit enemy!")
    end
end

function love.draw()
    playerRect:draw({0, 1, 0})  -- Green
    enemyCircle:draw({1, 0, 0}) -- Red
end
```

### Unity-Style Collision States

```lua
local collider1 = CollisionManager.RectCollider:new(100, 100, 50, 50)
local collider2 = CollisionManager.CircleCollider:new(200, 150, 30)
local previousCollision = false

function love.update(dt)
    -- Move colliders
    collider1.x = collider1.x + 100 * dt

    -- Check collision states
    local isColliding = CollisionManager.checkCollision(collider1, collider2)
    local entered = CollisionManager.checkCollisionEnter(collider1, collider2, previousCollision)
    local stayed = CollisionManager.checkCollisionStay(collider1, collider2, previousCollision)
    local exited = CollisionManager.checkCollisionExit(collider1, collider2, previousCollision)

    -- Update previous state
    previousCollision = isColliding

    -- Handle states
    if entered then
        print("Collision started!")
        -- Play sound, apply damage, etc.
    elseif stayed then
        -- Continuous collision logic
    elseif exited then
        print("Collision ended!")
        -- Reset states, etc.
    end
end
```

### Point Containment

```lua
local buttonRect = CollisionManager.RectCollider:new(100, 100, 200, 50)

function love.mousepressed(x, y, button)
    if button == 1 and buttonRect:containsPoint(x, y) then
        print("Button clicked!")
    end
end

function love.draw()
    buttonRect:draw()
    love.graphics.print("Click me!", 150, 115)
end
```

### Multiple Colliders Management

```lua
local colliders = {
    CollisionManager.RectCollider:new(100, 100, 50, 50),
    CollisionManager.CircleCollider:new(200, 150, 30),
    CollisionManager.RectCollider:new(300, 200, 40, 60)
}

function checkAllCollisions()
    for i = 1, #colliders do
        for j = i + 1, #colliders do
            if CollisionManager.checkCollision(colliders[i], colliders[j]) then
                print("Collision between collider " .. i .. " and " .. j)
            end
        end
    end
end

function love.draw()
    for _, collider in ipairs(colliders) do
        collider:draw()
    end
end
```

## Best Practices

1. **Update colliders with game objects:** Keep collider positions synchronized with your game entities.

2. **Use appropriate collider types:** Rectangles for axis-aligned objects, circles for radial objects.

3. **Cache collision results:** For performance-critical scenarios, cache collision checks when possible.

4. **Use collision states wisely:** Collision enter/exit/stay provide better control than just checking current collision.

5. **Debug with visualization:** Use the draw() methods during development to visualize colliders.

6. **Consider performance:** For many colliders, consider spatial partitioning techniques.

7. **Handle edge cases:** Be aware of floating-point precision issues with very small or fast-moving objects.

## Error Handling

The CollisionManager includes basic validation:
- Invalid collider types will return false for collision checks
- Missing parameters in constructors use defaults (0)

Always ensure colliders are properly initialized before use.

## Performance Considerations

- Collision detection is O(1) for all supported collider combinations
- Point containment checks are very fast
- Drawing colliders has minimal performance impact (mainly for debugging)
- For large numbers of colliders, consider broad-phase collision detection

## Complete Example

```lua
local CollisionManager = require("lib.CollisionManager")

-- Player setup
local player = {
    collider = CollisionManager.RectCollider:new(400, 300, 32, 32),
    speed = 200,
    color = {0, 1, 0}
}

-- Enemies setup
local enemies = {}
for i = 1, 5 do
    local enemy = {
        collider = CollisionManager.CircleCollider:new(
            math.random(0, 800),
            math.random(0, 600),
            15
        ),
        speed = 50,
        color = {1, 0, 0},
        previousCollision = false
    }
    table.insert(enemies, enemy)
end

function love.update(dt)
    -- Move player
    if love.keyboard.isDown("w") then player.collider.y = player.collider.y - player.speed * dt end
    if love.keyboard.isDown("s") then player.collider.y = player.collider.y + player.speed * dt end
    if love.keyboard.isDown("a") then player.collider.x = player.collider.x - player.speed * dt end
    if love.keyboard.isDown("d") then player.collider.x = player.collider.x + player.speed * dt end

    -- Move enemies randomly
    for _, enemy in ipairs(enemies) do
        enemy.collider.x = enemy.collider.x + (math.random() - 0.5) * enemy.speed * dt
        enemy.collider.y = enemy.collider.y + (math.random() - 0.5) * enemy.speed * dt

        -- Keep enemies in bounds
        enemy.collider.x = math.max(0, math.min(800 - 30, enemy.collider.x))
        enemy.collider.y = math.max(0, math.min(600 - 30, enemy.collider.y))

        -- Check collision with player
        local isColliding = CollisionManager.checkCollision(player.collider, enemy.collider)
        local entered = CollisionManager.checkCollisionEnter(player.collider, enemy.collider, enemy.previousCollision)

        if entered then
            print("Player collided with enemy!")
            -- Handle collision (damage, sound, etc.)
        end

        enemy.previousCollision = isColliding

        -- Change color based on collision
        enemy.color = isColliding and {1, 1, 0} or {1, 0, 0}  -- Yellow when colliding
    end
end

function love.draw()
    -- Draw player
    player.collider:draw(player.color)

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        enemy.collider:draw(enemy.color)
    end

    -- UI
    love.graphics.print("Use WASD to move player", 10, 10)
    love.graphics.print("Enemies turn yellow when colliding", 10, 30)
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
end
```

This documentation provides comprehensive coverage of the CollisionManager's capabilities, from basic collision detection to advanced state tracking, with practical examples for game development.