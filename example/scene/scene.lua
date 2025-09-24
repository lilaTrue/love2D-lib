-- scene.lua
-- Example scene definitions for SceneManager demonstration

local SceneManager = require("lib.SceneManager")

-- Menu Scene
local menuScene = SceneManager:createScene("menu")

function menuScene:load()
    print("Menu scene loaded")
    self.title = "GAME TITLE"
    self.options = {"Start Game", "Settings", "Quit"}
    self.selectedOption = 1
end

function menuScene:update(dt)
    -- Menu update logic
end

function menuScene:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.title, 0, 200, love.graphics.getWidth(), "center")

    for i, option in ipairs(self.options) do
        local color = (i == self.selectedOption) and {1, 1, 0} or {1, 1, 1}
        love.graphics.setColor(color)
        love.graphics.printf(option, 0, 250 + i * 30, love.graphics.getWidth(), "center")
    end

    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.printf("Use UP/DOWN to navigate, ENTER to select", 0, 400, love.graphics.getWidth(), "center")
    love.graphics.printf("Press SPACE for quick start", 0, 430, love.graphics.getWidth(), "center")
end

function menuScene:keypressed(key)
    if key == "up" then
        self.selectedOption = math.max(1, self.selectedOption - 1)
    elseif key == "down" then
        self.selectedOption = math.min(#self.options, self.selectedOption + 1)
    elseif key == "return" then
        if self.selectedOption == 1 then
            SceneManager:startTransition("fade", 0.5)
            SceneManager:setScene("game")
        elseif self.selectedOption == 2 then
            SceneManager:pushScene("settings")
        elseif self.selectedOption == 3 then
            love.event.quit()
        end
    elseif key == "space" then
        SceneManager:setScene("game")
    end
end

-- Game Scene
local gameScene = SceneManager:createScene("game")

function gameScene:load()
    print("Game scene loaded")
    self.player = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        size = 20,
        speed = 200
    }
    self.score = 0
    self.enemies = {}
    self.spawnTimer = 0
end

function gameScene:update(dt)
    -- Player movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.player.x = self.player.x - self.player.speed * dt
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.player.x = self.player.x + self.player.speed * dt
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.player.y = self.player.y - self.player.speed * dt
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.player.y = self.player.y + self.player.speed * dt
    end

    -- Keep player in bounds
    self.player.x = math.max(self.player.size, math.min(love.graphics.getWidth() - self.player.size, self.player.x))
    self.player.y = math.max(self.player.size, math.min(love.graphics.getHeight() - self.player.size, self.player.y))

    -- Spawn enemies
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > 2 then
        self.spawnTimer = 0
        table.insert(self.enemies, {
            x = love.math.random(0, love.graphics.getWidth()),
            y = -20,
            speed = 100 + love.math.random(0, 50)
        })
    end

    -- Update enemies
    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        enemy.y = enemy.y + enemy.speed * dt

        -- Check collision with player
        if math.abs(enemy.x - self.player.x) < self.player.size and
           math.abs(enemy.y - self.player.y) < self.player.size then
            SceneManager:setScene("gameOver")
            return
        end

        -- Remove off-screen enemies
        if enemy.y > love.graphics.getHeight() + 20 then
            table.remove(self.enemies, i)
            self.score = self.score + 1
        end
    end
end

function gameScene:draw()
    -- Draw player
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", self.player.x, self.player.y, self.player.size)

    -- Draw enemies
    love.graphics.setColor(1, 0, 0)
    for _, enemy in ipairs(self.enemies) do
        love.graphics.circle("fill", enemy.x, enemy.y, 15)
    end

    -- Draw UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. self.score, 10, 10)
    love.graphics.print("Press ESC for menu, P for pause", 10, 30)
end

function gameScene:keypressed(key)
    if key == "escape" then
        SceneManager:setScene("menu")
    elseif key == "p" then
        SceneManager:pushScene("pause")
    end
end

-- Pause Scene
local pauseScene = SceneManager:createScene("pause")

function pauseScene:draw()
    -- Semi-transparent overlay
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("PAUSED", 0, 250, love.graphics.getWidth(), "center")
    love.graphics.printf("Press P to resume", 0, 290, love.graphics.getWidth(), "center")
    love.graphics.printf("Press ESC for menu", 0, 320, love.graphics.getWidth(), "center")
end

function pauseScene:keypressed(key)
    if key == "p" then
        SceneManager:popScene()
    elseif key == "escape" then
        SceneManager:setScene("menu")
    end
end

-- Settings Scene
local settingsScene = SceneManager:createScene("settings")

function settingsScene:load()
    self.options = {"Volume: High", "Difficulty: Normal", "Transition Test", "Back"}
    self.selectedOption = 1
end

function settingsScene:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("SETTINGS", 0, 200, love.graphics.getWidth(), "center")

    for i, option in ipairs(self.options) do
        local color = (i == self.selectedOption) and {1, 1, 0} or {1, 1, 1}
        love.graphics.setColor(color)
        love.graphics.printf(option, 0, 250 + i * 30, love.graphics.getWidth(), "center")
    end
end

function settingsScene:keypressed(key)
    if key == "up" then
        self.selectedOption = math.max(1, self.selectedOption - 1)
    elseif key == "down" then
        self.selectedOption = math.min(#self.options, self.selectedOption + 1)
    elseif key == "return" then
        if self.selectedOption == 3 then
            SceneManager:pushScene("transitions")
        elseif self.selectedOption == 4 then
            SceneManager:popScene()
        end
    elseif key == "escape" then
        SceneManager:popScene()
    end
end

-- Transitions Test Scene
local transitionsScene = SceneManager:createScene("transitions")

function transitionsScene:load()
    self.transitions = {
        "fade",
        "slide_left",
        "slide_right",
        "slide_up",
        "slide_down",
        "zoom_in",
        "zoom_out",
        "rotate_cw",
        "rotate_ccw",
        "wipe_horizontal",
        "wipe_vertical",
        "checkerboard"
    }
    self.selectedTransition = 1
    self.testScene = "menu"  -- Scene to transition to for testing
end

function transitionsScene:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("TRANSITION TEST", 0, 50, love.graphics.getWidth(), "center")
    love.graphics.printf("Select transition type and press ENTER to test", 0, 80, love.graphics.getWidth(), "center")

    -- Draw transition list
    local startY = 120
    for i, transition in ipairs(self.transitions) do
        local color = (i == self.selectedTransition) and {1, 1, 0} or {1, 1, 1}
        love.graphics.setColor(color)
        love.graphics.printf(transition, 0, startY + i * 25, love.graphics.getWidth(), "center")
    end

    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.printf("Use UP/DOWN to select, ENTER to test, ESC to go back", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")
end

function transitionsScene:keypressed(key)
    if key == "up" then
        self.selectedTransition = math.max(1, self.selectedTransition - 1)
    elseif key == "down" then
        self.selectedTransition = math.min(#self.transitions, self.selectedTransition + 1)
    elseif key == "return" then
        -- Test the selected transition
        local transitionType = self.transitions[self.selectedTransition]
        SceneManager:startTransition(transitionType, 1.0)
        SceneManager:setScene(self.testScene)
    elseif key == "escape" then
        SceneManager:popScene()
    elseif key == "space" then
        -- Quick test with current selection
        local transitionType = self.transitions[self.selectedTransition]
        SceneManager:startTransition(transitionType, 0.5)
        SceneManager:setScene(self.testScene)
    end
end

-- Game Over Scene
local gameOverScene = SceneManager:createScene("gameOver")

function gameOverScene:load()
    self.finalScore = SceneManager:getCurrentScene().score or 0
end

function gameOverScene:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("GAME OVER", 0, 200, love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Final Score: " .. self.finalScore, 0, 250, love.graphics.getWidth(), "center")
    love.graphics.printf("Press R to restart", 0, 290, love.graphics.getWidth(), "center")
    love.graphics.printf("Press ESC for menu", 0, 320, love.graphics.getWidth(), "center")
end

function gameOverScene:keypressed(key)
    if key == "r" then
        SceneManager:setScene("game")
    elseif key == "escape" then
        SceneManager:setScene("menu")
    end
end

-- Register all scenes
SceneManager:addScene("menu", menuScene)
SceneManager:addScene("game", gameScene)
SceneManager:addScene("pause", pauseScene)
SceneManager:addScene("settings", settingsScene)
SceneManager:addScene("transitions", transitionsScene)
SceneManager:addScene("gameOver", gameOverScene)

-- Export scenes for external access if needed
return {
    menu = menuScene,
    game = gameScene,
    pause = pauseScene,
    settings = settingsScene,
    transitions = transitionsScene,
    gameOver = gameOverScene
}