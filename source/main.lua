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
local width, height = playerSprite:getSize()
playerSprite:setCollideRect(4, 4, width - 8, height - 8)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- Game State
local gameState = "stopped" -- Possible states: "stopped", "active"

function pd.update()
    gfx.sprite.update()
    if gameState == "stopped" then
        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            playerSprite:moveTo(playerStartX, playerStartY)
        end
    elseif gameState == "active" then
        local crankPosition = pd.getCrankPosition()
        local crankRadians = math.rad(crankPosition)
        local verticalSpeed = -math.cos(crankRadians) * playerSpeed
        playerSprite:moveBy(0, verticalSpeed)
    end

    -- Keep player within screen bounds
    if playerSprite.y > 270 or playerSprite.y < -30 then
        gameState = "stopped"
    end

end