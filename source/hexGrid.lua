-- 🎯 Hexagonal Grid System
-- Manages the hexagonal game board using axial coordinates

local constants = require "constants"

local HexGrid = {}
HexGrid.__index = HexGrid

-- 🔨 Create a new hexagonal grid
function HexGrid:new(radius)
    local self = setmetatable({}, HexGrid)
    
    self.radius = radius or constants.GRID_RADIUS
    self.hexes = {}  -- Table to store hex states, keyed by "q,r"
    
    -- Generate all hexagons within the radius
    self:generateGrid()
    
    return self
end

-- 🗺️ Generate all hexagons in the grid
function HexGrid:generateGrid()
    for q = -self.radius, self.radius do
        for r = -self.radius, self.radius do
            local s = -q - r
            
            -- Only include hexes within the hexagonal boundary
            if math.abs(s) <= self.radius then
                local key = self:getKey(q, r)
                self.hexes[key] = {
                    q = q,
                    r = r,
                    s = s,
                    state = false  -- Binary state: false = white, true = black
                }
            end
        end
    end
end

-- 🔑 Generate a unique key for a hex coordinate
function HexGrid:getKey(q, r)
    return q .. "," .. r
end

-- 📍 Get a hex at the given coordinates
function HexGrid:getHex(q, r)
    local key = self:getKey(q, r)
    return self.hexes[key]
end

-- 🔄 Set the state of a hex
function HexGrid:setHexState(q, r, state)
    local hex = self:getHex(q, r)
    if hex then
        hex.state = state
    end
end

-- 🔄 Flip the state of a hex
function HexGrid:flipHex(q, r)
    local hex = self:getHex(q, r)
    if hex then
        hex.state = not hex.state
        return true
    end
    return false
end

-- 🧭 Get all neighboring hexagons
function HexGrid:getNeighbors(q, r)
    local directions = {
        {1, 0},   -- Right
        {1, -1},  -- Top-right
        {0, -1},  -- Top-left
        {-1, 0},  -- Left
        {-1, 1},  -- Bottom-left
        {0, 1}    -- Bottom-right
    }
    
    local neighbors = {}
    for _, dir in ipairs(directions) do
        local neighborQ = q + dir[1]
        local neighborR = r + dir[2]
        local neighbor = self:getHex(neighborQ, neighborR)
        
        if neighbor then
            table.insert(neighbors, neighbor)
        end
    end
    
    return neighbors
end

-- 📐 Convert hex coordinates to pixel position (flat-top orientation)
function HexGrid:hexToPixel(q, r)
    local size = constants.HEX_SIZE
    
    -- Flat-top hexagon conversion
    local x = size * (3/2 * q)
    local y = size * (math.sqrt(3)/2 * q + math.sqrt(3) * r)
    
    -- Center the grid on screen
    x = x + constants.GRID_CENTER_X
    y = y + constants.GRID_CENTER_Y
    
    return x, y
end

-- 📐 Convert pixel position to hex coordinates (for input handling)
function HexGrid:pixelToHex(x, y)
    -- Adjust for grid center
    x = x - constants.GRID_CENTER_X
    y = y - constants.GRID_CENTER_Y
    
    local size = constants.HEX_SIZE
    
    -- Flat-top hexagon reverse conversion
    local q = (2/3 * x) / size
    local r = (-1/3 * x + math.sqrt(3)/3 * y) / size
    
    -- Round to nearest hex
    return self:roundHex(q, r)
end

-- 🔢 Round fractional hex coordinates to nearest hex
function HexGrid:roundHex(q, r)
    local s = -q - r
    
    local roundQ = math.floor(q + 0.5)
    local roundR = math.floor(r + 0.5)
    local roundS = math.floor(s + 0.5)
    
    local qDiff = math.abs(roundQ - q)
    local rDiff = math.abs(roundR - r)
    local sDiff = math.abs(roundS - s)
    
    -- Adjust the coordinate with the largest rounding error
    if qDiff > rDiff and qDiff > sDiff then
        roundQ = -roundR - roundS
    elseif rDiff > sDiff then
        roundR = -roundQ - roundS
    else
        roundS = -roundQ - roundR
    end
    
    return roundQ, roundR
end

-- 📏 Calculate distance between two hexagons
function HexGrid:distance(q1, r1, q2, r2)
    return (math.abs(q1 - q2) + math.abs(q1 + r1 - q2 - r2) + math.abs(r1 - r2)) / 2
end

-- 🔄 Rotate hex coordinates around origin by steps of 60 degrees
function HexGrid:rotateHex(q, r, rotationSteps)
    -- Normalize rotation to 0-5
    rotationSteps = rotationSteps % 6
    
    -- Convert to cube coordinates for easier rotation
    local s = -q - r
    
    -- Apply rotation based on steps
    for i = 1, rotationSteps do
        -- Rotate 60 degrees clockwise
        local tempQ = -r
        local tempR = -s
        local tempS = -q
        
        q = tempQ
        r = tempR
        s = tempS
    end
    
    return q, r
end

-- 🗺️ Get all hexagons in the grid
function HexGrid:getAllHexes()
    local hexList = {}
    for _, hex in pairs(self.hexes) do
        table.insert(hexList, hex)
    end
    return hexList
end

-- 🔍 Check if coordinates are valid (within grid)
function HexGrid:isValidHex(q, r)
    return self:getHex(q, r) ~= nil
end

-- 📊 Count hexagons in each state
function HexGrid:countStates()
    local blackCount = 0
    local whiteCount = 0
    
    for _, hex in pairs(self.hexes) do
        if hex.state then
            blackCount = blackCount + 1
        else
            whiteCount = whiteCount + 1
        end
    end
    
    return blackCount, whiteCount
end

-- 🎯 Check if all hexagons are in the same state
function HexGrid:isUniform()
    local firstState = nil
    
    for _, hex in pairs(self.hexes) do
        if firstState == nil then
            firstState = hex.state
        elseif hex.state ~= firstState then
            return false
        end
    end
    
    return true
end

-- 🔄 Reset all hexagons to default state
function HexGrid:reset()
    for _, hex in pairs(self.hexes) do
        hex.state = false
    end
end

return HexGrid