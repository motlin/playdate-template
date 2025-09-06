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

function pd.update()
    local crankPosition = pd.getCrankPosition()
    local crankRadians = math.rad(crankPosition)
    local verticalMovement = -math.cos(crankRadians) * playerSpeed
    playerSprite:moveBy(0, verticalMovement)
    gfx.sprite.update()
end