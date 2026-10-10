std = "lua54"
include_files = { "source/**/*.lua", "spec/**/*.lua" }
max_line_length = false
self = false

-- Playdate SDK globals.
read_globals = { "import", "kTextAlignment", "playdate" }

-- Each module publishes itself as a global for the Playdate runtime.
local modules = {
    constants = "constants",
    hexGrid = "HexGrid",
    piece = "Piece",
    renderer = "renderer",
}
for file, name in pairs(modules) do
    read_globals[#read_globals + 1] = name
    files["source/" .. file .. ".lua"] = { globals = { name } }
end

-- main.lua keeps empty input branches as placeholders for new games.
files["source/main.lua"] = {
    ignore = { "542" },
    globals = { "playdate.update", "initGame", "draw", "drawUI", "drawPauseMenu", "drawGameOver", "handleInput" },
}

files["spec"] = { std = "+busted", globals = { "playdate", "import" } }
