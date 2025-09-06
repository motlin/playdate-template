local pd = playdate
local gfx = pd.graphics

-- Player
local playerX = 40
local playerY = 120
local playerSpeed = 3
local playerImage = gfx.image.new("images/rock")

function pd.update()
    gfx.clear()
    local crankPosition = pd.getCrankPosition()
    local crankRadians = math.rad(crankPosition)
    local verticalMovement = -math.cos(crankRadians) * playerSpeed
    playerY += verticalMovement
    playerImage:draw(playerX, playerY)
end