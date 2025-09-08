-- 🎮 Hex Flip - Main Game Loop
-- Playdate port of Hex Zero with binary flip mechanics

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

-- Playdate SDK aliases
local pd = playdate
local gfx = pd.graphics

-- Game modules
import "constants"
import "hexGrid"
import "renderer"
import "piece"
-- import "gameState"
-- import "input"

-- 🎯 Game state variables
local grid = nil
local currentPiece = nil
local score = 0
local moveCount = 0
local gameMode = "playing" -- playing, paused, gameover

-- 🖼️ Screen constants from configuration
local SCREEN_WIDTH = constants.SCREEN_WIDTH
local SCREEN_HEIGHT = constants.SCREEN_HEIGHT
local CENTER_X = constants.GRID_CENTER_X
local CENTER_Y = constants.GRID_CENTER_Y

-- 🔄 Initialize game
function initGame()
    -- Set up display
    gfx.setBackgroundColor(constants.BACKGROUND_COLOR)
    
    -- Initialize game systems
    grid = HexGrid:new(constants.GRID_RADIUS)
    currentPiece = Piece.createTestPiece()
    
    score = 0
    moveCount = 0
    gameMode = "playing"
    
    print("🎮 Hex Flip initialized")
end

-- 🎨 Draw function
function draw()
    gfx.clear()
    
    -- Draw game elements
    if gameMode == "playing" then
        -- Grid rendering
        renderer.drawGrid(grid)
        
        -- Current piece rendering
        if currentPiece then
            renderer.drawPiece(currentPiece, grid, currentPiece.centerQ, currentPiece.centerR)
        end
        
        -- UI elements
        drawUI()
    elseif gameMode == "paused" then
        drawPauseMenu()
    elseif gameMode == "gameover" then
        drawGameOver()
    end
end

-- 📊 Draw UI elements
function drawUI()
    local crankPos = pd.getCrankPosition()
    renderer.drawUI(score, moveCount, crankPos)
end

-- ⏸️ Draw pause menu
function drawPauseMenu()
    gfx.drawTextAligned("PAUSED", CENTER_X, CENTER_Y - 20, kTextAlignment.center)
    gfx.drawTextAligned("Press A to Resume", CENTER_X, CENTER_Y + 10, kTextAlignment.center)
end

-- 💀 Draw game over screen
function drawGameOver()
    gfx.drawTextAligned("GAME OVER", CENTER_X, CENTER_Y - 30, kTextAlignment.center)
    gfx.drawTextAligned("Score: " .. score, CENTER_X, CENTER_Y, kTextAlignment.center)
    gfx.drawTextAligned("Press A to Restart", CENTER_X, CENTER_Y + 30, kTextAlignment.center)
end

-- 🎮 Handle input
function handleInput()
    -- A button - place piece or menu action
    if pd.buttonJustPressed(pd.kButtonA) then
        if gameMode == "playing" then
            -- Place piece logic
            -- if currentPiece and hexGrid.canPlacePiece(grid, currentPiece) then
            --     hexGrid.placePiece(grid, currentPiece)
            --     moveCount = moveCount + 1
            --     currentPiece = piece.generateRandom()
            -- end
        elseif gameMode == "paused" then
            gameMode = "playing"
        elseif gameMode == "gameover" then
            initGame()
        end
    end
    
    -- B button - cancel/back
    if pd.buttonJustPressed(pd.kButtonB) then
        if gameMode == "playing" then
            -- Cancel current action or undo
        end
    end
    
    -- Menu button - pause
    if pd.buttonJustPressed(pd.kButtonMenu) then
        if gameMode == "playing" then
            gameMode = "paused"
        elseif gameMode == "paused" then
            gameMode = "playing"
        end
    end
    
    -- D-pad for cursor movement
    if gameMode == "playing" then
        -- Cursor movement logic
        -- if pd.buttonIsPressed(pd.kButtonUp) then
        --     input.moveCursor(0, -1)
        -- elseif pd.buttonIsPressed(pd.kButtonDown) then
        --     input.moveCursor(0, 1)
        -- elseif pd.buttonIsPressed(pd.kButtonLeft) then
        --     input.moveCursor(-1, 0)
        -- elseif pd.buttonIsPressed(pd.kButtonRight) then
        --     input.moveCursor(1, 0)
        -- end
    end
    
    -- Crank for piece rotation
    if gameMode == "playing" then
        local crankPosition = pd.getCrankPosition()
        if currentPiece then
            -- Map crank position (0-360) to rotation steps (0-5)
            local targetRotation = math.floor(crankPosition / 60) % 6
            currentPiece:setRotation(targetRotation)
        end
    end
end

-- 🔄 Main update loop
function pd.update()
    -- Handle input
    handleInput()
    
    -- Update game logic
    if gameMode == "playing" then
        -- Update animations
        -- animation.update()
        
        -- Check win/lose conditions
        -- if hexGrid.isClear(grid) then
        --     gameMode = "gameover"
        -- end
    end
    
    -- Update timers
    pd.timer.updateTimers()
    
    -- Draw everything
    draw()
    
    -- Update sprites (if using sprite system)
    gfx.sprite.update()
    
    -- FPS counter (debug)
    if pd.isSimulator then
        pd.drawFPS(SCREEN_WIDTH - 20, SCREEN_HEIGHT - 15)
    end
end

-- 🚀 Start the game
initGame()