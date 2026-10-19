import("hexGrid")

local function coordinates(hexes)
    local result = {}
    for _, hex in ipairs(hexes) do
        result[#result + 1] = { hex.q, hex.r }
    end
    table.sort(result, function(a, b)
        if a[1] ~= b[1] then return a[1] < b[1] end
        return a[2] < b[2]
    end)
    return result
end

describe("HexGrid", function()
    it("generates every hex within the radius, all white", function()
        local grid = HexGrid:new(1)

        assert.are.same({
            ["-1,0"] = { q = -1, r = 0, s = 1, state = false },
            ["-1,1"] = { q = -1, r = 1, s = 0, state = false },
            ["0,-1"] = { q = 0, r = -1, s = 1, state = false },
            ["0,0"] = { q = 0, r = 0, s = 0, state = false },
            ["0,1"] = { q = 0, r = 1, s = -1, state = false },
            ["1,-1"] = { q = 1, r = -1, s = 0, state = false },
            ["1,0"] = { q = 1, r = 0, s = -1, state = false },
        }, grid.hexes)
    end)

    it("flips hexes inside the grid and ignores coordinates outside it", function()
        local grid = HexGrid:new(1)

        assert.are.same({ true, false }, { grid:flipHex(0, 0), grid:flipHex(2, 0) })
        assert.are.same({ 1, 6 }, { grid:countStates() })
        assert.is_false(grid:isUniform())

        grid:reset()

        assert.are.same({ 0, 7 }, { grid:countStates() })
        assert.is_true(grid:isUniform())
    end)

    it("returns only the neighbors that exist on the board", function()
        local grid = HexGrid:new(1)

        assert.are.same(
            { { -1, 0 }, { -1, 1 }, { 0, -1 }, { 0, 1 }, { 1, -1 }, { 1, 0 } },
            coordinates(grid:getNeighbors(0, 0))
        )
        assert.are.same({ { -1, 1 }, { 0, -1 }, { 0, 0 } }, coordinates(grid:getNeighbors(-1, 0)))
    end)

    it("round-trips hex coordinates through screen pixels", function()
        local grid = HexGrid:new(4)

        assert.are.same({ 200, 120 }, { grid:hexToPixel(0, 0) })
        assert.are.same({ 2, -1 }, { grid:pixelToHex(grid:hexToPixel(2, -1)) })
    end)

    it("rotates coordinates around the origin in 60 degree steps", function()
        local grid = HexGrid:new(1)

        assert.are.same({ 0, 1 }, { grid:rotateHex(1, 0, 1) })
        assert.are.same({ 1, 0 }, { grid:rotateHex(1, 0, 6) })
        assert.are.equal(2, grid:distance(-1, 0, 1, 0))
    end)
end)
