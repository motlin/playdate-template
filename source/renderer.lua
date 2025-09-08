-- 🎨 Renderer Module
-- Handles all drawing operations for the hexagonal grid and game elements

local pd = playdate
local gfx = pd.graphics

local constants = import "constants"

local Renderer = {}

-- 🔶 Draw a single hexagon outline at the given pixel position
function Renderer.drawHexagon(x, y, radius, filled)
    filled = filled or false
    
    -- Calculate the 6 vertices of a flat-top hexagon
    local vertices = {}
    for i = 0, 5 do
        local angle = math.pi / 3 * i  -- 60 degrees in radians
        local vertexX = x + radius * math.cos(angle)
        local vertexY = y + radius * math.sin(angle)
        table.insert(vertices, {x = vertexX, y = vertexY})
    end
    
    -- Draw the hexagon
    if filled then
        -- Create a polygon for filled hexagon
        local polygon = gfx.polygon.new(
            vertices[1].x, vertices[1].y,
            vertices[2].x, vertices[2].y,
            vertices[3].x, vertices[3].y,
            vertices[4].x, vertices[4].y,
            vertices[5].x, vertices[5].y,
            vertices[6].x, vertices[6].y
        )
        gfx.setColor(constants.PIECE_COLOR)
        gfx.fillPolygon(polygon)
    else
        -- Draw outline using line segments
        gfx.setLineWidth(constants.HEX_LINE_WIDTH)
        gfx.setColor(constants.GRID_COLOR)
        
        for i = 1, 6 do
            local nextIndex = (i % 6) + 1
            gfx.drawLine(
                vertices[i].x, vertices[i].y,
                vertices[nextIndex].x, vertices[nextIndex].y
            )
        end
    end
end

-- 🗺️ Draw the entire hexagonal grid
function Renderer.drawGrid(hexGrid)
    -- Get all hexagons from the grid
    local hexes = hexGrid:getAllHexes()
    
    -- Draw each hexagon
    for _, hex in ipairs(hexes) do
        local x, y = hexGrid:hexToPixel(hex.q, hex.r)
        
        -- Draw filled if the hex state is true (black), otherwise just outline
        if hex.state then
            Renderer.drawHexagon(x, y, constants.HEX_SIZE, true)
        else
            Renderer.drawHexagon(x, y, constants.HEX_SIZE, false)
        end
    end
end

-- 🧩 Draw a piece at the specified grid position
function Renderer.drawPiece(piece, hexGrid, centerQ, centerR)
    if not piece or not piece.hexes then
        return
    end
    
    -- Draw each hexagon of the piece
    for _, relativeHex in ipairs(piece.hexes) do
        -- Calculate absolute position
        local absoluteQ = centerQ + relativeHex.q
        local absoluteR = centerR + relativeHex.r
        
        -- Check if this position is valid on the grid
        if hexGrid:isValidHex(absoluteQ, absoluteR) then
            local x, y = hexGrid:hexToPixel(absoluteQ, absoluteR)
            
            -- Draw piece hexagons with thicker lines and filled
            gfx.setLineWidth(constants.PIECE_LINE_WIDTH)
            Renderer.drawHexagon(x, y, constants.HEX_SIZE, true)
        end
    end
end

-- 👻 Draw a ghost preview of where a piece will be placed
function Renderer.drawGhostPiece(piece, hexGrid, centerQ, centerR)
    if not piece or not piece.hexes then
        return
    end
    
    -- Set up dithered pattern for ghost effect
    local ditherPattern = {0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55}
    gfx.setPattern(ditherPattern)
    
    -- Draw each hexagon of the piece as a ghost
    for _, relativeHex in ipairs(piece.hexes) do
        local absoluteQ = centerQ + relativeHex.q
        local absoluteR = centerR + relativeHex.r
        
        if hexGrid:isValidHex(absoluteQ, absoluteR) then
            local x, y = hexGrid:hexToPixel(absoluteQ, absoluteR)
            Renderer.drawHexagon(x, y, constants.HEX_SIZE, true)
        end
    end
    
    -- Reset pattern
    gfx.setColor(constants.PIECE_COLOR)
end

-- 🎯 Draw a cursor or selection indicator at a hex position
function Renderer.drawCursor(hexGrid, q, r)
    local x, y = hexGrid:hexToPixel(q, r)
    
    -- Draw a slightly larger hexagon outline as cursor
    gfx.setLineWidth(3)
    gfx.setColor(constants.GRID_COLOR)
    Renderer.drawHexagon(x, y, constants.HEX_SIZE + 3, false)
end

-- 🔄 Draw rotation indicator showing current piece rotation
function Renderer.drawRotationIndicator(x, y, rotationSteps)
    local radius = 30
    local angle = (rotationSteps * 60) * math.pi / 180
    
    -- Draw circle background
    gfx.setLineWidth(2)
    gfx.drawCircleAtPoint(x, y, radius)
    
    -- Draw rotation line
    local endX = x + radius * math.cos(angle - math.pi / 2)
    local endY = y + radius * math.sin(angle - math.pi / 2)
    gfx.setLineWidth(3)
    gfx.drawLine(x, y, endX, endY)
    
    -- Draw rotation step markers
    for i = 0, 5 do
        local markerAngle = (i * 60) * math.pi / 180 - math.pi / 2
        local markerX = x + (radius - 5) * math.cos(markerAngle)
        local markerY = y + (radius - 5) * math.sin(markerAngle)
        gfx.fillCircleAtPoint(markerX, markerY, 2)
    end
end

-- 📊 Draw score and game stats
function Renderer.drawUI(score, moves, crankPosition)
    -- Score
    gfx.setFont(gfx.getSystemFont())
    gfx.drawText("Score: " .. score, 10, 10)
    
    -- Moves
    gfx.drawText("Moves: " .. moves, 10, 30)
    
    -- Crank position
    if crankPosition then
        local crankText = string.format("Crank: %d°", math.floor(crankPosition))
        gfx.drawText(crankText, constants.SCREEN_WIDTH - 80, 10)
        
        -- Draw rotation indicator in top right
        Renderer.drawRotationIndicator(
            constants.SCREEN_WIDTH - 40,
            40,
            math.floor(crankPosition / 60)
        )
    end
end

-- 🎉 Draw victory animation elements
function Renderer.drawVictoryEffect(progress)
    -- Progress is 0.0 to 1.0
    local alpha = math.floor(255 * (1 - progress))
    
    -- Create expanding circle effect
    local radius = constants.SCREEN_WIDTH * progress
    gfx.setLineWidth(2)
    gfx.setDitherPattern(progress, gfx.image.kDitherTypeBayer8x8)
    gfx.drawCircleAtPoint(
        constants.GRID_CENTER_X,
        constants.GRID_CENTER_Y,
        radius
    )
    
    -- Victory text
    if progress > 0.5 then
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextAligned(
            "VICTORY!",
            constants.GRID_CENTER_X,
            constants.GRID_CENTER_Y - 20,
            kTextAlignment.center
        )
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
end

return Renderer