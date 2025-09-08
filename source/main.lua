-- 🎮 Hex Flip - Main Game Loop
-- Playdate port of Hex Zero with binary flip mechanics

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

-- Playdate SDK aliases
local pd = playdate
local gfx = pd.graphics

-- Game modules (to be implemented)
-- local constants = import "constants"
-- local hexGrid = import "hexGrid"
-- local renderer = import "renderer"
-- local piece = import "piece"
-- local gameState = import "gameState"
-- local input = import "input"

-- 🎯 Game state variables
local grid = nil
local currentPiece = nil
local score = 0
local moveCount = 0
local gameMode = "playing" -- playing, paused, gameover

-- 🖼️ Screen constants
local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 240
local CENTER_X = SCREEN_WIDTH / 2
local CENTER_Y = SCREEN_HEIGHT / 2

-- 🔄 Initialize game
function initGame()
    -- Set up display
    gfx.setBackgroundColor(gfx.kColorWhite)
    
    -- Initialize game systems
    -- grid = hexGrid.new(5) -- radius 5 for testing
    -- currentPiece = piece.generateRandom()
    
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
        -- renderer.drawGrid(grid, CENTER_X, CENTER_Y)
        
        -- Current piece rendering
        -- if currentPiece then
        --     renderer.drawPiece(currentPiece, CENTER_X, CENTER_Y)
        -- end
        
        -- UI elements
        drawUI()
        
        -- Temporary placeholder text
        gfx.drawTextAligned("Hex Flip", CENTER_X, 20, kTextAlignment.center)
        gfx.drawTextAligned("Grid rendering coming soon", CENTER_X, CENTER_Y, kTextAlignment.center)
    elseif gameMode == "paused" then
        drawPauseMenu()
    elseif gameMode == "gameover" then
        drawGameOver()
    end
end

-- 📊 Draw UI elements
function drawUI()
    -- Score display
    gfx.drawText("Score: " .. score, 10, 10)
    
    -- Move counter
    gfx.drawText("Moves: " .. moveCount, 10, 25)
    
    -- Crank indicator (temporary)
    local crankPos = pd.getCrankPosition()
    gfx.drawText("Crank: " .. math.floor(crankPos) .. "°", SCREEN_WIDTH - 80, 10)
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
        local crankChange = pd.getCrankChange()
        if math.abs(crankChange) > 0 then
            -- Rotation logic
            -- local rotationSteps = math.floor(crankChange / 60)
            -- if rotationSteps ~= 0 and currentPiece then
            --     piece.rotate(currentPiece, rotationSteps)
            -- end
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