-- 🧩 Piece Module
-- Manages game pieces (polyominoes made of hexagons)

local Piece = {}
Piece.__index = Piece

-- 🔨 Create a new piece
function Piece:new(hexes, centerQ, centerR)
    local self = setmetatable({}, Piece)
    
    -- Store piece as array of relative hex coordinates from center
    self.hexes = hexes or {}
    
    -- Position of piece center on the grid
    self.centerQ = centerQ or 0
    self.centerR = centerR or 0
    
    -- Current rotation (0-5, representing 0-300 degrees in 60 degree steps)
    self.rotation = 0
    
    return self
end

-- 🎲 Generate a simple test piece (T-shape with 4 hexagons)
function Piece.createTestPiece()
    local hexes = {
        {q = 0, r = 0},   -- Center
        {q = 1, r = 0},   -- Right
        {q = -1, r = 0},  -- Left
        {q = 0, r = -1}   -- Top
    }
    return Piece:new(hexes, 0, 0)
end

-- 🎯 Create various predefined piece shapes
function Piece.createPieceByType(pieceType)
    local pieces = {
        -- T-shape (4 hexagons)
        T = {
            {q = 0, r = 0},
            {q = 1, r = 0},
            {q = -1, r = 0},
            {q = 0, r = -1}
        },
        
        -- L-shape (4 hexagons)
        L = {
            {q = 0, r = 0},
            {q = 1, r = 0},
            {q = 2, r = 0},
            {q = 0, r = 1}
        },
        
        -- Line (3 hexagons)
        I = {
            {q = -1, r = 0},
            {q = 0, r = 0},
            {q = 1, r = 0}
        },
        
        -- Y-shape (4 hexagons)
        Y = {
            {q = 0, r = 0},
            {q = -1, r = 1},
            {q = 1, r = -1},
            {q = 0, r = -1}
        },
        
        -- Cross/Plus (5 hexagons)
        PLUS = {
            {q = 0, r = 0},
            {q = 1, r = 0},
            {q = -1, r = 0},
            {q = 0, r = 1},
            {q = 0, r = -1}
        },
        
        -- Star (7 hexagons)
        STAR = {
            {q = 0, r = 0},
            {q = 1, r = 0},
            {q = -1, r = 0},
            {q = 0, r = 1},
            {q = 0, r = -1},
            {q = 1, r = -1},
            {q = -1, r = 1}
        },
        
        -- Hexagon (7 hexagons - a small hex cluster)
        HEX = {
            {q = 0, r = 0},
            {q = 1, r = 0},
            {q = 1, r = -1},
            {q = 0, r = -1},
            {q = -1, r = 0},
            {q = -1, r = 1},
            {q = 0, r = 1}
        }
    }
    
    local hexes = pieces[pieceType] or pieces.T
    return Piece:new(hexes, 0, 0)
end

-- 🎲 Generate a random piece from the available types
function Piece.generateRandom()
    local types = {"T", "L", "I", "Y", "PLUS", "STAR", "HEX"}
    local randomType = types[math.random(#types)]
    return Piece.createPieceByType(randomType)
end

-- 🔄 Rotate the piece by a number of 60-degree steps
function Piece:rotate(steps)
    -- Normalize steps to 0-5
    steps = steps or 1
    self.rotation = (self.rotation + steps) % 6
    
    -- Rotate each hex coordinate
    for _, hex in ipairs(self.hexes) do
        local q, r = hex.q, hex.r
        
        -- Apply rotation for each step
        for i = 1, steps do
            -- Rotate 60 degrees clockwise using cube coordinates
            local s = -q - r
            local newQ = -r
            local newR = -s
            
            q = newQ
            r = newR
        end
        
        hex.q = q
        hex.r = r
    end
end

-- 🔄 Set absolute rotation (0-5)
function Piece:setRotation(targetRotation)
    -- Calculate how many steps to rotate from current position
    targetRotation = targetRotation % 6
    local steps = (targetRotation - self.rotation) % 6
    
    if steps > 0 then
        self:rotate(steps)
    end
end

-- 📍 Move the piece to a new position
function Piece:moveTo(newQ, newR)
    self.centerQ = newQ
    self.centerR = newR
end

-- 📍 Move the piece by a relative amount
function Piece:moveBy(deltaQ, deltaR)
    self.centerQ = self.centerQ + deltaQ
    self.centerR = self.centerR + deltaR
end

-- 🔍 Get absolute positions of all hexagons in the piece
function Piece:getAbsolutePositions()
    local positions = {}
    
    for _, hex in ipairs(self.hexes) do
        table.insert(positions, {
            q = self.centerQ + hex.q,
            r = self.centerR + hex.r
        })
    end
    
    return positions
end

-- 🔍 Check if piece can be placed on the grid
function Piece:canPlaceOnGrid(hexGrid)
    local positions = self:getAbsolutePositions()
    
    for _, pos in ipairs(positions) do
        -- Check if position is valid on the grid
        if not hexGrid:isValidHex(pos.q, pos.r) then
            return false
        end
    end
    
    return true
end

-- 🔄 Clone the piece (useful for preview/ghost pieces)
function Piece:clone()
    local hexesCopy = {}
    for _, hex in ipairs(self.hexes) do
        table.insert(hexesCopy, {q = hex.q, r = hex.r})
    end
    
    local clone = Piece:new(hexesCopy, self.centerQ, self.centerR)
    clone.rotation = self.rotation
    return clone
end

-- 📊 Get the bounds of the piece (for display purposes)
function Piece:getBounds()
    if #self.hexes == 0 then
        return 0, 0, 0, 0
    end
    
    local minQ, maxQ = self.hexes[1].q, self.hexes[1].q
    local minR, maxR = self.hexes[1].r, self.hexes[1].r
    
    for _, hex in ipairs(self.hexes) do
        minQ = math.min(minQ, hex.q)
        maxQ = math.max(maxQ, hex.q)
        minR = math.min(minR, hex.r)
        maxR = math.max(maxR, hex.r)
    end
    
    return minQ, maxQ, minR, maxR
end

-- 📏 Get the size of the piece (width and height in hex units)
function Piece:getSize()
    local minQ, maxQ, minR, maxR = self:getBounds()
    return maxQ - minQ + 1, maxR - minR + 1
end

return Piece