import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

-- Player
local playerStartX = 40
local playerStartY = 120
local playerSpeed = 3
local playerImage = gfx.image.new("images/rock")
assert(playerImage, "Failed to load player image")
local playerSprite = gfx.sprite.new(playerImage)
local playerWidth, playerHeight = playerSprite:getSize()
playerSprite:setCollideRect(4, 4, playerWidth - 8, playerHeight - 8)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- Game State
local gameState = "stopped" -- Possible states: "stopped", "active"
local score = 0

-- Obstacle
local initialObstacleSpeed = 5
local obstacleSpeed = initialObstacleSpeed
local obstacleImage = gfx.image.new("images/capybara")
assert(obstacleImage, "Failed to load obstacle image")
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, obstacleSprite:getSize())
obstacleSprite:setImageFlip(gfx.kImageFlippedX)
obstacleSprite:moveTo(450, 240)
obstacleSprite:add()

function pd.update()
    gfx.sprite.update()

    if gameState == "stopped" then
        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            score = 0
            obstacleSpeed = initialObstacleSpeed
            playerSprite:moveTo(playerStartX, playerStartY)
            obstacleSprite:moveTo(450, math.random(40, 200))
        end
    elseif gameState == "active" then
        local crankPosition = pd.getCrankPosition()
        local crankRadians = math.rad(crankPosition)
        local verticalSpeed = -math.cos(crankRadians) * playerSpeed
        playerSprite:moveBy(0, verticalSpeed)
        local obstacleX, obstacleY, collisions, collisionCount =
            obstacleSprite:moveWithCollisions(obstacleSprite.x - obstacleSpeed, obstacleSprite.y)

        -- Reset obstacle position if it goes off screen
        if obstacleSprite.x < -20 then
            obstacleSprite:moveTo(450, math.random(40, 200))
            score += 1
            obstacleSpeed += 0.2
        end

        -- Keep player within screen bounds
        if collisionCount > 0 or playerSprite.y > 270 or playerSprite.y < -30 then
            gameState = "stopped"
        end
    end

    gfx.drawTextAligned("Score: " .. score, 390, 10, kTextAlignment.right)
end